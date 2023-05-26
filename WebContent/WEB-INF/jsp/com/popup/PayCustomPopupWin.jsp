<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.PayCustomPopup");
%>
					


	 Unilite.defineModel('${PKGNAME}.PayCustomPopupModel', {
	    fields: [{name: 'PAY_CUSTOM_CODE' 	,text:'<t:message code="system.label.common.suppcode" default="지급처"/>' 		,type:'string'	},
				 {name: 'PAY_CUSTOM_NAME'	,text:'<t:message code="system.label.common.suppname" default="지급처명"/>' 		,type:'string'	},
				 {name: 'COMPANY_NUM' 		,text:'<t:message code="system.label.common.businessdivision" default="사업자"/>/<t:message code="system.label.common.socialsecuritynumber" default="주민번호"/>' 		,type:'string'	},
				 {name: 'CUSTOM_NAME' 		,text:'<t:message code="system.label.common.bankname" default="은행명"/>' 		,type:'string'	},
				 {name: 'BANKBOOK_NUM' 		,text:'<t:message code="system.label.common.bankaccount" default="계좌번호"/>' 		,type:'string'	},
				 {name: 'BANKBOOK_NAME' 	,text:'<t:message code="system.label.common.accountholder" default="예금주"/>' 		,type:'string'	},
				 {name: 'CODE_NAME' 		,text:'<t:message code="system.label.common.suppcodetype" default="지급처구분"/>' 		,type:'string'	},
				 {name: 'BANK_CODE' 		,text:'<t:message code="system.label.common.bankcode" default="은행코드"/>' 		,type:'string'	}
				
			]
	});

    
    
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    constructor : function(config) {
    var me = this;
    if (config) {
        Ext.apply(me, config);
    }
    /**
     * 검색조건 (Search Panel)
     * @type 
     */
//    var wParam = this.param;
//    var t1= false, t2 = false;
//    if( Ext.isDefined(wParam)) {
//        if(wParam['TYPE'] == 'VALUE') {
//            t1 = true;
//            t2 = false;
//            
//        } else {
//            t1 = false;
//            t2 = true;
//            
//        }
//    }
    me.panelSearch = Unilite.createSearchForm('',{
        layout: {
        	type: 'uniTable', 
        	columns: 2, 
        	tableAttrs: {
	            style: {
	                width: '100%'
	            }
	        }
	    },
        items: [  { xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
//                 ,{ fieldLabel: ' ', 
//                    xtype: 'radiogroup', width: 230,  
//                    items:[ {inputValue: '1', boxLabel:'코드순', name: 'RDO', checked: t1},
//                            {inputValue: '2', boxLabel:'이름순',  name: 'RDO', checked: t2} ]
//                 }
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.payCustomPopupStore',{
							model: '${PKGNAME}.PayCustomPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.payCustomPopup'
					            }
					        }
					}),
	        uniOpt:{
                 expandLastColumn: false
                ,useRowNumberer: false,
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
	                     { dataIndex: 'PAY_CUSTOM_CODE' 	,  width: 80 },
	                     { dataIndex: 'PAY_CUSTOM_NAME'		,  width: 300 },
	                     { dataIndex: 'COMPANY_NUM' 	 	,  width: 120 },
	                     { dataIndex: 'CUSTOM_NAME' 	 	,  width: 80 },
	                     { dataIndex: 'BANKBOOK_NUM' 	 	,  width: 120 },
	                     { dataIndex: 'BANKBOOK_NAME'  		,  width: 250 },
	                     { dataIndex: 'CODE_NAME' 	 		,  width: 80 ,hidden:true},
	                     { dataIndex: 'BANK_CODE' 	 		,  width: 80 ,hidden:true}  
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
	    
		config.items = [me.panelSearch, 	me.masterGrid];
      	me.callParent(arguments);
    },
    initComponent : function(){    
    	var me  = this;
        
        me.masterGrid.focus();
        
    	this.callParent();    	
    },
	fnInitBinding : function(param) {
		var me = this;		
		var frm= me.panelSearch.getForm();		
		var fieldTxt = frm.findField('TXT_SEARCH');
		var frm= me.panelSearch.getForm();
		var fieldTxt = frm.findField('TXT_SEARCH');
		me.panelSearch.setValues(param);
		if(param['TYPE'] == 'VALUE') {
        	if(!Ext.isEmpty(param['PAY_CUSTOM_CODE'])){
        		fieldTxt.setValue(param['PAY_CUSTOM_CODE']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['PAY_CUSTOM_CODE'])){
        		fieldTxt.setValue(param['PAY_CUSTOM_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['PAY_CUSTOM_NAME'])){
        		fieldTxt.setValue(param['PAY_CUSTOM_NAME']);
        	}
        }
//        var me = this;
//		
//		var frm= me.panelSearch.getForm();
//		
//		var rdo = frm.findField('RDO');
//		var fieldTxt = frm.findField('TXT_SEARCH');
//
//		if( Ext.isDefined(param)) {
//			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
//				if(param['TYPE'] == 'VALUE') {
//					fieldTxt.setValue(param['PAY_CUSTOM_CODE']);
//					rdo.setValue({ RDO : '1'});
//				} else {
//					fieldTxt.setValue(param['PAY_CUSTOM_NAME']);
//					rdo.setValue({ RDO : '2'});
//				}
//			}
//			me.panelSearch.setValues(param);
//		}
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        var me = this;
		var selectRecord = me.masterGrid.getSelectedRecord();
		var rv ;
		if(selectRecord)	{
		 	rv = {
				status : "OK",
				data:[selectRecord.data]
			};
		}
		me.returnData(rv);
	},
	_dataLoad : function() {
        var me = this;
		var param= me.panelSearch.getValues();
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

