/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
//Combobox

/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.scheduleViewModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'ScheduleID'},
		{name: 'ScheduleType'},
		{name: 'ScheduleTypeName'}, 
		{name: 'Subject'},
		{name: 'StartDate', type: 'date', dateFormat:'Y-m-d'},
		{name: 'EndDate', type: 'date', dateFormat:'Y-m-d'},
		{name: 'StartTime', type: 'date', dateFormat:'H:i'},
		{name: 'EndTime', type: 'date', dateFormat:'H:i'},
		{name: 'AllDayFlag', type: 'bool' },
		{name: 'Description'},
		{name: 'OpenFlag', type: 'bool'},
		{name: 'EventInformation'},
		{name: 'MyAuth'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.scheduleViewStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.scheduleViewModel',
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
//Detail View 
Ext.define('nbox.scheduleViewPanel',    {
    extend: 'Ext.form.Panel',
    config: {
    	regItems: {}
    },
    layout: { 
    	type: 'vbox'
    },
    //padding: '0 0 0 0',
    /*flex: 1,*/
    
    border: false,
    autoScroll: true,
    defaultType: 'displayfield',
    
    initComponent: function () {
    	var me = this;
    	
    	me.items = [
			{ 
				xtype: 'textfield',
				fieldLabel: '일정구분',
				name: 'ScheduleTypeName',
				labelAlign : 'right',
				labelClsExtra: 'field_label',
				readOnly: true,
				padding: '10 0 0 0',
				width: 200
			},    	            
			{ 
				xtype: 'textfield',
				fieldLabel: '일정명',
				name: 'Subject',
				labelAlign : 'right',
				labelClsExtra: 'field_label',
				readOnly: true,
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
						readOnly: true,
						width: 200
					},	
					{ 
						xtype: 'datefield',
						name:'EndDate', 
						format: 'Y-m-d', 
						readOnly: true,
						width: 95,
						padding: '0 0 0 5'
					},	
					{ 
						xtype: 'timefield',
						itemId: 'startTime',
						name:'StartTime',
						width: 60,
						padding: '0 0 0 5',
						format: 'H:i',
						readOnly: true,
						increment: 30
						
					},
					{ 
						xtype: 'timefield',
						itemId: 'endTime',
						name:'EndTime',
						width: 60,
						padding: '0 0 0 5',
						format: 'H:i', 
						readOnly: true,
						increment: 30
					},
					{ 
						xtype: 'checkboxfield',
						boxLabel  : '하루종일',
					    name      : 'AllDayFlag',
					    padding: '0 0 0 5'
					}   
					
				]
			},
			{ 
				xtype: 'textareafield',
				fieldLabel: '상세일정',
				name: 'Description',
				labelAlign : 'right',
				labelClsExtra: 'field_label',
				readOnly: true,
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
					    name      : 'OpenFlag'
					} ,
					{ 
						xtype: 'displayfield',
						name:'EventInformation',
						fieldStyle: {
							'text-align': 'right;'
						},
						readOnly: true,
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
    deleteData: function(){
    	var me = this;
    	
    	var win = me.getRegItems()['ParentContainer'];
		var store = me.getRegItems()['Store'];
		
		if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			var param = {'ScheduleID': record.data.ScheduleID, 'ScheduleType':record.data.ScheduleType};
			
			nboxScheduleService.remove(param, function(provider, response) {
				UniAppManager.updateStatus(Msg.sMB013);
				win.close();
			});
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
			
			me.items.items[2].items.get('startTime').setVisible(true);
			me.items.items[2].items.get('endTime').setVisible(true);
			
			if(record.data.AllDayFlag == true){
				me.items.items[2].items.get('startTime').setVisible(false);
				me.items.items[2].items.get('endTime').setVisible(false);
			}
			
			me._setMyAuth();
    	}
    },
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
		
		frm.reset();
    },
    _setMyAuth: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	
    	if (store.getCount() > 0)
    	{
    		var record = store.getAt(0);
    		
    		var win = me.getRegItems()['ParentContainer'];
    		var detailToolbar = win.getRegItems()['DetailToolbar'];
    		
    		detailToolbar.setToolBars(['edit', 'delete'], false);
    		if(record.data.MyAuth == 1)
    			detailToolbar.setToolBars(['edit', 'delete'], true);
    	}
    }
});


/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/
