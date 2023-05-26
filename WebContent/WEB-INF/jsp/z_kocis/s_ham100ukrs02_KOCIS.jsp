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
				         		 load: s_ham100ukrService_KOCIS.select,
				         		 submit: s_ham100ukrService_KOCIS.saveHum100
						},
						bodyCls: 'human-panel-form-background',
            			layout:{type:'uniTable', columns:'3'},
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
							 	allowBlank:false
							},{
		            	  	 	fieldLabel: '년월차기준금',
							 	name:'COM_YEAR_WAGES' ,
							 	xtype:'uniNumberfield'//, 
//							 	allowBlank:false
							}/*,{
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
							}*/,{
		            	  	 	fieldLabel: '상여구분자',
							 	name:'BONUS_KIND',
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H037'
							}/*,{
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
							}*/,{
		            	  	 	fieldLabel: 'E-Mail 주소',
							 	name:'EMAIL_ADDR'
							},{
		            	  	 	fieldLabel: '지급차수',
							 	name:'PAY_PROV_FLAG' , 
							 	allowBlank:false,
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H031'
							},{
		            	  	 	fieldLabel: '급여지급방식',
							 	name:'PAY_CODE' , 
							 	allowBlank:false,
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H028'
							},{
                                fieldLabel: '급여이체은행',
                                name:'BANK_CODE1', 
                                allowBlank:false,
                                xtype: 'uniCombobox',
                                comboType: 'AU', 
                                comboCode: 'H099'
                            }
							/*,
							Unilite.popup('BANK',{
		            	  	 	fieldLabel: '급여이체은행',
							 	valueFieldName:'BANK_CODE1'   ,  
							 	valueFieldWidth:40,
							 	textFieldWidth:75
							})*/
							/*,{
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
							}*/,{
		            	  	 	fieldLabel: '계좌번호',
							 	name:'BANK_ACCOUNT1'
							}/*,{
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
							}*/,{
		            	  	 	fieldLabel: '예금주',
							 	name:'BANKBOOK_NAME' 
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
								console.log("onDirtyChange");
								if(form.isDirty() && !form.uniOpt.inLoading)    {
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
				salaryForm.uniOpt.inLoading = true; 
				salaryForm.getForm().load(
					{
						params : {'PERSON_NUMB':personNum},
						success: function(form, action)	{
							 	salaryForm.uniOpt.inLoading = false; 
						},
						failure: function(form, action)	{
							 	salaryForm.uniOpt.inLoading = false; 
						}
					}
				);
			}
    	};