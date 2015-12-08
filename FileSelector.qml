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

    FolderListModel {
        id: modelFS;
        showDirs: true;
        showFiles: true;
        showHidden: false;
        showDirsFirst: true;
        showDotAndDotDot: false;
    }
    StretchColumnContainer {
        spacing: 6;
        anchors {
            fill: parent;
            margins: 12;
        }

        StretchRowContainer {
            spacing: 12;
            anchors {
                left: parent.left;
                right: parent.right;
            }

            TextButton {
                text: "Parent dir";
                anchors.verticalCenter: parent.verticalCenter;
                onClicked: { modelFS.folder = modelFS.parentFolder; }
            }
            TextLabel {
                anchors.verticalCenter: parent.verticalCenter;
                text: modelFS.folder;
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
                delegate: MouseArea {
                    height: 24;
                    anchors {
                        left: parent.left;
                        right: parent.right;
                    }
                    onClicked: {
                        list.currentIndex = model.index;
                    }
                    onDoubleClicked: {
                        if (model.fileIsDir) {
                            modelFS.folder = model.fileURL;
                        }
                        else {
                            selected (model.fileURL.toString ());
                            base.close ();
                        }
                    }

                    Rectangle {
                        color: (model.index % 2 ? Style.colorLightGray : Style.colorDarkGray);
                        opacity: 0.35;
                        anchors.fill: parent;
                    }
                    TextLabel {
                        text: model.fileName + (model.fileIsDir ? "/" : "");
                        anchors {
                            left: parent.left;
                            right: parent.right;
                            margins: 6;
                            verticalCenter: parent.verticalCenter;
                        }
                    }
                }
            }
        }
    }
}
