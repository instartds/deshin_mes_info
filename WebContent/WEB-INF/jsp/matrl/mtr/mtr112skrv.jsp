<%--
'프로그램명 : 입고현황조회 (구매재고)
'
'작  성  자 : (주)포렌 개발실
'작  성  일 :
'
'최종수정자 :
'최종수정일 :
'
'버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mtr112skrv"  >
<t:ExtComboStore comboType="BOR120"  />		  <!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 입고담당(=수불담당?) -->
<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 (O) -->
<t:ExtComboStore comboType="AU" comboCode="M103" /> <!-- 품목계정 B004? -->
<t:ExtComboStore comboType="AU" comboCode="M103" /> <!-- 입고유형 -->
<t:ExtComboStore comboType="AU" comboCode="M505" /> <!-- 생성경로 -->
<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 통화 -->
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var BsaCodeInfo = {
	gsInOutPrsn: '${gsInOutPrsn}'
};
function appMain() {
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mtr112skrvService.selectList'
		}
	});



	Unilite.defineModel('mtr112skrvModel1', {
		fields: [
			{name: 'ITEM_LEVEL1'			, text: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL2'			, text: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL3'			, text: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>'				, type: 'string'},
			{name: 'INDEX01'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					, type: 'string'},//ITEM_CODE
			{name: 'INDEX02'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					, type: 'string'},//ITEM_NAME
			{name: 'BARCODE'				, text: '<t:message code="system.label.purchase.barcode" default="바코드"/>'					, type: 'string'},
			{name: 'INDEX03'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'						, type: 'string'},//SPEC
			{name: 'INDEX04'				, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate'},//INOUT_DATE
			{name: 'INDEX05'				, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type: 'string'},//INOUT_CODE
			{name: 'INDEX06'				, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type: 'string'},//CUSTOM_NAME
			{name: 'INOUT_Q'				, text: '<t:message code="system.label.purchase.receiptqty3" default="입고량(재고)"/>'			, type: 'uniQty'},
			{name: 'INOUT_P'				, text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'					, type: 'uniUnitPrice'},
			{name: 'INOUT_I'				, text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'					, type: 'uniPrice'},
			{name: 'EXPENSE_I'				, text: '<t:message code="system.label.purchase.importexpense" default="수입부대비"/>'			, type: 'uniPrice'},
			{name: 'INOUT_I_TOTAL'			, text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>(<t:message code="system.label.purchase.expenseinclude" default="부대비포함"/>)'	, type: 'uniPrice'},
			{name: 'TAX_TYPE'				, text: '<t:message code="system.label.purchase.taxationyn" default="과세여부"/>'				, type: 'string', comboType: "AU", comboCode: "B059"},
			{name: 'INOUT_FOR_P'			, text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>'		, type: 'uniFC'},
			{name: 'INOUT_FOR_O'			, text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>'	, type: 'uniFC'},
			{name: 'MONEY_UNIT'				, text: '<t:message code="system.label.purchase.currency2" default="통화"/>'					, type: 'string'},
			{name: 'EXCHG_RATE_O'			, text: '<t:message code="system.label.purchase.receiptexchangerate" default="입고환율"/>'		, type: 'uniER'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'			, type: 'string'},
			{name: 'INOUT_PRSN'				, text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'			, type: 'string'},
			{name: 'INOUT_NUM'				, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string'},
			{name: 'INOUT_METH'				, text: '<t:message code="system.label.purchase.tranmethod" default="수불방법"/>'				, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		, text: '<t:message code="system.label.purchase.trantype" default="수불유형"/>'					, type: 'string'},
			{name: 'ORDER_DATE'				, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'					, type: 'uniDate'},
			{name: 'ORDER_NUM'				, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'					, type: 'int'},
			{name: 'DVRY_DATE'				, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				, type: 'uniDate'},
			{name: 'BUY_Q'					, text: '<t:message code="system.label.purchase.purchaseqty" default="매입량"/>'				, type: 'uniQty'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					, type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			//{name: 'LOT_NO'					, text: 'LOT NO'				, type: 'string'},
			{name: 'LC_NUM'					, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'					, type: 'string'},
			{name: 'BL_NUM'					, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'					, type: 'string'},
			{name: 'CREATE_LOC'				, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'				, type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'					, type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '<t:message code="system.label.purchase.entrydate" default="등록일"/>'					, type: 'uniDate'},
			//20190110 입고량(ORDER_UNIT_Q), 발주단위(ORDER_UNIT) 추가
			{name: 'ORDER_UNIT_Q'			, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				, type: 'uniQty'},
			{name: 'ORDER_UNIT'				, text: '<t:message code="system.label.purchase.pounit2" default="발주단위"/>'			, type: 'string'},
			{name: 'ORDER_UNIT_FOR_P'		, text: '<t:message code="system.label.purchase.receiptprice" default="입고단가"/>'				, type: 'uniUnitPrice', allowBlank: true},
			{name: 'ORDER_UNIT_FOR_O'		, text: '<t:message code="system.label.purchase.receiptamount" default="입고금액"/>'			, type: 'uniPrice'/*, allowBlank: false*/},
			{name: 'SQM'					, text: 'SQM'																				, type: 'float'	, decimalPrecision: 2	, format:'0,000.00'}
		]
	});



	var directMasterStore1 = Unilite.createStore('mtr112skrvMasterStore1',{
		model: 'mtr112skrvModel1',
		proxy: directProxy1,
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params: param
			});
		},
		groupField: 'INDEX02'
	});



	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title	: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId	: 'search_panel1',
			layout	: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items	: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
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
				fieldLabel		: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'INOUT_FR_DATE',
				endFieldName	: 'INOUT_TO_DATE',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				allowBlank		: false,
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_FR_DATE',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_TO_DATE',newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					}
//				  onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
//							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
//						},
//						scope: this
//					},
//					onClear: function(type) {
//						panelResult.setValue('ITEM_CODE', '');
//						panelResult.setValue('ITEM_NAME', '');
//					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name		: 'ORDER_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'M001',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
					}
				}
			})
		]},{
			title		: '<t:message code="system.label.purchase.additionalinfo" default="추가정보"/>',
			id			: 'search_panel2',
			itemId		: 'search_panel2',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [{
				fieldLabel	: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',
				name		: 'INOUT_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B024',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_PRSN', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
				name		: 'ITEM_ACCOUNT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>',
				name		: 'INOUT_TYPE_DETAIL',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'M103',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_TYPE_DETAIL', newValue);
					}
				}
			},
			//프로젝트번호
			Unilite.popup('PJT',{
				fieldLabel		: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				valueFieldName	: 'PJT_CODE',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelResult.setValue('PJT_CODE', panelSearch.getValue('PJT_CODE'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PJT_CODE', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				xtype		: 'radiogroup',
				id			: 'DVRY_TYPE1',
				fieldLabel	: '<t:message code="system.label.purchase.deliverylapse" default="납기경과"/>',
				items		: [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width	: 60,
					name	: 'DVRY_TYPE',
					inputValue: '0',
					checked	: true
				},{
					boxLabel: '<t:message code="system.label.purchase.deliveryobservance" default="납기준수"/>',
					width	: 80,
					name	: 'DVRY_TYPE',
					inputValue: '1'
				},{
					boxLabel: '<t:message code="system.label.purchase.deliverylapse" default="납기경과"/>',
					width	: 80,
					name	: 'DVRY_TYPE',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						Ext.getCmp('DVRY_TYPE').setValue(newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
				name		: 'CREATE_LOC',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'M505',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CREATE_LOC', newValue);
					}
				}

			},{
				fieldLabel		: '<t:message code="system.label.purchase.podate" default="발주일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'ORDER_FR_DATE',
				endFieldName	: 'ORDER_TO_DATE',
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_FR_DATE',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_TO_DATE',newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'DVRY_FR_DATE',
				endFieldName	: 'DVRY_TO_DATE',
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DVRY_FR_DATE',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DVRY_TO_DATE',newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.currency2" default="통화"/>',
				name		: 'MONEY_UNIT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B004',
				displayField: 'value',
				fieldStyle	: 'text-align: center;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('MONEY_UNIT', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'TXTLV_L2',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child		: 'TXTLV_L3',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>',
				name		: 'ITEM_LEVEL3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL3', newValue);
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
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
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
			fieldLabel		: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'INOUT_FR_DATE',
			endFieldName	: 'INOUT_TO_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			allowBlank		: false,
			width			: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_FR_DATE',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_TO_DATE',newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				}
			}
	}),{
			fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name		: 'ORDER_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'M001',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_TYPE', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				}
			}
		})]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var itemGrid = Unilite.createGrid('mtr112skrvGrid1', {
		layout	: 'fit',
		region	: 'center',
		title	: '<t:message code="system.label.purchase.itemby" default="품목별"/>',
		uniOpt	: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			filter: {
				useFilter	: false,
				autoCreate	: false
			},
			excel: {
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: true,		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		features: [{
			id		: 'masterGridSubTotal',
			ftype	: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id		: 'masterGridTotal',
			ftype	: 'uniSummary',
			showSummaryRow: true
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'INDEX01'			, width: 120	, locked: false},
			{dataIndex: 'INDEX02'			, width: 150	, locked: false},
			{dataIndex: 'BARCODE'			, width: 88		, locked: false},
			{dataIndex: 'INDEX03'			, width: 150	, locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.subtotal" default="소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
			}},
			{dataIndex: 'INDEX04'			, width: 86		, locked: false},
			{dataIndex: 'INDEX05'			, width: 150	, hidden: true},
			{dataIndex: 'INDEX06'			, width: 166},
			//20190110 입고량(ORDER_UNIT_Q), 발주단위(ORDER_UNIT) 추가
			{dataIndex: 'ORDER_UNIT_Q'		, width: 95		, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT'		, width: 66},
			{dataIndex: 'SQM'			, width: 95,summaryType: 'sum', hidden: true},
			{dataIndex: 'ORDER_UNIT_FOR_P'			, width: 100,summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_FOR_O'			, width: 100,summaryType: 'sum'},
			{dataIndex: 'INOUT_Q'			, width: 95		, summaryType: 'sum'},
			{dataIndex: 'INOUT_P'			, width: 100},
			{dataIndex: 'INOUT_I'			, width: 100	, summaryType: 'sum'},
			{dataIndex: 'EXPENSE_I'			, width: 100	, summaryType: 'sum'},
			{dataIndex: 'INOUT_I_TOTAL'		, width: 140	, summaryType: 'sum'},
			{dataIndex: 'TAX_TYPE'			, width: 90},
			{dataIndex: 'INOUT_FOR_P'		, width: 100},
			{dataIndex: 'INOUT_FOR_O'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'MONEY_UNIT'		, width: 66		, align: 'center'},
			{dataIndex: 'EXCHG_RATE_O'		, width: 70},
			{dataIndex: 'STOCK_UNIT'		, width: 66},
			{dataIndex: 'WH_CODE'			, width: 100},
			{dataIndex: 'INOUT_PRSN'		, width: 66},
			{dataIndex: 'INOUT_NUM'			, width: 133},
			{dataIndex: 'INOUT_METH'		, width: 66},
			{dataIndex: 'INOUT_TYPE_DETAIL'	, width: 66},
			{dataIndex: 'ORDER_DATE'		, width: 93},
			{dataIndex: 'ORDER_NUM'			, width: 133},
			{dataIndex: 'ORDER_SEQ'			, width: 70},
			{dataIndex: 'DVRY_DATE'			, width: 93},
			{dataIndex: 'BUY_Q'				, width: 93		, summaryType: 'sum'},
			{dataIndex: 'REMARK'			, width: 133},
			{dataIndex: 'PROJECT_NO'		, width: 133},
			//{dataIndex: 'LOT_NO'			, width: 113},
			{dataIndex: 'ITEM_LEVEL1'		, width: 120	, locked: false},
			{dataIndex: 'ITEM_LEVEL2'		, width: 120	, locked: false},
			{dataIndex: 'ITEM_LEVEL3'		, width: 120	, locked: false},
			{dataIndex: 'LC_NUM'			, width: 113},
			{dataIndex: 'BL_NUM'			, width: 113},
			{dataIndex: 'CREATE_LOC'		, width: 66		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 6		, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 120}
		]
	});



	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				itemGrid, panelResult
			]
		},
			panelSearch
		],
		id: 'mtr112skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);

			panelSearch.setValue('CHECK_SUM', true);
			panelResult.setValue('CHECK_SUM', true);

			panelSearch.setValue('INOUT_FR_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('INOUT_TO_DATE', UniDate.get('today'));
			panelResult.setValue('INOUT_FR_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('INOUT_TO_DATE', UniDate.get('today'));

			panelSearch.setValue('INOUT_PRSN',BsaCodeInfo.gsInOutPrsn);
			panelResult.setValue('INOUT_PRSN',BsaCodeInfo.gsInOutPrsn);
			mtr112skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			});

			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {
			directMasterStore1.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			itemGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		}
	});
};
</script>