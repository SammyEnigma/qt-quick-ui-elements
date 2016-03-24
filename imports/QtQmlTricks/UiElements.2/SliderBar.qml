import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    implicitWidth: 200;
    implicitHeight: handle.height;

    property real value    : 0;
    property real minValue : 0;
    property real maxValue : 100;

    property int  decimals : 0;

    Rectangle {
        id: groove;
        color: (enabled ? Style.colorEditable : Style.colorWindow);
        height: Style.spacingNormal;
        radius: Style.roundness;
        enabled: base.enabled;
        antialiasing: radius;
        border {
            width: Style.lineSize;
            color: Style.colorBorder;
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
                           ? Style.gradientChecked ()
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
                      : Style.gradientIdle (Qt.lighter (Style.colorClickable, clicker.containsMouse ? 1.15 : 1.0)))
                   : Style.gradientDisabled ());
        border {
            width: Style.lineSize;
            color: Style.colorBorder;
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
            hoverEnabled: Style.useHovering;
            anchors.fill: parent;
            onPressed: {
                if (tooltip === null) {
                    tooltip = compoTooltip.createObject (Introspector.window (base));
                }
            }
            onReleased: {
                if (tooltip !== null) {
                    tooltip.destroy ();
                    tooltip = null;
                }
            }
            onPositionChanged: {
                value = (minValue + (maxValue - minValue) * (handle.x / (base.width - handle.width)));
            }

            property Balloon tooltip : null;

            Component {
                id: compoTooltip;

                Balloon {
                    x: (handleTopCenterAbsPos.x - width / 2);
                    y: (handleTopCenterAbsPos.y - height - Style.spacingNormal);
                    z: 9999999;
                    content: base.value.toFixed (decimals);

                    readonly property var handleTopCenterAbsPos : base.mapToItem (parent,
                                                                                  (handle.x + handle.width  / 2),
                                                                                  (handle.y));
                }
            }
        }
    }
}
