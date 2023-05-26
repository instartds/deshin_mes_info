<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String loginPage = ConfigUtil.getString("common.login.loginPage", "/login/login.do");
	request.setAttribute("loginPage", loginPage);
	request.setAttribute("mainUrl", foren.unilite.com.constants.Unilite.getMainUrl());
%>
<c:choose>
	<c:when test="${empty loginVO }">
		<c:redirect url="${loginPage}"></c:redirect>
	</c:when>
	<c:otherwise>
		<c:redirect url="${mainUrl }"></c:redirect>
	</c:otherwise>
</c:choose>