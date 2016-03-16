import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    visible: (icon !== "");
    implicitWidth: (helper.size * helper.horizontalRatio);
    implicitHeight: (helper.size * helper.verticalRatio);

    property alias icon            : helper.icon;
    property alias size            : helper.size;
    property alias color           : helper.color;
    property alias verticalRatio   : helper.verticalRatio;
    property alias horizontalRatio : helper.horizontalRatio;

    Image {
        id: img;
        cache: true;
        width: helper.size;
        height: helper.size;
        smooth: false;
        fillMode: Image.Pad;
        antialiasing: false;
        asynchronous: true;

        SvgIconHelper on source { id: helper; }
    }
}
