/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.docDetailViewRcvUserModel', {
    extend: 'Ext.data.Model',
    fields: [
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

//Rcv Read Check Model
Ext.define('nbox.docDetailViewReadCheckModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'RcvUserName'}, 
    	{name: 'RcvUserPosName'},
    	{name: 'ReadDate'},
    	{name: 'RcvUserDeptID'}
    ]
});	

/**************************************************
 * Store
 **************************************************/
//RCV User Store
Ext.define('nbox.docDetailViewRcvUserStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docDetailViewRcvUserModel',
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

//REF User Store
Ext.define('nbox.docDetailViewRefUserStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docDetailViewRcvUserModel',
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

// Read Check Stroe
Ext.define('nbox.docDetailViewReadCheckStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docDetailViewReadCheckModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: {
        	read: 'nboxDocRcvUserService.selectReadCheck'
        },
        reader: {
            type: 'json',
            root: 'records'
        }
    },
  	initPage: function(currentPage, pageSize) {
        var me = this;

        me.currentPage = currentPage;
        me.pageSize = pageSize;
    }
});		

/**************************************************
 * Define
 **************************************************/
// Rcv Read Check Grid
Ext.define('nbox.docDetailViewReadCheck', {
	extend:	'Ext.grid.Panel',
	
	config:{
		regItems: {}
	},
	
	border: true,
    
    initComponent: function () {
		var me = this;
		
        me.columns= [
	        {
	            text: '이름',
	            dataIndex: 'RcvUserName',
	            align: 'center',
	            width: 100
	        }, 
	        {
	            text: '직위',
	            dataIndex: 'RcvUserPosName',
	            align: 'center',
	            width: 100
	        }, 
	        {	
	            text: '확인일자',
	            dataIndex: 'ReadDate',
	            align: 'center',
	            flex: 1
	        }];
    
        var gridPaging = Ext.create('Ext.toolbar.Paging', {
        	id: 'nboxReadCheckPaging',
    		store: me.getStore(),
	        dock: 'bottom',
	        pageSize: 5,
	        displayInfo: true
    	});
		
		me.callParent(); 
    }
});		

//RCV User List
Ext.define('nbox.docDetailViewRcvUser1',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
    cls: 'nbox-feed-list',
    itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="0" cellspacing="0" width="100%" border="0" style="padding:3px 5px 0px 5px; width:100%;">',
				'<tr>',
					'<td width="50">',
						'<span style="color:#666666; font-size:12px;">수신&nbsp;&nbsp;</span>',
					'</td>',
					'<td>',
					'<tpl for=".">',
						'<tpl if="xcount &gt; 1 && xindex === xcount">',
							'<span style="color:#666666; font-size:12px;">수신자&nbsp;참조</span>',
						'</tpl>',
						'<tpl if="xcount &lt;= 1">',
							'<span id="RCVUSER1-{RcvUserDeptID}" style="color:#666666; font-size:12px;">',
							'<tpl if="values.DeptType == \'P\'">',
								'{RcvUserName}',
							'<tpl else>',
								'{RcvUserDeptName}',
							'</tpl>',
							'<tpl if="values.ReadChk == \'1\'">',
								'&#91;{[fm.date(values.ReadDate, "Y-m-d h:i:s")]}&#93;',
							'</tpl>',
							'<tpl if="values.ReadChk == \'0\'">',
								'&#91;미열람&#93;',
							'</tpl>',
							'</span>',
							'{[xindex === xcount ? "<span></span>" : "<span>,&nbsp;</span>"]}',
						'</tpl>',
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
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var documentID = nboxBaseApp.getDocumentID();
		
		me.clearData();
		
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('RcvType', 'C');
		
		store.load({
			callback: function(records, operation, success) {
   				if (success){
   					me.loadData();
   				}
   			}
		});
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
		
		me.clearPanel();
		store.removeAll();
	},
	loadData: function(){
    	var me = this;
    	var nboxDocDetailViewRcvUser2 = Ext.getCmp('nboxDocDetailViewRcvUser2')
    	var store = me.getStore();
    	
    	if (nboxDocDetailViewRcvUser2)
    		nboxDocDetailViewRcvUser2.loadData();
    	
    	if (store.getCount() <= 1){
    		store.each(function(record){
    			
    			if(record.data.DeptType == 'D')
    			{
        			var docDetailViewReadCheckStore = Ext.create('nbox.docDetailViewReadCheckStore',{});
            		
        			docDetailViewReadCheckStore.proxy.setExtraParam('DocumentID', record.data.DocumentID);
        			docDetailViewReadCheckStore.proxy.setExtraParam('RcvType', record.data.RcvType);
        			docDetailViewReadCheckStore.proxy.setExtraParam('DeptType', record.data.DeptType);
        			docDetailViewReadCheckStore.proxy.setExtraParam('RcvUserDeptID', record.data.RcvUserDeptID);
            		
        			docDetailViewReadCheckStore.initPage(1, 5);
        			docDetailViewReadCheckStore.load({
           				callback: function(records, operation, success) {
               				if (success){
               					
               					if( records.length > 1){
	               					var docDetailViewReadCheck = Ext.create('nbox.docDetailViewReadCheck',{
	               	        			store: docDetailViewReadCheckStore
	               	        		});
	               					
	               					Ext.create('Ext.tip.ToolTip', {
	               	             		target: 'RCVUSER1-' + records[0].data.RcvUserDeptID,
	               	             		width: 400, height:185,
	               	             	    hideDelay: 500000,
	               	    				layout: { 
	               	    					type:'fit'
	               	    				},
	               	             	    items:[docDetailViewReadCheck]
	               	             	    	
	               	             	});	
               					}
               				}
               			}
           			});
    			}
    		});
    	}
    },
    clearPanel: function(){
	}
});	

