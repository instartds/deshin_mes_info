<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'작업장CAPA등록',
		border: false,
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'container',
			layout: {type: 'uniTable', columns: 3},
			items:[{
				border: true,
	        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	        	name:'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120',
	        	allowBlank:false
	        }, {
	        	border: true,
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: '',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('wsList'),allowBlank:false
			}, { 
				border: true,
		 		fieldLabel: '생성년도',
		 		name:'', 
		 		xtype: 'uniDatefield',
		 		allowBlank:false
	 		}]			
		}]
	}