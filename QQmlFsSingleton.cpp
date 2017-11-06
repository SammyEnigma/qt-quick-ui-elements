
#include "QQmlFsSingleton.h"

#include <QTimer>
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
#include <QDirIterator>
#include <QDebug>

QMimeDatabase QQmlFileSystemModelEntry::MIME_DATABASE;

const QString QQmlFileSystemModelEntry::DATETIME_FORMAT = QStringLiteral ("yyyy-MM-dd hh:mm:ss.zzz");

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
    doRefreshDrives ();
}

QObject * QQmlFileSystemSingleton::qmlSingletonProvider (QQmlEngine * qmlEngine, QJSEngine * jsEngine) {
    Q_UNUSED (qmlEngine)
    Q_UNUSED (jsEngine)
    return new QQmlFileSystemSingleton;
}

void QQmlFileSystemSingleton::doRefreshDrives (void) {
    QStringList tmp;
    const QList<QFileInfo> infoList = QDir::drives ();
    for (QList<QFileInfo>::const_iterator it = infoList.constBegin (); it != infoList.constEnd (); ++it) {
        tmp.append ((* it).absolutePath ());
    }
    if (m_drivesList != tmp) {
        m_drivesList = tmp;
        emit drivesListChanged (m_drivesList);
    }
#ifdef Q_OS_WIN
#   if QT_VERSION >= 0x050400
    QTimer::singleShot (5000, this, &QQmlFileSystemSingleton::doRefreshDrives);
#   else
    QTimer::singleShot (5000, this, SLOT(doRefreshDrives()));
#   endif
#endif
}

const QString & QQmlFileSystemSingleton::getHomePath (void) const {
    return m_homePath;
}

const QString & QQmlFileSystemSingleton::getRootPath (void) const {
    return m_rootPath;
}

const QString & QQmlFileSystemSingleton::getTempPath (void) const {
    return m_tempPath;
}

const QString & QQmlFileSystemSingleton::getAppDirPath (void) const {
    return m_appDirPath;
}

const QString & QQmlFileSystemSingleton::getAppCachePath (void) const {
    return m_appCachePath;
}

const QString & QQmlFileSystemSingleton::getAppConfigPath (void) const {
    return m_appConfigPath;
}

const QString & QQmlFileSystemSingleton::getDocumentsPath (void) const {
    return m_documentsPath;
}

const QString & QQmlFileSystemSingleton::getImagesPath (void) const {
    return m_imagesPath;
}

const QString & QQmlFileSystemSingleton::getMusicPath (void) const {
    return m_musicPath;
}

const QString & QQmlFileSystemSingleton::getVideosPath (void) const {
    return m_videosPath;
}

const QString & QQmlFileSystemSingleton::getDownloadsPath (void) const {
    return m_downloadsPath;
}

const QString & QQmlFileSystemSingleton::getWorkingDirectoryPath (void) const {
    return m_workingDirectoryPath;
}

