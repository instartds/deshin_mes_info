<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 사업팝업
request.setAttribute("PKGNAME","Unilite.app.popup.PjtTree");
%>



	/**
	 *   Model 정의 
	 * @type 
	 */
Unilite.defineModel('${PKGNAME}PjtPopupModel', {
    extend: 'Ext.data.Model',
    fields: [ {name: 'parentId' 					, text:'<t:message code="system.label.common.parentpjtcode" default="상위사업코드"/>' 	, type:'string'	}	// Java 내부 Tree에서 사용 하는 코드로 이름 변경 금지.
	    	, {name: 'PJT_CODE' 					, text:'<t:message code="system.label.common.pjtcode" default="사업코드"/>' 		, type:'string'	}
			, {name: 'PJT_NAME' 					, text:'<t:message code="system.label.common.pjtname" default="사업명"/>' 		, type:'string'	}
			, {name: 'DEPT_CODE'	 			, text:'<t:message code="system.label.common.departmencode" default="부서코드"/>' 		, type:'string'	}
			, {name: 'DEPT_NAME'	 			, text:'<t:message code="system.label.common.department" default="부서"/>' 		, type:'string'	}
			, {name: 'PERSON_NUMB'	 	, text:'<t:message code="system.label.common.charger" default="담당자"/>' 		, type:'string'	}
			, {name: 'USE_YN'	 					, text:'<t:message code="system.label.common.useyn" default="사용여부"/>' 		, type:'string'	}
	]
});				


Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    constructor : function(config) {
        var me = this;
        if (config) {
            Ext.apply(me, config);
        }
	    /* 검색조건 (Search Panel)
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
	    
		/* 검색조건 (Search Panel)
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
				fieldLabel: 'PJT_CODE',
		    	name:'PJT_CODE',
		    	hidden: true
		    },{
				fieldLabel: 'PJT_NAME',
		    	name:'PJT_NAME',
		    	hidden: true
		    } ]
		});  
		
		/* Master Grid 정의(Grid Panel)
		 * @type 
		 */
		me.masterPanel =  Ext.create('Ext.tree.Panel', {//Unilite.createTreeGrid('', {
			rootVisible	: false,
       	 	useArrows	: false,
       	 	bodyStyle	: 'background:#fff; ',
       	 	flex		: 1,
       	 	autoScroll	: true,
//	        rootVisible : true,
        	frame		: false,
        	selectionMode: 'MULTI',
			store		: Unilite.createTreeStore('${PKGNAME}PjtPopupMasterStore',{
				model	: '${PKGNAME}PjtPopupModel',
		        autoLoad: true,
//		        rootVisible : true,
		        proxy	: {
		            type: 'direct',
		            api	: {
		            	read: 'popupService.pjtTreeList'
		            }
		        },
		        uniOpt	: {
	            	isMaster	: 	false,			
	            	editable	: 	false,			 
	            	deletable	:	false,			
		            useNavi		: 	false			
	            },
		        listeners: {
		        	//팝업 필드에 값이 입력 되었을 때, 해당 데이터 보이게 expand, 값이 1개 일 때도 보이도록 수정
	            	'load' : function( store, records, successful, operation, node, eOpts ) {
	            		var expandedNode;
	            		if(records) {
	            			var root = this.getRootNode();
	            			if(root) {
	            				//값이 1개 일 때도 보이도록 수정 (root일 때 expand), 단 rootVisible: false
								root.expand();
	            				root.expandChildren();
	            			}
							node.cascadeBy(function(n){
								if(me.param[me.callBackScope.valuesName].indexOf(n.get(me.callBackScope.getDBvalueFieldName())) > -1)	{
									expandedNode = n.data.parentId
									n.set('checked', true);
									if(n.hasChildNodes())	{
										n.expand();
									}
								}
							})
							node.cascadeBy(function(n){
								//팝업 필드에 값이 입력 되었을 때, 해당 데이터 보이게 expand (parentId 값 찾아서 해당 노드 expand)
								if (n.data.id == expandedNode){
									n.expand();
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

		if(param['PJT_CODE'] && param['PJT_CODE']!='')	frm.setValue('PJT_CODE',  param['PJT_CODE']);
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
