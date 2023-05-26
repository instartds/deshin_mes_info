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

%>
<!DOCTYPE html >
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>

<%@ include file='/WEB-INF/jspf/commonHead.jspf' %>

	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/icons.css"/>"/>
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/app.css"/>"/>
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/common.css"/>"/>

	<link rel="shortcut icon" href='<c:url value="/resources/images/main/logo.ico" />' type="image/x-icon" />
	<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/jqueryui/smoothness/jquery-ui-1.10.4.custom.min.css" />' />
    <script type="text/javascript" src="<c:url value='/resources/js/jquery/jquery-1.10.2.js' />" ></script>
    <script type="text/javascript" src="<c:url value='/resources/js/jquery/jquery-ui-1.10.4.custom.min.js' />"></script>
    <!-- Input Mask -->
    <script type="text/javascript" src="<c:url value='/resources/js/jquery/jquery.inputmask.js' />" ></script>
    <script type="text/javascript" src="<c:url value='/resources/js/jquery/jquery.cookie.js' />" ></script>
    <script type="text/javascript" src="<c:url value='/resources/js/tlab/miya_validator.js' />"></script>



<style>

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
                    	top.location = "<c:url value='/main_m.do' />";
                    } else {
                        window.location = "<c:url value='/login/login_m.do' />";
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
<body class="authentication-bg" onload="loadPage()">

        <!-- content -->
        	<div class="account-pages mt-5 mb-5">
			<div class="container">
				<div class="row justify-content-center">
					<div class="col-lg-5">
						<div class="card">

							<!-- Logo -->
							<div class="card-header pt-3 pb-3 text-center bg-primary">
								<a href="#" class="login-logo"></a>
							</div>

							<div class="card-body p-4">

								<div class="text-center w-75 m-auto">
									<h4 class="text-dark-50 text-center mt-0 font-weight-bold">Sign In</h4>
									<!-- <p class="text-muted mb-4">Enter your id and password to access admin panel.</p> -->
								</div>
								<div class="tab-pane show active" id="custom-styles-preview">
									<%-- <form class="needs-validation" id="loginForm" novalidate method="post" action="<c:url value="/login/loginProc.do"/>"> --%>


       								<form id="form1" name="form1" action="" onsubmit="login(false);return false" target='_new'>
									<input type="hidden" name="confirm" value="F" />
		            				<input type="hidden" name="TLAB_RETURN_URL" value="<c:url value='/' />" />
										<div class="form-group mb-3">
											<label for="email">아이디</label>
											<!-- <input type="email" class="form-control" id="email" name="email" min="5" max="20"placeholder="" value="ksjin@synergyinno.com" required autocomplete="off"> -->
											<!-- <input type="email" class="form-control" id="email" name="email" min="5" max="20"placeholder="" value="coreaols@mkh.co.kr" required autocomplete="off">-->
											<!-- <input type="email" class="form-control" id="email" name="email" min="5" max="20"placeholder="" value="admin@synergysystems.co.kr" required autocomplete="off"> -->
											<!-- <input type="email" class="form-control" id="email" name="email" min="5" max="20"placeholder="" value="" required autocomplete="off" autofocus> -->
											<input type="text" id="userid" name="userid" class="form-control">
											<div class="invalid-feedback">

											</div>
										</div>

										<div class="form-group mb-3">
											<label for="member-password">패스워드</label>
											<!-- <input type="password" class="form-control" id="member-password" name="password"
												placeholder="" value="1" required autocomplete="off"> -->
											<input type="password" class="form-control" id="userpw" name="userpw"
												placeholder="" value="" required autocomplete="off" >
											<div class="invalid-feedback">
											</div>
										</div>
										<div class="form-group text-center">
											<button class="btn btn-outline-primary btn-rounded" type="submit">로그인</button>
										</div>

									</form>
								</div> <!-- end preview-->
							</div> <!-- end card-body -->
						</div>
						<!-- end card -->
<%--
						<div class="row mt-3">
							<div class="col-12 text-center">
								<p class="text-muted">Don't have an account? <a href="<c:url value="/cms/user/agreeSignUp.do"/>" class="text-muted ml-1"><b>Sign Up</b></a></p>
							</div> <!-- end col -->
						</div> --%>
						<!-- end row -->

					</div> <!-- end col -->
				</div>
				<!-- end row -->
			</div>
			<!-- end container -->
		</div>
		<!-- end page -->

		<footer class="footer footer-alt">
			© DELTA MES
		</footer>

</body>
</html>