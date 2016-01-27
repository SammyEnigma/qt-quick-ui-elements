import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: base;
    implicitHeight: Style.spacingBig;

    property real value     : 0;
    property real minValue  : 0;
    property real maxValue  : 100;
    property int  divisions : 0;

    Rectangle {
        id: groove;
        color: (base.enabled ? Style.colorWhite : Style.colorLightGray);
        radius: Style.roundness;
        antialiasing: radius;
        anchors {
            fill: parent;
            margins: Style.lineSize;
        }

        Rectangle {
            id: rect;
            width: (parent.width * (value - minValue) / (maxValue - minValue));
            radius: (Style.roundness - Style.lineSize * 2);
            antialiasing: radius;
            gradient: (base.enabled
                       ? Style.gradientChecked ("skyblue")
                       : Style.gradientDisabled ());
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
            color: (base.enabled ? Style.colorLightBlue : Style.colorDarkGray)
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
        antialiasing: radius;
        border {
            width: Style.lineSize;
            color: Style.colorGray;
        }
        anchors.fill: parent;
    }
}
