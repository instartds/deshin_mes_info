<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.ExBlnoPopup");
%>
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 

	 Unilite.defineModel('${PKGNAME}.ExBlnoPopupModel', {
	    fields: [{name: 'DIV_CODE' 				,text:'<t:message code="system.label.common.division" default="사업장"/>' 		,type:'string', comboType:'BOR120'	},
				 {name: 'BL_SER_NO'					,text:'<t:message code="system.label.trade.shipmentmanageno" default="선적관리번호"/>' 	,type:'string'	},
				 {name: 'EX_BLNO_CODE' 		,text:'<t:message code="system.label.common.blno" default="B/L번호"/>' 		,type:'string'	},
				 {name: 'BL_DATE' 						,text:'<t:message code="system.label.common.blissuedate" default="B/L발행일"/>' 	,type:'uniDate'	},
				 {name: 'SEARCH_MAN' 			,text:'<t:message code="system.label.common.importercode" default="수입자코드"/>' 		,type:'string'	},
				 {name: 'SEARCH_MAN_NM' 	,text:'<t:message code="system.label.common.importer" default="수입자"/>' 		,type:'string'	},
				 {name: 'TERMS_PRICE' 			,text:'<t:message code="system.label.common.pricecondition" default="가격조건"/>'	 	,type:'string', comboType: 'AU', comboCode: 'T005'	},
				 {name: 'PAY_TERMS' 				,text:'<t:message code="system.label.common.paycondition" default="결제조건"/>' 		,type:'string', comboType: 'AU', comboCode: 'T006'	}
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
			holdable: 'hold',
			//20190627 읽기전용여부 추가
			readOnly: wParam.READ_ONLY_YN == 'Y' ? true : false,
			colspan: 2
		}, {
			fieldLabel: '<t:message code="선적관리번호" default="선적관리번호"/>',
			xtype: 'uniTextfield',
			name: 'BL_SER_NO'	
		}, {
			fieldLabel: '<t:message code="system.label.common.blno" default="B/L번호"/>',
			xtype: 'uniTextfield',
			name: 'EX_BLNO_CODE'			
		}, {
			fieldLabel: '<t:message code="system.label.common.blissuedate" default="B/L발행일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'BL_DATE_FR',
			endFieldName: 'BL_DATE_TO'
		},
		    Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="system.label.common.importer" default="수입자"/>'
		})  
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.exBlnoPopupStore',{
							model: '${PKGNAME}.ExBlnoPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.exBlnoPopup'
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
	                     { dataIndex: 'DIV_CODE' 		,  width: 80 }
	                    ,{ dataIndex: 'BL_SER_NO'		,  width: 100 }
	                    ,{ dataIndex: 'EX_BLNO_CODE' 	,  width: 100 }
	                    ,{ dataIndex: 'BL_DATE' 		,  width: 100 }
	                    ,{ dataIndex: 'SEARCH_MAN' 		,  width: 90, hidden: true }
	                    ,{ dataIndex: 'SEARCH_MAN_NM' 	,  width: 120 }
	                    ,{ dataIndex: 'TERMS_PRICE' 	,  width: 120 }
	                    ,{ dataIndex: 'PAY_TERMS' 		,  minWidth: 90, flex: 1 }
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

