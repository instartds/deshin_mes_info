<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms512ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="mms512ukrv"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>						<!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>						<!-- 화폐 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>			<!--창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList"/>	<!--창고Cell-->
	<t:ExtComboStore comboType="AU" comboCode="M001"/>						<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201"/>						<!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M505" opts= '2;6'/>			<!-- 생성경로 (폼) -->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '2;6'/>			<!-- 생성경로 (그리드) -->
	<t:ExtComboStore comboType="AU" comboCode="M103"/>						<!-- 입고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B021"/>						<!-- 품목상태 -->
	<t:ExtComboStore comboType="AU" comboCode="M301"/>						<!-- 단가형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B020"/>						<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="S014"/>						<!-- 기표대상 -->
	<t:ExtComboStore comboType="AU" comboCode="YP08"/>						<!-- 조건 -->
	<t:ExtComboStore comboType="AU" comboCode="YP09"/>						<!-- 형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>						<!-- 과세구분 -->
	<t:ExtComboStore comboType="OU" />										<!-- 창고-->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

var windowFlag = '';			// 검사결과, 무검사 참조 구분 플래그
var SearchInfoWindow;			//조회버튼 누르면 나오는 조회창
var referNoReceiveWindow;		//미입고참조
var referReturnPossibleWindow;	//반품가능발주참조
var referInspectResultWindow;	//검사결과참조 (무검사겸용)
var gsSelRecord
var labelPrintWindow;			//라벨출력
var labelPrintHiddenYn	= true;
var gsOriValue
//var referScmRefWindow; //업체출고 참조(SCM)
var BsaCodeInfo = {
	gsDefaultData		: '${gsDefaultData}',
	gsInTypeAccountYN	: '${gsInTypeAccountYN}',
	gsExcessRate		: '${gsExcessRate}',
	gsInvstatus			: '${gsInvstatus}',
	gsProcessFlag		: '${gsProcessFlag}',
	gsInspecFlag		: '${gsInspecFlag}',
	gsMap100UkrLink		: '${gsMap100UkrLink}',
	gsSumTypeLot		: '${gsSumTypeLot}',
	gsSumTypeCell		: '${gsSumTypeCell}',
	gsDefaultMoney		: '${gsDefaultMoney}',
	gsAutoType			: '${gsAutoType}',
	gsInOutPrsn			: '${gsInOutPrsn}',
	gsOScmYn			: '${gsOScmYn}',
	gsDbName			: '${gsDbName}',
	gsEssItemAccount	: '${gsEssItemAccount}',
	gsGwYn				: '${gsGwYn}',
	gsQ008Sub			: '${gsQ008Sub}',	//가입고사용여부 관련
	gsInoutType			: '${gsInoutType}',
	gsSiteCode		  : '${gsSiteCode}',
	gsExchangeRate	  : '${gsExchangeRate}',
	gsCalculate   : '${gsCalculate}'
};
var CustomCodeInfo = {
	gsUnderCalBase: ''
};
var gsInoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_M103').getAt(0).get('value');
var outDivCode = UserInfo.divCode;

var gsGwYn = true; //그룹웨어 사용여부
if(BsaCodeInfo.gsGwYn == 'Y') {
	gsGwYn = false;
}
if(BsaCodeInfo.gsSiteCode == 'SHIN'){
	labelPrintHiddenYn = false;
}
//var output ='';
//  for(var key in BsaCodeInfo){
//	  output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//  }
//  alert(output);


