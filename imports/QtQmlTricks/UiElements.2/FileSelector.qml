import QtQuick 2.1;
import Qt.labs.folderlistmodel 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: base;

    property string fileUrl  : "";
    property string filePath : "";

    property string folder      : FS.homePath;
    property string rootFolder  : FS.rootPath;
    property var    nameFilters : [];
    property bool   showFiles   : true;
    property bool   showHidden  : false;

    MimeIconsHelper { id: mimeHelper; }
    ListModel {
        id: modelFS;
        onEntriesChanged: {
            clear ();
            append (entries);
        }
        Component.onCompleted: { append (entries); }

        readonly property var entries : FS.list (folder, nameFilters, showHidden, showFiles);
    }
    StretchColumnContainer {
        spacing: Style.spacingNormal;
        anchors.fill: parent;

        StretchRowContainer {
            spacing: Style.spacingBig;
            ExtraAnchors.horizontalFill: parent;

            TextButton {
                text: "Parent";
                enabled: (folder !== rootFolder);
                icon: SvgIconLoader {
                    icon: "qrc:/QtQmlTricks/icons/actions/chevron-up.svg";
                    size: Style.realPixels (24);
                    color: Style.colorForeground;
                }
                anchors.verticalCenter: parent.verticalCenter;
                onClicked: {
                    list.currentIndex = -1;
                    folder = FS.parentDir (folder);
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
                   ? modelFS.get (list.currentIndex, "fileName")
                   : "");
            elide: Text.ElideMiddle;
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
            verticalAlignment: Text.AlignVCenter;
            horizontalAlignment: Text.AlignHCenter;
        }
    }
}
