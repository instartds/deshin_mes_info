//@charset UTF-8
/**
 *  Table layout 보정용 
 *  1. role: 'presentation' 제거
 *  2. table_td_div css 추가
 */
 
 Ext.define("Unilite.com.layout.UniTable", {
    extend: 'Ext.layout.container.Container',
	alias: ['layout.uniTable'],



    type: 'table',
    
    createsInnerCt: true,

    targetCls: Ext.baseCSSPrefix + 'table-layout-ct',
    tableCls: Ext.baseCSSPrefix + 'table-layout',
    cellCls: Ext.baseCSSPrefix + 'table-layout-cell',

    /**
     * @cfg {Object} tableAttrs
     * An object containing properties which are added to the {@link Ext.dom.Helper DomHelper} specification used to
     * create the layout's `<table>` element. Example:
     *
     *     {
     *         xtype: 'panel',
     *         layout: {
     *             type: 'table',
     *             columns: 3,
     *             tableAttrs: {
     *                 style: {
     *                     width: '100%'
     *                 }
     *             }
     *         }
     *     }
     */
    tableAttrs: null,

    /**
     * @cfg {Object} trAttrs
     * An object containing properties which are added to the {@link Ext.dom.Helper DomHelper} specification used to
     * create the layout's `<tr>` elements.
     */

    /**
     * @cfg {Object} tdAttrs
     * An object containing properties which are added to the {@link Ext.dom.Helper DomHelper} specification used to
     * create the layout's `<td>` elements.
     */

    getItemSizePolicy: function (item) {
        return this.autoSizePolicy;
    },
    
    initInheritedState: function (inheritedState, inheritedStateInner) {
        inheritedStateInner.inShrinkWrapTable  = true;
    },

    getLayoutItems: function() {
        var me = this,
            result = [],
            items = me.callParent(),
            item,
            len = items.length, i;

        for (i = 0; i < len; i++) {
            item = items[i];
            if (!item.hidden) {
                result.push(item);
            }
        }
        return result;
    },
    
    getHiddenItems: function(){
        var result = [],
            items = this.owner.items.items,
            len = items.length,
            i = 0, item;
            
        for (; i < len; ++i) {
            item = items[i];
            if (item.rendered && item.hidden) {
                result.push(item);
            }
        }    
        return result;
    },

    /**
     * @private
     * Iterates over all passed items, ensuring they are rendered in a cell in the proper
     * location in the table structure.
     */
    renderChildren: function() {
        var me = this,
            items = me.getLayoutItems(),
        	tbody,
        
            rows ,
            i = 0,
            len = items.length,
            hiddenItems = me.getHiddenItems(),
            cells, curCell, rowIdx, cellIdx, item, trEl, tdEl, itemCt, el;

        if(me.owner.getTargetEl().child('table', true) && me.owner.getTargetEl().child('table', true).tBodies)	{
        	
            tbody = me.owner.getTargetEl().child('table', true).tBodies[0];
            rows = tbody.rows
        
	        // Calculate the correct cell structure for the current items
	        cells = me.calculateCells(items);
	
	        // Loop over each cell and compare to the current cells in the table, inserting/
	        // removing/moving cells as needed, and making sure each item is rendered into
	        // the correct cell.
	        for (; i < len; i++) {
	            curCell = cells[i];
	            rowIdx = curCell.rowIdx;
	            cellIdx = curCell.cellIdx;
	            item = items[i];
	
	            // If no row present, create and insert one
	            trEl = rows[rowIdx];
	            if (!trEl) {
	                trEl = tbody.insertRow(rowIdx);
	                if (me.trAttrs) {
	                    trEl.set(me.trAttrs);
	                }
	            }
	
	            // If no cell present, create and insert one
	            itemCt = tdEl = Ext.get(trEl.cells[cellIdx] || trEl.insertCell(cellIdx));
	            if (me.needsDivWrap()) { //create wrapper div if needed - see docs below
	//                itemCt = tdEl.first() || tdEl.createChild({ tag: 'div', role: 'presentation' });
	//                itemCt.setWidth(null);
	            	var child = {tag: 'div', cls:'uni-table_td_div'};
	                itemCt = tdEl.first() || tdEl.createChild(child);
	                itemCt.setWidth(null);
	                itemCt.addCls('uni-table_td_div');
	            }
	
	            // Render or move the component into the cell
	            if (!item.rendered) {
	                me.renderItem(item, itemCt, 0);
	            } else if (!me.isValidParent(item, itemCt, rowIdx, cellIdx, tbody)) {
	                me.moveItem(item, itemCt, 0);
	            }
	
	            // Set the cell properties
	            if (me.tdAttrs) {
	                tdEl.set(me.tdAttrs);
	            }
	            if (item.tdAttrs) {
	                tdEl.set(item.tdAttrs);
	            }
	            tdEl.set({
	                colSpan: item.colspan || 1,
	                rowSpan: item.rowspan || 1,
	                id: item.cellId || '',
	                cls: me.cellCls + ' ' + (item.cellCls || '')
	            });
	
	            // If at the end of a row, remove any extra cells
	            if (!cells[i + 1] || cells[i + 1].rowIdx !== rowIdx) {
	                cellIdx++;
	                while (trEl.cells[cellIdx]) {
	                    trEl.deleteCell(cellIdx);
	                }
	            }
	        }
	
	        // Delete any extra rows
	        rowIdx++;
	        while (tbody.rows[rowIdx]) {
	            tbody.deleteRow(rowIdx);
	        }
        }    
        // Check if we've removed any cells that contain a component, we need to move
        // them so they don't get cleaned up by the gc
        for (i = 0, len = hiddenItems.length; i < len; ++i) {
            me.ensureInDocument(hiddenItems[i].getEl());
        }
        
    },
    
    ensureInDocument: function(el){
        var dom = el.dom.parentNode;
        while (dom) {
            if (dom.tagName.toUpperCase() == 'BODY') {
                return;
            }
            dom = dom.parentNode;
        } 
        
        Ext.getDetachedBody().appendChild(el);
    },

    calculate: function (ownerContext) {
        if (!ownerContext.hasDomProp('containerChildrenSizeDone')) {
            this.done = false;
        } else {
            var targetContext = ownerContext.targetContext,
                widthShrinkWrap = ownerContext.widthModel.shrinkWrap,
                heightShrinkWrap = ownerContext.heightModel.shrinkWrap,
                shrinkWrap = heightShrinkWrap || widthShrinkWrap,
                table = shrinkWrap && targetContext.el.child('table', true),
                targetPadding = shrinkWrap && targetContext.getPaddingInfo();

            if (widthShrinkWrap) {
                ownerContext.setContentWidth(table.offsetWidth + targetPadding.width, true);
            }

            if (heightShrinkWrap) {
                ownerContext.setContentHeight(table.offsetHeight + targetPadding.height, true);
            }
        }
    },

    finalizeLayout: function() {
        if (this.needsDivWrap()) {
            // set wrapper div width to match layed out item - see docs below
            var items = this.getLayoutItems(),
                i,
                iLen  = items.length,
                item;

            for (i = 0; i < iLen; i++) {
                item = items[i];

                Ext.fly(item.el.dom.parentNode).setWidth(item.getWidth());
            }
        }
    },

    /**
     * @private
     * Determine the row and cell indexes for each component, taking into consideration
     * the number of columns and each item's configured colspan/rowspan values.
     * @param {Array} items The layout components
     * @return {Object[]} List of row and cell indexes for each of the components
     */
    calculateCells: function(items) {
        var cells = [],
            rowIdx = 0,
            colIdx = 0,
            cellIdx = 0,
            totalCols = this.columns || Infinity,
            rowspans = [], //rolling list of active rowspans for each column
            i = 0, j,
            len = items.length,
            item;

        for (; i < len; i++) {
            item = items[i];

            // Find the first available row/col slot not taken up by a spanning cell
            while (colIdx >= totalCols || rowspans[colIdx] > 0) {
                if (colIdx >= totalCols) {
                    // move down to next row
                    colIdx = 0;
                    cellIdx = 0;
                    rowIdx++;

                    // decrement all rowspans
                    for (j = 0; j < totalCols; j++) {
                        if (rowspans[j] > 0) {
                            rowspans[j]--;
                        }
                    }
                } else {
                    colIdx++;
                }
            }

            // Add the cell info to the list
            cells.push({
                rowIdx: rowIdx,
                cellIdx: cellIdx
            });

            // Increment
            for (j = item.colspan || 1; j; --j) {
                rowspans[colIdx] = item.rowspan || 1;
                ++colIdx;
            }
            ++cellIdx;
        }

        return cells;
    },

    getRenderTree: function() {
        var me = this,
            items = me.getLayoutItems(),
            cells,
            rows = [],
            result = Ext.apply({
                tag: 'table',
                role: 'presentation',
                cls: me.tableCls,
                cellspacing: 0,
                cellpadding: 0,
                cn: {
                    tag: 'tbody',
                    //role: 'presentation',
                    cn: rows
                }
            }, me.tableAttrs),
            tdAttrs = me.tdAttrs,
            needsDivWrap = me.needsDivWrap(),
            i, len = items.length, item, curCell, tr, rowIdx, cellIdx, cell;

        // Calculate the correct cell structure for the current items
        cells = me.calculateCells(items);

        for (i = 0; i < len; i++) {
            item = items[i];
            
            curCell = cells[i];
            rowIdx = curCell.rowIdx;
            cellIdx = curCell.cellIdx;

            // If no row present, create and insert one
            tr = rows[rowIdx];
            if (!tr) {
                tr = rows[rowIdx] = {
                    tag: 'tr',
                    //role: 'presentation',
                    cn: []
                };
                if (me.trAttrs) {
                    Ext.apply(tr, me.trAttrs);
                }
            }

            // If no cell present, create and insert one
            cell = tr.cn[cellIdx] = {
                tag: 'td'/*,
                role: 'presentation'*/
            };
            if (tdAttrs) {
                Ext.apply(cell, tdAttrs);
            }
            Ext.apply(cell, {
                colSpan: item.colspan || 1,
                rowSpan: item.rowspan || 1,
                id: item.cellId || '',
                cls: me.cellCls + ' ' + (item.cellCls || '')
            });

            if (needsDivWrap) { //create wrapper div if needed - see docs below
                cell = cell.cn = {
                    tag: 'div'/*,
                    role: 'presentation'*/
                };
            }

            me.configureItem(item);
            // The DomHelper config of the item is the cell's sole child
            cell.cn = item.getRenderTree();
        }
        return result;
    },

    isValidParent: function(item, target, rowIdx, cellIdx) {
        var tbody,
            correctCell,
            table;

        // If we were called with the 3 arg signature just check that the parent table of the item is within the render target
        if (arguments.length === 3) {
            table = item.el.up('table');
            return table && table.dom.parentNode === target.dom;
        }
        tbody = this.owner.getTargetEl().child('table', true).tBodies[0];
        correctCell = tbody.rows[rowIdx].cells[cellIdx];
        return item.el.dom.parentNode === correctCell;
    },

    /**
     * @private
     * Opera 10.5 has a bug where if a table cell's child has box-sizing:border-box and padding, it
     * will include that padding in the size of the cell, making it always larger than the
     * shrink-wrapped size of its contents. To get around this we have to wrap the contents in a div
     * and then set that div's width to match the item rendered within it afterLayout. This method
     * determines whether we need the wrapper div; it currently does a straight UA sniff as this bug
     * seems isolated to just Opera 10.5, but feature detection could be added here if needed.
     */
    needsDivWrap: function() {
        return true; //Ext.isOpera10_5;
    }
});