
#include "QQmlMimeIconsHelper.h"

#include <QMimeDatabase>
#include <QMimeType>
#include <QIcon>
#include <QFile>
#include <QFileInfo>
#include <QStandardPaths>

QQmlMimeIconsHelper::QQmlMimeIconsHelper (QObject * parent) : QObject (parent) {
    foreach (const QString & path, QStandardPaths::standardLocations (QStandardPaths::HomeLocation)) {
        m_specialFoldersIconNames.insert (path, "folder-home");
    }
    foreach (const QString & path, QStandardPaths::standardLocations (QStandardPaths::DocumentsLocation)) {
        m_specialFoldersIconNames.insert (path, "folder-documents");
    }
    foreach (const QString & path, QStandardPaths::standardLocations (QStandardPaths::MusicLocation)) {
        m_specialFoldersIconNames.insert (path, "folder-music");
    }
    foreach (const QString & path, QStandardPaths::standardLocations (QStandardPaths::PicturesLocation)) {
        m_specialFoldersIconNames.insert (path, "folder-images");
    }
    foreach (const QString & path, QStandardPaths::standardLocations (QStandardPaths::MoviesLocation)) {
        m_specialFoldersIconNames.insert (path, "folder-videos");
    }
    foreach (const QString & path, QStandardPaths::standardLocations (QStandardPaths::DownloadLocation)) {
        m_specialFoldersIconNames.insert (path, "folder-downloads");
    }
}

QString QQmlMimeIconsHelper::getIconNameForPath (const QString & path) const {
    static QHash<QString, QString> mimes;
    static QMimeDatabase * db = new QMimeDatabase;
    QString ret;
    const QFileInfo info (path);
    if (info.exists ()) {
        if (info.isDir ()) {
            return m_specialFoldersIconNames.value (path, "folder");
        }
        else {
            const QMimeType type = db->mimeTypeForFile (path);
            const QString tmp = type.name ();
            if (!mimes.contains (tmp)) {
                if (QIcon::hasThemeIcon (type.iconName ())) {
                    mimes.insert (tmp, type.iconName ());
                }
                else if (QIcon::hasThemeIcon (type.genericIconName ())) {
                    mimes.insert (tmp, type.genericIconName ());
                }
                else {
                    mimes.insert (tmp, "empty");
                }
            }
            return mimes.value (tmp);
        }
    }
    return ret;
}
