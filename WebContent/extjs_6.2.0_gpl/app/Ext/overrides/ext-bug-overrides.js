//@charset UTF-8

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

Ext.override(Ext.grid.CellContext, {
	setRow: function(row) {
        var me = this,
            dataSource = me.view.dataSource,
            oldRecord = me.record,
            count;
        if (row!=null && row !== undefined) {
            // Row index passed, < 0 meaning count from the tail (-1 is the last, etc)
            if (typeof row === 'number') {
                count = dataSource.getCount();
                row = row < 0 ? Math.max(count + row, 0) : Math.max(Math.min(row, count - 1), 0);
                me.rowIdx = row;
                me.record = dataSource.getAt(row);
            }
            // row is a Record
            else if (row.isModel) {
                me.record = row;
                me.rowIdx = dataSource.indexOf(row);
            }
            // row is a grid row, or Element wrapping row
            else if (row.tagName || row.isElement) {
                me.record = me.view.getRecord(row);
                me.rowIdx = dataSource.indexOf(me.record);
            }
        }
        if (me.record !== oldRecord) {
            me.generation++;
        }
        return me;
    }
});

Ext.define('Ext.overrides.grid.CellEditor', {
    override: 'Ext.grid.CellEditor',
	alias :'widget.celleditor',
	
	onFocusEnter: function() {
        var me = this,
            context = me.context,
            view = context.view;

        // Focus restoration after a refresh may require realignment and correction
        // of the context because it could have been due to a or filter operation and
        // the context may have changed position.
        me.reattachToBody();
        context.node = view.getNode(context.record);
        context.row = view.getRow(context.record);
        context.cell = context.getCell(true);
        context.rowIdx = view.indexOf(context.row);
        me.realign(true);

        me.callParent(arguments);

        // Ensure that hide processing does not throw focus back to the previously focused element.
        me.focusEnterEvent = null;
    },
    onEditComplete: function(remainVisible, canceling) {
        var me = this,
            activeElement = Ext.Element.getActiveElement(),
            ctx = me.context, 
            store = ctx && ctx.store,
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
            // When expanding/collapsing a node, the editor will lose focus
            // and cancel the editing, but at the same time the expand/collapse
            // will call actionable#suspend that will cause this editor to remain visible
            // and will prevent the element from being cached. So if remainVisible is true
            // and we are expanding/collapsing we should always cache the element.
            if (remainVisible && store && store.isExpandingOrCollapsing) {
                me.cacheElement();
            }
        } else {
            me.editingPlugin.onEditComplete(me, me.getValue(), me.startValue);
        }
    },

    cacheElement: function(force) {
        if ((!this.editing || force) && !this.destroyed) {
            this.detachFromBody();
        }
    },
    onHide: function() {
        this.cacheElement(true);
        Ext.Editor.superclass.onHide.apply(this, arguments);
    }

});

