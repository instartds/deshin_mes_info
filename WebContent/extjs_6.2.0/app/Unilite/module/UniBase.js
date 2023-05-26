//@charset UTF-8
/**
 * 기준 모듈용 공통 함수 모음
 * @class Unilite.module.UniBase
 * @singleton
 */
Ext.define('Unilite.module.UniBase', {
	alternateClassName: 'UniBase',
    singleton: true,
	fncheckPwd:function(newPwd, strFormId, caseSensYN, popWin)	{
			var me = this;
			var isError = false; //경고창 출력여부
			var userIdCheck = false;	//아이디 포함체크
			var userBirthCheck = false; //생일 포함체크
			var userTelCheck = false;   //전화번호 포함체크

			var splitNewPwd	= [];		//사용자가정의한 금지pw포함 여부
			var splitPrePwd	= '';		//앞전 문자(연속문자포함 여부)
			var cntNumeric = 0;			//숫자포함여부
			var cntUpper = 0;			//대문자포함 여부
			var cntLower = 0;			//소문자포함 여부
			var cntSpecial = 0;			//특수문자포함 여부
			var cntSeqChar = 0;			//연속문자포함 여부
			var resultMsg = '';
			var masterForm = Ext.getCmp(strFormId);
			var param = !Ext.isEmpty(masterForm) ? masterForm.getValues() : {'NEW_PWD':newPwd} ;
    		//아이디 포함 체크
			if(newPwd.toUpperCase().indexOf(UserInfo.userID.toUpperCase()) > -1){
				isError = me.fnSetErorrText("userIdCheck", true);
			}else{
				//생일, 비밀번호에 전화번호  check
				if(popWin) popWin.mask();
				bsa310ukrvService.birthTelCheck(param, function(provider, response)	{
					var err1 = false;
					var err2 = false;
					var err3 = false;
					var err4 = false;
					var err5 = false;
					if(newPwd.indexOf(provider['BIR']) > -1){
						err1 = me.fnSetErorrText("userBirthCheck", true);
						isError = err1;
					}

					if(newPwd.indexOf(provider['TEL']) > -1){
						err2 = me.fnSetErorrText("userTelCheck", true);
						isError = err2;
					}
					if(popWin) popWin.unmask();
					if(!err1 && !err2) {//입력한 비밀번호가 현재 비밀번호와 같은지 조회
						if(caseSensYN == "Y"){
							var param = {"NEW_PWD": newPwd};
						}else{
							var param = {"NEW_PWD" : newPwd.toUpperCase()};
						}
						bsa310ukrvService.pwDuplicateCheck(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								err3 = me.fnSetErorrText("pwDuplicateCheck", true);
								isError = err3;
							}
							if(!err3){//비밀번호 교대사용 금지

								var dCycleCnt = 0;	//비밀번호 체크 갯수
								//비밀번호 체크갯수 조회 B110
								if(popWin) popWin.mask();
								bsa310ukrvService.pwCheckQ(param, function(provider, response)	{
									if(!Ext.isEmpty(provider['CYCLE_CNT']) && provider['CYCLE_CNT'] != 0){
										dCycleCnt = provider['CYCLE_CNT'];
									}else{
										dCycleCnt = 2;
									}
									//입력한 비밀번호가 이전사용한 x개의 비밀번호와 같은지 조회
									if(caseSensYN == "Y"){
										var param = {"DCYCLE_CNT": dCycleCnt, "NEW_PWD": newPwd};
									}else{
										var param = {"DCYCLE_CNT": dCycleCnt, "NEW_PWD": newPwd.toUpperCase()}
									}
									if(popWin) popWin.unmask();
									var param = {"DCYCLE_CNT": dCycleCnt, "NEW_PWD": newPwd};
									bsa310ukrvService.pwSameCheck(param, function(provider, response)	{
										if(!Ext.isEmpty(provider)){
											err4 = me.fnSetErorrText("pwSameCheck", dCycleCnt);
											isError = err4;
										}
										if(popWin) popWin.unmask();
										if(!err4){
											//비밀번호 규칙 체크
											if(popWin) popWin.mask();
											bsa310ukrvService.pwRuleCheck(param, function(provider, response)	{
												var rule = [];
												Ext.each(provider, function(data, i)	{
									        		switch(data['CHAR_TYPE']) {
									        			case "N" : rule["N"] = data['ALLOW_VALUE']	//숫자체크
									        			case "U" : rule["U"] = data['ALLOW_VALUE']	//대문자체크
									        			case "L" : rule["L"] = data['ALLOW_VALUE']  //소문자체크
									        			case "S" : rule["S"] = data['ALLOW_VALUE']  //특수문자 체크
									        			case "E" : rule["E"] = data['ALLOW_VALUE']  //사용자정의어 체크
									        		}
								        		});
								        		var splitRuleE = rule["E"].split(',');
								        		for(var i = 0 ; i < splitRuleE.length; i++ ){
								        			if(newPwd.indexOf(splitRuleE[i])  > -1){
									        			err5 = me.fnSetErorrText("ProhibitionCahr", true);
									        			isError = err5;
									        		}
								        		}
								        		if(!err5){
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
								        		if(popWin) popWin.unmask();
											});
										}

									});

								});
							}
						});

					}

				});
			}
		return isError;
	},
	fnSetErorrText : function(checkId, checkVal) {
			var resultMsg = "";
			var bError = false;

			switch (checkId) {
			case "userIdCheck" :
				if(checkVal) {
					resultMsg = '부적합 - 비밀번호에 아이디 포함 오류';
					bError = true;
				}
				break;
			case "userBirthCheck":	//T5256	B0114
				if(checkVal) {
					resultMsg = '부적합 - 비밀번호에 생일 포함오류';
					bError = true;
				}
				break;
			case "userTelCheck":
				if(checkVal) {
					resultMsg = '부적합 - 비밀번호에 전화번호 뒷자리 4자 포함오류';
					bError = true;
				}
				break;
			case "splitNewPwdInfo":
				if(checkVal.cntSeqChar >= 3){
					resultMsg = '부적합 - 연속적인 문자/숫자가 3단어 이상 포함 오류';
	    			bError = true;
				}
				else if(checkVal.cntSeqChar <= 3 && checkVal.splitNewPwd.length < 8){
	    			resultMsg = '부적합 - 비밀번호 8자리 이상 오류';
	    			bError = true;
	    		}else if(checkVal.cntSeqChar <= 3 && checkVal.splitNewPwd.length >= 10){	//10자리일경우 대소문자, 숫자, 특수문자중 2개이상
	    			if(checkVal.cntNumeric + checkVal.cntUpper + checkVal.cntLower + checkVal.cntSpecial < 2){
	    				resultMsg = '부적합 - 비밀번호가 10자리이상일경우  대/소문자, 숫자, 특수문자중 2개이상 포함 오류';
	    				bError = true;
	    			}else{
	    				resultMsg = '적합';
	    			}
	    		}else if(checkVal.cntSeqChar <= 3 && checkVal.splitNewPwd.length < 10){	//10자리일경우 대소문자, 숫자, 특수문자중 2개이상
	    			if(checkVal.cntNumeric + checkVal.cntUpper + checkVal.cntLower + checkVal.cntSpecial < 3){
	    				resultMsg = '부적합 - 비밀번호가 8자리이상 10자리 미만일경우  대/소문자, 숫자, 특수문자중 3개이상 포함 오류';
	    				bError = true;
	    			}else{
	    				resultMsg = '적합';
	    			}
	    		}
				break;
			case "pwSameCheck":
				resultMsg = '부적합 - 최근 사용한 ' + checkVal + '개의 비밀번호와 동일오류';
				bError = true;
				break;
			case "pwDuplicateCheck":
				if(checkVal) {
					resultMsg = '부적합 - 이전 비밀번호와 동일오류';
					bError = true;
				}
				break;
			case "ProhibitionCahr":
				if(checkVal) {
					resultMsg = '부적합 - 비밀번호 금지어 오류';
					bError = true;
				}
				break;

			default :
				break;
			}

			if(resultMsg == '적합'){
				//Ext.getCmp('new_pwd_text').el.dom.innerHTML = "적합";
//				Ext.getCmp('new_pwd_text').setText("<font color = 'blue'>" + resultMsg +"</font>", false);
//				Ext.getCmp('new_pwd_text').el.dom.innerHTML = "<font color = 'blue'>" + resultMsg +"</font>";
				Ext.getCmp('new_pwd_text').setValue(resultMsg);
				Ext.getCmp('new_pwd_text').setFieldStyle("color:blue");
//				Ext.getCmp('new_pwd_text').removeCls('pwd_msg_invalid');
//				Ext.getCmp('new_pwd_text').addCls('pwd_msg_valid');
//

//				lbl.updateLayout();
				//Ext.getCmp('new_pwd_text').el.dom.innerHTML = "<font color = 'blue'>" + resultMsg +"</font>";
			}else{
//				Ext.getCmp('new_pwd_text').setText("<font color = 'red'>" + resultMsg +"</font>", false);
//				Ext.getCmp('new_pwd_text').el.dom.innerHTML = "<font color = 'blue'>" + resultMsg +"</font>";
				Ext.getCmp('new_pwd_text').setValue(resultMsg);
				Ext.getCmp('new_pwd_text').setFieldStyle("color:red");
//				Ext.getCmp('new_pwd_text').removeCls('pwd_msg_valid');
//				Ext.getCmp('new_pwd_text').addCls('pwd_msg_invalid');
//				lbl.el.dom.innerHTML = "<font color = 'red'>" + resultMsg +"</font>";
//				lbl.updateLayout();
			}
			return bError;
		},
		fnChangePw : function(masterForm, popWin) {
			var param = masterForm.getValues();
			var newPwd = masterForm.getValue('NEW_PWD');
			if(popWin) popWin.mask();
			bsa310ukrvService.encryptionYN(param, function(provider, response)	{	//비밀번호 암호화 여부
				if(!Ext.isEmpty(provider)){	//암호화 이면..
					provider['CASE_SENS_YN'] == "Y" ? param = {"NEW_PWD": newPwd} : param = {"NEW_PWD" : newPwd.toUpperCase()};
					bsa310ukrvService.encryptionSavePw(param);
					Unilite.messageBox('비밀번호를 변경하였습니다. 다음 로그인부터 적용됩니다.');
					masterForm.setValue('OLD_PWD', '');
					masterForm.setValue('NEW_PWD', '');
					masterForm.setValue('NEW_CFM_PWD', '');
					Ext.getCmp('new_pwd_text').setValue('');

				}else{	//암호화가 아니면 이면..
					param = {"NEW_PWD" : newPwd.toUpperCase()};
					bsa310ukrvService.notEncryptionSavePw(param);
					Unilite.messageBox('비밀번호를 변경하였습니다. 다음 로그인부터 적용됩니다.');
					masterForm.setValue('OLD_PWD', '');
					masterForm.setValue('NEW_PWD', '');
					masterForm.setValue('NEW_CFM_PWD', '');
					Ext.getCmp('new_pwd_text').setValue('');
				}
				if(popWin) popWin.unmask();
			});
		},
		//기안버튼 컨트롤(조회 후 처리 / loadStoreRecords: 함수의 콜백이나 조회 후 리스너 함수에 넣어준다. )
		fnGwBtnControl : function(btnNm, gwFlag){
			console.log('1' + gwFlag);
			console.log('2' + btnNm);
			if(gwFlag == '1' || gwFlag == '3'){

				 UniAppManager.setToolbarButtons(['save', 'newData', 'delete'], false);
                 Ext.getCmp(btnNm).setDisabled(true);

			}else{

                 Ext.getCmp(btnNm).setDisabled(false);

			}
		},
		//기안 버튼 주소 호출 함수  requestApprove: function()안의 내용을 공통함수로 처리
		fnGw_Call : function(url, form, btnNm){
		 	var gsWin = window.open('about:blank','payviewer','width=500,height=500');
			 if(!Ext.isEmpty(btnNm)){
				 Ext.getCmp(btnNm).setDisabled(true);
			 }
			form.action   = url;
			form.target   = "payviewer";
			form.method   = "post";
			form.submit();
		},

		//날짜 유효성 체크 관련( 6자리 숫자 입력 하여 날짜체크 벨리데이트 용 "Unilite.createValidator('validator01', {" 추후 보완가능(자리수등등))
		fnDateCheckValidator : function(value){
			var checkReturn = true;
			if(isNaN(value) == false){
				if (value.length == 6) {
			    	var todayYY = UniDate.getDbDateStr(UniDate.get('today')).substring(0, 2);
			        var y = todayYY + value.substring(0, 2) ;   // yyyy
			        var m = value.substring(2, 4);   // mm
			        var d = value.substring(4, 6);  // dd

			        if (m<1 || m>12){
						checkReturn = false;
			        }

			        if ( d<1 || d>31){
						checkReturn = false;
			        }

			        if ( (m==4 || m==6 || m==9 || m==11) && d == 31 ) {
						checkReturn = false;
			        }

			        if (m==2){
			            var isleap = (y % 4 == 0 && (y % 100 != 0 || y % 400 == 0));
			            if (d>29 || (d==29 && !isleap)){
						checkReturn = false;
			            }
			        }
			    }else{
					checkReturn = false;
			    }
			}else{
				checkReturn = false;
			}

		    return checkReturn;
		}

});



