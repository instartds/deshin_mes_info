<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv600skrv"  >
	<t:ExtComboStore comboType="BOR120" comboCode="B001"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P402" /> 				<!-- 생산계획 생성 유형 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>		<!--창고-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */

	    			
	Unilite.defineModel('Biv600skrvModel', {
	    fields: [
			{name: 'ITEM_CODE',		text: '<t:message code="system.label.inventory.item" default="품목"/>',	type: 'string'},
			{name: 'ITEM_NAME',		text: '품명',		type: 'string'},
			{name: 'SPEC',			text: '<t:message code="system.label.inventory.spec" default="규격"/>',		type: 'string'},
			{name: 'STOCK_UNIT',	text: '단위',		type: 'string'},
			{name: 'STOCK_Q',		text: '현재고',		type: 'string'},
			{name: 'GOOD_STOCK_Q',	text: '양품재고',	type: 'string'},
			{name: 'BAD_STOCK_Q',	text: '불량재고',	type: 'string'},
			{name: 'KEY_ID',		text: 'KEY_ID',		type: 'string'},
			{name: 'ITEM_CODE',		text: '<t:message code="system.label.inventory.item" default="품목"/>',	type: 'string'},
			{name: 'ITEM_NAME',		text: '품명',		type: 'string'},
			{name: 'SPEC',			text: '<t:message code="system.label.inventory.spec" default="규격"/>',		type: 'string'},
			{name: 'STOCK_UNIT',	text: '단위',		type: 'string'},
			{name: 'STOCK_Q',		text: '현재고',		type: 'string'},
			{name: 'WH_NAME1',		text: '창고명1',	type: 'string'},
			{name: 'WH_STOCK1',		text: '창고1',		type: 'string'},
			{name: 'WH_NAME2',		text: '창고명2',	type: 'string'},
			{name: 'WH_STOCK2',		text: '창고2',		type: 'string'},
			{name: 'WH_NAME3',		text: '창고명3',	type: 'string'},
			{name: 'WH_STOCK3',		text: '창고3',		type: 'string'},
			{name: 'WH_NAME4',		text: '창고명4',	type: 'string'},
			{name: 'WH_STOCK4',		text: '창고4',		type: 'string'},
			{name: 'WH_NAME5',		text: '창고명5',	type: 'string'},
			{name: 'WH_STOCK5',		text: '창고5',		type: 'string'},
			{name: 'WH_NAME6',		text: '창고명6',	type: 'string'},
			{name: 'WH_STOCK6',		text: '창고6',		type: 'string'},
			{name: 'WH_NAME7',		text: '창고명7',	type: 'string'},
			{name: 'WH_STOCK7',		text: '창고7',		type: 'string'},
			{name: 'WH_NAME8',		text: '창고명8',	type: 'string'},
			{name: 'WH_STOCK8',		text: '창고8',		type: 'string'},
			{name: 'WH_NAME9',		text: '창고명9',	type: 'string'},
			{name: 'WH_STOCK9',		text: '창고9',		type: 'string'},
			{name: 'WH_NAME10',		text: '창고명10',	type: 'string'},
			{name: 'WH_STOCK10',	text: '창고10',		type: 'string'},
			{name: 'WH_NAME11',		text: '창고명11',	type: 'string'},
			{name: 'WH_STOCK11',	text: '창고11',		type: 'string'},
			{name: 'WH_NAME12',		text: '창고명12',	type: 'string'},
			{name: 'WH_STOCK12',	text: '창고12',		type: 'string'},
			{name: 'WH_NAME13',		text: '창고명13',	type: 'string'},
			{name: 'WH_STOCK13',	text: '창고13',		type: 'string'},
			{name: 'WH_NAME14',		text: '창고명14',	type: 'string'},
			{name: 'WH_STOCK14',	text: '창고14',		type: 'string'},
			{name: 'WH_NAME15',		text: '창고명15',	type: 'string'},
			{name: 'WH_STOCK15',	text: '창고15',		type: 'string'},
			{name: 'WH_NAME16',		text: '창고명16',	type: 'string'},
			{name: 'WH_STOCK16',	text: '창고16',		type: 'string'},
			{name: 'WH_NAME17',		text: '창고명17',	type: 'string'},
			{name: 'WH_STOCK17',	text: '창고17',		type: 'string'},
			{name: 'WH_NAME18',		text: '창고명18',	type: 'string'},
			{name: 'WH_STOCK18',	text: '창고18',		type: 'string'},
			{name: 'WH_NAME19',		text: '창고명19',	type: 'string'},
			{name: 'WH_STOCK19',	text: '창고19',		type: 'string'},
			{name: 'WH_NAME20',		text: '창고명20',	type: 'string'},
			{name: 'WH_STOCK20',	text: '창고20',		type: 'string'}
		]
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('biv600skrvMasterStore1',{
			model: 'Biv600skrvModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'biv600skrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			groupField: 'ITEM_NAME'
			
	});
	
	var directMasterStore2 = Unilite.createStore('biv600skrvMasterStore2',{
			model: 'Biv600skrvModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'biv600skrvService.selectList1'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			groupField: 'CUSTOM_NAME1'
			
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		collapsed: true,
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
					fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
					name: 'WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('WH_CODE', newValue);
						}
					}
				},	{
					xtype: 'radiogroup',		            		
					fieldLabel: '재고유형',
					//name:'QRY_TYPE',
					labelWidth:90,
					items: [{
						boxLabel: '전체',
						width: 60,
						name: 'QRY_TYPE',
						inputValue: '0',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.inventory.good" default="양품"/>',
						width: 60,
						name: 'QRY_TYPE',
						inputValue: '1'
					},{
						boxLabel: '<t:message code="system.label.inventory.defect" default="불량"/>', 
						width: 60,
						name: 'QRY_TYPE',
						inputValue: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {		
							panelResult.getField('QRY_TYPE').setValue(newValue.QRY_TYPE);
						}
					}
				},
					Unilite.popup('ITEM',{
						fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>', 
						textFieldWidth:170, 
						validateBlank:false,
						valueFieldName: 'FROM_ITEM',
		        		textFieldName:'FROM_NAME', 
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('FROM_ITEM', panelSearch.getValue('FROM_ITEM'));
									panelResult.setValue('FROM_NAME', panelSearch.getValue('FROM_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('FROM_ITEM', '');
								panelResult.setValue('FROM_NAME', '');
							}
						}
				}),
					Unilite.popup('ITEM',{
						fieldLabel: '~', 
						textFieldWidth:170, 
						validateBlank:false,
						valueFieldName: 'TO_ITEM',
		        		textFieldName:'TO_NAME', 
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('TO_ITEM', panelSearch.getValue('TO_ITEM'));
									panelResult.setValue('TO_NAME', panelSearch.getValue('TO_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('TO_ITEM', '');
								panelResult.setValue('TO_NAME', '');
							}
						}
				})]
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
					fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
					name: 'WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('WH_CODE', newValue);
						}
					}
				},	{
					xtype: 'radiogroup',		            		
					fieldLabel: '재고유형',
					//name:'QRY_TYPE',
					labelWidth:90,
					items: [{
						boxLabel: '전체',
						width: 60,
						name: 'QRY_TYPE',
						inputValue: '0',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.inventory.good" default="양품"/>',
						width: 60,
						name: 'QRY_TYPE',
						inputValue: '1'
					},{
						boxLabel: '<t:message code="system.label.inventory.defect" default="불량"/>', 
						width: 60,
						name: 'QRY_TYPE',
						inputValue: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {		
							panelSearch.getField('QRY_TYPE').setValue(newValue.QRY_TYPE);
						}
					}
				},
					Unilite.popup('ITEM',{
						fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>', 
						textFieldWidth:170, 
						validateBlank:false,
						valueFieldName: 'FROM_ITEM',
		        		textFieldName:'FROM_NAME', 
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('FROM_ITEM', panelResult.getValue('FROM_ITEM'));
									panelSearch.setValue('FROM_NAME', panelResult.getValue('FROM_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('FROM_ITEM', '');
								panelSearch.setValue('FROM_NAME', '');
							}
						}
				}),
					Unilite.popup('ITEM',{
						fieldLabel: '~', 
						textFieldWidth:170, 
						validateBlank:false,
						valueFieldName: 'TO_ITEM',
		        		textFieldName:'TO_NAME',
						labelWidth: 15, 
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('TO_ITEM', panelResult.getValue('TO_ITEM'));
									panelSearch.setValue('TO_NAME', panelResult.getValue('TO_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('TO_ITEM', '');
								panelSearch.setValue('TO_NAME', '');
							}
						}
				})]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('biv600skrvGrid1', {
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
        	{dataIndex:'ITEM_CODE',		width: 133}, 
        	{dataIndex:'ITEM_NAME',		width: 200},				
			{dataIndex:'SPEC',			width: 200}, 				
			{dataIndex:'STOCK_UNIT',	width: 66},  				
			{dataIndex:'STOCK_Q',		width: 126}, 				
			{dataIndex:'GOOD_STOCK_Q',	width: 126}, 				
			{dataIndex:'BAD_STOCK_Q',	width: 126 }  				
		] 
    });
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
  var masterGrid2 = Unilite.createGrid('biv600skrvGrid2', {
    	region: 'south' ,
        layout : 'fit',
        store : directMasterStore2, 
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
    	store: directMasterStore2,
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
        	{dataIndex: 'KEY_ID', 		width: 66, hidden: true},
			{dataIndex: 'ITEM_CODE',	width: 113},       
			{dataIndex: 'ITEM_NAME',	width: 193},       
			{dataIndex: 'SPEC',			width: 193},       
			{dataIndex: 'STOCK_UNIT',	width: 66},        
			{dataIndex: 'STOCK_Q',		width: 106},       
			{dataIndex: 'WH_NAME1',		width: 66, hidden: true},
			{dataIndex: 'WH_STOCK1',	width: 106},       
			{dataIndex: 'WH_NAME2',		width: 66, hidden: true},
			{dataIndex: 'WH_STOCK2',	width: 106},       
			{dataIndex: 'WH_NAME3',		width: 66, hidden: true},
			{dataIndex: 'WH_STOCK3',	width: 106},       
			{dataIndex: 'WH_NAME4',		width: 66, hidden: true},
			{dataIndex: 'WH_STOCK4',	width: 106},       
			{dataIndex: 'WH_NAME5',		width: 66, hidden: true},
			{dataIndex: 'WH_STOCK5',	width: 106},       
			{dataIndex: 'WH_NAME6',		width: 66, hidden: true},
			{dataIndex: 'WH_STOCK6',	width: 106},       
			{dataIndex: 'WH_NAME7',		width: 66, hidden: true},
			{dataIndex: 'WH_STOCK7',	width: 106},       
			{dataIndex: 'WH_NAME8',		width: 66, hidden: true},
			{dataIndex: 'WH_STOCK8',	width: 106},       
			{dataIndex: 'WH_NAME9',		width: 66, hidden: true},
			{dataIndex: 'WH_STOCK9',	width: 106},       
			{dataIndex: 'WH_NAME10',	width: 66, hidden: true},
			{dataIndex: 'WH_STOCK10',	width: 106},       
			{dataIndex: 'WH_NAME11',	width: 66, hidden: true},
			{dataIndex: 'WH_STOCK11',	width: 106},       
			{dataIndex: 'WH_NAME12',	width: 66, hidden: true},
			{dataIndex: 'WH_STOCK12',	width: 106},       
			{dataIndex: 'WH_NAME13',	width: 66, hidden: true},
			{dataIndex: 'WH_STOCK13',	width: 106},       
			{dataIndex: 'WH_NAME14',	width: 66, hidden: true},
			{dataIndex: 'WH_STOCK14',	width: 106},       
			{dataIndex: 'WH_NAME15',	width: 66, hidden: true},
			{dataIndex: 'WH_STOCK15',	width: 106},       
			{dataIndex: 'WH_NAME16',	width: 66, hidden: true},
			{dataIndex: 'WH_STOCK16',	width: 106},       
			{dataIndex: 'WH_NAME17',	width: 66, hidden: true},
			{dataIndex: 'WH_STOCK17',	width: 106},       
			{dataIndex: 'WH_NAME18',	width: 66, hidden: true},
			{dataIndex: 'WH_STOCK18',	width: 106},       
			{dataIndex: 'WH_NAME19',	width: 66, hidden: true},
			{dataIndex: 'WH_STOCK19',	width: 106},
			{dataIndex: 'WH_NAME20',	width: 66, hidden: true},
			{dataIndex: 'WH_STOCK20',	width: 106}
		] 
    });   
    

	
	
    Unilite.Main( {
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			items:[
				masterGrid1, masterGrid2, panelResult
			]	
		},
			panelSearch
		],
		id  : 'biv600skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			masterGrid1.getStore().loadStoreRecords();
			masterGrid2.getStore().loadStoreRecords();
			var viewLocked = masterGrid1.lockedGrid.getView();
			var viewNormal = masterGrid1.normalGrid.getView();
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
