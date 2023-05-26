<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="agd335ukrv"  >
<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="S024" /> <!-- 부가세유형 -->
<t:ExtComboStore comboType="AU" comboCode="B002" /> <!-- 법인구분 -->
<t:ExtComboStore comboType="AU" comboCode="B012" /> <!-- 국가코드 -->
<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 자사화폐 -->
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	/**
	 * 수주등록 Master Form
	 * 
	 * @type
	 */     
	var panelSearch = Unilite.createForm('agd335ukrvDetail', {
    	disabled :false
        , flex:1        
        , layout: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}}
	    , items :[{	
			fieldLabel: '실행월',
	        xtype: 'uniMonthRangefield',
	        startFieldName: 'FR_DATE',
	        endFieldName: 'TO_DATE',
	        allowBlank: false
//			onStartDateChange: function(field, newValue, oldValue, eOpts) {
//                	if(panelResult) {
//						panelResult.setValue('DPR_YYMM_FR',newValue);
//                	}
//			    },
//		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
//		    	if(panelResult) {
//		    		panelResult.setValue('DPR_YYMM_TO',newValue);
//		    	}
//		    }
        },{ 
			fieldLabel: '사업장',
			name: 'DIV_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120'
		 },{
			fieldLabel: '전표일',
	        xtype: 'uniDatefield',
	        name: 'AC_DATE',
	        allowBlank: false
	     },{
	     	xtype: 'container', 
	     	tdAttrs: {align: 'center'},
	     	layout: {type: 'uniTable', columns: 3},
	     	items: [{
	        	margin: '0 6 0 0',
				xtype: 'button',
				id: 'startButton',
				text: '실행',		
				width: 60,
				handler : function() {
	    			if(!panelSearch.setAllFieldsReadOnly(true)){
			    		return false;
			    	}	    			
	    		}
	     	},{xtype: 'component', width: 5}, {
				xtype: 'button',
				id: 'cancelButton',
				text: '취소',
				width: 60,
				handler : function() {
	    			if(!panelSearch.setAllFieldsReadOnly(true)){
			    		return false;
			    	}	    			
	    		}
	     	}]
		}]
         ,api: {
         		 load: 'agd335ukrvService.selectMaster',
				 submit: 'agd335ukrvService.syncMaster'				
				}
		, listeners : {
			dirtychange:function( basicForm, dirty, eOpts ) {
				console.log("onDirtyChange");
//					UniAppManager.setToolbarButtons('save', true);
			}/*,
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
			        	alert(labelText+Msg.sMB083);
			        	invalid.items[0].focus();
			        }																									
				}
			}*/	
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
					//this.mask();		    
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});

    /**
	 * main app
	 */
    Unilite.Main( {
    		 id  : 'agd335ukrvApp',
			 items 	: [ panelSearch]
			,fnInitBinding : function() {
				panelSearch.setValue('DIV_CODE', UserInfo.divCode);
				panelSearch.setValue('FR_DATE', UniDate.get('today'));
				panelSearch.setValue('TO_DATE', UniDate.get('today'));
				panelSearch.setValue('AC_DATE', UniDate.get('today'));
				this.setToolbarButtons(['newData','reset', 'query'],false);
				panelSearch.onLoadSelectText('FR_DATE');
			}
		/*	,onQueryButtonDown:function () {
				var param= panelSearch.getValues();
				panelSearch.getForm().load({params : param});
			},
			onSaveDataButtonDown: function (config) {
				
				var param= panelSearch.getValues();
				panelSearch.getForm().submit({
						 params : param,
						 success : function(form, action) {
			 					panelSearch.getForm().wasDirty = false;
								panelSearch.resetDirtyStatus();											
								UniAppManager.setToolbarButtons('save', false);	
								
			            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.			
						 }	
				});
			},
			onDetailButtonDown:function() {
				var as = Ext.getCmp('agd335ukrvAdvanceSerch');	
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
				
            }*/
            
		});
}
</script>
