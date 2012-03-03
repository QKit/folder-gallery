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

#ifndef _MediaPreviewImageProvider_h_
#define _MediaPreviewImageProvider_h_

#include <QDeclarativeImageProvider>
#include "MediaFile.h"

/*!
 * \brief Preview image of media files provider for declarative items.
 * \author KiRiK aka Kirill Chuvilin (kirik-ch.ru)
 */
class MediaPreviewImageProvider : public QDeclarativeImageProvider {

public:
    /*!
     * \brief Constructor.
     */
    MediaPreviewImageProvider();

    /*!
     * \brief Generates image by id.
     * \return preview image for media file
     * \param id string with url to file
     * \param size pointer to size of generated image
     * \param requestedSize sourceSize requested by an Image element
     */
    QImage requestImage(const QString & id, QSize * size, const QSize & requestedSize);
};

#endif // _MediaPreviewImageProvider_h_
