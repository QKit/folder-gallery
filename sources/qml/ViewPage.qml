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

import QtQuick 1.0
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

        visible: flick.zoom === 1
        anchors.fill: parent
        orientation: "Horizontal"
        snapMode: "SnapOneItem"
        highlightMoveDuration: 0
        highlightMoveSpeed: -1
        onCurrentIndexChanged: flick.zoom = 1
        onContentXChanged: {
            var newCurrentIndex = contentX / width
            if (Math.abs(newCurrentIndex - currentIndex) >= 0.95) currentIndex = newCurrentIndex
        }
        delegate: Item {
            id: file

            property url source: viewPage.files[index].source
            property url thumbnail: viewPage.files[index].thumbnail

            width:  viewPage.width
            height:  viewPage.height
            Image {
                // to view while image loading
                visible: !imagePreview.visible && !imageZoomed.visible
                anchors.centerIn: parent
                scale: Math.min(viewPage.width / sourceSize.width, viewPage.height / sourceSize.height)
                source: file.thumbnail
                asynchronous: false
            }
            Image { // to view on none zoom
                id: imagePreview

                property bool resized: false // ready resize or not

                visible: (status == Image.Ready) && resized && (flick.zoom === 1)
                anchors.centerIn: parent
                source: file.source
                scale: Math.min(1, viewPage.width / sourceSize.width, viewPage.height / sourceSize.height)
                asynchronous: true
                onSourceChanged: resized = false
                onStatusChanged: {
                    if (status == Image.Ready) {
                        var resizeScale = Math.min(1, Math.max(viewPage.width, viewPage.height) / Math.min(sourceSize.width, sourceSize.height))
                        sourceSize.width *= resizeScale
                        sourceSize.height *= resizeScale
                        resized = true
                    }
                }

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
                var newWidth = imageZoomed.sourceSize.width * imageZoomed.minScale * flick.zoom
                var newHeight = imageZoomed.sourceSize.height * imageZoomed.minScale * flick.zoom
                var centerX = flick.contentWidth / 2
                var centerY = flick.contentHeight / 2
                contentWidth = newWidth
                contentHeight = newHeight
            }
        }

        visible: (imageZoomed.status == Image.Ready) &&  (flick.zoom !== 1)
        z: 2
        anchors.fill: parent
        onZoomChanged: {
            if (zoom < 1)
                zoom = 1
            else if (zoom > 5)
                zoom = 5
        }
        onVisibleChanged: {
            viewPage.toolbar.visible = !visible
            if (visible) { // start of zooming
                flick.contentWidth = imageZoomed.sourceSize.width * imageZoomed.minScale * flick.zoom
                flick.contentHeight = imageZoomed.sourceSize.height * imageZoomed.minScale * flick.zoom
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

            property real minScale: Math.min(1, viewPage.width / sourceSize.width, viewPage.height / sourceSize.height)

            width: flick.contentWidth
            height: flick.contentHeight
            source: (viewPage.files && (viewPage.iCurrentFile >= 0) ? viewPage.files[viewPage.iCurrentFile].source : "")
            smooth: false
            asynchronous: true
        }
    }

//    Text {
//        anchors.left: parent.left
//        anchors.top: parent.top
//        text: "flick.contentX: " + flick.contentX + ", flick.contentY: " + flick.contentY
//    }


    QKitDialogButton { // zoom in button
        width: 0.8 * viewPage.toolbar.height
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
        width: 0.8 * viewPage.toolbar.height
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
