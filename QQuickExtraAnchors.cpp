
#include "QQuickExtraAnchors.h"

#include <QQmlProperty>
#include <QStringBuilder>

QQuickExtraAnchors::QQuickExtraAnchors (QObject * parent)
    : QObject (parent)
    , m_item (qobject_cast<QQuickItem *> (parent))
    , m_dockTop (Q_NULLPTR)
    , m_dockLeft (Q_NULLPTR)
    , m_dockRight (Q_NULLPTR)
    , m_dockBottom (Q_NULLPTR)
    , m_verticalFill (Q_NULLPTR)
    , m_horizontalFill (Q_NULLPTR)
    , m_topLeftCorner (Q_NULLPTR)
    , m_topRightCorner (Q_NULLPTR)
    , m_bottomLeftCorner (Q_NULLPTR)
    , m_bottomRightCorner (Q_NULLPTR)
{ }

QQuickExtraAnchors * QQuickExtraAnchors::qmlAttachedProperties (QObject * object) {
    return new QQuickExtraAnchors (object);
}

void QQuickExtraAnchors::defineAnchorLine (QQuickItem * otherItem, const QString & lineName) {
    static const QString ANCHORS = QStringLiteral ("anchors.");
    if (m_item != Q_NULLPTR) {
        QQmlProperty prop (m_item, ANCHORS % lineName);
        prop.write (otherItem != Q_NULLPTR ? QQmlProperty (otherItem, lineName).read () : QVariant ());
    }
}

/**************************** GETTERS ******************************/

QQuickItem * QQuickExtraAnchors::getTopDock (void) const {
    return m_dockTop;
}

QQuickItem * QQuickExtraAnchors::getLeftDock (void) const {
    return m_dockLeft;
}

QQuickItem * QQuickExtraAnchors::getRightDock (void) const {
    return m_dockRight;
}

QQuickItem * QQuickExtraAnchors::getBottomDock (void) const {
    return m_dockBottom;
}

QQuickItem * QQuickExtraAnchors::getVerticalFill (void) const {
    return m_verticalFill;
}

QQuickItem * QQuickExtraAnchors::getHorizontalFill (void) const {
    return m_horizontalFill;
}

QQuickItem * QQuickExtraAnchors::getTopLeftCorner (void) const {
    return m_topLeftCorner;
}

QQuickItem * QQuickExtraAnchors::getTopRightCorner (void) const {
    return m_topRightCorner;
}

QQuickItem * QQuickExtraAnchors::getBottomLeftCorner (void) const {
    return m_bottomLeftCorner;
}

QQuickItem * QQuickExtraAnchors::getBottomRightCorner (void) const {
    return m_bottomRightCorner;
}

/**************************** SETTERS ******************************/

void QQuickExtraAnchors::setTopDock (QQuickItem * dockTop) {
    if (m_dockTop != dockTop) {
        m_dockTop = dockTop;
        defineAnchorLine (m_dockTop, "top");
        defineAnchorLine (m_dockTop, "left");
        defineAnchorLine (m_dockTop, "right");
        emit topDockChanged (m_dockTop);
    }
}

void QQuickExtraAnchors::setLeftDock (QQuickItem * dockLeft) {
    if (m_dockLeft != dockLeft) {
        m_dockLeft = dockLeft;
        defineAnchorLine (m_dockLeft, "top");
        defineAnchorLine (m_dockLeft, "left");
        defineAnchorLine (m_dockLeft, "bottom");
        emit leftDockChanged (m_dockLeft);
    }
}

void QQuickExtraAnchors::setRightDock (QQuickItem * dockRight) {
    if (m_dockRight != dockRight) {
        m_dockRight = dockRight;
        defineAnchorLine (m_dockRight, "top");
        defineAnchorLine (m_dockRight, "right");
        defineAnchorLine (m_dockRight, "bottom");
        emit rightDockChanged (m_dockRight);
    }
}

void QQuickExtraAnchors::setBottomDock (QQuickItem * dockBottom) {
    if (m_dockBottom != dockBottom) {
        m_dockBottom = dockBottom;
        defineAnchorLine (m_dockBottom, "left");
        defineAnchorLine (m_dockBottom, "right");
        defineAnchorLine (m_dockBottom, "bottom");
        emit bottomDockChanged (m_dockBottom);
    }
}

void QQuickExtraAnchors::setVerticalFill (QQuickItem * verticalFill) {
    if (m_verticalFill != verticalFill) {
        m_verticalFill = verticalFill;
        defineAnchorLine (m_verticalFill, "top");
        defineAnchorLine (m_verticalFill, "bottom");
        emit verticalFillChanged (m_verticalFill);
    }
}

void QQuickExtraAnchors::setHorizontalFill (QQuickItem * horizontalFill) {
    if (m_horizontalFill != horizontalFill) {
        m_horizontalFill = horizontalFill;
        defineAnchorLine (m_horizontalFill, "left");
        defineAnchorLine (m_horizontalFill, "right");
        emit horizontalFillChanged (m_horizontalFill);
    }
}

void QQuickExtraAnchors::setTopLeftCorner (QQuickItem * topLeftCorner) {
    if (m_topLeftCorner != topLeftCorner) {
        m_topLeftCorner = topLeftCorner;
        defineAnchorLine (m_topLeftCorner, "top");
        defineAnchorLine (m_topLeftCorner, "left");
        emit topLeftCornerChanged (m_topLeftCorner);
    }
}

void QQuickExtraAnchors::setTopRightCorner (QQuickItem * topRightCorner) {
    if (m_topRightCorner != topRightCorner) {
        m_topRightCorner = topRightCorner;
        defineAnchorLine (m_topRightCorner, "top");
        defineAnchorLine (m_topRightCorner, "right");
        emit topRightCornerChanged (m_topRightCorner);
    }
}

void QQuickExtraAnchors::setBottomLeftCorner (QQuickItem * bottomLeftCorner) {
    if (m_bottomLeftCorner != bottomLeftCorner) {
        m_bottomLeftCorner = bottomLeftCorner;
        defineAnchorLine (m_bottomLeftCorner, "left");
        defineAnchorLine (m_bottomLeftCorner, "bottom");
        emit bottomLeftCornerChanged (m_bottomLeftCorner);
    }
}

void QQuickExtraAnchors::setBottomRightCorner(QQuickItem * bottomRightCorner) {
    if (m_bottomRightCorner != bottomRightCorner) {
        m_bottomRightCorner = bottomRightCorner;
        defineAnchorLine (m_bottomRightCorner, "right");
        defineAnchorLine (m_bottomRightCorner, "bottom");
        emit bottomRightCornerChanged (m_bottomRightCorner);
    }
}
