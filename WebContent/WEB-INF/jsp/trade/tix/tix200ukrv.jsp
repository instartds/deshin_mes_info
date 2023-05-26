<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tix200ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="T104" /> <!-- 수입구분 -->
	<t:ExtComboStore comboType="AU" comboCode="T105" /> <!-- 배부여부 -->
	<t:ExtComboStore comboType="BOR120"  />			 <!-- 사업장 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('tix200ukrvModel', {
		fields: [
			{name: 'OPR_FLAG'			, text: 'OPR_FLAG'			, type: 'string'},
			{name: 'TRADE_LOC'			, text: '수입구분'				, type: 'string', comboType: "AU", comboCode: "T104"},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.trade.division" default="사업장"/>'			, type: 'string'},
			{name: 'INOUT_DATE'			, text: '입고일'				, type: 'uniDate'},
			{name: 'INOUT_NUM'			, text: '입고번호'				, type: 'string'},
			{name: 'INOUT_SEQ'			, text: '입고순번'				, type: 'string'},
			{name: 'GUBUN'				, text: 'GUBUN'				, type: 'string'},
			{name: 'EXPENSE_FLAG'		, text: '배부여부'				, type: 'string', comboType: "AU", comboCode: "T105"},
			{name: 'WH_CODE'			, text: '창고'				, type: 'string'},
			{name: 'BASIS_NUM'			, text: '통관(LOCAL번호)'		, type: 'string'},
			{name: 'BASIS_SEQ'			, text: '순번'				, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '거래처코드'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처명'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.trade.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.trade.itemname2" default="품명 "/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.trade.spec" default="규격"/>'				, type: 'string'},
			{name: 'INOUT_Q'			, text: '입고량'				, type: 'uniQty'},
			{name: 'MONEY_UNIT'			, text: '입고화폐'				, type: 'string'},
			{name: 'INOUT_FOR_P'		, text: '입고외화단가'			, type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O'		, text: '입고외화금액'			, type: 'uniFC'},
			{name: 'INOUT_P'			, text: '입고원화단가'			, type: 'uniUnitPrice'},
			{name: 'INOUT_I'			, text: '입고원화금액'			, type: 'uniPrice'},
			{name: 'TOT_AMT'			, text: '총금액'				, type: 'uniPrice'},
			{name: 'TRNS_RATE'			, text: '변환계수'				, type: 'float', format: '0,000.000000', decimalPrecision: 6},
			{name: 'TOTAL_EXP'			, text: '경비금액계'				, type: 'uniPrice'},
			{name: 'OFFER_EXP'			, text: 'OFFER경비'			, type: 'uniPrice'},
			{name: 'MLC_EXP'			, text: 'LC경비'				, type: 'uniPrice'},
			{name: 'LLC_EXP'			, text: 'LOCAL LC경비'		, type: 'uniPrice'},
			{name: 'BL_EXP'				, text: '선적경비'				, type: 'uniPrice'},
			{name: 'PASS_EXP'			, text: '통관경비'				, type: 'uniPrice'},
			{name: 'NEGO_EXP'			, text: '대금경비'				, type: 'uniPrice'},
			{name: 'OFFER_NUM'			, text: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>'	, type: 'string'},
			{name: 'MLC_NUM'			, text: 'LC관리번호'			, type: 'string'},
			{name: 'LC_NO'				, text: 'L/C번호'				, type: 'string'},
			{name: 'LLC_NUM'			, text: 'LOCAL LC관리번호'		, type: 'string'},
			{name: 'LLC_NO'				, text: 'LOCAL L/C번호'		, type: 'string'},
			{name: 'BL_NUM'				, text: '선적관리번호'			, type: 'string'},
			{name: 'BL_NO'				, text: 'BL번호'				, type: 'string'},
			{name: 'PASS_NUM'			, text: '통관관리번호'			, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: '수정자'				, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '수정일'				, type: 'uniDate'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.trade.companycode" default="법인코드"/>'			, type: 'string'},
			{name: 'INOUT_TYPE'			, text: 'INOUT_TYPE'		, type: 'string'},
			{name: 'INOUT_METH'			, text: 'INOUT_METH'		, type: 'string'},
			{name: 'CREATE_LOC'			, text: 'CREATE_LOC'		, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	, text: 'INOUT_TYPE_DETAIL'	, type: 'string'},
			{name: 'INOUT_CODE_TYPE'	, text: 'INOUT_CODE_TYPE'	, type: 'string'},
			{name: 'INOUT_CODE'			, text: 'INOUT_CODE'		, type: 'string'},
			{name: 'ITEM_STATUS'		, text: 'ITEM_STATUS'		, type: 'string'},
			{name: 'BILL_TYPE'			, text: 'BILL_TYPE'			, type: 'string'},
			{name: 'SALE_TYPE'			, text: 'SALE_TYPE'			, type: 'string'},
			{name: 'SALE_DIV_CODE'		, text: 'SALE_DIV_CODE'		, type: 'string'},
			{name: 'SALE_CUSTOM_CODE'	, text: 'SALE_CUSTOM_CODE'	, type: 'string'},
			{name: 'EX_DATE'			, text: '결의전표일'				, type: 'uniDate'},
			{name: 'EX_NUM'				, text: '결의전표순번'			, type: 'string'}
		]
	});//End of Unilite.defineModel('tix200ukrvModel', {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'tix200ukrvService.selectList',
			update	: 'tix200ukrvService.updateDetail',
			syncAll	: 'tix200ukrvService.saveAll'
		}
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('tix200ukrvMasterStore1', {
		model	: 'tix200ukrvModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		saveStore: function()  {
			var paramMaster = panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 ) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						directMasterStore1.loadStoreRecords();
						Ext.getCmp('onExcuteBtn').setDisabled(false);
						Ext.getCmp('onCancelBtn').setDisabled(false);
					} 
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params: param
			});
		}

	});//End of var directMasterStore1 = Unilite.createStore('tix200ukrvMasterStore1', {

	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.trade.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{   
			title: '<t:message code="system.label.trade.basisinfo" default="기본정보"/>',  
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>'  ,
				name: 'DIV_CODE',   
				xtype:'uniCombobox', 
				comboType:'BOR120', 
				value:UserInfo.divCode, 
				allowBlank:false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);   
					}
				}
			}, {
				fieldLabel: '입고일',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				width: 350,
				allowBlank: false,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),				  
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_DATE_FR', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_DATE_TO', newValue);
					}
				}
			}, {
				fieldLabel: '배부여부'	   ,
				name: 'EXPENSE_FLAG', 
				xtype:'uniCombobox',
				comboType:'AU', 
				comboCode:'T105',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('EXPENSE_FLAG', newValue);
					}
				}			
			}, {
				fieldLabel: '수입구분'	   ,
				name: 'TRADE_LOC', 
				xtype:'uniCombobox',
				comboType:'AU', 
				comboCode:'T104',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('TRADE_LOC', newValue);
					}
				}			
			},
			//20200123 추가: 조회조건 거래처 팝업 추가
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.trade.custom" default="거래처"/>',
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange:function( elm, newValue, oldValue) {						
						panelResult.setValue('CUSTOM_CODE', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_NAME', '');
							panelSearch.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange:function( elm, newValue, oldValue) {
						panelResult.setValue('CUSTOM_NAME', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_CODE', '');
							panelSearch.setValue('CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER': ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE': ['1','2']});
					}
				}
			})]
		}]
	}); //end panelSearch  

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 4, tableAttrs: {width: '95%'}},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>'  ,
			name: 'DIV_CODE',   
			xtype:'uniCombobox', 
			comboType:'BOR120', 
			value:UserInfo.divCode, 
			allowBlank:false,
			tdAttrs: {width: 300},
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);   
				}
			}
		}, {
			fieldLabel: '입고일',
			xtype: 'uniDateRangefield',
			startFieldName: 'INOUT_DATE_FR',
			endFieldName: 'INOUT_DATE_TO',
			width: 350,
			allowBlank: false,
			tdAttrs: {width: 300},
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),				  
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_FR', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_TO', newValue);
				}
			}
		}, {
			fieldLabel: '배부여부'	   ,
			name: 'EXPENSE_FLAG', 
			xtype:'uniCombobox',
			comboType:'AU', 
			comboCode:'T105',
			tdAttrs: {width: 300},
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('EXPENSE_FLAG', newValue);
				}
			}
		},{
		   width: 120,
		   xtype: 'button',
		   text: '미착대체자동기표',	
		   tdAttrs: {align: 'right'},
		   handler : function() {
				var params = {
					action:'select',
					'PGM_ID'			 :  'tix200ukrv',		
					'DIV_CODE'		   :   panelSearch.getValue('DIV_CODE'),					//사업장
					'INOUT_DATE_FR'	  :   panelSearch.getValue('INOUT_DATE_FR'),			   //입고일
					'INOUT_DATE_TO'	  :   panelSearch.getValue('INOUT_DATE_TO')				
				}
				var rec = {data : {prgID : 'agd250ukr', 'text':''}};
				parent.openTab(rec, '/accnt/agd250ukr.do', params, CHOST+CPATH);
		   }
		}, {
			fieldLabel: '수입구분'	   ,
			name: 'TRADE_LOC', 
			xtype:'uniCombobox',
			comboType:'AU', 
			comboCode:'T104',
			tdAttrs: {width: 300},
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('TRADE_LOC', newValue);
				}
			}			
		},
		//20200123 추가: 조회조건 거래처 팝업 추가
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.trade.custom" default="거래처"/>',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelSearch.setValue('CUSTOM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_NAME', '');
								panelSearch.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('CUSTOM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_CODE', '');
								panelSearch.setValue('CUSTOM_CODE', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER': ['1','2']});
							popup.setExtParam({'CUSTOM_TYPE': ['1','2']});
						}
			}
		}),{
			xtype: 'container',
			margin: '0 0 2 94',
			tdAttrs: {align: 'left'},
			layout: {type: 'uniTable', columns: 2},
			items:[{
			   width: 100,
			   xtype: 'button',
			   id: 'onExcuteBtn',
			   text: '배부',
			   handler : function() {
				   directMasterStore1.saveStore();
			   }
			},{
			   width: 100,
			   xtype: 'button',
			   id: 'onCancelBtn',
			   text: '배부취소',	
			   margin: '0 0 0 10',
			   handler : function() {
					//20200214 기표여부 체크로직 추가
					var records	= masterGrid.getSelectedRecords();
					if(records.length == 0) {
						Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
						return false;
					}
					var exFlag	= false;
					Ext.each(records, function(record, i){
						if(Ext.isDate(record.get('EX_DATE')) && !Ext.isEmpty(record.get('EX_NUM'))) {
							exFlag = true;
						}
					});
					if(exFlag) {
						Unilite.messageBox('자동기표된 부대비는 취소할 수 없습니다. 자동기표를 취소해주세요.');
						return false;
					}
				   directMasterStore1.saveStore();
			   }
			}]
		}] 
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('tix200ukrvGrid1', {
		store: directMasterStore1,
		layout: 'fit',
		region: 'center',
		uniOpt: {
//		  useRowNumberer: true
//		  copiedRow: true
//		  useContextMenu: true,
			onLoadSelectFirst: false
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false 
		},{
			id: 'masterGridTotal',  
			ftype: 'uniSummary',	  
			showSummaryRow: false
		}],
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if(selectRecord.get('EXPENSE_FLAG') == "Y"){   //배부일시 OPR_FLAG를 D로 
					   selectRecord.set('OPR_FLAG', "D");
					}else{ //미배부일시 OPR_FLAG를 N으로 
					   selectRecord.set('OPR_FLAG', "N");
					}
					
					var records = masterGrid.getSelectedRecords();
					var isErr = false;
					Ext.each(records, function(record1, i){
					   Ext.each(records, function(record1_1, i){
							if(record1.get('EXPENSE_FLAG') != record1_1.get('EXPENSE_FLAG')){
								alert('배부 또는 미배부 한가지 작업만 가능합니다.');
								Ext.getCmp('onExcuteBtn').setDisabled(true);
								Ext.getCmp('onCancelBtn').setDisabled(true);
								isErr = true;
								return false;
							}
						});
						if(isErr) return false;
					});
					if(isErr) return false;
					Ext.each(records, function(record, i){
					   if(record.get('EXPENSE_FLAG') == "N"){  //배부 대상 레코드일시
						   Ext.getCmp('onExcuteBtn').setDisabled(false);
						   Ext.getCmp('onCancelBtn').setDisabled(true);
					   }else{  //미배부 대상 레코드일시
						   Ext.getCmp('onExcuteBtn').setDisabled(true);
						   Ext.getCmp('onCancelBtn').setDisabled(false);
					   }
					});
					
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					selectRecord.set('OPR_FLAG', "");
					var records = masterGrid.getSelectedRecords();
					if(records.length == 0){
						Ext.getCmp('onExcuteBtn').setDisabled(false);
						Ext.getCmp('onCancelBtn').setDisabled(false);
						return false;
					}else{
						Ext.each(records, function(record, i){
						   if(record.get('EXPENSE_FLAG') == "N"){  //배부 대상 레코드일시
							   Ext.getCmp('onExcuteBtn').setDisabled(false);
							   Ext.getCmp('onCancelBtn').setDisabled(true);
						   }else{  //미배부 대상 레코드일시
							   Ext.getCmp('onExcuteBtn').setDisabled(true);
							   Ext.getCmp('onCancelBtn').setDisabled(false);
						   }
						});
					}
				}
			}
		}),
		columns: [ 
			{dataIndex: 'OPR_FLAG'				, width: 100, hidden: true},
			{dataIndex: 'TRADE_LOC'				, width: 100},
			{dataIndex: 'DIV_CODE'				, width: 100, hidden: true},
			{dataIndex: 'INOUT_DATE'			, width: 90 },
			{dataIndex: 'INOUT_NUM'				, width: 120},
			{dataIndex: 'INOUT_SEQ'				, width: 80 , align: 'center'},
			{dataIndex: 'GUBUN'					, width: 100, hidden: true},
			{dataIndex: 'EXPENSE_FLAG'			, width: 80 , align: 'center'},
			{dataIndex: 'WH_CODE'				, width: 100, hidden: true},
			{dataIndex: 'BASIS_NUM'				, width: 100, hidden: true},
			{dataIndex: 'BASIS_SEQ'				, width: 100, hidden: true},
			{dataIndex: 'CUSTOM_CODE'			, width: 100},
			{dataIndex: 'CUSTOM_NAME'			, width: 140},
			{dataIndex: 'ITEM_CODE'				, width: 100},
			{dataIndex: 'ITEM_NAME'				, width: 140},
			{dataIndex: 'SPEC'					, width: 140},
			{dataIndex: 'INOUT_Q'				, width: 100},
			{dataIndex: 'MONEY_UNIT'			, width: 80 , align: 'center'},
			{dataIndex: 'INOUT_FOR_P'			, width: 100},
			{dataIndex: 'INOUT_FOR_O'			, width: 100},
			{dataIndex: 'INOUT_P'				, width: 100},
			{dataIndex: 'INOUT_I'				, width: 100},
			{dataIndex: 'TOT_AMT'				, width: 100},
			{dataIndex: 'TRNS_RATE'				, width: 100},
			{dataIndex: 'TOTAL_EXP'				, width: 100},
			{dataIndex: 'OFFER_EXP'				, width: 100},
			{dataIndex: 'MLC_EXP'				, width: 100},
			{dataIndex: 'LLC_EXP'				, width: 130},
			{dataIndex: 'BL_EXP'				, width: 100},
			{dataIndex: 'PASS_EXP'				, width: 100},
			{dataIndex: 'NEGO_EXP'				, width: 100},
			{dataIndex: 'OFFER_NUM'				, width: 120},
			{dataIndex: 'MLC_NUM'				, width: 100, hidden: true},
			{dataIndex: 'LC_NO'					, width: 120},
			{dataIndex: 'LLC_NUM'				, width: 100, hidden: true},
			{dataIndex: 'LLC_NO'				, width: 120},
			{dataIndex: 'BL_NUM'				, width: 100, hidden: true},
			{dataIndex: 'BL_NO'					, width: 120},
			{dataIndex: 'PASS_NUM'				, width: 120},
			{dataIndex: 'UPDATE_DB_USER'		, width: 100, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 100, hidden: true},
			{dataIndex: 'COMP_CODE'				, width: 100, hidden: true},
			{dataIndex: 'INOUT_TYPE'			, width: 100, hidden: true},
			{dataIndex: 'INOUT_METH'			, width: 100, hidden: true},
			{dataIndex: 'CREATE_LOC'			, width: 100, hidden: true},
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width: 100, hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'		, width: 100, hidden: true},
			{dataIndex: 'INOUT_CODE'			, width: 100, hidden: true},
			{dataIndex: 'ITEM_STATUS'			, width: 100, hidden: true},
			{dataIndex: 'BILL_TYPE'				, width: 100, hidden: true},
			{dataIndex: 'SALE_TYPE'				, width: 100, hidden: true},
			{dataIndex: 'SALE_DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'SALE_CUSTOM_CODE'		, width: 100, hidden: true},
			{dataIndex: 'EX_DATE'				, width: 90 },
			{dataIndex: 'EX_NUM'				, width: 100, align: 'center'}
		],
		listeners: {
			beforeedit: function(editor, e) {
			},
			edit: function(editor, e) {
				if (e.originalValue != e.value) {
//					UniAppManager.setToolbarButtons('save', true);
				}
			},
			selectionchange: function(grid, selNodes ){
//				UniAppManager.setToolbarButtons('delete', true);
			}
		}
	});//End of var masterGrid = Unilite.createGrid('tix200ukrvGrid1', {

	Unilite.Main({
		id			: 'tix200ukrvApp',
		border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('INOUT_DATE_TO')));
			UniAppManager.setToolbarButtons('reset', false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)  {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			Ext.getCmp('onExcuteBtn').setDisabled(false);
			Ext.getCmp('onCancelBtn').setDisabled(false);
		},
		onDeleteDataButtonDown : function() {
			/*  if(masterGrid.getStore().isDirty()) {
			masterGrid.getStore().saveStore();
		} */
		var selRow = masterGrid.getSelectionModel().getSelection()[0];
		if(selRow.get('FLAG') == 'N')   {
			masterGrid.deleteSelectedRow();
		}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
			masterGrid.deleteSelectedRow();
//			  detailForm.clearForm();	 //넣으면 폼 깨짐
		}
//	  if(selRow.phantom === true) {
//		  masterGrid.deleteSelectedRow();
//	  }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
//		  if(selRow.data.FLAG == 'N') {
//			  alert('년월차기초자료가 없습니다 삭제불가능합니다.');
//		  }else{
//			  masterGrid.deleteSelectedRow();
//		  }
//	  }
		// fnOrderAmtSum 호출(grid summary 이용)
		},
		onSaveDataButtonDown: function() {
			if(masterGrid.getStore().isDirty()) {
				masterGrid.getStore().saveStore();
			}
		},
		onDeleteAllButtonDown : function() {
			/* Ext.Msg.confirm('삭제', '전체행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
				if (btn == 'yes') {
					directMasterStore1.removeAll();
					masterGrid.getStore().sync({
							success: function(response) {
								masterGrid.getView().refresh();
							},
							failure: function(response) {
								masterGrid.getView().refresh();
							}
					});
				}
			}); */
		}
	});//End of Unilite.Main( {
};
</script>