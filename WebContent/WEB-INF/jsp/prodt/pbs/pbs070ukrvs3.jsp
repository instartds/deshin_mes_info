<%@page language="java" contentType="text/html; charset=utf-8"%>

	var prodt_Calender_Revise =	 {
		itemId: 'prodt_Calender_Revise',
		id:'prodt_Calender_Revise',
		layout: {type: 'vbox', align:'stretch'},
		items:[{	
			title:'카렌더정보수정',
			itemId: 'tab_Cal_Revise',
			id: 'tab_Cal_Revise',
			xtype: 'uniDetailFormSimple',
    		layout: 'fit',
			items:[
				{
					xtype:'uxiframe',
					src: CPATH+"/prodt/pbs070ukrs3_1.do",
					layout	: 'fit'
				}
			]
		}]
	}