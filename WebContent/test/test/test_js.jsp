<%@page language="java" contentType="text/html; charset=utf-8"%>
<jsp:include page="/WEB-INF/jsp/com/include/admin_header.jsp" flush="true"/>
<script type="text/javascript">

function openModalC() {
	gls.openModalC(CPATH+'/test/test_poppage.jsp', '', 400, 300);
}
function openWindowC() {
	gls.openWinC(CPATH+'/test/test_poppage.jsp','owin','', 400, 300);
}
function openWindow() {
	gls.openWin(CPATH+'/test/test_poppage.jsp','owin', '', 400, 300);
}
</script>

<a href="javascript:openModalC()"> Open ModalWindow in center </a><br/>
<a href="javascript:openWindowC()"> Open Windows in center </a><br/>
<a href="javascript:openWindow()"> Open Windows  </a><br/>
<jsp:include page="/WEB-INF/jsp/com/include/admin_footer.jsp" flush="true"/>