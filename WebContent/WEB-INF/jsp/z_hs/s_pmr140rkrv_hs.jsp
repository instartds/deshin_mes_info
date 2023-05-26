<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr140rkrv_hs"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmr140rkrv_hs"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B079" />	<!-- 작업그룹 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'center',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items: [{
					fieldLabel : '사업장',
					xtype : 'uniCombobox',
					name : 'DIV_CODE',
					comboType : 'BOR120',
					allowBlank : false
				},{
					fieldLabel : '작업일',
					xtype : 'uniDatefield',
					name : 'PRODT_DT',
					value : UniDate.today(),
					allowBlank : false
				},{
					fieldLabel : '작업그룹',
					xtype : 'uniCombobox',
					name : 'GROUP_CD',
					comboType : 'AU',
					comboCode : 'B079',
					allowBlank : false
				},{
					fieldLabel : '출력선택',
					xtype : 'radiogroup',
					layout:'vbox',
					allowBlank : false,
					items: [{
		    			boxLabel : '공장업무일지',
		    			width : 100,
		    			name : 'TEMPLATE_TYPE',
		    			inputValue : '1',
		    			checked: true
		    		}, {
		    			boxLabel : '제품,원재료 수불명세서',
		    			width : 150,
		    			name : 'TEMPLATE_TYPE',
		    			inputValue : '2'
		    		}]
				},{
					xtype : 'button',
					text : '출력',
					width : 120,
					tdAttrs : { style : 'padding-left : 90px;'},
					handler : function()	{
						if(panelResult.getInvalidMessage())	{
							var param = '?DIV_CODE=' + panelResult.getValue('DIV_CODE')+'&PRODT_DT='+UniDate.getDbDateStr(panelResult.getValue('PRODT_DT'))+'&GROUP_CD='+panelResult.getValue('GROUP_CD')+'&TEMPLATE_TYPE='+panelResult.getValues().TEMPLATE_TYPE;
							window.open(CPATH + '/z_hs/s_pmr140rkrv_hsExcelDown.do'+param);
						}
					} 
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
		id  : 's_pmr140rkrv_hs',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue("TEMPLATE_TYPE", "1");
			UniAppManager.setToolbarButtons(['print','newData','delete','save','query'], false);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			this.fnInitBinding();
		}
	});
};

</script>