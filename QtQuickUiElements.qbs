import qbs;

Project {
    name: "QtQuick UI Elements";

    Product {
        name: "libqtqmltricks-qtquickuielements";
        type: "staticlibrary";
        targetName: "QtQuickUiElements";

        Export {
            cpp.includePaths: ".";

            Depends { name: "cpp"; }
            Depends {
                name: "Qt";
                submodules: ["core", "gui", "qml", "quick", "svg"];
            }
        }
        Depends { name: "cpp"; }
        Depends {
            name: "Qt";
            submodules: ["core", "gui", "qml", "quick", "svg"];
        }
        Group {
            name: "C++ sources";
            files: [
                "QQuickGridContainer.cpp",
                "QQuickPolygon.cpp",
                "QQuickStretchColumnContainer.cpp",
                "QQuickStretchRowContainer.cpp",
                "QQuickSvgIconHelper.cpp",
                "QQuickWrapLeftRightContainer.cpp",
            ]
        }
        Group {
            name: "C++ headers";
            files: [
                "QQuickGridContainer.h",
                "QQuickPolygon.h",
                "QQuickStretchColumnContainer.h",
                "QQuickStretchRowContainer.h",
                "QQuickSvgIconHelper.h",
                "QQuickWrapLeftRightContainer.h",
                "QtQmlTricksPlugin.h",
            ]
        }
        Group {
            name: "QML components";
            files: [
                "Style.qml",
                "ComboList.qml",
                "IconTextButton.qml",
                "ScrollContainer.qml",
                "SingleLineEditBox.qml",
                "TextBox.qml",
                "TextButton.qml",
                "TextLabel.qml",
            ]
        }
        Group {
            name: "Qt resources bundle";
            files: [
                "qtqmltricksuielements.qrc",
            ]
        }
        Group {
            qbs.install: true;
            fileTagsFilter: product.type;
        }
    }
}
