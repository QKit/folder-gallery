/*******************************************************************************
*                                                                              *
*  Main application item implementation.                                       *
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
import MediaRoots 1.0
import "./stack.js" as DirStack

QKitApplication {
    id: application

    MediaRoots { id: mediaRoots }

    HomePage { // page with all folders
        id: homePage

        onOpenFolderToggled: {
            folderPage.dir = homePage.selectedDir
            application.state = "folder"
        }
        onMenuToggled: menu.active = true
    }

    FolderPage { // page with images in particular folder
        id: folderPage

        onBackToggled: {
            if (DirStack.isEmpty()) { // no previous folder pages
                application.state = "home"
            } else { // there are some folder pages in stack
                folderPage.dir = DirStack.pop()
                application.state = "folder"
            }
        }
        onViewFolderToggled: {
            DirStack.push(dir)
            folderPage.dir = folderPage.selectedDir
            application.state = "folder"
        }
        onViewFileToggled: {
            viewPage.dir = folderPage.dir
            viewPage.iCurrentFile = folderPage.selectedFileIndex
            application.state = "view"
        }
        onMenuToggled: menu.active = true
    }

    ViewPage { // page with image view
        id: viewPage
        onBackToggled: application.state = "folder"
        onMenuToggled: menu.active = true
    }

    QKitMenu {
        id: menu

        QKitMenuElement { // goto website button
            text: qsTr("Homepage")
            onClicked: Qt.openUrlExternally("http://MaemoWorld.ru/wiki/index.php?title=Folder_Gallery")
        }
        QKitMenuElement { // exit button
            text: qsTr("Quit")
            onClicked: Qt.quit()
        }

        onClosed: {
            switch (application.state) {
            case "home":
                homePage.forceActiveFocus()
                break
            case "folder":
                folderPage.forceActiveFocus()
                break
            case "view":
                viewPage.forceActiveFocus()
                break
            }
        }
    }

    state: "home" // starts with home page
    states: [
        State { // active page is home
            name: "home"
            PropertyChanges {
                target: homePage
                visible: true
                focus: true
            }
            PropertyChanges {
                target: folderPage
                visible: false
            }
            PropertyChanges {
                target: viewPage
                visible: false
            }
        },
        State { // active page is folder
            name: "folder"
            PropertyChanges {
                target: homePage
                visible: false
            }
            PropertyChanges {
                target: folderPage
                visible: true
                focus: true
            }
            PropertyChanges {
                target: viewPage
                visible: false
            }
        },
        State { // active page is image view
            name: "view"
            PropertyChanges {
                target: homePage
                visible: false
            }
            PropertyChanges {
                target: folderPage
                visible: false
            }
            PropertyChanges {
                target: viewPage
                visible: true
                focus: true
            }
        }
    ]

//    onStateChanged: {
//        switch (application.state) {
//        case "home":
//            homePage.visible = false
//            homePage.visible = true
//            break
//        case "folder":
//            folderPage.visible = false
//            folderPage.visible = true
//            break
//        case "view":
//            viewPage.visible = false
//            viewPage.visible = true
//            break
//        }
//    }

    onFocusChanged: {
        if (!focus) return
        switch (application.state) {
        case "home":
            homePage.focus = true
            break
        case "folder":
            folderPage.focus = true
            break
        case "view":
            viewPage.facus = true
            break
        }
    }
}
