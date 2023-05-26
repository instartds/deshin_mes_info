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
    		store: me.getStore(),
	        dock: 'bottom',
	        pageSize: 5,
	        displayInfo: true
    	});
		
		me.getRegItems()['GridPaging'] = gridPaging;
		me.dockedItems= [gridPaging];
		
		me.callParent(); 
    }
});		

//RCV User List
Ext.define('nbox.docDetailViewRcvUser',{
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
			'<table cellpadding="0" cellspacing="0" width="100%" border="0" style="border-collapse:collapse; border:1px solid #C0C0C0;">',
				'<tr>',
					'<td align="center" style="width:100px; border-right: 1px solid #C0C0C0;">',
						'<span class="f9pt" style="font-weight:bold; color:#666666;">수신</span>',
					'</td>',
					'<td style="padding:5px; border-right-width:1px;border-bottom-width:1px;">',
						'<tpl for=".">',
							'<div id="RCVUSER-{RcvUserDeptID}" style="float:left; border:1px solid #C0C0C0; width:150px; height:60px; margin-top:5px; margin-left:5px;margin-right:5px; margin-bottom:5px; padding-left:15px; text-align:left;">',
								'<span class="f9pt">{RcvUserDeptName}</span>',
								'<br />',
								'<span class="f9pt">{RcvUserName}</span>',
								'<br />',
								'<tpl if="values.ReadChk != \'0\'">',
									'<span class="f9pt">{[fm.date(values.ReadDate, "Y-m-d h:i:s")]}</span>',
								'<tpl else>',
									'<span class="f9pt">&#91;미열람&#93;</span>',
								'</tpl>',
							'</div>',
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
		var win = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
		var documentID = win.getRegItems()['DocumentID'];
		
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
    loadPanel: function(){
    	var me = this;
    	var store = me.getStore();
    	
    	if (store.getCount() == 0)
    		me.hide(); 
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
	               	             		target: 'RCVUSER-' + records[0].data.RcvUserDeptID,
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
Ext.define('nbox.docDetailViewRefUser',{
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
			'<table cellpadding="0" cellspacing="0" width="100%" border="0" style="border-collapse:collapse; border:1px solid #C0C0C0;">',
				'<tr>',
					'<td align="center" style="width:100px; border-right: 1px solid #C0C0C0;">',
						'<span class="f9pt" style="font-weight:bold; color:#666666;">참조</span>',
					'</td>',
					'<td style="padding:5px; border-right-width:1px;border-bottom-width:1px;">',
						'<tpl for=".">',
							'<div id="REFUSER-{RcvUserDeptID}" style="float:left; border:1px solid #C0C0C0; width:150px; height:60px; margin-top:5px; margin-left:5px;margin-right:5px; margin-bottom:5px; padding-left:15px; text-align:left;">',
								'<span class="f9pt">{RcvUserDeptName}</span>',
								'<br />',
								'<span class="f9pt">{RcvUserName}</span>',
								'<br />',
								'<tpl if="values.ReadChk != \'0\'">',
									'<span class="f9pt">{[fm.date(values.ReadDate, "Y-m-d h:i:s")]}</span>',
								'<tpl else>',
									'<span class="f9pt">&#91;미열람&#93;</span>',
								'</tpl>',
							'</div>',
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
		var win = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
		
		var documentID = win.getRegItems()['DocumentID'];
		
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
    loadPanel: function(){
    	var me = this;
    	var store = me.getStore();
    	
    	if (store.getCount() == 0)
    		me.hide(); 
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
	               	             		target: 'REFUSER-' + records[0].data.RcvUserDeptID,
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