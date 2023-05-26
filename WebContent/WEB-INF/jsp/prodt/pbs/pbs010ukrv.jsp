<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'조회데이타포맷설정',
		
		xtype: 'uniDetailForm',
		layout: {tyep: 'hbox', align: 'stretch'},
		items:[{
			border: false,
			xtype: 'panel',
			layout: {tyep: 'hbox', align: 'stretch'},
			items:[{
				title: '조회용 데이타포맷',
				name: '',
				xtype: 'fieldset',
				margin: '15 15 15 15',
				padding: '10 20 10 20',
				layout: {tyep: 'hbox', align: 'stretch'},
				items:[{					
					fieldLabel: '[수&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;량]',
					name: '',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'A037'			
				}, {					
					fieldLabel: '[단&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;가]',
					name: '',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'A037'			
				}, {					
					fieldLabel: '[자국화폐금액]',
					name: '',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'A037'			
				}, {					
					fieldLabel: '[외화화폐금액]',
					name: '',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'A037'			
				}, {					
					fieldLabel: '[환&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;율]',
					name: '',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'A037'			
				}]
			}]			
		}]
	}