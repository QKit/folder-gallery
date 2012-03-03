/*******************************************************************************
*                                                                              *
*  Page with root media forlders implementation.                               *
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
    id: homePage

    property MediaDir selectedDir // will be set after selection
    signal openFolderToggled() // goto folder page

    toolbar: QKitToolbar {
        rightButton: QKitToolbarMenuButton {onClicked: homePage.menuToggled() }
    }

    FolderView {
        id: folderView
        focus: true
        anchors.fill: parent
        model: mediaRoots.list
        onFolderClicked: {
            homePage.selectedDir = selectedDir
            homePage.openFolderToggled() // to go to folder page
        }
    }

    onFocusChanged: folderView.focus = focus
}