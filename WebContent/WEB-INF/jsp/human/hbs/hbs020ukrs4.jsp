<%@page language="java" contentType="text/html; charset=utf-8"%>
	{
		title:'<t:message code="system.label.human.restworktimeupload" default="휴무별근무시간등록"/>',
		id: 'hbs020ukrTab4',
		itemId: 'hbs020ukrTab4',
		border: false,
		subCode:'H003',
		getSubCode: function()	{
			return this.subCode;
		},
		xtype: 'container',
<!-- 		xtype: 'uniDetailForm', -->
		layout: {type: 'vbox', align: 'stretch'},
		bodyCls: 'human-panel-form-background',
        padding: '0 0 0 0',
		items:[{				
			xtype: 'uniGridPanel',
			itemId:'uniGridPanel4',
		    store : hbs020ukrs4Store,
		    uniOpt: {
		    	expandLastColumn: false,
		        useRowNumberer: true,
		        useMultipleSorting: false,
		        copiedRow: false
			},
	    	features: [{
	    		id: 'masterGridSubTotal',
	    		ftype: 'uniGroupingsummary', 
	    		showSummaryRow: false 
	    	},{
	    		id: 'masterGridTotal', 	
	    		ftype: 'uniSummary', 	  
	    		showSummaryRow: false
	    	}],		        
			columns: [
				{dataIndex: 'MAIN_CODE'			,		width: 0, hidden: true},
				{dataIndex: 'SUB_CODE'			,		width: 100},
				{dataIndex: 'CODE_NAME'			,		width: 433},
				{dataIndex: 'CODE_NAME_EN'		,		width: 433, hidden: true},
				{dataIndex: 'CODE_NAME_CN'		,		width: 433, hidden: true},
				{dataIndex: 'CODE_NAME_JP'		,		width: 433, hidden: true},
				{dataIndex: 'REF_CODE1'			,		minWidth: 120, flex: 1},
				{dataIndex: 'REF_CODE2'			,		width: 86, hidden: true},
				{dataIndex: 'REF_CODE3'			,		width: 86, hidden: true},
				{dataIndex: 'SUB_LENGTH'		,		width: 66, hidden: true},
				{dataIndex: 'USE_YN'			,		width: 86, hidden: true},
				{dataIndex: 'SORT_SEQ'			,		width: 66, hidden: true},
				{dataIndex: 'SYSTEM_CODE_YN'	,		width: 86, hidden: true},
				{dataIndex: 'UPDATE_DB_USER'	,		width: 66, hidden: true},
				{dataIndex: 'UPDATE_DB_TIME'	,		width: 66, hidden: true}
			],
			listeners: {
				beforeedit  : function( editor, e, eOpts ) {
									
					if (UniUtils.indexOf(e.field, ['REF_CODE1'])){
						return true;
					}else{
						return false;
					}	
				}				
				
			}						
		}]
	}