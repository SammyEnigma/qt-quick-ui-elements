import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

FocusScope {
    id: base;
    implicitWidth: clicker.width;
    implicitHeight: clicker.height;
    Keys.onSpacePressed: { toggle (); }

    property bool value : false;

    function toggle () {
        if (enabled) {
            forceActiveFocus ();
            value = !value;
        }
    }

    MouseArea {
        id: clicker;
        width: (Style.spacingNormal * 2.5);
        height: (Style.spacingNormal * 2.5);
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
        Image {
            source: "image://icon-theme/dialog-ok";
            visible: base.value;
            fillMode: Image.Stretch;
            anchors {
                fill: parent;
                margins: (Style.spacingNormal / 10);
            }
        }
    }
}
