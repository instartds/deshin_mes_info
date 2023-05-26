//@charset UTF-8
/**
 * ExtJS OmegaPlus 공통 컴포넌트 overrrides
 */
 
Ext.override(Unilite.com.button.BaseButton, {
    style: {
    	padding: '0px',margin: '0px'
    }
});

Ext.override(Unilite.com.grid.UniGridPanel, {
    uniOpt:{
		//column option--------------------------------------------------
		expandLastColumn: true,
		useRowNumberer: true,		//번호 컬럼 사용 여부		
		filter: {
			useFilter: false,		//컬럼 filter 사용 여부
			autoCreate: true		//컬럼 필터 자동 생성 여부
		},
		//toolbar option--------------------------------------------------
		useGroupSummary: false,		//그룹핑 버튼 사용 여부
		useSqlTotal:false, 
		useLiveSearch: false,		//내용검색 버튼 사용 여부		
		state: {
			useState: false,			//그리드 설정 버튼 사용 여부
			useStateList: false		//그리드 설정 목록 사용 여부
		},
		excel: {
			useExcel: true,			//엑셀 다운로드 사용 여부
			exportGroup : false, 		//group 상태로 export 여부
			onlyData:false,
			summaryExport:true
		},
		//grid row&cell option--------------------------------------------
		useContextMenu: false,		//Context 메뉴 자동 생성 여부 
		copiedRow: null	,
		onLoadSelectFirst: true,
		
		
		_selectionRecord: {			//selectionChangeRecord event에서 사용됨
			oldRecordId:'',
			newRecordId:'',
			selected: undefined
		},
		userToolbar :true,
		enterKeyCreateRow:true,
		hasEnterKeyCreateRow:false,
		animatedScroll : false,
		dblClickToEdit	: true,	// true: double click to edit false:keydown to edit
		//FIXME 전페 선택 체크박스 아이콘 --> 삭제 대상
		selectAll:{				// 전체선택 tool 사용여부
			useCheckIcon:false,
			useCustomHandler:false  // onSelectAll event, onDeselectAll event will be fired
		},
		useNavigationModel:true		// enter key Ext.grid.NavigationModel 사용여부
		// 전페 선택 체크박스 아이콘 끝
	}
});

Ext.override(Unilite.com.BaseApp, {
	_setToolBar : function() {
		var me = this;
		var btnWidth = 56;
		var btnHeight = 28;	
		
		var btnQuery =  {
                xtype: 'button',
		 		text : '검색',//me.text.btnQuery,
		 		tooltip : '조회' + ' [F2]',
//		 		iconCls : 'icon-query', 
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
                xtype: 'button',
				text : '초기화',//me.text.btnReset, 
				tooltip : '초기화' + ' [F3]',
//				iconCls: 'icon-reset',
				width: 70, height: btnHeight,
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
                xtype: 'button',
				text : '추가',//me.text.btnNewData,
				tooltip : '추가' + ' [F4]',
//				iconCls: 'icon-new',
				disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'newData',
				handler : function() { me.onNewDataButtonDown() }
			};
		var btnDelete = {
                xtype: 'button',
				text : '삭제',//me.text.btnDelete,
				tooltip : '삭제' + ' [F6]',
//				iconCls: 'icon-delete',
				disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'delete',
				handler : function() { me.onDeleteDataButtonDown() }
			};
		var btnSave = {
                xtype: 'button',
				text : '저장',//me.text.btnSave, 
				tooltip : '저장' + ' [F7]', 
//				iconCls: 'icon-save',
				disabled: true,
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
                xtype: 'button',
				text : '이전',//me.text.btnPrev, 
				tooltip : '이전 레코드', 
//				iconCls: 'icon-movePrev',
				disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'prev',
				handler : function() { me.onPrevDataButtonDown() }
			};
		var btnNext = {
                xtype: 'button',
				text : '다음',//me.text.btnNext, 
				tooltip : '다음 레코드', 
//				iconCls: 'icon-moveNext',
				disabled: true,
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
                xtype: 'button',
				text : '출력',//me.text.btnDetail, 
				tooltip : '인쇄', 
//				iconCls: 'icon-print', 
				disabled: true,
				width: btnWidth, height: btnHeight,
		 		itemId : 'print',
				handler : function() { me.onPrintButtonDown() }
			};				
			
			
		var btnClose = {
                xtype: 'button',
				text : '닫기',//me.text.btnClose, 
				tooltip : '닫기', 
//				iconCls: 'icon-close', 
				disabled: false,
				width: btnWidth, height: btnHeight,
		 		itemId : 'close',
				//handler : function(btn, e, eOpts) {
		 		listeners: {
					click: function(btn, e, eOpts) {					
						
						
						//fireHanders 에서 event 처리가 timer로 남아 있는 상태에서 iframe 이 닫히면 Ext, doc 등이 사라지기 때문에 delay 를 줌.
						me.delayedCloseButtonDown.delay(500);
					}
				}
			};			
		var btnManual = {
	                xtype: 'button',
					text : '도움말',//me.text.btnManual, 
					tooltip : '도움말', 
//					iconCls: 'icon-manual', 
					disabled: true,
					width: btnWidth, height: btnHeight,
			 		itemId : 'manual',
			 		listeners: {
						click: function(btn, e, eOpts) {					
							
							me.onManualButtonDown();
						}
					}
				};	
			
		
        var toolbarItems = [ btnQuery, btnReset, 
                btnNewData, btnDelete,
                btnSave,// btnDeleteAll, //btnExcel,
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
	}
});