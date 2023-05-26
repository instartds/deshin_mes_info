<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="foren.framework.utils.*" %>
<%@ page import="foren.unilite.com.constants.*" %>
<%
String qrUrl = (String)session.getAttribute("qrUrl");
%>
<!DOCTYPE html >
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <link rel="shortcut icon" href='<c:url value="/resources/images/main/logo.ico" />' type="image/x-icon" />
    <script type="text/javascript" src="<c:url value='/resources/js/jquery/jquery-1.10.2.js' />" ></script>
    <script type="text/javascript" src="<c:url value='/resources/js/jquery/jquery-ui-1.10.4.custom.min.js' />"></script>
    <!-- Input Mask -->
    <script type="text/javascript" src="<c:url value='/resources/js/opt_tab.js' />"></script>
    <link href="/resources/css/tab.css" rel="stylesheet" type="text/css">

<script type="text/javascript">
if(top != window) {
    top.location = window.location
  }
  
$(document).ready(function(){
    $("input[name=otpCode]").keydown(function (key) {
        if(key.keyCode == 13){//키가 13이면 실행 (엔터는 13)
            optCertification();
        }
    });

    $("input[name=smsCode]").keydown(function (key) {
        if(key.keyCode == 13){//키가 13이면 실행 (엔터는 13)
            smsCertification();
        }
    });
});

function init() {
    form1.otpCode.focus();
}

function optCreate() {
    $.ajax({
        type: "POST",
        url: "<c:url value='/login/otpCreate.do' />",
        data: $("#form1").serialize(),
        dataType: "json",
        success: function(data) {
            if(data.success == "true") {
                
                var qrUrl = "";
                qrUrl = qrUrl + "http://chart.apis.google.com/chart?cht=qr&chs=200x200&choe=UTF-8&chld=H|0&chl=";
                qrUrl = qrUrl + encodeURIComponent(data.qrUrl.substring(61, 88));
                qrUrl = qrUrl + data.qrUrl.substring(88, data.qrUrl.length);
                
                $("#optQRCode").empty().append('<img style="display: block;" src="' + qrUrl + '">');
                openLayer('layerPop2',45,58);          
            } 
        }
    });
}

function smsCreate() {
    $.ajax({
        type: "POST",
        url: "<c:url value='/login/smsCreate.do' />",
        data: $("#form1").serialize(),
        dataType: "json",
        success: function(data) {
            if(data.success == "true") {
                alert("SMS 사용자 등록이 완료되었습니다.\nSMS 코드 요청을 하실 수 있습니다.");                
            } else {
                alert("SMS 사용자 등록이 실패하였습니다.\n관리자에게 문의하여 주십시오.");
            }
        }
    });
}

/*
 * OTP 인증 전송
 */
function optCertification() {
    $("#optSelCheck").val("OTP")
    if($("#otpCode").val().length == 0) {
        alert("인증번호는 필수입력 항목입니다.");
        return false;
    }
    
    $.ajax({
        type: "POST",
        url: "<c:url value='/login/otpLoginProc.do' />",
        data: $("#form1").serialize(),
        dataType: "json",
        success: function(data) {
            console.log("data.success :: " + data.success);
            if(data.success == "true") {
                if(!(data.return_url === null || data.return_url == '')) {
                    top.location = data.return_url;  
                } else {
                    window.location = "<c:url value='/login/login.do' />";
                }
            } else {
                alert("OPT 인증에 실패하였습니다.\n다시 확인하여 주십시오.");
            }
        }
    });
    
    return false;

}

function smsRequest() {
    $("#optSelCheck").val("SMS")

    $.ajax({
        type: "POST",
        url: "<c:url value='/login/otpLoginProc.do' />",
        data: $("#form1").serialize() + "&smsRequestYn=Y",
        dataType: "json",
        success: function(data) {
            if(data.smsSendYn == "true") {
                alert("SMS 인증코드가 발송되었습니다.");
            } else {
                alert("핸드폰번호 오류입니다.\n관리자에게 문의하여 주십시오.");
            }
        }
    });

    return false;

}

/**
 * SMS 인증 전송
 */
function smsCertification() {
    
    if($("#smsCode").val().length == 0) {
        alert("인증번호는 필수입력 항목입니다.");
        return false;
    }

    $.ajax({
        type: "POST",
        url: "<c:url value='/login/otpLoginProc.do' />",
        data: $("#form1").serialize(),
        dataType: "json",
        success: function(data) {
            if(data.success == "true") {
                if(!(data.return_url === null || data.return_url == '')) {
                    top.location = data.return_url;  
                } else {
                    window.location = "<c:url value='/login/login.do' />";
                }
            }  else {
                alert("SMS 인증에 실패하였습니다.\n다시 확인하여 주십시오.");
            }
        }
    });

    return false;

}

</script>
</head>

<body class="otp_login_bg" onload="init()">
<form id="form1" name="form1" action="" onsubmit="return false">
    <input type="hidden" id="TLAB_RETURN_URL" name="TLAB_RETURN_URL" value="/" />
    <input type="hidden" id="optSelCheck" name="optSelCheck" value="OTP" />
<font size="1">ACCNT</font>
    <div id="otp_login_wrap">
        <div class="otp_login_logo"></div>

        <ul class="tab_bar tab_list">
            <li class="tab_select" onClick="$("#otpCode").focus();">OTP 인증</li>
            <li class="" onClick="$("#smsCode").focus();">SMS 인증</li>
        </ul>
        <div class="tab_contents">
            <!-- otp 인증 contents S -->
            <div id="otp" class="otp_contents">
                <input type="input" class="otp_input" id="otpCode" name="otpCode" placeholder="인증번호를 입력하세요" maxlength="6">
                <button class="otp_subm bg_yellow" type="button" align=center valign=middle onClick="optCertification()">전송</button>
                <div class="otp_area">
                    <button class="" type="button" onClick="openLayer('layerPop1',45,58)">OTP APP 받기</button>
                    <button class="" type="button" onClick="optCreate()">OTP 등록</button>
                </div>
                <!-- layer popup -->
                <div id="layerPop1">
                    <button onclick="closeLayer('layerPop1')" class="close">X</button>
                    <div>
                        <br><br>
                        <li>OTP APP 받기</li>
                        <br><br>
                        <a target="_blank" href="https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2"><b>Android</b></a>
                        <br><br>
                        <a target="_blank" href="https://itunes.apple.com/kr/app/google-authenticator/id388497605?mt=8"><b>iPhone</b></a>
                    </div>
                </div>
                <div id="layerPop2">
                    <button onclick="closeLayer('layerPop2')" class="close">X</button>
                    <div id="optQRCode" style="margin-top: 40px; padding-left: 130px;  " ></div>
                </div>
                <!-- layer popup -->
            </div>
            <!-- otp 인증 contents E -->
            <!-- otp 인증 contents S -->
            <div id="sms" class="sms_contents manner">
                <input type="input" class="otp_input" id="smsCode" name="smsCode" placeholder="SMS코드를 입력하세요" maxlength="6">
                <div class="sms_area">
                    <button class="" type="button" onClick="smsRequest()">SMS 코드 요청</button>
                    <button class="bg_yellow" type="button" onClick="smsCertification()">전송</button>
                </div>
                <button class="sms_subm" type="button" onClick="smsCreate()">SMS 등록</button>
            </div>
            <!-- otp 인증 contents E -->
        </div>
    </div>
</form> 
</body>
</html> 