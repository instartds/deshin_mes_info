<%@page language="java" contentType="text/html; charset=utf-8"%>
	{
		title:'<t:message code="system.label.human.totdayupload" default="달력정보등록"/>',
		id: 'hbs020ukrTab5',
		itemId: 'hbs020ukrTab5',
		border: false,
		xtype: 'container',
		layout	: 'fit',
		items:[
			{
				xtype:'uxiframe',
				src: CPATH+"/human/hbs020ukr5_1.do",
				layout	: 'fit'
			}
		]
	}