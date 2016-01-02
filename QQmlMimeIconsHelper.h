#ifndef QQMLMIMEICONSHELPER_H
#define QQMLMIMEICONSHELPER_H

#include <QObject>
#include <QString>
#include <QHash>

class QQmlMimeIconsHelper : public QObject {
    Q_OBJECT

public:
    explicit QQmlMimeIconsHelper (QObject * parent = Q_NULLPTR);

public slots:
    QString getIconNameForUrl (const QString & url) const;

private:
    QHash<QString, QString> m_specialFoldersIconNames;
};

#endif // QQMLMIMEICONSHELPER_H
