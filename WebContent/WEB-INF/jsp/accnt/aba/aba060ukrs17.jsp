<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'외화환산평가',
		itemId: 'tab_exchangeSlip',
		id:'tab_exchangeSlip',
		border: false,
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'uniDetailForm',
			itemId: 'tab_exchangeSlipForm',
			id		: 'formExchangeSlip',
			disabled:false,
			autoScroll: false,
			layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '외화평가구분',
				id: 'GUBUN_17',
				name: 'GUBUN_17',
				xtype: 'uniCombobox',
				comboType: 'A',
				comboCode: 'A242'
			}]
		}, {				
			xtype: 'uniGridPanel',
			itemId:'aba060ukrs17Grid',
		    store : aba060ukrs17Store,
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
			columns: [{dataIndex: 'GUBUN'			,		width: 133},				
					  {dataIndex: 'ACCNT'				,		width: 120
						  ,'editor' : Unilite.popup('ACCNT_G',{	
						  			DBtextFieldName: 'ACCNT_CODE',
						  			autoPopup:true,
			  						listeners: {
	  									'onSelected': {
			 								fn: function(records, type) {
			 									grdRecord = Ext.getCmp('tab_exchangeSlip').down('#aba060ukrs17Grid').getSelectedRecord();
												record = records[0];
												grdRecord.set('ACCNT',  record.ACCNT_CODE);
												grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
			 								grdRecord = Ext.getCmp('tab_exchangeSlip').down('#aba060ukrs17Grid').getSelectedRecord();
											grdRecord.set('ACCNT', '');
											grdRecord.set('ACCNT_NAME', '');
			 							},
										'applyextparam': function(popup){							
											popup.setExtParam({
			    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"
		    								});
										}
			 						}
								})
						  },		
					  {dataIndex: 'ACCNT_NAME'			,		width: 220
					  	,'editor' : Unilite.popup('ACCNT_G',{
					  			autoPopup:true,
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_exchangeSlip').down('#aba060ukrs17Grid').getSelectedRecord();
											record = records[0];
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_exchangeSlip').down('#aba060ukrs17Grid').getSelectedRecord();
										grdRecord.set('ACCNT', '');
										grdRecord.set('ACCNT_NAME', '');
		 							},
									'applyextparam': function(popup){							
										popup.setExtParam({
		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"
	    								});
									}
		 						}
							})
					  },
					  {dataIndex: 'ACCNT_GAIN'				,		width: 120
						  ,'editor' : Unilite.popup('ACCNT_G',{	
						  			DBtextFieldName: 'ACCNT_CODE',
						  			autoPopup:true,
			  						listeners: {
	  									'onSelected': {
			 								fn: function(records, type) {
			 									grdRecord = Ext.getCmp('tab_exchangeSlip').down('#aba060ukrs17Grid').getSelectedRecord();
												record = records[0];
												grdRecord.set('ACCNT_GAIN',  record.ACCNT_CODE);
												grdRecord.set('ACCNT_GAIN_NAME', record.ACCNT_NAME);
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
			 								grdRecord = Ext.getCmp('tab_exchangeSlip').down('#aba060ukrs17Grid').getSelectedRecord();
											grdRecord.set('ACCNT_GAIN', '');
											grdRecord.set('ACCNT_GAIN_NAME', '');
			 							},
										'applyextparam': function(popup){							
											popup.setExtParam({
			    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"
		    								});
										}
			 						}
								})
						  },		
					  {dataIndex: 'ACCNT_GAIN_NAME'			,		width: 220
					  	,'editor' : Unilite.popup('ACCNT_G',{
					  			autoPopup:true,
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_exchangeSlip').down('#aba060ukrs17Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT_GAIN',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_GAIN_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_exchangeSlip').down('#aba060ukrs17Grid').getSelectedRecord();
										grdRecord.set('ACCNT_GAIN', '');
										grdRecord.set('ACCNT_GAIN_NAME', '');
		 							},
									'applyextparam': function(popup){							
										popup.setExtParam({
		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"
	    								});
									}
		 						}
							})
					  },
					  {dataIndex: 'ACCNT_LOSS'				,		width: 120
						  ,'editor' : Unilite.popup('ACCNT_G',{	
						  			DBtextFieldName: 'ACCNT_CODE',
						  			autoPopup:true,
			  						listeners: {
	  									'onSelected': {
			 								fn: function(records, type) {
			 									grdRecord = Ext.getCmp('tab_exchangeSlip').down('#aba060ukrs17Grid').getSelectedRecord();
												record = records[0];
												grdRecord.set('ACCNT_LOSS',  record.ACCNT_CODE);
												grdRecord.set('ACCNT_LOSS_NAME', record.ACCNT_NAME);
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
			 								grdRecord = Ext.getCmp('tab_exchangeSlip').down('#aba060ukrs17Grid').getSelectedRecord();
											grdRecord.set('ACCNT_LOSS', '');
											grdRecord.set('ACCNT_LOSS_NAME', '');
			 							},
										'applyextparam': function(popup){							
											popup.setExtParam({
			    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"
		    								});
										}
			 						}
								})
						  },		
					  {dataIndex: 'ACCNT_LOSS_NAME'			,		width: 220
					  	,'editor' : Unilite.popup('ACCNT_G',{
					  			autoPopup:true,
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_exchangeSlip').down('#aba060ukrs17Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT_LOSS',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_LOSS_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_exchangeSlip').down('#aba060ukrs17Grid').getSelectedRecord();
										grdRecord.set('ACCNT_LOSS', '');
										grdRecord.set('ACCNT_LOSS_NAME', '');
		 							},
									'applyextparam': function(popup){							
										popup.setExtParam({
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
		        		if(UniUtils.indexOf(e.field, ['GUBUN', 'ACCNT', 'ACCNT_NAME'  ])) {
							return false;
						}
		        	}
	        	} 	
        	}
		}]
	}
