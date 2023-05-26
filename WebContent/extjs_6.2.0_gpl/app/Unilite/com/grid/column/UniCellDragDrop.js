Ext.define('Unilite.com.grid.CellDragDrop', {
    extend: 'Ext.ux.CellDragDrop',
    alias: 'plugin.unicelldragdrop',

    /**
     * @cfg {Boolean} applyEmptyText
     * If `record`, then copy to drop record from drag record if 'cell' copy cell to drop cell from drag cell.
     *
     * Defaults to `record`.
     */
    copyType:'record', 
    
	constructor: function(config){
    	config = config || {};
        
        this.callParent([config]);
    },
    init: function (view) {
        var me = this;

        view.on('render', me.onViewRender, me, {
            single: true
        });
    },
	
    onViewRender: function (view) {
        var me = this,
            scrollEl;

        if (me.enableDrag) {
            if (me.containerScroll) {
                scrollEl = view.getEl();
            }

            me.dragZone = new Ext.view.DragZone({
                view: view,
                ddGroup: me.dragGroup || me.ddGroup,
                dragText: me.dragText,
                containerScroll: me.containerScroll,
                scrollEl: scrollEl,
                getDragData: function (e) {
                    var view = this.view,
                        item = e.getTarget(view.getItemSelector()),
                        record = view.getRecord(item),
                        clickedEl = e.getTarget(view.getCellSelector()),
                        dragEl;

                    if (item) {
                        dragEl = document.createElement('div');
                        dragEl.className = 'x-form-text';
                        dragEl.appendChild(document.createTextNode(clickedEl.textContent || clickedEl.innerText));

                        return {
                            event: new Ext.EventObjectImpl(e),
                            ddel: dragEl,
                            item: e.target,
                            columnName: view.getGridColumns()[clickedEl.cellIndex].dataIndex,
                            record: record,
                            view: view,
                            records : [record]
                        };
                    }
                },

                onInitDrag: function (x, y) {
                    var self = this,
                        data = self.dragData,
                        view = self.view,
                        selectionModel = view.getSelectionModel(),
                        record = data.record,
                        el = data.ddel;

                    // Update the selection to match what would have been selected if the user had
                    // done a full click on the target node rather than starting a drag from it.
                    if (!selectionModel.isSelected(record)) {
                        selectionModel.select(record, true);
                    }

                    self.ddel.update(el.textContent || el.innerText);
                    self.proxy.update(self.ddel.dom);
                    self.onStartDrag(x, y);
                    return true;
                }
            });
        }

        if (me.enableDrop) {
            me.dropZone = new Ext.dd.DropZone(view.el, {
                view: view,
                ddGroup: me.dropGroup || me.ddGroup,
                containerScroll: true,

                getTargetFromEvent: function (e) {
                    var self = this,
                        v = self.view,
                        cell = e.getTarget(v.cellSelector),
                        row, columnIndex;

                    // Ascertain whether the mousemove is within a grid cell.
                    if (cell) {
                        row = v.findItemByChild(cell);
                        columnIndex = cell.cellIndex;
                        
						var columns = self.view.getGridColumns();
						
                        if (row && Ext.isDefined(columnIndex)) {
                            return {
                                node: cell,
                                record: v.getRecord(row),
                                columnName: columns[columnIndex].dataIndex //self.view.up('grid').columns[columnIndex].dataIndex
                            };
                        }
                    }
                },

                // On Node enter, see if it is valid for us to drop the field on that type of column.
                onNodeEnter: function (target, dd, e, dragData) {
                    var self = this;
                        
                    //delete self.dropOK;

                    // Return if no target node or if over the same cell as the source of the drag.
                    if (!target ) {
                     	if (dragData.view.getXType() == 'gridview' && target.node === dragData.item.parentNode)  {
                        	return;
                     	}
                    }
					
                    if (me.enforceType && destType !== sourceType) {

                        self.dropOK = false;

                        if (me.noDropCls) {
                            Ext.fly(target.node).addCls(me.noDropCls);
                        } else {
                            Ext.fly(target.node).applyStyles({
                                backgroundColor: me.noDropBackgroundColor
                            });
                        }

                        return;
                    }
                    
                    if(!me.onDropEnter(target, dragData))	{
                    	self.dropOK = false;
                    	return;
                    }
                    
                    self.dropOK = true;

                    if (me.dropCls) {
                        Ext.fly(target.node).addCls(me.dropCls);
                    } else {
                        Ext.fly(target.node).applyStyles({
                            backgroundColor: me.dropBackgroundColor
                        });
                    }
                    
                },

                // Return the class name to add to the drag proxy. This provides a visual indication
                // of drop allowed or not allowed.
                onNodeOver: function (target, dd, e, dragData) {
                    return this.dropOK ? this.dropAllowed : this.dropNotAllowed;
                },

                // Highlight the target node.
                onNodeOut: function (target, dd, e, dragData) {
                    var cls = this.dropOK ? me.dropCls : me.noDropCls;

                    if (cls) {
                        Ext.fly(target.node).removeCls(cls);
                    } else {
                        Ext.fly(target.node).applyStyles({
                            backgroundColor: ''
                        });
                    }
                },

                // Process the drop event if we have previously ascertained that a drop is OK.
                onNodeDrop: function (target, dd, e, dragData) {
                    if (this.dropOK) {
                    	if(me.copyType == "record")	{
                    		/*var store = me.getCmp().getStore();
                    		if(store)	{
	                    		var tFields = store.getAt(store.indexOf(target.record)).getFields();
	                    		Ext.each(tFields, function(field, index)	{
	                    			if( !Ext.isEmpty(dragData.record.get(field.getName())) )	{
	                    				target.record.set(field.getName(), dragData.record.get(field.getName()) );
	                    			}
	                    		});
                    		}*/
                    		me.onRecordDrop(target, dragData);
                    		//target.record.set('name', dragData.record.name);
                    	}else {
                    		
	                        target.record.set(target.columnName, dragData.record.get(dragData.columnName));
	                        if (me.applyEmptyText) {
	                            dragData.record.set(dragData.columnName, me.emptyText);
	                        }
                    	}
                        return true;
                    }
                },

                onCellDrop: Ext.emptyFn
            });
        }
    },
    
    onRecordDrop: Ext.emptyFn,
    onDropEnter: function(target, dragData)	{
    	return true;
    }
});
