<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.RealtyPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	


	 Unilite.defineModel('${PKGNAME}.RealtyPopupModel', {
	    fields: [{name: 'DIV_CODE' 				,text:'<t:message code="system.label.common.divisioncode" default="사업장코드"/>' 			,type:'string'	},
			     {name: 'BILL_DIV_NAME' 		,text:'<t:message code="system.label.common.newdivision" default="신규사업장"/>' 			,type:'string'	},
			     {name: 'REALTY_CODE' 			,text:'<t:message code="system.label.common.realpropertycode" default="부동산코드"/>' 			,type:'string'	},
			     {name: 'REALTY_NAME' 			,text:'<t:message code="system.label.common.realproperty" default="부동산"/>' 			,type:'string'	},
			     {name: 'DONG' 						,text:'<t:message code="system.label.common.dong" default="동"/>' 				,type:'string'	},
			     {name: 'UP_UNDER' 					,text:'<t:message code="system.label.common.updndertype" default="지상/지하구분"/>' 		,type:'string'	},
			     {name: 'UP_FLOOR' 					,text:'<t:message code="system.label.common.upfloor" default="층"/>' 				,type:'string'	},
			     {name: 'HOUSE' 						,text:'<t:message code="system.label.common.house" default="호"/>' 				,type:'string'	},
			     {name: 'HOUSE_CNT' 				,text:'<t:message code="system.label.common.housecnt" default="호실수"/>' 			,type:'string'	},
			     {name: 'AREA' 							,text:'<t:message code="system.label.common.area" default="면적"/>' 				,type:'string'	}
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
        items: [  { fieldLabel: '<t:message code="system.label.common.useflag" default="사용유무"/>',		name:'USE_YN', hidden:true}
        		 ,{
					fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>'  ,
					name: 'BILL_DIV_CODE',
					xtype:'uniCombobox',
					comboType:'BOR120',
					colspan: 2
				}
                 ,{ xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
//                 ,{ fieldLabel: ' ', 
//                    xtype: 'radiogroup', width: 230,  
//                    items:[ {inputValue: '1', boxLabel:'코드순', name: 'RDO', checked: t1},
//                            {inputValue: '2', boxLabel:'이름순',  name: 'RDO', checked: t2} ]
//                 }
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.custPopupStore',{
							model: '${PKGNAME}.RealtyPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.realtyPopup'
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
	                     { dataIndex: 'DIV_CODE' 			,  width: 100, hidden: true }
	                    ,{ dataIndex: 'BILL_DIV_NAME' 		,  width: 100 }
	                    ,{ dataIndex: 'REALTY_CODE' 		,  width: 100 }
	                    ,{ dataIndex: 'REALTY_NAME' 		,  width: 150 }
	                    ,{ dataIndex: 'DONG' 				,  width: 100, hidden: true }
	                    ,{ dataIndex: 'UP_UNDER' 			,  width: 100, hidden: true }
	                    ,{ dataIndex: 'UP_FLOOR' 			,  width: 70 }
	                    ,{ dataIndex: 'HOUSE' 				,  width: 70 }
	                    ,{ dataIndex: 'HOUSE_CNT' 			,  width: 70 }
	                    ,{ dataIndex: 'AREA' 				,  minWidth: 80, flex: 1 }           
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
		var frm= me.panelSearch.getForm();
		var fieldTxt = frm.findField('TXT_SEARCH');
		me.panelSearch.setValues(param);
		if(param['TYPE'] == 'VALUE') {
        	if(!Ext.isEmpty(param['REALTY_CODE'])){
        		fieldTxt.setValue(param['REALTY_CODE']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['REALTY_CODE'])){
        		fieldTxt.setValue(param['REALTY_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['REALTY_NAME'])){
        		fieldTxt.setValue(param['REALTY_NAME']);
        	}
        }
//        var me = this;
//		
//		var frm= me.panelSearch.getForm();
//		
//		var rdo = frm.findField('RDO');
//		var fieldTxt = frm.findField('TXT_SEARCH');
//
//		if( Ext.isDefined(param)) {
//			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
//				if(param['TYPE'] == 'VALUE') {
//					fieldTxt.setValue(param['REALTY_CODE']);
//					rdo.setValue({ RDO : '1'});
//				} else {
//					fieldTxt.setValue(param['REALTY_NAME']);
//					rdo.setValue({ RDO : '2'});
//				}
//			}
//			me.panelSearch.setValues(param);
//		}
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

