import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

FocusScope {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    implicitWidth: -1;
    implicitHeight: -1;

    property bool      showBorder    : true;
    property bool      indicatorOnly : false;
    property alias     placeholder   : lbl.text;
    property alias     background    : rect.color;
    property alias     headerItem    : loaderHeader.sourceComponent;
    property alias     footerItem    : loaderFooter.sourceComponent;
    property Flickable flickableItem : null;

    default property alias content : base.flickableItem;

    readonly property bool canScrollX : (flickableItem && flickableItem.contentWidth  > flickableItem.width);
    readonly property bool canScrollY : (flickableItem && flickableItem.contentHeight > flickableItem.height);

    readonly property real minContentX : 0;
    readonly property real minContentY : 0;
    readonly property real maxContentX : (canScrollX ? flickableItem.contentWidth  - flickableItem.width  : 0);
    readonly property real maxContentY : (canScrollY ? flickableItem.contentHeight - flickableItem.height : 0);

    readonly property real ratioContentX : (canScrollX ? flickableItem.contentX / maxContentX : 0.0);
    readonly property real ratioContentY : (canScrollY ? flickableItem.contentY / maxContentY : 0.0);
    readonly property real ratioContentW : (canScrollX ? flickableItem.width  / flickableItem.contentWidth  : 0.0);
    readonly property real ratioContentH : (canScrollY ? flickableItem.height / flickableItem.contentHeight : 0.0);

    function ensureVisible (item) {
        if (item && flickableItem) {
            // position of the object's center against the flickable viewport top-left origin
            var relPos = item.mapToItem (flickableItem, (item.width / 2), (item.height / 2));
            // position of the object's center against the flickable content scene top-left origin
            var scenePosX = (flickableItem.contentX + relPos.x);
            var scenePosY = (flickableItem.contentY + relPos.y);
            // compute ideal flickable content scene position to have object's center in viewport center
            var idealContentX = (scenePosX - (flickableItem.width  / 2));
            var idealContentY = (scenePosY - (flickableItem.height / 2));
            // move flickable content scene, in respect of boundaries
            flickableItem.contentX = clamp (idealContentX, minContentX, maxContentX);
            flickableItem.contentY = clamp (idealContentY, minContentY, maxContentY);
        }
    }

    function clamp (val, min, max) {
        return (val > max ? max : (val < min ? min : val));
    }

    Rectangle {
        id: rect;
        color: Style.colorEditable;
        border {
            color: Style.colorBorder;
            width: (showBorder ? Style.lineSize : 0);
        }
        anchors {
            fill: parent;
            topMargin: (headerItem ? loaderHeader.height - Style.lineSize : 0);
            bottomMargin: (footerItem ? loaderFooter.height - Style.lineSize : 0);
        }
    }
    Loader {
        id: loaderHeader;
        clip: true;
        visible: item;
        ExtraAnchors.topDock: parent;

        Rectangle {
            z: -1;
            width: Math.round (parent.width);
            radius: Style.roundness;
            antialiasing: radius;
            gradient: Gradient {
                GradientStop { position: 0.0; color: Style.colorWindow; }
                GradientStop { position: 1.0; color: background; }
            }
            border {
                color: Style.colorBorder;
                width: (showBorder ? Style.lineSize : 0);
            }
            anchors.bottomMargin: -radius;
            ExtraAnchors.leftDock: parent;
        }
    }
    Loader {
        id: loaderFooter;
        clip: true;
        visible: item;
        ExtraAnchors.bottomDock: parent;

        Rectangle {
            z: -1;
            width: Math.round (parent.width);
            radius: Style.roundness;
            antialiasing: radius;
            gradient: Gradient {
                GradientStop { position: 0.0; color: background; }
                GradientStop { position: 1.0; color: Style.colorWindow; }
            }
            border {
                color: Style.colorBorder;
                width: (showBorder ? Style.lineSize : 0);
            }
            anchors.topMargin: -radius;
            ExtraAnchors.leftDock: parent;
        }
    }
    Item {
        id: container;
        clip: true;
        anchors {
            top: (loaderHeader.item ? loaderHeader.bottom : parent.top);
            bottom: (loaderFooter.item ? loaderFooter.top : parent.bottom);
            margins: rect.border.width;
        }
        ExtraAnchors.horizontalFill: parent;

        Binding {
            target: (flickableItem ? flickableItem.anchors : null);
            property: "fill";
            value: viewport;
        }
        Binding {
            target: flickableItem;
            property: "boundsBehavior";
            value: Flickable.StopAtBounds;
        }
        Binding {
            target: flickableItem;
            property: "interactive";
            value: true;
        }
        Binding {
            target: flickableItem;
            property: "pixelAligned";
            value: true;
        }
        Item {
            id: viewport;
            children: flickableItem;
            anchors {
                fill: parent;
                rightMargin: (scrollbarY.visible ? scrollbarY.width : 0);
                bottomMargin: (scrollbarX.visible ? scrollbarX.height : 0);
            }

            // CONTENT HERE
        }
        TextLabel {
            id: lbl;
            color: Style.colorBorder;
            font.pixelSize: Style.fontSizeBig;
            verticalAlignment: Text.AlignVCenter;
            horizontalAlignment: Text.AlignHCenter;
            anchors {
                fill: parent;
                margins: Style.spacingBig;
            }
        }
        Item {
            id: scrollbarX;
            height: (indicatorOnly ? Style.spacingSmall : Style.spacingBig);
            visible: (flickableItem && flickableItem.flickableDirection !== Flickable.VerticalFlick);
            anchors.rightMargin: (scrollbarY.visible ? scrollbarY.width : 0);
            ExtraAnchors.bottomDock: parent;

            Rectangle {
                id: backBottom;
                color: Style.colorGroove;
                anchors.fill: parent;
            }
            SymbolLoader {
                id: arrowLeft;
                size: Style.spacingNormal;
                color: (flickableItem && !flickableItem.atXBeginning ? Style.colorForeground : Style.colorBorder);
                width: height;
                symbol: Style.symbolArrowLeft;
                visible: !indicatorOnly;
                autoSize: false;
                ExtraAnchors.leftDock: parent;
            }
            SymbolLoader {
                id: arrowRight;
                size: Style.spacingNormal;
                color: (flickableItem && !flickableItem.atXEnd ? Style.colorForeground : Style.colorBorder);
                width: height;
                symbol: Style.symbolArrowRight;
                visible: !indicatorOnly;
                autoSize: false;
                ExtraAnchors.rightDock: parent;
            }
            MouseArea {
                id: grooveHoriz;
                clip: true;
                enabled: (canScrollX && !indicatorOnly);
                drag {
                    axis: Drag.XAxis;
                    target: handleHoriz;
                    minimumX: 0;
                    maximumX: (grooveHoriz.width - handleHoriz.width);
                }
                anchors {
                    fill: parent;
                    leftMargin: (!indicatorOnly ? height : 0);
                    rightMargin: (!indicatorOnly ? height : 0);
                }
                onPositionChanged: {
                    flickableItem.contentX = ((flickableItem.contentWidth - flickableItem.width) * handleHoriz.x / grooveHoriz.drag.maximumX);
                }

                Item {
                    id: handleHoriz;
                    visible: canScrollX;
                    ExtraAnchors.verticalFill: parent;

                    Binding on x {
                        when: (flickableItem && !grooveHoriz.pressed);
                        value: (grooveHoriz.drag.maximumx * ratioContentX);
                    }
                    Binding on width {
                        when: (flickableItem && !grooveHoriz.pressed);
                        value: Math.max (grooveHoriz.width * ratioContentW, 40);
                    }
                    PixelPerfectContainer {
                        contentItem: rectHoriz;
                        anchors {
                            fill: parent;
                            margins: Style.lineSize;
                        }

                        Rectangle {
                            id: rectHoriz;
                            color: (grooveHoriz.pressed ? Style.colorSecondary : Style.colorClickable);
                            width: Math.round (parent.width);
                            height: Math.round (parent.height);
                            radius: (indicatorOnly ? Style.lineSize : Style.roundness);
                            antialiasing: radius;
                            border {
                                width: Style.lineSize;
                                color: Style.colorSecondary;
                            }
                        }
                    }
                }
            }
        }
        Item {
            id: scrollbarY;
            width: (indicatorOnly ? Style.spacingSmall : Style.spacingBig);
            visible: (flickableItem && flickableItem.flickableDirection !== Flickable.HorizontalFlick);
            anchors.bottomMargin: (scrollbarX.visible ? scrollbarX.height : 0);
            ExtraAnchors.rightDock: parent;

            Rectangle {
                id: backRight;
                color: Style.colorGroove;
                anchors.fill: parent;
            }
            SymbolLoader {
                id: arrowUp;
                size: Style.spacingNormal;
                color: (flickableItem && !flickableItem.atYBeginning ? Style.colorForeground : Style.colorBorder);
                symbol: Style.symbolArrowUp;
                height: width;
                visible: !indicatorOnly;
                autoSize: false;
                ExtraAnchors.topDock: parent;
            }
            SymbolLoader {
                id: arrowDown;
                size: Style.spacingNormal;
                color: (flickableItem && !flickableItem.atYEnd ? Style.colorForeground : Style.colorBorder);
                height: width;
                symbol: Style.symbolArrowDown;
                visible: !indicatorOnly;
                autoSize: false;
                ExtraAnchors.bottomDock: parent;
            }
            MouseArea {
                id: grooveVertic;
                clip: true;
                enabled: (canScrollY && !indicatorOnly);
                drag {
                    axis: Drag.YAxis;
                    target: handleVertic;
                    minimumY: 0;
                    maximumY: (grooveVertic.height - handleVertic.height);
                }
                anchors {
                    fill: parent;
                    topMargin: (!indicatorOnly ? width : 0);
                    bottomMargin: (!indicatorOnly ? width : 0);
                }
                onPositionChanged: {
                    flickableItem.contentY = ((flickableItem.contentHeight - flickableItem.height) * handleVertic.y / grooveVertic.drag.maximumY);
                }

                Item {
                    id: handleVertic;
                    visible: canScrollY;
                    ExtraAnchors.horizontalFill: parent;

                    Binding on y {
                        when: (flickableItem && !grooveVertic.pressed);
                        value: (grooveVertic.drag.maximumY * ratioContentY);
                    }
                    Binding on height {
                        when: (flickableItem && !grooveVertic.pressed);
                        value: Math.max (grooveVertic.height * ratioContentH, 40);
                    }
                    PixelPerfectContainer {
                        contentItem: rectVertic;
                        anchors {
                            fill: parent;
                            margins: Style.lineSize;
                        }

                        Rectangle {
                            id: rectVertic;
                            color: (grooveVertic.pressed ? Style.colorSecondary : Style.colorClickable);
                            width: Math.round (parent.width);
                            height: Math.round (parent.height);
                            radius: (indicatorOnly ? Style.lineSize : Style.roundness);
                            antialiasing: radius;
                            border {
                                width: Style.lineSize;
                                color: Style.colorSecondary;
                            }
                        }
                    }
                }
            }
        }
        Rectangle {
            color: Style.colorGroove;
            width: scrollbarY.width;
            height: scrollbarX.height;
            visible: (scrollbarX.visible && scrollbarY.visible);
            ExtraAnchors.bottomRightCorner: parent;
        }
    }
}
