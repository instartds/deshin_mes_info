import { Scheduler, StringHelper, DateHelper, Panel, TabPanel , ResourceModel, LocaleManager, Splitter, RecurringTimeSpan, TimeSpan, RecurringTimeSpansMixin, Store, Toast } from '../../build/scheduler.module.js';
import shared from '../_shared/shared.module.js';
/* eslint-disable no-unused-vars */

const maxValue = 10;
var url = window.location.href;
var jsonUrl = url.substring(0,url.indexOf('/prodt/')) +'/prodt'+ '/apsChartData.do' ;


const scheduler = new Scheduler({
        appendTo          : 'container',
        startDate         : new Date(),
        endDate           : new Date().getTime()+(8*24*60*60*1000-1),
        //startDate         : new Date(),
        //endDate           : (new Date().getTime() + 7 * 24 * 60 * 60* 1000),
        viewPreset        : {
        	base          : 'dayAndWeek',
        	hideAnimation : false,
        	headers       : [
                {
                    unit       : 'WEEK',
                    align      : 'center',
                    renderer    : function(date) {
                        return  "W."+DateHelper.format(date, 'WW MMM YYYY').toUpperCase();
                    }
                },
                {
                    unit       : 'DAY',
                    align      : 'center',
                    renderer    : function(date) {
                        return  DateHelper.format(date, 'dd DD').toUpperCase()
                    }
                }
            ]
        },
        rowHeight         : 60,
        barMargin         : 5,
        fillTicks         : true,
        eventStyle        : 'colored',
        enableRecurringEvents : false,
        
        features : {
            nonWorkingTime : true,

            // Not yet compatible with the event styles which center their content
            stickyEvents : false,
            headerZoom     : false,
            dependencies   : true,
            dependencyEdit : {
                showLagField : false
            },
            tree         : true,
            eventEdit  : {
                // Uncomment to make event editor readonly from the start
                // readOnly : true,
                // Add items to the event editor
            	showResourceField : false,
            	editorConfig :{
	            	bbar : {
	                    items : {
	                        deleteButton : null
	                    }
	                }
            	},
                items : {
                	nameField : {
                        type      : 'textArea',
                        label     : '계획명',
                        clearable : false,
                        name      : 'name',
                        weight    : 100,
                        required  : true,
                        readOnly  : true
                    },
                	itemCodeField :{
                		type    : 'text',
                        name    : 'ITEM_CODE',
                        label   : '품목코드',
                        weight  : 120,
                        width   : '150',
                        readOnly : true
                      // This field is only displayed for meetings
                	},
                	itemNameField :{
                		type    : 'text',
                        name    : 'ITEM_NAME',
                        label   : '품목명',
                        weight  : 120,
                        width   : '150',
                        readOnly : true
                      // This field is only displayed for meetings
                	},
                	orderNumField : {
                        type    : 'text',
                        name    : 'ORDER_NUM',
                        label   : '수주번호',
                        weight  : 120,
                        width   : '150',
                        readOnly : true
                      // This field is only displayed for meetings
                      // dataset : { endDate : ${item.value} }
                  }, seqField : {
                      type    : 'text',
                      name    : 'SEQ',
                      label   : '수주순번',
                      weight  : 120,
                      width   : '150',
                      readOnly : true
                    // This field is only displayed for meetings
                    // dataset : { endDate : ${item.value} }
                 },
                    eventColorField :  {
                        type        : 'combo',
                        label       : 'Color',
                        name        : 'eventColor',
                        editable    : false,
                        hidden      : true,
                        weight      : 130,
                        listItemTpl : item => StringHelper.xss`<div class="color-box b-sch-${item.value}"></div><div>${item.text}</div>`,
                        items       : Scheduler.eventColors.map(color => [color, StringHelper.capitalize(color)])
                    },
                	wkPlanQField : {
                          type    : 'text',
                          name    : 'WK_PLAN_Q',
                          label   : '계확량',
                          weight  : 620,
                          width   : '150',
                          style   : 'text-align: right;'
                        // This field is only displayed for meetings
                        // dataset : { endDate : ${item.value} }
                    },
                    confirmYn : {
                        type    : 'text',
                        name    : 'CONFIRM_YN',
                        label   : '확졍여부',
                        weight  : 620,
                        width   : '150',
                        readOnly : true
                      // This field is only displayed for meetings
                      // dataset : { endDate : ${item.value} }
                  }
                }
            }
        },

        columns : [
        	{
                text  : '공정/설비명',
                width : 300,
                field : 'name',
                type  : 'tree'
            },
            {
                text  : '공정명',
                width : 100,
                field : 'WORK_SHOP_NM',
                hidden : true
            },
            {
                text  : '설비명',
                width : 200,
                field : 'EQU_NAME',
                hidden : true
            },{
                text   : 'Category',
                width  : 100,
                field  : 'category',
                hidden : true
            }
        ],
        crudManager : {
            autoLoad  : false,
            assignmentStore : Ext.data.StoreManager.lookup("ppl320ukrvMasterStore1"),
            transport : {
                load : {
                	 url : jsonUrl
                	 //url : '/resources/js/scheduler-4.2.1/apps/ppl320ukrv/data/data.json'
                }
            },
            
	        eventStore : {
	            // Extra fields used on EventModels. Store tries to be smart about it and extracts these from the first
	            // record it reads, but it is good practice to define them anyway to be certain they are included.
	            fields : ['SCHEDULE_NO',
	            	{ name : 'SCHEDULE_NO', text : 'NO' },
	            	'WK_PLAN_Q',
	                { name : 'WK_PLAN_Q', text : '계획량' }
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
//                return StringHelper.encodeHtml(eventRecord.name);
               return [{
                    html : DateHelper.format(eventRecord.startDate, 'LT')+ ' ~ ' + DateHelper.format(eventRecord.endDate, 'LT') +"<br/>" + StringHelper.encodeHtml(eventRecord.name)
                }/*, {
                	html : StringHelper.encodeHtml("<br/><br/>")
                },{
                    html : StringHelper.encodeHtml(eventRecord.name)
                }*/];
        }


    });