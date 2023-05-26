<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 거래처팝업
request.setAttribute("PKGNAME","Unilite.app.popup.CustKocisPopup");
%>
/**
 *   Model 정의 
 * @type 
 */
Unilite.defineModel('${PKGNAME}CustKocisPopupModel', {
    fields: [
    	{name: 'CUSTOM_CODE'       ,text:'<t:message code="system.label.common.customcode" default="거래처코드"/>'   ,type:'string'  }
        ,{name: 'CUSTOM_NAME'      ,text:'<t:message code="system.label.common.customname" default="거래처명"/>'    ,type:'string'  , allowBlank:false}
        ,{name: 'CUSTOM_TYPE'      ,text:'<t:message code="system.label.common.classfication" default="구분"/>'       ,type:'string', allowBlank:false, comboType:'AU',comboCode:'B015'}                
        ,{name: 'AGENT_TYPE'       ,text:'<t:message code="system.label.common.customclass" default="거래처분류"/>'   ,type:'string', comboType:'AU',comboCode:'B055'  }
    ]
});


/**
 * 검색조건 (Search Panel)
 * @type 
 */
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',    
    //param: this.param,
    constructor : function(config) {
        var me = this;
        if (config) {
            Ext.apply(me, config);
        }
        /**
         * 검색조건 (Search Panel)
         * @type 
         */
//      var wParam = this.param;
//      var t1= false, t2 = false;
//      if( Ext.isDefined(wParam)) {
//          if(wParam['TYPE'] == 'VALUE') {
//              t1 = true;
//              t2 = false;
//              
//          } else {
//              t1 = false;
//              t2 = true;
//              
//          }
//      }
        me.panelSearch = Unilite.createSearchForm('',{
            layout : {type : 'uniTable', columns : 2, tableAttrs: {
                style: {
                    width: '100%'
                }
            }},
            items: [  { fieldLabel: '<t:message code="system.label.common.classfication" default="구분"/>',  name:'CUSTOM_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B015'}
                     
                     ,{ fieldLabel: '<t:message code="system.label.common.customclass" default="거래처분류"/>',    name:'AGENT_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B055'}
                     
                     ,{ fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',  allowBlank:false,
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                     }
                     ,{ fieldLabel: '<t:message code="system.label.common.useflag" default="사용유무"/>',     name:'USE_YN', hidden:true}
//                   ,{ fieldLabel: '사업자구분', 
//                      xtype: 'radiogroup', width: 230,
//                      items:[ {inputValue: '1', boxLabel:'코드순', name: 'RDO', checked: t1},
//                              {inputValue: '2', boxLabel:'이름순',  name: 'RDO', checked: t2} ]
//                   }
                    ,{ xtype:'button', text:'<t:message code="system.label.common.quickregist" default="빠른등록"/>', margin: '0 0 5 95', width: 110
                    ,handler:function() {
                            me.openRegWindow();
                       }
                     }
                     ,{ fieldLabel: '<t:message code="system.label.common.addquery" default="추가쿼리관련"/>',     name:'ADD_QUERY',   xtype: 'uniTextfield', hidden: true}
                     
            ]
        });  
        me.masterStore = Unilite.createStoreSimple('${PKGNAME}custKocisPopupMasterStore',{
            model: '${PKGNAME}CustKocisPopupModel',
            autoLoad: false,
            proxy: {
                type: 'uniDirect',
                api: {
                    read: 'popupService.custKocisPopup'
                    ,create : 's_bcm100ukrvService_KOCIS.insertSimple'
                    ,syncAll:'s_bcm100ukrvService_KOCIS.syncAll'
                }
            },
            saveStore : function(config)    {               
                    var inValidRecs = this.getInvalidRecords();
                    if(inValidRecs.length == 0 )    {
                        this.syncAll(config);
//                                      this.syncAllDirect(config);
                    }else {
                        alert(Msg.sMB083);
                    }
            }
    });
        
        /**
         * Master Grid 정의(Grid Panel)
         * @type 
         */
         me.masterGrid = Unilite.createGrid('', {
            store: me.masterStore,
            uniOpt: {
				state: {
					useState: false,
					useStateList: false	
                },
				pivot : {
					use : false
				}
	        },
            selModel:'rowmodel',
            columns: [        
                 { dataIndex: 'CUSTOM_CODE'     ,width: 80}  
                ,{ dataIndex: 'CUSTOM_NAME'     ,width: 200} 
                ,{ dataIndex: 'CUSTOM_TYPE'     ,width: 80} 
                ,{ dataIndex: 'AGENT_TYPE'      ,width: 100, align:'center'}
            ],
            listeners: {
                onGridDblClick:function(grid, record, cellIndex, colName) {
//                  if(colName =="TOP_NUM_MASK") {
//                        //me.masterGrid.openCryptCardNoPopup(record);
//                        record.set('TOP_NUM_MASK',record.data['TOP_NUM_EXPOS']);
//                    }else {
                        var rv = {
                            status : "OK",
                            data:[record.data]
                        };
                        me.returnData(rv);
//                    }
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
        config.items = [me.panelSearch, me.masterGrid];
        me.callParent(arguments);
        
        me.regCustKocisForm = Unilite.createForm('',{
            
            layout : {type : 'uniTable', columns : 1},
            masterGrid: me.masterGrid,
            
            disabled:false,
            buttonAlign :'center',
            fbar: [
                    {  xtype: 'button', text: '저장' ,
                       handler: function()  {
                            if(!me.regCustKocisForm.getInvalidMessage()) return;

                                //기존 저장로직
                                var r = {
                                    CUSTOM_CODE: me.regCustKocisForm.getValue('CUSTOM_CODE'),
                                    CUSTOM_NAME: me.regCustKocisForm.getValue('CUSTOM_NAME'),
                                    CUSTOM_TYPE: me.regCustKocisForm.getValue('CUSTOM_TYPE'),
                                    AGENT_TYPE: me.regCustKocisForm.getValue('AGENT_TYPE')
                                }
                                me.masterGrid.createRow(r);
                                var record = me.masterGrid.getSelectedRecord();
                                me.masterGrid.getStore().saveStore({                                    
                                    success: function() {
                                        var rv = {
                                            status : "OK",
                                            data:[record.data]
                                        };
                                        me.returnData(rv);
                                     }
                                })
                                me.returnData({});
                                me.regWindow.hide();
                        }
                    },{  xtype: 'button', text: '닫기' ,
                        handler:function()  {
//                          me.masterGrid.getStore().rejectChanges();
                            me.regWindow.hide();
                        }
                    }
                   ],
            items: [  
                 { fieldLabel: '거래처코드',     name:'CUSTOM_CODE', enforceMaxLength: true, maxLength: 8, readOnly:true}
                 ,{ fieldLabel: '거래처명',     name:'CUSTOM_NAME', allowBlank: false, enforceMaxLength: true, maxLength: 50}
                 ,{ fieldLabel: '구분',        name:'CUSTOM_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B015', allowBlank: false, value: '1'}
                 ,{ fieldLabel: '거래처분류',    name:'AGENT_TYPE',  xtype: 'uniCombobox', comboType:'AU',comboCode:'B055', allowBlank: false, value: '1'}
            ]
        });  
        
        me.regWindow = Ext.create('Ext.window.Window', {
            title: '거래처 빠른 입력',
            modal: true,
            closable: false,
            width: 300,                             
            height: 200,
            alwaysOnTop:89000,
            items: [me.regCustKocisForm],
            hidden:true,
            listeners : {
                show:function( window, eOpts)  {
                    me.regCustKocisForm.reset();
                    me.regCustKocisForm.body.el.scrollTo('top',0);                                   
                }
            }
        });
    },
    initComponent : function(){    
        var me  = this;
        
        me.masterGrid.focus();

        this.callParent();      
    },
    fnInitBinding : function(param) {
        var me = this;
        me.param = param;
        
        var frm= me.panelSearch.getForm();
        
//      var rdo = frm.findField('RDO');
        var fieldTxt = frm.findField('TXT_SEARCH');
        var custKocisomType = frm.findField('CUSTOM_TYPE');
        frm.setValues(param);
        if( Ext.isDefined(param)) {
//          if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
//              if(param['TYPE'] == 'VALUE') {
//                  fieldTxt.setValue(param['CUSTOM_CODE']);
//                  rdo.setValue('1');
//              } else {
//                  fieldTxt.setValue(param['CUSTOM_NAME']);
//                  rdo.setValue('2');
//              }
//          }
            //custKocisomType.setValue(param['CUSTOM_TYPE']);  //combo store 의 load 와 비동기로 값 설정이 안되어 setCustKocisomTypeCombo 사용으로 변경
            if(param['TYPE'] == 'VALUE') {
                if(!Ext.isEmpty(param['CUSTOM_CODE'])){
                    fieldTxt.setValue(param['CUSTOM_CODE']);            
                }
            }else{
                if(!Ext.isEmpty(param['CUSTOM_CODE'])){
                    fieldTxt.setValue(param['CUSTOM_CODE']);            
                }
                if(!Ext.isEmpty(param['CUSTOM_NAME'])){
                    fieldTxt.setValue(param['CUSTOM_NAME']);
                }
            }
        }

        
        var tbar = me.masterGrid._getToolBar();
        if(!Ext.isEmpty(tbar)){
            tbar[0].insert(tbar.length + 1, me.decrypBtn);
        }
        
        if(frm.isValid())   {
            this._dataLoad();
        }        
    },
     onQueryButtonDown : function() {
/*        if(!Ext.getCmp('panelSearch').getInvalidMessage()){
            return false;
        }*/
        this._dataLoad();
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
        me.close();
    },
    openRegWindow:function()    {
        var me = this;
        console.log("openRegWindow:me", me);
        me.regWindow.show();
//      var selRecord = me.masterGrid.createRow();  
//      me.regCustKocisForm.setActiveRecord(selRecord||null);
        
    },  
    _dataLoad : function() {
            var me = this;
            var param= me.panelSearch.getValues();
            if(Ext.isEmpty(param.CUSTOM_TYPE) && !Ext.isEmpty(me.param.CUSTOM_TYPE))    {
                param.CUSTOM_TYPE =me.param.CUSTOM_TYPE
            }
            console.log( "_dataLoad: ", param );
            if(me.panelSearch.isValid())    {
            	me.isLoading = true;
                me.masterGrid.getStore().load({
                    params : param,
					callback:function()	{
						me.isLoading = false;
					}
                });
            }
    }
});