var aa = 0;
function appMain() {
	//창고에 따른 창고cell 콤보load..
	var cbStore = Unilite.createStore('hat510ukrsComboStoreGrid',{
		autoLoad: false,
		uniOpt	: {
			isMaster: false		 // 상위 버튼 연결
		},
		fields: [
			{name: 'SUB_CODE'	, type : 'string'},
			{name: 'CODE_NAME'	, type : 'string'}
		],
		proxy: {
			type: 'direct',
			api	: {
				read: 'salesCommonService.fnRecordCombo'
			}
		},
		loadStoreRecords: function(whCode) {
			var param		= panelSearch.getValues();
			param.COMP_CODE	= UserInfo.compCode;
//			param.DIV_CODE	= UserInfo.divCode;
			param.WH_CODE	= whCode;
			param.TYPE		= 'BSA225T';
			console.log( param );
			this.load({
				params: param
			});
		}
	});

//	var sumtypeLot = BsaCodeInfo.gsSumTypeLot == "Y"?true:false;
	var sumtypeLot = true;	//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeLot =='Y') {
		sumtypeLot = false;
	}
	var sumtypeCell = true;	//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeCell =='Y') {
		sumtypeCell = false;
	}
	var isAutoInoutNum = BsaCodeInfo.gsAutoType=='Y'?true:false;

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'mms512ukrvService.selectList',
			update	: 'mms512ukrvService.updateDetail',
			create	: 'mms512ukrvService.insertDetail',
			destroy	: 'mms512ukrvService.deleteDetail',
			syncAll	: 'mms512ukrvService.saveAll'
		}
	});

	Unilite.defineModel('Mms512ukrvModel1', {
		fields: [
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string',allowBlank: isAutoInoutNum},
			{name: 'INOUT_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'						, type: 'int', allowBlank: false},
			{name: 'INOUT_METH'			, text: '<t:message code="system.label.purchase.method" default="방법"/>'						, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.purchase.receipttype" default="반품유형"/>'				, type: 'string',comboType:'AU',comboCode:'M103', allowBlank: false},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				, type: 'string',comboType: 'AU',comboCode: 'B020'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'						, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				, type: 'string',comboType:'AU',comboCode:'B013', displayField: 'value'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.receiptqty" default="반품수량"/>'				, type: 'uniQty', allowBlank: true},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string',comboType:'AU',comboCode:'B013', displayField: 'value'},
			{name: 'INOUT_Q'			, text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>'		, type: 'uniQty'},
			{name: 'ORIGINAL_Q'			, text: '<t:message code="system.label.purchase.existinginqty" default="기존입고량"/>'			, type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'		, text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'				, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'		, text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'			, type: 'uniQty'},
			{name: 'NOINOUT_Q'			, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'				, type: 'uniQty'},
			{name: 'PRICE_YN'			, text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'				, type: 'string',comboType:'AU',comboCode:'M301'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'					, type: 'string',comboType:'AU',comboCode:'B004', allowBlank: false, displayField: 'value',editable: false},//20200908 수정: 그리드 화폐는 수정 불가
			{name: 'INOUT_FOR_P'		, text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>'		, type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O'		, text: '<t:message code="system.label.purchase.inventoryunitamount" default="재고단위금액"/>'	, type: 'uniPrice'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				, type: 'uniER'},
			{name: 'INOUT_P'			, text: '<t:message code="system.label.purchase.copricestock" default="자사단가(재고)"/>'			, type: 'uniUnitPrice', allowBlank: true, editable: false},
			{name: 'INOUT_I'			, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'				, type: 'uniPrice'	, editable: false},//기존 자사금액(재고), 20200908 수정: 공급가액은 수정 불가
			{name: 'TRANS_COST'			, text: '<t:message code="system.label.purchase.shippingcharge" default="운반비"/>'			, type: 'uniPrice'},
			{name: 'TARIFF_AMT'			, text: '<t:message code="system.label.purchase.Customs" default="관세"/>'					, type: 'uniPrice'},
			{name: 'ACCOUNT_YNC'		, text: '<t:message code="system.label.purchase.sliptarget" default="기표대상"/>'				, type: 'string', comboType:'AU',comboCode:'S014', allowBlank: false},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string',comboType:'AU',comboCode:'M001', allowBlank: false},
			{name: 'LC_NUM'				, text: 'LC/NO(*)'		, type: 'string'},
			{name: 'BL_NUM'				, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'					, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'						, type: 'int'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'						, type: 'uniQty'},
			{name: 'INOUT_CODE_TYPE'	, text: '<t:message code="system.label.purchase.receiptplacetype" default="입고처구분"/>'		, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'			, type: 'string', comboType:'OU', allowBlank: false, child: 'WH_CELL_CODE'},
			{name: 'WH_CELL_CODE'		, text:'<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/> Cell'		, type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','SALE_DIV_CODE']},
			{name: 'ITEM_STATUS'		, text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>'				, type: 'string',comboType:'AU',comboCode:'B021', allowBlank: false},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate', allowBlank: false},
			{name: 'INOUT_PRSN'			, text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'			, type: 'string'},
			{name: 'ACCOUNT_Q'			, text: '<t:message code="system.label.purchase.billqty" default="계산서량"/>'					, type: 'uniQty'},
			{name: 'CREATE_LOC'			, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'				, type: 'string',comboType:'AU',comboCode:'B031'},
			{name: 'SALE_C_DATE'		, text: '<t:message code="system.label.purchase.billclosingdate" default="계산서마감일"/>'		, type: 'uniDate'},
			{name: 'MAKE_LOT_NO'		, text: '거래처LOT'		, type: 'string'},
			{name: 'MAKE_DATE'			, text: '제조일자'			, type: 'uniDate'},
			{name: 'MAKE_EXP_DATE'		, text: '유통기한'			, type: 'uniDate'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'LOT_NO'				, text: 'LOT NO'		, type: 'string'},
			{name: 'LOT_YN'				, text: '<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'			, type: 'string', comboType:'AU', comboCode:'A020'},
			{name: 'INOUT_TYPE'			, text: '<t:message code="system.label.purchase.type" default="타입"/>'						, type: 'string'},
			{name: 'INOUT_CODE'			, text: '<t:message code="system.label.purchase.receiptplace" default="입고처"/>'				, type: 'string', allowBlank: false},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'					, type: 'string', child: 'WH_CODE'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type: 'string'},
			{name: 'COMPANY_NUM'		, text: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				, type: 'string'},
			{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.purchase.poreceiptqty" default="발주입고수량"/>'			, type: 'uniQty'},
			{name: 'INSPEC_NUM'			, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'					, type: 'string'},
			{name: 'INSPEC_SEQ'			, text: '<t:message code="system.label.purchase.inspecseq" default="검사순번"/>'				, type: 'int'},
			{name: 'SALE_DIV_CODE'		, text: '<t:message code="system.label.purchase.salesdivision" default="매출사업장"/>'			, type: 'string'},
			{name: 'SALE_CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.salesplace" default="매출처"/>'				, type: 'string'},
			{name: 'BILL_TYPE'			, text: '<t:message code="system.label.purchase.salestype" default="매출유형"/>'				, type: 'string'},
			{name: 'SALE_TYPE'			, text: '<t:message code="system.label.purchase.salesclass" default="매출구분"/>'				, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>'				, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '<t:message code="system.label.purchase.updatedate" default="수정일"/>'				, type: 'string'},
			{name: 'EXCESS_RATE'		, text: '<t:message code="system.label.purchase.overreceiptrate" default="과입고허용율"/>'		, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'				, type: 'uniQty'},
			{name: 'ORDER_UNIT_FOR_P'	, text: '<t:message code="system.label.purchase.receiptprice" default="입고단가"/>'				, type: 'uniUnitPrice', allowBlank: true},
			{name: 'ORDER_UNIT_FOR_O'	, text: '<t:message code="system.label.purchase.receiptamount" default="입고금액"/>'			, type: 'uniFC'/* , allowBlank: false */},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'					, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_I'		, text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'					, type: 'uniPrice'},			///////////////////////////////////////////////////////	INOUT_I
			{name: 'BASIS_NUM'			, text: 'BASIS_NUM'		, type: 'string'},
			{name: 'BASIS_SEQ'			, text: 'BASIS_SEQ'		, type: 'int'},
			{name: 'SCM_FLAG_YN'		, text: 'SCM_FLAG_YN'	, type: 'string'},
			{name: 'TRADE_LOC'			, text: '<t:message code="system.label.purchase.tradelocation" default="무역경로"/>'			, type: 'string',comboType:'AU',comboCode:'T104'},
			{name: 'STOCK_CARE_YN'		, text: '<t:message code="system.label.purchase.inventorymanagementyn" default="재고관리여부"/>'	, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				, type: 'string'},
			{name: 'INSERT_DB_USER'		, text: 'INSERT_DB_USER', type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: 'INSERT_DB_TIME', type: 'string'},
			{name: 'SALES_TYPE'			, text: 'SALES_TYPE'	, type: 'int'},
			{name: 'FLAG'				, text: 'FLAG'			, type: 'string'},
			{name: 'RECEIPT_NUM'		, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'				, type: 'string'},
			{name: 'RECEIPT_SEQ'		, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'				, type: 'int'},
			{name: 'SOF_ORDER_NUM'		, text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'						, type: 'string'},
			{name: 'SOF_ORDER_SEQ'		, text: '<t:message code="system.label.purchase.soseq" default="수주순번"/>'					, type: 'int'},
			{name: 'SOF_CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.soplace" default="수주처"/>'					, type: 'string'},
			{name: 'SOF_ITEM_NAME'		, text: '<t:message code="system.label.purchase.soitemname" default="수주품목명"/>'				, type: 'string'},
			//20200409 추가: 조회 시 BL합계금액 계산을 위해 추가
			{name: 'TEMP_SEQ'			, text: 'TEMP_SEQ'		, type: 'string'}
//			{name: 'PURCHASE_TYPE'		, text: 'PURCHASE_TYPE'	, type: 'int'},
//			{name: 'PURCHASE_RATE'		, text: 'PURCHASE_RATE'	, type: 'int'}
		]
	});//Unilite.defineModel('Mms512ukrvModel1', {

	Unilite.defineModel('inoutNoMasterModel', {			//조회버튼 누르면 나오는 조회창
		fields: [
			{name: 'INOUT_NAME'			, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'			, type: 'uniDate'},
			{name: 'INOUT_CODE'			, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'			, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'		, type: 'string', comboType	: 'OU'},
			{name: 'WH_CELL_CODE'		, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>Cell'	, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'				, type: 'string',comboType:'BOR120'},
			{name: 'INOUT_PRSN'			, text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'		, type: 'string',comboType:'AU', comboCode:'B024'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'			, type: 'string'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			, type: 'uniER'},
			{name: 'CREATE_LOC'			, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'			, type: 'string',comboType:'AU',comboCode:'B031'},
			{name: 'PERSON_NAME'		, text: '<t:message code="system.label.purchase.employeename" default="사원명"/>'			, type: 'string'},
			{name: 'BL_NO'				, text: 'BL_NO'		, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.purchase.receipttype" default="반품유형"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'}
		]
	});

	Unilite.defineModel('mms512ukrvRECEIVEModel', {		//미입고참조
		fields: [
			{name: 'GUBUN'				, text: '<t:message code="system.label.purchase.selection" default="선택"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			, type: 'string'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'					, type: 'uniQty'},
			{name: 'REMAIN_Q'			, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'			, type: 'uniQty'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'NOINOUT_Q'			, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'			, type: 'uniQty'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>'	, type: 'uniQty'},
			{name: 'UNIT_PRICE_TYPE'	, text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'			, type: 'string',comboType:'AU', comboCode:'M301'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			, type: 'uniER'},
			{name: 'ORDER_P'			, text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>'	, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'					, type: 'uniUnitPrice'},
			{name: 'ORDER_O'			, text: '<t:message code="system.label.purchase.amount" default="금액"/>'					, type: 'uniFC'},		//20200622 수정: uniPrice -> uniFC
			{name: 'ORDER_LOC_P'		, text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'				, type: 'uniUnitPrice'},
			{name: 'ORDER_LOC_O'		, text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'				, type: 'uniPrice'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'string'},
			{name: 'INSPEC_NUM'			, text: '<t:message code="system.label.purchase.receiptinspecno" default="접수/검사번호"/>'	, type: 'string'},
			{name: 'INSPEC_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'string'},
			{name: 'LC_NUM'				, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'				, type: 'string'},
			{name: 'ORDER_REQ_NUM'		, text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'	, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'				, type: 'string', allowBlank: false},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.conversioncoeff" default="변환계수"/>'		, type: 'uniQty'},
			{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.purchase.poreceiptqty" default="발주입고수량"/>'		, type: 'uniQty'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'EXCESS_RATE'		, text: '<t:message code="system.label.purchase.overreceiptrate" default="과입고허용율"/>'	, type: 'uniPercent'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'		, type: 'string',comboType:'AU', comboCode:'M201'},		//20200729 수정: B024 -> M201
			{name: 'GOOD_STOCK_Q'		, text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>'			, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'		, text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'		, type: 'uniQty'},
			{name: 'LC_NO'				, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'BL_NO'				, text: '<t:message code="system.label.purchase.blserno" default="B/L관리번호"/>'			, type: 'string'},
			{name: 'BASIS_NUM'			, text: '<t:message code="system.label.purchase.basisnum" default="기준번호"/>'				, type: 'string'},
			{name: 'BASIS_SEQ'			, text: '<t:message code="system.label.purchase.basisseq2" default="기준순번"/>'			, type: 'string'},
			{name: 'LC_DATE'			, text: '<t:message code="system.label.purchase.lcdate" default="LC일"/>'				, type: 'uniDate'},
			{name: 'INVOICE_DATE'		, text: '<t:message code="system.label.purchase.invoicedate" default="통관일자"/>'			, type: 'uniDate'},
			{name: 'TRADE_LOC'			, text: '<t:message code="system.label.purchase.tradelocation" default="무역경로"/>'		, type: 'string'},
			{name: 'LOT_NO'				, text: 'LOT NO'		, type: 'string'},
			{name: 'LOT_YN'				, text: 'LOT_YN'		, type: 'string'},
			{name: 'SOF_ORDER_NUM'		, text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'			, type: 'string'},
			{name: 'SOF_ORDER_SEQ'		, text: '<t:message code="system.label.purchase.soseq" default="수주순번"/>'		, type: 'int'},
			{name: 'SOF_CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.soplace" default="수주처"/>'		, type: 'string'},
			{name: 'SOF_ITEM_NAME'		, text: '<t:message code="system.label.purchase.soitemname" default="수주품목명"/>'	, type: 'string'},
			{name: 'BL_NUM'				, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'		, type: 'string'},
			{name: 'WON_CALC_BAS'		, text: 'WON_CALC_BAS'	, type: 'string'}
		]
	});

	Unilite.defineModel('mms512ukrvRETURNModel', {		//반품가능발주참조
		fields: [
			{name: 'GUBUN'				, text: '<t:message code="system.label.purchase.selection" default="선택"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			, type: 'string'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'					, type: 'uniQty'},
			{name: 'REMAIN_Q'			, text: '<t:message code="system.label.purchase.returnavaiableqty" default="반품가능량"/>'	, type: 'uniQty'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'NOINOUT_Q'			, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'			, type: 'uniQty'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>'	, type: 'uniQty'},
			{name: 'UNIT_PRICE_TYPE'	, text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'			, type: 'string',comboType:'AU', comboCode:'M301'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			, type: 'uniER'},
			{name: 'ORDER_P'			, text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>'	, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'					, type: 'uniUnitPrice'},
			{name: 'ORDER_O'			, text: '<t:message code="system.label.purchase.amount" default="금액"/>'					, type: 'uniPrice'},
			{name: 'ORDER_LOC_P'		, text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'				, type: 'uniPrice'},
			{name: 'ORDER_LOC_O'		, text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'				, type: 'uniPrice'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'string'},
			{name: 'LC_NUM'				, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'				, type: 'string', comboType:'OU'},
			{name: 'ORDER_REQ_NUM'		, text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'	, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'				, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.conversioncoeff" default="변환계수"/>'		, type: 'uniQty'},
			{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.purchase.poreceiptqty" default="발주입고수량"/>'		, type: 'uniQty'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'EXCESS_RATE'		, text: '<t:message code="system.label.purchase.overreceiptrate" default="과입고허용율"/>'	, type: 'string'},
			{name: 'LC_NO'				, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'BL_NO'				, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'				, type: 'string'},
			{name: 'BASIS_NUM'			, text: '<t:message code="system.label.purchase.basisnum" default="기준번호"/>'				, type: 'string'},
			{name: 'BASIS_SEQ'			, text: '<t:message code="system.label.purchase.basisseq2" default="기준순번"/>'			, type: 'string'},
			{name: 'LC_DATE'			, text: '<t:message code="system.label.purchase.lcdate" default="LC일"/>'				, type: 'uniDate'},
			{name: 'INVOICE_DATE'		, text: '<t:message code="system.label.purchase.invoicedate" default="통관일자"/>'			, type: 'uniDate'},
			{name: 'TRADE_LOC'			, text: '<t:message code="system.label.purchase.tradelocation" default="무역경로"/>'		, type: 'string'}
		]
	});

	Unilite.defineModel('mms512ukrvSCMREFModel1', {		//SCM참조
		fields: [
			{name: 'GUBUN'				, text: '<t:message code="system.label.purchase.selection" default="선택"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>'				, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.issueno" default="출고번호"/>'					, type: 'string'},
			{name: 'INOUT_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'						, type: 'int'},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.purchase.issuedate" default="출고일"/>'					, type: 'string'},
			{name: 'CUSTOM_ITEM_CODE'	, text: '<t:message code="system.label.purchase.customitemcode" default="업체품목코드"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.coitemcode" default="자사품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.coitemname" default="자사품명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.cospec" default="자사규격"/>'					, type: 'string'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'				, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				, type: 'uniER'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'				, type: 'int'},
			{name: 'INOUT_Q'			, text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'					, type: 'uniQty'},
			{name: 'INOUT_P'			, text: '<t:message code="system.label.purchase.issueprice" default="출고단가"/>'				, type: 'uniUnitPrice'},
			{name: 'INOUT_I'			, text: '<t:message code="system.label.purchase.issueamount" default="출고금액"/>'				, type: 'uniPrice'},
			{name: 'INOUT_PRSN'			, text: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>'				, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'						, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				, type: 'string'},
			{name: 'STOCK_CARE_YN'		, text: '<t:message code="system.label.purchase.inventorymanagementyn" default="재고관리여부"/>'	, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'					, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string'},
			{name: 'INOUT_FOR_P'		, text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>'		, type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O'		, text: '<t:message code="system.label.purchase.inventoryunitamount" default="재고단위금액"/>'	, type: 'uniPrice'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string'}
		]
	});

	Unilite.defineModel('mms512ukrvINSPECTModel2', {	//검사결과참조
		fields: [
			{name: 'GUBUN'				, text: '<t:message code="system.label.purchase.selection" default="선택"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'INSPEC_DATE'		, text: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>'			, type: 'uniDate'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			, type: 'string'},
			{name: 'ORDER_O'			, text: '<t:message code="system.label.purchase.amount" default="금액"/>'					, type: 'uniFC'},		//20200622 수정: uniPrice -> uniFC
			{name: 'NOINOUT_Q'			, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'			, type: 'uniQty'},
			{name: 'ITEM_STATUS'		, text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>'			, type: 'string',comboType:'AU', comboCode:'B021'},
			{name: 'UNIT_PRICE_TYPE'	, text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'			, type: 'string',comboType:'AU', comboCode:'M301'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				, type: 'string'},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'					, type: 'uniUnitPrice'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			, type: 'uniER'},
			{name: 'ORDER_LOC_P'		, text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'				, type: 'uniUnitPrice'},
			{name: 'ORDER_LOC_O'		, text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'				, type: 'uniPrice'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'				, type: 'int'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'RECEIPT_Q'			, text: '접수량'				    , type: 'uniQty'},
			{name: 'NOR_RECEIPT_Q'		, text: '(정상)접수량'				, type: 'uniQty'},
			{name: 'FREE_RECEIPT_Q'		, text: '(무상)접수량'				, type: 'uniQty'},
			{name: 'REMAIN_Q'			, text: '<t:message code="system.label.purchase.inspecqty" default="검사량"/>'				, type: 'uniQty'},
			{name: 'INSPEC_NUM'			, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'				, type: 'string'},
			{name: 'INSPEC_SEQ'			, text: '<t:message code="system.label.purchase.inspecseq" default="검사순번"/>'			, type: 'int'},
			{name: 'RECEIPT_NUM'		, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'			, type: 'string'},
			{name: 'RECEIPT_SEQ'		, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'			, type: 'int'},
			{name: 'PORE_Q'				, text: '<t:message code="system.label.purchase.pobalance" default="발주잔량"/>'			, type: 'uniQty'},
			{name: 'MAKE_LOT_NO'		, text: '거래처LOT'			, type: 'string'},
			{name: 'MAKE_DATE'			, text: '제조일자'				, type: 'uniDate'},
			{name: 'MAKE_EXP_DATE'		, text: '유통기한'				, type: 'uniDate'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'LOT_NO'				, text: 'LOT NO'			, type: 'string'},
			{name: 'LOT_YN'				, text: 'LOT_YN'			, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'LC_NO'				, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'BL_NO'				, text: '<t:message code="system.label.purchase.blserno" default="B/L관리번호"/>'			, type: 'string'},
			{name: 'BASIS_NUM'			, text: '<t:message code="system.label.purchase.basisnum" default="기준번호"/>'				, type: 'string'},
			{name: 'BASIS_SEQ'			, text: '<t:message code="system.label.purchase.basisseq2" default="기준순번"/>'			, type: 'int'},
			{name: 'LC_DATE'			, text: '<t:message code="system.label.purchase.lcdate" default="LC일"/>'				, type: 'uniDate'},
			{name: 'INVOICE_DATE'		, text: '<t:message code="system.label.purchase.invoicedate" default="통관일자"/>'			, type: 'uniDate'},
			{name: 'TRADE_LOC'			, text: '<t:message code="system.label.purchase.tradelocation" default="무역경로"/>'		, type: 'string',comboType:'AU',comboCode:'T104'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			, type: 'string'},
			{name: 'LC_NUM'				, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'				, type: 'string', comboType:'OU'},
			{name: 'ORDER_REQ_NUM'		, text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'	, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>'				, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'				, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.conversioncoeff" default="변환계수"/>'		, type: 'uniQty'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>'	, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'					, type: 'uniQty'},
			{name: 'ORDER_P'			, text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>'	, type: 'uniUnitPrice'},
			{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.purchase.poreceiptqty" default="발주입고수량"/>'		, type: 'uniQty'},
			{name: 'EXCESS_RATE'		, text: '<t:message code="system.label.purchase.overreceiptrate" default="과입고허용율"/>'	, type: 'string'},
			{name: 'MONEY_UNIT_CUST'	, text: 'MONEY_UNIT_CUST'	, type: 'string'},
			{name: 'TRADE_LOC'			, text: 'TRADE_LOC'			, type: 'string'},
			{name: 'CREATE_LOC'			, text: 'CREATE_LOC'		, type: 'string'},
			{name: 'SOF_ORDER_NUM'		, text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'					, type: 'string'},
			{name: 'SOF_ORDER_SEQ'		, text: '<t:message code="system.label.purchase.soseq" default="수주순번"/>'				, type: 'int'},
			{name: 'SOF_CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.soplace" default="수주처"/>'				, type: 'string'},
			{name: 'SOF_ITEM_NAME'		, text: '<t:message code="system.label.purchase.soitemname" default="수주품목명"/>'			, type: 'string'},
			{name: 'BL_NUM'				, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'				, type: 'string'},
			{name: 'WON_CALC_BAS'		, text: 'WON_CALC_BAS'		, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.purchase.receipttype" default="반품유형"/>'				, type: 'string',comboType:'AU',comboCode:'M103'}
		]
	});

	var directMasterStore1 = Unilite.createStore('mms512ukrvMasterStore1', {
		model: 'Mms512ukrvModel1',
		uniOpt: {
			isMaster	 : true,			// 상위 버튼 연결
			editable	 : true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			allDeletable : true,
			useNavi	  : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
				var toUpdate = this.getUpdatedRecords();
				var toDelete = this.getRemovedRecords();
				var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var isErr = false;
			Ext.each(list, function(record, index) {

// sp 에서 체크하여 비어 있으면 자동채번함 2019.2.26 수정
//				 if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
//					 alert((index + 1) + '<t:message code="system.message.purchase.message026" default="행의 입력값을 확인 해주세요."/>' + 'LOT NO:' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
//					 isErr = true;
//					 return false;
//				 }
				if(record.get('INOUT_TYPE_DETAIL') != '91'){//금액 보정이 아닐 경우
					var msg = '';
					if(record.get('ORDER_UNIT_Q') == 0){
						msg += '\n<t:message code="system.label.purchase.receiptqty1" default="입고수량"/> ' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>';
					}
					if(record.get('INOUT_Q') == 0){
						msg += '\n<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>';
					}
					if(msg != ''){
						alert((index + 1) + '<t:message code="system.message.purchase.message026" default="행의 입력값을 확인 해주세요."/>' + msg);
						isErr = true;
						return false;
					}
				}
				if(record.get('INOUT_TYPE_DETAIL') != '91'  //금액 보정이 아닐 경우
					&& record.get('ACCOUNT_YNC') == 'Y'		//기표대상일 경우
					&& record.get('PRICE_YN')	== 'Y' ){	//진단가일 경우
					//20190613 기존 20'(무상입고)에 '40'(사급입고) 추가
					if(record.get('INOUT_TYPE_DETAIL') != '20' && record.get('INOUT_TYPE_DETAIL') != '40'){
						var msg = '';
						if(record.get('ORDER_UNIT_FOR_P') == 0){
							msg += '<t:message code="system.label.purchase.receiptprice" default="입고단가"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>';
						}
						if(record.get('ORDER_UNIT_FOR_O') == 0){
							msg += '<t:message code="system.label.purchase.receiptamount" default="입고금액"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>';
						}
						if(record.get('ORDER_UNIT_P') == 0){
							msg += '<t:message code="system.label.purchase.coprice" default="자사단가"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>';
						}
						if(msg != ''){
							alert((index + 1) + '<t:message code="system.message.purchase.message026" default="행의 입력값을 확인 해주세요."/>' + msg);
							isErr = true;
							return false;
						}
					 }
				}
			});

			if(isErr) {
				return false;
			}
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelSearch.setValue("INOUT_NUM", master.INOUT_NUM);
						panelResult2.setValue("INOUT_NUM", master.INOUT_NUM);
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);

						if (directMasterStore1.count() == 0) {
							UniAppManager.app.onResetButtonDown();
						}else{
							directMasterStore1.loadStoreRecords();
						}
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('mms512ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
				load: function(store, records, successful, eOpts) {
					//20200409 추가: 조회시에도 b/l 합계금액 표시 위해
					if(records.length > 0) {
						this.fnSumBlAmountI(records[0]);
					}
//					this.fnSumAmountI();
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
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		fnSumBlAmountI: function(record) {
			var blAmtWon = this.sumBy(function(record, id){
							return record.get('TEMP_SEQ') == '1';},
							['BL_AMT_WON']);
			panelResult.setValue('BlSumInoutO', blAmtWon.BL_AMT_WON);
			this.fnSumAmountI();
		},
		fnSumAmountI:function(){
			var dAmountI	= Ext.isNumeric(this.sum('INOUT_FOR_O'))	? this.sum('INOUT_FOR_O')	: 0;	// 재고단위금액
			var dIssueAmtWon= Ext.isNumeric(this.sum('ORDER_UNIT_I'))	? this.sum('ORDER_UNIT_I')	: 0;	//20200409 수정: INOUT_I(자사금액(재고)) -> ORDER_UNIT_I(자사금액)로 변경

			panelResult.setValue('SumInoutO'	, dAmountI);
			panelResult.setValue('IssueAmtWon'	, dIssueAmtWon);

			//20200409 추가: bl금액합계와 합계금액이 다를경우 bl금액합계 금액 다른색으로 표시
			if(!panelResult.getField('BlSumInoutO').hidden) {
				if(panelResult.getValue('BlSumInoutO') != panelResult.getValue('IssueAmtWon')) {
					panelResult.getField('IssueAmtWon').setFieldStyle('color:red');
				} else {
					panelResult.getField('IssueAmtWon').setFieldStyle('color:black');
				}
			}
		}
	});

	var inoutNoMasterStore = Unilite.createStore('inoutNoMasterStore', {	//조회버튼 누르면 나오는 조회창
		model: 'inoutNoMasterModel',
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
				read: 'mms512ukrvService.selectinoutNoMasterList'
			}
		}
		,loadStoreRecords : function() {
			var param= inoutNoSearch.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(inoutNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var noReceiveStore = Unilite.createStore('mms512ukrvNoReceiveStore', {//미입고참조
			model: 'mms512ukrvRECEIVEModel',
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
					read : 'mms512ukrvService.selectnoReceiveList'
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
												&& (record.data['ORDER_SEQ'] == item.data['ORDER_SEQ']))
											{
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
				var param= noreceiveSearch.getValues();
				this.load({params : param});
			},
			groupField:'ORDER_NUM'
	});

	var returnPossibleStore = Unilite.createStore('mms512ukrvReturnPossibleStore', {//반품가능발주참조
			model: 'mms512ukrvRETURNModel',
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
					read : 'mms512ukrvService.selectreturnPossibleList'
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
											&& (record.data['ORDER_SEQ'] == item.data['ORDER_SEQ']))
										{
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
				var param= returnpossibleSearch.getValues();
				//20200417 추가: div_code 안 넘어감
				param.DIV_CODE = panelSearch.getValue('DIV_CODE');
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField:'ORDER_NUM'
	});

	var scmRefStore = Unilite.createStore('mms512ukrvScmRefStore', {//업체SCM참조
			model: 'mms512ukrvSCMREFModel1',
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
					read : 'mms512ukrvService.selectScmRefList'
				}
			},
			listeners:{
				load:function(store, records, successful, eOpts) {
					if(successful) {
						var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
						var scmRefRecords = new Array();
						if(masterRecords.items.length > 0) {
								Ext.each(records, function(item, i) {
									Ext.each(masterRecords.items, function(record, i) {
										if((record.data['INOUT_NUM'] == item.data['INOUT_NUM'])
											&& (record.data['INOUT_SEQ'] == item.data['INOUT_SEQ']))
										{
											scmRefRecords.push(item);
										}
									});
								});
							store.remove(scmRefRecords);
						}
					}
				}
			},
			loadStoreRecords : function() {
				var param= scmRefSearch.getValues();
				param["DIV_CODE"] = panelSearch.getValue("DIV_CODE")
				param["CUSTOM_CODE"] = panelSearch.getValue("CUSTOM_CODE")
				this.load({
					params : param
				});
			},
			groupField:'INOUT_NUM'
	});

	var inspectResultStore2 = Unilite.createStore('mms512ukrvInspectResultStore', {//검사결과참조(무검사참조겸용)
		model: 'mms512ukrvINSPECTModel2',
		autoLoad: false,
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 'mms512ukrvService.selectinspectResultList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					var inspectRecords = new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM']) && (record.data['RECEIPT_SEQ'] == item.data['INSPEC_SEQ'] && (record.data['RECEIPT_NUM']) == item.data['INSPEC_NUM'])
								  )
								{
									inspectRecords.push(item);
								}
							});
						});
						store.remove(inspectRecords);
					}
				}
			}
		},
		loadStoreRecords : function() {
			var param= inspectresultSearch.getValues();
			param.WINDOW_FLAG = windowFlag;
			param["oScmYn"] = BsaCodeInfo.gsOScmYn;
			param["sDbName"] = BsaCodeInfo.gsDbName;
			param["DIV_CODE"] = panelSearch.getValue("DIV_CODE")
			param["CUSTOM_CODE"] = panelSearch.getValue("CUSTOM_CODE")
			param["ORDER_PRSN"] = panelSearch.getValue("INOUT_PRSN")
			param["MONEY_UNIT"] = panelSearch.getValue("MONEY_UNIT")
			param["EXCHG_RATE_O"] = panelSearch.getValue("EXCHG_RATE_O")
			this.load({
				params : param
			});
		},groupField:'INSPEC_NUM'
	});

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
			collapse: function () {
				panelResult2.show();
			},
			expand: function() {
				panelResult2.hide();
			}
		},
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
						var field = panelResult2.getField('INOUT_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult2.setValue('DIV_CODE', newValue);
						var field2 = panelResult2.getField('WH_CODE');
						field2.getStore().clearFilter(true);


						panelSearch.setValue('WH_CODE', '');
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				allowBlank: true,
				autoPopup:true,
				holdable: 'hold',
				extParam: {'CUSTOM_TYPE': ['1','2']},
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
							panelSearch.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
							panelSearch.setValue('EXCHG_RATE_O', '1');
							panelResult2.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
							panelResult2.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
							panelResult2.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
							panelResult2.setValue('EXCHG_RATE_O', '1');
							if(records[0]["MONEY_UNIT"] != BsaCodeInfo.gsDefaultMoney){
								//20191126 콤보에서 라디오로 변경
								panelSearch.getField('CREATE_LOC').setValue('6');
								panelResult2.getField('CREATE_LOC').setValue('6');
//								panelSearch.setValue('CREATE_LOC', '6');
//								panelResult2.setValue('CREATE_LOC', '6');
							}else{
								//20191126 콤보에서 라디오로 변경
								panelSearch.getField('CREATE_LOC').setValue('2');
								panelResult2.getField('CREATE_LOC').setValue('2');
//								panelSearch.setValue('CREATE_LOC', '2');
//								panelResult2.setValue('CREATE_LOC', '2');
							}
							UniAppManager.app.fnExchngRateO();
						},
						scope: this
					},
					onClear: function(type) {
						panelResult2.setValue('CUSTOM_CODE', '');
						panelResult2.setValue('CUSTOM_NAME', '');
					}
				}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="반품일자"/>',
				name: 'INOUT_DATE',
				xtype: 'uniDatefield',
					value: UniDate.get('today'),
				allowBlank: false,
				//holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('INOUT_DATE', newValue);
						Ext.each(directMasterStore1.data.items, function(record, index){
						record.set('INOUT_DATE', newValue);
						});
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="반품창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType	: 'OU',
				allowBlank: false,
				child: 'WH_CELL_CODE',
				holdable: 'hold',
				listConfig:{minWidth:230},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('WH_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						var prStore = panelResult2.getField('WH_CODE').store;
						store.clearFilter();
						prStore.clearFilter();
						if(!Ext.isEmpty(panelResult2.getValue('DIV_CODE'))){
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
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="반품창고"/>Cell',
				name: 'WH_CELL_CODE',
				xtype:'uniCombobox',
				store: Ext.data.StoreManager.lookup('whCellList'),
				holdable: 'hold',
				//20191127 추가
				allowBlank: sumtypeCell,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult2.setValue('WH_CELL_CODE', newValue);
					}
				}
			}/*,{
				fieldLabel: '입고창고 Cell',
				holdable:'hold',
				name: 'WH_CELL_CODE',
				hidden:!sumtypeCell,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('WH_CELL_CODE', newValue);
					}
				}
			}*/,{
				fieldLabel: '<t:message code="system.label.purchase.receiptcharge" default="반품담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				//holdable: 'hold',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('INOUT_PRSN', newValue);
						Ext.each(directMasterStore1.data.items, function(record, index){
						record.set('INOUT_PRSN', newValue);
						});
					}
				}
//			},{	//20191126 콤보에서 라디오로 변경
//				fieldLabel: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
//				name: 'CREATE_LOC',
//				xtype: 'uniCombobox',
//				comboType:'AU',
//				comboCode:'B031',
//				allowBlank: false,
//				holdable: 'hold',
//				listeners: {
//					change: function(field, newValue, oldValue, eOpts) {
//						panelResult2.setValue('CREATE_LOC', newValue);
//					}
//				}
			}]
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
			name		: 'CREATE_LOC',
			holdable	: 'hold',
			items		: [{
				boxLabel	: '내수',
				name		: 'CREATE_LOC',
				inputValue	: '2'
			},{
				boxLabel	: '수입',
				name		: 'CREATE_LOC',
				inputValue	: '6'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult2.getField('CREATE_LOC').setValue(newValue.CREATE_LOC);
				}
			}
		},{
			title:'<t:message code="system.label.purchase.inputinfo" default="입력정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.receiptno" default="반품번호"/>',
				xtype: 'uniTextfield',
				name:'INOUT_NUM',
				readOnly: isAutoInoutNum,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('INOUT_NUM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
				name: 'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B004',
				allowBlank: true,
				displayField: 'value',
				holdable: 'hold',
				fieldStyle: 'text-align: center;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('MONEY_UNIT', newValue);
//						UniAppManager.app.fnExchngRateO();
					},
					blur: function( field, The, eOpts ) {
						UniAppManager.app.fnExchngRateO();
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.exchangerate" default="환율"/>',
				name:'EXCHG_RATE_O',
				xtype: 'uniNumberfield',
				allowBlank: true,
				holdable: 'hold',
				decimalPrecision: 4,
				value: 1,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('EXCHG_RATE_O', newValue);
					}
				}
			},{
				fieldLabel:'ITEM_CODE',
				name:'ITEM_CODE',
				xtype: 'uniTextfield',
				hidden: true
			},{
				fieldLabel:'ORDER_UNIT',
				name:'ORDER_UNIT',
				xtype: 'uniTextfield',
				hidden: true
			}]
		}],
		setAllFieldsReadOnly: setAllFieldsReadOnly

	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult2 = Unilite.createSearchForm('resultForm2',{
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
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

						panelResult.setValue('WH_CODE','');
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				allowBlank: true,
				holdable: 'hold',
				autoPopup:true,
				extParam: {'CUSTOM_TYPE': ['1','2']},
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
							panelSearch.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
							panelSearch.setValue('EXCHG_RATE_O', '1');
							panelSearch.setValue('CUSTOM_CODE', panelResult2.getValue('CUSTOM_CODE'));
							panelSearch.setValue('CUSTOM_NAME', panelResult2.getValue('CUSTOM_NAME'));
							panelResult2.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
							panelResult2.setValue('EXCHG_RATE_O', '1');
							if(records[0]["MONEY_UNIT"] != BsaCodeInfo.gsDefaultMoney){
								//20191126 콤보에서 라디오로 변경
								panelSearch.getField('CREATE_LOC').setValue('6');
								panelResult2.getField('CREATE_LOC').setValue('6');
//								panelSearch.setValue('CREATE_LOC', '6');
//								panelResult2.setValue('CREATE_LOC', '6');
							}else{
								//20191126 콤보에서 라디오로 변경
								panelSearch.getField('CREATE_LOC').setValue('2');
								panelResult2.getField('CREATE_LOC').setValue('2');
//								panelSearch.setValue('CREATE_LOC', '2');
//								panelResult2.setValue('CREATE_LOC', '2');
							}
							UniAppManager.app.fnExchngRateO();
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelSearch.setValue('CUSTOM_NAME', '');
					}
				}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="반품창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType	: 'OU',
				allowBlank: false,
				holdable: 'hold',
				child: 'WH_CELL_CODE',
				listConfig:{minWidth:230},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WH_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						var psStore = panelSearch.getField('WH_CODE').store;
						store.clearFilter();
						psStore.clearFilter();
						if(!Ext.isEmpty(panelResult2.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == panelResult2.getValue('DIV_CODE');
							});
							psStore.filterBy(function(record){
								return record.get('option') == panelResult2.getValue('DIV_CODE');
							});
						}else{
							store.filterBy(function(record){
								return false;
							});
							psStore.filterBy(function(record){
								return false;
							});
						}
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="반품창고"/>Cell',
				name: 'WH_CELL_CODE',
				xtype:'uniCombobox',
				store: Ext.data.StoreManager.lookup('whCellList'),
				holdable: 'hold',
				//20191127 추가
				allowBlank: sumtypeCell,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('WH_CELL_CODE', newValue);
					}
				}
			}/*,{
				fieldLabel: '입고창고 Cell',
				holdable:'hold',
				name: 'WH_CELL_CODE',
				hidden:!sumtypeCell,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WH_CELL_CODE', newValue);
					}
				}
			}*/,
			{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="반품일자"/>',
				name: 'INOUT_DATE',
				xtype: 'uniDatefield',
					value: UniDate.get('today'),
				allowBlank: false,
				//holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('INOUT_DATE', newValue);
						Ext.each(directMasterStore1.data.items, function(record, index){
						record.set('INOUT_DATE', newValue);
						});

					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptcharge" default="반품담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				//holdable: 'hold',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('INOUT_PRSN', newValue);
						Ext.each(directMasterStore1.data.items, function(record, index){
						record.set('INOUT_PRSN', newValue);
						});
					}
				}
			},{	//20191126 콤보에서 라디오로 변경
//				fieldLabel: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
//				name: 'CREATE_LOC',
//				xtype: 'uniCombobox',
//				comboType:'AU',
//				comboCode:'B031',
//				allowBlank: false,
//				holdable: 'hold',
//				listeners: {
//					change: function(field, newValue, oldValue, eOpts) {
//						panelSearch.setValue('CREATE_LOC', newValue);
//					}
//				}
//			},{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
				name		: 'CREATE_LOC',
				holdable	: 'hold',
				items		: [{
					boxLabel	: '내수',
					name		: 'CREATE_LOC',
					inputValue	: '2',
					width		: 60
				},{
					boxLabel	: '수입',
					name		: 'CREATE_LOC',
					inputValue	: '6',
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('CREATE_LOC').setValue(newValue.CREATE_LOC);
						if(newValue.CREATE_LOC == '6') {
							panelResult.getField('BlSumInoutO').setHidden(false);
						} else {
							panelResult.getField('BlSumInoutO').setHidden(true);
						}
					}
				}
			},{
				xtype: 'component',
				colspan: 4/*,
				tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' }*/
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>',
				xtype: 'uniTextfield',
				name:'INOUT_NUM',
				readOnly: isAutoInoutNum
			},{
				fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
				name: 'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B004',
				allowBlank: true,
				displayField: 'value',
				holdable: 'hold',
				fieldStyle: 'text-align: center;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('MONEY_UNIT', newValue);
//						UniAppManager.app.fnExchngRateO();
					},
					blur: function( field, The, eOpts ) {
						UniAppManager.app.fnExchngRateO();
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.exchangerate" default="환율"/>',
				name:'EXCHG_RATE_O',
				xtype: 'uniNumberfield',
				allowBlank: true,
				holdable: 'hold',
				decimalPrecision: 4,
				colspan: 2,
				value: 1,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('EXCHG_RATE_O', newValue);
					}
				}
			}],
			setAllFieldsReadOnly: setAllFieldsReadOnly
	});

	var inoutNoSearch = Unilite.createSearchForm('inoutNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				child:'WH_CODE',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = inoutNoSearch.getField('INOUT_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						var field2 = inoutNoSearch.getField('WH_CODE');
						field2.getStore().clearFilter(true);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="반품창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType	: 'OU'
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'INOUT_CODE',
					textFieldName: 'INOUT_NAME',
					textFieldWidth : 170,
				validateBlank: false
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.receiptcharge" default="반품담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},
			{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="반품일자"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="반품창고"/>',
				name: 'WH_CELL_CODE',
				hidden:true
			},{
				fieldLabel: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
				name: 'CREATE_LOC',
				hidden:true
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel	 : '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				textFieldWidth : 170,
				//validateBlank  : false,
				autoPopup : true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{	//20200609 추가: 조회 시 입고번호로 조회할 수 있도록 수정
				fieldLabel: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>',
				name: 'INOUT_NUM'
			}]
	}); // createSearchForm

	var noreceiveSearch = Unilite.createSearchForm('noreceiveForm', {//미입고참조
		layout:  {type : 'uniTable', columns : 3},
		items: [
		{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			readOnly:true,
			child:'WH_CODE',
			value: UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = noreceiveSearch.getField('ORDER_PRSN');			//20200729 수정: INOUT_PRSN -> ORDER_PRSN
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					var field2 = noreceiveSearch.getField('WH_CODE');
					field2.getStore().clearFilter(true);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_ESTI_DATE',
			endFieldName: 'TO_ESTI_DATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315,
			allowBlank:false
		},
			Unilite.popup('AGENT_CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			readOnly: true
		}),{
			fieldLabel: '<t:message code="system.label.purchase.powarehouse" default="발주창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			comboType	: 'OU'
		},{
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name: 'ORDER_PRSN',					//20200729 수정: INOUT_PRSN -> ORDER_PRSN
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M201',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode4', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode4', newValue, divCode);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel	 : '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			textFieldWidth : 170,
			//validateBlank  : false,
			autoPopup : true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name: 'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M001'
			//value:'1'
		},{
			fieldLabel: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
			name: 'CREATE_LOC',
			hidden:true
		},{
			fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
			xtype: 'uniTextfield',
			name:'MONEY_UNIT',
			hidden:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				}
			}
		}]
	});

	var returnpossibleSearch = Unilite.createSearchForm('returnpossibleForm', {//반품가능발주참조
			layout :  {type : 'uniTable', columns : 3},
			items :[{
				fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank:false
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M001',
				value:'1'
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				readOnly: true
			}),
			Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					validateBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
							},
							scope: this
						},
						onClear: function(type) {
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
				name: 'CREATE_LOC',
				hidden:true
			}]
	});

/*	var scmRefSearch = Unilite.createSearchForm('scmRefForm', {//업체출고 참조(SCM)
			layout :  {type : 'uniTable', columns : 4},
			items :[{
				fieldLabel: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank:true
			},
			{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M001',
				value:'1'
			},{
				fieldLabel: '발주창고',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
			},{
				fieldLabel: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
				name: 'CREATE_LOC',
				hidden:true
			}]
	});*/

	var inspectresultSearch = Unilite.createSearchForm('inspectresultForm', {//검사결과참조
			layout :  {type : 'uniTable', columns : 4},
			items :[{
				fieldLabel: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
				xtype: 'uniDateRangefield',
				itemId:'dvryDate',
				startFieldName: 'FR_DVRY_DATE',
				endFieldName: 'TO_DVRY_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank:true
			},
			{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M001'
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptinspecno" default="접수/검사번호"/>',
				name: 'INSPEC_NUM',
				xtype: 'uniTextfield'
			},{
				fieldLabel: '<t:message code="system.label.purchase.powarehouse" default="발주창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType	: 'OU'
			},{
				fieldLabel: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
				name: 'CREATE_LOC',
				hidden:true
			}]
	});

	var panelResult = Unilite.createSearchForm('detailForm', { //createForm
		disabled: false,
		border:true,
		padding: '1',
		region: 'center',
		autoScroll: true,
		masterGrid: masterGrid,
		layout: {
			type: 'uniTable',
			columns : 3,
			tableAttrs: {align:'right'}
		},
		items: [{	//20200330 추가
			xtype		: 'container',
			defaultType	: 'uniTextfield',
			layout		: {type : 'vbox'},
			items		: [{
				fieldLabel: 'B/L <t:message code="system.label.purchase.amounttotal" default="금액합계"/>',
				name:'BlSumInoutO',
				xtype: 'uniNumberfield',
				readOnly: true
			}]
		},{
			fieldLabel: '<t:message code="system.label.purchase.amounttotal" default="금액합계"/>',
			name:'SumInoutO',
			xtype: 'uniNumberfield',
			type: 'uniFC',		//20200622 추가
			readOnly: true
		},{
			fieldLabel: '<t:message code="system.label.purchase.ownamounttotal" default="자사금액합계"/>',
			name:'IssueAmtWon',
			xtype: 'uniNumberfield',
			readOnly: true
		}]
	});		// end of var panelResult = Unilite.createSearchForm('resultForm',{

	var masterGrid = Unilite.createGrid('mms512ukrvGrid1', {
		layout: 'fit',
		region: 'center',
		excelTitle: '<t:message code="system.label.purchase.receiptentry" default="입고등록"/>',
		store: directMasterStore1,
		uniOpt: {
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		tbar: ['-',{
			itemId: 'inspectresultBtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.inspecresultrefer" default="검사결과참조"/></div>',
			handler: function() {
				windowFlag = 'inspectResult';
				if(referInspectResultWindow) {
					referInspectResultWindow.setConfig('title', '<t:message code="system.label.purchase.inspecresultrefer" default="검사결과참조"/>');
				}
				openInspectResultWindow();
			}
		},'-',{
			itemId: 'noreceiveBtn',
//			id:'noreceiveBtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.unreceiptreference" default="미입고참조"/></div>',
			handler: function() {
				openNoReceiveWindow();
			}
		},{
			itemId: 'inspectnoBtn',
//			id:'inspectnoBtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.noinspecreference" default="무검사참조"/></div>',
			handler: function() {
				windowFlag = 'inspectNo';
				if(referInspectResultWindow) {
					referInspectResultWindow.setConfig('title', '무검사참조');
				}
				openInspectResultWindow();
			}
		},'-',{
			itemId: 'returnpossibleBtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.returnavaiableporefer" default="반품가능발주참조"/></div>',
			handler: function() {
				openReturnPossibleWindow();
			}
		},'-',{
			xtype: 'button',
			text: '<div style="color: red"><t:message code="system.label.purchase.slipentry" default="지급결의 등록"/></div>',
//			margin:'0 0 0 100',
			handler: function() {
				if(directMasterStore1.count() == 0){
					return false;
				}
				var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
				if(needSave) {
					alert('<t:message code="system.message.common.savecheck" default="먼저 저장을 하십시오"/>');
					return false;
				}
				var params = {
					action			: 'select',
					'PGM_ID'		: 'mms512ukrv',
					'DIV_CODE'		: panelSearch.getValue('DIV_CODE'),
					'CUSTOM_CODE'	: panelSearch.getValue('CUSTOM_CODE'),
					'CUSTOM_NAME'	: panelSearch.getValue('CUSTOM_NAME'),
					'MONEY_UNIT'	: panelSearch.getValue('MONEY_UNIT'),
					'INOUT_DATE'	: UniDate.getDbDateStr(panelSearch.getValue('INOUT_DATE')),
					'WH_CODE'		: panelSearch.getValue('WH_CODE'),
					'INOUT_PRSN'	: panelSearch.getValue('INOUT_PRSN'),
					'CREATE_LOC'	: panelSearch.getValue('CREATE_LOC').CREATE_LOC,
					'INOUT_NUM'		: panelSearch.getValue('INOUT_NUM'),
					'ORDER_TYPE'	: directMasterStore1.data.items[0].get('ORDER_TYPE')
				}
				var rec1 = {data : {prgID : 'map100ukrv', 'text':'<t:message code="system.label.purchase.slipentry" default="지급결의 등록"/>'}};
				parent.openTab(rec1, '/matrl/map100ukrv.do', params);
			}
		}],
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns: [
			{dataIndex: 'INOUT_SEQ'			, width:57	, align:'center'},
			{dataIndex: 'INOUT_TYPE_DETAIL'	, width:100	, align:'center'},
			{dataIndex: 'WH_CODE'			, width:80,
				listeners:{
					render:function(elm){
						elm.editor.on('beforequery',function(queryPlan, eOpts)  {
							var store = queryPlan.combo.store;
							var selRecord =  masterGrid.uniOpt.currentRecord;
							store.clearFilter();
							if(!Ext.isEmpty(selRecord.get('DIV_CODE'))){
								store.filterBy(function(record){
									return record.get('option') == selRecord.get('DIV_CODE');
								});

							}else{
								store.filterBy(function(record){
									return false;
								});
							}
						})
					}
				}
			},
			{dataIndex: 'WH_CELL_CODE'		, width:100	,hidden:sumtypeCell,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filter('option', record.get('WH_CODE'));
					}
			},
			{dataIndex: 'ITEM_CODE'			, width:130 ,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						'onSelected': {
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
						},
						applyextparam: function(popup){
							popup.setExtParam({'SELMODEL': 'MULTI'});
							popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': Ext.getCmp("searchForm").getValue("DIV_CODE")});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 180,
					editor: Unilite.popup('DIV_PUMOK_G', {
						extParam: {SELMODEL: 'MULTI'},
						autoPopup: true,
						listeners: {
							'onSelected': {
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
							},
							applyextparam: function(popup){
								popup.setExtParam({'SELMODEL': 'MULTI'});
								popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
								popup.setExtParam({'DIV_CODE': Ext.getCmp("searchForm").getValue("DIV_CODE")});
							}
						}
					})
				},
			{dataIndex: 'SPEC'				, width:150 },
			{dataIndex: 'LOT_NO'			, width:120	,hidden: sumtypeLot,
				getEditor: function(record) {
					var inoutTypeValue = record.get('INOUT_TYPE_DETAIL');
					return getLotPopupEditor(sumtypeLot, inoutTypeValue);
				}
			},
			{dataIndex: 'ORDER_UNIT'		, width:80	,align: 'center'},
			{dataIndex: 'ORDER_UNIT_Q'		, width:100	,summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_FOR_P'	, width:100 },
			{dataIndex: 'ORDER_UNIT_FOR_O'	, width:100 ,summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_P'		, width:100 },
			{dataIndex: 'ORDER_UNIT_I'		, width:100 ,summaryType: 'sum'},
			//{dataIndex: 'LOT_NO'			, width:120 },
			{dataIndex: 'LOT_YN'			, width:120	, hidden: true },
			{dataIndex: 'TRNS_RATE'			, width:66	,maxLength:12},
			{dataIndex: 'STOCK_UNIT'		, width:88	,align: 'center'},
			{dataIndex: 'INOUT_Q'			, width:100	,summaryType: 'sum'},
			{dataIndex: 'SOF_ORDER_NUM'		, width:100	,hidden:true},
			{dataIndex: 'SOF_ORDER_SEQ'		, width:80	,hidden:true},
			{dataIndex: 'SOF_CUSTOM_NAME'	, width:100	,hidden:true},
			{dataIndex: 'SOF_ITEM_NAME'		, width:120	,hidden:true},
			{dataIndex: 'PRICE_YN'			, width:100	,hidden: false },
			{dataIndex: 'MONEY_UNIT'		, width:88	,align: 'center', hidden: true},
			{dataIndex: 'EXCHG_RATE_O'		, width:88	,hidden: true },
			{dataIndex: 'INOUT_P'			, width:115 },
			{dataIndex: 'INOUT_I'			, width:100 ,summaryType: 'sum' },
			{dataIndex: 'TRANS_COST'		, width:88  },
			{dataIndex: 'TARIFF_AMT'		, width:88  },
			{dataIndex: 'ACCOUNT_YNC'		, width:88  },
			{dataIndex: 'ORDER_TYPE'		, width:88  },
			{dataIndex: 'BL_NUM'			, width:88  ,maxLength:20},
			{dataIndex: 'ORDER_NUM'			, width:120 },
			{dataIndex: 'ORDER_SEQ'			, width:57  ,align: 'center'},
			{dataIndex: 'ITEM_STATUS'		, width:80  },
			{dataIndex: 'MAKE_LOT_NO'		, width: 100},
			{dataIndex: 'MAKE_DATE'			, width: 100},
			{dataIndex: 'MAKE_EXP_DATE'		, width: 100},
			{dataIndex: 'REMARK'			, width:188 ,maxLength:200},
			{dataIndex: 'PROJECT_NO'		, width:120 ,
				getEditor : function(record){
					return getPjtNoPopupEditor();
				}
			},
			{dataIndex: 'TRADE_LOC'			, width:88},
			{dataIndex: 'INOUT_NUM'			, width:110	,hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'	, width:80	,hidden: true},
			{dataIndex: 'LC_NUM'			, width:100	,hidden: true},
			{dataIndex: 'INOUT_PRSN'		, width:100	,hidden: true},
			{dataIndex: 'ACCOUNT_Q'			, width:80	,hidden: true},
			{dataIndex: 'CREATE_LOC'		, width:80	,hidden: true},
			{dataIndex: 'SALE_C_DATE'		, width:100	,hidden: true},
			{dataIndex: 'ITEM_ACCOUNT'		, width:100	,hidden: true},
			{dataIndex: 'INOUT_TYPE'		, width:100	,hidden: true},
			{dataIndex: 'INOUT_CODE'		, width:100	,hidden: true},
			{dataIndex: 'DIV_CODE'			, width:80	,hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width:80	,hidden: true},
			{dataIndex: 'INOUT_DATE'		, width:100	,hidden: true},
			{dataIndex: 'INOUT_METH'		, width:80	,hidden: true},
			{dataIndex: 'ORDER_Q'			, width:80	,hidden: true},
			{dataIndex: 'GOOD_STOCK_Q'		, width:100	,hidden: true},
			{dataIndex: 'BAD_STOCK_Q'		, width:100	,hidden: true},
			{dataIndex: 'ORIGINAL_Q'		, width:100	,hidden: true},
			{dataIndex: 'NOINOUT_Q'			, width:80	,hidden: true},
			{dataIndex: 'COMPANY_NUM'		, width:80	,hidden: true},
			{dataIndex: 'INOUT_FOR_P'		, width:80	,hidden: true},
			{dataIndex: 'INOUT_FOR_O'		, width:80	,hidden: true},
			{dataIndex: 'INSTOCK_Q'			, width:80	,hidden: true},
			{dataIndex: 'SALE_DIV_CODE'		, width:80	,hidden: true},
			{dataIndex: 'SALE_CUSTOM_CODE'	, width:80	,hidden: true},
			{dataIndex: 'BILL_TYPE'			, width:80	,hidden: true},
			{dataIndex: 'SALE_TYPE'			, width:80	,hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width:80	,hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width:80	,hidden: true},
			{dataIndex: 'EXCESS_RATE'		, width:80	,hidden: true},
			{dataIndex: 'BASIS_NUM'			, width:80	,hidden: true},
			{dataIndex: 'BASIS_SEQ'			, width:80	,hidden: true},
			{dataIndex: 'SCM_FLAG_YN'		, width:80	,hidden: true},
			{dataIndex: 'STOCK_CARE_YN'		, width:88	,hidden: true},
			{dataIndex: 'COMP_CODE'			, width:80	,hidden: true},
			{dataIndex: 'INSERT_DB_USER'	, width:80	,hidden: true},
			{dataIndex: 'INSERT_DB_TIME'	, width:80	,hidden: true},
			{dataIndex: 'FLAG'				, width:80	,hidden: true},
			{dataIndex: 'INSPEC_NUM'		, width:105	,hidden: false},
			{dataIndex: 'INSPEC_SEQ'		, width:80	,hidden: false},
			{dataIndex: 'RECEIPT_NUM'		, width:105	,hidden: false},
			{dataIndex: 'RECEIPT_SEQ'		, width:80	,hidden: false},
			{
				text	: '라벨',
				width	: 120,
				xtype	: 'widgetcolumn',
				hidden	: labelPrintHiddenYn,
				widget	: {
					xtype		: 'button',
					text		: '라벨 출력',
					listeners	: {
						buffer	: 1,
						click	: function(button, event, eOpts) {
							gsSelRecord = event.record.data;
							openLabelPrintWindow(gsSelRecord)
						}
					}
				}
			}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.data.ACCOUNT_Q != '0'){
					return false;
				}
				if(e.record.data.ORDER_NUM != ''){
					if(UniUtils.indexOf(e.field, ['BL_NUM'])){
						if(e.record.data.ORDER_TYPE != '3'){
							return true;
						}else{
							return false;
						}
					}
					if(UniUtils.indexOf(e.field, ['ACCOUNT_YNC','ORDER_UNIT_Q','INOUT_SEQ'
												 ,'WH_CELL_CODE','INOUT_I','INOUT_P','PRICE_YN','EXCHG_RATE_O','MONEY_UNIT','MAKE_LOT_NO','MAKE_DATE','MAKE_EXP_DATE'])){
						return true;
					}
					if(UniUtils.indexOf(e.field, ['ITEM_STATUS'])){
						if(BsaCodeInfo.gsProcessFlag == "PG"){
							return false;
						}else{
							return true;
						}
					}
					if(UniUtils.indexOf(e.field, ['LOT_NO','ORDER_UNIT_P','ORDER_UNIT_I','ORDER_UNIT_FOR_P'
												 ,'ORDER_UNIT_FOR_O','REMARK','PROJECT_NO','TRANS_COST','TARIFF_AMT'])){
						return true;
					}
				/*	  if(e.record.data.FLAG == 'FLAG') {
						if(UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL'])){
							return false;
						}
					} else {
						if(UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL'])){
							return true;
						}
					} */
					 if(UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL'])){
						 return true;
					 }
				}else{
					if(UniUtils.indexOf(e.field, ['BL_NUM'])){
						if(e.record.data.ORDER_TYPE != '3'){
							return true;
						}else{
							return false;
						}
					}
					if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','INOUT_METH','WH_CODE'
												 ,'WH_CELL_CODE','ORDER_TYPE','INOUT_SEQ'])){
						if(e.record.phantom == true){
							return true;
						}
						return false;
					}
					if(UniUtils.indexOf(e.field, ['INOUT_P','ORDER_UNIT_Q','INOUT_I','ACCOUNT_YNC'
												 ,'PRICE_YN','MONEY_UNIT','EXCHG_RATE_O','MAKE_LOT_NO','MAKE_DATE','MAKE_EXP_DATE'])){
						return true;
					}
					if(UniUtils.indexOf(e.field, ['ITEM_STATUS'])){
						if(BsaCodeInfo.gsProcessFlag == "PG"){
							return false;
						}else{
							return true;
						}
					}
					if(UniUtils.indexOf(e.field, ['LOT_NO','ORDER_UNIT_P','ORDER_UNIT_I','ORDER_UNIT_FOR_P'
												 ,'ORDER_UNIT_FOR_O','ORDER_UNIT','REMARK','PROJECT_NO','TRANS_COST','TARIFF_AMT'])){
						return true;
					}
					if(UniUtils.indexOf(e.field, ['TRNS_RATE'])){
						if(e.record.data.ORDER_UNIT != e.record.data.STOCK_UNIT){
							return true;
						}else{
							return false;
						}
					}
					/* if(e.record.data.FLAG == 'FLAG') {
						if(UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL'])){
							return false;
						}
					} else {
						if(UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL'])){
							return true;
						}
					} */
					 if(UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL'])){
						 return true;
					 }
				}
				return false;
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			var grdRecord = this.getSelectedRecord();
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, "");
				grdRecord.set('ITEM_NAME'		, "");
				grdRecord.set('SPEC'			, "");
				grdRecord.set('STOCK_UNIT'		, "");
				grdRecord.set('ORDER_UNIT'		, "");
				grdRecord.set('TRNS_RATE'		, 0);
				grdRecord.set('ITEM_ACCOUNT'	, "");
				grdRecord.set('STOCK_Q'			, "");
				grdRecord.set('GOOD_STOCK_Q'	, "");
				grdRecord.set('BAD_STOCK_Q'		, "");
				grdRecord.set('LOT_YN'			, '');
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('ORDER_UNIT'		, record['ORDER_UNIT']);
				grdRecord.set('TRNS_RATE'		, record['PUR_TRNS_RATE']);
				grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
				grdRecord.set('LOT_YN'			, record['LOT_YN']);
				grdRecord.set('INOUT_Q'			, grdRecord.get('ORDER_UNIT_Q') *  grdRecord.get('TRNS_RATE'));
				var param = {
					"ITEM_CODE"		: record['ITEM_CODE'],
					"CUSTOM_CODE"	: panelSearch.getValue('CUSTOM_CODE'),
					"DIV_CODE"		: panelSearch.getValue('DIV_CODE'),
					"MONEY_UNIT"	: panelSearch.getValue('MONEY_UNIT'),
					"ORDER_UNIT"	: record['ORDER_UNIT'],
					"INOUT_DATE"	: panelSearch.getValue('INOUT_DATE')
				};
				mms512ukrvService.fnOrderPrice(param, function(provider, response) {
					if(!Ext.isEmpty(provider)){
//						if(provider['PURCHASE_TYPE'] && provider['PURCHASE_TYPE'] != ''){
//							grdRecord.set('PURCHASE_RATE'	, provider['PURCHASE_RATE']);
//						}else{
//							grdRecord.set('PURCHASE_RATE'	, '0');
//						}
						if(provider['SALES_TYPE'] && provider['SALES_TYPE'] != ''){
							grdRecord.set('SALES_TYPE'	, provider['SALES_TYPE']);
						}else{
							grdRecord.set('SALES_TYPE'	, '0');
						}
						grdRecord.set('ORDER_UNIT_FOR_P', provider['ORDER_P']);
						grdRecord.set('ORDER_UNIT_P'	, (provider['ORDER_P'] * grdRecord.get('EXCHG_RATE_O')));
						grdRecord.set('INOUT_FOR_P'		, (provider['ORDER_P'] / grdRecord.get('TRNS_RATE')));
						grdRecord.set('INOUT_P'			, (provider['ORDER_P'] / grdRecord.get('TRNS_RATE') * grdRecord.get('EXCHG_RATE_O')));
					}
				})
				UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );
			}
		},
		setNoreceiveData:function(record){
			var grdRecord = this.getSelectedRecord();
			if(BsaCodeInfo.gsExchangeRate == '10'){
				panelSearch.setValue('EXCHG_RATE_O', record['EXCHG_RATE_O']);
				panelResult2.setValue('EXCHG_RATE_O', record['EXCHG_RATE_O']);
			}
			var moneyUnit = panelSearch.getValue('MONEY_UNIT');
			grdRecord.set('INOUT_TYPE'			,'1');
			grdRecord.set('INOUT_METH'			,'1');
			grdRecord.set('INOUT_NUM'			, panelSearch.getValue('INOUT_NUM'));
			grdRecord.set('INOUT_TYPE_DETAIL'	, gsInoutTypeDetail);//gsInoutTypeDetail ?확인필요
			grdRecord.set('INOUT_CODE_TYPE'		, '4');
			grdRecord.set('INOUT_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, panelSearch.getValue('CUSTOM_NAME'));
			grdRecord.set('INOUT_DATE'			, panelSearch.getValue('INOUT_DATE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ITEM_STATUS'			, '1');
			grdRecord.set('ACCOUNT_Q'			, '0');
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			if(record['TRNS_RATE'] == '0'){
				grdRecord.set('TRNS_RATE'		, '1');
			}else{
				grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			}
			var exchgRateO		= panelSearch.getValue('EXCHG_RATE_O');
			//20200608 추가: 조건 추가
			if(record.ORDER_UNIT_Q == record.REMAIN_Q) {
				//20200609 추가: orderUnitAmt도 별도로 계산하도록 수정
				var orderUnitAmt	= record['ORDER_O']; //외화금액
				var orderLocAmt		= record['ORDER_LOC_O']
					orderLocAmt		= UniMatrl.fnAmtWonCalc(orderLocAmt, record['WON_CALC_BAS'], 0);
			} else {
				//20200609 추가: orderUnitAmt도 별도로 계산하도록 수정
				var orderUnitAmt	= record['ORDER_UNIT_P'] * record['REMAIN_Q']; //외화금액
				var orderLocAmt		= record['ORDER_LOC_P'] * record['REMAIN_Q']; //자사금액 현재환율로 재계산, 20200608 수정: record['ORDER_UNIT_P'] * exchgRateO -> record['ORDER_LOC_P']
					orderLocAmt		= UniMatrl.fnAmtWonCalc(orderLocAmt, record['WON_CALC_BAS'], 0);
			}
			grdRecord.set('ORDER_UNIT_Q'		, record['REMAIN_Q']);		//구매단위수량
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['ORDER_UNIT_P']);	//외화단가
			grdRecord.set('ORDER_UNIT_FOR_O'	, orderUnitAmt);			//외화금액
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_LOC_P']);	//자사단가 현재환율로 재계산, 20200608 수정: record['ORDER_UNIT_P'] * exchgRateO -> record['ORDER_LOC_P']
			grdRecord.set('ORDER_UNIT_I'		, orderLocAmt);				//자사금액 (구매)
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);	//재고단위
			grdRecord.set('INOUT_Q'				, record['NOINOUT_Q']);		//입고수량(재고)
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);		//입수
			grdRecord.set('NOINOUT_Q'			, record['NOINOUT_Q']);		//미입고수량(재고)
			grdRecord.set('INOUT_I'				, orderLocAmt);				//자사금액 (재고)
			grdRecord.set('ACCOUNT_YNC'			, 'Y');
//			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('INOUT_P'				, record['ORDER_LOC_P']);	//단가(재고), 20200908 수정: isNaN(grdRecord.get('INOUT_I')/ grdRecord.get('INOUT_Q'))?0:grdRecord.get('INOUT_I')/ grdRecord.get('INOUT_Q')) -> record['ORDER_LOC_P']
			grdRecord.set('INOUT_FOR_O'			, orderUnitAmt);			//외화금액(재고)
			grdRecord.set('INOUT_FOR_P'			, isNaN(grdRecord.get('INOUT_FOR_O') / grdRecord.get('INOUT_Q'))?0:grdRecord.get('INOUT_FOR_O')/ grdRecord.get('INOUT_Q')); //외화단가(재고)
			/* if(record['EXCHG_RATE_O'] == '0' || record['EXCHG_RATE_O'] == '1'){
				grdRecord.set('EXCHG_RATE_O'	, panelSearch.getValue('EXCHG_RATE_O'));
			}else{
				grdRecord.set('EXCHG_RATE_O'	, record['EXCHG_RATE_O']);
			} */
			grdRecord.set('EXCHG_RATE_O'		, exchgRateO);
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('LC_NUM'				, record['LC_NUM']);
			grdRecord.set('BL_NUM'				, record['BL_NO']);
			grdRecord.set('WH_CODE'				, panelSearch.getValue('WH_CODE'));
			grdRecord.set('WH_CELL_CODE'		, panelSearch.getValue('WH_CELL_CODE'));
			grdRecord.set('INOUT_PRSN'			, panelSearch.getValue('INOUT_PRSN'));
			grdRecord.set('COMPANY_NUM'			, BsaCodeInfo.gsCompanyNum);// gsCompanyNum 확인필요
			grdRecord.set('INSTOCK_Q'			, record['INSTOCK_Q']);
			grdRecord.set('PRICE_YN'			, record['UNIT_PRICE_TYPE']);
			grdRecord.set('BASIS_NUM'			, record['BASIS_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['BASIS_SEQ']);
			grdRecord.set('TRADE_LOC'			, record['TRADE_LOC']);
			grdRecord.set('GOOD_STOCK_Q'		, record['GOOD_STOCK_Q']);
			grdRecord.set('BAD_STOCK_Q'			, record['BAD_STOCK_Q']);
			grdRecord.set('ORIGINAL_Q'			, '0');
			if(panelSearch.getValue('DIV_CODE') == ''){
				grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			}else{
				grdRecord.set('DIV_CODE'		, panelSearch.getValue('DIV_CODE'));
			}
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('EXCESS_RATE'			, record['EXCESS_RATE']);
			grdRecord.set('LOT_YN'				, record['LOT_YN']);
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');
			grdRecord.set('SOF_ORDER_NUM'		, record['SOF_ORDER_NUM']);
			grdRecord.set('SOF_ORDER_SEQ'		, record['SOF_ORDER_SEQ']);
			grdRecord.set('SOF_CUSTOM_NAME'		, record['SOF_CUSTOM_NAME']);
			grdRecord.set('SOF_ITEM_NAME'		, record['SOF_ITEM_NAME']);
			if(panelSearch.getValue("CREATE_LOC").CREATE_LOC == "2"){
				grdRecord.set('CREATE_LOC'		, "2");
			}else{
				grdRecord.set('CREATE_LOC'		, "6");
			}

			CustomCodeInfo.gsUnderCalBase = record['WON_CALC_BAS'];
			//20200609 추가
			directMasterStore1.fnSumAmountI();
			//환율이 jpy일 경우 /100처리, 20200608 주석
//			grdRecord.set('ORDER_UNIT_P', UniMatrl.fnExchangeApply(moneyUnit, grdRecord.get('ORDER_UNIT_P')));
//			grdRecord.set('ORDER_UNIT_I', UniMatrl.fnExchangeApply(moneyUnit, grdRecord.get('ORDER_UNIT_I')));
//			grdRecord.set('INOUT_I'		, UniMatrl.fnExchangeApply(moneyUnit, grdRecord.get('INOUT_I')));
//			grdRecord.set('INOUT_P'		, UniMatrl.fnExchangeApply(moneyUnit, grdRecord.get('INOUT_P')));
			UniMatrl.fnStockQ(grdRecord	, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE'));
		},
		setReturnPossibleData:function(record){
			var grdRecord	= this.getSelectedRecord();
			var moneyUnit	= panelSearch.getValue('MONEY_UNIT');
			grdRecord.set('INOUT_TYPE'			,'1');
			grdRecord.set('INOUT_METH'			,'1');
			grdRecord.set('INOUT_NUM'			, panelSearch.getValue('INOUT_NUM'));
			grdRecord.set('INOUT_TYPE_DETAIL'	, '90');//gsInoutTypeDetail ?확인필요
			grdRecord.set('INOUT_CODE_TYPE'		, '4');
			grdRecord.set('INOUT_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, panelSearch.getValue('CUSTOM_NAME'));
			grdRecord.set('INOUT_DATE'			, panelSearch.getValue('INOUT_DATE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ITEM_STATUS'			, '1');
			grdRecord.set('ACCOUNT_Q'			, '0');
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			if(record['TRNS_RATE'] == '0'){
				grdRecord.set('TRNS_RATE'		, '1');
			}else{
				grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			}

//			var orderUnitAmt = record['ORDER_UNIT_P'] * (record['REMAIN_Q'] / record['TRNS_RATE']) 20190708 REMAIN_Q가 구매단위량이라 입수 나누기 제외
			var orderUnitAmt = record['ORDER_UNIT_P'] * record['REMAIN_Q'] ;
//			var orderLocAmt = record['ORDER_LOC_P'] * (record['REMAIN_Q'] / record['TRNS_RATE'])  20190708 REMAIN_Q가 구매단위량이라 입수 나누기 제외
			var orderLocAmt = record['ORDER_LOC_P'] * record['REMAIN_Q'] ;
			grdRecord.set('ORDER_UNIT_Q'		, record['REMAIN_Q']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_FOR_O'	, orderUnitAmt);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_LOC_P']);
			grdRecord.set('ORDER_UNIT_I'		, orderLocAmt);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('INOUT_Q'				, record['NOINOUT_Q']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('NOINOUT_Q'			, record['NOINOUT_Q']);
			grdRecord.set('INOUT_I'				, orderLocAmt);
			grdRecord.set('ACCOUNT_YNC'			, 'Y');
//			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('INOUT_P'				, record['ORDER_LOC_P']);		//20200908 수정: isNaN(grdRecord.get('INOUT_I')/ grdRecord.get('INOUT_Q'))?0:grdRecord.get('INOUT_I')/ grdRecord.get('INOUT_Q') -> record['ORDER_LOC_P']
			grdRecord.set('INOUT_FOR_O'			, orderUnitAmt);
			grdRecord.set('INOUT_FOR_P'			, isNaN(grdRecord.get('INOUT_FOR_O') / grdRecord.get('INOUT_Q'))?0:grdRecord.get('INOUT_FOR_O')/ grdRecord.get('INOUT_Q'));
			grdRecord.set('EXCHG_RATE_O'		, panelSearch.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('LC_NUM'				, record['LC_NUM']);
			grdRecord.set('BL_NUM'				, record['BL_NO']);
			grdRecord.set('WH_CODE'				, panelSearch.getValue('WH_CODE'));
			grdRecord.set('WH_CELL_CODE'		, panelSearch.getValue('WH_CELL_CODE'));
			grdRecord.set('INOUT_PRSN'			, panelSearch.getValue('INOUT_PRSN'));
			grdRecord.set('COMPANY_NUM'			, BsaCodeInfo.gsCompanyNum);// gsCompanyNum 확인필요
			grdRecord.set('INSTOCK_Q'			, record['INSTOCK_Q']);
			grdRecord.set('PRICE_YN'			, record['UNIT_PRICE_TYPE']);
			grdRecord.set('BASIS_NUM'			, record['BASIS_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['BASIS_SEQ']);
			grdRecord.set('TRADE_LOC'			, record['TRADE_LOC']);
			grdRecord.set('ORIGINAL_Q'			, '0');
			if(panelSearch.getValue('DIV_CODE') == ''){
				grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			}else{
				grdRecord.set('DIV_CODE'		, panelSearch.getValue('DIV_CODE'));
			}
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('EXCESS_RATE'			, record['EXCESS_RATE']);
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');

			if(panelSearch.getValue("CREATE_LOC").CREATE_LOC  == "2"){
				grdRecord.set('CREATE_LOC'		, "2");
			}else{
				grdRecord.set('CREATE_LOC'		, "6");
			}
			//환율이 jpy일 경우 /100처리, 20200608 주석
//			grdRecord.set('ORDER_UNIT_P', UniMatrl.fnExchangeApply(moneyUnit, grdRecord.get('ORDER_UNIT_P')));
//			grdRecord.set('ORDER_UNIT_I', UniMatrl.fnExchangeApply(moneyUnit, grdRecord.get('ORDER_UNIT_I')));
//			grdRecord.set('INOUT_I',	  UniMatrl.fnExchangeApply(moneyUnit, grdRecord.get('INOUT_I')));
//			grdRecord.set('INOUT_P',	  UniMatrl.fnExchangeApply(moneyUnit, grdRecord.get('INOUT_P')));
			UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE'));
		},
		setInspectData:function(record){
			var grdRecord = this.getSelectedRecord();
			var exchangeRateO = panelSearch.getValue('EXCHG_RATE_O');
			var moneyUnit	  = panelSearch.getValue('MONEY_UNIT');
			if(BsaCodeInfo.gsExchangeRate == '10') {				//입고환율적용시점(10: 통관시점, 20: 입고시점)
				exchangeRateO = record['EXCHG_RATE_O'];
				panelSearch.setValue('EXCHG_RATE_O'	, exchangeRateO);
				panelResult2.setValue('EXCHG_RATE_O', exchangeRateO);
			}
			grdRecord.set('INOUT_TYPE'			,'1');
			grdRecord.set('INOUT_METH'			,'1');
			grdRecord.set('INOUT_NUM'			, panelSearch.getValue('INOUT_NUM'));
			grdRecord.set('INOUT_TYPE_DETAIL'	, record['INOUT_TYPE_DETAIL']);
			grdRecord.set('INOUT_CODE_TYPE'		, '4');
			grdRecord.set('INOUT_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, panelSearch.getValue('CUSTOM_NAME'));
			grdRecord.set('INOUT_DATE'			, panelSearch.getValue('INOUT_DATE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ITEM_STATUS'			, record['ITEM_STATUS']);
			grdRecord.set('ACCOUNT_Q'			, '0');
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			if(record['TRNS_RATE'] == '0'){
				grdRecord.set('TRNS_RATE'		, '1');
			}else{
				grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			}
			grdRecord.set('ORDER_UNIT_Q'		, record['NOINOUT_Q']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('INOUT_Q'				, record['NOINOUT_Q'] * record['TRNS_RATE']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('NOINOUT_Q'			, record['NOINOUT_Q'] * record['TRNS_RATE']);
			grdRecord.set('ACCOUNT_YNC'			, 'Y');
//			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);

			//20200319 추가: 조건 추가
			if(record.ORDER_UNIT_Q != record.REMAIN_Q) {
				//1. 기존로직 수행
				grdRecord.set('ORDER_UNIT_FOR_P', record['ORDER_UNIT_P']);
				grdRecord.set('ORDER_UNIT_FOR_O', record['ORDER_UNIT_P'] * record['NOINOUT_Q']);
				grdRecord.set('ORDER_UNIT_P'	, UniMatrl.fnExchangeApply(moneyUnit, record['ORDER_UNIT_P'] * exchangeRateO));								//자사단가, 20200908 수정: jpy 관련로직 추가
				var orderUnitAmt= record['ORDER_UNIT_P'] * (record['REMAIN_Q'] / record['TRNS_RATE']);
				var orderLocAmt	= UniMatrl.fnExchangeApply(moneyUnit, record['ORDER_UNIT_P'] * (record['REMAIN_Q'] / record['TRNS_RATE']) * exchangeRateO);	//20200908 수정: jpy 관련로직 추가
				orderLocAmt		= UniMatrl.fnAmtWonCalc(orderLocAmt, record['WON_CALC_BAS'], 0)	;
				grdRecord.set('ORDER_UNIT_I'	, orderLocAmt);
				grdRecord.set('INOUT_P'			, UniMatrl.fnExchangeApply(moneyUnit, record['ORDER_UNIT_P'] * exchangeRateO / record['TRNS_RATE']));		//20200908 수정: 조건별로 다른 값 입력되도록 수정
				grdRecord.set('INOUT_I'			, orderLocAmt);																	//20200423 수정: 자사금액과 동일하게 들어도록 하기 위해 위로 로직 변경/이동
				grdRecord.set('INOUT_FOR_O'		, orderUnitAmt);
			} else {
				//2. 조회된 값 적용
				grdRecord.set('ORDER_UNIT_FOR_P', record['ORDER_UNIT_P']);
				grdRecord.set('ORDER_UNIT_FOR_O', record['ORDER_O']);
				grdRecord.set('ORDER_UNIT_P'	, record['ORDER_LOC_P'] == 0 ? record['ORDER_UNIT_P'] : record['ORDER_LOC_P']);	//20200423 수정
				grdRecord.set('ORDER_UNIT_I'	, record['ORDER_LOC_O'] == 0 ? record['ORDER_O'] : record['ORDER_LOC_O']);		//20200423 수정
				grdRecord.set('INOUT_P'			, record['ORDER_LOC_P'] == 0 ? record['ORDER_UNIT_P'] : record['ORDER_LOC_P']);	//20200908 수정: 조건별로 다른 값 입력되도록 수정
				grdRecord.set('INOUT_I'			, record['ORDER_LOC_O'] == 0 ? record['ORDER_O'] : record['ORDER_LOC_O']);		//20200423 수정: 자사금액과 동일하게 들어도록 하기 위해 위로 로직 변경/이동
				grdRecord.set('INOUT_FOR_O'		, record['ORDER_O']);
			}
			grdRecord.set('INOUT_FOR_P'			, grdRecord.get('INOUT_FOR_O') / grdRecord.get('INOUT_Q'));
			//20200423 수정: 자사금액과 동일하게 들어도록 하기 위해 위로 로직 변경/이동
//			grdRecord.set('INOUT_I'				, record['ORDER_UNIT_P'] * exchangeRateO * record['NOINOUT_Q']);				// 자사단가(ORDER_UNIT_P)
//			grdRecord.set('INOUT_I'				, UniMatrl.fnAmtWonCalc(grdRecord.get('INOUT_I'), record['WON_CALC_BAS'], 0));	//원단위미만 처리

			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('LC_NUM'				, record['LC_NO']);
			grdRecord.set('BL_NUM'				, record['BL_NO']);
			grdRecord.set('WH_CODE'				, panelSearch.getValue('WH_CODE'));
			grdRecord.set('WH_CELL_CODE'		, panelSearch.getValue('WH_CELL_CODE'));
			grdRecord.set('INOUT_PRSN'			, panelSearch.getValue('INOUT_PRSN'));
			grdRecord.set('COMPANY_NUM'			, BsaCodeInfo.gsCompanyNum);// gsCompanyNum 확인필요
			grdRecord.set('INSTOCK_Q'			, record['INSTOCK_Q']);
			grdRecord.set('PRICE_YN'			, record['UNIT_PRICE_TYPE']);
			grdRecord.set('BASIS_NUM'			, record['BASIS_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['BASIS_SEQ']);
			grdRecord.set('TRADE_LOC'			, record['TRADE_LOC']);
			grdRecord.set('GOOD_STOCK_Q'		, record['GOOD_STOCK_Q']);
			grdRecord.set('BAD_STOCK_Q'			, record['BAD_STOCK_Q']);
			grdRecord.set('EXCHG_RATE_O'		, exchangeRateO);
			grdRecord.set('ORIGINAL_Q'			, '0');

			if(panelSearch.getValue('DIV_CODE') == ''){
				grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			}else{
				grdRecord.set('DIV_CODE'		, panelSearch.getValue('DIV_CODE'));
			}
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, '');
			grdRecord.set('EXCESS_RATE'			, record['EXCESS_RATE']);
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');

			grdRecord.set('INSPEC_NUM'			, record['INSPEC_NUM']);
			grdRecord.set('INSPEC_SEQ'			, record['INSPEC_SEQ']);
			grdRecord.set('RECEIPT_NUM'			, record['RECEIPT_NUM']);
			grdRecord.set('RECEIPT_SEQ'			, record['RECEIPT_SEQ']);

//			grdRecord.set('PURCHASE_TYPE'		, !record['PURCHASE_TYPE']?'0':record['PURCHASE_TYPE']);
			grdRecord.set('SALES_TYPE'			, record['SALES_TYPE']);
			grdRecord.set('SALE_BASIS_P'		, record['SALE_BASIS_P']);
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('LOT_YN'				, record['LOT_YN']);

//			grdRecord.set('PURCHASE_RATE'		, record['PURCHASE_RATE']);
			panelSearch.setValue('CUSTOM_CODE'	, record['CUSTOM_CODE']);
			panelSearch.setValue('CUSTOM_NAME'	, record['CUSTOM_NAME']);
			panelResult2.setValue('CUSTOM_CODE'	, record['CUSTOM_CODE']);
			panelResult2.setValue('CUSTOM_NAME'	, record['CUSTOM_NAME']);

			grdRecord.set('MAKE_LOT_NO'			, record['MAKE_LOT_NO']);
			grdRecord.set('MAKE_DATE'			, record['MAKE_DATE']);
			grdRecord.set('MAKE_EXP_DATE'		, record['MAKE_EXP_DATE']);
			grdRecord.set('SOF_ORDER_NUM'		, record['SOF_ORDER_NUM']);
			grdRecord.set('SOF_ORDER_SEQ'		, record['SOF_ORDER_SEQ']);
			grdRecord.set('SOF_CUSTOM_NAME'		, record['SOF_CUSTOM_NAME']);
			grdRecord.set('SOF_ITEM_NAME'		, record['SOF_ITEM_NAME']);
			var param = {
				"COMP_CODE": UserInfo.compCode,
				"ITEM_CODE": record['ITEM_CODE']
			};
			mms512ukrvService.taxType(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					grdRecord.set('TAX_TYPE', provider['TAX_TYPE']);
				}
			});

			CustomCodeInfo.gsUnderCalBase = record['WON_CALC_BAS'];
			//환율이 jpy일 경우 /100처리, 20200608 주석
//			grdRecord.set('ORDER_UNIT_P', UniMatrl.fnExchangeApply(moneyUnit, grdRecord.get('ORDER_UNIT_P')));
//			grdRecord.set('ORDER_UNIT_I', UniMatrl.fnExchangeApply(moneyUnit, grdRecord.get('ORDER_UNIT_I')));
//			grdRecord.set('INOUT_I',	  UniMatrl.fnExchangeApply(moneyUnit, grdRecord.get('INOUT_I')));
//			grdRecord.set('INOUT_P',	  UniMatrl.fnExchangeApply(moneyUnit, grdRecord.get('INOUT_P')));
			directMasterStore1.fnSumAmountI();
		},
		setScmRefData:function(record){
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('INOUT_TYPE'			,'1');
			grdRecord.set('INOUT_METH'			,'1');
			grdRecord.set('INOUT_NUM'			, panelSearch.getValue('INOUT_NUM'));
			grdRecord.set('INOUT_TYPE_DETAIL'	, gsInoutTypeDetail);//gsInoutTypeDetail ?확인필요
			grdRecord.set('INOUT_CODE_TYPE'		, '4');
			grdRecord.set('INOUT_CODE'			, panelSearch.getValue('CUSTOM_CODE'));
			grdRecord.set('CUSTOM_NAME'			, panelSearch.getValue('CUSTOM_NAME'));
			grdRecord.set('CREATE_LOC'			, '2');
			grdRecord.set('INOUT_DATE'			, panelSearch.getValue('INOUT_DATE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ITEM_STATUS'			, '1');
			grdRecord.set('ACCOUNT_Q'			, '0');
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			if(record['TRNS_RATE'] == '0'){
				grdRecord.set('TRNS_RATE'		, '1');
			}else{
				grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			}
			grdRecord.set('ORDER_UNIT_Q'		, record['INOUT_Q']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['INOUT_P']);
			grdRecord.set('ORDER_UNIT_FOR_O'	, record['INOUT_P'] * record['INOUT_Q']);
			grdRecord.set('ORDER_UNIT_P'		, record['INOUT_P'] * panelSearch.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_UNIT_I'		, record['INOUT_P'] * record['INOUT_Q'] * panelSearch.getValue('EXCHG_RATE_O'));
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('INOUT_Q'				, record['INOUT_Q']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('NOINOUT_Q'			, record['INOUT_Q'] * record['TRNS_RATE']);
			grdRecord.set('INOUT_I'				, record['INOUT_P'] * record['INOUT_Q']);
			grdRecord.set('ACCOUNT_YNC'			, 'Y');
//			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('INOUT_P'				, record['ORDER_UNIT_P'] / record['TRNS_RATE']);
			grdRecord.set('INOUT_FOR_O'			, record['INOUT_P'] * record['INOUT_Q']);
			grdRecord.set('INOUT_FOR_P'			, isNaN(grdRecord.get('INOUT_FOR_O') / grdRecord.get('INOUT_Q'))?0:grdRecord.get('INOUT_FOR_O')/ grdRecord.get('INOUT_Q'));
			grdRecord.set('EXCHG_RATE_O'		, panelSearch.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('ORDER_Q'				, '0');
			grdRecord.set('LC_NUM'				, '');
			grdRecord.set('WH_CODE'				, panelSearch.getValue('WH_CODE'));
			grdRecord.set('WH_CELL_CODE'		, panelSearch.getValue('WH_CELL_CODE'));
			grdRecord.set('INOUT_PRSN'			, panelSearch.getValue('INOUT_PRSN'));
			grdRecord.set('COMPANY_NUM'			, BsaCodeInfo.gsCompanyNum);// gsCompanyNum 확인필요
			grdRecord.set('INSTOCK_Q'			, '0');
			grdRecord.set('PRICE_YN'			, 'Y');
			grdRecord.set('SCM_FLAG_YN'			, 'Y');
			grdRecord.set('ORIGINAL_Q'			, '0');
			grdRecord.set('DIV_CODE'			, panelSearch.getValue('DIV_CODE'));
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, '');
			grdRecord.set('EXCESS_RATE'			, '');
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');
			grdRecord.set('BASIS_NUM'			, record['INOUT_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['INOUT_SEQ']);

			UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE'));
		}
	});//End of var masterGrid = Unilite.createGrid('mms512ukrvGrid1', {

	var inoutNoMasterGrid = Unilite.createGrid('mms512ukrvinoutNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
		layout : 'fit',
		excelTitle: '<t:message code="system.label.purchase.receiptentry" default="입고등록"/>(<t:message code="system.label.purchase.receiptnosearch2" default="입고번호검색"/>)',
		store: inoutNoMasterStore,
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false
		},
		columns:  [
			{ dataIndex: 'INOUT_NAME'	, width:166},
			{ dataIndex: 'INOUT_DATE'	, width:86},
			{ dataIndex: 'INOUT_CODE'	, width:120,hidden:true},
			{ dataIndex: 'WH_CODE'		, width:100},
			{ dataIndex: 'WH_CELL_CODE'	, width:120,hidden:!sumtypeCell},
			{ dataIndex: 'DIV_CODE'		, width:100},
			{ dataIndex: 'INOUT_PRSN'	, width:100, align: 'center'},
			{ dataIndex: 'INOUT_NUM'	, width:126, align: 'center'},
			{ dataIndex: 'BL_NO'		, width:100, align: 'center',hidden:false},
			{ dataIndex: 'INOUT_TYPE_DETAIL'		, width:100},
			{ dataIndex: 'ITEM_CODE'		, width:100,hidden:true},
			{ dataIndex: 'ITEM_NAME'		, width:400},
			{ dataIndex: 'MONEY_UNIT'	, width:53, align: 'center',hidden:true},
			{ dataIndex: 'EXCHG_RATE_O'	, width:53,hidden:true},
			{ dataIndex: 'CREATE_LOC'	, width:53,hidden:true},
			{ dataIndex: 'PERSON_NAME'	, width:53,hidden:true}

		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				inoutNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
				panelSearch.setAllFieldsReadOnly(true);
				panelResult2.setAllFieldsReadOnly(true);
				 //	directMasterStore1.fnSumAmountI();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelSearch.setValues({
				'DIV_CODE':record.get('DIV_CODE'),
				'INOUT_DATE':record.get('INOUT_DATE'),
				'INOUT_NUM':record.get('INOUT_NUM'),
				'WH_CODE':record.get('WH_CODE'),
				'CUSTOM_CODE':record.get('INOUT_CODE'),
				'CUSTOM_NAME':record.get('INOUT_NAME'),
				'EXCHG_RATE_O':record.get('EXCHG_RATE_O'),
				'MONEY_UNIT':record.get('MONEY_UNIT'),
				'INOUT_PRSN':record.get('INOUT_PRSN'),
				'CREATE_LOC':record.get('CREATE_LOC'),
				'PERSON_NAME':record.get('PERSON_NAME')
			});
			panelResult2.setValues({
				'DIV_CODE':record.get('DIV_CODE'),
				'INOUT_DATE':record.get('INOUT_DATE'),
				'INOUT_NUM':record.get('INOUT_NUM'),
				'WH_CODE':record.get('WH_CODE'),
				'CUSTOM_CODE':record.get('INOUT_CODE'),
				'CUSTOM_NAME':record.get('INOUT_NAME'),
				'EXCHG_RATE_O':record.get('EXCHG_RATE_O'),
				'MONEY_UNIT':record.get('MONEY_UNIT'),
				'INOUT_PRSN':record.get('INOUT_PRSN'),
				'CREATE_LOC':record.get('CREATE_LOC'),
				'PERSON_NAME':record.get('PERSON_NAME')
			});

			if(BsaCodeInfo.gsSumTypeCell=='Y'){
				panelSearch.getField('WH_CELL_CODE').getStore().getFilters().removeAll();
				panelSearch.getField('WH_CELL_CODE').getStore().filter('option', record.get('WH_CODE'));
				panelSearch.setValue('WH_CELL_CODE', record.get('WH_CELL_CODE'));

				panelResult2.getField('WH_CELL_CODE').getStore().getFilters().removeAll();
				panelResult2.getField('WH_CELL_CODE').getStore().filter('option', record.get('WH_CODE'));
				panelResult2.setValue('WH_CELL_CODE', record.get('WH_CELL_CODE'));

				//위의 필터 초기화 버그 때문에 아래 4줄 실행함 ( 필터가 한쪽만 초기화됨...)
				panelResult2.getField('WH_CELL_CODE').focus();
				panelResult2.getField('WH_CODE').focus();
				panelResult2.getField('WH_CELL_CODE').focus();
				panelResult2.getField('WH_CODE').focus();
			}
		}
	});

	var noreceiveGrid = Unilite.createGrid('mms512ukrvNoreceiveGrid', {//미입고참조
		layout : 'fit',
		excelTitle: '<t:message code="system.label.purchase.receiptentry" default="입고등록"/>(<t:message code="system.label.purchase.unreceiptreference" default="미입고참조"/>)',
		store: noReceiveStore,
		uniOpt: {
			onLoadSelectFirst : false,
			useGroupSummary: true,
			useLiveSearch: true
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
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false ,
			//20200331 수정: 체크로직 일괄 수정
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
					var beforeSelected	= rowSelection.selected.items;
					var gsBlSum			= panelResult.getValue('BlSumInoutO');
					var count			= 0;
					var amt				= 0;

					if(Ext.isEmpty(beforeSelected[0]) || beforeSelected[0].get('CUSTOM_CODE') == record.get('CUSTOM_CODE')) {
						Ext.each(beforeSelected, function(item, i){
							if(item.get('ORDER_NUM') == record.get('ORDER_NUM') && item.get('ORDER_SEQ') == record.get('ORDER_SEQ') && item.get('BL_NO') == record.get('BL_NO')) {
								count = count + 1;
							}
						});
						if(count < 1) {
							amt = record.get('ORDER_LOC_O');
						}
						gsBlSum = gsBlSum + amt;
						panelResult.setValue('BlSumInoutO', gsBlSum);
						return true;
					} else {
						return false;
					}
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ) {
					//20200331 수정: beforeselect로 기존로직 이동 후, 체크로직 일괄 수정
					var records		= noReceiveStore.data.items;
					var sm			= noreceiveGrid.getSelectionModel();
					var selRecords	= noreceiveGrid.getSelectionModel().getSelection();

					Ext.each(records, function(record, i){
						if(!Ext.isEmpty(selectRecord.get('BL_NO'))){
							if(selectRecord.get('ORDER_NUM') == record.get('ORDER_NUM') && selectRecord.get('ORDER_SEQ') == record.get('ORDER_SEQ') && selectRecord.get('BL_NO') == record.get('BL_NO')) {
								selRecords.push(record);
							}
						}else if(!Ext.isEmpty(selectRecord.get('INSPEC_NUM'))){
							if(selectRecord.get('ORDER_NUM') == record.get('ORDER_NUM') && selectRecord.get('ORDER_SEQ') == record.get('ORDER_SEQ')
							&& selectRecord.get('INSPEC_NUM') == record.get('INSPEC_NUM') && selectRecord.get('INSPEC_SEQ') == record.get('INSPEC_SEQ')) {
								selRecords.push(record);
							}
						}else{
							if(selectRecord.get('ORDER_NUM') == record.get('ORDER_NUM') && selectRecord.get('ORDER_SEQ') == record.get('ORDER_SEQ')
							&& selectRecord.get('RECEIPT_NUM') == record.get('RECEIPT_NUM') && selectRecord.get('RECEIPT_SEQ') == record.get('RECEIPT_SEQ')) {
								selRecords.push(record);
							}
						}
					});
					sm.select(selRecords);

/*					var records = noReceiveStore.data.items;
					var customCode = '';
					var data = new Object();
					data.records = [];
					var isErr = false;
					Ext.each(records, function(record, i){
						if( noreceiveGrid.getSelectionModel().isSelected(record) == true && selectRecord.get('CUSTOM_CODE') != record.get('CUSTOM_CODE') ) {
							customCode = record.get('CUSTOM_CODE');
							data.records.push(record);
						}
					});
					Ext.each(records, function(record, i){
						if( noreceiveGrid.getSelectionModel().isSelected(record) == true) {
							if(!Ext.isEmpty(customCode) && customCode != record.get('CUSTOM_CODE')){
								//alert("검사결과정보의 거래처를 2개 이상 선택할 수 없습니다.");
								isErr = true;
								return false;
							}
						}
					});
					noreceiveGrid.getSelectionModel().select(data.records);
						if(isErr == true){
							return false;
					}*/
				},
				beforedeselect : function( me, record, index, eOpts ){
					if(index != -1) {		//윈도우 닫을 때를 제외하고 로직 수행하기 위한 조건 추가
						var beforeSelected	= me.selected.items;
						var gsBlSum			= panelResult.getValue('BlSumInoutO');
						var count			= 0;
						var amt				= 0;

						Ext.each(beforeSelected, function(item, i){
							if(item.get('ORDER_NUM') == record.get('ORDER_NUM') && item.get('ORDER_SEQ') == record.get('ORDER_SEQ') && item.get('BL_NO') == record.get('BL_NO')) {
								count = count + 1;
							}
						});
						if(count == 1) {
							amt = record.get('ORDER_LOC_O');
						}
						gsBlSum = gsBlSum - amt;
						panelResult.setValue('BlSumInoutO', gsBlSum);
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ) {
					var records		= noReceiveStore.data.items;
					var sm			= noreceiveGrid.getSelectionModel();
					var deselRecords= [];

					Ext.each(records, function(record, i){
						if(!Ext.isEmpty(selectRecord.get('BL_NO'))){
							if(selectRecord.get('ORDER_NUM') == record.get('ORDER_NUM') && selectRecord.get('ORDER_SEQ') == record.get('ORDER_SEQ') && selectRecord.get('BL_NO') == record.get('BL_NO')) {
								deselRecords.push(record);
							}
						}else if(!Ext.isEmpty(selectRecord.get('LC_NUM'))){
							if(selectRecord.get('ORDER_NUM') == record.get('ORDER_NUM') && selectRecord.get('ORDER_SEQ') == record.get('ORDER_SEQ') && selectRecord.get('LC_NUM') == record.get('LC_NUM')) {
								deselRecords.push(record);
							}
						}else if(!Ext.isEmpty(selectRecord.get('BL_NUM'))){
							if(selectRecord.get('ORDER_NUM') == record.get('ORDER_NUM') && selectRecord.get('ORDER_SEQ') == record.get('ORDER_SEQ') && selectRecord.get('BL_NUM') == record.get('BL_NUM')) {
								deselRecords.push(record);
							}
						}else{
							if(selectRecord.get('ORDER_NUM') == record.get('ORDER_NUM') && selectRecord.get('ORDER_SEQ') == record.get('ORDER_SEQ')
							&& selectRecord.get('BASIS_NUM') == record.get('BASIS_NUM') && selectRecord.get('BASIS_SEQ') == record.get('BASIS_SEQ')) {
								deselRecords.push(record);
							}
						}
					});
					sm.deselect(deselRecords);
				}
			}
		}),
		columns:  [
			{ dataIndex: 'GUBUN'				, width:33,locked:false,hidden:true},
			{ dataIndex: 'CUSTOM_CODE'			, width:100,hidden:false,locked:false},
			{ dataIndex: 'CUSTOM_NAME'			, width:150,hidden:false,locked:false},
			{ dataIndex: 'ITEM_CODE'			, width:120,locked:false},
			{ dataIndex: 'ITEM_NAME'			, width:150,locked:false},
			{ dataIndex: 'ITEM_ACCOUNT'			, width:120,hidden:true},
			{ dataIndex: 'SPEC'					, width:150},
			{ dataIndex: 'SOF_ORDER_NUM'		, width:100,hidden:true},
			{ dataIndex: 'SOF_ORDER_SEQ'		, width:80,hidden:true},
			{ dataIndex: 'SOF_CUSTOM_NAME'		, width:100,hidden:true},
			{ dataIndex: 'SOF_ITEM_NAME'		, width:120,hidden:true},
			{ dataIndex: 'DVRY_DATE'			, width:86},
			{ dataIndex: 'DIV_CODE'				, width:80,hidden:true},
			{ dataIndex: 'ORDER_UNIT'			, width:66,align:"center"},
			{ dataIndex: 'ORDER_UNIT_Q'			, width:100,hidden:true},
			{ dataIndex: 'REMAIN_Q'				, width:100,summaryType: 'sum'},
			{ dataIndex: 'STOCK_UNIT'			, width:53,hidden:true,align:"center"},
			{ dataIndex: 'NOINOUT_Q'			, width:100,hidden:true},
			{ dataIndex: 'ORDER_Q'				, width:100,hidden:true},
			{ dataIndex: 'UNIT_PRICE_TYPE'		, width:100},
			{ dataIndex: 'MONEY_UNIT'			, width:66,align:"center"},
			{ dataIndex: 'EXCHG_RATE_O'			, width:90},
			{ dataIndex: 'ORDER_P'				, width:93,hidden:true},
			{ dataIndex: 'ORDER_UNIT_P'			, width:100},
			{ dataIndex: 'ORDER_O'				, width:100,summaryType: 'sum'},
			{ dataIndex: 'ORDER_LOC_P'			, width:100},
			{ dataIndex: 'ORDER_LOC_O'			, width:100,summaryType: 'sum'},
			{ dataIndex: 'ORDER_NUM'			, width:120},
			{ dataIndex: 'ORDER_SEQ'			, width:66,align:"center"},
			{ dataIndex: 'LC_NUM'				, width:33,hidden:true},
			{ dataIndex: 'WH_CODE'				, width:33,hidden:true},
			{ dataIndex: 'ORDER_REQ_NUM'		, width:33,hidden:true},
			{ dataIndex: 'ORDER_TYPE'			, width:33,hidden:true},
			{ dataIndex: 'TRNS_RATE'			, width:80,hidden:true},
			{ dataIndex: 'INSTOCK_Q'			, width:80,hidden:true},
			{ dataIndex: 'REMARK'				, width:150},
			{ dataIndex: 'PROJECT_NO'			, width:120},
			{ dataIndex: 'EXCESS_RATE'			, width:80,hidden:true},
			{ dataIndex: 'ORDER_PRSN'			, width:100},
			{ dataIndex: 'GOOD_STOCK_Q'			, width:66,hidden:true},
			{ dataIndex: 'BAD_STOCK_Q'			, width:66,hidden:true},
			{ dataIndex: 'LC_NO'				, width:66,hidden:true},
			{ dataIndex: 'BL_NO'				, width:66,hidden:true},
			{ dataIndex: 'BASIS_NUM'			, width:66,hidden:true},
			{ dataIndex: 'BASIS_SEQ'			, width:53,hidden:true},
			{ dataIndex: 'LC_DATE'				, width:66,hidden:true},
			{ dataIndex: 'INVOICE_DATE'			, width:66,hidden:true},
			{ dataIndex: 'TRADE_LOC'			, width:53,hidden:true},
			{ dataIndex: 'LOT_NO'				, width:53},
			{ dataIndex: 'LOT_YN'				, width:53,hidden: true},
			{ dataIndex: 'BL_NUM'				, width:66,hidden: false},
			{ dataIndex: 'WON_CALC_BAS'			, width:66,hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();

			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setNoreceiveData(record.data);
			});
			//20200609 수정
//			this.deleteSelectedRow();
			this.getStore().remove(records);
		}
	});

	var returnpossibleGrid = Unilite.createGrid('mms512ukrvReturnpossibleGrid', {//반품가능발주참조
		layout: 'fit',
		excelTitle: '<t:message code="system.label.purchase.receiptentry" default="입고등록"/>(<t:message code="system.label.purchase.returnavaiableporefer" default="반품가능발주참조"/>)',
		store: returnPossibleStore,
		uniOpt: {
			onLoadSelectFirst : false,
			useGroupSummary: true,
			useLiveSearch: true
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
		selModel:	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns:  [
			{ dataIndex: 'GUBUN'				,  width:33,locked:true,hidden:true},
			{ dataIndex: 'ITEM_CODE'			,  width:120,locked:true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.subtotal" default="소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
				}
			},
			{ dataIndex: 'ITEM_NAME'			,  width:150,locked:true},
			{ dataIndex: 'ITEM_ACCOUNT'			,  width:120,hidden:true},
			{ dataIndex: 'SPEC'					,  width:150},
			{ dataIndex: 'DVRY_DATE'			,  width:86},
			{ dataIndex: 'DIV_CODE'				,  width:66,hidden:true},
			{ dataIndex: 'ORDER_UNIT'			,  width:80,align:"center"},
			{ dataIndex: 'ORDER_UNIT_Q'			,  width:100,hidden:true},
			{ dataIndex: 'REMAIN_Q'				,  width:100,summaryType: 'sum'},
			{ dataIndex: 'STOCK_UNIT'			,  width:80,hidden:true},
			{ dataIndex: 'NOINOUT_Q'			,  width:100,hidden:true},
			{ dataIndex: 'ORDER_Q'				,  width:113,hidden:true},
			{ dataIndex: 'UNIT_PRICE_TYPE'		,  width:90},
			{ dataIndex: 'MONEY_UNIT'			,  width:80,align:"center"},
			{ dataIndex: 'EXCHG_RATE_O'			,  width:80,hidden:true},
			{ dataIndex: 'ORDER_P'				,  width:93,hidden:true},
			{ dataIndex: 'ORDER_UNIT_P'			,  width:100},
			{ dataIndex: 'ORDER_O'				,  width:100,summaryType: 'sum'},
			{ dataIndex: 'ORDER_LOC_P'			,  width:100},
			{ dataIndex: 'ORDER_LOC_O'			,  width:100,summaryType: 'sum'},
			{ dataIndex: 'ORDER_NUM'			,  width:120},
			{ dataIndex: 'ORDER_SEQ'			,  width:66,align:"center"},
			{ dataIndex: 'LC_NUM'				,  width:80,hidden:true},
			{ dataIndex: 'WH_CODE'				,  width:80,hidden:true},
			{ dataIndex: 'ORDER_REQ_NUM'		,  width:80,hidden:true},
			{ dataIndex: 'ORDER_TYPE'			,  width:80,hidden:true},
			{ dataIndex: 'CUSTOM_CODE'			,  width:60,hidden:true},
			{ dataIndex: 'TRNS_RATE'			,  width:80,hidden:true},
			{ dataIndex: 'INSTOCK_Q'			,  width:80,hidden:true},
			{ dataIndex: 'REMARK'				,  width:133},
			{ dataIndex: 'PROJECT_NO'			,  width:133},
			{ dataIndex: 'EXCESS_RATE'			,  width:80,hidden:true},
			{ dataIndex: 'LC_NO'				,  width:80,hidden:true},
			{ dataIndex: 'BL_NO'				,  width:80,hidden:true},
			{ dataIndex: 'BASIS_NUM'			,  width:80,hidden:true},
			{ dataIndex: 'BASIS_SEQ'			,  width:80,hidden:true},
			{ dataIndex: 'LC_DATE'				,  width:66,hidden:true},
			{ dataIndex: 'INVOICE_DATE'			,  width:66,hidden:true},
			{ dataIndex: 'TRADE_LOC'			,  width:53,hidden:true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
				var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setReturnPossibleData(record.data);
			});
			this.deleteSelectedRow();
			}
	});

/*	var scmRefGrid= Unilite.createGrid('mms512ukrvScmRefGrid1', {//업체출고 참조(SCM)
		region: 'center' ,
		layout: 'fit',
		store: scmRefStore,
		uniOpt: {
			onLoadSelectFirst : false,
			useGroupSummary: true,
			useLiveSearch: true
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
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns: [
				{dataIndex:'GUBUN'						,width:80,hidden:true},
				{dataIndex:'CUSTOM_NAME'				,width:150},
				{dataIndex:'INOUT_NUM'					,width:120},
				{dataIndex:'INOUT_SEQ'					,width:66,align:"center"},
				{dataIndex:'INOUT_DATE'					,width:86},
				{dataIndex:'CUSTOM_ITEM_CODE'			,width:120},
				{dataIndex:'ITEM_CODE'					,width:120},
				{dataIndex:'ITEM_NAME'					,width:150},
				{dataIndex:'SPEC'						,width:150},
				{dataIndex:'MONEY_UNIT'					,width:66,align:"center"},
				{dataIndex:'EXCHG_RATE_O'				,width:66},
				{dataIndex:'ORDER_UNIT'					,width:66,align:"center"},
				{dataIndex:'TRNS_RATE'					,width:66},
				{dataIndex:'INOUT_Q'					,width:100,summaryType: 'sum'},
				{dataIndex:'INOUT_P'					,width:100},
				{dataIndex:'INOUT_I'					,width:100,summaryType: 'sum'},
				{dataIndex:'INOUT_PRSN'					,width:100},
				{dataIndex:'ORDER_NUM'					,width:120},
				{dataIndex:'ORDER_SEQ'					,width:80,align:"center"},
				{dataIndex:'REMARK'						,width:80},
				{dataIndex:'ITEM_ACCOUNT'				,width:80,hidden:true},
				{dataIndex:'STOCK_CARE_YN'				,width:80,hidden:true},
				{dataIndex:'WH_CODE'					,width:80,hidden:true},
				{dataIndex:'STOCK_UNIT'					,width:80,hidden:true,align:"center"},
				{dataIndex:'INOUT_FOR_P'				,width:80,hidden:true},
				{dataIndex:'INOUT_FOR_O'				,width:80,hidden:true},
				{dataIndex:'ORDER_TYPE'					,width:80,hidden:true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
				var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setScmRefData(record.data);
			});
			this.deleteSelectedRow();
			}
	});*/

	var inspectresultGrid2 = Unilite.createGrid('mms512ukrvInspectResultGrid2', {//검사결과참조
		region: 'east' ,
		layout : 'fit',
		excelTitle: '<t:message code="system.label.purchase.receiptentry" default="입고등록"/>(<t:message code="system.label.purchase.inspecresultrefer" default="검사결과참조"/>)',
		store: inspectResultStore2,
		uniOpt: {
			onLoadSelectFirst : false,
			useGroupSummary: true,
			useLiveSearch: true
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
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false,
			listeners: {
				//20200331 수정: 체크로직 일괄 수정
				beforeselect: function(rowSelection, record, index, eOpts) {
					var beforeSelected	= rowSelection.selected.items;
					var gsBlSum			= panelResult.getValue('BlSumInoutO');
					var count			= 0;
					var amt				= 0;

					if(Ext.isEmpty(beforeSelected[0]) || beforeSelected[0].get('CUSTOM_CODE') == record.get('CUSTOM_CODE')) {
						Ext.each(beforeSelected, function(item, i){
							if(item.get('ORDER_NUM') == record.get('ORDER_NUM') && item.get('ORDER_SEQ') == record.get('ORDER_SEQ') && item.get('BL_NO') == record.get('BL_NO')) {
								count = count + 1;
							}
						});
						if(count < 1) {
							amt = record.get('ORDER_LOC_O');
						}
						gsBlSum = gsBlSum + amt;
						panelResult.setValue('BlSumInoutO', gsBlSum);
						return true;
					} else {
						return false;
					}
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ) {
					//20200331 수정: beforeselect로 기존로직 이동 후, 체크로직 일괄 수정
					var records		= inspectResultStore2.data.items;
					var sm			= inspectresultGrid2.getSelectionModel();
					var selRecords	= inspectresultGrid2.getSelectionModel().getSelection();

					Ext.each(records, function(record, i){
						if(!Ext.isEmpty(selectRecord.get('BL_NO'))){
							if(selectRecord.get('ORDER_NUM') == record.get('ORDER_NUM') && selectRecord.get('ORDER_SEQ') == record.get('ORDER_SEQ') && selectRecord.get('BL_NO') == record.get('BL_NO')) {
								selRecords.push(record);
							}
						}else if(!Ext.isEmpty(selectRecord.get('INSPEC_NUM'))){
							if(selectRecord.get('ORDER_NUM') == record.get('ORDER_NUM') && selectRecord.get('ORDER_SEQ') == record.get('ORDER_SEQ')
							&& selectRecord.get('INSPEC_NUM') == record.get('INSPEC_NUM') && selectRecord.get('INSPEC_SEQ') == record.get('INSPEC_SEQ')) {
								selRecords.push(record);
							}
						}else{
							if(selectRecord.get('ORDER_NUM') == record.get('ORDER_NUM') && selectRecord.get('ORDER_SEQ') == record.get('ORDER_SEQ')
							&& selectRecord.get('RECEIPT_NUM') == record.get('RECEIPT_NUM') && selectRecord.get('RECEIPT_SEQ') == record.get('RECEIPT_SEQ')) {
								selRecords.push(record);
							}
						}
					});
					sm.select(selRecords);
				},
				beforedeselect : function( me, record, index, eOpts ){
					if(index != -1) {		//윈도우 닫을 때를 제외하고 로직 수행하기 위한 조건 추가
						var beforeSelected	= me.selected.items;
						var gsBlSum			= panelResult.getValue('BlSumInoutO');
						var count			= 0;
						var amt				= 0;

						Ext.each(beforeSelected, function(item, i){
							if(item.get('ORDER_NUM') == record.get('ORDER_NUM') && item.get('ORDER_SEQ') == record.get('ORDER_SEQ') && item.get('BL_NO') == record.get('BL_NO')) {
								count = count + 1;
							}
						});
						if(count == 1) {
							amt = record.get('ORDER_LOC_O');
						}
						gsBlSum = gsBlSum - amt;
						panelResult.setValue('BlSumInoutO', gsBlSum);
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ) {
					var records		= inspectResultStore2.data.items;
					var sm			= inspectresultGrid2.getSelectionModel();
					var deselRecords= [];

					Ext.each(records, function(record, i){
						if(!Ext.isEmpty(selectRecord.get('BL_NO'))){
							if(selectRecord.get('ORDER_NUM') == record.get('ORDER_NUM') && selectRecord.get('ORDER_SEQ') == record.get('ORDER_SEQ') && selectRecord.get('BL_NO') == record.get('BL_NO')) {
								deselRecords.push(record);
							}
						}else if(!Ext.isEmpty(selectRecord.get('INSPEC_NUM'))){
							if(selectRecord.get('ORDER_NUM') == record.get('ORDER_NUM') && selectRecord.get('ORDER_SEQ') == record.get('ORDER_SEQ')
							&& selectRecord.get('INSPEC_NUM') == record.get('INSPEC_NUM') && selectRecord.get('INSPEC_SEQ') == record.get('INSPEC_SEQ')) {
								deselRecords.push(record);
							}
						}else{
							if(selectRecord.get('ORDER_NUM') == record.get('ORDER_NUM') && selectRecord.get('ORDER_SEQ') == record.get('ORDER_SEQ')
							&& selectRecord.get('RECEIPT_NUM') == record.get('RECEIPT_NUM') && selectRecord.get('RECEIPT_SEQ') == record.get('RECEIPT_SEQ')) {
								deselRecords.push(record);
							}
						}
					});
					sm.deselect(deselRecords);
				}
			}
		}),
		columns:  [
			{dataIndex: 'GUBUN'				, width:80,hidden:true},
			{dataIndex: 'CUSTOM_CODE'		, width:120,hidden:false},
			{dataIndex: 'CUSTOM_NAME'		, width:150,hidden:false},
			{dataIndex: 'INSPEC_DATE'		, width:86,hidden:false},
			{dataIndex: 'ITEM_CODE'			, width:120,hidden:false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.subtotal" default="소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
				}
			},
			{dataIndex: 'ITEM_NAME'			, width:160,hidden:false},
			{dataIndex: 'SPEC'				, width:150,hidden:false},
			{dataIndex: 'INOUT_TYPE_DETAIL' , width:150,hidden:true},
			{dataIndex: 'RECEIPT_Q'			, width:100,hidden:false,summaryType: 'sum'},
			{dataIndex: 'NOR_RECEIPT_Q'		, width:100,hidden:false,summaryType: 'sum'},
			{dataIndex: 'FREE_RECEIPT_Q'	, width:100,hidden:false,summaryType: 'sum'},
			{dataIndex: 'REMAIN_Q'			, width:100,hidden:false,summaryType: 'sum'},
			{dataIndex: 'ORDER_NUM'			, width:100,hidden:true},
			{dataIndex: 'ORDER_SEQ'			, width:80,hidden:true},
			{dataIndex: 'SOF_CUSTOM_NAME'	, width:100,hidden:true},
			{dataIndex: 'SOF_ITEM_NAME'		, width:120,hidden:true},
			{dataIndex: 'ITEM_STATUS'		, width:88,hidden:false},
			{dataIndex: 'DVRY_DATE'			, width:86,hidden:false},
			{dataIndex: 'ORDER_UNIT'		, width:66,hidden:false,align:"center"},
			{dataIndex: 'ORDER_O'			, width:100,hidden:false,summaryType: 'sum'},
			{dataIndex: 'NOINOUT_Q'			, width:100,hidden:false,summaryType: 'sum'},
			{dataIndex: 'UNIT_PRICE_TYPE'	, width:100,hidden:false},
			{dataIndex: 'MONEY_UNIT'		, width:66,hidden:false,align:"center"},
			{dataIndex: 'ORDER_UNIT_P'		, width:100,hidden:false},
			{dataIndex: 'ORDER_LOC_P'		, width:100,hidden:false},
			{dataIndex: 'ORDER_LOC_O'		, width:100,hidden:false,summaryType: 'sum'},
			{dataIndex: 'ORDER_NUM'			, width:120,hidden:false},
			{dataIndex: 'ORDER_SEQ'			, width:80,hidden:false,align:"center"},
			{dataIndex: 'INSPEC_NUM'		, width:120,hidden:false},
			{dataIndex: 'INSPEC_SEQ'		, width:80,hidden:false,align:"center"},
			{dataIndex: 'RECEIPT_NUM'		, width:120,hidden:false},
			{dataIndex: 'RECEIPT_SEQ'		, width:80,hidden:false,align:"center"},
			{dataIndex: 'PORE_Q'			, width:100,hidden:false,summaryType: 'sum'},
			{dataIndex: 'MAKE_LOT_NO'		, width: 100},
			{dataIndex: 'MAKE_DATE'			, width: 100},
			{dataIndex: 'MAKE_EXP_DATE'		, width: 100},
			{dataIndex: 'REMARK'			, width:150,hidden:false},
			{dataIndex: 'LOT_NO'			, width:100,hidden:false},
			{dataIndex: 'LOT_YN'			, width:100,hidden:true},
			{dataIndex: 'EXCHG_RATE_O'		, width:100,hidden:true},
			{dataIndex: 'PROJECT_NO'		, width:100,hidden:true},
			{dataIndex: 'LC_NO'				, width:100,hidden:true},
			{dataIndex: 'BL_NO'				, width:100,hidden:true},
			{dataIndex: 'BASIS_NUM'			, width:120,hidden:true},
			{dataIndex: 'BASIS_SEQ'			, width:66,hidden:true},
			{dataIndex: 'LC_DATE'			, width:86,hidden:true},
			{dataIndex: 'INVOICE_DATE'		, width:86,hidden:true},
			{dataIndex: 'TRADE_LOC'			, width:100,hidden:true},
			{dataIndex: 'ITEM_ACCOUNT'		, width:100,hidden:true},
			{dataIndex: 'LC_NUM'			, width:100,hidden:true},
			{dataIndex: 'WH_CODE'			, width:100,hidden:true},
			{dataIndex: 'ORDER_REQ_NUM'		, width:100,hidden:true},
			{dataIndex: 'DIV_CODE'			, width:100,hidden:true},
			{dataIndex: 'ORDER_TYPE'		, width:100,hidden:true},
			{dataIndex: 'TRNS_RATE'			, width:100,hidden:true},
			{dataIndex: 'STOCK_UNIT'		, width:100,hidden:true},
			{dataIndex: 'ORDER_Q'			, width:100,hidden:true},
			{dataIndex: 'ORDER_UNIT_Q'		, width:100,hidden:true},
			{dataIndex: 'ORDER_P'			, width:100,hidden:true},
			{dataIndex: 'INSTOCK_Q'			, width:100,hidden:true},
			{dataIndex: 'EXCESS_RATE'		, width:100,hidden:true},
			{dataIndex: 'MONEY_UNIT_CUST'	, width:100,hidden:true},
			{dataIndex: 'TRADE_LOC'			, width:100,hidden:true},
			{dataIndex: 'CREATE_LOC'		, width:100,hidden:true},
			{dataIndex: 'BL_NUM'			, width:100,hidden:false},
			{dataIndex: 'WON_CALC_BAS'		, width:100,hidden:true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setInspectData(record.data);
			});
			this.getStore().remove(records);
		}
	});

	function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.receiptnosearch2" default="입고번호검색"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'}, //위치 확인 필요
				items: [inoutNoSearch, inoutNoMasterGrid],
				tbar:  ['->',
					{
						itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							inoutNoMasterStore.loadStoreRecords();
						},
						disabled: false
					}, {
						itemId : 'inoutNoCloseBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						inoutNoSearch.clearForm();
						inoutNoMasterGrid.reset();
					},
					 beforeclose: function( panel, eOpts ) {
						inoutNoSearch.clearForm();
						inoutNoMasterGrid.reset();
					},
					show: function( panel, eOpts ) {
						inoutNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
						inoutNoSearch.setValue('INOUT_DATE_FR',UniDate.get('startOfMonth'));
						inoutNoSearch.setValue('INOUT_DATE_TO',UniDate.get('today'));
						inoutNoSearch.setValue('WH_CODE',panelSearch.getValue('WH_CODE'));
						inoutNoSearch.setValue('INOUT_CODE',panelSearch.getValue('CUSTOM_CODE'));
						inoutNoSearch.setValue('INOUT_NAME',panelSearch.getValue('CUSTOM_NAME'));
						inoutNoSearch.setValue('INOUT_PRSN',panelSearch.getValue('INOUT_PRSN'));
					 }
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}

	function openNoReceiveWindow() {			//미입고참조
		/* if(Ext.isEmpty(panelSearch.getValue('CUSTOM_CODE'))){
			alert('거래처를 선택해주세요.');
			return false;
		} */

		if(!UniAppManager.app.checkForNewDetail()) return false;

//		noreceiveSearch.setValue('FR_ESTI_DATE', UniDate.get('startOfMonth'));
//		noreceiveSearch.setValue('TO_ESTI_DATE', UniDate.get('today'));
		noreceiveSearch.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));

		if(!referNoReceiveWindow) {
			referNoReceiveWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.unreceiptreference" default="미입고참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [noreceiveSearch, noreceiveGrid],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							noReceiveStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'confirmBtn',
						text: '<t:message code="system.label.purchase.receiptapply2" default="입고적용"/>',
						handler: function() {
							//20190917 추가
							//거래처를 선택하지 않고 참조를 할 경우와 아닌 경우 나눠서 처리
							if(Ext.isEmpty(panelSearch.getValue('CUSTOM_CODE'))){
								fn_NoReceive(false);

							}else{
								var records = noreceiveGrid.getSelectedRecords();
								var selCustomCode = records[0].data.CUSTOM_CODE;
								if(panelSearch.getValue('CUSTOM_CODE') != selCustomCode){
									alert('한개의 거래처만 입력할 수 있습니다.');
									return false;
								}
								noreceiveGrid.returnData();
							}
						},
						disabled: false
					},{
						itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.purchase.receiptapplyclose" default="입고적용후 닫기"/>',
						handler: function() {
							//20190917 추가
							//거래처를 선택하지 않고 참조를 할 경우와 아닌 경우 나눠서 처리
							if(Ext.isEmpty(panelSearch.getValue('CUSTOM_CODE'))){
								fn_NoReceive(true);
							}else{
								var records = noreceiveGrid.getSelectedRecords();
								var selCustomCode = records[0].data.CUSTOM_CODE;
								if(panelSearch.getValue('CUSTOM_CODE') != selCustomCode){
									alert('한개의 거래처만 입력할 수 있습니다.');
									return false;
								}
								noreceiveGrid.returnData();
								referNoReceiveWindow.hide();
							}
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							if(directMasterStore1.getCount() == 0){
								panelSearch.setAllFieldsReadOnly(false);
								panelResult2.setAllFieldsReadOnly(false);
							}
							referNoReceiveWindow.hide();
							panelResult.setValue('BlSumInoutO', gsOriValue);
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						noreceiveSearch.clearForm();
						noreceiveGrid.reset();
						noReceiveStore.clearData();
					},
					beforeclose: function( panel, eOpts ) {
						noreceiveSearch.clearForm();
						noreceiveGrid.reset();
						noReceiveStore.clearData();
					},
					beforeshow: function ( me, eOpts ){
						gsOriValue = panelResult.getValue('BlSumInoutO');
						noreceiveSearch.setValue('FR_ESTI_DATE',UniDate.get('startOfMonth'));
						noreceiveSearch.setValue('TO_ESTI_DATE',UniDate.get('today'));
						//noreceiveSearch.setValue('ORDER_TYPE', '1');
						noreceiveSearch.setValue('WH_CODE',panelSearch.getValue('WH_CODE'));
						noreceiveSearch.setValue('INOUT_PRSN',panelSearch.getValue('INOUT_PRSN'));
						noreceiveSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
						noreceiveSearch.setValue('CREATE_LOC',panelSearch.getValue('CREATE_LOC').CREATE_LOC);
						noreceiveSearch.setValue('CUSTOM_CODE',panelSearch.getValue('CUSTOM_CODE'));
						noreceiveSearch.setValue('CUSTOM_NAME',panelSearch.getValue('CUSTOM_NAME'));
						//noreceiveSearch.setValue('MONEY_UNIT',panelSearch.getValue('MONEY_UNIT'));
						if(panelSearch.getValue('CREATE_LOC').CREATE_LOC == '6'){
							noreceiveSearch.getField('ITEM_CODE').setReadOnly(true);
							noreceiveSearch.getField('ITEM_NAME').setReadOnly(true);
						}else{
							noreceiveSearch.getField('ITEM_CODE').setReadOnly(false);
							noreceiveSearch.getField('ITEM_NAME').setReadOnly(false);
						}
						noReceiveStore.loadStoreRecords();
					}
				}
			})
		}
		referNoReceiveWindow.center();
		referNoReceiveWindow.show();
	}

	function openReturnPossibleWindow() {		//반품가능발주참조
		if(Ext.isEmpty(panelSearch.getValue('CUSTOM_CODE'))){
			alert('거래처를 선택해주세요.');
			return false;
		}
		if(!UniAppManager.app.checkForNewDetail()) return false;

		if(!referReturnPossibleWindow) {
			referReturnPossibleWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.returnavaiableporefer" default="반품가능발주참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [returnpossibleSearch, returnpossibleGrid],
				tbar:  ['->',
					{
						itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							returnPossibleStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'confirmBtn',
						text: '<t:message code="system.label.purchase.receiptapply2" default="입고적용"/>',
						handler: function() {
							returnpossibleGrid.returnData();
						},
						disabled: false
					},{
						itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.purchase.receiptapplyclose" default="입고적용후 닫기"/>',
						handler: function() {
							returnpossibleGrid.returnData();
							referReturnPossibleWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							if(directMasterStore1.getCount() == 0){
								panelSearch.setAllFieldsReadOnly(false);
								panelResult2.setAllFieldsReadOnly(false);
							}
							referReturnPossibleWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						returnpossibleGrid.reset();
						returnPossibleStore.clearData();
					},
					beforeclose: function( panel, eOpts ) {
						returnpossibleGrid.reset();
						returnPossibleStore.clearData();
					},
					beforeshow: function ( me, eOpts ) {
						returnpossibleSearch.setValue('FR_ESTI_DATE',UniDate.get('startOfMonth'));
						returnpossibleSearch.setValue('TO_ESTI_DATE',UniDate.get('today'));
						returnpossibleSearch.setValue('INOUT_PRSN', panelSearch.getValue('INOUT_PRSN'));		//20200729 수정: DIV_CODE -> INOUT_PRSN
						returnpossibleSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
						returnpossibleSearch.setValue('CREATE_LOC',panelSearch.getValue('CREATE_LOC').CREATE_LOC);
						returnpossibleSearch.setValue('CUSTOM_CODE',panelSearch.getValue('CUSTOM_CODE'));
						returnpossibleSearch.setValue('CUSTOM_NAME',panelSearch.getValue('CUSTOM_NAME'));
						returnPossibleStore.loadStoreRecords();
					}
				}
			})
		}
		referReturnPossibleWindow.center();
		referReturnPossibleWindow.show();
	}

/*	function opeScmRefWindow() {				//업체출고 참조(SCM)
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!referScmRefWindow) {
			referScmRefWindow = Ext.create('widget.uniDetailWindow', {
				title: '업체출고 참조(SCM)',
				width: 1000,
				height: 540,
				layout:{type:'vbox', align:'stretch'},

				items: [scmRefSearch,scmRefGrid],
				tbar:  [
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							scmRefStore.loadStoreRecords();
						},
						disabled: false
					}
					,{
						itemId : 'confirmBtn',
						text: '입고적용',
						handler: function() {
							scmRefGrid.returnData();
						},
						disabled: false
					},
					{
						itemId : 'confirmCloseBtn',
						text: '입고적용 후 닫기',
						handler: function() {
							scmRefGrid.returnData();
							referInspectResultWindow.hide();
						},
						disabled: false
					},'->',{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							referScmRefWindow.hide();
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
						scmRefSearch.setValue('FR_INOUT_DATE',UniDate.get('startOfMonth'), panelSearch.getValue("INOUT_DATE"));
						scmRefSearch.setValue('TO_INOUT_DATE',panelSearch.getValue("INOUT_DATE"));
						scmRefSearch.setValue('ORDER_TYPE', '1');
						scmRefSearch.setValue('WH_CODE',panelSearch.getValue('WH_CODE'));
						scmRefSearch.setValue('CREATE_LOC',panelSearch.getValue('CREATE_LOC').CREATE_LOC);
						scmRefStore.loadStoreRecords();
					}
				}
			})
		}
		referScmRefWindow.center();
		referScmRefWindow.show();
	}*/

	function openInspectResultWindow() {		//검사결과참조(무검사겸용)
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!referInspectResultWindow) {
			referInspectResultWindow = Ext.create('widget.uniDetailWindow', {
				title: windowFlag == 'inspectResult' ?  '<t:message code="system.label.purchase.inspecresultrefer" default="검사결과참조"/>' : '<t:message code="system.label.purchase.noinspecreference" default="무검사참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [inspectresultSearch,inspectresultGrid2],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							inspectResultStore2.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'confirmBtn',
						text: '<t:message code="system.label.purchase.receiptapply2" default="입고적용"/>',
						handler: function() {
							//20190917 추가
							//거래처를 선택하지 않고 참조를 할 경우와 아닌 경우 나눠서 처리
							if(Ext.isEmpty(panelSearch.getValue('CUSTOM_CODE'))){
								fn_InspectData(false);
							}else{
								var records = inspectresultGrid2.getSelectedRecords();
								var selCustomCode = records[0].data.CUSTOM_CODE;
								if(panelSearch.getValue('CUSTOM_CODE') != selCustomCode){
									alert('한개의 거래처만 입력할 수 있습니다.');
									return false;
								}
								inspectresultGrid2.returnData();
							}
						},
						disabled: false
					},{
						itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.purchase.receiptapplyclose" default="입고적용후 닫기"/>',
						handler: function() {
							//20190917 추가
							//거래처를 선택하지 않고 참조를 할 경우와 아닌 경우 나눠서 처리
							if(Ext.isEmpty(panelSearch.getValue('CUSTOM_CODE'))){
								fn_InspectData(true);
							}else{
								var records = inspectresultGrid2.getSelectedRecords();
								var selCustomCode = records[0].data.CUSTOM_CODE;
								if(panelSearch.getValue('CUSTOM_CODE') != selCustomCode){
									alert('한개의 거래처만 입력할 수 있습니다.');
									return false;
								}
								inspectresultGrid2.returnData();
								referInspectResultWindow.hide();
							}
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							if(directMasterStore1.getCount() == 0){
								panelSearch.setAllFieldsReadOnly(false);
								panelResult2.setAllFieldsReadOnly(false);
							}
							panelResult.setValue('BlSumInoutO', gsOriValue);
							referInspectResultWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						inspectresultSearch.clearForm();
						inspectresultGrid2.reset();
						inspectResultStore2.clearData();
					},
					beforeclose: function( panel, eOpts ) {
						inspectresultSearch.clearForm();
						inspectresultGrid2.reset();
						inspectResultStore2.clearData();
						windowFlag = '';
					},
					beforeshow: function ( me, eOpts ) {
						gsOriValue = panelResult.getValue('BlSumInoutO');
						inspectresultSearch.down('#dvryDate').setConfig('fieldLabel',windowFlag == 'inspectResult' ?  '<t:message code="system.label.purchase.inspecdate" default="검사일"/>' : '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>');

						inspectresultSearch.setValue('FR_DVRY_DATE',UniDate.get('startOfMonth'));
						inspectresultSearch.setValue('TO_DVRY_DATE',UniDate.get('today'));
						inspectresultSearch.setValue('CREATE_LOC',panelSearch.getValue('CREATE_LOC').CREATE_LOC);

						//20191126 추가: 팝업에 따른 컬럼명 변경로직
						inspectresultGrid2.getColumn('INSPEC_DATE').setText(windowFlag == 'inspectResult' ?  '<t:message code="system.label.purchase.inspecdate" default="검사일"/>' : '<t:message code="system.label.purchase.temporaryreceiptdate" default="가입고일"/>');
						inspectresultGrid2.getColumn('REMAIN_Q').setText(windowFlag == 'inspectResult' ?  '<t:message code="system.label.purchase.inspecqty" default="검사량"/>' : '<t:message code="system.label.purchase.temporarystock" default="가입고량"/>');
						inspectResultStore2.loadStoreRecords();
					}
				}
			})
		}
		referInspectResultWindow.center();
		referInspectResultWindow.show();
	}

	function fn_NoReceive(closeYn){
		var records = noreceiveGrid.getSelectedRecords();
		panelSearch.setValue('CUSTOM_CODE', records[0].data.CUSTOM_CODE);
		panelSearch.setValue('CUSTOM_NAME', records[0].data.CUSTOM_NAME);
		panelResult2.setValue('CUSTOM_CODE', records[0].data.CUSTOM_CODE);
		panelResult2.setValue('CUSTOM_NAME', records[0].data.CUSTOM_NAME);
		panelSearch.setValue('MONEY_UNIT', records[0].data.MONEY_UNIT);
		panelResult2.setValue('MONEY_UNIT', records[0].data.MONEY_UNIT);
		var isIni = false;
		var param = {
			"AC_DATE"	: UniDate.getDbDateStr(panelSearch.getValue('INOUT_DATE')),
			"MONEY_UNIT" : panelSearch.getValue('MONEY_UNIT')
		};
		salesCommonService.fnExchgRateO(param, function(provider, response) {
			if(!Ext.isEmpty(provider)){
				if(provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(panelSearch.getValue('MONEY_UNIT')) && panelSearch.getValue('MONEY_UNIT') != "KRW"){
					alert('<t:message code="system.message.purchase.datacheck002" default="환율정보가 없습니다."/>')
				}
				panelSearch.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
				panelResult2.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
				noreceiveGrid.returnData();
				if(closeYn){
					referNoReceiveWindow.hide();
				}
			}else{
				noreceiveGrid.returnData();
				if(closeYn){
					referNoReceiveWindow.hide();
				}
			}
		});
	}

	function fn_InspectData(closeYn){
		var records = inspectresultGrid2.getSelectedRecords();
		panelSearch.setValue('CUSTOM_CODE', records[0].data.CUSTOM_CODE);
		panelSearch.setValue('CUSTOM_NAME', records[0].data.CUSTOM_NAME);
		panelResult2.setValue('CUSTOM_CODE', records[0].data.CUSTOM_CODE);
		panelResult2.setValue('CUSTOM_NAME', records[0].data.CUSTOM_NAME);
		panelSearch.setValue('MONEY_UNIT', records[0].data.MONEY_UNIT);
		panelResult2.setValue('MONEY_UNIT', records[0].data.MONEY_UNIT);

		var isIni = false;
		var param = {
			"AC_DATE"		 : UniDate.getDbDateStr(panelSearch.getValue('INOUT_DATE')),
			"MONEY_UNIT"  : panelSearch.getValue('MONEY_UNIT')
		};
		salesCommonService.fnExchgRateO(param, function(provider, response) {
			if(!Ext.isEmpty(provider)){
				if(provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(panelSearch.getValue('MONEY_UNIT')) && panelSearch.getValue('MONEY_UNIT') != "KRW"){
					alert('<t:message code="system.message.purchase.datacheck002" default="환율정보가 없습니다."/>')
				}
				panelSearch.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
				panelResult2.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
				inspectresultGrid2.returnData();
				if(closeYn){
					referInspectResultWindow.hide();
				}
			}else{
				inspectresultGrid2.returnData();
				if(closeYn){
					referInspectResultWindow.hide();
				}
			}
		});
	}


	/***************************
	 *라벨 출력 코드
	 *2019-11-29
	 ***************************/
	//라벨분할출력 폼
	var labelPrintSearch = Unilite.createSearchForm('labelPrintForm', {
		//layout		: {type:'vbox', align:'center', pack: 'center' },
		layout	: {type : 'uniTable', columns : 1},
		border:true,
		items	: [{	fieldLabel	: '<t:message code="system.label.purchase.oemitemcode" default="품번"/>',
						name		: 'LABEL_ITEM_CODE',
						xtype		: 'uniTextfield',
						margin 	: '0 0 0 0',
						hidden		: false,
						readOnly	: true,
						fieldStyle: 'text-align: center;',
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
							}
						}
					},{
			 			fieldLabel	: '<t:message code="system.label.purchase.printqty" default="출력매수"/>',
			 			xtype		: 'uniNumberfield',
			 			name		: 'LABEL_QTY',
			 			margin 	: '0 0 0 0',
			 			value		: 1,
			 			allowBlank	: true,
			 			hidden	: false,
			 			fieldStyle: 'text-align: center;'
			 			//holdable	: 'hold'
 					},{
				  	fieldLabel: '입고일',
							xtype: 'uniDatefield',
							name: 'INOUT_DATE',
							value:UniDate.get('today'),
				//			fieldStyle: 'text-align: center;background-color: yellow; background-image: none;',
							readOnly : false,
							allowBlank:false
					},{
				  	fieldLabel: 'INOUT_NUM',
						xtype: 'uniTextfield',
						name: 'INOUT_NUM',
						hidden: true,
						readOnly : false,
						allowBlank:false
					},{
				  	fieldLabel: 'INOUT_SEQ',
						xtype: 'uniNumberfield',
						name: 'INOUT_SEQ',
						hidden: true,
						readOnly : false,
						allowBlank:false
					},{
			 			fieldLabel	: '<t:message code="system.label.product.qty" default="수량"/>',
			 			xtype		: 'uniNumberfield',
			 			name		: 'INOUT_QTY',
			 			value		: 1,
			 			allowBlank	: true,
			 			hidden	: false,
			 			fieldStyle: 'text-align: center;'
			 			//holdable	: 'hold'
 					},{	xtype		: 'container',
						defaultType	: 'uniTextfield',
						margin		: '0 0 0 60',
						layout		: {type : 'uniTable', columns : 2,align:'center', pack: 'center'},
						items		: [{	xtype	: 'button',
											name	: 'labelPrint',
											text	: '<t:message code="system.label.product.labelprint" default="라벨출력"/>',
											width	: 80,
											hidden	: false,
											handler : function() {

												var selectedDetailRecords = masterGrid.getSelectedRecords();
													/*	if(Ext.isEmpty(selectedRecords)){
															  alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
															  return;
														  } */
												  var param = panelResult2.getValues();
												  param["INOUT_NUM"]= labelPrintSearch.getValue('INOUT_NUM');
												  param["INOUT_SEQ"]= labelPrintSearch.getValue('INOUT_SEQ');
												  param["PRINT_CNT"]= labelPrintSearch.getValue('LABEL_QTY');
												  param["INOUT_QTY"]= labelPrintSearch.getValue('INOUT_QTY');
												  param["INOUT_DATE"]= UniDate.getDbDateStr(labelPrintSearch.getValue('INOUT_DATE'));

												  param["sTxtValue2_fileTitle"]='라벨 출력';
												  param["RPT_ID"]='mms510clukrv';
												  param["PGM_ID"]='mms512ukrv';
												  param["MAIN_CODE"]='M030';
												  if(BsaCodeInfo.gsSiteCode == 'SHIN'){
													  param["GUBUN"]='SHIN';
												  }else{
													  param["GUBUN"]='STANDARD';
												  }
												  var win  = Ext.create('widget.ClipReport', {
															url: CPATH+'/matrl/mms510clukrv_label.do',
															prgID: 'mms512ukrv',
															extParam: param
														});
													win.center();
													win.show();
											}
										},{
											xtype	: 'button',
											name	: 'btnCancel',
											text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
											width	: 80,
											hidden	: false,
											handler	: function() {
												labelPrintSearch.clearForm();
												labelPrintWindow.hide();
											}
							 }]
			}]
	});

	function openLabelPrintWindow() {
		//if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!labelPrintWindow) {
			labelPrintWindow = Ext.create('widget.uniDetailWindow', {
				title		: '<t:message code="system.label.purchase.label" default="라벨"/><t:message code="system.label.purchase.print" default="출력"/>',
				width		: 300,
				height		: 175,
				//resizable	: false,
				layout		:{type:'vbox', align:'stretch'},
				items		: [labelPrintSearch],
				listeners	: {
					beforehide	: function(me, eOpt) {
						labelPrintSearch.clearForm();
					},
					beforeclose: function( panel, eOpts ) {

					},
					beforeshow: function ( me, eOpts ) {
						var selectedDetailRecord = masterGrid.getSelectedRecord();
						labelPrintSearch.setValue('LABEL_ITEM_CODE', selectedDetailRecord.get('ITEM_CODE'));
						labelPrintSearch.setValue('LABEL_QTY', 1);
						labelPrintSearch.setValue('INOUT_QTY', selectedDetailRecord.get('INOUT_Q'));
						labelPrintSearch.setValue('INOUT_NUM', selectedDetailRecord.get('INOUT_NUM'));
						labelPrintSearch.setValue('INOUT_SEQ', selectedDetailRecord.get('INOUT_SEQ'));
					},
					show: function(me, eOpts) {

					}
				}
			})
		}
		labelPrintWindow.center();
		labelPrintWindow.show();
	}


	Unilite.Main({
		id			: 'mms512ukrvApp',
		borderItems	: [{
			region:'center',
			layout: 'border',
			border: false,
			items:[{
					region : 'center',
					xtype : 'container',
					layout : 'fit',
					items : [ masterGrid ]
				},
				panelResult2,
				{
					region : 'north',
					xtype : 'container',
					highth: 20,
					layout : 'fit',
					items : [ panelResult ]
				}
			]
		},
			panelSearch
		],
		fnInitBinding: function(){
			if(BsaCodeInfo.gsQ008Sub == 'Y'){ //무검사참조
				masterGrid.down('#noreceiveBtn').setHidden(true);
				masterGrid.down('#inspectnoBtn').setHidden(false);
			}else{	//미입고참조
				masterGrid.down('#noreceiveBtn').setHidden(false);
				masterGrid.down('#inspectnoBtn').setHidden(true);
			}
			UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);
			this.setDefault();
			cbStore.loadStoreRecords();
		},
		onQueryButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			gsBlSum = 0;
			var inoutNo = panelSearch.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow()
			} else {
				directMasterStore1.loadStoreRecords();
			}
		},
		onNewDataButtonDown: function() {
			if(Ext.isEmpty(panelSearch.getValue('CUSTOM_CODE'))) {
				alert('<t:message code="system.message.purchase.message059" default="거래처를 선택해 주세요."/>');
				return false;
			}
			if(!this.checkForNewDetail()) return false;
				 var accountYnc		= 'Y';
				 var inoutNum		= panelSearch.getValue('INOUT_NUM');
				 var seq			= !directMasterStore1.max('INOUT_SEQ')?1:directMasterStore1.max('INOUT_SEQ')+1
				 var inoutType		= '1';
				 var inoutCodeType	= '4';
				 var whCode			= panelSearch.getValue('WH_CODE');
				 var whCellCode		= panelSearch.getValue('WH_CELL_CODE');
				 var inoutPrsn		= panelSearch.getValue('INOUT_PRSN');
				 var inoutCode		= panelSearch.getValue('CUSTOM_CODE');
				 var customName		= panelSearch.getValue('CUSTOM_NAME');
				 var createLoc		= panelSearch.getValue('CREATE_LOC').CREATE_LOC;
				 var inoutDate		= panelSearch.getValue('INOUT_DATE');
				 var inoutMeth		= '2';
				 var inoutTypeDetail= '99'; //gsInoutTypeDetail ?? 확인필요
				 var itemStatus		= '1';
				 var accountQ		= '0';
				 var orderUnitQ		= '0';
				 var inoutQ			= '0';
				 var inoutI			= '0';
				 var moneyUnit		= panelSearch.getValue('MONEY_UNIT');
				 var inoutP			= '0';
				 var inoutForP		= '0';
				 var inoutForO		= '0';
				 var originalQ		= '0';
				 var noinoutQ		= '0';
				 var goodStockQ		= '0';
				 var badStockQ		= '0';
				 var exchgRateO		= panelSearch.getValue('EXCHG_RATE_O');
				 var trnsRate		= '1';
				 var divCode		= panelSearch.getValue('DIV_CODE');
				 var companyNum		= BsaCodeInfo.gsCompanyNum; // ??확인필요
				 var saleDivCode	= '*';
				 var saleCustomCode	= '*';
				 var saleType		= '*';
				 var billType		= '*';
				 var priceYn		= 'Y';
				 var excessRate		= '0';
				 var orderType		= '1';
				 var transCost		= '0';
				 var tariffAmt		= '0';
				 var deptCode		= panelSearch.getValue('DEPT_CODE');

				if(BsaCodeInfo.gsGwYn == 'Y') {
					 var r = {
						ACCOUNT_YNC:		accountYnc,
						INOUT_TYPE:			inoutType,
						INOUT_CODE_TYPE:	inoutCodeType,
						WH_CODE:			whCode,
						WH_CELL_CODE:		whCellCode,
						INOUT_PRSN:			inoutPrsn,
						INOUT_CODE:			inoutCode,
						CUSTOM_NAME:		customName,
						CREATE_LOC:			createLoc,
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
						ORIGINAL_Q:			originalQ,
						NOINOUT_Q:			noinoutQ,
						GOOD_STOCK_Q:		goodStockQ,
						BAD_STOCK_Q:		badStockQ,
						EXCHG_RATE_O:		exchgRateO,
						TRNS_RATE:			trnsRate,
						DIV_CODE:			divCode,
						COMPANY_NUM:		companyNum,
						SALE_DIV_CODE:		saleDivCode,
						SALE_CUSTOM_CODE:	saleCustomCode,
						SALE_TYPE:			saleType,
						BILL_TYPE:			billType,
						PRICE_YN:			priceYn,
						EXCESS_RATE:		excessRate,
						ORDER_TYPE:			orderType,
						TRANS_COST:			transCost,
						TARIFF_AMT:			tariffAmt,
						INOUT_NUM:			inoutNum,
						INOUT_SEQ:			seq,
						DEPT_CODE:			deptCode,
						SALES_TYPE:			0
	//					PURCHASE_TYPE:		0,
	//					PURCHASE_RATE:		0
					}
				} else {
					 var r = {
						ACCOUNT_YNC:		accountYnc,
						INOUT_TYPE:			inoutType,
						INOUT_CODE_TYPE:	inoutCodeType,
						WH_CODE:			whCode,
						WH_CELL_CODE:		whCellCode,
						INOUT_PRSN:			inoutPrsn,
						INOUT_CODE:			inoutCode,
						CUSTOM_NAME:		customName,
						CREATE_LOC:			createLoc,
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
						ORIGINAL_Q:			originalQ,
						NOINOUT_Q:			noinoutQ,
						GOOD_STOCK_Q:		goodStockQ,
						BAD_STOCK_Q:		badStockQ,
						EXCHG_RATE_O:		exchgRateO,
						TRNS_RATE:			trnsRate,
						DIV_CODE:			divCode,
						COMPANY_NUM:		companyNum,
						SALE_DIV_CODE:		saleDivCode,
						SALE_CUSTOM_CODE:	saleCustomCode,
						SALE_TYPE:			saleType,
						BILL_TYPE:			billType,
						PRICE_YN:			priceYn,
						EXCESS_RATE:		excessRate,
						ORDER_TYPE:			orderType,
						TRANS_COST:			transCost,
						TARIFF_AMT:			tariffAmt,
						INOUT_NUM:			inoutNum,
						INOUT_SEQ:			seq,
						DEPT_CODE:			deptCode,
						SALES_TYPE:			0
	//					PURCHASE_TYPE:		0,
	//					PURCHASE_RATE:		0
					}
				}
				cbStore.loadStoreRecords(whCode);
				masterGrid.createRow(r);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult2.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult2.clearForm();
			panelResult.clearForm();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			gsBlSum = 0;
//			debugger;
//			if(UniAppManager.app.updateChanges()){
				directMasterStore1.saveStore();
//			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				masterGrid.deleteSelectedRow();

			}else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('ACCOUNT_Q') != 0){
					alert('<t:message code="system.message.purchase.message042" default="매입등록된 자료는 삭제, 수정할 수 없습니다."/>');
				}else{
					masterGrid.deleteSelectedRow();
				}
			}
			//20200609 추가
			directMasterStore1.fnSumBlAmountI();
			directMasterStore1.fnSumAmountI();
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore1.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('<t:message code="system.message.purchase.message008" default="전체삭제 하시겠습니까?"/>')) {
						if(record.get('ACCOUNT_Q') != 0){
							alert('<t:message code="system.message.purchase.message042" default="매입등록된 자료는 삭제, 수정할 수 없습니다."/>');
						}else{
							var deletable = true;
							if(deletable){
								masterGrid.reset();
								UniAppManager.app.onSaveDataButtonDown();
							}
							isNewData = false;
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelSearch.getValue('INOUT_NUM'))) {
				alert('<t:message code="unilite.msg.sMS514" default="입고번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}
			if(panelSearch.setAllFieldsReadOnly(true)){
				panelResult2.setAllFieldsReadOnly(true);
				return true;
			}
			return false;
		},
		setDefault: function() {
			gsBlSum = 0;
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult2.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('INOUT_DATE',new Date());
			panelResult2.setValue('INOUT_DATE',new Date());
			//20191126 콤보에서 라디오로 변경
//			panelResult2.setValue('CREATE_LOC','2');
//			panelSearch.setValue('CREATE_LOC','2');
			panelResult2.getField('CREATE_LOC').setValue('2');
			panelSearch.getField('CREATE_LOC').setValue('2');
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
			var field = panelSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult2.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = inoutNoSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = noreceiveSearch.getField('ORDER_PRSN');					//20200729 수정: INOUT_PRSN -> ORDER_PRSN
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
//			panelSearch.setValue('INOUT_PRSN',BsaCodeInfo.gsInOutPrsn);
//			panelResult2.setValue('INOUT_PRSN',BsaCodeInfo.gsInOutPrsn);
			UniAppManager.app.fnExchngRateO(true);
		},
		fnInTypeAccountYN:function(subCode){
			var fRecord ='';
			Ext.each(BsaCodeInfo.gsInTypeAccountYN, function(item, i) {
				if(item['codeNo'] == subCode && !Ext.isEmpty(item['refCode4'])) {
					fRecord = item['refCode4'];
				}
			});
			if(Ext.isEmpty(fRecord)){
				fRecord = 'N'
			}
			return fRecord;
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelSearch.getValue('INOUT_DATE')),
				"MONEY_UNIT" : panelSearch.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(panelSearch.getValue('MONEY_UNIT')) && panelSearch.getValue('MONEY_UNIT') != "KRW"){
						alert('<t:message code="system.message.purchase.datacheck002" default="환율정보가 없습니다."/>')
					}
					panelSearch.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
					panelResult2.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
				}

			});
		},
		fnExchngRateO2:function(isIni, records) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelSearch.getValue('INOUT_DATE')),
				"MONEY_UNIT" : panelSearch.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(panelSearch.getValue('MONEY_UNIT')) && panelSearch.getValue('MONEY_UNIT') != "KRW"){
						alert('<t:message code="system.message.purchase.datacheck002" default="환율정보가 없습니다."/>')
					}
					panelSearch.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
					panelResult2.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
					records.set('EXCHG_RATE_O', provider.BASE_EXCHG);
				}

			});
		},
		cbStockQ: function(provider, params) {
			var rtnRecord = params.rtnRecord;
			var dStockQ = provider['STOCK_Q'];
			var dGoodStockQ = provider['GOOD_STOCK_Q'];
			var dBadStockQ = provider['BAD_STOCK_Q'];
			rtnRecord.set('STOCK_Q', dStockQ);
			rtnRecord.set('GOOD_STOCK_Q', dGoodStockQ);
			rtnRecord.set('BAD_STOCK_Q', dBadStockQ);
		},
		updateChanges:function(){
//			var saveRecs = directMasterStore1.data.items;
//			var toSave = true;
//			Ext.each(saveRecs, function(saveRec,i) {
//				if(saveRec.get("ORDER_UNIT_Q") == '0' && saveRec.get("INOUT_TYPE_DETAIL") != '91'){
//					alert('<t:message code = "unilite.msg.sMM350"/>');
//					toSave = false
//				}
//				if(!UniAppManager.app.isQtyCheck(saveRec)){
//					toSave = false
//				}
//				if(saveRec.get("INOUT_Q") == '0' && saveRec.get("INOUT_TYPE_DETAIL") != '91'){
//					alert('<t:message code = "unilite.msg.sMM350"/>');
//					toSave = false
//				}
//				if(saveRec.get("ACCOUNT_YNC") == 'Y' && saveRec.get("INOUT_TYPE_DETAIL") != '91' && saveRec.get("PRICE_YN") == 'Y'){
//					if(saveRec.get("ORDER_UNIT_FOR_P") == '0'){
//						alert('<t:message code = "unilite.msg.sMM375"/>');
//						toSave = false
//					}
//				}
//			});
//			return toSave;
		},
		isQtyCheck:function(record){
			var dInoutQ,dOriginalQ,dOrderQ,dNoInoutQ,dEnableQ,dStockQ
			var isQtycheck = false;
			if(record.get("INOUT_Q") == '0' && record.get("INOUT_TYPE_DETAIL") != '91'){
				alert('<t:message code="system.message.purchase.message074" default="입고량을 입력 하십시오."/>');
				return false;
			}
			var recordSts = "N";
			if(record.phantom !== true){
				if(record.dirty === true){
					recordSts = "U"
				}else{
					recordSts = "D"
				}
			}

			if(BsaCodeInfo.gsInvstatus == '+'){
				if(record.get("STOCK_CARE_YN") == 'Y'){
					if((record.get("INOUT_Q") < 0 && recordSts == "D")
					|| (record.get("INOUT_Q") < record.get("ORIGINAL_Q")) && recordSts == "U"){
						dInoutQ = 0
						dOriginalQ = 0;
						var findRecs = directMasterStore1.findBy(function(rec,id){
							 return rec['ITEM_CODE'] == record['ITEM_CODE'];
						});
						if(findRecs.length > 0){
							Ext.each(findRecs, function(findRec,i) {
								if(findRec.phantom === true || findRec.dirty === true){
									if(findRec.get("INOUT_Q") != ""){
										dOriginalQ = dOriginalQ + findRec.get("ORIGINAL_Q")
									}
								}
							});
						}
					}
					if(recordSts == "N" || recordSts == "U"){
						dInoutQ = dInoutQ + record.get("INOUT_Q")
						dOriginalQ = dOriginalQ + record.get("ORIGINAL_Q")
					}else{
						dOriginalQ = dOriginalQ + record.get("ORIGINAL_Q")
					}
					if(record.get("ITEM_STATUS") == "1"){
						dStockQ = record.get("GOOD_STOCK_Q")
					}else{
						dStockQ = record.get("BAD_STOCK_Q")
					}
					if((dStockQ - dOriginalQ) < dInoutQ * (-1)){
						alert('<t:message code="system.message.purchase.message069" default="(-) 입고 수량은 재고량을 초과할 수 없습니다."/>'+" : " + (dStockQ - dOriginalQ));
						return false;
					}
				}
			}
			return true;
		}
	});

	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			switch(fieldName) {
				case "MAKE_DATE" :
					if(!Ext.isEmpty(record.get('ITEM_CODE'))){
						if(!Ext.isEmpty(newValue)){
							var params = {
								'ITEM_CODE' : record.get('ITEM_CODE')
							};
							mms512ukrvService.selectExpirationdate(params, function(provider, response) {
								if(!Ext.isEmpty(provider) && provider.EXPIRATION_DAY != 0) {
									record.set('MAKE_EXP_DATE',UniDate.getDbDateStr(UniDate.add(newValue, {months: + provider.EXPIRATION_DAY , days:-1})));
								}else{
									//alert('유효기간을 설정하지 않은 품목입니다. 유효기간을 설정해주세요.');
									record.set('MAKE_EXP_DATE', '');
								}
							});
						}
					}else{
						rv ='작업지시를 할 품목을 입력해주세요.';
						break;
					}
					break;
				case "INOUT_SEQ" :
					if(newValue != ''){
						if(!isNaN(newValue)){
							rv='<t:message code="system.message.purchase.message075" default="숫자만 입력가능합니다."/>';
							break;
						}
						if(newValue <= 0){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						}
					}
					break;
				case "ITEM_CODE" :
					if(record.get('ACCOUNT_YNC') == 'N' && record.get('INOUT_TYPE_DETAIL') != '20' ){
						record.set('PRICE_YN','N');
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');

						directMasterStore1.fnSumAmountI();
					}
					break;
				case "ITEM_NAME" :
					if(record.get('ACCOUNT_YNC') == 'N' && record.get('INOUT_TYPE_DETAIL') != '20'){
						record.set('PRICE_YN','N');
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');

						directMasterStore1.fnSumAmountI();
					}
					break;
				case "WH_CODE" :
					if(!Ext.isEmpty(newValue)){
						record.set('WH_CELL_CODE', "");
						record.set('WH_CELL_NAME', "");
						record.set('LOT_NO', "");
					}else{
						record.set('WH_CODE', "");
						record.set('WH_CELL_CODE', "");
						record.set('WH_CELL_NAME', "");
						record.set('LOT_NO', "");
					}
					//그리드 창고cell콤보 reLoad..
					cbStore.loadStoreRecords(newValue);
					break;
				case "ORDER_UNIT_Q" :  //입고수량(구매단위)
					if(newValue != oldValue){
						if(record.get('ITEM_CODE') == ''){
							rv='<t:message code="system.message.purchase.message028" default="품목코드를 입력 하십시오."/>';
							break;
						}
					}

					var dInoutQ3	= newValue * record.get('TRNS_RATE');
					var moneyUnit	= panelSearch.getValue('MONEY_UNIT');
					if(!(newValue < '0')){
						if(record.get('ORDER_NUM') != ''){
							//var dTempQ =0;
							var dOrderQ = record.get('ORDER_Q');	//발주량
							var dInoutQ = newValue * record.get('TRNS_RATE');	//입력한 입고량  * 입수
							var dNoInoutQ =  record.get('NOINOUT_Q');	//미입고량

							var dEnableQ = (dOrderQ + dOrderQ * record.get('EXCESS_RATE') / 100) / record.get('TRNS_RATE');
											//(발주량 + 발주량 * 과입고허용률 / 100) / 입수
							var dTempQ = ((dOrderQ - dNoInoutQ + dInoutQ - record.get('ORIGINAL_Q')) / record.get('TRNS_RATE'));
											// ( 발주량 - 미입고량 + (입력한 입고량*입수) - 기존입고량	) / 입수
							if(dNoInoutQ > 0){
								if(dTempQ > dEnableQ){
									 dEnableQ = (dNoInoutQ + record.get('ORIGINAL_Q')) / record.get('TRNS_RATE') + (dEnableQ - (dOrderQ / record.get('TRNS_RATE')));
									//	(미입고량 + 기존입고량) / 입수 + (1100 - 발주량 /입수 )
									rv='<t:message code="system.message.purchase.message030" default="입고량은 발주량에 과입고허용률을 적용한 입고가능량보다 클 수 없습니다."/>' + '<t:message code="system.label.purchase.receiptavailbleqty" default="입고가능수량"/>' + ":" + dEnableQ;
									break;
								}
							}
						}
					}

					record.set('INOUT_Q',dInoutQ3);

					if(BsaCodeInfo.gsInvstatus == '+'){
						if(record.get('STOCK_CARE_YN') == 'Y'){
							if(newValue < 0){
								var dInoutQ1 = 0;
								var dOriginalQ = 0;

								dInoutQ1 = dInoutQ1 + newValue;
								dOriginalQ = dOriginalQ + record.get('ORIGINAL_Q');

								if(record.get('ITEM_STATUS') == '1'){
									dStockQ = record.get('GOOD_STOCK_Q');
								}else{
									dStockQ = record.get('BAD_STOCK_Q');
								}

								if((dStockQ - dOriginalQ) < dInoutQ1 * -1){
									rv='<t:message code="system.message.purchase.message069" default="(-) 입고 수량은 재고량을 초과할 수 없습니다."/>'+" : " + (dStockQ - dOriginalQ) ;
										record.set('INOUT_Q', oldValue);
								}
							}
						}
					}

					if(record.get('ORDER_UNIT_P') != ''){
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_P') * newValue));	//자사금액= 자사단가 * 입력한입고량
					}else{
						record.set('ORDER_UNIT_I','0');
					}

					if(record.get('ORDER_UNIT_FOR_P') != ''){
						record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_FOR_P') * newValue));	//구매금액 = 구매단가 * 입력한 입고량
					}else{
						record.set('ORDER_UNIT_FOR_O','0');
					}
					record.set('INOUT_Q',(newValue * record.get('TRNS_RATE')));	//수불수량(재고) = 입력수량 * 입수
					record.set('INOUT_P',(record.get('ORDER_UNIT_P') / record.get('TRNS_RATE')));	//자사단가(재고) = 자사단가 / 입수
					record.set('INOUT_I',record.get('ORDER_UNIT_I'));	//자사금액(재고) = 자사금액
					record.set('INOUT_FOR_P',(record.get('ORDER_UNIT_FOR_P')/ record.get('TRNS_RATE')));	//재고단위단가  = 구매단가 / 입수량
					record.set('INOUT_FOR_O',record.get('ORDER_UNIT_FOR_O'));	//재고단위금액  = 구매금액

					//환율이 jpy일 경우 /100처리, 20200609 주석
//					record.set('ORDER_UNIT_P', UniMatrl.fnExchangeApply(moneyUnit, record.get('ORDER_UNIT_P')));
//					record.set('ORDER_UNIT_I', UniMatrl.fnExchangeApply(moneyUnit, record.get('ORDER_UNIT_I')));
//					record.set('INOUT_I',	   UniMatrl.fnExchangeApply(moneyUnit, record.get('INOUT_I')));
//					record.set('INOUT_P',	   UniMatrl.fnExchangeApply(moneyUnit, record.get('INOUT_P')));
					directMasterStore1.fnSumAmountI();
				break;

				case "ORDER_UNIT_FOR_P":	//입고단가
					//20200908 수정: jpy 관련로직 추가로 전체 수정
					var moneyUnit = panelSearch.getValue('MONEY_UNIT');
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
					record.set('ORDER_UNIT_FOR_O', (record.get('ORDER_UNIT_Q') * newValue));
					record.set('INOUT_FOR_P',(newValue / record.get('TRNS_RATE')));	//재고단위단가 = 입고단가 / 입수
					record.set('INOUT_FOR_O',(record.get('INOUT_FOR_P') * record.get('INOUT_Q')));	//재고단위금액 = 단가 * 수량
/*					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					} */
					directMasterStore1.fnSumAmountI();
					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_P'		,UniMatrl.fnExchangeApply(moneyUnit, (record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O'))));	//자사단가(재고) = 재고단위단가 * 환율, 20200908 수정: jpy 관련로직 수정
						record.set('INOUT_I'		,(record.get('INOUT_P') * record.get('INOUT_Q'))); //
						record.set('ORDER_UNIT_P'	,UniMatrl.fnExchangeApply(moneyUnit, (newValue * record.get('EXCHG_RATE_O'))));				//자사단가 = 입력한 구매단가 * 환율, 20200908 수정: jpy 관련로직 수정
						record.set('ORDER_UNIT_I'	,(record.get('ORDER_UNIT_P') * record.get('ORDER_UNIT_Q')));	//자사금액 = 입고량 * 자사단가

