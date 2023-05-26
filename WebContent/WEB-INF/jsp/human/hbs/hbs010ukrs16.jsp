<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.localtaxgovupdate" default="지방소득세신고관할관청"/>',
		id:'hbs010ukrGrid16',
		border: true,
		subCode:'H137',
		getSubCode: function()	{
			return this.subCode;
		},		
		layout:'fit',
//		layout: {type: 'vbox', align: 'stretch'},
		bodyCls: 'human-panel-form-background',
        padding: '0 0 0 0',
		xtype: 'uniGridPanel',
		itemId:'uniGridPanel16',
	    store : hbs010ukrs16Store,
	    uniOpt: {
			useMultipleSorting	: true,			 	
	    	useLiveSearch		: false,			
	    	onLoadSelectFirst	: true,		//체크박스모델은 false로 변경		
	    	dblClickToEdit		: true,			
	    	useGroupSummary		: false,			
			useContextMenu		: false,			
			useRowNumberer		: true,			
			expandLastColumn	: false,				
			useRowContext		: false,	// rink 항목이 있을경우만 true		
	    	filter: {					
				useFilter	: false,			
				autoCreate	: false		
	    	}
		},		        
		columns: [
//			{dataIndex: 'MAIN_CODE'				,		width: 0, hidden: true},
			{dataIndex: 'SUB_CODE'				,		width: 100},
			{dataIndex: 'CODE_NAME'				,		width: 300},
//			{dataIndex: 'SYSTEM_CODE_YN'		,		width: 100, hidden: true},
//			{dataIndex: 'CODE_NAME_EN'			,		width: 533, hidden: true},
//			{dataIndex: 'CODE_NAME_CN'			,		width: 533, hidden: true},
//			{dataIndex: 'CODE_NAME_JP'			,		width: 533, hidden: true},
//			{dataIndex: 'REF_CODE1'				,		width: 86, hidden: true},
//			{dataIndex: 'REF_CODE2'				,		width: 86, hidden: true},
//			{dataIndex: 'REF_CODE3'				,		width: 86, hidden: true},
//			{dataIndex: 'REF_CODE4'				,		width: 86, hidden: true},
//			{dataIndex: 'REF_CODE5'				,		width: 86, hidden: true},
//			{dataIndex: 'SUB_LENGTH'			,		width: 66, hidden: true},
			{dataIndex: 'USE_YN'				,		width: 200	, align: 'center'}//,
//			{dataIndex: 'SORT_SEQ'				,		width: 66, hidden: true},				
//			{dataIndex: 'UPDATE_DB_USER'		,		width: 66, hidden: true},
//			{dataIndex: 'UPDATE_DB_TIME'		,		width: 66, hidden: true},
//			{dataIndex: 'COMP_CODE'				,		width: 66, hidden: true}
		]
	}