<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 작업장 팜업
request.setAttribute("PKGNAME","Unilite.app.popup.programPopup");
%>
/** Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.programPopupModel', {
	fields: [{name: 'PGM_SEQ'			,text:'모율'	,type:'string', comboType: 'AU', comboCode: 'B007'	}
			,{name: 'PGM_ID'			,text:'<t:message code="system.label.common.system.label.base.programid" default="프로그램ID"/>'	,type:'string'	}
			,{name: 'PGM_NAME'			,text:'<t:message code="system.label.common.system.label.base.programname" default="프로그램명"/>'	,type:'string'	}
			,{name: 'PGM_NAME_EN' 	    ,text:'<t:message code="system.label.base.programnameen" default="프로그램명(영어)"/>' 	,type:'string'	}
			,{name: 'PGM_NAME_CN' 	    ,text:'<t:message code="system.label.base.programnamecn" default="프로그램명(중국어)"/>' 	,type:'string'	}
			,{name: 'PGM_NAME_JP' 	    ,text:'<t:message code="system.label.base.programnamejp" default="프로그램명(일본어)"/>' 	,type:'string'	}
			,{name: 'PGM_NAME_VI' 	    ,text:'<t:message code="system.label.base.programnamevi" default="프로그램명(베트남어)"/>' ,type:'string'	}
			,{name: 'LOCATION' 	        ,text:'<t:message code="system.label.common.location" default="위치"/>' ,type:'string'	}
			,{name: 'TYPE' 	            ,text:'<t:message code="system.label.common.type" default="유형"/>' ,type:'string'	}
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
			{ fieldLabel: '모듈',		name: 'PGM_SEQ'		, xtype: 'uniCombobox', comboType:'AU', comboCode:'B007'},
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
		store: Unilite.createStore('${PKGNAME}.programPopupMasterStore',{
						model: '${PKGNAME}.programPopupModel',
						autoLoad: true,
						proxy: {
							type: 'direct',
							api: {
								read: 'popupService.programPopup'
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
			{ dataIndex: 'PGM_SEQ'		,width: 120 },
			{ dataIndex: 'PGM_ID'		,width: 100 },
			{ dataIndex: 'PGM_NAME'		,width: 120 },
			{ dataIndex: 'PGM_NAME_EN'		,width: 120 },
			{ dataIndex: 'PGM_NAME_CN'		,width: 120 },
			{ dataIndex: 'PGM_NAME_JP'		,width: 120 },
			{ dataIndex: 'PGM_NAME_VI'		,width: 120 },
			{ dataIndex: 'LOCATION'		,width: 120, hidden:true},
			{ dataIndex: 'TYPE'		    ,width: 120, hidden:true }
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
		
		if(param['PGM_ID'] && param['PGM_ID']!='')	frm.setValue('TXT_SEARCH', param['PGM_ID']);
		if(param['PGM_NAME'] && param['PGM_NAME']!='')	frm.setValue('TXT_SEARCH', param['PGM_NAME']);
		
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

