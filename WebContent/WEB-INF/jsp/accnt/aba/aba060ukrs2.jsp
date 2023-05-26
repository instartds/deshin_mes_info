<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'매입매출전표',
		itemId: 'tab_inoutSlip',
		id:'tab_inoutSlip',
		border: false,
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'uniDetailForm',
			itemId: 'tab_inoutSlipForm',
			id		: 'formInoutSlip',
			disabled:false,
			autoScroll: false,
			layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '매입매출구분',
				id: 'SALE_DIVI2',
				name: 'SALE_DIVI',
				xtype: 'uniCombobox',
				comboType: 'A',
				comboCode: 'A003',
				allowBlank: false
			}]
		}, {				
			xtype: 'uniGridPanel',
			itemId:'aba060ukrs2Grid',
		    store : aba060ukrs2Store,
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
		   /* uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: true,
			onLoadSelectFirst : true,
    		filter: {
				useFilter: false,
				autoCreate: false
				}
	        },	     */  
			columns: [{dataIndex: 'SALE_DIVI'			,		width: 133},				  
					  {dataIndex: 'BUSI_TYPE'			,		width: 170,
		                listeners:{
		                    render:function(elm)    {
		                        var tGrid = elm.getView().ownerGrid;
		                        elm.editor.on('beforequery',function(queryPlan, eOpts)  {
		                            
		                            var grid = tGrid;
		                            var record = grid.uniOpt.currentRecord;
		                            
		                            var store = queryPlan.combo.store;
		                            store.clearFilter();
		                            store.filterBy(function(item){
		                                return item.get('refCode1') == record.get('SALE_DIVI');
		                            })
		                        
		                            /*var store = queryPlan.combo.getStore();
		                            console.log('propKind',store);
		                            store.gridRoadStoreRecords({
		                                "txtDivi" : record.get('INOUT_DIVI')
		                            }, store);*/
		                        });
		                        elm.editor.on('collapse',function(combo,  eOpts )   {
		                            var store = combo.store;
		                            store.clearFilter();
		                        });
		                    }
		                }
		                
		                
		            },
					  {dataIndex: 'SLIP_DIVI'			,		width: 133},
					  {dataIndex: 'ACCNT'				,		width: 120
						  ,'editor' : Unilite.popup('ACCNT_G',{	
						  			DBtextFieldName: 'ACCNT_CODE',
						  			autoPopup:true,
//						  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//			    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
			  						listeners: {
	  									'onSelected': {
			 								fn: function(records, type) {
			 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
												record = records[0];
												grdRecord.set('ACCNT',  record.ACCNT_CODE);
												grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
			 								grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
											grdRecord.set('ACCNT', '');
											grdRecord.set('ACCNT_NAME', '');
			 							},
										'applyextparam': function(popup){							
											popup.setExtParam({
//												'CHARGE_CODE': getChargeCode[0].SUB_CODE,
			    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"
		    								});
										}
			 						}
								})
						  },		
					  {dataIndex: 'ACCNT_NAME'			,		width: 220
					  	,'editor' : Unilite.popup('ACCNT_G',{
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//			    							'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"},
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
											record = records[0];
//											grdRecord.set('ACCNT',  record.ACCNT_CODE);
//											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
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
					  }
//					  {dataIndex: 'DEPT_CODE' 			,		width: 133	,
//						'editor': Unilite.popup('DEPT_G', {
////		 					DBtextFieldName: 'DEPT_CODE',
//					  		autoPopup:true,
//							listeners: {'onSelected': {
//								fn: function(records, type) {
//	 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//										record = records[0];									
//										grdRecord.set('DEPT_CODE', record['TREE_CODE']);
//										grdRecord.set('DEPT_NAME', record['TREE_NAME']);
//									},
//								scope: this	
//								},
//								'onClear': function(type) {
// 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//									grdRecord.set('DEPT_CODE', '');
//									grdRecord.set('DEPT_NAME', '');
//								},
//								applyextparam: function(popup){
//									
//								}									
//							}
//						})
//					},
//					  {dataIndex: 'DEPT_NAME' 			,		width: 133	,
//						'editor': Unilite.popup('DEPT_G', {
////		 					DBtextFieldName: 'DEPT_CODE',
//					  		autoPopup:true,
//							listeners: {'onSelected': {
//								fn: function(records, type) {
//	 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//										record = records[0];									
//										grdRecord.set('DEPT_CODE', record['TREE_CODE']);
//										grdRecord.set('DEPT_NAME', record['TREE_NAME']);
//									},
//								scope: this	
//								},
//								'onClear': function(type) {
// 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//									grdRecord.set('DEPT_CODE', '');
//									grdRecord.set('DEPT_NAME', '');
//								},
//								applyextparam: function(popup){
//									
//								}									
//							}
//						})
//					},
//					  {dataIndex: 'ITEM_CODE'			,		width: 133,
//						'editor': Unilite.popup('ITEM_G', {		
//		 	 				textFieldName: 'ITEM_CODE',
//		 	 				DBtextFieldName: 'ITEM_CODE',
//					  		autoPopup:true,
//			 				listeners: {
//			 					'onSelected': {
//	 								fn: function(records, type) {				 										
//	 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//										record = records[0];									
//										grdRecord.set('ITEM_CODE', record['ITEM_CODE']);
//										grdRecord.set('ITEM_NAME', record['ITEM_NAME']);
//	 								},
//	 								scope: this
//	 							},
//	 							'onClear': function(type) {
// 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//									grdRecord.set('ITEM_CODE', '');
//									grdRecord.set('ITEM_NAME', '');
//	 							}
//			 				}
//					 })
//					},
//					  {dataIndex: 'ITEM_NAME'			,		width: 133,
//						'editor': Unilite.popup('ITEM_G', {		
//		 	 				textFieldName: 'ITEM_NAME',
//		 	 				DBtextFieldName: 'ITEM_NAME',
//					  		autoPopup:true,
//			 				listeners: {
//			 					'onSelected': {
//	 								fn: function(records, type) {				 										
//	 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//										record = records[0];									
//										grdRecord.set('ITEM_CODE', record['ITEM_CODE']);
//										grdRecord.set('ITEM_NAME', record['ITEM_NAME']);
//	 								},
//	 								scope: this
//	 							},
//	 							'onClear': function(type) {
// 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//									grdRecord.set('ITEM_CODE', '');
//									grdRecord.set('ITEM_NAME', '');
//	 							}
//			 				}
//					 })
//					},
//					  {dataIndex: 'PERSON_NUMB'			,		width: 133,
//				 		editor: Unilite.popup('Employee_G',{
//					  		autoPopup:true,
//							listeners:{ 
//								'onSelected': {
//				                    fn: function(records, type  ){
//	 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//										record = records[0];									
//										grdRecord.set('PERSON_NUMB', record['PERSON_NUMB']);
//										grdRecord.set('NAME', record['NAME']);
//			                    },
//			                    scope: this
//							},
//			                  'onClear' : function(type)	{		                  		
// 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//									grdRecord.set('PERSON_NUMB', '');
//									grdRecord.set('NAME', '');
//								}
//							}
//						})
//					},
//					  {dataIndex: 'NAME'			,		width: 133,
//				 		editor: Unilite.popup('Employee_G',{
//					  		autoPopup:true,
//							listeners:{ 
//								'onSelected': {
//				                    fn: function(records, type  ){
//	 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//										record = records[0];									
//										grdRecord.set('PERSON_NUMB', record['PERSON_NUMB']);
//										grdRecord.set('NAME', record['NAME']);
//			                    },
//			                    scope: this
//							},
//			                  'onClear' : function(type)	{		                  		
// 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//									grdRecord.set('PERSON_NUMB', '');
//									grdRecord.set('NAME', '');
//								}
//							}
//						})
//					},
//					  {dataIndex: 'BANK_CODE'			,		width: 133,
//						editor: Unilite.popup('BANK_G', {
//							autoPopup: true,
//							textFieldName:'BANK_NAME',
//							DBtextFieldName: 'BANK_NAME',
//							listeners:{
//								scope:this,
//								onSelected:function(records, type )	{
// 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//									record = records[0];									
//									grdRecord.set('BANK_CODE', record['BANK_CODE']);
//									grdRecord.set('BANK_NAME', record['BANK_NAME']);
//								},
//								onClear:function(type)	{
// 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//									grdRecord.set('BANK_CODE', '');
//									grdRecord.set('BANK_NAME', '');
//								}
//							}
//						})
//					},
//					  {dataIndex: 'BANK_NAME'			,		width: 133,
//						editor: Unilite.popup('BANK_G', {
//							autoPopup: true,
//							textFieldName:'BANK_NAME',
//							DBtextFieldName: 'BANK_NAME',
//							listeners:{
//								scope:this,
//								onSelected:function(records, type )	{
// 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//									record = records[0];									
//									grdRecord.set('BANK_CODE', record['BANK_CODE']);
//									grdRecord.set('BANK_NAME', record['BANK_NAME']);
//								},
//								onClear:function(type)	{
// 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//									grdRecord.set('BANK_CODE', '');
//									grdRecord.set('BANK_NAME', '');
//								}
//							}
//						})
//					},
//					  {dataIndex: 'SAVE_CODE'			,		width: 133,
//		        		editor: Unilite.popup('BANK_BOOK_G', {
//						  		autoPopup: true,
//					  			textFieldName: 'SAVE_CODE',
//			 	 				DBtextFieldName: 'SAVE_NAME',
//									listeners: {'onSelected': {
//										fn: function(records, type) {
//		 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//											record = records[0];									
//											grdRecord.set('SAVE_CODE', record['BANK_BOOK_CODE']);
//											grdRecord.set('SAVE_NAME', record['BANK_BOOK_NAME']);
//											},
//										scope: this	
//										},
//										'onClear': function(type) {
//		 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//											grdRecord.set('SAVE_CODE', '');
//											grdRecord.set('SAVE_NAME', '');
//										},
//										applyextparam: function(popup){
//											
//										}									
//									}
//						})
//					},
//					  {dataIndex: 'SAVE_NAME'			,		width: 133,
//		        		editor: Unilite.popup('BANK_BOOK_G', {
//						  		autoPopup: true,
//					  			textFieldName: 'SAVE_CODE',
//			 	 				DBtextFieldName: 'SAVE_NAME',
//									listeners: {'onSelected': {
//										fn: function(records, type) {
//		 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//											record = records[0];									
//											grdRecord.set('SAVE_CODE', record['BANK_BOOK_CODE']);
//											grdRecord.set('SAVE_NAME', record['BANK_BOOK_NAME']);
//											},
//										scope: this	
//										},
//										'onClear': function(type) {
//		 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//											grdRecord.set('SAVE_CODE', '');
//											grdRecord.set('SAVE_NAME', '');
//										},
//										applyextparam: function(popup){
//											
//										}									
//									}
//						})
//					},
//					  {dataIndex: 'BIZ_GUBUN'			,		width: 133,
//				 		editor: Unilite.popup('COM_ABA210_G', {
//					  		autoPopup: true,
//		    				DBtextFieldName: 'COM_ABA210_NAME',
//			 				listeners: {
//			 					'onSelected': {
//									fn: function(records, type) {
//	 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//										record = records[0];									
//										grdRecord.set('BIZ_GUBUN', record['COM_ABA210_CODE']);
//										grdRecord.set('BIZ_GUBUN_NAME', record['COM_ABA210_NAME']);
//									},
//										scope: this
//								},
//								'onClear': function(type) {
// 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//									grdRecord.set('BIZ_GUBUN', '');
//									grdRecord.set('BIZ_GUBUN_NAME', '');
//								},
//								applyextparam: function(popup){
//									popup.setExtParam({'SUB_CODE': 'E3'});
//								}
//							}
//						 })
//					},
//					  {dataIndex: 'BIZ_GUBUN_NAME'			,		width: 133,
//				 		editor: Unilite.popup('COM_ABA210_G', {
//					  		autoPopup: true,
//		    				DBtextFieldName: 'COM_ABA210_NAME',
//			 				listeners: {
//			 					'onSelected': {
//									fn: function(records, type) {
//	 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//										record = records[0];									
//										grdRecord.set('BIZ_GUBUN', record['COM_ABA210_CODE']);
//										grdRecord.set('BIZ_GUBUN_NAME', record['COM_ABA210_NAME']);
//									},
//										scope: this
//								},
//								'onClear': function(type) {
// 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//									grdRecord.set('BIZ_GUBUN', '');
//									grdRecord.set('BIZ_GUBUN_NAME', '');
//								},
//								applyextparam: function(popup){
//									popup.setExtParam({'SUB_CODE': 'E3'});
//								}
//							}
//						 })
//					},
//					  {dataIndex: 'PJT_CODE'			,		width: 133,
//				 		editor: Unilite.popup('PJT_TREE_G',{
//				 			autoPopup		: true,
//							listeners		: { 
//								'onSelected': {
//				                    fn: function(records, type  ){
//	 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//										record = records[0];									
//										grdRecord.set('PJT_CODE', record['PJT_CODE']);
//										grdRecord.set('PJT_NAME', record['PJT_NAME']);
//			                    },
//			                    scope: this
//							},
//			                  'onClear' : function(type)	{		                  		
// 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//									grdRecord.set('PJT_CODE', '');
//									grdRecord.set('PJT_NAME', '');
//								}
//							}
//						})
//					},
//					  {dataIndex: 'PJT_NAME'			,		width: 133,
//				 		editor: Unilite.popup('PJT_TREE_G',{
//				 			autoPopup		: true,
//							listeners		: { 
//								'onSelected': {
//				                    fn: function(records, type  ){
//	 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//										record = records[0];									
//										grdRecord.set('PJT_CODE', record['PJT_CODE']);
//										grdRecord.set('PJT_NAME', record['PJT_NAME']);
//			                    },
//			                    scope: this
//							},
//			                  'onClear' : function(type)	{		                  		
// 									grdRecord = Ext.getCmp('tab_inoutSlip').down('#aba060ukrs2Grid').getSelectedRecord();
//									grdRecord.set('PJT_CODE', '');
//									grdRecord.set('PJT_NAME', '');
//								}
//							}
//						})
//					}

		  	],
			listeners: {
        		beforeedit: function( editor, e, eOpts ) {
		        	if(e.record.phantom == false) {
		        		if(UniUtils.indexOf(e.field, ['SALE_DIVI', 'BUSI_TYPE', 'SLIP_DIVI', 'ACCNT', 'ACCNT_NAME'  ])) {
							return false;
						}
		        	}
	        	} 	
        	}
		}]
	}
