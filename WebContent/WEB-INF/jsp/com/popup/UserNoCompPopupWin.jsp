<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
//	사용자 팝업 'Unilite.app.popup.UserNoCompPopup' 
request.setAttribute("PKGNAME","Unilite.app.popup.UserNoCompPopup");
%>

	/**
	 *   Model 정의 
	 */
	 Unilite.defineModel('${PKGNAME}.UserNoCompPopupModel', {
	    fields: [ 	 {name: 'USER_ID' 			,text:'<t:message code="system.label.common.user" default="사용자"/>ID' 	,type:'string'	}
					,{name: 'USER_NAME' 		,text:'<t:message code="system.label.common.user" default="사용자"/>' 	,type:'string'	}
	    			,{name: 'DEPT_CODE' 		,text:'<t:message code="system.label.common.departmencode" default="부서코드"/>' 	,type:'string'	}
					,{name: 'DEPT_NAME' 		,text:'<t:message code="system.label.common.departmentname" default="부서명"/>' 	,type:'string'	}
					,{name: 'DIV_CODE' 			,text:'<t:message code="system.label.common.division" default="사업장"/>' 	,type:'string'	}
					,{name: 'BILL_DIV_CODE' 	,text:'<t:message code="system.label.common.declaredivisioncode2" default="신고사업장코드"/>' 	,type:'string'	}
					,{name: 'BILL_DIV_NAME' 	,text:'<t:message code="system.label.common.declaredivisionname" default="신고사업장명"/>' 	,type:'string'	}
					,{name: 'SECTION_CODE' 		,text:'<t:message code="system.label.common.businessdivisioncode" default="사업부코드"/>' 	,type:'string'	}
					,{name: 'SECTION_NAME' 		,text:'<t:message code="system.label.common.businessdivisionname" default="사업부"/>' 	,type:'string'	}
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
                            type : 'table',
                            columns : 1,
                            tableAttrs : {
                                style : {
                                    width : '100%'
                                }
                            }
                        },
                        items : [{
                                    fieldLabel : '<t:message code="system.label.common.searchword" default="검색어"/>',
                                    name : 'TXT_SEARCH',
                                    listeners:{
                                        specialkey: function(field, e){
                                            if (e.getKey() == e.ENTER) {
                                               me.onQueryButtonDown();
                                            }
                                        }
                                    }
                                }]
                    });
		var masterGridConfig = {

            store : Unilite.createStoreSimple('${PKGNAME}.UserNoCompPopupMasterStore',{
							model: '${PKGNAME}.UserNoCompPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.userNoCompPopup'
					            }
					        }
					}),
	        uniOpt:{
                useRowNumberer: false,
                onLoadSelectFirst : false     ,
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
                        dataIndex : 'USER_ID',
                        width : 100
                    }, {
                        dataIndex : 'USER_NAME',
                        width : 140
                    }, {
                        dataIndex : 'DEPT_CODE',
                        width : 80
                    }, {
                        dataIndex : 'DEPT_NAME',
                        width : 100
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
        };
        var wParam = this.param;
        if(Ext.isDefined(wParam)) {     
	        if(wParam['SELMODEL'] == 'MULTI') {
	            masterGridConfig.selModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : false });
	        }
	    }
	    
	    me.grid = Unilite.createGrid('', masterGridConfig);
	    
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
			if(param['TYPE'] == 'VALUE')	{
				frm.setValue('TXT_SEARCH', param['USER_ID']);
			}else {
				frm.setValue('TXT_SEARCH', param['USER_NAME']);
			}
			this._dataLoad();
        }
	},
    onSubmitButtonDown : function()	{
//        var me = this;
//		var selectRecord = me.grid.getSelectedRecord();
//	 	var rv = {
//			status : "OK",
//			data:[selectRecord.data]
//		};
//		me.returnData(rv);
    	var me = this,
        masterGrid = me.grid;
		var selectRecords = masterGrid.getSelectedRecords();
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


