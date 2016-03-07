#ifndef QQMLINTROSPECTOR_H
#define QQMLINTROSPECTOR_H

#include <QObject>
#include <QQmlEngine>
#include <QJSEngine>

class QQmlIntrospector : public QObject {
    Q_OBJECT

public:
    explicit QQmlIntrospector (QObject * parent = Q_NULLPTR);

    static QObject * qmlSingletonProvider (QQmlEngine * qmlEngine, QJSEngine * jsEngine);

public slots:
    bool inherits (QObject * object, QObject * reference);
};

#endif // QQMLINTROSPECTOR_H
