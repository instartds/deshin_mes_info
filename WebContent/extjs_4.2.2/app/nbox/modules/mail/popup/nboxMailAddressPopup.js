/**************************************************
 * Common variable
 **************************************************/
//local  variable
var mailAddressPopupWin ;
var mailAddressPopupWinWidth = 600;
var mailAddressPopupWinHeight = 500;

/**************************************************
 * Common Code
 **************************************************/

/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.mail.popup.mailAddressGridModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'ContactID'},
    	{name: 'ContactName'}
    ]
});

Ext.define('nbox.mail.popup.mailAddressDeptTreeModel', {
    extend: 'Ext.data.Model',
    fields: [
		{name: 'id'},
		{name: 'TREE_CODE'},
    	{name: 'text'},
    	{name: 'DeptType'},
    	{name: 'UserName'},
    	{name: 'UserDeptID'},
    	{name: 'UserDeptName'},
    	{name: 'UserPosName'},
    	{name: 'ContactName'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.mail.popup.mailAddressGrid1Store', {
	extend: 'Ext.data.Store',
	model: 'nbox.mail.popup.mailAddressGridModel',
	autoLoad: true,
	proxy: {
        type: 'direct',
        api: { read: 'nboxContactService.selectAddress' },
        reader: {
            type: 'json',
            root: 'records'
        }
    },
    listeners: {
	  	beforeload: function(store, operation, eOpts) {
	  		var me = this;
			var proxy = me.getProxy();
			
			proxy.setExtraParam('MENUID', '8000001');
		}
  	}
});

Ext.define('nbox.mail.popup.mailAddressGrid2Store', {
	extend: 'Ext.data.Store',
	model: 'nbox.mail.popup.mailAddressGridModel',
	autoLoad: true,
	proxy: {
        type: 'direct',
        api: { read: 'nboxContactService.selectAddress' },
        reader: {
            type: 'json',
            root: 'records'
        }
    },
    listeners: {
	  	beforeload: function(store, operation, eOpts) {
	  		var me = this;
			var proxy = me.getProxy();
			
			proxy.setExtraParam('MENUID', '8000002');
		}
  	}
});

Ext.define('nbox.mail.popup.mailAddressDeptTreeStore', {
	extend: 'Ext.data.TreeStore',
	model: 'nbox.mail.popup.mailAddressDeptTreeModel',
	autoLoad: true,
	proxy: {
        type: 'direct',
        api: {
            read : 'nboxDocCommonService.selectDeptTree'
        }
    }  
});

Ext.define('nbox.mail.popup.mailAddressToStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.mail.popup.mailAddressGridModel',
	autoLoad: false,
	copyStoreData: function(store){
		var me = this;
    	var records = [];
    	
    	store.each(function(r){
    		records.push(r.copy());	
		});
		
		me.add(records);
	},
    copyRecordsData: function(records){
    	var me = this;
		me.add(records);
    }
});

Ext.define('nbox.mail.popup.mailAddressCcStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.mail.popup.mailAddressGridModel',
	autoLoad: false,
	copyStoreData: function(store){
		var me = this;
    	var records = [];
    	
    	store.each(function(r){
    		records.push(r.copy());	
		});
		
		me.add(records);
	},
    copyRecordsData: function(records){
    	var me = this;
		me.add(records);
    }
});

Ext.define('nbox.mail.popup.mailAddressBccStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.mail.popup.mailAddressGridModel',
	autoLoad: false,
	copyStoreData: function(store){
		var me = this;
    	var records = [];
    	
    	store.each(function(r){
    		records.push(r.copy());	
		});
		
		me.add(records);
	},
    copyRecordsData: function(records){
    	var me = this;
		me.add(records);
    }
});

/**************************************************
 * Define
 **************************************************/
//Address Grid1
Ext.define('nbox.mail.popup.mailAddressGrid1',  {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	
	border: false,
	flex: 1,
	
	style: {
		'border': '1px solid #C0C0C0',
    	'border-top': 'none'
    },
    
    hideHeaders: true,
    
    initComponent: function () {
    	var me = this;
    	
    	me.columns= [
			{
	        	sortable: true,
	            dataIndex: 'ContactName',
	            groupable: false,
	            flex: 1,
	            renderer: function(value){
	            	return value.replace('<', '(').replace('>', ')');
			    }
	        }
		];
    	
       	me.callParent();
    },
    listeners: {
    	itemdblclick: function(obj, record, item, index, e) {
    		var me = this;
    		var panel = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
    		var mailAddressToPanel = panel.getRegItems()['MailAddressPopupPanel'].getRegItems()['MailAddressToLayoutPanel'];
    		
    		mailAddressToPanel.addData();
        }
    },
    queryData: function(){
    	var me = this;
    	var store = me.getStore();
    	
    	me.clearData();
    	
    	var parentContainer = me.getRegItems()['ParentContainer'];
    	var searchPanel = parentContainer.items.getAt(0);
    	var searchText = searchPanel.items.getAt(0);
    	
    	store.proxy.setExtraParam('CONTACTSEARCHTEXT', searchText.getValue());
		store.load();
    },
	clearData: function(){
		var me = this;
    	var store = me.getStore();
    	
    	store.removeAll();
    }
});

