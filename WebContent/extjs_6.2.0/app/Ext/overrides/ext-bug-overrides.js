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
                }/* else {
                	cmp.setValue(false);
                }*/
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
    updateElement: function(element, oldElement) {
        var me = this,
            scrollListener = me.scrollListener,
            elementCls = me.elementCls,
            eventSource, scrollEl;
        // If we have a scrollListener, we also have a scrollElement
        if (scrollListener) {
            scrollListener.destroy();
            me.scrollListener = null;
            me.setScrollElement(null);
        }
        if (oldElement && !oldElement.destroyed) {
            // TODO: might be nice to have x-scroller-foo classes to map overflow styling
            oldElement.setStyle('overflow', 'hidden');
            oldElement.removeCls(elementCls);
        }
        if (element) {
            if (element.dom === document.documentElement || element.dom === document.body) {
                // When the documentElement or body is scrolled, its scroll events are
                // fired via the window object
                eventSource = Ext.getWin();
                scrollEl = Ext.scroll.Scroller.getScrollingElement();
            } else {
                scrollEl = eventSource = element;
            }
            me.setScrollElement(Ext.get(scrollEl));
            me.scrollListener = eventSource.on({
                scroll: me.onDomScroll,
                scope: me,
                destroyable: true
            });
           
            me.initXStyle();
            me.initYStyle();
            element.addCls(elementCls);
            me.initSnap();
            me.initMsSnapInterval();
            me.syncScrollbarCls();
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
                    this._translatable.on('animationend', function() {
                        // Check destroyed vs destroying since we're onFrame here
                        if (me.destroyed) {
                            deferred.reject();
                        } else {
                            deferred.resolve();
                        }
                    }, Ext.global, {
                        single: true,
                        onFrame: true
                    });
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
            me.startX = x - xDelta;
            me.startY = y - yDelta;
            if (me.hasListeners.scrollstart) {
                me.fireEvent('scrollstart', me, x, y);
            }
            if (component && component.onScrollStart) {
                component.onScrollStart(x, y);
            }
            Ext.GlobalEvents.fireEvent('scrollstart', me, x, y, xDelta, yDelta);
        },
        fireScroll: function(x, y, xDelta, yDelta) {
            var me = this,
                component = me.component;
            me.invokePartners('onPartnerScroll', x, y, xDelta, yDelta);
            if (me.hasListeners.scroll) {
                me.fireEvent('scroll', me, x, y, xDelta, yDelta);
            }
            if (component && component.onScrollMove) {
                component.onScrollMove(x, y);
            }
            Ext.GlobalEvents.fireEvent('scroll', me, x, y, xDelta, yDelta);
        },
        fireScrollEnd: function(x, y, xDelta, yDelta) {
            var me = this,
                component = me.component,
                dx = x - me.startX,
                dy = y - me.startY;
            me.startX = me.startY = null;
            me.invokePartners('onPartnerScrollEnd', x, y, xDelta, yDelta);
            if (me.hasListeners.scrollend) {
                me.fireEvent('scrollend', me, x, y, dx, dy);
            }
            if (component && component.onScrollEnd) {
                component.onScrollEnd(x, y);
            }
            Ext.GlobalEvents.fireEvent('scrollend', me, x, y, dx, dy);
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
        readPosition: function(position) {
            var me = this,
                element = me.getScrollElement(),
                elScroll;
            position = position || {};
            if (element && !element.destroyed) {
                elScroll = me.getElementScroll(element);
                position.x = elScroll.left;
                position.y = elScroll.top;
            }
            return position;
        },
        updateDomScrollPosition: function(silent) {
            var me = this,
                position = me.position,
                oldX = position.x,
                oldY = position.y,
                x, y, xDelta, yDelta;
            me.readPosition(position);
            x = position.x;
            y = position.y;
            me.positionDirty = false;
            if (!silent) {
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
            }
            return position;
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
            this.updateDomScrollPosition(true);		//## 6.2.2.475 수정 this.updateDomScrollPosition(true);  
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
        },
        //## 6.2.2.475 수정
        restoreState: function() {
            var me = this,
                el = me.getScrollElement();
            if (el) {
                // Only restore state if has been previously captured! For example,
                // floaters probably have not been hidden before initially shown.
                if (me.trackingScrollTop !== undefined) {
                    // If we're restoring the scroll position, we don't want to publish
                    // scroll events since the scroll position should not have changed
                    // at all as far as the user is concerned, so just do it silently
                    // while ensuring we maintain the correct internal state. 50ms is
                    // enough to capture the async scroll events, anything after that
                    // we re-enable.
                    if (!me.restoreTimer) {
                        me.restoreTimer = Ext.defer(function() {
                            me.restoreTimer = null;
                        }, 50);
                    }
                    me.doScrollTo(me.trackingScrollLeft, me.trackingScrollTop, false);
                }
            }
        }
        
    }
},function(Scroller) {
    /**
     * @private
     * @return {Ext.scroll.Scroller}
     */
    Ext.getViewportScroller = function() {
        // This method creates the global viewport scroller.  This scroller instance must
        // always exist regardless of whether or not there is a Viewport component in use
        // so that global scroll events will still fire.  Menus and some other floating
        // things use these scroll events to hide themselves.
        return Scroller.viewport || (Scroller.viewport = new Scroller());
    };
    /**
     * @private
     * @param {Ext.scroll.Scroller} scroller
     */
    Ext.setViewportScroller = function(scroller) {
        if (Scroller.viewport !== scroller) {
            Ext.destroy(Scroller.viewport);
            Scroller.viewport = scroller.isScroller ? scroller : new Scroller(scroller);
        }
    };
    Ext.onReady(function() {
        Ext.defer(function() {
            // The viewport scroller must always exist, but it is deferred so that the
            // viewport component has a chance to call Ext.setViewportScroller() with
            // its own scroller first.
            var scroller = Ext.getViewportScroller();
            if (!scroller.getElement()) {
                // if the viewport component has already claimed the viewport scroller
                // it will have already set its overflow element as the scroller element,
                // otherwise, the element is always the body.
                scroller.setElement(Ext.getBody());
            }
        }, 100);
    });
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
    //EXTJS-26076 bugfix(6.5.0)
    finishedLayout: function(ownerContext) {
        var me = this,
            ownerGrid = me.owner.ownerGrid,
            nodeContainer = Ext.fly(me.owner.getNodeContainer()),
            scroller = this.owner.getScrollable(),
            buffered;
        me.callParent([
            ownerContext
        ]);
        if (nodeContainer) {
            nodeContainer.setWidth(ownerContext.headerContext.props.contentWidth);
        }
        // Inform any buffered renderer about completion of the layout of its view
        if (me.owner.bufferedRenderer) {
            me.owner.bufferedRenderer.afterTableLayout(ownerContext);
        }
        if (ownerGrid) {
            ownerGrid.syncRowHeightOnNextLayout = false;
        }
        buffered = me.owner.bufferedRenderer;
        if (scroller && !scroller.isScrolling) {
        	if (buffered && buffered.nextRefreshStartIndex === 0) {
                return;
            }
            scroller.restoreState();
        }
    }
});

Ext.override(Ext.grid.feature.Grouping, {
	 getMetaGroup: function(group) {
        var metaGroupCache = this.metaGroupCache || this.createCache(),
            key, metaGroup;
        if (group != null && group.isModel) {
            group = this.getGroup(group);
        }
        // An empty string is a valid groupKey so only filter null and undefined.
        if (group != null) {
            key = (typeof group === 'string') ? group : group.getGroupKey();
            metaGroup = metaGroupCache[key];
            if (!metaGroup) {
                // TODO: Break this out into its own method?
                metaGroup = metaGroupCache[key] = {
                    isCollapsed: false,
                    lastGroup: null,
                    lastGroupGeneration: null,
                    lastFilterGeneration: null,
                    aggregateRecord: new Ext.data.Model()
                };
            }
        }
        return metaGroup;
    }
});

