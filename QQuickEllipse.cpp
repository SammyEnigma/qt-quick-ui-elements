
#include "QQuickEllipse.h"

#include <QtMath>
#include <QDebug>

QPointF operator* (const QPointF & p1, const QPointF & p2) {
    return QPointF (p1.x () * p2.x (), p1.y () *  p2.y ());
}

QQuickEllipse::QQuickEllipse (QQuickItem * parent)
    : QQuickItem   (parent)
    , m_holeWidth  (0)
    , m_holeHeight (0)
    , m_startAngle (0)
    , m_stopAngle  (0)
    , m_clockwise  (true)
    , m_color      (Qt::black)
{
    setFlag (QQuickItem::ItemHasContents);
}

const QColor & QQuickEllipse::getColor (void) const {
    return m_color;
}

bool QQuickEllipse::getClockwise() const
{
    return m_clockwise;
}

int QQuickEllipse::getHoleWidth (void) const {
    return m_holeWidth;
}

int QQuickEllipse::getHoleHeight (void) const {
    return m_holeHeight;
}

int QQuickEllipse::getStartAngle (void) const {
    return m_startAngle;
}

int QQuickEllipse::getStopAngle (void) const {
    return m_stopAngle;
}


void QQuickEllipse::setHoleWidth (const int holeWidth) {
    if (m_holeWidth == holeWidth)
        return;

    m_holeWidth = holeWidth;
    emit holeWidthChanged ();
    update ();
}

void QQuickEllipse::setHoleHeight (const int holeHeight) {
    if (m_holeHeight == holeHeight)
        return;

    m_holeHeight = holeHeight;
    emit holeHeightChanged ();
    update ();
}

void QQuickEllipse::setStartAngle (const int startAngle) {
    if (startAngle > 359 || startAngle < 0) {
        qWarning () << "Ellipse.startAngle must be comprised between 0 and 359 !";
        return;
    }

    if (m_startAngle == startAngle)
        return;

    m_startAngle = startAngle;
    emit startAngleChanged ();
    update ();
}

void QQuickEllipse::setStopAngle (const int stopAngle) {
    if (stopAngle > 359 || stopAngle < 0) {
        qWarning () << "Ellipse.stopAngle must be comprised between 0 and 359 !";
        return;
    }

    if (m_stopAngle == stopAngle)
        return;

    m_stopAngle = stopAngle;
    emit stopAngleChanged ();
    update ();
}

void QQuickEllipse::setClockwise (const bool clockwise) {
    if (m_clockwise == clockwise)
        return;

    m_clockwise = clockwise;
    emit clockwiseChanged ();
    update ();
}

void QQuickEllipse::setColor (const QColor & color) {
    if (m_color == color)
        return;

    m_color = color;
    emit colorChanged ();
    update ();
}

QPointF QQuickEllipse::trigoPoint (const int angleDeg) {
    static bool computed = false;
    static QPointF cache [359];
    if (!computed) {
        for (int tmpDeg = 0; tmpDeg < 360; tmpDeg++) {
            const qreal tmpRad = (qreal (tmpDeg) * M_PI / 180.0f);
            cache [tmpDeg].setX (qCos (tmpRad));
            cache [tmpDeg].setY (qSin (tmpRad));
        }
        computed = true;
    }
    return cache [angleDeg % 360];
}

QSGNode * QQuickEllipse::updatePaintNode (QSGNode * oldNode, UpdatePaintNodeData * updateData) {
    Q_UNUSED (updateData)
    if (oldNode != Q_NULLPTR) {
        delete oldNode;
    }
    QSGNode * node = new QSGNode;
    const QPointF outerRadius (width ()    / 2.0f, height ()    / 2.0f);
    const QPointF innerRadius (m_holeWidth / 2.0f, m_holeHeight / 2.0f);
    const QPointF & center = outerRadius;
    QVector<QPointF> anglesList;
    anglesList.reserve (360);
    if (m_startAngle != m_stopAngle) {
        int currDeg = m_startAngle;
        while (currDeg != m_stopAngle) {
            anglesList.append (trigoPoint (currDeg));
            currDeg = (m_clockwise ? currDeg +1 : 360 + currDeg -1) % 360;
        }
    }
    else {
        for (int currDeg = 0; currDeg < 360; currDeg++) {
            anglesList.append (trigoPoint (currDeg));
        }
        anglesList.append (trigoPoint (0));
    }
    QSGGeometry * area = Q_NULLPTR;
    if (m_holeWidth > 0 && m_holeHeight > 0) { // ring : triangle strip
        const int pointsCount = (anglesList.count () * 2);
        area = new QSGGeometry (QSGGeometry::defaultAttributes_Point2D (), pointsCount);
        area->setDrawingMode (GL_TRIANGLE_STRIP);
        QSGGeometry::Point2D * vertex = area->vertexDataAsPoint2D ();
        int pointIdx = 0;
        for (QVector<QPointF>::const_iterator it = anglesList.constBegin (); it != anglesList.constEnd (); it++) {
            const QPointF currTrigo (* it);
            const QPointF innerPoint (center + innerRadius * currTrigo);
            vertex [pointIdx].x = float (innerPoint.x ());
            vertex [pointIdx].y = float (innerPoint.y ());
            pointIdx++;
            const QPointF outerPoint (center + outerRadius * currTrigo);
            vertex [pointIdx].x = float (outerPoint.x ());
            vertex [pointIdx].y = float (outerPoint.y ());
            pointIdx++;
        }
    }
    else { // ellipse : triangle fan
        const int pointsCount = (anglesList.count () + 1);
        area = new QSGGeometry (QSGGeometry::defaultAttributes_Point2D (), pointsCount);
        area->setDrawingMode (GL_TRIANGLE_FAN);
        QSGGeometry::Point2D * vertex = area->vertexDataAsPoint2D ();
        int pointIdx = 0;
        vertex [pointIdx].x = float (center.x ());
        vertex [pointIdx].y = float (center.y ());
        pointIdx++;
        for (QVector<QPointF>::const_iterator it = anglesList.constBegin (); it != anglesList.constEnd (); it++, pointIdx++) {
            const QPointF currTrigo (* it);
            const QPointF currPoint (center + outerRadius * currTrigo);
            vertex [pointIdx].x = float (currPoint.x ());
            vertex [pointIdx].y = float (currPoint.y ());
        }
    }
    if (area != Q_NULLPTR) {
        QSGFlatColorMaterial * mat = new QSGFlatColorMaterial;
        mat->setColor (m_color);
        QSGGeometryNode * subNode = new QSGGeometryNode;
        subNode->setGeometry (area);
        subNode->setMaterial (mat);
        subNode->setFlag (QSGNode::OwnsGeometry);
        subNode->setFlag (QSGNode::OwnsMaterial);
        subNode->setFlag (QSGNode::OwnedByParent);
        node->appendChildNode (subNode);
    }
    return node;
}
