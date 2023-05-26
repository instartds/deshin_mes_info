<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.BudgKocisPopup");
%>
<t:ExtComboStore useScriptTag="false" items="${COMBO_SAVE_CODE}" storeId="saveCode" /> <!--계좌코드-->
<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->

	 Unilite.defineModel('${PKGNAME}.BudgKocisPopupModel', {
	    fields: [   
	        {name: 'ACCT_NO'            , text: '<t:message code="system.label.common.bankaccountcode" default="계좌코드"/>'          , type: 'string'},
            {name: 'SAVE_NAME'          , text: '<t:message code="system.label.common.bankaccountname" default="계좌명"/>'          , type: 'string'},
            {name: 'BANK_ACCOUNT'       , text: '<t:message code="system.label.common.bankaccount" default="계좌번호"/>'          , type: 'string'},
    	    {name: 'BUDG_CODE'          , text: '<t:message code="system.label.common.budgcode" default="예산코드"/>'          , type: 'string'},
            {name: 'BUDG_NAME'          , text: '<t:message code="system.label.common.budgname" default="예산명"/>'          , type: 'string'},
            {name: 'BUDG_I'             , text: '<t:message code="system.label.common.budgamount" default="예산사용금액"/>(<t:message code="system.label.common.localization" default="현지화"/>)'          , type: 'float',decimalPrecision: 2, format:'0,000.00'},
            {name: 'EX_DATE'            , text: '<t:message code="system.label.common.transferdate" default="이체일"/>'          , type: 'uniDate'},
            {name: 'CURR_UNIT'          , text: '<t:message code="system.label.common.currencyunit" default="화폐단위"/>'          , type: 'string',comboType:'AU', comboCode:'B004', displayField: 'value'},
            {name: 'CURR_RATE'          , text: '<t:message code="system.label.common.exchangerate" default="환율"/>'            , type: 'uniER'},
            {name: 'CURR_AMT'           , text: '<t:message code="system.label.common.foreigncurrencyamount" default="외화금액"/>'          , type: 'float',decimalPrecision: 2, format:'0,000.00'},
            {name: 'DEPT_CODE'          , text: '<t:message code="system.label.common.departmencode" default="부서코드"/>'          , type: 'string'},
            {name: 'USE_YN'             , text: '<t:message code="system.label.common.useyn" default="사용여부"/>'          , type: 'string',comboType:'AU', comboCode:'A020'}

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
    var wParam = this.param;
    var t1= false, t2 = false;
    if( Ext.isDefined(wParam)) {
        if(wParam['TYPE'] == 'VALUE') {
            t1 = true;
            t2 = false;
            
        } else {
            t1 = false;
            t2 = true;
            
        }
    }
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
        items: [{
                xtype: 'radiogroup',                            
                fieldLabel: '<t:message code="system.label.common.bankaccounttype" default="계좌구분"/>',
//                id:'saveCodeGubun',
                colspan:2,
                items: [{
                    boxLabel: '<t:message code="system.label.common.thisaccount" default="본계좌"/>', 
                    width: 60,
                    name: 'SAVE_CODE_GUBUN',
                    inputValue: '1',
                    checked:true
                },{
                    boxLabel: '<t:message code="system.label.common.exaccount" default="이체계좌"/>', 
                    width: 80,
                    name: 'SAVE_CODE_GUBUN',
                    inputValue: '2'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {   
                       me.onQueryButtonDown();
                    }
                }
            
            },
        	{ xtype: 'uniTextfield', 		fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH'},
        	
            { xtype: 'uniCombobox',        fieldLabel: '<t:message code="system.label.common.bankaccountcode" default="계좌코드"/>',     name:'ACCT_NO',
              store: Ext.data.StoreManager.lookup('saveCode'),
                listeners:{
                    specialkey: function(field, e){
                        if (e.getKey() == e.ENTER) {
                            me.onQueryButtonDown();
                        }
                    }
                }
            },
            { xtype: 'uniTextfield',      name:'ADD_QUERY', hidden: true},
            { xtype: 'uniTextfield',      name:'AC_YYYY', hidden: true},
            { xtype: 'uniTextfield',      name:'DEPT_CODE', hidden: true},
            { xtype: 'uniTextfield',      name:'ACCNT', hidden: true},
            { xtype: 'uniTextfield',      name:'NEXT_GUBUN', hidden: true},
            { xtype: 'uniTextfield',      name:'BUDG_GUBUN', hidden: true}
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.budgKocisPopupStore',{
							model: '${PKGNAME}.BudgKocisPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.budgKocisPopup'
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
	        columns:[
                { dataIndex: 'ACCT_NO'              ,width: 100 , hidden:true},
                { dataIndex: 'SAVE_NAME'            ,width: 150 },
                { dataIndex: 'BANK_ACCOUNT'            ,width: 200 , hidden:true},
                { dataIndex: 'BUDG_CODE'            ,width: 170 ,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                    }
                },
                { dataIndex: 'BUDG_NAME'            ,width: 150 },
                { dataIndex: 'BUDG_I'               ,width: 150 },
                { dataIndex: 'EX_DATE'              ,width: 100 },
                { dataIndex: 'CURR_UNIT'            ,width: 100, align: 'center' },
                { dataIndex: 'CURR_RATE'            ,width: 100 },
                { dataIndex: 'CURR_AMT'             ,width: 150 },
                { dataIndex: 'DEPT_CODE'            ,width: 150 , hidden:true},
                { dataIndex: 'USE_YN'               ,width: 150 , hidden:true}
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
		me.panelSearch.setValues(param);
		if(param['TYPE'] == 'VALUE') {
        	if(!Ext.isEmpty(param['BUDG_CODE'])){
        		fieldTxt.setValue(param['BUDG_CODE']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['BUDG_CODE'])){
        		fieldTxt.setValue(param['BUDG_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['BUDG_NAME'])){
        		fieldTxt.setValue(param['BUDG_NAME']);
        	}
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
//		param.budgNameInfoList = budgNameList;	//예산목록	
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

