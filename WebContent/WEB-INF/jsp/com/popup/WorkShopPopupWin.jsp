<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 작업장 팜업
request.setAttribute("PKGNAME","Unilite.app.popup.WorkShopPopup");
%>


	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />				// 사업장 



/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}.WorkShopPopupModel', {
    fields: [ 	 {name: 'COMP_CODE' 		,text:'<t:message code="system.label.common.companycode" default="법인코드"/>' 				,type:'string'	}
    			,{name: 'TYPE_LEVEL' 		,text:'<t:message code="system.label.common.division" default="사업장"/>' 				,type:'string', xtype: 'uniCombobox', comboType: 'BOR120'	}
    			,{name: 'TREE_CODE' 		,text:'<t:message code="system.label.common.workcentercode" default="작업장코드"/>' 				,type:'string'	}
    			,{name: 'TREE_NAME' 		,text:'<t:message code="system.label.common.workcenter" default="작업장"/>' 				,type:'string'	}
    			,{name: 'SECTION_CD' 		,text:'<t:message code="system.label.common.businessdivisionname" default="사업부"/>' 				,type:'string'	}
    			,{name: 'SHIFT_CD' 			,text:'<t:message code="system.label.common.shiftcode" default="작업조코드"/>' 			,type:'string'	}
    			,{name: 'WH_CODE' 			,text:'<t:message code="system.label.common.warehouse" default="창고"/>' 					,type:'string'	}
    			,{name: 'WH_CELL_CODE'		,text:'<t:message code="system.label.common.warehouse" default="창고"/>CELL' 				,type:'string'	}
    			,{name: 'USE_YN' 					,text:'<t:message code="system.label.common.useyn" default="사용여부"/>' 				,type:'string'	}
    			,{name: 'STANDARD_TIME'		,text:'<t:message code="system.label.common.workcenterstandardtime" default="작업장표준시간"/>' 			,type:'uniDate'	}
    			,{name: 'USER_ID' 			,text:'<t:message code="system.label.common.user" default="사용자"/>ID' 				,type:'string'	}
    			,{name: 'INSERT_DB_TIME' 	,text:'INSERT_DB_TIME' 		,type:'uniDate'	}
    			,{name: 'INSERT_DB_USER' 	,text:'INSERT_DB_USER' 		,type:'string'	}
    			,{name: 'UPDATE_DB_TIME' 	,text:'UPDATE_DB_TIME' 		,type:'uniDate'	}
    			,{name: 'UPDATE_DB_USER' 	,text:'UPDATE_DB_USER' 		,type:'string'	}
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
	me.panelSearch = Unilite.createSearchForm('',{
	    layout : {type : 'uniTable', columns : 2, tableAttrs: {
	        style: {
	            width: '100%'
	        }
	    }},
	    items: [ { fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>' ,  	name: 'TYPE_LEVEL'  	, xtype: 'uniCombobox', comboType:'BOR120', readOnly: true }
	            ,{ fieldLabel: '<t:message code="system.label.common.searchword" default="검색어"/>',   	name: 'TXT_SEARCH' 		, xtype: 'uniTextfield' ,
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
	            ,{ fieldLabel: '<t:message code="system.label.common.workcentercode" default="작업장코드"/>',   name: 'TREE_CODE' 		, xtype: 'uniTextfield', hidden: true }
	            ,{ fieldLabel: '<t:message code="system.label.common.workcenter" default="작업장"/>',   	name: 'TREE_NAME' 		, xtype: 'uniTextfield', hidden: true }
	                          
	               
	        ]
	
	});  

/**
 * Master Grid 정의(Grid Panel)
 * @type 
 */
	 var masterGridConfig = {
		store: Unilite.createStore('${PKGNAME}.workShopPopupMasterStore',{
						model: '${PKGNAME}.WorkShopPopupModel',
				        autoLoad: true,
				        proxy: {
				            type: 'direct',
				            api: {
				            	read: 'popupService.workShopPopup'
				            }
				        }
				}),
		
        uniOpt:{
//            useRowNumberer: false,
            onLoadSelectFirst : false,
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
	           		 { dataIndex: 'COMP_CODE' 	 		,width: 120, hidden: true }  
					,{ dataIndex: 'TYPE_LEVEL' 	 		,width: 120, hidden: true }  
					,{ dataIndex: 'TREE_CODE' 	 		,width: 120 }  
					,{ dataIndex: 'TREE_NAME' 	 		,width: 400 }  
					,{ dataIndex: 'SECTION_CD' 	 		,width: 120, hidden: true }  
					,{ dataIndex: 'SHIFT_CD' 		 	,width: 120, hidden: true }  
					,{ dataIndex: 'WH_CODE' 		 	,width: 120, hidden: true }  
					,{ dataIndex: 'WH_CELL_CODE'	 	,width: 120, hidden: true }  
					,{ dataIndex: 'USE_YN' 		 		,width: 120, hidden: true }  
					,{ dataIndex: 'STANDARD_TIME'	 	,width: 120, hidden: true }  
					,{ dataIndex: 'USER_ID' 		 	,width: 120, hidden: true }  
					,{ dataIndex: 'INSERT_DB_TIME' 		,width: 120, hidden: true }  
					,{ dataIndex: 'INSERT_DB_USER' 		,width: 120, hidden: true }  
					,{ dataIndex: 'UPDATE_DB_TIME' 		,width: 120, hidden: true }  
					,{ dataIndex: 'UPDATE_DB_USER' 		,width: 120, hidden: true }   					
			
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
	    };
	    if(Ext.isDefined(wParam)) {		
			 if(wParam['SELMODEL'] == 'MULTI') {
			  masterGridConfig.selModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : false });
			 }
		 }
		 me.masterGrid = Unilite.createGrid('', masterGridConfig);
		 
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
		if(param['TYPE_LEVEL'] && param['TYPE_LEVEL']!='')	frm.setValue('TYPE_LEVEL',  param['TYPE_LEVEL']);
		/*if( Ext.isDefined(param)) {
			frm.setValues(param);
			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
				if(param['TYPE'] == 'VALUE') {
					fieldTxt.setValue(param['ITEM_CODE']);						
					rdo.setValue('1');
				} else {
					fieldTxt.setValue(param['ITEM_NAME']);
					rdo.setValue('2');
					fieldTxt.setFieldLabel('작업장명');
				}
			}
		}*/
		
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        var me = this;
		var selectRecords = me.masterGrid.getSelectedRecords();
		var rvRecs= new Array();
		Ext.each(selectRecords, function(record, i)	{
			rvRecs[i] = record.data;
		})
	 	var rv = {	
			status : "OK",
			data:rvRecs
		};
		me.returnData(rv);
	},
	_dataLoad : function() {
		var me = this;
		if(me.panelSearch.isValid())	{
			var param= me.panelSearch.getValues();		
			me.isLoading = true;
			me.masterGrid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
		}
	}
});

