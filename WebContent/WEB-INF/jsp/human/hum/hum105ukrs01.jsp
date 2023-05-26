<%@page language="java" contentType="text/html; charset=utf-8"%>
var personalInfo =	 {		         
	        title: '인사기본정보',	
	        itemId: 'personalInfo',
			layout:{type:'vbox', align:'stretch'},
			autoScroll:true,	
			xtype:'uniDetailForm',			
			api: {
			         load: hum105ukrService.select,
			         submit: hum105ukrService.saveHum100
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
											allowBlank: '${autoNum}',
//											allowBlank: ${autoNum},
											//readOnly: '${autoNum}',
//											readOnly: ${autoNum},
			                    	  	 	fieldLabel: '사번'    ,
										 	name:'PERSON_NUMB' ,
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
			                    	  	 	fieldLabel: '사업장',
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
				        					listeners:{
				        						blur: function(field, event, eOpts )	{
				        							if(UniAppManager.app._needSave()){
				        								this.up('#personalInfo').down('#empName').update(field.getValue());	
				        							}
				        						}
				        					}
										},
										Unilite.popup('DEPT',{
			                    	  	 	fieldLabel: '부서',
										 	showValue:false,
										 	allowBlank:false,
										 	textFieldWidth:115
										})
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
										 	,
                                          listeners: {
                                                change: function(field, newValue, oldValue, eOpts) {
//                                                  alert(newValue);
//                                                    personalInfo.setValue('ABIL_CODE', newValue);
                                                    panelDetail.down('#personalInfo').setValue('ABIL_CODE', newValue);
                                                }
                                            }
										},{
			                    	  	 	fieldLabel: '한자성명',
										 	name:'NAME_CHI',
											width:230,
				        					labelWidth:110   
										},{
			                    	  	 	fieldLabel: '직책',
										 	name:'ABIL_CODE',
										 	xtype: 'uniCombobox',
										 	comboType: 'AU', 
										 	comboCode: 'H005'   
										},{
					            	  	 	fieldLabel: '발령일자',
										 	name:'ANNOUNCE_DATE',
										 	xtype:'uniDatefield',
										 	allowBlank:false,
										 	width:230,
				        					labelWidth:110,
				        					listeners: {
                                                change: function(field, newValue, oldValue, eOpts) {
													var form = panelDetail.down('#personalInfo');
													if(!form.uniOpt.inLoading )	{
                                                    	form.setValue('ORI_JOIN_DATE', newValue);
                                                    	form.setValue('JOIN_DATE', newValue);
                                                    }
                                                }
                                            }
										 	
										},{
			                    	  	 	fieldLabel: '발령코드',
										 	name:'ANNOUNCE_CODE',
										 	xtype: 'uniCombobox',
										 	allowBlank:false,
										 	comboType: 'AU', 
										 	comboCode: 'H094'   
										}
//										,Unilite.popup('ZIP',{
//										fieldLabel: '주소',
//			        					labelWidth:110,
//										showValue:false,
//										textFieldWidth:115,	
//										textFieldName:'ZIP_CODE',
//										DBtextFieldName:'ZIP_CODE',
//										validateBlank:false,
//										popupHeight:580,
//										listeners: { 'onSelected': {
//									                    fn: function(records, type  ){
//									                    	panelDetail.down('#personalInfo').setValue('KOR_ADDR', records[0]['ZIP_NAME']+records[0]['ADDR2']);
//									                    },
//									                    scope: this
//									                  },
//									                  'onClear' : function(type)	{
//									                    	panelDetail.down('#personalInfo').setValue('KOR_ADDR', '');
//									                  }
//											}
//										})
//                                      ,{
//			                    	  	 	fieldLabel: '직렬',
//										 	name:'AFFIL_CODE',
//										 	xtype: 'uniCombobox',
//										 	comboType: 'AU', 
//										 	comboCode: 'H173',
//										 	hidden: true
//										}
										/*{
											fieldLabel: '주소',
											width:230,
				        					labelWidth:110,
				        					colspan:2,
											xtype: 'triggerfield',
												
								            triggerCls :'x-form-search-trigger',								           
								            padding: 0, 
								            margin: 0,
								            name : 'ZIP_CODE',
								            enableKeyEvents: true,
								            listeners: {
								            	'render' : function(c) {
								            		 c.getEl().on('dblclick', function(){
													    	this.openPopup();
													  });
								            	},
								                'keydown': {
								                  	fn: function(elm, evt){
								                  		//console.log("KEYS:", evt.getKey());
								                  		switch( evt.getKey() ) {
								                  			case Ext.EventObject.F8:
								                            case Ext.EventObject.ENTER:
								                  			 	elm.openPopup( 'TEXT');
								                    			break;
								                  		}
								                  	} // fn
								                  	,scope: this
								                }                  
								            },	
								            onTriggerClick: function() {
										        this.openPopup();
										    },
											onSelected: function(records, type  ){
										    	panelDetail.down('#personalInfo').setValue('KOR_ADDR', records[0]['ZIP_NAME']+records[0]['ADDR2']);
										               
										    },										                  
										    onClear : function(type)	{
										    	panelDetail.down('#personalInfo').setValue('KOR_ADDR', '');
										    },
										    openPopup:function()	{
										    	var me = this;
										        var param = {};
										        
										        param[me.getName()] = me.getValue().trim();				  
										        param['TYPE'] = 'TEXT';   
										        param['pageTitle'] = '우편번호';  
									            var fn = function() {
									                var oWin =  Ext.WindowMgr.get('Unilite.app.popup.ZipPopup');
									                if(!oWin) {
									                    oWin = Ext.create( 'Unilite.app.popup.ZipPopup', {									                            
									                            //callBackFn: me.processResult, 
									                            callBackScope: me, 
									                            popupType: 'TEXT',
									                            width: 500,
									                            height: 500,
									                            title:'우편번호',
									                            param: param
									                     });
									                }
									                oWin.fnInitBinding(param);
									                oWin.center();
									                oWin.show();
									            };
									            Unilite.require('Unilite.app.popup.ZipPopup', fn, this, true);
										    }
										}*/
