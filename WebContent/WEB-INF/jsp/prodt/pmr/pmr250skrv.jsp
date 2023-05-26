<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr250skrv">
	<t:ExtComboStore comboType="BOR120" pgmId="pmr250skrv"/>	<!-- 사업장 -->
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
	Unilite.defineModel('pmr250skrvModel', {
		fields: [
			{name: 'WKORD_NUM'			, text: '작업지시번호'	, type: 'string'},
			{name: 'ITEM_CODE'			, text: '품목코드'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '품목명'		, type: 'string'},
			{name: 'ITEM_NAME1'			, text: '품목명1'		, type: 'string'},
			{name: 'SPEC'				, text: '규격'		, type: 'string'},
			{name: 'LOT_NO'				, text: 'LOT NO'	, type: 'string'},
			{name: 'PRODT_WKORD_DATE'	, text: '작업지시일'		, type: 'uniDate'},
			{name: 'PRODT_DATE'			, text: '생산일'		, type: 'uniDate'},
			{name: 'WKORD_Q'			, text: '지시량'		, type: 'uniQty'},
			{name: 'WORK_Q'				, text: '생산량'		, type: 'uniQty'},
			{name: 'GOOD_WORK_Q'		, text: '양품수량'		, type: 'uniQty'},
			{name: 'BAD_WORK_Q'			, text: '불량수량'		, type: 'uniQty'},
			{name: 'BAD_NAME'			, text: '불량유형'		, type: 'string'},
			{name: 'REMARK'				, text: '문제점 및 대책'	, type: 'string'},
			{name: 'PRODT_PRSN_CODE'    , text: '작업자'       , type: 'string'},
			{name: 'PRODT_PRSN_NAME'    , text: '작업자명'      , type: 'string',comboType:'AU',comboCode:'P505'},
			{name: 'PRODT_PRSN'			, text: '실적작업자'		, type: 'string'},
			{name: 'REGIST_USER'		, text: '실적처리자'		, type: 'string'}
		]
	});

	var directMasterStore = Unilite.createStore('pmr250skrvMasterStore',{
		model	: 'pmr250skrvModel',
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
				read: 'pmr250skrvService.selectList'
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
						validateBlank	: false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('SPEC'		, records[0]["SPEC"]);
									panelSearch.setValue('SPEC'		, records[0]["SPEC"]);
								},
								scope: this
							},
							onValueFieldChange: function( elm, newValue, oldValue ) {
								panelResult.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('ITEM_NAME', '');
									panelSearch.setValue('ITEM_NAME', '');
									panelResult.setValue('SPEC'		, '');
									panelSearch.setValue('SPEC'		, '');
								}
							},
							onTextFieldChange: function( elm, newValue, oldValue ) {
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('ITEM_CODE', '');
									panelSearch.setValue('ITEM_CODE', '');
									panelResult.setValue('SPEC'		, '');
									panelSearch.setValue('SPEC'		, '');
								}
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
					validateBlank	: false,
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('SPEC'		, records[0]["SPEC"]);
								panelSearch.setValue('SPEC'		, records[0]["SPEC"]);
							},
							scope: this
						},
						onValueFieldChange: function( elm, newValue, oldValue, records ) {
							panelSearch.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('SPEC'		, '');
								panelSearch.setValue('SPEC'		, '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue, records ) {
							panelSearch.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('SPEC'		, '');
								panelSearch.setValue('SPEC'		, '');
							}
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

	var masterGrid = Unilite.createGrid('pmr250skrvGrid1', {
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
			{dataIndex: 'WKORD_NUM'			, width: 120},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'ITEM_NAME1'		, width: 150},
			{dataIndex: 'SPEC'				, width: 200},
			{dataIndex: 'LOT_NO'			, width: 100},
			{dataIndex: 'PRODT_WKORD_DATE'	, width: 100},
			{dataIndex: 'PRODT_DATE'		, width: 80},
			{dataIndex: 'WKORD_Q'			, width: 100},
			{dataIndex: 'WORK_Q'			, width: 100},
			{dataIndex: 'GOOD_WORK_Q'		, width: 100},
			{dataIndex: 'BAD_WORK_Q'		, width: 100},
			{dataIndex: 'BAD_NAME'			, width: 150},
			{dataIndex: 'REMARK'			, width: 100},
			{dataIndex: 'PRODT_PRSN_CODE'   , width: 80 , align: 'center'},
			{dataIndex: 'PRODT_PRSN_NAME'   , width: 80 , align: 'center'},
			{dataIndex: 'PRODT_PRSN'		, width: 80 , align: 'center'},
			{dataIndex: 'REGIST_USER'		, width: 80 , align: 'center'}
		]
	});



	Unilite.Main({
		id			: 'pmr250skrvApp',
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

			panelSearch.setValue('PRODT_DATE_FR', UniDate.get('mondayOfWeek'));
			panelSearch.setValue('PRODT_DATE_TO', UniDate.get('sundayOfNextWeek'));

			panelResult.setValue('PRODT_DATE_FR', UniDate.get('mondayOfWeek'));
			panelResult.setValue('PRODT_DATE_TO', UniDate.get('sundayOfNextWeek'));

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