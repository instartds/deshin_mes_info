<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
//	공정정보 팝업 'Unilite.app.popup.ProgWorkCode' 
request.setAttribute("PKGNAME","Unilite.app.popup.ProgWorkCode");
%>
	/**
	 *   Model 정의 
	 */
	 Unilite.defineModel('${PKGNAME}.ProgWorkCodePopupModel', {
	    fields: [ 	 {name: 'PROG_WORK_CODE'     ,text:'<t:message code="system.label.common.routingcode" default="공정코드"/>' 		,type:'string'	}
					,{name: 'PROG_WORK_NAME'		 	,text:'<t:message code="system.label.common.routingname" default="공정명"/>' 		,type:'string'	}
					,{name: 'PROG_UNIT'			 				,text:'<t:message code="system.label.common.routingunit" default="공정단위"/>' 		,type:'string'	}
					,{name: 'STD_TIME'                            ,text:'표준시간'      ,type:'string'  }
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
			
            store : Unilite.createStoreSimple('${PKGNAME}.ProgWorkCodePopupMasterStore',{
							model: '${PKGNAME}.ProgWorkCodePopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.progWorkCode'
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
						,{ dataIndex: 'PROG_WORK_NAME'	   		,width: 400 }
						,{ dataIndex: 'PROG_UNIT'				,minWidth: 100, flex: 1 }
						,{ dataIndex: 'STD_TIME'                ,width: 100 }
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
			
			if(param['DIV_CODE'] && param['DIV_CODE']!='')				frm.setValue('DIV_CODE',   param['DIV_CODE']);
			if(param['PROG_WORK_CODE'] && param['PROG_WORK_CODE']!='')	frm.setValue('TXT_SEARCH', param['PROG_WORK_CODE']);
			if(param['PROG_WORK_NAME'] && param['PROG_WORK_NAME']!='')	frm.setValue('TXT_SEARCH', param['PROG_WORK_NAME']);
			if(param['WORK_SHOP_CODE'] && param['WORK_SHOP_CODE']!='')	frm.setValue('WORK_SHOP_CODE',   param['WORK_SHOP_CODE']);
            if(param['ITEM_CODE'] && param['ITEM_CODE']!='')  frm.setValue('ITEM_CODE', param['ITEM_CODE']);
			
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