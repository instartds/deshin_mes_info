<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 세무서 팜업
request.setAttribute("PKGNAME","Unilite.app.popup.SafferTaxPopup");
%>


/**
 *   Model 정의 
 * @type 
 */
 Unilite.defineModel('${PKGNAME}.SafferTaxPopupModel', {
    fields: [ 	 {name: 'SUB_CODE' 		,text:'<t:message code="system.label.common.taxofficecode" default="세무서코드"/>' 	,type:'string'	}
				,{name: 'CODE_NAME' 		,text:'<t:message code="system.label.common.taxofficename" default="세무서명"/>' 	,type:'string'	}
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
		me.panelSearch = Unilite.createSearchForm('',{			    
		    layout : {type : 'table', columns : 1, tableAttrs: {
		        style: {
		            width: '100%'
		        }
		    }},
		    width:'100%',
		    items: [ { fieldLabel: '<t:message code="system.label.common.searchword" default="검색어"/>', 	name:'TXT_SEARCH',
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    } ]
		});
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		me.masterGrid = Unilite.createGrid('', {
			store: Unilite.createStoreSimple('${PKGNAME}.safferTaxPopupMasterStore',{
							model: '${PKGNAME}.SafferTaxPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.safferTaxPopup'
					            }
					        }
					}),
			uniOpt:{
				useRowNumberer:false,
		    	expandLastColumn: false,
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
		           		 { dataIndex: 'SUB_CODE'		,width: 140 }  
						,{ dataIndex: 'CODE_NAME'		,width: 140 } 
						
				
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
		var frm= me.panelSearch

		if(param['TYPE'] == 'VALUE')	{
			frm.setValue('TXT_SEARCH', param['SUB_CODE']);
		}else {
			frm.setValue('TXT_SEARCH', param['CODE_NAME']);
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
