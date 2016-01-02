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
                "QQmlMimeIconsHelper.cpp",
                "QQuickGridContainer.cpp",
                "QQuickPolygon.cpp",
                "QQuickStretchColumnContainer.cpp",
                "QQuickStretchRowContainer.cpp",
                "QQuickSvgIconHelper.cpp",
                "QQuickThemeIconProvider.cpp",
                "QQuickWrapLeftRightContainer.cpp",
            ]
        }
        Group {
            name: "C++ headers";
            files: [
                "QQmlMimeIconsHelper.h",
                "QQuickGridContainer.h",
                "QQuickPolygon.h",
                "QQuickStretchColumnContainer.h",
                "QQuickStretchRowContainer.h",
                "QQuickSvgIconHelper.h",
                "QQuickThemeIconProvider.h",
                "QQuickWrapLeftRightContainer.h",
                "QtQmlTricksPlugin.h",
            ]
        }
        Group {
            name: "QML components";
            files: [
                "FileSelector.qml",
                "Style.qml",
                "ComboList.qml",
                "ScrollContainer.qml",
                "TextBox.qml",
                "TextButton.qml",
                "TextLabel.qml",
            ]
        }
        Group {
            name: "Qt resources bundle";
            files: [
                "qtqmltricksicons.qrc",
                "qtqmltricksuielements.qrc",
            ]
        }
        Group {
            qbs.install: true;
            fileTagsFilter: product.type;
        }
    }
}
