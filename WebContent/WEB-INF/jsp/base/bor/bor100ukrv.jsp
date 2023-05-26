<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="bor100ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="B002" /> <!-- 법인구분 -->
<t:ExtComboStore comboType="AU" comboCode="B012" /> <!-- 국가코드 -->
<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 자사화폐 -->
</t:appConfig>
<script type="text/javascript">
  var protocol =   ("https:" == document.location.protocol)  ? "https" : "http"  ;
  if(protocol == "https")	{
	  document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E")  );
  }else {
  	document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
  }
</script>
<script type="text/javascript" >
function appMain() {
	var plBaseOptStore = Unilite.createStore('bor100ukrvPlBaseOptStore', {
	    fields: ['text', 'value'],
		data :  [
		        {'text':'<t:message code="system.label.base.businessprofitloss" default="법인손익"/>'		, 'value':'1'},
		        {'text':'<t:message code="system.label.base.businessdivisionprofitloss" default="사업부손익"/>'	, 'value':'2'},
		        {'text':'<t:message code="system.label.base.profitunit" default="손익단위"/>'		, 'value':'3'}
		]
	});   
	/**
	 * Master Form
	 * 
	 * @type
	 */     
	var detailForm = Unilite.createForm('bor100ukrvDetail', {
		
    	disabled :false
        , flex:1        
        , layout: {type: 'uniTable', columns: 2, tdAttrs: {valign:'top'}}
	    , items :[	 
	    	 {name: 'COMP_CODE'    		,fieldLabel: 'COMP_CODE', allowBlank:false ,colspan:2, hidden:true, value:UserInfo.compCode} 
			,{name: 'DIV_CODE'    		,fieldLabel: 'DIV_CODE',  allowBlank:false ,colspan:2, hidden:true, value:'01'} 
			,{name: 'COMP_NAME'    		,fieldLabel: '<t:message code="system.label.base.compname" default="회사명"/>'	, allowBlank:false ,colspan:2 } 
			,{name: 'COMP_ENG_NAME'    	,fieldLabel: '<t:message code="system.label.base.compnameen" default="회사영문명"/>'	 ,colspan:2} 
			,{name: 'REPRE_NAME'    	,fieldLabel: '<t:message code="system.label.base.representativename" default="대표자명"/>'	 ,colspan:2} 
			,{name: 'REPRE_ENG_NAME'    ,fieldLabel: '<t:message code="system.label.base.representativenameen" default="대표자영문명"/>'	 ,colspan:2}
			,{name: 'REPRE_NO'    		,fieldLabel: '<t:message code="system.label.base.residentno" default="주민등록번호"/>', hidden:true}
			,{name: 'REPRE_NO_EXPOS'    ,fieldLabel: '<t:message code="system.label.base.residentno" default="주민등록번호"/>'	 ,colspan:2,
				listeners:{
					// focus out 이벤트
					blur: function(field, event, eOpts ){
						// 빈값이 아닌경우
						if(!Ext.isEmpty(field.lastValue)){
							// '-', '*' 제외
							var newValue = field.getValue().replace(/-/g ,'').replace(/\*/g ,'');

							if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{
						 		Unilite.messageBox('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
						 		this.setValue(field.originalValue);
						 		return ;
						 	}								
							// 새로운 값을 입력했을 경우							
							if(field.lastValue != field.originalValue){
								
			  					if(Unilite.validate('residentno',newValue) != true && !Ext.isEmpty(newValue))	{
							 		if(!confirm(Msg.sMB174+"\n"+Msg.sMB176)) { // 잘못된 주민등록번호를 입력하셨습니다. \n 잘못된 주민등록번호를 저장하시겠습니까?
							 			field.setValue(field.originalValue);   // 아닐경우 원래 데이터로 세팅
							 			return;
							 		}
							 	}
								var param = {
									"DECRYP_WORD" : field.lastValue
								};
								// 새로 입력한 데이터 암호화
								humanCommonService.encryptField(param, function(provider, response)  {
				                    if(!Ext.isEmpty(provider)){
				                    	detailForm.setValue('REPRE_NO',provider);
				                    }else{
				                    	detailForm.setValue('REPRE_NO_EXPOS',"");
				                    	detailForm.setValue('REPRE_NO',"");
				                    }
			                        field.originalValue = field.lastValue; 
								});
							}
						// 빈값인 경우 원본 데이터에 빈값 세팅
						}else{
							detailForm.setValue('REPRE_NO',"");
						}
					},
                    afterrender:function(field) {
                        field.getEl().on('dblclick', field.onDblclick);
                    }
                },
                // 클릭 할 경우 복호화 한 주민번호 팝업창 show
                onDblclick:function(event, elm) {
					var params = {'INCRYP_WORD':detailForm.getValue('REPRE_NO')};
                    Unilite.popupDecryptCom(params);
                }
			}
			,{name: 'COMPANY_NUM'    	,fieldLabel: '<t:message code="system.label.base.compnum" default="사업자등록번호"/>'	 ,colspan:2, maxLength:21,
			  listeners : { blur: function( field, The, eOpts )	{
			  					var newValue = field.getValue().replace(/-/g,'');		
			  					if(!Ext.isNumeric(newValue))	{	
			  						Unilite.messageBox(Msg.sMB074);
						 			detailForm.setValue('COMPANY_NUM', field.originalValue);
						 			return;
								 }
			  					if(!Ext.isEmpty(newValue) && !(field.originalValue == field.getValue()) )	{
				  					if(Ext.isNumeric(newValue)) {
										var a = newValue;
										var i = (a.substring(0,3)+ "-"+ a.substring(3,5)+"-" + a.substring(5,10));
										if(a.length == 10){
											detailForm.setValue('COMPANY_NUM',i);
										}else{
											detailForm.setValue('COMPANY_NUM',a);
										}
										
								 	}
				  					
				  					if(Unilite.validate('bizno', newValue) != true)	{
								 		if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))	{									 		 
								 			detailForm.setValue('COMPANY_NUM', field.originalValue);
								 		}
								 	}
			  					}
							 	
			  				}
			  			  }
			  } 					
			,{name: 'COMP_OWN_NO'    	,fieldLabel: '<t:message code="system.label.base.compownno" default="법인등록번호"/>'	, maxLength:21,
				listeners : { blur: function( field, The, eOpts )	{
								var newValue = field.getValue().replace(/-/g,'');
								if(!Ext.isEmpty(newValue) && field.originalValue != field.getValue())	{
									if(Ext.isNumeric(newValue) == true) {
										var a = newValue;
										var i = (a.substring(0,6)+ "-"+ a.substring(6,13));
										detailForm.setValue('COMP_OWN_NO',i);
								 	}
				  					if(Ext.isNumeric(newValue) != true)	{
								 		if(!confirm(Msg.sMB074)) {									 		 
								 			detailForm.setValue('COMP_OWN_NO', field.originalValue);
								 		}
								 	}
								}
							 	
						}
				}
			} 
			,{name: 'COMP_KIND'    		,fieldLabel: '<t:message code="system.label.base.companytype" default="법인구분"/>'	, allowBlank:false, xtype:'uniCombobox', comboType:'AU', comboCode:'B002' ,width:315} 
			,{name: 'COMP_CLASS'    	,fieldLabel: '<t:message code="system.label.base.businesstype" default="업종"/>'	} 
			,{name: 'COMP_TYPE'    		,fieldLabel: '<t:message code="system.label.base.businessconditions" default="업태"/>'	,width:315} 
			,{name: 'SESSION'    		,fieldLabel: '<t:message code="system.label.base.session" default="회기"/>'	,xtype : 'uniNumberfield', allowBlank:false } 
			,{fieldLabel: '<t:message code="system.label.base.axslipterm" default="회계기간"/>'
				,xtype: 'uniDateRangefield'
			    ,startFieldName: 'FN_DATE'
			    ,endFieldName: 'TO_DATE'	
			    ,width: 470
			    ,startDate: UniDate.get('startOfMonth')
			    ,endDate: UniDate.get('today')
			    ,allowBlank:false
		     }
			,{name: 'ESTABLISH_DATE'    ,fieldLabel: '<t:message code="system.label.base.establishdate" default="설립일"/>'	,xtype : 'uniDatefield'} 
			,{name: 'NATION_CODE'    	,fieldLabel: '<t:message code="system.label.base.countrycode" default="국가코드"/>'	, xtype:'uniCombobox', comboType:'AU', comboCode:'B012', allowBlank:false,width:315} 
			,{name: 'CURRENCY'    		,fieldLabel: '<t:message code="system.label.base.currency1" default="자사화폐"/>'	, xtype:'uniCombobox', comboType:'AU', comboCode:'B004', displayField: 'value', allowBlank:false} 
			,{name: 'CAPITAL'    		,fieldLabel: '<t:message code="system.label.base.capital" default="자본금"/>'	,xtype : 'uniNumberfield',width:315} 
			, Unilite.popup('ZIP',{showValue:false, textFieldName:'ZIP_CODE', textFieldWidth: 150, DBtextFieldName:'ZIP_CODE', validateBlank:false ,colspan:2, 
						listeners: { 'onSelected': {
								fn: function(records, type  ) {
								   	detailForm.setValue('ADDR', records[0]['ZIP_NAME']);
								    console.log("(records[0] : ", records[0]);
									//Ext.getCmp('ADDR2_F').setValue(records[0]['ADDR2']);
								    /*if(Ext.isNumeric(detailForm.getValue('ZIP')) == true) {
										var a = detailForm.getValue('ZIP');
										var i = (a.substring(0,3)+ "-");
										detailForm.setValue('ZIP',i);
							 		}*/
								},
								scope: this
				            },
							'onClear' : function(type)	{
								detailForm.setValue('ADDR', '');
							}
						}
			})
			,{name: 'ADDR'    			,fieldLabel: '<t:message code="system.label.base.address" default="주소"/>'	 ,colspan:2, width:560} 
			,{name: 'ENG_ADDR'    		,fieldLabel: '<t:message code="system.label.base.engaddr" default="영문주소"/>'	 ,colspan:2, width:560} 
			,{name: 'TELEPHON'    		,fieldLabel: '<t:message code="system.label.base.telephonnum" default="대표전화번호"/>'	 ,colspan:2} 
			,{name: 'FAX_NUM'    		,fieldLabel: '<t:message code="system.label.base.repfaxnum" default="대표FAX번호"/>'	 ,colspan:2} 
			,{name: 'HTTP_ADDR'    		,fieldLabel: '<t:message code="system.label.base.homepage" default="홈페이지"/>'	 ,colspan:2} 
			,{name: 'EMAIL'    			,fieldLabel: 'E-mail'	 ,colspan:2} 
			,{name: 'DOMAIN'    		,fieldLabel: '<t:message code="system.label.base.domain" default="도메인"/>'	 ,colspan:2} 
			,{name: 'PL_BASE'    		,fieldLabel: '<t:message code="system.label.base.profitbase" default="손익작성기준"/>'	 ,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bor100ukrvPlBaseOptStore') ,colspan:2} 
        ]
        , api: {
         		 load: 'bor100ukrvService.selectMaster',
				 submit: 'bor100ukrvService.syncMaster'				
				}
		, listeners : {
				uniOnChange:function( basicForm, dirty, eOpts ) {
					console.log("onDirtyChange");
					if(basicForm.isDirty()&& !basicForm.uniOpt.inLoading)	{
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
				},
				beforeaction:function(basicForm, action, eOpts)	{
					console.log("action : ",action);
					console.log("action.type : ",action.type);
					if(action.type =='directsubmit')	{
						var invalid = this.getForm().getFields().filterBy(function(field) {
						            return !field.validate();
						    });
				        	
			         	if(invalid.length > 0)	{
				        	r=false;
				        	var labelText = ''
				        	
				        	if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
				        		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				        	}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
				        		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				        	}
				        	Unilite.messageBox(labelText+Msg.sMB083);
				        	invalid.items[0].focus();
				        }																									
					}
				}
		}
	});

    /**
	 * main app
	 */
    Unilite.Main( {
    		 id  : 'bor100ukrvApp',
			 items 	: [ detailForm]
			,fnInitBinding : function() {
				this.setToolbarButtons(['newData','reset'],false);
				this.onQueryButtonDown();	
			}
			,onQueryButtonDown:function () {
				var param= detailForm.getValues();
				detailForm.uniOpt.inLoading = true;
				Ext.getBody().mask('<t:message code="system.label.base.loading" default="로딩중..."/>','loading-indicator');
				detailForm.getForm().load({
					params: param,
					success:function()	{
						Ext.getBody().unmask();
						if(!Ext.isEmpty(detailForm.getValue('COMP_OWN_NO'))){
							var a = detailForm.getValue('COMP_OWN_NO');
							var i = (a.substring(0,6) + "-"+ a.substring(6,13));
							detailForm.setValue('COMP_OWN_NO',i);
							detailForm.getField('COMP_OWN_NO').originalValue = i;
						}
						if(!Ext.isEmpty(detailForm.getValue('COMPANY_NUM'))){
							var a = detailForm.getValue('COMPANY_NUM');
							var i = (a.substring(0,3) + "-"+ a.substring(3,5) + "-" + a.substring(5,10));
							detailForm.setValue('COMPANY_NUM',i);
							detailForm.getField('COMPANY_NUM').originalValue = i;
						}
						if(!Ext.isEmpty(detailForm.getValue('ZIP_CODE'))){
							var a = detailForm.getValue('ZIP_CODE');
							var i = (a.substring(0,3) + "-"+ a.substring(3,6));
							detailForm.setValue('ZIP_CODE',i);
							detailForm.getField('ZIP_CODE').originalValue = i;
						}
						
						detailForm.uniOpt.inLoading = false;
					},
					 failure: function(batch, option) {					 	
					 	Ext.getBody().unmask();					 
					 }
				})
			},
			onSaveDataButtonDown: function (config) {			
				
				var param= detailForm.getValues();
				Ext.getBody().mask('<t:message code="system.label.base.loading" default="로딩중..."/>','loading-indicator');
				detailForm.getForm().submit({
					 params : param,
					 success : function(form, action) {
				 		Ext.getBody().unmask();
	 					detailForm.getForm().wasDirty = false;
						detailForm.resetDirtyStatus();											
						UniAppManager.setToolbarButtons('save', false);	
	            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
	            		
	            		UniAppManager.app.onQueryButtonDown();
					 }	
				});
			},
			onDetailButtonDown:function() {
				var as = Ext.getCmp('bor100ukrvAdvanceSerch');	
				if(as.isHidden())	{
					as.show();
				}else {
					as.hide()
				}
			},
			rejectSave: function()	{
				var rowIndex = masterGrid.getSelectedRowIndex();
				masterGrid.select(rowIndex);
				directMasterStore.rejectChanges();
				
				if(rowIndex >= 0){
					masterGrid.getSelectionModel().select(rowIndex);
					var selected = masterGrid.getSelectedRecord();
					
					var selected_doc_no = selected.data['DOC_NO'];
	  				bdc100ukrvService.getFileList(
	  						{DOC_NO : selected_doc_no},
							function(provider, response) {															
								
							}
					);
				}
				directMasterStore.onStoreActionEnable();

			}, confirmSaveData: function(config)	{
            	if(directMasterStore.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown(config);
					} else {
						this.rejectSave();
					}
				}
            }
		});
		
		
}
</script>
