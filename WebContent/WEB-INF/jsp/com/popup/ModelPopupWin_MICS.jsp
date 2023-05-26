<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 모델 팝업 (멕아이씨에스 전용)
request.setAttribute("PKGNAME","Unilite.app.popup.ModelPopup");
%>

	 Unilite.defineModel('${PKGNAME}.ModelPopupModel', {
		fields: [
			{name: 'CUSTOM_CODE'			,text:'<t:message code="system.label.common.customcode" default="거래처코드"/>'		,type:'string'},
			{name: 'CUSTOM_NAME'			,text:'<t:message code="system.label.common.customname" default="거래처명"/>'		,type:'string'},
			{name: 'MODEL_CODE'				,text:'모델고유식별코드'	,type:'string'},
			{name: 'MODEL_NAME'				,text:'모델명'		,type:'string'},
			{name: 'PRODUCT_CODE'			,text:'제품코드'		,type:'string'}
		]
	});



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
//	var wParam = this.param;
//	var t1= false, t2 = false;
//	if( Ext.isDefined(wParam)) {
//		if(wParam['TYPE'] == 'VALUE') {
//			t1 = true;
//			t2 = false;
//
//		} else {
//			t1 = false;
//			t2 = true;
//
//		}
//	}
	me.panelSearch = Unilite.createSearchForm('',{
		layout: {
			type: 'uniTable',
			columns: 2,
			tableAttrs: {
				style: {
					width: '100%'
				}
			}
		},
		items: [  { fieldLabel: '모델명',	name:'MODEL_NAME', xtype: 'uniTextfield'}
		]
	});
	me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
			store: Unilite.createStoreSimple('${PKGNAME}.modelPopupStore',{
							model: '${PKGNAME}.ModelPopupModel',
							autoLoad: false,
							proxy: {
								type: 'direct',
								api: {
									 read: 'popupService.modelPopup'
								}
							},
							saveStore : function(config)	{
									var inValidRecs = this.getInvalidRecords();
									if(inValidRecs.length == 0 )	{
										this.syncAll(config);
//									  this.syncAllDirect(config);
									}else {
										alert(Msg.sMB083);
									}
							}
					}),
			layout: 'fit',
			uniOpt:{
						expandLastColumn: false,
						useRowNumberer: true,
						state: {
							useState: false,
							useStateList: false
						},
						pivot : {
							use : false
						},
						useMultipleSorting: false,
						filter: {
							useFilter	: true,
							autoCreate	: true
						}
			},
			selModel:'rowmodel',
			columns:  [
						 { dataIndex: 'CUSTOM_CODE'		, width: 80		, hidden:true}
						,{ dataIndex: 'CUSTOM_NAME'		, width: 250	, hidden:true}
						,{ dataIndex: 'MODEL_CODE'		, width: 150 }
						,{ dataIndex: 'MODEL_NAME'		, width: 150 }
						,{ dataIndex: 'PRODUCT_CODE'	, width: 150 }

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
						var rv = {
							status : "OK",
							data:[selectRecord.data]
						};
						me.returnData(rv);
					}
				}
			}
		});

		config.items = [me.panelSearch, 	me.masterGrid];
	  	me.callParent(arguments);
	},
	initComponent : function(){
		var me  = this;

		me.masterGrid.focus();

		this.callParent();
	},
	fnInitBinding : function(param) {
		var me = this;

		var frm= me.panelSearch.getForm();
		me.panelSearch.onLoadSelectText('MODEL_NAME');
		var fieldTxt = frm.findField('MODEL_NAME');
		me.panelSearch.setValues(param);
		if( Ext.isDefined(param)) {
			if(Ext.isDefined(fieldTxt)) {

					if(!Ext.isEmpty(param['MODEL_CODE'])){
						fieldTxt.setValue(param['MODEL_CODE']);
					}
					if(!Ext.isEmpty(param['MODEL_NAME'])){
						fieldTxt.setValue(param['MODEL_NAME']);
					}
			}
		}

		//조회 조건이 있을 때만 팝업 열리면서 조회 되도록, 20210830 수정: 무조건 조회되도록 수정
//		if (!Ext.isEmpty(me.panelSearch.getValue('MODEL_NAME'))) {
			this._dataLoad();
//		}
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
	openRegWindow:function()   {
		var me = this;
		console.log("openRegWindow:me", me);
		me.regWindow.show();
//	  var selRecord = me.masterGrid.createRow();
//	  me.regCustForm.setActiveRecord(selRecord||null);

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