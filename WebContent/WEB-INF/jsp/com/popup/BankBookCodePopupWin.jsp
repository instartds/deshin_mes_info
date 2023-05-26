<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.BankBookCodePopup");
%>


	 Unilite.defineModel('${PKGNAME}.BankBookCodePopupModel', {
	    fields: [{name: 'CUSTOM_CODE'	 	,text: '<t:message code="system.label.common.customcode" default="거래처코드"/>' 	,type: 'string'},
	    	{name: 'CUSTOM_NAME'	 	,text: '<t:message code="system.label.common.customname" default="거래처명"/>' 	,type: 'string'},
    		{name: 'BOOK_CODE'          ,text: '<t:message code="system.label.common.bankaccountcode" default="계좌코드"/>'          ,type: 'string'},
            {name: 'BOOK_NAME'          ,text: '<t:message code="system.label.common.bankaccountname" default="계좌명"/>'           ,type: 'string'},
            
    		{name: 'BANK_CODE'	 		,text: '<t:message code="system.label.common.bankcode" default="은행코드"/>' 			,type: 'string'},
    		{name: 'BANK_NAME'	 		,text: '<t:message code="system.label.common.bankname" default="은행명"/>' 			,type: 'string'},
    		{name: 'BANK_ACCOUNT'	 	,text: '<t:message code="system.label.common.bankaccount" default="계좌번호"/>' 			,type: 'string'},
			{name: 'BANK_ACCOUNT_EXPOS'	,text:'<t:message code="system.label.common.bankaccount" default="계좌번호"/>(<t:message code="system.label.common.decodingtype" default="유형별복호화"/>)',type:'string' , defaultValue: '***************'},
    		{name: 'BANKBOOK_NAME'	 	,text: '<t:message code="system.label.common.accountholder" default="예금주"/>' 			,type: 'string'},
    	    {name: 'MAIN_BOOK_YN'       ,text: '<t:message code="system.label.common.mainaccount" default="주지급계좌"/>'        ,type: 'string', comboType:'AU',comboCode:'B131'}
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
        items: [   { xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH'}
        		  ,{ xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.custom" default="거래처"/>',     name:'CUSTOM_SEARCH'}
                  ,{ xtype: 'uniTextfield',      name:'COUSTOM_CODE', hidden: true}
                
        ]
    });                
    me.masterStore = Unilite.createStoreSimple('${PKGNAME}.bankBookCodePopupStore',{
            model: '${PKGNAME}.BankBookCodePopupModel',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                    read: 'popupService.bankBookCodePopup'
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
	                    { dataIndex: 'CUSTOM_CODE'	 		 	,  		width: 120},
	                    { dataIndex: 'CUSTOM_NAME'	 		 	,  		width: 120},
			        	{ dataIndex: 'BOOK_CODE'           	 	,       width: 120},
			            { dataIndex: 'BOOK_NAME'            	,       width: 180},
			            
						{ dataIndex: 'BANK_CODE'	 		 	,  		width: 120},
						{ dataIndex: 'BANK_NAME'	 		 	,  		width: 130},

						{ dataIndex: 'BANK_ACCOUNT_EXPOS'		,  		width: 150},
						{ dataIndex: 'BANKBOOK_NAME'	 		,  		width: 100},
			            { dataIndex: 'MAIN_BOOK_YN'       ,       width: 100}
	        ],
			listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {
					if(colName =="BANK_ACCOUNT_EXPOS") {
						//me.masterGrid.openCryptCardNoPopup(record);
						record.set('BANK_ACCOUNT_EXPOS',record.data['BANK_ACCOUNT']);
					}else {
						var rv = {
							status : "OK",
							data:[record.data]
						};
						me.returnData(rv);
					}
                    me.masterStore.commitChanges();
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
				},
				beforecelldblclick:function  (grid , td , cellIndex , record , tr , rowIndex , e , eOpts ) {					
					var records = me.masterGrid.store.data.items;
					Ext.each(records, function(record,i) {
	                    record.set('BANK_ACCOUNT_EXPOS','***************');
					});
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
		
		
		me.panelSearch.setValues(param);
		if(param['TYPE'] == 'VALUE') {
        	if(!Ext.isEmpty(param['BOOK_CODE'])){
        		fieldTxt.setValue(param['BOOK_CODE']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['BOOK_CODE'])){
        		fieldTxt.setValue(param['BOOK_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['BOOK_NAME'])){
        		fieldTxt.setValue(param['BOOK_NAME']);
        	}
        }
        
        var customTxt = frm.findField('CUSTOM_SEARCH');
        if(!Ext.isEmpty(param['CUSTOM_CODE']))	{
        	customTxt.setValue(param['CUSTOM_CODE'])
        }
        if(!Ext.isEmpty(param['CUSTOM_NAME']))	{
        	customTxt.setValue(param['CUSTOM_NAME'])
        }
		 if(!Ext.isEmpty(param['CUSTOM_CODE']) ||!Ext.isEmpty(param['CUSTOM_NAME']) || !Ext.isEmpty(param['BOOK_CODE']) || !Ext.isEmpty(param['BOOK_NAME']) )	{
		 	this._dataLoad();
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
	}
});

