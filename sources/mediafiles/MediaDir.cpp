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

#include "MediaDir.h"
#include "DeclarativeList.h"

MediaDir::MediaDir(QString path, QString name, QObject *parent) :
    QObject(parent) {
    if (!path.isNull())
        this->setPath(path);
    if (!name.isNull())
        this->setName(name);
}


QList<MediaFile*> MediaDir::getFiles() {
    if (this->m_dir.path().isNull()) return QList<MediaFile*>(); // return empty list if is null
    if (this->m_files.isEmpty()) this->refreshFiles(); // recalculate list if wasn't recalculated or really empty
    return this->m_files;
}


QDeclarativeListProperty<MediaFile> MediaDir::getFilesProperty() {
    this->getFiles(); // prepare files
    return DeclarativeList<MediaFile>::generateProperty(this, &m_files, false, true);
}


QList<MediaDir*> MediaDir::getDirs() {
    if (this->m_dir.path().isNull()) return QList<MediaDir*>(); // return empty list if is null
    if (this->m_dirs.isEmpty()) this->refreshDirs(); // recalculate list if wasn't recalculated or really empty
    return this->m_dirs;
}


QDeclarativeListProperty<MediaDir> MediaDir::getDirsProperty() {
    this->getDirs(); // prepare dirs
    return DeclarativeList<MediaDir>::generateProperty(this, &m_dirs, false, true);
}


void MediaDir::setName(QString name) {
    this->m_name = name;
    emit nameChanged();
}


void MediaDir::setPath(QString path) {
    this->m_dir.setPath(path);
    if (this->m_name.isNull()) // if name isn't set
        this->setName(this->m_dir.dirName()); // sets system directory name
    this->m_files.clear(); // clears previos list to recalculate after
    emit filesChanged();
    this->m_dirs.clear(); // clears previos list to recalculate after
    emit dirsChanged();
    emit sourceChanged();
}


void MediaDir::refreshThumbnails(int depth) {
    this->getFiles();
    foreach (MediaFile* mediaFile, this->m_files)
        mediaFile->getThumbnail();
    this->getDirs();
    depth--;
    if (depth) {
        foreach (MediaDir* mediaDir, this->m_dirs)
            mediaDir->refreshThumbnails(depth - 1);
    }
}


void MediaDir::refreshFiles() {
    this->m_files.clear(); // clears previos list
    QStringList mediaNames;
    mediaNames << "*.jpg" << "*.png" << "*.gif" << "*.bmp" << "*.svg";
    QStringList fileNames = this->m_dir.entryList(mediaNames, QDir::Files | QDir::Readable);
    foreach (QString fileName, fileNames) { // for all file names
        MediaFile* newMediaFile = new MediaFile(this->m_dir.absoluteFilePath(fileName), this); // media file for path
        QObject::connect(newMediaFile, SIGNAL(generateThumbnail(QUrl)), this, SIGNAL(generateThumbnail(QUrl))); // for thumbnail generation
        this->m_files.append(newMediaFile);
    }
}


void MediaDir::refreshDirs() {
    this->m_dirs.clear(); // clears previos list
    QStringList dirNames = this->m_dir.entryList(QDir::NoDotAndDotDot | QDir::Dirs | QDir::Readable);
    foreach (QString dirName, dirNames) { // for all dir names
        MediaDir* newMediaDir = new MediaDir(this->m_dir.absoluteFilePath(dirName));
        QObject::connect(newMediaDir, SIGNAL(generateThumbnail(QUrl)), this, SIGNAL(generateThumbnail(QUrl))); // for thumbnail generation
        this->m_dirs.append(newMediaDir);
    }
}