Ext.override(Ext.grid.plugin.CellEditing, {
	getEditor: function(record, column) {
        return this.getCachedEditor(column.getItemId(), record, column);
    },
    
    getCachedEditor: function (editorId, record, column) {
        var me = this,
            editors = me.editors,
            editor = editors.getByKey(editorId);
        
        if (!editor) {
            editor = column.getEditor(record);
            if (!editor) {
                return false;
            }
            
            // Allow them to specify a CellEditor in the Column
            if (!(editor instanceof Ext.grid.CellEditor)) {
                // Apply the field's editorCfg to the CellEditor config.
                // See Editor#createColumnField. A Column's editor config may
                // be used to specify the CellEditor config if it contains a field property.
                editor = Ext.widget(Ext.apply({
                    xtype: 'celleditor',
                    floating: true,
                    editorId: editorId,
                    field: editor
                }, editor.editorCfg));
            }
            
            // Add the Editor as a floating child of the grid
            // Prevent this field from being included in an Ext.form.Basic
            // collection, if the grid happens to be used inside a form
            editor.field.excludeForm = true;
            
            // If the editor is new to this grid, then add it to the grid, and ensure it tells us about its life cycle.
            if (editor.column !== column) {
                editor.column = column;
                column.on('removed', me.onColumnRemoved, me);
            }
            editors.add(editor);
        }
        
        // Inject an upward link to its owning grid even though it is not an added child.
        editor.ownerCmp = me.grid.ownerGrid;
        
        if (column.isTreeColumn) {
            editor.isForTree = column.isTreeColumn;
            editor.addCls(Ext.baseCSSPrefix + 'tree-cell-editor');
        }
        
        // Set the owning grid.
        // This needs to be kept up to date because in a Lockable assembly, an editor
        // needs to swap sides if the column is moved across.
        editor.setGrid(me.grid);
        
        // Keep upward pointer correct for each use - editors are shared between locking sides
        editor.editingPlugin = me;
        return editor;
    }
});
Ext.override(Ext.event.publisher.Dom, {
	unsubscribe: function(element, eventName, delegated, capture) {
        var me = this,
            captureSubscribers, bubbleSubscribers, subscribers, id;
        if (delegated && !me.directEvents[eventName]) {
            captureSubscribers = me.captureSubscribers;
            bubbleSubscribers = me.bubbleSubscribers;
            subscribers = capture ? captureSubscribers : bubbleSubscribers;
            if (subscribers && subscribers[eventName]) {
                --subscribers[eventName];
            }
            //me.type == 'gesture' ?
            if(me.handles && bubbleSubscribers && captureSubscribers) {
	            if (!me.handles[eventName] && !bubbleSubscribers[eventName] && !captureSubscribers[eventName]) {
	                // decremented subscribers back to 0 - and the event is not in "handledEvents"
	                // no longer need to listen at the dom level
	                this.removeDelegatedListener(eventName);
	            }
            }
        } else {
            subscribers = capture ? me.directCaptureSubscribers : me.directSubscribers;
            id = element.id;
            subscribers = subscribers[eventName];
            if (subscribers[id]) {
                --subscribers[id];
            }
            if (!subscribers[id]) {
                // no more direct subscribers for this element/id/capture, so we can safely
                // remove the dom listener
                delete subscribers[id];
                me.removeDirectListener(eventName, element, capture);
            }
        }
    }
});

Ext.define('Unilite.com.grid.CellEditor',{
	extend : 'Ext.grid.CellEditor',
	alias : 'widget.celleditor',
	constructor: function(config) {
        var me = this;
        config = config || {};
        me.callParent([config]);
    }
});

//radio group 은 simpleValue 추가로 인해 기존의 field.getValue().name 값을 가져 올 수 없으므로 수정
Ext.override(Ext.form.RadioGroup, {
	getValue: function() {
        var me = this,
            items = me.items.items,
            i, item, ret;
        if (me.simpleValue) {
            for (i = items.length; i-- > 0; ) {
                item = items[i];
                if (item.checked) {
                    ret = item.inputValue;
                    break;
                }
            }
        } else {
            //ret = me.callParent();
	        	
	        var values = {},
	            boxes  = this.getBoxes(),
	            b,
	            bLen   = boxes.length,
	            box, name, inputValue, bucket;
	
	        for (b = 0; b < bLen; b++) {
	            box        = boxes[b];
	            name       = box.getName();
	            inputValue = box.inputValue;
	
	            if (box.checked) {
	               values[name] = inputValue;
	            }
	        }
	
	        ret = values;
        }
        return ret;
    },
    setValue: function(value) {
        var items = this.items,
            cbValue, cmp, formId, radios, i, len, name;
        Ext.suspendLayouts();
        if (this.simpleValue) {
            for (i = 0 , len = items.length; i < len; ++i) {
                cmp = items.items[i];
                if (cmp.inputValue === value) {
                    cmp.setValue(true);
                    break;
                }
            }
        } else if (Ext.isObject(value)) {
            cmp = items.first();
            formId = cmp ? cmp.getFormId() : null;
            for (name in value) {
                cbValue = value[name];
                radios = Ext.form.RadioManager.getWithValue(name, cbValue, formId).items;
                len = radios.length;
                for (i = 0; i < len; ++i) {
                    radios[i].setValue(true);
                }
            }
        } else {
        	for (i = 0 , len = items.length; i < len; ++i) {
                cmp = items.items[i];
                if (cmp.inputValue === value) {
                    cmp.setValue(true);
                    break;
                }
            }
        }
        Ext.resumeLayouts(true);
        return this;
    }
});

