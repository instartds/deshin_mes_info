<%@page language="java" contentType="text/html; charset=utf-8"%>
var surety = {
		title:'보증인',
		itemId: 'surety',
        layout:{type:'vbox', align:'stretch'},	
        
        items:[ basicInfo,
        		{
	    			xtype: 'uniDetailForm',
	    			itemId: 'suretyForm',
	    			bodyCls: 'human-panel-form-background',
	    			disabled: false,
	    			api: {
			         		 load: hum100ukrService.surety,
			         		 submit: hum100ukrService.saveHum800
					},
	    			layout: {type:'uniTable', columns:'3'},
	    			margin:'0 10 0 10', 
	        		padding:'0',
	        		defaults: {
	        					width:260,
	        					labelWidth:140
	        		},
	        		flex:1,
	    			items: [{
			        	  	 	
							 	name:'PERSON_NUMB' ,
							 	hidden: true
							},{
								xtype:'component',
								html:'<center>[보증보험]</center>'
							},{
								xtype:'component',
								html:'&nbsp;',
								colspan: 2
							},{
			        	  	 	fieldLabel: '보험명',
							 	name:'INSURANCE_NAME'
							},{
			        	  	 	fieldLabel: '보험번호',
							 	name:'INSURANCE_NO' 
							},{
								xtype:'component',
								html:'&nbsp;'
							},{
			        	  	 	fieldLabel: '보험사명',
							 	name:'INSURANCE_COMPANY'
							},{
			        	  	 	fieldLabel: '보험료',
							 	name:'INSURANCE_FARE',  
							 	xtype:'uniNumberfield',
							 	suffixTpl:'원' 
							},{
			        	  	 	fieldLabel: '보증기간',
							 	xtype: 'uniDateRangefield',
					            startFieldName: 'GUARANTEE_PERIOD_FR',
					            endFieldName: 'GUARANTEE_PERIOD_TO',
					            tdAttrs:{width: 370},
					            width: 370 
							},{
								xtype:'component',
								html:'&nbsp;',
								colspan: 3
							},{
								xtype:'component',
								html:'<center>[추천인1]</center>'
							},{
								xtype:'component',
								html:'&nbsp;',
								colspan: 2
							},{
			        	  	 	fieldLabel: '성명',
							 	name:'GUARANTOR1_NAME'  
							},{
			        	  	 	fieldLabel: '관계',
							 	name:'GUARANTOR1_RELATION',
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H020'   
							},{
			        	  	 	fieldLabel: '주민번호',
							 	name:'GUARANTOR1_RES_NO',
							 	listeners:{
							 		blur: function(field, event, eOpt){		
							 			var v = field.getValue();		
							 			if(!Ext.isEmpty(v))	{
								 			if(Unilite.validate('residentno', v) !== true)  {
								 				if(!confirm('잘못된 주민번호를 입력하셨습니다. 잘못된 주민번호를 저장하시겠습니까? 주민번호:'+v))	{
								 					field.setValue('');
								 					return;
								 				}
								 			}
							 			}
							 		}
							 	}
							},{
			        	  	 	fieldLabel: '근무지',
							 	name:'GUARANTOR1_WORK_ZONE'
							},{
			        	  	 	fieldLabel: '직위',
							 	name:'GUARANTOR1_CLASS'
							},{
			        	  	 	fieldLabel: '세금',
							 	name:'GUARANTOR1_INCOMETAX',
							 	xtype:'uniNumberfield',
							 	suffixTpl:'원'
							},
							Unilite.popup('ZIP',{
								fieldLabel: '주소',
								showValue:false,
								textFieldWidth:115,	
								textFieldName:'GUARANTOR1_ZIP_CODE',
								DBtextFieldName:'ZIP_CODE',
								validateBlank:false,
								listeners: { 
									'onSelected': {
					                    fn: function(records, type  ){
					                    	panelDetail.down('#suretyForm').setValue('GUARANTOR1_ADDR', records[0]['ZIP_NAME']);
					                    	panelDetail.down('#suretyForm').setValue('GUARANTOR1_ADDR_DE', records[0]['ADDR2']);
					                    },
					                    scope: this
					                  },
					                  'onClear' : function(type)	{
					                    	panelDetail.down('#suretyForm').setValue('GUARANTOR1_ADDR', '');
					                    	panelDetail.down('#suretyForm').setValue('GUARANTOR1_ADDR_DE', '');
					                  }
									}
							}),{ 
								xtype: 'container',
								defaultType:'uniTextfield',
								hideLabel:true,
								layout: {type:'hbox', align:'stretch'},
								width:260,
								items: [
									{
					        	  	 	fieldLabel: '주소',
									 	name:'GUARANTOR1_ADDR',
										hideLabel:true,
										width: 130
										//margin:'0 0 0 145'
									},{
					        	  	 	fieldLabel: '주소',
									 	name:'GUARANTOR1_ADDR_DE',
										hideLabel:true,
										width: 130
										//margin:'0 0 0 145',
										
									}
								]
							},{
			        	  	 	fieldLabel: '보증기간',
							 	xtype: 'uniDateRangefield',
					            startFieldName: 'GUARANTOR1_PERIOD_FR',
					            endFieldName: 'GUARANTOR1_PERIOD_TO',
					            tdAttrs:{width: 370},
					            width: 370
							},{
								xtype:'component',
								html:'&nbsp;',
								colspan: 3
							},{
								xtype:'component',
								html:'<center>[추천인2]</center>'
							},{
								xtype:'component',
								html:'&nbsp;',
								colspan: 2
							},{
			        	  	 	fieldLabel: '성명',
							 	name:'GUARANTOR2_NAME' 
							},{
			        	  	 	fieldLabel: '관계',
							 	name:'GUARANTOR2_RELATION',
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H020'   
							},{
			        	  	 	fieldLabel: '주민번호',
							 	name:'GUARANTOR2_RES_NO',
							 	listeners:{
							 		blur: function(field, event, eOpt){		
							 			var v = field.getValue();	
							 			if(!Ext.isEmpty(v))	{
								 			if(Unilite.validate('residentno', v) !== true)  {
								 				if(!confirm('잘못된 주민번호를 입력하셨습니다. 잘못된 주민번호를 저장하시겠습니까? 주민번호:'+v))	{
								 					field.setValue('');
								 					return;
								 				}
								 			}
							 			}
							 		}
							 	}
							},{
			        	  	 	fieldLabel: '근무지',
							 	name:'GUARANTOR2_WORK_ZONE'
							},{
			        	  	 	fieldLabel: '직위',
							 	name:'GUARANTOR2_CLASS'
							},{
			        	  	 	fieldLabel: '세금',
							 	name:'GUARANTOR2_INCOMETAX',
							 	xtype:'uniNumberfield',
							 	suffixTpl:'원'
							},
							Unilite.popup('ZIP',{
								fieldLabel: '주소',
								showValue:false,
								textFieldWidth:115,	
								textFieldName:'GUARANTOR2_ZIP_CODE',
								DBtextFieldName:'ZIP_CODE',
								validateBlank:false,
								listeners: { 
									'onSelected': {
						                    fn: function(records, type  ){
						                    	panelDetail.down('#suretyForm').setValue('GUARANTOR2_ADDR', records[0]['ZIP_NAME']);
						                    	panelDetail.down('#suretyForm').setValue('GUARANTOR2_ADDR_DE', records[0]['ADDR2']);
						                    },
						                    scope: this
						                  },
						                  'onClear' : function(type)	{
						                    	panelDetail.down('#suretyForm').setValue('GUARANTOR2_ADDR', '');
						                    	panelDetail.down('#suretyForm').setValue('GUARANTOR2_ADDR_DE', '');
						                  }
									}
							}),{ 
								xtype: 'container',
								defaultType:'uniTextfield',
								hideLabel:true,
								layout: {type:'hbox', align:'stretch'},
								width:260,
								items: [
									{
					        	  	 	fieldLabel: '주소',
									 	name:'GUARANTOR2_ADDR',
										hideLabel:true,
										width:130
										//margin:'0 0 0 145'
									},{
					        	  	 	fieldLabel: '주소',
									 	name:'GUARANTOR2_ADDR_DE',
										hideLabel:true,
										width:130
										//margin:'0 0 0 145',
										
									}
								]
							},{
			        	  	 	fieldLabel: '보증기간',
							 	xtype: 'uniDateRangefield',
					            startFieldName: 'GUARANTOR2_PERIOD_FR',
					            endFieldName: 'GUARANTOR2_PERIOD_TO',
					            tdAttrs:{width: 370},
					            width: 370
							}							
			        	],
					listeners:{
						uniOnChange:function( form, dirty, eOpts ) {
							console.log("onDirtyChange");
							UniAppManager.app.setToolbarButtons('save', true);
						}
					}
        		}]
        		,loadData:function(personNum)	{
        			var suretyForm = this.down('#suretyForm');
					suretyForm.clearForm();
					suretyForm.uniOpt.inLoading = true; 
					suretyForm.getForm().load(
						{
							params : {'PERSON_NUMB':personNum},
							success: function(form, action)	{
								 	suretyForm.uniOpt.inLoading = false; 
								 },
							failure:function(form, action)	{
								 	suretyForm.uniOpt.inLoading = false; 
								 }
						}
					);
				}
		};