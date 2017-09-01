import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

AutoRepeatableClicker {
    id: clicker;
    width: implicitWidth;
    height: implicitHeight;
    hoverEnabled: Style.useHovering;
    implicitWidth: contentWidth;
    implicitHeight: contentHeight;
    states: [
        State {
            name: "icon_and_text";
            when: (ico.visible && lbl.visible && !invertLayout);

            PropertyChanges {
                target: clicker;
                contentWidth: Math.ceil (ico.width + lbl.contentWidth + padding * 3);
                contentHeight: Math.ceil (ico.height > lbl.contentHeight
                                          ? ico.height + padding * 2
                                          : lbl.contentHeight + padding * 2);
            }
            AnchorChanges {
                target: ico;
                anchors {
                    left: parent.left;
                    verticalCenter: parent.verticalCenter;
                }
            }
            AnchorChanges {
                target: lbl;
                anchors {
                    left: ico.right;
                    right: parent.right;
                    verticalCenter: parent.verticalCenter;
                }
            }
        },
        State {
            name: "text_and_icon";
            when: (ico.visible && lbl.visible && invertLayout);

            PropertyChanges {
                target: clicker;
                contentWidth: Math.ceil (ico.width + lbl.contentWidth + padding * 3);
                contentHeight: Math.ceil (ico.height > lbl.contentHeight
                                          ? ico.height + padding * 2
                                          : lbl.contentHeight + padding * 2);
            }
            AnchorChanges {
                target: lbl;
                anchors {
                    left: parent.left;
                    right: ico.left;
                    verticalCenter: parent.verticalCenter;
                }
            }
            AnchorChanges {
                target: ico;
                anchors {
                    right: parent.right;
                    verticalCenter: parent.verticalCenter;
                }
            }
        },
        State {
            name: "text_only";
            when: (!ico.visible && lbl.visible);

            PropertyChanges {
                target: clicker;
                contentWidth: Math.ceil (Math.max (lbl.contentWidth + padding * 2, contentHeight));
                contentHeight: Math.ceil (lbl.contentHeight + padding * 2);
            }
            AnchorChanges {
                target: lbl;
                anchors {
                    verticalCenter: parent.verticalCenter;
                    horizontalCenter: parent.horizontalCenter;
                }
            }
        },
        State {
            name: "icon_only";
            when: (ico.visible && !lbl.visible);

            PropertyChanges {
                target: clicker;
                contentWidth: Math.ceil (ico.width + padding * 2);
                contentHeight: Math.ceil (ico.height + padding * 2);
            }
            AnchorChanges {
                target: ico;
                anchors {
                    verticalCenter: parent.verticalCenter;
                    horizontalCenter: parent.horizontalCenter;
                }
            }
        },
        State {
            name: "empty";
            when: (!ico.visible && !lbl.visible);

            PropertyChanges {
                target: clicker;
                contentWidth: 0;
                contentHeight: 0;
            }
        }
    ]

    property int   padding       : Style.spacingNormal;
    property bool  flat          : false;
    property bool  checked       : false;
    property bool  autoColorIcon : true;
    property bool  invertLayout  : false;
    property alias text          : lbl.text;
    property alias textFont      : lbl.font;
    property alias rounding      : rect.radius;
    property alias icon          : ico.sourceComponent;
    property alias hovered       : clicker.containsMouse;
    property int   contentWidth  : 0;
    property int   contentHeight : 0;
    property color backColor     : Style.colorClickable;
    property color textColor     : (Style.useDarkTheme !== Style.isDark (backColor)
                                    ? Style.colorInverted
                                    : Style.colorForeground);

    function click (isAutoRepeat) {
        if (enabled) {
            clicked (isAutoRepeat);
        }
    }

    Binding {
        target: (ico.item && "color" in ico.item ? ico.item : null);
        when: (autoColorIcon && ico.item)
        property: "color";
        value: textColor;
    }
    PixelPerfectContainer {
        contentItem: rect;
        anchors.fill: parent;

        Rectangle {
            id: rect;
            width: Math.round (parent.width);
            height: Math.round (parent.height);
            enabled: clicker.enabled;
            radius: Style.roundness;
            antialiasing: radius;
            gradient: (enabled
                       ? (checked
                          ? Style.gradientChecked ()
                          : (pressed
                             ? Style.gradientPressed (Style.opacify (backColor, flat ? 0.35 : 1.0))
                             : Style.gradientIdle (flat ? Style.colorNone : Qt.lighter (backColor, hovered ? 1.15 : 1.0))))
                       : Style.gradientDisabled (flat ? Style.colorNone : Style.colorClickable));
            border {
                width: (!flat || pressed || checked || hovered ? Style.lineSize : 0);
                color: (checked ? Style.colorSelection : Style.colorBorder);
            }
        }
    }
    Loader {
        id: ico;
        active: (sourceComponent !== null);
        enabled: clicker.enabled;
        visible: (item !== null);
        anchors.margins: padding;
    }
    TextLabel {
        id: lbl;
        color: (enabled
                ? (checked
                   ? (Style.useDarkTheme
                      ? Qt.lighter (Style.colorSelection)
                      : Qt.darker  (Style.colorSelection))
                   : textColor)
                : Style.colorBorder);
        enabled: clicker.enabled;
        visible: (text !== "");
        horizontalAlignment: (ico.visible ? Text.AlignLeft : Text.AlignHCenter);
        font {
            family: Style.fontName;
            pixelSize: Style.fontSizeNormal;
        }
        anchors.margins: padding;
    }
}
