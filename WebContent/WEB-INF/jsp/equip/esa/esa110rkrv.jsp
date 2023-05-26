<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="esa110rkrv"  >
<t:ExtComboStore comboType="AU" comboCode="S801" />
<t:ExtComboStore comboType="AU" comboCode="S802" />
<t:ExtComboStore comboType="AU" comboCode="S804" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'center',
//    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items: [{
    		fieldLabel: '접수일',
    		xtype: 'uniDateRangefield',
    		startFieldName: 'FR_DATE',
    		endFieldName: 'TO_DATE',
    		startDate: UniDate.get('startOfMonth'),
    		endDate: UniDate.get('today'),
    		width:315,
    		allowBlank:false
		},Unilite.popup('CUST',{
            fieldLabel: '고객',
            valueFieldName:'CUSTOM_CODE',
            textFieldName:'CUSTOM_NAME'
        }),{
			fieldLabel: '접수구분',
			name: 'ACCEPT_GUBUN',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'S801'
		},{
			fieldLabel: '유무상구분',
			name: 'BEFORE_PAY_YN',
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

    
    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult
			]
		}],	
		id  : 'esa110rkrvApp',
		fnInitBinding : function() {

			panelResult.setValue('FR_DATE',UniDate.get('aMonthAgo'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('print',true);
			UniAppManager.setToolbarButtons('query',false);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			this.fnInitBinding();
		},
        onPrintButtonDown: function() {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
			var param = panelResult.getValues();
			
			param["sTxtValue2_fileTitle"]='A/S 접수현황';
			param["RPT_ID"]='esa110rkrv';
			param["PGM_ID"]='esa110rkrv';
			var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/equit/esa110crkrv.do',
                prgID: 'esa110rkrv',
                extParam: param
            });
				win.center();
				win.show();
        	
		}
	});
};

</script>
