<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.PurchaseCardPopup");
%>

	 Unilite.defineModel('${PKGNAME}.PurchaseCardPopupModel', {
	    fields: [{name: 'PURCHASE_CARD_NUM' 	,text:'<t:message code="system.label.common.purchasecardnum" default="구매카드번호"/>' 	,type:'string'	},
				 {name: 'PURCHASE_CARD_NAME'		,text:'<t:message code="system.label.common.purchasecardname" default="구매카드명"/>'	 	,type:'string'	}
			]
	});

Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    constructor : function(config) {
    var me = this;
    if (config) {
        Ext.apply(me, config);
    }
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
        items: [ 
        		 { xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',
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
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.purchasePopupStore',{
							model: '${PKGNAME}.PurchaseCardPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.purchaseCardPopup'
					            }
					        }
					}),
	        uniOpt:{
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
                 { dataIndex: 'PURCHASE_CARD_NUM' 		,  width: 110 },
                 { dataIndex: 'PURCHASE_CARD_NAME'		,  width: 120	, minWidth: 80, flex: 1 } 
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
    	if(!Ext.isEmpty(param['PURCHASE_CARD_NUM'])){
    		fieldTxt.setValue(param['PURCHASE_CARD_NUM']);        	
    	}
    	if(!Ext.isEmpty(param['PURCHASE_CARD_NAME'])){
    		fieldTxt.setValue(param['PURCHASE_CARD_NAME']);
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

