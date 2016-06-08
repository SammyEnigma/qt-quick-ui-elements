
#include "QQmlFsSingleton.h"

#include <QUrl>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QStandardPaths>
#include <QCoreApplication>
#include <QDateTime>
#include <QMimeDatabase>
#include <QMimeType>

QQmlFsSingleton::QQmlFsSingleton (QObject * parent)
    : QObject (parent)
    , m_homePath             (QDir::homePath ())
    , m_rootPath             (QDir::rootPath ())
    , m_tempPath             (QDir::tempPath ())
    , m_appDirPath           (QCoreApplication::applicationDirPath ())
    , m_appCachePath         (QStandardPaths::writableLocation (QStandardPaths::CacheLocation))
    , m_appConfigPath        (QStandardPaths::writableLocation (QStandardPaths::AppConfigLocation))
    , m_documentsPath        (QStandardPaths::writableLocation (QStandardPaths::DocumentsLocation))
    , m_imagesPath           (QStandardPaths::writableLocation (QStandardPaths::PicturesLocation))
    , m_musicPath            (QStandardPaths::writableLocation (QStandardPaths::MusicLocation))
    , m_videosPath           (QStandardPaths::writableLocation (QStandardPaths::MoviesLocation))
    , m_downloadsPath        (QStandardPaths::writableLocation (QStandardPaths::DownloadLocation))
    , m_workingDirectoryPath (QDir::currentPath ())
{ }

QObject * QQmlFsSingleton::qmlSingletonProvider (QQmlEngine * qmlEngine, QJSEngine * jsEngine) {
    Q_UNUSED (qmlEngine)
    Q_UNUSED (jsEngine)
    return new QQmlFsSingleton;
}

QString QQmlFsSingleton::getHomePath (void) const {
    return m_homePath;
}

QString QQmlFsSingleton::getRootPath (void) const {
    return m_rootPath;
}

QString QQmlFsSingleton::getTempPath (void) const {
    return m_tempPath;
}

QString QQmlFsSingleton::getAppDirPath (void) const {
    return m_appDirPath;
}

QString QQmlFsSingleton::getAppCachePath (void) const {
    return m_appCachePath;
}

QString QQmlFsSingleton::getAppConfigPath (void) const {
    return m_appConfigPath;
}

QString QQmlFsSingleton::getDocumentsPath (void) const {
    return m_documentsPath;
}

QString QQmlFsSingleton::getImagesPath (void) const {
    return m_imagesPath;
}

QString QQmlFsSingleton::getMusicPath (void) const {
    return m_musicPath;
}

QString QQmlFsSingleton::getVideosPath (void) const {
    return m_videosPath;
}

QString QQmlFsSingleton::getDownloadsPath (void) const {
    return m_downloadsPath;
}

QString QQmlFsSingleton::getWorkingDirectoryPath (void) const {
    return m_workingDirectoryPath;
}

bool QQmlFsSingleton::isDir (const QString & path) const {
    return QFileInfo (path).isDir ();
}

bool QQmlFsSingleton::isFile (const QString & path) const {
    return QFileInfo (path).isFile ();
}

bool QQmlFsSingleton::isLink (const QString & path) const {
    return QFileInfo (path).isSymLink ();
}

bool QQmlFsSingleton::exists (const QString & path) const {
    return QFile::exists (path);
}

bool QQmlFsSingleton::copy (const QString & sourcePath, const QString & destPath) const {
    return QFile::copy (sourcePath, destPath);
}

bool QQmlFsSingleton::move (const QString & sourcePath, const QString & destPath) const {
    return QFile::rename (sourcePath, destPath);
}

bool QQmlFsSingleton::link (const QString & sourcePath, const QString & destPath) const {
    return QFile::link (sourcePath, destPath);
}

bool QQmlFsSingleton::remove (const QString & path) const {
    if (QFileInfo (path).isDir ()) {
        return QDir (path).removeRecursively ();
    }
    else {
        return QFile::remove (path);
    }
}

int QQmlFsSingleton::size (const QString & path) const {
    return static_cast<int> (QFileInfo (path).size ());
}

QString QQmlFsSingleton::parentDir (const QString & path) const {
    QDir dir (path);
    dir.cdUp ();
    return dir.path ();
}

QString QQmlFsSingleton::readTextFile (const QString & path) const {
    QString ret;
    QFile file (path);
    if (file.open (QFile::ReadOnly)) {
        ret = QString::fromUtf8 (file.readAll ());
        file.close ();
    }
    return ret;
}

bool QQmlFsSingleton::writeTextFile (const QString & path, const QString & text) const {
    bool ret = false;
    QFile file (path);
    if (file.open (QFile::WriteOnly)) {
        file.write (text.toUtf8 ());
        file.flush ();
        file.close ();
        ret = true;
    }
    return ret;
}

QString QQmlFsSingleton::pathFromUrl (const QUrl & url) const {
    return url.toLocalFile ();
}

QUrl QQmlFsSingleton::urlFromPath (const QString & path) const {
    return QUrl::fromLocalFile (path);
}

QVariantList QQmlFsSingleton::list (const QString & dirPath, const QStringList & nameFilters, const bool showHidden, const bool showFiles) const {
    static QMimeDatabase mimeDb;
    QVariantList ret;
    const QDir dir (dirPath);
    if (dir.exists ()) {
        const QDir::Filters filters (QDir::Dirs
                                     | QDir::AllDirs
                                     | QDir::NoDotAndDotDot
                                     | (showHidden ? QDir::Hidden : 0)
                                     | (showFiles ? QDir::Files : 0));
        const QDir::SortFlags sortFlags (QDir::Name
                                         | QDir::IgnoreCase
                                         | QDir::DirsFirst);
        const QList<QFileInfo> infoList = dir.entryInfoList (nameFilters, filters, sortFlags);
        ret.reserve (infoList.size ());
        QVariantMap entry;
        for (QList<QFileInfo>::const_iterator it = infoList.constBegin (); it != infoList.constEnd (); it++) {
            const QFileInfo & info = (* it);
            entry.insert ("url",          QUrl::fromLocalFile (info.absoluteFilePath ()).toString ());
            entry.insert ("name",         info.fileName ());
            entry.insert ("path",         info.absoluteFilePath ());
            entry.insert ("isDir",        info.isDir ());
            entry.insert ("isFile",       info.isFile ());
            entry.insert ("isLink",       info.isSymLink ());
            entry.insert ("extension",    info.completeSuffix ());
            entry.insert ("size",         static_cast<int> (info.size ()));
            entry.insert ("permissions",  static_cast<int> (info.permissions ()));
            entry.insert ("lastModified", info.lastModified ().toString ("yyyy-MM-dd hh:mm:ss.zzz"));
            //entry.insert ("mimeType",     mimeDb.mimeTypeForFile (info.absoluteFilePath ()).name ());
            ret.append (entry);
        }
    }
    return ret;
}
