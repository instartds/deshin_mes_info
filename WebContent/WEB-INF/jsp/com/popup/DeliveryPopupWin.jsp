<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.DeliveryPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	


	 Unilite.defineModel('${PKGNAME}.DeliveryPopupModel', {
	    fields: [{name: 'DELIVERY_CODE'     ,text:'<t:message code="system.label.common.deliveryplace" default="배송처"/>'  ,type:'string'  },
                 {name: 'DELIVERY_NAME'     	,text:'<t:message code="system.label.common.deliveryplace" default="배송처"/>'  ,type:'string'  },
                 {name: 'DVRY_CUST_PRSN'     ,text:'<t:message code="system.label.common.deliverycharger" default="배송처담당자"/>'  ,type:'string'  },
                 {name: 'DVRY_CUST_TEL'     	,text:'<t:message code="system.label.common.deliveryplacephoneno" default="배송처전화번호"/>'  ,type:'string'  },
                 {name: 'DVRY_CUST_ADD'      ,text:'<t:message code="system.label.sales.deliveryplaceaddress" default="배송처주소"/>'  ,type:'string'  }
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
        items: [  { fieldLabel: '<t:message code="system.label.common.useflag" default="사용유무"/>',		name:'USE_YN', hidden:true}
                 ,{ xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.customcode" default="거래처코드"/>',     name:'CUSTOM_CODE'}
                 ,{ xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',
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
            store: Unilite.createStoreSimple('${PKGNAME}.custPopupStore',{
							model: '${PKGNAME}.DeliveryPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.deliveryPopup'
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
	                     { dataIndex: 'DELIVERY_CODE'     ,  width: 100, hidden: true}
	                    ,{ dataIndex: 'DELIVERY_NAME'     ,	 width: 160}
	                    ,{ dataIndex: 'DVRY_CUST_PRSN'    ,  width: 100}
	                    ,{ dataIndex: 'DVRY_CUST_TEL'     ,  width: 100}
	                    ,{ dataIndex: 'DVRY_CUST_ADD'     ,  width: 100, flex: 1}
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
        	if(!Ext.isEmpty(param['DELIVERY_CODE'])){
        		fieldTxt.setValue(param['DELIVERY_CODE']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['DELIVERY_CODE'])){
        		fieldTxt.setValue(param['DELIVERY_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['DELIVERY_NAME'])){
        		fieldTxt.setValue(param['DELIVERY_NAME']);
        	}
        }
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

