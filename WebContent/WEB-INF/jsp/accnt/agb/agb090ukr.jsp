<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb090ukr">
	<t:ExtComboStore comboType="BOR120" pgmId="agb090ukr"/>		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A074"/>			<!-- 지급분기 -->
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createForm('searchForm', {
		disabled: false,
		flex	: 1,
		layout	: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
		items	: [{ 
			fieldLabel		: '기준일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			startDate		: UniDate.get('startOfYear'),
			endDate			: UniDate.get('endOfYear'),
			width			: 470,
			labelWidth		: 100
		},{
			fieldLabel		: '총계정원장',
			name			: 'AGB100T_YN',
			xtype			: 'checkbox',
			checked			: true,
			inputValue		: 'Y',
	 		uncheckedValue	: 'N',
			labelWidth		: 100
		},{
			fieldLabel		: '계정잔액원장',
			name			: 'AGB200T_YN',
			xtype			: 'checkbox',
			checked			: true,
			inputValue		: 'Y',
	 		uncheckedValue	: 'N',
			labelWidth		: 100
		},{
			fieldLabel		: '예적금현황',
			name			: 'AGB500T_YN',
			xtype			: 'checkbox',
			checked			: true,
	 		inputValue		: 'Y',
	 		uncheckedValue	: 'N',
			labelWidth		: 100
		},{
			fieldLabel		: '예산실적',
			name			: 'AFB110T_YN',
			xtype			: 'checkbox',
			inputValue		: 'Y',
	 		uncheckedValue	: 'N',
	 		hidden			: true,
			labelWidth		: 100
		},{
			xtype	: 'container',
			padding	: '10 0 0 0',
			layout	: {
				type	: 'vbox',
				align	: 'center',
				pack	: 'center'
			},
			items	: [{
				xtype	: 'button',
				margin	: '0 6 0 0',
				text	: '실행',
				width	: 60,
				handler	: function(){
					
					var param	= panelSearch.getValues();
					
					// validation check
					if(!panelSearch.getInvalidMessage()) {
						return false;
					}
					
					Ext.getBody().mask('로딩중...','loading-indicator');
					agb090ukrService.fnCheckData(param, function(provider, response) {
						
						if(provider) {
							UniAppManager.updateStatus("완료 되었습니다.");
						}
						Ext.getBody().unmask();
					});
					
				}
			}]
		}]
	});

	Unilite.Main({
		id		: 'agb090ukrApp',
		items	: [ panelSearch],
		fnInitBinding : function() {

			UniAppManager.setToolbarButtons(['detail','reset','query'],false); // button enable false 처리
		}
	});
};
</script>