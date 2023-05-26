<%@page language="java" contentType="text/html; charset=utf-8"%>
var personalInfo =	 {
    title: '<t:message code="system.label.human.personbasisinfo" default="인사기본정보"/>',
    itemId: 'personalInfo',
	layout:{type:'vbox', align:'stretch'},
	xtype:'uniDetailForm',
	api: {
		load: hum100ukrService.select,
		submit: hum100ukrService.saveHum100
	},
	defaultType:'container',
	flex:1,
	bodyCls: 'human-panel-form-background',
	disabled: false,
	flex:1,
    items:[{
		xtype: 'uniFieldset',
		itemId:'basicInfo',
		layout:{type: 'uniTable', columns:2},
		margin: '10 10 10 10',
		scrollable:true,
		defaultType:'container',
		items:[{
			width: 274,
			margin: '10 0 10 0',
			layout:{type: 'uniTable', columns:2, tableAttrs:{class:'photo-background'}},
			cls:'photo-background',
			items: [{
				xtype:'component',
	        	itemId:'EmpImg',
	        	width:130,
	        	autoEl: {
	        		tag: 'img',
	        		src: CPATH+'/resources/images/human/noPhoto.png',
	        		cls:'photo-wrap'
	        	}
			},{
				xtype:'container',
  				layout:{type: 'vbox', align:'stretch'},
  				width:140,
  				defaults:{cls:'photo-lable-group'},
  				tdAttrs:{valign:'top'},
  				margin:'20 5 5 5',
  				items: [{
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
		        	items:[{
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
					}]
				},{
					xtype:'container',
					padding : '2 0 0 0',
		        	items:[{
						xtype: 'button',
						text: '문서등록',
						itemId: 'docaddbutton',
						width : '80%',
						holdable: 'hold',
						handler: function() {
							openFileWindow();
						}
					}]
				}]
			}]
		},{
		 	defaultType:'uniTextfield',
		 	itemId: 'basicInfoForm',
		 	disabled:false,
		 	layout: {type: 'uniTable',  columns:2},
		 	width: 640,
		 	bodyCls: 'human-panel-form-background',
	 		defaults: {
				width:300,
				labelWidth:140
    		},
			items:[{
    	  	 	fieldLabel: '<t:message code="system.label.human.personnumb" default="사번"/>',
			 	name:'PERSON_NUMB' ,
				allowBlank:${autoNum},
				readOnly:${autoNum},
				width:230,
				labelWidth:110,
				listeners:{
					blur: function(field, event, eOpts ){
						if(UniAppManager.app._needSave()){
							this.up('#personalInfo').down('#empNo').update(field.getValue());
						}
						if(field.lastValue != field.originalValue){
							var param = {
								"PERSON_NUMB" : field.lastValue
							};
							hum100ukrService.personNumbCheck(param, function(provider, response)  {
			                    if(!Ext.isEmpty(provider)){
			                        if(provider=='N'){
			                        	Unilite.messageBox('<t:message code="system.message.human.message135" default="이미 사용중인 사번입니다."/>');
			                        	panelDetail.down('#personalInfo').setValue('PERSON_NUMB','')
			                        }
			                    }
							});
						}
					}
				}
			},{
    	  	 	fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
			 	name:'DIV_CODE' ,
			 	allowBlank:false,
			 	xtype: 'uniCombobox',
			 	comboType: 'BOR120'
			},{
    	  	 	fieldLabel: '<t:message code="system.label.human.name" default="성명"/>',
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
    	  	 	fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
			 	showValue:false,
			 	allowBlank:false,
			 	textFieldWidth:155,
			 	listeners: {
                    onTextFieldChange: function(field, newValue){
                    	if(newValue == ''){
                    		panelDetail.down('#personalInfo').setValue('DEPT_CODE', '');
                    	}                    	
                    }
			 	}
			}),
			{
    	  	 	fieldLabel: '<t:message code="system.label.human.engname" default="영문명"/>',
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
    	  	 	fieldLabel: '<t:message code="system.label.human.postcode" default="직위"/>',
			 	name:'POST_CODE' ,
			 	allowBlank:false,
			 	xtype: 'uniCombobox',
			 	comboType: 'AU',
			 	comboCode: 'H005'
			},{
    	  	 	fieldLabel: '<t:message code="system.label.human.namechi" default="한자이름"/>',
			 	name:'NAME_CHI',
				width:230,
				labelWidth:110
			},{
    	  	 	fieldLabel: '<t:message code="system.label.human.abil" default="직책"/>',
			 	name:'ABIL_CODE',
			 	xtype: 'uniCombobox',
			 	comboType: 'AU',
			 	comboCode: 'H006',
                pickerWidth: 250

			},
			Unilite.popup('ZIP',{
				fieldLabel: '<t:message code="system.label.human.address2" default="주소"/>',
				labelWidth:110,
				showValue:false,
				textFieldWidth:115,
				textFieldName:'ZIP_CODE',
				DBtextFieldName:'ZIP_CODE',
				validateBlank:false,
				popupHeight:580,
				listeners: { 
					'onSelected': {
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
    	  	 	fieldLabel: '<t:message code="system.label.human.serial" default="직렬"/>',
			 	name:'AFFIL_CODE',
			 	xtype: 'uniCombobox',
			 	comboType: 'AU',
			 	comboCode: 'H173'
			},{
    	  	 	fieldLabel: '<t:message code="system.label.human.addressdetail" default="상세주소"/>',
			 	name:'KOR_ADDR',
			 	hideLabel:true,
			 	width:250,
			 	margin:'0 0 0 115'
			},{
                fieldLabel: '<t:message code="system.label.human.ocpt" default="직종"/>',
                name:'KNOC',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H072'
            }]
		}],
		loadBasicData: function(node)	{
			if(!Ext.isEmpty(node))	{
				var data = node.getData();
				this.down('#EmpImg').getEl().dom.src=CPATH+'/uploads/employeePhoto/'+data['PERSON_NUMB'] + '?_dc=' + data['dc'];;
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
		xtype: 'container',
        layout: {type: 'uniTable', columns: 5},
        padding: '10 10 10 10',
        scrollable:true,
        flex:1,
        items: [{
			title: '<t:message code="system.label.human.basisinfo" default="기본정보"/>',
			xtype: 'uniFieldset',
			itemId:'personalForm_1',
			layout:{type: 'uniTable', columns:1, tableAttrs:{cellpadding:1}, tdAttrs: {valign:'top'}},
	        padding: '10 10 10 20',
			autoScroll:false,
			defaultType:'uniTextfield',
			height:350,
			items:[{
	            xtype: 'container',
	            layout: {type: 'uniTable', columns: 2},
	            items: [{
	                fieldLabel:'<t:message code="system.label.human.reprenum" default="주민등록번호"/>',
	                name :'REPRE_NUM_EXPOS',
	                xtype: 'uniTextfield',
	                itemId: 'repreNumExpos',
	                allowBlank: false,
	                width:235,
	                listeners:{
						blur: function(field, event, eOpts ){
							
							if(!Ext.isEmpty(field.lastValue)){
								var newValueChk = field.getValue().replace(/-/g ,'');
								var newValue = newValueChk.replace(/\*/g ,'');

								if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{
							 		Unilite.messageBox('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
							 		this.setValue(field.originalValue);
							 		return ;
							 	}								
								
								if(field.lastValue != field.originalValue){
									
				  					if(Unilite.validate('residentno',newValue) != true && !Ext.isEmpty(newValue))	{
								 		if(!confirm(Msg.sMB174+"\n"+Msg.sMB176))	{
								 			field.setValue(field.originalValue);
								 			return;
								 		}
								 	}
									var param = {
										"DECRYP_WORD" : field.lastValue
									};
									humanCommonService.encryptField(param, function(provider, response)  {
					                    if(!Ext.isEmpty(provider)){
				                        	panelDetail.down('#personalInfo').setValue('REPRE_NUM',provider);
					                    }else{
				                        	panelDetail.down('#personalInfo').setValue('REPRE_NUM_EXPOS',"");
				                        	panelDetail.down('#personalInfo').setValue('REPRE_NUM',"");
					                    }
				                        field.originalValue = field.lastValue; 
				                        
				                        
				                        
				                        if(field.lastValue.length > 6) {
				                            field.lastValue = field.lastValue.replace('-','');
				                            var birth = field.lastValue.substring(0,6);
				                            var checkNo = field.lastValue.substring(6,7);
				                            var sexCheck = field.lastValue.substring(6,7);
				                            var formPanel = panelDetail.down('#personalInfo');
				                            
				                            if(checkNo == '1' || checkNo == '2' ||checkNo == '5' || checkNo == '6'){
				                                birth = '19' + birth;
				                            }else if(checkNo == '3' || checkNo == '4' || checkNo == "7" || checkNo == "8" ){
				                                birth = '20' + birth;
				                            }
				                            
				                            if(sexCheck%2==0){
				                            	formPanel.setValue('SEX_CODE','F');
				                            }else{
				                            	formPanel.setValue('SEX_CODE','M');
				                            }
				
				                            formPanel.setValue('KOR_AGE', calcAge(birth));
				                            formPanel.setValue('BIRTH_DATE', birth);
				                        }
				                        
									});
								}
							}else{
								panelDetail.down('#personalInfo').setValue('REPRE_NUM',"");
								panelDetail.down('#personalInfo').setValue('BIRTH_DATE',"");
								panelDetail.down('#personalInfo').setValue('KOR_AGE',"");
							}
						},
	                    afterrender:function(field) {
	                        field.getEl().on('dblclick', field.onDblclick);
	                    }
	                },
	                onDblclick:function(event, elm) {
	                    var formPanel = panelDetail.down('#personalInfo');
						var params = {'INCRYP_WORD':formPanel.getValue('REPRE_NUM')};
	                    Unilite.popupDecryptCom(params);
	                }
	            },{
	                fieldLabel: '<t:message code="system.label.human.socialsecuritynumberencryption" default="주민번호 암호화"/>',
	                name: 'REPRE_NUM',
	                xtype: 'uniTextfield',
	                hidden: true
	             /*   listeners:{
	                    change:function(field, newValue, oldValue)  {
	                        if(newValue.length > 6) {
	                            newValue = newValue.replace('-','');
	                            birth = newValue.substring(0,6);
	                            sexCheckNo = newValue.substring(6,7);
	
	                            if(sexCheckNo == '1' || sexCheckNo == '2' ||sexCheckNo == '5' || sexCheckNo == '6'){
	                                birth = '19' + birth;
	                            }else if(sexCheckNo == '3' || sexCheckNo == '4' || sexCheckNo == "7" || sexCheckNo == "8" ){
	                                birth = '20' + birth;
	                            }
	
	                            var formPanel = this.up('#personalInfo');
	                            formPanel.setValue('KOR_AGE', calcAge(birth));
	                        }
	                    }
	                }*/
	            },{
	                fieldLabel: '<t:message code="system.label.human.sexcode" default="성별"/>',
	                name: 'SEX_CODE' ,
	                xtype: 'uniRadiogroup',
	                allowBlank: false,
	                hideLabel: true,
	                width: 80,
	                margin: '0 0 0 5',
	                items: [
	                    {boxLabel:'<t:message code="system.label.human.male" default="남"/>', name:'SEX_CODE', inputValue:'M', width: 40, checked:true},
	                    {boxLabel:'<t:message code="system.label.human.female" default="여"/>', name:'SEX_CODE', inputValue:'F',width: 40}
	                ]
	            }]
			},{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 2},
                items: [{
        	  	 	fieldLabel: '<t:message code="system.label.human.birthdate" default="생일"/>',
				 	name:'BIRTH_DATE',
				 	xtype:'uniDatefield',
				 	listeners:{
	                    change:function(field, newValue, oldValue)  {
							var activeTab = panelDetail.down('#hum100Tab').getActiveTab();
							if(activeTab.getItemId()=='personalInfo')	{
	                            var formPanel = panelDetail.down('#personalInfo');
		                    	formPanel.setValue('KOR_AGE', calcAge(UniDate.getDbDateStr(newValue)));
		                    }
	                    }
				 	}
				},{
        	  	 	fieldLabel: '<t:message code="system.label.human.solaryn" default="양력/음력구분"/>',
        	  	 	id: 'SOLAR_YN',
				 	name:'SOLAR_YN'  ,
				 	allowBlank:false,
				 	hideLabel:true,
				 	xtype: 'uniRadiogroup',
				 	width: 80,
				 	margin: '0 0 0 5',
					items: [
	 					{boxLabel:'양', name:'SOLAR_YN', inputValue:'Y',width: 40, checked:true},
	 					{boxLabel:'음', name:'SOLAR_YN', inputValue:'N',width: 40}
	  				]
				}]
    		},{
                fieldLabel: '<t:message code="system.label.human.korage" default="나이(만)"/>',
                name: 'KOR_AGE',
                xtype: 'uniTextfield',
                value: 0,
                readOnly: true
            },{
                fieldLabel: '<t:message code="system.label.human.nationcode" default="국적"/>',
                name:'NATION_CODE' ,
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B012',
                allowBlank:false
            },{
                fieldLabel: '거주지국',
                name:'LIVE_CODE' ,
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B012',
                allowBlank:false
            },{
                fieldLabel: '<t:message code="system.label.human.schshipcode" default="최종학력"/>',
                name:'SCHSHIP_CODE',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H009'
            },{
                fieldLabel: '<t:message code="system.label.human.gradutype" default="졸업구분"/>',
                name:'GRADU_TYPE',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H010'
            },{
                fieldLabel: '<t:message code="system.label.human.deformyn" default="장애인여부"/>',
                name:'DEFORM_YN',
                xtype: 'uniRadiogroup',
                items: [
                    {boxLabel:'<t:message code="system.label.human.yes" default="예"/>'    , name:'DEFORM_YN',width: 90, inputValue:'Y'},
                    {boxLabel:'<t:message code="system.label.human.no" default="아니오"/>' , name:'DEFORM_YN',width: 90, inputValue:'N', checked:true}
                ],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    	if(newValue == null || typeof newValue === "undefined") {
                    		newValue = {DEFORM_YN:'N'};
                    	}
                    	
                        if(newValue.DEFORM_YN == 'N'){
                            panelDetail.down('#personalInfo').getField('DEFORM_GRD').setDisabled(true);
                            panelDetail.down('#personalInfo').getField('DEFORM_GRD').setConfig('allowBlank', true);
                        }else{
                            panelDetail.down('#personalInfo').getField('DEFORM_GRD').setDisabled(false);
                            panelDetail.down('#personalInfo').getField('DEFORM_GRD').setConfig('allowBlank', false);

                        }
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.human.deformgubun" default="장애인구분"/>',
                name:'DEFORM_GRD',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H169',
                disabled:true
            }]
		},{
        	xtype:'component',
        	width:10
        },{
			title: '<t:message code="system.label.human.exceptinfo" default="입퇴사정보"/>',
			xtype: 'uniFieldset',
			itemId:'personalForm_2',
			layout:{type: 'uniTable', columns:1, tableAttrs:{cellpadding:1},  tdAttrs: {valign:'top'}},
	        padding: '10 10 10 20',
			autoScroll:false,
			defaultType:'uniTextfield',
			height:350,
			items:[{
                fieldLabel: '<t:message code="system.label.human.firstjoindate" default="최초입사일"/>',
                name:'ORI_JOIN_DATE',
                xtype:'uniDatefield'
            },{
                fieldLabel: '<t:message code="system.label.human.joindate" default="입사일"/>',
                name:'JOIN_DATE' ,
                allowBlank:false,
                xtype:'uniDatefield'
            },{
                fieldLabel: '<t:message code="system.label.human.joinway" default="입사방식"/>',
                name:'JOIN_CODE' ,
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H012',
                allowBlank:false
            },{
                fieldLabel: '<t:message code="system.label.human.retrdate" default="퇴사일"/>',
                name:'RETR_DATE' ,
                xtype:'uniDatefield'
            },{
                fieldLabel: '<t:message code="system.label.human.retrreson" default="퇴사사유"/>',
                name:'RETR_RESN',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H023' 
            },{
                fieldLabel: '<t:message code="system.label.human.retrotkind2" default="퇴직계산분류"/>',
                name:'RETR_OT_KIND',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H112',
                allowBlank:false
            },{
                fieldLabel: '<t:message code="system.label.human.retrlastdate" default="퇴직중간정산"/>',
                name:'RETR_LAST_DATE',
                readOnly:true
            }]
		},{
        	xtype:'component',
        	width:10
        },{
			title: '<t:message code="system.label.human.bussinfo" default="소속정보"/>',
			xtype: 'uniFieldset',
			itemId:'personalForm_3',
			layout:{type: 'uniTable', columns:1, tableAttrs:{cellpadding:1}, tdAttrs: {valign:'top'}},
	        padding: '10 10 10 20',
			autoScroll:false,
			defaultType:'uniTextfield',
			height:350,
			items:[{
    	  	 	fieldLabel: '<t:message code="system.label.human.sectcode" default="신고사업장"/>',
			 	name:'SECT_CODE' ,
			 	allowBlank:false,
			 	xtype: 'uniCombobox',
				comboType: 'BOR120'
			},{
                fieldLabel: '<t:message code="system.label.human.bussofficecode" default="소속지점"/>',
                name:'BUSS_OFFICE_CODE' ,
                xtype: 'uniCombobox',
                allowBlank:false,
                store : Ext.StoreManager.lookup('BussOfficeCode')
            },{
                fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
                name:'PAY_GUBUN' ,
                allowBlank:false,
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H011',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        if(newValue == '1'){
                            panelDetail.down('#personalInfo').getField('PAY_GUBUN2').setDisabled(true);
                            panelDetail.down('#personalInfo').getField('BZNS_ATRB').setDisabled(true);
                            panelDetail.down('#personalInfo').getField('HUMN_ATRB').setDisabled(true);
                            
                        }else{
                            panelDetail.down('#personalInfo').getField('PAY_GUBUN2').setDisabled(false);
                            panelDetail.down('#personalInfo').getField('BZNS_ATRB').setDisabled(false);
                            panelDetail.down('#personalInfo').getField('HUMN_ATRB').setDisabled(false);
                        }
                    }
                }
            },{        
                fieldLabel: ' ',
                name: 'PAY_GUBUN2',
                xtype: 'uniRadiogroup',
                labelWidth: 80,
                width: 200, 
                items:[
                        {
                           boxLabel:'<t:message code="system.label.human.dailyworkers" default="일용"/>',
                           name: 'PAY_GUBUN2',
                           inputValue:'1'
                        },{
                           boxLabel:'<t:message code="system.label.human.nomal" default="일반"/>',
                           name: 'PAY_GUBUN2',
                           inputValue:'2'
                        }
                ]
             },{
                fieldLabel: '<t:message code="system.label.human.businessattribute" default="업무속성"/>',
                name: 'BZNS_ATRB' ,                
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H204'
            },{
                fieldLabel: '<t:message code="system.label.human.humanproperty" default="인적속성"/>',
                name: 'HUMN_ATRB' ,                
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H205'
            },{
                fieldLabel: '<t:message code="system.label.human.employtype" default="사원구분"/>',
                name: 'EMPLOY_TYPE' ,
                allowBlank: false,
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H024'
            },{
                fieldLabel: '<t:message code="system.label.human.trialtermenddate" default="수습만료일자"/>',
                name:'TRIAL_TERM_END_DATE' ,
                xtype:'uniDatefield'
            },{
                fieldLabel: '<t:message code="system.label.human.jobcode1" default="담당업무"/>',
                name:'JOB_CODE',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'H008',
                allowBlank: true
            },
			Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.human.project" default="프로젝트"/>',
				valueFieldName:'PJT_CODE',
				DBvalueFieldName: 'PJT_CODE',
				textFieldName:'PJT_NAME',
				DBtextFieldName: 'PJT_NAME',
				textFieldOnly: false,
				valueFieldWidth: 100,
				textFieldWidth: 150,
				verticalMode : true,
				listeners: { 
					'onSelected': {
	                    fn: function(records, type  ){
	                    	panelDetail.down('#personalInfo').setValue('KOR_ADDR', records[0]['ZIP_NAME']+records[0]['ADDR2']);
	                    },
			            scope: this
			        },
			        'onClear' : function(type)	{
			        	panelDetail.down('#personalInfo').setValue('KOR_ADDR', '');
			        }
				}
			})]
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
	},
	loadData:function(personNum)	{
		var me = this;
		me.uniOpt.inLoading = true;
		me.clearForm();
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

//만나이 계산 함수
function calcAge(birth) {
	var age ='';
	if(!Ext.isEmpty(birth)){
	    var date = new Date();
	    var year = date.getFullYear();
	    var month = (date.getMonth() + 1);
	    var day = date.getDate();
	    if (month < 10) month = '0' + month;
	    if (day < 10) day = '0' + day;
	    var monthDay = month + day;
	
	    birth = birth.replace('-', '').replace('-', '');
	    var birthdayy = birth.substr(0, 4);
	    var birthdaymd = birth.substr(4, 4);
	
	    age = monthDay < birthdaymd ? year - birthdayy - 1 : year - birthdayy;
    
	}
	return age;
}
