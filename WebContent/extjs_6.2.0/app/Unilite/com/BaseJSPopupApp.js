//@charset UTF-8
/**
 */
Ext.define('Unilite.com.BaseJSPopupApp', {
	extend: 'Ext.window.Window',
	requires: [
		'Unilite.com.UniAppManager'
	],
	text: {
		btnQuery	: UniUtils.getLabel('system.label.commonJS.btnQuery'	,'조회'),
		btnReset	: UniUtils.getLabel('system.label.commonJS.btnReset'	,'신규'),
		btnNewData	: UniUtils.getLabel('system.label.commonJS.btnNewData'	,'추가'),
		btnDelete	: UniUtils.getLabel('system.label.commonJS.btnDelete'	,'삭제'),
		btnSave		: UniUtils.getLabel('system.label.commonJS.btnSave'		,'저장'),
		btnDeleteAll: UniUtils.getLabel('system.label.commonJS.btnDeleteAll','전체삭제'),
		btnExcel	: UniUtils.getLabel('system.label.commonJS.btnExcel'	,'다운로드'),
		btnPrev		: UniUtils.getLabel('system.label.commonJS.btnPrev'		,'이전'),
		btnNext		: UniUtils.getLabel('system.label.commonJS.btnNext'		,'이후'),
		btnDetail	: UniUtils.getLabel('system.label.commonJS.btnDetail'	,'추가검색'),
		btnClose	: UniUtils.getLabel('system.label.commonJS.btnClose'	,'닫기'),
		btnApply	: UniUtils.getLabel('system.label.commonJS.btnApply'	,'확인'),
		btnReset2	: UniUtils.getLabel('system.label.commonJS.btnReset2'	,'확인')
	},
	closable	: false,
	closeAction	: 'destroy',		// 한화면에 같은 팝업을 여러군데 쓸수 있으므로 윈도는 close로 닫고 destory 시킨다.
	modal		: true,
	resizable	: true,
	keyMapEnabled: true,
	layout		: {type:'vbox', align:'stretch'},
	width		: 500,
	height		: 400,
	uniOpt		:{
		btnQueryHide	: false,
		btnSubmitHide	: false,
		btnCloseHide	: false
	},
	//defaults: {padding:'0 0 5 0'},
	callBackFn	: Ext.emptyFn,
	constructor	: function (config) {
		var me = this;
		me.callParent(arguments);
		me.delayedSaveDataButtonDown = Ext.create('Ext.util.DelayedTask', me.onSaveDataButtonDown, me);
	},
	initComponent : function(){	
		var me  = this;
		this.setToolBar();
//		this.comPanelToolbar.dockedItems = [this.toolbar];
//		console.log("BaseJSPopupApp init.");
//		var newItems = [];
//		newItems.push(this.comPanelToolbar);  
// 	
//		for(i = 0, len = this.items.length; i < len; i ++ ) {
//			var element = this.items[i];
//			newItems.push(element);
//		}
		//this.items = newItems;
		this.tbar= this.toolbar;
		this.callParent();
		//var params = Unilite.getParams();
		//this.fnInitBinding(params);
		me.on('render', me._onRender);
		me.on('afterrender', me._onAfterrender);
		me.on('beforeclose', me._onBeforeClose);
	},
	// abstract
	//beforeClose:Ext.emptyFn,
	_onBeforeClose:function(window) {
		var me = this;
		if(me.isLoading) {
			return false;
		}
	},
	// abstract
	fnReceiveParam: Ext.emptyFn,
	// abstract
	fnInitBinding: Ext.emptyFn,
	toolBar: {},
	comPanelToolbar: {
		xtype : 'panel',
		//id : 'comPanelToolbar',
		flex : 0,
		border : 0,
		margin : '0 0 0 0 ',
		dockedItems : [ ]
	},
	onQueryButtonDown: Ext.emptyFn,
	onSubmitButtonDown: function()	{
		this.close();
	},
	returnData: function(data, close_flag) {
		if(Ext.isFunction(this.callBackFn) && this.callBackFn != null) {
			if(this.callBackScope) this.callBackFn.call(this.callBackScope, data, this.popupType);
			else this.callBackFn.call(this, data, this.popupType);
		}
		//20200106 close_flag 받아서 창 닫을지 여부 판단하도록 로직 추가
		if(Ext.isEmpty(close_flag) || close_flag != 'N') {
			this.close();
		}
	},
	_onRender: function()	{
		var me = this;
	},
	_onAfterrender: function(window, eOpts) {
		var me = this.getEl();
		var window = this
		me.keyNav = new Ext.util.KeyMap({
			target: me.el,
			binding: [{
				key: Ext.EventObjectImpl.ESC,
				fn: function(keyCode, e){
					if( !(e.shiftKey || e.ctrlKey || e.altKey ) ) {	// ESC (닫기)
						e.stopEvent();
						window.close();
						return false;
					}
				}
			}]
		});
	},
	// private
	setToolBar : function() {
		var me = this;
		var btnQuery = Ext.create('Ext.button.Button', {
				text : me.text.btnQuery,tooltip : me.text.btnQuery, //iconCls : 'icon-query',
				hidden:me.uniOpt.btnQueryHide,
				handler: function() { 
					me.onQueryButtonDown();
				}
			});

		var btnSubmit = Ext.create('Ext.button.Button', {
			text : me.text.btnApply,tooltip : me.text.btnApply, //iconCls : 'icon-query',
			hidden:me.uniOpt.btnSubmitHide,
			handler: function() { 
				me.onSubmitButtonDown();
			}
		});

		this.toolbar = Ext.create('Ext.toolbar.Toolbar', {
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
				{text : me.text.btnClose ,tooltip : me.text.btnClose, // iconCls : 'icon-query',
				hidden:me.uniOpt.btnClosetHide,
					handler: function() { 
						//me.close();
						me._onCloseBtnDown();
					}
				}
				,' '
				//,'-',' ', me._getSheetButtons()
			]
		});
	},
	_onCloseBtnDown: function() {
		if(Ext.isFunction(this.callBackFn) && this.callBackFn != null) {
			if(this.callBackScope) this.callBackFn.call(this.callBackScope, null, this.popupType);
			else this.callBackFn.call(this, null, this.popupType);
		}
		this.close();
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
		var obj =  this.getTopToolbar().getComponent(btnName);
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
		//me.setXY(me.);
		
		me.callParent(arguments);
	},
	getTopToolbar: function() {
		return this.toolbar;
	}
});

