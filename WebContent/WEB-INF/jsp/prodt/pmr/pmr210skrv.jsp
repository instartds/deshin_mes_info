<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr210skrv"  >
	<t:ExtComboStore comboType="BOR120"  />		<!-- 사업장 -->
	<t:ExtComboStore comboType="W" />			<!-- 작업장  -->
</t:appConfig>
<style type="text/css">

.x-change-cell {
background-color: #FFFFC6;
}
.x-change-cell2 {
background-color: #FDE3FF;
}
</style>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Pmr210skrvModel', {
		fields: [	  
			{name: 'WORK_SHOP_NAME'	,text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'		,type: 'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.product.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'ITEM_NAME1'		,text: '<t:message code="system.label.product.itemname" default="품목명"/>1'			,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.product.spec" default="규격"/>'					,type: 'string'},
			{name: 'STOCK_UNIT'		,text: '<t:message code="system.label.product.unit" default="단위"/>'					,type: 'string'},
			{name: 'PRODT_Q'		,text: '<t:message code="system.label.product.totalproductionqty" default="총생산량"/>'	,type: 'uniQty'},
			{name: 'GOOD_Q'			,text: '<t:message code="system.label.product.goodoutputqty" default="양품생산량"/>'		,type: 'uniQty'},
			{name: 'BAD_Q'			,text: '<t:message code="system.label.product.defectoutputqty" default="불량생산량"/>'	,type: 'uniQty'},
			{name: 'YIELD_RATE'		,text: '수율(%)'	,type: 'uniQty'},
			{name: 'IN_STOCK_Q'		,text: '<t:message code="system.label.product.totalreceiptqty" default="총입고량"/>'	,type: 'uniQty'},
			{name: 'MAN_HOUR'		,text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'			,type: 'uniQty'},
			{name: 'DAY_01'			,text: '1<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_02'			,text: '2<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_03'			,text: '3<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_04'			,text: '4<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_05'			,text: '5<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_06'			,text: '6<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_07'			,text: '7<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_08'			,text: '8<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_09'			,text: '9<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_10'			,text: '10<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_11'			,text: '11<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_12'			,text: '12<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_13'			,text: '13<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_14'			,text: '14<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_15'			,text: '15<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_16'			,text: '16<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_17'			,text: '17<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_18'			,text: '18<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_19'			,text: '19<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_20'			,text: '20<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_21'			,text: '21<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_22'			,text: '22<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_23'			,text: '23<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_24'			,text: '24<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_25'			,text: '25<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_26'			,text: '26<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_27'			,text: '27<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_28'			,text: '28<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_29'			,text: '29<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_30'			,text: '30<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			{name: 'DAY_31'			,text: '31<t:message code="system.label.product.day" default="일"/>'					,type: 'uniPrice'},
			
			{name: 'EQUIP_CODE'		,text: '설비'					,type: 'string'},
			{name: 'EQUIP_NAME'		,text: '설비명'					,type: 'string'},
			{name: 'MOLD_CODE'		,text: '금형'					,type: 'string'},
			{name: 'MOLD_NAME'		,text: '금형명'					,type: 'string'}
			
		]
	}); //End of Unilite.defineModel('Ppl210skrvModel', {



	/** Store 정의(Service 정의)
	 * @type 
	 */	
	var directMasterStore1 = Unilite.createStore('pmr210skrvMasterStore1',{
		model: 'Pmr210skrvModel',
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api	: {
				read: 'pmr210skrvService.selectList'
			}
		},
		loadStoreRecords: function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var directMasterStore2 = Unilite.createStore('pmr210skrvMasterStore2',{
		model: 'Pmr210skrvModel',
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api	: {
				read: 'pmr210skrvService.selectList2'
			}
		},
		loadStoreRecords: function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField:'EQUIP_NAME'
	});

	var directMasterStore3 = Unilite.createStore('pmr210skrvMasterStore3',{
		model: 'Pmr210skrvModel',
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api	: {
				read: 'pmr210skrvService.selectList3'
			}
		},
		loadStoreRecords: function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField:'MOLD_NAME'
	});
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed:true,
		listeners: {
			collapse: function () {
				topSearch.show();
			},
			expand: function() {
				topSearch.hide();
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
				allowBlank:false,
				value : UserInfo.divCode,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							topSearch.setValue('DIV_CODE', newValue);
							panelSearch.setValue('WORK_SHOP_CODE','');
						}
					}
			},{
				fieldLabel: '<t:message code="system.label.product.basisyearmonth" default="기준년월"/>',
				name: 'PRODT_DATE',
				xtype: 'uniMonthfield', 
				allowBlank:false,
				value: new Date(),
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							topSearch.setValue('PRODT_DATE', newValue);
						}
					}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name:'WORK_SHOP_CODE', 
				xtype: 'uniCombobox', 
				comboType:'W',
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							topSearch.setValue('WORK_SHOP_CODE', newValue);
						},
					beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var prStore = topSearch.getField('WORK_SHOP_CODE').store;
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
				Unilite.popup('ITEM',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					validateBlank	: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							topSearch.setValue('ITEM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								topSearch.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							topSearch.setValue('ITEM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								topSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						}
					}
			}),{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.product.badincludedflag" default="불량포함여부"/>',
				items		: [{
					boxLabel: '<t:message code="system.label.product.yes" default="예"/>', 
					width	: 70, 
					name	: 'INCLUDED_YN',
					inputValue: 'Y'
				},{
					boxLabel: '<t:message code="system.label.product.no" default="아니오"/>', 
					width	: 80,
					name	: 'INCLUDED_YN',
					inputValue: 'N',
					checked	: true 
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						topSearch.getField('INCLUDED_YN').setValue(newValue.INCLUDED_YN);

//						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]
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
	
						alert(labelText+Msg.sMB083);
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
	
	var topSearch = Unilite.createSimpleForm('topSearchForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
			items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120',
				tdAttrs: {width: 300},
				allowBlank:false,
				value : UserInfo.divCode,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
					topSearch.setValue('WORK_SHOP_CODE','');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.basisyearmonth" default="기준년월"/>',
				name: 'PRODT_DATE',
				xtype: 'uniMonthfield', 
				allowBlank:false,
				value: new Date(),
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PRODT_DATE', newValue);
					}
				}
			}, 
				Unilite.popup('ITEM',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					validateBlank:false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelSearch.setValue('ITEM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								topSearch.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelSearch.setValue('ITEM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								topSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name:'WORK_SHOP_CODE', 
				xtype: 'uniCombobox', 
				comboType:'W',
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
						store.clearFilter();
						prStore.clearFilter();
						if(!Ext.isEmpty(topSearch.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == topSearch.getValue('DIV_CODE');
							});
							prStore.filterBy(function(record){
								return record.get('option') == topSearch.getValue('DIV_CODE');
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
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.product.badincludedflag" default="불량포함여부"/>',
				items		: [{
					boxLabel: '<t:message code="system.label.product.yes" default="예"/>', 
					width	: 70, 
					name	: 'INCLUDED_YN',
					inputValue: 'Y'
				},{
					boxLabel: '<t:message code="system.label.product.no" default="아니오"/>', 
					width	: 80,
					name	: 'INCLUDED_YN',
					inputValue: 'N',
					checked	: true 
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('INCLUDED_YN').setValue(newValue.INCLUDED_YN);

//						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('pmr210skrvGrid1', {
		layout : 'fit',
		region:'center',
		store : directMasterStore1, 
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
/*		tbar: [{
			text:'상세보기',
			handler: function() {
				var record = masterGrid.getSelectedRecord();
				if(record) {
					openDetailWindow(record);
				}
			}
		}],*/
		features: [ 
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [	
			{dataIndex: 'WORK_SHOP_NAME', width: 100, locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.customtotal" default="거래처계"/>', '<t:message code="system.label.product.total" default="총계"/>');
			}},
			{dataIndex: 'ITEM_CODE'		, width: 106, locked: true},
			{dataIndex: 'ITEM_NAME'		, width: 140, locked: true},
			{dataIndex: 'ITEM_NAME1'	, width: 140, locked: true, hidden: true},
			{dataIndex: 'SPEC'			, width: 133},
			{dataIndex: 'STOCK_UNIT'	, width: 93},
			{dataIndex: 'PRODT_Q'		, width: 93, summaryType:'sum'},
			{dataIndex: 'GOOD_Q'		, width: 93, summaryType:'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'BAD_Q'			, width: 93, summaryType:'sum'},   
			{dataIndex: 'YIELD_RATE'	, width: 80},   
			{dataIndex: 'IN_STOCK_Q'	, width: 93, summaryType:'sum'},
			{dataIndex: 'MAN_HOUR'		, width: 93, summaryType:'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'DAY_01'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_02'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_03'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_04'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_05'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_06'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_07'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_08'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_09'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_10'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_11'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_12'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_13'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_14'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_15'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_16'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_17'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_18'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_19'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_20'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_21'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_22'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_23'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_24'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_25'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_26'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_27'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_28'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_29'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_30'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_31'		, width: 93, summaryType:'sum'}
		] 
	});

	var masterGrid2 = Unilite.createGrid('pmr210skrvGrid2', {
		layout : 'fit',
		region:'center',
		store : directMasterStore2, 
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
/*		tbar: [{
			text:'상세보기',
			handler: function() {
				var record = masterGrid.getSelectedRecord();
				if(record) {
					openDetailWindow(record);
				}
			}
		}],*/
		features: [ 
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [	
			{dataIndex: 'WORK_SHOP_NAME', width: 100, locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.customtotal" default="거래처계"/>', '<t:message code="system.label.product.total" default="총계"/>');
			}},
			{dataIndex: 'ITEM_CODE'		, width: 106, locked: true},
			{dataIndex: 'ITEM_NAME'		, width: 140, locked: true},
			{dataIndex: 'ITEM_NAME1'	, width: 140, locked: true, hidden: true},
			{dataIndex: 'SPEC'			, width: 133},
			{dataIndex: 'STOCK_UNIT'	, width: 93},
			{dataIndex: 'PRODT_Q'		, width: 93, summaryType:'sum'},
			{dataIndex: 'GOOD_Q'		, width: 93, summaryType:'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'BAD_Q'			, width: 93, summaryType:'sum'},   
			{dataIndex: 'YIELD_RATE'	, width: 80},   
			{dataIndex: 'IN_STOCK_Q'	, width: 93, summaryType:'sum'},
			{dataIndex: 'MAN_HOUR'		, width: 93, summaryType:'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'DAY_01'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_02'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_03'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_04'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_05'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_06'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_07'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_08'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_09'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_10'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_11'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_12'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_13'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_14'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_15'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_16'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_17'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_18'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_19'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_20'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_21'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_22'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_23'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_24'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_25'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_26'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_27'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_28'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_29'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_30'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_31'		, width: 93, summaryType:'sum'},
			
			{dataIndex: 'EQUIP_CODE'	, width: 10,hidden:true},
			{dataIndex: 'EQUIP_NAME'	, width: 10,hidden:true}
			
			
			
		] 
	});
	
		var masterGrid3 = Unilite.createGrid('pmr210skrvGrid3', {
		layout : 'fit',
		region:'center',
		store : directMasterStore3, 
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
/*		tbar: [{
			text:'상세보기',
			handler: function() {
				var record = masterGrid.getSelectedRecord();
				if(record) {
					openDetailWindow(record);
				}
			}
		}],*/
		features: [ 
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [	
			{dataIndex: 'WORK_SHOP_NAME', width: 100, locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.customtotal" default="거래처계"/>', '<t:message code="system.label.product.total" default="총계"/>');
			}},
			{dataIndex: 'ITEM_CODE'		, width: 106, locked: true},
			{dataIndex: 'ITEM_NAME'		, width: 140, locked: true},
			{dataIndex: 'ITEM_NAME1'	, width: 140, locked: true, hidden: true},
			{dataIndex: 'SPEC'			, width: 133},
			{dataIndex: 'STOCK_UNIT'	, width: 93},
			{dataIndex: 'PRODT_Q'		, width: 93, summaryType:'sum'},
			{dataIndex: 'GOOD_Q'		, width: 93, summaryType:'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'BAD_Q'			, width: 93, summaryType:'sum'},   
			{dataIndex: 'YIELD_RATE'	, width: 80},   
			{dataIndex: 'IN_STOCK_Q'	, width: 93, summaryType:'sum'},
			{dataIndex: 'MAN_HOUR'		, width: 93, summaryType:'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'DAY_01'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_02'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_03'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_04'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_05'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_06'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_07'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_08'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_09'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_10'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_11'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_12'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_13'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_14'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_15'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_16'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_17'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_18'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_19'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_20'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_21'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_22'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_23'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_24'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_25'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_26'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_27'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_28'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_29'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_30'		, width: 93, summaryType:'sum'},
			{dataIndex: 'DAY_31'		, width: 93, summaryType:'sum'},
			
			
			{dataIndex: 'MOLD_CODE'	, width: 10,hidden:true},
			{dataIndex: 'MOLD_NAME'	, width: 10,hidden:true}
		] 
	});
	
	var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab: 0,
	    region: 'center',
	    items: [{
	    	title: '품목별',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[masterGrid1],
	    	id: 'tab1'
	    },{
	    	title: '설비별',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[masterGrid2],
	    	id: 'tab2' 
	    },{
	    	title: '금형별',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[masterGrid3],
	    	id: 'tab3' 
	    }],
		listeners : {
			beforetabchange : function ( tabPanel, newCard, oldCard, eOpts )  {
				if(!topSearch.getInvalidMessage()) return false;   // 필수체크
			},
			tabChange : function ( tabPanel, newCard, oldCard, eOpts )  {
				var newTabId = newCard.getId();
				if(newTabId == 'tab1'){
					directMasterStore1.loadStoreRecords();
				}else if(newTabId == 'tab2'){
					directMasterStore2.loadStoreRecords();
				}else if(newTabId == 'tab3'){
					directMasterStore3.loadStoreRecords();
				}
			}
	    }
	});
	
	
	

	Unilite.Main({
		id			: 'ppl210skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				 topSearch, tab
			]
		},
		panelSearch
		],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);

			panelSearch.setValue('PRODT_DATE',new Date());
			topSearch.setValue('PRODT_DATE',new Date());
		},
		onQueryButtonDown : function() {
			if(!topSearch.getInvalidMessage()) return;	//필수체크
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'tab1') {
				directMasterStore1.loadStoreRecords();
			}else if(activeTabId == 'tab2') {
				directMasterStore2.loadStoreRecords();
			}else if(activeTabId == 'tab3') {
				directMasterStore3.loadStoreRecords();
			}
		
		}
	});
};
</script>