<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="false" %>
<%@ page import="java.util.*" %>
<%@ page import="foren.framework.utils.*" %>
<%@ page import="foren.unilite.com.constants.*" %>
<%@ page import="foren.framework.model.LoginVO" %>
<%
/*
<c:choose>
    <c:when test="${empty loginVO }">
    </c:when>
    <c:otherwise>
        <c:redirect url="/portal.do"></c:redirect>
    </c:otherwise>
</c:choose>
*/
Locale locale = LocaleUtils.getSafeLocale(request);
String curLang = locale.getLanguage();
String contextPath = request.getContextPath();

//String[] langs = {"ko","zh","en","ja"};
String[] langs = (String[])request.getAttribute("SUPPORT_LANG");

List<String> langList = new ArrayList<String>();
langList.add(curLang);

for(String lang : langs) {
	if(!lang.equals(curLang)) {
		langList.add(lang);
	}
}

request.setAttribute("langs",langList);
request.setAttribute("contexts",Unilite.getContextList());
LoginVO userSession = (LoginVO)request.getSession().getAttribute(CommonConstants.SESSION_KEY);
String loginPage = ConfigUtil.getString("loginPage");

loginPage = ConfigUtil.getString("loginPage", request.getContextPath());
if(userSession == null)	{
	response.sendRedirect(request.getContextPath()+"/");
} else {
	if("E".equals(userSession.getRefItem())) {
		response.sendRedirect(request.getContextPath()+"/login/newExtUser.do");;
	}
}
%>
<!DOCTYPE html >
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>

<%@ include file='/WEB-INF/jspf/commonHead.jspf' %>

	<link rel="shortcut icon" href='<c:url value="/resources/images/main/logo.ico" />' type="image/x-icon" />
	<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/jqueryui/smoothness/jquery-ui-1.10.4.custom.min.css" />' />
    <script type="text/javascript" src="<c:url value='/resources/js/jquery/jquery-1.10.2.js' />" ></script>
    <script type="text/javascript" src="<c:url value='/resources/js/jquery/jquery-ui-1.10.4.custom.min.js' />"></script>
 
