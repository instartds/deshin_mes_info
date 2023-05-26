/**************************************************
 * Common variable
 **************************************************/
var scheduleDetailWin ;
var scheduleDetailWinWidth = 550;
var scheduleDetailWinHeight = 270;

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
Ext.define('nbox.scheduleDetailToolbar',    {
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
Ext.define('nbox.scheduleDetailWindow',{
	extend: 'Ext.window.Window',
	
	config: {
    	regItems: {}   	
    },
    
    layout: {
        type: 'fit'
    },
    
    width: scheduleDetailWinWidth,
    height: scheduleDetailWinHeight,
    
    maximizable: true,
    resizable: true,
    closable: true,
    modal: true,
    
    initComponent: function () {
    	var me = this;
    	
    	var detailToolbar = Ext.create('nbox.scheduleDetailToolbar', {});
    	var scheduleViewStore = Ext.create('nbox.scheduleViewStore',{});
    	var scheduleEditStore = Ext.create('nbox.scheduleEditStore',{});
    	
    	var scheduleViewPanel = Ext.create('nbox.scheduleViewPanel', {
    		store: scheduleViewStore
    	});
    	
    	var scheduleEditPanel = Ext.create('nbox.scheduleEditPanel', {
    		store: scheduleEditStore
    	});
		
    	detailToolbar.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['DetailToolbar'] = detailToolbar;
    	
    	scheduleViewPanel.getRegItems()['ParentContainer'] = me;
    	scheduleViewPanel.getRegItems()['Store'] = scheduleViewStore;
		me.getRegItems()['ScheduleViewPanel'] = scheduleViewPanel;
		
		scheduleEditPanel.getRegItems()['ParentContainer'] = me;
		scheduleEditPanel.getRegItems()['Store'] = scheduleEditStore;
		me.getRegItems()['ScheduleEditPanel'] = scheduleEditPanel;
		
    	me.dockedItems = [detailToolbar];
    	me.items = [scheduleViewPanel, scheduleEditPanel];
    	
    	me.callParent(); 
    },
    listeners: {
    	beforeshow: function(win, eOpts){
    		var me = this;
			console.log(me.id + ' beforeshow -> scheduleDetailWin');
			win.formShow();
    	},
	    beforehide: function(win, eOpts){
	    	var me = this;
	    	
    		console.log(me.id + ' beforehide -> scheduleDetailWin')
    	},
    	beforeclose: function(win, eOpts){
    		var me = this;
    		console.log(me.id + ' beforeclose -> scheduleDetailWin')
    		
    		var parentContainer = win.getRegItems()['ParentContainer'] ;
    		parentContainer.queryData();
    		
    		scheduleDetailWin = null;
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
    	
    	var scheduleView = me.getRegItems()['ScheduleViewPanel'];
    	scheduleView.queryData();
    },
	editData: function(){
		var me = this;
		
		me.getRegItems()['ActionType'] = NBOX_C_UPDATE;
		me.formShow();
	},
	saveData: function(){
		var me = this;
    	var scheduleEdit = me.getRegItems()['ScheduleEditPanel'];
    	
    	scheduleEdit.saveData();
	},
	deleteData: function(){
    	var me = this;
    	
    	var scheduleView = me.getRegItems()['ScheduleViewPanel'];
    	scheduleView.deleteData();
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
		var scheduleView  = me.getRegItems()['ScheduleViewPanel'];
		var scheduleEdit  = me.getRegItems()['ScheduleEditPanel'];
		
		switch(me.getRegItems()['ActionType'])
		{
			case NBOX_C_CREATE:
    			detailToolbar.setToolBars(['save',  'close'], true);
				detailToolbar.setToolBars(['delete', 'cancel','edit' ], false);
				
				scheduleEdit.clearData();
				
				scheduleView.hide();
				scheduleEdit.show();
	    		break;
	    		
			case NBOX_C_READ:
				detailToolbar.setToolBars(['edit', 'delete', 'close'], true);
				detailToolbar.setToolBars(['save', 'cancel'], false);

				scheduleView.queryData();
				
				scheduleView.show();
				scheduleEdit.hide();
				break;
			case NBOX_C_UPDATE:
				detailToolbar.setToolBars(['save', 'delete', 'cancel', 'close'], true);
				detailToolbar.setToolBars(['edit'], false);
				
				scheduleEdit.queryData();
				
				scheduleEdit.show();
				scheduleView.hide();

				break;
			case NBOX_C_DELETE:
				
				scheduleView.hide();
				scheduleEdit.hide();
				
				break;
			default:

				scheduleView.clearData();
			
				scheduleView.show();
				scheduleEdit.hide();
				
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
function openScheduleDetailWin(parentContainer, actionType, scheduleId) {
	
	// scheduleDetailWin
	if(!scheduleDetailWin){
		scheduleDetailWin = Ext.create('nbox.scheduleDetailWindow', { 
		}); 
	} 
	
	scheduleDetailWin.getRegItems()['ParentContainer'] = parentContainer;
	scheduleDetailWin.getRegItems()['ActionType'] = actionType;
	scheduleDetailWin.getRegItems()['ScheduleID'] = scheduleId;
	
	scheduleDetailWin.show();
}	
