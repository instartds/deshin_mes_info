<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.IssueReqNumPopup");
%>

/** Model 정의 
 */
 Unilite.defineModel('${PKGNAME}.IssueReqNumPopupModel', {
	fields: [
		{name: 'ISSUE_REQ_NUM'	,text:'<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'	,type:'string'},
		{name: 'ISSUE_REQ_DATE'	,text:'<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'	,type:'uniDate'},
		{name: 'CUSTOM_CODE'	,text:'<t:message code="system.label.sales.client" default="고객"/>'					,type:'string'},
		{name: 'CUSTOM_NAME'	,text:'<t:message code="system.label.sales.client" default="고객"/>'					,type:'string'},
		{name: 'DVRY_DATE'		,text:'<t:message code="system.label.product.deliverydate" default="납기일"/>'		,type:'uniDate'}
	]
});

	
Ext.define('${PKGNAME}', {
	extend: 'Unilite.com.BaseJSPopupApp',
	constructor : function(config){
		var me = this;
		if (config) {
			Ext.apply(me, config);
		}
		me.form = Unilite.createSearchForm('', {
			layout : {
				type : 'uniTable',
				columns : 2
			},
			items : [{
				xtype		: 'uniTextfield',
				fieldLabel	: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>',
				name		: 'TXT_SEARCH',
				listeners	: {
					specialkey: function(field, e){
						if (e.getKey() == e.ENTER) {
						me.onQueryButtonDown();
						}
					}
				}
			},{
				fieldLabel	: ' ',
				xtype		: 'radiogroup',
				items		: [{
					inputValue	: '1',
					boxLabel	: '<t:message code="system.label.common.issuereqdateinorder" default="출하지시일순"/>',
					name		: 'RDO',
					checked		: true,
					width		: 100
				},{
					inputValue	: '2',
					boxLabel	: '<t:message code="system.label.common.clientinorder" default="고객순"/>',
					name		: 'RDO',
					width		: 70
				}]
			},{
				xtype	: 'uniTextfield',
				name	: 'ISSUE_REQ_NUM',
				hidden	: true
			},{
				xtype	: 'uniTextfield',
				name	: 'DIV_CODE',
				hidden	: true
			},{
				xtype	: 'uniTextfield',
				name	: 'CUSTOM_CODE',
				hidden	: true
			},{
				xtype	: 'uniTextfield',
				name	: 'DETAIL_YN',
				hidden	: true
			}]
		});
		me.grid = Ext.create('Unilite.com.grid.UniGridPanel',{
			store : Unilite.createStoreSimple('${PKGNAME}.IssueReqNumPopupMasterStore',{
				model	: '${PKGNAME}.IssueReqNumPopupModel',
				autoLoad: false,
				proxy	: {
					type: 'direct',
					api	: {
						read: 'popupService.issueReqNumPopup'
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
			columns : [
				{dataIndex : 'ISSUE_REQ_NUM'	, width : 140},
				{dataIndex : 'ISSUE_REQ_DATE'	, width : 80},
				{dataIndex : 'CUSTOM_CODE'		, width : 250},
				{dataIndex : 'CUSTOM_NAME'		, width : 250},
				{dataIndex : 'DVRY_DATE'		, width : 80}
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
		config.items = [me.form, me.grid];
		me.callParent(arguments);
	},  //constructor
	initComponent : function(){	
		var me  = this;
		me.grid.focus();
		this.callParent();
	},	
	fnInitBinding : function(param) {
		//var param = window.dialogArguments;
		var frm= this.form;
		if(param) {
			if(!Ext.isEmpty(param['DETAIL_YN']) && param['DETAIL_YN'] == 'Y') {
				this.grid.getColumn('CUSTOM_CODE').setHidden(true);
				this.grid.getColumn('DVRY_DATE').setHidden(false);
				frm.setValue('DETAIL_YN', param['DETAIL_YN']);
				
			} else {
				this.grid.getColumn('CUSTOM_CODE').setHidden(true);
				this.grid.getColumn('DVRY_DATE').setHidden(true);
			}
			frm.setValue('DIV_CODE'		, param['DIV_CODE']);
			frm.setValue('ISSUE_REQ_NUM', param['ISSUE_REQ_NUM']);
			frm.setValue('CUSTOM_CODE'	, param['CUSTOM_CODE']);
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