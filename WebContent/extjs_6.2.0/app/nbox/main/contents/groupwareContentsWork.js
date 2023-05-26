/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.main.groupwareContentsWorkModel', {
    extend: 'Ext.data.Model',
    fields: [
		{name: 'WorkInTime'}, 
		{name: 'WorkOutTime'},
		{name: 'TotalHolidayCnt'},		
		{name: 'UseHolidayCnt'},		
		{name: 'MinusHolidayCnt'}
    ]
});


/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.main.groupwareContentsWorkStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsWorkModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
		        api   : {
		        			read: 'groupwareContentsService.selectWork' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

var groupwareContentsWorkStore = Ext.create('nbox.main.groupwareContentsWorkStore', {});

/**************************************************
 * Define
 **************************************************/
/* WORK INOUT PANEL */
Ext.define('nbox.main.groupwareContentsMyWorkInOut', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: false,
	padding: '15px 5px 0px 15px',
	layout: {
		type: 'vbox',
		align: 'stretch'
	},
	style: {
		'border-bottom': '1px solid #C0C0C0'
	},
	
	initComponent: function(){
		var me = this;
		
		var btnWorkIn = {
			xtype: 'button',
			text: '출근체크',
		 	tooltip : '출근체크',
            handler: function() { 
            	me.WorkInButtonDown();
            }
		};
		
		var btnWorkOut = {
			xtype: 'button',
			text: '퇴근체크',
		 	tooltip : '퇴근체크',
            handler: function() { 
            	me.WorkOutButtonDown();
            }
		};
		
		me.items = [
			{
				xtype: 'panel',
				border: false,
				layout: {
					type: 'hbox',
					align: 'stretch'
				},
				margin: '0 0 0 0',
				
				items: [
					btnWorkIn,
				    {
				        xtype: 'displayfield',
				        id: 'WorkInTime',
				        name: 'WorkInTime',
				        value: '00:00',
				        margin: '0 50 0 10'
				    },
				    btnWorkOut,
				    {
				        xtype: 'displayfield',
				        id: 'WorkOutTime',
				        name: 'WorkOutTime',
				        value: '00:00',
				        margin: '0 10 0 10'
				    } 
				]
			}
		];	
		
		me.callParent();
	},
	WorkInButtonDown: function(){
		var me = this;
		
		me.workinData();
	},
	WorkOutButtonDown: function(){
		var me = this;
		
		me.workoutData();		
	},
	workinData: function(){
		var me = this;
    	var param = {'InOutType': 'W0001'};
    	
    	groupwareContentsService.updateWorkInOut(param, 
    		function(provider, response) {
    			var workInTime = Ext.get('WorkInTime');
    			
    			workInTime.setHTML(response.result.result.WorkInTime); 
    			
		});
	},
	workoutData: function(){
		var me = this;
    	var param = {'InOutType': 'W0002'};
    	
    	groupwareContentsService.updateWorkInOut(param, 
    		function(provider, response) {
    			var workOutTime = Ext.get('WorkOutTime');

				workOutTime.setHTML(response.result.result.WorkOutTime);
    			
		});
	}
});

/* WORK HOLIDAY PANEL */
Ext.define('nbox.main.groupwareContentsMyWorkHoliday', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	
	border: false,
	padding: '10px 30px 5px 30px',
	flex: 1,
	layout: {
		type: 'vbox',
		align: 'stretch'
	},
	
	initComponent: function(){
		var me = this;
		
		me.items = [
			{
			    xtype: 'displayfield',
			    name: 'TotalHolidayCnt',
			    fieldLabel: '<img src = "' + CPATH + '/resources/images/nbox/btn_s_open.gif" width=15 height=15 />&nbsp;'+'총&nbsp;연&nbsp;차',
			    fieldStyle: 'text-align:right;'
			},
			{
		        xtype: 'displayfield',
		        name: 'UseHolidayCnt',
		        fieldLabel: '<img src = "' + CPATH + '/resources/images/nbox/btn_s_close.gif" width=15 height=15 />&nbsp;'+'사용연차',
		        fieldStyle: 'text-align:right;'
		    },
		    {
		        xtype: 'displayfield',
		        name: 'MinusHolidayCnt',
		        fieldLabel: '<img src = "' + CPATH + '/resources/images/nbox/btn_s_equal.gif" width=15 height=15 />&nbsp;'+'잔여연차',
		        fieldStyle: 'text-align:right;'
		    }		            
		];
		
		me.callParent();
	}
});