Ext.override(Ext.grid.plugin.BufferedRenderer, {
	scrollTo: function(recordIdx, options) {
        var args = arguments,
            me = this,
            view = me.view,
            lockingPartner = view.lockingPartner && view.lockingPartner.grid.isVisible() && view.lockingPartner.bufferedRenderer,
            store = me.store,
            total = store.getCount(),
            startIdx, endIdx,
            targetRow,
            tableTop,
            groupingFeature,
            metaGroup,
            record,
            direction;

        // New option object API
        if (options !== undefined && !(options instanceof Object)) {
            options = {
                select : args[1],
                callback: args[2],
                scope: args[3]
            };
        }

        // If we have a grouping summary feature rendering the view in groups,
        // first, ensure that the record's group is expanded,
        // then work out which record in the groupStore the record is at.
        if ((groupingFeature = view.dataSource.groupingFeature) && (groupingFeature.collapsible) ) {
            if (recordIdx.isEntity) {
                record = recordIdx;
            } else if(recordIdx == 0)	{
            	record = view.store.getAt(recordIdx);
            } else {
            	if(view.store.getCount() != 0)	{
                	record = view.store.getAt(Math.min(Math.max(recordIdx, 0), view.store.getCount() - 1));
            	} else {
            		//view.store.data = me.store.data;
            		//record = view.store.getAt(recordIdx);
            		return;
            	}
            }

            metaGroup = groupingFeature.getMetaGroup(record);

            if (metaGroup && metaGroup.isCollapsed) {
                if (!groupingFeature.isExpandingOrCollapsing && record !== metaGroup.placeholder) {
                    groupingFeature.expand(groupingFeature.getGroup(record).getGroupKey());
                    total = store.getCount();
                    recordIdx = groupingFeature.indexOf(record);
                } else {
                    // If we've just been collapsed, then the only record we have is
                    // the wrapped placeholder
                    record = metaGroup.placeholder;
                    recordIdx = groupingFeature.indexOfPlaceholder(record);
                }
            } else {
            	if(record)	{
                	recordIdx = groupingFeature.indexOf(record);
            	}
            }

        } else {

            if (recordIdx.isEntity) {
                record = recordIdx;
                recordIdx = store.indexOf(record);

                // Currently loaded pages do not contain the passed record, we cannot proceed.
                if (recordIdx === -1) {
                    //<debug>
                    Ext.raise('Unknown record passed to BufferedRenderer#scrollTo');
                    //</debug>
                    return;
                }
            } else {
                // Sanitize the requested record index
                recordIdx = Math.min(Math.max(recordIdx, 0), total - 1);
                record = store.getAt(recordIdx);
            }
        }

        // See if the required row for that record happens to be within the rendered range.
        if (record && (targetRow = view.getNode(record))) {
            view.grid.ensureVisible(record,options);

            // Keep the view immediately replenished when we scroll an existing element into view.
            // DOM scroll events fire asynchronously, and we must not leave subsequent code without a valid buffered row block.
            me.onViewScroll();
            me.onViewScrollEnd();

            return;
        }

        // Calculate view start index.
        // If the required record is above the fold...
        if (recordIdx == 0 || recordIdx < view.all.startIndex) {
            // The startIndex of the new rendered range is a little less than the target record index.
            direction = -1;
            startIdx = Math.max(Math.min(recordIdx - (Math.floor((me.leadingBufferZone + me.trailingBufferZone) / 2)), total - me.viewSize + 1), 0);
            endIdx = Math.min(startIdx + me.viewSize - 1, total - 1);
        }
        // If the required record is below the fold...
        else {
            // The endIndex of the new rendered range is a little greater than the target record index.
            direction = 1;
            endIdx = Math.min(recordIdx + (Math.floor((me.leadingBufferZone + me.trailingBufferZone) / 2)), total - 1);
            startIdx = Math.max(endIdx - (me.viewSize - 1), 0);
        }
        tableTop = Math.max(startIdx * me.rowHeight, 0);

        store.getRange(startIdx, endIdx, {
            callback: function(range, start, end) {
                // Render the range.
                // Pass synchronous flag so that it does it inline, not on a timer.
                // Pass fromLockingPartner flag so that it does not inform the lockingPartner.
                me.renderRange(start, end, true, true);
                record = store.data.getRange(recordIdx, recordIdx + 1)[0];
                targetRow = view.getNode(record);

                // bodyTop property must track the translated position of the body
                view.body.translate(null, me.bodyTop = tableTop);

                // Ensure the scroller knows about the range if we're going down
                if (direction === 1) {
                    me.refreshSize();
                }

                // Locking partner must render the same range
                if (lockingPartner) {
                    lockingPartner.renderRange(start, end, true, true);

                    // Sync all row heights
                    me.syncRowHeights();

                    // bodyTop property must track the translated position of the body
                    lockingPartner.view.body.translate(null, lockingPartner.bodyTop = tableTop);

                    // Ensure the scroller knows about the range if we're going down
                    if (direction === 1) {
                        lockingPartner.refreshSize();
                    }
                }

                // The target does not map to a view node.
                // Cannot scroll to it.
                if (!targetRow) {
                    return;
                }
                view.grid.ensureVisible(record,options);

                me.scrollTop = me.position = me.scroller.getPosition().y;

                if (lockingPartner) {
                    lockingPartner.position = lockingPartner.scrollTop = me.scrollTop;
                }
            }
        });
    },

    onRangeFetched: function(range, start, end, options, fromLockingPartner) {
        var me = this,
            view = me.view,
            scroller = me.scroller,
            viewEl = view.el,
            rows = view.all,
            increment = 0,
            calculatedTop,
            lockingPartner = (view.lockingPartner && !fromLockingPartner && !me.doNotMirror) && view.lockingPartner.bufferedRenderer,
            variableRowHeight = me.variableRowHeight,
            oldBodyHeight = me.bodyHeight,
            layoutCount = view.componentLayoutCounter,
            activeEl, containsFocus, i, newRows, newTop, newFocus, noOverlap,
            oldStart, partnerNewRows, pos, removeCount, topAdditionSize, topBufferZone;

        // View may have been destroyed since the DelayedTask was kicked off.
        if (view.destroyed) {
            return;
        }

        // If called as a callback from the Store, the range will be passed, if called from renderRange, it won't
        if (range) {
            if (!fromLockingPartner) {
                // Re-cache the scrollTop if there has been an asynchronous call to the server.
                me.scrollTop = me.scroller.getPosition().y;
            }
        } else {
            range = me.store.getRange(start, end);

            // Store may have been cleared since the DelayedTask was kicked off.
            if (!range) {
                return;
            }
        }

        // If we contain focus now, but do not when we have rendered the new rows, we must focus the view el.
        activeEl = Ext.Element.getActiveElement(true);
        containsFocus = viewEl.contains(activeEl);

        // In case the browser does fire synchronous focus events when a focused element is derendered...
        if (containsFocus) {
            activeEl.suspendFocusEvents();
        }

        // Best guess rendered block position is start row index * row height.
        // We can use this as bodyTop if the row heights are all standard.
        // We MUST use this as bodyTop if the scroll is a telporting scroll.
        // If we are incrementally scrolling, we add the rows to the bottom, and
        // remove a block of rows from the top.
        // The bodyTop is then incremented by the height of the removed block to keep
        // the visuals the same.
        //
        // We cannot always use the calculated top, and compensate by adjusting the scroll position
        // because that would break momentum scrolling on DOM scrolling platforms, and would be
        // immediately undone in the next frame update of a momentum scroll on touch scroll platforms.
        calculatedTop = start * me.rowHeight;

        // The new range encompasses the current range. Refresh and keep the scroll position stable
        if (start < rows.startIndex && end > rows.endIndex) {

            // How many rows will be added at top. So that we can reposition the table to maintain scroll position
            topAdditionSize = rows.startIndex - start;

            // MUST use View method so that itemremove events are fired so widgets can be recycled.
            view.clearViewEl(true);
            newRows = view.doAdd(range, start);
            view.fireItemMutationEvent('itemadd', range, start, newRows, view);
            for (i = 0; i < topAdditionSize; i++) {
                increment -= newRows[i].offsetHeight;
            }

            // We've just added a bunch of rows to the top of our range, so move upwards to keep the row appearance stable
           newTop = me.bodyTop + increment;
        }
        else {
            // No overlapping nodes; we'll need to render the whole range.
            // teleported flag is set in getFirstVisibleRowIndex/getLastVisibleRowIndex if
            // the table body has moved outside the viewport bounds
            noOverlap = me.teleported || start > rows.endIndex || end < rows.startIndex;
            if (noOverlap) {
                view.clearViewEl(true);
                me.teleported = false;
            }

            if (!rows.getCount()) {
                newRows = view.doAdd(range, start);
                view.fireItemMutationEvent('itemadd', range, start, newRows, view);
                newTop = calculatedTop;

                // Adjust the bodyTop to place the data correctly around the scroll vieport
                if (noOverlap && variableRowHeight) {
                    topBufferZone = me.scrollTop < me.position ? me.leadingBufferZone : me.trailingBufferZone;
                    newTop = Math.max(me.scrollTop - rows.item(rows.startIndex + topBufferZone - 1, true).offsetTop, 0);
                }
            }
            // Moved down the dataset (content moved up): remove rows from top, add to end
            else if (end > rows.endIndex) {
                removeCount = Math.max(start - rows.startIndex, 0);

                // We only have to bump the table down by the height of removed rows if rows are not a standard size
                if (variableRowHeight) {
                    increment = rows.item(rows.startIndex + removeCount, true).offsetTop;
                }
                newRows = rows.scroll(Ext.Array.slice(range, rows.endIndex + 1 - start), 1, removeCount);
                // 2018.05.10 추가
				view.el.dom.scrollTop = me.scrollTop;
				// 2018.05.10 추가 끝
				
                // We only have to bump the table down by the height of removed rows if rows are not a standard size
                if (variableRowHeight) {
                    // Bump the table downwards by the height scraped off the top
                    newTop = me.bodyTop + increment;
                }
                // If the rows are standard size, then the calculated top will be correct
                else {
                    newTop = calculatedTop;
                }
            }
            // Moved up the dataset: remove rows from end, add to top
            else {
                removeCount = Math.max(rows.endIndex - end, 0);
                oldStart = rows.startIndex;
                newRows = rows.scroll(Ext.Array.slice(range, 0, rows.startIndex - start), -1, removeCount);
				// 2018.05.10 추가
				view.el.dom.scrollTop = me.scrollTop;
				// 2018.05.10 추가 끝
				
                // We only have to bump the table up by the height of top-added rows if rows are not a standard size
                if (variableRowHeight) {
                    // Bump the table upwards by the height added to the top
                    newTop = me.bodyTop - rows.item(oldStart, true).offsetTop;

                    // We've arrived at row zero...
                    if (!rows.startIndex) {
                        // But the calculated top position is out. It must be zero at this point
                        // We adjust the scroll position to keep visual position of table the same.
                        if (newTop) {
                            scroller.scrollTo(null, me.position = (me.scrollTop -= newTop));
                            newTop = 0;
                        }
                    }

                    // Not at zero yet, but the position has moved into negative range
                    else if (newTop < 0) {
                        increment = rows.startIndex * me.rowHeight;
                        scroller.scrollTo(null, me.position = (me.scrollTop += increment));
                        newTop = me.bodyTop + increment;
                    }
                }
                // If the rows are standard size, then the calculated top will be correct
                else {
                    newTop = calculatedTop;
                }
            }

            // The position property is the scrollTop value *at which the table was last correct*
            // MUST be set at table render/adjustment time
            me.position = me.scrollTop;
        }

        // We contained focus at the start, check whether activeEl has been derendered.
        // Focus the cell's column header if so.
        if (containsFocus) {
            // Restore active element's focus processing.
            activeEl.resumeFocusEvents();

            if (!viewEl.contains(activeEl)) {
                pos = view.actionableMode ? view.actionPosition : view.lastFocused;
                if (pos && pos.column) {
                    // we set the rendering rows to true here so the actionables know
                    // that view is forcing the onFocusLeave method here
                    view.renderingRows = true;
                    view.onFocusLeave({});
                    view.renderingRows = false;
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
                partnerNewRows = lockingPartner.onRangeFetched(range, start, end, options, true);

                // Sync the row heights if configured to do so, or if one side has variableRowHeight but the other doesn't.
                // variableRowHeight is just a flag for the buffered rendering to know how to measure row height and
                // calculate firstVisibleRow and lastVisibleRow. It does not *necessarily* mean that row heights are going
                // to be asymmetric between sides. For example grouping causes variableRowHeight. But the row heights
                // each side will be symmetric.
                // But if one side has variableRowHeight (eg, a cellWrap: true column), and the other does not, that
                // means there could be asymmetric row heights.
                if (view.ownerGrid.syncRowHeight || view.ownerGrid.syncRowHeightOnNextLayout || (lockingPartner.variableRowHeight !== variableRowHeight)) {
                    me.syncRowHeights(newRows, partnerNewRows);
                    view.ownerGrid.syncRowHeightOnNextLayout = false;
                }
            }
            if (lockingPartner.bodyTop !== newTop) {
                lockingPartner.setBodyTop(newTop);
            }
            // Set the real scrollY position after the correct data has been rendered there.
            // It will not handle a scroll because the scrollTop and position have been preset.
            lockingPartner.scroller.scrollTo(null, me.scrollTop);
        }

        // If there's variableRowHeight and the scroll operation did affect that, remeasure now.
        // We must do this because the RowExpander and RowWidget plugin might make huge differences
        // in rowHeight, so we might scroll from a zone full of 200 pixel hight rows to a zone of
        // all 21 pixel high rows.
        if (me.variableRowHeight && me.bodyHeight !== oldBodyHeight && view.componentLayoutCounter === layoutCount) {
            delete me.rowHeight;
            me.refreshSize();
        }

        //<debug>
        // If there are columns to trigger rendering, and the rendered block os not either the view size
        // or, if store count less than view size, the store count, then there's a bug.
        if (view.getVisibleColumnManager().getColumns().length && rows.getCount() !== Math.min(me.store.getCount(), me.viewSize)) {
            Ext.raise('rendered block refreshed at ' + rows.getCount() + ' rows while BufferedRenderer view size is ' + me.viewSize);
        }
        //</debug>
        return newRows;
    }
    
});

Ext.override(Ext.scroll.TableScroller, {
    
    config: {
        lockingScroller: null
    },

     privates: {
        getScrollIntoViewXY: function(el, hscroll) {
            var lockingScroller = this.getLockingScroller(),
                position = this.getPosition(),
                newPosition;
            
            if (lockingScroller) {
                position.y = lockingScroller.position.y;
            }

            newPosition = Ext.fly(el).getScrollIntoViewXY(this.getElement(), position.x, position.y);
            newPosition.x = (hscroll === false) ? position.x : newPosition.x;
            if (lockingScroller) {
                newPosition.y = Ext.fly(el).getScrollIntoViewXY(lockingScroller.getElement(), position.x, position.y).y;
            }
            return newPosition;
        },

        doScrollTo: function(x, y, animate) {
            var lockingScroller;

            if (y != null) {
                lockingScroller = this.getLockingScroller();

                if (lockingScroller) {
                    lockingScroller.doScrollTo(null, y, animate);
                    y = null;
                }
            }

            this.callParent([x, y, animate]);
        }
    }

});

Ext.override(Ext.grid.NavigationModel, {
	initKeyNav: function(view) {
        var me = this,
            nav;

        // We will have two keyNavs if we are the navigation model for a lockable assembly
        if (!me.keyNav) {
            me.keyNav = [];
            me.position = new Ext.grid.CellContext(view);
        }

        // Drive the KeyNav off the View's itemkeydown event so that beforeitemkeydown listeners may veto.
        // By default KeyNav uses defaultEventAction: 'stopEvent', and this is required for movement keys
        // which by default affect scrolling.
        
        nav = new Ext.util.KeyNav({
            target: view,
            ignoreInputFields: true,

            // Must use the same event that form fields use to detect keystrokes.
            // keypress happens *after* keydown, but the framework must see key events in bubble sequence order
            // So a field in actionable mode must see its key event before this nav model.
            eventName: Ext.supports.SpecialKeyDownRepeat ? 'itemkeydown' : 'itemkeypress',
            defaultEventAction: 'stopEvent',

            processEvent: me.processViewEvent,
            up: me.onKeyUp,
            down: me.onKeyDown,
            right: me.onKeyRight,
            left: me.onKeyLeft,
            pageDown: me.onKeyPageDown,
            pageUp: me.onKeyPageUp,
            home: me.onKeyHome,
            end: me.onKeyEnd,
            space: me.onKeySpace,
            enter: me.onKeyEnter,
            esc: me.onKeyEsc,
            113: {
                // Actionable mode is triggered by F2 key with no modifiers
                ctrl: false,
                shift: false,
                alt: false,
                handler: me.onKeyF2
            },
            tab: me.onKeyTab,
            A: {
                ctrl: true,
                // Need a separate function because we don't want the key
                // events passed on to selectAll (causes event suppression).
                handler: me.onSelectAllKeyPress
            },
            scope: me
        });
        me.keyNav.push(nav);
        me.onKeyNavCreate(nav);
    },
	   onContainerMouseDown: function(view, mousedownEvent) {
        var me = this,
            context = new Ext.grid.CellContext(view),
            lastFocused, position;

        me.callParent([view, mousedownEvent]);

        lastFocused = view.lastFocused;
        position = (view.actionableMode && view.actionPosition) || lastFocused;
        
        if (!position || lastFocused === 'scrollbar') {
            return;
        }
        
        context.setPosition(position.record, position.column);
        mousedownEvent.position = context;
        me.attachClosestCell(mousedownEvent);
        
        // If we are not already on that position, set position there.
        if (!me.position.isEqual(context)) {
            me.setPosition(context, null, mousedownEvent);
        }
    },
        onCellMouseDown: function(view, cell, cellIndex, record, row, recordIndex, mousedownEvent) {
        var targetComponent = Ext.Component.fromElement(mousedownEvent.target, cell),
            actionableEl = mousedownEvent.getTarget(this.isFocusableEl, cell),
            ac;

        // If actionable mode, and		
        //  (mousedown on a tabbable, or anywhere in the ownership tree of an inner active component),		
        // we should just keep the action position synchronized.
        // The tabbable element will be part of actionability.	
        // If the mousedown was NOT on some focusable object, we need to exit actionable mode.
        if (view.actionableMode) {
            // If mousedown is on a focusable element, or in the component tree of the active component (which is NOT this)
            if (!actionableEl) {
                actionableEl = (ac = Ext.ComponentManager.getActiveComponent()) && ac !== view && ac.owns(mousedownEvent);
            }
            if (actionableEl) {
                // Keep actionPosition synched
                view.setActionableMode(true, mousedownEvent.position);
            }
            // Not on anything actionable, then exit actionable mode
            else {
                view.setActionableMode(false, mousedownEvent.position);
            }
            return;
        }

        // If the event is a touchstart, leave it until the click to focus.
        // Mousedowns may have a focusing effect.
        if (mousedownEvent.pointerType !== 'touch') {
            if (mousedownEvent.position.column.cellFocusable !== false) {
                if (actionableEl) {

                    // So that the impending onFocusEnter does not
                    // process the event and delegate focus. We
                    // control that here. This means disabling tabbability.
                    if (!view.containsFocus) {
                        view.containsFocus = true;
                        view.toggleChildrenTabbability(false);
                    }
                    if (view.setActionableMode(true, mousedownEvent.position) !== false) {
                        actionableEl.focus();
                    }
                } else {
                    cell.focus();
                }
                if (mousedownEvent.button === 2) {
                    this.fireNavigateEvent(mousedownEvent);
                }
                
                // If mousedowning on a focusable Component.
                // After having set the position according to the mousedown, we then
                // enter actionable mode and focus the component just as if the user
                // Had navigated here and pressed F2.
                if (targetComponent && targetComponent.isFocusable && targetComponent.isFocusable()) {
                    view.setActionableMode(true, mousedownEvent.position);
                    
                    // Focus the targeted Component
                    targetComponent.focus();
                }
            }
            else {
                mousedownEvent.preventDefault(true);
            }
        }
    },
        onItemMouseDown: function(view, record, item, index, mousedownEvent) {
        var me = this,
            scroller;

        // If the event is a touchstart, leave it until the click to focus
        // A mousedown outside a cell. Must be in a Feature, or on a row border
        if (!mousedownEvent.position.cellElement && (mousedownEvent.pointerType !== 'touch')) {
            // We are going to redirect focus, so do not allow default focus to proceed
            // but allow text selection if the view is configured with enableTextSelection
            if (!view.enableTextSelection) {
                mousedownEvent.preventDefault();
            }

            // Stamp the closest cell into the event as if it were a cellmousedown
            me.attachClosestCell(mousedownEvent);

            // If we are not already on that position, set position there.
            if (!me.position.isEqual(mousedownEvent.position)) {
                me.setPosition(mousedownEvent.position, null, mousedownEvent);
            }

            // If the browser autoscrolled to bring the cell into focus
            // undo that.
            scroller = view.getScrollable();
            
            if (scroller) {
                scroller.restoreState();
            }
        }
    },

    onItemClick: function(view, record, item, index, clickEvent) {
        // A mousedown outside a cell. Must be in a Feature, or on a row border
        if (!clickEvent.position.cellElement) {
            this.attachClosestCell(clickEvent);

            // touchstart does not focus the closest cell, leave it until touchend (translated as a click)
            if (clickEvent.pointerType === 'touch') {
                this.setPosition(clickEvent.position, null, clickEvent);
            } else {
                this.fireNavigateEvent(clickEvent);
            }
        }
    },
        move: function(dir, keyEvent) {
        var me = this,
            position = me.getPosition(),
            result = position,
            rowVeto = keyEvent.shiftKey && (dir === 'right' || dir === 'left');
        
        if (position && position.record) {
            while (result) {
                // Do not allow SHIFT+(left|right) to wrap.
                // Important to use result.view, since a call to walkCells could change the
                // resulting view if we're using locking.
                result = result.view.walkCells(result, dir, rowVeto ? me.vetoRowChange : null, me);

                // If the new position is fousable, we're done.
                if (result && result.column.cellFocusable !== false) {
                    return result;
                }
            }
        }
        // <debug>
        // Enforce code correctness in unbuilt source.
        return null;
        // </debug>
    },
    attachClosestCell: function(event) {
        var position = event.position,
            targetCell = position.cellElement,
            x, columns, len, i, column, b;

        if (!targetCell) {
            x = event.getX();
            columns = position.view.getVisibleColumnManager().getColumns();
            len = columns.length;
            for (i = 0; i < len; i++) {
                column = columns[i];
                b = columns[i].getBox();
                if (x >= b.left && x < b.right) {
                    position.setColumn(columns[i]);
                    position.rowElement = position.getRow(true);
                    position.cellElement = position.getCell(true);
                    return;
                }
            }
        }
    },
    isFocusableEl: function(el) {
        return Ext.fly(el).isFocusable();
    }
});

Ext.define('Ext.overrides.dom.Element', (function() {
	return {
		override: 'Ext.dom.Element',
		focus: function(defer, /* private */
        dom) {
            var me = this;
            dom = dom || me.dom;
            if (Number(defer)) {
                Ext.defer(me.focus, defer, me, [
                    null,
                    dom
                ]);
            } else {
            	if(dom)	{
                	Ext.GlobalEvents.fireEvent('beforefocus', dom);
                	dom.focus();
            	}
            }
            return me;
        }
	}
})()
);

Ext.override(Ext.view.Table, {
	getDefaultFocusPosition: function(fromComponent) {
        var me = this,
            store = me.dataSource,
            focusPosition = me.lastFocused,
            newPosition = new Ext.grid.CellContext(me).setPosition(0, 0),
            targetCell, scroller;
        if (fromComponent) {
            // Tabbing in from one of our column headers; the user will expect to land in that column.
            // Unless it is configured cellFocusable: false
            if (fromComponent.isColumn && fromComponent.cellFocusable !== false) {
                if (!focusPosition) {
                    focusPosition = newPosition;
                }
                focusPosition.setColumn(fromComponent);
                focusPosition.setView(fromComponent.getView());
            }
            // Tabbing in from the neighbouring TableView (eg, locking).
            // Go to column zero, same record
            else if (fromComponent.isTableView && fromComponent.lastFocused && fromComponent.ownerGrid === me.ownerGrid) {
                focusPosition = new Ext.grid.CellContext(me).setPosition(fromComponent.lastFocused.record, 0);
            }
        }
        // We found a position from the "fromComponent, or there was a previously focused context
        if (focusPosition) {
            scroller = me.getScrollable();
            // Record is not in the store, or not in the rendered block.
            // Fall back to using the same row index.
            if ((focusPosition.record &&!store.contains(focusPosition.record) ) || (scroller && !scroller.isInView(focusPosition.getRow()).y)) {
                focusPosition.setRow(store.getAt(Math.min(focusPosition.rowIdx, store.getCount() - 1)));
            }
        } else // All else fails, find the first focusable cell.
        {
            focusPosition = newPosition;
            // Find the first focusable cell.
            targetCell = me.el.down(me.getCellSelector() + '[tabIndex="-1"]');
            if (targetCell) {
                focusPosition.setPosition(me.getRecord(targetCell), me.getHeaderByCell(targetCell));
            } else // All visible columns are cellFocusable: false
            {
                focusPosition = null;
            }
        }
        return focusPosition;
    }
});

Ext.override(Ext.grid.CellContext, {
	setView: function(view) {
        this.view = view;
        this.refresh();
    }
});
//## 6.2.2.475
Ext.override(Ext.grid.locking.View, {
	 onDataRefresh: function() {
        Ext.suspendLayouts();
        this.relayFn('onDataRefresh', arguments);
        this.ownerGrid.view.refreshView();
        Ext.resumeLayouts(true);
    },
        setActionableMode: function(enabled, position) {
        var result,
            targetView;

        if (enabled) {
            if (!position) {
                position = this.getNavigationModel().getPosition();
            }
            if (position) {
                position = position.clone();

                // Drill down to the side that we're actioning
                position.view = targetView = position.column.getView();

                // Attempt to switch the focused view to actionable.
                result = targetView.setActionableMode(enabled, position);

                // If successful, and the partner is visible, switch that too.
                if (result !== false && targetView.lockingPartner.grid.isVisible()) {
                    targetView.lockingPartner.setActionableMode(enabled, position);

                    // If the partner side refused to cooperate, the whole locking.View must not enter actionable mode
                    if (!targetView.lockingPartner.actionableMode) {
                        targetView.setActionableMode(false);
                        result = false;
                    }
                }
                return result;
            } else {
                return false;
            }
        } else {
            this.relayFn('setActionableMode', [false, position]);
        }
    },
    destroy: function() {
        var me = this;
        
        me.rendered = false;

        // Unbind from the dataSource we bound to in constructor
        me.bindStore(null, false, 'dataSource');
        
        Ext.destroy(me.selModel, me.navigationModel, me.loadMask);
        
        me.lockedView.lockingPartner = me.normalView.lockingPartner = null;
        
        me.callParent();
    }
    
});
//## 6.2.2.475
Ext.override(Ext.grid.locking.Lockable, {
	determineXTypeToCreate: function(lockedSide) {
        var me = this;

        if (me.subGridXType) {
            return me.subGridXType;
        } else if (!lockedSide) {
            // Tree columns only moves down into the locked side.
            // The normal side is always just a grid
            return 'gridpanel'; 
        }

        return me.isXType('treepanel') ? 'treepanel' : 'gridpanel';
    },
    
        injectLockable: function() {
        // The child grids are focusable, not this one
        this.focusable = false;

        // ensure lockable is set to true in the TablePanel
        this.lockable = true;
        // Instruct the TablePanel it already has a view and not to create one.
        // We are going to aggregate 2 copies of whatever TablePanel we are using
        this.hasView = true;

        var me = this,
            store = me.store = Ext.StoreManager.lookup(me.store),
            lockedViewConfig = me.lockedViewConfig,
            normalViewConfig = me.normalViewConfig,
            Obj = Ext.Object,

            // Hash of {lockedFeatures:[],normalFeatures:[]}
            allFeatures,

            // Hash of {topPlugins:[],lockedPlugins:[],normalPlugins:[]}
            allPlugins,

            lockedGrid,
            normalGrid,
            i,
            columns,
            lockedHeaderCt,
            normalHeaderCt,
            viewConfig = me.viewConfig,
            // When setting the loadMask value, the viewConfig wins if it is defined.
            loadMaskCfg = viewConfig && viewConfig.loadMask,
            loadMask = (loadMaskCfg !== undefined) ? loadMaskCfg : me.loadMask,
            bufferedRenderer = me.bufferedRenderer,
            setWidth;

        allFeatures = me.constructLockableFeatures();

        // Must be available early. The BufferedRenderer needs access to it to add
        // scroll listeners.
        me.scrollable = new Ext.scroll.LockingScroller({
            component: me,
            x: false,
            y: true
        });

        // This is just a "shell" Panel which acts as a Container for the two grids and must not use the features
        me.features = null;

        // Distribute plugins to whichever Component needs them
        allPlugins = me.constructLockablePlugins();
        me.plugins = allPlugins.topPlugins;

        lockedGrid = {
            id: me.id + '-locked',
            $initParent: me,
            isLocked: true,
            bufferedRenderer: bufferedRenderer,
            ownerGrid: me,
            ownerLockable: me,
            xtype: me.determineXTypeToCreate(true),
            store: store,
            scrollerOwner: false,
            // Lockable does NOT support animations for Tree
            // Because the right side is just a grid, and the grid view doen't animate bulk insertions/removals
            animate: false,
            border: false,
            cls: me.lockedGridCls,

            // Usually a layout in one side necessitates the laying out of the other side even if each is fully
            // managed in both dimensions, and is therefore a layout root.
            // The only situation that we do *not* want layouts to escape into the owning lockable assembly
            // is when using a border layout and any of the border regions is floated from a collapsed state.
            isLayoutRoot: function() {
                return this.floatedFromCollapse || this.ownerGrid.normalGrid.floatedFromCollapse;
            },
            features: allFeatures.lockedFeatures,
            plugins: allPlugins.lockedPlugins
        };

        normalGrid = {
            id: me.id + '-normal',
            $initParent: me,
            isLocked: false,
            bufferedRenderer: bufferedRenderer,
            ownerGrid: me,
            ownerLockable: me,
            xtype: me.determineXTypeToCreate(),
            store: store,
            // Pass down our reserveScrollbar to the normal side:
            reserveScrollbar: me.reserveScrollbar,
            scrollerOwner: false,
            border: false,
            cls: me.normalGridCls,

            // As described above, isolate layouts when floated out from a collapsed border region.
            isLayoutRoot: function() {
                return this.floatedFromCollapse || this.ownerGrid.lockedGrid.floatedFromCollapse;
            },
            features: allFeatures.normalFeatures,
            plugins: allPlugins.normalPlugins
        };

        me.addCls(Ext.baseCSSPrefix + 'grid-locked');

        // Copy appropriate configurations to the respective aggregated tablepanel instances.
        // Pass 4th param true to NOT exclude those settings on our prototype.
        // Delete them from the master tablepanel.
        Ext.copy(normalGrid, me, me.bothCfgCopy, true);
        Ext.copy(lockedGrid, me, me.bothCfgCopy, true);
        Ext.copy(normalGrid, me, me.normalCfgCopy, true);
        Ext.copy(lockedGrid, me, me.lockedCfgCopy, true);

        Ext.apply(normalGrid, me.normalGridConfig);
        Ext.apply(lockedGrid, me.lockedGridConfig);

        for (i = 0; i < me.normalCfgCopy.length; i++) {
            delete me[me.normalCfgCopy[i]];
        }

        for (i = 0; i < me.lockedCfgCopy.length; i++) {
            delete me[me.lockedCfgCopy[i]];
        }

        me.addStateEvents(['lockcolumn', 'unlockcolumn']);

        columns = me.processColumns(me.columns || [], lockedGrid);

        lockedGrid.columns = columns.locked;

        // If no locked columns, hide the locked grid
        if (!lockedGrid.columns.items.length) {
            lockedGrid.hidden = true;
        }
        normalGrid.columns = columns.normal;

        if (!normalGrid.columns.items.length) {
            normalGrid.hidden = true;
        }

        // normal grid should flex the rest of the width
        normalGrid.flex = 1;
        // Chain view configs to avoid mutating user's config
        lockedGrid.viewConfig = lockedViewConfig = (lockedViewConfig ? Obj.chain(lockedViewConfig) : {});
        normalGrid.viewConfig = normalViewConfig = (normalViewConfig ? Obj.chain(normalViewConfig) : {});
        lockedViewConfig.loadingUseMsg = false;
        lockedViewConfig.loadMask = false;
        normalViewConfig.loadMask = false;

        //<debug>
        if (viewConfig && viewConfig.id) {
            Ext.log.warn('id specified on Lockable viewConfig, it will be shared between both views: "' + viewConfig.id + '"');
        }
        //</debug>

        Ext.applyIf(lockedViewConfig, viewConfig);
        Ext.applyIf(normalViewConfig, viewConfig);

        // Allow developer to configure the layout.
        // Instantiate the layout so its type can be ascertained.
        if (me.layout === Ext.panel.Table.prototype.layout) {
            me.layout = {
                type: 'hbox',
                align: 'stretch'
            };
        }
        me.getLayout();

        // Sanity check the split config.
        // Only allowed to insert a splitter between the two grids if it's a box layout
        if (me.layout.type === 'border') {
            if (me.split) {
                lockedGrid.split = me.split;
            }
            if (!lockedGrid.region) {
                lockedGrid.region = 'west';
            }
            if (!normalGrid.region) {
                normalGrid.region = 'center';
            }
            me.addCls(Ext.baseCSSPrefix + 'grid-locked-split');
        }
        if (!(me.layout instanceof Ext.layout.container.Box)) {
            me.split = false;
        }

        // The LockingView is a pseudo view which owns the two grids.
        // It listens for store events and relays the calls into each view bracketed by a layout suspension.
        me.view = new Ext.grid.locking.View({
            loadMask: loadMask,
            locked: lockedGrid,
            normal: normalGrid,
            ownerGrid: me
        });

        // after creating the locking view we now have Grid instances for both locked and
        // unlocked sides
        lockedGrid = me.lockedGrid;
        normalGrid = me.normalGrid;

        // View has to be moved back into the panel during float
        lockedGrid.on({
            beginfloat: me.onBeginLockedFloat,
            endfloat: me.onEndLockedFloat,
            scope: me
        });

        setWidth = lockedGrid.setWidth;
        // Intercept setWidth here so we can tell the difference between
        // our own calls to setWidth vs user calls
        lockedGrid.setWidth = function() {
            lockedGrid.shrinkWrapColumns = false;
            setWidth.apply(lockedGrid, arguments);
        };

        // Account for initially hidden columns, or user hide of columns in handlers called during grid construction
        if (!lockedGrid.getVisibleColumnManager().getColumns().length) {
            lockedGrid.hide();
        }
        if (!normalGrid.getVisibleColumnManager().getColumns().length) {
            normalGrid.hide();
        }

        // Extract the instantiated views from the locking View.
        // The locking View injects lockingGrid and normalGrid into this lockable panel.
        // This is because during constraction, it must be possible for descendant components
        // to navigate up to the owning lockable panel and then down into either side.

        lockedHeaderCt = lockedGrid.headerCt;
        normalHeaderCt = normalGrid.headerCt;

        // The top grid, and the LockingView both need to have a headerCt which is usable.
        // It is part of their private API that framework code uses when dealing with a grid or grid view
        me.headerCt = me.view.headerCt = new Ext.grid.locking.HeaderContainer(me);

        lockedHeaderCt.lockedCt = true;
        lockedHeaderCt.lockableInjected = true;
        normalHeaderCt.lockableInjected = true;

        lockedHeaderCt.on({
            add: me.delaySyncLockedWidth,
            remove: me.delaySyncLockedWidth,
            columnshow: me.delaySyncLockedWidth,
            columnhide: me.delaySyncLockedWidth,
            sortchange: me.onLockedHeaderSortChange,
            columnresize: me.delaySyncLockedWidth,
            scope: me
        });

        normalHeaderCt.on({
            add: me.delaySyncLockedWidth,
            remove: me.delaySyncLockedWidth,
            columnshow: me.delaySyncLockedWidth,
            columnhide: me.delaySyncLockedWidth,
            sortchange: me.onNormalHeaderSortChange,
            scope: me
        });

        me.modifyHeaderCt();
        me.items = [lockedGrid];
        if (me.split) {
            me.addCls(Ext.baseCSSPrefix + 'grid-locked-split');
            me.items[1] = Ext.apply({
                xtype: 'splitter'
            }, me.split);
        }
        me.items.push(normalGrid);

        me.relayHeaderCtEvents(lockedHeaderCt);
        me.relayHeaderCtEvents(normalHeaderCt);

        // The top level Lockable container does not get bound to the store, so we need to programatically add the relayer so that
        // The filterchange state event is fired.
        //
        // TreePanel also relays the beforeload and load events, so 
        me.storeRelayers = me.relayEvents(store, [
            /**
             * @event filterchange
             * @inheritdoc Ext.data.Store#filterchange
             */
            'filterchange',
            /**
             * @event groupchange
             * @inheritdoc Ext.data.Store#groupchange
             */
            'groupchange',
            /**
             * @event beforeload
             * @inheritdoc Ext.data.Store#beforeload
             */
            'beforeload',
            /**
             * @event load
             * @inheritdoc Ext.data.Store#load
             */
            'load'
        ]);

        // Only need to relay from the normalGrid. Since it's created after the lockedGrid,
        // we can be confident to only listen to it.
        me.gridRelayers = me.relayEvents(normalGrid, [
            /**
             * @event viewready
             * @inheritdoc Ext.panel.Table#viewready
             */
            'viewready'
        ]);
    },
    syncLockableHeaderVisibility: function() {
        var me = this,
            hideHeaders = me.hideHeaders,
            locked = this.lockedGrid,
            normal = this.normalGrid;
        
        if (hideHeaders === null) {
            hideHeaders = locked.shouldAutoHideHeaders() && normal.shouldAutoHideHeaders();
        }
        locked.hideHeaders = normal.hideHeaders = hideHeaders;
        locked.syncHeaderVisibility();
        normal.syncHeaderVisibility();
    },
    onBeginLockedFloat: function(locked) {
        var el = locked.getContentTarget().dom,
            lockedHeaderCt = this.lockedGrid.headerCt,
            normalHeaderCt = this.normalGrid.headerCt,
            headerCtHeight = Math.max(normalHeaderCt.getHeight(), lockedHeaderCt.getHeight());

        // The two layouts are seperated and no longer share stretchmax height data upon
        // layout, so for the duration of float, force them to be at least the current matching height.
        lockedHeaderCt.minHeight = headerCtHeight;
        normalHeaderCt.minHeight = headerCtHeight;

        locked.el.addCls(Ext.panel.Panel.floatCls);

        // Move view into the grid unless it's already there.
        // We fire a beginfloat event when expanding or collapsing from 
        // floated out state.
        if (el.firstChild !== locked.view.el.dom) {
            el.appendChild(locked.view.el.dom);
        }

        locked.body.dom.scrollTop = this.getScrollable().getPosition().y;
    },

    onEndLockedFloat: function() {
        var locked = this.lockedGrid;

        // The two headerCts are connected now, allow them to stretchmax each other
        if (locked.collapsed) {
            locked.el.removeCls(Ext.panel.Panel.floatCls);
        } else {
            this.lockedGrid.headerCt.minHeight = this.normalGrid.headerCt.minHeight = null;
        }
        this.lockedScrollbarClipper.appendChild(locked.view.el.dom);
        this.doSyncLockableLayout();
    },
    beforeLayout: function() {
        var me = this,
            lockedGrid = me.lockedGrid,
            normalGrid = me.normalGrid,
            totalColumnWidth;

        if (lockedGrid && normalGrid) {

            // The locked side of a grid, if it is shrinkwrapping fixed size columns, must take into
            // account the column widths plus the border widths of the grid element and the headerCt element.
            // This must happen at this late stage so that all relevant classes are added which affect
            // what borders are applied to what elements.
            if (lockedGrid.getSizeModel().width.shrinkWrap) {
                lockedGrid.gridPanelBorderWidth = lockedGrid.el.getBorderWidth('lr');
                lockedGrid.shrinkWrapColumns = true;
            }            
            if (lockedGrid.shrinkWrapColumns) {
                totalColumnWidth = lockedGrid.headerCt.getTableWidth();
                //<debug>
                if (isNaN(totalColumnWidth)) {
                    Ext.raise("Locked columns in an unsized locked side do NOT support a flex width.");
                }
                //</debug>
                lockedGrid.setWidth(totalColumnWidth + lockedGrid.gridPanelBorderWidth);
                // setWidth will clear shrinkWrapColumns, so force it again here
                lockedGrid.shrinkWrapColumns = true;
            }

            if (!me.scrollContainer) {
                me.initScrollContainer();
            }

            me.lastScrollPos = me.getScrollable().getPosition();

            // Undo margin styles set by afterLayout
            lockedGrid.view.el.setStyle('margin-bottom', '');
            normalGrid.view.el.setStyle('margin-bottom', '');
        }
    },

    syncLockableLayout: function() {
        var me = this;

        // This is called directly from child TableView#afterComponentLayout
        // So we might get two calls if both are visible, and both lay out.
        // Schedule a single sync on the tail end of the current layout.
        if (!me.afterLayoutListener) {
            me.afterLayoutListener = Ext.on({
                afterlayout: me.doSyncLockableLayout,
                scope: me,
                single: true
            });
        }
    },
    
    doSyncLockableLayout: function() {
        var me = this,
            collapseExpand = me.isCollapsingOrExpanding,
            lockedGrid = me.lockedGrid,
            normalGrid = me.normalGrid,
            lockedViewEl, normalViewEl, lockedViewRegion,
            normalViewRegion, scrollbarSize, scrollbarWidth, scrollbarHeight, normalViewWidth,
            normalViewX, hasVerticalScrollbar, hasHorizontalScrollbar,
            scrollContainerHeight, scrollBodyHeight, lockedScrollbar, normalScrollbar,
            scrollbarVisibleCls, scrollHeight, lockedGridVisible, normalGridVisible, scrollBodyDom,
            viewRegion, scrollerElHeight;

        me.afterLayoutListener = null;

        if (collapseExpand) {
            // Expand
            if (collapseExpand === 2) {
                me.on('expand', 'doSyncLockableLayout', me, {single: true});
            }
            return;
        }

        if (lockedGrid && normalGrid) {
            lockedGridVisible = lockedGrid.isVisible(true) && !lockedGrid.collapsed;
            normalGridVisible = normalGrid.isVisible(true);
            lockedViewEl = lockedGrid.view.el;
            normalViewEl = normalGrid.view.el;
            scrollBodyDom = me.scrollBody.dom;
            lockedViewRegion = lockedGridVisible ? lockedGrid.body.getRegion(true) : new Ext.util.Region(0, 0, 0, 0);
            normalViewRegion = normalGridVisible ? normalGrid.body.getRegion(true) : new Ext.util.Region(0, 0, 0, 0);
            scrollbarSize = Ext.getScrollbarSize();
            scrollbarWidth = scrollbarSize.width;
            scrollbarHeight = scrollerElHeight = scrollbarSize.height;
            normalViewWidth = normalGridVisible ? normalViewRegion.width : 0;
            normalViewX = lockedGridVisible ? (normalGridVisible ? normalViewRegion.x - lockedViewRegion.x : lockedViewRegion.width) : 0;
            hasHorizontalScrollbar = (normalGrid.headerCt.tooNarrow || lockedGrid.headerCt.tooNarrow) ? scrollbarHeight : 0;
            scrollContainerHeight = normalViewRegion.height || lockedViewRegion.height;
            scrollBodyHeight = scrollContainerHeight;
            lockedScrollbar = me.lockedScrollbar;
            normalScrollbar = me.normalScrollbar;
            scrollbarVisibleCls = me.scrollbarVisibleCls;
    
            // EXTJS-23301 IE10/11 does not allow an overflowing element to scroll
            // if the element height is the same as the scrollbar height. This
            // affects the horizontal normal scrollbar only as the vertical
            // scrollbar container will always have a width larger due to content.
            if (Ext.supports.CannotScrollExactHeight) {
                scrollerElHeight += 1;
            }

            if (hasHorizontalScrollbar) {
                lockedViewEl.setStyle('margin-bottom', -scrollbarHeight + 'px');
                normalViewEl.setStyle('margin-bottom', -scrollbarHeight + 'px');
                scrollBodyHeight -= scrollbarHeight;

                if (lockedGridVisible && lockedGrid.view.body.dom) {
                    me.lockedScrollbarScroller.setSize({x: lockedGrid.headerCt.getTableWidth()});
                }
                if (normalGrid.view.body.dom) {
                    me.normalScrollbarScroller.setSize({x: normalGrid.headerCt.getTableWidth()});
                }
            }
            me.scrollBody.setHeight(scrollBodyHeight);

            lockedViewEl.dom.style.height = normalViewEl.dom.style.height = '';
            scrollHeight = (me.scrollable.getSize().y + hasHorizontalScrollbar);
            normalGrid.view.stretchHeight(scrollHeight);
            lockedGrid.view.stretchHeight(scrollHeight);

            hasVerticalScrollbar = scrollbarWidth &&
                scrollBodyDom.scrollHeight > scrollBodyDom.clientHeight;
            if (hasVerticalScrollbar && normalViewWidth) {
                normalViewWidth -= scrollbarWidth;
                normalViewEl.setStyle('width', normalViewWidth + 'px');
            }

            lockedScrollbar.toggleCls(scrollbarVisibleCls, lockedGridVisible && !!hasHorizontalScrollbar);
            normalScrollbar.toggleCls(scrollbarVisibleCls, !!hasHorizontalScrollbar);

            // Floated from collapsed views must overlay. THis raises them up.
            me.normalScrollbarClipper.toggleCls(me.scrollbarClipperCls + '-floated', !!me.normalGrid.floatedFromCollapse);
            me.normalScrollbar.toggleCls(me.scrollbarCls + '-floated', !!me.normalGrid.floatedFromCollapse);
            me.lockedScrollbarClipper.toggleCls(me.scrollbarClipperCls + '-floated', !!me.lockedGrid.floatedFromCollapse);
            me.lockedScrollbar.toggleCls(me.scrollbarCls + '-floated', !!me.lockedGrid.floatedFromCollapse);

            lockedScrollbar.setSize(me.lockedScrollbarClipper.dom.offsetWidth, scrollerElHeight);
            normalScrollbar.setSize(normalViewWidth, scrollerElHeight);

            me.setNormalScrollerX(normalViewX);

            if (lockedGridVisible && normalGridVisible) {
                viewRegion = lockedViewRegion.union(normalViewRegion);
            } else if (lockedGridVisible) {
                viewRegion = lockedViewRegion;
            } else {
                viewRegion = normalViewRegion;
            }

            me.scrollContainer.setBox(viewRegion);

            me.onSyncLockableLayout(hasVerticalScrollbar, viewRegion.width);

            me.getScrollable().scrollTo(me.lastScrollPos);
        }
    },

    onSyncLockableLayout: Ext.emptyFn,

    setNormalScrollerX: function(x) {
        this.normalScrollbar.setLocalX(x);
        this.normalScrollbarClipper.setLocalX(x);
    },

    getScrollExtraCls: function() {
        return '';
    },

    initScrollContainer: function() {
        var me = this,
            extraCls = me.getScrollExtraCls(),
            scrollContainer = me.scrollContainer = me.body.insertFirst({
                cls: [me.scrollContainerCls, extraCls]
            }),
            scrollBody = me.scrollBody = scrollContainer.appendChild({
                cls: me.scrollBodyCls
            }),
            lockedScrollbar = me.lockedScrollbar = scrollContainer.appendChild({
                cls: [me.scrollbarCls, me.scrollbarCls + '-locked', extraCls]
            }),
            normalScrollbar = me.normalScrollbar = scrollContainer.appendChild({
                cls: [me.scrollbarCls, extraCls]
            }),
            lockedView = me.lockedGrid.view,
            normalView = me.normalGrid.view,
            lockedScroller = lockedView.getScrollable(),
            normalScroller = normalView.getScrollable(),
            Scroller = Ext.scroll.Scroller,
            lockedScrollbarScroller, normalScrollbarScroller, lockedScrollbarClipper,
            normalScrollbarClipper;

        lockedView.stretchHeight(0);
        normalView.stretchHeight(0);

        me.scrollable.setConfig({
            element: scrollBody,
            lockedScroller: lockedScroller,
            normalScroller: normalScroller
        });

        lockedScrollbarClipper = me.lockedScrollbarClipper = scrollBody.appendChild({
            cls: [me.scrollbarClipperCls, me.scrollbarClipperCls + '-locked', extraCls]
        });

        normalScrollbarClipper = me.normalScrollbarClipper = scrollBody.appendChild({
            cls: [me.scrollbarClipperCls, extraCls]
        });

        lockedScrollbarClipper.appendChild(lockedView.el);
        normalScrollbarClipper.appendChild(normalView.el);

        // We just moved the view elements into a containing element that is not the same
        // as their container's target element (grid body).  Setting the ignoreDomPosition
        // flag instructs the layout system not to move them back.
        lockedView.ignoreDomPosition = true;
        normalView.ignoreDomPosition = true;

        lockedScrollbarScroller = me.lockedScrollbarScroller = new Scroller({
            element: lockedScrollbar,
            x: 'scroll',
            y: false,
            rtl: lockedScroller.getRtl && lockedScroller.getRtl()
        });

        normalScrollbarScroller = me.normalScrollbarScroller = new Scroller({
            element: normalScrollbar,
            x: 'scroll',
            y: false,
            rtl: normalScroller.getRtl && normalScroller.getRtl()
        });

        me.initScrollers();

        lockedScrollbarScroller.addPartner(lockedScroller, 'x');
        normalScrollbarScroller.addPartner(normalScroller, 'x');

        // Tell the lockable.View that it has been rendered.
        me.view.onPanelRender(scrollBody);
    },

    initScrollers: Ext.emptyFn,
    syncLockedWidth: function() {
        var me = this,
            rendered = me.rendered,
            locked = me.lockedGrid,
            normal = me.normalGrid,
            lockedColCount = locked.getVisibleColumnManager().getColumns().length,
            normalColCount = normal.getVisibleColumnManager().getColumns().length,
            task = me.syncLockedWidthTask;

        // If we are called directly, veto any existing task.
        if (task) {
            task.cancel();
        }
        if (me.reconfiguring) {
            return;
        }

        Ext.suspendLayouts();

        // If there are still visible normal columns, then the normal grid will flex
        // while we effectively shrinkwrap the width of the locked columns
        if (normalColCount) {
            normal.show();
            if (lockedColCount) {

                // Revert locked grid to original region now it's not the only child grid.
                if (me.layout.type === 'border') {
                    locked.region = locked.initialConfig.region;
                }
                // The locked grid shrinkwraps the total column width while the normal grid flexes in what remains
                // UNLESS it has been set to forceFit
                if (rendered && locked.shrinkWrapColumns && !locked.headerCt.forceFit) {
                    delete locked.flex;
                    // Just set the property here and update the layout.
                    // Size settings assume it's NOT the layout root.
                    // If the locked has been floated, it might well be!
                    // Use gridPanelBorderWidth as measured in Ext.grid.ColumnLayout#beginLayout
                    // TODO: Use shrinkWrapDock on the locked grid when it works.
                    locked.width = locked.headerCt.getTableWidth() + locked.gridPanelBorderWidth;
                    locked.updateLayout();
                }
                locked.addCls(me.lockedGridCls);
                locked.show();
                if (locked.split) {
                    me.child('splitter').show();
                    me.addCls(Ext.baseCSSPrefix + 'grid-locked-split');
                }
            } else {
                // Hide before clearing to avoid DOM layout from clearing
                // the content and to avoid scroll syncing. TablePanel
                // disables scroll syncing on hide.
                locked.hide();

                // No visible locked columns: hide the locked grid
                // We also need to trigger a clearViewEl to clear out any
                // old dom nodes
                if (rendered) {
                    locked.getView().clearViewEl(true);
                }
                if (locked.split) {
                    me.child('splitter').hide();
                    me.removeCls(Ext.baseCSSPrefix + 'grid-locked-split');
                }
            }
        }

        // There are no normal grid columns. The "locked" grid has to be *the*
        // grid, and cannot have a shrinkwrapped width, but must flex the entire width.
        else {
            normal.hide();

            // The locked now becomes *the* grid and has to flex to occupy the full view width
            delete locked.width;
            if (me.layout.type === 'border') {
                locked.region = 'center';
                normal.region = 'west';
            } else {
                locked.flex = 1;
            }
            locked.removeCls(me.lockedGridCls);
            locked.show();
        }
        Ext.resumeLayouts(true);

        // Flag object indicating which views need to be cleared and refreshed.
        return {
            locked: !!lockedColCount,
            normal: !!normalColCount
        };
    }/*,
     lock: function(activeHd, toIdx, toCt) {
        var me         = this,
            normalGrid = me.normalGrid,
            lockedGrid = me.lockedGrid,
            normalView = normalGrid.view,
            lockedView = lockedGrid.view,
            normalScroller = normalView.getScrollable(),
            lockedScroller = lockedView.getScrollable(),
            normalHCt  = normalGrid.headerCt,
            refreshFlags,
            ownerCt, lbr;
		layoutCount = me.componentLayoutCounter;
        activeHd = activeHd || normalHCt.getMenu().activeHeader;
        activeHd.unlockedWidth = activeHd.width;

        // If moving a flexed header back into a side where we can't know
        // whether the flex value will be invalid, revert it either to
        // its original width or actual width.
        if (activeHd.flex) {
            if (activeHd.lockedWidth) {
                activeHd.width = activeHd.lockedWidth;
                activeHd.lockedWidth = null;
            } else {
                activeHd.width = activeHd.lastBox.width;
            }
            activeHd.flex = null;
        }
        toCt = toCt || lockedGrid.headerCt;
        ownerCt = activeHd.ownerCt;

        // isLockable will test for making the locked side too wide.
        // The header we're locking may be to be added, and have no ownerCt.
        // For instance, a checkbox column being moved into the correct side
        if (ownerCt && !activeHd.isLockable()) {
            return;
        }

        Ext.suspendLayouts();
        if (normalScroller) {
            normalScroller.suspendPartnerSync();
            lockedScroller.suspendPartnerSync();
        }

        // If hidden, we need to show it now or the locked headerCt's VisibleColumnManager may be out of sync as
        // headers are only added to a visible manager if they are not explicity hidden or hierarchically hidden.
        if (lockedGrid.hidden) {

            // The locked side's BufferedRenderer has never has a resize passed in, so its viewSize will be the default
            // viewSize, out of sync with the normal side. Synchronize the viewSize before the two sides are refreshed.
            if (!lockedGrid.componentLayoutCounter) {
                lockedGrid.height = normalGrid.lastBox.height;
                lbr = lockedView.bufferedRenderer;
                if (lbr) {
                    lbr.rowHeight = normalView.bufferedRenderer.rowHeight;
                    lbr.onViewResize(lockedView, 0, normalGrid.body.lastBox.height);
                }
            }
            lockedGrid.show();
        }

        // TablePanel#onHeadersChanged does not respond if reconfiguring set.
        // We programatically refresh views which need it below.
        lockedGrid.reconfiguring = normalGrid.reconfiguring = true;

        // Keep the column in the hierarchy during the move.
        // So that grid.isAncestor(column) still returns true, and SpreadsheetModel does not deselect
        activeHd.ownerCmp = activeHd.ownerCt;

        activeHd.locked = true;

        // Flag to the locked column add listener to do nothing
        if (Ext.isDefined(toIdx)) {
            toCt.insert(toIdx, activeHd);
        } else {
            toCt.add(activeHd);
        }
        lockedGrid.reconfiguring = normalGrid.reconfiguring = false;

        activeHd.ownerCmp = null;

        refreshFlags = me.syncLockedWidth();

        // Clear both views first so that any widgets are cached
        // before reuse. If we refresh the grid which just had a widget column added
        // first, the clear of the view which had the widget column in removes the widgets
        // from their new place.
        if (refreshFlags.locked) {
            lockedView.clearViewEl(true);
        }
        if (refreshFlags.normal) {
            normalView.clearViewEl(true);
        }

        // Refresh locked view second, so that if it's refreshing from empty (can start with no locked columns),
        // the buffered renderer can look to its partner to get the correct range to refresh.
        normalGrid.getView().refreshNeeded = refreshFlags.normal;
        lockedGrid.getView().refreshNeeded = refreshFlags.locked;
        activeHd.onLock(activeHd);
        me.fireEvent('lockcolumn', me, activeHd);
        Ext.resumeLayouts(true);
        if (normalScroller) {
            normalScroller.resumePartnerSync(true);
            lockedScroller.resumePartnerSync();
        }
        if (me.componentLayoutCounter === layoutCount) {
            me.syncLockableLayout();
        }
    } ,  
    unlock: function(activeHd, toIdx, toCt) {
        var me         = this,
            normalGrid = me.normalGrid,
            lockedGrid = me.lockedGrid,
            normalView = normalGrid.view,
            lockedView = lockedGrid.view,
            startIndex = normalView.all.startIndex,
            lockedHCt  = lockedGrid.headerCt,
            refreshFlags;
			layoutCount = me.componentLayoutCounter;
        // Unlocking; user expectation is that the unlocked column is inserted at the beginning.
        if (!Ext.isDefined(toIdx)) {
            toIdx = 0;
        }
        activeHd = activeHd || lockedHCt.getMenu().activeHeader;
        activeHd.lockedWidth = activeHd.width;

        // If moving a flexed header back into a side where we can't know
        // whether the flex value will be invalid, revert it either to
        // its original width or actual width.
        if (activeHd.flex) {
            if (activeHd.unlockedWidth) {
                activeHd.width = activeHd.unlockedWidth;
                activeHd.unlockedWidth = null;
            } else {
                activeHd.width = activeHd.lastBox.width;
            }
            activeHd.flex = null;
        }
        toCt = toCt || normalGrid.headerCt;

        Ext.suspendLayouts();

        // TablePanel#onHeadersChanged does not respond if reconfiguring set.
        // We programatically refresh views which need it below.
        lockedGrid.reconfiguring = normalGrid.reconfiguring = true;

        // Keep the column in the hierarchy during the move.
        // So that grid.isAncestor(column) still returns true, and SpreadsheetModel does not deselect
        activeHd.ownerCmp = activeHd.ownerCt;

        if (activeHd.ownerCt) {
            activeHd.ownerCt.remove(activeHd, false);
        }
        activeHd.locked = false;
        toCt.insert(toIdx, activeHd);
        lockedGrid.reconfiguring = normalGrid.reconfiguring = false;

        activeHd.ownerCmp = null;

        // syncLockedWidth returns visible column counts for both grids.
        // only refresh what needs refreshing
        refreshFlags = me.syncLockedWidth();

        // Clear both views first so that any widgets are cached
        // before reuse. If we refresh the grid which just had a widget column added
        // first, the clear of the view which had the widget column in removes the widgets
        // from their new place.
        if (refreshFlags.locked) {
            lockedView.clearViewEl(true);
        }
        if (refreshFlags.normal) {
            normalView.clearViewEl(true);
        }

        // Refresh locked view second, so that if it's refreshing from empty (can start with no locked columns),
        // the buffered renderer can look to its partner to get the correct range to refresh.
        if (refreshFlags.normal) {
            normalGrid.getView().refreshView(startIndex);
        }
        if (refreshFlags.locked) {
            lockedGrid.getView().refreshView(startIndex);
        }
        activeHd.onUnlock(activeHd);
        me.fireEvent('unlockcolumn', me, activeHd);
        Ext.resumeLayouts(true);
        if (me.componentLayoutCounter === layoutCount) {
            me.syncLockableLayout();
        }
    }*/
});

//## 6.2.2.475
Ext.override(Ext.grid.locking.HeaderContainer, {
	applyColumnsState: function (columnsState, storeState) {
        var me             = this,
            lockedGrid     = me.lockable.lockedGrid,
            normalGrid     = me.lockable.normalGrid,
            lockedHeaderCt = lockedGrid.headerCt,
            normalHeaderCt = me.lockable.normalGrid.headerCt,
            columns        = lockedHeaderCt.items.items.concat(normalHeaderCt.items.items),
            length         = columns.length,
            i, colState, column, lockedCount, switchSides;

        // Loop through the column set, applying state from the columnsState object.
        // Columns which have their "locked" property changed must be added to the appropriate
        // headerCt.
        for (i = 0; i < length; i++) {
            column = columns[i];
            colState = columnsState[column.getStateId()];
            if (colState) {

                // See if the state being applied needs to cause column movement
                // Coerce possibly absent locked config to boolean.
                switchSides = colState.locked != null && !!column.locked !== colState.locked;

                if (column.applyColumnState) {
                    column.applyColumnState(colState, storeState);
                }

                // If the column state means it has to change sides
                // move the column to the other side
                if (switchSides) {
                    (column.locked ? lockedHeaderCt : normalHeaderCt).add(column);
                }
            }
        }
        lockedCount = lockedHeaderCt.items.items.length;

        // We must now restore state in each side's HeaderContainer.
        // This means passing the state down into each side's applyColumnState
        // to get sortable, hidden and width states restored.
        // We must ensure that the index on the normal side is zero based.
        for (i = 0; i < length; i++) {
            column = columns[i];
            colState = columnsState[column.getStateId()];
            if (colState && !column.locked) {
                colState.index -= lockedCount;
            }
        }

        // Each side must apply individual column's state
        lockedHeaderCt.applyColumnsState(columnsState, storeState);
        normalHeaderCt.applyColumnsState(columnsState, storeState);

        // Account for columns being hidden or moved by state application.
        if (!lockedGrid.getVisibleColumnManager().getColumns().length) {
            lockedGrid.hide();
        }

        if (!normalGrid.getVisibleColumnManager().getColumns().length) {
            normalGrid.hide();
        }
    }
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
//## 6.2.2.475
Ext.override(Ext.scroll.LockingScroller, {
	updateTouchAction: function(touchAction, oldTouchAction) {
        this.callParent([touchAction, oldTouchAction]);

        this.getLockedScroller().setTouchAction(touchAction);
        this.getNormalScroller().setTouchAction(touchAction);
    }
});
////## 6.2.2.475
//Ext.override(Ext.grid.locking.Lockable, {});
Ext.override(Ext.grid.feature.Summary, {
	 toggleSummaryRow: function(visible, fromLockingPartner) {
	 	
	 	
        var me = this,
            bar = me.summaryBar;
		if (me.lockingPartner) {
			 me.callParent([visible, fromLockingPartner]);
		}
        if (bar) {
            bar.setVisible(me.showSummaryRow);
        }
    }
});
//checkbox model whitespace 오류
Ext.override(Ext.selection.CheckboxModel, {
	getHeaderConfig: function() {
        var me = this,
            showCheck = me.showHeaderCheckbox !== false,
            htmlEncode = Ext.String.htmlEncode,
            config;
        config = {
            xtype: 'checkcolumn',
            headerCheckbox: showCheck,
            isCheckerHd: showCheck,
            // historically used as a dicriminator property before isCheckColumn
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
            tdCls: me.tdCls,
            cls: Ext.baseCSSPrefix + 'selmodel-column',
            editRenderer: me.editRenderer || me.renderEmpty,
            locked: me.hasLockedHeader(),
            processEvent: me.processColumnEvent,
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
            //config.ariaRole = 'presentation'; 
            config.focusable = false;
            config.cellFocusable = false;
        } else {
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
//HtmlEditor 오류, 20201221 주석: 화면 오픈 시, 오류 발생
Ext.override(Ext.form.field.HtmlEditor, {
syncValue: function(){
        var me = this,
            body, changed, html, bodyStyle, match, textElDom;

        if (me.initialized) {
            body = me.getEditorBody();
            html = body.innerHTML;
            textElDom = me.textareaEl.dom;

            if (Ext.isWebKit) {
                bodyStyle = body.getAttribute('style'); // Safari puts text-align styles on the body element!
                if(bodyStyle) {							//20201210 추가
	                match = bodyStyle.match(me.textAlignRE);
	                if (match && match[1]) {
	                    html = '<div style="' + match[0] + '">' + html + '</div>';
	                }
                }
            }

            html = me.cleanHtml(html);

            if (me.fireEvent('beforesync', me, html) !== false) {
                // Gecko inserts single <br> tag when input is empty
                // and user toggles source mode. See https://sencha.jira.com/browse/EXTJSIV-8542
                if (Ext.isGecko && textElDom.value === '' && html === '<br>') {
                    html = '';
                }

                if (textElDom.value !== html) {
                    textElDom.value = html;
                    changed = true;
                }

                me.fireEvent('sync', me, html);

                if (changed) {
                    // we have to guard this to avoid infinite recursion because getValue
                    // calls this method...
                    me.checkChange();
                }
            }
        }
    }
});

//mouse drag 시  summary record에 mouseenter 시 record가 null 이므로 에러발쌩
/*
Ext.override(Ext.grid.feature.GroupStore, {
	indexOf: function(record) {
      var ret = -1;
      if (record && !record.isCollapsedPlaceholder) {
          ret = this.data.indexOf(record);
      } else {
      	ret = this.data.length
      }
      return ret;
  },
});*/