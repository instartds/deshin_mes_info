<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<t:appConfig pgmId="hpe500ukr">
	<t:ExtComboStore comboType="BOR120"	pgmId="hpe500ukr"/>			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU"	comboCode="H222" opts='1;3'/>	<!-- 전산매체유형 -->
</t:appConfig>

<script type="text/javascript" >
function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm', {
		region : 'center',
		layout : {type : 'uniTable', columns : 1},
		padding: '1 1 1 1',
		border : true,
		defaults: {labelWidth: 100},
		url: CPATH+'/human/hpe500ukrFileDown.do',
		standardSubmit: true,
		items: [{
			html:'&nbsp;',
			xtype: 'component'
		},{
			fieldLabel: '전산매체유형',
			name:'DATA_FLAG',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'H222',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '정산년도',
			xtype: 'uniYearField',
			name: 'YEAR_YYYY',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelSearch.setValue('YEAR_YYYY', newValue);
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '반기구분',
			id:'rdoHalfYearR',
			allowBlank:false,
			items: [{
				boxLabel: '상반기',
				width: 70,
				name: 'HALF_YEAR',
				inputValue: '1'
			},{
				boxLabel : '하반기',
				width: 70,
				name: 'HALF_YEAR',
				inputValue: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelSearch.getField('HALF_YEAR').setValue(newValue);
				}
			}
		},{
			fieldLabel: '제출일',
			name:'SUBMIT_DATE',
			xtype: 'uniDatefield',
			allowBlank:false,
			value: UniDate.get('today')
		},{
			fieldLabel: '신고사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '관리번호',
			name:'TAX_AGENT_NO',
			xtype: 'uniTextfield'
		},{
			fieldLabel: '홈택스 ID',
			name:'HOMETAX_ID',
			xtype: 'uniTextfield',
			allowBlank:false
		},{
			xtype: 'button',
			text: '실행',
			width: 150,
			margin: '0 0 0 105',
			handler : function() {
				var panel = Ext.getCmp('resultForm');
				if(!panel.getInvalidMessage()){
					return false;
				}
				var param = panel.getValues();
				hpe500ukrService.fnCheckData(param, function(provider, response) {
					if(provider) {
						panel.submit({
							params : param
						});
					}
				});
			}
		}]
	});


	Unilite.Main({
		id			: 'hpe500ukrApp',
		border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult
			]}
		],
		fnInitBinding : function() {
			panelResult.setValue('DATA_FLAG'	, '1');
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('YEAR_YYYY'	, UniDate.add(UniDate.today(),{'months':-1} ).getFullYear());
			panelResult.setValue('SUBMIT_DATE'	, UniDate.get('today'));

			var month		= Ext.Date.format(UniDate.add(UniDate.today(),{'months':-1} ),'n');
			var halfYear	= '1';
			if(month > 6) {
				halfYear = '2';
			}
			panelResult.getField('HALF_YEAR').setValue(halfYear);
			UniAppManager.setToolbarButtons(['query','reset'],false);
		},
		onResetButtonDown: function() {
			this.fnInitBinding();
		}
	});
}
</script>