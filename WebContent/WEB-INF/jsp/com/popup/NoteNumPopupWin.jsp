<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.NoteNumPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 



	 Unilite.defineModel('${PKGNAME}.NoteNumPopupModel', {
	    fields: [{name: 'NOTE_NUM_CODE' 	,text:'<t:message code="system.label.common.noteno" default="어음번호"/>' 	,type:'string'	},
				 {name: 'NOTE_TYPE'						,text:'<t:message code="system.label.common.noteclass" default="어음구분"/>' 	,type:'string'	},
				 {name: 'NOTE_STS'  						,text: '<t:message code="system.label.common.notestatus" default="어음상태"/>' 	,type: 'string'},
				 {name: 'NOTE_STS2'  					,text: '<t:message code="system.label.common.notestatus" default="어음상태"/>' 	,type: 'string'  },
				 {name: 'CUSTOM_CODE' 			,text:'<t:message code="system.label.common.custom" default="거래처"/>' 	,type:'string'	},
				 {name: 'CUSTOM_NAME' 			,text:'<t:message code="system.label.common.customname" default="거래처명"/>' 	,type:'string'	},
				 {name: 'BANK_CODE' 					,text:'<t:message code="system.label.common.bankcode" default="은행코드"/>' 	,type:'string'	},
				 {name: 'BANK_NAME' 					,text:'<t:message code="system.label.common.bankname" default="은행명"/>' 	,type:'string'	},
				 {name: 'PUB_DATE' 						,text:'<t:message code="system.label.common.publishdate" default="발행일"/>' 	,type:'uniDate'	},
				 {name: 'EXP_DATE' 						,text:'<t:message code="system.label.common.duedate" default="만기일"/>' 	,type:'uniDate'	},
				 {name: 'OC_AMT_I' 						,text:'<t:message code="system.label.common.occuramount" default="발생금액"/>' 	,type:'uniPrice'},
				 {name: 'J_AMT_I' 							,text:'결제금액' 	,type:'uniPrice'}
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
        items: [  { xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
//                 ,{ fieldLabel: ' ', 
//                    xtype: 'radiogroup', width: 300,  
//                    items:[ {inputValue: '1', boxLabel:'어음번호순', name: 'RDO', checked: true},
//                            {inputValue: '2', boxLabel:'거래처순',  name: 'RDO', checked: false} ]
//                 }
        		,{ xtype: 'uniTextfield', fieldLabel: '자산부채특성',   name:'SPEC_DIVI',	hidden:true}
        		,{ xtype: 'uniTextfield', fieldLabel: '차대구분',     	name:'DR_CR', 		hidden:true}
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.noteNumPopupStore',{
							model: '${PKGNAME}.NoteNumPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.noteNumPopup'
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
	                     { dataIndex: 'NOTE_NUM_CODE' 	,  width: 110 }
	                    ,{ dataIndex: 'NOTE_TYPE'		,  width: 110 }
	                    ,{ dataIndex: 'NOTE_STS'		,  width: 110 }
	                    ,{ dataIndex: 'NOTE_STS2'		,  width: 110 }
	                    ,{ dataIndex: 'CUSTOM_CODE' 	,  width: 80 }
	                    ,{ dataIndex: 'CUSTOM_NAME' 	,  width: 120 }
	                    ,{ dataIndex: 'BANK_CODE' 		,  width: 90 }
	                    ,{ dataIndex: 'BANK_NAME' 		,  width: 100 }
	                    ,{ dataIndex: 'PUB_DATE' 		,  width: 90 }
	                    ,{ dataIndex: 'EXP_DATE' 		,  width: 90 }
	                    ,{ dataIndex: 'OC_AMT_I' 		,  width: 100} 
	                    ,{ dataIndex: 'J_AMT_I' 		,  minWidth: 100, flex: 1 }  
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
			},
			hideCustom:function(b)	{
				
				var customCode = this.getColumn('CUSTOM_CODE');
				var customName = this.getColumn('CUSTOM_NAME');
				var noteSts = this.getColumn('NOTE_STS');	
				var noteSts2 = this.getColumn('NOTE_STS2');	// 대변,지급어음의 경우 
//				if(b)	{
//					customCode.hide();
//					customName.hide();
//					noteSts.hide();
//					noteSts2.show();
//				}else {
//					customCode.show();
//					customName.show();
//					noteSts.show();
//					noteSts2.hide();
//				}
				if(b)	{
					customCode.setHidden(true);
					customName.setHidden(true);
					noteSts.setHidden(true);
					noteSts2.setHidden(false);
				}else {
					customCode.setHidden(false);
					customName.setHidden(false);
					noteSts.setHidden(false);
					noteSts2.setHidden(true);
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
        	if(!Ext.isEmpty(param['NOTE_NUM_CODE'])){
        		fieldTxt.setValue(param['NOTE_NUM_CODE']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['NOTE_NUM_CODE'])){
        		fieldTxt.setValue(param['NOTE_NUM_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['NOTE_NUM_NAME'])){
        		fieldTxt.setValue(param['NOTE_NUM_NAME']);
        	}
        }
        
        if(param['DR_CR'] =="2" && param["SPEC_DIVI"] == "D3")	{
        	me.masterGrid.hideCustom(true);
        }else {
        	me.masterGrid.hideCustom(false);
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
//					fieldTxt.setValue(param['NOTE_NUM_CODE']);
//					rdo.setValue({ RDO : '1'});
//				} /*else {
//					fieldTxt.setValue(param['NOTE_NUM_NAME']);
//					rdo.setValue({ RDO : '2'});
//				}*/
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

