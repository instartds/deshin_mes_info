<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.CommonPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	


	 Unilite.defineModel('${PKGNAME}.CommonPopupModel', {
	    fields: [{name: 'COMMON_CODE' 	,text:'<t:message code="system.label.common.code" default="코드"/>' 	,type:'string'	},
				 {name: 'COMMON_NAME'	,text:'<t:message code="system.label.common.name" default="명"/>' 	,type:'string'	}
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
                 },
                 { xtype: 'uniTextfield',      name:'BSA_CODE', hidden: true}
                
        ]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.commonPopupStore',{
							model: '${PKGNAME}.CommonPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.commonPopup'
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
	                     { dataIndex: 'COMMON_CODE' 	,  width: 230 }
	                    ,{ dataIndex: 'COMMON_NAME'		,  width: 270 } 
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
					fieldTxt.setValue(param['COMMON_CODE']);
					rdo.setValue({ RDO : '1'});
				} else {
					fieldTxt.setValue(param['COMMON_NAME']);
					rdo.setValue({ RDO : '2'});
				}
			}
			me.panelSearch.setValues(param);
		}
		
		me.masterGrid.getColumn('COMMON_CODE').setText(param.HEADER + '코드');
		me.masterGrid.getColumn('COMMON_NAME').setText(param.HEADER + '명');
		
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

