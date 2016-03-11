import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Text {
    color: (enabled ? Style.colorForeground : Style.colorBorder);
    textFormat: Text.PlainText;
    renderType: (Style.useNativeText ? Text.NativeRendering : Text.QtRendering);
    verticalAlignment: Text.AlignVCenter;
    font {
        weight: (Style.useSlimFonts ? Font.Light : Font.Normal);
        family: Style.fontName;
        pixelSize: Style.fontSizeNormal;
    }
}
