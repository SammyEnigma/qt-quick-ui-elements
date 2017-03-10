import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

FocusScope {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    implicitWidth: Math.ceil (showButtons ? input.implicitWidth + input.height * 2 : input.implicitWidth);
    implicitHeight: Math.ceil (input.implicitHeight);

    property real step        : 1;
    property real value       : 0;
    property real minValue    : 0;
    property real maxValue    : 100;
    property int  decimals    : 0;
    property int  padding     : Style.spacingNormal;
    property bool showButtons : true;

    readonly property string display : (!isNaN (value) ? value.toFixed (decimals) : "");

    signal edited ();

    function validate () {
        if (enabled) {
            input.apply ();
        }
    }

    TextButton {
        id: btnDecrease;
        width: (height + Style.roundness);
        icon: SymbolLoader {
            size: Style.fontSizeNormal;
            color: (enabled ? Style.colorForeground : Style.colorBorder);
            symbol: Style.symbolMinus;
        }
        padding: base.padding;
        visible: showButtons;
        enabled: (base.enabled && value - step >= minValue);
        autoRepeat: true;
        ExtraAnchors.leftDock: parent;
        onClicked: {
            if (value - step >= minValue) {
                value -= step;
                edited ();
            }
        }
    }
    TextButton {
        id: btnIncrease;
        icon: SymbolLoader {
            size: Style.fontSizeNormal;
            color: (enabled ? Style.colorForeground : Style.colorBorder);
            symbol: Style.symbolPlus;
        }
        padding: base.padding;
        width: (height + Style.roundness);
        visible: showButtons;
        enabled: (base.enabled && value + step <= maxValue);
        autoRepeat: true;
        ExtraAnchors.rightDock: parent;
        onClicked: {
            if (value + step <= maxValue) {
                value += step;
                edited ();
            }
        }
    }
    TextBox {
        id: input;
        focus: true;
        padding: base.padding;
        enabled: base.enabled;
        rounding: (showButtons ? 0 : Style.roundness);
        hasClear: false;
        textAlign: TextInput.AlignHCenter;
        backColor: (flashEffect ? Style.colorError : Style.colorEditable);
        textColor: (flashEffect ? Style.colorEditable : (hasError ? Style.colorError : Style.colorForeground));
        implicitWidth: (Math.max (metricsMinValue.width, metricsMaxValue.width) + padding * 2);
        validator: DoubleValidator {
            top: base.maxValue;
            bottom: base.minValue;
            locale: "C";
            decimals: base.decimals;
            notation: DoubleValidator.StandardNotation;
        }
        textFont.underline: (text !== display);
        anchors {
            left: (showButtons ? btnDecrease.right : parent.left);
            right: (showButtons ? btnIncrease.left : parent.right);
            leftMargin: (showButtons ? -btnDecrease.rounding : 0);
            rightMargin: (showButtons ? -btnIncrease.rounding : 0);
        }
        ExtraAnchors.verticalFill: parent;
        onActiveFocusChanged: {
            if (!activeFocus) {
                apply ();
            }
        }
        Keys.onEnterPressed:  {
            apply ();
            event.accepted = false;
        }
        Keys.onReturnPressed: {
            apply ();
            event.accepted = false;
        }
        Keys.onUpPressed:   { btnIncrease.click (event.isAutoRepeat); }
        Keys.onDownPressed: { btnDecrease.click (event.isAutoRepeat); }

        property bool flashEffect : false;

        readonly property var  number    : parseFloat (text);
        readonly property bool notNumber : isNaN (number);
        readonly property bool tooBig    : (!notNumber ? number > maxValue : false);
        readonly property bool tooSmall  : (!notNumber ? number < minValue : false);
        readonly property bool hasError  : (notNumber || tooBig || tooSmall);

        function apply () {
            if (!notNumber && !tooBig && !tooSmall) {
                base.value = number;
                edited ();
            }
            else {
                text = (base.value.toFixed (decimals));
                animFlash.start ();
            }
        }

        Binding on text { value: display; }
        SequentialAnimation on flashEffect {
            id: animFlash;
            loops: 2;
            running: false;
            alwaysRunToEnd: true;

            PropertyAction { value: true; }
            PauseAnimation { duration: 100; }
            PropertyAction { value: false; }
            PauseAnimation { duration: 100; }
        }
        TextLabel {
            id: metricsMinValue;
            text: minValue.toFixed (decimals);
            color: Style.colorNone;
        }
        TextLabel {
            id: metricsMaxValue;
            text: maxValue.toFixed (decimals);
            color: Style.colorNone;
        }
    }
}
