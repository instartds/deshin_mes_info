<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="srq160ukrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="srq160ukrv" /> 		   <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A" />   <!-- 창고 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/> <!--재고단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A" />   <!-- 창고Cell -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/> <!--담당자 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/> <!--영업담당 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >


function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('srq160ukrvModel1', {
		fields: [
			{name: 'INOUT_SEQ'				, text: '<t:message code="system.label.sales.seq" default="순번"/>'				, type: 'string'},
			{name: 'INOUT_NUM'				, text: 'Picking No.'		, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.sales.item" default="품목"/>' 			, type: 'string'},
			{name: 'ITEM_NAME'		 		, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.sales.spec" default="규격"/>' 				, type: 'string'},
			{name: 'STOCK_UNIT'	 			, text: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'   			, type: 'string', displayField: 'value'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.sales.warehouse" default="창고"/>' 				, type: 'string'},
			{name: 'WH_CELL_CODE'	 		, text: 'Cell' 				, type: 'string'},
			{name: 'LOT_NO'					, text: 'NOT NO' 			, type: 'string'},
			{name: 'QTY'					, text: 'Picking지시량' 		, type: 'uniQty'},
			{name: 'BOX_QTY'				, text: 'BOX수량' 			, type: 'uniQty'},
			{name: 'EA_QTY'					, text: 'EA수량' 				, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q'			, text: '실제수량' 			, type: 'uniQty'},
			{name: 'STOCK_Q'				, text: '<t:message code="system.label.sales.inventoryqty2" default="재고수량"/>' 			, type: 'uniQty'}
		]                           
	});		//End of Unilite.defineModel('Ppl120skrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('srq160ukrvMasterStore1',{
		model: 'srq160ukrvModel1',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
    		deletable:false,			// 삭제 가능 여부 
        	useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
 		proxy: {
			type: 'direct',
			api: {			
				read: 'srq160ukrvService.selectList1'                	
				 }
            },
            loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();			
					console.log( param );
					this.load({
						params : param
					});
				},
				groupField: 'ITEM_NAME'
	});		//End of var directMasterStore1 = Unilite.createStore('ppl120skrvMasterStore1',{
	
 	var now = new Date();
 	var month = now.getMonth()+1
 	var day = now.getDate(); 
 		month = month < 10? '0' + month : month
		day = day < 10? '0' + day : day 
 	var today = now.getFullYear() + '/' + month + '/' + day;
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
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
		 		fieldLabel: 'Picking 처리일',
		 		id:'frToDate',
		 		xtype: 'uniDatefield',
		 		name: 'FR_DATE',
		 		value: today,
		 		allowBlank:false
			}]
		}]
	});		//End of var panelSearch = Unilite.createSearchForm('searchForm', {    
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid1 = Unilite.createGrid('srq160ukrvGrid1', {
        region: 'center' ,
        layout : 'fit',
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
        		{dataIndex:'INOUT_SEQ'		         , width: 40},
        		{dataIndex:'INOUT_NUM'		         , width: 100},
        		{dataIndex:'ITEM_CODE'		         , width: 100},
        		{dataIndex:'ITEM_NAME'		         , width: 166},
        		{dataIndex:'SPEC'			         , width: 100},
        		{dataIndex:'STOCK_UNIT'	 	         , width: 66},
        		{dataIndex:'WH_CODE'		         , width: 100},
        		{dataIndex:'WH_CELL_CODE'	         , width: 113},
        		{dataIndex:'LOT_NO'			         , width: 80},
        		{dataIndex:'QTY'			         , width: 100},
        		{dataIndex:'BOX_QTY'		         , width: 86 , hidden: true},
        		{dataIndex:'EA_QTY'			         , width: 86 , hidden: true},
        		{dataIndex:'ORDER_UNIT_Q'	         , width: 86},
        		{dataIndex:'STOCK_Q'		         , width: 86}
        		
		]                                    
    });		//End of var masterGrid1 = Unilite.createGrid('srq160ukrvGrid1', {

    Unilite.Main({
		border: false,
		borderItems:[ 
		 		 masterGrid1
				,panelSearch
		], 
		id : 'srq160ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function() {		
			var activeTabId = tab.getActiveTab().getId();			
			if( activeTabId == 'srq160ukrvGrid1'){				
				directMasterStore1.loadStoreRecords();				
			}
			var viewLocked = tab.getActiveTab().lockedGrid.getView();
			var viewNormal = tab.getActiveTab().normalGrid.getView();
			
			console.log("viewLocked : ", viewLocked);
			console.log("viewNormal : ", viewNormal);
			
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden()){
				as.show();
			}else {
				as.hide()
			}
		}
	});		// End of Unilite.Main

};
</script>
