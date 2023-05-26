<%@page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title></title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta http-equiv="cache-control" content="no-cache" />
	<meta http-equiv="pragma" content="no-cache" />

	<script type="text/javascript">
	        var CPATH ='<%=request.getContextPath()%>';
	</script>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/co/default.css' />" />
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/co/jquery-ui-1.8.4.custom.css' />" />
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/co/jqueryLayout.css' />" />
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/cm/crg_common.css' />" />
	
	<script type="text/javascript" src="<c:url value='/js/jquery/jquery-1.6.2.js' />"></script>
	
	<script type="text/javascript" charset="utf-8" src="<c:url value='/js/lib/jquery-ui-1.8.6.custom.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/lib/jquery.ui.datepicker-en-GB.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/lib/jquery.layout.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/lib/jquery.maskedinput-1.2.2.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/cm/jqueryUiCustoms.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/cm/cm_common.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/cm/message_en.js' />"></script>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/jqgrid/ui.jqgrid.css' />" />
	<script type="text/javascript" src="<c:url value='/js/jqgrid/i18n/grid.locale-en.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/jqgrid/jquery.jqGrid.min.js' />"></script>
</head>
<body>

	<table id="list2"></table>
	<div id="pager2"></div>
	<script type="text/javascript">
		jQuery("#list2").jqGrid({
			url : CPATH + '/cmi/vessel/selectVesselOperationList.do',
			datatype : "json",
			colNames : [ 'Inv No', 'Date', 'Client' ],
			colModel : [ {
				name : 'cdid',
				index : 'cdid',
				width : 55
			}, {
				name : 'cdexplntn',
				index : 'cdexplntn',
				width : 90
			}, {
				name : 'cdnm',
				index : 'cdnm',
				width : 100
			} ],
			rowNum : 10,
			rowList : [ 10, 20, 30 ],
			sortname : 'cdid',
			jsonReader : {
				repeatitems : false,
				id : "jqID"
			},
			viewrecords : true,
			sortorder : "desc",
			caption : "JSON Example"
		});
	</script>

</body>
</html>