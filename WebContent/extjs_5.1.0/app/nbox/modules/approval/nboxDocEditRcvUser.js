/**************************************************
 * Common variable
 **************************************************/
var docControlPanelWidth = 650;

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.docEditRcvUserModel', {
    extend: 'Ext.data.Model',
    fields: [
		{name: 'id'},     
    	{name: 'DocumentID'},
    	{name: 'RcvType'},
    	{name: 'DeptType'},
    	{name: 'RcvUserID'},
    	{name: 'RcvUserName'},
    	{name: 'RcvUserDeptID'},
    	{name: 'RcvUserDeptName'},
    	{name: 'RcvUserPosName'},		
    	{name: 'ReadDate', type: 'date', dateFormat:'Y-m-d H:i:s'},
    	{name: 'ReadChk'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.docEditRcvUserStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docEditRcvUserModel',
	
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxDocRcvUserService.selects' },
        reader: {
            type: 'json',
            root: 'records'
        }
    },
    copyData: function(store){
    	var me = this;
    	var records = [];
    	
    	store.each(function(r){
			records.push(r.copy());
		});
		
		me.add(records);
    }
});	

//REF User List
Ext.define('nbox.docEditRefUserStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docEditRcvUserModel',
	
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxDocRcvUserService.selects' },
        reader: {
            type: 'json',
            root: 'records'
        }
    },
    copyData: function(store){
    	var me = this;
    	var records = [];
    	
    	store.each(function(r){
			records.push(r.copy());
		});
		
		me.add(records);
    }
});	

/**************************************************
 * Define
 **************************************************/
Ext.define('nbox.docEditRcvUserView',{
	extend: 'Ext.view.View',
	id: 'docEditRcvUserView',
	config: {
		regItems: {}
	},
	loadMask:false,
    cls: 'nbox-feed-list',
    itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    width: docControlPanelWidth - 27,
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="0" cellspacing="0" width="100%" margin="0 0 0 0">',
				'<tr>',
					'<td style="border:0px; padding:3px; width:95px; text-align:right">',
						'<label>수신:</label>',
					'</td>',
					'<td style="border:0px; width:4px; text-align:right">',
					'</td>',
					'<td class="nboxDocEditRcvUserTd">',
						'<span class="f9pt">&nbsp;</span>',
						'<tpl for=".">',
							'<span class="f9pt">',
								'<div class="nboxDocEditRcvUserDiv" onclick="deleteDocEditRcvUser({[xindex]})">',
									'<tpl if="values.DeptType == \'P\'">',
										'{RcvUserName}',
									'<tpl else>',
										'@{RcvUserDeptName}',
									'</tpl>',
									'{[xindex === xcount ? "<span></span>" : "<span>,&nbsp;</span>"]}',
								'</div>',
							'</span>',
				       	'</tpl>',
			    	'</td>',
				'</tr>',
	       	'</table>'
		); 
		
		me.callParent();
	},		
    queryData: function(){
    	var me = this;
   		var store = me.getStore();
		
   		me.clearData();
   		
   		var win = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
   		var documentID = win.getRegItems()['DocumentID'];
		
   		store.proxy.setExtraParam('DocumentID', documentID);
   		store.proxy.setExtraParam('RcvType', 'C');
   		
		store.load();
   	},
   	deleteData: function(rowIndex){
   		var me = this;
   		var store = me.getStore();
   		
   		var record = store.getAt(rowIndex);
		store.remove(record);
   		
   		me.refresh();
   	},   	
   	confirmData: function(tempStore){
		var me = this;
		var store = me.getStore();
		
		store.removeAll();
		store.copyData(tempStore);
		
		me.refresh();
	}, 
   	clearData: function(){
   		var me = this;
   		var store = me.getStore();
   		
   		store.removeAll();
   	}
});

Ext.define('nbox.docEditRefUserView',{
	extend: 'Ext.view.View',
	id: 'docEditRefUserView',
	config: {
		regItems: {}
	},
	
	loadMask:false,
    cls: 'nbox-feed-list',
    itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    width: docControlPanelWidth - 27,
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="0" cellspacing="0" width="100%" margin="0 0 0 0">',
				'<tr>',
					'<td style="border:0px; padding:3px; width:95px; text-align:right">',
						'<label>참조:</label>',
					'</td>',
					'<td style="border:0px; width:4px; text-align:right">',
					'</td>',
					'<td class="nboxDocEditRcvUserTd">',
						'<span class="f9pt">&nbsp;</span>',
						'<tpl for=".">',
							'<span class="f9pt">',
								'<div class="nboxDocEditRcvUserDiv"  onclick="deleteDocEditRefUser({[xindex]})">',
									'<tpl if="values.DeptType == \'P\'">',
										'{RcvUserName}',
									'<tpl else>',
										'@{RcvUserDeptName}',
									'</tpl>',
									'{[xindex === xcount ? "<span></span>" : "<span>,&nbsp;</span>"]}',
								'</div>',
							'</span>',
				       	'</tpl>',
			    	'</td>',
				'</tr>',
	       	'</table>'
		); 
		
		me.callParent();
	},		
	queryData: function(){
   		var me = this;
   		var store = me.getStore();
		
   		me.clearData();
   		
   		var win = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
   		var documentID = win.getRegItems()['DocumentID'];
		
   		store.proxy.setExtraParam('DocumentID', documentID);
   		store.proxy.setExtraParam('RcvType', 'R');
   		
		store.load();
   	},
   	deleteData: function(rowIndex){
   		var me = this;
   		var store = me.getStore();
   		
   		var record = store.getAt(rowIndex);
		store.remove(record);
   		
   		me.refresh();
   	},   	
   	confirmData: function(tempStore){
		var me = this;
		var store = me.getStore();
		
		store.removeAll();
		store.copyData(tempStore);
		
		me.refresh();
	}, 
   	clearData: function(){
   		var me = this;
   		var store = me.getStore();
   		
   		store.removeAll();
   	}
});

