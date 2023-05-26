<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.clipsoft.clipreport.oof.OOFFile"%>
<%@page import="com.clipsoft.clipreport.oof.OOFDocument"%>
<%@page import="com.clipsoft.clipreport.oof.connection.*"%>
<%@page import="java.io.File"%>
<%@page import="com.clipsoft.clipreport.server.service.ReportUtil"%>
<!DOCTYPE html ${DOC_TYPE} >
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<title>Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="./css/clipreport.css">
<link rel="stylesheet" type="text/css" href="./css/UserConfig.css">
<link rel="stylesheet" type="text/css" href="./css/font.css">
<script type='text/javascript' src='./js/jquery-1.11.1.js'></script>
<script type='text/javascript' src='./js/clipreport.js'></script>
<script type='text/javascript' src='./js/UserConfig.js'></script>
<script type='text/javascript'>
	function json2rawUrl(obj) {
		var s = [],r20 = /%20/g,
			add = function( key, value ) {
				s[ s.length ] = encodeURIComponent( key ) + "=" + encodeURIComponent( value );
			};
		for ( var prefix in obj ) {
         	add(prefix, obj[prefix]);
		}

	    return s.join( "&" ).replace( r20, "+" );
	}

var urlPath = document.location.protocol + "//" + document.location.host;
function loadReportForPdf(reportUrl)	{
	var data = JSON.parse(decodeURI('<%=request.getParameter("params")%>'));

    // Use XMLHttpRequest instead of Jquery $ajax
    xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        var a;
        if (xhttp.readyState === 4 && xhttp.status === 200) {
            // Trick for making downloadable link
            a = document.createElement('a');
            a.href = window.URL.createObjectURL(xhttp.response);
            // Give filename you wish to download
            a.download = data.PGM_ID+".pdf";
            a.style.display = 'none';
            document.body.appendChild(a);
            a.click();
        }
    };
    // Post data to URL which handles post request
    xhttp.open("POST", reportUrl);
    xhttp.setRequestHeader("Content-Type", "application/json");
    // You should set responseType as blob for binary responses
    xhttp.responseType = 'blob';
    xhttp.send(JSON.stringify(data));
}
function loadReport(reportUrl)	{
	var extraParam = JSON.parse(decodeURI('<%=request.getParameter("params")%>'));
	
	$.ajax({
            url: reportUrl,
            type: "POST",
            data: JSON.parse(JSON.stringify(extraParam)),
            dataType: "json",
            success: function(data) {
            	if(data.success == "true") {
                	html2xml('targetDiv1', data.resultKey)
                }
            }
        });
}
function html2xml(divPath, resultKey){
    //var reportkey = "";
	var report = createImportJSPReport("./Clip.jsp", resultKey, document.getElementById(divPath));
    var directPrint = '<%=request.getParameter("directPrint")%>';
    if(directPrint == "Y")	{
		report.setDirectPrint(true);
    }
    //20181217 인쇄 버튼 클릭시 html/pdf 인쇄 선택하는 미들창 생략하고(인쇄 미리보기로 가는 절차 간소화) 바로 pdf인쇄 미리보기로 이동
    report.setStartPrintButtonEvent(function(){
		report.printView();//pdf출력, 브라우저 인쇄 미리보기로 출력을 원할 경우 report.printHTMLView();

		return false;
    })
	//리포트 실행
    report.view();
}

</script>
</head>
<body>
<div id='targetDiv1' style='position:absolute;top:5px;left:5px;right:5px;bottom:5px;'><span style="margin-left:600px;margin-top:150px"><img src="./img/deploying.gif" border=0 width="80" height="80"/></span></div>
<script>
var printOption = '<%=request.getParameter("pdfPrint")%>';
if(printOption == "Y")	{
	loadReportForPdf('<%=request.getParameter("file")%>');
} else {
	loadReport('<%=request.getParameter("file")%>');
}
</script>
</body>
</html>
