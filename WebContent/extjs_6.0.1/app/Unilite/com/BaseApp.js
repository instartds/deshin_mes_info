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
		'Ext.window.MessageBox',
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
        btnClose: '닫기',
        btnManual: '도움말'
    },
    uniOpt: {
    	showToolbar: true
    	
    },
    layout: 'border' ,    
    listeners: {
    	afterrender: function(viewport, eOpts) {
    		var me = viewport;
    		// 도움말 버튼 활성화
    		if(MANUAL_YN && MANUAL_YN == 'Y')  {
    			UniAppManager.setToolbarButtons('manual',true);
    		}
    		
    		/** IE10,11 에서 preventDefault 가 제대로 동작하지 않고 있음.
    		 * preventDefault 	: Prevents the browsers default handling of the event
    		 * stopPropagation 	: Cancels bubbling of the event.
    		 * stopEvent	 	: Stop the event (preventDefault and stopPropagation)
    		 */
    		//var vDom = viewport.getEl();
            me.keyNav = new Ext.util.KeyMap({
                target: me.el,
                binding: [
                {
                    key: Ext.EventObjectImpl.F2,
                    fn: function(keyCode, e){
                    	if( !(e.shiftKey || e.ctrlKey || e.altKey ) ) {	// only F2 (조회)
	                        me._clickToolBarButton('query');
	                        e.stopEvent();
                    	}
                    }
                },{
                    key: Ext.EventObjectImpl.F3,
                    fn: function(keyCode, e){            
                    	if( !(e.shiftKey || e.ctrlKey || e.altKey ) ) {	// only F3 (초기화)
	                       me._clickToolBarButton('reset');
	                        e.stopEvent();
                    	}
                   	}
                },{
                    key: Ext.EventObjectImpl.F4,
                    fn: function(keyCode, e){            
                    	if( !(e.shiftKey || e.ctrlKey || e.altKey ) ) {	// only F4 (추가)
	                        me._clickToolBarButton('newData');
	                        e.stopEvent();
                    	}
                   	}
                },{
                    key: Ext.EventObjectImpl.F6,
                    fn: function(keyCode, e){                       
                    	if( e.shiftKey && !e.ctrlKey && !e.altKey ) {	// only F6 (삭제)
	                        me._clickToolBarButton('delete');
	                        e.stopEvent();
                    	}
                   	}
                },{
                    key: Ext.EventObjectImpl.F7,
                    fn: function(keyCode, e){                 
                    	if( e.shiftKey && !e.ctrlKey && !e.altKey ) {	// only F7 (저장)
                    		me._clickToolBarButton('save');
                    		e.stopEvent();
                    	}
                   	}
                }],
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
        me.delayedCloseButtonDown 	 = Ext.create('Ext.util.DelayedTask', me._onCloseButtonDown, me);
        
       
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
//    	this.comPanelToolbar = new Ext.panel.Panel({
//    	    dockedItems : [this.toolbar], 
//            padding:0, 
//            border:0,
//            region:'north'    		
//    	});
		
    	var newItems = [];
        var pgmTitle = '';
        if(typeof PGM_TITLE !== 'undefined' ) {
        	if(PGM_TITLE == '')	{
        		if(parent && parent.Ext.StoreMgr.lookup("treeSystemMenuStore"))	{
        			var mainSysTreeStore = parent.Ext.StoreMgr.lookup("treeSystemMenuStore");
        			var menuRecIdx =mainSysTreeStore.find('prgID', PGM_ID);
        			var menuRec = mainSysTreeStore.getAt(menuRecIdx);
        			PGM_TITLE = menuRec.get("text");
        		}
        	}
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
	            items: me.items //oldItems
	        });
            console.log('normal items');
        }
    	this.items = newItems;
    	
    	this.callParent();
		
    	//me.on('afterreder', function(app){
    		me.panelResult = Ext.getCmp('panelResultForm');
    		me.panelSearch = Ext.getCmp('searchForm');    		
    	//})
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
//    		var form = me.down('form');
//    		if(form) {
//    			//form.child(':focusable').focus();
//    			var fd = form.down('field:not(hiddenfield)');
//    			if(fd)
//    				fd.focus();
//    		}
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
	
	onManualButtonDown:function()	{
		if(EXT_PGM_ID)	{
			var fullUrl = CPATH+"/fileman/manual/"+EXT_PGM_ID; //me.getFullUrl();
			var viewer= CPATH+"/resources/pdfJS/web/viewer.jsp";
			var title = PGM_TITLE ? PGM_TITLE:'Manual';
			if (! Ext.isIE8m ) {
				fullUrl= viewer+"?file="+fullUrl+"&params={title:"+Ext.encode(title)+"}";
			} 
			var manualWin = window.open(fullUrl, 'manual'+EXT_PGM_ID,"width=800.height=600,menubar=no, toolbar=no");
			
			manualWin.focus();
		} else {
			alert("프로그램 정보가 없습니다.");
		}
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
		var btnWidth = 28;
		var btnHeight = 28;	
		
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
				tooltip : '초기화' + ' [F3]',
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
				tooltip : '추가' + ' [F4]',
				iconCls: 'icon-new',disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'newData',
				handler : function() { me.onNewDataButtonDown() }
			};
		var btnDelete = {
                xtype: 'uniBaseButton',
				text : me.text.btnDelete,
				tooltip : '삭제' + ' [F6]',
				iconCls: 'icon-delete',disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'delete',
				handler : function() { me.onDeleteDataButtonDown() }
			};
		var btnSave = {
                xtype: 'uniBaseButton',
				text : me.text.btnSave, 
				tooltip : '저장' + ' [F7]', 
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
				//handler : function(btn, e, eOpts) {
		 		listeners: {
					click: function(btn, e, eOpts) {					
						/*
						var tabPanel = parent.Ext.getCmp('contentTabPanel');
						if(tabPanel) {
							var activeTab = tabPanel.getActiveTab();
							var canClose = activeTab.onClose(activeTab);
							if(canClose)  {
								tabPanel.remove(activeTab);
							}
						} else {
							self.close();
						}
						*/
						
						//fireHanders 에서 event 처리가 timer로 남아 있는 상태에서 iframe 이 닫히면 Ext, doc 등이 사라지기 때문에 delay 를 줌.
						me.delayedCloseButtonDown.delay(500);
					}
				}
			};			
		var btnManual = {
	                xtype: 'uniBaseButton',
					text : me.text.btnManual, tooltip : '도움말', iconCls: 'icon-manual', disabled: true,
					width: btnWidth, height: btnHeight,
			 		itemId : 'manual',
					//handler : function(btn, e, eOpts) {
			 		listeners: {
						click: function(btn, e, eOpts) {					
							
							me.onManualButtonDown();
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
                btnClose,
                btnManual
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
	_onCloseButtonDown: function(btn, e, eOpts) {
		var tabPanel = parent.Ext.getCmp('contentTabPanel');
		if(tabPanel) {
			var activeTab = tabPanel.getActiveTab();
			var tab = activeTab.tab;
			if(tab && tab.closable) {
				var canClose = activeTab.onClose(activeTab);
				if(canClose)  {
					tabPanel.remove(activeTab);
					//tab.onCloseClick();
				}
			}
		} else {
			self.close();
		}
	},
	_clickToolBarButton: function(buttonId) {
		var me = this;
		var btn = me.getTopToolbar().getComponent(buttonId);
        /*if(btn.isVisible() && !btn.isDisabled()) {
        	if(Ext.isFunction(btn.el.dom.click))
        		btn.el.dom.click();
        }*/
		if(btn.isVisible() && !btn.isDisabled()) {
        	if(Ext.isFunction(btn.handler))
        		btn.handler();
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
	isValidSearchForm:function()	{
		var me = this;
		var northForm = me.panelResult ? me.panelResult : me.down('uniSearchForm');
		var westForm = me.panelSearch ? me.panelSearch : me.down('uniSearchPanel');
		
		var formPanel = northForm.isHidden() ? westForm : northForm;
		
		var invalid = formPanel.getForm().getFields().filterBy(function(field) {
															return !field.validate();
														});				   															
		if(invalid.length > 0) {
			r=false;
			var labelText = ''

			if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
				var labelText = invalid.items[0]['fieldLabel']+'은(는)';
			} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
				var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
			}

		   	alert(labelText+Msg.sMB083);
		   	invalid.items[0].focus();
		   	return false;
		} 
		return true;
	},
	setAllFieldsReadOnly:function(b)	{
		var me = this;
		var northForm = me.panelResult ? me.panelResult : me.down('uniSearchForm');
		var westForm = me.panelSearch ? me.panelSearch : me.down('uniSearchPanel');
		var fields1 = Ext.isEmpty(northForm) ? null : northForm.getForm().getFields().items
		var fields2 = Ext.isEmpty(westForm)  ? null : westForm.getForm().getFields().items;
		
		var fields;
		if(fields1 && fields2) {
			fields = fields1.concat(fields2);
		}else if(fields1) {
			fields = fields1;
		}else {
			fields = fields2;
		}
		
		var r= true;
		if(b) {
			var chkForm = northForm.isHidden() ? westForm: northForm
			var invalid = chkForm.getForm().getFields().filterBy(function(field) {
																return !field.validate();
															});				   															
			if(invalid.length > 0) {
				r=false;
				var labelText = ''

				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				}

			   	alert(labelText+Msg.sMB083);
			   	invalid.items[0].focus();
			} else {
				//this.mask();
				
				
				Ext.each(fields, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(true); 
						}
						
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;							
						if(popupFC.holdable == 'hold') {
							popupFC.setReadOnly(true);
						}
						var popupTFC = item.up('uniTreePopupField')	;							
						if(popupTFC && popupTFC.holdable == 'hold') {
							popupTFC.setReadOnly(true);
						}
						
					}
				})
			}
  		} else {
			//this.unmask();
  			
			Ext.each(fields, function(item) {
				if(Ext.isDefined(item.holdable) )	{
				 	if (item.holdable == 'hold') {
						item.setReadOnly(false);
					}
				
				} 
				if(item.isPopupField)	{
					var popupFC = item.up('uniPopupField')	;	
					if(popupFC.holdable == 'hold' ) {
						item.setReadOnly(false);
					}
					var popupTFC = item.up('uniTreePopupField')	;							
					if(popupTFC && popupTFC.holdable == 'hold') {
						popupTFC.setReadOnly(false);
					}
					
				}
			})
		}
		return r;
	},
	getActiveSearchForm:function()	{
		var me = this;
		var northForm = me.panelResult ? me.panelResult : me.down('uniSearchForm');
		var westForm = me.panelSearch ? me.panelSearch : me.down('uniSearchPanel');
		
		return northForm.isHidden() ? westForm : northForm;
	}
	
});


