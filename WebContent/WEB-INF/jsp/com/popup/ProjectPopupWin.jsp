<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
//	사용자 팝업 'Unilite.app.popup.ProjectPopup' 
request.setAttribute("PKGNAME","Unilite.app.popup.ProjectPopup");
%>
	/** Model 정의 
	 */
	Unilite.defineModel('${PKGNAME}.ProjectPopupModel', {
		fields: [
			{name: 'PJT_CODE'	, text:'<t:message code="system.label.common.projectno" default="프로젝트번호"/>'		, type:'string'	},
			{name: 'PJT_NAME'	, text:'<t:message code="system.label.common.projectname" default="프로젝트명"/>'	, type:'string'	},
			{name: 'PJT_TYPE'	, text:'<t:message code="system.label.common.class" default="분류"/>'				, type:'string'	},
			{name: 'PJT_AMT'	, text:'<t:message code="system.label.common.contractamount" default="계약금액"/>'	, type:'uniPrice'},
			{name: 'CUSTOM_CODE', text:'<t:message code="system.label.common.custom" default="거래처"/>'			, type:'string'	},
			{name: 'CUSTOM_NAME', text:'<t:message code="system.label.common.customname" default="거래처명"/>'		, type:'string'	},
			{name: 'FR_DATE'	, text:'<t:message code="system.label.common.startdate" default="시작일"/>'		, type:'string'},
			{name: 'TO_DATE'	, text:'<t:message code="system.label.common.enddate" default="종료일"/>'			, type:'string'}
		]
	});



Ext.define('${PKGNAME}', {
	extend: 'Unilite.com.BaseJSPopupApp',
	autoScroll : true,
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
				fieldLabel : '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',
				name : 'TXT_SEARCH',
				listeners:{
					specialkey: function(field, e){
						if (e.getKey() == e.ENTER) {
						   me.onQueryButtonDown();
						}
					}
				}
			},{
				fieldLabel: ' ',
				xtype: 'radiogroup',
				name: 'rdoRadio',
				//20191226 수정: 구분 필드 hidden: true -> 코드/명 동시에 like 검색으로 변경
				hidden: true,
				items:[
					{inputValue: '1'	, boxLabel: '<t:message code="system.label.common.projectno" default="프로젝트번호"/>', name: 'RDO', checked: true, width: 110},
					{inputValue: '2'		, boxLabel: '<t:message code="system.label.common.projectname" default="프로젝트명"/>',  name: 'RDO', width: 90} ]
			},{
				xtype:'uniTextfield',
				name: 'BPARAM0',
				hidden: true
			},{
				xtype:'uniTextfield',
				name: 'CUSTOM_CODE',
				hidden: true
			}]
		});
		me.grid = Ext.create('Unilite.com.grid.UniGridPanel',{
			store : Unilite.createStoreSimple('${PKGNAME}.ProjectPopupMasterStore',{
				model: '${PKGNAME}.ProjectPopupModel',
				autoLoad: false,
				proxy: {
					type: 'direct',
					api: {
						read: 'popupService.projectPopup'
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
			columns : [{
				dataIndex : 'PJT_CODE',
				width : 120
			}, {
				dataIndex : 'PJT_NAME',
				width : 150
			}, {
				dataIndex : 'PJT_TYPE',
				width : 120,
				hidden: true
			}, {
				dataIndex : 'PJT_AMT',
				width : 120
			}, {
				dataIndex : 'CUSTOM_CODE',
				width : 80
			}, {
				dataIndex : 'CUSTOM_NAME',
				width : 150
			}, {
				dataIndex : 'FR_DATE',
				width : 80
			}, {
				dataIndex : 'TO_DATE',
				width : 80
			}],
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
			frm.setValue('BPARAM0', param['BPARAM0']);
			frm.setValue('CUSTOM_CODE', param['CUSTOM_CODE']);
			frm.setValue('TXT_SEARCH', param['PJT_CODE']);
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