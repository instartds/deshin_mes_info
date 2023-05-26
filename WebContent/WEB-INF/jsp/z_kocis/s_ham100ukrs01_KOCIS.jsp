<%@page language="java" contentType="text/html; charset=utf-8"%>
var personalInfo =	 {		         
	        title: '인사기본정보',	
	        itemId: 'personalInfo',
			layout:{type:'vbox', align:'stretch'},
			autoScroll:true,	
			xtype:'uniDetailForm',			
			api: {
			         load: s_ham100ukrService_KOCIS.select,
			         submit: s_ham100ukrService_KOCIS.saveHum100
				},
			defaultType:'container',
			flex:1,
			padding:0,
			bodyCls: 'human-panel-form-background',
			disabled: false,
	        items:[ {
	        			xtype: 'uniFieldset',
						itemId:'basicInfo',
						layout:{type: 'uniTable', columns:'2'},
						margin: '10 10 10 10',
						autoScroll:false,
						defaultType:'container',
						items:[ {
									width: 274,
									margin: '10 0 10 0',
									layout:{type: 'uniTable', columns:'2', tableAttrs:{class:'photo-background'}},
									cls:'photo-background',
									items: [							
											{ 
												xtype:'component',
									        	itemId:'EmpImg',
									        	width:130,							        
									        	autoEl: {
									        		tag: 'img',
									        		src: CPATH+'/resources/images/human/noPhoto.png',
									        		cls:'photo-wrap'
									        	}
						    	  			},{ xtype:'container',
						    	  				layout:{type: 'vbox', align:'stretch'},
						    	  				width:140,
						    	  				defaults:{cls:'photo-lable-group'},
						    	  				tdAttrs:{valign:'top'},
						    	  				margin:'20 5 5 5',
						    	  				items: [
						    	  						{
									    	  				xtype:'component',
												        	itemId:'empName',
												        	cls:'photo-lable-name',
												        	html:' '
									    	  			},{
									    	  				xtype:'component',
												        	itemId:'empEngName',
												        	cls:'photo-lable-engname',
												        	html:' '
									    	  			},{
									    	  				xtype:'component',
												        	itemId:'empNo',
												        	html:' '
									    	  			},{
									    	  				xtype:'component',
												        	itemId:'empTel',
												        	html:' '
									    	  			},{
									    	  				xtype:'container',
												        	items:[
												        			{
													        			xtype:'image',
															        	itemId:'photoUpload',
															     		src:CPATH+'/resources/css/icons/s01_query.png',
														        		cls:'photo-search-icon ',
														        		listeners:{
														        			click : {
														        				element:'el',
														        				fn: function( e, t, eOpts )	{
														        					openUploadWindow();
														        				}
														        			}
														        		}
												        			}
												        	]
												        
									    	  			}
								    	  		]
						    	  			}
				    	  			]
		    	  			
		    	  				}
		    	  			,{
			        		 	defaultType:'uniTextfield',
			        		 	itemId: 'basicInfoForm',
			        		 	disabled:false,
			        		 	layout: {type: 'uniTable',  columns:'2'},
			        		 	width: 510,
			        		 	bodyCls: 'human-panel-form-background',
			        	 		defaults: {
				        					width:260,
				        					labelWidth:140
				        		},
			        		 	items:[ 
			        		 			{
			                    	  	 	fieldLabel: '사번',
										 	name:'PERSON_NUMB',
											allowBlank:${autoNum},
											readOnly:${autoNum},
											width:230,
				        					labelWidth:110,
				        					listeners:{
				        						blur: function(field, event, eOpts )	{
				        							if(UniAppManager.app._needSave()){
				        								this.up('#personalInfo').down('#empNo').update(field.getValue());	
				        							}
				        						}
				        					}
										},
										{
			                    	  	 	fieldLabel: '기관',
										 	name:'DIV_CODE' , 
										 	allowBlank:false,
										 	xtype: 'uniCombobox',
										 	comboType: 'BOR120'
										},{
			                    	  	 	fieldLabel: '성명',
										 	name:'NAME' , 
										 	allowBlank:false,
											width:230,
				        					labelWidth:110,
                                            colspan:2,
				        					listeners:{
				        						blur: function(field, event, eOpts )	{
				        							if(UniAppManager.app._needSave()){
				        								this.up('#personalInfo').down('#empName').update(field.getValue());	
				        							}
				        						}
				        					}
										}/*,
										Unilite.popup('DEPT',{
			                    	  	 	fieldLabel: '부서',
										 	showValue:false,
										 	allowBlank:false,
										 	textFieldWidth:115
										})*/
										,{
			                    	  	 	fieldLabel: '영문성명',
										 	name:'NAME_ENG',
											width:230,
				        					labelWidth:110,
				        					listeners:{
				        						blur: function(field, event, eOpts )	{
				        							if(UniAppManager.app._needSave()){
				        								this.up('#personalInfo').down('#empEngName').update(field.getValue());	
				        							}
				        						}
				        					}   
										},{
			                    	  	 	fieldLabel: '직위',
										 	name:'POST_CODE' , 
										 	allowBlank:false,
										 	xtype: 'uniCombobox',
										 	comboType: 'AU', 
										 	comboCode: 'H005'
										},{
			                    	  	 	fieldLabel: '한자성명',
										 	name:'NAME_CHI',
											width:230,
				        					labelWidth:110,
				        					colspan:2
										},{
                                            fieldLabel: '주소',
                                            name:'KOR_ADDR',
                                            labelWidth:110,
//                                          hideLabel:true,
                                            width:500,
                                            colspan:2
										}

							]
							
					}
				],
				loadBasicData: function(node)	{
						if(!Ext.isEmpty(node))	{
							var data = node.getData();
							this.down('#EmpImg').getEl().dom.src=CPATH+'/uploads/employeePhoto/'+data['PERSON_NUMB'] + '?_dc=' + data['dc'];
							this.down('#empName').update(data['NAME']);
							this.down('#empEngName').update(data['NAME_ENG']);
							this.down('#empNo').update(data['PERSON_NUMB']);
							this.down('#empTel').update(data['PHONE_NO']);  
						}else {
							this.down('#EmpImg').getEl().dom.src=CPATH+'/resources/images/human/noPhoto.png';
							this.down('#empName').update('');
							this.down('#empEngName').update('');
							this.down('#empNo').update('');
							this.down('#empTel').update('');  
						}
				}
			},//fieldset end
	        {
	        		defaultType: 'uniTextfield',
	        		itemId: 'personalForm',
	        		disabled: false,
	        		bodyCls: 'human-panel-form-background',			        
	        		layout: {type:'uniTable', columns:'3'},
	        		margin:'0 10 0 10',
	        		padding:'0',
	        		defaults: {
	        					width:260,
	        					labelWidth:140
	        		},
	        		flex:1,
	        		items: [
	            		{
	            	  	 	fieldLabel: '생년월일',
						 	name:'BIRTH_DATE',
						 	xtype:'uniDatefield'
						},{
	            	  	 	fieldLabel: '양음구분',
	            	  	 	id: 'SOLAR_YN',
						 	name:'SOLAR_YN'  ,
						 	allowBlank:false,
						 	hideLabel:true,
						 	xtype: 'uniRadiogroup',
						 	width: 120,
						 	margin: '0 0 0 5',
                            colspan:2,
							items: [
			 					{boxLabel:'양', name:'SOLAR_YN', inputValue:'Y', checked:true},
			 					{boxLabel:'음', name:'SOLAR_YN', inputValue:'N'}
			  				]
						}/*,{
	            	  	 	fieldLabel: '신고사업장',
						 	name:'SECT_CODE' , 
						 	allowBlank:false,
						 	xtype: 'uniCombobox',
							comboType: 'BOR120'
						}*/
						,{
	            	  	 	fieldLabel:'주민등록번호',
                            name :'REPRE_NUM_EXPOS',
                            xtype: 'uniTextfield',
                            itemId: 'repreNumExpos',
                            value: '***************',
                            allowBlank: false,
                            readOnly:true,
                            listeners:{
                                afterrender:function(field) {
                                    field.getEl().on('dblclick', field.onDblclick);
                                }
                            },
                            onDblclick:function(event, elm) {      
                                var formPanel = panelDetail.down('#personalInfo');
                                
                                var params = {'REPRE_NO':formPanel.getValue('REPRE_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'Y'};
                                Unilite.popupCipherComm('form', formPanel, 'REPRE_NUM_EXPOS', 'REPRE_NUM', params);
                            }
                        },{
                            fieldLabel: '주민등록번호',
                            name: 'REPRE_NUM',
                            xtype: 'uniTextfield',
                            hidden: true
                        }
						,{
	            	  	 	fieldLabel: '성별',
						 	name: 'SEX_CODE' , 
						 	xtype: 'uniRadiogroup',
						 	allowBlank: false,
						 	hideLabel: true,
						 	width: 120,
						 	margin: '0 0 0 5',
							items: [
			 					{boxLabel:'남', name:'SEX_CODE', inputValue:'M', checked:true},
			 					{boxLabel:'여', name:'SEX_CODE', inputValue:'F'}
			  				]										 	
						},{
	            	  	 	fieldLabel: '소속지점',
						 	name:'BUSS_OFFICE_CODE'   
						},{
	            	  	 	fieldLabel: '고용형태',
						 	name:'PAY_GUBUN' , 
						 	allowBlank:false,
						 	readOnly:true,
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H011'
						},{
	            	  	 	fieldLabel: '고용형태',
						 	name: 'PAY_GUBUN2' , 
						 	xtype: 'uniRadiogroup',
						 	allowBlank: false,
						 	hideLabel: true,
						 	width: 120,
						 	margin: '0 0 0 5',
							items: [
			 					{boxLabel:'일용', name:'PAY_GUBUN2', inputValue:'0', checked:true},
			 					{boxLabel:'일반', name:'PAY_GUBUN2', inputValue:'1'}
			  				]										 	
						},{
	            	  	 	fieldLabel: '퇴사일',
						 	name:'RETR_DATE' , 
						 	xtype:'uniDatefield'
						},{
	            	  	 	fieldLabel: '입사일',
						 	name:'JOIN_DATE' , 
						 	allowBlank:false,
						 	xtype:'uniDatefield'
						}
						,{
	            	  	 	fieldLabel: '직원구분',
						 	name: 'EMPLOY_TYPE' , 
						 	allowBlank: false,
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H024'
						},{
	            	  	 	fieldLabel: '퇴사사유',
						 	name:'RETR_RESN',
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H023' , 
						 	listeners:{
						 		change:function(field, newValue, oldValue, eOpts )	{
						 			var formPanel = this.up('#personalInfo');
						 			if(Ext.isEmpty(formPanel.getValue('RETR_DATE')))	{
						 				alert('퇴사일을 입력하세요.');
						 				field.setValue(oldValue);
						 				formPanel.getField('RETR_DATE').focus();
						 			}
						 		}
						 	}
						},{
	            	  	 	fieldLabel: '입사방식',
						 	name:'JOIN_CODE' ,
						 	xtype: 'uniCombobox', 
						 	comboType: 'AU', 
						 	comboCode: 'H012', 
						 	allowBlank:false
						},{
	            	  	 	fieldLabel: '수습만료일',
						 	name:'TRIAL_TERM_END_DATE' ,
						 	xtype:'uniDatefield'  
						},{
	            	  	 	fieldLabel: '국적',
						 	name:'NATION_CODE' ,
						 	xtype: 'uniCombobox', 
						 	comboType: 'AU', 
						 	comboCode: 'B012', 
						 	allowBlank:false
						},{
	            	  	 	fieldLabel: '담당업무',
						 	name:'JOB_CODE',
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H008',
                            colspan:3
						},{
                            fieldLabel: '비고',
                            name:'REMARK',
                            width:780,
                            colspan:3
                        }
						]
	    			}
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
		},
		loadData:function(personNum)	{
			var me = this;
			me.clearForm();
			me.uniOpt.inLoading = true; 
			me.getForm().load({params : {'PERSON_NUMB':personNum},
								 success: function(form, action)	{
								 	me.uniOpt.inLoading = false; 
								 }
								}
							   );
		}		        	
	};