const QStringList & QQmlFileSystemSingleton::getDrivesList (void) const {
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

bool QQmlFileSystemSingleton::mkpath (const QString & path) const {
    return QDir ().mkpath (path);
}

int QQmlFileSystemSingleton::size (const QString & path) const {
    return static_cast<int> (QFileInfo (path).size ());
}

QString QQmlFileSystemSingleton::parentDir (const QString & path) const {
    return QFileInfo (path).dir ().absolutePath ();
}

QString QQmlFileSystemSingleton::baseName (const QString & path) const {
    return QFileInfo (path).fileName ();
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

static void getDirsList (const QString & dirPath,
                         const bool includeHidden,
                         const bool recursive,
                         QFileInfoList & dirsList) {
    static const QStringList EMPTY_STR_LIST;
    QDirIterator lister (dirPath,
                         EMPTY_STR_LIST,
                         QDir::Filters (QDir::Dirs | QDir::AllDirs | QDir::NoDotAndDotDot | QDir::Hidden),
                         QDirIterator::NoIteratorFlags);
    while (lister.hasNext ()) {
        const QFileInfo & info = lister.next ();
        if (includeHidden || (!info.isHidden () && !info.fileName ().startsWith ('.'))) {
            dirsList.append (info);
            if (recursive) {
                getDirsList (info.absoluteFilePath (), includeHidden, true, dirsList);
            }
        }
    }
}

static void getFilesList (const QString & dirPath,
                          const QStringList & nameFilters,
                          const bool includeHidden,
                          QFileInfoList & filesList) {
    QDirIterator lister (dirPath,
                         nameFilters,
                         QDir::Filters (QDir::Files | QDir::Hidden),
                         QDirIterator::NoIteratorFlags);
    while (lister.hasNext ()) {
        const QFileInfo & info = lister.next ();
        if (includeHidden || (!info.isHidden () && !info.fileName ().startsWith ('.'))) {
            filesList.append (info);
        }
    }
}

QVariantList QQmlFileSystemSingleton::list (const QString & dirPath, const QStringList & nameFilters, const bool showHidden, const bool showFiles, const bool showDirs, const bool recursive) const {
    QVariantList ret;
    const QDir dir (dirPath);
    if (!dirPath.isEmpty () && dir.exists ()) {
        QFileInfoList dirsList;
        QFileInfoList filesList;
        if (recursive) {
            getDirsList (dirPath, showHidden, recursive, dirsList);
            if (showFiles) {
                getFilesList (dirPath, nameFilters, showHidden, filesList);
                for (QFileInfoList::const_iterator it = dirsList.constBegin (); it != dirsList.constEnd (); ++it) {
                    getFilesList ((* it).absoluteFilePath (), nameFilters, showHidden, filesList);
                }
            }
            if (!showDirs) {
                dirsList.clear ();
            }
        }
        else {
            if (showDirs) {
                getDirsList (dirPath, showHidden, false, dirsList);
            }
            if (showFiles) {
                getFilesList (dirPath, nameFilters, showHidden, filesList);
            }
        }
        qSort (dirsList);
        qSort (filesList);
        ret.reserve (dirsList.size () + filesList.size ());
        for (QFileInfoList::const_iterator it = dirsList.constBegin (); it != dirsList.constEnd (); ++it) {
            ret.append (QVariant::fromValue (new QQmlFileSystemModelEntry (* it)));
        }
        for (QFileInfoList::const_iterator it = filesList.constBegin (); it != filesList.constEnd (); ++it) {
            ret.append (QVariant::fromValue (new QQmlFileSystemModelEntry (* it)));
        }
    }
    return ret;
}

QQmlFileSystemModelEntry::QQmlFileSystemModelEntry (const QFileInfo & info, QObject * parent)
    : QObject (parent)
    , m_url (QUrl::fromLocalFile (info.absoluteFilePath ()).toString ())
    , m_name (info.fileName ())
    , m_path (info.absoluteFilePath ())
    #ifndef Q_OS_LINUX
    , m_mimeType (MIME_DATABASE.mimeTypeForFile (info.absoluteFilePath ()).name ())
    #else
    , m_mimeType ("undefined")
    #endif
    , m_extension (info.completeSuffix ())
    , m_lastModified (info.lastModified ().toString (DATETIME_FORMAT))
    , m_isDir (info.isDir ())
    , m_isFile (info.isFile ())
    , m_isLink (info.isSymLink ())
    , m_size (static_cast<int> (info.size ()))
    , m_permissions (static_cast<int> (info.permissions ()))
{
    if (parent == Q_NULLPTR) {
        QQmlEngine::setObjectOwnership (this, QQmlEngine::JavaScriptOwnership);
    }
}

const QString & QQmlFileSystemModelEntry::getUrl (void) const {
    return m_url;
}

const QString & QQmlFileSystemModelEntry::getName (void) const {
    return m_name;
}

const QString & QQmlFileSystemModelEntry::getPath (void) const {
    return m_path;
}

const QString & QQmlFileSystemModelEntry::getMimeType (void) const {
    return m_mimeType;
}

const QString & QQmlFileSystemModelEntry::getExtension (void) const {
    return m_extension;
}

const QString & QQmlFileSystemModelEntry::getLastModified (void) const {
    return m_lastModified;
}

bool QQmlFileSystemModelEntry::getIsDir (void) const {
    return m_isDir;
}

bool QQmlFileSystemModelEntry::getIsFile (void) const {
    return m_isFile;
}

bool QQmlFileSystemModelEntry::getIsLink (void) const {
    return m_isLink;
}

int QQmlFileSystemModelEntry::getSize (void) const {
    return m_size;
}

int QQmlFileSystemModelEntry::getPermission (void) const {
    return m_permissions;
}
