<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Unchecked Exception Invoked!</title>
<script> 
</script>
</head>
<body bgcolor="white">
Ha ocurrido error en el Servicio. Vuelva a intentar luego.<br>


<%
Throwable exception = (Throwable) request.getAttribute("exception");
exception.printStackTrace();
%>
</body>
</html>
