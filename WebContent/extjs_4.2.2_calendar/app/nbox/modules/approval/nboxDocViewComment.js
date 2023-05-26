/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.docDetailViewCommentModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'DocumentID'}, 
    	{name: 'Seq', type: 'int'},
    	{name: 'Comment'}, 
    	{name: 'UserDeptName'}, 
    	{name: 'UserDeptPosName'},
    	{name: 'UserName'}, 
    	{name: 'MyCommentFlag'},
    	{name: 'InsertDate', type: 'date', dateFormat:'Y-m-d H:i:s'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.docDetailViewCommentStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docDetailViewCommentModel',
	autoLoad: false,
	pageSize: NBOX_C_COMMENT_LIMIT,
	proxy: {
	    type: 'direct',
	    api: {
	    	read: 'nboxDocCommentService.selects' ,
	    	destroy: 'nboxDocCommentService.delete' 
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
Ext.define('nbox.docDetailViewComment',  {
	extend: 'Ext.grid.Panel',
	config: {
		regItems: {}
	},
	padding: '3px 3px 0px 3px',
	hideHeaders: true,
	border: false,
    initComponent: function () {
    	var me = this;
    	
    	var commentTpl = new Ext.XTemplate(
			'<div style="padding: 3px 3px 0px, 3px">',
		        '<tpl for=".">', 
		            '<div>',
			            '<span class="nbox-feed-sel-item"><label>{UserName}</label>&nbsp;</span>',
			            '<span><label>{UserDeptPosName}</label>&nbsp;</span>',
			            '<span><label>{[fm.date(values.InsertDate, "Y-m-d H:i:s")]}</label>&nbsp;</span>',
		            '</div>',
		        	'<div style="padding: 0px 0px 0px, 10px">',
		        		'<span><label>{Comment}</label></span>',
		        	'</div>',
		        '</tpl>',
	        '</div>'
		);
		
    	var commentTplColumns = Ext.create('Ext.grid.column.Template', {
    		tpl: commentTpl,
        	flex: 1
    	});
    	
    	var commentActionColumns = Ext.create('Ext.grid.column.Action', {
    		width: 50,
			items: [
				{
					icon: NBOX_IMAGE_PATH + "edit.gif" ,
					tooltip: '수정',
					width: 25,
					handler:function(grid, rowIndex, colIndex) {
						var record = grid.store.getAt(rowIndex);
						if (record.data.MyCommentFlag == 'Y'){
							var documentID = record.data.DocumentID;
							var seq = record.data.Seq;
							me.openCommentWin(NBOX_C_UPDATE, documentID, seq);
						}
					}
				},
				{
					icon: NBOX_IMAGE_PATH + "delete.png" ,
					tooltip: '삭제',
					width: 25,
					handler: function(grid, rowIndex, colIndex) {
						var record = grid.store.getAt(rowIndex);
						if (record.data.MyCommentFlag == 'Y'){
							Ext.Msg.confirm('확인', '삭제 하시겠습니까?', 
						    function(btn) {
						        if (btn === 'yes') {
						        	me.deleteData(rowIndex);
						            return true;
						        } else {
						            return false;
						        }
							});
						};
					}
				}
			]
    	});
    	
    	var commentPaging = Ext.create('Ext.toolbar.Paging', {
    		store: me.getStore(),
	        dock: 'bottom',
	        pageSize: NBOX_C_COMMENT_LIMIT,
	        displayInfo: true
    	});
    	
    	me.getRegItems()['CommentPaging'] = commentPaging;
	    me.columns = [commentTplColumns, commentActionColumns];
        me.dockedItems = [commentPaging];
        
       	me.callParent();
    },
    queryData: function(){
		var me = this;
		var store = me.getStore();
		var win = me.getRegItems()['ParentContainer'].getRegItems()['ParentContainer'];
		var documentID = win.getRegItems()['DocumentID'];
		
		me.clearData();
		
		store.proxy.setExtraParam('DocumentID', documentID);
		
		store.initPage(1, NBOX_C_COMMENT_LIMIT);
		store.load({
			callback: function(records, operation, success) {
   				if (success){
   					me.loadPanel();
   				}
   			}
		});
	},
	deleteData: function(rowIndex){
		var me = this;
		var last;
		var store = me.getStore();
		var record = store.getAt(rowIndex);
		var selModel = me.getSelectionModel();
		
		last = selModel.getSelection()[0];

		store.remove(record);
		store.sync({success: function(batch, options){
			//me.selectPrevious(last.index, false, false);
			}
		});
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
    	
    	if(store.getCount() > 0){
    		me.show();
    		
			var commentPaging = me.getRegItems()['CommentPaging'];
			if (commentPaging != null) {
				if (store.totalCount > NBOX_C_COMMENT_LIMIT){
	  				if (!commentPaging.isVisible()){
	  					commentPaging.show();
	  				}
				} else {
					if (commentPaging.isVisible()){
						commentPaging.hide();
					}
				}
	    	}
			
		}else
			me.hide();
    },
	clearPanel: function(){
		
	},
	openCommentWin: function(actionType, documentID, seq){
		var me = this;
		
		openDocCommentWin(me, actionType, documentID, seq);
	}
}); 

/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	