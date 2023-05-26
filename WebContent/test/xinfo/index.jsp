<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="java.util.*"%>
<%@page import="java.net.*"%>
<%@page import="foren.framework.utils.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <jsp:include page="commonHeader.jsp" />
	<TITLE>System Status</TITLE>
<style type="text/css">
body,td {
	font-family: "Verdana", "Arial", "sans-serif";
	font-size: 12px;
}

.tdblue {
	background-color: #0000ff;
	color: #ffffff;
	text-align: center;
}

.tdred {
	background-color: #ff0000;
	color: #ffffff;
	text-align: center;
}
</style>
<script>
	console.log('console log test');
</script>
</head>
<body>
[${loginVO.userName }]
[<br/>
<%
	URL url = foren.framework.utils.FileUtil.getResource("/") ;
	
//			<div id="tabs-extDirectMapping">
//			<jsp:include page="xinfo_extDirectMappings.jsp"></jsp:include>
//		</div>
%>
URL = <%=url.toExternalForm() %><br/>
	File = <%=url.getFile() %>
 ]
	<script>
		$(function() {
			$("#tabs").tabs();
		});
	</script>
	<div id="tabs">
		<ul>
			<li><a href="#tabs-user">User</a></li>
			<li><a href="#tabs-jvm">Jvm info</a></li>
			<li><a href="#tabs-application">Application Info</a></li>
			<li><a href="#tabs-controller">Spring:Controller Information</a></li>
			<li><a href="#tabs-extDirectMapping">extDirectMapping</a></li>
			<li><a href="#tabs-allMessages">all Messsages</a></li>
			<li><a href="#tabs-requestMappings">Spring:RequestMappings</a></li>
		</ul>

		<div id="tabs-user">
			<jsp:include page="xinfo_user.jsp"></jsp:include>
		</div>
		<div id="tabs-jvm">
			<jsp:include page="xinfo_jvm.jsp"></jsp:include>
		</div>
		<div id="tabs-application">
			<jsp:include page="xinfo_application.jsp"></jsp:include>
		</div>
			<div id="tabs-controller">
			<jsp:include page="xinfo_controller.jsp"></jsp:include>
		</div>
	
		<div id="tabs-requestMappings">
			<jsp:include page="xinfo_requestMappings.jsp"></jsp:include>
		</div>
		<div id="tabs-allMessages">
			<jsp:include page="xinfo_message.jsp"></jsp:include>
		</div>
	
	</div>
</body>
</html>