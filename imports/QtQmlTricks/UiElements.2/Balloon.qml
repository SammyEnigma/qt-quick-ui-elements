import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Rectangle {
    id: base;
    color: Style.colorBubble;
    width: implicitWidth;
    height: implicitHeight;
    radius: Style.roundness;
    antialiasing: radius;
    border {
        width: Style.lineSize;
        color: Qt.darker (color);
    }
    implicitWidth: 100;
    implicitHeight: (layout.height + layout.anchors.margins * 2);

    property alias image   : img.source;
    property alias title   : lblTitle.text;
    property alias content : lblContent.text;

    StretchColumnContainer {
        id: layout;
        spacing: Style.spacingSmall;
        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right;
            margins: Style.spacingNormal;
        }

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
            font {
                pixelSize: Style.fontSizeSmall;
            }
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
