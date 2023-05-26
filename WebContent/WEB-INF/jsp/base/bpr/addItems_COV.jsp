<%@page language="java" contentType="text/html; charset=utf-8"%>
    <%
        String aaa = request.getParameter("aaa");

    %>

{
		layout: {type: 'uniTable', columns: 3, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
		defaultType: 'uniFieldset',
		masterGrid: masterGrid,
		defaults: { padding: '10 15 15 10'},
		colspan: 3,
		id: 'addItemsFieldset',
		items: [{
				title	: '추가항목(코브인터내셔날)',
				defaults: {type: 'uniTextfield', labelWidth:105},
				layout	: { type: 'uniTable', columns: 4},
				items	: [{


								}

							]
				}],
		hidden:true
	},

