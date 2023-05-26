<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.InoutNumPopup");
%>

	/**
	 *   Model 정의 
	 */
	 Unilite.defineModel('${PKGNAME}.InoutNumPopupModel', {
	    fields: [ 	 {name: 'INOUT_NUM' 		,text:'<t:message code="system.label.common.tranno" default="수불번호"/>' 	,type:'string'	}
					,{name: 'INOUT_DATE' 		,text:'<t:message code="system.label.common.transdate" default="수불일"/>' 	,type:'string'	}
					,{name: 'INOUT_CODE' 		,text:'<t:message code="system.label.common.tranplace" default="수불처"/>' 	,type:'string'	}
					,{name: 'CUSTOM_NAME' 		,text:'<t:message code="system.label.sales.tranplacename" default="수불처명"/>' 	,type:'string'}
	    			,{name: 'WH_CODE' 			,text:'<t:message code="system.label.common.warehouse" default="창고"/>' 		,type:'string'}
	    			,{name: 'DIV_CODE' 			,text:'<t:message code="system.label.common.division" default="사업장"/>' 	,type:'string', comboType:'BOR120'}
	    			,{name: 'AGENT_TYPE' 		,text:'<t:message code="system.label.common.clienttype" default="고객분류"/>CD'	,type:'string'}
	    			,{name: 'AREA_TYPE' 		,text:'<t:message code="system.label.common.areatype" default="지역분류"/>CD'	,type:'string'}
	    			,{name: 'INOUT_TYPE' 		,text:'<t:message code="system.label.common.tranclass" default="수불구분"/>' 	,type:'string'}
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
                            type : 'uniTable',
                            columns : 2
                        },
                        items : [{
                        			xtype: 'uniTextfield',
                                    fieldLabel : '<t:message code="system.label.common.tranno" default="수불번호"/>',
                                    name : 'TXT_SEARCH',
                                    listeners:{
                                        specialkey: function(field, e){
                                            if (e.getKey() == e.ENTER) {
                                               me.onQueryButtonDown();
                                            }
                                        }
                                    }
                                },{
                               		fieldLabel: ' ',
				                    xtype: 'radiogroup',
				                    items:[{inputValue: '1', boxLabel: '<t:message code="system.label.common.transdateinorder" default="수불일순"/>', name: 'RDO', checked: true, width: 80},
				                           {inputValue: '2', boxLabel: '<t:message code="system.label.sales.clientinorder" default="고객순"/>',  name: 'RDO', width: 60} ]
			                   },{
				               		xtype:'uniTextfield',
				               		name: 'INOUT_TYPE',
				               		hidden: true
				               },{
				               		xtype:'uniTextfield',
				               		name: 'DIV_CODE',
				               		hidden: true
				               }
			               ]
                    });
		me.grid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store : Unilite.createStoreSimple('${PKGNAME}.InoutNumPopupMasterStore',{
							model: '${PKGNAME}.InoutNumPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.inoutNumPopup'
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
            columns : [{dataIndex : 'INOUT_NUM' 		, width : 100},
            		   {dataIndex : 'INOUT_DATE' 		, width : 80},
            		   {dataIndex : 'INOUT_CODE' 		, width : 80},
            		   {dataIndex : 'CUSTOM_NAME' 		, width : 205},
            		   {dataIndex : 'WH_CODE' 			, width : 80, hidden: true},
            		   {dataIndex : 'DIV_CODE' 			, width : 80, hidden: true},
            		   {dataIndex : 'AGENT_TYPE' 		, width : 80, hidden: true},
            		   {dataIndex : 'AREA_TYPE' 		, width : 80, hidden: true},
            		   {dataIndex : 'INOUT_TYPE' 		, width : 80, hidden: true}
            		   
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
			frm.setValue('INOUT_TYPE', param['INOUT_TYPE']);
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


