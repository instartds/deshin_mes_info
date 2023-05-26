//@charset UTF-8

/**
  * Store insert 오류 with locking grid
  * ExtJS version : 5.1.0
  */
  /* 6.0 변경됨. 확인 후 삭제  newNodes.childrenArray = > childern(result.children)
Ext.override(Ext.view.NodeCache, {
	scroll: function(newRecords, direction, removeCount) {
        var me = this,
            view = me.view,
            store = view.store,
            elements = me.elements,
            recCount = newRecords.length,
            i, el, removeEnd,
            newNodes,
            nodeContainer = view.getNodeContainer(),
            fireItemRemove = view.hasListeners.itemremove,
            fireItemAdd = view.hasListeners.itemadd,
            range = me.statics().range;

        // Scrolling up (content moved down - new content needed at top, remove from bottom)
        if (direction === -1) {
            if (removeCount) {
                if (range) {
                    range.setStartBefore(elements[(me.endIndex - removeCount) + 1]);
                    range.setEndAfter(elements[me.endIndex]);
                    range.deleteContents();
                    for (i = (me.endIndex - removeCount) + 1; i <= me.endIndex; i++) {
                        el = elements[i];
                        delete elements[i];
                        if (fireItemRemove) {
                            view.fireEvent('itemremove', store.getByInternalId(el.getAttribute('data-recordId')), i, el, view);
                        }
                    }
                } else {
                    for (i = (me.endIndex - removeCount) + 1; i <= me.endIndex; i++) {
                        el = elements[i];
                        delete elements[i];
                        el.parentNode.removeChild(el);
                        if (fireItemRemove) {
                            view.fireEvent('itemremove', store.getByInternalId(el.getAttribute('data-recordId')), i, el, view);
                        }
                    }
                }
                me.endIndex -= removeCount;
            }

            // Only do rendering if there are rows to render.
            // This could have been a remove only operation due to a view resize event.
            if (newRecords.length) {

                // grab all nodes rendered, not just the data rows
                newNodes = view.bufferRender(newRecords, me.startIndex -= recCount);
                for (i = 0; i < recCount; i++) {
                    elements[me.startIndex + i] = newNodes.childrenArray[i];
                }
                nodeContainer.insertBefore(newNodes, nodeContainer.firstChild);

                // pass the new DOM to any interested parties
                if (fireItemAdd) {
                    view.fireEvent('itemadd', newRecords, me.startIndex, newNodes.childrenArray);
                }
            }
        }

        // Scrolling down (content moved up - new content needed at bottom, remove from top)
        else {
            if (removeCount) {
                removeEnd = me.startIndex + removeCount;
                if (range) {
                    range.setStartBefore(elements[me.startIndex]);
                    range.setEndAfter(elements[removeEnd - 1]);
                    range.deleteContents();
                    for (i = me.startIndex; i < removeEnd; i++) {
                        el = elements[i];
                        delete elements[i];
                        if (fireItemRemove) {
                            view.fireEvent('itemremove', store.getByInternalId(el.getAttribute('data-recordId')), i, el, view);
                        }
                    }
                } else {
                    for (i = me.startIndex; i < removeEnd; i++) {
                        el = elements[i];
                        delete elements[i];
                        el.parentNode.removeChild(el);
                        if (fireItemRemove) {
                            view.fireEvent('itemremove', store.getByInternalId(el.getAttribute('data-recordId')), i, el, view);
                        }
                    }
                }
                me.startIndex = removeEnd;
            }

            // grab all nodes rendered, not just the data rows
            newNodes = view.bufferRender(newRecords, me.endIndex + 1);
            for (i = 0; i < recCount; i++) {
                elements[me.endIndex += 1] = newNodes.childrenArray[i];
            }
            nodeContainer.appendChild(newNodes);

            // pass the new DOM to any interested parties
            if (fireItemAdd) {
                view.fireEvent('itemadd', newRecords, me.endIndex + 1, newNodes.childrenArray);
            }
        }
        // Keep count consistent.
        me.count = me.endIndex - me.startIndex + 1;
        
        //bug: lockging grid 에서 store 에 insert 할 때 오류남(newNodes 가 undefined).
        //return newNodes.childrenArray;
        return (Ext.isEmpty(newNodes) ? [] : newNodes.childrenArray);
    }
});
*/

