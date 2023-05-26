<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import='foren.framework.utils.*' %>
<c:set var='maximumScale' value='5' />
<c:set var='minimumScale' value='0.25' />
<%
	String[] widths = {"device-width", "480", "598", "640","980"};
	pageContext.setAttribute("widths", widths);   
	pageContext.setAttribute("defaultWidth", ObjUtils.nvl(request.getParameter("defaultWidth"),"device-width"));  	
	
	String[] initScales = {"0.5", "1","2"};
	pageContext.setAttribute("initScales", initScales);
	pageContext.setAttribute("initialScale", ObjUtils.nvl(request.getParameter("initialScale"),"1"));  
	pageContext.setAttribute("userScalable", ObjUtils.nvl(request.getParameter("userScalable"),"no"));  
%>
<!DOCTYPE html>
<html>
<head>

<meta name="viewport" content="user-scalable=${userScalable }, height=device-height, width=${defaultWidth }, initial-scale=${initialScale }, maximum-scale=${maximumScale }, minimum-scale=${minimumScale }" /> 
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="mobile-web-app-capable" content="yes" />
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="cache-control" content="no-cache" />
<meta http-equiv="pragma" content="no-cache" />

<title>OMEGA Plus Mobile Test</title>
<script type="text/javascript" src="<c:url value='/resources/js/jquery/jquery-1.10.2.js' />" ></script>

<script type="text/javascript" charset="UTF-8" src='mobile.js'></script>
<script type="text/javascript">
$(function() {
	 $(".auto_submit_item").change(function() {
		   $(this).parents("form").submit();
	   });
	 });
</script>

<style>
	body{
		margin:0;
		padding:0;
        font: normal 11px '굴림',Gulim,Helvetica, tahoma, arial, verdana, sans-serif;
	}
    .mbox {
        width:${defaultWidth}px;
        border: 1px solid #f00;
        font: normal 11px '굴림',Gulim,Helvetica, tahoma, arial, verdana, sans-serif;
    }
    .configuration td, .configuration th {
        font: normal 15px '굴림',Gulim,Helvetica, tahoma, arial, verdana, sans-serif;
    }
</style>
</head>
<body >
<form name="defForm">
<table class='configuration'>
	<tr>
		<th>사용자 Zoom 허용</th>
		<td><label><input type='radio' name='userScalable' class='auto_submit_item' value='yes' ${(userScalable == 'yes') ? 'checked="checked"' :'' }> YES</label>
			<label><input type='radio' name='userScalable' class='auto_submit_item' value='no' ${(userScalable == 'no') ? 'checked="checked"' :'' }> NO</label> </td>
	</tr>
	<tr>
		<th><label for='defaultWidth'>기본폭 </label></th>
		<td><select name='defaultWidth'  class='auto_submit_item'>
				<c:forEach var="item" items="${widths }">
					<option value="${item }" ${(defaultWidth == item)? 'selected':'' }>${item }</option>
				</c:forEach>
		</select></td>
	</tr>
	<tr>
		<th><label for='initialScale'>기본줌 </label></th>
		<td><select name='initialScale'  class='auto_submit_item'>
				<c:forEach var="item" items="${initScales }">
					<option value="${item }" ${(initialScale == item)? 'selected':'' }>${item }</option>
				</c:forEach>
		</select></td>
	</tr>
</table>	
</form>

<div class='mbox'>
	<ul>
		<li> default width : ${defaultWidth } </li>
		<li> initial-scale : ${initialScale } </li>
		<li> 한글 크기 확인용(normal 11px '굴림') </li>
		<li> Screen width x height : <script>
		var viewSize = fnGetWidthHeight();
		document.write(window.screen.width + ' x ' + window.screen.height);
		</script></li>
		<li> Viewport width x height : <script>document.write(viewSize.width + ' x ' + viewSize.height)</script></li>
		<li><script type="text/javascript" >
		if (window.mobilecheck()) {
			out('You are using mobile mode');
			out('orientation : ' + getOrientation());
		} else {
			out('You are using desktop mode');
		}</script></li>
		<li><script type="text/javascript" >
		out( 'UserAgent: '+navigator.userAgent);
		</script></li>
		<li> <a href='${pageContext.request.requestURL }' >[RESET]</a> </li>
		<li></li>
		<li><script type="text/javascript" >
		out( 'Scale: '+getScale());
		</script></li>
		<li> <a href='http://www.quirksmode.org/mobile/metaviewport/' target='_blank'>Info</a> </li>
	</ul>
	
	<hr/>
	
</div>
<img src='prg01.png' border='0'/>
</body>
</html>