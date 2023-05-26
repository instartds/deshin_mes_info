<%@page language="java" contentType="text/html; charset=utf-8"%>

	var reference_Data = {
		layout: {type: 'vbox', align:'stretch'},
		items:[{
			title:'조회데이터포맷설정',
			itemId: 'tab_format',
			xtype: 'uniDetailForm',
			disabled:false,
			api: {
		        load : 'pbs060ukrvService.selectForm2',
		        submit: 'pbs060ukrvService.syncForm2'	
	    	},
    		layout: {type: 'hbox', align:'stretch'},
    		flex:1,
 			autoScroll:false,
 			items:[{	
	    		xtype: 'uniDetailForm',
				disabled:false,
		        dockedItems: [{
			        xtype: 'toolbar',
			        dock: 'top',
			        padding:'0px',
			        border:0,
			        padding: '0 0 0 0'
			    }],
		        layout: {type: 'vbox', align: 'stretch' ,padding: '0 0 0 0'},
				items:[{
				xtype: 'fieldset',
				title: '조회데이터포맷',
				layout: {type: 'uniTable', columns: 1},
				items:[{					
						fieldLabel: '[수&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;량]',
						name: 'FORMAT_QTY',
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('pbs060ukrvCombo'),
						defaultAlign: 'right',
						allowBlank: false			
					}, {					
						fieldLabel: '[단&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;가]',
						name: 'FORMAT_PRICE',
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('pbs060ukrvCombo'),
						allowBlank: false			
					}, {					
						fieldLabel: '[자국화폐금액]',
						name: 'FORMAT_IN', 
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('pbs060ukrvCombo'),
						allowBlank: false				
					}, {					
						fieldLabel: '[외화화폐금액]',
						name: 'FORMAT_OUT',
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('pbs060ukrvCombo'),
						allowBlank: false				
					}, {					
						fieldLabel: '[환&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;율]',
						name: 'FORMAT_RATE',
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('pbs060ukrvCombo'),
						allowBlank: false			
					}]
				}],
				listeners: {
					dirtychange:function( basicForm, dirty, eOpts ) {
						if(gsButtonFlag) {
							UniAppManager.setToolbarButtons('save', true);
							
						} else {
							UniAppManager.setToolbarButtons('save', false);
						}
					}
				}
			}]
		}]	
	}
	
