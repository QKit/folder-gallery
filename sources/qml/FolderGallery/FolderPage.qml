/*******************************************************************************
*                                                                              *
*  Page with folder images implementation.                                     *
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
    id: folderPage

    property MediaDir dir: mediaRoots.list[0] // source directory  // todo: find another default dir
    property int selectedFileIndex // will be set after selection
    property MediaDir selectedDir // will be set after selection

    signal viewFileToggled() // goto file view
    signal viewFolderToggled() // goto folder page

    toolbar: QKitToolbar {
        leftButton: QKitToolbarBackButton { onClicked: folderPage.backToggled() }
        rightButton: QKitToolbarMenuButton { onClicked: folderPage.menuToggled() }
    }

    FolderView {
        id: folderView

        anchors.fill: parent
        model: folderPage.dir.content
        onFolderClicked: {
            folderPage.selectedDir = selectedDir
            folderPage.viewFolderToggled()
        }
        onFileClicked: {
            folderPage.selectedFileIndex = selectedIndex - dir.dirsCount
            folderPage.viewFileToggled()
        }
    }

    onFocusChanged: folderView.focus = focus
}
