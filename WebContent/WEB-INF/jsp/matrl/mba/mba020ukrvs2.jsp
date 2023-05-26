<%@page language="java" contentType="text/html; charset=utf-8"%>

	var format_Setup = {
		layout: {type: 'vbox', align:'stretch'},
		items:[{
			title:'조회데이터포맷설정',
			itemId: 'tab_format',
			xtype: 'uniDetailForm',
			disabled:false,
			api: {
	        	load : 'mba020ukrvService.selectForm2',
	            submit: 'mba020ukrvService.syncForm2'	
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
			title: '<t:message code="system.label.purchase.inquirydataformatsetting" default="조회데이터포맷설정"/>',
			layout: {type: 'uniTable', columns: 1},
			items:[{					
					fieldLabel: '<t:message code="system.label.purchase.qty" default="수량"/>',
					name: 'FORMAT_QTY',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('mba020ukrvCombo'),
					allowBlank: false
				}, {					
					fieldLabel: '<t:message code="system.label.purchase.price" default="단가"/>',
					name: 'FORMAT_PRICE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('mba020ukrvCombo'),
					allowBlank: false			
				}, {					
					fieldLabel: '자국화폐금액',
					name: 'FORMAT_IN', 
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('mba020ukrvCombo'),
					allowBlank: false			
				}, {					
					fieldLabel: '외화화폐금액',
					name: 'FORMAT_OUT',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('mba020ukrvCombo'),
					allowBlank: false			
				}, {					
					fieldLabel: '<t:message code="system.label.purchase.exchangerate" default="환율"/>',
					name: 'FORMAT_RATE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('mba020ukrvCombo'),
					allowBlank: false			
				}]
	}]
		}],
		listeners: {
	           	afterrender: function(form) {
	           		form.getForm().load();
	           	},
				dirtychange:function( basicForm, dirty, eOpts ) {
					UniAppManager.setToolbarButtons('save', true);
				}
			}
	}]
}
	