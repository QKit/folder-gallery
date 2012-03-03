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
#include <QDeclarativeListProperty>

#include "MediaFile.h"

class MediaDir : public QObject {
    Q_OBJECT

    Q_PROPERTY(bool isDir READ isDir CONSTANT) // indicates dir or not
    Q_PROPERTY(bool isNull READ isNull NOTIFY sourceChanged) // indicates that dir is null dir
    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged) // name of directory
    Q_PROPERTY(QUrl source READ getSource WRITE setSource NOTIFY sourceChanged) // path to directory
    Q_PROPERTY(int filesCount READ getFilesCount NOTIFY filesChanged) // number of files
    Q_PROPERTY(QDeclarativeListProperty<MediaFile> files READ getFiles NOTIFY filesChanged) // files
    Q_PROPERTY(int dirsCount READ getDirsCount NOTIFY dirsChanged) // number of subdirs
    Q_PROPERTY(QDeclarativeListProperty<MediaDir> dirs READ getDirs NOTIFY dirsChanged) // subdirs
    Q_PROPERTY(int contentCount READ getContentCount NOTIFY contentChanged) // number of files and subdirs
    Q_PROPERTY(QDeclarativeListProperty<QObject> content READ getContent NOTIFY contentChanged) // files and subdirs

public:

    /*
      Constructor.
    */
    explicit MediaDir(QString source = QString::null, QString name = QString::null, QObject *parent = 0);

    /*
      Indicates dir or not.
    */
    static bool isDir() {return true;}

    /*
      Indicates dir or not.
    */
    bool isNull() {return this->m_dir.path().isNull();}

    /*
      Returns name of directory.
    */
    QString getName() const {return this->m_name;}

    /*
      Returns path to directory.
    */
    QUrl getSource() const {return QUrl::fromLocalFile(this->m_dir.absolutePath());}

    /*
      Returns number of files.
    */
    int getFilesCount();

    /*
      Returns files.
    */
    QDeclarativeListProperty<MediaFile> getFiles();

    /*
      Returns number of subdirs.
    */
    int getDirsCount();

    /*
      Returns subdirs.
    */
    QDeclarativeListProperty<MediaDir> getDirs();

    /*
      Returns number of files and subdirs.
    */
    int getContentCount();

    /*
      Returns files and subdirs.
    */
    QDeclarativeListProperty<QObject> getContent();

public slots:
    /*
      Sets name of directory.
    */
    void setName(QString name);
    /*
      Sets path to directory.
    */
    void setSource(QString source);
    void setSource(QUrl source) {this->setSource(source.toLocalFile());}

    /*
      Recalculates file list.
    */
    void refreshFiles();

    /*
      Recalculates dir list.
    */
    void refreshDirs();

    /*
      Recalculates content list.
    */
    void refreshContent();

signals:
    /*
      Emited when name property changes.
    */
    void nameChanged();

    /*
      Emited when source property changes.
    */
    void sourceChanged();

    /*
      Emited when files property changes.
    */
    void filesChanged();

    /*
      Emited when dirs property changes.
    */
    void dirsChanged();

    /*
      Emited when content property changes.
    */
    void contentChanged();

    /*
      Emited when new thumbnail needed.
      mediaFile - file for thumbnail
    */
    void generateThumbnail(MediaFile* mediaFile);

private:
    QString m_name;  // name of directory
    QDir m_dir; // directory object
    QList<MediaFile*> m_files; // files
    QList<MediaDir*> m_dirs; // dirs
    QList<QObject*> m_content; // dirs
};
#endif // _MediaDir_h_