/*						record.set('INOUT_P',(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P',(newValue * record.get('EXCHG_RATE_O')));	//자사단가 = 입력한 구매단가 * 환율
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));	//자사금액 = 입고량 * 자사단가

						record.set('INOUT_FOR_P',(newValue / record.get('TRNS_RATE')));
						record.set('INOUT_P',(newValue / record.get('TRNS_RATE') * record.get('EXCHG_RATE_O')));
						record.set('INOUT_I', (record.get('ORDER_UNIT_P') * record.get('ORDER_UNIT_Q'))); // 자사단가(ORDER_UNIT_P)
					 */
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					break;

				case "ORDER_UNIT_FOR_O" : //입고금액
					//20200908 수정: jpy 관련로직 추가로 전체 수정
					var moneyUnit = panelSearch.getValue('MONEY_UNIT');
					//20200403 변경: != '' -> != 0
					if(record.get('ORDER_UNIT_Q') != 0){
						if((newValue <= 0) && (record.get('ORDER_UNIT_Q') > 0)){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						}else if((newValue >= 0) && (record.get('ORDER_UNIT_Q') < 0)){
							rv='<t:message code="system.message.purchase.message034" default="음수만 입력가능합니다."/>';
							break;
						}
					}

					//20200403 추가: && record.get('INOUT_TYPE_DETAIL') != '91'추가
					if(record.get('INOUT_TYPE_DETAIL') != '90' && record.get('INOUT_TYPE_DETAIL') != '91'){
						if(newValue <= '0'){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						}
					}
                    if(BsaCodeInfo.gsCalculate == 'Y'){
    					//20200908 수정: 그리드 금액변경 시, 단가 변경 되지 않도록 수정
    					if(record.get('ORDER_UNIT_Q') != 0){
    						record.set('ORDER_UNIT_FOR_P',(newValue / record.get('ORDER_UNIT_Q')));	//구매단가 = 입력한 구매금액 / 입고량
    					}else{
    						record.set('ORDER_UNIT_FOR_P','0');
    					}
    					record.set('INOUT_FOR_P',(record.get('ORDER_UNIT_FOR_P') / record.get('TRNS_RATE')));	//재고단위단가 = 입고단가 / 입수
    					record.set('INOUT_FOR_O',(record.get('INOUT_FOR_P') * record.get('INOUT_Q')));			//재고단위금액 = 단가 * 수량

    /*					if(record.get('INOUT_Q') != 0){
    						record.set('INOUT_FOR_P',(record.get('ORDER_UNIT_FOR_P') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
    						record.set('ORDER_UNIT_FOR_P',(newValue / record.get('ORDER_UNIT_Q')));	//구매단가 = 입력한 구매금액 / 입고량
    					}else{
    						record.set('INOUT_FOR_P','0');
    						record.set('ORDER_UNIT_FOR_P','0');
    					} */

	    				if(record.get('EXCHG_RATE_O') != 0){
							var localAmt = UniMatrl.fnExchangeApply(moneyUnit, (newValue * record.get('EXCHG_RATE_O')));
							record.set('INOUT_I'		, UniMatrl.fnAmtWonCalc(localAmt, CustomCodeInfo.gsUnderCalBase, 0));						//자사단가(재고) = 재고단위단가 * 환율, 20200908 수정: jpy 관련로직 수정
							record.set('INOUT_FOR_O'	, newValue);
							record.set('ORDER_UNIT_I'	, UniMatrl.fnAmtWonCalc(localAmt, CustomCodeInfo.gsUnderCalBase, 0));						//자사금액 = 입력한 구매금액 * 환율, 20200908 수정: jpy 관련로직 수정
							//20200908 수정: 그리드 금액변경 시, 단가 변경 되지 않도록 수정
	//						record.set('INOUT_P'		,UniMatrl.fnExchangeApply(moneyUnit, (record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O'))));		//자사단가(재고) = 재고단위단가 * 환율, 20200908 수정: jpy 관련로직 수정
	//						record.set('ORDER_UNIT_P'	,UniMatrl.fnExchangeApply(moneyUnit, (record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O'))));	//자사단가 = 구매단가 * 환율, 20200908 수정: jpy 관련로직 수정
						}else{
							record.set('INOUT_I'		, newValue);
							record.set('ORDER_UNIT_I'	, newValue);
							record.set('INOUT_FOR_O'	, newValue);
							//20200908 수정: 그리드 금액변경 시, 단가 변경 되지 않도록 수정
	//						record.set('INOUT_P','0');
	//						record.set('ORDER_UNIT_P','0');
						}
                    }
					directMasterStore1.fnSumAmountI();
					break;

				case "ORDER_UNIT_P":	//자사단가
					//20200908 수정: jpy 관련로직 추가로 전체 수정
					var moneyUnit = panelSearch.getValue('MONEY_UNIT');
					if((record.get('ACCOUNT_YNC') == 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')){
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

					record.set('INOUT_P',(newValue / record.get('TRNS_RATE')));	//자사단가(재고) = 입력한 자사단가 / 입수
					record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * newValue));	//자사금액 = 입고량 * 입력한 자사단가
					record.set('INOUT_I',(record.get('ORDER_UNIT_I')));	//자사금액(재고) = 자사금액
					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_FOR_P',UniMatrl.fnExchangeApply2(moneyUnit, (record.get('INOUT_P') / record.get('EXCHG_RATE_O'))));						//재고단위단가 = 자사단가(재고)/환율, 20200908 수정: jpy 관련로직 수정
						record.set('ORDER_UNIT_FOR_P',UniMatrl.fnExchangeApply2(moneyUnit, (newValue / record.get('EXCHG_RATE_O'))));								//구매단가 = 입력한 자사단가 / 환율, 20200908 수정: jpy 관련로직 수정
						record.set('ORDER_UNIT_FOR_O',UniMatrl.fnExchangeApply2(moneyUnit, (record.get('ORDER_UNIT_Q') * newValue / record.get('EXCHG_RATE_O'))));	//구매금액 = 입고량 * 입력한 자사단가 / 환율, 20200908 수정: jpy 관련로직 수정
						record.set('INOUT_FOR_O',record.get("ORDER_UNIT_FOR_O"));
					}else{
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}

					directMasterStore1.fnSumAmountI();
					break;

				case "ORDER_UNIT_I" :	//자사금액
					//20200908 수정: jpy 관련로직 추가로 전체 수정
					var moneyUnit = panelSearch.getValue('MONEY_UNIT');

					//20200403 변경: != '' -> != 0
					if(record.get('ORDER_UNIT_Q') != 0){
						if((newValue <= 0) && (record.get('ORDER_UNIT_Q') > 0)){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						}else if((newValue >= 0) && (record.get('ORDER_UNIT_Q') < 0)){
							rv='<t:message code="system.message.purchase.message034" default="음수만 입력가능합니다."/>';
							break;
						}
					}

					//20200330 추가: 자사금액 변경 시, 공급가액 동일하게 set
					record.set('INOUT_I', newValue);

					//20200908 수정: 그리드 금액변경 시, 단가 변경 되지 않도록 수정
