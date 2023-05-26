<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.CheckNumPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	


	 Unilite.defineModel('${PKGNAME}.CheckNumPopupModel', {
	    fields: [{name: 'CHECK_NUM_CODE' 	,text:'<t:message code="system.label.common.note" default="어음"/>/<t:message code="system.label.common.checknum" default="수표번호"/>' 	,type:'string'	},
				 {name: 'BANK_CODE'			,text:'<t:message code="system.label.common.bankcode" default="은행코드"/>' 		,type:'string'	},
				 {name: 'BANK_NAME' 		,text:'<t:message code="system.label.common.bankname" default="은행명"/>' 		,type:'string'	},
				 {name: 'INSOCK_DATE' 		,text:'<t:message code="system.label.common.receiptdate2" default="입고일"/>' 		,type:'uniDate'	},
				 {name: 'FLOAT_DATE' 		,text:'<t:message code="system.label.common.publishdate" default="발행일"/>' 		,type:'uniDate'	},
				 {name: 'SET_DATE' 			,text:'<t:message code="system.label.common.paydate" default="결제일"/>' 		,type:'uniDate'	}
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
//                    items:[ {inputValue: '1', boxLabel:'코드순', name: 'RDO', checked: true},
//                            {inputValue: '2', boxLabel:'이름순',  name: 'RDO', checked: false} ]
//                 }
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.checkNumPopupStore',{
							model: '${PKGNAME}.CheckNumPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.checkNumPopup'
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
	                     { dataIndex: 'CHECK_NUM_CODE' 		,  width: 140 }
	                    ,{ dataIndex: 'BANK_CODE'			,  width: 80 }
	                    ,{ dataIndex: 'BANK_NAME' 			,  width: 120 }
	                    ,{ dataIndex: 'INSOCK_DATE' 		,  width: 100}
	                    ,{ dataIndex: 'FLOAT_DATE' 			,  width: 100 }
	                    ,{ dataIndex: 'SET_DATE' 			,  minWidth: 100, flex: 1 }
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
        	if(!Ext.isEmpty(param['CHECK_NUM_CODE'])){
        		fieldTxt.setValue(param['CHECK_NUM_CODE']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['CHECK_NUM_CODE'])){
        		fieldTxt.setValue(param['CHECK_NUM_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['CHECK_NUM_NAME'])){
        		fieldTxt.setValue(param['CHECK_NUM_NAME']);
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
//					fieldTxt.setValue(param['CHECK_NUM_CODE']);
//					rdo.setValue({ RDO : '1'});
//				} /*else {
//					fieldTxt.setValue(param['CHECK_NUM_NAME']);
//					rdo.setValue({ RDO : '2'});
//				}*/
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

