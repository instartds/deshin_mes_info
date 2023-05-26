<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="aigd330ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> 			<!-- 부가세유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B002" />				<!-- 법인구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B012" />				<!-- 국가코드 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> 			<!-- 자사화폐 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
var	getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;								//당기시작월 관련 전역변수
	gsSlipDivi = '';
	gsAutoType = '';
	/* 감가상각계산 및 자동기표 Form
	 * 
	 * @type
	 */     
	var panelSearch = Unilite.createForm('aigd330ukrvDetail', {
    	disabled :false,
    	flex:1,
    	layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
    	items :[{
			fieldLabel	: '상각년월',
	        xtype		: 'uniMonthRangefield',
	        startFieldName: 'DPR_YYMM_FR',
	        endFieldName: 'DPR_YYMM_TO',
            startDate	: getStDt[0].STDT,
            endDate		: getStDt[0].TODT,
		  	colspan		: 2,
	        allowBlank	: false
	        
	     },{ 
			fieldLabel	: '사업장',
			name		: 'ACCNT_DIV_CODE',
			xtype		: 'uniCombobox',
			multiSelect	: true, 
			typeAhead	: false,
			value		: UserInfo.divCode,
		  	colspan		: 2,
			comboType	: 'BOR120'
		},{
			fieldLabel	: '전표일',
	        xtype		: 'uniDatefield',
	 		name		: 'EX_DATE',
	 		value		: UniDate.get('today')
		},{
			xtype: 'container',
	    	items:[{
	    		xtype: 'button',
	    		text: '실행',
	    		width: 60,
	    		margin: '0 0 0 120',	
				handler : function() {
					if(!panelSearch.getInvalidMessage()){
						return false;
					}else{					
						var param = panelSearch.getValues();
						param.AUTO_TYPE = gsAutoType;
						if(!Ext.isEmpty(getStDt[0]) ){
							var frDate = panelSearch.getValue("DPR_YYMM_FR");
							if(Ext.isDate(frDate))	{
					        	if(!Ext.isEmpty(getStDt[0].STDT) && UniDate.getMonthStr(frDate) < UniDate.getMonthStr(UniDate.extParseDate(getStDt[0].STDT)))	{
					        		Unilite.messageBox("상각년월은 회사정보에 등록된 회계기간에 속해야 합니다.["+Ext.Date.format(UniDate.extParseDate(getStDt[0].STDT), 'Y.m')+"~"+Ext.Date.format(UniDate.extParseDate(getStDt[0].TODT), 'Y.m')+"]")
					        		panelSearch.getField("DPR_YYMM_FR").focus()
					        		return;
					        	}
							}
							var toDate = panelSearch.getValue("DPR_YYMM_TO");
				        	if(Ext.isDate(toDate))	{
					        	if(!Ext.isEmpty(getStDt[0].TODT) && UniDate.getMonthStr(toDate) > UniDate.getMonthStr(UniDate.extParseDate(getStDt[0].TODT)))	{
					        		Unilite.messageBox("상각년월은 회사정보에 등록된 회계기간에 속해야 합니다.["+Ext.Date.format(UniDate.extParseDate(getStDt[0].STDT), 'Y.m')+"~"+Ext.Date.format(UniDate.extParseDate(getStDt[0].TODT), 'Y.m')+"]")
					        		panelSearch.getField("DPR_YYMM_TO").focus()
					        		return;
					        	}
				        	}
			        	}
						
						if(Ext.isEmpty(panelSearch.getValue("EX_DATE")))	{
							Unilite.messageBox("전표일은 필수 입력입니다.");
							return;	
						}
						panelSearch.getEl().mask('로딩중...','loading-indicator');
						aigd330ukrvService.procButton(param, function(provider, response) {
							if(provider) {	
								UniAppManager.updateStatus("자동기표가 생성 되었습니다.");
							}
							panelSearch.getEl().unmask();
						})
					}
				}
			},{
	    		xtype: 'button',
	    		text: '취소',
	    		width: 60,
	    		margin: '0 0 0 0',                                                       
				handler : function() {
					if(!panelSearch.getInvalidMessage()){
						return false;
					}else{					
						var param = panelSearch.getValues();
						panelSearch.getEl().mask('로딩중...','loading-indicator');
						aigd330ukrvService.cancButton(param, 
							function(provider, response) {
								if(provider) {	
									UniAppManager.updateStatus("취소 되었습니다.");
								}
								console.log("response",response)
								panelSearch.getEl().unmask();
							}
						)
					}
				}
    		}]
		},{
			fieldLabel	: '입력일',
	        xtype		: 'uniDatefield',
	 		name		: 'INPUT_DATE',
	 		value		: UniDate.get('today'),
	 		readOnly	: true,
	 		hidden		: true
		}]
	});

    /**
	 * main app
	 */
    Unilite.Main( {
		id  : 'aigd330ukrvApp',
		items 	: [ panelSearch],
		fnInitBinding : function() {
			var param =  {};
			aigd330ukrvService.getRefCode(param, function(provider, response){
				gsSlipDivi = provider[0].REF_CODE1	//전표기준 1 : AGJ100T, 2 : AIGJ210T
				gsAutoType = provider[0].REF_CODE2	//감가상각비자동기표 분개 방식 (1:batch, 2:분개화면 거쳐 저장)
			});
			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			var activeSForm = panelSearch;
			activeSForm.onLoadSelectText('DPR_YYMM_FR');
		}
	});
}
</script>
