/*******************************************************************************
*                                                                              *
*  DragArea item singletouch implementation.                                   *
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


QKitItem {
    id: dragArea
    objectName: "QKitDragAreaSingletouch"

    property QKitDrag drag: QKitDrag{}

    MouseArea {
        id: dragAreaMouseArea
        objectName: dragArea.objectName + ":MouseArea"

        property Item handleItem: Item { // scale and rotation handler
            property real radiusX: 0
            property real radiusY: 0
            property real startRadius: 0
            property real startAngle: 0
            property real dX: 0
            property real dY: 0

            function radius() {
                return Math.sqrt(radiusX * radiusX + radiusY * radiusY);
            }

            function angle() {
                if (radiusX < 0) {
                    return 180 / Math.PI * Math.atan(radiusY / radiusX) + 180;
                }
                if (radiusX > 0) {
                    if (radiusY < 0) return 180 / Math.PI * Math.atan(radiusY / radiusX) + 360;
                    return 180 / Math.PI * Math.atan(radiusY / radiusX);
                }
                // radiusX == 0
                if (radiusY < 0) return -90;
                if (radiusY > 0) return 90;
                return 0;
            }

            enabled: false
        }

        function fixTargetScale() {
            if (dragArea.drag.target.scale < dragArea.drag.minimumScale) {
                dragArea.drag.target.scale = dragArea.drag.minimumScale;
            } else if (dragArea.drag.target.scale > dragArea.drag.maximumScale) {
                dragArea.drag.target.scale = dragArea.drag.maximumScale;
            }
        }

        function fixTargetRoation() {
            if (dragArea.drag.target.rotation < dragArea.drag.minimumRotation) {
                dragArea.drag.target.rotation = dragArea.drag.minimumRotation;
            } else if (dragArea.drag.target.rotation > dragArea.drag.maximumRotation) {
                dragArea.drag.target.rotation = dragArea.drag.maximumRotation;
            }
        }

        function fixTargetX() {
            if (dragArea.drag.target.x < dragArea.drag.minimumX)
                dragArea.drag.target.x = dragArea.drag.minimumX;
            else if (dragArea.drag.target.x > dragArea.drag.maximumX)
                dragArea.drag.target.x = dragArea.drag.maximumX;
        }

        function fixTargetY() {
            if (dragArea.drag.target.y < dragArea.drag.minimumY)
                dragArea.drag.target.y = dragArea.drag.minimumY;
            else if (dragArea.drag.target.y > dragArea.drag.maximumY)
                dragArea.drag.target.y = dragArea.drag.maximumY;
        }

        anchors.fill: parent
        drag.target: dragArea.drag.target // to move item
        drag.axis: dragArea.drag.axis
        drag.minimumX: dragArea.drag.minimumX
        drag.maximumX: dragArea.drag.maximumX
        drag.minimumY: dragArea.drag.minimumY
        drag.maximumY: dragArea.drag.maximumY

        onPressed: {
            dragArea.drag.active = true; // start of dragging
            dragAreaMouseArea.drag.target = dragArea.drag.target // to move item
            handleItem.enabled = false;
        }
        onPressAndHold: {
            if (Qt.isQtObject(dragArea.drag.target)) {
                dragAreaMouseArea.drag.target = null; // to not move item
                handleItem.scale = dragArea.drag.target.scale;
                handleItem.rotation = dragArea.drag.target.rotation;
                var targetPosition = mapFromItem(dragArea.drag.target.parent, dragArea.drag.target.x, dragArea.drag.target.y) // target position in dragArea coordinate system
                handleItem.x = targetPosition.x;
                handleItem.y = targetPosition.y;
                handleItem.radiusX = mouseX - width / 2;
                handleItem.radiusY = mouseY - height / 2;
                handleItem.startRadius = handleItem.radius();
                handleItem.startAngle = handleItem.angle();
                handleItem.dX = - width / 2;
                if ((dragArea.drag.target.transformOrigin == Item.Top) || (dragArea.drag.target.transformOrigin == Item.Center) || (dragArea.drag.target.transformOrigin == Item.Bottom)) {
                    handleItem.dX += dragArea.drag.target.width / 2;
                } else if ((dragArea.drag.target.transformOrigin == Item.TopRight) || (dragArea.drag.target.transformOrigin == Item.Right) || (dragArea.drag.target.transformOrigin == Item.BottomRight)) {
                    handleItem.dX += dragArea.drag.target.width;
                }
                handleItem.dY = - height / 2;
                if ((dragArea.drag.target.transformOrigin == Item.Left) || (dragArea.drag.target.transformOrigin == Item.Center) || (dragArea.drag.target.transformOrigin == Item.Right)) {
                    handleItem.dY += dragArea.drag.target.height / 2;
                } else if ((dragArea.drag.target.transformOrigin == Item.BottomLeft) || (dragArea.drag.target.transformOrigin == Item.Bottom) || (dragArea.drag.target.transformOrigin == Item.BottomRight)) {
                    handleItem.dY += dragArea.drag.target.height;
                }
                handleItem.enabled = true;
            }
        }
        onReleased: {
            handleItem.enabled = false;
            dragArea.drag.active = false; // end of dragging
        }
        onPositionChanged: {
            if (handleItem.enabled) { // if scaling or rotation
                handleItem.radiusX = mouse.x - width / 2;
                handleItem.radiusY = mouse.y - height / 2;
                var kScale = handleItem.radius() / handleItem.startRadius;
                dragArea.drag.target.scale = handleItem.scale * kScale;
                fixTargetScale(); // check limits
                kScale = dragArea.drag.target.scale / handleItem.scale;
                var dAngle = handleItem.angle() - handleItem.startAngle;
                if (Math.abs(dAngle) > 180) dAngle = handleItem.startAngle < 0 ? 360 - dAngle : dAngle - 360;
                dragArea.drag.target.rotation = handleItem.rotation + dAngle;
                // todo:
                fixTargetRoation(); // check limits
                dAngle = dragArea.drag.target.rotation - handleItem.rotation;
                var cos = Math.cos(Math.PI / 180 * dAngle);
                var sin = Math.sin(Math.PI / 180 * dAngle);
                var newTargetX = ((handleItem.x + handleItem.dX) * cos - (handleItem.y + handleItem.dY) * sin) * kScale - handleItem.dX; // new target x in dragArea coordinate system
                var newTargetY = ((handleItem.x + handleItem.dX) * sin + (handleItem.y + handleItem.dY) * cos) * kScale - handleItem.dY; // new target y in dragArea coordinate system
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
    Rectangle { // to view center of scaling and rotation
        visible: dragAreaMouseArea.handleItem.enabled
        anchors.centerIn: parent
        width: 2 * radius
        height: 2 * radius
        z: 2
        radius: 0.02 * Math.min(parent.width, parent.height)
        color: "#3FFFFFFF"
        border.color: "#3F000000"
        border.width: 0.5 * radius
    }
}
