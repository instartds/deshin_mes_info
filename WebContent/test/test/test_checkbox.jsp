<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
String optionType1 = request.getParameter("options");
String[] optionType2 = request.getParameterValues("options");	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE>Table Info</TITLE>

</head>
<body>
Type 1 : [<%=optionType1 %>]<br/>
Type 2 : [<%=optionType2 %>]<br/>
<form>
	<label >A1 : <input name="options" type="checkbox" value="a1" /></label>
	<label >A2 : <input name="options" type="checkbox" value="a2" /></label>
	<label >A3 : <input name="options" type="checkbox" value="a3" /></label>
	<br/>
	<input type="submit" />
	
</form>
<table border="1">
	<c:forEach var="aKey" items="${paramValues}">
		<tr>
			<td><c:out value="${aKey.key}" /></td>
			<td><c:forEach var="val" items="${aKey.value}">
					[<c:out value="${val}" />]<br />
				</c:forEach></td>
		</tr>
	</c:forEach>
	</table>
</body>
</html>