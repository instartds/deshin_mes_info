<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="foren.framework.utils.*"%>
<%@ page import="foren.unilite.com.constants.*"%>
<%@ page import="javax.servlet.http.*"%>

<!DOCTYPE html >
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
</head>
<body>
</body>
<script type="text/javascript">
	alert('로그아웃 되었습니다.');
	//window.close();
	//self.close();
	//window.opener = window.location.href;
	//self.close();
	//window.open("","_self").close();
	//window.open("about:blank","_self").close();

	//open(location, '_self').close();

	//window.open('', '_self', '');
	//window.close();

	//window.open(location, '_self', '');
	//window.open("about:blank","_self").close();
    //window.close();

    logout();

function logout() {
	console.log("window.length :: " + window.length);
    window.open('about:blank', '_self', '');
    window.close();
    return false;
}
</script>


</html>
