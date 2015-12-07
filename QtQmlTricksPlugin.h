#ifndef QTQMLTRICKSPLUGIN_H
#define QTQMLTRICKSPLUGIN_H

#include <QQmlEngine>
#include <qqml.h>

#include "QQuickPolygon.h"
#include "QQuickSvgIconHelper.h"
#include "QQuickGridContainer.h"
#include "QQuickStretchRowContainer.h"
#include "QQuickStretchColumnContainer.h"
#include "QQuickWrapLeftRightContainer.h"

static void registerQtQmlTricksUiElements (void) {
    Q_INIT_RESOURCE (qtqmltricksuielements);

    const char * uri = "QtQmlTricks.UiElements"; // @uri QtQmlTricks.UiElements
    const int    maj = 2;
    const int    min = 0;

    // shapes
    qmlRegisterType<QQuickPolygon>                       (uri, maj, min, "Polygon");

    // icons
    qmlRegisterType<QQuickSvgIconHelper>                 (uri, maj, min, "SvgIconHelper");

    // layouts
    qmlRegisterType<QQuickGridContainer>                 (uri, maj, min, "GridContainer");
    qmlRegisterType<QQuickStretchRowContainer>           (uri, maj, min, "StretchRowContainer");
    qmlRegisterType<QQuickStretchColumnContainer>        (uri, maj, min, "StretchColumnContainer");
    qmlRegisterType<QQuickWrapLeftRightContainer>        (uri, maj, min, "WrapLeftRightContainer");
    qmlRegisterType<QQuickWrapLeftRightContainerBreaker> (uri, maj, min, "WrapBreaker");

    // globals
    qmlRegisterSingletonType (QUrl ("qrc:///QtQmlTricks/UiElements/Style.qml"),    uri, maj, min, "Style");

    // widgets
    qmlRegisterType (QUrl ("qrc:///QtQmlTricks/UiElements/ComboList.qml"),         uri, maj, min, "ComboList");
    qmlRegisterType (QUrl ("qrc:///QtQmlTricks/UiElements/IconTextButton.qml"),    uri, maj, min, "IconTextButton");
    qmlRegisterType (QUrl ("qrc:///QtQmlTricks/UiElements/TextBox.qml"),           uri, maj, min, "TextBox");
    qmlRegisterType (QUrl ("qrc:///QtQmlTricks/UiElements/TextButton.qml"),        uri, maj, min, "TextButton");
    qmlRegisterType (QUrl ("qrc:///QtQmlTricks/UiElements/TextLabel.qml"),         uri, maj, min, "TextLabel");
    qmlRegisterType (QUrl ("qrc:///QtQmlTricks/UiElements/SingleLineEditBox.qml"), uri, maj, min, "SingleLineEditBox");
    qmlRegisterType (QUrl ("qrc:///QtQmlTricks/UiElements/ScrollContainer.qml"),   uri, maj, min, "ScrollContainer");
}

#endif // QTQMLTRICKSPLUGIN_H

