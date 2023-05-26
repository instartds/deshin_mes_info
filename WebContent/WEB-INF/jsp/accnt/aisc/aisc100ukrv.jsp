<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="aisc100ukrv"  >
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
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
	/* 감가상각계산 및 자동기표 Form
	 * 
	 * @type
	 */     
	var panelSearch = Unilite.createForm('aisc100ukrvDetail', {
    	disabled :false,
    	flex:1,
    	layout: {type: 'uniTable', columns: 2, tdAttrs: {valign:'top'}},
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
		},
			Unilite.popup('IFRS_ASSET', {
			fieldLabel		: '자산코드', 
			valueFieldWidth	: 80,
		    textFieldWidth	: 150,
			valueFieldName	: 'ASSET_CODE_FR', 
			textFieldName	: 'ASSET_NAME_FR', 
			autoPopup		: true,
			listeners		: {
				onSelected: {
				},
				onClear: function(type)	{
				},
				applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                            'ACCNT_DIV_CODE': panelSearch.getValue('ACCNT_DIV_CODE')
                        }
                        popup.setExtParam(param);
                    }
                }
			}
		}),
			Unilite.popup('IFRS_ASSET',{ 
			fieldLabel		: '~', 
			labelWidth		: 20,
			width			: 300,
			valueFieldWidth	: 80,
		    textFieldWidth	: 150,
			valueFieldName	: 'ASSET_CODE_TO', 
			textFieldName	: 'ASSET_NAME_TO', 
			popupWidth		: 710,
			autoPopup		: true,
			listeners: {
				onSelected: {
				},
				onClear: function(type)	{
				},
				applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                            'ACCNT_DIV_CODE': panelSearch.getValue('ACCNT_DIV_CODE')
                        }
                        popup.setExtParam(param);
                    }
                }
			}
		}),		    
	    	Unilite.popup('ACCNT',{
	    	fieldLabel		: '계정과목',
	    	valueFieldName	: 'ACCNT_CODE_FR',
	    	textFieldName	: 'ACCNT_NAME_FR',
	    	autoPopup		: true,
            tdAttrs			: {width: 300},  
			listeners		: {
                applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                            'ADD_QUERY' : "SPEC_DIVI IN ('K')",
                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
			}
	    }),	    
	    	Unilite.popup('ACCNT',{
	    		fieldLabel		: '~', 
				labelWidth		: 20,
				valueFieldName	: 'ACCNT_CODE_TO',
		    	textFieldName	: 'ACCNT_NAME_TO',  	
		    	autoPopup		: true,
			    listeners     : {
	                applyExtParam:{
	                    scope:this,
	                    fn:function(popup){
	                        var param = {
	                            'ADD_QUERY' : "SPEC_DIVI IN ('K')",
	                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
	                        }
	                        popup.setExtParam(param);
	                    }
	                }
            }
    	}),
			Unilite.popup('AC_PROJECT',{ 
		    fieldLabel		: '사업코드', 
		    valueFieldWidth	: 80,
		    textFieldWidth	: 150,
			valueFieldName	: 'PJT_CODE_FR', 
			textFieldName	: 'PJT_NAME_FR', 
		    validateBlank	: false,
		    autoPopup		: true
		}),   	
			Unilite.popup('AC_PROJECT',{ 
			fieldLabel		: '~', 
			valueFieldWidth	: 80,
		    textFieldWidth	: 150,
			labelWidth		: 20,
			valueFieldName	: 'PJT_CODE_TO', 
			textFieldName	: 'PJT_NAME_TO', 
			validateBlank	: false ,
		    autoPopup		: true
		}),{
			xtype: 'container',
			colspan:2,
			tdAttrs:{style:'padding-left:265px'},
	    	items:[{
	    		xtype: 'button',
	    		text: '실행',
	    		width: 60,
	    		margin: '5 5 5 5',	
				handler : function() {
					if(!panelSearch.getInvalidMessage()){
						return false;
					}else{					
						var param = panelSearch.getValues();
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
						
						panelSearch.getEl().mask('로딩중...','loading-indicator');
						aisc100ukrvService.procButton(param, function(provider, response) {
							if(provider) {
									UniAppManager.updateStatus("감각상각계산이 완료 되었습니다.");
							}
							console.log("response",response)
							panelSearch.getEl().unmask();
						})
					}
				}
			},{
	    		xtype: 'button',
	    		text: '취소',
	    		width: 60,
	    		margin: '5 5 5 5',                                                       
				handler : function() {
					if(!panelSearch.getInvalidMessage()){
						return false;
					}else{					
						var param = panelSearch.getValues();
						panelSearch.getEl().mask('로딩중...','loading-indicator');
						aisc100ukrvService.cancButton(param, 
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
		id  : 'aisc100ukrvApp',
		items 	: [ panelSearch],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			var activeSForm = panelSearch;
			activeSForm.onLoadSelectText('DPR_YYMM_FR');
		}
	});
}
</script>
