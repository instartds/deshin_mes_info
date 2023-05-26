<%@page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE>System Status</TITLE>
</head>

<body>
<a href="test_select.jsp"> [reload] </a><br/>
[t:select name="nmSelect" id="sel01" codeGroup="A022" ]<br/>
<t:select name="nmSelect" codeGroup="A022" dispStyle="1">
</t:select>
<hr/><br/><br/>
[t:select name="nmSelect" id="sel01" codeGroup="A008" showTitle="true"]<br/> 
<t:select name="nmSelect" id="sel01" codeGroup="A008" showTitle="true" dispStyle="1" />
<!-- <hr/><br/><br/> -->
<%-- <c:set var="cur" value="ce"/> --%>
<!-- [t:select name="nmSelect" id="sel02" codeGroup="COM006" dispStyle="1" selected="CF02"]<br/> -->
<%-- <t:select name="nmSelect" id="sel02" codeGroup="COM006" dispStyle="1" selected="CF02" > --%>
<%-- </t:select> --%>
</body>
</html>