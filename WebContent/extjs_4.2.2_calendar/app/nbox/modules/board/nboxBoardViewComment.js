/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	

/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.boardViewCommentModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'NOTICEID'}, 
    	{name: 'SEQ', type: 'int'},
    	{name: 'COMMENT'}, 
    	{name: 'USERDEPTNAME'}, 
    	{name: 'USERDEPTPOSNAME'},
    	{name: 'USERNAME'},
    	{name: 'INSERTUSERID'},
    	{name: 'INSERTDATE', type: 'date', dateFormat:'Y-m-d H:i:s'}
    ]
});	 

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.boardViewCommentsStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.boardViewCommentModel',
	autoLoad: false,
	pageSize: NBOX_C_COMMENT_LIMIT,
	proxy: {
        type: 'direct',
        api: {
        	read: 'nboxBoardService.selectComments',
        	destroy: 'nboxBoardService.deleteComment'
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
//Comment Grid
Ext.define('nbox.boardViewCommentGrid',  {
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
			            '<span class="nbox-feed-sel-item"><label>{USERNAME}</label>&nbsp;</span>',
			            '<span><label>{USERDEPTPOSNAME}</label>&nbsp;</span>',
			            '<span><label>{[fm.date(values.INSERTDATE, "Y-m-d H:i:s")]}</label>&nbsp;</span>',
		            '</div>',
		        	'<div style="padding: 0px 0px 0px, 10px">',
		        		'<span><label>{COMMENT}</label></span>',
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
						
						if(record.data.INSERTUSERID == UserInfo.userID){
							var noticeID = record.data.NOTICEID;
							var seq = record.data.SEQ;
							me.openCommentWin(NBOX_C_UPDATE, noticeID, seq);
						}else
							Ext.Msg.alert('확인', '본인의 글만 수정할 수 있습니다.');
					}
				},
				{
					icon: NBOX_IMAGE_PATH + "delete.png" ,
					tooltip: '삭제',
					width: 25,
					handler: function(grid, rowIndex, colIndex) {
						var record = grid.store.getAt(rowIndex);
						
						if(record.data.INSERTUSERID == UserInfo.userID){
							Ext.Msg.confirm('확인', '삭제 하시겠습니까?', 
						    function(btn) {
						        if (btn === 'yes') {
						        	me.deleteData(rowIndex);
						            return true;
						        } else {
						            return false;
						        }
							});
						}else
							Ext.Msg.alert('확인', '본인의 글만 삭제할 수 있습니다.');
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
		var noticeID = win.getRegItems()['NoticeID'];
		
		me.clearData();
		
		store.proxy.setExtraParam('NOTICEID', noticeID);
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
    openCommentWin: function(actionType, noticeID, seq){
		var me = this;
		openBoardCommentWin(me, actionType, noticeID, seq);
	}
});


/**************************************************
 * Create
 **************************************************/


/**************************************************
 * User Define Function
 **************************************************/	