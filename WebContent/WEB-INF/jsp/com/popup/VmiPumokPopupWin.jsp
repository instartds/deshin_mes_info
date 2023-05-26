<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
	//  사업장별 품목 'Unilite.app.popup.VmiPumokPopup'
	request.setAttribute("PKGNAME","Unilite.app.popup.VmiPumokPopup");
%>
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B013"/>	// 단위
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />				// 사업장


	/**
	 *   Model 정의
	 */
	Unilite.defineModel('${PKGNAME}.vmiPumokPopupModel', {
		fields: [
			 {name: 'ITEM_CODE'			,text:'<t:message code="system.label.common.itemcode" default="품목코드"/>'						,type : 'string'}
			,{name: 'ITEM_NAME'			,text:'<t:message code="system.label.common.itemname" default="품목명"/>'						,type : 'string'}
			,{name: 'SPEC'				,text:'<t:message code="system.label.common.spec" default="규격"/>'							,type : 'string'}
			,{name: 'SALE_UNIT'			,text:'<t:message code="system.label.common.salesunit" default="판매단위"/>'					,type : 'string'}
		]
	});


Ext.define('${PKGNAME}', {
	extend: 'Unilite.com.BaseJSPopupApp',
	constructor : function(config){
		var me = this;
		if (config) {
			Ext.apply(me, config);
		}
		// -----------------------

		/**
		 * 검색조건 (Search Panel)
		 * @type
		 */
		var wParam = this.param;
		var multiSelectItemAccount = false; //품목계정 멀티선택 옵션 설정 -- 2018.11.20 수정
		if(wParam.multiSelectItemAccount == true){
			multiSelectItemAccount = true;
		}
//		var t1= false, t2 = false;
//		if( Ext.isDefined(wParam)) {
//			if(wParam['POPUP_TYPE'] == 'GRID_CODE') {
//				t1 = true;
//				t2 = false;
//			}else {
//				if(wParam['TYPE'] == 'VALUE') {
//					t1 = true;
//					t2 = false;
//
//				} else {
//					t1 = false;
//					t2 = true;
//
//				}
//			}
//		}
		if(Ext.isDefined(wParam)) {
			var isReadOnly = false;
			if(wParam['SUPPLY_TYPE_READONLY'] == 'supplyReadOnly') {
				isReadOnly = true;
			}
		}

		me.panelSearch = Unilite.createSearchForm('',{
			layout : {type : 'uniTable', columns : 1, tableAttrs: {
				style: {
					width: '100%'
				}
			}},
			items: [{
				fieldLabel	: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',
				name		: 'TXT_SEARCH2',
				xtype		: 'uniTextfield',
				colspan		: 4,
				focusable	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						me.panelSearch.setValue('ITEM_CODE', newValue);
						me.panelSearch.setValue('ITEM_NAME', newValue);
					},
					specialkey: function(field, e) {
						if (e.getKey() == e.ENTER) {
							me.onQueryButtonDown();
						}
					}
				}
			},{
				xtype	: 'uniTextfield',
				name	: 'ITEM_CODE',
				hidden	: true
			},{
				xtype	: 'uniTextfield',
				name	: 'ITEM_NAME',
				hidden	: true
			},{
				xtype	: 'uniTextfield',
				name	: 'DIV_CODE',
				hidden	: true
			}]
		});


		/**Master Grid 정의(Grid Panel)
		 * @type
		 */
		var masterGridConfig = {
			store	: Unilite.createStoreSimple('${PKGNAME}.vmiPumokPopupMasterStore',{
				model: '${PKGNAME}.vmiPumokPopupModel',
				autoLoad: false,
				proxy: {
					type: 'direct',
					api: {
						read: 'popupService.vmiPumokPopup'
					}
				},
				listeners	: {
					load: function(store, records, successful, eOpts) {
						//me.masterGrid.focus();
//						if(me.masterGrid.getStore().count() > 0){
//							me.masterGrid.getView().focusRow(0);
//						}
						if(store.getCount() > 0){
							var navi = me.masterGrid.getView().getNavigationModel();
							navi.setPosition(0,1);
						}
					}
				}
			}),
			uniOpt:{
				useRowNumberer		: false,
				onLoadSelectFirst	: false,
				useLoadFocus		: false,
				state				: {
					useState	: false,
					useStateList: false
				},
				pivot : {
					use : false
				}
			},
			selModel: 'rowmodel',
			columns	: [
				 { dataIndex: 'ITEM_CODE',			width: 120}
				,{ dataIndex: 'ITEM_NAME',			width: 240}
				,{ dataIndex: 'SPEC',				width: 160}
				,{ dataIndex: 'SALE_UNIT',			width: 100, align: 'center'}
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
						if(!Ext.isEmpty(selectRecord)) {
							var rv = {
								status : "OK",
								data:[selectRecord.data]
							};
							me.returnData(rv);
						}
					}
				}
			}
		};

		if(Ext.isDefined(wParam)) {
			if(wParam['SELMODEL'] == 'MULTI') {
				masterGridConfig.selModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : false });
			}
		}

		me.masterGrid = Unilite.createGrid('', masterGridConfig);


		// -----------------------
		config.items = [me.panelSearch, me.masterGrid];
		me.callParent(arguments);
	}, //constructor
	initComponent : function(){
		var me  = this;

		me.masterGrid.focus();

		this.callParent();
	},
	fnInitBinding : function(param) {
		//var param = window.dialogArguments;
		//공통코드(B052)에서 첫번째 값 가져오기
		var me = this,
			masterGrid = me.masterGrid,
			panelSearch = me.panelSearch;
		var frm= panelSearch.getForm();
		var fieldTxt = frm.findField('TXT_SEARCH2');

		if( Ext.isDefined(param)) {
			if (param['ITEM_CODE'] != '') {
				panelSearch.setValue('ITEM_CODE'	, param['ITEM_CODE']);
				panelSearch.setValue('TXT_SEARCH2'	, param['ITEM_CODE']);
			} else {
				panelSearch.setValue('ITEM_NAME'	, param['ITEM_NAME']);
				panelSearch.setValue('TXT_SEARCH2'	, param['ITEM_NAME']);
			}
			if (param['DIV_CODE'] != '') {
				panelSearch.setValue('DIV_CODE'	 	, param['DIV_CODE']);
			}
		}
		me.panelSearch.onLoadSelectText('TXT_SEARCH2');
		this._dataLoad();
	},
	onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
		var me = this,
			masterGrid = me.masterGrid,
			panelSearch = me.panelSearch;
		var selectRecords = masterGrid.getSelectedRecords();
		var rvRecs= new Array();
		Ext.each(selectRecords, function(record, i)	{
			rvRecs[i] = record.data;
		})
		var rv = {
			status : "OK",
			data:rvRecs
		};

		me.returnData(rv);
	},
	_dataLoad : function() {
		var me = this,
			masterGrid = me.masterGrid,
			panelSearch = me.panelSearch;
		if(panelSearch.isValid())	{
			var param= panelSearch.getValues();
			console.log( param );
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