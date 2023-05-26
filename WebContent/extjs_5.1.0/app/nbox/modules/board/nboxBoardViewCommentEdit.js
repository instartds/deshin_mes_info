/**************************************************
 * Common variable
 **************************************************/
var boardCommentWin ;
var boardCommentWidth = 300;
var boardCommentHeight = 200;
	
/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
Ext.define('nbox.boardViewCommentEditModel', {
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
Ext.define('nbox.boardViewCommentEditStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.boardViewCommentEditModel',
	config: {
		regItems: {}
	},
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: {
        	read: 'nboxBoardService.selectComment'
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
//Comment Edit
Ext.define('nbox.boardViewCommentEdit',  {
	extend: 'Ext.form.Panel',
	
	config: {
		regItems: {}
	},
	
	layout: 'fit',
	
	padding: '0px 0px 0px 0px',
	
	border: false,
	
    api: { submit: 'nboxBoardService.saveComment' },
	items: [
		{ xtype: 'textareafield',
		  name: 'COMMENT',
		  autoScroll: true,
		  allowBlank: false 
        }
	],
	queryData: function(){
		var me = this;
		var store = me.getRegItems()['Store'];
		var win = me.getRegItems()['ParentContainer'];
		
		var noticeID = win.getRegItems()['NoticeID'];
		var seq = win.getRegItems()['Seq'];
		
		me.clearData();
		
		switch (win.getRegItems()['ActionType']){
    		case NBOX_C_CREATE:
	    	case NBOX_C_READ:
	    		break;
	    		
    		case NBOX_C_UPDATE:
				store.proxy.setExtraParam('NOTICEID', noticeID);
				store.proxy.setExtraParam('SEQ', seq);
        		
       			store.load({
	       			callback: function(records, operation, success) {
	       				if (success){
	       					me.loadData();
	       				}
	       			}
       			});
	    		break;
	    	
			case NBOX_C_DELETE:
				break;
				
			default:
				break;
		}
    },
	saveData: function(){
		var me = this;
		var win = me.getRegItems()['ParentContainer'];
		
		var noticeID = win.getRegItems()['NoticeID'];
		var seq = win.getRegItems()['Seq'];
    	
		var param = {'NOTICEID': noticeID, 'SEQ': seq};
		
		if (me.isValid()) {
			me.submit({
            	params: param,
                success: function(obj, action) {
                	win.close();
                }
            });
        }
        else {
        	Ext.Msg.alert('확인', me.validationCheck());
        }
	},
    clearData: function(){
		var me = this;
		var store = me.getRegItems()['Store'];
		
    	me.clearPanel();
    	
    	store.removeAll();
    },
	loadData: function(){
		var me = this;
    	var store = me.getRegItems()['Store'];
    	var frm = me.getForm();
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
    	}
	},
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
    	
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
    }
});

//comment toolbar
Ext.define('nbox.boardViewCommentEditToolbar',    {
    extend:'Ext.toolbar.Toolbar',
	dock : 'top',
	
	config: {
		regItems: {}
	},
	
	initComponent: function () {
    	var me = this;
    	
        var btnSave = {
			xtype: 'button',
			text: '저장',
			tooltip : '저장',
			itemId : 'save',
			handler: function() {
				me.getRegItems()['ParentContainer'].SaveButtonDown();		
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
        	    	
		me.items = [btnSave, btnCancel];
		
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

//Comment Window
Ext.define('nbox.boardViewCommentEditWindow',{
	extend: 'Ext.window.Window',
	
	config: {
		regItems: {}    	
	},
	
	layout: {
        type: 'fit'
    },
	
    title: '댓글',
	
	x:20,
    y:20,
    
    width: boardCommentWidth,
    height: boardCommentHeight,
    
    modal: true,
    resizable: false,
    closable: false,
    
    initComponent: function () {
		var me = this;
       
        var boardViewCommentEditToolbar = Ext.create('nbox.boardViewCommentEditToolbar', {});
		var boardViewCommentEdit = Ext.create('nbox.boardViewCommentEdit',{});
		var boardViewCommentEditStore = Ext.create('nbox.boardViewCommentEditStore',{});
        
		me.getRegItems()['BoardViewCommentEditToolbar'] = boardViewCommentEditToolbar;
		boardViewCommentEditToolbar.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['BoardViewCommentEdit'] = boardViewCommentEdit;
		boardViewCommentEdit.getRegItems()['ParentContainer'] = me;
		boardViewCommentEdit.getRegItems()['Store'] = boardViewCommentEditStore;
		
		me.dockedItems = [boardViewCommentEditToolbar];
		me.items = [boardViewCommentEdit];
		
		me.callParent(); 
    },
    listeners: {
    	beforeshow: function(obj, eOpts){
    		var me = this;
    		
			console.log(me.id + ' beforeshow -> boardViewCommentToolbar');
    		me.formShow();
    	},
	    beforehide: function(obj, eOpts){
	    	var me = this;
	    	
    		console.log(me.id + ' beforehide -> boardViewCommentToolbar')
    	},
    	beforeclose: function(obj, eOpts){
    		var me = this;
    		console.log(me.id + ' beforeclose -> boardViewCommentToolbar')
    		
    		var commentGrid = me.getRegItems()['CommentGrid'];
    		commentGrid.queryData();
    		boardCommentWin = null;
    	}
    },
    SaveButtonDown: function(){
		var me = this;
		
    	me.saveData();	
    },
    CancelButtonDown: function(){
		var me = this;
		
	    me.closeData();
    },
    saveData: function(){
		var me = this;
    	var boardViewCommentEdit = me.getRegItems()['BoardViewCommentEdit'];
    	
    	boardViewCommentEdit.saveData();	
    },
    closeData: function(){
		var me = this;
	    me.close();
    },
    formShow: function(){
		var me = this;
		var boardViewCommentEdit = me.getRegItems()['BoardViewCommentEdit'];
		
		boardViewCommentEdit.clearData();
		
		switch(me.getRegItems()['ActionType'])
		{
			case NBOX_C_CREATE:
	    		break;
	    		
			case NBOX_C_READ:
				break;
				
			case NBOX_C_UPDATE:
				boardViewCommentEdit.queryData();
				break;

			case NBOX_C_DELETE:
				break;
				
			default:
				break;
		}
	}
});	 

/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	
//Comment Window Open
function openBoardCommentWin(grid, actionType, noticeId, seq){
	
	if(!boardCommentWin){
		boardCommentWin = Ext.create('nbox.boardViewCommentEditWindow', {
		}); 
	}
	
	boardCommentWin.getRegItems()['CommentGrid'] = grid;
	boardCommentWin.getRegItems()['ActionType'] = actionType;
	
	boardCommentWin.getRegItems()['NoticeID'] = noticeId;
	boardCommentWin.getRegItems()['Seq'] = seq;
	
	
		
	boardCommentWin.show();
}