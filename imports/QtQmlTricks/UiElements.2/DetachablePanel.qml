import QtQuick 2.1;
import QtQuick.Window 2.1;
import QtQmlTricks.UiElements 2.0;

Group {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    visible: !detached;
    implicitWidth: size;
    implicitHeight: size;

    property int size : Style.realPixels (250);

    property int borderSide : Item.Right;

    default property alias content : panel.data;

    readonly property bool detached : (priv.instance !== null);

    QtObject {
        id: priv;

        property Window instance : null;

        function createInstance () {
            if (instance === null) {
                var rootItem = Introspector.window (base);
                var abspos = rootItem.contentItem.mapFromItem (base, 0 , 0);
                instance = compoWindow.createObject (Introspector.window (base), {
                                                         "x" : (abspos.x + rootItem.x),
                                                         "y" : (abspos.y + rootItem.y),
                                                     });
                panel.parent = instance.contentItem;
            }
        }

        function destroyInstance () {
            if (instance !== null) {
                panel.parent = container;
                instance.destroy ();
            }
        }
    }
    Component {
        id: compoWindow;

        Window {
            title: base.title;
            color: container.color;
            width: container.width;
            height: container.height;
            visible: true;
            onClosing: { priv.destroyInstance (); }
        }
    }
    Rectangle {
        id: header;
        height: (layout.implicitHeight + layout.anchors.margins * 2);
        gradient: Style.gradientShaded (Style.colorHighlight, Style.colorSecondary);
        ExtraAnchors.topDock: parent;

        StretchRowContainer {
            id: layout;
            spacing: Style.spacingNormal;
            anchors {
                margins: Style.spacingNormal;
                verticalCenter: parent.verticalCenter;
            }
            ExtraAnchors.horizontalFill: parent;

            TextLabel {
                text: base.title;
                anchors.verticalCenter: parent.verticalCenter;
            }
            Stretcher { }
            TextButton {
                flat: true;
                icon: SvgIconLoader {
                    icon: "actions/fullscreen";
                    size: Style.fontSizeBig;
                    color: Style.colorForeground;
                }
                padding: (Style.lineSize * 2);
                anchors.verticalCenter: parent.verticalCenter;
                onClicked: { priv.createInstance (); }
            }
        }
    }
    Rectangle {
        id: container;
        color: Style.colorSecondary;
        anchors.top: header.bottom;
        ExtraAnchors.bottomDock: parent;

        Item {
            id: panel;
            anchors.fill: parent;

            // CONTENT HERE
        }
    }
    Line {
        id: line;
        states: [
            State {
                when: (borderSide === Item.Top);

                AnchorChanges {
                    target: line;
                    anchors {
                        top: base.top;
                        left: base.left;
                        right: base.right;
                    }
                }
            },
            State {
                when: (borderSide === Item.Left);

                AnchorChanges {
                    target: line;
                    anchors {
                        top: base.top;
                        left: base.left;
                        bottom: base.bottom;
                    }
                }
            },
            State {
                when: (borderSide === Item.Right);

                AnchorChanges {
                    target: line;
                    anchors {
                        top: base.top;
                        right: base.right;
                        bottom: base.bottom;
                    }
                }
            },
            State {
                when: (borderSide === Item.Bottom);

                AnchorChanges {
                    target: line;
                    anchors {
                        left: base.left;
                        right: base.right;
                        bottom: base.bottom;
                    }
                }
            }
        ]
    }
}
