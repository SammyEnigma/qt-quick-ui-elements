#ifndef QQUICKSTRETCHROWCONTAINER_H
#define QQUICKSTRETCHROWCONTAINER_H

#include <QObject>
#include <QQuickItem>

class QQuickStretchRowContainer : public QQuickItem {
    Q_OBJECT
    Q_PROPERTY (qreal spacing READ getSpacing WRITE setSpacing NOTIFY spacingChanged)

public:
    explicit QQuickStretchRowContainer (QQuickItem * parent = Q_NULLPTR);

    qreal getSpacing (void) const;

public slots:
    void setSpacing (qreal spacing);

signals:
    void spacingChanged (qreal spacing);

protected:
    void classBegin        (void);
    void componentComplete (void);
    void updatePolish      (void);
    void itemChange        (ItemChange change, const ItemChangeData & value);

private:
    qreal m_spacing;
};

#endif // QQUICKSTRETCHROWCONTAINER_H
