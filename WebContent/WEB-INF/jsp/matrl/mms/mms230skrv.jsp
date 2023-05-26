<%--
'   프로그램명 : 수입검사현황II (mms230skrv)
'   작  성  자 : 시너지시스템즈 개발실
'   작  성  일 :
'   최종수정자 :
'   최종수정일 :
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms230skrv">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020"/>	<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="M001"/>	<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="Q033"/>	<!-- 최종판정 -->
	<t:ExtComboStore comboType="AU" comboCode="Q005"/>	<!-- 검사유형 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsSiteCode : '${gsSiteCode}'
};

var printHiddenYn = true;
if(BsaCodeInfo.gsSiteCode == 'SHIN'){
	printHiddenYn = false;
}

function appMain() {
	var colData	= Ext.isEmpty(${colData})  ? '' : ${colData};		//Q005
	var colData4= Ext.isEmpty(${colData4}) ? '' : ${colData4};		//Q014
	var fields	= createModelField(colData, colData4);
	var columns	= createGridColumn(colData, colData4);
	var gsBadQArray, gsBadQArray2; 

	/** 검색조건 (Search Panel)
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: true,
		width		: 380,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title		: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE'		, newValue);
						panelSearch.setValue('INSPEC_PRSN'	, '');
						panelResult.setValue('INSPEC_PRSN'	, '');
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'INSPEC_DATE_FR',
				endFieldName	: 'INSPEC_DATE_TO',
				allowBlank		: false,
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INSPEC_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INSPEC_DATE_TO',newValue);
					}
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.purchase.poclass" default="발주유형"/>',
				items		: [{
					boxLabel	: '내수/수입',
					name		: 'ORDER_TYPE',
					inputValue	: 'A', 
					width		: 90
				},{
					boxLabel	: '외주',
					name		: 'ORDER_TYPE',
					inputValue	: 'B',
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('ORDER_TYPE').setValue(newValue.ORDER_TYPE);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.inspeccharge" default="검사담당"/>',
				name		: 'INSPEC_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Q022',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPEC_PRSN', newValue)
					},
					beforequery:function( queryPlan, eOpts ) {
						var store	= queryPlan.combo.store;
						var pRStore	= panelSearch.getField('INSPEC_PRSN').store;
						var divChk	= false;
						Ext.each(store.data.items, function(record,i){
							if(!Ext.isEmpty(record.get('refCode1'))){
								divChk = true;
							}
						});
						store.clearFilter();
						pRStore.clearFilter();
						if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE')) && divChk == true ){
							store.filterBy(function(record){
								return record.get('refCode1') == panelSearch.getValue('DIV_CODE');
							});
							pRStore.filterBy(function(record){
								return record.get('refCode1') == panelSearch.getValue('DIV_CODE');
							});
						}else if(divChk == false){
								return true;
						} else {
							store.filterBy(function(record){
								return false;
							});
							pRStore.filterBy(function(record){
								return false;
							});
						}
					}
				}
			},
			Unilite.popup('DIV_PUMOK', {
				fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange:function( elm, newValue, oldValue) {
						panelResult.setValue('ITEM_CODE', newValue);
	
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_NAME', '');
							panelSearch.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange:function( elm, newValue, oldValue) {
						panelResult.setValue('ITEM_NAME', newValue);
	
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
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
					}
				}
			})]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
			change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE'		, newValue);
					panelSearch.setValue('INSPEC_PRSN'	, '');
					panelResult.setValue('INSPEC_PRSN'	, '');
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'INSPEC_DATE_FR',
			endFieldName	: 'INSPEC_DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INSPEC_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INSPEC_DATE_TO',newValue);
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.purchase.poclass" default="발주유형"/>',
			items		: [{
				boxLabel	: '내수/수입',
				name		: 'ORDER_TYPE',
				inputValue	: 'A', 
				width		: 90
			},{
				boxLabel	: '외주',
				name		: 'ORDER_TYPE',
				inputValue	: 'B',
				width		: 60
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('ORDER_TYPE').setValue(newValue.ORDER_TYPE);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.inspeccharge" default="검사담당"/>',
			name		: 'INSPEC_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'Q022',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INSPEC_PRSN', newValue)
				},
				beforequery:function( queryPlan, eOpts ) {
					var store	= queryPlan.combo.store;
					var pRStore	= panelResult.getField('INSPEC_PRSN').store;
					var divChk	= false;
					Ext.each(store.data.items, function(record,i){
						if(!Ext.isEmpty(record.get('refCode1'))){
							divChk = true;
						}
					});
					store.clearFilter();
					pRStore.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE')) && divChk == true ){
						store.filterBy(function(record){
							return record.get('refCode1') == panelResult.getValue('DIV_CODE');
						});
						pRStore.filterBy(function(record){
							return record.get('refCode1') == panelResult.getValue('DIV_CODE');
						});
					}else if(divChk == false){
							return true;
					} else {
						store.filterBy(function(record){
							return false;
						});
						pRStore.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange:function( elm, newValue, oldValue) {
					panelSearch.setValue('ITEM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_NAME', '');
						panelSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange:function( elm, newValue, oldValue) {
					panelSearch.setValue('ITEM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
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
				}
			}
		})]
	});



	/** Model 정의
	 */
	Unilite.defineModel('mms230skrvModel', {
		fields: fields
/*		fields: [
			{name: 'INSPEC_DATE'			, text: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>'			, type: 'uniDate'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'INSTOCK'				, text: '<t:message code="system.label.purchase.receiptqty1" default="입고수량"/>'			, type: 'uniQty'},
			{name: 'RECEIPT_Q'				, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'			, type: 'uniQty'},
			검사방식 동적으로 추가
			{name: 'INSPEC_Q'				, text: '<t:message code="system.label.purchase.inspecqty" default="검사량"/>'				, type: 'uniQty'},
			{name: 'REMAIN_INSTOCK_Q'		, text: '<t:message code="system.label.purchase.inspecqty" default="검사량"/>'				, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q'			, text: '<t:message code="system.label.purchase.defectqty" default="불량수량"/>'			, type: 'uniQty'},
			{name: 'BAD_RATE'				, text: '<t:message code="system.label.purchase.defectratepercent" default="불량률(%)"/>'	, type: 'uniPercent'},
			불량유형 동적으로 추가
			{name: 'BAD_INSPEC_NAME_LIST'	, text: '불량세부내역'		, type: 'string'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'INSPEC_PRSN_NAME'		, text: '검사자'			, type: 'string'},
			{name: 'ORDER_TYPE'				, text: '<t:message code="system.label.purchase.poclass" default="발주유형"/>'				, type: 'string',comboType:'AU',comboCode:'M001'},
			{name: 'INSPEC_NUM'				, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'				, type: 'string'},
			{name: 'INSPEC_SEQ'				, text: '<t:message code="system.label.purchase.inspecseq" default="검사순번"/>'			, type: 'int'},
			{name: 'RECEIPT_NUM'			, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'			, type: 'string'},
			{name: 'RECEIPT_SEQ'			, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'			, type: 'int'},
			{name: 'ORDER_NUM'				, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '발주순번'			, type: 'int'}
		]*/
	});

	/** Store 정의(Service 정의)
	 */
	var directMasterStore1 = Unilite.createStore('mms230skrvMasterStore1', {
		model	: 'mms230skrvModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'mms230skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		groupField: 'INSPEC_DATE',
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				if(records && records.length > 0){
				}
			}
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 */
	var masterGrid = Unilite.createGrid('mms230skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: false,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			},
			excel: {
				useExcel		: true,			//엑셀 다운로드 사용 여부
				exportGroup		: true,			//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: true
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: true
		}],
		columns	: columns,
		listeners: {
			selectionchange: function( grid, selected, eOpts ){
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ){
			}
		}
	});



	Unilite.Main({
		id			: 'mms230skrvApp',
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
			panelSearch.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelSearch.setValue('INSPEC_DATE_FR'	, UniDate.get('startOfMonth'));
			panelResult.setValue('INSPEC_DATE_FR'	, UniDate.get('startOfMonth'));
			panelSearch.setValue('INSPEC_DATE_TO'	, UniDate.get('today'));
			panelResult.setValue('INSPEC_DATE_TO'	, UniDate.get('today'));
			panelSearch.setValue('ORDER_TYPE').setValue('A');
			panelResult.setValue('ORDER_TYPE').setValue('A');
			UniAppManager.setToolbarButtons('reset', true);
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
//			UniAppManager.setToolbarButtons('excel',true);
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			UniAppManager.app.fnInitBinding();
		}
	});



	function createModelField(colData, colData4) {
		var fields = [
			{name: 'INSPEC_DATE'			, text: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>'			, type: 'uniDate'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'INSTOCK'				, text: '<t:message code="system.label.purchase.receiptqty1" default="입고수량"/>'			, type: 'uniQty'},
			{name: 'RECEIPT_Q'				, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'			, type: 'uniQty'},
			{name: 'INSPEC_Q'				, text: '<t:message code="system.label.purchase.inspecqty" default="검사량"/>'				, type: 'uniQty'},
			{name: 'REMAIN_INSTOCK_Q'		, text: '미입고'			, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q'			, text: '<t:message code="system.label.purchase.defectqty" default="불량수량"/>'			, type: 'uniQty'},
			{name: 'BAD_INSPEC_RATE'		, text: '<t:message code="system.label.purchase.defectratepercent" default="불량률(%)"/>'	, type: 'uniPercent'},
			{name: 'BAD_INSPEC_NAME_LIST'	, text: '불량세부내역'		, type: 'string'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'INSPEC_PRSN_NAME'		, text: '검사자'			, type: 'string'},
			{name: 'ORDER_TYPE'				, text: '<t:message code="system.label.purchase.poclass" default="발주유형"/>'				, type: 'string',comboType:'AU',comboCode:'M001'},
			{name: 'INSPEC_NUM'				, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'				, type: 'string'},
			{name: 'INSPEC_SEQ'				, text: '<t:message code="system.label.purchase.inspecseq" default="검사순번"/>'			, type: 'int'},
			{name: 'RECEIPT_NUM'			, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'			, type: 'string'},
			{name: 'RECEIPT_SEQ'			, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'			, type: 'int'},
			{name: 'ORDER_NUM'				, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '발주순번'			, type: 'int'}
		];
		//동적 컬럼 모델 push
		Ext.each(colData, function(item, index){
			var subCode = index + 1;
			if(subCode < 10) {
				subCode = '0' + subCode;
			}
			fields.push({name: 'INSPEC_Q_' + subCode, type: 'uniQty' });
		});
		Ext.each(colData4, function(item, index){
			var subCode = index + 1;
//			if(subCode < 10) {
//				subCode = '0' + subCode;
//			}
			fields.push({name: 'BAD_INSPEC_Q_' + subCode, type: 'uniQty' });
		});
		return fields;
	}

	function createGridColumn(colData, colData4) {
		var array1	= new Array();
		var array4	= new Array();
		var columns	= [
			{dataIndex: 'INSPEC_DATE'			, width: 80	, style: {textAlign: 'center'}},
			{dataIndex: 'ITEM_CODE'				, width: 120, style: 'text-align: center'},
			{dataIndex: 'ITEM_NAME'				, width: 150, style: 'text-align: center'},
			{dataIndex: 'SPEC'					, width: 120, style: 'text-align: center'},
			{dataIndex: 'INSTOCK'				, width: 100, style: 'text-align: center',	align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum'},
			{dataIndex: 'RECEIPT_Q'				, width: 100, style: 'text-align: center',	align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum'}
		];	
		Ext.each(colData, function(item, index){
			var subCode = index + 1;
			if(subCode < 10) {
				subCode = '0' + subCode;
			}
			array1[index] = Ext.applyIf({dataIndex: 'INSPEC_Q_' + subCode	, text: item.CODE_NAME	, width:110	, style: {textAlign: 'center'}},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum' });
		});
		columns.push(
			{text: '검사방식',
				columns: array1
			}
		);
		columns.push(
			{dataIndex: 'INSPEC_Q'				, width: 100, style: 'text-align: center',	align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum'},
			{dataIndex: 'REMAIN_INSTOCK_Q'		, width: 100, style: 'text-align: center',	align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum'},
			{dataIndex: 'BAD_INSPEC_Q'			, width: 100, style: 'text-align: center',	align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum'},
			{dataIndex: 'BAD_INSPEC_RATE'		, width: 100, style: 'text-align: center',	align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Percent}
		)
		Ext.each(colData4, function(item, index){
			var subCode = index + 1;
//			if(subCode < 10) {
//				subCode = '0' + subCode;
//			}
			array4[index] = Ext.applyIf({dataIndex: 'BAD_INSPEC_Q_' + subCode	, text: item.CODE_NAME	, width:110	, style: {textAlign: 'center'}},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum' });
		});
		columns.push(
			{text: '불량유형',
				columns: array4
			}
		);
		columns.push(
			{dataIndex: 'BAD_INSPEC_NAME_LIST'	, width: 200, style: 'text-align: center'},
			{dataIndex: 'REMARK'				, width: 150, style: 'text-align: center'},
			{dataIndex: 'INSPEC_PRSN_NAME'		, width: 80	, style: 'text-align: center', align: 'center'},
			{dataIndex: 'ORDER_TYPE'			, width: 80	, style: 'text-align: center', align: 'center'},
			{dataIndex: 'INSPEC_NUM'			, width: 110, style: 'text-align: center'},
			{dataIndex: 'INSPEC_SEQ'			, width: 80	, style: 'text-align: center', align: 'center'},
			{dataIndex: 'RECEIPT_NUM'			, width: 110, style: 'text-align: center'},
			{dataIndex: 'RECEIPT_SEQ'			, width: 80	, style: 'text-align: center', align: 'center'},
			{dataIndex: 'ORDER_NUM'				, width: 110, style: 'text-align: center'},
			{dataIndex: 'ORDER_SEQ'				, width: 80	, style: 'text-align: center', align: 'center'}
		);
//		gsBadQArray	= gsBadQArrayInfo.split(',');
//		gsBadQArray2= gsBadQArrayInfo2.split(',');
		return columns;
	}
};
</script>