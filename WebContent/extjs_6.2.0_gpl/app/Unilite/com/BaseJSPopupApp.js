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

Ext.define('Unilite.com.BaseJSPopupApp', {
	extend: 'Ext.window.Window',
    requires: [
    	'Unilite.com.UniAppManager'
	],
    
    text: {
        btnQuery: '조회',
        btnReset: '신규',
        btnNewData: '추가',
        btnDelete: '삭제',
        btnSave: '저장',
        btnDeleteAll: '전체삭제',
        btnExcel: '다운로드',
        btnPrev: '이전',
        btnNext: '이후',
        btnDetail: '추가검색',
        btnClose: '닫기'
    },
    closable: false,
    closeAction: 'destroy',         // 한화면에 같은 팝업을 여러군데 쓸수 있으므로 윈도는 close로 닫고 destory 시킨다.
    modal: true,
    resizable: true,
    layout:{type:'vbox', align:'stretch'},
    width: 500,
    height: 400,
    uniOpt:{
    	btnQueryHide:false,
    	btnSubmitHide:false,
    	btnCloseHide:false
    },
    //defaults: {padding:'0 0 5 0'},
    callBackFn: Ext.emptyFn,
    
    constructor : function (config) {
        var me = this;

        me.callParent(arguments);
        
        me.delayedSaveDataButtonDown = Ext.create('Ext.util.DelayedTask', me.onSaveDataButtonDown, me);
    },
    initComponent : function(){    
    	var me  = this;
        
    	this.setToolBar();
//		this.comPanelToolbar.dockedItems = [this.toolbar];
//		console.log("BaseJSPopupApp init.");
//    	var newItems = [];
//    	newItems.push(this.comPanelToolbar);  
// 	
//    	for(i = 0, len = this.items.length; i < len; i ++ ) {
//    		var element = this.items[i];
//    		newItems.push(element);
//    	}
    	//this.items = newItems;   
        this.tbar= this.toolbar;
    	this.callParent();		
    	//var params = Unilite.getParams();
    	//this.fnInitBinding(params);
    	
    },
    // abstract
	beforeClose:Ext.emptyFn,
    // abstract
    fnReceiveParam:  Ext.emptyFn,
    // abstract
    fnInitBinding:  Ext.emptyFn,

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

    returnData: function(data) {
       if(Ext.isFunction(this.callBackFn) && this.callBackFn != null) {
        	if(this.callBackScope) this.callBackFn.call(this.callBackScope, data, this.popupType);
        	else this.callBackFn.call(this, data, this.popupType);
        }
        this.close();
    },
	
	// private
	setToolBar : function() {
		var me = this;
		var btnQuery = Ext.create('Ext.button.Button', {
		 		text : '조회',tooltip : '조회', //iconCls : 'icon-query'	, 
		 		hidden:me.uniOpt.btnQueryHide,
				handler: function() { 
					me.onQueryButtonDown();
				}
			});
			
		var btnSubmit = Ext.create('Ext.button.Button', {
		 		text : '확인',tooltip : '확인', //iconCls : 'icon-query'	, 
		 		hidden:me.uniOpt.btnSubmitHide,
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

/**
 * 카렌다용 
 */
Ext.define('Unilite.com.BaseJSPopupCalApp', {
    extend: 'Unilite.com.BaseJSPopupApp',
    // private
    setToolBar : function() {
        var me = this;
        
		var btnSave = {
                xtype: 'button',
                text : me.text.btnSave, tooltip : '저장', disabled: true,
                itemId : 'save',
                handler : function() { 
                    Ext.getBody().mask();
                    me.delayedSaveDataButtonDown.delay(500);
                }
            };
            
        var btnDelete = {
                xtype: 'button',
                text : me.text.btnDelete,tooltip : '삭제', disabled: true,
                itemId : 'delete',
                handler : function() { me.onDeleteDataButtonDown() }
            };

        this.toolbar = Ext.create('Ext.toolbar.Toolbar',   {
            dock : 'top',
            items : [ '->', 
	            btnSave,btnDelete,
	            // space
	            ' ','-',' ',
	            
	            {text : '닫기',tooltip : '닫기', // iconCls : 'icon-query',
	                handler: function() { 
	                     me.close();
	                }
	            }
            ]
        });
    
    }
});

/**
 * 그리드 설정용 
 */
Ext.define('Unilite.com.BaseJSPopupGridApp', {
    extend: 'Unilite.com.BaseJSPopupApp',
    // private
    setToolBar : function() {
        var me = this;
        
        var btnQuery =  {
                xtype: 'button',
		 		text : '조회',tooltip : '조회', //iconCls : 'icon-query'	, 
				handler: function() { 
					me.onQueryButtonDown();
				}
			};
		var btnReset =  {
                xtype: 'button',
		 		text : '초기화',tooltip : '초기화', //iconCls : 'icon-query'	, 
				handler: function() { 
					me.onResetButtonDown();
				}
			};	
		
		var btnSave = {
                xtype: 'button',
                text : me.text.btnSave, tooltip : '저장', disabled: true,
                itemId : 'save',
                handler : function() { 
                    Ext.getBody().mask();
                    me.delayedSaveDataButtonDown.delay(500);
                }
            };
            
        var btnDelete = {
                xtype: 'button',
                text : me.text.btnDelete,tooltip : '삭제', disabled: true,
                itemId : 'delete',
                handler : function() { me.onDeleteDataButtonDown() }
            };

        var btnSubmit = Ext.create('Ext.button.Button', {
	 		text : '확인',tooltip : '확인', //iconCls : 'icon-query'	, 
			handler: function() { 
				me.onSubmitButtonDown();
			}
		});
		
        this.toolbar = Ext.create('Ext.toolbar.Toolbar',   {
            dock : 'top',
            items : [ '->', 
	            btnQuery,	
	            btnReset,
	            ' ','-',' ',	            
	            btnSave,btnDelete,
	            // space
	            ' ','-',' ',
	            btnSubmit,
	            {text : '닫기',tooltip : '닫기', // iconCls : 'icon-query',
	                handler: function() { 
	                     me.close();
	                }
	            }
            ]
        });
    
    }
});
