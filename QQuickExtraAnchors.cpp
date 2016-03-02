
#include "QQuickExtraAnchors.h"

#include <QQmlProperty>

const QString QQuickExtraAnchors::TOP     = QStringLiteral ("top");
const QString QQuickExtraAnchors::LEFT    = QStringLiteral ("left");
const QString QQuickExtraAnchors::RIGHT   = QStringLiteral ("right");
const QString QQuickExtraAnchors::BOTTOM  = QStringLiteral ("bottom");
const QString QQuickExtraAnchors::ANCHORS = QStringLiteral ("anchors");

QQuickExtraAnchors::QQuickExtraAnchors (QObject * parent)
    : QObject (parent)
    , m_anchors (parent != Q_NULLPTR ? QQmlProperty (parent, ANCHORS).read ().value<QObject *> () : Q_NULLPTR)
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
    static const QVariant UNDEFINED = QVariant ();
    if (m_anchors != Q_NULLPTR) {
        QQmlProperty (m_anchors, lineName).write (otherItem != Q_NULLPTR ? QQmlProperty (otherItem, lineName).read () : UNDEFINED);
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
        defineAnchorLine (m_dockTop, TOP);
        defineAnchorLine (m_dockTop, LEFT);
        defineAnchorLine (m_dockTop, RIGHT);
        emit topDockChanged (m_dockTop);
    }
}

void QQuickExtraAnchors::setLeftDock (QQuickItem * dockLeft) {
    if (m_dockLeft != dockLeft) {
        m_dockLeft = dockLeft;
        defineAnchorLine (m_dockLeft, TOP);
        defineAnchorLine (m_dockLeft, LEFT);
        defineAnchorLine (m_dockLeft, BOTTOM);
        emit leftDockChanged (m_dockLeft);
    }
}

void QQuickExtraAnchors::setRightDock (QQuickItem * dockRight) {
    if (m_dockRight != dockRight) {
        m_dockRight = dockRight;
        defineAnchorLine (m_dockRight, TOP);
        defineAnchorLine (m_dockRight, RIGHT);
        defineAnchorLine (m_dockRight, BOTTOM);
        emit rightDockChanged (m_dockRight);
    }
}

void QQuickExtraAnchors::setBottomDock (QQuickItem * dockBottom) {
    if (m_dockBottom != dockBottom) {
        m_dockBottom = dockBottom;
        defineAnchorLine (m_dockBottom, LEFT);
        defineAnchorLine (m_dockBottom, RIGHT);
        defineAnchorLine (m_dockBottom, BOTTOM);
        emit bottomDockChanged (m_dockBottom);
    }
}

void QQuickExtraAnchors::setVerticalFill (QQuickItem * verticalFill) {
    if (m_verticalFill != verticalFill) {
        m_verticalFill = verticalFill;
        defineAnchorLine (m_verticalFill, TOP);
        defineAnchorLine (m_verticalFill, BOTTOM);
        emit verticalFillChanged (m_verticalFill);
    }
}

void QQuickExtraAnchors::setHorizontalFill (QQuickItem * horizontalFill) {
    if (m_horizontalFill != horizontalFill) {
        m_horizontalFill = horizontalFill;
        defineAnchorLine (m_horizontalFill, LEFT);
        defineAnchorLine (m_horizontalFill, RIGHT);
        emit horizontalFillChanged (m_horizontalFill);
    }
}

void QQuickExtraAnchors::setTopLeftCorner (QQuickItem * topLeftCorner) {
    if (m_topLeftCorner != topLeftCorner) {
        m_topLeftCorner = topLeftCorner;
        defineAnchorLine (m_topLeftCorner, TOP);
        defineAnchorLine (m_topLeftCorner, LEFT);
        emit topLeftCornerChanged (m_topLeftCorner);
    }
}

void QQuickExtraAnchors::setTopRightCorner (QQuickItem * topRightCorner) {
    if (m_topRightCorner != topRightCorner) {
        m_topRightCorner = topRightCorner;
        defineAnchorLine (m_topRightCorner, TOP);
        defineAnchorLine (m_topRightCorner, RIGHT);
        emit topRightCornerChanged (m_topRightCorner);
    }
}

void QQuickExtraAnchors::setBottomLeftCorner (QQuickItem * bottomLeftCorner) {
    if (m_bottomLeftCorner != bottomLeftCorner) {
        m_bottomLeftCorner = bottomLeftCorner;
        defineAnchorLine (m_bottomLeftCorner, LEFT);
        defineAnchorLine (m_bottomLeftCorner, BOTTOM);
        emit bottomLeftCornerChanged (m_bottomLeftCorner);
    }
}

void QQuickExtraAnchors::setBottomRightCorner(QQuickItem * bottomRightCorner) {
    if (m_bottomRightCorner != bottomRightCorner) {
        m_bottomRightCorner = bottomRightCorner;
        defineAnchorLine (m_bottomRightCorner, RIGHT);
        defineAnchorLine (m_bottomRightCorner, BOTTOM);
        emit bottomRightCornerChanged (m_bottomRightCorner);
    }
}
