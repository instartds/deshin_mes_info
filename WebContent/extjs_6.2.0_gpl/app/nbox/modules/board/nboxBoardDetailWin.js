/**************************************************
 * Common variable
 **************************************************/
/*Local Varival*/
var boardDetailWin ;
var boardDetailWinWidth  = 700;
var boardDetailWinHeight = 700;

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/

/**************************************************
 * Store
 **************************************************/

/**************************************************
 * Define
 **************************************************/
//Board Detail Toolbar
Ext.define('nbox.boardDetailToolbar',    {
    extend:'Ext.toolbar.Toolbar',
    
    config: {
		regItems: {}
	},
	
	dock : 'top',
	
	initComponent: function () {
    	var me = this;
    	
    	var btnEdit = {
			xtype: 'button',
			text: '수정',
			tooltip : '수정',
			itemId : 'edit',
			handler: function() { 
				me.getRegItems()['ParentContainer'].EditButtonDown();
			}
        };
        
        var btnSave = {
			xtype: 'button',
			text: '저장',
			tooltip : '저장',
			itemId : 'save',
			handler: function() {
				me.getRegItems()['ParentContainer'].SaveButtonDown();		
			}
        };
        
        var btnDelete = {
			xtype: 'button',
			text: '삭제',
			tooltip : '삭제',
			itemId : 'delete',
			handler: function() {
				me.getRegItems()['ParentContainer'].DeleteButtonDown();					
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
        
        var btnComment = {
			xtype: 'button',
			text: '댓글',
			tooltip : '댓글쓰기',
			itemId : 'comment',
			handler: function() { 
				me.getRegItems()['ParentContainer'].CommentButtonDown();
			}
        };	
        
    	var btnClose = {
			xtype: 'button',
			text: '닫기',
			tooltip : '닫기',
			itemId : 'close',
			handler: function() { 
				me.getRegItems()['ParentContainer'].CloseButtonDown();
			}				
        };
        
        var btnPrev = {
			xtype: 'button',
			text: '이전',
			tooltip : '이전페이지',
			itemId : 'prev',
			handler: function() {
				me.getRegItems()['ParentContainer'].PrevButtonDown();
			}
        };
        
        var btnNext = {
			xtype: 'button',
			text: '다음',
			tooltip : '다음페이지',
			itemId : 'next',
			handler: function() { 
				me.getRegItems()['ParentContainer'].NextButtonDown();
			}
        };	        
    	
		me.items = [btnEdit, btnSave, btnDelete, btnCancel, btnClose, '-', btnComment, '->', btnPrev, btnNext ];
		
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

//Detail Window
Ext.define('nbox.boardDetailWindow',{
	extend: 'Ext.window.Window',
	
	config: {
    	regItems: {}   	
    },
    
    layout: {
        type: 'fit'
    },
    
    width: boardDetailWinWidth,
    height: boardDetailWinHeight,
    
    maximizable: true,
    resizable: true,
    closable: true,
    modal: true,
   	
    initComponent: function () {
    	var me = this;
		
    	var detailToolbar = Ext.create('nbox.boardDetailToolbar', {});
    	var detailViewStore = Ext.create('nbox.boardDetailViewStore', {});
    	var detailEditStore = Ext.create('nbox.boardDetailEditStore', {});
    	
    	var detailView = Ext.create('nbox.boardDetailView', {
    		store: detailViewStore
    	});
    	var detailEdit = Ext.create('nbox.boardDetailEdit', {
    		store: detailEditStore
    	});
    	
    	detailToolbar.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['DetailToolbar'] = detailToolbar;
    	
    	detailView.getRegItems()['ParentContainer'] = me;
    	detailView.getRegItems()['Store'] = detailViewStore;
    	me.getRegItems()['DetailView'] = detailView;
    	
    	detailEdit.getRegItems()['ParentContainer'] = me;
    	detailEdit.getRegItems()['Store'] = detailEditStore;
    	me.getRegItems()['DetailEdit'] = detailEdit;
    	
    	me.dockedItems = [detailToolbar];
    	me.items = [detailView, detailEdit];
		
    	me.callParent(); 
    },
    listeners: {
    	beforeshow: function(win, eOpts){
    		var me = this;
			console.log(me.id + ' beforeshow -> detailWindow');
			
			win.formShow();
    	},
	    beforehide: function(win, eOpts){
	    	var me = this;
	    	
    		console.log(me.id + ' beforehide -> detailWindow')
    	},
    	beforeclose: function(win, eOpts){
    		var me = this;
    		var grid = me.getRegItems()['MasterGrid'];
    		
    		console.log(me.id + ' beforeclose -> detailWindow')
    		grid.queryData();
    		boardDetailWin = null;
    	},
    },
    EditButtonDown: function() {
		var me = this;
		
		me.editData();
    },
    SaveButtonDown: function(){
    	var me = this;
    	
    	me.saveData();
    },
    DeleteButtonDown: function(){
    	var me = this;
    	
    	Ext.Msg.confirm('확인', '삭제 하시겠습니까?', 
	    function(btn) {
	        if (btn === 'yes') {
	        	me.deleteData();
	            return true;
	        } else {
	            return false;
	        }
		});
    },
    CancelButtonDown: function(actionType){
    	var me = this;
    	
		me.cancelData();
    },
    CommentButtonDown: function(){
    	var me = this;
    	
    	me.commentData();
    },
    CloseButtonDown: function(){
    	var me = this;
		
	    me.closeData();
	},
	PrevButtonDown: function(){
		var me = this;
		
		me.prevData();
	},
	NextButtonDown: function(){
		var me = this;
		
		me.nextData();
	},
	queryData: function(){
    	var me = this;
    	var detailView = me.getRegItems()['DetailView'];
    	
    	detailView.queryData();
    },
	editData: function(){
		var me = this;
		
		me.getRegItems()['ActionType'] = NBOX_C_UPDATE;
		me.formShow();
	},
	saveData: function(){
		var me = this;
    	var detailEdit = me.getRegItems()['DetailEdit'];
    	
    	detailEdit.saveData();
	},
	deleteData: function(){
    	var me = this;
    	var detailView = me.getRegItems()['DetailView'];

    	detailView.deleteData();
    },
    cancelData: function(){
    	var me = this;

    	switch(me.getRegItems()['ActionType'])
    	{
    		case NBOX_C_UPDATE:
    			me.getRegItems()['ActionType'] = NBOX_C_READ;
			break;
	    	
    		case NBOX_C_CREATE:
	    	case NBOX_C_READ:
	    	case NBOX_C_DELETE:
				break;
			
    		default:
    			break;
    	}

		me.formShow();
    },
    commentData: function(){
    	var me = this;
    	var detailView = me.getRegItems()['DetailView'];
    	var noticeID = me.getRegItems()['NoticeID'];
    	var seq = null;
    	
    	detailView.openCommentWin(NBOX_C_CREATE, noticeID, seq);
    },
    closeData: function(){
    	var me = this;
    	me.close();
    },
    prevData: function(){
    	var me = this;
		var masterGrid = me.getRegItems()['MasterGrid'];
		
		masterGrid.selectPrevious(false, false);
    },
    nextData: function(){
    	var me = this;
    	var masterGrid = me.getRegItems()['MasterGrid'];
		
    	masterGrid.selectNext(false, false);
    },
    formShow: function(){
		var me = this;
		
		var detailToolbar = me.getRegItems()['DetailToolbar'];
		var detailView = me.getRegItems()['DetailView'];
		var detailEdit = me.getRegItems()['DetailEdit'];
		
		switch(me.getRegItems()['ActionType'])
		{
			case NBOX_C_CREATE:
    			detailToolbar.setToolBars(['save',  'cancel', 'close'], true);
				detailToolbar.setToolBars(['delete', 'edit', 'comment', 'prev', 'next'], false);
				
				detailEdit.clearData();
				
				detailView.hide();
				detailEdit.show();
	    		break;
	    		
			case NBOX_C_READ:
				detailToolbar.setToolBars(['edit', 'delete', 'comment', 'close', 'prev', 'next'], true);
				detailToolbar.setToolBars(['save', 'cancel'], false);

				detailView.clearData();
				
				detailView.show();
				detailEdit.hide();
				
				detailView.queryData();
				break;
				
			case NBOX_C_UPDATE:
				detailToolbar.setToolBars(['save', 'delete', 'cancel', 'close'], true);
				detailToolbar.setToolBars(['edit', 'comment', 'prev', 'next'], false);
				
				detailEdit.clearData();
				
				detailView.hide();
				detailEdit.show();
				
				detailEdit.queryData();
				break;

			case NBOX_C_DELETE:
				detailView.hide();
				detailEdit.hide();
				break;
				
			default:
				detailView.clearData();
			
				detailView.show();
				detailEdit.hide();
				break;
		}
	},
	onShow: function() {
        var me = this;
        var mySize = me.getSize();
        var pSize = Ext.getBody().getSize();
        
        if(mySize.height > pSize.height) {
            me.setSize({
                    width: mySize.width,
                    height : pSize.height
            });   
        }
        var posX = pSize.width - mySize .width;
        me.x = 0;(posX < 0) ? 0 : posX;
        me.y = 0;
        
        me.callParent(arguments);
    }
});

/**************************************************
 * Create
 **************************************************/


/**************************************************
 * User Define Function
 **************************************************/	
function openBoardDetailWin(grid, actionType, noticeID, menuID) {
	// detailWin
	if(!boardDetailWin){
		boardDetailWin = Ext.create('nbox.boardDetailWindow', { 
		}); 
	} 
	
	boardDetailWin.getRegItems()['MasterGrid'] = grid;
	boardDetailWin.getRegItems()['ActionType'] = actionType;
	boardDetailWin.getRegItems()['NoticeID']   = noticeID;
	boardDetailWin.getRegItems()['MenuID']   = menuID;
	
	boardDetailWin.show();
}	

