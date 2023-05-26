<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.EquMoldCodePopup");
%>
/** Model 정의 
 */
Unilite.defineModel('${PKGNAME}.EquMoldCodePopupModel', {
	fields: [
		{name: 'COMP_CODE'			, text: '법인코드'		, type: 'string'},
		{name: 'DIV_CODE'			, text: '사업장'		, type: 'string'},
		{name: 'EQU_CODE_TYPE'		, text: '장비구분'		, type: 'string'},
		{name: 'EQU_CODE_TYPE_NAME'	, text: '장비구분'		, type: 'string'},
		{name: 'EQU_MOLD_CODE'		, text: '금형코드'		, type: 'string'},
		{name: 'EQU_MOLD_NAME'		, text: '금형명'		, type: 'string'},
		{name: 'EQU_SPEC'			, text: '금형규격'		, type: 'string'},
		{name: 'CUSTOM_CODE'		, text: '제작처코드'		, type: 'string'},
		{name: 'CUSTOM_NAME'		, text: '제작처'		, type: 'string'},
		{name: 'PRODT_DATE'			, text: '제작일'		, type: 'string'},
		{name: 'PRODT_O'			, text: '제작금액'		, type: 'uniPrice'},
		{name: 'CAVIT_BASE_Q'		, text: 'cavity 수'	, type: 'int'},
		{name: 'CYCLE_TIME'			, text: ''			, type: 'int'},
		//20201111 추가
		{name: 'EQU_TYPE'			, text: '금형종류'		, type: 'string', comboType:'AU', comboCode:'I802'}
	]
});

	
Ext.define('${PKGNAME}', {
	extend		: 'Unilite.com.BaseJSPopupApp',
	autoScroll	: true,
	constructor	: function(config){
		var me = this;
		if (config) {
			Ext.apply(me, config);
		}
		me.form = Unilite.createSearchForm('', {
			layout : {type : 'uniTable', columns : 2 },
			items : [{
				fieldLabel	: '<t:message code="system.label.common.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				tdAttrs		: {width: 340},		//20201111 추가: 모양이 사팔뜨기 같아서;;
				allowBlank	: false
			},{
				fieldLabel	: 'ITEM_CODE',
				name		: 'ITEM_CODE',
				xtype		: 'uniTextfield',
				hidden		: true
			},{	//20201111 추가
				fieldLabel	: '금형종류',
				name		: 'EQU_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'I802'
			},{
				fieldLabel	: '<t:message code="system.label.common.searchword" default="검색어"/>',
				name		: 'TXT_SEARCH',
				xtype		: 'uniTextfield',
				listeners	: {
					specialkey: function(field, e){
						if (e.getKey() == e.ENTER) {
							me.onQueryButtonDown();
						}
					}
				}
			}]
		});
		me.grid = Ext.create('Unilite.com.grid.UniGridPanel',{
			store : Unilite.createStoreSimple('${PKGNAME}.EquMoldCodePopupMasterStore',{
				model	: '${PKGNAME}.EquMoldCodePopupModel',
				autoLoad: false,
				proxy	: {
					type: 'direct',
					api: {
						read: 'popupService.equMoldCodePopup'
					}
				}
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
				{ dataIndex: 'EQU_CODE_TYPE'		, width: 100,hidden:true},
				{ dataIndex: 'EQU_CODE_TYPE_NAME'	, width: 80},
				{ dataIndex: 'EQU_MOLD_CODE'		, width: 100},
				{ dataIndex: 'EQU_MOLD_NAME'		, width: 120},
				{ dataIndex: 'EQU_SPEC'				, width: 120},
				{ dataIndex: 'EQU_TYPE'				, width: 100},		//20201111 추가
				{ dataIndex: 'CUSTOM_CODE'			, width: 100},
				{ dataIndex: 'CUSTOM_NAME'			, width: 120},
				{ dataIndex: 'PRODT_DATE'			, width: 80},
				{ dataIndex: 'PRODT_O'				, width: 100},
				{ dataIndex: 'CAVIT_BASE_Q'			, width: 100, hidden:true},
				{ dataIndex: 'CYCLE_TIME'			, width: 100, hidden:true}
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
		config.items = [me.form, me.grid];
		me.callParent(arguments);
	},	//constructor
	initComponent : function(){	
		var me  = this;
		me.grid.focus();
		this.callParent();
	},	
	fnInitBinding : function(param) {
		var frm= this.form;
		if(param) {
			if(param['DIV_CODE'] && param['DIV_CODE']!='')	frm.setValue('DIV_CODE',   param['DIV_CODE']);
			if(param['ITEM_CODE'] && param['ITEM_CODE']!='')	frm.setValue('ITEM_CODE',   param['ITEM_CODE']);
			if(param['EQU_MOLD_CODE'] && param['EQU_MOLD_CODE']!='')	frm.setValue('TXT_SEARCH', param['EQU_MOLD_CODE']);
			if(param['EQU_MOLD_NAME'] && param['EQU_MOLD_NAME']!='')	frm.setValue('TXT_SEARCH', param['EQU_MOLD_NAME']);
		}
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
		var me = this;
		var selectRecord = me.grid.getSelectedRecord();
		var rv ;
		if(selectRecord)	{
			rv = {
				status : "OK",
				data:[selectRecord.data]
			};
		}
		me.returnData(rv);
	},
	onQueryButtonDown : function()	{
		this._dataLoad();
	},
	_dataLoad : function() {
		var me = this;
		var param= this.form.getValues();
		console.log( param );
		if(param) {
			me.isLoading = true;
			this.grid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
		}
	}
});