/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.main.groupwareContentsMyInfoModel', {
    extend: 'Ext.data.Model',
    fields: [
         {name: 'TYPE'}
    	,{name: 'USER_ID'}
    	,{name: 'USER_NAME'}
    	,{name: 'id'}
		,{name: 'compcode'}
      	,{name: 'levStatusImage'}
		,{name: 'prgID'}
		,{name: 'text'}
		,{name: 'url'}
		,{name: 'box'}
		,{name: 'contentID'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.main.groupwareContentsMyInfoStore', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsMyInfoModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
		        api   : {
		        			read: 'groupwareContentsService.selectMyInfo' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

var groupwareContentsMyInfoStore = Ext.create('nbox.main.groupwareContentsMyInfoStore', {});

/**************************************************
 * Define
 **************************************************/
/* INFORMATION VIEW */
Ext.define('nbox.main.groupwareContentsMyInfoView', {
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '0 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
/*	style: {
		'padding': '0px 0px 20px 0px',
		'border-top': '1px solid #C0C0C0'
	},*/
	
	loadMask:false,
	
	itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    
    store: groupwareContentsMyInfoStore,
	
	initComponent: function(){
		var me = this;

		me.tpl = new Ext.XTemplate(
			'<div>&nbsp;</div>',
			'<div>',
		        '<tpl for=".">', 
		            '<span class="nbox-feed-sel-item">',
		            	'<tpl if="TYPE == 1">',
			            	'&nbsp;<label>{USER_NAME}</label>',
			            '</tpl>',
			            '<tpl if="TYPE == 2">',	
			            	'&nbsp;&nbsp;<img src = "' + CPATH + '/resources/images/nbox/{levStatusImage}" width=15 height=15 />',
			            '</tpl>',
		            '</span>',
		        '</tpl>',
	        '</div>'
		); 	
		
		me.callParent(); 
	},
	listeners: {
        itemclick: function(view, record, item, index, e, eOpts) {

        	var panel = Ext.getCmp(record.data.contentID) ;
	  		if (typeof panel !== "undefined" )
	  			panel.expand();
	  		
    		var url = record.data.url ; 
	  		var params = {
	  			 'prgID' : record.data.prgID
	  			,'prgName' : record.get('text')
	  			,'box' : record.data.box
			};
	  		
	  		if (typeof url !== "undefined" )
		  		openTab(record, url, params);
        	 
    	}
    },
	queryData: function(){
		var me = this;
		var store = me.getStore();
		
		store.load();
	}
});

/* INFORMATION PANEL */
Ext.define('nbox.main.groupwareContentsMyInfo', {
	extend: 'Ext.panel.Panel',
	id: 'groupwareContentsMyInfo',
	config: {
		regItems: {}
	}, 
	border: true,
	padding: '0 0 0 0',
	
	layout:{
		type: 'fit'
	},
	
	/*header: false,*/
	
	title: '나의정보',	
	
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
		
		/*var title = '나의정보';
		var type = 4;
		
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
		
		var groupwareContentsMyInfoView = Ext.create('nbox.main.groupwareContentsMyInfoView', {});
		
		me.getRegItems()['GroupwareContentsMyInfoView'] = groupwareContentsMyInfoView;
		groupwareContentsMyInfoView.getRegItems()['ParentContainer'] = me;
		
		me.items = [/*title, */groupwareContentsMyInfoView];
		
		me.callParent(); 
	},
	queryData: function(){
		var me = this;
		
		var groupwareContentsMyInfoView = me.getRegItems()['GroupwareContentsMyInfoView']
		groupwareContentsMyInfoView.queryData();
	}
});

/**************************************************
 * Create
 **************************************************/


/**************************************************
 * User Define Function
 **************************************************/	