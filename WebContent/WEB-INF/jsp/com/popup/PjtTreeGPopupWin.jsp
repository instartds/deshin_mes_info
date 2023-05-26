<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.PjtTreeGPopup");
%>


	Unilite.defineModel('${PKGNAME}.PjtTreeGPopupModel', {
	    fields: [{name: 'PJT_CODE' 		,text:'<t:message code="system.label.common.pjtcode" default="사업코드"/>' 		,type:'string'	},
				 {name: 'PJT_NAME'		,text:'<t:message code="system.label.common.pjtname" default="사업명"/>' 		,type:'string'	},
				 {name: 'DEPT_CODE' 	,text:'<t:message code="system.label.common.departmencode" default="부서코드"/>' 		,type:'string'	},
				 {name: 'DEPT_NAME' 	,text:'<t:message code="system.label.common.departmentname" default="부서명"/>' 		,type:'string'	},
				 {name: 'PERSON_NUMB' 	,text:'<t:message code="system.label.common.charger" default="담당자"/>' 		,type:'string'	}
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
    me.panelSearch = Unilite.createSearchForm('',{
        layout: {
        	type: 'uniTable', 
        	columns: 2, 
        	tableAttrs: {
	            style: {
	                width: '100%'
	            }
	        }
	    },
        items: [{
		    	fieldLabel: '<t:message code="system.label.common.searchword" default="검색어"/>',
		    	name:'TXT_SEARCH'
		    },{
				fieldLabel: '<t:message code="system.label.common.pjtcode" default="사업코드"/>',
		    	name:'PJT_CODE',
		    	hidden: true
		    },{
				fieldLabel: '<t:message code="system.label.common.pjtname" default="사업명"/>',
		    	name:'PJT_NAME',
		    	hidden: true
		    }]
    }); 
                   
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.PjtTreeGPopupStore',{
					model: '${PKGNAME}.PjtTreeGPopupModel',
			        autoLoad: false,
			        proxy: {
			            type: 'direct',
			            api: {
			            	read: 'popupService.pjtPopupGridList'
			            }
			        }
			}),
	        uniOpt:{
                 expandLastColumn: true
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
	        columns:  [        
	                     { dataIndex: 'PJT_CODE' 		,  width: 100 }
	                    ,{ dataIndex: 'PJT_NAME'		,  width: 300 }
	                    ,{ dataIndex: 'DEPT_NAME'		,  width: 300 }
	                    ,{ dataIndex: 'PERSON_NUMB'		,  width: 300 }
	        ],
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
	    
		config.items = [me.panelSearch, 	me.masterGrid];
      	me.callParent(arguments);
    },
    initComponent : function(){    
    	var me  = this;
        
        me.masterGrid.focus();
        
    	this.callParent();    	
    },
	fnInitBinding : function(param) {
		var frm= this.panelSearch.getForm();
		var search = frm.findField('TXT_SEARCH');
		if (!Ext.isEmpty(param['PJT_CODE'])) {
			search.setValue(param['PJT_CODE']);	
		}
		if (!Ext.isEmpty(param['PJT_NAME'])) {
			search.setValue(param['PJT_NAME']);	
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

