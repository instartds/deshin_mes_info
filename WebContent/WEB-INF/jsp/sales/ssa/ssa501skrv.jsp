<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa501skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa501skrv" />	<!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" />			<!-- 품목계정 -->
    <t:ExtComboStore comboType="AU" comboCode="B055" />			<!-- 고객분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />			<!-- 영업담당 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
var BsaCodeInfo = {
	gsSalesPrsn: '${gsSalesPrsn}'		//로그인 한 유저의 영업담당자 정보
};
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('ssa501skrvModel', {
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'	,comboType: "BOR120"},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'	,type: 'string'},
			{name: 'TAX_TYPE'	,text: '<t:message code="system.label.base.taxtype" default="세구분"/>'	,type: 'string',comboType: "AU", comboCode: "B059"},
			{name: 'AGENT_TYPE'		,text: '<t:message code="system.label.sales.clienttype" default="고객분류"/>'	,type: 'string'	,comboType: "AU", comboCode: "B055"},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.sales.spec" default="규격"/>'			,type: 'string'},
			{name: 'ITEM_ACCOUNT'	,text: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>'	,type: 'string'	, comboType:'AU', comboCode:'B020'},			{name: 'SALE_PRSN'		,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,type: 'string'	,comboType: "AU", comboCode: "S010"},
			{name: 'PROJECT_NO'		,text: '<t:message code="system.label.sales.project" default="프로젝트"/>'		,type: 'string'},
			{name: 'TOT_AMT'		,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'	,type: 'uniPrice'},
			{name: 'SALE_AMT_01'	,text: '<t:message code="system.label.sales.january" default="1월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_02'	,text: '<t:message code="system.label.sales.february" default="2월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_03'	,text: '<t:message code="system.label.sales.march" default="3월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_04'	,text: '<t:message code="system.label.sales.april" default="4월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_05'	,text: '<t:message code="system.label.sales.may" default="5월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_06'	,text: '<t:message code="system.label.sales.june" default="6월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_07'	,text: '<t:message code="system.label.sales.july" default="7월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_08'	,text: '<t:message code="system.label.sales.august" default="8월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_09'	,text: '<t:message code="system.label.sales.september" default="9월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_10'	,text: '<t:message code="system.label.sales.october" default="10월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_11'	,text: '<t:message code="system.label.sales.november" default="11월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_12'	,text: '<t:message code="system.label.sales.december" default="12월"/>'		,type: 'uniPrice'},
			//20191111 거래처/품목 탭 추가 관련
			{name: 'TOT_AMT_5'		,text: '<t:message code="system.label.sales.amount" default="금액"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_01_5'	,text: '<t:message code="system.label.sales.amount" default="금액"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_02_5'	,text: '<t:message code="system.label.sales.amount" default="금액"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_03_5'	,text: '<t:message code="system.label.sales.amount" default="금액"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_04_5'	,text: '<t:message code="system.label.sales.amount" default="금액"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_05_5'	,text: '<t:message code="system.label.sales.amount" default="금액"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_06_5'	,text: '<t:message code="system.label.sales.amount" default="금액"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_07_5'	,text: '<t:message code="system.label.sales.amount" default="금액"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_08_5'	,text: '<t:message code="system.label.sales.amount" default="금액"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_09_5'	,text: '<t:message code="system.label.sales.amount" default="금액"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_10_5'	,text: '<t:message code="system.label.sales.amount" default="금액"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_11_5'	,text: '<t:message code="system.label.sales.amount" default="금액"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_12_5'	,text: '<t:message code="system.label.sales.amount" default="금액"/>'			,type: 'uniPrice'},
			{name: 'TOT_QTY_5'		,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'},
			{name: 'SALE_QTY_01_5'	,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'},
			{name: 'SALE_QTY_02_5'	,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'},
			{name: 'SALE_QTY_03_5'	,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'},
			{name: 'SALE_QTY_04_5'	,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'},
			{name: 'SALE_QTY_05_5'	,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'},
			{name: 'SALE_QTY_06_5'	,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'},
			{name: 'SALE_QTY_07_5'	,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'},
			{name: 'SALE_QTY_08_5'	,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'},
			{name: 'SALE_QTY_09_5'	,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'},
			{name: 'SALE_QTY_10_5'	,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'},
			{name: 'SALE_QTY_11_5'	,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'},
			{name: 'SALE_QTY_12_5'	,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('ssa501skrvMasterStore1', {
		model	: 'ssa501skrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'ssa501skrvService.selectList'
			}
		},
		loadStoreRecords: function(activeTabId) {
			var param = Ext.getCmp('searchForm').getValues();
			if(!Ext.isEmpty(activeTabId)) {
				param.ACTIVE_TAB = activeTabId;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		} ,
		groupField: 'DIV_CODE'
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
			title		: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				value		: UserInfo.divCode,
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						field.changeDivCode(field, newValue, oldValue, eOpts);
						var field = panelResult.getField('SALE_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.baseyear" default="기준년도"/>',
				xtype		: 'uniYearField',
				name		: 'BASIS_YEAR',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BASIS_YEAR', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name		: 'SALE_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010',
				multiSelect	: true,
				typeAhead	: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SALE_PRSN', newValue);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					} else {
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},{	//20191111 부가세 포함여부 추가: 기본값 미포함
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 2},
				items	: [{
					xtype		: 'radiogroup',
					fieldLabel	: '<t:message code="system.label.sales.taxincludedflag2" default="부가세포함여부"/>',
					name		: 'TAX_YN',
					items		: [{
						boxLabel	: '<t:message code="system.label.sales.notinclustion" default="미포함"/>',
						name		: 'TAX_YN',
						inputValue	: 'N',
						holdable	: 'hold',
						width		: 80
					},{
						boxLabel	: '<t:message code="system.label.sales.inclusion" default="포함"/>',
						name		: 'TAX_YN',
						inputValue	: 'Y',
						width		: 80,
						holdable	: 'hold'
					}],
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TAX_YN', newValue.TAX_YN);
						}
					}
				}]
			},
			Unilite.popup('AGENT_CUST',{
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
					}
				}
			}),
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners: {
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
			Unilite.popup('PROJECT',{
				fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
				valueFieldName	: 'PROJECT_NO',
				textFieldName	: 'PROJECT_NAME',
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName	: 'PJT_NAME',
				validateBlank	: false,
				textFieldOnly	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PROJECT_NO', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('PROJECT_NAME', newValue);
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.sales.domesticoverseasclass" default="국내외구분"/>',
				name		: 'NATION_INOUT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B019',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('NATION_INOUT', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			holdable	: 'hold',
			value		: UserInfo.divCode,
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					field.changeDivCode(field, newValue, oldValue, eOpts);
					var field = panelSearch.getField('SALE_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.baseyear" default="기준년도"/>',
			xtype		: 'uniYearField',
			name		: 'BASIS_YEAR',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BASIS_YEAR', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			multiSelect	: true,
			typeAhead	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SALE_PRSN', newValue);
				}
			},
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},{	//20191111 부가세 포함여부 추가: 기본값 미포함
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			items	: [{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.taxincludedflag2" default="부가세포함여부"/>',
				name		: 'TAX_YN',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.notinclustion" default="미포함"/>',
					name		: 'TAX_YN',
					inputValue	: 'N',
					holdable	: 'hold',
					width		: 80
				},{
					boxLabel	: '<t:message code="system.label.sales.inclusion" default="포함"/>',
					name		: 'TAX_YN',
					inputValue	: 'Y',
					width		: 80,
					holdable	: 'hold'
				}],
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('TAX_YN', newValue.TAX_YN);
					}
				}
			}]
		},
		Unilite.popup('AGENT_CUST',{
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
				}
			}
		}),
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
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
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			valueFieldName	: 'PROJECT_NO',
			textFieldName	: 'PROJECT_NAME',
			DBvalueFieldName: 'PJT_CODE',
			DBtextFieldName	: 'PJT_NAME',
			validateBlank	: false,
			textFieldOnly	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PROJECT_NO', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('PROJECT_NAME', newValue);
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.domesticoverseasclass" default="국내외구분"/>',
			name		: 'NATION_INOUT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B019',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('NATION_INOUT', newValue);
				}
			}
		}]
	});



	/** masterGrid Grid1 정의(Grid Panel) - 동일 model / store 사용
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('ssa501skrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			filter				: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		features: [
			{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'DIV_CODE'		, width: 93		, hidden: true},
			{dataIndex: 'CUSTOM_CODE'	, width: 120	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData
						 , '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'CUSTOM_NAME'	, width: 150},
			{dataIndex: 'AGENT_TYPE'	, width: 80		, hidden: true},
			{dataIndex: 'SALE_PRSN'		, width: 80		, hidden: true},
			{dataIndex: 'TOT_AMT'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_01'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_02'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_03'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_04'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_05'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_06'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_07'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_08'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_09'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_10'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_11'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_12'	, width: 100	, summaryType: 'sum'}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		}
	});
	var masterGrid2 = Unilite.createGrid('ssa501skrvGrid2', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			filter				: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		features: [
			{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'DIV_CODE'		, width: 93		, hidden: true},
			{dataIndex: 'ITEM_CODE'		, width: 120	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData
						 , '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'ITEM_NAME'		, width: 150	},
			{dataIndex: 'SPEC'			, width: 80		, hidden: true},
			{dataIndex: 'ITEM_ACCOUNT'	, width: 80		, hidden: true},
			{dataIndex: 'TOT_AMT'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_01'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_02'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_03'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_04'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_05'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_06'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_07'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_08'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_09'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_10'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_11'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_12'	, width: 100	, summaryType: 'sum'}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		}
	});
	var masterGrid3 = Unilite.createGrid('ssa501skrvGrid3', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			filter				: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		features: [
			{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'DIV_CODE'		, width: 93		, hidden: true},
			{dataIndex: 'SALE_PRSN'		, width: 100	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData
						 , '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'TOT_AMT'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_01'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_02'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_03'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_04'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_05'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_06'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_07'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_08'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_09'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_10'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_11'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_12'	, width: 100	, summaryType: 'sum'}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		}
	});
	var masterGrid4 = Unilite.createGrid('ssa501skrvGrid4', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			filter				: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		features: [
			{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'DIV_CODE'		, width: 93		, hidden: true},
			{dataIndex: 'PROJECT_NO'	, width: 100	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData
						 , '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'TOT_AMT'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_01'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_02'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_03'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_04'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_05'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_06'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_07'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_08'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_09'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_10'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_11'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_12'	, width: 100	, summaryType: 'sum'}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		}
	});
	var masterGrid5 = Unilite.createGrid('ssa501skrvGrid5', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			filter				: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		features: [
			{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'DIV_CODE'		, width: 93		, hidden: true},
			{dataIndex: 'AGENT_TYPE'	, width: 80		, hidden: true},
			{dataIndex: 'CUSTOM_CODE'	, width: 120	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData
						, '<t:message code="system.label.sales.customsubtotal" default="거래처계"/>', '<t:message code="system.label.sales.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'CUSTOM_NAME'	, width: 150},
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 150},
			{dataIndex: 'SPEC'			, width: 80		, hidden: true},
			{dataIndex: 'SALE_PRSN'		, width: 80		, hidden: true},
			{text: '<t:message code="system.label.sales.totalamount" default="합계"/>',
				columns: [
					{dataIndex: 'TOT_QTY_5'	, width: 100	, summaryType: 'sum'},
					{dataIndex: 'TOT_AMT_5'	, width: 100	, summaryType: 'sum'}
				]
			},
			{text: '<t:message code="system.label.sales.january" default="1월"/>',
				columns: [
					{dataIndex: 'SALE_QTY_01_5'	, width: 100	, summaryType: 'sum'},
					{dataIndex: 'SALE_AMT_01_5'	, width: 100	, summaryType: 'sum'}
				]
			},
			{text: '<t:message code="system.label.sales.february" default="2월"/>',
				columns: [
					{dataIndex: 'SALE_QTY_02_5'	, width: 100	, summaryType: 'sum'},
					{dataIndex: 'SALE_AMT_02_5'	, width: 100	, summaryType: 'sum'}
				]
			},
			{text: '<t:message code="system.label.sales.march" default="3월"/>',
				columns: [
					{dataIndex: 'SALE_QTY_03_5'	, width: 100	, summaryType: 'sum'},
					{dataIndex: 'SALE_AMT_03_5'	, width: 100	, summaryType: 'sum'}
				]
			},
			{text: '<t:message code="system.label.sales.april" default="4월"/>',
				columns: [
					{dataIndex: 'SALE_QTY_04_5'	, width: 100	, summaryType: 'sum'},
					{dataIndex: 'SALE_AMT_04_5'	, width: 100	, summaryType: 'sum'}
				]
			},
			{text: '<t:message code="system.label.sales.may" default="5월"/>',
				columns: [
					{dataIndex: 'SALE_QTY_05_5'	, width: 100	, summaryType: 'sum'},
					{dataIndex: 'SALE_AMT_05_5'	, width: 100	, summaryType: 'sum'}
				]
			},
			{text: '<t:message code="system.label.sales.june" default="6월"/>',
				columns: [
					{dataIndex: 'SALE_QTY_06_5'	, width: 100	, summaryType: 'sum'},
					{dataIndex: 'SALE_AMT_06_5'	, width: 100	, summaryType: 'sum'}
				]
			},
			{text: '<t:message code="system.label.sales.july" default="7월"/>',
				columns: [
					{dataIndex: 'SALE_QTY_07_5'	, width: 100	, summaryType: 'sum'},
					{dataIndex: 'SALE_AMT_07_5'	, width: 100	, summaryType: 'sum'}
				]
			},
			{text: '<t:message code="system.label.sales.august" default="8월"/>',
				columns: [
					{dataIndex: 'SALE_QTY_08_5'	, width: 100	, summaryType: 'sum'},
					{dataIndex: 'SALE_AMT_08_5'	, width: 100	, summaryType: 'sum'}
				]
			},
			{text: '<t:message code="system.label.sales.september" default="9월"/>',
				columns: [
					{dataIndex: 'SALE_QTY_09_5'	, width: 100	, summaryType: 'sum'},
					{dataIndex: 'SALE_AMT_09_5'	, width: 100	, summaryType: 'sum'}
				]
			},
			{text: '<t:message code="system.label.sales.october" default="10월"/>',
				columns: [
					{dataIndex: 'SALE_QTY_10_5'	, width: 100	, summaryType: 'sum'},
					{dataIndex: 'SALE_AMT_10_5'	, width: 100	, summaryType: 'sum'}
				]
			},
			{text: '<t:message code="system.label.sales.november" default="11월"/>',
				columns: [
					{dataIndex: 'SALE_QTY_11_5'	, width: 100	, summaryType: 'sum'},
					{dataIndex: 'SALE_AMT_11_5'	, width: 100	, summaryType: 'sum'}
				]
			},
			{text: '<t:message code="system.label.sales.december" default="12월"/>',
				columns: [
					{dataIndex: 'SALE_QTY_12_5'	, width: 100	, summaryType: 'sum'},
					{dataIndex: 'SALE_AMT_12_5'	, width: 100	, summaryType: 'sum'}
				]
			}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		}
	});
	var masterGrid6 = Unilite.createGrid('ssa501skrvGrid6', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			filter				: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		features: [
			{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'DIV_CODE'		, width: 93		, hidden: true},
			{dataIndex: 'CUSTOM_CODE'	, width: 120	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData
						 , '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'CUSTOM_NAME'	, width: 150},
			{dataIndex: 'TAX_TYPE'	, width: 80},
			{dataIndex: 'AGENT_TYPE'	, width: 80		, hidden: true},
			{dataIndex: 'SALE_PRSN'		, width: 80		, hidden: true},
			{dataIndex: 'TOT_AMT'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_01'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_02'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_03'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_04'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_05'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_06'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_07'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_08'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_09'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_10'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_11'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_12'	, width: 100	, summaryType: 'sum'}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		}
	});


	var tab = Unilite.createTabPanel('tabPanel',{
		region		: 'center',
		activeTab	: 0,
		items		: [{
			title	: '<t:message code="system.label.sales.custom" default="거래처"/>',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [masterGrid1],
			id		: 'tab1_custom'
		},{
			title	: '<t:message code="system.label.sales.custom" default="거래처"/>(<t:message code="system.label.base.taxtype" default="세구분"/>)',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [masterGrid6],
			id		: 'tab6_customTaxType'
		},{
			title	: '<t:message code="system.label.sales.item" default="품목"/>',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [masterGrid2],
			id		: 'tab2_item'
		},{
			title	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [masterGrid3],
			id		: 'tab3_salePrsn'
		},{
			title	: '<t:message code="system.label.sales.project" default="프로젝트"/>',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [masterGrid4],
			id		: 'tab4_project'
		},{
			title	: '<t:message code="system.label.sales.custom" default="거래처"/>/<t:message code="system.label.sales.item" default="품목"/>',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [masterGrid5],
			id		: 'tab5_customItem'
		}],
		listeners	: {
			beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts ) {
				if(UniAppManager.app._needSave()) {
					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
						UniAppManager.app.onSaveDataButtonDown();
						return false;
					} else {
						return false;
					}
				}
			},
			tabChange: function ( tabPanel, newCard, oldCard, eOpts ) {
				var activeTabId = tab.getActiveTab().getId();
				directMasterStore.loadData({})
				fnSetColumn(activeTabId);
			}
		}
	});



	Unilite.Main({
		id			: 'ssa501skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				tab, panelResult
			]
		},
		panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('BASIS_YEAR'	, new Date().getFullYear());
			//20191111 부가세 포함여부 추가: 기본값 미포함
			panelSearch.setValue('TAX_YN'		, 'N');
			//20200212 추가: 조회조건 국내외 구분 추가
			panelSearch.getField('NATION_INOUT').setValue('1');

			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('BASIS_YEAR'	, new Date().getFullYear());
			//20191111 부가세 포함여부 추가: 기본값 미포함
			panelResult.setValue('TAX_YN'		, 'N');
			//20200212 추가: 조회조건 국내외 구분 추가
			panelResult.getField('NATION_INOUT').setValue('1');

			var pCombo	= panelSearch.getField('DIV_CODE');
			var combo 	= panelSearch.getField('SALE_PRSN').filterByRefCode('refCode1', pCombo.getValue(), pCombo);

			var field = panelSearch.getField('SALE_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field = panelResult.getField('SALE_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			panelSearch.setValue('SALE_PRSN'	, BsaCodeInfo.gsSalesPrsn);
			panelResult.setValue('SALE_PRSN'	, BsaCodeInfo.gsSalesPrsn);

			//최초 포커스 설정
			var activeSForm ;
			var authoInfo = pgmInfo.authoUser;	//권한정보(N-전체,A-자기사업장>5-자기부서)
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
//			if(authoInfo == 'A') {
//				panelSearch.getField('DIV_CODE').setReadOnly(true);
//				panelResult.getField('DIV_CODE').setReadOnly(true);
//				activeSForm.onLoadSelectText('BASIS_YEAR');
//			} else {
				panelSearch.getField('DIV_CODE').setReadOnly(false);
				panelResult.getField('DIV_CODE').setReadOnly(false);
				activeSForm.onLoadSelectText('DIV_CODE');
//			}
		},
		onQueryButtonDown: function(activeTabId) {
			if(!this.isValidSearchForm()){
				return false;
			}
			if(Ext.isEmpty(activeTabId)) {
				var activeTabId = tab.getActiveTab().getId();
			}
			directMasterStore.loadStoreRecords(activeTabId);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			directMasterStore.loadData({});
			this.fnInitBinding();
		}
	});



	//탭변경에 따른 store setting
	function fnSetColumn(activeTabId) {
		if(activeTabId == 'tab1_custom') {
			directMasterStore.setGroupField('DIV_CODE');
		} else if(activeTabId == 'tab2_item') {
			directMasterStore.setGroupField('DIV_CODE');
		} else if(activeTabId == 'tab3_salePrsn') {
			directMasterStore.setGroupField('DIV_CODE');
		} else if(activeTabId == 'tab4_project') {
			directMasterStore.setGroupField('DIV_CODE');
		} else if(activeTabId == 'tab5_customItem') {
			directMasterStore.setGroupField('CUSTOM_CODE');
		} else if(activeTabId == 'tab6_customTaxType') {
			directMasterStore.setGroupField('DIV_CODE');
		}
	}
};
</script>