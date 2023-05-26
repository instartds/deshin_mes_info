<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="asc100ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B002" /> 	<!-- 법인구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B012" /> 	<!-- 국가코드 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> 	<!-- 자사화폐 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var getStDt = ${getStDt};	//당기시작,종료일	
	var gsChargeCode = '${getChargeCode}';     
	var panelSearch = Unilite.createForm('searchForm', {		
		disabled :false
        ,	flex:1        
        ,	layout: {type: 'uniTable', columns: 2, tdAttrs: {valign:'top'}}
		,	items: [{
	        	fieldLabel: '상각년월',
				xtype: 'uniMonthRangefield',  
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				allowBlank:false,
				width: 315,
				colspan: 2
//				textFieldWidth:170
			},{
				fieldLabel: '사업장',
				name:'DIV_CODE',	
				xtype: 'uniCombobox',
				comboType:'BOR120',
				colspan: 2
			},
				Unilite.popup('ASSET',{ 
			    fieldLabel: '자산코드', 
			    valueFieldName: 'ASSET_CODE_FR', 
				textFieldName: 'ASSET_NAME_FR',
			    validateBlank: true,
				listeners: {
					onValueFieldChange: function(field, newValue){
					},
					onTextFieldChange: function(field, newValue){
					}
				}
		   	}),
				Unilite.popup('ASSET',{ 
			    fieldLabel: '~', 
			    labelWidth:20,
			    valueFieldName: 'ASSET_CODE_TO', 
				textFieldName: 'ASSET_NAME_TO',
			    validateBlank: true,
				listeners: {
					onValueFieldChange: function(field, newValue){
					},
					onTextFieldChange: function(field, newValue){
					}
				}
		   	}),
		   		Unilite.popup('ACCNT',{
			    fieldLabel: '계정과목',
			    valueFieldName: 'ACCNT_CODE_FR', 
				textFieldName: 'ACCNT_NAME_FR',
				validateBlank: true,
				listeners: {
					onValueFieldChange: function(field, newValue){
//						panelResult.setValue('ASSET_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
//						panelResult.setValue('ASSET_NAME', newValue);				
					},
					applyextparam: function(popup){
						popup.setExtParam({'ADD_QUERY': "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
						popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)			
					}
				}
			}),
		   		Unilite.popup('ACCNT',{
			    fieldLabel: '~',
			    labelWidth:20,
				valueFieldName: 'ACCNT_CODE_TO', 
				textFieldName: 'ACCNT_NAME_TO',
				validateBlank: true,
				listeners: {
					onValueFieldChange: function(field, newValue){
//						panelResult.setValue('ASSET_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
//						panelResult.setValue('ASSET_NAME', newValue);				
					},
					applyextparam: function(popup){
						popup.setExtParam({'ADD_QUERY': "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
						popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)			
					}
				}
			}),
				Unilite.popup('AC_PROJECT',{ 
				valueFieldName: 'AC_PROJECT_CODE_FR', 
				textFieldName: 'AC_PROJECT_NAME_FR',
			    validateBlank: true,
				listeners: {
					onValueFieldChange: function(field, newValue){
//						panelResult.setValue('ASSET_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
//						panelResult.setValue('ASSET_NAME', newValue);				
					}
				}
		   	}),
				Unilite.popup('AC_PROJECT',{
				fieldLabel: '~',
				labelWidth:20,
			    valueFieldName: 'AC_PROJECT_CODE_TO', 
				textFieldName: 'AC_PROJECT_NAME_TO',
			    validateBlank: true,
				listeners: {
					onValueFieldChange: function(field, newValue){
//						panelResult.setValue('ASSET_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
//						panelResult.setValue('ASSET_NAME', newValue);				
					}
				}
		   	}),{
		    	xtype: 'container',
		    	layout: {
		    		type: 'hbox',
		    		margin:	'0 0 0 0',
					align: 'center',
					pack:'center'
		    	},
		    	colspan: 2,
		    	items:[{
					xtype: 'button',
		    		margin:	'0 0 0 75',
		    		text: '실행',
		    		width: 70,
		    		handler : function() {
//						if(confirm(Msg.sMA0221)){
		    			if(!panelSearch.getInvalidMessage()){
							return false;
						}
						if(getStDt[0].STDT > UniDate.getDbDateStr(panelSearch.getValue('FR_DATE')) || getStDt[0].TODT < UniDate.getDbDateStr(panelSearch.getValue('TO_DATE'))){
							var stDt = getStDt[0].STDT.substring(0, 4) + '.' + getStDt[0].STDT.substring(4, 6);
							var edDt = getStDt[0].TODT.substring(0, 4) + '.' + getStDt[0].TODT.substring(4, 6);
							alert(Msg.sMA0294 + '\n' + '[ ' + stDt + ' ~ ' + edDt +']');
							return false;
						}
						var param = panelSearch.getValues();
						Ext.getBody().mask('로딩중...','loading-indicator');
						asc100ukrService.insertMaster(param, function(provider, response)	{						
							if(provider){
								UniAppManager.updateStatus("저장되었습니다.");
							}
							Ext.getBody().unmask();
						});	
					}
//		    		}
		    	},{
		    		xtype: 'button',
		    		margin:	'0 0 0 5',
		    		text: '취소',
		    		width: 70,
		    		handler : function() {
		    			if(!panelSearch.getInvalidMessage()){
							return false;
						}
						if(getStDt[0].STDT > UniDate.getDbDateStr(panelSearch.getValue('FR_DATE')) || getStDt[0].TODT < UniDate.getDbDateStr(panelSearch.getValue('TO_DATE'))){
							var stDt = getStDt[0].STDT.substring(0, 4) + '.' + getStDt[0].STDT.substring(4, 6);
							var edDt = getStDt[0].TODT.substring(0, 4) + '.' + getStDt[0].TODT.substring(4, 6);
							alert(Msg.sMA0294 + '\n' + '[ ' + stDt + ' ~ ' + edDt +']');
							return false;
						}
						var param = panelSearch.getValues();
						Ext.getBody().mask('로딩중...','loading-indicator');
						asc100ukrService.cancelMaster(param, function(provider, response)	{						
							if(provider){
								UniAppManager.updateStatus("작업을 취소하였습니다.");
							}
							Ext.getBody().unmask();
						});		    			
		    		}
				}]
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
					//this.mask();		    
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});
	
    Unilite.Main( {
		items:[panelSearch],
		id  : 'asc100ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('FR_DATE',getStDt[0].STDT);
			panelSearch.setValue('TO_DATE',getStDt[0].TODT);
			UniAppManager.setToolbarButtons(['detail', 'query', 'reset'],false);
			
			panelSearch.onLoadSelectText('FR_DATE');
		},
		onQueryButtonDown : function()	{			
			
				masterGrid.getStore().loadStoreRecords();
				var viewLocked = masterGrid.lockedGrid.getView();
				var viewNormal = masterGrid.normalGrid.getView();
				console.log("viewLocked : ",viewLocked);
				console.log("viewNormal : ",viewNormal);
			    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);				
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>
