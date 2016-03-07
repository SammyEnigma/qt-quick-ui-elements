import QtQuick 2.1;
import Qt.labs.folderlistmodel 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: base;

    property alias title       : labelTitle.text;
    property alias folder      : modelFS.folder;
    property alias rootFolder  : modelFS.rootFolder;
    property alias nameFilters : modelFS.nameFilters;

    signal selected (string fileUrl);
    signal canceled ();

    MimeIconsHelper {
        id: mimeHelper;
    }
    FolderListModel {
        id: modelFS;
        showDirs: true;
        showFiles: true;
        showHidden: false;
        showDirsFirst: true;
        showDotAndDotDot: false;
        Component.onCompleted: { path.text = folder.toString (); }
    }
    StretchColumnContainer {
        spacing: Style.spacingNormal;
        anchors.fill: parent;

        TextLabel {
            id: labelTitle;
            text: "Choose a file";
            font.pixelSize: Style.fontSizeTitle;
        }
        StretchRowContainer {
            spacing: Style.spacingBig;
            ExtraAnchors.horizontalFill: parent;

            TextButton {
                text: "Parent";
                enabled: (folder.toString () !== "file:///");
                icon: Image { source: "image://icon-theme/go-up"; }
                anchors.verticalCenter: parent.verticalCenter;
                onClicked: {
                    list.currentIndex = -1;
                    folder = modelFS.parentFolder;
                }
            }
            Item {
                height: implicitHeight;
                implicitWidth: -1;
                implicitHeight: path.height;
                anchors.verticalCenter: parent.verticalCenter;

                TextLabel {
                    id: path;
                    font.pixelSize: Style.fontSizeSmall;
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                    anchors.verticalCenter: parent.verticalCenter;
                    ExtraAnchors.horizontalFill: parent;

                    Binding on text { value: folder; }
                }
            }
        }
        ScrollContainer {
            implicitHeight: -1;
            ExtraAnchors.horizontalFill: parent;

            ListView {
                id: list;
                model: modelFS;
                currentIndex: -1;
                delegate: MouseArea {
                    height: (Math.max (label.height, img.height) + label.anchors.margins * 2);
                    ExtraAnchors.horizontalFill: parent;
                    onClicked: {
                        if (!model.fileIsDir) {
                            list.currentIndex = model.index;
                        }
                        else {
                            list.currentIndex = -1;
                        }
                    }
                    onDoubleClicked: {
                        if (model.fileIsDir) {
                            list.currentIndex = -1;
                            folder = model.fileURL;
                        }
                        else {
                            selected (model.fileURL.toString ());
                        }
                    }

                    Line {
                        opacity: 0.65;
                        ExtraAnchors.bottomDock: parent;
                    }
                    Image {
                        id: img;
                        width: size;
                        height: size;
                        source: "image://icon-theme/%1".arg (mimeHelper.getIconNameForUrl (model.fileURL));
                        fillMode: Image.Stretch;
                        anchors {
                            left: parent.left;
                            margins: Style.spacingNormal;
                            verticalCenter: parent.verticalCenter;
                        }

                        readonly property int size : (Style.fontSizeNormal * 2);
                    }
                    TextLabel {
                        id: label;
                        text: model.fileName + (model.fileIsDir ? "/" : "");
                        font.bold: (model.index === list.currentIndex);
                        elide: Text.ElideRight;
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                        maximumLineCount: 3;
                        anchors {
                            left: img.right;
                            right: parent.right;
                            margins: Style.spacingNormal;
                            verticalCenter: parent.verticalCenter;
                        }
                    }
                }
            }
        }
        StretchRowContainer {
            spacing: Style.spacingBig;
            ExtraAnchors.horizontalFill: parent;

            TextButton {
                text: "Cancel";
                icon: SymbolLoader {
                    size: Style.fontSizeNormal;
                    color: (enabled ? Style.colorForeground : Style.colorBorder);
                    symbol: Style.symbolCross;
                }
                anchors.verticalCenter: parent.verticalCenter;
                onClicked: { base.canceled (); }
            }
            Item {
                implicitWidth: -1;
                anchors.verticalCenter: parent.verticalCenter;

                TextLabel {
                    text: (list.currentIndex > -1 && list.currentIndex < modelFS.count
                           ? modelFS.get (list.currentIndex, "fileName")
                           : "");
                    font.pixelSize: Style.fontSizeNormal;
                    width: (parent.parent.colSpacing + parent.width * 2);
                    elide: Text.ElideMiddle;
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                    verticalAlignment: Text.AlignVCenter;
                    horizontalAlignment: Text.AlignHCenter;
                    anchors.verticalCenter: parent.verticalCenter;
                    ExtraAnchors.horizontalFill: parent;
                }
            }
            TextButton {
                text: "Accept";
                icon: SymbolLoader {
                    size: Style.fontSizeNormal;
                    color: (enabled ? Style.colorForeground : Style.colorBorder);
                    symbol: Style.symbolCheck;
                }
                enabled: (list.currentIndex > -1 && list.currentIndex < list.count);
                anchors.verticalCenter: parent.verticalCenter;
                onClicked: { selected (modelFS.get (list.currentIndex, "fileURL").toString ()); }
            }
        }
    }
}
