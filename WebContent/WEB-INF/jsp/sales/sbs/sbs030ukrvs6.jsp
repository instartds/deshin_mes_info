<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'품목별 할인등록(고객별)',
		
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
					fieldLabel: '할인기간',
					startFieldName: '',
					endFieldName: '',
					xtype: 'uniDateRangefield',
					width: 315,
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					allowBlank: false
				}, 
					Unilite.popup('ITEM',{
					fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
					textFieldWidth: 170,
					validateBlank: false, 
					extParam: {'CUSTOM_TYPE':'3'}
				}), {
					xtype: 'uniTextfield',
					fieldLabel: '할인내역',					
					name: ''
				}, {
		    		fieldLabel: '단가검색',
		    		xtype: 'radiogroup',
		    		id: 'rdoSelect2',
		    		items: [{
		    			boxLabel: '<t:message code="system.label.sales.sellingprice" default="판매단가"/>',
		    			width: 80,
		    			name: 'rdoSelect2', 
		    			inputValue: 'A',
		    			checked: true
		    		}, {
		    			boxLabel: '고객별 단가', 
		    			width: 80, name: 'rdoSelect2',
		    			inputValue: 'N'
		    		}]
    			}]
			}]		
		}, {
			region: 'center',
			xtype: 'container',
			layout: 'border',
			items: [{
				region: 'center',
				xtype: 'uniGridPanel',
				
			    store : sbs030ukrvs6_1Store,
			    uniOpt: {
			    	expandLastColumn: true,
			        useRowNumberer: true,
			        useMultipleSorting: false
				},		        
				columns: [{dataIndex: 'ITEM_CODE'					,		width: 106},				  	  
						  {dataIndex: 'ITEM_NAME'					,		width: 140},				  	  
						  {dataIndex: 'SPEC'						,		width: 173},				  	  
						  {dataIndex: 'ORDER_UNIT'					,		width: 66},				  	  
						  {dataIndex: 'TRANS_RATE'					,		width: 66},				  	  
						  {dataIndex: 'SALE_BASIS_P'				,		width: 133},				  	  
						  {dataIndex: 'COMP_CODE'					,		width: 133, hidden: true}		  	  
						  
				]
			}, {
				region: 'south',
				xtype: 'uniGridPanel',
				
			    store : sbs030ukrvs6_2Store,
			    uniOpt: {
			    	expandLastColumn: true,
			        useRowNumberer: true,
			        useMultipleSorting: false
				},		        
				columns: [{dataIndex: 'DIV_CODE'			,		width: 33, hidden: true},
						  {dataIndex: 'ITEM_CODE'			,		width: 66, hidden: true},
						  {dataIndex: 'CUSTOM_CODE'			,		width: 80},
						  {dataIndex: 'CUSTOM_NAME'			,		width: 166},
						  {dataIndex: 'DC_START_DT'			,		width: 80},
						  {dataIndex: 'DC_END_DT'			,		width: 80},
						  {dataIndex: 'MONEY_UNIT'			,		width: 66, hidden: true},
						  {dataIndex: 'AGENT_TYPE'			,		width: 66, hidden: true},
						  {dataIndex: 'ORDER_UNIT'			,		width: 66, hidden: true},
						  {dataIndex: 'TRANS_RATE'			,		width: 66, hidden: true},
						  {dataIndex: 'BASIS_ITEM_P'		,		width: 113},
						  {dataIndex: 'DC_RATE'				,		width: 80},
						  {dataIndex: 'DC_PRICE'			,		width: 133},
						  {dataIndex: 'DC_REMARK'			,		width: 113}
						  
				]
			}]			
		}]
	}