//Address Grid2
Ext.define('nbox.mail.popup.mailAddressGrid2',  {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	
	border: false,
	flex: 1,
	
	style: {
		'border': '1px solid #C0C0C0',
    	'border-top': 'none'
    },
    
    hideHeaders: true,
	
    initComponent: function () {
    	var me = this;
    	
    	me.columns= [
			{
	        	sortable: true,
	            dataIndex: 'ContactName',
	            groupable: false,
	            flex: 1,
	            renderer: function(value){
	            	return value.replace('<', '(').replace('>', ')');
			    }
	        }
		];
    	
       	me.callParent();
    },
    listeners: {
    	itemdblclick: function(obj, record, item, index, e) {
    		var me = this;
    		var panel = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
    		var mailAddressToPanel = panel.getRegItems()['MailAddressPopupPanel'].getRegItems()['MailAddressToLayoutPanel'];
    		
    		mailAddressToPanel.addData();
        }
    },
    queryData: function(){
    	var me = this;
    	var store = me.getStore();
    	
    	me.clearData();
    	
    	var parentContainer = me.getRegItems()['ParentContainer'];
    	var searchPanel = parentContainer.items.getAt(0);
    	var searchText = searchPanel.items.getAt(0);
    	
    	store.proxy.setExtraParam('CONTACTSEARCHTEXT', searchText.getValue());
		store.load();
    },
	clearData: function(){
		var me = this;
    	var store = me.getStore();
    	
    	store.removeAll();
    }
});

// Dept Tree
Ext.define("nbox.mail.popup.mailAddressDeptTree",{
	extend: 'Ext.tree.Panel',
	config: {
		regItems: {}    	
	},
	cls: "doc-tree iScroll",
	useArrows: false,
	animCollapse: true,
	animate: true,
	rootVisible: false,
	bodyBorder: false,
	
	border: false,
	flex: 1,
	
	rowLines: false, lines: false,
	scroll: 'vertical',
	
	style: {
		'border': '1px solid #C0C0C0'
    },
	
	listeners: {
		itemdblclick: function( t, record, item, index, e, eOpts ){
			
			var me = this;
    		var panel = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
    		var mailAddressToPanel = panel.getRegItems()['MailAddressPopupPanel'].getRegItems()['MailAddressToLayoutPanel'];
    		
    		mailAddressToPanel.addData();
			
			/*if (record.data.id !== "" )  {
	  			var me = this;
	  			
	  			var activePanel = me.getRegItems()['ParentContainer'].getRegItems()['DocLinePopupTab'].getActiveTab();
	  			var grid = activePanel.down('grid'); 
	  			
	  			grid.addData(record);
	  	    }*/
		} 
	} 
});	 
	
// To Grid
Ext.define('nbox.mail.popup.mailAddressToGrid',  {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	
	border: false,
	flex: 1,
	
	style: {
		'border': '1px solid #C0C0C0',
    	'border-top': 'none'
    },
    
    hideHeaders: true,
	
    initComponent: function () {
    	var me = this;
    	
    	me.columns= [
	        {
	        	sortable: true,
	            dataIndex: 'ContactName',
	            groupable: false,
	            flex: 1,
	            renderer: function(value){
	            	return value.replace('<', '(').replace('>', ')');
			    }
	        }
		];
    	
       	me.callParent();
    },
    listeners: {
    	itemdblclick: function(obj, record, item, index, e) {
    		var me = this;
    		var panel = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
    		
    		panel.deleteData();
        }
    }
});

//Cc Grid
Ext.define('nbox.mail.popup.mailAddressCcGrid',  {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	
	border: false,
	flex: 1,
	
	style: {
		'border': '1px solid #C0C0C0',
    	'border-top': 'none'
    },
    
    hideHeaders: true,
	
    initComponent: function () {
    	var me = this;
    	
    	me.columns= [
	        {
	        	sortable: true,
	            dataIndex: 'ContactName',
	            groupable: false,
	            flex: 1,
	            renderer: function(value){
	            	return value.replace('<', '(').replace('>', ')');
			    }
	        }
		];
    	
       	me.callParent();
    },
    listeners: {
    	itemdblclick: function(obj, record, item, index, e) {
    		var me = this;
    		var panel = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
    		
    		panel.deleteData();
        }
    }
});

