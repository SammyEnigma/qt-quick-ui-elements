#ifndef QQUICKWINDOWICONHELPER_H
#define QQUICKWINDOWICONHELPER_H

#include <QQuickItem>
#include <QQmlParserStatus>

class QQuickWindowIconHelper : public QQuickItem {
    Q_OBJECT
    Q_PROPERTY (QString iconPath READ getIconPath WRITE setIconPath NOTIFY iconPathChanged)

public:
    explicit QQuickWindowIconHelper (QQuickItem * parent = Q_NULLPTR);

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
