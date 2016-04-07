
#include "QQuickEllipse.h"

#include <QtMath>
#include <QDebug>

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

QSGNode * QQuickEllipse::updatePaintNode (QSGNode * oldNode, UpdatePaintNodeData * updateData) {
    Q_UNUSED (updateData)
    if (oldNode != Q_NULLPTR) {
        delete oldNode;
    }
    QSGNode * node = new QSGNode;
    QVector<int> anglesList;
    anglesList.reserve (360);
    if (m_startAngle != m_stopAngle) {
        int currDeg = m_startAngle;
        while (currDeg != m_stopAngle) {
            anglesList.append (currDeg);
            currDeg = (m_clockwise ? currDeg +1 : 360 + currDeg -1) % 360;
        }
    }
    else {
        for (int currDeg = 0; currDeg < 360; currDeg++) {
            anglesList.append (currDeg);
        }
        anglesList.append (0);
    }
    const qreal centerX      = (width () / 2.0f);
    const qreal centerY      = (height () / 2.0f);
    const qreal outerRadiusX = (centerX);
    const qreal outerRadiusY = (centerY);
    const qreal innerRadiusX = (m_holeWidth / 2.0f);
    const qreal innerRadiusY = (m_holeHeight / 2.0f);
    QSGGeometry * area = Q_NULLPTR;
    if (m_holeWidth > 0 && m_holeHeight > 0) { // ring : triangle strip
        const int pointsCount = (anglesList.count () * 2);
        area = new QSGGeometry (QSGGeometry::defaultAttributes_Point2D (), pointsCount);
        area->setDrawingMode (GL_TRIANGLE_STRIP);
        QSGGeometry::Point2D * vertex = area->vertexDataAsPoint2D ();
        int pointIdx = 0;
        for (QVector<int>::const_iterator it = anglesList.constBegin (); it != anglesList.constEnd (); it++) {
            const int currDeg = (* it);
            const qreal currRad = (qreal (currDeg) * M_PI / 180.0f);
            vertex [pointIdx].x = float (centerX + innerRadiusX * qCos (currRad));
            vertex [pointIdx].y = float (centerY + innerRadiusY * qSin (currRad));
            pointIdx++;
            vertex [pointIdx].x = float (centerX + outerRadiusX * qCos (currRad));
            vertex [pointIdx].y = float (centerY + outerRadiusY * qSin (currRad));
            pointIdx++;
        }
    }
    else { // ellipse : triangle fan
        const int pointsCount = (anglesList.count () + 1);
        area = new QSGGeometry (QSGGeometry::defaultAttributes_Point2D (), pointsCount);
        area->setDrawingMode (GL_TRIANGLE_FAN);
        QSGGeometry::Point2D * vertex = area->vertexDataAsPoint2D ();
        int pointIdx = 0;
        vertex [pointIdx].x = float (centerX);
        vertex [pointIdx].y = float (centerY);
        pointIdx++;
        for (QVector<int>::const_iterator it = anglesList.constBegin (); it != anglesList.constEnd (); it++, pointIdx++) {
            const int currDeg = (* it);
            const qreal currRad = (qreal (currDeg) * M_PI / 180.0f);
            vertex [pointIdx].x = float (centerX + outerRadiusX * qCos (currRad));
            vertex [pointIdx].y = float (centerY + outerRadiusY * qSin (currRad));
        }
    }
    if (area != Q_NULLPTR) {
        QSGFlatColorMaterial * mat = new QSGFlatColorMaterial;
        mat->setColor (m_color);
        QSGGeometryNode * subNode = new QSGGeometryNode;
        subNode->setGeometry (area);
        subNode->setMaterial (mat);
        node->appendChildNode (subNode);
    }
    return node;
}