/**
  * tree panel 에서 조회 후 node 선택 조작-> 다시 조회 -> 선택 조작 시 오류 발생 (예: 부서정보 등록)
  * ExtJS version : 5.1.0
  */
Ext.override(Ext.selection.CellModel, {
	onSelectChange: function(record, isSelected, suppressEvent, commitFn) {
        var me = this,
            pos, eventName, view, nm;
        if (isSelected) {
            pos = me.nextSelection;
            eventName = 'select';
        } else {
            pos = me.selection;
            eventName = 'deselect';
        }
        
        if(pos) {	// pos null 체크
        
	        view = pos.view || me.primaryView;
	        if ((suppressEvent || me.fireEvent('before' + eventName, me, record, pos.rowIdx, pos.colIdx)) !== false && commitFn() !== false) {
	            if (isSelected) {
	                view.onCellSelect(pos);
	            } else {
	                view.onCellDeselect(pos);
	                delete me.selection;
	            }
	            if (!suppressEvent) {
	                me.fireEvent(eventName, me, record, pos.rowIdx, pos.colIdx);
	            }
	        }
        }
    }
});

Ext.override(Ext.form.field.Base, {
	
	/**
	 * validateOnChange 설정과 상관없이 change 이벤트 시 매번 getErrors() 내에서 validator 를 호출하게 되는 문제.
	 * 각 필드의 onChange(), onBlur() 에서 validateOnChange, validateOnBlur 설정값에 따라 validate 를 호출하고 있기에
	 * 이곳에서는 제거함.
	 */
	publishValue: function() {
        var me = this;
        //if (me.rendered && !me.getErrors().length) {
        if (me.rendered) {
            me.publishState('value', me.getValue());
        }
    }	
});

Ext.override(Ext.form.field.Field, {
	
	/**
	 * validateOnChange 설정과 상관없이 change 이벤트 시 매번 getErrors() 내에서 validator 를 호출하게 되는 문제.
	 * 각 필드의 onChange(), onBlur() 에서 validateOnChange, validateOnBlur 설정값에 따라 validate 를 호출하고 있기에
	 * 이곳에서는 제거함.
	 */
	publishValue: function() {
        var me = this;
        //if (me.rendered && !me.getErrors().length) {
        if (me.rendered) {
            me.publishState('value', me.getValue());
        }
    }
});

Ext.override(Ext.form.field.ComboBox, {
	
	/**
	 * IE11의 경우 setValue() 시에 리스트가 expand 되어져 버림. 
	 * setValue -> setRawValue 에서 propertychange 가 발생 -> onFieldMutation 를 실행 -> doQueryTask -> expand.
	 * 
	 * http://www.sencha.com/forum/showthread.php?296114-ComboBox.setValue-in-IE11-expands-picker!&p=1081279
	 * http://www.sencha.com/forum/showthread.php?296103-ComboBox-in-IE-10-11-be-focus
	 * @type 
	 */
	checkChangeEvents: Ext.isIE //&& (!document.documentMode || document.documentMode < 9) 
						?
                        ['change', 'propertychange', 'keyup'] :
                        ['change', 'input', 'textInput', 'keyup', 'dragdrop']

});

//if(!Ext.isIE)	{
//	Ext.override(Ext.grid.CellEditor, {
//		focusLeaveAction: 'completeEdit',
//	    setGrid: function(grid) {
//	        this.grid = grid;
//	    },
//	    completeEdit: function(remainVisible) {
//	        var me = this,
//	            context = me.context;
//	        if (me.editing) {
//	            context.value = me.field.value;
//	            if (me.editingPlugin.validateEdit(context) === false) {
//	                if (context.cancel) {
//	                    context.value = me.originalValue;
//	                    me.editingPlugin.cancelEdit();
//	                }
//	                return !!context.cancel;
//	            }
//	        }
//	        me.callParent([
//	            remainVisible
//	        ]);
//	    },
//	    onEditComplete: function(remainVisible, canceling) {
//	        var me = this,
//	            activeElement = Ext.Element.getActiveElement(),
//	            boundEl;
//	        me.editing = false;
//	        // Must refresh the boundEl in case DOM has been churned during edit.
//	        boundEl = me.boundEl = me.context.getCell();
//	        // We have to test if boundEl is still present because it could have been
//	        // de-rendered by a bufferedRenderer scroll.
//	        if (boundEl) {
//	            me.restoreCell();
//	            // IF we are just terminating, and NOT being terminated due to focus
//	            // having moved out of this editor, then we must prevent any upcoming blur
//	            // from letting focus fly out of the view.
//	            // onFocusLeave will have no effect because the editing flag is cleared.
//	            if (boundEl.contains(activeElement) && boundEl.dom !== activeElement) {
//	                boundEl.focus();
//	            }
//	        }
//	        me.callParent(arguments);
//	        // Do not rely on events to sync state with editing plugin,
//	        // Inform it directly.
//	        if (canceling) {
//	            me.editingPlugin.cancelEdit(me);
//	        } else {
//	            me.editingPlugin.onEditComplete(me, me.getValue(), me.startValue);
//	        }
//	    }
//	})
//}

