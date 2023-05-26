<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.CoreCodePopup");
%>
/** Model 정의 
 */
Unilite.defineModel('${PKGNAME}.CoreCodePopupModel', {
	fields: [
		{name: 'COMP_CODE'		, text: '법인코드'		, type: 'string'},
		{name: 'DIV_CODE'		, text: '사업장'		, type: 'string'},
		{name: 'CORE_CODE'		, text: '코어번호'		, type: 'string'},
		{name: 'MODEL_CODE'		, text: '모델코드'		, type: 'string'},
		{name: 'CORE_NAME'		, text: '품명'		, type: 'string'},
		{name: 'CORE_SPEC'		, text: '규격'		, type: 'string'},
		{name: 'PRODT_TYPE'		, text: '부품타입'		, type: 'string', comboType:'AU', comboCode:'I808'},
		{name: 'PRODT_MTRL'		, text: '원료'		, type: 'string'},
		{name: 'CAVITY_Q'		, text: '캐비티'		, type: 'string'}
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
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				tdAttrs: {width: 340},		//20201111 추가: 모양이 사팔뜨기 같아서;;
				allowBlank: false
			},{
				fieldLabel: '부품타입',
				name: 'PRODT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'I808'
			},{
				fieldLabel: '모델',
				name: 'MODEL_CODE',
				xtype: 'uniTextfield'
			},{
				fieldLabel: '<t:message code="system.label.common.searchword" default="검색어"/>',
				name: 'TXT_SEARCH',
				xtype: 'uniTextfield',
				listeners: {
					specialkey: function(field, e){
						if (e.getKey() == e.ENTER) {
							me.onQueryButtonDown();
						}
					}
				}
			}]
		});
		me.grid = Ext.create('Unilite.com.grid.UniGridPanel',{
			store : Unilite.createStoreSimple('${PKGNAME}.CoreCodePopupMasterStore',{
				model	: '${PKGNAME}.CoreCodePopupModel',
				autoLoad: false,
				proxy	: {
					type: 'direct',
					api: {
						read: 'popupService.coreCodePopup'
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
				{ dataIndex: 'COMP_CODE'	, width: 100,hidden:true},
				{ dataIndex: 'DIV_CODE'		, width: 100,hidden:true},
				{ dataIndex: 'CORE_CODE'	, width: 100},
				{ dataIndex: 'MODEL_CODE'	, width: 100},
				{ dataIndex: 'CORE_NAME'	, width: 200},
				{ dataIndex: 'CORE_SPEC'	, width: 150},
				{ dataIndex: 'PRODT_TYPE'	, width: 100},
				{ dataIndex: 'PRODT_MTRL'	, width: 100},
				{ dataIndex: 'CAVITY_Q'		, width: 100}
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
			if(param['CORE_CODE'] && param['CORE_CODE']!='')	frm.setValue('TXT_SEARCH', param['CORE_CODE']);
			if(param['CORE_NAME'] && param['CORE_NAME']!='')	frm.setValue('TXT_SEARCH', param['CORE_NAME']);
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