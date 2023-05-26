<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
	//  사업장별 품목 'Unilite.app.popup.DivPumokPopup'
	request.setAttribute("PKGNAME","Unilite.app.popup.ASDivPumokPopup");
%>
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B020" />	// '품목계정
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B014"/>	// 조달구분
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B013"/>	// 단위
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B019"/>	// 국내외
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B039"/>	// 출고방법
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />				// 사업장
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B052"/>				// 검색항목 -->
	<t:ExtComboStore useScriptTag="false" items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />//대분류
	<t:ExtComboStore useScriptTag="false" items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />//중분류
	<t:ExtComboStore useScriptTag="false" items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />//소분류
	<t:ExtComboStore useScriptTag="false" items="${COMBO_WH_LIST}" storeId="whList" />		// 창고


	/**
	 *   Model 정의
	 */
	Unilite.defineModel('${PKGNAME}.divPumokPopupModel', {
		fields: [
			 {name: 'ITEM_CODE'			,text:'<t:message code="system.label.common.itemcode" default="품목코드"/>'						,type : 'string'}
			,{name: 'ITEM_NAME'			,text:'<t:message code="system.label.common.itemname" default="품목명"/>'						,type : 'string'}
			,{name: 'SPEC'				,text:'<t:message code="system.label.common.spec" default="규격"/>'							,type : 'string'}
			,{name: 'STOCK_UNIT'		,text:'<t:message code="system.label.common.inventoryunit" default="재고단위"/>'				,type : 'string'}
			,{name: 'BASIS_P'			,text:'<t:message code="system.label.common.inventoryprice" default="재고단가"/>'				,type : 'uniUnitPrice'}
			,{name: 'SALE_BASIS_P'		,text:'<t:message code="system.label.common.sellingprice" default="판매단가"/>'					,type : 'uniUnitPrice'}
			,{name: 'WH_CODE'			,text:'<t:message code="system.label.common.basiswarehouse" default="기준창고"/>'				,type : 'string', store:Ext.data.StoreManager.lookup('whList')}
			,{name: 'WORK_SHOP_CODE'	,text:'<t:message code="system.label.common.mainworkcenter" default="주작업장"/>'				,type : 'string'}
			,{name: 'DIV_CODE'			,text:'<t:message code="system.label.common.standarddivision" default="기준사업장"/>'			,type : 'string'}
			,{name: 'ITEM_ACCOUNT'		,text:'<t:message code="system.label.common.itemaccount" default="품목계정"/>'					,type : 'string',comboType:'AU', comboCode:'B020'}
			,{name: 'STOCK_UNIT'		,text:'<t:message code="system.label.common.inventoryunit" default="재고단위"/>'				,type : 'string'}
			,{name: 'STOCK_CARE_YN'		,text:'<t:message code="system.label.common.inventorymanagementyn" default="재고관리여부"/>'		,type : 'string'}
			,{name: 'ITEM_GROUP'		,text:'<t:message code="system.label.common.repmodel" default="대표모델"/>'						,type : 'string'}
			,{name: 'ITEM_GROUP_NAME'   ,text:'<t:message code="system.label.common.repmodelname" default="대표모델명"/>'				,type : 'string'}
			,{name: 'ITEM_LEVEL1'		,text:'<t:message code="system.label.common.majorgroup" default="대분류"/>'					,type : 'string'}
			,{name: 'ITEM_LEVEL_NAME1'  ,text:'<t:message code="system.label.common.majorgroupname" default="대분류명"/>'				,type : 'string'}
			,{name: 'ITEM_LEVEL2'		,text:'<t:message code="system.label.common.middlegroup" default="중분류"/>'					,type : 'string'}
			,{name: 'ITEM_LEVEL_NAME2'  ,text:'<t:message code="system.label.common.middlegroupname" default="중분류명"/>'				,type : 'string'}
			,{name: 'ITEM_LEVEL3'		,text:'<t:message code="system.label.common.minorgroup" default="소분류"/>'					,type : 'string'}
			,{name: 'ITEM_LEVEL_NAME3'  ,text:'<t:message code="system.label.common.minorgroupname" default="소분류명"/>'				,type : 'string'}
			,{name: 'LOT_YN'			,text:'<t:message code="system.label.common.lotmanageyn" default="LOT관리여부"/>'				,type : 'string'}
			,{name: 'PURCHASE_P'		,text:'<t:message code="system.label.common.price" default="단가"/>'							,type : 'uniPrice'}
			,{name: 'STOCK_Q'			,text:'재고수량'				,type: 'uniQty'}
			,{name: 'TYPE'				,text:'구분'				    ,type : 'string'}      //20210323추가:   구분 ('1':매입, 구매(자재)에서 등록. '2':매출, 영업에서 등록)
			,{name: 'PABSTOCK_YN'       ,text:'가용재고적용여부'			,type : 'string'}  //BSA225T
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

		if(Ext.isDefined(wParam)) {
			var isReadOnly = false;
			if(wParam['SUPPLY_TYPE_READONLY'] == 'supplyReadOnly') {
				isReadOnly = true;
			}
		}

		me.panelSearch = Unilite.createSearchForm('',{
			layout : {type : 'uniTable', columns : 3, tableAttrs: {
				style: {
					width: '100%'
				}
			}},
			items: [	{ fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>' ,		name:'DIV_CODE'  , xtype: 'uniCombobox' , comboType:'BOR120', readOnly: true }
					   ,{ fieldLabel: '<t:message code="system.label.common.repmodel" default="대표모델"/>' ,		name:'ITEM_GROUP' ,colspan:2 }
					   ,{ fieldLabel: '<t:message code="system.label.common.itemaccount" default="품목계정"/>' ,	name:'ITEM_ACCOUNT'  , xtype: 'uniCombobox' , comboType:'AU', multiSelect: multiSelectItemAccount ,comboCode:'B020'/*, allowBlank: false*/, /*multiSelect : true, typeAhead: false,*/
							listeners:{
								beforequery: function(queryPlan, eOpts )	{
									var fValue = me.panelSearch.getValue('ITEM_ACCOUNT_FILTER');
									var store = queryPlan.combo.getStore();
									if(!Ext.isEmpty(fValue) )	{
										store.clearFilter(true);
										queryPlan.combo.queryFilter = null;
										console.log("fValue :",fValue);

										//20190227 - 품목계정 콤보 값 설정을 위한 REF_CODE3값 확인
										var records = store.data.items;
										var count = 0;
										Ext.each(records, function(record, i)	{
											if(!Ext.isEmpty(record.get('refCode3'))) {
												count++;
											}
										});
										if(count > 0) {
											store.filterBy(function(record, id){
												return fValue.indexOf(record.get('refCode3')) > -1 ? record:null;
//												return Ext.isEmpty(record.get('refCode3')) ? null:record;
											});

										} else {
											store.filterBy(function(record, id){
												console.log("record :",record.get('value'),fValue.indexOf(record.get('value')));
												return fValue.indexOf(record.get('value')) > -1 ? record:null;
											});
										}
									} else {
										store.clearFilter(true);
										queryPlan.combo.queryFilter = null;
										store.loadRawData(store.proxy.data);
									}
								}
							}
						}
					   ,{ fieldLabel: '<t:message code="system.label.common.majorgroup" default="대분류"/>',					name: 'ITEM_LEVEL1' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve1Store') , child: 'ITEM_LEVEL2',colspan:2}
					   ,{ fieldLabel: '<t:message code="system.label.common.procurementclassification" default="조달구분"/>',	name:'SUPPLY_TYPE'  , xtype: 'uniCombobox' , comboType:'AU' ,comboCode:'B014', readOnly: isReadOnly }
					   ,{ fieldLabel: '<t:message code="system.label.common.middlegroup" default="중분류"/>',					name: 'ITEM_LEVEL2' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve2Store') , child: 'ITEM_LEVEL3',colspan:2}
					   ,{ fieldLabel: '<t:message code="system.label.common.searchitem" default="검색항목"/>' ,					name:'FIND_TYPE'	, xtype: 'uniCombobox' , comboType:'AU' ,comboCode:'B052' , value:'01'  }
					   ,{ fieldLabel: '<t:message code="system.label.common.minorgroup" default="소분류"/>',					name: 'ITEM_LEVEL3' , xtype: 'uniCombobox' ,  store: Ext.data.StoreManager.lookup('itemLeve3Store'), parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'], levelType:'ITEM'  ,colspan:2}
					   ,{ fieldLabel: '<t:message code="system.label.common.searchword" default="검색어"/>',					name: 'TXT_SEARCH'  }
//					   ,{ fieldLabel: '<t:message code="system.label.common.itemcode" default="품목코드"/>' ,					name:'ITEM_SEARCH' /*, allowBlank:false*/}
					   ,{ fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',			name:'TXT_SEARCH2', xtype: 'uniTextfield', colspan: 2, focusable:true,
					   listeners:{
							specialkey: function(field, e){
								if (e.getKey() == e.ENTER) {
								   me.onQueryButtonDown();
								}
							}
						}
					   }
					   ,{ fieldLabel: '<t:message code="system.label.common.oemitemcode" default="품번(OEM)"/>' ,				name:'OEM_ITEM_CODE', hidden:true }  //20200306 극동사용안하기로 함
					   ,{ fieldLabel: '<t:message code="system.label.common.domesticimport" default="내수/수입"/>',				name:'DOM_FORIGN', xtype: 'uniTextfield', hidden: true }
					   //프로세스에 필요한 필드 (hidden)
					   ,{ fieldLabel: '검색제외구분',		name:'ITEM_EXCLUDE', hidden:true} // (DIV_CODE:BPR500T 해당 사업장에 이미등록된코드 제외, PROD_ITEM_CODE: BPR500T 해당 사업장에 검색하는 등록된 코드 제외)
					   ,{ fieldLabel: '검색제외',		name:'PROD_ITEM_CODE', hidden:true}
					   ,{ fieldLabel: '검색제외',		name:'CHILD_ITEM_CODE', hidden:true}
					   ,{ fieldLabel: '검색제외',		name:'ITEM_ACCOUNT_FILTER', hidden:true}
//					   ,{ fieldLabel: '사용유무',		name:'USE_YN', hidden:true}
					   ,{
							fieldLabel	: '<t:message code="system.label.common.useyn" default="사용여부"/>',
							//id			: 'rdoSelect0',
							xtype		: 'uniRadiogroup',
//							allowBlank	: false,
							items		: [{
								boxLabel: '<t:message code="system.label.common.use" default="사용"/>',
								width	: 70,
								name	: 'USE_YN',
								inputValue: 'Y',
								checked: true
							}, {
								boxLabel: '<t:message code="system.label.common.whole" default="전체"/>',
								width	: 90,
								name	: 'USE_YN',
								inputValue: 'A'
							}]
					   }
					   ,{ fieldLabel: '거래처코드', name:'CUSTOM_CODE', hidden:true}
			]
		});


		/**
		 * Master Grid 정의(Grid Panel)
		 * @type
		 */

		 var masterGridConfig = {
			store : Unilite.createStoreSimple('${PKGNAME}.divPumokPopupMasterStore',{
							model: '${PKGNAME}.divPumokPopupModel',
							autoLoad: false,
							proxy: {
								type: 'direct',
								api: {
									read: 'popupService.asDivPumokPopup'
								}
							},listeners	: {
								load: function(store, records, successful, eOpts) {
									//me.masterGrid.focus();
//									if(me.masterGrid.getStore().count() > 0){
//										me.masterGrid.getView().focusRow(0);
//									}
									if(store.getCount() > 0){
										var navi = me.masterGrid.getView().getNavigationModel();
										navi.setPosition(0,1);
									}
								}
							}
					}),
			uniOpt:{
				useRowNumberer: false,
				onLoadSelectFirst : false,
				useLoadFocus:false,
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
						 { dataIndex: 'ITEM_CODE',			width: 120}
						,{ dataIndex: 'ITEM_NAME',			width: 240}
						,{ dataIndex: 'SPEC',				width: 160}
						,{ dataIndex: 'STOCK_UNIT',			width: 80}
						,{ dataIndex: 'BASIS_P',			width: 90   }
						,{ dataIndex: 'SALE_BASIS_P',		width: 90   }
						,{ dataIndex: 'WH_CODE',			width: 100  ,hidden:true}
						,{ dataIndex: 'WORK_SHOP_CODE',		width: 100  ,hidden:true}
						,{ dataIndex: 'DIV_CODE',			width: 100  ,hidden:true}
						,{ dataIndex: 'ITEM_ACCOUNT',		width: 100  ,hidden:true}
						,{ dataIndex: 'STOCK_UNIT',			width: 100  ,hidden:true}
						,{ dataIndex: 'STOCK_CARE_YN',		width: 100  ,hidden:true}
						,{ dataIndex: 'ITEM_GROUP',			width: 100  ,hidden:true}
						,{ dataIndex: 'ITEM_GROUP_NAME',	width: 100  ,hidden:true}
						,{ dataIndex: 'ITEM_LEVEL1',		width: 100  ,hidden:true}
						,{ dataIndex: 'ITEM_LEVEL_NAME1',	width: 100  ,hidden:true}
						,{ dataIndex: 'ITEM_LEVEL2',		width: 100  ,hidden:true}
						,{ dataIndex: 'ITEM_LEVEL_NAME2',	width: 100  ,hidden:true}
						,{ dataIndex: 'ITEM_LEVEL3',		width: 100  ,hidden:true}
						,{ dataIndex: 'ITEM_LEVEL_NAME3',	width: 100  ,hidden:true}
						,{ dataIndex: 'LOT_YN',				width: 100  ,hidden:true}
						,{ dataIndex: 'STOCK_Q',			width: 100  }
						,{ dataIndex: 'PURCHASE_P',			width: 100  }
						,{ dataIndex: 'TYPE',				width: 100  }
						,{ dataIndex: 'PABSTOCK_YN',		width: 100  }
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
		var rdo = frm.findField('rdoRadio');
		var fieldTxt = frm.findField('TXT_SEARCH2');


		if(Ext.data.StoreManager.lookup('CBS_AU_B052').data.length != 0) {
			var qryType = Ext.data.StoreManager.lookup('CBS_AU_B052').getAt(0).get('value');
			me.panelSearch.setValue('FIND_TYPE', qryType);
		}


		if( Ext.isDefined(param)) {
			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
				var me = this;
				var frm= me.panelSearch.getForm();
				var fieldTxt = frm.findField('TXT_SEARCH2');
				var frm= me.panelSearch.getForm();
				var fieldTxt = frm.findField('TXT_SEARCH2');
				me.panelSearch.setValues(param);
				if(param['TYPE'] == 'VALUE') {
					if(!Ext.isEmpty(param['ITEM_CODE'])){
						fieldTxt.setValue(param['ITEM_CODE']);
					}
				}else{
					if(!Ext.isEmpty(param['ITEM_CODE'])){
						fieldTxt.setValue(param['ITEM_CODE']);
					}
					if(!Ext.isEmpty(param['ITEM_NAME'])){
						fieldTxt.setValue(param['ITEM_NAME']);
					}
				}
				if(param['DIV_CODE'])	{
					frm.findField('DIV_CODE').setValue(param['DIV_CODE']);
				}
				if(param['ITEM_ACCOUNT'])	{
					frm.findField('ITEM_ACCOUNT').setValue(param['ITEM_ACCOUNT']);
				}
				if(param['ITEM_EXCLUDE'])	{
					frm.findField('ITEM_EXCLUDE').setValue(param['ITEM_EXCLUDE']);
				}
				if(param['PROD_ITEM_CODE'])	{
					frm.findField('PROD_ITEM_CODE').setValue(param['PROD_ITEM_CODE']);
				}
				if(param['CHILD_ITEM_CODE'])	{
					frm.findField('CHILD_ITEM_CODE').setValue(param['CHILD_ITEM_CODE']);
				}
				if(param['DEFAULT_ITEM_ACCOUNT'])	{
					frm.findField('ITEM_ACCOUNT').setValue(param['DEFAULT_ITEM_ACCOUNT']);
				}
				if(param['ITEM_CODE'] || param['ITEM_NAME'])	{
					this._dataLoad();
				}
			}
			frm.setValues(param);

			var sType = param['sType'];
			if(sType == "T")	{
				masterGrid.getColumn("HS_NO").show();
				masterGrid.getColumn("HS_NAME").show();
				masterGrid.getColumn("HS_UNIT").show();
			}
		}
		me.panelSearch.onLoadSelectText('TXT_SEARCH2');
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


