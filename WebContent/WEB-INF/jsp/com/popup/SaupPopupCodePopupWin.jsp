<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 사업소득자 팝업
request.setAttribute("PKGNAME","Unilite.app.popup.SaupPopupCode");
%>



	/**
	 *   Model 정의 
	 * @type 
	 */
Unilite.defineModel('${PKGNAME}.SaupPopupCodeModel', {  
    fields: [ 	 {name: 'SAUP_POPUP_CODE' 	,text:' ' 		,type:'string'	}
				,{name: 'SAUP_POPUP_NAME' 	,text:' ' 		,type:'string'	}
				,{name: 'SUB_CODE' 			,text:' ' 		,type:'string'	}
				,{name: 'CODE_NAME' 		,text:' ' 		,type:'string'	}
				,{name: 'REF_CODE1' 		,text:' ' 		,type:'string'	}
				,{name: 'REF_CODE2' 		,text:' ' 		,type:'string'	}
				,{name: 'REF_CODE3' 		,text:' ' 		,type:'string'	}
				,{name: 'REF_CODE4' 		,text:' ' 		,type:'string'	}
				,{name: 'REF_CODE5' 		,text:' ' 		,type:'string'	}
			]
	}); 

	
	
	
/**
 * 검색조건 (Search Panel)
 * @type 
 */
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    constructor : function(config) {
        var me = this;
        if (config) {
            Ext.apply(me, config);
        }
        
        var wParam = this.param;
		var code   = wParam.PARAM_MAIN_CODE;
		var columns = [];
		
		if(code == 'HC01'){
			 columns =  [{dataIndex: 'SAUP_POPUP_CODE' 	,width:60	, text :'<t:message code="system.label.common.code" default="코드"/>'}
						,{dataIndex: 'SAUP_POPUP_NAME' 	,width:60	, text :'<t:message code="system.label.common.saupname" default="명의"/>'}
						,{dataIndex: 'REF_CODE1' 		,width:250	, text :'<t:message code="system.label.common.realnameclass" default="실지명의구분"/>'}
						,{dataIndex: 'REF_CODE2' 		,width:250	, text :'<t:message code="system.label.common.realnameclass" default="실지명의구분"/>'}
						,{dataIndex: 'REF_CODE3' 		,width:250	, text :'<t:message code="system.label.common.usenum" default="사용번호"/>'}	
		    	] 
		}
		else if(code == 'HC02'){
			columns =  [ {dataIndex: 'SAUP_POPUP_CODE' 	,width:60	, hidden: true}
						,{dataIndex: 'SAUP_POPUP_NAME' 	,width:60	, hidden: true}
						,{dataIndex: 'SUB_CODE' 			,width:80		, text :'<t:message code="system.label.common.code" default="코드"/>'}
						,{dataIndex: 'CODE_NAME' 		,width:200	, text :'<t:message code="system.label.common.ded" default="소득자"/>'}
						,{dataIndex: 'REF_CODE1' 		,width:450	, text :'<t:message code="system.label.common.dedtype" default="소득유형"/>'}
						,{dataIndex: 'REF_CODE2' 		,width:250	, text :'<t:message code="system.label.common.dedtype" default="소득유형"/>'}
						,{dataIndex: 'REF_CODE3' 		,width:120	, text :'<t:message code="system.label.common.interestded" default="이자소득"/>'}
						,{dataIndex: 'REF_CODE4' 		,width:120	, text :'<t:message code="system.label.common.allocationded" default="배당소득"/>(<t:message code="system.label.common.general" default="일반"/>)'}
						,{dataIndex: 'REF_CODE5' 		,width:120	, text :'<t:message code="system.label.common.allocationded" default="배당소득"/>(<t:message code="system.label.common.imitation" default="의제"/>)'}
						
		    	] 
		}
		else if(code == 'HC03'){	// 채권이자구분
			columns =  [ 
						 {dataIndex: 'SUB_CODE' 		,width:80	, text : '<t:message code="system.label.common.code" default="코드"/>'}
						,{dataIndex: 'CODE_NAME' 		,width:700	, text : '<t:message code="system.label.common.incomekind" default="소득종류"/>'}		
		    	] 
		}
		else if(code == 'HC04'){
			columns =  [ {dataIndex: 'SAUP_POPUP_CODE' 	,width:60	, hidden: true}
						,{dataIndex: 'SAUP_POPUP_NAME' 	,width:60	, hidden: true}
						,{dataIndex: 'SUB_CODE' 		,width:80	, text :'<t:message code="system.label.common.worknessary" default="작업필요"/>'}
						,{dataIndex: 'CODE_NAME' 		,width:150	, text :'<t:message code="system.label.common.worknessary" default="작업필요"/>'}
						,{dataIndex: 'REF_CODE1' 		,width:400	, hidden: true}
						,{dataIndex: 'REF_CODE2' 		,width:250	, hidden: true}
						,{dataIndex: 'REF_CODE3' 		,width:250	, hidden: true}
						,{dataIndex: 'REF_CODE4' 		,width:250	, hidden: true}
						,{dataIndex: 'REF_CODE5' 		,width:250	, hidden: true}
						
		    	] 
		}
		else if(code == 'HC05'){
			columns =  [ 
						 {dataIndex: 'SUB_CODE' 		,width:80	, text : '<t:message code="system.label.common.code" default="코드"/>'}
						,{dataIndex: 'CODE_NAME' 		,width:600	, text : '<t:message code="system.label.common.incomekind" default="소득종류"/>'}		
		    	]
		}
		else if(code == 'HC06'){		//조세특례
			columns =  [ 
						 {dataIndex: 'SUB_CODE' 		,width:80	, text : '<t:message code="system.label.common.code" default="코드"/>'}
						,{dataIndex: 'CODE_NAME' 		,width:600	, text : '<t:message code="system.label.common.incomekind" default="소득종류"/>'}		
		    	] 
		}
		
		else if(code == 'HC07'){		//2012 년 이후
			columns =  [ 
						 {dataIndex: 'SUB_CODE' 		,width:80	, text : '<t:message code="system.label.common.code" default="코드"/>'}
						,{dataIndex: 'CODE_NAME' 		,width:80	, text : '<t:message code="system.label.common.ded" default="소득자"/>'}
						,{dataIndex: 'REF_CODE1' 		,width:150	, text : '<t:message code="system.label.common.dedtype" default="소득유형"/>'}
						,{dataIndex: 'REF_CODE2' 		,width:400	, text : '<t:message code="system.label.common.dedtype" default="소득유형"/>'}
		    	] 
		}
        
        
        
	    /**
	     * 검색조건 (Search Panel)
	     * @type 
	     */
	    /*var wParam = this.param;
	    var t1= false, t2 = false;
	    if( Ext.isDefined(wParam)) {
	        if(wParam['TYPE'] == 'VALUE') {
	            t1 = true;
	            t2 = false;
	            
	        } else {
	            t1 = false;
	            t2 = true;
	            
	        }
	    }*/


		me.panelSearch =  Unilite.createSearchForm('',{
		    layout : {type : 'table', columns : 2, tableAttrs: {
		        style: {
		            width: '100%'
		        }
		    }},
		    items: [ 
		    		 { fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',  xtype: 'uniTextfield' ,
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    },
		    		 { fieldLabel: '<t:message code="system.label.common.parammaincode" default="파라미터 공통코드"/>',  name:'PARAM_MAIN_CODE',  xtype: 'uniTextfield' ,hidden:true},
		    		 { fieldLabel: '<t:message code="system.label.common.incometype" default="소득구분"/>',  name:'DED_TYPE'		 ,  xtype: 'uniTextfield' ,hidden:true}]
		});  

		
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		me.masterGrid =  Unilite.createGrid('', {
			store: Unilite.createStoreSimple('${PKGNAME}.saupPopupCodeMasterStore',{
							model: '${PKGNAME}.SaupPopupCodeModel',
					        autoLoad: true,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.saupPopupCode'
					            }
					        },
					        listeners: {
					        	/*load: function(store) {
					        		
					        		// HCD100T 의 공통코드에 따라 Header 값 변경
						    		if(me.panelSearch.getValue('PARAM_MAIN_CODE') == 'HC01'){
						    			me.masterGrid.getColumn('SAUP_POPUP_CODE').setText('<t:message code="system.label.common.code" default="코드"/>');
						    			me.masterGrid.getColumn('SAUP_POPUP_NAME').setText('<t:message code="system.label.common.saupname" default="명의"/>');
						    			me.masterGrid.getColumn('SUB_CODE').setHidden(true);
						    			me.masterGrid.getColumn('CODE_NAME').setHidden(true);
						    			me.masterGrid.getColumn('REF_CODE1').setText('<t:message code="system.label.common.realnameclass" default="실지명의구분"/>');
						    			me.masterGrid.getColumn('REF_CODE2').setText('<t:message code="system.label.common.realnameclass" default="실지명의구분"/>');
						    			me.masterGrid.getColumn('REF_CODE3').setText('<t:message code="system.label.common.usenum" default="사용번호"/>'); 			
						    			me.masterGrid.getColumn('REF_CODE4').setHidden(true);
						    			me.masterGrid.getColumn('REF_CODE5').setHidden(true);
						    		}
						    		else if(me.panelSearch.getValue('PARAM_MAIN_CODE') == 'HC03'){		// 채권이자구분
						    			me.masterGrid.getColumn('SAUP_POPUP_CODE').setHidden(true);
						    			me.masterGrid.getColumn('SAUP_POPUP_NAME').setHidden(true);
						    			me.masterGrid.getColumn('SUB_CODE').setText('<t:message code="system.label.common.code" default="코드"/>');
						    			me.masterGrid.getColumn('CODE_NAME').setText('<t:message code="system.label.common.incomekind" default="소득종류"/>');
						    			me.masterGrid.getColumn('REF_CODE1').setHidden(true);
						    			me.masterGrid.getColumn('REF_CODE2').setHidden(true);
						    			me.masterGrid.getColumn('REF_CODE3').setHidden(true);
						    			me.masterGrid.getColumn('REF_CODE4').setHidden(true);
						    			me.masterGrid.getColumn('REF_CODE5').setHidden(true);
						    		}
						    		
						    		else if(me.panelSearch.getValue('PARAM_MAIN_CODE') == 'HC05'){
						    			me.masterGrid.getColumn('SAUP_POPUP_CODE').setHidden(true);
						    			me.masterGrid.getColumn('SAUP_POPUP_NAME').setHidden(true);
						    			me.masterGrid.getColumn('SUB_CODE').setText('<t:message code="system.label.common.code" default="코드"/>');
						    			me.masterGrid.getColumn('CODE_NAME').setText('<t:message code="system.label.common.incomekind" default="소득종류"/>');
						    			me.masterGrid.getColumn('REF_CODE1').setHidden(true);
						    			me.masterGrid.getColumn('REF_CODE2').setHidden(true);
						    			me.masterGrid.getColumn('REF_CODE3').setHidden(true);
						    			me.masterGrid.getColumn('REF_CODE4').setHidden(true);
						    			me.masterGrid.getColumn('REF_CODE5').setHidden(true);
						    		}
						    		else if(me.panelSearch.getValue('PARAM_MAIN_CODE') == 'HC06'){			// 조세특례
						    			me.masterGrid.getColumn('SAUP_POPUP_CODE').setHidden(true);
						    			me.masterGrid.getColumn('SAUP_POPUP_NAME').setHidden(true);
						    			me.masterGrid.getColumn('SUB_CODE').setText('<t:message code="system.label.common.code" default="코드"/>');
						    			me.masterGrid.getColumn('CODE_NAME').setText('<t:message code="system.label.common.incomekind" default="소득종류"/>');
						    			me.masterGrid.getColumn('REF_CODE1').setHidden(true);
						    			me.masterGrid.getColumn('REF_CODE2').setHidden(true);
						    			me.masterGrid.getColumn('REF_CODE3').setHidden(true);
						    			me.masterGrid.getColumn('REF_CODE4').setHidden(true);
						    			me.masterGrid.getColumn('REF_CODE5').setHidden(true);
						    		}
						    	}*/
					        }
					}),
			uniOpt:{
                state: {
					useState: false,
					useStateList: false	
	            },
				pivot : {
					use : false
				}
		    },
			selModel:'rowmodel',
		    columns : columns,
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
		config.items = [me.panelSearch, me.masterGrid];
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
        	if(!Ext.isEmpty(param['SAUP_POPUP_CODE'])){
        		fieldTxt.setValue(param['SAUP_POPUP_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['INCOME_KIND'])){			//HC05
        		fieldTxt.setValue(param['INCOME_KIND']);        	
        	}
        	if(!Ext.isEmpty(param['TAX_EXCEPTION'])){		//HC06
        		fieldTxt.setValue(param['TAX_EXCEPTION']);        	
        	}
        	if(!Ext.isEmpty(param['TAX_GUBN'])){			//HC02
        		fieldTxt.setValue(param['TAX_GUBN']);
        	}  
        	if(!Ext.isEmpty(param['CLAIM_INTER_GUBN'])){	//HC03
        		fieldTxt.setValue(param['CLAIM_INTER_GUBN']);
        	}
        }else{
        	if(!Ext.isEmpty(param['SAUP_POPUP_CODE'])){
        		fieldTxt.setValue(param['SAUP_POPUP_CODE']);        	
        	}
        	if(!Ext.isEmpty(param['SAUP_POPUP_NAME'])){
        		fieldTxt.setValue(param['SAUP_POPUP_NAME']);
        	}   
        	if(!Ext.isEmpty(param['INCOME_KIND'])){			//HC05
        		fieldTxt.setValue(param['INCOME_KIND']);
        	}  
        	if(!Ext.isEmpty(param['TAX_EXCEPTION'])){		//HC06
        		fieldTxt.setValue(param['TAX_EXCEPTION']);
        	} 
        	if(!Ext.isEmpty(param['TAX_GUBN'])){			//HC02
        		fieldTxt.setValue(param['TAX_GUBN']);
        	}  
        	if(!Ext.isEmpty(param['CLAIM_INTER_GUBN'])){	//HC03
        		fieldTxt.setValue(param['CLAIM_INTER_GUBN']);
        	} 
        }		

        
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
		
		/*var me = this;
		me.panelSearch.clearForm();*/
		
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

