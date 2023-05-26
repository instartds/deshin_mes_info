<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tex200ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120" comboCode="BILL"/>			<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A020"/>				<!-- 사용여부-->
	<t:ExtComboStore comboType="AU" comboCode="T070" opts='B;S'/>	<!-- 진행구분-->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>				<!-- 화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="T072"/>				<!-- 지급유형-->
	<t:ExtComboStore comboType="AU" comboCode="A022"/>				<!-- 증빙유형-->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('tex200ukrvModel', {
		fields: [  	  
			{name: 'CHARGE_TYPE'		, text: '<t:message code="system.label.trade.processtype" default="진행구분"/>'		,type: 'string', comboType: "AU", comboCode: "T070"},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'	,type: 'string'},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'	,type: 'string'},
			{name: 'IMPORTER'			, text: '<t:message code="system.label.trade.importer" default="수입자"/>'			,type: 'string'},
			{name: 'IMPORTER_NM'		, text: '<t:message code="system.label.trade.importername" default="수입자명"/>'	,type: 'string'},
			{name: 'BASIC_PAPER_NO'		, text: '<t:message code="system.label.trade.basisno" default="근거번호"/>'			,type: 'string'},
			{name: 'SALE_DATE'			, text: '<t:message code="system.label.trade.basisdate" default="기준일"/>'		,type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.trade.projectno" default="프로젝트번호"/>'		,type: 'string'},
			{name: 'LC_NO'				, text: 'LC_NO'		,type: 'string'},
			{name: 'BL_NO'				, text: 'BL_NO'		,type: 'string'}
		]
	});

	Unilite.defineModel('tex200ukrvModel2', {
		fields: [
			{name: 'TRADE_DIV'			, text: '<t:message code="system.label.trade.tradeclass" default="무역구분"/>'				,type: 'string'},
			{name: 'CHARGE_TYPE'		, text: '<t:message code="system.label.trade.processtype" default="진행구분"/>'				,type: 'string'},
			{name: 'CHARGE_SER'			, text: '<t:message code="system.label.trade.seq" default="순번"/>'						,type: 'int', allowBlank:false},
			{name: 'BASIC_PAPER_NO'		, text: '<t:message code="system.label.trade.basisno" default="근거번호"/>'					,type: 'string'},
			{name: 'TRADE_CUSTOM_CODE'	, text: '<t:message code="system.label.trade.importer" default="수입자"/>'					,type: 'string'},
			{name: 'TRADE_CUSTOM_NAME'	, text: '<t:message code="system.label.trade.importername" default="수입자명"/>'			,type: 'string'},
			{name: 'CHARGE_CODE'		, text: '<t:message code="system.label.trade.expensecode" default="경비코드"/>'				,type: 'string', allowBlank:false},
			{name: 'CHARGE_NAME'		, text: '<t:message code="system.label.trade.expensename" default="경비명"/>'				,type: 'string', allowBlank:false},
			{name: 'CUST_CODE'			, text: '<t:message code="system.label.trade.suppcode" default="지급처"/>'					,type: 'string', allowBlank:false},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.trade.suppname" default="지급처명"/>'				,type: 'string', allowBlank:false},
			{name: 'VAT_CUSTOM'			, text: '<t:message code="system.label.trade.supplycustom" default="공급처"/>'				,type: 'string'},
			{name: 'VAT_CUSTOM_NAME'	, text: '<t:message code="system.label.trade.supplycustomname" default="공급처명"/>'		,type: 'string'},
			{name: 'OCCUR_DATE'			, text: '<t:message code="system.label.trade.occurdate" default="발생일자"/>'				,type: 'uniDate', allowBlank:false},
			{name: 'CHARGE_AMT'			, text: '<t:message code="system.label.trade.foreigncurrencyamount" default="외화금액"/>'	,type: 'uniFC', allowBlank:false},
			{name: 'AMT_UNIT'			, text: '<t:message code="system.label.trade.currencyunit" default="화폐단위"/>'			,type: 'string', comboType:"AU", comboCode: "B004", displayField: 'value', allowBlank:false},
			{name: 'EXCHANGE_RATE'		, text: '<t:message code="system.label.trade.exchangerate" default="환율"/>'				,type: 'uniER', allowBlank:false},
			{name: 'CHARGE_AMT_WON'		, text: '<t:message code="system.label.trade.localamount" default="원화금액"/>'				,type: 'uniPrice', allowBlank:false},
			{name: 'SUPPLY_AMT'			, text: '<t:message code="system.label.trade.supplyamount" default="공급가액"/>'			,type: 'uniPrice', allowBlank:false},
			{name: 'TAX_CLS'			, text: '<t:message code="system.label.trade.prooftype" default="증빙유형"/>'				,type: 'string', comboType:"AU", comboCode: "A022"},
			{name: 'VAT_AMT'			, text: '<t:message code="system.label.trade.vatamount" default="부가세액"/>'				,type: 'uniPrice'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.trade.division" default="사업장"/>'					,type: 'string', comboType: "BOR120"},
			{name: 'VAT_COMP_CODE'		, text: '<t:message code="system.label.trade.declaredivisioncode" default="신고사업장"/>'	,type: 'string', comboType: "BOR120", comboCode: 'BILL', allowBlank:false},
			{name: 'PAY_TYPE'			, text: '<t:message code="system.label.trade.supptype" default="지급유형"/>'				,type: 'string', comboType:"AU", comboCode: "T072", allowBlank:false},
			{name: 'NOTE_NUM'			, text: '<t:message code="system.label.trade.noteno" default="어음번호"/>'					,type: 'string'},
			{name: 'SAVE_CODE'			, text: '<t:message code="system.label.trade.bankbookcode" default="통장코드"/>'			,type: 'string'},
			{name: 'SAVE_NAME'			, text: '<t:message code="system.label.trade.bankbook" default="통장명"/>'					,type: 'string'},
			{name: 'BANK_CODE'			, text: '<t:message code="system.label.trade.bankcode" default="은행코드"/>'				,type: 'string'},
			{name: 'BANK_NAME'			, text: '<t:message code="system.label.trade.bankname" default="은행명"/>'					,type: 'string'},
			{name: 'EXP_DATE'			, text: '<t:message code="system.label.trade.duedate" default="만기일"/>'					,type: 'uniDate'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.trade.projectno" default="프로젝트번호"/>'				,type: 'string'},
			{name: 'PAY_DATE'			, text: '<t:message code="system.label.trade.paymentplandate" default="지급예정일"/>'		,type: 'uniDate'},
			{name: 'REMARKS'			, text: '<t:message code="system.label.trade.remark" default="적요"/>'					,type: 'string'},
			{name: 'OFFER_SER_NO'		, text: '<t:message code="system.label.trade.offerno" default="OFFER 번호 "/>'				,type: 'string'},
			{name: 'LC_SER_NO'			, text: '<t:message code="system.label.trade.lcmanageno" default="L/C관리번호"/>'			,type: 'string'},
			{name: 'LC_NO'				, text: '<t:message code="system.label.trade.lcno" default="L/C번호"/>'					,type: 'string'},
			{name: 'BL_SER_NO'			, text: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>'			,type: 'string'},
			{name: 'BL_NO'				, text: '<t:message code="system.label.trade.blno" default="B/L번호"/>'					,type: 'string'},
			{name: 'COST_DIV'			, text: '<t:message code="system.label.trade.costdiv" default="배부대상"/>'					,type: 'string'},
			{name: 'EX_DATE'			, text: '<t:message code="system.label.trade.exdate" default="결의일"/>'					,type: 'uniDate'},
			{name: 'EX_NUM'				, text: '<t:message code="system.label.trade.exnum" default="결의번호"/>'					,type: 'string'},
			{name: 'AGREE_YN'			, text: '<t:message code="system.label.trade.agreeyn" default="승인여부"/>'					,type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER',type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME',type: 'string'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		,type: 'string'},
			{name: 'GUBUN'				, text: 'GUBUN'			,type: 'string'}
		]
	});

	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'tex200ukrvService.selectMasterList',
			update	: 'tex200ukrvService.updateMaster',
//			create	: 'tex200ukrvService.insertMaster',
//			destroy	: 'tex200ukrvService.deleteMaster',
			syncAll	: 'tex200ukrvService.saveAll'
		}
	});

	var directDetailProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'tex200ukrvService.selectDetailList',
			update	: 'tex200ukrvService.updateDetail',
			create	: 'tex200ukrvService.insertDetail',
			destroy	: 'tex200ukrvService.deleteDetail',
			syncAll	: 'tex200ukrvService.saveAll'
		}
	});  

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('tex200ukrvMasterStore1',{
		proxy	: directMasterProxy,
		model	: 'tex200ukrvModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log( param );
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {
//						UniAppManager.setToolbarButtons('newData', false);
					}
				}
			});
		},
