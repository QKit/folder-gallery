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
import MediaFile 1.0
import MediaDir 1.0

QKitNavGridView {
    id: folderView

    property variant files
    property variant dirs
    property int __nDirs: 0

    signal folderClicked(variant dir, int index) // generates when clicked on folder
    signal fileClicked(variant file, int index) // generates when clicked on file

    function refreshModel() { // refreshes model according to files and dirs properties
        var newModel = []; // true for dir, false for file
        if (dirs) { // if dirs defines
            for (var iDir = 0; dirs[iDir]; iDir++)
                newModel[newModel.length] = true;
            __nDirs = iDir;
        }
        if (files) { // if files defined
            for (var iFile = 0; files[iFile]; iFile++)
                newModel[newModel.length] = false;
        }
        model = newModel;
    }

    cellWidth: Math.min(Math.round(width / Math.round(width / 192 + 0.5) - 0.5), 0.49 * width)
    cellHeight: 1.2 * cellWidth
    keyNavigationWraps: false
    onFilesChanged: refreshModel()
    onDirsChanged: refreshModel()
    delegate: QKitLoader {
        width: folderView.cellWidth
        height: folderView.cellHeight
        controllerSource: GridView.view
        Component.onCompleted: sourceComponent = (folderView.model[index] ? folderThumbnail : fileThumbnail)

        onFocusChanged: if (focus) item.forceActiveFocus()

        Component {
            id: folderThumbnail
            FolderThumbnail { // thumbnail for folder element
                Keys.onPressed: {
                    if (event.key === keyController.buttonPressKey) {
                        folderClicked(folderView.dirs[index], index)
                        event.accepted = true
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: folderClicked(folderView.dirs[index], index)
                }
                Component.onCompleted: sourceDir = folderView.dirs[index]
            }
        }

        Component {
            id: fileThumbnail
            QKitThumbnail { // thumbnail for folder element
                source: (!folderView.model[index] &&  folderView.files[index - __nDirs] ? folderView.files[index - __nDirs].thumbnail : "")
                transform: Rotation {
                    angle: -20 + 40 * Math.random()
                    origin.x: width * (0.25 + 0.5 * Math.random())
                    origin.y: height * (0.25 + 0.5 * Math.random())
                }
                Keys.onPressed: {
                    if (event.key === keyController.buttonPressKey) {
                        fileClicked(folderView.files[index - __nDirs], index - __nDirs)
                        event.accepted = true
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: fileClicked(folderView.files[index - __nDirs], index - __nDirs)
                }
            }
        }
    }
}