Ext.define('nbox.docDetailViewRcvUser2',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	loadMask:false,
    cls: 'nbox-feed-list',
    itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    width: '100%',
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="0" cellspacing="0" width="100%" border="0" style="padding:3px 5px 0px 5px; width:100%;">',
				'<tr>',
					'<td width="50">',
						'<span style="color:#666666; font-size:12px;">수신자&nbsp;&nbsp;</span>',
					'</td>',
					'<td>',
					'<tpl for=".">',
						'<span id="RCVUSER2-{RcvUserDeptID}" style="color:#666666; font-size:12px;">',
						'<tpl if="values.DeptType == \'P\'">',
							'{RcvUserName}',
						'<tpl else>',
							'{RcvUserDeptName}',
						'</tpl>',
						'<tpl if="values.ReadChk == \'1\'">',
							'&#91;{[fm.date(values.ReadDate, "Y-m-d h:i:s")]}&#93;',
						'</tpl>',
						'<tpl if="values.ReadChk == \'0\'">',
							'&#91;미열람&#93;',
						'</tpl>',
						'</span>',
						'{[xindex === xcount ? "<span></span>" : "<span>,&nbsp;</span>"]}',
					'</tpl>',								
					'</td>',
				'</tr>',
			'</table>'
		); 
		
		me.callParent();
	},		
    queryData: function(){
		var me = this;
		/*
		var store = me.getStore();
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		var documentID = nboxBaseApp.getDocumentID();
		
		me.clearData();
		
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('RcvType', 'C');
		
		store.load({
			callback: function(records, operation, success) {
   				if (success){
   					me.loadPanel();
   				}
   			}
		});
		*/
		me.loadData();
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
		
		me.clearPanel();
		store.removeAll();
	},
	loadData: function(){
    	var me = this;
    	var store = me.getStore();
    	
    	if (store.getCount() <= 1){
    		me.hide();
    	}
    	else{
    		me.show();
    		
    		store.each(function(record){
    			
    			if(record.data.DeptType == 'D')
    			{
        			var docDetailViewReadCheckStore = Ext.create('nbox.docDetailViewReadCheckStore',{});
            		
        			docDetailViewReadCheckStore.proxy.setExtraParam('DocumentID', record.data.DocumentID);
        			docDetailViewReadCheckStore.proxy.setExtraParam('RcvType', record.data.RcvType);
        			docDetailViewReadCheckStore.proxy.setExtraParam('DeptType', record.data.DeptType);
        			docDetailViewReadCheckStore.proxy.setExtraParam('RcvUserDeptID', record.data.RcvUserDeptID);
            		
        			docDetailViewReadCheckStore.initPage(1, 5);
        			docDetailViewReadCheckStore.load({
           				callback: function(records, operation, success) {
               				if (success){
               					
               					if( records.length > 1){
	               					var docDetailViewReadCheck = Ext.create('nbox.docDetailViewReadCheck',{
	               	        			store: docDetailViewReadCheckStore
	               	        		});
	               					
	               					Ext.create('Ext.tip.ToolTip', {
	               	             		target: 'RCVUSER2-' + records[0].data.RcvUserDeptID,
	               	             		width: 400, height:185,
	               	             	    hideDelay: 500000,
	               	    				layout: { 
	               	    					type:'fit'
	               	    				},
	               	             	    items:[docDetailViewReadCheck]
	               	             	    	
	               	             	});	
               					}
               				}
               			}
           			});
    			}
    		});
    	}
    },
    clearPanel: function(){
	}
});	

