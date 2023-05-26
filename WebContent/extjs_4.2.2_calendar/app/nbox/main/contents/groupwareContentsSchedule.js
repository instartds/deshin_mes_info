/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.main.groupwareContentsScheduleModel', {
    extend: 'Ext.data.Model',
    fields: [
		{name: 'calendarId'}, 
		{name: 'title'},
		{name: 'startDate'},
		{name: 'endDate'},
		{name: 'startTime'},
		{name: 'endTime'},
		{name: 'allDay'},
		{name: 'notes'},
		{name: 'openFlag'},
		{name: 'eventInformation'},
		{name: 'scheduleId'},
		{name: 'companyId'},
		{name: 'userId'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.main.groupwareContentsScheduleStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsScheduleModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
		        api   : {
		        			read: 'groupwareContentsService.selectSchedule' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});


var groupwareContentsScheduleStore = Ext.create('nbox.main.groupwareContentsScheduleStore', {});
/**************************************************
 * Define
 **************************************************/
/* PUBLIC SCHEDULE VIEW */
Ext.define('nbox.main.groupwareContentsScheduleView', {
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	}, 
	border: false,
	margin: '5 0 0 5',
	
	/*layout:{
		type: 'fit'
	},*/
	
	loadMask:false,
	autoScroll: true,
	
	itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    
    store: groupwareContentsScheduleStore,
	
	initComponent: function(){
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<div>',
				'<table>',
			        '<tpl for=".">',
			        	'<tr>',
			        		'<td>',
			        			'<span class="nbox-feed-sel-item">',
			        				'<img src = "' + CPATH + '/resources/images/nbox/main/pin-{calendarId}.gif" width=15 height=15 />&nbsp;',
					        		'<label>{title}</label>',
					        		'<tpl if = "openFlag != \'1\'">',
			        					'&nbsp;<img src = "' + CPATH + '/resources/images/nbox/main/schedule-security3.gif" />',
			        				'</tpl>',
					        	'</span>',
			        		'</td>',
			            '</tr>',
			        '</tpl>',
		        '</table>',
	        '</div>'
		); 	
		
		me.callParent(); 
	},
	listeners: {
        itemclick: function(view, record, item, index, e, eOpts) {
        	var me = this;
           	if(record) {
           		if(record.data.calendarId != 'B' && record.data.calendarId != 'H')
           			me.openDetailWin(NBOX_C_READ, record.data.scheduleId, null);
        	}
    	}
    },
    queryData: function(){
		var me = this;
		var store = me.getStore();
		
		var myPanel = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
		var groupwareContentsCalendarView = myPanel.getRegItems()['ParentContainer'].getRegItems()['GroupwareContentsCalendar'].getRegItems()['GroupwareContentsCalendarView'];
		var selectedDate = groupwareContentsCalendarView.selectedDate;
		
		var groupwareContentsSchedule = me.getRegItems()['ParentContainer'];
		
		if(selectedDate == ''){
			var toDay = new Date()
			selectedDate = toDay.toISOString().slice(0,10).replace(/-/g,"") ; 
		}
		
		var title =  selectedDate.substring(0,4) + '-' + selectedDate.substring(4,6) + '-' + selectedDate.substring(6,8) ;
		myPanel.setTitle(title);
		
		store.proxy.setExtraParam('YYYYMMDD', selectedDate);
		store.load();
	},
	newData: function(){
		var me = this;
		
		var myPanel = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
		var groupwareContentsCalendarView = myPanel.getRegItems()['ParentContainer'].getRegItems()['GroupwareContentsCalendar'].getRegItems()['GroupwareContentsCalendarView'];
		var selectedDate = groupwareContentsCalendarView.selectedDate;
		
		var groupwareContentsSchedule = me.getRegItems()['ParentContainer'];
		
		if(selectedDate == ''){
			var toDay = new Date()
			selectedDate = toDay.toISOString().slice(0,10).replace(/-/g,"") ;
		}
		
		me.openDetailWin(NBOX_C_CREATE, null, selectedDate);
	},
	openDetailWin: function(actionType, scheduleId, selectedDate){
		var me = this;
		
		openScheduleDetailWin(me, actionType, scheduleId, selectedDate);
	}
});

