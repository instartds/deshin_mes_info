<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.RemarkDistributionPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
    <t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B058"/> // 출고방법
	


	 Unilite.defineModel('${PKGNAME}.RemarkDistributionPopupModel', {
	    fields: [{name: 'REMARK_CD' 			,text:'<t:message code="system.label.common.remarkcode" default="적요코드"/>' 	 ,type:'string'	},
				 {name: 'REMARK_NAME' 		,text:'<t:message code="system.label.common.remark" default="적요"/>' 	     ,type:'string'	},
                 {name: 'REMARK_TYPE'       		,text:'<t:message code="system.label.common.remarktype" default="적요구분"/>'     ,type:'string' }
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
//    var wParam = this.param;
//    var t1= false, t2 = false;
//    if( Ext.isDefined(wParam)) {
//        if(wParam['TYPE'] == 'VALUE') {
//            t1 = true;
//            t2 = false;
//            
//        } else {
//            t1 = false;
//            t2 = true;
//            
//        }
//    }
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
        items: [  { xtype: 'uniCombobox', fieldLabel: '<t:message code="system.label.common.remarktype" default="적요구분"/>',     name:'REMARK_TYPE', comboType:'AU', comboCode:'B058', readOnly: true}
                 ,{ xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.searchconditon" default="검색조건"/>',     name:'TXT_SEARCH',
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
//                 ,{ fieldLabel: ' ', 
//                    xtype: 'radiogroup', width: 230,  
//                    items:[ {inputValue: '1', boxLabel:'코드순', name: 'RDO', checked: t1},
//                            {inputValue: '2', boxLabel:'이름순',  name: 'RDO', checked: t2} ]
//                 }                 
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.custPopupStore',{
							model: '${PKGNAME}.RemarkDistributionPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.remarkDistributionPopup'
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
	        selModel:'rowmodel',
	        columns:  [        
                         { dataIndex: 'REMARK_TYPE',  minWidth: 100, hidden: true}
	                    ,{ dataIndex: 'REMARK_CD'	 ,  width: 120 }
	                    ,{ dataIndex: 'REMARK_NAME',  minWidth: 380, flex: 1 }	     
	                    
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
		var fieldTxt = frm.findField('TXT_SEARCH');
		var frm= me.panelSearch.getForm();
		var fieldTxt = frm.findField('TXT_SEARCH');
		me.panelSearch.setValues(param);
		if(param['TYPE'] == 'VALUE') {
        	if(!Ext.isEmpty(param['REMARK_CODE'])){
        		fieldTxt.setValue(param['REMARK_CODE']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['REMARK_CODE'])){
        		fieldTxt.setValue(param['REMARK_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['REMARK_NAME'])){
        		fieldTxt.setValue(param['REMARK_NAME']);
        	}
        }
//		var rdo = frm.findField('RDO');
//		if( Ext.isDefined(param)) {
//			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
//				if(param['TYPE'] == 'VALUE') {
//					fieldTxt.setValue(param['REMARK_CODE']);
//					rdo.setValue({ RDO : '1'});
//				} else {
//					fieldTxt.setValue(param['REMARK_NAME']);
//					rdo.setValue({ RDO : '2'});
//				}
//			}
//			me.panelSearch.setValues(param);
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

