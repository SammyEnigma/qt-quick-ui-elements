pragma Singleton;
import QtQuick 2.0;

QtObject {
    id: style;

    property int lineSize : 1;

    property int roundness : 3;

    property int spacingSmall  :  3;
    property int spacingNormal :  6;
    property int spacingBig    : 12;

    property int fontSizeSmall  : 11;
    property int fontSizeNormal : 14;
    property int fontSizeBig    : 16;
    property int fontSizeTitle  : 18;

    property color colorNone      : "transparent";
    property color colorWhite     : "white";
    property color colorLightGray : "lightgray";
    property color colorDarkGray  : "darkgray";
    property color colorGray      : "gray";
    property color colorBlack     : "black";
    property color colorDarkRed   : "darkred";
    property color colorOrange    : "orange";
    property color colorSteelBlue : "steelblue";
    property color colorDarkBlue  : "darkblue";
    property color colorLightBlue : "lightblue";

    readonly property string fontName : selectFont ([
                                                        "Sail Sans Pro",
                                                        "Source Sans Pro",
                                                        "Ubuntu",
                                                        "Roboto",
                                                        "Droid Sans",
                                                        "Liberation Sans",
                                                        "Trebuchet MS",
                                                        "Deja Vu Sans",
                                                        "Tahoma",
                                                        "Arial",
                                                    ],
                                                    "sans-serif");

    readonly property string fontFixedName : selectFont ([
                                                             "Ubuntu Mono",
                                                             "Deja Vu Mono",
                                                             "Courier New",
                                                             "Lucida Console",
                                                         ],
                                                         "monospace");

    property Component symbolCross : Component {
        Item {
            id: cross;
            width: size;
            height: size;

            property real  size  : 10;
            property color color : "magenta";

            Rectangle {
                color: cross.color;
                width: cross.size;
                height: (cross.size * 0.15);
                rotation: +45;
                radius: (cross.size * 0.05);
                antialiasing: radius;
                anchors.centerIn: parent;
                anchors.alignWhenCentered: false;
            }
            Rectangle {
                color: cross.color;
                width: cross.size;
                height: (cross.size * 0.15);
                rotation: -45;
                radius: (cross.size * 0.05);
                antialiasing: radius;
                anchors.centerIn: parent;
                anchors.alignWhenCentered: false;
            }
        }
    }

    property Component symbolPlus : Component {
        Item {
            id: plus;
            width: size;
            height: size;

            property real  size  : 10;
            property color color : "magenta";

            Rectangle {
                color: plus.color;
                width: plus.size;
                height: (plus.size * 0.15);
                radius: (plus.size * 0.05);
                antialiasing: radius;
                anchors.centerIn: parent;
                anchors.alignWhenCentered: false;
            }
            Rectangle {
                color: plus.color;
                width: (plus.size * 0.15);
                height: plus.size;
                radius: (plus.size * 0.05);
                antialiasing: radius;
                anchors.centerIn: parent;
                anchors.alignWhenCentered: false;
            }
        }
    }

    property Component symbolMinus : Component {
        Item {
            id: minus;
            width: size;
            height: size;

            property real  size  : 10;
            property color color : "magenta";

            Rectangle {
                color: minus.color;
                width: minus.size;
                height: (minus.size * 0.15);
                radius: (minus.size * 0.05);
                antialiasing: radius;
                anchors.centerIn: parent;
                anchors.alignWhenCentered: false;
            }
        }
    }

    property Component symbolCheck : Component {
        Item {
            id: check;
            width: size;
            height: size;

            property real  size  : 10;
            property color color : "magenta";

            readonly property real section  : (size * 0.10);
            readonly property real diagonal : (Math.SQRT2 * section);

            Rectangle {
                id: small;
                color: check.color;
                width: (check.diagonal * 3);
                height: check.diagonal;
                rotation: +45;
                radius: (check.diagonal / 5);
                antialiasing: radius;
                anchors {
                    centerIn: parent;
                    alignWhenCentered: false;
                    verticalCenterOffset: check.section;
                    horizontalCenterOffset: (-2 * check.section);
                }
            }
            Rectangle {
                id: big;
                color: check.color;
                width: (check.diagonal * 5);
                height: check.diagonal;
                rotation: -45;
                radius: (check.diagonal / 5);
                antialiasing: radius;
                anchors {
                    centerIn: parent;
                    alignWhenCentered: false;
                    horizontalCenterOffset: check.section;
                }
            }
        }
    }

    property Component symbolArrowDown : Component {
        Item {
            id: arrow;
            width: size;
            height: size;

            property real  size  : 10;
            property color color : "magenta";

            Item {
                clip: true;
                width: arrow.size;
                height: (arrow.size / 2);
                anchors.centerIn: parent;

                Rectangle {
                    color: arrow.color;
                    width: (arrow.size * Math.SQRT2 / 2);
                    height: width;
                    rotation: 45;
                    antialiasing: true;
                    anchors {
                        verticalCenter: parent.top;
                        horizontalCenter: parent.horizontalCenter;
                        alignWhenCentered: false;
                    }
                }
            }
        }
    }

    property Component symbolArrowUp : Component {
        Item {
            id: arrow;
            width: size;
            height: size;

            property real  size  : 10;
            property color color : "magenta";

            Item {
                clip: true;
                width: arrow.size;
                height: (arrow.size / 2);
                anchors.centerIn: parent;

                Rectangle {
                    color: arrow.color;
                    width: (arrow.size * Math.SQRT2 / 2);
                    height: width;
                    rotation: 45;
                    antialiasing: true;
                    anchors {
                        verticalCenter: parent.bottom;
                        horizontalCenter: parent.horizontalCenter;
                        alignWhenCentered: false;
                    }
                }
            }
        }
    }

    property Component symbolArrowLeft : Component {
        Item {
            id: arrow;
            width: size;
            height: size;

            property real  size  : 10;
            property color color : "magenta";

            Item {
                clip: true;
                width: (arrow.size / 2);
                height: arrow.size;
                anchors.centerIn: parent;

                Rectangle {
                    color: arrow.color;
                    width: (arrow.size * Math.SQRT2 / 2);
                    height: width;
                    rotation: 45;
                    antialiasing: true;
                    anchors {
                        verticalCenter: parent.verticalCenter;
                        horizontalCenter: parent.right;
                        alignWhenCentered: false;
                    }
                }
            }
        }
    }

    property Component symbolArrowRight : Component {
        Item {
            id: arrow;
            width: size;
            height: size;

            property real  size  : 10;
            property color color : "magenta";

            Item {
                clip: true;
                width: (arrow.size / 2);
                height: arrow.size;
                anchors.centerIn: parent;

                Rectangle {
                    color: arrow.color;
                    width: (arrow.size * Math.SQRT2 / 2);
                    height: width;
                    rotation: 45;
                    antialiasing: true;
                    anchors {
                        verticalCenter: parent.verticalCenter;
                        horizontalCenter: parent.left;
                        alignWhenCentered: false;
                    }
                }
            }
        }
    }

    property Component templateGradientSunken : Component {
        Gradient {
            id: autogradient;

            property color baseColor : "magenta";

            GradientStop { color: Qt.darker  (autogradient.baseColor, 1.15); position: 0.0; }
            GradientStop { color: Qt.lighter (autogradient.baseColor, 1.15); position: 1.0; }
        }
    }
    property Component templateGradientRaised : Component {
        Gradient {
            id: autogradient;

            property color baseColor : "magenta";

            GradientStop { color: Qt.lighter (autogradient.baseColor, 1.15); position: 0.0; }
            GradientStop { color: Qt.darker  (autogradient.baseColor, 1.15); position: 1.0; }
        }
    }
    property Component templateGradientFlat : Component {
        Gradient {
            id: autogradient;

            property color baseColor : "magenta";

            GradientStop { color: autogradient.baseColor; position: 0.0; }
            GradientStop { color: autogradient.baseColor; position: 1.0; }
        }
    }
    property Component templateGradientShaded : Component {
        Gradient {
            id: autogradient;

            property color baseColorTop    : "magenta";
            property color baseColorBottom : "magenta";

            GradientStop { color: autogradient.baseColorTop;    position: 0.0; }
            GradientStop { color: autogradient.baseColorBottom; position: 1.0; }
        }
    }

    function gray (val) {
        var tmp = (val / 255);
        return Qt.rgba (tmp, tmp, tmp, 1.0);
    }

    function opacify (tint, alpha) {
        var tmp = Qt.darker (tint, 1.0);
        return Qt.rgba (tmp.r, tmp.g, tmp.b, alpha);
    }

    function selectFont (list, fallback) {
        var ret;
        var all = Qt.fontFamilies ();
        for (var idx = 0; idx < list.length; idx++) {
            var tmp = list [idx];
            if (all.indexOf (tmp) >= 0) {
                ret = tmp;
                break;
            }
        }
        return (ret || fallback);
    }

    property Item garbage : Item { }

    function generateGradient (template, baseColor) {
        return template.createObject (garbage, { "baseColor" : baseColor });
    }

    function gradientIdle (baseColor) {
        return generateGradient (templateGradientRaised, baseColor || colorLightGray);
    }

    function gradientPressed (baseColor) {
        return generateGradient (templateGradientSunken, baseColor || colorDarkGray);
    }

    function gradientChecked (baseColor) {
        return generateGradient (templateGradientSunken, baseColor || colorLightBlue);
    }

    function gradientDisabled (baseColor) {
        return generateGradient (templateGradientFlat, baseColor || colorLightGray);
    }

    function gradientEditable (baseColor) {
        return generateGradient (templateGradientFlat, baseColor || colorWhite);
    }

    function gradientShaded (baseColorTop, baseColorBottom) {
        return templateGradientShaded.createObject (garbage, {
                                                        "baseColorTop"    : (baseColorTop    || colorLightBlue),
                                                        "baseColorBottom" : (baseColorBottom || colorLightGray),
                                                    });
    }
}
