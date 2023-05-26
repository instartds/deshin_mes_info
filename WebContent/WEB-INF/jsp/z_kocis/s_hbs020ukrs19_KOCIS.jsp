<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'서류내역등록',
		id:'hbs020ukrTab19',
		itemId: 'hbs020ukrPanel19',
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
				fieldLabel: '서류구분',
				name: '',
				id: 'DOC_TYPE19', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H058',
				allowBlank: false,
				itemId: 'tabFocus19',
				value: '1'
			}]			
		}, {				
			xtype: 'uniGridPanel',
			itemId:'uniGridPanel19',
		    store : hbs020ukrs19Store,
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
					  {dataIndex: 'DOC_TYPE'	      ,		width: 66, hidden: true},				  
					  {dataIndex: 'DOC_ID'			  ,		width: 194},				  
					  {dataIndex: 'DOC_NAME'		  ,		minWidth: 533, flex: 1}
			],
			listeners: {
				beforeedit  : function( editor, e, eOpts ) {					
					if(!e.record.phantom){						
						if (UniUtils.indexOf(e.field, ['DOC_ID'])){
							return false;
						}else{
							return true;
						}	
					}					
				}
			}
		}]
	}