<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="hrt800ukr"  >
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL"/> 			<!-- 신고 사업장 --> 
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	
	var panelSearch = Unilite.createForm('hrt800ukrDetail', {		
		  disabled :false
		, id: 'searchForm'
	    , flex:1       
	    , url: CPATH+'/human/createRetireFile.do'
    	, standardSubmit: true
	    , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	    , defaults: {labelWidth: 100}
	    , items :[{
			xtype: 'radiogroup',		            		
			fieldLabel: '제출방법',						            		
			id: 'rdoSelect1',
			items: [{
				boxLabel: '연간 합산제출', 
				width: 100, 
				name: 'rdoSelect1',
				inputValue: '',
				checked: true
			}]
		},{
			fieldLabel: '정산년도',
			xtype: 'uniTextfield',
			value: new Date().getFullYear(),
			fieldStyle: 'text-align:center;',
			name: 'CAL_YEAR',
			allowBlank: false
		},{
			fieldLabel: '제출년월일',
			id: 'frToDate',
			xtype: 'uniDatefield',
			name: 'SUBMIT_DATE',                    
			value: new Date(),                    
			allowBlank: false
		},{
			fieldLabel: '관리번호',
			name: 'TAX_AGENT_NO',
			xtype: 'uniTextfield'
		},{
			fieldLabel: '홈텍스ID',
			xtype: 'uniTextfield',
			name: 'HOME_TAX_ID',
			allowBlank: false
		},{
			fieldLabel: '신고사업장',
			name: 'DIV_CODE', 
			xtype: 'uniCombobox',
			comboCode: 'BILL', 
			comboType: 'BOR120',
			allowBlank: false
		},{
	    	xtype: 'container',
	    	padding: '10 0 0 0',
	    	layout: {
	    		type: 'vbox',
				align: 'center',
				pack:'center'
	    	},
	    	items:[{
	    		xtype: 'button',
	    		text: '실행',
	    		width : 100,
	    		handler: function() {
	    			var detailform = panelSearch.getForm();
					if (detailform.isValid()) {
						hrt800ukrService.checkData(panelSearch.getValues(), function(responseText, response){
	    					if(responseText.length > 0)	{
	    						panelSearch.submit();
	    					} else {
	    						Unilite.messageBox("법인정보 또는 해당사원이 존재하지 않습니다.");
	    					}
	    				})
					} else {
						var invalid = panelSearch.getForm().getFields()
								.filterBy(function(field) {
									return !field.validate();
								});
						if (invalid.length > 0) {
							r = false;
							var labelText = ''
							if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
								var labelText = invalid.items[0]['fieldLabel']
										+ '은(는)';
							} else if (Ext.isDefined(invalid.items[0].ownerCt)) {
								var labelText = invalid.items[0].ownerCt['fieldLabel']
										+ '은(는)';
							}
							Ext.Msg.alert('확인', labelText + Msg.sMB083);
							invalid.items[0].focus();
						}
					}
	    		}
	    	}]
	    }]      
	});	
	

    
    Unilite.Main( {
		items:[ 
	 		panelSearch
		],
		id  : 'hrt800ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset', 'query'],false);
			panelSearch.setValue('CAL_YEAR', UniDate.add(UniDate.today(),{'months':-2} ).getFullYear());
			panelSearch.onLoadSelectText('CAL_YEAR');
		}
	});


};


</script>
