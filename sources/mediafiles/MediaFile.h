/*******************************************************************************
*                                                                              *
*  Abstract media file implementation.                                         *
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

#ifndef _MediaFile_h_
#define _MediaFile_h_

#include <QObject>
#include <QUrl>
#include <QFileInfo>
#include <QImage>

class MediaFile : public QObject {
    Q_OBJECT

    Q_PROPERTY(bool isDir READ isDir CONSTANT) // indicates dir or not
    Q_PROPERTY(QString name READ getName NOTIFY sourceChanged) // name of file
    Q_PROPERTY(QUrl source READ getSource WRITE setSource NOTIFY sourceChanged) // path to file
    Q_PROPERTY(QUrl thumbnail READ getThumbnail NOTIFY thumbnailChanged) // path to thumbnail file

public:
    /*
      Constructor.
    */
    explicit MediaFile(const QString source = QString::null, QObject *parent = 0);
    explicit MediaFile(const QUrl source, QObject *parent = 0);

    /*
      Indicates dir or not.
    */
    static bool isDir() {return false;}

    /*
      Returns name of file.
    */
    QString getName() const {return this->fileInfo.baseName();}

    /*
      Returns path to file.
    */
    QUrl getSource() const {return QUrl::fromLocalFile(this->fileInfo.absoluteFilePath());}

    /*
      Returns path to thumbnail file.
    */
    QUrl getThumbnail();

    /*
      Returns thumbnail image for file.
      width  - width of thumbnail
      height - height of thumbnail
    */
    QImage getThumbnailImage(int width, int height) {return QImage(this->fileInfo.absoluteFilePath()).scaled(width, height, Qt::KeepAspectRatio);}

public slots:
    /*
      Sets path to file.
    */
    void setSource(const QString source);
    void setSource(const QUrl source) {this->setSource(source.toLocalFile());}

    /*
      Sets path to thumbnail file.
      path - path to thumbnail image
    */
    void setThumbnail(const QString path);

signals:
    /*
      Emited when source property changes.
    */
    void sourceChanged();

    /*
      Emited when thumbnail property changes.
    */
    void thumbnailChanged();

    /*
      Emited when new thumbnail needed.
      mediaFile - file for thumbnail
    */
    void generateThumbnail(MediaFile* mediaFile);

private:
    QFileInfo fileInfo; // file info object
    QString thumbnailPath; // path to thumbnail
};

#endif // _MediaFile_h_
