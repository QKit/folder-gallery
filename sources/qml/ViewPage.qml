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

    property MediaDir dir: mediaRoots.list[0] // source directory
    property alias iCurrentFile: viewPageViewer.currentIndex

    toolbar: QKitToolbar {
        leftButton: QKitToolbarBackButton { onClicked: viewPage.backToggled() }
        rightButton: QKitToolbarMenuButton { onClicked: viewPage.menuToggled() }
    }

    Keys.onRightPressed: viewPageViewer.incrementCurrentIndex()
    Keys.onLeftPressed: viewPageViewer.decrementCurrentIndex()

    ListView {
        id: viewPageViewer

        anchors.fill: parent
        orientation: "Horizontal"
        snapMode: "SnapOneItem"
        highlightMoveDuration: 0
        highlightMoveSpeed: -1
        delegate: Item {
            width:  viewPage.width
            height:  viewPage.height
            Image { // to view while image loading
                visible: image.status != Image.Ready
                anchors.centerIn: parent
                scale: Math.min(viewPage.width / sourceSize.width, viewPage.height / sourceSize.height)
                source: viewPageViewer.model[index].thumbnail
                asynchronous: false
            }
            Image { // to view on none zoom
                id: image
                visible: status == Image.Ready
                anchors.centerIn: parent
                source: viewPageViewer.model[index].source
                scale: Math.min(1, viewPage.width / sourceSize.width, viewPage.height / sourceSize.height)
                asynchronous: true
                onStatusChanged: {
                    if (status == Image.Ready) {
                        var resizeScale = Math.min(1, Math.max(viewPage.width, viewPage.height) / Math.min(sourceSize.width, sourceSize.height))
                        sourceSize.width *= resizeScale
                        sourceSize.height *= resizeScale
                    }
                }
            }
        }
        model: viewPage.dir.files

        MouseArea { // for toolbar removing
            anchors.fill: parent
            onClicked: viewPage.toolbar.active = !viewPage.toolbar.active // reactivate toolbar
        }
    }
}
