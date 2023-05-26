<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 소속지점 팝업
request.setAttribute("PKGNAME","Unilite.app.popup.BussOfficeCode");
%>



	/**
	 *   Model 정의 
	 * @type 
	 */
Unilite.defineModel('${PKGNAME}.BussOfficeCodeModel', {  
    fields: [ 	 {name: 'BUSS_OFFICE_NAME' 		,text:'<t:message code="system.label.common.bussofficename" default="지점명"/>' 		,type:'string'	}
				,{name: 'BUSS_OFFICE_CODE' 		,text:'<t:message code="system.label.common.bussofficecode" default="지점코드"/>' 		,type:'string'	}
				,{name: 'LOCAL_TAX_GOVNM' 		,text:'<t:message code="system.label.common.localtaxgovnm" default="관할관청"/>' 		,type:'string'	}
				,{name: 'BUSS_OFFICE_ADDR' 		,text:'<t:message code="system.label.common.bussofficeaddress" default="지점주소"/>' 		,type:'string'	}
				,{name: 'SECT_NAME' 			,text:'<t:message code="system.label.common.division" default="사업장"/>' 		,type:'string'	}
				,{name: 'LOCAL_TAX_GOV' 		,text:'<t:message code="system.label.common.localtaxgov" default="주민세관할관청"/> ' 	,type:'string'	}
				,{name: 'SECT_CODE' 			,text:'<t:message code="system.label.common.divisioncode" default="사업장코드"/>' 		,type:'string'	}
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
		    		 { fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',  xtype: 'uniTextfield',
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }]
		});  
		
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		me.masterGrid =  Unilite.createGrid('', {
			store: Unilite.createStoreSimple('${PKGNAME}.bussOfficeCodeMasterStore',{
							model: '${PKGNAME}.BussOfficeCodeModel',
					        autoLoad: true,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.bussOfficeCode'
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
		    columns:  [  {dataIndex: 'BUSS_OFFICE_NAME' 		,width:100	}
						,{dataIndex: 'BUSS_OFFICE_CODE' 		,width:100	}
						,{dataIndex: 'LOCAL_TAX_GOVNM' 			,width:100	}
						,{dataIndex: 'BUSS_OFFICE_ADDR' 		,width:200	}
						,{dataIndex: 'SECT_NAME' 				,width:100	}
						,{dataIndex: 'LOCAL_TAX_GOV' 			,width:100	, hidden: true}
						,{dataIndex: 'SECT_CODE' 				,width:90	, hidden: true}			
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
        	if(!Ext.isEmpty(param['BUSS_OFFICE_CODE'])){
        		fieldTxt.setValue(param['BUSS_OFFICE_CODE']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['BUSS_OFFICE_CODE'])){
        		fieldTxt.setValue(param['BUSS_OFFICE_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['BUSS_OFFICE_NAME'])){
        		fieldTxt.setValue(param['BUSS_OFFICE_NAME']);
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

