<%@page language="java" contentType="text/html; charset=utf-8"%>
var etcInfo =	 {
		title:'인사추가정보', 
		itemId: 'etcInfo',
		layout:{type:'vbox', align:'stretch'},	
        
        items:[ basicInfo,
        		{
	    			xtype: 'uniDetailForm',
	    			itemId: 'etcForm',
	    			bodyCls: 'human-panel-form-background',
	    			disabled: false,
	    			api: {
			         		 load: s_hum100ukrService_KOCIS.select,
			         		 submit: s_hum100ukrService_KOCIS.saveHum100
					},
	    			layout: {type:'uniTable', columns:'3', tdAttrs:{width: 260/*, style: 'border : 1px solid #ced9e7;'*//*, align : 'center'*/}},
	    			margin:'0 10 0 10',
	        		padding:'0',
	        		defaults: {
	        					width:260,
	        					labelWidth:120
	        		},
	        		flex:1,
	    			items: [{
			        	  	 	
							 	name:'PERSON_NUMB' ,
							 	hidden: true
							},{
			        	  	 	fieldLabel: '군번',
							 	name:'ARMY_NO'  
							},{
			        	  	 	fieldLabel: '전화번호',
							 	name:'TELEPHON', 
 							 	width:260 
							},{
			        	  	 	fieldLabel: '휴대폰번호',
							 	name:'PHONE_NO',
	        					listeners:{
	        						blur: function(field, event, eOpts )	{
	        							if(UniAppManager.app._needSave()){
	        								this.up('#etcInfo').down('#empTel').update(field.getValue());	
	        							}
	        						}
	        					}    
							},{
                                fieldLabel: '병역군별',
                                name:'ARMY_KIND',
                                xtype: 'uniCombobox',
                                comboType: 'AU', 
                                comboCode: 'H017'   
                            },{
                                fieldLabel: '결혼기념일',
                                name:'WEDDING_DATE',
                                xtype:'uniDatefield'
                            },{
                                fieldLabel: '결혼여부',
                                name:'MARRY_YN' , 
                                xtype: 'uniRadiogroup',
                                items: [
                                    {boxLabel:'유', name:'MARRY_YN', inputValue:'Y', checked:true},
                                    {boxLabel:'무', name:'MARRY_YN', inputValue:'N'}
                                ]
                            },{
                                fieldLabel: '병역구분',
                                name:'MIL_TYPE'  ,
                                xtype: 'uniCombobox',
                                comboType: 'AU', 
                                comboCode: 'H016' 
                            },{
                                fieldLabel: '외국인등록번호',
                                name:'FOREIGN_NUM'
                            },{
                                fieldLabel: '외국인기술자여부',
                                name:'FOREIGN_SKILL_YN', 
                                xtype: 'uniRadiogroup',
                                items: [
                                    {boxLabel:'예'       , name:'FOREIGN_SKILL_YN', inputValue:'Y'},
                                    {boxLabel:'아니오' , name:'FOREIGN_SKILL_YN', inputValue:'N', checked:true}
                                ]  
                            },{
                                fieldLabel: '병역계급',
                                name:'ARMY_GRADE',
                                xtype: 'uniCombobox',
                                comboType: 'AU', 
                                comboCode: 'H018'
                            },{
                                fieldLabel: '거주구분',
                                name:'LIVE_GUBUN',
                                xtype: 'uniCombobox',
                                comboType: 'AU', 
                                comboCode: 'H007'
                            },{
                                fieldLabel: '출입카드NO',
                                name:'CARD_NUM'
                            },{
                                fieldLabel: '병역병과',
                                name:'ARMY_MAJOR',
                                xtype: 'uniCombobox',
                                comboType: 'AU', 
                                comboCode: 'H019'
                            },{
                                fieldLabel: '복무기간',
                                xtype: 'uniDateRangefield',
                                startFieldName: 'ARMY_STRT_DATE',
                                endFieldName: 'ARMY_LAST_DATE',
                                tdAttrs:{width: 500},
                                width: 500,
                                colspan:2
                            },{
                                fieldLabel: '기타사항',
                                name:'REMARK'
                            },{
                                fieldLabel: '기타주소',
                                name:'ORI_ADDR',
                                colspan: 3,
                                width:500
                            }
                            /*,{
                                fieldLabel: '장애인여부',
                                name:'DEFORM_YN', 
                                xtype: 'uniRadiogroup',
                                items: [
                                    {boxLabel:'예'       , name:'DEFORM_YN', inputValue:'Y'},
                                    {boxLabel:'아니오' , name:'DEFORM_YN', inputValue:'N', checked:true}
                                ],  
                                width:260  
                            }*/
                            /*,{
			        	  	 	fieldLabel: '세대주여부',
							 	name:'HOUSEHOLDER_YN', 
							 	xtype: 'uniRadiogroup',
							 	items: [
				 					{boxLabel:'예'		, name:'HOUSEHOLDER_YN', inputValue:'1', checked:true},
				 					{boxLabel:'아니오'	, name:'HOUSEHOLDER_YN', inputValue:'2'}
				  				],	
							 	width:260   
							}*//*,{
			        	  	 	fieldLabel: '배우자공제',
							 	name:'SPOUSE' , 
							 	xtype: 'uniRadiogroup',
								width:260,
	 							items: [
				 					{boxLabel:'유', name:'SPOUSE', inputValue:'Y', checked:true},
				 					{boxLabel:'무', name:'SPOUSE', inputValue:'N'}
				  				],
				  				listeners:{
	        						change: function(field,  newValue, oldValue, eOpts )	{
	        							var formPanel = this.up('#etcForm');
	        							if(newValue.SPOUSE == "Y")	{
		        							var chkValue = formPanel.getValue('ONE_PARENT').ONE_PARENT
		        							if(!Ext.isEmpty(chkValue))	{
		        								if(chkValue == 'Y')	{
		        									alert('배우자가 있는 경우에는 한부모 소득공제를 받을 수 없습니다');
		        									formPanel.setValue('ONE_PARENT','N');
		        								}
		        							}		
	        							}
	        						}
	        					}
							}*//*,{
			        	  	 	fieldLabel: '부녀자세대공제',
							 	name:'WOMAN' , 
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260,
							 	items: [
				 					{boxLabel:'한다', name:'WOMAN', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다', name:'WOMAN', inputValue:'N'}
				  				],
				  				listeners:{
	        						change: function(field,  newValue, oldValue, eOpts )	{
	        							var formPanel = this.up('#etcForm');
	        							if(newValue.WOMAN == "Y")	{
		        							var chkValue = formPanel.getValue('ONE_PARENT').ONE_PARENT
		        							if(!Ext.isEmpty(chkValue))	{
		        								if(chkValue == 'Y')	{
		        									alert('한부모 소득공제를 받을 경우 부녀자 세대공제를 받을 수 없습니다.');
		        									formPanel.setValue('WOMAN','N');
		        								}
		        							}		
	        							}
	        						}
	        					}  
							}*//*,{
			        	  	 	fieldLabel: '한부모소득공제',
							 	name:'ONE_PARENT' , 
							 	xtype: 'uniRadiogroup',
							 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
							 	width:260 ,
							 	items: [
				 					{boxLabel:'한다', name:'ONE_PARENT', inputValue:'Y', checked:true},
				 					{boxLabel:'안한다', name:'ONE_PARENT', inputValue:'N'}
				  				],
				  				listeners:{
	        						change: function(field,  newValue, oldValue, eOpts )	{
	        							var formPanel = this.up('#etcForm');
	        							if(newValue.ONE_PARENT == "Y")	{
		        							var chkValue = formPanel.getValue('SPOUSE').SPOUSE;
		        							var chkValue2 = formPanel.getValue('WOMAN').WOMAN
		        							if(!Ext.isEmpty(chkValue))	{
		        								if(chkValue == 'Y')	{
		        									alert('배우자가 있는 경우에는 한부모 소득공제를 받을 수 없습니다');
		        									formPanel.setValue('ONE_PARENT','N');
		        								}
		        							}
		        							if(!Ext.isEmpty(chkValue2))	{
		        								if(chkValue2 == 'Y')	{
		        									alert('부녀자 세대공제를 받을 경우 한부모 소득공제를 받을 수 없습니다');
		        									formPanel.setValue('ONE_PARENT','N');
		        								}
		        							}		
	        							}
	        						}
	        					}
							}*//*,{
			        	  	 	fieldLabel: '부양가족수(배우자,본인제외)',
							 	name:'SUPP_AGED_NUM' ,
							 	xtype:'uniNumberfield',
							 	value:0,
							 	labelWidth:170,
					            width: 260
							}*//*,{
			        	  	 	fieldLabel: '20세이하자녀수(다자녀)',
							 	name:'CHILD_20_NUM' ,
							 	xtype:'uniNumberfield',
							 	value:0
							}*//*,{
			        	  	 	fieldLabel: '장애인수(본인포함)',
							 	name:'DEFORM_NUM' ,
							 	xtype:'uniNumberfield',
							 	value:0
							}*//*,{
			        	  	 	fieldLabel: '대사우사용여부',
							 	name:'' ,
							 	colspan: 2
							},{
			        	  	 	fieldLabel: '경로우대자수(70세이상)',
							 	name:'AGED_NUM70' ,
							 	xtype:'uniNumberfield',
							 	value:0
							}*//*,{
			        	  	 	fieldLabel: '경로우대자수(70세미만)',
							 	name:'AGED_NUM' ,
							 	xtype:'uniNumberfield',
							 	value:0
							}*//*,{
			        	  	 	fieldLabel: '자녀양육수(6세이하)',
							 	name:'BRING_CHILD_NUM' ,
							 	xtype:'uniNumberfield',
							 	value:0
							}*//*,{
			        	  	 	fieldLabel: '대사우사용여부',
							 	name:'ESS_USE_YN', 
							 	xtype: 'uniRadiogroup',
								items: [
				 					{boxLabel:'예'		, name:'ESS_USE_YN', inputValue:'Y', checked:true},
				 					{boxLabel:'아니오'	, name:'ESS_USE_YN', inputValue:'N'}
				  				]
							}*/
                            /*,{
							 	xtype: 'button',
								text:'대사우 비빌번호 초기화',
								width:'150',
								tdAttrs:{align:'center'},
								handler: function()	{
									
								}
							}*//*,{
			        	  	 	fieldLabel: '자녀양육수(6세이하)',
							 	name:'BRING_CHILD_NUM' ,
							 	xtype:'uniNumberfield', 
							 	allowBlank:false
							},{
			        	  	 	fieldLabel: 'ESS_PASSWORD',
							 	name:'ESS_PASSWORD' ,
							 	hidden:true
							},{
			        	  	 	fieldLabel: '건강보험등급',
							 	name:'MED_GRADE' ,
							 	hidden:true
							}*/
			        	],
					listeners:{
						uniOnChange:function( form ) {
							if(form.isDirty())	{
								UniAppManager.setToolbarButtons('save', true);
							}else {
								UniAppManager.setToolbarButtons('save', false);
							}
						}
					},
					/**
					 * 부양가족수 체크 함수
					 */
					chkSupportNum: function()	{
						var r = true;
						var me = this;
						var sum = 0;
						sum = me.getValue('CHILD_20_NUM') + me.getValue('DEFORM_NUM') + me.getValue('AGED_NUM70') + me.getValue('AGED_NUM');//DEFORM_YN  장애인여부
						suppNum = me.getValue('SUPP_AGED_NUM')
						if(suppNum < sum)	{
							if(!confirm('20세이하자녀수와 장애인수, 경로우대자수의 합이 부양가족수 보다 많습니다. 그래도 저장하시겠습니까?'))	{
								r = false;
							}
						}
						
						if(!Ext.isNumber(me.getValue('CHILD_20_NUM')) && Unilite.nvl(me.getValue('CHILD_20_NUM'), '') == '')	{
							alert('해당 사항이 없는 경우 0을 입력하세요');
							me.getField('CHILD_20_NUM').focus();
							r = false;
						}
						
						if(!Ext.isNumber(me.getValue('DEFORM_NUM')) &&  Unilite.nvl(me.getValue('DEFORM_NUM'), '') == '')	{
							alert('해당 사항이 없는 경우 0을 입력하세요');
							me.getField('DEFORM_NUM').focus();
							r = false;
						}
						
						if(!Ext.isNumber(me.getValue('AGED_NUM70')) &&  Unilite.nvl(me.getValue('AGED_NUM70'), '') == '')	{
							alert('해당 사항이 없는 경우 0을 입력하세요');
							me.getField('AGED_NUM70').focus();
							r = false;
						}
						
						if(!Ext.isNumber(me.getValue('AGED_NUM')) &&  Unilite.nvl(me.getValue('AGED_NUM'), '') == '')	{
							alert('해당 사항이 없는 경우 0을 입력하세요');
							me.getField('AGED_NUM').focus();
							r = false;
						}
						return r;						
					}
        		}]
        		,loadData:function(personNum)	{
        			var etcForm = this.down('#etcForm');
					etcForm.uniOpt.inLoading = true; 
					etcForm.clearForm();
					etcForm.getForm().load(
						{
							params : {'PERSON_NUMB':personNum},
							success: function(form, action)	{
								 	etcForm.uniOpt.inLoading = false; 
								 },
							failure: function(form, action)	{
								 	etcForm.uniOpt.inLoading = false; 
								 }
						}
					);
				}
		};