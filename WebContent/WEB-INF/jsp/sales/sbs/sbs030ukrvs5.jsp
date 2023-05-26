<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'품목별 할인등록(고객분류별)',
		
		xtype: 'uniDetailForm',
		api: { load: 'aba050ukrService.select' },
		layout: 'border',
		items:[{
			region: 'west',
			xtype: 'uniSearchPanel',          
			title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',         
			defaultType: 'uniSearchSubPanel',
			items: [{     
				title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',   
				itemId: 'search_panel1',
				layout: {type: 'uniTable', columns: 1},
           		defaultType: 'uniTextfield',
		   		items : [{ 
					fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					allowBlank: false
				}, {
					xtype: 'uniTextfield',
					fieldLabel: '할인내역',					
					name: ''
				}, {
					fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
					name:'',
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'B055',
					allowBlank: false
				}, {
					fieldLabel: '할인시작기간',
					startFieldName: '',
					endFieldName: '',
					xtype: 'uniDateRangefield',
					width: 315,
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today')
				},
					Unilite.popup('ITEM',{
					fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
					textFieldWidth: 170,
					validateBlank: false, 
					extParam: {'CUSTOM_TYPE':'3'}
				})]
			}]		
		}, {
			region: 'center',
			xtype: 'uniGridPanel',
			
		    store : sbs030ukrvs5Store,
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [{dataIndex: 'DIV_CODE'				,		width: 33, hidden: true },				  	  
				  	  {dataIndex: 'ITEM_CODE'				,		width: 66 },				  	  
				  	  {dataIndex: 'ITEM_NAME'				,		width: 100 },				  	  
				  	  {dataIndex: 'SPEC'					,		width: 100 },				  	  
				  	  {dataIndex: 'CUSTOM_CODE'				,		width: 80, hidden: true },				  	  
				  	  {dataIndex: 'MONEY_UNIT'				,		width: 66, hidden: true },				  	  
				  	  {dataIndex: 'ORDER_UNIT'				,		width: 64 },				  	  
				  	  {dataIndex: 'TRANS_RATE'				,		width: 66 },				  	  
				  	  {dataIndex: 'DC_START_DT'				,		width: 80 },				  	  
				  	  {dataIndex: 'DC_END_DT'				,		width: 80 },				  	  
				  	  {dataIndex: 'BASIS_ITEM_P'			,		width: 113 },				  	  
				  	  {dataIndex: 'DC_RATE'					,		width: 80 },				  	  
				  	  {dataIndex: 'DC_PRICE'				,		width: 133 },				  	  
				  	  {dataIndex: 'AGENT_TYPE'				,		width: 66 },				  	  
				  	  {dataIndex: 'DC_REMARK'				,		width: 113 },				  	  
				  	  {dataIndex: 'UPDATE_DB_USER'			,		width: 66, hidden: true },				  	  
				  	  {dataIndex: 'UPDATE_DB_TIME'			,		width: 113, hidden: true },				  	  
				  	  {dataIndex: 'COMP_CODE'				,		width: 113, hidden: true }		  	  
				  	  
			]
		}]
	}