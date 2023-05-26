<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr140rkrv_sk"  >
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B079" />	<!-- 작업그룹 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	var masterForm = Unilite.createForm('masterForm', {
    	disabled :false,
    	region:'center',
	    padding: '1 1 1 1',
        layout : {type : 'uniTable', columns : 1},
		items: [
				{
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
						if(masterForm.getInvalidMessage())	{
							var param = '?DIV_CODE=' + masterForm.getValue('DIV_CODE')+'&PRODT_DT='+UniDate.getDbDateStr(masterForm.getValue('PRODT_DT'))+'&GROUP_CD='+masterForm.getValue('GROUP_CD')+'&TEMPLATE_TYPE='+masterForm.getValues().TEMPLATE_TYPE;
							window.open(CPATH + '/z_sk/s_pmr140rkrv_skExcelDown.do'+param);
						}
					} 
				}
	    ]
	});

	
	Unilite.Main({
		id: 's_pmr140rkrv_skApp',
		borderItems: [{
			id: 'pageAll',
			region: 'center',
			layout: 'border',
			border: false,
			items: [
				 masterForm
			]
		}],
		fnInitBinding: function() {
			masterForm.setValue("DIV_CODE", UserInfo.divCode);
			masterForm.setValue("TEMPLATE_TYPE", "1");
			UniAppManager.setToolbarButtons(['print','newData','delete','save','query'], false);
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			this.fnInitInputFields();
		}
	});

};
</script>