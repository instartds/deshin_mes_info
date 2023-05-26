<%@page language="java" contentType="text/html; charset=utf-8"%>

	var reference_Data = {
		layout: {type: 'vbox', align:'stretch'},
		items:[{
			title:'조회데이터포맷설정',
			itemId: 'tab_format',
			xtype: 'uniDetailForm',
			disabled:false,
			api: {
	                load : 'biv060ukrvService.selectForm2',
	                submit: 'biv060ukrvService.syncForm2'	
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
					store: Ext.data.StoreManager.lookup('biv060ukrvCombo'),
					defaultAlign: 'right',
					allowBlank: false
				}, {					
					fieldLabel: '[단&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;가]',
					name: 'FORMAT_PRICE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('biv060ukrvCombo'),
					allowBlank: false			
				}, {					
					fieldLabel: '자국화폐금액',
					name: 'FORMAT_IN', 
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('biv060ukrvCombo'),
					allowBlank: false			
				}, {					
					fieldLabel: '외화화폐금액',
					name: 'FORMAT_OUT',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('biv060ukrvCombo'),
					allowBlank: false			
				}, {					
					fieldLabel: '[환&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;율]',
					name: 'FORMAT_RATE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('biv060ukrvCombo'),
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
//	{
//		title:'조회데이타포맷설정',
//		
//		xtype: 'uniDetailForm',
//		layout: {tyep: 'hbox', align: 'stretch'},
//		items:[{
//			border: false,
//			xtype: 'panel',
//			layout: {tyep: 'hbox', align: 'stretch'},
//			items:[{
//				title: '조회용 데이타포맷',
//				name: '',
//				xtype: 'fieldset',
//				layout: {tyep: 'hbox', align: 'stretch'},
//				items:[{					
//					fieldLabel: '[수&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;량]',
//					name: '',
//					xtype: 'uniCombobox',
//					comboType: 'AU',
//					comboCode: 'A037'			
//				}, {					
//					fieldLabel: '[단&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;가]',
//					name: '',
//					xtype: 'uniCombobox',
//					comboType: 'AU',
//					comboCode: 'A037'			
//				}, {					
//					fieldLabel: '[자국화폐금액]',
//					name: '',
//					xtype: 'uniCombobox',
//					comboType: 'AU',
//					comboCode: 'A037'			
//				}, {					
//					fieldLabel: '[외화화폐금액]',
//					name: '',
//					xtype: 'uniCombobox',
//					comboType: 'AU',
//					comboCode: 'A037'			
//				}, {					
//					fieldLabel: '[환&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;율]',
//					name: '',
//					xtype: 'uniCombobox',
//					comboType: 'AU',
//					comboCode: 'A037'			
//				}]
//			}]			
//		}]
//	}