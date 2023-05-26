import { Scheduler, StringHelper, DateHelper, Panel, TabPanel , ResourceModel, LocaleManager, Splitter, RecurringTimeSpan, TimeSpan, RecurringTimeSpansMixin, Store, Toast } from '../../build/scheduler.module.js';
import shared from '../_shared/shared.module.js';
/* eslint-disable no-unused-vars */

const maxValue = 10;
var url = window.location.href;
var jsonUrl = url.substring(0,url.indexOf('/prodt/')) +'/prodt'+ '/ganttJsonData.do?DUMMY_YN=N' ;

//alert(inputId.value);
//region Data

//Define a new Model extending TimeSpan class
//with RecurringTimeSpan mixin which adds recurrence support
class MyTimeRange extends RecurringTimeSpan(TimeSpan) {}

//Define a new store extending the Store class
//with RecurringTimeSpansMixin mixin to add recurrence support to the store.
//This store will contain time ranges.
class MyTimeRangeStore extends RecurringTimeSpansMixin(Store) {
 static get defaultConfig() {
     return {
         // use our new MyTimeRange model
         modelClass : MyTimeRange,
         storeId    : 'timeRanges'
     };
 }
}

//instantiate store for time ranges using our new classes
const myTimeRangeStore = new MyTimeRangeStore();

