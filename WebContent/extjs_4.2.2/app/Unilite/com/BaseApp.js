//@charset UTF-8
/**
 * Base Application 모듈
 * 
 */

Ext.define('Unilite.com.BaseApp', {
	extend: 'Unilite.com.UniAbstractApp',
    alias: 'widget.BaseApp',    
	name: 'BaseApp',

	requires: [
		'Ext.Msg',
		'Ext.button.Button',
		'Ext.toolbar.Toolbar',
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
        btnPrint: '인쇄',
        btnPrev: '이전',
        btnNext: '이후',
        btnDetail: '추가검색',
        btnClose: '닫기'
    },
    uniOpt: {
    	showToolbar: true
    },
    layout: 'border' ,    
    listeners: {
    	afterrender: function(viewport, eOpts) {
    		var me = viewport;
    		/** IE10,11 에서 preventDefault 가 제대로 동작하지 않고 있음.
    		 * preventDefault 	: Prevents the browsers default handling of the event
    		 * stopPropagation 	: Cancels bubbling of the event.
    		 * stopEvent	 	: Stop the event (preventDefault and stopPropagation)
    		 */
            me.keyNav = new Ext.util.KeyMap({
                target: me.el,
                binding: [
                {
                    key: Ext.EventObject.F2,
                    fn: function(keyCode, e){
                    	if( !(e.shiftKey || e.ctrlKey || e.altKey ) ) {	// only F2 (조회)
	                        me._clickToolBarButton('query');
	                        e.stopEvent();
                    	}else if(e.shiftKey && !e.ctrlKey && !e.altKey) {	// Shift + F2 (초기화)
                    		me._clickToolBarButton('reset');
                        	e.stopEvent();
                    	}
                    }
                },{
                    key: Ext.EventObject.F9,
                    fn: function(keyCode, e){            
                    	if( !(e.shiftKey || e.ctrlKey || e.altKey ) ) {	// only F9 (저장)
	                        me._clickToolBarButton('save');
	                        e.stopEvent();
                    	}
                   	}
                },{
                    key: Ext.EventObject.BACKSPACE,
                    fn: function(keyCode, e){                       
                    	if( e.shiftKey && !e.ctrlKey && !e.altKey ) {	// Shift + Backspace (삭제)
	                        me._clickToolBarButton('delete');
	                        e.stopEvent();
                    	}
                   	}
                },{
                    key: Ext.EventObject.F8,
                    fn: function(keyCode, e){                 
                    	if( e.shiftKey && !e.ctrlKey && !e.altKey ) {	// Shift + F8 (추가)
                    		me._clickToolBarButton('newData');
                    		e.stopEvent();
                    	}
                   	}
                }/*,{
                    key: Ext.EventObject.LEFT,
                    fn: function(keyCode, e){
                    	if( e.shiftKey && !e.ctrlKey && !e.altKey ) {	// Shift + <-
	                        me._clickToolBarButton('prev');
	                        e.stopEvent();
                    	}
                   	}
                },{
                    key: Ext.EventObject.RIGHT,
                    fn: function(keyCode, e){
                    	if( e.shiftKey && !e.ctrlKey && !e.altKey ) {	// Shift + ->
	                        me._clickToolBarButton('next');
	                        e.stopEvent();
                    	}
                   	}
                }*/],
                scope: this
            }); 
            
            this.focus();
        }				
	},
    constructor : function (config) {
        var me = this;
		
		Ext.apply(this, config || {});
		
        me.callParent(arguments);
        
        me.delayedSaveDataButtonDown = Ext.create('Ext.util.DelayedTask', me.onSaveDataButtonDown, me);
    },
    initComponent: function(){    
    	var me  = this;
    	UniAppManager.setApp( me );
    	
    	this._setToolBar();
		this.comPanelToolbar = {
            dockedItems : [this.toolbar], 
            padding:0, 
            border:0,
            region:'north'
        };
		
		var newItems = [];
        var pgmTitle = '';
        if(typeof PGM_TITLE !== 'undefined') {
            pgmTitle = PGM_TITLE + (UserInfo.appOption.showPgmId ? " (" +PGM_ID +")" : "");
        }
        
        var title = {
            xtype: 'container',
            cls: 'uni-pageTitle',
            id: 'UNILITE_PG_TITLE',
            html: pgmTitle,
            padding: '0 0 5px 0',
            height: 32,
            region:'north'
        };
        newItems.push(title);
        if(this.uniOpt.showToolbar) {
    		newItems.push(this.comPanelToolbar);  
        }

        // Border를 쓸결우
        if(me.borderItems) {
            for(i = 0, len = me.borderItems.length; i < len; i ++ ) {
				 var item = me.borderItems[i];
				 newItems.push(item);
			}
            console.log('border items');
        }
        
        // 기존 방식의 경우
        if(me.items && me.items.length > 0) {
	        newItems.push({
	            xtype: 'panel',
	            region: 'center',
	            border: false,
	            padding: '1 1 1 1',
	            layout: { type: 'vbox', pack: 'start', align: 'stretch' },
	            items: me.items
	        });
            console.log('normal items');
        }
    	this.items = newItems;
    	
    	this.callParent();

    	this.fnInitButton();
    	
		//var params = Unilite.getParams();
    	var params;
    	if(parent) {
    		params = parent.UniAppManager.getAppParams();	//openTab 시에 저장된 appParams
    	}else{
    		params = Unilite.getParams();	//url 파싱이라서 object 를 넘기지 못함.
    	}
    	this.fnInitBinding(Ext.isEmpty(params) ? {} : params);
    	
    	if(Ext.isDefined(me.focusField)) {    		
    		me.focusField.focus();
    	}else{
    		var form = me.down('form');
    		if(form) {
    			//form.child(':focusable').focus();
    			var fd = form.down('field:not(hiddenfield)');
    			if(fd)
    				fd.focus();
    		}
    	}
    	    	
		console.log("BaseApp initialized.");
    },
    
    /**
     * 
     *  @abstract
     */
    fnReceiveParam:  Ext.emptyFn,

    /**
     * 
     * @abstract
     */
    fnInitBinding:  Ext.emptyFn,
    
    /**
     * 
     */
    fnInitButton:function(){
    	var me = this;
    	for(i = 0, len = this.buttons.length; i < len; i ++ ) {
    		var element = this.buttons[i];
    		if(element.name != 'query') {
				me._setToolbarButton(element.name, false);
			}
    	}

	},
	/**
	 * [조회] 버튼 처리 함수
	 * 각 화면에서 overide 해야 함.
	 * @abstract
	 */
    onQueryButtonDown: function() {
    	return true;
    }, 
    /**
	 * [저장] 버튼 처리 함수
	 * 각 화면에서 overide 해야 함.
	 * @abstract
	 */
	onSaveAndQueryButtonDown: function() {
		// 저장 후 조회 ( 저장 완료 체크 필요 )
		this.onSaveDataButtonDown(); 
		this.onQueryButtonDown();
	}, 
	/**
	 * 저장 후 조회 ( 저장 완료 체크 필요 )
	 * @abstract
	 */
	onSaveAndResetButtonDown: function() {
		// 저장 후 조회 ( 저장 완료 체크 필요 )
		this.onSaveDataButtonDown(true); 
		this.onResetButtonDown();
	},
    /**
     * 
     * @abstract
     */	
	onResetButtonDown:function() {this.fnInitBinding();},
    /**
     * 데이타 추가
     * @abstract
     */	
	onNewDataButtonDown: Ext.emptyFn,  
    /**
     * 데이타 삭제
     * @abstract
     */	
	onDeleteDataButtonDown: Ext.emptyFn, 
    /**
     * 전체 삭제 
     * @abstract
     */	
	onDeleteAllButtonDown: Ext.emptyFn, 
    /**
     * 저장	
     * @abstract
     */	
	onSaveDataButtonDown: Ext.emptyFn,	/**
     * 저장   
     * @abstract
     */ 
    onSaveDataButtonDown: Ext.emptyFn,  
    /**
     * 엑셀 저장	
     * @abstract
     */	
	onSaveAsExcelButtonDown: Ext.emptyFn,
    /**
     * 인쇄
     * @abstract
     */		
	onPrintButtonDown: Ext.emptyFn, 
    /**
     * 
     * @abstract
     */	
	onPrevDataButtonDown: Ext.emptyFn,
    /**
     * 
     * @abstract
     */	
	onNextDataButtonDown: Ext.emptyFn,
    /**
     * 상세검색
     * @abstract
     */	
	onDetailButtonDown: Ext.emptyFn,	
    /**
     * 인쇄
     * @abstract
     */	
	onPrintButtonDown: Ext.emptyFn,	
    /**
     * 닫기
     * @abstract
     */	
	onCloseButtonDown: function() {
		self.close();
		alert('작업중');
	},
	
	/**
	 * 버튼 상태 변경 
	 * btnNames : 버튼명 또는 버튼명 배열
	 * 
	 * state : true / false
	 *       @example
	 *       예제) 
	 * 	        this.setToolbarButtons('newData',true);
	 *          this.setToolbarButtons(['prev','next'],true);
	 */
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
		//var obj = this.buttons[btnName];
		//console.log("_setToolbarButton ", btnName, state);
			
		var obj =  this.getTopToolbar().getComponent(btnName);
		if(obj) {
			(state) ? obj.enable():obj.disable();
		}
	},
	addButton: function( button ) {
		var toolbar =  this.getTopToolbar();
		if(toolbar) {
			var index = toolbar.items.findIndex('itemId','detail');
			toolbar.insert(index+2, button);
			console.log("t");
		}
	},
	/**
	 * 조회 버튼 클릭시 저장 여부 확인 이 필요 한지 확인
	 * save 버튼이 enable되어 있으면 true
	 * 여러 탭이 있는 경우도 있음.
	 */ 	
	_needSave: function() {
		//var button = this.buttons['save'];
		//return ! button.isDisabled( );
		return ! this.getTopToolbar().getComponent('save').isDisabled( );
	},
	getTopToolbar: function() {
		return this.toolbar;
	},
	// private
	_setToolBar : function() {
		var me = this;
		var btnWidth = 26;
		var btnHeight = 26;	
		
		var btnQuery =  {
                xtype: 'uniBaseButton',
		 		text : me.text.btnQuery,
		 		tooltip : '조회' + ' [F2]',
		 		iconCls : 'icon-query', 
		 		width: btnWidth, height: btnHeight,
		 		itemId : 'query',
				handler: function() { 
					//if(this.autoButtonControl && UniAppManager.hasDirty) {
					if( me._needSave() ) {
						//if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
						//	me.onQueryButtonDown();
						//}
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	//console.log(res);
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
			};
		var btnReset = {
                xtype: 'uniBaseButton',
				text : me.text.btnReset, 
				tooltip : '초기화' + ' [Shift+F2]',
				iconCls: 'icon-reset',
				width: btnWidth, height: btnHeight,
		 		itemId : 'reset',
				handler : function() { 
					if( me._needSave() ) {
						//if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
						//	me.onQueryButtonDown();
						//}
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	console.log(res);
						     	if (res === 'yes' ) {
						     		me.onSaveAndResetButtonDown();
						     	} else if(res === 'no') {
						     		me.onResetButtonDown();
						     	}
						     }
						});
					} else {
						me.onResetButtonDown() ;
					}
					
				}
			};
		
		var btnNewData = {
                xtype: 'uniBaseButton',
				text : me.text.btnNewData,
				tooltip : '추가' + ' [Shift+F8]',
				iconCls: 'icon-new',disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'newData',
				handler : function() { me.onNewDataButtonDown() }
			};
		var btnDelete = {
                xtype: 'uniBaseButton',
				text : me.text.btnDelete,
				tooltip : '삭제' + ' [Shift+Baskspace]',
				iconCls: 'icon-delete',disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'delete',
				handler : function() { me.onDeleteDataButtonDown() }
			};
		var btnSave = {
                xtype: 'uniBaseButton',
				text : me.text.btnSave, 
				tooltip : '저장' + ' [F9]', 
				iconCls: 'icon-save',disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'save',
				handler : function() { 
                    //Ext.getBody().mask();
                    me.delayedSaveDataButtonDown.delay(500);
                }
			};
		var btnDeleteAll = {
                xtype: 'uniBaseButton',
				text : me.text.btnDeleteAll, tooltip : '전체삭제', iconCls: 'icon-deleteAll',disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'deleteAll',
				handler : function() { me.onDeleteAllButtonDown() }
			};			
		var btnExcel = Ext.create('Unilite.com.button.BaseButton', {
				text : me.text.btnExcel, tooltip : '엑셀 다운로드', iconCls: 'icon-excel',disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'excel',
				//handler : function() { me.onSaveAsDataButtonDown() }
				handler : function() { me.onSaveAsExcelButtonDown() }
			});			
		var btnPrev = {
                xtype: 'uniBaseButton',
				text : me.text.btnPrev, 
				tooltip : '이전 레코드', 
				iconCls: 'icon-movePrev',disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'prev',
				handler : function() { me.onPrevDataButtonDown() }
			};
		var btnNext = {
                xtype: 'uniBaseButton',
				text : me.text.btnNext, 
				tooltip : '다음 레코드', 
				iconCls: 'icon-moveNext', disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'next',
				handler : function() { me.onNextDataButtonDown() }
			};
		var btnDetail = {
                xtype: 'uniBaseButton',
				text : me.text.btnDetail, tooltip : '추가검색', iconCls: 'icon-detail', disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'detail',
				handler : function() { me.onDetailButtonDown() }
			};	
		var btnPrint = {
                xtype: 'uniBaseButton',
				text : me.text.btnDetail, tooltip : '인쇄', iconCls: 'icon-print', disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'print',
				handler : function() { me.onPrintButtonDown() }
			};				
			
			
		var btnClose = {
                xtype: 'uniBaseButton',
				text : me.text.btnClose, tooltip : '닫기', iconCls: 'icon-close', disabled: false,
				width: btnWidth, height: btnHeight,
		 		itemId : 'close',
				handler : function() {
					
					var tabPanel = parent.Ext.getCmp('contentTabPanel');
					if(tabPanel) {
						var activeTab = tabPanel.getActiveTab();
	//					tabPanel.remove(activeTab);
						var canClose = activeTab.onClose(activeTab);
						if(canClose)  {
							tabPanel.remove(activeTab);
						}
					} else {
						self.close();
					}
				}
			};			
		/*
		this.buttons = {"query":btnQuery,
						"reset":btnReset,
						"newData":btnNewData,
						"delete":btnDelete,
						"save":btnSave,
						"excel":btnExcel,
						"prev":btnPrev,
						"next":btnNext,
						"detail":btnDetail};
		*/
//		var toolbarItems = [ btnQuery,'-', btnReset, 
//						btnNewData, btnDelete,
//						btnSave, btnDeleteAll, btnExcel,
//				// space
//				' ','-',' ',btnPrev, btnNext ,' ','-',' ', btnDetail, '-',
//				btnClose
//				];
        var toolbarItems = [ btnQuery, btnReset, 
                btnNewData, btnDelete,
                btnSave, btnDeleteAll, //btnExcel,
                btnPrint,
                // space
                btnPrev, btnNext , 
                btnClose
                ];
                
		var chk01 = ( typeof IS_DEVELOPE_SERVER == "undefined") ? false : IS_DEVELOPE_SERVER  ;
		if( chk01 ) {
			toolbarItems.push( // space
				'->',				
				{xtype : 'button',
					text : '',
					tooltip : '현재탭 Reload(Cache 사용 안함!)', 
					iconCls: 'icon-reload',
					handler : function() {
						// param : 
						//			false - Default. Reloads the current page from the cache.
						//			true - The current page must be reloaded from the server
						location.reload(true );
					}
				},
				{xtype : 'button',
					text : '',
					tooltip : '현재 Tab을 새창으로 띄우기', 
					iconCls: 'icon-newWindow',
					handler : function() {
						window.open(window.location.href, '_blank');
					}
				}
			);
		} // IS_DEVELOPE_SERVER
			
    	this.toolbar = Ext.create('Ext.toolbar.Toolbar',   {
				dock : 'top',
				height: 30, 
				padding: '0 0 0 5',
				items : toolbarItems
		});
	},
	_clickToolBarButton: function(buttonId) {
		var me = this;
		var btn = me.getTopToolbar().getComponent(buttonId);
        if(btn.isVisible() && !btn.isDisabled()) {
        	if(btn.el.dom.click)
        		btn.el.dom.click();
        }
	},
	isDirty: function() {
		var obj =  this.getTopToolbar().getComponent('save');
		var rv = false;
		if(obj) {
			rv =  ! obj.disabled;
		}
		return rv;
	}
	
});


