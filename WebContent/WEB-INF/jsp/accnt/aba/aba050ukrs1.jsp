<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title	: '회계담당자',
		itemId	: 'tab_accntPrsn',
		id		: 'tab_accntPrsn',
		xtype	: 'uniDetailForm',
		layout	: {type: 'vbox', align:'stretch'},
		items	: [{
			id		: 'tab_accntPrsnForm',
			xtype	: 'uniDetailForm',
			layout	: {type: 'uniTable', columns: 1},
			disabled: false,
			items:[
				Unilite.popup('ACCNT_PRSN', { 
				fieldLabel		: '회계담당자', 
//				textFieldName	: 'PRSN_NAME',
//				valueFieldName	: 'PRSN_NAME',
//				allowBlank		: false,
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue){	
					},	
					onTextFieldChange: function(field, newValue){	
					},
	    			onTextSpecialKey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	UniAppManager.app.onQueryButtonDown();  
	                	}
	                }
				}
			})]
		},{	
			xtype	: 'uniGridPanel',
			itemId	: 'aba050ukrsGrid',
		    store	: aba050ukrStore,
		    uniOpt	: {			
			    useMultipleSorting	: true,		
			    useLiveSearch		: true,		
			    onLoadSelectFirst	: true,			
			    dblClickToEdit		: true,		
			    useGroupSummary		: true,		
				useContextMenu		: false,	
				useRowNumberer		: true,	
				expandLastColumn	: true,		
				useRowContext		: true,	
				copiedRow			: true,
			    filter: {				
					useFilter		: false,
					autoCreate		: false
				}			
			},		        
			columns: [{dataIndex: 'SUB_CODE'	,	width: 80}, 
					  {dataIndex: 'CODE_NAME'	,	width: 150}, 
					  {dataIndex: 'REF_CODE1'	,	width: 150,
						'editor' : Unilite.popup('USER_G',{
					 	 		DBtextFieldName: 'REF_CODE1',
                                autoPopup: true,
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_accntPrsn').down('#aba050ukrsGrid').getSelectedRecord();
											record = records[0];
											grdRecord.set('REF_CODE1', record.USER_ID);
											grdRecord.set('USER_NAME', record.USER_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_accntPrsn').down('#aba050ukrsGrid').getSelectedRecord();
										grdRecord.set('REF_CODE1', '');
										grdRecord.set('USER_NAME', '');
		 							}/*,
		 							applyextparam: function(popup){	
		 								grdRecord = Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord();
										popup.setExtParam({'ALLOW_TAG'  : grdRecord.data.ALLOW_TAG});
		 							}*/
		 						}
							})
					  }, 
			 		  {dataIndex: 'USER_NAME'	, 	width: 150,
						'editor' : Unilite.popup('USER_G',{
					 	 		DBtextFieldName: 'USER_NAME',
                                autoPopup: true,
		  						listeners: {
  									'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = Ext.getCmp('tab_accntPrsn').down('#aba050ukrsGrid').getSelectedRecord();
											record = records[0];
											grdRecord.set('REF_CODE1', record.USER_ID);
											grdRecord.set('USER_NAME', record.USER_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = Ext.getCmp('tab_accntPrsn').down('#aba050ukrsGrid').getSelectedRecord();
										grdRecord.set('REF_CODE1', '');
										grdRecord.set('USER_NAME', '');
		 							}/*,
		 							applyextparam: function(popup){	
		 								grdRecord = Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord();
										popup.setExtParam({'ALLOW_TAG'  : grdRecord.data.ALLOW_TAG});
		 							}*/
		 						}
							})
					  },
					  {dataIndex: 'REF_CODE2'	,  	width: 120}
				],
				listeners:{
					beforeedit  : function( editor, e, eOpts ) {
						if(UniUtils.indexOf(e.field, ['SUB_CODE'])){
							if(e.record.phantom){
								return true;
							}else{
								return false;
							}
						}
					}	
				}
		}]
	}