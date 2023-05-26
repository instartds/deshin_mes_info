<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="txt100ukrv"  >	
	<t:ExtComboStore comboType="BOR120" /> 			<!-- 사업장 -->  
</t:appConfig>
<script type="text/javascript" >
function appMain() { 

	var panelSearch = Unilite.createForm('biv150ukrv', {		
		disabled :false
        , flex:1        
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	    , items :[{
				xtype: 'uniTextfield',
				fieldLabel: '최종적용',
				name: 'TXT_YYYY1',
				readOnly: true
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '학기',
				name: 'TXT_SEQ1',
				readOnly: true
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '학년도',
				name: 'TXT_YYYY2',
		 		enforceMaxLength: true,
		 		maxLength: '4',
				allowBlank: false
			},{
				fieldLabel: '학기',
				name: 'TXT_SEQ2',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'YP27',
				holdable: 'hold'	
			},{
	        	margin: '0 0 0 23',
				xtype: 'button',
				id: 'startButton',
				text: '실행',	
	        	width: 80,
	        	tdAttrs:{'align':'center'},							   	
				handler : function() {
					if(panelSearch.getForm().isValid()) {
						if(confirm(Msg.sMB063)) {
							panelSearch.getEl().mask('로딩중...','loading-indicator');
							var param= panelSearch.getValues();	
							var param2= {
								'HYHG': panelSearch.getValue('TXT_YYYY2') + panelSearch.getValue('TXT_SEQ2')
							};
							var params = Ext.merge(param, param2);
							var me = this;
							me.setDisabled(true);
							txt100ukrvService.insertMaster(params, function(provider, response) {
								alert(Msg.sMB021);
								me.setDisabled(false);
								panelSearch.getEl().unmask();
							});
						} else {
				   			
						}
					}
				}
			}]
	});

    Unilite.Main({
		items:[panelSearch],
		id: 'txt100ukrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['query', 'detail', 'reset'],false);

		}

	});
	
};
</script>
