<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pms400skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pms400skrv"  />	<!-- 사업장 -->
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	/**
	 *   Model 정의 
	 */
	Unilite.defineModel('pms400skrvModel', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.product.compcode" default="법인코드"/>'			, type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.product.division" default="사업장"/>'			, type: 'string'},
			{name: 'INSPEC_DATE'	, text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'			, type: 'uniDate'},
			{name: 'INSPEC_NUM'		, text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'			, type: 'string'},
			{name: 'INSPEC_SEQ'		, text: '<t:message code="system.label.product.inspecseq" default="검사순번"/>'			, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.product.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.product.spec" default="규격"/>'				, type: 'string'},
			{name: 'LOT_NO'			, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'	, text: '<t:message code="system.label.product.mainworkcenter" default="작업장"/>'		, type: 'string'},
			{name: 'WORK_SHOP_NAME' , text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'	, type: 'string'},
			{name: 'INSPEC_Q'		, text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'			, type: 'uniQty'},
			{name: 'GOOD_INSPEC_Q'  , text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'		, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q'	, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'			, type: 'uniQty'},
			{name: 'BAD_LATE'		, text: '<t:message code="system.label.product.defectrate" default="불량률(%)"/>'		, type: 'uniER'},
			{name: 'REMARK'			, text: '<t:message code="system.label.product.remarks" default="비고"/>'				, type: 'string'},
			{name: 'BAD_INSPEC1'	, text: '불량명1'		, type: 'string'},
			{name: 'BAD_INSPEC2'	, text: '불량명2'		, type: 'string'},
			{name: 'BAD_INSPEC3'	, text: '불량명3'		, type: 'string'},
			{name: 'BAD_INSPEC4'	, text: '불량명4'		, type: 'string'},
			{name: 'BAD_INSPEC5'	, text: '불량명5'		, type: 'string'},
			{name: 'BAD_INSPEC_Q1'	, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>1'		, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q2'	, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>2'		, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q3'	, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>3'		, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q4'	, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>4'		, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q5'	, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>5'		, type: 'uniQty'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 */					
	var masterStore = Unilite.createStore('pms400skrvMasterStore1', {
		model: 'pms400skrvModel',
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
				read: 'pms400skrvService.selectList'					
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

	/**
	 * 검색조건 (Search Panel)
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
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
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
						panelSearch.setValue('WORK_SHOP_CODE','');

					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INSPEC_DATE_FR',
				endFieldName: 'INSPEC_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315, 
				allowBlank: false,
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
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE', 
				xtype: 'uniCombobox', 
				comboType:'W',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var prStore = panelResult.getField('WORK_SHOP_CODE').store;
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
			Unilite.popup('DIV_PUMOK',{ // 20210824 추가: 품목 조회조건 정규화
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
				validateBlank:false,
				valueFieldName:'ITEM_CODE',
				textFieldName:'ITEM_NAME', 
				listeners: {
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
			})]							 
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout: {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>', 
			name: 'DIV_CODE', 
			xtype: 'uniCombobox', 
			comboType: 'BOR120', 
			allowBlank: false,
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'INSPEC_DATE_FR',
			endFieldName: 'INSPEC_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315, 
			allowBlank: false,
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
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE', 
			xtype: 'uniCombobox', 
			comboType:'W',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				},
					beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
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
		Unilite.popup('DIV_PUMOK',{ // 20210824 추가: 품목 조회조건 정규화
			fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
			validateBlank:false,
			valueFieldName:'ITEM_CODE',
			textFieldName:'ITEM_NAME', 
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
		})]
	});
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 */
	var masterGrid = Unilite.createGrid('pms400skrvGrid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
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
				useState: false,
				useStateList: false
			}
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
		store: masterStore,
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 100,hidden:true},
			{dataIndex: 'DIV_CODE'			, width: 100,hidden:true},
			{dataIndex: 'INSPEC_DATE'		, width: 100},
			{dataIndex: 'INSPEC_NUM'		, width: 120},
			{dataIndex: 'INSPEC_SEQ'		, width: 100,hidden:true},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'LOT_NO'			, width: 80},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100,hidden:true},
			{dataIndex: 'WORK_SHOP_NAME'	, width: 120, align:'center'},
			{dataIndex: 'INSPEC_Q'			, width: 80},
			{dataIndex: 'GOOD_INSPEC_Q'		, width: 80},
			{dataIndex: 'BAD_INSPEC_Q'		, width: 80},
			{dataIndex: 'BAD_LATE'			, width: 80},
			{dataIndex: 'REMARK'			, width: 150},
			{dataIndex: 'BAD_INSPEC1'		, width: 100},
			{dataIndex: 'BAD_INSPEC_Q1'		, width: 100},
			{dataIndex: 'BAD_INSPEC2'		, width: 100},
			{dataIndex: 'BAD_INSPEC_Q2'		, width: 100},
			{dataIndex: 'BAD_INSPEC3'		, width: 100},
			{dataIndex: 'BAD_INSPEC_Q3'		, width: 100},
			{dataIndex: 'BAD_INSPEC4'		, width: 100},
			{dataIndex: 'BAD_INSPEC_Q4'		, width: 100},
			{dataIndex: 'BAD_INSPEC5'		, width: 100},
			{dataIndex: 'BAD_INSPEC_Q5'		, width: 100}
		]
	});

	Unilite.Main({
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
		id: 'pms400skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('INSPEC_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('INSPEC_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('INSPEC_DATE_TO',UniDate.get('today'));
			panelResult.setValue('INSPEC_DATE_TO',UniDate.get('today'));
			
			UniAppManager.setToolbarButtons(['reset'], true);
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;//필수체크
			masterStore.loadStoreRecords();
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			UniAppManager.app.fnInitBinding();
		}
	});
};
</script>