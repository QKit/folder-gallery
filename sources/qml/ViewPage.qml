/*******************************************************************************
*                                                                              *
*  Page with image view implementation.                                        *
*                                                                              *
*  Copyright (C) 2011-2012 Kirill Chuvilin.                                    *
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

import Qt 4.7
import "QKit"
import MediaDir 1.0

QKitPage {
    id: viewPage

    property alias files: viewPageViewer.model
    property alias iCurrentFile: viewPageViewer.currentIndex

    Keys.onRightPressed: viewPageViewer.incrementCurrentIndex()
    Keys.onLeftPressed: viewPageViewer.decrementCurrentIndex()
    toolbar: QKitToolbar {
//        color: "#00000000"
//        borderColor: "#00000000"
        QKitToolbarBackButton { onClicked: viewPage.backToggled() }
        QKitToolbarMenuButton { onClicked: viewPage.menuToggled() }
    }

    QKitListView {
        id: viewPageViewer

        anchors.fill: parent
        orientation: "Horizontal"
        snapMode: "SnapOneItem"
        highlightMoveDuration: 0
        highlightMoveSpeed: -1
        highlightRangeMode: ListView.StrictlyEnforceRange // to change currentIndex on moving
        delegate: Item {
            id: fileViewer

            property bool isCurrent: index === viewPageViewer.currentIndex
            property url source: viewPage.files[index].source
            property url thumbnail: viewPage.files[index].thumbnail
            property variant imageSize: viewPage.files[index].previewSize
            property real resizeScale: Math.min(1, width / imageSize.width, height / imageSize.height)
            property int imageWidth: imageSize.width * resizeScale
            property int imageHeight: imageSize.height * resizeScale
            property alias image: imagePreview

            function resetImage() {
                image.scale = 1;
                image.rotation = 0;
                image.x = (width - imageWidth) / 2
                image.y = (height - imageHeight) / 2
            }

            width:  viewPage.width
            height:  viewPage.height

            onWidthChanged: resetImage()
            onHeightChanged: resetImage()
            onIsCurrentChanged: if (!isCurrent) resetImage()
            Component.onCompleted: resetImage()

            Image { // to view while preview loading
                id: imageThumbnail

                visible: imagePreview.status != Image.Ready
//                visible: imagePreview.status != Image.Ready && !imageZoomed.visible
                width: imageWidth
                height: imageHeight
                source: fileViewer.thumbnail
                fillMode: Image.PreserveAspectFit
                asynchronous: false
                smooth: true

                scale: imagePreview.scale
                rotation: imagePreview.rotation
                x: imagePreview.x
                y: imagePreview.y
            }
            Image { // to view on none zoom
                id: imagePreview

//                visible: !imageZoomed.visible
                width: imageWidth
                height: imageHeight
                sourceSize.width: fileViewer.width // Math.min(400, fileViewer.width)
                sourceSize.height: fileViewer.height // Math.min(400, fileViewer.height)
                source: "image://preview/" + fileViewer.source
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                smooth: uiController.thumbnailSmooth
            }
        }

        MouseArea { // for toolbar removing
            anchors.fill: parent
            onClicked: viewPage.toolbar.enabled = !viewPage.toolbar.enabled // reactivate toolbar
        }
    }

    QKitDragArea {
        id: dragArea

        parent: viewPage
        anchors.fill: parent
        anchors.leftMargin: parent.width / 5
        anchors.rightMargin: parent.width / 5
        drag.target: viewPageViewer.currentItem ? viewPageViewer.currentItem.image : null
        drag.minimumScale: 0.2
        drag.maximumScale: 5
        drag.minimumRotation: -18000
        drag.maximumRotation: 18000
        drag.axis: (drag.target == null || drag.target.scale == 1 || drag.target.rotation == 0 ? 0 : Drag.XandYAxis)
    }
}
