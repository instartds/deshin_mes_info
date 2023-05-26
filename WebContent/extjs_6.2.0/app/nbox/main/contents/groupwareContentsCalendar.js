/**************************************************
 * Common variable
 **************************************************/
var lgcurrSelectDiv = null;

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.main.groupwareContentsCalendarModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'nType'},
		{name: 'nRow'}, 
		{name: 'nCol'},
		{name: 'nMonth'},
		{name: 'nDay'},
		{name: 'nDate'},
		{name: 'nToday'}
    ]
});


/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.main.groupwareContentsCalendarStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsCalendarModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
		        api   : {
		        			read: 'groupwareContentsService.selectCalendar' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

var groupwareContentsCalendarStore = Ext.create('nbox.main.groupwareContentsCalendarStore', {});
/**************************************************
 * Define
 **************************************************/
Ext.define('nbox.main.groupwareContentsCalendarView',{
	extend: 'Ext.view.View',
	
	config: {
		regItems: {}
	},
	
	border: true,
	margin: '0 0 0 0',
	
	style: {
		'border-bottom': '1px solid #C0C0C0'
	},
	
	loadMask: false,
	
	itemSelector: '.nbox-calendar-feed-sel-item',
    selectedItemCls: 'nbox-calendar-feed-seled-item', 
    
    store: groupwareContentsCalendarStore,
	
	daysOfWeek: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
	toMonth: '',
	selectedDate: '',
	
	initComponent: function(){
		var me = this;
        me.tpl = new Ext.XTemplate();
        
        me.callParent(); 
	},
	listeners: {
	    itemclick: function(view, record, item, index, e, eOpts) {
			var me = this;
			var headerType = record.data.nType;
			
			switch(headerType){
				case 'H':
					me.toMonth = record.data.nDate.substring(0,6);
					me.queryData();
						
					break;
				case 'D':
					var parentDiv = item.parentElement;
					
					if (!parentDiv) return;
					
					if (lgcurrSelectDiv)
						lgcurrSelectDiv.style.backgroundColor = '';
					
					parentDiv.style.backgroundColor = '#d1e61a';
					lgcurrSelectDiv = parentDiv;
					
					me.selectedDate = record.data.nDate;
					
					groupwareContentsSchedulePanel = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['GroupwareContentsSchedule'];
					groupwareContentsSchedulePanel.queryData();			
					
					break;
				default:
					break;
			}
		}
	},
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		var month = me.toMonth;
		store.proxy.setExtraParam('YYYYMM', month);
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
		
		var htmlData = [];
        htmlData.push("<table width='100%' height='100%' cellspacing='0'>");
        htmlData.push("<thead>");
        htmlData.push("<tr height='30px'>");
        htmlData.push('<tpl for=".">');
        htmlData.push('<tpl if="nType==\'H\'":>');
        htmlData.push('<tpl if="nCol==0">');
        htmlData.push('<th><span class="nbox-calendar-feed-sel-item"><<</span></th>');
        htmlData.push('</tpl>');
        htmlData.push('<tpl if="nCol==1">');
        htmlData.push("<th colspan='5'><span class='nbox-calendar-feed-sel-item'>{nMonth}</span></th>");
        htmlData.push('</tpl>');
        htmlData.push('<tpl if="nCol==2">');
        htmlData.push('<th><span class="nbox-calendar-feed-sel-item">>></span></th>');
        htmlData.push('</tpl>');
        htmlData.push('</tpl>');
        htmlData.push('</tpl>');
        htmlData.push('</th></tr>');
        htmlData.push('</thead>');
        htmlData.push('<tbody>');
        
        /*<tr height='25px' style='background-repeat: repeat; background-image: url('/g3erp/resources/images/nbox/title-background.png') ;'>*/

        htmlData.push("<tr height='20px'>");
        var daysOfWeek = me.daysOfWeek;
        for (var i = 0; i < 7; i++) {
            var width = i == 0 || i == 6 ? 15 : 14;
            var fStyle = '';
            
            if(i==0)
            	fStyle = 'color:red;';
            
            if(i==6)
            	fStyle = 'color:blue;';
            
            htmlData.push('<td align="center" width="' + width + '%"><div style="font-weight:bold;' + fStyle + '" >' + daysOfWeek[i] + '</div></td>');
        }
        htmlData.push('</tr>');

        htmlData.push('<tpl for=".">');
        htmlData.push('<tpl if="nType==\'D\'":>');
        htmlData.push('<tpl if="nCol==0">');
        htmlData.push('<tr>');
        htmlData.push('</tpl>');
        htmlData.push('<td align="center">');
        htmlData.push('<div style="width: 20px;');
        htmlData.push('<tpl if="nCol==0">color: red;</tpl>');
        htmlData.push('<tpl if="nToday==1">text-decoration: underline;</tpl>');
        htmlData.push('<tpl if="nCol==6">color: blue;</tpl>');
        htmlData.push('"><span class="nbox-calendar-feed-sel-item">{nDay}</span></div>');
        htmlData.push('</td>');
        htmlData.push('<tpl if="nCol==6">');
        htmlData.push('</tr>');
        htmlData.push('</tpl>');
        htmlData.push('</tpl>');
        htmlData.push('</tpl>');
        htmlData.push('</tbody>');
        htmlData.push('</table>');
        
        var htmlString = "";
        
        for(var i=0; i<htmlData.length; i++)
        	htmlString += htmlData[i] + ' ';
        
        me.tpl = new Ext.XTemplate(
        	htmlString
    	);
		
		me.refresh();
	}
});



/* CALENDAR PANEL */
Ext.define('nbox.main.groupwareContentsCalendar', {
	extend: 'Ext.panel.Panel',
	id: 'groupwareContentsCalendar',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '2 0 0 0',
	
	title: '달력',
	
	tools:[{
	    type:'refresh',
	    tooltip: '새로고침',
	    handler: function(event, toolEl, panel){
	    	var me = panel.up('panel');
	    	me.queryData();
	    }
	}],	
	
	layout:{
		type: 'vbox',
    	align: 'stretch'
	},

	initComponent: function(){
		var me = this;
		
		/*var title = '달력';
		var type = 7;
		
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
		
		var groupwareContentsCalendarView = Ext.create('nbox.main.groupwareContentsCalendarView',{
			/*height: 159*/
			/*height: 190*/
			flex: 1
		});
		
/*		var groupwareContentsScheduleView = Ext.create('nbox.main.groupwareContentsScheduleView', {
			flex: 1
		});*/
		
		me.getRegItems()['GroupwareContentsCalendarView'] = groupwareContentsCalendarView;
		groupwareContentsCalendarView.getRegItems()['ParentContainer'] = me;
		
		/*me.getRegItems()['GroupwareContentsScheduleView'] = groupwareContentsScheduleView;
		groupwareContentsScheduleView.getRegItems()['ParentContainer'] = me;*/
		
		me.items = [/*title,*/groupwareContentsCalendarView/*, groupwareContentsScheduleView*/];
		me.callParent(); 
	},
	queryData: function(){
		var me = this;
		var groupwareContentsCalendarView = me.getRegItems()['GroupwareContentsCalendarView'];
		/*var groupwareContentsScheduleView = me.getRegItems()['GroupwareContentsScheduleView'];*/
		
		groupwareContentsCalendarView.queryData();
		/*groupwareContentsScheduleView.queryData();*/
	}
});


/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	