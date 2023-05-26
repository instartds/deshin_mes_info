//@charset UTF-8

/**
 *
 */
Ext.define('Unilite.com.grid.feature.UniSummary', {

    /* Begin Definitions */

    extend: 'Ext.grid.feature.AbstractSummary',
	suffix : '-grand-summary-record',
    alias: 'feature.uniSummary',
    summaryRowCls: Ext.baseCSSPrefix + 'grid-grand-row-summary',

    /**
     * @cfg {String} dock
     * Configure `'top'` or `'bottom'` top create a fixed summary row either above or below the scrollable table.
     *
     */
    dock: undefined,
	//dock: 'top', // 설정 후 합계표시 토글 시키면 row 가 사라짐
	
    dockedSummaryCls: Ext.baseCSSPrefix + 'docked-summary',

    panelBodyCls: Ext.baseCSSPrefix + 'summary-',

    init: function(grid) {
        var me = this,
            view = me.view;

        me.callParent(arguments);

        if (me.dock) {
            grid.headerCt.on({
                afterlayout: me.onStoreUpdate,
                scope: me
            });
            grid.on({
                beforerender: function() {
                    var tableCls = [me.summaryTableCls];
                    if (view.columnLines) {
                        tableCls[tableCls.length] = view.ownerCt.colLinesCls;
                    }
                    me.summaryBar = grid.addDocked({
                        childEls: ['innerCt'],
                        renderTpl: [
                            '<div id="{id}-innerCt">',
                                '<table cellPadding="0" cellSpacing="0" class="' + tableCls.join(' ') + '">',
                                    '<tr class="' + me.summaryRowCls + '"></tr>',
                                '</table>',
                            '</div>'
                        ],
                        style: 'overflow:hidden',
                        itemId: 'summaryBar',
                        cls: [ me.dockedSummaryCls, me.dockedSummaryCls + '-' + me.dock ],
                        xtype: 'component',
                        dock: me.dock,
                        weight: 10000000
                    })[0];
                },
                afterrender: function() {
                    grid.body.addCls(me.panelBodyCls + me.dock);
                    view.mon(view.el, {
                        scroll: me.onViewScroll,
                        scope: me
                    });
                    me.onStoreUpdate();
                },
                single: true
            });
// Dock 의 colum line 맞추기 위해 변경
//            // Stretch the innerCt of the summary bar upon headerCt layout
//            grid.headerCt.afterComponentLayout = Ext.Function.createSequence(grid.headerCt.afterComponentLayout, function() {
//                me.summaryBar.innerCt.setWidth(this.getFullWidth() + Ext.getScrollbarSize().width);
//            });
            grid.headerCt.afterComponentLayout = Ext.Function.createSequence(grid.headerCt.afterComponentLayout, function() {
                var width = this.getFullWidth(),
                    innerCt = me.summaryBar.innerCt,
                    scrollWidth;
                    
                if (view.hasVerticalScroll()) {
                    scrollWidth = Ext.getScrollbarSize().width;
                    width -= scrollWidth;
                    innerCt.down('table').setStyle(me.scrollPadProperty, scrollWidth + 'px');
                }
                innerCt.setWidth(width);
            });
        } else {
            me.view.addFooterFn(me.renderTFoot);
        }

        grid.on({
            columnmove: me.onStoreUpdate,
            scope: me
        });

        // On change of data, we have to update the docked summary.
        view.mon(view.store, {
            update: me.onStoreUpdate,
            datachanged: me.onStoreUpdate,
            scope: me
        });
    },

    renderTFoot: function(values, out) {
        var view = values.view,
            me = view.findFeature('uniSummary');

        if (me.showSummaryRow) {
            out.push('<tfoot>');
            me.outputSummaryRecord(me.createSummaryRecord(view), values, out);
            out.push('</tfoot>');
        }
    },
    
    vetoEvent: function(record, row, rowIndex, e) {
        return !e.getTarget(this.summaryRowSelector);
    },

    onViewScroll: function() {
        this.summaryBar.el.dom.scrollLeft = this.view.el.dom.scrollLeft;
    },

    createSummaryRecord: function(view) {
        var columns = view.headerCt.getVisibleGridColumns(),
            info = {
                records: view.store.getRange()
            },
            colCount = columns.length, i, column,
            summaryRecord = this.summaryRecord || (this.summaryRecord = new view.store.model(null, view.id + this.suffix));

        // Set the summary field values
        summaryRecord.beginEdit();
      //  var fields = summaryRecord.fields.getRange();
      //  fields.push(new Ext.data.Field({name: 'S_SUMMAR_TYPE', type: 'string', dataIndex:'S_SUMMAR_TYPE'}));
      // 	summaryRecord.set('S_SUMMAR_TYPE', 'GRAND');
       	//summaryRecord.setFields(fields,'1','1');
        
        for (i = 0; i < colCount; i++) {
            column = columns[i];

            // In summary records, if there's no dataIndex, then the value in regular rows must come from a renderer.
            // We set the data value in using the column ID.
            if (!column.dataIndex) {
                column.dataIndex = column.id;
            }

            summaryRecord.set(column.dataIndex, this.getSummary(view.store, column.summaryType, column.dataIndex, info));
        }
       // console.log("summaryRecord", summaryRecord);
        summaryRecord.endEdit(true);
        // It's not dirty
        summaryRecord.commit(true);
        summaryRecord.isSummary = true;

        return summaryRecord;
    },

    onStoreUpdate: function() {
        var me = this,
            view = me.view,
            record = me.createSummaryRecord(view),
            newRowDom = view.createRowElement(record, -1),
            oldRowDom, partner,
            p;

        if (!view.rendered) {
            return;
        }
        
        // Summary row is inside the docked summaryBar Component
        if (me.dock) {
            oldRowDom = me.summaryBar.el.down('.' + me.summaryRowCls, true);
        }
        // Summary row is a regular row in a THEAD inside the View.
        // Downlinked through the summary record's ID'
        else {
            oldRowDom = me.view.getNode(record);
        }
        
        if (oldRowDom) {
            p = oldRowDom.parentNode;
            p.insertBefore(newRowDom, oldRowDom);
            p.removeChild(oldRowDom);

            partner = me.lockingPartner;
            // For locking grids...
            // Update summary on other side (unless we have been called from the other side)
            if (partner && partner.grid.rendered && !me.calledFromLockingPartner) {
                partner.calledFromLockingPartner = true;
                partner.onStoreUpdate();
                partner.calledFromLockingPartner = false;
            }
        }
        // If docked, the updated row will need sizing because it's outside the View
        if (me.dock) {
            me.onColumnHeaderLayout();
        }
    },

    // Synchronize column widths in the docked summary Component
    onColumnHeaderLayout: function() {
        var view = this.view,
            columns = view.headerCt.getVisibleGridColumns(),
            column,
            len = columns.length, i,
            summaryEl = this.summaryBar.el,
            el;

        for (i = 0; i < len; i++) {
            column = columns[i];
            el = summaryEl.down(view.getCellSelector(column));
            if (el) {
                if (column.hidden) {
                    el.setDisplayed(false);
                } else {
                    el.setDisplayed(true);
                    el.setWidth(column.width || (column.lastBox ? column.lastBox.width : 100));
                }
            }
        }
    },
    // overide
    getSummary: function(store, type, field, group){
        var records = group.records;

        if (type) {
            if (Ext.isFunction(type)) {
                return store.getAggregate(type, null, records, [field]);
            }

            switch (type) {
                case 'count':
                    return records.length;
                case 'min':
                    return store.getMin(records, field);
                case 'max':
                    return store.getMax(records, field);
                case 'sum':
                    return store.getSum(records, field);
                case 'average':
                    return store.getAverage(records, field);
                 case 'nod':
                    return this._getNOD(records, field);
                default:
                    return '';

            }
        }
    },
    // _private  //  number of distinct values 
    _getNOD: function (records, dataIndex) {
    	var rv = "";
	  		var oldValue = null;
	  		for(i = 0, len = records.length; i < len; i ++) {
	  			var value = records[i].get(dataIndex) ;
	  			if(oldValue != null && value != oldValue) {
	  				rv = "";
	  				break;
	  			} else {
	  				oldValue = value;
	  				rv = value;
	  			}
	  		}
	  		return rv;
    }
});