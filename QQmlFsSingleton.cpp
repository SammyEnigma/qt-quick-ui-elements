
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
    static const QString ROLE_URL           = QStringLiteral ("url");
    static const QString ROLE_NAME          = QStringLiteral ("name");
    static const QString ROLE_PATH          = QStringLiteral ("path");
    static const QString ROLE_IS_DIR        = QStringLiteral ("isDir");
    static const QString ROLE_IS_FILE       = QStringLiteral ("isFile");
    static const QString ROLE_IS_LINK       = QStringLiteral ("isLink");
    static const QString ROLE_EXTENSION     = QStringLiteral ("extension");
    static const QString ROLE_SIZE          = QStringLiteral ("size");
    static const QString ROLE_PERMISSIONS   = QStringLiteral ("permissions");
    static const QString ROLE_LAST_MODIFIED = QStringLiteral ("lastModified");
    static const QString ROLE_MIME_TYPE     = QStringLiteral ("mimeType");
    static const QString DATETIME_FORMAT    = QStringLiteral ("yyyy-MM-dd hh:mm:ss.zzz");
    QVariantList ret;
    const QDir dir (dirPath);
    if (dir.exists ()) {
        const QDir::Filters filters (QDir::Dirs
                                     | QDir::AllDirs
                                     | QDir::NoDotAndDotDot
                                     | (showHidden ? QDir::Hidden : 0)
                                     | (showFiles  ? QDir::Files  : 0));
        const QDir::SortFlags sortFlags (QDir::Name
                                         | QDir::IgnoreCase
                                         | QDir::DirsFirst);
        const QList<QFileInfo> infoList = dir.entryInfoList (nameFilters, filters, sortFlags);
        ret.reserve (infoList.size ());
        QVariantMap entry;
        for (QList<QFileInfo>::const_iterator it = infoList.constBegin (); it != infoList.constEnd (); it++) {
            const QFileInfo & info = (* it);
            if (showHidden || !info.fileName ().startsWith ('.')) {
                entry.insert (ROLE_URL,           QUrl::fromLocalFile (info.absoluteFilePath ()).toString ());
                entry.insert (ROLE_NAME,          info.fileName ());
                entry.insert (ROLE_PATH,          info.absoluteFilePath ());
                entry.insert (ROLE_IS_DIR,        info.isDir ());
                entry.insert (ROLE_IS_FILE,       info.isFile ());
                entry.insert (ROLE_IS_LINK,       info.isSymLink ());
                entry.insert (ROLE_EXTENSION,     info.completeSuffix ());
                entry.insert (ROLE_SIZE,          static_cast<int> (info.size ()));
                entry.insert (ROLE_PERMISSIONS,   static_cast<int> (info.permissions ()));
                entry.insert (ROLE_LAST_MODIFIED, info.lastModified ().toString (DATETIME_FORMAT));
                entry.insert (ROLE_MIME_TYPE,     mimeDb.mimeTypeForFile (info.absoluteFilePath ()).name ());
                ret.append (entry);
            }
        }
    }
    return ret;
}
