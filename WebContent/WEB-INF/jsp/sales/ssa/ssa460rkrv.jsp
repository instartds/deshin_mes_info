<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa460rkrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="ssa460rkrv"  /> 			<!-- 사업장 -->
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
			xtype: 'radiogroup',		            		
			fieldLabel: '<t:message code="system.label.sales.reporttype" default="보고서유형"/>',						            		
			items: [{
				boxLabel: '<t:message code="system.label.sales.sellingtypeby" default="판매유형별"/>', 
				width: 90, 
				name: 'rdoPrintItem',
				inputValue: '1',
				checked: true
			},{
				boxLabel : '대분류별', 
				width: 70,
				name: 'rdoPrintItem',
				inputValue: '2'
			}]
		},{	    
	    	fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
	    	name:'DIV_CODE',
	    	xtype: 'uniCombobox', 
	    	comboType:'BOR120', 
	    	allowBlank:false,
	    	value: UserInfo.divCode
    	},{
    		fieldLabel: '출고일자',
    		xtype: 'uniDateRangefield',
    		allowBlank:false,
    		startFieldName: 'FR_DATE',
    		endFieldName: 'TO_DATE',
    		startDate: UniDate.get('startOfMonth'),
    		endDate: UniDate.get('today'),
    		width:315
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '품목분류',						            		
			items: [{
				boxLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>', 
				width: 90, 
				name: 'opt',
				inputValue: '1',
                checked: true
			},{
				boxLabel : '<t:message code="system.label.sales.middlegroup" default="중분류"/>', 
				width: 70,
				name: 'opt',
				inputValue: '2'
			}]
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
		id  : 'ssa460rkrvApp',
		fnInitBinding : function() {
			panelResult.setValue('rdoPrintItem','1');
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
            panelResult.setValue('opt','1');
			
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
			if(param.rdoPrintItem=='1'){
				param.sPrintFlag = "SALE";
				param.sPrintFlagStr = "판매유형별";
				param["sTxtValue2_fileTitle"]='일일매출현황출력(판매유형별)';
				param["RPT_ID"]='ssa460rkrv1';
			}else{
				param.sPrintFlag = "LEVEL";
				param.sPrintFlagStr = "대분류별";
				param["sTxtValue2_fileTitle"]='일일매출현황출력(대분류별)';
				param["RPT_ID"]='ssa460rkrv2';
			}
			param["PGM_ID"]='ssa460rkrv';
			param.MONTH_BEGIN = UniDate.get("startOfMonth",param.FR_DATE);
			param.MONTH_END = UniDate.get("endOfMonth",param.FR_DATE);
			var date = panelResult.getValue('FR_DATE');
			param.sYear =date.getFullYear();
			param.iMonth =date.getMonth()+1;
    		
			var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/sales/ssa460crkrv.do',
                prgID: 'ssa460rkrv',
                extParam: param
            });
				win.center();
				win.show();
		}
	});
};

</script>
