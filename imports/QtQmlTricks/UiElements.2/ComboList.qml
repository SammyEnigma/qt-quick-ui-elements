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

    Column {
        id: dumbLayout;

        Repeater {
            model: base.model;
            delegate: TextLabel {
                text: model.value;
                color: "transparent";
            }
        }
    }
    MouseArea {
        id: clicker;
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
            dropdownItem = compoDropdown.createObject (rootItem, { "referenceItem" : base });
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
        antialiasing: true;
        gradient: (enabled
                   ? (clicker.pressed ||
                      clicker.dropdownItem
                      ? Style.gradientPressed ()
                      : Style.gradientIdle ())
                   : Style.gradientDisabled ());
        border {
            width: Style.lineSize;
            color: Style.colorGray;
        }
        anchors.fill: parent;
    }
    TextLabel {
        id: lbl;
        text: (currentValue || "");
        elide: Text.ElideRight;
        visible: (text !== "");
        anchors {
            left: parent.left;
            right: arrow.left;
            margins: padding;
            verticalCenter: parent.verticalCenter;
        }
    }
    Item {
        id: arrow;
        clip: true;
        width: Style.fontSizeNormal;
        height: (width / 2);
        anchors {
            right: parent.right;
            margins: padding;
            verticalCenter: parent.verticalCenter;
        }

        Rectangle {
            color: (enabled ? Style.colorBlack : Style.colorGray);
            width: (parent.height * Math.SQRT2);
            height: width;
            rotation: 45;
            antialiasing: true;
            anchors {
                verticalCenter: parent.top;
                horizontalCenter: parent.horizontalCenter;
            }
        }
    }
    Component {
        id: compoDropdown;

        MouseArea {
            id: dimmer;
            anchors.fill: parent;
            onWheel: { }
            onPressed: { clicker.destroyDropdown (); }

            property Item referenceItem : null;

            Rectangle {
                color: "lightgray";
                height: Math.max (layout.height, (Style.fontSizeNormal + Style.spacingNormal * 2));
                border {
                    width: Style.lineSize;
                    color: Style.colorGray;
                }
                Component.onCompleted: {
                    if (dimmer.referenceItem) {
                        var pos = mapFromItem (dimmer.referenceItem.parent,
                                               dimmer.referenceItem.x,
                                               dimmer.referenceItem.y +
                                               dimmer.referenceItem.height);
                        width = dimmer.referenceItem.width;
                        x = pos ["x"];
                        y = pos ["y"];
                    }
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
