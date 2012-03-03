/*******************************************************************************
*                                                                              *
*  Toolbar item implementation.                                                *
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
    id: toolbar
    objectName: "QKitToolbar"

    // UI properties
    property int   animationDuration: uiController.toolbarAnimationDuration
    property int   borderWidth: uiController.toolbarBorderWidth
    property color borderColor: uiController.toolbarBorderColor
    // key properties
    property int leftButtonPressKey: keyController.toolbarLeftButtonPressKey
    property int rightButtonPressKey: keyController.toolbarRightButtonPressKey
    // other properties
    property Item  leftButton
    property Item  rightButton

    function keyPressedEvent(event) { // key event handler
        switch (event.key) {
        case leftButtonPressKey:
            if (leftButton)
                leftButton.pressByKey(event)
            break
        case rightButtonPressKey:
            if (rightButton)
                rightButton.pressByKey(event)
            break
        default:
            return
        }
        event.accepted = true
    }

    signal opened() // emits on dialog open
    signal closed() // emits on dialog close

    active: true // initially opened
    anchors.right: parent.right
    anchors.bottom: parent.bottom // on bottom of the parent
    anchors.left: parent.left
    height: Math.max(0.1 * parent.height, 0.06 * parent.width)
    z: 1 // to view ower other
    color: uiController.toolbarBackgroundColor

    Item { // local variables
        id: local

        state: (toolbar.active ? "opened" : "closed")
        states: [
            State {
                name: "opened"
                PropertyChanges {
                    target: toolbar
                    visible: true
                    focus: true
                }
            },
            State {
                name: "closed"
                PropertyChanges {
                    target: toolbar
                    visible: false
                    height: 0
                }
                PropertyChanges {
                    target: toolbar.parent
                    focus: true
                }
            }
        ]

        transitions: [
            Transition {
                to: "opened"
                SequentialAnimation {
                    PropertyAnimation {
                        target:  toolbar
                        property: "visible"
                        duration: 0
                    }
                    PropertyAnimation {
                        target:  toolbar
                        property: "height"
                        duration: toolbar.animationDuration
                    }
                }
            },
            Transition {
                to: "closed"
                SequentialAnimation {
                    PropertyAnimation {
                        target:  toolbar
                        property: "height"
                        duration: toolbar.animationDuration
                    }
                    PropertyAnimation {
                        target:  toolbar
                        property: "visible"
                        duration: 0
                    }
                }
            }
        ]

        onStateChanged: {
            switch (state) {
            case "closed":
                toolbar.closed()
                break
            case "opened":
                toolbar.opened()
                break
            }
        }
    }

    Rectangle {
        anchors.top: toolbar.top
        anchors.right: toolbar.right
        anchors.left: toolbar.left
        height: toolbar.borderWidth
        color: toolbar.borderColor
    }

    onLeftButtonChanged: {
        leftButton.parent = toolbar
        leftButton.makeLeft()
    }
    onRightButtonChanged: {
        rightButton.parent = toolbar
        rightButton.makeRight()
    }

    Keys.onPressed: keyPressedEvent(event)
}
