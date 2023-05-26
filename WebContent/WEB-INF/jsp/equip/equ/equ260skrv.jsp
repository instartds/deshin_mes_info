<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="equ260skrv">
	<t:ExtComboStore comboType="BOR120"/>						<!-- 사업장 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
.x-grid-cell_red {
	background-color: #ff5500;
	//color:white;
}
.x-grid-cell_yellow {
	background-color: #ffff66;
	//color:white;
}
.x-grid-cell_black {
	background-color: #eee;
	//color:white;
}
</style>

<script type="text/javascript" >

function appMain() {
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title		: '검색조건',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items	: [{
			title		: '<t:message code="system.label.equipment.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.equipment.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'SALE_DATE_FR',
				endFieldName	: 'SALE_DATE_TO',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('SALE_DATE_FR', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('SALE_DATE_TO', newValue);
					}
				}
			},
			Unilite.popup('EQU_CODE', { 
				fieldLabel		: '금형번호', 
				valueFieldName	: 'EQU_CODE',
				textFieldName	: 'EQU_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue) {
						panelResult.setValue('EQU_CODE', newValue);
						if(Ext.isEmpty(newValue)) {
							panelSearch.setValue('EQU_NAME', newValue);
							panelResult.setValue('EQU_NAME', newValue);
						}
					},
					onTextFieldChange: function(field, newValue) {
						panelResult.setValue('EQU_CODE', newValue);
					},
					applyextparam: function(popup) {
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			})]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3,	rows:2, tableAttrs: { /*style: { width: '100%', height:'100%' }*/ }},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.equipment.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'SALE_DATE_FR',
			endFieldName	: 'SALE_DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('SALE_DATE_FR', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('SALE_DATE_TO', newValue);
				}
			}
		},
		Unilite.popup('EQU_CODE', { 
			fieldLabel		: '금형번호', 
			valueFieldName	: 'EQU_CODE',
			textFieldName	: 'EQU_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue) {
					panelSearch.setValue('EQU_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('EQU_NAME', newValue);
						panelResult.setValue('EQU_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue) {
					panelSearch.setValue('EQU_CODE', newValue);
				},
				applyextparam: function(popup) {
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		})]
	});




	Unilite.defineModel('equ260skrvModel1', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.equipment.compcode" default="법인코드"/>'	, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.equipment.division" default="사업장"/>'		, type: 'string'},
			{name: 'EQU_CODE'			, text: '<t:message code="system.label.common.moldcode" default="금형코드"/>'		, type: 'string'},
			{name: 'EQU_NAME'			, text: '<t:message code="system.label.common.moldname" default="금형명"/>'		, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'			, type: 'string'},
			{name: 'SER_NO'				, text: '<t:message code="system.label.sales.seq" default="순번"/>'				, type: 'integer'},
			{name: 'SALE_CUSTOM_CODE'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string'},
			{name: 'SALE_CUSTOM_NAME'	, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'MODEL_COL'			, text: '모델'		, type: 'string'},
			{name: 'PROD_ITEM_CODE'		, text: '<t:message code="system.label.product.goods" default="제품"/>'			, type: 'string'},
			{name: 'PROD_ITEM_NAME'		, text: '<t:message code="system.label.base.goodsname" default="제품명"/>'			, type: 'string'},
			{name: 'SALE_Q'				, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'			, type: 'float' , decimalPrecision: 2 , format:'0,000.00'},
			{name: 'SALE_AMT_O'			, text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'	, type: 'float' , decimalPrecision: 2, format:'0,000.00'},
			{name: 'SALE_DATE'			, text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'		, type: 'uniDate'},
			{name: 'INSERT_DATE'		, text: '<t:message code="system.label.sales.entrydate" default="등록일"/>'		, type: 'uniDate'},
			{name: 'LEVEL_COL'			, text: '레벨'		, type: 'integer'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>'		, type: 'string'},
			{name: 'ITEM_LEVEL_COL'		, text: '품목레벨'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '부품코드'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '부품명'		, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.sales.unit" default="단위"/>'				, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('equ260skrvMasterStore1',{
		model	: 'equ260skrvModel1',
		proxy	: {
			type: 'direct',
			api	: {
				read: 'equ260skrvService.selectList'
			}
		},
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부
			allDeletable: false,	// 전체 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
			
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log( param );
			this.load({
				params: param//,
//				callback:function(records, operation, success) {
//					if(success) {
//					}
//				}
			});
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		groupField: 'EQU_CODE'
	});

	var masterGrid = Unilite.createGrid('equ260skrvGrid1', {
		store	: directMasterStore1,
		title	: '',
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useLiveSearch		: true,
			useGroupSummary		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: true,
			onLoadSelectFirst	: false,
			filter: {
				useFilter	: false,
				autoCreate	: false
			},
			excel: {
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: true,		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		features: [
			{id: 'masterGridSubTotal'	,ftype: 'uniGroupingsummary',showSummaryRow: true},
			{id: 'masterGridTotal'		,ftype: 'uniSummary'		,showSummaryRow: true}
		],
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store) {
//				var cls = '';
//					if(record.get("EQU_GRADE") == "C") {
//						return 'x-grid-cell_red';
//					}else if(record.get("EQU_GRADE") == "A") {
//						return 'x-grid-cell_yellow';
//					}
//					return 'x-grid-cell_black';
				
//				return cls;
			}
		},
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 80		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 120	, hidden: true},
			{dataIndex: 'EQU_CODE'			, width: 100},
			{dataIndex: 'EQU_NAME'			, width: 150,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'ORDER_NUM'			, width: 110},
			{dataIndex: 'SER_NO'			, width: 66		, align: 'center'},
			{dataIndex: 'SALE_CUSTOM_CODE'	, width: 100},
			{dataIndex: 'SALE_CUSTOM_NAME'	, width: 150},
			{dataIndex: 'MODEL_COL'			, width: 120},
			{dataIndex: 'PROD_ITEM_CODE'	, width: 120},
			{dataIndex: 'PROD_ITEM_NAME'	, width: 250},
			{dataIndex: 'SALE_Q'			, width: 110	, summaryType: 'sum',
				summaryRenderer:function(value, summaryData, dataIndex, metaData) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<div align="right">'+ Ext.util.Format.number(value,'0,000')+'</div>', '<div align="right">'+ Ext.util.Format.number(value,'0,000')+'</div>');
				}
			},
			{dataIndex: 'SALE_AMT_O'		, width: 110	, summaryType: 'sum',
				summaryRenderer:function(value, summaryData, dataIndex, metaData) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<div align="right">'+ Ext.util.Format.number(value,'0,000')+'</div>', '<div align="right">'+ Ext.util.Format.number(value,'0,000')+'</div>');
				}
			},
			{dataIndex: 'SALE_DATE'			, width: 80},
			{dataIndex: 'INSERT_DATE'		, width: 80},
			{dataIndex: 'LEVEL_COL'			, width: 80		, align: 'center'},
			{dataIndex: 'ITEM_ACCOUNT'		, width: 100	, align: 'center'},
			{dataIndex: 'ITEM_LEVEL_COL'	, width: 200,
				renderer:function(value) {
					return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+'</div>';
				}
			},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 250},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'STOCK_UNIT'		, width: 80		, align: 'center'}
		]
	});





	Unilite.Main( {
		id			: 'equ260skrvApp',
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
		fnInitBinding: function(params) {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('SALE_DATE_FR'	, UniDate.get('startOfMonth'));
			panelSearch.setValue('SALE_DATE_TO'	, UniDate.get('today'));

			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('SALE_DATE_FR'	, UniDate.get('startOfMonth'));
			panelResult.setValue('SALE_DATE_TO'	, UniDate.get('today'));

			UniAppManager.setToolbarButtons(['reset'], true);
			//초기화 시, 포커스 설정
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) {
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});
};
</script>