
	/**************************************************
	 * Common variable
	 **************************************************/
	var expenseDetailWin ;
	var expenseDetailWidth = 500;
	var expenseDetailHeight = 300;
	 
	var SUBJECTWidth = 650;
	
	var toDay = new Date();
	/**************************************************
	 * Common Code
	 **************************************************/
		
	
	/**************************************************
	 * Model
	 **************************************************/
	// ExpenseDetail Model
	Ext.define('nbox.expenseDetailModel', {
	    extend: 'Ext.data.Model',
	    fields: [
	    	{name: 'DocumentID'}, 
	    	{name: 'Seq'},
	    	{name: 'ExpenseDate', type: 'date', dateFormat:'Y-m-d'}, 
	    	{name: 'ExpenseReason'},
	    	{name: 'AcctName'},
	    	{name: 'Supply'},
	    	{name: 'Vat'},
	    	{name: 'Remark'}
	    ]
	});	

	/**************************************************
	 * Store
	 **************************************************/
	//ExpenseDetail Store
	Ext.define('nbox.expenseDetailStore', {
		extend: 'Ext.data.Store',
		model: 'nbox.expenseDetailModel',
		autoLoad: false,
		proxy: {
            type: 'direct',
            api: { 
            	read: 'nboxDocExpenseDetailService.selects'
            },
            reader: {
	            type: 'json',
	            root: 'records'
	        }
        }
	});
	
	var expenseDetailStore = Ext.create('nbox.expenseDetailStore',{});
		
	/**************************************************
	 * Define
	 **************************************************/
	//Expense Detail Grid
	Ext.define('nbox.expenseDetailGrid', {
		extend:	'Ext.grid.Panel',
		config:{
			regItems: {}
		},
		viewConfig:{
	       loadMask:true,
	       loadingText: 'loading...'
	    },
	    
	    border: true,
	    
	   	initComponent: function () {
			var me = this;
						
	       me.columns= [
   		     	{
   		     		xtype: 'datecolumn',
	   		     	text: '일자',
		            sortable: true,
		            dataIndex: 'ExpenseDate',
		            align: 'center',
		            width: 100,
		            groupable: false,
		            format: 'Y-m-d'
		        },
   		     	{
		            text: '지출사유',
		            sortable: true,
		            dataIndex: 'ExpenseReason',
		            groupable: false,
		            width: 200,
		        },
		        {
	   		     	text: '표준적요',
		            sortable: true,
		            dataIndex: 'AcctName',
		            align: 'center',
		            width: 150,
		            groupable: false
		        },
		        {
	   		     	text: '공급가액',
		            sortable: true,
		            dataIndex: 'Supply',
		            width: 120,
		            align: 'right',
		            groupable: false
		        },
		        {
	   		     	text: '부가세',
		            sortable: true,
		            dataIndex: 'Vat',
		            width: 120,
		            align: 'right',
		            groupable: false
		        },
		        {
	   		     	text: '비고',
		            sortable: true,
		            dataIndex: 'Remark',
		            flex: 1,
		            groupable: false
		        },
		        {
		        	xtype: 'actioncolumn',
					icon: NBOX_IMAGE_PATH + "grid_delete.png" ,
					tooltip: '삭제',
					width: 25,
					handler: function(grid, rowIndex, colIndex) {
						me.deleteData(rowIndex);
					}
				}
		   	];
	        
	       var tbar = Ext.create('Ext.toolbar.Toolbar',{
	        	dock: 'top',
	        	items: [
	        	 	{
	        	 		xtype: 'button', 
	        	 		text: '<img src="' + NBOX_IMAGE_PATH + 'upload_add.png" width=15 height=15/> 추가',  
	        	 		handler: function(){
	        	 			me.newData();
	        	 		}
	        	 	}
	        	]
	        });
	    
	       var gridPaging = Ext.create('Ext.toolbar.Paging', {
        		store: me.getStore(),
		        dock: 'bottom',
		        displayInfo: true
        	});
	        
			me.getRegItems()['GridPaging'] = gridPaging;
			me.dockedItems = [tbar, gridPaging];
			
			me.callParent(); 
	        
	    },
	    queryData: function(){
        	var me = this;
        	var store = me.getStore();
        	
        	var documentID = null;
	   		var actionType = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ActionType'];
			switch (actionType){
				case NBOX_C_CREATE:
					break;
				case NBOX_C_UPDATE:
					documentID = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['ParentContainer'].getRegItems()['DocumentID'];
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
        newData: function(){
        	var me = this;
        	var editExpenseDetailPanel = me.getRegItems()['ParentContainer'];
        	
        	editExpenseDetailPanel.newData();
        },
        deleteData: function(rowIndex){
        	var me = this;
        	var store = me.getStore();
        	var record = store.getAt(rowIndex);
        	
        	store.remove(record);
        },
        clearData: function(){
        	var me = this;
        	var store = me.getStore();
        	
        	store.removeAll();
        },
        loadData: function(){
        	
        }
	}); 
	
	//ExpenseDetail Edit
    Ext.define('nbox.expenseDetailEdit',  {
		extend: 'Ext.form.Panel',
		config: {
			regItems: {}
		},
		
		layout: 'vbox',
		border: false,
		
		items: [
			{ 
				xtype: 'datefield',
				name:'ExpenseDate', 
				fieldLabel: '일자',
				format: 'Y-m-d', 
				labelAlign : 'right',
				labelClsExtra: 'required_field_label',
				allowBlank:false,
				value: toDay,
				padding: '10 0 0 0'
				
			},
			{
				xtype: 'textfield',
				name: 'ExpenseReason',
				fieldLabel: '지출사유',
				labelAlign : 'right',
				labelClsExtra: 'required_label',
				width: 450
			},
			{
				xtype: 'panel',
				layout: 'hbox',
				itemId: 'ExpenseAcctPopupPanel',
				border: false,
				padding: '0 0 5 0',
				items: [
					{
						xtype: 'textfield',
						itemId: 'AcctName',
						name: 'AcctName',
						fieldLabel: '표준적요',
						labelAlign : 'right',
						labelClsExtra: 'required_field_label',
						allowBlank:false,
						width: 350
					},
					{
						xtype: 'button',
						text: '<img src="' + NBOX_IMAGE_PATH + 'popup.png" width=13 height=13/>',
						itemId: 'btnexpenseacct',
					    style: 'width:26px; height:22px; margin-top:0px; margin-right:0px; padding-left:0px;',
						handler: function() {
							var me = this;
							var myForm = me.up('form');
							myForm.openExpenseAcctPopupWin();
						}
					}
				],
				width: 450
			},
			{
				xtype: 'numberfield',
				name: 'Supply',
				fieldLabel: '공급가액',
				labelAlign : 'right',
				labelClsExtra: 'required_label',
				align: 'right',
				width: 250
			},
			{
				xtype: 'numberfield',
				name: 'Vat',
				fieldLabel: '부가세액',
				labelAlign : 'right',
				labelClsExtra: 'required_label',
				align: 'right',
				width: 250
			},
			{
				xtype: 'textareafield',
				name: 'Remark',
				fieldLabel: '비고',
				labelAlign : 'right',
				labelClsExtra: 'required_label',
				width: 450
			}
    	],
		queryData: function(){
			var me = this;
			me.loadPanel();
        },
        saveData: function(){
			var me = this;
			var store = me.getRegItems()['StoreData'];
			
			var documentID = null;
			var seq = null
			
			var record = expenseDetailWin.getRegItems()['Record'];
			if(record != null){
				documentID = record.data.DocumentID;
				seq = record.data.Seq;
			}
			
			var values = me.getValues();
			
			var newRecord = {
  				DocumentID: documentID,
  				Seq: seq,
  				ExpenseDate: values.ExpenseDate,
  				ExpenseReason: values.ExpenseReason,
  				AcctName: values.AcctName,
  				Supply: values.Supply,
  				Vat: values.Vat,
  				Remark: values.Remark
 		    }; 
			
  			store.add(newRecord);
  			expenseDetailWin.closeData();
			
        },
        clearData: function(){
			var me = this;	
			
        	me.clearPanel(); 
        },
    	loadPanel: function(){
    		var me = this;
	    	var frm = me.getForm();
	    	
	    	var record = expenseDetailWin.getRegItems()['Record'];
	    	frm.loadRecord(record);
    	},
        clearPanel: function(){
        	var me = this;
	    	var frm = me.getForm();
	    	
			frm.reset(); 
        },
    	validationCheck: function(){
	    	var me = this;
	    	
	    	var fields = me.getForm().getFields();
	    	var result = '';
	    	
	    	var itemCnt = fields.getCount();
	    	for(var idx=0; idx<itemCnt; idx++){
	    		if(!fields.items[idx].isValid()){
	    			result += fields.items[idx].getFieldLabel() + ',';
	    		}
	    	}
	    	
	    	return '[' + result.substring(0,result.length-1) + ']' + '은/는 필수입력 사항입니다.';	
	    },
	    openExpenseAcctPopupWin: function(){
	    	var me = this; 
	    	var searchText = me.items.get('ExpenseAcctPopupPanel').items.get('AcctName') ;
	    	
	    	openExpenseAcctPopupWin(me, searchText.getValue());
	    },
	    confirmData: function(record){
	    	var me = this;
	    	
	    	var searchText = me.items.get('ExpenseAcctPopupPanel').items.get('AcctName') ;
	    	searchText.setValue(record.data.ACCT_NAME);
	    }
	}); 
    
	// toolbar
	Ext.define('nbox.expenseDetailToolbar',    {
        extend:'Ext.toolbar.Toolbar',
		dock : 'top',
		config: {
			regItems: {}
		},
		
		initComponent: function () {
	    	var me = this;
	    	
	        var btnSave = {
				xtype: 'button',
				text: '확인',
				tooltip : '확인',
				itemId : 'save',
				handler: function() {
					me.getRegItems()['ParentContainer'].SaveButtonDown();		
				}
	        };
	        
	        var btnCancel = {
				xtype: 'button',
				text: '취소',
				tooltip : '취소',
				itemId : 'cancel',
				handler: function() { 
					me.getRegItems()['ParentContainer'].CancelButtonDown();					
				}
	        };
	        	    	
			me.items = [btnSave, btnCancel];
			
	    	me.callParent(); 
	    },
	    setToolBars: function(btnItemIDs, flag){
	    	var me = this;
	    	
			if(Ext.isArray(btnItemIDs) ) {
				for(i = 0; i < btnItemIDs.length; i ++) {
					var element = btnItemIDs[i];
					me.setToolBar(element, flag);
				}
			} else {
				me.setToolBar(btnItemIDs, flag);
			}
	    },
	    setToolBar: function(btnItemID, flag){
	    	var me = this;
	    	
	    	var obj =  me.getComponent(btnItemID);
			if(obj) {
				(flag) ? obj.enable(): obj.disable();
			}
	    }
	});
	
	//ExpenseDetail Window
	Ext.define('nbox.expenseDetailWindow',{
		extend: 'Ext.window.Window',
		config: {
			regItems: {}    	
		},
		
		layout: {
	        type: 'fit'
	    },
	    
		title: '지출결의항목등록',
		
		x:20,
        y:20,
        
        width: expenseDetailWidth,
        height: expenseDetailHeight,
        
        modal: true,
        resizable: false,
        closable: false,
        
	    initComponent: function () {
			var me = this;
	       
	        var expenseDetailToolbar = Ext.create('nbox.expenseDetailToolbar', {});
			var expenseDetailEdit = Ext.create('nbox.expenseDetailEdit',{});
	        
			me.getRegItems()['ExpenseDetailToolbar'] = expenseDetailToolbar;
			expenseDetailToolbar.getRegItems()['ParentContainer'] = me;
			
			me.getRegItems()['ExpenseDetailEdit'] = expenseDetailEdit;
			expenseDetailEdit.getRegItems()['ParentContainer'] = me;
			expenseDetailEdit.getRegItems()['StoreData'] = expenseDetailStore;
			
			me.dockedItems = [expenseDetailToolbar];
			me.items = [expenseDetailEdit];
			
			me.callParent(); 
	    },
	    listeners: {
	    	beforeshow: function(obj, eOpts){
	    		var me = this;
	    		
    			console.log(me.id + ' beforeshow -> expenseDetailWindow');
	    		me.formShow();
	    	},
		    beforehide: function(obj, eOpts){
		    	var me = this;
		    	
	    		console.log(me.id + ' beforehide -> dexpenseDetailWindow')
	    	},
	    	beforeclose: function(obj, eOpts){
	    		var me = this;
	    		expenseDetailWin = null;
	    	}
	    },
	    SaveButtonDown: function(){
			var me = this;
			
	    	me.saveData();	
	    },
	    CancelButtonDown: function(){
			var me = this;
			
		    me.closeData();
	    },
	    saveData: function(){
			var me = this;
	    	var expenseDetailEdit = me.getRegItems()['ExpenseDetailEdit'];
	    	
	    	expenseDetailEdit.saveData();
	    },
	    closeData: function(){
			var me = this;
		    me.close();
	    },
	    formShow: function(){
    		var me = this;
    		var expenseDetailEdit = me.getRegItems()['ExpenseDetailEdit'];
			
    		expenseDetailEdit.clearData();
    		
    		switch(me.getRegItems()['ActionType'])
    		{
    			case NBOX_C_CREATE:
		    		break;
		    		
    			case NBOX_C_READ:
				case NBOX_C_UPDATE:
					expenseDetailEdit.queryData();
					break;

				case NBOX_C_DELETE:
					break;
					
				default:
					break;
			}
    	}
	}); 	
	

	
    /**************************************************
	 * User Define Function
	 **************************************************/
	// ExpenseDetail Window Open
    function openExpenseDetailWin(obj, actionType, record){
		
		if(!expenseDetailWin){
			expenseDetailWin = Ext.create('nbox.expenseDetailWindow', {
			}); 
    	}
    	
    	expenseDetailWin.getRegItems()['ExpenseDetailGrid'] = obj;
    	expenseDetailWin.getRegItems()['ActionType'] = actionType;
    	expenseDetailWin.getRegItems()['Record'] = record;
    		
    	expenseDetailWin.show();
    }	
