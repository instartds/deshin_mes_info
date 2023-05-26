<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
//	사용자 팝업 'Unilite.app.popup.DriverPopup' 
request.setAttribute("PKGNAME","Unilite.app.popup.DriverPopup");
%>

	/**
	 *   Model 정의 
	 */
	 Unilite.defineModel('${PKGNAME}.driverPopupModel', {
	    fields: [ 	 {name: 'DRIVER_CODE' 		,text:'<t:message code="system.label.common.drivercode" default="기사코드"/>' 	,type:'string'	}
					,{name: 'DRIVER_NAME' 		,text:'<t:message code="system.label.common.drivername" default="기사명"/>' 		,type:'string'	}
	    			,{name: 'VEHICLE_CODE' 		,text:'<t:message code="system.label.common.vehiclecode" default="차량코드"/>' 	,type:'string'	}
					,{name: 'VEHICLE_NAME' 		,text:'<t:message code="system.label.common.vehiclename" default="차량명"/>' 		,type:'string'	}
					,{name: 'JOIN_DATE' 		,text:'<t:message code="system.label.common.joindate" default="입사일"/>' 		,type:'uniDate'	}
					,{name: 'RETR_DATE' 		,text:'<t:message code="system.label.common.retrdate" default="퇴사일"/>' 		,type:'uniDate'	}				
					
					,{name: 'KOR_ADDR' 			,text:'<t:message code="system.label.common.address" default="주소"/>' 		,type:'string'	}
					,{name: 'TELEPHON' 			,text:'<t:message code="system.label.common.telephone" default="전화번호"/>' 	,type:'string'	}
					,{name: 'PHONE_NO' 			,text:'<t:message code="system.label.common.cellphone" default="핸드폰"/>' 		,type:'string'	}
					,{name: 'REPRE_NUM' 		,text:'<t:message code="system.label.common.socialsecuritynumber" default="주민번호"/>' 	,type:'string'	}
					,{name: 'LICENSE_NO' 		,text:'<t:message code="system.label.common.epno" default="면허번호"/>' 	,type:'string'	}					
					,{name: 'DIV_CODE' 			,text:'<t:message code="system.label.common.division" default="사업장"/>' 		,type:'string'	,comboType:'BOR120'}
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
                                    width:180
                                },{
                                    fieldLabel : '<t:message code="system.label.common.searchword" default="검색어"/>',
                                    name : 'TXT_SEARCH',
                                    labelWidth:60,
                                    width:180,
                                    listeners:{
                                        specialkey: function(field, e){
                                            if (e.getKey() == e.ENTER) {
                                               me.onQueryButtonDown();
                                            }
                                        }
                                    }
                                }]
                    });
		me.grid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store : Unilite.createStoreSimple('${PKGNAME}.DriverPopupMasterStore',{
							model: '${PKGNAME}.driverPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.driverPopup'
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
                        dataIndex : 'DRIVER_CODE',
                        width : 100
                    }, {
                        dataIndex : 'DRIVER_NAME',
                        width : 100
                    }, {
                        dataIndex : 'VEHICLE_CODE',
                        width : 80
                    }, {
                        dataIndex : 'VEHICLE_NAME',
                        width : 80
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
			frm.setValue('TXT_SEARCH', param['DRIVER_CODE']);
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


