<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="agd260ukrv"  >
<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->
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
	/* 매출자동기표 Form
	 * 
	 * @type
	 */     
	var panelSearch = Unilite.createForm('agd260ukrvDetail', {
    	disabled	: false,
    	flex		: 1,
    	layout		: {type: 'uniTable', columns: 2, tdAttrs: {valign:'top'}},
    	items		: [{
			fieldLabel	: '실행월',
	        startFieldName: 'SLIP_DATE_FR',
	        endFieldName: 'SLIP_DATE_TO',
	        xtype		: 'uniMonthRangefield',
	        startDate	: UniDate.get('startOfMonth'),
	        endDate		: UniDate.get('endOfMonth'),
		  	colspan		: 2,
	        allowBlank	: false,
	        onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                	var tempDate = UniDate.getDbDateStr(newValue).substring(0,6) + '01';
                	    tempDate = tempDate.substring(0,4) + '/' + tempDate.substring(4,6) + '/' + tempDate.substring(6,8);
                    var transDate = new Date(tempDate);
                	var sSendDate = UniDate.getDbDateStr(UniDate.add((UniDate.add(transDate, {months: +1})), {days: -1}));
                    panelSearch.setValue('EX_DATE', sSendDate);
                }
            }
	     },{ 
			fieldLabel	: '사업장',
			name		: 'ACCNT_DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			multiSelect	: false, 
			typeAhead	: false,
			value		: UserInfo.divCode,
		  	colspan		: 2
		},{
			fieldLabel	: '전표일',
	        xtype		: 'uniDatefield',
	 		name		: 'EX_DATE',
	 		value		: UniDate.get('today'),
	 		readOnly	: true,
	        allowBlank	: false,
		  	colspan		: 2
	     },{
	     	xtype		: 'component',
	     	height		: 5,
	     	colspan		: 2
	     },{
			xtype: 'container',
	    	items:[{
	    		xtype	: 'button',
	    		text	: '실행',
	    		width	: 60,
	    		margin	: '0 0 0 120',	
				handler : function() {
					if(!panelSearch.getInvalidMessage()){						//자동기표 전 필수 입력값 체크
						return false;
					}
					var param = panelSearch.getValues();
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					agd260ukrService.procButton(param, 
						function(provider, response) {
							if(provider) {	
								UniAppManager.updateStatus("자동기표가 완료 되었습니다.");
							}
							console.log("response",response)
							panelSearch.getEl().unmask();
						}
					)
				}
	    	},{
	    		xtype	: 'button',
	    		text	: '취소',
	    		width	: 60,
	    		margin	: '0 0 0 0',                                                       
				handler : function() {
					if(!panelSearch.getInvalidMessage()){						//기표취소 전 필수 입력값 체크
						return false;
					}
					var param = panelSearch.getValues();
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					agd260ukrService.cancButton(param, 
						function(provider, response) {
							if(provider) {	
								UniAppManager.updateStatus("취소 되었습니다.");
							}
							console.log("response",response)
							panelSearch.getEl().unmask();
						}
					)
				}
    		}]
		}]
	});


    Unilite.Main( {
		id		: 'agd260ukrvApp',
		items	: [ panelSearch ],
		
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			var activeSForm = panelSearch;
			activeSForm.onLoadSelectText('SLIP_DATE_FR');
			
			var tempDate = UniDate.getDbDateStr(panelSearch.getValue('SLIP_DATE_TO')).substring(0,6) + '01';
        	    tempDate = tempDate.substring(0,4) + '/' + tempDate.substring(4,6) + '/' + tempDate.substring(6,8);
            var transDate = new Date(tempDate);
        	var sSendDate = UniDate.getDbDateStr(UniDate.add((UniDate.add(transDate, {months: +1})), {days: -1}));
            panelSearch.setValue('EX_DATE', sSendDate);
		}
	});
}
</script>
