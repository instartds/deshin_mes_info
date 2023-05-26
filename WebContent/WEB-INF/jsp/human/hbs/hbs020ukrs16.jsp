<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
	 	title:'<t:message code="system.label.human.longworkbasisupdate" default="근속수당기준등록"/>',
	 	id:'hbs020ukrTab16',
		itemId: 'hbs020ukrPanel16',
	 	border: false,
		subCode:'',
		getSubCode: function()	{
			return this.subCode;
		},
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},		
		items:[{
				border: false,
				store : hbs020ukrs16Store,
				xtype: 'uniDetailFormSimple',
                id:'hbs020ukrTab16_inner',
				layout: {type: 'uniTable', columns: 2},
				bodyCls: 'human-panel-form-background',
        		padding: '0 0 0 0',
				items:[{
                    xtype: 'uniCombobox',
					fieldLabel: '<t:message code="system.label.human.longtype" default="근속구분"/>',
                    name: 'CNWK_DSNC', 
                    store: Ext.data.StoreManager.lookup('cnwkDsnc'),
                    colspan:2
					
				},{
					 xtype: 'fieldset',
			         title: '<t:message code="system.label.human.periodcalcusrchlm" default="근속기간산입/불산입"/>',
			         layout: {type: 'uniTable', columns: 2},
			         items:[{
			        	name: 'srchImportanceGroup',
			        	id: 'srchImportanceGroup',
			            xtype: 'checkboxgroup',
			            columns: 3,
			            vertical: false,
			            listeners:{
			            	change:{			            		
			            		fn: function(){ 
			            			var check1 = Ext.getCmp('srchImportanceGroup1').getValue();
			            			var check2 = Ext.getCmp('srchImportanceGroup2').getValue();
			            			var check3 = Ext.getCmp('srchImportanceGroup3').getValue();		            			
			            	
			            			var Model = Ext.getCmp('uniGridPanel16').getStore().getRange();			            			
			            						            			
			            			Ext.each(Model, function(record,i){			            				
										record.set('ACCEPT_CAREER_YN',check1);
										record.set('PENALTY_CAREER_YN',check2);
										record.set('BREAK_CAREER_YN',check3);
									});
			            			
			            		}
			            	}
			            },
			            items: [
			            	{boxLabel: '<t:message code="system.label.human.carraddition" default="인정경력산입"/>', name: 'srchImportanceGroup1', id: 'srchImportanceGroup1', inputValue: 'Y', width: 110},
			                {boxLabel: '<t:message code="system.label.human.validitydateaddition" default="징계기간불산입"/>', name: 'srchImportanceGroup2', id: 'srchImportanceGroup2', inputValue: 'Y', padding: '0 0 0 10', width: 120},
			                {boxLabel: '<t:message code="system.label.human.breakcareeryn" default="휴직불산입"/>', name: 'srchImportanceGroup3', id: 'srchImportanceGroup3', inputValue: 'Y', padding: '0 0 0 10', width: 80}
			            ]
			          
			            }]
			        },{
						fieldLabel: '<t:message code="system.label.human.basedatecode" default="산정기준"/>',
						name: 'BASE_DATE_CODE16', 
						id:'BASE_DATE_CODE16',
						xtype: 'uniCombobox',
						comboType: 'AU',
						comboCode: 'H166',
						padding: '15 0 0 150',
						listeners:{
			            	change:{			            		
			            		fn: function(){			            				
			            			var bdc = Ext.getCmp('BASE_DATE_CODE16').getValue();
			            			var Model = Ext.getCmp('uniGridPanel16').getStore().getRange();			            						            			
			            			Ext.each(Model, function(record,i){			            				
										record.set('BASE_DATE_CODE', bdc);										
									});
			            		}
			            	}
			    		}
 					}]
			},{				
				xtype: 'uniGridPanel',
				itemId:'uniGridPanel16',
				id:'uniGridPanel16',
			    store : hbs020ukrs16Store,			     
			    uniOpt: {
			    	expandLastColumn: true,
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
                          {dataIndex: 'CNWK_DSNC'                       ,       width: 133},     
					      {dataIndex: 'STRT_MONTH'			          	,		width: 200},				  
						  {dataIndex: 'LAST_MONTH'			          	,		width: 200},				  
						  {dataIndex: 'SUPP_TOTAL_I'		          	,		width: 120},				  
						  {dataIndex: 'SUPP_RATE'			          	,		width: 133}				  
//						  {dataIndex: 'ACCEPT_CAREER_YN'	          	,		width: 120, hidden: true},				  
//						  {dataIndex: 'PENALTY_CAREER_YN'	          	,		width: 120, hidden: true},				  
//						  {dataIndex: 'BREAK_CAREER_YN'	          		,		width: 120, hidden: true},				  
//						  {dataIndex: 'BASE_DATE_CODE'		          	,		width: 100, hidden: true},				  
//						  {dataIndex: 'UPDATE_DB_USER'		          	,		width: 100, hidden: true},				  
//						  {dataIndex: 'UPDATE_DB_TIME'		          	,		width: 100, hidden: true}
				],
				listeners: {
					beforeedit  : function( editor, e, eOpts ) {						
						if(!e.record.phantom){						
							if (UniUtils.indexOf(e.field, ['STRT_MONTH', 'LAST_MONTH'])){
								return false;
							}else{
								return true;
							}	
						}					
					}
				}
			}]
	 }