<style>

	/* Reset */
	html,body{width:100%;height:100%}
	html{overflow-y:scroll}
	body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,form,p,button{margin:0;padding:0}
	fieldset{}
	body,h1,h2,h3,h4,input,button{font-family:'돋움',dotum,Helvetica,sans-serif;font-size:14px;color:#383d41}
	body{background-color:#fff;text-align:center;*word-break:break-all;-ms-word-break:break-all}

	.loginHelper dt {
		display: block;
		padding-left:10px;
		font-size: 12px;
	}
	.loginHelper dd,  .loginHelper A{
		font-weight: bold !important;
		color:#f00 !important;
		display: inline;
		font-size: 12px;
	}
	.loginList { width:100%}
	.loginList th{background:#efefef}
	.loginList td, .loginList th{
		border: 1px solid #e0e0e0; text-align: center;
	}

	#centered {
		left:50%;top:50%;
		margin:-300px 0 0 -243px;
		border: 0px solid #ffffff;
		position: fixed;
	}

	.login_main {
		position: absolute;
		left: 68px;
		top: 40px;
	}
	.passwordDesc {
		position: absolute;
		left: -150px;
		top: 350px;
		width:750px;
		border : 1px solid #bfbf9f;
		padding : 15px;
	}
	.head_userConfirm {
		width  : 100%;
		height : 50px;
		background-color:#085788;
		color:#FFF;
		padding-top : 20px;
	}
	.loginButton
	{
	    background-color : #3177B3;
	    border: none;
	    width: 340px;
	    height: 48px;
	    font-size: 16px;
		font-weight: bold;
		color:#fff;
		text-align: center;
  		text-decoration: none;
  		display: inline-block;
  		cursor: pointer;
	}
	.login_input
	{
		width: 210px;
		height: 38px;
		border: 1px solid #bfbfbf;
		font-size: 20px;
		font-weight: bold;
		color: #383d41;
	}

	#setupButton
	{
		border: none;
		background-color: #ffffff;
		background-image: none;
	}

	input:-webkit-autofill {
		-webkit-box-shadow:0 0 0 1000px #bfbfbf inset;
		-webkit-text-fill-color: #383d41;
	}
	input:-webkit-autofill:focus {
		-webkit-box-shadow: 0 0 0 1000px #bfbfbf inset;
		-webkit-text-fill-color: #383d41;
	}

	* html #centered { position:absolute;} /* As Mariusz noticed */
	img {border: 0 none;margin: 0;padding: 0;vertical-align: middle;}
</style>

<script type="text/javascript">
var loginPage = '<%=loginPage%>';
// onLoad Event Hanlder
function loadPage(){
        $("#OLD_PWD").focus();
}

function updatePassword(lForce) {

        if(!$("#OLD_PWD").val() || $("#OLD_PWD").val() == "")	{
        	alert("현재 비밀번호를 입력하세요.");
        	$("#OLD_PWD").focus();
        	return;
        }
		if(!$("#NEW_PWD").val() || $("#NEW_PWD").val() == "")	{
			alert("신규비밀번호를 입력하세요.");
        	$("#NEW_PWD").focus();
        	return;
        }
		if(!$("#NEW_CFM_PWD").val() || $("#NEW_CFM_PWD").val() == "")	{
			alert("비밀번호확인을 입력하세요.");
        	$("#NEW_CFM_PWD").focus();
        	return;
		}
        if($("#NEW_CFM_PWD").val() != $("#NEW_PWD").val())	{
        	alert("신규비밀번호이 비밀번호확인와 같지 않습니다.")
        	$("#NEW_PWD").value = "";
        	$("#NEW_CFM_PWD").value = "";
        	return;
        }

        $.ajax({
            type: "POST",
            url: "<c:url value='/login/updatePassword.do' />",
            data: $("#form1").serialize(),
            dataType: "json",
            success: function(data) {
                if(data.success == "true") {
                    alert("비밀번호가 변경되었습니다."+"\n"+"다시 로그인 하세요.");
                    window.location = "<c:url value='<%=loginPage%>' />";
                } else {
                    alert(data.errorMessage);
                    if(data.location){
                    	window.location = data.location;
                    }
                    return false;
                }
            },
            failure:function(arg1, arg2){
            	console.log("arg1 :", arg1);
            	console.log("arg2 :", arg2);
            }
        });
   // }
//	return false;

}

</script>
</head>
<body onload="loadPage()">
<div class="head_userConfirm">
	<img src="../resources/css/theme_01/logo.png" border="1">
</div>
	<div class="wrap_login_main" id="centered">
        <!-- content -->
        	<div class="login_main">
       			<form id="form1" name="form1" action="" onsubmit="updatePassword();return false" target='_new'>
       				<input type="hidden" name="newUserId" value="" />
       			<table border='0' cellpadding='2' cellspacing='5' >
       			<colgroup>
       				<col width="110" />
       				<col width="200" />
       			</colgroup>
       			<tr height=52>
       				<td><t:message code="system.label.common.oldpassword" default="현재 비밀번호"/></td>
       				<td align="right" valign="middle">
       					<input type="password" name="OLD_PWD" id="OLD_PWD" value="" class="login_input" tabindex="4" maxlength="30"/>
       				</td>
       			</tr>
       			<tr height=52>
       				<td><t:message code="system.label.common.newpassword" default="신규 비밀번호"/></td>
       				<td align="right" valign="middle">
       					<input type="password" name="NEW_PWD" id="NEW_PWD" value="" class="login_input" tabindex="4" maxlength="30"/>
       				</td>
       			</tr>
       			<tr height=52>
       				<td><t:message code="system.label.common.passwordconfirm" default="비밀번호확인"/></td>
       				<td align="right" valign="middle">
       					<input type="password" name="NEW_CFM_PWD" id="NEW_CFM_PWD" value="" class="login_input" maxlength="16" tabindex="5" autocomplete="off" />
       				</td>
       			</tr>
       			<tr>
       				<td colspan="2">
       					<button class="loginButton">등록</button>
       				</td>
       			</tr>
       			</table>
		        </form>
            </div>
            <div class="passwordDesc">
       			
       			<table border="0" cellpadding="0" cellspacing="0" width="750">
       			<tr>
       				<td align="left"><b>※ 비밀번호의 최소 길이</b></td>
       			</tr>
       			<tr>
       				<td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-. 비밀번호는 구성하는 문자의 종류에 따라 최소 9자리 이상의 길이로 구성</td>
       			</tr>
       			<tr>
       				<td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-. 영대소문자(A~Z, 26개,a~z, 26개), 숫자(0~9, 10개) 및 특수문자(32개)중  모든 종류를 이용해 구성<br/><br/></td>
       			<tr>
       				<td align="left"><b>※ 특수문자 32개 예시</b></td>
       			</tr>
       			<tr>
       				<td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-. !, ", #, $, %, &, `, (, ), *, +, `, -, ., /, :, ;, <, =, >, ?, {, |, }, ~, @, [, \, ], ^, _ , .<br/><br/></td>
       			</tr>
       			<tr>
       				<td align="left"><b>※ 유추가능한 비밀번호 금지</b></td>
       			</tr>
       			<tr>
       				<td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-. 일련번호(abcde, 12345 등…)</td>
       			</tr>
       			<tr>
       				<td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-. 키보드상 나란한 문자열 (qazwsx, qweasd 등…)</td>
       			</tr>
       			<tr>
       				<td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-. 잘 알려진 단어 (admin, guest, test 등…)<br/><br/></td>
       			</tr>
       			<tr>
       				<td align="left"><b>※ 최근 ${pastNum}개의 비밀번호를 교대로 사용금지</b></td>
       			</tr>
       			<tr>
       				<td align="left"><b>※ 비밀번호에 생일, 전화번호 끝 4자리 포함금지</b></td>
       			</tr>
       			<tr>
       				<td align="left"><b>※ 비밀번호에 사용자 ID 포함 금지</b></td>
       			</tr>
       			</table>
            </div>
	</div>
</body>
</html>