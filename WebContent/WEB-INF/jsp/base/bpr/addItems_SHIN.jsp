<%@page language="java" contentType="text/html; charset=utf-8"%>
    <%
        String aaa = request.getParameter("aaa");
 
    %>
 
{
		layout: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
		defaultType	: 'uniFieldset',
		masterGrid: masterGrid,
		defaults: { padding: '10 15 15 10'},
		colspan: 3,
		id: 'addItemsFieldset',
//			hidden:true,
		items: [
		]
	},

