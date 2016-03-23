#ifndef QQMLSVGICONHELPER_H
#define QQMLSVGICONHELPER_H

#include <QObject>
#include <QString>
#include <QColor>
#include <QTimer>
#include <QSvgRenderer>
#include <QQmlProperty>
#include <QQmlParserStatus>
#include <QQmlPropertyValueSource>
#include <QCryptographicHash>

class QQuickSvgIconHelper : public QObject, public QQmlParserStatus, public QQmlPropertyValueSource {
    Q_OBJECT
    Q_INTERFACES (QQmlParserStatus)
    Q_INTERFACES (QQmlPropertyValueSource)
    Q_PROPERTY (int     size            READ getSize            WRITE setSize            NOTIFY sizeChanged)
    Q_PROPERTY (qreal   verticalRatio   READ getVerticalRatio   WRITE setVerticalRatio   NOTIFY verticalRatioChanged)
    Q_PROPERTY (qreal   horizontalRatio READ getHorizontalRatio WRITE setHorizontalRatio NOTIFY horizontalRatioChanged)
    Q_PROPERTY (QColor  color           READ getColor           WRITE setColor           NOTIFY colorChanged)
    Q_PROPERTY (QString icon            READ getIcon            WRITE setIcon            NOTIFY iconChanged)

public:
    explicit QQuickSvgIconHelper (QObject * parent = Q_NULLPTR);

    void classBegin        (void);
    void componentComplete (void);

    void setTarget (const QQmlProperty & target);

    static void setBasePath  (const QString & basePath);
    static void setCachePath (const QString & cachePath);

    int             getSize             (void) const;
    qreal           getVerticalRatio    (void) const;
    qreal           getHorizontalRatio  (void) const;
    const QColor  & getColor            (void) const;
    const QString & getIcon             (void) const;

public slots:
    void setSize            (const int size);
    void setVerticalRatio   (const qreal ratio);
    void setHorizontalRatio (const qreal ratio);
    void setColor           (const QColor & color);
    void setIcon            (const QString & icon);

signals:
    void sizeChanged            (void);
    void verticalRatioChanged   (void);
    void horizontalRatioChanged (void);
    void colorChanged           (void);
    void iconChanged            (void);

protected:
    void refresh      (void);
    void restartTimer (void);

private:
    int          m_size;
    bool         m_ready;
    qreal        m_verticalRatio;
    qreal        m_horizontalRatio;
    QColor       m_color;
    QString      m_icon;
    QTimer       m_inhibitTimer;
    QQmlProperty m_property;

    class MetaDataCache {
    public:
        explicit MetaDataCache (void);

        void changeBasePath  (const QString & path);
        void changeCachePath (const QString & path);

        QString baseFile  (const QString & name = "");
        QString cacheFile (const QString & name = "");

        QString hashFile (const QString    & filePath);
        QString hashData (const QByteArray & data);

        QString readChecksumFile (const QString & filePath);
        void writeChecksumFile (const QString & filePath, const QString & checksum);

        bool renderSvgToPng (const QString & svgPath, const QString & pngPath, const QSize & size, const QColor & colorize);

    private:
        QString            basePath;
        QString            cachePath;
        QSvgRenderer       renderer;
        QCryptographicHash hasher;
    };

    static MetaDataCache & cache (void);
};

#endif // QQMLSVGICONHELPER_H
