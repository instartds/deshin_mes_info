<%--
'   프로그램명 : 품목 LOT추적 현황 (pmp150skrv)
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp150skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp150skrv" />					<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"  />						<!-- 상태  -->
	<t:ExtComboStore comboType="AU" comboCode="B039"  />						<!-- 출고방법  -->
	<t:ExtComboStore comboType="AU" comboCode="B020"  />						<!-- 품목계정  -->
	<t:ExtComboStore comboType="W" />											<!-- 작업장  -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />	<!--대분류-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('pmp150skrvModel', {
		fields: [	
			{name: 'COMP_CODE'	, text:'<t:message code="system.label.product.compcode" default="법인코드"/>'			, type: 'string'},
			{name: 'DIV_CODE'	, text:'<t:message code="system.label.product.division" default="사업장"/>'			, type: 'string', comboType:'BOR120'},
			{name: 'ITEM_CODE'	, text:'<t:message code="system.label.product.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'	, text:'<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'BASIS_P'	, text:'<t:message code="system.label.product.price" default="단가"/>'				, type: 'uniUnitPrice'},
			{name: 'STOCK_UNIT'	, text:'<t:message code="system.label.product.unit" default="단위"/>'					, type: 'string'},
			{name: 'IN_Q'		, text:'<t:message code="system.label.product.receiptqty" default="입고량"/>'			, type: 'uniQty'},
			{name: 'OUT_Q'		, text:'<t:message code="system.label.product.issueqty" default="출고량"/>'			, type: 'uniQty'},
			{name: 'STOCK_Q'	, text:'<t:message code="system.label.product.onhandstock" default="현재고"/>'			, type: 'uniQty'},
			{name: 'IN_AMOUT'	, text:'<t:message code="system.label.product.receiptamount2" default="입고금액"/>'		, type: 'uniPrice'},
			{name: 'OUT_AMOUT'	, text:'<t:message code="system.label.product.issueamount" default="출고금액"/>'		, type: 'uniPrice'},
			{name: 'STOCK_AMT'	, text:'<t:message code="system.label.product.inventoryamount" default="재고금액"/>'	, type: 'uniPrice'}
		]
	});		// End of Unilite.defineModel('pmp150skrvModel', {
	
	Unilite.defineModel('pmp150skrvModel2', {
		fields: [
			{name: 'COMP_CODE'			, text:'<t:message code="system.label.product.compcode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text:'<t:message code="system.label.product.division" default="사업장"/>'		, type: 'string', comboType:'BOR120'},
			{name: 'ITEM_CODE'			, text:'<t:message code="system.label.product.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text:'<t:message code="system.label.product.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'STOCK_UNIT'			, text:'<t:message code="system.label.product.unit" default="단위"/>'				, type: 'string'},
			//보여주는 데이터
			{name: 'INOUT_DATE'			, text:'<t:message code="system.label.product.date" default="일자"/>'				, type: 'uniDate'},
			{name: 'LOT_NO'				, text:'<t:message code="system.label.product.lotno" default="LOT번호"/>'			, type: 'string'},
			{name: 'INOUT_TYPE'			, text:'<t:message code="system.label.product.trantype1" default="수불타입"/>'		, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	, text:'<t:message code="system.label.product.classfication" default="구분"/>'	, type: 'string'},
			{name: 'IN_Q'				, text:'<t:message code="system.label.product.receiptqty" default="입고량"/>'		, type: 'uniQty'},
			{name: 'OUT_Q'				, text:'<t:message code="system.label.product.issueqty" default="출고량"/>'		, type: 'uniQty'},
			{name: 'REMARK1'			, text:'<t:message code="system.label.product.remarks" default="비고"/>1'			, type: 'string'},
			{name: 'REMARK2'			, text:'<t:message code="system.label.product.remarks" default="비고"/>2'			, type: 'string'}
		]
	});		//End of Unilite.defineModel('pmp150skrvModel2', {



	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('pmp150skrvMasterStore1',{
		model	: 'pmp150skrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'pmp150skrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records[0] != null){
					directMasterStore2.loadStoreRecords(records[0]);
				}else{
					directMasterStore2.loadData({});
				}
			},
			add: function(store, records, index, eOpts) {
				
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				
			},
			remove: function(store, record, index, isMove, eOpts) {	
			}
		}
//		,groupField: 'COMP_CODE'
	});

	var directMasterStore2 = Unilite.createStore('pmp150skrvMasterStore2',{
		model	: 'pmp150skrvModel2',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'pmp150skrvService.selectDetailList'
			}
		},
		loadStoreRecords: function(record){
			var param= Ext.getCmp('searchForm').getValues();
			param.ITEM_CODE = record.get('ITEM_CODE');
			console.log( param );
			this.load({
				params: param
			});
		}
