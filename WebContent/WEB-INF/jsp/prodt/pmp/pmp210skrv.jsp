<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp210skrv">
	<t:ExtComboStore comboType="BOR120" pgmId="pmp210skrv"/>	<!-- 사업장 -->  
	<t:ExtComboStore comboType="W"/>							<!-- 작업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"/>			<!-- 진행상태 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >
function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Pmp210skrvModel', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			, type: 'string',comboType:'W'},
			{name: 'SEQ'				, text: '<t:message code="system.label.product.seq" default="순번"/>'					, type: 'string'},
			{name: 'OUTSTOCK_NUM'		, text: '<t:message code="system.label.product.issuerequestno" default="출고요청번호"/>'	, type: 'string'},
			{name: 'REF_WKORD_NUM'		, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		, type: 'string'},
			{name: 'WKORD_ITEM_CODE'	, text: '<t:message code="system.label.product.workorderitem" default="작업지시품목"/>'	, type: 'string'},
			{name: 'WKORD_ITEM_SPEC'	, text: '<t:message code="system.label.product.workorderitem" default="작업지시품목"/> <t:message code="system.label.product.spec" default="규격"/>', type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'ITEM_NAME1'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>1'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'				, type: 'string'},
			{name: 'ALLOCK_Q'			, text: '<t:message code="system.label.product.allocationqty" default="예약량"/>'		, type: 'uniQty'},
			{name: 'OUTSTOCK_REQ_Q'		, text: '<t:message code="system.label.product.issuerequestqty" default="출고요청량"/>'	, type: 'uniQty'},
			{name: 'OUTSTOCK_Q'			, text: '<t:message code="system.label.product.issueqty" default="출고량"/>'			, type: 'uniQty'},
			{name: 'ISSUE_QTY'			, text: '<t:message code="system.label.product.unissuedqty" default="미출고량"/>'		, type: 'uniQty'},
			{name: 'OUTSTOCK_REQ_DATE'	, text: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>'	, type: 'uniDate'},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.product.remarks" default="비고"/>'				, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'PJT_CODE'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'PJT_CODE'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'GW_FLAG'			, text: '<t:message code="system.label.product.drafting" default="기안여부"/>'			, type: 'string', comboType:'AU', comboCode:'WB17'},
			//20200709 추가: 현재고량
			{name: 'CURRENT_STOCK'		, text : '<t:message code="system.label.sales.onhandqty" default="현재고량"/>'			, type : 'uniQty'},
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('pmp210skrvMasterStore1',{
		model	: 'Pmp210skrvModel',
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
				read: 'pmp210skrvService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'OUTSTOCK_NUM'
	});

	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title		: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: true,
		listeners	: {
			collapse: function () {
				topSearch.show();
			},
			expand: function() {
				topSearch.hide();
			}
		},
		items		: [{
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
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						topSearch.setValue('DIV_CODE'			, newValue);
						panelSearch.setValue('WORK_SHOP_CODE'	, '');
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name		: 'WORK_SHOP_CODE',
				xtype		: 'uniCombobox', 
				comboType	: 'W',
//				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						topSearch.setValue('WORK_SHOP_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts ) {
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
			},{
				fieldLabel		: '<t:message code="system.label.product.requestdate" default="요청일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'OUTSTOCK_REQ_DATE_FR',
				endFieldName	: 'OUTSTOCK_REQ_DATE_TO',
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(topSearch) {
						topSearch.setValue('OUTSTOCK_REQ_DATE_FR',newValue);
						//topSearch.getField('ISSUE_REQ_DATE_FR').validate();
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(topSearch) {
						topSearch.setValue('OUTSTOCK_REQ_DATE_TO',newValue);
						//topSearch.getField('ISSUE_REQ_DATE_TO').validate();
					}
				}
			},
			Unilite.popup('OUTSTOCK_NUM', {
				fieldLabel	: '<t:message code="system.label.product.issuerequestno" default="출고요청번호"/>',
				listeners	: {
					onSelected: {
						fn: function(records, type) {
							topSearch.setValue('OUTSTOCK_NUM', panelSearch.getValue('OUTSTOCK_NUM'));
						},
						scope: this
					},
					onClear: function(type) {
						topSearch.setValue('OUTSTOCK_NUM', '');
					},
					applyextparam: function(popup){
						/*if(!UniAppManager.app.checkForNewDetail()){
							return false;
						}else{*/
							popup.setExtParam({'DIV_CODE'		: panelSearch.getValue('DIV_CODE')});
							popup.setExtParam({'WORK_SHOP_CODE'	: panelSearch.getValue('WORK_SHOP_CODE')});
						//}
					}
				} 
			}),
			Unilite.popup('DIV_PUMOK',{ // 20210826 추가: 품목 조회조건 정규화
				fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				validateBlank: false,
				listeners		: {
					onValueFieldChange: function( elm, newValue, oldValue ) {
						topSearch.setValue('ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							topSearch.setValue('ITEM_NAME', '');
							panelSearch.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						topSearch.setValue('ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							topSearch.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						if(Ext.isDefined(panelSearch)){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue("DIV_CODE")});
							//popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
						}
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
				xtype		: 'uniTextfield',
				name		: 'REF_WKORD_NUM',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						topSearch.setValue('REF_WKORD_NUM', newValue);
					}
				}
			},{
				fieldLabel	: ' ',
				boxLabel	: '<t:message code="system.label.product.unissued" default="미출고"/>', 
				xtyp		:'checkboxfield',
				name		: 'IS_ISSUE',
				checked		: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						topSearch.setValue('IS_ISSUE', newValue);
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
				//  this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});

	var topSearch = Unilite.createSimpleForm('topSearchForm', {
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
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE'		, newValue);
					topSearch.setValue('WORK_SHOP_CODE'	, '');
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox', 
			comboType	: 'W',
//			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				},
				beforequery:function( queryPlan, eOpts ) {
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
			fieldLabel		: '<t:message code="system.label.product.requestdate" default="요청일"/>',
			xtype			: 'uniDateRangefield',   
			startFieldName	: 'OUTSTOCK_REQ_DATE_FR',
			endFieldName	: 'OUTSTOCK_REQ_DATE_TO',
			width			: 315,
			colspan			: 2,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('OUTSTOCK_REQ_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('OUTSTOCK_REQ_DATE_TO',newValue);
				}
			}
		},
		Unilite.popup('OUTSTOCK_NUM', { 
			fieldLabel	: '<t:message code="system.label.product.issuerequestno" default="출고요청번호"/>', 
			listeners	: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('OUTSTOCK_NUM', topSearch.getValue('OUTSTOCK_NUM'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('OUTSTOCK_NUM', '');
				},
				applyextparam: function(popup){
					/*if(!UniAppManager.app.checkForNewDetail()){
						return false;
					}else{
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						popup.setExtParam({'WORK_SHOP_CODE': panelSearch.getValue('WORK_SHOP_CODE')});
					}
					*/
					/*var checkDivCode = panelSearch.getValue('DIV_CODE');
					var checkWorkShopCode = panelSearch.getValue('WORK_SHOP_CODE');
					
					if(Ext.isEmpty(checkDivCode) || Ext.isEmpty(checkWorkShopCode)){
						if(Ext.isEmpty(checkDivCode)){
							alert('12344');
							return false;
						}
						else if(Ext.isEmpty(checkWorkShopCode)){
							alert('15252');
							return false;
						}
						return false;
					}else{*/
						popup.setExtParam({'DIV_CODE'		: panelSearch.getValue('DIV_CODE')});
						popup.setExtParam({'WORK_SHOP_CODE'	: panelSearch.getValue('WORK_SHOP_CODE')});
					//}
				}
			} 
		}),
		Unilite.popup('DIV_PUMOK',{ // 20210826 추가: 품목 조회조건 정규화
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function( elm, newValue, oldValue ) {
					panelSearch.setValue('ITEM_CODE', newValue);
					if(!Ext.isObject(oldValue)) {
						topSearch.setValue('ITEM_NAME', '');
						panelSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function( elm, newValue, oldValue ) {
					panelSearch.setValue('ITEM_NAME', newValue);
					if(!Ext.isObject(oldValue)) {
						topSearch.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					if(Ext.isDefined(panelSearch)){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue("DIV_CODE")});
						//popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
					}
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			xtype		: 'uniTextfield',
			name		: 'REF_WKORD_NUM',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('REF_WKORD_NUM', newValue);
				}
			}
		},{
			fieldLabel	: ' ',
			boxLabel	: '<t:message code="system.label.product.unissued" default="미출고"/>', 
			xtype		: 'checkboxfield',
			name		: 'IS_ISSUE',
			checked		: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('IS_ISSUE', newValue);
				}
			}
		}]
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('pmp210skrvGrid1', {
		store	: directMasterStore1,
		region	: 'center' ,
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn	: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useRowNumberer		: false,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [
			{dataIndex: 'DIV_CODE'			, width:100 , hidden : true},
			{dataIndex: 'WORK_SHOP_CODE'	, width:110 , hidden : false},
			{dataIndex: 'SEQ'				, width:40  , hidden : true},
			{dataIndex: 'OUTSTOCK_NUM'		, width:120},
			{dataIndex: 'REF_WKORD_NUM'		, width:120},
			{dataIndex: 'WKORD_ITEM_CODE'	, width:120},
			{dataIndex: 'WKORD_ITEM_SPEC'	, width:120},
			{dataIndex: 'ITEM_CODE'			, width:120},
			{dataIndex: 'ITEM_NAME'			, width:180},
			{dataIndex: 'ITEM_NAME1'		, width:180, hidden:true},
			{dataIndex: 'SPEC'				, width:150},
			{dataIndex: 'STOCK_UNIT'		, width:60},
			{dataIndex: 'ALLOCK_Q'			, width:100, hidden:true},
			{dataIndex: 'OUTSTOCK_Q'		, width:100},
			{dataIndex: 'OUTSTOCK_REQ_Q'	, width:100},
			{dataIndex: 'ISSUE_QTY'			, width:100},
			//20200709 추가: 현재고량
			{dataIndex: 'CURRENT_STOCK'		, width:100},
			{dataIndex: 'OUTSTOCK_REQ_DATE'	, width:90},
			{dataIndex: 'LOT_NO'			, width:120},
			{dataIndex: 'GW_FLAG'			, width:100, hidden:true},	//20200709 주석
			{dataIndex: 'REMARK'			, width:150},
			{dataIndex: 'PROJECT_NO'		, width:120}
//			{dataIndex: 'PJT_CODE'			, width:153}
		]
	});



	Unilite.Main({
		id			: 'pmp210skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid1, topSearch
			]
		},
		panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE'				, UserInfo.divCode);
			panelSearch.setValue('OUTSTOCK_REQ_DATE_FR'	, UniDate.get('startOfMonth'));
			panelSearch.setValue('OUTSTOCK_REQ_DATE_TO'	, UniDate.get('today'));

			topSearch.setValue('DIV_CODE'				, UserInfo.divCode);
			topSearch.setValue('OUTSTOCK_REQ_DATE_FR'	, UniDate.get('startOfMonth'));
			topSearch.setValue('OUTSTOCK_REQ_DATE_TO'	, UniDate.get('today'));

			UniAppManager.setToolbarButtons(['save', 'reset', 'detail'], false);
		},
		onQueryButtonDown : function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid1.getStore().loadStoreRecords();
				UniAppManager.setToolbarButtons('reset', true); 
			}
		},
		onResetButtonDown: function() {	// 초기화
			this.suspendEvents();
			panelSearch.reset();
			masterGrid1.reset();
			topSearch.reset();
			this.fnInitBinding();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		}
	});
};
</script>