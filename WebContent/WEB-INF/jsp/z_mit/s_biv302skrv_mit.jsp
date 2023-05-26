<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_biv302skrv_mit"  >
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 					<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B267" /> 
	<t:ExtComboStore items="${COMBO_DIV_CODE}" storeId="divComboStore" /><!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_CODE}" storeId="whCodeComboStore" /><!-- 사업장 -->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {	//컨트롤러에서 값을 받아옴.
	gsAvgPHiddenYN	: '${gsAvgPHiddenYN}',
	gsDivCode       : '${gsDivCode}',
	gsWhCode        : '${gsWhCode}'
};

function appMain() {
	var AvgPHiddenYN = false;	// 현재고 단가필드 숨김여부 (Y:숨김, N:보여줌)
	if(BsaCodeInfo.gsAvgPHiddenYN =='Y') {
		AvgPHiddenYN = true;
	}

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_biv302skrv_mitModel', {
		fields: [
			{name: 'ITEM_ACCOUNT',		text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',				type: 'string'},
			{name: 'ACCOUNT1',			text: '<t:message code="system.label.inventory.itemaccountcode" default="품목계정코드"/>',		type: 'string'},
			{name: 'DIV_CODE',			text: '<t:message code="system.label.inventory.division" default="사업장"/>',					type: 'string'},
			{name: 'ITEM_CODE',			text: '<t:message code="system.label.inventory.item" default="품목"/>',						type: 'string'},
			{name: 'ITEM_NAME',			text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',						type: 'string'},
			{name: 'SPEC',				text: '<t:message code="system.label.inventory.spec" default="규격"/>',						type: 'string'},
			{name: 'STOCK_UNIT',		text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',			type: 'string'},
			{name: 'STOCK_Q',			text: '<t:message code="system.label.inventory.totalinventoryqty" default="총재고량"/>',		type: 'uniQty'},
			{name: 'GOOD_STOCK_Q',		text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>',			type: 'uniQty'},
			{name: 'BAD_STOCK_Q',		text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>',		type: 'uniQty'},
			{name: 'LOCATION',			text: 'LOCATION',		type: 'string'},
			{name: 'CUSTOM_CODE',		text: '<t:message code="system.label.inventory.maincustomcode" default="주거래처코드"/>',			type: 'string'},
			{name: 'CUSTOM_NAME',		text: '<t:message code="system.label.inventory.maincustom" default="주거래처"/>',				type: 'string'},
			{name: 'RECEIPT_DATE',		text: '최종접수일',				type: 'uniDate'}
		]
	});




	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_biv302skrv_mitMasterStore1',{
		model: 's_biv302skrv_mitModel',
		uniOpt : {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {read: 's_biv302skrv_mitService.selectMaster'}
		},
		loadStoreRecords : function() {
			var param= panelResult.getValues();
			if(!panelResult.getInvalidMessage()) return;
			
			param.QUERY_TYPE = '1'
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
				fieldLabel: '본사 사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				autoSelect : true,
				child :'WH_CODE',
				store: Ext.data.StoreManager.lookup('divComboStore'),
				allowBlank: false,
				value  : BsaCodeInfo.gsDivCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				autoSelect : true,
				store: Ext.data.StoreManager.lookup('whCodeComboStore'),
				allowBlank: false,
				value  : BsaCodeInfo.gsWhCode,
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
			Unilite.popup('AGENT_DIV_PUMOK',{
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
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				name :'COMP_CODE',
				xtype :'uniTextfield',
				value :'MASTER',
				hidden : true
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
			fieldLabel: '본사 사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('divComboStore'),
			allowBlank: false,
			autoSelect : true,
			child :'WH_CODE',
			value  : BsaCodeInfo.gsDivCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			autoSelect : true,
			store: Ext.data.StoreManager.lookup('whCodeComboStore'),
			allowBlank: false,
			value  : BsaCodeInfo.gsWhCode,
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
			multiSelect:true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},
		Unilite.popup('AGENT_DIV_PUMOK',{
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
			name :'COMP_CODE',
			xtype :'uniTextfield',
			value :'MASTER',
			hidden : true
		}]
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_biv302skrv_mitGrid_1', {
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
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 200},
			{dataIndex: 'SPEC'			, width: 180},
			{dataIndex: 'STOCK_UNIT'	, width: 80,align:'center'},
			{dataIndex: 'STOCK_Q'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_Q'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK_Q'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'LOCATION'		, width: 86, hidden:true},
			{dataIndex: 'CUSTOM_CODE'	, width: 86, hidden:true},
			{dataIndex: 'CUSTOM_NAME'	, width: 86, hidden:true},
		] ,
		listeners:{
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
		}
	});

	Unilite.Main({
		id  : 's_biv302skrv_mitApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset',true);
			
		},
		onQueryButtonDown : function() {
			directMasterStore1.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();

			masterGrid.getStore().loadData({});

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
