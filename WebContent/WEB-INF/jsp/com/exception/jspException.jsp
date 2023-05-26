<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" contentType="text/html" %>

Ha ocurrido error durante el Proceso de la solicitud.

<jsp:useBean id="now" class="java.util.Date" />
  -----<br/>
  ${now}<br/>
  ErrorDate :  ${pageContext.errorData}<br/>
  Request that failed: ${pageContext.errorData.requestURI}<br/>
  Status code: ${pageContext.errorData.statusCode}<br/>
<br/>
<%= exception + " : " + exception.getMessage() %><br/>
  -----<br/>
<%
Exception ex = pageContext.getException();
ex.printStackTrace(System.out);
%>

