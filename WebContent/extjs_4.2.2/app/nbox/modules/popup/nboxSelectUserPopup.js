	/**************************************************
	 * Common variable
	 **************************************************/
	//local  variable
	var selectUserPopupWin ;
	
	var selectUserPopupWidth = 600;
	var selectUserPopupHeight = 500;
	
	
	/**************************************************
	 * Common Code
	 **************************************************/
	
	/**************************************************
	 * Model
	 **************************************************/
	//dept TREE Panel	
	Ext.define('nbox.deptTreeModel', {
	    extend: 'Ext.data.Model',
	    fields: [
			{name: 'id'},
			{name: 'TREE_CODE'},
	    	{name: 'text'},
	    	{name: 'DeptType'},
	    	{name: 'UserName'},
	    	{name: 'UserDeptID'},
	    	{name: 'UserDeptName'},
	    	{name: 'UserPosName'}
	    ]
	});
	
	// Select User List
	Ext.define('nbox.selectUserModel', {
	    extend: 'Ext.data.Model',
	    fields: [
	        {name: 'NoteID'},
 	    	{name: 'RcvUserID'}, 
	    	{name: 'RcvUserName'},
	    	{name: 'RcvUserDeptName'}
 	    ]
	});	
	

	/**************************************************
	 * Store
	 **************************************************/
	//dept tree	
	var deptTreeStore = Ext.create('Ext.data.TreeStore', {
		model: 'nbox.deptTreeModel',
		autoLoad: true,
		proxy: {
	        type: 'direct',
	        api: {
	            read : 'nboxDocCommonService.selectDeptTree'
	        }
	    }  
	});
	
	//Select User List
	var tempSelectUserStore = Ext.create('Ext.data.Store', {
		model: 'nbox.selectUserModel',
		autoLoad: false,
		proxy: {
            type: 'direct',
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
	//dept Tree
	Ext.define("nbox.deptTree",{
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
		
		width: 250,
		height: 445,
		
		title: '부서 및 사용자를 더블클릭하십시요.',

		margins: '0 0 0 0',
		rowLines: false, lines: false,
		scroll: 'vertical',
		
		listeners: {
			itemdblclick: function( t, record, item, index, e, eOpts ){
				if ( record.data.id !== "" )  {
		  			var me = this;
		  			
		  			var grid = me.getRegItems()['ParentContainer'].getRegItems()['SelectUserPopupGrid'];
		  			grid.addData(record);
		  	    }
			} 
		} 
	});	 
	
	// 수신라인 Grid
	Ext.define('nbox.selectUserPopupGrid',  {
		extend: 'Ext.grid.Panel',
		config: {
			regItems: {}
		},
		hideHeaders: false,
		border: true,
		
		title: '&nbsp;',
		flex:1,
		
        initComponent: function () {
        	var me = this;
        	
        	me.columns= [
		        {
	  		        text: '부서',
		            sortable: true,
		            dataIndex: 'RcvUserDeptName',
		            groupable: false,
		            width: 100
		        }, 
		        {
		            text: '이름',
		            sortable: true,
		            dataIndex: 'RcvUserName',
		            groupable: false,
		            flex:1
		        } ,
		        {
		        	xtype: 'actioncolumn',
					icon: NBOX_IMAGE_PATH + "grid_delete.png" ,
					tooltip: '삭제',
					width: 25 ,
					handler: function(grid, rowIndex, colIndex) {
						var record = grid.store.getAt(rowIndex);
						me.deleteData(rowIndex);
					}
				}
			];
        	
	       	me.callParent();
        },
        queryData: function(){
    	},
        addData: function(record){
    		var me = this;
    		var store = me.getStore();
    		var newRecord ;
    		
    		if(record.data.DeptType == 'P') {
    			if(store.findRecord('RcvUserID', record.data.TREE_CODE) !== null )
    				return ;
    		
	  			newRecord = {
	  				NoteID: null,
	  				RcvUserID: record.data.TREE_CODE,
	  				RcvUserName: record.data.UserName,
	  				RcvUserDeptName: record.data.UserDeptName
	 		    }; 
	  			
	  			store.add(newRecord);
	  			
    		}else{
    			var deptTree = me.getRegItems()['ParentContainer'].getRegItems()['DeptTree'];
    			var newRecords = me.childData(deptTree.getSelectionModel().getLastSelected().childNodes);
    		}
    	},
    	childData: function(childNodes){
    		var me = this;
    		var store = me.getStore();
    		
    		Ext.each(childNodes, function(childNode,i){												      
    			if (childNode.data.DeptType == 'P'){
    				
    				if(store.findRecord('RcvUserID', childNode.data.TREE_CODE) !== null )
        				return ;
    				
    				newRecord = {
   		  				NoteID: null,
   		  				RcvUserID: childNode.data.TREE_CODE,
   		  				RcvUserName: childNode.data.UserName,
   		  				RcvUserDeptName: childNode.data.UserDeptName
   		 		    };
    				
    				store.add(newRecord);
    			}
    			
    			me.childData(childNode.childNodes);
		    });
    		
    		return true;
    	},
    	deleteData: function(rowIndex){
    		var me = this;
    		var last;
    		var store = me.getStore();
    		var record = store.getAt(rowIndex);
    		var selModel = me.getSelectionModel();
    		
    		last = selModel.getSelection()[0];

    		store.remove(record);
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
	
	//DocLinePopup Window
	Ext.define('nbox.selectUserPopupWindow',{
		extend: 'Ext.window.Window',
		config: {
			regItems: {}    	
		},
		layout: {
	        type: 'hbox',
	        align: 'stretch' 
	    },
		title: '수신',
		
		x:20,
        y:20,
        
        width: selectUserPopupWidth,
        height: selectUserPopupHeight,
        
        modal: true,
        resizable: false,
        closable: false,
	    initComponent: function () {
			var me = this;
	       
	        var selectUserPopupToolbar = Ext.create('nbox.selectUserPopupToolbar', {});
	        
	        var deptTree = Ext.create('nbox.deptTree',{
				store: deptTreeStore
			});
	    	
	    	deptTree.expandAll();
	    	
	    	var selectUserPopupGrid = Ext.create('nbox.selectUserPopupGrid', {
	    		store:tempSelectUserStore 
	    	});
	        
			me.getRegItems()['SelectUserPopupToolbar'] = selectUserPopupToolbar;
			selectUserPopupToolbar.getRegItems()['ParentContainer'] = me;
			
			me.getRegItems()['DeptTree'] = deptTree;
			deptTree.getRegItems()['ParentContainer'] = me;
			deptTree.getRegItems()['StoreData'] = deptTreeStore;
			
			me.getRegItems()['SelectUserPopupGrid'] = selectUserPopupGrid;
			selectUserPopupGrid.getRegItems()['ParentContainer'] = me;
			
			me.dockedItems = [selectUserPopupToolbar];
			me.items = [deptTree, selectUserPopupGrid];
			
			me.callParent(); 
	    },
	    listeners: {
	    	beforeshow: function(obj, eOpts){
	    		var me = this;
    			console.log(me.id + ' beforeshow -> selectUserPopupWin');
	    		me.formShow();
	    	},
		    beforehide: function(obj, eOpts){
		    	var me = this;
	    		console.log(me.id + ' beforehide -> selectUserPopupWin')
	    	},
	    	beforeclose: function(obj, eOpts){
	    		var me = this;
	    		console.log(me.id + ' beforeclose -> selectUserPopupWin');
	    		
	    		var parentContainer = me.getRegItems()['ParentContainer'];
	    		tempSelectUserStore.clearData();
	    		parentContainer.refresh();
	    		
	    		selectUserPopupWin = null; 
	    	}
	    },
	    QueryButtonDown: function(){
	    	var me = this;
	    	
	    	me.queryData();
	    },
	    ConfirmButtonDown: function(){
			var me = this;
			
	    	me.confirmData();	
	    },
	    CancelButtonDown: function(){
			var me = this;
			
		    me.closeData();
	    },
	    queryData: function(){
	    	var me = this;
	    	var selectUserPopupGrid = me.getRegItems()['SelectUserPopupGrid'];
	    	
	    	selectUserPopupGrid.queryData();
	    },
	    confirmData: function(){
			var me = this;
			var selectUserStore = selectUserPopupWin.getRegItems()['ParentContainer'].getStore();
    		
			selectUserStore.removeAll();
			selectUserStore.copyData(tempSelectUserStore);
    		
			me.close();
	    },
	    closeData: function(){
			var me = this;
			
		    me.close();
	    },
	    formShow: function(){
    		var me = this;
    		var selectUserStore = selectUserPopupWin.getRegItems()['ParentContainer'].getStore();
    		
    		tempSelectUserStore.copyData(selectUserStore);
    	}
	});
	
	//DocLinePopup toolbar
	Ext.define('nbox.selectUserPopupToolbar',    {
        extend:'Ext.toolbar.Toolbar',
		dock : 'top',
		config: {
			regItems: {}
		},
		
		initComponent: function () {
	    	var me = this;
	    	
	        var btnConfirm = {
				xtype: 'button',
				text: '확인',
				tooltip : '확인',
				itemId : 'confirm',
				handler: function() {
					me.getRegItems()['ParentContainer'].ConfirmButtonDown();		
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
	        	    	
			me.items = [btnConfirm, btnCancel];
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
	
	/**************************************************
	 * Create
	 **************************************************/
	
	 
	/**************************************************
	 * User Define Function
	 **************************************************/
	//DocLinePopup Window Open
	function openSelectUserPopupWin(view) {
		
		// detailWin
		if(!selectUserPopupWin){
			selectUserPopupWin = Ext.create('nbox.selectUserPopupWindow', { 
			}); 
		} 
		
		selectUserPopupWin.getRegItems()['ParentContainer'] = view;
		selectUserPopupWin.show();
    }	