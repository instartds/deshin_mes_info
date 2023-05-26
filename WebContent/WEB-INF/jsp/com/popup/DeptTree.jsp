<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 부서팝업
request.setAttribute("PKGNAME","Unilite.app.popup.DeptTree");
%>



	/**
	 *   Model 정의 
	 * @type 
	 */
Unilite.defineModel('${PKGNAME}DeptPopupModel', {
    extend: 'Ext.data.Model',
    fields: [ 	 {name: 'parentId' 					,text:'상위부서코드' 	,type:'string'	}	// Java 내부 Tree에서 사용 하는 코드로 이름 변경 금지.
	    		,{name: 'TREE_CODE' 				,text:'<t:message code="system.label.common.departmencode" default="부서코드"/>' 		,type:'string'	}
				,{name: 'TREE_NAME' 				,text:'<t:message code="system.label.common.departmentname" default="부서명"/>' 			,type:'string'	}
				,{name: 'DIV_CODE' 					,text:'<t:message code="system.label.common.division" default="사업장"/>' 			,type:'string'	}
				,{name: 'BILL_DIV_CODE' 			,text:'<t:message code="system.label.common.declaredivisioncode" default="신고사업장"/>' 	,type:'string'	}
				,{name: 'BILL_DIV_NAME' 			,text:'<t:message code="system.label.common.declaredivisionname" default="신고사업장명"/>' 	,type:'string'	}
				,{name: 'SECTION_CODE' 			,text:'<t:message code="system.label.common.businessdivisioncode" default="사업부코드"/>' 		,type:'string'	}
				,{name: 'SECTION_NAME' 		,text:'<t:message code="system.label.common.businessdivisionname" default="사업부"/>' 		,type:'string'	}
				,{name: 'WH_CODE' 					,text:'창고' 			,type:'string'	}
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
		    items: [{
		    	fieldLabel: '<t:message code="system.label.common.searchword" default="검색어"/>',
		    	name:'TXT_SEARCH',
		    	hidden: true
		    },{
				fieldLabel: 'DEPT_CODE',
		    	name:'DEPT_CODE',
		    	hidden: true
		    },{
		    	fieldLabel: 'DIV_CODE',
		    	name:'DIV_CODE',
		    	hidden: true
		    },{
           		xtype: 'radiogroup',		            		
           		fieldLabel: '',
           		items : [
           			{boxLabel  : '현재 적용부서', width: 130,  name: 'USE_YN',  inputValue: 'Y'  , checked: true}
                   	,{boxLabel  : '전체', width: 80, name: 'USE_YN' , inputValue: ''}
                   		
               	]
            }]
		});  
		
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		
		me.masterPanel =  Ext.create('Ext.tree.Panel', {//Unilite.createTreeGrid('', {
			rootVisible: false,
       	 	useArrows: false,
       	 	bodyStyle: 'background:#fff; ',
       	 	flex:1,
       	 	autoScroll:true,
        	frame: false,
        	selectionMode:'MULTI',
			store: Unilite.createTreeStore('${PKGNAME}DeptPopupMasterStore',{
							model: '${PKGNAME}DeptPopupModel',
							
					        autoLoad: true,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.deptTreeList'
					            }
					        },
					        uniOpt : {
				            	isMaster: 	false,			
				            	editable: 	false,			 
				            	deletable:	false,			
					            useNavi : 	false			
				            },
					        listeners: {
				            	'load' : function( store, records, successful, operation, node, eOpts ) {
				            		
				            		if(records) {
				            			var root = this.getRootNode();
				            			if(root) {
				            				root.expandChildren();
				            			}
										node.cascadeBy(function(n){
											if(me.param[me.callBackScope.valuesName].indexOf(n.get(me.callBackScope.getDBvalueFieldName())) > -1)	{
												n.set('checked', true);
												if(n.hasChildNodes())	{
													n.expand();
												}
											}
										})
										
				            		}
				            	}
				            }
					}),
		    listeners: {
			    checkchange:function( node, checked, e, eOpts )	{
			    	if(me.callBackScope.selectChildren)	{
			    		node.cascadeBy(function(n){n.set('checked', checked);} );
			    	}
			    },
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
		config.items = [me.panelSearch,	me.masterPanel];
     	me.callParent(arguments);
    },			
	initComponent : function(){    
    	var me  = this;
        
        me.masterPanel.focus();
        
    	this.callParent();    	
    },    
	fnInitBinding : function(param) {
		var me = this;
		var frm= me.panelSearch;

		if(param['DEPT_CODE'] && param['DEPT_CODE']!='')	frm.setValue('DEPT_CODE',  param['DEPT_CODE']);
		if(param['DIV_CODE'] && param['DIV_CODE']!='')		frm.setValue('DIV_CODE',   param['DIV_CODE']);
		if(param['USE_YN'] && param['USE_YN']!='')		frm.setValue('USE_YN',   param['USE_YN']);
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad(true);
	},
	onSubmitButtonDown : function()	{
        var me = this;
		var selectRecord = me.masterPanel.getChecked();
		var rData = [];
		Ext.each(selectRecord, function(record, idx){
			rData.push(record.data)
		});
	 	var rv ;
		if(selectRecord)	{
		 	rv = {
				status : "OK",
				data:rData
			};
		}
		me.returnData(rv);
	},
	_dataLoad : function(isInit) {
		var me = this;
		var param= me.panelSearch.getValues();
		me.isLoading = true;
		me.masterPanel.getStore().load({
			params : param,
			callback:function()	{
				me.isLoading = false;
			}
		});
	}
});
