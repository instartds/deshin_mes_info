
/**************************************************
 * Common variable
 **************************************************/
 var docCommentWin ;
 var docCommentWidth = 300;
 var docCommentHeight = 200;	
	
/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/
//Comment List
Ext.define('nbox.docCommentModel', {
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
Ext.define('nbox.docCommentStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docCommentModel',
	config: {
		parentContainer: null
	},
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: {
        	read: 'nboxDocCommentService.select'
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
//Doc Comment Edit
Ext.define('nbox.docCommentPanel',  {
	extend: 'Ext.form.Panel',
	config: {
		regItems: {}
	},
	layout: 'fit',
	padding: '5px 5px 0px 5px',
	api: { submit: 'nboxDocCommentService.save' },
	items: [
		{ xtype: 'textareafield',
		  name: 'Comment',
		  autoScroll: true,
		  allowBlank: false 
        }
	],
	queryData: function(){
		var me = this;
		
		var win = me.getRegItems()['ParentContainer'];
		var store = me.getRegItems()['Store'];
		
		var documentID = win.getRegItems()['DocumentID'];
		var seq = win.getRegItems()['Seq'];
		
		me.clearData();
		
		switch (win.getRegItems()['ActionType']){
    		case NBOX_C_CREATE:
	    	case NBOX_C_READ:
	    		break;
	    		
    		case NBOX_C_UPDATE:
				store.proxy.setExtraParam('DocumentID', documentID);
				store.proxy.setExtraParam('Seq', seq);
        		
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
		
    	var documentID = win.getRegItems()['DocumentID'];
    	var seq = win.getRegItems()['Seq'];
		var param = {'DocumentID': documentID, 'Seq': seq};
		
		if (me.isValid()) {
			me.submit({
            	params: param,
                success: function(obj, action) {
                	docCommentWin.close();
                }
            });
        }
        else {
        	Ext.Msg.alert('확인', me.validationCheck());
        }
	},
    clearData: function(){
		var me = this;
		
    	me.clearPanel();
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
    	var store = me.getRegItems()['Store'];
    	
		store.removeAll();
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

//Doc Comment toolbar
Ext.define('nbox.docCommentToolbar',    {
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

//Doc Comment Window
Ext.define('nbox.docCommentWindow',{
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
    width: docCommentWidth,
    height: docCommentHeight,
    modal: true,
    resizable: false,
    closable: false,
    initComponent: function () {
		var me = this;
       
		var docCommentStore = Ext.create('nbox.docCommentStore', {});
		
        var docCommentToolbar = Ext.create('nbox.docCommentToolbar', {});
		var docCommentPanel = Ext.create('nbox.docCommentEdit',{});
        
		me.getRegItems()['DocCommentToolbar'] = docCommentToolbar;
		docCommentToolbar.getRegItems()['ParentContainer'] = me;
		
		me.getRegItems()['DocCommentPanel'] = docCommentPanel;
		docCommentPanel.getRegItems()['ParentContainer'] = me;
		docCommentPanel.getRegItems()['Store'] = docCommentStore;
		
		me.dockedItems = [docCommentToolbar];
		me.items = [docCommentEditForm];
		
		me.callParent(); 
    },
    listeners: {
    	beforeshow: function(obj, eOpts){
    		var me = this;
    		
			console.log(me.id + ' beforeshow -> docCommentWindow');
    		me.formShow();
    	},
	    beforehide: function(obj, eOpts){
	    	var me = this;
	    	
    		console.log(me.id + ' beforehide -> docCommentWindow')
    	},
    	beforeclose: function(obj, eOpts){
    		var me = this;
    		var parentGrid = me.getRegItems()['ParentGrid'];
    		
    		console.log(me.id + ' beforeclose -> docCommentWindow')
    		parentGrid.queryData();
    		docCommentWin = null;
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
    	var docCommentPanel = me.getRegItems()['DocCommentPanel'];
    	docCommentPanel.saveData();	
    },
    closeData: function(){
		var me = this;
	    me.close();
    },
    formShow: function(){
		var me = this;
		var docCommentPanel = me.getRegItems()['DocCommentPanel'];
		
		docCommentPanel.clearData();
		
		switch(me.getRegItems()['ActionType'])
		{
			case NBOX_C_CREATE:
	    		break;
	    		
			case NBOX_C_READ:
				break;
				
			case NBOX_C_UPDATE:
				docCommentEditForm.queryData();
				break;

			case NBOX_C_DELETE:
				break;
				
			default:
				break;
		}
	}
});	

/**************************************************
 * User Define Function
 **************************************************/
//Comment Window Open
function openDocCommentWin(grid, actionType, documentID, seq){
	
	if(!docCommentWin){
		docCommentWin = Ext.create('nbox.docCommentWindow', {
		}); 
	}
	
	docCommentWin.getRegItems()['ParentGrid'] = grid;
	docCommentWin.getRegItems()['DocumentID'] = documentID;
	docCommentWin.getRegItems()['Seq'] = seq;
	docCommentWin.getRegItems()['ActionType'] = actionType;
		
	docCommentWin.show();
}	
