<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%
    /**
			 * @Class Name : EgovLoginUsr.jsp
			 * @Description : Login 인증 화면
			 * @Modification Information
			 * @
			 * @  수정일         수정자                   수정내용
			 * @ -------    --------    ---------------------------
			 * @ 2009.03.03    박지욱          최초 생성
			 *   2011.09.25    서준식          사용자 관리 패키지가 미포함 되었을때에 회원가입 오류 메시지 표시
			 *   2011.10.27    서준식          사용자 입력 탭 순서 변경
			 *   2012.04.10    goindole     TRA 불필요한 항목 삭제
			 *  @author 공통서비스 개발팀 박지욱
			 *  @since 2009.03.03
			 *  @version 1.0
			 *  @see
			 *
			 *  Copyright (C) 2009 by MOPAS  All right reserved.
			 */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<c:url value='/css/egovframework/com/cmm/com.css'/>" type="text/css">
<link rel="stylesheet" href="<c:url value='/css/egovframework/com/cmm/button.css'/>" type="text/css">
<link rel="stylesheet" type="text/css"
	href="<c:url value='/css/egovframework/com/common.css'/>">

<title>Login</title>
<script type="text/javaScript" language="javascript">
	function checkLogin(userSe) {
		// 기업회원
		if (userSe == "GNR") {
			document.loginForm.rdoSlctUsr[0].checked = true;
			document.loginForm.rdoSlctUsr[1].checked = false;
			document.loginForm.userSe.value = "GNR";
		} else if (userSe == "USR") {
			document.loginForm.rdoSlctUsr[0].checked = false;
			document.loginForm.rdoSlctUsr[1].checked = true;
			document.loginForm.userSe.value = "USR";
		}
	}

	function actionLogin() {

		if (document.loginForm.id.value == "") {
			alert("Input User ID");
		} else if (document.loginForm.password.value == "") {
			alert("Input Password");
		} else {
			document.loginForm.action = "<c:url value='/uat/uia/actionLogin.do'/>";
			document.loginForm.submit();
		}
	}



	function goFindId() {
		document.defaultForm.action = "<c:url value='/uat/uia/egovIdPasswordSearch.do'/>";
		document.defaultForm.submit();
	}

	function goRegiUsr() {

		var useMemberManage = '${useMemberManage}';

		if (useMemberManage != 'true') {
			alert("사용자 관리 컴포넌트가 설치되어 있지 않습니다. \n관리자에게 문의하세요.");
			return false;
		}

		var userSe = document.loginForm.userSe.value;
		// 일반회원
		if (userSe == "GNR") {
			document.loginForm.action = "<c:url value='/uss/umt/EgovStplatCnfirmMber.do'/>";
			document.loginForm.submit();
			// 기업회원
		} else if (userSe == "ENT") {
			document.loginForm.action = "<c:url value='/uss/umt/EgovStplatCnfirmEntrprs.do'/>";
			document.loginForm.submit();
			// 업무사용자
		} else if (userSe == "USR") {
			alert("업무사용자는 별도의 회원가입이 필요하지 않습니다.");
		}
	}

	function setCookie(name, value, expires) {
		document.cookie = name + "=" + escape(value) + "; path=/; expires="
				+ expires.toGMTString();
	}

	function getCookie(Name) {
		var search = Name + "=";
		if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
			offset = document.cookie.indexOf(search);
			if (offset != -1) { // 쿠키가 존재하면
				offset += search.length;
				// set index of beginning of value
				end = document.cookie.indexOf(";", offset);
				// 쿠키 값의 마지막 위치 인덱스 번호 설정
				if (end == -1)
					end = document.cookie.length;
				return unescape(document.cookie.substring(offset, end));
			}
		}
		return "";
	}

	function saveid(form) {
		var expdate = new Date();
		// 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
		if (form.checkId.checked)
			expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
		else
			expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
		setCookie("saveid", form.id.value, expdate);
	}

	function getid(form) {
		form.checkId.checked = ((form.id.value = getCookie("saveid")) != "");
	}

	function fnInit() {
		var message = document.loginForm.message.value;
		if (message != "") {
			alert(message);
		}

		getid(document.loginForm);
		// 포커스
		//document.loginForm.rdoSlctUsr.focus();
	}

	function login(usertype, userid, pw) {
		var frm = document.loginForm;
		checkLogin(usertype);
		frm.id.value=userid;
		frm.password.value=pw;
		frm.submit();
	}
