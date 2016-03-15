
# QtQuick UI Elements

QT += core gui qml quick svg

INCLUDEPATH += $$PWD

QML_IMPORT_PATH += $$PWD/imports

contains (CONFIG, NO_ICONS_IN_QT_RES) {
    warning ("QtQmlTricks.UiElements : You disabled icons in QRC, the Faenza Lite icon theme won't be available !")

    DEFINES += NO_ICONS_IN_QT_RES
}
else {
    RESOURCES += $$PWD/qtqmltricksicons.qrc
}

contains (CONFIG, NO_QT_PRIVATE_LIBS) {
    warning ("QtQmlTricks.UiElements : You disabled Qt private libs, some cases won't be handled by QQmlIntrospector::inherits() method !")

    DEFINES += NO_QT_PRIVATE_LIBS
}
else {
    QT += core-private qml-private
}

OTHER_FILES += \
    $$PWD/LICENSE.md \
    $$PWD/README.md

RESOURCES += \
    $$PWD/qtqmltricksuielements.qrc \
    $$PWD/qtqmltricksmimeicons.qrc

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
    $$PWD/QQuickExtraAnchors.h \
    $$PWD/QQuickRoundedRectanglePaintedItem.h \
    $$PWD/QQuickFormContainer.h \
    $$PWD/QQmlIntrospector.h \
    $$PWD/QQuickPixelPerfectContainer.h

SOURCES += \
    $$PWD/QQuickGridContainer.cpp \
    $$PWD/QQuickPolygon.cpp \
    $$PWD/QQuickStretchColumnContainer.cpp \
    $$PWD/QQuickStretchRowContainer.cpp \
    $$PWD/QQuickSvgIconHelper.cpp \
    $$PWD/QQuickWrapLeftRightContainer.cpp \
    $$PWD/QQmlMimeIconsHelper.cpp \
    $$PWD/QQuickThemeIconProvider.cpp \
    $$PWD/QQuickExtraAnchors.cpp \
    $$PWD/QQuickRoundedRectanglePaintedItem.cpp \
    $$PWD/QQuickFormContainer.cpp \
    $$PWD/QQmlIntrospector.cpp \
    $$PWD/QQuickPixelPerfectContainer.cpp
