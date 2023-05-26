<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="esa100rkrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수-->
	<t:ExtComboStore comboType="AU" comboCode="B012" /><!--국가코드 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;};  
#ext-element-3 {align:center}
</style>

<script type="text/javascript" >
function appMain() {  
	var panelResult = Unilite.createSearchForm('esa100rkrvForm', {
        region: 'center',
        padding:'1 1 1 1',
        border:false,
        layout : {type : 'uniTable', columns : 1},
        items :[
			Unilite.popup('AS_NUM', {
				fieldLabel: '접수번호',
				valueFieldName:'AS_NUM',
                textFieldName:'AS_NUM',
                allowBlank: false
			}),{
				fieldLabel: '접수일',
 		        width: 315,
 		        allowBlank: false,
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_DATE',
                endFieldName: 'TO_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
			},{
				fieldLabel: '접수구분',
				name: 'ACCEPT_GUBUN',
				xtype:'uniCombobox',
				comboType:'AU', 
				comboCode:'S801'
			},{
				fieldLabel: '유무상구분',
				name: 'PAY_YN',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'S802'
			},{
				fieldLabel: '진행상태',
				name: 'FINISH_YN',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'S804'
			}]
	});
	 Unilite.Main( {
	 	border: false,
	 	items: [panelResult],
		id : 'esa100rkrvApp',
		fnInitBinding : function() {
			panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_DATE', UniDate.get('today'));
            
			UniAppManager.setToolbarButtons('print',true);
			UniAppManager.setToolbarButtons('query',false);
		},
		onResetButtonDown : function() {
			panelResult.clearForm();
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
			var param = panelResult.getForm().getValues();
			
			
            param["sTxtValue2_fileTitle"]='A/S 처리결과';
			var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/sales/esa100crkrv.do',
                prgID: 'esa100rkrv',
                extParam: param
            });
			win.center();
			win.show();
		}
	});
		
};
</script>