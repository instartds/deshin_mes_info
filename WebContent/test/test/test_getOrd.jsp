<%@page language="java" contentType="text/html; charset=utf-8"%>

<%@ page import="foren.unilite.com.service.TlabCommonService" %>
<%@ page import="foren.framework.utils.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE>System Status</TITLE>
</head>

<body>
--------------------------------<br/>
<%
    String tableName ="CO_ORDINAL" ;
	String docType ="DISDEC";
	String prefix ="FWRD1207";
	String suffix ="";
	int length = 5;
	TlabCommonService commonService = (TlabCommonService) ObjUtils.getBean(TlabCommonService.COMMON_SERVICE_BEAN_ID);
	String documentNo = commonService.getOrdinal(docType, prefix, length, suffix);
	//getOrdinal(String type, String prefix, int length, String suffix)
%>
관련 Table : [<%=tableName %>] <br/>
String docType = [<%=docType %>]<br/>
String prefix = [<%=prefix %>] CmpnyDspId + YYMM<br/>
int length = [<%=length %>]<br/>
===============================<br/>
<pre>
CommonService commonService = (CommonService) ObjUtils.getBean(CommonService.COMMON_SERVICE_BEAN_NAME);
String documentNo = commonService.getOrdinal(type, prefix, length, "");
Document Type = [<%=docType %>]
Document No = [ <%=documentNo %>]
</pre>

==============================<br/>

--------------------------------<br/>
