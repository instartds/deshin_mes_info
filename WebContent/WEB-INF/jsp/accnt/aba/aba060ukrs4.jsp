<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'기타소득',
		itemId:'tab_Other_Income',
		id:'tab_Other_Income',
		border: false,
		xtype: 'container',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'uniDetailForm',
			itemId:'tab_Other_IncomeForm',
			disabled:false,
			autoScroll: false,
			layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '소득구분',
				id:'INCOM_TYPE4',
				name: 'INCOM_TYPE',
				xtype: 'uniCombobox',
				comboType: 'A',
				comboCode: 'A118',
				allowBlank: false
				//value: '1'
			}],
			setAllFieldsReadOnly: function(b) {
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
			itemId:'aba060ukrs4Grid',
		    store : aba060ukrs4Store,
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
			columns: [{dataIndex: 'COMP_CODE'			, width: 66, hidden: true},				  
					  {dataIndex: 'INCOM_TYPE'			, width: 100},				  
					  {dataIndex: 'ETC_INCOM_TYPE'		, width: 100},				  
					  {dataIndex: 'DR_CR'  		 		, width: 100},				  
					  {dataIndex: 'PAY_TYPE' 	   		, width: 100},				  
					  {dataIndex: 'ACCNT'          		, width: 120 ,
					  	'editor' : Unilite.popup('ACCNT_G',{
					 	 		DBtextFieldName: 'ACCNT_CODE',
					 	 		autoPopup:true,
//					 	 		extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_Other_Income').down('#aba060ukrs4Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_Other_Income').down('#aba060ukrs4Grid').getSelectedRecord();
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
					  {dataIndex: 'ACCNT_NAME'     		, width: 220 ,
					  	'editor' : Unilite.popup('ACCNT_G',{
					  			autoPopup:true,
//					  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//		    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_Other_Income').down('#aba060ukrs4Grid').getSelectedRecord();
											record = records[0];
											grdRecord.set('ACCNT',  record.ACCNT_CODE);
											grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_Other_Income').down('#aba060ukrs4Grid').getSelectedRecord();
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
					  {dataIndex: 'CUSTOM_CODE'		,width: 66, hidden: true },
					  {dataIndex: 'CUSTOM_NAME'		,width: 220,
						'editor': Unilite.popup('CUST_G',{
							textFieldName	: 'CUSTOM_NAME',
							DBtextFieldName	: 'CUSTOM_NAME',
							autoPopup		: true,
							listeners		: {
								'onSelected': {
									fn: function(records, type  ){
										var grdRecord = Ext.getCmp('tab_Other_Income').down('#aba060ukrs4Grid').getSelectedRecord();
										grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
										grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
									},
									scope: this
								},
								'onClear' : function(type) {
									var grdRecord = Ext.getCmp('tab_Other_Income').down('#aba060ukrs4Grid').getSelectedRecord();
									grdRecord.set('CUSTOM_CODE','');
									grdRecord.set('CUSTOM_NAME','');
								}
							}
						})
					}
				],
				listeners: {
	        		beforeedit: function( editor, e, eOpts ) {
//	        			debugger;
			        	if(e.record.phantom == false) {
			        		if(UniUtils.indexOf(e.field, ['COMP_CODE', 'INCOM_TYPE', 'ETC_INCOM_TYPE', 'DR_CR', 'PAY_TYPE', 'ACCNT' ,'ACCNT_NAME' ])) {
								return false;
							} else if(e.field == "CUSTOM_CODE"){
								if(e.record.get("PAY_TYPE") == '11' || e.record.get("PAY_TYPE") == '12' || e.record.get("PAY_TYPE") == '13') {
									return true;
								} else {
									return false;
								}
							} else {
								return false;
							}
			        	}
			        } 	
		        }
			}]
	}