<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.HsPopup");
%>

/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.HsPopupModel', {
    fields: [
   	 	{name: 'COMP_CODE'			, text:'<t:message code="system.label.common.companycode" default="법인코드"/>' 			, type: 'string'},
   	 	{name: 'HS_NO'						, text:'<t:message code="system.label.common.hsno" default="HS번호"/>'				, type: 'string'},				 
		{name: 'HS_NAME'				, text:'<t:message code="system.label.common.hsname" default="HS명"/>'		   		, type: 'string'},				 
		{name: 'HS_SPEC'					, text:'<t:message code="system.label.common.hsspec" default="HS규격"/>'				, type: 'string'},				 
		{name: 'HS_UNIT'					, text:'<t:message code="system.label.common.hsunit" default="HS단위"/>'				, type: 'string', 	comboType: 'AU',comboCode:'B013', displayField: 'value'}
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
		    layout : {type : 'table', columns : 3, tableAttrs: {
		        style: {
		            width: '100%'
		        }
		    }},
		    items : [{
		                fieldLabel: '<t:message code="system.label.common.hsno" default="HS번호"/>',
		                name:'HS_NO',   
		                xtype: 'uniTextfield',
		                holdable: 'hold'
		                
		            },
		            {
		                fieldLabel: '<t:message code="system.label.common.hsname" default="HS명"/>',
		                name:'HS_NAME',   
		                xtype: 'uniTextfield',
		                holdable: 'hold'
		                
		            }
                ]
		}); 
/**
 * Master Grid 정의(Grid Panel)
 * @type 
 */
		 me.masterGrid = Unilite.createGrid('', {
			store: Unilite.createStore('${PKGNAME}.hsPopupMasterStore',{
							model: '${PKGNAME}.HsPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'uniDirect',
					            api: {
					            	read: 'popupService.hsPopup'
					            }
					        }
					        /*,
					        saveStore : function(config)	{				
									var inValidRecs = this.getInvalidRecords();
									if(inValidRecs.length == 0 )	{
										//this.syncAll(config);
										this.syncAllDirect(config);
									}else {
										alert(Msg.sMB083);
									}
							}*/
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
		    columns: [
                	{dataIndex: 'HS_NO'     	,       width: 126},                   
                    {dataIndex: 'HS_NAME'     	,       width: 346},                      
                    {dataIndex: 'HS_SPEC'     	,       width: 166},                    
                    {dataIndex: 'HS_UNIT'      	,       width: 80, align: 'center'}
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
			
			//var fieldTxt = frm.findField('lot_NAME');
			me.panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			me.panelSearch.setValue('HS_NO', param.HS_NO);
			me.panelSearch.setValue('HS_NAME', param.HS_NAME);
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
