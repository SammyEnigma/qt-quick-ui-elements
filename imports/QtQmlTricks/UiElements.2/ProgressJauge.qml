import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    implicitWidth: 200;
    implicitHeight: Style.spacingBig;

    property real value     : 0;
    property real minValue  : 0;
    property real maxValue  : 100;
    property int  divisions : 0;

    Rectangle {
        id: groove;
        color: (base.enabled ? Style.colorEditable : Style.colorWindow);
        radius: Style.roundness;
        enabled: base.enabled;
        antialiasing: radius;
        anchors {
            fill: parent;
            margins: Style.lineSize;
        }

        Rectangle {
            id: rect;
            width: Math.min (parent.width * (value - minValue) / (maxValue - minValue), parent.width);
            radius: (Style.roundness - Style.lineSize * 2);
            enabled: base.enabled;
            antialiasing: radius;
            gradient: (base.enabled
                       ? Style.gradientChecked ()
                       : Style.gradientDisabled (Style.colorBorder));
            anchors {
                top: parent.top;
                left: parent.left;
                bottom: parent.bottom;
            }
        }
    }
    Repeater {
        model: (divisions > 1 ? divisions -1 : 0);
        delegate: Rectangle {
            x: ((parent.width / divisions) * (model.index +1));
            width: Style.lineSize;
            color: (enabled ? Style.colorHighlight : Style.colorSecondary)
            enabled: base.enabled;
            anchors {
                top: parent.top;
                bottom: parent.bottom;
            }
        }
    }
    Rectangle {
        id: frame;
        color: Style.colorNone;
        radius: Style.roundness;
        enabled: base.enabled;
        antialiasing: radius;
        border {
            width: Style.lineSize;
            color: Style.colorBorder;
        }
        anchors.fill: parent;
    }
}
