<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'공정수순등록',
		border: false,
		
		xtype: 'uniDetailForm',
		api: { load: 'pbs070ukrvService.select' },
		layout: 'border',
		items:[{
			region: 'west',
			xtype: 'uniSearchPanel',          
			title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',         
			defaultType: 'uniSearchSubPanel',
			items: [{     
				title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',   
				itemId: 'search_panel1',
				layout: {type: 'uniTable', columns: 1},
           		defaultType: 'uniTextfield',
		   		items : [{
		        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		        	name:'DIV_CODE', 
		        	xtype: 'uniCombobox', 
		        	comboType:'BOR120',
		        	allowBlank:false
		        }, {
					fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
					name: '',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('wsList'),allowBlank:false
				}, 
					Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					textFieldWidth:170, 
					validateBlank:false
				}),{
		        	fieldLabel: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
		        	name:'', 
		        	xtype: 'uniCombobox', 
		        	comboType:'AU',
		        	comboCode:'B020'
		        },{
		        	fieldLabel: '<t:message code="system.label.product.procurementclassification" default="조달구분"/>',
		        	name:'', 
		        	xtype: 'uniCombobox', 
		        	comboType:'AU',
		        	comboCode:'B014'
		        },{ 
			    	fieldLabel: '<t:message code="system.label.product.majorgroup" default="대분류"/>',
			    	name: 'TXTLV_L1',
			    	xtype: 'uniCombobox',  
			    	store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
			    	child: 'TXTLV_L2'
				},{ 
				    fieldLabel: '<t:message code="system.label.product.middlegroup" default="중분류"/>',
				    name: 'TXTLV_L2', 
				    xtype: 'uniCombobox',  
				    store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
				    child: 'TXTLV_L3'
				},{ 
				    fieldLabel: '<t:message code="system.label.product.minorgroup" default="소분류"/>',
				    name: 'TXTLV_L3',
				    xtype: 'uniCombobox', 
				    store: Ext.data.StoreManager.lookup('itemLeve3Store')
			    },{	
					xtype: 'radiogroup',		            		
					fieldLabel: '등록여부',						            		
					id: 'rdoSelect',
					labelWidth:90,
					items: [{
						boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
						width: 60,
						name: 'rdoSelect',
						inputValue: 'A',
						checked: true
					},{
						boxLabel: '등록',
						width: 60,
						name: 'rdoSelect' ,
						inputValue: 'P'
					},{
						boxLabel: '미등록',
						width: 60,
						name: 'rdoSelect' ,
						inputValue: 'E'
					}]
				}]
			}]		
		}, {
			xtype: 'container',
			layout: 'border',
			region: 'center',
			items:[{				
				region: 'north',
				flex: 3,
				xtype: 'uniGridPanel',
				
			    store : pbs070ukrvs4Store,
			    uniOpt: {
			    	expandLastColumn: true,
			        useRowNumberer: true,
			        useMultipleSorting: false,
			        onLoadSelectFirst : false
				},	
				selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false  }), 
				columns: [{dataIndex: 'ITEM_CODE'				,		width: 80},				  	  
						  {dataIndex: 'ITEM_NAME'				,		width: 146},				  	  
						  {dataIndex: 'SPEC'					,		width: 133},				  	  
						  {dataIndex: 'STOCK_UNIT'				,		width: 53},				  	  
						  {dataIndex: 'ITEM_ACCOUNT'			,		width: 66 , hidden: true},				  	  
						  {dataIndex: 'ITEMACCOUNT_NAME'		,		width: 80},				  	  
						  {dataIndex: 'SUPPLY_TYPE'				,		width: 80}, 
						  {dataIndex: 'PROG_CNT'				,		width: 53},				  	  
						  {dataIndex: 'ITEMLEVEL1_NAME'			,		width: 80},				  	  
						  {dataIndex: 'ITEMLEVEL2_NAME'			,		width: 80},				  	  
						  {dataIndex: 'ITEMLEVEL3_NAME'			,		width: 80}
				]
			}, {
				region: 'center',
				flex: 2,
				xtype: 'uniGridPanel',
				
			    store : pbs070ukrvs5Store,
			    uniOpt: {
			    	expandLastColumn: true,
			        useRowNumberer: true,
			        useMultipleSorting: false
				},		      
				columns: [{dataIndex: 'SORT_FLD'      	,			width: 33 ,hidden: true},		  	  
						  {dataIndex: 'DIV_CODE'      	,			width: 33 ,hidden: true},		  	  
						  {dataIndex: 'ITEM_CODE'     	,			width: 66 ,hidden: true},		  	  
						  {dataIndex: 'WORK_SHOP_CODE'	,			width: 33 ,hidden: true},		  	  
						  {dataIndex: 'PROG_WORK_CODE'	,			width: 100},		  	  
						  {dataIndex: 'PROG_WORK_NAME'	,			width: 120},		  	  
						  {dataIndex: 'LINE_SEQ'      	,			width: 66},
						  {dataIndex: 'MAKE_LDTIME'   	,			width: 133},		  	  
						  {dataIndex: 'PROG_RATE'     	,			width: 120},		  	  
						  {dataIndex: 'PROG_UNIT_Q'   	,			width: 120},		  	  
						  {dataIndex: 'PROG_UNIT'     	,			width: 100}
				]
			}]
		}]
	}