//										,{
//			                    	  	 	fieldLabel: '상세주소',
//										 	name:'KOR_ADDR',
//										 	hideLabel:true,
//										 	width:377,
//										 	colspan:2,
//										 	margin:'0 0 0 115'
//										}
										 
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
							items: [
			 					{boxLabel:'양', name:'SOLAR_YN', inputValue:'Y', checked:true},
			 					{boxLabel:'음', name:'SOLAR_YN', inputValue:'N'}
			  				]
						},{
	            	  	 	fieldLabel: '신고사업장',
						 	name:'SECT_CODE' , 
						 	allowBlank:false,
						 	xtype: 'uniCombobox',
							comboType: 'BOR120'
						},{
	            	  	 	fieldLabel: '주민번호',
						 	name:'REPRE_NUM',
						 	allowBlank:false,
						 	listeners:{
						 		change:function(field, newValue, oldValue)	{
						 			if(newValue.length > 6)	{
						 				newValue = newValue.replace('-','');
										field.setValue(newValue.substring(0,6)+'-'+newValue.substring(6,newValue.length))
						 			}
						 		},
						 		blur: function(field, event, eOpt){
						 			if(UniAppManager.app._needSave()){
							 			var f='2468';
							 			var m='1357';
							 			var formPanel = this.up('#personalInfo');
							 			var v = field.getValue();
							 			var param={'REPRE_NUM' : v};
							 			if(Unilite.validate('residentno', v) == true) {
							 				v = v.replace('-','');
							 				if(f.indexOf(v.substring(6,7)) > -1 )	{
							 					formPanel.setValue('SEX_CODE','F');
							 				}else if(m.indexOf(v.substring(6,7)) > -1 )	{
							 					formPanel.setValue('SEX_CODE','M');
							 				}
							 			}else {
							 				if(!confirm('잘못된 주민번호를 입력하셨습니다. 잘못된 주민번호를 저장하시겠습니까? 주민번호:'+v))	{
							 					field.setValue('');
							 					return;
							 				}
							 			}
							 			if(Ext.isEmpty(v))	{
							 				alert('주민번호를 입력하세요.')
							 				return;
							 			}
							 			if(v.length > 6)	{
							 				v = v.replace('-','');
											field.setValue(v.substring(0,6)+'-'+v.substring(6,v.length))
							 			}
//							 			hum105ukrService.chkRepreNum(param, function(response, provider) {
//							 				alert(provider.data.CNT + "a");
// 												if(provider['CNT'] != 0) {
// 													alert(provider.data.CNT);
//													if(!confirm('중복된 주민번호가 존재합니다. 계속 진행하시겠습니까? 사번:'+v))	{
//														field.setValue('');
//													}
//												}
//										});
										
						 			}						 			
						 		}
						 	}
						},{
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
						 	name:'BUSS_OFFICE_CODE' ,
						 	xtype: 'uniCombobox',
						 	store : Ext.StoreManager.lookup('BussOfficeCode')
						},{
	            	  	 	fieldLabel: '최초입사일',
						 	name:'ORI_JOIN_DATE',
						 	xtype:'uniDatefield'
						},{
	            	  	 	fieldLabel: '고용형태',
						 	name:'PAY_GUBUN' , 
						 	allowBlank:false,
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H011'
						},{
	            	  	 	fieldLabel: '퇴사일',
						 	name:'RETR_DATE' , 
						 	xtype:'uniDatefield',
						 	listeners:{
                                change:function(field, newValue, oldValue, eOpts )  {
                                    var formPanel = this.up('#personalInfo');
                                    
//                                    if(newValue == null || Ext.isEmpty(newValue))    {
//                                        alert('날짜를 입력하세요.');
////                                        field.setValue('RETR_DATE',UniDate.get('today'));
////                                        alert('11111 : ' + formPanel.getValue('RETR_RESN'));
//                                        formPanel.setValue('RETR_RESN', '');
//                                    }
                                    
                                }
                            }
						},{
	            	  	 	fieldLabel: '입사일',
						 	name:'JOIN_DATE' , 
						 	allowBlank:false,
						 	xtype:'uniDatefield'
						}
						,{
	            	  	 	fieldLabel: '사원구분',
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
//						 			alert('11111 : ' + formPanel.getValue('RETR_DATE'));
						 			
//						 			if(newValue != null && Ext.isEmpty(formPanel.getValue('RETR_DATE')))	{
//						 				alert('퇴사일을 입력하세요.1');
////						 				field.setValue('');
//						 				field.setValue(oldValue);
//						 				
////						 				field.setValue('RETR_DATE', 00000000);
////						 				formPanel.setValue('RETR_DATE', 00000000);
////						 			    field.setValue('RETR_DATE',UniDate.get('today'));
//
//						 				formPanel.getField('RETR_DATE').focus();
////						 				return;
////						 				return false;
//						 			}
						 			
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
	            	  	 	fieldLabel: '퇴직계산분류',
						 	name:'RETR_OT_KIND',
						 	colspan:3,
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H112', 
						 	allowBlank:false
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
						 	comboCode: 'H008'   
						},{
	            	  	 	fieldLabel: '퇴직중간정산',
						 	name:'RETR_LAST_DATE'   ,
						 	readOnly:true
						},{
	            	  	 	fieldLabel: '최종학력',
						 	name:'SCHSHIP_CODE',
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H009'   
						},{
	            	  	 	fieldLabel: '졸업구분',
						 	name:'GRADU_TYPE',
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H010'
						}
                        ,{
                            name:'AFFIL_CODE',
                            xtype: 'uniCombobox',
                            comboType: 'AU', 
                            comboCode: 'H173',
                            fieldLabel: '관리구분', 
                            allowBlank:false
                        },
							Unilite.popup('ZIP',{
							fieldLabel: '주소',
	    					labelWidth:140,
							showValue:false,
							textFieldWidth:115,	
							textFieldName:'ZIP_CODE',
							DBtextFieldName:'ZIP_CODE',
							validateBlank:false,
							//colspan:3,
							popupHeight:580,
							listeners: { 'onSelected': {
						                    fn: function(records, type  ){
						                    	panelDetail.down('#personalInfo').setValue('KOR_ADDR', records[0]['ZIP_NAME']+records[0]['ADDR2']);
						                    },
						                    scope: this
						                  },
						                  'onClear' : function(type)	{
						                    	panelDetail.down('#personalInfo').setValue('KOR_ADDR', '');
						                  }
								}
							}),
							 {
                    	  	 	fieldLabel: '상세주소',
							 	name:'KOR_ADDR',
							 	hideLabel:true,
							 	//labelWidth:140,
							 	width:377,
							 	colspan:2,
							 	margin:'0 0 0 5'
							 },
							Unilite.popup('ZIP',{
								fieldLabel: '본적지주소',
	        					labelWidth:140,
								showValue:false,
								textFieldWidth:115,	
								textFieldName:'ORI_ZIP_CODE',
								DBtextFieldName:'ZIP_CODE',
								validateBlank:false,
								//colspan:3,
								listeners: { 'onSelected': {
							                    fn: function(records, type  ){
							                    	panelDetail.down('#personalInfo').setValue('ORI_ADDR', records[0]['ZIP_NAME']+records[0]['ADDR2']);
							                    },
							                    scope: this
							                  },
							                  'onClear' : function(type)	{
							                    	panelDetail.down('#personalInfo').setValue('ORI_ADDR', '');
							                  }
									}
							}),
							 {
                    	  	 	fieldLabel: '기타상세주소',
							 	name:'ORI_ADDR',
							 	hideLabel:true,
							 	//labelWidth:140,
							 	width:377,
							 	colspan:2,
							 	margin:'0 0 0 5'
							 },
							 {
                    	  	 	fieldLabel: '학교명',
							 	name:'SCHOOL_NAME',
							 	width:260
							 	
							 },	
							 {
                    	  	 	fieldLabel: '전공(과)',
							 	name:'MAJOR_NAME',
							 	width:260
							 }	
						]
	    			}
		],
		listeners:{
			uniOnChange:function( form ) {
			
			
				Ext.each(form.getForm().getFields().items, function(item)	{
						if(item.dirty)	{
							console.log("basicInfo item.dirty:" , item.name, item.fieldLable);
						}
					})
				if(form.isDirty())	{
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		},
		loadData:function(personNum)	{
			var me = this;
			me.uniOpt.inLoading = true; 
			me.clearForm();
			me.getForm().load({params : {'PERSON_NUMB':personNum},
								 success: function(form, action)	{
								 	me.uniOpt.inLoading = false; 
								 	
								 	panelDetail.down('#personalInfo').getField('PERSON_NUMB').setReadOnly(true);
								 }
								}
							   );
		}		        	
	};