//					if(record.get('INOUT_Q') != 0){
//						record.set('INOUT_P',(record.get('INOUT_I') / record.get('INOUT_Q')));	//자사단가(재고) = 자사금액(재고) / 재고단위수량
//						record.set('ORDER_UNIT_P',(newValue / record.get('ORDER_UNIT_Q')));		//자사단가 = 입력한 자사금액 / 입고량
//					}else{
//						record.set('INOUT_P','0');
//						record.set('ORDER_UNIT_P','0');
//					}

					if(record.get('EXCHG_RATE_O') != 0){
						//20200908 수정: 그리드 금액변경 시, 단가 변경 되지 않도록 수정
//						record.set('INOUT_FOR_P'		,UniMatrl.fnExchangeApply2(moneyUnit, (record.get('INOUT_P') / record.get('EXCHG_RATE_O'))));		//재고단위단가 = 자사단가(재고) / 환율, 20200908 수정: jpy 관련로직 수정
//						record.set('ORDER_UNIT_FOR_P'	,UniMatrl.fnExchangeApply2(moneyUnit, (record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'))));	//구매단가 = 자사단가 / 환율, 20200908 수정: jpy 관련로직 수정
						//20200908 수정: 자사금액 변경 시, 공급가액만 변경되도록 수정
//						record.set('ORDER_UNIT_FOR_O'	,UniMatrl.fnExchangeApply2(moneyUnit, (newValue / record.get('EXCHG_RATE_O'))));					//구매금액 = 입력한 자사금액 / 환율, 20200908 수정: jpy 관련로직 수정
//						record.set('INOUT_FOR_O'		,(record.get('ORDER_UNIT_FOR_O')));																	//재고단위금액 = 구매금액
					}else{
						//20200908 수정: 그리드 금액변경 시, 단가 변경 되지 않도록 수정
//						record.set('INOUT_FOR_P','0');
//						record.set('ORDER_UNIT_FOR_P','0');
						//20200908 수정: 자사금액 변경 시, 공급가액만 변경되도록 수정
//						record.set('ORDER_UNIT_FOR_O','0');
//						record.set('INOUT_FOR_O','0');
					}
					directMasterStore1.fnSumAmountI();
					break;

				case "INOUT_P" :	//자사단가(재고)
					//20200908 수정: jpy 관련로직 추가로 전체 수정
					var moneyUnit = panelSearch.getValue('MONEY_UNIT');

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

					record.set('INOUT_I', (record.get('INOUT_Q') * newValue));	//자사금액(재고) = 재고단위 수량 * 입력한 자사단가(재고)

					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_FOR_P',UniMatrl.fnExchangeApply2(moneyUnit, (newValue / record.get('EXCHG_RATE_O'))));							//재고단위단가 = 입력한 자사단가(재고) / 환율, 20200908 수정: jpy 관련로직 수정
						record.set('INOUT_FOR_O',UniMatrl.fnExchangeApply2(moneyUnit, (record.get('INOUT_Q') * newValue / record.get('EXCHG_RATE_O'))));	//재고단위금액 = 재고단위수량 * 입력한 자사단가(재고) / 환율, 20200908 수정: jpy 관련로직 수정
					}else{
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
					}
					directMasterStore1.fnSumAmountI();
					break;

