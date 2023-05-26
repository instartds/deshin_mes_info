<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="java.util.*" %>
<%@page import="foren.unilite.com.code.*" %>
<%@page import="foren.unilite.com.utils.*" %>
<jsp:include page="_testHeader.jsp" />
<%
	List codes = new ArrayList();
	codes.add( CodeUtil.getCompCodeList("MASTER", "A001", null, true));
	codes.add( CodeUtil.getCompCodeList("MASTER", "A001", null, false));
	codes.add( CodeUtil.getCompCodeList("MASTER", "A001"));
	codes.add( CodeUtil.getCompCodeList("MASTER", "A001", true));
	
	
	request.setAttribute("codes", codes);
%>
    
   
    <c:forEach var="code" items="${codes }">
     <hr/>
    <c:forEach var="item" items="${code }">
    	${item.codeNo } / ${item.codeName } /  ${item.inUse } / ${item.option } <br/>
    </c:forEach>
    </c:forEach>
</body>
</html>
