	/**************************************************
	 * Common variable
	 **************************************************/
	//local  variable
 	var expenseAcctPopupWin ;
	
	var expenseAcctPopupWidth = 500;
	var expenseAcctPopupHeight = 400;
	 
	/**************************************************
	 * Common Code
	 **************************************************/
	
	/**************************************************
	 * Model
	 **************************************************/
	//Grid Panel	
 	Ext.define('nbox.expenseAcctGridModel', {
	    extend: 'Ext.data.Model',
	    fields: [
			{name: 'COMP_CODE'},
	    	{name: 'ACCT_CD'},
	    	{name: 'ACCT_NAME'}
	    ]
	}); 

	/**************************************************
	 * Store
	 **************************************************/
	// ExpenseAcct Grid Store	
 	var expenseAcctGridStroe = Ext.create('Ext.data.Store', {
		model: 'nbox.expenseAcctGridModel',
		autoLoad: false,
		proxy: {
	        type: 'direct',
	        api: {
	            read : 'nboxCommonService.selectExpenseAcct'
	        },
            reader: {
	            type: 'json',
	            root: 'records'
	        }
	    }  
	});
		
	/**************************************************
	 * Define
	 **************************************************/
	// ExpenseAcct Grid
	Ext.define('nbox.expenseAcctGrid',  {
		extend: 'Ext.grid.Panel',
		
		config: {
			regItems: {}
		},
		
		hideHeaders: false,
		border: false,
		
		style: {
			'border-top': '1px solid #C0C0C0'
		},
		
		flex:1,
		
        initComponent: function () {
        	var me = this;
        	
        	me.columns= [
		        {
	  		        text: '계정코드',
		            sortable: true,
		            dataIndex: 'ACCT_CD',
		            groupable: false,
		            width: 100
		        }, 
		        {
		            text: '계정명',
		            sortable: true,
		            dataIndex: 'ACCT_NAME',
		            groupable: false,
		            flex:1
		        } ,
		        {
		        	xtype: 'actioncolumn',
					icon: NBOX_IMAGE_PATH + "grid_check.gif" ,
					tooltip: '선택',
					width: 25 ,
					handler: function(grid, rowIndex, colIndex) {
						var record = grid.store.getAt(rowIndex);
						me.confirmData(record);
					}
				}
			];
        	
        	var gridPaging = Ext.create('Ext.toolbar.Paging', {
        		store: me.getStore(),
		        dock: 'bottom',
		        pageSize: 10,
		        displayInfo: true
        	});
			
        	me.getRegItems()['GridPaging'] = gridPaging;
			me.dockedItems= [gridPaging];
			
	       	me.callParent();
        },
        queryData: function(){
        	var me = this;
	    	var store = me.getStore();
	    	
	    	var toolbar = me.getRegItems()['ParentContainer'].getRegItems()['ExpenseAcctPopupToolbar'];
	    	var searchText = toolbar.getRegItems()['SearchText'].getValue();
	    	
        	me.clearData(); 
        	
        	store.proxy.setExtraParam('SEARCHTEXT', searchText);
   			store.load();
    	},
        confirmData: function(record){
        	var me = this;
        	var panel = expenseAcctPopupWin.getRegItems()['Panel'];
        	
        	panel.confirmData(record);
        	expenseAcctPopupWin.close(); 
    	},
	    clearData: function(){
	    	var me = this;
    		var store = me.getStore();
    		
    		store.removeAll();
    	}
	});	
	 
	//ExpenseAcct Popup toolbar
	Ext.define('nbox.expenseAcctPopupToolbar',    {
        extend:'Ext.toolbar.Toolbar',
		dock : 'top',
		config: {
			regItems: {}
		},
		
		initComponent: function () {
	    	var me = this;
	    	
	    	var searchText = Ext.create('Ext.form.field.Text',{});
	    	
	    	var formSearch = {
    			xtype: 'form',
    			border: false,
			  	layout: 'fit',
			  	items: [searchText]
    		};
	    	
	    	var btnQuery = {
				xtype: 'button',
				text: '조회',
				tooltip : '조회',
				itemId : 'query',
				handler: function() {
					me.getRegItems()['ParentContainer'].QueryButtonDown();		
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
	        
	        me.getRegItems()['SearchText'] = searchText;
	        
	        	    	
			me.items = [formSearch, btnQuery, btnCancel];
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
	
	//ExepnseAcct Popup Window
	Ext.define('nbox.expenseAcctPopupWindow',{
		extend: 'Ext.window.Window',
		config: {
			regItems: {}    	
		},
		layout: {
	        type: 'fit' 
	    },
		title: '지출결의계정',
		
		x:20,
        y:20,
        
        width: expenseAcctPopupWidth,
        height: expenseAcctPopupHeight,
        
        modal: true,
        resizable: false,
	    initComponent: function () {
			var me = this;
	       
	        var expenseAcctPopupToolbar = Ext.create('nbox.expenseAcctPopupToolbar', {});
	        var expenseAcctGrid = Ext.create('nbox.expenseAcctGrid',{
	        	store: expenseAcctGridStroe
	        })
	        
	        me.getRegItems()['ExpenseAcctPopupToolbar'] = expenseAcctPopupToolbar;
	        expenseAcctPopupToolbar.getRegItems()['ParentContainer'] = me;
	        
	        me.getRegItems()['ExpenseAcctGrid'] = expenseAcctGrid;
	        expenseAcctGrid.getRegItems()['ParentContainer'] = me;
	        
	        me.dockedItems = [expenseAcctPopupToolbar];
	        me.items = [expenseAcctGrid];
	        
			me.callParent(); 
	    },
	    listeners: {
	    	beforeshow: function(obj, eOpts){
	    		var me = this;
    			console.log(me.id + ' beforeshow -> expenseAcctPopupWin');
    			
    			me.formShow();
	    	},
		    beforehide: function(obj, eOpts){
		    	var me = this;
	    		console.log(me.id + ' beforehide -> expenseAcctPopupWin')
	    	},
	    	beforeclose: function(obj, eOpts){
	    		var me = this;
	    		console.log(me.id + ' beforeclose -> expenseAcctPopupWin');
	    		
	    		expenseAcctPopupWin = null;
	    	}
	    },
	    QueryButtonDown: function(){
	    	var me = this;
	    	
	    	me.queryData();
	    },
	    CancelButtonDown: function(){
			var me = this;
			
		    me.closeData();
	    },
	    queryData: function(){
	    	var me = this;
	    	var expenseAcctGrid = me.getRegItems()['ExpenseAcctGrid'];
	    	expenseAcctGrid.queryData();
	    },
	    closeData: function(){
			var me = this;
			
		    me.close();
	    },
	    formShow: function(){
	    	var me = this;
	    	var expenseAcctPopupToolbar = me.getRegItems()['ExpenseAcctPopupToolbar'];
	    	var expenseAcctGrid = me.getRegItems()['ExpenseAcctGrid'];
	    	var searchText = expenseAcctPopupToolbar.getRegItems()['SearchText'];
	    	
	    	searchText.setValue(expenseAcctPopupWin.getRegItems()['SearchText']);
	    	
	    	expenseAcctGrid.queryData();
	    }
	});
	
	
	/**************************************************
	 * User Define Function
	 **************************************************/
	//DocLinePopup Window Open
	function openExpenseAcctPopupWin(obj, searchText) {
		// detailWin
		if(!expenseAcctPopupWin){
			expenseAcctPopupWin = Ext.create('nbox.expenseAcctPopupWindow', { 
			}); 
		} 
		
		expenseAcctPopupWin.getRegItems()['Panel'] = obj
		expenseAcctPopupWin.getRegItems()['SearchText'] = searchText
		 
		expenseAcctPopupWin.show();
    }	