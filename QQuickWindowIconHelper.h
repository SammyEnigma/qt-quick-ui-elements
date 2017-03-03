#ifndef QQUICKWINDOWICONHELPER_H
#define QQUICKWINDOWICONHELPER_H

#include <QObject>
#include <QQmlParserStatus>

class QQuickWindowIconHelper : public QObject, public QQmlParserStatus {
    Q_OBJECT
    Q_INTERFACES (QQmlParserStatus)
    Q_PROPERTY (QString iconPath READ getIconPath WRITE setIconPath NOTIFY iconPathChanged)

public:
    explicit QQuickWindowIconHelper (QObject * parent = Q_NULLPTR);

    void classBegin        (void) Q_DECL_FINAL;
    void componentComplete (void) Q_DECL_FINAL;

    const QString & getIconPath (void) const;

public slots:
    void setIconPath (const QString & iconPath);

signals:
    void iconPathChanged(QString iconPath);

protected:
    void refreshWindowIcon (void);

private:
    QString m_iconPath;
};

#endif // QQUICKWINDOWICONHELPER_H
