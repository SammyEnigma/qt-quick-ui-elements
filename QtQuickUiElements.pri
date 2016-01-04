
# QtQuick UI Elements

QT += core gui qml quick svg

INCLUDEPATH += $$PWD

RESOURCES += \
    $$PWD/qtqmltricksuielements.qrc \
    $$PWD/qtqmltricksicons.qrc

HEADERS += \
    $$PWD/QQuickGridContainer.h \
    $$PWD/QQuickPolygon.h \
    $$PWD/QQuickStretchColumnContainer.h \
    $$PWD/QQuickStretchRowContainer.h \
    $$PWD/QQuickSvgIconHelper.h \
    $$PWD/QQuickWrapLeftRightContainer.h \
    $$PWD/QtQmlTricksPlugin.h \
    $$PWD/QQuickThemeIconProvider.h \
    $$PWD/QQmlMimeIconsHelper.h

SOURCES += \
    $$PWD/QQuickGridContainer.cpp \
    $$PWD/QQuickPolygon.cpp \
    $$PWD/QQuickStretchColumnContainer.cpp \
    $$PWD/QQuickStretchRowContainer.cpp \
    $$PWD/QQuickSvgIconHelper.cpp \
    $$PWD/QQuickWrapLeftRightContainer.cpp \
    $$PWD/QQmlMimeIconsHelper.cpp \
    $$PWD/QQuickThemeIconProvider.cpp

OTHER_FILES += \
    $$PWD/Style.qml \
    $$PWD/ComboList.qml \
    $$PWD/ScrollContainer.qml \
    $$PWD/FileSelector.qml \
    $$PWD/TextBox.qml \
    $$PWD/TextButton.qml \
    $$PWD/TextLabel.qml