//RcvUser Panel
Ext.define('nbox.docEditRcvUserPanel', { 
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
    },
    
    layout: {
		type: 'hbox'
	},
	padding: '0px 0px 3px 3px',

	border: false,
	
	initComponent: function () {
		var me = this;
		
		var docEditRcvUserStore = Ext.create('nbox.docEditRcvUserStore', {});
		
		var docEditRcvUserView = Ext.create('nbox.docEditRcvUserView',{
			store: docEditRcvUserStore
		});
		
		var btn =  {	
			xtype: 'button',
			text: '<img src="' + NBOX_IMAGE_PATH + 'popup.png" width=13 height=13/>',
		    itemId: 'btnrcvuser',
		    style: 'width:26px; height:23px; margin-top:3px; margin-right:3px; padding-left:0px;',
		    handler: function() {
		    	me.buttonDown();
		    }
		};			
		
		me.items = [ docEditRcvUserView, btn ] ;
		
		me.getRegItems()['DocEditRcvUserView'] = docEditRcvUserView;
		docEditRcvUserView.getRegItems()['ParentContainer'] = me;
		            
		me.callParent();
	},
	buttonDown: function(){
		var me = this;
		var panel1 = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
		var panel2 = panel1.getRegItems()['DocEditHeaderPanel'].getRegItems()['DocEditExpandCollapsePanel'];
		
		var docEditLineView    = panel1.getRegItems()['DocEditLinePanel'].getRegItems()['DocEditLineView'];
		var docEditRcvUserView = me.getRegItems()['DocEditRcvUserView'];
   		var docEditRefUserView = panel2.getRegItems()['DocEditRefUserPanel'].getRegItems()['DocEditRefUserView'];
   			
   		openDocLinePopupWin(2,'A',docEditLineView,docEditRcvUserView,docEditRefUserView);
   		
	},
	queryData: function(){
		var me = this;
		var docEditRcvUserView = me.getRegItems()['DocEditRcvUserView']
		
		docEditRcvUserView.queryData();
	},
	clearData: function(){
		var me = this;
		var docEditRcvUserView = me.getRegItems()['DocEditRcvUserView']
		
		docEditRcvUserView.clearData();
    }
});

//Ref User Panel
Ext.define('nbox.docEditRefUserPanel', { 
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
    },
    
    layout: {
		type: 'hbox'
	},
	padding: '0px 0px 3px 3px',

	border: false,
	
	initComponent: function () {
		var me = this;
		
		var docEditRefUserStore = Ext.create('nbox.docEditRefUserStore', {});
		
		var docEditRefUserView = Ext.create('nbox.docEditRefUserView',{
			store: docEditRefUserStore
		});
		
		var btn =  {	
			xtype: 'button',
			text: '<img src="' + NBOX_IMAGE_PATH + 'popup.png" width=13 height=13/>',
		    itemId: 'btnrcvuser',
		    style: 'width:26px; height:23px; margin-top:3px; margin-right:3px; padding-left:0px;',
		    handler: function() {
		    	me.buttonDown();
		    }
		};			
		
		me.items = [ docEditRefUserView, btn ] ;
		
		me.getRegItems()['DocEditRefUserView'] = docEditRefUserView;
		docEditRefUserView.getRegItems()['ParentContainer'] = me;
		            
		me.callParent();
	},
	buttonDown: function(){
		var me = this;
		var panel1 = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
		var panel2 = panel1.getRegItems()['DocEditHeaderPanel'].getRegItems()['DocEditExpandCollapsePanel'];
		
		var docEditLineView    = panel1.getRegItems()['DocEditLinePanel'].getRegItems()['DocEditLineView'];
		var docEditRcvUserView = panel2.getRegItems()['DocEditRcvUserPanel'].getRegItems()['DocEditRcvUserView'];
   		var docEditRefUserView = me.getRegItems()['DocEditRefUserView']
   			
   		openDocLinePopupWin(3,'A',docEditLineView,docEditRcvUserView,docEditRefUserView);
	},
	queryData: function(){
		var me = this;
		var docEditRefUserView = me.getRegItems()['DocEditRefUserView'];
		
		docEditRefUserView.queryData();
	},
	clearData: function(){
		var me = this;
		var docEditRefUserView = me.getRegItems()['DocEditRefUserView'];
		
		docEditRefUserView.clearData();
    }
});

/**************************************************
 * User Define Function
 **************************************************/	
function deleteDocEditRcvUser(rowIndex){
	var docEditRcvUserView = Ext.getCmp('docEditRcvUserView');
	docEditRcvUserView.deleteData(rowIndex-1);
}

function deleteDocEditRefUser(rowIndex){
	var docEditRefUserView = Ext.getCmp('docEditRefUserView');
	docEditRefUserView.deleteData(rowIndex-1);
}