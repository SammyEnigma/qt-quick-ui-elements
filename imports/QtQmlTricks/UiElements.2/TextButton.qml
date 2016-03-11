import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

MouseArea {
    id: clicker;
    width: implicitWidth;
    height: implicitHeight;
    hoverEnabled: Style.useHovering;
    implicitWidth: contentWidth;
    implicitHeight: contentHeight;
    states: [
        State {
            name: "icon_and_text";
            when: (ico.visible && lbl.visible);

            PropertyChanges {
                target: clicker;
                contentWidth: (ico.width + lbl.contentWidth + padding * 3);
                contentHeight: (ico.height > lbl.contentHeight ? ico.height + padding * 2: lbl.contentHeight + padding * 2);
            }
            AnchorChanges {
                target: ico;
                anchors {
                    left: parent.left;
                    verticalCenter: parent.verticalCenter;
                }
            }
            AnchorChanges {
                target: lbl;
                anchors {
                    left: ico.right;
                    right: parent.right;
                    verticalCenter: parent.verticalCenter;
                }
            }
        },
        State {
            name: "text_only";
            when: (!ico.visible && lbl.visible);

            PropertyChanges {
                target: clicker;
                contentWidth: Math.max (lbl.contentWidth + padding * 2, contentHeight);
                contentHeight: (lbl.contentHeight + padding * 2);
            }
            AnchorChanges {
                target: lbl;
                anchors {
                    verticalCenter: parent.verticalCenter;
                    horizontalCenter: parent.horizontalCenter;
                }
            }
        },
        State {
            name: "icon_only";
            when: (ico.visible && !lbl.visible);

            PropertyChanges {
                target: clicker;
                contentWidth: (ico.width + padding * 2);
                contentHeight: (ico.height + padding * 2);
            }
            AnchorChanges {
                target: ico;
                anchors {
                    verticalCenter: parent.verticalCenter;
                    horizontalCenter: parent.horizontalCenter;
                }
            }
        },
        State {
            name: "empty";
            when: (!ico.visible && !lbl.visible);

            PropertyChanges {
                target: clicker;
                contentWidth: 0;
                contentHeight: 0;
            }
        }
    ]

    property int   padding       : Style.spacingNormal;
    property bool  flat          : false;
    property bool  checked       : false;
    property color backColor     : Style.colorClickable;
    property color textColor     : Style.colorForeground;
    property alias text          : lbl.text;
    property alias textFont      : lbl.font;
    property alias rounding      : rect.radius;
    property alias icon          : ico.sourceComponent;
    property alias hovered       : clicker.containsMouse;
    property int   contentWidth  : 0;
    property int   contentHeight : 0;

    function click () {
        if (enabled) {
            clicked (null);
        }
    }

    Rectangle {
        id: rect;
        enabled: clicker.enabled;
        radius: Style.roundness;
        antialiasing: radius;
        gradient: (enabled
                   ? (checked
                      ? Style.gradientChecked ()
                      : (pressed
                         ? Style.gradientPressed (backColor)
                         : Style.gradientIdle (flat ? Style.colorNone : Qt.lighter (backColor, hovered ? 1.15 : 1.0))))
                   : Style.gradientDisabled ());
        border {
            width: (!flat || pressed || checked || hovered ? Style.lineSize : 0);
            color: (checked ? Style.colorSelection : Style.colorBorder);
        }
        anchors.fill: parent;
    }
    Loader {
        id: ico;
        active: (sourceComponent !== null);
        enabled: clicker.enabled;
        visible: (item !== null);
        anchors.margins: padding;
    }
    Text {
        id: lbl;
        color: (enabled
                ? (checked
                   ? Style.colorLink
                   : textColor)
                : Style.colorBorder);
        enabled: clicker.enabled;
        visible: (text !== "");
        horizontalAlignment: (ico.visible ? Text.AlignLeft : Text.AlignHCenter);
        font {
            family: Style.fontName;
            weight: Font.Light;
            pixelSize: Style.fontSizeNormal;
        }
        anchors.margins: padding;
    }
}
