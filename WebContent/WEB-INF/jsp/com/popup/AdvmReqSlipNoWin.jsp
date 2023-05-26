<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
//	작업지시정보 팝업 'Unilite.app.popup.advmReqSlipNo' 
request.setAttribute("PKGNAME","Unilite.app.popup.AdvmReqSlipNo");
%>
	/**
	 *   Model 정의 
	 */
	 Unilite.defineModel('${PKGNAME}.advmReqSlipNoPopupModel', {
	    fields: [ 	
            {name: 'VENDOR_ID'	 		   ,text:'<t:message code="system.label.common.suppcode" default="지급처"/>'	 	 ,type:'string'	},
			{name: 'VENDOR_NM'             ,text:'<t:message code="system.label.common.suppname" default="지급처명"/>'          ,type:'string'  },
            {name: 'ADVM_REQ_SLIP_NO'      ,text:'<t:message code="system.label.common.slipno" default="전표번호"/>'         ,type:'string'  },
            {name: 'SLIP_DESC'             ,text:'<t:message code="system.label.common.remark" default="적요"/>'            ,type:'string'  },
            {name: 'NAME'                  ,text:'<t:message code="system.label.common.writer" default="작성자"/>'           ,type:'string'  },
            {name: 'SLIP_AMT'              ,text:'<t:message code="system.label.common.slipamount" default="전표금액"/>'          ,type:'uniPrice'  }
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
                        layout : {type : 'uniTable', columns : 2 },
                        items : [{
                          fieldLabel : '<t:message code="system.label.common.slipno" default="전표번호"/>',
                          name : 'ADVM_REQ_SLIP_NO',
                          xtype: 'uniTextfield',
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
		me.grid = Ext.create('Unilite.com.grid.UniGridPanel',{
			
            store : Unilite.createStoreSimple('${PKGNAME}.advmReqSlipNoPopupMasterStore',{
							model: '${PKGNAME}.advmReqSlipNoPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.advmReqSlipNo'
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
		           		 { dataIndex: 'VENDOR_ID'                ,width: 100 ,hidden:true},  
                         { dataIndex: 'VENDOR_NM'                ,width: 120 }, 
                         { dataIndex: 'ADVM_REQ_SLIP_NO'         ,width: 120 }, 
                         { dataIndex: 'SLIP_DESC'                ,width: 250 }, 
                         { dataIndex: 'NAME'                     ,width: 100 }, 
                         { dataIndex: 'SLIP_AMT'                 ,width: 120 }	
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
			frm.setValue('ADVM_REQ_SLIP_NO', param['ADVM_REQ_SLIP_NO']);
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