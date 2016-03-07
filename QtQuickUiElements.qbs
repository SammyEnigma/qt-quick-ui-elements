import qbs;

Project {
    name: "QtQuick UI Elements";

    property bool noQtPrivateLibs : false;

    Product {
        name: "libqtqmltricks-qtquickuielements";
        type: "staticlibrary";
        targetName: "QtQuickUiElements";
        cpp.defines: {
            var ret = [];
            if (project.noQtPrivateLibs) {
                ret.push ("NO_QT_PRIVATE_LIBS=1");
            }
            return ret;
        }

        readonly property stringList qmlImportPaths : [sourceDirectory + "/imports"]; // equivalent to QML_IMPORT_PATH += $$PWD/imports
        readonly property stringList qtModules : {
             var ret = ["core", "gui", "qml", "quick", "svg"];
             if (!project.noQtPrivateLibs) {
                 ret.push ("core-private");
                 ret.push ("qml-private");
             }
             return ret;
         }

        Export {
            cpp.includePaths: ".";

            Depends { name: "cpp"; }
            Depends {
                name: "Qt";
                submodules: product.qtModules;
            }
        }
        Depends { name: "cpp"; }
        Depends {
            name: "Qt";
            submodules: product.qtModules;
        }
        Group {
            name: "C++ sources";
            files: [
                "QQmlIntrospector.cpp",
                "QQmlMimeIconsHelper.cpp",
                "QQuickExtraAnchors.cpp",
                "QQuickFormContainer.cpp",
                "QQuickGridContainer.cpp",
                "QQuickPolygon.cpp",
                "QQuickRoundedRectanglePaintedItem.cpp",
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
                "QQmlIntrospector.h",
                "QQmlMimeIconsHelper.h",
                "QQuickExtraAnchors.h",
                "QQuickFormContainer.h",
                "QQuickGridContainer.h",
                "QQuickPolygon.h",
                "QQuickRoundedRectanglePaintedItem.h",
                "QQuickStretchColumnContainer.h",
                "QQuickStretchRowContainer.h",
                "QQuickSvgIconHelper.h",
                "QQuickThemeIconProvider.h",
                "QQuickWrapLeftRightContainer.h",
                "QtQmlTricksPlugin.h",
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
            name: "Markdown documents";
            files: [
                "README.md",
            ]
        }
        Group {
            qbs.install: (product.type === "dynamiclibrary");
            fileTagsFilter: product.type;
        }
    }
}
