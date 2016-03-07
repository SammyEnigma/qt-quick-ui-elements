import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: accordion;

    property alias background : rect.color;

    property Group currentTab : null;

    default property alias content : container.children;

    readonly property var tabs : {
        var ret = [];
        for (var idx = 0; idx < content.length; idx++) {
            var item = content [idx];
            if (Introspector.inherits (item, testGroup)) {
                ret.push (item);
            }
        }
        return ret;
    }

    readonly property int tabSize  : (Style.spacingBig * 2);
    readonly property int paneSize : (height - tabs.length * (tabSize + Style.lineSize));

    Group { id: testGroup; }
    Rectangle {
        id: rect;
        color: Style.colorSecondary;
        anchors.fill: parent;
    }
    Item {
        id: container;
        height: paneSize;
        anchors.topMargin: ((tabSize + Style.lineSize) * (tabs.indexOf (currentTab) +1));
        ExtraAnchors.topDock: parent;

        // NOTE : tabs content here
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
                                   ? Style.gradientShaded (Style.colorHighlight, Style.colorSecondary)
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
                Binding {
                    target: modelData ["anchors"];
                    property: "fill";
                    value: container;
                }
                Binding {
                    target: modelData;
                    property: "visible";
                    value: (modelData === currentTab);
                }
                Stretcher {
                    id: placeholder;
                    height: paneSize;
                    visible: (modelData === currentTab);
                    ExtraAnchors.horizontalFill: parent;
                }
                Line { ExtraAnchors.horizontalFill: parent; }
            }
        }
    }
}
