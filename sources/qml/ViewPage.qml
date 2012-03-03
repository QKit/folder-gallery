/*******************************************************************************
*                                                                              *
*  Page with image view implementation.                                        *
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
        leftButton: QKitToolbarBackButton { onClicked: viewPage.backToggled() }
        rightButton: QKitToolbarMenuButton { onClicked: viewPage.menuToggled() }
    }

    ListView {
        id: viewPageViewer

        visible: !flick.visible
        anchors.fill: parent
        orientation: "Horizontal"
        snapMode: "SnapOneItem"
        highlightMoveDuration: 0
        highlightMoveSpeed: -1
        highlightRangeMode: ListView.StrictlyEnforceRange // to change currentIndex on moving
        onCurrentItemChanged: flick.zoom = 1
        delegate: Item {
            id: fileViewer

            property url source: viewPage.files[index].source
            property url thumbnail: viewPage.files[index].thumbnail
            property variant imageSize: viewPage.files[index].previewSize
            property real resizeScale: Math.min(1, width / imageSize.width, height / imageSize.height)
            property int imageWidth: imageSize.width * resizeScale
            property int imageHeight: imageSize.height * resizeScale

            width:  viewPage.width
            height:  viewPage.height

            Image { // to view while preview loading
                id: imageThumbnail

                visible: imagePreview.status != Image.Ready
                anchors.centerIn: parent
                width: imageWidth
                height: imageHeight
                source: fileViewer.thumbnail
                fillMode: Image.PreserveAspectFit
                asynchronous: false
                smooth: true
            }
            Image { // to view on none zoom
                id: imagePreview

                anchors.centerIn: parent
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
            onClicked: viewPage.toolbar.active = !viewPage.toolbar.active // reactivate toolbar
        }
    }

    Flickable {
        id: flick

        property real zoom: 1

        function fixContentX() {
            if (contentWidth < width) {
                contentX = - (width - contentWidth) / 2
            } else if (contentX < 0) {
                contentX = 0
            } else if (contentX > contentWidth - width) {
                contentX = contentWidth - width
            }
        }
        function fixContentY() {
            if (contentHeight < height) {
                contentY = - (height - contentHeight) / 2
            } else if (contentY < 0) {
                contentY = 0
            } else if (contentY > contentHeight - height) {
                contentY = contentHeight - height
            }
        }
        function zoomContent() {
            if (zoom != 1) {
                imageZoomed.scale = imageZoomed.minScale * flick.zoom
            }
        }

        visible: (imageZoomed.status == Image.Ready) &&  (flick.zoom !== 1)
        anchors.fill: parent
        z: 2
        contentWidth: imageZoomed.width * imageZoomed.scale
        contentHeight: imageZoomed.height * imageZoomed.scale
        onZoomChanged: {
            if (zoom < 1)
                zoom = 1 // minimum zoom
            else if (zoom > 4)
                zoom = 4 // maximum zoom
        }
        onVisibleChanged: {
            viewPage.toolbar.visible = !visible
            if (visible) { // start of zooming
                imageZoomed.minScale = Math.min(1, viewPage.width / imageZoomed.width, viewPage.height / imageZoomed.height)
                imageZoomed.scale = imageZoomed.minScale * flick.zoom
                flick.contentX = - (flick.width - flick.contentWidth) / 2
                flick.contentY = - (flick.height - flick.contentHeight) / 2
            }
        }
        onWidthChanged: fixContentX()
        onHeightChanged: fixContentY()
        onContentXChanged: fixContentX()
        onContentYChanged: fixContentY()
        onContentWidthChanged: fixContentX()
        onContentHeightChanged: fixContentY()

        Image { // to view full image on zoom
            id: imageZoomed

            property real minScale: 1

            anchors.centerIn: parent
            sourceSize.width: flick.width * 2
            sourceSize.height: flick.height * 2
            source: flick.zoom == 1 ? "" : "image://preview/" + viewPageViewer.currentItem.source
            smooth: uiController.thumbnailSmooth
            asynchronous: true
        }
    }

    QKitDialogButton { // zoom in button
        width: 0.06 * Math.max(parent.height, parent.width)
        height: width
        z: 3
        anchors.right: parent.right
        anchors.rightMargin: 0.2 * width
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: 0.2 * height
        imageSource: "images/icon-m-camera-zoom-in.svg"
        onClicked: {
            flick.zoom += 0.2
            flick.zoomContent()
        }
    }

    QKitDialogButton { // zoom out button
        width: 0.06 * Math.max(parent.height, parent.width)
        height: width
        z: 3
        anchors.right: parent.right
        anchors.rightMargin: 0.2 * width
        anchors.top: parent.verticalCenter
        anchors.topMargin: 0.2 * height
        imageSource: "images/icon-m-camera-zoom-out.svg"
        onClicked: {
            flick.zoom -= 0.2
            flick.zoomContent()
        }
    }
}