//REF User List
Ext.define('nbox.docDetailViewRefUser1',{
	extend: 'Ext.view.View',
	
	config: {
		regItems: {}
	},
	
	loadMask:false,
	
    cls: 'nbox-feed-list',
    itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    
    width: '100%',
    
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="0" cellspacing="0" width="100%" border="0" style="padding: 5px 5px 5px 5px; width:100%;">',
				'<tr>',
					'<td width="50">',
						'<span style="color:#666666; font-size:12px;">참조&nbsp;&nbsp;</span>',
					'</td>',
					'<td>',
					'<tpl for=".">',
						'<tpl if="xcount &gt; 1 && xindex === xcount">',
							'<span style="color:#666666; font-size:12px;">참조자&nbsp;참조</span>',
						'</tpl>',
						'<tpl if="xcount &lt;= 1">',
							'<span id="REFUSER1-{RcvUserDeptID}" style="color:#666666; font-size:12px;">',
							'<tpl if="values.DeptType == \'P\'">',
								'{RcvUserName}',
							'<tpl else>',
								'{RcvUserDeptName}&#93;',
							'</tpl>',
							'<tpl if="values.ReadChk == \'1\'">',
								'&#91;{[fm.date(values.ReadDate, "Y-m-d h:i:s")]}&#93;',
							'</tpl>',
							'<tpl if="values.ReadChk == \'0\'">',
								'&#91;미열람&#93;',
							'</tpl>',
							'</span>',
							'{[xindex === xcount ? "<span></span>" : "<span>,&nbsp;</span>"]}',
						'</tpl>',
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
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		
		var documentID = nboxBaseApp.getDocumentID();
		
		me.clearData();
		
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('RcvType', 'R');
		
		store.load({
			callback: function(records, operation, success) {
   				if (success){
   					me.loadData();
   				}
   			}
		});
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
		
		me.clearPanel();
		
		store.removeAll();
	},
	loadData: function(){
    	var me = this;
    	var nboxDocDetailViewRefUser2 = Ext.getCmp('nboxDocDetailViewRefUser2')
    	var store = me.getStore();
    	
    	if (nboxDocDetailViewRefUser2)
    		nboxDocDetailViewRefUser2.loadData();
    		
    	if (store.getCount() <= 1){
    		store.each(function(record){
    			
    			if(record.data.DeptType == 'D')
    			{
        			var docDetailViewReadCheckStore = Ext.create('nbox.docDetailViewReadCheckStore',{});
            		
            		docDetailViewReadCheckStore.proxy.setExtraParam('DocumentID', record.data.DocumentID);
            		docDetailViewReadCheckStore.proxy.setExtraParam('RcvType', record.data.RcvType);
            		docDetailViewReadCheckStore.proxy.setExtraParam('DeptType', record.data.DeptType);
            		docDetailViewReadCheckStore.proxy.setExtraParam('RcvUserDeptID', record.data.RcvUserDeptID);
            		
            		docDetailViewReadCheckStore.initPage(1, 5);
            		docDetailViewReadCheckStore.load({
           				callback: function(records, operation, success) {
               				if (success){
               					
               					if( records.length > 1){
	               					var docDetailViewReadCheck = Ext.create('nbox.docDetailViewReadCheck',{
	               	        			store: docDetailViewReadCheckStore
	               	        		});
	               					
	               					Ext.create('Ext.tip.ToolTip', {
	               	             		target: 'REFUSER1-' + records[0].data.RcvUserDeptID,
	               	             		width: 400, height:185,
	               	             	    hideDelay: 500000,
	               	    				layout: { 
	               	    					type:'fit'
	               	    				},
	               	             	    items:[docDetailViewReadCheck]
	               	             	    	
	               	             	});	
               					}
               				}
               			}
           			});
    			}
    		});
    	}
    },
    clearPanel: function(){
		
	}
});	


