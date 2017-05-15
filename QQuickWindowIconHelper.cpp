
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
        window ()->setIcon (QIcon ((m_iconPath.indexOf ("://") < 5)
                                   ? QUrl (m_iconPath).toLocalFile ()
                                   : m_iconPath));
    }
}
