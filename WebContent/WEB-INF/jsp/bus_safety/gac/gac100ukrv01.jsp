<%@page language="java" contentType="text/html; charset=utf-8"%>
var detailAccident =	 {		         
	        title: '기본정보',	
	        itemId: 'detailAccident',
	        id:'gac100ukrv01Form',
			layout:{type:'vbox', align:'stretch'},
			autoScroll:true,	
			xtype:'uniDetailForm',			
			defaultType: 'fieldset',
			flex:1,
			padding:0,
			
			bodyCls: 'human-panel-form-background',
			disabled: false,
			api:{
				'load' : 'gac100ukrvService.select',
				'submit' :'gac100ukrvService.insert'
			},
	        items:[ 
	        	{
	        		title:'기본정보',
	        		defaultType: 'uniTextfield',
	        		itemId: 'masterForm',
	        		disabled: false,
	        		bodyCls: 'human-panel-form-background',			        
	        		layout: {type:'uniTable', columns:'5'},
	        		margin:'10 10 0 10',
	        		padding:'0',
	        		defaults: {
	        					width:200,
	        					labelWidth:80
	        		},
	        		items: [
	        			{
	            	  	 	fieldLabel: '사고번호',
						 	name:'ACCIDENT_NUM',
							hidden:true
						},
	        			{
	            	  	 	fieldLabel: '사업장',
						 	name:'DIV_CODE',
							hidden:true
						},
	            		{
	            	  	 	fieldLabel: '사고일시',
						 	name:'ACCIDENT_DATE',
						 	xtype:'uniDatefield',
						 	allowBlank:false,
						 	listeners:{
						 		validitychange:function(field, isValid, eOpts)	{
						 			var form = Ext.getCmp('gac100ukrv01Form');
						 			if(isValid)	{							 			
							 			form.getForm().findField('DRIVER_CODE').setReadOnly(false);
							 			form.getForm().findField('DRIVER_NAME').setReadOnly(false);
						 			}else {
						 				var driverCode = form.getForm().findField('DRIVER_CODE');
						 				var driverName = form.getForm().findField('DRIVER_NAME');
						 				driverCode.setValue('');
						 				driverName.setValue('');						 				
						 				driverCode.setReadOnly(true);
							 			driverName.setReadOnly(true);
						 			}
						 		}
						 	}
						},{
	            	  	 	fieldLabel: '사고시간',
						 	name: 'ACCIDENT_TIME',
						 	hideLabel:true,
						 	width:100,
						 	allowBlank:false,
							listeners:{
								blur: function (field, The, eOpts )	{
									var form = Ext.getCmp('gac100ukrv01Form');
									form.chkTime(form.getValue('ACCIDENT_DATE'), field, field.getValue());
								}
							}
						},{
	            	  	 	fieldLabel: '접수일시',
						 	name:'REGIST_DATE',
						 	xtype:'uniDatefield',
						 	allowBlank:false
						},{
	            	  	 	fieldLabel: '접수시간',
						 	name: 'REGIST_TIME',
						 	hideLabel:true,
						 	width:100,
						 	allowBlank:false,
							listeners:{
								blur: function (field, The, eOpts )	{
									var form = Ext.getCmp('gac100ukrv01Form');
									form.chkTime(form.getValue('REGIST_DATE'), field, field.getValue());
								}
							}
						},{
	            	  	 	fieldLabel: '접수자',
						 	name:'REGIST_PERSON'						 	
						},
						Unilite.popup('VEHICLE',
							 {
							 	itemId:'vehicle',
							 	extParam:{'DIV_CODE': UserInfo.divCode},
								colspan:2	,
						 		allowBlank:false						  
							 }
						),{
	            	  	 	fieldLabel: '노선',
						 	name:'ROUTE_CODE',
						 	xtype: 'uniCombobox',
							store: Ext.data.StoreManager.lookup('routeStore'),
							colspan:2
						},{
	            	  	 	fieldLabel: '접수자구분',
						 	name: 'REGIST_PERSON_TYPE' , 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'GA01'									 	
						},
						Unilite.popup('DRIVER',
							 {
							 	fieldLabel:'운전자',
							 	itemId:'driver',
							 	extParam:{'DIV_CODE': UserInfo.divCode},
								colspan:2,
						 		allowBlank:false	,
						 		readOnly:true,
						 		listeners:{
						 			'onSelected': {
						                    fn: function(records, type  ){
						                    	var form = Ext.getCmp('gac100ukrv01Form');
						                    	form.setValue('KOR_ADDR',records[0]['KOR_ADDR']);
						                    	form.setValue('TELEPHON',records[0]['TELEPHON']);
						                    	form.setValue('MOBILE_PHONE',records[0]['PHONE_NO']);
						                    	form.setValue('REPRE_NUM',records[0]['REPRE_NUM']);
						                    	
						                    	var birthYear = records[0]['REPRE_NUM'].substring(0,2);
						                    	if(birthYear > '19' )	birthYear = '19'+birthYear;
						                    	else birthYear = '20'+birthYear;
						                    	
						                    	form.setValue('AGE', (form.getValue('ACCIDENT_DATE').getUTCFullYear() - parseInt(birthYear)));
						                    	form.setValue('LICENSE_NO',records[0]['LICENSE_NO']);
						                    	var empPeriod = "";
						                    	if(records[0]['RETR_DATE'] == '00000000' )	empPeriod = Ext.Date.format(UniDate.extParseDate(records[0]['JOIN_DATE']),'Y.m.d') + '~ 재직중'
						                    	else empPeriod = UniDate.extParseDate(records[0]['JOIN_DATE'])+'~' + records[0]['RETR_DATE']
						                    	form.setValue('EMPLOYMENT_PERIOD',empPeriod);
						                    },
						                    scope: this
						                
						 			},
					               'onClear' : function(type){
					               			var form = Ext.getCmp('gac100ukrv01Form');
					               			form.setValue('KOR_ADDR','');
					                    	form.setValue('TELEPHON','');
					                    	form.setValue('MOBILE_PHONE','');
					                    	form.setValue('REPRE_NUM','');
					                    	
					                    	form.setValue('AGE', '');
					                    	form.setValue('LICENSE_NO','');
					                    	form.setValue('EMPLOYMENT_PERIOD','');
					               }
						 		}
						 		
							 }
						),{
	            	  	 	fieldLabel: '주민번호',
						 	name:'REPRE_NUM'   ,
							colspan:2,
							readOnly:true
						},{
	            	  	 	fieldLabel: '사고유형',
						 	name:'ACCIDENT_TYPE', 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'GA05'			
						},{
	            	  	 	fieldLabel: '주소',
						 	name:'KOR_ADDR',
							colspan:4, 
							width:500,
							readOnly:true
						},{
	            	  	 	fieldLabel: '사고구분',
						 	name:'ACCIDENT_DIV' , 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'GA04'			
						},{
	            	  	 	fieldLabel: '전화번호',
						 	name:'TELEPHON' ,
							colspan:2,
							readOnly:true
						}
						,{
	            	  	 	fieldLabel: '면허번호',
						 	name: 'LICENSE_NO' ,
							colspan:2,
							readOnly:true
						},{
	            	  	 	fieldLabel: '근무기간',
						 	name:'EMPLOYMENT_PERIOD',
							readOnly:true
						},{
	            	  	 	fieldLabel: '휴대폰',
						 	name:'MOBILE_PHONE' ,
							colspan:2
						},{
	            	  	 	fieldLabel: '연령',
						 	name:'AGE',
							colspan:2,
							readOnly:true
						},{
	            	  	 	fieldLabel: '경력',
						 	name:'EXPERIENCE_PERIOD' 
						},{
	            	  	 	fieldLabel: '날씨',
						 	name:'WHEATHER', 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'GA02',
							colspan:2
						},{
	            	  	 	fieldLabel: '노면',
						 	name:'SURFACE_ROAD'  , 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'GA03',
							colspan:3 
						},{
	            	  	 	fieldLabel: '처리구분',
						 	name:'MANAGE_DIV', 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'GA23',
							colspan:2
						},{
	            	  	 	fieldLabel: '처리일',
						 	name:'MANAGE_DATE',
						 	xtype:'uniDatefield',
							colspan:2
						},{
	            	  	 	fieldLabel: '결재일',
						 	name:'APPROVAL_DATE',
						 	xtype:'uniDatefield'
						}
						]
	    			},{
	    				title:'상세내용',
		        		defaultType: 'uniTextfield',
		        		itemId: 'detailForm',
		        		disabled: false,
		        		bodyCls: 'human-panel-form-background',			        
		        		layout: {type:'uniTable', columns:'5'},
		        		margin:'10 10 0 10',
		        		padding:'0',
		        		defaults: {
		        					width:200,
		        					labelWidth:80
		        		},
		        		items: [
		            		{
		            	  	 	fieldLabel: '도로종류',
							 	name:'ROAD_DIV', 
						 		xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'GA06'
							},{
		            	  	 	xtype: 'component',
							 	html:"&nbsp;",
							 	width:100
							},{
		            	  	 	fieldLabel: '도로형태',
							 	name:'ROAD_TYPE', 
						 		xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'GA07'
							},{
		            	  	 	xtype: 'component',
							 	html:"&nbsp;",
							 	width:100
							},{
		            	  	 	fieldLabel: '발생원인',
							 	name:'ACCIDENT_CAUSE', 
						 		xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'GA09'
							},{
		            	  	 	fieldLabel: '사고구간',
							 	name:'ACCICENT_COURSE', 
						 		xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'GA08',
								colspan:2
							},{
		            	  	 	fieldLabel: '운전자과실',
							 	name:'DRIVER_FAULT', 
						 		xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'GA11',
								colspan:2
							},{
		            	  	 	fieldLabel: '상대방과실',
							 	name:'OTHER_FAULT', 
						 		xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'GA11'
							},{
		            	  	 	fieldLabel: '사고장소',
							 	name:'ACCIDENT_PLACE',
							 	width: 500,
							 	colspan:4
							},{
		            	  	 	fieldLabel: '장소구분',
							 	name:'PLACE_TYPE', 
						 		xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'GA10'
							},{
		            	  	 	fieldLabel: '기타',
							 	name:'ACCIDENT_REPORT_TYPE',
								colspan:2
							},{
		            	  	 	fieldLabel: '보험사',
							 	name:'INSUREANCE_COMPANY',
								colspan:2
							},{
		            	  	 	fieldLabel: '관할서',
							 	name:'POLICE_OFFICE'
							},{
		            	  	 	fieldLabel: '영업소',
							 	name:'OFFICE_CODE',
								colspan:2
							},{
		            	  	 	fieldLabel: '사고번호',
							 	name:'POLICE_ACC_NUM',
								colspan:2
							},{
		            	  	 	fieldLabel: '보고서번호',
							 	name:'POLICE_REPORT_NUM'
							},{
		            	  	 	fieldLabel: '담당경찰',
							 	name:'POLICE_INCHARGE',
								colspan:2
							},{
		            	  	 	fieldLabel: '사건번호',
							 	name:'CASE_NUM',
								colspan:2
							},{
		            	  	 	fieldLabel: '팀',
							 	name:'TEAM'
							},{
		            	  	 	xtype: 'component',
							 	html:"&nbsp;",
							 	colspan:4
							},{
		            	  	 	fieldLabel: '특별교육',
							 	name:'SPECIAL_EDU_YN', 
						 		xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'A020'								
							},{
		            	  	 	fieldLabel: '사고경위',
							 	name:'textarea',
							 	xtype:'textarea',
							 	colspan:5,
							 	height:50,
							 	width:800
							},{
		            	  	 	fieldLabel: '참고사항',
							 	name:'COMMENTS',
							 	xtype:'textarea',
							 	colspan:5,
							 	height:30,
							 	width:800
							},{
		            	  	 	fieldLabel: '특기사항',
							 	name:'SPECIAL_FEATURE',
							 	colspan:5,
							 	width:800
							}
						]
		    		},{
		    			title:'접보',
		        		defaultType: 'uniTextfield',
		        		itemId: 'insuranceForm',
		        		disabled: false,
		        		bodyCls: 'human-panel-form-background',			        
		        		layout: {type:'uniTable', columns:'5'},
		        		margin:'10 10 0 10',
		        		padding:'0',
		        		defaults: {
		        					width:200,
		        					labelWidth:80
		        		},
		        		items: [
		            		{
		            	  	 	fieldLabel: '접보번호',
							 	name:'CLAIM_NO'
							},{
		            	  	 	xtype: 'component',
							 	html:"&nbsp;",
							 	width:100
							},{
		            	  	 	fieldLabel: '접수일시',
							 	name:'CLAIM_DATE',
							 	xtype:'uniDatefield'
							},{
		            	  	 	fieldLabel: '접수시간',
							 	name:'CLAIM_TIME',
							 	hideLabel:true,
							 	width:100,
								listeners:{
									blur: function (field, The, eOpts )	{
										var form = Ext.getCmp('gac100ukrv01Form');
										form.chkTime(form.getValue('CLAIM_DATE'), field, field.getValue());
									}
								}
							},{
		            	  	 	fieldLabel: '접수자',
							 	name:'CLAIM_PERSON'
							},{
		            	  	 	fieldLabel: '대인담당자',
							 	name:'VICTIM_INS_PRSN',
							 	colspan:2
							},{
		            	  	 	fieldLabel: '대물담당자',
							 	name:'PROPERTY_INS_PRSN',
							 	colspan:2
							},{
		            	  	 	fieldLabel: '통보자',
							 	name:'INFORM_PRSN'
							},{
		            	  	 	fieldLabel: '전화번호',
							 	name:'INFORM_INS_TEL',
							 	colspan:5
							}
						]
		    		}
		],
		chkTime: function(date, field, newValue)	{
			var me = Ext.getCmp('gac100ukrv01Form');;
			if(!date)	{
				alert("날짜를 입력해 주세요.");
				return;
			}
			var val = newValue.replace(/:/g, "");
			if(val.length == 4)	{
				if(!Ext.Date.isValid(date.getFullYear(),date.getMonth()+1,date.getDate(), val.substring(0,2), val.substring(2,4)))	{
					me.setValue(field.getName(), '');
					alert("시간을 정확히 입력해 주세요."+'\n'+'예: 06:00:00');
					return;
				}
				val = val.substring(0,2)+":"+val.substring(2,4);
				me.setValue(field.getName(), val);
			} else if(val.length == 6){
				if(!Ext.Date.isValid(date.getFullYear(),date.getMonth()+1,date.getDate(), val.substring(0,2), val.substring(2,4), val.substring(4,6)))	{
					me.setValue(field.getName(), '');
					alert("시간을 정확히 입력해 주세요."+'\n'+'예: 06:00:00');
					return;
				}
				val = val.substring(0,2)+":"+val.substring(2,4)+":"+val.substring(4,6);						
				me.setValue(field.getName(), val);
			} else  if(val.length != 0) {
				me.setValue(field.getName(), '');
				alert("00:00:00(시:분:초) 형식으로 입력하거나 숫자만 입력해 주세요.");
				
			}					
		},
		listeners:{
			uniOnChange:function( form, dirty, eOpts ) {
				console.log("onDirtyChange");
				UniAppManager.setToolbarButtons('save', true);
			}
		},
		loadData:function(param)	{
			var me = Ext.getCmp('gac100ukrv01Form');;
			me.getForm().wasDirty = false;
			me.resetDirtyStatus();
			
			me.uniOpt.inLoading = true;
			me.getEl().mask();
			me.getForm().load({
					params: param,
					success:function(form, action)	{
						me.uniOpt.inLoading = false;
						me.getEl().unmask();
						form.findField('DRIVER_CODE').setReadOnly(false);
						form.findField('DRIVER_NAME').setReadOnly(false);
					}
			})
		},
		saveData:function()	{
			var me = Ext.getCmp('gac100ukrv01Form');
			if(me.isDirty())		{
				me.setValue('DIV_CODE',panelSearch.getValue("DIV_CODE"));
				if(me.isValid())	{
					me.getEl().mask();
					me.getForm().submit({
						success:function(form, action)	{
							me.uniOpt.inLoading = false;
							me.getEl().unmask();
							if(action.result.success === true)	{
								UniAppManager.updateStatus(Msg.sMB011);
								UniAppManager.setToolbarButtons('save', false);
								me.getForm().wasDirty = false;
								me.resetDirtyStatus();
								searchPanelStore.loadStoreRecords(action.result.ACCIDENT_NUM);
							}
						}
					})
				} else {
					var invalid = me.getForm().getFields().filterBy(function(field) {
																		return !field.validate();
																	});				   															
	   				if(invalid.length > 0) {
						r=false;
	   					var labelText = ''
	   	
						if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
	   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					}
				}
			}
		},
		newData:function()	{
			var me = this;
			if(me.isDirty())	{
				if(confirm('저장할 내용이 있습니다. 저장하시겠습니까?')){
					if(AppManager.app.findInvalidField(me))	{
						AppManager.app.onSaveDataButtonDown();
					}
					return;
				}
			}
			me.clearForm();
			me.setDisabled( false );
 			me.getForm().findField('DRIVER_CODE').setReadOnly(true);
 			me.getForm().findField('DRIVER_NAME').setReadOnly(true);
			masterGrid.getSelectionModel().deselect(masterGrid.getSelectedRecords());
		},
		deleteData:function()	{
			masterGrid.deleteSelectedRow();	
		},
		rejectChanges:function()	{
			var me = Ext.getCmp('gac100ukrv01Form');
			me.clearForm();
		}
		
	};