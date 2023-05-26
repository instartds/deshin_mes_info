import { Scheduler, DateHelper, StringHelper, Toast } from '../../build/scheduler.module.js';
import shared from '../_shared/shared.module.js';

const maxValue = 10;
var url = window.location.href;
var jsonUrl = url.substring(0,url.indexOf('/prodt/')) +'/prodt'+ '/ganttJsonData.do?DUMMY_YN=N' ;

const scheduler = new Scheduler({
    appendTo          : 'container',
    startDate         : new Date(2018, 4, 13),
    endDate           : new Date(2018, 4, 20),
    viewPreset        : 'dayAndWeek',
    rowHeight         : 60,
    barMargin         : 5,
    fillTicks         : true,
    eventStyle        : 'colored',
    resourceImagePath : '../_shared/images/users/',

    features : {
	    group        : 'name',
        sort         : 'progWorkCode',
        nonWorkingTime : true,

        // Not yet compatible with the event styles which center their content
        stickyEvents : false,
        dependencies   : true,
        dependencyEdit : {
            showLagField : false
        },
        eventEdit  : {
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
                   width     : 100/*,
                   summaries : [{ sum : 'count', label : 'Employees' }]*/
               },
               {
                   text      : '설비명',
                   width     : 150,
                   field     : 'type'/*,
                   summaries : [
                       {
                           sum   : (result, record) => result + (record.type === 'Part time' ? 1 : 0),
                           label : 'Part time'
                       }
                   ]*/
               }
    ],

/*    eventStore : {
        readUrl  : 'data/events.json',
        autoLoad : true
    },

    resourceStore : {
        readUrl  : 'data/resources.json',
        autoLoad : true
    },*/

   /* eventRenderer({ eventRecord }) {
        return [{
            html : DateHelper.format(eventRecord.startDate, 'LT')
        }, {
            html : StringHelper.encodeHtml(eventRecord.name)
        }];
    },*/
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
//        return StringHelper.encodeHtml(eventRecord.name);
       return [{
            html : DateHelper.format(eventRecord.startDate, 'LT')+ ' ~ ' + DateHelper.format(eventRecord.endDate, 'LT')
        }, {
            html : StringHelper.encodeHtml(eventRecord.name)
        }];
    },
    tbar : [
            '->',{
                type    : 'checkbox',
                label   : 'Highlight dependent events',
                checked : true,
                onChange({ checked }) {
                    if (checked && !scheduler.selectedEvents.length) {
                        Toast.show('Select an event to highlight the dependency chain');
                    }

                    scheduler.highlightSuccessors = scheduler.highlightPredecessors = checked;
                }
            }, 
        {
            type     : 'checkbox',
            label    : 'Fill ticks',
            checked  : true,
            onChange : ({ checked }) => {
                scheduler.fillTicks = checked;
            }
        }
    ],
    
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

});
