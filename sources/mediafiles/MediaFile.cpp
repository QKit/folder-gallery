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

#include "MediaFile.h"


MediaFile::MediaFile(const QString source, QObject *parent) :
    QObject(parent) {
    this->setSource(source);
}


MediaFile::MediaFile(const QUrl source, QObject *parent) :
    QObject(parent) {
    this->setSource(source);
}


QUrl MediaFile::getThumbnail() {
    if (this->thumbnailPath.isNull()) { // thumbnail isn't defined
        emit generateThumbnail(this); // signal to generate thumbnail for file
        return QUrl(""); // empty thumbnail
    }
    return QUrl::fromLocalFile(this->thumbnailPath); // path to thumbnail
}


void MediaFile::setSource(const QString source) {
    this->fileInfo.setFile(source);
    emit sourceChanged();
    this->setThumbnail(QString::null); // no thumbnail
}


void MediaFile::setThumbnail(const QString path) {
    this->thumbnailPath = path;
    emit thumbnailChanged(); // thumbnail was changed
}
