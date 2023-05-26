<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.excepttypebaseupdate" default="입/퇴사자 지급기준등록"/>',
		id:'hbs020ukrTab10',
		itemId: 'hbs020ukrPanel10',
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
			xtype: 'container',
			ItemId: 'container10',
			layout: {type: 'uniTable'},
			items:[{
				fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
				name: 'PAY_CODE',
				id:'PAY_CODE',
				itemId: 'tabFocus10',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H028',
				value: '0',
				allowBlank: false
			},{
				fieldLabel: '<t:message code="system.label.human.payprovnum" default="급여지급차수"/>',
				name: 'PAY_PROV_FLAG',
				id:'PAY_PROV_FLAG',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H031'
			},{
				fieldLabel: '<t:message code="system.label.human.excepttype" default="입퇴사구분"/>',
				name: 'EXCEPT_TYPE',
				id:'EXCEPT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H048'
			}]			
		}, {				
			xtype: 'uniGridPanel',
			itemId:'uniGridPanel10',
		    store : hbs020ukrs10Store,
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
			columns: [{dataIndex: 'PAY_CODE'		       ,		width: 140},				  
					  {dataIndex: 'PAY_PROV_FLAG'	       ,		width: 140},				  
					  {dataIndex: 'EXCEPT_TYPE'	           ,		width: 140},				  
					  {dataIndex: 'WAGES_CODE'		       ,		width: 160},				  
					  {dataIndex: 'WORK_DAY'		       ,		width: 100},				  
					  {dataIndex: 'PROV_YN'		           ,		width: 100},				  
					  {dataIndex: 'DAILY_YN'		       ,		minWidth: 100, flex: 1},
					  {dataIndex: 'FIXED_WAGES_DAILY_YN'   ,		width: 100, hidden: true}
					  //{dataIndex: 'DAILY_YN'		       ,		width: 100},
					  //{dataIndex: 'FIXED_WAGES_DAILY_YN'   ,		minWidth: 100, flex: 1}
			],
			listeners: {
				beforeedit  : function( editor, e, eOpts ) {
					if(!e.record.phantom){						
						if (UniUtils.indexOf(e.field, ['PAY_CODE','PAY_PROV_FLAG', 'EXCEPT_TYPE', 'WAGES_CODE'])){
							return false;
						}else{
							return true;
						}	
					}					
				}
			}
		}]
	}