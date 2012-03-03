/*******************************************************************************
*                                                                              *
*  View of folder subfilders and files item implementation.                    *
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

QKitGridView {
    id: folderView

    property MediaDir selectedDir // will be set after selection
    property int selectedIndex // will be set after selection
    property bool markCurrent: false // mark current item or not

    signal folderClicked() // generates when clicked on folder
    signal fileClicked() // generates when clicked on file

    // select element with particular index
    function selectIndex(index) {
        selectedIndex = index
        if (model[index].isDir) {
            selectedDir = model[index]
            folderClicked()
        } else {
            fileClicked()
        }
    }

    cellWidth: Math.min(Math.round(width / Math.round(width / 256 + 0.5) - 0.5), 0.49 * width)
    cellHeight: 1.2 * cellWidth
    clip: true
    delegate: QKitItem {
        uiControl: folderView.uiControl
        width: folderView.cellWidth
        height: folderView.cellHeight

        FolderThumbnail { // thumbnail for folder element
            visible: folderView.model[index].isDir
            selected: (index == currentIndex) && folderView.markCurrent
            anchors.fill: parent
            sourceDir: visible ? folderView.model[index] : mediaRoots.list[0] // todo: find another default dir
        }

        QKitThumbnail { // thumbnail for folder element
            visible: !folderView.model[index].isDir
            selected: (index == currentIndex) && folderView.markCurrent
            anchors.fill: parent
            source: visible ? folderView.model[index].thumbnail : ""
            transform: Rotation {
                angle: -20 + 40 * Math.random()
                origin.x: width * (0.25 + 0.5 * Math.random())
                origin.y: height * (0.25 + 0.5 * Math.random())
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: folderView.selectIndex(index)
        }
    }

    onFocusChanged: if (!focus) folderView.markCurrent = false

    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Up:
            markCurrent = true
            moveCurrentIndexUp()
            break
        case Qt.Key_Right:
            markCurrent = true
            moveCurrentIndexRight()
            break
        case Qt.Key_Down:
            markCurrent = true
            moveCurrentIndexDown()
            break
        case Qt.Key_Left:
            markCurrent = true
            moveCurrentIndexLeft()
            break
        case Qt.Key_Select:
        case Qt.Key_Return:
        case Qt.Key_Enter:
            selectIndex(currentIndex)
            break
        default:
            return
        }
        event.accepted = true
    }
}
