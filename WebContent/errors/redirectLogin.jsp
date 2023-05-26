<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String loginPage = ConfigUtil.getString("common.login.loginPage", "/login/login.do");
	String ssoUse = ConfigUtil.getString("common.login.sso.use", "false");
	request.setAttribute("loginPage", loginPage);
	request.setAttribute("ssoUse", ssoUse);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="cache-control" content="no-cache" />
<meta http-equiv="pragma" content="no-cache" />
<script type="text/javascript">
var ssoUse = "${ssoUse}";
if(ssoUse =="false")	{
	alert("Session expired!");
}

/*
try{opener.parent.parent.parent.document.location.href	= "<c:url value='/common/login.do'/>"; self.close();}catch(e){}
try{opener.parent.parent.document.location.href	= "<c:url value='/common/login.do'/>"; self.close();}catch(e){}
try{opener.parent.document.location.href	= "<c:url value='/common/login.do'/>"; self.close();}catch(e){}
try{opener.document.location.href	= "<c:url value='/common/login.do'/>"; self.close();}catch(e){}
try{parent.parent.parent.document.location.href	= "<c:url value='/common/login.do'/>";}catch(e){}
try{parent.parent.document.location.href	= "<c:url value='/common/login.do'/>";}catch(e){}
try{parent.document.location.href	= "<c:url value='/common/login.do'/>";}catch(e){}
*/
//-->
try{document.location.href	= "<c:url value='${loginPage}'/>";}catch(e){console.log("Session expired redirectioin Exception : ", e);}

</script>
</head>
</html>