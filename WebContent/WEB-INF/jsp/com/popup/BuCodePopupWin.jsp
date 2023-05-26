<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 부표팝업
request.setAttribute("PKGNAME","Unilite.app.popup.BuCodePopup");
%>



	/**
	 *   Model 정의 
	 * @type 
	 */
Unilite.defineModel('${PKGNAME}.BuCodePopupModel', {  
    fields: [ 	 {name: 'TAX_CODE' 				,text:'<t:message code="system.label.common.taxcode" default="원천징수코드"/>' 	,type:'string'	}
				,{name: 'TAX_CODE_NAME' 		,text:'<t:message code="system.label.common.codename" default="코드명"/>' 		,type:'string'	}
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
	    /*var wParam = this.param;
	    var t1= false, t2 = false;
	    if( Ext.isDefined(wParam)) {
	        if(wParam['TYPE'] == 'VALUE') {
	            t1 = true;
	            t2 = false;
	            
	        } else {
	            t1 = false;
	            t2 = true;
	            
	        }
	    }*/


		me.panelSearch =  Unilite.createSearchForm('',{
		    layout : {type : 'table', columns : 2, tableAttrs: {
		        style: {
		            width: '100%'
		        }
		    }},
		    items: [ 
		    		  { fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',      name:'TXT_SEARCH',  xtype: 'uniTextfield',
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
		    		 ,{ fieldLabel: 'PARAM1',     name:'gaPopUp1',  xtype: 'uniTextfield', hidden:true }
		    		 ,{ fieldLabel: 'PARAM2',     name:'gaPopUp2',  xtype: 'uniTextfield', hidden:true }
		    		 ,{ fieldLabel: 'PARAM3',     name:'gaPopUp3',  xtype: 'uniTextfield', hidden:true }
		    		 ,{ fieldLabel: 'PARAM4',     name:'gaPopUp4',  xtype: 'uniTextfield', hidden:true }
		    		 ,{ fieldLabel: 'PARAM5',     name:'gaPopUp5',  xtype: 'uniTextfield', hidden:true }
		    		 ]
		});  
		
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		me.masterGrid =  Unilite.createGrid('', {
			store: Unilite.createStoreSimple('${PKGNAME}.buCodePopupMasterStore',{
							model: '${PKGNAME}.BuCodePopupModel',
					        autoLoad: true,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.buCodePopup'
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
		    columns:  [  {dataIndex: 'TAX_CODE' 			,flex:1	}
						,{dataIndex: 'TAX_CODE_NAME' 		,flex:4	}
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
		var fieldTxt = frm.findField('TXT_SEARCH');
		var frm= me.panelSearch.getForm();
		var fieldTxt = frm.findField('TXT_SEARCH');
		me.panelSearch.setValues(param);
		if(param['TYPE'] == 'VALUE') {
        	if(!Ext.isEmpty(param['BU_CODE'])){
        		fieldTxt.setValue(param['BU_NAME']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['BU_CODE'])){
        		fieldTxt.setValue(param['BU_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['BU_NAME'])){
        		fieldTxt.setValue(param['BU_NAME']);
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

