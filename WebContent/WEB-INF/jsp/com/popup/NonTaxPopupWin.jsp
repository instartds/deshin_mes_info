<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.NonTaxPopup");
%>

	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장 
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="H220" />            // 비과세한도종류(구분)
	


	 Unilite.defineModel('${PKGNAME}.NonTaxPopupModel', {
	    fields: [{name: 'NONTAX_CODE' 				,text:'<t:message code="system.label.common.nontaxicode" default="비과세코드"/>' 		,type:'string'	},
				 {name: 'NONTAX_CODE_NAME'	        ,text:'<t:message code="system.label.common.nontaxcodename" default="비과세항목"/>' 		,type:'string'	},
				 {name: 'TAX_EXEMP_KIND'            ,text:'<t:message code="system.label.common.classfication" default="구분"/>'         ,comboType:'AU', comboCode:'H220' ,type:'string'  },
				 {name: 'TAX_EXEMP_LMT'             ,text:'<t:message code="system.label.common.taxamountlmti" default="비과세한도액"/>'      ,type:'uniPrice'  },
				 {name: 'SEND_YN' 					,text:'<t:message code="system.label.common.sendyn" default="자료제출여부"/>'             ,type:'string'	},
				 {name: 'PRINT_LOCATION'            ,text:'<t:message code="system.label.common.printlocation" default="기재란"/>'         ,type:'string'  }
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
        	fieldLabel: '<t:message code="system.label.common.taxyear" default="세액년도"/>',
        	xtype: 'uniTextfield',
        	value: new Date().getFullYear(),
        	readOnly: true,
        	name: 'PAY_YM_FR'
//        	onStoreLoad: function(combo, store, records, successful, eOpts) {
//				combo.setValue(me.param['PAY_YM_FR']);
//        	}
       	}, {
			fieldLabel: '<t:message code="system.label.common.nontaxicode" default="비과세코드"/>',
				xtype: 'uniTextfield',
				name: 'NONTAX_CODE'	,
                listeners:{
                    specialkey: function(field, e){
                        if (e.getKey() == e.ENTER) {
                           me.onQueryButtonDown();
                        }
                    }
                }
            }]
    });                
    me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
            store: Unilite.createStoreSimple('${PKGNAME}.NonTaxPopupStore',{
					model: '${PKGNAME}.NonTaxPopupModel',
			        autoLoad: false,
			        proxy: {
			            type: 'direct',
			            api: {
			            	read: 'popupService.nonTaxPopup'
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
	                     { dataIndex: 'NONTAX_CODE' 		,  width: 90, align:'center' }
	                    ,{ dataIndex: 'NONTAX_CODE_NAME'	,  width: 300 }
	                    ,{ dataIndex: 'TAX_EXEMP_KIND'      ,  width: 50, align:'center' }
	                    ,{ dataIndex: 'TAX_EXEMP_LMT'       ,  width: 100 }
	                    ,{ dataIndex: 'SEND_YN'            ,  width: 100, align:'center' }
	                    ,{ dataIndex: 'PRINT_LOCATION' 		,  width: 100 , hidden:true}
	                    
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
		var frm= this.panelSearch.getForm();
		
		var payYmFr = frm.findField('PAY_YM_FR');
		var nonTaxCode = frm.findField('NONTAX_CODE');
		payYmFr.setValue(param['PAY_YM_FR']);
		nonTaxCode.setValue(param['NONTAX_CODE']);
			
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

