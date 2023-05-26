<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.earnincomeiupdate" default="퇴직소득공제등록"/>',
		id:'hbs030ukrGrid3',
		itemId: 'hbs030ukrPanel3',
		border: false,
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{				
			xtype: 'uniDetailForm',
			id:'hbs030ukrPanel3Form',
			itemId:'hbs030ukrPanel3Form',
			disabled:false,
			layout: {type: 'uniTable'},
			items:[{
				fieldLabel: '<t:message code="system.label.human.taxyear" default="세액년도"/>',
				xtype: 'uniYearField',
				value: new Date().getFullYear(),
			    name: 'TAX_YEAR2',
			    id : 'TAX_YEAR2',
				allowBlank: false
			}]},{
			xtype: 'uniGridPanel',
			itemId: 'uniGridPanel3',
		    store : hbs030ukrs3Store,
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
				{dataIndex: 'DUTY_YYYY'				,width: 300},
				{dataIndex: 'INCOME_SUB'			,flex: 1},
				{dataIndex: 'TAX_YEAR'				,width: 100,  hidden:true}

			],
			listeners: {
	    		beforeedit: function( editor, e, eOpts ) {
		        	if(!e.record.phantom == true) {
		        		if(UniUtils.indexOf(e.field, ['DUTY_YYYY'])) {
							return false;
						}
		        	}
		        	if(!e.record.phantom == true || e.record.phantom == true) {
		        		if(UniUtils.indexOf(e.field, ['TAX_YEAR'])) {
							return false;
						}
		        	}
		        } 	
		    }
		}]
	}