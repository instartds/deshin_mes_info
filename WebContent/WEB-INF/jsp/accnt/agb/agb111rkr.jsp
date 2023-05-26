<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb111rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수-->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo =  {
	
};
var getStDt = Ext.isEmpty(${getStDt}) ? ['']: ${getStDt} ;								//당기시작월 관련 전역변수
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수

function appMain() {   
	var panelSearch = Unilite.createSearchForm('agb111rkrForm', {
		region: 'center',
    	disabled :false,
    	border: false,
    	flex:1,
    	layout: {
	    	type: 'uniTable',
			columns:3
	    },
	    defaults:{
	    	width:325,
			labelWidth:90
	    },
		defaultType: 'uniTextfield',
		padding:'20 0 0 0',
		width:325,
		autoScroll:true,
		items : [{
			fieldLabel: '전표일',
			colspan: 1,
			xtype: 'uniDateRangefield',
			startFieldName: 'AC_DATE_FR',
			endFieldName: 'AC_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank:false
	     },
	     {
	    	 xtype: 'hiddenfield',
	         name: 'AC_DATA1'
	     },
	     {
	    	 xtype: 'hiddenfield',
	         name: 'ACCNT'
	     },
	     {
	    		xtype: 'radiogroup',	
	    		colspan: 2,
	    		fieldLabel: '과목구분',
	    		id: 'ACCNT_DIVI_RADIO',
	    		items: [{
	    			boxLabel: '과목', width: 82, name: 'ACCNT_DIVI', inputValue: '1'
	    		}, {
	    			boxLabel: '세목', width: 82, name: 'ACCNT_DIVI', inputValue: '2'
	    		}]
	    	},
/* 	     { 
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
//				multiSelect: false, 
//				typeAhead: false,
			value : UserInfo.divCode,
			comboType: 'BOR120'
		}, */
		Unilite.popup('ACCNT',{
	    	fieldLabel: '범위지정',
	    	colspan: 1,
	    	
	    	valueFieldName: 'FR_ACCNT_CODE',
	    	textFieldName: 'FR_ACCNT_NAME',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						/**
						 * 계정과목 동적 팝업
						 * 생성된 필드가 팝업일시 필드name은 아래와 같음		
						 * 			opt: '1' 미결항목용							opt: '2' 계정잔액1,2용					opt: '3' 관리항목 1~6용				
						 *  valueFieldName    textFieldName 		valueFieldName     textFieldName		 	valueFieldName    textFieldName
						 *    PEND_CODE			PEND_NAME			 BOOK_CODE1(~2)	   BOOK_NAME1(~2)			 AC_DATA1(~6)	 AC_DATA_NAME1(~6)
						 * -------------------------------------------------------------------------------------------------------------------------
						 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음	
						 * opt: '1' 미결항목용			opt: '2' 계정잔액1,2용			opt: '3' 관리항목 1~6용							 
						 *    PEND_CODE					BOOK_CODE1(~2)				AC_DATA1(~6)		
						 * */
						var param = {ACCNT_CD : panelSearch.getValue('FR_ACCNT_CODE')};
						accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
							dataMap = provider;
							var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용						
							UniAppManager.app.addMadeFields(1,"FR_ACCNT_CODE_SUB","FR_ACCNT_NAME_SUB",panelSearch, dataMap, null, opt);
							panelSearch.down('#conArea1').show();
							panelSearch.down('#conArea2').show();
							panelSearch.down('#formFieldArea1').show();
							panelSearch.down('#formFieldArea2').show();
							
							panelSearch.down('#serach_ViewPopup1').hide();
							panelSearch.down('#serach_ViewPopup2').hide();
							panelSearch.setReadOnlyByAcctCode();
						});			 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.down('#serach_ViewPopup1').show();
					panelSearch.down('#serach_ViewPopup2').show();
					// onClear시 removeField..
					UniAppManager.app.removeField(1,panelSearch, null);
					panelSearch.down('#conArea1').hide();
					panelSearch.down('#conArea2').hide();
					panelSearch.setReadOnlyByAcctCode();
				},
				applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                          'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
			}
 		}),{
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup1', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액1',
			    	validateBlank:false
			    })
			]
		},{
	    	xtype: 'container',
	    	itemId: 'conArea1',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',
			  	itemId: 'formFieldArea1', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    }, {
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup2', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액2',
			    	validateBlank:false
			    })
		]},{
	    	xtype: 'container',
	    	itemId: 'conArea2',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',			  	
			  	itemId: 'formFieldArea2', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    },
	    Unilite.popup('ACCNT',{
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	
	    	valueFieldName: 'TO_ACCNT_CODE',
	    	textFieldName: 'TO_ACCNT_NAME', 
			listeners: {
				onSelected: {
					fn: function(records, type) {

						var param = {ACCNT_CD : panelSearch.getValue('TO_ACCNT_CODE')};
						accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
							dataMap = provider;
							var opt = '2'					
							UniAppManager.app.addMadeFields(3,"TO_ACCNT_CODE_SUB","TO_ACCNT_NAME_SUB",panelSearch, dataMap, null, opt);
							panelSearch.down('#conArea3').show();
							panelSearch.down('#conArea4').show();
							panelSearch.down('#formFieldArea3').show();
							panelSearch.down('#formFieldArea4').show();
							
							panelSearch.down('#serach_ViewPopup3').hide();
							panelSearch.down('#serach_ViewPopup4').hide();
							panelSearch.setReadOnlyByAcctCode();
						});			 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.down('#serach_ViewPopup3').show();
					panelSearch.down('#serach_ViewPopup4').show();
					// onClear시 removeField..
					UniAppManager.app.removeField(3,panelSearch, null);
					panelSearch.down('#conArea3').hide();
					panelSearch.down('#conArea4').hide();
					panelSearch.setReadOnlyByAcctCode();
				},
				applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                          'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
			}
 		}),{
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup3', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액1',
			    	validateBlank:false
			    })
			]
		},{
	    	xtype: 'container',
	    	itemId: 'conArea3',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',
			  	itemId: 'formFieldArea3', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    }, {
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup4', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액2',
			    	validateBlank:false
			    })
		]},{
	    	xtype: 'container',
	    	itemId: 'conArea4',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',			  	
			  	itemId: 'formFieldArea4', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    },
	    //ext
	    Unilite.popup('ACCNT',{
	    	fieldLabel: '내제외과목',
	    	colspan: 1,
	    	
	    	valueFieldName: 'EX_ACCNT_CODE1',
	    	textFieldName: 'EX_ACCNT_NAME1',
			listeners: {
				onSelected: {
					fn: function(records, type) {

						var param = {ACCNT_CD : panelSearch.getValue('EX_ACCNT_CODE1')};
						accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
							dataMap = provider;
							var opt = '2'					
							UniAppManager.app.addMadeFields(11,"EX_ACCNT_CODE_SUB","EX_ACCNT_NAME_SUB",panelSearch, dataMap, null, opt);
							panelSearch.down('#conArea11').show();
							panelSearch.down('#conArea12').show();
							panelSearch.down('#formFieldArea11').show();
							panelSearch.down('#formFieldArea12').show();
							
							panelSearch.down('#serach_ViewPopup11').hide();
							panelSearch.down('#serach_ViewPopup12').hide();
						});			 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.down('#serach_ViewPopup11').show();
					panelSearch.down('#serach_ViewPopup12').show();
					// onClear시 removeField..
					UniAppManager.app.removeField(11,panelSearch, null);
					panelSearch.down('#conArea11').hide();
					panelSearch.down('#conArea12').hide();
				},
				applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                          'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
			}
 		}),{
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup11', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액1',
			    	validateBlank:false
			    })
			]
		},{
	    	xtype: 'container',
	    	itemId: 'conArea11',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',
			  	itemId: 'formFieldArea11', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    }, {
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup12', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액2',
			    	validateBlank:false
			    })
		]},{
	    	xtype: 'container',
	    	itemId: 'conArea12',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',			  	
			  	itemId: 'formFieldArea12', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    },
	    Unilite.popup('ACCNT',{
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	
	    	valueFieldName: 'EX_ACCNT_CODE2',
	    	textFieldName: 'EX_ACCNT_NAME2',  
			listeners: {
				onSelected: {
					fn: function(records, type) {

						var param = {ACCNT_CD : panelSearch.getValue('EX_ACCNT_CODE2')};
						accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
							dataMap = provider;
							var opt = '2'					
							UniAppManager.app.addMadeFields(21,"EX_ACCNT_CODE_SUB","EX_ACCNT_NAME_SUB",panelSearch, dataMap, null, opt);
							panelSearch.down('#conArea21').show();
							panelSearch.down('#conArea22').show();
							panelSearch.down('#formFieldArea21').show();
							panelSearch.down('#formFieldArea22').show();
							
							panelSearch.down('#serach_ViewPopup21').hide();
							panelSearch.down('#serach_ViewPopup22').hide();
						});			 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.down('#serach_ViewPopup21').show();
					panelSearch.down('#serach_ViewPopup22').show();
					// onClear시 removeField..
					UniAppManager.app.removeField(21,panelSearch, null);
					panelSearch.down('#conArea21').hide();
					panelSearch.down('#conArea22').hide();
				},
				applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                          'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
			}
 		}),{
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup21', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액1',
			    	validateBlank:false
			    })
			]
		},{
	    	xtype: 'container',
	    	itemId: 'conArea21',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',
			  	itemId: 'formFieldArea21', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    }, {
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup22', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액2',
			    	validateBlank:false
			    })
		]},{
	    	xtype: 'container',
	    	itemId: 'conArea22',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',			  	
			  	itemId: 'formFieldArea22', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    },
	    Unilite.popup('ACCNT',{
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	
	    	valueFieldName: 'EX_ACCNT_CODE3',
	    	textFieldName: 'EX_ACCNT_NAME3',
			listeners: {
				onSelected: {
					fn: function(records, type) {

						var param = {ACCNT_CD : panelSearch.getValue('EX_ACCNT_CODE3')};
						accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
							dataMap = provider;
							var opt = '2'					
							UniAppManager.app.addMadeFields(31,"EX_ACCNT_CODE_SUB","EX_ACCNT_NAME_SUB",panelSearch, dataMap, null, opt);
							panelSearch.down('#conArea31').show();
							panelSearch.down('#conArea32').show();
							panelSearch.down('#formFieldArea31').show();
							panelSearch.down('#formFieldArea32').show();
							
							panelSearch.down('#serach_ViewPopup31').hide();
							panelSearch.down('#serach_ViewPopup32').hide();
						});			 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.down('#serach_ViewPopup31').show();
					panelSearch.down('#serach_ViewPopup32').show();
					// onClear시 removeField..
					UniAppManager.app.removeField(31,panelSearch, null);
					panelSearch.down('#conArea31').hide();
					panelSearch.down('#conArea32').hide();
				},
				applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                          'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
			}
 		}),{
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup31', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액1',
			    	validateBlank:false
			    })
			]
		},{
	    	xtype: 'container',
	    	itemId: 'conArea31',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',
			  	itemId: 'formFieldArea31', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    }, {
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup32', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액2',
			    	validateBlank:false
			    })
		]},{
	    	xtype: 'container',
	    	itemId: 'conArea32',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',			  	
			  	itemId: 'formFieldArea32', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    },
	    //add
	     Unilite.popup('ACCNT',{
	    	fieldLabel: '개별과목지정',
	    	colspan: 1,
	    	valueFieldName: 'ADD_ACCNT_CODE1',
	    	textFieldName: 'ADD_ACCNT_NAME1',
			listeners: {
				

				onSelected: {
					fn: function(records, type) {

						var param = {ACCNT_CD : panelSearch.getValue('ADD_ACCNT_CODE1')};
						accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
							dataMap = provider;
							var opt = '2'					
							UniAppManager.app.addMadeFields(111,"ADD_ACCNT_CODE_SUB","ADD_ACCNT_NAME_SUB",panelSearch, dataMap, null, opt);
							panelSearch.down('#conArea111').show();
							panelSearch.down('#conArea112').show();
							panelSearch.down('#formFieldArea111').show();
							panelSearch.down('#formFieldArea112').show();
							
							panelSearch.down('#serach_ViewPopup111').hide();
							panelSearch.down('#serach_ViewPopup112').hide();
						});			 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.down('#serach_ViewPopup111').show();
					panelSearch.down('#serach_ViewPopup112').show();
					// onClear시 removeField..
					UniAppManager.app.removeField(111,panelSearch, null);
					panelSearch.down('#conArea111').hide();
					panelSearch.down('#conArea112').hide();
				},
				applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                          'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
			}
 		}),{
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup111', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액1',
			    	validateBlank:false
			    })
			]
		},{
	    	xtype: 'container',
	    	itemId: 'conArea111',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',
			  	itemId: 'formFieldArea111', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    }, {
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup112', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액2',
			    	validateBlank:false
			    })
		]},{
	    	xtype: 'container',
	    	itemId: 'conArea112',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',			  	
			  	itemId: 'formFieldArea112', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    },
	    Unilite.popup('ACCNT',{
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	
	    	valueFieldName: 'ADD_ACCNT_CODE2',
	    	textFieldName: 'ADD_ACCNT_NAME2', 
			listeners: {
				onSelected: {
					fn: function(records, type) {

						var param = {ACCNT_CD : panelSearch.getValue('ADD_ACCNT_CODE2')};
						accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
							dataMap = provider;
							var opt = '2'					
							UniAppManager.app.addMadeFields(121,"ADD_ACCNT_CODE_SUB","ADD_ACCNT_NAME_SUB",panelSearch, dataMap, null, opt);
							panelSearch.down('#conArea121').show();
							panelSearch.down('#conArea122').show();
							panelSearch.down('#formFieldArea121').show();
							panelSearch.down('#formFieldArea122').show();
							
							panelSearch.down('#serach_ViewPopup121').hide();
							panelSearch.down('#serach_ViewPopup122').hide();
						});			 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.down('#serach_ViewPopup121').show();
					panelSearch.down('#serach_ViewPopup122').show();
					// onClear시 removeField..
					UniAppManager.app.removeField(121,panelSearch, null);
					panelSearch.down('#conArea121').hide();
					panelSearch.down('#conArea122').hide();
				},
				applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                          'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
			}
 		}),{
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup121', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액1',
			    	validateBlank:false
			    })
			]
		},{
	    	xtype: 'container',
	    	itemId: 'conArea121',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',
			  	itemId: 'formFieldArea121', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    }, {
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup122', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액2',
			    	validateBlank:false
			    })
		]},{
	    	xtype: 'container',
	    	itemId: 'conArea122',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',			  	
			  	itemId: 'formFieldArea122', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    },
	    Unilite.popup('ACCNT',{
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	
	    	valueFieldName: 'ADD_ACCNT_CODE3',
	    	textFieldName: 'ADD_ACCNT_NAME3',
			listeners: {
				onSelected: {
					fn: function(records, type) {

						var param = {ACCNT_CD : panelSearch.getValue('ADD_ACCNT_CODE3')};
						accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
							dataMap = provider;
							var opt = '2'					
							UniAppManager.app.addMadeFields(131,"ADD_ACCNT_CODE_SUB","ADD_ACCNT_NAME_SUB",panelSearch, dataMap, null, opt);
							panelSearch.down('#conArea131').show();
							panelSearch.down('#conArea132').show();
							panelSearch.down('#formFieldArea131').show();
							panelSearch.down('#formFieldArea132').show();
							
							panelSearch.down('#serach_ViewPopup131').hide();
							panelSearch.down('#serach_ViewPopup132').hide();
						});			 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.down('#serach_ViewPopup131').show();
					panelSearch.down('#serach_ViewPopup132').show();
					// onClear시 removeField..
					UniAppManager.app.removeField(131,panelSearch, null);
					panelSearch.down('#conArea131').hide();
					panelSearch.down('#conArea132').hide();
				},
				applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                          'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
			}
 		}),{
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup131', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액1',
			    	validateBlank:false
			    })
			]
		},{
	    	xtype: 'container',
	    	itemId: 'conArea131',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',
			  	itemId: 'formFieldArea131', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    }, {
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup132', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액2',
			    	validateBlank:false
			    })
		]},{
	    	xtype: 'container',
	    	itemId: 'conArea132',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',			  	
			  	itemId: 'formFieldArea132', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    },
	    Unilite.popup('ACCNT',{
	    	fieldLabel: ' ',
	    	colspan: 1,
	    	
	    	valueFieldName: 'ADD_ACCNT_CODE4',
	    	textFieldName: 'ADD_ACCNT_NAME4',
			listeners: {
				onSelected: {
					fn: function(records, type) {

						var param = {ACCNT_CD : panelSearch.getValue('ADD_ACCNT_CODE4')};
						accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
							dataMap = provider;
							var opt = '2'					
							UniAppManager.app.addMadeFields(141,"ADD_ACCNT_CODE_SUB","ADD_ACCNT_NAME_SUB",panelSearch, dataMap, null, opt);
							panelSearch.down('#conArea141').show();
							panelSearch.down('#conArea142').show();
							panelSearch.down('#formFieldArea141').show();
							panelSearch.down('#formFieldArea142').show();
							
							panelSearch.down('#serach_ViewPopup141').hide();
							panelSearch.down('#serach_ViewPopup142').hide();
						});			 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.down('#serach_ViewPopup141').show();
					panelSearch.down('#serach_ViewPopup142').show();
					// onClear시 removeField..
					UniAppManager.app.removeField(141,panelSearch, null);
					panelSearch.down('#conArea141').hide();
					panelSearch.down('#conArea142').hide();
				},
				applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                          'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
			}
 		}),{
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup141', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액1',
			    	validateBlank:false
			    })
			]
		},{
	    	xtype: 'container',
	    	itemId: 'conArea141',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',
			  	itemId: 'formFieldArea141', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    }, {
		  	xtype: 'container',
		  	colspan: 1,
		  	itemId: 'serach_ViewPopup142', 
		  	layout: {
		   		type: 'table', 
		   		columns:1,
		   		itemCls:'table_td_in_uniTable',
		   		tdAttrs: {
		    		width: 350
		   		}
	  		},
	  		items:[
			    Unilite.popup('ACCNT_PRSN',{
					readOnly:true,
			    	fieldLabel: '계정잔액2',
			    	validateBlank:false
			    })
		]},{
	    	xtype: 'container',
	    	itemId: 'conArea142',
	    	colspan: 1,
	    	items:[{
			  	xtype: 'container',			  	
			  	itemId: 'formFieldArea142', 
			  	layout: {
			   		type: 'table', 
			   		columns:1,
			   		itemCls:'table_td_in_uniTable',
			   		tdAttrs: {
			    		width: 350
			   		}
		  		}
			}]
	    },
		//more choose select
		{
			fieldLabel: '사업장',
			colspan: 3,
			name:'ACCNT_DIV_CODE', 
			xtype: 'uniCombobox',
	        multiSelect: true, 
	        typeAhead: false,
	        value:UserInfo.divCode,
	        comboType:'BOR120',
			width: 325,
			listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						
					}
				}
		},
         { 
			fieldLabel: '당기시작년월',
			colspan: 34,
			name: 'START_DATE',
            xtype: 'uniMonthfield',
            readOnly:false,
            width:250
         },
         Unilite.popup('ACCNT_PRSN',{
	    	fieldLabel: '입력자',
	    	colspan: 3,
		    valueFieldName:'CHARGE_CODE',
		    textFieldName:'CHARGE_NAME',
	    	validateBlank:false
		 }),
		 {
			xtype: 'container',
			colspan: 3,
			layout: {type : 'uniTable', columns : 3},
			width:600,
			items :[{
				fieldLabel:'금액', 
				xtype: 'uniNumberfield',
				name: 'FR_AMT_I', 
				width: 203,
				renderer: Ext.util.Format.numberRenderer('0.000')
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniNumberfield',
				name: 'TO_AMT_I', 
				width: 113
			}]
		},
		
		{
			xtype: 'container',
			colspan: 3,
			layout: {type : 'uniTable', columns : 3},
			width:600,
			items :[{
				fieldLabel:'외화금액', 
				xtype: 'uniNumberfield',
				name: 'FR_FOR_AMT_I', 
				width: 203
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniNumberfield',
				name: 'TO_FOR_AMT_I', 
				width: 113
			}]
		},{
                xtype: 'uniTextfield',
                name: 'REMARK',
                fieldLabel: '적요',
                width: 325,
                colspan: 4
        },
	    Unilite.popup('DEPT',{
	    	colspan: 3,
	        fieldLabel: '부서',
		    valueFieldName:'FR_DEPT_CODE',
		    textFieldName:'FR_DEPT_NAME',
	        validateBlank:false
	    }),
	      	Unilite.popup('DEPT',{
	        fieldLabel: '~',
	        colspan: 3,
		    valueFieldName:'TO_DEPT_CODE',
		    textFieldName:'TO_DEPT_NAME',
	        validateBlank:false
	    }), 
	    {
			fieldLabel: '출력조건',
			name: '',
			colspan: 3,
			xtype: 'checkboxgroup', 
			width: 400, 
			items: [{
	        	boxLabel: '수정삭제이력표시',
	        	name: 'INCLUDE_DELETE',
				width: 150,
				uncheckedValue: 'N',
	        	inputValue: 'Y'
	        }, {
				boxLabel: '각주',
	        	name: 'POSTIT_YN',
				width: 100,
				uncheckedValue: '',						//unilite에 체크 안 되어 있을 때 'N'으로 조회되나 데이터 조회 값은 ''이 들어간 것이 동일한 값을 가짐 일단 ''처리
	        	inputValue: 'Y',
        		listeners: {
   				 	change: function(field, newValue, oldValue, eOpts) {
   				 		if(panelSearch.getValue('POSTIT_YN')) {
							panelSearch.getField('POSTIT').setReadOnly(false);
   				 		} else {
							panelSearch.getField('POSTIT').setReadOnly(true);
   				 		}
					}
        		}
			}]
		},
	    {
	    	xtype: 'uniTextfield',
	    	fieldLabel: '각주',
	    	colspan: 3,
	    	width: 325,
	    	name:'POSTIT',
	    	readOnly: true
	    },
	    Unilite.popup('CUST',{
	        fieldLabel: '거래처',
	        colspan: 3,
			allowBlank:true,
			autoPopup:false,	        
	        validateBlank:false,
		    valueFieldName:'CUSTOM_CODE',
		    textFieldName:'CUSTOM_NAME',
			listeners: {
				onValueFieldChange:function( elm, newValue, oldValue) {	
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange:function( elm, newValue, oldValue) {
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),
		
         {
         	xtype:'button',
         	text:'출    력',
         	width:235,
         	margin: '60 0 0 0',
            colspan: 3,
         	tdAttrs:{'align':'center', style:'padding-left:95px'},
         	handler:function()	{
         		UniAppManager.app.onPrintButtonDown();
         	}
         }
		],
		 setReadOnlyByAcctCode:function(){
				if(panelSearch.getValue('FR_ACCNT_CODE') || panelSearch.getValue('TO_ACCNT_CODE')) {
		 			for(var i=1;i<4;i++){
		 				panelSearch.getField('EX_ACCNT_CODE'+i).setReadOnly(false);
						panelSearch.getField('EX_ACCNT_NAME'+i).setReadOnly(false);
		 			}
		 				
		 		} else {
		 			for(var i=1;i<4;i++){
			 			panelSearch.getField('EX_ACCNT_CODE'+i).setReadOnly(true);
						panelSearch.getField('EX_ACCNT_NAME'+i).setReadOnly(true);
		 			}
		 		}
			}
	});
	
   
   
    
	 Unilite.Main( {
	 	border: false,
	 	items:[
	 		panelSearch
	 		],
	 
		id : 'agb111rkrApp',
		fnInitBinding : function(params) {
			panelSearch.getField('ACCNT_DIVI').setValue("1");
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			
			panelSearch.down('#formFieldArea1').hide();
			panelSearch.down('#formFieldArea2').hide();
			panelSearch.down('#conArea1').hide();
			panelSearch.down('#conArea2').hide();
			
			panelSearch.down('#formFieldArea3').hide();
			panelSearch.down('#formFieldArea4').hide();
			panelSearch.down('#conArea3').hide();
			panelSearch.down('#conArea4').hide();
			//ext
			panelSearch.down('#formFieldArea11').hide();
			panelSearch.down('#formFieldArea12').hide();
			panelSearch.down('#conArea11').hide();
			panelSearch.down('#conArea12').hide();
			
			panelSearch.down('#formFieldArea21').hide();
			panelSearch.down('#formFieldArea22').hide();
			panelSearch.down('#conArea21').hide();
			panelSearch.down('#conArea22').hide();
			
			panelSearch.down('#formFieldArea31').hide();
			panelSearch.down('#formFieldArea32').hide();
			panelSearch.down('#conArea31').hide();
			panelSearch.down('#conArea32').hide();
			//add
			panelSearch.down('#formFieldArea111').hide();
			panelSearch.down('#formFieldArea112').hide();
			panelSearch.down('#conArea111').hide();
			panelSearch.down('#conArea112').hide();
			
			panelSearch.down('#formFieldArea121').hide();
			panelSearch.down('#formFieldArea122').hide();
			panelSearch.down('#conArea121').hide();
			panelSearch.down('#conArea122').hide();
			
			panelSearch.down('#formFieldArea131').hide();
			panelSearch.down('#formFieldArea132').hide();
			panelSearch.down('#conArea131').hide();
			panelSearch.down('#conArea132').hide();
			
			panelSearch.down('#formFieldArea141').hide();
			panelSearch.down('#formFieldArea142').hide();
			panelSearch.down('#conArea141').hide();
			panelSearch.down('#conArea142').hide();
			
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			panelSearch.setReadOnlyByAcctCode();
			
			if(!Ext.isEmpty(params.AC_DATE_FR)){
                this.processParams(params);
            }
		},
        //링크로 넘어오는 params 받는 부분 
        processParams: function(param) {
            //agb110skr.jsp(보조부)에서 링크걸려옴
           if(param.CHECK_POST_IT == true){
                panelSearch.getField('POSTIT').setReadOnly(false);
            }else{
                panelSearch.getField('POSTIT').setReadOnly(true);
            }
            panelSearch.setValue('AC_DATE_FR', param.AC_DATE_FR),      
            panelSearch.setValue('AC_DATE_TO', param.AC_DATE_TO ),
            panelSearch.setValue('FR_ACCNT_CODE', param.ACCNT_CODE),      
            panelSearch.setValue('FR_ACCNT_NAME', param.ACCNT_NAME ),
            panelSearch.setValue('TO_ACCNT_CODE', param.ACCNT_CODE),      
            panelSearch.setValue('TO_ACCNT_NAME', param.ACCNT_NAME ),
            panelSearch.setValue('ACCNT_DIV_CODE', param.DIV_CODE ),  
            panelSearch.setValue('INCLUDE_DELETE', param.CHECK_DELETE ),
            panelSearch.setValue('POSTIT_YN', param.CHECK_POST_IT ),
            panelSearch.setValue('POSTIT', param.POST_IT ),
            panelSearch.setValue('START_DATE', param.START_DATE ),
            panelSearch.setValue('FR_AMT_I', param.AMT_FR ),
            panelSearch.setValue('TO_AMT_I', param.AMT_TO ),
            panelSearch.setValue('FR_FOR_AMT_I', param.FOR_AMT_FR ),
            panelSearch.setValue('TO_FOR_AMT_I', param.FOR_AMT_TO ),
            panelSearch.setValue('REMARK', param.REMARK ),
            panelSearch.setValue('CHARGE_CODE', param.CHARGE_CODE ),     
            panelSearch.setValue('CHARGE_NAME', param.CHARGE_NAME ),     
            panelSearch.setValue('CUSTOM_CODE', param.CUSTOM_CODE ),     
            panelSearch.setValue('CUSTOM_NAME', param.CUSTOM_NAME),  
            panelSearch.setValue('FR_DEPT_CODE', param.DEPT_CODE_FR),     
            panelSearch.setValue('TO_DEPT_CODE', param.DEPT_CODE_TO),
            panelSearch.setValue('FR_DEPT_NAME', param.DEPT_NAME_FR),     
            panelSearch.setValue('TO_DEPT_NAME', param.DEPT_NAME_TO),
            panelSearch.setValue('REMARK_CODE', param.REMARK_CODE),
            panelSearch.setValue('REMARK_NAME', param.REMARK_NAME),
            panelSearch.setValue('MONEY_UNIT', param.MONEY_UNIT),
            panelSearch.setValue('AC_DATA1', param.ACCNT_CODE),
            panelSearch.setValue('ACCNT', param.ACCNT_CODE)
            
            
        },
		onQueryButtonDown : function()	{
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
			var param= panelSearch.getValues();
			
			param.ACCNT_DIV_CODE = panelSearch.getValue('ACCNT_DIV_CODE').join(",");
			param.ACCNT_DIV_NAME = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
			
			/* var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/agb/agb111rkrPrint.do',
				prgID: 'agb111rkr',
				extParam: panelSearch.getValues()
			}); */
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/accnt/agb111clrkrPrint.do',
				prgID: 'agb11c1rkr',
				extParam: param
			});
			win.center();
			win.show();   				
		},
		removeField : function(n,form, otherForm){
			
			if(form.down('#formFieldArea'+(n+1))){
				form.down('#formFieldArea'+n).removeAll();
				form.down('#formFieldArea'+(n+1)).removeAll();
				if(!otherForm) return false; 
				otherForm.down('#formFieldArea'+n).removeAll();
				otherForm.down('#formFieldArea'+(n+1)).removeAll();
			}else{
				form.down('#formFieldArea'+n).removeAll();
				if(!otherForm) return false; 
				otherForm.down('#formFieldArea'+n).removeAll();
			}
		},
		makeItem: function(n, acCode,  acName,  fName, fDataName, gsBankValueFieldName, gsBankTextFieldName, acType, acPopup, acLen, acCtl, acFormat, fieldKind, form, otherForm, extParam, record)	{
			if(!Ext.isEmpty(fieldKind)){
				if(fieldKind == 'frField'){
					fName = 'DYNAMIC_CODE_FR';
					fDataName = 'DYNAMIC_NAME_FR';
				}else{
					fName = 'DYNAMIC_CODE_TO';
					fDataName = 'DYNAMIC_NAME_TO';
					acName = '~';
				}
			}
			
			var field = {};
			// acType
			if(acPopup == 'Y')	{
				switch(acCode)	{
	    			case 'A2': Ext.apply(field, Unilite.popup('DEPT',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));		//부서
	    				break;
	    			case 'A3': //gsBankValueFieldName = fName; gsBankTextFieldName = fDataName; 
	    			Ext.apply(field, Unilite.popup('BANK',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, 
	    				listeners: {
	    					onSelected: 
	    					{ fn: function(records, type){
	    						if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); 
	    						otherForm.setValue(fDataName, form.getValue(fDataName));}, 
	    						scope: this}, 
	    						onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));		//은행
	    				break;
	    			case 'A4': var aBankBookColNm, aBankColNm;
	    					   if(record)	{
	    						var idx = this.findAcCode(record, "O2");
	    					     aBankBookColNm = "AC_DATA"+idx;
	    					     aBankColNm = "AC_DATA_NAME"+idx;
	    					   }
	    					   Ext.apply(field, 
	    					   		Unilite.popup('CUST',{
		    					   		fieldLabel:acName, 
		    					   		valueFieldName: fName, 
		    					   		textFieldName: fDataName, 
		    					   		extParam:{"CUSTOM_TYPE":['1','2','3']},
		    					   		listeners: {
		    					   			'onSelected': { 
		    					   				fn: function(records, type) {
		    					   					console.log("aBankBookColNm : ", aBankBookColNm);
		    					   					if(!otherForm) return false; 
		    					   					otherForm.setValue(fName, form.getValue(fName)); 
		    					   					otherForm.setValue(fDataName, form.getValue(fDataName));
		    					   					
		    					   					var bankBookColNm = aBankBookColNm, bankColNm = aBankColNm;
		    					   					if(!Ext.isEmpty(bankBookColNm))	{
		    					   						//otherForm.getField(bankBookColNm).getEl().dom.innerHTML = otherForm.getField(bankBookColNm).getEl().dom.innerHTML + records[0].BANK_NAME;
		    					   						otherForm.setValue(bankBookColNm, records[0].BANKBOOK_NUM);	 
		    					   						otherForm.setValue(bankColNm, records[0].BANK_NAME);	
		    				
		    					   					}
		    					   				}, 
		    					   				scope: this}, 
		    					   			'onClear': function(type){
		    					   				if(!otherForm) return false; 
		    					   				otherForm.setValue(fName, ''); 
		    					   				otherForm.setValue(fDataName, '');
		    					   				var bankBookColNm = aBankBookColNm;
		    					   				if(!Ext.isEmpty(bankBookColNm))	{
		    					   						otherForm.setValue(bankBookColNm, "");	    	
		    					   				}
		    					   			}
		    					   		}
	    					   		})
	    					   	);		//거래처
	    				break;
	    			case 'A6': Ext.apply(field, Unilite.popup('Employee',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));	//사번
	    				break;
	    			case 'A7': Ext.apply(field, Unilite.popup('CUST',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//예산코드
	    				break;
	    			case 'A9': Ext.apply(field, Unilite.popup('COST_POOL',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//Cost Pool
	    				break;
	    			case 'B1': Ext.apply(field, Unilite.popup('DIV_PUMOK',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//사업장별 품목팝업
	    				break;
	    			case 'C2': var aBankCd, aBankNm, aCustCd, aCustNm, aExpDate;	//어음번호
	    					   if(record)	{
	    						var bankIdx = this.findAcCode(record, "A3");
	    					     aBankCd = "AC_DATA"+bankIdx;
	    					     aBankNm = "AC_DATA_NAME"+bankIdx;
	    					     
	    					    var custIdx = this.findAcCode(record, "A4");
	    					     aCustCd = "AC_DATA"+custIdx;
	    					     aCustNm = "AC_DATA_NAME"+custIdx;
	    					   
	    					    var expDateIdx = this.findAcCode(record, "C3");
	    					     aExpDate = "AC_DATA"+expDateIdx;
	    					   }
	    					   Ext.apply(field, 
	    					   		Unilite.popup('NOTE_NUM',{
	    					   			fieldLabel:acName, 
	    					   			valueFieldName: fName, 
	    					   			textFieldName: fName, 
	    					   			dataRecord : record,
	    					   			autoPopup:false,
	    					   			allowInputData:true,
	    					   			listeners: {
	    					   				onSelected: { 
	    					   					fn: function(records, type){
	    					   						if(!otherForm) return false; 
	    					   						otherForm.setValue(fName, form.getValue(fName)); 
	    					   						otherForm.setValue(fDataName, form.getValue(fDataName));
	    					   						
	    					   						//var bankCd=aBankCd, bankNm=aBankNm, custCd=aCustCd, custNm=aCustNm, expDate=aExpDate;
	    					   						var rRecord = record;
	    					   						var chkAmt = true;
	    					   						if(rRecord != null && Ext.isFunction(UniAppManager.app.cbCheckNoteAmt))	{
	    					   							var rfieldName = rRecord.get("DR_CR") =="1" ? "DR_AMT_I" : "CR_AMT_I";
	    					   							chkAmt = UniAppManager.app.cbCheckNoteAmt(records[0], rRecord.get("AMT_I"),   rRecord.get("AMT_I"), rRecord, rfieldName);
	    					   						}
	    					   						if(chkAmt)	{
	    					   							if(aBankCd) otherForm.setValue(aBankCd, records[0].BANK_CODE);
		    					   						if(aBankNm) otherForm.setValue(aBankNm, records[0].BANK_NAME);
		    					   						if(aCustCd) otherForm.setValue(aCustCd, records[0].CUSTOM_CODE);
		    					   						if(aCustNm) otherForm.setValue(aCustNm, records[0].CUSTOM_NAME);
		    					   						if(aExpDate) otherForm.setValue(aExpDate, records[0].EXP_DATE);
	    					   						}else {
	    					   							otherForm.setValue(fName, ""); 
	    					   						}
	    					   					}, 
	    					   					scope: this
	    					   				}
	    					   				, onClear: function(type){
	    					   					if(!otherForm) return false; 
	    					   					//otherForm.setValue(fName, ''); 
	    					   					//otherForm.setValue(fDataName, '');
	    					   					
	    					   					if(aBankCd) otherForm.setValue(aBankCd, "");
						   						if(aBankNm) otherForm.setValue(aBankNm, "");
						   						if(aCustCd) otherForm.setValue(aCustCd, "");
						   						if(aCustNm) otherForm.setValue(aCustNm, "");
						   						if(aExpDate) otherForm.setValue(aExpDate, "");
	    					   				},
	    					   				applyExtParam:function(popup)	{
	    					   					
	    					   					var extParam = popup.extParam;
	    					   					extParam.DR_CR = popup.dataRecord.get("DR_CR");
	    					   					extParam.SPEC_DIVI = popup.dataRecord.get("SPEC_DIVI");
												popup.setExtParam(extParam);
										 
										 	}
	    					   			}
	    					   		})
	    					   	);			//어음번호
	    				break;
	    			case 'C7': var aBankCd, aBankNm, aPubDate;	//수표번호
	    					   if(record)	{
	    						var bankIdx = this.findAcCode(record, "A3");
	    					     aBankCd = "AC_DATA"+bankIdx;
	    					     aBankNm = "AC_DATA_NAME"+bankIdx;
	    					    var pubDateIdx = this.findAcCode(record, "C4");
	    					     aPubDate = "AC_DATA"+pubDateIdx;
	    					   } 
	    						Ext.apply(field, 
	    							Unilite.popup('CHECK_NUM',{
	    								fieldLabel:acName, 
	    								valueFieldName: fName, 
	    								textFieldName: fDataName, 
	    								listeners: {
	    									onSelected: { 
	    										fn: function(records, type){
	    											if(!otherForm) return false; 
	    											otherForm.setValue(fName, form.getValue(fName)); 
	    											otherForm.setValue(fDataName, form.getValue(fDataName));
	    											
	    											if(aBankCd) otherForm.setValue(aBankCd, records[0].BANK_CODE);
	    					   						if(aBankNm) otherForm.setValue(aBankNm, records[0].BANK_NAME);
	    					   						if(aPubDate) otherForm.setValue(aPubDate, records[0].PUB_DATE);
	    										}, 
	    										scope: this
	    									}, 
	    									onClear: function(type){
	    										if(!otherForm) return false; 
	    										otherForm.setValue(fName, ''); 
	    										otherForm.setValue(fDataName, '');
	    										
	    										if(aBankCd) otherForm.setValue(aBankCd, "");
						   						if(aBankNm) otherForm.setValue(aBankNm, "");
						   						if(aPubDate) otherForm.setValue(aPubDate, "");
	    									}
	    								}
	    							})
	    						);			//수표번호
	    				break;
	    			case 'D5': Ext.apply(field, Unilite.popup('EX_LCNO',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//L/C번호(수출)
	    				break;
	    			case 'D6': Ext.apply(field, Unilite.popup('IN_LCNO',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//L/C번호(수입)
	    				break;
	    			case 'D7': Ext.apply(field, Unilite.popup('EX_BLNO',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//B/L번호(수출)
	    				break;
	    			case 'D8': Ext.apply(field, Unilite.popup('IN_BLNO',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//B/L번호(수입)
	    				break;
	    			case 'E1': Ext.apply(field, Unilite.popup('AC_PROJECT',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//프로젝트
	    				break;
	    			case 'G5': Ext.apply(field, Unilite.popup('CREDIT_NO',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//증빙유형
	    				break;
	    			case 'M1': var aBankCd, aBankNm;	//자산코드
	    					   if(record)	{
	    						var bankIdx = this.findAcCode(record, "A3");
	    					     aBankCd = "AC_DATA"+bankIdx;
	    					     aBankNm = "AC_DATA_NAME"+bankIdx;
	    					   } 
	    						Ext.apply(field, 
	    							Unilite.popup('ASSET',{
	    								fieldLabel:acName, 
	    								valueFieldName: fName, 
	    								textFieldName: fDataName, 
	    								listeners: {
	    									onSelected: { 
	    										fn: function(records, type){
	    											if(!otherForm) return false; 
	    											otherForm.setValue(fName, form.getValue(fName)); 
	    											otherForm.setValue(fDataName, form.getValue(fDataName));
	    											
	    											if(aBankCd) otherForm.setValue(aBankCd, records[0].BANK_CODE);
	    					   						if(aBankNm) otherForm.setValue(aBankNm, records[0].BANK_NAME);
	    					   						
	    										}, 
	    										scope: this
	    									},
	    									onClear: function(type){
	    										if(!otherForm) return false; 
	    										otherForm.setValue(fName, ''); 
	    										otherForm.setValue(fDataName, '');
	    										
	    										if(aBankCd) otherForm.setValue(aBankCd, "");
						   						if(aBankNm) otherForm.setValue(aBankNm, "");
						   						
	    									}
	    								}
	    							})
	    						);			//자산코드
	    				break;
	    			case 'O1': Ext.apply(field, Unilite.popup('BANK_BOOK',{fieldLabel:acName
	    																, valueFieldName: fName, textFieldName: fDataName, 
	    																listeners: {
	    																	onSelected: { 
	    																		fn: function(records, type){
	    																			form.setValue(gsBankValueFieldName, records[0].BANK_CD); 
	    																			form.setValue(gsBankTextFieldName, records[0].BANK_NM); 
	    																			if(!otherForm) return false; 
	    																			otherForm.setValue(gsBankValueFieldName, records[0].BANK_CD); 
	    																			otherForm.setValue(gsBankTextFieldName, records[0].BANK_NM); 
	    																			otherForm.setValue(fName, form.getValue(fName)); 
	    																			otherForm.setValue(fDataName, form.getValue(fDataName));}, 
	    																		scope: this
	    																	}
	    																 , onClear: function(type){ 
	    																 			form.setValue('BANK_CODE', ''); 
	    																 			form.setValue('BANK_NAME', '');
	    																 			if(!otherForm) return false;
	    																 			otherForm.setValue(fName, ''); 
	    																 			otherForm.setValue(fDataName, '');
	    																 	}
	    																 ,applyExtParam:function(popup)	{
																				popup.setExtParam(extParam);
	    																 
	    																 	}
	    																 }
	    																 
	    																 }));			//Deposit
	    				break;
	    			case 'P2': Ext.apply(field, Unilite.popup('DEBT_NO',{fieldLabel:acName, valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}}));			//차입금번호
	    				break;
	    			  				
	    			default:	//동적 팝업  (공통코드, 사용자 정의 팝업)
	    				var bsaCode = '';
						if(UniUtils.indexOf(acCode, ["B5", "C0", "D2", "I4", "I5", "I7", "Q1", "A8"])){		//공통코드 팝업 생성						
							switch(acCode){
								case "B5" :
									bsaCode = 'B013'							
								break;
								case "C0" :
									bsaCode = 'A058'
								break;
								case "D2" :
									bsaCode = 'B004'
								break;
								case "I4" :
									bsaCode = 'A003'
								break;
								case "I5" :
									bsaCode = 'A022'
								break;
								case "I7" :
									bsaCode = 'A149'
								break;
								case "Q1" :
									bsaCode = 'A171'
								break;
								case "A8" :
									bsaCode = 'A170'
								break;
							}						
							if(fieldKind == 'toField'){
								Ext.apply(field, Unilite.popup('COMMON',{itemId: dynamicId + cnt, fieldBsaCode: bsaCode, usePopup: 'common', valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}})); // 빈팝업 생성						
							}else{
								Ext.apply(field, Unilite.popup('COMMON',{itemId: dynamicId+ cnt, fieldBsaCode: bsaCode, usePopup: 'common', valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}})); // 빈팝업 생성	DYNAMIC_CODE_TO	
							}
							
							
						}else if(UniUtils.indexOf(acCode, ["R1", "Z0", "Z1", "Z2", "Z3", "Z4", "Z5", "Z6", "Z7", "Z8", "Z9",	//사용자 정의 팝업 생성
															   "Z10","Z11","Z12","Z13","Z14","Z15","Z16","Z17","Z18","Z19","Z20",
															   "Z21","Z22","Z23","Z24","Z25","Z26","Z27","Z28","Z29", "Z34", "Z35"])){				
							if(fieldKind == 'toField'){
								Ext.apply(field, Unilite.popup('USER_DEFINE',{itemId: dynamicId + cnt, usePopup: 'userDefine', valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}})); // 빈팝업 생성
							}else{
								Ext.apply(field, Unilite.popup('USER_DEFINE',{itemId: dynamicId + cnt, usePopup: 'userDefine', valueFieldName: fName, textFieldName: fDataName, listeners: {onSelected: { fn: function(records, type){if(!otherForm) return false; otherForm.setValue(fName, form.getValue(fName)); otherForm.setValue(fDataName, form.getValue(fDataName));}, scope: this}, onClear: function(type){if(!otherForm) return false; otherForm.setValue(fName, ''); otherForm.setValue(fDataName, '');}}})); // 빈팝업 생성
							}
						}
	    				break;
	    		}
			}else {
	    		switch(acType)	{
	    			case 'A': 
	    				if(acCode == 'O2') {
	    					Ext.apply(field, 
	    							 {
	    								xtype:'fieldcontainer',
	    								fieldLabel:acName, 
	    								tdAttrs:{style : {'margin-top':'0px'}},
	    								layout:{type:'table', columns:2, tableAttrs:{cellpadding:0, cellspacing:0, border:0}}, 
	    								items:[{
	    								  	xtype:'uniTextfield', 
	    								  	name:fName, 
	    								  	maxLength: acLen, 
	    								  	enforceMaxLength: true, 
	    								  	listeners: { 
	    								  		change: function(combo, newValue, oldValue, eOpts){if(!otherForm) return ; otherForm.setValue(fName, form.getValue(fName));}
	    								  	}
	    								},{
	    								  	xtype:'displayfield',
	    								  	name:fDataName,
	    								  	value:''
	    								}]
	    							}
	    					);
	    				}else {
	    					Ext.apply(field, {fieldLabel:acName, xtype:'uniTextfield', name:fName, maxLength: acLen, enforceMaxLength: true, listeners: { change: function(combo, newValue, oldValue, eOpts){if(!otherForm) return ; otherForm.setValue(fName, form.getValue(fName));}}});
	    				}
	    				break;
	    			case 'N': 
	    				if(acCode == 'I1' || acCode == 'I6') {
	    					Ext.apply(field, {fieldLabel:acName, xtype:'uniNumberfield', name:fName, maxLength: acLen, enforceMaxLength: true, 
	    										
	    										listeners: { 
	    											'change': function(nfield, newValue, oldValue, eOpts){
	    												if(!otherForm) return ; 
	    												otherForm.setValue(fName, form.getValue(fName));
	    												
	    												var price = 0, tax = 0;
														console.log(" 공급가액 record : ", record);
														if(record){
		    												for(var i=1;i <=6 ;i++)	{
		    													if(record.get('AC_CODE'+i) == 'I1') price = record.get('AC_DATA'+i) ;
		    													else if(record.get('AC_CODE'+i) == 'I6') tax  =  record.get('AC_DATA'+i) ;
		    												}
		    												var sum = parseFloat(Unilite.nvl(price,0)) + parseFloat(Unilite.nvl(tax,0));
		    												var cmp = form.down('#acItem5');
		    												if(cmp && cmp.getEl() && cmp.getEl().dom) cmp.getEl().dom.innerHTML = '<div style="text-align:right">VAT 포함: '+Ext.util.Format.number(sum,UniFormat.Price)+'원</div>';
														}
	    											}
	    										}
	    									});
	    				}else {
	    					Ext.apply(field, {fieldLabel:acName, xtype:'uniNumberfield', name:fName, maxLength: acLen, enforceMaxLength: true, listeners: { change: function(combo, newValue, oldValue, eOpts){if(!otherForm) return ; otherForm.setValue(fName, form.getValue(fName));}}});
	    				}
	    				break;
	    			case 'D': Ext.apply(field, {fieldLabel:acName, xtype:'uniDatefield', name:fName, formatText: Unilite.dateFormat,
	    										listeners: { 
	    											change: function(field, newValue, oldValue, eOpts){
	    												if(Ext.isDate(field.getValue()))	{
		    												if(!otherForm) return ; 
		    												otherForm.setValue(fName, UniDate.getDateStr(field.getValue()));
		    												
	    													var grdRecord = record;
		    												if(grdRecord)	{
		    													grdRecord.set(fName, UniDate.getDateStr(field.getValue()));
		    												}
	    												}
	    											},
	    											blur:function(field,  eOpts){
	    												var grdRecord = record;
	    												if(grdRecord)	{
	    													grdRecord.set(fName, UniDate.getDateStr(field.getValue()));
	    												}
	    											}
	    										}
	    									  });
	    				break;
	    			default:
	    				break;
	    		}
			}
			if(acType=='N')	{
				switch(acFormat)	{
	    			case 'Q': Ext.apply(field, {uniType:'uniQty'});	
	    				break;
	    			case 'P': Ext.apply(field, {uniType:'uniUnitPrice'}); 
	    				break;
	    			case 'I': Ext.apply(field, {uniType:'uniPrice'});
	    				break;
	    			case 'O': Ext.apply(field, {uniType:'uniFC'});
	    				break;
	    			case 'R': Ext.apply(field, {uniType:'uniER'});
	    				break;
	    			default:
	    				break;
	    		}
			}
			if(acCtl == 'Y')	{
				Ext.apply(field, {allowBlank: false, labelClsExtra :'required_field_label'});
			}
			//cnt++;
			return field;		
		},
		
		addMadeFields : function(n,fName,fDataName, form, dataMap, otherForm,  opt, record, prevRecord)	{
	    	var  acCode, acName, acType, acPopup, acLen, acCtl, acFormat;
	    	var field1, field3, field5	//필드간의 간격 조정위해 앞에 필드들이 팝업필드인지 일반필드인지 확인
			console.log('dataMap: ',dataMap)
			
			if(form.down('#formFieldArea'+(n+1))){
				form.down('#formFieldArea'+n).removeAll();
				form.down('#formFieldArea'+(n+1)).removeAll();		
			}else{
				form.down('#formFieldArea'+n).removeAll();
			}
			
//			form.on('add', function(form, component){
//				if(!component.allowBlank){
//					component.labelClsExtra = 'required_field_label'
//				}
//			})
			
			if(opt == '1'){		//미결 항목용
				
			}else if(opt == '2'){	//계정잔액1,2용
				acCode= dataMap['BOOK_CODE1'];
				var i;
				for(i=1; i<7; i++){
					if(acCode  == dataMap['AC_CODE'  + (i)]){
						acType  = dataMap['AC_TYPE'  + (i)];
						acPopup = dataMap['AC_POPUP' + (i)];
						acLen   = dataMap['AC_LEN'   + (i)];
					}
				}
				if(!Ext.isEmpty(acCode)){
					//fName = 'BOOK_CODE1';
					//fDataName = 'BOOK_NAME1';
					acName = dataMap['BOOK_NAME1'];
//					acCtl = dataMap['AC_CTL1'];
//					acFormat = dataMap['AC_FORMAT1'];
					var field = UniAppManager.app.makeItem(n,acCode,  acName,	fName+n,	fDataName+n, fName, fDataName, acType, acPopup, acLen, acCtl, acFormat, '', form, otherForm)
					if(Ext.isEmpty(field.fieldLabel)) return false;
					field1 = field;
					if(!Ext.isEmpty(field.usePopup)){
						form.down('#formFieldArea'+n).add(field);
						UniAccnt.setDynamicPopup(field, form, acCode, acName);
					}else{
						form.down('#formFieldArea'+n).add(field);
					}			
					
				}else {
					form.down('#formFieldArea'+n).add(UniAccnt.makeBlankField());	
				}
				
				acCode= dataMap['BOOK_CODE2'];
				for(i=1; i<7; i++){
					if(acCode  == dataMap['AC_CODE'  + (i)]){
						acType  = dataMap['AC_TYPE'  + (i)];;
						acPopup = dataMap['AC_POPUP' + (i)];;
						acLen   = dataMap['AC_LEN'   + (i)];
					}
				}
				if(!Ext.isEmpty(acCode))	{
					//fName = 'BOOK_CODE2';
					//fDataName = 'BOOK_NAME2';
					acName = dataMap['BOOK_NAME2'];
//					acCtl = dataMap['AC_CTL1'];
//					acFormat = dataMap['AC_FORMAT1'];
					var field = UniAppManager.app.makeItem(n,acCode,  acName,	fName+(n+1),	fDataName+(n+1),	fName+n,	fDataName+n,	acType, acPopup, acLen, acCtl, acFormat, '', form, otherForm)
					if(Ext.isEmpty(field.fieldLabel)) return false;
					field1 = field;
					if(!Ext.isEmpty(field.usePopup)){
						if(form.down('#formFieldArea'+(n+1))){
							form.down('#formFieldArea'+(n+1)).add(field);		
						}else{
							form.down('#formFieldArea'+n).add(field);
						}					
						UniAccnt.setDynamicPopup(field, form, acCode, acName);
					}else{
						if(form.down('#formFieldArea'+(n+1))){
							form.down('#formFieldArea'+(n+1)).add(field);		
						}else{
							form.down('#formFieldArea'+n).add(field);
						}
					}			
				}else {
					if(form.down('#formFieldArea'+(n+1))){
						form.down('#formFieldArea'+(n+1)).removeAll();		
					}			
				}
			}else{	//관리항목 1~6용
				
				
			}
			
			//form.masterGrid.addChildForm(form);
			form._onAfterRenderFunction(form);
			 
			console.log('form:', form);
		},	
		
		
	});
};


</script>
