import QtQuick 2.1;
import Qt.labs.folderlistmodel 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: base;

    property string fileUrl : "";

    property alias folder      : modelFS.folder;
    property alias rootFolder  : modelFS.rootFolder;
    property alias nameFilters : modelFS.nameFilters;

    MimeIconsHelper { id: mimeHelper; }
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

        StretchRowContainer {
            spacing: Style.spacingBig;
            ExtraAnchors.horizontalFill: parent;

            TextButton {
                text: "Parent";
                enabled: (folder.toString () !== "file:///");
                icon: SvgIconLoader {
                    icon: "qrc:/QtQmlTricks/icons/actions/chevron-up.svg";
                    size: Style.realPixels (24);
                    color: Style.colorForeground;
                }
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
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                    font.pixelSize: Style.fontSizeSmall;
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
                            fileUrl = model.fileURL.toString ();
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
                            fileUrl = model.fileURL.toString ();
                        }
                    }

                    Line {
                        opacity: 0.65;
                        ExtraAnchors.bottomDock: parent;
                    }
                    SvgIconLoader {
                        id: img;
                        size: Style.realPixels (24);
                        icon: mimeHelper.getSvgIconPathForUrl (model.fileURL);
                        anchors {
                            left: parent.left;
                            margins: Style.spacingNormal;
                            verticalCenter: parent.verticalCenter;
                        }
                    }
                    TextLabel {
                        id: label;
                        text: model.fileName + (model.fileIsDir ? "/" : "");
                        elide: Text.ElideRight;
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                        maximumLineCount: 3;
                        emphasis: (model.index === list.currentIndex);
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
        TextLabel {
            text: (list.currentIndex > -1 && list.currentIndex < modelFS.count
                   ? modelFS.get (list.currentIndex, "fileName")
                   : "");
            elide: Text.ElideMiddle;
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
            verticalAlignment: Text.AlignVCenter;
            horizontalAlignment: Text.AlignHCenter;
        }
    }
}
