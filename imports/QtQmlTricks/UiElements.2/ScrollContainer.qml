import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

FocusScope {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    implicitWidth: 200;
    implicitHeight: 200;

    property bool      showBorder    : true;
    property bool      indicatorOnly : false;
    property alias     background    : rect.color;
    property alias     headerItem    : loaderHeader.sourceComponent;
    property alias     footerItem    : loaderFooter.sourceComponent;
    property Flickable flickableItem : null;

    default property alias content : base.flickableItem;

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
            anchors {
                fill: parent;
                bottomMargin: -radius;
            }
        }
    }
    Loader {
        id: loaderFooter;
        clip: true;
        visible: item;
        ExtraAnchors.bottomDock: parent;

        Rectangle {
            z: -1;
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
            anchors {
                fill: parent;
                topMargin: -radius;
            }
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
        Item {
            id: scrollbarX;
            height: (indicatorOnly ? Style.spacingSmall : Style.spacingBig);
            visible: (flickableItem && flickableItem.flickableDirection !== Flickable.VerticalFlick);
            anchors.rightMargin: (scrollbarY.visible ? scrollbarY.width : 0);
            ExtraAnchors.bottomDock: parent;

            Rectangle {
                id: backBottom;
                color: Style.colorBorder;
                opacity: (flickableItem && flickableItem.contentWidth > container.width ? 0.5 : 0.15);
                anchors.fill: parent;
            }
            Loader {
                id: arrowLeft;
                width: height;
                visible: !indicatorOnly;
                sourceComponent: Style.symbolArrowLeft;
                states: State {
                    when: (arrowLeft.item !== null);

                    PropertyChanges {
                        target: arrowLeft.item;
                        size: Style.spacingNormal;
                        color: (flickableItem && !flickableItem.atXBeginning ? Style.colorForeground : Style.colorBorder);
                        width: arrowLeft.width;
                        height: arrowLeft.height;
                    }
                }
                ExtraAnchors.leftDock: parent;
            }
            Loader {
                id: arrowRight;
                width: height;
                visible: !indicatorOnly;
                sourceComponent: Style.symbolArrowRight;
                states: State {
                    when: (arrowRight.item !== null);

                    PropertyChanges {
                        target: arrowRight.item;
                        size: Style.spacingNormal;
                        color: (flickableItem && !flickableItem.atXEnd ? Style.colorForeground : Style.colorBorder);
                        width: arrowRight.width;
                        height: arrowRight.height;
                    }
                }
                ExtraAnchors.rightDock: parent;
            }
            MouseArea {
                id: grooveHoriz;
                clip: true;
                enabled: !indicatorOnly;
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

                Rectangle {
                    id: handleHoriz;
                    color: Style.colorWindow;
                    radius: (indicatorOnly ? 2 : 5);
                    visible: (flickableItem && flickableItem.visibleArea.widthRatio < 1.0);
                    antialiasing: true;
                    border {
                        width: (indicatorOnly ? 1 : 2);
                        color: Style.colorSecondary;
                    }
                    ExtraAnchors.verticalFill: parent;

                    Binding on x {
                        when: (flickableItem && !grooveHoriz.pressed);
                        value: (grooveHoriz.width * flickableItem.visibleArea.xPosition);
                    }
                    Binding on width {
                        when: (flickableItem && !grooveHoriz.pressed);
                        value: Math.max (grooveHoriz.width * flickableItem.visibleArea.widthRatio, 40);
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
                color: Style.colorBorder;
                opacity: (flickableItem && flickableItem.contentHeight > container.height ? 0.5 : 0.15);
                anchors.fill: parent;
            }
            Loader {
                id: arrowUp;
                height: width;
                visible: !indicatorOnly;
                sourceComponent: Style.symbolArrowUp;
                states: State {
                    when: (arrowUp.item !== null);

                    PropertyChanges {
                        target: arrowUp.item;
                        size: Style.spacingNormal;
                        color: (flickableItem && !flickableItem.atYBeginning ? Style.colorForeground : Style.colorBorder);
                        width: arrowUp.width;
                        height: arrowUp.height;
                    }
                }
                ExtraAnchors.topDock: parent;
            }
            Loader {
                id: arrowDown;
                height: width;
                visible: !indicatorOnly;
                sourceComponent: Style.symbolArrowDown;
                states: State {
                    when: (arrowDown.item !== null);

                    PropertyChanges {
                        target: arrowDown.item;
                        size: Style.spacingNormal;
                        color: (flickableItem && !flickableItem.atYEnd ? Style.colorForeground : Style.colorBorder);
                        width: arrowDown.width;
                        height: arrowDown.height;
                    }
                }
                ExtraAnchors.bottomDock: parent;
            }
            MouseArea {
                id: grooveVertic;
                clip: true;
                enabled: !indicatorOnly;
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

                Rectangle {
                    id: handleVertic;
                    color: Style.colorWindow;
                    radius: (indicatorOnly ? 2 : 5);
                    visible: (flickableItem && flickableItem.visibleArea.heightRatio < 1.0);
                    antialiasing: true;
                    border {
                        width: (indicatorOnly ? 1 : 2);
                        color: Style.colorSecondary;
                    }
                    ExtraAnchors.horizontalFill: parent;

                    Binding on y {
                        when: (flickableItem && !grooveVertic.pressed);
                        value: (grooveVertic.height * flickableItem.visibleArea.yPosition);
                    }
                    Binding on height {
                        when: (flickableItem && !grooveVertic.pressed);
                        value: Math.max (grooveVertic.height * flickableItem.visibleArea.heightRatio, 40);
                    }
                }
            }
        }
        Rectangle {
            color: Style.colorBorder;
            width: scrollbarY.width;
            height: scrollbarX.height;
            visible: (scrollbarX.visible && scrollbarY.visible);
            opacity: Math.max (backRight.opacity, backBottom.opacity);
            ExtraAnchors.bottomRightCorner: parent;
        }
    }
}
