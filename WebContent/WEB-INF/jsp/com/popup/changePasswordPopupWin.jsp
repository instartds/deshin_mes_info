<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
	//사용자 팝업 'Unilite.app.popup.UserNoCompPopup'
	request.setAttribute("PKGNAME","Unilite.app.popup.changePassword");
%>

Ext.define('${PKGNAME}', {
	extend		: 'Unilite.com.BaseJSPopupApp',
	caseSensYN	: '${caseSensYN}',
	numberPast	: '${numberPast}',
	logoutYN  : '${logOutYN}',
	uniOpt		: {
		btnQueryHide	: true,
		btnSubmitHide	: true
	},
	constructor	: function(config) {
		var me = this;
		if (config) {
			Ext.apply(me, config);
		}

		me.form = Unilite.createForm('changePasswordPopupForm', {
			disabled:false,
			layout	: 'vbox',
			items	: [{
				xtype	: 'container',
				layout	: {type: 'uniTable', columns: 2,tdAttrs: {valign:'center'}},
				defaults: {labelWidth: 100},
				items	: [{
					margin	: '15 0 0 0',
					xtype	: 'container',
					html	: '<font size=6><b>&nbsp;&nbsp;비밀번호를 변경해 주세요.</b></font>',
					colspan	: 2,
					hidden  : (!Ext.isDefined(me.extParam) || (me.extParam && me.extParam.isAutoPopup == "true")) ? false:true
				},{
					margin	: '5 0 0 15',
					xtype	: 'container',
					name	: 'PWD_CYCLE',
					itemId	: 'PWD_CYCLE',
					html	: '<font size=2><b>&nbsp;&nbsp;비밀번호 변경후 ${PWD_DAY_DIFF}일이 지났습니다.<br/>&nbsp;&nbsp;비밀번호는 ${PWD_CYCLE}일마다 주기적으로 변경하셔야 합니다.</b></font>',
					colspan	: 2,
					hidden  : (!Ext.isDefined(me.extParam) || (me.extParam && me.extParam.isAutoPopup == "true")) ? false:true
				},{
					fieldLabel	: '<t:message code="system.label.common.oldpassword" default="현재 비밀번호"/>',
					xtype		: 'uniTextfield',
					name		: 'OLD_PWD',
				 	allowBlank	: false,
					inputType	: 'password',
					maxLength	: 20,
					enforceMaxLength: true
				},{
					xtype	: 'label',
					html	: '<t:message code="system.label.common.newpasswordinput" default="현재 비밀번호를 입력하세요."/>',
					name	: '',
					padding	: '0 0 0 7',
					width	: 400
				},{
					fieldLabel	: '<t:message code="system.label.common.newpassword" default="신규 비밀번호"/>',
					xtype		: 'uniTextfield',
					name		: 'NEW_PWD',
				 	allowBlank	: false,
					inputType	: 'password',
					maxLength	: 20,
					enforceMaxLength: true,
					listeners	: {
						blur: function( form, The, eOpts ) {
							var masterForm	= me.form;
							var newPwd		= masterForm.getValue('NEW_PWD');
							if(!Ext.isEmpty(newPwd)) {
								me.fncheckPwd(newPwd);
							} else {
								Ext.getCmp('new_pwd_text').setValue('');
							}
						}
					}
				},{
					xtype		: 'uniTextfield',//'label',
					fieldLabel	: '',
					name		: 'NEW_PWD_TEXT',
					id			: 'new_pwd_text',
					disabled	: true,
					fieldCls	: 'pwd_msg_valid',
					padding		: '0 0 0 4',
					width		: 300
				},{
					fieldLabel	: '<t:message code="system.label.common.passwordconfirm" default="비밀번호 확인"/>',
					xtype		: 'uniTextfield',
					name		: 'NEW_CFM_PWD',
				 	allowBlank	: false,
					inputType	: 'password',
					maxLength	: 20,
					enforceMaxLength: true
				}]
			},{
				xtype	: 'container',
				layout	: {type: 'uniTable', columns: 2,tdAttrs: {valign:'center'}},
				defaults: {labelWidth: 100, margin:'15 0 15 20', width: 700},
				items	: [{
					xtype	: 'container',
					layout	: 'hbox',
					tdAttrs	: {'align':'center'},
					items	: [{
						xtype	: 'container',
						padding	: '0 0 0 90'
					},{
						xtype	: 'button',
						text	: '<t:message code="system.label.common.pwchange" default="비밀번호 변경"/>',
						width	: 100,
						tdAttrs	: {'align':'center'},
						handler	: function() {
							var masterForm = Ext.getCmp('changePasswordPopupForm');
							if(Ext.isEmpty(masterForm.getValue('NEW_PWD')) || Ext.isEmpty(masterForm.getValue('OLD_PWD'))) {
								Unilite.messageBox('비밀번호를 입력하십시오.');
								if(Ext.isEmpty(masterForm.getValue('OLD_PWD'))) {
									masterForm.getField('OLD_PWD').focus();
								} else {
									masterForm.getField('NEW_PWD').focus();
								}
								return false;
							}
							var errorMsg = '비밀번호 규칙이 부적합 합니다. 다시 확인하십시오.';
							if(isError) {
								Unilite.messageBox(errorMsg);
								masterForm.setValue('NEW_PWD'		, '');
								masterForm.setValue('NEW_CFM_PWD'	, '');
								Ext.getCmp('new_pwd_text').setValue('');
								return false;
							}
							if(masterForm.getValue('NEW_PWD') != masterForm.getValue('NEW_CFM_PWD')) {
								Unilite.messageBox('신규 입력된 비밀번호가 서로 다릅니다.');
								masterForm.setValue('NEW_CFM_PWD', '');
								masterForm.getField('NEW_CFM_PWD').focus();
								return false;
							}
							//OLD_PWD맞게 입력했는지 확인
							var oldPwd = masterForm.getValue('OLD_PWD');
							if(me.caseSensYN == "Y") {
								var param = {"OLD_PWD" : oldPwd};
							} else {
								var param = {"OLD_PWD" : oldPwd.toUpperCase()};
							}
							bsa310ukrvService.oldPwdCheck(param, function(provider, response) {
								var err = false;
								if(Ext.isEmpty(provider)) {
									Unilite.messageBox('비밀번호가 일치하지 않습니다. 다시 확인하십시오.');
									err = true;
									return false;
								}
								if(!err) {
									me.fnChangePw()//저장 로직
								}
							});
						}
					},{
						xtype	: 'container',
						html	: '&nbsp;'
					},{
						xtype	: 'button',
						text	: '<t:message code="system.label.common.nextchange" default="다음에 변경"/>',
						width	: 100,
						hidden  : ((!Ext.isDefined(me.extParam) || (me.extParam && me.extParam.isAutoPopup == "true")) || '${logOutYN}' != 'Y') ? false:true,
						tdAttrs	: {'align':'center'},
						handler	: function() {
							if(me.logoutYN == 'Y')	{
								setTimeout(function(){
									top.window.location = CPATH+'/login/actionLogout.do';
								}, 10);
							}
							me._onCloseBtnDown();
						}
					}]
				}]
			}]
		});

		me.detailForm = Unilite.createForm('changePasswordPopupFormDetail', {
			disabled: false,
			layout	: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
			defaults: {labelWidth: 100, margin:'5 0 0 20', width: 500},
			width	: 700,
//			padding	: '20 20 20 20',
			items	: [{
				margin	: '15 0 0 20',
				xtype	: 'container',
				html	: '<b>※ 비밀번호의 최소 길이</b>',
				style	: {
					color: 'blue'
				}
			},{
				xtype	: 'container',
				html	: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-. 비밀번호는 구성하는 문자의 종류에 따라 최소 9자리 이상의 길이로 구성'
			},{
				xtype	: 'container',
				html	: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-. 영대소문자(A~Z, 26개,a~z, 26개), 숫자(0~9, 10개) 및 특수문자(32개)중 </br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;모든 종류를 이용해 구성',
				margin	: '0 0 15 20'
			},{
				xtype	: 'container',
				html	: '<b>※ 특수문자 32개 예시</b>',
				style	: {
					color: 'blue'
				}
			},{
				xtype	: 'container',
				html	: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-. !, ", #, $, %, &, `, (, ), *, +, `, -, ., /, :, ;, <, =, >, ?, {, |, }, ~, @, [, \, ], ^, _ , .',
				margin	: '0 0 15 20'
			},{
				xtype	: 'container',
				html	: '<b>※ 유추가능한 비밀번호 금지</b>',
				style	: {
					color: 'blue'
				}
			},{
				xtype	: 'container',
				html	: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-. 일련번호(abcde, 12345 등…)'
			},{
				xtype	: 'container',
				html	: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-. 키보드상 나란한 문자열 (qazwsx, qweasd 등…)'
			},{
				xtype	: 'container',
				html	: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-. 잘 알려진 단어 (admin, guest, test 등…)',
				margin	: '0 0 15 20'
			},{
				xtype	: 'container',
				html	: '<b>※ 최근 '+me.numberPast+'개의 비밀번호를 교대로 사용금지</b>',
				style	: {
					color: 'blue'
				},
				margin	: '0 0 7 20'
			},{
				xtype	: 'container',
				html	: '<b>※ 비밀번호에 생일, 전화번호 끝 4자리 포함금지</b>',
				style	: {
					color: 'blue'
				},
				margin	: '0 0 7 20'
			},{
				xtype	: 'container',
				html	: '<b>※ 비밀번호에 사용자 ID 포함 금지</b><br/><br/>',
				style	: {
					color: 'blue'
				}
			}]
		});
		config.items = [me.form, me.detailForm];
		me.callParent(arguments);
	},	//constructor
	initComponent : function() {
		var me = this;
		this.callParent();
		var param = me.form.getValues();

		/*baseCommonService.getUserLoginInfo(param, function(provider, response) {
			if(!Ext.isEmpty(provider)) {
				me.form.down('#PWD_CYCLE').setHtml('<font size=2><b>&nbsp;&nbsp;비밀번호 변경후  ' + provider['PWD_DAY_DIFF'] + '일이 지났습니다.<br/>&nbsp;&nbsp;비밀번호는 주기적(' + provider['PWD_CYCLE'] + '일)마다 변경하셔야 합니다.</b></font>');
			}
		})*/
	},
	fnInitBinding : function(param) {
		var me = this;
		me._setToolbarButton("query", false);

	},
	onSubmitButtonDown : function() {
		me._onClose();
	},
	_onCloseBtnDown : function()	{
		if(this.logoutYN == 'Y')	{
			setTimeout(function(){
				top.window.location = CPATH+'/login/actionLogout.do';
			}, 100);
		}
		if(Ext.isFunction(this.callBackFn) && this.callBackFn != null) {
			if(this.callBackScope) this.callBackFn.call(this.callBackScope, null, this.popupType);
			else this.callBackFn.call(this, null, this.popupType);
		}
		this.close();
	},
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
		var param			= me.form.getValues();
		//아이디 포함 체크
		if(newPwd.toUpperCase().indexOf(UserInfo.userID.toUpperCase()) > -1) {
			isError = me.fnSetErorrText("userIdCheck", true);
		} else {
			me.mask("비밀번호 확인 중...");
			//생일, 비밀번호에 전화번호  check
			bsa310ukrvService.birthTelCheck(param, function(provider, response) {
				var err1 = false;
				var err2 = false;
				var err3 = false;
				var err4 = false;
				var err5 = false;
				if(!Ext.isEmpty(provider['BIR'])) {
					if(newPwd.indexOf(provider['BIR']) > -1) {
						err1	= me.fnSetErorrText("userBirthCheck", true);
						isError	= err1;
					}
				}
				if(!Ext.isEmpty(provider['TEL'])) {
					if(newPwd.indexOf(provider['TEL']) > -1) {
						err2	= me.fnSetErorrText("userTelCheck", true);
						isError	= err2;
					}
				}
				if(!err1 && !err2) {//입력한 비밀번호가 현재 비밀번호와 같은지 조회
					if(me.caseSensYN == "Y") {
						var param = {"NEW_PWD": newPwd};
					} else {
						var param = {"NEW_PWD" : newPwd.toUpperCase()};
					}
					bsa310ukrvService.pwDuplicateCheck(param, function(provider, response) {
						if(!Ext.isEmpty(provider)) {
							err3	= me.fnSetErorrText("pwDuplicateCheck", true);
							isError	= err3;
						}
						if(!err3) {				//비밀번호 교대사용 금지
							var dCycleCnt = 0;	//비밀번호 체크 갯수
							//비밀번호 체크갯수 조회 B110
							bsa310ukrvService.pwCheckQ(param, function(provider, response) {
								if(!Ext.isEmpty(provider['CYCLE_CNT']) && provider['CYCLE_CNT'] != 0) {
									dCycleCnt = provider['CYCLE_CNT'];
								} else {
									dCycleCnt = 2;
								}
								//입력한 비밀번호가 이전사용한 x개의 비밀번호와 같은지 조회
								if(me.caseSensYN == "Y") {
									var param = {"DCYCLE_CNT": dCycleCnt, "NEW_PWD": newPwd};
								} else {
									var param = {"DCYCLE_CNT": dCycleCnt, "NEW_PWD": newPwd.toUpperCase()}
								}
								var param = {"DCYCLE_CNT": dCycleCnt, "NEW_PWD": newPwd};
								bsa310ukrvService.pwSameCheck(param, function(provider, response) {
									if(!Ext.isEmpty(provider)) {
										err4	= me.fnSetErorrText("pwSameCheck", dCycleCnt);
										isError	= err4;
									}
									if(!err4) {
										//비밀번호 규칙 체크
										var strAlpabet	= "abcdeghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
										var strNumber	= "01234567890";
										var strSpecial	=  "-!\"#$%&`()*+`-./:;<=>?{|}~@[,]^_";

										var chkA=0,chkN=0, chkS=0, chkSeq=0;

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
										var checkVal= {"cntNumeric" : chkN, "cntUpper":chkA, "cntLower":chkA, "cntSpecial":chkS, "splitNewPwd":newPwd, "cntSeqChar":chkSeq };
										isError		= me.fnSetErorrText("splitNewPwdInfo", checkVal);

/*										bsa310ukrvService.pwRuleCheck(param, function(provider, response) {
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
											if(rule.length > 0) {
												var splitRuleE = rule["E"].split(',');
												for(var i = 0 ; i < splitRuleE.length; i++ ) {
													if(newPwd.indexOf(splitRuleE[i])  > -1) {
														err5 = me.fnSetErorrText("ProhibitionCahr", true);
														isError = err5;
													}
												}
											}
											if(!err5 && rule.length > 0) {
												splitNewPwd = newPwd.split('');	//NEW_PWD
												for(var i = 0; i < splitNewPwd.length; i++) {
													//숫자체크
													if(rule["N"].indexOf(splitNewPwd[i].charCodeAt(0)) > -1) {
														cntNumeric = 1;
													}
													//대문자체크
													if(rule["U"].indexOf(splitNewPwd[i].charCodeAt(0)) > -1) {
														cntUpper = 1;
													}
													//소문자체크
													if(rule["L"].indexOf(splitNewPwd[i].charCodeAt(0)) > -1) {
														cntLower = 1;
													}
													//특수문자체크
													if(rule["S"].indexOf(splitNewPwd[i].charCodeAt(0)) > -1) {
														cntSpecial = 1;
													}
													//연속적인 문자열체크
													if(splitNewPwd[i].charCodeAt() == splitPrePwd.charCodeAt() + 1) {
														cntSeqChar = cntSeqChar + 1;
													}
													splitPrePwd = splitNewPwd[i];
												}
												var checkVal = {"cntNumeric" : cntNumeric, "cntUpper":cntUpper, "cntLower":cntLower, "cntSpecial":cntSpecial, "splitNewPwd":splitNewPwd, "cntSeqChar":cntSeqChar };
												isError = me.fnSetErorrText("splitNewPwdInfo", checkVal);
											}
										});	*/
									}
									me.unmask();
								});
							});
						} else {	//20210810 추가
							me.unmask();
						}
					});
				} else {	//20210810 추가
					me.unmask();
				}
			});
		}
	},
	fnSetErorrText : function(checkId, checkVal) {
		var resultMsg	= "";
		var bError		= false;

		switch (checkId) {
		case "userIdCheck" :
			if(checkVal) {
				resultMsg	= '부적합 - 비밀번호에 아이디 포함 오류';
				bError		= true;
			}
			break;
		case "userBirthCheck":	//T5256	B0114
			if(checkVal) {
				resultMsg	= '부적합 - 비밀번호에 생일 포함오류';
				bError		= true;
			}
			break;
		case "userTelCheck":
			if(checkVal) {
				resultMsg	= '부적합 - 비밀번호에 전화번호 뒷자리 4자 포함오류';
				bError		= true;
			}
			break;
		case "splitNewPwdInfo":
			if(checkVal.cntSeqChar > 0) {
				resultMsg	= '부적합 - 연속적인 문자/숫자가 3단어 이상 포함 오류';
				bError		= true;
			}
			else if(checkVal.splitNewPwd.length < 9) {
				resultMsg	= '부적합 - 비밀번호 9자리 이상 오류';
				bError		= true;
			}else if(!(checkVal.cntNumeric > 0 && checkVal.cntUpper + checkVal.cntLower > 0 &&  checkVal.cntSpecial > 0)) {
				resultMsg	= '부적합 - 영대/소문자, 숫자, 특수문자 모두 포함 오류';
				bError		= true;
			} else {
				resultMsg	= '적합';
			}
/*			if(checkVal.cntSeqChar >= 3) {
				resultMsg	= '부적합 - 연속적인 문자/숫자가 3단어 이상 포함 오류';
				bError		= true;
			}
			else if(checkVal.cntSeqChar <= 3 && checkVal.splitNewPwd.length < 8) {
				resultMsg	= '부적합 - 비밀번호 8자리 이상 오류';
				bError		= true;
			}else if(checkVal.cntSeqChar <= 3 && checkVal.splitNewPwd.length >= 10) {	//10자리일경우 대소문자, 숫자, 특수문자중 2개이상
				if(checkVal.cntNumeric + checkVal.cntUpper + checkVal.cntLower + checkVal.cntSpecial < 2) {
					resultMsg	= '부적합 - 비밀번호가 10자리이상일경우  대/소문자, 숫자, 특수문자중 2개이상 포함 오류';
					bError		= true;
				} else {
					resultMsg	= '적합';
				}
			}else if(checkVal.cntSeqChar <= 3 && checkVal.splitNewPwd.length < 10) {	//10자리일경우 대소문자, 숫자, 특수문자중 2개이상
				if(checkVal.cntNumeric + checkVal.cntUpper + checkVal.cntLower + checkVal.cntSpecial < 3) {
					resultMsg	= '부적합 - 비밀번호가 8자리이상 10자리 미만일경우  대/소문자, 숫자, 특수문자중 3개이상 포함 오류';
					bError		= true;
				} else {
					resultMsg	= '적합';
				}
			}		*/
			break;
		case "pwSameCheck":
			resultMsg	= '부적합 - 최근 사용한 ' + checkVal + '개의 비밀번호와 동일오류';
			bError		= true;
			break;
		case "pwDuplicateCheck":
			if(checkVal) {
				resultMsg	= '부적합 - 이전 비밀번호와 동일오류';
				bError		= true;
			}
			break;
		case "ProhibitionCahr":
			if(checkVal) {
				resultMsg	= '부적합 - 비밀번호 금지어 오류';
				bError		= true;
			}
			break;

		default :
			break;
		}

		if(resultMsg == '적합') {
			Ext.getCmp('new_pwd_text').setValue(resultMsg);
			Ext.getCmp('new_pwd_text').setFieldStyle("color:blue");
		} else {
			Ext.getCmp('new_pwd_text').setValue(resultMsg);
			Ext.getCmp('new_pwd_text').setFieldStyle("color:red");
		}
		return bError;
	},
	fnChangePw : function() {
		var me			= this;
		var masterForm	= me.form;
		var param		= masterForm.getValues();
		var newPwd		= masterForm.getValue('NEW_PWD');
		bsa310ukrvService.encryptionYN(param, function(provider, response) {	//비밀번호 암호화 여부
			var masterForm = me.form;
			if(!Ext.isEmpty(provider)) {	//암호화 이면..
				provider['CASE_SENS_YN'] == "Y" ? param = {"NEW_PWD": newPwd} : param = {"NEW_PWD" : newPwd.toUpperCase()};
				bsa310ukrvService.encryptionSavePw(param);
				Unilite.messageBox('비밀번호를 변경하였습니다. 다음 로그인부터 적용됩니다.');
				masterForm.setValue('OLD_PWD'		, '');
				masterForm.setValue('NEW_PWD'		, '');
				masterForm.setValue('NEW_CFM_PWD'	, '');
				Ext.getCmp('new_pwd_text').setValue('');

			} else {	//암호화가 아니면 이면..
				param = {"NEW_PWD" : newPwd.toUpperCase()};
				bsa310ukrvService.notEncryptionSavePw(param);
				Unilite.messageBox('비밀번호를 변경하였습니다. 다음 로그인부터 적용됩니다.');
				masterForm.setValue('OLD_PWD'		, '');
				masterForm.setValue('NEW_PWD'		, '');
				masterForm.setValue('NEW_CFM_PWD'	, '');
				Ext.getCmp('new_pwd_text').setValue('');
			}
			me._onCloseBtnDown();
		});
	}
});