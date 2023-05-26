<%@page language="java" contentType="text/html; charset=utf-8"%>
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
				         		 load: ham100ukrService.select,
				         		 submit: hum100ukrService.saveHum100
						},
						bodyCls: 'human-panel-form-background',
            			layout:{type:'uniTable', columns:'5'},
            			defaultType: 'uniTextfield',
    					defaults: {
    							width:260,
	        					labelWidth:140
	        					},
	        			margin:'0 10 0 10',
	        			padding:'0',
    					flex: 1,
            			items: [
            				{
			        	  	 	
							 	name:'PERSON_NUMB' ,
							 	hidden: true
							},{	
		            	  	 	fieldLabel: '연봉',
							 	name:'ANNUAL_SALARY_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:false,   
							 	colspan: 2
							},{
		            	  	 	fieldLabel: '년월차기준금',
							 	name:'COM_YEAR_WAGES' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:false,   
							 	colspan: 2
							},{
		            	  	 	fieldLabel: '명세서이메일전송',
							 	name:'EMAIL_SEND_YN', 
							 	allowBlank:false,
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'EMAIL_SEND_YN', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다'	, name:'EMAIL_SEND_YN', inputValue:'N'}
				  				]
							},{
		            	  	 	fieldLabel: '급',
							 	name:'PAY_GRADE_01',
							 	width:170
							},{
		            	  	 	fieldLabel: '호',
							 	name:'PAY_GRADE_02',
							 	width:90,
							 	labelWidth:20
							},{
		            	  	 	fieldLabel: '상여구분자',
							 	name:'BONUS_KIND',
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H037'  ,   
							 	colspan: 2
							},{
		            	  	 	fieldLabel: '급여지급',
							 	name:'PAY_PROV_YN' , 
							 	allowBlank:false,
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'PAY_PROV_YN', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다'	, name:'PAY_PROV_YN', inputValue:'N'}
				  				]
							},{
		            	  	 	fieldLabel: 'E-Mail 주소',
							 	name:'EMAIL_ADDR'  ,   
							 	colspan: 2
							},{
		            	  	 	fieldLabel: '회계부서',
							 	name:'COST_KIND'   ,  
                                xtype: 'uniCombobox',
                                store : Ext.StoreManager.lookup('costPoolCombo'),
							 	colspan: 2
							},{
		            	  	 	fieldLabel: '급여지급보류',
							 	name:'PAY_PROV_STOP_YN', 
							 	allowBlank:false,
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'PAY_PROV_STOP_YN', inputValue:'Y'},
				 					{boxLabel:'안한다'	, name:'PAY_PROV_STOP_YN', inputValue:'N', checked:true}
				  				]
							 	
							},{
		            	  	 	fieldLabel: '지급차수',
							 	name:'PAY_PROV_FLAG' , 
							 	allowBlank:false,
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H031',   
							 	colspan: 2
							},{
		            	  	 	fieldLabel: '건강보험증번호',
							 	name:'MED_INSUR_NO' ,   
							 	colspan: 2
							},{
		            	  	 	fieldLabel: '세액계산',
							 	name:'COMP_TAX_I' , 
							 	allowBlank:false,
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'COMP_TAX_I', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다'	, name:'COMP_TAX_I', inputValue:'N'}
				  				]
							},{
		            	  	 	fieldLabel: '급여지급방식',
							 	name:'PAY_CODE' , 
							 	allowBlank:false,
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H028',   
							 	colspan: 2
							},{
		            	  	 	fieldLabel: '월평균보수액(건강)',
							 	name:'MED_AVG_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:false, 
							 	width: 210,
							 	listeners: {
							 		blur: function(field, event, eOpt)	{
							 			panelDetail.down('#salaryInfo').mask();
							 			hum100ukrService.getMonthInsurI(
							 				{
							 					'MONTH_AVG_I':field.getValue(), 
							 					'TYPE' : '2'
							 				}, 
							 				function(provider, response)	{
							 					panelDetail.down('#salaryInfo').unmask();
							 					panelDetail.down('#salaryForm').setValue('MED_INSUR_I', provider['INSUR_I']);							 				
							 				}
							 			);
							 		}
							 	}
							},{
		            	  	 	fieldLabel: '건강보험금액',
							 	name:'MED_INSUR_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:false, 
							 	width: 50,
							 	hideLabel: true
							 },{
		            	  	 	fieldLabel: '고용보험계산',
							 	name:'HIRE_INSUR_TYPE' , 
							 	allowBlank:false,
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'HIRE_INSUR_TYPE', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다'	, name:'HIRE_INSUR_TYPE', inputValue:'N'}
				  				]
							},{
		            	  	 	fieldLabel: '연장수당세액',
							 	name:'TAX_CODE' , 
							 	allowBlank:false,
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H029',   
							 	colspan: 2
							},{
		            	  	 	fieldLabel: '월평균보수액(고용)',
							 	name:'HIRE_AVG_I' ,
							 	xtype:'uniNumberfield', 
							 	width: 210,
							 	allowBlank:false,
							 	listeners: {
							 		blur: function(field, event, eOpt)	{
							 			panelDetail.down('#salaryInfo').mask();
							 			hum100ukrService.getHireInsurI(
							 				{
							 					'HIRE_AVG_I':field.getValue(), 
							 					'TYPE' : '3'
							 				}, 
							 				function(provider, response)	{
							 					panelDetail.down('#salaryInfo').unmask();
							 					panelDetail.down('#salaryForm').setValue('HIRE_INSUR_I', provider['HIRE_INSUR_I']);							 				
							 				}
							 			);
							 		}
							 	}
							},{
		            	  	 	fieldLabel: '고용보험금액',
							 	name:'HIRE_INSUR_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:false, 
							 	width: 50,
							 	hideLabel: true
							},{
		            	  	 	fieldLabel: '퇴직금지급',
							 	name:'RETR_GIVE' , 
							 	allowBlank:false,
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'RETR_GIVE', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다'	, name:'RETR_GIVE', inputValue:'N'}
				  				]
							},{
		            	  	 	fieldLabel: '보육수당세액',
							 	name:'TAX_CODE2' ,
							 	xtype:'uniNumberfield',
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H029' ,   
							 	colspan: 2    
							},{
		            	  	 	fieldLabel: '월평균보수액(연금)',
							 	name:'ANU_BASE_I' ,
							 	xtype:'uniNumberfield', 
							 	width: 210,
							 	allowBlank:false,
							 	listeners: {
							 		blur: function(field, event, eOpt)	{
							 			panelDetail.down('#salaryInfo').mask();
							 			hum100ukrService.getMonthInsurI(
							 				{
							 					'MONTH_AVG_I':field.getValue(), 
							 					'TYPE' : '1'
							 				}, 
							 				function(provider, response)	{
							 					panelDetail.down('#salaryInfo').unmask();
							 					panelDetail.down('#salaryForm').setValue('ANU_INSUR_I', provider['INSUR_I']);							 				
							 				}
							 			);
							 		}
							 	}
							},{
		            	  	 	fieldLabel: '국민연금금액',
							 	name:'ANU_INSUR_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:false, 
							 	width: 50,
							 	hideLabel: true
							},{
		            	  	 	fieldLabel: '노조가입',
							 	name:'LABOR_UNON_YN' ,
							 	xtype: 'uniRadiogroup',
							 	allowBlank:false,
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
							 	colspan: 2
							},
							Unilite.popup('BANK',{
		            	  	 	fieldLabel: '급여이체은행',
							 	valueFieldName:'BANK_CODE1'   ,  
							 	valueFieldWidth:40,
							 	textFieldWidth:75,
							 	colspan: 2
							})
							,{
		            	  	 	fieldLabel: '년차수당지급',
							 	name:'YEAR_GIVE' , 
							 	allowBlank:false,
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'YEAR_GIVE', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다'	, name:'YEAR_GIVE', inputValue:'N'}
				  				]
							},{
		            	  	 	fieldLabel: '계좌번호',
							 	name:'BANK_ACCOUNT1',   
							 	colspan: 2
							},{
		            	  	 	fieldLabel: '연말정산신고',
							 	name:'YEAR_CALCU'  ,
							 	xtype: 'uniRadiogroup',
							 	allowBlank:false,
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다'	, name:'YEAR_CALCU', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다'	, name:'YEAR_CALCU', inputValue:'N'}
				  				]
							},{
		            	  	 	fieldLabel: '예금주',
							 	name:'BANKBOOK_NAME'   ,   
							 	colspan: 2
							}/*,{
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
								if(form.isDirty() && !form.uniOpt.inLoading)	{
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
				salaryForm.clearForm();
				salaryForm.mask();
				salaryForm.uniOpt.inLoading = true; 
				salaryForm.getForm().load({
						params : {'PERSON_NUMB':personNum},
						success: function(form, action)	{
							 	salaryForm.uniOpt.inLoading = false; 
							 	salaryForm.unmask();
						},
						failure: function(form, action)	{
							 	salaryForm.uniOpt.inLoading = false; 
						}
					}
				);
			}
    	};