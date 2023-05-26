<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.purchase.mrpactionmessage" default="MRP Action Message 적용여부"/>',
		
		border: false,
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{				
			xtype: 'uniGridPanel',
			
		    store : mba010ukrvs6Store,
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [
				{dataIndex: 'COMP_CODE'				,		width: 0 ,hidden: true},
				{dataIndex: 'MAIN_CODE'				,		width: 0 ,hidden: true},
				{dataIndex: 'SUB_CODE'				,		width: 100 },
				{dataIndex: 'CODE_NAME'				,		width: 333 },
				{dataIndex: 'CODE_NAME_EN'			,		width: 333 ,hidden: true},
				{dataIndex: 'CODE_NAME_JP'			,		width: 333 ,hidden: true},
				{dataIndex: 'CODE_NAME_CN'			,		width: 333 ,hidden: true},
				{dataIndex: 'CODE_TYPE'				,		width: 86 },
				{dataIndex: 'REF_CODE1'				,		width: 86 },
				{dataIndex: 'REF_CODE2'				,		width: 86 ,hidden: true},
				{dataIndex: 'REF_CODE3'				,		width: 86 ,hidden: true},
				{dataIndex: 'REF_CODE4'				,		width: 86 ,hidden: true},
				{dataIndex: 'REF_CODE5'				,		width: 86 ,hidden: true},
				{dataIndex: 'SUB_LENGTH'			,		width: 66 ,hidden: true},
				{dataIndex: 'USE_YN'				,		width: 86 ,hidden: true},
				{dataIndex: 'SORT_SEQ'				,		width: 66 ,hidden: true},
				{dataIndex: 'SYSTEM_CODE_YN'		,		width: 86 },
				{dataIndex: 'UPDATE_DB_USER'		,		width: 66 ,hidden: true},
				{dataIndex: 'UPDATE_DB_TIME'		,		width: 66 ,hidden: true}
			]						
		}]
	}