/** 카렌다용 
 */
Ext.define('Unilite.com.BaseJSPopupCalApp', {
	extend: 'Unilite.com.BaseJSPopupApp',
	// private
	setToolBar : function() {
		var me = this;

		var btnSave = {
				xtype: 'button',
				text : me.text.btnSave, tooltip : me.text.btnSave, disabled: true,
				itemId : 'save',
				handler : function() { 
					Ext.getBody().mask();
					me.delayedSaveDataButtonDown.delay(500);
				}
			};

		var btnDelete = {
				xtype: 'button',
				text : me.text.btnDelete,tooltip : me.text.btnDelete, disabled: true,
				itemId : 'delete',
				handler : function() { me.onDeleteDataButtonDown() }
			};

		this.toolbar = Ext.create('Ext.toolbar.Toolbar',   {
			dock : 'top',
			items : [ '->', 
				btnSave,btnDelete,
				// space
				' ','-',' ',
				{text :me.text.btnClose ,tooltip : me.text.btnClose, // iconCls : 'icon-query',
					handler: function() { 
						 me.close();
					}
				}
			]
		});
	}
});

/** 그리드 설정용 
 */
Ext.define('Unilite.com.BaseJSPopupGridApp', {
	extend: 'Unilite.com.BaseJSPopupApp',
	// private
	setToolBar : function() {
		var me = this;

		var btnQuery = {
			xtype: 'button',
			itemId : 'query',
	 		text : me.text.btnQuery ,tooltip : me.text.btnQuery, //iconCls : 'icon-query',
			handler: function() { 
				me.onQueryButtonDown();
			}
		};

		var btnReset = {
			xtype: 'button',
			itemId : 'reset',
	 		text :  me.text.btnReset2 ,tooltip :me.text.btnReset2 , //iconCls : 'icon-query',
			handler: function() { 
				me.onResetButtonDown();
			}
		};

		var btnSave = {
			xtype: 'button',
			text : me.text.btnSave, tooltip : me.text.btnSave, disabled: true,
			itemId : 'save',
			handler : function() { 
				Ext.getBody().mask();
				me.delayedSaveDataButtonDown.delay(500);
			}
		};

		var btnDelete = {
			xtype: 'button',
			text : me.text.btnDelete,tooltip : me.text.btnDelete, disabled: true,
			itemId : 'delete',
			handler : function() { me.onDeleteDataButtonDown() }
		};

		var btnSubmit = Ext.create('Ext.button.Button', {
	 		text : me.text.btnApply ,tooltip : me.text.btnApply, //iconCls : 'icon-query', 
			handler: function() { 
				me.onSubmitButtonDown();
			}
		});

		this.toolbar = Ext.create('Ext.toolbar.Toolbar',   {
			dock : 'top',
			items : [ '->', 
				//btnQuery,	
				//btnReset,
				//' ','-',' ',
				btnSave,
				//btnDelete,
				// space
				//' ','-',' ',
				//btnSubmit,
				{text :  me.text.btnClose, tooltip :  me.text.btnClose, // iconCls : 'icon-query',
					handler: function() { 
						 me.close();
					}
				}
			]
		});
	}
});