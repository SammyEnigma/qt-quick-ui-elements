
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
#include <QStringBuilder>

QQmlFileSystemSingleton::QQmlFileSystemSingleton (QObject * parent)
    : QObject (parent)
    , m_homePath             (QDir::homePath ())
    , m_rootPath             (QDir::rootPath ())
    , m_tempPath             (QDir::tempPath ())
    , m_appDirPath           (QCoreApplication::applicationDirPath ())
    , m_appCachePath         (QStandardPaths::writableLocation (QStandardPaths::CacheLocation))
#if QT_VERSION >= 0x050500
    , m_appConfigPath        (QStandardPaths::writableLocation (QStandardPaths::AppConfigLocation))
#else
    , m_appConfigPath        (QStandardPaths::writableLocation (QStandardPaths::ConfigLocation) % '/' % QCoreApplication::applicationName ())
#endif
    , m_documentsPath        (QStandardPaths::writableLocation (QStandardPaths::DocumentsLocation))
    , m_imagesPath           (QStandardPaths::writableLocation (QStandardPaths::PicturesLocation))
    , m_musicPath            (QStandardPaths::writableLocation (QStandardPaths::MusicLocation))
    , m_videosPath           (QStandardPaths::writableLocation (QStandardPaths::MoviesLocation))
    , m_downloadsPath        (QStandardPaths::writableLocation (QStandardPaths::DownloadLocation))
    , m_workingDirectoryPath (QDir::currentPath ())
{
    QStringList tmp;
    const QList<QFileInfo> infoList = QDir::drives ();
    for (QList<QFileInfo>::const_iterator it = infoList.constBegin (); it != infoList.constEnd (); it++) {
        tmp.append ((* it).absolutePath ());
    }
    if (m_drivesList != tmp) {
        m_drivesList = tmp;
        emit drivesListChanged (m_drivesList);
    }
}

QObject * QQmlFileSystemSingleton::qmlSingletonProvider (QQmlEngine * qmlEngine, QJSEngine * jsEngine) {
    Q_UNUSED (qmlEngine)
    Q_UNUSED (jsEngine)
    return new QQmlFileSystemSingleton;
}

QString QQmlFileSystemSingleton::getHomePath (void) const {
    return m_homePath;
}

QString QQmlFileSystemSingleton::getRootPath (void) const {
    return m_rootPath;
}

QString QQmlFileSystemSingleton::getTempPath (void) const {
    return m_tempPath;
}

QString QQmlFileSystemSingleton::getAppDirPath (void) const {
    return m_appDirPath;
}

QString QQmlFileSystemSingleton::getAppCachePath (void) const {
    return m_appCachePath;
}

QString QQmlFileSystemSingleton::getAppConfigPath (void) const {
    return m_appConfigPath;
}

QString QQmlFileSystemSingleton::getDocumentsPath (void) const {
    return m_documentsPath;
}

QString QQmlFileSystemSingleton::getImagesPath (void) const {
    return m_imagesPath;
}

QString QQmlFileSystemSingleton::getMusicPath (void) const {
    return m_musicPath;
}

QString QQmlFileSystemSingleton::getVideosPath (void) const {
    return m_videosPath;
}

QString QQmlFileSystemSingleton::getDownloadsPath (void) const {
    return m_downloadsPath;
}

QString QQmlFileSystemSingleton::getWorkingDirectoryPath (void) const {
    return m_workingDirectoryPath;
}

QStringList QQmlFileSystemSingleton::getDrivesList (void) const {
    return m_drivesList;
}

bool QQmlFileSystemSingleton::isDir (const QString & path) const {
    return QFileInfo (path).isDir ();
}

bool QQmlFileSystemSingleton::isFile (const QString & path) const {
    return QFileInfo (path).isFile ();
}

bool QQmlFileSystemSingleton::isLink (const QString & path) const {
    return QFileInfo (path).isSymLink ();
}

bool QQmlFileSystemSingleton::exists (const QString & path) const {
    return QFile::exists (path);
}

bool QQmlFileSystemSingleton::copy (const QString & sourcePath, const QString & destPath) const {
    return QFile::copy (sourcePath, destPath);
}

bool QQmlFileSystemSingleton::move (const QString & sourcePath, const QString & destPath) const {
    return QFile::rename (sourcePath, destPath);
}

bool QQmlFileSystemSingleton::link (const QString & sourcePath, const QString & destPath) const {
    return QFile::link (sourcePath, destPath);
}

bool QQmlFileSystemSingleton::remove (const QString & path) const {
    if (QFileInfo (path).isDir ()) {
        return QDir (path).removeRecursively ();
    }
    else {
        return QFile::remove (path);
    }
}

int QQmlFileSystemSingleton::size (const QString & path) const {
    return static_cast<int> (QFileInfo (path).size ());
}

QString QQmlFileSystemSingleton::parentDir (const QString & path) const {
    QDir dir (path);
    dir.cdUp ();
    return dir.path ();
}

QString QQmlFileSystemSingleton::readTextFile (const QString & path) const {
    QString ret;
    QFile file (path);
    if (file.open (QFile::ReadOnly)) {
        ret = QString::fromUtf8 (file.readAll ());
        file.close ();
    }
    return ret;
}

bool QQmlFileSystemSingleton::writeTextFile (const QString & path, const QString & text) const {
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

QString QQmlFileSystemSingleton::pathFromUrl (const QUrl & url) const {
    return url.toLocalFile ();
}

QUrl QQmlFileSystemSingleton::urlFromPath (const QString & path) const {
    return QUrl::fromLocalFile (path);
}

QVariantList QQmlFileSystemSingleton::list (const QString & dirPath, const QStringList & nameFilters, const bool showHidden, const bool showFiles) const {
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
            if (showHidden || !info.fileName ().startsWith ('.')) {
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
    }
    return ret;
}
