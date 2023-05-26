<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'외화환산자동기표방법등록',
		itemId: 'tab_ForeignCurrency_Transit',
		id:'tab_ForeignCurrency_Transit',
		border: false,
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{				
			xtype	: 'uniGridPanel',
			itemId	: 'aba060ukrs12Grid',
		    store	: aba060ukrs12Store,
		    uniOpt	: {
				copiedRow           : true,
				useMultipleSorting	: true,			 
		    	useLiveSearch		: false,			
		    	onLoadSelectFirst	: true,		
		    	dblClickToEdit		: true,		
		    	useGroupSummary		: false,			
				useContextMenu		: false,		
				useRowNumberer		: true,			
				expandLastColumn	: true,		
				useRowContext		: false,	// rink 항목이 있을경우만 true			
			    	filter: {
					useFilter	: true,		
					autoCreate	: true		
				}
			},        
			columns: [
				{dataIndex: 'ACCNT'		, width: 120,
			  		'editor' : Unilite.popup('FOREIGN_ACCNTT_G',{	
						autoPopup	:true,
						listeners	: {
							'onSelected': {
								fn	: function(records, type) {
									grdRecord = Ext.getCmp('tab_ForeignCurrency_Transit').down('#aba060ukrs12Grid').getSelectedRecord();
									record = records[0];
									grdRecord.set('ACCNT'		, record.ACCNT);
									grdRecord.set('ACCNT_NAME'	, record.ACCNT_NAME);
								},
								scope: this
							},
							'onClear': function(type) {
								grdRecord = Ext.getCmp('tab_ForeignCurrency_Transit').down('#aba060ukrs12Grid').getSelectedRecord();
								grdRecord.set('ACCNT', '');
								grdRecord.set('ACCNT_NAME', '');
							}
						}
					})
				},				  
				{dataIndex: 'ACCNT_NAME'     	, width: 150,
			  		'editor' : Unilite.popup('FOREIGN_ACCNTT_G',{	
						autoPopup	:true,
						listeners	: {
							'onSelected': {
								fn	: function(records, type) {
									grdRecord = Ext.getCmp('tab_ForeignCurrency_Transit').down('#aba060ukrs12Grid').getSelectedRecord();
									record = records[0];
									grdRecord.set('ACCNT'		, record.ACCNT);
									grdRecord.set('ACCNT_NAME'	, record.ACCNT_NAME);
								},
								scope: this
							},
							'onClear': function(type) {
								grdRecord = Ext.getCmp('tab_ForeignCurrency_Transit').down('#aba060ukrs12Grid').getSelectedRecord();
								grdRecord.set('ACCNT', '');
								grdRecord.set('ACCNT_NAME', '');
							}
						}
					})
				},				  
				{dataIndex: 'GUBUN'						, width: 120},
				{dataIndex: 'EXG_ACCNT'		, width: 120,
			  		'editor' : Unilite.popup('EXCHANGE_ACCNT_G',{	
						autoPopup	:true,
						listeners	: {
							'onSelected': {
								fn	: function(records, type) {
										grdRecord = Ext.getCmp('tab_ForeignCurrency_Transit').down('#aba060ukrs12Grid').getSelectedRecord();
									record = records[0];
									grdRecord.set('EXG_ACCNT'	, record.ACCNT);
									grdRecord.set('EXG_NAME'	, record.ACCNT_NAME);
								},
								scope: this
							},
							'onClear': function(type) {
								grdRecord = Ext.getCmp('tab_ForeignCurrency_Transit').down('#aba060ukrs12Grid').getSelectedRecord();
								grdRecord.set('EXG_ACCNT', '');
								grdRecord.set('EXG_NAME', '');
							}
						}
					})
				},				  
				{dataIndex: 'EXG_NAME'		, width: 150,
			  		'editor' : Unilite.popup('EXCHANGE_ACCNT_G',{	
						autoPopup	:true,
						listeners	: {
							'onSelected': {
								fn	: function(records, type) {
										grdRecord = Ext.getCmp('tab_ForeignCurrency_Transit').down('#aba060ukrs12Grid').getSelectedRecord();
									record = records[0];
									grdRecord.set('EXG_ACCNT'	, record.ACCNT);
									grdRecord.set('EXG_NAME'	, record.ACCNT_NAME);
								},
								scope: this
							},
							'onClear': function(type) {
								grdRecord = Ext.getCmp('tab_ForeignCurrency_Transit').down('#aba060ukrs12Grid').getSelectedRecord();
								grdRecord.set('EXG_ACCNT', '');
								grdRecord.set('EXG_NAME', '');
							}
						}
					})
				}
			],
			listeners: {
        		beforeedit: function( editor, e, eOpts ) {
      				if(!e.record.phantom){							//신규 row 외에는 수정 불가
						return false;
					}      		
	      		}
	        } 						
		}]
	}