//@charset UTF-8
/**
 * ExtJS bug overrides
 * currentVersion : 5.1.0.107
 */

/**
 * EXTJS-16166 - Unable to use home/end/arrow navigation keys inside data views & grid editors.
 */
Ext.define('Ext.overrides.view.View', {
    override: 'Ext.view.View',
    compatibility: '5.1.0.107',
    handleEvent: function(e) {
        var me = this,
            isKeyEvent = me.keyEventRe.test(e.type),
            nm = me.getNavigationModel();

        e.view = me;
        
        if (isKeyEvent) {
            e.item = nm.getItem();
            e.record = nm.getRecord();
        }

        // If the key event was fired programatically, it will not have triggered the focus
        // so the NavigationModel will not have this information.
        if (!e.item) {
            e.item = e.getTarget(me.itemSelector);
        }
        if (e.item && !e.record) {
            e.record = me.getRecord(e.item);
        }

        if (me.processUIEvent(e) !== false) {
            me.processSpecialEvent(e);
        }
        
        // We need to prevent default action on navigation keys
        // that can cause View element scroll unless the event is from an input field.
        // We MUST prevent browser's default action on SPACE which is to focus the event's target element.
        // Focusing causes the browser to attempt to scroll the element into view.
        
        if (isKeyEvent && !Ext.fly(e.target).isInputField()) {
            if (e.getKey() === e.SPACE || e.isNavKeyPress(true)) {
                e.preventDefault();
            }
        }
    }
});

/**
 * EXTJS-15525 - Syncing of newly client-side created records with a server results in the new record being permanently selected
 */
Ext.define('Ext.overrides.util.Collection', {
    override: 'Ext.util.Collection',
    compatibility: '5.1.0.107',

    updateKey: function (item, oldKey) {
        var me = this,
            map = me.map,
            indices = me.indices,
            source = me.getSource(),
            newKey;

        if (source && !source.updating) {
            // If we are being told of the key change and the source has the same idea
            // on keying the item, push the change down instead.
            source.updateKey(item, oldKey);
        }
        // If there *is* an existing item by the oldKey and the key yielded by the new item is different from the oldKey...
        else if (map[oldKey] && (newKey = me.getKey(item)) !== oldKey) {
            if (oldKey in map || map[newKey] !== item) {
                if (oldKey in map) {
                    //<debug>
                    if (map[oldKey] !== item) {
                        Ext.Error.raise('Incorrect oldKey "' + oldKey +
                                        '" for item with newKey "' + newKey + '"');
                    }
                    //</debug>

                    delete map[oldKey];
                }

                // We need to mark ourselves as updating so that observing collections
                // don't reflect the updateKey back to us (see above check) but this is
                // not really a normal update cycle so we don't call begin/endUpdate.
                me.updating++;

                me.generation++;
                map[newKey] = item;
                if (indices) {
                    indices[newKey] = indices[oldKey];
                    delete indices[oldKey];
                }

                me.notify('updatekey', [{
                    item: item,
                    newKey: newKey,
                    oldKey: oldKey
                }]);

                me.updating--;
            }
        }
    }
});

/**
 * EXTJS-16164 CheckboxModel selectionchange, deselect doesn't fire when user unselect row
 */
Ext.define('Ext.overrides.selection.CheckboxModel', {
    override: 'Ext.selection.CheckboxModel',
    privates: {
        selectWithEventMulti: function(record, e, isSelected) {
            var me = this;

            if (!e.shiftKey && !e.ctrlKey && e.getTarget(me.checkSelector)) {
                if (isSelected) {
                    me.doDeselect(record); // Second param here is suppress event, not "keep selection"
                } else {
                    me.doSelect(record, true);
                }
            } else {
                me.callParent([record, e, isSelected]);
            }
        }
    }
});

