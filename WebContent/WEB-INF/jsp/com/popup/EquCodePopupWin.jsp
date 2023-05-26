<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 장비번호 팝업
request.setAttribute("PKGNAME","Unilite.app.popup.EquCodePopup");
%>


	/**
	 *   Model 정의 
	 * @type 
	 */
Unilite.defineModel('${PKGNAME}.EquCodePopupModel', {  
    fields: [ 	 
    	
				{name: 'EQU_CODE_TYPE' 				,text:'장비구분' 				,type:'string'	,comboType:'AU',comboCode:'I800'	}
    			,{name: 'EQU_CODE' 			,text:'<t:message code="system.label.common.equipcode" default="장비코드"/>' 			,type:'string'	}
				,{name: 'EQU_NAME' 				,text:'장비명' 				,type:'string'	}
				,{name: 'EQU_SPEC' 					,text:'<t:message code="system.label.common.spec" default="규격"/>' 				,type:'string'	}
				,{name: 'CUSTOM_CODE' 			,text:'<t:message code="system.label.common.manufacturercode" default="제작처코드"/>' 			,type:'string'	}
				,{name: 'CUSTOM_NAME' 		,text:'<t:message code="system.label.common.manufacturer" default="제작처"/>' 			,type:'string'	}
				,{name: 'PRODT_DATE' 				,text:'<t:message code="system.label.common.manufacturerdate" default="제작일"/>' 			,type:'uniDate'	}
				,{name: 'PRODT_O' 					,text:'<t:message code="system.label.common.manufacturerprice" default="제작금액"/>' 			,type:'uniPrice'}
				,{name: 'ASSETS_NO' 				,text:'<t:message code="system.label.common.assetsno" default="자산번호"/>' 			,type:'string'	}
				,{name: 'EQU_GRADE' 				,text:'장비상태' 				,type:'string'	,comboType:'AU',comboCode:'I801'}
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
//	    var wParam = this.param;
//	    var t1= false, t2 = false;
//	    if( Ext.isDefined(wParam)) {
//	        if(wParam['TYPE'] == 'VALUE') {
//	            t1 = true;
//	            t2 = false;
//	            
//	        } else {
//	            t1 = false;
//	            t2 = true;
//	            
//	        }
//	    }


		me.panelSearch =  Unilite.createSearchForm('',{
		    layout : {type : 'uniTable', columns : 2},
		    items: [ 
		    
		    	{ fieldLabel: '장비구분'	 , 		name:'EQU_CODE_TYPE',	   xtype:'uniCombobox', comboType: 'AU', comboCode: 'I800'}
		    	,{ fieldLabel: '장비상태' ,name: 'EQU_GRADE',xtype: 'uniCombobox',comboType:'AU',comboCode:'I801'} 
		    
		    		 ,{ fieldLabel: '<t:message code="system.label.common.equipcode" default="장비코드"/>', 		name:'EQU_CODE',	   xtype:'uniTextfield',
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                     }
		    		,{ fieldLabel: ''	 	, 		name:'DIV_CODE',xtype: 'uniCombobox',comboType:'BOR120',hidden:true}
		    		,{ fieldLabel: '장비명'	 , 		name:'EQU_NAME',	   xtype:'uniTextfield'}
		    		,{ fieldLabel: '<t:message code="system.label.common.manufacturerdate" default="제작일"/>',xtype: 'uniDateRangefield',startFieldName: 'FR_DATE',endFieldName: 'TO_DATE'}
		    		
		    		,{ fieldLabel: '<t:message code="system.label.common.assetsno" default="자산번호"/>',      name:'ASSETS_NO',     xtype:'uniTextfield' ,
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
		me.masterStore = Unilite.createStoreSimple('${PKGNAME}.equcodePopupMasterStore',{
                model: '${PKGNAME}.EquCodePopupModel',
                autoLoad: false,
                proxy: {
                    type: 'direct',
                    api: {
                        read: 'popupService.equCodePopup'
                    }
                }
        })
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		me.masterGrid =  Unilite.createGrid('', {
			store: me.masterStore,
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
		    columns:  [  {dataIndex: 'EQU_CODE_TYPE' 				,width:80	}
						,{dataIndex: 'EQU_CODE' 				,width:120	}
						,{dataIndex: 'EQU_NAME' 				,width:130	}
						,{dataIndex: 'EQU_SPEC' 				,width:130	}
						,{dataIndex: 'CUSTOM_CODE' 				,width:120	}
						,{dataIndex: 'CUSTOM_NAME' 				,width:120	}
						,{dataIndex: 'PRODT_DATE' 				,width:120	}
						,{dataIndex: 'PRODT_O' 					,width:120	}
						,{dataIndex: 'ASSETS_NO' 				,width:120	}
						,{dataIndex: 'EQU_GRADE' 				,width:120	}
					
		    ] ,
		    listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {
   					var rv = {
   						status : "OK",
   						data:[record.data]
   					};
   					me.returnData(rv);
                    me.masterStore.commitChanges();
				},
                beforecelldblclick:function  (grid , td , cellIndex , record , tr , rowIndex , e , eOpts ) {                    
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
		
		var frm= me.panelSearch.getForm();
		frm.setValues(param);
		
//		me.panelSearch.setValues(param);
//		var frm= me.panelSearch.getForm();	
//		var equCode=frm.findField('EQU_CODE');
//		var divCode=frm.findField('DIV_CODE');
//		var frm= me.panelSearch.getForm();
//        if(!Ext.isEmpty(param['EQU_CODE'])){
//            equCode.setValue(param['EQU_CODE']);            
//        }
//        if(!Ext.isEmpty(param['DIV_CODE'])){
//            equCode.setValue(param['DIV_CODE']);            
//        }
//        frm.setValue("FR_DATE",UniDate.get('startOfMonth'));
//        frm.setValue("TO_DATE",UniDate.get('today'));
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

