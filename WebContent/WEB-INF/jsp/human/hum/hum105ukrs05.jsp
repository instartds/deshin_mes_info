<%@page language="java" contentType="text/html; charset=utf-8"%>
var payGrdWin;
var wageStd = ${wageStd};
var grade_flag = '';

 var salaryInfo =	{
			title:'급여정보',
			itemId: 'salaryInfo',
			layout:{type:'vbox', align:'stretch'},			
        	items:[
        			basicInfo
        			,{
            			xtype: 'uniDetailForm',
	        			itemId: 'salaryForm',
	        			disabled: false,
			            api: {
				         		 load: hum105ukrService.select,
				         		 submit: hum105ukrService.saveHum100
						},
						bodyCls: 'human-panel-form-background',
            			layout:{type:'uniTable', columns:'6'},
            			defaultType: 'uniTextfield',
    					defaults: {
    							width:285,
	        					labelWidth:125
	        					},
	        			margin:'0 10 0 10',
	        			padding:'0',
    					flex: 1,
            			items: [
            				{
							 	name:'PERSON_NUMB' ,
							 	hidden: true
							},{
                                name:'ANNOUNCE_CODE' ,
                                hidden: true
                            }
                            ,{
                                name:'POST_CODE' ,
                                hidden: true
                            },{	
		            	  	 	fieldLabel: '연봉',
							 	name:'ANNUAL_SALARY_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:true,
							 	value:0,
							 	colspan: 3,
							 	listeners:{
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue(0);
							 			}
							 		}
							 	}
							},{
		            	  	 	fieldLabel: '년월차기준금',
							 	name:'COM_YEAR_WAGES' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:true,
							 	value:0,   
							 	colspan: 2,  
							 	listeners:{
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue(0);
							 			}
							 		}
							 	}
							},{
		            	  	 	fieldLabel: '급여지급',
							 	name:'PAY_PROV_YN' , 
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'PAY_PROV_YN', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다'	, name:'PAY_PROV_YN', inputValue:'N'}
				  				]
							}, {
								xtype		: 'container',
								layout		: {type: 'uniTable', columns: 2},
            					defaultType	: 'uniTextfield',
								colspan		: 3,
								padding		: '0 0 0 36',
								items		: [{
			            	  	 	fieldLabel: '호봉 급',
								 	name:'PAY_GRADE_01',
								 	width:120,
								 	//readOnly:true,
		                			listeners:{
		                				render:function(el)	{
		                					el.getEl().on('dblclick', function(){
		                						grade_flag = '01';
										    	wageCodePopup();
										    });
		                				}
		                			}
								},{
			            	  	 	
								 	name:'PAY_GRADE_01_NAME',
								 	width:113,
								 	labelWidth:13,
			                			listeners:{
			                				render:function(el)	{
			                					el.getEl().on('dblclick', function(){
		                							grade_flag = '01';
											    	wageCodePopup();
											    });
			                				}
			                			}
								}]
							},{
		            	  	 	fieldLabel: '상여구분자',
							 	name:'BONUS_KIND',
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H037'  ,   
							 	colspan: 2
							},{
		            	  	 	fieldLabel: '급여지급보류',
							 	name:'PAY_PROV_STOP_YN', 
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'PAY_PROV_STOP_YN', inputValue:'Y'},
				 					{boxLabel:'안한다'	, name:'PAY_PROV_STOP_YN', inputValue:'N', checked:true}
				  				]
							 	
							},{
                                xtype       : 'container',
                                layout      : {type: 'uniTable', columns: 4},
                                defaultType : 'uniTextfield',
                                colspan     : 3,
                                padding		: '0 0 0 36',
                                items       : [{
                                    fieldLabel: '호봉 호',
                                    name:'PAY_GRADE_02',
                                    width:120,
                                    listeners:{
                                        render:function(el) {
                                            el.getEl().on('dblclick', function(){
                                                grade_flag = '02';
                                                wageCodePopup();
                                            });
                                        }
                                    }
                                },{
                                    fieldLabel: '직',
                                    name:'PAY_GRADE_03',
                                    width:43,
                                    labelWidth:13,
                                        listeners:{
                                            render:function(el) {
                                                el.getEl().on('dblclick', function(){
                                                    grade_flag = '03';
                                                    wageCodePopup();
                                                });
                                            }
                                        }
                                },{
                                    fieldLabel: '기',
                                    name:'PAY_GRADE_04',
                                    width:43,
                                    labelWidth:13,
                                        listeners:{
                                            render:function(el) {
                                                el.getEl().on('dblclick', function(){
                                                    grade_flag = '04';
                                                    wageCodePopup();
                                                });
                                            }
                                        }
                                },{
                                    fieldLabel: '조',
                                    name:'PAY_GRADE_05',
                                    width:43,
                                    labelWidth:13,
                                        listeners:{
                                            render:function(el) {
                                                el.getEl().on('dblclick', function(){
                                                    grade_flag = '05';
                                                    wageCodePopup();
                                                });
                                            }
                                        }
                                }]
                            },
							
							/*{
		            	  	 	xtype:'component',
		            	  	 	html:'<div style="margin-left:100px">근속</div>',
		            	  	 	width:150
							},{
		            	  	 	fieldLabel:'년',
							 	name:'YEAR_GRADE',
							 	width:60,
							 	labelWidth:20
							},{
		            	  	 	hideLabel:true,
							 	name:'YEAR_GRADE_BASE',
							 	width:60,
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H174'  
							},*/
								{
		            	  	 	fieldLabel: '상여기준금',
							 	name:'BONUS_STD_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:true,
							 	value:0,  
							 	colspan: 2,
							 	listeners:{
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue(0);
							 			}
							 		}
							 	}
							},{
		            	  	 	fieldLabel: '세액계산',
							 	name:'COMP_TAX_I' , 
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'COMP_TAX_I', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다'	, name:'COMP_TAX_I', inputValue:'N'}
				  				]
							},{
		            	  	 	fieldLabel: '기본급',
		            	  	 	
							 	name:'WAGES_STD_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:true,
							 	readOnly:false,
							 	value:0,  
							 	colspan: 3,
							 	listeners:{
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue('');
							 			}
							 		}
							 	}
							},{
		            	  	 	fieldLabel: '건강보험증번호',
							 	name:'MED_INSUR_NO' ,   
							 	colspan: 2
							},{
		            	  	 	fieldLabel: '고용보험계산',
							 	name:'HIRE_INSUR_TYPE' , 
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'HIRE_INSUR_TYPE', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다'	, name:'HIRE_INSUR_TYPE', inputValue:'N'}
				  				]
							},{
		            	  	 	fieldLabel: '기본급2',
							 	name:'PAY_PRESERVE_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:true,
							 	value:0,
							 	colspan: 3,
							 	listeners:{
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue(0);
							 			}
							 		}
							 	}
							},{
		            	  	 	fieldLabel: '월평균보수액(건강)',
							 	name:'MED_AVG_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:true,
							 	value:0,
							 	width: 210,
							 	listeners: {
							 		blur: function(field, event, eOpt)	{
							 			panelDetail.down('#salaryInfo').mask();
							 			if(field.getValue() == 0) {
                                            var form = panelDetail.down('#salaryForm');
                                            form.setValue('MED_AVG_I', 0); 
							 				form.setValue('MED_INSUR_I', 0); 
                                            form.setValue('OLD_MED_INSUR_I', 0); 
                                            form.setValue('ORI_MED_INSUR_I', 0); 
                                            panelDetail.down('#salaryInfo').unmask();
							 			} else {
    							 			hum105ukrService.getMonthInsurI(
    							 				{
    							 					'MONTH_AVG_I':field.getValue(), 
    							 					'TYPE' : '2'
    							 				}, 
    							 				function(provider, response)	{
    							 					panelDetail.down('#salaryInfo').unmask();
    							 					var form = panelDetail.down('#salaryForm');
    							 					var oldValue = form.getValue('MED_INSUR_I');
    							 					if(!Ext.isEmpty(provider))	{
    								 					if(oldValue !=  provider['INSUR_I'])	{
    								 						form.setValue('MED_INSUR_I', provider['INSUR_I2']);	
                                                            form.setValue('OLD_MED_INSUR_I', provider['INSUR_I3']); 
                                                            form.setValue('ORI_MED_INSUR_I', provider['INSUR_I']); 	
    								 					}
    							 					}
    							 				}
    							 			)
							 			}
							 		},
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue(0);
							 			}
							 		}
							 	}
							},{
		            	  	 	fieldLabel: '건강보험금액',
							 	name:'MED_INSUR_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:true,
							 	value:0, 
							 	width: 70,
							 	hideLabel: true,
							 	listeners:{
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue(0);
							 			}
							 		}
							 	}
							 },{
		            	  	 	fieldLabel: '산재보험계산',
							 	name:'WORK_COMPEN_YN', 
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'WORK_COMPEN_YN', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다'	, name:'WORK_COMPEN_YN', inputValue:'N'}
				  				]
							},{
		            	  	 	fieldLabel: '지급차수',
							 	name:'PAY_PROV_FLAG' , 
							 	allowBlank:false,
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H031',   
							 	colspan: 3
							},{
		            	  	 	fieldLabel: '건강보험/노인요양(고지)',
							 	name:'ORI_MED_INSUR_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:true,
							 	value:0, 
							 	width: 210,
							 	listeners:{
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue(0);
							 			}
							 		}
							 	}
							},{
		            	  	 	fieldLabel: '노인요양보험금액',
							 	name:'OLD_MED_INSUR_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:true,
							 	value:0,
							 	width: 70,
							 	hideLabel: true,
							 	listeners:{
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue(0);
							 			}
							 		}
							 	}
							 },{
		            	  	 	fieldLabel: '상여지급',
							 	name:'BONUS_PROV_YN', 
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'BONUS_PROV_YN', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다'	, name:'BONUS_PROV_YN', inputValue:'N'}
				  				]
							},{
		            	  	 	fieldLabel: '급여지급방식',
							 	name:'PAY_CODE' , 
							 	allowBlank:false,
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H028',   
							 	colspan: 3
							},{
		            	  	 	fieldLabel: '월평균보수액(고용)',
							 	name:'HIRE_AVG_I' ,
							 	xtype:'uniNumberfield', 
							 	width: 210,
							 	allowBlank:true,
							 	value:0,
							 	
							 	listeners: {
							 		blur: function(field, event, eOpt)	{
							 			panelDetail.down('#salaryInfo').mask();
							 			hum105ukrService.getHireInsurI(
							 				{
							 					'HIRE_AVG_I':field.getValue(), 
							 					'TYPE' : '3'
							 				}, 
							 				function(provider, response)	{
							 					panelDetail.down('#salaryInfo').unmask();
							 					var form = panelDetail.down('#salaryForm');
							 					var oldValue = form.getValue('HIRE_INSUR_I');
							 					if(!Ext.isEmpty(provider))	{
								 					if(oldValue !=  provider['HIRE_INSUR_I'])	{
								 						form.setValue('HIRE_INSUR_I', provider['HIRE_INSUR_I']);	
								 					}
							 					}
							 				}
							 			);
							 		},
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue(0);
							 			}
							 		}
							 	}
							},{
		            	  	 	fieldLabel: '고용보험금액',
							 	name:'HIRE_INSUR_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:true,
							 	value:0,
							 	width: 70,
							 	hideLabel: true,
							 	listeners:{
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue(0);
							 			}
							 		}
							 	}
							},{
		            	  	 	fieldLabel: '년차수당지급',
							 	name:'YEAR_GIVE' , 
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'YEAR_GIVE', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다'	, name:'YEAR_GIVE', inputValue:'N'}
				  				]
							},{
		            	  	 	fieldLabel: '연장수당세액',
							 	name:'TAX_CODE' , 
							 	allowBlank:false,
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H029',   
							 	colspan: 3
							},{
		            	  	 	fieldLabel: '월평균보수액(연금)',
							 	name:'ANU_BASE_I' ,
							 	xtype:'uniNumberfield', 
							 	width: 210,
							 	allowBlank:true,
							 	value:0,
							 	listeners: {
							 		blur: function(field, event, eOpt)	{
							 			panelDetail.down('#salaryInfo').mask();
							 			hum105ukrService.getMonthInsurI(
							 				{
							 					'MONTH_AVG_I':field.getValue(), 
							 					'TYPE' : '1'
							 				}, 
							 				function(provider, response)	{
							 					panelDetail.down('#salaryInfo').unmask();
							 					var form = panelDetail.down('#salaryForm');
							 					var oldValue = form.getValue('ANU_INSUR_I');
							 					if(!Ext.isEmpty(provider))	{
								 					if(oldValue !=  provider['INSUR_I'])	{
								 						form.setValue('ANU_INSUR_I', provider['INSUR_I']);		
								 					}
							 					}
							 				}
							 			);
							 		},
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue(0);
							 			}
							 		}
							 	}
							},{
		            	  	 	fieldLabel: '국민연금금액',
							 	name:'ANU_INSUR_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:true,
							 	value:0, 
							 	width: 70,
							 	hideLabel: true,
							 	listeners:{
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue(0);
							 			}
							 		}
							 	}
							},{
		            	  	 	fieldLabel: '연말정산신고',
							 	name:'YEAR_CALCU'  ,
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'YEAR_CALCU', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다'	, name:'YEAR_CALCU', inputValue:'N'}
				  				]
							},{
		            	  	 	fieldLabel: '보육수당세액',
							 	name:'TAX_CODE2' ,
							 	xtype:'uniNumberfield',
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H029' ,   
							 	colspan: 3    ,
							 	listeners:{
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue(0);
							 			}
							 		}
							 	}
							},
							Unilite.popup('BANK',{
		            	  	 	fieldLabel: '급여이체은행',
							 	valueFieldName:'BANK_CODE1'   ,  
							 	textFieldName:'BANK_NAME1',
							 	valueFieldWidth:60,
							 	textFieldWidth:95,
							 	colspan: 2,
                                listeners: {
                                    onSelected: {
                                        fn: function(records, type) {
                                            UniAppManager.setToolbarButtons('save', true);                                            
                                        },
                                        scope: this
                                    },
                                    onClear: function(type) {
                                        UniAppManager.setToolbarButtons('save', true);
                                    }
                                }
							})
							,{
		            	  	 	fieldLabel: '노조가입',
							 	name:'LABOR_UNON_YN' ,
							 	xtype: 'uniRadiogroup',
							 	width:260,
							 	items: [
				 					{boxLabel:'가입'	, name:'LABOR_UNON_YN', inputValue:'Y', checked:true},
				 					{boxLabel:'미가입'	, name:'LABOR_UNON_YN', inputValue:'N'}
				  				]	
							},{
		            	  	 	fieldLabel: '제조판관구분',
							 	name:'MAKE_SALE' , 
							 	allowBlank:false,
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'B027',   
							 	colspan: 3
							},{
		            	  	 	fieldLabel: '계좌번호',
							 	name:'BANK_ACCOUNT1_EXPOS',   
							 	colspan: 2
							 	,value: '***************',
	                            readOnly:true,
	                            listeners:{
	                                afterrender:function(field) {
	                                    field.getEl().on('dblclick', field.onDblclick);
	                                }
	                            },
	                            onDblclick:function(event, elm) {      
	                            	var formPanel = panelDetail.down('#salaryForm');
	                            	
									var params = {'BANK_ACCOUNT':formPanel.getValue('BANK_ACCOUNT1'), 'GUBUN_FLAG': '2'};
									Unilite.popupCipherComm('form', formPanel, 'BANK_ACCOUNT1_EXPOS', 'BANK_ACCOUNT1', params);
	                            }
							},{
		            	  	 	fieldLabel: '계좌번호',
							 	name:'BANK_ACCOUNT1',   
							 	hidden:true
							},{
		            	  	 	fieldLabel: '퇴직금지급',
							 	name:'RETR_GIVE' , 
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'RETR_GIVE', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다'	, name:'RETR_GIVE', inputValue:'N'}
				  				]
							},{
		            	  	 	fieldLabel: 'Cost Pool',
							 	name:'COST_KIND'   ,   
							 	xtype: 'uniCombobox',
							 	store : Ext.StoreManager.lookup('costPoolCombo'),
							 	colspan: 3
							},{
		            	  	 	fieldLabel: '예금주',
							 	name:'BANKBOOK_NAME'   ,   
							 	colspan: 2
							},{
		            	  	 	fieldLabel: '퇴직연금',
							 	name:'RETR_PENSION_KIND' , 
							 	xtype: 'uniRadiogroup',
							 	width:320,
							 	tdAttrs:{align:'right'},
							 	items: [
				 					{boxLabel:'DB'		, name:'RETR_PENSION_KIND', inputValue:'DB', checked:true},
				 					{boxLabel:'DC'		, name:'RETR_PENSION_KIND', inputValue:'DC'},
				 					{boxLabel:'미가입'	, name:'RETR_PENSION_KIND', inputValue:'N'}
				  				]	
							},{
		            	  	 	fieldLabel: '소득세감면기한(100%)',
							 	name:'YOUTH_EXEMP_DATE' ,  
							 	xtype: 'uniDatefield',
							 	colspan: 3  
							},{
		            	  	 	fieldLabel: '소득세감면기한(50%)',
							 	name:'YOUTH_EXEMP_DATE2',   
							 	xtype: 'uniDatefield',   
							 	colspan: 2
							},{
		            	  	 	fieldLabel: '세율기준',
							 	name:'TAXRATE_BASE' , 
							 	xtype: 'uniRadiogroup',
							 	width:320,
							 	tdAttrs:{align:'right'},
							 	items: [
				 					{boxLabel:'80%'		, name:'TAXRATE_BASE', inputValue:'1'},
				 					{boxLabel:'100%'	, name:'TAXRATE_BASE', inputValue:'2', checked:true},
				 					{boxLabel:'120%'	, name:'TAXRATE_BASE', inputValue:'3'}
				  				]	
							},{
		            	  	 	fieldLabel: '소득세감면기한(70%)',
							 	name:'YOUTH_EXEMP_DATE3' ,  
							 	xtype: 'uniDatefield',
							 	colspan: 3  
							},{
		            	  	 	fieldLabel: 'E-Mail 주소',
							 	name:'EMAIL_ADDR'  ,   
							 	colspan: 2
							},{
		            	  	 	fieldLabel: '명세서이메일전송',
							 	name:'EMAIL_SEND_YN', 
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'EMAIL_SEND_YN', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다'	, name:'EMAIL_SEND_YN', inputValue:'N'}
				  				]
							},{
                                fieldLabel: '기본급',
                                name:'WAGES_AMT_01' ,  
                                xtype:'uniNumberfield', 
                                allowBlank:true,
                                readOnly:true,
                                value:0,
                                colspan: 3,
                                
                                listeners   : {
                                blur: function(field, event, eOpts ) {      
                                    panelDetail.down('#salaryInfo').unmask();
                                    var form = panelDetail.down('#salaryForm');
                                    var payGrad01 = form.getValue('PAY_GRADE_01');
                                    var amt02 = 0;
                                    var amt03 = 0;
                                    var num = 1.0;
                                    var wagesAmt01 = form.getValue('WAGES_AMT_01') * num.toFixed(1);
                                    var wagesAmt06 = form.getValue('WAGES_AMT_06') * num.toFixed(1);
                                    var wagesAmt03 = form.getValue('WAGES_AMT_03') * num.toFixed(1);
                                    var wagesAmt07 = form.getValue('WAGES_AMT_07') * num.toFixed(1);
                                    var wagesAmt13 = form.getValue('WAGES_AMT_13') * num.toFixed(1);
                                    
                                   // if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
                                        amt02 = (((Math.round(wagesAmt01.toFixed(1) / 209)) + (Math.round(wagesAmt06.toFixed(1) / 209)) + (Math.round(wagesAmt03.toFixed(1) / 209)) + (Math.round(wagesAmt07.toFixed(1) / 209)) + (Math.round(wagesAmt13.toFixed(1) / 209))) * 22) * 1.5
                                    
                                        form.setValue('WAGES_AMT_02', amt02.toFixed(1)); 
                                       // }
                                    amt03 = form.getValue('WAGES_AMT_01') + form.getValue('WAGES_AMT_02') + form.getValue('WAGES_AMT_03') + form.getValue('WAGES_AMT_04') + form.getValue('WAGES_AMT_05') + 
							                form.getValue('WAGES_AMT_06') + form.getValue('WAGES_AMT_07') + form.getValue('WAGES_AMT_08') + form.getValue('WAGES_AMT_09') + form.getValue('WAGES_AMT_10') +
							                form.getValue('WAGES_AMT_11') + form.getValue('WAGES_AMT_12') + form.getValue('WAGES_AMT_13')
							                form.setValue('WAGES_AMT_14',amt03);
                                    }
                                }
                                
                                /*listeners: {
                                    blur: function(field, event, eOpt)  {
                                        panelDetail.down('#salaryInfo').mask();
                                        hum105ukrService.getMonthInsurI(
                                            {
                                                'MONTH_AVG_I':field.getValue(), 
                                                'TYPE' : '1'
                                            }, 
                                            function(provider, response)    {
                                                panelDetail.down('#salaryInfo').unmask();
                                                var form = panelDetail.down('#salaryForm');
                                                var oldValue = form.getValue('ANU_INSUR_I');
                                                if(!Ext.isEmpty(provider))  {
                                                    if(oldValue !=  provider['INSUR_I'])    {
                                                        form.setValue('ANU_INSUR_I', provider['INSUR_I']);      
                                                    }
                                                }
                                            }
                                        );
                                    },
                                    change:function(field, newValue, oldValue)  {
                                    	
                                    	var form = panelDetail.down('#salaryForm');
                                        var oldValue = form.getValue('WAGES_AMT_01');
                                    	
                                    	
                                        if(Ext.isEmpty(newValue))   {
                                            field.setValue(0);
                                        }
                                    }
                                }*/
                                
                            },{
                                fieldLabel: '시간외수당',
                                name:'WAGES_AMT_02'  ,  
                                xtype:'uniNumberfield', 
                                allowBlank:true,
                                value:0,
                                readOnly:true,
                                colspan: 2,
                                listeners   : {
                                blur: function(field, event, eOpts ) {      
                                    		panelDetail.down('#salaryInfo').unmask();
							                var form = panelDetail.down('#salaryForm');
							                var amt02 = 0;
							                amt02 = form.getValue('WAGES_AMT_01') + form.getValue('WAGES_AMT_02') + form.getValue('WAGES_AMT_03') + form.getValue('WAGES_AMT_04') + form.getValue('WAGES_AMT_05') + 
							                form.getValue('WAGES_AMT_06') + form.getValue('WAGES_AMT_07') + form.getValue('WAGES_AMT_08') + form.getValue('WAGES_AMT_09') + form.getValue('WAGES_AMT_10') +
							                form.getValue('WAGES_AMT_11') + form.getValue('WAGES_AMT_12') + form.getValue('WAGES_AMT_13')
							                form.setValue('WAGES_AMT_14',amt02);
                                    }
                                }
                            },{
                                fieldLabel: '직책수당',
                                name:'WAGES_AMT_03', 
                                xtype:'uniNumberfield', 
                                allowBlank:true,
                                value:0, 
                                readOnly:true,
                                listeners   : {
                                blur: function(field, event, eOpts ) {      
                                    panelDetail.down('#salaryInfo').unmask();
                                    var form = panelDetail.down('#salaryForm');
                                    var payGrad01 = form.getValue('PAY_GRADE_01');
                                    var amt02 = 0;
                                    var amt03 = 0;
                                    var num = 1.0;
                                   var wagesAmt01 = form.getValue('WAGES_AMT_01') * num.toFixed(1);
                                    var wagesAmt06 = form.getValue('WAGES_AMT_06') * num.toFixed(1);
                                    var wagesAmt03 = form.getValue('WAGES_AMT_03') * num.toFixed(1);
                                    var wagesAmt07 = form.getValue('WAGES_AMT_07') * num.toFixed(1);
                                    var wagesAmt13 = form.getValue('WAGES_AMT_13') * num.toFixed(1);
                                    
                                   // if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
                                        amt02 = (((Math.round(wagesAmt01.toFixed(1) / 209)) + (Math.round(wagesAmt06.toFixed(1) / 209)) + (Math.round(wagesAmt03.toFixed(1) / 209)) + (Math.round(wagesAmt07.toFixed(1) / 209)) + (Math.round(wagesAmt13.toFixed(1) / 209))) * 22) * 1.5
                                    
                                        form.setValue('WAGES_AMT_02', amt02.toFixed(1)); 
                                    //   }
                                    amt03 = form.getValue('WAGES_AMT_01') + form.getValue('WAGES_AMT_02') + form.getValue('WAGES_AMT_03') + form.getValue('WAGES_AMT_04') + form.getValue('WAGES_AMT_05') + 
							                form.getValue('WAGES_AMT_06') + form.getValue('WAGES_AMT_07') + form.getValue('WAGES_AMT_08') + form.getValue('WAGES_AMT_09') + form.getValue('WAGES_AMT_10') +
							                form.getValue('WAGES_AMT_11') + form.getValue('WAGES_AMT_12') + form.getValue('WAGES_AMT_13')
							                form.setValue('WAGES_AMT_14',amt03);
                                    }
                                }
                            },{
                                fieldLabel: '기술수당',
                                name:'WAGES_AMT_04' ,  
                                xtype:'uniNumberfield', 
                                allowBlank:true,
                                value:0,
                                readOnly:true,
                                colspan: 3, 
                                listeners   : {
                                blur: function(field, event, eOpts ) {      
                                    panelDetail.down('#salaryInfo').unmask();
                                    var form = panelDetail.down('#salaryForm');
                                    var payGrad01 = form.getValue('PAY_GRADE_01');
                                    var amt02 = 0;
                                    var amt03 = 0;
                                    var num = 1.0;
                                    var wagesAmt01 = form.getValue('WAGES_AMT_01') * num.toFixed(1);
                                    var wagesAmt06 = form.getValue('WAGES_AMT_06') * num.toFixed(1);
                                    var wagesAmt03 = form.getValue('WAGES_AMT_03') * num.toFixed(1);
                                    var wagesAmt07 = form.getValue('WAGES_AMT_07') * num.toFixed(1);
                                    var wagesAmt13 = form.getValue('WAGES_AMT_13') * num.toFixed(1);
                                    
                                   //if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
                                        amt02 = (((Math.round(wagesAmt01.toFixed(1) / 209)) + (Math.round(wagesAmt06.toFixed(1) / 209)) + (Math.round(wagesAmt03.toFixed(1) / 209)) + (Math.round(wagesAmt07.toFixed(1) / 209)) + (Math.round(wagesAmt13.toFixed(1) / 209))) * 22) * 1.5
                                    
                                        form.setValue('WAGES_AMT_02', amt02.toFixed(1)); 
                                      //  }
                                     amt03 = form.getValue('WAGES_AMT_01') + form.getValue('WAGES_AMT_02') + form.getValue('WAGES_AMT_03') + form.getValue('WAGES_AMT_04') + form.getValue('WAGES_AMT_05') + 
							                form.getValue('WAGES_AMT_06') + form.getValue('WAGES_AMT_07') + form.getValue('WAGES_AMT_08') + form.getValue('WAGES_AMT_09') + form.getValue('WAGES_AMT_10') +
							                form.getValue('WAGES_AMT_11') + form.getValue('WAGES_AMT_12') + form.getValue('WAGES_AMT_13')
							                form.setValue('WAGES_AMT_14',amt03);
                                    
                                    }
                                }
                            },{
                                fieldLabel: '가족수당',
                                name:'WAGES_AMT_05'  ,  
                                xtype:'uniNumberfield', 
                                allowBlank:true,
                                value:0,
                                readOnly:true,
                                colspan: 2,
                                listeners   : {
                                blur: function(field, event, eOpts ) {      
                                    		panelDetail.down('#salaryInfo').unmask();
							                var form = panelDetail.down('#salaryForm');
							                var amt02 = 0;
							                amt02 = form.getValue('WAGES_AMT_01') + form.getValue('WAGES_AMT_02') + form.getValue('WAGES_AMT_03') + form.getValue('WAGES_AMT_04') + form.getValue('WAGES_AMT_05') + 
							                form.getValue('WAGES_AMT_06') + form.getValue('WAGES_AMT_07') + form.getValue('WAGES_AMT_08') + form.getValue('WAGES_AMT_09') + form.getValue('WAGES_AMT_10') +
							                form.getValue('WAGES_AMT_11') + form.getValue('WAGES_AMT_12') + form.getValue('WAGES_AMT_13')
							                form.setValue('WAGES_AMT_14',amt02);
                                    }
                                }
                            },{
                                fieldLabel: '생산장려',
                                name:'WAGES_AMT_06', 
                                xtype:'uniNumberfield', 
                                allowBlank:true,
                                value:0, 
                                readOnly:true,
                                listeners   : {
                                blur: function(field, event, eOpts ) {      
                                    panelDetail.down('#salaryInfo').unmask();
                                    var form = panelDetail.down('#salaryForm');
                                    var payGrad01 = form.getValue('PAY_GRADE_01');
                                    var amt02 = 0;
                                    var amt03 = 0;
                                    var num = 1.0;
                                    var wagesAmt01 = form.getValue('WAGES_AMT_01') * num.toFixed(1);
                                    var wagesAmt06 = form.getValue('WAGES_AMT_06') * num.toFixed(1);
                                    var wagesAmt03 = form.getValue('WAGES_AMT_03') * num.toFixed(1);
                                    var wagesAmt07 = form.getValue('WAGES_AMT_07') * num.toFixed(1);
                                    var wagesAmt13 = form.getValue('WAGES_AMT_13') * num.toFixed(1);
                                    
                                   // if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
                                        amt02 = (((Math.round(wagesAmt01.toFixed(1) / 209)) + (Math.round(wagesAmt06.toFixed(1) / 209)) + (Math.round(wagesAmt03.toFixed(1) / 209)) + (Math.round(wagesAmt07.toFixed(1) / 209)) + (Math.round(wagesAmt13.toFixed(1) / 209))) * 22) * 1.5
                                    
                                        form.setValue('WAGES_AMT_02', amt02.toFixed(1)); 
                                       // }
                                    amt03 = form.getValue('WAGES_AMT_01') + form.getValue('WAGES_AMT_02') + form.getValue('WAGES_AMT_03') + form.getValue('WAGES_AMT_04') + form.getValue('WAGES_AMT_05') + 
							                form.getValue('WAGES_AMT_06') + form.getValue('WAGES_AMT_07') + form.getValue('WAGES_AMT_08') + form.getValue('WAGES_AMT_09') + form.getValue('WAGES_AMT_10') +
							                form.getValue('WAGES_AMT_11') + form.getValue('WAGES_AMT_12') + form.getValue('WAGES_AMT_13')
							                form.setValue('WAGES_AMT_14',amt03);
                                    }
                                }
                            },{
                                fieldLabel: '반장수당',
                                name:'WAGES_AMT_07' ,  
                                xtype:'uniNumberfield', 
                                allowBlank:true,
                                value:0,
                                readOnly:true,
                                colspan: 3, 
                                listeners   : {
                                blur: function(field, event, eOpts ) {      
                                    panelDetail.down('#salaryInfo').unmask();
                                    var form = panelDetail.down('#salaryForm');
                                    var payGrad01 = form.getValue('PAY_GRADE_01');
                                    var amt02 = 0;
                                    var amt03 = 0;
                                    var num = 1.0;
                                    var wagesAmt01 = form.getValue('WAGES_AMT_01') * num.toFixed(1);
                                    var wagesAmt06 = form.getValue('WAGES_AMT_06') * num.toFixed(1);
                                    var wagesAmt03 = form.getValue('WAGES_AMT_03') * num.toFixed(1);
                                    var wagesAmt07 = form.getValue('WAGES_AMT_07') * num.toFixed(1);
                                    var wagesAmt13 = form.getValue('WAGES_AMT_13') * num.toFixed(1);
                                    
                                    //if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
                                        amt02 = (((Math.round(wagesAmt01.toFixed(1) / 209)) + (Math.round(wagesAmt06.toFixed(1) / 209)) + (Math.round(wagesAmt03.toFixed(1) / 209)) + (Math.round(wagesAmt07.toFixed(1) / 209)) + (Math.round(wagesAmt13.toFixed(1) / 209))) * 22) * 1.5
                                    
                                        form.setValue('WAGES_AMT_02', amt02.toFixed(1)); 
                                      //  }
                                    amt03 = form.getValue('WAGES_AMT_01') + form.getValue('WAGES_AMT_02') + form.getValue('WAGES_AMT_03') + form.getValue('WAGES_AMT_04') + form.getValue('WAGES_AMT_05') + 
							                form.getValue('WAGES_AMT_06') + form.getValue('WAGES_AMT_07') + form.getValue('WAGES_AMT_08') + form.getValue('WAGES_AMT_09') + form.getValue('WAGES_AMT_10') +
							                form.getValue('WAGES_AMT_11') + form.getValue('WAGES_AMT_12') + form.getValue('WAGES_AMT_13')
							                form.setValue('WAGES_AMT_14',amt03);
                                    }
                                }
                            },{
                                fieldLabel: '연구수당',
                                name:'WAGES_AMT_08'  ,  
                                xtype:'uniNumberfield', 
                                allowBlank:true,
                                value:0,
                                colspan: 2,
                                readOnly:true,
                                listeners   : {
                                blur: function(field, event, eOpts ) {      
                                    		panelDetail.down('#salaryInfo').unmask();
							                var form = panelDetail.down('#salaryForm');
							                var amt02 = 0;
							                amt02 = form.getValue('WAGES_AMT_01') + form.getValue('WAGES_AMT_02') + form.getValue('WAGES_AMT_03') + form.getValue('WAGES_AMT_04') + form.getValue('WAGES_AMT_05') + 
							                form.getValue('WAGES_AMT_06') + form.getValue('WAGES_AMT_07') + form.getValue('WAGES_AMT_08') + form.getValue('WAGES_AMT_09') + form.getValue('WAGES_AMT_10') +
							                form.getValue('WAGES_AMT_11') + form.getValue('WAGES_AMT_12') + form.getValue('WAGES_AMT_13')
							                form.setValue('WAGES_AMT_14',amt02);
                                    }
                                }
                            },{
                                fieldLabel: '기타수당1',
                                name:'WAGES_AMT_09', 
                                xtype:'uniNumberfield', 
                                allowBlank:true,
                                value:0,
                                readOnly:true,
                                listeners   : {
                                blur: function(field, event, eOpts ) {      
                                    		panelDetail.down('#salaryInfo').unmask();
							                var form = panelDetail.down('#salaryForm');
							                var amt02 = 0;
							                amt02 = form.getValue('WAGES_AMT_01') + form.getValue('WAGES_AMT_02') + form.getValue('WAGES_AMT_03') + form.getValue('WAGES_AMT_04') + form.getValue('WAGES_AMT_05') + 
							                form.getValue('WAGES_AMT_06') + form.getValue('WAGES_AMT_07') + form.getValue('WAGES_AMT_08') + form.getValue('WAGES_AMT_09') + form.getValue('WAGES_AMT_10') +
							                form.getValue('WAGES_AMT_11') + form.getValue('WAGES_AMT_12') + form.getValue('WAGES_AMT_13')
							                form.setValue('WAGES_AMT_14',amt02);
                                    }
                                }
                            },{
                                fieldLabel: '기타수당2',
                                name:'WAGES_AMT_10' ,  
                                xtype:'uniNumberfield', 
                                allowBlank:true,
                                value:0,
                                readOnly:true,
                                colspan: 3,
                                listeners   : {
                                blur: function(field, event, eOpts ) {      
                                    		panelDetail.down('#salaryInfo').unmask();
							                var form = panelDetail.down('#salaryForm');
							                var amt02 = 0;
							                amt02 = form.getValue('WAGES_AMT_01') + form.getValue('WAGES_AMT_02') + form.getValue('WAGES_AMT_03') + form.getValue('WAGES_AMT_04') + form.getValue('WAGES_AMT_05') + 
							                form.getValue('WAGES_AMT_06') + form.getValue('WAGES_AMT_07') + form.getValue('WAGES_AMT_08') + form.getValue('WAGES_AMT_09') + form.getValue('WAGES_AMT_10') +
							                form.getValue('WAGES_AMT_11') + form.getValue('WAGES_AMT_12') + form.getValue('WAGES_AMT_13')
							                form.setValue('WAGES_AMT_14',amt02);
                                    }
                                }
                            },{
                                fieldLabel: '운전수당',
                                name:'WAGES_AMT_11'  ,  
                                xtype:'uniNumberfield', 
                                allowBlank:true,
                                value:0,
                                readOnly:true,
                                colspan: 2,
                                listeners   : {
                                blur: function(field, event, eOpts ) {      
                                    		panelDetail.down('#salaryInfo').unmask();
							                var form = panelDetail.down('#salaryForm');
							                var amt02 = 0;
							                amt02 = form.getValue('WAGES_AMT_01') + form.getValue('WAGES_AMT_02') + form.getValue('WAGES_AMT_03') + form.getValue('WAGES_AMT_04') + form.getValue('WAGES_AMT_05') + 
							                form.getValue('WAGES_AMT_06') + form.getValue('WAGES_AMT_07') + form.getValue('WAGES_AMT_08') + form.getValue('WAGES_AMT_09') + form.getValue('WAGES_AMT_10') +
							                form.getValue('WAGES_AMT_11') + form.getValue('WAGES_AMT_12') + form.getValue('WAGES_AMT_13')
							                form.setValue('WAGES_AMT_14',amt02);
                                    }
                                }
                            },{
                                fieldLabel: '연수수당',
                                name:'WAGES_AMT_12', 
                                xtype:'uniNumberfield', 
                                allowBlank:true,
                                value:0,
                                readOnly:true,
                                listeners   : {
                                blur: function(field, event, eOpts ) {      
                                    		panelDetail.down('#salaryInfo').unmask();
							                var form = panelDetail.down('#salaryForm');
							                var amt02 = 0;
							                amt02 = form.getValue('WAGES_AMT_01') + form.getValue('WAGES_AMT_02') + form.getValue('WAGES_AMT_03') + form.getValue('WAGES_AMT_04') + form.getValue('WAGES_AMT_05') + 
							                form.getValue('WAGES_AMT_06') + form.getValue('WAGES_AMT_07') + form.getValue('WAGES_AMT_08') + form.getValue('WAGES_AMT_09') + form.getValue('WAGES_AMT_10') +
							                form.getValue('WAGES_AMT_11') + form.getValue('WAGES_AMT_12') + form.getValue('WAGES_AMT_13')
							                form.setValue('WAGES_AMT_14',amt02);
                                    }
                                }
                            },{
                                fieldLabel: '조정수당',
                                name:'WAGES_AMT_13' ,  
                                xtype:'uniNumberfield', 
                                allowBlank:true,
                                value:0,
                                readOnly:true,
                                colspan: 3,
                                listeners   : {
                                blur: function(field, event, eOpts ) {      
                                    		panelDetail.down('#salaryInfo').unmask();
                                            var form = panelDetail.down('#salaryForm');
                                            var payGrad01 = form.getValue('PAY_GRADE_01');
                                            var amt02 = 0;
                                            var amt03 = 0;
                                            var num = 1.0;
                                            var wagesAmt01 = form.getValue('WAGES_AMT_01') * num.toFixed(1);
                                            var wagesAmt06 = form.getValue('WAGES_AMT_06') * num.toFixed(1); // 생산
                                            var wagesAmt03 = form.getValue('WAGES_AMT_03') * num.toFixed(1); // 직책
                                            var wagesAmt07 = form.getValue('WAGES_AMT_07') * num.toFixed(1); // 반장
                                            var wagesAmt13 = form.getValue('WAGES_AMT_13') * num.toFixed(1); // 조정
                                            
                                            //if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
                                                amt02 = (((Math.round(wagesAmt01.toFixed(1) / 209)) + (Math.round(wagesAmt06.toFixed(1) / 209)) + (Math.round(wagesAmt03.toFixed(1) / 209)) + (Math.round(wagesAmt07.toFixed(1) / 209)) + (Math.round(wagesAmt13.toFixed(1) / 209))) * 22) * 1.5
                                            
                                                form.setValue('WAGES_AMT_02', amt02.toFixed(1)); 
                                              //  }
                                            amt03 = form.getValue('WAGES_AMT_01') + form.getValue('WAGES_AMT_02') + form.getValue('WAGES_AMT_03') + form.getValue('WAGES_AMT_04') + form.getValue('WAGES_AMT_05') + 
                                                    form.getValue('WAGES_AMT_06') + form.getValue('WAGES_AMT_07') + form.getValue('WAGES_AMT_08') + form.getValue('WAGES_AMT_09') + form.getValue('WAGES_AMT_10') +
                                                    form.getValue('WAGES_AMT_11') + form.getValue('WAGES_AMT_12') + form.getValue('WAGES_AMT_13')
                                                    form.setValue('WAGES_AMT_14',amt03);
                                    }
                                }
                            },{
                                fieldLabel: '급여총합계',  
                                xtype:'uniNumberfield',
                                name:'WAGES_AMT_14' ,  
                                allowBlank:true,
                                value:0 ,
                                colspan: 2,
                                readOnly: true
                                                              
                            },{
                                fieldLabel: '신규여부',
                                name:'MEMO_2',
                                readOnly: true,
                                hidden: true
                                                              
                            }
                            

							/*,{
		            	  	 	fieldLabel: '국민연금',
							 	name:'ANU_INSUR_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:false,
							 	hideLabel:true,
							 	margin:'0 0 0 2'
							},{
		            	  	 	fieldLabel: '고용보험료',
							 	name:'HIRE_INSUR_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:false,
							 	hideLabel:true,
							 	margin:'0 0 0 2'
							},{
		            	  	 	fieldLabel: '건강보험료',
							 	name:'MED_INSUR_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:false,
							 	hideLabel:true,
							 	margin:'0 0 0 2'
							},{
		            	  	 	fieldLabel: '월차지급방식',
							 	name:'MONTH_GIVE' , 
							 	allowBlank:false,
							 	hidden:true,
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H049'
							},{
		            	  	 	fieldLabel: '보전수당',
							 	name:'PAY_PRESERVE_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:false
							},{
		            	  	 	fieldLabel: '',
							 	name:'COM_DAY_WAGES' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:false,
							 	hidden:true
							},{
		            	  	 	fieldLabel: '잔업구분',
							 	name:'OT_KIND'  ,
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H036'
							},{
		            	  	 	fieldLabel: '',
							 	name:'BANK_CODE2'   
							},{
		            	  	 	fieldLabel: '',
							 	name:'BANK_ACCOUNT2'   
							},{
		            	  	 	fieldLabel: '',
							 	name:'PAY_GUBUN2' , 
							 	allowBlank:false
							}*/
						
						],
						listeners:{
							uniOnChange:function( form, dirty, eOpts ) {
								console.log("onDirtyChange");
								if(form.isDirty()  && !form.uniOpt.inLoading)	{
									UniAppManager.setToolbarButtons('save', true);
								}else {
									UniAppManager.setToolbarButtons('save', false);
								}
							}
						}
        			}
				],
			loadData:function(personNum)	{
				var salaryForm = this.down('#salaryForm');
				salaryForm.uniOpt.inLoading = true; 
				salaryForm.clearForm();
				salaryForm.mask();
				salaryForm.getForm().load(
					{
						params : {'PERSON_NUMB':personNum},
						success: function(form, action)	{
								salaryForm.uniOpt.inLoading = false; 
								salaryForm.unmask();
								
								var bNew = (salaryForm.getValue('MEMO_2') == 'NEW' ? true : false);
								fnSetWagesReadOnly(bNew);
								
								//panelDetail.down('#salaryInfo').unmask();
							                //var form = panelDetail.down('#salaryForm');
							               /* var amt02 = 0;
							                amt02 = salaryForm.getValue('WAGES_AMT_01') + salaryForm.getValue('WAGES_AMT_02') + salaryForm.getValue('WAGES_AMT_03') + salaryForm.getValue('WAGES_AMT_04') + salaryForm.getValue('WAGES_AMT_05') + 
							                salaryForm.getValue('WAGES_AMT_06') + salaryForm.getValue('WAGES_AMT_07') + salaryForm.getValue('WAGES_AMT_08') + salaryForm.getValue('WAGES_AMT_09') + salaryForm.getValue('WAGES_AMT_10') +
							                salaryForm.getValue('WAGES_AMT_11') + salaryForm.getValue('WAGES_AMT_12') + salaryForm.getValue('WAGES_AMT_13')
							                salaryForm.setValue('WAGES_AMT_14',amt02);*/
						},
						failure: function(form, action)	{
								salaryForm.uniOpt.inLoading = false; 
								salaryForm.unmask();
								
								fnSetWagesReadOnly(false);
						}
					}
				);
			}
    	};

