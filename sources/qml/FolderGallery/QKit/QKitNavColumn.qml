/*******************************************************************************
*                                                                              *
*  Column item with key navigation implementation.                             *
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

QKitColumn {
    property int currentItem: -1 // current active item
    property bool focusOnCurrent: false // highlight current item or not
    property bool looped: true // firt to last and vice versa

    Keys.onUpPressed: {
        if (!focusOnCurrent) {
            focusOnCurrent = true
            currentItem = children.length - 1
        } else {
            var newCurrentItem = currentItem - 1
            if (newCurrentItem >= 0)
                currentItem = newCurrentItem
            else if (looped)
                currentItem = children.length - 1
            else
                currentItem = 0
        }
    }
    Keys.onDownPressed: {
        if (!focusOnCurrent) {
            focusOnCurrent = true
            currentItem = 0
        } else {
            var newCurrentItem = currentItem + 1
            if (newCurrentItem <= children.length - 1)
                currentItem = newCurrentItem
            else if (looped)
                currentItem = 0
            else
                currentItem = children.length - 1
        }
    }

    onVisibleChanged: {
        if (!visible) {
            focusOnCurrent = false
            currentItem = -1
        }
    }
    onChildrenChanged: {
        focusOnCurrent = false
        currentItem = -1
    }
    onCurrentItemChanged: {
        if (focusOnCurrent && currentItem >= 0)
            children[currentItem].focus = true
    }
}
