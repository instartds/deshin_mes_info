<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr400skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />	<!-- 작업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />				<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="P506" />				<!-- 작업호기 -->
	<t:ExtComboStore comboType="AU" comboCode="P507" />				<!-- 주야구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('pmr400skrvModel1', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'		, text: 'DIV_CODE'		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.product.item" default="품목"/>'							, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.product.itemname" default="품목명"/>'						, type: 'string'},
			{name: 'ITEM_NAME1'		, text: '<t:message code="system.label.product.itemname" default="품목명"/>1'						, type: 'string'},
			{name: 'PRODT_Q'		, text: '<t:message code="system.label.product.totalproductionqty" default="총생산량"/>'			, type: 'uniQty'},
			{name: 'GOOD_PRODT_Q'	, text: '<t:message code="system.label.product.good" default="양품"/>'							, type: 'uniQty'},
			{name: 'BAD_PRODT_Q'	, text: '<t:message code="system.label.product.defect" default="불량"/>'							, type: 'uniQty'},
			{name: 'PRODT_DATE'		, text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'						, type: 'uniDate'},
			{name: 'PRODT_PRSN'		, text: '<t:message code="system.label.product.inspector" default="검사자"/>'						, type: 'string'},
			{name: 'PRODT_NAME'		, text: '<t:message code="system.label.product.inspectorname" default="검사자명"/>'					, type: 'string'},
			{name: 'PRODT_MACH'		, text: '<t:message code="system.label.base.inspectionline" default="검수라인"/>'					, type: 'string'	, comboType:'AU'		, comboCode:'P506'},
			{name: 'DAY_NIGHT'		, text: '<t:message code="system.label.product.daynightclass" default="주야구분"/>'					, type: 'string'	, comboType:'AU'		, comboCode:'P507'},
			{name: 'PRODT_TIME'		, text: '<t:message code="system.label.product.inspectime" default="검사시간"/>'					, type: 'float'		, decimalPrecision: 2	, format:'0,000.00'},
			{name: 'STANDARD_TIME'	, text: '<t:message code="system.label.product.standardtime" default="표준시간"/>'					, type: 'float'		, decimalPrecision: 2	, format:'0,000.00'},
			{name: 'ARRAY_CNT'		, text: '<t:message code="system.label.product.arraycount" default="배열수"/>'						, type: 'int'},
			{name: 'PRODT_TARGET'	, text: '<t:message code="system.label.product.inspectiontargetquantity" default="검사목표수량"/>'	, type: 'uniQty'},
			{name: 'PRODT_RESULT'	, text: '<t:message code="system.label.product.accompratepercent" default="달성율(%)"/>'			, type: 'uniPercent'},
			{name: 'REMARK'			, text: '<t:message code="system.label.product.remarks" default="비고"/>'							, type: 'string'}
		]
	}); //End of Unilite.defineModel('pmr400skrvModel1', {



	/** Store 정의(Service 정의)
	 * @type 
	 */	
	var directMasterStore = Unilite.createStore('pmr400skrvMasterStore1',{
		model	: 'pmr400skrvModel1',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'pmr400skrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
				
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				
			},
			remove: function(store, record, index, isMove, eOpts) {	
			}
		}
	}); //End of var directMasterStore = Unilite.createStore('pmr400skrvMasterStore1',{



	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
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
				value		: UserInfo.divCode,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.product.resultsdate" default="실적일"/>',
				xtype			: 'uniDateRangefield', 
				startFieldName	: 'PRODT_DATE_FR',
				endFieldName	: 'PRODT_DATE_TO',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
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
				store		: Ext.data.StoreManager.lookup('wsList'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
						panelResult.setValue('PRODT_MACH', '');
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.base.inspectionline" default="검수라인"/>',
				name		: 'PRODT_MACH', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU', 
				comboCode	: 'P506',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PRODT_MACH', newValue);
					},
					beforequery:function( queryPlan, eOpts )    {
                        var store = queryPlan.combo.store;
                        store.clearFilter();
                    	if(!Ext.isEmpty(panelSearch.getValue('WORK_SHOP_CODE'))){
                            store.filterBy(function(record){
                                return record.get('refCode1') == panelSearch.getValue('WORK_SHOP_CODE');
                            })
                        }
                    }
				}
			},
			Unilite.popup('DIV_PUMOK',{ 
				fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
				validateBlank	: false, 
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.product.daynightclass" default="주야구분"/>',
				name		: 'DAY_NIGHT', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU', 
				comboCode	: 'P507',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DAY_NIGHT', newValue);
					}
				}
			}]
		}]
	});	

	var panelResult = Unilite.createSimpleForm('panelResultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE', 
			xtype		: 'uniCombobox', 
			comboType	:'BOR120', 
			allowBlank	: false,
			value		: UserInfo.divCode,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.product.resultsdate" default="실적일"/>',
			xtype			: 'uniDateRangefield', 
			startFieldName	: 'PRODT_DATE_FR',
			endFieldName	: 'PRODT_DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
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
			store		: Ext.data.StoreManager.lookup('wsList'),
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
					panelSearch.setValue('PRODT_MACH', '');
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.base.inspectionline" default="검수라인"/>',
			name		: 'PRODT_MACH', 
			xtype		: 'uniCombobox', 
			comboType	: 'AU', 
			comboCode	: 'P506',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PRODT_MACH', newValue);
				},
				beforequery:function( queryPlan, eOpts )    {
                    var store = queryPlan.combo.store;
                    store.clearFilter();
                    if(!Ext.isEmpty(panelResult.getValue('WORK_SHOP_CODE'))){
	                    store.filterBy(function(record){
	                        return record.get('refCode1') == panelResult.getValue('WORK_SHOP_CODE');
	                    })
                    }
                }
			}
		},
		Unilite.popup('DIV_PUMOK',{ 
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>', 
			validateBlank	: false, 
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.product.daynightclass" default="주야구분"/>',
			name		: 'DAY_NIGHT', 
			xtype		: 'uniCombobox', 
			comboType	: 'AU', 
			comboCode	: 'P507',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DAY_NIGHT', newValue);
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('pmr400skrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useRowNumberer		: true,
			onLoadSelectFirst	: true,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		features: [ 
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} 
		],
		columns: [		
			{dataIndex: 'COMP_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'ITEM_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'ITEM_NAME'		, width: 140},
			{dataIndex: 'ITEM_NAME1'	, width: 140	, hidden: true},
			{dataIndex: 'PRODT_Q'		, width: 120	, summaryType: 'sum'},
			{dataIndex: 'GOOD_PRODT_Q'	, width: 110	, summaryType: 'sum'},
			{dataIndex: 'BAD_PRODT_Q'	, width: 110	, summaryType: 'sum'},
			{dataIndex: 'PRODT_DATE'	, width: 80 },
			{dataIndex: 'PRODT_PRSN'	, width: 100},
			{dataIndex: 'PRODT_NAME'	, width: 120},
			{dataIndex: 'PRODT_MACH'	, width: 100},
			{dataIndex: 'DAY_NIGHT'		, width: 100},
			{dataIndex: 'PRODT_TIME'	, width: 100},
			{dataIndex: 'STANDARD_TIME'	, width: 100},
			{dataIndex: 'ARRAY_CNT'		, width: 80},
			{dataIndex: 'PRODT_TARGET'	, width: 100/*	, summaryType: 'sum'*/},
			{dataIndex: 'PRODT_RESULT'	, width: 100	, summaryType: 'average'},
			{dataIndex: 'REMARK'		, width: 200}
		],
		listeners: {
			cellclick: function( viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts , colName) {
//				this.returnCell(record, colName);
			}
		},
		returnCell: function(record, colName){
//			var itemCode		= record.get("ITEM_CODE");
//			var workCode		= record.get("WORK_SHOP_CODE");
//			panelSearch.setValues({'TEMP_ITEM_CODE':itemCode});
//			panelSearch.setValues({'TEMP_WORK_SHOP_CODE':workCode});
		 }
	});
	
	
	
	
	
	Unilite.Main( {
		id			: 'pmr400skrvApp',
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
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('PRODT_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('PRODT_DATE_TO', UniDate.get('today'));
			
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('PRODT_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('PRODT_DATE_TO', UniDate.get('today'));
			
			panelSearch.setValue('WORK_SHOP_CODE'		, 'WC40');
			panelResult.setValue('WORK_SHOP_CODE'		, 'WC40');
			
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore.loadStoreRecords();
			}
		},
		onResetButtonDown: function() {		// 새로고침 버튼
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();
			
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		}
	});
};
</script>
