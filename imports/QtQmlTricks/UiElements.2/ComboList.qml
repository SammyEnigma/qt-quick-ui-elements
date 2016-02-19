import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    implicitWidth: (dumbLayout.width + arrow.width + padding * 3);
    implicitHeight: (loaderCurrent.height + padding * 2);

    property int   padding   : Style.spacingNormal;
    property alias backColor : rect.color;
    property alias rounding  : rect.radius;

    property var       model      : undefined;
    property Component delegate   : ComboListDelegateForModelWithRoles { }
    property int       currentIdx : -1;

    readonly property var currentValue : (currentIdx >= 0 && currentIdx < repeater.count
                                          ? repeater.itemAt (currentIdx) ["value"]
                                          : undefined);

    readonly property var currentKey   : (currentIdx >= 0 && currentIdx < repeater.count
                                          ? repeater.itemAt (currentIdx) ["key"]
                                          : undefined);

    function selectByKey (key) {
        for (var idx = 0; idx < repeater.count; idx++) {
            var item = repeater.itemAt (idx);
            if (item ["key"] === key) {
                currentIdx = idx;
                break;
            }
        }
    }

    StretchColumnContainer {
        id: dumbLayout;
        opacity: 0;

        Repeater {
            id: repeater;
            model: base.model;
            delegate: Loader {
                id: loader;
                sourceComponent: base.delegate;

                readonly property var value : (item ? item ["value"] : undefined);
                readonly property var key   : (item ? item ["key"]   : undefined);

                Binding {
                    target: loader.item;
                    property: "index";
                    value: model.index;
                }
                Binding {
                    target: loader.item;
                    property: "model";
                    value: (typeof (model) !== "undefined" ? model : undefined);
                }
                Binding {
                    target: loader.item;
                    property: "modelData";
                    value: (typeof (modelData) !== "undefined" ? modelData : undefined);
                }
                Binding {
                    target: loader.item;
                    property: "active";
                    value: true;
                }
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
    Loader {
        id: loaderCurrent;
        enabled: base.enabled;
        sourceComponent: base.delegate;
        anchors {
            left: parent.left;
            right: arrow.left;
            margins: padding;
            verticalCenter: parent.verticalCenter;
        }

        property color color ;

        Binding {
            target: loaderCurrent.item;
            property: "index";
            value: currentIdx;
        }
        Binding {
            target: loaderCurrent.item;
            property: "key";
            value: currentKey;
        }
        Binding {
            target: loaderCurrent.item;
            property: "value";
            value: currentValue;
        }
        Binding {
            target: loaderCurrent.item;
            property: "active";
            value: false;
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

                StretchColumnContainer {
                    id: layout;
                    ExtraAnchors.topDock: parent;

                    Repeater {
                        model: base.model;
                        delegate: MouseArea {
                            width: implicitWidth;
                            height: implicitHeight;
                            implicitWidth: (loader.width + padding * 2);
                            implicitHeight: (loader.height + padding * 2);
                            onClicked: {
                                currentIdx = model.index;
                                clicker.destroyDropdown ();
                            }
                            ExtraAnchors.horizontalFill: parent;

                            Loader {
                                id: loader;
                                sourceComponent: base.delegate;
                                anchors {
                                    margins: padding;
                                    verticalCenter: parent.verticalCenter;
                                }
                                ExtraAnchors.horizontalFill: parent;
                            }
                            Binding {
                                target: loader.item;
                                property: "index";
                                value: model.index;
                            }
                            Binding {
                                target: loader.item;
                                property: "model";
                                value: (typeof (model) !== "undefined" ? model : undefined);
                            }
                            Binding {
                                target: loader.item;
                                property: "modelData";
                                value: (typeof (modelData) !== "undefined" ? modelData : undefined);
                            }
                            Binding {
                                target: loader.item;
                                property: "active";
                                value: (model.index === base.currentIdx);
                            }
                        }
                    }
                }
            }
        }
    }
}
