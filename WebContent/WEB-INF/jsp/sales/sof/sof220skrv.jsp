<%--
'   프로그램명: 초도수주현황조회 (영업)
'   작   성   자: 시너지시스템즈 개발팀
'   최종수정자: PJW
'   최종수정일:
'   버	 전: OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof220skrv">
	<t:ExtComboStore comboType="BOR120" pgmId="sof220skrv"/>		<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store"/>
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel3 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel4 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >


var BsaCodeInfo = {
	gsMoneyUnit: '${gsMoneyUnit}'
};

function appMain() {
/* <<<<type>>>>
 *	uniQty			: 수량
 *	uniUnitPrice	: 단가
 *	uniPrice		: 금액(자사화폐)
 *	uniPercent		: 백분율(00.00)
 *	uniFC			: 금액(외화화폐)
 *	uniER			: 환율
 *	uniDate			: 날짜(2999.12.31)
 *	maxLength		: 입력가능한 최대 길이
 *	editable		: true --수정가능 여부
 *	allowBlank		: 필수 여부
 *	defaultValue	: 기본값
 *	comboType:'AU', comboCode:'B014' : 그리드 콤보 사용시
 */

	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,//true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items		: [{
			title		: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				value		: UserInfo.divCode,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				startFieldName	: 'ORDER_DATE_FR',
				endFieldName	: 'ORDER_DATE_TO',
				xtype			: 'uniDateRangefield',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_TO',newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_CODE', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_NAME', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_CODE', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_NAME', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup) {
						popup.setExtParam({'CUSTOM_TYPE':['1','3']});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
				name		: 'OUT_DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('OUT_DIV_CODE', newValue);
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
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.sodate" default="수주일"/>',
			startFieldName	: 'ORDER_DATE_FR',
			endFieldName	: 'ORDER_DATE_TO',
			xtype			: 'uniDateRangefield',
			allowBlank		: false,
			colspan			: 2,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_TO',newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_CODE', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_NAME', '');
						panelResult.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_NAME', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup) {
					popup.setExtParam({'CUSTOM_TYPE':['1','3']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
			name		: 'OUT_DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('OUT_DIV_CODE', newValue);
				}
			}
		}]
	});



	Unilite.defineModel('sof220skrvModel', {
		fields: [
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'ITEM_LEVEL1'	, text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'		, type: 'string'	,store: Ext.data.StoreManager.lookup('itemLeve1Store')},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.sales.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_Q'		, text: '초도수주량'		, type: 'uniQty'},
			{name: 'ORDER_O'		, text: '<t:message code="system.label.sales.soamount" default="수주액"/>'			, type: 'uniPrice'},
			{name: 'ORDER_DATE'		, text: '<t:message code="system.label.sales.sodate" default="수주일"/>'			, type: 'uniDate'},
			{name: 'ORDER_NUM'		, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'			, type: 'string'},
			{name: 'SER_NO'			, text: '<t:message code="system.label.sales.seq" default="순번"/>'				, type: 'integer'},
			{name: 'ORDER_MONTH'	, text: '수주월'		, type:'string'},
			{name: 'OUT_DIV_CODE'	, text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'	, type: 'string'	, comboType: 'BOR120'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('sof220skrvMasterStore1', {
		model	: 'sof220skrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼,상태바 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sof220skrvService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param = panelSearch.getValues();
			this.load({
				params: param
			});
		},
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
			}
		}
	});

	/** Master Grid 정의(Grid Panel),
	 * @type
	 */
	var masterGrid = Unilite.createGrid('sof220skrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: true,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			},
			excel: {
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: true,		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true
		}],
		columns: [
			{dataIndex: 'CUSTOM_CODE'	, width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'CUSTOM_NAME'	, width: 150},
			{dataIndex: 'ITEM_LEVEL1'	, width: 110},
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 200},
			{dataIndex: 'SPEC'			, width: 150},
			{dataIndex: 'ORDER_Q'		, width: 110, summaryType: 'sum'},
			{dataIndex: 'ORDER_O'		, width: 110, summaryType: 'sum'},
			{dataIndex: 'ORDER_DATE'	, width: 100},
			{dataIndex: 'ORDER_NUM'		, width: 120},
			{dataIndex: 'SER_NO'		, width: 80	, align: 'center'},
			{dataIndex: 'ORDER_MONTH'	, width: 100, align: 'center'},
			{dataIndex: 'OUT_DIV_CODE'	, width: 100}
		],
		listeners:{
		}
	});



	Unilite.Main({
		id			: 'sof220skrvApp',
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
			panelSearch.setValue('ORDER_DATE_FR', '20200101');
			panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_FR', '20200101');
			panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
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
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		}
	});
};
</script>