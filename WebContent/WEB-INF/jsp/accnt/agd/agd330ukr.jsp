<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="agd330ukrv"  >
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
	var panelSearch = Unilite.createForm('agd330ukrvDetail', {
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
	    			}else {
    
	    				var param = {
	    					DIV_CODE		: panelSearch.getValue("DIV_CODE"),
	    					FR_DATE 		: UniDate.getDbDateStr(panelSearch.getValue("FR_DATE")),
	    					TO_DATE 		: UniDate.getDbDateStr(panelSearch.getValue("TO_DATE")),
	    					AC_DATE			: UniDate.getDbDateStr(panelSearch.getValue("AC_DATE")),
	    					INPUT_USER_ID 	: UserInfo.userID,
	    					INPUT_DATE		: UniDate.getDbDateStr(UniDate.today()),
	    					LANG_TYPE 		: UserInfo.userLang,
	    					CALL_PATH		: 'Batch'
	    					
	    				}
	    				panelSearch.getEl().mask('로딩중...','loading-indicator');
						agd330ukrService.procAutoSlip(param, function(provider, response)	{
								if(provider) {	
									UniAppManager.updateStatus("자동기표가 완료 되었습니다.");
								}
								console.log("response",response)
								panelSearch.getEl().unmask();
						});
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
			    	}else {
			    		
	    				var param = {
	    					DIV_CODE		: panelSearch.getValue("DIV_CODE"),
	    					FR_DATE 		: UniDate.getDbDateStr(panelSearch.getValue("FR_DATE")),
	    					TO_DATE 		: UniDate.getDbDateStr(panelSearch.getValue("TO_DATE")),
	    					AC_DATE			: UniDate.getDbDateStr(panelSearch.getValue("AC_DATE")),
	    					INPUT_USER_ID 	: UserInfo.userID,
	    					INPUT_DATE		: UniDate.getDbDateStr(UniDate.today()),
	    					LANG_TYPE 		: UserInfo.userLang,
	    					CALL_PATH		: 'Batch'
	    					
	    				}
	    				panelSearch.getEl().mask('로딩중...','loading-indicator');
						agd330ukrService.cancelAutoSlip(param, function(provider, response)	{
								if(provider) {	
									UniAppManager.updateStatus("자동기표가 취소 되었습니다.");
								}
								console.log("response",response)
								panelSearch.getEl().unmask();
						});
	    			
			    		
			    	}   			
	    		}
	     	}]
		}]
         
		, listeners : {
			dirtychange:function( basicForm, dirty, eOpts ) {
				console.log("onDirtyChange");
//					UniAppManager.setToolbarButtons('save', true);
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
    		 id  : 'agd330ukrvApp',
			 items 	: [ panelSearch]
			,fnInitBinding : function() {
				panelSearch.setValue('DIV_CODE', UserInfo.divCode);
				panelSearch.setValue('FR_DATE', UniDate.get('today'));
				panelSearch.setValue('TO_DATE', UniDate.get('today'));
				panelSearch.setValue('AC_DATE', UniDate.get('today'));
				this.setToolbarButtons(['newData','reset', 'query'],false);
				panelSearch.onLoadSelectText('FR_DATE');
			}
		
            
		});
}
</script>
