<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp100kr"  >
	<t:ExtComboStore comboType="BOR120"  /> 					  <!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"  /> 		  <!-- 진행상태 -->
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
	Unilite.defineModel('pmp100krModel', {
	    fields: [
	    	{name: 'GUBUN'        			, text: '<t:message code="system.label.product.selection" default="선택"/>'			, type: 'string'},
	    	{name: 'DIV_CODE'				, text: '<t:message code="system.label.product.mfgplace" default="제조처"/>'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'			, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			, type: 'string'},
			{name: 'WK_PLAN_NUM'			, text: '<t:message code="system.label.product.productionplanno" default="생산계획번호"/>'		, type: 'string'},
			{name: 'ITEM_CODE' 				, text: '<t:message code="system.label.product.item" default="품목"/>'			, type: 'string'},
			{name: 'ITEM_NAME' 				, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC' 					, text: '<t:message code="system.label.product.spec" default="규격"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.product.unit" default="단위"/>'			, type: 'string'},
			{name: 'WK_PLAN_Q' 				, text: '<t:message code="system.label.product.planqty" default="계획량"/>'			, type: 'string'},
			{name: 'PRODUCT_LDTIME'			, text: '<t:message code="system.label.product.mfglt" default="제조 L/T"/>'		, type: 'string'},
			{name: 'PRODT_START_DATE'		, text:'<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'		, type: 'string'},
			{name: 'PRODT_PLAN_DATE'		, text: '<t:message code="system.label.product.planfinisheddate" default="계획완료일"/>'		, type: 'string'},
			{name: 'ORDER_NUM'	 			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'			, type: 'string'},
			{name: 'ORDER_DATE' 			, text: '<t:message code="system.label.product.sodate" default="수주일"/>'			, type: 'string'},
			{name: 'ORDER_Q' 				, text: '<t:message code="system.label.product.soqty" default="수주량"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'	 		, text: '<t:message code="system.label.product.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'DVRY_DATE' 				, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'			, type: 'string'},
			{name: 'PROJECT_NO' 			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'PJT_CODE' 				, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'}
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('pmp100krMasterStore1',{
			model: 'pmp100krModel',
			uniOpt: {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable: false,			// 삭제 가능 여부
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'pmp100krService.selectList'
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items: [{
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	        	fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
	        	name: 'WORK_SHOP_CODE',
	        	xtype: 'uniCombobox',
	        	store: Ext.data.StoreManager.lookup('wsList')
	        },{
	        	fieldLabel: '<t:message code="system.label.product.plandate" default="계획일"/>',
	            xtype: 'uniDateRangefield',
	            startFieldName: 'OUTSTOCK_REQ_DATE_FR',
				endFieldName: 'OUTSTOCK_REQ_DATE_TO',
	            width: 315,
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	        	allowBlank:false
			},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					textFieldWidth:170,
					validateBlank:false,
					valueFieldName: 'ITEM_CODE',
	        		textFieldName:'ITEM_NAME'
			})]
		}]
	});

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid1 = Unilite.createGrid('pmp100krGrid1', {
        region: 'center' ,
        layout : 'fit',
        store : directMasterStore1,
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'<t:message code="system.label.product.inquiry" default="조회"/>',
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
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} ],
        columns:  [
        	{dataIndex: 'GUBUN'        		      	, width:0  ,hidden: true},
	        {dataIndex: 'DIV_CODE'			      	, width:0  ,hidden: true},
	        {dataIndex: 'WORK_SHOP_CODE'		    , width:100},
	        {dataIndex: 'WK_PLAN_NUM'		      	, width:100,hidden: true},
	        {dataIndex: 'ITEM_CODE' 			    , width:100},
	        {dataIndex: 'ITEM_NAME' 			    , width:126},
	        {dataIndex: 'SPEC' 				      	, width:120},
	        {dataIndex: 'STOCK_UNIT'			    , width:40},
	        {dataIndex: 'WK_PLAN_Q' 			    , width:73},
	        {dataIndex: 'PRODUCT_LDTIME'		    , width:53},
	        {dataIndex: 'PRODT_START_DATE'      	, width:73},
	        {dataIndex: 'PRODT_PLAN_DATE'	      	, width:73},
	        {dataIndex: 'ORDER_NUM'	 		      	, width:93},
	        {dataIndex: 'ORDER_DATE' 		      	, width:73},
	        {dataIndex: 'ORDER_Q' 			      	, width:73},
	        {dataIndex: 'CUSTOM_CODE'	       		, width:100},
	        {dataIndex: 'DVRY_DATE' 			    , width:73 ,hidden: true},
	        {dataIndex: 'PROJECT_NO' 		      	, width:80 ,hidden: true},
	        {dataIndex: 'PJT_CODE' 			      	, width:80 ,hidden: true}
         ]
    });		// End of  var masterGrid1 = Unilite.createGrid('pmp100krGrid1', {


    Unilite.Main( {
		border: false,
		borderItems:[
		 		 masterGrid1
				,panelSearch
		],
		id : 'pmp100krApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},

		onQueryButtonDown : function()	{
			masterGrid1.getStore().loadStoreRecords();
			/*var viewLocked = masterGrid1.lockedGrid.getView();
			var viewNormal = masterGrid1.normalGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
	      	viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
	      	viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
	      	viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
	      	viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);*/
		},


		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});		// End of Unilite.Main( {
};
</script>
