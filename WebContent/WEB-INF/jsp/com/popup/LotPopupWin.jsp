<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.LotPopup");
%>
<t:ExtComboStore useScriptTag="false" comboType="BOR120" />

/**
 *   Model 정의
 * @type
 */
Unilite.defineModel('${PKGNAME}.LotPopupModel', {
	fields: [
		{name: 'COMP_CODE'		, text: '<t:message code="system.label.common.companycode" default="법인코드"/>'		, type: 'string'},
		{name: 'DIV_CODE'		, text: '<t:message code="system.label.common.division" default="사업장"/>'			, type: 'string'},
		{name: 'INOUT_DATE'		, text: '<t:message code="system.label.common.transdate" default="수불일"/>'			, type: 'uniDate'},
		{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.common.customcode" default="거래처코드"/>'		, type: 'string'},
		{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.common.customname" default="거래처명"/>'			, type: 'string'},
		{name: 'LOT_NO'			, text: '<t:message code="system.label.common.lotno" default="LOT번호"/>'				, type: 'string'},
		{name: 'WH_CODE'		, text: '창고코드'		, type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('whList')},
		{name: 'WH_NAME'		, text: '<t:message code="system.label.common.warehouse" default="창고"/>'			, type: 'string'},
		{name: 'INSTOCK_Q'		, text: '<t:message code="system.label.common.receiptqty" default="입고수량"/>'			, type: 'uniQty'},
		{name: 'OUTSTOCK_Q'		, text: '<t:message code="system.label.common.issueqty" default="출고량"/>'			, type: 'uniQty'},
		{name: 'STOCK_Q'		, text: '<t:message code="system.label.common.onhandstock" default="현재고"/>'			, type: 'uniQty'},	//20200427 수정: STOCK_YN -> STOCK_Q
		{name: 'GOOD_STOCK_Q'	, text: '<t:message code="system.label.common.goodstock" default="양품재고"/>'			, type: 'uniQty'},
		{name: 'BAD_STOCK_Q'	, text: '<t:message code="system.label.common.defectinventory" default="불량재고"/>'	, type: 'uniQty'},
		{name: 'ITEM_CODE'		, text: '<t:message code="system.label.common.itemcode" default="품목코드"/>'			, type: 'string'},
		{name: 'ITEM_NAME'		, text: '<t:message code="system.label.common.itemname" default="품목명"/>	'			, type: 'string'},
		{name: 'SPEC'			, text: '<t:message code="system.label.common.spec" default="규격"/>'					, type: 'string'},
		{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.common.inventoryunit" default="재고단위"/>'		, type: 'string'},
		{name: 'REMARK'			, text: '<t:message code="system.label.common.remarks" default="비고"/>'				, type: 'string'}
	]
});

/**
 * 검색조건 (Search Panel)
 * @type
 */
Ext.define('${PKGNAME}', {
	extend: 'Unilite.com.BaseJSPopupApp',
	constructor : function(config) {
		var me = this;
		if (config) {
			Ext.apply(me, config);
		}
		/**
		 * 검색조건 (Search Panel)
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

		me.panelSearch =  Unilite.createSearchForm('',{
			layout : {type : 'table', columns : 3, tableAttrs: {
				style: {
					width: '100%'
				}
			}},
			items: [{
					fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					allowBlank:false
				},{
					fieldLabel: '<t:message code="system.label.common.transdate" default="수불일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_INOUT_DATE',
					endFieldName: 'TO_INOUT_DATE',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width:315,
					colspan:2

				},
				Unilite.popup('CUST',{
						fieldLabel: '<t:message code="system.label.common.custom" default="거래처"/>',
						valueFieldName: 'CUSTOM_CODE',
						textFieldName: 'CUSTOM_NAME',
						textFieldWidth:	170,
						validateBlank: false
			   }),{
					fieldLabel: 'LOT NO',
					name:'LOT_NO',
					xtype: 'uniTextfield',
					listeners:{
							specialkey: function(field, e){
								if (e.getKey() == e.ENTER) {
								   me.onQueryButtonDown();
								}
							}
						}
				},{
					fieldLabel: '<t:message code="system.label.common.remarks" default="비고"/>',
					name:'REMARK',
					xtype: 'uniTextfield'
				},
				Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.common.itemcode" default="품목코드"/>',
						valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						textFieldWidth:	170,
						validateBlank: false
			   }),{
					xtype: 'radiogroup',
					fieldLabel: '<t:message code="system.label.common.onhandstock" default="현재고"/>',
					labelWidth:90,
					items : [{
						boxLabel: '<t:message code="system.label.common.yes" default="유"/>',
						width:60,
						name:'STOCK_YN',
						inputValue: 'Y',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.common.no" default="무"/>',
						width:60,
						name:'STOCK_YN',
						inputValue: 'N'
					},{
						boxLabel: '<t:message code="system.label.common.whole" default="전체"/>',
						width:60,
						name:'STOCK_YN' ,
						inputValue: ' '
					}]
				}
			]
		});
/**
 * Master Grid 정의(Grid Panel)
 * @type
 */
		 me.masterGrid = Unilite.createGrid('', {
			store: Unilite.createStore('${PKGNAME}.lotPopupMasterStore',{
							model: '${PKGNAME}.LotPopupModel',
							autoLoad: false,
							proxy: {
								type: 'uniDirect',
								api: {
									read: 'popupService.lotPopup'
								}
							}
							/*,
							saveStore : function(config)	{
									var inValidRecs = this.getInvalidRecords();
									if(inValidRecs.length == 0 )	{
										//this.syncAll(config);
										this.syncAllDirect(config);
									}else {
										alert(Msg.sMB083);
									}
							}*/
					}),
			uniOpt:{
				state: {
					useState: false,
					useStateList: false
				},
				pivot : {
					use : false
				}
			},
			selModel:'rowmodel',
			columns:  [
					{dataIndex : 'COMP_CODE'		, width : 80, hidden: true},
					{dataIndex : 'DIV_CODE'			, width : 80, hidden: true},
					{dataIndex : 'INOUT_DATE'		, width : 80, hidden: true},
					{dataIndex : 'CUSTOM_CODE'		, width : 120},
					{dataIndex : 'CUSTOM_NAME'		, width : 140},
					{dataIndex : 'LOT_NO'			, width : 100},
					{dataIndex : 'WH_CODE'			, width : 100, hidden: true},
					{dataIndex : 'WH_NAME'			, width : 120},
					{dataIndex : 'INSTOCK_Q'		, width : 60},
					{dataIndex : 'OUTSTOCK_Q'		, width : 60},
					{dataIndex : 'STOCK_Q'			, width : 60},	//20200427 수정: STOCK_YN -> STOCK_Q
					{dataIndex : 'GOOD_STOCK_Q'		, width : 60},
					{dataIndex : 'BAD_STOCK_Q'		, width : 60},
					{dataIndex : 'ITEM_CODE'		, width : 120},
					{dataIndex : 'ITEM_NAME'		, width : 140},
					{dataIndex : 'SPEC'				, width : 120},
					{dataIndex : 'STOCK_UNIT'		, width : 80},
					{dataIndex : 'REMARK'			, width : 80}
				] ,
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
							var rv = {
								status : "OK",
								data:[selectRecord.data]
							};
							me.returnData(rv);
						}
					}
				}
			});
			config.items = [me.panelSearch, me.masterGrid];
			me.callParent(arguments);
		},
		initComponent : function(){
			var me  = this;
			me.masterGrid.focus();
			this.callParent();
		},
		fnInitBinding : function(param) {
			var me = this;
			me.param = param;
			var frm= me.panelSearch.getForm();
			//var fieldTxt = frm.findField('lot_NAME');
			me.panelSearch.setValue('DIV_CODE',param.DIV_CODE);
			me.panelSearch.setValue('ITEM_CODE', param.ITEM_CODE);
			me.panelSearch.setValue('ITEM_NAME', param.ITEM_NAME);
			//this._dataLoad();
		},
		 onQueryButtonDown : function()	{
			this._dataLoad();
		},
		onSubmitButtonDown : function()	{
			var me = this;
			var selectRecord = me.masterGrid.getSelectedRecord();
			var rv ;
			if(selectRecord)	{
				rv = {
					status : "OK",
					data:[selectRecord.data]
				};
			}
			me.returnData(rv);
		},
		_dataLoad : function() {
			var me = this;
			var param= me.panelSearch.getValues();
			console.log( "_dataLoad: ", param );
			me.isLoading = true;
			me.masterGrid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
		}
	});