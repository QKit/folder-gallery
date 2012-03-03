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

MediaDir::MediaDir(QString source, QString name, QObject *parent) :
    QObject(parent) {
    if (!source.isNull())
        this->setSource(source);
    if (!name.isNull())
        this->setName(name);
    this->connect(this, SIGNAL(filesChanged()), SIGNAL(contentChanged()));
    this->connect(this, SIGNAL(dirsChanged()), SIGNAL(contentChanged()));
}


int MediaDir::getFilesCount() {
    if (this->m_files.isEmpty()) // wasn't recalculated or really empty
        this->refreshFiles(); // recalculate list
    return this->m_files.count();
}


QDeclarativeListProperty<MediaFile> MediaDir::getFiles() {
    if (this->m_files.isEmpty()) // wasn't recalculated or really empty
        this->refreshFiles(); // recalculate list
    return DeclarativeList<MediaFile>::generateProperty(this, &m_files, false, true);
}


int MediaDir::getDirsCount() {
    if (this->m_dirs.isEmpty()) // wasn't recalculated or really empty
        this->refreshDirs(); // recalculate list
    return this->m_dirs.count();
}


QDeclarativeListProperty<MediaDir> MediaDir::getDirs() {
    if (this->m_dirs.isEmpty()) // wasn't recalculated or really empty
        this->refreshDirs(); // recalculate list
    return DeclarativeList<MediaDir>::generateProperty(this, &m_dirs, false, true);
}


int MediaDir::getContentCount() {
    if (this->m_content.isEmpty()) // wasn't recalculated or really empty
        this->refreshContent(); // recalculate list
    return this->m_content.count();
}


QDeclarativeListProperty<QObject> MediaDir::getContent() {
    if (this->m_content.isEmpty()) // wasn't recalculated or really empty
        this->refreshContent(); // recalculate list
    return DeclarativeList<QObject>::generateProperty(this, &m_content, false, true);
}


void MediaDir::setName(QString name) {
    this->m_name = name;
    emit nameChanged();
}


void MediaDir::setSource(QString source) {
    this->m_dir.setPath(source);
    if (this->m_name.isNull()) // if name isn't set
        this->setName(this->m_dir.dirName()); // sets system directory name
    this->m_files.clear(); // clears previos list to recalculate after
    emit filesChanged();
    this->m_dirs.clear(); // clears previos list to recalculate after
    emit dirsChanged();
    emit sourceChanged();
}


void MediaDir::refreshFiles() {
    this->m_files.clear(); // clears previos list
    QStringList mediaNames;
    mediaNames << "*.jpg" << "*.png" << "*.gif" << "*.bmp";
    QStringList fileNames = this->m_dir.entryList(mediaNames, QDir::Files | QDir::Readable);
    foreach (QString fileName, fileNames) { // for all file names
        MediaFile* newMediaFile = new MediaFile(this->m_dir.absoluteFilePath(fileName)); // media file for path
        QObject::connect(newMediaFile, SIGNAL(generateThumbnail(MediaFile*)), this, SIGNAL(generateThumbnail(MediaFile*))); // for thumbnail generation
        this->m_files.append(newMediaFile);
    }
}


void MediaDir::refreshDirs() {
    this->m_dirs.clear(); // clears previos list
    QStringList dirNames = this->m_dir.entryList(QDir::NoDotAndDotDot | QDir::Dirs | QDir::Readable);
    foreach (QString dirName, dirNames) { // for all dir names
        MediaDir* newMediaDir = new MediaDir(this->m_dir.absoluteFilePath(dirName));
        QObject::connect(newMediaDir, SIGNAL(generateThumbnail(MediaFile*)), this, SIGNAL(generateThumbnail(MediaFile*))); // for thumbnail generation
        this->m_dirs.append(newMediaDir);
    }
}


void MediaDir::refreshContent() {
    this->m_content.clear(); // clears previos list
    this->refreshDirs();
    foreach (MediaDir* mediaDir, this->m_dirs)
        this->m_content.append(mediaDir);
    this->refreshFiles();
    foreach (MediaFile* mediaFile, this->m_files)
        this->m_content.append(mediaFile);
}
