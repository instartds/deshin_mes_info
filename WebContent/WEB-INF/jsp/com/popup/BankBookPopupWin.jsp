<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.BankBookPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	


	 Unilite.defineModel('${PKGNAME}.BankBookPopupModel', {
	    fields: [{name: 'BANK_BOOK_CODE' 	,text:'<t:message code="system.label.common.bankbookcode" default="통장코드"/>' 		,type:'string'	},
				 {name: 'BANK_BOOK_NAME'	,text:'<t:message code="system.label.common.bankbook" default="통장명"/>' 		,type:'string'	},				 
				 {name: 'DEPOSIT_NUM_MASK'  ,text:'<t:message code="system.label.common.bankaccount" default="계좌번호"/>' 		,type:'string' , defaultValue: '***************'},
				 {name: 'DEPOSIT_NUM_VAL'  ,text:'<t:message code="system.label.common.bankaccount" default="계좌번호"/>(<t:message code="system.label.common.decodingtype" default="유형별복호화"/>)'        ,type:'string' , defaultValue: '***************'},
				 {name: 'DEPOSIT_NUM_EXPOS' ,text:'<t:message code="system.label.common.bankaccount" default="계좌번호"/>(<t:message code="system.label.common.decryption" default="복호화"/>)' 		,type:'string'	},
				 {name: 'DEPOSIT_NUM' 		,text:'<t:message code="system.label.common.bankaccount" default="계좌번호"/>(DB)' 		,type:'string'	},
				 {name: 'BANK_CD' 			,text:'<t:message code="system.label.common.bankcode" default="은행코드"/>' 		,type:'string'	},
				 {name: 'BANK_NM' 			,text:'<t:message code="system.label.common.bankname" default="은행명"/>' 		,type:'string'	},				 
				 {name: 'ACCNT' 			,text:'ACCNT' 		,type:'string'	},
				 {name: 'ACCNT_NAME' 		,text:'ACCNT_NAME' 	,type:'string'	},
				 {name: 'DIV_CODE' 			,text:'DIV_CODE' 	,type:'string'	},
				 {name: 'DIV_NAME' 			,text:'DIV_NAME' 	,type:'string'	}
			]
	});

    
var isDecYn = 'N';  //복호화 조회 여부        
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
//                    xtype: 'radiogroup', width: 230,  
//                    items:[ {inputValue: '1', boxLabel:'코드순', name: 'RDO', checked: t1},
//                            {inputValue: '2', boxLabel:'이름순',  name: 'RDO', checked: t2} ]
//                 }
                 ,{ xtype: 'checkbox',          name:'CHK_ALL', boxLabel: '전체'	, hidden: true}
                 ,{ xtype: 'uniTextfield',      name:'ACCNT', hidden: true}
                 ,{ xtype: 'uniTextfield',      name:'DIV_CODE', hidden: true}
                 ,{ xtype: 'uniTextfield',      name:'ADD_QUERY', hidden: true}
                 ,{               
                    //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                    name:'DEC_FLAG', 
                    xtype: 'uniTextfield',
                    hidden: true
                 }
                
        ]
    });    
    me.masterStore = Unilite.createStoreSimple('${PKGNAME}.bankBookPopupStore',{
            model: '${PKGNAME}.BankBookPopupModel',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                    read: 'popupService.bankBookPopup'
                }
            }
    }),
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
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
	        selModel:'rowmodel',
	        columns:  [        
	                     { dataIndex: 'BANK_BOOK_CODE' 	,  width: 80 }
	                    ,{ dataIndex: 'BANK_BOOK_NAME'	,  width: 180 }
	                    ,{ dataIndex: 'DEPOSIT_NUM_EXPOS' 	,  width: 180, hidden: true }
	                    ,{ dataIndex: 'DEPOSIT_NUM_MASK' 	,  width: 180 }
	                    ,{ dataIndex: 'BANK_CD' 		,  width: 80 }
	                    ,{ dataIndex: 'BANK_NM' 		,  minWidth: 120, flex: 1 }
	                    ,{ dataIndex: 'DEPOSIT_NUM' 	,  width: 180, hidden: true }
//	                    ,{ dataIndex: 'ACCNT' 			,  width: 90, hidden: true }
//	                    ,{ dataIndex: 'ACCNT_NAME' 		,  width: 90, hidden: true }
//	                    ,{ dataIndex: 'DIV_CODE' 		,  width: 80, hidden: true }
//	                    ,{ dataIndex: 'DIV_NAME' 		,  width: 80, hidden: true }  
	        ],
			listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {
					if(colName =="DEPOSIT_NUM_MASK") {
						//me.masterGrid.openCryptCardNoPopup(record);
						record.set('DEPOSIT_NUM_MASK',record.data['DEPOSIT_NUM_EXPOS']);
					}else {
						var rv = {
							status : "OK",
							data:[record.data]
						};
						me.returnData(rv);
					}
                    me.masterStore.commitChanges();
				},
				beforecelldblclick:function  (grid , td , cellIndex , record , tr , rowIndex , e , eOpts ) {					
					var records = me.masterGrid.store.data.items;
					Ext.each(records, function(record,i) {
						if(isDecYn == 'N'){//일반조회
                            record.set('DEPOSIT_NUM_MASK','***************');
                        }else{//복호화 조회
                            record.set('DEPOSIT_NUM_MASK', record.get('DEPOSIT_NUM_VAL'));//복호화 조회되었던 값으로 세팅
                        }
					});
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
	    
	     //복호화 버튼 정의
        me.decrypBtn = Ext.create('Ext.Button',{
            text:'<t:message code="system.label.common.decryption" default="복호화"/>',
            width: 80,
            handler: function() {
        //        var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
        //        if(needSave){
        //           alert(Msg.sMB154); //먼저 저장하십시오.
        //           return false;
        //        }
                me.panelSearch.setValue('DEC_FLAG', 'Y');
                isDecYn = 'Y';
                me._dataLoad();
                me.panelSearch.setValue('DEC_FLAG', '');                
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
        	if(!Ext.isEmpty(param['BANK_BOOK_CODE'])){
        		fieldTxt.setValue(param['BANK_BOOK_CODE']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['BANK_BOOK_CODE'])){
        		fieldTxt.setValue(param['BANK_BOOK_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['BANK_BOOK_NAME'])){
        		fieldTxt.setValue(param['BANK_BOOK_NAME']);
        	}
        }
        
        var tbar = me.masterGrid._getToolBar();
        if(!Ext.isEmpty(tbar)){
            tbar[0].insert(tbar.length + 1, me.decrypBtn);
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
//					fieldTxt.setValue(param['BANK_BOOK_CODE']);
//					rdo.setValue({ RDO : '1'});
//				} else {
//					fieldTxt.setValue(param['BANK_BOOK_NAME']);
//					rdo.setValue({ RDO : '2'});
//				}
//			}
//			me.panelSearch.setValues(param);
//		}

		if(param.hasOwnProperty('ACCNT')) {
			me.panelSearch.getField('CHK_ALL').show();
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
		var chkAll = (me.panelSearch.getValue('CHK_ALL') ? 'Y' : 'N');
		
		if(chkAll == 'Y') {
			param.ACCNT = '';
			param.DIV_CODE = '';
		}
		
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

