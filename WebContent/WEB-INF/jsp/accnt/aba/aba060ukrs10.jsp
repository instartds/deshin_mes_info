<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'감가상각',
		itemId: 'tab_Depreciation',
		id:'tab_Depreciation',
		border: false,
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'uniDetailForm',
			itemId: 'tab_DepreciationForm',
			disabled:false,
			autoScroll: false,
			layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '구분',
				id:'DEPT_DIVI10',
				name: 'DEPT_DIVI',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A037'
			}]
		}, {				
			xtype: 'uniGridPanel',
			itemId:'aba060ukrs10Grid',
		    store : aba060ukrs10Store,
		    uniOpt : {
		    	copiedRow           : true,
				useMultipleSorting	: true,			 
		    	useLiveSearch		: false,			
		    	onLoadSelectFirst	: true,		
		    	dblClickToEdit		: true,		
		    	useGroupSummary		: true,			
				useContextMenu		: false,		
				useRowNumberer		: true,			
				expandLastColumn	: false,		
				useRowContext		: false,	// rink 항목이 있을경우만 true			
			    	filter: {
					useFilter	: true,		
					autoCreate	: true		
				}
			},     
			columns: [{dataIndex: 'DEPT_DIVI'		,width: 80 },				  
					  {dataIndex: 'ACCNT'  			,width: 120 
					  ,'editor' : Unilite.popup('ACCNT_G',{	
					  			DBtextFieldName: 'ACCNT_CODE',
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//		    								'ADD_QUERY': "(SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_Depreciation').down('#aba060ukrs10Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_Depreciation').down('#aba060ukrs10Grid').getSelectedRecord();
										grdRecord.set('ACCNT', '');
										grdRecord.set('ACCNT_NAME', '');
		 							},
									'applyextparam': function(popup){							
										popup.setExtParam({
//											'CHARGE_CODE': getChargeCode[0].SUB_CODE,
		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"
	    								});
									}
		 						}
							})
					  },				  
					  {dataIndex: 'ACCNT_NAME' 		,width: 160
					  ,'editor' : Unilite.popup('ACCNT_G',{	
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//		    								'ADD_QUERY': "(SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_Depreciation').down('#aba060ukrs10Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_Depreciation').down('#aba060ukrs10Grid').getSelectedRecord();
										grdRecord.set('ACCNT', '');
										grdRecord.set('ACCNT_NAME', '');
		 							},
									'applyextparam': function(popup){							
										popup.setExtParam({
//											'CHARGE_CODE': getChargeCode[0].SUB_CODE,
		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"
	    								});
									}
		 						}
							})
					  },
					  {dataIndex: 'DEP_ACCNT'  		,width: 120
					  ,'editor' : Unilite.popup('ACCNT_G',{	
					  			DBtextFieldName: 'ACCNT_CODE',
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_Depreciation').down('#aba060ukrs10Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('DEP_ACCNT',  record.ACCNT_CODE);
											grdRecord.set('DEP_ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_Depreciation').down('#aba060ukrs10Grid').getSelectedRecord();
										grdRecord.set('DEP_ACCNT', '');
										grdRecord.set('DEP_ACCNT_NAME', '');
		 							},
		 							'applyextparam': function(popup){                         
                                        popup.setExtParam({
//                                          'CHARGE_CODE': getChargeCode[0].SUB_CODE,
                                            'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"
                                        });
                                    }
		 						}
							})
					  },
					  {dataIndex: 'DEP_ACCNT_NAME'	,width: 220
					  ,'editor' : Unilite.popup('ACCNT_G',{	
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_Depreciation').down('#aba060ukrs10Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('DEP_ACCNT',  record.ACCNT_CODE);
											grdRecord.set('DEP_ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_Depreciation').down('#aba060ukrs10Grid').getSelectedRecord();
										grdRecord.set('DEP_ACCNT', '');
										grdRecord.set('DEP_ACCNT_NAME', '');
		 							},
		 							'applyextparam': function(popup){                         
                                        popup.setExtParam({
//                                          'CHARGE_CODE': getChargeCode[0].SUB_CODE,
                                            'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"
                                        });
                                    }
		 						}
							})
					  },						  
					  {dataIndex: 'APP_ACCNT'  		,width: 120 
					  ,'editor' : Unilite.popup('ACCNT_G',{	
					  			DBtextFieldName: 'ACCNT_CODE',
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_Depreciation').down('#aba060ukrs10Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('APP_ACCNT',  record.ACCNT_CODE);
											grdRecord.set('APP_ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_Depreciation').down('#aba060ukrs10Grid').getSelectedRecord();
										grdRecord.set('APP_ACCNT', '');
										grdRecord.set('APP_ACCNT_NAME', '');
		 							},
		 							'applyextparam': function(popup){                         
                                        popup.setExtParam({
//                                          'CHARGE_CODE': getChargeCode[0].SUB_CODE,
                                            'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"
                                        });
                                    }
		 						}
							})
					  },						  
					  {dataIndex: 'APP_ACCNT_NAME'	,width: 220
					  ,'editor' : Unilite.popup('ACCNT_G',{	
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_Depreciation').down('#aba060ukrs10Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('APP_ACCNT',  record.ACCNT_CODE);
											grdRecord.set('APP_ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_Depreciation').down('#aba060ukrs10Grid').getSelectedRecord();
										grdRecord.set('APP_ACCNT', '');
										grdRecord.set('APP_ACCNT_NAME', '');
		 							},
		 							'applyextparam': function(popup){                         
                                        popup.setExtParam({
//                                          'CHARGE_CODE': getChargeCode[0].SUB_CODE,
                                            'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"
                                        });
                                    }
		 						}
							})
					   }
					],
			listeners: {
	        		beforeedit: function( editor, e, eOpts ) {
			        	if(e.record.phantom == false) {
			        		if(UniUtils.indexOf(e.field, ['DEPT_DIVI', 'ACCNT', 'ACCNT_NAME'])) {
								return false;
							}
			        	}
	        		}
		        } 							
		}]
	}