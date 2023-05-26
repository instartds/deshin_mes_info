<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bpr910skrv_jw">
	<t:ExtComboStore comboType="BOR120" />							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />				<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />				<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />				<!-- 계정구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B131" />				<!-- 예/아니오 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_bpr910skrv_jwService.selectList'
		}
	});
	
	
	Unilite.defineModel('s_bpr910skrv_jwModel', {
		fields: [
			{name: 'COMP_CODE'          , text: '<t:message code="system.label.base.compcode" default="법인코드"/>'	, type: 'string'},
			{name: 'DIV_CODE'           , text: '<t:message code="system.label.base.divisioncode" default="사업장코드"/>'	, type: 'string'	, comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'        , text: '<t:message code="system.label.common.client" default="고객"/>'	, type: 'string'},
			{name: 'CUSTOM_NAME'        , text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'	, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.base.item" default="품목"/>'				, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.base.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'MODEL'              , text: 'MODEL'	, type: 'string'	, allowBlank: false},
			{name: 'PART_NAME'          , text: 'PART NAME'	, type: 'string'},
			{name: 'REV_NO'             , text: 'REV No'	, type: 'string'},
			{name: 'CUSTOM_REV'         , text: '<t:message code="system.label.base.customrev" default="고객REV"/>'	, type: 'string'},
			{name: 'INSIDE_REV'         , text: '<t:message code="system.label.base.insiderev" default="내부REV"/>'	, type: 'string'},
			{name: 'RECEIPT_DATE'       , text: '<t:message code="system.label.common.receiptdate" default="접수일"/>'	, type: 'uniDate'},
			{name: 'DEVELOPMENT_LEVEL'  , text: '<t:message code="system.label.base.developmentlevel" default="개발단계"/>'	, type: 'string', comboType:'AU', comboCode:'ZN03'},
			{name: 'RECEIPT_TYPE'       , text: '<t:message code="system.label.common.accepttype" default="접수구분"/>'	, type: 'string', comboType:'AU', comboCode:'ZN04'},
			{name: 'RECEIPT_DETAIL'     , text: '<t:message code="system.label.base.receiptdetail" default="접수내용"/>'	, type: 'string'},
			{name: 'WKORD_NUM'          , text: '<t:message code="system.label.base.workorderno" default="작업지시번호"/>'	, type: 'string'},
			{name: 'WORK_DATE'          , text: '<t:message code="system.label.product.workday" default="작업일"/>'	, type: 'uniDate'},
			{name: 'WORK_Q'             , text: '<t:message code="system.label.product.workqty" default="작업량"/>'	, type: 'uniQty'},
			{name: 'WOODEN_PATTEN'      , text: '<t:message code="system.label.base.woodenpatten" default="목형번호"/>'	, type: 'string'},
			{name: 'WOODEN_ORDER_DATE'  , text: '<t:message code="system.label.base.woodenorderdate" default="목형발주일"/>'	, type: 'uniDate'},
			{name: 'WOODEN_UNIT_PRICE'  , text: '<t:message code="system.label.base.woodenprice" default="목형단가"/>'	, type: 'int'},
			{name: 'WOODEN_ORDER_YN'    , text: '<t:message code="system.label.base.woodenorderyn" default="목형발주여부"/>'	, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'SAMPLE_DATE'        , text: '<t:message code="system.label.base.sampledate" default="샘플발송일"/>'	, type: 'uniDate'},
			{name: 'SAMPLE_RESULT'      , text: '<t:message code="system.label.base.sampleresult" default="샘플결과"/>'	, type: 'string'},
			{name: 'LINE_BAD_DETAIL'    , text: '<t:message code="system.label.base.linebaddetail" default="LINE발생 불량현상 내용"/>'	, type: 'string'},
			{name: 'IMPROVING_MEASURE'  , text: '<t:message code="system.label.common.improvingneasure" default="개선조치"/>'	, type: 'string'},
			{name: 'FABRIC_COST'        , text: '<t:message code="system.label.base.fabridcost" default="원단비용"/>'	, type: 'int'},
			{name: 'SAMPLE_COST'        , text: '<t:message code="system.label.base.samplecost" default="샘플비용"/>'	, type: 'int'},
			{name: 'SAMSUNG_MANAGER'    , text: '<t:message code="system.label.base.charger" default="담당자"/>'	, type: 'string'},
			{name: 'SUBMISSION'         , text: '<t:message code="system.label.base.submission" default="재출처"/>'	, type: 'string'},
			{name: 'MONEY_UNIT'         , text: '<t:message code="system.label.base.currencyunit" default="화폐단위"/>'	, type: 'string', comboType:'AU', comboCode:'B004'},
			{name: 'ITEM_PRICE'         , text: '<t:message code="system.label.base.itemprice" default="제품단가"/>'	, type: 'uniUnitPrice'},
			{name: 'CUSTOMER_SUBMIT_Q'  , text: '<t:message code="system.label.base.customerSubmitQ" default="고객제출수량"/>'	, type: 'uniQty'},
			{name: 'PRICE'              , text: '<t:message code="system.label.sales.amount" default="금액"/>'	, type: 'uniUnitPrice'},
			{name: 'ACCOUNT_MANAGER'    , text: '<t:message code="system.label.common.accountManger" default="계산서발행 담당자"/>'	, type: 'string'},
			{name: 'ACCOUNT_YN'         , text: '<t:message code="system.label.base.accountYn" default="계산서발행여부"/>'	, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'QUOT_DATE'          , text: '<t:message code="system.label.base.quotdate" default="견적제출일"/>'	, type: 'uniDate'},
			{name: 'ACCOUNT_DATE'       , text: '<t:message code="system.label.base.billissuedate" default="계산서발행일"/>'	, type: 'uniDate'},
			{name: 'ACCOUNT_PRICE'      , text: '<t:message code="system.label.base.accountprice" default="계산서발행금액"/>'	, type: 'int'},
			{name: 'DEV_COST_RECALL'    , text: '<t:message code="system.label.base.devcostrecall" default="개발비용회수율"/>'	, type: 'uniPercent'}
		]
	});
	
	
	var masterStore = Unilite.createStore('s_bpr910skrv_jwMasterStore',{
		model	: 's_bpr910skrv_jwModel',
	 	proxy	: directProxy,
	 	autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 
			deletable	: false,			// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
		},
	 	listeners: {
			load: function(store, records, successful, eOpts) {
		 		if(!Ext.isEmpty(records)){
	 			}
	 		},
			write: function(proxy, operation){
				if (operation.action == 'destroy') {
				}
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
			},
			remove: function( store, records, index, isMove, eOpts ) { 
				if(store.count() == 0) {
				}
			}
		}
	});	
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{ 
			fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.common.client" default="고객"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank   : false,
			autoPopup       : true,
            listeners       : {
                applyextparam: function(popup){
                    popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','3']});
                    popup.setExtParam({'CUSTOM_TYPE'        : ['1','3']});
                }
            }
        }),		
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.base.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE', 
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				'applyextparam': function(popup){
					var divCode = panelResult.getValue('DIV_CODE');
					popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.common.receiptdate" default="접수일"/>',
		 	xtype: 'uniDateRangefield',
		 	startFieldName: 'RECEIPT_DATE_FR',
		 	endFieldName: 'RECEIPT_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),	
	 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
		},{
			fieldLabel	: '<t:message code="system.label.base.developmentlevel" default="개발단계"/>',
			name		: 'DEVELOPMENT_LEVEL',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZN03',
			colspan     :2,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel: 'MODEL',
			name: 'MODEL',
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel: 'PART_NM',
			name: 'PART_NM',
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]	
	});

	var masterGrid = Unilite.createGrid('s_bpr910skrv_jwGrid', {
		store	: masterStore,
	 	region	: 'center',
		sortableColumns : true,
		uniOpt	:{
			onLoadSelectFirst	: true,
			expandLastColumn	: true,
			useRowNumberer		: true,
			dblClickToEdit		: false,
			useMultipleSorting	: true
		},
		columns:[
			{dataIndex: 'COMP_CODE'			, width: 93		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 93		, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 100},
			{dataIndex: 'CUSTOM_NAME'		, width: 133},			
			{dataIndex: 'ITEM_CODE'			, width: 110},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'MODEL'	        , width: 100},
			{dataIndex: 'PART_NAME'	    , width: 100},
			{dataIndex: 'REV_NO'	    , width: 100},
			{dataIndex: 'CUSTOM_REV'	, width: 100},
			{dataIndex: 'INSIDE_REV'	, width: 100},
			{dataIndex: 'RECEIPT_DATE'	, width: 100},
			{dataIndex: 'DEVELOPMENT_LEVEL'	, width: 100},
			{dataIndex: 'RECEIPT_TYPE'	    , width: 100},
			{dataIndex: 'RECEIPT_DETAIL'	, width: 100},
			{dataIndex: 'WKORD_NUM'	        , width: 100},
			{dataIndex: 'WORK_DATE'	        , width: 100},
			{dataIndex: 'WORK_Q'	        , width: 100},
			{dataIndex: 'WOODEN_PATTEN'	    , width: 100},
			{dataIndex: 'WOODEN_ORDER_DATE'	, width: 100},
			{dataIndex: 'WOODEN_UNIT_PRICE'	, width: 100},
			{dataIndex: 'WOODEN_ORDER_YN'	, width: 100},
			{dataIndex: 'SAMPLE_DATE'	    , width: 100},
			{dataIndex: 'SAMPLE_RESULT'	    , width: 100},
			{dataIndex: 'LINE_BAD_DETAIL'	, width: 100},
			{dataIndex: 'IMPROVING_MEASURE'	, width: 100},
			{dataIndex: 'FABRIC_COST'	    , width: 100},
			{dataIndex: 'SAMPLE_COST'	    , width: 100},
			{dataIndex: 'SAMSUNG_MANAGER'	, width: 100},
			{dataIndex: 'SUBMISSION'	    , width: 100},
			{dataIndex: 'MONEY_UNIT'	    , width: 100},
			{dataIndex: 'ITEM_PRICE'	    , width: 100},
			{dataIndex: 'CUSTOMER_SUBMIT_Q'	, width: 100},
			{dataIndex: 'PRICE'	            , width: 100},
			{dataIndex: 'ACCOUNT_MANAGER'	, width: 100},
			{dataIndex: 'ACCOUNT_YN'	    , width: 100},
			{dataIndex: 'QUOT_DATE'	        , width: 100},
			{dataIndex: 'ACCOUNT_DATE'	    , width: 100},
			{dataIndex: 'ACCOUNT_PRICE'	    , width: 100},
			{dataIndex: 'DEV_COST_RECALL'	, width: 100}

		],
		listeners: {
	  		beforeedit  : function( editor, e, eOpts ) {
	  		},
			selectionchangerecord:function(selected)	{
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {			
			},			
			onGridDblClick:function(grid, record, cellIndex, colName) {

			}
		}
	});	
	
	
	Unilite.Main({
		id			: 's_bpr910skrv_jwApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid 
			]
		}],

		fnInitBinding : function(params) {
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');
			
			this.setDefault();
		},

		onQueryButtonDown: function () {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterStore.loadStoreRecords();
		},

		onNewDataButtonDown : function()	{
		},
								
		onDeleteDataButtonDown : function()	{
		},
		
		onSaveDataButtonDown: function (config) {
		},				
				
		onResetButtonDown: function() {
			panelResult.clearForm();	
			masterGrid.getStore().loadData({});	
			masterStore.clearData();	
			this.fnInitBinding();	
		},

		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		},

		setDefault: function() {
	 		panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
	 		panelResult.setValue('RECEIPT_DATE'	, UniDate.get('today'));
	 		panelResult.setValue('WORK_DATE'	, UniDate.get('today'));
		}
		
	});
	
	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {

			}
			return rv;
		}
	})

};
</script>