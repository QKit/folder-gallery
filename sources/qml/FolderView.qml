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

QKitNavGridView {
    id: folderView

    signal folderClicked(variant dir, int index) // generates when clicked on folder
    signal fileClicked(variant file, int index) // generates when clicked on file

    cellWidth: Math.min(Math.round(width / Math.round(width / 256 + 0.5) - 0.5), 0.49 * width)
    cellHeight: 1.2 * cellWidth
    keyNavigationWraps: false
    delegate: QKitGridViewDelegate {
        width: folderView.cellWidth
        height: folderView.cellHeight

        Loader {
            id: thumbnail
            anchors.fill: parent
            sourceComponent: (folderView.model[index].isDir ? folderThumbnail : fileThumbnail)
        }
        onFocusChanged: if (focus) thumbnail.item.forceActiveFocus()

        Component {
            id: folderThumbnail
            FolderThumbnail { // thumbnail for folder element
                logController: folderView.logController // logging settings
                uiController:  folderView.uiController  // item with UI settings
                keyController: folderView.keyController // item with key settings
                navController: folderView.navController // key navigation controllerler
                sourceDir: folderView.model[index]
                Keys.onPressed: {
                    if (event.key == keyController.buttonPressKey) {
                        folderClicked(folderView.model[index], index)
                        event.accepted = true
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: folderClicked(folderView.model[index], index)
                }
            }
        }

        Component {
            id: fileThumbnail
            QKitThumbnail { // thumbnail for folder element
                logController: folderView.logController // logging settings
                uiController:  folderView.uiController  // item with UI settings
                keyController: folderView.keyController // item with key settings
                navController: folderView.navController // key navigation controllerler
                source: folderView.model[index].thumbnail
                transform: Rotation {
                    angle: -20 + 40 * Math.random()
                    origin.x: width * (0.25 + 0.5 * Math.random())
                    origin.y: height * (0.25 + 0.5 * Math.random())
                }
                Keys.onPressed: {
                    if (event.key == keyController.buttonPressKey) {
                        fileClicked(folderView.model[index], index)
                        event.accepted = true
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: fileClicked(folderView.model[index], index)
                }
            }
        }
    }
}
