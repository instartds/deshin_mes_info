<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.ComAba900Popup");
%>



	 Unilite.defineModel('${PKGNAME}.ComAba900PopupModel', {
	    fields: [{name: 'ORG_ACCNT' 		,text:'<t:message code="system.label.common.accountcode" default="계정코드"/>' 		,type:'string'	},
				 {name: 'ORG_ACCNT_NAME'	,text:'<t:message code="system.label.common.accountname" default="계정명"/>' 			,type:'string'	},
				 {name: 'ORG_AC_DATE' 		,text:'<t:message code="system.label.common.slipdate" default="전표일"/>' 			,type:'uniDate'	},
				 {name: 'ORG_SLIP_NUM' 		,text:'<t:message code="system.label.common.slipno" default="전표번호"/>' 		,type:'string'	},
				 {name: 'ORG_SLIP_SEQ'		,text:'<t:message code="system.label.common.slipseq" default="전표순번"/>' 		,type:'string'	},
				 {name: 'ORG_AMT_I' 		,text:'<t:message code="system.label.common.occuramount" default="발생금액"/>' 		,type:'uniPrice'	},
				 {name: 'BLN_I' 			,text:'<t:message code="system.label.common.balanceamount" default="잔액"/>' 			,type:'uniPrice'	},
				 {name: 'PEND_NAME'			,text:'<t:message code="system.label.common.pendcode2" default="미결항목코드"/>' 	,type:'string'	},
				 {name: 'PEND_DATA_CODE' 	,text:'<t:message code="system.label.common.penddatacode2" default="미결코드"/>' 		,type:'string'	},
				 {name: 'PEND_DATA_NAME' 	,text:'<t:message code="system.label.common.pendcode" default="미결항목"/>' 		,type:'string'	},
				 {name: 'DEPT_NAME' 		,text:'<t:message code="system.label.common.affiliatedeptname" default="귀속부서"/>' 		,type:'string'	}	
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
        items: [{
					fieldLabel: '<t:message code="system.label.common.slipdate" default="전표일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'AC_DATE_FR',
					endFieldName: 'AC_DATE_TO',
		            startDate:  UniDate.get('startOfMonth'),
		            endDate:  UniDate.get('today')					
				},
			
				Unilite.popup('ACCNT',{
					fieldLabel: '<t:message code="system.label.common.accountitem" default="계정과목"/>', 
					valueFieldWidth: 90,
					textFieldWidth: 140,
					valueFieldName:'ACCNT_CODE',
				    textFieldName:'ACCNT_NAME',
				    listeners: {
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'ADD_QUERY' : "SLIP_SW = 'Y' AND PROFIT_DIVI = 'A' AND GROUP_YN = 'N'"
                                }
                                popup.setExtParam(param);
                            }
                        }
                    }
				}),
				Unilite.popup('DEPT', {
					valueFieldWidth:80, 
					textFieldWidth:140
				}),
        		{ xtype: 'uniTextfield'		, fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>'		, name:'TXT_SEARCH', hidden: true},
        		{ xtype: 'uniTextfield'		, name:'SUB_CODE'			, hidden: true}
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.comAba900PopupStore',{
							model: '${PKGNAME}.ComAba900PopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.comAba900Popup'
					            }
					        }
					}),
	        uniOpt:{
                expandLastColumn: false,
                useRowNumberer: false,
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
	                     { dataIndex: 'ORG_ACCNT' 		,  width: 120 }
	                    ,{ dataIndex: 'ORG_ACCNT_NAME'	,  width: 150 }
	                    ,{ dataIndex: 'ORG_AC_DATE' 		,  width: 100 }
	                    ,{ dataIndex: 'ORG_SLIP_NUM' 		,  width: 70 }
	                    ,{ dataIndex: 'ORG_SLIP_SEQ'	,  width: 70 }
	                    ,{ dataIndex: 'ORG_AMT_I' 		,  width: 110 }
	                    ,{ dataIndex: 'BLN_I'			,  width: 110 }
	                    ,{ dataIndex: 'PEND_NAME'			,  width: 120 }
	                    ,{ dataIndex: 'PEND_DATA_CODE' 		,  width: 120 }
	                    ,{ dataIndex: 'PEND_DATA_NAME'	,  width: 120 }
	                    ,{ dataIndex: 'DEPT_NAME' 		,  width: 130, hidden: true }	 	
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
		//var fieldTxt = frm.findField('TXT_SEARCH');
		var fieldTxt = frm.findField('ACCNT_CODE');
		me.panelSearch.setValues(param);
		if(param['TYPE'] == 'VALUE') {
        	if(!Ext.isEmpty(param['ORG_ACCNT'])){
        		fieldTxt.setValue(param['ORG_ACCNT']);        	
        	}
        }else{
/*        	if(!Ext.isEmpty(param['ORG_ACCNT'])){
        		fieldTxt.setValue(param['ORG_ACCNT']);        	
        	}*/
        	if(!Ext.isEmpty(param['ORG_ACCNT_NAME'])){
        		fieldTxt.setValue(param['ORG_ACCNT_NAME']);
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

