/*******************************************************************************
*                                                                              *
*  DragArea item nultitouch implementation.                                    *
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


import QtQuick 1.1


QKitDragAreaSingletouch {
    id: dragArea
    objectName: "QKitDragAreaSingletouch"

    property QKitDrag drag: QKitDrag{}

    PinchArea {
        id: dragAreaPinchArea
        objectName: dragArea.objectName + ":PinchArea"

        function fixTargetX() {
            if (dragArea.drag.target.x < pinch.minimumX)
                dragArea.drag.target.x = pinch.minimumX;
            else if (dragArea.drag.target.x > pinch.maximumX)
                dragArea.drag.target.x = pinch.maximumX;
        }

        function fixTargetY() {
            if (dragArea.drag.target.y < pinch.minimumY)
                dragArea.drag.target.y = pinch.minimumY;
            else if (dragArea.drag.target.y > pinch.maximumY)
                dragArea.drag.target.y = pinch.maximumY;
        }

        anchors.fill: parent
        pinch.target: Item {
            id: handleItem

            property real startRotation: 0
            property real startScale: 1
            property real startX: 0
            property real startY: 0
            property real dX: 0
            property real dY: 0
        }
        pinch.minimumScale: dragArea.drag.minimumScale
        pinch.maximumScale: dragArea.drag.maximumScale
        pinch.minimumRotation: dragArea.drag.minimumRotation
        pinch.maximumRotation: dragArea.drag.maximumRotation
        pinch.dragAxis: dragArea.drag.axis
        pinch.minimumX: dragArea.drag.minimumX
        pinch.maximumX: dragArea.drag.maximumX
        pinch.minimumY: dragArea.drag.minimumY
        pinch.maximumY: dragArea.drag.maximumY

        onPinchStarted: {
            dragArea.drag.active = true; // start of dragging
            if (Qt.isQtObject(dragArea.drag.target)) {
                handleItem.scale = dragArea.drag.target.scale;
                handleItem.rotation = dragArea.drag.target.rotation;
                handleItem.startScale = dragArea.drag.target.scale;
                handleItem.startRotation = dragArea.drag.target.rotation;
                var targetPosition = mapFromItem(dragArea.drag.target.parent, dragArea.drag.target.x, dragArea.drag.target.y) // target position in dragArea coordinate system
                handleItem.startX = targetPosition.x;
                handleItem.startY = targetPosition.y;
                if ((dragArea.drag.target.transformOrigin == Item.Top) || (dragArea.drag.target.transformOrigin == Item.Center) || (dragArea.drag.target.transformOrigin == Item.Bottom)) {
                    handleItem.dX = dragArea.drag.target.width / 2;
                } else if ((dragArea.drag.target.transformOrigin == Item.TopRight) || (dragArea.drag.target.transformOrigin == Item.Right) || (dragArea.drag.target.transformOrigin == Item.BottomRight)) {
                    handleItem.dX = dragArea.drag.target.width;
                } else {
                    handleItem.dX = 0;
                }
                if ((dragArea.drag.target.transformOrigin == Item.Left) || (dragArea.drag.target.transformOrigin == Item.Center) || (dragArea.drag.target.transformOrigin == Item.Right)) {
                    handleItem.dY = dragArea.drag.target.height / 2;
                } else if ((dragArea.drag.target.transformOrigin == Item.BottomLeft) || (dragArea.drag.target.transformOrigin == Item.Bottom) || (dragArea.drag.target.transformOrigin == Item.BottomRight)) {
                    handleItem.dY = dragArea.drag.target.height;
                } else {
                    handleItem.dY = 0;
                }
            }
        }
        onPinchFinished: {
            dragArea.drag.active = false; // end of dragging
        }
        onPinchUpdated: {
            if (Qt.isQtObject(dragArea.drag.target)) {
                dragArea.drag.target.scale = handleItem.scale;
                var kScale = handleItem.scale / handleItem.startScale;
                dragArea.drag.target.rotation = handleItem.rotation;
                var dAngle = handleItem.rotation - handleItem.startRotation;
                var cos = Math.cos(Math.PI / 180 * dAngle);
                var sin = Math.sin(Math.PI / 180 * dAngle);
                var newTargetX = ((handleItem.startX + handleItem.dX - pinch.startCenter.x) * cos - (handleItem.startY + handleItem.dY - pinch.startCenter.y) * sin) * kScale - handleItem.dX + pinch.center.x; // new target x in dragArea coordinate system
                var newTargetY = ((handleItem.startX + handleItem.dX - pinch.startCenter.x) * sin + (handleItem.startY + handleItem.dY - pinch.startCenter.y) * cos) * kScale - handleItem.dY + pinch.center.y; // new target y in dragArea coordinate system
                var newTargetPosition = mapToItem(dragArea.drag.target.parent, newTargetX, newTargetY) // target position in target parent coordinate system
                if (dragArea.drag.axis & Drag.XAxis) {
                    dragArea.drag.target.x = newTargetPosition.x;
                    fixTargetX(); // check limits
                }
                if (dragArea.drag.axis & Drag.YAxis) {
                    dragArea.drag.target.y = newTargetPosition.y;
                    fixTargetY(); // check limits
                }
            }
        }
    }
}
