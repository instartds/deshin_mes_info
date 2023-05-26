<%@page language="java" contentType="text/html; charset=utf-8"%>
/**
 * 거래처코드 채번룰 정규용
 * 추후 로직 있을시 추가
 * JSP 파일은 유지 시킬것
 *
 */
    <%
        String aaa = request.getParameter("aaa");

    %>

{
	xtype		: 'container',
	layout: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
	defaultType: 'uniFieldset',
	id          : 'autoCustomCodeFieldset',
	masterGrid: masterGrid,
	padding: '0 0 0 0',
	defaults: { padding: '0 0 0 0'},
	//fieldStyle: 'font-size: 0px;letter-spacing: 0px;word-spacing: 0px; vertical-align:top',
	id: 'autoCustomCodeFieldset',
	//hidden:true,
	items: [
	]
},