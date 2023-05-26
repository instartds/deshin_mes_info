<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.regwithholdingupdate" default="원천징수신고코드등록"/>',
		id:'hbs030ukrGrid6',
		itemId: 'hbs030ukrPanel6',
		border: false,
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{	
			xtype: 'uniDetailForm',
			id:'hbs030ukrPanel6Form',
			itemId:'hbs030ukrPanel6Form',
			disabled:false,
			layout: {type: 'uniTable'},
			items:[{
				fieldLabel: '<t:message code="system.label.human.applyyymm" default="기준년월"/>',
		        xtype: 'uniMonthfield',
		        allowBlank: false,    
		        readOnly:true,
		        name : 'TAX_YYYYMM',
		        id : 'TAX_YYYYMM'
			}]},{
			xtype: 'uniGridPanel',
			itemId: 'uniGridPanel6',
		    store : hbs030ukrs6Store,
		    uniOpt: {
	    		expandLastColumn: false,
			 	copiedRow: true
	//		 	useContextMenu: true,
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
				{dataIndex: 'COMP_CODE'				,width: 100, hidden: true},
				{dataIndex: 'TAX_YYYYMM'			,width: 100, hidden: true},
				{dataIndex: 'TAX_CODE'				,width: 100},
				{dataIndex: 'TAX_CODE_NAME'			,width: 400},
				{dataIndex: 'SORT_SEQ'				,width: 80},
				
				{dataIndex: 'COL_EDIT4'		,width: 80},
				{dataIndex: 'COL_EDIT5'		,width: 80},
				{dataIndex: 'COL_EDIT6'		,width: 80},
				{dataIndex: 'COL_EDIT7'		,width: 80},
				{dataIndex: 'COL_EDIT8'		,width: 80},
				{dataIndex: 'COL_EDIT9'		,width: 80},
				{dataIndex: 'COL_EDIT10'	,width: 80},
				{dataIndex: 'COL_EDIT11'	,width: 80},
				
				{dataIndex: 'REF_CODE1'				,width: 140, editor:{maxLength:3}},
				{dataIndex: 'REF_CODE2'				,width: 120, editor:{maxLength:3}},
				{dataIndex: 'REF_CODE3'				,width: 80, editor:{maxLength:3}},
				{dataIndex: 'REF_CODE4'             ,width: 120},
				
				{dataIndex: 'INSERT_DB_USER'		,width: 100, hidden: true},
	    		{dataIndex: 'INSERT_DB_TIME'		,width: 100, hidden: true},
	    		{dataIndex: 'UPDATE_DB_USER'		,width: 100, hidden: true},
	    		{dataIndex: 'UPDATE_DB_TIME'		,width: 100, hidden: true}
			],
			listeners: {
	    		beforeedit: function( editor, e, eOpts ) {
		        	if(!e.record.phantom == true) {
		        		if(UniUtils.indexOf(e.field, ['TAX_CODE'])) {
							return false;
						}
		        	}
		        	if(!e.record.phantom == true || e.record.phantom == true) {
		        		if(UniUtils.indexOf(e.field, ['COMP_CODE', 'TAX_YYYYMM', 'INSERT_DB_USER', 'INSERT_DB_TIME', 'UPDATE_DB_USER', 'UPDATE_DB_TIME' ])) {
							return false;
						}
		        	}
		        } 	
		    }
		}]
	}