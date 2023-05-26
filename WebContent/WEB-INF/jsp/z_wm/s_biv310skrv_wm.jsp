<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_biv310skrv_wm">
	<t:ExtComboStore comboType="BOR120"/>									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020"/>						<!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>			<!--창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList"/>	<!--창고Cell-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store"/>
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">


function appMain() {
	var gsPlannedQArray	= new Array();										//입고예정 관련 array
	var gsPlannedQArray2= new Array();										//입고예정 관련 array2
	var gsOnhandQArray	= new Array();										//현재고 관련 array
	var gsOnhandQArray2	= new Array();										//현재고 관련 array2
	var colData			= Ext.isEmpty(${colData}) ?		'' : ${colData};	//입고처
	var colData2		= Ext.isEmpty(${colData2}) ?	'' : ${colData2};	//창고
	var fields			= createModelField(colData, colData2);
	var columns			= createGridColumn(colData, colData2);


	/* 조회조건
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
			layout	: {type: 'uniTable', columns: 1},
			items	: [{
				fieldLabel	: '<t:message code="system.label.equipment.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				child		: 'WH_CODE',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
//			},{
//				fieldLabel	: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
//				name		: 'WH_CODE',
//				xtype		: 'uniCombobox',
//				store		: Ext.data.StoreManager.lookup('whList'),
//				listeners	: {
//					change: function(field, newValue, oldValue, eOpts) {
//						panelResult.setValue('WH_CODE', newValue);
//					}
//				}
			},{
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
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue) {
						panelResult.setValue('ITEM_CODE', newValue);
						if(Ext.isEmpty(newValue)) {
							panelSearch.setValue('ITEM_NAME', newValue);
							panelResult.setValue('ITEM_NAME', newValue);
						}
					},
					onTextFieldChange: function(field, newValue) {
						panelResult.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
				name		: 'TXTLV_L1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'TXTLV_L2',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TXTLV_L1', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
				name		: 'TXTLV_L2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child		: 'TXTLV_L3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TXTLV_L2', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
				name		: 'TXTLV_L3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames	: ['TXTLV_L1','TXTLV_L2'],
				levelType	: 'ITEM',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TXTLV_L3', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding		: '1 1 1 1',
		border		: true,
		hidden		: !UserInfo.appOption.collapseLeftSearch,
		items		: [{
			fieldLabel	: '<t:message code="system.label.equipment.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			child		: 'WH_CODE',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
//		},{
//			fieldLabel	: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
//			name		: 'WH_CODE',
//			xtype		: 'uniCombobox',
//			store		: Ext.data.StoreManager.lookup('whList'),
//			listeners	: {
//				change: function(field, newValue, oldValue, eOpts) {
//					panelSearch.setValue('WH_CODE', newValue);
//				}
//			}
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
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue) {
					panelSearch.setValue('ITEM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('ITEM_NAME', newValue);
						panelResult.setValue('ITEM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue) {
					panelSearch.setValue('ITEM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
			name		: 'TXTLV_L1',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
			child		: 'TXTLV_L2',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXTLV_L1', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
			name		: 'TXTLV_L2',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
			child		: 'TXTLV_L3',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXTLV_L2', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
			name		: 'TXTLV_L3',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
			parentNames	: ['TXTLV_L1','TXTLV_L2'],
			levelType	: 'ITEM',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXTLV_L3', newValue);
				}
			}
		}]
	});



	Unilite.defineModel('s_biv310skrv_wmMModel', {
		fields : fields
	});

	var masterStore = Unilite.createStore('s_biv310skrv_wmMasterStore',{
		model	: 's_biv310skrv_wmMModel',
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_biv310skrv_wmService.selectList'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param = panelResult.getValues();
			if(!Ext.isEmpty(gsPlannedQArray)) {
				param.gsPlannedQArray = gsPlannedQArray;
			}
			if(!Ext.isEmpty(gsPlannedQArray2)) {
				param.gsPlannedQArray2 = gsPlannedQArray2;
			}
			if(!Ext.isEmpty(gsOnhandQArray)) {
				param.gsOnhandQArray = gsOnhandQArray;
			}
			if(!Ext.isEmpty(gsOnhandQArray2)) {
				param.gsOnhandQArray2 = gsOnhandQArray2;
			}
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
				}
			},
			write: function(proxy, operation){
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			},
			remove: function( store, records, index, isMove, eOpts ) {
			}
		}
	});

	var masterGrid = Unilite.createGrid('s_biv310skrv_wmGrid', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		columns	: columns,
		listeners: {
			selectionchange: function( grid, selected, eOpts ){
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ){
			}
		}
	});



	Unilite.Main({
		id			: 's_biv310skrv_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		},
			panelSearch
		],
		fnInitBinding : function(params) {
			this.setDefault();
		},
		setDefault: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);

			//초기화 시, 포커스 설정
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function () {
			if(!this.isValidSearchForm()){
				return false;
			}
			createStore_onQuery();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});



	// 모델 필드 생성
	function createModelField(colData, colData2) {
		var fields = [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'			, type: 'string'},
			{name: 'SUM_QTY'			, text: '<t:message code="system.label.inventory.totalamount" default="합계"/>'	, type:'uniQty'},
			{name: 'REMAIN_ORDER_Q'		, text: '발주'			, type:'uniQty'}
		];
		//동적 컬럼 모델 push
		Ext.each(colData, function(item, index){
			fields.push({name: 'RECEIPT_PLANNED_' + item.SUB_CODE, type:'uniQty' });
		});
		Ext.each(colData2, function(item, index){
			fields.push({name: 'ONHAND_STOCK_' + item.TREE_CODE, type:'uniQty' });
		});
		return fields;
	}
	// 그리드 컬럼 생성
	function createGridColumn(colData, colData2) {
		var array1	= new Array();
		var array2	= new Array();
		var columns	= [
			{dataIndex: 'COMP_CODE'		, text: 'COMP_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'		, text: 'DIV_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'ITEM_CODE'		, text: '<t:message code="system.label.product.itemcode" default="품목코드"/>'		, width: 120	, style: {textAlign: 'center'}},
			{dataIndex: 'ITEM_NAME'		, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		, width: 150	, style: {textAlign: 'center'}},
			{dataIndex: 'SPEC'			, text: '<t:message code="system.label.product.spec" default="규격"/>'			, width: 120	, style: {textAlign: 'center'}},
			{dataIndex: 'SUM_QTY'		, text: '<t:message code="system.label.inventory.totalamount" default="합계"/>'	, width: 110	, style: 'text-align: center',	align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum' }
		];
		//입고예정 컬럼 생성
		array1[0] = Ext.applyIf({dataIndex: 'REMAIN_ORDER_Q'	, text: '발주'	, width:110	, style: {textAlign: 'center'}},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum' });
		Ext.each(colData, function(item, index){
			if(index == 0){
				gsPlannedQInfo	= 'RECEIPT_PLANNED_' + item.SUB_CODE;
				gsPlannedQInfo2	= item.SUB_CODE;
			} else {
				gsPlannedQInfo	+= ',' + 'RECEIPT_PLANNED_' + item.SUB_CODE;
				gsPlannedQInfo2	+= ',' + item.SUB_CODE;
			}
			array1[index+1] = Ext.applyIf({dataIndex: 'RECEIPT_PLANNED_' + item.SUB_CODE	, text: item.CODE_NAME	, width:110	, style: {textAlign: 'center'}},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum' });
		});
		columns.push(
			{text: '<t:message code="system.label.inventory.receiptplanned" default="입고예정"/>',
				columns: array1
			}
		);
		//현재고 컬럼 생성
		Ext.each(colData2, function(item, index){
			if(index == 0){
				gsOnhandQInfo	= 'ONHAND_STOCK_' + item.TREE_CODE;
				gsOnhandQInfo2	= item.TREE_CODE;
			} else {
				gsOnhandQInfo	+= ',' + 'ONHAND_STOCK_' + item.TREE_CODE;
				gsOnhandQInfo2	+= ',' + item.TREE_CODE;
			}
			array2[index] = Ext.applyIf({dataIndex: 'ONHAND_STOCK_' + item.TREE_CODE	, text: item.TREE_NAME	, width:110	, style: {textAlign: 'center'}},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum' });
		});
		columns.push(
			{text: '<t:message code="system.label.inventory.onhandstock" default="현재고"/>',
				columns: array2
			}
		);
		gsPlannedQArray	= gsPlannedQInfo.split(',');
		gsPlannedQArray2= gsPlannedQInfo2.split(',');
		gsOnhandQArray	= gsOnhandQInfo.split(',');
		gsOnhandQArray2	= gsOnhandQInfo2.split(',');
		return columns;
	}



	function createStore_onQuery() {
		var records, fields, columns
		// 그리드 컬럼명 조건에 맞게 재 조회하여 입력
		var param = panelResult.getValues();
		s_biv310skrv_wmService.selectColumns2_1(param, function(provider, response) {
			records	= response.result;
			fields	= createModelField(colData, records);
			columns	= createGridColumn(colData, records);
			masterStore.setFields(fields);
			masterGrid.setColumnInfo(masterGrid, columns, fields);
			masterGrid.reconfigure(masterStore, columns);
			masterStore.loadStoreRecords();
		});
	}
};
</script>