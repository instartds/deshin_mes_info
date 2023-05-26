<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.ComAba210Popup");
%>



	 Unilite.defineModel('${PKGNAME}.ComAba210PopupModel', {
	    fields: [{name: 'COM_ABA210_CODE' 	,text:'<t:message code="system.label.common.manageitemcode" default="관리항목코드"/>' 		,type:'string'	},
				 {name: 'COM_ABA210_NAME'	,text:'<t:message code="system.label.common.manageitem" default="관리항목"/>' 			,type:'string'	},
				 {name: 'REF_CODE1' 		,text:'<t:message code="system.label.common.refcode" default="관련코드"/>1' 			,type:'string'	},
				 {name: 'REF_CODE2' 		,text:'<t:message code="system.label.common.refcode" default="관련코드"/>2' 			,type:'string'	}
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
        items: [{ xtype: 'uniTextfield'		, fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>'		, name:'TXT_SEARCH',
                    listeners:{
                        specialkey: function(field, e){
                            if (e.getKey() == e.ENTER) {
                               me.onQueryButtonDown();
                            }
                        }
                    }
                },
        		{ xtype: 'uniTextfield'		, name:'SUB_CODE'			, hidden: true}
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.comAba210PopupStore',{
							model: '${PKGNAME}.ComAba210PopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.comAba210Popup'
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
	                     { dataIndex: 'COM_ABA210_CODE' ,  width: 180 }
	                    ,{ dataIndex: 'COM_ABA210_NAME'	,  width: 200 }
	                    ,{ dataIndex: 'REF_CODE1' 		,  width: 130 }
	                    ,{ dataIndex: 'REF_CODE2' 		,  minWidth: 130, flex: 1 }
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
        	if(!Ext.isEmpty(param['COM_ABA210_CODE'])){
        		fieldTxt.setValue(param['COM_ABA210_CODE']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['COM_ABA210_CODE'])){
        		fieldTxt.setValue(param['COM_ABA210_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['COM_ABA210_NAME'])){
        		fieldTxt.setValue(param['COM_ABA210_NAME']);
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

