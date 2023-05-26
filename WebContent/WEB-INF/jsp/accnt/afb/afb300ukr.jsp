<%@page language="java" contentType="text/html; charset=utf-8"%> 
	<t:appConfig pgmId="afb300ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A128" /> <!-- 예산과목구분 -->
</t:appConfig>
<script type="text/javascript" >

var SAVE_FLAG = '';
var onDataCopy = '';
var subFormWindow; // 전년도자료복사

function appMain() {
	
	var panelResult = Unilite.createForm('searchForm', {	
		disabled :false,
        layout: {type: 'uniTable', columns: 2,
        	tableAttrs: {height:40/*style: 'border : 1px solid #ced9e7;',*//*, width: '100%'*/}
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*,align : 'center'*/}
        
        /*, tdAttrs: {valign:'top'}*/},
        padding: '50 0 0 50',
	    items :[{
            xtype: 'uniYearField',
            name: 'AC_YYYY',
            fieldLabel: '사업년도',
            value: new Date().getFullYear(),
            fieldStyle: 'text-align: center;',
            labelWidth: 60,
            allowBlank:false,
            tdAttrs: {align : 'left'},
			listeners: {
				specialkey: function(field, event){
					if(event.getKey() == event.ENTER){
						if(detailForm.getField("CODE_LEVEL").readOnly == true){
							detailForm.getField('CTL_UNIT').focus();   
						}else{
							detailForm.getField('CODE_LEVEL').focus();   
						}
					}
				}
			}
           
         },{
    		xtype: 'button',
    		text: '전년도 자료복사',	
    		margin: '0 0 0 0',
//    		width: 60,
    		tdAttrs: {width: 335, align : 'right'},
			handler : function() {
				if(!UniAppManager.app.checkForNewDetail()){
					return false;
				}else{
					openSubFormWindow();
				}
			}
    	}],		
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
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
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});
		
	var detailForm = Unilite.createSearchForm('resultForm',{
		region: 'center', 
		disabled :false,
        layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
        padding: '50 0 0 50',
	    items :[/*{
            xtype: 'uniYearField',
            name: 'AC_YYYY',
            fieldLabel: '사업년도',
            value: new Date().getFullYear(),
            fieldStyle: 'text-align: center;',
            colspan:2,
            allowBlank:false
         },*/{
			title:'예산코드 설정',
	    	xtype: 'fieldset',
	    	padding: '20 20 20 20',
	    	margin: '0 0 0 0',
		    defaults: {readOnly: false, xtype: 'uniNumberfield',enforceMaxLength: true},
		    layout : {type: 'uniTable' , columns: 2,
		    	tableAttrs: {width: '100%'},
				tdAttrs: {align : 'center'}
		    },
	    	items: [{
	    		fieldLabel: 'Level',
		 		name:'CODE_LEVEL',
		 		width:120,
	            maxLength:1,
		 		holdable: 'hold',
		 		allowBlank:false
	    	},{
	            xtype: 'container',
	            defaultType: 'uniNumberfield',
	            layout: {type: 'hbox', align:'stretch'},
	            defaults : {enforceMaxLength: true},
	            width:295,
	            items:[{
	            	 
		    		xtype: 'component',  
		    		html:'자릿수&nbsp;',
		    		style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
	            },{
	            	fieldLabel:'1번 자릿수', 
	            	hideLabel : true,
	                name: 'LEVEL_NUM1', 
	                width:25,
	                maxLength:2
	            },{
	            	fieldLabel:'2번 자릿수', 
	            	hideLabel : true,
	                name: 'LEVEL_NUM2', 
	                width:25,
	                maxLength:2
	            },{
	            	fieldLabel:'3번 자릿수', 
	            	hideLabel : true,
	                name: 'LEVEL_NUM3', 
	                width:25,
	                maxLength:2
	            },{
	            	fieldLabel:'4번 자릿수', 
	            	hideLabel : true,
	                name: 'LEVEL_NUM4', 
	                width:25,
	                maxLength:2
	            },{
	            	fieldLabel:'5번 자릿수', 
	            	hideLabel : true,
	                name: 'LEVEL_NUM5', 
	                width:25,
	                maxLength:2
	            },{
	            	fieldLabel:'6번 자릿수', 
	            	hideLabel : true,
	                name: 'LEVEL_NUM6', 
	                width:25,
	                maxLength:2
	            },{
	            	fieldLabel:'7번 자릿수', 
	            	hideLabel : true,
	                name: 'LEVEL_NUM7', 
	                width:25,
	                maxLength:2
	            },{
	            	fieldLabel:'8번 자릿수', 
	            	hideLabel : true,
	                name: 'LEVEL_NUM8', 
	                width:25,
	                maxLength:2
	            }]
	        },{
	        	xtype: 'uniTextfield',
                name: 'EXIST_YN', 
                width:80,
                hidden:true
            }]
		},/*{
    		xtype: 'button',
    		text: '전년도 자료복사',	
    		margin: '0 0 5 150',
//    		width: 60,
			handler : function() {
				if(!UniAppManager.app.checkForNewDetail()){
					return false;
				}else{
				
				
				}
			}
    	},*/{
			title:'예산기본 설정',
	    	xtype: 'fieldset',
	    	padding: '20 20 20 20',
	    	margin: '0 0 0 0',
		    defaults: {readOnly: false, enforceMaxLength: true},
		    layout : {type: 'uniTable' , columns: 1
//			,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		    },
	    	items: [{ 
	    		xtype: 'component',  
	    		html:'&nbsp;예산과목의 단위는 공통코드' +"'A128'"+'에서 먼저 정의하고 화면을 닫고 다시 실행한다.',
	    		style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
//	    		colspan:2
	    	},{
			   xtype: 'container',
			   layout: {type : 'uniTable', columns : 2},
			   width:500,
			   defaults : {enforceMaxLength: true},
//			   tdAttrs: {align : 'left'},
			   items :[{
					fieldLabel:'예산통제단위는',
					name: 'CTL_UNIT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'A128',
//					holdable: 'hold',
					allowBlank:false,
					tdAttrs: {width: 250}
				},{ 
		    		xtype: 'component',  
		    		html:'이다',
		    		tdAttrs: {align : 'left'}
				}]
	    	},{
			   xtype: 'container',
			   layout: {type : 'uniTable', columns : 2},
			   width:500,
			   defaults : {enforceMaxLength: true},
//			   tdAttrs: {align : 'left'},
			   items :[{
	    		fieldLabel:'예산전용단위는',
				name: 'CONV_UNIT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A128',
//				holdable: 'hold',
				allowBlank:false,
				tdAttrs: {width: 250}
	    	},{ 
	    		xtype: 'component',  
	    		html:'이다',
	    		tdAttrs: {align : 'left'}
	    	}]
	    	},{
				xtype: 'radiogroup',		            		
				id: 'rdoSelect',
				fieldLabel:'예산전용/배정을 입력하면',
//				colspan:2,
				labelWidth:148,
				width:500,
				items: [{
					boxLabel: '승인해야 예산이 반영된다.', 
					name: 'DIVERT_AGREE_YN',
					inputValue: '1',
					checked: true  
				},{
					boxLabel : '승인 없이 예산이 반영된다.', 
					name: 'DIVERT_AGREE_YN',
					inputValue: '2'
				}]
	    	},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 4
//					,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//					tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
				},
//			   width:600,
				defaults : {enforceMaxLength: true},
				items :[{
					fieldLabel:'예산확정이 안되어 통제할 수 없는 월이 존재하므로', 
					xtype: 'uniNumberfield',
					name: 'FR_CTL_MONTH',
					maxLength:2,
					labelWidth:282,
					width:310,
					tdAttrs: {align : 'left'},
					allowBlank:false,
					listeners: {
		        		blur: function(field, event, eOpts )	{
		        			if(field.originalValue == field.lastValue){
								UniAppManager.setToolbarButtons('save', false);
		        			}
		        		}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
				    xtype: 'uniNumberfield',
				    name: 'TO_CTL_MONTH', 
				    maxLength:2,
				    width:23,
				     listeners: {
				     	blur: function(field, event, eOpts )	{
							if(field.originalValue == field.lastValue){
								UniAppManager.setToolbarButtons('save', false);
		        			}		        		},
						specialkey: function(field, event){
							if(event.getKey() == event.ENTER){
		//						UniAppManager.app.onQueryButtonDown();
								panelResult.getField('AC_YYYY').focus();   
							}
						}
					}
				},{ 
		    		xtype: 'component',  
		    		html:'월 범위는 통제에서 제외시킨다.'
		    	}]
			}]
		}],
    	api: {
    		load: 'afb300ukrService.selectForm',
	 		submit: 'afb300ukrService.syncMaster'	
		},
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {				
				UniAppManager.setToolbarButtons('save', true);
			},
			afterrender:function()	{
				UniAppManager.app.onQueryButtonDown();
			}
		},	
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
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
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});
	var subForm = Unilite.createForm('subForm',{	//전년도자료복사
		padding:'0 0 0 0',
	    title:'전년도자료복사',
		disabled: false,
		flex: 1.5,
		bodyPadding: 10,
		region: 'center',
		layout: {
			type: 'uniTable',
			columns:1,
			tableAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width: '100%'},
			tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ align : 'center'}
		},
		items: [{
            xtype: 'uniYearField',
            name: 'AC_YYYY_THIS',
            fieldLabel: '원본사업년도',
            fieldStyle: 'text-align: center;',
            labelWidth: 80,
            allowBlank:false
         },{
            xtype: 'uniYearField',
            name: 'AC_YYYY_NEXT',
            fieldLabel: '대상사업년도',
            fieldStyle: 'text-align: center;',
            labelWidth: 80,
            allowBlank:false
         }]
	});
	
	
	function openSubFormWindow() {			//전년도자료복사
		if(!subFormWindow) {
			subFormWindow = Ext.create('widget.uniDetailWindow', {
	            title: '전년도자료복사',
	            header: {
        			titleAlign: 'center'
				},
	            width: 400,
	            layout: {type:'vbox', align:'stretch'}, 
	            items: [subForm], 
	           	dockedItems: [{
					xtype: 'toolbar',
					dock: 'bottom',
					items: [
						'->',{ xtype: 'button', text: '실행',
							handler: function() {
								var param = {"COMP_CODE": UserInfo.compCode,
										"AC_YYYY_NEXT": subForm.getValue('AC_YYYY_NEXT')
								};
								afb300ukrService.selectCheckDataCopy1(param, function(provider, response)	{
									if(!Ext.isEmpty(provider)){
										if(confirm(Msg.fsbMsgA0194)) {
											var param = {"COMP_CODE": UserInfo.compCode,
												"AC_YYYY_NEXT": subForm.getValue('AC_YYYY_NEXT')
											};
											afb300ukrService.selectCheckDataCopy2(param, function(provider, response)	{
												if(!Ext.isEmpty(provider)){
													Ext.Msg.alert('확인',Msg.fsbMsgA0195);
												}else{
													onDataCopy = 'on';	
													UniAppManager.app.onSaveDataButtonDown();
													subFormWindow.hide();
												}
											})
										}
									}else{
										onDataCopy = 'on';	
										UniAppManager.app.onSaveDataButtonDown();	
										subFormWindow.hide();
									}
								})
							
							
							
								
							}
						},
						{ xtype: 'button', text: '닫기',
							handler: function() {
								subFormWindow.close();
							}
						}
					]
				}],
	            /* bbar: [
	              
				  { xtype: 'button',buttonAlign : 'center',closable : true, text: 'Button 1' }
				],*/
				listeners : {
					show: function( panel, eOpts )	{
						subForm.setValue('AC_YYYY_THIS',panelResult.getValue('AC_YYYY'));
						subForm.setValue('AC_YYYY_NEXT',panelResult.getValue('AC_YYYY') + 1);
						subForm.getField('AC_YYYY_THIS').focus();
						
					},
					beforehide: function(me, eOpt)	{
//						                							
					},
					 beforeclose: function( panel, eOpts )	{
					 
		 			}
	            }		
			})
		}
		subFormWindow.center();
		subFormWindow.show();
	}
    Unilite.Main( {
		items:[panelResult,detailForm],
		id  : 'afb300ukrApp',
		fnInitBinding : function() {
			panelResult.setValue('AC_YYYY',new Date().getFullYear());
			UniAppManager.setToolbarButtons(['save','reset'],false);
		
			panelResult.onLoadSelectText('AC_YYYY');
			 
		
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				detailForm.mask('loading...');
				var param= panelResult.getValues();
				
				detailForm.clearForm();
				detailForm.setValue('DIVERT_AGREE_YN','1');	
				
				detailForm.getForm().load({
					params: param,
					success: function(form, action) {
						detailForm.unmask();
						
						UniAppManager.app.fnEssLevelNumDisAble();
						UniAppManager.setToolbarButtons('delete',true);
						UniAppManager.app.necessaryCheck();
						UniAppManager.setToolbarButtons('save', false);
					},
					failure: function(form, action) {
						detailForm.unmask();
						UniAppManager.app.fnEssLevelNumDisAble();
						UniAppManager.setToolbarButtons('delete',false);
						UniAppManager.app.necessaryCheck();
						UniAppManager.setToolbarButtons('save', false);
					}
				});
//				UniAppManager.setToolbarButtons('save',false);
				panelResult.setAllFieldsReadOnly(true);
				
			}
		},
		onResetButtonDown: function() {
			detailForm.clearForm();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function() {
			if(!detailForm.setAllFieldsReadOnly(true)){
	    		return false;
	    	}else{
				var param = detailForm.getValues();
				
				param.SAVE_FLAG = SAVE_FLAG;
				param.onDataCopy = onDataCopy;
				
				param.AC_YYYY_THIS = subForm.getValue('AC_YYYY_THIS');
				param.AC_YYYY_NEXT = subForm.getValue('AC_YYYY_NEXT');
				param.AC_YYYY = panelResult.getValue("AC_YYYY");
	//			param.txtToPubDate = UniDate.getDbDateStr(detailForm.getValue("txtToPubDate"));
	//	
				
				detailForm.getForm().submit({
				params : param,
					success : function(form, action) {
		 				detailForm.getForm().wasDirty = false;
						detailForm.resetDirtyStatus();											
						UniAppManager.setToolbarButtons('save', false);	
		            	UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
		            	if(SAVE_FLAG != 'D'){
		            		onDataCopy = '';
		            		UniAppManager.app.onQueryButtonDown();
		            	}else{
		            		SAVE_FLAG = '';
		            		detailForm.clearForm();
		            		UniAppManager.setToolbarButtons('save', false);		
		            	}
					}	
				});
			}
		},
		onDeleteDataButtonDown: function() {
			if(detailForm.getValue('EXIST_YN') == 'Y'){
				Ext.Msg.alert('확인',Msg.fSbMsgA0197);				
			}else{
				if(confirm('정말 삭제 하시겠습니까?')) {
	//				detailForm.clearForm();
					UniAppManager.setToolbarButtons('delete',false);
					UniAppManager.setToolbarButtons('save',true);
					SAVE_FLAG = 'D';
					UniAppManager.app.onSaveDataButtonDown();
	//				detailForm.mask('deleting...(저장버튼을 누르세요)');
				}
			}
		},
		checkForNewDetail:function() { 			
			return panelResult.setAllFieldsReadOnly(true);
        },
//        setDefaultValue: function() {
//        	detailForm.setValue('')
//        },
        fnEssLevelNumDisAble: function() {
        	if(detailForm.getValue('EXIST_YN') == 'Y'){	//AFB400T에 데이터 있음
        		detailForm.getField("CODE_LEVEL").setReadOnly(true);
        		detailForm.getField("LEVEL_NUM1").setReadOnly(true);
        		detailForm.getField("LEVEL_NUM2").setReadOnly(true);
        		detailForm.getField("LEVEL_NUM3").setReadOnly(true);
        		detailForm.getField("LEVEL_NUM4").setReadOnly(true);
        		detailForm.getField("LEVEL_NUM5").setReadOnly(true);
        		detailForm.getField("LEVEL_NUM6").setReadOnly(true);
        		detailForm.getField("LEVEL_NUM7").setReadOnly(true);
        		detailForm.getField("LEVEL_NUM8").setReadOnly(true);
        	}else{	//AFB400T에 데이터 없음
        		detailForm.getField("CODE_LEVEL").setReadOnly(false);
        		detailForm.getField("LEVEL_NUM1").setReadOnly(false);
        		detailForm.getField("LEVEL_NUM2").setReadOnly(false);
        		detailForm.getField("LEVEL_NUM3").setReadOnly(false);
        		detailForm.getField("LEVEL_NUM4").setReadOnly(false);
        		detailForm.getField("LEVEL_NUM5").setReadOnly(false);
        		detailForm.getField("LEVEL_NUM6").setReadOnly(false);
        		detailForm.getField("LEVEL_NUM7").setReadOnly(false);
        		detailForm.getField("LEVEL_NUM8").setReadOnly(false);
        	}
        },
        necessaryCheck: function(){
        	UniAppManager.app.fnEssLevelColorInit();
        	
        	
        	if(!Ext.isEmpty(detailForm.getValue('CODE_LEVEL'))){
        		var tempIndex, i
        		
        		tempIndex = detailForm.getValue('CODE_LEVEL');
        		
        		for(i = 1; i <= tempIndex; i++){
    				detailForm.getField("LEVEL_NUM"+i).setConfig('allowBlank',false);
					detailForm.getField("LEVEL_NUM"+i).setConfig('fieldStyle','background-image:none;background-color:#FAF4C0;');
        		}
        		
        		
        		
        	}
        },
        fnEssLevelColorInit: function(){
        	detailForm.getField("LEVEL_NUM1").setConfig('allowBlank',true);
			detailForm.getField("LEVEL_NUM1").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
			detailForm.getField("LEVEL_NUM2").setConfig('allowBlank',true);
			detailForm.getField("LEVEL_NUM2").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
			detailForm.getField("LEVEL_NUM3").setConfig('allowBlank',true);
			detailForm.getField("LEVEL_NUM3").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
			detailForm.getField("LEVEL_NUM4").setConfig('allowBlank',true);
			detailForm.getField("LEVEL_NUM4").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
			detailForm.getField("LEVEL_NUM5").setConfig('allowBlank',true);
			detailForm.getField("LEVEL_NUM5").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
			detailForm.getField("LEVEL_NUM6").setConfig('allowBlank',true);
			detailForm.getField("LEVEL_NUM6").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
			detailForm.getField("LEVEL_NUM7").setConfig('allowBlank',true);
			detailForm.getField("LEVEL_NUM7").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
			detailForm.getField("LEVEL_NUM8").setConfig('allowBlank',true);
			detailForm.getField("LEVEL_NUM8").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
		}
	});

	Unilite.createValidator('validator01', {
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				/*case fieldName:
					UniAppManager.setToolbarButtons('save', true);
					break;*/
				case "CODE_LEVEL" : 
//					if(SAVE_FLAG != 'D'){
						if(newValue < 1 || newValue > 8){
	//						rv='<t:message code = "unilite.msg.sMB070"/>'; 추후 코드화
							rv = 'LEVEL 1 부터 8 까지 입력 가능 합니다';
							
							break;
						}
							
						UniAppManager.app.necessaryCheck();
						
						break;
//						if(newValue == 1){
//							detailForm.getField("LEVEL_NUM2").setConfig('allowBlank',true);
//							detailForm.getField("LEVEL_NUM2").setConfig('fieldStyle','ime-mode:disabled;');
//						}
						
			}
			return rv;
		}
	});	
};


</script>
