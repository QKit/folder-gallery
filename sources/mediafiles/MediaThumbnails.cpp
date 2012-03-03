/*******************************************************************************
*                                                                              *
*  Thumbnail names generator implementation.                                   *
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

#include "MediaThumbnails.h"

MediaThumbnailsBase::MediaThumbnailsBase(const QString dirPath) {
    this->idCount = 0; // no thumbnails
    this->setDirPath(dirPath);
    this->connect(&(this->generatorThread), SIGNAL(thumbnailReady(QUrl)), SLOT(finishThumbnail(QUrl)));
}


QString MediaThumbnailsBase::getThumbnailPath(const QUrl fileUrl) {
    QMutexLocker baseLocker(&this->baseMutex);
    Q_UNUSED(baseLocker)
    if (this->base.contains(fileUrl)) // thumbnail exists
        return this->getThumbnailPathById(this->base[fileUrl]); // returns path to thumbnail
    else // thumbnail doesn't exist
        return QString::null;
}


void MediaThumbnailsBase::setDirPath(const QString dirPath) {
    this->clear(); // remove all thumbnails
    QDir::root().mkpath(dirPath); // to be sure that exists
    this->dir.setPath(dirPath);
}


void MediaThumbnailsBase::generateThumbnail(MediaFile* mediaFile) {
    if (!mediaFile)
        return;
    QUrl fileSource = mediaFile->getSource();
    QMutexLocker baseLocker(&this->baseMutex);
    QMutexLocker todoLocker(&this->toProcessMutex);
    if (this->base.contains(fileSource)) { // if already in base
        mediaFile->setThumbnail(this->getThumbnailPathById(this->base[fileSource]));
        return;
    }
    int id;
    if (this->toProcess.contains(fileSource)) { // if already in work
        id = this->toProcess[fileSource];
    } else {
        this->idCountMutex.lock(); // to protect from other threads
        id = this->idCount;
        this->idCount++; // one more thumbnail
        this->idCountMutex.unlock();
        this->toProcess[fileSource] = id;
    }
    this->toProcessFiles.insertMulti(id, mediaFile);
    baseLocker.unlock();
    todoLocker.unlock();
    this->generatorThread.generateThumbnail(fileSource, this->getThumbnailPathById(id));
}


void MediaThumbnailsBase::clear() {
    foreach (int thumbnailId, this->base) // for each thumbnail
        this->dir.remove(this->getThumbnailPathById(thumbnailId)); // delete file
    this->base.clear(); // clear list
    this->idCount = 0; // number of thumbnails
}


void MediaThumbnailsBase::finishThumbnail(const QUrl& fileSource) {
    this->toProcessMutex.lock();
    this->baseMutex.lock();
    int id = this->toProcess.take(fileSource);
    QString thumbnailPath = this->getThumbnailPathById(id);
    foreach (MediaFile* mediaFile, this->toProcessFiles.values(id))
        mediaFile->setThumbnail(thumbnailPath);
    this->toProcessFiles.remove(id);
    this->base[fileSource] = id;
    this->baseMutex.unlock();
    this->toProcessMutex.unlock();
}


MediaThumbnailGeneratorTread::MediaThumbnailGeneratorTread() {
    this->maxWidth = 256;
    this->maxHeight = 256;
}


void MediaThumbnailGeneratorTread::generateThumbnail(const QUrl& fileSource, const QString& thumbnailPath) {
    QMutexLocker todoStackLocker(&this->toProcessStackMutex);
    bool isAtStack = false;
    MediaThumbnailElement element;
    // try to find it in todo stack
    for (int i = 0; i < this->toProcessStack.size(); i++) {
        if (this->toProcessStack.at(i).fileSource == fileSource) {
            isAtStack = true;
            element = this->toProcessStack.takeAt(i);
            break;
        }
    }
    if (!isAtStack) { // if wasn't in todo stack
        element.fileSource = fileSource;
        element.thumbnailPath = thumbnailPath;
    }
    this->toProcessStack.append(element); // append new or taken element
    todoStackLocker.unlock();
    if (!this->isRunning())
        this->start();
}


void MediaThumbnailGeneratorTread::run() {
    while (true) {
        QMutexLocker todoStackLocker(&this->toProcessStackMutex);
        if (this->toProcessStack.isEmpty())
            return;
        MediaThumbnailElement element = this->toProcessStack.takeLast();
        todoStackLocker.unlock();
        MediaFile mediaFile(element.fileSource); // media file for the source
        mediaFile.getThumbnailImage(this->maxWidth, this->maxHeight).save(element.thumbnailPath); // saves thumbnail
        emit thumbnailReady(element.fileSource);
    }
}
