/*******************************************************************************
*                                                                              *
*  Directory with media files implementation.                                  *
*                                                                              *
*  Copyright (C) 2011 Kirill Chuvilin.                                         *
*  All rights reserved.                                                        *
*  Contact: Kirill Chuvilin (kirill.chuvilin@gmail.com, kirik-ch.ru)           *
*                                                                              *
*  This file is part of the Folder Gallery project.                            *
*                                                                              *
*  $QT_BEGIN_LICENSE:GPL$                                                      *
*  You may use this file under the terms of the GNU General Public License     *
*  as published by the Free Software Foundation; version 3 of the License.     *
*                                                                              *
*  This file is distributed in the hope that it will be useful,                *
*  but WITHOUT ANY WARRANTY; without even the implied warranty of              *
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the                *
*  GNU General Public License for more details.                                *
*                                                                              *
*  You should have received a copy of the GNU General Public License           *
*  along with this package; if not, write to the Free Software                 *
*  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.   *
*  $QT_END_LICENSE$                                                            *
*                                                                              *
*******************************************************************************/

#ifndef _MediaDir_h_
#define _MediaDir_h_

#include <QDir>
#include <QtDeclarative/QDeclarativeListProperty>

#include "MediaFile.h"

/*!
 * \brief Media directory class.
 * \author KiRiK aka Kirill Chuvilin (kirik-ch.ru)
 */
class MediaDir : public QObject {
    Q_OBJECT

    Q_PROPERTY(bool isDir READ isDir CONSTANT) //!< indicates dir or file
    Q_PROPERTY(bool isNull READ isNull NOTIFY sourceChanged) //!< indicates that dir is null dir
    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged) //!< name of directory
    Q_PROPERTY(QUrl source READ getSource WRITE setSource NOTIFY sourceChanged) //!< path to directory
    Q_PROPERTY(int filesCount READ getFilesCount NOTIFY filesChanged) //!< number of files
    Q_PROPERTY(QDeclarativeListProperty<MediaFile> files READ getFilesProperty NOTIFY filesChanged) //!< files
    Q_PROPERTY(int dirsCount READ getDirsCount NOTIFY dirsChanged) //!< number of subdirs
    Q_PROPERTY(QDeclarativeListProperty<MediaDir> dirs READ getDirsProperty NOTIFY dirsChanged) //!< subdirs
    Q_PROPERTY(int contentCount READ getContentCount NOTIFY contentChanged) //!< number of files and subdirs
    Q_PROPERTY(QDeclarativeListProperty<QObject> content READ getContentProperty NOTIFY contentChanged) //!< files and subdirs

public:
    /*!
     * \brief Constructor.
     * \param path   string with path to directory
     * \param name   string with name of directory to show (leave null to set automatically)
     * \param parent parent object
     */
    explicit MediaDir(QString path = QString::null, QString name = QString::null, QObject *parent = 0);

    /*!
     * \brief To indicate dir or file.
     * \return true
     */
    static bool isDir() {return true;}

    /*!
     * \brief Indicates null dir or not.
     * \return true if dir path is null, otherwise false
     */
    bool isNull() {return this->m_dir.path().isNull();}

    /*!
     * \brief Returns name of directory.
     * \return string with directory name
     */
    QString getName() const {return this->m_name;}

    /*!
     * \brief Returns path to directory.
     * \return string with absolute path
     */
    QString getPath() const {return this->m_dir.absolutePath();}

    /*!
     * \brief Returns url to directory.
     * \return source url
     */
    QUrl getSource() const {return QUrl::fromLocalFile(this->m_dir.absolutePath());}

    /*!
     * \brief Returns number of directory files.
     * \return number of files
     */
    int getFilesCount() {return this->getFiles().count();}

    /*!
     * \brief Returns files.
     * \return list with pointers to files
     */
    QList<MediaFile*> getFiles();

    /*!
     * \brief Returns files.
     * \return list property with files
     */
    QDeclarativeListProperty<MediaFile> getFilesProperty();

    /*!
     * \brief Returns number of directory subdirs.
     * \return number of subdirs
     */
    int getDirsCount() {return this->getDirs().count();}

    /*!
     * \brief Returns subdirs.
     * \return list with pointers to subdirs
     */
    QList<MediaDir*> getDirs();

    /*!
     * \brief Returns subdirs.
     * \return list property with subdirs
     */
    QDeclarativeListProperty<MediaDir> getDirsProperty();

    /*!
     * \brief Returns number of files and subdirs in directory.
     * \return number of files and subdirs
     */
    int getContentCount();

    /*!
     * \brief Returns files and subdirs.
     * \return list property with files and subdirs
     */
    QDeclarativeListProperty<QObject> getContentProperty();

public slots:
    /*!
     * \brief Sets name of directory.
     * \param name string with name of directory to show
     */
    void setName(QString name);

    /*!
     * \brief Sets path to directory.
     * \param string with path to directory
     */
    void setPath(QString path);

    /*!
     * \brief Sets url to directory.
     * \param source source url
     */
    void setSource(QUrl source) {this->setPath(source.toLocalFile());}

    /*!
     * \brief Recalculates thumbnails of files and subfolders.
     * \param depth depth of scan (leave 0 to unlimited depth)
     */
    void refreshThumbnails(int depth = 0);

signals:
    /*!
     * \brief Emited when name property changes.
     */
    void nameChanged();

    /*!
     * \brief Emited when source property changes.
     */
    void sourceChanged();

    /*!
     * \brief Emited when files property changes.
     */
    void filesChanged();

    /*!
     * \brief Emited when dirs property changes.
     */
    void dirsChanged();

    /*!
     * \brief Emited when content property changes.
     */
    void contentChanged();

    /*!
     * \brief Emited when new thumbnail is needed.
     * \param source url to file source
     */
    void generateThumbnail(const QUrl &source);

private:
    QString m_name;  //!< name of directory
    QDir m_dir; //!< directory object
    QList<MediaFile*> m_files; //!< files
    QList<MediaDir*> m_dirs; //!< dirs
    QList<QObject*> m_content; //!< dirs

private slots:
    /*!
     * \brief Recalculates file list.
     */
    void refreshFiles();

    /*!
     * \brief Recalculates dir list.
     */
    void refreshDirs();

    /*!
     * \brief Recalculates content list.
     */
    void refreshContent();
};
#endif // _MediaDir_h_
