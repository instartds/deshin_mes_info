<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'수금',
		border: false,
		itemId: 'tab_collection',
		id:'tab_collection',
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'uniDetailForm',
			itemId: 'tab_collectionForm',
			disabled:false,
			autoScroll: false,
			layout: {type: 'uniTable', columns: 2},
			items:[{
				fieldLabel: '국내/해외구분',
				id:'EXPORT_YN6',
				name: 'EXPORT_YN',
				xtype: 'uniCombobox',
				comboType: 'A',
				comboCode: 'B043',
				allowBlank: false
			}, {
				fieldLabel: '수금유형',
				id:'SALE_DIVI6',
				name: 'SALE_DIVI',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'S017'
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
			itemId:'aba060ukrs6Grid',
		    store : aba060ukrs6Store,
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
			columns: [{dataIndex: 'EXPORT_YN'		, width: 100},				  
					  {dataIndex: 'COLLECT_TYPE'	, width: 233},				  
					  {dataIndex: 'DR_CR'  			, width: 100},				  
					  {dataIndex: 'ACCNT'  			, width: 120  
					  ,'editor' : Unilite.popup('ACCNT_G',{	
					  			DBtextFieldName: 'ACCNT_CODE',
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_collection').down('#aba060ukrs6Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_collection').down('#aba060ukrs6Grid').getSelectedRecord();
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
					  {dataIndex: 'ACCNT_NAME' 		, width: 220 
					  ,'editor' : Unilite.popup('ACCNT_G',{
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//			    							'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"},
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_collection').down('#aba060ukrs6Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_collection').down('#aba060ukrs6Grid').getSelectedRecord();
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
			        		if(UniUtils.indexOf(e.field, ['EXPORT_YN', 'COLLECT_TYPE', 'DR_CR'])) {
								return false;
							}
			        	}
	        		}
		        } 						
		}]
	}