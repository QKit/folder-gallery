/*******************************************************************************
*                                                                              *
*  Button item for toolbars implementation.                                    *
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

QKitButton {
    id: button
    objectName: "QKitToolbarButton"

    function makeLeft() {position.state = "left"}
    function makeRight() {position.state = "right"}

    anchors.verticalCenter: parent.verticalCenter
    width: 0.18 * parent.width
    height: 0.8 * parent.height
    radius: 0.3 * height
    borderWidth: uiController.toolbarButtonBorderWidth
    smooth: uiController.toolbarButtonSmooth
    backgroundColor: uiController.toolbarButtonBackgroundColor // background color
    backgroundColorDimmed: uiController.toolbarButtonBackgroundColorDimmed // background color when button is pressed
    backgroundColorSelected: uiController.toolbarButtonBackgroundColorSelected // background color when button is selected
    borderColor: uiController.toolbarButtonBorderColor // border color
    borderColorDimmed: uiController.toolbarButtonBorderColorDimmed // border color when button is pressed
    borderColorSelected: uiController.toolbarButtonBorderColorSelected // border color when button is selected
    textColor: uiController.toolbarButtonTextColor // text color
    textColorDimmed: uiController.toolbarButtonTextColorDimmed // text color when button is pressed
    textColorSelected: uiController.toolbarButtonTextColorSelected // text color when button is selected
    mouseHoverEnabled: uiController.mouseHoverEnabled // handle mouse hover or not
    // key properties
    pressKey: keyController.toolbarButtonPressKey // key for press

    Item { // position states
        id: position
        state: "middle"
        states: [
            State {
                name: "middle"
                PropertyChanges {
                    target: button
                    x: button.parent.width / 2 - button.width / 2
                }
            },
            State {
                name: "left"
                PropertyChanges {
                    target: button
                    x: 0.01 * button.parent.width
                }
            },
            State {
                name: "right"
                PropertyChanges {
                    target: button
                    x: 0.99 * button.parent.width - button.width
                }
            }
        ]
    }
}
