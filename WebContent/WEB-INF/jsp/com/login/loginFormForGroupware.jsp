<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

request.setAttribute("loginBgImage",ConfigUtil.getString("common.login.loginBgImage", "loginBg.png"));

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
		margin:-300px 0 0 -425px;
		border: 1px solid #c5c5c5;
		position: fixed;
	}
	
	.wrap_login_main {
		background: url("../resources/images/login/${loginBgImage}");
		background-repeat: no-repeat; 
		width: 850px;
		height: 494px;
	}

	.login_main {
		position: absolute;
		left: 50px;
		top: 325px;
	}	

	#loginButton
	{
	    background-image: url("../resources/images/login/loginBtn.png");
	    background-repeat: no-repeat; 
	    border: none;    
	    width: 130px;
	    height: 40px;
	}

	.login_input 
	{
		width: 150px;
		height: 28px;
		border: 0 solid #000000;
		background-color: #bfbfbf;
		font-size: 18px;
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
    
    var cookieContext = $.cookie("login.context");
    var currentContext = "<%=contextPath%>";
    if(cookieContext){
    	if(currentContext != cookieContext)
    		changeContext(cookieContext);
    }
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
                	
                	alertMessage(data.message);
 
                    if(!(data.return_url === null || data.return_url == '')) {
                    	top.location = data.return_url;  
                    } else {
                        window.location = "<c:url value='/login/login.do' />";
                    }
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

$(function() {
	$( "#setupFormDiv" ).dialog({
	    autoOpen: false,
	    height: 300,
	    width: 350,
	    modal: true,
	    buttons: {
	      "OK": function() {
	      
	    	  var newLang = $('input[name=newLang]:checked', '#formSetup').val();
	    	  var newContextpath = $('select[name=contextPath]', '#formSetup').val();
	    	  
	    	  $.cookie('login.context', newContextpath, { expires: 30,  path: '/' });

	    	  changeSetup(newLang, newContextpath );
	      },
	      Cancel: function() {
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
       			<form id="form1" name="form1" action="" onsubmit="login(false);return false">
       				<input type="hidden" name="confirm" value="F" />
		            <input type="hidden" name="TLAB_RETURN_URL" value="<c:url value='/' />" /> 
       			<table border='0' cellpadding='2' cellspacing='5' >
       			<colgroup>
       				<col width="200" />
       				<col width="70" />
       				<col width="30" />
       			</colgroup>
       			<tr height=52>
       				<td align=right valign="middle" style='background:url("../resources/images/login/loginUserId.png"); background-size: 280px; background-repeat: no-repeat;'>
       					<input type="text" name="userid" id="userid" value="" class="login_input" tabindex="4" maxlength="10" />
       				</td>       				
       				<td width="70px">
       					<input type="checkbox" name="saveid" id="saveid"/> 
       					<label for="saveid"><t:message code="login.saveid" default="아이디 저장" /></label>			
       				</td>
       				<td>
       					<img id="setupButton" src="<c:url value='/resources/images/login/loginSetting.png' />" title="Setup" />
       				</td>
       			</tr>
       			<tr height=52>
       				<td align=right valign=middle style='background:url("../resources/images/login/loginPassword.png"); background-size: 280px; background-repeat: no-repeat; '>
       					<input type="password" name="userpw" id="userpw" value="" class="login_input" maxlength="16" tabindex="5" autocomplete="off" />
       				</td>
       				<td colspan=2>
       					<button id="loginButton"></button>
       				</td>
       			</tr>       			
       			</table>  
		        </form> 
            </div>          	
	</div>

	<div id="setupFormDiv" title="Setup" style="display:none; text-align:left;">
		<form id="formSetup" name="formSetup" action="">
		<fieldset title="Language">
    	<legend>언어</legend>
	   	<c:forEach var="l" items="${langs}">
    		<label><input type="radio" value="${l}"  name="newLang" /><t:message code="language.${l}" /></label><br/>
    	</c:forEach>
    	</fieldset>
    	
    	<fieldset title="Language" >
    	<legend>Database</legend>
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

<%
    if (ConfigUtil.getBooleanValue("system.isDevelopServer", false)) {
%>
<script type="text/javascript">
    function loginbyId(id,pw) {
        var frm = document.forms["form1"];
        frm.userid.value = id;
        frm.userpw.value = pw;
        login();
    }
</script>

<!-- <div style="border: none; position: fixed;; top:0;left:0; z-index: 10" >
	<center>
		<a href="javascript:loginbyId('unilite5','1111')">[unilite5] </a> |
		<a href="javascript:loginbyId('goindole','1111')">[goindole] </a> |
		<a href="javascript:loginbyId('goindole','xxxx')">[goindole(암호X)] </a> |
		<a href="javascript:loginbyId('leeyoong','1111')">[leeyoong] </a>
	</center>
</div> -->
<%
    }
%>


</body>
</html>	