/* WORK PANEL */
Ext.define('nbox.main.groupwareContentsMyWork', {
	extend: 'Ext.form.Panel',
	id: 'groupwareContentsMyWork',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '0 0 0 0',
	
	layout: {
		type: 'vbox',
		align: 'stretch'
	},
	
	title: '나의근태',
	
	tools:[{
	    type:'refresh',
	    tooltip: 'Refresh form Data',
	    handler: function(event, toolEl, panel){
	    	var me = panel.up('panel');
	    	me.queryData();
	    }
	}],	
	
	initComponent: function(){
		var me = this;
		
		/*var title = '나의근태';
		var type = 6;
		
		var html = '';
		html += '<table style="background-color:#d9e7f8;" width="100%">'
		html += '	<tr>';
		html += '		<td width="90%">';
		html += '			<label>' + title + '</label>';
		html += '		</td>';
		html += '		<td width="10%" align="right">';
		html += '			<img src = "' + CPATH + '/resources/images/nbox/main/refresh16a.png" width=15 height=15" onClick="panelRefresh('+ type +')" style="cursor: pointer;" />';
		html += '		</td>'			
		html += '	</tr>';
		html += '</table>';		
		
        var title = {
            xtype: 'container',
            cls: 'nbox-contentTitle',
            html: html,
            padding: '0 0 0 0',
            height: 20,
            region:'north',
            style: {
        		'border-bottom': '1px solid #C0C0C0'
        	},
        	listeners: {
        		render: function(container, eOpts){
        			container.el.on('click', function() {
        		    	me.queryData();
        			});
        		}
        	}
        };	*/	
		
		var groupwareContentsMyWorkInOut = Ext.create('nbox.main.groupwareContentsMyWorkInOut', {
			height: 60
		}); 
		
		var groupwareContentsMyWorkHoliday = Ext.create('nbox.main.groupwareContentsMyWorkHoliday', {
			flex: 1
		});
		
		me.getRegItems()['GroupwareContentsMyWorkInOut'] = groupwareContentsMyWorkInOut;
		groupwareContentsMyWorkInOut.getRegItems()['ParentContainer'] = me;
		me.getRegItems()['StoreData'] = groupwareContentsWorkStore;
		
		me.getRegItems()['GroupwareContentsMyWorkHoliday'] = groupwareContentsMyWorkHoliday;
		groupwareContentsMyWorkHoliday.getRegItems()['ParentContainer'] = me;
		
		me.items = [/*title,*/groupwareContentsMyWorkInOut,groupwareContentsMyWorkHoliday];	 		
		me.callParent(); 
	},
	queryData: function(){
		var me = this;
		var store = me.getRegItems()['StoreData'];
		
		me.clearData();
		
		store.load({
   			callback: function(records, operation, success) {
   				if (success){
   					me.loadData();
   				}
   			}
		});
	},
	loadData: function(){
		var me = this;
		
		me.loadPanel();
	},
	clearData: function(){
		var me = this;
		
		me.clearPanel();
	},
	loadPanel: function(){
		var me = this;
    	var store = me.getRegItems()['StoreData'];
    	var frm = me.getForm();
    	
    	if (store.getCount() >= 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
    	}
    },
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
    	var store = me.getRegItems()['StoreData'];
		
    	store.removeAll();
		frm.reset();
	}
});


/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	