<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa900skrv"  >
		<t:ExtComboStore comboType= "BOR120"  /> 		 <!-- 사업장 --> 
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
	Unilite.defineModel('bsa900skrvModel', {
	    fields: [  	  
	    	{name: 'DIV_CODE'						,text: '<t:message code="system.label.base.division" default="사업장"/>'				,type: 'string'},
		    {name: 'QRY_DATE'						,text: '일자'				,type: 'string'},
		    {name: 'SALES_FORECAST'					,text: '판매계획'				,type: 'string'},
		    {name: 'SALES_ORDER'					,text: '수주오더'				,type: 'string'},
		    {name: 'ISSUE_REQ'						,text: '출고지시 '				,type: 'string'},
		    {name: 'GOODS_ISSUE'					,text: '출고'				,type: 'string'},
		    {name: 'INVOICE_CNT'					,text: '계산서'				,type: 'string'},
		    
		    {name: 'PURCHASE_ORDER'					,text: '발주'				,type: 'string'},
		    {name: 'GOODS_RECEIPT'					,text: '입고'				,type: 'string'},
		    
		    {name: 'SUBCON_PURCHASE'				,text: '외주발주'				,type: 'string'},
		    {name: 'SUBCON_ISSUE'					,text: '외주 자재출고'				,type: 'string'},
		    {name: 'SUBCON_RECEIPT'					,text: '외주입고'				,type: 'string'},
		    
		    {name: 'PRODT_SCHEDULE'					,text: '생산계획'				,type: 'string'},
		    {name: 'MATERIAL_PLAN'					,text: 'MRP'				,type: 'string'},
		    {name: 'PRODT_ORDER'					,text: '작업지시'				,type: 'string'},
		    {name: 'PRODT_RESULT'					,text: '생산실적'				,type: 'string'},
		    {name: 'PRODT_ISSUE'					,text: '자재출고'				,type: 'string'},
		    {name: 'PRODT_RECEIPT'					,text: '생산입고'				,type: 'string'},
		    
		    {name: 'TRANSFER_ISSUE'					,text: '이동출고'				,type: 'string'},
		    {name: 'TRANSFER_RECEIPT'				,text: '이동입고'				,type: 'string'},
		    
		    {name: 'RECEIPT_IN'						,text: '수입접수'				,type: 'string'},
		    {name: 'RECEIPT_INSPECT'				,text: '수입검사'				,type: 'string'},
		    {name: 'PRODT_IN'						,text: '출하접수'				,type: 'string'},
		    {name: 'PRODT_INSPECT'					,text: '출하검사'				,type: 'string'},
		  
		    {name: 'TRADE_EXPORT_OFFER'	 			,text: '수출OFFER'			,type: 'string'},
		    {name: 'TRADE_EXPORT_ISSUE'	 			,text: '수출출고'				,type: 'string'},
		    {name: 'TRADE_EXPORT_SHIPMENT'  		,text: '수출선적'				,type: 'string'},
		    {name: 'TRADE_IMPORT_OFFER'	 			,text: '수입OFFER'			,type: 'string'},
		    {name: 'TRADE_IMPORT_SHIPMENT'  		,text: '수입선적'				,type: 'string'},
		    {name: 'TRADE_IMPORT_RECEIPT'   		,text: '수입접수'				,type: 'string'},
		    {name: 'TRADE_IMPORT_INSPECTION'		,text: '수입검사'				,type: 'string'},
		    {name: 'TRADE_IMPORT_ENTER'	 			,text: '수입입고'				,type: 'string'}
		]
	}); //End of Unilite.defineModel('bsa900skrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('bsa900skrvMasterStore1',{
		model: 'bsa900skrvModel',
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
            	read: 'bsa900skrvService.selectList1'                	
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
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false
			},{
	        	fieldLabel: '조회기간', 
				xtype: 'uniDateRangefield', 
				startFieldName: 'ORDER_DATE_FR',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				allowBlank:false
		    }]
		}]
    }); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('bsa900skrvGrid1', {
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
			{dataIndex: 'DIV_CODE'					, width: 66   , hidden: true},
			{text:'영업' , 
        		columns: [
					{dataIndex: 'QRY_DATE'					, width: 120},
					{dataIndex: 'SALES_FORECAST'			, width: 66},
					{dataIndex: 'SALES_ORDER'				, width: 66}, 
					{dataIndex: 'ISSUE_REQ'					, width: 66},
					{dataIndex: 'GOODS_ISSUE'				, width: 66}, 
					{dataIndex: 'INVOICE_CNT'				, width: 66}
			]},
			{text:'구매' , 
        		columns: [
					{dataIndex: 'PURCHASE_ORDER'			, width: 66},
					{dataIndex: 'GOODS_RECEIPT'				, width: 66}
			]},
			{text:'외주' , 
        		columns: [
					{dataIndex: 'SUBCON_PURCHASE'			, width: 66}, 
					{dataIndex: 'SUBCON_ISSUE'				, width: 93},
					{dataIndex: 'SUBCON_RECEIPT'			, width: 86}
			]},
			{text:'생산' , 
        		columns: [
					{dataIndex: 'PRODT_SCHEDULE'			, width: 66},
					{dataIndex: 'MATERIAL_PLAN'				, width: 66},
					{dataIndex: 'PRODT_ORDER'				, width: 66}, 
					{dataIndex: 'PRODT_RESULT'				, width: 66},
					{dataIndex: 'PRODT_ISSUE'				, width: 66}, 
					{dataIndex: 'PRODT_RECEIPT'				, width: 66}
			]},
			{text:'재고이동' , 
        		columns: [
					{dataIndex: 'TRANSFER_ISSUE'			, width: 66},
					{dataIndex: 'TRANSFER_RECEIPT'			, width: 66} 
			]},
			{text:'품질' , 
        		columns: [
					{dataIndex: 'RECEIPT_IN'				, width: 66}, 
					{dataIndex: 'RECEIPT_INSPECT'			, width: 66},
					{dataIndex: 'PRODT_IN'					, width: 66}, 
					{dataIndex: 'PRODT_INSPECT'				, width: 66}
			]},
			{text:'무역' , 
        		columns: [
					{dataIndex: 'TRADE_EXPORT_OFFER'	 	, width: 83},
					{dataIndex: 'TRADE_EXPORT_ISSUE'	 	, width: 66}, 
					{dataIndex: 'TRADE_EXPORT_SHIPMENT'  	, width: 66},
					{dataIndex: 'TRADE_IMPORT_OFFER'	 	, width: 83}, 
					{dataIndex: 'TRADE_IMPORT_SHIPMENT'  	, width: 66},
					{dataIndex: 'TRADE_IMPORT_RECEIPT'   	, width: 66}, 
					{dataIndex: 'TRADE_IMPORT_INSPECTION'	, width: 66},
					{dataIndex: 'TRADE_IMPORT_ENTER'	 	, width: 66}
			]}
		] 
    });	//End of   var masterGrid1 = Unilite.createGrid('bsa900skrvGrid1', {

    Unilite.Main( {
		border: false,
		borderItems:[ 
		 		 masterGrid1
				,panelSearch
		], 
		id: 'bsa900skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function() {		
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'bsa900skrvGrid1'){				
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
