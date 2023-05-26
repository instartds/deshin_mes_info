<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 202109 jhj: 원산지 팝업 (양평농협 전용)
request.setAttribute("PKGNAME","Unilite.app.popup.wonsangiPopup");
%>

	 Unilite.defineModel('${PKGNAME}.WonsangiPopupModel', {
		fields: [
			{name: 'CUSTOM_CODE'			,text:'<t:message code="system.label.common.customcode" default="거래처코드"/>'		,type:'string'},
			{name: 'CUSTOM_NAME'			,text:'<t:message code="system.label.common.customname" default="거래처명"/>'		,type:'string'},
			{name: 'FARM_CODE'				,text:'농가코드'		,type:'string'},
			{name: 'FARM_NAME'				,text:'농가'			,type:'string'},
			{name: 'FARM_TYPE'				,text:'농가구분코드'	,type:'string'},
			{name: 'FARM_TYPE_NM'			,text:'농가구분'		,type:'string'},
			{name: 'CERT_NO'				,text:'인증번호'		,type:'string'},
			{name: 'CERT_TYPE'				,text:'인증구분코드'	,type:'string'},
			{name: 'CERT_TYPE_NM'			,text:'인증구분'		,type:'string'},
			{name: 'ITEM_NAME'				,text:'<t:message code="unilite.msg.sMS688" default="품명"/>'						,type:'string'},
			{name: 'WONSANGI'				,text:'원산지'		,type:'string'}
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
		items: [	{ fieldLabel: '거래처코드',	name:'CUSTOM_CODE'	, xtype: 'uniTextfield', hidden		: true},
					{ fieldLabel: '농가명',	name:'FARM_NAME'	, xtype: 'uniTextfield'},
					{ fieldLabel: '원산지',	name:'WONSANGI'		, xtype: 'uniTextfield'}
		]
	});
	me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
			store: Unilite.createStoreSimple('${PKGNAME}.WonsangiPopupStore',{
							model: '${PKGNAME}.WonsangiPopupModel',
							autoLoad: false,
							proxy: {
								type: 'direct',
								api: {
									 read: 'popupService.wonsangiPopup'
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
						expandLastColumn: true,
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
						{dataIndex: 'CUSTOM_CODE'	,width: 80		,hidden:true},
						{dataIndex: 'CUSTOM_NAME'	,width: 120},
						{dataIndex: 'FARM_CODE'		,width: 80		,hidden:true},
						{dataIndex: 'FARM_NAME'		,width: 80},
						{dataIndex: 'FARM_TYPE'		,width: 80		,hidden:true},
						{dataIndex: 'FARM_TYPE_NM'	,width: 80},
						{dataIndex: 'CERT_NO'		,width: 80},
						{dataIndex: 'CERT_TYPE'		,width: 80		,hidden:true},
						{dataIndex: 'CERT_TYPE_NM'	,width: 80},
						{dataIndex: 'ITEM_NAME'		,width: 100},
						{dataIndex: 'WONSANGI'		,width: 100}


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
//		var fieldTxt = frm.findField('TXT_SEARCH');
		debugger;
		me.panelSearch.setValues(param);
		me.panelSearch.onLoadSelectText('WONSANGI');
		
		if( Ext.isDefined(param)) {
//			if(Ext.isDefined(fieldTxt)) {
//				if(!Ext.isEmpty(param['WONSANGI'])){
//					fieldTxt.setValue(param['WONSANGI']);		//TXT_SEARCH에 param으로 넘어온 data set
//				}
				if(!Ext.isEmpty(param['CUSTOM_CODE'])){
					frm.findField('CUSTOM_CODE').setValue(param['CUSTOM_CODE']);
				}
				if(!Ext.isEmpty(param['FARM_NAME'])){
					frm.findField('FARM_NAME').setValue(param['FARM_NAME']);
				}
				if(!Ext.isEmpty(param['WONSANGI'])){
					frm.findField('WONSANGI').setValue(param['WONSANGI']);
				}
//			}
		}

//		if (!Ext.isEmpty(me.panelSearch.getValue('WONSANGI'))) {
			this._dataLoad();		//무조건 조회
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