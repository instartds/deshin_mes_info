<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.IncomBlNoPopup");
%>
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 

	 Unilite.defineModel('${PKGNAME}.IncomBlNoPopupModel', {
	    fields: [
	    	{name: 'DIV_CODE'              ,text: '<t:message code="system.label.common.division" default="사업장"/>'           , type: 'string', comboType: "BOR120"},
            {name: 'BL_SER_NO'             ,text: '<t:message code="system.label.common.blmanageno" default="B/L관리번호"/>'      , type: 'string'},
            {name: 'BL_NO'                 ,text: '<t:message code="system.label.common.blno" default="B/L번호"/>'          , type: 'string'},
            {name: 'BL_DATE'               ,text: '<t:message code="system.label.common.bldate" default="B/L일"/>'            , type: 'uniDate'},
            {name: 'IMPORTER_NM'           ,text: '<t:message code="system.label.common.importer" default="수입자"/>'           , type: 'string'},
            {name: 'EXPORTER'              ,text: '<t:message code="system.label.common.exporter" default="수출자"/>'           , type: 'string'},
            {name: 'EXPORTER_NM'           ,text: '<t:message code="system.label.common.exporter" default="수출자"/>'           , type: 'string'},
            {name: 'PAY_TEMRS'             ,text: '<t:message code="system.label.common.paycondition" default="결제조건"/>'         , type: 'string'},
            {name: 'TERMS_PRICE'           ,text: '<t:message code="system.label.common.paycondition" default="결제조건"/>'         , type: 'string'},
            {name: 'PAY_METHODE'           ,text: '<t:message code="system.label.common.payingterm" default="결제방법"/>'         , type: 'string'},
            
            {name: 'EXPENSE_FLAG'          ,text: 'EXPENSE_FLAG'         , type: 'string'},
            {name: 'AMT_UNIT'              ,text: 'AMT_UNIT'             , type: 'string'},
            {name: 'PAY_DURING'            ,text: 'PAY_DURING'           , type: 'string'},
            {name: 'SO_SER_NO'             ,text: 'SO_SER_NO'            , type: 'string'},
            {name: 'LC_SER_NO'             ,text: 'LC_SER_NO'            , type: 'string'},
            {name: 'VESSEL_NAME'           ,text: 'VESSEL_NAME'          , type: 'string'},
            {name: 'VESSEL_NATION_CODE'    ,text: 'VESSEL_NATION_CODE'   , type: 'string'},
            {name: 'DEST_PORT'             ,text: 'DEST_PORT'            , type: 'string'},
            {name: 'DEST_PORT_NM'          ,text: 'DEST_PORT_NM'         , type: 'string'},
            {name: 'SHIP_PORT'             ,text: 'SHIP_PORT'            , type: 'string'},
            {name: 'SHIP_PORT_NM'          ,text: 'SHIP_PORT_NM'         , type: 'string'},
            {name: 'PACKING_TYPE'          ,text: 'PACKING_TYPE'         , type: 'string'},
            {name: 'GROSS_WEIGHT'          ,text: 'GROSS_WEIGHT'         , type: 'string'},
            {name: 'WEIGHT_UNIT'           ,text: 'WEIGHT_UNIT'          , type: 'string'},
            {name: 'DATE_SHIPPING'         ,text: 'DATE_SHIPPING'        , type: 'string'},
            {name: 'EXCHANGE_RATE'         ,text: 'EXCHANGE_RATE'        , type: 'string'},
            {name: 'BL_AMT'                ,text: 'BL_AMT'               , type: 'string'},
            {name: 'BL_AMT_WON'            ,text: 'BL_AMT_WON'           , type: 'string'},
            {name: 'TRADE_TYPE'            ,text: 'TRADE_TYPE'           , type: 'string'},
            {name: 'NATION_INOUT'          ,text: 'NATION_INOUT'         , type: 'string'},
            {name: 'PROJECT_NO'            ,text: 'PROJECT_NO'           , type: 'string'},
            {name: 'PROJECT_NAME'          ,text: 'PROJECT_NAME'         , type: 'string'},
            {name: 'RECEIVE_AMT'           ,text: 'RECEIVE_AMT'          , type: 'string'},
            {name: 'INVOICE_NO'            ,text: 'INVOICE_NO'           , type: 'string'},
            {name: 'CUSTOMS'               ,text: 'CUSTOMS'              , type: 'string'},
            {name: 'EP_TYPE'               ,text: 'EP_TYPE'              , type: 'string'},
            {name: 'LC_NO'                 ,text: 'LC_NO'                , type: 'string'}
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
            fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            colspan: 2,
            readOnly: true
        },{
            fieldLabel: '<t:message code="system.label.common.blmanageno" default="B/L관리번호"/>',
            xtype: 'uniTextfield',
            name: 'BL_SER_NO'
        },{
            fieldLabel: '<t:message code="system.label.common.blno" default="B/L번호"/>',
            xtype: 'uniTextfield',
            name: 'BL_NO'
        },{
            fieldLabel: '<t:message code="system.label.common.bldate" default="B/L일"/>',
            xtype: 'uniDateRangefield',
            startFieldName: 'BL_DATE_FR',
            endFieldName: 'BL_DATE_TO',              
            allowBlank: false, 
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today')
        },
        Unilite.popup('AGENT_CUST',{
            fieldLabel: '<t:message code="system.label.common.exporter" default="수출자"/>',   
            valueFieldName:'EXPORTER',
            textFieldName:'EXPORTER_NM',
//                extParam: {'CUSTOM_TYPE':'1,2,3'},
            listeners: {
                applyextparam: function(popup) {
//                        popup.setExtParam({'CUSTOM_TYPE':'1,2,3'});
                }
            }
        })]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.incomBlNoPopupStore',{
							model: '${PKGNAME}.IncomBlNoPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.incomBlNoPopup'
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
                 { dataIndex: 'DIV_CODE'            ,  width:100},
                 { dataIndex: 'BL_SER_NO'           ,  width:100},
                 { dataIndex: 'BL_NO'               ,  width:100},
                 { dataIndex: 'BL_DATE'             ,  width:100},
                 { dataIndex: 'IMPORTER_NM'         ,  width:200},
                 { dataIndex: 'EXPORTER'            ,  width:200},
                 { dataIndex: 'EXPORTER_NM'         ,  width:200},
                 { dataIndex: 'PAY_TEMRS'           ,  width:100},
                 { dataIndex: 'TERMS_PRICE'         ,  width:100},
                 { dataIndex: 'PAY_METHODE'         ,  width:100},
                 { dataIndex: 'EXPENSE_FLAG'        ,  width:100, hidden: true},
                 { dataIndex: 'AMT_UNIT'            ,  width:100, hidden: true},
                 { dataIndex: 'PAY_DURING'          ,  width:100, hidden: true},
                 { dataIndex: 'SO_SER_NO'           ,  width:100, hidden: true},
                 { dataIndex: 'LC_SER_NO'           ,  width:100, hidden: true},
                 { dataIndex: 'VESSEL_NAME'         ,  width:100, hidden: true},
                 { dataIndex: 'VESSEL_NATION_CODE'  ,  width:100, hidden: true},
                 { dataIndex: 'DEST_PORT'           ,  width:100, hidden: true},
                 { dataIndex: 'DEST_PORT_NM'        ,  width:100, hidden: true},
                 { dataIndex: 'SHIP_PORT'           ,  width:100, hidden: true},
                 { dataIndex: 'SHIP_PORT_NM'        ,  width:100, hidden: true},
                 { dataIndex: 'PACKING_TYPE'        ,  width:100, hidden: true},
                 { dataIndex: 'GROSS_WEIGHT'        ,  width:100, hidden: true},
                 { dataIndex: 'WEIGHT_UNIT'         ,  width:100, hidden: true},
                 { dataIndex: 'DATE_SHIPPING'       ,  width:100, hidden: true},
                 { dataIndex: 'EXCHANGE_RATE'       ,  width:100, hidden: true},
                 { dataIndex: 'BL_AMT'              ,  width:100, hidden: true},
                 { dataIndex: 'BL_AMT_WON'          ,  width:100, hidden: true},
                 { dataIndex: 'TRADE_TYPE'          ,  width:100, hidden: true},
                 { dataIndex: 'NATION_INOUT'        ,  width:100, hidden: true},
                 { dataIndex: 'PROJECT_NO'          ,  width:100, hidden: true},
                 { dataIndex: 'PROJECT_NAME'        ,  width:100, hidden: true},
                 { dataIndex: 'RECEIVE_AMT'         ,  width:100, hidden: true},
                 { dataIndex: 'INVOICE_NO'          ,  width:100, hidden: true},
                 { dataIndex: 'CUSTOMS'             ,  width:100, hidden: true},
                 { dataIndex: 'EP_TYPE'             ,  width:100, hidden: true},
                 { dataIndex: 'LC_NO'               ,  width:100, hidden: true}
            
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
		me.panelSearch.setValue('BL_DATE_TO', new Date());
		me.panelSearch.setValue('BL_DATE_FR', UniDate.get('startOfMonth', me.panelSearch.getValue('BL_DATE_TO')));
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

