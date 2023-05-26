<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'기본정보 등록',
		
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
			
		    store : sbs030ukrvs3Store,
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [{dataIndex: 'REMARK_TYPE'	 		,		width: 133, hidden: true},
					  {dataIndex: 'REMARK_CD'			,		width: 100},
					  {dataIndex: 'REMARK_NAME'			,		width: 153}					  	  
			]
		}]
	}