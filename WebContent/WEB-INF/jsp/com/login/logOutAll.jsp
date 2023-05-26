<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="foren.framework.utils.*" %>
<%@ page import="foren.unilite.com.constants.*" %>
<%@ page import="javax.servlet.http.*" %>
<%

Locale locale = LocaleUtils.getSafeLocale(request);
String curLang = locale.getLanguage();
String contextPath = request.getContextPath();
request.setAttribute("mainDomain",  ConfigUtil.getString("servers[@domain]", ""));
request.setAttribute("CPATH", contextPath );

%>
<%
//로컬 사용자 아이피 확인
String REMOTE_IP = request.getRemoteAddr();

%>
<!DOCTYPE html >
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>

<%@ include file='/WEB-INF/jspf/commonHead.jspf' %>
</head>
<body>
</body>
<script type="text/javascript">
<c:if test="${not empty mainDomain}">
	document.domain = '${mainDomain}';
</c:if>
var uris = ${logOutUrls}

if(uris != "undefined")	{
	 alert('로그아웃 되었습니다.');
	uris.forEach( function(uri, idx)	{
		var iframe = document.createElement('iframe');
		iframe.src = uri+"/login/actionLogout.do";
		iframe.style="border:none;";
		iframe.width= 0;
		iframe.height= 0;
		iframe.frameborder=0;
		if(idx == uris.length-1)	{
			//iframe.onload = onLoadHandler;
		}
	    //document.write("<iframe src='"+uri+"/login/actionLogout.do' width=1 height=1 "+ (idx == (uris.length-1) ? "onload='onLoadHandler()'":"") +" ></iframe>"
		document.body.appendChild(iframe);
	})
	setTimeout(onLoadHandler(),1000);
}

function onLoadHandler() {


	logSave($("#userid").val("test"));

    alert('로그아웃 되었습니다.');
    document.location = "${CPATH}/";
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
 		    'useSe' : "종료",
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
 	         alert(result.recptnRsltCd);

 	    },
 	    error : function(jqXHR, textStatus, errorThrown) {
 	    },
 	    complete : function() {
 	    }
 	});




}
</script>


</html>