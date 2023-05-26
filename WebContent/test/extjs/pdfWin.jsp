<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm100ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="B015" />  <!--  거래처구분    -->  
<t:ExtComboStore comboType="AU" comboCode="B010" />  <!--  거래처구분    -->  

</t:appConfig>
<script type="text/javascript" >
function prHum960() {
	var win = Ext.create('Unilite.com.window.PDFPrintWindow', {
		prgID:'hum960rkr',
		url: CPATH+'/human/hum960rkrPrint.do',
		extParam: {
			PERSON_NUMB:'10138'
		}
	});
	win.show();
}


function appMain() {
	Unilite.Main({
		items : [{
				contentEl : "menus",
				title : 'Best ERP',
				closable : false
			}]
	});  
}
</script>
<div id="menus">
<ul >
    <li><a href="/g3erp/sales/downloadJasperSample.do" target="_blank">Report(거래명세서)</a></li>
    <li><a href="#" onclick='prHum960();' >Report(거래명세서-window)</a></li>
    <li><a href="/g3erp/download/downloadJasperSample.do" target="_blank">Report(거래명세서 X)</a></li>
    <li><a href="/g3erp/human/hum960rkrPrint.do?PERSON_NUMB=10138" target="_blank">인사기록(pdf)</a></li>
    <li><a href="/g3erp/human/hum960rkrPrint.do?PERSON_NUMB=10138&reportType=xlsx" target="_blank">인사기록(xlsx)</a></li>
    <li><a href="/g3erp/human/hum960rkrPrint.do?PERSON_NUMB=10138&reportType=docx" target="_blank">인사기록(docx)</a></li>
    <li><a href="#" onclick='prHum960();' >Report(인사기록카드-window)</a></li>
</ul>
</div>