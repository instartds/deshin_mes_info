<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="java.util.*"%>
<%@page import="foren.framework.lib.listop.ListOp"%>
<%@page import="foren.framework.utils.ObjUtils"%>
<%@page import="foren.framework.model.ExtHtttprequestParam"%>
<%@page import="foren.framework.model.NavigatorInfo"%>
<%
	final String[] searchFields = { "srch_cdnm" };

	ListOp listOp = new ListOp();
	listOp.put("srchVal3", request.getParameterValues("srchVal3"));
	ExtHtttprequestParam _req = new ExtHtttprequestParam();
	NavigatorInfo navigator = new NavigatorInfo(_req, listOp, searchFields);

	navigator.setList(null);
	request.setAttribute("LISTOP", listOp);
%>

<html>
<head>
</head>
<body>
<form>
	<label for="srchVal3"> checked</label> :
		<up:checkbox name="srchVal3" codeGroup="CM046" curValue="${LISTOP.ht.srchVal3 }" option="E" connector="&nbsp;" seperator=" &nbsp;&nbsp;" class="checkbox" />
		<input type="submit"/>
</form>

ListOp.value = ${LISTOP.value }<br/>
ListOp.ht = ${LISTOP.ht }<br/>
ListOp.ht.srchVal3 = 
<c:forEach var="t" items="${LISTOP.ht.srchVal3 }" >${t },</c:forEach>

</body></html>