<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<table width="800" border="1" cellpadding="2" cellspacing="0">
				<tr>
					<th>param</th>
					<th>values</th>
				</tr>
				<tr>
					<td colspan="2">
						<h3>Application Scope:</h3></td>
				</tr>
				<c:forEach var="aKey" items="${applicationScope}">
					<tr>
						<th colspan="2"><c:out value="${aKey.key}" />
						</th>
					</tr>
					<tr>
						<td colspan="2">${fn:replace(aKey.value, ";", "<br/>")}</td>
					</tr>
				</c:forEach>

				<tr>
					<td colspan="2">
						<h3>requestScope</h3></td>
				</tr>
				<c:forEach var="aKey" items="${requestScope}">
					<tr>
						<td><c:out value="${aKey.key}" />
						</td>
						<td>[<c:out value="${aKey.value}" />]</td>
					</tr>
				</c:forEach>

				<tr>
					<td colspan="2">
						<h3>initParam</h3></td>
				</tr>
				<c:forEach var="aKey" items="${initParam}">
					<tr>
						<td><c:out value="${aKey.key}" />
						</td>
						<td>[<c:out value="${aKey.value}" />]</td>
					</tr>
				</c:forEach>

				<tr>
					<td colspan="2">
						<h3>pageScope</h3></td>
				</tr>
				<c:forEach var="aKey" items="${pageScope}">
					<tr>
						<td><c:out value="${aKey.key}" />
						</td>
						<td>[<c:out value="${aKey.value}" />]</td>
					</tr>
				</c:forEach>
				<tr>
					<td colspan="2">
						<h3>CONFIGUREAIONS</h3></td>
				</tr>
				<c:forEach var="aKey" items="${CONFIGUREAIONS}">
					<tr>
						<td><c:out value="${aKey.key}" />
						</td>
						<td>[<c:out value="${aKey.value}" />]<br /> <c:forEach var="cmd" items="${aKey.value.commandMapping}">
								<a href="<c:url value='${aKey.key}${cmd.key}'/>" target="show"><c:out value="${cmd.key}" /> </a> | <c:out
									value="${cmd.value.type}" />
								<br />
							</c:forEach>
						</td>
					</tr>
				</c:forEach>
			</table>