/* SCHEDULE PANEL*/
Ext.define('nbox.main.groupwareContentsSchedulePanel', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	}, 
	border: false,
	margin: '0 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	title: '일정',

	initComponent: function () {
		var me = this;
		
		var groupwareContentsScheduleView = Ext.create('nbox.main.groupwareContentsScheduleView', {});
		
		me.getRegItems()['GroupwareContentsScheduleView'] = groupwareContentsScheduleView;
		groupwareContentsScheduleView.getRegItems()['ParentContainer'] = me;
		
		me.items = [groupwareContentsScheduleView];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		
		var groupwareContentsScheduleView = me.getRegItems()['GroupwareContentsScheduleView'];
		groupwareContentsScheduleView.queryData();
	},
	newData: function(){
		var me = this;
		
		var groupwareContentsScheduleView = me.getRegItems()['GroupwareContentsScheduleView'];
		groupwareContentsScheduleView.newData();
	}
});

/* SCHEDULE TAB */
Ext.define('nbox.main.groupwareContentsScheduleTab', {
	extend: 'Ext.tab.Panel',
	config: {
		regItems: {}
	}, 
	border: false,
	margin: '0 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	tabPosition : 'bottom',
	
	initComponent: function () {
		var me = this;
		
		var groupwareContentsSchedulePanel = Ext.create('nbox.main.groupwareContentsSchedulePanel', {});
		
		me.getRegItems()['GroupwareContentsSchedulePanel'] = groupwareContentsSchedulePanel;
		groupwareContentsSchedulePanel.getRegItems()['ParentContainer'] = me;
		
		
		me.items = [groupwareContentsSchedulePanel];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;
		
		var groupwareContentsSchedulePanel = me.getRegItems()['GroupwareContentsSchedulePanel'];
		
		groupwareContentsSchedulePanel.queryData();
	},
	newData: function(){
		var me = this;
		var panel = me.getActiveTab();
		
		panel.newData();
	}
});

/* SCHEDULE PANEL */
Ext.define('nbox.main.groupwareContentsSchedule', {
	extend: 'Ext.panel.Panel',
	id: 'groupwareContentsSchedule',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '2 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	title: '일정',
	
	tools:[
	  { 	type : 'plus',
		  	tooltip: '추가',
		  	handler: function(event, toolEl, panel){
		    	var me = panel.up('panel');
		    	me.newData();
		    }
	  },   
	  {
		    type:'refresh',
		    tooltip: '새로고침',
		    handler: function(event, toolEl, panel){
		    	var me = panel.up('panel');
		    	me.queryData();
		    }	
	  }
	],	
	
	initComponent: function(){
		var me = this;
		
		/*var title = '일정';
		var type = 8;
		
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
        };*/
		
		var groupwareContentsScheduleTab = Ext.create('nbox.main.groupwareContentsScheduleTab', {});
		
		me.getRegItems()['GroupwareContentsScheduleTab'] = groupwareContentsScheduleTab;
		groupwareContentsScheduleTab.getRegItems()['ParentContainer'] = me;
			
		me.items = [/*title,*/ groupwareContentsScheduleTab]
		
		me.callParent(); 
	},
	queryData: function(){
		var me = this;
		
		var groupwareContentsScheduleTab = me.getRegItems()['GroupwareContentsScheduleTab'];
		groupwareContentsScheduleTab.queryData();
	},
	newData: function(){
		var me = this;
		
		var groupwareContentsScheduleTab = me.getRegItems()['GroupwareContentsScheduleTab'];
		groupwareContentsScheduleTab.newData();
	}
});

/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	