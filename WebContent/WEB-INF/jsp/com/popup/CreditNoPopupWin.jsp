<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.CreditNoPopup");
%>

    <t:ExtComboStore useScriptTag="false" comboType="BOR120" />                         // 사업장 
    


     Unilite.defineModel('${PKGNAME}.CreditNoPopupModel', {
        fields: [{name: 'CREDIT_NO_CODE'			,text:'<t:message code="system.label.common.creditcardcode" default="신용카드코드"/>'  ,type:'string'  },
                 {name: 'CREDIT_NO_NAME'			,text:'<t:message code="system.label.common.creditcardname" default="카드명"/>'         ,type:'string'  },
                 {name: 'CRDT_FULL_NUM_MASK'  ,text:'<t:message code="system.label.common.creditcardnum" default="신용카드번호"/>'  ,type:'string', defaultValue:'***************'},
                 {name: 'CRDT_FULL_NUM_VAL'    	,text:'<t:message code="system.label.common.creditcardnum" default="신용카드번호"/>(<t:message code="system.label.common.decodingtype" default="유형별복호화"/>)'  ,type:'string'},
                 {name: 'CRDT_FULL_NUM_EXPOS' ,text:'<t:message code="system.label.common.creditcardnum" default="신용카드번호"/>(<t:message code="system.label.common.decryption" default="복호화"/>)'     ,type:'string'  },
                 {name: 'CRDT_FULL_NUM'     			,text:'<t:message code="system.label.common.creditcardnum" default="신용카드번호"/>(DB)'  ,type:'string'  },
                 {name: 'BANK_CODE'         				,text:'<t:message code="system.label.common.bankcode" default="은행코드"/>'        ,type:'string'  },
                 {name: 'BANK_NAME'         				,text:'<t:message code="system.label.common.bankname" default="은행명"/>'         ,type:'string'  },
                 {name: 'ACCOUNT_NUM_MASK'    ,text:'<t:message code="system.label.common.paybankaccount" default="결제계좌번호"/>'  ,type:'string', defaultValue:'***************'},
                 {name: 'ACCOUNT_NUM_VAL'     	,text:'<t:message code="system.label.common.paybankaccount" default="결제계좌번호"/>(<t:message code="system.label.common.decodingtype" default="유형별복호화"/>)'  ,type:'string'  },
                 {name: 'ACCOUNT_NUM_EXPOS'   ,text:'<t:message code="system.label.common.paybankaccount" default="결제계좌번호"/>(<t:message code="system.label.common.decryption" default="복호화"/>)'  ,type:'string'  },
                 {name: 'ACCOUNT_NUM'       			,text:'<t:message code="system.label.common.paybankaccount" default="결제계좌번호"/>(DB)'  ,type:'string'  },
                 {name: 'SET_DATE'          					,text:'<t:message code="system.label.common.paydate" default="결제일"/>'         ,type:'uniDate' },
                 {name: 'PERSON_NAME'       			,text:'<t:message code="system.label.common.employeename" default="사원명"/>'         ,type:'string'  },
                 {name: 'CRDT_COMP_CD'      			,text:'<t:message code="system.label.common.creditcardcompcode" default="신용카드사코드"/>'       ,type:'string'  },
                 {name: 'CRDT_COMP_NM'      		,text:'<t:message code="system.label.common.creditcardcomp" default="신용카드사"/>'  ,type:'string'  }
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
                    }, {               
                        //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                        name:'DEC_FLAG', 
                        xtype: 'uniTextfield',
                        hidden: true
                    }
//                 ,{ fieldLabel: ' ', 
//                    xtype: 'radiogroup', width: 230,  
//                    items:[ {inputValue: '1', boxLabel:'코드순', name: 'RDO', checked: t1},
//                            {inputValue: '2', boxLabel:'이름순',  name: 'RDO', checked: t2} ]
//                 }
                
        ]
    });        
    me.masterStore = Unilite.createStoreSimple('${PKGNAME}.creditNoPopupStore',{
            model: '${PKGNAME}.CreditNoPopupModel',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                    read: 'popupService.creditNoPopup'
                }
            }
    });
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
                         { dataIndex: 'CREDIT_NO_CODE'      ,  width: 90 }
                        ,{ dataIndex: 'CREDIT_NO_NAME'      ,  width: 120 }
                        ,{ dataIndex: 'CRDT_FULL_NUM_MASK'      ,  width: 140, align:'center' }
