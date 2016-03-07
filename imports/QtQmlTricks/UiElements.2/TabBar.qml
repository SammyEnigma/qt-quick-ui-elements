import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: base;

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

    Group { id: testGroup; }
    Rectangle {
        id: rect;
        color: Style.colorSecondary;
        anchors.bottom: bar.bottom;
        ExtraAnchors.topDock: parent;
    }
    Line {
        anchors {
            leftMargin: -bar.colSpacing;
            rightMargin: -bar.colSpacing;
        }
        ExtraAnchors.bottomDock: bar;
    }
    GridContainer {
        id: bar;
        clip: true;
        cols: capacity;
        capacity: tabs.length;
        colSpacing: Style.spacingSmall;
        anchors.margins: colSpacing;
        ExtraAnchors.topDock: parent;

        Repeater {
            model: tabs;
            delegate: MouseArea {
                id: clicker;
                implicitHeight: (Style.spacingBig * 2);
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
                onClicked: { currentTab = modelData; }

                Rectangle {
                    radius: Style.roundness;
                    visible: (currentTab === modelData || clicker.pressed);
                    gradient: (clicker.pressed ? Style.gradientPressed () : Style.gradientShaded ());
                    antialiasing: radius;
                    border {
                        width: Style.lineSize;
                        color: Style.colorBorder;
                    }
                    states: State {
                        when: (modelData !== null);

                        PropertyChanges {
                            target: modelData;
                            visible: (currentTab === modelData);
                            anchors.fill: container;
                        }
                    }
                    anchors {
                        fill: parent;
                        bottomMargin: -radius;
                    }
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
        }
    }
    FocusScope {
        id: container;
        anchors.top: bar.bottom;
        ExtraAnchors.bottomDock: parent;

        // NOTE : CONTENT HERE
    }
}
