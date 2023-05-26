<%@page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<TITLE>Table Info</TITLE>
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

	<script type="text/javascript"  charset="utf-8" src="<c:url value='/js/jquery/jquery-1.6.2.js' />" ></script>

	<script type="text/javascript" charset="utf-8" src="<c:url value='/js/lib/jquery-ui-1.8.6.custom.min.js' />"></script>
	<script type="text/javascript" charset="utf-8" src="<c:url value='/js/lib/jquery.ui.datepicker-en-GB.js' />"></script>
	<script type="text/javascript" charset="utf-8" src="<c:url value='/js/lib/jquery.layout.js' />" ></script>
    <script type="text/javascript" charset="utf-8" src="<c:url value='/js/lib/jquery.maskedinput-1.2.2.min.js' />" ></script>
	<script type="text/javascript" charset="utf-8" src="<c:url value='/js/cm/jqueryUiCustoms.js' />" ></script>
	<script type="text/javascript" charset="utf-8" src="<c:url value='/js/cm/cm_common.js' />" ></script>
	<script type="text/javascript" charset="utf-8" src="<c:url value='/js/cm/message_en.js' />" ></script>
	<script type="text/javascript" charset="utf-8" src="<c:url value="/validator.do"/>"></script>"text/javascript" src="<c:url value="/validator.do"/>"></script>
    <script type="text/javascript">
    </script>
<style>
select {
	width: 250px;
}
</style>
<script type="text/javascript">
	var CODE_SELECTOR =  "/ajax/getCodeList.do";
</script>

<up:jqCodeVars codeGroup="CM032" name="typeSelect"></up:jqCodeVars>
</head>
<body>
	<form name="testFrm">
		<table border="1" cellspacing="0" cellpadding="2">
			<tr>
				<th>Group Code</th>
				<th>Detail Code</th>
			</tr>
			<tr>
				<td><up:select name="grodupCode" codeGroup="CM041"
					onchange="cm.jsSelect(CODE_SELECTOR,'{codeGroup:'+this.value+'}', $('#detailCD') );;">
				</up:select></td>
				<td><select name="detailCD" id="detailCD" size="5">
						<option value=""></option>
						<option value="1">1</option>
						<option value="2">2</option>
				</select></td>
			</tr>
		</table>
	</form>
	

	<script type="text/javascript">
		$(document).ready(
						function() {
							cm.jsSelect(CODE_SELECTOR, {codeGroup:'CM041'}, $('#mrn'));

							$('#mrn').change(
									function() {
											cm.jsSelect(
													CODE_SELECTOR,
													{codeGroup:'CM029',option:this.value}, $('#abc'));
											$('#qqq')[0].options.length = 0;
											
							});
							$('#abc').change(
									function() {
											cm.jsSelect(
													CODE_SELECTOR,
													{codeGroup:'CM029',option:this.value}, $('#qqq'));
											
							});

							
						});
	</script>
	<table border="1" cellspacing="0" cellpadding="2">
		<tr>
			<th>Type A</th>
			<th>Type b</th>
			<th>TypeC</th>
		</tr>
		<tr>
			<td><select name="mrn" id="mrn" size="5" ></select></td>
			<td><select name="abc" id="abc" size="5"></select></td>
			<td><select name="qqq" id="qqq" size="5"><option>asdasd</option><option>qqq</option></select></td>
		</tr>
	</table>


</body>
</html>