import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

FocusScope {
    id: base;
    implicitWidth: clicker.width;
    implicitHeight: clicker.height;
    Keys.onSpacePressed: { toggle (); }

    property bool  value : false;
    property alias size  : shape.size;

    function toggle () {
        if (enabled) {
            forceActiveFocus ();
            value = !value;
        }
    }

    MouseArea {
        id: clicker;
        width: size;
        height: size;
        anchors.centerIn: parent;
        onClicked: { base.toggle (); }

        Rectangle {
            id: rect;
            radius: Style.roundness;
            antialiasing: radius;
            gradient: (base.enabled ? Style.gradientEditable () : Style.gradientDisabled ());
            border {
                width: Style.lineSize;
                color: (base.activeFocus ? Style.colorSteelBlue : Style.colorGray);
            }
            anchors.fill: parent;
        }
        Item {
            id: shape;
            visible: value;
            anchors.fill: parent;

            property int size : (Style.spacingNormal * 2.5);

            readonly property real section  : (size * 0.10);
            readonly property real diagonal : (Math.SQRT2 * section);

            Rectangle {
                id: small;
                color: (base.enabled ? Style.colorBlack : Style.colorGray);
                width: (shape.diagonal * 3);
                height: shape.diagonal;
                rotation: +45;
                radius: (shape.diagonal / 5);
                antialiasing: radius;
                anchors {
                    centerIn: parent;
                    alignWhenCentered: false;
                    verticalCenterOffset: shape.section;
                    horizontalCenterOffset: (-2 * shape.section);
                }
            }
            Rectangle {
                id: big;
                color: (base.enabled ? Style.colorBlack : Style.colorGray);
                width: (shape.diagonal * 5);
                height: shape.diagonal;
                rotation: -45;
                radius: (shape.diagonal / 5);
                antialiasing: radius;
                anchors {
                    centerIn: parent;
                    alignWhenCentered: false;
                    horizontalCenterOffset: shape.section;
                }
            }
        }
    }
}
