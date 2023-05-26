
	/**************************************************
	 * Common variable
	 **************************************************/

	
	/**************************************************
	 * Common Code
	 **************************************************/
		
	
	/**************************************************
	 * Model
	 **************************************************/
	// RCV User Model
	Ext.define('nbox.rcvUserViewModel', {
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
	Ext.define('nbox.rcvReadCheckModel', {
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
	Ext.define('nbox.rcvUserViewStore', {
		extend: 'Ext.data.Store',
		model: 'nbox.rcvUserViewModel',
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
	Ext.define('nbox.refUserViewStore', {
		extend: 'Ext.data.Store',
		model: 'nbox.rcvUserViewModel',
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
	Ext.define('nbox.rcvReadCheckStore', {
		extend: 'Ext.data.Store',
		model: 'nbox.rcvReadCheckModel',
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
	Ext.define('nbox.rcvReadCheckGrid', {
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
	Ext.define('nbox.rcvUserLines',{
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
    		var documentID;
			
    		me.clearData();
    		
    		documentID = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['DocumentID'];
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
    		
    		me.clearPanel();
    	},
        loadData: function(){
        	var me = this;
        	var store = me.getStore();
        	
        	if (store.getCount() == 0)
        		me.hide(); 
        	else{
        		me.show();
        		
        		store.each(function(record){
        			
        			if(record.data.DeptType == 'D')
        			{
	        			var rcvReadCheckStroe = Ext.create('nbox.rcvReadCheckStore',{});
	            		
	            		rcvReadCheckStroe.proxy.setExtraParam('DocumentID', record.data.DocumentID);
	            		rcvReadCheckStroe.proxy.setExtraParam('RcvType', record.data.RcvType);
	            		rcvReadCheckStroe.proxy.setExtraParam('DeptType', record.data.DeptType);
	            		rcvReadCheckStroe.proxy.setExtraParam('RcvUserDeptID', record.data.RcvUserDeptID);
	            		
	            		rcvReadCheckStroe.initPage(1, 5);
	            		rcvReadCheckStroe.load({
	           				callback: function(records, operation, success) {
	               				if (success){
	               					
	               					if( records.length > 1){
		               					var rcvReadCheckGrid = Ext.create('nbox.rcvReadCheckGrid',{
		               	        			store: rcvReadCheckStroe
		               	        		});
		               					
		               					Ext.create('Ext.tip.ToolTip', {
		               	             		target: 'RCVUSER-' + records[0].data.RcvUserDeptID,
		               	             		width: 400, height:185,
		               	             	    hideDelay: 500000,
		               	    				layout: { 
		               	    					type:'fit'
		               	    				},
		               	             	    items:[rcvReadCheckGrid]
		               	             	    	
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
    		var me = this;
    		var store = me.getStore();
    		
    		store.removeAll();
    	}
	});	
	
	//REF User List
	Ext.define('nbox.refUserLines',{
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
    		var documentID;
			
    		me.clearData();
    		
    		documentID = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['DocumentID'];
    		store.proxy.setExtraParam('DocumentID', documentID);
    		store.proxy.setExtraParam('RcvType', 'R');
    		
   			store.load({callback: function(records, operation, success) {
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
    		
    		me.clearPanel();
    	},
        loadData: function(){
        	var me = this;
        	var store = me.getStore();
        	
        	if (store.getCount() == 0)
        		me.hide(); 
        	else{
        		me.show();
        		
        		store.each(function(record){
        			
        			if(record.data.DeptType == 'D')
        			{
	        			var rcvReadCheckStroe = Ext.create('nbox.rcvReadCheckStore',{});
	            		documentID = docDetailWin.getRegItems()['DocumentID'];
	            		
	            		rcvReadCheckStroe.proxy.setExtraParam('DocumentID', record.data.DocumentID);
	            		rcvReadCheckStroe.proxy.setExtraParam('RcvType', record.data.RcvType);
	            		rcvReadCheckStroe.proxy.setExtraParam('DeptType', record.data.DeptType);
	            		rcvReadCheckStroe.proxy.setExtraParam('RcvUserDeptID', record.data.RcvUserDeptID);
	            		
	            		rcvReadCheckStroe.initPage(1, 5);
	            		rcvReadCheckStroe.load({
	           				callback: function(records, operation, success) {
	               				if (success){
	               					
	               					if( records.length > 1){
		               					var rcvReadCheckGrid = Ext.create('nbox.rcvReadCheckGrid',{
		               	        			store: rcvReadCheckStroe
		               	        		});
		               					
		               					Ext.create('Ext.tip.ToolTip', {
		               	             		target: 'REFUSER-' + records[0].data.RcvUserDeptID,
		               	             		width: 400, height:185,
		               	             	    hideDelay: 500000,
		               	    				layout: { 
		               	    					type:'fit'
		               	    				},
		               	             	    items:[rcvReadCheckGrid]
		               	             	    	
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
    		var me = this;
    		var store = me.getStore();
    		
    		store.removeAll();
    	}
	});			

	
    /**************************************************
	 * User Define Function
	 **************************************************/
