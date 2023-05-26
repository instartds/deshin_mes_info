<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.NegoNoPopup");
%>
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 

	 Unilite.defineModel('${PKGNAME}.NegoNoPopupModel', {
	    fields: [
	        {name: 'DIV_CODE'		             ,text:'<t:message code="system.label.common.division" default="사업장"/>'                    ,type:'string', comboType: "BOR120"  },
            {name: 'NEGO_SER_NO'		         ,text:'<t:message code="system.label.common.negomanageno" default="NEGO 관리번호"/>'               ,type:'string'  },
            {name: 'TRADE_TYPE'		             ,text:'<t:message code="system.label.common.tradetype" default="무역종류"/>'                   ,type:'string', comboType:"AU" ,comboCode: "T002"  },
            {name: 'NATION_INOUT'	             ,text:'<t:message code="system.label.common.domesticoverseasclass" default="국내외구분"/>'                  ,type:'string', comboType:"AU" ,comboCode: "T019"  },
            {name: 'PROJECT_NO'		             ,text:'<t:message code="system.label.common.projectno" default="프로젝트번호"/>'                 ,type:'string'  },
            {name: 'NEGO_DIV'		             ,text:'<t:message code="system.label.common.negodivision" default="NEGO사업장"/>'                 ,type:'string', comboType: "BOR120"  },
            {name: 'NEGO_DATE'		             ,text:'<t:message code="system.label.common.negodate" default="NEGO일"/>'                    ,type:'uniDate'  },
            {name: 'NEGO_NM'			         ,text:'<t:message code="system.label.common.negocharger" default="NEGO담당자"/>'                 ,type:'string'  },
            {name: 'NEGO_BANK'		             ,text:'<t:message code="system.label.common.negobank" default="매입은행"/>'                   ,type:'string'  },
            {name: 'IMPORTER_NM'		         ,text:'<t:message code="system.label.common.importer" default="수입자"/>'                    ,type:'string'  },
            {name: 'TERMS_PRICE'		         ,text:'TERMS_PRICE'		     ,type:'string'  },
            {name: 'PAY_METHODE1'		         ,text:'PAY_METHODE1'		     ,type:'string'  },
            {name: 'EXPORT_NM'			         ,text:'EXPORT_NM'			     ,type:'string'  },
            {name: 'OPEN_BANK'			         ,text:'OPEN_BANK'			     ,type:'string'  },
            {name: 'IMPORTER'			         ,text:'IMPORTER'			     ,type:'string'  },
            {name: 'NEGO_NO'			         ,text:'NEGO_NO'			     ,type:'string'  },
            {name: 'EXPORTER'			         ,text:'EXPORTER'			     ,type:'string'  },
            {name: 'EXPORTER_NM'		         ,text:'EXPORTER_NM'		     ,type:'string'  },
            {name: 'MONEY_UNIT'		             ,text:'MONEY_UNIT'		         ,type:'string'  },
            {name: 'PAY_TERMS'			         ,text:'PAY_TERMS'			     ,type:'string'  },
            {name: 'PAY_DURING'		             ,text:'PAY_DURING'		         ,type:'string'  },
            {name: 'EXCHAGE_COMM_RATE'	         ,text:'EXCHAGE_COMM_RATE'	     ,type:'string'  },
            {name: 'NEGO_AMT'			         ,text:'NEGO_AMT'			     ,type:'string'  },
            {name: 'EXCHANGE_RATE'		         ,text:'EXCHANGE_RATE'		     ,type:'string'  },
            {name: 'NEGO_AMT_WON'		         ,text:'NEGO_AMT_WON'		     ,type:'string'  },
            {name: 'EXPIRY_DATE'		         ,text:'EXPIRY_DATE'		     ,type:'string'  },
            {name: 'PRIME_RATE'		             ,text:'PRIME_RATE'		         ,type:'string'  },
            {name: 'FLAG_FLAW'			         ,text:'FLAG_FLAW'			     ,type:'string'  },
            {name: 'PAY_DIV'			         ,text:'PAY_DIV'			     ,type:'string'  },
            {name: 'PAY_DATE'			         ,text:'PAY_DATE'			     ,type:'string'  },
            {name: 'PAY_AMT'			         ,text:'PAY_AMT'			     ,type:'string'  },
            {name: 'PAY_EXCHANGE_RATE'	         ,text:'PAY_EXCHANGE_RATE'	     ,type:'string'  },
            {name: 'PAY_AMT_WON'		         ,text:'PAY_AMT_WON'		     ,type:'string'  },
            {name: 'AMT_SUB_PM'		             ,text:'AMT_SUB_PM'		         ,type:'string'  },
            {name: 'COLET_TYPE'		             ,text:'COLET_TYPE'		         ,type:'string'  },
            {name: 'REMARKS1'			         ,text:'REMARKS1'			     ,type:'string'  },
            {name: 'REMARKS2'			         ,text:'REMARKS2'			     ,type:'string'  }
//            {name: 'NEGO_DIV'			         ,text:'NEGO_DIV'			     ,type:'string'  }
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
        	columns: 1, 
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
			value: UserInfo.divCode
		}, {
			fieldLabel: '<t:message code="system.label.common.negomanageno" default="NEGO 관리번호"/>',
			xtype: 'uniTextfield',
			name: 'NEGO_SER_NO'	
		}, {
			fieldLabel: '<t:message code="system.label.common.negodate" default="NEGO일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'NEGO_DATE_FR',
			endFieldName: 'NEGO_DATE_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today')
			
		}]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.negoNoPopupStore',{
							model: '${PKGNAME}.NegoNoPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.negoNoPopup'
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
	                     { dataIndex: 'DIV_CODE'		             ,  width: 120 }
                        ,{ dataIndex: 'NEGO_SER_NO'		             ,  width: 100 }
                        ,{ dataIndex: 'TRADE_TYPE'		             ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'NATION_INOUT'	             ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'PROJECT_NO'		             ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'NEGO_DIV'		             ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'NEGO_DATE'		             ,  width: 100 }
                        ,{ dataIndex: 'NEGO_NM'			             ,  width: 100 }
                        ,{ dataIndex: 'NEGO_BANK'		             ,  width: 100 }
                        ,{ dataIndex: 'IMPORTER_NM'		             ,  width: 100 }
                        ,{ dataIndex: 'TERMS_PRICE'		             ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'PAY_METHODE1'		         ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'EXPORT_NM'			         ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'OPEN_BANK'			         ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'IMPORTER'			         ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'NEGO_NO'			             ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'EXPORTER'			         ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'EXPORTER_NM'		             ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'MONEY_UNIT'		             ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'PAY_TERMS'			         ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'PAY_DURING'		             ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'EXCHAGE_COMM_RATE'	         ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'NEGO_AMT'			         ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'EXCHANGE_RATE'		         ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'NEGO_AMT_WON'		         ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'EXPIRY_DATE'		             ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'PRIME_RATE'		             ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'FLAG_FLAW'			         ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'PAY_DIV'			             ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'PAY_DATE'			         ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'PAY_AMT'			             ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'PAY_EXCHANGE_RATE'	         ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'PAY_AMT_WON'		             ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'AMT_SUB_PM'		             ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'COLET_TYPE'		             ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'REMARKS1'			         ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'REMARKS2'			         ,  width: 100 , hidden: true}
                        ,{ dataIndex: 'NEGO_DIV'			         ,  width: 100 , hidden: true}
                        
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

