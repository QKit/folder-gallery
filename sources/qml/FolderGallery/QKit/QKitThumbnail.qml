/*******************************************************************************
*                                                                              *
*  Image thumbnail item implementation.                                        *
*                                                                              *
*  Copyright (C) 2011 Kirill Chuvilin.                                         *
*  All rights reserved.                                                        *
*  Contact: Kirill Chuvilin (kirill.chuvilin@gmail.com, kirik-ch.ru)           *
*                                                                              *
*  This file is part of the QKit project.                                      *
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

import QtQuick 1.0

QKitItem {
    id: thumbnail

    property url source // image source
    property int borderWidth: uiControl.thumbnailBorderWidth
    property color borderColor: uiControl.thumbnailBorderColor
    property color borderColorSelected: uiControl.thumbnailBorderColorSelected
    property color backgroundColor: uiControl.thumbnailBackgroundColor
    property color backgroundColorSelected: uiControl.thumbnailBackgroundColorSelected
    property bool smooth: uiControl.thumbnailSmooth
    property bool asynchronous: uiControl.thumbnailAsynchronous // loading in separate thread

    QKitRectangle { // background
        id: thumbnailBackground

        visible: thumbnailImage.status == Image.Ready // to view only when image viewed
        anchors.centerIn: parent
        width: thumbnailImage.width + borderWidth
        height: thumbnailImage.height + borderWidth
        border.width: thumbnail.borderWidth
        border.color: thumbnail.borderColor
        color: thumbnail.backgroundColor
        smooth: thumbnail.smooth

        Item { // local variables
            id: local

            states: [
                State { // on selected or focused
                    name: "selected"
                    when: thumbnail.active && thumbnail.selected
                    PropertyChanges {
                        target: thumbnailBackground
                        color: thumbnail.backgroundColorSelected
                        border.color: thumbnail.borderColorSelected
                    }
                }
            ]
        }

        QKitImage {
            id: thumbnailImage

            property int maxWidth: thumbnail.width - 2 * thumbnail.borderWidth
            property int maxHeight: thumbnail.height - 2 * thumbnail.borderWidth
            property int originalSourceWidth // original source width
            property int originalSourceHeight // original source height
            property bool originalSizeStored: false // was oroginal source size stored or not

            function resize() {
                if (!thumbnailImage.originalSizeStored) return // if size wasn't stored can't resize - it will be done on size store
                var widthBased = thumbnailImage.maxWidth / thumbnailImage.originalSourceWidth < thumbnailImage.maxHeight / thumbnailImage.originalSourceHeight
                thumbnailImage.width = widthBased ? thumbnailImage.maxWidth : thumbnailImage.maxHeight * thumbnailImage.originalSourceWidth / thumbnailImage.originalSourceHeight
                thumbnailImage.height = widthBased ? thumbnailImage.maxWidth * thumbnailImage.originalSourceHeight / thumbnailImage.originalSourceWidth : thumbnailImage.maxHeight
                thumbnailImage.sourceSize.width = thumbnailImage.width
                thumbnailImage.sourceSize.height = thumbnailImage.height
            }

            anchors.centerIn: parent
            source: thumbnail.source
            smooth: thumbnail.smooth
            asynchronous: thumbnail.asynchronous

            onMaxWidthChanged: thumbnailImage.resize()
            onMaxHeightChanged: thumbnailImage.resize()
            onSourceChanged: originalSizeStored = false
            onStatusChanged: {
                if (thumbnailImage.status != Image.Ready) return
                thumbnailImage.originalSourceWidth = thumbnailImage.sourceSize.width
                thumbnailImage.originalSourceHeight = thumbnailImage.sourceSize.height
                thumbnailImage.originalSizeStored = true
                thumbnailImage.resize()
            }
        }
    }
}
