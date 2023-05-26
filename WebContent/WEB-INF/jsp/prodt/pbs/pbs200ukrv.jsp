<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'공정등록',
		border: false,
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'container',
			layout: {type: 'uniTable', columns: 2},
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
			}]			
		}, {				
			xtype: 'uniGridPanel',
			
		    store : pbs070ukrvs3Store,
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [{dataIndex: 'WORK_SHOP_CODE'			, width:100},				  
					  {dataIndex: 'PROG_WORK_CODE'			, width:100},			  
					  {dataIndex: 'PROG_WORK_NAME'			, width:213},
					  {dataIndex: 'STD_TIME'      			, width:86},			  
					  {dataIndex: 'PROG_UNIT'     			, width:80},
					  {dataIndex: 'PROG_UNIT_COST'			, width:100},			  
					  {dataIndex: 'EXIST'         			, width:133}
			]						
		}]
	}