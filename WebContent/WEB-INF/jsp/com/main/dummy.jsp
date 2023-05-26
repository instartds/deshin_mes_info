<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html id="htmlTag" xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US" dir="ltr">
<head>
</head>
<body>
Request Locales = [<c:forEach var="loc" items="${pageContext.request.locales}"> ${loc}, </c:forEach> ]<br/>
Response Locale = "${pageContext.response.locale}"<br/>
<table width="800" border="1" cellpadding="2" cellspacing="0">
	<c:forEach var="aKey" items="${pageContext.request.cookies}">
		<tr>
			<td><c:out value="${aKey.name}" /></td>
			<td><c:forEach var="val" items="${aKey.value}">
	     [<c:out value="${val}" />]<br />
				</c:forEach></td>
		</tr>
	</c:forEach>	
</table>
</body>
</html>