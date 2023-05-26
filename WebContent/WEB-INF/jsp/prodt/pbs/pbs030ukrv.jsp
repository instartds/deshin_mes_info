<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'생산휴일등록',
		itemId: 'familyInfo',
		xtype: 'uniDetailForm',
		api: { load: 'pbs070ukrvService.select' },
		layout: {type: 'vbox', align:'stretch'},
		items:[{	
			xtype: 'uniGridPanel',
			
		    store : pbs070ukrvs1Store,
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [{dataIndex: 'HOLY_MONTH'		,	width: 66}, 
					  {dataIndex: 'HOLY_DAY'		,	width: 66}, 
					  {dataIndex: 'REMARK'			,	width: 333}
			]
		}]
	}