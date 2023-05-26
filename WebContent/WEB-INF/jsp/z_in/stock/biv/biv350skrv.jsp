<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv350skrv"  >
	<t:ExtComboStore comboType="BOR120" comboCode="B001"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 				<!-- 계정구분 -->  
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>		<!--창고-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */

	    			
	Unilite.defineModel('Biv350skrvModel', {
	    fields: [  	
	    	{name: 'ITEM_ACCOUNT',	text:'계정',		type:'string'},
	    	{name: 'ACCOUNT1',		text:'계정코드',	type:'string'},
	    	{name: 'DIV_CODE',		text:'<t:message code="system.label.inventory.division" default="사업장"/>',		type:'string'},
	    	{name: 'WH_CODE',		text:'<t:message code="system.label.inventory.warehouse" default="창고"/>',		type:'string'},
	    	{name: 'ITEM_CODE',		text:'<t:message code="system.label.inventory.item" default="품목"/>',	type:'string'},
	    	{name: 'ITEM_NAME',		text:'품명',		type:'string'},
	    	{name: 'SPEC',			text:'<t:message code="system.label.inventory.spec" default="규격"/>',		type:'string'},
	    	{name: 'STOCK_UNIT',	text:'<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',	type:'string'},
	    	{name: 'BASIS_P',		text:'단가',		type:'uniUnitPrice'},
	    	{name: 'STOCK_Q',		text:'재고량',		type:'uniQty'},
	    	{name: 'STOCK_O',		text:'재고금액',	type:'uniPrice'},
	    	{name: 'START_DATE',	text:'사용시작일',	type:'uniDate'},
	    	{name: 'STOP_DATE',		text:'사용중단일',	type:'uniDate'}
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
	var directMasterStore1 = Unilite.createStore('biv350skrvMasterStore1',{
			model: 'Biv350skrvModel',
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
                	   read: 'biv350skrvService.selectList1'                	
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
	
	var directMasterStore2 = Unilite.createStore('biv350skrvMasterStore2',{
			model: 'Biv350skrvModel',
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
                	   read: 'biv350skrvService.selectList1'                	
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
	
	
	var directMasterStore3 = Unilite.createStore('biv350skrvMasterStore3',{
			model: 'Biv350skrvModel',
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
                	   read: 'biv350skrvService.selectList1'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			groupField: 'DVRY_DATE1'
			
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
            		name:'DIV_CODE',
            		xtype: 'uniCombobox',
            		comboType:'BOR120',
            		allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
            	},{
            		fieldLabel: '계정',
            		name: 'ACCOUNT',
            		xtype: 'uniCombobox',
            		comboType: 'AU',
            		comboCode: 'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ACCOUNT', newValue);
						}
					}
            	},{
            		fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
            		name:'WH_CODE',
            		xtype: 'uniCombobox',
            		store: Ext.data.StoreManager.lookup('whList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('WH_CODE', newValue);
						}
					}
            	}]
		},{
			title: '추가정보', 	
			itemId: 'search_panel2',
	       	layout: {type: 'uniTable', columns: 1},
	       	defaultType: 'uniTextfield',
			    items: [{ 
            		fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
            		name: 'TXTLV_L1', 
            		xtype: 'uniCombobox',  
            		store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
            		child: 'TXTLV_L2'
            	},{
            		fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
            		name: 'TXTLV_L2', 
            		xtype: 'uniCombobox',  
            		store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
            		child: 'TXTLV_L3'
            	},{ 
            		fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
            		name: 'TXTLV_L3', 
            		xtype: 'uniCombobox',  
            		store: Ext.data.StoreManager.lookup('itemLeve3Store')
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
            		name:'DIV_CODE',
            		xtype: 'uniCombobox',
            		comboType:'BOR120',
            		allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
            	},{
            		fieldLabel: '계정',
            		name: 'ACCOUNT',
            		xtype: 'uniCombobox',
            		comboType: 'AU',
            		comboCode: 'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ACCOUNT', newValue);
						}
					}
            	},{
            		fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
            		name:'WH_CODE',
            		xtype: 'uniCombobox',
            		store: Ext.data.StoreManager.lookup('whList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('WH_CODE', newValue);
						}
					}
            	}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('biv350skrvGrid1', {
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
        columns: [  
        	{dataIndex:'ITEM_ACCOUNT',	width:86}, 				
			{dataIndex:'ACCOUNT1',		width:93, hidden:true}, 				
			{dataIndex:'DIV_CODE',		width:80, hidden:true},  				
			{dataIndex:'WH_CODE',		width:80},  				
			{dataIndex:'ITEM_CODE',		width:100},  				
			{dataIndex:'ITEM_NAME',		width:173},  				
			{dataIndex:'SPEC',			width:173},  				
			{dataIndex:'STOCK_UNIT',	width:66},  				
			{dataIndex:'BASIS_P',		width:100},  				
			{dataIndex:'STOCK_Q',		width:100},  				
			{dataIndex:'STOCK_O',		width:133},  				
			{dataIndex:'START_DATE',	width:86},  				
			{dataIndex:'STOP_DATE', 	width:86}  							
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
		id  : 'biv350skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'biv350skrvGrid1'){				
				directMasterStore1.loadStoreRecords();				
			}
			else if(activeTabId == 'biv350skrvGrid2'){
				directMasterStore2.loadStoreRecords();
								
			}else if(activeTabId == 'biv350skrvGrid3'){
				directMasterStore3.loadStoreRecords();				
			}
			
			var viewLocked = tab.getActiveTab().lockedGrid.getView();
			var viewNormal = tab.getActiveTab().normalGrid.getView();
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
