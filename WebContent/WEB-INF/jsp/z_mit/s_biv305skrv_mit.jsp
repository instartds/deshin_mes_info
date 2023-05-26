<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_biv305skrv_mit"  >
	<t:ExtComboStore comboType="AU" comboCode="B266" /> 				<!-- 대리점 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 					<!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
	<t:ExtComboStore items="${COMBO_DIV_CODE}" storeId="divComboStore" /><!-- 사업장 -->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {	//컨트롤러에서 값을 받아옴.
	gsAvgPHiddenYN	: '${gsAvgPHiddenYN}'
};

function appMain() {
	var AvgPHiddenYN = false;	// 현재고 단가필드 숨김여부 (Y:숨김, N:보여줌)
	if(BsaCodeInfo.gsAvgPHiddenYN =='Y') {
		AvgPHiddenYN = true;
	}



	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_biv305skrv_mitModel', {
		fields: [
			{name: 'ITEM_ACCOUNT',		text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',				type: 'string'},
			{name: 'ACCOUNT1',			text: '<t:message code="system.label.inventory.itemaccountcode" default="품목계정코드"/>',		type: 'string'},
			{name: 'DIV_CODE',			text: '<t:message code="system.label.inventory.division" default="사업장"/>',					type: 'string'},
			{name: 'ITEM_LEVEL1',		text: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',				type: 'string', store: Ext.data.StoreManager.lookup('itemLeve1Store')},
			{name: 'ITEM_LEVEL2',		text: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',				type: 'string', store: Ext.data.StoreManager.lookup('itemLeve2Store')},
			{name: 'ITEM_LEVEL3',		text: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',				type: 'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')},
			{name: 'ITEM_CODE',			text: '<t:message code="system.label.inventory.item" default="품목"/>',						type: 'string'},
			{name: 'ITEM_NAME',			text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',						type: 'string'},
			{name: 'SPEC',				text: '<t:message code="system.label.inventory.spec" default="규격"/>',						type: 'string'},
			{name: 'STOCK_UNIT',		text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',			type: 'string'},
			{name: 'STOCK_P',			text: '<t:message code="system.label.inventory.inventoryprice" default="재고단가"/>',			type: 'uniUnitPrice'},
			{name: 'STOCK_Q',			text: '<t:message code="system.label.inventory.totalinventoryqty" default="총재고량"/>',		type: 'uniQty'},
			{name: 'STOCK_AMT',			text: '<t:message code="system.label.inventory.totalinventoryamount" default="총재고금액"/>',	type: 'uniPrice'},
			{name: 'GOOD_STOCK_Q',		text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>',			type: 'uniQty'},
			{name: 'GOOD_STOCK_AMT',	text: '<t:message code="system.label.inventory.goodstockamount" default="양품재고금액"/>',		type: 'uniPrice'},
			{name: 'BAD_STOCK_Q',		text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>',		type: 'uniQty'},
			{name: 'BAD_STOCK_AMT',		text: '<t:message code="system.label.inventory.defectinventoryamount" default="불량재고금액"/>',	type: 'uniPrice'},
			{name: 'LOCATION',			text: 'LOCATION',		type: 'string'},
			{name: 'CUSTOM_CODE',		text: '<t:message code="system.label.inventory.maincustomcode" default="주거래처코드"/>',			type: 'string'},
			{name: 'CUSTOM_NAME',		text: '<t:message code="system.label.inventory.maincustom" default="주거래처"/>',				type: 'string'},
			{name: 'RECEIPT_DATE',		text: '최종접수일',				type: 'uniDate'}
		]
	});

	Unilite.defineModel('s_biv305skrv_mitModel3', {
		fields:  [
			{name: 'LOT_NO'			, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',					type: 'string'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',				type: 'string'},
			{name: 'WH_NAME'		, text: '<t:message code="system.label.inventory.warehousename" default="창고명"/>',			type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.inventory.item" default="품목"/>',						type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',				type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.inventory.spec" default="규격"/>',						type: 'string'},
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',			type: 'string'},
			{name: 'STOCK'			, text: '<t:message code="system.label.inventory.totalinventoryqty" default="총재고량"/>',		type: 'uniQty'},
			{name: 'GOOD_STOCK'		, text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>',			type: 'uniQty'},
			{name: 'BAD_STOCK'		, text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>',	type: 'uniQty'},
			//{name: 'REMARK'		, text: '<t:message code="system.label.inventory.remarks" default="비고"/>',					type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.inventory.division" default="사업장"/>',				type: 'string'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',				type: 'string'},
			
			{name: 'LOCATION'		, text: 'Location',				type: 'string'},
			//20190529 제조일자, 사용기한 추가
			{name: 'MAKE_DATE'		, text: '<t:message code="system.label.inventory.mfgdate" default="제조일"/>',					type: 'uniDate'},
			{name: 'MAKE_EXP_DATE'	, text: '<t:message code="system.label.inventory.expirationdateII" default="사용기한"/>',		type: 'uniDate'},
			//20190603 거래처, 구매단가
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.inventory.customname" default="거래처명"/>',				type: 'string'},
			{name: 'PURCHASE_BASE_P', text: '<t:message code="system.label.inventory.purchaseprice2" default="구매단가"/>',			type: 'uniUnitPrice'}
		]
	});

	Unilite.defineModel('s_biv305skrv_mitModel4', {
		fields:  [
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.inventory.division" default="사업장"/>',					type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.inventory.custom" default="거래처"/>',						type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.inventory.customname" default="거래처명"/>',					type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.inventory.item" default="품목"/>',							type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',					type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.inventory.spec" default="규격"/>',							type: 'string'},
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',				type: 'string'},
			{name: 'STOCK_P'		, text: '<t:message code="system.label.inventory.inventoryprice" default="재고단가"/>',				type: 'uniUnitPrice'},
			{name: 'STOCK_Q'		, text: '<t:message code="system.label.inventory.totalinventoryqty" default="총재고량"/>',			type: 'uniQty'},
			{name: 'STOCK_AMT'		, text: '<t:message code="system.label.inventory.totalinventoryamount" default="총재고금액"/>',		type: 'uniPrice'},
			{name: 'GOOD_STOCK_Q'	, text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>',				type: 'uniQty'},
			{name: 'GOOD_STOCK_AMT'	, text: '<t:message code="system.label.inventory.goodstockamount" default="양품재고금액"/>',			type: 'uniPrice'},
			{name: 'BAD_STOCK_Q'	, text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>',		type: 'uniQty'},
			{name: 'BAD_STOCK_AMT'	, text: '<t:message code="system.label.inventory.defectinventoryamount" default="불량재고금액"/>',	type: 'uniPrice'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_biv305skrv_mitMasterStore1',{
		model: 's_biv305skrv_mitModel',
		uniOpt : {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {read: 's_biv305skrv_mitService.selectMaster'}
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

	var directMasterStore3 = Unilite.createStore('s_biv305skrv_mitMasterStore3',{
		model: 's_biv305skrv_mitModel3',
		uniOpt : {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {read: 's_biv305skrv_mitService.selectMaster3'}
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

	var directMasterStore4 = Unilite.createStore('s_biv305skrv_mitMasterStore4',{
		model: 's_biv305skrv_mitModel4',
		uniOpt : {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {read: 's_biv305skrv_mitService.selectMaster4'}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.CUSTOM_CODE = customSubForm.getValue('CUSTOM_CODE');
			param.CUSTOM_NAME = customSubForm.getValue('CUSTOM_NAME');
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
				fieldLabel: '대리점',
				name: 'COMP_CODE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B266',
				allowBlank: false,
				autoSelect : true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('COMP_CODE', newValue);
						var divCombofield = panelSearch.getField("DIV_CODE");
						divCombofield.store.clearFilter(true);
						divCombofield.store.filter("option", newValue);
						if(divCombofield.store.getData().items)	{
							divCombofield.select(divCombofield.store.getData().items[0]);
						}
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				autoSelect : true,
				store: Ext.data.StoreManager.lookup('divComboStore'),
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
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
			fieldLabel: '대리점',
			name: 'COMP_CODE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B266',
			allowBlank: false,
			autoSelect : true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('COMP_CODE', newValue);
					var divCombofield = panelResult.getField("DIV_CODE");
					divCombofield.store.clearFilter(true);
					divCombofield.store.filter("option", newValue);
					if(divCombofield.store.getData().items)	{
						divCombofield.select(divCombofield.store.getData().items[0]);
					}
						
				}
			}
		},
		{
			fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('divComboStore'),
			allowBlank: false,
			autoSelect : true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
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
		}]
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
	var masterGrid = Unilite.createGrid('s_biv305skrv_mitGrid_1', {
//		title: '품목별',
		store : directMasterStore1,
		region: 'center' ,
		layout : 'fit',
		excelTitle: '<t:message code="system.label.inventory.onhandqtybyitem" default="현재고현황(품목별)"/>',
		uniOpt:{
			expandLastColumn: true,
			useRowNumberer: false,
			useMultipleSorting: true,
			//20191205 필터기능 추가
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		tbar:[{xtype:'uniNumberfield', labelWidth: 110, fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>', id:'selectionSummary', value:0, decimalPrecision:4, format:'0,000.0000',readOnly:true}],
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
		columns:  [
			{dataIndex: 'ITEM_ACCOUNT'	, width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
			},
			{dataIndex: 'ACCOUNT1'		, width: 66, hidden:true},
			{dataIndex: 'DIV_CODE'		, width: 66, hidden:true},
//			{dataIndex: 'ITEM_LEVEL1'	, width: 120,align:'center', locked: true},
//			{dataIndex: 'ITEM_LEVEL2'	, width: 100,align:'center', locked: true},
//			{dataIndex: 'ITEM_LEVEL3'	, width: 100,align:'center', locked: true},
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 200},
			{dataIndex: 'SPEC'			, width: 180},
			{dataIndex: 'STOCK_UNIT'	, width: 80,align:'center'},
			{dataIndex: 'STOCK_P'		, width: 100, hidden: AvgPHiddenYN},
			{dataIndex: 'STOCK_Q'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'STOCK_AMT'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_Q'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_AMT', width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK_Q'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK_AMT'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'LOCATION'		, width: 86, hidden:true},
			{dataIndex: 'CUSTOM_CODE'	, width: 86, hidden:true},
			{dataIndex: 'CUSTOM_NAME'	, width: 86, hidden:true},
			{dataIndex: 'RECEIPT_DATE'	, width: 86, align:'center', hidden:true}
		] ,
		listeners:{
			//20210311 추가: 마우스 오른 쪽 클릭 - 기간별 수불현황으로 링크 로직 추가
			itemmouseenter:function(view, record, item, index, e, eOpts) {
				view.ownerGrid.setCellPointer(view, item);
			},
			selectionchange:function(grid, selection, eOpts) {
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
			}
		},
		//20210311 추가: 마우스 오른 쪽 클릭 - 기간별 수불현황으로 링크 로직 추가
		onItemcontextmenu:function(menu, grid, record, item, index, event) {
			menu.down('#linkBiv360skrv').show();
		},
		uniRowContextMenu:{
			items: [{
				text	: '기간별 수불현황 이동',
				itemId	: 'linkBiv360skrv',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoBiv360skrv(param.record);
				}
			}]
		},
		gotoBiv360skrv:function(record) {
			if(record) {
				var params = {
					action			: 'select',
					'PGM_ID'		: PGM_ID,
					'DIV_CODE'		: record.data['DIV_CODE'],
					'ITEM_CODE'		: record.data['ITEM_CODE'],
					'ITEM_NAME'		: record.data['ITEM_NAME']
				}
				var rec = {data : {prgID : 'biv360skrv', 'text':''}};
				parent.openTab(rec, '/stock/biv360skrv.do', params);
			}
		}
	});


	var masterGrid3 = Unilite.createGrid('s_biv305skrv_mitGrid_3', {
//		title: 'LOT별',
		store : directMasterStore3,
		region: 'center' ,
		layout : 'fit',
		excelTitle: '<t:message code="system.label.inventory.onhandqtybylot" default="현재고현황(LOT별)"/>',
		uniOpt:{
			expandLastColumn: true,
			useRowNumberer: false,
			useMultipleSorting: true,
			//20191205 필터기능 추가
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		tbar:[{xtype:'uniNumberfield', labelWidth: 110, fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>', id:'selectionSummary3', value:0, decimalPrecision:4, format:'0,000.0000',readOnly:true}],
		features: [ {id : 'masterGridSubTotal3', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal3',	ftype: 'uniSummary',	  showSummaryRow: true} ],
		columns:  [
			{dataIndex: 'LOT_NO'			,		width: 115,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
			},
			{dataIndex: 'WH_CODE'			, width: 85},
			{dataIndex: 'WH_NAME'			, width: 100},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'SPEC'				, width: 140},
			{dataIndex: 'STOCK_UNIT'		, width: 80 , align:'center'},
			{dataIndex: 'STOCK'				, width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK'			, width: 100, summaryType: 'sum'},
			//{dataIndex: 'REMARK'			, width: 100},
			{dataIndex: 'DIV_CODE'			, width: 66 , hidden: true},
			{dataIndex: 'WH_CODE'			, width: 100, hidden: true},
			//20190603 거래처, 구매단가
			{dataIndex: 'CUSTOM_NAME'		, width: 200},
			{dataIndex: 'PURCHASE_BASE_P'	, width: 100},
			
			{dataIndex: 'LOCATION'	, width: 150, hidden:true},
			//20190529 제조일자, 사용기한 추가
			{dataIndex: 'MAKE_DATE'			, width: 90},
			{dataIndex: 'MAKE_EXP_DATE'		, width: 90}
		] ,
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
			}
		}
	});

	var masterGrid4 = Unilite.createGrid('s_biv305skrv_mitGrid_4', {
//		title: '외주처별',
		store : directMasterStore4,
		region: 'center' ,
		layout : 'fit',
		excelTitle: '<t:message code="system.label.inventory.onhandqtybysubcontract" default="현재고현황(외주처별)"/>',
		uniOpt:{
			expandLastColumn: true,
			useRowNumberer: false,
			useMultipleSorting: true,
			//20191205 필터기능 추가
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		tbar:[{xtype:'uniNumberfield', labelWidth: 110, fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>', id:'selectionSummary4', value:0, decimalPrecision:4, format:'0,000.0000',readOnly:true}],
		features: [ {id : 'masterGridSubTotal4', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal4',	ftype: 'uniSummary',	  showSummaryRow: true} ],
		columns:  [
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'CUSTOM_NAME'	, width: 200,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
			},
			{dataIndex: 'ITEM_CODE'		, width: 100},
			{dataIndex: 'ITEM_NAME'		, width: 200},
			{dataIndex: 'SPEC'			, width: 100},
			{dataIndex: 'STOCK_UNIT'	, width: 100,align:'center'},
			{dataIndex: 'STOCK_P'		, width: 100, hidden: AvgPHiddenYN},
			{dataIndex: 'STOCK_Q'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'STOCK_AMT'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_Q'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_AMT', width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK_Q'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK_AMT'	, width: 100, summaryType: 'sum'}
		] ,
		listeners:{
			selectionchange:function( grid, selection, eOpts ) {
				if(selection && selection.startCell) {
					var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary4");
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
			}
		}
	});


	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab:  0,
		region: 'center',
		items:  [{
				title: '<t:message code="system.label.inventory.itemby" default="품목별"/>',
				xtype:'container',
				layout:{type:'vbox', align:'stretch'},
				items:[itemSubForm, masterGrid],
				id: 's_biv305skrv_mitGrid1'
			},{
				title: '<t:message code="system.label.inventory.byeachlot" default="LOT별"/>',
				xtype:'container',
				layout:{type:'vbox', align:'stretch'},
				items:[lotSubForm, masterGrid3],
				id: 's_biv305skrv_mitGrid3'
			},{
				title: '<t:message code="system.label.inventory.parenbyeachsubcontract" default="외주처별"/>',
				xtype:'container',
				layout:{type:'vbox', align:'stretch'},
				items:[customSubForm, masterGrid4],
				id: 's_biv305skrv_mitGrid4'
			}
		]
	});



	Unilite.Main({
		id  : 's_biv305skrv_mitApp',
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
			panelSearch.getField('COMP_CODE').select(panelSearch.getField('COMP_CODE').store.getData().items[0]);
			panelResult.getField('COMP_CODE').select(panelResult.getField('COMP_CODE').store.getData().items[0]);
			UniAppManager.setToolbarButtons('reset',true);
			
		},
		onQueryButtonDown : function() {
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 's_biv305skrv_mitGrid1'){
				directMasterStore1.loadStoreRecords();
			}
			else if(activeTabId == 's_biv305skrv_mitGrid3'){
				directMasterStore3.loadStoreRecords();
			}
			else if(activeTabId == 's_biv305skrv_mitGrid4'){
				directMasterStore4.loadStoreRecords();
			}
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();

			masterGrid.getStore().loadData({});
			masterGrid3.getStore().loadData({});
			masterGrid4.getStore().loadData({});

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
