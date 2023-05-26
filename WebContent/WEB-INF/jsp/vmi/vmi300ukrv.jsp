<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="vmi300ukrv">

<style type="text/css">
	.pwd_msg_invalid {
		color: red;
		border-width: 0px;
	}
	.pwd_msg_valid {
		color: blue;
		border-width: 0px;
		background: none !important;
	}
</style>
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var BsaCodeInfo = {
		caseSensYN	: '${caseSensYN}',
		numberPast	: '${numberPast}'
	};
	var isError = false;	//비밀번호 check	

	var masterForm = Unilite.createForm('vmi300ukrvMaster', {
		border	: true,
		region	: 'north',
		disabled: false,
		layout	: 'vbox',
		items	: [{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 2,tdAttrs: {valign:'center'}},
			defaults: {labelWidth: 100},
			items	: [{
				margin	: '15 0 20 0',
				xtype	: 'container',
				html	: '<font size=6><b>&nbsp;&nbsp;'+'<t:message code="system.label.base.passchange" default="비밀번호를 변경해주세요."/>'+'</b></font>',
				colspan	: 2
			},{
				fieldLabel		: '<t:message code="system.label.base.oldpassword" default="현재 비밀번호"/>',
				xtype			: 'uniTextfield',
				name			: 'OLD_PWD',
				allowBlank		: false,
				inputType		: 'password',
				maxLength		: 20,
				enforceMaxLength: true
			},{
				xtype	: 'label',
				html	: '<t:message code="system.label.base.newpasswordinput" default="현재 비밀번호를 입력하세요."/>',
				name	: '',
				padding	: '10 0 0 7',
				width	: 800
			},{ 
				fieldLabel		: '<t:message code="system.label.base.newpassword" default="신규 비밀번호"/>',
				xtype			: 'uniTextfield',
				name			: 'NEW_PWD',
				allowBlank		: false,
				inputType		: 'password',
				maxLength		: 20,
				enforceMaxLength: true,
				listeners		: {
					blur: function( form, The, eOpts ) {
						var newPwd = masterForm.getValue('NEW_PWD');
						if(!Ext.isEmpty(newPwd)) {
							//20210427 수정: 주석 해제
							UniAppManager.app.fncheckPwd(newPwd);
						}else{
							masterForm.down('#new_pwd_text').setValue('');
						}
					}
				}
			},{
				fieldLabel	: '',
				xtype		: 'uniTextfield',
				name		: 'NEW_PWD_TEXT',
				itemId		: 'new_pwd_text',
				disabled	: true,
				fieldCls	: 'pwd_msg_valid',
				padding		: '10 0 0 4',
				width		: 800
			},{ 
				fieldLabel		: '<t:message code="system.label.base.passwordconfirm" default="비밀번호 확인"/>',
				xtype			: 'uniTextfield',
				name			: 'NEW_CFM_PWD',
				allowBlank		: false,
				inputType		: 'password',
				maxLength		: 20,
				enforceMaxLength: true
			}]
		},{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 2,tdAttrs: {valign:'center'}},
			defaults: {labelWidth: 100, margin:'30 0 15 20', width: 800},
			items	: [{
				xtype	: 'container',
				layout	: 'hbox',
				tdAttrs	: {'align':'center'},
				items	: [{
					xtype	: 'container',
					padding	: '0 0 0 90'
				},{
					xtype	: 'button',
					text	: '<t:message code="system.label.base.pwchange" default="비밀번호 변경"/>',
					width	: 100,
					tdAttrs	: {'align':'center'},
					handler	: function() {
						if(Ext.isEmpty(masterForm.getValue('NEW_PWD')) || Ext.isEmpty(masterForm.getValue('OLD_PWD'))) {
							Unilite.messageBox('<t:message code="system.message.base.message016" default="비밀번호를 입력하십시오."/>');
							if(Ext.isEmpty(masterForm.getValue('OLD_PWD'))) {
								masterForm.getField('OLD_PWD').focus();
							}else{
								masterForm.getField('NEW_PWD').focus();
							}
							return false;
						}
						if(isError) {
							Unilite.messageBox('<t:message code="system.message.base.message017" default="비밀번호 규칙이 부적합 합니다. 다시 확인하십시오."/>');
							masterForm.setValue('NEW_PWD'		, '');
							masterForm.setValue('NEW_CFM_PWD'	, '');
							masterForm.down('#new_pwd_text').setValue('');
							return false;	
						}
						if(masterForm.getValue('NEW_PWD') != masterForm.getValue('NEW_CFM_PWD')) {
							Unilite.messageBox('<t:message code="system.message.base.message018" default="신규 입력된 비밀번호가 서로 틀립니다."/>');
							masterForm.setValue('NEW_CFM_PWD', '');
							masterForm.getField('NEW_CFM_PWD').focus();
							return false;
						}
						//OLD_PWD맞게 입력했는지 확인	
						var oldPwd = masterForm.getValue('OLD_PWD');
						if(BsaCodeInfo.caseSensYN == "Y") {
							var param = {"OLD_PWD" : oldPwd};
						}else{
							var param = {"OLD_PWD" : oldPwd.toUpperCase()};
						}
						vmi300ukrvService.oldPwdCheck(param, function(provider, response) {
							var err = false;
							if(Ext.isEmpty(provider)) {
								Unilite.messageBox('<t:message code="system.message.base.message019" default="비밀번호가 일치하지 않습니다. 다시 확인하십시오."/>');
								err = true;
								return false;
							}
							if(!err) {
								UniAppManager.app.fnChangePw()//저장 로직
							}
						});
					}
				},{
					xtype	: 'container',
					html	: '&nbsp;'
				},{
					xtype	: 'button',
					text	: '<t:message code="system.label.base.nextchange" default="다음에 변경"/>',
					width	: 100,
					tdAttrs	: {'align':'center'},
					handler	: function() {
						if(confirm('<t:message code="system.message.base.message020" default="지금 보고 있는 웹 페이지 창을 닫으려고 합니다."/>' + '\n' + '<t:message code="system.message.base.message021" default="이 창을 닫으시겠습니까?"/>')) {
							var tabPanel = parent.Ext.getCmp('contentTabPanel');
							if(tabPanel) {
								var activeTab	= tabPanel.getActiveTab();
								var canClose	= activeTab.onClose(activeTab);
								if(canClose) {
									tabPanel.remove(activeTab);
								}
							} else {
								self.close();
							}
						}
					}
				}]
			}]
		}]
	});


	//20210426 추가: 암호화 사용으로 설명부분 추가
	var detailForm = Unilite.createForm('bsa310ukrvDetail', {
		width	: 700,
		border	: true,
		region	: 'center',
		disabled: false,
		layout	: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
		defaults: {labelWidth: 100, margin:'5 0 0 20', width: 600},
		items	: [{
			margin	: '15 0 0 20',
			xtype	: 'container',
			html	: '<b>※'+'<t:message code="system.label.base.passminlength" default="비밀번호의 최소 길이"/>'+'</b>',
			style	: {
				color: 'blue'
			}},{
				xtype	: 'container',
				html	: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-.'+'<t:message code="system.label.base.passexplanation1" default="비밀번호를 구성하는 문자는 최소 9자리 이상의 길이도 구성"/>'
			},{
				xtype	: 'container',
				html	: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-.'+'<t:message code="system.label.base.passexplanation2" default="영대소문자(A~Z 26개, a~z 26개), 숫자(0~9, 10개) 및 특수문자(32개)중"/>'+'</br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
						+ '<t:message code="system.label.base.passexplanation3" default="모든 종류를 이용해 구성"/>',
				margin	: '0 0 15 20'
			},{
				xtype	: 'container',
				html	: '<b>※'+'<t:message code="system.label.base.passexplanation4" default="특수문자 32개 예시"/>'+'</b>',
				style	: {
					color: 'blue'
				}
			},{
				xtype	: 'container',
				html	: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-. !, ", #, $, %, &, `, (, ), *, +, `, -, ., /, :, ;, <, =, >, ?, {, |, }, ~, @, [, \, ], ^, _ , .',
				margin	: '0 0 15 20'
			},{
				xtype	: 'container',
				html	: '<b>※ '+'<t:message code="system.label.base.passexplanation5" default=" 유추가능한 비밀번호 금지"/>'+'</b>',
				style	: {
					color: 'blue'
				}
			},{
				xtype	: 'container',
				html	: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-.'+'<t:message code="system.label.base.passexplanation6" default="일련번호(abcde, 12345 등…)"/>'
			},{
				xtype	: 'container',
				html	: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-.'+'<t:message code="system.label.base.passexplanation7" default="키보드상 나란한 문자열 (qazwsx, qweasd 등…)"/>'
			},{
				xtype	: 'container',
				html	: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-.'+'<t:message code="system.label.base.passexplanation8" default="잘 알려진 단어 (admin, guest, test 등…)"/>',
				margin	: '0 0 15 20'
			},{
				xtype	: 'container',
				html	: '<b>※'+'<t:message code="system.label.base.lately" default="최근"/> '+ (BsaCodeInfo.numberPast == 0 ? 2:BsaCodeInfo.numberPast) +'<t:message code="system.label.base.passexplanation9" default="개의 비밀번호를 교대로 사용금지"/>'+'</b>',
				style	: {
					color: 'blue'
				},
				margin	: '0 0 7 20'
			},{
				xtype	: 'container',
				html	: '<b>※'+'<t:message code="system.label.base.passexplanation11" default="비밀번호에 사용자 ID 포함 금지"/>'+'</b>',
				style	: {
					color: 'blue'
				}
			}
		]
	});



	Unilite.Main({
		id			: 'vmi300ukrvApp',
		borderItems	: [{
			border	: false,
			region	: 'center',
			layout	: 'border',
			width	: 700,
			items	: [
				masterForm, detailForm		//20210426 수정: 암호화 사용으로 설명부분(detailForm) 추가
			]
		}],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset'	, false);
		},
		//20210426 주석: 암호화 이전로직 주석
/*		fnChangePw : function() {
			var param = masterForm.getValues();
			var newPwd = masterForm.getValue('NEW_PWD');

			vmi300ukrvService.encryptionSavePw(param);
			Unilite.messageBox('<t:message code="system.message.base.message022" default="비밀번호를 변경하였습니다. 다음 로그인부터 적용됩니다."/>');
			masterForm.setValue('OLD_PWD', '');
			masterForm.setValue('NEW_PWD', '');
			masterForm.setValue('NEW_CFM_PWD', '');
			masterForm.down('#new_pwd_text').setValue('');
		},*/
		//20210426 추가: 암호화 사용으로 로직 추가
		fncheckPwd : function(newPwd) {
			var me				= this;
			isError				= false;	//경고창 출력여부
			var userIdCheck		= false;	//아이디 포함체크
			var userBirthCheck	= false;	//생일 포함체크
			var userTelCheck	= false;	//전화번호 포함체크
			var splitNewPwd		= [];		//사용자가정의한 금지pw포함 여부
			var splitPrePwd		= '';		//앞전 문자(연속문자포함 여부)
			var cntNumeric		= 0;		//숫자포함여부
			var cntUpper		= 0;		//대문자포함 여부
			var cntLower		= 0;		//소문자포함 여부
			var cntSpecial		= 0;		//특수문자포함 여부
			var cntSeqChar		= 0;		//연속문자포함 여부
			var resultMsg		= '';
			var param			= masterForm.getValues();
			var err1			= false;
			var err2			= false;
			var err3			= false;
			var err5			= false;
			//아이디 포함 체크
			if(newPwd.toUpperCase().indexOf(UserInfo.userID.toUpperCase()) > -1){
				isError = me.fnSetErorrText("userIdCheck", true);
			}else{
				Ext.getBody().mask('<t:message code="system.message.base.passconfirm" default="비밀번호 확인 중..."/>');
				if(BsaCodeInfo.caseSensYN == "Y"){
					var param = {"NEW_PWD": newPwd};
				}else{
					var param = {"NEW_PWD": newPwd.toUpperCase()};
				}
				vmi300ukrvService.pwDuplicateCheck(param, function(provider, response) {
					if(!Ext.isEmpty(provider)){
						err1 = me.fnSetErorrText("pwDuplicateCheck", true);
						isError = err1;
					}
					if(!err1){				//비밀번호 교대사용 금지
						var dCycleCnt = 0;	//비밀번호 체크 갯수
						//비밀번호 체크갯수 조회 B110
						vmi300ukrvService.pwCheckQ(param, function(provider, response) {
							if(!Ext.isEmpty(provider['CYCLE_CNT']) && provider['CYCLE_CNT'] != 0){
								dCycleCnt = provider['CYCLE_CNT'];
							}else{
								dCycleCnt = 2;
							}
							//입력한 비밀번호가 이전사용한 x개의 비밀번호와 같은지 조회
							if(BsaCodeInfo.caseSensYN == "Y"){
								var param = {"DCYCLE_CNT": dCycleCnt, "NEW_PWD": newPwd};
							}else{
								var param = {"DCYCLE_CNT": dCycleCnt, "NEW_PWD": newPwd.toUpperCase()}
							}
							var param = {"DCYCLE_CNT": dCycleCnt, "NEW_PWD": newPwd};
							vmi300ukrvService.pwSameCheck(param, function(provider, response) {
								if(!Ext.isEmpty(provider)){
									err2 = me.fnSetErorrText("pwSameCheck", dCycleCnt);
									isError = err2;
								}
								if(!err2){
									//비밀번호 규칙 체크
									var strAlpabet	= "abcdeghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
									var strNumber	= "01234567890";
									var strSpecial	= "-!\"#$%&`()*+`-./:;<=>?{|}~@[,]^_";
									var chkA=0, chkN=0, chkS=0, chkSeq=0;

									for(var i=0; i< newPwd.length;i++) {
										if(strAlpabet.indexOf(newPwd.charAt(i))>-1) {
											chkA++;
										}
										if(strNumber.indexOf(newPwd.charAt(i))>-1) {
											chkN++;
										}
										if(strSpecial.indexOf(newPwd.charAt(i))>-1) {
											chkS++;
										}
										if(i < newPwd.length-2 ) {
											if(strAlpabet.indexOf(newPwd.substring(i,i+3))>-1) {
												chkSeq++;
											}
											if(strNumber.indexOf(newPwd.substring(i,i+3))>-1) {
												chkSeq++;
											}
										}
									}
									var checkVal = {"cntNumeric" : chkN, "cntUpper":chkA, "cntLower":chkA, "cntSpecial":chkS, "splitNewPwd":newPwd, "cntSeqChar":chkSeq };
									isError = me.fnSetErorrText("splitNewPwdInfo", checkVal);

									vmi300ukrvService.pwRuleCheck(param, function(provider, response) {
										var rule = [];
										Ext.each(provider, function(data, i) {
											switch(data['CHAR_TYPE']) {
												case "N" : rule["N"] = data['ALLOW_VALUE']	//숫자체크
												case "U" : rule["U"] = data['ALLOW_VALUE']	//대문자체크
												case "L" : rule["L"] = data['ALLOW_VALUE']  //소문자체크
												case "S" : rule["S"] = data['ALLOW_VALUE']  //특수문자 체크
												case "E" : rule["E"] = data['ALLOW_VALUE']  //사용자정의어 체크
											}
										});
										if(!Ext.isEmpty(rule["E"])) {
											var splitRuleE = rule["E"].split(',');
											for(var i = 0 ; i < splitRuleE.length; i++ ){
												if(newPwd.indexOf(splitRuleE[i])  > -1){
													err5 = me.fnSetErorrText("ProhibitionCahr", true);
													isError = err5;
													return false;
												}
											}
										}
										if(!err5 && rule.length > 0){
											splitNewPwd = newPwd.split('');	//NEW_PWD
											for(var i = 0; i < splitNewPwd.length; i++){
												//숫자체크
												if(rule["N"].indexOf(splitNewPwd[i].charCodeAt(0)) > -1){
													cntNumeric = 1;
												}
												//대문자체크
												if(rule["U"].indexOf(splitNewPwd[i].charCodeAt(0)) > -1){
													cntUpper = 1;
												}
												//소문자체크
												if(rule["L"].indexOf(splitNewPwd[i].charCodeAt(0)) > -1){
													cntLower = 1;
												}
												//특수문자체크
												if(rule["S"].indexOf(splitNewPwd[i].charCodeAt(0)) > -1){
													cntSpecial = 1;
												}
												//연속적인 문자열체크
												if(splitNewPwd[i].charCodeAt() == splitPrePwd.charCodeAt() + 1){
													cntSeqChar = cntSeqChar + 1;
												}
												splitPrePwd = splitNewPwd[i];
											}
											var checkVal = {"cntNumeric" : cntNumeric, "cntUpper":cntUpper, "cntLower":cntLower, "cntSpecial":cntSpecial, "splitNewPwd":splitNewPwd, "cntSeqChar":cntSeqChar };
											isError = me.fnSetErorrText("splitNewPwdInfo", checkVal);
										}
									});
								}
								Ext.getBody().unmask();
							});
						});
					}
					Ext.getBody().unmask();		//20210427 추가
				});
			}
		},
		fnSetErorrText: function(checkId, checkVal) {
			var resultMsg	= '';
			var bError		= false;

			switch (checkId) {
				case "userIdCheck" :
					if(checkVal) {
						resultMsg = '<t:message code="system.message.base.passconfirm2" default="부적합 - 비밀번호에 아이디 포함 오류"/>';
						bError = true;
					}
					break;

				case "userBirthCheck":	//T5256	B0114
					if(checkVal) {
						resultMsg = '<t:message code="system.message.base.passconfirm3" default="부적합 - 비밀번호에 생일 포함오류"/>';
						bError = true;
					}
					break;

				case "splitNewPwdInfo":	
					if(checkVal.cntSeqChar > 0){
						resultMsg = '<t:message code="system.message.base.passconfirm5" default="부적합 - 연속적인 문자/숫자가 3단어 이상 포함 오류"/>';
						bError = true;
					}
					else if(checkVal.splitNewPwd.length < 9){
						resultMsg = '<t:message code="system.message.base.passconfirm6" default="부적합 - 비밀번호 9자리 이상 오류"/>';
						bError = true;
					}else if(!(checkVal.cntNumeric > 0 && checkVal.cntUpper + checkVal.cntLower > 0 &&  checkVal.cntSpecial > 0)) {
						resultMsg = '<t:message code="system.message.base.passconfirm7" default="부적합 - 영대/소문자, 숫자, 특수문자 모두 포함 오류"/>';
						bError = true;
					} else {
						resultMsg = '<t:message code="system.message.base.suitable" default="적합"/>';
					}
					break;

				case "pwSameCheck":
					resultMsg = '<t:message code="system.message.base.passconfirm8" default="부적합 - 최근 사용한"/>' + checkVal + '<t:message code="system.message.base.passconfirm9" default="개의 비밀번호와 동일오류"/>';
					bError = true;
					break;

				case "pwDuplicateCheck":
					if(checkVal) {
						resultMsg = '<t:message code="system.message.base.passconfirm10" default="부적합 - 이전 비밀번호와 동일오류"/>';
						bError = true;
					}
					break;

				case "ProhibitionCahr":
					if(checkVal) {
						resultMsg = '<t:message code="system.message.base.passconfirm11" default="부적합 - 비밀번호 금지어 오류"/>';
						bError = true;
					}
					break;

				default:
					break;
			}

			if(resultMsg == '적합'){
				masterForm.down('#new_pwd_text').setValue(resultMsg);
				masterForm.down('#new_pwd_text').setFieldStyle("color:blue");
			}else{
				masterForm.down('#new_pwd_text').setValue(resultMsg);
				masterForm.down('#new_pwd_text').setFieldStyle("color:red");
			}
			return bError;
		},
		fnChangePw : function() {
			var param	= masterForm.getValues();
			var newPwd	= masterForm.getValue('NEW_PWD');
			vmi300ukrvService.encryptionYN(param, function(provider, response) {	//비밀번호 암호화 여부
				if(!Ext.isEmpty(provider)){	//암호화 이면..
					//20210106 수정: 체크로직 오류로 수정
					provider['CASE_SENS_YN'] == "Y" ? param = {"NEW_PWD": newPwd} : param = {"NEW_PWD" : newPwd.toUpperCase()};
					vmi300ukrvService.encryptionSavePw(param);
					Unilite.messageBox('<t:message code="system.message.base.message022" default="비밀번호를 변경하였습니다. 다음 로그인부터 적용됩니다."/>');
					masterForm.setValue('OLD_PWD'		, '');
					masterForm.setValue('NEW_PWD'		, '');
					masterForm.setValue('NEW_CFM_PWD'	, '');
					masterForm.down('#new_pwd_text').setValue('');
				}else{	//암호화가 아니면 이면..
					param = {"NEW_PWD" : newPwd.toUpperCase()};
					vmi300ukrvService.notEncryptionSavePw(param);
					Unilite.messageBox('<t:message code="system.message.base.message022" default="비밀번호를 변경하였습니다. 다음 로그인부터 적용됩니다."/>');
					masterForm.setValue('OLD_PWD'		, '');
					masterForm.setValue('NEW_PWD'		, '');
					masterForm.setValue('NEW_CFM_PWD'	, '');
					masterForm.down('#new_pwd_text').setValue('');
				}
			});
		}
	});
};
</script>