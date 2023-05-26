<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.MoneyUnitPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	


	 Unilite.defineModel('${PKGNAME}.MoneyUnitPopupModel', {
	    fields: [{name: 'MONEY_UNIT' 	,text:'<t:message code="system.label.common.bankbookcode" default="통장코드"/>' 		,type:'string'	},
	    	{name: 'COUNTRY_CODE' 	,text:'<t:message code="system.label.common.countrycode" default="국가코드"/>' 		,type:'string'	},
			{name: 'COUNTRY_NAME'	,text:'<t:message code="system.label.common.nationname" default="국가명"/>' 		,type:'string'	}
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
//                    xtype: 'radiogroup', width: 280,  
//                    items:[ {inputValue: '1', boxLabel:'통화코드순', name: 'RDO', checked: true, width: 100},
//                            {inputValue: '2', boxLabel:'국가명순',  name: 'RDO'/*, checked: t2*/} ]
//                 }
                 ,{ xtype: 'uniTextfield',      name:'ACCNT', hidden: true}
                 ,{ xtype: 'uniTextfield',      name:'DIV_CODE', hidden: true}
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.moneyUnitPopupStore',{
							model: '${PKGNAME}.MoneyUnitPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.moneyUnitPopup'
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
	                     { dataIndex: 'MONEY_UNIT'			,  width: 80 }
	                    ,{ dataIndex: 'COUNTRY_CODE' 	,  width: 180 }
	                    ,{ dataIndex: 'COUNTRY_NAME' 	,  minWidth: 230, flex: 1 }
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
        	if(!Ext.isEmpty(param['MONEY_UNIT'])){
        		fieldTxt.setValue(param['MONEY_UNIT']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['MONEY_UNIT'])){
        		fieldTxt.setValue(param['MONEY_UNIT']);        	
        	}
        	if(!Ext.isEmpty(param['MONEY_UNIT'])){
        		fieldTxt.setValue(param['MONEY_UNIT']);
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
//				fieldTxt.setValue(param['MONEY_UNIT']);
//				rdo.setValue({ RDO : '1'});
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

