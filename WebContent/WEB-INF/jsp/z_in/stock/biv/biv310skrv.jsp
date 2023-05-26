<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv310skrv"  >
	
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 			<!-- 품목계정 --> 
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>	<!--창고-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 * Model 정의
	 * 
	 * @type
	 */

	Unilite.defineModel('Biv310skrvModel', {
	    fields: [  	 
	    	{name: 'ITEM_ACCOUNT',	  	text:'<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',	type:'string'},
			{name: 'ITEM_ACCOUNT_NM', 	text:'<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',	type:'string'},
			{name: 'ITEM_CODE',       	text:'<t:message code="system.label.inventory.item" default="품목"/>',	type:'string'},
			{name: 'ITEM_NAME',       	text:'<t:message code="system.label.inventory.itemname" default="품목명"/>',		type:'string'},
			{name: 'SPEC',            	text:'<t:message code="system.label.inventory.spec" default="규격"/>',		type:'string'},
			{name: 'STOCK_UNIT',      	text:'단위',		type:'string'},
			{name: 'STOCK_Q',         	text:'재고수량',	type:'uniQty'},
			{name: 'GOOD_STOCK_Q',    	text:'양품수량',	type:'uniQty'},
			{name: 'BAD_STOCK_Q',     	text:'불량수량',	type:'uniQty'},
			{name: 'AVERAGE_P',       	text:'단가',		type:'uniUnitPrice'},
			{name: 'STOCK_I',         	text:'재고금액',	type:'uniPrice'},
			{name: 'GOOD_STOCK_I',    	text:'양품금액',	type:'uniPrice'},
			{name: 'BAD_STOCK_I',     	text:'불량금액',	type:'uniPrice'},
			{name: 'WH_NAME_01',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_01',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_01',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_01', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_02',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_02',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_02',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_02', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_03',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_03',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_03',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_03', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_04',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_04',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_04',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_04', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_05',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_05',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_05',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_05', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_06',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_06',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_06',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_06', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_07',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_07',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_07',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_07', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_08',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_08',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_08',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_08', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_09',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_09',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_09',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_09', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_10',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_10',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_10',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_10', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_11',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_11',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_11',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_11', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_12',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_12',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_12',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_12', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_13',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_13',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_13',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_13', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_14',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_14',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_14',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_14', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_15',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_15',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_15',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_15', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_16',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_16',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_16',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_16', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_17',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_17',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_17',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_17', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_18',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_18',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_18',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_18', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_19',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_19',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_19',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_19', 	text:'불량수량',	type:'uniQty'},
			{name: 'WH_NAME_20',      	text:'창고명',		type:'string'},
			{name: 'WH_STOCK_20',     	text:'재고수량',	type:'uniQty'},
			{name: 'WH_GOOD_STOCK_20',	text:'양품수량',	type:'uniQty'},
			{name: 'WH_BAD_STOCK_20', 	text:'불량수량',	type:'uniQty'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */					
	var directMasterStore1 = Unilite.createStore('biv310skrvMasterStore1',{
			model: 'Biv310skrvModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
	            	// 비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'biv310skrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			groupField: 'CUSTOM_NAME'
			
	});

	/**
	 * 검색조건 (Search Panel)
	 * 
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		//collapsed: true,
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        listeners: {
        	collapse: function () {
            	panelResult.show();
        	},
        	expand: function() {
        		panelResult.hide();
        	}
    	},
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			    items: [{
		        	fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
		        	name: 'DIV_CODE', 
		        	xtype: 'uniCombobox', 
		        	comboType: 'BOR120', 
		        	comboCode: 'B001', 
		        	allowBlank: false,
	            		listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('DIV_CODE', newValue);
							}
						}
	        	},{
		        	fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>', 
		        	name:'ITEM_ACCOUNT', 
		        	xtype: 'uniCombobox', 
		        	comboType: 'AU', 
		        	comboCode: 'B020',
	            		listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('ITEM_ACCOUNT', newValue);
							}
						}
	        	},
					Unilite.popup('DIV_PUMOK',{ 
							fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>', 
							valueFieldName: 'DIV_PUMOK_CODE', 
							textFieldName: 'DIV_PUMOK_NAME',
							validateBlank:false,
							listeners: {
								onSelected: {
									fn: function(records, type) {
										panelResult.setValue('DIV_PUMOK_CODE', panelSearch.getValue('DIV_PUMOK_CODE'));
										panelResult.setValue('DIV_PUMOK_NAME', panelSearch.getValue('DIV_PUMOK_NAME'));				 																							
									},
									scope: this
								},
								onClear: function(type)	{
									panelResult.setValue('DIV_PUMOK_CODE', '');
									panelResult.setValue('DIV_PUMOK_NAME', '');
								}
							}
					}),{
					fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>', 
					name: 'TXTLV_L1', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
					child: 'TXTLV_L2',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TXTLV_L1', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
					name: 'TXTLV_L2', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
					child: 'TXTLV_L3',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TXTLV_L2', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>', 
					name: 'TXTLV_L3', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve3Store'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TXTLV_L3', newValue);
						}
					}
				}]
			},{	
				title: '추가정보',
				defaultType: 'uniTextfield',
				items: [{
					fieldLabel: ' ',
		            //name: '',
		            xtype: 'checkboxgroup',
		            items: [{
			            boxLabel: '전체',
			        	width:60, 
			        	name: 'CHECK', 
			        	inputValue: '1', 
			        	checked: true
		        	},{
			        	boxLabel: '<t:message code="system.label.inventory.good" default="양품"/>',
			        	width:60, 
			        	name: 'CHECK', 
			        	inputValue: '2', 
			        	checked: false
		        	},{
			        	boxLabel: '<t:message code="system.label.inventory.defect" default="불량"/>',
			        	width:60, 
			        	name: 'CHECK', 
			        	inputValue: '3', 
			        	checked: false
		        	}]
				}]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
		        	fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
		        	name: 'DIV_CODE', 
		        	xtype: 'uniCombobox', 
		        	comboType: 'BOR120', 
		        	comboCode: 'B001', 
		        	allowBlank: false,
	            		listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('DIV_CODE', newValue);
							}
						}
	        	},{
		        	fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>', 
		        	name:'ITEM_ACCOUNT', 
		        	xtype: 'uniCombobox', 
		        	comboType: 'AU', 
		        	comboCode: 'B020',
	            		listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('ITEM_ACCOUNT', newValue);
							}
						}
	        	},
					Unilite.popup('DIV_PUMOK',{ 
							fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>', 
							valueFieldName: 'DIV_PUMOK_CODE', 
							textFieldName: 'DIV_PUMOK_NAME',
							validateBlank:false,
							listeners: {
								onSelected: {
									fn: function(records, type) {
										panelSearch.setValue('DIV_PUMOK_CODE', panelResult.getValue('DIV_PUMOK_CODE'));
										panelSearch.setValue('DIV_PUMOK_NAME', panelResult.getValue('DIV_PUMOK_NAME'));				 																							
									},
									scope: this
								},
								onClear: function(type)	{
									panelSearch.setValue('DIV_PUMOK_CODE', '');
									panelSearch.setValue('DIV_PUMOK_NAME', '');
								}
							}
					}),{
					fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>', 
					name: 'TXTLV_L1', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
					child: 'TXTLV_L2',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L1', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
					name: 'TXTLV_L2', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
					child: 'TXTLV_L3',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L2', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>', 
					name: 'TXTLV_L3', 
					xtype: 'uniCombobox',  
					store: Ext.data.StoreManager.lookup('itemLeve3Store'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L3', newValue);
						}
					}
				}]
	});
	
    /**
	 * Master Grid1 정의(Grid Panel)
	 * 
	 * @type
	 */
    
    var masterGrid = Unilite.createGrid('biv310skrvGrid1', {
    	region: 'center' ,
        layout : 'fit',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
    	store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns:  [ 
        	{dataIndex: 'ITEM_ACCOUNT',		width: 66,  hidden : true }, 				
			{dataIndex: 'ITEM_ACCOUNT_NM',	width: 80,  locked: true }, 				
			{dataIndex: 'ITEM_CODE',		width: 133, locked: true },				
			{dataIndex: 'ITEM_NAME',		width: 166, locked: true },				
			{dataIndex: 'SPEC',				width: 100 },				
			{dataIndex: 'STOCK_UNIT',		width: 53 }, 				
			{dataIndex: 'STOCK_Q',			width: 100}, 				
			{dataIndex: 'GOOD_STOCK_Q',		width: 100, hidden : true },				
			{dataIndex: 'BAD_STOCK_Q' ,		width: 100, hidden : true },				
			{dataIndex: 'AVERAGE_P',		width: 100}, 				
			{dataIndex: 'STOCK_I',			width: 100},				
			{dataIndex: 'GOOD_STOCK_I',		width: 100, hidden : true }, 				
			{dataIndex: 'BAD_STOCK_I',		width: 100, hidden : true },
			{
				text:'창고1',
           		columns: [ 
 					{
 						dataIndex: 'WH_NAME_01',
						width: 60,
						summaryType: 'sum',
						hidden : true
					},{
						dataIndex: 'WH_STOCK_01',
						width: 100,
						summaryType: 'sum'
					},{
						dataIndex: 'WH_GOOD_STOCK_01',
						width: 60,
						summaryType: 'sum', 
						hidden: true
					},{
						dataIndex: 'WH_BAD_STOCK_01',
						width: 60,
						summaryType: 'sum',
						hidden: true
					}
				]
           },{
				text:'창고2',
				columns:[ 
					{
						dataIndex: 'WH_NAME_02' ,
						width: 60,
						summaryType: 'sum',
						hidden: true
					},{							
						dataIndex: 'WH_STOCK_02',
						width: 100,
						summaryType: 'sum'
					},{
						dataIndex: 'WH_GOOD_STOCK_02',
						width: 60,
						summaryType: 'sum',
						hidden: true
					},{
						dataIndex: 'WH_BAD_STOCK_02',
						width: 60,
						summaryType: 'sum',
						hidden: true  }
				]
           },{ 
           		text:'창고3',
          		columns:[ 
      				{
             			dataIndex: 'WH_NAME_03',
            			width: 60,
             			summaryType: 'sum', 
            			hidden: true  
             		},{
            			dataIndex: 'WH_STOCK_03',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_03',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_03',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고4',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_04',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_04',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_04',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
               		},{
                		dataIndex: 'WH_BAD_STOCK_04',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고5',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_05',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_05',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_05',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_05',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고6',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_06',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_06',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_06',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_06',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고7',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_07',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_07',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_07',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_07',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고8',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_08',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_08',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_08',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_08',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고9',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_09',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_09',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_09',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_09',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고10',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_10',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_10',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_10',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_10',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고11',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_11',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_11',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_11',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_11',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고12',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_12',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_12',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_12',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_12',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고13',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_13',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_13',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_13',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_13',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고14',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_14',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_14',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_14',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_14',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고15',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_15',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_15',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_15',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_15',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고16',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_16',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_16',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_16',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_16',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고17',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_17',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_17',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_17',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_17',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고18',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_18',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_18',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_18',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_18',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고19',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_19',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_19',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_19',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_19',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           },{ 
           		text:'창고20',
           		columns:[ 
             		{
             			dataIndex: 'WH_NAME_20',
             			width: 60,
             			summaryType: 'sum', 
             			hidden: true  
             		},{
             			dataIndex: 'WH_STOCK_20',
             			width:100,
             			summaryType:'sum'
             		},{
              			dataIndex: 'WH_GOOD_STOCK_20',
              			width:60,
              			summaryType:'sum',
              			hidden: true  
              		},{
                		dataIndex: 'WH_BAD_STOCK_20',
                		width: 60,
                		summaryType: 'sum',
                		hidden: true  }
				]
           }
			

		]                                                                   
    });                                                                       
	                                                                          
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id  : 'biv310skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{			
			
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>
