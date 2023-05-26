<%@ tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ attribute name="alert" %>

<c:if test="${!empty bizException}" >
    <c:choose>
        <c:when test="${alert}">
            <script type="text/javascript">
            //alert("<fmt:message key='${bizException.id}' />");
            alert("<fmt:message key='${bizException.id}'> <c:forEach var='arg' items='${bizException.args}'><fmt:param value='${arg}' /></c:forEach></fmt:message>");
            </script>
        </c:when>
        <c:otherwise>
            <fmt:message key="${bizException.id}" />
        </c:otherwise>
    </c:choose>
</c:if>

