/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/

/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.boardDetailViewModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'NOTICEID'}, 
    	{name: 'FILEATTACHFLAG'}, 
    	{name: 'IMPORTANT'}, 
    	{name: 'SUBJECT'}, 
    	{name: 'CONTENTS'},
    	{name: 'USERNAME'}, 
    	{name: 'USERCODE'}, 	    	
    	{name: 'MYAUTH', type: 'int'}, 
    	{name: 'ALWAYSTOP', type: 'bool'},
    	{name: 'POPUPFLAG', type: 'bool'},
    	{name: 'READCOUNT', type: 'int'}, 
    	{name: 'LOADDATE', type: 'date'},
    	{name: 'ALARMENDDATE', type: 'date', dateFormat:'Y-m-d'}
    ]
});	

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.boardDetailViewStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.boardDetailViewModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { 
        	read: 'nboxBoardService.select'
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
// Board Header
Ext.define('nbox.boardHeaderViewPanel',{
	extend: 'Ext.panel.Panel',
	
	config: {
    	regItems: {}
    },
    
    layout: {
    	type: 'hbox'
    },
    
    style: {
		'border-bottom': '1px dashed #C0C0C0',
		'padding': '3px 5px 3px 5px'					
	},
    
    border: false,
    
    defaultType: 'displayfield',
    initComponent: function () {
    	var me = this;
    	
    	me.items = [
    		{ 
				name: 'SUBJECT',
				flex: 1,
				fieldStyle: 'color: #666666; font-size: 11pt; font-weight: bold; padding: 3px 3px 0px 3px;'
	    	},
			{ 
				name: 'USERNAME', 
				width: '100px',
				fieldStyle: 'text-align: center; padding: 3px 3px 0px 3px;'
			}, 
			{
				id: 'boardViewReadCount',
				name: 'READCOUNT', 
				width: '50px',
				fieldStyle:  'text-align: center; border-right: 1px solid #C0C0C0; border-left: 1px solid #C0C0C0; padding: 3px 3px 0px 3px' 
			},
			{ 
				name: 'LOADDATE', 
				renderer: Ext.util.Format.dateRenderer('Y-m-d'),
				width: '100px',
				fieldStyle: 'text-align: center; padding: 3px 3px 0px 3px;'
			}
		];       	
    	
    	me.callParent();
    }
});

//Board Contents
Ext.define('nbox.boardContentsViewPanel',{
	extend: 'Ext.panel.Panel',
	
	config: {
    	regItems: {}
    },
    
    layout: {
    	type: 'fit'
    },
    
    style: {
		'padding': '3px 5px 3px 5px'					
	},
	
    border: false,
    
    initComponent: function () {
    	var me = this;
    	
    	me.items = [
			{
				xtype: 'displayfield', 
				name: 'CONTENTS'
			}       
    	];
    	
    	me.callParent();
    }
});

// Detail Form View
Ext.define('nbox.boardDetailView', {
	extend: 'Ext.form.Panel',
	
	config: {
    	regItems: {}
    },
    
    layout: {
    	type: 'anchor'
    },
    
    border: false,
    flex: 1,
    
    autoScroll: true,
    
    api: { 
    	submit: 'nboxBoardService.delete' 
	},
    
    initComponent: function () {
    	var me = this;
    	
    	var boardHeaderViewPanel = Ext.create('nbox.boardHeaderViewPanel',{});
    	
    	var boardViewFilesStore = Ext.create('nbox.boardViewFilesStore',{});
    	var boardViewFiles = Ext.create('nbox.boardViewFiles',{
    		store: boardViewFilesStore,
    	});
    	
    	var boardContentsViewPanel = Ext.create('nbox.boardContentsViewPanel', {});
    	
    	var boardViewCommentsStore = Ext.create('nbox.boardViewCommentsStore', {});
    	var boardViewCommentGrid = Ext.create('nbox.boardViewCommentGrid',{
    		store: boardViewCommentsStore
    	});
    	
    	var boardViewReadHisStore = Ext.create('nbox.boardViewReadHisStore', {});
    	var boardViewReadHisToolTip = Ext.create('nbox.boardViewReadHisToolTip',{}); 
    	
    	boardHeaderViewPanel.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['BoardHeaderViewPanel'] = boardHeaderViewPanel;
    	
    	boardViewFiles.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['BoardViewFiles'] = boardViewFiles;
    	
    	boardContentsViewPanel.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['BoardContentsViewPanel'] = boardContentsViewPanel;
    	
    	boardViewCommentGrid.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['BoardViewCommentGrid'] = boardViewCommentGrid;
    	
    	boardViewReadHisToolTip.getRegItems()['ParentContainer'] = me;
    	boardViewReadHisToolTip.getRegItems()['Store'] = boardViewReadHisStore;
    	me.getRegItems()['BoardViewReadHisToolTip'] = boardViewReadHisToolTip;
    	
    	me.items = [
    	   boardHeaderViewPanel
    	  ,boardViewFiles
    	  ,boardContentsViewPanel
    	  ,boardViewCommentGrid
    	];
    	
    	me.callParent();
    },
    queryData: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	var win = me.getRegItems()['ParentContainer'];
    	var noticeID = win.getRegItems()['NoticeID'];
    	
    	var boardViewFiles = me.getRegItems()['BoardViewFiles'];
    	var boardViewCommentGrid = me.getRegItems()['BoardViewCommentGrid'];
    	var boardViewReadHisToolTip = me.getRegItems()['BoardViewReadHisToolTip'];
    	
    	me.clearData();
    	
    	store.proxy.setExtraParam('NOTICEID', noticeID);
    	store.load({
   			callback: function(records, operation, success) {
   				if (success){
   					me.loadPanel();
   				}
   			}
		});
    	
    	boardViewFiles.queryData();
    	boardViewCommentGrid.queryData();
    	boardViewReadHisToolTip.queryData();
    },
    deleteData: function(){
    	var me = this;
    	var win = me.getRegItems()['ParentContainer'];
    	var noticeID = win.getRegItems()['NoticeID'];
    	
		var param = {'NOTICEID': noticeID};
		
		me.submit({
           	params: param,
               success: function(obj, action) {
               		win.close();
			}
		});
    },
    clearData: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	
    	me.clearPanel();
    	
    	store.removeAll();
    },
    loadPanel: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	var frm = me.getForm();
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
			
			me._setMyAuth();
    	}
    },
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
    	
		frm.reset();
    },
    openCommentWin: function(actionType, noticeID, seq){
    	var me = this;
    	var boardViewCommentGrid = me.getRegItems()['BoardViewCommentGrid'];
    	
    	boardViewCommentGrid.openCommentWin(actionType, noticeID, seq);
    },
    _setMyAuth: function(){
    	var me = this;
    	var store = me.getRegItems()['Store'];
    	
    	if (store.getCount() > 0)
    	{
    		var record = store.getAt(0);
    		
    		var win = me.getRegItems()['ParentContainer'];
    		var detailToolbar = win.getRegItems()['DetailToolbar'];
    		
    		detailToolbar.setToolBars(['edit', 'delete'], false);
    		if(record.data.MYAUTH == 1)
    			detailToolbar.setToolBars(['edit', 'delete'], true);
    	}
    }
});

/**************************************************
 * Create
 **************************************************/


/**************************************************
 * User Define Function
 **************************************************/	