//                      ,{ dataIndex: 'CRDT_FULL_NUM_EXPOS'         ,  width: 140, hidden: true }
//                      ,{ dataIndex: 'CRDT_FULL_NUM'       ,  width: 140, hidden: true }
                        ,{ dataIndex: 'BANK_CODE'           ,  width: 80 }
                        ,{ dataIndex: 'BANK_NAME'           ,  width: 110 }
                        ,{ dataIndex: 'ACCOUNT_NUM_MASK'        ,  width: 120, align:'center' }
//                      ,{ dataIndex: 'ACCOUNT_NUM_EXPOS'       ,  width: 90, hidden: true }
//                      ,{ dataIndex: 'ACCOUNT_NUM'         ,  width: 90, hidden: true }
                        ,{ dataIndex: 'SET_DATE'            ,  width: 90 }
                        ,{ dataIndex: 'PERSON_NAME'         ,  width: 80 }
                        ,{ dataIndex: 'CRDT_COMP_CD'        ,  width: 80 }
                        ,{ dataIndex: 'CRDT_COMP_NM'        ,  minWidth: 120, flex: 1 }
            ],
            tbar: [
            
            ],
            listeners: {
                onGridDblClick:function(grid, record, cellIndex, colName) {
                    if(colName == 'CRDT_FULL_NUM_MASK') {
                        record.set('CRDT_FULL_NUM_MASK',record.data['CRDT_FULL_NUM_EXPOS']);
                    }else if(colName == 'ACCOUNT_NUM_MASK') {
                        record.set('ACCOUNT_NUM_MASK',record.data['ACCOUNT_NUM_EXPOS']);
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
                            record.set('CRDT_FULL_NUM_MASK','***************');
                        }else{//복호화 조회
                            record.set('CRDT_FULL_NUM_MASK', record.get('CRDT_FULL_NUM_VAL'));//복호화 조회되었던 값으로 세팅
                        }
                        
                        if(isDecYn == 'N'){//일반조회
                            record.set('ACCOUNT_NUM_MASK','***************');
                        }else{//복호화 조회
                            record.set('ACCOUNT_NUM_MASK', record.get('ACCOUNT_NUM_VAL'));//복호화 조회되었던 값으로 세팅
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
        
        config.items = [me.panelSearch,     me.masterGrid];
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
            if(!Ext.isEmpty(param['CREDIT_NO_CODE'])){
                fieldTxt.setValue(param['CREDIT_NO_CODE']);         
            }
        }else{
            if(!Ext.isEmpty(param['CREDIT_NO_CODE'])){
                fieldTxt.setValue(param['CREDIT_NO_CODE']);         
            }
            if(!Ext.isEmpty(param['CREDIT_NO_NAME'])){
                fieldTxt.setValue(param['CREDIT_NO_NAME']);
            }
        }
        
       
        var tbar = me.masterGrid._getToolBar();
        if(!Ext.isEmpty(tbar)){
            tbar[0].insert(tbar.length + 1, me.decrypBtn);
        }
//        var me = this;
//      
//      var frm= me.panelSearch.getForm();
//      
//      var rdo = frm.findField('RDO');
//      var fieldTxt = frm.findField('TXT_SEARCH');
//
//      if( Ext.isDefined(param)) {
//          if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
//              if(param['TYPE'] == 'VALUE') {
//                  fieldTxt.setValue(param['CREDIT_NO_CODE']);
//                  rdo.setValue({ RDO : '1'});
//              } else {
//                  fieldTxt.setValue(param['CREDIT_NO_NAME']);
//                  rdo.setValue({ RDO : '2'});
//              }
//          }
//          me.panelSearch.setValues(param);
//      }
        this._dataLoad();
    },
     onQueryButtonDown : function() {
        this._dataLoad();
        isDecYn = 'N';
    },
    onSubmitButtonDown : function() {
        var me = this;
        var selectRecord = me.masterGrid.getSelectedRecord();
        var rv ;
        if(selectRecord)    {
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
