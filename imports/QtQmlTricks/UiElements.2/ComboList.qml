import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    implicitWidth: (dumbLayout.width + arrow.width + padding * 3);
    implicitHeight: (lbl.contentHeight + padding * 2);

    property int   padding   : Style.spacingNormal;
    property alias textColor : lbl.color;
    property alias backColor : rect.color;
    property alias rounding  : rect.radius;

    property ListModel model : null;

    property int          currentIdx   : -1;
    readonly property var currentValue : (model && currentIdx >= 0 && currentIdx < model.count ? model.get (currentIdx) ["value"] : undefined);
    readonly property var currentKey   : (model && currentIdx >= 0 && currentIdx < model.count ? model.get (currentIdx) ["key"]   : undefined);

    function selectByKey (key) {
        if (model !== null) {
            var tmp = -1;
            for (var idx = 0; idx < model.count; idx++) {
                if (model.get (idx) ["key"] === key) {
                    tmp = idx;
                    break;
                }
            }
            currentIdx = tmp;
        }
    }

    Column {
        id: dumbLayout;

        Repeater {
            model: base.model;
            delegate: TextLabel {
                text: model.value;
                color: Style.colorNone;
            }
        }
    }
    MouseArea {
        id: clicker;
        enabled: base.enabled;
        anchors.fill: parent;
        onClicked: {
            if (dropdownItem) {
                destroyDropdown ();
            }
            else {
                createDropdown ();
            }
        }
        Component.onDestruction: { destroyDropdown (); }

        property Item dropdownItem : null;

        readonly property Item rootItem : {
            var tmp = base;
            while ("parent" in tmp && tmp ["parent"] !== null && "visible" in tmp ["parent"]) {
                tmp = tmp ["parent"];
            }
            return tmp;
        }

        function createDropdown () {
            dropdownItem = compoDropdown.createObject (rootItem, { "refItem" : base });
        }

        function destroyDropdown () {
            if (dropdownItem) {
                dropdownItem.destroy ();
                dropdownItem = null;
            }
        }
    }
    Rectangle {
        id: rect;
        radius: Style.roundness;
        enabled: base.enabled;
        antialiasing: true;
        gradient: (enabled
                   ? (clicker.pressed ||
                      clicker.dropdownItem
                      ? Style.gradientPressed ()
                      : Style.gradientIdle ())
                   : Style.gradientDisabled ());
        border {
            width: Style.lineSize;
            color: Style.colorBorder;
        }
        anchors.fill: parent;
    }
    TextLabel {
        id: lbl;
        text: (currentValue || "");
        elide: Text.ElideRight;
        enabled: base.enabled;
        visible: (text !== "");
        anchors {
            left: parent.left;
            right: arrow.left;
            margins: padding;
            verticalCenter: parent.verticalCenter;
        }
    }
    Loader {
        id: arrow;
        enabled: base.enabled;
        sourceComponent: Style.symbolArrowDown;
        anchors {
            right: parent.right;
            margins: padding;
            verticalCenter: parent.verticalCenter;
        }
        states: State {
            when: (arrow.item !== null);

            PropertyChanges {
                target: arrow.item;
                size: Style.fontSizeNormal;
                color: (enabled ? Style.colorForeground : Style.colorBorder);
            }
        }
    }
    Component {
        id: compoDropdown;

        MouseArea {
            id: dimmer;
            anchors.fill: parent;
            states: State {
                when: (dimmer.refItem !== null);

                PropertyChanges {
                    target: frame;
                    x: (frame.mapFromItem (dimmer.refItem.parent, dimmer.refItem.x, 0) ["x"] || 0);
                    y: (frame.mapFromItem (dimmer.refItem.parent, 0, dimmer.refItem.y + dimmer.refItem.height -1) ["y"] || 0);
                    width: dimmer.refItem.width;
                }
            }
            onWheel: { }
            onPressed: { clicker.destroyDropdown (); }
            onReleased: { }

            property Item refItem : null;

            Rectangle {
                id: frame;
                color: Style.colorWindow;
                height: Math.max (layout.height, (Style.fontSizeNormal + Style.spacingNormal * 2));
                border {
                    width: Style.lineSize;
                    color: Style.colorBorder;
                }

                Column {
                    id: layout;
                    anchors {
                        top: parent.top;
                        left: parent.left;
                        right: parent.right;
                    }

                    Repeater {
                        model: base.model;
                        delegate: MouseArea {
                            height: (label.height + label.anchors.margins * 2);
                            anchors {
                                left: layout.left;
                                right: layout.right;
                            }
                            onClicked: {
                                currentIdx = model.index;
                                clicker.destroyDropdown ();
                            }

                            TextLabel {
                                id: label;
                                clip: true;
                                text: (model ["value"] || "");
                                font.bold: (model.index === currentIdx);
                                anchors {
                                    left: parent.left;
                                    right: parent.right;
                                    margins: padding;
                                    verticalCenter: parent.verticalCenter;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
