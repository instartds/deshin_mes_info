<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.ShopPopup");
%>

/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.ShopPopupModel', {
    fields: [
   	 	{name: 'DIV_CODE' 					, text: '<t:message code="system.label.common.divisioncode" default="사업장코드"/>' 			, type: 'string'},
    	{name: 'SHOP_CODE'				, text: '<t:message code="system.label.common.shopcode" default="매장코드"/>'				, type: 'string'},
	    {name: 'SHOP_NAME'				, text: '<t:message code="system.label.common.shopname" default="매장명"/>'				, type: 'string'},
		{name: 'WH_CODE'					, text: '<t:message code="system.label.common.mainwarehouse" default="주창고"/>'				, type: 'string', store: Ext.data.StoreManager.lookup('whList'), allowBlank: false},
	    {name: 'BRAND_CODE'				, text: '<t:message code="system.label.common.brandcode" default="브랜드"/>(<t:message code="system.label.common.class" default="분류"/>)'			, type: 'string', comboType:'AU', comboCode:'YP07'},
		{name: 'DEPT_CODE'					, text: '<t:message code="system.label.common.department" default="부서"/>'				, type: 'string'},
	    {name: 'DEPT_NAME'				, text: '<t:message code="system.label.common.departmentname" default="부서명"/>'				, type: 'string'},
		{name: 'STAFF_ID'						, text: '<t:message code="system.label.common.charger" default="담당자"/>'				, type: 'string', comboType: 'AU', comboCode: 'B024'},
		{name: 'PHONE_NUMBER'		, text: '<t:message code="system.label.common.telephone" default="전화번호"/>'				, type: 'string'}
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
	    
	    me.panelSearch =  Unilite.createSearchForm('',{
		    layout : {type : 'table', columns : 1, tableAttrs: {
		        style: {
		            width: '100%'
		        }
		    }},
		    items: [ { fieldLabel: '<t:message code="system.label.common.searchword" default="검색어"/>', 	name:'SHOP_NAME',
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
			store: Unilite.createStore('${PKGNAME}.shopPopupMasterStore',{
							model: '${PKGNAME}.ShopPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'uniDirect',
					            api: {
					            	read: 'popupService.shopPopup'
					            }
					        }
					        ,
					        saveStore : function(config)	{				
									var inValidRecs = this.getInvalidRecords();
									if(inValidRecs.length == 0 )	{
										//this.syncAll(config);
										this.syncAllDirect(config);
									}else {
										alert(Msg.sMB083);
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
		           	{dataIndex : 'DIV_CODE' 		, width : 80, hidden: true}, 
	            	{dataIndex : 'SHOP_CODE'		, width : 100}, 		
	            	{dataIndex : 'SHOP_NAME'		, width : 170}, 		
	            	{dataIndex : 'WH_CODE'		 	, width : 120}, 		
	            	{dataIndex : 'BRAND_CODE'		, width : 90}, 		
	            	{dataIndex : 'DEPT_CODE'		, width : 100}, 		
	            	{dataIndex : 'DEPT_NAME'		, width : 170}, 		
	            	{dataIndex : 'STAFF_ID'		 	, width : 80}, 		
	            	{dataIndex : 'PHONE_NUMBER' 	, width : 115}
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
		    config.items = [me.panelSearch, me.masterGrid];
		    me.callParent(arguments);
	    },
		initComponent : function(){    
	    	var me  = this;
	        me.masterGrid.focus();
	        this.callParent();    	
	    },    
		fnInitBinding : function(param) {
			var me = this;
			me.param = param;
			var frm= me.panelSearch.getForm();
			var fieldTxt = frm.findField('SHOP_NAME');
			
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