Ext.override(Ext.scroll.Scroller,{
	 constructor: function(config) {
        var me = this;
        me.position = {
            x: 0,
            y: 0
        };
        me.callParent([
            config
        ]);
        me.bufferedOnDomScrollEnd = Ext.Function.createBuffered(me.onDomScrollEnd, 100, me);
    },
     destroy: function() {
        var me = this;
        clearTimeout(me.restoreTimer);
        clearTimeout(me.onDomScrollEnd.timer);
        // Clear any overflow styles
        me.setX(Ext.emptyString);
        me.setY(Ext.emptyString);
        // Remove element listeners
        me.setElement(null);
        me.setScrollElement(null);
        me.bufferedOnDomScrollEnd = me._partners = me.component = null;
        if (me._translatable) {
            me._translatable.destroy();
            me._translatable = null;
        }
        me.removeSnapStylesheet();
        me.callParent();
    },
	addPartner: function(partner, axis) {
        var me = this,
            partners = me._partners || (me._partners = {}),
            otherPartners = partner._partners || (partner._partners = {});
        // Translate to boolean flags. {x:<boolean>,y:<boolean>}
        axis = me.axisConfigs[axis || 'both'];
        partners[partner.getId()] = {
            scroller: partner,
            axes: axis
        };
        otherPartners[me.getId()] = {
            scroller: me,
            axes: axis
        };
    },
    scrollIntoView: function(el, hscroll, animate, highlight) {
        var me = this,
            position = me.getPosition(),
            newPosition;
        // Might get called before Component#onBoxReady which is when the Scroller is set up with elements.
        if (el) {
            newPosition = me.getScrollIntoViewXY(el, hscroll);
            // Only attempt to scroll if it's needed.
            if (newPosition.y !== position.y || newPosition.x !== position.x) {
                if (highlight) {
                    me.on({
                        scrollend: 'doHighlight',
                        scope: me,
                        single: true,
                        args: [
                            el,
                            highlight
                        ]
                    });
                }
                me.doScrollTo(newPosition.x, newPosition.y, animate);
            }
            // No scrolling needed, but still honour highlight request
            else if (highlight) {
                me.doHighlight(el, highlight);
            }
        }
    },
    privates: {
    	axisConfigs: {
    	    x: {
                x: true
            },
            y: {
                y: true
            },
            both: {
                x: true,
                y: true
            }
        },
        getScrollIntoViewXY: function(el, hscroll) {
            var position = this.getPosition(),
                newPosition;
            newPosition = Ext.fly(el).getScrollIntoViewXY(this.getElement(), position.x, position.y);
            newPosition.x = (hscroll === false) ? position.x : newPosition.x;
            return newPosition;
        },
    doScrollTo: function(x, y, animate) {
            // There is an IE8 override of this method; when making changes here
            // don't forget to update the override as well
            var me = this,
                element = me.getScrollElement(),
                maxPosition, dom, xInf, yInf, i;
            if (element && !element.destroyed) {
                dom = element.dom;
                xInf = (x === Infinity);
                yInf = (y === Infinity);
                if (xInf || yInf) {
                    maxPosition = me.getMaxPosition();
                    if (xInf) {
                        x = maxPosition.x;
                    }
                    if (yInf) {
                        y = maxPosition.y;
                    }
                }
                if (x !== null) {
                    x = me.convertX(x);
                }
                if (animate) {
                    if (!this._translatable) {
                        this._translatable = new Ext.util.translatable.ScrollPosition({
                            element: element
                        });
                    }
                    this._translatable.translate(x, y, animate);
                } else {
                    if (y != null) {
                        dom.scrollTop = y;
                    }
                    if (x != null) {
                        dom.scrollLeft = x;
                    }
                }
                // Our position object will need refreshing before returning.
                me.positionDirty = true;
            }
        },
        fireScrollStart: function(x, y, xDelta, yDelta) {
            var me = this,
                component = me.component;
            me.invokePartners('onPartnerScrollStart', x, y, xDelta, yDelta);
            if (me.hasListeners.scrollstart) {
                me.fireEvent('scrollstart', me, x, y);
            }
            if (component && component.onScrollStart) {
                component.onScrollStart(x, y);
            }
            Ext.GlobalEvents.fireEvent('scrollstart', me, x, y);
        },
        fireScroll: function(x, y, xDelta, yDelta) {
            var me = this,
                component = me.component;
            me.invokePartners('onPartnerScroll', x, y, xDelta, yDelta);
            if (me.hasListeners.scroll) {
                me.fireEvent('scroll', me, x, y);
            }
            if (component && component.onScrollMove) {
                component.onScrollMove(x, y);
            }
            Ext.GlobalEvents.fireEvent('scroll', me, x, y);
        },
        fireScrollEnd: function(x, y, xDelta, yDelta) {
            var me = this,
                component = me.component;
            me.invokePartners('onPartnerScrollEnd', x, y, xDelta, yDelta);
            if (me.hasListeners.scrollend) {
                me.fireEvent('scrollend', me, x, y);
            }
            if (component && component.onScrollEnd) {
                component.onScrollEnd(x, y);
            }
            Ext.GlobalEvents.fireEvent('scrollend', me, x, y);
        },
	invokePartners: function(method, x, y, xDelta, yDelta) {
            var me = this,
                partners = me._partners,
                partner, id, axes;
            if (!me.suspendSync) {
                me.invokingPartners = true;
                for (id in partners) {
                    axes = partners[id].axes;
                    partner = partners[id].scroller;
                    // Only pass the scroll on to partners if we are are configured to pass on the scrolled dimension
                    if (!partner.invokingPartners && (xDelta && axes.x || yDelta && axes.y)) {
                        partner[method](me, axes.x ? x : null, axes.y ? y : null, xDelta, yDelta);
                    }
                }
                me.invokingPartners = false;
            }
        },
	syncWithPartners: function() {
            var me = this,
                partners = me._partners,
                id, partner, position;
            me.suspendPartnerSync();
            for (id in partners) {
                partner = partners[id].scroller;
                position = partner.getPosition();
                me.onPartnerScroll(partner, position.x, position.y);
            }
            me.resumePartnerSync();
        },
	onDomScroll: function() {
            var me = this,
                position = me.position,
                oldX = position.x,
                oldY = position.y,
                x, y, xDelta, yDelta;
            position = me.updateDomScrollPosition();
            if (me.restoreTimer) {
                clearTimeout(me.onDomScrollEnd.timer);
                return;
            }
            x = position.x;
            y = position.y;
            xDelta = x - oldX;
            yDelta = y - oldY;
            // If we already know about the position. then we've been coerced there by a partner
            // and that will have been firing our event sequence synchronously, so they do not
            // not need to be fire in response to the ensuing scroll event.
            if (xDelta || yDelta) {
                if (!me.isScrolling) {
                    me.isScrolling = Ext.isScrolling = true;
                    me.fireScrollStart(x, y, xDelta, yDelta);
                }
                me.fireScroll(x, y, xDelta, yDelta);
                me.bufferedOnDomScrollEnd(x, y, xDelta, yDelta);
            }
        },
        onDomScrollEnd: function(x, y, xDelta, yDelta) {
            var me = this;
            // Could be destroyed by this time
            if (me.destroying || me.destroyed) {
                return;
            }
            me.isScrolling = Ext.isScrolling = false;
            me.trackingScrollLeft = x;
            me.trackingScrollTop = y;
            me.fireScrollEnd(x, y, xDelta, yDelta);
        },
        onPartnerScrollStart: function(partner, x, y, xDelta, yDelta) {
            // Pass the signal on immediately to all partners.
            this.isScrolling = true;
            this.fireScrollStart(x, y, xDelta, yDelta);
        },
        onPartnerScroll: function(partner, x, y, xDelta, yDelta) {
            this.doScrollTo(x, y, false);
            // Update the known scroll position so that when it reacts to its DOM,
            // it will not register a change and so will not invoke partners.
            // All scroll intentions are propagated synchronously.
            // The ensuing multiple scroll events are then ignored.
            this.updateDomScrollPosition();
            // Pass the signal on immediately to all partners.
            this.fireScroll(x, y, xDelta, yDelta);
        },
        onPartnerScrollEnd: function(partner, x, y, xDelta, yDelta) {
            // Pass the signal on immediately to all partners.
            // We are called by the bufferedOnDomScrollEnd of our controller
            // so we must not add another delay.
            if(this && Ext.isFunction(this.onDomScrollEnd) ) { 
            	this.onDomScrollEnd(x, y, xDelta, yDelta);
            }
        }
    }
});