if(!Ext.isIE)	{
	Ext.override(Ext.grid.CellEditor, {
	    extend: 'Ext.Editor',
	    /**
	     * @property {Boolean} isCellEditor
	     * @readonly
	     * `true` in this class to identify an object as an instantiated CellEditor, or subclass thereof.
	     */
	    isCellEditor: true,
	    alignment: 'l-l!',
	    hideEl: false,
	    cls: Ext.baseCSSPrefix + 'small-editor ' + Ext.baseCSSPrefix + 'grid-editor ' + Ext.baseCSSPrefix + 'grid-cell-editor',
	    treeNodeSelector: '.' + Ext.baseCSSPrefix + 'tree-node-text',
	    shim: false,
	    shadow: false,
	    floating: true,
	    alignOnScroll: false,
	    useBoundValue: false,
	    focusLeaveAction: 'completeEdit',
	    // Set the grid that owns this editor.
	    // Called by CellEditing#getEditor
	    setGrid: function(grid) {
	        this.grid = grid;
	    }
	    ,
	    startEdit: function(boundEl, value, doFocus) {
	        this.context = this.editingPlugin.context;
	        this.callParent([
	            boundEl,
	            value,
	            doFocus
	        ]);
	    },
	    /**
	     * @private
	     * Shows the editor, end ensures that it is rendered into the correct view
	     * Hides the grid cell inner element when a cell editor is shown.
	     */
	    onShow: function() {
	        var me = this,
	            innerCell = me.boundEl.down(me.context.view.innerSelector);
	        if (innerCell) {
	            if (me.isForTree) {
	                innerCell = innerCell.child(me.treeNodeSelector);
	            }
	            innerCell.hide();
	        }
	        me.callParent(arguments);
	    },
	    onFocusEnter: function() {
	        var me = this,
	            context = me.context,
	            view = context.view;
	        // Focus restoration after a refresh may require realignment and correction
	        // of the context because it could have been due to a or filter operation and
	        // the context may have changed position.
	        context.node = view.getNode(context.record);
	        context.row = view.getRow(context.record);
	        context.cell = context.getCell(true);
	        context.rowIdx = view.indexOf(context.row);
	        me.realign(true);
	        me.callParent(arguments);
	        // Ensure that hide processing does not throw focus back to the previously focused element.
	        me.focusEnterEvent = null;
	    },
//	    onFocusLeave: function(e) {
//	        var me = this,
//	            view = me.context.view,
//	            related = Ext.fly(e.relatedTarget);
//	        // Quit editing in whichever way.
//	        // The default is completeEdit.
//	        // If we received an ESC, this will be cancelEdit.
//	        if (me[me.focusLeaveAction]() === false) {
//	            e.event.stopEvent();
//	            return;
//	        }
//	        delete me.focusLeaveAction;
//	        // If the related target is not a cell, turn actionable mode off
//	        if (!view.destroyed && view.el.contains(related) && (!related.isAncestor(e.target) || related === view.el) && !related.up(view.getCellSelector(), view.el)) {
//	            me.context.grid.setActionableMode(false, view.actionPosition);
//	        }
//	        me.cacheElement();
//	        // Bypass Editor's onFocusLeave
//	        Ext.container.Container.prototype.onFocusLeave.apply(me, arguments);
//	    },
	    completeEdit: function(remainVisible) {
	        var me = this,
	            context = me.context;
	        if (me.editing) {
	            context.value = me.field.value;
	            if (me.editingPlugin.validateEdit(context) === false) {
	                if (context.cancel) {
	                    context.value = me.originalValue;
	                    me.editingPlugin.cancelEdit();
	                }
	                return !!context.cancel;
	            }
	        }
	        me.callParent([
	            remainVisible
	        ]);
	    },
	    onEditComplete: function(remainVisible, canceling) {
	        var me = this,
	            activeElement = Ext.Element.getActiveElement(),
	            boundEl;
	        me.editing = false;
	        // Must refresh the boundEl in case DOM has been churned during edit.
	        boundEl = me.boundEl = me.context.getCell();
	        // We have to test if boundEl is still present because it could have been
	        // de-rendered by a bufferedRenderer scroll.
	        if (boundEl) {
	            me.restoreCell();
	            // IF we are just terminating, and NOT being terminated due to focus
	            // having moved out of this editor, then we must prevent any upcoming blur
	            // from letting focus fly out of the view.
	            // onFocusLeave will have no effect because the editing flag is cleared.
	            if (boundEl.contains(activeElement) && boundEl.dom !== activeElement) {
	                boundEl.focus();
	            }
	        }
	        me.callParent(arguments);
	        // Do not rely on events to sync state with editing plugin,
	        // Inform it directly.
	        if (canceling) {
	            me.editingPlugin.cancelEdit(me);
	        } else {
	            me.editingPlugin.onEditComplete(me, me.getValue(), me.startValue);
	        }
	    },
	    cacheElement: function() {
	        if (!this.editing && !this.destroyed) {
	            Ext.getDetachedBody().dom.appendChild(this.el.dom);
	        }
	    },
	    /**
	     * @private
	     * We should do nothing.
	     * Hiding blurs, and blur will terminate the edit.
	     * Must not allow superclass Editor to terminate the edit.
	     */
	    onHide: function() {
	        Ext.Editor.superclass.onHide.apply(this, arguments);
	    },
	    onSpecialKey: function(field, event, eOpts) {
	        var me = this,
	            key = event.getKey(),
	            complete = me.completeOnEnter && key === event.ENTER && (!eOpts || !eOpts.fromBoundList),
	            cancel = me.cancelOnEsc && key === event.ESC,
	            view = me.editingPlugin.view;
	        if (complete || cancel) {
	            // Do not let the key event bubble into the NavigationModel after we're don processing it.
	            // We control the navigation action here; we focus the cell.
	            event.stopEvent();
	            // Maintain visibility so that focus doesn't leak.
	            // We need to direct focusback to the owning cell.
	            if (cancel) {
	                me.focusLeaveAction = 'cancelEdit';
	            }
	            view.getNavigationModel().setPosition(me.context, null, event);
	            view.ownerGrid.setActionableMode(false);
	        }
	    },
	    getRefOwner: function() {
	        return this.column && this.column.getView();
	    },
	    restoreCell: function() {
	        var me = this,
	            innerCell = me.boundEl.down(me.context.view.innerSelector);
	        if (innerCell) {
	            if (me.isForTree) {
	                innerCell = innerCell.child(me.treeNodeSelector);
	            }
	            innerCell.show();
	        }
	    },
	    /**
	     * @private
	     * Fix checkbox blur when it is clicked.
	     */
	    afterRender: function() {
	        var me = this,
	            field = me.field;
	        me.callParent(arguments);
	        if (field.isCheckbox) {
	            field.mon(field.inputEl, {
	                mousedown: me.onCheckBoxMouseDown,
	                click: me.onCheckBoxClick,
	                scope: me
	            });
	        }
	    },
	    /**
	     * @private
	     * Because when checkbox is clicked it loses focus  completeEdit is bypassed.
	     */
	    onCheckBoxMouseDown: function() {
	        this.completeEdit = Ext.emptyFn;
	    },
	    /**
	     * @private
	     * Restore checkbox focus and completeEdit method.
	     */
	    onCheckBoxClick: function() {
	        delete this.completeEdit;
	        this.field.focus(false, 10);
	    },
	    /**
	     * @private
	     * Realigns the Editor to the grid cell, or to the text node in the grid inner cell
	     * if the inner cell contains multiple child nodes.
	     */
	    realign: function(autoSize) {
	        var me = this,
	            boundEl = me.boundEl,
	            innerCell = boundEl.down(me.context.view.innerSelector),
	            innerCellTextNode = innerCell.dom.firstChild,
	            width = boundEl.getWidth(),
	            offsets = Ext.Array.clone(me.offsets),
	            grid = me.grid,
	            xOffset,
	            v = '',
	            // innerCell is empty if there are no children, or there is one text node, and it contains whitespace
	            isEmpty = !innerCellTextNode || (innerCellTextNode.nodeType === 3 && !(Ext.String.trim(v = innerCellTextNode.data).length));
	        if (me.isForTree) {
	            // When editing a tree, adjust the width and offsets of the editor to line
	            // up with the tree cell's text element
	            xOffset = me.getTreeNodeOffset(innerCell);
	            width -= Math.abs(xOffset);
	            offsets[0] += xOffset;
	        }
	        if (grid.columnLines) {
	            // Subtract the column border width so that the editor displays inside the
	            // borders. The column border could be either on the left or the right depending
	            // on whether the grid is RTL - using the sum of both borders works in both modes.
	            width -= boundEl.getBorderWidth('rl');
	        }
	        if (autoSize === true) {
	            me.field.setWidth(width);
	        }
	        // https://sencha.jira.com/browse/EXTJSIV-10871 Ensure the data bearing element has a height from text.
	        if (isEmpty) {
	            innerCell.dom.innerHTML = 'X';
	        }
	        me.alignTo(boundEl, me.alignment, offsets);
	        if (isEmpty) {
	            innerCell.dom.firstChild.data = v;
	        }
	    },
	    getTreeNodeOffset: function(innerCell) {
	        return innerCell.child(this.treeNodeSelector).getOffsetsTo(innerCell)[0];
	    }
	});
}