/**
 * EXTJS-16046 Date Field Loses Focus When Selecting Month/Year Picker
 * (일)달력에서 년/월 선택 시 선택이 안되는 문제
 * 내일 버튼 추가함 (2015.09.14)
 */Ext.define('Ext.overrides.picker.Date', {
    override: 'Ext.picker.Date',

    yesterdayText:'어제',
    
    renderTpl: [
        '<div id="{id}-innerEl" data-ref="innerEl">',
            '<div class="{baseCls}-header">',
                '<div id="{id}-prevEl" data-ref="prevEl" class="{baseCls}-prev {baseCls}-arrow" role="button" title="{prevText}"></div>',
                '<div id="{id}-middleBtnEl" data-ref="middleBtnEl" class="{baseCls}-month" role="heading">{%this.renderMonthBtn(values, out)%}</div>',
                '<div id="{id}-nextEl" data-ref="nextEl" class="{baseCls}-next {baseCls}-arrow" role="button" title="{nextText}"></div>',
            '</div>',
            '<table role="grid" id="{id}-eventEl" data-ref="eventEl" class="{baseCls}-inner" {%',
                // If the DatePicker is focusable, make its eventEl tabbable.
                // Note that we're looking at the `focusable` property because
                // calling `isFocusable()` will always return false at that point
                // as the picker is not yet rendered.
                'if (values.$comp.focusable) {out.push("tabindex=\\\"0\\\"");}',
            '%} cellspacing="0">',
                '<thead><tr role="row">',
                    '<tpl for="dayNames">',
                        '<th role="columnheader" class="{parent.baseCls}-column-header" aria-label="{.}">',
                            '<div role="presentation" class="{parent.baseCls}-column-header-inner">{.:this.firstInitial}</div>',
                        '</th>',
                    '</tpl>',
                '</tr></thead>',
                '<tbody><tr role="row">',
                    '<tpl for="days">',
                        '{#:this.isEndOfWeek}',
                        '<td role="gridcell">',
                            '<div hidefocus="on" class="{parent.baseCls}-date"></div>',
                        '</td>',
                    '</tpl>',
                '</tr></tbody>',
            '</table>',
            '<tpl if="showToday">',
                '<div id="{id}-footerEl" data-ref="footerEl" role="presentation" class="{baseCls}-footer">{%this.renderTodayBtn(values, out)%}&nbsp;{%this.renderYesterdayBtn(values, out)%}</div>',
            '</tpl>',
        '</div>',
        {
            firstInitial: function(value) {
                return Ext.picker.Date.prototype.getDayInitial(value);
            },
            isEndOfWeek: function(value) {
                // convert from 1 based index to 0 based
                // by decrementing value once.
                value--;
                var end = value % 7 === 0 && value !== 0;
                return end ? '</tr><tr role="row">' : '';
            },
            renderTodayBtn: function(values, out) {
                Ext.DomHelper.generateMarkup(values.$comp.todayBtn.getRenderTree(), out);
            },
            renderMonthBtn: function(values, out) {
                Ext.DomHelper.generateMarkup(values.$comp.monthBtn.getRenderTree(), out);
            },
            renderYesterdayBtn: function(values, out) {
                Ext.DomHelper.generateMarkup(values.$comp.yesterdayBtn.getRenderTree(), out);
            }
        }
    ],
    
    yesterdayTip: '{0} (Spacebar)',
    
    getRefItems: function() {
        var results = [],
            monthBtn = this.monthBtn,
            todayBtn = this.todayBtn;
            yesterdayBtn = this.yesterdayBtn;

        if (monthBtn) {
            results.push(monthBtn);
        }

        if (todayBtn) {
            results.push(todayBtn);
        }
        
        if (yesterdayBtn) {
            results.push(yesterdayBtn);
        }
        return results;
    },
    
   
    beforeRender: function() {
        /*
         * days array for looping through 6 full weeks (6 weeks * 7 days)
         * Note that we explicitly force the size here so the template creates
         * all the appropriate cells.
         */
        var me = this,
            days = new Array(me.numDays),
            today = Ext.Date.format(new Date(), me.format);
			yesterday = Ext.Date.format(Ext.Date.add(new Date(),  Ext.Date.DAY, -1), me.format);

        if (me.padding && !me.width) {
            me.cacheWidth();
        }

        me.monthBtn = new Ext.button.Split({
            ownerCt: me,
            ownerLayout: me.getComponentLayout(),
            text: '',
            tooltip: me.monthYearText,
            listeners: {
                click: me.doShowMonthPicker,
                arrowclick: me.doShowMonthPicker,
                scope: me
            },
            
            // OVERRIDE
            onMouseDown: me.onButtonMouseDown
        });

        if (me.showToday) {
            me.todayBtn = new Ext.button.Button({
                ownerCt: me,
                ownerLayout: me.getComponentLayout(),
                text: Ext.String.format(me.todayText, today),
                tooltip: Ext.String.format(me.todayTip, today),
                tooltipType: 'title',
                handler: me.selectToday,
                scope: me,

                // OVERRIDE
                onMouseDown: me.onButtonMouseDown
            });
            
            me.yesterdayBtn = new Ext.button.Button({
                ownerCt: me,
                ownerLayout: me.getComponentLayout(),
                text: Ext.String.format(me.yesterdayText, yesterday),
                tooltip: Ext.String.format(me.yesterdayTip, yesterday),
                tooltipType: 'title',
                handler: me.selectYesterday,
                scope: me,
                onMouseDown: me.onButtonMouseDown
            });
			
        
        }
        
        // OVERRIDE
        // me.callParent();
        me.callSuper();

        Ext.applyIf(me, {
            renderData: {}
        });

        Ext.apply(me.renderData, {
            dayNames: me.dayNames,
            showToday: me.showToday,
            prevText: me.prevText,
            nextText: me.nextText,
            days: days
        });

        me.protoEl.unselectable();
        me.on('afterrender', me._onAfterRender, me);
        
    },
    
    // Override : new function to handle picker buttons' mousedown event
    onButtonMouseDown : function(e) {
        if (!this.ownerCt.focusable) {
            e.preventDefault();
        }
    },

    createMonthPicker: function() {
        var me = this,
            picker = me.monthPicker;

        if (!picker) {
            me.monthPicker = picker = new Ext.picker.Month({
                renderTo: me.el,
                // We need to set the ownerCmp so that owns() can correctly
                // match up the component hierarchy so that focus does not leave
                // an owning picker field if/when this gets focus.
                ownerCmp: me,
                floating: true,

                // OVERRIDE
                focusable: me.focusable,
                
                padding: me.padding,
                shadow: false,
                small: me.showToday === false,
                listeners: {
                    scope: me,
                    cancelclick: me.onCancelClick,
                    okclick: me.onOkClick,
                    yeardblclick: me.onOkClick,
                    monthdblclick: me.onOkClick
                }
            });
            if (!me.disableAnim) {
                // hide the element if we're animating to prevent an initial flicker
                picker.el.setStyle('display', 'none');
            }
            picker.hide();
            me.on('beforehide', me.doHideMonthPicker, me);
        }
        return picker;
    },
    fullUpdate: function(date) {
        var me = this,
            cells = me.cells.elements,
            textNodes = me.textNodes,
            disabledCls = me.disabledCellCls,
            eDate = Ext.Date,
            i = 0,
            extraDays = 0,
            newDate = +eDate.clearTime(date, true),
            today = +eDate.clearTime(new Date()),
            yesterday = +eDate.clearTime(Ext.Date.add(new Date(),  Ext.Date.DAY, -1)),
            min = me.minDate ? eDate.clearTime(me.minDate, true) : Number.NEGATIVE_INFINITY,
            max = me.maxDate ? eDate.clearTime(me.maxDate, true) : Number.POSITIVE_INFINITY,
            ddMatch = me.disabledDatesRE,
            ddText = me.disabledDatesText,
            ddays = me.disabledDays ? me.disabledDays.join('') : false,
            ddaysText = me.disabledDaysText,
            format = me.format,
            days = eDate.getDaysInMonth(date),
            firstOfMonth = eDate.getFirstDateOfMonth(date),
            startingPos = firstOfMonth.getDay() - me.startDay,
            previousMonth = eDate.add(date, eDate.MONTH, -1),
            ariaTitleDateFormat = me.ariaTitleDateFormat,
            prevStart, current, disableToday, tempDate, setCellClass, html, cls,
            formatValue, value;

        if (startingPos < 0) {
            startingPos += 7;
        }

        days += startingPos;
        prevStart = eDate.getDaysInMonth(previousMonth) - startingPos;
        current = new Date(previousMonth.getFullYear(), previousMonth.getMonth(), prevStart, me.initHour);

        if (me.showToday) {
            tempDate = eDate.clearTime(new Date());
            disableToday = (tempDate < min || tempDate > max ||
                (ddMatch && format && ddMatch.test(eDate.dateFormat(tempDate, format))) ||
                (ddays && ddays.indexOf(tempDate.getDay()) != -1));

            if (!me.disabled) {
                me.todayBtn.setDisabled(disableToday);
                me.yesterdayBtn.setDisabled(disableToday)
            }
        }

        setCellClass = function(cellIndex, cls){
            var cell = cells[cellIndex];
            
            value = +eDate.clearTime(current, true);
            cell.setAttribute('aria-label', eDate.format(current, ariaTitleDateFormat));
            // store dateValue number as an expando
            cell.firstChild.dateValue = value;
            if (value == today) {
                cls += ' ' + me.todayCls;
                cell.firstChild.title = me.todayText;
                
                // Extra element for ARIA purposes
                me.todayElSpan = Ext.DomHelper.append(cell.firstChild, {
                    tag: 'span',
                    cls: Ext.baseCSSPrefix + 'hidden-clip',
                    html: me.todayText
                }, true);
            }
            if (value == newDate) {
                me.activeCell = cell;
                me.eventEl.dom.setAttribute('aria-activedescendant', cell.id);
                cell.setAttribute('aria-selected', true);
                cls += ' ' + me.selectedCls;
                me.fireEvent('highlightitem', me, cell);
            } else {
                cell.setAttribute('aria-selected', false);
            }

            if (value < min) {
                cls += ' ' + disabledCls;
                cell.setAttribute('aria-label', me.minText);
            }
            else if (value > max) {
                cls += ' ' + disabledCls;
                cell.setAttribute('aria-label', me.maxText);
            }
            else if (ddays && ddays.indexOf(current.getDay()) !== -1){
                cell.setAttribute('aria-label', ddaysText);
                cls += ' ' + disabledCls;
            }
            else if (ddMatch && format){
                formatValue = eDate.dateFormat(current, format);
                if(ddMatch.test(formatValue)){
                    cell.setAttribute('aria-label', ddText.replace('%0', formatValue));
                    cls += ' ' + disabledCls;
                }
            }
            cell.className = cls + ' ' + me.cellCls;
        };

        for(; i < me.numDays; ++i) {
            if (i < startingPos) {
                html = (++prevStart);
                cls = me.prevCls;
            } else if (i >= days) {
                html = (++extraDays);
                cls = me.nextCls;
            } else {
                html = i - startingPos + 1;
                cls = me.activeCls;
            }
            textNodes[i].innerHTML = html;
            current.setDate(current.getDate() + 1);
            setCellClass(i, cls);
        }

        me.monthBtn.setText(Ext.Date.format(date, me.monthYearFormat));

        
    },
    selectYesterday: function() {
        var me = this,
            btn = me.yesterdayBtn,
            handler = me.handler;

        if (btn && !btn.disabled) {
            me.setValue(Ext.Date.clearTime(Ext.Date.add(new Date(), Ext.Date.DAY, -1)));
            me.fireEvent('select', me, me.value);
            if (handler) {
                handler.call(me.scope || me, me, me.value);
            }
            me.onSelect();
        }
        return me;
    },
    
    update: function(date, forceRefresh) {
        var me = this,
            active = me.activeDate;

        if (me.rendered) {
        		    
		    
            me.activeDate = date;
            if(!forceRefresh && active && me.el && active.getMonth() == date.getMonth() && active.getFullYear() == date.getFullYear()){
                me.selectedUpdate(date, active);
            } else {
                me.fullUpdate(date, active);
                
            }
            
        }
        return me;
    },
    beforeDestroy: function() {
        var me = this;

        if (me.rendered) {
            Ext.destroy(
                me.keyNav,
                me.monthPicker,
                me.monthBtn,
                me.nextRepeater,
                me.prevRepeater,
                me.todayBtn,
                me.yesterdayBtn,
                me.todayElSpan
            );
            delete me.textNodes;
            delete me.cells.elements;
        }
        me.callParent();
    },
     _onAfterRender:function(cmp)	{
     	 if(Ext.isDefined(cmp.yesterdayBtn) && Ext.isFunction(cmp.yesterdayBtn.finishRender()) ) {
			        	cmp.yesterdayBtn.finishRender();
	     }  
//	     if(Ext.isDefined(me.yesterdayBtn) && Ext.isFunction(me.yesterdayBtn.finishRender()) ) {
//			        	me.yesterdayBtn.finishRender();
//	     }
     }
});

