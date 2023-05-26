<%@page language="java" contentType="text/html; charset=utf-8"%>
<!-- 	 { -->
<!-- 		title:'근태기준등록', -->
<!-- 		id:'hbs020ukrTab3', -->
<!-- 		itemId: 'hbs020ukrTab3', -->
<!-- 		border: false, -->
<!-- 		subCode:'', -->
<!-- 		getSubCode: function()	{ -->
<!-- 			return this.subCode; -->
<!-- 		}, -->
<!-- 		xtype: 'uniDetailForm', -->
<!-- 		layout: {type: 'vbox', align: 'stretch'}, -->
<!-- 		bodyCls: 'human-panel-form-background', -->
<!--         padding: '0 0 0 0', -->
<!-- 		items:[{ -->
<!-- 			xtype: 'container', -->
<!-- 			id : 'container3', -->
<!-- 			layout: {type: 'uniTable'}, -->
<!-- 			items:[{ -->
<!-- 				fieldLabel: '급여지급방식', -->
<!-- 				name: '', -->
<!-- 				id: 'PAY_CODE3', -->
<!-- 				xtype: 'uniCombobox', -->
<!-- 				comboType: 'AU', -->
<!-- 				comboCode: 'H028' -->
<!-- 			},{ -->
<!-- 				fieldLabel: '근태코드', -->
<!-- 				name: '', -->
<!-- 				id: 'DUTY_CODE3', -->
<!-- 				xtype: 'uniCombobox', -->
<!-- 				comboType: 'AU', -->
<!-- 				comboCode: 'H050' -->
<!-- 			}]			 -->
<!-- 		},{				 -->
<!-- 			xtype: 'uniGridPanel', -->
<!-- 			itemId:'uniGridPanel3', -->
<!-- 		    store : hbs020ukrs3Store, -->
<!-- 		    uniOpt: { -->
<!-- 		    	expandLastColumn: false, -->
<!-- 		        useRowNumberer: true, -->
<!-- 		        useMultipleSorting: false -->
<!-- 			},		         -->
<!-- 			columns: [ -->
<!-- 				{dataIndex: 'PAY_CODE'      	,		width: 100}, -->
<!-- 				{dataIndex: 'DUTY_CODE'     	,		width: 100}, -->
<!-- 				{dataIndex: 'DUTY_TYPE'     	,		width: 100, hidden: true},		 -->
<!-- 				{dataIndex: 'COTR_TYPE'     	,		width: 100}, -->
<!-- 				{dataIndex: 'DUTY_STRT_MM'  	,		width: 66, hidden: true}, -->
<!-- 				{dataIndex: 'DUTY_STRT_DD'  	,		width: 66, hidden: true}, -->
<!-- 				{dataIndex: 'DUTY_LAST_MM'  	,		width: 66, hidden: true}, -->
<!-- 				{dataIndex: 'DUTY_LAST_DD'  	,		width: 66, hidden: true}, -->
<!-- 				{dataIndex: 'MARGIR_TYPE'   	,		width: 80}, -->
<!-- 				{dataIndex: 'MONTH_REL_CODE'	,		width: 80}, -->
<!-- 				{dataIndex: 'YEAR_REL_CODE' 	,		width: 80}, -->
<!-- 				{dataIndex: 'MENS_REL_CODE' 	,		width: 80}, -->
<!-- 				{dataIndex: 'WEEK_REL_CODE' 	,		width: 73}, -->
<!-- 				{dataIndex: 'FULL_REL_CODE' 	,		width: 80} -->
<!-- 			]						 -->
<!-- 		}] -->
<!-- 	} -->
		{
			xtype: 'container',
			title:'근태기준등록',
			id:'hbs020ukrTab3',
			itemId: 'hbs020ukrTab3',
			layout: {type: 'vbox', align: 'stretch'},
			items:[{
					border: false,
					subCode:'',
					getSubCode: function()	{
						return this.subCode;
					},
					xtype: 'uniDetailFormSimple',
					layout: {type: 'vbox', align: 'stretch'},
					bodyCls: 'human-panel-form-background',
			        padding: '0 0 0 0',
					items:[{
						xtype: 'container',
						id : 'container3',
						layout: {type: 'uniTable'},
						items:[{
							fieldLabel: '급여지급방식',
							name: 'PAY_CODE',
							id: 'PAY_CODE3',							
							xtype: 'uniCombobox',
							comboType: 'AU',
							comboCode: 'H028'
						},{
							fieldLabel: '근태코드',
							name: 'DUTY_CODE',
							id: 'DUTY_CODE3',
							itemId: 'tabFocus3',
							xtype: 'uniCombobox',
							comboType: 'A',
							comboCode: 'H033'
						}]			
					}]
				},{				
					xtype: 'uniGridPanel',
					itemId:'uniGridPanel3',
				    store : hbs020ukrs3Store,
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
						{dataIndex: 'PAY_CODE'      	,		width: 110},
						{dataIndex: 'DUTY_CODE'     	,		width: 110},
//						{dataIndex: 'DUTY_TYPE'     	,		width: 110, hidden: true},		
						{dataIndex: 'COTR_TYPE'     	,		width: 110},
//						{dataIndex: 'DUTY_STRT_MM'  	,		width: 80, hidden: true},
//						{dataIndex: 'DUTY_STRT_DD'  	,		width: 80, hidden: true},
//						{dataIndex: 'DUTY_LAST_MM'  	,		width: 80, hidden: true},
//						{dataIndex: 'DUTY_LAST_DD'  	,		width: 80, hidden: true},
						{dataIndex: 'MARGIR_TYPE'   	,		width: 100},
						{dataIndex: 'MONTH_REL_CODE'	,		width: 100},
						{dataIndex: 'YEAR_REL_CODE' 	,		width: 100},
						{dataIndex: 'MENS_REL_CODE' 	,		width: 100},
						{dataIndex: 'WEEK_REL_CODE' 	,		width: 90},
						{dataIndex: 'FULL_REL_CODE' 	,		minWidth: 100, flex: 1}
					],
					listeners: {
						beforeedit  : function( editor, e, eOpts ) {
							if(!e.record.phantom){						
								if (UniUtils.indexOf(e.field, ['PAY_CODE','DUTY_CODE'])){
									return false;
								}else{
									return true;
								}	
							}					
						}
					}						
				}
			]
		}
