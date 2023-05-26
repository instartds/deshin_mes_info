<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa461skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa461skrv" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" />			<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />			<!--영업담당 -->
</t:appConfig>
<script type="text/javascript" >


function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Ssa461skrvModel1', {
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'	,comboType: "BOR120"},
			{name: 'AGENT_TYPE'		,text:'<t:message code="system.label.sales.clienttype" default="고객분류"/>'	,type: 'string'	,comboType: "AU", comboCode: "B055"},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'	,type: 'string'},
			{name: 'ITEM_ACCOUNT'	,text: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>'	,type: 'string'	, comboType:'AU', comboCode:'B020'},			{name: 'SALE_PRSN'		,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,type: 'string'	,comboType: "AU", comboCode: "S010"},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'SPEC'			,text:'<t:message code="system.label.sales.spec" default="규격"/>'			,type: 'string'},
			{name: 'SALE_Q'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'},
			{name: 'SALE_AMT_O'		,text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'	,type: 'uniPrice'},
			{name: 'TAX_AMT_O'		,text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'	,type: 'uniPrice'},
			{name: 'SALE_TOT_O'		,text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'	,type: 'uniPrice'},
			{name: 'SALES_RATIO'	,text: '<t:message code="system.label.sales.salesratio" default="매출비율"/>'	,type: 'uniPercent'},
			{name: 'RANKING'		,text: '<t:message code="system.label.sales.ranking" default="순위"/>'		,type: 'int'},
			{name: 'SALE_PRSN'		,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,type: 'string'	,comboType: "AU", comboCode: "S010"},
			{name: 'SALE_COST_AMT'	,text: '<t:message code="system.label.sales.salescostII" default="매출원가"/>'	,type: 'uniPrice'},
			{name: 'GROSS_PROFIT'	,text: '<t:message code="system.label.sales.salesprofit" default="매출이익"/>'	,type: 'uniPrice'},
			{name: 'PROFIT_RATE'	,text: '<t:message code="system.label.sales.profitrate" default="이익율"/>'	,type: 'uniPercent'},
			{name: 'RANKING2'		,text: '<t:message code="system.label.sales.ranking" default="순위"/>'		,type: 'int'},
			{name: 'SALE_LOC_AMT_I'	,text: '<t:message code="system.label.sales.cosalesamount" default="자사매출액"/>'	, type: 'uniPrice', defaultValue: '0'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('ssa461skrvMasterStore1',{
		model	: 'Ssa461skrvModel1',
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
				read: 'ssa461skrvService.selectList'
			}
		},
		loadStoreRecords: function(activeTabId) {
			var param= Ext.getCmp('searchForm').getValues();
			if(!Ext.isEmpty(activeTabId)) {
				param.ACTIVE_TAB = activeTabId;
			}
			this.load({
				params	: param,
				callback: function(records, operation, success) {
					if(success)	{
					}
				}
			});
		},
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				if(records && records.length > 0){
					var activeTabId = tab.getActiveTab().getId();
					if(activeTabId == 'tab1_custom') {
						masterGrid1.setShowSummaryRow(true);
					} else if(activeTabId == 'tab2_item') {
						masterGrid2.setShowSummaryRow(true);
					}
				}
			}
		},
		groupField: 'AGENT_TYPE'
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
		items: [{
			title	: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId	: 'search_panel1',
			layout	: {type: 'vbox', align: 'stretch'},
			items	: [{
				xtype	: 'container',
				layout	: {type: 'uniTable', columns:1},
				items	: [{
					fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					value		: UserInfo.divCode,
					allowBlank	: false,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							var field = panelResult.getField('SALE_PRSN');
							field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel		: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
					xtype			: 'uniDateRangefield',
					startFieldName	: 'SALE_FR_DATE',
					endFieldName	: 'SALE_TO_DATE',
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
					allowBlank		: false,
					width			: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('SALE_FR_DATE',newValue);
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('SALE_TO_DATE',newValue);
						}
					}
				},
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
					valueFieldName	: 'SALE_CUSTOM_CODE',
					textFieldName	: 'SALE_CUSTOM_NAME',
					validateBlank	: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('SALE_CUSTOM_CODE', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('SALE_CUSTOM_NAME', '');
								panelResult.setValue('SALE_CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('SALE_CUSTOM_NAME', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('SALE_CUSTOM_CODE', '');
								panelResult.setValue('SALE_CUSTOM_CODE', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER'	: ['1', '3']});
							popup.setExtParam({'CUSTOM_TYPE'		: ['1', '3']});
						}
					}
				}),{
					fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
					name		: 'SALE_PRSN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'S010',
					multiSelect	: true,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('SALE_PRSN', newValue);
						}
					},
					onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
						if(eOpts){
							combo.filterByRefCode('refCode1', newValue, eOpts.parent);
						}else{
							combo.divFilterByRefCode('refCode1', newValue, divCode);
						}
					}
				},
				Unilite.popup('DIV_PUMOK', {
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
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelSearch.getField('SALE_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'SALE_FR_DATE',
			endFieldName	: 'SALE_TO_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			allowBlank		: false,
			width			: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('SALE_FR_DATE',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('SALE_TO_DATE',newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'SALE_CUSTOM_CODE',
			textFieldName	: 'SALE_CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('SALE_CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('SALE_CUSTOM_NAME', '');
						panelResult.setValue('SALE_CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('SALE_CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('SALE_CUSTOM_CODE', '');
						panelResult.setValue('SALE_CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1', '3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1', '3']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			multiSelect	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SALE_PRSN', newValue);
				}
			},
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
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
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
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



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('ssa461skrvGrid1', {
		store	: directMasterStore,
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
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
		columns	: [
			{dataIndex: 'DIV_CODE'		, width: 93		, hidden: true},
			{dataIndex: 'AGENT_TYPE'	, width: 93		, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData
						 , '<t:message code="system.label.sales.totalbyclienttype" default="고객분류계"/>', '<t:message code="system.label.sales.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'CUSTOM_CODE'	, width: 120},
			{dataIndex: 'CUSTOM_NAME'	, width: 150},
			{dataIndex: 'SALE_Q'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_O'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'TAX_AMT_O'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_TOT_O'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_LOC_AMT_I', width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALES_RATIO'	, width: 100},
			{dataIndex: 'RANKING'		, width: 100},
			{dataIndex: 'SALE_PRSN'		, width: 100},
			{dataIndex: 'SALE_COST_AMT'	, width: 100},
			{dataIndex: 'GROSS_PROFIT'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'PROFIT_RATE'	, width: 100},
			{dataIndex: 'RANKING2'		, width: 100}
		],
		listeners: {
			selectionchange:function( grid, selection, eOpts ) {
			}
		}
	});
	var masterGrid2 = Unilite.createGrid('ssa461skrvGrid2', {
		store	: directMasterStore,
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
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
		columns	: [
			{dataIndex: 'DIV_CODE'		, width: 93		, hidden: true},
			{dataIndex: 'ITEM_ACCOUNT'	, width: 93		, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData
						 , '<t:message code="system.label.sales.totalbyitemaccount" default="품목계정계"/>', '<t:message code="system.label.sales.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 150},
			{dataIndex: 'SPEC'			, width: 110},
			{dataIndex: 'SALE_Q'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_O'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'TAX_AMT_O'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALE_TOT_O'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'SALES_RATIO'	, width: 100},
			{dataIndex: 'RANKING'		, width: 100},
			{dataIndex: 'SALE_COST_AMT'	, width: 100},
			{dataIndex: 'GROSS_PROFIT'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'PROFIT_RATE'	, width: 100},
			{dataIndex: 'RANKING2'		, width: 100}
		],
		listeners: {
			selectionchange:function( grid, selection, eOpts ) {
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
			title	: '<t:message code="system.label.sales.item" default="품목"/>',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [masterGrid2],
			id		: 'tab2_item'
		}],
		listeners	: {
			beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts ) {
			},
			tabChange: function ( tabPanel, newCard, oldCard, eOpts ) {
				var activeTabId = tab.getActiveTab().getId();
				directMasterStore.loadData({})
				fnSetColumn(activeTabId);
			}
		}
	});



	Unilite.Main( {
		id			: 'ssa461skrvApp',
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
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('SALE_FR_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('SALE_TO_DATE', UniDate.get('today'));

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('SALE_FR_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('SALE_TO_DATE', UniDate.get('today'));

			var pCombo	= panelSearch.getField('DIV_CODE');
			var combo 	= panelSearch.getField('SALE_PRSN').filterByRefCode('refCode1', pCombo.getValue(), pCombo);

			var field = panelSearch.getField('SALE_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field = panelResult.getField('SALE_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			//최초 포커스 설정
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
			var activeTabId = tab.getActiveTab().getId();
			directMasterStore.loadStoreRecords(activeTabId);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			directMasterStore.loadData({})
			this.fnInitBinding();
		}
	});


	//탭변경에 따른 store setting
	function fnSetColumn(activeTabId) {
		if(activeTabId == 'tab1_custom') {
			directMasterStore.setGroupField('AGENT_TYPE');
		} else if(activeTabId == 'tab2_item') {
			directMasterStore.setGroupField('ITEM_ACCOUNT');
		}
	}
};
</script>