/**
 * EXTJS-16046 Date Field Loses Focus When Selecting Month/Year Picker
 */
Ext.define('Ext.overrides.picker.Month', {
    override: 'Ext.picker.Month',
    
    initComponent: function(){
        var me = this;

        me.selectedCls = me.baseCls + '-selected';

        if (me.small) {
            me.addCls(me.smallCls);
        }
        me.setValue(me.value);
        me.activeYear = me.getYear(new Date().getFullYear() - 4, -4);

        if (me.showButtons) {
            me.okBtn = new Ext.button.Button({
                text: me.okText,
                handler: me.onOkClick,
                scope: me,

                // OVERRIDE
                ownerCt: me,
                onMouseDown: me.onButtonMouseDown
            });
            me.cancelBtn = new Ext.button.Button({
                text: me.cancelText,
                handler: me.onCancelClick,
                scope: me,

                // OVERRIDE
                ownerCt: me,
                onMouseDown: me.onButtonMouseDown
            });
        }

        // OVERRIDE
        // this.callParent();
        this.callSuper();
    },
    
    // Override : new function to handle picker buttons' mousedown event
    onButtonMouseDown : function(e) {
        if (!this.ownerCt.focusable) {
            e.preventDefault();
        }
    }
});

/**
  * Store insert 오류 with locking grid
  * ExtJS version : 5.1.0
  */
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


