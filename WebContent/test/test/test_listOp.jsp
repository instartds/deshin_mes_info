<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="foren.framework.lib.listop.*"%>
<%
    String str1 = request.getParameter("listop1");
    ListOp listOp1 = new ListOp(str1);
    String str2 = request.getParameter("listop2");
    ListOp listOp2 = new ListOp(str2);
%>
<html>

<head>
</head>
<body>
	<form>
		<label> Str 1 : <input name="listop1" type="text" size="200" value="<%=str1%>" /></label><br />
		<label> Str 2 : <input name="listop2" type="text" size="200" value="<%=str2%>" /></label><br />
		 <input type="submit" />
	</form>
	<pre>
ListOp1 : <%=listOp1.getDecodedValue() %>
ListOp2 : <%=listOp2.getDecodedValue() %>
	</pre>
</body>
</html>

