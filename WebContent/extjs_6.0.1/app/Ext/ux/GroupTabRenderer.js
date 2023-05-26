/**
* Allows GroupTab to render a table structure.
*/
/*
Ext.define('Ext.ux.GroupTabRenderer', {
    extend: 'Ext.plugin.Abstract',
    alias: 'plugin.grouptabrenderer',

    tableTpl: new Ext.XTemplate(
        '<div id="{view.id}-body" class="' + Ext.baseCSSPrefix + '{view.id}-table ' + Ext.baseCSSPrefix + 'grid-table-resizer" style="{tableStyle}">',
            '{%',
                'values.view.renderRows(values.rows, values.viewStartIndex, out);',
            '%}',
        '</div>',
        {
            priority: 5
        }
    ),

    rowTpl: new Ext.XTemplate(
        '{%',
            'Ext.Array.remove(values.itemClasses, "', Ext.baseCSSPrefix + 'grid-row");',
            'var dataRowCls = values.recordIndex === -1 ? "" : " ' + Ext.baseCSSPrefix + 'grid-data-row";',
        '%}',
        '<div {[values.rowId ? ("id=\\"" + values.rowId + "\\"") : ""]} ',
            'data-boundView="{view.id}" ',
            'data-recordId="{record.internalId}" ',
            'data-recordIndex="{recordIndex}" ',
            'class="' + Ext.baseCSSPrefix + 'grouptab-row {[values.itemClasses.join(" ")]} {[values.rowClasses.join(" ")]}{[dataRowCls]}" ',
            '{rowAttr:attributes}>',
            '<tpl for="columns">' +
                '{%',
                    'parent.view.renderCell(values, parent.record, parent.recordIndex, parent.rowIndex, xindex - 1, out, parent)',
                 '%}',
            '</tpl>',
        '</div>',
        {
            priority: 5
        }
    ),

    cellTpl: new Ext.XTemplate(
        '{%values.tdCls = values.tdCls.replace(" ' + Ext.baseCSSPrefix + 'grid-cell "," ");%}',
        '<div class="' + Ext.baseCSSPrefix + 'grouptab-cell {tdCls}" {tdAttr}>',
            '<div {unselectableAttr} class="' + Ext.baseCSSPrefix + 'grid-cell-inner" style="text-align: {align}; {style};">{value}</div>',
            '<div class="x-grouptabs-corner x-grouptabs-corner-top-left"></div>',
            '<div class="x-grouptabs-corner x-grouptabs-corner-bottom-left"></div>',
        '</div>',
        {
            priority: 5
        }
    ),

    selectors: {
        // Outer table
        bodySelector: 'div.' + Ext.baseCSSPrefix + 'grid-table-resizer',

        // Element which contains rows
        nodeContainerSelector: 'div.' + Ext.baseCSSPrefix + 'grid-table-resizer',

        // row
        itemSelector: 'div.' + Ext.baseCSSPrefix + 'grouptab-row',

        // row which contains cells as opposed to wrapping rows
        rowSelector: 'div.' + Ext.baseCSSPrefix + 'grouptab-row',

        // cell
        cellSelector: 'div.' + Ext.baseCSSPrefix + 'grouptab-cell', 

        getCellSelector: function(header) {
            return header ? header.getCellSelector() : this.cellSelector; 
        }

    },

    init: function(grid) {
        var view = grid.getView(), 
            me = this;
        view.addTpl(me.tableTpl);
        view.addRowTpl(me.rowTpl);
        view.addCellTpl(me.cellTpl);
        Ext.apply(view, me.selectors);
    }
});
*/
Ext.define('Ext.ux.GroupTabRenderer', {
    extend: 'Ext.plugin.Abstract',
    alias: 'plugin.grouptabrenderer',

    // template 작성 (view/table.js 참고)
    tableTpl: new Ext.XTemplate(
    	'{%',
            'view = values.view;',
            'if (!(columns = values.columns)) {',
                'columns = values.columns = view.ownerCt.getVisibleColumnManager().getColumns();',
            '}',
            'values.fullWidth = 0;',
            // Stamp cellWidth into the columns
            'for (i = 0, len = columns.length; i < len; i++) {',
                'column = columns[i];',
                'values.fullWidth += (column.cellWidth = column.lastBox ? column.lastBox.width : column.width || column.minWidth);',
            '}',

            // Add the row/column line classes to the container element.
            'tableCls=values.tableCls=[];',
        '%}',
        '<div id="{view.id}-body" class="' + Ext.baseCSSPrefix + '{view.id}-table ' + Ext.baseCSSPrefix + 'grid-table-resizer" style="width:{fullWidth}px;{tableStyle}">',
            '{%',
                'values.view.renderRows(values.rows, values.columns, values.viewStartIndex, out);',
            '%}',
        '</div>',
        {
        	definitions: 'var view, tableCls, columns, i, len, column;',
            priority: 99999999	//수를 크게 하여 다른 클래스의 template apply를 막는다. (viwe.addXXX 를 사용하여 템플릿 추가 시)
        }
    ),

    rowTpl: new Ext.XTemplate(
        '{%',
        	'this.processRowValues(values);',
            'Ext.Array.remove(values.itemClasses, "', Ext.baseCSSPrefix + 'grid-row");',
            'var dataRowCls = values.recordIndex === -1 ? "" : " ' + Ext.baseCSSPrefix + 'grid-data-row";',
        '%}',
        '<table {[values.rowId ? ("id=\\"" + values.rowId + "\\"") : ""]} ',
            'data-boundView="{view.id}" ',
            'data-recordId="{record.internalId}" ',
            'data-recordIndex="{recordIndex}" ',
            'class="' + Ext.baseCSSPrefix + 'grouptab-item {[values.itemClasses.join(" ")]} {[values.rowClasses.join(" ")]}{[dataRowCls]}" ',
            'cellPadding="0" cellSpacing="0" {ariaTableAttr} style="{itemStyle};width:0" ',
            '{%',
                'var dataRowCls = values.recordIndex === -1 ? "" : " ' + Ext.baseCSSPrefix + 'grid-row";',
            '%}>',
            '<tr class="' + Ext.baseCSSPrefix + 'grouptab-row {[values.rowClasses.join(" ")]} {[dataRowCls]}" {rowAttr:attributes} {ariaRowAttr}>',
            '<tpl for="columns">' +
                '{%',
                    'parent.view.renderCell(values, parent.record, parent.recordIndex, parent.rowIndex, xindex - 1, out, parent)',
                 '%}',
            '</tpl>',
            '</tr>',
            '</table>',
        {
            priority: 99999999,
            processRowValues: function(rowValues) {	// tree의 +,- 아이콘 처리 위해 추가 (tree/view.js 참고)
                var record = rowValues.record,
                    view = rowValues.view;

                // We always need to set the qtip/qtitle, because they may have been
                // emptied, which means we still need to flush that change to the DOM
                // so the old values are overwritten
                rowValues.rowAttr['data-qtip'] = record.get('qtip') || '';
                rowValues.rowAttr['data-qtitle'] = record.get('qtitle') || '';
                if (record.isExpanded()) {
                    rowValues.rowClasses.push(view.expandedCls);
                }
                if (record.isLeaf()) {
                    rowValues.rowClasses.push(view.leafCls);
                }
                if (record.isLoading()) {
                    rowValues.rowClasses.push(view.loadingCls);
                }
            }
        }
    ),

    cellTpl: new Ext.XTemplate(
        '<td class="' + Ext.baseCSSPrefix + 'grouptab-cell {tdCls}" {tdAttr} {[Ext.aria ? "id=\\"" + Ext.id() + "\\"" : ""]} style="width:{column.cellWidth}px;<tpl if="tdStyle">{tdStyle}</tpl>" tabindex="-1" {ariaCellAttr} data-columnid="{[values.column.getItemId()]}">',
            '<div {unselectableAttr} class="' + Ext.baseCSSPrefix + 'grid-cell-inner {innerCls}" style="text-align: {align}; {style};">{value}</div>',
            '<div class="x-grouptabs-corner x-grouptabs-corner-top-left"></div>',
            '<div class="x-grouptabs-corner x-grouptabs-corner-bottom-left"></div>',
        '</td>',
        {
            priority: 99999999
        }
    ),

    selectors: {
        // Outer table
        bodySelector: 'div.' + Ext.baseCSSPrefix + 'grid-table-resizer',

        // Element which contains rows
        nodeContainerSelector: 'div.' + Ext.baseCSSPrefix + 'grid-table-resizer',

        // row
        itemSelector: 'table.' + Ext.baseCSSPrefix + 'grouptab-item',

        // row which contains cells as opposed to wrapping rows
        rowSelector: 'tr.' + Ext.baseCSSPrefix + 'grouptab-row',

        // cell
        cellSelector: 'td.' + Ext.baseCSSPrefix + 'grouptab-cell', 

        getCellSelector: function(header) {
            return header ? header.getCellSelector() : this.cellSelector; 
        }

    },

    init: function(grid) {
        var view = grid.getView(), 
        	me = this;
        //view.addTpl(me.tableTpl);
        view.tpl = me.tableTpl;
        //view.addRowTpl(me.rowTpl);
        view.rowTpl = me.rowTpl;
        //view.addCellTpl(me.cellTpl);
        view.cellTpl = me.cellTpl;
        Ext.apply(view, me.selectors);
    }
});
