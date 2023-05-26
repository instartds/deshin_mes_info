<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.ExLcnoPopup");
%>
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 

	 Unilite.defineModel('${PKGNAME}.ExLcnoPopupModel', {
	    fields: [{name: 'DIV_CODE' 				,text:'<t:message code="system.label.common.division" default="사업장"/>' 		,type:'string', comboType:'BOR120'	},
				 {name: 'LC_SER_NO'					,text:'<t:message code="system.label.common.lcmanageno" default="L/C관리번호"/>' 	,type:'string'	},
				 {name: 'EX_LCNO_CODE' 		,text:'<t:message code="system.label.common.lcno" default="L/C번호"/>' 		,type:'string'	},
				 {name: 'DATE_LC_OPEN' 			,text:'<t:message code="system.label.common.opendate" default="개설일"/>' 		,type:'uniDate'	},
				 {name: 'DATE_EXP' 					,text:'<t:message code="system.label.common.availabledate" default="유효일"/>' 		,type:'uniDate'	},
				 {name: 'SEARCH_MAN' 			,text:'<t:message code="system.label.common.exportercode" default="수출자코드"/>' 		,type:'string'	},
				 {name: 'SEARCH_MAN_NM' 	,text:'<t:message code="system.label.common.exporter" default="수출자"/>' 		,type:'string'	},
				 {name: 'LC_TYPE' 						,text:'<t:message code="system.label.common.lctype" default="L/C유형"/>'	 	,type:'string', comboType:'AU',comboCode:'T030'  }				 
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
			colspan: 2
		}, {
			fieldLabel: '<t:message code="system.label.common.lcmanageno" default="L/C관리번호"/>',
			xtype: 'uniTextfield',
			name: 'LC_SER_NO'	
		}, {
			fieldLabel: '<t:message code="system.label.common.lcno" default="L/C번호"/>',
			xtype: 'uniTextfield',
			name: 'EX_LCNO_CODE'			
		}, {
			fieldLabel: '<t:message code="system.label.common.opendate" default="개설일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'LC_DATE_FR',
			endFieldName: 'LC_DATE_TO'
		},
		    Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="system.label.common.exporter" default="수출자"/>'
		})  
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.exLcnoPopupStore',{
							model: '${PKGNAME}.ExLcnoPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.exLcnoPopup'
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
	                     { dataIndex: 'DIV_CODE' 			,  width: 80 }
	                    ,{ dataIndex: 'LC_SER_NO'			,  width: 100 }
	                    ,{ dataIndex: 'EX_LCNO_CODE' 		,  width: 100 }
	                    ,{ dataIndex: 'DATE_LC_OPEN' 		,  width: 100 }
	                    ,{ dataIndex: 'DATE_EXP' 			,  width: 90 }
	                    ,{ dataIndex: 'SEARCH_MAN' 			,  width: 120, hidden: true }
	                    ,{ dataIndex: 'SEARCH_MAN_NM' 		,  width: 120 }
	                    ,{ dataIndex: 'LC_TYPE' 			,  minWidth: 90, flex: 1 }
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
		me.panelSearch.setValue('LC_DATE_TO', new Date());
		me.panelSearch.setValue('LC_DATE_FR', UniDate.get('startOfMonth', me.panelSearch.getValue('LC_DATE_TO')));
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

