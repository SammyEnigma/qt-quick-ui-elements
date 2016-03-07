
#include "QQmlIntrospector.h"

#include <QMetaObject>

QQmlIntrospector::QQmlIntrospector (QObject * parent) : QObject (parent) { }

QObject * QQmlIntrospector::qmlSingletonProvider (QQmlEngine * qmlEngine, QJSEngine * jsEngine) {
    Q_UNUSED (qmlEngine)
    Q_UNUSED (jsEngine)
    return new QQmlIntrospector;
}

bool QQmlIntrospector::inherits (QObject * object, QObject * reference) {
    bool ret = false;
    if (object != Q_NULLPTR && reference != Q_NULLPTR) {
        const QString referenceClass = QString::fromLatin1 (reference->metaObject ()->className ());
        const QString objectClass    = QString::fromLatin1 (object->metaObject ()->className ());
        ret = (objectClass == referenceClass);
    }
    return ret;
}
