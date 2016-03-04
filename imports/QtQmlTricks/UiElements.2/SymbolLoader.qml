import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Loader {
    id: base;
    states: State {
        when: (instance !== null);

        PropertyChanges {
            target: instance;
            size: base.size;
            color: base.color;
            width: (base.autoSize ? instance.implicitWidth : base.width);
            height: (base.autoSize ? instance.implicitHeight : base.height);
        }
    }

    property int   size     : Style.fontSizeNormal;
    property color color    : (enabled ? Style.colorForeground : Style.colorBorder);
    property alias symbol   : base.sourceComponent;
    property bool  autoSize : true;

    readonly property AbstractSymbol instance : item;
}