//Bcc Grid
Ext.define('nbox.mail.popup.mailAddressBccGrid',  {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	
	border: false,
	flex: 1,
	
	style: {
		'border': '1px solid #C0C0C0',
    	'border-top': 'none'
    },
    
    hideHeaders: true,
	
    initComponent: function () {
    	var me = this;
    	
    	me.columns= [
	        {
	        	sortable: true,
	            dataIndex: 'ContactName',
	            groupable: false,
	            flex: 1,
	            renderer: function(value){
	            	return value.replace('<', '(').replace('>', ')');
			    }
	        }
		];
    	
       	me.callParent();
    },
    listeners: {
    	itemdblclick: function(obj, record, item, index, e) {
    		var me = this;
    		var panel = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
    		
    		panel.deleteData();
        }
    }
});

Ext.define('nbox.mail.popup.mailAddressPanel1', {
	extend: 'Ext.panel.Panel',

	config: {
		regItems: {}    	
	},

	layout: {
        type: 'vbox',
		align: 'stretch' 
        
    },
    
    padding: '10 10 10 10',
    
    bodyCls: 'nbox-x-panel-body',
    title: '회사주소록',
    
    initComponent: function () {
    	var me = this;
    	
    	var btnSearch = {
		 	xtype: 'button', scale: 'medium',
		 	tooltip : '검색',
		 	text: '검색', 
            /*width: 40,  */height: 23,
            
            handler: function() { 
            	me.SearchButtonDown();
            }
		};    	
    	
    	var searchPanel = { 
        	xtype: 'panel',
		  	border: false,
		  	layout: 'hbox',
		  	padding: '0 0 7 0',
		  	items: [
		  	{ 
			  	xtype: 'textfield',
			  	name: 'SEARCHTEXT' ,
			  	width: 180
		  	},
		  	btnSearch
		  	]	
        };
    	
    	var mailAddressGrid1Store = Ext.create('nbox.mail.popup.mailAddressGrid1Store',{});
    	var mailAddressGrid1 = Ext.create('nbox.mail.popup.mailAddressGrid1',{
    		store: mailAddressGrid1Store
    	});
    	
    	me.getRegItems()['MailAddressGrid1'] = mailAddressGrid1;
    	mailAddressGrid1.getRegItems()['ParentContainer'] = me;
    	
    	me.items=[searchPanel, mailAddressGrid1];
    	me.callParent();
    },
    SearchButtonDown: function(){
    	var me = this;
    	
    	me.queryData();
    },
    queryData: function(){
    	var me = this;
    	var mailAddressGrid1 = me.getRegItems()['MailAddressGrid1'];
    	
    	mailAddressGrid1.queryData();
    }
});

Ext.define('nbox.mail.popup.mailAddressPanel2', {
	extend: 'Ext.panel.Panel',

	config: {
		regItems: {}    	
	},

	layout: {
        type: 'vbox',
		align: 'stretch' 
        
    },
    
    padding: '10 10 10 10',
    
    bodyCls: 'nbox-x-panel-body',
    title: '개인주소록',
    
    initComponent: function () {
    	var me = this;
    	
    	var btnSearch = {
		 	xtype: 'button', scale: 'medium',
		 	tooltip : '검색',
		 	text: '검색', 
            /*width: 40,  */height: 23,
            
            handler: function() { 
            	me.SearchButtonDown();
            }
		};    	
    	
    	var searchPanel = { 
        	xtype: 'panel',
		  	border: false,
		  	layout: 'hbox',
		  	padding: '0 0 7 0',
		  	items: [
		  	{ 
			  	xtype: 'textfield',
			  	name: 'SEARCHTEXT' ,
			  	width: 180
		  	},
		  	btnSearch
		  	]	
        };
    	
    	var mailAddressGrid2Store = Ext.create('nbox.mail.popup.mailAddressGrid2Store',{});
    	var mailAddressGrid2 = Ext.create('nbox.mail.popup.mailAddressGrid2',{
    		store: mailAddressGrid2Store
    	});
    	
    	me.getRegItems()['MailAddressGrid2'] = mailAddressGrid2;
    	mailAddressGrid2.getRegItems()['ParentContainer'] = me;
    	
    	me.items=[searchPanel, mailAddressGrid2];
    	me.callParent();
    },
    SearchButtonDown: function(){
    	var me = this;
    	
    	me.queryData();
    },
    queryData: function(){
    	var me = this;
    	var mailAddressGrid2 = me.getRegItems()['MailAddressGrid2'];
    	
    	mailAddressGrid2.queryData();
    }
});

