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

Ext.define('nbox.workEditWorkIdStore', {
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

Ext.define('nbox.workEditHolidayIdStore', {
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
 		{name: 'ScheduleType'},
 		{name: 'ScheduleTypeName'}, 
 		{name: 'Subject'},
 		{name: 'StartDate'},
 		{name: 'EndDate'},
 		{name: 'StartTime'},
 		{name: 'EndTime'},
 		{name: 'AllDayFlag', type: 'bool' },
 		{name: 'Description'},
 		{name: 'OpenFlag', type: 'bool'},
 		{name: 'EventInformation'},
 		{name: 'MyAuth'},
 		{name: 'WorkID'},
 		{name: 'HolidayID'},
     ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.workEditStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.workEditModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
				api   : {
		        			read: 'nboxWorkStatusService.select' 
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
		var workIdStore = Ext.create('nbox.workEditWorkIdStore', {});
		var holidayIdStore = Ext.create('nbox.workEditHolidayIdStore', {});
		
    	me.items = [
			{ 
				xtype: 'textfield',
				fieldLabel: '일정구분',
				name: 'ScheduleTypeName',
				labelAlign : 'right',
				labelClsExtra: 'field_label',
				readOnly: true,
				padding: '10 0 0 0',
				width: 200,
				value: '근태'
			},             
			{
				xtype: 'container',
				itemId: 'workEditWorkId',	
				layout: {
					type: 'hbox'
				},
				padding: '0 0 5 0',
				
				items: [
					{ 
						xtype: 'combo', scale: 'medium', 
						name: 'WorkID',
						
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
						name: 'HolidayID',

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
						xtype: 'datefield',
						id: 'workEditStartDate',
						name:'StartDate', 
						fieldLabel: '일정기간',
						format: 'Y-m-d', 
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						allowBlank:false,
						width: 200
					},	
					{ 
						xtype: 'datefield',
						id: 'workEditEndDate',
						name:'EndDate', 
						format: 'Y-m-d', 
						allowBlank:false,
						width: 95,
						padding: '0 0 0 5'
					},	
					{ 
						xtype: 'timefield',
						itemId: 'workEditStartTime',
						name:'StartTime',
						width: 60,
						padding: '0 0 0 5',
						format: 'H:i', 
						increment: 30,
						value: '00:00'
					},
					{ 
						xtype: 'timefield',
						itemId: 'workEditEndTime',
						name:'EndTime',
						width: 60,
						padding: '0 0 0 5',
						format: 'H:i', 
						increment: 30,
						value: '00:00'
					},
					{ 
						xtype: 'checkboxfield',
						boxLabel  : '하루종일',
					    name      : 'AllDayFlag',
					    padding: '0 0 0 5',
					    listeners: {
					    	change: function( checkbox, newValue, oldValue, eOpts ){
					    		var container = checkbox.up('container');
					    		
					    		container.items.get('workEditStartTime').setVisible(true);
					    		container.items.get('workEditEndTime').setVisible(true);
					    		
					    		if(newValue == true){
					    			container.items.get('workEditStartTime').setVisible(false);
						    		container.items.get('workEditEndTime').setVisible(false);
					    		}
					    	}
					    }
					}   
				]
			},
			{ 
				xtype: 'textareafield',
				fieldLabel: '상세일정',
				name: 'Description',
				labelAlign : 'right',
				labelClsExtra: 'field_label',
				width: 500
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
					    name : 'OpenFlag'
					} ,
					{ 
						xtype: 'displayfield',
						name:'EventInformation',
						fieldStyle: {
							'text-align': 'right;'
						},
						width: 375,
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
    	var workStatusId = win.getRegItems()['WorkStatusID'];
    	
    	me.clearData();
    	store.proxy.setExtraParam('WorkStatusID', workStatusId);
    	
    	store.load({
   			callback: function(records, operation, success) {
   				if (success){
   					me.loadPanel();
   				}
   			}
		});
    },
    saveData: function(){
		/*var me = this;
		
		var win = me.getRegItems()['ParentContainer'];
		var workStatusId = win.getRegItems()['WorkStatusID'];
		
		var isNew = (scheduleId == "" || scheduleId == null);
		var param = {'WorkStatusID': workStatusId};
	
		if (me.isValid()) {
			me.submit({
	        	params: param,
	            success: function(obj, action) {
	            	
	            	if(isNew)
	            		win.getRegItems()['WorkStatusID'] = action.result.WorkStatusID;
	            	
	            	win.getRegItems()['ActionType'] = NBOX_C_READ;
	            	win.formShow();
	            }
	        });
	    }
	    else
	    	Ext.Msg.alert('확인', me.validationCheck());*/
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
		me.setDefaultData();
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
	},
	setDefaultData: function(){
		var me = this;
		
		var win = me.getRegItems()['ParentContainer'];
		var selectedDate = win.getRegItems()['SelectedDate'];
		
		var startDate = Ext.getCmp('workEditStartDate');
		var endDate = Ext.getCmp('workEditEndDate');
		
		startDate.setValue(selectedDate);
		endDate.setValue(selectedDate);
	}
});	 

/**************************************************
 * Create
 **************************************************/


/**************************************************
 * User Define Function
 **************************************************/	