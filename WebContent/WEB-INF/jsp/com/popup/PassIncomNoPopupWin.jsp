<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.PassIncomNoPopup");
%>
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	 Unilite.defineModel('${PKGNAME}.PassIncomNoPopupModel', {
	    fields: [
	        {name: 'DIV_CODE'                     ,text:'<t:message code="system.label.common.division" default="사업장"/>'                  ,type:'string', comboType: "BOR120" },
            {name: 'TRADE_TYPE'                   ,text:'<t:message code="system.label.common.tradetype" default="무역종류"/>'                ,type:'string'},
            {name: 'PASS_INCOM_NO'                ,text:'<t:message code="system.label.common.customsmanagementno" default="통관관리번호"/>'             ,type:'string'},
            {name: 'INVOICE_DATE'                 ,text:'<t:message code="system.label.common.customdate" default="통관일"/>'                 ,type:'uniDate'},
            {name: 'IMPORTER'                     ,text:'<t:message code="system.label.common.importer" default="수입자"/>'                 ,type:'string'},
            {name: 'IMPORTER_NM'                  ,text:'<t:message code="system.label.common.importer" default="수입자"/>'                 ,type:'string'},
            {name: 'EXPORTER'                     ,text:'<t:message code="system.label.common.exporter" default="수출자"/>'                 ,type:'string'},
            {name: 'EXPORTER_NM'                  ,text:'<t:message code="system.label.common.exporter" default="수출자"/>'                 ,type:'string'},
            {name: 'PAY_TERMS'                    ,text:'<t:message code="system.label.common.paycondition" default="결제조건"/>'                ,type:'string'},
            {name: 'TERMS_PRICE'                  ,text:'<t:message code="system.label.common.pricecondition" default="가격조건"/>'                ,type:'string'},
            {name: 'PASS_EXCHANGE_RATE'           ,text:'<t:message code="system.label.common.exchangerate" default="환율"/>'                   ,type:'string'},
            {name: 'PASS_AMT_UNIT'                ,text:'<t:message code="system.label.common.currencyunit" default="화폐단위"/>'                ,type:'string'},
            {name: 'PROJECT_NO'                   ,text:'<t:message code="system.label.common.projectno" default="프로젝트번호"/>'             ,type:'string'},
            {name: 'PROJECT_NAME'                 ,text:'<t:message code="system.label.common.projectname" default="프로젝트명"/>'              ,type:'string'},
            {name: 'SO_SER_NO'                    ,text:'<t:message code="system.label.common.offerno" default="OFFER번호"/>'             ,type:'string'},
            {name: 'LC_SER_NO'                    ,text:'<t:message code="system.label.common.lcmanageno" default="L/C관리번호"/>'            ,type:'string'},
            {name: 'LC_NO'                        ,text:'<t:message code="system.label.common.lcno" default="L/C번호"/>'               ,type:'string'},
            {name: 'BL_SER_NO'                    ,text:'<t:message code="system.label.common.blmanageno" default="B/L관리번호"/>'            ,type:'string'},
            {name: 'BL_NO'                        ,text:'<t:message code="system.label.common.blno" default="B/L번호"/>'              ,type:'string'},
//            {name: 'EXPENSE_FLAG'                 ,text:'EXPENSE_FLAG'        ,type:'string'},
            {name: 'REMARKS1'                     ,text:'<t:message code="system.label.common.remarks" default="비고"/>1'                ,type:'string'},
            {name: 'REMARKS2'                     ,text:'<t:message code="system.label.common.remarks" default="비고"/>2'                ,type:'string'},
            {name: 'REMARKS3'                     ,text:'<t:message code="system.label.common.remarks" default="비고"/>2'                ,type:'string'}
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
            fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>'  ,
            name: 'DIV_CODE',
            xtype:'uniCombobox',
            comboType:'BOR120',
            readOnly: true
        },{
            fieldLabel: '<t:message code="system.label.common.customsmanagementno" default="통관관리번호"/>',
            xtype: 'uniTextfield',
            name: 'PASS_SER_NO'
        },{
            fieldLabel: '<t:message code="system.label.common.blno" default="B/L번호"/>',
            xtype: 'uniTextfield',
            name: 'BL_NO'
        }, {
            fieldLabel: '<t:message code="system.label.common.customdate" default="통관일"/>',
            xtype: 'uniDateRangefield',
            startFieldName: 'INVOICE_DATE_FR',
            endFieldName: 'INVOICE_DATE_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            allowBlank:false
        },
            Unilite.popup('AGENT_CUST',{
            fieldLabel: '<t:message code="system.label.common.exporter" default="수출자"/>',            
            validateBlank: false, 
            valueFieldName:'EXPORTER',
            textFieldName:'EXPORTER_NM',
//            extParam: {'AGENT_CUST_FILTER':'1,2'},
            listeners: {
                applyextparam: function(popup) {
                    popup.setExtParam({'AGENT_CUST_FILTER':'1,2'});
                    popup.setExtParam({'CUSTOM_TYPE':'1,2'});
                }
            }
        }),{
            fieldLabel: '<t:message code="system.label.common.paycondition" default="결제조건"/>',
            name: 'PAY_TERMS',
            xtype: 'uniCombobox',               
            comboType: 'AU',
            comboCode: 'T006'
        },{
            fieldLabel: '<t:message code="system.label.common.pricecondition" default="가격조건"/>',
            name: 'TERMS_PRICE',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'T005'
        }]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.passIncomNoPopupStore',{
							model: '${PKGNAME}.PassIncomNoPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.passIncomNoPopup'
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
                 { dataIndex: 'DIV_CODE'                     , width: 100 },
                 { dataIndex: 'TRADE_TYPE'                   , width: 100, hidden: true },
                 { dataIndex: 'PASS_INCOM_NO'                , width: 100 },
                 { dataIndex: 'INVOICE_DATE'                 , width: 100 },
                 { dataIndex: 'IMPORTER'                     , width: 100, hidden: true },
                 { dataIndex: 'IMPORTER_NM'                  , width: 100, hidden: true },
                 { dataIndex: 'EXPORTER'                     , width: 100, hidden: true },
                 { dataIndex: 'EXPORTER_NM'                  , width: 100 },
                 { dataIndex: 'PAY_TERMS'                    , width: 100 },
                 { dataIndex: 'TERMS_PRICE'                  , width: 100 },
                 { dataIndex: 'PASS_EXCHANGE_RATE'           , width: 100, hidden: true },
                 { dataIndex: 'PASS_AMT_UNIT'                , width: 100, hidden: true },
                 { dataIndex: 'PROJECT_NO'                   , width: 100, hidden: true },
                 { dataIndex: 'PROJECT_NAME'                 , width: 100, hidden: true },
                 { dataIndex: 'SO_SER_NO'                    , width: 100 },
                 { dataIndex: 'LC_SER_NO'                    , width: 100 },
                 { dataIndex: 'LC_NO'                        , width: 100 },
                 { dataIndex: 'BL_SER_NO'                    , width: 100, hidden: true },
                 { dataIndex: 'BL_NO'                        , width: 100 },
//                 { dataIndex: 'EXPENSE_FLAG'                 , width: 100 },
                 { dataIndex: 'REMARKS1'                     , width: 100, hidden: true },
                 { dataIndex: 'REMARKS2'                     , width: 100, hidden: true },
                 { dataIndex: 'REMARKS3'                     , width: 100, hidden: true }
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
//		
//		var frm= me.panelSearch.getForm();
//		
//		var rdo = frm.findField('RDO');
//		var fieldTxt = frm.findField('TXT_SEARCH');
//		me.panelSearch.setValue('PAY_DATE_FR', new Date());
//		me.panelSearch.setValue('PAY_DATE_TO', UniDate.get('startOfMonth', me.panelSearch.getValue('BL_DATE_TO')));
		if( Ext.isDefined(param)) {
//			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
//				if(param['TYPE'] == 'VALUE') {
//					fieldTxt.setValue(param['ASSET_CODE']);
//					rdo.setValue({ RDO : '1'});
//				} else {
//					fieldTxt.setValue(param['ASSET_NAME']);
//					rdo.setValue({ RDO : '2'});
//				}
//			}
			me.panelSearch.setValues(param);
		}
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
	 	if(!this.panelSearch.getInvalidMessage()) return;
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

