<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_biv320skrv_in"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_biv320skrv_in"  />	<!-- 사업장    -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />				<!-- 품목계정   -->
	<t:ExtComboStore comboType="O" storeId="whList" />				<!-- 창고(전체) -->
	<t:ExtComboStore comboType="AU" comboCode="B036" />				<!-- 수불방법   -->
</t:appConfig>
<script type="text/javascript" >


var transStatusWindows;		//수불상세내역 팝업
var gsRecord;
var gsQueryFlag	= '';

function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_Biv320skrv_inModel1', {
		fields: [
			{name: 'ITEM_ACCOUNT',	text:'<t:message code="system.label.inventory.account" default="계정"/>',				type:'string'},
			{name: 'ACCOUNT1',		text:'<t:message code="system.label.inventory.accountcode" default="계정코드"/>',		type:'string'},
			{name: 'ITEM_CODE',		text:'<t:message code="system.label.inventory.item" default="품목"/>',				type:'string'},
			{name: 'ITEM_NAME',		text:'<t:message code="system.label.inventory.itemname" default="품목명"/>',			type:'string'},
			{name: 'SPEC',			text:'<t:message code="system.label.inventory.spec" default="규격"/>',				type:'string'},
			{name: 'STOCK_UNIT',	text:'<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',		type:'string'},
			{name: 'INOUT_DATE',	text:'<t:message code="system.label.inventory.tranyearmonth" default="수불년월"/>',		type:'string'},
			{name: 'BASIS_Q',		text:'<t:message code="system.label.inventory.basicqty" default="기초수량"/>',			type:'uniQty'},
			{name: 'BASIS_I',		text:'<t:message code="system.label.inventory.basicamount" default="기초금액"/>',		type:'uniPrice'},
			
			{name: 'IN_Q',			text:'<t:message code="system.label.inventory.receiptqty1" default="입고수량"/>',		type:'uniQty'},
			{name: 'IN_I',			text:'<t:message code="system.label.inventory.receiptamount" default="입고금액"/>',		type:'uniPrice'},
			{name: 'MOVE_IN_Q',		text:'<t:message code="" default="이동입고수량"/>',	type:'uniQty'},
			{name: 'MOVE_IN_I',		text:'<t:message code="" default="이동입고금액"/>',	type:'uniPrice'},
			{name: 'ETC_IN_Q',		text:'<t:message code="" default="기타입고수량"/>',	type:'uniQty'},
			{name: 'ETC_IN_I',		text:'<t:message code="" default="기타입고금액"/>',	type:'uniPrice'},

			{name: 'OUT_Q',			text:'<t:message code="system.label.inventory.issueqty2" default="출고수량"/>',			type:'uniQty'},
			{name: 'OUT_I',			text:'<t:message code="system.label.inventory.issueamount" default="출고금액"/>',		type:'uniPrice'},
			{name: 'MOVE_OUT_Q',	text:'<t:message code="" default="이동출고수량"/>',	type:'uniQty'},
			{name: 'MOVE_OUT_I',	text:'<t:message code="" default="이동출고금액"/>',	type:'uniPrice'},
			{name: 'ETC_OUT_Q',		text:'<t:message code="" default="기타출고수량"/>',	type:'uniQty'},
			{name: 'ETC_OUT_I',		text:'<t:message code="" default="기타출고금액"/>',	type:'uniPrice'},

			{name: 'STOCK_Q',		text:'<t:message code="system.label.inventory.inventoryqty2" default="재고수량"/>',		type:'uniQty'},
			{name: 'STOCK_I',		text:'<t:message code="system.label.inventory.inventoryamount" default="재고금액"/>',	type:'uniPrice'},
			{name: 'SORT_FLAG',		text:'SORT_FLAG',type:'string'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_biv320skrv_inMasterStore1',{
		model: 's_Biv320skrv_inModel1',
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {
				read: 's_biv320skrv_inService.selectList'
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
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var directMasterStore2 = Unilite.createStore('s_biv320skrv_inMasterStore2',{
		model	: 's_Biv320skrv_inModel1',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_biv320skrv_inService.selectList'
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
			param.rdoSelect = '2'; //창고조회일시
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	/** 검색조건 (Search Panel)
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
				//comboCode: 'B001',
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
				valueFieldName: 'DIV_PUMOK_CODE',
				textFieldName: 'DIV_PUMOK_NAME',
				listeners: {
					'onValueFieldChange': function(field, newValue, oldValue  ){
						panelResult.setValue('DIV_PUMOK_CODE',newValue);
					},
					'onTextFieldChange':  function( field, newValue, oldValue  ){
						panelResult.setValue('DIV_PUMOK_NAME',newValue);
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel  : '포장형태',
				name		: 'PACK_TYPE',
				xtype	   : 'uniCombobox',
				comboType   : 'AU',
				comboCode   : 'B138'
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.inventory.outsourcingstockinclusion" default="외주재고포함여부"/>',
				labelWidth: 100,
				//name: 'RADIO',
				items : [{
					boxLabel: '<t:message code="system.label.inventory.notinclusion" default="포함안함"/>',
					width: 80,
					name: 'rdoSelect',
					inputValue: '1N',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.inventory.inclusion" default="포함"/>',
					width: 80,
					name: 'rdoSelect',
					inputValue: '1Y'
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
			valueFieldName: 'DIV_PUMOK_CODE',
			textFieldName: 'DIV_PUMOK_NAME',
			listeners: {
				'onValueFieldChange': function(field, newValue, oldValue  ){
					panelSearch.setValue('DIV_PUMOK_CODE',newValue);
				},
				'onTextFieldChange':  function( field, newValue, oldValue  ){
					panelSearch.setValue('DIV_PUMOK_NAME',newValue);
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name:'WH_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('whList'),
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
				inputValue: '1N',
				checked: true
			},{
				boxLabel: '<t:message code="system.label.inventory.inclusion" default="포함"/>',
				width: 80,
				name: 'rdoSelect',
				inputValue: '1Y'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
					panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('s_biv320skrv_inGrid1', {
		store	: directMasterStore1,
		region	: 'center' ,
		layout	: 'fit',
		title	: '<t:message code="system.label.inventory.itemby" default="품목별"/>',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: true
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
//			id: 'masterGridSubTotal',
//			ftype: 'uniGroupingsummary',
//			showSummaryRow: false
//		},{
//			id: 'masterGridTotal',
//			ftype: 'uniSummary',
//			showSummaryRow: false
//		}],
		columns: [
			{dataIndex: 'ITEM_ACCOUNT', width: 100},
//			{dataIndex: 'ACCOUNT1',		width: 73},
			{dataIndex: 'ITEM_CODE',	width: 100},
			{dataIndex: 'ITEM_NAME',	width: 200},
			{dataIndex: 'SPEC',			width: 200},
			{dataIndex: 'STOCK_UNIT',	width: 100, align: 'center'},
			{dataIndex: 'INOUT_DATE',	width: 100, align: 'center'},
			{text:'기초'		, id:'BASIS_BY_ITEM',
				columns: [
					{dataIndex: 'BASIS_Q'	,width: 130,summaryType: 'sum' },
					{dataIndex: 'BASIS_I'	,width: 130,summaryType: 'sum' }
				]
			},
			{ text:'입고'		, id:'IN_BY_ITEM',
				columns: [
					{dataIndex: 'IN_Q'			,width: 130		,summaryType: 'sum' },
					{dataIndex: 'IN_I'			,width: 130		,summaryType: 'sum' },
					{dataIndex: 'MOVE_IN_Q'		,width: 130		,summaryType: 'sum' },
					{dataIndex: 'MOVE_IN_I'		,width: 130		,summaryType: 'sum' },
					{dataIndex: 'ETC_IN_Q'		,width: 130		,summaryType: 'sum' },
					{dataIndex: 'ETC_IN_I'		,width: 130		,summaryType: 'sum' }
				]
			},
			{ text:'출고'		, id:'OUT_BY_ITEM',
				columns: [
					{dataIndex: 'OUT_Q'			,width: 130		,summaryType: 'sum' },
					{dataIndex: 'OUT_I'			,width: 130		,summaryType: 'sum' },
					{dataIndex: 'MOVE_OUT_Q'	,width: 130		,summaryType: 'sum' },
					{dataIndex: 'MOVE_OUT_I'	,width: 130		,summaryType: 'sum' },
					{dataIndex: 'ETC_OUT_Q'		,width: 130		,summaryType: 'sum' },
					{dataIndex: 'ETC_OUT_I'		,width: 130		,summaryType: 'sum' }
				]
			},
			{ text:'재고'		, id:'STOCK_BY_ITEM',
				columns: [
					{dataIndex: 'STOCK_Q'		,width: 130		,summaryType: 'sum' },
					{dataIndex: 'STOCK_I'		,width: 130		,summaryType: 'sum' }
				]
			}
		],
		listeners:{
			onGridDblClick: function(grid, record, cellIndex, colName) {
				//더블클릭한 필드가 입고이면 입고상세, 출고이면 출고상세내역 화면 팝업호출 - 같은 window에 조회조건만 다르게 넘김
				if(UniUtils.indexOf(colName, ['IN_Q', 'IN_I', 'MOVE_IN_Q', 'MOVE_IN_I', 'ETC_IN_Q', 'ETC_IN_I'])) {
//					alert('입고');
					gsQueryFlag = '1';
				} else if(UniUtils.indexOf(colName, ['OUT_Q', 'OUT_I', 'MOVE_OUT_Q', 'MOVE_OUT_I', 'ETC_OUT_Q', 'ETC_OUT_I'])) {
//					alert('출고');
					gsQueryFlag = '2';
				} else {
					return false;
				}
				gsRecord = record;
				openTransStatusWindows();
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('s_biv320skrv_inGrid2', {
		store	: directMasterStore2,
		region	: 'center' ,
		layout	: 'fit',
		title	: '<t:message code="system.label.inventory.warehouseby" default="창고별"/>',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: true
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
			{ text:'기초'		, id:'BASIS_BY_WH',
				columns: [
					{dataIndex: 'BASIS_Q'	,width: 130,summaryType: 'sum' },
					{dataIndex: 'BASIS_I'	,width: 130,summaryType: 'sum' }
				]
			},
			{ text:'입고'		, id:'IN_BY_WH',
				columns: [
					{dataIndex: 'IN_Q'			,width: 130		,summaryType: 'sum' },
					{dataIndex: 'IN_I'			,width: 130		,summaryType: 'sum' },
					{dataIndex: 'MOVE_IN_Q'		,width: 130		,summaryType: 'sum' },
					{dataIndex: 'MOVE_IN_I'		,width: 130		,summaryType: 'sum' },
					{dataIndex: 'ETC_IN_Q'		,width: 130		,summaryType: 'sum' },
					{dataIndex: 'ETC_IN_I'		,width: 130		,summaryType: 'sum' }
				]
			},
			{ text:'출고'		, id:'OUT_BY_WH',
				columns: [
					{dataIndex: 'OUT_Q'			,width: 130		,summaryType: 'sum' },
					{dataIndex: 'OUT_I'			,width: 130		,summaryType: 'sum' },
					{dataIndex: 'MOVE_OUT_Q'	,width: 130		,summaryType: 'sum' },
					{dataIndex: 'MOVE_OUT_I'	,width: 130		,summaryType: 'sum' },
					{dataIndex: 'ETC_OUT_Q'		,width: 130		,summaryType: 'sum' },
					{dataIndex: 'ETC_OUT_I'		,width: 130		,summaryType: 'sum' }
				]
			},
			{ text:'재고'		, id:'STOCK_BY_WH',
				columns: [
					{dataIndex: 'STOCK_Q'		,width: 130		,summaryType: 'sum' },
					{dataIndex: 'STOCK_I'		,width: 130		,summaryType: 'sum' }
				]
			}
		],
		listeners:{
			onGridDblClick: function(grid, record, cellIndex, colName) {
				//더블클릭한 필드가 입고이면 입고상세, 출고이면 출고상세내역 화면 팝업호출 - 같은 window에 조회조건만 다르게 넘김
				if(UniUtils.indexOf(colName, ['IN_Q', 'IN_I', 'MOVE_IN_Q', 'MOVE_IN_I', 'ETC_IN_Q', 'ETC_IN_I'])) {
//					alert('입고');
					gsQueryFlag = '1';
				} else if(UniUtils.indexOf(colName, ['OUT_Q', 'OUT_I', 'MOVE_OUT_Q', 'MOVE_OUT_I', 'ETC_OUT_Q', 'ETC_OUT_I'])) {
//					alert('출고');
					gsQueryFlag = '2';
				} else {
					return false;
				}
				gsRecord = record;
				openTransStatusWindows();
			}
		}
	});



	/** 상세내역 팝업
	 */
	var detailDataForm = Unilite.createSearchForm('detailDataForm', {
		layout		: {type : 'uniTable', columns : 3},
//		height		: 50,
//		width		: 800,
		region		: 'center',
		border		: true,
		padding		: '0 0 0 0',
		xtype		: 'container',
		defaultType	: 'container',
		items:[{
			fieldLabel	: 'DIV_CODE',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.inventory.tranyearmonth" default="수불년월"/>',
			name		: 'INOUT_YM',
			xtype		: 'uniMonthfield',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.inventory.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			readOnly		: true,
			listeners		: {
				'onValueFieldChange': function(field, newValue, oldValue  ){
				},
				'onTextFieldChange':  function( field, newValue, oldValue  ){
				}
			}
		}),{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			width	: 300,
			items	: [{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.inventory.classfication" default="구분"/>',
				id			: 'statusFlag',
				items		: [{
					boxLabel	: '<t:message code="system.label.inventory.receipt" default="입고"/>', 
					width		: 60,
					name		: 'INOUT_TYPE',
					inputValue	: '1',
					readOnly: true
				},{
					boxLabel	: '<t:message code="system.label.inventory.issue" default="출고"/>', 
					width		: 80,
					name		: 'INOUT_TYPE',
					inputValue	: '2',
					readOnly: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		}]
	});
	
	Unilite.defineModel('detailDataModel', {
		fields: [
			{name: 'INOUT_DATE',			text: '<t:message code="system.label.inventory.transdate" default="수불일"/>',		type: 'uniDate'},
			{name: 'METH_NAME',				text: '<t:message code="system.label.inventory.tranmethod2" default="수불형태"/>',	type: 'string'},
			{name: 'INOUT_TYPE_NAME',		text: '<t:message code="system.label.inventory.trantype" default="수불유형"/>',		type: 'string'},
			{name: 'LOT_NO',				text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',		type: 'string'},
			{name: 'INOUT_Q',				text: '<t:message code="system.label.inventory.tranqty" default="수불량"/>',		type: 'uniQty'},
			{name: 'INOUT_P',				text: '<t:message code="system.label.inventory.tranprice" default="수불단가"/>',	type: 'uniUnitPrice'},
			{name: 'INOUT_I',				text: '<t:message code="system.label.inventory.tranamount" default="수불금액"/>',	type: 'uniPrice'},
			{name: 'CREATE_LOC_NAME',		text: '<t:message code="system.label.inventory.creationpath" default="생성경로"/>',	type: 'string'},
			{name: 'COMP_CODE',				text: 'COMP_CODE',			type: 'string'},
			{name: 'DIV_CODE',				text: 'DIV_CODE',			type: 'string'},
			{name: 'INOUT_NUM',				text: 'INOUT_NUM',			type: 'string'},
			{name: 'INOUT_SEQ',				text: 'INOUT_SEQ',			type: 'int'},
			{name: 'INOUT_METH',			text: 'INOUT_METH',			type: 'string'},
			{name: 'INOUT_TYPE_DETAIL',		text: 'INOUT_TYPE_DETAIL',	type: 'string'},
			{name: 'CREATE_LOC',			text: 'CREATE_LOC',			type: 'string'}
		]
	});

	var detailDataStore = Unilite.createStore('detailDataStore', {
		model	: 'detailDataModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 's_biv320skrv_inService.detailDataList'
			}
		},
		loadStoreRecords: function() {
			var param = detailDataForm.getValues();
			console.log(param);
			this.load({
				params: param
			});
		}
	});

	var detailDataGrid = Unilite.createGrid('detailDataGrid', {
		store	: detailDataStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: true
		},
		columns: [
			{ dataIndex: 'INOUT_DATE',			width: 80 },
			{ dataIndex: 'METH_NAME',			width: 80 , align: 'center'},
			{ dataIndex: 'INOUT_TYPE_NAME',		width: 100, align: 'center'},
			{ dataIndex: 'LOT_NO',				width: 100},
			{ dataIndex: 'INOUT_Q',				width: 100},
			{ dataIndex: 'INOUT_P',				width: 100},
			{ dataIndex: 'INOUT_I',				width: 100},
			{ dataIndex: 'CREATE_LOC_NAME',		width: 80 , align: 'center'},
			{ dataIndex: 'COMP_CODE',			width: 100, hidden: true},
			{ dataIndex: 'DIV_CODE',			width: 100, hidden: true},
			{ dataIndex: 'INOUT_NUM',			width: 100, hidden: true},
			{ dataIndex: 'INOUT_SEQ',			width: 100, hidden: true},
			{ dataIndex: 'INOUT_METH',			width: 100, hidden: true},
			{ dataIndex: 'INOUT_TYPE_DETAIL',	width: 100, hidden: true},
			{ dataIndex: 'CREATE_LOC',			width: 100, hidden: true}
		],
		listeners: {
		},
		viewConfig: {
//			getRowClass: function(record, rowIndex, rowParams, store){
//				var cls = '';
//				
//				if(record.get('REAL_NEED_Q') > record.get('GOOD_STOCK_Q')){
//					cls = 'x-change-celltext_red';	
//				}
//				return cls;
//			}
		}
	});

	function openTransStatusWindows() {
		if(!transStatusWindows) {
			transStatusWindows = Ext.create('widget.uniDetailWindow', {
				title		: '<t:message code="system.label.base.transtatuspopup" default="수불현황상세 팝업"/>',
				height		: 500,
				width		: 800,
				resizable	: false,
				layout		: {type:'vbox', align:'stretch'},
				items		: [detailDataForm, detailDataGrid],
				tbar		: ['->', {
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.confirm" default="확인"/>',
					handler	: function() {
						detailDataForm.clearForm();
						transStatusWindows.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function( panel, eOpts ) {
						detailDataForm.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						detailDataForm.setValue('INOUT_TYPE'	, gsQueryFlag);
						detailDataForm.setValue('ITEM_CODE'		, gsRecord.get('ITEM_CODE'));
						detailDataForm.setValue('ITEM_NAME'		, gsRecord.get('ITEM_NAME'));
						detailDataForm.setValue('INOUT_YM'		, gsRecord.get('INOUT_DATE'));
						detailDataStore.loadStoreRecords();
					}
				}
			})
		}
		transStatusWindows.center();
		transStatusWindows.show();
	}



	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab	: 0,
		region		: 'center',
		items		: [
			 masterGrid1,
			 masterGrid2
		]
	});

	Unilite.Main({
		id			: 's_biv320skrv_inApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	:[
				tab, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 's_biv320skrv_inGrid1'){
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