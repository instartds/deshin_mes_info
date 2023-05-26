<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'무역경비',
		border: false,
		itemId: 'tab_Trading_Cost',
		id:'tab_Trading_Cost',
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'uniDetailForm',
			itemId: 'tab_Trading_CostForm',
			disabled:false,
			autoScroll: false,
			layout: {type: 'uniTable', columns: 2},
			items:[{
				fieldLabel: '수출/수입구분',
				id:'TRADE_DIV8',
				name: 'TRADE_DIV',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'T001',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						TradeDivKindStore.loadStoreRecords();
						
						if(newValue == 'E' ){
							panelDetail.down('#aba060ukrs8Grid').getColumn('CHARGE_TYPE_E').setVisible(true);
				 			panelDetail.down('#aba060ukrs8Grid').getColumn('CHARGE_TYPE_I').setVisible(false);
						}else if(newValue == 'I'){
				 			panelDetail.down('#aba060ukrs8Grid').getColumn('CHARGE_TYPE_E').setVisible(false);
				 			panelDetail.down('#aba060ukrs8Grid').getColumn('CHARGE_TYPE_I').setVisible(true);
				 		}else{
							panelDetail.down('#aba060ukrs8Grid').getColumn('CHARGE_TYPE_E').setVisible(false);
				 			panelDetail.down('#aba060ukrs8Grid').getColumn('CHARGE_TYPE_I').setVisible(false);
				 		}
					}
				}
			}, {
				fieldLabel: '진행구분',
				id:'CHARGE_TYPE8',
				name: 'CHARGE_TYPE',
				xtype: 'uniCombobox',
				store:TradeDivKindStore
			}],
			setAllFieldsReadOnly : function(b) {
						var r= true
						if(b) {
							var invalid = this.getForm().getFields().filterBy(function(field) {
																				return !field.validate();
																			});
		   	
			   				if(invalid.length > 0) {
								r=false;
			   					var labelText = ''
			   	
								if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
			   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
			   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
			   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
			   					}
			
							   	alert(labelText+Msg.sMB083);
							   	invalid.items[0].focus();
							} else {
							//	this.mask();		    
			   				}
				  		} else {
		  					this.unmask();
		  				}
						return r;
		  			}
		}, {				
			xtype: 'uniGridPanel',
			itemId:'aba060ukrs8Grid',
		    store : aba060ukrs8Store,
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
			columns: [{dataIndex: 'TRADE_DIV'				,	width: 66 },
					  {dataIndex: 'CHARGE_TYPE_E'		,	width: 120,hidden:true},	
					  {dataIndex: 'CHARGE_TYPE_I'		,	width: 120,hidden:true},
					  /*{dataIndex: 'CHARGE_TYPE_NAME'		,	width: 100,
					  listeners:{
			        		render:function(elm)	{
			        			var tGrid = elm.getView().ownerGrid;
			        			elm.editor.on('beforequery',function(queryPlan, eOpts)	{
			        				
			        				var grid = tGrid;
			        				var record = grid.uniOpt.currentRecord;
			        				
			        				var store = queryPlan.combo.getStore();
			        				console.log('propKind',store);
			        				store.gridRoadStoreRecords({
			        					"TRADE_DIV" : record.get('TRADE_DIV')
			        				});
			        			});
			        		}
			        	 }
					  },*/
					  {dataIndex: 'CHARGE_CODE'				,	width: 120 
					  ,'editor' : Unilite.popup('EXPENSE_G',{	
					  			DBtextFieldName: 'EXPENSE_CODE',
					  			autoPopup:true,
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_Trading_Cost').down('#aba060ukrs8Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('CHARGE_CODE',  record.EXPENSE_CODE);
											grdRecord.set('CHARGE_NAME', record.EXPENSE_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_Trading_Cost').down('#aba060ukrs8Grid').getSelectedRecord();
										grdRecord.set('CHARGE_CODE', '');
										grdRecord.set('CHARGE_NAME', '');
		 							},
		 							applyextparam: function(popup){	
		 								grdRecord = Ext.getCmp('tab_Trading_Cost').down('#aba060ukrs8Grid').getSelectedRecord();
										popup.setExtParam({'TRADE_DIV'  : grdRecord.data.TRADE_DIV});
										popup.setExtParam({'CHARGE_TYPE': grdRecord.data.CHARGE_TYPE_NAME});
		 							}
		 						}
							})
					  },		
					  {dataIndex: 'CHARGE_NAME'				,	width: 220
					  
					  ,'editor' : Unilite.popup('EXPENSE_G',{	
								autoPopup:true,
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_Trading_Cost').down('#aba060ukrs8Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('CHARGE_CODE',  record.EXPENSE_CODE);
											grdRecord.set('CHARGE_NAME', record.EXPENSE_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_Trading_Cost').down('#aba060ukrs8Grid').getSelectedRecord();
										grdRecord.set('CHARGE_CODE', '');
										grdRecord.set('CHARGE_NAME', '');
		 							},
		 							applyextparam: function(popup){	
		 								grdRecord = Ext.getCmp('tab_Trading_Cost').down('#aba060ukrs8Grid').getSelectedRecord();
										popup.setExtParam({'TRADE_DIV'  : grdRecord.data.TRADE_DIV});
										popup.setExtParam({'CHARGE_TYPE': grdRecord.data.CHARGE_TYPE_NAME});
		 							}
		 						}
							})
					  },		
					  {dataIndex: 'PAY_TYPE'  				,	width: 120},					  
					  {dataIndex: 'COST_DIV'				,	width: 88},					  
					  {dataIndex: 'DR_CR'					,	width: 88},					  
					  {dataIndex: 'ACCNT'  					,	width: 120
					  ,'editor' : Unilite.popup('ACCNT_G',{	
					  			DBtextFieldName: 'ACCNT_CODE',
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_Trading_Cost').down('#aba060ukrs8Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_Trading_Cost').down('#aba060ukrs8Grid').getSelectedRecord();
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
					  {dataIndex: 'ACCNT_NAME' 				,	width: 220
						,'editor' : Unilite.popup('ACCNT_G',{
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//			    							'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"},
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_Trading_Cost').down('#aba060ukrs8Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_Trading_Cost').down('#aba060ukrs8Grid').getSelectedRecord();
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
		        		if(UniUtils.indexOf(e.field, ['TRADE_DIV'])) {
							return false;
						}
		        	}else{
		        		if(UniUtils.indexOf(e.field, ['TRADE_DIV'])) {
							return false;
						}
		        	}
        		}
	        }						
		}]
	}