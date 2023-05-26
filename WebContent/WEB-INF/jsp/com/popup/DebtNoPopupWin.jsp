<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.DebtNoPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	


	 Unilite.defineModel('${PKGNAME}.DebtNoPopupModel', {
	    fields: [{name: 'DEBT_NO_CODE' 	,text:'<t:message code="system.label.common.borrowingcode" default="차입번호"/>' 	,type:'string'	},
				 {name: 'DEBT_NO_NAME'		,text:'<t:message code="system.label.common.borrowingname" default="차입명"/>' 	,type:'string'	},
				 {name: 'CUSTOM_CODE' 		,text:'<t:message code="system.label.common.borrowercode" default="차입처코드"/>' 	,type:'string'	},
				 {name: 'CUSTOM_NAME' 		,text:'<t:message code="system.label.common.borrowername" default="차입처명"/>' 	,type:'string'	},
				 {name: 'LOAN_GUBUN' 			,text:'<t:message code="system.label.common.borrowingtype" default="차입구분"/>' 	,type:'string'	},
				 {name: 'PUB_DATE' 					,text:'<t:message code="system.label.common.borrowingdate" default="차입일"/>' 	,type:'uniDate'	},
				 {name: 'EXP_DATE' 					,text:'<t:message code="system.label.common.duedate" default="만기일"/>' 	,type:'uniDate'	},
				 {name: 'AMT_I' 							,text:'<t:message code="system.label.common.borrowingamt" default="차입원화"/>' 	,type:'uniPrice'	},
				 {name: 'FOR_AMT_I' 				,text:'<t:message code="system.label.common.borrowingforamt" default="차입외화"/>' 	,type:'uniFC'	},
				 {name: 'MONEY_UNIT' 			,text:'<t:message code="system.label.common.currency" default="화폐 "/>'	 	,type:'string'	},
				 {name: 'REMARK' 						,text:'<t:message code="system.label.common.remark" default="적요"/>' 		,type:'string'	}
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
        items: [{
			fieldLabel: '<t:message code="system.label.common.duedate" default="만기일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'EXP_DATE_FR',
			endFieldName: 'EXP_DATE_TO'
		},
			Unilite.popup('ACCNTS',{
	    	fieldLabel: '<t:message code="system.label.common.accountitem" default="계정과목"/>',  			
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
						panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelResult.setValue('ACCNT_CODE', '');
					panelResult.setValue('ACCNT_NAME', '');
				}
			}
	    }),
		    Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="system.label.common.borrower" default="차입처"/>'
		}),{
			fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>'  ,
			name: 'DIV_CODE',
			xtype:'uniCombobox',
			comboType:'BOR120',
			holdable: 'hold'
		}, {
			fieldLabel: '<t:message code="system.label.common.borrowingcode" default="차입번호"/>',
			xtype: 'uniTextfield',
			name: 'LOANNO'	
		}, {
			fieldLabel: '<t:message code="system.label.common.borrowingname" default="차입명"/>',
			xtype: 'uniTextfield',
			name: 'LOAN_NAME'			
		},{ xtype: 'uniTextfield',
			fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',
			name:'TXT_SEARCH',
            listeners:{
                specialkey: function(field, e){
                    if (e.getKey() == e.ENTER) {
                       me.onQueryButtonDown();
                    }
                }
            }
        }
		/*, { 
			fieldLabel: ' ', 
            xtype: 'radiogroup', width: 230,  
            items:[ {inputValue: '1', boxLabel:'코드순', name: 'RDO', checked: t1},
                    {inputValue: '2', boxLabel:'이름순',  name: 'RDO', checked: t2} ]
         }*/
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.debtNoPopupStore',{
							model: '${PKGNAME}.DebtNoPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.debtNoPopup'
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
	                     { dataIndex: 'DEBT_NO_CODE' 	,  width: 120 }
	                    ,{ dataIndex: 'DEBT_NO_NAME'	,  width: 120 }
	                    ,{ dataIndex: 'CUSTOM_CODE' 	,  width: 80 }
	                    ,{ dataIndex: 'CUSTOM_NAME' 	,  width: 120 }
	                    ,{ dataIndex: 'LOAN_GUBUN' 		,  width: 90 }
	                    ,{ dataIndex: 'PUB_DATE' 		,  width: 90 }
	                    ,{ dataIndex: 'EXP_DATE' 		,  width: 90 }
	                    ,{ dataIndex: 'AMT_I' 			,  width: 80 }
	                    ,{ dataIndex: 'FOR_AMT_I' 		,  width: 80 }
	                    ,{ dataIndex: 'MONEY_UNIT' 		,  width: 80 }
	                    ,{ dataIndex: 'REMARK' 			,  minWidth: 80, flex: 1 }
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
        	if(!Ext.isEmpty(param['DEBT_NO_CODE'])){
        		fieldTxt.setValue(param['DEBT_NO_CODE']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['MANAGE_CODE'])){
        		fieldTxt.setValue(param['MANAGE_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['DEBT_NO_NAME'])){
        		fieldTxt.setValue(param['DEBT_NO_NAME']);
        	}
        }
//        var me = this;
//		
//		var frm= me.panelSearch.getForm();
//		
//		var rdo = frm.findField('RDO');
////		var fieldTxt = frm.findField('TXT_SEARCH');
//
//		if( Ext.isDefined(param)) {
////			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
////				if(param['TYPE'] == 'VALUE') {
////					fieldTxt.setValue(param['DEBT_NO_CODE']);
//					rdo.setValue({ RDO : '1'});
////				} else {
////					fieldTxt.setValue(param['DEBT_NO_NAME']);
////					rdo.setValue({ RDO : '2'});
////				}
////			}
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

