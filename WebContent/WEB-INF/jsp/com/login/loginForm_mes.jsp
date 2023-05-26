<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="false" %>
<%@ page import="java.util.*" %>
<%@ page import="foren.framework.utils.*" %>
<%@ page import="foren.unilite.com.constants.*" %>
<%
//로컬 사용자 아이피 확인
String REMOTE_IP = request.getRemoteAddr();

%>

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

String loginBg = ConfigUtil.getString("loginBg_MES_ko.png", "loginBg_MES_ko.png");

String loginBgName = loginBg.substring(0, loginBg.indexOf("."));
String loginBgNameExt = loginBg.substring(loginBg.indexOf("."), loginBg.length());

request.setAttribute("loginBgImage","loginBg_MES_ko.png");
request.setAttribute("loginBtnImage",ConfigUtil.getString("common.login.loginBtnImage", "loginBtn_MES.png"));
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
		top: 298px;
	}

	#loginButton
	{
	    background-image: url("../resources/images/login/${loginBtnImage}");
	    background-repeat: no-repeat;
	    border: none;
	    left: 50px;
	    width: 120px;
	    height: 120px;
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

	if($.cookie("login.saveid")){
        $("#userpw").focus();
        $("#userid").val($.cookie("login.saveid"));
        $("#saveid").prop("checked",true);
    }else {
        $("#userid").focus();
    }

    /*var cookieContext = $.cookie("login.context");
    var currentContext = "<%=contextPath%>";
    if(cookieContext){
    	if(currentContext != cookieContext)
    		changeContext(cookieContext);
    }*/
}

$(function(){
    $("#userid,#userpw").keyup(function(e) {
        if(e.keyCode == 13) {
            login();
        }
    });
    // $("#company_cd > option[value="+$.cookie('gls.login.company_cd')+"]").attr("selected","selected");

});

function checkForm(form) {
    var v = new MiyaValidator(form);
    v.add(["userid", "userpw"], { required:true } );


    var result = false;
    try {
        result = v.validate();
    } catch(e) { alert(e); }

    if (!result) {
        alert("Error : " + v.getErrorMessage());
        v.focus();
        return false;
    } else {
        return true;
    }
}

function login(lForce) {
    var frm = document.forms["form1"];
    if(checkForm(frm)) {
        //frm.submit();
        //$.cookie('login.userid', $("#userid").val(), { expires: 365,  path: '/' });
        if($("#saveid").is(":checked"))
        	$.cookie('login.saveid', $("#userid").val(), { expires: 30,  path: '/' });
        else {
        	$.removeCookie('login.saveid', {path:'/'});
        }

        if(lForce) {
            $('input:hidden[name=confirm]').val("T");
         }
        $.ajax({
            type: "POST",
            url: "<c:url value='/login/loginProc.do' />",
            data: $("#form1").serialize(),
            dataType: "json",
            success: function(data) {
                if(data.success == "true") {

                	//alertMessage(data.message);

                    if(!(data.return_url === null || data.return_url == '')) {
                    	top.location = data.return_url;
                    } else {
                        window.location = "<c:url value='/login/login.do' />";
                    }
					//2023.02.20 로그수집API
                    logSave($("#userid").val());
                } else {
                    if(data.alreadyLogin  == "true") {
                        if(confirm(data.message)) {
                            login(true);
                        }
                    } else {
                        $('input:text[name=confirm]').val("F");
                        alertMessage(data.message);
                    }

                    return false;
                }
            }
        });
    }
	return false;

}
function logSave(userId) {


 	var today = new Date();

 	var year = today.getFullYear();
 	var month = ('0' + (today.getMonth() + 1)).slice(-2);
 	var day = ('0' + today.getDate()).slice(-2);
 	var hours = ('0' + today.getHours()).slice(-2);
 	var minutes = ('0' + today.getMinutes()).slice(-2);
 	var seconds = ('0' + today.getSeconds()).slice(-2);

 	var dateString, paramUserid ;

 	paramUserid =  $("#userid").val();

 	dateString = year + '-' + month  + '-' + day + ' '+hours + ':' + minutes  + ':' + seconds + '.000' ;

 	var paramData = {
 		    'crtfcKey' : "$5$API$VUI5NgewCRf7zbB.nF4IkMtGVS5TW7qi52eG0IiWLN4",
 		    'logDt' : dateString,
 		    'useSe' : "접속",
 		    'sysUser' : paramUserid,
 		    'conectIp' : "<%=REMOTE_IP%>",
 		    'dataUsgqty' : "100"
 		};


 	$.ajax({
 	    type : "POST",
 	    url : "https://log.smart-factory.kr/apisvc/sendLogData.json",
 	    data : paramData,
 	    cache : false,
 	    dataType : "json",
 	    contentType : "application/x-www-form-urlencoded; charset=utf-8",
 	    success : function(data, textStatus, jqXHR) {
 	        var result = data.result;
 	      	//실행결과 출력
 	        // alert(result.recptnRsltCd);

 	    },
 	    error : function(jqXHR, textStatus, errorThrown) {
 	    },
 	    complete : function() {
 	    }
 	});




}
function alertMessage(message) {
	if(message != "") {
	 	alert(message);
	}
}

