
/**************************************************
 * Common variable
 **************************************************/
//local  variable
var docBasisPopupWin ;
var docBasisPopupWidth = 600;
var docBasisPopupHeight = 500;
var popupDocBasisStore;
var tempDocBasisStore;
/**************************************************
 * Common Code
 **************************************************/
	

/**************************************************
 * Model
 **************************************************/
//DocBasis Model	
Ext.define('nbox.popupDocBasisModel', {
    extend: 'Ext.data.Model',
    fields: [
		{name: 'DocumentID'}, 
		{name: 'FileAttachFlag', type: 'int'},
    	{name: 'DocumentNo'}, 
    	{name: 'Subject'},
    	{name: 'Status'},
    	{name: 'DraftDate', type: 'date', dateFormat:'Y-m-d H:i:s'},
    	{name: 'DraftUserName'}
    ]
});

Ext.define('nbox.popupMyDocBasisModel', {
    extend: 'Ext.data.Model',
    fields: [
		{name: 'RefDocumentID'}, 
		{name: 'RefDocumentNo'}
    ]
});	

/**************************************************
 * Store
 **************************************************/
//docBasis List
Ext.define('nbox.popupDocBasisStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.popupDocBasisModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxDocBasisService.selects' },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});	

//MyDocBasis List
Ext.define('nbox.tempDocBasisStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.popupMyDocBasisModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { read: 'nboxDocBasisService.selectByDoc' },
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
// DocBasis Grid
Ext.define('nbox.docBasisGrid',  {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	padding: '3px 3px 0px 3px',
	hideHeaders: false,
	border: false,
	width: 400,
	height: '100%',
	
	title: '추가하고자 하는 근거문서를 더블클릭 하십시오.',
	
    initComponent: function () {
    	var me = this;
    	
    	me.columns= [
			{
				xtype: 'actioncolumn',
				icon: NBOX_IMAGE_PATH + "grid_preview.png" ,
				tooltip: '미리보기',
				width: 25,
				handler: function(grid, rowIndex, colIndex) {
					var record = grid.store.getAt(rowIndex);
					me.previewData(record);
				}
			},
			{
				text: '<img src="' + NBOX_IMAGE_PATH + 'Attach.gif" width=13 height=13/>',	
		       	sortable: false,
		       	dataIndex: 'FileAttachFlag',
		       	groupable: false,
		       	align : 'center',
		       	width: 30,
				renderer: function(value){
					if(value==1)
						return imgpath = '<img src="' + NBOX_IMAGE_PATH + 'Attach.gif" width=13 height=13/>';
			    }            
			}, 
			{
			   	text: '문서번호',
			    sortable: true,
			    dataIndex: 'DocumentNo',
			    groupable: false,
			    width: 120
			}, 
			{
			    text: '제목',
			    sortable: true,
			    dataIndex: 'Subject',
			    groupable: false,
			    width: 200
			}, 
			{	
	            text: '상태',
	            sortable: true,
	            dataIndex: 'Status',
	            align: 'center',
	            groupable: false,
	            width: 80
	        }, 
	        {
	            text: '상신일',
	            sortable: true,
	            dataIndex: 'DraftDate',
	            xtype: 'datecolumn',
	            format: 'Y-m-d',
	            align: 'center',
	            groupable: false
	        },
	        {
	        	text: '상신자',
	            sortable: true,
	            dataIndex: 'DraftUserName',
	            align: 'center',
	            groupable: false,
	            width: 80
	        }
		];
    	
    	var gridPaging = Ext.create('Ext.toolbar.Paging', {
    		store: me.getStore(),
	        dock: 'bottom',
	        displayInfo: true
    	});
		
    	me.getRegItems()['GridPaging'] = gridPaging;
		me.dockedItems= [gridPaging];
    	
       	me.callParent();
    },
    listeners : {
    	itemdblclick: function(obj, record, item, index, e) {
    		var me = this;
    		var myDocBasisGrid = me.getRegItems()['ParentContainer'].getRegItems()['MyDocBasisGrid'];
    		
    		myDocBasisGrid.addData(record);
        }
    },
    previewData: function(record){
    	var me = this;
    	openDocPreviewWin(record.data.DocumentID);
    },
    queryData: function(){
    	var me = this;
    	var store = me.getStore();
    	
      	var searchForm = me.getRegItems()['ParentContainer'].getRegItems()['DocBasisPopupToolbar'].items.get('nbox.docBasisSearchForm');
    	
    	store.proxy.setExtraParam('searchText', searchForm.items.getAt(0).getValue());
		store.load();
	},
	deleteData: function(rowIndex){
		
	},
    clearData: function(){
    	var me = this;
		var store = me.getStore();
		
		store.removeAll(); 
	}
});

// My DocBasis Grid
Ext.define('nbox.myDocBasisGrid',  {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	padding: '3px 3px 0px 3px',
	hideHeaders: false,
	border: false,
	
	flex: 1,
	height: '100%',
	
	title: '근거문서',
	
    initComponent: function () {
    	var me = this;
    	
    	me.columns= [
			{
			    text: '문서번호',
			    sortable: true,
			    dataIndex: 'RefDocumentNo',
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
    	
    	var gridPaging = Ext.create('Ext.toolbar.Paging', {
    		store: me.getStore(),
	        dock: 'bottom',
	        displayInfo: true
    	});
		
    	me.getRegItems()['GridPaging'] = gridPaging;
		me.dockedItems= [gridPaging];
    	
       	me.callParent();
    },
    queryData: function(){
    	var me = this;
    	
    	var docBasisStore = docBasisPopupWin.getRegItems()['DocBasisView'].getStore();
		tempDocBasisStore.copyData(docBasisStore);
		
    },
    addData: function(record){
		var me = this;
		var store = me.getStore();
		
		if(store.findRecord('RefDocumentID', record.data.DocumentID) !== null )
			return ;
		
		var newRecord = {
			DocumentID: null,
			RefDocumentID: record.data.DocumentID,
			RefDocumentNo: record.data.DocumentNo
			
	    }; 
		
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
		var store = me.getStore();
		
		store.removeAll();
	}
});
	
//DocBasisPopup toolbar
Ext.define('nbox.docBasisPopupToolbar',    {
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
		  	id:'nbox.docBasisSearchForm',
		  	items: [
		  	{ 
			  	xtype: 'textfield', 
			  	name: 'searchText' 
		  	}]	
        };
    	
    	var btnQuery =  {	
			xtype: 'button',
			text: '조회',
			tooltip: '조회',
		    itemId: 'query',
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
        	    	
		me.items = [formSearch, btnQuery, btnConfirm, btnCancel];
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

//DocLinePopup Window
Ext.define('nbox.docBasisPopupWindow',{
	extend: 'Ext.window.Window',
	config: {
		regItems: {}    	
	},
	layout: {
        type: 'hbox'
    },
	title: '근거문서',
	
	x:20,
    y:20,
    
    width: docBasisPopupWidth,
    height: docBasisPopupHeight,
    
    modal: true,
    resizable: false,
    closable: false,
    initComponent: function () {
		var me = this;
       
        var docBasisPopupToolbar = Ext.create('nbox.docBasisPopupToolbar', {});
        
        popupDocBasisStore = Ext.create('nbox.popupDocBasisStore', {
        	
        });
        
        tempDocBasisStore = Ext.create('nbox.tempDocBasisStore', {
        	
        });
        
        var docBasisGrid = Ext.create('nbox.docBasisGrid', {
        	store: popupDocBasisStore
        });
        
        var myDocBasisGrid = Ext.create('nbox.myDocBasisGrid', {
        	store: tempDocBasisStore
        });
        
		me.getRegItems()['DocBasisPopupToolbar'] = docBasisPopupToolbar;
		docBasisPopupToolbar.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['DocBasisGrid'] = docBasisGrid;
		docBasisGrid.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['MyDocBasisGrid'] = myDocBasisGrid;
		myDocBasisGrid.getRegItems()['ParentContainer'] = me; 
		
		me.dockedItems = [docBasisPopupToolbar];
		me.items = [docBasisGrid, myDocBasisGrid];
		
		me.callParent(); 
    },
    listeners: {
    	render: function(obj, eOptns){
    		var me = this;
			console.log(me.id + ' beforeshow -> docLinePopupWindow');
			
    		me.formShow();
    	},
    	beforeshow: function(obj, eOpts){
    		var me = this;
			console.log(me.id + ' beforeshow -> docLinePopupWindow');
			
    		//me.formShow();
    	},
	    beforehide: function(obj, eOpts){
	    	var me = this;
    		console.log(me.id + ' beforehide -> docLinePopupWindow')
    	},
    	beforeclose: function(obj, eOpts){
    		var me = this;
    		console.log(me.id + ' beforeclose -> docLinePopupWindow');
    		
    		var docBasisView = me.getRegItems()['DocBasisView'];
    		tempDocBasisStore.clearData();
    		docBasisView.refresh();
    		
    		docBasisPopupWin = null;
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
    	var docBasisGrid = me.getRegItems()['DocBasisGrid'];
    	var myDocBasisGrid = me.getRegItems()['MyDocBasisGrid'];
    	
    	docBasisGrid.queryData();
    	myDocBasisGrid.queryData();
    },
    confirmData: function(){
		var me = this;
		
		var docBasisStore = docBasisPopupWin.getRegItems()['DocBasisView'].getStore();
		docBasisStore.removeAll();
		docBasisStore.copyData(tempDocBasisStore);
		
		me.close();
    },
    closeData: function(){
		var me = this;
		
	    me.close();
    },
    formShow: function(){
    	var me = this;
    	me.queryData();
	}
});	



/**************************************************
 * User Define Function
 **************************************************/
//DocLinePopup Window Open
function openDocBasisPopupWin(docBasisView) {
	// detailWin
	if(!docBasisPopupWin){
		docBasisPopupWin = Ext.create('nbox.docBasisPopupWindow', { 
		}); 
	} 
	
	docBasisPopupWin.getRegItems()['DocBasisView'] = docBasisView;
    docBasisPopupWin.show();
}