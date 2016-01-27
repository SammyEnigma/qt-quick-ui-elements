import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: accordion;

    property alias background : rect.color;

    property Group currentTab : null;

    property list<Group> tabs;

    default property alias content : accordion.tabs;

    readonly property int tabSize  : (Style.spacingBig * 2);
    readonly property int paneSize :  (height - tabs.length * tabSize);

    Rectangle {
        id: rect;
        color: Style.colorDarkGray;
        anchors.fill: parent;
    }
    Column {
        anchors.fill: parent;

        Repeater {
            model: tabs;
            delegate: Column {
                states: [
                    State {
                        name: "text_and_icon";
                        when: (modelData.icon !== "");

                        AnchorChanges {
                            target: lbl;
                            anchors {
                                left: ico.right;
                                verticalCenter: parent.verticalCenter;
                            }
                        }
                        AnchorChanges {
                            target: ico;
                            anchors {
                                left: parent.left;
                                verticalCenter: parent.verticalCenter;
                            }
                        }
                    },
                    State {
                        name: "text_only";
                        when: (modelData.icon === "");

                        AnchorChanges {
                            target: lbl;
                            anchors {
                                verticalCenter: parent.verticalCenter;
                                horizontalCenter: parent.horizontalCenter;
                            }
                        }
                    }
                ]
                ExtraAnchors.horizontalFill: parent;

                MouseArea {
                    height: tabSize;
                    ExtraAnchors.horizontalFill: parent;
                    onClicked: { currentTab = (currentTab !== modelData ? modelData : null); }

                    Rectangle {
                        gradient: (modelData === currentTab
                                   ? Style.gradientShaded (Style.colorLightBlue, Style.colorDarkGray)
                                   : (parent.pressed
                                      ? Style.gradientPressed ()
                                      : Style.gradientIdle ()));
                        anchors.fill: parent;
                    }
                    Image {
                        id: ico;
                        source: modelData.icon;
                        width: size;
                        height: size;
                        sourceSize: Qt.size (size, size);
                        fillMode: Image.Stretch;
                        anchors.margins: Style.spacingNormal;

                        readonly property int size : (Style.fontSizeNormal * 2);
                    }
                    TextLabel {
                        id: lbl;
                        text: modelData.title;
                        anchors.margins: Style.spacingNormal;
                    }
                }
                FocusScope {
                    id: container;
                    height: paneSize;
                    visible: (modelData === currentTab);
                    children: modelData;
                    ExtraAnchors.horizontalFill: parent;

                    Binding {
                        target: modelData ["anchors"];
                        property: "fill";
                        value: container;
                    }

                    // NOTE : tab content here
                }
                Rectangle {
                    color: Style.colorGray;
                    height: Style.lineSize;
                    ExtraAnchors.horizontalFill: parent;
                }
            }
        }
    }
}
