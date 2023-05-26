<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.AsNumPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	


	 Unilite.defineModel('${PKGNAME}.AsNumPopupModel', {
	    fields: [{name: 'AS_NUM' 			,text:'<t:message code="system.label.common.receiptno" default="접수번호"/>' 	,type:'string'	},
				 {name: 'ACCEPT_DATE'		,text:'<t:message code="system.label.common.receiptdate" default="접수일"/>' 		,type:'uniDate'	},
				 {name: 'ACCEPT_PRSN' 		,text:'<t:message code="system.label.common.receptionist" default="접수자"/>' 		,type:'string'	},
				 {name: 'AS_CUSTOMER_NM' 	,text:'<t:message code="system.label.common.requester" default="요청자"/>' 		,type:'string'	},
				 {name: 'ACCEPT_GUBUN' 		,text:'<t:message code="system.label.common.accepttype" default="접수구분"/>' 	,type:'string'	},
				 {name: 'FINISH_YN' 		,text:'<t:message code="system.label.common.processstatus" default="진행상태"/>' 	,type:'string'	},
				 {name: 'ORDER_NUM' 		,text:'<t:message code="system.label.common.sono" default="수주번호"/>' 	,type:'string'	},
				 {name: 'AS_CUSTOMER_CD' 	,text:'<t:message code="system.label.common.soplace" default="수주처"/>' 		,type:'string'	},
				 {name: 'AS_CUSTOMER_NAME' 	,text:'<t:message code="system.label.common.soplacename" default="수주처명"/>' 		,type:'string'	}
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
        items: [  { xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.receiptno" default="접수번호"/>',     name:'TXT_SEARCH',
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
                    ,{
						fieldLabel: '<t:message code="system.label.common.receiptdate" default="접수일"/>',
					    width: 315,
			            xtype: 'uniDateRangefield',
			            startFieldName: 'FR_DATE',
			            endFieldName: 'TO_DATE',
			            onStartDateChange: function(field, newValue, oldValue, eOpts) {
			            	
					    },
					    onEndDateChange: function(field, newValue, oldValue, eOpts) {
					    	
					    }
			        },
			        { xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.receptionist" default="접수자"/>',     name:'ACCEPT_PRSN'}
			        ,{ xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.sono" default="수주번호"/>',     name:'ORDER_NUM'}
			       ,{
						fieldLabel: '<t:message code="system.label.common.accepttype" default="접수구분"/>',
						name: 'ACCEPT_GUBUN',
						xtype:'uniCombobox',
						comboType:'AU', 
						comboCode:'S801',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
							}
						}
					}
			       ,{
						fieldLabel: '<t:message code="system.label.common.processstatus" default="진행상태"/>',
						name: 'FINISH_YN',
						xtype:'uniCombobox',
						comboType:'AU', 
						comboCode:'B046',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
							}
						}
					}
                 ,{ fieldLabel: ' ', 
                    xtype: 'radiogroup', width: 230,  
                    items:[ {inputValue: '1', boxLabel:'<t:message code="system.label.common.codeinorder" default="코드순"/>', name: 'RDO', checked: t1},
                            {inputValue: '2', boxLabel:'<t:message code="system.label.common.nameinorder" default="이름순"/>',  name: 'RDO', checked: t2} ]
                 }
                 ,{ xtype: 'uniTextfield',      name:'DIV_CODE', hidden:true}
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.AsNumPopupStore',{
							model: '${PKGNAME}.AsNumPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.asNumPopup'
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
	                     { dataIndex: 'AS_NUM' 				,  width: 130 }
	                    ,{ dataIndex: 'ACCEPT_DATE'			,  width: 80 }
	                    ,{ dataIndex: 'ACCEPT_PRSN' 		,  width: 90  , align:'center'}
	                    ,{ dataIndex: 'AS_CUSTOMER_NM' 		,  width: 90 , align:'center' }
	                    ,{ dataIndex: 'ACCEPT_GUBUN' 		,  width: 80 , align:'center' }
	                    ,{ dataIndex: 'FINISH_YN' 			,  width: 80  , align:'center'}
	                    ,{ dataIndex: 'ORDER_NUM' 			,  width: 90 }
	                    ,{ dataIndex: 'AS_CUSTOMER_CD' 		,  width: 93  , align:'center'}
	                    ,{ dataIndex: 'AS_CUSTOMER_NAME' 	,  width: 150 }
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
		
		var frm= me.panelSearch;
//		var rdo = frm.findField('RDO');
//		var fieldTxt = frm.findField('TXT_SEARCH');
		
		
		if(param['AS_NUM'] && param['AS_NUM']!='')	frm.setValue('TXT_SEARCH', param['AS_NUM']);
		

		/*if( Ext.isDefined(param)) {
			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
					fieldTxt.setValue(param['AS_NUM']);
					fieldTxt.setValue(param['DIV_CODE']);
			}
			me.panelSearch.setValues(param);
		}*/
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

