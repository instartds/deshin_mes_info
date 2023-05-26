<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'카렌더정보수정',
		
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			border:false,
			xtype: 'fieldset',
			layout: {type: 'uniTable', columns: 2},
			items:[{ 
				border: true,
		 		fieldLabel: '카렌더 타입',
		 		name:'', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'B062',
		 		allowBlank:false,
		 		value:1
	 		}, { 
				border: true,
		 		fieldLabel: '작성년월',
		 		name:'', 
		 		xtype: 'uniDatefield',
		 		allowBlank:false
	 		}]			
		}]
	}