Ext.define('nbox.docDetailViewRefUser2',{
	extend: 'Ext.view.View',
	
	config: {
		regItems: {}
	},
	
	loadMask:false,
	
    cls: 'nbox-feed-list',
    itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    
    width: '100%',
    
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<table cellpadding="0" cellspacing="0" width="100%" border="0" style="padding: 5px 5px 5px 5px; width:100%;" >',
				'<tr>',
					'<td width="50">',
						'<span style="color:#666666; font-size:12px;">참조자&nbsp;&nbsp;</span>',
					'</td>',
					'<td>',
					'<tpl for=".">',
						'<span id="REFUSER2-{RcvUserDeptID}" style="color:#666666; font-size:12px;">',
						'<tpl if="values.DeptType == \'P\'">',
							'{RcvUserName}',
						'<tpl else>',
							'{RcvUserDeptName}&#93;',
						'</tpl>',
						'<tpl if="values.ReadChk == \'1\'">',
							'&#91;{[fm.date(values.ReadDate, "Y-m-d h:i:s")]}&#93;',
						'</tpl>',
						'<tpl if="values.ReadChk == \'0\'">',
							'&#91;미열람&#93;',
						'</tpl>',
						'</span>',
						'{[xindex === xcount ? "<span></span>" : "<span>,&nbsp;</span>"]}',
					'</tpl>',
					'</td>',
				'</tr>',
			'</table>'
		); 
		
		me.callParent();
	},		
    queryData: function(){
		var me = this;
		/*
		var store = me.getStore();
		var nboxBaseApp = Ext.getCmp('nboxBaseApp');
		
		var documentID = nboxBaseApp.getDocumentID();
		
		me.clearData();
		
		store.proxy.setExtraParam('DocumentID', documentID);
		store.proxy.setExtraParam('RcvType', 'R');
		
		store.load({
			callback: function(records, operation, success) {
   				if (success){
   					me.loadPanel();
   				}
   			}
		});
		*/
		me.loadData();
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
		
		me.clearPanel();
		
		store.removeAll();
	},
	loadData: function(){
    	var me = this;
    	var store = me.getStore();
    	
    	if (store.getCount() <= 1){
    		me.hide();
    	}
    	else {
    		me.show();
    		
    		store.each(function(record){
    			
    			if(record.data.DeptType == 'D')
    			{
        			var docDetailViewReadCheckStore = Ext.create('nbox.docDetailViewReadCheckStore',{});
            		
            		docDetailViewReadCheckStore.proxy.setExtraParam('DocumentID', record.data.DocumentID);
            		docDetailViewReadCheckStore.proxy.setExtraParam('RcvType', record.data.RcvType);
            		docDetailViewReadCheckStore.proxy.setExtraParam('DeptType', record.data.DeptType);
            		docDetailViewReadCheckStore.proxy.setExtraParam('RcvUserDeptID', record.data.RcvUserDeptID);
            		
            		docDetailViewReadCheckStore.initPage(1, 5);
            		docDetailViewReadCheckStore.load({
           				callback: function(records, operation, success) {
               				if (success){
               					
               					if( records.length > 1){
	               					var docDetailViewReadCheck = Ext.create('nbox.docDetailViewReadCheck',{
	               	        			store: docDetailViewReadCheckStore
	               	        		});
	               					
	               					Ext.create('Ext.tip.ToolTip', {
	               	             		target: 'REFUSER2-' + records[0].data.RcvUserDeptID,
	               	             		width: 400, height:185,
	               	             	    hideDelay: 500000,
	               	    				layout: { 
	               	    					type:'fit'
	               	    				},
	               	             	    items:[docDetailViewReadCheck]
	               	             	    	
	               	             	});	
               					}
               				}
               			}
           			});
    			}
    		});
    	}
    },
    clearPanel: function(){
		
	}
});	

/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	