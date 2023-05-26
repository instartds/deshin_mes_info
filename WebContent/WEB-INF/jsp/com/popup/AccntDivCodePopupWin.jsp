<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.AccntDivCodePopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	


	 Unilite.defineModel('${PKGNAME}.AccntDivCodePopupModel', {
	fields:[	{name:'ACCNT_DIV_CODE'		,text:'<t:message code="system.label.common.divisioncode" default="사업장코드"/>'				,type:'string'	},
				{name:'ACCNT_DIV_NAME'		,text:'<t:message code="system.label.common.division" default="사업장"/>'				,type:'string'	},
				{name:'DIV_FULL_NAME'		,text:'DIV_FULL_NAME'		,type:'string'	},
				{name:'COMPANY_NUM'			,text:'COMPANY_NUM'			,type:'string'	},
				{name:'REPRE_NAME'			,text:'REPRE_NAME'			,type:'string'	},
				{name:'REPRE_NO'			,text:'REPRE_NO'			,type:'string'	},
				{name:'COMP_CLASS'			,text:'COMP_CLASS'			,type:'string'	},
				{name:'COMP_TYPE'			,text:'COMP_TYPE'			,type:'string'	},
				{name:'ZIP_CODE'			,text:'ZIP_CODE'			,type:'string'	},
				{name:'ADDR'				,text:'ADDR'				,type:'string'	},
				{name:'TELEPHON'			,text:'TELEPHON'			,type:'string'	},
				{name:'FAX_NUM'				,text:'FAX_NUM'				,type:'string'	},
				{name:'SAFFER_TAX'			,text:'SAFFER_TAX'			,type:'string'	},
				{name:'SAFFER_TAX_NM'		,text:'SAFFER_TAX_NM'		,type:'string'	},
				{name:'BILL_DIV_CODE'		,text:'BILL_DIV_CODE'		,type:'string'	},
				{name:'TAX_NAME'			,text:'TAX_NAME'			,type:'string'	},
				{name:'TAX_NUM'				,text:'TAX_NUM'				,type:'string'	},
				{name:'TAX_TEL'				,text:'TAX_TEL'				,type:'string'	},
				{name:'HANDPHONE'			,text:'HANDPHONE'			,type:'string'	}
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
        items: [  { xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
                 ,{ fieldLabel: ' ', 
                    xtype: 'radiogroup', width: 230,  
                    items:[ {inputValue: '1', boxLabel:'<t:message code="system.label.common.codeinorder" default="코드순"/>', name: 'RDO', checked: t1},
                            {inputValue: '2', boxLabel:'<t:message code="system.label.common.nameinorder" default="이름순"/>',  name: 'RDO', checked: t2} ]
                 }
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.accntDivCodePopupStore',{
							model: '${PKGNAME}.AccntDivCodePopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.accntDivCodePopup'
					            }
					        }
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
	    	selModel :   Ext.create('Ext.selection.CheckboxModel', {
	    		checkOnly : false,
	    		toggleOnClick:false,
		        uniOpt:{
	                onLoadSelectFirst : false     
		        },
	    		mode: 'SIMPLE',
	    		listeners: {
	    			beforeselect : function( me, record, index, eOpts ){	
	    				
	    			},
	    			beforedeselect : function( me, record, index, eOpts ){
	    				
	    			}
	    		}    														
	    	}),
	        columns:  [        
	                     { dataIndex: 'ACCNT_DIV_CODE' 	,  width: 230 }
	                    ,{ dataIndex: 'ACCNT_DIV_NAME'	,  width: 270 }
	                    
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
        var me = this;
		
		var frm= me.panelSearch.getForm();
		
		var rdo = frm.findField('RDO');
		var fieldTxt = frm.findField('TXT_SEARCH');

		if( Ext.isDefined(param)) {
			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
				if(param['TYPE'] == 'VALUE') {
					fieldTxt.setValue(param['ACCNT_DIV_CODE']);
					rdo.setValue({ RDO : '1'});
				} else {
					fieldTxt.setValue(param['ACCNT_DIV_NAME']);
					rdo.setValue({ RDO : '2'});
				}
			}
			me.panelSearch.setValues(param);
		}
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        var me = this,
            masterGrid = me.masterGrid,
            panelSearch = me.panelSearch;
		var selectRecords = masterGrid.getSelectedRecords();
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

