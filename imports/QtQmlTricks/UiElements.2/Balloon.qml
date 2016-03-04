import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

MouseArea {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    implicitWidth: 100;
    implicitHeight: (layout.height + layout.anchors.margins * 2);

    property alias image   : img.source;
    property alias title   : lblTitle.text;
    property alias content : lblContent.text;

    Rectangle {
        id: rect;
        color: Style.colorBubble;
        radius: Style.roundness;
        antialiasing: radius;
        border {
            width: Style.lineSize;
            color: Qt.darker (color);
        }
        anchors.fill: parent;
    }
    StretchColumnContainer {
        id: layout;
        spacing: Style.spacingSmall;
        anchors.margins: Style.spacingNormal;
        ExtraAnchors.topDock: parent;

        TextLabel {
            id: lblTitle;
            visible: (text !== "");
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
            horizontalAlignment: Text.AlignJustify;
            font {
                weight: Font.Bold;
                pixelSize: Style.fontSizeSmall;
            }
        }
        TextLabel {
            id: lblContent;
            visible: (text !== "");
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
            horizontalAlignment: Text.AlignJustify;
            font.pixelSize: Style.fontSizeSmall;
        }
        Item {
            implicitHeight: Math.min (img.sourceSize.height, img.sourceSize.height * width / img.sourceSize.width);

            Image {
                id: img;
                visible: (status === Image.Ready);
                fillMode: Image.PreserveAspectFit;
                horizontalAlignment: Image.AlignHCenter;
                anchors.fill: parent;
            }
        }
    }
}