Ext.define('nbox.mail.popup.mailAddressPanel3', {
	extend: 'Ext.panel.Panel',

	config: {
		regItems: {}    	
	},

	layout: {
        type: 'vbox',
		align: 'stretch' 
        
    },
    
    padding: '10 10 10 10',
    
    bodyCls: 'nbox-x-panel-body',
    title: '조직도',
    
    initComponent: function () {
    	var me = this;
    	
    	var btnSearch = {
		 	xtype: 'button', scale: 'medium',
		 	tooltip : '검색',
		 	text: '검색', 
            /*width: 40,  */height: 23,
            
            handler: function() { 
            	me.SearchButtonDown();
            }
		};
    	
    	var searchPanel = { 
        	xtype: 'panel',
		  	border: false,
		  	layout: 'hbox',
		  	padding: '0 0 7 0',
		  	items: [
		  	{ 
			  	xtype: 'textfield',
			  	name: 'SEARCHTEXT' ,
			  	width: 180
		  	},
		  	btnSearch
		  	]	
        };
    	
    	var mailAddressDeptTreeStore = Ext.create('nbox.mail.popup.mailAddressDeptTreeStore', {});
        var mailAddressDeptTree = Ext.create('nbox.mail.popup.mailAddressDeptTree',{
			store: mailAddressDeptTreeStore
		});
    	
        mailAddressDeptTree.expandAll();
    	
    	var mailAddressGrid2Store = Ext.create('nbox.mail.popup.mailAddressGrid2Store',{});
    	var mailAddressGrid2 = Ext.create('nbox.mail.popup.mailAddressGrid2',{
    		store: mailAddressGrid2Store
    	});
    	
    	me.getRegItems()['MailAddressDeptTree'] = mailAddressDeptTree;
    	mailAddressDeptTree.getRegItems()['ParentContainer'] = me;
    	
    	me.items=[searchPanel, mailAddressDeptTree];
    	me.callParent();
    },
    SearchButtonDown: function(){
    	var me = this;
    	
    	me.queryData();
    },
    queryData: function(){
    	var me = this;
    	var mailAddressGrid2 = me.getRegItems()['MailAddressGrid2'];
    	
    	mailAddressGrid2.queryData();
    }
});

	
//Tab Panel
Ext.define('nbox.mail.popup.mailAddressPopupTab', {
	extend: 'Ext.tab.Panel',
	config: {
		regItems: {}    	
	},
	
    flex:1,
    border: false,
    
    initComponent: function () {
    	var me = this;
    	
    	var mailAddressPanel1 = Ext.create('nbox.mail.popup.mailAddressPanel1', {});
    	var mailAddressPanel2 = Ext.create('nbox.mail.popup.mailAddressPanel2', {});
    	var mailAddressPanel3 = Ext.create('nbox.mail.popup.mailAddressPanel3', {});
    	
    	me.getRegItems()['MailAddressPanel1'] = mailAddressPanel1;
    	mailAddressPanel1.getRegItems()['ParentContainer'] = me;
    	
    	me.getRegItems()['MailAddressPanel2'] = mailAddressPanel2;
    	mailAddressPanel2.getRegItems()['ParentContainer'] = me;
    	
    	me.getRegItems()['MailAddressPanel3'] = mailAddressPanel3;
    	mailAddressPanel3.getRegItems()['ParentContainer'] = me;
    	
    	me.items = [mailAddressPanel1, mailAddressPanel2, mailAddressPanel3];
    	me.callParent();
    }  

});

Ext.define('nbox.mail.popup.mailAddressBlankPanel', {
	extend: 'Ext.panel.Panel',
    height: 50,
    border: false
});

Ext.define('nbox.mail.popup.mailAddressToPanel', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}    	
	},
    
    layout: {
        type: 'vbox',
		align: 'stretch' 
    },
    
    flex: 1,
    
    border: false,
    
    initComponent: function () {
    	var me = this;
    	
    	var mailAddressToStore = Ext.create('nbox.mail.popup.mailAddressToStore', {});
    	var mailAddressToGrid = Ext.create('nbox.mail.popup.mailAddressToGrid', {
    		store: mailAddressToStore
    	});
    	
    	me.getRegItems()['MailAddressToGrid'] = mailAddressToGrid;
    	mailAddressToGrid.getRegItems()['ParentContainer'] = me;
    	
    	me.items=[
    	{
            xtype: 'label',
            forId: 'myFieldId',
            text: '받는사람',
        }, mailAddressToGrid];
    	
    	me.callParent();
    }
});

Ext.define('nbox.mail.popup.mailAddressCcPanel', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}    	
	},
	layout: {
        type: 'vbox',
		align: 'stretch' 
    },
    flex: 1,
    
    border: false,
    
    initComponent: function () {
    	var me = this;
    	
    	var mailAddressCcStore = Ext.create('nbox.mail.popup.mailAddressCcStore', {});
    	var mailAddressCcGrid = Ext.create('nbox.mail.popup.mailAddressCcGrid', {
    		store: mailAddressCcStore
    	});
    	
    	me.getRegItems()['MailAddressCcGrid'] = mailAddressCcGrid;
    	mailAddressCcGrid.getRegItems()['ParentContainer'] = me;
    	
    	me.items=[
    	{
            xtype: 'label',
            forId: 'myFieldId',
            text: '참조',
        }, mailAddressCcGrid];
    	
    	me.callParent();
    }
});

