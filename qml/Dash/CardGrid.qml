/*
 * Copyright (C) 2013 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import "../Components"

DashRenderer {
    id: root

    readonly property int collapsedRows: {
        if (!cardTool || !cardTool.template || typeof cardTool.template["collapsed-rows"] != "number") return 2;
        return cardTool.template["collapsed-rows"];
    }

                                                   // ↓ This is the ubuntu store icon
    readonly property string backgroundShapeStyle: cardTool.isAppLikeScope && !cardTool.isAppLikeScopeAppCategory ? "shadow" : "flat"

    expandedHeight: grid.totalContentHeight
    collapsedHeight: Math.min(grid.contentHeightForRows(collapsedRows, grid.cellHeight), expandedHeight)
    collapsedItemCount: collapsedRows * grid.columns
    originY: grid.originY

    function cardPosition(index) {
        var pos = {};
        var row = Math.floor(index / grid.columns);
        var column = index % grid.columns;
        // Bit sad this is not symmetrical
        pos.x = column * grid.cellWidth + grid.margins;
        pos.y = row * grid.cellHeight;
        return pos;
    }

    ResponsiveGridView {
        id: grid
        anchors.fill: parent
        minimumHorizontalSpacing: (cardTool.isAppLikeScopeAppCategory && cardTool.isWideView) ? units.gu(5) : units.gu(1)
        delegateWidth: cardTool.cardWidth
        delegateHeight: cardTool.cardHeight
        verticalSpacing: units.gu(1)
        model: root.model
        displayMarginBeginning: root.displayMarginBeginning
        displayMarginEnd: root.displayMarginEnd
        cacheBuffer: root.cacheBuffer
        interactive: false
        delegate: Item {
            width: grid.cellWidth
            height: grid.cellHeight
            Loader {
                id: loader
                sourceComponent: cardTool.cardComponent
                anchors.horizontalCenter: parent.horizontalCenter
                onLoaded: {
                    item.objectName = "delegate" + index;
                    item.width = Qt.binding(function() { return cardTool.cardWidth; });
                    item.height = Qt.binding(function() { return cardTool.cardHeight; });
                    item.fixedHeaderHeight = Qt.binding(function() { return cardTool.headerHeight; });
                    item.fixedArtShapeSize = Qt.binding(function() { return cardTool.artShapeSize; });
                    item.cardData = Qt.binding(function() { return model; });
                    item.scopeStyle = root.scopeStyle;
                    item.backgroundShapeStyle = root.backgroundShapeStyle;
                }
                Connections {
                    target: loader.item
                    onClicked: root.clicked(index, result, loader.item, model)
                    onPressAndHold: root.pressAndHold(index, result, model)
                    onAction: root.action(index, result, actionId)
                }
            }
        }
    }
}
