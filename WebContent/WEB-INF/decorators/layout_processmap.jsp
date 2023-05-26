<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ page import="foren.framework.utils.*" %>
<!DOCTYPE html ${DOC_TYPE} >
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=8" /><![endif]-->
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<title>Unilite</title>
<script type="text/javascript">
	var CPATH ='<%=request.getContextPath()%>';
	function openTab( vPrgID, vUrl, params) {
		var rec = {data : {prgID : vPrgID, 'text':''}};
		parent.openTab(rec, vUrl , params);	
	}
</script>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	
	boolean isDevelopServer = ConfigUtil.getBooleanValue("system.isDevelopServer", true);
	request.setAttribute("isDevelopServer", isDevelopServer);
    if(isDevelopServer) {
    	if(extjsVersion.equals("4.2.2")) {
    		request.setAttribute("ext_url", "/extjs_"+extjsVersion+"/ext-all-dev.js");
    	}else{
    		request.setAttribute("ext_url", "/extjs_"+extjsVersion+"/ext-all-debug.js");
    	}
    } else {
    	request.setAttribute("ext_url", "/extjs_"+extjsVersion+"/ext-all.js");
    }
    

	request.setAttribute("css_url", "/extjs_"+extjsVersion+"/resources/ext-theme-classic-omega/ext-overrides.css");
    request.setAttribute("ext_root", "extjs_"+extjsVersion);
    request.setAttribute("ext_version", extjsVersion);
    
%>

<c:if test="${param.processID == 'sop0000'}">
	<link rel="stylesheet" type="text/css" href='<c:url value="${css_url }" />' />
	<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/unilite_${ext_version}.css" />' />	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url }" />'></script> 
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/overrides/ext-overrides.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/overrides/ext-bug-overrides.js" />' ></script>
	
</c:if>
</head>
<body>
<c:if test="${param.processID ne 'sop0000'}">
<c:url var='imageUrl' value='/resources/process/${param.processID}.png' />
<img usemap="#processmap" src ="${imageUrl}" />
</c:if>
<decorator:body />

</body>
</html>