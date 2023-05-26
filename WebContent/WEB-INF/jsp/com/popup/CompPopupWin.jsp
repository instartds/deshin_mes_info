<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
//	회사정보 팝업 'Unilite.app.popup.CompPopup' 
request.setAttribute("PKGNAME","Unilite.app.popup.CompPopup");
%>

	/**
	 *   Model 정의 
	 */
	 Unilite.defineModel('${PKGNAME}.CompPopupModel', {
	    fields: [ 	 {name: 'COMP_CODE' 		,text:'<t:message code="system.label.common.companycode2" default="회사코드"/>' 	,type:'string'	}
					,{name: 'COMP_NAME' 		,text:'<t:message code="system.label.common.companyname" default="회사명"/>' 	,type:'string'	}
	    			,{name: 'REPRE_NAME' 		,text:'<t:message code="system.label.common.representativename" default="대표자명"/>' 	,type:'string'	}
					,{name: 'COMPANY_NUM' 		,text:'<t:message code="system.label.common.compnum" default="사업자등록번호"/>' 	,type:'string'	}
					,{name: 'TELEPHON' 			,text:'<t:message code="system.label.common.telephonnum" default="대표전화번호"/>' 	,type:'string'	}
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
                                }
                                ,{ xtype: 'uniTextfield',      name:'ADD_QUERY', hidden: true}]
                    });
		var masterGridConfig = {

            store : Unilite.createStoreSimple('${PKGNAME}.CompPopupMasterStore',{
							model: '${PKGNAME}.CompPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.compPopup'
					            }
					        }
					}),
	        uniOpt:{
                useRowNumberer: false,
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
            columns : [
            	{dataIndex : 'COMP_CODE'		,width : 100},
            	{dataIndex : 'COMP_NAME'		,width : 120},
            	{dataIndex : 'REPRE_NAME'		,width : 100,align:'center'},
            	{dataIndex : 'COMPANY_NUM'		,width : 100},
            	{dataIndex : 'TELEPHON'			,width : 120}
                        
                        
                        
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
				frm.setValue('TXT_SEARCH', param['COMP_CODE']);
			}else {
				frm.setValue('TXT_SEARCH', param['COMP_NAME']);
			}
			frm.setValues(param);
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


