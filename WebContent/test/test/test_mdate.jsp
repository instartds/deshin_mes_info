<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="foren.framework.lib.calendar.MDate" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE>Mdate Test</TITLE>

</head>
<body>
<%
	MDate date = new MDate();
%>
Year = [<%=date.getYear() %>]<br/>
month = [<%=date.getMonth() %>]<br/>
day = [<%=date.getDay() %>]<br/>
hour = [<%=date.getHour() %>]<br/>
minute = [<%=date.getMinute() %>]<br/>
</body>
</html>