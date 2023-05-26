<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'근무조등록',
		id: 'hbs020ukrTab6',
		itemId: 'hbs020ukrTab6',
		border: false,
		subCode:'H004',
		getSubCode: function()	{
			return this.subCode;
		},
<!-- 		xtype: 'uniDetailForm', -->
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		bodyCls: 'human-panel-form-background',
        padding: '0 0 0 0',
		items:[{				
			xtype: 'uniGridPanel',
			itemId:'uniGridPanel6',
		    store : hbs020ukrs6Store,
		    uniOpt: {
		    	expandLastColumn: false,
		        useRowNumberer: true,
		        useMultipleSorting: false,
		        copiedRow: true
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
				{dataIndex: 'REF_CODE1'			,		width: 120, hidden: true},
				{dataIndex: 'REF_CODE2'			,		width: 86, hidden: true},
				{dataIndex: 'REF_CODE3'			,		width: 86, hidden: true},
				{dataIndex: 'SUB_LENGTH'		,		width: 66, hidden: true},
				{dataIndex: 'USE_YN'			,		minWidth: 86, flex: 1},
				{dataIndex: 'SORT_SEQ'			,		width: 66, hidden: true},
				{dataIndex: 'SYSTEM_CODE_YN'	,		width: 86, hidden: true},
				{dataIndex: 'UPDATE_DB_USER'	,		width: 66, hidden: true},
				{dataIndex: 'UPDATE_DB_TIME'	,		width: 66, hidden: true}
			],
			listeners: {
				beforeedit  : function( editor, e, eOpts ) {
					if(!e.record.phantom){						
						if (UniUtils.indexOf(e.field, ['SUB_CODE'])){
							return false;
						}else{
							return true;
						}	
					}					
				},
				edit: function(editor, e) {
					if(e.field == 'SUB_CODE'){
						if(e.value.length > e.record.get('SUB_LENGTH')){
							Ext.Msg.alert('확인', '길이를 확인해 주세요.');
							e.record.set(e.field, e.originalValue);
						}
					}
				}
			}
		}]
	}