const scheduler = new Scheduler({
    appendTo   : 'container',
    eventStyle : 'border',
    eventColor : null,
    resourceImagePath : '../_shared/images/users/',
    fillTicks         : false,
    enableRecurringEvents : true,
    highlightSuccessors   : true,
    highlightPredecessors : true,
    features : {
        //stripe       : true,
	    group        : 'name',
        sort         : 'progWorkCode',
        nonWorkingTime : true,
        timeRanges 	   : true,
        //filterBar  : true,
        stripe     : false,
        dependencies   : true,
        dependencyEdit : {
            showLagField : false
        },
        timeRanges : {
            showCurrentTimeLine : false,
            showHeaderElements  : false
        },eventEdit  : {
            // Uncomment to make event editor readonly from the start
            // readOnly : true,
            // Add items to the event editor
            items : {
                eventColorField : {
                    type        : 'combo',
                    label       : 'Color',
                    name        : 'eventColor',
                    editable    : false,
                    weight      : 130,
                    listItemTpl : item => StringHelper.xss`<div class="color-box b-sch-${item.value}"></div><div>${item.text}</div>`,
                    items       : Scheduler.eventColors.map(color => [color, StringHelper.capitalize(color)])
                },
            	orderNumField : {
                    type    : 'text',
                    name    : 'orderNum',
                    label   : '수주번호',
                    weight  : 120,
                    width   : '150',
                    style   : 'text-align: center;'
                  // This field is only displayed for meetings
                  // dataset : { endDate : ${item.value} }
              },
            	actSetMField : {
                      type    : 'text',
                      name    : 'actSetM',
                      label   : '준비시간',
                      weight  : 620,
                      width   : '150',
                      style   : 'text-align: center;'
                    // This field is only displayed for meetings
                    // dataset : { endDate : ${item.value} }
                },
                planTimeField : {
                    type    : 'text',
                    name    : 'planTime',
                    label   : '제조시간',
                    weight  : 620,
                    width   : 250,
                    style   : 'text-align: center'
                  // This field is only displayed for meetings
                  // dataset : { endDate : ${item.value} }
	             },
	             actOutMField : {
	                  type    : 'text',
	                  name    : 'actOutM',
	                  label   : '정리시간',
	                  weight  : 620,
	                  width   : 250,
	                  style : 'text-align: center'
	                // This field is only displayed for meetings
	                // dataset : { endDate : ${item.value} }
	            }
            }
        }
     /*   groupSummary : {
            collapseToHeader : true,
            summaries        : [
                {
                    label : 'Full time',

                    renderer : ({ events }) => {
                        // Only count events for resources that are "Full time"
                        return events.filter(event => event.resource.type === 'Full time').length;
                    }
                },
                {
                    label : 'Part time',

                    renderer : ({ events }) => {
                        return events.reduce((result, event) => {
                            // Only count events for resources that are "Part time"
                            return result + (event.resource.type === 'Part time' ? 1 : 0);
                        }, 0);
                    }
                },
                {
                    label : 'Total',

                    height : 40, // needed to make summary row grow correctly

                    renderer({ events }) {
                        const value = Math.min(1, events.length / maxValue),
                            height = (100 * value) + '%';

                        return `
                           <div class="bar-outer">
                               <div class="bar-inner" style="height: ${height}"><label class="${value > 0.5 ? 'b-summarybar-label-inside' : ''}">${events.length || ''}</label></div>
                           </div>
                        `;
                    }
                }

            ]
        }*/
    },

    columns : [
               {
                   text   : 'Category',
                   width  : 100,
                   field  : 'category',
                   hidden : true
               },{
                   text   : 'progWorkCode',
                   width  : 100,
                   field  : 'progWorkCode',
                   hidden : true
               },
               {

                   text      : '공정명',
                   field	 :'name',
                   width     : 250/*,
                   summaries : [{ sum : 'count', label : 'Employees' }]*/
               },
               {
                   text      : '설비명',
                   width     : 250,
                   field     : 'type'/*,
                   summaries : [
                       {
                           sum   : (result, record) => result + (record.type === 'Part time' ? 1 : 0),
                           label : 'Part time'
                       }
                   ]*/
               }
    ],
    project : {
        // use our store for time ranges (crudManager will load it automatically among other project stores)
        timeRangeStore : myTimeRangeStore
    },
    tbar : [
            '->',
            {
                type : 'widget',
                cls  : 'b-has-label',
                html : '<label>Non-working days</label>'
            },
            {
                type     : 'buttongroup',
                ref      : 'nonWorkingDays',
                defaults : {
                    cls        : 'b-raised',
                    toggleable : true
                },
                items : DateHelper.getDayShortNames().map((name, index) => {
                    return {
                        text    : name,
                        pressed : DateHelper.nonWorkingDays[index],
                        index
                    };
                }),
                listeners : {
                    click : 'up.onNonWorkingDayChange'
                }
            },{
                type    : 'checkbox',
                label   : 'Highlight dependent events',
                checked : true,
                onChange({ checked }) {
                    if (checked && !scheduler.selectedEvents.length) {
                        Toast.show('Select an event to highlight the dependency chain');
                    }

                    scheduler.highlightSuccessors = scheduler.highlightPredecessors = checked;
                }
            }, {
                type     : 'checkbox',
                label    : 'Fill ticks',
                checked  : true,
                hidden   : true,
                onChange : ({ checked }) => {
                    scheduler.fillTicks = checked;
                }
            }
    ],
    rowHeight : 45,
    barMargin : 10,
    startDate : new Date(2021, 5, 1,0),
    endDate   : new Date(2021, 7, 1,24),

    // Customize preset
    viewPreset                : {
        displayDateFormat : 'H:mm',
        tickWidth         : 25,
        shiftIncrement    : 1,
        shiftUnit         : 'WEEK',
        timeResolution    : {
            unit      : 'MINUTE',
            increment : 60
        },
        headers           : [
            {
                unit       : 'DAY',
                align      : 'center',
                dateFormat : 'ddd L'
            },
            {
                unit       : 'HOUR',
                align      : 'center',
                dateFormat : 'H'
            }
        ]
    },
    // Custom time axis
    timeAxis : {
        continuous : false,

        generateTicks(start, end, unit, increment) {
            const ticks = [];

            while (start < end) {

                if (unit !== 'hour' || start.getHours() >= 8 && start.getHours() <= 24) {
                    ticks.push({
                        id        : ticks.length + 1,
                        startDate : start,
                        endDate   : DateHelper.add(start, increment, unit)
                    });
                }

                start = DateHelper.add(start, increment, unit);
            }
            return ticks;
        }
    },
    crudManager : {
        autoLoad  : false,
        transport : {
            load : {
            	 url : jsonUrl
            }
        },
        eventStore : {
            // Extra fields used on EventModels. Store tries to be smart about it and extracts these from the first
            // record it reads, but it is good practice to define them anyway to be certain they are included.
            fields : [
                'actSetM',
                { name : 'actSetM', defaultValue : '' },
                'planTime',
                { name : 'planTime', defaultValue : '' },
                'actOutM',
                { name : 'actOutM', defaultValue : '' }
            ]
        }
    },

    eventRenderer({ eventRecord, resourceRecord, renderData }) {
        const colors = {
        	H120 : 'orange',
        	H210 : 'purple',
        	H310 : 'lime',
            Testers     : 'cyan'
        };

        if (!eventRecord.eventColor) {
            renderData.eventColor = colors[resourceRecord.category];
        }

        // Add a custom CSS classes to the template element data by setting a property name
        renderData.cls.full = resourceRecord.type === 'Full time';
        renderData.cls.part = !renderData.cls.full;

        // Add data to be applied to the event template
        return StringHelper.encodeHtml(eventRecord.name);
    },

    onNonWorkingDayChange() {
        const
            // Collect an array of pressed button indices
            values = this.widgetMap.nonWorkingDays.items.filter(button => button.pressed).map(button => button.index),
            // Convert array [0, 6] to object { 0 : true, 6 : true } for example
            days   = values.reduce((acc, day) => {
                acc[day] = true;
                return acc;
            }, {});

        // Update nonWorkingDays in current locale
        LocaleManager.locale.DateHelper.nonWorkingDays = days;

        // Force-apply current locale to update non-working intervals
        LocaleManager.applyLocale(LocaleManager.locale.localeName, true);
    }
});
