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
	uris.forEach( function(uri, idx)	{
		 alert('로그아웃 되었습니다.');
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
    document.location = "${CPATH}/";
}
</script>


</html>