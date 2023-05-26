<%@ page language="java" contentType="text/html; charset=UTF-8" 	pageEncoding="UTF-8"%>
<%@ page import="foren.unilite.com.menu.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<title>TRA Cargo Management System</title>
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
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/co/dynatree/ui.dynatree.css' />" />

	<link rel="stylesheet" type="text/css" href="<c:url value='/css/jqgrid/ui.jqgrid.css' />" />
	
	<script type="text/javascript" src="<c:url value='/js/jquery/jquery-1.6.2.js' />" ></script>

	<!-- Input Mask -->
	<script type="text/javascript" src="<c:url value='/js/jquery/jquery.inputmask.js' />" ></script>
	<script type="text/javascript" src="<c:url value='/js/jquery/jquery.readonly.js' />" ></script>
	<script type="text/javascript" src="<c:url value='/js/jquery/jquery.inputmask.extentions.js' />" ></script>
	<script type="text/javascript" src="<c:url value='/js/jquery/jquery.inputmask.date.extentions.js' />" ></script>
	<script type="text/javascript" src="<c:url value='/js/jquery/jquery.inputmask.numeric.extentions.js' />" ></script>
	<script type="text/javascript" src="<c:url value='/js/jquery/jquery.maskMoney.js' />" ></script>
	<script type="text/javascript" src="<c:url value='/js/jquery/jquery.inputmask.default.js' />" ></script>

	
    <script type="text/javascript">
    $(function() {
        $("#srchValAll").change(function() {
            //Check/uncheck all the list's checkboxes
            $(".select_one").attr("checked", $(this).is(":checked"));
            //Remove the faded state
            $(this).removeClass("some_selected");
        });

        $(".select_one").change(
                function() {
                    if ($(".select_one:checked").length == 0) {
                        $("#srchValAll").removeClass("some_selected").attr(
                                "checked", false);
                    } else if ($(".select_one:not(:checked)").length == 0) {
                        $("#srchValAll").removeClass("some_selected").attr(
                                "checked", true);
                    } else {
                        $("#srchValAll").addClass("some_selected").attr(
                                "checked", true);
                    }
                });
        
        if ($(".select_one:checked").length == 0) {
            $("#srchValAll").removeClass("some_selected").attr(
                    "checked", false);
        } else if ($(".select_one:not(:checked)").length == 0) {
            $("#srchValAll").removeClass("some_selected").attr(
                    "checked", true);
        } else {
            $("#srchValAll").addClass("some_selected").attr(
                    "checked", true);
        }
        
        
    });
    </script>
    <style>
    
    input[readonly].text { background-color:  transparent; border:0; color:#000 !important; vertical-align: baseline; width: auto; margin:auto; text-align : left;} 
    </style>
</head>
<body id="body" 	>
<br/><br/><br/>
<form>
<label>FLOAT : 	<input type="text" name="t1" class="mask_float"/></label><br/>
<label>INT : 		<input type="text" name="t2" class="mask_int"  /></label><br/>
<label id="test_qqq">INT 1(read only) : 		<input type="text" name="t2_readonly" class="mask_int"/></label><br/>
<label >INT 2(read only) : 		<input type="text" name="t2_readonl2y" readonly="readonly" class="mask_int"/></label><br/>
<label>MONEY : 	<input type="text" name="t2" /></label><br/>

</form>
<button type="button" onclick="toReadOnly()"> to ReadOnly </button>
<button type="button" onclick="toNormal()"> to Normal </button>
 <script type="text/javascript">
	function toReadOnly() {
		$("input[name='t2_readonly']").readonly();
	}
	function toNormal() {
		$("input[name='t2_readonly']").readonly('reset');
	}
</script>
</body>
</html>
