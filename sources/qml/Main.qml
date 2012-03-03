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

    logController: QKitLogController {
        parentLogging: true
//        createdLogging: true
//        activeLogging: true
//        selectedLogging: true
//        activeFocusLogging: true
//        focusLogging: true
    }

    uiController: QKitUiController {
        pageTexture: "images/alder_pre.jpg"
    }

    HomePage { // page with all folders
        id: homePage
        objectName: "HomePage"

        onOpenFolderToggled: {
            folderPage.dir = dir
            application.state = "folder"
        }
        onMenuToggled: menu.active = true
    }

    FolderPage { // page with images in particular folder
        id: folderPage
        objectName: "FolderPage"

        onBackToggled: {
            if (DirStack.isEmpty()) { // no previous folder pages
                application.state = "home"
            } else { // there are some folder pages in stack
                folderPage.dir = DirStack.pop()
                application.state = "folder"
            }
        }
        onViewFolderToggled: {
            DirStack.push(folderPage.dir)
            folderPage.dir = dir
            application.state = "folder"
        }
        onViewFileToggled: {
            viewPage.files = folderPage.dir.files
            viewPage.iCurrentFile = index
            application.state = "view"
        }
        onMenuToggled: menu.active = true
    }

    ViewPage { // page with image view
        id: viewPage
        objectName: "ViewPage"
        onBackToggled: application.state = "folder"
        onMenuToggled: menu.active = true
    }

    QKitMenu {
        id: menu
        objectName: "Menu"

        children: [Text {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            font.pixelSize: 0.04 * Math.min(menu.width, menu.height)
            text: qsTr("by Kirill Chuvilin aka KiRiK for MaemoWorld.ru") + "\n" + qsTr("This is free full-featured version of application.") + "\n" + qsTr("Please pay it in Nokia Store if you liked it \n or want it to be developed.")
            horizontalAlignment: Text.AlignHCenter
            color: "white"
        }]
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

        QKitMenuElement { // goto website button
//            visible: new Date > new Date(2012,01,3)
            text: qsTr("Homepage")
            onClicked: Qt.openUrlExternally(qsTr("https://projects.developer.nokia.com/foldergallery"))
        }

        QKitMenuElement { // goto website button
            text: qsTr("Nokia Store")
            onClicked: Qt.openUrlExternally("http://store.ovi.com/content/193179")
        }

        QKitMenuElement { // exit button
            text: qsTr("Quit")
            onClicked: Qt.quit()
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
            viewPage.focus = true
            break
        }
    }

    // todo: why does focus goes to menuview?
    Component.onCompleted: forceActiveFocus()


//    Text {
//        anchors.left: parent.left
//        anchors.top: parent.top
//        text: qsTr(new Date + ", " + new Date(2012,00,31,23,52))
//    }
}
