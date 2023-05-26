<%@page import="java.io.File"%>
<%@ page import="foren.framework.utils.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
    //clipreport4.properties 서버환경에 따라 파일 위치를 지정합니다.
    //String propertyPath  = request.getSession().getServletContext().getRealPath("/") + File.separator +  "WEB-INF" + File.separator + "clipreport4" + File.separator + "clipreport4.properties";
	String contextName = JndiUtils.getEnv("CONTEXT_NAME", "default");
	String path = request.getSession().getServletContext().getRealPath("/");
	String[] directory = path.split(":");
	String drive = "";
	if(directory != null && directory.length >= 2)	{
		drive = directory[0]+":";
	}
	String basePath = ConfigUtil.getString("common.clipreport.basePath");
	String configPath = ConfigUtil.getString("common.clipreport.configPath") ;
	if(basePath != null)	{
		basePath = basePath.replace("/",File.separator);
	}
	if(configPath != null)	{
		configPath = configPath.replace("/",File.separator);
	}
	String propertyPath = drive +   basePath + contextName +  configPath +  "clipreport4.properties";
%>