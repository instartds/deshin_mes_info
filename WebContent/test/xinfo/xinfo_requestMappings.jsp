<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="java.util.*"%>
<%@page import="foren.framework.utils.*"%>
<%@page import="java.net.*"%>
<%@page import="java.io.*"%>
<%@page import="java.text.*"%>
<%@page import="java.lang.reflect.Method"%>
<%@ page import="org.springframework.core.io.Resource"%>
<%@ page import="org.springframework.core.io.support.PathMatchingResourcePatternResolver"%>
<%@ page import="org.springframework.core.type.classreading.*"%>
<%@ page import="org.springframework.core.type.*"%>
<%@ page import="org.springframework.web.servlet.mvc.annotation.*"%>
<%@ page import="org.springframework.web.bind.annotation.RequestMapping"%>
<style>
.list_panel {width: 100%; border-top: 1px solid #ccc;}
.list_panel  th {border-right: 1px solid #ccc;border-bottom: 1px solid #ccc;padding: 4px;background-color: #829FC1;color: #fff;}
.list_panel  td {border-right: 1px solid #ccc;border-bottom: 1px solid #ccc;padding: 4px;background-color: #fff;}
</style>
<table class="list_panel">
	<thead>
		<tr>
            <th>Request</th>
            <th>Contoller Class</th>
		</tr>
	</thead>
	<tbody  >
		<%
			DefaultAnnotationHandlerMapping am = null;
		  // org.springframework.web.servlet.mvc.annotation.DefaultAnnotationHandlerMapping 가 intercepter로 등록 되어 있어야 함. 
		  //  am =  (DefaultAnnotationHandlerMapping) ObjUtils.getBean("defaultInterceptorMapping");
		   if (am != null ) { 

				Map hm = am.getHandlerMap();
				for(Object obj : hm.keySet()) {
				    out.println("<tr>");
				    out.println("<td><a href='"+ request.getContextPath()+ obj + "'>" + obj +  "</a></td>");
				    out.println("<td>" +  hm.get(obj).getClass() +"</td>");
				    out.println("<td>" + "-"  +"</td>");
				    out.println("</tr>");
				}
			} %>

	</tbody>
</table>