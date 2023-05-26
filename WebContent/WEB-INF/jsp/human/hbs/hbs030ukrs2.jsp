<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.compreincometaxupdate" default="종합소득세율등록"/>',
		id:'hbs030ukrGrid2',
		itemId: 'hbs030ukrPanel2',
		border: false,
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{				
			xtype: 'uniDetailForm',
			id:'hbs030ukrPanel2Form',
			itemId:'hbs030ukrPanel2Form',
			disabled:false,
			layout: {type: 'uniTable'},
			items:[{
				fieldLabel: '<t:message code="system.label.human.taxyear" default="세액년도"/>',
				xtype: 'uniYearField',
			    id : 'TAX_YEAR1',
			    name: 'TAX_YEAR1',
				allowBlank: false
			}]},{
			xtype: 'uniGridPanel',
			itemId: 'uniGridPanel2',
		    store : hbs030ukrs2Store,
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
				{dataIndex: 'TAX_STD_LO_I'				,width: 300},
				{dataIndex: 'TAX_STD_HI_I'				,width: 300},
				{dataIndex: 'TAX_RATE'					,width: 300},
				{dataIndex: 'ACCUM_SUB_I'				,flex: 1},
				{dataIndex: 'TAX_YEAR'					,width: 20,  hidden:true}

			],
			listeners: {
	    		beforeedit: function( editor, e, eOpts ) {
		        	if(!e.record.phantom == true) {
		        		if(UniUtils.indexOf(e.field, ['TAX_STD_LO_I'])) {
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