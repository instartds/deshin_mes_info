<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 성분 팜업
request.setAttribute("PKGNAME","Unilite.app.popup.chemicalPopup");
%>
/** Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.chemicalPopupModel', {
	fields: [
		{name: 'COMP_CODE'			,text: '법인코드'		,type: 'string'},	//법인코드'
		{name: 'CHEMICAL_CODE'		,text: '성분코드'		,type: 'string'},	//성분코드'
		{name: 'CHEMICAL_NAME'		,text: '한글명'		,type: 'string'},	//성분명_한글'
		{name: 'CHEMICAL_NAME_EN'	,text: '영문명'		,type: 'string'},	//성분명_영문'
		{name: 'CHEMICAL_NAME_CH'	,text: '중문명'		,type: 'string'},	//성분명_중문'
		{name: 'CHEMICAL_NAME_JP'	,text: '일문명'		,type: 'string'},	//성분명_일문'
		{name: 'CAS_NO'				,text: 'CAS NO'		,type: 'string'},	//CAS NO'
		{name: 'FUNCTION_DESC'		,text: 'Function'	,type: 'string'},	//기능'
		{name: 'CONTROL_CH'			,text: '중국규제'		,type: 'string'},	//규제_중국'
		{name: 'CONTROL_JP'			,text: '일본규제'		,type: 'string'},	//규제_일본'
		{name: 'CONTROL_USA'		,text: '미국규제'		,type: 'string'},	//규제_미국'
		{name: 'CONTROL_ETC1'		,text: '기타1규제'		,type: 'string'},	//규제_기타1'
		{name: 'CONTROL_ETC2'		,text: '기타2규제'		,type: 'string'},	//규제_기타2'
		{name: 'CONTROL_ETC3'		,text: '기타3규제'		,type: 'string'},	//규제_기타3'
		{name: 'CONTROL_ETC4'		,text: '기타4규제'		,type: 'string'},	//규제_기타4'
		{name: 'CONTROL_ETC5'		,text: '기타5규제'		,type: 'string'},	//규제_기타5'
		{name: 'REMARK'				,text: '비고'			,type: 'string'}	//비고'
	]
});



Ext.define('${PKGNAME}', {
	extend: 'Unilite.com.BaseJSPopupApp',
	constructor : function(config) {
		var me = this;
		if (config) {
			Ext.apply(me, config);
		}
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
		/** 검색조건 (Search Panel)
		 * @type 
		 */
		me.panelSearch = Unilite.createSearchForm('',{
			layout : {type : 'uniTable', columns : 2, tableAttrs: {
				style: {
					width: '100%'
				}
			}},
			items: [
				{ fieldLabel: '중복제거',		name: 'CHEMICAL_CODES'},
				{ fieldLabel: '성분코드',		name: 'CHEMICAL_CODE'},
				{ fieldLabel: '<t:message code="system.label.common.searchword" default="검색어"/>',		name: 'TXT_SEARCH'		, xtype: 'uniTextfield' ,
					listeners:{
						specialkey: function(field, e){
							if (e.getKey() == e.ENTER) {
								me.onQueryButtonDown();
							}
						}
					}
				}
			]
		});  
	
		/** Master Grid 정의(Grid Panel)
		 * @type 
		 */
		var masterGridConfig = {
			store: Unilite.createStore('${PKGNAME}.chemicalPopupMasterStore',{
						model	: '${PKGNAME}.chemicalPopupModel',
						autoLoad: true,
						proxy	: {
							type: 'direct',
							api	: {
								read: 'popupService.chemicalPopup'
							}
						}
					}),
			uniOpt:{
				onLoadSelectFirst : false,
				state: {
					useState	: false,
					useStateList: false	
				}  ,
				pivot : {
					use : false
				}
			},		
			selModel: 'rowmodel',
			columns	:  [
				{dataIndex:'COMP_CODE'			,width:105 ,hidden: true},
				{dataIndex:'CHEMICAL_CODE'		,width:100},
				{dataIndex:'CHEMICAL_NAME_EN'	,width:200},
				{dataIndex:'CHEMICAL_NAME'		,width:200},
				{dataIndex:'CAS_NO'				,width:100},
				{dataIndex:'FUNCTION_DESC'		,width:100},
				{dataIndex:'CHEMICAL_NAME_CH'	,width:200},
				{dataIndex:'CHEMICAL_NAME_JP'	,width:200},
				{dataIndex:'CONTROL_CH'			,width:100},
				{dataIndex:'CONTROL_JP'			,width:100},
				{dataIndex:'CONTROL_USA'		,width:100},
				{dataIndex:'CONTROL_ETC1'		,width:100},
				{dataIndex:'CONTROL_ETC2'		,width:100},
	//			{dataIndex:'CONTROL_ETC3'		,width:100},
	//			{dataIndex:'CONTROL_ETC4'		,width:100},
	//			{dataIndex:'CONTROL_ETC5'		,width:100},
				{dataIndex:'REMARK'				,width:100}
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
		};
		if(Ext.isDefined(wParam)) {
			if(wParam['SELMODEL'] == 'MULTI') {
				masterGridConfig.selModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : false });
			}
		}
		me.masterGrid = Unilite.createGrid('', masterGridConfig);
		
		config.items = [me.panelSearch,	me.masterGrid];
		me.callParent(arguments);
	},
	initComponent : function(){
		var me  = this;
		me.masterGrid.focus();
		this.callParent();
	},	
	fnInitBinding : function(param) {
		var me = this;
		var frm= me.panelSearch;
		
		if(param['CHEMICAL_CODE'] && param['CHEMICAL_CODE']!='')	frm.setValue('TXT_SEARCH'		, param['CHEMICAL_CODE']);
		if(param['CHEMICAL_NAME'] && param['CHEMICAL_NAME']!='')	frm.setValue('TXT_SEARCH'		, param['CHEMICAL_NAME']);
		if(param['CHEMICAL_CODES'] && param['CHEMICAL_CODES']!='')	frm.setValue('CHEMICAL_CODES'	, param['CHEMICAL_CODES']);
		
		this._dataLoad();
	},
	onQueryButtonDown : function() {
		this._dataLoad();
	},
	onSubmitButtonDown : function() {
		var me = this;
		var selectRecords = me.masterGrid.getSelectedRecords();
		var rvRecs= new Array();
		Ext.each(selectRecords, function(record, i) {
			rvRecs[i] = record.data;
		})
	 	var rv = {	
			status : "OK",
			data:rvRecs
		};
		me.returnData(rv);
	},
	_dataLoad : function() {
		var me = this;
		if(me.panelSearch.isValid()) {
			var param= me.panelSearch.getValues();
			me.isLoading = true;
			me.masterGrid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
		}
	}
});

