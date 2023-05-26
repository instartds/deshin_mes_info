<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.ForeignAccntsPopup");
%>
<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	
	Unilite.defineModel('${PKGNAME}.ForeignAccntsPopupModel', {
	    fields: [{name: 'ACCNT' 			,text:'<t:message code="system.label.common.foreigncurrencyaccnt" default="외화계정코드"/>' 	,type:'string'	},
				 {name: 'ACCNT_NAME' 		,text:'<t:message code="system.label.common.foreigncurrencyaccntname" default="외화계정명"/>' 		,type:'string'	}
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
	        items: [  { fieldLabel: '사용유무',		name:'USE_YN', hidden:true}
	                 ,{ xtype: 'uniTextfield', 		fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
	                 ,{ xtype: 'uniTextfield',      name:'ADD_QUERY', hidden: true}
	                 ,{ xtype: 'uniTextfield',      name:'ADD_QUERY2', hidden: true}
	                 ,{ xtype: 'uniTextfield',      name:'CHARGE_CODE', hidden: true}
	                
	        ]
	    });                
	    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
	        store: Unilite.createStoreSimple('${PKGNAME}.custPopupStore',{
				model: '${PKGNAME}.ForeignAccntsPopupModel',
		        autoLoad: false,
		        proxy: {
		            type: 'direct',
		            api: {
		            	read: 'popupService.foreignAccntPopup'
		            }
		        }
			}),
	        uniOpt:{
	             expandLastColumn	: false,
	             useRowNumberer		: false,
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
	             { dataIndex: 'ACCNT'		,  width: 150 }
	            ,{ dataIndex: 'ACCNT_NAME'	,  minWidth: 200, flex: 1 }	            
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
        	if(!Ext.isEmpty(param['ACCNT'])){
        		fieldTxt.setValue(param['ACCNT']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['ACCNT'])){
        		fieldTxt.setValue(param['ACCNT']);        	
        	}
        	if(!Ext.isEmpty(param['ACCNT_NAME'])){
        		fieldTxt.setValue(param['ACCNT_NAME']);
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

