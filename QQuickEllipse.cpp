
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
    const qreal radiusX = (width ()  / 2.0f);
    const qreal radiusY = (height () / 2.0f);
    if (m_holeWidth > 0 && m_holeHeight > 0) { // ring : triangle strip
        qWarning () << "TRIANGLE STRIP";

        // TODO
    }
    else { // ellipse : triangle fan
        qWarning () << "TRIANGLE FAN";
        const int pointsCount = (anglesList.count () + 1);
        QSGGeometry * area = new QSGGeometry (QSGGeometry::defaultAttributes_Point2D (), pointsCount);
        area->setDrawingMode (GL_TRIANGLE_FAN);
        QSGGeometry::Point2D * vertex = area->vertexDataAsPoint2D ();
        int pointIdx = 0;
        vertex [pointIdx].x = float (radiusX);
        vertex [pointIdx].y = float (radiusY);
        pointIdx++;
        for (QVector<int>::const_iterator it = anglesList.constBegin (); it != anglesList.constEnd (); it++, pointIdx++) {
            const int currDeg = (* it);
            const qreal currRad = (qreal (currDeg) * M_PI / 180.0f);
            vertex [pointIdx].x = float (radiusX + radiusX * qCos (currRad));
            vertex [pointIdx].y = float (radiusY + radiusY * qSin (currRad));
        }
        QSGFlatColorMaterial * mat = new QSGFlatColorMaterial;
        mat->setColor (m_color);
        QSGGeometryNode * subNode = new QSGGeometryNode;
        subNode->setGeometry (area);
        subNode->setMaterial (mat);
        node->appendChildNode (subNode);
    }
    return node;
}