/*				case "INOUT_I" :	//자사금액(재고) - 20200908 수정 - 수정 안 되도록 변경(필요없는 로직 주석)
					//20200908 수정: jpy 관련로직 추가로 전체 수정
					var moneyUnit = panelSearch.getValue('MONEY_UNIT');

					//20200318 로직 수정: !isNaN -> isNaN
					if(isNaN(newValue)){
						rv='<t:message code="system.message.purchase.message075" default="숫자만 입력가능합니다."/>';
						break;
					}
					if(newValue < 0){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}

					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_P',(newValue / record.get('INOUT_Q')));	// 자사단가(재고) = 입력한 자사금액(재고) / 재고단위수량
					}else{
						record.set('INOUT_P','0');
					}

					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_FOR_P',UniMatrl.fnExchangeApply2(moneyUnit, (record.get('INOUT_P') / record.get('EXCHG_RATE_O'))));	//재고단위단가 = 자사단가(재고) / 환율, 20200908 수정: jpy 관련로직 수정
						record.set('INOUT_FOR_O',UniMatrl.fnExchangeApply2(moneyUnit, (newValue / record.get('EXCHG_RATE_O'))));				//재고단위금액 = 입력한 자사금액(재고) / 환율, 20200908 수정: jpy 관련로직 수정
					}else{
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
					}
					directMasterStore1.fnSumAmountI();
					break;*/
