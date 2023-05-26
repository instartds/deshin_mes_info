<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
//	채권번호팝업 'Unilite.app.popup.ConfRecePopup' 
request.setAttribute("PKGNAME","Unilite.app.popup.ConfRecePopup");
%>

	/**
	 *   Model 정의 
	 */
	 Unilite.defineModel('${PKGNAME}.ConfRecePopupModel', {
	    fields: [ 	 
            {name: 'RECE_COMP_CODE'    ,text:'<t:message code="system.label.common.companycode2" default="회사코드"/>' 	,type:'string'	},
            {name: 'RECE_COMP_NAME'    ,text:'<t:message code="system.label.common.companyname" default="회사명"/>'     ,type:'string'  },
            {name: 'CONF_RECE_NO'      ,text:'<t:message code="system.label.common.creditno" default="채권번호"/>'    ,type:'string'  },
            {name: 'CUSTOM_CODE'       ,text:'<t:message code="system.label.common.customcode" default="거래처코드"/>'   ,type:'string'  },
            {name: 'CONF_RECE_CUSTOM_NAME'       ,text:'<t:message code="system.label.common.customname" default="거래처명"/>'    ,type:'string'  },
            {name: 'RECE_AMT'          ,text:'<t:message code="system.label.common.receamount" default="채권금액"/>'    ,type:'uniPrice'  }
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

            store : Unilite.createStoreSimple('${PKGNAME}.ConfRecePopupMasterStore',{
							model: '${PKGNAME}.ConfRecePopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.confRecePopup'
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
            	{dataIndex : 'RECE_COMP_CODE'		,width : 100,hidden:true},
                {dataIndex : 'RECE_COMP_NAME'       ,width : 100},
                {dataIndex : 'CONF_RECE_NO'         ,width : 120},
                {dataIndex : 'CUSTOM_CODE'          ,width : 100,hidden:true},
                {dataIndex : 'CONF_RECE_CUSTOM_NAME'          ,width : 130},
                {dataIndex : 'RECE_AMT'             ,width : 100}
                        
                        
                        
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
				frm.setValue('TXT_SEARCH', param['CONF_RECE_NO']);
			}else {
				frm.setValue('TXT_SEARCH', param['CONF_RECE_CUSTOM_NAME']);
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


