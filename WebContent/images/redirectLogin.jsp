<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html >
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="cache-control" content="no-cache" />
<meta http-equiv="pragma" content="no-cache" />
<script type="text/javascript">
	alert("Session expired!");
	
	try{
		var url = "<c:url value='/login/login.do'/>";
		// document.location.href	= url;
		document.location.replace(url) 
	}catch(e){
		console.log("Session expired redirectioin Exception : ", e);
	}

</script>
</head>
</html>