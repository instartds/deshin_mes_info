<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'끝전처리기준등록',
		id:'hbs020ukrTab14',
		itemId: 'hbs020ukrPanel14',
		border: false,
		subCode:'',
		getSubCode: function()	{
			return this.subCode;
		},
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		bodyCls: 'human-panel-form-background',
        padding: '0 0 0 0',
		items:[{
			xtype: 'uniDetailFormSimple',
			layout: {type: 'uniTable'},
			items:[{
				fieldLabel: '지급/공제구분',
				name: 'WAGES_TYPE',
				id: 'WAGES_TYPE14',
				itemId: 'tabFocus14',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H038',
				value: '1',
				allowBlank: false
			}]			
		}, {				
			xtype: 'uniGridPanel',
			itemId:'uniGridPanel14',
			id:'uniGridPanel14',
		    store : hbs020ukrs14Store,
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
//					  {dataIndex: 'WAGES_TYPE'		          	,		width: 266, hidden: true},				  
					  {dataIndex: 'WAGES_CODE'		          	,		width: 180},				  
					  {dataIndex: 'STD_AMOUNT_I'	          	,		width: 200},				  
					  {dataIndex: 'BELOW'			          	,		width: 200},				  
					  {dataIndex: 'CALCU_BAS'		          	,		minWidth: 200, flex: 1}
			],
			listeners: {
				beforeedit  : function( editor, e, eOpts ) {
					if(e.field == 'BELOW'){
						return false;					
					}
					if(!e.record.phantom){						
						if (UniUtils.indexOf(e.field, ['WAGES_CODE'])){
							return false;
						}else{
							return true;
						}	
					}					
				}
			}
		}]
	}