<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.nontaxamountiupdate" default="비과세근로소득코드등록"/>',
		id:'hbs030ukrGrid5',
		itemId: 'hbs030ukrPanel5',
		border: false,
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		bodyCls: 'human-panel-form-background',
        padding: '0 0 0 0',
		items:[{			
			xtype: 'uniDetailForm',
			id:'hbs030ukrPanel5Form',
			itemId:'hbs030ukrPanel5Form',
			disabled:false,
			layout: {type: 'uniTable'},
			items:[{
				fieldLabel: '<t:message code="system.label.human.taxyear" default="세액년도"/>',
				xtype: 'uniYearField',
				value: new Date().getFullYear(),
			    name: 'TAX_YYYY5',
			    id: 'TAX_YYYY5',
				allowBlank: false
			}]},{
			xtype: 'uniGridPanel',
			itemId: 'uniGridPanel5',
		    store : hbs030ukrs5Store,
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
				{dataIndex: 'TAX_YYYY'				,width: 200, hidden: true},
				{dataIndex: 'NONTAX_CODE'			,width: 100},
				{dataIndex: 'NONTAX_CODE_NAME'		,width: 500},
				{dataIndex: 'TAX_EXEMP_KIND'        ,width: 100},
				{dataIndex: 'TAX_EXEMP_LMT'        ,width: 100},
				{dataIndex: 'SEND_YN'               ,width: 100},
				{dataIndex: 'PRINT_LOCATION'		,width: 100},
				{dataIndex: 'LAW_PROVISION'			,flex: 1},
				{dataIndex: 'INSERT_DB_USER'		,width: 100, hidden: true},
				{dataIndex: 'INSERT_DB_TIME'		,width: 100, hidden: true},
				{dataIndex: 'UPDATE_DB_USER'		,width: 100, hidden: true},
				{dataIndex: 'UPDATE_DB_TIME'		,width: 100, hidden: true}

			],
			listeners: {
	    		beforeedit: function( editor, e, eOpts ) {
		        	if(!e.record.phantom == true) {
		        		if(UniUtils.indexOf(e.field, ['NONTAX_CODE'])) {
							return false;
						}
		        	}
		        	if(!e.record.phantom == true || e.record.phantom == true) {
		        		if(UniUtils.indexOf(e.field, ['COMP_CODE', 'TAX_YYYY', 'INSERT_DB_USER', 'INSERT_DB_TIME', 'UPDATE_DB_USER', 'UPDATE_DB_TIME' ])) {
							return false;
						}
		        	}
		        } 	
		    }
		}]
	}