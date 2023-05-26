<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.IncomOfferNoPopup");
%>
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 

	 Unilite.defineModel('${PKGNAME}.IncomOfferNoPopupModel', {
	    fields: [
	        {name: 'DIV_CODE'           , text: '<t:message code="system.label.common.division" default="사업장"/>'               , type: 'string',comboType:'BOR120'},
            {name: 'OFFER_NO'          , text: '<t:message code="system.label.common.offermanageno" default="OFFER관리번호"/>'         , type: 'string'},
            {name: 'DATE_DEPART'        , text: '<t:message code="system.label.common.writtendate" default="작성일"/>'               , type: 'uniDate'},
            {name: 'IMPORTER'           , text: '<t:message code="system.label.common.importer" default="수입자"/>'               , type: 'string'},
            {name: 'IMPORTERNM'         , text: '<t:message code="system.label.common.importer" default="수입자"/>'               , type: 'string'},
            {name: 'EXPORTER'           , text: '<t:message code="system.label.common.exporter" default="수출자"/>'               , type: 'string'},
            {name: 'EXPORTERNM'         , text: '<t:message code="system.label.common.exporter" default="수출자"/>'               , type: 'string'},
            {name: 'PAY_TERMS'          , text: '<t:message code="system.label.common.paycondition" default="결제조건"/>'              , type: 'string',comboType:'AU',comboCode:'T006'},
            {name: 'PAY_DURING'         , text: '<t:message code="system.label.base.payperiod" default="결제기간"/>'              , type: 'string'},
            {name: 'TERMS_PRICE'        , text: '<t:message code="system.label.common.pricecondition" default="가격조건"/>'              , type: 'string',comboType:'AU',comboCode:'T005'},
            {name: 'PAY_METHODE'        , text: '<t:message code="system.label.common.payingterm" default="결제방법"/>'              , type: 'string'},
            {name: 'PROJECT_NO'         , text: 'PROJECT_NO'          , type: 'string'}
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
            
            readOnly:true,
            value: UserInfo.divCode,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    
                }
            }
        },{
            fieldLabel: '<t:message code="system.label.common.offermanageno" default="OFFER관리번호"/>',
            name: 'OFFER_NO',
            xtype: 'uniTextfield',
            labelWidth: 100,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                }
            }
        },{ 
            fieldLabel: '<t:message code="system.label.common.writtendate" default="작성일"/>',
            xtype: 'uniDateRangefield',
            startFieldName: 'FR_DATE',
            endFieldName: 'TO_DATE',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            allowBlank: false,
            //holdable: 'hold',
            width: 315,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
            }
        },
        Unilite.popup('AGENT_CUST', {
            fieldLabel: '<t:message code="system.label.common.exporter" default="수출자"/>',
            valueFieldName: 'EXPORTER', //EXPORTER
            textFieldName: 'EXPORTER_NM', 
            textFieldWidth:175, 
            labelWidth: 100,
            //validateBlank:false, 
            popupWidth: 710,
            listeners: {
                        onSelected: {
                            fn: function(records, type) {
                            },
                            scope: this
                        },
                        onClear: function(type) {
                        }
                    }
        }),
        { 
            name: 'TERMS_PRICE',         
            fieldLabel: '<t:message code="system.label.common.pricecondition" default="가격조건"/>',      
            xtype:'uniCombobox',   
            comboType:'AU', 
            comboCode:'T005',
            
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    
                }
            }
         },
         {
            fieldLabel: '<t:message code="system.label.common.payingterm" default="결제방법"/>',
            name: 'PAY_METHODE', 
            xtype : 'uniCombobox',
            comboType:'AU',
            labelWidth: 100,
            comboCode:'T016',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                }
            }
        },
        {
            fieldLabel: 'TYPE',
            name: 'TYPE',
            xtype: 'uniTextfield',
            hidden:true,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                }
            }
        }]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.incomOfferNoPopupStore',{
							model: '${PKGNAME}.IncomOfferNoPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.incomOfferNoPopup'
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
	                    {dataIndex: 'DIV_CODE'              , width: 120},
                        {dataIndex: 'OFFER_NO'              , width: 120},
                        {dataIndex: 'DATE_DEPART'           , width: 120},
                        {dataIndex: 'EXPORTERNM'            , width: 135},
                        {dataIndex: 'PAY_TERMS'             , width: 120},
                        {dataIndex: 'TERMS_PRICE'           , width: 120},
                        {dataIndex: 'PAY_METHODE'           , width: 120}
                        
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

