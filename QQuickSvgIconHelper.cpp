
#include "QQuickSvgIconHelper.h"

#include <QUrl>
#include <QDir>
#include <QFile>
#include <QImage>
#include <QDebug>
#include <QPainter>
#include <QDirIterator>
#include <QStringBuilder>
#include <QCoreApplication>
#include <QRegularExpression>
#include <QStandardPaths>

QQuickSvgIconHelper::QQuickSvgIconHelper (QObject * parent)
    : QObject           (parent)
    , m_size            (0)
    , m_ready           (false)
    , m_verticalRatio   (1.0)
    , m_horizontalRatio (1.0)
    , m_color           (Qt::transparent)
    , m_icon            (QString ())
    , m_inhibitTimer    (this)
{
    m_inhibitTimer.setInterval (50);
    m_inhibitTimer.setSingleShot (true);
    connect (&m_inhibitTimer, &QTimer::timeout, this, &QQuickSvgIconHelper::refresh, Qt::UniqueConnection);
}

QQuickSvgIconHelper::MetaDataCache & QQuickSvgIconHelper::cache (void) {
    static MetaDataCache ret;
    return ret;
}

void QQuickSvgIconHelper::classBegin (void) {
    m_ready = false;
}

void QQuickSvgIconHelper::componentComplete (void) {
    m_ready = true;
    restartTimer ();
}

void QQuickSvgIconHelper::setTarget (const QQmlProperty & target) {
    m_property = target;
    restartTimer ();
}

void QQuickSvgIconHelper::setBasePath (const QString & basePath) {
    cache ().changeBasePath (basePath);
}

void QQuickSvgIconHelper::setCachePath (const QString & cachePath) {
    cache ().changeCachePath (cachePath);
}

int QQuickSvgIconHelper::getSize (void) const {
    return m_size;
}

qreal QQuickSvgIconHelper::getVerticalRatio (void) const {
    return m_verticalRatio;
}

qreal QQuickSvgIconHelper::getHorizontalRatio (void) const {
    return m_horizontalRatio;
}

const QColor & QQuickSvgIconHelper::getColor (void) const {
    return m_color;
}

const QString & QQuickSvgIconHelper::getIcon (void) const {
    return m_icon;
}

void QQuickSvgIconHelper::setSize (const int size) {
    if (m_size != size) {
        m_size = size;
        restartTimer ();
        emit sizeChanged ();
    }
}

void QQuickSvgIconHelper::setVerticalRatio (const qreal ratio) {
    if (m_verticalRatio != ratio) {
        m_verticalRatio = ratio;
        restartTimer ();
        emit verticalRatioChanged ();
    }
}

void QQuickSvgIconHelper::setHorizontalRatio (const qreal ratio) {
    if (m_horizontalRatio != ratio) {
        m_horizontalRatio = ratio;
        restartTimer ();
        emit horizontalRatioChanged ();
    }
}

void QQuickSvgIconHelper::setColor (const QColor & color) {
    if (m_color != color) {
        m_color = color;
        restartTimer ();
        emit colorChanged ();
    }
}

void QQuickSvgIconHelper::setIcon (const QString & icon) {
    if (m_icon != icon) {
        m_icon = icon;
        restartTimer ();
        emit iconChanged ();
    }
}

void QQuickSvgIconHelper::refresh (void) {
    if (m_ready) {
        QUrl url;
        if (!m_icon.isEmpty () && m_size > 0 && m_horizontalRatio > 0.0 && m_verticalRatio > 0.0) {
            const QSize imgSize (int (m_size * m_horizontalRatio),
                                 int (m_size * m_verticalRatio));
            const QString sourcePath (m_icon.startsWith ("file://")
                                      ? QUrl (m_icon).toLocalFile ()
                                      : (m_icon.startsWith ("qrc:/")
                                         ? QString (m_icon).replace (QRegularExpression ("qrc:/+"), ":/")
                                         : cache ().baseFile (m_icon % ".svg")));
            if (QFile::exists (sourcePath)) {
                const QString hash (cache ().hashData (sourcePath.toLatin1 ()));
                const QString cachedPath = cache ().cacheFile (hash
                                                               % "_" % QString::number (imgSize.width ())
                                                               % "x" % QString::number (imgSize.height ())
                                                               % (m_color.alpha () > 0 ? m_color.name () : "")
                                                               % ".png");
                if (!cache ().hasHashInIndex (hash)) {
                    const QString checkumPath = cache ().cacheFile (hash % ".md5");
                    const QString reference = cache ().readChecksumFile (checkumPath);
                    const QString checksum  = cache ().hashFile (sourcePath);
                    if (reference != checksum) {
                        QDirIterator it (cache ().cacheFile (),
                                         QStringList (hash % "*.png"),
                                         QDir::Filters (QDir::Files | QDir::NoDotAndDotDot),
                                         QDirIterator::IteratorFlags (QDirIterator::NoIteratorFlags));
                        while (it.hasNext ()) {
                            QFile::remove (it.next ());
                        }
                        cache ().writeChecksumFile (checkumPath, checksum);
                    }
                    cache ().addHashInIndex (hash, checksum);
                }
                if (!QFile::exists (cachedPath)) {
                    cache ().renderSvgToPng (sourcePath, cachedPath, imgSize, m_color);
                }
                if (QFile::exists (cachedPath)) {
                    url = QUrl::fromLocalFile (cachedPath);
                }
            }
            else {
                qWarning () << ">>> QmlSvgIconHelper : Can't render" << sourcePath << ", no such file !";
            }
        }
        if (m_property.isValid () && m_property.isWritable ()) {
            m_property.write (url);
        }
    }
}