Ext.define('nbox.mail.popup.mailAddressBccPanel', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}    	
	},
	layout: {
        type: 'vbox',
		align: 'stretch' 
    },
    flex: 1,
    
    border: false,
    
    initComponent: function () {
    	var me = this;
    	
    	var mailAddressBccStore = Ext.create('nbox.mail.popup.mailAddressBccStore', {});
    	var mailAddressBccGrid = Ext.create('nbox.mail.popup.mailAddressBccGrid', {
    		store: mailAddressBccStore
    	});
    	
    	me.getRegItems()['MailAddressBccGrid'] = mailAddressBccGrid;
    	mailAddressBccGrid.getRegItems()['ParentContainer'] = me;
    	
    	me.items=[
    	{
            xtype: 'label',
            forId: 'myFieldId',
            text: '숨은참조',
        }, mailAddressBccGrid];
    	
    	me.callParent();
    }
});

Ext.define('nbox.mail.popup.mailAddressToLayoutPanel', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}    	
	},
    
    layout: {
        type: 'hbox',
		align: 'stretch' 
    },
    padding: '0 10 0 0',
    flex: 1,
    
    border: false,
    
    initComponent: function () {
    	var me = this;
    	
    	var btnAdd = {
			xtype: 'button',
			text: '추가', 
			tooltip : '추가',
               
			handler: function() { 
				me.AddButtonDown();
			}
        };
    	
    	var btnDel = {
			xtype: 'button',
			text: '삭제', 
			tooltip : '삭제',
               
			handler: function() { 
				me.DeleteButtonDown();
			}
        };
    	
    	var panel = Ext.create('Ext.panel.Panel',{
    		layout: {
    	        type: 'vbox' 
    	    },
    	    border: false,
    	    padding: '40 10 0 0',
    	    
    	    items:[btnAdd, btnDel]
    	});
    	
    	var mailAddressToPanel = Ext.create('nbox.mail.popup.mailAddressToPanel', {});
    	
    	me.getRegItems()['MailAddressToPanel'] = mailAddressToPanel;
    	mailAddressToPanel.getRegItems()['ParentContainer'] = me;
    	
    	me.items=[panel, mailAddressToPanel];
    	me.callParent();
    },
    AddButtonDown: function(){
    	var me = this;
    	
    	me.addData();
    },
    DeleteButtonDown: function(){
    	var me = this;
    	
    	me.deleteData();
    },
    addData: function(){
    	var me = this;
    	
    	var tab = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['MailAddressPopupTab'];
    	var targetGrid = me.getRegItems()['MailAddressToPanel'].getRegItems()['MailAddressToGrid'];
    	
    	var sourceGrid = tab.activeTab.down('grid');
    	var sourceTree = tab.activeTab.down('treeview');
    	var selectedRecords = null;
    	
    	if(sourceGrid != null)
    		selectedRecords = sourceGrid.getSelectionModel().getSelection();
    	else
    		selectedRecords = sourceTree.getSelectionModel().getSelection();
    	
    	var records=[];
    	Ext.each(selectedRecords, function(record) {
    		var findRecord = targetGrid.getStore().findRecord('ContactName', record.data.ContactName);
    		if(findRecord == null)
    			records.push(record);
    	});
    	
    	targetGrid.getStore().add(records);
    },
    deleteData: function(){
    	var me = this;
    	var targetGrid = me.getRegItems()['MailAddressToPanel'].getRegItems()['MailAddressToGrid'];
    	var selectedRecords = targetGrid.getSelectionModel().getSelection();
    	
    	targetGrid.getStore().remove(selectedRecords);
    },
    clearData: function(){
    	var me = this;
    	var store = me.getRegItems()['MailAddressToPanel'].getRegItems()['MailAddressToGrid'].getStore();
    	
    	store.removeAll();
    }
});

