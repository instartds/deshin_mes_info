<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 회계부서(cbm600t) 팝업
request.setAttribute("PKGNAME","Unilite.app.popup.CostPoolCbm600tPopup");
%>

	/**
	 *   Model 정의
	 * @type
	 */
Unilite.defineModel('${PKGNAME}.CostPoolCbm600tPopupModel', {
    extend: 'Ext.data.Model',
    fields: [ 	 {name: 'COST_POOL_CODE' 		,text:'<t:message code="system.label.common.costpoolcode" default="회계부서코드"/>' 	,type:'string'	}
				,{name: 'COST_POOL_NAME' 		,text:'<t:message code="system.label.common.costpoolname" default="회계부서명"/>' 	,type:'string'	}
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
		    xtype: 'uniSearchForm',
		    layout : {type : 'table', columns :2, tableAttrs: {
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
                    }]
		});

		/**
		 * Master Grid 정의(Grid Panel)
		 * @type
		 */
		me.masterGrid = Unilite.createGrid('', {
			store: Unilite.createStoreSimple('${PKGNAME}.costPoolCbm600tPopupMasterStore',{
							model: '${PKGNAME}.CostPoolCbm600tPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.costPoolCbm600tPopup'
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
		           		 { dataIndex: 'COST_POOL_CODE'		,width: 140 }
						,{ dataIndex: 'COST_POOL_NAME'		,minWidth: 200, flex: 1 }
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
	fnInitBinding : function() {
		var param = this.param;
		var me = this;
		var frm= me.panelSearch.getForm();
		var fieldTxt = frm.findField('TXT_SEARCH');
		var frm= me.panelSearch.getForm();
		var fieldTxt = frm.findField('TXT_SEARCH');
		me.panelSearch.setValues(param);
		if(param['TYPE'] == 'VALUE') {

        	if(!Ext.isEmpty(param['COST_POOL_CODE'])){
        		fieldTxt.setValue(param['COST_POOL_CODE']);
        	}
        }else{

        	if(!Ext.isEmpty(param['COST_POOL_CODE'])){
        		fieldTxt.setValue(param['COST_POOL_CODE']);
        	}
        	if(!Ext.isEmpty(param['COST_POOL_NAME'])){
        		fieldTxt.setValue(param['COST_POOL_NAME']);
        	}
        }

//		var me = this;
//		var frm= me.panelSearch;
//		if(param['TYPE'] == 'VALUE')	{
//			frm.setValue('TXT_SEARCH', param['BANK_CODE']);
//		}else {
//			frm.setValue('TXT_SEARCH', param['BANK_NAME']);
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

