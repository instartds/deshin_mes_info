<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr590skrv"  >
		<t:ExtComboStore comboType= "BOR120"  /> 		 <!-- 사업장 -->
		<t:ExtComboStore comboType="AU" comboCode="B018" /> <!-- 대체여부 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('bpr590skrvModel', {
	    fields: [  	  
	    	{name: 'ITEM_CODE'			,text: '자 품목코드'			,type: 'string'},
		    {name: 'ITEM_NAME' 			,text: '자 품목명'				,type: 'string'},
		    {name: 'SPEC'      			,text: '<t:message code="system.label.base.spec" default="규격"/>'					,type: 'string'},
		    {name: 'LOT_NO'    			,text: 'Lot No.'			,type: 'string'},
		    {name: 'STOCK_UNIT'			,text: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>'				,type: 'string'},
		    {name: 'STOCK_Q'   			,text: '재고수량'				,type: 'uniQty'}
		]
	}); //End of Unilite.defineModel('bpr590skrvModel', {
	
	Unilite.defineModel('bpr590skrvModel2', {
	    fields: [  	  
	    	{name: 'PROD_ITEM_CODE'		,text: '모 품목코드'			,type: 'string'},
		    {name: 'ITEM_NAME'     		,text: '모 품목명'				,type: 'string'},
		    {name: 'SPEC'          		,text: '<t:message code="system.label.base.spec" default="규격"/>'					,type: 'string'},
		    {name: 'EXCHG_YN'      		,text: '대체여부'				,type: 'string'},
		    {name: 'UNIT_Q'	    		,text: '원 단위 량'				,type: 'uniQty'},
		    {name: 'STOCK_UNIT'    		,text: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>'				,type: 'string'},
		    {name: 'POB_UNIT_Q'    		,text: '생상가능수량'			,type: 'uniQty'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('bpr590skrvMasterStore1',{
		model: 'bpr590skrvModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {			
            	read: 'bpr590skrvService.selectList1'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ITEM_NAME'
			
	});
	
	var directMasterStore2 = Unilite.createStore('bpr590skrvMasterStore2',{
		model: 'bpr590skrvModel2',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {			
            	read: 'bpr590skrvService.selectList1'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ITEM_NAME'
			
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		        fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
		        name:'', 
		        xtype: 'uniCombobox', 
		        comboType:'BOR120',
		 		allowBlank:false
		    },
			    Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
					textFieldWidth:170,
					validateBlank:false
			})]
		}]
    }); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('bpr590skrvGrid1', {
    	layout : 'fit',
    	region:'center',
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
        columns: [        			 
			{dataIndex: 'ITEM_CODE'					, width: 180}, 
			{dataIndex: 'ITEM_NAME' 				, width: 200},
			{dataIndex: 'SPEC'      				, width: 166}, 
			{dataIndex: 'LOT_NO'    				, width: 166},
			{dataIndex: 'STOCK_UNIT'				, width: 100}, 
			{dataIndex: 'STOCK_Q'   				, width: 133}
		] 
    });	//End of   var masterGrid1 = Unilite.createGrid('bpr590skrvGrid1', {
    
    var masterGrid2 = Unilite.createGrid('bpr590skrvGrid2', {
    	layout : 'fit',
    	region:'south',
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
        columns: [        			 
			{dataIndex: 'PROD_ITEM_CODE'				, width: 180}, 
			{dataIndex: 'ITEM_NAME'     				, width: 200},
			{dataIndex: 'SPEC'          				, width: 166}, 
			{dataIndex: 'EXCHG_YN'      				, width: 80},
			{dataIndex: 'UNIT_Q'	    				, width: 100},
			{dataIndex: 'STOCK_UNIT'    				, width: 100}, 
			{dataIndex: 'POB_UNIT_Q'    				, width: 100}
		] 
    });

    Unilite.Main( {
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			items:[
				masterGrid1, masterGrid2
			]	
		},
			panelSearch
		],
		id: 'bpr590skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function() {		
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'bpr590skrvGrid1'){				
				directMasterStore1.loadStoreRecords();				
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
	}); //End of Unilite.Main( {
};

</script>
