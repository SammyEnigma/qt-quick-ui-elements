
# QtQuick UI Elements

QT += core gui qml quick svg

INCLUDEPATH += $$PWD

QML_IMPORT_PATH += $$PWD/imports

contains (CONFIG, NO_ICONS_IN_QT_RES) {
    DEFINES += NO_ICONS_IN_QT_RES
}
else {
    RESOURCES += $$PWD/qtqmltricksicons.qrc
}

OTHER_FILES += \
    $$PWD/README.md

RESOURCES += \
    $$PWD/qtqmltricksuielements.qrc

HEADERS += \
    $$PWD/QQuickGridContainer.h \
    $$PWD/QQuickPolygon.h \
    $$PWD/QQuickStretchColumnContainer.h \
    $$PWD/QQuickStretchRowContainer.h \
    $$PWD/QQuickSvgIconHelper.h \
    $$PWD/QQuickWrapLeftRightContainer.h \
    $$PWD/QtQmlTricksPlugin.h \
    $$PWD/QQuickThemeIconProvider.h \
    $$PWD/QQmlMimeIconsHelper.h \
    $$PWD/QQuickExtraAnchors.h

SOURCES += \
    $$PWD/QQuickGridContainer.cpp \
    $$PWD/QQuickPolygon.cpp \
    $$PWD/QQuickStretchColumnContainer.cpp \
    $$PWD/QQuickStretchRowContainer.cpp \
    $$PWD/QQuickSvgIconHelper.cpp \
    $$PWD/QQuickWrapLeftRightContainer.cpp \
    $$PWD/QQmlMimeIconsHelper.cpp \
    $$PWD/QQuickThemeIconProvider.cpp \
    $$PWD/QQuickExtraAnchors.cpp
