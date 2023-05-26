/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.main.groupwareContentsMyJobModel', {
    extend: 'Ext.data.Model',
    fields: [
		 {name: 'cnt'}
		,{name: 'prgName'}
		,{name: 'imgName'}
		,{name: 'compcode'}
      	,{name: 'prgID'}
		,{name: 'text'}
		,{name: 'text_en'}
		,{name: 'text_cn'}
		,{name: 'text_jp'}
		,{name: 'url'}
		,{name: 'qtip', convert: function(value, record) {return record.get('text'+CUR_LANG_SUFFIX);}}
		,{name: 'box'}
		,{name: 'contentID'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.main.groupwareContentsMyJobStore1', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsMyJobModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
		        api   : {
		        			read: 'groupwareContentsService.selectMyJob1' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

Ext.define('nbox.main.groupwareContentsMyJobStore2', {
	extend  : 'Ext.data.Store', 
	model   : 'nbox.main.groupwareContentsMyJobModel',
	autoLoad: false,
	proxy   : {
				type  : 'direct',
		        api   : {
		        			read: 'groupwareContentsService.selectMyJob2' 
		        		},
		        reader: {
		        			type: 'json',
		                    root: 'records'
		                 }
          	   }
});

var groupwareContentsMyJobStore1 = Ext.create('nbox.main.groupwareContentsMyJobStore1', {});
var groupwareContentsMyJobStore2 = Ext.create('nbox.main.groupwareContentsMyJobStore2', {});

/**************************************************
 * Define
 **************************************************/
/* JOB VIEW */
Ext.define('nbox.main.groupwareContentsMyJobView1', {
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '0 0 0 0',
	
	loadMask:false,
	
	/*style: {
		'padding': '0px 0px 0px 0px',
		'border-top': '1px solid #C0C0C0'
	},*/
	
	itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    
    store: groupwareContentsMyJobStore1,
	
	initComponent: function(){
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<div>',
				'<table style="border-bottom:1px solid #C0C0C0;" width="100%">',
			        '<tpl for=".">', 
	            		'<tr><td><td></tr>',
						'<tr>',
							'<td width="15px"></td>',
							'<td width="100px">',
								'<span class="nbox-feed-sel-item">',
									'<table>',
										'<tr>',
											'<td width="10px"><img src = "' + CPATH + '/resources/images/nbox/{imgName}" width=15 height=15 /></td>',
											'<td width="150px">&nbsp;{prgName}</td>',
											'<td width="40px">&nbsp;{cnt}</td>',
										'</tr>',
									'</table>',
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
        	var panel = Ext.getCmp(record.data.contentID) ;
	  		if (typeof panel !== "undefined" )
	  			panel.expand();
        	
    		var url = record.data.url ; 
    		var params = {
   	  			 'prgID' : record.data.prgID
   	  			,'prgName' : record.get('text'+CUR_LANG_SUFFIX)
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

Ext.define('nbox.main.groupwareContentsMyJobView2', {
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	}, 
	border: true,
	margin: '0 0 0 0',
	
	loadMask:false,
	
	itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    
    store: groupwareContentsMyJobStore2,
	
	initComponent: function(){
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<div>',
				'<table style="border-bottom:1px solid #C0C0C0;" width="100%">',
					
			        '<tpl for=".">', 
						'<tr>',
							'<td width="15px"></td>',
							'<td width="100px">',
								'<span class="nbox-feed-sel-item">',
									'<table>',
										'<tr>',
											'<td width="10px"><img src = "' + CPATH + '/resources/images/nbox/{imgName}" width=15 height=15 /></td>',
											'<td width="150px">&nbsp;{prgName}</td>',
											'<td width="40px">&nbsp;{cnt}</td>',
										'</tr>',
									'</table>',
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
        	var panel = Ext.getCmp(record.data.contentID) ;
	  		if (typeof panel !== "undefined" )
	  			panel.expand();
        	
    		var url = record.data.url ; 
    		var params = {
   	  			 'prgID' : record.data.prgID
   	  			,'prgName' : record.get('text'+CUR_LANG_SUFFIX)
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

/* JPB PANEL */
Ext.define('nbox.main.groupwareContentsMyJob', {
	extend: 'Ext.panel.Panel',
	id: 'groupwareContentsMyJob',
	config: {
		regItems: {}
	}, 
	border: true,
	padding: '2 0 0 0',
	
	layout:{
		type: 'vbox',
		align: 'stretch'
	},
	
	title: '나의업무',
	
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
		
		/*var title = '나의업무';
		var type = 5;
		
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
		
		var groupwareContentsMyJobView1 = Ext.create('nbox.main.groupwareContentsMyJobView1', {
		});
		var groupwareContentsMyJobView2 = Ext.create('nbox.main.groupwareContentsMyJobView2', {
		});
		
		me.getRegItems()['GroupwareContentsMyJobView1'] = groupwareContentsMyJobView1;
		groupwareContentsMyJobView1.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['GroupwareContentsMyJobView2'] = groupwareContentsMyJobView2;
		groupwareContentsMyJobView2.getRegItems()['ParentContainer'] = me;
		
		me.items = [/*title, */groupwareContentsMyJobView1, groupwareContentsMyJobView2];
		
		me.callParent(); 
	},
	queryData: function(){
		var me = this;
		var groupwareContentsMyJobView1 = me.getRegItems()['GroupwareContentsMyJobView1'];
		var groupwareContentsMyJobView2 = me.getRegItems()['GroupwareContentsMyJobView2'];
		
		groupwareContentsMyJobView1.queryData();
		groupwareContentsMyJobView2.queryData();
	}
});

/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	