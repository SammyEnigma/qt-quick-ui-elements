import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

FocusScope {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    implicitWidth: (input.contentWidth + padding * 2);
    implicitHeight: (input.contentHeight + padding * 2);

    property int   padding    : Style.spacingNormal;
    property bool  hasClear   : false;
    property bool  isPassword : false;
    property color backColor  : Style.colorEditable;
    property color textColor  : Style.colorForeground;
    property alias text       : input.text;
    property alias readOnly   : input.readOnly;
    property alias textFont   : input.font;
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
        gradient: (enabled ? Style.gradientEditable (backColor) : Style.gradientDisabled ());
        border {
            width: (input.activeFocus ? Style.lineSize * 2 : Style.lineSize);
            color: (input.activeFocus ? Style.colorSelection : Style.colorBorder);
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
            color: (enabled ? textColor : Style.colorBorder);
            enabled: base.enabled;
            selectByMouse: true;
            selectionColor: Style.colorSelection;
            selectedTextColor: Style.colorEditable;
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
                    GradientStop { position: 0.5; color: backColor; }
                    GradientStop { position: 1.0; color: backColor; }
                }
                anchors {
                    verticalCenter: parent.verticalCenter;
                    horizontalCenter: parent.left;
                }
            }
            SymbolLoader {
                id: cross;
                size: Style.fontSizeNormal;
                color: (enabled ? Style.colorForeground : Style.colorBorder);
                symbol: Style.symbolCross;
                enabled: base.enabled;
                anchors.centerIn: parent;
            }
        }
    }
    TextLabel {
        id: holder;
        font: input.font;
        color: Style.colorSecondary;
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
