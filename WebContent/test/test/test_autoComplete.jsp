<%@ page language="java" contentType="text/html; charset=UTF-8" 	pageEncoding="UTF-8"%>
<%-- <%@ page import="unipass.co.lib.menu.*" %> --%>
<%-- <%@ page import="unipass.co.service.*" %> --%>
<%
//  MenuNode menuNode = (MenuNode) request.getAttribute(TraMenuService.KEY_MENU_NODE_ATTRIBUTE);

//  String pageTitle = (menuNode != null ) ? menuNode.getMenuName(request):"No PageTitle" ;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Autocomplete Test</title>
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

	<script type="text/javascript" src="<c:url value='/js/jquery/jquery-1.6.2.js' />" ></script>

	<script type="text/javascript" charset="utf-8" src="<c:url value='/js/lib/jquery-ui-1.8.6.custom.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/lib/jquery.ui.datepicker-en-GB.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/lib/jquery.layout.js' />" ></script>
    <script type="text/javascript" src="<c:url value='/js/lib/jquery.maskedinput-1.2.2.min.js' />" ></script>
	<script type="text/javascript" src="<c:url value='/js/cm/jqueryUiCustoms.js' />" ></script>
	<script type="text/javascript" src="<c:url value='/js/cm/cm_common.js' />" ></script>
	<script type="text/javascript" src="<c:url value='/js/cm/message_en.js' />" ></script>
	
    <script type="text/javascript">
	$(document).ready(function() {
		cm.autoCompleteCode("errorCodeInput","COM062","errorCode");
		cm.autoCompleteComp("shpnglinCdInput","A","","shpnglinCd");
		cm.autoCompleteComp("shpnglinCdInput2","W",null,"shpnglinCd3");
		cm.autoCompleteComp("shpnglinCdInput3","W","I,W","shpnglinCd3");
        cm.autoCompleteComp("placeOfDlvryNm","W","I,T","placeOfDlvry",null); //ICD, Terminal
        cm.autoCompleteComp("warehouseNm","W","W","warehouseCd","*"); //ALL Customs Warehouse

	});
    </script>
</head>
<body>
<hr/>
[ <tl:message code="tlab.validator.errors.required"  arguments="a;b;c"/> ]<br/>
 [ <tl:message code="tlab.validator.errors.required"  /> ]  <br/>
 
 <form>
 	<label > Error Code (ex. fou) : <input type="text" name="errorCodeInput" /> </label>	<input type="text" name="errorCode" readonly="readonly"/> <br/>
 	<label > Company 1 : <input type="text" name="shpnglinCdInput" /> </label>	<input type="text" name="shpnglinCd" readonly="readonly"/><br/>
 	<label > Company 2 : <input type="text" name="shpnglinCdInput2" /> </label>	<input type="text" name="shpnglinCd2" readonly="readonly"/><br/>
 	<label > Company 3 : <input type="text" name="shpnglinCdInput3" /> </label>	<input type="text" name="shpnglinCd3" readonly="readonly"/><br/>
 	
 	<label>ICD & Terminal</label> <input type="text" name="placeOfDlvryNm" id="placeOfDlvryNm" /> 	<input type="text" name="placeOfDlvry" id="placeOfDlvry"/> cm.autoCompleteComp("placeOfDlvryNm","W","I,T","placeOfDlvry");<br/>
    <label>All Customs Warehouse</label> <input type="text" name="warehouseNm" id="warehouseNm" />    <input type="text" name="warehouseCd" id="warehouseCd" />
    cm.autoCompleteComp("warehouseNm","W","W","warehouseCd","*"); <br/>
    <span class="lookup_btn"  onclick="crgCommonCodeLookup('input[name=ntnltyOfVssl]', 'CM002', 'input[name=ntnltyOfVssl]', 'input[name=ntnltyOfVsslNm]')"></span>
    <a href="javascript:crgCommonCodeLookup('input[name=ntnltyOfVssl]', 'CM002', 'input[name=ntnltyOfVssl]', 'input[name=ntnltyOfVsslNm]')">Lookup</a>
 </form>
</body>
</html>