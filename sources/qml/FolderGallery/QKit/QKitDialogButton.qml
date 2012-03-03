/*******************************************************************************
*                                                                              *
*  Button item for dialogs implementation.                                     *
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
    radius: 0.4 * height
    border.width: uiControl.dialogButtonBorderWidth
    smooth: uiControl.dialogButtonSmooth
    backgroundColor: uiControl.dialogButtonBackgroundColor // background color
    backgroundColorDimmed: uiControl.dialogButtonBackgroundColorDimmed // background color when button is pressed
    backgroundColorSelected: uiControl.dialogButtonBackgroundColorSelected // background color when button is selected
    borderColor: uiControl.dialogButtonBorderColor // border color
    borderColorDimmed: uiControl.dialogButtonBorderColorDimmed // border color when button is pressed
    borderColorSelected: uiControl.dialogButtonBorderColorSelected // border color when button is selected
    textColor: uiControl.dialogButtonTextColor // text color
    textColorDimmed: uiControl.dialogButtonTextColorDimmed // text color when button is pressed
    textColorSelected: uiControl.dialogButtonTextColorSelected // text color when button is selected
    mouseHoverEnabled: uiControl.mouseHoverEnabled // handle mouse hover or not
}
