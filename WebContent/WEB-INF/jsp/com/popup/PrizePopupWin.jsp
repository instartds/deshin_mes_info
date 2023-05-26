<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 금융상품코드
request.setAttribute("PKGNAME","Unilite.app.popup.PrizePopup");
%>



	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('${PKGNAME}.PrizePopupModel', {  
	    fields: [ 	 {name: 'SUB_CODE' 		,text:'<t:message code="system.label.common.code" default="코드"/>' 		,type:'string'	}
					,{name: 'REF_CODE2' 		,text:'<t:message code="system.label.common.classfication" default="구분"/>' 		,type:'string'	}
	
				]
		});
		
	Unilite.defineModel('${PKGNAME}.PrizePopupModel2', {  
	    fields: [ 	 {name: 'REF_CODE2' 	,text:'<t:message code="system.label.common.middlegroup" default="중분류"/>' 		,type:'string'	}
					,{name: 'REF_CODE3' 		,text:'<t:message code="system.label.common.code" default="코드"/>' 			,type:'string'	}
					,{name: 'REF_CODE4' 		,text:'<t:message code="system.label.common.minorgroup" default="소분류"/>' 		,type:'string'	}
					,{name: 'REF_CODE5' 		,text:'<t:message code="system.label.common.code" default="코드"/>' 			,type:'string'	}
					,{name: 'SUB_CODE' 			,text:'<t:message code="system.label.common.prizecode" default="상품코드"/>' 		,type:'string'	}
					
	
				]
		});	