Ext.define('nbox.mail.popup.mailAddressCcLayoutPanel', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}    	
	},
    
    layout: {
        type: 'hbox',
		align: 'stretch' 
    },
    padding: '5 10 0 0',
    flex: 1,
    
    border: false,
    
    initComponent: function () {
    	var me = this;
    	
    	var btnAdd = {
			xtype: 'button',
			text: '추가', 
			tooltip : '추가',
               
			handler: function() { 
				me.AddButtonDown();
			}
        };
    	
    	var btnDel = {
			xtype: 'button',
			text: '삭제', 
			tooltip : '삭제',
               
			handler: function() { 
				me.DeleteButtonDown();
			}
        };
    	
    	var panel = Ext.create('Ext.panel.Panel',{
    		layout: {
    	        type: 'vbox' 
    	    },
    	    border: false,
    	    padding: '40 10 0 0',
    	    
    	    items:[btnAdd, btnDel]
    	});
    	
    	var mailAddressCcPanel = Ext.create('nbox.mail.popup.mailAddressCcPanel', {});
    	
    	me.getRegItems()['MailAddressCcPanel'] = mailAddressCcPanel;
    	mailAddressCcPanel.getRegItems()['ParentContainer'] = me;
    	
    	me.items=[panel, mailAddressCcPanel];
    	me.callParent();
    },
    AddButtonDown: function(){
    	var me = this;
    	
    	me.addData();
    },
    DeleteButtonDown: function(){
    	var me = this;
    	
    	me.deleteData();
    },
    addData: function(){
    	var me = this;
    	
    	var tab = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['MailAddressPopupTab'];
    	var targetGrid = me.getRegItems()['MailAddressCcPanel'].getRegItems()['MailAddressCcGrid'];
    	
    	var sourceGrid = tab.activeTab.down('grid');
    	var sourceTree = tab.activeTab.down('treeview');
    	var selectedRecords = null;
    	
    	if(sourceGrid != null)
    		selectedRecords = sourceGrid.getSelectionModel().getSelection();
    	else
    		selectedRecords = sourceTree.getSelectionModel().getSelection();
    	
    	var records=[];
    	Ext.each(selectedRecords, function(record) {
    		var findRecord = targetGrid.getStore().findRecord('ContactName', record.data.ContactName);
    		if(findRecord == null)
    			records.push(record);
    	});
    	
    	targetGrid.getStore().add(records);
    },
    deleteData: function(){
    	var me = this;
    	var targetGrid = me.getRegItems()['MailAddressCcPanel'].getRegItems()['MailAddressCcGrid'];
    	var selectedRecords = targetGrid.getSelectionModel().getSelection();
    	
    	targetGrid.getStore().remove(selectedRecords);
    },
    clearData: function(){
    	var me = this;
    	var store = me.getRegItems()['MailAddressCcPanel'].getRegItems()['MailAddressCcGrid'].getStore();
    	
    	store.removeAll();
    }
});

Ext.define('nbox.mail.popup.mailAddressBccLayoutPanel', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}    	
	},
    
    layout: {
        type: 'hbox',
		align: 'stretch' 
    },
    padding: '5 10 10 0',
    flex: 1,
    
    border: false,
    
    initComponent: function () {
    	var me = this;
    	
    	var btnAdd = {
			xtype: 'button',
			text: '추가', 
			tooltip : '추가',
               
			handler: function() { 
				me.AddButtonDown();
			}
        };
    	
    	var btnDel = {
			xtype: 'button',
			text: '삭제', 
			tooltip : '삭제',
               
			handler: function() { 
				me.DeleteButtonDown();
			}
        };
    	
    	var btnPanel = Ext.create('Ext.panel.Panel',{
    		layout: {
    	        type: 'vbox' 
    	    },
    	    border: false,
    	    padding: '40 10 0 0',
    	    
    	    items:[btnAdd, btnDel]
    	});
    	
    	var mailAddressBccPanel = Ext.create('nbox.mail.popup.mailAddressBccPanel', {});
    	
    	me.getRegItems()['MailAddressBccPanel'] = mailAddressBccPanel;
    	mailAddressBccPanel.getRegItems()['ParentContainer'] = me;
    	
    	me.items=[btnPanel, mailAddressBccPanel];
    	me.callParent();
    },
    AddButtonDown: function(){
    	var me = this;
    	
    	me.addData();
    },
    DeleteButtonDown: function(){
    	var me = this;
    	
    	me.deleteData();
    },
    addData: function(){
    	var me = this;
    	
    	var tab = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['MailAddressPopupTab'];
    	var targetGrid = me.getRegItems()['MailAddressBccPanel'].getRegItems()['MailAddressBccGrid'];
    	
    	var sourceGrid = tab.activeTab.down('grid');
    	var sourceTree = tab.activeTab.down('treeview');
    	var selectedRecords = null;
    	
    	if(sourceGrid != null)
    		selectedRecords = sourceGrid.getSelectionModel().getSelection();
    	else
    		selectedRecords = sourceTree.getSelectionModel().getSelection();
    	
    	var records=[];
    	Ext.each(selectedRecords, function(record) {
    		var findRecord = targetGrid.getStore().findRecord('ContactName', record.data.ContactName);
    		if(findRecord == null)
    			records.push(record);
    	});
    	
    	targetGrid.getStore().add(records);
    },
    deleteData: function(){
    	var me = this;
    	var targetGrid = me.getRegItems()['MailAddressBccPanel'].getRegItems()['MailAddressBccGrid'];
    	var selectedRecords = targetGrid.getSelectionModel().getSelection();
    	
    	targetGrid.getStore().remove(selectedRecords);
    },
    clearData: function(){
    	var me = this;
    	var store = me.getRegItems()['MailAddressBccPanel'].getRegItems()['MailAddressBccGrid'].getStore();
    	
    	store.removeAll();
    }
});

