<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.stdamountiupdate1" default="표준보수월액등록"/>',
		id:'hbs030ukrGrid1',
		itemId: 'hbs030ukrPanel1',
		border: false,
		xtype: 'container',
		/*xtype: 'container',	
		layout: {type: 'vbox', align: 'stretch'},
		bodyCls: 'human-panel-form-background',
        padding: '0 0 0 0',*/
 		layout: {type: 'vbox', align: 'stretch'},
		items:[{		
 			xtype: 'uniDetailForm',
			id:'hbs030ukrPanel1Form',
			itemId:'hbs030ukrPanel1Form',
			disabled:false,
			layout: {type: 'uniTable', columns: 2},
			items:[{
				fieldLabel: '<t:message code="system.label.human.baseyear" default="기준년도"/>',
				xtype: 'uniYearField',
				value: new Date().getFullYear(),
			    id: 'BASE_YEAR',
			    name: 'BASE_YEAR',
				allowBlank: false
			},{
				fieldLabel: '<t:message code="system.label.human.insurtype" default="보험구분"/>',
				name: 'INSUR_TYPE', 
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('hbs030ukrInsuranceCombo'),
				value: '1',
				allowBlank: false,
				id: 'INSUR_TYPE'
			}]
		},{
			xtype: 'uniGridPanel',
			//id:'test',
			itemId: 'uniGridPanel1',
		    store : hbs030ukrs1Store,
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
				{dataIndex: 'STD_STRT_AMOUNT_I'	,width: 200},
				{dataIndex: 'STD_END_AMOUNT_I'	,width: 200},
				{dataIndex: 'INSUR_RATE'		,width: 100},
				{dataIndex: 'INSUR_RATE1'		,width: 100},
				{dataIndex: 'REMARK'			,flex: 1},
				{dataIndex: 'INSUR_SEQ'			,width: 533,  hidden:true},
				{dataIndex: 'INSUR_TYPE'		,width: 533,  hidden:true},
				{dataIndex: 'BASE_YEAR'		    ,width: 100,  hidden:true},
				{dataIndex: 'UPDATE_DB_USER'	,width: 86,   hidden:true},
				{dataIndex: 'UPDATE_DB_TIME'	,width: 86,   hidden:true},
				{dataIndex: 'COMP_CODE'			,width: 86,   hidden:true}
			],
			listeners: {
	    		beforeedit: function( editor, e, eOpts ) {
		        	if(!e.record.phantom == true) {
		        		if(UniUtils.indexOf(e.field, ['STD_STRT_AMOUNT_I'])) {
							return false;
						}
		        	}
		        	if(!e.record.phantom == true || e.record.phantom == true) {
		        		if(UniUtils.indexOf(e.field, ['INSUR_SEQ', 'INSUR_TYPE', 'BASE_YEAR', 'UPDATE_DB_USER', 'UPDATE_DB_TIME', 'COMP_CODE' ])) {
							return false;
						}
		        	}
		        } 	
		    }
		}]
	}