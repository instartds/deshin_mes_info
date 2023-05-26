<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'조회데이타포맷설정',
		xtype: 'uniDetailForm',
		itemId: 'tab_format',
		api: {
                load : 'aba060ukrsService.selectForm',
                submit: 'aba060ukrsService.syncForm'	
            },
		layout: {tyep: 'hbox', align: 'stretch'},
		items:[{
			border: false,
			xtype: 'panel',
			layout: {tyep: 'hbox', align: 'stretch'},
			items:[{
				title: '조회용 데이타포맷',
				name: '',
				xtype: 'fieldset',
				layout: {tyep: 'hbox', align: 'stretch'},
				items:[{					
					fieldLabel: '[수량]',
					name: 'FORMAT_QTY',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('aba060ukrvCombo'),
					allowBlank: false
				}, {					
					fieldLabel: '[단가]',
					name: 'FORMAT_PRICE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('aba060ukrvCombo'),
					allowBlank: false		
				}, {					
					fieldLabel: '[자국화폐금액]',
					name: 'FORMAT_IN',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('aba060ukrvCombo'),
					allowBlank: false	
				}, {					
					fieldLabel: '[외화화폐금액]',
					name: 'FORMAT_OUT',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('aba060ukrvCombo'),
					allowBlank: false	
				}, {					
					fieldLabel: '[환율]',
					name: 'FORMAT_RATE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('aba060ukrvCombo'),
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
					UniAppManager.setToolbarButtons('newData', false);
				}
			}
	}