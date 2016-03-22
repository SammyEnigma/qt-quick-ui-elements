import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    implicitWidth: size;
    implicitHeight: size;

    property int size       : Style.realPixels (250);
    property int handleSize : Style.spacingBig;
    property int handleSide : Item.Right;

    default property alias content : container.data;

    Rectangle {
        color: Style.colorSecondary;
        anchors.fill: parent;
    }
    Item {
        id: container;
        anchors {
            fill: parent;
            topMargin: (handleSide === Item.Top ? handleSize : 0);
            leftMargin: (handleSide === Item.Left ? handleSize : 0);
            rightMargin: (handleSide === Item.Right ? handleSize : 0);
            bottomMargin: (handleSide === Item.Bbottom ? handleSize : 0);
        }

        // CONTENT HERE
    }
    MouseArea {
        id: handle;
        states: [
            State {
                when: (handleSide === Item.Top);

                AnchorChanges {
                    target: handle;
                    anchors {
                        top: base.top;
                        left: base.left;
                        right: base.right;
                        bottom: undefined;
                    }
                }
                PropertyChanges {
                    target: handle;
                    height: handleSize;
                    cursorShape: Qt.SizeVerCursor;
                }
            },
            State {
                when: (handleSide === Item.Left);

                AnchorChanges {
                    target: handle;
                    anchors {
                        top: base.top;
                        left: base.left;
                        right: undefined;
                        bottom: base.bottom;
                    }
                }
                PropertyChanges {
                    target: handle;
                    width: handleSize;
                    cursorShape: Qt.SizeHorCursor;
                }
            },
            State {
                when: (handleSide === Item.Right);

                AnchorChanges {
                    target: handle;
                    anchors {
                        top: base.top;
                        left: undefined;
                        right: base.right;
                        bottom: base.bottom;
                    }
                }
                PropertyChanges {
                    target: handle;
                    width: handleSize;
                    cursorShape: Qt.SizeHorCursor;
                }
            },
            State {
                when: (handleSide === Item.Bottom);

                AnchorChanges {
                    target: handle;
                    anchors {
                        top: undefined;
                        left: base.left;
                        right: base.right;
                        bottom: base.bottom;
                    }
                }
                PropertyChanges {
                    target: handle;
                    height: handleSize;
                    cursorShape: Qt.SizeVerCursor;
                }
            }
        ]
        onPressed: {
            lastPos = Qt.point (mouse.x, mouse.y);
        }
        onPositionChanged: {
            var delta = Qt.point (mouse.x - lastPos.x, mouse.y - lastPos.y);
            switch (handleSide) {
            case Item.Top:
                size -= delta.y;
                break;
            case Item.Left:
                size -= delta.x;
                break;
            case Item.Right:
                size += delta.x;
                break;
            case Item.Bottom:
                size += delta.y;
                break;
            }
            lastPos = Qt.point (mouse.x, mouse.y);
        }

        property point lastPos;

        Rectangle {
            id: rect;
            gradient: (handle.pressed
                       ? Style.gradientShaded (Style.colorHighlight, Style.colorSecondary)
                       : Style.gradientShaded (Style.colorClickable, Style.colorSecondary));
            anchors.centerIn: parent;
            states: [
                State {
                    when: (handleSide === Item.Top);

                    PropertyChanges {
                        target: rect;
                        width: handle.width;
                        height: handle.height;
                        rotation: 0;
                    }
                },
                State {
                    when: (handleSide === Item.Left);

                    PropertyChanges {
                        target: rect;
                        width: handle.height;
                        height: handle.width;
                        rotation: 270;
                    }
                },
                State {
                    when: (handleSide === Item.Right);

                    PropertyChanges {
                        target: rect;
                        width: handle.height;
                        height: handle.width;
                        rotation: 90;
                    }
                },
                State {
                    when: (handleSide === Item.Bottom);

                    PropertyChanges {
                        target: rect;
                        width: handle.width;
                        height: handle.height;
                        rotation: 180;
                    }
                }
            ]
        }
    }
    Line {
        id: line;
        states: [
            State {
                when: (handleSide === Item.Top);

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
                when: (handleSide === Item.Left);

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
                when: (handleSide === Item.Right);

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
                when: (handleSide === Item.Bottom);

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
