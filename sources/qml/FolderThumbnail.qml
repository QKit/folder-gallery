/*******************************************************************************
*                                                                              *
*  Folder thunmbnail item implimentation.                                      *
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

QKitItem {
    id: folderThumbnail
    objectName: "QKitFolderThumbnail"

    property variant sourceDir // folder directory
    property color textColor: uiController.thumbnailBorderColor
    property color textColorSelected: uiController.thumbnailBorderColorSelected

    QKitColumn {
        visible: Qt.isQtObject(sourceDir)
        anchors.fill: parent
        QKitItem {
            id: imagesView

            width: parent.width
            height: parent.width
            QKitThumbnail {
                visible: Qt.isQtObject(sourceDir) && sourceDir.files.length > 2
                selected: folderThumbnail.selected
                anchors.centerIn: parent
                width: 0.9 * parent.width
                height: 0.9 * parent.height
                source: Qt.isQtObject(sourceDir) && sourceDir.files.length > 2 ? sourceDir.files[2].thumbnail : ""
                transform: Rotation {
                    angle: -20 + 40 * Math.random()
                    origin.x: width * (0.25 + 0.5 * Math.random())
                    origin.y: height * (0.25 + 0.5 * Math.random())
                }
            }
            QKitThumbnail {
                visible: Qt.isQtObject(sourceDir) && sourceDir.files.length > 1
                selected: folderThumbnail.selected
                anchors.centerIn: parent
                width: 0.9 * parent.width
                height: 0.9 * parent.height
                source: Qt.isQtObject(sourceDir) && sourceDir.files.length > 1 ? sourceDir.files[1].thumbnail : ""
                transform: Rotation {
                    angle: -20 + 40 * Math.random()
                    origin.x: width * (0.25 + 0.5 * Math.random())
                    origin.y: height * (0.25 + 0.5 * Math.random())
                }
            }
            QKitThumbnail {
                property bool isDirEmpty: !(Qt.isQtObject(sourceDir) && sourceDir.files.length > 0)

                selected: folderThumbnail.selected
                anchors.centerIn: parent
                width: 0.9 * parent.width
                height: 0.9 * parent.height
                source: isDirEmpty ? "images/icon-m-common-directory.png" : sourceDir.files[0].thumbnail
                backgroundColor: isDirEmpty ? "#00000000" : uiController.thumbnailBackgroundColor
                backgroundColorSelected: isDirEmpty ? backgroundColor : uiController.thumbnailBorderColor
                borderColor: isDirEmpty ? "#00000000" : uiController.thumbnailBorderColor
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 0.9 * parent.width
            horizontalAlignment: "AlignHCenter"
            elide: "ElideRight"
            font.pixelSize: 0.1 * parent.width
            color: (folderThumbnail.selected ? folderThumbnail.textColorSelected : folderThumbnail.textColor)
            text: Qt.isQtObject(sourceDir) ? sourceDir.name : ""
        }
    }
}
