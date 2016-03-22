import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: base;

    property alias background : rect.color;

    property int extraPaddingBeforeTabs : 0;
    property int extraPaddingAfterTabs  : 0;

    property Group currentTab : null;

    default property alias content : container.children;

    readonly property int tabsSize : (Style.spacingBig * 2);

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
        anchors.bottom: bar.bottom;
        ExtraAnchors.horizontalFill: parent;
    }
    GridContainer {
        id: bar;
        clip: true;
        cols: capacity;
        capacity: tabs.length;
        colSpacing: Style.spacingSmall;
        anchors {
            topMargin: bar.colSpacing;
            leftMargin: (bar.colSpacing + extraPaddingBeforeTabs);
            rightMargin: (bar.colSpacing + extraPaddingAfterTabs);
        }
        ExtraAnchors.topDock: parent;

        Repeater {
            model: tabs;
            delegate: MouseArea {
                id: clicker;
                implicitHeight: tabsSize;
                states: [
                    State {
                        name: "text_and_icon";
                        when: (clicker.group.icon !== null);

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
                        when: (clicker.group.icon === null);

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

                readonly property Group group : modelData;

                Rectangle {
                    radius: Style.roundness;
                    visible: (currentTab === clicker.group || clicker.pressed);
                    gradient: (clicker.pressed ? Style.gradientPressed () : Style.gradientShaded ());
                    antialiasing: radius;
                    border {
                        width: Style.lineSize;
                        color: Style.colorBorder;
                    }
                    states: State {
                        when: (clicker.group !== null);

                        PropertyChanges {
                            target: clicker.group;
                            visible: (currentTab === clicker.group);
                            anchors.fill: container;
                        }
                    }
                    anchors {
                        fill: parent;
                        bottomMargin: -radius;
                    }
                }
                Loader {
                    id: ico;
                    enabled: clicker.enabled;
                    sourceComponent: clicker.group.icon;
                    anchors.margins: Style.spacingNormal;
                }
                TextLabel {
                    id: lbl;
                    text: clicker.group.title;
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
