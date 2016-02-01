import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

FocusScope {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    implicitWidth: 200;
    implicitHeight: 200;

    property bool       showBorder    : true;
    property bool       indicatorOnly : false;
    property alias      background    : rect.color;
    property Flickable  flickableItem : null;
    property alias      headerItem    : loaderHeader.sourceComponent;
    property alias      footerItem    : loaderFooter.sourceComponent;

    default property alias content : base.flickableItem;

    Rectangle {
        id: rect;
        color: Style.colorEditable;
        border {
            width: (showBorder ? 1 : 0);
            color: Style.colorBorder;
        }
        anchors.fill: parent;
    }
    Loader {
        id: loaderHeader;
        visible: item;
        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right;
            margins: rect.border.width;
        }

        Rectangle {
            z: -1;
            gradient: Gradient {
                GradientStop { position: 0; color: Style.colorWindow; }
                GradientStop { position: 1; color: rect.color; }
            }
            anchors.fill: parent;
        }
    }
    Loader {
        id: loaderFooter;
        visible: item;
        anchors {
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
            margins: rect.border.width;
        }

        Rectangle {
            z: -1;
            gradient: Gradient {
                GradientStop { position: 0; color: rect.color; }
                GradientStop { position: 1; color: Style.colorWindow; }
            }
            anchors.fill: parent;
        }
    }
    Item {
        id: container;
        clip: true;
        anchors {
            top: (loaderHeader.item ? loaderHeader.bottom : parent.top);
            left: parent.left;
            right: parent.right;
            bottom: (loaderFooter.item ? loaderFooter.top : parent.bottom);
            margins: rect.border.width;
        }

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
            anchors {
                left: parent.left;
                right: parent.right;
                bottom: parent.bottom;
                rightMargin: (scrollbarY.visible ? scrollbarY.width : 0);
            }

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
                anchors {
                    top: parent.top;
                    left: parent.left;
                    bottom: parent.bottom;
                }
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
                anchors {
                    top: parent.top;
                    right: parent.right;
                    bottom: parent.bottom;
                }
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
                    anchors {
                        top: parent.top;
                        bottom: parent.bottom;
                    }

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
            anchors {
                top: parent.top;
                right: parent.right;
                bottom: parent.bottom;
                bottomMargin: (scrollbarX.visible ? scrollbarX.height : 0);
            }

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
                anchors {
                    top: parent.top;
                    left: parent.left;
                    right: parent.right;
                }
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
                anchors {
                    left: parent.left;
                    right: parent.right;
                    bottom: parent.bottom;
                }
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
                    anchors {
                        left: parent.left;
                        right: parent.right;
                    }

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
            opacity: Math.max (backRight.opacity, backBottom.opacity);
            width: scrollbarY.width;
            height: scrollbarX.height;
            visible: (scrollbarX.visible && scrollbarY.visible);
            anchors {
                right: parent.right;
                bottom: parent.bottom;
            }
        }
    }
}
