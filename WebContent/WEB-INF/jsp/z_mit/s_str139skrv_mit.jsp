<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str139skrv_mit">
	<t:ExtComboStore comboType="BOR120" pgmId="s_str139skrv_mit"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P505"/> 			<!-- 작업자 -->
	<t:ExtComboStore comboType="W"/>							<!-- 작업장 -->
</t:appConfig>
<style type="text/css">
	.x-change-cell {
		background-color: #FFFFC6;
	}
	.x-change-cell_Red {
		background-color: #FF0000;
	}
	.x-change-cell_Green {
		background-color: #1DDB16;
	}
</style>

<script type="text/javascript" >
function appMain() {
	Unilite.defineModel('s_str139skrv_mitModel', {
		fields: [
			{name: 'ITEM_CODE'			, text: '품목코드'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '품목명'		, type: 'string'},
			{name: 'PREV_PRODT_Q'		, text: '전월생산량'		, type: 'uniQty'},
			{name: 'NOW_PRODT_Q'		, text: '당월생산량'		, type: 'uniQty'},
			{name: 'RISE_RATE'			, text: '증가율(%)'		, type: 'uniQty'},
			{name: 'PREV_MAN_HOUR'		, text: '전월공수'		, type: 'uniQty'},
			{name: 'NOW_MAN_HOUR'		, text: '당월공수'		, type: 'uniQty'},
			{name: 'LOSE_RATE'			, text: '감소율(%)'		, type: 'uniQty'}
		]
	});

	var directMasterStore = Unilite.createStore('s_str139skrv_mitMasterStore',{
		model	: 's_str139skrv_mitModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api	: {
				read: 's_str139skrv_mitService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
			}
		}
	});

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items:[{
			title		: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE'			, newValue);
						panelResult.setValue('WORK_SHOP_CODE'	, '');
						panelSearch.setValue('WORK_SHOP_CODE'	, '');
					}
				}
			},{
				fieldLabel		: '생산일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'PRODT_DATE_FR',
				endFieldName	: 'PRODT_DATE_TO',
				width			: 315,
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name		: 'WORK_SHOP_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'W',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts ) {
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
			},{
				xtype		: 'container',
				layout		: { type: 'uniTable', columns: 2},
				defaultType	: 'uniTextfield',
				items		: [
					Unilite.popup('DIV_PUMOK',{
						fieldLabel		: '품목코드',
						valueFieldName	: 'ITEM_CODE',
						textFieldName	: 'ITEM_NAME',
						valueFieldWidth	: 80,
						textFieldWidth	: 100,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('ITEM_CODE', records[0]["ITEM_CODE"]);
									panelResult.setValue('ITEM_NAME', records[0]["ITEM_NAME"]);
									panelResult.setValue('SPEC'		, records[0]["SPEC"]);
									panelSearch.setValue('SPEC'		, records[0]["SPEC"]);
								},
								scope: this
							},
							onClear: function(type) {
								panelResult.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_NAME', '');
								panelResult.setValue('SPEC'		, '');
								panelSearch.setValue('SPEC'		, '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
						}
				}),{
					name	: 'SPEC',
					xtype	: 'uniTextfield',
					width	: 50,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('SPEC', newValue);
						}
					}
				}]
			},{
				fieldLabel	: '작업자',
				name		: 'PRODT_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'P505',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PRODT_PRSN', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
					panelSearch.setValue('WORK_SHOP_CODE', '');
					panelResult.setValue('WORK_SHOP_CODE', '');
				}
			}
		},{
			fieldLabel		: '생산일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'PRODT_DATE_FR',
			endFieldName	: 'PRODT_DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_DATE_TO',newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'W',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					var psStore = panelSearch.getField('WORK_SHOP_CODE').store;
					store.clearFilter();
					psStore.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
						psStore.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
					}else{
						store.filterBy(function(record){
							return false;
						});
						psStore.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},{
			xtype		: 'container',
			layout		: { type: 'uniTable', columns: 2},
			defaultType	: 'uniTextfield',
			colspan		: 2,
			items		: [
				Unilite.popup('DIV_PUMOK',{
					fieldLabel		: '품목코드',
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ITEM_CODE', records[0]["ITEM_CODE"]);
								panelSearch.setValue('ITEM_NAME', records[0]["ITEM_NAME"]);
								panelSearch.setValue('SPEC'		, records[0]["SPEC"]);
								panelResult.setValue('SPEC'		, records[0]["SPEC"]);
							},
							scope: this
						},
						onClear: function(type) {
							panelSearch.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_NAME', '');
							panelSearch.setValue('SPEC'		, '');
							panelResult.setValue('SPEC'		, '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
				name		: 'SPEC',
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('SPEC', newValue);
					}
				}
			}]
		},{
			fieldLabel	: '작업자',
			name		: 'PRODT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'P505',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PRODT_PRSN', newValue);
				}
			}
		}]
	});

	var masterGrid = Unilite.createGrid('s_str139skrv_mitGrid1', {
		store			: directMasterStore,
		layout			: 'fit',
		region			: 'center',
		sortableColumns	: false,
		uniOpt			: {
			expandLastColumn	: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useRowNumberer		: false,
			onLoadSelectFirst	: true,
			filter				: {
				useFilter	: true,
				autoCreate	: true
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
		selModel: 'rowmodel',
		columns	: [
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'PREV_PRODT_Q'		, width: 150},
			{dataIndex: 'NOW_PRODT_Q'		, width: 150},
			{dataIndex: 'RISE_RATE'			, width: 150},
			{dataIndex: 'PREV_MAN_HOUR'		, width: 150},
			{dataIndex: 'NOW_MAN_HOUR'		, width: 150},
			{dataIndex: 'LOSE_RATE'			, width: 150}
		
		]
	});



	Unilite.Main({
		id			: 's_str139skrv_mitApp',
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
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);

			panelSearch.setValue('PRODT_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('PRODT_DATE_TO', UniDate.get('today'));

			panelResult.setValue('PRODT_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('PRODT_DATE_TO', UniDate.get('today'));

			UniAppManager.setToolbarButtons(['reset']		, true);
			UniAppManager.setToolbarButtons(['print','save'], false);
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			directMasterStore.loadData({});
			this.fnInitBinding();
		}
	});
};
</script>