function fnSetWagesReadOnly(bReadOnly) {
	if(bReadOnly) {
		var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
		var salaryForm = activeTab.down('#salaryForm');
		
		salaryForm.getField('WAGES_AMT_01').setReadOnly(false);
		salaryForm.getField('WAGES_AMT_02').setReadOnly(false);
		salaryForm.getField('WAGES_AMT_03').setReadOnly(false);
		salaryForm.getField('WAGES_AMT_04').setReadOnly(false);
		salaryForm.getField('WAGES_AMT_05').setReadOnly(false);
		salaryForm.getField('WAGES_AMT_06').setReadOnly(false);
		salaryForm.getField('WAGES_AMT_07').setReadOnly(false);
		salaryForm.getField('WAGES_AMT_08').setReadOnly(false);
		salaryForm.getField('WAGES_AMT_09').setReadOnly(false);
		salaryForm.getField('WAGES_AMT_10').setReadOnly(false);
		salaryForm.getField('WAGES_AMT_11').setReadOnly(false);
		salaryForm.getField('WAGES_AMT_12').setReadOnly(false);
		salaryForm.getField('WAGES_AMT_13').setReadOnly(false);
	}
	else {
		var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
		var salaryForm = activeTab.down('#salaryForm');
		
		salaryForm.getField('WAGES_AMT_01').setReadOnly(true);
		salaryForm.getField('WAGES_AMT_02').setReadOnly(true);
		salaryForm.getField('WAGES_AMT_03').setReadOnly(true);
		salaryForm.getField('WAGES_AMT_04').setReadOnly(true);
		salaryForm.getField('WAGES_AMT_05').setReadOnly(true);
		salaryForm.getField('WAGES_AMT_06').setReadOnly(true);
		salaryForm.getField('WAGES_AMT_07').setReadOnly(true);
		salaryForm.getField('WAGES_AMT_08').setReadOnly(true);
		salaryForm.getField('WAGES_AMT_09').setReadOnly(true);
		salaryForm.getField('WAGES_AMT_10').setReadOnly(true);
		salaryForm.getField('WAGES_AMT_11').setReadOnly(true);
		salaryForm.getField('WAGES_AMT_12').setReadOnly(true);
		salaryForm.getField('WAGES_AMT_13').setReadOnly(true);
	}
};

 function wageCodePopup()	{ 
 		var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
		var returnForm = activeTab.down('#salaryForm');
	    if(!payGrdWin) {
	    		var winfields = [
	    		     {name: 'PAY_GRADE_YYYY'    ,text:'년도'              ,type:'string'	}
	    			,{name: 'PAY_GRADE_01' 		,text:'급'               ,type:'string'	}
	    			,{name: 'PAY_GRADE_01_NAME' ,text:'급'               ,type:'string'  }
					,{name: 'PAY_GRADE_02' 		,text:'호'               ,type:'string'	}
				];
		    	Ext.each(wageStd, function(stdCode, idx) {
		    		winfields.push({name: 'CODE'+stdCode.WAGES_CODE 	,text:stdCode.WAGES_NAME+'코드' 			,type:'string'	});
		    		winfields.push({name: 'STD'+stdCode.WAGES_CODE 		,text:stdCode.WAGES_NAME 				,type:'uniPrice'});		    		
		    	})
	    		Unilite.defineModel('WagesCodeModel', {
				    fields: winfields
				});
				
				var wagesCodeDirctProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
					api: {
						read : 'hum105ukrService.fnHum100P2'
					}
				});
				
	    		var wageCodeStore = Unilite.createStore('wageCodeStore', {
						model: 'WagesCodeModel' ,
						proxy: wagesCodeDirctProxy,            
			            loadStoreRecords : function()	{
							var param= payGrdWin.down('#search').getValues();
							
							this.load({
								params: param
							});				
						}
				});
	    
				var wageColumns = [
				    { dataIndex: 'PAY_GRADE_YYYY' 			,width: 60 , align:'center'}
				   ,{ dataIndex: 'PAY_GRADE_01' 			,width: 40  } 
	               ,{ dataIndex: 'PAY_GRADE_01_NAME'        ,width: 80  }
	               ,{ dataIndex: 'PAY_GRADE_02' 			,width: 40  }  
	            ];
	            Ext.each(wageStd, function(stdCode, idx) {
		    		wageColumns.push({dataIndex: 'CODE'+stdCode.WAGES_CODE 		,width: 50 	, hidden:true});
		    		wageColumns.push({dataIndex: 'STD'+stdCode.WAGES_CODE 		,width: 100  });		    		
		    	});  		
				payGrdWin = Ext.create('widget.uniDetailWindow', {
	                title: '급호봉조회POPUP',
	                width: 600,				                
	                height:400,
				    
	                layout: {type:'vbox', align:'stretch'},	                
	                items: [{
		                	itemId:'search',
		                	xtype:'uniSearchForm',
		                	layout:{type:'uniTable',columns:3},
		                	items:[{	
	                			fieldLabel:'년도',
	                			xtype:'uniYearField',
	                			labelWidth:60,
	                			name :'PAY_GRADE_YYYY',
	                			width:160
	                			
	                		},{	
	                			fieldLabel:'급',
	                			labelWidth:60,
	                			name :'PAY_GRADE_01',
	                			width:160
	                		},{
	                			
	                			fieldLabel:'호',
	                			labelWidth:60,
	                			name :'PAY_GRADE_02',
	                			width:160
	                		},{
	                			
	                			fieldLabel:'구분',
	                			labelWidth:60,
	                			name :'GRADE_FLAG',
	                			width:160,
	                			hidden: true
	                		}]
	               		},
						Unilite.createGrid('', {
							itemId:'grid',
					        layout : 'fit',
					    	store: wageCodeStore,
					    	selModel:'rowmodel',
							uniOpt:{
					        	expandLastColumn: false,
			        			useRowNumberer: false,
			                    onLoadSelectFirst: true,
			                    userToolbar :false
					        },
					        columns: wageColumns
					         ,listeners: {	
					          		onGridDblClick:function(grid, record, cellIndex, colName) {
					  					grid.ownerGrid.returnData();
					  					payGrdWin.hide();
					  				}
					       		}
					       	,returnData: function()	{
					       		var record = this.getSelectedRecord();  
					       		var form = panelDetail.down('#salaryForm');
					       		var postCd = form.getValue('POST_CODE');
					       	    var payGrad01 = '';
					       	    var amt00 = 0.0;
					       	    var amt01 = 0;             //기본급
					       	    var amt02 = 0;             //시간외수당
					       	    var amt04 = 0;             //기술수당
					       	    var amt06 = 0;             //생산장려
					       	    var amt07 = 0;             //반장수당
					       	    
					       	    
					       	    var samt01 = 0;
					       	    var samt02 = 0;
					       	    var samt03 = 0;
					       	    var samt04 = 0;
					       	    var samt05 = 0;
					       	    var samt06 = 0;
					       	    var samt07 = 0;
					       	    var samt08 = 0;
					       	    var samt09 = 0;
					       	    var samt10 = 0;
					       	    var samt11 = 0;
					       	    var samt12 = 0;
					       	    var samt13 = 0;
					       	    var samt14 = 0;
					       	    
					       	    
					       	    //var form = panelDetail.down('#salaryForm');
					       	    
					       		if (grade_flag == '03') {
					       			payGrdWin.returnForm.setValue('PAY_GRADE_03', record.get("PAY_GRADE_02"))
					       			payGrdWin.returnForm.setValue('WAGES_AMT_03', record.get("STD110"))
					       			payGrdWin.returnForm.setValue('WAGES_AMT_06', 80000)
					       			if (postCd == '57'){
					       				payGrdWin.returnForm.setValue('WAGES_AMT_07', 50000)
					       			}
					       			
					       			payGrdWin.returnForm.setValue('WAGES_AMT_13', record.get("STD270"))

					       		} else if (grade_flag == '04') {
					       			payGrdWin.returnForm.setValue('PAY_GRADE_04', record.get("PAY_GRADE_02"))
					       			payGrdWin.returnForm.setValue('WAGES_AMT_04', record.get("STD120"))
					       			payGrdWin.returnForm.setValue('WAGES_AMT_06', 80000)
					       			if (postCd == '57'){
                                        payGrdWin.returnForm.setValue('WAGES_AMT_07', 50000)
                                    }
                                    
                                    payGrdWin.returnForm.setValue('WAGES_AMT_13', record.get("STD270"))
					       			
					       		} else if (grade_flag == '05') {
                                    payGrdWin.returnForm.setValue('PAY_GRADE_05', record.get("PAY_GRADE_02"))
                                    payGrdWin.returnForm.setValue('WAGES_AMT_13', record.get("STD110"))
                                    /*payGrdWin.returnForm.setValue('WAGES_AMT_06', 80000)
                                    if (postCd == '57'){
                                        payGrdWin.returnForm.setValue('WAGES_AMT_13', 50000)
                                    }*/
                                    
                                    payGrdWin.returnForm.setValue('WAGES_AMT_13', record.get("STD270"))
                                    
                                } else {
					       			payGrdWin.returnForm.setValue('PAY_GRADE_01'     , record.get("PAY_GRADE_01"))
					       			payGrdWin.returnForm.setValue('PAY_GRADE_01_NAME', record.get("PAY_GRADE_01_NAME"))
					       			payGrdWin.returnForm.setValue('PAY_GRADE_02'     , record.get("PAY_GRADE_02"))
					       			payGrdWin.returnForm.setValue('WAGES_STD_I'      , record.get("STD100"))
					       			
					       			payGrdWin.returnForm.setValue('WAGES_AMT_01', record.get("STD100"))
					       			payGrdWin.returnForm.setValue('WAGES_AMT_02', record.get("STD300"))
					       			payGrdWin.returnForm.setValue('WAGES_AMT_06', 80000)
					       			if (postCd == '57'){
                                        payGrdWin.returnForm.setValue('WAGES_AMT_07', 50000)
                                    } 
                                    
                                    payGrdWin.returnForm.setValue('WAGES_AMT_13', record.get("STD270"))
//                                    payGrad01 = record.get("PAY_GRADE_01");
//                                    
//                                    if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
//                                        var num = 1.0;
//                                    	amt01 = form.getValue('WAGES_AMT_01') * num.toFixed(1);
//                                    	amt01 = Math.round(amt01.toFixed(1) * 209)    //기본급
//                                    	                                    	
////                                    	amt00 = amt01 * 0.1 //마지막 자리 숫자 사사오입을 위해 소수점만듬
////                                    	
////                                    	amt00 = Math.round(amt00)
////                                    	
////                                    	amt01 = amt00 * 10
//                                    	                                    	
//                                    	amt04 = form.getValue('WAGES_AMT_04') * num.toFixed(1);
//                                    	amt06 = form.getValue('WAGES_AMT_06') * num.toFixed(1);
//                                    	amt07 = form.getValue('WAGES_AMT_07') * num.toFixed(1);
//                                    	
//                                    	amt02 = Math.round((((amt01 + amt04.toFixed(1) + amt06.toFixed(1) + amt07.toFixed(1)) / 209) * 22) * 1.5);
//                                    
//                                        //alert(amt02);
//                                    	
//                                    	payGrdWin.returnForm.setValue('WAGES_AMT_01'      , amt01)
//                                    	payGrdWin.returnForm.setValue('WAGES_AMT_02'      , amt02)
                                    	

                                        
//                                    }

                                        
                                    
                                        var form = panelDetail.down('#salaryForm');
                                        var payGrad01 = form.getValue('PAY_GRADE_01');
                                        var amt02 = 0;
                                        var num = 1.0;
                                        var num2 = 0.1;
                                        var amt01 = form.getValue('WAGES_AMT_01') * num2.toFixed(1);
                                        amt01 = Math.round(amt01.toFixed(1) * 209) * 10;    //기본급  
                                        var wagesStdI = form.getValue('WAGES_STD_I') * num.toFixed(1);
                                        var wagesAmt06 = form.getValue('WAGES_AMT_06') * num.toFixed(1);
                                        var wagesAmt03 = form.getValue('WAGES_AMT_03') * num.toFixed(1);
                                        var wagesAmt07 = form.getValue('WAGES_AMT_07') * num.toFixed(1);
                                        var wagesAmt13 = form.getValue('WAGES_AMT_13') * num.toFixed(1);
                                        
                                        if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
                                            amt02 = ((wagesStdI + (Math.round(wagesAmt06.toFixed(1) / 209)) + (Math.round(wagesAmt03.toFixed(1) / 209)) + (Math.round(wagesAmt07.toFixed(1) / 209))+ (Math.round(wagesAmt13.toFixed(1) / 209))) * 22) * 1.5
                                            payGrdWin.returnForm.setValue('WAGES_AMT_01'      , amt01)
                                            payGrdWin.returnForm.setValue('WAGES_AMT_02'      , amt02.toFixed(1)); 
                                            
                                        
                                        }
                                    
					       		}
					       		
					       		
					       		samt01 = form.getValue('WAGES_AMT_01');
					       		samt02 = form.getValue('WAGES_AMT_02');
					       		samt03 = form.getValue('WAGES_AMT_03');
					       		samt04 = form.getValue('WAGES_AMT_04');
					       		samt05 = form.getValue('WAGES_AMT_05');
					       		samt06 = form.getValue('WAGES_AMT_06');
					       		samt07 = form.getValue('WAGES_AMT_07');
					       		samt08 = form.getValue('WAGES_AMT_08');
					       		samt09 = form.getValue('WAGES_AMT_09');
					       		samt10 = form.getValue('WAGES_AMT_10');
					       		samt11 = form.getValue('WAGES_AMT_11');
					       		samt12 = form.getValue('WAGES_AMT_12');
					       		samt13 = form.getValue('WAGES_AMT_13');
					       		
					       		samt14 = samt01 + samt02 + samt03 + samt04 + samt05 + samt06
					       		      + samt07 + samt08 + samt09 + samt10 + samt11 + samt12 + samt13;
					       		      
					       		      /*alert(amt01);
					       		      alert(amt02);
					       		      alert(amt03);
					       		      alert(amt04);
					       		      alert(amt05);
					       		      alert(amt06);
					       		      alert(amt07);
					       		      alert(amt08);
					       		      alert(amt09);
					       		      alert(amt10);
					       		      alert(amt11);
					       		      alert(amt12);
					       		      alert(amt13);
					       		      alert(amt14);
					       		     alert(samt14); */
					       		      //form.setvalue('WAGES_AMT_13', amt14 );
					       		      payGrdWin.returnForm.setValue('WAGES_AMT_14', samt14)
					       		      
					       		
					       		
					       		
					       		
					       		
					       	}
					       	
						})
					       
					],
	                tbar:  ['->',
	               		 {
							itemId : 'searchtBtn',
							text: '조회',
							handler: function() {
								var form = payGrdWin.down('#search');
								var store = Ext.data.StoreManager.lookup('creditStore')
								wageCodeStore.loadStoreRecords();
							},
							disabled: false
						},
				         {
							itemId : 'submitBtn',
							text: '확인',
							handler: function() {
								payGrdWin.down('#grid').returnData()
								payGrdWin.hide();
							},
							disabled: false
						},{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								payGrdWin.hide();
							},
							disabled: false
						}
				    ],
					listeners : {
						beforehide: function(me, eOpt)	{
							payGrdWin.down('#search').clearForm();
							payGrdWin.down('#grid').reset();
            			},
            			 beforeclose: function( panel, eOpts )	{
							payGrdWin.down('#search').clearForm();
							payGrdWin.down('#grid').reset();
            			},
            			 show: function( panel, eOpts )	{
							var form = payGrdWin.down('#search');
							form.clearForm();
							form.setValue('GRADE_FLAG', grade_flag);
							form.setValue('PAY_GRADE_YYYY',new Date().getFullYear());
							Ext.data.StoreManager.lookup('wageCodeStore').loadStoreRecords();
            			}
	                }		
				});
	    }	
	
	    payGrdWin.returnForm	 	= returnForm;
		payGrdWin.center();		
		payGrdWin.show();
		return payGrdWin;
	}   	