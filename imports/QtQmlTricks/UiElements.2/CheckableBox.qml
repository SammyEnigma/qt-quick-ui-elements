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
                width: Style.lineSize;
                color: (base.activeFocus ? Style.colorSteelBlue : Style.colorGray);
            }
            anchors.fill: parent;
        }
        Loader {
            id: shape;
            enabled: base.enabled;
            sourceComponent: Style.symbolCheck;
            anchors.fill: parent;
            states: State {
                when: (shape.item !== null);

                PropertyChanges {
                    target: shape.item;
                    size: base.size;
                    color: (base.enabled ? Style.colorBlack : Style.colorGray);
                    visible: base.value;
                }
            }
        }
    }
}
