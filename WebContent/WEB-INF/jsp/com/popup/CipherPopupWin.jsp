<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 부서팝업
request.setAttribute("PKGNAME","Unilite.app.popup.CipherPopup");
%>



	/**
	 *   Model 정의 
	 * @type 
	 */
Unilite.defineModel('${PKGNAME}CipherPopupModel', {
    extend: 'Ext.data.Model',
    fields: [ 	 {name: 'INCRYP_WORD' 		,text:'<t:message code="system.label.common.incrypword" default="암호화단어"/>'     ,type:'string'	}
				,{name: 'DECRYP_WORD' 		,text:'<t:message code="system.label.common.decrypword" default="복호화단어"/>' 		,type:'string'	}				
		    ]
});				


Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    uniOpt:{
    	btnQueryHide:true,
    	btnSubmitHide:false,
    	btnCloseHide:false
    },
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
/**
 * 검색조건 (Search Panel)
 * @type 
 */

		me.panelSearch =  Unilite.createSearchForm('',{
		    layout : {type : 'table', columns : 1, tableAttrs: {
		        style: {
		            width: '100%'
		        }
		    }},		 
		    items: [{
				    	fieldLabel: '<t:message code="system.label.common.decrypword" default="복호화단어"/>',
				    	name:'DECRYP_WORD'
				    },{
						fieldLabel: '<t:message code="system.label.common.incrypword" default="암호화단어"/>',
				    	name:'INCRYP_WORD'
				    	// ,hidden: true
				    }
		    ],
            api: {
            	load: 'popupService.incryptPopup'
            }
		});  
		
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		/*
		me.masterGrid =  Unilite.createGrid('', {
			store: Unilite.createStoreSimple('${PKGNAME}CipherPopupMasterStore',{
							model: '${PKGNAME}CipherPopupModel',
					        autoLoad: false,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.incryptPopup'
					            }
					        }
					}),
			uniOpt:{
				expandLastColumn: false,
				pivot : {
					use : false
				}
			},
			selModel:'rowmodel',
		    columns:  [        
		           		 { dataIndex: 'TREE_CODE'		,width: 100 }  
						,{ dataIndex: 'TREE_NAME'		,minWidth: 220, flex: 1 }
						,{ dataIndex: 'DIV_CODE'		,width: 220, hidden: true }
		    ] ,
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
		*/
		
		
		//config.items = [me.panelSearch,	me.masterGrid];
		config.items = [me.panelSearch];
     	me.callParent(arguments);
    },			
	initComponent : function(){    
    	var me  = this;
        
        me.panelSearch.focus();
        
    	this.callParent();    	
    },    
	fnInitBinding : function(param) {
		var me = this;

		alert(param['CRDT_FULL_NUM']);
		//alert(param.CRDT_FULL_NUM);
		var frm= me.panelSearch;
		if(!Ext.isEmpty(param.DECRYP_WORD))	frm.setValue('DECRYP_WORD', param.DECRYP_WORD);

        if(param) {			
			frm.setValue('INCRYP_WORD', param['CRDT_FULL_NUM']);
		}

					
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        var me = this;
		// var selectRecord = me.masterGrid.getSelectedRecord();
		/*
	 	var rv ;
		if(selectRecord)	{
		 	rv = {
				status : "OK",
				data:[selectRecord.data]
			};
		}
		me.returnData(rv);
		*/
		
		this._dataLoad();
		
	},
	_dataLoad : function() {
		var me = this;
		var param= me.panelSearch.getValues();
		console.log( "_dataLoad: ", param );
		//me.panelSearch.getStore().load({
		me.isLoading = true;
		me.panelSearch.getForm().load({		
			params : param,
			callback:function()	{
				me.isLoading = false;
			}
		});
	}
});
