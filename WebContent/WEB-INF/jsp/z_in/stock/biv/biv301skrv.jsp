<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv301skrv">
	<t:ExtComboStore comboType="BOR120"  pgmId="biv301skrv"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 					<!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>			<!--창고-->
	<t:ExtComboStore comboType="O" storeId="whList" />   					<!--창고(전체) -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {	//컨트롤러에서 값을 받아옴.
	gsAvgPHiddenYN: 		'${gsAvgPHiddenYN}',
	gsWHGroupYN:			'${gsWHGroupYN}'
};

var lotStocksWindows;
var gsRecord;

function appMain() {
	var AvgPHiddenYN = false;	// 현재고 단가필드 숨김여부 (Y:숨김, N:보여줌)
	if(BsaCodeInfo.gsAvgPHiddenYN =='Y') {
		AvgPHiddenYN = true;
	}


	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Biv300skrvModel', {
		fields: [
			{name: 'ITEM_ACCOUNT',		text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',				type: 'string'},
			{name: 'ACCOUNT1',			text: '<t:message code="system.label.inventory.itemaccountcode" default="품목계정코드"/>',		type: 'string'},
			{name: 'DIV_CODE',			text: '<t:message code="system.label.inventory.division" default="사업장"/>',					type: 'string'},
			{name: 'ITEM_LEVEL1',		text: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',				type: 'string', store: Ext.data.StoreManager.lookup('itemLeve1Store')},
			{name: 'ITEM_LEVEL2',		text: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',				type: 'string', store: Ext.data.StoreManager.lookup('itemLeve2Store')},
			{name: 'ITEM_LEVEL3',		text: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',				type: 'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')},
			{name: 'ITEM_CODE',			text: '<t:message code="system.label.inventory.item" default="품목"/>',						type: 'string'},
			{name: 'ITEM_NAME',			text: '<t:message code="system.label.inventory.item" default="품목"/>',						type: 'string'},
			{name: 'SPEC',				text: '<t:message code="system.label.inventory.spec" default="규격"/>',						type: 'string'},
			{name: 'STOCK_UNIT',		text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',			type: 'string'},
			{name: 'STOCK_P',			text: '<t:message code="system.label.inventory.inventoryprice" default="재고단가"/>',			type: 'uniUnitPrice'},
			{name: 'STOCK_Q',			text: '<t:message code="system.label.inventory.totalinventoryqty" default="총재고량"/>',		type: 'uniQty'},
			{name: 'STOCK_AMT',			text: '<t:message code="system.label.inventory.totalinventoryamount" default="총재고금액"/>',	type: 'uniPrice'},
			{name: 'USEABLE_STOCK_QTY',	text: '<t:message code="system.label.base.availableinventoryqty" default="가용재고량"/>',		type: 'uniQty'},
			{name: 'ISSUE_REQ_QTY',		text: '<t:message code="system.label.base.issueresevationqty" default="출고예정량"/>',			type: 'uniQty'},
			{name: 'GOOD_STOCK_Q',		text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>',			type: 'uniQty'},
			{name: 'GOOD_STOCK_AMT',	text: '<t:message code="system.label.inventory.goodstockamount" default="양품재고금액"/>',		type: 'uniPrice'},
			{name: 'BAD_STOCK_Q',		text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>',		type: 'uniQty'},
			{name: 'BAD_STOCK_AMT',		text: '<t:message code="system.label.inventory.defectinventoryamount" default="불량재고금액"/>',	type: 'uniPrice'},
			{name: 'LOCATION',			text: 'LOCATION',	type: 'string'},
			{name: 'CUSTOM_CODE',		text: '<t:message code="system.label.inventory.maincustomcode" default="주거래처코드"/>',			type: 'string'},
			{name: 'CUSTOM_NAME',		text: '<t:message code="system.label.inventory.maincustom" default="주거래처"/>',				type: 'string'}
		]
	});

	Unilite.defineModel('Biv300skrvModel2', {
		fields:  [
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',					type: 'string'},
			{name: 'ACCOUNT1'			, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',					type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.inventory.division" default="사업장"/>',					type: 'string'},
			{name: 'ITEM_LEVEL1'		, text: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',					type: 'string', store: Ext.data.StoreManager.lookup('itemLeve1Store')},
			{name: 'ITEM_LEVEL2'		, text: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',					type: 'string', store: Ext.data.StoreManager.lookup('itemLeve2Store')},
			{name: 'ITEM_LEVEL3'		, text: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',					type: 'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.inventory.item" default="품목"/>',							type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.inventory.item" default="품목"/>',							type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.inventory.spec" default="규격"/>',							type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',				type: 'string'},
			{name: 'STOCK_P'			, text: '<t:message code="system.label.inventory.inventoryprice" default="재고단가"/>',				type: 'uniUnitPrice'},
			{name: 'STOCK_Q'			, text: '<t:message code="system.label.inventory.totalinventoryqty" default="총재고량"/>',			type: 'uniQty'},
			{name: 'STOCK_AMT'			, text: '<t:message code="system.label.inventory.totalinventoryamount" default="총재고금액"/>',		type: 'uniPrice'},
			{name: 'USEABLE_STOCK_QTY'	, text: '<t:message code="system.label.base.availableinventoryqty" default="가용재고량"/>',			type: 'uniQty'},
			{name: 'ISSUE_REQ_QTY'		, text: '<t:message code="system.label.base.issueresevationqty" default="출고예정량"/>',				type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'		, text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>',				type: 'uniQty'},
			{name: 'GOOD_STOCK_AMT'		, text: '<t:message code="system.label.inventory.goodstockamount" default="양품재고금액"/>',			type: 'uniPrice'},
			{name: 'BAD_STOCK_Q'		, text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>',		type: 'uniQty'},
			{name: 'BAD_STOCK_AMT'		, text: '<t:message code="system.label.inventory.defectinventoryamount" default="불량재고금액"/>',	type: 'uniPrice'},
			{name: 'LOCATION'			, text: 'LOCATION',		type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.inventory.maincustomcode" default="주거래처코드"/>',			type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.inventory.maincustom" default="주거래처"/>',					type: 'string'}
		]
	});

	Unilite.defineModel('Biv300skrvModel3', {
		fields:  [
			{name: 'LOT_NO'				, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',					type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',				type: 'string'},
			{name: 'WH_NAME'			, text: '<t:message code="system.label.inventory.warehousename" default="창고명"/>',			type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.inventory.item" default="품목"/>',						type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',				type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.inventory.spec" default="규격"/>',						type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',			type: 'string'},
			{name: 'STOCK'				, text: '<t:message code="system.label.inventory.totalinventoryqty" default="총재고량"/>',		type: 'uniQty'},
			{name: 'USEABLE_STOCK_QTY'	, text: '<t:message code="system.label.base.availableinventoryqty" default="가용재고량"/>',		type: 'uniQty'},
			{name: 'ISSUE_REQ_QTY'		, text: '<t:message code="system.label.base.issueresevationqty" default="출고예정량"/>',			type: 'uniQty'},
			{name: 'GOOD_STOCK'			, text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>',			type: 'uniQty'},
			{name: 'BAD_STOCK'			, text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>',	type: 'uniQty'},
			{name: 'REMARK'				, text: '<t:message code="system.label.inventory.remarks" default="비고"/>',					type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.inventory.division" default="사업장"/>',				type: 'string'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('biv301skrvMasterStore1',{
		model: 'Biv300skrvModel',
		uniOpt : {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api	: {read: 'biv301skrvService.selectMaster'}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.SUBCON_FLAG = Ext.getCmp('rdoSelect').getChecked()[0].inputValue;
			param.QUERY_TYPE = '1'
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var directMasterStore2 = Unilite.createStore('biv301skrvMasterStore2',{
		model: 'Biv300skrvModel2',
		uniOpt : {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api	: {read: 'biv301skrvService.selectMaster2'}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.QUERY_TYPE = '2'
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var directMasterStore3 = Unilite.createStore('biv301skrvMasterStore3',{
		model: 'Biv300skrvModel3',
		uniOpt : {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api	: {read: 'biv301skrvService.selectMaster3'}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.FR_LOT = lotSubForm.getValue('FR_LOT');
			param.TO_LOT = lotSubForm.getValue('TO_LOT');
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: true,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
		   	layout: {type: 'uniTable', columns: 1},
		   	defaultType: 'uniTextfield',
				items: [{
					fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					child:'WH_CODE',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
					name: 'WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList'),
					multiSelect:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WH_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
					name:'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
					multiSelect:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},
				Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
						valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						validateBlank: false,
						listeners: {
//							onSelected: {
//								fn: function(records, type) {
//									console.log('records : ', records);
//									panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
//									panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
//								},
//								scope: this
//							},
//							onClear: function(type) {
//								panelResult.setValue('ITEM_CODE', '');
//								panelResult.setValue('ITEM_NAME', '');
//							},
							onValueFieldChange: function(field, newValue){
								panelResult.setValue('ITEM_CODE', newValue);
							},
							onTextFieldChange: function(field, newValue){
								panelResult.setValue('ITEM_NAME', newValue);
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
			   })]
			},{
				title: '<t:message code="system.label.inventory.additionalinfo" default="추가정보"/>',
				defaultType: 'uniTextfield',
				items: [{
					fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
					name: 'TXTLV_L1',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve1Store'),
					child: 'TXTLV_L2',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TXTLV_L1', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
					name: 'TXTLV_L2',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve2Store'),
					child: 'TXTLV_L3',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TXTLV_L2', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
					name: 'TXTLV_L3',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve3Store'),
					parentNames:['TXTLV_L1','TXTLV_L2'],
					levelType:'ITEM',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TXTLV_L3', newValue);
						}
					}
				},{
					xtype: 'uniCheckboxgroup',
					fieldLabel: '',
					padding: '0 0 0 0',
					margin: '0 0 0 90',
					items: [{
						boxLabel: '<t:message code="system.label.inventory.stockzeroinclusion" default="재고수량 0포함"/>',
						width: 200,
						name: 'ZERO_STOCK_YN',
						inputValue: 'Y',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {

							}
						}
					}]
				}]
			}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
					fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					child:'WH_CODE',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
					name: 'WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList'),
					multiSelect:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('WH_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
					name:'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
					colspan: 2,
					multiSelect:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},
				Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
						valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						validateBlank: false,
						listeners: {
//							onSelected: {
//								fn: function(records, type) {
//									console.log('records : ', records);
//									panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
//									panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
//								},
//								scope: this
//							},
//							onClear: function(type) {
//								panelSearch.setValue('ITEM_CODE', '');
//								panelSearch.setValue('ITEM_NAME', '');
//							},
							onValueFieldChange: function(field, newValue){
								panelSearch.setValue('ITEM_CODE', newValue);
							},
							onTextFieldChange: function(field, newValue){
								panelSearch.setValue('ITEM_NAME', newValue);
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
						}
			   }),{
					fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
					name: 'TXTLV_L1',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve1Store'),
					child: 'TXTLV_L2',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('TXTLV_L1', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
					name: 'TXTLV_L2',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve2Store'),
					child: 'TXTLV_L3',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('TXTLV_L2', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
					name: 'TXTLV_L3',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve3Store'),
					parentNames:['TXTLV_L1','TXTLV_L2'],
					levelType:'ITEM',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('TXTLV_L3', newValue);
						}
					}
				}
			]
	});

	var itemSubForm = Unilite.createSearchForm('itemSubForm',{
		padding: '0 0 0 0',
		layout:{type:'uniTable', columns: '1'},
		items: [{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.inventory.outsourcingstockinclusion" default="외주재고포함여부"/>',
			labelWidth: 100,
			id: 'rdoSelect',
			items: [{
				boxLabel: '<t:message code="system.label.inventory.notinclusion" default="포함안함"/>',
				width: 70,
				inputValue: '1',
				name: 'SUBCON_FLAG',
				checked: true
			},{
				boxLabel : '<t:message code="system.label.inventory.inclusion" default="포함"/>',
				width: 70,
				inputValue: '2',
				name: 'SUBCON_FLAG'
			}]
		}]
	});

	var lotSubForm = Unilite.createSearchForm('lotSubForm',{
		padding: '0 0 0 0',
		layout:{type:'uniTable', columns: '1'},
		items: [{
			xtype: 'container',
			items:[{
				xtype: 'container',
				defaultType: 'uniTextfield',
				layout: {type: 'uniTable', columns: 2},
				width: 250,
				items: [{
					fieldLabel: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',
					//suffixTpl: '&nbsp;~&nbsp;',
					width: 200,
					name: 'FR_LOT'
				}, {
					name: 'TO_LOT',
					width: 135,
					fieldLabel: '~',
					labelWidth: 15
				}]
			}]
		}]
	});

	var customSubForm = Unilite.createSearchForm('customSubForm',{
		padding: '0 0 0 0',
		layout:{type:'uniTable', columns: '1'},
		items: [
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.inventory.subcontractor" default="외주처"/>',
				valueFieldName : 'CUSTOM_CODE',
				textFieldName  : 'CUSTOM_NAME'
			})
		]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('biv301skrvGrid_1', {
		region: 'center' ,
		layout : 'fit',
//		title: '품목별',
		excelTitle: '<t:message code="system.label.inventory.onhandqtybyitem" default="현재고현황(품목별)"/>',
		store : directMasterStore1,
		uniOpt:{	expandLastColumn: true,
					useRowNumberer: false,
					useMultipleSorting: true
		},
		tbar:[{xtype:'uniNumberfield', labelWidth: 110, fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>', id:'selectionSummary', value:0, decimalPrecision:4, format:'0,000.0000',readOnly:true}],
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
				   	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
		columns:  [
			{dataIndex: 'ITEM_ACCOUNT'	,		width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
			},
			{dataIndex: 'ACCOUNT1'		,		width: 66, hidden:true},
			{dataIndex: 'DIV_CODE'		,		width: 66, hidden:true},
//			{dataIndex: 'ITEM_LEVEL1'	, 		width: 120,align:'center', locked: true},
//			{dataIndex: 'ITEM_LEVEL2'	, 		width: 100,align:'center', locked: true},
//			{dataIndex: 'ITEM_LEVEL3'	, 		width: 100,align:'center', locked: true},
			{dataIndex: 'ITEM_CODE'		,		width: 120},
			{dataIndex: 'ITEM_NAME'		,		width: 200},
			{dataIndex: 'SPEC'			,		width: 180},
			{dataIndex: 'STOCK_UNIT'	,		width: 80},
			{dataIndex: 'STOCK_P'		,		width: 100, hidden: AvgPHiddenYN},
			{dataIndex: 'STOCK_Q'		,		width: 100, summaryType: 'sum'},
			{dataIndex: 'STOCK_AMT'		,		width: 100, summaryType: 'sum'},
			{dataIndex: 'USEABLE_STOCK_QTY'		,		width: 100, summaryType: 'sum'},
			{dataIndex: 'ISSUE_REQ_QTY'			,		width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_Q'	,		width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_AMT',		width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK_Q'	,		width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK_AMT'	,		width: 100, summaryType: 'sum'},
			{dataIndex: 'LOCATION'		,		width: 86, hidden:true},
			{dataIndex: 'CUSTOM_CODE'	,		width: 86, hidden:true},
			{dataIndex: 'CUSTOM_NAME'	,		width: 86, hidden:true}
		],
		listeners:{
			selectionchange:function( grid, selection, eOpts ) {
				if(selection && selection.startCell) {
					var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary");
					if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex) {
						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
						var sum = 0;
						for(var i=startIdx; i <= endIdx; i++){
							var record = store.getAt(i);
							sum += record.get(columnName);
						}
						displayField.setValue(sum);
					} else {
						displayField.setValue(0);
					}
				}
			},
			onGridDblClick: function(grid, record, cellIndex, colName) {
				//품목코드 컬럼 더블클릭 시, 해당 품목의 LOT별 재고팝업 호출
				if(UniUtils.indexOf(colName, ['ITEM_CODE'])) {
					gsRecord = record;
					openLotStocksWindows();
				}
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('biv301skrvGrid_2', {
		region: 'center' ,
		layout : 'fit',
//		title: '창고별',
		excelTitle: '<t:message code="system.label.inventory.onhandqtybywarehouse" default="현재고현황(창고별)"/>',
		store : directMasterStore2,
		uniOpt:{	expandLastColumn: true,
					useRowNumberer: false,
					useMultipleSorting: true
		},
		tbar:[{xtype:'uniNumberfield', labelWidth: 110, fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>', id:'selectionSummary2', value:0, decimalPrecision:4, format:'0,000.0000',readOnly:true}],
		features: [ {id : 'masterGridSubTotal2', ftype: 'uniGroupingsummary', showSummaryRow: true },
				   	{id : 'masterGridTotal2', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
		columns:  [
			{dataIndex: 'ACCOUNT1'		,		width: 85,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				   return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.total" default="총계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
			},
			{dataIndex: 'ITEM_ACCOUNT'	,		width: 100},
			{dataIndex: 'DIV_CODE'		,		width: 80, hidden:true},
//			{dataIndex: 'ITEM_LEVEL1'	, 		width: 120,align:'center', locked: true},
//			{dataIndex: 'ITEM_LEVEL2'	, 		width: 100,align:'center', locked: true},
//			{dataIndex: 'ITEM_LEVEL3'	, 		width: 100,align:'center', locked: true},
			{dataIndex: 'ITEM_CODE'		,		width: 120},
			{dataIndex: 'ITEM_NAME'		,		width: 200},
			{dataIndex: 'SPEC'			,		width: 180},
			{dataIndex: 'STOCK_UNIT'	,		width: 80},
			{dataIndex: 'STOCK_P'		,		width: 100, hidden: AvgPHiddenYN},
			{dataIndex: 'STOCK_Q'		,		width: 100, summaryType: 'sum'},
			{dataIndex: 'STOCK_AMT'		,		width: 100, summaryType: 'sum'},

			{dataIndex: 'USEABLE_STOCK_QTY'		,		width: 100	,summaryType: 'sum'},
			{dataIndex: 'ISSUE_REQ_QTY'			,		width: 100	,summaryType: 'sum'},
			
			
			{dataIndex: 'GOOD_STOCK_Q'	,		width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_AMT',		width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK_Q'	,		width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK_AMT'	,		width: 100, summaryType: 'sum'},
			{dataIndex: 'LOCATION'		,		width: 100},
			{dataIndex: 'CUSTOM_CODE'	,		width: 86, hidden:true},
			{dataIndex: 'CUSTOM_NAME'	,		width: 86, hidden:true}
		],
		listeners:{
			selectionchange:function( grid, selection, eOpts ) {
				if(selection && selection.startCell) {
					var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary2");
					if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex) {

						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
						var sum = 0;

						for(var i=startIdx; i <= endIdx; i++){
							var record = store.getAt(i);
							sum += record.get(columnName);
						}
						displayField.setValue(sum);
					} else {
						displayField.setValue(0);
					}
				}
			},
			onGridDblClick: function(grid, record, cellIndex, colName) {
				//품목코드 컬럼 더블클릭 시, 해당 품목의 LOT별 재고팝업 호출
				if(UniUtils.indexOf(colName, ['ITEM_CODE'])) {
					gsRecord = record;
					openLotStocksWindows();
				}
			}
		}
	});

	var masterGrid3 = Unilite.createGrid('biv301skrvGrid_3', {
		region: 'center' ,
		layout : 'fit',
//		title: 'LOT별',
		excelTitle: '<t:message code="system.label.inventory.onhandqtybylot" default="현재고현황(LOT별)"/>',
		store : directMasterStore3,
		uniOpt:{	expandLastColumn: true,
					useRowNumberer: false,
					useMultipleSorting: true
		},
		tbar:[{xtype:'uniNumberfield', labelWidth: 110, fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>', id:'selectionSummary3', value:0, decimalPrecision:4, format:'0,000.0000',readOnly:true}],
		features: [ {id : 'masterGridSubTotal3', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal3',   ftype: 'uniSummary',	  showSummaryRow: true} ],
		columns:  [
			{dataIndex: 'LOT_NO'			,		width: 115,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				   return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
			}
			},
			{dataIndex: 'WH_CODE'			,		width: 85},
			{dataIndex: 'WH_NAME'			,		width: 100},
			{dataIndex: 'ITEM_CODE'			,		width: 120},
			{dataIndex: 'ITEM_NAME'			,		width: 200},
			{dataIndex: 'SPEC'				,		width: 140},
			{dataIndex: 'STOCK_UNIT'		,		width: 80},
			{dataIndex: 'STOCK'				,		width: 100, summaryType: 'sum'},

			{dataIndex: 'USEABLE_STOCK_QTY'				,		width: 100	,summaryType: 'sum'},
			{dataIndex: 'ISSUE_REQ_QTY'					,		width: 100	,summaryType: 'sum'},
			
			
			{dataIndex: 'GOOD_STOCK'		,		width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK'			,		width: 100, summaryType: 'sum'},
			{dataIndex: 'REMARK'			,		width: 200},
			{dataIndex: 'DIV_CODE'			,		width: 66, hidden: true}
		],
		listeners:{
			selectionchange:function( grid, selection, eOpts ) {
				if(selection && selection.startCell) {
					var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary3");
					if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex) {

						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
						var sum = 0;

						for(var i=startIdx; i <= endIdx; i++){
							var record = store.getAt(i);
							sum += record.get(columnName);
						}
						displayField.setValue(sum);
					} else {
						displayField.setValue(0);
					}
				}
			},
			onGridDblClick: function(grid, record, cellIndex, colName) {
				//품목코드 컬럼 더블클릭 시, 해당 품목의 LOT별 재고팝업 호출
				if(UniUtils.indexOf(colName, ['ITEM_CODE'])) {
					gsRecord = record;
					openTransStatusWindows();
				}
			}
		}
	});



	/** 상세내역 팝업
	 */
	var detailDataForm = Unilite.createSearchForm('detailDataForm', {
		layout		: {type : 'uniTable', columns : 3},
//		height		: 50,
//		width		: 800,
		region		: 'center',
		border		: true,
		padding		: '0 0 0 0',
		xtype		: 'container',
		defaultType	: 'container',
		items:[{
			fieldLabel	: 'DIV_CODE',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.inventory.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			readOnly		: true,
			listeners		: {
				'onValueFieldChange': function(field, newValue, oldValue  ){
				},
				'onTextFieldChange':  function( field, newValue, oldValue  ){
				}
			}
		})]
	});
	
	Unilite.defineModel('detailDataModel', {
		fields: [
			{name: 'LOT_NO'				, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',					type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',				type: 'string'},
			{name: 'WH_NAME'			, text: '<t:message code="system.label.inventory.warehousename" default="창고명"/>',			type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.inventory.item" default="품목"/>',						type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',				type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.inventory.spec" default="규격"/>',						type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',			type: 'string'},
			{name: 'STOCK'				, text: '<t:message code="system.label.inventory.totalinventoryqty" default="총재고량"/>',		type: 'uniQty'},
			{name: 'USEABLE_STOCK_QTY'	, text: '<t:message code="system.label.base.availableinventoryqty" default="가용재고량"/>',		type: 'uniQty'},
			{name: 'ISSUE_REQ_QTY'		, text: '<t:message code="system.label.base.issueresevationqty" default="출고예정량"/>',			type: 'uniQty'},
			{name: 'GOOD_STOCK'			, text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>',			type: 'uniQty'},
			{name: 'BAD_STOCK'			, text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>',	type: 'uniQty'},
			{name: 'REMARK'				, text: '<t:message code="system.label.inventory.remarks" default="비고"/>',					type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.inventory.division" default="사업장"/>',				type: 'string'}
		]
	});

	var detailDataStore = Unilite.createStore('detailDataStore', {
		model	: 'detailDataModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'biv301skrvService.detailDataList'
			}
		},
		loadStoreRecords: function() {
			var param = detailDataForm.getValues();
			console.log(param);
			this.load({
				params: param
			});
		}
	});

	var detailDataGrid = Unilite.createGrid('detailDataGrid', {
		store	: detailDataStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: true
		},
		columns: [
			{dataIndex: 'LOT_NO'			, width: 100},
			{dataIndex: 'WH_CODE'			, width: 85	, hidden: true},
			{dataIndex: 'WH_NAME'			, width: 100},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'SPEC'				, width: 140},
			{dataIndex: 'STOCK_UNIT'		, width: 80	, hidden: true},
			{dataIndex: 'STOCK'				, width: 100},
			{dataIndex: 'USEABLE_STOCK_QTY'	, width: 100},
			{dataIndex: 'ISSUE_REQ_QTY'		, width: 100},
			{dataIndex: 'GOOD_STOCK'		, width: 100},
			{dataIndex: 'BAD_STOCK'			, width: 100},
			{dataIndex: 'REMARK'			, minWidth: 200	, flex: 1},
			{dataIndex: 'DIV_CODE'			, width: 66	, hidden: true}
		],
		listeners: {
		},
		viewConfig: {
//			getRowClass: function(record, rowIndex, rowParams, store){
//				var cls = '';
//				
//				if(record.get('REAL_NEED_Q') > record.get('GOOD_STOCK_Q')){
//					cls = 'x-change-celltext_red';	
//				}
//				return cls;
//			}
		}
	});

	function openLotStocksWindows() {
		if(!lotStocksWindows) {
			lotStocksWindows = Ext.create('widget.uniDetailWindow', {
				title		: '<t:message code="system.label.inventory.byeachlotonhandinquiry" default="LOT별 재고현황 검색"/>',
				height		: 700,
				width		: 1000,
				resizable	: false,
				layout		: {type:'vbox', align:'stretch'},
				items		: [detailDataForm, detailDataGrid],
				tbar		: ['->', {
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.confirm" default="확인"/>',
					handler	: function() {
						detailDataForm.clearForm();
						lotStocksWindows.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function( panel, eOpts ) {
						detailDataForm.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						detailDataForm.setValue('ITEM_CODE'		, gsRecord.get('ITEM_CODE'));
						detailDataForm.setValue('ITEM_NAME'		, gsRecord.get('ITEM_NAME'));
						detailDataStore.loadStoreRecords();
					}
				}
			})
		}
		lotStocksWindows.center();
		lotStocksWindows.show();
	}



	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab:  0,
		region: 'center',
		items:  [{
			title: '<t:message code="system.label.inventory.itemby" default="품목별"/>'
			,xtype:'container'
			,layout:{type:'vbox', align:'stretch'}
			,items:[itemSubForm, masterGrid]
			,id: 'biv301skrvGrid1'
		},{
			title: '<t:message code="system.label.inventory.warehouseby" default="창고별"/>'
			,xtype:'container'
			,layout:{type:'vbox', align:'stretch'}
			,items:[masterGrid2]
			,id: 'biv301skrvGrid2'
		},{
			title: '<t:message code="system.label.inventory.byeachlot" default="LOT별"/>'
			,xtype:'container'
			,layout:{type:'vbox', align:'stretch'}
			,items:[lotSubForm, masterGrid3]
			,id: 'biv301skrvGrid3'
		}]
	});

	Unilite.Main({
		id  : 'biv301skrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',true);
			biv301skrvService.userWhcode({}, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
		},
		onQueryButtonDown : function() {
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'biv301skrvGrid1'){
				directMasterStore1.loadStoreRecords();
			}
			else if(activeTabId == 'biv301skrvGrid2'){
				directMasterStore2.loadStoreRecords();
			}
			else if(activeTabId == 'biv301skrvGrid3'){
				directMasterStore3.loadStoreRecords();
			}
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();

			masterGrid.getStore().loadData({});
			masterGrid2.getStore().loadData({});
			masterGrid3.getStore().loadData({});
			
			this.fnInitBinding();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		}
	});
};
</script>
