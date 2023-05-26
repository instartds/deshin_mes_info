<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
//	사용자 팝업 'Unilite.app.popup.CountDatePopup' 
request.setAttribute("PKGNAME","Unilite.app.popup.CountDatePopup");
%>

/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.CountDatePopupModel', {
    fields: [ 	 
    	 {name: 'DIV_CODE' 				,text:'<t:message code="system.label.common.divisioncode" default="사업장코드"/>' 		,type:'string'	}
		,{name: 'WH_CODE' 				,text:'<t:message code="system.label.common.warehousecode" default="창고코드"/>' 		,type:'string'	}
		,{name: 'WH_NAME' 				,text:'<t:message code="system.label.common.warehousename" default="창고명"/>' 		,type:'string'	}
		,{name: 'COUNT_DATE' 			,text:'<t:message code="system.label.common.stockcountingdateselect" default="실사(선별)일"/>' 	,type:'uniDate'	}
		,{name: 'COUNT_FLAG' 			,text:'<t:message code="system.label.common.status" default="상태"/>' 			,type:'string'	}
		,{name: 'COUNT_CONT_DATE' 		,text:'<t:message code="system.label.common.stockcountingapplydate" default="실사반영일"/>'	 	,type:'uniDate'	}
		,{name: 'COUNT_FLAG_CD' 		,text:'<t:message code="system.label.common.statuscode" default="상태코드"/>' 		,type:'string'	}	
	]
});

/**
 * 검색조건 (Search Panel)
 * @type 
 */
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    constructor : function(config) {
    var me = this;
    if (config) {
        Ext.apply(me, config);
    }
/**
 * Master Grid 정의(Grid Panel)
 * @type 
 */
	 me.panelSearch =  Unilite.createSearchForm('',{
	 		hidden: true,
		    layout : {type : 'table', columns : 1, tableAttrs: {
		        style: {
		            width: '100%'
		        }
		    }},
		    items: [{					
					fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120'
				},{
					fieldLabel: '<t:message code="system.label.common.warehouse" default="창고"/>',
					name:'WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList')
				},
				Unilite.popup('COUNT_DATE', { 
					fieldLabel: '<t:message code="system.label.common.stockcountingdate" default="실사일"/>', 
					textFieldWidth: 150, 
					validateBlank: false
				})
			]
		}); 
	 
	 me.masterGrid = Unilite.createGrid('', {
		store: Unilite.createStore('${PKGNAME}.countdatePopupMasterStore',{
						model: '${PKGNAME}.CountDatePopupModel',
				        autoLoad: false,
				        proxy: {
				            type: 'direct',
				            api: {
				            	read: 'popupService.countdatePopup'
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
	           	{dataIndex : 'DIV_CODE' 		, width : 80, hidden: true}, 
            	{dataIndex : 'WH_CODE' 			, width : 86}, 
            	{dataIndex : 'WH_NAME' 			, width : 113}, 
            	{dataIndex : 'COUNT_DATE' 		, width : 93},
            	{dataIndex : 'COUNT_FLAG' 		, width : 86}, 
            	{dataIndex : 'COUNT_CONT_DATE' 	, width : 86}, 
            	{dataIndex : 'COUNT_FLAG_CD' 	, width : 86, hidden: true}			
			
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
	    config.items = [me.panelSearch,	me.masterGrid];
	    me.callParent(arguments);
    },
	initComponent : function(){    
    	var me  = this;
        me.masterGrid.focus();
        this.callParent();    	
    },    
	fnInitBinding : function(param) {
		var frm= this.panelSearch;
        if(param) {
			frm.setValue('DIV_CODE', param['DIV_CODE']);
			frm.setValue('WH_CODE', param['WH_CODE']);
			frm.setValue('COUNT_DATE', param['COUNT_DATE']);
		}
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
		this.masterGrid.getStore().load();
		var me = this;
		var param= me.panelSearch.getValues();
		var cOUNTdATE = me.panelSearch.getValue('COUNT_DATE').replace('.','');
		var countdateReplace = cOUNTdATE.replace('.','');
		param.COUNT_DATE = countdateReplace;
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

