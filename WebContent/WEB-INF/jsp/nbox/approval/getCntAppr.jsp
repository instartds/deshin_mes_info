<%@page language="java" contentType="text/html; charset=utf-8"%> 
<%

String  cnt = (String) request.getAttribute("CNT");

if (cnt == null ) cnt = "3";
%>	
{"<%=cnt %>"}
