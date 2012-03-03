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

    function makeLeft() {position.state = "left"}
    function makeRight() {position.state = "right"}

    anchors.verticalCenter: parent.verticalCenter
    width: 0.18 * parent.width
    height: 0.8 * parent.height
    radius: 0.3 * height
    border.width: uiControl.toolbarButtonBorderWidth
    smooth: uiControl.toolbarButtonSmooth
    backgroundColor: uiControl.toolbarButtonBackgroundColor // background color
    backgroundColorDimmed: uiControl.toolbarButtonBackgroundColorDimmed // background color when button is pressed
    backgroundColorSelected: uiControl.toolbarButtonBackgroundColorSelected // background color when button is selected
    borderColor: uiControl.toolbarButtonBorderColor // border color
    borderColorDimmed: uiControl.toolbarButtonBorderColorDimmed // border color when button is pressed
    borderColorSelected: uiControl.toolbarButtonBorderColorSelected // border color when button is selected
    textColor: uiControl.toolbarButtonTextColor // text color
    textColorDimmed: uiControl.toolbarButtonTextColorDimmed // text color when button is pressed
    textColorSelected: uiControl.toolbarButtonTextColorSelected // text color when button is selected
    mouseHoverEnabled: uiControl.mouseHoverEnabled // handle mouse hover or not

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
