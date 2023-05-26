<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms201ukrv"  >
	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="Q031" /> <!-- 조회구분(접수구분) -->
	<t:ExtComboStore comboType="AU" comboCode="Q033" /> <!-- 최종판정 -->		
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
	
	
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

	Unilite.defineModel('Mms201ukrvModel1', {
		fields: [
			{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: ''			, text: ''		, type: ''},
	    	{name: '' 			, text: ''		, type: ''}
		]
	});//Unilite.defineModel('Mms201ukrvModel1', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mms201ukrvMasterStore1', {
		model: 'Mms201ukrvModel1',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'mms201ukrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'CUSTOM_NAME'
			
	});//End of var directMasterStore1 = Unilite.createStore('mms201ukrvMasterStore1', {

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('searchForm', {
		layout: {type: 'vbox', align: 'stretch'},
		items: [{
			xtype: 'container',
			layout: {type: 'uniTable', columns: 3},
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false
			},{
				fieldLabel: '<t:message code="system.label.purchase.inspectype" default="검사유형"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'Q005' 
			},{
	        fieldLabel: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
	        xtype: 'uniDatefield',
	       	value: UniDate.get('today'),
	     	width : 200
			},{
				fieldLabel: '<t:message code="system.label.purchase.inspeccharge" default="검사담당"/>', 
				name: '', 
				xtype: 'uniCombobox', 
				comboType: 'Q005' 
			},{
				fieldLabel: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>',
				xtype: 'uniTextfield'				
			},{
				fieldLabel: '<t:message code="system.label.purchase.passyn" default="합격여부"/>', 
				name: '', 
				xtype: 'uniCombobox',  
				comboCode: 'M414'
			},
			Unilite.popup('CUST',{ 
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
				textFieldWidth: 170,
				validateBlank: false, 
				allowBlank: false,
				extParam: {'CUSTOM_TYPE':'3'}
			}),{
	        	fieldLabel: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'ORDER_DATE_FR',
	        	endFieldName: 'ORDER_DATE_TO',
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),
	        	width:315
			},{
				fieldLabel: '<t:message code="system.label.purchase.poclass" default="발주유형"/>', 
				name: '', 
				xtype: 'uniCombobox',  
				comboCode: 'M001'
			},
			Unilite.popup('DIV_PUMOK',{ 
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>', 
				textFieldWidth: 170,
				validateBlank: false, 
				extParam: {'CUSTOM_TYPE':'3'}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>',
				xtype: 'uniTextfield'				
			}]	            			 
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('mms201ukrvGrid1', {
    	// for tab    	
		layout: 'fit',
		uniOpt: {
			expandLastColumn: false
		},
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'DIV_CODE'				, width: 100, hidden: true}, 				
			{dataIndex: 'CUSTOM_CODE'			, width: 80},
			{dataIndex: 'CUSTOM_NAME'			, width: 80},
			{dataIndex: 'ORDER_TYPE'			, width: 80},
			{dataIndex: 'ORDER_DATE'			, width: 100},
			{dataIndex: 'ITEM_CODE'				, width: 73},
			{dataIndex: 'ITEM_NAME'				, width: 180},
			{dataIndex: 'SPEC'					, width: 200},
			{dataIndex: 'DVRY_DATE'				, width: 100},
			{dataIndex: 'ORDER_UNIT'			, width: 53},
			{dataIndex: 'ORDER_Q'				, width: 120},
			{dataIndex: 'RECEIPT_DATE'			, width: 100},
			{dataIndex: 'RECEIPT_PRSN'			, width: 66},
			{dataIndex: 'RECEIPT_Q'				, width: 120},
			{dataIndex: 'NOTRECEIPT_Q'			, width: 120},
			{dataIndex: 'ORDER_NUM'				, width: 133},
			{dataIndex: 'ORDER_SEQ'				, width: 66},
			{dataIndex: 'RECEIPT_NUM'			, width: 133},
			{dataIndex: 'RECEIPT_SEQ'			, width: 66},
			{dataIndex: 'ORDER_REMARK'			, width: 133},
			{dataIndex: 'ORDER_PROJECT_NO'		, width: 133},
			{dataIndex: 'RECEIPT_REMARK'		, width: 133},
			{dataIndex: 'RECEIPT_PROJECT_NO'	, width: 133}
		] 
	});//End of var masterGrid = Unilite.createGrid('mms201ukrvGrid1', {   

	Unilite.Main({
		items: [panelSearch, masterGrid],
		id: 'mms201ukrvApp',
		fnInitBinding: function(){
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);
		},
		onQueryButtonDown: function(){			
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ",viewLocked);
			console.log("viewNormal: ",viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};//End of Unilite.Main({

</script>
