/*******************************************************************************
*                                                                              *
*  Grid item implementation.                                                   *
*                                                                              *
*  Copyright (C) 2012 Kirill Chuvilin.                                         *
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

import Qt 4.7

Grid {
    id: item
    objectName: "QKitGrid"
    // controllers
    property Item controllerSource: parent // source of controller items
    property Item logController: controllerSource.logController // logging settings
    property Item uiController:  controllerSource.uiController  // item with UI settings
    property Item keyController: controllerSource.keyController // item with key settings
    property Item navController: controllerSource.navController // key navigation controllerler
    // QKit properties
    property bool selected: activeFocus // selected or not
    // logging
    Component.onCompleted: if (logController && logController.createdLogging) console.log(item.objectName + " - created")
    onActiveFocusChanged: if (logController && logController.activeFocusLogging) console.log(item.objectName + " - activeFocus changed to " + activeFocus)
    onEnabledChanged: if (logController && logController.enabledLogging) console.log(item.objectName + " - enabled changed to " + enabled)
    onFocusChanged: if (logController && logController.focusLogging) console.log(item.objectName + " - focus changed to " + focus)
    onParentChanged: if (logController && logController.parentLogging) console.log(item.objectName + " - parent changed to " + (item.parent ? item.parent.objectName : "[NULL]"))
    onSelectedChanged: if (logController && logController.selectedLogging) console.log(item.objectName + " - selected changed to " + selected)
}
