
#include "QQuickWindowIconHelper.h"

#include <QUrl>
#include <QIcon>
#include <QWindow>
#include <QQuickWindow>

QQuickWindowIconHelper::QQuickWindowIconHelper (QQuickItem * parent)
    : QQuickItem (parent)
{
    connect (this, &QQuickWindowIconHelper::windowChanged,   this, &QQuickWindowIconHelper::refreshWindowIcon);
    connect (this, &QQuickWindowIconHelper::iconPathChanged, this, &QQuickWindowIconHelper::refreshWindowIcon);
}

void QQuickWindowIconHelper::componentComplete (void) {
    QQuickItem::componentComplete ();
    refreshWindowIcon ();
}

const QString & QQuickWindowIconHelper::getIconPath (void) const {
    return m_iconPath;
}

void QQuickWindowIconHelper::setIconPath (const QString & iconPath) {
    if (m_iconPath != iconPath) {
        m_iconPath = iconPath;
        emit iconPathChanged (iconPath);
    }
}

void QQuickWindowIconHelper::refreshWindowIcon (void) {
    if (window ()) {
        if (m_iconPath.startsWith ("file://")) {
            window ()->setIcon (QIcon (QUrl (m_iconPath).toLocalFile ()));
        }
        else if (m_iconPath.startsWith ("qrc:///")) {
            window ()->setIcon (QIcon (m_iconPath.replace ("qrc:///", ":/")));
        }
        else if (m_iconPath.startsWith ("qrc://")) {
            window ()->setIcon (QIcon (m_iconPath.replace ("qrc://", ":/")));
        }
        else {
            window ()->setIcon (QIcon (m_iconPath));
        }
    }
}
