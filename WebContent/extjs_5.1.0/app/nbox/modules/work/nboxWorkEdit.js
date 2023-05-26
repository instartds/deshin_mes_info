/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
Ext.define('nbox.calendarIdStore', {
  extend: 'Ext.data.Store',
  fields: ["CODE", 'NAME'],
  autoLoad: true,
  proxy: {
        type: 'direct',
        extraParams: {MASTERID: 'NS04'},
        api: { read: 'nboxCommonService.selectCommonCode' },
        reader: {
            type: 'json',
            root: 'records'
        }
  	}
});

Ext.define('nbox.workIdStore', {
  extend: 'Ext.data.Store',
  fields: ["WorkID", 'WorkName', 'InputType', 'RefType'],
  autoLoad: true,
  proxy: {
        type: 'direct',
        api: { read: 'nboxWorkCodeService.selectCombo' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});	

Ext.define('nbox.holidayIdStore', {
  extend: 'Ext.data.Store',
  fields: ["HolidayID", 'HolidayName'],
  autoLoad: true,
  proxy: {
        type: 'direct',
        api: { read: 'nboxWorkHolidayCodeService.selects' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});	

/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.workEditModel', {
    extend: 'Ext.data.Model',
    fields: [
		{name: 'calendarId'},
		{name: 'calendarIdName'}, 
		{name: 'title'},
		{name: 'startDate'},
		{name: 'endDate'},
		{name: 'startTime'},
		{name: 'endTime'},
		{name: 'allDay'},
		{name: 'notes'},
		{name: 'openFlag'},
		{name: 'eventInformation'},
		{name: 'myAuth'},
		{name: 'workId'},
		{name: 'seq'},
		{name: 'holidayId'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.workEditStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.scheduleEditModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
				api   : {
		        			read: 'nboxScheduleService.select' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});	

/**************************************************
 * Define
 **************************************************/
//Detail Edit Panel
Ext.define('nbox.workEditPanel', {
	extend: 'Ext.form.Panel',
    config: {
    	regItems: {}
    },
    layout: { 
    	type: 'vbox'
    },
    //padding: '0 0 0 0',
    //flex: 1,
    
    border: false,
    autoScroll: true,
    defaultType: 'displayfield',
	
	/*api: { submit: 'nboxBoardService.save' },*/
	
	initComponent: function () {
		var me = this;
		
		var calendarIdStore = Ext.create('nbox.calendarIdStore', {});
		var workIdStore = Ext.create('nbox.workIdStore', {});
		var holidayIdStore = Ext.create('nbox.holidayIdStore', {});
		
    	me.items = [
			{ 
				xtype: 'combo', scale: 'medium', 
				fieldLabel: '일정구분',
				name: 'calendarId',
				labelAlign : 'right',
				labelClsExtra: 'field_label',
				
				store: calendarIdStore,
			  	
			  	valueField: 'CODE',
			  	displayField: 'NAME',
			  	value: 'P',
			  	
				padding: '10 0 0 0',
				width: 200,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts ){
						if(newValue != oldValue && newValue != null){
							var panel = combo.up('panel');
							
							var workEditTitle = panel.items.get('workEditTitle');
							var workEditWorkId = panel.items.get('workEditWorkId');
								
							if( typeof workEditTitle != undefined && typeof workEditWorkId != undefined){
								if(newValue == 'W'){
									workEditTitle.setVisible(false);
									workEditWorkId.setVisible(true);
								}else{
									workEditTitle.setVisible(true);
									workEditWorkId.setVisible(false);
								}
							}
						}
					}
				}
			},    	            
			{ 
				xtype: 'textfield',
				itemId: 'workEditTitle',
				name: 'title',
				fieldLabel: '일정명',
				labelAlign : 'right',
				labelClsExtra: 'field_label',
				width: 450,
			},
			{
				xtype: 'container',
				itemId: 'workEditWorkId',	
				layout: {
					type: 'hbox'
				},
				padding: '0 0 5 0',
				hidden: true,
				
				items: [
					{ 
						xtype: 'combo', scale: 'medium', 
						name: 'workId',
						
						store: workIdStore,
					  	valueField: 'WorkID',
					  	displayField: 'WorkName',
					  	
					  	fieldLabel: '근태',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						
						padding: '0 5 0 0',
						width: 200,
						listeners: {
							change: function(combo, newValue, oldValue, eOpts ){
								if(newValue != oldValue && newValue != null && newValue != ''){
									var store = combo.getStore();
									
									var record = store.findRecord('WorkID', newValue);
									var container = combo.up('container');
									var holidayId = container.items.get('workEditHolidayId');
										
									if( typeof holidayId != undefined ){
										holidayId.setVisible(false);
										if(record.data.RefType == 'H')
											holidayId.setVisible(true);
									}
								}
							}
						}
					},
					{ 
						xtype: 'combo', scale: 'medium', 
						itemId: 'workEditHolidayId',
						name: 'holidayId',

						store: holidayIdStore,
					  	valueField: 'HolidayID',
					  	displayField: 'HolidayName',
					  	
					  	labelAlign : 'right',
						labelClsExtra: 'field_label',
						
						padding: '0 0 0 0',
						width: 100,
						hidden: true
					} 
				]
			},
			{
				xtype: 'container',
				layout: {
					type: 'hbox'
				},
				padding: '0 0 7 0',
				items: [
					{ 
						xtype: 'textfield',
						name:'startDate',
						fieldLabel: '일정기간',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 185
					},
					{ 
						xtype: 'textfield',
						name:'endDate',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 80,
						padding: '0 0 0 5'
					},
					{ 
						xtype: 'textfield',
						itemId: 'startTime',
						name:'startTime',
						width: 42,
						padding: '0 0 0 5',
					} ,
					{ 
						xtype: 'textfield',
						itemId: 'endTime',
						name:'endTime',
						width: 42,
						padding: '0 0 0 5'
					} ,
					{ 
						xtype: 'checkboxfield',
						boxLabel  : '하루종일',
					    name      : 'allDay',
					    padding: '0 0 0 5',
					    listeners: {
					    	change: function( checkbox, newValue, oldValue, eOpts ){
					    		var container = checkbox.up('container');
					    		
					    		container.items.get('startTime').setVisible(true);
					    		container.items.get('endTime').setVisible(true);
					    		
					    		if(newValue == true){
					    			container.items.get('startTime').setVisible(false);
						    		container.items.get('endTime').setVisible(false);
					    		}
					    	}
					    }
					}   
				]
			},
			{ 
				xtype: 'textareafield',
				fieldLabel: '상세일정',
				name: 'notes',
				labelAlign : 'right',
				labelClsExtra: 'field_label',
				width: 450
			},
			{
				xtype: 'container',
				layout: {
					type: 'hbox'
				},
				padding: '0 0 7 0',
				items: [
					{ 
						xtype: 'checkboxfield',
						fieldLabel: '공개여부',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
					    name      : 'openFlag'
					} ,
					{ 
						xtype: 'displayfield',
						name:'eventInformation',
						fieldStyle: {
							'text-align': 'right;'
						},
						width: 325,
						padding: '0 0 0 5'
					} 
					
				]
			}
    	];
    	
    	me.callParent();
	},
    queryData: function(){
    	var me = this;
    	
    	var store = me.getRegItems()['Store'];
    	var win = me.getRegItems()['ParentContainer'];
    	var record = win.getRegItems()['Record'];
    	
    	me.clearData();
    	
    	store.proxy.setExtraParam('calendarId', record.data.calendarId);
    	store.proxy.setExtraParam('companyId', record.data.companyId);
    	store.proxy.setExtraParam('userId', record.data.userId);
    	store.proxy.setExtraParam('workDate', record.data.workDate);
    	store.proxy.setExtraParam('workId', record.data.workId);
    	store.proxy.setExtraParam('seq', record.data.seq);
    	store.proxy.setExtraParam('holidayId', record.data.holidayId);
    	store.proxy.setExtraParam('scheduleId', record.data.scheduleId);
    	
    	store.load({
   			callback: function(records, operation, success) {
   				if (success){
   					me.loadPanel();
   				}
   			}
		});
    },
    saveData: function(){
    	var me = this;
    	
    	var win = me.getRegItems()['ParentContainer'];
		var record = win.getRegItems()['Record'];
		
		var isNew = (record == "" || record == null);
		
		if (me.isValid()) {
			me.submit({
            	params: param,
                success: function(obj, action) {
                	
                	/*if(isNew)
                		win.getRegItems()['NoticeID'] = action.result.NOTICEID;*/
                	
                	/*boardEditUploadFile.reset();*/
                	win.getRegItems()['ActionType'] = NBOX_C_READ;
                	win.formShow();
                }
            });
        }
        else {
        	Ext.Msg.alert('확인', me.validationCheck());
        }
    },
    clearData: function(){
    	var me = this;
		var store = me.getRegItems()['Store'];
			
    	me.clearPanel();
    	
    	store.removeAll();
    },
	loadPanel: function(){
		var me = this;
    	var store = me.getRegItems()['Store'];
    	var frm = me.getForm();
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
    	}
    },
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
		
		frm.reset();
    },
    validationCheck: function(){
    	var me = this;
    	
    	var fields = me.getForm().getFields();
    	var result = '';
    	
    	var itemCnt = fields.getCount();
    	for(var idx=0; idx<itemCnt; idx++){
    		if(!fields.items[idx].isValid()){
    			result += fields.items[idx].getFieldLabel() + ',';
    		}
    	}
    	
    	return '[' + result.substring(0,result.length-1) + ']' + '은/는 필수입력 사항입니다.';	
    }
});	 

/**************************************************
 * Create
 **************************************************/


/**************************************************
 * User Define Function
 **************************************************/	