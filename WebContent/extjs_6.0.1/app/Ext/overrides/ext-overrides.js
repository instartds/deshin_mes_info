//@charset UTF-8
/**
 * ExtJS overrides
 */
 
 /**
  * Store insert 오류 with locking grid
  * ExtJS version : 5.1.0
  */
Ext.override(Ext, {
	validIdRe: /^[a-z_][a-z0-9\-_.]*$/i
});

Ext.override(Ext.dom.Element, {
	
	validIdRe: /^[a-z_][a-z0-9\-_.]*$/i

});

Ext.override(Ext.Component, {
	
	validIdRe: /^[a-z_][a-z0-9\-_.]*$/i

});

Ext.override(Ext.form.trigger.Trigger, {
	
	validIdRe: /^[a-z_][a-z0-9\-_.]*$/i

});


/**
 * 내일 버튼 추가함 (2015.09.14)
 */
Ext.define('Ext.overrides.picker.Date', {
    override: 'Ext.picker.Date',

    yesterdayText:'어제',
    
    renderTpl: [
    	'<div id="{id}-innerEl" data-ref="innerEl" role="presentation">',
            '<div class="{baseCls}-header">',
                '<div id="{id}-prevEl" data-ref="prevEl" class="{baseCls}-prev {baseCls}-arrow" role="presentation" title="{prevText}"></div>',
                '<div id="{id}-middleBtnEl" data-ref="middleBtnEl" class="{baseCls}-month" role="heading">{%this.renderMonthBtn(values, out)%}</div>',
                '<div id="{id}-nextEl" data-ref="nextEl" class="{baseCls}-next {baseCls}-arrow" role="presentation" title="{nextText}"></div>',
            '</div>',
            '<table role="grid" id="{id}-eventEl" data-ref="eventEl" class="{baseCls}-inner" cellspacing="0" tabindex="0">',
                '<thead>',
                    '<tr role="row">',
                        '<tpl for="dayNames">',
                            '<th role="columnheader" class="{parent.baseCls}-column-header" aria-label="{.}">',
                                '<div role="presentation" class="{parent.baseCls}-column-header-inner">{.:this.firstInitial}</div>',
                            '</th>',
                        '</tpl>',
                    '</tr>',
                '</thead>',
                '<tbody>',
                    '<tr role="row">',
                        '<tpl for="days">',
                            '{#:this.isEndOfWeek}',
                            '<td role="gridcell">',
                                '<div hidefocus="on" class="{parent.baseCls}-date"></div>',
                            '</td>',
                        '</tpl>',
                    '</tr>',
                '</tbody>',
            '</table>',
            '<tpl if="showToday">',
                '<div id="{id}-footerEl" data-ref="footerEl" role="presentation" class="{baseCls}-footer">{%this.renderTodayBtn(values, out)%}&nbsp;{%this.renderYesterdayBtn(values, out)%}</div>',
            '</tpl>',
            // These elements are used with Assistive Technologies such as screen readers
            '<div id="{id}-todayText" class="' + Ext.baseCSSPrefix + 'hidden-clip">{todayText}.</div>',
            '<div id="{id}-ariaMinText" class="' + Ext.baseCSSPrefix + 'hidden-clip">{ariaMinText}.</div>',
            '<div id="{id}-ariaMaxText" class="' + Ext.baseCSSPrefix + 'hidden-clip">{ariaMaxText}.</div>',
            '<div id="{id}-ariaDisabledDaysText" class="' + Ext.baseCSSPrefix + 'hidden-clip">{ariaDisabledDaysText}.</div>',
            '<div id="{id}-ariaDisabledDatesText" class="' + Ext.baseCSSPrefix + 'hidden-clip">{ariaDisabledDatesText}.</div>',
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
        	encode = Ext.String.htmlEncode,
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
            tabIndex: -1,
            ariaRole: 'presentation',
            listeners: {
                click: me.doShowMonthPicker,
                arrowclick: me.doShowMonthPicker,
                scope: me
            }
            
        });

        if (me.showToday) {
            me.todayBtn = new Ext.button.Button({
            	ui: me.footerButtonUI,
                ownerCt: me,
                ownerLayout: me.getComponentLayout(),
                text: Ext.String.format(me.todayText, today),
                tooltip: Ext.String.format(me.todayTip, today),
                tooltipType: 'title',
                tabIndex: -1,
                ariaRole: 'presentation',
                handler: me.selectToday,
                scope: me
            });
            
            me.yesterdayBtn = new Ext.button.Button({
            	ui: me.footerButtonUI,
                ownerCt: me,
                ownerLayout: me.getComponentLayout(),
                text: Ext.String.format(me.yesterdayText, yesterday),
                tooltip: Ext.String.format(me.yesterdayTip, yesterday),
                tooltipType: 'title',
                tabIndex: -1,
                ariaRole: 'presentation',
                handler: me.selectYesterday,
                scope: me
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
            todayText: encode(me.todayText),
            ariaMinText: encode(me.ariaMinText),
            ariaMaxText: encode(me.ariaMaxText),
            ariaDisabledDaysText: encode(me.ariaDisabledDaysText),
            ariaDisabledDatesText: encode(me.ariaDisabledDatesText),
            days: days
        });

        me.protoEl.unselectable();
        me.on('afterrender', me._onAfterRender, me);
        
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
            var cell = cells[cellIndex],
                describedBy = [];
            
            // Cells are not rendered with ids
            if (!cell.hasAttribute('id')) {
                cell.setAttribute('id', me.id + '-cell-' + cellIndex);
            }
            
            // store dateValue number as an expando
            value = +eDate.clearTime(current, true);
            cell.firstChild.dateValue = value;
            
            cell.setAttribute('aria-label', eDate.format(current, ariaTitleDateFormat));
            
            // Here and below we can't use title attribute instead of data-qtip
            // because JAWS will announce title value before cell content
            // which is not what we need. Also we are using aria-describedby attribute
            // and not placing the text in aria-label because some cells may have
            // compound descriptions (like Today and Disabled day).
            cell.removeAttribute('aria-describedby');
            cell.removeAttribute('data-qtip');
            
            if (value == today) {
                cls += ' ' + me.todayCls;
                describedBy.push(me.id + '-todayText');
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
                describedBy.push(me.id + '-ariaMinText');
                cell.setAttribute('data-qtip', me.minText);
            }
            else if (value > max) {
                cls += ' ' + disabledCls;
                describedBy.push(me.id + '-ariaMaxText');
                cell.setAttribute('data-qtip', me.maxText);
            }
            else if (ddays && ddays.indexOf(current.getDay()) !== -1){
                cell.setAttribute('data-qtip', ddaysText);
                describedBy.push(me.id + '-ariaDisabledDaysText');
                cls += ' ' + disabledCls;
            }
            else if (ddMatch && format){
                formatValue = eDate.dateFormat(current, format);
                if(ddMatch.test(formatValue)){
                    cell.setAttribute('data-qtip', ddText.replace('%0', formatValue));
                    describedBy.push(me.id + '-ariaDisabledDatesText');
                    cls += ' ' + disabledCls;
                }
            }
            
            if (describedBy.length) {
                cell.setAttribute('aria-describedby', describedBy.join(' '));
            }
            
            cell.className = cls + ' ' + me.cellCls;
        };
		
        me.eventEl.dom.setAttribute('aria-busy', 'true');
        
        
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

        me.eventEl.dom.removeAttribute('aria-busy');
        
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
     }
});

