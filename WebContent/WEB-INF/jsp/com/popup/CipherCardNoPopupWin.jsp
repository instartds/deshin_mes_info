<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 부서팝업
request.setAttribute("PKGNAME","Unilite.app.popup.CipherCardNoPopup");
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
				    	fieldLabel: '<t:message code="system.label.common.cardnum" default="카드번호"/>',
				    	//id:'fieldNm',
				    	width: 326,
				    	name:'DECRYP_WORD',
				    	listeners : {
										blur: function(field, The, eOpts)	{
											var newValue = field.getValue().replace(/-/g,'');
											if(isNaN(newValue)){
												alert('숫자만 입력가능합니다.');
										 		this.setValue('');
										 		return ;
										 	}						  					
										}
									}
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
            	load: 'popupService.incryptDecryptPopupForm'
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
				,
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
        
		/*
		if(param.GUBUN_FLAG =='1'){
			Ext.getCmp('fieldNm').setFieldLabel('카드번호');
			
		}else if(param.GUBUN_FLAG =='2'){
			Ext.getCmp('fieldNm').setFieldLabel('계좌번호');
			
		}else if(param.GUBUN_FLAG =='3'){
			Ext.getCmp('fieldNm').setFieldLabel('주민번호');
		}else{
			Ext.getCmp('fieldNm').setFieldLabel('');
		}
		*/
		
		var frm = me.panelSearch;
		//if(!Ext.isEmpty(param.DECRYP_WORD))	frm.setValue('DECRYP_WORD', param.DECRYP_WORD);
		
		//alert(param['CRDT_FULL_NUM']);
		if(!Ext.isEmpty(param['CRDT_FULL_NUM'])){

	        frm.setValue('INCDRC_GUBUN', 'DEC');
	        frm.setValue('INCRYP_WORD', param['CRDT_FULL_NUM']);
	        
	        this.fnIncryptDecrypt();
		}
							
		//this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onCloseBtnDown:function(){
		this.close();
	},
	onSubmitButtonDown : function()	{
        var me = this;
        var cardNo = me.panelSearch.getValue('DECRYP_WORD'); 
        if(Ext.isEmpty(cardNo)){
        	me.panelSearch.setValue('INCRYP_WORD', '');
			rv = {
				status : "OK",
				data : [{INC_WORD:''}]			
			};
			me.returnData(rv);
			me._onCloseBtnDown();
        }else{
	        me.panelSearch.setValue('INCDRC_GUBUN', 'INC');      
	        //this.fnIncryptDecrypt();
        	if(me.body) me.body.mask();
	        me.panelSearch.getForm().load({
	        	params:me.panelSearch.getValues(),
				success:function(provider, request)	{
        			if(me.body) me.body.unmask();
					if(!Ext.isEmpty(request.result)){
						//alert(provider);				
						if(me.panelSearch.getValue('INCDRC_GUBUN') == 'INC'){
							me.panelSearch.setValue('INCRYP_WORD', request.result.data.DECRYP_WORD);
							rv = {
								status : "OK",
								data : [{
									DECRYP_WORD:request.result.data.DECRYP_WORD,
									INC_WORD:request.result.data.INC_WORD
								 }]			
							};
							me.returnData(rv);
							me.close();
						}else{
							me.panelSearch.setValue('DECRYP_WORD', request.result.data.DECRYP_WORD);
						}
					}
				}
			})
        }	
              		
	},
	
	_dataLoad : function() {
		var me = this;
		var param= me.panelSearch.getValues();
		console.log( "_dataLoad: ", param );
		if(me.body) me.body.mask();
		me.isLoading = true;
		me.panelSearch.getForm().load({		
			params : param,
			callback:function()	{
				me.isLoading = false;
				if(me.body) me.body.unmask();
			},
			success:function()	{
				if(me.body) me.body.unmask();
			},
			failure:function()	{
				if(me.body) me.body.unmask();
			}
		});
	},
	

	fnIncryptDecrypt: function() {	
		var me = this;
		var param= me.panelSearch.getValues();
		if(me.body) me.body.mask();
		me.isLoading = false;
		popupService.incryptDecryptPopup(param, function(provider, response)	{
			if(me.body) me.body.unmask();
			me.isLoading = false;
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
