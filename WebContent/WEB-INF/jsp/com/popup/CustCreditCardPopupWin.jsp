<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 부서팝업
request.setAttribute("PKGNAME","Unilite.app.popup.CustCreditCard");
%>



	/**
	 *   Model 정의 
	 * @type 
	 */
Unilite.defineModel('${PKGNAME}.CustCreditCardPopupModel', {
    extend: 'Ext.data.Model',
    fields: [ 	 {name: 'CUST_CREDIT_CODE'  	,text:'<t:message code="system.label.common.customcode" default="거래처코드"/>' 	,type:'string'	}
				,{name: 'CUST_CREDIT_NAME' 		,text:'<t:message code="system.label.common.customname" default="거래처명"/>' 		,type:'string'	}
				,{name: 'CARD_COMP_CODE'			,text:'<t:message code="system.label.common.creditcardcompcode" default="신용카드사코드"/>' 	,type:'string'	}
				,{name: 'CODE_NAME'      				,text:'<t:message code="system.label.common.creditcardcomp" default="신용카드사"/>' 	,type:'string'	}
				,{name: 'FEE_RATE'       						,text:'<t:message code="system.label.common.commissionrate" default="수수료율"/>' 		,type:'uniPercent'	}
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
	    var wParam = this.param;
	    var t1= false, t2 = false;
	    if( Ext.isDefined(wParam)) {
	        if(wParam['TYPE'] == 'VALUE') {
	            t1 = true;
	            t2 = false;
	            
	        } else {
	            t1 = false;
	            t2 = true;
	            
	        }
	    }
/**
 * 검색조건 (Search Panel)
 * @type 
 */

		me.panelSearch =  Unilite.createSearchForm('',{
		    layout : {type : 'table', columns : 2, tableAttrs: {
		        style: {
		            width: '100%'
		        }
		    }},
		    items: [{
		    	fieldLabel: '<t:message code="system.label.common.searchword" default="검색어"/>',
		    	name:'TXT_SEARCH',
                listeners:{
                    specialkey: function(field, e){
                        if (e.getKey() == e.ENTER) {
                           me.onQueryButtonDown();
                        }
                    }
                }
            },{ fieldLabel: ' ', 
                    xtype: 'radiogroup', width: 230, id:'rdoRadio', 
                    items:[ {inputValue: '1', boxLabel:'<t:message code="system.label.common.codeinorder" default="코드순"/>', name: 'RDO', checked: t1},
                            {inputValue: '2', boxLabel:'<t:message code="system.label.common.nameinorder" default="이름순"/>',  name: 'RDO', checked: t2} ]
            }]
		});  
		
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		me.masterGrid =  Unilite.createGrid('', {
			store: Unilite.createStoreSimple('${PKGNAME}.CustCreditCardPopupMasterStore',{
								model: '${PKGNAME}.CustCreditCardPopupModel',
						        autoLoad: false,
						        proxy: {
						            type: 'direct',
						            api: {
						            	read: 'popupService.custCreditCard'
						            }
						        }
						}),				
			uniOpt: {
				expandLastColumn: false,
				useRowNumberer: false,
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
		           		 { dataIndex: 'CUST_CREDIT_CODE'   	,width: 90 }  
						,{ dataIndex: 'CUST_CREDIT_NAME'   	,width: 150 }
						,{ dataIndex: 'CARD_COMP_CODE'		,width: 100 } 	
						,{ dataIndex: 'CODE_NAME'      		,width: 150 } 	
						,{ dataIndex: 'FEE_RATE'       		,width: 90 } 	
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
		config.items = [me.panelSearch,	me.masterGrid];
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
		var rdo = frm.findField('rdoRadio');
		var fieldTxt = frm.findField('TXT_SEARCH');
		if( Ext.isDefined(param)) {
			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
				if(param['TYPE'] == 'VALUE') {
					fieldTxt.setValue(param['CUST_CREDIT_CODE']);
					rdo.setValue({ RDO : '1'});
				}else{
					fieldTxt.setValue(param['CUST_CREDIT_NAME']);
					rdo.setValue({ RDO : '2'});
				}					
			}
		}
		me.panelSearch.setValues(param);
		
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
