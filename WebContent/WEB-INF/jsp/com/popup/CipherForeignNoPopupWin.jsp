<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 부서팝업
request.setAttribute("PKGNAME","Unilite.app.popup.CipherForeignNoPopup");
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
	    
	    var inputYn = wParam.INPUT_YN;
		if(Ext.isEmpty(inputYn)){
			inputYn = 'Y';
		}
		if(inputYn == 'Y'){
			this.uniOpt.btnSubmitHide = false;
			
		}else{
			
			this.uniOpt.btnSubmitHide  = true;
			
		}
		
/**
 * 검색조건 (Search Panel)
 * @type 
 */

		me.panelSearch =  Unilite.createSearchForm('',{
		    layout : {type : 'table', columns : 1, tableAttrs: {
		        style: {
		            width: '120%'
		        }
		    }},		 
		    items: [{
				    	fieldLabel: '<t:message code="system.label.common.foreignnum" default="외국인등록번호"/>',
				    	width: 326,
				    	name:'DECRYP_WORD'
//				    	listeners : {
//										blur: function(field, The, eOpts)	{
//											var newValue = field.getValue().replace(/-/g,'');
//											if(isNaN(newValue)){
//												alert('숫자만 입력가능합니다.');
//										 		this.setValue('');
//										 		return ;
//										 	}						  					
//										}
//									}
				    },{
						fieldLabel: '',
				    	name:'INCRYP_WORD',
				    	hidden: true
				    },{
						fieldLabel: '<t:message code="system.label.common.incryptype" default="암호화구분"/>',
				    	name:'INCDRC_GUBUN',
				    	hidden: true
				    }
		    ],
            api: {
            	load: 'popupService.incryptDecryptPopup'
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
					            	read: 'popupService.incryptDecryptPopup'
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

		var frm = me.panelSearch;
		if(!Ext.isEmpty(param.DECRYP_WORD))	frm.setValue('DECRYP_WORD', param.DECRYP_WORD);
		
		//alert(param['CRDT_FULL_NUM']);
		if(!Ext.isEmpty(param['FOREIGN_NUM'])){

	        frm.setValue('INCDRC_GUBUN', 'DEC');
	        frm.setValue('INCRYP_WORD', param['FOREIGN_NUM']);
	        
	        this.fnIncryptDecrypt();
		}
							
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        var me = this;
        var foreignNo = me.panelSearch.getValue('DECRYP_WORD'); 
        if(Ext.isEmpty(foreignNo)){
        	me.panelSearch.setValue('INCRYP_WORD', '');
			rv = {
				status : "OK",
				data : [{INC_WORD:''}]			
			};
			me.returnData(rv);
        }else{
	        me.panelSearch.setValue('INCDRC_GUBUN', 'INC');      
	        this.fnIncryptDecrypt();
        }	
	},
	
	_dataLoad : function() {
		var me = this;
		var param= me.panelSearch.getValues();
		console.log( "_dataLoad: ", param );
		me.panelSearch.getForm().load({		
			params : param
		});
	},
	

	fnIncryptDecrypt: function() {	
		var me = this;
		var param= me.panelSearch.getValues();
		popupService.incryptDecryptPopup(param, function(provider, response)	{
			
			if(!Ext.isEmpty(provider)){
				//alert(provider);				
				if(me.panelSearch.getValue('INCDRC_GUBUN') == 'INC'){
					me.panelSearch.setValue('INCRYP_WORD', provider);
					rv = {
						status : "OK",
						data : [{INC_WORD:provider}]			
					};
					me.returnData(rv);
				}else{
					me.panelSearch.setValue('DECRYP_WORD', provider);
				}
								
			}
		})
	}
	
});
