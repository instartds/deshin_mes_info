<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
	request.setAttribute("PKGNAME","Unilite.app.popup.LotPopupMulti_in");
%>
	<t:ExtComboStore useScriptTag="false" items="${COMBO_WH_LIST}" storeId="whList" />			// 창고
	<t:ExtComboStore useScriptTag="false" items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	// 창고 CELL


	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('${PKGNAME}.LotPopupMulti_inModel', {
		fields: [
			{name: 'CUSTOM_CODE'		, text: 't:message code="system.label.common.customcode" default="거래처코드"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.common.customname" default="거래처명"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.common.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.common.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.common.spec" default="규격"/>'						, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.common.inventoryunit" default="재고단위"/>'			, type: 'string'},
			{name: 'WH_CODE'	 		, text: '<t:message code="system.label.common.warehouse" default="창고"/>'				, type: 'string', store: Ext.data.StoreManager.lookup('whList')},
			{name: 'WH_CELL_CODE'		, text: '<t:message code="system.label.common.warehouse" default="창고"/>cell'			, type: 'string'},
			{name: 'WH_CELL_NAME'		, text: '<t:message code="system.label.common.warehouse" default="창고"/>cell'			, type: 'string'},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.common.lotno" default="LOT번호"/>'					, type: 'string'},
			{name: 'LOTNO_CODE'			, text: '<t:message code="system.label.common.lotno" default="LOT번호"/>'					, type: 'string'},
			{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.common.receiptqty" default="입고수량"/>'				, type: 'uniQty'},
			{name: 'OUTSTOCK_Q'			, text: '<t:message code="system.label.common.issueqty" default="출고량"/>'				, type: 'uniQty'},
			{name: 'STOCK_Q'			, text: '<t:message code="system.label.common.onhandstock" default="현재고"/>'				, type: 'uniQty'},
			{name: 'ISSUE_REQ_QTY'		, text: '<t:message code="system.label.base.issueresevationqty" default="출고예정량"/>'		, type: 'uniQty'},
			{name: 'USEABLE_STOCK_QTY'	, text: '<t:message code="system.label.base.availableinventoryqty" default="가용재고량"/>'	, type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'		, text: '<t:message code="system.label.common.goodstock" default="양품재고"/>'				, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'		, text: '<t:message code="system.label.common.defectinventory" default="불량재고"/>'		, type: 'uniQty'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'	, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.common.remarks" default="비고"/>'					, type: 'string'},
			{name: 'MAKE_EXP_DATE'		, text: '<t:message code="system.label.common.expirationdate" default="유통기한"/>'			, type: 'uniDate'},
			{name: 'MAKE_DATE'			, text: '<t:message code="system.label.common.mfgdate" default="제조일"/>'					, type: 'uniDate'}
		]
	});


Ext.define('${PKGNAME}', {
	extend: 'Unilite.com.BaseJSPopupApp',
	constructor : function(config){
		var me = this;
		if (config) {
			Ext.apply(me, config);
		}
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

		/** 검색조건 (Search Panel)
		 * @type
		 */
		me.panelSearch = Unilite.createSearchForm('',{
			layout : {type : 'uniTable', columns : 3
					, tableAttrs: {style: {width: '100%'}
//					, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
			}},
			items: [{
					fieldLabel	: '<t:message code="system.label.common.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					child		: 'S_WH_CODE',
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
				}, {
					xtype	: 'container',
					layout	: {type:'uniTable', column:2},
					tdAttrs	: {width: 380},
					items	: [{
						fieldLabel	: '<t:message code="system.label.common.warehouse" default="창고"/>',
						name		: 'S_WH_CODE',
						xtype		: 'uniCombobox',
						store		: Ext.data.StoreManager.lookup('whList'),
						child		: 'S_WH_CELL_CODE'
					},{
						fieldLabel	: '',
						name		: 'S_WH_CELL_CODE',
						xtype		: 'uniCombobox',
						store		: Ext.data.StoreManager.lookup('whCellList'),
						width		: 120,
						labelWidth	: 0,
						hidden		: wParam.SHOW_CELL_YN,
						listeners	: {
							change: function(combo, newValue, oldValue, eOpts) {
							},
							render: function(combo, eOpts){
								combo.store.clearFilter();
								combo.store.filter('option',me.panelSearch.getValue('S_WH_CODE'));
							}
						}
					}]
				},
				Unilite.popup('CUST',{
					fieldLabel		: '<t:message code="system.label.common.custom" default="거래처"/>',
					valueFieldName	: 'S_CUSTOM_CODE',
					textFieldName	: 'S_CUSTOM_NAME',
					validateBlank	: false
				}),{
					xtype		: 'uniRadiogroup',
					fieldLabel	: '<t:message code="system.label.common.onhandstockyn" default="현재고 유무"/>',
					labelWidth	: 90,
					items		: [{
						boxLabel	: '<t:message code="system.label.common.yes" default="유"/>',
						width		: 60,
						name		: 'STOCK_YN',
						inputValue	: 'Y',
						checked		: true
					},{
						boxLabel	: '<t:message code="system.label.common.no" default="무"/>',
						width		: 60,
						name		: 'STOCK_YN',
						inputValue	: 'N'
					},{
						boxLabel	: '<t:message code="system.label.common.whole" default="전체"/>',
						width		: 60,
						name		: 'STOCK_YN' ,
						inputValue	: ''
					}]
				}
			]
		});




		/** Master Grid 정의(Grid Panel)
		 * @type
		 */
		var masterGridConfig = {
			store: Unilite.createStoreSimple('${PKGNAME}.lotPopupMulti_inMasterStore',{
				model	: '${PKGNAME}.LotPopupMulti_inModel',
				autoLoad: false,
				proxy	: {
					type: 'uniDirect',
					api	: {
						read: 'popupService.lotNoPopup_in'
					}
				}
			}),
			uniOpt:{
				onLoadSelectFirst	: false,
				useRowNumberer		: false,
				state: {
					useState	: false,
					useStateList: false
				},
				pivot : {
					use : false
				}
			},
			selModel:'rowmodel',
			columns: [
				{dataIndex : 'ITEM_CODE'		, width :100},
				{dataIndex : 'ITEM_NAME'		, width :133},
				{dataIndex : 'SPEC'				, width :100},
				{dataIndex : 'STOCK_UNIT'		, width :80},
				{dataIndex : 'WH_CODE'			, width :150},
				{dataIndex : 'WH_CELL_CODE'		, width :66, hidden: true},
				{dataIndex : 'WH_CELL_NAME'		, width :100},
				{dataIndex : 'LOT_NO'			, width :120},
				{dataIndex : 'INSTOCK_Q'		, width :100, hidden: true},
				{dataIndex : 'OUTSTOCK_Q'		, width :100, hidden: true},
				{dataIndex : 'STOCK_Q'			, width :100},
				{dataIndex : 'ISSUE_REQ_QTY'	, width :100},
				{dataIndex : 'USEABLE_STOCK_QTY', width :100},
				{dataIndex : 'GOOD_STOCK_Q'		, width :100},
				{dataIndex : 'BAD_STOCK_Q'		, width :100},
				{dataIndex : 'MAKE_EXP_DATE'	, width :100},
				{dataIndex : 'MAKE_DATE'		, width :100},
				{dataIndex : 'COMP_CODE'		, width :100, hidden: true},
				{dataIndex : 'REMARK'			, width :100, hidden: true},
				{dataIndex : 'CUSTOM_CODE'		, width :100, hidden: true},
				{dataIndex : 'CUSTOM_NAME'		, width :133}
			],
			listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {
					var rv = {
						status : "OK",
						data:[record.data]
					};
					me.returnData(rv);
				},
				onGridKeyDown: function(grid, keyCode, e) {
					if(e.getKey() == Ext.EventObject.ENTER) {
						var selectRecord = grid.getSelectedRecord();

						if(Ext.isEmpty(selectRecord))
							return;

						var rv = {
							status : "OK",
							data:[selectRecord.data]
						};
						me.returnData(rv);
					}
				}
			}
		}

		if(Ext.isDefined(wParam)) {
			if(wParam['SELMODEL'] == 'MULTI') {
				masterGridConfig.selModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : false });
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
		var me		= this;
		me.param	= param;
		var frm		= me.panelSearch.getForm();
		var fieldTxt= frm.findField('LOTNO_NAME');

		me.panelSearch.setValue('DIV_CODE'		, param.DIV_CODE);
		me.panelSearch.setValue('ITEM_CODE'		, param.ITEM_CODE);
		me.panelSearch.setValue('ITEM_NAME'		, param.ITEM_NAME);
		me.panelSearch.setValue('S_CUSTOM_CODE'	, param.S_CUSTOM_CODE);
		me.panelSearch.setValue('S_CUSTOM_NAME'	, param.S_CUSTOM_NAME);
		me.panelSearch.setValue('S_WH_CODE'		, param.S_WH_CODE);
		me.panelSearch.setValue('LOTNO_CODE'	, param.LOTNO_CODE);

		frm.findField('DIV_CODE').setReadOnly(true);
		//20200616 추가
		if(Ext.isEmpty(frm.findField('ITEM_CODE').getValue())){
			frm.findField('ITEM_CODE').setReadOnly(false);
			frm.findField('ITEM_NAME').setReadOnly(false);
		}else{
			frm.findField('ITEM_CODE').setReadOnly(true);
			frm.findField('ITEM_NAME').setReadOnly(true);
		}
		var combo1 = me.panelSearch.getField('S_WH_CELL_CODE');
		combo1.fireEvent('render', combo1);
		me.panelSearch.setValue('S_WH_CELL_CODE', param.S_WH_CELL_CODE);
		this._dataLoad();
	},
	onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
		var me = this, masterGrid = me.masterGrid, panelSearch = me.panelSearch;
		var selectRecords = masterGrid.getSelectedRecords();
		var rvRecs= new Array();
		Ext.each(selectRecords, function(record, i)	{
			rvRecs[i] = record.data;
		})
		var rv = {
			status	: "OK",
			data	: rvRecs
		};
		me.returnData(rv);
	},
	_dataLoad : function() {
		var me = this, masterGrid = me.masterGrid, panelSearch = me.panelSearch;
		if(panelSearch.isValid()) {
			var param= panelSearch.getValues();
			console.log( "_dataLoad: ", param );
			me.isLoading = true;
			masterGrid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
		}
	}
});