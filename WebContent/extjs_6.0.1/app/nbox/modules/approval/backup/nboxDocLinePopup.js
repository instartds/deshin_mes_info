	/**************************************************
	 * Common variable
	 **************************************************/
	//local  variable
	var docLinePopupWin ;
	var docLinePopupWidth = 600;
	var docLinePopupHeight = 500;
	
	/**************************************************
	 * Common Code
	 **************************************************/
	var commonDocPathStore = Ext.create('Ext.data.Store', {
		fields: ["pathID", 'pathName'],
		autoLoad: false,
		proxy: {
	        type: 'direct',
	        api: { read: 'nboxDocCommonService.selectDocPath' },
	        reader: {
	            type: 'json',
	            root: 'records'
			}
		}
	});	 
	
	/**************************************************
	 * Model
	 **************************************************/
	//dept TREE Panel	
	Ext.define('nbox.docLinePopupDeptTreeModel', {
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

	/**************************************************
	 * Store
	 **************************************************/
	//dept tree	
	var docLinePopupDeptTreeStore = Ext.create('Ext.data.TreeStore', {
		model: 'nbox.docLinePopupDeptTreeModel',
		autoLoad: true,
		proxy: {
	        type: 'direct',
	        api: {
	            read : 'nboxDocCommonService.selectDeptTree'
	        }
	    }  
	});
	
	//DocLine List
	var tempDocLineStore = Ext.create('Ext.data.Store', {
		model: 'nbox.docLineEditModel',
		autoLoad: false,
		proxy: {
            type: 'direct',
            extraParams: {LineType: 'A'},
            api: { read: 'nboxDocPathLineService.selects' },
            reader: {
	            type: 'json',
	            root: 'records'
	        }
        },
        copyData: function(store){
        	var me = this;
        	var records = [];
        	
        	store.each(function(r){
        		if(r.data.LineType == 'A')
    				records.push(r.copy());	
    		});
    		
    		me.add(records);
        },
        confirmData: function(store){
        	var me = this;
        	var records = [];
        	
        	store.each(function(r){
    			records.push(r.copy());	
    		});
    		
    		me.add(records);
        }
	});	
	
	//DoubleLine List
	var tempDoubleLineStore = Ext.create('Ext.data.Store', {
		model: 'nbox.docLineEditModel',
		autoLoad: false,
		proxy: {
            type: 'direct',
            extraParams: {LineType: 'B'},
            api: { read: 'nboxDocPathLineService.selects' },
            reader: {
	            type: 'json',
	            root: 'records'
	        }
        },
        copyData: function(store){
        	var me = this;
        	var records = [];
        	
        	store.each(function(r){
        		if(r.data.LineType == 'B')
    				records.push(r.copy());
    		});
    		
    		me.add(records);
        }
	});		
	
	//RCV User List
	var tempRcvUserStore = Ext.create('Ext.data.Store', {
		model: 'nbox.rcvUserEditModel',
		autoLoad: false,
		proxy: {
            type: 'direct',
            extraParams: {RcvType: 'C'},
            api: { read: 'nboxDocPathRcvUserService.selects' },
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
	var tempRefUserStore = Ext.create('Ext.data.Store', {
		model: 'nbox.rcvUserEditModel',
		autoLoad: false,
		proxy: {
            type: 'direct',
            extraParams: {RcvType: 'R'},
            api: { read: 'nboxDocPathRcvUserService.selects' },
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
	Ext.define("nbox.docLinePopupDeptTree",{
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
				if (record.data.id !== "" )  {
		  			var me = this;
		  			
		  			var activePanel = me.getRegItems()['ParentContainer'].getRegItems()['DocLinePopupTab'].getActiveTab();
		  			var grid = activePanel.down('grid'); 
		  			
		  			grid.addData(record);
		  	    }
			} 
		} 
	});	 
	
	// 결재라인 Grid
	Ext.define('nbox.docLineGrid',  {
		extend: 'Ext.grid.Panel',
		config: {
			regItems: {}
		},
		padding: '3px 3px 0px 3px',
		hideHeaders: false,
		border: false,
		
        initComponent: function () {
        	var me = this;
        	
        	me.columns= [
		        {
	  		        text: '부서',
		            sortable: false,
		            dataIndex: 'SignUserDeptName',
		            align: 'center',
		            groupable: false,
		            width: 100
		        }, 
		        {
		            text: '이름',
		            sortable: false,
		            dataIndex: 'SignUserName',
		            align: 'center',
		            groupable: false,
		            flex:1
		        }, 
		        {	
		        	xtype : 'checkcolumn',
		            text: '합의',
		            /*id: 'SignType',*/
		            dataIndex: 'SignType',
		            align: 'center',
		            groupable: false,
		            sortable: false,
		            width: 50,
		            listeners:{
		            	checkchange: function(me, rowIndex, checked, eOpts ){
		            		if(checked){
		            			
		            		}
		            	}
		            }
		        }, 
		        {
		        	xtype: 'actioncolumn',
					icon: NBOX_IMAGE_PATH + "grid_delete.png" ,
					tooltip: '삭제',
					width: 25 ,
					handler: function(grid, rowIndex, colIndex) {
						var record = grid.store.getAt(rowIndex);
						
						if(record.data.Seq == 1) {
							Ext.Msg.alert('확인', '기안자는 삭제할 수 없습니다.');
							return false;
						}
						
						if(record.data.DoubleLineFirstFlag == 'Y'){
							Ext.Msg.alert('확인', '시작 이중결재자는 삭제할 수 없습니다.');
							return false;
						}
						me.deleteData(rowIndex);
						return true;
					}
				} 
			];
        	
	       	me.callParent();
        },
        queryData: function(){
        	var me = this;
	    	var store = me.getStore();
	    	
	    	var targetContainer = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
        	var popupSearchForm = targetContainer.getRegItems()['DocLinePopupToolbar'].items.get('nbox.popupSearchForm');
        	var param = popupSearchForm.getValues();
	    	
   			store.load({params:param,
       			callback: function(records, operation, success) {
       				if (success){
       					me.loadData();
       				}
       			}
   			});
    	},
    	addData: function(record){
    		var me = this;
    		var store = me.getStore();
    		
    		if(record.data.DeptType == 'P') {
    			
    			if(store.findRecord('SignUserID', record.data.TREE_CODE) !== null )
        			return ;
    			
    			var newRecord = {
	  				DocumentID: record.data.DocumentID,
	  				LineType: 'A',
	  				SignUserID: record.data.TREE_CODE,
	  				SignUserName: record.data.UserName,
	  				SignUserDeptName: record.data.UserDeptName,
	  				SignUserPosName: record.data.UserPosName,
	  				SignImgUrl: CPATH + '/nboxfile/myinfosign/X0005',
	  				SignType: 0,
	  				SignFlag: 'N',
	  				SignTypeName: '결재'
  		        }; 
				
	  			store.add(newRecord);
			}	
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
	
	// 이중결재라인 Grid
	Ext.define('nbox.doubleLineGrid',  {
		extend: 'Ext.grid.Panel',
		config: {
			regItems: {}
		},
		padding: '3px 3px 0px 3px',
		hideHeaders: false,
		border: false,
		
        initComponent: function () {
        	var me = this;
        	
        	me.columns= [
		        {
	  		        text: '부서',
		            sortable: false,
		            dataIndex: 'SignUserDeptName',
		            align: 'center',
		            groupable: false,
		            width: 100
		        }, 
		        {
		            text: '이름',
		            sortable: false,
		            dataIndex: 'SignUserName',
		            align: 'center',
		            groupable: false,
		            flex:1
		        }, 
		        {	
		        	xtype : 'checkcolumn',
		            text: '합의',
		            /*id: 'SignType',*/
		            dataIndex: 'SignType',
		            align: 'center',
		            groupable: false,
		            sortable: false,
		            width: 50,
		            listeners:{
		            	checkchange: function(me, rowIndex, checked, eOpts ){
		            		if(checked){
		            			
		            		}
		            	}
		            }
		        }, 
		        {
		        	xtype: 'actioncolumn',
					icon: NBOX_IMAGE_PATH + "grid_delete.png" ,
					tooltip: '삭제',
					width: 25 ,
					handler: function(grid, rowIndex, colIndex) {
						me.deleteData(rowIndex);
						return true;
					}
				} 
			];
        	
	       	me.callParent();
        },
        queryData: function(){
        	var me = this;
	    	var store = me.getStore();
	    	
	    	var targetContainer = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
        	var popupSearchForm = targetContainer.getRegItems()['DocLinePopupToolbar'].items.get('nbox.popupSearchForm');
        	var param = popupSearchForm.getValues();
	    	
   			store.load({params:param,
       			callback: function(records, operation, success) {
       				if (success){
       					me.loadData();
       				}
       			}
   			});
    	},
    	addData: function(record){
    		var me = this;
    		var store = me.getStore();
    		
    		if(record.data.DeptType == 'P') {
    			
    			if(store.findRecord('SignUserID', record.data.TREE_CODE) !== null )
        			return ;
    			
	  			var newRecord = {
	  				DocumentID: record.data.DocumentID,
	  				LineType: 'B',
	  				SignUserID: record.data.TREE_CODE,
	  				SignUserName: record.data.UserName,
	  				SignUserDeptName: record.data.UserDeptName,
	  				SignUserPosName: record.data.UserPosName,
	  				SignImgUrl: CPATH + '/nboxfile/myinfosign/X0005',
	  				SignType: 0,
	  				SignFlag: 'N',
	  				SignTypeName: '이중결재'
  		        }; 
				
	  			store.add(newRecord);
			}	
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
	
	// 수신라인 Grid
	Ext.define('nbox.rcvUserGrid',  {
		extend: 'Ext.grid.Panel',
		config: {
			regItems: {}
		},
		padding: '3px 3px 0px 3px',
		hideHeaders: false,
		border: false,
		
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
        	var me = this;
	    	var store = me.getStore();
	    	
	    	var targetContainer = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
        	var popupSearchForm = targetContainer.getRegItems()['DocLinePopupToolbar'].items.get('nbox.popupSearchForm');
        	var param = popupSearchForm.getValues();
	    	
   			store.load({params:param,
       			callback: function(records, operation, success) {
       				if (success){
       					me.loadData();
       				}
       			}
   			});    		
    	},
    	addData: function(record){
    		var me = this;
    		var store = me.getStore();
    		
    		if(record.data.DeptType == 'P') {
	    		if(store.findRecord('RcvUserID', record.data.TREE_CODE) !== null )
	    			return ;
	    		
	  			var newRecord = {
	  				id: record.data.id,
	  				DocumentID: record.data.DocumentID,
	  				RcvType: record.data.RcvType,
	  				DeptType: record.data.DeptType,
	  				RcvUserID: record.data.TREE_CODE,
	  				RcvUserName: record.data.UserName,
	  				RcvUserDeptID: record.data.UserDeptID,
	  				RcvUserDeptName: record.data.UserDeptName,
	  				RcvUserPosName: record.data.UserPosName,
	  				ReadDate: null
	 		    }; 
    		}else{
    			
    			if(store.findRecord('RcvUserDeptID', record.data.TREE_CODE) !== null )
    				return ;
    		
	  			newRecord = {
	  				id: record.data.id,	
	  				DocumentID: record.data.DocumentID,
	  				RcvType: record.data.RcvType,
	  				DeptType: record.data.DeptType,
	  				RcvUserID: '*',
	  				RcvUserName: record.data.UserDeptName,
	  				RcvUserDeptID: record.data.UserDeptID,
	  				RcvUserDeptName: record.data.UserDeptName,
	  				ReadDate: null
	 		    }; 
    		}
    		
    		store.add(newRecord);
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
		
	// 참조라인 Grid
	Ext.define('nbox.refUserGrid',  {
		extend: 'Ext.grid.Panel',
		config: {
			regItems: {}
		},
		padding: '3px 3px 0px 3px',
		hideHeaders: false,
		border: false,
		
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
		        },
		        {
		        	xtype: 'actioncolumn',
					icon: NBOX_IMAGE_PATH + "grid_delete.png" ,
					tooltip: '삭제',
					width: 25,
					handler: function(grid, rowIndex, colIndex) {
						var record = grid.store.getAt(rowIndex);
						me.deleteData(rowIndex);
					}
				}
			];
        	
	       	me.callParent();
        },
        queryData: function(){
        	var me = this;
	    	var store = me.getStore();
	    	
	    	var targetContainer = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
        	var popupSearchForm = targetContainer.getRegItems()['DocLinePopupToolbar'].items.get('nbox.popupSearchForm');
        	var param = popupSearchForm.getValues();
	    	
   			store.load({params:param,
       			callback: function(records, operation, success) {
       				if (success){
       					me.loadData();
       				}
       			}
   			});
        },
        addData: function(record){
    		var me = this;
    		var store = me.getStore();
    		
    		if(record.data.DeptType == 'P') {
	    		if(store.findRecord('RcvUserID', record.data.TREE_CODE) !== null )
	    			return ;
	    		
	  			var newRecord = {
	  				id: record.data.id,
	  				DocumentID: record.data.DocumentID,
	  				RcvType: record.data.RcvType,
	  				DeptType: record.data.DeptType,
	  				RcvUserID: record.data.TREE_CODE,
	  				RcvUserName: record.data.UserName,
	  				RcvUserDeptID: record.data.UserDeptID,
	  				RcvUserDeptName: record.data.UserDeptName,
	  				RcvUserPosName: record.data.UserPosName,
	  				ReadDate: null
	 		    }; 
    		}else{
    			
    			if(store.findRecord('RcvUserDeptID', record.data.TREE_CODE) !== null )
    				return ;
    		
	  			newRecord = {
	  				id: record.data.id,	
	  				DocumentID: record.data.DocumentID,
	  				RcvType: record.data.RcvType,
	  				DeptType: record.data.DeptType,
	  				RcvUserID: '*',
	  				RcvUserName: record.data.UserDeptName,
	  				RcvUserDeptID: record.data.UserDeptID,
	  				RcvUserDeptName: record.data.UserDeptName,
	  				ReadDate: null
	 		    }; 
    		} 
			
			store.add(newRecord);
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
	
	//Tab Panel
	Ext.define('nbox.docLinePopupTab', {
		extend: 'Ext.tab.Panel',
		config: {
			regItems: {}    	
		},
	    width: 340,
	    height: 445,
	     
	    initComponent: function () {
	    	var me = this;
	    	
	    	var docLineGrid = Ext.create('nbox.docLineGrid',{
	    		store: tempDocLineStore
        	});
	    	
	    	var doubleLineGrid = Ext.create('nbox.doubleLineGrid',{
	    		store: tempDoubleLineStore
        	});
	    	
	    	var rcvUserGrid = Ext.create('nbox.rcvUserGrid',{
        		store: tempRcvUserStore
        	});
	    	
	    	var refUserGrid = Ext.create('nbox.refUserGrid',{
        		store: tempRefUserStore
        	});  
	    	
	    	var docLineGridPanel = Ext.create('Ext.panel.Panel', {
	    		title: '결재',
	    		layout: {
	    	        type: 'fit'
	    	    },
	    	    items: docLineGrid
	    	});
	    	
	    	var doubleLineGridPanel = Ext.create('Ext.panel.Panel', {
	    		title: '이중결재',
	    		layout: {
	    	        type: 'fit'
	    	    },
	    	    items: doubleLineGrid
	    	});
	    	
	    	var rcvUserGridPanel = Ext.create('Ext.panel.Panel', {
	    		title: '수신',
	    		layout: {
	    	        type: 'fit'
	    	    },
	    	    items: rcvUserGrid
	    	});
	    	
	    	var refUserGridPanel = Ext.create('Ext.panel.Panel', {
	    		title: '참조',
	    		layout: {
	    	        type: 'fit'
	    	    },
	    	    items: refUserGrid
	    	});
	    	
	    	 
	    	me.getRegItems()['DocLineGrid'] = docLineGrid;
	    	docLineGrid.getRegItems()['ParentContainer'] = me;
	    	
	    	me.getRegItems()['DoubleLineGrid'] = doubleLineGrid;
	    	doubleLineGrid.getRegItems()['ParentContainer'] = me;
	    	
	    	me.getRegItems()['RcvUserGrid'] = rcvUserGrid;
	    	rcvUserGrid.getRegItems()['ParentContainer'] = me;
	    	
	    	me.getRegItems()['RefUserGrid'] = refUserGrid;
	    	refUserGrid.getRegItems()['ParentContainer'] = me; 
	    	
	    	me.items = [ docLineGridPanel, doubleLineGridPanel, rcvUserGridPanel, refUserGridPanel ];
	    	me.callParent();
	    }  

	});
	
	
	//DocLinePopup Window
	Ext.define('nbox.docLinePopupWindow',{
		extend: 'Ext.window.Window',
		config: {
			regItems: {}    	
		},
		layout: {
	        type: 'hbox'
	    },
		title: '결재',
		
		x:20,
        y:20,
        
        width: docLinePopupWidth,
        height: docLinePopupHeight,
        
        modal: true,
        resizable: false,
        closable: false,
	    initComponent: function () {
			var me = this;
	       
	        var docLinePopupToolbar = Ext.create('nbox.docLinePopupToolbar', {});
	        var docLinePopupDeptTree = Ext.create('nbox.docLinePopupDeptTree',{
				store: docLinePopupDeptTreeStore
			});
	    	
	        docLinePopupDeptTree.expandAll();
	    	
	    	var docLinePopupTab = Ext.create('nbox.docLinePopupTab', {});
	        
			me.getRegItems()['DocLinePopupToolbar'] = docLinePopupToolbar;
			docLinePopupToolbar.getRegItems()['ParentContainer'] = me;
			
			me.getRegItems()['DocLinePopupDeptTree'] = docLinePopupDeptTree;
			docLinePopupDeptTree.getRegItems()['ParentContainer'] = me;
			docLinePopupDeptTree.getRegItems()['StoreData'] = docLinePopupDeptTree;
			
			me.getRegItems()['DocLinePopupTab'] = docLinePopupTab;
			docLinePopupTab.getRegItems()['ParentContainer'] = me;
			
			me.dockedItems = [docLinePopupToolbar];
			me.items = [docLinePopupDeptTree, docLinePopupTab];
			
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
	    		
	    		tempDocLineStore.clearData();
	    		tempDoubleLineStore.clearData();
	    		tempRcvUserStore.clearData();
	    		tempRefUserStore.clearData();
	    		
	    		docLinePopupWin = null;
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
	    	
	    	var docLineGrid = me.getRegItems()['DocLinePopupTab'].getRegItems()['DocLineGrid'];
	    	var doubleLineGrid = me.getRegItems()['DocLinePopupTab'].getRegItems()['DoubleLineGrid'];
	    	var rcvUserGrid = me.getRegItems()['DocLinePopupTab'].getRegItems()['RcvUserGrid'];
	    	var refUserGrid = me.getRegItems()['DocLinePopupTab'].getRegItems()['RefUserGrid'];
	    	
	    	docLineGrid.queryData();
	    	doubleLineGrid.queryData();
	    	rcvUserGrid.queryData();
	    	refUserGrid.queryData();
	    },
	    confirmData: function(){
			var me = this;
			
			var docLineView = me.getRegItems()['DocLineView'];
			var doubleLineView = me.getRegItems()['DoubleLineView'];
    		var rcvUserView = me.getRegItems()['RcvUserView'];
    		var refUserView = me.getRegItems()['RefUserView'];
    		
    		if(tempDoubleLineStore.getCount()>0)
    			tempDocLineStore.confirmData(tempDoubleLineStore)
    		
    		if(tempDocLineStore.getCount()>0)
    			docLineView.confirmData(tempDocLineStore);
    		
    		/* if(tempRcvUserStore.getCount()>0) */
    			rcvUserView.confirmData(tempRcvUserStore);
    		
    		/* if(tempRefUserStore.getCount()>0) */
    			refUserView.confirmData(tempRefUserStore);
			
			me.close();
	    },
	    closeData: function(){
			var me = this;
			
		    me.close();
	    },
	    formShow: function(){
    		var me = this;
    		var docLinePopupTab = me.getRegItems()['DocLinePopupTab'];
    		
    		var docLineStore = docLinePopupWin.getRegItems()['LineView'].getStore();
    		var rcvUserStore = docLinePopupWin.getRegItems()['RcvUserView'].getStore();
    		var refUserStore = docLinePopupWin.getRegItems()['RefUserView'].getStore(); 
    		
    		tempDocLineStore.copyData(docLineStore);
    		tempDoubleLineStore.copyData(docLineStore);
    		tempRcvUserStore.copyData(rcvUserStore);
    		tempRefUserStore.copyData(refUserStore);
    		
    		docLinePopupTab.setActiveTab(me.getRegItems()['OpenType']); 
    	}
	});
	
	//DocLinePopup toolbar
	Ext.define('nbox.docLinePopupToolbar',    {
        extend:'Ext.toolbar.Toolbar',
		dock : 'top',
		
		config: {
			regItems: {}
		},
		
		initComponent: function () {
	    	var me = this;
	    	
	    	var formSearch = {
    			xtype: 'form',
    			border: false,
			  	layout: 'fit',
			  	id:'nbox.popupSearchForm',
			  	items: [
				  	{ 
				  		xtype: 'combo', scale: 'medium', 
					  	name: 'PATHID',
					  	store: commonDocPathStore,	
					  	valueField: 'pathID',
					  	displayField: 'pathName'
				  	}
				  ]
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
	        	    	
			me.items = [formSearch,btnQuery,btnConfirm, btnCancel];
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
	function openDocLinePopupWin(openType,lineType,LineView,RcvUserView,RefUserView) {
		// detailWin
		if(!docLinePopupWin){
			docLinePopupWin = Ext.create('nbox.docLinePopupWindow', { 
			}); 
		} 
		
		docLinePopupWin.getRegItems()['OpenType'] = openType;
		docLinePopupWin.getRegItems()['LineType'] = lineType;
		docLinePopupWin.getRegItems()['LineView'] = LineView;
		docLinePopupWin.getRegItems()['RcvUserView'] = RcvUserView;
	    docLinePopupWin.getRegItems()['RefUserView'] = RefUserView;
		
		docLinePopupWin.show();
    }	