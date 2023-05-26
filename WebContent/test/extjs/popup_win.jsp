<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script type="text/javascript">

	function onOk() {
		var rv = {
			status : "OK",
			message : "hahaha",
			result : [{name:"하하하", value:"01"}, {name:"하하하", value:"02"}]
		};
		alert("ok?");
		window.returnValue = rv;
		window.close();
	};
	
	
	Ext.onReady(function() {
			init();
	});
	
	function init() {
		var param = window.dialogArguments;
		console.log("received param: ", param);
	};
</script>
<a href="#" onclick="onOk()">[ Close ]</a>
<table>
	<tr>
		<td colspan="2">
			<h3>Parameter info:</h3>
		</td>
	</tr>

	<c:forEach var="aKey" items="${paramValues}">
		<tr>
			<td><c:out value="${aKey.key}" /></td>
			<td><c:forEach var="val" items="${aKey.value}">
					[<c:out value="${val}" />]<br />
				</c:forEach></td>
		</tr>
	</c:forEach>
	<tr>
		<td colspan="2">
			<h3>Header info:</h3>
		</td>
	</tr>
	<c:forEach var="aKey" items="${headerValues}">
		<tr>
			<td><c:out value="${aKey.key}" /></td>
			<td><c:forEach var="val" items="${aKey.value}">
		     [<c:out value="${val}" />]<br />
				</c:forEach></td>
		</tr>
	</c:forEach>
</table>