Ext.override(Ext.grid.plugin.CellEditing, {
	
//	/**
//	 * appendChild 에서 detachedBody.dom을 못 찾는 에러
//	 * detachedBody.dom 존재 여부 확인
//	 * EXTJS-20323 bug 
//	 * 
//	 
	cacheDeactivatedEditors: function() {
        var me = this,
            editors = me.editors.items,
            len = editors.length,
            i, editor,
            detachedBody = Ext.getDetachedBody();
        for (i = 0; i < len; i++) {
            editor = editors[i];
            if (detachedBody  && detachedBody.dom && editor && !editor.isVisible()) {
            	if(editor.el && editor.el.dom){
                	if(Ext.isFunction(detachedBody.dom.appendChild))	{
                		detachedBody.dom.appendChild(editor.el.dom);
                		editor.container = detachedBody;
                	}
            	}
            }
        }
    }
//    ,
//    getEditor: function(record, column) {
//        var me = this,
//            editors = me.editors,
//            editorId = column.getItemId(),
//            editor = editors.getByKey(editorId);
////        if(editor && editor.el && !editor.el.dom)	{
////        	editor= null;
////        }
//        if (!editor) {
//            editor = column.getEditor(record);
//            if (!editor) {
//                return false;
//            }
//            // Allow them to specify a CellEditor in the Column
//            if (editor instanceof Ext.grid.CellEditor && editor.el && editor.el.dom) {
//                editor.floating = true;
//            } else // But if it's just a Field, wrap it.
//            {
//                editor = new Ext.grid.CellEditor({
//                    floating: true,
//                    editorId: editorId,
//                    field: editor
//                });
//            }
//            // Add the Editor as a floating child of the grid
//            // Prevent this field from being included in an Ext.form.Basic
//            // collection, if the grid happens to be used inside a form
//            editor.field.excludeForm = true;
//            // If the editor is new to this grid, then add it to the grid, and ensure it tells us about its life cycle.
//            if (editor.column !== column) {
//                editor.column = column;
//                editor.on({
//                    scope: me,
//                    complete: me.onEditComplete,
//                    canceledit: me.cancelEdit
//                });
//                column.on('removed', me.onColumnRemoved, me);
//            }
//            editors.add(editor);
//        }
//        // Inject an upward link to its owning grid even though it is not an added child.
//        editor.ownerCmp = me.grid.ownerGrid;
//        if (column.isTreeColumn) {
//            editor.isForTree = column.isTreeColumn;
//            editor.addCls(Ext.baseCSSPrefix + 'tree-cell-editor');
//        }
//        // Set the owning grid.
//        // This needs to be kept up to date because in a Lockable assembly, an editor
//        // needs to swap sides if the column is moved across.
//        editor.setGrid(me.grid);
//        // Keep upward pointer correct for each use - editors are shared between locking sides
//        editor.editingPlugin = me;
//        return editor;
//    }
//
});