Ext.define('nbox.mail.popup.mailAddressPopupPanel', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}    	
	},
    width: 320,
    border: false,
    
    layout: {
        type: 'vbox',
		align: 'stretch' 
    },
    
    initComponent: function () {
    	var me = this;
    	
    	var mailAddressBlankPanel = Ext.create('nbox.mail.popup.mailAddressBlankPanel',{});
    	var mailAddressToLayoutPanel = Ext.create('nbox.mail.popup.mailAddressToLayoutPanel',{});
    	var mailAddressCcLayoutPanel = Ext.create('nbox.mail.popup.mailAddressCcLayoutPanel',{});
    	var mailAddressBccLayoutPanel = Ext.create('nbox.mail.popup.mailAddressBccLayoutPanel',{});
    	
    	me.getRegItems()['MailAddressToLayoutPanel'] = mailAddressToLayoutPanel;
    	mailAddressToLayoutPanel.getRegItems()['ParentContainer'] = me;
    	
    	me.getRegItems()['MailAddressCcLayoutPanel'] = mailAddressCcLayoutPanel;
    	mailAddressCcLayoutPanel.getRegItems()['ParentContainer'] = me;
    	
    	me.getRegItems()['MailAddressBccLayoutPanel'] = mailAddressBccLayoutPanel;
    	mailAddressBccLayoutPanel.getRegItems()['ParentContainer'] = me;
    	
    	me.items=[mailAddressBlankPanel,mailAddressToLayoutPanel,mailAddressCcLayoutPanel,mailAddressBccLayoutPanel];
    	me.callParent();
    }
});

Ext.define('nbox.mail.popup.mailAddressPopupTopPanel', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}    	
	},
    
    layout: {
        type: 'hbox',
		align: 'stretch' 
    },
    flex: 1,
    
    border: false,
    
    initComponent: function () {
    	var me = this;
   	
    	var mailAddressPopupTab = Ext.create('nbox.mail.popup.mailAddressPopupTab', {});
    	var mailAddressPopupPanel = Ext.create('nbox.mail.popup.mailAddressPopupPanel', {});
        
		me.getRegItems()['MailAddressPopupTab'] = mailAddressPopupTab;
		mailAddressPopupTab.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['MailAddressPopupPanel'] = mailAddressPopupPanel;
		mailAddressPopupPanel.getRegItems()['ParentContainer'] = me;
		
		me.items = [mailAddressPopupTab, mailAddressPopupPanel];
    	
    	me.callParent();
    }
});

Ext.define('nbox.mail.popup.mailAddressPopupBottomPanel', {
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}    	
	},
    
    layout: {
        type: 'hbox' 
    },
    height: 35,
    
    border: false,
    bodyStyle: {
        padding: '0 0 0 185px'
    },
    
    initComponent: function () {
    	var me = this;
        
    	var btnConfirm = {
			xtype: 'button',
			text: '확인', 
			tooltip : '확인',
			width: 100,
			
			   
			handler: function() { 
				me.getRegItems()['ParentContainer'].ConfirmButtonDown();
			}
        };
    	
    	var btnCancel = {
			xtype: 'button',
			text: '취소', 
			tooltip : '취소',
			width: 100,
			
			handler: function() { 
				me.getRegItems()['ParentContainer'].CancelButtonDown();
			}
        };
	    	
    	me.items=[btnConfirm,btnCancel];
    	me.callParent();
    }
});

