<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="unipass.co.vo.*"%>
<%@page import="foren.framework.web.support.*"%>
<%@page import="foren.framework.utils.*"%>
<%
	try {
		ExtHtttprequestParam eReq = RequestParamParser.parse(request);

		request.setAttribute("items", eReq.getAllFiles());
		request.setAttribute("items2", eReq.getFiles("a"));
	} catch (Exception e) {

	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
	<c:forEach var="item" items="${items }">
- ${item } <br />
	</c:forEach>
	<hr/>
	 <c:forEach var="item" items="${items2 }">
- ${item } <br />
    </c:forEach>
	<form method="POST" enctype="multipart/form-data">
		<input type="file" name="a"/>
        <input type="file" name="a"/>
         <input type="submit" />
	</form>
</body>
</html>