<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
	//  사업장별 품목 'Unilite.app.popup.DivPumokPopup'
	request.setAttribute("PKGNAME","Unilite.app.popup.ASAssetPopup");
%>
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="S178" />	// 자산정보
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="S179"/>	// 구분
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="S177"/>	// 현재상태


	/**
	 *   Model 정의
	 */
	Unilite.defineModel('${PKGNAME}.divPumokPopupModel', {
		fields: [
			  {name : 'DIV_CODE'        , text : '사업장코드'     	, type : 'string'  }
			, {name : 'ASST_CODE'       , text : '자산코드'     	, type : 'string'  }
			, {name : 'ASST_NAME'       , text : '자산명'      	, type : 'string'  }
			, {name : 'SERIAL_NO'       , text : 'S/N'          , type : 'string'  }
			, {name : 'ASST_INFO'       , text : '자산정보'  		, type : 'string'   , comboType: "AU"	,comboCode:"S178" }
			, {name : 'ASST_GUBUN'      , text : '구분'  			, type : 'string'  	, comboType: "AU"	,comboCode:"S179" }
			, {name : 'NOW_LOC'         , text : '현위치'       	, type : 'string'  }
			, {name : 'ASST_STATUS'     , text : '현재상태'  		, type : 'string'  	, comboType: "AU"	,comboCode:"S177" }
			, {name : 'INOUT_DATE'   	, text : '창고입고일'    	, type : 'uniDate' }
			, {name : 'RETURN_DATE'   	, text : '반납예정일'    	, type : 'uniDate' }
			, {name : 'RESERVE_DATE'   	, text : '예약일자'    	, type : 'uniDate' }
			, {name : 'RESERVE_STATUS'  , text : '예약여부'        , type : 'string'  }
			, {name : 'RESERVE_YN'      , text : '예약여부'        , type : 'string'  }
			, {name : 'RESERVE_NO'      , text : '예약번호'        , type : 'string'  }
			, {name : 'RESERVE_SEQ'     , text : '예약순번'        , type : 'string'  }
			, {name : 'RESERVE_USER_ID' , text : '예약담당자'       , type : 'string'  }
			, {name : 'RESERVE_USER_NAME',text : '예약담당자'       , type : 'string'  }
			
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

		me.panelSearch = Unilite.createSearchForm('',{
			layout : {type : 'uniTable', columns : 3, tableAttrs: {
				style: {
					width: '100%'
				}
			}},
			items: [	{ fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>' ,	name: 'DIV_CODE'  , xtype: 'uniCombobox' , comboType:'BOR120' }
					   ,{ fieldLabel: '<t:message code="system.label.common.searchword" default="검색어"/>',	name: 'TXT_SEARCH'  },
					   ,{ fieldLabel: '상태',	name: 'ASST_STATUS'  , hidden : true}
//					
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
									read: 'popupService.selectASAssetPopup'
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
				expandLastColumn : false,
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
						  {dataIndex : 'ASST_CODE'      , width : 80 }
						, {dataIndex : 'ASST_NAME'      , width : 150 }
						, {dataIndex : 'SERIAL_NO'      , width : 150 }
						, {dataIndex : 'ASST_INFO'      , width : 70 }
						, {dataIndex : 'ASST_GUBUN'     , width : 100 }
						, {dataIndex : 'NOW_LOC'        , width : 150 ,hidden : true}
						, {dataIndex : 'ASST_STATUS'    , width : 70 }
						, {dataIndex : 'INOUT_DATE'   	, width : 80 }
						, {dataIndex : 'RETURN_DATE'   	, width : 80 }
						, {dataIndex : 'RESERVE_DATE'   , width : 80 }
						, {dataIndex : 'RESERVE_STATUS' , width : 80 , align :'center'}
						, {dataIndex : 'RESERVE_USER_NAME', width : 100 , align :'center'}
						
			] ,
			listeners: {
				beforeselect : function(grid, record, index, eOpts){
					return me.checkSelection(record);
				},
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
		var me = this,
			masterGrid = me.masterGrid,
			panelSearch = me.panelSearch;
		var frm= panelSearch.getForm();
		frm.setValues(param);
		me.panelSearch.onLoadSelectText('TXT_SEARCH');
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
	},
	checkSelection : function(record)	{
		var params = this.param;
		if(params.ASST_STATUS == "예약" || params.ASST_STATUS == "연장" || params.ASST_STATUS == "이동")	{
			if(record.get("RESERVE_YN") =="Y")	{
				Unilite.messageBox("예약된 자산은 선택하실 수 없습니다.");
				return false;
			}
		}
		return true;
	}
});


