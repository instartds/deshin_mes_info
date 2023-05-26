<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afn100rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A047" /> <!-- 어음구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A058" /> <!-- 어음종류 -->
	<t:ExtComboStore comboType="AU" comboCode="A057" /> <!-- 어음보관장소 -->
	<t:ExtComboStore comboType="AU" comboCode="A063" /> <!-- 어음상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B064" /> <!-- 수취구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'center',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [		    
	    	{ 
		        fieldLabel: '일 자',
				xtype: 'uniDateRangefield',  
				startFieldName: 'FR_DATE',
				endFieldName:'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
//                	if(panelSearch) {
//						panelSearch.setValue('FR_DATE',newValue);
//                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
//			    	if(panelSearch) {
//			    		panelSearch.setValue('TO_DATE',newValue);
//			    	}   	
			    }
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '일자기준',
				colspan:3,
				items: [{
						boxLabel: '만기일', 
						width: 65, 
						name: 'ESS',
						inputValue: 'MGDay' 
					},{
						boxLabel : '발행일', 
						width: 65,
						name: 'ESS',
						inputValue: 'BHDay'
					},{
						boxLabel : '전표일', 
						width: 65,
						name: 'ESS',
						inputValue: 'JPDay'
					},{
						boxLabel : '반제일', 
						width: 65,
						name: 'ESS',
						inputValue: 'BJDay'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
//							panelSearch.getField('ESS').setValue(newValue.ESS);
						}
					}
				},{	
			 		fieldLabel: '어음구분',
			 		name:'AC_CD', 
			 		xtype: 'uniCombobox',
			 		comboType:'AU',
			 		comboCode:'A047',
			 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
//							panelSearch.setValue('AC_CD', newValue);
						}
					}
		 		},{
			 		fieldLabel: '어음상태',
			 		name:'NOTE_STS', 
			 		xtype: 'uniCombobox',
			 		comboType:'AU',
			 		comboCode:'A063',
					colspan:3,
			 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
//							panelSearch.setValue('NOTE_STS', newValue);
						}
					}
		 		},
					Unilite.popup('BANK',{ 
				    	fieldLabel: '은행코드', 
				    	popupWidth: 500,
						autoPopup   : true ,
				    	valueFieldName: 'BANK_CODE',
						textFieldName: 'BANK_NAME',
				    	listeners: {
							onSelected: {
								fn: function(records, type) {
//									panelSearch.setValue('BANK_CODE', panelResult.getValue('BANK_CODE'));
//									panelSearch.setValue('BANK_NAME', panelResult.getValue('BANK_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
//								panelSearch.setValue('BANK_CODE', '');
//								panelSearch.setValue('BANK_NAME', '');
							},
							applyextparam: function(popup){							
								//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
				}),   	
				Unilite.popup('CUST',{ 
			    	fieldLabel: '거래처', 
			    	popupWidth: 710,
					allowBlank:true,
					autoPopup:false,
					validateBlank:false,
					colspan:3,
			    	valueFieldName: 'CUSTOM_CODE',
					textFieldName: 'CUSTOM_NAME',
			    	listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {									
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_CODE', '');
							}
						},
		    			onTextSpecialKey: function(elm, e){
		                    if (e.getKey() == e.ENTER) {
		                    	UniAppManager.app.onQueryButtonDown();  
		                	}
		                }
					}
			}),
			{
					fieldLabel:'어음번호', 
					xtype: 'uniTextfield',
					name: 'NOTE_NUM_FR'
				},{
					fieldLabel:'~', 
					xtype: 'uniTextfield',
					name: 'NOTE_NUM_TO'
				},{
			 		fieldLabel: '어음종류',
			 		name:'DC_DIVI', 
			 		xtype: 'uniCombobox',
			 		comboType:'AU',
			 		comboCode:'A058'
		 		},{
		 			fieldLabel: '수취구분',
			 		name:'RECEIPT_DIVI', 
			 		xtype: 'uniCombobox',
			 		comboType:'AU',
			 		comboCode:'B064'
			 	},
			
			
			
			{
				xtype: 'uniNumberfield',
				name: 'AMT1',
				fieldLabel:'받을어음금액',
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
//						panelSearch.setValue('AMT1', newValue);
					}
				}
			},{
				xtype: 'uniNumberfield',
				name: 'AMT2',
				fieldLabel:'지급어음금액',
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
//						panelSearch.setValue('AMT2', newValue);
					}
				}
			},{
				xtype: 'uniNumberfield',
				name: 'AMT3',
				fieldLabel:'합 계',
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
//						panelSearch.setValue('AMT3', newValue);
						}
				}
			},{
				xtype: 'checkboxgroup',		            		
				fieldLabel: '출력조건',
				colspan:3,
				items: [{
						boxLabel: '어음구분별 페이지처리 ', 
						width: 130, 
						name: 'NOTEORDER',
						checked: true  
					},{
						boxLabel : '만기일자순출력 ', 
						width: 130,
						name: 'EXPORDER'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
						}
					}
				},
				{
			     	xtype:'button',
			     	text:'출    력',
			     	width:235,
			     	tdAttrs:{'align':'center', style:'padding-left:95px'},
			     	handler:function()	{
			     		UniAppManager.app.onPrintButtonDown();
		     		}
         		}],
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
		id : 'afn100rkrApp',
		fnInitBinding : function(params) {
			activeSForm = panelResult;
			activeSForm.onLoadSelectText('FR_DATE');
			UniAppManager.setToolbarButtons('print',true);
			UniAppManager.setToolbarButtons(['query','reset','newData', 'prev', 'next','release','cancel'], false);
			
			if(!Ext.isEmpty(params) && !Ext.isEmpty(params.PGM_ID)){
                this.processParams(params); 
            }
		},
		onPrintButtonDown: function() {
			var param = panelResult.getValues();
			var reportGubun = '${gsReportGubun}';
			
			if(reportGubun == 'CLIP'){
				param.PGM_ID = 'afn100rkr';		//프로그램ID
				param.MAIN_CODE = 'A126';		//해당 모듈의 출력정보를 가지고 있는 공통코드
				param.sTxtValue2_fileTitle = '어음명세출력';
				
				param.NOTEORDER = (panelResult.getField('NOTEORDER').getValue() ? 'Y' : 'N');
				param.EXPORDER  = (panelResult.getField('EXPORDER' ).getValue() ? 'Y' : 'N');
				
				
				var win = Ext.create('widget.ClipReport', {
					url: CPATH+'/accnt/afn100clrkrPrint.do',
					prgID: 'afn100rkr',
					extParam: param
				});
				win.center();
				win.show();
			}
			else {
				var win = Ext.create('widget.PDFPrintWindow', {
					url: CPATH+'/afn/afn100rkr.do',
					prgID: 'afn100rkr',
					extParam: param
				});
				win.center();
				win.show();
			}
		},
        //링크로 넘어오는 params 받는 부분 
        processParams: function(params) {
            //this.uniOpt.appParams = params;
            if(params.PGM_ID == 's_afn100skr_yg') {
                //alert(params.ESS);
                panelResult.setValue('FR_DATE'      , params.FR_DATE);
                panelResult.setValue('TO_DATE'      , params.TO_DATE);
                panelResult.getField('ESS').setValue(params.ESS);
                panelResult.setValue('AC_CD'        , params.AC_CD);
                panelResult.setValue('NOTE_STS'     , params.NOTE_STS);
                panelResult.setValue('BANK_CODE'    , params.BANK_CODE);
                panelResult.setValue('BANK_NAME'    , params.BANK_NAME);
                panelResult.setValue('CUSTOM_CODE'  , params.CUSTOM_CODE);
                panelResult.setValue('CUSTOM_NAME'  , params.CUSTOM_NAME);
                panelResult.setValue('NOTE_NUM_FR'  , params.NOTE_NUM_FR);
                panelResult.setValue('NOTE_NUM_TO'  , params.NOTE_NUM_TO);
                panelResult.setValue('DC_DIVI'      , params.DC_DIVI);
                panelResult.setValue('RECEIPT_DIVI' , params.RECEIPT_DIVI);
                
            }
            if(params.PGM_ID == 'afn100skr') {
                panelResult.setValue('FR_DATE'      , params.FR_DATE);
                panelResult.setValue('TO_DATE'      , params.TO_DATE);
                panelResult.setValue('AC_CD'        , params.AC_CD);
                panelResult.setValue('NOTE_STS'     , params.NOTE_STS);
                panelResult.setValue('BANK_CODE'    , params.BANK_CODE);
                panelResult.setValue('BANK_NAME'    , params.BANK_NAME);
                panelResult.setValue('CUSTOM_CODE'  , params.CUSTOM_CODE);
                panelResult.setValue('CUSTOM_NAME'  , params.CUSTOM_NAME);
                panelResult.setValue('NOTE_NUM_FR'  , params.NOTE_NUM_FR);
                panelResult.setValue('NOTE_NUM_TO'  , params.NOTE_NUM_TO);
                panelResult.setValue('DC_DIVI'      , params.DC_DIVI);
                panelResult.setValue('RECEIPT_DIVI' , params.RECEIPT_DIVI);
                panelResult.setValue('AMT1'         , params.AMT1);
                panelResult.setValue('AMT2'         , params.AMT2);
                panelResult.setValue('AMT3'         , params.AMT3);
                panelResult.getField('ESS').setValue(params.ESS);
                
            }
        }
	});
};


</script>
