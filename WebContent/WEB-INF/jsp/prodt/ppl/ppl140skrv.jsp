<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ppl140skrv"  >
	<t:ExtComboStore comboType="BOR120" /> 						 <!-- 사업장 -->
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
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
	Unilite.defineModel('Ppl140skrvModel', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'					, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'						, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'ITEM_NAME1'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>1'					, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'						, type: 'string'},
			{name: 'PRODT_PLAN_YYMM'	, text: '<t:message code="system.label.product.productionplanyearmonth" default="생산계획년월"/>'	, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'					, type: 'string' , comboType:"W"},
			{name: 'TOT_Q'				, text: '<t:message code="system.label.product.monthlytotal" default="월합계"/>'				, type: 'uniQty'},
			{name: 'Day1_Q'				, text: '1<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day2_Q'				, text: '2<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day3_Q'				, text: '3<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day4_Q'				, text: '4<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day5_Q'				, text: '5<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day6_Q'				, text: '6<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day7_Q'				, text: '7<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day8_Q'				, text: '8<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day9_Q'				, text: '9<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day10_Q'			, text: '10<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day11_Q'			, text: '11<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day12_Q'			, text: '12<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day13_Q'			, text: '13<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day14_Q'			, text: '14<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day15_Q'			, text: '15<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day16_Q'			, text: '16<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day17_Q'			, text: '17<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day18_Q'			, text: '18<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day19_Q'			, text: '19<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day20_Q'			, text: '20<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day21_Q'			, text: '21<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day22_Q'			, text: '22<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day23_Q'			, text: '23<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day24_Q'			, text: '24<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day25_Q'			, text: '25<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day26_Q'			, text: '26<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day27_Q'			, text: '27<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day28_Q'			, text: '28<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day29_Q'			, text: '29<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day30_Q'			, text: '30<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'},
			{name: 'Day31_Q'			, text: '31<t:message code="system.label.product.day" default="일"/>' 						, type: 'uniQty'}
		]
	});		//End of Unilite.defineModel('Ppl140skrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var MasterStore = Unilite.createStore('ppl140skrvMasterStore',{
			model: 'Ppl140skrvModel',
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
					read: 'ppl140skrvService.selectList'
				}
			},
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
			listeners: {
				load: function(store, records, successful, eOpts) {
					if(MasterStore.count() == 0)	{
						UniAppManager.setToolbarButtons('reset', false);
				}
			}},
			groupField: 'WORK_SHOP_CODE'
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
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value: UserInfo.divCode,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
							panelSearch.setValue('WORK_SHOP_CODE','');
						}
					}
			},{
				fieldLabel: '<t:message code="system.label.product.planmonth" default="계획월"/>',
				xtype: 'uniMonthRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName:'ORDER_DATE_TO',
				allowBlank: false,
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('ORDER_DATE_FR',newValue);
						}
					},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'W',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
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
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					textFieldWidth:170,
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
		}],
		setAllFieldsReadOnly: function(b) {
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
																		return !field.validate();
																	});

					if(invalid.length > 0) {
						r=false;
						var labelText = ''

						if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
							var labelText = invalid.items[0]['fieldLabel']+' : ';
						} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
							var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
						}

						Unilite.messageBox(labelText+Msg.sMB083);
						invalid.items[0].focus();
					} else {
					//	this.mask();
					}
				} else {
					this.unmask();
				}
				return r;
			}
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
			items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
						panelResult.setValue('WORK_SHOP_CODE','');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.planmonth" default="계획월"/>',
				xtype: 'uniMonthRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName:'ORDER_DATE_TO',
				allowBlank: false,
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();

					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_TO',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'W',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
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
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					textFieldWidth:170,
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
	 * @type
	 */
	var masterGrid = Unilite.createGrid('ppl140skrvGrid',{
		region: 'center' ,
		layout : 'fit',
		store : MasterStore,
		uniOpt:{
			expandLastColumn: true,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
			{id : 'masterGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'DIV_CODE'			, width: 10	 , hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 90  , locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					   return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
				}
			},
			{dataIndex: 'ITEM_NAME'			, width: 130 , locked: true},
			{dataIndex: 'ITEM_NAME1'		, width: 130 , locked: true , hidden: true},
			{dataIndex: 'SPEC'				, width: 130 , locked: true},
			{dataIndex: 'PRODT_PLAN_YYMM'	, width: 95  , locked: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 120 , locked: true},
			{dataIndex: 'TOT_Q'				, width: 110 , locked: true, summaryType: 'sum'},
			{dataIndex: 'Day1_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day2_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day3_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day4_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day5_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day6_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day7_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day8_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day9_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day10_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day11_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day12_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day13_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day14_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day15_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day16_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day17_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day18_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day19_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day20_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day21_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day22_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day23_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day24_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day25_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day26_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day27_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day28_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day29_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day30_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'Day31_Q'			, width: 90, summaryType: 'sum'}
		]
	});		//End of var masterGrid1 = Unilite.createGrid('ppl140skrvGrid1', {

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
		id: 'ppl140skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();

			console.log("viewLocked : ", viewLocked);
			console.log("viewNormal : ", viewNormal);

			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			UniAppManager.setToolbarButtons('reset', true);
			}
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
			MasterStore.clearData();
		}
	});		//End of Unilite.Main({
};
</script>