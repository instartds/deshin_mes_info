<%@page language="java" contentType="text/html; charset=utf-8"%>
/**
 * 품목코드 채번룰 정규용
 * 추후 로직 있을시 추가
 * JSP 파일은 유지 시킬것
 * 
 */ 
    <%
        String aaa = request.getParameter("aaa");
 
    %>
 
var autoFieldset = {
	layout: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
	defaultType: 'uniFieldset',
	masterGrid: masterGrid,
	defaults: { padding: '10 15 15 10'},
	colspan: 3,
	id: 'autoCodeFieldset',
//			hidden:true,
	items: [
	]
}

