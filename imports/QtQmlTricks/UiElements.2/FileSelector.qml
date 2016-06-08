import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: base;

    property string fileUrl  : "";
    property string filePath : "";

    property string folder      : FileSystem.homePath;
    property string rootFolder  : FileSystem.rootPath;
    property bool   showFiles   : true;
    property bool   showHidden  : false;
    property var    nameFilters : [];

    MimeIconsHelper { id: mimeHelper; }
    ListModel {
        id: modelFS;
        onEntriesChanged: {
            clear ();
            append (entries);
        }
        Component.onCompleted: {
            clear ();
            append (entries);
        }

        readonly property var entries : FileSystem.list (folder, nameFilters, showHidden, showFiles);
    }
    StretchColumnContainer {
        spacing: Style.spacingNormal;
        anchors.fill: parent;

        StretchRowContainer {
            spacing: Style.spacingNormal;
            ExtraAnchors.horizontalFill: parent;

            ComboList {
                model: FileSystem.drivesList;
                visible: (FileSystem.rootPath !== "/");
                delegate: ComboListDelegateForSimpleVar { }
                anchors.verticalCenter: parent.verticalCenter;
                onCurrentKeyChanged: {
                    if (currentKey !== undefined && currentKey !== "" && ready) {
                        rootFolder = currentKey;
                        folder = currentKey;
                    }
                }
                Component.onCompleted: {
                    selectByKey (FileSystem.rootPath);
                    ready = true;
                }

                property bool ready : false;
            }
            Stretcher {
                height: implicitHeight;
                implicitHeight: path.height;
                anchors.verticalCenter: parent.verticalCenter;

                TextLabel {
                    id: path;
                    text: folder;
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                    font.pixelSize: Style.fontSizeSmall;
                    anchors.verticalCenter: parent.verticalCenter;
                    ExtraAnchors.horizontalFill: parent;
                }
            }
            TextButton {
                text: qsTr ("Parent");
                enabled: (folder !== rootFolder);
                icon: SvgIconLoader {
                    icon: "actions/chevron-up";
                    size: Style.iconSize (1);
                    color: Style.colorForeground;
                }
                anchors.verticalCenter: parent.verticalCenter;
                onClicked: {
                    list.currentIndex = -1;
                    folder = FileSystem.parentDir (folder);
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
                        if (!model.isDir) {
                            list.currentIndex = model.index;
                            fileUrl  = model.url;
                            filePath = model.path;
                        }
                        else {
                            list.currentIndex = -1;
                        }
                    }
                    onDoubleClicked: {
                        if (model.isDir) {
                            list.currentIndex = -1;
                            folder = model.path;
                        }
                        else {
                            fileUrl  = model.url;
                            filePath = model.path;
                        }
                    }

                    Line {
                        opacity: 0.65;
                        ExtraAnchors.bottomDock: parent;
                    }
                    SvgIconLoader {
                        id: img;
                        size: Style.realPixels (24);
                        icon: mimeHelper.getSvgIconPathForUrl (model.url);
                        anchors {
                            left: parent.left;
                            margins: Style.spacingNormal;
                            verticalCenter: parent.verticalCenter;
                        }
                    }
                    TextLabel {
                        id: label;
                        text: model.name + (model.isDir ? "/" : "");
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
                   ? (modelFS.get (list.currentIndex) ["name"] || "")
                   : "");
            elide: Text.ElideMiddle;
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
            verticalAlignment: Text.AlignVCenter;
            horizontalAlignment: Text.AlignHCenter;
        }
    }
}
