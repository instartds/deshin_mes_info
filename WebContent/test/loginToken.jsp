<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html >
<html>
<head>
	<script type="text/javascript" src="/resources/js/jquery/jquery-1.10.2.js" ></script>
	<script type="text/javascript">
//http://demo.unilite.co.kr:7002/omegaplus_standard

	function fnCallback(jObj){
		var resJson = JSON.parse(jObj);
		if(resJson.success=="fail")	{
			alert("시스템이 로그인되어 있지 않습니다.");
		}else if(resJson.loginToken) {
        	document.getElementById("demo").innerHTML = "Token : "+resJson.loginToken;
		}else {
			alert("관리자에게 문의하세요.");
		}
	}
	function getToken2(url)	{
		$.ajax({
		     url:url,
		     dataType: 'jsonp', 
		     jsonp: 'callback',
		     jsonpCallback: 'fnCallback'
		});
	}
</script>
</head>
<body>
<button onclick="getToken2('/login/loginToken.do')" type="button"
>Get LoginToken
</button>
<div id="demo"></div>

</body>
</html>