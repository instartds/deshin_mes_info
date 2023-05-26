<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'고정자산취득',
		itemId: 'tab_Acquisition_Assets',
		id:'tab_Acquisition_Assets',
		border: false,
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'uniDetailForm',
			itemId: 'tab_Acquisition_AssetsForm',
			disabled:false,
			autoScroll: false,
			layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '결재유형',
				id:'PAY_TYPE9',
				name: 'PAY_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A140'
			}]			
		}, {				
			xtype: 'uniGridPanel',
			itemId:'aba060ukrs9Grid',
		    store : aba060ukrs9Store,	            
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
			columns: [{dataIndex: 'COMP_CODE'	    	,	width: 66, hidden: true },				  
					  {dataIndex: 'PAY_TYPE'			,	width: 133},				  
					  {dataIndex: 'DR_CR'				,	width: 133},				  
					  {dataIndex: 'ACCNT'				,	width: 120 
					  ,'editor' : Unilite.popup('ACCNT_G',{	
					  			DBtextFieldName: 'ACCNT_CODE',
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_Acquisition_Assets').down('#aba060ukrs9Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_Acquisition_Assets').down('#aba060ukrs9Grid').getSelectedRecord();
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
					  {dataIndex: 'ACCNT_NAME'			,	width: 220
					  ,'editor' : Unilite.popup('ACCNT_G',{	
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_Acquisition_Assets').down('#aba060ukrs9Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_Acquisition_Assets').down('#aba060ukrs9Grid').getSelectedRecord();
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
			],
			listeners: {
	        		beforeedit: function( editor, e, eOpts ) {
			        	if(e.record.phantom == false) {
			        		if(UniUtils.indexOf(e.field, ['PAY_TYPE', 'DR_CR', 'ACCNT', 'ACCNT_NAME'])) {
								return false;
							}
			        	}
	        		}
		        } 
		}]
	}