/**************************************************
 * Common variable
 **************************************************/
var workDetailWin ;
var workDetailWinWidth = 500;
var workDetailWinHeight = 270;

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
Ext.define('nbox.workDetailToolbar',    {
    extend:'Ext.toolbar.Toolbar',
    
    config: {
		regItems: {}
	},
	
	dock : 'top',
	
	initComponent: function () {
    	var me = this;	
    	
    	var btnEdit = {
			xtype: 'button',
			text: '<img src="' + NBOX_IMAGE_PATH + 'popupButton/edit16a.png" width=15 height=15/>&nbsp;<label>수정</label>',
			tooltip : '수정',
			itemId : 'edit',
			handler: function() { 
				me.getRegItems()['ParentContainer'].EditButtonDown();
			}
        };
        
        var btnSave = {
			xtype: 'button',
			text: '<img src="' + NBOX_IMAGE_PATH + 'popupButton/save16a.png" width=15 height=15/>&nbsp;<label>저장</label>',
			tooltip : '저장',
			itemId : 'save',
			handler: function() {
				me.getRegItems()['ParentContainer'].SaveButtonDown();		
			}
        };
        
        var btnDelete = {
			xtype: 'button',
			text: '<img src="' + NBOX_IMAGE_PATH + 'popupButton/delete16a.png" width=15 height=15/>&nbsp;<label>삭제</label>',
			tooltip : '삭제',
			itemId : 'delete',
			handler: function() {
				me.getRegItems()['ParentContainer'].DeleteButtonDown();					
			}
        };	       
        
        var btnCancel = {
			xtype: 'button',
			text: '<img src="' + NBOX_IMAGE_PATH + 'popupButton/undo16a.png" width=15 height=15/>&nbsp;<label>취소</label>',
			tooltip : '취소',
			itemId : 'cancel',
			handler: function() { 
				me.getRegItems()['ParentContainer'].CancelButtonDown();
			}
        };
        
    	var btnClose = {
			xtype: 'button',
			text: '<img src="' + NBOX_IMAGE_PATH + 'popupButton/close16a.png" width=15 height=15/>&nbsp;<label>닫기</label>',
			tooltip : '닫기',
			itemId : 'close',
			handler: function() { 
				me.getRegItems()['ParentContainer'].CloseButtonDown();
			}				
        };

    	me.items = [btnEdit, btnSave, btnDelete, btnCancel, btnClose ];
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
Ext.define('nbox.workDetailWindow',{
	extend: 'Ext.window.Window',
	
	config: {
    	regItems: {}   	
    },
    
    layout: {
        type: 'fit'
    },
    
    width: workDetailWinWidth,
    height: workDetailWinHeight,
    
    maximizable: true,
    resizable: true,
    closable: true,
    modal: true,
    
    initComponent: function () {
    	var me = this;
    	
    	var detailToolbar = Ext.create('nbox.workDetailToolbar', {});
    	var workViewStore = Ext.create('nbox.workViewStore',{});
    	var workEditStore = Ext.create('nbox.workEditStore',{});
    	
    	var workViewPanel = Ext.create('nbox.workViewPanel', {
    		store: workViewStore
    	});
    	
    	var workEditPanel = Ext.create('nbox.workEditPanel', {
    		store: workEditStore
    	});
		
    	detailToolbar.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['DetailToolbar'] = detailToolbar;
    	
    	workViewPanel.getRegItems()['ParentContainer'] = me;
    	workViewPanel.getRegItems()['Store'] = workViewStore;
		me.getRegItems()['WorkViewPanel'] = workViewPanel;
		
		workEditPanel.getRegItems()['ParentContainer'] = me;
		workEditPanel.getRegItems()['Store'] = workEditStore;
		me.getRegItems()['WorkEditPanel'] = workEditPanel;
		
    	me.dockedItems = [detailToolbar];
    	me.items = [workViewPanel, workEditPanel];
    	
    	me.callParent(); 
    },
    listeners: {
    	beforeshow: function(win, eOpts){
    		var me = this;
			console.log(me.id + ' beforeshow -> workDetailWin');
			win.formShow();
    	},
	    beforehide: function(win, eOpts){
	    	var me = this;
	    	
    		console.log(me.id + ' beforehide -> workDetailWin')
    	},
    	beforeclose: function(win, eOpts){
    		var me = this;
    		console.log(me.id + ' beforeclose -> workDetailWin')
    		workDetailWin = null;
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
    CloseButtonDown: function(){
    	var me = this;
		
	    me.closeData();
	},
	queryData: function(){
    	var me = this;
    	
    	var workView = me.getRegItems()['WorkViewPanel'];
    	workView.queryData();
    },
	editData: function(){
		var me = this;
		
		me.getRegItems()['ActionType'] = NBOX_C_UPDATE;
		me.formShow();
	},
	saveData: function(){
		var me = this;
    	var workEdit = me.getRegItems()['WorkEditPanel'];
    	
    	workEdit.saveData();
	},
	deleteData: function(){
    	var me = this;
    	
    	var workView = me.getRegItems()['WorkViewPanel'];
    	workView.deleteData();
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
    closeData: function(){
    	var me = this;
    	me.close();
    },
    formShow: function(){
		var me = this;
		
		var detailToolbar = me.getRegItems()['DetailToolbar'];
		var workView  = me.getRegItems()['WorkViewPanel'];
		var workEdit  = me.getRegItems()['WorkEditPanel'];
		
		switch(me.getRegItems()['ActionType'])
		{
			case NBOX_C_CREATE:
    			detailToolbar.setToolBars(['save',  'close'], true);
				detailToolbar.setToolBars(['delete', 'cancel','edit' ], false);
				
				workEdit.clearData();
				
				workView.hide();
				workEdit.show();
	    		break;
	    		
			case NBOX_C_READ:
				detailToolbar.setToolBars(['edit', 'delete', 'close'], true);
				detailToolbar.setToolBars(['save', 'cancel'], false);

				workView.queryData();
				
				workView.show();
				workEdit.hide();
				break;
			case NBOX_C_UPDATE:
				detailToolbar.setToolBars(['save', 'delete', 'cancel', 'close'], true);
				detailToolbar.setToolBars(['edit'], false);
				
				workEdit.queryData();
				
				workEdit.show();
				workView.hide();

				break;
			case NBOX_C_DELETE:
				
				workView.hide();
				workEdit.hide();
				
				break;
			default:

				workView.clearData();
			
				workView.show();
				workEdit.hide();
				
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
function openWorkDetailWin(parentContainer, actionType, record) {
	
	// workDetailWin
	if(!workDetailWin){
		workDetailWin = Ext.create('nbox.workDetailWindow', { 
		}); 
	} 
	
	workDetailWin.getRegItems()['ParentContainer'] = parentContainer;
	workDetailWin.getRegItems()['ActionType'] = actionType;
	workDetailWin.getRegItems()['Record']   = record;
	
	workDetailWin.show();
}	
