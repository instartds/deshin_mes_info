<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
//	공정불량 팝업 'Unilite.app.popup.BadCode' 
request.setAttribute("PKGNAME","Unilite.app.popup.BadCode");
%>
	/**
	 *   Model 정의 
	 */
	 Unilite.defineModel('${PKGNAME}.BadCodePopupModel', {
	    fields: [ 	 {name: 'PROG_WORK_CODE'    ,text:'<t:message code="system.label.common.routingcode" default="공정코드"/>' 		,type:'string'	}
					,{name: 'PROG_WORK_NAME'	,text:'<t:message code="system.label.common.routingname" default="공정명"/>' 		,type:'string'	}
					,{name: 'BAD_CODE'			,text:'<t:message code="system.label.product.defectcode" default="불량코드"/>' 		,type:'string'	}
					,{name: 'BAD_NAME'         	,text:'<t:message code="system.label.purchase.defectcodename" default="불량코드명"/>'       ,type:'string'  }
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
                        layout : {type : 'uniTable', columns : 3 },
                        items : [{
                                  fieldLabel : '<t:message code="system.label.common.division" default="사업장"/>',
                                  name : 'DIV_CODE',
                                  xtype: 'uniTextfield',
                                  hidden: true
                               },{
                                  fieldLabel : '<t:message code="system.label.common.workcenter" default="작업장"/>',
                                  name : 'WORK_SHOP_CODE',
                                  xtype: 'uniTextfield',
                                  hidden: true
                               },{
                                  fieldLabel : '<t:message code="system.label.common.searchword" default="검색어"/>',
                                  name : 'TXT_SEARCH',
                                  xtype: 'uniTextfield',
                                    listeners:{
                                        specialkey: function(field, e){
                                            if (e.getKey() == e.ENTER) {
                                               me.onQueryButtonDown();
                                            }
                                        }
                                    }
                                },{
                                  fieldLabel : '품목코드',
                                  name : 'ITEM_CODE',
                                  xtype: 'uniTextfield',
                                  hidden: true
                                }
                       
                        ]
                    });
        var gridModel;
        if(Ext.isDefined(this.param)) {     
            if(this.param['SELMODEL'] == 'MULTI') {
                gridModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : false });
            }else{
                gridModel = 'rowmodel';
            }        
        }
		me.grid = Ext.create('Unilite.com.grid.UniGridPanel',{
			
            store : Unilite.createStoreSimple('${PKGNAME}.BadCodePopupMasterStore',{
							model: '${PKGNAME}.BadCodePopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.selectBadCodePopup'
					            }
					        }
					}),
			selModel:gridModel,
			uniOpt:{
                useRowNumberer: false,
                onLoadSelectFirst : false  ,
                state: {
					useState: false,
					useStateList: false	
	            },
				pivot : {
					use : false
				}
            },
            columns:  [        
		           		 { dataIndex: 'PROG_WORK_CODE'     		,width: 100 }  
						,{ dataIndex: 'PROG_WORK_NAME'	   		,width: 200 }
						,{ dataIndex: 'BAD_CODE'				,width: 100 }
						,{ dataIndex: 'BAD_NAME'                ,minWidth: 200, flex: 1 }
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
			
			if(param['DIV_CODE'] && param['DIV_CODE']!='')		frm.setValue('DIV_CODE',   param['DIV_CODE']);
			if(param['BAD_CODE'] && param['BAD_CODE']!='')		frm.setValue('TXT_SEARCH', param['BAD_CODE']);
			if(param['BAD_NAME'] && param['BAD_NAME']!='')		frm.setValue('TXT_SEARCH', param['BAD_NAME']);
			if(param['WORK_SHOP_CODE'] && param['WORK_SHOP_CODE']!='')	frm.setValue('WORK_SHOP_CODE',   param['WORK_SHOP_CODE']);
			
		}
		this._dataLoad();
        
	},
    onSubmitButtonDown : function()	{
        var me = this;
		var selectRecords = me.grid.getSelectedRecords();
		var rvRecs= new Array();
	 	Ext.each(selectRecords, function(record, i)  {
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