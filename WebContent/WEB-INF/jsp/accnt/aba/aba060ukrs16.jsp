<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'미착',
		itemId: 'tab_ship',
		id:'tab_ship',
		border: false,
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'uniDetailForm',	
			itemId: 'tab_shipForm',
			disabled:false,
			autoScroll: false,
			layout: {type: 'uniTable', columns: 2},
			items:[{
				fieldLabel: '운임지불방법',
				id:'PAY_METHD16',
				name: 'PAY_METHD',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'T025'
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
			itemId:'aba060ukrs16Grid',
		    store : aba060ukrs16Store,
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
			columns: [{dataIndex: 'PAY_METHD'			,		width: 133},	
					  {dataIndex: 'DR_CR'  				,		width: 100},	
					  {dataIndex: 'ITEM_ACCNT'			,		width: 113,
					  listeners:{
					  		afterrender: function(field) {
								var tGrid = field.getView().ownerGrid;
			        			field.editor.on('beforequery',function(queryPlan, eOpts)	{
			        				
			        				var grid = tGrid;
			        				var record = grid.uniOpt.currentRecord;
			        				
			        				var store = queryPlan.combo.getStore();
			        				
			        			
			        				
			        				/*if(store.get('ITEM_ACCNT') == "Z0"){	        					        			
			        					store.insert(99, {"value":"Z0", "option":null, "text":"부가세"});
			        				}
			        				//}
*/			        			});

					     	}
					  	
					  	
			        		/*render:function(elm)	{
			        			var tGrid = elm.getView().ownerGrid;
			        			elm.editor.on('beforequery',function(queryPlan, eOpts)	{
			        				
			        				var grid = tGrid;
			        				var record = grid.uniOpt.currentRecord;
			        				
			        				var store = queryPlan.combo.getStore();
			        				
			        				
			        				//if(Ext.isEmpty(record.get('ITEM_ACCNT') == "Z0")){
			        					store.insert(99, {"value":"Z0", "option":null, "text":"부가세"});
			        				//}
			        			});
			        		}*/
			        	}
					  },
					  {dataIndex: 'ACCNT'  				,		width: 120 
					  	,'editor' : Unilite.popup('ACCNT_G',{	
					  			DBtextFieldName: 'ACCNT_CODE',
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_ship').down('#aba060ukrs16Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_ship').down('#aba060ukrs16Grid').getSelectedRecord();
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
					  {dataIndex: 'ACCNT_NAME' 			,		width: 220 
					  ,'editor' : Unilite.popup('ACCNT_G',{
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//			    							'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"},
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_ship').down('#aba060ukrs16Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_ship').down('#aba060ukrs16Grid').getSelectedRecord();
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
			        		if(UniUtils.indexOf(e.field, ['PAY_METHD', 'DR_CR', 'ITEM_ACCNT'])) {
								return false;
							}
			        	}
			        	
	        		}
		        } 							
		}]
	}