//		,groupField: 'COMP_CODE'
	});		//End of var directMasterStore2 = Unilite.createStore('pmp150skrvMasterStore2',{



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
						panelSearch.setValue('WORK_SHOP_CODE','');
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.product.period" default="기간"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'DATE_FR',
				endFieldName	: 'DATE_TO',
				width			: 315,
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DATE_FR',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DATE_TO',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
					}
				}
			},{
				name		: 'ITEM_ACCOUNT',
				fieldLabel	: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					},
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						store.clearFilter();
						store.filterBy(function(record){
							return record.get('value') != '10';
						})
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.majorgroup" default="대분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
				validateBlank	: false,
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.product.stockcounting" default="실사포함"/>',
				name		: 'EVAL_FLAG',
				xtype		: 'checkboxfield',
				inputValue	: 'Y',
				listeners	: {
					change: function (checkbox, newVal, oldVal) {
						panelResult.setValue('EVAL_FLAG', newVal);
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
	});		//End of var panelSearch = Unilite.createSearchForm('searchForm',{	

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.product.period" default="기간"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'DATE_FR',
			endFieldName	: 'DATE_TO',
			width			: 315,
			colspan			: 3,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('DATE_TO',newValue);
				}
			}
		},{
			name		: 'ITEM_ACCOUNT',
			fieldLabel	: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					store.filterBy(function(record){
						return record.get('value') != '10';
					})
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.majorgroup" default="대분류"/>',
			name		: 'ITEM_LEVEL1',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_LEVEL1', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			validateBlank	: true,
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
						panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ITEM_CODE', '');
					panelSearch.setValue('ITEM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.product.stockcounting" default="실사포함"/>',
			name		: 'EVAL_FLAG',
			xtype		: 'checkboxfield',
			inputValue	: 'Y',
			listeners	: {
				change: function (checkbox, newVal, oldVal) {
					panelSearch.setValue('EVAL_FLAG', newVal);
				}
			}
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



	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('pmp150skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		flex	: .3,
		selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		uniOpt	: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		columns: [  
			{dataIndex: 'COMP_CODE'	, width: 80 , hidden:true},
			{dataIndex: 'DIV_CODE'	, width: 80 , hidden:true},
			{dataIndex: 'ITEM_CODE'	, width: 100},
			{dataIndex: 'ITEM_NAME'	, width: 250},
			{dataIndex: 'BASIS_P'	, width: 100},
			{dataIndex: 'STOCK_UNIT', width: 80 , align: 'center'},
			{dataIndex: 'IN_Q'		, width: 100},
			{dataIndex: 'OUT_Q'		, width: 100},
			{dataIndex: 'STOCK_Q'	, width: 100},
			{dataIndex: 'IN_AMOUT'	, width: 120},
			{dataIndex: 'OUT_AMOUT'	, width: 120},
			{dataIndex: 'STOCK_AMT'	, width: 120}
		],
		listeners: {
		/*  cellclick: function( viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts , colName) {
				directMasterStore2.loadStoreRecords(record);
			this.returnCell(record, colName);
 		}*/
			select: function(grid, selectRecord, index, rowIndex, eOpts ){
				if(!Ext.isEmpty(selectRecord)) {
					this.returnCell(selectRecord);
					directMasterStore2.loadData({})
					directMasterStore2.loadStoreRecords(selectRecord);
				}
			},
 			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
				}
			}
		},
		returnCell: function(record){
			var stockQ		= record.get("STOCK_Q");
			var stockUnit	= record.get("STOCK_UNIT");
			Ext.getCmp('onhandstock').setValue(stockQ);
			Ext.getCmp('stockUnit').setValue(stockUnit);
		} 
	});		//End of  var masterGrid1 = Unilite.createGrid('pmp150skrvGrid1', {

	/** Master Grid2 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid2 = Unilite.createGrid('pmp150skrvGrid2', {
		store	: directMasterStore2,
		layout	: 'fit',
		region	: 'south',
		flex	: .7,
		uniOpt	: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		tbar:[{
			fieldLabel	: '<t:message code="system.label.product.onhandstock" default="현재고"/>',
			id			: 'onhandstock',
			xtype		: 'uniNumberfield',
			type		: 'uniQty',
//			labelWidth	: 110,
//			decimalPrecision:4,
//			format		: '0,000.0000',
			value		: 0,
			readOnly	: true
		},{
			fieldLabel	: '',
			id			: 'stockUnit',
			xtype		: 'uniTextfield',
			readOnly	: true,
			width		: 40
		}],
		columns: [ 
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden:true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden:true},
			{dataIndex: 'ITEM_CODE'			, width: 100	, hidden:true},
			{dataIndex: 'ITEM_NAME'			, width: 100	, hidden:true},
			{dataIndex: 'STOCK_UNIT'		, width: 80		, hidden:true},
			{dataIndex: 'INOUT_DATE'		, width: 80},
			{dataIndex: 'LOT_NO'			, width: 100},
			{dataIndex: 'INOUT_TYPE'		, width: 100	, hidden:true},
			{dataIndex: 'INOUT_TYPE_DETAIL'	, width: 100	, align: 'center'},
			{dataIndex: 'IN_Q'				, width: 100},
			{dataIndex: 'OUT_Q'				, width: 100},
			{dataIndex: 'REMARK1'			, width: 150},
			{dataIndex: 'REMARK2'			, width: 450}
		] 
	});		//End of var masterGrid2 = Unilite.createGrid('pmp150skrvGrid2', {   



	Unilite.Main({
		id			: 'pmp150skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid1, masterGrid2, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset'	, false);
			UniAppManager.setToolbarButtons('save'	, false);

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);

			panelSearch.setValue('DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('DATE_FR', UniDate.get('startOfMonth'));

			panelSearch.setValue('DATE_TO', UniDate.get('today'));
			panelResult.setValue('DATE_TO', UniDate.get('today'));
		},
		onQueryButtonDown : function(){
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid1.getStore().loadStoreRecords();
				UniAppManager.setToolbarButtons('reset', true); 
			}
		},
		onResetButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid1.reset();
			masterGrid2.reset();
			directMasterStore1.clearData();
			directMasterStore2.clearData();
			this.fnInitBinding();
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		}
	});		//End of Unilite.Main({
};
</script>