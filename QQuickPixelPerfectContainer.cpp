
#include "QQuickPixelPerfectContainer.h"

QQuickPixelPerfectContainer::QQuickPixelPerfectContainer (QQuickItem * parent)
    : QQuickItem    (parent)
    , m_contentItem (Q_NULLPTR)
{ }

QQuickItem * QQuickPixelPerfectContainer::getContentItem (void) const {
    return m_contentItem;
}

void QQuickPixelPerfectContainer::setContentItem (QQuickItem * contentItem) {
    if (m_contentItem != contentItem) {
        m_contentItem = contentItem;
        emit contentItemChanged (contentItem);
    }
}

void QQuickPixelPerfectContainer::classBegin (void) { }

void QQuickPixelPerfectContainer::componentComplete (void) {
    QQuickItem * tmp = this;
    while (tmp != Q_NULLPTR) {
        m_ancestors.append (tmp);
        connect (tmp, &QQuickItem::xChanged, this, &QQuickPixelPerfectContainer::polish, Qt::UniqueConnection);
        connect (tmp, &QQuickItem::yChanged, this, &QQuickPixelPerfectContainer::polish, Qt::UniqueConnection);
        tmp = tmp->parentItem ();
    }
    polish ();
}

void QQuickPixelPerfectContainer::updatePolish (void) {
    if (m_contentItem != Q_NULLPTR) {
        QPointF absPos;
        for (QVector<QQuickItem *>::const_iterator it = m_ancestors.constBegin (); it != m_ancestors.constEnd (); it++) {
            absPos += (*it)->position ();
        }
        m_contentItem->setPosition (absPos.toPoint () - absPos);
    }
}
