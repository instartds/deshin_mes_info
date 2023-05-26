<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
//	차량 팝업 'Unilite.app.popup.VehiclePopup' 
request.setAttribute("PKGNAME","Unilite.app.popup.VehiclePopup");
%>

	/**
	 *   Model 정의 
	 */
	 Unilite.defineModel('${PKGNAME}.VehiclePopupModel', {
	    fields: [ 	 {name: 'VEHICLE_CODE' 			,text:'<t:message code="system.label.common.vehiclecode" default="차량코드"/>' 	,type:'string'	}
					,{name: 'VEHICLE_NAME' 				,text:'<t:message code="system.label.common.vehiclename" default="차량명"/>' 	,type:'string'	}
					,{name: 'VEHICLE_REGIST_NO' 	,text:'<t:message code="system.label.common.owncompnum" default="등록번호"/>' 	,type:'string'	}
					,{name: 'REGIST_STATUS' 				,text:'<t:message code="system.label.common.owncompstatus" default="등록상태"/>' 	,type:'string', comboType:'AU',comboCode:'GO13'	}
	    			,{name: 'DIV_CODE' 						,text:'<t:message code="system.label.common.division" default="사업장"/>' 	,type:'string'	,comboType:'BOR120'}
			]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					

	
 
    
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
                            columns : 2,
                            tableAttrs : {
                                style : {
                                    width : '100%'
                                }
                            }
                        },
                        items : [{
                                    fieldLabel : '<t:message code="system.label.common.division" default="사업장"/>',
                                    name : 'DIV_CODE',
                                    xtype:'uniCombobox',
                                    comboType:'BOR120',
                                    labelWidth:60,
                                    width:180,
                                    colspan:2
                                },{
                                    fieldLabel : '<t:message code="system.label.common.searchword" default="검색어"/>',
                                    name : 'TXT_SEARCH',
                                    labelWidth:60,
                                    width:180
                                },{
                                    fieldLabel : '<t:message code="system.label.common.owncompstatus" default="등록상태"/>',
                                    name : 'REGIST_STATUS',
                                    labelWidth:60,
                                    width:180,
                                    xtype:'uniCombobox',
                                    comboType:'AU',
                                    comboCode:'GO13'
                                }]
                    });
		me.grid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store : Unilite.createStoreSimple('${PKGNAME}.VehiclePopupMasterStore',{
							model: '${PKGNAME}.VehiclePopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.vehiclePopup'
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
                        dataIndex : 'VEHICLE_CODE',
                        width : 80
                    }, {
                        dataIndex : 'VEHICLE_NAME',
                        width : 80
                    }, {
                        dataIndex : 'VEHICLE_REGIST_NO',
                        width : 110
                    }, {
                        dataIndex : 'REGIST_STATUS',
                        flex: 1
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
			frm.setValue('DIV_CODE', param['DIV_CODE']);
			console.log("param['TYPE'] :",param['TYPE'] );
			if(param['TYPE'] == 'VALUE') frm.setValue('TXT_SEARCH', param['VEHICLE_CODE']);
			else frm.setValue('TXT_SEARCH', param['VEHICLE_NAME']);
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


