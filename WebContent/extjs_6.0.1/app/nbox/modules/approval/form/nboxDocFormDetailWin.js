/**************************************************
 * Common variable
 **************************************************/
var detailWin ;
var detailWinWidth = 850;
var detailWinHeight = 700;
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
Ext.define('nbox.approval.form.detailToolbar',    {
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

        var btnDelete = {
			xtype: 'button',
			text: '삭제',
			tooltip : '삭제',
			itemId : 'delete',
			handler: function() {
				me.getRegItems()['ParentContainer'].DeleteButtonDown();					
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
    	
		me.items = [btnSave, btnDelete, btnClose, '->', btnPrev, btnNext];
		
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
Ext.define('nbox.approval.form.detailWin',{
	extend: 'Ext.window.Window',
	
	config: {
    	regItems: {}   	
    },
    
    layout: {
        type: 'fit'
    },
    
    width: detailWinWidth,
    height: detailWinHeight,
    maximizable: true,
    /* maximized: true, */
    buttonAlign: 'right',
   	modal: true,
   	resizable: true,
    closable: true,
    
    
    initComponent: function () {
    	var me = this;
		
    	var detailEditStore = Ext.create('nbox.approval.form.detailEditStore', {});
    	
    	var detailToolbar = Ext.create('nbox.approval.form.detailToolbar', {});
    	var detailEditPanel = Ext.create('nbox.approval.form.detailEditPanel', {});
		
    	detailToolbar.getRegItems()['ParentContainer'] = me;
    	me.getRegItems()['DetailToolbar'] = detailToolbar;
    	
    	detailEditPanel.getRegItems()['ParentContainer'] = me;
    	detailEditPanel.getRegItems()['Store'] = detailEditStore;
    	me.getRegItems()['DetailEditPanel'] = detailEditPanel;
    	
    	me.dockedItems = [detailToolbar];
    	me.items = [detailEditPanel];
		
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
    		var masterGrid = me.getRegItems()['MasterGrid'];
    		
    		console.log(me.id + ' beforeclose -> detailWindow')
    		masterGrid.queryData();
    		detailWin = null;
    	},
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
	saveData: function(){
		var me = this;
    	var detailEditPanel = me.getRegItems()['DetailEditPanel'];
    	
    	detailEditPanel.saveData();
	},
	deleteData: function(){
    	var me = this;
    	var detailEditPanel = me.getRegItems()['DetailEditPanel'];

    	detailEditPanel.deleteData();
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
		var detailEditPanel = me.getRegItems()['DetailEditPanel'];
		
		detailEditPanel.queryData();
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
function openApprovalFormDetailWin(grid, actionType, formID) {
	// detailWin
	if(!detailWin){
		detailWin = Ext.create('nbox.approval.form.detailWin', { 
		}); 
	} 
	
	detailWin.getRegItems()['MasterGrid'] = grid;
	detailWin.getRegItems()['ActionType'] = actionType;
	detailWin.getRegItems()['FormID'] = formID;
	
	detailWin.show();
}	