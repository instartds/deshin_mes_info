<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str130skrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_str130skrv_mit"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="OU"/>								<!--입고창고-->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
		items: [{
			title		: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
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
				fieldLabel		: '<t:message code="system.label.sales.transdate" default="수불일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'INOUT_DATE_FR',
				endFieldName	: 'INOUT_DATE_TO',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.receiptwarehouse" default="입고창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'OU',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						store.clearFilter();
						if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == panelSearch.getValue('DIV_CODE');
							})
						}else{
							store.filterBy(function(record){
								return false;
							})
						}
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
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
			fieldLabel		: '<t:message code="system.label.sales.transdate" default="수불일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'INOUT_DATE_FR',
			endFieldName	: 'INOUT_DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_TO',newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.receiptwarehouse" default="입고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						})
					}else{
						store.filterBy(function(record){
							return false;
						})
					}
				}
			}
		}]
	});



	/** Model 정의 
	 * @type
	 */
	Unilite.defineModel('s_str130skrv_mitModel', {
		fields: [  	
			{name: 'COMP_CODE'	, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'				, type: 'string'},
			{name: 'DIV_CODE'	, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string'},
			{name: 'WH_CODE'	, text: '<t:message code="system.label.sales.receiptwarehouse" default="입고창고"/>'		, type: 'string', comboType: 'OU'},
			{name: 'INOUT_DATE'	, text: '<t:message code="system.label.sales.receiptdate" default="입고일"/>'				, type: 'uniDate'},
			{name: 'ITEM_CODE'	, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'	, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'		, text: '<t:message code="system.label.sales.spec" default="규격"/>'						, type: 'string'},
			{name: 'LOT_NO'		, text: '<t:message code="system.label.sales.lotno" default="LOT_NO"/>'					, type: 'string'},
			{name: 'IN_Q'		, text: '<t:message code="system.label.inventory.receiptqty1" default="입고수량"/>'			, type: 'uniQty'},
			{name: 'STOCK_UNIT'	, text: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'			, type: 'string'},
			{name: 'WKORD_NUM'	, text: '작업지시번호'	, type: 'string'},
			{name: 'PRODT_NUM'	, text: '<t:message code="system.label.sales.productionresultno" default="생산실적번호"/>'	, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_str130skrv_mitMasterStore1',{
		model	: 's_str130skrv_mitModel',
		uniOpt : {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_str130skrv_mitService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});	
		}
	});

	/** Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_str130skrv_mitGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false, 
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ 
			{id: 'masterGridSubTotal1'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'masterGridTotal1'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{ dataIndex: 'COMP_CODE'	, width: 150, hidden:true},
			{ dataIndex: 'DIV_CODE'		, width: 150, hidden:true},
			{ dataIndex: 'WH_CODE'		, width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex: 'INOUT_DATE'	, width: 80},
			{ dataIndex: 'ITEM_CODE'	, width: 110},
			{ dataIndex: 'ITEM_NAME'	, width: 150, hidden:true},
			{ dataIndex: 'SPEC'			, width: 230},
			{ dataIndex: 'LOT_NO'		, width: 110},
			{ dataIndex: 'IN_Q'			, width: 100, summaryType: 'sum'},
			{ dataIndex: 'STOCK_UNIT'	, width: 100},
			{ dataIndex: 'WKORD_NUM'	, width: 100},
			{ dataIndex: 'PRODT_NUM'	, width: 110, hidden:true}
		],
		listeners: {
			select: function(grid, record, index, eOpts ){	
			},
			deselect:  function(grid, record, index, eOpts ){
			}
		}
	});



	Unilite.Main({
		id			: 's_str130skrv_mitApp',
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
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode)
			panelSearch.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth'));;
			panelSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_TO', UniDate.get('today'));

			//초기화 시 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
			UniAppManager.setToolbarButtons('reset', true);
			//20200316 추가: 링크 넘어오는 데이터 받는 로직 추가
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
		},
		//20200316 추가: 링크 넘어오는 데이터 받는 로직 추가
		processParams: function(params) {
			if(params.PGM_ID == 's_str130ukrv_mit') {
				panelSearch.setValue('DIV_CODE'		, params.formPram.DIV_CODE);
				panelResult.setValue('DIV_CODE'		, params.formPram.DIV_CODE)
				panelSearch.setValue('INOUT_DATE_FR', params.formPram.PRODT_DATE_FR);
				panelResult.setValue('INOUT_DATE_FR', params.formPram.PRODT_DATE_FR);;
				panelSearch.setValue('INOUT_DATE_TO', params.formPram.PRODT_DATE_TO);
				panelResult.setValue('INOUT_DATE_TO', params.formPram.PRODT_DATE_TO);
				panelSearch.setValue('WH_CODE'		, params.formPram.WH_CODE);
				panelResult.setValue('WH_CODE'		, params.formPram.WH_CODE);
				UniAppManager.app.onQueryButtonDown();
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		}
	});
};
</script>