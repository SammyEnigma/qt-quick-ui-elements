import QtQuick 2.1;
import QtQmlTricks.UiElements 2.0;

Item {
    id: base;
    width: implicitWidth;
    height: implicitHeight;
    implicitWidth: (dumbLayout.width + arrow.width + padding * 3);
    implicitHeight: (loaderCurrent.height + padding * 2);

    property int   padding    : Style.spacingNormal;
    property bool  filterable : false;
    property alias rounding   : rect.radius;
    property alias backColor  : rect.color;

    property var       model      : undefined;
    property Component delegate   : ComboListDelegateForModelWithRoles { }

    property int currentIdx : -1;

    readonly property int count : repeater.count;

    readonly property var currentValue : ((currentIdx >= 0 && currentIdx < repeater.count)
                                          ? repeater.itemAt (currentIdx) ["value"]
                                          : undefined);

    readonly property var currentKey   : ((currentIdx >= 0 && currentIdx < repeater.count)
                                          ? repeater.itemAt (currentIdx) ["key"]
                                          : undefined);

    function selectByKey (key) {
        var ret = false;
        for (var idx = 0; idx < repeater.count; ++idx) {
            var item = repeater.itemAt (idx);
            if (item ["key"] === key) {
                currentIdx = idx;
                ret = true;
                break;
            }
        }
        return ret;
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
        hoverEnabled: Style.useHovering;
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

        function createDropdown () {
            dropdownItem = compoDropdown.createObject (Introspector.window (base), { });
        }

        function destroyDropdown () {
            if (dropdownItem) {
                dropdownItem.destroy ();
                dropdownItem = null;
            }
        }
    }
    PixelPerfectContainer {
        contentItem: rect;
        anchors.fill: parent;

        Rectangle {
            id: rect;
            width: Math.round (parent.width);
            height: Math.round (parent.height);
            radius: Style.roundness;
            enabled: base.enabled;
            antialiasing: radius;
            gradient: (enabled
                       ? (clicker.pressed ||
                          clicker.dropdownItem
                          ? Style.gradientPressed ()
                          : Style.gradientIdle (Qt.lighter (Style.colorClickable, clicker.containsMouse ? 1.15 : 1.0)))
                       : Style.gradientDisabled ());
            border {
                width: Style.lineSize;
                color: Style.colorBorder;
            }
        }
    }
    Loader {
        id: loaderCurrent;
        clip: true;
        enabled: base.enabled;
        sourceComponent: base.delegate;
        anchors {
            left: parent.left;
            right: arrow.left;
            margins: padding;
            verticalCenter: parent.verticalCenter;
        }

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
    SymbolLoader {
        id: arrow;
        size: Style.fontSizeNormal;
        color: (enabled ? Style.colorForeground : Style.colorBorder);
        symbol: Style.symbolArrowDown;
        enabled: base.enabled;
        anchors {
            right: parent.right;
            margins: padding;
            verticalCenter: parent.verticalCenter;
        }
    }
    Component {
        id: compoDropdown;

        MouseArea {
            id: dimmer;
            z: 999999999;
            anchors.fill: parent;
            onWheel: { }
            onPressed: { clicker.destroyDropdown (); }
            onReleased: { }

            Item {
                id: mirror;
                x:      ref ["x"];
                y:      ref ["y"];
                width:  ref ["width"];
                height: ref ["height"];

                readonly property rect ref : (dimmer.width && dimmer.height
                                              ? base.mapToItem (parent, 0, 0, base.width, base.height)
                                              : Qt.rect (0,0,0,0));
            }
            Item {
                id: placeholderAbove;
                anchors {
                    top: dimmer.top;
                    left: mirror.left;
                    right: mirror.right;
                    bottom: mirror.top;
                    topMargin: Style.spacingNormal;
                    bottomMargin: -Style.lineSize;
                }
            }
            Item {
                id: placeholderUnder;
                anchors {
                    top: mirror.bottom;
                    left: mirror.left;
                    right: mirror.right;
                    bottom: dimmer.bottom;
                    topMargin: -Style.lineSize;
                    bottomMargin: Style.spacingNormal;
                }
            }
            Item {
                anchors.fill: frame.place;

                ScrollContainer {
                    id: frame;
                    y: (place === placeholderAbove ? (parent.height - (height * scale)) : 0);
                    width: Math.ceil (base.width);
                    height: (parent.height >= actualSize ? actualSize : parent.height);
                    scale: (mirror.width / base.width);
                    showBorder: true;
                    background: Style.colorWindow;
                    placeholder: (!repeaterDropdown.count ? qsTr ("Nothing here") : "");
                    transformOrigin: Item.TopLeft;

                    readonly property int itemSize    : (Style.fontSizeNormal + padding * 2);
                    readonly property int contentSize : (layout.height  + Style.lineSize * 2);
                    readonly property int minimumSize : ((itemSize * 3) + Style.lineSize * 2);
                    readonly property int actualSize  : Math.max (contentSize, minimumSize);

                    readonly property Item place : {
                        if (placeholderUnder.height >= actualSize) {
                            return placeholderUnder;
                        }
                        else if (placeholderAbove.height >= actualSize) {
                            return placeholderAbove;
                        }
                        else if (placeholderUnder.height >= minimumSize) {
                            return placeholderUnder;
                        }
                        else if (placeholderAbove.height >= minimumSize) {
                            return placeholderAbove;
                        }
                        else {
                            return placeholderUnder;
                        }
                    }

                    Flickable {
                        contentHeight: layout.height;
                        flickableDirection: Flickable.VerticalFlick;

                        StretchColumnContainer {
                            id: layout;
                            ExtraAnchors.topDock: parent;

                            TextBox {
                                id: inputFilter;
                                visible: filterable;
                                hasClear: true;
                                textHolder: qsTr ("Filter...");
                                ExtraAnchors.horizontalFill: parent;
                                Component.onCompleted: {
                                   if (filterable) {
                                       forceActiveFocus ();
                                   }
                                }

                                function matches (str) {
                                    return (isEmpty || (str.toLowerCase ().indexOf (text.toLowerCase ()) >= 0));
                                }
                            }
                            Repeater {
                                id: repeaterDropdown;
                                model: base.model;
                                delegate: MouseArea {
                                    width: implicitWidth;
                                    height: implicitHeight;
                                    visible: inputFilter.matches (loader.instance.value);
                                    hoverEnabled: Style.useHovering;
                                    implicitWidth: (loader.width + padding * 2);
                                    implicitHeight: (loader.height + padding * 2);
                                    onClicked: {
                                        currentIdx = model.index;
                                        clicker.destroyDropdown ();
                                    }
                                    ExtraAnchors.horizontalFill: parent;

                                    Rectangle {
                                        color: Style.colorHighlight;
                                        opacity: 0.65;
                                        visible: parent.containsMouse;
                                        anchors.fill: parent;
                                        anchors.margins: Style.lineSize;
                                    }
                                    Loader {
                                        id: loader;
                                        clip: true;
                                        sourceComponent: base.delegate;
                                        anchors {
                                            margins: padding;
                                            verticalCenter: parent.verticalCenter;
                                        }
                                        ExtraAnchors.horizontalFill: parent;

                                        readonly property ComboListDelegate instance : item;
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
    }
}
