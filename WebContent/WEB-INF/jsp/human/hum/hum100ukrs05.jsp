<%@page language="java" contentType="text/html; charset=utf-8"%>
var payGrdWin;
var wageStd = ${wageStd};
var boxSize = 505;

var salaryInfo =	{
	title:'<t:message code="system.label.human.salaryinfo" default="급여정보"/>',
	itemId: 'salaryInfo',
	layout:{type:'vbox', align:'stretch'},			
	items:[{
		xtype: 'uniDetailForm',
		itemId: 'salaryForm',
		bodyCls: 'human-panel-form-background',
		disabled: false,
        api: {
            load: hum100ukrService.select,
            submit: hum100ukrService.saveHum100
		},
		flex: 1,
		items: [basicInfo,{
			xtype: 'container',
	        layout: {type: 'uniTable', columns: 5},
	        padding: '10 10 10 10',
	        items: [{
				title: '<t:message code="system.label.human.salaryinfo" default="급여정보"/>',
				xtype: 'uniFieldset',
				itemId:'salaryForm_1',
				layout:{type: 'uniTable', columns:1, tableAttrs:{cellpadding:1}, tdAttrs: {valign:'top'}},
		        padding: '10 10 10 20',
				autoScroll:false,
				defaultType:'uniTextfield',
				height:boxSize,
				items:[/*{
				 	name:'PERSON_NUMB' ,
				 	hidden: false
				},*/{
			  	 	fieldLabel: '<t:message code="system.label.human.annualsalaryi" default="연봉"/>',
				 	name:'ANNUAL_SALARY_I' ,
				 	xtype:'uniNumberfield', 
				 	value:0,
					listeners:{
				 		change:function(field, newValue, oldValue)	{
				 			if(Ext.isEmpty(newValue))	{
				 				field.setValue(0);
				 			}
				 		},
				 		blur:function(field, event, eOpts) {
				 			if(!Ext.isEmpty(field.getValue())) {
				 				var form = panelDetail.down('#salaryForm');
				 				var payCode = form.getValue('PAY_CODE');
				 				var wage = Number(field.lastValue);
				 				
				 				if(payCode == "2") {
				 					wage = wage / 365;
				 				}
				 				else if(payCode == "3") {
				 					wage = wage / 12 / 209;
				 				}
				 				else {
				 					wage = wage / 12;
				 				}
				 				
				 				form.setValue('WAGES_STD_I', wage);
				 			}
				 			else {
				 				form.setValue('WAGES_STD_I', 0);
				 			}
				 		}
				 	}
				},{
					xtype: 'container',
		            layout: {type: 'uniTable', columns: 3},
		            defaultType: 'uniTextfield',
//		            padding: '0 0 0 36',
		            items: [{
						fieldLabel: '<t:message code="system.label.human.paygrade1" default="호봉"/>',
						name:'PAY_GRADE_01',
						width:130,
//						labelWidth:105,
		                listeners:{
							render:function(el) {
								el.getEl().on('dblclick', function(){
									wageCodePopup();
								});
							}
						}
					},{
						fieldLabel: '<t:message code="system.label.human.paygrade01" default="급"/>',
						name:'PAY_GRADE_02',
						width:45,
						labelWidth:15,
		                listeners:{
		                	render:function(el) {
								el.getEl().on('dblclick', function(){
									wageCodePopup();
								});
							}
						}
					},{
						fieldLabel: '<t:message code="system.label.human.paygrade02" default="호"/>',
						name:'PAY_GRADE_BASE',
						width:60,
						labelWidth:15,
						xtype: 'uniCombobox',
						comboType: 'AU', 
						comboCode: 'H174',
		                listeners:{
		                	render:function(el) {
		                    	el.getEl().on('dblclick', function(){
		                        	wageCodePopup();
		                        });
		                    }
		                }
					}]
				},{
		            xtype       : 'container',
		            layout      : {type: 'uniTable', columns: 3},
		            defaultType : 'uniTextfield',
		            //colspan     : 3,
//		            padding     : '0 0 0 36',
		            items       : [{
		                fieldLabel:'<t:message code="system.label.human.yeargrade" default="근속"/>',
		                name:'YEAR_GRADE',
		                width:175
//		                labelWidth:105
					},{
		                fieldLabel:'<t:message code="system.label.human.year" default="년"/>',
		                name:'YEAR_GRADE_BASE',
		                width:60,
						labelWidth:15,
		                xtype: 'uniCombobox',
		                comboType: 'AU', 
		                comboCode: 'H174'  
		            }]
				},{
			  	 	fieldLabel: '<t:message code="system.label.common.wagesstdi" default="기본급"/>',
				 	name:'WAGES_STD_I' ,
				 	xtype:'uniNumberfield', 
					value:0,
					listeners:{
						change:function(field, newValue, oldValue)	{
							if(Ext.isEmpty(newValue))	{
								field.setValue(0);
				 			}
				 		}
				 	}
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.wagesstdi" default="기본급"/>2',
				 	name:'PAY_PRESERVE_I' ,
				 	xtype:'uniNumberfield', 
				 	allowBlank:true,
				 	value:0,
				 	//colspan: 3,
				 	listeners:{
				 		change:function(field, newValue, oldValue)	{
				 			if(Ext.isEmpty(newValue))	{
				 				field.setValue(0);
				 			}
				 		}
				 	}
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
				 	name:'PAY_PROV_FLAG' , 
				 	allowBlank:false,
				 	xtype: 'uniCombobox',
				 	comboType: 'AU', 
				 	comboCode: 'H031'   
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
				 	name:'PAY_CODE' , 
				 	allowBlank:false,
				 	xtype: 'uniCombobox',
				 	comboType: 'AU', 
				 	comboCode: 'H028'
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.taxcodeamt" default="연장수당세액"/>',
				 	name:'TAX_CODE' , 
				 	allowBlank:false,
				 	xtype: 'uniCombobox',
				 	comboType: 'AU', 
				 	comboCode: 'H029'
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.taxcode3" default="보육수당세액"/>',
				 	name:'TAX_CODE2' ,
				 	xtype:'uniNumberfield',
				 	xtype: 'uniCombobox',
				 	comboType: 'AU', 
				 	comboCode: 'H029' ,
				 	allowBlank:false,
				 	listeners:{
				 		change:function(field, newValue, oldValue)	{
				 			if(Ext.isEmpty(newValue))	{
				 				field.setValue(0);
				 			}
				 		}
				 	}
				},
				Unilite.popup('BANK',{
			  	 	fieldLabel: '<t:message code="system.label.human.payrolltrnasferbank" default="급여이체은행"/>',
				 	valueFieldName:'BANK_CODE1'   ,  
				 	textFieldName:'BANK_NAME1',
				 	valueFieldWidth:55,
				 	textFieldWidth:95
				}),
				{
			  	 	fieldLabel: '<t:message code="system.label.human.bankaccount" default="계좌번호"/>',
				 	name:'BANK_ACCOUNT1_EXPOS' ,
		            listeners:{
		            	blur: function(field, event, eOpts ){
							if(field.lastValue != field.originalValue){
								if(!Ext.isEmpty(field.lastValue)){
									var param = {
										"DECRYP_WORD" : field.lastValue
									};
									humanCommonService.encryptField(param, function(provider, response)  {
					                    if(!Ext.isEmpty(provider)){
				                        	panelDetail.down('#salaryForm').setValue('BANK_ACCOUNT1',provider);
					                    }else{
				                        	panelDetail.down('#salaryForm').setValue('BANK_ACCOUNT1_EXPOS',"");
				                        	panelDetail.down('#salaryForm').setValue('BANK_ACCOUNT1',"");
					                    }
				                        field.originalValue = field.lastValue; 
									});
								}else{
									panelDetail.down('#salaryForm').setValue('BANK_ACCOUNT1',"");
								}
							}
						},
		                afterrender:function(field) {
		                    field.getEl().on('dblclick', field.onDblclick);
		                }
		            },
		            onDblclick:function(event, elm) {
		            	var formPanel = panelDetail.down('#salaryForm');
						var params = {'INCRYP_WORD':formPanel.getValue('BANK_ACCOUNT1')};
	                    Unilite.popupDecryptCom(params);
		            }
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.bankaccount" default="계좌번호"/>',
				 	name:'BANK_ACCOUNT1',
				 	hidden:true
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.accountholder" default="예금주"/>',
				 	name:'BANKBOOK_NAME'
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.payspecification" default="급여명세서"/><br><t:message code="system.label.human.emailsend" default="이메일전송"/>',
				 	name:'EMAIL_SEND_YN',
				 	xtype: 'uniRadiogroup',
				 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
				 	width:235,
				 	items: [
						{boxLabel:'<t:message code="system.label.human.do" default="한다"/>'	, name:'EMAIL_SEND_YN', inputValue:'Y', checked:true},
						{boxLabel:'<t:message code="system.label.human.donot" default="안한다"/>'	, name:'EMAIL_SEND_YN', inputValue:'N'}
					]
				},{
			  	 	fieldLabel: 'E-Mail <t:message code="system.label.human.address2" default="주소"/>',
				 	name:'EMAIL_ADDR'
				}]
	        },{
	        	xtype:'component',
	        	width:10
        	},{
				title: '<t:message code="system.label.human.bonusdedinfo" default="상여/공제정보"/>',
				xtype: 'uniFieldset',
				itemId:'salaryForm_2',
				layout:{type: 'uniTable', columns:1, tableAttrs:{cellpadding:1}, tdAttrs: {valign:'top'}},
		        padding: '10 10 10 20',
				autoScroll:false,
				defaultType:'uniTextfield',
				height:boxSize,
				items:[{
			  	 	fieldLabel: '<t:message code="system.label.human.comyearwages2" default="연차기준금"/>',
				 	name:'COM_YEAR_WAGES' ,
				 	xtype:'uniNumberfield', 
				 	allowBlank:true,
				 	value:0,
		            labelWidth:140,
				 	listeners:{
				 		change:function(field, newValue, oldValue)	{
				 			if(Ext.isEmpty(newValue))	{
				 				field.setValue(0);
				 			}
				 		}
				 	}
				},{
					fieldLabel: '<t:message code="system.label.human.bonustype" default="상여구분"/>',
		            labelWidth:140,
				 	name:'BONUS_KIND',
				 	xtype: 'uniCombobox',
				 	comboType: 'AU', 
				 	comboCode: 'H037'  
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.bonusstdi" default="상여기준금"/>',
		            labelWidth:140,
				 	name:'BONUS_STD_I' ,
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
			  	 	fieldLabel: '<t:message code="system.label.human.medinsurno2" default="건강보험증번호"/>',
		            labelWidth:140,
				 	name:'MED_INSUR_NO'
				},{
		            xtype       : 'container',
		            layout      : {type: 'uniTable', columns: 2},
		            defaultType : 'uniTextfield',
//		            padding     : '0 0 0 36',
		            items       : [{
		                fieldLabel: '<t:message code="system.label.human.medavgihealth" default="보수월액(건강)"/>',
		                name:'MED_AVG_I' ,
		                xtype:'uniNumberfield', 
		                allowBlank:true,
		                value:0,
		                width: 225,
		                labelWidth:140,
		                listeners: {
		                    blur: function(field, event, eOpt)  {
		                        panelDetail.down('#salaryInfo').mask();
		                        if(field.getValue() == 0) {
		                            var form = panelDetail.down('#salaryForm');
		                            form.setValue('MED_AVG_I', 0); 
		                            form.setValue('MED_INSUR_I', 0); 
		                            form.setValue('OLD_MED_INSUR_I', 0); 
		                            form.setValue('ORI_MED_INSUR_I', 0); 
		                            panelDetail.down('#salaryInfo').unmask();
		                        } else {
		                            hum100ukrService.getMonthInsurI({
		                                    'MONTH_AVG_I':field.getValue(), 
		                                    'TYPE' : '2'
		                            }, 
		                            function(provider, response)    {
		                                panelDetail.down('#salaryInfo').unmask();
		                                var form = panelDetail.down('#salaryForm');
		                                var oldValue = form.getValue('MED_INSUR_I');
		                                if(!Ext.isEmpty(provider))  {
		                                    if(oldValue !=  provider['INSUR_I'])    {
		// form.setValue('MED_INSUR_I', provider['INSUR_I2']); //건강보험금액 -MED_INSUR_I
		// form.setValue('OLD_MED_INSUR_I', provider['INSUR_I3']); //노인요양(고지) -
		// OLD_MED_INSUR_I
		// form.setValue('ORI_MED_INSUR_I', provider['INSUR_I']); //건강보험 -
		// ORI_MED_INSUR_I
		                                        form.setValue('MED_INSUR_I', provider['INSUR_I3']);  // 건강보험금액
		                                                                                                // -MED_INSUR_I
		                                        form.setValue('OLD_MED_INSUR_I', provider['INSUR_I2']);  // 노인요양(고지)
		                                                                                                    // -
		                                                                                                    // OLD_MED_INSUR_I
		                                        form.setValue('ORI_MED_INSUR_I', provider['INSUR_I']);   // 건강보험
		                                                                                                                    // -
		                                                                                                                    // ORI_MED_INSUR_I
		                                    }
		                                }
		                            })
		                        }
		                    },
		                    change:function(field, newValue, oldValue)  {
		                        if(Ext.isEmpty(newValue))   {
		                            field.setValue(0);
		                        }
		                    }
		                }
		            },{
		                name:'MED_INSUR_I' ,
		                xtype:'uniNumberfield', 
		                allowBlank:true,
		                value:0, 
		                width: 70,
		                hideLabel: true,
		                labelWidth:20,
		                listeners:{
		                    change:function(field, newValue, oldValue)  {
		                        if(Ext.isEmpty(newValue))   {
		                            field.setValue(0);
		                        }
		                    }
		                }
					}]
		        },{
		            xtype       : 'container',
		            layout      : {type: 'uniTable', columns: 2},
		            defaultType : 'uniTextfield',
//		            padding     : '0 0 0 36',
		            items       : [{
		                fieldLabel: '<t:message code="system.label.human.healthinsur" default="건강보험"/>/<t:message code="system.label.human.elderlyinsur" default="노인요양(고지)"/>',
		                name:'ORI_MED_INSUR_I' ,
		                xtype:'uniNumberfield', 
		                allowBlank:true,
		                value:0, 
		                width: 225,
		                labelWidth:140,
		                listeners:{
		                    change:function(field, newValue, oldValue)  {
		                        if(Ext.isEmpty(newValue))   {
		                            field.setValue(0);
		                        }
		                    }
		                }
		            },{
		                fieldLabel: '<t:message code="system.label.human.oldmedinsuri" default="노인요양보험금액"/>',
		                name:'OLD_MED_INSUR_I' ,
		                xtype:'uniNumberfield', 
		                allowBlank:true,
		                value:0,
		                width: 70,
		                hideLabel: true,
		                listeners:{
		                    change:function(field, newValue, oldValue)  {
		                        if(Ext.isEmpty(newValue))   {
		                            field.setValue(0);
		                        }
		                    }
		                }
		             }]
				}
				
				
				,{
		            xtype       : 'container',
		            layout      : {type: 'uniTable', columns: 2},
		            defaultType : 'uniTextfield',
//		            padding     : '0 0 0 36',
		            items       : [{
		                fieldLabel: '건강/요양보험(경감율%)',
		                name:'MED_INSUR_DED_RATE' ,
		                xtype:'uniCombobox', 
		                allowBlank:true,
		                width: 225,
		                comboType: 'AU',
				 		comboCode: 'H230',
		                labelWidth:140
		            },{
		                fieldLabel: '건강/요양보험(경감율)',
		                name:'OLD_INSUR_DED_RATE' ,
		                xtype:'uniCombobox', 
		                allowBlank:true,
		                width: 70,
		                comboType: 'AU',
				 		comboCode: 'H231',
		                hideLabel: true
		             }]
				}
				
				
/*				,{
					fieldLabel: '건강/요양보험(경감율)',
		            labelWidth:140,
		            width: 225,
				 	name:'REDUCTION_RATE',
				 	xtype: 'uniCombobox',
				 	comboType: 'AU',
				 	comboCode: 'H230'
				}*/
				
				,{
		            xtype       : 'container',
		            layout      : {type: 'uniTable', columns: 2},
		            defaultType : 'uniTextfield',
//		            padding     : '0 0 0 36',
		            items       : [{
		                fieldLabel: '<t:message code="system.label.human.medavgigy" default="월평균보수(고용)"/>',
		                name:'HIRE_AVG_I' ,
		                xtype:'uniNumberfield',
		                width: 225,
		                labelWidth:140,
		                allowBlank:true,
		                value:0,
		                listeners: {
		                	blur: function(field, event, eOpt)  {
		                        panelDetail.down('#salaryInfo').mask();
		                        hum100ukrService.getHireInsurI({
		                            'HIRE_AVG_I':field.getValue(), 
		                            'TYPE' : '3'
		                            },
		                            function(provider, response)    {
		                                panelDetail.down('#salaryInfo').unmask();
		                                var form = panelDetail.down('#salaryForm');
		                                var oldValue = form.getValue('HIRE_INSUR_I');
		                                if(!Ext.isEmpty(provider))  {
		                                    if(oldValue !=  provider['HIRE_INSUR_I'])   {
		                                        form.setValue('HIRE_INSUR_I', provider['HIRE_INSUR_I']);    
		                                    }
		                                }
		                            }
		                        );
		                    },
		                    change:function(field, newValue, oldValue)  {
		                        if(Ext.isEmpty(newValue))   {
		                            field.setValue(0);
		                        }
		                    }
		                }
		            },{
		                fieldLabel: '<t:message code="system.label.human.hirinsuri" default="고용보험금액"/>',
		                name:'HIRE_INSUR_I' ,
		                xtype:'uniNumberfield', 
		                allowBlank:true,
		                value:0,
		                width: 70,
		                hideLabel: true,
		                listeners:{
		                    change:function(field, newValue, oldValue)  {
		                        if(Ext.isEmpty(newValue))   {
		                            field.setValue(0);
		                        }
		                    }
		                }
		            }]
		        },{
		            xtype: 'container',
		            layout: {type: 'uniTable', columns: 2},
		            defaultType: 'uniTextfield',
//		            padding: '0 0 0 36',
		            items: [{
		                fieldLabel: '<t:message code="system.label.human.medavgiyear" default="기준소득월액(연금)"/>',
		                name:'ANU_BASE_I' ,
		                xtype:'uniNumberfield',
		                width: 225,
		                labelWidth:140,
		                allowBlank:true,
		                value:0,
		                listeners: {
		                    blur: function(field, event, eOpt)  {
		                        panelDetail.down('#salaryInfo').mask();
		                        hum100ukrService.getMonthInsurI({
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
		                        if(Ext.isEmpty(newValue))   {
		                            field.setValue(0);
		                        }
		                    }
		                }
		            },{
		                fieldLabel: '<t:message code="system.label.human.anuinsuriamt" default="국민연금금액"/>',
		                name:'ANU_INSUR_I' ,
		                xtype:'uniNumberfield', 
		                allowBlank:true,
		                value:0, 
		                width: 70,
		                hideLabel: true,
		                listeners:{
		                    change:function(field, newValue, oldValue)  {
		                        if(Ext.isEmpty(newValue))   {
		                            field.setValue(0);
		                        }
		                    }
		                }
		            }]
		        },{
					fieldLabel: '<t:message code="system.label.human.youtaxredrat" default="청년(외)세액 감면율"/>',
		            labelWidth:140,
				 	name:'YOUTH_EXEMP_RATE',
				 	xtype: 'uniCombobox',
				 	comboType: 'AU',
				 	comboCode: 'H179'
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.youtaxreddea" default="청년(외)세액감면기한"/>',
		            labelWidth:140,
				 	name:'YOUTH_EXEMP_DATE',
				 	xtype: 'uniDatefield'
				},{
		            fieldLabel: '<t:message code="system.label.human.taxratebase" default="세율기준"/>',
		            labelWidth:140,
				 	width:295,
		            name:'TAXRATE_BASE',
		            xtype: 'uniRadiogroup',
		            tdAttrs:{align:'right'},
		            items: [
		                {boxLabel:'80%'     , name:'TAXRATE_BASE',width:35, inputValue:'1'},
		                {boxLabel:'100%'    , name:'TAXRATE_BASE',width:50, inputValue:'2', checked:true},
		                {boxLabel:'120%'    , name:'TAXRATE_BASE',width:50, inputValue:'3'}
		            ]   
		        },{
		            fieldLabel: '<t:message code="system.label.human.trialSalaryRate" default="수습급여비율"/>',
		            labelWidth:140,
				 	width:295,
		            name:'TRIAL_SALARY_RATE',
		            xtype: 'uniNumberfield',
		            format : '#0,000.00',
		            decimalPrecision : 2 ,
		            maxLength : 6,
		            suffixTpl : '%'
		        },{
			  	 	fieldLabel: '외국인 기술자 여부',
		            hidden:true,
				 	name:'FOREIGN_SKILL_YN',
				 	xtype: 'uniTextfield'
				},{
				    fieldLabel: 'form 구역 안에 uniDateRangefield가 존재해야 form.isDirty()가 정상작동하여 저장버튼이 살아나는 현상있음... 확인필요 ',
		            xtype: 'uniDateRangefield',
	                hidden:true
	        	}]
	        },{
	        	xtype:'component',
	        	width:10
        	},{
				title: '<t:message code="system.label.human.payetcinfo" default="지급/기타정보"/>',
				xtype: 'uniFieldset',
				itemId:'salaryForm_3',
				layout:{type: 'uniTable', columns:1, tableAttrs:{cellpadding:1}, tdAttrs: {valign:'top'}},
		        padding: '10 10 10 20',
				autoScroll:false,
				defaultType:'uniTextfield',
				height:boxSize,
				items:[{
			  	 	fieldLabel: '<t:message code="system.label.human.payprov" default="급여지급"/>',
				 	name:'PAY_PROV_YN' , 
				 	xtype: 'uniRadiogroup',
				 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
				 	width:260,
				 	items: [
						{boxLabel:'<t:message code="system.label.human.do" default="한다"/>'	, name:'PAY_PROV_YN', inputValue:'Y', checked:true},
						{boxLabel:'<t:message code="system.label.human.donot" default="안한다"/>'	, name:'PAY_PROV_YN', inputValue:'N'}
					]
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.payprovstopyn" default="급여지급보류"/>',
				 	name:'PAY_PROV_STOP_YN', 
				 	xtype: 'uniRadiogroup',
				 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
				 	width:260,
				 	items: [
						{boxLabel:'<t:message code="system.label.human.do" default="한다"/>'	, name:'PAY_PROV_STOP_YN', inputValue:'Y'},
						{boxLabel:'<t:message code="system.label.human.donot" default="안한다"/>'	, name:'PAY_PROV_STOP_YN', inputValue:'N', checked:true}
					]
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.taxcalculationmethod" default="세액계산"/>',
				 	name:'COMP_TAX_I' , 
				 	xtype: 'uniRadiogroup',
				 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
				 	width:260,
				 	items: [
						{boxLabel:'<t:message code="system.label.human.do" default="한다"/>'	, name:'COMP_TAX_I', inputValue:'Y', checked:true},
						{boxLabel:'<t:message code="system.label.human.donot" default="안한다"/>'	, name:'COMP_TAX_I', inputValue:'N'}
					]
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.hireinsurtype2" default="고용보험계산"/>',
				 	name:'HIRE_INSUR_TYPE' , 
				 	xtype: 'uniRadiogroup',
				 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
				 	width:260,
				 	colspan: 3,
				 	items: [
						{boxLabel:'<t:message code="system.label.human.do" default="한다"/>'	, name:'HIRE_INSUR_TYPE', inputValue:'Y', checked:true},
						{boxLabel:'<t:message code="system.label.human.donot" default="안한다"/>'	, name:'HIRE_INSUR_TYPE', inputValue:'N'}
					]
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.workconpenyn" default="산재보험계산"/>',
				 	name:'WORK_COMPEN_YN', 
				 	xtype: 'uniRadiogroup',
				 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
				 	width:260,
				 	colspan: 3,
				 	items: [
						{boxLabel:'<t:message code="system.label.human.do" default="한다"/>'	, name:'WORK_COMPEN_YN', inputValue:'Y', checked:true},
						{boxLabel:'<t:message code="system.label.human.donot" default="안한다"/>'	, name:'WORK_COMPEN_YN', inputValue:'N'}
					]
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.bonusprovyn" default="상여지급"/>',
				 	name:'BONUS_PROV_YN', 
				 	xtype: 'uniRadiogroup',
				 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
				 	width:260,
				 	colspan: 3,
				 	items: [
						{boxLabel:'<t:message code="system.label.human.do" default="한다"/>'	, name:'BONUS_PROV_YN', inputValue:'Y', checked:true},
						{boxLabel:'<t:message code="system.label.human.donot" default="안한다"/>'	, name:'BONUS_PROV_YN', inputValue:'N'}
					]
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.yeargive2" default="연차수당지급"/>',
				 	name:'YEAR_GIVE' , 
				 	xtype: 'uniRadiogroup',
				 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
				 	width:260,
				 	colspan: 3,
				 	items: [
						{boxLabel:'<t:message code="system.label.human.do" default="한다"/>'	, name:'YEAR_GIVE', inputValue:'Y', checked:true},
						{boxLabel:'<t:message code="system.label.human.donot" default="안한다"/>'	, name:'YEAR_GIVE', inputValue:'N'}
					]
				},{
			  	 	fieldLabel: '<t:message code="system.label.accnt.yearcalcu2" default="연말정산신고"/>',
				 	name:'YEAR_CALCU'  ,
				 	xtype: 'uniRadiogroup',
				 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
				 	width:260,
				 	colspan: 3,
				 	items: [
						{boxLabel:'<t:message code="system.label.human.do" default="한다"/>'	, name:'YEAR_CALCU', inputValue:'Y', checked:true},
						{boxLabel:'<t:message code="system.label.human.donot" default="안한다"/>'	, name:'YEAR_CALCU', inputValue:'N'}
					]
				},
				
				{
			  	 	fieldLabel: '<t:message code="system.label.human.laborunon" default="노조가입"/>',
				 	name:'LABOR_UNON_YN' ,
				 	xtype: 'uniRadiogroup',
				 	width:260,
				 	colspan: 3,
				 	items: [
						{boxLabel:'<t:message code="system.label.human.laboruony" default="가입"/>'	, name:'LABOR_UNON_YN', inputValue:'Y'},
						{boxLabel:'<t:message code="system.label.human.laboruonn" default="미가입"/>'	, name:'LABOR_UNON_YN', inputValue:'N', checked:true}
					],
					listeners: {
		                change: function(field, newValue, oldValue, eOpts) {
	                    	if(newValue == null || typeof newValue === "undefined") {
	                    		newValue = {LABOR_UNON_YN:'N'};
	                    	}
	                    	
		                    if(newValue.LABOR_UNON_YN == 'N'){
		                    	panelDetail.down('#salaryForm').getField('LABOR_UNON_CODE_GROUP').setDisabled(true);
		                    }else{
		                    	panelDetail.down('#salaryForm').getField('LABOR_UNON_CODE_GROUP').setDisabled(false);
		                    }
		                }
		            }
				},{
		            fieldLabel: '<t:message code="system.label.human.larborunoncodegroup" default="가입노조"/>',
		            name: 'LABOR_UNON_CODE_GROUP',
		            xtype: 'uniCheckboxgroup',
		            disabled:true,
		            colspan:3,
		            items: [{
		                boxLabel: '<t:message code="system.label.human.laborunon1" default="공사노조"/>',
		                name: 'LABOR_UNON_CODE',
		                width:80,
		                inputValue: '01'
		            },{
		                boxLabel: '<t:message code="system.label.human.laborunon2" default="우리민주"/>',
		                name: 'LABOR_UNON_CODE',
		                width:80,
		                inputValue: '02'
		            },{
		                boxLabel: '<t:message code="system.label.human.etc" default="기타"/>',
		                name: 'LABOR_UNON_CODE',
		                inputValue: '04',
		                width:80
		            }]
				},{
			  	 	fieldLabel: '<t:message code="system.label.human.yearEndTaxInstallmentYn" default="연말정산분납신청"/>',
				 	name:'YEARENDTAX_INSTALLMENTS_YN' ,
				 	xtype: 'uniRadiogroup',
				 	width:260,
				 	colspan: 3,
				 	items: [
						{boxLabel:'<t:message code="system.label.human.do" default="한다"/>'			, name:'YEARENDTAX_INSTALLMENTS_YN', inputValue:'Y', checked:true},
						{boxLabel:'<t:message code="system.label.human.donot" default="안한다"/>'	, name:'YEARENDTAX_INSTALLMENTS_YN', inputValue:'N'}
					]
				},{
		            fieldLabel: '<t:message code="system.label.human.annuretrkind" default="퇴직연금"/>',
		            name:'RETR_PENSION_KIND' , 
		            xtype: 'uniRadiogroup',
		            width:230,
					columns:2,
		            items: [
		                {boxLabel:'DB'      , name:'RETR_PENSION_KIND', inputValue:'DB', checked:true},
		                {boxLabel:'DC'      , name:'RETR_PENSION_KIND', inputValue:'DC'},
		                {boxLabel:'DBDC'    , name:'RETR_PENSION_KIND', inputValue:'BC'},
		                {boxLabel:'<t:message code="system.label.human.laboruonn" default="미가입"/>' , name:'RETR_PENSION_KIND', inputValue:'N'}
		            ],
		            listeners: {
		                change: function(field, newValue, oldValue, eOpts) {
	                    	if(newValue == null || typeof newValue === "undefined") {
	                    		newValue = {RETR_PENSION_KIND:'N'};
	                    	}
	                    	
		                    if(newValue.RETR_PENSION_KIND == 'N'){
		                    	panelDetail.down('#salaryForm').getField('RETR_PENSION_BANK').setDisabled(true);
		                    }else{
		                    	panelDetail.down('#salaryForm').getField('RETR_PENSION_BANK').setDisabled(false);
		                    }
		                }
		            }
		        }
/*		        ,{
		            fieldLabel: ' ',
		            name:'RETR_PENSION_KIND' , 
		            xtype: 'uniRadiogroup',
		            width:230,
	
		            items: [
		                
		            ],
		            listeners: {
		                change: function(field, newValue, oldValue, eOpts) {
		                    if(newValue.RETR_PENSION_KIND == 'BC'){
		                    	panelDetail.down('#salaryForm').getField('RETR_PENSION_BANK').setDisabled(false);
		                    }else{
		                    	var form = panelDetail.down('#salaryForm');
		                        form.setValue('RETR_PENSION_BANK', ''); 
		                    	panelDetail.down('#salaryForm').getField('RETR_PENSION_BANK').setDisabled(true);
		                    }
		                }
		            }
		        }*/
		        ,{
			  	 	fieldLabel: '운용사',
				 	name:'RETR_PENSION_BANK' , 
				 	xtype: 'uniCombobox',
				 	comboType: 'AU', 
				 	comboCode: 'H221'   
				}
		        ,{
			  	 	fieldLabel: '<t:message code="system.label.human.makesale" default="제조판관구분"/>',
				 	name:'MAKE_SALE' , 
				 	allowBlank:false,
				 	xtype: 'uniCombobox',
				 	comboType: 'AU', 
				 	comboCode: 'B027'   
				},{
			  	 	fieldLabel: costPoolLabel,
				 	name:'COST_KIND'   ,   
				 	xtype: 'uniCombobox',
				 	store : Ext.StoreManager.lookup('costPoolCombo')
				}]
	        }]
		}],
		listeners:{
			uniOnChange:function( form ) {
				if(form.isDirty() && !form.uniOpt.inLoading)	{
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	}],
	loadData:function(personNum)	{
		var salaryForm = this.down('#salaryForm');
		salaryForm.uniOpt.inLoading = true; 
		salaryForm.clearForm();
		salaryForm.mask();
		salaryForm.getForm().load({
			params : {'PERSON_NUMB':personNum},
			success: function(form, action)	{
				if(!Ext.isEmpty(action.result.data.LABOR_UNON_CODE)){
                    var laborUnonCode = action.result.data.LABOR_UNON_CODE.split(',');
					panelDetail.down('#salaryForm').getField('LABOR_UNON_CODE_GROUP').setValue({
                        LABOR_UNON_CODE:laborUnonCode
                    });
                    UniAppManager.app.setToolbarButtons('save',false);  
				}
			 	salaryForm.uniOpt.inLoading = false; 
			 	salaryForm.unmask();
			},
			failure: function(form, action)	{
			 	salaryForm.uniOpt.inLoading = false; 
			 	salaryForm.unmask();
			}
		});
	}
};
 function wageCodePopup()	{ 
 		var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
		var returnForm = activeTab.down('#salaryForm');
	    if(!payGrdWin) {
	    		var winfields = [
	    			 {name: 'PAY_GRADE_01' 		,text:'<t:message code="system.label.human.paygradegeb" default="급"/>' 					,type:'string'	}
					,{name: 'PAY_GRADE_02' 		,text:'<t:message code="system.label.human.paygradeho" default="호"/>' 					,type:'string'	}
				];
		    	Ext.each(wageStd, function(stdCode, idx) {
		    		winfields.push({name: 'CODE'+stdCode.WAGES_CODE 	,text:stdCode.WAGES_NAME+'<t:message code="system.label.human.code" default="코드"/>' 			,type:'string'	});
		    		winfields.push({name: 'STD'+stdCode.WAGES_CODE 		,text:stdCode.WAGES_NAME 					,type:'uniPrice'});		    		
		    	})
	    		Unilite.defineModel('WagesCodeModel', {
				    fields: winfields
				});
				
				var wagesCodeDirctProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
					api: {
						read : 'hum100ukrService.fnHum100P2'
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
	                title: '<t:message code="system.label.human.abaloneinq" default="급호봉조회"/>POPUP',
	                width: 400,				                
	                height:400,
				    
	                layout: {type:'vbox', align:'stretch'},	                
	                items: [{
		                	itemId:'search',
		                	xtype:'uniSearchForm',
		                	layout:{type:'uniTable',columns:2},
		                	items:[
		                		{	
		                			fieldLabel:'<t:message code="system.label.human.paygradegeb" default="급"/>',
		                			labelWidth:60,
		                			name :'PAY_GRADE_01',
		                			width:160
		                		},{
		                			
		                			fieldLabel:'<t:message code="system.label.human.paygradeho" default="호"/>',
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
	                tbar:  ['->',
	               		 {
							itemId : 'searchtBtn',
							text: '<t:message code="system.label.human.inquiry" default="조회"/>',
							handler: function() {
								var form = payGrdWin.down('#search');
								var store = Ext.data.StoreManager.lookup('creditStore')
								wageCodeStore.loadStoreRecords();
							},
							disabled: false
						},
				         {
							itemId : 'submitBtn',
							text: '<t:message code="system.label.human.confirm" default="확인"/>',
							handler: function() {
								payGrdWin.down('#grid').returnData()
								payGrdWin.hide();
							},
							disabled: false
						},{
							itemId : 'closeBtn',
							text: '<t:message code="system.label.human.close" default="닫기"/>',
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