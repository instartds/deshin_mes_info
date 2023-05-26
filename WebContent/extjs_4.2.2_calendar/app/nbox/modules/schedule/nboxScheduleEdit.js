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

Ext.define('nbox.scheduleEditWorkIdStore', {
  extend: 'Ext.data.Store',
  fields: ["WorkID", 'WorkName', 'InputType', 'RefType'],
  autoLoad: true,
  proxy: {
        type: 'direct',
        extraParams: {InputType: 'W01'},
        api: { read: 'nboxWorkCodeService.selectCombo' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});	

Ext.define('nbox.scheduleEditHolidayIdStore', {
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
Ext.define('nbox.scheduleEditModel', {
    extend: 'Ext.data.Model',
    fields: [
		{name: 'ScheduleType'},
		{name: 'ScheduleTypeName'}, 
		{name: 'Subject'},
		{name: 'StartDate', type: 'date', dateFormat:'Y-m-d' },
		{name: 'EndDate', type: 'date', dateFormat:'Y-m-d'},
		{name: 'StartTime', type: 'date', dateFormat:'H:i'},
		{name: 'EndTime', type: 'date', dateFormat:'H:i'},
		{name: 'AllDayFlag', type: 'bool'},
		{name: 'Description'},
		{name: 'OpenFlag', type: 'bool'},
		{name: 'EventInformation'},
		{name: 'MyAuth'},
 		{name: 'WorkID'},
 		{name: 'HolidayID'}		
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
		var workIdStore = Ext.create('nbox.scheduleEditWorkIdStore', {});
		var holidayIdStore = Ext.create('nbox.scheduleEditHolidayIdStore', {});

		me.items = [
			{ 
				xtype: 'combo', scale: 'medium', 
				config: {
					msgLabelText: '일정구분'
			    },
				fieldLabel: '일정구분',
				name: 'ScheduleType',
				labelAlign : 'right',
				labelClsExtra: 'required_field_label',
				
				store: calendarIdStore,
			  	
			  	valueField: 'CODE',
			  	displayField: 'NAME',
			  	value: 'P',
			  	allowBlank:false,
			  	
				padding: '10 0 0 0',
				width: 200,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts ){
						var scheduleEditSubject = Ext.getCmp('scheduleEditSubject');
						var scheduleEditWorkID = Ext.getCmp('scheduleEditWorkID');
						var scheduleEditOpenFlag = Ext.getCmp('scheduleEditOpenFlag');
						
						if( newValue != 'W' ){
							scheduleEditSubject.setVisible(true);
							scheduleEditWorkID.setVisible(false);
							scheduleEditOpenFlag.setVisible(true);
							
							scheduleEditSubject.allowBlank = false;
							scheduleEditWorkID.allowBlank = true;
						}else{
							scheduleEditSubject.setVisible(false);
							scheduleEditWorkID.setVisible(true);
							scheduleEditOpenFlag.setVisible(false);
							
							scheduleEditSubject.allowBlank = true;
							scheduleEditWorkID.allowBlank = false;
						}
					}
				}
			},    	            
			{ 
				xtype: 'textfield',
				config: {
					msgLabelText: '일정명'
			    },
				id: 'scheduleEditSubject',
				name: 'Subject',
				fieldLabel: '일정명',
				labelAlign : 'right',
				labelClsExtra: 'required_field_label',
				width: 500,
				allowBlank: false
			},
			{
				xtype: 'container',
				//id: 'scheduleEditWorkID',	
				layout: {
					type: 'hbox'
				},
				//padding: '0 0 5 0',
				
				//hidden: true,
				
				items: [
					{ 
						xtype: 'combo', scale: 'medium', 
						id: 'scheduleEditWorkID',	
						name: 'WorkID',
						config: {
							msgLabelText: '근태'
					    },
						
						store: workIdStore,
					  	valueField: 'WorkID',
					  	displayField: 'WorkName',
					  	hidden: true,
					  	
					  	fieldLabel: '근태',
						labelAlign : 'right',
						labelClsExtra: 'required_field_label',
						
						padding: '0 5 5 0',
						width: 200,
						listeners: {
							change: function(combo, newValue, oldValue, eOpts ){
								if(newValue != oldValue && newValue != null && newValue != ''){
									var store = combo.getStore();
									
									var record = store.findRecord('WorkID', newValue);
									var container = combo.up('container');
									var holidayId = container.items.get('workEditHolidayID');
										
									if( typeof holidayId != undefined ){
										holidayId.setVisible(false);
										holidayId.allowBlank = true;
										if(record.data.RefType == 'H'){
											holidayId.setVisible(true);
											holidayId.allowBlank = false;
										}
									}
								}
							}
						}
					},
					{ 
						xtype: 'combo', scale: 'medium', 
						itemId: 'workEditHolidayID',
						name: 'HolidayID',
						hidden: true,
						store: holidayIdStore,
					  	valueField: 'HolidayID',
					  	displayField: 'HolidayName',
					  	
					  	labelAlign : 'right',
						labelClsExtra: 'field_label',
						
						padding: '0 0 5 0',
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
						config: {
							msgLabelText: '시작일'
					    },
						id: 'scheduleEditStartDate',
						name:'StartDate', 
						fieldLabel: '일정기간',
						format: 'Y-m-d', 
						labelAlign : 'right',
						labelClsExtra: 'required_field_label',
						allowBlank:false,
						width: 200,
						endTimePeriod:'EndDate',
						validationEvent: 'change',
				        validator: function (value) {
				            return me.timerange(value, this);
				        }
					},	
					{ 
						xtype: 'datefield',
						id: 'scheduleEditEndDate',
						name:'EndDate', 
						format: 'Y-m-d', 
						allowBlank:false,
						width: 95,
						padding: '0 0 0 5',
						startTimeField:'StartDate',
						validationEvent: 'change',
				        validator: function (value) {
				            return me.timerange(value, this);
				        }
					},	
					{ 
						xtype: 'timefield',
						itemId: 'scheduleEditStartTime',
						name:'StartTime',
						width: 60,
						padding: '0 0 0 5',
						format: 'H:i', 
						increment: 30,
						value: '00:00'
					},
					{ 
						xtype: 'timefield',
						itemId: 'scheduleEditEndTime',
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
					    		
					    		container.items.get('scheduleEditStartTime').setVisible(true);
					    		container.items.get('scheduleEditEndTime').setVisible(true);
					    		
					    		if(newValue == true){
					    			container.items.get('scheduleEditStartTime').setVisible(false);
						    		container.items.get('scheduleEditEndTime').setVisible(false);
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
						id: 'scheduleEditOpenFlag',
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

		var validationMsg = me.validationCheck()
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
        else
        	Ext.Msg.alert('확인', me.validationCheck());
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
    		var field = fields.items[idx]; 
			if(!field.isValid()){
				field.lastActiveError = field.lastActiveError.replace('<li>', '<li>\''+ field.config.msgLabelText + '\'은(는) ' );
    			//result += fields.items[idx].getFieldLabel() + ',';
				result += field.lastActiveError;
    		}
    	}
    	
    	return result;
    	//return '[' + result.substring(0,result.length-1) + ']' + '은/는 필수입력 사항입니다.';	
    },
	timerange: function (val, field) {
	    /// <summary>
		/// This will validate two datefields
		/// </summary>
	
		var me = this; //will be the form, containing datefields
		
		var time = field.parseDate(val);
		if (!time) {
		    return;
		}
		if (field.startTimeField && (!this.timeRangeMax || (time.getTime() != this.timeRangeMax.getTime()))) {
		    var start = me.down('datefield[name=' + field.startTimeField + ']');
		    start.maxValue = time;
		    start.validate();
		    this.timeRangeMax = time;
		}
		else if (field.endTimeField && (!this.timeRangeMin || (time.getTime() != this.timeRangeMin.getTime()))) {
		    var end = me.down('datefield[name=' + field.endTimeField + ']');
		        end.minValue = time;
		        end.validate();
		        this.timeRangeMin = time;
		}
		return true;
	},	 
    setDefaultData: function(){
    	var me = this;
    	
    	var win = me.getRegItems()['ParentContainer'];
		var selectedDate = win.getRegItems()['SelectedDate'];
		
		var startDate = Ext.getCmp('scheduleEditStartDate');
		var endDate = Ext.getCmp('scheduleEditEndDate');
		
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