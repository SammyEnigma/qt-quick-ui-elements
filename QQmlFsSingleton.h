#ifndef QQMLFSSINGLETON_H
#define QQMLFSSINGLETON_H

#include <QObject>
#include <QString>
#include <QQmlEngine>
#include <QJSEngine>

class QQmlFileSystemSingleton : public QObject {
    Q_OBJECT

    Q_ENUMS (Permission)

    Q_PROPERTY (QString homePath             READ getHomePath             CONSTANT)
    Q_PROPERTY (QString rootPath             READ getRootPath             CONSTANT)
    Q_PROPERTY (QString tempPath             READ getTempPath             CONSTANT)
    Q_PROPERTY (QString appDirPath           READ getAppDirPath           CONSTANT)
    Q_PROPERTY (QString appCachePath         READ getAppCachePath         CONSTANT)
    Q_PROPERTY (QString appConfigPath        READ getAppConfigPath        CONSTANT)
    Q_PROPERTY (QString documentsPath        READ getDocumentsPath        CONSTANT)
    Q_PROPERTY (QString imagesPath           READ getImagesPath           CONSTANT)
    Q_PROPERTY (QString musicPath            READ getMusicPath            CONSTANT)
    Q_PROPERTY (QString videosPath           READ getVideosPath           CONSTANT)
    Q_PROPERTY (QString downloadsPath        READ getDownloadsPath        CONSTANT)
    Q_PROPERTY (QString workingDirectoryPath READ getWorkingDirectoryPath CONSTANT)

    Q_PROPERTY (QStringList drivesList READ getDrivesList NOTIFY drivesListChanged)

public:
    static QObject * qmlSingletonProvider (QQmlEngine * qmlEngine, QJSEngine * jsEngine);

    enum Permission {
        ReadOwner = 0x4000, WriteOwner = 0x2000, ExeOwner = 0x1000,
        ReadUser  = 0x0400, WriteUser  = 0x0200, ExeUser  = 0x0100,
        ReadGroup = 0x0040, WriteGroup = 0x0020, ExeGroup = 0x0010,
        ReadOther = 0x0004, WriteOther = 0x0002, ExeOther = 0x0001,
    };

    QString getHomePath             (void) const;
    QString getRootPath             (void) const;
    QString getTempPath             (void) const;
    QString getAppDirPath           (void) const;
    QString getAppCachePath         (void) const;
    QString getAppConfigPath        (void) const;
    QString getDocumentsPath        (void) const;
    QString getImagesPath           (void) const;
    QString getMusicPath            (void) const;
    QString getVideosPath           (void) const;
    QString getDownloadsPath        (void) const;
    QString getWorkingDirectoryPath (void) const;

    QStringList getDrivesList       (void) const;

public slots:
    bool isDir  (const QString & path) const;
    bool isFile (const QString & path) const;
    bool isLink (const QString & path) const;
    bool exists (const QString & path) const;

    bool copy (const QString & sourcePath, const QString & destPath) const;
    bool move (const QString & sourcePath, const QString & destPath) const;
    bool link (const QString & sourcePath, const QString & destPath) const;

    bool remove (const QString & path) const;

    int  size (const QString & path) const;

    QString parentDir (const QString & path) const;

    QString readTextFile  (const QString & path) const;
    bool    writeTextFile (const QString & path, const QString & text) const;

    QString pathFromUrl (const QUrl    & url)  const;
    QUrl    urlFromPath (const QString & path) const;

    QVariantList list (const QString & dirPath,
                       const QStringList & nameFilters = QStringList (),
                       const bool showHidden = false,
                       const bool showFiles = true) const;

signals:
    void drivesListChanged (const QStringList & drivesList);

protected:
    explicit QQmlFileSystemSingleton (QObject * parent = Q_NULLPTR);

private:
    const QString m_homePath;
    const QString m_rootPath;
    const QString m_tempPath;
    const QString m_appDirPath;
    const QString m_appCachePath;
    const QString m_appConfigPath;
    const QString m_documentsPath;
    const QString m_imagesPath;
    const QString m_musicPath;
    const QString m_videosPath;
    const QString m_downloadsPath;
    const QString m_workingDirectoryPath;
    QStringList m_drivesList;
};

#endif // QQMLFSSINGLETON_H
