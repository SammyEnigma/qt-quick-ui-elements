import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

FocusScope {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    implicitWidth: (input.contentWidth + padding * 2);
    implicitHeight: (input.contentHeight + padding * 2);

    property int   padding    : Style.spacingNormal;
    property bool  hasClear   : true;
    property bool  isPassword : false;
    property alias text       : input.text;
    property alias readOnly   : input.readOnly;
    property alias textFont   : input.font;
    property alias textColor  : input.color;
    property alias textAlign  : input.horizontalAlignment;
    property alias textHolder : holder.text;
    property alias inputMask  : input.inputMask;
    property alias validator  : input.validator;
    property alias acceptable : input.acceptableInput;
    property alias rounding   : rect.radius;

    signal accepted ();

    function selectAll () {
        input.selectAll ();
    }

    function clear () {
        input.text = "";
    }

    Rectangle {
        id: rect;
        radius: Style.roundness;
        enabled: base.enabled;
        visible: !readOnly;
        antialiasing: radius;
        gradient: (enabled ? Style.gradientEditable () : Style.gradientDisabled ());
        border {
            width: Style.lineSize;
            color: (input.activeFocus ? Style.colorSteelBlue : Style.colorGray);
        }
        anchors.fill: parent;
    }
    Item {
        clip: (input.contentWidth > input.width);
        enabled: base.enabled;
        anchors {
            fill: rect;
            margins: rect.border.width;
        }

        TextInput {
            id: input;
            focus: true;
            color: (enabled ? Style.colorBlack : Style.colorGray);
            enabled: base.enabled;
            selectByMouse: true;
            selectionColor: Style.colorSteelBlue;
            selectedTextColor: Style.colorWhite;
            activeFocusOnPress: true;
            echoMode: (isPassword ? TextInput.Password : TextInput.Normal);
            font {
                family: Style.fontName;
                weight: Font.Light;
                pixelSize: Style.fontSizeNormal;
            }
            anchors {
                left: parent.left;
                right: parent.right;
                margins: padding;
                verticalCenter: parent.verticalCenter;
            }
            onAccepted: { base.accepted (); }
        }
        MouseArea {
            width: height;
            enabled: base.enabled;
            visible: (input.text !== "" && hasClear);
            ExtraAnchors.rightDock: parent;
            onClicked: {
                base.focus = false;
                clear ();
            }

            Rectangle {
                width: (parent.width)
                height: (parent.height * 2);
                rotation: -90;
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Style.colorNone;  }
                    GradientStop { position: 0.5; color: Style.colorWhite; }
                    GradientStop { position: 1.0; color: Style.colorWhite; }
                }
                anchors {
                    verticalCenter: parent.verticalCenter;
                    horizontalCenter: parent.left;
                }
            }
            Loader {
                id: cross;
                enabled: base.enabled;
                sourceComponent: Style.symbolCross;
                states: State {
                    when: (cross.item !== null);

                    PropertyChanges {
                        target: cross.item;
                        size: Style.fontSizeNormal;
                        color: (enabled ? Style.colorBlack : Style.colorGray);
                    }
                }
                anchors.centerIn: parent;
            }
        }
    }
    TextLabel {
        id: holder;
        font: input.font;
        color: Style.colorGray;
        enabled: base.enabled;
        visible: (!input.activeFocus && input.text.trim ().length === 0 && !readOnly);
        horizontalAlignment: input.horizontalAlignment;
        anchors {
            left: parent.left;
            right: parent.right;
            margins: padding;
            verticalCenter: parent.verticalCenter;
        }
    }
}
