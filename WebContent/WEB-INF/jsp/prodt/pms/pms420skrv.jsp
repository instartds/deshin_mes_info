<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pms420skrv">
	<t:ExtComboStore comboType="BOR120" pgmId="pms420skrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="Q007"/>			<!-- 검사유형 -->
	<t:ExtComboStore comboType="AU" comboCode="Q024"/>			<!-- 검사담당 -->
	<t:ExtComboStore comboType="W"/>							<!-- 작업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/** 검색조건 (Search Panel)
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title		: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox', 
				comboType	: 'BOR120', 
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE'			, newValue);
						panelSearch.setValue('WORK_SHOP_CODE'	, '');
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'INSPEC_DATE_FR',
				endFieldName	: 'INSPEC_DATE_TO',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INSPEC_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INSPEC_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.inspecchargeperson" default="검사담당자"/>',
				name		: 'INSPEC_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU' ,
				comboCode	: 'Q024',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPEC_PRSN', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name		: 'WORK_SHOP_CODE', 
				xtype		: 'uniCombobox', 
				comboType	: 'W',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts )   {
						var store	= queryPlan.combo.store;
						var prStore	= panelResult.getField('WORK_SHOP_CODE').store;
						store.clearFilter();
						prStore.clearFilter();
						if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == panelSearch.getValue('DIV_CODE');
							});
							prStore.filterBy(function(record){
								return record.get('option') == panelSearch.getValue('DIV_CODE');
							});
						}else{
							store.filterBy(function(record){
								return false;
							});
							prStore.filterBy(function(record){
								return false;
							});
						}
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function( elm, newValue, oldValue ) {
						panelResult.setValue('ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_NAME', '');
							panelSearch.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						panelResult.setValue('ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){	
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.product.sono" default="수주번호"/>',
				name		: 'ORDER_NUM',
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_NUM', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>', 
			name		: 'DIV_CODE', 
			xtype		: 'uniCombobox', 
			comboType	: 'BOR120', 
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'INSPEC_DATE_FR',
			endFieldName	: 'INSPEC_DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INSPEC_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INSPEC_DATE_TO',newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.inspecchargeperson" default="검사담당자"/>',
			name		: 'INSPEC_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU' ,
			comboCode	: 'Q024',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INSPEC_PRSN', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE', 
			xtype		: 'uniCombobox', 
			comboType	: 'W',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				},
				beforequery:function( queryPlan, eOpts )   {
					var store	= queryPlan.combo.store;
					var prStore	= panelSearch.getField('WORK_SHOP_CODE').store;
					store.clearFilter();
					prStore.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
						prStore.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
					}else{
						store.filterBy(function(record){
							return false;
						});
						prStore.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function( elm, newValue, oldValue ) {
					panelSearch.setValue('ITEM_CODE', newValue);
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_NAME', '');
						panelSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function( elm, newValue, oldValue ) {
					panelSearch.setValue('ITEM_NAME', newValue);
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.product.sono" default="수주번호"/>',
			name		: 'ORDER_NUM',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_NUM', newValue);
				}
			}
		}]
	});



	/** Model 정의 
	 */
	Unilite.defineModel('pms420skrvModel', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.product.compcode" default="법인코드"/>'				, type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.product.division" default="사업장"/>'				, type: 'string'},
		    {name: 'RECEIPT_DATE'	, text: '<t:message code="system.label.product.receiptdate" default="접수일"/>'			, type: 'uniDate'},
			{name: 'INSPEC_DATE'	, text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'				, type: 'uniDate'},
			{name: 'INSPEC_NUM'		, text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'				, type: 'string'},
			{name: 'INSPEC_SEQ'		, text: '<t:message code="system.label.product.inspecseq" default="검사순번"/>'				, type: 'string'},
			{name: 'WORK_SHOP_CODE'	, text: '<t:message code="system.label.product.mainworkcenter" default="작업장"/>'			, type: 'string'},
			{name: 'WORK_SHOP_NAME'	, text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.product.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.product.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.product.spec" default="규격"/>'					, type: 'string'},
			{name: 'INSPEC_TYPE'	, text: '<t:message code="system.label.product.inspectype" default="검사유형"/>'			, type: 'string' , comboType:'AU' , comboCode:'Q007'},
			{name: 'INSPEC_Q'		, text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'				, type: 'uniQty'},
			{name: 'GOOD_INSPEC_Q'	, text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'			, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q'	, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'				, type: 'uniQty'},
			{name: 'GOODBAD_TYPE'	, text: '<t:message code="system.label.product.passyn" default="합격여부"/>'				, type: 'string' , comboType:'AU' , comboCode:'M414'},
			{name: 'REMARK'			, text: '<t:message code="system.label.product.remarks" default="비고"/>'					, type: 'string'},
			{name: 'BAD_NAME1'		, text: '불량명1'		, type: 'string'},
			{name: 'MANAGE_REMARK1'	, text: '조치내역1'		, type: 'string'},
			{name: 'BAD_NAME2'		, text: '불량명2'		, type: 'string'},
			{name: 'MANAGE_REMARK2'	, text: '조치내역2'		, type: 'string'},
			{name: 'BAD_NAME3'		, text: '불량명3'		, type: 'string'},
			{name: 'MANAGE_REMARK3'	, text: '조치내역3'		, type: 'string'},
			{name: 'ORDER_NUM'		, text: '<t:message code="system.label.product.sono" default="수주번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'		, text: '순번'		, type: 'string'},
			{name: 'WKORD_NUM'		, text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'			, type: 'string'},
			{name: 'PRODT_NUM'		, text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'	, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 */
	var masterStore = Unilite.createStore('pms420skrvMasterStore1', {
		model: 'pms420skrvModel',
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
				read: 'pms420skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		groupField:'INSPEC_DATE'
	});

	/** Master Grid 정의(Grid Panel)
	 */
	var masterGrid = Unilite.createGrid('pms420skrvGrid', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: false,
			dblClickToEdit		: false,
			useSqlTotal			: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext		: false,
			filter: {
				useFilter		: true,
				autoCreate		: true
			},
			state: {
				useState	: false,
				useStateList: false
			}
		},
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: false
		}],
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'RECEIPT_DATE'		, width: 100},
			{dataIndex: 'INSPEC_DATE'		, width: 100},
			{dataIndex: 'INSPEC_NUM'		, width: 110},
			{dataIndex: 'INSPEC_SEQ'		, width: 80	, align: 'center'},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100},
			{dataIndex: 'WORK_SHOP_NAME'	, width: 110},
			{dataIndex: 'ITEM_CODE'			, width: 110},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'SPEC'				, width: 120},
			{dataIndex: 'INSPEC_TYPE'		, width: 100},
			{dataIndex: 'INSPEC_Q'			, width: 100},
			{dataIndex: 'GOOD_INSPEC_Q'		, width: 100},
			{dataIndex: 'BAD_INSPEC_Q'		, width: 100},
			{dataIndex: 'GOODBAD_TYPE'		, width: 80	, align: 'center'},
			{dataIndex: 'REMARK'			, width: 120},
			{dataIndex: 'BAD_NAME1'			, width: 100},
			{dataIndex: 'MANAGE_REMARK1'	, width: 120},
			{dataIndex: 'BAD_NAME2'			, width: 100},
			{dataIndex: 'MANAGE_REMARK2'	, width: 120},
			{dataIndex: 'BAD_NAME3'			, width: 100},
			{dataIndex: 'MANAGE_REMARK3'	, width: 120},
			{dataIndex: 'ORDER_NUM'			, width: 110},
			{dataIndex: 'ORDER_SEQ'			, width: 80	, align: 'center'},
			{dataIndex: 'WKORD_NUM'			, width: 110},
			{dataIndex: 'PRODT_NUM'			, width: 110}
		]
	});



	Unilite.Main({
		id			: 'pms420skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelSearch.setValue('INSPEC_DATE_FR'	, UniDate.get('today'));
			panelResult.setValue('INSPEC_DATE_FR'	, UniDate.get('today'));
			panelSearch.setValue('INSPEC_DATE_TO'	, UniDate.get('today'));
			panelResult.setValue('INSPEC_DATE_TO'	, UniDate.get('today'));

			UniAppManager.setToolbarButtons(['reset'], true);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterStore.loadStoreRecords();
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});
};
</script>