Ext.override(Ext.selection.CheckboxModel, {
getHeaderConfig: function() {
        var me = this,
            showCheck = me.showHeaderCheckbox !== false,
            htmlEncode = Ext.String.htmlEncode,
            config;

        config = {
            xtype: 'checkcolumn',
            headerCheckbox: showCheck,
            isCheckerHd: showCheck, // historically used as a dicriminator property before isCheckColumn
            ignoreExport: true,
            text: me.headerText,
            width: me.headerWidth,
            sortable: false,
            draggable: false,
            resizable: false,
            hideable: false,
            menuDisabled: true,
            checkOnly: me.checkOnly,
            checkboxAriaRole: 'presentation',
            // Firefox needs pointer-events: none on the checkbox span with checkOnly: true
            // to work around focusing issues
            tdCls: (me.checkOnly ? Ext.baseCSSPrefix + 'selmodel-checkonly ' : '') + me.tdCls,
            cls: Ext.baseCSSPrefix + 'selmodel-column',
            editRenderer: me.editRenderer || me.renderEmpty,            
            locked: me.hasLockedHeader(),
            processEvent: Ext.emptyFn,

            // It must not attempt to set anything in the records on toggle.
            // We handle that in onHeaderClick.
            toggleAll: Ext.emptyFn,

            // The selection model listens to the navigation model to select/deselect
            setRecordCheck: Ext.emptyFn,
            
            // It uses our isRowSelected to test whether a row is checked
            isRecordChecked: me.isRowSelected.bind(me)
        };
        
        if (!me.checkOnly) {
            config.tabIndex = undefined;
            config.ariaRole = 'presentation';
            config.focusable = false;
        }
        else {
            config.useAriaElements = true;
            config.ariaLabel = htmlEncode(me.headerAriaLabel);
            config.headerSelectText = htmlEncode(me.headerSelectText);
            config.headerDeselectText = htmlEncode(me.headerDeselectText);
            config.rowSelectText = htmlEncode(me.rowSelectText);
            config.rowDeselectText = htmlEncode(me.rowDeselectText);
        }
       
        return config;
    }
});

