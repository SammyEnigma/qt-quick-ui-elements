import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

MouseArea {
    id: clicker;
    width: implicitWidth;
    height: implicitHeight;
    states: [
        State {
            name: "icon_and_text";
            when: (ico.visible && lbl.visible);

            PropertyChanges {
                target: clicker;
                implicitWidth: (ico.width + lbl.contentWidth + padding * 3);
                implicitHeight: (ico.height > lbl.contentHeight ? ico.height + padding * 2: lbl.contentHeight + padding * 2);
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
                implicitWidth: Math.max (lbl.contentWidth + padding * 2, implicitHeight);
                implicitHeight: (lbl.contentHeight + padding * 2);
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
                implicitWidth: (ico.width + padding * 2);
                implicitHeight: (ico.height + padding * 2);
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
                implicitWidth: 0;
                implicitHeight: 0;
            }
        }
    ]

    property int   padding   : 6;
    property bool  checked   : false;
    property alias text      : lbl.text;
    property alias textFont  : lbl.font;
    property alias textColor : lbl.color;
    property alias backColor : rect.color;
    property alias rounding  : rect.radius;
    property alias icon      : ico.sourceComponent;

    Rectangle {
        id: rect;
        radius: 3;
        antialiasing: true;
        gradient: (clicker.enabled
                   ? (checked
                      ? Style.gradientChecked
                      : (pressed
                         ? Style.gradientPressed
                         : Style.gradientIdle))
                   : Style.gradientDisabled);
        border {
            width: 1;
            color: (checked ? Style.colorSteelBlue : Style.colorGray);
        }
        anchors.fill: parent;
    }
    Loader {
        id: ico;
        active: (sourceComponent !== null);
        visible: (item !== null);
        anchors.margins: padding;
    }
    Text {
        id: lbl;
        color: (clicker.enabled
                ? (checked
                   ? Style.colorDarkBlue
                   : Style.colorBlack)
                : Style.colorGray);
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
