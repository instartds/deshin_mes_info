<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.s_asset_mitPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	


	 Unilite.defineModel('${PKGNAME}.s_asset_mitPopupModel', {
	    fields: [{name: 'ASST'			,text:'<t:message code="system.label.common.assetscode" default="자산코드"/>' 			,type:'string'	},
				 {name: 'ASST_NAME'		,text:'<t:message code="system.label.common.assetsname" default="자산명"/>' 			,type:'string'	},
				 {name: 'ACCNT'			,text:'<t:message code="system.label.common.accountcode" default="계정코드"/>' 		,type:'string'	},
				 {name: 'ACCNT_NAME'	,text:'<t:message code="system.label.common.accountitemname" default="계정과목명"/>' 	,type:'string'	},
				 {name: 'ACQ_DATE'		,text:'<t:message code="system.label.common.acqdate" default="취득일"/>' 				,type:'uniDate'	},
				 {name: 'ACQ_AMT_I'		,text:'<t:message code="system.label.common.acamount" default="취득가액"/>' 			,type:'uniPrice'},
				 {name: 'ACQ_Q'			,text:'<t:message code="system.label.common.acquestqty" default="취득수량"/>' 			,type:'uniQty'	},
				 {name: 'DRB_YEAR'		,text:'<t:message code="system.label.common.contentyear" default="내용년수"/>' 		,type:'int'		},
				 {name: 'DPR_RATE'		,text:'<t:message code="system.label.common.deprection" default="상각률"/>' 			,type:'uniPercent'	},
				 {name: 'SPEC'			,text:'<t:message code="system.label.common.spec" default="규격"/>' 					,type:'string'	}
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
                 ,{ 
						fieldLabel	: '사업장',
						name		: 'ACCNT_DIV_CODE',
						xtype		: 'uniCombobox',
						multiSelect	: true, 
						typeAhead	: false,
						value		: UserInfo.divCode,
						readOnly    : true,
						hidden      : true,
						comboType	: 'BOR120',
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.custPopupStore',{
							model: '${PKGNAME}.s_asset_mitPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.s_asset_mitPopup'
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
	                     { dataIndex: 'ASST' 		,  width: 80 }
	                    ,{ dataIndex: 'ASST_NAME'	,  width: 150 }
	                    ,{ dataIndex: 'ACCNT' 		,  width: 80 }
	                    ,{ dataIndex: 'ACCNT_NAME' 	,  width: 120 }
	                    ,{ dataIndex: 'ACQ_DATE' 	,  width: 90 }
	                    ,{ dataIndex: 'ACQ_AMT_I' 	,  width: 90 }
	                    ,{ dataIndex: 'ACQ_Q' 		,  width: 90 }
	                    ,{ dataIndex: 'DRB_YEAR' 	,  width: 80 }
	                    ,{ dataIndex: 'DPR_RATE' 	,  width: 80 }
	                    ,{ dataIndex: 'SPEC' 	    ,  minWidth: 80, flex: 1 , hidden:true }  
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
        	if(!Ext.isEmpty(param['ASST'])){
        		fieldTxt.setValue(param['ASST']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['ASST'])){
        		fieldTxt.setValue(param['ASST']);        	
        	}
        	if(!Ext.isEmpty(param['ASST_NAME'])){
        		fieldTxt.setValue(param['ASST_NAME']);
        	}
        }
//        var me = this;
//		
//		var frm= me.panelSearch.getForm();
//		
//		var rdo = frm.findField('RDO');
//		var fieldTxt = frm.findField('TXT_SEARCH');
//
//		if( Ext.isDefined(param)) {
//			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
//				if(param['TYPE'] == 'VALUE') {
//					fieldTxt.setValue(param['ASST']);
//					rdo.setValue({ RDO : '1'});
//				} else {
//					fieldTxt.setValue(param['ASST_NAME']);
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

