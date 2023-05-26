/**************************************************
 * Common variable
 **************************************************/
var docDetailWin ;
var docDetailWinWidth = 850;
var docDetailWinHeight = 700;

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
//Detail toolbar
Ext.define('nbox.docDetailToolbar',    {
    extend:'Ext.toolbar.Toolbar',
	dock : 'top',
	config: {
		regItems: {}
	},
	
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
        
        var btnDraft = {
			xtype: 'button',
			text: '상신',
			tooltip : '상신',
			itemId : 'draft',
			handler: function() {
				me.getRegItems()['ParentContainer'].DraftButtonDown();		
			}
        };
        
        var btnDraftCancel = {
			xtype: 'button',
			text: '상신취소',
			tooltip : '상신취소',
			itemId : 'draftcancel',
			handler: function() {
				me.getRegItems()['ParentContainer'].DraftCancelButtonDown();		
			}
        };
        
        var btnConfirm = {
			xtype: 'button',
			text: '결재승인',
			tooltip : '결재승인',
			itemId : 'confirm',
			handler: function() {
				me.getRegItems()['ParentContainer'].ConfirmButtonDown();		
			}
        };
	        
        var btnConfirmCancel = {
			xtype: 'button',
			text: '승인취소',
			tooltip : '승인취소',
			itemId : 'confirmcancel',
			handler: function() {
				me.getRegItems()['ParentContainer'].ConfirmCancelButtonDown();		
			}
        };
        
        var btnReturn = {
			xtype: 'button',
			text: '반려',
			tooltip : '반려',
			itemId : 'return',
			handler: function() {
				me.getRegItems()['ParentContainer'].ReturnButtonDown();		
			}
        };
	        
        var btnReturnCancel = {
			xtype: 'button',
			text: '반려취소',
			tooltip : '반려취소',
			itemId : 'returncancel',
			handler: function() {
				me.getRegItems()['ParentContainer'].ReturnCancelButtonDown();		
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
        
        var btnPreview = {
			xtype: 'button',
			text: '미리보기',
			tooltip : '미리보기',
			itemId : 'preview',
			handler: function() { 
				me.getRegItems()['ParentContainer'].PreviewButtonDown();
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
    	
    	var btnDoubleLine = {
			xtype: 'button',
			text: '이중결재선',
			tooltip : '이중결재선',
			itemId : 'doubleline',
			handler: function() { 
				me.getRegItems()['ParentContainer'].DoubleLineButtonDown();
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
    	
		me.items = [btnEdit, btnSave, btnDelete, btnCancel, btnPreview, btnComment, btnClose, '-', btnDoubleLine, '->', btnDraft, btnDraftCancel, btnConfirm, btnConfirmCancel, btnReturn, btnReturnCancel, '-', btnPrev, btnNext];
		
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
Ext.define('nbox.docDetailWindow',{
	extend: 'Ext.window.Window',
	
	config: {
    	regItems: {}   	
    },
    
    layout: {
        type: 'fit'
    },
    
    width: docDetailWinWidth,
    height: docDetailWinHeight,
    maximizable: true,
    /* maximized: true, */
    buttonAlign: 'right',
   	modal: true,
   	resizable: true,
    closable: true,
    
    
    initComponent: function () {
    	var me = this;
		
    	var detailToolbar = Ext.create('nbox.docDetailToolbar', {});
    	
    	var detailViewStore = Ext.create('nbox.docDetailViewStore', {});
    	var docEditStore = Ext.create('nbox.docEditStore', {});
    	
    	var detailView = Ext.create('nbox.docDetailView', {
    		strore: detailViewStore
    	});
		var docEditPanel = Ext.create('nbox.docEditPanel', {
			store: docEditStore
		});
		
		detailToolbar.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['DetailToolbar'] = detailToolbar;
    	
    	detailView.getRegItems()['ParentContainer'] = me;
    	detailView.getRegItems()['Store'] = detailViewStore;
    	me.getRegItems()['DetailView'] = detailView;
    	
    	docEditPanel.getRegItems()['ParentContainer'] = me;
    	docEditPanel.getRegItems()['Store'] = docEditStore;
    	me.getRegItems()['DocEditPanel'] = docEditPanel;
    	
    	me.dockedItems = [detailToolbar];
    	me.items = [detailView, docEditPanel];
		
    	me.callParent(); 
    },
    listeners: {
    	beforeshow: function(win, eOpts){
    		var me = this;
    		
			console.log(me.id + ' beforeshow -> docDetailWindow');
			win.formShow();
    	},
	    beforehide: function(win, eOpts){
	    	var me = this;
	    	
    		console.log(me.id + ' beforehide -> docDetailWindow')
    	},
    	beforeclose: function(win, eOpts){
    		var me = this;
    		var masterGrid = me.getRegItems()['MasterGrid'];
    		
    		console.log(me.id + ' beforeclose -> docDetailWindow')
    		masterGrid.queryData();
    		docDetailWin = null;
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
    DraftButtonDown: function(){
    	var me = this;
    	
    	me.draftData();
    },
    DraftCancelButtonDown: function(){
    	var me = this;
    	
    	me.draftcancelData();
    },
    ConfirmButtonDown: function(){
    	var me = this;
    	
    	me.confirmData();
    },
    ConfirmCancelButtonDown: function(){
    	var me = this;
    	
    	me.confirmcancelData();
    },
    ReturnButtonDown: function(){
    	var me = this;
    	
    	me.returnData();
    },
    ReturnCancelButtonDown: function(){
    	var me = this;
    	
    	me.returncancelData();
    },
    DoubleLineButtonDown: function(){
    	var me = this;
    	
    	me.doublelineData();
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
    CancelButtonDown: function(){
    	var me = this;
    	
		me.cancelData();
    },
    PreviewButtonDown: function(){
    	var me = this;
    	
    	me.previewData();
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
	editData: function(){
		var me = this;
		
		me.getRegItems()['ActionType'] = NBOX_C_UPDATE;
		me.formShow();
	},
	saveData: function(){
		var me = this;
    	var docEditPanel = me.getRegItems()['DocEditPanel'];
    	
    	docEditPanel.saveData();
	},
	draftData: function(){
		var me = this;
		
		switch(me.getRegItems()['ActionType'])
		{
			case NBOX_C_READ:
				var currentForm = me.getRegItems()['DetailView'];
				break;
			case NBOX_C_CREATE:
			case NBOX_C_UPDATE:
				var currentForm = me.getRegItems()['DocEditPanel'];
				break
		}
		
		currentForm.draftData();
	},
	draftcancelData: function(){
		var me = this;
    	var detailView = me.getRegItems()['DetailView'];

    	detailView.draftcancelData();
	},
	confirmData: function(){
		var me = this;
    	var detailView = me.getRegItems()['DetailView'];

    	detailView.confirmData();
	},
	confirmcancelData: function(){
		var me = this;
    	var detailView = me.getRegItems()['DetailView'];

    	detailView.confirmcancelData();
	},
	returnData: function(){
		var me = this;
    	var detailView = me.getRegItems()['DetailView'];

    	detailView.returnData();
	},
	returncancelData: function(){
		var me = this;
    	var detailView = me.getRegItems()['DetailView'];

    	detailView.returncancelData();
	},
	doublelineData: function(){
		var me = this;
    	var detailView = me.getRegItems()['DetailView'];

    	detailView.doublelineData();
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
    previewData: function(){
    	var me = this;
    	var detailView = me.getRegItems()['DetailView'];
    	var documentID = docDetailWin.getRegItems()['DocumentID'];
    	
    	detailView.openPreviewWin(documentID);
    },
    commentData: function(){
    	var me = this;
    	var detailView = me.getRegItems()['DetailView'];
    	var documentID = docDetailWin.getRegItems()['DocumentID'];
    	
    	detailView.openCommentWin(NBOX_C_CREATE, documentID, null);
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
    queryData: function(){
    	var me = this;
    	var detailView = me.getRegItems()['DetailView'];
    	
    	detailView.queryData();
    },
    formShow: function(){
		var me = this;
		var detailToolbar = me.getRegItems()['DetailToolbar'];
		var detailView = me.getRegItems()['DetailView'];
		var docEditPanel = me.getRegItems()['DocEditPanel'];
		
		switch(me.getRegItems()['ActionType'])
		{
			case NBOX_C_READ:
				switch(me.getRegItems()['Box']){
	    			case 'XA001': //임시문서
	    				detailToolbar.setToolBars(['edit','draft','delete', 'preview', 'close', 'prev', 'next'], true);
	    				detailToolbar.setToolBars(['draftcancel', 'confirm', 'confirmcancel', 'return', 'returncancel', 'comment'], false);
		    			break;
	    			case 'XA002': //기안문서
	    				detailToolbar.setToolBars(['draftcancel', 'close', 'prev', 'next'], true);
						detailToolbar.setToolBars(['edit', 'draft', 'confirm', 'confirmcancel', 'return', 'returncancel', 'delete', 'comment', 'save', 'cancel'], false);
		    			break;
	    			case 'XA003': case 'XA004': case 'XA011':  //미결문서,기결문서
	    				detailToolbar.setToolBars(['comment', 'close', 'prev', 'next'], true);
						detailToolbar.setToolBars(['edit', 'draft', 'draftcancel','confirm', 'confirmcancel', 'return', 'returncancel', 'delete'], false);
		    			break;
	    			case 'XA005':  case 'XA006': case 'XA007':	case 'XA008': case 'XA009': case 'XA010': //예결문서, 참조, 수신, 발신, 회사결재문서함, 개인결재문서함
	    				detailToolbar.setToolBars(['comment', 'close', 'prev', 'next'], true);
						detailToolbar.setToolBars(['edit', 'draft', 'draftcancel','confirm', 'confirmcancel', 'return', 'returncancel', 'delete'], false);
		    			break;
		    		default:
		    			break;
	    		}    				
				
				detailToolbar.setToolBars(['save', 'cancel', 'doubleline'], false);
				
				detailView.clearData();
				
				detailView.show();
				docEditPanel.hide();
				
				detailView.queryData();
				break;
				
			case NBOX_C_UPDATE:
				detailToolbar.setToolBars(['save', 'draft', 'cancel', 'close'], true);
				detailToolbar.setToolBars(['edit', 'draftcancel', 'confirm', 'confirmcancel', 'return', 'returncancel', 'delete', 'preview', 'comment', 'prev', 'next'], false);
				
				docEditPanel.clearData();
				
				detailView.hide();
				docEditPanel.show();
				
				docEditPanel.queryData();
				break;

			case NBOX_C_DELETE:
				detailView.hide();
				docEditPanel.hide();
				break;
				
			default:
				viewForm.clearData();
			
				detailView.show();
				docEditPanel.hide();
				
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
function openDocDetailWin(grid, actionType, documentID, menuID, box) {
	// detailWin
	if(!docDetailWin){
		docDetailWin = Ext.create('nbox.docDetailWindow', { 
		}); 
	} 
	
	docDetailWin.getRegItems()['MasterGrid'] = grid;
	docDetailWin.getRegItems()['DocumentID'] = documentID;
	docDetailWin.getRegItems()['ActionType'] = actionType;
	docDetailWin.getRegItems()['MenuID'] = menuID;
	docDetailWin.getRegItems()['Box'] = box;
	
	docDetailWin.show();
}	