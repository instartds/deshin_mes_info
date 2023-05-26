<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="${PRGID}" >
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	
	/**************************************************
	 * Require
	 **************************************************/
	Ext.require([
	    'Ext.ux.PreviewPlugin'/* , 
	    'Ext.LoadMask'  */
	]);
	
	/**************************************************
	 * Common variable
	 **************************************************/
	//local  variable
	var console = window.console;
	
	/**************************************************
	 * Common Code
	 **************************************************/	 
    Ext.define('nbox.docCommonPathStore', {
        extend:'Ext.data.Store', 
        fields: ["pathID", 'pathName'],
        autoLoad: true,
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
	
	// docPath 
	Ext.define('nbox.docPathModel', {
	    extend: 'Ext.data.Model',
	    fields: [
			{name: 'PathID'},
			{name: 'PathName'},
			{name: 'UserID'},
			{name: 'CompanyID'}
			
	    ]	    
	});

	//Path Line List
	Ext.define('nbox.docPathLineModel', {
	    extend: 'Ext.data.Model',
	    fields: [
			{name: 'PathID'},
			{name: 'LineType'},
			{name: 'Seq'},
			{name: 'SignType'},
			{name: 'SignUserID'},
			{name: 'SignUserName'},
			{name: 'SignUserDeptName'}
	    ]	    
	});	

	// Path RCV List
	Ext.define('nbox.docPathRcvUserModel', {
	    extend: 'Ext.data.Model',
	    fields: [
	    	{name: 'PathID'},
	    	{name: 'RcvType'}, 
	    	{name: 'DeptType'},
	    	{name: 'RcvUserID'}, 
	    	{name: 'RcvUserName'},
	    	{name: 'RcvUserDeptID'},
	    	{name: 'RcvUserDeptName'}
	    ]
	});	
	
	// Path REF List
	Ext.define('nbox.docPathRefUserModel', {
	    extend: 'Ext.data.Model',
	    fields: [
	    	{name: 'PathID'},
	    	{name: 'RcvType'}, 
	    	{name: 'DeptType'},
	    	{name: 'RcvUserID'}, 
	    	{name: 'RcvUserName'},
	    	{name: 'RcvUserDeptID'},
	    	{name: 'RcvUserDeptName'},
	    	{name: 'RcvUserPos'}
	    ]
	});			
	
	/**************************************************
	 * Store
	 **************************************************/
	//dept tree	
	Ext.define('nbox.docPathTreeStore', {
		extend:	'Ext.data.TreeStore', 
		model: 'nbox.deptTreeModel',
		autoLoad: true,
		proxy: {
	        type: 'direct',
	        api: {
	            read : 'nboxDocCommonService.selectDeptTree'
	        }
	    }  
	});
	
	//Doc Path
	Ext.define('nbox.docPathStore', {
		extend: 'Ext.data.Store', 
		model: 'nbox.docPathModel',
		autoLoad: false,
		proxy: {
            type: 'direct',
            api: { read: 'nboxDocPathService.select' },
            reader: {
	            type: 'json',
	            root: 'records'
	        }
        }
	});	
	
	//DocLine List
	Ext.define('nbox.docPathLineStore', { 
		extend:'Ext.data.Store', 
		model: 'nbox.docPathLineModel',
		autoLoad: true,
		proxy: {
            type: 'direct',
            extraParams: {LineType: 'A'},
            api: { read: 'nboxDocPathLineService.selects' },
            reader: {
	            type: 'json',
	            root: 'records'
	        }
        }
	});	

	//DocDoubleLine List
	Ext.define('nbox.docPathDoubleLineStore', { 
		extend: 'Ext.data.Store', 
		model: 'nbox.docPathLineModel',
		autoLoad: false,
		proxy: {
            type: 'direct',
            extraParams: {LineType: 'B'},
            api: { read: 'nboxDocPathLineService.selects' },
            reader: {
	            type: 'json',
	            root: 'records'
	        }
        }
	});		
	
	//RCV User List
	Ext.define('nbox.docPathRcvUserStore',{
		extend: 'Ext.data.Store', 
		model: 'nbox.docPathRcvUserModel',
		autoLoad: false,
		proxy: {
            type: 'direct',
            extraParams: {RcvType: 'C'},
            api: { read: 'nboxDocPathRcvUserService.selects' },
            reader: {
	            type: 'json',
	            root: 'records'
	        }
        }
	});	
	
	//REF User List
	Ext.define('nbox.docPathRefUserStore', {
		extend: 'Ext.data.Store', 
		model: 'nbox.docPathRefUserModel',
		autoLoad: false,
		proxy: {
            type: 'direct',
            extraParams: {RcvType: 'R'},
            api: { read: 'nboxDocPathRcvUserService.selects' }, 
            reader: {
	            type: 'json',
	            root: 'records'
	        }
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
		layout: 'fit',
		
		useArrows: false,
		animCollapse: true,
		animate: true,
		rootVisible: false,
		bodyBorder: false,
		
		width: 250,
		
		title: '부서 및 사용자를 더블클릭하십시요.',

		margins: '0 0 0 0',
		rowLines: false, lines: false,
		
		listeners: {
			itemdblclick: function( t, record, item, index, e, eOpts ){
				if ( record.data.id !== "" )  {
		  			var me = this;
		  			var activePanel =  null;
		  			var grid = null;
		  			var nboxDocPathTab = Ext.getCmp('nboxDocPathTab')
		  			
		  			if (nboxDocPathTab){
		  			    activePanel = nboxDocPathTab.getActiveTab();
    		  		    grid = activePanel.down('grid'); 
    		  			grid.addRecord(record);
    		  		} 
		  		} 
			}
		}
	});	 	
	
	// 결재라인 Grid
	Ext.define('nbox.docPathLineGrid',  {
		extend: 'Ext.grid.Panel',
		config: {
			
			regItems: {}
		},
		cls: "doc-tree iScroll",
		hideHeaders: false,
		border: false,
		scroll: 'vertical',
        initComponent: function () {
        	var me = this;
        	
        	me.columns= [
		        {
	  		        text: '부서',
		            sortable: true,
		            dataIndex: 'SignUserDeptName',
		            align: 'center',
		            groupable: false,
		            width: 100
		        }, 
		        {
		            text: '이름',
		            sortable: true,
		            dataIndex: 'SignUserName',
		            align: 'center',
		            groupable: false,
		            flex:1
		        }, 
		        {	
		        	xtype : 'checkcolumn',
		            text: '협조',
		            sortable: true,
		            dataIndex: 'SignType',
		            align: 'center',
		            groupable: false,
		            width: 50
		        }, 
		        /* {
		        	xtype : 'checkcolumn',
		            text: '이중결재',
		            sortable: true,
		            dataIndex: 'LineType',
		            align: 'center',
		            groupable: false,
		            width: 50
		        } , */
		        {
		        	xtype: 'actioncolumn',
					icon: NBOX_IMAGE_PATH + "grid_delete.png" ,
					tooltip: '삭제',
					width: 25 ,
					handler: function(grid, rowIndex, colIndex) {
						var record = grid.store.getAt(rowIndex);
						
						if (record.data.Seq == 1) {
							Ext.Msg.alert('확인', '기안자는 삭제할 수 없습니다.');
							return false;
						} 
						me.deleteRecord(rowIndex);
						return true;
					}
				} 
			];
        	
	       	me.callParent();
        },
        addRecord: function(record){
    		var me = this;
    		var store = me.getStore();
    		
    		if(record.data.DeptType == 'P') {
    			
    			if(store.findRecord('SignUserID', record.data.TREE_CODE) !== null )
        			return ;
    			
	  			var newRecord = {
	  				DocumentID: null,
	  				LineType: 'A',
	  				SignUserID: record.data.TREE_CODE,
	  				SignUserName: record.data.UserName,
	  				SignUserDeptName: record.data.UserDeptName
  		        }; 
				
	  			store.add(newRecord);
			}
    	},
    	deleteRecord: function(rowIndex){
    		var me = this;
    		var last;
    		var store = me.getStore();
    		var record = store.getAt(rowIndex);
    		var selModel = me.getSelectionModel();
    		
    		last = selModel.getSelection()[0];
    		store.remove(record);
    	},
        queryData: function(){
        	var me = this;
        	var param = null;
	    	var store = me.getStore();
	    	
	    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
            var nboxSearchForm = Ext.getCmp('nboxSearchForm');
            
            if (nboxSearchForm)
            	param = nboxSearchForm.getValues();
	    	
   			store.load({params:param,
       			callback: function(records, operation, success) {
       				if (success){
       					me.loadData();
       				}
       			}
   			});
    	},
    	newData: function(){
    		var me = this;
    		
    		me.clearData();
    	},
	    clearData: function(){
	    	var me = this;
	    	
    		me.clearPanel();
    		me.queryData();
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
	Ext.define('nbox.docPathDoubleLineGrid',  {
		extend: 'Ext.grid.Panel',
		config: {

			regItems: {}
		},
		hideHeaders: false,
		border: false,
		
        initComponent: function () {
        	var me = this;
        	
        	me.columns= [
		        {
	  		        text: '부서',
		            sortable: true,
		            dataIndex: 'SignUserDeptName',
		            align: 'center',
		            groupable: false,
		            width: 100
		        }, 
		        {
		            text: '이름',
		            sortable: true,
		            dataIndex: 'SignUserName',
		            align: 'center',
		            groupable: false,
		            flex:1
		        }, 
		        {	
		        	xtype : 'checkcolumn',
		            text: '협조',
		            sortable: true,
		            dataIndex: 'SignType',
		            align: 'center',
		            groupable: false,
		            width: 50
		        }, 
		        /* {
		        	xtype : 'checkcolumn',
		            text: '이중결재',
		            sortable: true,
		            dataIndex: 'LineType',
		            align: 'center',
		            groupable: false,
		            width: 50
		        } , */
		        {
		        	xtype: 'actioncolumn',
					icon: NBOX_IMAGE_PATH + "grid_delete.png" ,
					tooltip: '삭제',
					width: 25 ,
					handler: function(grid, rowIndex, colIndex) {
						me.deleteRecord(rowIndex);
						return true;
					}
				} 
			];
        	
	       	me.callParent();
        },
        addRecord: function(record){
    		var me = this;
    		var store = me.getStore();
    		
    		if(record.data.DeptType == 'P') {
    			
    			if(store.findRecord('SignUserID', record.data.TREE_CODE) !== null )
        			return ;
    			
	  			var newRecord = {
	  				DocumentID: null,
	  				LineType: 'B',
	  				SignUserID: record.data.TREE_CODE,
	  				SignUserName: record.data.UserName,
	  				SignUserDeptName: record.data.UserDeptName
  		        }; 
				
	  			store.add(newRecord);
			}
    	},
    	deleteRecord: function(rowIndex){
    		var me = this;
    		var last;
    		var store = me.getStore();
    		var record = store.getAt(rowIndex);
    		var selModel = me.getSelectionModel();
    		
    		last = selModel.getSelection()[0];
    		store.remove(record);
    	},
        queryData: function(){
        	var me = this;
        	var param = null;
	    	var store = me.getStore();
	    	
	    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
            var nboxSearchForm = Ext.getCmp('nboxSearchForm');
            
            if (nboxSearchForm)
            	param = nboxSearchForm.getValues();
	    	
   			store.load({params:param,
       			callback: function(records, operation, success) {
       				if (success){
       					me.loadData();
       				}
       			}
   			});
    	},
    	newData: function(){
    		var me = this;
    		
    		me.clearData();
    	},
	    clearData: function(){
	    	var me = this;
	    	
    		me.clearPanel();
    		me.queryData();
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
	Ext.define('nbox.docPathRcvUserGrid',  {
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
						me.deleteRecord(rowIndex);
					}
				}
			];
        	
	       	me.callParent();
        },
        addRecord: function(record){
    		var me = this;
    		var store = me.getStore();
    		var newRecord ;
    		
    		if(record.data.DeptType == 'P') {
    			if(store.findRecord('RcvUserID', record.data.TREE_CODE) !== null )
    				return ;
    		
	  			newRecord = {
	  				DocumentID: null,
	  				RcvType: 'C',
	  				DeptType: record.data.DeptType,
	  				RcvUserID: record.data.TREE_CODE,
	  				RcvUserName: record.data.UserName,
	  				RcvUserDeptID: record.data.UserDeptID,
	  				RcvUserDeptName: record.data.UserDeptName
	 		    }; 
    		}else{
    			
    			if(store.findRecord('RcvUserDeptID', record.data.TREE_CODE) !== null )
    				return ;
    		
	  			newRecord = {
	  				DocumentID: null,
	  				RcvType: 'C',
	  				DeptType: record.data.DeptType,
	  				RcvUserID: '*',
	  				RcvUserName: record.data.UserDeptName,
	  				RcvUserDeptID: record.data.UserDeptID,
	  				RcvUserDeptName: record.data.UserDeptName
	 		    }; 
    		}
			
			store.add(newRecord);
    	},
    	deleteRecord: function(rowIndex){
    		var me = this;
    		var last;
    		var store = me.getStore();
    		var record = store.getAt(rowIndex);
    		var selModel = me.getSelectionModel();
    		
    		last = selModel.getSelection()[0];

    		store.remove(record);
    	},
        queryData: function(){
        	var me = this;
        	var param = null;
	    	var store = me.getStore();
	    	
	    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	    	var nboxSearchForm = Ext.getCmp('nboxSearchForm');
	    	
	    	if (nboxSearchForm)
	    		   param = nboxSearchForm.getValues();
	    	
   			store.load({params:param,
       			callback: function(records, operation, success) {
       				if (success){
       					me.loadData();
       				}
       			}
   			});
    	},
    	newData: function(){
    		var me = this;
    		
    		me.clearData();
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
	Ext.define('nbox.docPathRefUserGrid',  {
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
						me.deleteRecord(rowIndex);
					}
				}
			];
        	
	       	me.callParent();
        },
        addRecord: function(record){
    		var me = this;
    		var store = me.getStore();
			var newRecord ;
    		
    		if(record.data.DeptType == 'P') {
    			if(store.findRecord('RcvUserID', record.data.TREE_CODE) !== null )
    				return ;
    		
	  			newRecord = {
	  				DocumentID: null,
	  				RcvType: 'R',
	  				DeptType: record.data.DeptType,
	  				RcvUserID: record.data.TREE_CODE,
	  				RcvUserName: record.data.UserName,
	  				RcvUserDeptID: record.data.UserDeptID,
	  				RcvUserDeptName: record.data.UserDeptName
	 		    }; 
    		}else{
    			
    			if(store.findRecord('RcvUserDeptID', record.data.TREE_CODE) !== null )
    				return ;
    		
	  			newRecord = {
	  				DocumentID: null,
	  				RcvType: 'R',
	  				DeptType: record.data.DeptType,
	  				RcvUserID: '*',
	  				RcvUserName: record.data.UserDeptName,
	  				RcvUserDeptID: record.data.UserDeptID,
	  				RcvUserDeptName: record.data.UserDeptName
	 		    }; 
    		}
			
			store.add(newRecord);
    	},
    	deleteRecord: function(rowIndex){
    		var me = this;
    		var last;
    		var store = me.getStore();
    		var record = store.getAt(rowIndex);
    		var selModel = me.getSelectionModel();
    		
    		last = selModel.getSelection()[0];

    		store.remove(record);
    	},
        queryData: function(){
        	var me = this;
        	var param = null;
	    	var store = me.getStore();
	    	
	    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
        	var nboxSearchForm = Ext.getCmp('nboxSearchForm');
        	
        	if (nboxSearchForm)
            	param = nboxSearchForm.getValues();
    	    	
   			store.load({params:param,
       			callback: function(records, operation, success) {
       				if (success){
       					me.loadData();
       				}
       			}
   			});
        	
    	},
    	newData: function(){
			var me = this;
	    	
    		me.clearData();
    	},
    	saveData: function(){
    		
    	},
    	deleteData: function(){
    		
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
	
	//Detail Panel
	Ext.define('nbox.docPathPanel', {
		extend: 'Ext.form.Panel',
		config: {
			store:null,
			regItems: {}
	    },
	    
	    title : '&nbsp;',
	    layout: 'vbox',
	    
	    api: { submit: 'nboxDocPathService.save' }, 
	    
	    border: true,
	    initComponent: function () {
	    	var me = this;

			me.items = [{ 
				xtype:'textfield',
				name: 'PathID',
				id: 'nboxDocPathIDTextfield',
				fieldLabel: '결재경로ID',
				labelAlign : 'right',
				labelClsExtra: 'field_label',
				allowBlank:false,
				width:600,
				padding: '3px 3px 0px 3px',
				disabled : true
			},	
			{ 
				xtype:'textfield',
				name: 'PathName',
				id:'nboxDocPathNameTextfield',
				fieldLabel: '결재경로명',
				labelAlign : 'right',
				labelClsExtra: 'required_field_label',
				allowBlank:false,
				padding: '3px 3px 0px 3px',
				width:600
			}];
			
	    	me.callParent();
	    },
	    queryData: function(){
	    	var me = this;
	    	var param = null;
	    	var store = me.getStore();
	    	
	    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
        	var nboxSearchForm = Ext.getCmp('nboxSearchForm');
        	
        	if (nboxSearchForm)
        		   param = nboxSearchForm.getValues();
        	
        	if (param.PATHID != ""){
        		store.load({
       				params:param,
           			callback: function(records, operation, success) {
           				if (success){
           					me.loadData();
           				}
           			}
       			}); 
        	}
   			var nboxDocPathTab = Ext.getCmp('nboxDocPathTab');
   			if (nboxDocPathTab)
   			  nboxDocPathTab.queryData();
	    },
	    newData: function(){
	    	var me = this;
	    	var searchitem = null;
	    	
	    	var nboxDocPathCombo = Ext.getCmp('nboxDocPathCombo');
	    	var nboxDocCommonPathStore = nboxDocPathCombo.getStore();
	    	nboxDocCommonPathStore.reload();
	    	
	    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
	    	var nboxDocPathPanel = Ext.getCmp('nboxDocPathPanel');
	    	var nboxSearchForm = Ext.getCmp('nboxSearchForm');
	    	var nboxDocPathCombo = Ext.getCmp('nboxDocPathCombo');
	    	
	    	if (nboxDocPathCombo){
	    		nboxDocPathCombo.setValue('');
	    	}
	    	me.clearData();
	    },
    	saveData: function(){
			var me = this;
			var pathID = null;
			var actionType = null;
			
			var nboxDocPathIDTextfield = Ext.getCmp('nboxDocPathIDTextfield');
			
			if (nboxDocPathIDTextfield){
				  pathID =nboxDocPathIDTextfield.getValue();
			}
			
	    	if (pathID == "" || pathID == null)
	    		actionType = NBOX_C_CREATE;
	    	else
	    		actionType = NBOX_C_UPDATE;
	    	
	    	var nboxDocPathTab = Ext.getCmp('nboxDocPathTab');
	    	var nboxDocPathLineGrid = Ext.getCmp('nboxDocPathLineGrid');
	    	var nboxDocPathDoubleLineGrid = Ext.getCmp('nboxDocPathDoubleLineGrid');
	    	var nboxDocPathRcvUserGrid = Ext.getCmp('nboxDocPathRcvUserGrid');
	    	var nboxDocPathRefUserGrid = Ext.getCmp('nboxDocPathRefUserGrid')
	    	
	    	var doclinelist = []; 
			var doclines = nboxDocPathLineGrid.getStore().data.items;
			Ext.each(doclines,function(record){
				doclinelist.push(me.JSONtoString(record.data));
			});
			
			if (doclinelist.length < 1) 
				doclinelist = null;
			
			var doublelinelist = []; 
			var doublelines = nboxDocPathDoubleLineGrid.getStore().data.items;
			Ext.each(doublelines,function(record){
				doublelinelist.push(me.JSONtoString(record.data));
			});
			
			if (doublelinelist.length < 1) 
				doublelinelist = null;
	    	
			var rcvuserlist = []; 
			var rcvusers = nboxDocPathRcvUserGrid.getStore().data.items;
			Ext.each(rcvusers,function(record){
				rcvuserlist.push(me.JSONtoString(record.data));
			});
			
			if (rcvuserlist.length < 1) 
				rcvuserlist = null;
	    	
			var refuserlist = []; 
			var refusers = nboxDocPathRefUserGrid.getStore().data.items;
			Ext.each(refusers,function(record){
				refuserlist.push(me.JSONtoString(record.data));
			});
			
			if (refuserlist.length < 1) 
				refuserlist = null;
	    	
	    	var param = {
				 'PathID': pathID, 
			     'ActionType': actionType,
			     
			     'DOCLINES' : doclinelist,
			     'DOUBLELINES': doublelinelist,
			     'RCVUSERS' : rcvuserlist,
			     'REFUSERS' : refuserlist 
			};	
	    	
	    	if (me.isValid()) {
				me.submit({
	               	params: param,
					success: function(obj, action) {
						Ext.Msg.alert('확인', '저장되었습니다.');
						
						var nboxDocPathCombo = Ext.getCmp('nboxDocPathCombo');
			            var nboxDocCommonPathStore = nboxDocPathCombo.getStore();
			            nboxDocCommonPathStore.reload();
						
						if(actionType == NBOX_C_CREATE)
							me.newData();
						else
							me.queryData();
	            	}
	            });
           }
           else {
           		Ext.Msg.alert('확인', me.validationCheck());
           };
        },	    
        deleteData: function(){
        	var me = this;
        	var pathID = null;
        	
        	var nboxDocPathIDTextfield = Ext.getCmp('nboxDocPathIDTextfield');
        	
        	if (nboxDocPathIDTextfield)
        		   pathID = nboxDocPathIDTextfield.getValue();
        	
	    	var actionType = 'D';
	    	
	    	if (pathID == "" || pathID == null){
	    		Ext.Msg.alert('확인', '삭제할 데이터가 존재하지 않습니다.');
	    		return;
	    	}
	    	
	    	var doclinelist = null;
	    	var doublelinelist = null;
	    	var rcvuserlist = null;
	    	var refuserlist = null;
	    	
	    	var param = {
				 'PathID': pathID, 
			     'ActionType': actionType,
			     
			     'DOCLINES' : doclinelist,
			     'DOUBLELINES': doublelinelist,
			     'RCVUSERS' : rcvuserlist,
			     'REFUSERS' : refuserlist 
			};	
	    	
	    	if (me.isValid()) {
				me.submit({
	               	params: param,
					success: function(obj, action) {
						Ext.Msg.alert('확인', '삭제되었습니다.');
						me.newData();
	            	}
	            });
           }
	    },
	    loadData: function(){
	    	var me = this;
	    	var store = me.getStore();
	    	var frm = me.getForm();
	    	
	    	if (store.getCount() > 0)
	    	{
				var record = store.getAt(0);
				frm.loadRecord(record);
	    	}
	    },
	    clearData: function(){
	    	var me = this;
	    	me.clearPanel();
	    	
	    	var nboxDocPathTab = Ext.getCmp('nboxDocPathTab');
	    	if (nboxDocPathTab)
	    		nboxDocPathTab.clearData();
	    },
	    clearPanel: function(){
	    	var me = this;
	    	var store = me.getStore();
	    	var frm = me.getForm();
	    	
			store.removeAll();
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
	    JSONtoString: function (object) {
	        var results = [];
	        for (var property in object) {
	            var value = object[property];
	            if (value)
	                results.push('\"' + property.toString() + '\": \"' + value + '\"');
	            }
	                     
	            return '{' + results.join(String.fromCharCode(11)) + '}';
	    }
	});	
	
	//Tab Panel
	Ext.define('nbox.docPathTab', {
		extend: 'Ext.tab.Panel',
		config: {
			regItems: {}    	
		},
		
	    border: false,
	    
	    initComponent: function () {
	    	var me = this;
	    	
	    	var nboxDocPathLineStore = Ext.create('nbox.docPathLineStore', {
	    		id: 'nboxDocPathLineStore'
	    	});
	    	
	    	var nboxDocPathDoubleLineStore = Ext.create('nbox.docPathDoubleLineStore', {
	    		id: 'nboxDocPathDoubleLineStore'
	    	});
	    	
	    	var nboxDocPathRcvUserStore = Ext.create('nbox.docPathRcvUserStore',{
	    		id : 'nboxDocPathRcvUserStore'
	    	});
	    	
	    	var nboxDocPathRefUserStore = Ext.create('nbox.docPathRefUserStore', {
	    		id:'nboxDocPathRefUserStore'
	    	});
	    	
	    	var nboxDocPathLineGrid = Ext.create('nbox.docPathLineGrid',{
	    		id:'nboxDocPathLineGrid',
	    		store: nboxDocPathLineStore
        	});
	    	
	    	var nboxDocPathDoubleLineGrid = Ext.create('nbox.docPathDoubleLineGrid',{
	    		id:'nboxDocPathDoubleLineGrid',
	    		store: nboxDocPathDoubleLineStore
        	});
	    	
	    	var nboxDocPathRcvUserGrid = Ext.create('nbox.docPathRcvUserGrid',{
	    		id:'nboxDocPathRcvUserGrid',
        		store: nboxDocPathRcvUserStore
        	});
	    	
	    	var nboxDocPathRefUserGrid = Ext.create('nbox.docPathRefUserGrid',{
	    		id: 'nboxDocPathRefUserGrid',
        		store: nboxDocPathRefUserStore
        	});
	    	
	    	var docPathLineGridPanel = Ext.create('Ext.panel.Panel', {
	    		title: '결재',
	    		layout: {
	    	        type: 'fit'
	    	    } ,
	    	    items: [nboxDocPathLineGrid]
	    	});
	    	
	    	var docPathDoubleLineGridPanel = Ext.create('Ext.panel.Panel', {
	    		title: '이중결재',
	    		layout: {
	    	        type: 'fit'
	    	    } ,
	    	    items: [nboxDocPathDoubleLineGrid],
	    	    hidden : true
	    	});
	    	
	    	var docPathRcvUserGridPanel = Ext.create('Ext.panel.Panel', {
	    		title: '수신',
	    		layout: {
	    	        type: 'fit'
	    	    } ,
	    	    items: [nboxDocPathRcvUserGrid],
	    	    hidden : true
	    	});
	    	
	    	var docPathRefUserGridPanel = Ext.create('Ext.panel.Panel', {
	    		title: '참조',
	    		layout: {
	    	        type: 'fit'
	    	    } ,
	    	    items: [nboxDocPathRefUserGrid],
	    	    hidden : true
	    	});
	    	
	    	me.items = [ docPathLineGridPanel, docPathDoubleLineGridPanel, docPathRcvUserGridPanel, docPathRefUserGridPanel ];
	    	me.callParent();
	    },
	    queryData: function(){
	    	var me = this;
	    	
	    	var nboxDocPathLineGrid = Ext.getCmp('nboxDocPathLineGrid');
	    	var nboxDocPathDoubleLineGrid = Ext.getCmp('nboxDocPathDoubleLineGrid');
	    	var nboxDocPathRcvUserGrid = Ext.getCmp('nboxDocPathRcvUserGrid');
	    	var nboxDocPathRefUserGrid = Ext.getCmp('nboxDocPathRefUserGrid');
	    	
	    	if (nboxDocPathLineGrid)
	    		  nboxDocPathLineGrid.queryData();
	    	if (nboxDocPathDoubleLineGrid)
	    		nboxDocPathDoubleLineGrid.queryData();
	    	if (nboxDocPathRcvUserGrid)
	    		nboxDocPathRcvUserGrid.queryData();
	    	if (nboxDocPathRefUserGrid)
	    		  nboxDocPathRefUserGrid.queryData();
	    },
	    newData: function(){
	    	var me = this;
	    	
	    	var nboxDocPathLineGrid = Ext.getCmp('nboxDocPathLineGrid');
            var nboxDocPathDoubleLineGrid = Ext.getCmp('nboxDocPathDoubleLineGrid');
            var nboxDocPathRcvUserGrid = Ext.getCmp('nboxDocPathRcvUserGrid');
            var nboxDocPathRefUserGrid = Ext.getCmp('nboxDocPathRefUserGrid');
	    	
            if (nboxDocPathLineGrid)
            	nboxDocPathLineGrid.newData();
            if (nboxDocPathDoubleLineGrid)
            	nboxDocPathDoubleLineGrid.newData();
            if (nboxDocPathRcvUserGrid)
            	nboxDocPathRcvUserGrid.newData();
            if (nboxDocPathRefUserGrid)
            	nboxDocPathRefUserGrid.newData();
	    },
    	saveData: function(){
    		
        },	    
        deleteData: function(){
        	
	    },
	    clearData: function(){
	    	var me = this;
    		
	    	var nboxDocPathLineGrid = Ext.getCmp('nboxDocPathLineGrid');
            var nboxDocPathDoubleLineGrid = Ext.getCmp('nboxDocPathDoubleLineGrid');
            var nboxDocPathRcvUserGrid = Ext.getCmp('nboxDocPathRcvUserGrid');
            var nboxDocPathRefUserGrid = Ext.getCmp('nboxDocPathRefUserGrid');
	    	
            if (nboxDocPathLineGrid)
            	nboxDocPathLineGrid.clearData();
            if (nboxDocPathDoubleLineGrid)
            	nboxDocPathDoubleLineGrid.clearData();
            if (nboxDocPathRcvUserGrid)
            	nboxDocPathRcvUserGrid.clearData();
            if (nboxDocPathRefUserGrid)
            	nboxDocPathRefUserGrid.clearData();
	    }
	}); 
	
	// Contents Detail Panel
	Ext.define('nbox.contentsDetailPanel', {
		extend: 'Ext.form.Panel',
		config: {
			store:null,
			regItems: {}
		},
		
		layout : {	
    		type: 'vbox', 
    		align: 'stretch' 
    	},
		
		border:false,
		
		initComponent: function () {
	    	var me = this;
	    	
	    	var nboxDocPathStore = Ext.create('nbox.docPathStore', {
	    		id:'nboxDocPathStore'	    		
	    	});
	    	
	    	var nboxDocPathPanel = Ext.create('nbox.docPathPanel',{
	    		id:'nboxDocPathPanel',
	    		store: nboxDocPathStore
	    	});
	    	
	    	var nboxDocPathTab = Ext.create('nbox.docPathTab',{
	    		id:'nboxDocPathTab',
	    		flex: 1
	    	});
	    	
			
			me.items = [nboxDocPathPanel, nboxDocPathTab];
	        me.callParent(); 
	    },
	    queryData: function(){
	    	var me = this;
	    	var nboxDocPathPanel = Ext.getCmp('nboxDocPathPanel');
	    	
	    	if (nboxDocPathPanel)
	    		nboxDocPathPanel.queryData();
	    },
	    newData: function(){
	    	var me = this;
	        var nboxDocPathPanel = Ext.getCmp('nboxDocPathPanel');
            
            if (nboxDocPathPanel)
                nboxDocPathPanel.newData();
	    },
    	saveData: function(){
    		var me = this;
    	    var nboxDocPathPanel = Ext.getCmp('nboxDocPathPanel');
            
            if (nboxDocPathPanel)
                nboxDocPathPanel.saveData(); 
        },	    
        deleteData: function(){
        	var me = this;
            var nboxDocPathPanel = Ext.getCmp('nboxDocPathPanel');
            
            if (nboxDocPathPanel)
                nboxDocPathPanel.deleteData();
	    },
	    clearData: function(){
	    	var me = this;
	        var nboxDocPathPanel = Ext.getCmp('nboxDocPathPanel');
            
            if (nboxDocPathPanel)
                nboxDocPathPanel.clearData();
	    }
	});
	
	// contentsPanel
	Ext.define('nbox.contentsPanel', {
		extend: 'Ext.form.Panel',
		config: {
			store:null,
			regItems: {}
		},
		
		layout: {
			type: 'hbox',
	        align: 'stretch'
		},
		
		border:false,

		initComponent: function () {
	    	var me = this;
	    	
	    	var nboxDocPathTreeStore = Ext.create('nbox.docPathTreeStore',{
	    		id: 'nboxDocPathTreeStore'
	    	});
	    		
	    	var nboxDeptTree = Ext.create('nbox.deptTree',{
	    		id: 'nboxDeptTree',
				store: nboxDocPathTreeStore
			});
	    	
	    	nboxDeptTree.expandAll();
	    	
	    	var nboxContentsDetailPanel = Ext.create('nbox.contentsDetailPanel',{
	    		id:'nboxContentsDetailPanel',
	    		flex: 1
	    	});
			
			me.items = [nboxDeptTree, nboxContentsDetailPanel];
	        me.callParent(); 
	    },
	    queryData: function(){
	    	var me = this;
	    	var nboxContentsDetailPanel = Ext.getCmp('nboxContentsDetailPanel');
	    	
	    	if (nboxContentsDetailPanel)
	    		nboxContentsDetailPanel.queryData(); 
	    },
	    newData: function(){
	    	var me = this;
	        var nboxContentsDetailPanel = Ext.getCmp('nboxContentsDetailPanel');
            
            if (nboxContentsDetailPanel)
                nboxContentsDetailPanel.newData();
	    },
    	saveData: function(){
    		var me = this;
    	    var nboxContentsDetailPanel = Ext.getCmp('nboxContentsDetailPanel');
            
            if (nboxContentsDetailPanel)
                nboxContentsDetailPanel.saveData(); 
        },	    
        deleteData: function(){
        	var me = this;
            var nboxContentsDetailPanel = Ext.getCmp('nboxContentsDetailPanel');
            
            if (nboxContentsDetailPanel)
                nboxContentsDetailPanel.deleteData();
	    },
	    clearData: function(){
	    	var me = this;
	        var nboxContentsDetailPanel = Ext.getCmp('nboxContentsDetailPanel');
            
            if (nboxContentsDetailPanel)
                nboxContentsDetailPanel.clearData();
	    }
	});
	
	//Viewport toolbar
	Ext.define('nbox.viewportToolbar',    {
        extend:'Ext.toolbar.Toolbar',
		config: {
			regItems: {}
		},
		dock : 'top',
		height: 30, 
		padding: '0 0 0 5px',
		
		initComponent: function () {
	    	var me = this;
	    	var btnWidth = 60;
	    	var btnHeight = 26;
	    	
	    	var nboxDocCommonPathStore =  Ext.create('nbox.docCommonPathStore',{
	    		id:'nboxDocCommonPathStore'
	    	});
	    	
	    	var formSearch = {
    			xtype: 'form',
    			border: false,
			  	layout: 'fit',
			  	id:'nboxSearchForm',
			  	items: [
				  	{ 
					  	xtype: 'combo', scale: 'medium', 
					  	name: 'PATHID',
					  	id: 'nboxDocPathCombo',
					  	store: nboxDocCommonPathStore,	
					  	valueField: 'pathID',
					  	displayField: 'pathName'
				  	}
				  ]
    		};
	    	
	    	var btnQuery =  {	
				xtype: 'button', 
				//scale: 'medium',
				tooltip: '검색',
				//text: '<img src="' + NBOX_IMAGE_PATH + 'baseButton/search16a.png" width=15 height=15/>&nbsp;<label>검색</label>', 
				text: '검색',
			    itemId: 'query',
			    width: btnWidth,  
			    height: btnHeight,
			    style: { margin: '0px 0px 0px 3px' },  
			    handler: function() {
			    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
			    	
			    	if (nboxBaseApp)
			    		nboxBaseApp.QueryButtonDown();
			    }
			};
	    	
	    	var btnNew =  {	
				xtype: 'button', 
				//scale: 'medium',
				tooltip: '새경로',
				//text: '<img src="' + NBOX_IMAGE_PATH + 'baseButton/new16a.png" width=15 height=15/>&nbsp;<label>새경로</label>', 
				text: '새경로',
			    itemId: 'new',
			    width: btnWidth,  
                height: btnHeight,
                style: { margin: '0px 0px 0px 3px' },
			    handler: function() {
			        var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                    
                    if (nboxBaseApp)
                        nboxBaseApp.NewButtonDown();
			    }
			};
   	
	    	var btnSave =  {	
				xtype: 'button', 
				//scale: 'medium',
				tooltip: '저장',
				//text: '<img src="' + NBOX_IMAGE_PATH + 'baseButton/save16a.png" width=15 height=15/>&nbsp;<label>저장</label>', 
				text: '저장',
			    itemId: 'save',
			    width: btnWidth,  
                height: btnHeight,
                style: { margin: '0px 0px 0px 3px' },        
			    handler: function() {
			        var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                    
                    if (nboxBaseApp)
                        nboxBaseApp.SaveButtonDown();
			    }
			};
	    	
	    	var btnDelete =  {	
				xtype: 'button', 
				//scale: 'medium',
				tooltip: '삭제',
				//text: '<img src="' + NBOX_IMAGE_PATH + 'baseButton/delete16a.png" width=15 height=15/>&nbsp;<label>삭제</label>',
				text: '삭제',
			    itemId: 'delete',
			    width: btnWidth,  
                height: btnHeight,
                style: { margin: '0px 0px 0px 3px' },        
			    handler: function() {
			        var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                    
                    if (nboxBaseApp)
                        nboxBaseApp.DeleteButtonDown();
			    }
			};
				
			var btnClose = {
				xtype: 'button', 
				//scale: 'medium',
			 	tooltip : '닫기',
			 	//text: '<img src="' + NBOX_IMAGE_PATH + 'baseButton/close16a.png" width=15 height=15/>&nbsp;<label>닫기</label>', 
			 	text: '닫기',
                itemId : 'close',
                width: btnWidth,  
                height: btnHeight,
                style: { margin: '0px 0px 0px 3px' },
                handler: function() { 
                    var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                    
                    if (nboxBaseApp)
                        nboxBaseApp.CloseButtonDown();
                }
			};
			
		    var toolbarItems = [ formSearch, btnQuery, btnNew, btnSave, btnDelete, btnClose ];    
		        
	        //var chk01 = false;
	        var chk01 = ( typeof IS_DEVELOPE_SERVER == "undefined") ? false : IS_DEVELOPE_SERVER ;
			if( chk01 ) {
				toolbarItems.push( // space
					'->',
					{
						xtype : 'button',
						text : '',
						tooltip : '현재탭 Reload(Cache 사용 안함!)', 
						iconCls: 'icon-reload',
						handler : function() {
							location.reload(true );
						}
					},
					{
						xtype : 'button',
						text : '',
						tooltip : '현재 Tab을 새창으로 띄우기', 
						iconCls: 'icon-newWindow',
						handler : function() {
							window.open(window.location.href, '_blank');
						}
					}
				);
			}
	        	    	
			me.items = toolbarItems;
			
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
	
	//Viewport
	Ext.define('nbox.baseApp', {
		extend: 'Ext.Viewport',
		config:{
			regItems: {}
		},
	    defaults: { padding: 0 },
    	layout : {	
    		type: 'vbox', 
    		pack: 'start', 
    		align: 'stretch' 
    	},
	    initComponent: function () {
	    	var me = this;
	    	var btnWidth = 26;
			var btnHeight = 26;	
	        
			var title = {
	            xtype: 'container',
	            cls: 'uni-pageTitle',
	            id: 'UNILITE_PG_TITLE',
                html: "${PGM_TITLE}",
	            padding: '0 0 5px 0',
	            height: 32,
	            region:'north'
	        };
	        
			var nboxViewportToolbar = Ext.create('nbox.viewportToolbar',{
				id:'nboxViewportToolbar'
			});
			var nboxContentsPanel = Ext.create('nbox.contentsPanel',{
				id: 'nboxContentsPanel',
				flex: 1,
			});
	    	
			
	    	me.items = [title, nboxViewportToolbar, nboxContentsPanel];
	    	
	        me.callParent(); 
	    },
	    QueryButtonDown: function(){
			var me = this;
	    	
	    	me.queryData();
	    },
	    NewButtonDown: function(){
			var me = this;
	    	
	    	me.newData();
	    },
	    SaveButtonDown: function(){
	    	var me = this;
	    	
	    	me.saveData();
	    },
	    DeleteButtonDown: function(){
	    	var me = this;
	    	
	    	me.deleteData();
	    },
	    CloseButtonDown: function(){
	        var me = this;
	        
	        me.closeData();
	    },   
	    queryData: function(){
	    	var me = this;
	    	var nboxContentsPanel = Ext.getCmp('nboxContentsPanel');
	    	
	    	if (nboxContentsPanel)
	    		nboxContentsPanel.queryData();
	    },
	    newData: function(){
	    	var me = this;
	        var nboxContentsPanel = Ext.getCmp('nboxContentsPanel');
            
            if (nboxContentsPanel)
                nboxContentsPanel.newData();
	    },
    	saveData: function(){
    		var me = this;
    	    var nboxContentsPanel = Ext.getCmp('nboxContentsPanel');
            
            if (nboxContentsPanel)
                nboxContentsPanel.saveData();
        },	    
        deleteData: function(){
        	var me = this;
            var nboxContentsPanel = Ext.getCmp('nboxContentsPanel');
            
            if (nboxContentsPanel)
                nboxContentsPanel.deleteData();
	    },
	    closeData: function(){
	    	var tabPanel = parent.Ext.getCmp('contentTabPanel');
	    	
			if(tabPanel) {
				var activeTab = tabPanel.getActiveTab();
				var canClose = activeTab.onClose(activeTab);
				if(canClose)  {
					tabPanel.remove(activeTab);
				}
			} else {
				me.hide();
			}
	    }
	});
	
	/**************************************************
	 * Create
	 **************************************************/
	//Load Mask
	//var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"Please wait..."});
	
    //Viewport Create
	Ext.create('nbox.baseApp',  {
		id: 'nboxBaseApp'
	});
	
	
	/**************************************************
	 * User Define Function
	 **************************************************/


}; // appMain

</script>	