function changeSetup(newLang, newContextpath) {
	var path = "${serveletPath}";
	document.location=newContextpath + path + "?TlabSiteLanguage="+newLang;
}

function changeContext(context) {
	var path = "${serveletPath}";
	document.location=context + path;
}
var langArr = new Array() ;
	<c:forEach var="l" items="${langs}">
    	langArr.push("${l}");
    </c:forEach>
$(function() {

	$( "#setupFormDiv" ).dialog({
	    autoOpen: false,
	    height: langArr.length*20+210,//300,
	    width: 350,
	    modal: true,
	    buttons: {
	      '<t:message code="system.label.common.ok" default="확인" />': function() {

	    	  var newLang = $('input[name=newLang]:checked', '#formSetup').val();
	    	  var newContextpath = $('select[name=contextPath]', '#formSetup').val();

	    	  //$.cookie('login.context', newContextpath, { expires: 30,  path: '/' });

	    	  changeSetup(newLang, newContextpath );
	      },
	      '<t:message code="system.label.common.cancel" default="취소" />': function() {
	          $( this ).dialog( "close" );
	        }
	    } //buttons
	});
	$("input[name=newLang][value=" + lang + "]",'#formSetup').attr('checked', 'checked');

	$("#setupButton").button().click(function() {
	  	$("#setupFormDiv").dialog( "open" );
	});

	$("#loginButton").button();
});// function
</script>
</head>
<body onload="loadPage()">
	<div class="wrap_login_main" id="centered">
        <!-- content -->
        	<div class="login_main">
       			<form id="form1" name="form1" action="" onsubmit="login(false);return false" target='_new'>
       				<input type="hidden" name="confirm" value="F" />
		            <input type="hidden" name="TLAB_RETURN_URL" value="<c:url value='/' />" />
       			<table border='0' cellpadding='2' cellspacing='5' >
       			<colgroup>
       				<col width="276" />
       				<col width="90" />
       				<col width="90" />
       			</colgroup>
       			<tr >
       				<td  align=left>
       					<input type="checkbox" name="saveid" id="saveid" />
       					<label for="saveid"><t:message code="system.label.common.saveid" default="아이디저장" /></label>
       				</td>
					<td rowspan=3 >
       					<button  id="loginButton"></button>
       				</td>
       			</tr>
       			<tr height=52>

       				<td align=right valign=middle style='background:url("../resources/images/login/loginUserId.png"); background-repeat: no-repeat;'>
       					<input type="text" name="userid" id="userid" value="" class="login_input" tabindex="4" maxlength="30"/>
       				</td>
       				<!--<td><input type="checkbox" name="saveid" id="saveid" />
       					<label for="saveid"><t:message code="system.label.common.saveid" default="아이디저장" /></label>
       				</td>
       				<!--<td align=right>
       					<img id="setupButton" src="<c:url value='/resources/images/login/loginSetting.png' />" title="Setup" />
       				</td>-->

       			</tr>

       			<tr >
       				<td align=right valign=middle style='background:url("../resources/images/login/loginPassword.png"); background-repeat: no-repeat; '>
       					<input type="password" name="userpw" id="userpw" value="" class="login_input" maxlength="16" tabindex="5" autocomplete="off" />
       				</td>

       			</tr>
       			</table>
		        </form>
            </div>
	</div>

	<div id="setupFormDiv" title='<t:message code="system.label.common.settings" default="설정" />' style="display:none; text-align:left;">
		<form id="formSetup" name="formSetup" action="">
		<fieldset title="Language">
    	<legend><t:message code="system.label.common.language" default="언어" /></legend>
	   	<c:forEach var="l" items="${langs}">
    		<label><input type="radio" value="${l}"  name="newLang" /><t:message code="language.${l}" /></label><br/>
    	</c:forEach>
    	</fieldset>
    	<div style="height:10px;"></div>
    	<fieldset title="Language" >
    	<legend><t:message code="system.label.common.database" default="데이타베이스" /></legend>
    		<label>
    			<select name="contextPath">
    	<c:set var="currentContext"><%=contextPath%></c:set>
	   	<c:forEach var="c" items="${contexts}">
    				<option value="${c.path}"
    				<c:if test="${currentContext==c.path}">
    				selected
    				</c:if>
    				>${c.name}</option>
    	</c:forEach>
    			</select><br/>
    		</label>
    	</fieldset>

		</form>
	</div>
</body>
</html>