import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

ProgressJauge {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    barSize: Style.spacingNormal;
    implicitWidth: 200;
    implicitHeight: handle.height;

    property int decimals : 0;

    property int handleSize : (Style.spacingBig * 2);

    property bool editable : true;

    property bool showTooltipWhenMoved : true;

    readonly property real ratio : Math.pow (10, decimals);

    signal edited ();

    MouseArea {
        visible: editable;
        anchors.fill: parent;
        onClicked: {
            var tmp = Style.convert (mouse.x,
                                     0,
                                     width,
                                     minValue,
                                     maxValue);
            value = (Math.round (tmp * ratio) / ratio);
            edited ();
        }
    }
    Rectangle {
        id: handle;
        width: handleSize;
        height: handleSize;
        radius: (handleSize / 2);
        visible: editable;
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

        Binding on x {
            when: !clicker.pressed;
            value: Style.convert (base.value,
                                  base.minValue,
                                  base.maxValue,
                                  clicker.drag.minimumX,
                                  clicker.drag.maximumX);
        }
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
                if (tooltip === null && showTooltipWhenMoved) {
                    tooltip = compoTooltip.createObject (Introspector.window (base));
                }
            }
            onReleased: {
                if (tooltip !== null && showTooltipWhenMoved) {
                    tooltip.destroy ();
                    tooltip = null;
                }
            }
            onPositionChanged: {
                if (pressed) {
                    var tmp = Style.convert (handle.x,
                                             clicker.drag.minimumX,
                                             clicker.drag.maximumX,
                                             minValue,
                                             maxValue);
                    value = (Math.round (tmp * ratio) / ratio);
                    edited ();
                }
            }

            property Item tooltip : null;

            Component {
                id: compoTooltip;

                Rectangle {
                    id: rect;
                    x: (handleTopCenterAbsPos.x - width / 2);
                    y: (handleTopCenterAbsPos.y - height - Style.spacingNormal);
                    z: 9999999;
                    width: Math.ceil (lblTooltip.implicitWidth + lblTooltip.anchors.margins * 2);
                    height: Math.ceil (lblTooltip.implicitHeight + lblTooltip.anchors.margins * 2);
                    color: Style.colorBubble;
                    radius: Style.roundness;
                    antialiasing: radius;
                    border {
                        width: Style.lineSize;
                        color: Qt.darker (color);
                    }

                    readonly property var handleTopCenterAbsPos : base.mapToItem (parent,
                                                                                  (handle.x + handle.width / 2),
                                                                                  (handle.y));

                    TextLabel {
                        id: lblTooltip;
                        text: base.value.toFixed (decimals);
                        font.pixelSize: Style.fontSizeSmall;
                        anchors.margins: Style.spacingSmall;
                        anchors.centerIn: parent;
                    }
                }
            }
        }
    }
}
