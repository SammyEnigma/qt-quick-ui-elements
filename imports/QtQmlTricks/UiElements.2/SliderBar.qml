import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: base;
    implicitHeight: handle.height;

    property real value    : 0;
    property real minValue : 0;
    property real maxValue : 100;

    Rectangle {
        id: groove;
        color: (enabled ? Style.colorWhite : Style.colorLightGray);
        height: Style.spacingNormal;
        radius: Style.roundness;
        enabled: base.enabled;
        antialiasing: radius;
        border {
            width: Style.lineSize;
            color: Style.colorGray;
        }
        anchors {
            left: parent.left;
            right: parent.right;
            verticalCenter: parent.verticalCenter;
        }

        Item {
            enabled: base.enabled;
            anchors {
               fill: parent;
               margins: Style.lineSize;
            }

            Rectangle {
                id: rect;
                width: (parent.width * (value - minValue) / (maxValue - minValue));
                radius: (Style.roundness - Style.lineSize * 2);
                enabled: base.enabled;
                antialiasing: radius;
                gradient: (enabled
                           ? Style.gradientChecked ("skyblue")
                           : Style.gradientDisabled ());
                anchors {
                    top: parent.top;
                    left: parent.left;
                    bottom: parent.bottom;
                }
            }
        }
    }
    Rectangle {
        id: handle;
        x: ((base.width - handle.width) * (value - minValue) / (maxValue - minValue));
        width: size;
        height: size;
        radius: (size / 2);
        enabled: base.enabled;
        antialiasing: radius;
        gradient: (enabled
                   ? (clicker.pressed
                      ? Style.gradientPressed ()
                      : Style.gradientIdle ())
                   : Style.gradientDisabled ());
        border {
            width: Style.lineSize;
            color: Style.colorGray;
        }
        anchors.verticalCenter: parent.verticalCenter;

        readonly property int size : (Style.spacingBig * 2);

        MouseArea {
            id: clicker;
            drag {
                target: handle;
                minimumX: 0;
                maximumX: (base.width - handle.width);
                minimumY: 0;
                maximumY: 0;
            }
            enabled: base.enabled;
            anchors.fill: parent;
            onPositionChanged: { value = (minValue + (maxValue - minValue) * (handle.x / (base.width - handle.width))); }
        }
    }
}
