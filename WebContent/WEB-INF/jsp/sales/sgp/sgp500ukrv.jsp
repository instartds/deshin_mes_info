<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sgp500ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sgp500ukrv"/> 			<!-- 사업장 -->  
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /> <!-- 대분류 -->
   	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /> <!-- 중분류 -->
   	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /> <!-- 소분류 -->
   	<t:ExtComboStore comboType="AU" comboCode="S010"  /> <!-- 담당자 -->  
   	<t:ExtComboStore comboType="AU" comboCode="B010"  /> <!-- 반영구분 -->  
   	<t:ExtComboStore comboType="AU" comboCode="B055"  /> <!-- 거래처분류 -->  
   	<t:ExtComboStore comboType="AU" comboCode="B013"  /> <!-- 기준단위 -->  
   	<t:ExtComboStore comboType="AU" comboCode="S070"  /> <!-- 프로모션유형 -->  
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
	Unilite.defineModel('sgp500ukrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string'},
	    	{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string'},
	    	{name: 'PLAN_DATE'			, text: '계획년월'			, type: 'uniDate'},
			{name: 'PROMO_NUM'			, text: '프로모션번호'  	, type: 'string'},
			{name: 'ITEM_CODE'     		, text: '<t:message code="system.label.sales.item" default="품목"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '품명명'			, type: 'string'},
			{name: 'CUSTOM_CODE'   		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'BASIS_P'			, text: '<t:message code="system.label.sales.basisprice" default="기준단가"/>'			, type: 'uniQty'},
			{name: 'DC_RATE'      		, text: '<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'			, type: 'uniQty'},
			{name: 'DISCOUNT_P'			, text: '할인가'			, type: 'uniUnitPrice'},
			{name: 'BASIS_Q'			, text: '계획수량'			, type: 'uniQty'},
			{name: 'EXTRA_Q'			, text: '주문수량'			, type: 'uniQty'},
			{name: 'PLAN_Q'				, text: '할증수량'			, type: 'uniQty'},
			{name: 'ORDER_UNIT'			, text: '주문단위'			, type: 'string'},
			{name: 'GUBUN'				, text: '<t:message code="system.label.sales.classfication" default="구분"/>'			, type: 'string'}	
		] 
	});		//End of Unilite.defineModel('sgp500ukrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('sgp500ukrvMasterStore1',{
			model: 'sgp500ukrvModel',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'sgp500ukrvService.selectList1'                	
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
	});		//End of var directMasterStore1 = Unilite.createStore('sgp500ukrvMasterStore1',{
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
	        	fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
	        	name:'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120',
	        	allowBlank:false
	        },{
				fieldLabel: '계획년월'	,
				name: '',
				xtype: 'uniDatefield',
				allowBlank: false
			},
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '프로모션번호', 
					validateBlank:false
			}),{
				fieldLabel: '프로모션명',
				name: '',
				xtype: 'uniTextfield'
			},
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>', 
					validateBlank:false
			}),
				Unilite.popup('ITEM',{ 
					fieldLabel: '공정코드', 
					validateBlank:false
			}),{ 
				xtype: 'container',
	            layout: {type: 'hbox', align:'stretch' },
	            width:325,
	            defaultType: 'uniTextfield',
	            items: [{
	            	fieldLabel: '<t:message code="system.label.sales.workorderno" default="작업지시번호"/>', 
	            	suffixTpl: '&nbsp;~&nbsp;',
	            	name: 'INOUT_NUM_FR', 
	            	width:218
	            },{
		            hideLabel : true, 
		            name: 'INOUT_NUM_TO', 
		            width:107
	            }
			]}]
		}]
    });		//End of var panelSearch = Unilite.createSearchForm('searchForm',{  
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('sgp500ukrvGrid1', {
        layout : 'fit',
        region : 'center',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'<t:message code="system.label.sales.detailsview" default="상세보기"/>',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
    	store: directMasterStore1,
    	features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	  	showSummaryRow: false} 
    	],
        columns:  [	
        	{dataIndex: 'COMP_CODE'			, width: 100, hidden: true}, 	  			
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true}, 	  			
			{dataIndex: 'PLAN_DATE'			, width: 66 , hidden: true}, 	  			
			{dataIndex: 'PROMO_NUM'			, width: 100, hidden: true}, 	  			
			{dataIndex: 'ITEM_CODE'     	, width: 86}, 	  			
			{dataIndex: 'ITEM_NAME'			, width: 200}, 	  			
			{dataIndex: 'CUSTOM_CODE'   	, width: 66}, 	  			
			{dataIndex: 'CUSTOM_NAME'		, width: 153}, 	  			
			{dataIndex: 'BASIS_P'			, width: 80}, 	  			
			{dataIndex: 'DC_RATE'      		, width: 80}, 	  			
			{dataIndex: 'DISCOUNT_P'		, width: 80},	  			
			{dataIndex: 'BASIS_Q'			, width: 80}, 	  			
			{dataIndex: 'EXTRA_Q'			, width: 80}, 	  			
			{dataIndex: 'PLAN_Q'			, width: 80}, 	  			
			{dataIndex: 'ORDER_UNIT'		, width: 80}, 	  			
			{dataIndex: 'GUBUN'				, width: 53 , hidden: true}  			
          ]                                          
    });		//End of  var masterGrid1 = Unilite.createGrid('sgp500ukrvGrid1', {
    
    Unilite.Main({
		border: false,
		borderItems:[ 
		 		 masterGrid1
				,panelSearch
		],
		id : 'sgp500ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'sgp500ukrvGrid1'){				
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
	});		//End of  Unilite.Main({
};
</script>
