<%@page language="java" contentType="text/html; charset=utf-8"%>

<c:import url="_test_header.jsp"></c:import>
<body>
<script>

	var msg = "<g:out value='${param.message}' escapeJS='true'/>'";
</script>
<hr/>
[ <tl:message code="tlab.validator.errors.required"  arguments="a;b;c"/> ]<br/>
 [ <tl:message code="tlab.validator.errors.required"  /> ]  <br/>
</body>
</html>