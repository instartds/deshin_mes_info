<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="java.util.*" %>
<%
double cnt = 1234567.12345;
request.setAttribute("cnt",cnt);
request.setAttribute("today",new Date());


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE>System Status</TITLE>
</head>

<body>
	<hr />
	&lt;t:out value="1+1" /&gt; = <t:out value="1+1" /><br />
	&lt;t:out value="${cnt }" format="currency" /&gt; = [<t:out value="${cnt }" format="currency"  /> ]<br/>
	&lt;t:out value="${cnt }" format="float" /&gt; = [<t:out value="${cnt }" format="float"  /> ]<br/>
	&lt;t:out value="${cnt }" format="float2" /&gt; = [<t:out value="${cnt }" format="float2"  /> ]<br/>
	&lt;t:out value="${cnt }" format="float3" /&gt; = [<t:out value="${cnt }" format="float3"  /> ]<br/>
	 [<t:out value="${today }"  /> ]<br/>
	 [<t:out value="${today }"  format="fulldatetime"/> ]<br/>
	
	<table border="1">
		<thead>
			<tr>
				<th>Expression</th>
				<th>out</th>
			</tr>
		</thead>
		<tbody>
			<c:set var="t1" value="10" />
			<c:set var="t2" value="15" />
			<tr>
				<td><t:out value="" td="true" /></td>
				<td><t:out value="${t1 + t2}" />/ <c:out value="${t1 + t2}" />
				</td>
			</tr>
			<tr>
				<td>CodeGroup : F = <t:out value="1"  codeGroup="X002" /></td>
				<td><t:out value="${t1 + t2}" />/ <c:out value="${t1 + t2}" /></td>
			</tr>
		</tbody>
	</table>
</body>
</html>