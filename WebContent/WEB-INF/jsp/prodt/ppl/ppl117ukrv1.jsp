<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<meta name="decorator" content="calendar_body2"/>
<t:appConfig pgmId="ppl117ukrv"   >
	<t:ExtComboStore comboType="BOR120" />  
	<t:ExtComboStore comboType="OU" comboCode=""  />  
	<t:ExtComboStore comboType="WU" comboCode=""  /> 
	<t:ExtComboStore comboType="AU" comboCode="P001"  opts="2;8;9"/> 
</t:appConfig>
<script type="text/javascript" >

var regFormWin, editorWin;
function appMain() {
	Ext.apply(Extensible.calendar.data.CalendarMappings, {
   	 CalendarId: {
  	        name:    'CalendarId',
  	        mapping: 'CalendarId',
  	        type:    'string'
  	    },
  	    Title: {
  	        name:    'Title',
  	        mapping: 'title',
  	        type:    'string'
  	    },
  	    Description: {
  	        name:    'Description',
  	        mapping: 'desc',
  	        type:    'string'
  	    },
  	    ColorId: {
  	        name:    'ColorId',
  	        mapping: 'ColorId',
  	        type:    'int'
  	    },
  	    IsHidden: {
   	        name:    'IsHidden',
   	        mapping: 'hidden',
   	        type:    'boolean'
   	    }
	});
    Extensible.calendar.data.CalendarModel.reconfigure();
	 Ext.apply(Extensible.calendar.data.EventMappings, {
	    EventId: {
	        name:    'EventId',
	        mapping: 'EventId',
	        type:    'string'
	    },
	    CalendarId: {
	        name:    'CalendarId',
	        mapping: 'CalendarId',
	        type:    'string'
	    },
	    Title: {
	        name:    'title',
	        mapping: 'title',
	        type:    'string'
	    },
	    StartDate: {
	        name:       'startDate',
	        mapping:    'start',
	        type:       'date',
	        dateFormat: 'Y-m-d H:i:sO'
	    },
	    EndDate: {
	        name:       'endDate',
	        mapping:    'end',
	        type:       'date',
		    dateFormat: 'Y-m-d H:i:sO'
	    },
	    IsAllDay: {
	        name:    'IsAllDay',
	        mapping: 'ad',
	        type:    'boolean'
	    }
	});
	 Extensible.calendar.data.EventModel.reconfigure();
	Ext.define('ppl117ukrvModel', {
		extend:'Extensible.calendar.data.EventModel',
        fields: [
            {name:    'EventId',        mapping: 'EventId',          type:    'String'}, //EventId
            {name:    'CalendarId', 	mapping: 'CalendarId',  type:    'String'}, //calendarId
            {name:    'title',      	mapping: 'title',       type:    'string'}, //Title
            {name:    'startDate',  	mapping: 'startDate',   type:    'date'  },//StartDate
            {name:    'endDate',   	 	mapping: 'endDate',  	type:    'date'  },//EndDate
            {name:    'IsAllDay',   	mapping: 'IsAllDay',  	type:    'boolean' },
            {name:    'DIV_CODE',  		text   : '사업장코드',    	type:     'string' },
            {name:    'WKORD_NUM',  	text   : '작업지시번호',    	type:     'string' },
            {name:    'ITEM_CODE',  	text   : '품목코드',      	type:     'string' },
            {name:    'ITEM_NAME',  	text   : '픔목명',        type:     'string' },
            {name:    'SPEC',       	text   : '규격',         	type:     'string' },
            {name:    'EQUIP_CODE',  		text   : '설비',    	type:     'string' },
            {name:    'EQU_NAME',  		text   : '설비명',    	type:     'string' },
            {name:    'WKORD_Q',  		text   : '작지수량',    	type:     'string' },
            {name:    'WKORD_STATUS',	text   : '진행상태',    	type:     'string' },
            {name:    'ORDER_NUM',  	text   : '수주번호',    	type:     'string' },
            {name:    'CUSTOM_NAME',  	text   : '거래처',    		type:     'string' },
            {name:    'EDITOR_SAVE',  	text   : '팝업수정여부',    	type:     'string' }
       ]
    });
     var eventStore = Unilite.createStore('ppl117ukrvStore',{
    	 model:'ppl117ukrvModel',
         proxy: {
             type: 'uniDirect',
             api: {
                 read: ppl117ukrvService.getEventList,
                 update : ppl117ukrvService.updateDetail
             }
         },
         listeners:{
        	 load : function(store)	{
        		 var cpObj = Ext.getCmp('uniCalendarPanel01');
        		 //휴일, 반인 조회
        		 holidaysStore.loadStoreRecords();   
        		 cpObj.unmask();
        	 },
        	 beforeload :function(store, operation, arg2){
        		 if(operation && operation.action == 'read')	{
        			 if(operation.params)	{
        			 	operation.params = Ext.Object.merge(operation.params,  panelSearch.getValues());
        			 } else {
        				 var cpObj = Ext.getCmp('uniCalendarPanel01');
        				 operation.params = panelSearch.getValues();
        			 }
        			var cpObj = Ext.getCmp('uniCalendarPanel01');
        			//xtype  == "extensible.dayview"
     			 	if(cpObj && cpObj.activeView) {
     			 		if(cpObj.activeView.xtype == "extensible.weekview" || cpObj.activeView.xtype =='extensible.dayview')	{
     			 			Ext.each(cpObj.items.items, function(item)	{
     			 				if(item.xtype == "extensible.dayheaderview")	{
     			 					operation.params.startDate = item.viewStart;
     	        				    operation.params.endDate = item.viewEnd;
     			 				}
     			 			});
     			 			if(Ext.isEmpty(operation.params.startDate) && !Ext.isEmpty(cpObj.activeView.viewStart)
     			 					&& cpObj.items.items.length > -1 && !Ext.isEmpty(cpObj.items.items[0].items)  )	{
     			 				Ext.each(cpObj.items.items[0].items, function(item)	{
         			 				if(item.xtype == "extensible.dayheaderview")	{
         			 					operation.params.startDate = item.viewStart;
         	        				    operation.params.endDate = item.viewEnd;
         			 				}
         			 			});
         			 		}
     			 			
     			 		} else {
     			 			operation.params.startDate = cpObj.activeView.viewStart;
    				    	operation.params.endDate = cpObj.activeView.viewEnd;
     			 		}
     			 		
     			 	} else {
     			 		operation.params.startDate = moment().startOf("month").format('YYYY-MM-DD');
     			 		operation.params.endDate = moment().endOf("month").format('YYYY-MM-DD');
     			 	}
     			 	holidaysStore.searchParam = operation.params;     
     			 	cpObj.mask("조회 중...");
        		 }
        	 }
         },
         loadStoreRecords: function() {
              var param = panelSearch.getValues();
              this.load({
                  params : param
              });
          }
    });
     Unilite.defineModel('ppl117ukrvModel1', {
         fields: [
             {name:    'cal_date'    	, type:    'string'}, 
             {name:    'title'         	, type:    'string'},
             {name:    'startDate'		, type:    'date'  },
             {name:    'endDate'	   	, type:    'date'  },
             {name:    'holy_type'      , type:    'string'}
        ]
     });
     var holidaysStore = Unilite.createStore('ppl117ukrvholidaysStore',{
    	 model:'ppl117ukrvModel1',
         proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
     		api: {
    			read: 'ppl117ukrvService.selectHolydayList'
    		}
    	 }), 
         loadStoreRecords : function(param) {
   			console.log(this.searchParam);
   			this.load({
   				params : this.searchParam
   			});
   		 },
   		 searchParam : {},
         listeners:{
        	 load : function(store, records) {

        		var cpObj = Ext.getCmp('uniCalendarPanel01');
        		var viweCls = { 
        			"extensible.monthview" 		: "uniCalendarPanel01-month-ev-day-", //월
        			"extensible.multiweekview" 	: "uniCalendarPanel01-multiweek-ev-day-", //주
        			"extensible.weekview" 		: "uniCalendarPanel01-week-hd-ev-day-", //2주
        			"extensible.dayview" 		: "uniCalendarPanel01-day-hd-ev-day-" //일
        		}
        		var cls = "uniCalendarPanel01-month-ev-day-";
        		if(cpObj.activeView && cpObj.activeView.xtype) {
        		    cls = viweCls[cpObj.activeView.xtype];
        		}
        		
        		Ext.each(records, function(record){
        			var holyDayDom = Ext.getDom(cls + record.get("cal_date"));
        			if(!Ext.isEmpty(holyDayDom))	{
	        			holyDayDom.innerText = record.get("title") + ', ' +holyDayDom.innerText;
	        			if(record.get("holy_type") == "0")	{
	        				holyDayDom.setAttribute("class", holyDayDom.getAttribute("class") + " holiday1");
	        			}
	        			if(record.get("holy_type") == "1")	{
	        				holyDayDom.setAttribute("class", holyDayDom.getAttribute("class") + " holiday2");
	        			}
        			}
        		});
        	 }
         }
    }); 

    var calendarStore = Ext.create('Extensible.calendar.data.MemoryCalendarStore',{

    	data : [{
		        "CalendarId"    : '2',
		        "title" : "진행",
		        "ColorId" : 17
		    },{
		        "CalendarId"    : '9',
		        "title" : "완료",
		        "ColorId" : 26
		    },{
		        "CalendarId"    : '8',
		        "title" : "마감",
		        "ColorId" : 33
		    },{
		        "CalendarId"    : '0',
		        "title" : "휴일/반일",
		        "ColorId" : 6
		    }],
        sorters : {
            property: Extensible.calendar.data.CalendarMappings.CalendarId.name,
            direction: 'ASC'
        }
		
    }); 
    
    var ppl116ukrEditWin = Ext.create('Extensible.calendar.form.EventWindow', {
        id: 'ext-cal-editwin',
        calendarStore: this.calendarStore,
        modal: true,
        width: 1000,
        enableEditDetails: false,
        saveButtonText: '저장',
        cancelButtonText: '닫기',
        deleteButtonText: '삭제',
        title : '생산일정상세',
        eventadd :false,
        eventdelete: false,
        editdetails: false,
        
        titleTextAdd: 'Add Event',
        titleTextEdit: '생산일정상세',
        labelWidth: 65,
        detailsLinkText: '생산일정상세',
        savingMessage: '저장중...',
        deletingMessage: '삭제중...',
        titleLabelText: 'Title',
        calendarLabelText: 'Calendar',
        // General configs
        closeAction: 'hide',
        resizable:true,
        constrain: true,
        buttonAlign: 'center',
        style : 'background-color : #ffffff',
        formPanelConfig : {
        	bodyStyle : 'background-color : #ffffff; border-width : 0px'
        },
       	getFormItemConfigs: function() {
               var items = [{
                   xtype: 'textfield',
                   itemId: this.id + '-title',
                   name: Extensible.calendar.data.EventMappings.Title.name,
                   fieldLabel: this.titleLabelText,
                   anchor: '100%',
                   hidden : true
               },{
                 	 xtype: 'uniTextfield',
                     fieldLabel: '작업지시번호',
                     labelWidth : 100,
                     name: 'WKORD_NUM',
                     anchor: '50%',
                     readOnly : true
                    
                },{
                 	 xtype: 'uniTextfield',
                     fieldLabel: '품목코드',
                     labelWidth : 100,
                     name: 'ITEM_CODE',
                     anchor: '50%',
                     readOnly : true
                    
                },{
                 	 xtype: 'uniTextfield',
                     fieldLabel: '품목명',
                     labelWidth : 100,
                     name: 'ITEM_NAME', 
                     anchor: '100%',
                     readOnly : true
                    
                },{
                 	 xtype: 'uniTextfield',
                     fieldLabel: '규격',
                     labelWidth : 100,
                     name: 'SPEC', 
                     anchor: '100%',
                     readOnly : true
                    
                },{
                   xtype: 'extensible.daterangefield',
                   itemId: this.id + '-dates',
                   name: 'dates',
                   anchor: '95%',
                   singleLine: true,
                   startDay: this.startDay,
                   dateFormat:'Y-m-d',
                   timeFormat:'g:i A',
                   labelWidth : 100,
                   fieldLabel: '착수/완료예정일',
                   getFieldConfigs: function() {
                       var me = this;
                       return [
                           me.getStartDateConfig(),
                           me.getStartTimeConfig(),
                           me.getDateSeparatorConfig(),
                           me.getEndDateConfig(),
                           me.getEndTimeConfig(),
                           me.getAllDayConfig()
                       ];
                   }
               },
               
               Unilite.popup('EQU_MACH_CODE',{
	    			fieldLabel: '설비',
                    labelWidth : 100,
	    			valueFieldName:'EQUIP_CODE',
	    			textFieldName:'EQU_NAME',
	    			validateBlank:true,
	    			listeners: {
	    				applyextparam: function(popup){
	    					popup.setExtParam({'DIV_CODE'		: panelSearch.getValue('DIV_CODE')});
	    				}
	    			}
	    		}),
    			{
	               	 xtype: 'uniNumberfield',
	                 fieldLabel: '작지수량',
	                 labelWidth : 100,
	                 name: 'WKORD_Q', 
	                 anchor: '50%',
	                 readOnly : true
	                
	            },{
	               	 xtype: 'uniCombobox',
	                 fieldLabel: '진행상태',
	                 labelWidth : 100,
	                 name: 'WKORD_STATUS', 
	                 comboType:'AU',
	                 comboCode:'P001',
	                 anchor: '50%',
	                 readOnly : true
	                
	            },{
	               	 xtype: 'uniTextfield',
	                 fieldLabel: '수주번호',
	                 labelWidth : 100,
	                 name: 'ORDER_NUM', 
	                 width : 250,
	                 readOnly : true
	                
	            },{
	               	 xtype: 'uniTextfield',
	                 fieldLabel: '거래처명',
	                 labelWidth : 100,
	                 name: 'CUSTOM_NAME', 
		             anchor: '100%',
	                 readOnly : true
	            }];

               return items;
             
        },
        getFooterBarConfig: function() {
            var cfg = ['->', {
                    text: this.saveButtonText,
                    itemId: this.id + '-save-btn',
                    disabled: false,
                    handler: this.onSave,
                    scope: this
                },{
                    text: this.deleteButtonText,
                    itemId: this.id + '-delete-btn',
                    disabled: true,
                    handler: this.onDelete,
                    scope: this,
                    hidden : true
                },{
                    text: this.cancelButtonText,
                    itemId: this.id + '-cancel-btn',
                    disabled: false,
                    handler: this.onCancel,
                    scope: this
                }];

            if(this.enableEditDetails !== false) {
                cfg.unshift({
                    xtype: 'tbtext',
                    itemId: this.id + '-details-btn',
                    text: '<a href="#" class="' + this.editDetailsLinkClass + '">' + this.detailsLinkText + '</a>'
                });
            }
            return cfg;
        },
        listeners: {
        	'render'  :{
                fn: function(win) {
                },
                scope: this
            },
            'eventadd': {
                fn: function(win, rec, animTarget, options) {
                    win.hide(animTarget);
                    win.currentView.onEventEditorAdd(null, rec, options);
                },
                scope: this
            },
            'eventupdate': {
                fn: function(win, rec, animTarget, options) {
                    //win.hide(animTarget);
                    if(rec.get("WKORD_STATUS") == "8")	{
                    	alert("마감된 일정은 수정할 수 없습니다.");
                    	return;
                    }
                    win.currentView.onEventEditorUpdate(null, rec, options);
                },
                scope: this
            },
            'eventdelete': {
                fn: function(win, rec, animTarget, options) {
                    win.hide(animTarget);
                    //win.currentView.onEventEditorDelete(null, rec, options);
                },
                scope: this
            },
            'editdetails': {
                fn: function(win, rec, animTarget, view) {
                    // explicitly do not animate the hide when switching to detail
                    // view as it looks weird visually
                    //win.animateTarget = null;
                    //win.hide();
                    //win.currentView.fireEvent('editdetails', win.currentView, rec);
                },
                scope: this
            },
            'eventcancel': {
                fn: function(win, rec, animTarget) {
                	win.cleanup();
                    win.currentView.onEventEditorCancel();
                },
                scope: this
            },
            'hide' : function(win, rec, animTarget) {
            	win.cleanup();
                win.currentView.onEventEditorCancel();
            }
        }
    });

	var cp = {
			flex:.8,
	        xtype:'extensible.calendarpanel',
	        id:'uniCalendarPanel01',
	        todayText : '오늘',
	        jumpToText : '달력 이동',
	        goText : '이동',
	        dayText : '일',
	        weekText : '주',
	        monthText : '월',
	        multiWeekText : '2주',
	        eventStore: eventStore,
	        calendarStore : calendarStore,
	        showTime : false,
	        eventclick : true,
	        eventMenu : false,
        	editWin : ppl116ukrEditWin,
        	sharedViewCfg :{
        		eventadd: false,
		        eventdelete : false,
		        editdetails: false
        	},
	        monthViewCfg : {

		        enableContextMenus : false,
		        editWin : ppl116ukrEditWin,
		        detailsTitleDateFormat :'Y년 m월 d일',
		        morePanelMinWidth : 500,
	        	onDayClick: function(dt, ad, el) {
	                if (this.readOnly === true) {
	                    return;
	                }
	            }
		        
	        	
	        },
	        dayViewCfg : {
	        	enableContextMenus : false,
		        editWin : ppl116ukrEditWin,
		        detailsTitleDateFormat :'Y년 m월 d일',
		        morePanelMinWidth : 500,
	        	onDayClick: function(dt, ad, el) {
	                if (this.readOnly === true) {
	                    return;
	                }
	            }
	        },
	        weekViewCfg : {
		       
	        	enableContextMenus : false,
		        editWin : ppl116ukrEditWin,
		        detailsTitleDateFormat :'Y년 m월 d일',
		        morePanelMinWidth : 500,
	        	onDayClick: function(dt, ad, el) {
	                if (this.readOnly === true) {
	                    return;
	                }
	            }
	        },
	        multiWeekViewCfg : {
	        	enableContextMenus : false,
		        editWin : ppl116ukrEditWin,
		        detailsTitleDateFormat :'Y년 m월 d일',
		        morePanelMinWidth : 500,
	        	onDayClick: function(dt, ad, el) {
	                if (this.readOnly === true) {
	                    return;
	                }
	            }
		        
	        	
	        },
	        editViewCfg : {
		        eventadd: false,
		        eventdelete : false,
		        editdetails: false,
		        enableContextMenus : false,
	        	editWin : ppl116ukrEditWin,
	        	dismissEventEditor: function(dismissMethod, /*private*/ animTarget) {
	                if (this.newRecord && this.newRecord.phantom) {
	                    this.store.remove(this.newRecord);
	                }
	                delete this.newRecord;

	                // grab the manager's ref so that we dismiss it properly even if the active view has changed
	                var editWin = Ext.WindowMgr.get('ext-cal-editwin');
	                if (editWin) {
	                    editWin[dismissMethod ? dismissMethod : 'hide'](animTarget);
	                }
	                return this;
	            }
	        },
	        
	        listeners:{
	        	'beforeeventmove' : {
	               	 fn: function(win, rec, animTarget) {
	               		 if(rec.get("WKORD_STATUS") == "8")	{
	                        	alert("마감된 일정은 수정할 수 없습니다.");
	                        	return false;
	                        }
	                    },
	                    scope: this
               },
               'rangeselect' : {
	               	 fn: function(win, rec, animTarget) {
	                        return false;
	                    },
	                    scope: this
               }

	        }
		}   	
	
    var panelSearch = Unilite.createSearchForm('ppl117ukrvForm', {
		   region: 'north',
		   xtype: 'container',
		   layout: {type: 'uniTable', columns: 10, tableAttrs : {width:'100%'}},
		   
    		padding:'0 0 0 0',
		   items:[{ 
                fieldLabel: '사업장',
                allowBlank:false,
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                value : UserInfo.divCode,
                child :'WORK_SHOP_CODE',
                
                listeners:{
                    blur:function(field, eOpt) {
                        var cpanel = Ext.getCmp("uniCalendarPanel01");
                       
                    }
                }
            },{ 
                fieldLabel: '작업장',
                name: 'WORK_SHOP_CODE',
                xtype: 'uniCombobox',
                comboType: 'WU',
                width : 250,
                listeners:{
                    blur:function(field, eOpt) {
                        var cpanel = Ext.getCmp("uniCalendarPanel01");
                       
                    }
                }
            }, Unilite.popup('EQU_MACH_CODE',{
    			fieldLabel: '설비',
    			valueFieldName:'EQUIP_CODE',
    			textFieldName:'EQU_MACH_NAME',
    			validateBlank:true,
    			listeners: {
    				applyextparam: function(popup){
    					popup.setExtParam({'DIV_CODE'		: panelSearch.getValue('DIV_CODE')});
    				}
    			}
    		}),
    		{
            	xtype :'uniRadiogroup',
            	fieldLabel	: '진행상태',
            	name        : 'WKORD_STATUS',
            	width       : 400,
				comboType   : 'AU',
				multiSelect : false,
				comboCode   : 'P001',
				listeners :{
					change : function()	{
						cp.eventStore.load();
					}
				}
    		},
    		{
            	xtype : 'component',
            	width : 30,
            	html  :'&nbsp;'
    		},
    		{
            	xtype : 'button',
            	text  : '조회',
            	width : 80,
            	handler : function()	{
            		cp.eventStore.load();
            	}
    		},{
            	xtype : 'component',
            	tdAttrs:{ width : '100%'},
            	html  :'&nbsp;'
    		},{
    			xtype:'component', 
    			width : 50,
    			html :'<span style="color:#7399f9">■</span> 진행 '
    		},{
    			xtype:'component', 
    			width : 50,
    			html :'<span style="color:#83ad47">■</span> 완료  '	
    		},{
    			xtype:'component', 
    			width : 50,
    			html :'<span style="color:#909090">■</span> 마감 '
    		}]
			
	});
            
    Ext.create('Ext.Viewport', {
		layout : 'border',
		title : '',
		items : [
			panelSearch ,
			{
				region:'center',
				flex:1,
				layout:{type:'hbox',align: 'stretch'},
				items:[cp]
			}
			],
		renderTo : Ext.getBody()
	})
	
	panelSearch.setValue("WKORD_STATUS","2");
	cp.eventStore.load();
} 
	 
    </script>