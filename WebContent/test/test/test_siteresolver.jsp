<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<jsp:include page="/WEB-INF/jsp/com/include/admin_header.jsp" flush="true"/>
<%
  	Enumeration ex =  request.getHeaderNames();
	System.out.println("============H===========" + request.getParameter("test1"));
   while ( ex.hasMoreElements()) {
       String obj =(String) ex.nextElement();
       System.out.println(obj + " = " +request.getHeader(obj)); 
   }
   
   HttpSession s = request.getSession();
   ex = s.getAttributeNames();
	System.out.println("=============S==========" );
   while ( ex.hasMoreElements()) {
       String obj =(String) ex.nextElement();
       System.out.println(obj + " = " +request.getHeader(obj)); 
   }
%>


url = [<%=request.getServerName() %>], site is [${ABLE_SITE }]
<jsp:include page="/WEB-INF/jsp/com/include/admin_footer.jsp" flush="true"/>