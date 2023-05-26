<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="com.google.gson.*" %>
<%@page import="foren.framework.lib.json.*" %>
<%@page import="java.util.*" %>
<%

String jsonStr = "{'miv_end_index':'15','srchVal3':['CO','ER','RE'],'miv_pageSize':'15','srch_cdnm':''}";

GsonBuilder gsonBuilder = new GsonBuilder();
gsonBuilder.registerTypeAdapter(Map.class, new NaturalDeserializer());
Gson gson = gsonBuilder.create();
Object natural = gson.fromJson(jsonStr, Map.class);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>GSON Test</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta http-equiv="cache-control" content="no-cache" />
	<meta http-equiv="pragma" content="no-cache" />
</head>
<body><a><%=natural %></a>
</body>
</html>