/**
 * 검색조건 (Search Panel)
 * @type 
 */
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    layout: {
        type: 'hbox',
        align: 'stretch'  // Child items are stretched to full width
    },
    constructor : function(config) {
        var me = this;
        if (config) {
            Ext.apply(me, config);
        }
        
        
        var wParam = this.param;
		var code   = wParam.PARAM_MAIN_CODE;
		var columns = [];
        var columns2 = [];
        
        if(code == 'HC04'){
        	columns =  [ {dataIndex: 'SUB_CODE' 	,flex : 0.5	, text :'<t:message code="system.label.common.code" default="코드"/>'}
						,{dataIndex: 'REF_CODE2' 	,flex : 0.5	, text :'<t:message code="system.label.common.classfication" default="구분"/>'}
			]			
		    columns2 = [ {dataIndex: 'REF_CODE2' 	,flex : 3	, text :'<t:message code="system.label.common.middlegroup" default="중분류"/>'}
						,{dataIndex: 'REF_CODE3' 	,flex : 1	, text :'<t:message code="system.label.common.code" default="코드"/>'}	
						,{dataIndex: 'REF_CODE4' 	,flex : 6	, text :'<t:message code="system.label.common.minorgroup" default="소분류"/>'}	
						,{dataIndex: 'REF_CODE5' 	,flex : 1	, text :'<t:message code="system.label.common.code" default="코드"/>'}	
						,{dataIndex: 'SUB_CODE' 	,flex : 1.4	, text :'<t:message code="system.label.common.prizecode" default="상품코드"/>'}	
			] 	
        }
        
        if(code == 'HC08'){
        	columns =  [ {dataIndex: 'REF_CODE2' 	,flex : 0.5	, text :'<t:message code="system.label.common.code" default="코드"/>'}
						,{dataIndex: 'REF_CODE3' 	,flex : 0.5	, text :'<t:message code="system.label.common.classfication" default="구분"/>'}
			]			
		    columns2 = [ {dataIndex: 'REF_CODE3' 	,flex : 4	, text :'<t:message code="system.label.common.interitem" default="금융상품"/>'}
						,{dataIndex: 'REF_CODE2' 	,flex : 1	, text :'<t:message code="system.label.common.prizecode" default="상품코드"/>'}	
			] 	
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
	            
	        
	    }*/


		me.panelSearch =  Unilite.createSearchForm('',{
		    layout : {type : 'table', columns : 2, tableAttrs: {
		        style: {
		            width: '100%'
		        }
		    }},
		    items: [ 
		    		 { fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',  xtype: 'uniTextfield' ,hidden:true},
		    		 { fieldLabel: '<t:message code="system.label.common.parammaincode" default="파라미터 공통코드"/>',  name:'PARAM_MAIN_CODE',  xtype: 'uniTextfield' ,hidden:true},
		    		 { fieldLabel: '<t:message code="system.label.common.incometype" default="소득구분"/>',  name:'DED_TYPE'		 ,  xtype: 'uniTextfield' ,hidden:true},
		    		 { fieldLabel: '<t:message code="system.label.common.incomekind" default="소득종류"/>',  name:'IN_COME_KIND'	,  xtype: 'uniTextfield' ,hidden:true} ]
		});  
		
		
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		me.masterGrid =  Unilite.createGrid('', {
			flex : 1,
			store: Unilite.createStoreSimple('${PKGNAME}.prizePopupMasterStore',{
							model: '${PKGNAME}.PrizePopupModel',
					        autoLoad: true,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.prizePopup'
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
		    columns: columns,
		    listeners: {
				/*onGridDblClick:function(grid, record, cellIndex, colName) {
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
				}*/
			}
		});
		
		/*
		 *  SubStore
		 * */
		me.masterGrid2 =  Unilite.createGrid('', {
			flex: 3,
			store: Unilite.createStoreSimple('${PKGNAME}.prizePopupMasterStore2',{
							model: '${PKGNAME}.PrizePopupModel2',
					        autoLoad: true,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.prizePopup2'
					            }
					        }
					}),
			selModel:'rowmodel',
			uniOpt:{
				pivot : {
					use : false
				}
			},
		    columns: columns2,
		    listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {
					var mainGrid = me.masterGrid.getSelectedRecord();
					var subGrid  = me.masterGrid2.getSelectedRecord();
					var sumPrizeCode = '';		
					if(me.panelSearch.getValue('PARAM_MAIN_CODE') == 'HC04'){			//2012 년 이전
						mainGrid = mainGrid.data['SUB_CODE'];
						subGrid  = subGrid.data['SUB_CODE'];
					}
					else if(me.panelSearch.getValue('PARAM_MAIN_CODE') == 'HC08'){		// 2012년 이후
						mainGrid = mainGrid.data['REF_CODE2'];
						subGrid  = subGrid.data['REF_CODE2'];
					}
					sumPrizeCode = mainGrid+subGrid;
					
					var rv = {
						status : "OK",
						data:[sumPrizeCode]
					};
					me.returnData(rv);
				},
				onGridKeyDown: function(grid, keyCode, e) {
					if(e.getKey() == Ext.EventObject.ENTER) {
						var mainGrid = me.masterGrid.getSelectedRecord();
						var subGrid  = me.masterGrid2.getSelectedRecord();
						var sumPrizeCode = '';		
						if(me.panelSearch.getValue('PARAM_MAIN_CODE') == 'HC04'){		//2012 년 이전
							mainGrid = mainGrid.data['SUB_CODE'];
							subGrid  = subGrid.data['SUB_CODE'];
						}
						else if(me.panelSearch.getValue('PARAM_MAIN_CODE') == 'HC08'){	// 2012년 이후
							mainGrid = mainGrid.data['REF_CODE2'];
							subGrid  = subGrid.data['REF_CODE2'];
						}
						sumPrizeCode = mainGrid+subGrid;
						
						var rv = {
							status : "OK",
							data:[sumPrizeCode]
						};
						me.returnData(rv);
					}
				}
		    }
		});
		
		config.items = [me.masterGrid, me.masterGrid2];
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
        	if(!Ext.isEmpty(param['SAUP_POPUP_CODE'])){
        		fieldTxt.setValue(param['SAUP_POPUP_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['IN_COME_KIND'])){
        		fieldTxt.setValue(param['IN_COME_KIND']);
        	}
        }else{
        	if(!Ext.isEmpty(param['SAUP_POPUP_CODE'])){
        		fieldTxt.setValue(param['SAUP_POPUP_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['SAUP_POPUP_NAME'])){
        		fieldTxt.setValue(param['SAUP_POPUP_NAME']);
        	}
        	if(!Ext.isEmpty(param['IN_COME_KIND'])){
        		fieldTxt.setValue(param['IN_COME_KIND']);
        	}
        }		
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        var me = this;
		var mainGrid = me.masterGrid.getSelectedRecord();
		var subGrid  = me.masterGrid2.getSelectedRecord();
		var sumPrizeCode = '';
	 	var rv ;
	 	
	 	if(me.panelSearch.getValue('PARAM_MAIN_CODE') == 'HC04'){		//2012 년 이전
			mainGrid = mainGrid.data['SUB_CODE'];
			subGrid  = subGrid.data['SUB_CODE'];
		}
		else if(me.panelSearch.getValue('PARAM_MAIN_CODE') == 'HC08'){	// 2012년 이후
			mainGrid = mainGrid.data['REF_CODE2'];
			subGrid  = subGrid.data['REF_CODE2'];
		}
		sumPrizeCode = mainGrid+subGrid;
	 	
		if(sumPrizeCode)	{
		 	rv = {
				status : "OK",
				data:[sumPrizeCode]
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
		me.masterGrid2.getStore().load({
			params : param,
			callback:function()	{
				me.isLoading = false;
			}
		});
	}
});

