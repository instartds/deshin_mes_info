<%@page language="java" contentType="text/html; charset=utf-8"%>
var personalInfo =	 {		         
	        title: '인사기본정보',	
	        itemId: 'personalInfo',
			layout:{type:'vbox', align:'stretch'},
			autoScroll:true,	
			xtype:'uniDetailForm',			
			api: {
			         load: ham100ukrService.select,
			         submit: hum100ukrService.saveHum100
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
			        		 	layout: {type: 'uniTable',  columns:2},
			        		 	width: 510,
			        		 	bodyCls: 'human-panel-form-background',
			        	 		defaults: {
				        					width:260,
				        					labelWidth:140
				        		},
			        		 	items:[ 
			        		 			{
			                    	  	 	fieldLabel: '사번'    ,
										 	name:'PERSON_NUMB' , 
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
			                    	  	 	fieldLabel: '사업장',
										 	name:'DIV_CODE' , 
										 	allowBlank:false,
										 	xtype: 'uniCombobox',
										 	listConfig:{minWidth:120}, 
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
										 	listConfig:{minWidth:120}, 
										 	comboType: 'AU', 
										 	comboCode: 'H005'
										},{
			                    	  	 	fieldLabel: '한자성명',
										 	name:'NAME_CHI',
											width:230,
				        					labelWidth:110   
										},{
			                    	  	 	fieldLabel: '직책',
										 	name:'ABIL_CODE',
										 	xtype: 'uniCombobox',
										 	listConfig:{minWidth:120}, 
										 	comboType: 'AU', 
										 	comboCode: 'H006'   
										},
										
										Unilite.popup('ZIP',{
										
										fieldLabel: '주소',
			        					labelWidth:110,
			        					colspan:2,
										showValue:false,
										textFieldWidth:115,	
										textFieldName:'ZIP_CODE',
										DBtextFieldName:'ZIP_CODE',
										validateBlank:false,
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
										})
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
										}*/,{
			                    	  	 	fieldLabel: '상세주소',
										 	name:'KOR_ADDR',
										 	hideLabel:true,
										 	width:377,
										 	colspan:2,
										 	margin:'0 0 0 115'
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
						 	listConfig:{minWidth:120}, 
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
						 	listConfig:{minWidth:120}, 
							comboType: 'BOR120'
						},{ 
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
                                
                                var params = {'REPRE_NUM':formPanel.getValue('REPRE_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'Y'};
                                Unilite.popupCipherComm('form', formPanel, 'REPRE_NUM_EXPOS', 'REPRE_NUM', params);
                            }
                        },{
                            fieldLabel: '주민등록번호',
                            name: 'REPRE_NUM',
                            xtype: 'uniTextfield',
                            hidden: true
                        },{
	            	  	 	fieldLabel: '성별',
						 	name: 'SEX_CODE' , 
						 	xtype: 'uniRadiogroup',
						 	listConfig:{minWidth:120}, 
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
//						 	readOnly:true,
						 	xtype: 'uniCombobox',
						 	listConfig:{minWidth:120},
						 	comboType: 'AU', 
						 	comboCode: 'H011'
						},{
	            	  	 	fieldLabel: '고용형태',
						 	name: 'PAY_GUBUN2' , 
						 	xtype: 'uniRadiogroup',
						 	listConfig:{minWidth:120}, 
						 	allowBlank: false,
						 	hideLabel: true,
						 	width: 120,
						 	margin: '0 0 0 5',
							items: [
			 					{boxLabel:'일용', name:'PAY_GUBUN2', inputValue:'1', checked:true},
			 					{boxLabel:'일반', name:'PAY_GUBUN2', inputValue:'2'}
			  				]										 	
						},{
	            	  	 	fieldLabel: '퇴사일',
						 	name:'RETR_DATE' , 
						 	xtype:'uniDatefield'
					/*	 	listeners:{
                                change:function(field, newValue, oldValue, eOpts )  {
                                    var formPanel = this.up('#personalInfo');
                                    
                                    formPanel.setValue('RETR_RESN','');
                                }
                            }*/
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
						 	listConfig:{minWidth:120}, 
						 	comboType: 'AU', 
						 	comboCode: 'H024'
						},{
	            	  	 	fieldLabel: '퇴사사유',
						 	name:'RETR_RESN',
						 	xtype: 'uniCombobox',
						 	listConfig:{minWidth:120}, 
						 	comboType: 'AU', 
						 	comboCode: 'H023' 
					/*	 	listeners:{
						 		change:function(field, newValue, oldValue, eOpts )	{
						 			var formPanel = this.up('#personalInfo');
                                    
                                    if(!Ext.isEmpty(newValue)){
                                        if(Ext.isEmpty(formPanel.getValue('RETR_DATE')))    {
                                            alert('퇴사일을 입력하세요.');
                                            
                                            formPanel.setValue('RETR_RESN','');
                                            formPanel.getField('RETR_DATE').focus();
                                        }
                                    }
						 		}
						 	}*/
						},{
	            	  	 	fieldLabel: '입사방식',
						 	name:'JOIN_CODE' ,
						 	xtype: 'uniCombobox',
						 	listConfig:{minWidth:120}, 
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
						 	listConfig:{minWidth:120}, 
						 	comboType: 'AU', 
						 	comboCode: 'B012', 
						 	allowBlank:false
						},{
	            	  	 	fieldLabel: '담당업무',
						 	name:'JOB_CODE',
						 	xtype: 'uniCombobox',
						 	listConfig:{minWidth:120}, 
						 	comboType: 'AU', 
						 	comboCode: 'H008'   
						},{
                            fieldLabel: '직종',
                            name:'KNOC',
                            xtype: 'uniCombobox',
                            listConfig:{minWidth:120}, 
                            comboType: 'AU', 
                            comboCode: 'H072',
                            allowBlank:false
                        },{
                            fieldLabel: '실제근무기간',
                            name: 'REAL_WORK_PROD',
                            xtype: 'uniTextfield',
                            readOnly:true                            
                        },{
                            fieldLabel: '업무속성',
                            name:'BZNS_ATRB',
                            xtype: 'uniCombobox',
                            listConfig:{minWidth:120}, 
                            comboType: 'AU', 
                            comboCode: 'H204'
                        },{
                            fieldLabel: '인적속성',
                            name:'HUMN_ATRB',
                            xtype: 'uniCombobox',
                            listConfig:{minWidth:120}, 
                            comboType: 'AU', 
                            comboCode: 'H205'
                        }
						]
	    			}
		],
		listeners:{
			uniOnChange:function( form, dirty, eOpts ) {
				if(form.isDirty() && !form.uniOpt.inLoading)	{
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
			me.mask();
			me.getForm().load({
				params : {'PERSON_NUMB':personNum},
				success: function(form, action)	{
					me.unmask();
					me.uniOpt.inLoading = false; 
					UniAppManager.setToolbarButtons('delete', true);
				}
			});
		}		        	
	};