//@charset UTF-8
/**
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 */

Ext.define('Unilite.com.BasePopupApp', {
	extend: 'Unilite.com.UniAbstractApp',
    alias: 'widget.BasePopupApp',
    name:'BasePopupApp',
    requires: [
    	'Unilite.com.UniAppManager'
	],
    
    defaults: {padding:'0 0 5 0'},
    initComponent : function(){    
    	var me  = this;
    	UniAppManager.setApp( me );
    	//UniAppManager.on("datachanged", me._datachangedFun);
    	
    	var param = window.dialogArguments;
    	if(Ext.isDefined(param)) {
    		document.title =param['pageTitle'];
    	}
    	
    	this._setToolBar();
		this.comPanelToolbar.dockedItems = [this.toolbar];
		console.log("BaseApp init.");
    	var newItems = [];
    	newItems.push(this.comPanelToolbar);  
 	
    	for(i = 0, len = this.items.length; i < len; i ++ ) {
    		var element = this.items[i];
    		newItems.push(element);
    	}
    	this.items = newItems;    	
    	this.callParent();		
    	var params = Unilite.getParams();
    	this.fnInitBinding(params);
    	this.fnInitBinding();
    },
    // abstract
	beforeClose:Ext.emptyFn,
    // abstract
    fnReceiveParam:  Ext.emptyFn,
    // abstract
    fnInitBinding:  Ext.emptyFn,

    toolBar : {},    
    comPanelToolbar : {
			xtype : 'panel',
			//id : 'comPanelToolbar',
			flex : 0,
			border : 0,
			margin : '0 0 0 0 ',
			dockedItems : [ ]
	},
	
	onQueryButtonDown: Ext.emptyFn,
	onSubmitButtonDown: function()	{
		window.close();
	},

	
	// private
	_setToolBar : function() {
		var me = this;
		var btnQuery = Ext.create('Ext.button.Button', {
		 		text : '조회',tooltip : '조회', //iconCls : 'icon-query'	, 
				handler: function() { 
					if(UniAppManager.hasDirty) {
						//if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
						//	me.onQueryButtonDown();
						//}
						Ext.Msg.show({
						     title:UniUtils.getMessage('system.message.commonJS.baseApp.confirm','확인'),
						     msg: UniUtils.getMessage('system.message.commonJS.baseApp.dirty','내용이 변경되었습니다.') + "\n" 
                             		+ UniUtils.getMessage('system.message.commonJS.baseApp.confirmSave','변경된 내용을 저장하시겠습니까?'),
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	console.log(res);
						     	if (res === 'yes' ) {
						     		me.onSaveAndQueryButtonDown();
						     	} else if(res === 'no') {
						     		me.onQueryButtonDown();
						     	}
						     }
						});
					} else {
						me.onQueryButtonDown();
					}
				}
			});
			
		var btnSubmit = Ext.create('Ext.button.Button', {
		 		text : '확인',tooltip : '확인', //iconCls : 'icon-query'	, 
				handler: function() { 
					me.onSubmitButtonDown();
				}
			});
    	this.toolbar = Ext.create('Ext.toolbar.Toolbar',   {
				dock : 'top',
				items : [ '->', btnQuery,
				// space
				' ','-',' ',
				btnSubmit,
				/*{text : '확인',tooltip : '확인',iconCls : 'icon-query',
					handler: function() { 
						window.close();
					}
				},*/
				{text : '닫기',tooltip : '닫기', // iconCls : 'icon-query',
					handler: function() { 
						window.close();
					}
				},
				' '
			]
		});
	
	},
	setToolbarButtons: function(btnNames, state) {
		var me = this;
		if(Ext.isArray(btnNames) ) {
			for(i =0, len = btnNames.length; i < len; i ++) {
				var element = btnNames[i];
				me._setToolbarButton(element, state);
			}
		} else {
			me._setToolbarButton(btnNames, state);
		}
	},
	_setToolbarButton : function(btnName, state) {
		var obj = this.buttons[btnName];
		//console.log("_setToolbarButton ", btnName, state);
			
		if(obj) {
			(state) ? obj.enable():obj.disable();
		}
	},
	isDirty: function() {
		var obj =  this.getTopToolbar().getComponent('save');
		var rv = false;
		if(obj) {
			rv =  ! obj.disabled;
		}
		return rv;
	},
    getTopToolbar: function() {
        return this.toolbar;
    }
});


