<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="cache-control" content="no-cache" />
<meta http-equiv="pragma" content="no-cache" />
<TITLE>Mime Type Test</TITLE>
</head>
<body>
	Location Information ::<br/>
	<table border="1">
		<c:forTokens var="item" items="hash,host,hostname,href,pathname,port,protocol,search" delims=",">
		<tr>
			<th>${item }</th>
			<td><script type="text/javascript">document.write(window.location.${item });</script></td>
		</tr>
		</c:forTokens>
	</table>
</body>
</html>