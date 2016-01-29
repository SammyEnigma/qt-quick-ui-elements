import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

FocusScope {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    implicitWidth: (input.implicitWidth + input.height * 2);
    implicitHeight: input.implicitHeight;

    property real step      : 1;
    property real value     : 0;
    property real minValue  : 0;
    property real maxValue  : 100;
    property int  decimals  : 0;

    TextLabel {
        id: metricsValue;
        color: Style.colorNone;
        text: {
            var txtMin = minValue.toFixed (decimals);
            var txtMax = maxValue.toFixed (decimals);
            var count = Math.max (txtMin.length, txtMax.length);
            return new Array (count +1).join ("0");
        }
    }
    TextButton {
        id: btnDecrease;
        icon: Loader {
            id: minus;
            sourceComponent: Style.symbolMinus;
            states: State {
                when: (minus.item !== null);

                PropertyChanges {
                    target: minus.item;
                    size: Style.fontSizeNormal;
                    color: (enabled ? Style.colorBlack : Style.colorGray);
                }
            }
        }
        width: (height + Style.roundness);
        enabled: (base.enabled && value - step >= minValue);
        ExtraAnchors.leftDock: parent;
        onClicked: { value -= step; }
    }
    TextButton {
        id: btnIncrease;
        icon: Loader {
            id: plus;
            sourceComponent: Style.symbolPlus;
            states: State {
                when: (plus.item !== null);

                PropertyChanges {
                    target: plus.item;
                    size: Style.fontSizeNormal;
                    color: (enabled ? Style.colorBlack : Style.colorGray);
                }
            }
        }
        width: (height + Style.roundness);
        enabled: (base.enabled && value + step <= maxValue);
        ExtraAnchors.rightDock: parent;
        onClicked: { value += step; }
    }
    TextBox {
        id: input;
        focus: true;
        enabled: base.enabled;
        rounding: 0;
        hasClear: false;
        textAlign: TextInput.AlignHCenter;
        textColor: (enabled
                    ? (notNumber || tooBig || tooSmall
                       ? Style.colorDarkRed
                       : Style.colorBlack)
                    : Style.colorGray);
        implicitWidth: (metricsValue.contentWidth + padding * 2);
        anchors {
            left: btnDecrease.right;
            right: btnIncrease.left;
            leftMargin: -Style.roundness;
            rightMargin: -Style.roundness;
        }
        ExtraAnchors.verticalFill: parent;
        onActiveFocusChanged: {
            if (!activeFocus) {
                apply ();
            }
        }
        Keys.onEnterPressed:  {
            event.accepted = false;
            apply ();
        }
        Keys.onReturnPressed: {
            event.accepted = false;
            apply ();
        }
        Keys.onUpPressed:   { btnIncrease.click (); }
        Keys.onDownPressed: { btnDecrease.click (); }

        readonly property var  number    : parseFloat (text);
        readonly property bool notNumber : isNaN (number);
        readonly property bool tooBig    : (!notNumber ? number > maxValue : false);
        readonly property bool tooSmall  : (!notNumber ? number < minValue : false);

        function apply () {
            if (!notNumber && !tooBig && !tooSmall) {
                base.value = number;
            }
            else {
                text = (base.value.toFixed (decimals));
            }
        }

        Binding on text { value: (base.value.toFixed (decimals)); }
    }
}