void QQuickSvgIconHelper::restartTimer (void) {
    m_inhibitTimer.stop ();
    m_inhibitTimer.start ();
}

QQuickSvgIconHelper::MetaDataCache::MetaDataCache (void) : hasher (QCryptographicHash::Md5) {
    changeBasePath  (qApp->applicationDirPath ());
    changeCachePath (QStandardPaths::writableLocation (QStandardPaths::CacheLocation) % "/SvgIconsCache");
}

void QQuickSvgIconHelper::MetaDataCache::changeBasePath (const QString & path) {
    basePath = path;
}

void QQuickSvgIconHelper::MetaDataCache::changeCachePath (const QString & path) {
    cachePath = path;
    QDir ().mkpath (cachePath);
}

QString QQuickSvgIconHelper::MetaDataCache::baseFile (const QString & name) {
    return (basePath % "/" % name);
}

QString QQuickSvgIconHelper::MetaDataCache::cacheFile (const QString & name) {
    return (cachePath % "/" % name);
}

bool QQuickSvgIconHelper::MetaDataCache::renderSvgToPng (const QString & svgPath,
                                                         const QString & pngPath,
                                                         const QSize   & size,
                                                         const QColor  & colorize) {
    bool ret = false;
    QImage image (size.width (), size.height (), QImage::Format_ARGB32);
    QPainter painter (&image);
    image.fill (Qt::transparent);
    painter.setRenderHint (QPainter::Antialiasing,            true);
    painter.setRenderHint (QPainter::SmoothPixmapTransform,   true);
    painter.setRenderHint (QPainter::HighQualityAntialiasing, true);
    renderer.load (svgPath);
    if (renderer.isValid ()) {
        renderer.render (&painter);
        if (colorize.isValid () && colorize.alpha () > 0) {
            QColor tmp (colorize);
            for (int x (0); x < image.width (); x++) {
                for (int y (0); y < image.height (); y++) {
                    tmp.setAlpha (qAlpha (image.pixel (x, y)));
                    image.setPixel (x, y, tmp.rgba ());
                }
            }
        }
        ret = image.save (pngPath, "PNG", 0);
    }
    return ret;
}

QString QQuickSvgIconHelper::MetaDataCache::readChecksumFile (const QString & filePath) {
    QString ret;
    QFile file (filePath);
    if (file.open (QFile::ReadOnly)) {
        ret = QString::fromLatin1 (file.readAll ());
        file.close ();
    }
    return ret;
}

void QQuickSvgIconHelper::MetaDataCache::writeChecksumFile (const QString & filePath, const QString & checksum) {
    QFile file (filePath);
    if (file.open (QFile::WriteOnly)) {
        file.write (checksum.toLatin1 ());
        file.flush ();
        file.close ();
    }
}

QString QQuickSvgIconHelper::MetaDataCache::hashFile (const QString & filePath) {
    QString ret;
    QFile file (filePath);
    if (file.open (QFile::ReadOnly)) {
        hasher.reset ();
        hasher.addData (&file);
        ret = hasher.result ().toHex ();
        hasher.reset ();
        file.close ();
    }
    return ret;
}

QString QQuickSvgIconHelper::MetaDataCache::hashData (const QByteArray & data) {
    QString ret;
    if (!data.isEmpty ()) {
        hasher.reset ();
        hasher.addData (data);
        ret = hasher.result ().toHex ();
        hasher.reset ();
    }
    return ret;
}

bool QQuickSvgIconHelper::MetaDataCache::hasHashInIndex (const QString & hash) {
    return index.contains (hash);
}

void QQuickSvgIconHelper::MetaDataCache::addHashInIndex (const QString & hash, const QString & checksum) {
    index.insert (hash, checksum);
}
