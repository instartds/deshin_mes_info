<%--
'   프로그램명 : 외주입고등록 (외주관리)
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'   최종수정자 :
'   최종수정일 :
'   버	전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="otr121ukrv">
	<t:ExtComboStore comboType="BOR120"/>									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>						<!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>						<!-- 화폐 -->
	<t:ExtComboStore comboType="AU" comboCode="M001"/>						<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M103"/>						<!-- 판매유형 -->
	<t:ExtComboStore comboType="OU"/>										<!-- 창고 -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList"/>	<!-- 창고Cell -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">
var windowFlag = '';	// 검사결과, 무검사 참조 구분 플래그
var SearchInfoWindow;	// 검색창
var NotInoutWindow;		// 미입고참조
var ReturnOrderWindow;	// 반품가능발주참조
var CheckResultWindow;	// 검사결과/무검사참조
var isLoad = false;		//20200603 추가: 로딩 플래그 화폐단위 환율 change 로드시 계속 타므로 막음

var BsaCodeInfo = {
	gsInvstatus			: '${gsInvstatus}',
	glPerCent			: '${glPerCent}',
	gsSumTypeCell		: '${gsSumTypeCell}',
	gsCheckMath			: '${gsCheckMath}',
	gsDefaultMoney		: '${gsDefaultMoney}',
	gsInoutTypeDetail	: '30',				//20200525 수정: 현재 프로그램에서는 입고유형 기본(30: 외주입고)로 변경:Ext.data.StoreManager.lookup('CBS_AU_M103').getAt(0).get('value') -> '30'
	gsLotNoInputMethod	: '${gsLotNoInputMethod}',
	gsLotNoEssential	: '${gsLotNoEssential}',
	gsEssItemAccount	: '${gsEssItemAccount}',
	gsBoxYN				: '${gsBoxYN}',
	gsQ008Sub			: '${gsQ008Sub}'	//가입고사용여부 관련
};

var CustomCodeInfo = {
	gsUnderCalBase: ''
};

var outDivCode = UserInfo.divCode;
function appMain() {
	var lotNoEssential	= BsaCodeInfo.gsLotNoEssential == "Y"?true:false;
	var sumTypeCell		= BsaCodeInfo.gsSumTypeCell =='Y'?false:true;
	var lotNoInputMethod= BsaCodeInfo.gsLotNoInputMethod == "Y"?true:false;

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'otr121ukrvService.selectMaster',
			update	: 'otr121ukrvService.updateDetail',
			create	: 'otr121ukrvService.insertDetail',
			destroy	: 'otr121ukrvService.deleteDetail',
			syncAll	: 'otr121ukrvService.saveAll'
		}
	});

	/**
	 */
	var searchForm = Unilite.createSearchForm('otr121ukrvSearchForm', {	// 메인
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						searchForm.setValue('WH_CODE', '');
					}
				}
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				holdable		: 'hold',
				allowBlank		: false,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
							searchForm.setValue('MONEY_UNIT', records[0]["MONEY_UNIT"]);
							searchForm.setValue('EXCHG_RATE_O', '1');
						},
						scope: this
					},
					onClear: function(type) {
						searchForm.setValue('MONEY_UNIT', '')
						searchForm.setValue('EXCHG_RATE_O', '');
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				holdable:'hold',
				comboType  : 'OU',
				child: 'WH_CELL_CODE',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
							store.clearFilter();
						if(!Ext.isEmpty(searchForm.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == searchForm.getValue('DIV_CODE');
							})
						}else{
							store.filterBy(function(record){
								return false;
							})
						}
					}
					}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				name: 'INOUT_DATE',
				xtype: 'uniDatefield',
				holdable:'hold',
				value: new Date(),
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',
				name:'INOUT_PRSN',
				xtype: 'uniCombobox',
				holdable:'hold',
				comboType: 'AU',
				comboCode: 'B024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehousecell" default="입고창고Cell"/>',
				name: 'WH_CELL_CODE',
				xtype:'uniCombobox',
				store: Ext.data.StoreManager.lookup('whCellList'),
				holdable: 'hold',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			}/*,{
				xtype: 'component',
				colspan: 3,
				tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' }
			},Unilite.popup('PJT',{
				 fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				 holdable:'hold',
				 colspan : 1,
				 colspan:BsaCodeInfo.gsSumTypeCell == "Y"?1:2,
				 valueFieldName: 'PROJECT_CODE',
				 listeners: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': searchForm.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel: '창고 Cell',
				holdable:'hold',
				name: 'WH_CELL_CODE',
				allowBlank: BsaCodeInfo.gsSumTypeCell == "Y"?false:true,
				hidden:BsaCodeInfo.gsSumTypeCell == "Y"?false:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				xtype: 'button',
				text: '입고현황출력',
				margin:'0 0 0 100',
				handler: function() {
					var params = {
						"INOUT_DATE":searchForm.getValue("INOUT_DATE"),
						"INOUT_CODE":searchForm.getValue("CUSTOM_CODE"),
						"INOUT_NAME":searchForm.getValue("CUSTOM_NAME"),
						"INOUT_NUM" :searchForm.getValue("INOUT_NUM"),
						"DIV_CODE"  :searchForm.getValue("DIV_CODE")
					}
					var rec1 = {data : {prgID : 'otr340rkrv', 'text':''}};
					parent.openTab(rec1, '/matrl/otr340rkrv.do', params);
				}
			}*/,{
				fieldLabel: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>',
				name:'INOUT_NUM',
				xtype: 'uniTextfield',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
				name: 'MONEY_UNIT',
				holdable:'hold',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B004',
				allowBlank: false,
				displayField: 'value',
				fieldStyle: 'text-align: center;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						fnSetColumnFormat();	//20200603 추가: blur의 UniAppManager.app.fnExchngRateO(); 주석
//						UniAppManager.app.fnExchngRateO();
					},
					blur: function( field, The, eOpts ) {
//						UniAppManager.app.fnExchngRateO();
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.exchangerate" default="환율"/>',
				name: 'EXCHG_RATE_O',
				holdable:'hold',
				xtype:'uniNumberfield',
				decimalPrecision: 4,
				value: 1,
				allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '',
				name:'COMPANY_NUM',
				readOnly: true,
				xtype: 'uniTextfield',
				hidden: true
			}
		],
		setAllFieldsReadOnly: setAllFieldsReadOnly
	});

	/**
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{ //createForm
		disabled: false,
		border:true,
		padding: '1',
		region: 'center',
		autoScroll: true,
		masterGrid: masterGrid,
		layout: {
			type: 'uniTable',
			columns : 2,
			tableAttrs: {align:'right'}
		},
		items: [{
				fieldLabel	: '<t:message code="system.label.purchase.amounttotal" default="금액합계"/>',
				name		: 'SumInoutO',
				xtype		: 'uniNumberfield',
				value		: 0,						//20200603 추가
				readOnly	: true
			},{
				fieldLabel	: '<t:message code="system.label.purchase.ownamounttotal" default="자사금액합계"/>',
				name		: 'IssueAmtWon',
				xtype		: 'uniNumberfield',
				type		: 'uniPrice',				//20200603 추가
				value		: 0,						//20200603 추가
				readOnly	: true
			}]
	});

	/**
	 */
	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {		// 검색 팝업창
		layout: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items: [
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME'
			}),{
 				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
 				name:'WH_CODE',
 				xtype: 'uniCombobox',
				comboType  : 'OU',
				colspan: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
//					 cbStore.loadStoreRecords(newValue);
					},
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
							store.clearFilter();
						if(!Ext.isEmpty(searchForm.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == searchForm.getValue('DIV_CODE');
							})
						}else{
							store.filterBy(function(record){
								return false;
							})
						}
					}
				}
 			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false
			},{
				fieldLabel: '<t:message code="system.label.purchase.warehousecell" default="창고Cell"/>',
				name: 'WH_CELL_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whCellList'),
