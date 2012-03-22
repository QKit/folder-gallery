/*******************************************************************************
*                                                                              *
*  Drag item implementation.                                                   *
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


QtObject { // transformation params group
    property Item target: null // id of the item to drag
    property bool active: false // if the target item is currently being dragged
    property real minimumScale: 1 // minimum of the Item::scale property
    property real maximumScale: 1 // maximum of the Item::scale property
    property real minimumRotation: 0 // minimum of the Item::rotation property
    property real maximumRotation: 0 // maximum of the Item::rotation property
    property int axis: 0 // dragging direction (Drag.XAxis, Drag.YAxis, Drag.XandYAxis, 0)
    property real minimumX: -3.4028234663852886e+38 // minimum limit how far the target can be dragged horizontally
    property real maximumX: 3.4028234663852886e+38 // maximum limit how far the target can be dragged horizontally
    property real minimumY: -3.4028234663852886e+38 // minimum limit how far the target can be dragged vertically
    property real maximumY: 3.4028234663852886e+38 // maximum limit how far the target can be dragged vertically
}
