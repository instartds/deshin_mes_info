<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="hpb500ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->   
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" />		<!-- 신고사업장 -->
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	/*
	 * combobox 정의
	 */
	
	var TypeStore = Unilite.createStore('TypeStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'거주자사업소득'		, 'value':'1'},
			        {'text':'거주자기타소득'		, 'value':'2'},
			        {'text':'비거주자사업기타소득'	, 'value':'3'},
			        {'text':'이자,배당소득'			, 'value':'4'}
	    		]
	});
	
	var panelSearch = Unilite.createForm('searchForm', {		
        disabled :false
        , flex:1        
        , url: CPATH+'/human/fileDown.do'
    	, standardSubmit: true
        , layout: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}}
	    , items :[{
			xtype: 'radiogroup',		            		
			fieldLabel: '제출방법',						            		
			id: 'rdoSelect1',
			items: [{
				boxLabel: '연간 합산제출', 
				width: 150, 
				name: 'SUBMIT_CODE',
				inputValue: '1',
				checked: true,
				readOnly: true
			}]
		},{
			fieldLabel: '전산매체유형',
			name: 'MEDIUM_TYPE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: '',
			store: TypeStore,
			value: '1',
			allowBlank: false
		},{
			fieldLabel: '정산년도',
			xtype: 'uniTextfield',
			name: 'CAL_YEAR',
			allowBlank: false
		},{
			fieldLabel: '제출년월일',
			id: 'SUBMIT_DATE',
			xtype: 'uniDatefield',
			name: 'SUBMIT_DATE',                    
			value: new Date(),                    
			allowBlank: false
		},{
			fieldLabel: '신고사업장',
			name: 'DIV_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			comboCode: 'BILL',
			allowBlank: false
		},{
			fieldLabel: '관리번호',
    		xtype: 'uniTextfield',
    		name: 'TAX_AGENT_NO',
            allowBlank: true
		},{
			fieldLabel: '홈텍스ID',
    		xtype: 'uniTextfield',
    		name: 'HOME_TAX_ID',
    		allowBlank: true
		},{
	    	xtype: 'container',
	    	padding: '10 0 0 0',
	    	layout: {
	    		type: 'vbox',
				align: 'center',
				pack:'center'
	    	},
	    	items:[{
	    		margin: '0 6 0 0',
				xtype: 'button',
				text: '실행',		
				width: 60,
	    		handler: function(){
	    			var mediumType = panelSearch.getValue("MEDIUM_TYPE");
	    			if(mediumType == "1"){
	    				hpb500ukrService.checkResidentBusiness(panelSearch.getValues(), function(responseText, response){
	    					if(responseText.length > 0)	{
	    						panelSearch.submit();
	    					} else {
	    						Unilite.messageBox("법인정보 또는 해당사원이 존재하지 않습니다.");
	    					}
	    				})
	    			}
	    			if(mediumType == "2"){
	    				hpb500ukrService.checkResidentEtc(panelSearch.getValues(), function(responseText, response){
	    					if(responseText.length > 0)	{
	    						panelSearch.submit();
	    					}else {
	    						Unilite.messageBox("법인정보 또는 해당사원이 존재하지 않습니다.");
	    					}
	    				})
	    			}
	    			if(mediumType == "3"){
	    				hpb500ukrService.checkNonResidentBusinessEtc(panelSearch.getValues(), function(responseText, response){
	    					if(responseText.length > 0)	{
	    						panelSearch.submit();
	    					}else {
	    						Unilite.messageBox("법인정보 또는 해당사원이 존재하지 않습니다.");
	    					}
	    				})
	    			}
	    			if(mediumType == "4"){
	    				hpb500ukrService.checkInterest(panelSearch.getValues(), function(responseText, response){
	    					if(responseText.length > 0)	{
	    						panelSearch.submit();
	    					}else {
	    						Unilite.messageBox("법인정보 또는 해당사원이 존재하지 않습니다.");
	    					}
	    				})
	    			}
	
	    		}
	    	}]
	    }]		
	});
		
	
	
    Unilite.Main( {
		items 	: [ panelSearch],
		id  : 'hpb500ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('qurey',false);
			
			panelSearch.setValue('HOMETAX_NO', '${hometaxId}');
			if(UniDate.getDbDateStr(UniDate.get('today')).substring(4, 8) <= '0228'){
				panelSearch.setValue('CAL_YEAR', (new Date().getFullYear() - 1));
			}else{
				panelSearch.setValue('CAL_YEAR', new Date().getFullYear());
			}
		}
	});

};


</script>
			