Ext.define('Ext.overrides.grid.plugin.BufferedRenderer', {
    override: 'Ext.grid.plugin.BufferedRenderer',

    onRangeFetched: function(range, start, end, options, fromLockingPartner) {
        var me = this,
            view = me.view,
            viewEl = view.el,
            oldStart,
            rows = view.all,
            removeCount,
            increment = 0,
            calculatedTop, newTop,
            lockingPartner = (view.lockingPartner && !fromLockingPartner && !me.doNotMirror) && view.lockingPartner.bufferedRenderer,
            newRows, partnerNewRows, topAdditionSize, topBufferZone, i,
            variableRowHeight = me.variableRowHeight,
            activeEl, containsFocus, pos, newFocus;

        // View may have been destroyed since the DelayedTask was kicked off.
        if (view.destroyed) {
            return;
        }
        // If called as a callback from the Store, the range will be passed, if called from renderRange, it won't
        if (range) {
            // Re-cache the scrollTop if there has been an asynchronous call to the server.
            me.scrollTop = me.view.getScrollY();
        } else {
            range = me.store.getRange(start, end);
            // Store may have been cleared since the DelayedTask was kicked off.
            if (!range) {
                return;
            }
        }
        // If we contain focus now, but do not when we have rendered the new rows, we must focus the view el.
        activeEl = Ext.Element.getActiveElement();
        containsFocus = viewEl.contains(activeEl);
        // Best guess rendered block position is start row index * row height.
        calculatedTop = start * me.rowHeight;
        // The new range encompasses the current range. Refresh and keep the scroll position stable
        if (start < rows.startIndex && end > rows.endIndex) {
            // How many rows will be added at top. So that we can reposition the table to maintain scroll position
            topAdditionSize = rows.startIndex - start;
            // MUST use View method so that itemremove events are fired so widgets can be recycled.
            view.clearViewEl(true);
            newRows = view.doAdd(range, start);
            view.fireEvent('itemadd', range, start, newRows);
            for (i = 0; i < topAdditionSize; i++) {
                increment -= newRows[i].offsetHeight;
            }
            // We've just added a bunch of rows to the top of our range, so move upwards to keep the row appearance stable
            newTop = me.bodyTop + increment;
        } else {
            // No overlapping nodes, we'll need to render the whole range
            // teleported flag is set in getFirstVisibleRowIndex/getLastVisibleRowIndex if
            // the table body has moved outside the viewport bounds
            if (me.teleported || start > rows.endIndex || end < rows.startIndex) {
                newTop = calculatedTop;
                // If we teleport with variable row height, the best thing is to try to render the block
                // <bufferzone> pixels above the scrollTop so that the rendered block encompasses the
                // viewport. Only do that if the start is more than <bufferzone> down the dataset.
                if (variableRowHeight) {
                    topBufferZone = me.scrollTop < me.position ? me.leadingBufferZone : me.trailingBufferZone;
                    if (start > topBufferZone) {
                        newTop = me.scrollTop - me.rowHeight * topBufferZone;
                    }
                }
                // MUST use View method so that itemremove events are fired so widgets can be recycled.
                view.clearViewEl(true);
                me.teleported = false;
            }
            if (!rows.getCount()) {
                newRows = view.doAdd(range, start);
                view.fireEvent('itemadd', range, start, newRows);
            }
            // Moved down the dataset (content moved up): remove rows from top, add to end
            else if (end > rows.endIndex) {
                removeCount = Math.max(start - rows.startIndex, 0);
                // We only have to bump the table down by the height of removed rows if rows are not a standard size
                if (variableRowHeight) {
                    increment = rows.item(rows.startIndex + removeCount, true).offsetTop;
                }
                newRows = rows.scroll(Ext.Array.slice(range, rows.endIndex + 1 - start), 1, removeCount);
                // We only have to bump the table down by the height of removed rows if rows are not a standard size
                if (variableRowHeight) {
                    // Bump the table downwards by the height scraped off the top
                    newTop = me.bodyTop + increment;
                } else {
                    newTop = calculatedTop;
                }
            } else // Moved up the dataset: remove rows from end, add to top
            {
                removeCount = Math.max(rows.endIndex - end, 0);
                oldStart = rows.startIndex;
                newRows = rows.scroll(Ext.Array.slice(range, 0, rows.startIndex - start), -1, removeCount);
                // We only have to bump the table up by the height of top-added rows if rows are not a standard size
                if (variableRowHeight) {
                    // Bump the table upwards by the height added to the top
                    newTop = me.bodyTop - rows.item(oldStart, true).offsetTop;
                    // We've arrived at row zero...
                    if (!rows.startIndex) {
                        // But the calculated top position is out. It must be zero at this point
                        // We adjust the scroll position to keep visual position of table the same.
                        if (newTop) {
                            view.setScrollY(me.position = (me.scrollTop -= newTop));
                            newTop = 0;
                        }
                    }
                    // Not at zero yet, but the position has moved into negative range
                    else if (newTop < 0) {
                        increment = rows.startIndex * me.rowHeight;
                        view.setScrollY(me.position = (me.scrollTop += increment));
                        newTop = me.bodyTop + increment;
                    }
                } else {
                    newTop = calculatedTop;
                }
            }
            // The position property is the scrollTop value *at which the table was last correct*
            // MUST be set at table render/adjustment time
            me.position = me.scrollTop;
        }
        // We contained focus at the start, but that activeEl has been derendered.
        // Focus the cell's column header.
        if (containsFocus && !viewEl.contains(activeEl)) {
            pos = view.actionableMode ? view.actionPosition : view.lastFocused;
            if (pos && pos.column) {
                view.onFocusLeave({});

                //////////////////////////////////////////////
                //
                // The Fix/
                // ========
                // Try to focus the contextual column header.
                // Failing that, look inside it for a tabbable element.
                // Failing that, focus the view.
                // Focus MUST NOT just silently die due to DOM removal
                if (pos.column.focusable) {
	                newFocus = pos.column;
                } else {
                    newFocus = pos.column.el.findTabbableElements()[0];
                }
                if (!newFocus) {
                    newFocus = view.el;
                }
                newFocus.focus();
            }
        }
        // Position the item container.
        newTop = Math.max(Math.floor(newTop), 0);
        if (view.positionBody) {
            me.setBodyTop(newTop);
        }
        // Sync the other side to exactly the same range from the dataset.
        // Then ensure that we are still at exactly the same scroll position.
        if (newRows && lockingPartner && !lockingPartner.disabled) {
            // Set the pointers of the partner so that its onRangeFetched believes it is at the correct position.
            lockingPartner.scrollTop = lockingPartner.position = me.scrollTop;
            if (lockingPartner.view.ownerCt.isVisible()) {
                partnerNewRows = lockingPartner.onRangeFetched(null, start, end, options, true);
                // Sync the row heights if configured to do so, or if one side has variableRowHeight but the other doesn't.
                // variableRowHeight is just a flag for the buffered rendering to know how to measure row height and
                // calculate firstVisibleRow and lastVisibleRow. It does not *necessarily* mean that row heights are going
                // to be asymmetric between sides. For example grouping causes variableRowHeight. But the row heights
                // each side will be symmetric.
                // But if one side has variableRowHeight (eg, a cellWrap: true column), and the other does not, that
                // means there could be asymmetric row heights.
                if (view.ownerGrid.syncRowHeight || (lockingPartner.variableRowHeight !== variableRowHeight)) {
                    me.syncRowHeights(newRows, partnerNewRows);
                    // body height might have changed with change of rows, and possible syncRowHeights call.
                    me.bodyHeight = view.body.dom.offsetHeight;
                }
            }
            if (lockingPartner.bodyTop !== newTop) {
                lockingPartner.setBodyTop(newTop);
            }
            // Set the real scrollY position after the correct data has been rendered there.
            // It will not handle a scroll because the scrollTop and position have been preset.
            lockingPartner.view.setScrollY(me.scrollTop);
        }
        return newRows;
    }
});