
#include "QQuickWindowIconHelper.h"

#include <QIcon>
#include <QWindow>

QQuickWindowIconHelper::QQuickWindowIconHelper (QObject * parent)
    : QObject (parent)
{
    connect (this, &QQuickWindowIconHelper::iconPathChanged, this, &QQuickWindowIconHelper::refreshWindowIcon);
}

void QQuickWindowIconHelper::classBegin (void) { }

void QQuickWindowIconHelper::componentComplete (void) {
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
    if (QWindow * window = qobject_cast<QWindow *> (parent ())) {
        window->setIcon (QIcon (m_iconPath));
    }
}
