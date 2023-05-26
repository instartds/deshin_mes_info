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

Ext.define('nbox.scheduleEditTimeStore', {
	  extend: 'Ext.data.Store',
	  fields: ["CODE", 'NAME'],
	  autoLoad: true,
	  proxy: {
	        type: 'direct',
	        extraParams: {MASTERID: 'NX05'},
	        api: { read: 'nboxCommonService.selectCommonCode' },
	        reader: {
	            type: 'json',
	            root: 'records'
	        }
	  	}
	});


/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.scheduleEditModel', {
    extend: 'Ext.data.Model',
    fields: [
		{name: 'ScheduleType'},
		{name: 'ScheduleTypeName'}, 
		{name: 'Subject'},
		{name: 'StartDate', type: 'date', dateFormat:'Y-m-d' },
		{name: 'EndDate'},
		{name: 'StartTime'},
		{name: 'EndTime'},
		{name: 'AllDayFlag', type: 'bool'},
		{name: 'Description'},
		{name: 'OpenFlag', type: 'bool'},
		{name: 'EventInformation'},
		{name: 'MyAuth'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.scheduleEditStore', {
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
Ext.define('nbox.scheduleEditPanel', {
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
	
	api: { submit: 'nboxScheduleService.save' },
	
	initComponent: function () {
		var me = this;
		
		var calendarIdStore = Ext.create('nbox.calendarIdStore', {});
		var scheduleEditTimeStore = Ext.create('nbox.scheduleEditTimeStore', {});
		
    	me.items = [
			{ 
				xtype: 'combo', scale: 'medium', 
				fieldLabel: '일정구분',
				name: 'ScheduleType',
				labelAlign : 'right',
				labelClsExtra: 'field_label',
				
				store: calendarIdStore,
			  	
			  	valueField: 'CODE',
			  	displayField: 'NAME',
			  	value: 'P',
			  	
				padding: '10 0 0 0',
				width: 200
			},    	            
			{ 
				xtype: 'textfield',
				name: 'Subject',
				fieldLabel: '일정명',
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
						xtype: 'datefield',
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
						name:'EndDate', 
						format: 'Y-m-d', 
						allowBlank:false,
						width: 95,
						padding: '0 0 0 5'
					},	
					/*{ 
						xtype: 'combo', scale: 'medium', 
						itemId: 'startTime',
						name: 'StartTime',
						
						store: scheduleEditTimeStore,
					  	
					  	valueField: 'CODE',
					  	displayField: 'NAME',
					  	width: 60,
						padding: '0 0 0 5',
						listeners: {
							change: function(combo, newValue, oldValue, eOpts ){
								
								alert(newValue);
								
							}
						}
					},	*/				
					{ 
						xtype: 'timefield',
						itemId: 'startTime',
						name:'StartTime',
						width: 100,
						padding: '0 0 0 5',
						minValue: '00:00 AM',
				        maxValue: '24:00 PM',
				        increment: 30
					},
					{ 
						xtype: 'textfield',
						itemId: 'endTime',
						name:'EndTime',
						width: 42,
						padding: '0 0 0 5'
					},
					{ 
						xtype: 'checkboxfield',
						boxLabel  : '하루종일',
					    name      : 'AllDayFlag',
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
    	var scheduleId = win.getRegItems()['ScheduleID'];
    	
    	me.clearData();
    	store.proxy.setExtraParam('ScheduleID', scheduleId);
    	
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
		var scheduleId = win.getRegItems()['ScheduleID'];
		
		var isNew = (scheduleId == "" || scheduleId == null);
		var param = {'ScheduleID': scheduleId};

		if (me.isValid()) {
			me.submit({
            	params: param,
                success: function(obj, action) {
                	
                	if(isNew)
                		win.getRegItems()['ScheduleID'] = action.result.ScheduleID;
                	
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