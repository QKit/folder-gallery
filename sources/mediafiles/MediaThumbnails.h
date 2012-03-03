/*******************************************************************************
*                                                                              *
*  Thumbnail base implementation.                                              *
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

#ifndef _MediaThumbnails_h_
#define _MediaThumbnails_h_

#include <QMap>
#include <QUrl>
#include <QDir>
#include <QThread>
#include <QMutex>
#include "MediaFile.h"

struct MediaThumbnailElement {
    QUrl fileSource; // source file
    QString thumbnailPath; // path to thumbnail
};


class MediaThumbnailGeneratorTread : public QThread {
    Q_OBJECT

public:
    /*
      Constructor.
      dirPath - path to dir with thumbnails
    */
    MediaThumbnailGeneratorTread();

public slots:
    /*
      Adds thumbnail for file.
      fileSource    - source file
      thumbnailPath - path to thumbnail
    */
    void generateThumbnail(const QUrl& fileSource, const QString& thumbnailPath);

    /*
      Separate thread action.
    */
    virtual void run();

signals:
    /*
      Emits when thumbnail file generated.
      fileSource    - source file
    */
    void thumbnailReady(const QUrl& fileSource) const;

private:
    int maxWidth; // max width of thumbnail
    int maxHeight; // max height of thumbnail
    QList<MediaThumbnailElement> toProcessStack; // unfinished thumbnails
    QMutex toProcessStackMutex; // to protect todoStack in threads
};


class MediaThumbnailsBase : public QObject {
    Q_OBJECT

public:
    /*
      Constructor.
      dirPath - path to dir with thumbnails
    */
    explicit MediaThumbnailsBase(const QString dirPath = QDir::tempPath());

    /*
      Returns path to thumbnail for file, or null string, if no thumbnail.
      fileUrl - url of file
    */
    QString getThumbnailPath(const QUrl fileUrl);

    /*
      Returns absolute path to directory with thumbnail files.
    */
    QString getDirPath() const {return this->dir.absolutePath();}

public slots:
    /*
      Sets directory for thumbnails.
      dirPath - path to directory
    */
    void setDirPath(const QString dirPath);

    /*
      Adds thumbnail for file.
      mediaFile - file for thumbnail
    */
    void generateThumbnail(MediaFile* mediaFile);

    /*
      Removes all thumbnails.
    */
    void clear();

private:
    volatile int idCount; // number of thubnail ids
    QMutex idCountMutex; // to protect count in threads
    QMap<QUrl, int> base; // id for thumbnails
    QMutex baseMutex; // to protect base in threads
    QMap<QUrl, int> toProcess; // id for not ready thumbnails
    QMultiMap<int, MediaFile*> toProcessFiles; // files with not ready thumbnails by id
    QMutex toProcessMutex; // to protect todo and todoFiles in threads
    QDir dir; // to operate with thumbnails dir
    MediaThumbnailGeneratorTread generatorThread;

    /*
      Returns name of thumbnail file by id.
    */
    QString getThumbnailNameById(int id) const {return QString("thumbnail" + QString::number(id) + ".jpg");}

    /*
      Returns path to thumbnail by id.
    */
    QString getThumbnailPathById(int id) const {return this->dir.absoluteFilePath(this->getThumbnailNameById(id));}

private slots:
    /*
      Move thumbnail id from todo to base.
      fileSource - source file
    */
    void finishThumbnail(const QUrl& fileSource);
};

#endif // _MediaThumbnails_h_
