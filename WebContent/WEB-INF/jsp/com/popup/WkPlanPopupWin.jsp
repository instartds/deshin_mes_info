<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 부서팝업
request.setAttribute("PKGNAME","Unilite.app.popup.DeptPopup");
%>



	/**
	 *   Model 정의 
	 * @type 
	 */
Unilite.defineModel('${PKGNAME}.DeptPopupModel', {
    extend: 'Ext.data.Model',
    fields: [ 	 {name: 'TREE_CODE' 		,text:'<t:message code="system.label.common.departmencode" default="부서코드"/>' 	,type:'string'	}
				,{name: 'TREE_NAME' 			,text:'<t:message code="system.label.common.departmentname" default="부서명"/>' 	,type:'string'	}
				,{name: 'DIV_CODE' 				,text:'<t:message code="system.label.common.division" default="사업장"/>' 	,type:'string'	}
				,{name: 'BILL_DIV_CODE' 		,text:'<t:message code="system.label.common.declaredivisioncode2" default="신고사업장코드"/>' 	,type:'string'	}
				,{name: 'BILL_DIV_NAME' 		,text:'<t:message code="system.label.common.declaredivisionname" default="신고사업장명"/>' 	,type:'string'	}
				,{name: 'SECTION_CODE' 		,text:'<t:message code="system.label.common.businessdivisioncode" default="사업부코드"/>' 	,type:'string'	}
				,{name: 'SECTION_NAME' 	,text:'<t:message code="system.label.common.businessdivisionname" default="사업부"/>' 	,type:'string'	}
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
		    layout : {type : 'table', columns : 1, tableAttrs: {
		        style: {
		            width: '100%'
		        }
		    }},
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
		me.masterGrid =  Unilite.createGrid('', {
			store: Unilite.createStoreSimple('${PKGNAME}.DeptPopupMasterStore',{
							model: '${PKGNAME}.DeptPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.deptPopup'
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
		    columns:  [        
		           		 { dataIndex: 'TREE_CODE'		,width: 140 }  
						,{ dataIndex: 'TREE_NAME'		,width: 140 } 			
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
		var frm= me.panelSearch;
		if(param['TREE_CODE'] && param['TREE_CODE']!='')	frm.setValue('TXT_SEARCH', param['TREE_CODE']);
		if(param['TREE_NAME'] && param['TREE_NAME']!='')	frm.setValue('TXT_SEARCH', param['TREE_NAME']);
		
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
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
