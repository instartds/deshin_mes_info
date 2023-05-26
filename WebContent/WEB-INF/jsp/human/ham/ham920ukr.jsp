<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ham920ukr">
	<t:ExtComboStore comboType="BOR120" pgmId="ham920ukr"/>		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A074"/>			<!-- 지급분기 -->
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL"/>		<!-- 신고사업장 -->
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
			fieldLabel	: '귀속년도',
			xtype		: 'uniTextfield',
			name		: 'TAX_YYYY',
			allowBlank	: false
		},{
			fieldLabel	: '지급분기',
			name		: 'QUARTER', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A074',
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
			//20200702 추가: 6글자로 제한
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
					
					if(!panelSearch.getForm().isValid()) {
						var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
							return !field.validate();
						});
						if(invalid.length > 0) {
							r = false;
							var labelText = '';
							if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
								var labelText = invalid.items[0]['fieldLabel']+'은(는)';
							}else if(Ext.isDefined(invalid.items[0].ownerCt)) {
								var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
							}
							// Ext.Msg.alert(타이틀, 표시문구); 
							Unilite.messageBox(labelText+Msg.sMB083);					//20200702 수정: 메세지 표준화
							// validation이 맞지 않는 필드 중 제일 처음 필드에 포커스를 줌
							invalid.items[0].focus();
						}
						
						return false;
					}
					
					ham920ukrService.fnCheckData(param, function(provider, response) {
						if(provider) {
							form.submit({
								params: param
							});
						}
					});
					
//					form.submit({
//						params: param
//					});
				}
/*				Ext.Msg.show({
					title:'',
					msg: '자료생성을 실행 하시겠습니까?',
					buttons: Ext.Msg.YESNO,
					icon: Ext.Msg.QUESTION,
					fn: function(btn) {
						if (btn === 'yes') {
							runProc();
						} else if (btn === 'no') {
							this.close();
						} 
					}
				});*/
			}]
		}]
	});

	var panelFileDown = Unilite.createForm('FileDownForm', {
		url				: CPATH+'/human/ham920proc.do',
		standardSubmit	: true
	});



	// 프로시져 실행
	function runProc() {
		var form = panelSearch.getForm();
		if (form.isValid()) {
			var param= Ext.getCmp('searchForm').getValues();
			Ext.Ajax.on("beforerequest", function(){
				Ext.getBody().mask('로딩중...', 'loading')
			}, Ext.getBody());
			Ext.Ajax.on("requestcomplete", Ext.getBody().unmask, Ext.getBody());
			Ext.Ajax.on("requestexception", Ext.getBody().unmask, Ext.getBody());
			
			Ext.Ajax.request({
				url	 : CPATH+'/human/ham920proc.do',
				params: param,
				success: function(response){
					data = Ext.decode(response.responseText);
					console.log("data:::",data);
					
					if(data.return_value == '-1'){
						if(data.ERROR_CODE == '54251'){
							Unilite.messageBox('법인정보 또는 해당사원이 존재하지 않습니다.');		//20200702 수정: 메세지 표준화
						}else{
							Unilite.messageBox('년월차수당 계산 수행을 실패하였습니다.');		//20200702 수정: 메세지 표준화
						}
					}else if(data.return_value == '1'){
						Unilite.messageBox('년월차수당 계산을 수행하였습니다.');				//20200702 수정: 메세지 표준화
					}
				},
				failure: function(response){
					console.log(response);
					Unilite.messageBox(response.statusText);					//20200702 수정: 메세지 표준화
				}
			});
		} else {
			var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
				return !field.validate();
			});
			if(invalid.length > 0) {
				r = false;
				var labelText = ''
				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				}else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				}
				// Ext.Msg.alert(타이틀, 표시문구); 
				Unilite.messageBox(labelText+Msg.sMB083);					//20200702 수정: 메세지 표준화
				// validation이 맞지 않는 필드 중 제일 처음 필드에 포커스를 줌
				invalid.items[0].focus();
			}
		}	
	}



	Unilite.Main({
		id		: 'ham920ukrApp',
		items	: [ panelSearch],
		fnInitBinding : function() {
			if(UniDate.getDbDateStr(UniDate.get('today')).substring(4, 8) <= '0228'){
				panelSearch.setValue('TAX_YYYY', (new Date().getFullYear() - 1));
			}else{
				panelSearch.setValue('TAX_YYYY', new Date().getFullYear());
			}
			UniAppManager.setToolbarButtons(['detail','reset','query'],false);
		}
	});
};
</script>