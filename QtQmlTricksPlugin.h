#ifndef QTQMLTRICKSPLUGIN_H
#define QTQMLTRICKSPLUGIN_H

#include <QQmlEngine>
#include <QDebug>
#include <qqml.h>
#include <QIcon>

#include "QQuickPolygon.h"
#include "QQuickExtraAnchors.h"
#include "QQuickSvgIconHelper.h"
#include "QQmlMimeIconsHelper.h"
#include "QQuickThemeIconProvider.h"
#include "QQuickGridContainer.h"
#include "QQuickFormContainer.h"
#include "QQuickStretchRowContainer.h"
#include "QQuickStretchColumnContainer.h"
#include "QQuickWrapLeftRightContainer.h"
#include "QQuickRoundedRectanglePaintedItem.h"

static void registerQtQmlTricksUiElements (QQmlEngine * engine = Q_NULLPTR) {
#ifndef NO_ICONS_IN_QT_RES
    Q_INIT_RESOURCE (qtqmltricksicons);
#endif
    Q_INIT_RESOURCE (qtqmltricksuielements);

    const char * uri = "QtQmlTricks.UiElements"; // @uri QtQmlTricks.UiElements
    const int    maj = 2;
    const int    min = 0;

    // icon theme
#ifndef NO_ICONS_IN_QT_RES
    QIcon::setThemeSearchPaths (QStringList () << ":/QtQmlTricks/UiElements/icons");
    QIcon::setThemeName ("FaenzaIconsLite");
#endif

    // shapes
    qmlRegisterType<QQuickPolygon>                       (uri, maj, min, "Polygon");
    qmlRegisterType<QQuickRoundedRectanglePaintedItem>   (uri, maj, min, "RoundedRectangle");

    // icons
    qmlRegisterType<QQuickSvgIconHelper>                 (uri, maj, min, "SvgIconHelper");
    qmlRegisterType<QQmlMimeIconsHelper>                 (uri, maj, min, "MimeIconsHelper");

    // layouts
    qmlRegisterType<QQuickGridContainer>                 (uri, maj, min, "GridContainer");
    qmlRegisterType<QQuickFormContainer>                 (uri, maj, min, "FormContainer");
    qmlRegisterType<QQuickStretchRowContainer>           (uri, maj, min, "StretchRowContainer");
    qmlRegisterType<QQuickStretchColumnContainer>        (uri, maj, min, "StretchColumnContainer");
    qmlRegisterType<QQuickWrapLeftRightContainer>        (uri, maj, min, "WrapLeftRightContainer");
    qmlRegisterType<QQuickWrapLeftRightContainerBreaker> (uri, maj, min, "WrapBreaker");

    qmlRegisterUncreatableType<QQuickExtraAnchors>       (uri, maj, min, "ExtraAnchors", "!!!");

    if (engine != Q_NULLPTR) {
        engine->addImageProvider ("icon-theme", new QQuickThemeIconProvider);
        engine->addImportPath ("qrc:///imports");
    }
    else {
        qWarning () << "You didn't pass a QML engine to the register function,"
                    << "some features (mostly plain QML components, and icon theme provider) won't work !";
    }
}

#endif // QTQMLTRICKSPLUGIN_H

