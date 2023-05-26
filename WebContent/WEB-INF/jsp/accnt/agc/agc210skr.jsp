<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="agc210ukrv"  >
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
	var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;               //당기시작월 관련 전역변수
	
	var panelSearch = Unilite.createForm('agc210ukrvDetail', {
    	disabled	: false,
    	flex		: 1,
    	layout		: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
    	items		: [{
            fieldLabel: '전표일',
            xtype: 'uniDateRangefield',
            startFieldName: 'AC_DATE_FR',
            endFieldName: 'AC_DATE_TO',
//            startDate: UniDate.get('startOfYear'),
//            endDate: UniDate.get('endOfYear'),
            allowBlank:false,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
				UniAppManager.app.fnSetStDate(newValue);
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    }
         },{
            fieldLabel: '사업장',
            name:'DIV_CODE', 
            xtype: 'uniCombobox',
            multiSelect: true, 
            typeAhead: false,
            comboType:'BOR120',
            width: 325,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        },
        Unilite.popup('ACCNT',{
            fieldLabel: '계정과목',
            validateBlank:false,
            valueFieldName:'ACCNT_CODE_FR',
            textFieldName:'ACCNT_NAME_FR',
            listeners: {
                applyextparam: function(popup){
                }
            }
        }),
        Unilite.popup('ACCNT',{
            fieldLabel: '~',
            validateBlank:false,  
            valueFieldName:'ACCNT_CODE_TO',
            textFieldName:'ACCNT_NAME_TO',
            listeners: {
                applyextparam: function(popup){
                }
            }
        }),{
            fieldLabel: '당기시작년월',
            name: 'START_DATE',
            xtype: 'uniMonthfield',
            allowBlank: false
        },{
            margin: '10 0 0 6',
            xtype: 'button',
            id: 'startButton',
            text: '엑셀다운', 
            width: 120,
            tdAttrs:{'align':'center'},                             
            handler : function() {  
				if(!panelSearch.getInvalidMessage()){
					return false;
				}
                var form = panelFileDown;

                form.setValue('AC_DATE_FR',    UniDate.getDbDateStr(panelSearch.getValue('AC_DATE_FR')));
                form.setValue('AC_DATE_TO',    UniDate.getDbDateStr(panelSearch.getValue('AC_DATE_TO')));
                form.setValue('DIV_CODE',      panelSearch.getValue('DIV_CODE'));
                form.setValue('ACCNT_CODE_FR', panelSearch.getValue('ACCNT_CODE_FR'));
                form.setValue('ACCNT_NAME_FR', panelSearch.getValue('ACCNT_NAME_FR'));
                form.setValue('ACCNT_CODE_TO', panelSearch.getValue('ACCNT_CODE_TO'));
                form.setValue('ACCNT_NAME_TO', panelSearch.getValue('ACCNT_NAME_TO'));
                form.setValue('START_DATE',    UniDate.getDbDateStr(panelSearch.getValue('START_DATE')).substring(0, 6));
                
                var param = form.getValues();
                
                form.submit({
                    params: param,
                    success:function(comp, action)  {
                        Ext.getBody().unmask();
                    },
                    failure: function(form, action){
                        Ext.getBody().unmask();
                    }                   
                }); 
            }
        }]
	});

    var panelFileDown = Unilite.createForm('ExcelFileDownForm', {
        url: CPATH+'/accnt/agc210excel.do',
        colspan: 2,
        layout: {type: 'uniTable', columns: 1},
        height: 30,
        padding: '0 0 0 0',
        disabled:false,
        autoScroll: false,
        standardSubmit: true,  
        items:[{
            xtype: 'uniTextfield',
            name: 'AC_DATE_FR'
        },{
            xtype: 'uniTextfield',
            name: 'AC_DATE_TO'
        },{
            xtype: 'uniTextfield',
            name: 'DIV_CODE'
        },{
            xtype: 'uniTextfield',
            name: 'ACCNT_CODE_FR'
        },{
            xtype: 'uniTextfield',
            name: 'ACCNT_NAME_FR'
        },{
            xtype: 'uniTextfield',
            name: 'ACCNT_CODE_TO'
        },{
            xtype: 'uniTextfield',
            name: 'ACCNT_NAME_TO'
        },{
            xtype: 'uniTextfield',
            name: 'START_DATE'
        }]
    });

    
    Unilite.Main( {
		id		: 'agc210ukrvApp',
		items	: [ panelSearch ],
		
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			
			var activeSForm = panelSearch;
			activeSForm.onLoadSelectText('AC_DATE_FR');
			
//            startDate: UniDate.get('startOfYear'),
//            endDate: UniDate.get('endOfYear'),
			
            panelSearch.setValue('START_DATE', getStDt[0].STDT);
            panelSearch.setValue('AC_DATE_FR', getStDt[0].STDT);
            panelSearch.setValue('AC_DATE_TO', UniDate.get('endOfYear'));
		},
		
		//당기시작월 세팅
		fnSetStDate: function(newValue) {
        	if(newValue == null){
				return false;
				
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
        }
	});
}
</script>
