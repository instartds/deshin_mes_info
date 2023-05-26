<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="false" %>
<%@ page import="java.util.*" %>
<%@ page import="foren.framework.utils.*" %>
<%@ page import="foren.unilite.com.constants.*" %>

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

String loginBg = ConfigUtil.getString("common.login.loginBgImage", "loginBg.png");

String loginBgName = loginBg.substring(0, loginBg.indexOf("."));
String loginBgNameExt = loginBg.substring(loginBg.indexOf("."), loginBg.length());

request.setAttribute("loginBgImage",loginBgName+"_"+curLang+loginBgNameExt);
request.setAttribute("loginToken",request.getParameter("loginToken"));
%>
<!DOCTYPE html >
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>

<%@ include file='/WEB-INF/jspf/commonHead.jspf' %>

	<link rel="shortcut icon" href='<c:url value="/resources/images/main/logo.ico" />' type="image/x-icon" />
	<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/jqueryui/smoothness/jquery-ui-1.10.4.custom.min.css" />' />
    <script type="text/javascript" src="<c:url value='/resources/js/jquery/jquery-1.10.2.js' />" ></script>
    <script type="text/javascript" src="<c:url value='/resources/js/jquery/jquery-ui-1.10.4.custom.min.js' />"></script>
    <!-- Input Mask -->
    <script type="text/javascript" src="<c:url value='/resources/js/jquery/jquery.inputmask.js' />" ></script>  
    <script type="text/javascript" src="<c:url value='/resources/js/jquery/jquery.cookie.js' />" ></script>
    <script type="text/javascript" src="<c:url value='/resources/js/tlab/miya_validator.js' />"></script>



<style>

	/* Reset */
	html,body{width:100%;height:100%}
	html{overflow-y:scroll}
	body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,form,p,button{margin:0;padding:0}
	fieldset{}
	body,h1,h2,h3,h4,input,button{font-family:'돋움',dotum,Helvetica,sans-serif;font-size:12px;color:#383d41}
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
		margin:-240px 0 0 -303px;
		border: 1px solid #c5c5c5;
		position: fixed;
	}
	
	.wrap_login_main {
		background: url("../resources/images/login/${loginBgImage}");
		background-repeat: no-repeat; 
		width: 600px;
		height: 294px;
	}

	.login_main {
		position: absolute;
		left: 68px;
		top: 298px;
	}	

	#loginButton
	{
	    background-image: url("../resources/images/login/loginBtn.png");
	    background-repeat: no-repeat; 
	    border: none;    
	    width: 175px;
	    height: 48px;
	}

	.login_input 
	{
		width: 210px;
		height: 38px;
		border: 0 solid #000000;
		background-color: #bfbfbf;
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
function detectmob() { 
	 if( navigator.userAgent.match(/Android/i)
	 || navigator.userAgent.match(/webOS/i)
	 || navigator.userAgent.match(/iPhone/i)
	 || navigator.userAgent.match(/iPad/i)
	 || navigator.userAgent.match(/iPod/i)
	 || navigator.userAgent.match(/BlackBerry/i)
	 || navigator.userAgent.match(/Windows Phone/i)
	 ){
	    return true;
	  }
	 else {
	    return false;
	  }
	}
if(detectmob()) {
	//window.location.href = "mlogin.do";
}
var lang = "${TLAB_LANG}";
//var lang = "ko";


// onLoad Event Hanlder
function loadPage(){

	var msg = "${loginToken}";
		$.ajax({
		     url:"<c:url value='/login/connectLogin.do' />",	// 토큰 생성 url
		     dataType: 'jsonp', 
		     jsonp: 'callback',
		     data: {loginToken:msg},
		     jsonpCallback: 'fnCallback'
		});
    
}
	function fnCallback(jObj){
		var resJson = JSON.parse(jObj);
		if(resJson.success=="fail")	{
			alert("시스템이 로그인되어 있지 않습니다.");
		}else if(resJson.return_url) {
			window.location = resJson.return_url;
   		}else {
			alert("관리자에게 문의하세요.");
		}
	};
</script>
</head>
<body onload="loadPage()">
	
</body>
</html>	