Ext.override(Ext.view.TableLayout, {
	measureContentHeight: function(ownerContext) {
        var owner = this.owner,
            bodyDom = owner.body.dom,
            emptyEl = owner.emptyEl,
            bodyHeight = 0;
        if (emptyEl) {
            bodyHeight += emptyEl.offsetHeight;
        }
        if (bodyDom) {
            bodyHeight += bodyDom.offsetHeight;
        }
        // This will have been figured out by now because the columnWidths have been
        // published...
        if (ownerContext.headerContext.state.boxPlan && ownerContext.headerContext.state.boxPlan.tooNarrow) {
            bodyHeight += Ext.getScrollbarSize().height;
        }
        return bodyHeight;
    },
});

Ext.override(Ext.panel.Table, {
	// locked grid 에서 컬럼 생성시 오류
    syncHeaderVisibility: function() {
        var me = this,
            headerCt = me.headerCt,
            columns = headerCt.items.items,
            len = columns.length,
            currentHideHeaderState = headerCt.height === 0,
            hideHeaders = !!len,
            column, colText, i, viewScroller;
        // If we have not been configured with hideHeaders, then set it if
        // there ARE columns and none of the columns has header text or child columns.
        // For example, a simple tree with an automatically inserted TreeColumn.
        if (me.hideHeaders != null) {
            hideHeaders = me.hideHeaders;
        } else {
            // Loop until we find a column with content.
            for (i = 0; hideHeaders && i < len; i++) {
                column = columns[i];
                colText = column.text;
                // If any column was configured with text *that is not &nbsp;* or child columns, then
                // we must show headers.
                if ((colText && colText !== '\xa0') || column.columns || (column.isGroupHeader && column.items.items.length)) {
                    hideHeaders = false;
                }
            }
        }
        if (!headerCt.rendered || hideHeaders !== currentHideHeaderState) {
            headerCt.setHeight(hideHeaders ? 0 : null);
            headerCt.hiddenHeaders = hideHeaders;
            me.headerCt.toggleCls(me.hiddenHeaderCtCls, hideHeaders);
            me.toggleCls(me.hiddenHeaderCls, hideHeaders);
            if (!hideHeaders) {
                headerCt.setScrollable({
                    x: false,
                    y: false
                });
                viewScroller = Ext.isEmpty(me.lockedGrid) ? me.view.getScrollable():me.lockedGrid.view.getScrollable();
                if (viewScroller) {
                    headerCt.getScrollable().addPartner(viewScroller, 'x');
                }
            }
        }
    }
});