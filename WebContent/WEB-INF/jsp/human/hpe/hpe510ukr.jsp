<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="hpe510ukr">
	<t:ExtComboStore comboType="BOR120"		pgmId="hpe510ukr"/>			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU"			comboCode="H222" opts='2'/>			<!-- 전산매체유형 -->
</t:appConfig>

<script type="text/javascript" >
function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm', {
		region : 'center',
		layout : {type : 'uniTable', columns : 1},
		padding: '1 1 1 1',
		border : false,
		defaults: {labelWidth: 100},
		url: CPATH+'/human/hpe510ukrFileDown.do',
		standardSubmit: true,
		items: [{
			html	: '&nbsp;',
			xtype	: 'component'
		},{
			fieldLabel	: '전산매체유형',
			xtype		: 'uniCombobox',
			name		: 'DATA_FLAG',
			comboType	: 'AU',
			comboCode	: 'H222',
			allowBlank	: false
		},{
			fieldLabel	: '지급월',
			xtype		: 'uniMonthfield',
			name		: 'TAX_YYYYMM',
			value		: new Date(),
			allowBlank	: false
		},{
			fieldLabel	: '제출일',
			xtype		: 'uniDatefield',
			name		: 'SUBMIT_DATE',
			value		: UniDate.get('today'),
			allowBlank	: false
		},{
			fieldLabel	: '신고사업장',
			xtype		: 'uniCombobox',
			name		: 'DIV_CODE',
			comboType	: 'BOR120',
			allowBlank	: false
		},{
			fieldLabel	: '관리번호',
			xtype		: 'uniTextfield',
			name		: 'TAX_AGENT_NO',
			enforceMaxLength: true,
			maxLength	: 6
		},{
			fieldLabel	: '홈택스 ID',
			name		: 'HOMETAX_NO',
			xtype		: 'uniTextfield',
			allowBlank	: false
		},{
			xtype: 'button',
			text: '실행',
			width: 150,
			margin: '0 0 0 105',
			handler : function() {
				var panel = Ext.getCmp('resultForm');
				
				// validation check
				if(!panel.getInvalidMessage()){
					return false;
				}
				
				// 지급명세서 조회
				var param = panelResult.getValues();
				hpe510ukrService.fnCheckData(param, function(provider, response) {
					if(provider) {
						// 파일 생성
						panel.submit({
							params : param
						});
					}
				});
	    	}
		}]
	});
	
	Unilite.Main({
		borderItems:[{
			region : 'center',
			layout : 'border',
			border : false,
			items:[ panelResult ]}
		],
		id : 'hpe510ukrApp',
		fnInitBinding : function() {
			panelResult.setValue('DATA_FLAG', '2');
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('SUBMIT_DATE', UniDate.get('today'));
			
			panelResult.setValue('TAX_YYYYMM', UniDate.get('aMonthAgo'));
			//aMonthAgo

			UniAppManager.setToolbarButtons(['query','reset'],false);
		}
	});
}
</script>
