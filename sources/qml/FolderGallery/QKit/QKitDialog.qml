/*******************************************************************************
*                                                                              *
*  Dialog item implementation.                                                 *
*                                                                              *
*  Copyright (C) 2011 Kirill Chuvilin.                                         *
*  All rights reserved.                                                        *
*  Contact: Kirill Chuvilin (kirill.chuvilin@gmail.com, kirik-ch.ru)           *
*                                                                              *
*  This file is part of the QKit project.                                      *
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

QKitRectangle {
    id: dialog

    property Item contentItem // item with content
    property int animationDuration: uiControl.dialogAnimationDuration

    signal opened() // emits on dialog open
    signal closed() // emits on dialog close

    active: false // initially closed
    anchors.fill: parent // fill parent when opened
    z: 1 // to view ower other
    color: dialog.uiControl.dialogBackgroundColor

    Item { // local variables
        id: local

        state: (dialog.active ? "opened" : "closed")
        states: [
            State {
                name: "opened"
                PropertyChanges {
                    target: dialog
                    visible: true
                }
                PropertyChanges {
                    target: dialog.contentItem
                    focus: true
                }
            },
            State {
                name: "closed"
                PropertyChanges {
                    target: dialog
                    visible: false
                    color: "#00000000"
                }
                PropertyChanges {
                    target: dialog.parent
                    focus: true
                }
            }
        ]

        transitions: [
            Transition {
                to: "opened"
                SequentialAnimation {
                    ColorAnimation {
                        target:  dialog
                        duration: animationDuration
                    }
                }
            }
        ]

        onStateChanged: {
            switch (state) {
            case "closed":
                dialog.closed()
                break
            case "opened":
                dialog.opened()
                break
            }
        }
    }

    MouseArea { // for out of bar click test
        anchors.fill: dialog
        onClicked: dialog.active = false // if clicked, then out of dialog element and dialog must be closed
    }

    onContentItemChanged: {
        contentItem.parent = dialog
        contentItem.focus = true
    }

    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Backspace:
        case Qt.Key_Escape:
            active = false
            break
        }
        event.accepted = true
    }
}
