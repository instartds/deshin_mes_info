<%@page language="java" contentType="text/html; charset=utf-8"%>
var payGrdWin;
var wageStd = ${wageStd};
 
 var salaryInfo =	{
			title:'기타정보',
			itemId: 'salaryInfo',
			layout:{type:'vbox', align:'stretch'},			
        	items:[
        			basicInfo
        			,{
            			xtype: 'uniDetailForm',
	        			itemId: 'salaryForm',
	        			disabled: false,
			            api: {
				         		 load: s_hum100ukrService_KOCIS.select,
				         		 submit: s_hum100ukrService_KOCIS.saveHum100
						},
						bodyCls: 'human-panel-form-background',
            			layout:{type:'uniTable', columns:'3'},
            			defaultType: 'uniTextfield',
    					defaults: {
    							width:250,
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
		            	  	 	fieldLabel: '연봉',
							 	name:'ANNUAL_SALARY_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:true,
							 	value:0,
							 	listeners:{
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue(0);
							 			}
							 		}
							 	}
							},{
		            	  	 	fieldLabel: '부임여비',
							 	name:'WAGES_STD_I' ,
                                xtype:'uniNumberfield', 
                                decimalPrecision: 2,
							 	allowBlank:true,
							 	value:0,
							 	listeners:{
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue(0);
							 			}
							 		}
							 	}
							}/*,{
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
							}*/,{
		            	  	 	fieldLabel: '퇴임여비',
							 	name:'PAY_PRESERVE_I' ,
							 	xtype:'uniNumberfield', 
                                decimalPrecision: 2,
							 	allowBlank:true,
							 	value:0,
							 	listeners:{
							 		change:function(field, newValue, oldValue)	{
							 			if(Ext.isEmpty(newValue))	{
							 				field.setValue(0);
							 			}
							 		}
							 	}
							}/*,{
		            	  	 	fieldLabel: '월평균보수액(건강)',
							 	name:'MED_AVG_I' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:true,
							 	value:0,
							 	width: 210,
							 	listeners: {
							 		blur: function(field, event, eOpt)	{
							 			panelDetail.down('#salaryInfo').mask();
							 			s_hum100ukrService_KOCIS.getMonthInsurI(
							 				{
							 					'MONTH_AVG_I':field.getValue(), 
							 					'TYPE' : '2'
							 				}, 
							 				function(provider, response)	{
							 					panelDetail.down('#salaryInfo').unmask();
							 					var form = panelDetail.down('#salaryForm');
							 					var oldValue = form.getValue('MED_INSUR_I');
							 					if(oldValue !=  provider['INSUR_I'])	{
							 						form.setValue('MED_INSUR_I', provider['INSUR_I']);		
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
							}*/,{
		            	  	 	fieldLabel: '지급차수',
							 	name:'PAY_PROV_FLAG' , 
							 	allowBlank:false,
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H031'
							}/*,{
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
							}*/,{
		            	  	 	fieldLabel: '급여지급방식',
							 	name:'PAY_CODE' , 
							 	allowBlank:false,
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H028'
							},{
                                fieldLabel: 'E-Mail 주소',
                                name:'EMAIL_ADDR',   
                                colspan: 2
                            },{
                                fieldLabel: '급여이체은행',
                                name:'BANK_CODE1', 
                                allowBlank:false,
                                xtype: 'uniCombobox',
                                comboType: 'AU', 
                                comboCode: 'H099'
                            },{
		            	  	 	fieldLabel: '계좌번호',
							 	name:'BANK_ACCOUNT1'
							},{
		            	  	 	fieldLabel: '예금주',
							 	name:'BANKBOOK_NAME'
							}
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
    	
 function wageCodePopup()	{ 
 		var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
		var returnForm = activeTab.down('#salaryForm');
	    if(!payGrdWin) {
	    		var winfields = [
	    			 {name: 'PAY_GRADE_01' 		,text:'급' 					,type:'string'	}
					,{name: 'PAY_GRADE_02' 		,text:'호' 					,type:'string'	}
				];
		    	Ext.each(wageStd, function(stdCode, idx) {
		    		winfields.push({name: 'CODE'+stdCode.WAGES_CODE 	,text:stdCode.WAGES_NAME+'코드' 			,type:'string'	});
		    		winfields.push({name: 'STD'+stdCode.WAGES_CODE 		,text:stdCode.WAGES_NAME 					,type:'uniPrice'});		    		
		    	})
	    		Unilite.defineModel('WagesCodeModel', {
				    fields: winfields
				});
				
				var wagesCodeDirctProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
					api: {
						read : 's_hum100ukrService_KOCIS.fnHum100P2'
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
					{ dataIndex: 'PAY_GRADE_01' 			,width: 40  } 
	            	,{ dataIndex: 'PAY_GRADE_02' 			,width: 40  }  
	            ];
	            Ext.each(wageStd, function(stdCode, idx) {
		    		wageColumns.push({dataIndex: 'CODE'+stdCode.WAGES_CODE 		,width: 50 	, hidden:true});
		    		wageColumns.push({dataIndex: 'STD'+stdCode.WAGES_CODE 		,width: 100  });		    		
		    	});  		
				payGrdWin = Ext.create('widget.uniDetailWindow', {
	                title: '급호봉조회POPUP',
	                width: 400,				                
	                height:400,
				    
	                layout: {type:'vbox', align:'stretch'},	                
	                items: [{
		                	itemId:'search',
		                	xtype:'uniSearchForm',
		                	layout:{type:'uniTable',columns:2},
		                	items:[
		                		{	
		                			fieldLabel:'급',
		                			labelWidth:60,
		                			name :'PAY_GRADE_01',
		                			width:160
		                		},{
		                			
		                			fieldLabel:'호',
		                			labelWidth:60,
		                			name :'PAY_GRADE_02',
		                			width:160
		                		}
		                		
		                	]
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
					       		payGrdWin.returnForm.setValue('PAY_GRADE_01', record.get("PAY_GRADE_01"))
					       		payGrdWin.returnForm.setValue('PAY_GRADE_02', record.get("PAY_GRADE_02"))
					       		payGrdWin.returnForm.setValue('WAGES_STD_I', record.get("STD100"))
					       	}
					       	
						})
					       
					],
	                tbar:  [
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
				         '->',{
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
					listeners : {beforehide: function(me, eOpt)	{
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