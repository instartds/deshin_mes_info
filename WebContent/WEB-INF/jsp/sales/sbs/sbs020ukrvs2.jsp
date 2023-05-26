<%@page language="java" contentType="text/html; charset=utf-8"%>
	var reference_Data = {
		layout	: {type: 'vbox', align:'stretch'},
		items	: [{
			title	: '<t:message code="system.label.sales.inquirydataformatsetting" default="조회데이터포맷설정"/>',
			itemId	: 'tab_format',
			xtype	: 'uniDetailForm',
			disabled: false,
			api		: {
				load	: 'sbs020ukrvService.selectForm2',
				submit	: 'sbs020ukrvService.syncForm2'
			},
			layout		: {type: 'hbox', align:'stretch'},
			flex		: 1,
			autoScroll	: false,
			items		: [{
				xtype		: 'uniDetailForm',
				disabled	: false,
				dockedItems	: [{
					xtype	: 'toolbar',
					dock	: 'top',
					padding	: '0px',
					border	: 0,
					padding	: '0 0 0 0'
				}],
				layout		: {type: 'vbox', align: 'stretch' ,padding: '0 0 0 0'},
				items		: [{
					xtype	: 'fieldset',
					title	: '<t:message code="system.label.sales.inquirydataformat" default="조회데이터포맷"/>',
					layout	: {type: 'uniTable', columns: 1},
					items	: [{
						fieldLabel	: '<t:message code="system.label.sales.qty" default="수량"/>',
						name		: 'FORMAT_QTY',
						xtype		: 'uniCombobox',
						store		: Ext.data.StoreManager.lookup('sbs020ukrvCombo'),
						allowBlank	: false
					},{
						fieldLabel	: '<t:message code="system.label.sales.price" default="단가"/>',
						name		: 'FORMAT_PRICE',
						xtype		: 'uniCombobox',
						store		: Ext.data.StoreManager.lookup('sbs020ukrvCombo'),
						allowBlank	: false
					},{
						fieldLabel	: '<t:message code="system.label.sales.countrycurrencyamount" default="자국화폐금액"/>',
						name		: 'FORMAT_IN',
						xtype		: 'uniCombobox',
						store		: Ext.data.StoreManager.lookup('sbs020ukrvCombo'),
						allowBlank	: false
					},{
						fieldLabel	: '<t:message code="system.label.sales.foreigncurrencyamount1" default="외화화폐금액"/>',
						name		: 'FORMAT_OUT',
						xtype		: 'uniCombobox',
						store		: Ext.data.StoreManager.lookup('sbs020ukrvCombo'),
						allowBlank	: false
					},{
						fieldLabel	: '<t:message code="system.label.sales.exchangerate" default="환율"/>',
						name		: 'FORMAT_RATE',
						xtype		: 'uniCombobox',
						store		: Ext.data.StoreManager.lookup('sbs020ukrvCombo'),
						allowBlank	: false
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