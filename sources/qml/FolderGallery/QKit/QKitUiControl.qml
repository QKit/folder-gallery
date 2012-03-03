/*******************************************************************************
*                                                                              *
*  UI settings item implementation.                                            *
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

Item {
    property bool buttonSmooth: true // use smooth for buttons or not
    property bool mouseHoverEnabled: true // handle mouse hover or not

    property color pageBackgroundColor: "#FFFFFF"
    property color pageTextColor: "#000000"

    property color dialogBackgroundColor: "#BF000000"
    property int   dialogAnimationDuration: 250
    property color dialogButtonBackgroundColor: "#5F000000"
    property color dialogButtonBackgroundColorDimmed: "#0FFFFFFF"
    property color dialogButtonBackgroundColorSelected: dialogButtonBackgroundColor
    property color dialogButtonBorderColor: "#7FFFFFFF"
    property color dialogButtonBorderColorDimmed: "#FFFFFF"
    property color dialogButtonBorderColorSelected: "#FFFFFF"
    property color dialogButtonTextColor: dialogButtonBorderColor
    property color dialogButtonTextColorDimmed: dialogButtonBorderColorDimmed
    property color dialogButtonTextColorSelected: dialogButtonBorderColorSelected
    property int   dialogButtonBorderWidth: 1
    property bool  dialogButtonSmooth: buttonSmooth // use smooth for buttons or not

    property color toolbarBackgroundColor: "#7FDFDFDF"
    property color toolbarBorderColor: "#DF7F7F7F"
    property int   toolbarBorderWidth: 1
    property int   toolbarAnimationDuration: 250
    property color toolbarButtonBackgroundColor: "#00000000"
    property color toolbarButtonBackgroundColorDimmed: "#3F000000"
    property color toolbarButtonBackgroundColorSelected: toolbarButtonBackgroundColor
    property color toolbarButtonBorderColor: toolbarBorderColor
    property color toolbarButtonBorderColorDimmed: "#FFFFFF"
    property color toolbarButtonBorderColorSelected: "#FFFFFF"
    property color toolbarButtonTextColor: toolbarButtonBorderColor
    property color toolbarButtonTextColorDimmed: toolbarButtonBorderColorDimmed
    property color toolbarButtonTextColorSelected: toolbarButtonBorderColorSelected
    property int   toolbarButtonBorderWidth: 1
    property bool  toolbarButtonSmooth: buttonSmooth // use smooth for buttons or not

    property bool  thumbnailSmooth: false // use smooth for thumbnails or not
    property bool  thumbnailAsynchronous: true // load in separate thread or not
    property color thumbnailBackgroundColor: "#DFDFDF"
    property color thumbnailBackgroundColorSelected: thumbnailBackgroundColor
    property int   thumbnailBorderWidth: 2
    property color thumbnailBorderColor: "#DF7F7F7F"
    property color thumbnailBorderColorSelected: "#0000DF"

    property url iconMToolbarBack: "images/icon-m-toolbar-back.png"
    property url iconMToolbarBackSelected: "images/icon-m-toolbar-back-selected.png"
    property url iconMToolbarBackDimmed: "images/icon-m-toolbar-back-dimmed.png"
    property url iconMToolbarViewMenu: "images/icon-m-toolbar-view-menu.png"
    property url iconMToolbarViewMenuSelected: "images/icon-m-toolbar-view-menu-selected.png"
    property url iconMToolbarViewMenuDimmed: "images/icon-m-toolbar-view-menu-dimmed.png"
}
