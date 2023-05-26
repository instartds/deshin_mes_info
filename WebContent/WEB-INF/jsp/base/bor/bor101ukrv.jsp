<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="bor101ukrv"  >
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
	var plBaseOptStore = Unilite.createStore('bor101ukrvPlBaseOptStore', {
	    fields: ['text', 'value'],
		data :  [
		        {'text':'법인손익'		, 'value':'1'},
		        {'text':'사업부손익'	, 'value':'2'},
		        {'text':'손익단위'		, 'value':'3'}
		]
	});   
	/**
	 * 수주등록 Master Form
	 * 
	 * @type
	 */     
	var detailForm = Unilite.createForm('bor101ukrvDetail', {
		
    	disabled :false
        , flex:1        
        , layout: {type: 'uniTable', columns: 2, tdAttrs: {valign:'top'}}
	    , items :[	 
	    	 {name: 'COMP_CODE'    		,fieldLabel: 'COMP_CODE', allowBlank:false ,colspan:2, hidden:true, value:UserInfo.compCode} 
			,{name: 'DIV_CODE'    		,fieldLabel: 'DIV_CODE',  allowBlank:false ,colspan:2, hidden:true, value:'01'} 
			,{name: 'COMP_NAME'    		,fieldLabel: '회사명'	, allowBlank:false ,colspan:2 } 
			,{name: 'COMP_ENG_NAME'    	,fieldLabel: '회사영문명'	 ,colspan:2} 
			,{name: 'REPRE_NAME'    	,fieldLabel: '대표자명'	 ,colspan:2} 
			,{name: 'REPRE_ENG_NAME'    ,fieldLabel: '대표자영문명'	 ,colspan:2} 
			,{ 
				fieldLabel:'주민등록번호',
				name :'REPRE_NO_EXPOS',
				xtype: 'uniTextfield',
				readOnly:true,
				focusable:false,
				listeners:{
					afterrender:function(field)	{
						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick:function(event, elm)	{					
					detailForm.openCryptRepreNoPopup();
				}
			},
			{name: 'REPRE_NO'    		,fieldLabel: '주민등록번호'	 ,xtype: 'uniTextfield',	colspan:1, hidden: true	
			  /*
			  listeners : { blur: function(  field, The, eOpts  )	{
			  					var newValue = field.getValue().replace(/-/g,'');
			  					if(!Ext.isNumeric(newValue))	{
			  						Unilite.messageBox(Msg.sMB074);
								 	detailForm.setValue('REPRE_NO', field.originalValue);
								 	return;
								 	
								 }
			  					if(!Ext.isEmpty(newValue) && field.originalValue != field.getValue())	{
			  						if(Unilite.validate('residentno',newValue) !== true)	{
								 		if(!confirm(Msg.sMB174+"\n"+Msg.sMB176))	{									 		 
								 			detailForm.setValue('REPRE_NO', field.originalValue);
								 			return;
								 		}
								 	}
				  					if(Ext.isNumeric(newValue)) {
										var a = newValue;
										var i = (a.substring(0,6)+ "-"+ a.substring(6,13));
										detailForm.setValue('REPRE_NO',i);
								 	}
			  				}
			  			  }
			  }
			  */
			 }  
			,{name: 'COMPANY_NUM'    	,fieldLabel: '사업자등록번호'	 ,colspan:2, maxLength:21,
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
			,{name: 'COMP_OWN_NO'    	,fieldLabel: '법인등록번호'	, maxLength:21,
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
			,{name: 'COMP_KIND'    		,fieldLabel: '법인구분'	, allowBlank:false, xtype:'uniCombobox', comboType:'AU', comboCode:'B002' ,width:315} 
			,{name: 'COMP_CLASS'    	,fieldLabel: '업종'	} 
			,{name: 'COMP_TYPE'    		,fieldLabel: '업태'	,width:315} 
			,{name: 'SESSION'    		,fieldLabel: '회기'	,xtype : 'uniNumberfield', allowBlank:false } 
			,{fieldLabel: '회계기간'
				,xtype: 'uniDateRangefield'
			    ,startFieldName: 'FN_DATE'
			    ,endFieldName: 'TO_DATE'	
			    ,width: 470
			    ,startDate: UniDate.get('startOfMonth')
			    ,endDate: UniDate.get('today')
			    ,allowBlank:false
		     }
			,{name: 'ESTABLISH_DATE'    ,fieldLabel: '설립일'	,xtype : 'uniDatefield'} 
			,{name: 'NATION_CODE'    	,fieldLabel: '국가코드'	, xtype:'uniCombobox', comboType:'AU', comboCode:'B012', allowBlank:false,width:315} 
			,{name: 'CURRENCY'    		,fieldLabel: '자사화폐'	, xtype:'uniCombobox', comboType:'AU', comboCode:'B004', displayField: 'value', allowBlank:false} 
			,{name: 'CAPITAL'    		,fieldLabel: '자본금'	,xtype : 'uniNumberfield',width:315} 
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
			,{name: 'ADDR'    			,fieldLabel: '주소'	 ,colspan:2, width:560} 
			,{name: 'ENG_ADDR'    		,fieldLabel: '영문주소'	 ,colspan:2, width:560} 
			,{name: 'TELEPHON'    		,fieldLabel: '대표전화번호'	 ,colspan:2} 
			,{name: 'FAX_NUM'    		,fieldLabel: '대표FAX번호'	 ,colspan:2} 
			,{name: 'HTTP_ADDR'    		,fieldLabel: '홈페이지주소'	 ,colspan:2} 
			,{name: 'EMAIL'    			,fieldLabel: 'E-mail주소'	 ,colspan:2} 
			,{name: 'DOMAIN'    		,fieldLabel: '도메인'	 ,colspan:2} 
			,{name: 'PL_BASE'    		,fieldLabel: '손익작성기준'	 ,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bor101ukrvPlBaseOptStore') ,colspan:2} 
        ]
        , api: {
         		 load: 'bor101ukrvService.selectMaster',
				 submit: 'bor101ukrvService.syncMaster'				
				}
		, listeners : {
				uniOnChange:function( basicForm, dirty, eOpts ) {
					console.log("onDirtyChange");
					if(basicForm.isDirty())	{
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
		, openCryptRepreNoPopup:function(  )	{
			var record = this;
							
			var params = {'REPRE_NO':this.getValue('REPRE_NO'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'Y'};
			Unilite.popupCipherComm('form', record, 'REPRE_NO_EXPOS', 'REPRE_NO', params);
			
				
		}
	});

    /**
	 * main app
	 */
    Unilite.Main( {
    		 id  : 'bor101ukrvApp',
			 items 	: [ detailForm]
			,fnInitBinding : function() {
				this.setToolbarButtons(['newData','reset'],false);
				this.onQueryButtonDown();	
			}
			,onQueryButtonDown:function () {
				var param= detailForm.getValues();
				detailForm.uniOpt.inLoading = true;
				Ext.getBody().mask('로딩중...','loading-indicator');
				detailForm.getForm().load({
					params: param,
					success:function()	{
						Ext.getBody().unmask();
//						if(!Ext.isEmpty(detailForm.getValue('REPRE_NO'))){
//							var a = detailForm.getValue('REPRE_NO');
//							var i = (a.substring(0,6) + "-"+ a.substring(6,13));
//							detailForm.setValue('REPRE_NO',i);
//							detailForm.getField('REPRE_NO').originalValue = i;
//						}
//						if(!Ext.isEmpty(detailForm.getValue('COMP_OWN_NO'))){
//							var a = detailForm.getValue('COMP_OWN_NO');
//							var i = (a.substring(0,6) + "-"+ a.substring(6,13));
//							detailForm.setValue('COMP_OWN_NO',i);
//							detailForm.getField('COMP_OWN_NO').originalValue = i;
//						}
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
				Ext.getBody().mask('로딩중...','loading-indicator');
				detailForm.getForm().submit({
					 params : param,
					 success : function(form, action) {
				 		Ext.getBody().unmask();
	 					detailForm.getForm().wasDirty = false;
						detailForm.resetDirtyStatus();											
						UniAppManager.setToolbarButtons('save', false);	
	            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
					 }	
				});
			},
			onDetailButtonDown:function() {
				var as = Ext.getCmp('bor101ukrvAdvanceSerch');	
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
