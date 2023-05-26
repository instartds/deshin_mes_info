<%--
'   프로그램명 : 월별 구매집계 (man110skrv)
'   작   성   자 : 시너지시스템즈개발실
'   작   성   일 : 2020.03.13
'   최종수정자 :
'   최종수정일 :
'   버	  전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="man110skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="man110skrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020"/>			<!-- 품목계정-->
	<t:ExtComboStore comboType="AU" comboCode="B042"/>			<!-- 금액단위-->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/><!--창고-->
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
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
				fieldLabel	: '<t:message code="system.label.purchase.baseyear" default="기준년도"/>',
				xtype		: 'uniYearField',
				name		: 'BASIS_YYYY',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BASIS_YYYY', newValue);
						fnSetColumnName(newValue);
					}
				}
			},{	//20200410 추가: 조회조건 "창고(멀티)" 추가
				fieldLabel	: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				multiSelect	: true,
				listeners	: {
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						store.clearFilter();
						store.filterBy(function(record){
							return record.get('option') == panelSearch.getValue('DIV_CODE');
						})
					},
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.amountunit" default="금액단위"/>',
				name		: 'AMOUNT_UNIT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B042',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AMOUNT_UNIT', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 5},
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
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.baseyear" default="기준년도"/>',
			xtype		: 'uniYearField',
			name		: 'BASIS_YYYY',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BASIS_YYYY', newValue);
					fnSetColumnName(newValue);
				}
			}
		},{	//20200410 추가: 조회조건 "창고(멀티)" 추가
			fieldLabel	: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList'),
			multiSelect	: true,
			listeners	: {
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					store.filterBy(function(record){
						return record.get('option') == panelSearch.getValue('DIV_CODE');
					})
				},
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				}
			}
		},{
			xtype: 'component',
			width: 200
		},{
			fieldLabel	: '<t:message code="system.label.sales.amountunit" default="금액단위"/>',
			name		: 'AMOUNT_UNIT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B042',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AMOUNT_UNIT', newValue);
				}
			}
		}]
	});



	/** Model 정의 
	 * @type
	 */
	Unilite.defineModel('man110skrvModel', {
		fields: [
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'	, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			, type: 'string'/*, type: 'string', comboType:'AU', comboCode:'B020'*/},
			{name: 'PRE_AVERAGE'	, text: '<t:message code="system.label.purchase.previousyearaverage" default="전년도평균"/>'	, type: 'uniPrice'},
			{name: 'AVG_AMOUNT'		, text: '<t:message code="system.label.purchase.annualmean" default="년평균"/>'			, type: 'uniPrice'},
			{name: 'TOTAL_AMOUNT'	, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'			, type: 'uniPrice'},
			{name: 'AMOUNT_I1'		, text: '1<t:message code="system.label.purchase.month" default="월"/>'					, type: 'uniPrice'},
			{name: 'AMOUNT_I2'		, text: '2<t:message code="system.label.purchase.month" default="월"/>'					, type: 'uniPrice'},
			{name: 'AMOUNT_I3'		, text: '3<t:message code="system.label.purchase.month" default="월"/>'					, type: 'uniPrice'},
			{name: 'AMOUNT_I4'		, text: '4<t:message code="system.label.purchase.month" default="월"/>'					, type: 'uniPrice'},
			{name: 'AMOUNT_I5'		, text: '5<t:message code="system.label.purchase.month" default="월"/>'					, type: 'uniPrice'},
			{name: 'AMOUNT_I6'		, text: '6<t:message code="system.label.purchase.month" default="월"/>'					, type: 'uniPrice'},
			{name: 'AMOUNT_I7'		, text: '7<t:message code="system.label.purchase.month" default="월"/>'					, type: 'uniPrice'},
			{name: 'AMOUNT_I8'		, text: '8<t:message code="system.label.purchase.month" default="월"/>'					, type: 'uniPrice'},
			{name: 'AMOUNT_I9'		, text: '9<t:message code="system.label.purchase.month" default="월"/>'					, type: 'uniPrice'},
			{name: 'AMOUNT_I10'		, text: '10<t:message code="system.label.purchase.month" default="월"/>'					, type: 'uniPrice'},
			{name: 'AMOUNT_I11'		, text: '11<t:message code="system.label.purchase.month" default="월"/>'					, type: 'uniPrice'},
			{name: 'AMOUNT_I12'		, text: '12<t:message code="system.label.purchase.month" default="월"/>'					, type: 'uniPrice'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('man110skrvMasterStore1', {
		model	: 'man110skrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'man110skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});	
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		groupField: 'CUSTOM_NAME'
	});


	/** Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('man110skrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: false,
			onLoadSelectFirst	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ 
			{id: 'masterGridSubTotal1'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'masterGridTotal1'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		selModel: 'rowmodel',
		columns	: [
			{ text: '<t:message code="system.label.purchase.classfication" default="구분"/>',
				columns: [
					{dataIndex: 'CUSTOM_CODE'	, width: 110, hidden: true},
					{dataIndex: 'CUSTOM_NAME'	, width: 150,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
						}
					},
					{dataIndex: 'ITEM_ACCOUNT'	, width: 120}
				]
			},
			{dataIndex: 'PRE_AVERAGE'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'AVG_AMOUNT'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'TOTAL_AMOUNT'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'AMOUNT_I1'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'AMOUNT_I2'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'AMOUNT_I3'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'AMOUNT_I4'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'AMOUNT_I5'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'AMOUNT_I6'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'AMOUNT_I7'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'AMOUNT_I8'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'AMOUNT_I9'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'AMOUNT_I10'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'AMOUNT_I11'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'AMOUNT_I12'	, width: 100, summaryType: 'sum'}
		],
		listeners:{
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		}
	});



	Unilite.Main({
		id			: 'man110skrvApp',
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
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('BASIS_YYYY'	, new Date().getFullYear());
			panelSearch.setValue('AMOUNT_UNIT'	, '2');

			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('BASIS_YYYY'	, new Date().getFullYear());
			panelResult.setValue('AMOUNT_UNIT'	, '2');

			fnSetColumnName(panelResult.getValue('BASIS_YYYY'));

			//초기화 시 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
			UniAppManager.setToolbarButtons('reset', true);
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
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



	//그리드 컬럼명 set / hidden처리
	function fnSetColumnName(provider) {
		if(provider != 0) {		//초기화
			var year = provider;
//			var year = provider - 2000;		//년도 콤보가 2000년 ~ 200
//			if(year == 0) {
//				year = '00';
//			}
			masterGrid.getColumn('AVG_AMOUNT').setText(year + '<t:message code="system.label.purchase.annualmean" default="년평균"/>');
		}
	}
};
</script>