//DocLinePopup Window
Ext.define('nbox.mail.popup.mailAddressPopupWindow',{
	extend: 'Ext.window.Window',
	
	config: {
		regItems: {}    	
	},
	
	layout: {
        type: 'vbox',
		align: 'stretch' 
    },
    
	title: '주소록',
	
	x:20,
    y:20,
    
    width: mailAddressPopupWinWidth,
    height: mailAddressPopupWinHeight,
    
    modal: true,
    resizable: false,
    /*closable: false,*/
    
    initComponent: function () {
		var me = this;
       
    	var mailAddressPopupTopPanel    = Ext.create('nbox.mail.popup.mailAddressPopupTopPanel', {});
    	var mailAddressPopupBottomPanel = Ext.create('nbox.mail.popup.mailAddressPopupBottomPanel', {});
        
		me.getRegItems()['MailAddressPopupTopPanel'] = mailAddressPopupTopPanel;
		mailAddressPopupTopPanel.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['MailAddressPopupBottomPanel'] = mailAddressPopupBottomPanel;
		mailAddressPopupBottomPanel.getRegItems()['ParentContainer'] = me;
		
		me.items = [mailAddressPopupTopPanel, mailAddressPopupBottomPanel];
		
		me.callParent(); 
    },
    listeners: {
    	beforeshow: function(obj, eOpts){
    		var me = this;
			console.log(me.id + ' beforeshow -> docLinePopupWindow');
			
    		me.formShow();
    	},
	    beforehide: function(obj, eOpts){
	    	var me = this;
    		console.log(me.id + ' beforehide -> docLinePopupWindow')
    	},
    	beforeclose: function(obj, eOpts){
    		var me = this;
    		console.log(me.id + ' beforeclose -> docLinePopupWindow');
    		
    		var panel = me.getRegItems()['MailAddressPopupTopPanel'].getRegItems()['MailAddressPopupPanel'];
    		
    		var mailAddressToPanel = panel.getRegItems()['MailAddressToLayoutPanel'];
        	var mailAddressCcPanel = panel.getRegItems()['MailAddressCcLayoutPanel'];
        	var mailAddressBccPanel = panel.getRegItems()['MailAddressBccLayoutPanel'];
    		
        	mailAddressToPanel.clearData();
        	mailAddressCcPanel.clearData();
        	mailAddressBccPanel.clearData();
        	
    		mailAddressPopupWin = null;
    	}
    },
    ConfirmButtonDown: function(){
		var me = this;
		
    	me.confirmData();	
    },
    CancelButtonDown: function(){
		var me = this;
		
	    me.closeData();
    },
    confirmData: function(){
    	var me = this;

    	var mailEditTo = me.getRegItems()['MailEditorTo'];
    	var mailEditCc = me.getRegItems()['MailEditorCc'];
    	var mailEditBcc = me.getRegItems()['MailEditorBcc'];
    	
    	mailEditTo.clearData();
    	mailEditCc.clearData();
    	mailEditBcc.clearData();
    	
    	var panel = me.getRegItems()['MailAddressPopupTopPanel'].getRegItems()['MailAddressPopupPanel'];
    	
    	var mailAddressToStore = panel.getRegItems()['MailAddressToLayoutPanel'].getRegItems()['MailAddressToPanel'].items.getAt(1).getStore();
    	var mailAddressCcStore = panel.getRegItems()['MailAddressCcLayoutPanel'].getRegItems()['MailAddressCcPanel'].items.getAt(1).getStore();
    	var mailAddressBccStore = panel.getRegItems()['MailAddressBccLayoutPanel'].getRegItems()['MailAddressBccPanel'].items.getAt(1).getStore();
    	
    	mailEditTo.getRegItems()['Store'].copyStoreData(mailAddressToStore);
    	mailEditCc.getRegItems()['Store'].copyStoreData(mailAddressCcStore);
    	mailEditBcc.getRegItems()['Store'].copyStoreData(mailAddressBccStore);
    	
    	mailEditTo.confirmData();
    	mailEditCc.confirmData();
    	mailEditBcc.confirmData();
    	
    	me.close();
    },
    closeData: function(){
		var me = this;
		
	    me.close();
    },
    formShow: function(){
    	var me = this;
    	
    	var mailEditToStore = me.getRegItems()['MailEditorTo'].getRegItems()['Store'];
    	var mailEditCcStore = me.getRegItems()['MailEditorCc'].getRegItems()['Store'];
    	var mailEditBccStore = me.getRegItems()['MailEditorBcc'].getRegItems()['Store'];
    	
    	var panel = me.getRegItems()['MailAddressPopupTopPanel'].getRegItems()['MailAddressPopupPanel'];
    	
    	var mailAddressToStore = panel.getRegItems()['MailAddressToLayoutPanel'].getRegItems()['MailAddressToPanel'].items.getAt(1).getStore();
    	var mailAddressCcStore = panel.getRegItems()['MailAddressCcLayoutPanel'].getRegItems()['MailAddressCcPanel'].items.getAt(1).getStore();
    	var mailAddressBccStore = panel.getRegItems()['MailAddressBccLayoutPanel'].getRegItems()['MailAddressBccPanel'].items.getAt(1).getStore();
    	                         
    	mailAddressToStore.copyStoreData(mailEditToStore);
    	mailAddressCcStore.copyStoreData(mailEditCcStore);
    	mailAddressBccStore.copyStoreData(mailEditBccStore);
	}
});

/**************************************************
 * Create
 **************************************************/
 
/**************************************************
 * User Define Function
 **************************************************/
//MailAddress Popup Window Open
function openMailAddressPopupWin(mailEditorTo,mailEditorCc,mailEditorBcc) {
	// detailWin
	if(!mailAddressPopupWin){
		mailAddressPopupWin = Ext.create('nbox.mail.popup.mailAddressPopupWindow', { 
		}); 
	} 
	
	mailAddressPopupWin.getRegItems()['MailEditorTo'] = mailEditorTo;
	mailAddressPopupWin.getRegItems()['MailEditorCc'] = mailEditorCc;
	mailAddressPopupWin.getRegItems()['MailEditorBcc'] = mailEditorBcc;
	
	mailAddressPopupWin.show();
}	