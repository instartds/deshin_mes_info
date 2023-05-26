<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ham930ukr">
	<t:ExtComboStore comboType="BOR120" pgmId="ham930ukr"/>		<!-- 사업장 -->
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
			fieldLabel	: '지급월',
			xtype		: 'uniMonthfield',
			name		: 'TAX_YYYYMM',
			value		: new Date(),
			allowBlank	: false
		},{
			fieldLabel	: '제출년월일',
			id			: 'CRT_DATE',
			xtype		: 'uniDatefield',
			name		: 'CRT_DATE',
			value		: new Date(),
			allowBlank	: false
		},{
			fieldLabel	: '관리번호',
			xtype		: 'uniTextfield',
			name		: 'TAX_AGENT_NO',
			maxLength	: 6,
			enforceMaxLength: true
		},{
			fieldLabel	: '홈텍스ID',
			xtype		: 'uniTextfield',
			name		: 'HOMETAX_ID'
		},{
			fieldLabel	: '신고사업장',
			id			: 'DIV_CODE',
			name		: 'DIV_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			comboCode	: 'BILL',
			allowBlank	: false
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
					var form	= panelFileDown;
					var param	= panelSearch.getValues();
					
					// validation check
					if(!panelSearch.getInvalidMessage()) {
						return false;
					}
					
					// 일용근로전산신고자료 파일 대상 조회
					ham930ukrService.fnCheckData(param, function(provider, response) {
						// 파일 생성할 데이터가 존재 할 경우 파일 생성
						if(provider) {
							form.submit({
								params: param
							});
						}
					});
				}
			}]
		}]
	});

	// 컨트롤러 호출
	var panelFileDown = Unilite.createForm('FileDownForm', {
		url				: CPATH+'/human/ham930proc.do',
		standardSubmit	: true
	});


	Unilite.Main({
		id		: 'ham930ukrApp',
		items	: [ panelSearch],
		fnInitBinding : function() {

			UniAppManager.setToolbarButtons(['detail','reset','query'],false); // button enable false 처리
			
			panelSearch.setValue('TAX_YYYYMM', UniDate.get('aMonthAgo'));
		}
	});
};
</script>