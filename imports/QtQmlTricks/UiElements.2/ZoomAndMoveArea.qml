import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: base;

    property int wheelResolution : 1200; // NOTE : change if zoom is too slow / too fast

    property bool enableMoving  : true;
    property bool enableZooming : true;

    property real contentZoom    : 1;
    property real contentZoomMin : 0.05;
    property real contentZoomMax : 50;
    property real contentPadding : 0;

    property Item contentItem : null;

    default property alias content : base.contentItem;

    QtObject {
        id: priv;

        property real lastPosX : 0;
        property real lastPosY : 0;

        property real contentOffsetX : 0;
        property real contentOffsetY : 0;

        readonly property real contentZoomedWidth  : (contentItem ? contentItem.width  * contentZoom : 0);
        readonly property real contentZoomedHeight : (contentItem ? contentItem.height * contentZoom : 0);

        readonly property real contentOffsetXLimit : ((contentZoomedWidth  / 2) - (width  / 2) + contentPadding);
        readonly property real contentOffsetYLimit : ((contentZoomedHeight / 2) - (height / 2) + contentPadding);

        function clamp (value, min, max) {
            return (min !== undefined && value < min
                    ? min
                    : (max !== undefined && value > max
                       ? max
                       : value));
        }

        function applyZoom (zoom) {
            contentZoom = clamp (zoom, contentZoomMin, contentZoomMax);
        }

        function applyOffsetX (offset) {
            contentOffsetX = ((contentZoomedWidth + contentPadding * 2) > width
                              ? clamp (offset, -contentOffsetXLimit, contentOffsetXLimit)
                              : 0);
        }

        function applyOffsetY (offset) {
            contentOffsetY = ((contentZoomedHeight + contentPadding * 2) > height
                              ? clamp (offset, -contentOffsetYLimit, contentOffsetYLimit)
                              : 0);
        }

        function doSavePos (posX, posY) {
            if (enableMoving) {
                lastPosX = posX;
                lastPosY = posY;
            }
        }

        function doZoomAtPos (posX, posY, zoomDelta) {
            if (enableZooming) {
                var posOnContentBeforeZoom = mapToItem (contentItem, posX, posY);
                applyZoom (contentZoom + (contentZoom * (zoomDelta / wheelResolution)));
                var posOnContentAfterZoom = mapToItem (contentItem, posX, posY);
                applyOffsetX (contentOffsetX + (posOnContentAfterZoom.x - posOnContentBeforeZoom.x) * contentZoom);
                applyOffsetY (contentOffsetY + (posOnContentAfterZoom.y - posOnContentBeforeZoom.y) * contentZoom);
            }
        }

        function doMoveToPos (posX, posY) {
            if (enableMoving) {
                applyOffsetX (contentOffsetX + posX - lastPosX);
                applyOffsetY (contentOffsetY + posY - lastPosY);
                doSavePos (posX, posY);
            }
        }
    }
    MouseArea {
        anchors.fill: parent;
        onWheel: { priv.doZoomAtPos (wheel.x, wheel.y, wheel.angleDelta.y); }
        onPressed: { priv.doSavePos (mouse.x, mouse.y); }
        onPositionChanged: { priv.doMoveToPos (mouse.x, mouse.y); }
        states: State {
            when: (contentItem !== null);

            PropertyChanges {
                target: contentItem;
                scale: contentZoom;
                parent: base;
                anchors {
                    verticalCenterOffset: priv.contentOffsetY;
                    horizontalCenterOffset: priv.contentOffsetX;
                }
            }
            AnchorChanges {
                target: contentItem;
                anchors {
                    verticalCenter: base.verticalCenter;
                    horizontalCenter: base.horizontalCenter;
                }
            }
        }
    }
}
