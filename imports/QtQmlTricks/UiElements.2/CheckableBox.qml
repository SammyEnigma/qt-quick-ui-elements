import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

FocusScope {
    id: base;
    implicitWidth: clicker.width;
    implicitHeight: clicker.height;
    Keys.onSpacePressed: { toggle (); }

    property bool  value : false;
    property int   size  : (Style.spacingNormal * 2.5);

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
        enabled: base.enabled;
        anchors.centerIn: parent;
        onClicked: { base.toggle (); }

        Rectangle {
            id: rect;
            radius: Style.roundness;
            enabled: base.enabled;
            antialiasing: radius;
            gradient: (enabled ? Style.gradientEditable () : Style.gradientDisabled ());
            border {
                width: (base.activeFocus ? Style.lineSize * 2 : Style.lineSize);
                color: (base.activeFocus ? Style.colorSelection : Style.colorBorder);
            }
            anchors.fill: parent;
        }
        SymbolLoader {
            id: shape;
            size: base.size;
            color: (base.enabled ? Style.colorForeground : Style.colorBorder);
            symbol: Style.symbolCheck;
            visible: base.value;
            enabled: base.enabled;
            autoSize: false;
            anchors.fill: parent;
        }
    }
}
