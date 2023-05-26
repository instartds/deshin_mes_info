<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afs520rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐유형-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var getStDt = ${getStDt};
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수

function appMain() {     
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'center',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
		 		fieldLabel: '전표일',
		 		xtype: 'uniDatefield',
		 		name: 'AC_DATE',
		 		value: UniDate.get('today'),
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
//						panelSearch.setValue('AC_DATE', newValue);
//						UniAppManager.app.fnSetStDate(newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
						}
					}
		    },
//		    	{
//		 		fieldLabel: 'hidden',
//		 		name:'DIV_CODE_NANE', 
//		 		xtype: 'uniTextfield',
//		 		hidden: true,
//				hideLabel:true,
//		 		listeners: {
//					change: function(field, newValue, oldValue, eOpts) {						
////						panelSearch.setValue('MONEY_UNIT', newValue);
//					}
//				}
//		    },
				Unilite.popup('ACCNT',{ 
				    fieldLabel: '계정과목',		    
				    valueFieldName: 'ACCNT_CODE',
					textFieldName: 'ACCNT_NAME',
					listeners: {
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'ADD_QUERY' : "SUBSTRING(SPEC_DIVI,1,1) IN ('B','C')",
                                    'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                                }
                                popup.setExtParam(param);
                            }
                        }
					}
			}),
				Unilite.popup('BANK_BOOK',{ 
				    fieldLabel: '통장',	
				    colspan: 2,					    
				    valueFieldName: 'BANK_BOOK_CODE',
					textFieldName: 'BANK_BOOK_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
//								panelSearch.setValue('BANK_BOOK_CODE', panelResult.getValue('BANK_BOOK_CODE'));
//								panelSearch.setValue('BANK_BOOK_NAME', panelResult.getValue('BANK_BOOK_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
//							panelSearch.setValue('BANK_BOOK_CODE', '');
//							panelSearch.setValue('BANK_BOOK_NAME', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
		 		fieldLabel: '화폐',
		 		name:'MONEY_UNIT', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'B004', 
		 		displayField: 'value',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
//						panelSearch.setValue('MONEY_UNIT', newValue);
					}
				}
			},
				Unilite.popup('BANK',{ 
				    fieldLabel: '은행',	
				    valueFieldName: 'BANK_CODE',
					textFieldName: 'BANK_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
//								panelSearch.setValue('BANK_CODE', panelResult.getValue('BANK_CODE'));
//								panelSearch.setValue('BANK_NAME', panelResult.getValue('BANK_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
//							panelSearch.setValue('BANK_CODE', '');
//							panelSearch.setValue('BANK_NAME', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),{ 
	    			fieldLabel: '당기시작년월',
	    			name:'ST_DATE',
					xtype: 'uniMonthfield',
	//				value: UniDate.get('today'),
					holdable:'hold',
					allowBlank:false,
					width: 200
				},{
         	xtype:'button',
         	text:'출    력',
         	width:235,
         	tdAttrs:{'align':'center', style:'padding-left:95px'},
         	handler:function()	{
         		UniAppManager.app.onPrintButtonDown();
         	}
         }
			],
			setAllFieldsReadOnly: function(b) { 
			    var r= true
			    if(b) {
			    	var invalid = this.getForm().getFields().filterBy(function(field) {
			        	return !field.validate();
			        });                      
			        if(invalid.length > 0) {
			     		r=false;
			         	var labelText = ''
			     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
			          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
			        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
			          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
			        	}
						alert(labelText+Msg.sMB083);
			        	invalid.items[0].focus();
			     	} else {
			      		//this.mask();
			      		var fields = this.getForm().getFields();
			      		Ext.each(fields.items, function(item) {
			       			if(Ext.isDefined(item.holdable) ) {
			         			if (item.holdable == 'hold') {
			         				item.setReadOnly(true); 
			        			}
			       			} 
			       			if(item.isPopupField) {
			        			var popupFC = item.up('uniPopupField') ;       
			        			if(popupFC.holdable == 'hold') {
			         				popupFC.setReadOnly(true);
			        			}
			       			}
			      		})
			       	}
			    } else {
			    	//this.unmask();
			       	var fields = this.getForm().getFields();
			     	Ext.each(fields.items, function(item) {
			      		if(Ext.isDefined(item.holdable) ) {
			        		if (item.holdable == 'hold') {
			        			item.setReadOnly(false);
			       			}
			      		} 
			      		if(item.isPopupField) {
			       			var popupFC = item.up('uniPopupField') ; 
			       			if(popupFC.holdable == 'hold' ) {
			        			item.setReadOnly(false);
			      			}
			      		}
			     	})
			    }
			    return r;
			}
	});
	
	
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
					panelResult
				]
			}
			 	
		], 
		id : 'afs520skrApp',
		fnInitBinding : function() {
			activeSForm = panelResult;
			activeSForm.onLoadSelectText('AC_DATE');
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('print',true);
			UniAppManager.setToolbarButtons(['query','reset','newData', 'prev', 'next','release','cancel'], false);
			panelResult.setValue('ST_DATE',getStDt[0].STDT);
			panelResult.setValue('AC_DATE',UniDate.get('today'));
			panelResult.setValue('AC_DATE',UniDate.get('today'));	
		},
		onPrintButtonDown: function() {
			var param = panelResult.getValues();
			var adcArr = new Array();
			adcArr[0] = param["ACCNT_DIV_CODE"]; 
			param["ACCNT_DIV_CODE"] = adcArr;
			//测试打印报表
			var win = Ext.create('widget.PDFPrintWindow', {
				method:'POST',
				url: CPATH+'/afs/afs520rkr.do',
				prgID: 'afs520rkr',
				extParam: panelResult.getValues()
				});
			win.center();
			win.show();
		}
	});
};


</script>
