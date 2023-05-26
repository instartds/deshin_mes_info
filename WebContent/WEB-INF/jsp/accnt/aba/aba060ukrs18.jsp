<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'지출결의',
		itemId: 'tab_pay2',
		id:'tab_pay2',
		border: false,
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'uniDetailForm',	
			itemId: 'tab_pay2Form',
			disabled:false,
			autoScroll: false,
			layout: {type: 'uniTable', columns: 2},
			items:[{
				fieldLabel: '결제방법',
				id:'PAY_DIVI18',
				name: 'PAY_DIVI',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A172'
			},{
				fieldLabel: '지출유형',
				id:'PAY_TYPE18',
				name: 'PAY_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A177'
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
			itemId:'aba060ukrs18Grid',
		    store : aba060ukrs18Store,
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
			columns: [{dataIndex: 'PAY_DIVI'			,		width: 133},	
					  {dataIndex: 'PAY_TYPE'			,		width: 133},	
				      {dataIndex: 'MAKE_SALE'			,		width: 133},	
					  {dataIndex: 'DR_CR'  				,		width: 100},	
					  {dataIndex: 'AMT_DIVI'			,		width: 113},
					  {dataIndex: 'ACCNT'  				,		width: 120 
					  	,'editor' : Unilite.popup('ACCNT_G',{	
					  			DBtextFieldName: 'ACCNT_CODE',
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_pay2').down('#aba060ukrs18Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_pay2').down('#aba060ukrs18Grid').getSelectedRecord();
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
		 									grdRecord = Ext.getCmp('tab_pay2').down('#aba060ukrs18Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_pay2').down('#aba060ukrs18Grid').getSelectedRecord();
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
					  }	,
					  {dataIndex: 'REMARK'			,		width: 150},
			],
			listeners: {
	        		beforeedit: function( editor, e, eOpts ) {
			        	if(e.record.phantom == false) {
			        		if(UniUtils.indexOf(e.field, ['PAY_DIVI', 'PAY_TYPE', 'MAKE_SALE', 'DR_CR', 'AMT_DIVI', 'ACCNT' ,'ACCNT_NAME' ])) {
								return false;
							}
			        	}
			        	
	        		}
		        } 							
		}]
	}