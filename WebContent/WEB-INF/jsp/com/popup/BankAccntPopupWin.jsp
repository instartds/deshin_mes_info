<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.BankAccntPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	


	 Unilite.defineModel('${PKGNAME}.BankAccntPopupModel', {
	    fields: [{name: 'SAVE_CODE'				,text:'<t:message code="system.label.common.bankbookcode" default="통장코드"/>' 		,type:'string'	},
				 {name: 'SAVE_NAME' 			,text:'<t:message code="system.label.common.bankbook" default="통장명"/>' 		,type:'string'	},
				 {name: 'BANK_ACCNT_CODE' 		,text:'<t:message code="system.label.common.bankaccount" default="계좌번호"/>(DB)' 	,type:'string'	},
				 {name: 'BANK_ACCNT_MASK' 		,text:'<t:message code="system.label.common.bankaccount" default="계좌번호"/>' 	    ,type:'string', defaultValue:'***************'},
				 {name: 'BANK_ACCNT_EXPOS' 		,text:'<t:message code="system.label.common.bankaccount" default="계좌번호"/>' 		,type:'string'	},
				 {name: 'BANK_CODE' 			,text:'<t:message code="system.label.common.bankcode" default="은행코드"/>' 		,type:'string'	},
				 {name: 'BANK_NAME' 			,text:'<t:message code="system.label.common.bankname" default="은행명"/>' 		,type:'string'	}
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
        items: [  { xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.bankbook" default="통장명"/>',     name:'SAVE_NAME'}   
        		 ,{ xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.bankaccount" default="계좌번호"/>',    name:'BANK_ACCOUNT'}    //계좌번호 암호화로 인하여 조회조건 분리
//        			{ xtype: 'uniTextfield', fieldLabel: '조회조건',     name:'TXT_SEARCH'}
//                 ,{ fieldLabel: ' ', 
//                    xtype: 'radiogroup', width: 280,  
//                    items:[ {inputValue: '1', boxLabel:'계좌번호순', name: 'RDO', checked: true, width: 100},
//                            {inputValue: '2', boxLabel:'통장명',  name: 'RDO'/*, checked: t2*/} ]
//                 }
                 ,{ xtype: 'uniTextfield',      name:'ACCNT', hidden: true}
                 ,{ xtype: 'uniTextfield',      name:'DIV_CODE', hidden: true}
                 ,{ xtype: 'uniTextfield',      name:'INCRYP_WORD', hidden: true}
                 ,{ xtype: 'uniTextfield',      name:'INCDRC_GUBUN', hidden: true}
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.bankAccntPopupStore',{
							model: '${PKGNAME}.BankAccntPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.bankAccntPopup'
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
	                     { dataIndex: 'SAVE_CODE'			,  width: 80 }
	                    ,{ dataIndex: 'SAVE_NAME' 			,  width: 180 }
	                    ,{ dataIndex: 'BANK_ACCNT_MASK' 	,  width: 180,align:'center' }
	                    ,{ dataIndex: 'BANK_ACCNT_EXPOS' 	,  width: 180, hidden:true }	                    
	                    ,{ dataIndex: 'BANK_CODE' 			,  width: 80 }
	                    ,{ dataIndex: 'BANK_NAME' 			,  minWidth: 120, flex: 1 }
	                    ,{ dataIndex: 'BANK_ACCNT_CODE' 	,  width: 180, hidden:true }
	        ],
			listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {
					if(colName =="BANK_ACCNT_MASK") {
						record.set('BANK_ACCNT_MASK',record.data['BANK_ACCNT_EXPOS']);
					}else {
						var rv = {
							status : "OK",
							data:[record.data]
						};
						me.returnData(rv);
					}
					
				},
				beforecelldblclick:function  (grid , td , cellIndex , record , tr , rowIndex , e , eOpts ) {					
					var records = me.masterGrid.store.data.items;
					Ext.each(records, function(record,i) {
						if(record.data['BANK_ACCNT_MASK'] != '***************'){
							record.set('BANK_ACCNT_MASK','***************');
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
		var fieldTxt = frm.findField('BANK_ACCOUNT');
		
		me.panelSearch.setValues(param);
		
		if(param['TYPE'] == 'VALUE') {
        	if(!Ext.isEmpty(param['BANK_ACCNT_CODE'])){        		
        		fieldTxt.setValue(param['BANK_ACCNT_CODE']);        	
        	}
        }else{
        	//alert(param['BANK_ACCNT_CODE']);
        	if(!Ext.isEmpty(param['BANK_ACCNT_CODE'])){
        		me.panelSearch.setValue('INCDRC_GUBUN', 'DEC');
				me.panelSearch.setValue('INCRYP_WORD', param['BANK_ACCNT_CODE']);
				        
				this.fnDecrypt();   //함수내에서 복호화후 조회
        	}else{                           //빈값
        		this._dataLoad();
        	}
        }
		
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
	},
	
	//조회조건 계좌번호 복호화
	fnDecrypt: function() {	
		var me = this;
		var param= me.panelSearch.getValues();
		popupService.incryptDecryptPopup(param, function(provider, response)	{
			if(!Ext.isEmpty(provider)){
				me.panelSearch.setValue('BANK_ACCOUNT', provider);
				
				me._dataLoad();				
			}
		})
	}
});

