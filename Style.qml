pragma Singleton;
import QtQuick 2.0;

QtObject {
    id: style;

    property int fontSizeSmall  : 11;
    property int fontSizeNormal : 14;
    property int fontSizeBig    : 16;
    property int fontSizeTitle  : 18;

    property color colorGray      : "gray";
    property color colorBlack     : "black";
    property color colorWhite     : "white";
    property color colorDarkGray  : "darkgray";
    property color colorLightGray : "lightgray";
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
}
