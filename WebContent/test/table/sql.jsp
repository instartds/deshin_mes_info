<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="foren.framework.utils.*"%>
<%@page import="java.util.*"%>
<%@page import="gudusoft.gsqlparser.*"%>
<%@page import="gudusoft.gsqlparser.pp.para.*"%>
<%@page import="gudusoft.gsqlparser.pp.stmtformatter.*"%>
<%@page import="gudusoft.gsqlparser.pp.para.styleenums.*"%>

<%
	String formattedSql = null;
	String srcSql = request.getParameter("srcSql");
    if (!ObjUtils.isEmpty(srcSql)) {
        formattedSql = GStringUtils.sqlFormat(  srcSql, true );
        //formattedSql = sqlFormat(  srcSql );
    }
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE>SQL Formatter</TITLE>
</head>
<body>
	<form method="post">

<textarea cols="132" rows="10" name="srcSql">${param.srcSql }</textarea>
		<input type="submit" value="Format SQL"/><br />
<textarea cols="132" rows="10" name="formattedSql">
<%=formattedSql%>				
</textarea>
	</form>

</body>
</html>