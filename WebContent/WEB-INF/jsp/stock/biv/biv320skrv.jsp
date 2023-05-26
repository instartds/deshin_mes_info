<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv320skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="biv320skrv"  /> 						<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 							<!-- 품목계정 -->
	<t:ExtComboStore comboType="O" storeId="whList" />   							<!--창고(전체) -->
	<t:ExtComboStore comboType="AU" comboCode="B036" />								<!-- 수불방법 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의
	 * @type
	 */

	Unilite.defineModel('Biv320skrvModel1', {
		fields: [
			{name: 'ITEM_ACCOUNT',	text:'<t:message code="system.label.inventory.account" default="계정"/>',			type:'string'},
			{name: 'ACCOUNT1',		text:'<t:message code="system.label.inventory.accountcode" default="계정코드"/>',	type:'string'},
			{name: 'ITEM_CODE',		text:'<t:message code="system.label.inventory.item" default="품목"/>',			type:'string'},
			{name: 'ITEM_NAME',		text:'<t:message code="system.label.inventory.itemname" default="품목명"/>',		type:'string'},
			{name: 'SPEC',			text:'<t:message code="system.label.inventory.spec" default="규격"/>',			type:'string'},
			{name: 'STOCK_UNIT',	text:'<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',	type:'string'},
			{name: 'INOUT_DATE',	text:'<t:message code="system.label.inventory.tranyearmonth" default="수불년월"/>',	type:'string'},
			{name: 'BASIS_Q',		text:'<t:message code="system.label.inventory.basicqty" default="기초수량"/>',		type:'uniQty'},
			{name: 'BASIS_I',		text:'<t:message code="system.label.inventory.basicamount" default="기초금액"/>',	type:'uniPrice'},
			{name: 'IN_Q',			text:'<t:message code="system.label.inventory.receiptqty1" default="입고수량"/>',	type:'uniQty'},
			{name: 'IN_I',			text:'<t:message code="system.label.inventory.receiptamount" default="입고금액"/>',	type:'uniPrice'},
			{name: 'MOVE_IN_Q',		text:'<t:message code="" default="이동입고수량"/>',	type:'uniQty'},
			{name: 'MOVE_IN_I',		text:'<t:message code="" default="이동입고금액"/>',	type:'uniPrice'},
			{name: 'ETC_IN_Q',		text:'<t:message code="" default="대체입고수량"/>',	type:'uniQty'},
			{name: 'ETC_IN_I',		text:'<t:message code="" default="대체입고금액"/>',	type:'uniPrice'},
			{name: 'OUT_Q',			text:'<t:message code="system.label.inventory.issueqty2" default="출고수량"/>',		type:'uniQty'},
			{name: 'OUT_I',			text:'<t:message code="system.label.inventory.issueamount" default="출고금액"/>',	type:'uniPrice'},
			{name: 'MOVE_OUT_Q',	text:'<t:message code="" default="이동출고수량"/>',	type:'uniQty'},
			{name: 'MOVE_OUT_I',	text:'<t:message code="" default="이동출고금액"/>',	type:'uniPrice'},
			{name: 'ETC_OUT_Q',		text:'<t:message code="" default="대체출고수량"/>',	type:'uniQty'},
			{name: 'ETC_OUT_I',		text:'<t:message code="" default="대체출고금액"/>',	type:'uniPrice'},
			{name: 'STOCK_Q',		text:'<t:message code="system.label.inventory.inventoryqty2" default="재고수량"/>',		type:'uniQty'},
			{name: 'STOCK_I',		text:'<t:message code="system.label.inventory.inventoryamount" default="재고금액"/>',	type:'uniPrice'},
			{name: 'AVERAGE_P',		text:'<t:message code="system.label.inventory.inventoryprice" default="재고단가"/>',	type:'uniPrice'},
			{name: 'SORT_FLAG',		text:'SORT_FLAG',type:'string'}
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('biv320skrvMasterStore1',{
		model: 'Biv320skrvModel1',
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
				//비고(*) 사용않함
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				   read: 'biv320skrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			if(Ext.isEmpty(param.ITEM_ACCOUNT)){
				param.ITEM_ACCOUNT = '';
			}
			if(Ext.isEmpty(param.WH_CODE)){
				param.WH_CODE = '';
			}
			param.rdoSelect = '1' + param.rdoSelect; //품목1
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var directMasterStore2 = Unilite.createStore('biv320skrvMasterStore2',{
		model: 'Biv320skrvModel1',
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false		 // prev | newxt 버튼 사용
				//비고(*) 사용않함
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				   read: 'biv320skrvService.selectList'
			}
		},
		loadStoreRecords : function()  {
			var param= Ext.getCmp('searchForm').getValues();
			if(Ext.isEmpty(param.ITEM_ACCOUNT)){
				param.ITEM_ACCOUNT = '';
			}
			if(Ext.isEmpty(param.WH_CODE)){
				param.WH_CODE = '';
			}
			param.rdoSelect = '2' + param.rdoSelect; //창고2
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		collapsed: true,
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
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
					child:'WH_CODE',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.account" default="계정"/>',
					name: 'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
					//20200302 추가: 멀티선택
					multiSelect: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.tranyearmonth" default="수불년월"/>',
	 				width: 315,
					xtype: 'uniMonthRangefield',
					startFieldName: 'FR_INOUT_DATE',
					endFieldName: 'TO_INOUT_DATE',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					allowBlank: false,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FR_INOUT_DATE',newValue);
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('TO_INOUT_DATE',newValue);
						}
					}
				 },
					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
						valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						validateBlank: false,
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
							//20200703 추가
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
					}),{
						fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
						name:'WH_CODE',
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('whList'),
						//20200302 추가: 멀티선택
						multiSelect: true,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WH_CODE', newValue);
						}
					}
					},{
						xtype: 'radiogroup',
						fieldLabel: '<t:message code="system.label.inventory.outsourcingstockinclusion" default="외주재고포함여부"/>',
						labelWidth: 100,
						//name: 'RADIO',
						items : [{
							boxLabel: '<t:message code="system.label.inventory.notinclusion" default="포함안함"/>',
							width: 80,
							name: 'rdoSelect',
							inputValue: 'N',
							checked: true
						},{
							boxLabel: '<t:message code="system.label.inventory.inclusion" default="포함"/>',
							width: 80,
							name: 'rdoSelect',
							inputValue: 'Y'
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
								panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
							}
						}
					},{
						xtype: 'radiogroup',
						fieldLabel: '<t:message code="system.label.inventory.inventorymovementincludeyn" default="재고이동포함여부"/>',
						labelWidth: 100,
						//name: 'RADIO',
						items : [{
							boxLabel: '<t:message code="system.label.inventory.inclusion" default="포함"/>',
							width: 80,
							name: 'rdoSelect2',
							inputValue: 'Y'
						},{
							boxLabel: '<t:message code="system.label.inventory.notinclusion" default="포함안함"/>',
							width: 80,
							name: 'rdoSelect2',
							inputValue: 'N',
							checked: true
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
							}
						}
					},{
						xtype: 'radiogroup',
						fieldLabel: '<t:message code="system.label.inventory.inventorymanageobject" default="재고관리대상"/>',
						labelWidth: 100,
						//name: 'RADIO',
						items : [{
							boxLabel: '<t:message code="system.label.inventory.whole" default="전체"/>',
							width: 80,
							name: 'rdoSelect3',
							inputValue: ''
						},{
							boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
							width: 80,
							name: 'rdoSelect3',
							inputValue: 'Y',
							checked: true
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
							}
						}
					}]
			}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
					fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					//comboCode: 'B001',
					child:'WH_CODE',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.inventory.account" default="계정"/>',
					name: 'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
					//20200302 추가: 멀티선택
					multiSelect: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},{
						fieldLabel: '<t:message code="system.label.inventory.tranyearmonth" default="수불년월"/>',
						labelWidth: 120,
						xtype: 'uniMonthRangefield',
						startFieldName: 'FR_INOUT_DATE',
						endFieldName: 'TO_INOUT_DATE',
						startDate: UniDate.get('startOfMonth'),
						endDate: UniDate.get('today'),
						allowBlank: false,
						onStartDateChange: function(field, newValue, oldValue, eOpts) {
							if(panelResult) {
								panelSearch.setValue('FR_INOUT_DATE',newValue);
							}
						},
						onEndDateChange: function(field, newValue, oldValue, eOpts) {
							if(panelResult) {
								panelSearch.setValue('TO_INOUT_DATE',newValue);
							}
						}
				 },
					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
						valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						validateBlank: false,
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
							//20200703 추가
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
					}),{
						fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
						name:'WH_CODE',
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('whList'),
						//20200302 추가: 멀티선택
						multiSelect: true,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('WH_CODE', newValue);
							}
						}
					},{
						xtype: 'radiogroup',
						fieldLabel: '<t:message code="system.label.inventory.outsourcingstockinclusion" default="외주재고포함여부"/>',
						labelWidth: 120,
						//name: 'RADIO',
						items : [{
							boxLabel: '<t:message code="system.label.inventory.notinclusion" default="포함안함"/>',
							width: 80,
							name: 'rdoSelect',
							inputValue: 'N',
							checked: true
						},{
							boxLabel: '<t:message code="system.label.inventory.inclusion" default="포함"/>',
							width: 80,
							name: 'rdoSelect',
							inputValue: 'Y'
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
								panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
							}
						}
					}]
	});


	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type
	 */

	var masterGrid1 = Unilite.createGrid('biv320skrvGrid1', {
		region: 'center' ,
		layout : 'fit',
		title: '<t:message code="system.label.inventory.itemby" default="품목별"/>',
		uniOpt:{	expandLastColumn: false,
					useRowNumberer: true,
					useMultipleSorting: true
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(record.get('SORT_FLAG') == '2'){	//합계행
					cls = 'x-change-cell_light';
				}
				return cls;
			}
		},
//		tbar: [{
//			text:'상세보기',
//			handler: function() {
//				var record = masterGrid.getSelectedRecord();
//				if(record) {
//					openDetailWindow(record);
//				}
//			}
//		}],
		store: directMasterStore1,
//		features: [{
//			id: 'masterGridSubTotal',
//			ftype: 'uniGroupingsummary',
//			showSummaryRow: false
//		},{
//			id: 'masterGridTotal',
//			ftype: 'uniSummary',
//			showSummaryRow: false
//		}],
		columns:  [
			{dataIndex: 'ITEM_ACCOUNT', width: 100},
//			{dataIndex: 'ACCOUNT1',		width: 73},
			{dataIndex: 'ITEM_CODE',	width: 100},
			{dataIndex: 'ITEM_NAME',	width: 200},
			{dataIndex: 'SPEC',			width: 200},
			{dataIndex: 'STOCK_UNIT',	width: 100, align: 'center'},
			{dataIndex: 'INOUT_DATE',	width: 100, align: 'center'},
			{ text:'기초',	id:'BASIS_BY_ITEM', columns:  [
			  	{dataIndex: 'BASIS_Q',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'BASIS_I',width: 130,summaryType: 'sum' }
			]},
			{ text:'입고',	id:'IN_BY_ITEM', columns:  [
			  	{dataIndex: 'IN_Q',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'IN_I',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'MOVE_IN_Q',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'MOVE_IN_I',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'ETC_IN_Q',width: 130,summaryType: 'sum'},
			  	{dataIndex: 'ETC_IN_I',width: 130,summaryType: 'sum'}
			]},
			{ text:'출고',	id:'OUT_BY_ITEM', columns:  [
			  	{dataIndex: 'OUT_Q',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'OUT_I',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'MOVE_OUT_Q',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'MOVE_OUT_I',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'ETC_OUT_Q',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'ETC_OUT_I',width: 130,summaryType: 'sum' }
			]},
			{ text:'재고',	id:'STOCK_BY_ITEM', columns:  [
			  	{dataIndex: 'STOCK_Q',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'STOCK_I',width: 130,summaryType: 'sum' },
				{dataIndex: 'AVERAGE_P',width: 130}
			]}

			]
	});

	 var masterGrid2 = Unilite.createGrid('biv320skrvGrid2', {
		region: 'center' ,
		layout : 'fit',
		title: '<t:message code="system.label.inventory.warehouseby" default="창고별"/>',
		store : directMasterStore2,
		uniOpt:{	expandLastColumn: false,
					useRowNumberer: true,
					useMultipleSorting: true
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(record.get('SORT_FLAG') == '2'){	//합계행
					cls = 'x-change-cell_light';
				}
				return cls;
			}
		},
//		tbar: [{
//			text:'상세보기',
//			handler: function() {
//				var record = masterGrid.getSelectedRecord();
//				if(record) {
//					openDetailWindow(record);
//				}
//			}
//		}],
//		features: [{
//			id: 'masterGridSubTotal2',
//			ftype: 'uniGroupingsummary2',
//			showSummaryRow: false
//		},{
//			id: 'masterGridTotal',
//			ftype: 'uniSummary',
//			showSummaryRow: false
//		}],
		columns:  [
			{dataIndex: 'ITEM_ACCOUNT', width: 100},
//			{dataIndex: 'ACCOUNT1',		width: 73},
			{dataIndex: 'ITEM_CODE',	width: 100},
			{dataIndex: 'ITEM_NAME',	width: 200},
			{dataIndex: 'SPEC',			width: 200},
			{dataIndex: 'STOCK_UNIT',	width: 100, align: 'center'},
			{dataIndex: 'INOUT_DATE',	width: 100, align: 'center'},
			{ text:'기초',	id:'BASIS_BY_WH', columns:  [
			  	{dataIndex: 'BASIS_Q',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'BASIS_I',width: 130,summaryType: 'sum' }
			]},
			{ text:'입고',	id:'IN_BY_WH', columns:  [
			  	{dataIndex: 'IN_Q',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'IN_I',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'MOVE_IN_Q',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'MOVE_IN_I',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'ETC_IN_Q',width: 130,summaryType: 'sum'},
			  	{dataIndex: 'ETC_IN_I',width: 130,summaryType: 'sum'}
			]},
			{ text:'출고',	id:'OUT_BY_WH', columns:  [
			  	{dataIndex: 'OUT_Q',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'OUT_I',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'MOVE_OUT_Q',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'MOVE_OUT_I',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'ETC_OUT_Q',width: 130,summaryType: 'sum'},
			  	{dataIndex: 'ETC_OUT_I',width: 130,summaryType: 'sum'}
			]},
			{ text:'재고',	id:'STOCK_BY_WH', columns:  [
			  	{dataIndex: 'STOCK_Q',width: 130,summaryType: 'sum' },
			  	{dataIndex: 'STOCK_I',width: 130,summaryType: 'sum' },
				{dataIndex: 'AVERAGE_P',width: 130},
			]}
			]
	});

	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab: 0,
		region: 'center',
		items: [
			 masterGrid1,
			 masterGrid2
		]
	});
	Unilite.Main( {
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
		id  : 'biv320skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'biv320skrvGrid1'){
				directMasterStore1.loadStoreRecords();
			}else{
				directMasterStore2.loadStoreRecords();
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};
</script>