//Enter key로 navigation 할 때 checked되지 않되도록 overrides
Ext.define('Ext.overrides.grid.column.Check', {
    override: 'Ext.grid.column.Check',

        processEvent: function(type, view, cell, recordIndex, cellIndex, e, record, row) {
        var me = this,
            key = type === 'keydown' && e.getKey(),
            mousedown = type === 'mousedown',
            disabled = me.disabled,
            ret,
            checked;

        // Flag event to tell SelectionModel not to process it.
        e.stopSelection = !key && me.stopSelection;

        //Enter key로 navigation 할 때 checked되지 않되도록 
         if(key === e.ENTER)	{
         	return ret;
         }
            
        if (!disabled && (mousedown || (/*key === e.ENTER ||*/ key === e.SPACE))) {
            checked = !me.isRecordChecked(record);
			
            // Allow apps to hook beforecheckchange
            
            if (me.fireEvent('beforecheckchange', me, recordIndex, checked) !== false) {
                me.setRecordCheck(record, checked, cell, row, e);
                me.fireEvent('checkchange', me, recordIndex, checked);
                
				//SpaceKey toggle bug 로 추가 됨
				me.getView().ownerGrid.setActionableMode(false);
				
                // Do not allow focus to follow from this mousedown unless the grid is already in actionable mode
                if ((mousedown ||  key === e.SPACE) && !me.getView().actionableMode) {
                    e.preventDefault();
                    
                }
            }
        } else {
            ret = me.callParent(arguments);
        }
        return ret;
    }

});

Ext.define('Ext.overrides.selection.CheckboxModel', {
	 override: 'Ext.grid.column.Check',
	 uniType : 'checkboxmodel' 
});


Ext.define('Ext.overrides.data.TreeStore', {
	override: 'Ext.data.TreeStore',
	
    hasFilter: false,

    filter: function(filters, value) {

        if (Ext.isString(filters)) {
            filters = {
                property: filters,
                value: value
            };
        }

        var me = this,
            decoded = me.decodeFilters(filters),
            i = 0,
            length = decoded.length;

        for (; i < length; i++) {
            me.filters.replace(decoded[i]);
        }

        Ext.Array.each(me.filters.items, function(filter) {
            Ext.Object.each(me.tree.nodeHash, function(key, node) {
                if (filter.filterFn) {
                    if (!filter.filterFn(node)) node.remove();
                } else {
                    if (node.data[filter.property] != filter.value) node.remove();
                }
            });
        });
        me.hasFilter = true;

        console.log(me);
    },

    clearFilter: function() {
        var me = this;
        me.filters.clear();
        me.hasFilter = false;
        me.load();
    },

    isFiltered: function() {
        return this.hasFilter;
    }

});
