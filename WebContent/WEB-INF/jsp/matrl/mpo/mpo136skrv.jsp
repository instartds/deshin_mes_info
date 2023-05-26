<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo136skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" /> <!-- 단가형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" /> <!-- 조달구분 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('Mpo136skrvModel2', {
		fields: [
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '공급자'		, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	, text: '입고형태'		, type: 'string'},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'		, type: 'uniDate'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'		, type: 'uniDate'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'		, type: 'uniQty'},
			{name: 'ORDER_UNIT'			, text: '입고단위'		, type: 'string'},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.receiptprice" default="입고단가"/>'		, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_O'		, text: '입고금액'		, type: 'uniPrice'},
			{name: 'PURCHASE_BASE_P'	, text: '<t:message code="system.label.purchase.basisprice" default="기준단가"/>'		, type: 'uniUnitPrice'},
			{name: 'BASE_AMT'			, text: '환산금액'		, type: 'uniPrice'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'		, type: 'string'},
			{name: 'INOUT_NUMBER'		, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'		, type: 'string'},
			{name: 'BILL_NUM'			, text: '<t:message code="system.label.purchase.billno" default="계산서번호"/>'	, type: 'string'},
			{name: 'ORDER_DATE'			, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'		, type: 'uniDate'},
			{name: 'PORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'		, type: 'uniQty'},
			{name: 'PORDER_UNIT'		, text: '발주단위'		, type: 'string'},
			{name: 'INOUT_PRSN'			, text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'		, type: 'string'},
			{name: 'ORDER_NUMBER'		, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'		, type: 'string'},
			{name: 'CONTROL_STATUS'		, text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'		, type: 'string'},
			{name: 'UNIT_PRICE_TYPE'	, text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'		, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'+'1'		, type: 'string'},
			{name: 'REMARK2'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'+'2'		, type: 'string'},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'	, type: 'string'},
			{name: 'INOUT_NUM'			, text: 'INOUT_NUM'	, type: 'string'},
			{name: 'INOUT_SEQ'			, text: 'INOUT_SEQ'	, type: 'string'},
			{name: 'LINK_PAGE'			, text: 'LINK_PAGE'	, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'		, type: 'string',comboType:'AU' ,comboCode:'B020'},
			{name: 'SUPPLY_TYPE'		, text: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>'		, type: 'string'	, comboType: 'AU'	, comboCode: 'B014'} //21.03.16 조달구분 추가
		]
	});//End of Unilite.defineModel('Mpo136skrvModel2', {

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore2 = Unilite.createStore('mpo136skrvMasterStore2',{
		model: 'Mpo136skrvModel2',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'mpo136skrvService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();
			Ext.applyIf(param,panelSearch.getValues());
			this.load({
				params: param
			});
		},
		groupField: 'CUSTOM_NAME'

	});//End of var directMasterStore2 = Unilite.createStore('mpo136skrvMasterStore2',{

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
   var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		width: 380,
        defaultType: 'uniSearchSubPanel',
		items: [{
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				holdable: 'hold',
				child: 'WH_CODE',
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelSearch.getField('INOUT_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
						var field2 = panelSearch.getField('WH_CODE');
						field2.getStore().clearFilter(true);


						panelSearch.setValue('WH_CODE', '');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>'	,
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M001',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			}]
		},{
				title:'<t:message code="system.label.purchase.additionalinfo" default="추가정보"/>',
				id: 'search_panel2',
				itemId:'search_panel2',
		    	defaultType: 'uniTextfield',
		    	layout: {type: 'uniTable', columns: 1},
				items:[{
							fieldLabel: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
							xtype: 'uniDateRangefield',
							startFieldName: 'DVRY_DATE_FR',
							endFieldName: 'DVRY_DATE_TO',
							width: 315
						},
							Unilite.popup('CUST', {
								fieldLabel:  '<t:message code="system.label.purchase.custom" default="거래처"/>',
								textFieldWidth:  170,
								allowBlank:true,	// 2021.08 표준화 작업
								autoPopup:false,	// 2021.08 표준화 작업
								validateBlank:false,// 2021.08 표준화 작업
								listeners: {
											onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
												panelSearch.setValue('CUSTOM_CODE', newValue);
												if(!Ext.isObject(oldValue)) {
													panelSearch.setValue('CUSTOM_NAME', '');
												}
											},
											onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
												panelSearch.setValue('CUSTOM_NAME', newValue);
												if(!Ext.isObject(oldValue)) {
													panelSearch.setValue('CUSTOM_CODE', '');
												}
											},
						                    applyextparam: function(popup){	// 2021.08 표준화 작업
						                        popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
						                        popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				                    }
								}
							}),
							Unilite.popup('DIV_PUMOK', {
								fieldLabel: '<t:message code="system.label.purchase.item" default="품목"/>',
								textFieldWidth: 170,
								allowBlank:true,	// 2021.08 표준화 작업
								autoPopup:false,	// 2021.08 표준화 작업
								validateBlank:false,// 2021.08 표준화 작업
								listeners: {
											onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
												panelSearch.setValue('ITEM_CODE', newValue);
												if(!Ext.isObject(oldValue)) {
													panelSearch.setValue('ITEM_NAME', '');
												}
											},
											onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
												panelSearch.setValue('ITEM_NAME', newValue);
												if(!Ext.isObject(oldValue)) {
													panelSearch.setValue('ITEM_CODE', '');
												}
											},
										applyextparam: function(popup){	// 2021.08 표준화 작업
											popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
										}
									}
							}),
						{
							fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'	,
							name: 'WH_CODE',
							xtype: 'uniCombobox',
							store: Ext.data.StoreManager.lookup('whList'),
							beforequery:function( queryPlan, eOpts )   {
								var store = queryPlan.combo.store;
								store.clearFilter();
								if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
									store.filterBy(function(record){
										return record.get('option') == panelSearch.getValue('DIV_CODE');
									});
								}else{
									store.filterBy(function(record){
										return false;
									});
								}
							}
						},{
							fieldLabel: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',
							name: 'INOUT_PRSN',
							xtype: 'uniCombobox',
							comboType:'AU',
							comboCode:'B024',
							holdable: 'hold',
							onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
								if(eOpts){
									combo.filterByRefCode('refCode1', newValue, eOpts.parent);
								}else{
									combo.divFilterByRefCode('refCode1', newValue, divCode);
								}
							},
							listeners: {
								change: function(field, newValue, oldValue, eOpts) {
									panelResult.setValue('INOUT_PRSN', newValue);
								}
							}
						},{
							fieldLabel: '<t:message code="system.label.purchase.billno" default="계산서번호"/>',
							name: 'BILL_NUM',
							xtype: 'uniTextfield'
						},{
							fieldLabel: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'	,
							name:'CONTROL_STATUS',
							xtype: 'uniCombobox',
							comboType: 'AU',
							comboCode: 'M002'
						},{
							fieldLabel: '<t:message code=" system.label.purchase.purchasecharge" default="구매담당"/>'	,
							name: 'ORDER_PRSN',
							xtype: 'uniCombobox',
							comboType: 'AU',
							comboCode: 'M201'
						},{
							xtype: 'radiogroup',
							fieldLabel: '마감여부',
							id: 'rdoSelect',
							items: [{
								boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
								width:  60,
								name: 'AGREE_STATUS',
								inputValue: 'A',
								checked: true
							},{
								boxLabel: '마감',
								width :60,
								name: 'AGREE_STATUS',
								inputValue: 'Y'
							},{
								boxLabel: '미마감',
								width: 60,
								name: 'AGREE_STATUS',
								inputValue: 'N'
							}]
						},
							Unilite.popup('', {
								fieldLabel: '<t:message code="system.label.purchase.manageno" default="관리번호"/>',
								textFieldWidth: 70
							}),
						{
							fieldLabel: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>',
							name: 'PRICE_YN',
							xtype: 'uniCombobox',
							comboType: 'AU',
							comboCode: 'M301'
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
   						var labelText = invalid.items[0]['fieldLabel']+':';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	/**
	 * 검색조건 (searchForm)
	 * @type
	 */
    var panelResult = Unilite.createSearchForm('resultForm', {
     	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			holdable: 'hold',
			child: 'WH_CODE',
			value: UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelSearch.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
					var field2 = panelSearch.getField('WH_CODE');
					field2.getStore().clearFilter(true);
					panelResult.setValue('WH_CODE', '');
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'INOUT_DATE_FR',
			endFieldName: 'INOUT_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315,
			allowBlank: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_TO',newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>'	,
			name: 'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M001',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_TYPE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			name: 'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B020',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
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
   						var labelText = invalid.items[0]['fieldLabel']+':';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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
	});//End of var panelResult

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('mpo136skrvGrid', {
    	// for tab
		layout: 'fit',
		region:'center',
		store: directMasterStore2,
		flex: 1,
		uniOpt: {
			expandLastColumn	: false,
			useLiveSearch		: true,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		columns: [
			{dataIndex: 'ITEM_CODE'				, width: 86, locked: true},
			{dataIndex: 'ITEM_NAME'				, width: 133, locked: true},
			{dataIndex: 'SPEC'					, width: 133},
			{dataIndex: 'CUSTOM_NAME'			, width: 86},
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width: 86},
			{dataIndex: 'INOUT_DATE'			, width: 80},
			{dataIndex: 'DVRY_DATE'				, width: 80},
			{dataIndex: 'ORDER_UNIT_Q'			, width: 73, summaryType:'sum',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<div align="right">' + Ext.util.Format.number(value,UniFormat.Qty)+'</div>', '<div align="right">' + Ext.util.Format.number(value,UniFormat.Qty)+'</div>');
				}
			},
			{dataIndex: 'ORDER_UNIT'			, width: 66},
			{dataIndex: 'ORDER_UNIT_P'			, width: 86},
			{dataIndex: 'ORDER_UNIT_O'			, width: 86, summaryType:'sum',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<div align="right">' + Ext.util.Format.number(value,UniFormat.Price)+'</div>', '<div align="right">' + Ext.util.Format.number(value,UniFormat.Price)+'</div>');
				}
			},
			{dataIndex: 'PURCHASE_BASE_P'		, width: 86},
			{dataIndex: 'BASE_AMT'				, width: 86, summaryType:'sum',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<div align="right">' + Ext.util.Format.number(value,UniFormat.Price)+'</div>', '<div align="right">' + Ext.util.Format.number(value,UniFormat.Price)+'</div>');
				}
			},
			{dataIndex: 'SUPPLY_TYPE'			, width: 100, align:'center'},
			{dataIndex: 'WH_CODE'				, width: 86},
			{dataIndex: 'INOUT_NUMBER'			, width: 113},
			{dataIndex: 'BILL_NUM'				, width: 86},
			{dataIndex: 'ORDER_DATE'			, width: 80},
			{dataIndex: 'PORDER_UNIT_Q'			, width: 73, summaryType:'sum',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<div align="right">' + Ext.util.Format.number(value,UniFormat.Qty)+'</div>', '<div align="right">' + Ext.util.Format.number(value,UniFormat.Qty)+'</div>');
				}
			},
			{dataIndex: 'PORDER_UNIT'			, width: 73},
			{dataIndex: 'INOUT_PRSN'			, width: 86},
			{dataIndex: 'ORDER_NUMBER'			, width: 106},
			{dataIndex: 'CONTROL_STATUS'		, width: 86},
			{dataIndex: 'UNIT_PRICE_TYPE'		, width: 86},
			{dataIndex: 'PROJECT_NO'			, width: 86},
			{dataIndex: 'REMARK'				, width: 86},
			{dataIndex: 'REMARK2'				, width: 86},
			{dataIndex: 'ITEM_ACCOUNT'			, width: 100, align:'center'},
			{dataIndex: 'DIV_CODE'				, width: 86, hidden: true},
			{dataIndex: 'INOUT_NUM'				, width: 86, hidden: true},
			{dataIndex: 'INOUT_SEQ'				, width: 86, hidden: true},
			{dataIndex: 'LINK_PAGE'				, width: 86, hidden: true}
		]
	});//End of var masterGrid2 = Unilite.createGrid('mpo136skrvGrid2', {

	Unilite.Main({
		/* borderItems:[
	 		 masterGrid,
			panelSearch
		], */
		borderItems:[{
			id		: 'mainItem',
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		} ,
			panelSearch
		],
		id: 'mpo135skrvApp',
		fnInitBinding: function(){
			this.setDefault();
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset', false);
		},
		onQueryButtonDown: function(){
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
				var viewLocked = masterGrid.lockedGrid.getView();
				var viewNormal = masterGrid.normalGrid.getView();
				console.log("viewLocked: ", viewLocked);
				console.log("viewNormal: ", viewNormal);
			    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()){
				as.show();
			}else {
				as.hide()
			}
		},
		setDefault: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			var field = panelSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
};//End of Unilite.Main({
</script>