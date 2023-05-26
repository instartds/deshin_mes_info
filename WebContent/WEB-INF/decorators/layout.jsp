<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><decorator:title /></title>
<script type="text/javascript">
        var CPATH ='<%=request.getContextPath()%>';
</script>
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/resources/css/ui-lightness/jquery-ui-1.9.2.custom.css' />" />
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/resources/css/co/jquery.treeview.css' />" />
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/resources/css/lib/tipTip.css' />" />

<link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/resources/css/co/default.css' />" />
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/resources/css/co/unilite_common.css' />" />
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/resources/css/co/jqueryLayout.css' />" />
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/resources/css/ui.jqgrid.css' />" />


<!--[if IE]><link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/resources/css/co/iehacks.css' />"><![endif]-->


<script type="text/javascript" src="<c:url value='/js/jquery/jquery-1.8.3.js' />" ></script>
<script type="text/javascript" src="<c:url value='/js/jquery/jquery.form.js' />" ></script>

<script type="text/javascript" src="<c:url value='/js/jquery.ui/jquery-ui-1.9.2.custom.min.js' />" ></script>
<script type="text/javascript" src="<c:url value='/js/jquery.ui/jquery.ui.datepicker-en-GB.js' />" ></script>

<script type="text/javascript" src="<c:url value='/js/jqgrid/jquery.jqGrid.min.js' />" ></script>

<script type="text/javascript" src="<c:url value='/js/jquery/jquery.layout.js' />" ></script>
<script type="text/javascript" src="<c:url value='/js/jqueryUiCustoms.js' />" ></script>
<script type="text/javascript" src="<c:url value='/js/cm_common.js' />" ></script>
<decorator:head />
<script type="text/javascript">


</script>
</head>

<body onload="<decorator:getProperty property='body.onload' />">
	<!-- Content -->
	<div class="ui-layout-center">
		<decorator:body />
	</div>
	
	<div class="ui-layout-north">[ 인사 ] [ 회계 ] </div>
	<div class="ui-layout-south">South</div>
	<div class="ui-layout-east">East</div>
	<div class="ui-layout-west">West</div>
</body>
</html>
