<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr220ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />	<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />	<!-- 단위   -->
	<t:ExtComboStore comboType="AU" comboCode="B014" />	<!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B023" />	<!-- 실적입고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="B039" />	<!-- 출고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" />	<!-- 세구분  -->
	<t:ExtComboStore comboType="AU" comboCode="B061" />	<!-- 발주방침 -->
	<t:ExtComboStore comboType="OU" />					<!-- 창고   -->
	<t:ExtComboStore comboType="WU" />					<!-- 작업장  -->

</t:appConfig>

<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
</style>

<script type="text/javascript" >

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 'bpr220ukrvService.selectList',
			create	: 'bpr220ukrvService.insertDetail',
			update	: 'bpr220ukrvService.updateDetail',
			destroy	: 'bpr220ukrvService.deleteDetail',
			syncAll	: 'bpr220ukrvService.saveAll'
		}
	});



	Unilite.defineModel('detailModel', {
		fields: [
			{name: 'DIV_CODE'		,text: '사업장'	,type: 'string',comboType:'BOR120', allowBlank:false},
			{name: 'ITEM_ACCOUNT'	,text: '품목계정'	,type: 'string',comboType: 'AU',comboCode: 'B020', allowBlank:false},
			{name: 'SUPPLY_TYPE'	,text: '조달구분'	,type: 'string',comboType: 'AU',comboCode: 'B014', allowBlank:false},
			{name: 'WH_CODE'		,text: '주창고'	,type: 'string', comboType:'OU', allowBlank:false},
			{name: 'STOCK_UNIT'		,text: '재고단위'	,type: 'string',comboType: 'AU',comboCode: 'B013', displayField: 'value',allowBlank:false},
			{name: 'SALE_UNIT'		,text: '판매단위'	,type: 'string',comboType: 'AU',comboCode: 'B013', displayField: 'value',allowBlank:false},
			{name: 'ORDER_UNIT'		,text: '구매단위'	,type: 'string',comboType: 'AU',comboCode: 'B013', displayField: 'value',allowBlank:false},
			{name: 'SALE_TRNS_RATE'	,text: '판매입수'	,type: 'int',/* decimalPrecision:1,*/ format:'0,000',allowBlank:false},
			{name: 'PUR_TRNS_RATE'	,text: '구매입수'	,type: 'int', format:'0,000', allowBlank:false},
			{name: 'ORDER_PLAN'		,text: '발주방침'	,type: 'string',comboType: 'AU',comboCode: 'B061', allowBlank:false},
			{name: 'TAX_TYPE'		,text: '세구분'	,type: 'string',comboType: 'AU',comboCode: 'B059', allowBlank:false},
			{name: 'WORK_SHOP_CODE'	,text: '주작업장'	,type: 'string', comboType:'WU'},
			//20190702 출고방법, 실적입고방법 추가
			{name: 'OUT_METH'		,text: '<t:message code="system.label.base.issuemethod" default="출고방법"/>'				, type: 'string'	, comboType: 'AU'	, comboCode: 'B039'},
			{name: 'RESULT_YN'		,text: '<t:message code="system.label.base.resultsreceiptmethod" default="실적입고방법"/>'	, type: 'string'	, comboType: 'AU'	, comboCode: 'B023'},
			//20190910 품질대상(검사) 여부, LOT관리여부 추가
			{name: 'INSPEC_YN'		,text: '<t:message code="system.label.base.qualityyn" default="품질대상여부"/>'				, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'LOT_YN'			,text: '<t:message code="system.label.base.lotmanageyn" default="LOT관리여부"/>'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			//20200813 생산방식, 유통기한관리여부, 유통기간 추가
			{name: 'ORDER_METH'		,text: '생산방식'				, type: 'string'	, comboType: 'AU'	, comboCode: 'P006'},
			{name: 'CIR_PERIOD_YN'		,text: '유통기한관리여부'				, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'EXPIRATION_DAY'		,text: '유통기간'				, type: 'int'},
			{name: 'REMARK'			,text: '비고'		,type: 'string'}
		]
	});	

	var detailStore = Unilite.createStore('detailStore',{
		model	: 'detailModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,	// 상위 버튼 연결 
			editable	: true,	// 수정 모드 사용 
			deletable	: true,	// 삭제 가능 여부 
			useNavi		: false	// prev | next 버튼 사용
		},
		loadStoreRecords : function() {
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						detailStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
				
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});



	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region	: 'north',
		layout	: {type : 'uniTable', columns :1},
//			tableAttrs: {width: '100%'}
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
//		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]
	});



	var detailGrid = Unilite.createGrid('detailGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
//			userToolbar:false,
			expandLastColumn	: true,
			useLiveSearch		: false,
			useContextMenu		: false,
			useMultipleSorting	: false,
			useGroupSummary		: false,
			useRowNumberer		: false,
			onLoadSelectFirst	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			},
			state: {
				useState	: false,
				useStateList: false
			}
		},
		columns: [
			{ dataIndex: 'ITEM_ACCOUNT'			, width: 100,align:'center'},
			{ dataIndex: 'SUPPLY_TYPE'			, width: 100,align:'center'},
			{ dataIndex: 'WH_CODE'				, width: 150,align:'center',
				listeners:{
					render:function(elm){ 
						elm.editor.on('beforequery',function(queryPlan, eOpts) {
					 		var store		= queryPlan.combo.store;
							var selRecord	=  detailGrid.uniOpt.currentRecord;
							store.clearFilter();
							if(!Ext.isEmpty(selRecord.get('DIV_CODE'))){
								store.filterBy(function(record){
									return record.get('option') == selRecord.get('DIV_CODE');
								});
							} else {
								store.filterBy(function(record){
									return false;
								});
							}
						})
					}
				}
			},
			{ dataIndex: 'STOCK_UNIT'			, width: 100,align:'center'},
			{ dataIndex: 'SALE_UNIT'			, width: 100,align:'center'},
			{ dataIndex: 'ORDER_UNIT'			, width: 100,align:'center'},
			{ dataIndex: 'SALE_TRNS_RATE'		, width: 100},
			{ dataIndex: 'PUR_TRNS_RATE'		, width: 100},
			{ dataIndex: 'ORDER_PLAN'			, width: 120,align:'center'},
			{ dataIndex: 'TAX_TYPE'				, width: 100,align:'center'},
			{ dataIndex: 'WORK_SHOP_CODE'		, width: 150,align:'center',
				listeners:{
					render:function(elm){ 
						elm.editor.on('beforequery',function(queryPlan, eOpts) {
					 		var store		= queryPlan.combo.store;
							var selRecord	=  detailGrid.uniOpt.currentRecord;
							store.clearFilter();
							if(!Ext.isEmpty(selRecord.get('DIV_CODE'))){
								store.filterBy(function(record){
									return record.get('option') == selRecord.get('DIV_CODE');
								});
							} else {
								store.filterBy(function(record){
									return false;
								});
							}
						})
					}
				}
			},
			//20190702 출고방법, 실적입고방법 추가
			{ dataIndex: 'OUT_METH'				, width: 100,align:'center'},
			{ dataIndex: 'RESULT_YN'			, width: 100,align:'center'},
			//20190910 품질대상(검사) 여부, LOT관리여부 추가
			{ dataIndex: 'INSPEC_YN'			, width: 100,align:'center'},
			{ dataIndex: 'LOT_YN'				, width: 100,align:'center'},
			//20200813 생산방식, 유통기한관리여부, 유토기간 추가
			{ dataIndex: 'ORDER_METH'			, width: 100,align:'center'},
			{ dataIndex: 'CIR_PERIOD_YN'		, width: 100,align:'center'},
			{ dataIndex: 'EXPIRATION_DAY'		, width: 100,align:'center'},
			{ dataIndex: 'REMARK'				, width: 300}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(e.record.phantom == true){
					return true;
				} else {
					if (UniUtils.indexOf(e.field, ['ITEM_ACCOUNT'])) {
						return false;
					} else {
						return true;
					}
				}
			}
		}
	});



	Unilite.Main({
		id			: 'bpr220ukrvApp',
		borderItems	: [{
			id		: 'pageAll',
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelSearch, detailGrid
			]
		}],
		fnInitBinding: function() {
			this.fnInitInputFields();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			detailGrid.reset();
			detailStore.clearData();

			this.fnInitInputFields();
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
			panelSearch.getField('DIV_CODE').setReadOnly(true);
			detailStore.loadStoreRecords();
		},
		onNewDataButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;	//필수체크

			var divCode = panelSearch.getValue('DIV_CODE');
			var r = {
				DIV_CODE		: divCode,
				STOCK_UNIT		: 'EA',
				SALE_UNIT		: 'EA',
				ORDER_UNIT		: 'EA',
				SALE_TRNS_RATE	: 1,
				PUR_TRNS_RATE	: 1,
				ORDER_PLAN		: '1',
				TAX_TYPE		: '1',
				//20190910 품질대상(검사) 여부 추가
				INSPEC_YN		: 'Y'
			};
			detailGrid.createRow(r);
			panelSearch.getField('DIV_CODE').setReadOnly(true);
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)){
				if(selRow.phantom === true) {
					detailGrid.deleteSelectedRow();
				} else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					detailGrid.deleteSelectedRow();
				}
			}
		},
		onSaveDataButtonDown: function(config) {
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
			detailStore.saveStore();
		},
		fnInitInputFields: function(){
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			UniAppManager.setToolbarButtons(['reset','newData']	, true);
			UniAppManager.setToolbarButtons(['print','save']	, false);
		}
	});
};
</script>