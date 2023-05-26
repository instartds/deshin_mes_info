<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa430skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa430skrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />			<!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" />			<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" />			<!-- 고객분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S007" />			<!--출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="B059" />			<!--과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="S017" />			<!--수금유형-->
	<t:ExtComboStore comboType="AU" comboCode="B004" />			<!--화폐단위-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
var BsaCodeinfo = {
	gsMoneyUnit : '${gsMoneyUnit}'
};
	/** Model 정의
	 */
	Unilite.defineModel('Ssa430skrvModel1', {
		fields: [
			{name: 'DIV_CODE'		,text:'<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'		,type:'string', comboType: 'BOR120'},
			{name: 'DIV_CODE_NAME'	,text:'<t:message code="system.label.sales.division" default="사업장"/>'			,type:'string', comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'	,text:'<t:message code="system.label.sales.client" default="고객코드"/>'			,type:'string'},
			{name: 'CUSTOM_NAME'	,text:'<t:message code="system.label.sales.client" default="고객"/>'				,type:'string'},
			{name: 'BASIS_AMT_O'	,text:'<t:message code="system.label.sales.lastdayar" default="전일미수"/>'			,type:'uniPrice'},
			{name: 'MONEY_UNIT'		,text:'<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'		,type:'string'},
			{name: 'COMP_CODE'		,text:'<t:message code="system.label.sales.compcode" default="법인코드"/>'			,type:'string'}
		]
	});

	Unilite.defineModel('Ssa430skrvModel2', {
		fields: [
			{name: 'SALE_CUSTOM_CODE'	,text:'SALE_CUSTOM_CODE'	,type:'string'},
			{name: 'SALE_CUSTOM_NAME'	,text:'고객'	,type:'string'},
			{name: 'SALE_MONTH'			,text:'<t:message code="system.label.sales.yearmonth" default="년월"/>'			,type:'string'},
			{name: 'SALE_DATE'			,text:'<t:message code="system.label.sales.date" default="일자"/>'				,type:'uniDate'},
			{name: 'INOUT_TYPE_DETAIL'	,text:'<t:message code="system.label.sales.issuetype" default="출고유형"/>'			,type:'string'},
			{name: 'ITEM_CODE'			,text:'<t:message code="system.label.sales.item" default="품목"/>'				,type:'string'},
			{name: 'ITEM_NAME'			,text:'<t:message code="system.label.sales.itemname" default="품목명"/>'			,type:'string'},
			{name: 'SPEC'				,text:'<t:message code="system.label.sales.spec" default="규격"/>'				,type:'string'},
			{name: 'SALE_UNIT'			,text:'<t:message code="system.label.sales.unit" default="단위"/>'				,type:'string', displayField: 'value'},
			{name: 'TRANS_RATE'			,text:'<t:message code="system.label.sales.containedqty" default="입수"/>'		,type:'string'},
			{name: 'SALE_Q'				,text:'<t:message code="system.label.sales.salesqty" default="매출량"/>'			,type:'uniQty'},
			{name: 'SALE_AMT_O'			,text:'<t:message code="system.label.sales.salesamount" default="매출액"/>'		,type:'uniFC'},
			{name: 'TAX_TYPE'			,text:'<t:message code="system.label.sales.taxationyn" default="과세여부"/>'		,type:'string', comboType: "AU", comboCode: "B059"},
			{name: 'TAX_AMT_O'			,text:'<t:message code="system.label.sales.taxamount" default="세액"/>'			,type:'uniPrice'},
			{name: 'SUM_SALE_AMT'		,text:'<t:message code="system.label.sales.salestotal" default="매출계"/>'			,type:'uniFC'},
			{name: 'MONEY_UNIT'		    ,text:'<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'		,type:'string'},
			{name: 'COLLECT_AMT'		,text:'<t:message code="system.label.sales.collectionamount" default="수금액"/>'	,type:'uniFC'},
			{name: 'COLLECT_TYPE'		,text:'<t:message code="system.label.sales.collectiontype" default="수금유형"/>'	,type:'string'},
			{name: 'NOTE_DUE_DATE'		,text:'<t:message code="system.label.sales.duedate" default="만기일"/>'			,type:'uniDate'},
			{name: 'UN_COLLECT_AMT'		,text:'<t:message code="system.label.sales.dayuncollected" default="당일미수"/>'	,type:'uniFC'},
			{name: 'SALE_NAME'			,text:'<t:message code="system.label.sales.salename" default="영업담당"/>'	,type:'string'},
			{name: 'CARD_TYPE'			,text:'<t:message code="system.label.sales.card" default="카드여부"/>'				,type:'string'},
			{name: 'SALE_P'				,text:'<t:message code="system.label.sales.price" default="단가"/>'				,type:'uniUnitPrice'}
		]
	});



	/** Store 정의(Service 정의)
	 */
	var directMasterStore1 = Unilite.createStore('ssa430skrvMasterStore1',{
		model	: 'Ssa430skrvModel1',
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
				read: 'ssa430skrvService.selectList1'
			}
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
//			param.GS_MONEY_UNIT = BsaCodeinfo.gsMoneyUnit;
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField:  'COMP_CODE'
	});

	var directMasterStore2 = Unilite.createStore('ssa430skrvMasterStore2',{
		model	: 'Ssa430skrvModel2',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	:false,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'ssa430skrvService.selectList2'
			}
		},
		loadStoreRecords : function(param)	{
			this.load({
				params : param
			});
		},
		groupField:  'SALE_DATE',
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				if(records && records.length > 0){
					UniAppManager.setToolbarButtons('print', true);
				} else {
					UniAppManager.setToolbarButtons('print', false);
				}
			}
		}
	});



	/** 검색조건 (Search Panel)
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
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
						allowBlank	: true ,
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('DIV_CODE', newValue);
							}
						}
					},{
						fieldLabel		: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
						xtype			: 'uniDateRangefield',
						startFieldName	: 'BILL_FR_DATE',
						endFieldName	: 'BILL_TO_DATE',
						startDate		: UniDate.get('startOfMonth'),
						endDate			: UniDate.get('today'),
						onStartDateChange: function(field, newValue, oldValue, eOpts) {
							if(panelResult) {
								panelResult.setValue('BILL_FR_DATE', newValue);
							}
						},
						onEndDateChange: function(field, newValue, oldValue, eOpts) {
							if(panelResult) {
								panelResult.setValue('BILL_TO_DATE', newValue);
							}
						}
					},{
						fieldLabel	: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
						name		: 'AGENT_TYPE',
						xtype		: 'uniCombobox',
						comboType	: 'AU',
						comboCode	:'B055',
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('AGENT_TYPE', newValue);
							}
						}
					},{
						xtype		: 'radiogroup',
						fieldLabel	: '<t:message code="system.label.sales.tradeinclusionyn" default="무역포함여부"/>',
						items		: [{
							boxLabel	: '<t:message code="system.label.sales.notinclusion" default="포함안함"/>',
							name		: 'rdoSelect1',
							width		: 70,
							inputValue	: 'S',
							checked		: true
						},{
							boxLabel	: '<t:message code="system.label.sales.inclusion" default="포함"/>',
							name		: 'rdoSelect1' ,
							inputValue	: 'T'
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.getField('rdoSelect1').setValue(newValue.rdoSelect1);
								if(newValue.rdoSelect1 == "S"){
									panelSearch.setValue('MONEY_UNIT', '');
									panelSearch.getField("MONEY_UNIT").setDisabled(true);
									panelResult.setValue('MONEY_UNIT', '');
									panelResult.getField("MONEY_UNIT").setDisabled(true);
								}else{
									panelSearch.getField("MONEY_UNIT").setDisabled(false);
									panelResult.getField("MONEY_UNIT").setDisabled(false);
								}
								masterGrid1.reset();
								directMasterStore1.clearData();
								masterGrid2.reset();
								directMasterStore2.clearData();
								UniAppManager.setToolbarButtons('save',false);
							}
						}
					},
					Unilite.popup('AGENT_CUST',{
						fieldLabel		: '<t:message code="system.label.sales.client" default="고객"/>',
						validateBlank	: false,
						valueFieldName	: 'CUSTOM_CODE',
						textFieldName	: 'CUSTOM_NAME',
						listeners: {
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
					}),{
						fieldLabel	: '<t:message code="system.label.sales.area" default="지역"/>',
						name		: 'TXT_AREA_TYPE',
						xtype		: 'uniCombobox',
						comboType	: 'AU',
						comboCode	: 'B056',
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('TXT_AREA_TYPE', newValue);
							}
						}
					},{
						fieldLabel	: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>',
						name		: 'MONEY_UNIT',
						xtype		: 'uniCombobox',
						comboType	: 'AU',
						comboCode	: 'B004',
						displayField: 'value',
						fieldStyle	: 'text-align: center;',
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('MONEY_UNIT', newValue);
							}
						}
					}
				]
			}]
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r=false;
					var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				}
			}
			return r;
		}
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
			allowBlank	: true ,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'BILL_FR_DATE',
			endFieldName	: 'BILL_TO_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelSearch.setValue('BILL_FR_DATE', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelSearch.setValue('BILL_TO_DATE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
			name		: 'AGENT_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B055',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AGENT_TYPE', newValue);
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.sales.tradeinclusionyn" default="무역포함여부"/>',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.notinclusion" default="포함안함"/>',
				name		: 'rdoSelect1',
				width		: 70,
				inputValue	: 'S',
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.sales.inclusion" default="포함"/>',
				name		: 'rdoSelect1' ,
				inputValue	: 'T'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('rdoSelect1').setValue(newValue.rdoSelect1);
					if(newValue.rdoSelect1 == "S"){
						panelSearch.setValue('MONEY_UNIT', '');
						panelSearch.getField("MONEY_UNIT").setDisabled(true);
						panelResult.setValue('MONEY_UNIT', '');
						panelResult.getField("MONEY_UNIT").setDisabled(true);
					}else{
						panelSearch.getField("MONEY_UNIT").setDisabled(false);
						panelResult.getField("MONEY_UNIT").setDisabled(false);
					}
					masterGrid1.reset();
					directMasterStore1.clearData();
					masterGrid2.reset();
					directMasterStore2.clearData();
					UniAppManager.setToolbarButtons('save',false);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.client" default="고객"/>',
			validateBlank	: false,
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
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
		}),{
			fieldLabel	: '<t:message code="system.label.sales.area" default="지역"/>',
			name		: 'TXT_AREA_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B056',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXT_AREA_TYPE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>',
			name		: 'MONEY_UNIT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B004',
			displayField: 'value',
			fieldStyle	: 'text-align: center;',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('MONEY_UNIT', newValue);
				}
			}
		}], setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r=false;
					var labelText = ''

					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				}
			}
			return r;
		}
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('ssa430skrvGrid1', {
		store	: directMasterStore1,
		region	: 'center' ,
		layout	: 'fit',
		uniOpt	: {
			useLiveSearch		: true,
			useGroupSummary		: true,
			expandLastColumn	: false,
			onLoadSelectFirst	: true,		//체크박스모델은 false로 변경
			excel: {
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: true, 	//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		selModel: 'rowmodel',
		columns	: [
			{ dataIdex:'DIV_CODE'		, width:80	, hidden:true},
			{ dataIndex:'DIV_CODE_NAME'	, width:80	, hidden:false},
			{ dataIndex:'CUSTOM_CODE'	, width:66	, hidden:true},
			{ dataIndex:'CUSTOM_NAME'	, width:200,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex:'BASIS_AMT_O'	, width:93	,summaryType:'sum'},
			{ dataIndex:'MONEY_UNIT'	, width:110},
			{ dataIndex:'COMP_CODE'		, width:110	, hidden:true}
		],
		listeners : {
			selectionchange: function(grid, selected, eOpts) {
				this.setDetailGrd(selected, eOpts);
			}
		},
		setDetailGrd : function (selected, eOpts) {
			if(selected.length > 0) {
				var param = panelSearch.getValues();
				param.CUSTOM_CODE	= selected[selected.length-1].get('CUSTOM_CODE'),
				param.CUSTOM_NAME	= selected[selected.length-1].get('CUSTOM_NAME'),
				param.BASIS_AMT_O	= selected[selected.length-1].get('BASIS_AMT_O'),
				param.MONEY_UNIT	= selected[selected.length-1].get('MONEY_UNIT'),
				param.DIV_CODE		= selected[selected.length-1].get('DIV_CODE')
				var dgrid			= Ext.getCmp('ssa430skrvGrid2');
				dgrid.getStore().loadStoreRecords(param);
			}
		}
	});

	/** Master Grid2 정의(Grid Panel)
	 * @type
	 */
	var masterGrid2 = Unilite.createGrid('ssa430skrvGrid2', {
		store	: directMasterStore2,
		region	: 'east' ,
		layout	: 'fit',
		flex	: 4,
		itemId	: 'ssa430skrvGrid2',
		uniOpt	: {
			useLiveSearch	: true,
			useGroupSummary	: true,
			excel: {
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: true,		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns	: [
			{ dataIndex:'SALE_CUSTOM_CODE'	, width:80	, hidden:true},
			{ dataIndex:'SALE_CUSTOM_NAME'	, width:120},
			{ dataIndex:'SALE_MONTH'		, width:73	, hidden:true},
			{ dataIndex:'SALE_DATE'			, width:90	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.datesubtotal" default="날짜소계"/>', '<t:message code="system.label.sales.custtotal" default="고객총계"/>');
				}
			},
			{ dataIndex:'INOUT_TYPE_DETAIL'	, width:90},
			{ dataIndex:'ITEM_CODE'			, width:100},
			{ dataIndex:'ITEM_NAME'			, width:200},
			{ dataIndex:'SPEC'				, width:120},
			{ dataIndex:'SALE_UNIT'			, width:50},
			{ dataIndex:'TRANS_RATE'		, width:70},
			{ dataIndex:'SALE_Q'			, width:110	,summaryType:'sum'},
			{ dataIndex:'SALE_P'			, width:110	},
			{ dataIndex:'SALE_AMT_O'		, width:120	,summaryType:'sum'},
			{ dataIndex:'TAX_TYPE'			, width:70	,align: 'center' },
			{ dataIndex:'TAX_AMT_O'			, width:120	,summaryType:'sum'},
			{ dataIndex:'SUM_SALE_AMT'		, width:120	,summaryType:'sum'},
			{ dataIndex:'MONEY_UNIT'	    , width:80},
			{ dataIndex:'COLLECT_AMT'		, width:120	,summaryType:'sum'},
			{ dataIndex:'COLLECT_TYPE'		, width:106	, hidden:true},
			{ dataIndex:'NOTE_DUE_DATE'		, width:80},
			{ dataIndex:'UN_COLLECT_AMT'	, width:133},
			{ dataIndex:'SALE_NAME'			, width:100},
			{ dataIndex:'CARD_TYPE'			, width:80	}
		]
	});



	Unilite.Main({
		id			: 'ssa430skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid1, masterGrid2
			]
		},
		panelSearch
		],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('BILL_FR_DATE'	, UniDate.get('startOfMonth'));
			panelResult.setValue('BILL_FR_DATE'	, UniDate.get('startOfMonth'));
			panelSearch.setValue('BILL_TO_DATE'	, UniDate.get('today'));
			panelResult.setValue('BILL_TO_DATE'	, UniDate.get('today'));
			panelSearch.getField('rdoSelect1').setValue("S");
			panelResult.getField('rdoSelect1').setValue("S");
			panelSearch.getField("MONEY_UNIT").setDisabled(true);
			panelResult.getField("MONEY_UNIT").setDisabled(true);
			UniAppManager.setToolbarButtons('reset'	, true);
			UniAppManager.setToolbarButtons('save'	, false);
		},
		onQueryButtonDown : function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			masterGrid2.getStore().loadData({});
			directMasterStore1.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset'	, true);
			UniAppManager.setToolbarButtons('save'	, false);
		},
		onResetButtonDown : function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid1.getStore().loadData({});
			masterGrid2.getStore().loadData({});

			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
			var win;
			var masterGrid = masterGrid1.getSelectedRecord();
			if(Ext.isEmpty(masterGrid) || masterGrid2.getStore().length ==0) {
				Unilite.messageBox('<t:message code="system.message.sales.message140" default="출력할 데이터가 없습니다."/>')
				return false;
			}
			var param = panelSearch.getValues();
			if(Ext.isEmpty(param.CUSTOM_CODE)) {
				param.CUSTOM_CODE = masterGrid.get('CUSTOM_CODE');
			};
			param.MONEY_UNIT = masterGrid.get('MONEY_UNIT');
			win = Ext.create('widget.ClipReport', {
				url		: CPATH + '/sales/ssa430clskrv.do',
				prgID	: 'ssa430skrv',
				extParam: param
			});
			win.center();
			win.show();
		}
	});
};
</script>