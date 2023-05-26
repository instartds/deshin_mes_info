<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="foren.framework.utils.*"%>
<%@page import="java.util.*"%>
<%@page import="foren.unilite.com.service.TlabDbAdminService"%>
<%
	//@page import="org.eclipse.datatools.modelbase.sql.query.util.*"
%>
<%
	TlabDbAdminService commonService = (TlabDbAdminService) ObjUtils.getBean("tlabDbAdminService");
	String owner = "TRAINT";
	Map param = new HashMap();
	param.put("owner", owner);

	List<Map> tableList = commonService.getTablelList(param);
	request.setAttribute("tableList", tableList);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE>Table Info</TITLE>
<style>
body {
	margin: 0;
	padding: 0;
	font-family: Trebuchet MS, Tahoma, Verdana, Arial, sans-serif;
	font-size: 11px;
}
/* ANCHOR(inline) */
a {
	margin: 0;
	padding: 0;
}

a:link {
	text-decoration: none;
	outline: none;
	color: #000;
}

a:hover {
	text-decoration: underline;
}

a:visited {
	text-decoration: none;
	outline: none;
	color: #000;
}

a:active {
	text-decoration: none;
	outline: none;
}

table td {
	border: 1px solid #efefef;
}
</style>
</head>
<body>
	<table>
		<thead>
			<tr>
				<th>TableName</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="table" items="${tableList }">
				<tr>
					<td><a href="table_source.jsp?tableName=${table.name }" target="contents" title="${table.comments }">T: ${table.name }</a></td>
				</tr>
			</c:forEach>

		</tbody>
	</table>
</body>
</html>