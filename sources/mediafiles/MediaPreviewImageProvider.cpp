/*******************************************************************************
*                                                                              *
*  Preview image of media files provider for declarative items.                *
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

#include "MediaPreviewImageProvider.h"


MediaPreviewImageProvider::MediaPreviewImageProvider() :
    QDeclarativeImageProvider(QDeclarativeImageProvider::Image) {
}


QImage MediaPreviewImageProvider::requestImage(const QString & id, QSize * size, const QSize & requestedSize) {
    try {
        QUrl source(id);
        QImage result = MediaFile(source).getPreviewImage(requestedSize.width(), requestedSize.height());
        if (size) *size = result.size();
        return result;
    } catch (MediaFile::Exception exception) {
        if (exception == MediaFile::EXCEPTION_ACCESS) { // problem with access to file
            if (size) *size = QSize(0,0);
            return QImage(1,1, QImage::Format_ARGB32);
        }
        throw exception; // rethrow exception
    }
}
