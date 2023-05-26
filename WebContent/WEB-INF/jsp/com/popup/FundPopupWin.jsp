<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.FundPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	


	 Unilite.defineModel('${PKGNAME}.FundPopupModel', {
	    fields: [{name: 'ASSET_CODE' 		,text:'<t:message code="system.label.common.assetscode" default="자산코드"/>' 	,type:'string'	},
				 {name: 'ASSET_NAME'			,text:'<t:message code="system.label.common.assetsname" default="자산명"/>' 	,type:'string'	},
				 {name: 'ACCNT' 					,text:'<t:message code="system.label.common.accountcode" default="계정코드"/>' 	,type:'string'	},
				 {name: 'ACCNT_NAME' 		,text:'<t:message code="system.label.common.accountitemname" default="계정과목명"/>' 	,type:'string'	},
				 {name: 'AC_DATE' 				,text:'<t:message code="system.label.common.acqdate" default="취득일"/>' 	,type:'uniDate'	},
				 {name: 'AC_AMT_I' 				,text:'<t:message code="system.label.common.acamount" default="취득가액"/>' 	,type:'uniPrice'	},
				 {name: 'ACQ_Q' 					,text:'<t:message code="system.label.common.acquestqty" default="취득수량"/>' 	,type:'uniQty'	},
				 {name: 'DRB_YEAR' 				,text:'<t:message code="system.label.common.contentyear" default="내용년수"/>' 	,type:'int'	},
				 {name: 'DEPRECTION' 			,text:'<t:message code="system.label.common.deprection" default="상각률"/>' 	,type:'uniPercent'	}
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
        items: [  { xtype: 'uniTextfield', fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',
                    listeners:{
                        specialkey: function(field, e){
                            if (e.getKey() == e.ENTER) {
                               me.onQueryButtonDown();
                            }
                        }
                    }
                }
                 ,{ fieldLabel: ' ', 
                    xtype: 'radiogroup', width: 230,  
                    items:[ {inputValue: '1', boxLabel:'<t:message code="system.label.common.codeinorder" default="코드순"/>', name: 'RDO', checked: t1},
                            {inputValue: '2', boxLabel:'<t:message code="system.label.common.nameinorder" default="이름순"/>',  name: 'RDO', checked: t2} ]
                 }
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.fundPopupStore',{
							model: '${PKGNAME}.FundPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.fundPopup'
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
	                     { dataIndex: 'ASSET_CODE' 	,  width: 80 }
	                    ,{ dataIndex: 'ASSET_NAME'	,  width: 120 }
	                    ,{ dataIndex: 'ACCNT' 		,  width: 80 }
	                    ,{ dataIndex: 'ACCNT_NAME' 	,  width: 120 }
	                    ,{ dataIndex: 'AC_DATE' 	,  width: 90 }
	                    ,{ dataIndex: 'AC_AMT_I' 	,  width: 90 }
	                    ,{ dataIndex: 'ACQ_Q' 		,  width: 90 }
	                    ,{ dataIndex: 'DRB_YEAR' 	,  width: 80 }
	                    ,{ dataIndex: 'DEPRECTION' 	,  minWidth: 80, flex: 1 }  
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
		
		var rdo = frm.findField('RDO');
		var fieldTxt = frm.findField('TXT_SEARCH');

		if( Ext.isDefined(param)) {
			if(Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
				if(param['TYPE'] == 'VALUE') {
					fieldTxt.setValue(param['ASSET_CODE']);
					rdo.setValue({ RDO : '1'});
				} else {
					fieldTxt.setValue(param['ASSET_NAME']);
					rdo.setValue({ RDO : '2'});
				}
			}
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

