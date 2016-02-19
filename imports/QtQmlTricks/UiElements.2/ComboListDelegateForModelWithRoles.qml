import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

ComboListDelegate {
    id: self;
    key: (model ? model [roleKey] : undefined);
    value: (model ? model [roleValue] : "");
    width: implicitWidth;
    height: implicitHeight;
    implicitWidth: lbl.contentWidth;
    implicitHeight: lbl.contentHeight;

    property string roleKey   : "key";
    property string roleValue : "value";

    readonly property alias label : lbl;

    TextLabel {
        id: lbl;
        text: self.value;
        font.bold: self.active;
        anchors.verticalCenter: parent.verticalCenter;
    }
}
