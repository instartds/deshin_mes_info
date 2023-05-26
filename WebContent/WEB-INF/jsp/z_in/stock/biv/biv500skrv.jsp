<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv500skrv">
	<t:ExtComboStore comboType="BOR120" pgmId="biv500skrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020"/>			<!-- 품목계정 --> 
	<t:ExtComboStore comboType="O" storeId="whList"/>			<!--창고(전체) -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {
};
var period1 = ${period1}	//RECEIVED_1 기간(개월 수)
var period2 = ${period2}	//RECEIVED_2 기간(개월 수)
var period3 = ${period3}	//RECEIVED_3 기간(개월 수)
var period4 = ${period4}	//RECEIVED_4 기간(개월 수)

function appMain() {
	/** Model 정의 
	 * @type
	 */
	Unilite.defineModel('biv500skrvModel', {
		fields: [
			{name: 'COMP_CODE',				text: 'COMP_CODE',	type:'string'},
			{name: 'DIV_CODE',				text: 'DIV_CODE',	type:'string'},
			{name: 'ITEM_CODE',				text: '<t:message code="system.label.inventory.item" default="품목"/>',			type:'string'},
			{name: 'ITEM_NAME',				text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',		type:'string'},
			{name: 'SPEC',					text: '<t:message code="system.label.inventory.spec" default="규격"/>',			type:'string'},
			{name: 'AVERAGE_P',				text: '<t:message code="system.label.inventory.price" default="단가"/>',			type:'uniUnitPrice'},
			{name: 'STOCK_Q',				text: '<t:message code="system.label.inventory.onhandstock" default="현재고"/>',	type:'uniQty'},
			//기간별 입고수량
			{name: 'RECEIVED_1',			text: '<t:message code="system.label.inventory.good" default="양품"/>',			type:'uniQty'},
			{name: 'RECEIVED_2',			text: '<t:message code="system.label.inventory.good" default="양품"/>',			type:'uniQty'},
			{name: 'RECEIVED_3',			text: '<t:message code="system.label.inventory.good" default="양품"/>',			type:'uniQty'},
			{name: 'RECEIVED_4',			text: '<t:message code="system.label.inventory.good" default="양품"/>',			type:'uniQty'},
			//보유기간별 재고수량(일)
			{name: 'STOCK_QTY_90',			text: '< 90',		type:'uniQty'},
			{name: 'STOCK_QTY_90_TO_180',	text: '90 ~ 180',	type:'uniQty'},
			{name: 'STOCK_QTY_181_TO_365',	text: '181 ~ 365',	type:'uniQty'},
			{name: 'STOCK_QTY_366_TO_730',	text: '366 ~ 730',	type:'uniQty'},
			{name: 'STOCK_QTY_730',			text: '> 730',		type:'uniQty'},
			{name: 'STOCK_QTY_TOTAL',		text: 'Total',		type:'uniQty'},
			//보유기간별 재고금액(일)
			{name: 'STOCK_AMT_90',			text: '< 90',		type:'uniPrice'},
			{name: 'STOCK_AMT_90_TO_180',	text: '90 ~ 180',	type:'uniPrice'},
			{name: 'STOCK_AMT_181_TO_365',	text: '181 ~ 365',	type:'uniPrice'},
			{name: 'STOCK_AMT_366_TO_730',	text: '366 ~ 730',	type:'uniPrice'},
			{name: 'STOCK_AMT_730',			text: '> 730',		type:'uniPrice'},
			{name: 'STOCK_AMT_TOTAL',		text: 'Total',		type:'uniPrice'},
			//Provision(366~730) > No Demand
			{name: 'NO_DEMAND_QTY',			text: 'Qty',		type:'uniQty'},
			{name: 'NO_DEMAND_AMT',			text: 'Amt',		type:'uniPrice'},
			//6개월 미만
			{name: 'PROVISON_180_QTY',		text: 'Qty',		type:'uniQty'},
			{name: 'PROVISON_180_AMT',		text: 'Amt',		type:'uniPrice'},
			//12개월 미만
			{name: 'PROVISON_365_QTY',		text: 'Qty',		type:'uniQty'},
			{name: 'PROVISON_365_AMT',		text: 'Amt',		type:'uniPrice'},
			//2년 미만
			{name: 'PROVISON_730_QTY',		text: 'Qty',		type:'uniQty'},
			{name: 'PROVISON_730_AMT',		text: 'Amt',		type:'uniPrice'},
			//2년 이상
			{name: 'PROVISON_730_OVER_QTY',	text: 'Qty',		type:'uniQty'},
			{name: 'PROVISON_730_OVER_AMT',	text: 'Amt',		type:'uniPrice'}
		]
	});

	Unilite.defineModel('biv500skrvModel2', {
		fields: [
			{name: 'COMP_CODE',			text: 'COMP_CODE',	type:'string'},
			{name: 'DIV_CODE',			text: 'DIV_CODE',	type:'string'},
			{name: 'ITEM_CODE',			text: '<t:message code="system.label.inventory.item" default="품목"/>',			type:'string'},
			{name: 'ITEM_NAME',			text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',		type:'string'},
			{name: 'SPEC',				text: '<t:message code="system.label.inventory.spec" default="규격"/>',			type:'string'},
			{name: 'AVERAGE_P',			text: '<t:message code="system.label.inventory.price" default="단가"/>',			type:'uniUnitPrice'},
			{name: 'STOCK_Q',			text: '<t:message code="system.label.inventory.onhandstock" default="현재고"/>',	type:'uniQty'},
			{name: 'STOCK_QTY_01',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_02',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_03',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_04',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_05',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_06',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_07',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_08',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_09',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_10',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_11',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_12',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_13',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_14',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_15',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_16',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_17',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_18',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_19',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_20',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_21',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_22',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_23',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_24',		text: '',	type:'uniQty'},
			{name: 'STOCK_QTY_OVER',	text: '<t:message code="system.label.inventory.over2years" default="2년 이상"/>',	type:'uniQty'},
			{name: 'STOCK_QTY_TOTAL',	text: '<t:message code="system.label.inventory.totalamount" default="합계"/>',	type:'uniQty'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('biv500skrvMasterStore1',{
		model	: 'biv500skrvModel',
		uniOpt	: {
			isMaster	: false,	//상위 버튼 연결 
			editable	: false,	//수정 모드 사용 
			deletable	: false,	//삭제 가능 여부 
			useNavi		: false		//prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {read: 'biv500skrvService.selectList'}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
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
			}
		}
	});

	var directMasterStore2 = Unilite.createStore('biv500skrvMasterStore2',{
		model	: 'biv500skrvModel2',
		uniOpt	: {
			isMaster	: false,	//상위 버튼 연결 
			editable	: false,	//수정 모드 사용 
			deletable	: false,	//삭제 가능 여부 
			useNavi		: false		//prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {read: 'biv500skrvService.selectList2'}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
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
			}
		}
	});



	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title		: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
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
		items		: [{
			title		: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
 			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				comboCode	: 'B001',
				child		: 'WH_CODE',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.basisyearmonth" default="기준년월"/>',
				xtype		: 'uniMonthfield',
				name		: 'BASIS_MONTH',
				value		: new Date(),
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BASIS_MONTH', newValue);
						fnSetColumnName(newValue);
					}
				}
			},{
				boxLabel		: '<t:message code="system.label.inventory.inventoryqtywith0" default="재고수량 0포함"/>',
				xtype			: 'checkboxfield',
				name			: 'STOCK_YN',
	    		inputValue		: 'Y',
				uncheckedValue	: 'N',
				listeners		: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('STOCK_YN', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.inventory.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				autoPopup		: false,
				validateBlank	: false,
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
				name		: 'ITEM_ACCOUNT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				xtype	: 'container',
				layout	: {type : 'vbox', columns : 3},
				padding	: '0 0 3 0',
				items	: [{
					fieldLabel	: '<t:message code="system.label.inventory.itemgroup" default="품목분류"/>',
					name		: 'ITEM_LEVEL1',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
					child		: 'ITEM_LEVEL2',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_LEVEL1', newValue);
						}
					}
				},{
					fieldLabel	: ' ',
					name		: 'ITEM_LEVEL2',
					xtype		:'uniCombobox',
					store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
					child		: 'ITEM_LEVEL3',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_LEVEL2', newValue);
						}
					}
				},{
					fieldLabel	: ' ',
					name		: 'ITEM_LEVEL3',
					xtype		:'uniCombobox',
					store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_LEVEL3', newValue);
						}
					}
				}]
			}]
		}]
	});//End of var panelSearch

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	:true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			comboCode	: 'B001',
			child		: 'WH_CODE',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.inventory.basisyearmonth" default="기준년월"/>',
			xtype		: 'uniMonthfield',
			name		: 'BASIS_MONTH',
			value		: new Date(),
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BASIS_MONTH', newValue);
						fnSetColumnName(newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.inventory.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			autoPopup		: false,
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				}
			}
		}),{
			boxLabel		: '<t:message code="system.label.inventory.inventoryqtywith0" default="재고수량 0포함"/>',
			xtype			: 'checkboxfield',
			name			: 'STOCK_YN',
    		inputValue		: 'Y',
			uncheckedValue	: 'N',
			listeners		: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('STOCK_YN', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
			name		: 'ITEM_ACCOUNT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList'),
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 3 0',
			colspan	: 2,
			items	: [{
				fieldLabel	: '<t:message code="system.label.inventory.itemgroup" default="품목분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'ITEM_LEVEL2',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{
				fieldLabel	: '',
				name		: 'ITEM_LEVEL2',
				xtype		:'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child		: 'ITEM_LEVEL3',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{
				fieldLabel	: '',
				name		: 'ITEM_LEVEL3',
				xtype		:'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_LEVEL3', newValue);
					}
				}
			}]
		}]
	});



	/** Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('biv500skrvGrid1', {
		store	: directMasterStore1, 
		region	: 'center' ,
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: false,
			useMultipleSorting	: true
		},
		features: [ 
			{id : 'masterGrid1SubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
			{id : 'masterGrid1Total'	, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns	: [
			{dataIndex: 'COMP_CODE',	width:100, hidden:true},
			{dataIndex: 'DIV_CODE',		width:100, hidden:true},
			{dataIndex: 'ITEM_CODE',	width:120},
			{dataIndex: 'ITEM_NAME',	width:150},
			{dataIndex: 'SPEC',			width:120},
			{dataIndex: 'AVERAGE_P',	width:100, hidden:true},
			{dataIndex: 'STOCK_Q',		width:100},
			{text: '<t:message code="system.label.inventory.qtyreceivedbyperiod" default="기간별 입고수량"/>',
				columns:[ 
					{dataIndex: 'RECEIVED_1',	width:100},
					{dataIndex: 'RECEIVED_2',	width:100},
					{dataIndex: 'RECEIVED_3',	width:100},
					{dataIndex: 'RECEIVED_4',	width:100}
				]
			},
			{text: '<t:message code="system.label.inventory.qtyofinventorybyretentionperiod(days)" default="보유기간별 재고수량(일)"/>',
				columns:[ 
					{dataIndex: 'STOCK_QTY_90',			width:100},
					{dataIndex: 'STOCK_QTY_90_TO_180',	width:100},
					{dataIndex: 'STOCK_QTY_181_TO_365',	width:100},
					{dataIndex: 'STOCK_QTY_366_TO_730',	width:100},
					{dataIndex: 'STOCK_QTY_730',		width:100},
					{dataIndex: 'STOCK_QTY_TOTAL',		width:100}
				]
			},
			{text: '<t:message code="system.label.inventory.Inventoryamountbyretentionperiod(days)" default="보유기간별 재고금액(일)"/>',
				columns:[ 
					{dataIndex: 'STOCK_AMT_90',			width:100},
					{dataIndex: 'STOCK_AMT_90_TO_180',	width:100},
					{dataIndex: 'STOCK_AMT_181_TO_365',	width:100},
					{dataIndex: 'STOCK_AMT_366_TO_730',	width:100},
					{dataIndex: 'STOCK_AMT_730',		width:100},
					{dataIndex: 'STOCK_AMT_TOTAL',		width:100}
				]
			},
			{text: 'Provision(366~730)',
				columns:[ 
					{text: 'No Demand',
						columns:[ 
							{dataIndex: 'NO_DEMAND_QTY',	width:100},
							{dataIndex: 'NO_DEMAND_AMT',	width:100}
						]
					}
				]
			},
			{text: '<t:message code="system.label.inventory.inventorystatusbyexpirationdate" default="유통기한별 재고현황"/>',
				columns:[ 
					{text: '<t:message code="system.label.inventory.lessthan6months" default="6개월 미만"/>',
						columns:[ 
							{dataIndex: 'PROVISON_180_QTY',	width:100},
							{dataIndex: 'PROVISON_180_AMT',	width:100}
						]
					},
					{text: '<t:message code="system.label.inventory.lessthan12months" default="12개월 미만"/>',
						columns:[ 
							{dataIndex: 'PROVISON_365_QTY',	width:100},
							{dataIndex: 'PROVISON_365_AMT',	width:100}
						]
					},
					{text: '<t:message code="system.label.inventory.lessthan2years" default="2년 미만"/>',
						columns:[ 
							{dataIndex: 'PROVISON_730_QTY',	width:100},
							{dataIndex: 'PROVISON_730_AMT',	width:100}
						]
					},
					{text: '<t:message code="system.label.inventory.over2years" default="2년 이상"/>',
						columns:[ 
							{dataIndex: 'PROVISON_730_OVER_QTY',	width:100},
							{dataIndex: 'PROVISON_730_OVER_AMT',	width:100}
						]
					}
				]
			}
		]
	});

	var masterGrid2 = Unilite.createGrid('biv500skrvGrid2', {
		store	: directMasterStore2, 
		region	: 'center' ,
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: false,
			useMultipleSorting	: true
		},
		features: [ 
			{id : 'masterGrid1SubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
			{id : 'masterGrid1Total'	, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns	: [
			{dataIndex: 'COMP_CODE',		width:100, hidden:true},
			{dataIndex: 'DIV_CODE',			width:100, hidden:true},
			{dataIndex: 'ITEM_CODE',		width:120},
			{dataIndex: 'ITEM_NAME',		width:150},
			{dataIndex: 'SPEC',				width:120},
			{dataIndex: 'AVERAGE_P',		width:100},
			{dataIndex: 'STOCK_Q',			width:100},
			{dataIndex: 'STOCK_QTY_01',		width:100},
			{dataIndex: 'STOCK_QTY_02',		width:100},
			{dataIndex: 'STOCK_QTY_03',		width:100},
			{dataIndex: 'STOCK_QTY_04',		width:100},
			{dataIndex: 'STOCK_QTY_05',		width:100},
			{dataIndex: 'STOCK_QTY_06',		width:100},
			{dataIndex: 'STOCK_QTY_07',		width:100},
			{dataIndex: 'STOCK_QTY_08',		width:100},
			{dataIndex: 'STOCK_QTY_09',		width:100},
			{dataIndex: 'STOCK_QTY_10',		width:100},
			{dataIndex: 'STOCK_QTY_11',		width:100},
			{dataIndex: 'STOCK_QTY_12',		width:100},
			{dataIndex: 'STOCK_QTY_13',		width:100},
			{dataIndex: 'STOCK_QTY_14',		width:100},
			{dataIndex: 'STOCK_QTY_15',		width:100},
			{dataIndex: 'STOCK_QTY_16',		width:100},
			{dataIndex: 'STOCK_QTY_17',		width:100},
			{dataIndex: 'STOCK_QTY_18',		width:100},
			{dataIndex: 'STOCK_QTY_19',		width:100},
			{dataIndex: 'STOCK_QTY_20',		width:100},
			{dataIndex: 'STOCK_QTY_21',		width:100},
			{dataIndex: 'STOCK_QTY_22',		width:100},
			{dataIndex: 'STOCK_QTY_23',		width:100},
			{dataIndex: 'STOCK_QTY_24',		width:100},
			{dataIndex: 'STOCK_QTY_OVER',	width:100},
			{dataIndex: 'STOCK_QTY_TOTAL',	width:100}
		]
	});



	var tab = Unilite.createTabPanel('tabPanel', {
		activeTab	: 0,
		region		: 'center',
		items		: [{
			title	: '<t:message code="system.label.inventory.byperiod" default="기간별"/>',
			xtype	: 'container',
			id		: 'biv500skrvGridTab',
			layout	: {
				type	: 'vbox',
				align	: 'stretch'
			},
			items	: [ masterGrid1 ]
		},{
			title	: '<t:message code="system.label.inventory.monthly" default="월별"/>',
			xtype	: 'container',
			id		: 'biv500skrvGridTab2',
			layout	: {
				type	: 'vbox',
				align	: 'stretch'
			},
			items	: [ masterGrid2 ]
		} ],
		listeners : {
			tabChange : function(tabPanel, newCard, oldCard, eOpts) {
				var activeTabId = tabPanel.getActiveTab().getId();
				if (activeTabId == 'biv500skrvGridTab') {
					directMasterStore1.loadStoreRecords();
				} else {
					directMasterStore2.loadStoreRecords();
				}
			}
		}
	});



	Unilite.Main({
		id			: 'biv500skrvApp',
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
		fnInitBinding : function() {
			fnSetColumnName(new Date());
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('BASIS_MONTH'	, new Date());
			panelResult.setValue('BASIS_MONTH'	, new Date());

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
			if(activeTabId == 'biv500skrvGridTab'){
				directMasterStore1.loadStoreRecords();
			}else{
				directMasterStore2.loadStoreRecords();
			}
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid1.getStore().loadData({});
			masterGrid2.getStore().loadData({});
			this.fnInitBinding();
		}
	});



	//그리드 컬럼명 set
	function fnSetColumnName(provider) {
		if(Ext.isEmpty(provider) || UniDate.getDbDateStr(provider).length != 8) {
			return false;
		}
		//1. masterGrid1 컬럼명 set
		var frMonth1 = UniDate.getDbDateStr(UniDate.add(provider, {months:-(period1-1)})).substring(2, 4) + '.' + UniDate.getDbDateStr(UniDate.add(provider, {months:-(period1-1)})).substring(4, 6);
		var frMonth2 = UniDate.getDbDateStr(UniDate.add(provider, {months:-(period1+period2-1)})).substring(2, 4) + '.' + UniDate.getDbDateStr(UniDate.add(provider, {months:-(period1+period2-1)})).substring(4, 6);
		var frMonth3 = UniDate.getDbDateStr(UniDate.add(provider, {months:-(period1+period2+period3-1)})).substring(2, 4) + '.' + UniDate.getDbDateStr(UniDate.add(provider, {months:-(period1+period2+period3-1)})).substring(4, 6);
		var frMonth4 = UniDate.getDbDateStr(UniDate.add(provider, {months:-(period1+period2+period3+period4-1)})).substring(2, 4) + '.' + UniDate.getDbDateStr(UniDate.add(provider, {months:-(period1+period2+period3+period4-1)})).substring(4, 6);
		var toMonth1 = UniDate.getDbDateStr(provider).substring(2, 4) + '.' + UniDate.getDbDateStr(provider).substring(4, 6);
		var toMonth2 = UniDate.getDbDateStr(UniDate.add(provider, {months:-period1})).substring(2, 4) + '.' + UniDate.getDbDateStr(UniDate.add(provider, {months:-period1})).substring(4, 6);
		var toMonth3 = UniDate.getDbDateStr(UniDate.add(provider, {months:-(period1+period2)})).substring(2, 4) + '.' + UniDate.getDbDateStr(UniDate.add(provider, {months:-(period1+period2)})).substring(4, 6);
		var toMonth4 = UniDate.getDbDateStr(UniDate.add(provider, {months:-(period1+period2+period3)})).substring(2, 4) + '.' + UniDate.getDbDateStr(UniDate.add(provider, {months:-(period1+period2+period3)})).substring(4, 6);
		masterGrid1.getColumn('RECEIVED_1').setText(frMonth1 + ' ~ ' + toMonth1);
		masterGrid1.getColumn('RECEIVED_2').setText(frMonth2 + ' ~ ' + toMonth2);
		masterGrid1.getColumn('RECEIVED_3').setText(frMonth3 + ' ~ ' + toMonth3);
		masterGrid1.getColumn('RECEIVED_4').setText(frMonth4 + ' ~ ' + toMonth4);

		//2. masterGrid2 컬럼명 set
		for (var i=0; i < 24; i ++) {
			varProvider = UniDate.getDbDateStr(UniDate.add(provider, {months:-i}));
			eval("columnName"+i+"= varProvider.substring(0, 4) + '.' + varProvider.substring(4, 6)");
		}
		masterGrid2.getColumn('STOCK_QTY_01').setText(columnName0);
		masterGrid2.getColumn('STOCK_QTY_02').setText(columnName1);
		masterGrid2.getColumn('STOCK_QTY_03').setText(columnName2);
		masterGrid2.getColumn('STOCK_QTY_04').setText(columnName3);
		masterGrid2.getColumn('STOCK_QTY_05').setText(columnName4);
		masterGrid2.getColumn('STOCK_QTY_06').setText(columnName5);
		masterGrid2.getColumn('STOCK_QTY_07').setText(columnName6);
		masterGrid2.getColumn('STOCK_QTY_08').setText(columnName7);
		masterGrid2.getColumn('STOCK_QTY_09').setText(columnName8);
		masterGrid2.getColumn('STOCK_QTY_10').setText(columnName9);
		masterGrid2.getColumn('STOCK_QTY_11').setText(columnName10);
		masterGrid2.getColumn('STOCK_QTY_12').setText(columnName11);
		masterGrid2.getColumn('STOCK_QTY_13').setText(columnName12);
		masterGrid2.getColumn('STOCK_QTY_14').setText(columnName13);
		masterGrid2.getColumn('STOCK_QTY_15').setText(columnName14);
		masterGrid2.getColumn('STOCK_QTY_16').setText(columnName15);
		masterGrid2.getColumn('STOCK_QTY_17').setText(columnName16);
		masterGrid2.getColumn('STOCK_QTY_18').setText(columnName17);
		masterGrid2.getColumn('STOCK_QTY_19').setText(columnName18);
		masterGrid2.getColumn('STOCK_QTY_20').setText(columnName19);
		masterGrid2.getColumn('STOCK_QTY_21').setText(columnName20);
		masterGrid2.getColumn('STOCK_QTY_22').setText(columnName21);
		masterGrid2.getColumn('STOCK_QTY_23').setText(columnName22);
		masterGrid2.getColumn('STOCK_QTY_24').setText(columnName23);

		//3. 날짜 변경되면 컬럼명이 변경되므로, 그리드 초기화
		masterGrid1.getStore().loadData({});
		masterGrid2.getStore().loadData({});
	}
};
</script>