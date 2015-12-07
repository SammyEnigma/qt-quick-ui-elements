import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Text {
    color: (enabled ? Style.colorBlack : Style.colorGray);
    font {
        weight: Font.Light;
        family: Style.fontName;
        pixelSize: Style.fontSizeNormal;
    }
}