//				case "ORDER_UNIT" :
				case "TRNS_RATE" :	//입수
//					if(!isNaN(newValue)){
//						rv='<t:message code="unilite.msg.sMB074"/>';
//						break;
//					}
					if(newValue <= 0){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}

					if(record.get('ORDER_UNIT_Q') != '0'){
						record.set('INOUT_Q',record.get('ORDER_UNIT_Q') * newValue);	//재고단위수량 = 입고량 * 입력한 입수
					}else{
						record.set('INOUT_Q','0');
					}

					if(record.get('ORDER_UNIT_P') != ''){
						record.set('INOUT_P',(record.get('ORDER_UNIT_P') / newValue));	//자사단가(재고) = 자사단가 / 입력한 입수
					}else{
						record.set('INOUT_P','0');
					}

					if(record.get('ORDER_UNIT_FOR_P') != ''){
						record.set('INOUT_FOR_P',(record.get('ORDER_UNIT_FOR_P') / newValue));	//재고단위단가 = 구매단가 / 입력한 입수
					}else{
						record.set('INOUT_FOR_P','0');
					}
					break;

//				case "PURCHASE_RATE" :	//매입율& 단가 & 수량 & 판매가 관계 추가
//					record.set("ORDER_UNIT_FOR_P",record.get('SALE_BASIS_P') * newValue / 100);
//					record.set("ORDER_UNIT_FOR_O",(record.get('SALE_BASIS_P') * newValue / 100)* record.get("ORDER_UNIT_Q"));
//
//					record.set("INOUT_FOR_P",record.get("ORDER_UNIT_FOR_P")/record.get("TRNS_RATE"));
//					record.set("INOUT_FOR_O",record.get("INOUT_FOR_P")*record.get("ORDER_UNIT_Q") * record.get("TRNS_RATE"));
//
//					record.set("INOUT_P",record.get("ORDER_UNIT_FOR_P") / record.get("TRNS_RATE") * record.get("EXCHG_RATE_O"));
//					record.set("INOUT_I",record.get("INOUT_P") * record.get("ORDER_UNIT_Q") * record.get("TRNS_RATE"));
//
//					record.set("ORDER_UNIT_P",record.get("ORDER_UNIT_FOR_P") * record.get("EXCHG_RATE_O"));
//					record.set("ORDER_UNIT_I",record.get("ORDER_UNIT_P") * record.get("ORDER_UNIT_Q"));
//
//					break;

				case "EXCHG_RATE_O" :	//환율
					//20200908 수정: jpy 관련로직 추가로 전체 수정
					var moneyUnit = panelSearch.getValue('MONEY_UNIT');

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

					record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}
					directMasterStore1.fnSumAmountI();

					if(newValue != 0){
						record.set('INOUT_P'		,UniMatrl.fnExchangeApply(moneyUnit, (record.get('INOUT_FOR_P') * newValue)));		//자사단가(재고) = 재고단위단가 * 입력한 환율, 20200908 수정: jpy 관련로직 수정
						record.set('INOUT_I'		,record.get('ORDER_UNIT_Q') * record.get('INOUT_P'));
						record.set('ORDER_UNIT_P'	,UniMatrl.fnExchangeApply(moneyUnit, (record.get('ORDER_UNIT_FOR_P') * newValue)));	//20200908 수정: jpy 관련로직 수정
						record.set('ORDER_UNIT_I'	,(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));
					}else{
						record.set('INOUT_P','0');
						record.set('INOUT_I','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					break;

/*				//20200908 주석: 그리드 화폐는 수정 불가
				case "MONEY_UNIT" :
					if(newValue == BsaCodeInfo.gsDefaultMoney){
						record.set('EXCHG_RATE_O','1');
					}//else
					record.set('ORDER_UNIT_FOR_O', record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_FOR_P'));	//구매금액 = 입고량 * 구매단가
					record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}
					directMasterStore1.fnSumAmountI();

					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P',(record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가 = 구매단가 * 환율
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));	//자사금액 = 입고량 * 자사단가
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					var param = {
						"AC_DATE"	: UniDate.getDbDateStr(panelSearch.getValue('INOUT_DATE')),
						"MONEY_UNIT" : newValue
					};
					salesCommonService.fnExchgRateO(param, function(provider, response) {
						if(!Ext.isEmpty(provider)){
							if(provider.BASE_EXCHG == "1" && !Ext.isEmpty(newValue) && newValue != "KRW"){
								rv = '<t:message code="system.message.purchase.datacheck002" default="환율정보가 없습니다."/>';
							}
							record.set('EXCHG_RATE_O', provider.BASE_EXCHG);
						}
					});
					break;*/

				case "INOUT_TYPE_DETAIL" :
					if(record.get('ACCOUNT_YNC') == 'N'){
						record.set('PRICE_YN','N');
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');

						directMasterStore1.fnSumAmountI();
					}else{
						record.set('PRICE_YN','Y');
					};

					if(newValue == '20'){
						if(Ext.isEmpty(BsaCodeInfo.gsInoutType)){
							record.set('ACCOUNT_YNC','N');
						}else{
							record.set('ACCOUNT_YNC',BsaCodeInfo.gsInoutType);
						}
					}else{
						record.set('ACCOUNT_YNC','Y');
					}
					break;

				case "ACCOUNT_YNC":
					if(newValue == 'N'){
						record.set('PRICE_YN','N');
					}
					break;
				case "PRICE_YN":
					if(newValue == 'Y'){
						if((record.get('INOUT_P') == 0) || (record.get('ORDER_UNIT_P') == 0)){
							rv='<t:message code="system.message.purchase.message070" default="단가는 0보다 커야 합니다."/>';
							break;
						}
					}
					break;
				case "PROJECT_NO":
					break;
				case "TRANS_COST":
					if(newValue < 0){
						rv='<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
						break;
					}
				case "TARIFF_AMT":
					if(newValue < 0){
						rv='<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
						break;
					}
			}
			return rv;
		}
	});

	Unilite.createValidator('validator02', {
		forms: {'formA:':panelSearch},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "EXCHG_RATE_O" :  // 환율
					if(panelSearch.getValue('MONEY_UNIT') == BsaCodeInfo.gsDefaultMoney){
						if(newValue != '1'){
							rv='<t:message code="system.message.purchase.message071" default="화폐단위가 자사화폐인 경우 환율은 1이어야 합니다."/>';
							break;
						}
					}
					break;
			}
			return rv;
		}
	});

	function setAllFieldsReadOnly(b) {
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
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
			} else {
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
				})
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
					if(popupFC.holdable == 'hold' ) {
						item.setReadOnly(false);
					}
				}
			})
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

	function getLotPopupEditor(sumtypeLot, inoutTypeValue){
		var editField;
		if(inoutTypeValue == '90' && ! sumtypeLot){
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
									popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')});
									popup.setExtParam({'CUSTOM_NAME': panelSearch.getValue('CUSTOM_NAME')});
									popup.setExtParam({'WH_CODE': selectRec.get('WH_CODE')});
									popup.setExtParam({'WH_CELL_CODE': selectRec.get('WH_CELL_CODE')});
									popup.setExtParam({'stockYN': 'Y'});
								}
							}
						 }
					});
		}else {
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
};
</script>