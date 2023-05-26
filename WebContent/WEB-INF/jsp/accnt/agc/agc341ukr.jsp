<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc341ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    
	var detailForm = Unilite.createForm('agc341ukrvDetail', {
    	disabled :false,
        flex:1,        
        layout: {type: 'uniTable', columns: 2, tdAttrs: {valign:'top'}},
		items :[{ 
			fieldLabel: '실행월',
	        xtype: 'uniMonthRangefield',
	        startFieldName: 'FR_AC_DATE',
	        endFieldName: 'TO_AC_DATE',
	        width: 470,
	        startDate: UniDate.get('today'),
	        endDate: UniDate.get('endOfMonth'),
		  	colspan: 2,
//		  	endDD:'last',
	        allowBlank: false,
	        onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(detailForm) {
                	var tempDate = UniDate.getDbDateStr(newValue).substring(0,6) + '01';
                	    tempDate = tempDate.substring(0,4) + '/' + tempDate.substring(4,6) + '/' + tempDate.substring(6,8);
                    var transDate = new Date(tempDate);
                	var sSendDate = UniDate.getDbDateStr(UniDate.add((UniDate.add(transDate, {months: +1})), {days: -1}));
                    detailForm.setValue('AC_DATE', sSendDate);
                    
                }
            }
		},{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
//	        allowBlank: false,
			value : UserInfo.divCode,
		  	colspan: 2,
			comboType: 'BOR120'
		},{
			fieldLabel: '전표일',
	        xtype: 'uniDatefield',
	 		name: 'AC_DATE',
//	 		value: UniDate.get('today'),
		  	colspan: 2,
	        allowBlank: false
	     },{
			xtype: 'container',
	    	items:[{
	    		xtype: 'button',
	    		text: '실행',
	    		width: 60,
	    		margin: '0 0 0 120',	
				handler : function() {
					if(!detailForm.getInvalidMessage()) return false;
					var param = {
                        DIV_CODE: detailForm.getValue('DIV_CODE'),
                        FR_AC_DATE  : UniDate.getDbDateStr(detailForm.getValue('FR_AC_DATE')),
                        TO_AC_DATE  : UniDate.getDbDateStr(detailForm.getValue('TO_AC_DATE')),
                        AC_DATE  : UniDate.getDbDateStr(detailForm.getValue('AC_DATE'))
                    }
                    detailForm.getEl().mask('자동기표 실행중...','loading-indicator');
                    agc341ukrService.spUspAccntAutoSlip58(param, function(provider, response)  {                           
                        if(provider){   
                            UniAppManager.updateStatus(Msg.sMA0328);     
                        }
                        detailForm.getEl().unmask();  
                        
                    });
                    
				}
	    	},{
	    		xtype: 'button',
	    		text: '취소',
	    		width: 60,
	    		margin: '0 0 0 0',                                                       
				handler : function() {
                    if(!detailForm.getInvalidMessage()) return false;
                    var param = {
                        DIV_CODE: detailForm.getValue('DIV_CODE'),
                        FR_AC_DATE  : UniDate.getDbDateStr(detailForm.getValue('FR_AC_DATE')),
                        TO_AC_DATE  : UniDate.getDbDateStr(detailForm.getValue('TO_AC_DATE')),
                        AC_DATE  : UniDate.getDbDateStr(detailForm.getValue('AC_DATE'))
                    }
                    detailForm.getEl().mask('자동기표 취소중...','loading-indicator');
                    agc341ukrService.spUspAccntAutoSlip58Cancel(param, function(provider, response)  {                           
                        if(provider){   
                            UniAppManager.updateStatus(Msg.sMA0329);     
                        }
                        detailForm.getEl().unmask();  
                        
                    });
                }
    		}]
		}]		
	});    
	
    Unilite.Main( {
		id  : 'agc341ukrApp',
		items:[detailForm],
		fnInitBinding : function() {
			detailForm.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['query','reset','save'],false);
			
			var activeSForm = detailForm;
			activeSForm.onLoadSelectText('FR_AC_DATE');
			
			var tempDateInit = UniDate.getDbDateStr(detailForm.getValue('TO_AC_DATE')).substring(0,6) + '01';
                tempDateInit = tempDateInit.substring(0,4) + '/' + tempDateInit.substring(4,6) + '/' + tempDateInit.substring(6,8);
            var transDateInit = new Date(tempDateInit);
            var sSendDateInit = UniDate.getDbDateStr(UniDate.add((UniDate.add(transDateInit, {months: +1})), {days: -1}));
            detailForm.setValue('AC_DATE', sSendDateInit);
		}
	});
};


</script>
