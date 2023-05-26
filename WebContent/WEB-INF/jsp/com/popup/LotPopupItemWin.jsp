<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
	request.setAttribute("PKGNAME","Unilite.app.popup.LotPopupItem");
%>
	<t:ExtComboStore useScriptTag="false" items="${COMBO_WH_LIST}" storeId="whList" />			//창고
	<t:ExtComboStore useScriptTag="false" items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	// 창고 CELL
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B020" />					//품목계정 


//20200106 추가: 적용버튼 추기에 따라.. 첫 번째 적용과 두 번째 적용이 다른 로직을 수행해야하므로 구분하기 위한 변수 추가
var applyCount = 0;

/** Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.LotPopupItemModel', {
	fields: [
		{name: 'ITEM_CODE'			,text:'<t:message code="system.label.common.itemcode" default="품목코드"/>'						,type : 'string'},
		{name: 'ITEM_NAME'			,text:'<t:message code="system.label.common.itemname" default="품목명"/>'						,type : 'string'},
		{name: 'SPEC'				,text:'<t:message code="system.label.common.spec" default="규격"/>'							,type : 'string'},
		{name: 'SPEC_NUM'			,text:'<t:message code="system.label.common.spec" default="규격"/>'							,type : 'int'},
		{name: 'STOCK_UNIT'			,text:'<t:message code="system.label.common.inventoryunit" default="재고단위"/>'				,type : 'string'},
		{name: 'ORDER_UNIT'			,text:'<t:message code="system.label.common.purchaseunit" default="구매단위"/>'					,type : 'string'},
		{name: 'TRNS_RATE'			,text:'<t:message code="system.label.common.conversioncoeff" default="변환계수"/>'				,type : 'uniER'},
		{name: 'BASIS_P'			,text:'<t:message code="system.label.common.inventoryprice" default="재고단가"/>'				,type : 'uniUnitPrice'},
		{name: 'SALE_BASIS_P'		,text:'<t:message code="system.label.common.sellingprice" default="판매단가"/>'					,type : 'uniUnitPrice'},
		{name: 'BARCODE'			,text:'<t:message code="system.label.common.barcode" default="바코드"/>'						,type : 'string'},
		{name: 'SAFE_STOCK_Q'		,text:'<t:message code="system.label.common.safetystockqty" default="안전재고량"/>'				,type : 'uniUnitPrice'},
		{name: 'EXPENSE_RATE'		,text:'<t:message code="system.label.common.importexpenserate" default="수입부대비용율"/>'			,type : 'uniER'},
		{name: 'SPEC_NUM'			,text:'<t:message code="system.label.common.drawingnumber" default="도면번호"/>'				,type : 'string'},
		{name: 'WORK_SHOP_CODE'		,text:'<t:message code="system.label.common.mainworkcenter" default="주작업장"/>'				,type : 'string'},
		{name: 'DIV_CODE'			,text:'<t:message code="system.label.common.standarddivision" default="기준사업장"/>'			,type : 'string'},
		{name: 'OUT_METH'			,text:'<t:message code="system.label.common.issuemethod" default="출고방법"/>'					,type : 'string',comboType:'AU', comboCode:'B039'},
		{name: 'ITEM_MAKER'			,text:'<t:message code="system.label.common.mfgmaker" default="제조메이커"/>'					,type : 'string'},
		{name: 'ITEM_MAKER_PN'		,text:'<t:message code="system.label.common.makerpartno" default="메이커 PART NO"/>'			,type : 'string'},
		{name: 'PURCH_LDTIME'		,text:'<t:message code="system.label.common.purchaselt" default="구매 L/T"/>'					,type : 'string'},
		{name: 'MINI_PURCH_Q'		,text:'<t:message code="system.label.common.minumunorderqty" default="최소발주량"/>'				,type : 'uniQty'},
		{name: 'UNIT_WGT'			,text:'<t:message code="system.label.common.unitweight" default="단위중량"/>'					,type : 'string'},
		{name: 'WGT_UNIT'			,text:'<t:message code="system.label.common.weightunit" default="중량단위"/>'					,type : 'string'},
		{name: 'ITEM_ACCOUNT'		,text:'<t:message code="system.label.common.itemaccount" default="품목계정"/>'					,type : 'string',comboType:'AU', comboCode:'B020'},
		{name: 'DOM_FORIGN'			,text:'<t:message code="system.label.common.domesticoverseas" default="국내외"/>'				,type : 'string',comboType:'AU', comboCode:'B019'},
		{name: 'SUPPLY_TYPE'		,text:'<t:message code="system.label.common.procurementclassification" default="조달구분"/>'	,type : 'string',comboType:'AU', comboCode:'B014'},
		{name: 'HS_NO'				,text:'<t:message code="system.label.common.hsno" default="HS번호"/>'							,type : 'string'},
		{name: 'HS_NAME'			,text:'<t:message code="system.label.common.hsname" default="HS명"/>'						,type : 'string'},
		{name: 'HS_UNIT'			,text:'<t:message code="system.label.common.hsunit" default="HS단위"/>'						,type : 'string'},
		{name: 'STOCK_UNIT'			,text:'<t:message code="system.label.common.inventoryunit" default="재고단위"/>'				,type : 'string'},
		{name: 'TAX_TYPE'			,text:'<t:message code="system.label.common.taxabledivision" default="과세구분"/>'				,type : 'string'},
		{name: 'STOCK_CARE_YN'		,text:'<t:message code="system.label.common.inventorymanagementyn" default="재고관리여부"/>'		,type : 'string'},
		{name: 'SALE_UNIT'			,text:'<t:message code="system.label.common.salesunit" default="판매단위"/>'					,type : 'string'},
		{name: 'ITEM_GROUP'			,text:'<t:message code="system.label.common.repmodel" default="대표모델"/>'						,type : 'string'},
		{name: 'ITEM_GROUP_NAME'	,text:'<t:message code="system.label.common.repmodelname" default="대표모델명"/>'				,type : 'string'},
		{name: 'ITEM_LEVEL1'		,text:'<t:message code="system.label.common.majorgroup" default="대분류"/>'					,type : 'string'},
		{name: 'ITEM_LEVEL_NAME1'	,text:'<t:message code="system.label.common.majorgroupname" default="대분류명"/>'				,type : 'string'},
		{name: 'ITEM_LEVEL2'		,text:'<t:message code="system.label.common.middlegroup" default="중분류"/>'					,type : 'string'},
		{name: 'ITEM_LEVEL_NAME2'	,text:'<t:message code="system.label.common.middlegroupname" default="중분류명"/>'				,type : 'string'},
		{name: 'ITEM_LEVEL3'		,text:'<t:message code="system.label.common.minorgroup" default="소분류"/>'					,type : 'string'},
		{name: 'ITEM_LEVEL_NAME3'	,text:'<t:message code="system.label.common.minorgroupname" default="소분류명"/>'				,type : 'string'},
		{name: 'LOT_SIZING_Q'		,text:'<t:message code="system.label.common.minimumlotsize" default="최소LotSize"/>'			,type : 'uniQty'},
		{name: 'MAX_PRODT_Q'		,text:'<t:message code="system.label.common.maximumproductqty" default="최대생산량"/>'			,type : 'uniQty'},
		{name: 'STAN_PRODT_Q'		,text:'<t:message code="system.label.common.standardproductionqty" default="표준생산량"/>'		,type : 'uniQty'},
		{name: 'TOTAL_ITEM'			,text:'<t:message code="system.label.common.summaryitemcode2" default="집계품목"/>'				,type : 'string'},
		{name: 'MAIN_CUSTOM_CODE'	,text:'<t:message code="system.label.common.custom" default="거래처"/>'						,type : 'string'},
		{name: 'MAIN_CUSTOM_NAME'	,text:'<t:message code="system.label.common.customname" default="거래처명"/>'					,type : 'string'},
		{name: 'LOT_YN'				,text:'<t:message code="system.label.common.lotmanageyn" default="LOT관리여부"/>'				,type : 'string'},
		{name: 'OEM_ITEM_CODE'		,text:'<t:message code="system.label.common.oemitemcode" default="품번(OEM)"/>'				,type : 'string'},
		{name: 'INSPEC_YN'			,text:'<t:message code="system.label.common.qualityyn" default="품질대상여부"/>'					,type : 'string'},
		{name: 'CAR_TYPE'			,text:'<t:message code="system.label.common.cartype" default="차종"/>'						,type : 'string'},
		{name: 'PURCHASE_BASE_P'	,text:'<t:message code="system.label.common.price" default="단가"/>'							,type : 'uniPrice'},
		{name: 'EXPIRATION_DAY'		,text:'유효기간'		,type : 'int'},
		{name: 'PRODUCT_LDTIME'		,text:'제조리드타임'		,type : 'int'},
		{name: 'TRNS_RATE'			,text:'TRNS_RATE'	,type: 'uniQty'},
		{name: 'WH_CODE'			,text: '<t:message code="system.label.common.warehouse" default="창고"/>'						,type: 'string', store: Ext.data.StoreManager.lookup('whList')},
		{name: 'WH_CELL_CODE'		,text: '<t:message code="system.label.common.warehouse" default="창고"/>cell'					,type: 'string', store: Ext.data.StoreManager.lookup('whCellList')},
		{name: 'LOT_NO'				,text: '<t:message code="system.label.common.lotno" default="LOT번호"/>'						,type: 'string'},
		{name: 'LOTNO_CODE'			,text: '<t:message code="system.label.common.lotno" default="LOT번호"/>'						,type: 'string'},
		{name: 'INSTOCK_Q'			,text: '<t:message code="system.label.common.receiptqty" default="입고수량"/>'					,type: 'uniQty'},
		{name: 'OUTSTOCK_Q'			,text: '<t:message code="system.label.common.issueqty" default="출고량"/>'						,type: 'uniQty'},
		{name: 'STOCK_Q'			,text: '<t:message code="system.label.common.onhandstock" default="현재고"/>'					,type: 'uniQty'},
		{name: 'GOOD_STOCK_Q'		,text: '<t:message code="system.label.common.goodstock" default="양품재고"/>'					,type: 'uniQty'},
		{name: 'BAD_STOCK_Q'		,text: '<t:message code="system.label.common.defectinventory" default="불량재고"/>'				,type: 'uniQty'},
		{name: 'COMP_CODE'			,text: 'COMP_CODE'	,type: 'string'},
		{name: 'REMARK'				,text: '<t:message code="system.label.common.remarks" default="비고"/>'						,type: 'string'}
	]
});


Ext.define('${PKGNAME}', {
	extend		: 'Unilite.com.BaseJSPopupApp',
	constructor	: function(config){
		var me = this;
		if (config) {
			Ext.apply(me, config);
		}

		var wParam = this.param;

		/** 검색조건 (Search Panel)
		 * @type 
		 */
		var wParam = this.param;
		var t1= false, t2 = false;
		if( Ext.isDefined(wParam)) {
			if(wParam['TYPE'] == 'VALUE') {
				t1 = true;
				t2 = false;
				
			} else {
				t1 = false;
				t2 = true;
				
			}
		}

		me.panelSearch = Unilite.createSearchForm('',{
			layout : {type : 'table', columns : 3, tableAttrs: {
				style: {
					width: '100%'
				}
			}},
			items: [{
					fieldLabel	: '<t:message code="system.label.common.division" default="사업장"/>',
					name		: 'DIV_CODE', 
					xtype		: 'uniCombobox', 
					comboType	: 'BOR120',
					allowBlank	: false
				},
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel		: '<t:message code="system.label.common.itemcode" default="품목코드"/>',
					validateBlank	: false
				}),{
					fieldLabel	: '<t:message code="system.label.common.lotno" default="LOT번호"/>',
					name		: 'LOTNO_CODE',	
					xtype		: 'uniTextfield',
					listeners	: {
						specialkey: function(field, e){
							if (e.getKey() == e.ENTER) {
								me.onQueryButtonDown();
							}
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.common.warehouse" default="창고"/>',
					name		: 'S_WH_CODE', 
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('whList'),
					child		: 'S_WH_CELL_CODE',
					listeners	: {
						beforequery:function( queryPlan, eOpts ) {
							var store = queryPlan.combo.store;
							var psStore = me.panelSearch.getField('S_WH_CODE').store;
							store.clearFilter();
							psStore.clearFilter();
							if(!Ext.isEmpty(me.panelSearch.getValue('DIV_CODE'))){
								store.filterBy(function(record){
									return record.get('option') == me.panelSearch.getValue('DIV_CODE');
								});
								psStore.filterBy(function(record){
									return record.get('option') == me.panelSearch.getValue('DIV_CODE');
								});
							}else{
								store.filterBy(function(record){
									return false;	
								});
								psStore.filterBy(function(record){
									return false;	
								});
							}
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.base.warehousecell" default="창고Cell"/>',
					name		: 'S_WH_CELL_CODE', 
					xtype		: 'uniCombobox', 
					store		: Ext.data.StoreManager.lookup('whCellList'),
					listeners	: {
						beforequery:function( queryPlan, eOpts ) {
							var store = queryPlan.combo.store;
							var psStore = me.panelSearch.getField('S_WH_CELL_CODE').store;
							store.clearFilter();
							psStore.clearFilter();
							if(!Ext.isEmpty(me.panelSearch.getValue('S_WH_CODE'))){
								store.filterBy(function(record){
									return record.get('option') == me.panelSearch.getValue('S_WH_CODE');
								});
								psStore.filterBy(function(record){
									return record.get('option') == me.panelSearch.getValue('S_WH_CODE');
								});
							}else{
								store.filterBy(function(record){
									return false;
								});
								psStore.filterBy(function(record){
									return false;
								});
							}
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.common.account" default="계정"/>',
					name		: 'ITEM_ACCOUNT',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B020',
					listeners	: {
						beforequery: function(queryPlan, eOpts ) {
//							var fValue = me.panelSearch.getValue('ITEM_ACCOUNT');
//							var store = queryPlan.combo.getStore();
//							if(!Ext.isEmpty(fValue) ) {
//								store.clearFilter(true);
//								queryPlan.combo.queryFilter = null;	
//								console.log("fValue :",fValue);
//								store.filterBy(function(record, id){
//									console.log("record :",record.get('value'),fValue.indexOf(record.get('value')));
//									return fValue.indexOf(record.get('value')) > -1 ? record:null;
//								});
//							} else {
//								store.clearFilter(true);
//								queryPlan.combo.queryFilter = null;	
//								store.loadRawData(store.proxy.data);
//							}
						}
					}
				}
			]
		}); 



		/** Master Grid 정의(Grid Panel)
		 * @type 
		 */
		var masterGridConfig = {
			store: Unilite.createStoreSimple('${PKGNAME}.LotPopupItemMasterStore',{
				model	: '${PKGNAME}.LotPopupItemModel',
				autoLoad: false,
				proxy	: {
					type: 'uniDirect',
					api: {
						read: 'popupService.lotItemPopup'
					}
				}
			}),
			uniOpt:{
				onLoadSelectFirst	: false,
				useRowNumberer		: false,
				useLiveSearch		: true,			//20200309 추가: 그리드 찾기기능 추가
				state: {
					//20200212 수정: 그리드 설정 가능하도록 true로 변경
					useState	: true,
					useStateList: true	
				},
				filter: {
					useFilter	: true,
					autoCreate	: true
				},
				pivot : {
					use : false
				}
			},
			selModel	: 'rowmodel',
			tbar		: [{
				xtype	: 'button',
				text	: '<t:message code="system.label.commonJS.excel.btnApply" default="적용"/>',
				tooltip	: '<t:message code="system.label.commonJS.excel.btnApply" default="적용"/>',  
				width	: 60,
				handler	: function() {
					me.onApplyButtonDown();
				}
			}],
			columns: [
				{dataIndex: 'ITEM_CODE'			, width: 120},
				{dataIndex: 'ITEM_NAME'			, width: 240},
				{dataIndex: 'SPEC'				, width: 160},
				{dataIndex : 'LOT_NO'			, width :120},
				{dataIndex: 'STOCK_UNIT'		, width: 80 },
				{dataIndex: 'INSPEC_YN'			, width: 100},
				{dataIndex: 'CAR_TYPE'			, width: 100},
				{dataIndex: 'ORDER_UNIT'		, width: 80   ,hidden:true},
				{dataIndex: 'TRNS_RATE'			, width: 80   ,hidden:true},
				{dataIndex: 'BASIS_P'			, width: 90   ,hidden:true},
				{dataIndex: 'SALE_BASIS_P'		, width: 90   ,hidden:true},
				{dataIndex: 'BARCODE'			, width: 130  ,hidden:true},
				{dataIndex: 'SAFE_STOCK_Q'		, width: 80   ,hidden:true},
				{dataIndex: 'EXPENSE_RATE'		, width: 80   ,hidden:true},
				{dataIndex: 'SPEC_NUM'			, width: 70   ,hidden:true},
				{dataIndex: 'WH_CODE'			, width: 100  ,hidden:true},
				{dataIndex: 'WORK_SHOP_CODE'	, width: 100  ,hidden:true},
				{dataIndex: 'DIV_CODE'			, width: 100  ,hidden:true},
				{dataIndex: 'OUT_METH'			, width: 100  ,hidden:true},
				{dataIndex: 'ITEM_MAKER'		, width: 100  ,hidden:true},
				{dataIndex: 'ITEM_MAKER_PN'		, width: 100  ,hidden:true},
				{dataIndex: 'PURCH_LDTIME'		, width: 100  ,hidden:true},
				{dataIndex: 'MINI_PURCH_Q'		, width: 100  ,hidden:true},
				{dataIndex: 'UNIT_WGT'			, width: 100  ,hidden:true},
				{dataIndex: 'WGT_UNIT'			, width: 100  ,hidden:true},
				{dataIndex: 'ITEM_ACCOUNT'		, width: 100  ,hidden:true},
				{dataIndex: 'DOM_FORIGN'		, width: 100  ,hidden:true},
				{dataIndex: 'SUPPLY_TYPE'		, width: 100  ,hidden:true},
				{dataIndex: 'HS_NO'				, width: 100  ,hidden:true},
				{dataIndex: 'HS_NAME'			, width: 100  ,hidden:true},
				{dataIndex: 'HS_UNIT'			, width: 100  ,hidden:true},
				{dataIndex: 'STOCK_UNIT'		, width: 100  ,hidden:true},
				{dataIndex: 'TAX_TYPE'			, width: 100  ,hidden:true},
				{dataIndex: 'STOCK_CARE_YN'		, width: 100  ,hidden:true},
				{dataIndex: 'SALE_UNIT'			, width: 100  ,hidden:true},
				{dataIndex: 'ITEM_GROUP'		, width: 100  ,hidden:true},
				{dataIndex: 'ITEM_GROUP_NAME'	, width: 100  ,hidden:true},
				{dataIndex: 'ITEM_LEVEL1'		, width: 100  ,hidden:true},
				{dataIndex: 'ITEM_LEVEL_NAME1'	, width: 100  ,hidden:true},
				{dataIndex: 'ITEM_LEVEL2'		, width: 100  ,hidden:true},
				{dataIndex: 'ITEM_LEVEL_NAME2'	, width: 100  ,hidden:true},
				{dataIndex: 'ITEM_LEVEL3'		, width: 100  ,hidden:true},
				{dataIndex: 'ITEM_LEVEL_NAME3'	, width: 100  ,hidden:true},
				{dataIndex: 'LOT_SIZING_Q'		, width: 100  ,hidden:true},
				{dataIndex: 'MAX_PRODT_Q'		, width: 100  ,hidden:true},
				{dataIndex: 'STAN_PRODT_Q'		, width: 100  ,hidden:true},
				{dataIndex: 'TOTAL_ITEM'		, width: 100  ,hidden:true},
				{dataIndex: 'MAIN_CUSTOM_CODE'	, width: 100  ,hidden:true},
				{dataIndex: 'MAIN_CUSTOM_NAME'	, width: 130  },
				{dataIndex: 'LOT_YN'			, width: 100  ,hidden:false},
				{dataIndex: 'OEM_ITEM_CODE'		, width: 100  ,hidden:false},
				{dataIndex: 'EXPIRATION_DAY'	, width: 100  ,hidden:false},
				{dataIndex: 'PRODUCT_LDTIME'	, width: 100  ,hidden:false},
				{dataIndex: 'TRNS_RATE'			, width: 100  ,hidden:true},
				{dataIndex : 'WH_CODE'			, width :150},
				{dataIndex : 'WH_CELL_CODE'		, width :100,
					renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
						combo.store.clearFilter();
						combo.store.filterBy(function(item){
							return item.get('option') == record.get('WH_CODE')
						})
					}
				},
				{dataIndex : 'INSTOCK_Q'		, width :100, hidden: true},
				{dataIndex : 'OUTSTOCK_Q'		, width :100, hidden: true},
				{dataIndex : 'STOCK_Q'			, width :100},
				{dataIndex : 'GOOD_STOCK_Q'		, width :100},
				{dataIndex : 'BAD_STOCK_Q'		, width :100},
				{dataIndex : 'COMP_CODE'		, width :100, hidden: true},
				{dataIndex : 'REMARK'			, width :100, hidden: true}
			],
			listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {
					//20200106 추가
					record.set('applyCount', applyCount);
					var rv = {
						status : "OK",
						data:[record.data]
					};
					me.returnData(rv);
				},
				onGridKeyDown: function(grid, keyCode, e) {
					if(e.getKey() == Ext.EventObject.ENTER) {
						var selectRecord = grid.getSelectedRecord();
						//20200106 추가
						if(!Ext.isEmpty(selectRecord)) {
							selectRecord.set('applyCount', applyCount);
							var rv = {
								status : "OK",
								data:[selectRecord.data]
							};
							me.returnData(rv);
						}
					}
				}
			}
		}
		if(Ext.isDefined(wParam)) {
			if(wParam['SELMODEL'] == 'MULTI') {
				//20191226 수정:  checkOnly : false -> true 
				masterGridConfig.selModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : true });
			}
		}
		me.masterGrid = Unilite.createGrid('', masterGridConfig);
		config.items = [me.panelSearch, me.masterGrid];
		me.callParent(arguments);
	},
	initComponent : function(){
		var me  = this;
		me.masterGrid.focus();
		this.callParent();
	},
	fnInitBinding : function(param) {
		applyCount = 0;
		var me = this;
		me.param = param;
		var frm= me.panelSearch.getForm();

		var fieldTxt = frm.findField('LOTNO_NAME');
		//me.panelSearch.setValue('DIV_CODE', UserInfo.divCode);
		me.panelSearch.setValue('DIV_CODE'		, param.DIV_CODE);
		me.panelSearch.setValue('ITEM_CODE'		, param.ITEM_CODE);
		me.panelSearch.setValue('ITEM_NAME'		, param.ITEM_NAME);
		me.panelSearch.setValue('S_CUSTOM_CODE'	, param.S_CUSTOM_CODE);
		me.panelSearch.setValue('S_CUSTOM_NAME'	, param.S_CUSTOM_NAME);
		me.panelSearch.setValue('S_WH_CODE'		, param.WH_CODE);
		var psStore = me.panelSearch.getField('S_WH_CELL_CODE').store;
		if(!Ext.isEmpty(me.panelSearch.getValue('S_WH_CODE'))){
			psStore.filterBy(function(record){
				return record.get('option') == me.panelSearch.getValue('S_WH_CODE');
			});
		}else{
			psStore.filterBy(function(record){
				return false;
			});
		}
		me.panelSearch.setValue('S_WH_CELL_CODE', param.WH_CELL_CODE);
		me.panelSearch.setValue('LOTNO_CODE'	, param.LOTNO_CODE);

		frm.findField('DIV_CODE').setReadOnly(true);
		if(param && !Ext.isEmpty(param.WH_CODE)) {
			frm.findField('S_WH_CODE').setReadOnly(true);
		}
		if(param && !Ext.isEmpty(param.WH_CELL_CODE)) {
			frm.findField('S_WH_CELL_CODE').setReadOnly(true);
		}

//		if(param.IS_FORM == 'Y'){	//조회폼에서 호출한 팝업일시 readonly(false)
//			frm.findField('ITEM_CODE').setReadOnly(false);
//			frm.findField('ITEM_NAME').setReadOnly(false);
//		}else{
//			frm.findField('ITEM_CODE').setReadOnly(true);
//			frm.findField('ITEM_NAME').setReadOnly(true);
//		}
		this._dataLoad();
	},
	onQueryButtonDown : function() {
		this._dataLoad();
	},
	onSubmitButtonDown : function() {
		var me = this, masterGrid = me.masterGrid, panelSearch = me.panelSearch;
		var selectRecords = masterGrid.getSelectedRecords();
		var rvRecs= new Array();
		Ext.each(selectRecords, function(record, i) {
			//20200106 추가
			record.set('applyCount', applyCount);
			rvRecs[i] = record.data;
		})
		var rv = {
			status : "OK",
			data:rvRecs
		};
		me.returnData(rv);
	},
	//20200106 추가
	onApplyButtonDown : function() {
		var me = this, masterGrid = me.masterGrid, panelSearch = me.panelSearch;
		var selectRecords = masterGrid.getSelectedRecords();
		var rvRecs= new Array();
		var delRecs = new Array();
		Ext.each(selectRecords, function(record, i) {
			record.set('applyCount', applyCount);
			rvRecs[i] = record.data;
			delRecs.push(record);
		})
		var rv = {
			status : "OK",
			data:rvRecs
		};
		me.returnData(rv, 'N');
		masterGrid.getStore().remove(delRecs);
		applyCount = applyCount + 1;
	},
	_dataLoad : function() {
		var me = this, masterGrid = me.masterGrid, panelSearch = me.panelSearch;
		if(panelSearch.isValid()) {
			var param= panelSearch.getValues();
			console.log( "_dataLoad: ", param );
			me.isLoading = true;
			masterGrid.getStore().load({
				params : param,
				callback:function() {
					me.isLoading = false;
				}
			});
		}
	}
});