</script>
</head>
<body onLoad="fnInit();">
	<!--
    <div id="gnb">
    <div id="top_logo"><img src="/images/egovframework/com/main_top.gif" alt="egovframe" /></div>
    </div>-->

	<table width="700" cellspacing="0" cellpadding="0">
		<tr>
			<td align="center"><c:import
					url="/uss/ion/lsi/getLoginScrinImageResult.do" charEncoding="utf-8">

				</c:import></td>
		</tr>
	</table>

	<table width="700">
		<tr>
			<td height="250">
				<!--일반로그인 테이블 시작-->
				<form name="loginForm"
					action="<c:url value='/uat/uia/actionLogin.do'/>" method="post">
					<div style="visibility: hidden; display: none;">
						<input name="iptSubmit1" type="submit" value="전송" title="전송">
					</div>
					<input type="hidden" name="message" value="${message}">
					<table width="303" border="0" cellspacing="8" cellpadding="0">
						<tr>
							<td width="40%" class="title_left"><img
								src="<c:url value='/images/egovframework/com/cmm/icon/tit_icon.gif'/>"
								width="16" height="16" hspace="3" align="middle" alt="login">&nbsp; SIGN IN</td>
						</tr>
						<tr>
							<td width="303" height="210" valign="top"
								style="background:url(<c:url value='/images/egovframework/com/uat/uia/login_bg01.gif' />) no-repeat;">
								<table width="303" border="0" align="center" cellpadding="0"
									cellspacing="0">
									<tr>
										<td height="70">&nbsp;</td>
									</tr>
									<tr>
										<td>
											<table border="0" cellpadding="0" cellspacing="0"
												style="width: 250px; margin-left: 20px; background-repeat: no-repeat;">
												<tr>
													<td width="30"></td>
													<td nowrap><input name="rdoSlctUsr" type="radio"
														value="radio" checked onClick="checkLogin('GNR');"
														style="border: 0; background: #ffffff;" tabindex="1">External User </td>
													<td nowrap><input name="rdoSlctUsr" type="radio"
														value="radio" onClick="checkLogin('USR');"
														style="border: 0; background: #ffffff;" tabindex="2">Customs Officer</td>
												</tr>
												<tr>
													<td height="1">&nbsp;</td>
												</tr>
											</table>
											<table border="0" cellpadding="0" cellspacing="0"
												style="width: 250px; margin-left: 20px;">
												<tr>
													<td>
														<table width="250" border="0" cellpadding="0"
															cellspacing="0">
															<tr>
																<td class="required_text" nowrap><label for="id">ID&nbsp;&nbsp;</label></td>
																<td><input type="text" name="id" id="id"
																	style="height: 16px; width: 85px; border: 1px solid #CCCCCC; margin: 0px; padding: 0px; ime-mode: disabled;"
																	tabindex="4" maxlength="10" /></td>
																<td />
															</tr>
															<tr>
																<td class="required_text" nowrap><label
																	for="password">Password&nbsp;&nbsp;</label></td>
																<td><input type="password" name="password"
																	id="password"
																	style="height: 16px; width: 85px; border: 1px solid #CCCCCC; margin: 0px; padding: 0px; ime-mode: disabled;"
																	maxlength="12" tabindex="5"
																	onKeyDown="javascript:if (event.keyCode == 13) { actionLogin(); }" /></td>
																<td class="title"><label for="checkId"><input
																		type="checkbox" name="checkId" class="check2"
																		onClick="javascript:saveid(document.loginForm);"
																		id="checkId" tabindex="6" />Keep ID</label></td>
															</tr>
														</table>
													</td>
												</tr>
												<tr>
													<td height="10">&nbsp;</td>
												</tr>
												<tr>
													<td>
														<table border="0" cellspacing="0" cellpadding="0">
															<tr>
																<td><span class="button"><a href="#LINK"
																		onClick="actionLogin()" tabindex="7">Sign in</a></span></td>
																<td>&nbsp;</td>
																<td><span class="button"><a href="#LINK"
																		onClick="goRegiUsr();" tabindex="8">Sign up</a></span></td>
																<td>&nbsp;</td>
																<td><span class="button"><a href="#LINK"
																		onClick="goFindId();" tabindex="9">Find ID/Password</a></span></td>
															</tr>
														</table>
													</td>
												</tr>


											</table>
										</td>
									</tr>

									<tr>
										<td height="2">&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<input name="userSe" type="hidden" value="GNR" /> <input
						name="j_username" type="hidden" />
				</form> <!--일반로그인 테이블 끝-->
			</td>

		</tr>
	</table>
	<table >
										<tr>
													<td height="3">
													   <b>Login - Internal</b><br/>
															- Master : <a href="javascript:login('GNR','CUO','qwerqwer')">[CUO] </a>
															<br/>
															- Auditor : <a href="javascript:login('GNR','ADTR','qwerqwer')">[ADTR] </a>
															            <a href="javascript:login('GNR','ADTR2','qwerqwer')">[ADTR2] </a>
															<br/>
															- Inspector : <a href="javascript:login('GNR','INSPCTR','qwerqwer')">[INSPCTR] </a>
															              <a href="javascript:login('GNR','INSPCTR2','qwerqwer')">[INSPCTR2] </a>
															<br/><br/>
														<b>Login - External</b><br/>
                                                            - Shipping List : <a href="javascript:login('GNR','LIN','qwerqwer')">[LIN] </a>
                                                            <br/>
															- Shipping Agent: <a href="javascript:login('GNR','USER','qwerqwer')">[USER] </a>
															                  <a href="javascript:login('GNR','AGNT2','qwerqwer')">[AGNT2] </a>
															<br/>
															- Forwader : <a href="javascript:login('FWD','FWD','qwerqwer')">[FWD] </a>
															<br/>
															- Terminal Operator : <a href="javascript:login('GNR','TICTS','qwerqwer')">[TICTS] </a>
															 <br/>
                                                            - ICD : <a href="javascript:login('GNR','ICD','qwerqwer')">[ICD] </a>
															<br/>
															- Warehouse : <a href="javascript:login('GNR','WH','qwerqwer')">[WH] </a>
															              <a href="javascript:login('GNR','WH2','qwerqwer')">[WH2] </a>
														    <br/>
														    - Terminal : <a href="javascript:login('GNR','TR','qwerqwer')">[TR] </a>
														                 <a href="javascript:login('GNR','TR2','qwerqwer')">[TR2] </a>
														    <br/>
														    - CFA01(GREATLAKES FREIGHT LIMITED:104216633) : <a href="javascript:login('GNR', 'CFA01','qwerqwer')">[CFA01] </a>
														    <br/>
														    - CheckPoint(CHALINZE) : <a href="javascript:login('GNR', 'CHALINZE','qwerqwer')">[CHALINZE] </a>
														    <br/>
														    - BorderOfficer(KABANGAA) : <a href="javascript:login('GNR', 'KABANGAA','qwerqwer')">[KABANGAA] </a>

														    <br/>
														    - <a href="javascript:login('USR','webmaster','qwerqwer')">[webmaster] </a>
														    <br/>
															</td>
												</tr>


	</table>
	<!-- bottom -->
	<div id="new_footer_login">
		<ul>

		</ul>
	</div>
<table>
	<tr>
		<td colspan="2">
			<h3>sessionScope:</h3>
		</td>
	</tr>
	<c:forEach var="aKey" items="${sessionScope}">
		<tr>
			<td><c:out value="${aKey.key}" /></td>
			<td>[<c:out value="${aKey.value}" />] <c:if test="${aKey.key == 'msession'}">
					<br />
				userid = <c:out value="${aKey.value.userid}" /> , nm = <c:out value="${aKey.value.nm}" />
					<br />

				</c:if></td>
		</tr>
	</c:forEach>
</table>
</body>
</html>


