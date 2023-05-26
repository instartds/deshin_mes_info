<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'상여구분자등록',
		id:'hbs020ukrTab17',
		itemId: 'hbs020ukrPanel17',
		border: false,
		subCode:'H037',
		getSubCode: function()	{
			return this.subCode;
		},
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		bodyCls: 'human-panel-form-background',
        padding: '0 0 0 0',
		items:[{				
			xtype: 'uniGridPanel',
			itemId:'uniGridPanel17',
		    store : hbs020ukrs17Store,
		    uniOpt: {
		    	expandLastColumn: false,
		        useRowNumberer: true,
		        useMultipleSorting: false
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
//				{dataIndex: 'MAIN_CODE'		        ,		width: 0, hidden: true},
				{dataIndex: 'SUB_CODE'		        ,		width: 100},
				{dataIndex: 'CODE_NAME'		        ,		width: 533},
//				{dataIndex: 'CODE_NAME_EN'	        ,		width: 533, hidden: true},
//				{dataIndex: 'CODE_NAME_CN'	        ,		width: 533, hidden: true},
//				{dataIndex: 'CODE_NAME_JP'	        ,		width: 533, hidden: true},
//				{dataIndex: 'REF_CODE1'		        ,		width: 86, hidden: true},
//				{dataIndex: 'REF_CODE2'		        ,		width: 86, hidden: true},
//				{dataIndex: 'REF_CODE3'		        ,		width: 86, hidden: true},
//				{dataIndex: 'REF_CODE4'		        ,		width: 86, hidden: true},
//				{dataIndex: 'REF_CODE5'		        ,		width: 86, hidden: true},
//				{dataIndex: 'SUB_LENGTH'		    ,		width: 66, hidden: true},
				{dataIndex: 'USE_YN'			    ,		minWidth: 110, flex: 1}
//				{dataIndex: 'SORT_SEQ'		        ,		width: 66, hidden: true},
//				{dataIndex: 'SYSTEM_CODE_YN'	    ,		width: 86, hidden: true},
//				{dataIndex: 'UPDATE_DB_USER'	    ,		width: 66, hidden: true},
//				{dataIndex: 'UPDATE_DB_TIME'	    ,		width: 66, hidden: true}
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
				}
			}						
		}]
	}