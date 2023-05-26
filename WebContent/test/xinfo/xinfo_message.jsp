<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<table border="1">
	<thead>
		<tr>
			<th>Message</th>
		</tr>
	</thead>
	<tbody>
		 <c:forEach items="${requestContext.allMessages}" var="message">
			<tr>
				<td>${message.text}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>