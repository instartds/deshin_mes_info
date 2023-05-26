/**************************************************
 * Common variable
 **************************************************/
var docControlPanelWidth = 660;

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

	config: {
		store:null,
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
    	var documentID = null;
   		var store = me.getStore();
		
   		me.clearData();
   		
   		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
   		if (nboxBaseApp)
   			documentID = nboxBaseApp.getDocumentID();
		
   		if (store){
	   		store.proxy.setExtraParam('DocumentID', documentID);
	   		store.proxy.setExtraParam('RcvType', 'C');
	   		
			store.load();
   		}
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
		//var nboxDocEditInnerFlagCheckBox = Ext.getCmp('nboxDocEditInnerFlagCheckBox');
		//var nboxDocInputRcvFlagCheckbox = Ext.getCmp('nboxDocInputRcvFlagCheckbox');
		var store = me.getStore();
		
		store.removeAll();
		
		//if (nboxDocEditInnerFlagCheckBox){
		//	if (nboxDocEditInnerFlagCheckBox.getValue() == true){
		//		if (tempStore.getCount() > 0){
		//			Ext.Msg.alert('확인', '내부결재문서는 수신 팝업을 사용 할 수 없습니다.');
		//			me.clearData();
		//			return;
		//		}
		//	}
		//}
		
		//if (nboxDocInputRcvFlagCheckbox){
		//	if (nboxDocInputRcvFlagCheckbox.getValue() == true){
		//		if (tempStore.getCount() > 0){
		//			Ext.Msg.alert('확인', '수신자 직접 입력시 수신 팝업을 사용 할 수 없습니다.');
		//			me.clearData();
		//			return;
		//		}
		//	}
		//}		
		
		//nboxDocInputRcvFlagCheckbox.getValue() == true
			
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
		store: null, 
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
   		
   		var documentID = null;
   		var store = me.getStore();
		
   		me.clearData();
   		
   		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
   		if (nboxBaseApp)
   			documentID = nboxBaseApp.getDocumentID();
		
   		if (store){
	   		store.proxy.setExtraParam('DocumentID', documentID);
	   		store.proxy.setExtraParam('RcvType', 'R');
	   		
			store.load();
   		}
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
		var nboxDocInputRefFlagCheckbox = Ext.getCmp('nboxDocInputRefFlagCheckbox');
		var store = me.getStore();
		
		store.removeAll();
		
		if (nboxDocInputRefFlagCheckbox){
			if (nboxDocInputRefFlagCheckbox.getValue() == true){
				if (tempStore.getCount() > 0){
					Ext.Msg.alert('확인', '참조자 직접 입력시 참조 팝업을 사용 할 수 없습니다.');
					me.clearData();
					return;
				}
			}
		}
		
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
		store: null,
		regItems: {}
    },
    
    layout: {
		type: 'hbox'
	},
	padding: '0px 0px 3px 3px',

	border: false,
	
	initComponent: function () {
		var me = this;
		
		var nboxDocEditRcvUserStore = Ext.create('nbox.docEditRcvUserStore', {
			id:'nboxDocEditRcvUserStore'
		});
		
		var nboxDocEditRcvUserView = Ext.create('nbox.docEditRcvUserView',{
			id:'nboxDocEditRcvUserView',
			store: nboxDocEditRcvUserStore
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
		
		me.items = [ nboxDocEditRcvUserView, btn ] ;
		
		me.callParent();
	},
	buttonDown: function(){
		var me = this;
		
		var nboxDocEditLineView = Ext.getCmp('nboxDocEditLineView');
		var nboxDocEditRcvUserView = Ext.getCmp('nboxDocEditRcvUserView');
    	var nboxDocEditRefUserView = Ext.getCmp('nboxDocEditRefUserView');
    	
   		openDocLinePopupWin(2, 'A', nboxDocEditLineView, nboxDocEditRcvUserView, nboxDocEditRefUserView);
   		
	},
	queryData: function(){
		var me = this;
		var nboxDocEditRcvUserView = Ext.getCmp('nboxDocEditRcvUserView');
		
		if (nboxDocEditRcvUserView)
			nboxDocEditRcvUserView.queryData();
	},
	clearData: function(){
		var me = this;
		var nboxDocEditRcvUserView = Ext.getCmp('nboxDocEditRcvUserView');
		
		if (nboxDocEditRcvUserView)
			nboxDocEditRcvUserView.clearData();
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
		
		var nboxDocEditRefUserStore = Ext.create('nbox.docEditRefUserStore', {
			id:'nboxDocEditRefUserStore'
		});
		
		var nboxDocEditRefUserView = Ext.create('nbox.docEditRefUserView',{
			id:'nboxDocEditRefUserView',
			store: nboxDocEditRefUserStore
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
		
		me.items = [ nboxDocEditRefUserView, btn ] ;
		
		me.callParent();
	},
	buttonDown: function(){
		var me = this;
		
		var nboxDocEditLineView = Ext.getCmp('nboxDocEditLineView');
		var nboxDocEditRcvUserView = Ext.getCmp('nboxDocEditRcvUserView');
    	var nboxDocEditRefUserView = Ext.getCmp('nboxDocEditRefUserView');
   			
   		openDocLinePopupWin(3, 'A', nboxDocEditLineView, nboxDocEditRcvUserView, nboxDocEditRcvUserView);
	},
	queryData: function(){
		var me = this;
		var nboxDocEditRefUserView = Ext.getCmp('nboxDocEditRefUserView');
		
		if (nboxDocEditRefUserView)
			nboxDocEditRefUserView.queryData();
	},
	clearData: function(){
		var me = this;
		var nboxDocEditRefUserView = Ext.getCmp('nboxDocEditRefUserView');
		
		if (nboxDocEditRefUserView)
			nboxDocEditRefUserView.clearData();
    }
});

/**************************************************
 * User Define Function
 **************************************************/	
function deleteDocEditRcvUser(rowIndex){
	var nboxDocEditRcvUserView = Ext.getCmp('nboxDocEditRcvUserView');
	
	if (nboxDocEditRcvUserView)
		nboxDocEditRcvUserView.deleteData(rowIndex-1);
}

function deleteDocEditRefUser(rowIndex){
	var nboxDocEditRefUserView = Ext.getCmp('nboxDocEditRefUserView');
	
	if (nboxDocEditRefUserView)
		nboxDocEditRefUserView.deleteData(rowIndex-1);
}