
	/**************************************************
	 * Common variable
	 **************************************************/
	var SUBJECTWidth = 650;
	
	/**************************************************
	 * Common Code
	 **************************************************/
		
	
	/**************************************************
	 * Model
	 **************************************************/
	// RCV User List
	Ext.define('nbox.rcvUserEditModel', {
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
	//RCV User List
	Ext.define('nbox.rcvUserEditStore', {
		extend: 'Ext.data.Store',
		model: 'nbox.rcvUserEditModel',
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
	Ext.define('nbox.refUserEditStore', {
		extend: 'Ext.data.Store',
		model: 'nbox.rcvUserEditModel',
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
	//RCV User List
	Ext.define('nbox.editRcvUserView',{
		extend: 'Ext.view.View',
		config: {
			regItems: {}
		},
		loadMask:false,
	    cls: 'nbox-feed-list',
	    itemSelector: '.nbox-feed-sel-item',
	    selectedItemCls: 'nbox-feed-seled-item', 
	    width: SUBJECTWidth - 27,
		initComponent: function () {
			var me = this;
			
			me.tpl = new Ext.XTemplate(
				'<table cellpadding="0" cellspacing="0" width="100%" margin="0 0 0 0">',
					'<tr>',
						'<td style="border:0px; padding:3px; width:100px; text-align:right">',
							'<label>수신:</label>',
						'</td>',
						'<td style="border:0px; width:4px; text-align:right">',
						'</td>',
						'<td style="border:1px solid #C0C0C0; padding:3px; ">',
							'<span class="f9pt">&nbsp;</span>',
							'<tpl for=".">', 
								'<tpl if="values.DeptType == \'P\'">',
									'<span class="f9pt">{RcvUserName}</span>',
								'<tpl else>',
									'<span class="f9pt">@{RcvUserDeptName}</span>',
								'</tpl>',
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
	   		var store = me.getStore();
			
	   		me.clearData();
	   		
	   		var documentID = null;
	   		var actionType = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ActionType'];
			switch (actionType){
				case NBOX_C_CREATE:
					break;
				case NBOX_C_UPDATE:
					documentID = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['DocumentID'];
					break;
				default:
					break;
			}
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
	       
	    },
	    clearPanel: function(){
	   		var me = this;
	   		var store = me.getStore();
	   		
	   		store.removeAll();
	   	}
	});	

	//REF User List
	Ext.define('nbox.editRefUserView',{
		extend: 'Ext.view.View',
		config: {
			regItems: {}
		},
		loadMask:false,
	    cls: 'nbox-feed-list',
	    itemSelector: '.nbox-feed-sel-item',
	    selectedItemCls: 'nbox-feed-seled-item', 
	    width: SUBJECTWidth - 27,
		initComponent: function () {
			var me = this;
			
			me.tpl = new Ext.XTemplate(
				'<table cellpadding="0" cellspacing="0" width="100%" margin="0 0 0 0">',
					'<tr>',
						'<td style="border:0px; padding:3px; width:100px; text-align:right">',
							'<label>참조:</label>',
						'</td>',
						'<td style="border:0px; width:4px; text-align:right">',
						'</td>',
						'<td style="border:1px solid #C0C0C0; padding:3px;">',
							'<span class="f9pt">&nbsp;</span>',
							'<tpl for=".">', 
								'<tpl if="values.DeptType == \'P\'">',
									'<span class="f9pt">{RcvUserName}</span>',
								'<tpl else>',
									'<span class="f9pt">@{RcvUserDeptName}</span>',
								'</tpl>',
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
	   		var store = me.getStore();
			
	   		me.clearData();
	   		
	   		var documentID = null;
	   		var actionType = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ActionType'];
			switch (actionType){
				case NBOX_C_CREATE:
					break;
				case NBOX_C_UPDATE:
					documentID = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['DocumentID'];
					break;
				default:
					break;
			}
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
	   		
	   		me.clearPanel();
	   	},
	    loadData: function(){

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
