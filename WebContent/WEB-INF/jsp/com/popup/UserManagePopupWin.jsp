<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.UserManagePopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	


	 Unilite.defineModel('${PKGNAME}.UserManagePopupModel', {
	    fields: [{name: 'USER_MANAGE_CODE' 		,text:'<t:message code="system.label.common.manageitemcode" default="관리항목코드"/>' 	,type:'string'	},
				 {name: 'USER_MANAGE_NAME'	 		,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>' 		,type:'string'	},
				 {name: 'DATA_TYPE'	 							,text:'<t:message code="system.label.common.type" default="유형"/>' 			,type:'string'	},
				 {name: 'DATA_LENGTH'	 					,text:'<t:message code="system.label.common.length" default="길이"/>' 			,type:'string'	},
				 {name: 'POPUP_YN'	 							,text:'<t:message code="system.label.common.popupyn" default="팝업여부"/>' 		,type:'string'	},
				 {name: 'USE_YN'	 								,text:'<t:message code="system.label.common.useyn" default="사용여부"/>'	 	,type:'string'	},
				 {name: 'POPUP_CODE'	 	,text:'POPUP_CODE'	,type:'string'	}
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
        items: [  { fieldLabel: '<t:message code="system.label.common.useflag" default="사용유무"/>',		name:'USE_YN', hidden:true}
                 ,{ xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',
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
            store: Unilite.createStoreSimple('${PKGNAME}.userManagePopupStore',{
							model: '${PKGNAME}.UserManagePopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.userManagePopup'
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
	                     { dataIndex: 'USER_MANAGE_CODE' 		,  width: 100 }
	                    ,{ dataIndex: 'USER_MANAGE_NAME'	 		,  width: 180 }
	                    ,{ dataIndex: 'DATA_TYPE'	 		,  width: 80 }
	                    ,{ dataIndex: 'DATA_LENGTH'	 		,  width: 80 }
	                    ,{ dataIndex: 'POPUP_YN'	 		,  width: 80 }
	                    ,{ dataIndex: 'USE_YN'	 			,  minWidth: 80, flex: 1 }
	                    ,{ dataIndex: 'POPUP_CODE'	 		,  width: 80, hidden: true }
	                    
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
        	if(!Ext.isEmpty(param['USER_MANAGE_CODE'])){
        		fieldTxt.setValue(param['USER_MANAGE_CODE']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['USER_MANAGE_CODE'])){
        		fieldTxt.setValue(param['USER_MANAGE_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['USER_MANAGE_NAME'])){
        		fieldTxt.setValue(param['USER_MANAGE_NAME']);
        	}
        }     
//        var me = this;		
//		var frm= me.panelSearch.getForm();
//		
//		var rdo = frm.findField('RDO');
//		var fieldTxt = frm.findField('TXT_SEARCH');
//
//		if( Ext.isDefined(param)) {
//			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
//				if(param['TYPE'] == 'VALUE') {
//					fieldTxt.setValue(param['USER_MANAGE_CODE']);
//					rdo.setValue({ RDO : '1'});
//				} else {
//					fieldTxt.setValue(param['USER_MANAGE_NAME']);
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

