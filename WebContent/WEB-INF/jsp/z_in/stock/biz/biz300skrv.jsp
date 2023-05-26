<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biz300skrv"  >
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />	<!-- 품목계정 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >
function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Biz300skrvModel1', {
		fields: [ 
			{name: 'DIV_CODE'			,text:'<t:message code="system.label.inventory.division" default="사업장"/>'					,type:'string'},
			{name: 'ITEM_ACCOUNT'		,text:'<t:message code="system.label.inventory.account" default="계정"/>'						,type:'string'},
			{name: 'ITEM_ACCOUNTNAME'	,text: '<t:message code="system.label.inventory.account" default="계정"/>'					,type:'string'},
			{name: 'ITEM_CODE'			,text:'<t:message code="system.label.inventory.item" default="품목"/>'						,type:'string'},
			{name: 'ITEM_NAME'			,text:'<t:message code="system.label.inventory.itemname" default="품목명"/>'					,type:'string'},
			{name: 'SPEC'				,text:'<t:message code="system.label.inventory.spec" default="규격"/>'						,type:'string'},
			{name: 'STOCK_UNIT'			,text:'<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'				,type:'string'},
			{name: 'STOCK_P'			,text:'<t:message code="system.label.inventory.inventoryprice" default="재고단가"/>'			,type:'uniUnitPrice'},
			{name: 'STOCK_Q'			,text:'<t:message code="system.label.inventory.inventoryqty2" default="재고수량"/>'				,type:'uniQty'},
			{name: 'STOCK_I'			,text:'<t:message code="system.label.inventory.inventoryamount" default="재고금액"/>'			,type:'uniPrice'},
			{name: 'GOOD_STOCK_Q'		,text:'<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>'				,type:'uniQty'},
			{name: 'GOOD_STOCK_I'		,text:'<t:message code="system.label.inventory.goodstockamount" default="양품재고금액"/>'			,type:'uniPrice'},
			{name: 'BAD_STOCK_Q'		,text:'<t:message code="system.label.inventory.defectinventoryqty" default ="불량재고량"/>'		,type:'uniQty'},
			{name: 'BAD_STOCK_I'		,text:'<t:message code="system.label.inventory.defectinventoryamount" default="불량재고금액"/>'	,type:'uniPrice'}
		 ]
	});	// end of Unilite.defineModel('Biz300skrvModel1', {

	Unilite.defineModel('Biz300skrvModel2', {
		fields: [ 
			{name: 'DIV_CODE'			,text:'<t:message code="system.label.inventory.division" default="사업장"/>'					,type:'string'},
			{name: 'CUSTOM_CODE'		,text:'<t:message code="system.label.inventory.custom" default="거래처"/>'						,type:'string'},
			{name: 'CUSTOM_NAME'		,text:'<t:message code="system.label.inventory.subcontractor" default="외주처"/>'				,type:'string'},
			{name: 'ITEM_CODE'			,text:'<t:message code="system.label.inventory.item" default="품목"/>'						,type:'string'},
			{name: 'ITEM_NAME'			,text:'<t:message code="system.label.inventory.itemname" default="품목명"/>'					,type:'string'},
			{name: 'SPEC'				,text:'<t:message code="system.label.inventory.spec" default="규격"/>'						,type:'string'},
			{name: 'STOCK_UNIT'			,text:'<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'				,type:'string'},
			{name: 'STOCK_P'			,text:'<t:message code="system.label.inventory.inventoryprice" default="재고단가"/>'			,type:'uniUnitPrice'},
			{name: 'STOCK_Q'			,text:'<t:message code="system.label.inventory.inventoryqty2" default="재고수량"/>'				,type:'uniQty'},
			{name: 'STOCK_I'			,text:'<t:message code="system.label.inventory.inventoryamount" default="재고금액"/>'			,type:'uniPrice'},
			{name: 'GOOD_STOCK_Q'		,text:'<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>'				,type:'uniQty'},
			{name: 'GOOD_STOCK_I'		,text:'<t:message code="system.label.inventory.goodstockamount" default="양품재고금액"/>'			,type:'uniPrice'},
			{name: 'BAD_STOCK_Q'		,text:'<t:message code="system.label.inventory.defectinventoryqty" default ="불량재고량"/>'		,type:'uniQty'},
			{name: 'BAD_STOCK_I'		,text:'<t:message code="system.label.inventory.defectinventoryamount" default="불량재고금액"/>'	,type:'uniPrice'}
		 ]
	});


	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('biz300skrvMasterStore1',{
		model	: 'Biz300skrvModel1',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {		 
				read: 'biz300skrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param	= Ext.getCmp('searchForm').getValues();
			param.TYPE	= '1';
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ITEM_ACCOUNTNAME'
	});	// end of var directMasterStore1 =

	var directMasterStore2 = Unilite.createStore('biz300skrvMasterStore2',{
		model	: 'Biz300skrvModel2',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'biz300skrvService.selectList2'
			}
		},
		loadStoreRecords : function()	{
			var param	= Ext.getCmp('searchForm').getValues();
			param.TYPE	= '2';
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'CUSTOM_NAME'
	});



	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {	 
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', { 
				fieldLabel: '<t:message code="system.label.inventory.custom" default="거래처"/>', 
				validateBlank: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE', newValue);
						if(Ext.isEmpty(newValue)) {
							panelSearch.setValue('CUSTOM_NAME', newValue);
							panelResult.setValue('CUSTOM_NAME', newValue);
						}
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);
					},
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.inventory.account" default="계정"/>',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox', 
				comboType: 'AU',
				comboCode: 'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{ 
				fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME', 
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
						if(Ext.isEmpty(newValue)) {
							panelSearch.setValue('ITEM_NAME', newValue);
							panelResult.setValue('ITEM_NAME', newValue);
						}
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					},
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE'),'FIND_TYPE':'00'});
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

					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
				// this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});// End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
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
		},
		Unilite.popup('AGENT_CUST', { 
			fieldLabel: '<t:message code="system.label.inventory.custom" default="거래처"/>', 
			validateBlank: false,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('CUSTOM_NAME', newValue);
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);
				},
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.inventory.account" default="계정"/>',
			name: 'ITEM_ACCOUNT',
			xtype: 'uniCombobox', 
			comboType: 'AU',
			comboCode: 'B020',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{ 
			fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
			valueFieldName: 'ITEM_CODE', 
			textFieldName: 'ITEM_NAME', 
			validateBlank: false,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('ITEM_NAME', newValue);
						panelResult.setValue('ITEM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				},
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE'),'FIND_TYPE':'00'});
				}
			}
		})],
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
				// this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});	 // end of var panelResult = Unilite.createSearchForm('resultForm',{



	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('biz300skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary: true,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel	: true,			// 엑셀 다운로드 사용 여부
				exportGroup	: true,		// group 상태로 export 여부
				onlyData	: false,
				summaryExport : true
			}
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true 
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns: [ 
			{ dataIndex: 'DIV_CODE'			, width: 66	,hidden: true},
			{ dataIndex: 'ITEM_ACCOUNT'		, width: 120,hidden:true,locked:false},
			{ dataIndex: 'ITEM_ACCOUNTNAME'	, width: 120,locked:false, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
			}},
			{ dataIndex: 'ITEM_CODE'		, width: 100,locked:false},
			{ dataIndex: 'ITEM_NAME'		, width: 180,locked:false},
			{ dataIndex: 'SPEC'				, width: 180,locked:false},
			{ dataIndex: 'STOCK_UNIT'		, width: 66 ,locked:false},
			{ dataIndex: 'STOCK_P'			, width: 86 ,hidden: true},
			{
				text	: '<t:message code="system.label.base.totalinventory" default="총재고"/>',
				columns	: [
					{ dataIndex: 'STOCK_Q'			, width: 110, summaryType: 'sum'},
					{ dataIndex: 'STOCK_I'			, width: 110, summaryType: 'sum'}
				]
			},
			{
				text	: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>',
				columns	: [
					{ dataIndex: 'GOOD_STOCK_Q'		, width: 110, summaryType: 'sum'},
					{ dataIndex: 'GOOD_STOCK_I'		, width: 110, summaryType: 'sum'}
				]
			},
			{
				text	: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>',
				columns	: [
					{ dataIndex: 'BAD_STOCK_Q'		, width: 110, summaryType: 'sum'},
					{ dataIndex: 'BAD_STOCK_I'		, width: 110, summaryType: 'sum' }
				]
			}
		]
	});	 // end of var masterGrid = Unilite.createGrid('biz300skrvGrid1', {

	var masterGrid2 = Unilite.createGrid('biz300skrvGrid2', {
		store: directMasterStore2,
		layout : 'fit',
		region:'center',
		uniOpt: {
			useGroupSummary: true,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: true,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns: [ 
			{ dataIndex: 'DIV_CODE'			, width: 66	,hidden: true},
			{ dataIndex: 'CUSTOM_CODE'		, width: 80	,hidden: true},
			{ dataIndex: 'CUSTOM_NAME'		, width: 120,locked:false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');}
			},
			{ dataIndex: 'ITEM_CODE'		, width: 100,locked:false},
			{ dataIndex: 'ITEM_NAME'		, width: 180,locked:false},
			{ dataIndex: 'SPEC'				, width: 180,locked:false},
			{ dataIndex: 'STOCK_UNIT'		, width: 66	,locked:false},
			{ dataIndex: 'STOCK_P'			, width: 86	,hidden: true},
			{
				text	: '<t:message code="system.label.base.totalinventory" default="총재고"/>',
				columns	: [
					{ dataIndex: 'STOCK_Q'			, width: 110, summaryType: 'sum'},
					{ dataIndex: 'STOCK_I'			, width: 110, summaryType: 'sum'}
				]
			},
			{
				text	: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>',
				columns	: [
					{ dataIndex: 'GOOD_STOCK_Q'		, width: 110, summaryType: 'sum'},
					{ dataIndex: 'GOOD_STOCK_I'		, width: 110, summaryType: 'sum'}
				]
			},
			{
				text	: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>',
				columns	: [
					{ dataIndex: 'BAD_STOCK_Q'		, width: 110, summaryType: 'sum'},
					{ dataIndex: 'BAD_STOCK_I'		, width: 110, summaryType: 'sum' }
				]
			}
		]
	}); 

	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab: 0,
		region: 'center',
		items: [{
			 title: '<t:message code="system.label.inventory.itemby" default="품목별"/>'
			 ,xtype:'container'
			 ,layout:{type:'vbox', align:'stretch'}
			 ,items:[masterGrid]
			 ,id: 'biz300skrvGridTab1'
		},{
			 title: '<t:message code="system.label.inventory.parenbyeachsubcontract" default="외주처별"/>'
			 ,xtype:'container'
			 ,layout:{type:'vbox', align:'stretch'}
			 ,items:[masterGrid2]
			 ,id: 'biz300skrvGridTab2' 
		}],
		listeners:  {
			tabChange:  function ( tabPanel, newCard, oldCard, eOpts ) {
//				var newTabId = newCard.getId();
//				console.log("newCard:  " + newCard.getId());
//				console.log("oldCard:  " + oldCard.getId());
//				UniAppManager.setToolbarButtons(['save', 'newData' ], false);
//				panelResult.setAllFieldsReadOnly(false);
//				if(newTabId = 'biz300skrvGridTab'){
//					masterGrid.getStore().loadStoreRecords();
//				}else if(newTabId = 'biz300skrvGridTab2'){
//					masterGrid2.getStore().loadStoreRecords();
//				}
			} 
		}
	});



	Unilite.Main( {
		id  : 'biz300skrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		},
			panelSearch	 
		],  
	fnInitBinding : function() {
		 panelSearch.setValue('DIV_CODE',UserInfo.divCode);
		 UniAppManager.setToolbarButtons('save'	, false);
		 UniAppManager.setToolbarButtons('reset', true);
	},
	onQueryButtonDown : function()	{ 
		if(!panelSearch.getInvalidMessage()) return;	// 필수체크
		var activeTabId = tab.getActiveTab().getId();
		if(activeTabId == 'biz300skrvGridTab1') {
			masterGrid.getStore().loadStoreRecords();
		} else {
			masterGrid2.getStore().loadStoreRecords();
		}
		UniAppManager.setToolbarButtons(['save', 'newData' ], false);
	},
	onResetButtonDown: function() {
		panelSearch.clearForm();
		panelResult.clearForm();
		
		masterGrid.reset();
		masterGrid2.reset();
		masterGrid.getStore().clearData();
		masterGrid2.getStore().clearData();
		
		this.fnInitBinding();
	},
	checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		}
	});
};
</script>