<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="java.util.*" %>
<%
	List selected = new ArrayList();
	selected.add("CF03");
	selected.add("CF14");
	request.setAttribute("selected", selected);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE>Checkbox test</TITLE>
</head>


<body>
<a href="test_checkbox.jsp"> [reload] </a><br/>
[up:select name="nmSelect" id="sel01" codeGroup="COM062" titleCode="LABEL.com.select.all" class="red b" style="height:none"]<br/>

[up:select name="nmSelect" id="sel01" codeGroup="COM064" showTitle="true"]<br/>
<c:set var="cur" value="ce"/>
[up:select name="nmSelect" id="sel02" codeGroup="COM006" dispStyle="1" selected="CF02"]<br/>


<input type="checkbox" value ="1" checked="checked"> - A1 <br/>
<up:checkbox name="nmSelect"  codeGroup="COM006" curValue="CF10"  seperator=" &nbsp; , &nbsp;" class="checkbox"/><br/>
[${selected }]<br/>
<up:checkbox name="nmSelect"  codeGroup="COM006"  curValue="${selected }" connector=" - "/><br/>
</body>
</html>