//				allowBlank: BsaCodeInfo.gsSumTypeCell == "Y"?false:true,
				hidden:BsaCodeInfo.gsSumTypeCell == "Y"?false:true
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',
				name:'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024',
				colspan: 2
			},{
				fieldLabel: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>',
				name:'LOT_NO',
				xtype: 'uniTextfield'
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>',
				name:'INOUT_NUM',
				xtype: 'uniTextfield'
			},{
				fieldLabel: '<t:message code="system.label.purchase.pono" default="발주번호"/>',
				name:'PO_NO',
				xtype: 'uniTextfield'
			},{
                    fieldLabel: 'DIV_CODE',
                    name:'DIV_CODE',
                    xtype: 'uniTextfield',
                    hidden: true
                }
		]
	}); // createSearchForm

	/**
	 */
	var otherorderSearch = Unilite.createSearchForm('otherorderForm', {		//미입고참조
			layout :  {type : 'uniTable', columns : 3},
			items :[
				{
					fieldLabel: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_DVRY_DATE',
					endFieldName: 'TO_DVRY_DATE',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width: 315,
					allowBlank:true
				},{
					fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
					name:'ORDER_TYPE',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'M001'
				},{
 					fieldLabel: '<t:message code="system.label.purchase.powarehouse" default="발주창고"/>',
 					name:'WH_CODE',
 					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList')
 				},{
					fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
					name:'CUSTOM_CODE',
					xtype: 'uniTextfield',
					hidden: true
				},{
					fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
					name: 'MONEY_UNIT',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B004',
					displayField: 'value',
					hidden: true
				},{
					fieldLabel: 'DIV_CODE',
					name:'DIV_CODE',
					xtype: 'uniTextfield',
					hidden: true
				}
 			]
	});

	/**
	 */
	var otherorderSearch2 = Unilite.createSearchForm('otherorderForm2', {	//반품가능발주참조
			layout :  {type : 'uniTable', columns : 2},
			items :[
				{
					fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_ORDER_DATE',
					endFieldName: 'TO_ORDER_DATE',
					allowBlank: false,
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today')
				},{
 					fieldLabel: '<t:message code="system.label.purchase.powarehouse" default="발주창고"/>',
 					name:'WH_CODE',
 					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList')
 				},{
 					fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
 					name:'DIV_CODE',
 					xtype: 'uniTextfield',
					hidden:true
 				},{
 					fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
 					name:'CUSTOM_CODE',
 					xtype: 'uniTextfield',
					hidden:true
 				},{
					fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
					name: 'MONEY_UNIT',
					xtype: 'uniTextfield',
					hidden:true
				}
			]
	});

	/**
	 */
	var otherorderSearch3 = Unilite.createSearchForm('otherorderForm3', {	//검사결과참조
			layout : {type : 'uniTable', columns : 3},
			items :[
				{
					fieldLabel: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_DVRY_DATE',
					endFieldName: 'TO_DVRY_DATE',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width: 315,
					allowBlank:true
				},{
					fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
					name:'ORDER_TYPE',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'M001'
				},{
					fieldLabel: '<t:message code="system.label.purchase.receiptinspecno" default="접수/검사번호"/>',
					name: 'INSPEC_NUM',
					xtype: 'uniTextfield'
				},{
 					fieldLabel: '<t:message code="system.label.purchase.powarehouse" default="발주창고"/>',
 					name:'WH_CODE',
 					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList')
 				},{
 					fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
 					name:'DIV_CODE',
 					xtype: 'uniTextfield',
					hidden:true
 				},{
					fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
					name: 'MONEY_UNIT',
					xtype: 'uniTextfield',
					hidden:true
				},{
 					fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
 					name:'CUSTOM_CODE',
 					xtype: 'uniTextfield',
					hidden:true
 				}
			]
	});

	/**
	 * 主要的-----------------------------------------------------------------------------model
	 */
	Unilite.defineModel('Otr121ukrvModel', {		// 메인
		fields: [
			{name: 'INOUT_NUM'			,text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				,type: 'string'},
			{name: 'INOUT_SEQ'			,text: '<t:message code="system.label.purchase.seq" default="순번"/>'						,type: 'int'},
			{name: 'INOUT_METH'			,text: '<t:message code="system.label.purchase.method" default="방법"/>'					,type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>'			,type: 'string', comboType: 'AU', comboCode: 'M103',allowBlank:false},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				,type: 'string',allowBlank:false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				,type: 'string',allowBlank:false},
			{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			,type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'					,type: 'string'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			,type: 'string', comboType:'AU', comboCode:'B013',displayField: 'value'},
			{name: 'PACK_UNIT_Q'		,text:'<t:message code="system.label.sales.packunitq" default="BOX입수"/>'				,type: 'uniQty'},
			{name: 'BOX_Q'				,text:'<t:message code="system.label.sales.boxq" default="BOX수"/>'						,type: 'uniQty'},
			{name: 'EACH_Q'				,text:'<t:message code="system.label.sales.eachq" default="낱개"/>'						,type: 'uniQty'},
			{name: 'LOSS_Q'				,text:'<t:message code="system.label.sales.lossq" default="LOSS여분"/>'					,type: 'uniQty'},
			{name: 'ORDER_UNIT_Q'		,text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				,type: 'uniQty'/*,allowBlank:false*/},		//20200604 수정: 수동으로 체크하도록 변경
			{name: 'ITEM_STATUS'		,text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>'			,type: 'string', comboType: 'AU', comboCode: 'B021',allowBlank:false},
			{name: 'ORIGINAL_Q'			,text: '<t:message code="system.label.purchase.existinginqty" default="기존입고량"/>'		,type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'		,text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>'				,type: 'uniQty'},
			{name: 'BAD_STOCK_Q'		,text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'		,type: 'uniQty'},
			{name: 'NOINOUT_Q'			,text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'			,type: 'uniQty'},
			{name: 'PRICE_YN'			,text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'				,type: 'string', comboType: 'AU', comboCode: 'M301'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				,type: 'string', comboType: 'AU', comboCode: 'B004',allowBlank:false, displayField: 'value'},
			{name: 'INOUT_FOR_P'		,text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>'	,type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O'		,text: '<t:message code="system.label.purchase.inventoryunitamount" default="재고단위금액"/>'	,type: 'uniPrice',allowBlank:true},
			{name: 'ORDER_UNIT_FOR_P'	,text: '<t:message code="system.label.purchase.price" default="단가"/>'					,type: 'uniUnitPrice',allowBlank:true},
			{name: 'ORDER_UNIT_FOR_O'	,text: '<t:message code="system.label.purchase.amount" default="금액"/>'					,type: 'uniPrice',allowBlank:true},
			{name: 'ACCOUNT_YNC'		,text: '<t:message code="system.label.purchase.sliptarget" default="기표대상"/>'			,type: 'string', comboType: 'AU', comboCode: 'S014'},
			{name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			,type: 'uniER'},
			{name: 'INOUT_P'			,text: '<t:message code="system.label.purchase.copricestock" default="자사단가(재고)"/>'		,type: 'uniUnitPrice',allowBlank:true},
			{name: 'INOUT_I'			,text: '<t:message code="system.label.purchase.coamountstock" default="자사금액(재고)"/>'		,type: 'uniPrice',allowBlank:true},
			{name: 'ORDER_UNIT_P'		,text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'				,type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_I'		,text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'				,type: 'uniPrice'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			,type: 'string', comboType:'AU', comboCode:'B013',displayField: 'value'},
			{name: 'TRNS_RATE'			,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'			,type: 'uniPrice'},
			{name: 'INOUT_Q'			,text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>'	,type: 'uniQty'},
			{name: 'ORDER_TYPE'			,text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'				,type: 'string', comboType:'AU', comboCode:'M001',allowBlank:false},
			{name: 'LC_NUM'				,text: 'LC/NO(*)'		,type: 'string'},
			{name: 'BL_NUM'				,text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'					,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'					,type: 'string'},
			{name: 'ORDER_SEQ'			,text: '<t:message code="system.label.purchase.seq" default="순번"/>'						,type: 'string'},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'					,type: 'uniQty'},
			{name: 'INOUT_CODE_TYPE'	,text: '<t:message code="system.label.purchase.receiptplacetype" default="입고처구분"/>'		,type: 'string',allowBlank:false},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'		,type: 'string',  comboType   : 'OU',allowBlank:false, child: 'WH_CELL_CODE'},
			{name: 'WH_CELL_CODE'		,text:'입고창고 Cell'		,type: 'string', allowBlank: sumTypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','DIV_CODE']},
//			{name: 'WH_CELL_CODE'		,text:'<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>Cell'	,type: 'string'},
			{name: 'WH_CELL_NAME'		,text: 'CELL<t:message code="system.label.purchase.warehouse" default="창고"/>'			,type: 'string'},
			{name: 'INOUT_DATE'			,text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'			,type: 'uniDate',allowBlank:false},
			{name: 'INOUT_PRSN'			,text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'			,type: 'string'},
			{name: 'ACCOUNT_Q'			,text: '<t:message code="system.label.purchase.billqty" default="계산서량"/>'				,type: 'uniQty'},
			{name: 'CREATE_LOC'			,text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'			,type: 'string',comboType:'AU',comboCode:'B031'},
			{name: 'SALE_C_DATE'		,text: '<t:message code="system.label.purchase.billclosingdate" default="계산서마감일"/>'		,type: 'uniDate'},
			{name: 'REMARK'				,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			,type: 'string'},
			{name: 'LOT_NO'				,text: 'LOT NO'			,type: 'string', allowBlank:lotNoInputMethod || !lotNoEssential},
			{name: 'LOT_YN'				,text: '<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'		,type: 'string', comboType:'AU', comboCode:'A020'},
			{name: 'INOUT_TYPE'			,text: '<t:message code="system.label.purchase.type" default="타입"/>'					,type: 'string',comboType:'AU',comboCode:'B035'},
			{name: 'INOUT_CODE'			,text: '<t:message code="system.label.purchase.receiptplace" default="입고처"/>'			,type: 'string',allowBlank:false},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'				,type: 'string', child: 'WH_CODE'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>'			,type: 'string'},
			{name: 'COMPANY_NUM'		,text: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>'		,type: 'string'},
			{name: 'INSTOCK_Q'			,text: '<t:message code="system.label.purchase.poreceiptqty" default="발주입고수량"/>'		,type: 'uniQty'},
			{name: 'SALE_DIV_CODE'		,text: '<t:message code="system.label.purchase.salesdivision" default="매출사업장"/>'		,type: 'string'},
			{name: 'SALE_CUSTOM_CODE'	,text: '<t:message code="system.label.purchase.salesplace" default="매출처"/>'				,type: 'string'},
			{name: 'BILL_TYPE'			,text: '<t:message code="system.label.purchase.salestype" default="매출유형"/>'				,type: 'string'},
			{name: 'SALE_TYPE'			,text: '<t:message code="system.label.purchase.salesclass" default="매출구분"/>'			,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>'				,type: 'string'},
			{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.purchase.updatedate" default="수정일"/>'				,type: 'uniDate'},
			{name: 'EXCESS_RATE'		,text: '<t:message code="system.label.purchase.overreceiptrate" default="과입고허용율"/>'		,type: 'string'},
			{name: 'INSPEC_NUM'			,text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'				,type: 'string'},
			{name: 'INSPEC_SEQ'			,text: '<t:message code="system.label.purchase.seq" default="순번"/>'						,type: 'string'},
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			,type: 'string'},
			{name: 'BASIS_NUM'			,text: 'BASIS_NUM'		,type: 'string'},
			{name: 'BASIS_SEQ'			,text: 'BASIS_SEQ'		,type: 'string'},
			{name: 'SCM_FLAG_YN'		,text: 'SCM_FLAG_YN'	,type: 'string'},
			{name: 'SO_NUM'				,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'					,type:'string'},
			{name: 'SOF_CUSTOM_NAME'	,text: '<t:message code="system.label.purchase.soplacename" default="수주처명"/>'			,type:'string'},
			{name: 'SOF_ITEM_NAME'		,text: '<t:message code="system.label.purchase.soitemname" default="수주품목명"/>'			,type:'string'}
		]
	});

	/**
	 * 订单编号弹出model
	 */
	Unilite.defineModel('orderNoMasterModel', {		// 검색조회창
		fields: [
			{name: 'INOUT_NAME'			, text: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>'			, type: 'string'},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'			, type: 'uniDate'},
			{name: 'INOUT_CODE'			, text: '<t:message code="system.label.purchase.subcontractorcode" default="외주처코드"/>'	, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'		, type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('whList')},
			{name: 'WH_CELL_CODE'		, text: 'CELL<t:message code="system.label.purchase.warehouse" default="창고"/>'			, type: 'string'},
			{name: 'WH_CELL_NAME'		, text: 'CELL<t:message code="system.label.purchase.warehouse" default="창고"/>'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>'				, type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
			{name: 'INOUT_PRSN'			, text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'		, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'			, type: 'string'},
			{name: 'LOT_NO'				, text: 'LOT NO'		, type: 'string'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			, type: 'string'},
			{name: 'PO_NO'				, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'					, type: 'string'}
		]
	});

	/**
	 * 未入库参照model
	 */
	Unilite.defineModel('Otr121ukrvOTHERModel', {	//미입고참조
		fields: [
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			, type: 'string'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'					, type: 'uniQty'},
			{name: 'REMAIN_Q'			, text: '<t:message code="system.label.purchase.returnavaiableqty" default="반품가능량"/>'	, type: 'uniQty'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'NOINOUT_Q'			, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'			, type: 'uniQty'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>'	, type: 'uniQty'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			, type: 'string'},
			{name: 'ORDER_P'			, text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>'	, type: 'string'},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'					, type: 'uniUnitPrice'},
			{name: 'ORDER_O'			, text: '<t:message code="system.label.purchase.amount" default="금액"/>'					, type: 'uniPrice'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'string'},
			{name: 'LC_NUM'				, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'				, type: 'string'},
			{name: 'WH_CELL_CODE'		, text: 'CELL<t:message code="system.label.purchase.warehouse" default="창고"/>'			, type: 'string'},
			{name: 'ORDER_REQ_NUM'		, text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'	, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'				, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.conversioncoeff" default="변환계수"/>'		, type: 'string'},
			{name: 'LOT_NO'				, text: 'LOT NO'		, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'}
		]
	});

	/**
	 * 可退货发货参照model
	 */
	Unilite.defineModel('Otr121ukrvOTHERModel2', {	//반품가능발주참조
		fields: [
			{name: 'GUBUN'				, text: '<t:message code="system.label.purchase.selection" default="선택"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			, type: 'string'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'					, type: 'uniQty'},
			{name: 'REMAIN_Q'			, text: '<t:message code="system.label.purchase.returnavaiableqty" default="반품가능량"/>'	, type: 'uniQty'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'NOINOUT_Q'			, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'			, type: 'uniQty'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>'	, type: 'uniQty'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			, type: 'string'},
			{name: 'ORDER_P'			, text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>'	, type: 'string'},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'					, type: 'uniUnitPrice'},
			{name: 'ORDER_O'			, text: '<t:message code="system.label.purchase.amount" default="금액"/>'					, type: 'uniPrice'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'string'},
			{name: 'LC_NUM'				, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'				, type: 'string'},
			{name: 'WH_CELL_CODE'		, text: 'CELL<t:message code="system.label.purchase.warehouse" default="창고"/>'			, type: 'string'},
			{name: 'ORDER_REQ_NUM'		, text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'	, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'				, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.conversioncoeff" default="변환계수"/>'		, type: 'string'},
			{name: 'LOT_NO'				, text: 'LOT NO'		, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'INSPEC_NUM'			, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'				, type: 'string'},
			{name: 'INSPEC_SEQ'			, text: '<t:message code="system.label.purchase.inspecseq" default="검사순번"/>'			, type: 'string'}
		]
	});

	/**
	 * 检查结果参照model
	 */
	Unilite.defineModel('Otr121ukrvOTHERModel3', {	//검사결과참조
		fields: [
			{name: 'GUBUN'				, text: '<t:message code="system.label.purchase.selection" default="선택"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/> '				, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'INSPEC_DATE'		, text: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>'			, type: 'uniDate'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			, type: 'string'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'					, type: 'uniQty'},
			{name: 'RECEIPT_Q'			, text: '접수량'				    , type: 'uniQty'},
			{name: 'NOR_RECEIPT_Q'		, text: '(정상)접수량'				, type: 'uniQty'},
			{name: 'FREE_RECEIPT_Q'		, text: '(무상)접수량'				, type: 'uniQty'},			
			{name: 'REMAIN_Q'			, text: '<t:message code="system.label.purchase.inspecqty" default="검사량"/>'				, type: 'uniQty'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'NOINOUT_Q'			, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'			, type: 'uniQty'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>'	, type: 'uniQty'},
			{name: 'UNIT_PRICE_TYPE'	, text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'			, type: 'string', comboType: 'AU', comboCode: 'M301'},
			{name: 'ITEM_STATUS'		, text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>'			, type: 'string', comboType: 'AU', comboCode: 'B021'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			, type: 'string'},
			{name: 'ORDER_P'			, text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>'	, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'					, type: 'uniUnitPrice'},
			{name: 'ORDER_O'			, text: '<t:message code="system.label.purchase.amount" default="금액"/>'					, type: 'uniPrice'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'string'},
			{name: 'LC_NUM'				, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'				, type: 'string'},
			{name: 'WH_CELL_CODE'		, text: 'CELL<t:message code="system.label.purchase.warehouse" default="창고"/>'			, type: 'string'},
			{name: 'ORDER_REQ_NU'		, text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'	, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'				, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.conversioncoeff" default="변환계수"/>'		, type: 'string'},
			{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.purchase.poreceiptqty" default="발주입고수량"/>'		, type: 'uniQty'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'EXCESS_RATE'		, text: '<t:message code="system.label.purchase.overreceiptrate" default="과입고허용율"/>'	, type: 'string'},
			{name: 'INSPEC_NUM'			, text: '<t:message code="system.label.purchase.receiptinspecno" default="접수/검사번호"/>'	, type: 'string'},
			{name: 'INSPEC_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'string'},
			{name: 'PORE_Q'				, text: '<t:message code="system.label.purchase.pobalance" default="발주잔량"/>'			, type: 'uniQty'},
			{name: 'LOT_NO'				, text: 'LOT NO'		, type: 'string'},
			{name: 'INSPEC_REMARK'		, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'INSPEC_PROJECT_NO'	, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'SO_NUM'				, text: '수주번호'			,type:'string'},
			{name: 'SOF_CUSTOM_NAME'	, text: '수주처명'			,type:'string'},
			{name: 'SOF_ITEM_NAME'		, text: '수주품목명'			,type:'string'},
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>'				, type: 'string',comboType:'AU',comboCode:'M103'}			
		]
	});

	/**
	 * 主要的--------------------------------------------------------------------------------store
	 */
	var directMasterStore1 = Unilite.createStore('otr121ukrvMasterStore1',{		// 메인
		model: 'Otr121ukrvModel',
		uniOpt: {
			isMaster : true,		// 상위 버튼 연결
			editable : true,		// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			allDeletable : true,
			useNavi  : false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy   : directProxy,
		loadStoreRecords: function() {
			var param= searchForm.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				isLoad = false;			//20200603 추가
				this.fnSumAmountI();
			},
			add: function(store, records, index, eOpts) {
				this.fnSumAmountI();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				this.fnSumAmountI();
			},
			remove: function(store, record, index, isMove, eOpts) {
				this.fnSumAmountI();
			}
		},
		fnSumAmountI:function(){
			var dAmountI = Ext.isNumeric(this.sum('ORDER_UNIT_FOR_O')) ? this.sum('ORDER_UNIT_FOR_O'):0; // 재고단위금액
			var dIssueAmtWon = Ext.isNumeric(this.sum('ORDER_UNIT_I')) ? this.sum('ORDER_UNIT_I'):0;	// 자사금액(재고)

			panelResult.setValue('SumInoutO'	, dAmountI);
			panelResult.setValue('IssueAmtWon'	, dIssueAmtWon);
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();

			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			var isErr = false;
			Ext.each(list, function(record, index) {
				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
					alert((index + 1) + '<t:message code="system.message.purchase.message026" default="행의 입력값을 확인 해주세요."/>'+'\n' + 'LOT NO: ' + '<t:message code="system.label.purchase.required" default="은(는) 필수입력 사항입니다."/>');
					isErr = true;
					return false;
				}
				var msg = '';
				//20200604 수정: 금액보정일 경우 입고량 체크 안하도록 로직 추가
				if(record.get('INOUT_TYPE_DETAIL') != '91'){
					if(record.get('ORDER_UNIT_Q') == 0){
						msg +='\n'+'<t:message code="system.label.purchase.receiptqty" default="입고량"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>'+'\n' ;
					}
				}
				if(record.get('INOUT_TYPE_DETAIL') != '20'){
					//20200604 추가: 금액보정일 경우 단가 체크 안하도록 로직 추가
					if(record.get('INOUT_TYPE_DETAIL') != '91'){
						if(record.get('ORDER_UNIT_FOR_P') == 0){
							msg += '<t:message code="system.label.purchase.price" default="단가"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>'+'\n' ;
						}
						if(record.get('INOUT_P') == 0){
							msg += '<t:message code="system.label.purchase.copricestock" default="자사단가(재고)"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>'+'\n' ;
						}
					}
					if(record.get('INOUT_FOR_O') == 0){
						msg +='\n'+'<t:message code="system.label.purchase.inventoryunitamount" default="재고단위금액"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>'+'\n' ;
					}
					if(record.get('ORDER_UNIT_FOR_O') == 0){
						msg += '<t:message code="system.label.purchase.amount" default="금액"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>'+'\n' ;
					}
					if(record.get('INOUT_I') == 0){
						msg += '<t:message code="system.label.purchase.coamountstock" default="자사금액(재고)"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>'+'\n' ;
					}
				}
				if(msg != ''){
					alert((index + 1) + '<t:message code="system.message.purchase.message026" default="행의 입력값을 확인 해주세요."/>' + msg +'\n' );
					isErr = true;
					return false;
				}
			});
			if(isErr) return false;

			var inoutNum = searchForm.getValue('INOUT_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['INOUT_NUM'] != inoutNum) {
					record.set('INOUT_NUM', inoutNum);
				}
			})
			//1. 마스터 정보 파라미터 구성
			var paramMaster= searchForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var result = batch.operations[0].getResultSet();
						searchForm.setValue("INOUT_NUM", result['INOUT_NUM']);
						searchForm.getForm().wasDirty = false;
						searchForm.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						if(directMasterStore1.getCount() == 0){
                            UniAppManager.app.onResetButtonDown();
                        } else {
                            UniAppManager.app.onQueryButtonDown();
                        }
						//UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('otr121ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	/**
	 * 订单编号弹出store
	 */
	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {		// 검색버튼 조회창
			model: 'orderNoMasterModel',
			autoLoad: false,
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false			// prev | newxt 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read: 'otr121ukrvService.selectDetail'
				}
			},
			loadStoreRecords : function() {
				var param= orderNoSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField:"INOUT_NAME"
	});

	/**
	 * 未入库参照store
	 */
	var otherOrderStore = Unilite.createStore('otr121ukrvOtherOrderStore', {	//미입고참조
			model: 'Otr121ukrvOTHERModel',
			autoLoad: false,
			uniOpt : {
				isMaster: false,		// 상위 버튼 연결
				editable: false,		// 수정 모드 사용
				deletable:false,		// 삭제 가능 여부
				useNavi : false			// prev | newxt 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read : 'otr121ukrvService.selectDetail2'
				}
			},
			listeners:{
				load:function(store, records, successful, eOpts) {
					if(successful) {
					 var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					 var estiRecords = new Array();
					 if(masterRecords.items.length > 0) {
							Ext.each(records, function(item, i) {
								Ext.each(masterRecords.items, function(record, i) {
   									if((record.data['ORDER_NUM'] == item.data['ORDER_NUM'])
   									&& (record.data['ORDER_SEQ'] == item.data['ORDER_SEQ'])){
   										estiRecords.push(item);
   									}
								});
							});
						 store.remove(estiRecords);
					 }
					}
				}
			},
			loadStoreRecords : function() {
				var param= otherorderSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});

	/**
	 * 可退货发货参照store
	 */
	var otherOrderStore2 = Unilite.createStore('otr121ukrvOtherOrderStore2', {	//반품가능발주참조
			model: 'Otr121ukrvOTHERModel2',
			autoLoad: false,
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false			// prev | newxt 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read : 'otr121ukrvService.selectDetail3'
				}
			},
			listeners:{
				load:function(store, records, successful, eOpts) {
					if(successful) {
					 var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					 var estiRecords = new Array();
					 if(masterRecords.items.length > 0) {
							Ext.each(records, function(item, i) {
								Ext.each(masterRecords.items, function(record, i) {
   									if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM'])
   									&& (record.data['ORDER_SEQ'] == item.data['ORDER_SEQ'])){
   										estiRecords.push(item);
   									}
								});
							});
						 store.remove(estiRecords);
					 }
					}
				}
			},
			loadStoreRecords : function() {
				var param= otherorderSearch2.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});

	/**
	 * 检查结果参照store ########
	 */
	var otherOrderStore3 = Unilite.createStore('otr121ukrvOtherOrderStore3', {	//검사결과/무검사참조 겸용
			model: 'Otr121ukrvOTHERModel3',
			autoLoad: false,
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false			// prev | newxt 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read : 'otr121ukrvService.selectDetail4'
				}
			},
			listeners:{
				load:function(store, records, successful, eOpts) {
					if(successful) {
					 var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					 var estiRecords = new Array();
					 if(masterRecords.items.length > 0) {
							Ext.each(records, function(item, i) {
								Ext.each(masterRecords.items, function(record, i) {
   									if((record.data['INSPEC_NUM'] == item.data['INSPEC_NUM'])
   									&& (record.data['INSPEC_SEQ'] == item.data['INSPEC_SEQ'])
   									&& (record.data['ORDER_NUM'] == item.data['ORDER_NUM'])
   									&& (record.data['ORDER_SEQ'] == item.data['ORDER_SEQ'])){
   										estiRecords.push(item);
   									}
								});
							});
						 store.remove(estiRecords);
					 }
					}
				}
			},
			loadStoreRecords : function() {
				var param= otherorderSearch3.getValues();
				param.WINDOW_FLAG = windowFlag;
				console.log( param );
				this.load({
					params : param
				});
			},groupField:'INSPEC_NUM'
	});

	/**
	 * 主要的-------------------------------------------------------------------------------grid
	 */
	var masterGrid = Unilite.createGrid('otr121ukrvGrid1', {						// 메인
		layout : 'fit',
		region:'center',
		uniOpt: {
			expandLastColumn : false,
			useRowNumberer   : false,
			useContextMenu   : true,
			useLiveSearch	: true
		},
		tbar: [{
			xtype: 'button',
			text: '<t:message code="system.label.purchase.slipentry" default="지급결의 등록"/>',
			hidden: true,
			margin:'0 0 0 100',
			handler: function() {
				if(masterGrid.getStore().getCount() <= 1){
					alert('<t:message code="system.message.purchase.message027" default="등록할 자료가 없습니다."/>')
					return;
				}
				var bCheck = false;
				var records = masterGrid.getStore().data.items;
				for(var i = 0; i < records.length; i++){
					if(records[i].get("PRICE_YN") == 'Y'){
						if(records[i].get("ACCOUNT_Q") <= 'Y'){
							bCheck = true;
						}
					}
				}
				if(!bCheck){
					alert('<t:message code="system.message.purchase.message027" default="등록할 자료가 없습니다."/>')
					return;
				}
				var rec1 = {data : {prgID : 'map100ukrv', 'text':''}};
				parent.openTab(rec1, '/matrl/map100ukrv.do', {});
			}
		},'-',{
			itemId: 'NotInoutBtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.unreceiptreference" default="미입고참조"/></div>',
			handler: function() {
				if(searchForm.setAllFieldsReadOnly(true)){
					openNotInoutWindow();
				}
			}
		},'-',{
			itemId: 'BBtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.inspecresultrefer" default="검사결과참조"/></div>',
			handler: function() {
				windowFlag = 'inspectResult';
				if(CheckResultWindow) {
					CheckResultWindow.setConfig('title', '<t:message code="system.label.purchase.inspecresultrefer" default="검사결과참조"/>');
				}
				openCheckResultWindow();
			}
		},'-',{
			itemId: 'inspectnoBtn',
//			id:'inspectnoBtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.noinspecreference" default="무검사참조"/></div>',
			handler: function() {
				windowFlag = 'inspectNo';
				if(CheckResultWindow) {
					CheckResultWindow.setConfig('title', '<t:message code="system.label.purchase.noinspecreference" default="무검사참조"/>');
				}
				openCheckResultWindow();
			}
		},'-',{
			itemId: 'ABtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.returnavaiableporefer" default="반품가능발주참조"/></div>',
			handler: function() {
				if(searchForm.setAllFieldsReadOnly(true)){
					openReturnOrderWindow();
				}
			}
		}],
		store: directMasterStore1,
		features: [ 
			{id: 'masterGridSubTotal1'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
			{id: 'masterGridTotal1'		, ftype: 'uniSummary'			, showSummaryRow: true}			//20200327 수정: 전체합계 표시
		],
		columns:  [
			{ dataIndex: 'INOUT_NUM'		, width:66, hidden: true},
			{ dataIndex: 'INOUT_SEQ'		, width:66, align: 'center'},								//20200603 추가: 가운데 정렬
			{ dataIndex: 'INOUT_METH'		, width:66, hidden: true},
			{ dataIndex: 'INOUT_TYPE_DETAIL', width:76,
				//20200327 추가: 전체합계 표시
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex: 'ITEM_CODE'		, width:120,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										masterGrid.setItemData(record,false);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record,false);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setItemData(null,true);
						}
					}
				})
			},
			{ dataIndex: 'ITEM_NAME'		, width:160,
				editor: Unilite.popup('DIV_PUMOK_G', {
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
					autoPopup: true,
					listeners: {'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										masterGrid.setItemData(record,false);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record,false);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setItemData(null,true);
						}
					}
				})
			},
			{ dataIndex: 'LOT_NO'			, width:120,
				getEditor: function(record) {
					return getLotPopupEditor(BsaCodeInfo.gsLotNoInputMethod);
				}
			 },
			{ dataIndex: 'LOT_YN'			, width:120, hidden: true},
			{ dataIndex: 'WH_CODE'			, width:100},
			{ dataIndex: 'WH_CELL_CODE'		, width:120, hidden: BsaCodeInfo.gsSumTypeCell == "Y"?false:true,	//20200603 수정: width 166 -> 120
				//20200416 추가: 
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filter('option', record.get('WH_CODE'));
				}
			},
			{ dataIndex: 'ITEM_ACCOUNT'		, width:66, hidden: true},
			{ dataIndex: 'SPEC'				, width:150},
			{ dataIndex: 'ORDER_UNIT'		, width:66, align:'center'},
			{ dataIndex: 'PACK_UNIT_Q'		, width:100, hidden: BsaCodeInfo.gsBoxYN == 'Y' ? false : true, summaryType: 'sum'},
			{ dataIndex: 'BOX_Q'			, width:100, hidden: BsaCodeInfo.gsBoxYN == 'Y' ? false : true, summaryType: 'sum'},
			{ dataIndex: 'EACH_Q'			, width:100, hidden: BsaCodeInfo.gsBoxYN == 'Y' ? false : true, summaryType: 'sum'},
			{ dataIndex: 'LOSS_Q'			, width:100, hidden: BsaCodeInfo.gsBoxYN == 'Y' ? false : true, summaryType: 'sum'},
			{ dataIndex: 'ORDER_UNIT_Q'		, width:86, summaryType: 'sum'},
			{ dataIndex: 'ITEM_STATUS'		, width:86},
			{ dataIndex: 'ORIGINAL_Q'		, width:86, hidden: true},
			{ dataIndex: 'GOOD_STOCK_Q'		, width:86, summaryType: 'sum'},
			{ dataIndex: 'BAD_STOCK_Q'		, width:86, summaryType: 'sum'},
			{ dataIndex: 'NOINOUT_Q'		, width:86, summaryType: 'sum'},
			{ dataIndex: 'PRICE_YN'			, width:66, hidden: true},
			{ dataIndex: 'MONEY_UNIT'		, width:66, hidden: true},
			{ dataIndex: 'INOUT_FOR_P'		, width:66, hidden: true},
			{ dataIndex: 'INOUT_FOR_O'		, width:66, hidden: true},
			{ dataIndex: 'ORDER_UNIT_FOR_P'	, width:100},
			{ dataIndex: 'ORDER_UNIT_FOR_O'	, width:100, summaryType: 'sum'},
			{ dataIndex: 'ACCOUNT_YNC'		, width:80},
			{ dataIndex: 'EXCHG_RATE_O'		, width:100, hidden: true},
			{ dataIndex: 'INOUT_P'			, width:100, hidden: true},
			{ dataIndex: 'INOUT_I'			, width:100, hidden: true},
			{ dataIndex: 'ORDER_UNIT_P'		, width:100},
			{ dataIndex: 'ORDER_UNIT_I'		, width:100, summaryType: 'sum'},
			{ dataIndex: 'STOCK_UNIT'		, width:80,align:"center"},
			{ dataIndex: 'TRNS_RATE'		, width:100},
			{ dataIndex: 'INOUT_Q'			, width:105, summaryType: 'sum'},
			{ dataIndex: 'ORDER_TYPE'		, width:60, hidden: true},
			{ dataIndex: 'LC_NUM'			, width:100, hidden: true},
			{ dataIndex: 'BL_NUM'			, width:66, hidden: true},
			{ dataIndex: 'ORDER_NUM'		, width:133, hidden: true},
			{ dataIndex: 'ORDER_SEQ'		, width:33, hidden: true},
			{ dataIndex: 'ORDER_Q'			, width:100, summaryType: 'sum'},
			{ dataIndex: 'INOUT_CODE_TYPE'	, width:33, hidden: true},
			{ dataIndex: 'WH_CELL_NAME'		, width:166, hidden: true},
			{ dataIndex: 'INOUT_DATE'		, width:73, hidden: true},
			{ dataIndex: 'INOUT_PRSN'		, width:33, hidden: true},
			{ dataIndex: 'ACCOUNT_Q'		, width:33, hidden: true},
			{ dataIndex: 'CREATE_LOC'		, width:33, hidden: true},
			{ dataIndex: 'SALE_C_DATE'		, width:33, hidden: true},
			{ dataIndex: 'REMARK'			, width:150},
			{ dataIndex: 'PROJECT_NO'		, width:120,
				getEditor : function(record){
					return getPjtNoPopupEditor();
				}
			},
			{ dataIndex: 'INOUT_TYPE'		, width:33, hidden: true},
			{ dataIndex: 'INOUT_CODE'		, width:66, hidden: true},
			{ dataIndex: 'DIV_CODE'			, width:33, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'		, width:120},
			{ dataIndex: 'COMPANY_NUM'		, width:100},
			{ dataIndex: 'INSTOCK_Q'		, width:66, hidden: true},
			{ dataIndex: 'SALE_DIV_CODE'	, width:66, hidden: true},
			{ dataIndex: 'SALE_CUSTOM_CODE'	, width:66, hidden: true},
			{ dataIndex: 'BILL_TYPE'		, width:66, hidden: true},
			{ dataIndex: 'SALE_TYPE'		, width:66, hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'	, width:66, hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'	, width:66, hidden: true},
			{ dataIndex: 'EXCESS_RATE'		, width:66, hidden: true},
			{ dataIndex: 'INSPEC_NUM'		, width:66, hidden: true},
			{ dataIndex: 'INSPEC_SEQ'		, width:66, hidden: true},
			{ dataIndex: 'COMP_CODE'		, width:66, hidden: true},
			{ dataIndex: 'BASIS_NUM'		, width:66, hidden: true},
			{ dataIndex: 'BASIS_SEQ'		, width:66, hidden: true},
			{ dataIndex: 'SCM_FLAG_YN'		, width:66, hidden: true},
			{ dataIndex: 'SO_NUM'			, width:66, hidden: true},
			{ dataIndex: 'SOF_CUSTOM_NAME'	, width:66, hidden: true},
			{ dataIndex: 'SOF_ITEM_NAME'	, width:66, hidden: true}
		],
		listeners: {
			afterrender: function(grid) {	//useContextMenu:true 설정으로 툴바 우측 버튼은 자동 생성되며 그 외 추가할 메뉴  작성
				this.contextMenu.add({
					xtype: 'menuseparator'
				},{
					text: '<t:message code="system.label.purchase.iteminfo" default="품목정보"/>',   iconCls : '',
					handler: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						var params = {
							ITEM_CODE : record.get('ITEM_CODE')
						}
						var rec = {data : {prgID : 'bpr100ukrv', 'text':''}};
						parent.openTab(rec, '/base/bpr100ukrv.do', params);
					}
				},{
					text: '<t:message code="system.label.purchase.custominfo" default="거래처정보"/>',   iconCls : '',
					handler: function(menuItem, event) {
						var params = {
							CUSTOM_CODE : searchForm.getValue('CUSTOM_CODE'),
							COMP_CODE : UserInfo.compCode
						}
						var rec = {data : {prgID : 'bcm100ukrv', 'text':''}};
						parent.openTab(rec, '/base/bcm100ukrv.do', params);
					}
				})
			},
			//contextMenu의 복사한 행 삽입 실행 전
			beforePasteRecord: function(rowIndex, record) {
				//if(!UniAppManager.app.checkForNewDetail()) return false;
					var seq = directMasterStore1.max('INOUT_SEQ');
					if(!seq) seq = 1;
					else  seq += 1;
					record.INOUT_SEQ = seq;

					return true;
			},
			//contextMenu의 복사한 행 삽입 실행 후
			afterPasteRecord: function(rowIndex, record) {
				searchForm.setAllFieldsReadOnly(true);
			},
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
					if(UniUtils.indexOf(e.field, ['ORDER_UNIT', 'ORDER_UNIT_Q', 'ITEM_STATUS', 'ORDER_UNIT_FOR_P', 'ORDER_UNIT_FOR_O',
												//20200714 수정: 신규가 아닌 데이터는 'WH_CODE', 'WH_CELL_CODE' 수정 못하도록 변경
												'ACCOUNT_YNC', 'ORDER_UNIT_P'/*, 'WH_CODE', 'WH_CELL_CODE'*/, 'ORDER_UNIT_I', 'REMARK', 'PROJECT_NO', 'LOT_NO', 'PACK_UNIT_Q', 'BOX_Q', 'EACH_Q', 'LOSS_Q']))
					{
						return true;
					} else {
						return false;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['INOUT_SEQ', 'INOUT_TYPE_DETAIL', 'ITEM_CODE', 'ITEM_NAME', 'ORDER_UNIT', 'ORDER_UNIT_Q',
												'ITEM_STATUS', 'ORDER_UNIT_FOR_P', 'ORDER_UNIT_FOR_O', 'ACCOUNT_YNC', 'ORDER_UNIT_P',
												'ORDER_UNIT_I', 'WH_CODE', 'WH_CELL_CODE', 'REMARK', 'PROJECT_NO', 'LOT_NO', 'PACK_UNIT_Q', 'BOX_Q', 'EACH_Q', 'LOSS_Q']))
					{
						return true;
					} else {
						return false;
					}
				}
			}
		},
		setItemData: function(record, dataClear) {
			var grdRecord = this.getSelectedRecord();
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, '');
				grdRecord.set('ITEM_NAME'		, '');
				grdRecord.set('SPEC'			, '');
				grdRecord.set('ORDER_UNIT'		, '');
				grdRecord.set('STOCK_UNIT'		, '');
				grdRecord.set('TRNS_RATE'		, '');
				grdRecord.set('ITEM_ACCOUNT'	, '');
				grdRecord.set('GOOD_STOCK_Q'	, '0');
				grdRecord.set('BAD_STOCK_Q'		, '0');
				grdRecord.set('LOT_YN'			, '');
				UniAppManager.app.fnSelectItemPrice(grdRecord, record)
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('ORDER_UNIT'		, record['ORDER_UNIT']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
				grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
				grdRecord.set('LOT_YN'			, record['LOT_YN']);
				UniAppManager.app.fnSelectItemPrice(grdRecord, record);

				directMasterStore1.fnSumAmountI();
				UniAppManager.app.selectStockQ(grdRecord)
			}
			UniAppManager.app.selectOrderPrice("N", grdRecord)
		},
		setNotInoutData: function(record) {						// 미입고참조 셋팅
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('INOUT_TYPE'			, '1');//입고
			grdRecord.set('INOUT_METH'			, '1');
			grdRecord.set('INOUT_NUM'			, searchForm.getValue('INOUT_NUM'));
			grdRecord.set('INOUT_TYPE_DETAIL'	, BsaCodeInfo.gsInoutTypeDetail);
			grdRecord.set('INOUT_CODE_TYPE'		, '5');
			grdRecord.set('INOUT_CODE'			, searchForm.getValue('CUSTOM_CODE'));
			grdRecord.set('CUSTOM_NAME'			, searchForm.getValue('CUSTOM_NAME'));
			grdRecord.set('CREATE_LOC'			, '2');//자재
			grdRecord.set('INOUT_DATE'			, searchForm.getValue('INOUT_DATE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ITEM_STATUS'			, '1');
			grdRecord.set('ACCOUNT_Q'			, '0');
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			if(record['TRNS_RATE'] == 0) {
				record.set('TRNS_RATE'			, '1');
			} else {
				grdRecord.set('TRNS_RATE'		, record['TRNS_RATE'])
			}
			grdRecord.set('ORDER_UNIT_Q'		, record['REMAIN_Q']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_FOR_O'	, record['ORDER_UNIT_P'] * record['REMAIN_Q']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P'] * searchForm.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_UNIT_I'		, fnWonCalc(record['ORDER_UNIT_P'] * record['REMAIN_Q'] * searchForm.getValue('EXCHG_RATE_O')));	//20200713 추가: 자사금액 소숫점 처리로직 추가
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('INOUT_Q'				, record['NOINOUT_Q']);
			grdRecord.set('NOINOUT_Q'			, record['NOINOUT_Q']);
			grdRecord.set('INOUT_I'				, fnWonCalc(record['ORDER_UNIT_P'] * record['REMAIN_Q'] * searchForm.getValue('EXCHG_RATE_O')));	//20200713 수정, 20200713 추가: 자사금액 소숫점 처리로직 추가
			grdRecord.set('ACCOUNT_YNC'			, 'Y');
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('INOUT_P'				, record['ORDER_P'] * searchForm.getValue('EXCHG_RATE_O'));
			grdRecord.set('INOUT_FOR_P'			, record['ORDER_P']);
			grdRecord.set('INOUT_FOR_O'			, record['ORDER_UNIT_P'] * record['REMAIN_Q']);
			grdRecord.set('EXCHG_RATE_O'		, searchForm.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, !record['ORDER_SEQ']?0:record['ORDER_SEQ']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('LC_NUM'				, record['LC_NUM']);
			grdRecord.set('WH_CODE'				, searchForm.getValue('WH_CODE'));
			if(BsaCodeInfo.gsSumTypeCell == 'Y') {
				grdRecord.set('WH_CELL_CODE'		, searchForm.getValue('WH_CELL_CODE'));
			} else {
				grdRecord.set('WH_CELL_CODE'		, '');
			}
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('COMPANY_NUM'			, record['COMPANY_NUM']);
			grdRecord.set('INOUT_PRSN'			, searchForm.getValue('INOUT_PRSN'));
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');
			grdRecord.set('INSTOCK_Q'			, '0');
			grdRecord.set('PRICE_YN'			, 'Y');
			grdRecord.set('ORIGINAL_Q'			, '0');
			if(record['DIV_CODE'] == '') {
				grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			} else {
				grdRecord.set('DIV_CODE'		, searchForm.getValue('DIV_CODE'));
			}
			directMasterStore1.fnSumAmountI();
			UniAppManager.app.selectStockQ(grdRecord)
		},
		setReturnOrderData: function(record) {					// 반품가능발주참조 셋팅
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('INOUT_TYPE'			, '1');
			grdRecord.set('INOUT_METH'			, '1');
			grdRecord.set('INOUT_NUM'			, searchForm.getValue('INOUT_NUM'));
			grdRecord.set('INOUT_TYPE_DETAIL'	, BsaCodeInfo.gsInoutTypeDetail);
			grdRecord.set('INOUT_CODE_TYPE'		, '5');
			grdRecord.set('INOUT_CODE'			, searchForm.getValue('CUSTOM_CODE'));
			grdRecord.set('CUSTOM_NAME'			, searchForm.getValue('CUSTOM_NAME'));
			grdRecord.set('CREATE_LOC'			, '2');
			grdRecord.set('INOUT_DATE'			, searchForm.getValue('INOUT_DATE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ITEM_STATUS'			, '1');
			grdRecord.set('ACCOUNT_Q'			, '0');
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			if(record['TRNS_RATE'] == 0) {
				record.set('TRNS_RATE'			, '1');
			} else {
				grdRecord.set('TRNS_RATE'		, record['TRNS_RATE'])
			}
			grdRecord.set('ORDER_UNIT_Q'		, record['REMAIN_Q']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_FOR_O'	, record['ORDER_UNIT_P'] * record['REMAIN_Q']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P'] * searchForm.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_UNIT_I'		, fnWonCalc(record['ORDER_UNIT_P'] * record['REMAIN_Q'] * searchForm.getValue('EXCHG_RATE_O')));	//20200713 추가: 자사금액 소숫점 처리로직 추가
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('INOUT_Q'				, record['NOINOUT_Q']);
			grdRecord.set('NOINOUT_Q'			, record['NOINOUT_Q']);
			grdRecord.set('INOUT_I'				, fnWonCalc(record['ORDER_UNIT_P'] * record['REMAIN_Q'] * searchForm.getValue('EXCHG_RATE_O')));	//20200713 추가: 자사금액 소숫점 처리로직 추가
			grdRecord.set('ACCOUNT_YNC'			, 'Y');
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('INOUT_P'				, record['ORDER_P'] * searchForm.getValue('EXCHG_RATE_O'));
			grdRecord.set('INOUT_FOR_P'			, record['ORDER_P']);
			grdRecord.set('INOUT_FOR_O'			, record['ORDER_UNIT_P'] * record['REMAIN_Q']);
			grdRecord.set('EXCHG_RATE_O'		, searchForm.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, !record['ORDER_SEQ']?0:record['ORDER_SEQ']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('LC_NUM'				, record['LC_NUM']);
			grdRecord.set('WH_CODE'				, searchForm.getValue('WH_CODE'));
			if(BsaCodeInfo.gsSumTypeCell == 'Y') {
				grdRecord.set('WH_CELL_CODE'	, searchForm.getValue('WH_CELL_CODE'));
			} else {
				grdRecord.set('WH_CELL_CODE'	, '');
			}
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');
			grdRecord.set('INSPEC_NUM'			, record['INSPEC_NUM']);
			grdRecord.set('INSPEC_SEQ'			, !record['INSPEC_SEQ']?0:record['INSPEC_SEQ']);
			grdRecord.set('INSTOCK_Q'			, '0');
			grdRecord.set('PRICE_YN'			, 'Y');
			grdRecord.set('ORIGINAL_Q'			, '0');
			if(record['DIV_CODE'] == '') {
				grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			} else {
				grdRecord.set('DIV_CODE'		, searchForm.getValue('DIV_CODE'));
			}
			directMasterStore1.fnSumAmountI();
			UniAppManager.app.selectStockQ(grdRecord)
		},
		setCheckResultData: function(record) {					// 검사결과참조 셋팅
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('INOUT_TYPE'			, '1');
			grdRecord.set('INOUT_METH'			, '1');
			grdRecord.set('INOUT_NUM'			, searchForm.getValue("INOUT_NUM"));
			grdRecord.set('INOUT_TYPE_DETAIL'	, record['INOUT_TYPE_DETAIL']);
			grdRecord.set('INOUT_CODE_TYPE'		, '5');
			grdRecord.set('INOUT_CODE'			, searchForm.getValue('CUSTOM_CODE'));
			grdRecord.set('CUSTOM_NAME'			, searchForm.getValue('CUSTOM_NAME'));
			grdRecord.set('CREATE_LOC'			, '2');
			grdRecord.set('INOUT_DATE'			, searchForm.getValue('INOUT_DATE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ITEM_STATUS'			, record['ITEM_STATUS']);
			grdRecord.set('ACCOUNT_Q'			, '0');
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			if(record['TRNS_RATE'] == 0) {
				record.set('TRNS_RATE'			, '1');
				grdRecord.set('TRNS_RATE'		, record['TRNS_RATE'])
			}
			grdRecord.set('ORDER_UNIT_Q'		, record['NOINOUT_Q']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_FOR_O'	, record['ORDER_UNIT_P'] * record['NOINOUT_Q']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P'] * searchForm.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_UNIT_I'		, fnWonCalc(record['ORDER_UNIT_P'] * record['NOINOUT_Q'] * searchForm.getValue('EXCHG_RATE_O')));	//20200713 추가: 자사금액 소숫점 처리로직 추가
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('INOUT_Q'				, record['NOINOUT_Q'] * record['TRNS_RATE']);
			grdRecord.set('NOINOUT_Q'			, record['NOINOUT_Q'] * record['TRNS_RATE']);
			grdRecord.set('INOUT_I'				, fnWonCalc(record['ORDER_UNIT_P'] * record['NOINOUT_Q'] * searchForm.getValue('EXCHG_RATE_O')));	//20200713 추가: 자사금액 소숫점 처리로직 추가
			grdRecord.set('ACCOUNT_YNC'			, 'Y');
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('INOUT_P'				, grdRecord.get('INOUT_I') / grdRecord.get('INOUT_Q'));
			grdRecord.set('INOUT_FOR_O'			, record['ORDER_UNIT_P'] * record['NOINOUT_Q']);
			grdRecord.set('INOUT_FOR_P'			, grdRecord.get('INOUT_FOR_O') / grdRecord.get('INOUT_Q'));
			grdRecord.set('EXCHG_RATE_O'		, searchForm.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, !record['ORDER_SEQ']?0:record['ORDER_SEQ']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('LC_NUM'				, record['LC_NUM']);
			grdRecord.set('WH_CODE'				, searchForm.getValue('WH_CODE'));
			if(BsaCodeInfo.gsSumTypeCell == 'Y') {
				grdRecord.set('WH_CELL_CODE'	, searchForm.getValue('WH_CELL_CODE'));
			} else {
				grdRecord.set('WH_CELL_CODE'	, '');
			}
			grdRecord.set('INOUT_PRSN'			, searchForm.getValue('INOUT_PRSN'));
			grdRecord.set('ORIGINAL_Q'			, '0');
			if(searchForm.getValue['DIV_CODE'] == '') {
				grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			} else {
				grdRecord.set('DIV_CODE'		, searchForm.getValue('DIV_CODE'));
			}
			grdRecord.set('REMARK'				, record['INSPEC_REMARK']);
			grdRecord.set('PROJECT_NO'			, record['INSPEC_PROJECT_NO']);
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');
			grdRecord.set('INSPEC_NUM'			, record['INSPEC_NUM']);
			grdRecord.set('INSPEC_SEQ'			, !record['INSPEC_SEQ']?0:record['INSPEC_SEQ']);
			grdRecord.set('INSTOCK_Q'			, '0');
			grdRecord.set('PRICE_YN'			, 'Y');

			directMasterStore1.fnSumAmountI();
			UniAppManager.app.selectStockQ(grdRecord)
		}
	});

	/**
	 * 订单编号弹出grid
	 */
	var orderNoMasterGrid = Unilite.createGrid('otr121ukrvOrderNoMasterGrid', {		// 검색팝업창
		// title: '기본',
		layout : 'fit',
		store: orderNoMasterStore,
		uniOpt:{
			useRowNumberer: false,
			useLiveSearch : true,
			useGroupSummary : true,
			excel: {
				useExcel	: true,		//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData	: false,
				summaryExport : true
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
		columns:  [
			{ dataIndex: 'INOUT_NAME'		, width: 170},
			{ dataIndex: 'INOUT_DATE'		, width: 90},
			{ dataIndex: 'INOUT_CODE'		, width: 100, hidden: true},
			{ dataIndex: 'WH_CODE'			, width: 120},
			{ dataIndex: 'WH_CELL_CODE'		, width: 120, hidden: BsaCodeInfo.gsSumTypeCell == "Y"?false:true},
			{ dataIndex: 'WH_CELL_NAME'		, width: 120, hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 100},
			{ dataIndex: 'INOUT_PRSN'		, width: 100},
			{ dataIndex: 'INOUT_NUM'		, width: 120},
			{ dataIndex: 'LOT_NO'			, width: 120},
			{ dataIndex: 'MONEY_UNIT'		, width: 53, hidden: true},
			{ dataIndex: 'EXCHG_RATE_O'		, width: 53, hidden: true},
			{ dataIndex: 'PO_NO'			, width: 120, hidden: false}
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				searchForm.setAllFieldsReadOnly(true)
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			searchForm.setValues({'CUSTOM_CODE':record.get('INOUT_CODE')});
			searchForm.setValues({'CUSTOM_NAME':record.get('INOUT_NAME')});
			searchForm.setValues({'INOUT_DATE':record.get('INOUT_DATE')});
			searchForm.setValues({'WH_CODE':record.get('WH_CODE')});
			searchForm.setValues({'INOUT_NUM':record.get('INOUT_NUM')});
			isLoad = true;			//20200603 추가
			searchForm.setValues({'MONEY_UNIT':record.get('MONEY_UNIT')});
			searchForm.setValues({'EXCHG_RATE_O':record.get('EXCHG_RATE_O')});
		}
	});

	/**
	 * 未入库参照弹出grid
	 */
	var otherorderGrid = Unilite.createGrid('otr121ukrvOtherorderGrid', {			//미입고참조
		// title: '기본',
		layout : 'fit',
		store: otherOrderStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt:{
			onLoadSelectFirst : false,
			useLiveSearch	 : true
		},
		columns:  [
			{ dataIndex: 'ITEM_CODE'		, width: 120},
			{ dataIndex: 'ITEM_NAME'		, width: 150},
			{ dataIndex: 'SPEC'				, width: 150},
			{ dataIndex: 'DVRY_DATE'		, width: 90},
			{ dataIndex: 'DIV_CODE'			, width: 80,  hidden: true},
			{ dataIndex: 'ORDER_UNIT'		, width: 80,  align:'center'},
			{ dataIndex: 'ORDER_UNIT_Q'		, width: 100, hidden: true},
			{ dataIndex: 'REMAIN_Q'			, width: 100, hidden: true},
			{ dataIndex: 'STOCK_UNIT'		, width: 53,  hidden: true},
			{ dataIndex: 'NOINOUT_Q'		, width: 100},
			{ dataIndex: 'ORDER_Q'			, width: 100, hidden: true},
			{ dataIndex: 'MONEY_UNIT'		, width: 80,  align:'center'},
			{ dataIndex: 'EXCHG_RATE_O'		, width: 100, hidden: true},
			{ dataIndex: 'ORDER_P'			, width: 100, hidden: true},
			{ dataIndex: 'ORDER_UNIT_P'		, width: 100},
			{ dataIndex: 'ORDER_O'			, width: 100},
			{ dataIndex: 'ORDER_NUM'		, width: 120},
			{ dataIndex: 'ORDER_SEQ'		, width: 66,  align:'center'},
			{ dataIndex: 'LC_NUM'			, width: 60,  hidden: true},
			{ dataIndex: 'WH_CODE'			, width: 100, hidden: true},
			{ dataIndex: 'WH_CELL_CODE'		, width: 100, hidden: BsaCodeInfo.gsSumTypeCell == "Y"?false:true},
			{ dataIndex: 'ORDER_REQ_NUM'	, width: 133, hidden: true},
			{ dataIndex: 'ORDER_TYPE'		, width: 133, hidden: true},
			{ dataIndex: 'CUSTOM_CODE'		, width: 133, hidden: true},
			{ dataIndex: 'TRNS_RATE'		, width: 133, hidden: true},
			{ dataIndex: 'LOT_NO'			, width: 120},
			{ dataIndex: 'REMARK'			, width: 150},
			{ dataIndex: 'PROJECT_NO'		, width: 120}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setNotInoutData(record.data);
			});
			this.deleteSelectedRow();
		}
	});

	/**
	 * 可退货发货参照弹出grid
	 */
	var otherorderGrid2 = Unilite.createGrid('otr121ukrvOtherorderGrid2', {			//반품가능발주참조
		// title: '기본',
		layout : 'fit',
		store: otherOrderStore2,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt:{
			onLoadSelectFirst : false,
			useLiveSearch : true
		},
		columns:  [
			{ dataIndex: 'ITEM_CODE'		, width: 101},
			{ dataIndex: 'ITEM_NAME'		, width: 140},
			{ dataIndex: 'SPEC'				, width: 120},
			{ dataIndex: 'DVRY_DATE'		, width: 80},
			{ dataIndex: 'DIV_CODE'			, width: 80, hidden: true},
			{ dataIndex: 'ORDER_UNIT'		, width: 70, align:'center'},
			{ dataIndex: 'ORDER_UNIT_Q'		, width: 100, hidden: true},
			{ dataIndex: 'REMAIN_Q'			, width: 100},
			{ dataIndex: 'STOCK_UNIT'		, width: 53, hidden: true},
			{ dataIndex: 'NOINOUT_Q'		, width: 100, hidden: true},
			{ dataIndex: 'ORDER_Q'			, width: 100, hidden: true},
			{ dataIndex: 'MONEY_UNIT'		, width: 70, align:'center'},
			{ dataIndex: 'EXCHG_RATE_O'		, width: 100, hidden: true},
			{ dataIndex: 'ORDER_P'			, width: 86, hidden: true},
			{ dataIndex: 'ORDER_UNIT_P'		, width: 100},
			{ dataIndex: 'ORDER_O'			, width: 110},
			{ dataIndex: 'ORDER_NUM'		, width: 100},
			{ dataIndex: 'ORDER_SEQ'		, width: 66, align:'center'},
			{ dataIndex: 'LC_NUM'			, width: 60, hidden: true},
			{ dataIndex: 'WH_CODE'			, width: 100, hidden: true},
			{ dataIndex: 'WH_CELL_CODE'		, width: 100, hidden: BsaCodeInfo.gsSumTypeCell == "Y"?false:true},
			{ dataIndex: 'ORDER_REQ_NUM'	, width: 133, hidden: true},
			{ dataIndex: 'ORDER_TYPE'		, width: 133, hidden: true},
			{ dataIndex: 'CUSTOM_CODE'		, width: 133, hidden: true},
			{ dataIndex: 'TRNS_RATE'		, width: 133, hidden: true},
			{ dataIndex: 'LOT_NO'			, width: 133},
			{ dataIndex: 'REMARK'			, width: 133},
			{ dataIndex: 'PROJECT_NO'		, width: 133},
			{ dataIndex: 'INSPEC_NUM'		, width: 110},
			{ dataIndex: 'INSPEC_SEQ'		, width: 80}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setReturnOrderData(record.data);
			});
			this.deleteSelectedRow();
		}
	});

	/**
	 * 检查结果参照弹出grid
	 */
	var otherorderGrid3 = Unilite.createGrid('otr121ukrvOtherorderGrid3', {			//검사결과참조
		// title: '기본',
		layout : 'fit',
		store: otherOrderStore3,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt:{
			onLoadSelectFirst : false,
			useLiveSearch	 : true,
			useGroupSummary : true
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
		columns:  [
			{ dataIndex: 'ITEM_CODE'				, width: 120, locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '');
				}
			},
			{ dataIndex: 'ITEM_NAME'				, width: 166, locked: false},
			{ dataIndex: 'ITEM_ACCOUNT'				, width: 100, hidden: true},
			{ dataIndex: 'SPEC'						, width: 150},
			{ dataIndex: 'DVRY_DATE'				, width: 93},
			{ dataIndex: 'INSPEC_DATE'				, width: 93},
			{ dataIndex: 'DIV_CODE'					, width: 101, hidden: true},
			{ dataIndex: 'ORDER_UNIT'				, width: 66,align:'center'},
			{ dataIndex: 'ORDER_UNIT_Q'				, width: 100, hidden: true},
			{dataIndex: 'INOUT_TYPE_DETAIL'         , width:150,hidden:true},
			{dataIndex: 'RECEIPT_Q'			        , width:100,hidden:false,summaryType: 'sum'},
			{dataIndex: 'NOR_RECEIPT_Q'		        , width:100,hidden:false,summaryType: 'sum'},
			{dataIndex: 'FREE_RECEIPT_Q'	        , width:100,hidden:false,summaryType: 'sum'},			
			{ dataIndex: 'REMAIN_Q'					, width: 100, summaryType: 'sum'},
			{ dataIndex: 'STOCK_UNIT'				, width: 53, hidden: true},
			{ dataIndex: 'NOINOUT_Q'				, width: 100, summaryType: 'sum'},
			{ dataIndex: 'ORDER_Q'					, width: 100, hidden: true},
			{ dataIndex: 'UNIT_PRICE_TYPE'			, width: 80,align:'center'},
			{ dataIndex: 'ITEM_STATUS'				, width: 66,align:'center'},
			{ dataIndex: 'MONEY_UNIT'				, width: 66,align:'center'},
			{ dataIndex: 'EXCHG_RATE_O'				, width: 93, hidden: true},
			{ dataIndex: 'ORDER_P'					, width: 93, hidden: true},
			{ dataIndex: 'ORDER_UNIT_P'				, width: 100},
			{ dataIndex: 'ORDER_O'					, width: 100, summaryType: 'sum'},
			{ dataIndex: 'ORDER_NUM'				, width: 120},
			{ dataIndex: 'ORDER_SEQ'				, width: 66,align:'center'},
			{ dataIndex: 'LC_NUM'					, width: 53, hidden: true},
			{ dataIndex: 'WH_CODE'					, width: 53, hidden: true},
			{ dataIndex: 'WH_CELL_CODE'				, width: 53, hidden: BsaCodeInfo.gsSumTypeCell == "Y"?false:true},
			{ dataIndex: 'ORDER_REQ_NU'				, width: 53, hidden: true},
			{ dataIndex: 'ORDER_TYPE'				, width: 53, hidden: true},
			{ dataIndex: 'CUSTOM_CODE'				, width: 60, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'				, width: 120},
			{ dataIndex: 'TRNS_RATE'				, width: 0, hidden: true},
			{ dataIndex: 'INSTOCK_Q'				, width: 0, hidden: true},
			{ dataIndex: 'PROJECT_NO'				, width: 0, hidden: true},
			{ dataIndex: 'EXCESS_RATE'				, width: 0, hidden: true},
			{ dataIndex: 'INSPEC_NUM'				, width: 120},
			{ dataIndex: 'INSPEC_SEQ'				, width: 66,align:'center'},
			{ dataIndex: 'PORE_Q'					, width: 100},
			{ dataIndex: 'LOT_NO'					, width: 100},
			{ dataIndex: 'INSPEC_REMARK'			, width: 133},
			{ dataIndex: 'INSPEC_PROJECT_NO'		, width: 133},
			{ dataIndex: 'SO_NUM'					, width:66, hidden: true},
			{ dataIndex: 'SOF_CUSTOM_NAME'  		, width:66, hidden: true},
			{ dataIndex: 'SOF_ITEM_NAME'			, width:66, hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setCheckResultData(record.data);
			});
			this.deleteSelectedRow();
		}
	});

	/**
	 * 订单编号弹出----------------------------------------------------------------------window
	 */
	function openSearchInfoWindow() {		// 검색팝업창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.inventory.subcontractreceiptnosearch" default="외주입고번호검색"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [orderNoSearch, orderNoMasterGrid], //orderNomasterGrid],
				tbar	: ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							orderNoMasterStore.loadStoreRecords();
						},
						disabled: false
					}, {
						itemId : 'OrderNoCloseBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						orderNoSearch.clearForm();
						//orderNoMasterGrid.reset();
						orderNoMasterGrid.getStore().loadData({});
					},
					beforeclose: function( panel, eOpts ) {
						orderNoSearch.clearForm();
						//orderNoMasterGrid.reset();
						orderNoMasterGrid.getStore().loadData({});
					},
					show: function( panel, eOpts ) {
						orderNoSearch.setValue('DIV_CODE'		, searchForm.getValue('DIV_CODE'));
						orderNoSearch.setValue('INOUT_PRSN'		, searchForm.getValue('INOUT_PRSN'));
						orderNoSearch.setValue('CUSTOM_CODE'	, searchForm.getValue('CUSTOM_CODE'));
						orderNoSearch.setValue('CUSTOM_NAME'	, searchForm.getValue('CUSTOM_NAME'));
						orderNoSearch.setValue('WH_CODE'		, searchForm.getValue('WH_CODE'));
						orderNoSearch.setValue('FR_INOUT_DATE'	, UniDate.get('startOfMonth'));
						orderNoSearch.setValue('TO_INOUT_DATE'	, UniDate.get('today'));
						orderNoSearch.setValue('WH_CELL_CODE'	, searchForm.getValue('WH_CELL_CODE'));
					}
				}
			})
		}
		SearchInfoWindow.show();
		SearchInfoWindow.center();
	}

	/**
	 * 未入库参照弹出window
	 */
	function openNotInoutWindow() {			//미입고참조
		if(!UniAppManager.app.checkForNewDetail()) return false;
		otherorderSearch.setValue('CUSTOM_CODE', searchForm.getValue('CUSTOM_CODE'));
		if(!NotInoutWindow) {
			NotInoutWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.unreceiptreference" default="미입고참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [otherorderSearch, otherorderGrid],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							otherOrderStore.loadStoreRecords();
						},
						disabled: false
					},{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.purchase.receiptapply2" default="입고적용"/>',
						handler: function() {
							otherorderGrid.returnData();
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.purchase.receiptapplyclose" default="입고적용후 닫기"/>',
						handler: function() {
							otherorderGrid.returnData();
							NotInoutWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							NotInoutWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						otherorderSearch.clearForm();
						otherorderGrid.reset();
						otherorderGrid.getStore().clearData();
					},
					beforeclose: function( panel, eOpts ) {
						otherorderSearch.clearForm();
						otherorderGrid.reset();
						otherorderGrid.getStore().clearData();
					},
					beforeshow: function ( me, eOpts ) {
						otherorderSearch.setValue('CUSTOM_CODE',searchForm.getValue('CUSTOM_CODE'));
						otherorderSearch.setValue('MONEY_UNIT',searchForm.getValue('MONEY_UNIT'));
						otherorderSearch.setValue('ORDER_TYPE',"4");//4：外包
						otherorderSearch.setValue('DIV_CODE',searchForm.getValue('DIV_CODE'));
						otherOrderStore.loadStoreRecords();
					}
				}
			})
		}
		NotInoutWindow.show();
		NotInoutWindow.center();
	}

	/**
	 * 可退货发货参照弹出window
	 */
	function openReturnOrderWindow() {		//반품가능발주참조
		if(!ReturnOrderWindow) {
			ReturnOrderWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.returnavaiableporefer" default="반품가능발주참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [otherorderSearch2, otherorderGrid2],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							otherOrderStore2.loadStoreRecords();
						},
						disabled: false
					},{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.purchase.receiptapply2" default="입고적용"/>',
						handler: function() {
							otherorderGrid2.returnData();
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.purchase.receiptapplyclose" default="입고적용후 닫기"/>',
						handler: function() {
							otherorderGrid2.returnData();
							ReturnOrderWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							ReturnOrderWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function ( me, eOpts ) {
						otherorderSearch2.setValue('CUSTOM_CODE',searchForm.getValue('CUSTOM_CODE'));
						otherorderSearch2.setValue('MONEY_UNIT',searchForm.getValue('MONEY_UNIT'));
						otherorderSearch2.setValue('DIV_CODE',searchForm.getValue('DIV_CODE'));
						otherorderSearch2.setValue('WH_CODE',searchForm.getValue('WH_CODE'));
						otherOrderStore2.loadStoreRecords();
					}
				}
			})
		}
		ReturnOrderWindow.show();
		ReturnOrderWindow.center();
	}

	/**
	 * 检查结果参照弹出window
	 */
	function openCheckResultWindow() {		//검사결과참조(무검사겸용)
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!CheckResultWindow) {
			CheckResultWindow = Ext.create('widget.uniDetailWindow', {
				title: windowFlag == 'inspectResult' ?  '<t:message code="system.label.purchase.inspecresultrefer" default="검사결과참조"/>' : '<t:message code="system.label.purchase.noinspecreference" default="무검사참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [otherorderSearch3, otherorderGrid3],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							otherOrderStore3.loadStoreRecords();
						},
						disabled: false
					},{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.purchase.receiptapply2" default="입고적용"/>',
						handler: function() {
							otherorderGrid3.returnData();
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.purchase.receiptapplyclose" default="입고적용후 닫기"/>',
						handler: function() {
							otherorderGrid3.returnData();
							searchForm.setAllFieldsReadOnly(false)
							CheckResultWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							searchForm.setAllFieldsReadOnly(false)
							CheckResultWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
 						otherorderSearch3.clearForm();
						otherorderGrid3.reset();
						otherOrderStore3.clearData();
						},
					beforeclose: function( panel, eOpts ) {
						otherorderSearch3.clearForm();
						otherorderGrid3.reset();
						otherOrderStore3.clearData();
						windowFlag = '';
						},
					beforeshow: function ( me, eOpts ) {
						otherorderSearch3.setValue('FR_DVRY_DATE',UniDate.get('startOfMonth'));
						otherorderSearch3.setValue('TO_DVRY_DATE',UniDate.get('today'));
						otherorderSearch3.setValue('CREATE_LOC',searchForm.getValue('CREATE_LOC'));
						otherorderSearch3.setValue('CUSTOM_CODE',searchForm.getValue('CUSTOM_CODE'));
						otherorderSearch3.setValue('MONEY_UNIT',searchForm.getValue('MONEY_UNIT'));
						otherorderSearch3.setValue('DIV_CODE',searchForm.getValue('DIV_CODE'));
						var fieldName = windowFlag == 'inspectResult' ? '<t:message code="system.label.purchase.inspecdate" default="검사일"/>' : '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'
						otherorderSearch3.getField('FR_DVRY_DATE').fieldContainer.setFieldLabel(fieldName);
						otherOrderStore3.loadStoreRecords();
					}
				}
			})
		}
		CheckResultWindow.show();
		CheckResultWindow.center();
	}

	/**
	 * main函数---------------------------------------------------------------------------------
	 */
	Unilite.Main({
		id			: 'otr121ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [{
					region	: 'center',
					xtype	: 'container',
					layout	: 'fit',
					items	: [ masterGrid ]
				},
				searchForm,
				{
					region	: 'north',
					xtype	: 'container',
					highth	: 20,
					layout	: 'fit',
					items	: [ panelResult ]
				}
			]
		}],
		fnInitBinding: function() {
			if(BsaCodeInfo.gsQ008Sub == 'Y'){			//무검사참조
				masterGrid.down('#NotInoutBtn').setHidden(true);
				masterGrid.down('#inspectnoBtn').setHidden(false);
			}else{	//미입고참조
				masterGrid.down('#NotInoutBtn').setHidden(false);
				masterGrid.down('#inspectnoBtn').setHidden(true);
			}
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
			this.setDefault();
		},
		onQueryButtonDown: function() {					// 조회버튼 눌렀을때
			searchForm.setAllFieldsReadOnly(false);
			var inoutNo = searchForm.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow()
			} else {
				searchForm.setAllFieldsReadOnly(true);
				fnSetColumnFormat();	//20200603 추가
				isLoad = true;			//20200603 추가
				directMasterStore1.loadStoreRecords();
			};
		},
		setDefault: function() {						// 기본값
			isLoad = false;			//20200603 추가
			searchForm.setValue('DIV_CODE'	, UserInfo.divCode);
			searchForm.setValue('INOUT_DATE', new Date());
			searchForm.setValue('MONEY_UNIT', BsaCodeInfo.gsDefaultMoney);
			searchForm.getForm().wasDirty = false;
			searchForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
			UniAppManager.app.fnExchngRateO(true);
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(searchForm.getValue('INOUT_DATE')),
				"MONEY_UNIT": searchForm.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					//20200603 !isLoad 추가
					if(!isLoad && provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(searchForm.getValue('MONEY_UNIT')) && searchForm.getValue('MONEY_UNIT') != "KRW"){
						alert('<t:message code="system.message.purchase.datacheck002" default="환율정보가 없습니다."/>')
					}
					panelResult.setValue('EXCHG_RATE_O'	, provider.BASE_EXCHG);
				}
			});
		},
		onResetButtonDown: function() {				// 초기화
			this.suspendEvents();
			searchForm.clearForm();
			searchForm.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterGrid.getStore().clearData();
			this.fnInitBinding();
			searchForm.getField('CUSTOM_CODE').focus();
		},
		onNewDataButtonDown: function() {			// 행추가
			if(!this.checkForNewDetail()) return false;
			var inoutNum		= searchForm.getValue('INOUT_NUM');
			var seq				= directMasterStore1.max('INOUT_SEQ');
			seq					= !seq?1:seq + 1;
			var accountYnc		= 'Y';
			var inoutType		= '1';
			var inoutCodeType	= '5';
			var whCode			= searchForm.getValue('WH_CODE');
			var whCellCode		= searchForm.getValue('WH_CELL_CODE');
			var inoutPrsn		= searchForm.getValue('INOUT_PRSN');
			var inoutCode		= searchForm.getValue('CUSTOM_CODE');
			var customName		= searchForm.getValue('CUSTOM_NAME');
			var credateLoc		= '2';
			var inoutDate		= searchForm.getValue('INOUT_DATE');
			var inoutMeth		= '1';
			var inoutTypeDetail	= BsaCodeInfo.gsInoutTypeDetail; //판매유형콤보value중 첫번째 value
			var itemStatus		= '1';
			var accountQ		= '0';
			var orderUnitQ		= '0';
			var inoutQ			= '0';
			var inoutI			= '0';
			var moneyUnit		= searchForm.getValue('MONEY_UNIT');
			var inoutP			= '0';
			var inoutForP		= '0';
			var inoutForO		= '0';
			var orderType		= '4';
			var originalQ		= '0';
			var noinoutQ		= '0';
			var goodStockQ		= '0';
			var badStockQ		= '0';
			var exchgRateO		= searchForm.getValue('EXCHG_RATE_O');
			var trnsRate		= '1';
			var divCode			= searchForm.getValue('DIV_CODE');
			var saleDivCode		= '*';
			var saleCustomCode	= '*';
			var saleType		= '*';
			var billType		= '*';
			var priceYn			= 'Y';
			var excessRate		= '0';
			var instockQ		= '0';
			var basisSeq		= '0';
			var inspecSeq		= '0';
			var orderSeq		= '0';

			var r = {
				ACCOUNT_YNC:		accountYnc,
				INOUT_NUM:			inoutNum,
				INOUT_SEQ:			seq,
				INOUT_TYPE:			inoutType,
				INOUT_CODE_TYPE:	inoutCodeType,
				WH_CODE:			whCode,
				WH_CELL_CODE:		whCellCode,
				INOUT_PRSN:			inoutPrsn,
				INOUT_CODE:			inoutCode,
				CUSTOM_NAME:		customName,
				CREATE_LOC:			credateLoc,
				INOUT_DATE:			inoutDate,
				INOUT_METH:			inoutMeth,
				INOUT_TYPE_DETAIL:	inoutTypeDetail,
				ITEM_STATUS:		itemStatus,
				ACCOUNT_Q:			accountQ,
				ORDER_UNIT_Q:		orderUnitQ,
				INOUT_Q:			inoutQ,
				INOUT_I:			inoutI,
				MONEY_UNIT:			moneyUnit,
				INOUT_P:			inoutP,
				INOUT_FOR_P:		inoutForP,
				INOUT_FOR_O:		inoutForO,
				ORDER_TYPE:			orderType,
				ORIGINAL_Q:			originalQ,
				NOINOUT_Q:			noinoutQ,
				GOOD_STOCK_Q:		goodStockQ,
				BAD_STOCK_Q:		badStockQ,
				EXCHG_RATE_O:		exchgRateO,
				TRNS_RATE:			trnsRate,
				DIV_CODE:			divCode,
				SALE_DIV_CODE:		saleDivCode,
				SALE_CUSTOM_CODE:	saleCustomCode,
				SALE_TYPE:			saleType,
				BILL_TYPE:			billType,
				PRICE_YN:			priceYn,
				EXCESS_RATE:		excessRate,
				INSTOCK_Q:			instockQ,
				BASIS_SEQ:			basisSeq,
				INSPEC_SEQ:			inspecSeq,
				ORDER_SEQ:			orderSeq
			};
//			cbStore.loadStoreRecords(whCode);
			masterGrid.createRow(r);
			directMasterStore1.fnSumAmountI();
		},
		onDeleteDataButtonDown: function() {		// 행삭제 버튼
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore1.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('<t:message code="system.message.purchase.message008" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						if(deletable){
							masterGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
						isNewData = false;
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore1.saveStore();
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(searchForm.getValue('ORDER_NUM'))) {
				alert('<t:message code="unilite.msg.sMS533" default="수주번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}
			if(searchForm.setAllFieldsReadOnly(true)){
				return searchForm.setAllFieldsReadOnly(true)
			}
			return false;
		},
		fnSelectItemPrice:function(grdRecord, record){
			if(!grdRecord || !record){
				return;
			}
			if(grdRecord.get("INOUT_Q") == ''){
				grdRecord.set("INOUT_Q", '0')
			}
			//재고단가 = 구매단가 / 변환계수
			var dInoutP = 0
			if(record["ORDER_P"] != '0' && record["TRNS_RATE"] != 0){
				dInoutP = record["ORDER_P"]/record["TRNS_RATE"]
			}else{
				dInoutP = 0
			}
			grdRecord.set("INOUT_P", dInoutP);
			grdRecord.set("INOUT_I", grdRecord.get("INOUT_P") * grdRecord.get("INOUT_Q"));
			if(grdRecord.get("EXCHG_RATE_O") != 0){
				grdRecord.set("INOUT_FOR_P", dInoutP / grdRecord.get("EXCHG_RATE_O"));
				grdRecord.set("INOUT_FOR_P", grdRecord.get("INOUT_Q") * dInoutP / grdRecord.get("EXCHG_RATE_O"));
			}else{
				grdRecord.set("INOUT_FOR_P", '0');
				grdRecord.set("INOUT_FOR_P", '0');
			}
		},
		selectOrderPrice: function(flag, grdRecord){
			var param = {
				'ITEM_CODE'	 : grdRecord.get("ITEM_CODE"),
				'ORDER_UNIT'	: grdRecord.get("ORDER_UNIT"),
				'ITEM_ACCOUNT'  : grdRecord.get("ITEM_ACCOUNT"),
				'DIV_CODE'	: grdRecord.get("DIV_CODE"),
				'MONEY_UNIT'	: grdRecord.get("MONEY_UNIT")
			}
			otr121ukrvService.selectGetOrderPrice(param, function(provider, response){
				if(!Ext.isEmpty(provider)) {
					var dExchangeRate = 0;
					if(searchForm.getValue("EXCHG_RATE_O") != ""){
						dExchangeRate = searchForm.getValue("EXCHG_RATE_O")
					}
					if(grdRecord.get("ORDER_UNIT_Q") == ""){
						grdRecord.set("ORDER_UNIT_Q", '0')
					}
					if(grdRecord.get("ORDER_UNIT_Q") != "0"){
						grdRecord.set("INOUT_Q", grdRecord.get("ORDER_UNIT_Q") * provider['TRNS_RATE'])
					}
					if(!grdRecord.get("ORDER_UNIT_Q") && flag == "N"){
						if(provider['ORDER_P'] != '0'){
							grdRecord.set("ORDER_UNIT_FOR_P", provider['ORDER_P'])
							grdRecord.set("ORDER_UNIT_P", provider['ORDER_P'] * dExchangeRate)
						}else{
							grdRecord.set("ORDER_UNIT_FOR_P", '0')
							grdRecord.set("ORDER_UNIT_P", '0')
						}
					}
					if(provider['TRNS_RATE'] != '0'){
						grdRecord.set("TRNS_RATE", provider['TRNS_RATE'])
					}else{
						grdRecord.set("TRNS_RATE", '1')
					}
					grdRecord.set("ORDER_UNIT"		, provider['ORDER_UNIT'])
					grdRecord.set("STOCK_UNIT"		, provider['STOCK_UNIT'])
					grdRecord.set("ORDER_UNIT_FOR_O", grdRecord.get("ORDER_UNIT_FOR_P") * grdRecord.get("ORDER_UNIT_Q"))
					grdRecord.set("ORDER_UNIT_I"	, fnWonCalc(grdRecord.get("ORDER_UNIT_P") * grdRecord.get("ORDER_UNIT_Q")))	//20200713 추가: 자사금액 소숫점 처리로직 추가
					grdRecord.set("INOUT_FOR_P"		, grdRecord.get("ORDER_UNIT_FOR_P") / grdRecord.get("TRNS_RATE"))
					grdRecord.set("INOUT_P"			, grdRecord.get("ORDER_UNIT_P") / grdRecord.get("TRNS_RATE"))
					grdRecord.set("INOUT_I"			, fnWonCalc(grdRecord.get("INOUT_P") * grdRecord.get("INOUT_P")))			//20200713 추가: 자사금액 소숫점 처리로직 추가
					grdRecord.set("INOUT_FOR_O"		, grdRecord.get("INOUT_FOR_P") * grdRecord.get("INOUT_Q"))
				}
			})
		},
		selectStockQ:function(grdRecord){
			var param = {
				'WH_CODE'   : grdRecord.get("WH_CODE"),
				'ITEM_CODE' : grdRecord.get("ITEM_CODE")
			}
			otr121ukrvService.selectStockQ(param, function(provider, response){
				if(!Ext.isEmpty(provider)) {
					grdRecord.set('GOOD_STOCK_Q', provider['GOOD_STOCK_Q']);
					grdRecord.set('BAD_STOCK_Q', provider['BAD_STOCK_Q']);
				}
			});
		}
	});

	/**
	 * 校验器
	 */
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ORDER_SEQ" :	// 순번
					if(newValue <= '0') {
						rv= '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
				break;

				case "ORDER_UNIT_Q" :	// 입고량
					if(record.get('ITEM_CODE') == '') {
						rv='<t:message code="system.message.purchase.message026" default="품목코드를 입력 하십시오."/>';
						break;
					}
					if(BsaCodeInfo.gsCheckMath == '2') {
						rv='<t:message code="system.message.purchase.message029" default="외주출고량 체크방법이 [출고예약량 기준]일 경우 Partial 등록이 불가능하여 입고량을 변경할 수 없습니다."/>';
						break;
					}
					var dInoutQ3 = newValue * record.get('TRNS_RATE');

					if(newValue < 0) {															//20200604 수정: record.get('ORDER_UNIT_Q') -> newValue
						if(record.get('ORDER_NUM') != '') {
							var dOrderQ = record.get('ORDER_Q');
							var dInoutQ = (newValue * record.get('TRNS_RATE'));					//20200604 수정: record.get('ORDER_UNIT_Q') -> newValue
							var dNoInoutQ = record.get('NOINOUT_Q');
							var dEnableQ = (dOrderQ + (dOrderQ * BsaCodeInfo.glPerCent / 100)) / record.get('TRNS_RATE');
							var dTempQ = (dOrderQ - dNoInoutQ + dInoutQ - record.get('ORIGINAL_Q')) / record.get('TRNS_RATE');
						}
						if(dNoInoutQ > 0) {
							if(dTempQ > dEnableQ) {
								dEnableQ = (dNoInoutQ + record.get('ORIGINAL_Q')) / record.get('TRNS_RATE') + (dEnableQ - (dOrderQ / record.get('TRNS_RATE')));
								rv='<t:message code="system.message.purchase.message030" default="입고량은 발주량에 과입고허용률을 적용한 입고가능량보다 클 수 없습니다."/>' + '<t:message code="system.message.purchase.message031" default="입고가능수량 : "/>' + dEnableQ;
								break;
							}
						}
					}
					record.set('INOUT_Q', dInoutQ3)

					if(BsaCodeInfo.gsInvstatus == '+') {	// 1368 ~~ 1401 물어봐야함.
						if(newValue < '0') {
							var dInoutQ1 = 0;
							var dOriginalQ = 0;
							var dStockQ = 0;
							var findRecs = directMasterStore1.findBy(function(rec,id){
								return rec['ITEM_CODE'] == record['ITEM_CODE'] && rec != record;
							});
							if(findRecs.length > 0){
								Ext.each(findRecs, function(findRec,i) {
									if(findRec.phantom === true || findRec.dirty === true){
										if(findRec.get("ITEM_STATUS") != record.get("ITEM_STATUS") && newValue != ''){
											dInoutQ1 = dInoutQ1 + newValue;
											doriginalQ =  doriginalQ + findRec.get("ORIGINAL_Q")
										}
									}
								});
								dInoutQ1 = dInoutQ1 + newValue;
								doriginalQ = doriginalQ + record.get("ORIGINAL_Q");
								if(record.get("ITEM_STATUS") != '1'){
									dStockQ = record.get("GOOD_STOCK_Q")
								}else{
									dStockQ = record.get("BAD_STOCK_Q")
								}
								if((dStockQ - doriginalQ) < dInoutQ1 * (-1)){
									rv = '<t:message code="system.message.purchase.message030" default="입고량은 발주량에 과입고허용률을 적용한 입고가능량보다 클 수 없습니다."/>'+ (dStockQ - doriginalQ)
									break;
								}
							}
						}
					}
					if(record.get('ORDER_UNIT_P') != '') {
						record.set('ORDER_UNIT_I', fnWonCalc(record.get('ORDER_UNIT_P') * newValue));	//20200713 추가: 자사금액 소숫점 처리로직 추가
					} else {
						record.set('ORDER_UNIT_I','0');
					}
					if (record.get('ORDER_UNIT_FOR_P') != '') {
						record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_FOR_P') * newValue));
					} else {
						record.set('ORDER_UNIT_FOR_O','0');
					}
					record.set('INOUT_I'	, record.get('ORDER_UNIT_I'));
					record.set('INOUT_FOR_O', record.get('ORDER_UNIT_FOR_O'));
					directMasterStore1.fnSumAmountI();
				break;

				case "INOUT_P" :	// 자사단가(재고단위)
					if(record.get('ACCOUNT_YNC') == 'Y' && record.get('INOUT_TYPE_DETAIL') != '91') {
						rv='<t:message code="system.message.purchase.message032" default="기표대상여부가 기표일때 단가는 0보다 커야 합니다."/>';
						break;
					} else if(newValue < '0') {
						rv='<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
						break;
					}
					record.set('INOUT_I',(record.get('INOUT_Q') * newValue));
					if(record.get('EXCHG_RATE_O') != '0') {
						record.set('INOUT_FOR_P',(newValue / record.get('EXCHG_RATE_O')));					//20200604 수정: record.get('INOUT_P') -> newValue
						record.set('INOUT_FOR_O',(record.get('INOUT_Q') * newValue / record.get('EXCHG_RATE_O')));
					} else {
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
					}
					directMasterStore1.fnSumAmountI();
				break;

				case "INOUT_I" : // 자사금액(재고단위)
					if(newValue < '0') {
						rv= '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					if(record.get('INOUT_Q') != '0') {
						record.set('INOUT_P',(newValue / record.get('INOUT_Q')));
					} else {
						record.set('INOUT_P','0');
					}
					if(record.get('EXCHG_RATE_O') != '0') {
						record.set('INOUT_FOR_P',(record.get('INOUT_P') / record.get('EXCHG_RATE_O')));
						record.set('INOUT_FOR_O',(newValue / record.get('EXCHG_RATE_O')));					//20200604 수정: record.get('INOUT_I') -> newValue
					} else {
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
					}
					directMasterStore1.fnSumAmountI();
				break;

				case "TRNS_RATE" :
					if(newValue <= '0') {
						rv= '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					var dInoutQ = 0;
					if(record.get('ORDER_UNIT_Q') != '') {
						dInoutQ = (record.get('ORDER_UNIT_Q') * newValue);					//20200604 수정: record.get('TRNS_RATE') -> newValue
					} else {
						dInoutQ = '0';
					}
					record.set('INOUT_Q', dInoutQ);
					if(record.get('ORDER_UNIT_P') != '') {
						record.set('INOUT_P',(record.get('ORDER_UNIT_P') / newValue));
					} else {
						record.set('INOUT_P','0');
					}
					if(record.get('ORDER_UNIT_FOR_P') != '') {
						record.set('INOUT_FOR_P',(record.get('ORDER_UNIT_FOR_P') / newValue));
					} else {
						record.set('INOUT_FOR_P','0');
					}
					directMasterStore1.fnSumAmountI();
				break;

				case "ORDER_UNIT_P" :	// 자사단가(구매단위)
					if(record.get('ACCOUNT_YNC') == 'Y' && record.get('INOUT_TYPE_DETAIL') != '91') {
						if(newValue <= '0') {
							rv= '<t:message code="system.message.purchase.message032" default="기표대상여부가 기표일때 단가는 0보다 커야 합니다."/>';
							break;
						}
					} else if(newValue < '0') {
						rv= '<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
							break;
					}
					record.set('INOUT_P'		,(newValue / record.get('TRNS_RATE')));
					record.set('ORDER_UNIT_I'	,fnWonCalc(record.get('ORDER_UNIT_Q') * newValue));	//20200713 추가: 자사금액 소숫점 처리로직 추가
					record.set('INOUT_I'		,(record.get('ORDER_UNIT_I')));
					if(record.get('EXCHG_RATE_O') != '0') {
						record.set('INOUT_FOR_P',(record.get('INOUT_P') / record.get('EXCHG_RATE_O')));
						record.set('ORDER_UNIT_FOR_P',(newValue / record.get('EXCHG_RATE_O')));									//20200604 수정: record.get('ORDER_UNIT_P') -> newValue
						record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_Q') * newValue) / record.get('EXCHG_RATE_O'));	//20200604 수정: record.get('ORDER_UNIT_P') -> newValue
						record.set('INOUT_FOR_O',record.get('ORDER_UNIT_FOR_O'));
					} else {
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}
					directMasterStore1.fnSumAmountI();
				break;

				case "ORDER_UNIT_I" : 	// 자사금액(구매단위)
					if(record.get('ORDER_UNIT_Q') != '') {
						if(newValue <= '0' && record.get('ORDER_UNIT_Q') > '0') {
							rv= '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						} else if(newValue >= '0' && record.get('ORDER_UNIT_Q') < '0') {
							rv= '<t:message code="system.message.purchase.message034" default="음수만 입력가능합니다."/>';
							break;
						}
					}
					record.set('INOUT_I',newValue);
					if(record.get('INOUT_Q') != '0') {
						record.set('INOUT_P',(record.get('INOUT_I') / record.get('INOUT_Q')));
						record.set('ORDER_UNIT_P',(newValue / record.get('ORDER_UNIT_Q')));				//20200604 수정: record.get('ORDER_UNIT_I') -> newValue
					} else {
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_P','0');
					}
					if(record.get('EXCHG_RATE_O') != '0') {
						record.set('INOUT_FOR_P',(record.get('INOUT_P') / record.get('EXCHG_RATE_O')));
						record.set('ORDER_UNIT_FOR_P',(record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O')));
						record.set('ORDER_UNIT_FOR_O',(newValue / record.get('EXCHG_RATE_O')));			//20200604 수정: record.get('ORDER_UNIT_I') -> newValue
						record.set('INOUT_FOR_O',record.get('ORDER_UNIT_FOR_O'));
					} else {
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}
					directMasterStore1.fnSumAmountI();
				break;

				case "ORDER_UNIT_FOR_P" : // 외화단가(구매단위)
					if((record.get('ACCOUNT_YNC')== 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')){
							if(newValue <= 0){
								rv='<t:message code="system.message.purchase.message032" default="기표대상여부가 기표일때 단가는 0보다 커야 합니다."/>';
								break;
							}
						}else{
							if(newValue < 0){
								rv='<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
								break;
							}
						}
						record.set('ORDER_UNIT_FOR_O', record.get('ORDER_UNIT_Q') * newValue);
						record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
						if(record.get('INOUT_Q') != 0){
							record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
						}
						directMasterStore1.fnSumAmountI();
						if(record.get('EXCHG_RATE_O') != 0){
							record.set('INOUT_P'		, (record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
							record.set('ORDER_UNIT_P'	, (newValue * record.get('EXCHG_RATE_O')));	//자사단가 = 입력한 구매단가 * 환율
							record.set('ORDER_UNIT_I'	, fnWonCalc(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));	//자사금액 = 입고량 * 자사단가, 20200713 추가: 자사금액 소숫점 처리로직 추가

							record.set('INOUT_FOR_P'	, (newValue / record.get('TRNS_RATE')));
							record.set('INOUT_P'		, (newValue / record.get('TRNS_RATE') * record.get('EXCHG_RATE_O')));
							record.set('INOUT_I'		, fnWonCalc(record.get('ORDER_UNIT_P') * record.get('ORDER_UNIT_Q'))); // 자사단가(ORDER_UNIT_P), 20200713 추가: 자사금액 소숫점 처리로직 추가
						}else{
							record.set('INOUT_I'		, '0');
							record.set('INOUT_P'		, '0');
							record.set('ORDER_UNIT_I'	, '0');
							record.set('ORDER_UNIT_P'	, '0');
						}
					/*if(record.get('ACCOUNT_YNC') == 'Y' && record.get('INOUT_TYPE_DETAIL') != '91') {
						if(newValue <= '0') {
							rv= Msg.sMM375;
							break;
						}
					} else if(newValue < '0') {
						rv= Msg.sMM376;
							break;
					}
					record.set('INOUT_FOR_P',(newValue / record.get('TRNS_RATE')));
					record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_Q') * newValue));
					record.set('INOUT_FOR_O',record.get('ORDER_UNIT_FOR_O'));
					if(record.get('EXCHG_RATE_O') != '0') {
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));
						record.set('ORDER_UNIT_P',(record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O')));
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));
						record.set('INOUT_I',record.get('ORDER_UNIT_I'));
					} else {
						record.set('INOUT_I',0);
						record.set('INOUT_P',0);
						record.set('ORDER_UNIT_I',0);
						record.set('ORDER_UNIT_P',0);
					}
					directMasterStore1.fnSumAmountI();*/
				break;

				case "ORDER_UNIT_FOR_O"	: 	// 외화금액(구매단위)
					if(record.get('ORDER_UNIT_Q') != '') {
						if(newValue <= '0' && record.get('ORDER_UNIT_Q') > '0') {
							rv= '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						} else if(newValue >= '0' && record.get("ORDER_UNIT_Q") < '0') {
							rv= '<t:message code="system.message.purchase.message034" default="음수만 입력가능합니다."/>';
							break;
						}
					}
					record.set('INOUT_FOR_O', newValue)
					if(record.get('INOUT_Q') != '0') {
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));
						record.set('ORDER_UNIT_FOR_P',(newValue / record.get('ORDER_UNIT_Q')));		//20200604 수정: record.get('ORDER_UNIT_FOR_O') -> newValue
					} else {
						record.set('INOUT_FOR_P',0);
						record.set('ORDER_UNIT_FOR_P',0);
					}
					if(record.get('EXCHG_RATE_O') != '0') {
						record.set('INOUT_P'		, (record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));
						record.set('ORDER_UNIT_P'	, (record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O')));
						record.set('ORDER_UNIT_I'	, fnWonCalc(newValue * record.get('EXCHG_RATE_O')));			//20200604 수정: record.get('ORDER_UNIT_FOR_O') -> newValue, 20200713 추가: 자사금액 소숫점 처리로직 추가
						record.set('INOUT_I'		, record.get('ORDER_UNIT_I'));
					} else {
						record.set('INOUT_I'		, 0);
						record.set('INOUT_P'		, 0);
						record.set('ORDER_UNIT_I'	, 0);
						record.set('ORDER_UNIT_P'	, 0);
					}
					directMasterStore1.fnSumAmountI();
				break;
				case "ORDER_TYPE"	:
					if(record.get('ORDER_TYPE') == '4') {
						rv= '<t:message code="system.message.purchase.message035" default="선택할 수 없는 코드입니다."/>';
						break;
					}
				break;
				case "WH_CODE" :
					if(!Ext.isEmpty(newValue)){
						record.set('WH_CELL_CODE'	, "");
						record.set('WH_CELL_NAME'	, "");
						record.set('LOT_NO'			, "");
					}else{
						record.set('WH_CODE'		, "");
						record.set('WH_CELL_CODE'	, "");
						record.set('WH_CELL_NAME'	, "");
						record.set('LOT_NO'			, "");
					}
					//그리드 창고cell콤보 reLoad..
//					cbStore.loadStoreRecords(newValue);
				break;

				case "ORDER_UNIT":
					UniAppManager.app.selectOrderPrice("U", record);
				break;

				case "PACK_UNIT_Q":
					if(BsaCodeInfo.gsBoxYN == 'Y'){
						var sInout_q = 0;
						var noInoutQ = record.get('NOINOUT_Q') / record.get('TRNS_RATE');//미납량 구매단위로 변경
						if(record.obj.phantom){
							if(!Ext.isEmpty(record.get('INOUT_NUM'))){
								if(newValue * record.get('BOX_Q') + record.get('EACH_Q') > noInoutQ){			//입고수량 > 미납량
									sInout_q = noInoutQ;	//출고수량 = 미납량(참조에서 가져온 미납량)
									record.set('LOSS_Q',newValue * record.get('BOX_Q') + record.get('EACH_Q') - noInoutQ);//LOSS여분 = 입고수량 - 미납량
								} else {
									sInout_q = newValue * record.get('BOX_Q') + record.get('EACH_Q');	//입고량
									record.set('LOSS_Q',0);
								}
							} else {
								sInout_q = newValue * record.get('BOX_Q') + record.get('EACH_Q');	//입고량
								record.set('LOSS_Q',0);
							}
						} else {
							if(!Ext.isEmpty(record.get('INOUT_NUM'))){
								if(newValue * record.get('BOX_Q') + record.get('EACH_Q') > record.get('ORIGINAL_Q') + noInoutQ ){			//입고수량 > 미납량
									sInout_q = record.get('ORIGINAL_Q') + noInoutQ;	//입고수량 = 미납량
									record.set('LOSS_Q', newValue * record.get('BOX_Q') + record.get('EACH_Q') - (record.get('ORIGINAL_Q') + noInoutQ));//LOSS여분 = 입고수량 - 미납량

								} else {
									sInout_q = newValue * record.get('BOX_Q') + record.get('EACH_Q');	//입고량
									record.set('LOSS_Q',0);
								}
							}
						}
						record.set('ORDER_UNIT_Q', sInout_q);
						record.set('INOUT_Q', sInout_q * record.get('TRNS_RATE'));

						if(record.get('ORDER_UNIT_P') != '') {
							record.set('ORDER_UNIT_I', fnWonCalc(record.get('ORDER_UNIT_P') * record.get('ORDER_UNIT_Q')));	//20200713 추가: 자사금액 소숫점 처리로직 추가
						} else {
							record.set('ORDER_UNIT_I','0');
						}
						if (record.get('ORDER_UNIT_FOR_P') != '') {
							record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_FOR_P') * record.get('ORDER_UNIT_Q')));
						} else {
							record.set('ORDER_UNIT_FOR_O','0');
						}
						record.set('INOUT_I',record.get('ORDER_UNIT_I'));
						record.set('INOUT_FOR_O',record.get('ORDER_UNIT_FOR_O'));

						directMasterStore1.fnSumAmountI();
					}
				break;

				case "BOX_Q":
					if(BsaCodeInfo.gsBoxYN == 'Y'){
							var sInout_q = 0;
							var noInoutQ = record.get('NOINOUT_Q') / record.get('TRNS_RATE');//미납량 구매단위로 변경
							if(record.obj.phantom){
								if(!Ext.isEmpty(record.get('INOUT_NUM'))){
									if(record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') > noInoutQ){			//입고수량 > 미납량
										sInout_q = noInoutQ;	//출고수량 = 미납량(참조에서 가져온 미납량)
										record.set('LOSS_Q',record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') - noInoutQ);//LOSS여분 = 입고수량 - 미납량
									} else {
										sInout_q = record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q');	//입고량
										record.set('LOSS_Q',0);
									}
								} else {
									sInout_q = record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q');	//입고량
									record.set('LOSS_Q',0);
								}
							} else {
								if(!Ext.isEmpty(record.get('INOUT_NUM'))){
									if(record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') > record.get('ORIGINAL_Q') + noInoutQ){			//입고수량 > 미납량
										sInout_q = record.get('ORIGINAL_Q') + noInoutQ;	//입고수량 = 미납량
										record.set('LOSS_Q', record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') - (record.get('ORIGINAL_Q') + noInoutQ));//LOSS여분 = 입고수량 - 미납량

									} else {
										sInout_q = record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q');	//입고량
										record.set('LOSS_Q',0);
									}
								}
							}
							record.set('ORDER_UNIT_Q', sInout_q);
							record.set('INOUT_Q', sInout_q * record.get('TRNS_RATE'));

							if(record.get('ORDER_UNIT_P') != '') {
								record.set('ORDER_UNIT_I', fnWonCalc(record.get('ORDER_UNIT_P') * record.get('ORDER_UNIT_Q')));	//20200713 추가: 자사금액 소숫점 처리로직 추가
							} else {
								record.set('ORDER_UNIT_I','0');
							}
							if (record.get('ORDER_UNIT_FOR_P') != '') {
								record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_FOR_P') * record.get('ORDER_UNIT_Q')));
							} else {
								record.set('ORDER_UNIT_FOR_O','0');
							}
							record.set('INOUT_I',record.get('ORDER_UNIT_I'));
							record.set('INOUT_FOR_O',record.get('ORDER_UNIT_FOR_O'));
							directMasterStore1.fnSumAmountI();
					}
				break;

				case "EACH_Q":
					if(BsaCodeInfo.gsBoxYN == 'Y'){
						var sInout_q = 0;
						var noInoutQ = record.get('NOINOUT_Q') / record.get('TRNS_RATE');//미납량 구매단위로 변경
						if(record.obj.phantom){
							if(!Ext.isEmpty(record.get('INOUT_NUM'))){
								if(record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue > noInoutQ ){			//입고수량 > 미납량
									sInout_q = noInoutQ;	//출고수량 = 미납량(참조에서 가져온 미납량)
									record.set('LOSS_Q', record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue - noInoutQ);//LOSS여분 = 입고수량 - 미납량
								} else {
									sInout_q = record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue;	//입고량
									record.set('LOSS_Q',0);
								}
							} else {
								sInout_q = record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue;	//입고량
								record.set('LOSS_Q',0);
							}
						} else {
							if(!Ext.isEmpty(record.get('INOUT_NUM'))){
								if(record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue > record.get('ORIGINAL_Q') + noInoutQ ){			//입고수량 > 미납량
									sInout_q = record.get('ORIGINAL_Q') + noInoutQ;	//입고수량 = 미납량
									record.set('LOSS_Q', record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue - (record.get('ORIGINAL_Q') + noInoutQ));//LOSS여분 = 입고수량 - 미납량

								} else {
									sInout_q = record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue;	//입고량
									record.set('LOSS_Q',0);
								}
							}
						}
						record.set('ORDER_UNIT_Q', sInout_q);
						record.set('INOUT_Q', sInout_q * record.get('TRNS_RATE'));

						if(record.get('ORDER_UNIT_P') != '') {
							record.set('ORDER_UNIT_I', fnWonCalc(record.get('ORDER_UNIT_P') * record.get('ORDER_UNIT_Q')));	//20200713 추가: 자사금액 소숫점 처리로직 추가
						} else {
							record.set('ORDER_UNIT_I','0');
						}
						if (record.get('ORDER_UNIT_FOR_P') != '') {
							record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_FOR_P') * record.get('ORDER_UNIT_Q')));
						} else {
							record.set('ORDER_UNIT_FOR_O','0');
						}
						record.set('INOUT_I',record.get('ORDER_UNIT_I'));
						record.set('INOUT_FOR_O',record.get('ORDER_UNIT_FOR_O'));
						directMasterStore1.fnSumAmountI();
					}
				break;

				case "LOSS_Q":
				break;
			}
			return rv;
		}
	});

	/**
	 * 设置所有属性不可编辑
	 */
	function setAllFieldsReadOnly(b){
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
				}else{
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					});
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField')	;
						if(popupFC.holdable == 'hold') {
							popupFC.setReadOnly(false);
						}
					}
				});
				this.unmask();
			}
			return r;
	}

	function getPjtNoPopupEditor(){
		var editField = Unilite.popup('PROJECT_G',{
			DBtextFieldName: 'PROJECT_NO',
			textFieldName:'PROJECT_NO',
			autoPopup: true,
			listeners: {
				'applyextparam': function(popup){
					var selectRec = masterGrid.getSelectedRecord();
					if(selectRec){
						popup.setExtParam({'BPARAM0': 3});
						popup.setExtParam({'CUSTOM_CODE': selectRec.get("CUSTOM_CODE")});
						popup.setExtParam({'CUSTOM_NAME': selectRec.get("CUSTOM_NAME")});
					}
				},
				'onSelected': {
					fn: function(record, type) {
						var selectRec = masterGrid.getSelectedRecord()
						if(selectRec){
							selectRec.set('PROJECT_NO', record[0]["PJT_CODE"]);
						}
					},
					scope: this
				},
				'onClear': function(type){
					scope: this
				}
			}
		})

		var editor = Ext.create('Ext.grid.CellEditor', {
			ptype: 'cellediting',
			clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
			autoCancel : false,
			selectOnFocus:true,
			field: editField
		});

		return editor;
	}

	function getLotPopupEditor(gsLotNoInputMethod){
		var editField;
		if(gsLotNoInputMethod == "E" || gsLotNoInputMethod == "Y"){
			 editField = Unilite.popup('LOTNO_G',{
				textFieldName: 'LOTNO_CODE',
				DBtextFieldName: 'LOTNO_CODE',
				width:1000,
				autoPopup: true,
				listeners: {
					'onSelected': {
						fn: function(record, type) {
							var selectRec = masterGrid.getSelectedRecord()
							if(selectRec){
								debugger;
								selectRec.set('LOT_NO', record[0]["LOT_NO"]);
								selectRec.set('GOOD_STOCK_Q', record[0]["GOOD_STOCK_Q"]);
								selectRec.set('BAD_STOCK_Q', record[0]["BAD_STOCK_Q"]);
							}
						},
						scope: this
					},
					'onClear': {
						fn: function(record, type) {
							var selectRec = masterGrid.getSelectedRecord()
							if(selectRec){
								selectRec.set('LOT_NO', '');
								selectRec.set('GOOD_STOCK_Q', 0);
								selectRec.set('BAD_STOCK_Q', 0);
							}
						},
						scope: this
					},
					applyextparam: function(popup){
						var selectRec = masterGrid.getSelectedRecord();
						if(selectRec){
							popup.setExtParam({'DIV_CODE':  selectRec.get('DIV_CODE')});
							popup.setExtParam({'ITEM_CODE': selectRec.get('ITEM_CODE')});
							popup.setExtParam({'ITEM_NAME': selectRec.get('ITEM_NAME')});
							popup.setExtParam({'CUSTOM_CODE': searchForm.getValue('CUSTOM_CODE')});
							popup.setExtParam({'CUSTOM_NAME': searchForm.getValue('CUSTOM_NAME')});
							popup.setExtParam({'WH_CODE': selectRec.get('WH_CODE')});
							popup.setExtParam({'WH_CELL_CODE': selectRec.get('WH_CELL_CODE')});
							popup.setExtParam({'stockYN': 'Y'});
						}
					}
				}
			});
		}else if(gsLotNoInputMethod == "N"){
			editField = {xtype : 'textfield', maxLength:20}
		}

		var editor = Ext.create('Ext.grid.CellEditor', {
			ptype: 'cellediting',
			clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
			autoCancel : false,
			selectOnFocus:true,
			field: editField
		});
		return editor;
	}



	//20200603 화폐에 따라 컬럼 포맷설정하는 부분 함수로 뺀 후, 여러곳에서 호출하도록 수정
	function fnSetColumnFormat() {
		var length = 0
		var format = ''
		if(searchForm.getValue('MONEY_UNIT') != BsaCodeInfo.gsDefaultMoney){
			length = Ext.isEmpty(UniFormat.FC.split('.')[1]) ? 0 : UniFormat.FC.split('.')[1].length;
			format = UniFormat.FC;
		} else {
			length = Ext.isEmpty(UniFormat.Price.split('.')[1]) ? 0 : UniFormat.Price.split('.')[1].length;
			format = UniFormat.Price;
		}
		panelResult.getField('SumInoutO').setConfig('decimalPrecision',length);
		panelResult.getField('SumInoutO').focus();
		panelResult.getField('SumInoutO').blur();

		masterGrid.getColumn("INOUT_FOR_O").setConfig('format'	,format);
		masterGrid.getColumn("ORDER_UNIT_FOR_O").setConfig('format'	,format);

		masterGrid.getColumn("INOUT_FOR_O").setConfig('decimalPrecision',length);
		masterGrid.getColumn("ORDER_UNIT_FOR_O").setConfig('decimalPrecision',length);

		if(!Ext.isEmpty(masterGrid.getColumn("INOUT_FOR_O").config.editor) && !Ext.isEmpty(masterGrid.getColumn("INOUT_FOR_O").config.editor.decimalPrecision)) {
			masterGrid.getColumn("INOUT_FOR_O").config.editor.decimalPrecision = length;
		}
		if(!Ext.isEmpty(masterGrid.getColumn("INOUT_FOR_O").editor)) {
			masterGrid.getColumn("INOUT_FOR_O").editor.decimalPrecision = length;
		}
		if(!Ext.isEmpty(masterGrid.getColumn("ORDER_UNIT_FOR_O").config.editor) && !Ext.isEmpty(masterGrid.getColumn("ORDER_UNIT_FOR_O").config.editor.decimalPrecision)) {
			masterGrid.getColumn("ORDER_UNIT_FOR_O").config.editor.decimalPrecision = length;
		}
		if(!Ext.isEmpty(masterGrid.getColumn("ORDER_UNIT_FOR_O").editor)) {
			masterGrid.getColumn("ORDER_UNIT_FOR_O").editor.decimalPrecision = length;
		}

		if(isLoad){
			isLoad = false;
		} else {
			UniAppManager.app.fnExchngRateO();
		}
	}

	//20200713 추가: 자사금액 소숫점 처리로직 추가
	function fnWonCalc(amt) {
		var calAmt = UniSales.fnAmtWonCalc(amt, CustomCodeInfo.gsUnderCalBase);
		return calAmt;
	}
};
</script>