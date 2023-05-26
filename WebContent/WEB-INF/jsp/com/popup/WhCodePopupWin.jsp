<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 작업장 팜업
request.setAttribute("PKGNAME","Unilite.app.popup.WhCodePopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />				// 사업장 



/** Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.WhCodePopupModel', {
	fields: [{name: 'COMP_CODE'			,text:'<t:message code="system.label.common.companycode" default="법인코드"/>'					,type:'string'	}
			,{name: 'TYPE_LEVEL'		,text:'<t:message code="system.label.common.division" default="사업장"/>'						,type:'string', xtype: 'uniCombobox', comboType: 'BOR120'	}
			,{name: 'TREE_CODE'			,text:'<t:message code="system.label.common.warehousecode" default="창고코드"/>'				,type:'string'	}
			,{name: 'TREE_NAME'			,text:'<t:message code="system.label.common.warehouse" default="창고"/>'					,type:'string'	}
		]
	});



/** 검색조건 (Search Panel)
 * @type 
 */
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
	me.panelSearch = Unilite.createSearchForm('',{
		layout : {type : 'uniTable', columns : 2, tableAttrs: {
			style: {
				width: '100%'
			}
		}},
		items: [
			{ fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',			name: 'TYPE_LEVEL'		, xtype: 'uniCombobox', comboType:'BOR120', readOnly: true },
			{ fieldLabel: '<t:message code="system.label.common.searchword" default="검색어"/>',		name: 'TXT_SEARCH'		, xtype: 'uniTextfield' ,
				listeners:{
					specialkey: function(field, e){
						if (e.getKey() == e.ENTER) {
							me.onQueryButtonDown();
						}
					}
				}
			},
			{ fieldLabel: '<t:message code="system.label.common.warehousecode" default="창고코드"/>',	name: 'TREE_CODE' 		, xtype: 'uniTextfield', hidden: true },
			{ fieldLabel: '<t:message code="system.label.common.warehouse" default="창고"/>',			name: 'TREE_NAME' 		, xtype: 'uniTextfield', hidden: true }
		]
	});  

/** Master Grid 정의(Grid Panel)
 * @type 
 */
	var masterGridConfig = {
		store: Unilite.createStore('${PKGNAME}.whCodePopupMasterStore',{
						model: '${PKGNAME}.WhCodePopupModel',
						autoLoad: true,
						proxy: {
							type: 'direct',
							api: {
								read: 'popupService.whCodePopup'
							}
						}
				}),
		
		uniOpt:{
//			useRowNumberer: false,
			onLoadSelectFirst : false,
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
			{ dataIndex: 'COMP_CODE'		,width: 120, hidden: true },
			{ dataIndex: 'TYPE_LEVEL'		,width: 120, hidden: true },
			{ dataIndex: 'TREE_CODE'		,width: 120 },
			{ dataIndex: 'TREE_NAME'		,width: 400 }
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
		
		if(param['TREE_CODE'] && param['TREE_CODE']!='')	frm.setValue('TXT_SEARCH', param['TREE_CODE']);
		if(param['TREE_NAME'] && param['TREE_NAME']!='')	frm.setValue('TXT_SEARCH', param['TREE_NAME']);
		if(param['TYPE_LEVEL'] && param['TYPE_LEVEL']!='')	frm.setValue('TYPE_LEVEL',  param['TYPE_LEVEL']);
		
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
		var me = this;
		var selectRecords = me.masterGrid.getSelectedRecords();
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