//		saveStore : function() {
//			var inValidRecs = this.getInvalidRecords();
//			if(inValidRecs.length == 0 ) {
//				var config = {
//					params:[panelResult.getValues()],
//					success : function() {
//						if(directDetailStore.isDirty()) {
//							directDetailStore.saveStore();
//						}
//					}
//				}
//				this.syncAllDirect(config);
//			}else {
//				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
//			}
//		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				if(records != null && records.length > 0 ){
					UniAppManager.setToolbarButtons('delete', true);
				}
			}
//			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
//				UniAppManager.setToolbarButtons('save', true);
//			},
//			datachanged : function(store,  eOpts) {
//				if( directDetailStore.isDirty() || store.isDirty()) {
//					UniAppManager.setToolbarButtons('save', true);
//				}else {
//					UniAppManager.setToolbarButtons('save', false);
//				}
//			}
		}
	});

	var directDetailStore = Unilite.createStore('tex200ukrvMasterStore2',{
		proxy	: directDetailProxy,
		model	: 'tex200ukrvModel2',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(record) {
			var params = {
				'DIV_CODE'		: record.get('DIV_CODE'),
				'CHARGE_TYPE'	: record.get('CHARGE_TYPE'),
				'BASIC_PAPER_NO': record.get('BASIC_PAPER_NO'),
				'AMT_UNIT'		: UserInfo.currency
			};	
			this.load({
				params : params,
				callback : function(records,options,success) {
					if(success) {
						UniAppManager.setToolbarButtons('delete', false);
					}
				}
			});
		},
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
		
			if(inValidRecs.length == 0 ) {
				var config = {
					params:[panelResult.getValues()],
					success : function() {}
				}
				this.syncAllDirect(config);	
			}else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
			
		},
		fnOrderAmtSum: function() {
			var chargeAmt	= 0;
			var vatAmt		= 0;
			var results		= this.sumBy(function(record, id){
										return true;}, 
									['CHARGE_AMT_WON','VAT_AMT']);
			chargeAmt		= results.CHARGE_AMT_WON;
			vatAmt			= results.VAT_AMT;

			panelSummary.setValue('CHARGE_AMT_WON',chargeAmt);		//원화합계
			panelSummary.setValue('VAT_AMT',vatAmt);				//부가세합계
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				this.fnOrderAmtSum();
			},
			add: function(store, records, index, eOpts) {
				this.fnOrderAmtSum();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				this.fnOrderAmtSum();
			},
			remove: function(store, record, index, isMove, eOpts) {
				this.fnOrderAmtSum();
			}
		}
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {	 
		title		: '<t:message code="system.label.trade.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items		: [{
			title		: '<t:message code="system.label.trade.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel		: '<t:message code="system.label.trade.basisdate" default="기준일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_DATE',
				endFieldName	: 'TO_DATE',
				width			: 350,
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('FR_DATE', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('TO_DATE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.trade.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue); 
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.trade.processtype" default="진행구분"/>',
				name		: 'CHARGE_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'T070',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('CHARGE_TYPE', newValue); 
					}
				}
			},{
				xtype		: 'uniTextfield',
				name		: 'BASIC_PAPER_NO',
				fieldLabel	: '<t:message code="system.label.trade.basisno" default="근거번호"/>',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('BASIC_PAPER_NO', newValue); 
					}
				}
			},
			Unilite.popup('CUST',{
				fieldLabel		: '<t:message code="system.label.trade.importernmaircomp" default="선박/항공사"/>',
				validateBlank	: false, 
				valueFieldName	: 'IMPORTER',
				textFieldName	: 'IMPORTER_NM',
				listeners		: {
					onValueFieldChange:function( elm, newValue, oldValue) {						
						panelResult.setValue('IMPORTER', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('IMPORTER_NM', '');
							panelSearch.setValue('IMPORTER_NM', '');
						}
					},
					onTextFieldChange:function( elm, newValue, oldValue) {
						panelResult.setValue('IMPORTER_NM', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('IMPORTER', '');
							panelSearch.setValue('IMPORTER', '');
						}
					}					
				}
			})]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3, tableAttrs: {width: '99.5%'}},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel		: '<t:message code="system.label.trade.basisdate" default="기준일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			tdAttrs			: {width: 400},
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FR_DATE', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TO_DATE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.trade.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			tdAttrs		: {width: 300},
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue); 
				}
			}
		},{
			width	: 100,
			xtype	: 'button',
			text	: '<t:message code="system.label.trade.expenseautoslipyn" default="경비자동기표"/>',
			tdAttrs	: {align: 'right'},
			margin	: '0 0 2 0',
			handler	: function() {

				var selectedRecord = detailGrid.getSelectedRecord();
				var chkParam = {
					'FRORDERDATE'	: UniDate.getDbDateStr(panelResult.getValue("FR_DATE")),
					'TOORDERDATE'	: UniDate.getDbDateStr(panelResult.getValue("TO_DATE")),
					'DIV_CODE'		: selectedRecord.get("DIV_CODE"),
					'CHARGE_TYPE'	: selectedRecord.get("CHARGE_TYPE"),
					'CHARGE_SER'	: selectedRecord.get("CHARGE_SER"),
					'TRADE_DIV'		: selectedRecord.get("TRADE_DIV")
				}
				tix100ukrvService.selectList(chkParam, function(responseText){
					if(responseText && responseText.length > 0)	{
						var rtnRecord = responseText[0]
						if(!Ext.isEmpty(rtnRecord.EX_DATE) &&  !Ext.isEmpty(rtnRecord.EX_NUM) && rtnRecord.EX_DATE != 0 )	{
							Unilite.messageBox('<t:message code="system.message.trade.message004" default="이미 전표가 등록되었습니다."/>');
							return;
						}
					}
					
					if(detailGrid.store.getCount() > 0 && selectedRecord){
						var params = {
								"PGM_ID": 'tex200ukrv',
								'sGubun' : '63',
								"TRADE_DIVI":selectedRecord.get("TRADE_DIV"),
								"FR_ORDER_DATE":UniDate.getDbDateStr(panelResult.getValue("FR_DATE")),
								"TO_ORDER_DATE":UniDate.getDbDateStr(panelResult.getValue("TO_DATE")),
								"DIV_CODE"  :panelResult.getValue("DIV_CODE"),
								"CHARGE_TYPE":selectedRecord.get("CHARGE_TYPE"),
								"CHARGE_SER":selectedRecord.get("CHARGE_SER")
							}
						
						setTimeout(function(){
							var rec1 = {data : {prgID : 'agj260ukr', 'text':''}};
							parent.openTab(rec1, '/accnt/agj260ukr.do', params);
						}
						, 500
						)
					}
				});
			}
		},{
			fieldLabel	: '<t:message code="system.label.trade.processtype" default="진행구분"/>',
			name		: 'CHARGE_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T070',
			tdAttrs		: {width: 300},
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('CHARGE_TYPE', newValue); 
				}
			}
		},{
			xtype		: 'uniTextfield',
			name		: 'BASIC_PAPER_NO',
			fieldLabel	: '<t:message code="system.label.trade.basisno" default="근거번호"/>',
			tdAttrs		: {width: 300},
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('BASIC_PAPER_NO', newValue); 
				}
			}
		},
		Unilite.popup('CUST',{
			fieldLabel		: '<t:message code="system.label.trade.importernmaircomp" default="선박/항공사"/>',
			validateBlank	: false, 
			valueFieldName	: 'IMPORTER',
			textFieldName	: 'IMPORTER_NM',
			listeners		: {
					onValueFieldChange:function( elm, newValue, oldValue) {						
						panelSearch.setValue('IMPORTER', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('IMPORTER_NM', '');
							panelSearch.setValue('IMPORTER_NM', '');
						}
					},
					onTextFieldChange:function( elm, newValue, oldValue) {
						panelSearch.setValue('IMPORTER_NM', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('IMPORTER', '');
							panelSearch.setValue('IMPORTER', '');
						}
					}
			}
		})]	
	});

	var panelSummary = Unilite.createSearchForm('summaryForm',{
		region	: 'south',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			xtype		: 'uniNumberfield',
			name		:'CHARGE_AMT_WON',
			fieldLabel	: '<t:message code="system.label.trade.localamounttotal" default="원화금액합계"/>',
			value		: 0
		},{
			xtype		: 'uniNumberfield',
			name		:'VAT_AMT',
			labelWidth	: 600,
			fieldLabel	: '<t:message code="system.label.sales.taxtotalamount" default="세액합계"/>',
			value		: 0
		}] 
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('tex200ukrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		flex	: 2,
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: true
//			copiedRow: true
//			useContextMenu: true,
		},
		selModel: 'rowmodel',
		columns: [		
			{dataIndex: 'CHARGE_TYPE'		, width: 120},
			{dataIndex: 'COMP_CODE'			, width: 120, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 120, hidden: true},
			{dataIndex: 'IMPORTER'			, width: 120, hidden: true},
			{dataIndex: 'IMPORTER_NM'		, width: 120},
			{dataIndex: 'BASIC_PAPER_NO'	, width: 120},
			{dataIndex: 'SALE_DATE'			, width: 135},
			{dataIndex: 'PROJECT_NO'		, width: 120, hidden: true},
			{dataIndex: 'LC_NO'				, width: 120, hidden: true},
			{dataIndex: 'BL_NO'				, width: 120, hidden: true}
		],
		listeners: {
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length == 1) {
					var record = selected[0];
					directDetailStore.loadStoreRecords(record);
				}
			},
			beforedeselect : function ( gird, record, index, eOpts ){
				if(directDetailStore.isDirty()) {
					if(confirm('<t:message code="system.message.trade.message002" default="내용이 변경되었습니다."/>' + '\n' + '<t:message code="system.message.trade.message003" default="변경된 내용을 저장하시겠습니까?"/>')) {
						UniAppManager.app.onSaveDataButtonDown();
					}else{
						directDetailStore.clearData();
						directMasterStore.loadStoreRecords();
					}
				}
			}
		}
	});

	/** Master Grid2 정의(Grid Panel)
	 * @type 
	 */
	var detailGrid = Unilite.createGrid('tex200ukrvGrid2', {
		store	: directDetailStore,
		layout	: 'fit',
		region	: 'east',
		flex	: 5,
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			copiedRow			: true,
			onLoadSelectFirst	: true
//			useContextMenu		: true,
		},
		features: [ {id : 'masterGridSubTotal2'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal2'	, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [
			{dataIndex: 'TRADE_DIV'					, width: 100,hidden: true},
			{dataIndex: 'CHARGE_TYPE'				, width: 100,hidden: true},
			{dataIndex: 'CHARGE_SER'				, width: 66, align: 'center'},
			{dataIndex: 'BASIC_PAPER_NO'			, width: 100,hidden: true},
			{dataIndex: 'TRADE_CUSTOM_CODE'			, width: 100,hidden: true},
			{dataIndex: 'TRADE_CUSTOM_NAME'			, width: 100,hidden: true},
			{dataIndex: 'CHARGE_CODE'				, width: 100,
				'editor' : Unilite.popup('EXPENSE_G', {
						DBtextFieldName: 'EXPENSE_CODE',
						autoPopup: true,
						listeners: {
							'onSelected': function(records, type  ){
									var grdRecord = detailGrid.uniOpt.currentRecord;
									grdRecord.set('CHARGE_CODE',records[0]['EXPENSE_CODE']);
									grdRecord.set('CHARGE_NAME',records[0]['EXPENSE_NAME']);
							},
							'onClear':  function( type  ){
									var grdRecord = detailGrid.uniOpt.currentRecord;
									grdRecord.set('CHARGE_CODE','');
									grdRecord.set('CHARGE_NAME','');
							},
							applyextparam: function(popup){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								popup.setExtParam({'TRADE_DIV': 'E', 'CHARGE_TYPE': grdRecord.get('CHARGE_TYPE')});
							}
						} // listeners
				})
			},
			{dataIndex: 'CHARGE_NAME'				, width: 100,
				'editor' : Unilite.popup('EXPENSE_G', {
						DBtextFieldName: 'EXPENSE_CODE',
						autoPopup: true,
						listeners: {
							'onSelected': function(records, type  ){
									var grdRecord = detailGrid.uniOpt.currentRecord;
									grdRecord.set('CHARGE_CODE',records[0]['EXPENSE_CODE']);
									grdRecord.set('CHARGE_NAME',records[0]['EXPENSE_NAME']);
							},
							'onClear':  function( type  ){
									var grdRecord = detailGrid.uniOpt.currentRecord;
									grdRecord.set('CHARGE_CODE','');
									grdRecord.set('CHARGE_NAME','');
							},
							applyextparam: function(popup){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								popup.setExtParam({'TRADE_DIV': 'E', 'CHARGE_TYPE': grdRecord.get('CHARGE_TYPE')});
							}
						} // listeners
				})
			},
			{dataIndex: 'CUST_CODE'					, width: 100,
				editor: Unilite.popup('CUST_G',{
					DBtextFieldName: 'CUSTOM_CODE',
					autoPopup: true,
					listeners:{ 'onSelected': {
						fn: function(records, type  ){
							//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUST_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							grdRecord.set('VAT_CUSTOM', records[0]['CUSTOM_CODE']);
							grdRecord.set('VAT_CUSTOM_NAME', records[0]['CUSTOM_NAME']);
						},
						scope: this
					},
					'onClear' : function(type) {
							//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUST_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							grdRecord.set('VAT_CUSTOM','');
							grdRecord.set('VAT_CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'CUSTOM_NAME'				, width: 100,
				editor: Unilite.popup('CUST_G',{
					autoPopup: true,
					listeners:{ 'onSelected': {
						fn: function(records, type  ){
							//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUST_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							grdRecord.set('VAT_CUSTOM', records[0]['CUSTOM_CODE']);
							grdRecord.set('VAT_CUSTOM_NAME', records[0]['CUSTOM_NAME']);
						},
						scope: this
					},
					'onClear' : function(type) {
							//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUST_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							grdRecord.set('VAT_CUSTOM','');
							grdRecord.set('VAT_CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'VAT_CUSTOM'				, width: 100,
				editor: Unilite.popup('CUST_G',{
					DBtextFieldName: 'CUSTOM_CODE',
					autoPopup: true,
					listeners:{ 'onSelected': {
						fn: function(records, type  ){
							//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('VAT_CUSTOM',records[0]['CUSTOM_CODE']);
							grdRecord.set('VAT_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
						},
						scope: this
					},
					'onClear' : function(type) {
							//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('VAT_CUSTOM','');
							grdRecord.set('VAT_CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'VAT_CUSTOM_NAME'			, width: 100,
				editor: Unilite.popup('CUST_G',{
					autoPopup: true,
					listeners:{ 'onSelected': {
						fn: function(records, type  ){
							//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('VAT_CUSTOM',records[0]['CUSTOM_CODE']);
							grdRecord.set('VAT_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
						},
						scope: this
					},
					'onClear' : function(type) {
							//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('VAT_CUSTOM','');
							grdRecord.set('VAT_CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'OCCUR_DATE'				, width: 100},
			{dataIndex: 'CHARGE_AMT'				, width: 100},
			{dataIndex: 'AMT_UNIT'					, width: 100, align: 'center'},
			{dataIndex: 'EXCHANGE_RATE'				, width: 100},
			{dataIndex: 'CHARGE_AMT_WON'			, width: 100},
			{dataIndex: 'SUPPLY_AMT'				, width: 100},
			{dataIndex: 'TAX_CLS'					, width: 100},
			{dataIndex: 'VAT_AMT'					, width: 100},
			{dataIndex: 'DIV_CODE'					, width: 100,hidden: true},
			{dataIndex: 'VAT_COMP_CODE'				, width: 100},
			{dataIndex: 'PAY_TYPE'					, width: 100},
			{dataIndex: 'NOTE_NUM'					, width: 100,hidden: true},
			{dataIndex: 'SAVE_CODE'					, width: 100,hidden: true},
			{dataIndex: 'SAVE_NAME'					, width: 100},
			{dataIndex: 'BANK_CODE'					, width: 100,hidden: true,
				editor: Unilite.popup('BANK_G', {
					autoPopup: true,
					DBtextFieldName: 'BANK_CODE',
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;
								rtnRecord.set('BANK_CODE', records[0]['BANK_CODE']);
								rtnRecord.set('BANK_NAME', records[0]['BANK_NAME']);
							},
							scope: this 
						},
						'onClear': function(type) {
							var rtnRecord = masterGrid.uniOpt.currentRecord;
								rtnRecord.set('BANK_CODE', '');
								rtnRecord.set('BANK_NAME', '');
						},
						applyextparam: function(popup){
						}
					}
				})
			},
			{dataIndex: 'BANK_NAME'					, width: 100,
				editor: Unilite.popup('BANK_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var rtnRecord = masterGrid.uniOpt.currentRecord;
								rtnRecord.set('BANK_CODE', records[0]['BANK_CODE']);
								rtnRecord.set('BANK_NAME', records[0]['BANK_NAME']);
							},
							scope: this 
						},
						'onClear': function(type) {
							var rtnRecord = masterGrid.uniOpt.currentRecord;
								rtnRecord.set('BANK_CODE', '');
								rtnRecord.set('BANK_NAME', '');
						},
						applyextparam: function(popup){
						}
					}
				})
			},
			{dataIndex: 'EXP_DATE'					, width: 100,hidden: true},
			{dataIndex: 'PROJECT_NO'				, width: 100},
			{dataIndex: 'PAY_DATE'					, width: 100},
			{dataIndex: 'REMARKS'					, width: 100},
			{dataIndex: 'OFFER_SER_NO'				, width: 100},
			{dataIndex: 'LC_SER_NO'					, width: 100,hidden: true},
			{dataIndex: 'LC_NO'						, width: 100},
			{dataIndex: 'BL_SER_NO'					, width: 100,hidden: true},
			{dataIndex: 'BL_NO'						, width: 100},
			{dataIndex: 'COST_DIV'					, width: 100,hidden: true},
			{dataIndex: 'EX_DATE'					, width: 100},
			{dataIndex: 'EX_NUM'					, width: 100},
			{dataIndex: 'AGREE_YN'					, width: 100},
			{dataIndex: 'UPDATE_DB_USER'			, width: 100,hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'			, width: 100,hidden: true},
			{dataIndex: 'COMP_CODE'					, width: 100,hidden: true},
			{dataIndex: 'GUBUN'						, width: 100,hidden: true}
		],
		listeners: {
			selectionchange:function( model1, selected, eOpts ){
				UniAppManager.setToolbarButtons('delete', true);
			},
			beforeedit  : function( editor, e, eOpts ) {
				var record = e.record;
				if(e.record.phantom){
					if (UniUtils.indexOf(e.field,['SAVE_CODE', 'SAVE_NAME'])) {
						if(!Ext.isEmpty(record.get('PAY_TYPE')) && record.get('PAY_TYPE').substring(0, 1) == "B"){
							return true;
						}else{
							return false;
						}
					}

					if (UniUtils.indexOf(e.field,['BANK_CODE', 'BANK_NAME'])) {
						if(!Ext.isEmpty(record.get('PAY_TYPE')) && record.get('PAY_TYPE').substring(0, 1) == "B" || record.get('PAY_TYPE').substring(0, 1) == "C"){
							return true;
						}else{
							return false;
						}
					}

					if (UniUtils.indexOf(e.field,['NOTE_NUM', 'EXP_DATE'])) {
						if(!Ext.isEmpty(record.get('PAY_TYPE')) && record.get('PAY_TYPE').substring(0, 1) == "C"){
							return true;
						}else{
							return false;
						}
					}

					if (UniUtils.indexOf(e.field,["CHARGE_AMT_WON","COST_DIV", "EX_DATE","EX_NUM","AGREE_YN"])) {
						return false;
					}
				}else{
					if (UniUtils.indexOf(e.field,["TRADE_DIV","CHARGE_SER", "CHARGE_CODE", "CHARGE_NAME"])) {
						return false;
					}

					if (UniUtils.indexOf(e.field,["CHARGE_AMT_WON","COST_DIV", "EX_DATE","EX_NUM","AGREE_YN"])) {
						return false;
					}

					if (UniUtils.indexOf(e.field,['SAVE_CODE', 'SAVE_NAME'])) {
						if(!Ext.isEmpty(record.get('PAY_TYPE')) && record.get('PAY_TYPE').substring(0, 1) == "B"){
							return true;
						}else{
							return false;
						}
					}
					if (UniUtils.indexOf(e.field,['BANK_CODE', 'BANK_NAME'])) {
						if(!Ext.isEmpty(record.get('PAY_TYPE')) && record.get('PAY_TYPE').substring(0, 1) == "B" || record.get('PAY_TYPE').substring(0, 1) == "C"){
							return true;
						}else{
							return false;
						}
					}

					if (UniUtils.indexOf(e.field,['NOTE_NUM', 'EXP_DATE'])) {
						if(!Ext.isEmpty(record.get('PAY_TYPE')) && record.get('PAY_TYPE').substring(0, 1) == "C"){
							return true;
						}else{
							return false;
						}
					}

					if (UniUtils.indexOf(e.field,["CUST_CODE","CUSTOM_NAME", "VAT_CUSTOM", "VAT_CUSTOM_NAME"])) {
						if(!Ext.isEmpty(record.get('EX_DATE'))){
							return false;
						}else{
							return true;
						}
					}
				}
			}
		}
	});



	 Unilite.Main({
		id			: 'tex200ukrvApp',
		border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, detailGrid, panelResult, panelSummary
			]
		}, panelSearch
		],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('newData', true);
			directMasterStore.loadStoreRecords();
			panelSearch.setValue('FR_DATE'	, UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE'	, UniDate.get('today'));
			panelResult.setValue('FR_DATE'	, UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE'	, UniDate.get('today'));
			panelSearch.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)  {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
		},
		onQueryButtonDown : function() {
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function() {
			var pRecord = masterGrid.getSelectedRecord();
			if(!Ext.isEmpty(pRecord)) {
				var seq = directDetailStore.max('CHARGE_SER');
				if(!seq) seq = 1;
				else  seq += 1;
				
				var r = {
					COMP_CODE			: pRecord.get('COMP_CODE'),
					DIV_CODE			: pRecord.get('DIV_CODE'),
					CHARGE_TYPE			: pRecord.get('CHARGE_TYPE'),
					VAT_COMP_CODE		: pRecord.get('DIV_CODE'),
					BASIC_PAPER_NO		: pRecord.get('BASIC_PAPER_NO'),
					TRADE_DIV			: 'E',
					CHARGE_SER			: seq,
					AMT_UNIT			: UserInfo.currency,
					OCCUR_DATE			: UniDate.get('today'),
					EXCHANGE_RATE		: '1',
					CHARGE_AMT			: 0,
					CHARGE_AMT_WON		: 0,
					SUPPLY_AMT			: 0,
					VAT_AMT				: 0,
					TRADE_CUSTOM_CODE	: pRecord.get('IMPORTER'),
					TRADE_CUSTOM_NAME	: pRecord.get('IMPORTER_NM'),
					PROJECT_NO			: pRecord.get('PROJECT_NO'),
					LC_NO				: pRecord.get('LC_NO'),
					BL_NO				: pRecord.get('BL_NO')
				}
				detailGrid.createRow(r, 'TRADE_DIV');
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.trade.message001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				detailGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			directMasterStore.loadData({});
			directDetailStore.loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function () {
			directDetailStore.saveStore();
		}
	});	



	Unilite.createValidator('validator02', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			switch(fieldName) {
				case "CHARGE_AMT" : 
					//20200610 수정: 자사금액 계산시, 'JPY' 관련로직 추가
					record.set('CHARGE_AMT_WON'	, UniMatrl.fnExchangeApply(record.get('AMT_UNIT'), newValue * record.get('EXCHANGE_RATE')));
					record.set('SUPPLY_AMT'		, UniMatrl.fnExchangeApply(record.get('AMT_UNIT'), newValue * record.get('EXCHANGE_RATE')));
					break;

				case "EXCHANGE_RATE" :
					//20200610 수정: 자사금액 계산시, 'JPY' 관련로직 추가
					record.set('CHARGE_AMT_WON'	, UniMatrl.fnExchangeApply(record.get('AMT_UNIT'), newValue * record.get('CHARGE_AMT')));
					record.set('SUPPLY_AMT'		, UniMatrl.fnExchangeApply(record.get('AMT_UNIT'), newValue * record.get('CHARGE_AMT')));
					break;

				//20200610 추가
				case "AMT_UNIT" :
					record.set('CHARGE_AMT_WON'	, UniMatrl.fnExchangeApply(newValue, record.get('EXCHANGE_RATE') * record.get('CHARGE_AMT')));
					record.set('SUPPLY_AMT'		, UniMatrl.fnExchangeApply(newValue, record.get('EXCHANGE_RATE') * record.get('CHARGE_AMT')));
					break;

				case "VAT_AMT" :
					break;
			}
			return rv;
		}
	});
};
</script>