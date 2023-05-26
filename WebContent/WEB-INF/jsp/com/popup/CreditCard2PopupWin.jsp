<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 신용카드 팝업
request.setAttribute("PKGNAME","Unilite.app.popup.CreditCard2");
%>

/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}CreditCard2PopupModel', {
    fields: [ 	 {name: 'CRDT_NUM' 			,text:'<t:message code="system.label.common.creditcardcode" default="신용카드코드"/>' 			,type:'string'	}
    			,{name: 'CRDT_NAME' 				,text:'<t:message code="system.label.common.creditcardname" default="카드명"/>' 				,type:'string'	}
    			,{name: 'CRDT_FULL_NUM' 		,text:'<t:message code="system.label.common.creditcardnum" default="신용카드번호"/>' 			,type:'string'	}
    			,{name: 'BANK_CODE' 				,text:'<t:message code="system.label.common.bankcode" default="은행코드"/>' 				,type:'string'	}
    			,{name: 'BANK_NAME' 				,text:'<t:message code="system.label.common.bankname" default="은행명"/>' 				,type:'string'	}
    			,{name: 'ACCOUNT_NUM' 		,text:'<t:message code="system.label.common.paybankaccount" default="결제계좌번호"/>' 			,type:'string'	}
    			,{name: 'SET_DATE' 					,text:'<t:message code="system.label.common.paydate" default="결제일"/>' 				,type:'uniDate'	}
    			,{name: 'PERSON_NAME'			,text:'<t:message code="system.label.common.employeename" default="사원명"/>' 				,type:'string'	}
    			,{name: 'CRDT_COMP_CD' 		,text:'<t:message code="system.label.common.creditcardcompcode" default="신용카드사코드"/>' 				,type:'string'	}
    			,{name: 'CRDT_COMP_NM'		,text:'<t:message code="system.label.common.creditcardcomp" default="신용카드사"/>' 			,type:'string'	}
    			,{name: 'COMP_CODE'				,text:'<t:message code="system.label.common.companycode" default="법인코드"/>' 				,type:'string'	}
    			
    			,{name: 'INSERT_DB_TIME' 	,text:'INSERT_DB_TIME' 		,type:'uniDate'	}
    			,{name: 'INSERT_DB_USER' 	,text:'INSERT_DB_USER' 		,type:'string'	}
    			,{name: 'UPDATE_DB_TIME' 	,text:'UPDATE_DB_TIME' 		,type:'uniDate'	}
    			,{name: 'UPDATE_DB_USER' 	,text:'UPDATE_DB_USER' 		,type:'string'	}
			]
	});
	
  

/**
 * 검색조건 (Search Panel)
 * @type 
 */
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
	me.panelSearch = Unilite.createSearchForm('',{
	    layout : {type : 'uniTable', columns : 2, tableAttrs: {
	        style: {
	            width: '100%'
	        }
	    }},
	    items: [ { fieldLabel: '<t:message code="system.label.common.companycode" default="법인코드"/>', name: 'COMP_CODE' 		, xtype: 'uniTextfield' , hidden:true}
	            ,{ fieldLabel: '<t:message code="system.label.common.search" default="찾기"/>',   	name: 'TXT_SEARCH' 		, xtype: 'uniTextfield',
                    listeners:{
                        specialkey: function(field, e){
                            if (e.getKey() == e.ENTER) {
                               me.onQueryButtonDown();
                            }
                        }
                    }
                }
	            ,{ fieldLabel: '<t:message code="system.label.common.cardcode" default="카드코드"/>',   name: 'CRDT_NUM' 		, xtype: 'uniTextfield', hidden: true }
	            ,{ fieldLabel: '<t:message code="system.label.common.card" default="카드"/>',   	name: 'CRDT_NAME' 		, xtype: 'uniTextfield', hidden: true }
	            
	            ,{ fieldLabel: ' ',
	                    xtype: 'radiogroup', width: 230, name: 'rdoRadio',
	                     items:[    {inputValue: '1', boxLabel: '<t:message code="system.label.common.codeinorder" default="코드순"/>', name: 'RDO', checked: t1},
	                                {inputValue: '2', boxLabel: '<t:message code="system.label.common.nameinorder" default="이름순"/>',  name: 'RDO', checked: t2} ]
	               }                  
	               
	        ]
	
	});  

/**
 * Master Grid 정의(Grid Panel)
 * @type 
 */
	 var masterGridConfig = {
		store: Unilite.createStore('${PKGNAME}.CreditCard2Store',{
						model: '${PKGNAME}CreditCard2PopupModel',
				        autoLoad: false,
				        proxy: {
				            type: 'direct',
				            api: {
				            	read: 'popupService.creditCard2'
				            }
				        }
				}),
		
        uniOpt:{
//            useRowNumberer: false,
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
	    columns:  [        
	           		 { dataIndex: 'CRDT_NUM' 			,width: 80  }  
					,{ dataIndex: 'CRDT_NAME' 			,width: 100 }  
					,{ dataIndex: 'CRDT_FULL_NUM' 		,width: 140 }  
					,{ dataIndex: 'BANK_CODE' 			,width: 80  }  
					,{ dataIndex: 'BANK_NAME' 			,width: 80  }  
					,{ dataIndex: 'ACCOUNT_NUM' 		,width: 120 }  
					,{ dataIndex: 'SET_DATE' 			,width: 80  }  
					,{ dataIndex: 'PERSON_NAME'		 	,width: 80  }  
					,{ dataIndex: 'CRDT_COMP_CD' 		,width: 100 }  
					,{ dataIndex: 'CRDT_COMP_NM'		 ,width: 150}  
			
					,{ dataIndex: 'INSERT_DB_TIME' 		,width: 120, hidden: true }  
					,{ dataIndex: 'INSERT_DB_USER' 		,width: 120, hidden: true }  
					,{ dataIndex: 'UPDATE_DB_TIME' 		,width: 120, hidden: true }  
					,{ dataIndex: 'UPDATE_DB_USER' 		,width: 120, hidden: true }  

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
	    };
	    if(Ext.isDefined(wParam)) {		
			 if(wParam['SELMODEL'] == 'MULTI') {
			  masterGridConfig.selModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : false });
			 }
		 }
		 me.masterGrid = Unilite.createGrid('', masterGridConfig);
		 
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
		var frm= me.panelSearch;
//		var rdo = frm.findField('rdoRadio');
//		
//		var fieldTxt = frm.findField('TXT_SEARCH');
//		frm.setValues(param);
		
		if(param['CRDT_NUM']  && param['CRDT_NUM']!='')		frm.setValue('TXT_SEARCH', param['CRDT_NUM']);
		if(param['CRDT_NAME'] && param['CRDT_NAME']!='')	frm.setValue('TXT_SEARCH', param['CRDT_NAME']);
		
		/*if( Ext.isDefined(param)) {
			frm.setValues(param);
			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
				if(param['TYPE'] == 'VALUE') {
					fieldTxt.setValue(param['CRDT_NUM']);						
					rdo.setValue('1');
				} else {
					fieldTxt.setValue(param['CRDT_NAME']);
					rdo.setValue('2');
				}
			}
		}*/
		
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        var me = this;
		var selectRecords = me.masterGrid.getSelectedRecords();
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
	_dataLoad : function() {
		var me = this;
		if(me.panelSearch.isValid())	{
			var param= me.panelSearch.getValues();		
			me.isLoading = true;
			me.masterGrid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
		}
	}
});

