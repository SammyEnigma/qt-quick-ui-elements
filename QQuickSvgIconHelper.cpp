
#include "QQuickSvgIconHelper.h"

#include <QUrl>
#include <QDir>
#include <QFile>
#include <QImage>
#include <QDebug>
#include <QPainter>
#include <QStringBuilder>
#include <QCoreApplication>
#include <QCryptographicHash>
#include <QRegularExpression>

QString      QQuickSvgIconHelper::s_basePath;
QString      QQuickSvgIconHelper::s_cachePath;
QSvgRenderer QQuickSvgIconHelper::s_renderer;

QQuickSvgIconHelper::QQuickSvgIconHelper (QObject * parent)
    : QObject           (parent)
    , m_size            (0)
    , m_ready           (false)
    , m_verticalRatio   (1.0)
    , m_horizontalRatio (1.0)
    , m_color           (Qt::transparent)
    , m_icon            (QString ())
{
    if (s_basePath.isEmpty ()) {
        QQuickSvgIconHelper::s_basePath = qApp->applicationDirPath ();
    }
    if (s_cachePath.isEmpty ()) {
         QQuickSvgIconHelper::s_cachePath = (QDir::homePath () % "/.CachedSvgIcon/" % qApp->applicationName ());
    }
}

void QQuickSvgIconHelper::classBegin (void) {
    m_ready = false;
}

void QQuickSvgIconHelper::componentComplete (void) {
    m_ready = true;
    refresh ();
}

void QQuickSvgIconHelper::setTarget (const QQmlProperty & target) {
    m_property = target;
    refresh ();
}

void QQuickSvgIconHelper::setBasePath (const QString & basePath) {
    QQuickSvgIconHelper::s_basePath = basePath;
}

void QQuickSvgIconHelper::setCachePath (const QString & cachePath) {
    QQuickSvgIconHelper::s_cachePath = cachePath;
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
        refresh ();
        emit sizeChanged ();
    }
}

void QQuickSvgIconHelper::setVerticalRatio (const qreal ratio) {
    if (m_verticalRatio != ratio) {
        m_verticalRatio = ratio;
        refresh ();
        emit verticalRatioChanged ();
    }
}

void QQuickSvgIconHelper::setHorizontalRatio (const qreal ratio) {
    if (m_horizontalRatio != ratio) {
        m_horizontalRatio = ratio;
        refresh ();
        emit horizontalRatioChanged ();
    }
}

void QQuickSvgIconHelper::setColor (const QColor & color) {
    if (m_color != color) {
        m_color = color;
        refresh ();
        emit colorChanged ();
    }
}

void QQuickSvgIconHelper::setIcon (const QString & icon) {
    if (m_icon != icon) {
        m_icon = icon;
        refresh ();
        emit iconChanged ();
    }
}

void QQuickSvgIconHelper::refresh (void) {
    if (m_ready) {
        QUrl url;
        if (!m_icon.isEmpty () && m_size > 0 && m_horizontalRatio > 0.0 && m_verticalRatio > 0.0) {
            QImage image (m_size * m_horizontalRatio, m_size * m_verticalRatio, QImage::Format_ARGB32);
            const QString uri (m_icon
                         % "?color="  % (m_color.isValid () ? m_color.name () : "none")
                         % "&width="  % QString::number (image.width  ())
                         % "&height=" % QString::number (image.height ()));
            const QString hash (QCryptographicHash::hash (uri.toLocal8Bit (), QCryptographicHash::Md5).toHex ());
            const QString sourcePath (m_icon.startsWith ("file://")
                                ? QUrl (m_icon).toLocalFile ()
                                : (m_icon.startsWith ("qrc:/")
                                   ? QString (m_icon).replace (QRegularExpression ("qrc:/+"), ":/")
                                   : QString (s_basePath  % "/" % m_icon % ".svg")));
            const QString cachedPath (s_cachePath % "/" % hash   % ".png");
            if (!QFile::exists (cachedPath)) {
                QPainter painter (&image);
                image.fill (Qt::transparent);
                painter.setRenderHint (QPainter::Antialiasing,            true);
                painter.setRenderHint (QPainter::SmoothPixmapTransform,   true);
                painter.setRenderHint (QPainter::HighQualityAntialiasing, true);
                if (QFile::exists (sourcePath)) {
                    s_renderer.load (sourcePath);
                    if (s_renderer.isValid ()) {
                        s_renderer.render (&painter);
                        if (m_color.isValid () && m_color.alpha () > 0) {
                            QColor tmp (m_color);
                            for (int x (0); x < image.width (); x++) {
                                for (int y (0); y < image.height (); y++) {
                                    tmp.setAlpha (qAlpha (image.pixel (x, y)));
                                    image.setPixel (x, y, tmp.rgba ());
                                }
                            }
                        }
                        QDir ().mkpath (s_cachePath);
                        image.save (cachedPath, "PNG", 0);
                        url = QUrl::fromLocalFile (cachedPath);
                    }
                }
                else {
                    qWarning () << ">>> QmlSvgIconHelper : Can't render" << sourcePath << ", no such file !";
                }
            }
            else {
                url = QUrl::fromLocalFile (cachedPath);
            }
        }
        if (m_property.isValid () && m_property.isWritable ()) {
            m_property.write (url);
        }
    }
}
