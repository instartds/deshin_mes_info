<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.purchase.availableinventorycalculation" default="가용재고 산출기준"/>',
		
		border: false,
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{				
			xtype: 'uniGridPanel',
			
		    store : mba010ukrvs5Store,
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [
				{dataIndex: 'MAIN_CODE'						,		width: 0, hidden:true},
				{dataIndex: 'SUB_CODE'						,		width: 100},
				{dataIndex: 'CODE_NAME'						,		width: 433},
				{dataIndex: 'CODE_NAME_EN'					,		width: 433, hidden:true},
				{dataIndex: 'CODE_NAME_CN'					,		width: 433, hidden:true},
				{dataIndex: 'CODE_NAME_JP'					,		width: 433, hidden:true},
				{dataIndex: 'REF_CODE1'						,		width: 86},
				{dataIndex: 'REF_CODE2'						,		width: 86, hidden:true},
				{dataIndex: 'REF_CODE3'						,		width: 86, hidden:true},
				{dataIndex: 'REF_CODE4'						,		width: 86, hidden:true},
				{dataIndex: 'REF_CODE5'						,		width: 86, hidden:true},
				{dataIndex: 'REF_CODE6'						,		width: 86, hidden:true},
				{dataIndex: 'REF_CODE7'						,		width: 86, hidden:true},
				{dataIndex: 'REF_CODE8'						,		width: 86, hidden:true},
				{dataIndex: 'REF_CODE9'						,		width: 86, hidden:true},
				{dataIndex: 'REF_CODE10'					,		width: 86, hidden:true},
				{dataIndex: 'SUB_LENGTH'					,		width: 86, hidden:true},
				{dataIndex: 'USE_YN'						,		width: 66, hidden:true},
				{dataIndex: 'SORT_SEQ'						,		width: 86, hidden:true},
				{dataIndex: 'SYSTEM_CODE_YN'				,		width: 66},
				{dataIndex: 'UPDATE_DB_USER'				,		width: 86, hidden:true},
				{dataIndex: 'UPDATE_DB_TIME'				,		width: 66, hidden:true},
				{dataIndex: 'COMP_CODE'						,		width: 66, hidden:true}
			]						
		}]
	}