<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>

<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/vendor/jquery-jvectormap-1.2.2.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/icons.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/app-dark.css"/>" id="dark-style" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/hyper/app.css"/>" id="light-style" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/timepicki/timepicki.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/datatables/dataTables.bootstrap4.min.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/datatables/buttons.bootstrap4.min.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap/bttn/bttn.css"/>" />

</head>

<style>

.dataTable{
	table-layout:fixed;
}
</style>
<body>

<script type="text/javascript">
	var CPATH ='<%=request.getContextPath()%>';
</script>

	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/vendor.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap/hyper/app.min.js"></script>
	
	<script src="${pageContext.request.contextPath}/resources/js/bootstrap/datatables/datatables.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/bootstrap/datatables/dataTables.bootstrap4.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/bootstrap/timepicki/timepicki.js"></script>

	<script src="${pageContext.request.contextPath}/resources/js/bootstrap/common/util.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/bootstrap/common/controll.js?ver=1.0"></script>	






<decorator:body />



</body>
</html>
