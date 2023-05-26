<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<div>
<h5>대용량 첨부파일 2개(815MB)</h5>
<ul>
<c:forEach var="item" items="${fileList}">
<c:url var="dnUrl" value="/ext/extDownload.do"><c:param name="REF_ID" value="${item.REF_ID }"/><c:param name="FID" value="${item.FID }"/> </c:url>
	<li><a href="${dnUrl }" > ${item.ORIGINAL_FILE_NAME } </a> (${item.SIZE })</li>
</c:forEach>
</ul>
</div>
</body>
</html>