Ext.override(Ext.grid.plugin.BufferedRenderer, {

    refreshSize: function() {
        var me = this,
            view = me.view;
        
        
        me.scrollHeight = me.getScrollHeight();
        me.stretchView(view, me.scrollHeight);
    },
    
    onViewResize: function(view, width, height, oldWidth, oldHeight) {
        var me = this,
            newViewSize;
        
        if (!oldHeight || height !== oldHeight) {
            
            newViewSize = Math.ceil(height / me.rowHeight) + me.trailingBufferZone + me.leadingBufferZone;
            me.viewSize = me.setViewSize(newViewSize);
            me.viewClientHeight = view.el.dom.clientHeight;
        }
    },
    stretchView: function(view, scrollRange) {
        var me = this,
            recordCount = me.store.getCount(),
            el, stretcherSpec;
        
        if (me.scrollTop > scrollRange) {
            me.position = me.scrollTop = Math.max(scrollRange - view.body.dom.offsetHeight, 0);
            view.setScrollY(me.scrollTop);
        }
        if (me.bodyTop > scrollRange) {
            view.body.translate(null, me.bodyTop = me.position);
        }
        
        if (view.getScrollable()) {
            me.refreshScroller(view, scrollRange);
        } else if (!me.pendingScrollerRefresh) {
            view.on({
                boxready: function() {
                    me.refreshScroller(view, scrollRange);
                    me.pendingScrollerRefresh = false;
                },
                single: true
            });
            me.pendingScrollerRefresh = true;
        }
        
        if (!Ext.supports.touchScroll || Ext.supports.touchScroll === 1) {
            if (!me.stretcher) {
                el = view.getTargetEl();
                
                
                if (view.refreshCounter) {
                    view.fixedNodes++;
                }
                stretcherSpec = {
                    role: 'presentation',
                    style: {
                        width: '1px',
                        height: '1px',
                        'marginTop': (scrollRange - 1) + 'px',
                        position: 'absolute'
                    }
                };
                stretcherSpec.style[me.isRTL ? 'right' : 'left'] = 0;
                me.stretcher = el.createChild(stretcherSpec, el.dom.firstChild);
            }
            
            if (me.hasOwnProperty('viewSize') && recordCount <= me.viewSize) {
                me.stretcher.dom.style.display = 'none';
            } else {
                me.stretcher.dom.style.marginTop = (scrollRange - 1) + 'px';
                me.stretcher.dom.style.display = '';
            }
        }
    },
    refreshScroller: function(view, scrollRange) {
        var scroller = view.getScrollable();
        if (scroller) {
            
            if (scroller.setElementSize) {
                scroller.setElementSize();
            }
            
            scroller.setSize({
                x: view.headerCt.getTableWidth(),
                y: scrollRange
            });
            
            
            if (view.touchScroll === 2 && Ext.isFunction(scroller.setRefreshOnIdle)) {
                scroller.setRefreshOnIdle(false);
            }
        }
    }
}, function(cls) {
    
    
    if (Ext.supports.Touch) {
        cls.prototype.leadingBufferZone = cls.prototype.trailingBufferZone = 2;
        cls.prototype.numFromEdge = 1;
    }
});

