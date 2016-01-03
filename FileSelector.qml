import QtQuick 2.1;
import QtQuick.Window 2.1;
import Qt.labs.folderlistmodel 2.1;
import QtQmlTricks.UiElements 2.0;

Window {
    id: base;
    color: Style.colorDarkGray;
    width: 640;
    height: 320;
    flags: Qt.Dialog;
    visible: true;
    modality: Qt.WindowModal;

    property alias folder      : modelFS.folder;
    property alias rootFolder  : modelFS.rootFolder;
    property alias nameFilters : modelFS.nameFilters;

    signal selected (string fileUrl);

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
        anchors {
            fill: parent;
            margins: Style.spacingBig;
        }

        StretchRowContainer {
            spacing: Style.spacingBig;
            anchors {
                left: parent.left;
                right: parent.right;
            }

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
                    anchors {
                        left: parent.left;
                        right: parent.right;
                        verticalCenter: parent.verticalCenter;
                    }

                    Binding on text { value: folder; }
                }
            }
        }
        ScrollContainer {
            implicitHeight: -1;
            anchors {
                left: parent.left;
                right: parent.right;
            }

            ListView {
                id: list;
                model: modelFS;
                currentIndex: -1;
                delegate: MouseArea {
                    height: (Math.max (label.height, img.height) + label.anchors.margins * 2);
                    anchors {
                        left: parent.left;
                        right: parent.right;
                    }
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
                            base.close ();
                        }
                    }

                    Rectangle {
                        color: Style.colorLightGray;
                        height: Style.lineSize;
                        opacity: 0.65;
                        anchors {
                            left: parent.left;
                            right: parent.right;
                            bottom: parent.bottom;
                        }
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
        GridContainer {
            cols: capacity;
            capacity: 4;
            colSpacing: Style.spacingBig;
            anchors {
                left: parent.left;
                right: parent.right;
            }

            TextButton {
                text: "Cancel";
                icon: Image { source: "image://icon-theme/dialog-no"; }
                anchors.verticalCenter: parent.verticalCenter;
                onClicked: { base.close (); }
            }
            Item {
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
                    anchors {
                        top: parent.top;
                        left: parent.left;
                        bottom: parent.bottom;
                    }
                }
            }
            Item { }
            TextButton {
                text: "OK";
                enabled: (list.currentIndex > -1 && list.currentIndex < list.count);
                icon: Image { source: "image://icon-theme/dialog-yes"; }
                anchors.verticalCenter: parent.verticalCenter;
                onClicked: {
                    selected (modelFS.get (list.currentIndex, "fileURL").toString ());
                    base.close ();
                }
            }
        }
    }
}
