<%@page language="java" contentType="text/html; charset=utf-8"%>
	<t:appConfig pgmId="s_map100ukrv_wm"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_map100ukrv_wm"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A022"/>				<!-- 계산서유형 -->
	<t:ExtComboStore comboType="AU" comboCode="M302"/>				<!-- 매입유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B051"/>				<!-- 세액계산법 -->
	<t:ExtComboStore comboType="AU" comboCode="M001"/>				<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B038"/>				<!-- 결제방법 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>				<!-- 화폐 -->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>				<!-- 세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B030"/>				<!-- 세액계산구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">
	//20210222 추가: 우편번호 다음 API 연동
	var protocol = ("https:" == document.location.protocol) ? "https" : "http";
	if(protocol == "https") {
		document.write(unescape("%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	} else {
		document.write(unescape("%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	}
</script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript">
var SearchInfoWindow;				//조회버튼 누르면 나오는 조회창
var referReceiveHistoryWindow;		//입고내역참조
var referReturningHistoryWindow;	//반품내역참조
var referOrderHistoryWindow;		//발주내역참조
var BsaCodeInfo = {
	gsAdvanUseYn	: '${gsAdvanUseYn}',
	gsDefaultMoney	: '${gsDefaultMoney}',
	gsAutoType1		: '${gsAutoType1}',
	gsAutoType2		: '${gsAutoType2}',
	gsList1			: '${gsList1}',
	gsList2			: '${gsList2}',
	AccountType		: ${AccountType},
	BillType		: ${BillType},
	gsSiteCode		: '${gsSiteCode}'
};

var CustomCodeInfo = {
	gsUnderCalBase	: '',
	gsTaxInclude	: '',
	gsTaxCalcType	: '',
	gsBillType		: ''
};
var gMoneyUnit	= '';
var gsTaxType	= '1';

function appMain() {
	var isAutoInoutNum1 = false;
	if(BsaCodeInfo.gsAutoType1=='Y') {
		isAutoInoutNum1 = true;
	}
	var isAutoInoutNum2 = false;
	if(BsaCodeInfo.gsAutoType2=='Y') {
		isAutoInoutNum2 = true;
	}

	/** Model 정의
	 * @type
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_map100ukrv_wmService.selectList',
			update	: 's_map100ukrv_wmService.updateDetail',
			create	: 's_map100ukrv_wmService.insertDetail',
			destroy	: 's_map100ukrv_wmService.deleteDetail',
			syncAll	: 's_map100ukrv_wmService.saveAll'
		}
	});

	Unilite.defineModel('s_map100ukrv_wmModel', {
		fields: [
			{name: 'CHANGE_BASIS_NUM'	, text: '<t:message code="system.label.purchase.purchaseno" default="매입번호"/>'				, type: 'string',allowBlank: isAutoInoutNum1},
			{name: 'CHANGE_BASIS_SEQ'	, text: '<t:message code="system.label.purchase.seq" default="순번"/>'						, type: 'int', allowBlank: false},
			{name: 'INSTOCK_DATE'		, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate', allowBlank: false},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				, type: 'string', allowBlank: false},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'						, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.unit" default="단위"/>'						, type: 'string'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.qty" default="수량"/>'						, type: 'uniQty', allowBlank: true},
			{name: 'REMAIN_Q'			, text: '<t:message code="system.label.purchase.purchasebalanceqty" default="매입잔량"/>'		, type: 'uniQty'},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.purchaseprice" default="구매단가"/>'			, type: 'uniUnitPrice'},
			{name: 'AMOUNT_P'			, text: '<t:message code="system.label.purchase.price" default="단가"/>'						, type: 'uniUnitPrice'},
			{name: 'AMOUNT_I'			, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'				, type: 'uniPrice'},
			{name: 'TAX_I'				, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'				, type: 'uniPrice'},
			{name: 'TOTAL_I'			, text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'				, type: 'uniPrice'},
			{name: 'ORDER_UNIT_FOR_P'	, text: '<t:message code="system.label.purchase.purchaseunitforeigncurrencyunit" default="구매단위외화단가"/>'	, type: 'uniUnitPrice'},
			{name: 'FOREIGN_P'			, text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>'		, type: 'uniUnitPrice'},
			{name: 'FOR_AMOUNT_O'		, text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>'	, type: 'uniFC'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'					, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				, type: 'uniER'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'				, type: 'uniQty'},
			{name: 'BUY_Q'				, text: '<t:message code="system.label.purchase.inventoryunitqty" default="재고단위량"/>'		, type: 'uniQty'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string',comboType:'AU', comboCode:'M001'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'			, type: 'string'},
			{name: 'LC_NUM'				, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'					, type: 'string'},
			{name: 'BL_NUM'				, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'					, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'					, type: 'int'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string'},
			{name: 'INOUT_SEQ'			, text: '<t:message code="system.label.purchase.receiptseq2" default="입고순번"/>'				, type: 'int'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'					, type: 'string',comboType:'BOR120', allowBlank: false},
			{name: 'BILL_DIV_CODE'		, text: '<t:message code="system.label.purchase.declaredivsion" default="신고사업장"/>'			, type: 'string', allowBlank: false},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.clientcode" default="고객코드"/>'				, type: 'string', allowBlank: false},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'	, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'	, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				, type: 'string'},
			{name: 'ADVAN_YN'			, text: 'ADVAN_YN'			, type: 'string'},
			{name: 'ADVAN_AMOUNT'		, text: 'ADVAN_AMOUNT'		, type: 'string'},
			{name: 'PURCHASE_TYPE'		, text: 'PURCHASE_TYPE'		, type: 'string'},
			{name: 'TAX_TYPE'			, text: '<t:message code="system.label.purchase.taxtype" default="세구분"/>'					, type: 'string' ,comboType:'AU', comboCode:'B059'},
			//20210216 추가: CUSTOM_PRSN, PHONE, BANK_NAME, BANK_ACCOUNT, BIRTHDAY, ZIP_CODE, ADDR1
			{name: 'CUSTOM_PRSN'		, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'				, type: 'string'},
			{name: 'PHONE'				, text: '연락처'				, type: 'string'},
			{name: 'BANK_NAME'			, text: '은행명'				, type: 'string'},
			{name: 'BANK_ACCOUNT'		, text: '계좌번호'				, type: 'string'},
			{name: 'BIRTHDAY'			, text: '생년월일'				, type: 'string'},	//20210317 수정: uniDate -> string
			{name: 'ZIP_CODE'			, text: '우편번호'				, type: 'string'},
			{name: 'ADDR1'				, text: '주소'				, type: 'string'},
			{name: 'BILL_TYPE'			, text: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>'				, type: 'string'}	//20210513 추가
		]
	});//End of Unilite.defineModel('s_map100ukrv_wmModel', {

	Unilite.defineModel('buyslipNoMasterModel', {			//조회버튼 누르면 나오는 조회창
		fields: [
			{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type: 'string'},
			{name: 'CHANGE_BASIS_DATE'		, text: '<t:message code="system.label.purchase.exdate" default="결의일"/>'					, type: 'uniDate'},
			{name: 'MONEY_UNIT'				, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'					, type: 'string'},
			{name: 'AMOUNT_I'				, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'				, type: 'uniPrice'},
			{name: 'BILL_NUM'				, text: '<t:message code="system.label.purchase.billno" default="계산서번호"/>'					, type: 'string'},
			{name: 'BILL_DATE'				, text: '<t:message code="system.label.purchase.billdate" default="계산서일"/>'					, type: 'uniDate'},
			{name: 'CHANGE_BASIS_NUM'		, text: '<t:message code="system.label.purchase.purchaseno" default="매입번호"/>'				, type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'					, type: 'string',comboType:'BOR120'},
			{name: 'BILL_DIV_CODE'			, text: '<t:message code="system.label.purchase.declaredivsion" default="신고사업장"/>'			, type: 'string',comboType:'BOR120'},
			{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type: 'string'},
			{name: 'COMPANY_NUM'			, text: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>'			, type: 'string'},
			{name: 'BILL_TYPE'				, text: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>'				, type: 'string'},
			{name: 'RECEIPT_TYPE'			, text: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>'			, type: 'string'},
			{name: 'ORDER_TYPE'				, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string',comboType:'AU', comboCode:'M001'},
			{name: 'VAT_RATE'				, text: '<t:message code="system.label.purchase.vatrate" default="부가세율"/>'					, type: 'string'},
			{name: 'VAT_AMOUNT_O'			, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'				, type: 'uniPrice'},
			{name: 'DEPT_CODE'				, text: '<t:message code="system.label.purchase.department" default="부서"/>'					, type: 'string'},
			{name: 'EX_DATE'				, text: '<t:message code="system.label.purchase.purchasepostdate" default="매입기표일"/>'		, type: 'uniDate'},
			{name: 'EX_NUM'					, text: '<t:message code="system.label.purchase.slipno" default="전표번호"/>'					, type: 'int'},
			{name: 'AGREE_YN'				, text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'				, type: 'string'},
			{name: 'DRAFT_YN'				, text: '<t:message code="system.label.purchase.drafting" default="기안여부"/>'					, type: 'string'},
			{name: 'DEPT_NAME'				, text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'			, type: 'string'},
			{name: 'ISSUE_EXPECTED_DATE'	, text: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>'			, type: 'uniDate'},
			{name: 'ACCOUNT_TYPE'			, text: '<t:message code="system.label.purchase.purchasetype" default="매입유형"/>'				, type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'CREDIT_NUM'				, text: '<t:message code="system.label.purchase.compcardcashno" default="법인카드/현금영수증번호"/>'	, type: 'string'},
			{name: 'CRDT_NAME'				, text: '<t:message code="system.label.purchase.compcardname" default="법인카드명"/>'			, type: 'string'},
			{name: 'WON_CALC_BAS'			, text: 'WON_CALC_BAS'			, type: 'string'},
			{name: 'TAX_TYPE'				, text: 'TAX_TYPE'				, type: 'string'},
			{name: 'TAX_CALC_TYPE'			, text: 'TAX_CALC_TYPE'			, type: 'string'},
			{name: 'CUSTOM_PRSN'			, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'				, type: 'string'}		//20210315 추가
		]
	});

	Unilite.defineModel('s_map100ukrv_wmRECEIVEModel', {	//입고내역참조
		fields: [
//			{name: 'GUBUN'				, text: '<t:message code="system.label.purchase.selection" default="선택"/>'					, type: 'string'},
			{name: 'INSTOCK_DATE'		, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'						, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				, type: 'string'},
			{name: 'TAX_TYPE'			, text: '<t:message code="system.label.purchase.taxtype" default="세구분"/>'					, type: 'string',comboType:'AU', comboCode:'B059'},
			{name: 'ORDER_UNIT_FOR_P'	, text: '<t:message code="system.label.purchase.receiptprice" default="입고단가"/>'				, type: 'uniUnitPrice'},
			{name: 'INOUT_Q'			, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				, type: 'uniQty'},
			{name: 'INOUT_I'			, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'				, type: 'uniPrice'},
			{name: 'INOUT_TAX_AMT'		, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'				, type: 'uniPrice'},
			{name: 'TOTAL_INOUT_I'		, text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'				, type: 'uniPrice'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.purchaseunitqty" default="구매단위수량"/>'		, type: 'uniQty'},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.purchaseprice" default="구매단가"/>'			, type: 'uniUnitPrice'},
			{name: 'AMOUNT_P'			, text: '<t:message code="system.label.purchase.price" default="단가"/>'						, type: 'uniUnitPrice'},
//			{name: 'INOUT_TAX_AMT'		, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'				, type: 'uniPrice'},
			{name: 'AMOUNT_I'			, text: '<t:message code="system.label.purchase.amount" default="금액"/>'						, type: 'uniPrice'},
			{name: 'ORDER_UNIT_FOR_P'	, text: '<t:message code="system.label.purchase.purchaseunitforeigncurrencyunit" default="구매단위외화단가"/>'	, type: 'uniUnitPrice'},
			{name: 'FOREIGN_P'			, text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>'		, type: 'uniUnitPrice'},
			{name: 'FOR_AMOUNT_O'		, text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>'	, type: 'uniFC'},
			{name: 'REMAIN_Q'			, text: '<t:message code="system.label.purchase.purchasebalanceqty" default="매입잔량"/>'		, type: 'uniQty'},
			{name: 'ADVAN_AMOUNT'		, text: '<t:message code="system.label.purchase.paymentinadvance" default="선지급금"/>'			, type: 'uniPrice'},
			{name: 'REMAIN_AMOUNT'		, text: '<t:message code="system.label.purchase.balanceamount" default="잔여액"/>'				, type: 'uniPrice'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'					, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				, type: 'uniER'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.conversioncoeff" default="변환계수"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.unit" default="단위"/>'						, type: 'string'},
			{name: 'BUY_Q'				, text: '<t:message code="system.label.purchase.qty" default="수량"/>'						, type: 'uniQty'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string',comboType:'AU', comboCode:'M001'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'			, type: 'string',comboType:'AU', comboCode:'M201'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'					, type: 'string'},
			{name: 'LC_NUM'				, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'					, type: 'string'},
			{name: 'BL_NUM'				, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'					, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string'},
			{name: 'INOUT_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'						, type: 'string'},
			{name: 'TAX_CALC_TYPE'		, text: '<t:message code="system.label.purchase.taxcalculationmethod" default="세액계산방법"/>'	, type: 'string',comboType:'AU', comboCode:'B051'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'PURCHASE_TYPE'		, text: 'PURCHASE_TYPE'		, type: 'string'},
			{name: 'INOUT_TYPE'			, text: 'INOUT_TYPE'		, type: 'string'},
			//20210216 추가: CUSTOM_PRSN, PHONE, BANK_NAME, BANK_ACCOUNT, BIRTHDAY, ZIP_CODE, ADDR1
			{name: 'CUSTOM_PRSN'		, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'				, type: 'string'},
			{name: 'PHONE'				, text: '연락처'				, type: 'string'},
			{name: 'BANK_NAME'			, text: '은행명'				, type: 'string'},
			{name: 'BANK_ACCOUNT'		, text: '계좌번호'				, type: 'string'},
			{name: 'BIRTHDAY'			, text: '생년월일'				, type: 'string'},	//20210317 수정: uniDate -> string
			{name: 'ZIP_CODE'			, text: '우편번호'				, type: 'string'},
			{name: 'ADDR1'				, text: '주소'				, type: 'string'}
		]
	});

	Unilite.defineModel('s_map100ukrv_wmRETURNINGModel', {	//반품내역참조
		fields: [
			//{name: 'GUBUN'			, text: '<t:message code="system.label.purchase.selection" default="선택"/>'					, type: 'string'},
			{name: 'INSTOCK_DATE'		, text: '<t:message code="system.label.purchase.returndate" default="반품일"/>'				, type: 'uniDate'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'						, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				, type: 'string'},
			{name: 'TAX_TYPE'			, text: '<t:message code="system.label.purchase.taxtype" default="세구분"/>'					, type: 'string' ,comboType:'AU', comboCode:'B059'},
			{name: 'ORDER_UNIT_FOR_P'	, text: '<t:message code="system.label.purchase.returnprice" default="반품단가"/>'				, type: 'uniUnitPrice'},
			{name: 'INOUT_Q'			, text: '<t:message code="system.label.purchase.returnqty" default="반품량"/>'					, type: 'uniQty'},
			{name: 'INOUT_I'			, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'				, type: 'uniPrice'},
			{name: 'INOUT_TAX_AMT'		, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'				, type: 'uniPrice'},
			{name: 'TOTAL_INOUT_I'		, text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'				, type: 'uniPrice'},
			{name: 'CONDITION'			, text: '<t:message code="system.label.purchase.condition" default="조건"/>'					, type: 'string'},
			{name: 'TYPE'				, text: '<t:message code="system.label.purchase.type2" default="형태"/>'						, type: 'string'},
			{name: 'GOOD_STOCK_Q'		, text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>'				, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.returnunitqty" default="반품단위수량"/>'			, type: 'uniQty'},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.returnunitprice" default="반품단위단가"/>'		, type: 'uniUnitPrice'},
			{name: 'AMOUNT_P'			, text: '<t:message code="system.label.purchase.price" default="단가"/>'						, type: 'uniUnitPrice'},
			{name: 'AMOUNT_I'			, text: '<t:message code="system.label.purchase.amount" default="금액"/>'						, type: 'uniPrice'},
			{name: 'ORDER_UNIT_FOR_P'	, text: '<t:message code="system.label.purchase.purchaseunitforeigncurrencyunit" default="구매단위외화단가"/>'	 , type: 'uniUnitPrice'},
			{name: 'FOREIGN_P'			, text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>'		, type: 'uniUnitPrice'},
			{name: 'FOR_AMOUNT_O'		, text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>'	, type: 'uniFC'},
			{name: 'REMAIN_Q'			, text: '<t:message code="system.label.purchase.purchasebalanceqty" default="매입잔량"/>'		, type: 'uniQty'},
			{name: 'ADVAN_AMOUNT'		, text: '<t:message code="system.label.purchase.paymentinadvance" default="선지급금"/>'			, type: 'uniPrice'},
			{name: 'REMAIN_AMOUNT'		, text: '<t:message code="system.label.purchase.balanceamount" default="잔여액"/>'				, type: 'uniPrice'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'					, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				, type: 'uniER'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.conversioncoeff" default="변환계수"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.unit" default="단위"/>'						, type: 'string'},
			{name: 'BUY_Q'				, text: '<t:message code="system.label.purchase.qty" default="수량"/>'						, type: 'uniQty'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string',comboType:'AU', comboCode:'M001'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'			, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'					, type: 'string'},
			{name: 'LC_NUM'				, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'					, type: 'string'},
			{name: 'BL_NUM'				, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'					, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.returnno" default="반품번호"/>'					, type: 'string'},
			{name: 'INOUT_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'						, type: 'string'},
			{name: 'TAX_CALC_TYPE'		, text: '<t:message code="system.label.purchase.taxcalculationmethod" default="세액계산방법"/>'	, type: 'string',comboType:'AU', comboCode:'B030'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'PURCHASE_TYPE'		, text: 'PURCHASE_TYPE'		, type: 'string'},
			{name: 'INOUT_TYPE'			, text: 'INOUT_TYPE'		, type: 'string'}
		]
	});

	Unilite.defineModel('s_map100ukrv_wmORDERModel', {		//발주내역참조
		fields: [
		//	{name: 'GUBUN'				, text: '<t:message code="system.label.purchase.selection" default="선택"/>'					, type: 'string'},
			{name: 'ORDER_DATE'			, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'					, type: 'uniDate'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'					, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'						, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				, type: 'string'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'						, type: 'uniQty'},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'						, type: 'uniUnitPrice'},
			{name: 'ORDER_O'			, text: '<t:message code="system.label.purchase.amount" default="금액"/>'						, type: 'uniPrice'},
			{name: 'ADVAN_AMOUNT'		, text: '<t:message code="system.label.purchase.paymentinadvance" default="선지급금"/>'			, type: 'uniPrice'},
			{name: 'LOG_AMT'			, text: '<t:message code="system.label.purchase.balanceamount" default="잔여액"/>'				, type: 'uniPrice'},
			{name: 'REMAIN_Q'			, text: 'REMAIN_Q'	, type: 'uniQty'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'					, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'				, type: 'string'},
			{name: 'LC_NUM'				, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'					, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'					, type: 'int'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string',comboType:'AU', comboCode:'M001'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.purchase.charger" default="담당자"/>'					, type: 'string'},
			//20200304 추가
			{name: 'INSTOCK_DATE'		, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate'},
			{name: 'AMOUNT_P'			, text: '<t:message code="system.label.purchase.price" default="단가"/>'						, type: 'uniUnitPrice'},
			{name: 'AMOUNT_I'			, text: '<t:message code="system.label.purchase.amount" default="금액"/>'						, type: 'uniPrice'},
			{name: 'ORDER_UNIT_FOR_P'	, text: '<t:message code="system.label.purchase.purchaseunitforeigncurrencyunit" default="구매단위외화단가"/>'	, type: 'uniUnitPrice'},
			{name: 'FOREIGN_P'			, text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>'		, type: 'uniUnitPrice'},
			{name: 'FOR_AMOUNT_O'		, text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>'	, type: 'uniFC'},
			{name: 'REMAIN_AMOUNT'		, text: '<t:message code="system.label.purchase.balanceamount" default="잔여액"/>'				, type: 'uniPrice'},
			{name: 'BUY_Q'				, text: '<t:message code="system.label.purchase.qty" default="수량"/>'						, type: 'uniQty'},
			{name: 'BL_NUM'				, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'					, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.returnno" default="반품번호"/>'					, type: 'string'},
			{name: 'INOUT_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'						, type: 'string'},
			{name: 'TAX_CALC_TYPE'		, text: '<t:message code="system.label.purchase.taxcalculationmethod" default="세액계산방법"/>'	, type: 'string',comboType:'AU', comboCode:'B030'},
			{name: 'INOUT_Q'			, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				, type: 'uniQty'},
			{name: 'INOUT_I'			, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'				, type: 'uniPrice'},
			{name: 'INOUT_TAX_AMT'		, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'				, type: 'uniPrice'},
			{name: 'TOTAL_INOUT_I'		, text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'				, type: 'uniPrice'},
			{name: 'INOUT_TYPE'			, text: 'INOUT_TYPE'		, type: 'string'}

		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_map100ukrv_wmMasterStore1',{
		model	: 's_map100ukrv_wmModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: directProxy,
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);

			console.log("list:", list);
			console.log("toUpdate:", toUpdate);
			console.log("toDelete:", toDelete);
			var paramMaster	= masterForm.getValues();	//syncAll 수정
			var orderType	= '';

			if(masterGrid.getStore().data.count() > 0){
				orderType = masterGrid.getStore().data.items[0].data.ORDER_TYPE;
				paramMaster.ORDER_TYPE = orderType;
			} else {
				paramMaster.ORDER_TYPE = gOrderType
			}

			gOrderType = '';
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("ORDER_TYPE"		, '1');//map200t의 order_type을 따름
						masterForm.setValue("CHANGE_BASIS_NUM"	, master.CHANGE_BASIS_NUM);
						panelResult.setValue("CHANGE_BASIS_NUM"	, master.CHANGE_BASIS_NUM);
						masterForm.setValue("BILL_NUM"			, master.BILL_NUM);
						panelResult.setValue("BILL_NUM"			, master.BILL_NUM);
						var cbNum	= masterForm.getValue('CHANGE_BASIS_NUM');
						var bNum	= masterForm.getValue('BILL_NUM');
						Ext.each(list, function(record, index) {
							if(record.data['CHANGE_BASIS_NUM'] != cbNum && record.data['BILL_NUM'] != bNum) {
								record.set('CHANGE_BASIS_NUM', cbNum);
								record.set('BILL_NUM', bNum);
							}
						})
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						if (directMasterStore1.count() == 0) {
							UniAppManager.app.onResetButtonDown();
						} else {
							directMasterStore1.loadStoreRecords();
						}
						UniAppManager.app.fnExSlipBtn();
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_map100ukrv_wmGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				this.fnSumAmountIForm();
				this.fnSumAmountI();
				UniAppManager.app.fnExSlipBtn();
			},
			add: function(store, records, index, eOpts) {
				this.fnSumAmountIForm();
				this.fnSumAmountI();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				if(!Ext.isEmpty(record.get('PHONE') && modifiedFieldNames == 'PHONE')) {
					record.set('PHONE', record.get('PHONE').replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3"));
				}
				this.fnSumAmountIForm();
				this.fnSumAmountI();
			},
			remove: function(store, record, index, isMove, eOpts) {
				this.fnSumAmountIForm();
				this.fnSumAmountI();
			}
		},
		fnSumAmountIForm: function() {
			var taxI		= 0;
			var amountI		= 0;
			var amountTot	= 0;
			var results = directMasterStore1.sumBy(function(record, id) {	 // 합계를 가지고 값구하기
				return true;
				},
				['TAX_I', 'AMOUNT_I']);
			taxI		= results.TAX_I;
			amountI		= results.AMOUNT_I;
			amountTot	= taxI + amountI;
			masterForm.setValue('VATAMOUNTO'	, taxI);
			masterForm.setValue('AMOUNTI'		, amountI);
			masterForm.setValue('AMOUNTTOT'		, amountTot);
			panelResult.setValue('VATAMOUNTO'	, taxI);
			panelResult.setValue('AMOUNTI'		, amountI);
			panelResult.setValue('AMOUNTTOT'	, amountTot);
			//masterForm.fnCreditCheck()
		},
		fnSumAmountI:function(records){
			console.log("=============Exec fnSumAmountI()");
			//var records = directMasterStore1.loadStoreRecords();
			var dSumTax			= 0;
			var dSumAmountI		= 0;
			var dSumAmountTot	= 0;
			var dOrderUnitQ		= 0;
			var dOrderUnitP		= 0;
			var dCalAmoutI		= 0;
			var dAmountI		= 0;
			var dTax			= 0;
			var dVatRate		= 0;
			var dTaxInout		= panelResult.getValues().TAX_INOUT;		//20210318 추가: 세액 포함여부 관련 계산로직 수정
////		조회시 값받아오질 못함	alert(CustomCodeInfo.gsUnderCalBase);
////						alert(CustomCodeInfo.gsTaxInclude);
////							alert(CustomCodeInfo.gsTaxCalcType);

			if(masterForm.getValue('VAT_RATE') == ''){
				dVatRate = 0;
			} else {
				dVatRate = masterForm.getValue('VAT_RATE');
			}
			if(gsTaxType == '2'){
				dVatRate = 0;
			}
			Ext.each(records,  function(record, index, recs){
//				for(var i=0; i<records.length-1; i++) {
//					var record = records[i];
				dOrderUnitQ	= record.get('ORDER_UNIT_Q');
				dOrderUnitP	= record.get('ORDER_UNIT_P');
				dCalAmoutI	= record.get('AMOUNT_I');

				if(Ext.isEmpty(records)){
					if(dCalAmoutI == (dOrderUnitQ * dOrderUnitP)){
						dAmountI = dCalAmoutI;
					} else {
						dAmountI = dOrderUnitQ * dOrderUnitP;
					}
				} else {
					dAmountI = dCalAmoutI;
				}

				if(dAmountI == '0'){
					dAmountI = record.get('FOR_AMOUNT_O') * record.get('EXCHG_RATE_O');
				}

				if(dTaxInout == '1'){				//20210318 수정: 세액 포함여부 관련 계산로직 수정
					Math.round(dAmountI,0);
					dTax = dAmountI * (dVatRate / 100);
					dSumAmountI = dSumAmountI + dAmountI;
					Math.round(dTax,0);
					record.set('AMOUNT_I',Math.round(dAmountI,0));

					if(record.phantom){
						console.log("[dTax]" + fnWonCalcBas(dTax));
						record.set('TAX_I',fnWonCalcBas(dTax));
					}
				} else {
					dTemp = Math.round(dAmountI / ( dVatRate + 100 ) * 100,0);
					//20190821 fnAmtWonCalc 기능은 자동 버림처리.. round로 변경.
					//dTemp = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '2');	//UniMatrl	??
					dTax  =	dAmountI - dTemp;
					Math.round(dTax,0);
					dTemp = dAmountI - dTax;
					Math.round(dTemp,0);
					dSumAmountTot = dSumAmountTot + dAmountI;

					record.set('AMOUNT_I',dTemp);
					if(record.phantom){
						console.log("[dTax]" + fnWonCalcBas(dTax));
						record.set('TAX_I', fnWonCalcBas(dTax));
					}
				}
				//20210317 추가
				record.set('TOTAL_I', record.get('AMOUNT_I') + record.get('TAX_I'));

				dSumTax = dSumTax + dTax;

				Math.round(dSumAmountI,0);
				Math.round(dSumAmountTot,0);
				Math.round(dSumTax,0);

				if(dTaxInout == '1'){						//20210318 수정: 세액 포함여부 관련 계산로직 수정
					masterForm.setValue('AMOUNTI',dSumAmountI);
					masterForm.setValue('AMOUNTTOT',dSumAmountI);
				} else {
					masterForm.setValue('AMOUNTTOT',dSumAmountTot);
				}

				if(CustomCodeInfo.gsTaxCalcType == '1'){
					if(dTaxInout == '1'){					//20210318 수정: 세액 포함여부 관련 계산로직 수정
						dTax = masterForm.getValue('AMOUNTI') * (dVatRate / 100);
						Math.round(dTax,0);
					} else {
						dTemp = masterForm.getValue('AMOUNTTOT') / ( dVatRate + 100 ) * 100;
						dTax = masterForm.getValue('AMOUNTTOT')	- dTemp;
						Math.round(dTax,0);
						masterForm.setValue('AMOUNTI',masterForm.getValue('AMOUNTTOT') - dTax);

					}
					masterForm.setValue('VATAMOUNTO', dTax);
				} else {
					masterForm.setValue('VATAMOUNTO', dSumTax);
					if(dTaxInout != '1'){					//20210318 수정: 세액 포함여부 관련 계산로직 수정
						masterForm.setValue('AMOUNTI',masterForm.getValue('AMOUNTTOT') - dSumTax);
					}
					directMasterStore1.fnSumTax();
				}
//				}
			})
			masterForm.setValue('AMOUNTTOT',masterForm.getValue('VATAMOUNTO') + masterForm.getValue('AMOUNTI'));

			if(CustomCodeInfo.gsTaxCalcType == '1'){
				var amountI = panelResult.getValue('AMOUNTI');
				var vat = fnWonCalcBas(amountI * (dVatRate / 100));
				panelResult.setValue('VATAMOUNTO', vat);
				panelResult.setValue('AMOUNTTOT',panelResult.getValue('VATAMOUNTO') + panelResult.getValue('AMOUNTI'));
			}
		},
		fnSumAmountI2:function(records, taxInout) {
			var dSumTax			= 0;
			var dSumAmountI		= 0;
			var dSumAmountTot	= 0;
			var dOrderUnitQ		= 0;
			var dOrderUnitP		= 0;
			var dCalAmoutI		= 0;
			var dAmountI		= 0;
			var dTax			= 0;
			var dVatRate		= 0;
			var dTaxInout		= Ext.isEmpty(taxInout) ? panelResult.getValues().TAX_INOUT: taxInout;		//20210318 추가: 세액 포함여부 관련 계산로직 수정, 20210513 수정

			if(masterForm.getValue('VAT_RATE') == ''){
				dVatRate = 0;
			} else {
				dVatRate = masterForm.getValue('VAT_RATE');
			}
			if(gsTaxType == '2'){
				dVatRate = 0;
			}
			Ext.each(records,  function(record, index, recs){
				dOrderUnitQ	= record.get('ORDER_UNIT_Q');
				dOrderUnitP	= record.get('ORDER_UNIT_P');
				dAmountI	= Unilite.multiply(dOrderUnitQ, dOrderUnitP);

				if(dAmountI == '0'){
					dAmountI = Unilite.multiply(record.get('FOR_AMOUNT_O'), record.get('EXCHG_RATE_O'));
				}

				if(dTaxInout == '1'){				//20210318 수정: 세액 포함여부 관련 계산로직 수정
					Math.round(dAmountI, 0);
					dTax		= Unilite.multiply(dAmountI, (dVatRate / 100));
					dSumAmountI	= dSumAmountI + dAmountI;
					Math.round(dTax, 0);
					record.set('AMOUNT_I'	, Math.round(dAmountI, 0));
					record.set('TAX_I'		, fnWonCalcBas(dTax));
				} else {
					dTemp	= Math.round(dAmountI / ( dVatRate + 100 ) * 100,0);
					dTax	= dAmountI - dTemp;
					Math.round(dTax, 0);
					dTemp	= dAmountI - dTax;
					Math.round(dTemp, 0);
					dSumAmountTot = dSumAmountTot + dAmountI;

					record.set('AMOUNT_I'	, dTemp);
					record.set('TAX_I'		, fnWonCalcBas(dTax));
				}
				record.set('TOTAL_I', record.get('AMOUNT_I') + record.get('TAX_I'));

				dSumTax = dSumTax + dTax;

				Math.round(dSumAmountI	, 0);
				Math.round(dSumAmountTot, 0);
				Math.round(dSumTax		, 0);

				if(dTaxInout == '1'){						//20210318 수정: 세액 포함여부 관련 계산로직 수정
					masterForm.setValue('AMOUNTI'	, dSumAmountI);
					masterForm.setValue('AMOUNTTOT'	, dSumAmountI);
				} else {
					masterForm.setValue('AMOUNTTOT'	, dSumAmountTot);
				}

				if(CustomCodeInfo.gsTaxCalcType == '1'){
					if(dTaxInout == '1'){
						dTax = Unilite.multiply(masterForm.getValue('AMOUNTI'), (dVatRate / 100));
						Math.round(dTax, 0);
					} else {
						dTemp	= masterForm.getValue('AMOUNTTOT') / ( dVatRate + 100 ) * 100;
						dTax	= masterForm.getValue('AMOUNTTOT') - dTemp;
						Math.round(dTax, 0);
						masterForm.setValue('AMOUNTI', masterForm.getValue('AMOUNTTOT') - dTax);
					}
					masterForm.setValue('VATAMOUNTO', dTax);
				} else {
					masterForm.setValue('VATAMOUNTO', dSumTax);
					if(dTaxInout != '1'){
						masterForm.setValue('AMOUNTI', masterForm.getValue('AMOUNTTOT') - dSumTax);
					}
					directMasterStore1.fnSumTax();
				}
			})
			masterForm.setValue('AMOUNTTOT', masterForm.getValue('VATAMOUNTO') + masterForm.getValue('AMOUNTI'));

			if(CustomCodeInfo.gsTaxCalcType == '1'){
				var amountI	= panelResult.getValue('AMOUNTI');
				var vat		= fnWonCalcBas(amountI * (dVatRate / 100));
				panelResult.setValue('VATAMOUNTO'	, vat);
				panelResult.setValue('AMOUNTTOT'	, panelResult.getValue('VATAMOUNTO') + panelResult.getValue('AMOUNTI'));
			}
		},
		fnSumTax: function() {
			var dTaxInout	= panelResult.getValues().TAX_INOUT		//20210318 추가: 세액 포함여부 관련 계산로직 수정
			var records		= masterGrid.getSelectedRecords();
			Ext.each(records, function(record, index, recs){
				var dSumTax			= 0 ;
				var dSumAmountI		= 0;
				var dSumAmountTot	= 0;
				var dVatRate;
				var dAmountI;
				var dTax;
				var dTaxI			= 0;
	
				if(masterForm.getValue('VAT_RATE') == ''){
					dVatRate = 0;
				} else {
					dVatRate = masterForm.getValue('VAT_RATE');
				}
				dAmountI = record.get('AMOUNT_I');
				if(dTaxInout == '1'){							//20210318 수정: 세액 포함여부 관련 계산로직 수정
					dTax = record.get('TAX_I');
					dSumAmountI = dSumAmountI + dAmountI;
				} else {
					dTax = record.get('TAX_I');
					dSumAmountTot = dSumAmountTot + dAmountI + dTax;
				}
	
				dSumTax = dSumTax + dTax;
				Math.round(dSumAmountI	, 0);
				Math.round(dSumAmountTot, 0);
				Math.round(dSumTax		, 0);
	
				if(dTaxInout == '1'){							//20210318 수정: 세액 포함여부 관련 계산로직 수정
					masterForm.setValue('AMOUNTI'	, dSumAmountI);
					masterForm.setValue('AMOUNTTOT'	, dSumAmountI);
				} else {
					masterForm.setValue('AMOUNTTOT'	, dSumAmountTot);
				}
	
				if(record.get('TAX_I') != ''){
					dTaxI = dTaxI + record.get('TAX_I');
				}
				masterForm.setValue('VATAMOUNTO', dTaxI);
	
				if(dTaxInout != '1'){							//20210318 수정: 세액 포함여부 관련 계산로직 수정
					masterForm.setValue('AMOUNTI', masterForm.getValue('AMOUNTTOT') - dSumTax);
				}
				masterForm.setValue('AMOUNTTOT', masterForm.getValue('VATAMOUNTO') + masterForm.getValue('AMOUNTI'));
			})
		}
	});//End of var directMasterStore1 = Unilite.createStore('s_map100ukrv_wmMasterStore1',{

	var buyslipNoMasterStore = Unilite.createStore('buyslipNoMasterStore', {					//조회버튼 누르면 나오는 조회창
		model	: 'buyslipNoMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_map100ukrv_wmService.selectOrderNumMasterList'
			}
		},
		loadStoreRecords : function() {
			var param		= buyslipNoSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(buyslipNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var receiveHistoryStore = Unilite.createStore('s_map100ukrv_wmReceiveHistoryStore', {		//입고내역참조
		model	: 's_map100ukrv_wmRECEIVEModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_map100ukrv_wmService.selectreceiveHistoryList'
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					var receiveRecords = new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records,
							function(item, i) {
								Ext.each(masterRecords.items, function(record, i) {
									console.log("record :", record);
										if( (record.data['INOUT_NUM'] == item.data['INOUT_NUM'])
												&& (record.data['INOUT_SEQ'] == item.data['INOUT_SEQ'])
										)
										{
											receiveRecords.push(item);
										}
								});
						});
						store.remove(receiveRecords);
					}
				}
			}
		},
		loadStoreRecords : function() {
			var param= receivehistorySearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var returningHistoryStore = Unilite.createStore('s_map100ukrv_wmReturningHistoryStore', {	//반품내역참조
		model	: 's_map100ukrv_wmRETURNINGModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_map100ukrv_wmService.selectreturningHistoryList'
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					var returningRecords = new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records,
							function(item, i) {
								Ext.each(masterRecords.items, function(record, i) {
									console.log("record :", record);
									if( (record.data['INOUT_NUM'] == item.data['INOUT_NUM'])
											&& (record.data['INOUT_SEQ'] == item.data['INOUT_SEQ'])
									)
									{
										returningRecords.push(item);
									}
								});
						});
					store.remove(returningRecords);
					}
				}
			}
		},
		loadStoreRecords : function() {
			var param= returninghistorySearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var orderHistoryStore = Unilite.createStore('s_map100ukrv_wmOrderHistoryStore', {			//발주내역참조
		model	: 's_map100ukrv_wmORDERModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read : 's_map100ukrv_wmService.selectorderHistoryList'
			}
		},
		listeners: {
			load:function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					var orderRecords = new Array();

					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records,
							function(item, i) {
								Ext.each(masterRecords.items, function(record, i) {
									console.log("record :", record);
									if( (record.data['ESTI_NUM'] == item.data['ESTI_NUM'])
											&& (record.data['ESTI_SEQ'] == item.data['ESTI_SEQ'])
									)
									{
										orderRecords.push(item);
									}
								});
						});
					store.remove(orderRecords);
					}
				}
			}
		},
		loadStoreRecords : function() {
			var param= orderhistorySearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var masterForm = Unilite.createSearchPanel('searchForm', {
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
		items		: [{
			title		: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [
				Unilite.popup('AGENT_CUST', {
					fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					allowBlank		: false,
					holdable		: 'hold',
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE'	, masterForm.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME'	, masterForm.getValue('CUSTOM_NAME'));
								masterForm.setValue('MONEY_UNIT'	, Unilite.nvl(records[0]['MONEY_UNIT'],BsaCodeInfo.gsDefaultMoney));
								panelResult.setValue('MONEY_UNIT'	, Unilite.nvl(records[0]['MONEY_UNIT'],BsaCodeInfo.gsDefaultMoney));
//								ownNum = records[0]['COMPANY_NUM'].substring(0, 3) + '-' + records[0]['COMPANY_NUM'].substring(3, 5) + '-' + records[0]['COMPANY_NUM'].substring(5);
								masterForm.setValue('COMPANY_NUM'	, records[0]['COMPANY_NUM']);
								panelResult.setValue('COMPANY_NUM'	, records[0]['COMPANY_NUM']);

								CustomCodeInfo.gsUnderCalBase	= records[0]['WON_CALC_BAS'];
								CustomCodeInfo.gsTaxInclude		= records[0]['TAX_TYPE'];
								CustomCodeInfo.gsTaxCalcType	= records[0]['TAX_CALC_TYPE'];
								CustomCodeInfo.gsBillType		= records[0]['BILL_TYPE'];

								var billType = '51';
								if(!Ext.isEmpty(records[0]['BILL_TYPE'])){
									if(records[0]['BILL_TYPE'] > '50'){
										billType = records[0]['BILL_TYPE'];
									}
								}
								/*******20190717 거래처 화폐와 자국화폐가 다른 경우 수입세금계산서로 세팅*******/
								var vatRate = records[0].VAT_RATE;
								if(Unilite.nvl(records[0]['MONEY_UNIT'],BsaCodeInfo.gsDefaultMoney) != BsaCodeInfo.gsDefaultMoney){
									billType = '56';
									vatRate = 0;
								} else if(Unilite.nvl(records[0]['MONEY_UNIT'],BsaCodeInfo.gsDefaultMoney) == 'KRW'){
									vatRate = 10;
								}
								masterForm.setValue('BILL_TYPE'		, billType);
								panelResult.setValue('BILL_TYPE'	, billType);
								masterForm.setValue('RECEIPT_TYPE'	, records[0]['SET_METH']);
								panelResult.setValue('RECEIPT_TYPE'	, records[0]['SET_METH']);
								masterForm.setValue('VAT_RATE'		, vatRate);
								panelResult.setValue('VAT_RATE'		, vatRate);
								//20210318 추가
								masterForm.getField('TAX_INOUT').setValue(records[0]['TAX_CALC_TYPE']);
								panelResult.getField('TAX_INOUT').setValue(records[0]['TAX_CALC_TYPE']);
							},
							scope: this
						},
						onClear: function(type) {
							CustomCodeInfo.gsUnderCalBase = '';
							masterForm.setValue('CUSTOM_CODE'	, '');
							masterForm.setValue('CUSTOM_NAME'	, '');
							masterForm.setValue('MONEY_UNIT'	, '');
							panelResult.setValue('MONEY_UNIT'	, '');
							masterForm.setValue('COMPANY_NUM'	, '');
							panelResult.setValue('COMPANY_NUM'	, '');
							masterForm.setValue('BILL_TYPE'		, '');
							panelResult.setValue('BILL_TYPE'	, '');
							masterForm.setValue('RECEIPT_TYPE'	, '');
							panelResult.setValue('RECEIPT_TYPE'	, '');
							masterForm.setValue('VAT_RATE'		, 10);
							panelResult.setValue('VAT_RATE'		, 10);

							CustomCodeInfo.gsUnderCalBase	= '';
							CustomCodeInfo.gsTaxInclude		= '';
							CustomCodeInfo.gsTaxCalcType	= '';
							CustomCodeInfo.gsBillType		= '';
							//20210318 추가
							masterForm.getField('TAX_INOUT').setValue('2');
							panelResult.getField('TAX_INOUT').setValue('2');
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
							popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
						}
					}
				}),
				Unilite.popup('DEPT', {
					fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					allowBlank: false,
					holdable: 'hold',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
								panelResult.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
							},
							scope: this
						},
						onClear: function(type) {
									panelResult.setValue('DEPT_CODE', '');
									panelResult.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장

							if(authoInfo == "A"){
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							} else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': masterForm.getValue('BILL_DIV_CODE')});
							} else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.purchasedivision" default="매입사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
						var param = {"DIV_CODE": masterForm.getValue('DIV_CODE')};
						s_map100ukrv_wmService.billDivCode(param, function(provider, response) {
							if(!Ext.isEmpty(provider)){
								masterForm.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
								panelResult.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
							}
						});
						masterForm.setValue('DEPT_CODE','');
						masterForm.setValue('DEPT_NAME','');
						panelResult.setValue('DEPT_CODE','');
						panelResult.setValue('DEPT_NAME','');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				name:'BILL_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BILL_DATE', newValue);
						//20200309 추가: endOfNextMonth, UniDate.extParseDate()
						if(Ext.isDate(newValue)) {
							fnSetIssueExpectedDate(newValue);
						}
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.billno" default="계산서번호"/>',
				name: 'BILL_NUM',
				xtype: 'uniTextfield',
//				holdable: 'hold',
				readOnly: true,
				readOnly: isAutoInoutNum2,
			//	holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BILL_NUM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.exdate" default="결의일"/>',
				name: 'CHANGE_BASIS_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CHANGE_BASIS_DATE', newValue);
					}
				}
			},{
				xtype: 'component',
				tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' }
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchaseno" default="매입번호"/>',
				name: 'CHANGE_BASIS_NUM',
				xtype: 'uniTextfield',
//				holdable: 'hold',
				readOnly: true,
				readOnly: isAutoInoutNum1,
		//		holdable: 'hold'
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CHANGE_BASIS_NUM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasetype" default="매입유형"/>',
				name: 'ACCOUNT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M302',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						UniAppManager.app.fnGetAccountType(newValue);
						panelResult.setValue('ACCOUNT_TYPE', newValue);
//						if(newValue == '10' ){
//							panelResult.setValue('BILL_TYPE', '51');
//						}
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>',
				name: 'BILL_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A022',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					blur: function(field, The, eOpts)  {
						var newValue = field.getValue();
						panelResult.setValue('BILL_TYPE', newValue);
						UniAppManager.app.fnGetBillType(newValue);
						panelResult.setValue('CRDT_NUM', '');
						panelResult.setValue('CRDT_NAME', '');
						masterForm.setValue('CRDT_NUM', '');
						masterForm.setValue('CRDT_NAME', '');
						panelResult.setValue('CREDIT_NUMBER', '');
						masterForm.setValue('CREDIT_NUMBER', '');

						//20200901 추가: 계산서유형이 '신용카드매입'일 때, show && 필수
						var commonCodes = Ext.data.StoreManager.lookup('CBS_AU_A022').data.items;
						var refCode1;
						Ext.each(commonCodes,function(commonCode, i) {
							if(commonCode.get('value') == newValue) {
								refCode1 = commonCode.get('refCode1');
							}
						})
						if(refCode1 != 'E') {
							panelResult.down('#CREDIT_NUM').setHidden(true);
							panelResult.getField('CREDIT_NUM').setConfig('allowBlank', true);
							masterForm.down('#CREDIT_NUM').setHidden(true);
							masterForm.getField('CREDIT_NUM').setConfig('allowBlank', true);
							panelResult.setValue('CREDIT_NUM', '');
							masterForm.setValue('CREDIT_NUM', '');
						} else {
							panelResult.getField('CREDIT_NUM').setHidden(false);
							panelResult.getField('CREDIT_NUM').setConfig('allowBlank', false);
							masterForm.getField('CREDIT_NUM').setHidden(false);
							masterForm.getField('CREDIT_NUM').setConfig('allowBlank', false);
						}

						var param= Ext.getCmp('searchForm').getValues();
						s_map100ukrv_wmService.selectRefCode2(param, function(provider, response) {
							if(!Ext.isEmpty(provider)){
								masterForm.setValue('VAT_RATE', provider[0].VAT_RATE);
								panelResult.setValue('VAT_RATE', provider[0].VAT_RATE);
							}
						});
					},
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						store.clearFilter();
						store.filterBy(function(record){
							return record.get('refCode3') == '1';
						})
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
				name: 'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B004',
				allowBlank: false,
				displayField: 'value',
				holdable: 'hold',
				fieldStyle: 'text-align: center;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('MONEY_UNIT', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.declaredivsion" default="신고사업장"/>',
				name: 'BILL_DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
//				holdable: 'hold',
				allowBlank: false,
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>',
				name: 'COMPANY_NUM',
				xtype: 'uniTextfield',
//				holdable: 'hold',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('COMPANY_NUM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasepostdate" default="매입기표일"/>',
				name: 'EX_DATE',
				xtype: 'uniDatefield',
//				holdable: 'hold',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EX_DATE', newValue);
					}
				}
			},{
				fieldLabel: 'DRAFT_YN',
				name: 'DRAFT_YN',
				xtype: 'uniTextfield',
				holdable: 'hold',
				hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DRAFT_YN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>',
				name: 'ISSUE_EXPECTED_DATE',
				xtype: 'uniDatefield',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ISSUE_EXPECTED_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.payingmethod" default="결제방법"/>',
				name: 'RECEIPT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B038',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('RECEIPT_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.slipno" default="전표번호"/>',
				name: 'EX_NUM',
				xtype: 'uniNumberfield',
//				holdable: 'hold',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EX_NUM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				name: 'PROJECT_NO',
				xtype: 'uniTextfield',
//				holdable: 'hold',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PROJECT_NO', newValue);
					}
				}
			},{	//20210318 추가
				fieldLabel	: '세액포함여부',
				xtype		: 'radiogroup',
				holdable	: 'hold',
				items		: [{
					boxLabel	: '포함',
					name		: 'TAX_INOUT',
					inputValue	: '2',
					width		: 70
				},{
					boxLabel	: '별도',
					name		: 'TAX_INOUT',
					inputValue	: '1',
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TAX_INOUT', newValue.TAX_INOUT);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.vatrate" default="부가세율"/>',
				name: 'VAT_RATE',
				xtype: 'uniNumberfield',
				decimalPrecision: 2,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('VAT_RATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.totalsupplyamount" default="총공급가액"/>(1)',
				name: 'AMOUNTI',
				xtype: 'uniNumberfield',
//				holdable: 'hold',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AMOUNTI', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.totalvatamount" default="총부가세액"/>(2)',
				name: 'VATAMOUNTO',
				xtype: 'uniNumberfield',

//				holdable: 'hold',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('VATAMOUNTO', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.totalpruchaseamount" default="총매입액"/>[(1)+(2)]',
				name: 'AMOUNTTOT',
				xtype: 'uniNumberfield',
//				holdable: 'hold',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AMOUNTTOT', newValue);
					}
				}
			},{	//20200901 추가: 계산서유형이 '신용카드매입'일 때, show && 필수
				xtype	: 'container',
				layout	: {type : 'vbox'},
				items	: [
					Unilite.popup('CREDIT_CARD2', {
						fieldLabel	: '신용카드번호',
						name		: 'CREDIT_NUM',
						itemId		: 'CREDIT_NUM',
						textFieldName:'CREDIT_NUM',
						DBvalueFieldName: 'CRDT_NUM',
						DBtextFieldName: 'CRDT_NUM',
						textFieldOnly : true,
						holdable	: 'hold',
						listeners:{
							onSelected: {
								fn: function(records, type) {
									masterForm.setValue('CREDIT_NUM',records[0].CRDT_NUM);
									panelResult.setValue('CREDIT_NUM',records[0].CRDT_NUM);
								},
								scope: this
							},
							onClear: function(type) {
								masterForm.setValue('CREDIT_NUM','');
								panelResult.setValue('CREDIT_NUM', '');
							}
						}
					})
				]
			}]
		}],
		api: {
			load: 's_map100ukrv_wmService.selectForm'
		},
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
	});//End of var masterForm = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		hidden		: !UserInfo.appOption.collapseLeftSearch,
		layout		: {type : 'uniTable', columns : 5
//			,tableAttrs	: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//			,tdAttrs	: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding		: '1 1 1 1',
		border		: true,
		autoScroll	: true,
		items		: [
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				allowBlank		: false,
				holdable		: 'hold',
				width			: 0,
				tdAttrs			: {width: 330},
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							masterForm.setValue('CUSTOM_CODE'	, panelResult.getValue('CUSTOM_CODE'));
							masterForm.setValue('CUSTOM_NAME'	, panelResult.getValue('CUSTOM_NAME'));
							masterForm.setValue('MONEY_UNIT'	, Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
							panelResult.setValue('MONEY_UNIT'	, Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
//							ownNum = records[0]["COMPANY_NUM"].substring(0, 3) + '-' + records[0]["COMPANY_NUM"].substring(3, 5) + '-' + records[0]["COMPANY_NUM"].substring(5);
							masterForm.setValue('COMPANY_NUM'	, records[0]["COMPANY_NUM"]);
							panelResult.setValue('COMPANY_NUM'	, records[0]["COMPANY_NUM"]);

							CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"];
							CustomCodeInfo.gsTaxInclude		= records[0]["TAX_TYPE"];
							CustomCodeInfo.gsTaxCalcType	= records[0]["TAX_CALC_TYPE"];
							CustomCodeInfo.gsBillType		= records[0]["BILL_TYPE"];

							var billType = '51';
							if(!Ext.isEmpty(records[0]["BILL_TYPE"])){
								if(records[0]["BILL_TYPE"] > '50'){
									billType = records[0]["BILL_TYPE"];
								}
							}
							/*******20190717 거래처 화폐와 자국화폐가 다른 경우 수입세금계산서로 세팅*******/
							var vatRate = records[0].VAT_RATE;
							if(Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney) != BsaCodeInfo.gsDefaultMoney){
								billType= '56';
								vatRate	= 0;
							} else if(Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney) == 'KRW'){
								vatRate = 10;
							}
							masterForm.setValue('BILL_TYPE'		, billType);
							panelResult.setValue('BILL_TYPE'	, billType);
							masterForm.setValue('RECEIPT_TYPE'	, records[0]["SET_METH"]);
							panelResult.setValue('RECEIPT_TYPE'	, records[0]["SET_METH"]);
							masterForm.setValue('VAT_RATE'		, vatRate);
							panelResult.setValue('VAT_RATE'		, vatRate);
							//20210318 추가
							masterForm.getField('TAX_INOUT').setValue(records[0]['TAX_CALC_TYPE']);
							panelResult.getField('TAX_INOUT').setValue(records[0]['TAX_CALC_TYPE']);
						},
						scope: this
					},
					onClear: function(type) {
						CustomCodeInfo.gsUnderCalBase = '';
						masterForm.setValue('CUSTOM_CODE'	, '');
						masterForm.setValue('CUSTOM_NAME'	, '');
						masterForm.setValue('MONEY_UNIT'	, '');
						panelResult.setValue('MONEY_UNIT'	, '');
						masterForm.setValue('COMPANY_NUM'	, '');
						panelResult.setValue('COMPANY_NUM'	, '');
						masterForm.setValue('BILL_TYPE'		, '');
						panelResult.setValue('BILL_TYPE'	, '');
						masterForm.setValue('RECEIPT_TYPE'	, '');
						panelResult.setValue('RECEIPT_TYPE'	, '');
						masterForm.setValue('VAT_RATE'		, 10);
						panelResult.setValue('VAT_RATE'		, 10);

						CustomCodeInfo.gsUnderCalBase	= '';
						CustomCodeInfo.gsTaxInclude		= '';
						CustomCodeInfo.gsTaxCalcType	= '';
						CustomCodeInfo.gsBillType		= '';
						//20210318 추가
						masterForm.getField('TAX_INOUT').setValue('2');
						panelResult.getField('TAX_INOUT').setValue('2');
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
					}
				}
			}),
			Unilite.popup('DEPT', {
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
				valueFieldName: 'DEPT_CODE',
				textFieldName: 'DEPT_NAME',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							masterForm.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							masterForm.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
						},
						scope: this
					},
					onClear: function(type) {
						masterForm.setValue('DEPT_CODE', '');
						masterForm.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장

						if(authoInfo == "A"){	//자기사업장
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});

						} else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});

						} else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			})/*,{
				xtype: 'component'
			}*/,{
				xtype: 'component'
			},{
				xtype: 'container' ,
				layout:{type:'hbox', align:'stretched'},
//				width:200,
				colspan: 1,
//				style:{'margin-left':'20px'},
				items:[{
						xtype: 'component',
						width: 85
					},{
						xtype	: 'button',
						text	: '<t:message code="system.label.purchase.purchaseslip" default="매입기표"/>',
						itemId	: 'btnCreate',
						width	: 80,
						handler	: function() {
							var changeBasisNum = masterForm.getValue("CHANGE_BASIS_NUM");
							if(changeBasisNum) {
								var param = {'CHANGE_BASIS_NUM': changeBasisNum};
								s_map100ukrv_wmService.selectForm(param,function(responseText, response) {
									console.log("responseText : ",responseText);
									console.log("response : ",response);
									if(responseText && responseText.data) {
										var masterData = responseText.data;
										if(masterData.EX_NUM && masterData.EX_NUM != 0 ) {
											alert('<t:message code="system.message.purchase.message076" default="이미 기표된 자료입니다."/>');
											UniAppManager.app.onQueryButtonDown()
											return ;
										}
										var params = {
											'PGM_ID'				: 'map100ukrv',					//20210219 수정: 기표로직 타도록 정규 id 사용
											'sGubun'				: '40',
											'DIV_CODE'				: masterForm.getValue("DIV_CODE"),
											'BILL_DATE'				: UniDate.getDateStr(masterForm.getValue("BILL_DATE")),
											'CUSTOM_CODE'			: masterForm.getValue("CUSTOM_CODE"),
											'ACCOUNT_TYPE'			: masterForm.getValue("ACCOUNT_TYPE"),
											'ISSUE_EXPECTED_DATE'	: UniDate.getDateStr(masterForm.getValue("ISSUE_EXPECTED_DATE")),
											'PROC_DATE'				: UniDate.getDateStr(masterForm.getValue("CHANGE_BASIS_DATE")),
											'CHANGE_BASIS_NUM'		: masterForm.getValue("CHANGE_BASIS_NUM")
										}

										var rec = {data : {prgID : 'agj260ukr', 'text':''}};
										parent.openTab(rec, '/accnt/agj260ukr.do', params, CHOST+CPATH);
									} else {
										alert('<t:message code="system.message.purchase.message077" default="초기화중 오류가 발생하였습니다."/>');
									}
								});
							} else {
								alert('<t:message code="system.message.purchase.message078" default="매입번호가 없습니다. 조회 후 실행하세요."/>')
							}
						}
					},{
						xtype	: 'button',
						text	: '<t:message code="system.label.purchase.slipcancel" default="기표취소"/>',
						itemId	: 'btnCancel',
						width	: 80,
						handler:function() {
							var changeBasisNum = masterForm.getValue("CHANGE_BASIS_NUM");
							if(changeBasisNum) {
								var paramNum = {'CHANGE_BASIS_NUM': changeBasisNum};
								s_map100ukrv_wmService.selectForm(paramNum,function(responseText, response) {
									console.log("responseText : ",responseText);
									console.log("response : ",response);
									if(responseText && responseText.data) {
										var masterData = responseText.data;
										if(Ext.isEmpty(masterData.EX_NUM) || masterData.EX_NUM == 0 ) {
											alert('<t:message code="system.message.purchase.message079" default="먼저 자료를 조회하십시요."/>');
											return ;
										}
										var param = {
											'DIV_CODE'			: masterForm.getValue("DIV_CODE"),
											'BILL_DATE'			: UniDate.getDateStr(masterForm.getValue("BILL_DATE")),
											'CUSTOM_CODE'		: masterForm.getValue("CUSTOM_CODE"),
											'ACCOUNT_TYPE'	 : masterForm.getValue("ACCOUNT_TYPE"),
											'ISSUE_EXPECTED_DATE': UniDate.getDateStr(masterForm.getValue("CHANGE_BASIS_DATE")),
											'PROC_DATE': UniDate.getDateStr(masterForm.getValue("CHANGE_BASIS_DATE")),
											'CHANGE_BASIS_NUM'   : masterForm.getValue("CHANGE_BASIS_NUM")
										}
										agj260ukrService.cancelExList(param,function(responseText, response) {
											if(responseText != undefined){
												if(!Ext.isEmpty(responseText.ERROR_DESC)) {
													if(responseText.EBYN_MESSAGE=="FALSE") {
														console.log(responseText.ERROR_DESC);
													}
												} else {
													alert('<t:message code="system.message.purchase.message080" default="기표취소되었습니다."/>');
													UniAppManager.app.onQueryButtonDown();
												}
											}
										});
									}
								});
							} else {
								alert('<t:message code="system.message.purchase.message079" default="먼저 자료를 조회하십시요."/>');
							}
						}
					}
				]
			},{
				xtype: 'component',
				width: 90
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasedivision" default="매입사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('DIV_CODE', newValue);
						var param = {"DIV_CODE": masterForm.getValue('DIV_CODE')};
						s_map100ukrv_wmService.billDivCode(param, function(provider, response) {
							if(!Ext.isEmpty(provider)){
								masterForm.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
								panelResult.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
							}
						});
						masterForm.setValue('DEPT_CODE','');
						masterForm.setValue('DEPT_NAME','');
						panelResult.setValue('DEPT_CODE','');
						panelResult.setValue('DEPT_NAME','');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				name:'BILL_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('BILL_DATE', newValue);
						masterForm.setValue('CHANGE_BASIS_DATE', newValue);
						panelResult.setValue('CHANGE_BASIS_DATE', newValue);
						//20200309 추가: endOfNextMonth, UniDate.extParseDate()
						if(Ext.isDate(newValue)) {
							fnSetIssueExpectedDate(newValue);
						}
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.billno" default="계산서번호"/>',
				name: 'BILL_NUM',
				xtype: 'uniTextfield',
//				holdable: 'hold',
				readOnly: true,
				readOnly: isAutoInoutNum2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('BILL_NUM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.exdate" default="결의일"/>',
				name: 'CHANGE_BASIS_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('CHANGE_BASIS_DATE', newValue);
					}
				}
			},{
				xtype: 'component'
			},{
				xtype: 'component',
				colspan: 5,
				height: 5
			},{
				xtype: 'component',
				colspan: 5,
				tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' }
			},{
//				xtype: 'component'
//			},{
				fieldLabel: '<t:message code="system.label.purchase.purchaseno" default="매입번호"/>',
				name: 'CHANGE_BASIS_NUM',
				xtype: 'uniTextfield',
//				holdable: 'hold',
				readOnly: true,
				readOnly: isAutoInoutNum1,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('CHANGE_BASIS_NUM', newValue);
					}
				}
//				holdable: 'hold'
			},{
				fieldLabel: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>',
				name: 'BILL_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A022',
				allowBlank: false,
//				holdable: 'hold',			//20210513 주석
				width: '325px',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('BILL_TYPE', newValue);
						UniAppManager.app.fnGetBillType(newValue);
						panelResult.setValue('CRDT_NUM', '');
						panelResult.setValue('CRDT_NAME', '');
						masterForm.setValue('CRDT_NUM', '');
						masterForm.setValue('CRDT_NAME', '');

						panelResult.setValue('CREDIT_NUMBER', '');
						masterForm.setValue('CREDIT_NUMBER', '');

						//20200901 추가: 계산서유형이 '신용카드매입'일 때, show && 필수
						var commonCodes = Ext.data.StoreManager.lookup('CBS_AU_A022').data.items;
						var refCode1;
						Ext.each(commonCodes,function(commonCode, i) {
							if(commonCode.get('value') == newValue) {
								refCode1 = commonCode.get('refCode1');
							}
						})
						if(refCode1 != 'E') {
							panelResult.down('#CREDIT_NUM').setHidden(true);
							panelResult.getField('CREDIT_NUM').setConfig('allowBlank', true);
							masterForm.down('#CREDIT_NUM').setHidden(true);
							masterForm.getField('CREDIT_NUM').setConfig('allowBlank', true);
							panelResult.setValue('CREDIT_NUM', '');
							masterForm.setValue('CREDIT_NUM', '');
						} else {
							panelResult.down('#CREDIT_NUM').setHidden(false);
							panelResult.getField('CREDIT_NUM').setConfig('allowBlank', false);
							masterForm.down('#CREDIT_NUM').setHidden(false);
							masterForm.getField('CREDIT_NUM').setConfig('allowBlank', false);
						}

						var param= Ext.getCmp('searchForm').getValues();
						s_map100ukrv_wmService.selectRefCode2(param, function(provider, response) {
							if(!Ext.isEmpty(provider)){
								masterForm.setValue('VAT_RATE'	, provider[0].VAT_RATE);
								panelResult.setValue('VAT_RATE'	, provider[0].VAT_RATE);
							}
							//20210513 추가
							var records = directMasterStore1.data.items;
							directMasterStore1.fnSumAmountI2(records);
						});

						//20210513 추가
						var records = directMasterStore1.data.items;
						Ext.each(records, function(record, idx) {
							record.set('BILL_TYPE', newValue);
						});
					},
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						store.clearFilter();
						store.filterBy(function(record){
						return record.get('refCode3') == '1';
						})
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
				name: 'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B004',
				allowBlank: false,
				displayField: 'value',
				holdable: 'hold',
				fieldStyle: 'text-align: center;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('MONEY_UNIT', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasetype" default="매입유형"/>',
				name: 'ACCOUNT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M302',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						UniAppManager.app.fnGetAccountType(newValue);
						masterForm.setValue('ACCOUNT_TYPE', newValue);
//						if(newValue == '10' ){
//							masterForm.setValue('BILL_TYPE', '51');
//						}
					}
				}
			},{
				xtype: 'component'
			},{
				fieldLabel: '<t:message code="system.label.purchase.declaredivsion" default="신고사업장"/>',
				name: 'BILL_DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
//				holdable: 'hold',
				allowBlank: false,
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>',
				name: 'COMPANY_NUM',
				xtype: 'uniTextfield',
//				holdable: 'hold',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('COMPANY_NUM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasepostdate" default="매입기표일"/>',
				name: 'EX_DATE',
				xtype: 'uniDatefield',
//				holdable: 'hold',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('EX_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>',
				name: 'ISSUE_EXPECTED_DATE',
				xtype: 'uniDatefield',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('ISSUE_EXPECTED_DATE', newValue);
					}
				}
			},{	//20210318 수정: 세액포함여부 필드 추가로 위치 변경
				fieldLabel	: '<t:message code="system.label.purchase.totalsupplyamount" default="총공급가액"/>(1)',
				name		: 'AMOUNTI',
				xtype		: 'uniNumberfield',
//				holdable	: 'hold',
				readOnly	: true,
				labelWidth	: 100,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('AMOUNTI', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.payingmethod" default="결제방법"/>',
				name: 'RECEIPT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B038',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('RECEIPT_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.slipno" default="전표번호"/>',
				name: 'EX_NUM',
				xtype: 'uniNumberfield',
//				holdable: 'hold',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('EX_NUM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				name: 'PROJECT_NO',
				xtype: 'uniTextfield',
//				holdable: 'hold',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('PROJECT_NO', newValue);
					}
				}
			},{	//20200901 추가: 계산서유형이 '신용카드매입'일 때, show && 필수
				xtype	: 'container',
				layout	: {type:'uniTable', columns:1},
				items	: [
					Unilite.popup('CREDIT_CARD2', {
					fieldLabel	: '신용카드번호',
					itemId		: 'CREDIT_NUM',
					name		: 'CREDIT_NUM',
					textFieldName:'CREDIT_NUM',
					DBvalueFieldName: 'CRDT_NUM',
					DBtextFieldName: 'CRDT_NUM',
					textFieldOnly : true,
					textFieldWidth: 150,
					holdable	: 'hold',
					listeners:{
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('CREDIT_NUM',records[0].CRDT_NUM);
								panelResult.setValue('CREDIT_NUM',records[0].CRDT_NUM);
							},
							scope: this
						},
						onClear: function(type) {
							masterForm.setValue('CREDIT_NUM','');
							panelResult.setValue('CREDIT_NUM', '');
						}
					}
				})]
//			},{
//				xtype: 'component'
			},{	//20210318 수정: 세액포함여부 필드 추가로 위치 변경 
				fieldLabel		: '<t:message code="system.label.purchase.totalvatamount" default="총부가세액"/>(2)',
				name			: 'VATAMOUNTO',
				xtype			: 'uniNumberfield',
//				decimalPrecision: 2,
//				holdable		: 'hold',
				readOnly		: true,
				labelWidth		: 100,
				listeners		: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('VATAMOUNTO', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.vatrate" default="부가세율"/>',
				name: 'VAT_RATE',
				xtype: 'uniNumberfield',
				decimalPrecision: 2,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('VAT_RATE', newValue);
					}
				}
			},{	//20210318 추가
				fieldLabel	: '세액포함여부',
				xtype		: 'radiogroup',
//				holdable	: 'hold',			//20210513 주석
				items		: [{
					boxLabel	: '포함',
					name		: 'TAX_INOUT',
					inputValue	: '2',
					width		: 70
				},{
					boxLabel	: '별도',
					name		: 'TAX_INOUT',
					inputValue	: '1',
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('TAX_INOUT', newValue.TAX_INOUT);
						//20210513 추가
						var records = directMasterStore1.data.items;
						directMasterStore1.fnSumAmountI2(records, newValue.TAX_INOUT);
					}
				}
			},{
				xtype	: 'component',
				colspan	: 2
			},{	//20210318 수정: 세액포함여부 필드 추가로 위치 변경 후, 주석
//				fieldLabel: '<t:message code="system.label.purchase.totalsupplyamount" default="총공급가액"/>(1)',
//				name: 'AMOUNTI',
//				xtype: 'uniNumberfield',
////				holdable: 'hold',
//				readOnly: true,
//				listeners: {
//					change: function(field, newValue, oldValue, eOpts) {
//						masterForm.setValue('AMOUNTI', newValue);
//					}
//				}
//			},{	//20210318 수정: 세액포함여부 필드 추가로 위치 변경 후, 주석
//				fieldLabel: '<t:message code="system.label.purchase.totalvatamount" default="총부가세액"/>(2)',
//				name: 'VATAMOUNTO',
//				xtype: 'uniNumberfield',
//				//decimalPrecision: 2,
////				holdable: 'hold',
//				readOnly: true,
//				listeners: {
//					change: function(field, newValue, oldValue, eOpts) {
//						masterForm.setValue('VATAMOUNTO', newValue);
//					}
//				}
//			},{
				fieldLabel: '<t:message code="system.label.purchase.totalpruchaseamount" default="총매입액"/>[(1)+(2)]',
				labelWidth:100,
				name: 'AMOUNTTOT',
				xtype: 'uniNumberfield',
//				holdable: 'hold',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('AMOUNTTOT', newValue);
					}
				}
			}
		],
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
	});

	var buyslipNoSearch = Unilite.createSearchForm('buyslipNoSearchForm', {				//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns: 3},		//20210315 수정: 검색조건 '고객명' 추가
		trackResetOnLoad: true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.purchasedivision" default="매입사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			colspan: 3
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName: 'CUSTOM_CODE',
			textFieldName: 'CUSTOM_NAME',
			validateBlank: false,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				}
			}
		}),
		Unilite.popup('DEPT', {
			fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
			valueFieldName: 'DEPT_CODE',
			textFieldName: 'DEPT_NAME',
			validateBlank: false,
			colspan: 2,
			listeners: {
				applyextparam: function(popup){
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장

					if(authoInfo == "A"){	//자기사업장
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});

					} else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});

					} else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.purchase.exdate" default="결의일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'CHANGE_BASIS_DATE_FR',
			endFieldName: 'CHANGE_BASIS_DATE_TO'
		},{
			fieldLabel: '<t:message code="system.label.purchase.billno" default="계산서번호"/>',
			name: 'BILL_NUM',
			xtype: 'uniTextfield',
			colspan: 2
		},{
			fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'BILL_DATE_FR',
			endFieldName: 'BILL_DATE_TO'
		},
		Unilite.popup('', {
			fieldLabel: '<t:message code="system.label.purchase.manageno" default="관리번호"/>',
			validateBlank: false
		}),{//20210315 추가
			fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_PRSN',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]
	});

	var receivehistorySearch = Unilite.createSearchForm('receivehistoryForm', {			//입고내역참조
		layout:  {type: 'uniTable', columns: 3},
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'INOUT_DATE_FR',
			endFieldName: 'INOUT_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},{
			fieldLabel: '<t:message code="system.label.purchase.taxtype" default="세구분"/>',
			name: 'TAX_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B059',
			fieldStyle: 'text-align: center;',
			holdable: 'hold'/*,
			//20200217 추가: mainGrid에 set할 때 전역변수에 넣어서 사용하는데.... 없을 경우 계산 오류 발생 가능하여 필수로 변경
			allowBlank: false*//*,
			readOnly:true*/
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			validateBlank: false
		}),{
			fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name: 'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M001',
			value: '1',
			allowBlank: false
		},{	//20210225 추가
			fieldLabel	: '고객명',
			name		: 'CUSTOM_PRSN',
			xtype		: 'uniTextfield'
		},{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.purchase.badincludedflag" default="불량포함여부"/>',
			id: 'rdoSelect',
			items: [
				{boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>', width: 60, name: 'rdoSelect', inputValue: 'Y', checked: true},
				{boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>', width: 60,  name: 'rdoSelect', inputValue: 'N'}
			]
		},{
			fieldLabel: '<t:message code="system.label.purchase.totalsupplyamount" default="총공급가액"/>',
			name: 'AMOUNTI',
			xtype: 'uniNumberfield',
			readOnly: true
		},
		{
			fieldLabel: '<t:message code="system.label.purchase.totalvatamount" default="총부가세액"/>',
			name: 'VATAMOUNTO',
			xtype: 'uniNumberfield',
			readOnly: true
		},{
			fieldLabel: '<t:message code="system.label.purchase.totalpruchaseamount" default="총매입액"/>',
			name: 'AMOUNTTOT',
			xtype: 'uniNumberfield',
			readOnly: true
		},{
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			name: 'CUSTOM_CODE',
			xtype: 'uniTextfield',
			hidden: true
		},{
			fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
			name: 'MONEY_UNIT',
			xtype: 'uniTextfield',
			hidden: true
		},{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniTextfield',
			hidden: true
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
	});

	var returninghistorySearch = Unilite.createSearchForm('returninghistoryForm', {		//반품내역참조
		layout:  {type: 'uniTable', columns: 4},
		items: [
			{
			fieldLabel: '<t:message code="system.label.purchase.returndate" default="반품일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'INOUT_DATE_FR',
			endFieldName: 'INOUT_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},{
			fieldLabel: '<t:message code="system.label.purchase.taxtype" default="세구분"/>',
			name: 'TAX_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B059',
			allowBlank: false,
			fieldStyle: 'text-align: center;',
			holdable: 'hold'/*,
			readOnly:true*/
		},
		Unilite.popup('',{
			fieldLabel: '<t:message code="system.label.purchase.manageno" default="관리번호"/>',
			validateBlank: false,
			colspan: 2
		}),
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			validateBlank: false
		}),{
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			name: 'CUSTOM_CODE',
			xtype: 'uniTextfield',
			hidden: true
		},{
			fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
			name: 'MONEY_UNIT',
			xtype: 'uniTextfield',
			hidden: true
		},{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniTextfield',
			hidden: true
		}/* ,{
			fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name: 'ORDER_TYPE',
			xtype: 'uniTextfield',
			hidden: true
		} */],
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
	});

	var orderhistorySearch = Unilite.createSearchForm('orderhistoryForm', {				//발주내역참조
		layout:  {type: 'uniTable', columns: 4},
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},{
			fieldLabel: '<t:message code="system.label.purchase.taxtype" default="세구분"/>',
			name: 'TAX_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B059',
			fieldStyle: 'text-align: center;',
			colspan: 3
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			validateBlank: false
		}),
		Unilite.popup('',{
			fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
			name: 'PROJECT_NO',
			validateBlank: false,
			colspan: 3
		}),{
			fieldLabel: '<t:message code="system.label.purchase.totalvatamount" default="총부가세액"/>',
			name: 'VATAMOUNTO',
			xtype: 'uniNumberfield',
			readOnly: true
		},{
			fieldLabel: '<t:message code="system.label.purchase.totalsupplyamount" default="총공급가액"/>',
			name: 'AMOUNTI',
			xtype: 'uniNumberfield',
			readOnly: true
		},{
			fieldLabel: '<t:message code="system.label.purchase.totalpruchaseamount" default="총매입액"/>',
			name: 'AMOUNTTOT',
			xtype: 'uniNumberfield',
			readOnly: true
		},{
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			name: 'CUSTOM_CODE',
			xtype: 'uniTextfield',
			hidden: true
		},{
			fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
			name: 'MONEY_UNIT',
			xtype: 'uniTextfield',
			hidden: true
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_map100ukrv_wmGrid1', {
		layout: 'fit',
		region:'center',
		excelTitle: '<t:message code="system.label.purchase.eachpurchaseslipentry" default="개별 매입지급결의 등록"/>',
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
		tbar: [{
				itemId: 'receivehistoryBtn',
				text: '<div style="color: blue"><t:message code="system.label.purchase.receiptdetailsrefer" default="입고내역참조"/></div>',
				handler: function() {
					if(masterForm.setAllFieldsReadOnly(true) == false){
						return false;
					}
					openReceiveHistoryWindow();
				}
			},{	//20200304 수정: 주석 해제 - 상세 내용은 한차장님 오시면 테스트 후 수정
				itemId	: 'orderhistoryBtn',
				id		: 'orderhistoryBtn',
				//20200310 로직정의될때까지 주석
				hidden	: true,
				text	: '<div style="color: blue"><t:message code="system.label.purchase.purchasedetailsrefer" default="발주내역참조"/></div>',
				handler	: function() {
					if(masterForm.setAllFieldsReadOnly(true) == false){
						return false;
					}
					openOrderHistoryWindow();
				}
			}],
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'CHANGE_BASIS_NUM'	, width: 93	, hidden: true },
			{dataIndex: 'CHANGE_BASIS_SEQ'	, width: 66	, align: 'center' },
			{dataIndex: 'INSTOCK_DATE'		, width: 80},
			{dataIndex: 'ITEM_ACCOUNT'		, width: 66	, hidden: true  },
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 300},
			{dataIndex: 'SPEC'				, width: 88},
			{dataIndex: 'TAX_TYPE'			, width: 53	, align: 'center'},
			{dataIndex: 'ORDER_UNIT'		, width: 88	, align: 'center'},
			{dataIndex: 'ORDER_UNIT_Q'		, width: 100},
			{dataIndex: 'REMAIN_Q'			, width: 80	, hidden: true},
			{dataIndex: 'ORDER_UNIT_P'		, width: 86 },
			{dataIndex: 'AMOUNT_P'			, width: 100, hidden: true},
			{dataIndex: 'AMOUNT_I'			, width: 100},
			{dataIndex: 'TAX_I'				, width: 80},
			{dataIndex: 'TOTAL_I'			, width: 120},
			//20210216 추가: CUSTOM_PRSN, PHONE, BANK_NAME, BANK_ACCOUNT, BIRTHDAY, ZIP_CODE, ADDR1, 20210219 수정: 위치 변경 / show
			{dataIndex: 'CUSTOM_PRSN'		, width: 100},
			{dataIndex: 'PHONE'				, width: 110, hidden: false},
			{dataIndex: 'BANK_NAME'			, width: 100, hidden: false},
			{dataIndex: 'BANK_ACCOUNT'		, width: 120, hidden: false},
			{dataIndex: 'BIRTHDAY'			, width: 100, hidden: false},
			{dataIndex: 'ZIP_CODE'			, width: 100, hidden: false	,
				//20210222 추가: 팝업으로 변경
				editor: Unilite.popup('ZIP_G',{
					textFieldName	: 'ZIP_CODE',
					DBtextFieldName	: 'ZIP_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ADDR1'	, records[0]['ZIP_NAME'] + (Ext.isEmpty(records[0]['ADDR2']) ? '':' ' + records[0]['ADDR2']));
								grdRecord.set('ZIP_CODE', records[0]['ZIP_CODE']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ADDR1'	, '');
							grdRecord.set('ZIP_CODE', '');
						},
						applyextparam: function(popup){
							var grdRecord	= masterGrid.uniOpt.currentRecord;
							var paramAddr	= grdRecord.get('ADDR1'); //우편주소 파라미터로 넘기기
							if(Ext.isEmpty(paramAddr)){
								popup.setExtParam({'GBN': 'post'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
							} else {
								popup.setExtParam({'GBN': 'addr'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
							}
							popup.setExtParam({'ADDR': paramAddr});
						}
					}
				})
			},
			{dataIndex: 'ADDR1'				, width: 250, hidden: false},
			{dataIndex: 'ORDER_UNIT_FOR_P'	, width: 133},
			{dataIndex: 'FOREIGN_P'			, width: 100, hidden: true},
			{dataIndex: 'FOR_AMOUNT_O'		, width: 100},
			{dataIndex: 'MONEY_UNIT'		, width: 53	, align: 'center'},
			{dataIndex: 'EXCHG_RATE_O'		, width: 80},
			{dataIndex: 'STOCK_UNIT'		, width: 80	, align: 'center'},
			{dataIndex: 'TRNS_RATE'			, width: 80},
			{dataIndex: 'BUY_Q'				, width: 100},
			{dataIndex: 'ORDER_TYPE'		, width: 66	, align: 'center'},
			{dataIndex: 'ORDER_PRSN'		, width: 66	, align: 'center', hidden: true},
			{dataIndex: 'LC_NUM'			, width: 86	, hidden: true},
			{dataIndex: 'BL_NUM'			, width: 86	, hidden: true},
			{dataIndex: 'ORDER_NUM'			, width: 93	, hidden: true},
			{dataIndex: 'ORDER_SEQ'			, width: 33	, hidden: true},
			{dataIndex: 'INOUT_NUM'			, width: 130},
			{dataIndex: 'INOUT_SEQ'			, width: 66},
			{dataIndex: 'DIV_CODE'			, width: 33	, hidden: true},
			{dataIndex: 'BILL_DIV_CODE'		, width: 33	, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 33	, hidden: true},
			{dataIndex: 'REMARK'			, width: 133},
			{dataIndex: 'PROJECT_NO'		, width: 133},
			{dataIndex: 'UPDATE_DB_USER'	, width: 33	, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 33	, hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 33	, hidden: true},
			{dataIndex: 'ADVAN_YN'			, width: 53	, hidden: true},
			{dataIndex: 'ADVAN_AMOUNT'		, width: 53	, hidden: true},
			{dataIndex: 'PURCHASE_TYPE'		, width: 53	, align: 'center', hidden: true},
			{dataIndex: 'INOUT_TYPE'		, width: 53	, align: 'center', hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				//20210222 추가: CUSTOM_PRSN, PHONE, BANK_NAME, BANK_ACCOUNT, BIRTHDAY, ZIP_CODE, ADDR1 수정 / 저장가능하도록 변경
				if(UniUtils.indexOf(e.field, ['CUSTOM_PRSN', 'PHONE', 'BANK_NAME', 'BANK_ACCOUNT', 'BIRTHDAY', 'ZIP_CODE', 'ADDR1'])){
					return true;
				}
				if(e.record.phantom){
					if(UniUtils.indexOf(e.field, ['TAX_I'])){
						return true;
					} else {
						return false;
					}
				} else {
					return false;
				}
			}
		},
		setItemData: function(record, dataClear) {
			var grdRecord = this.getSelectedRecord();
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		,"");
				grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('STOCK_UNIT'		,"");
				grdRecord.set('ORDER_Q'			,0);
				grdRecord.set('ORDER_P'			,0);
				grdRecord.set('ORDER_WGT_Q'		,0);
				grdRecord.set('ORDER_WGT_P'		,0);
				grdRecord.set('ORDER_VOL_Q'		,0);
				grdRecord.set('ORDER_VOL_P'		,0);
				grdRecord.set('ORDER_O'			,0);
				grdRecord.set('PROD_SALE_Q'		,0);
				grdRecord.set('PROD_Q'			,0);
				grdRecord.set('STOCK_Q'			,0);
				grdRecord.set('DISCOUNT_RATE'	,0);
				grdRecord.set('WGT_UNIT'		,"");
				grdRecord.set('UNIT_WGT'		,0);
				grdRecord.set('VOL_UNIT'		,"");
				grdRecord.set('UNIT_VOL'		,0);
			} else {
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('ORDER_UNIT'			, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);
				grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
				// grdRecord.set('OUT_DIV_CODE' ,record['DIV_CODE']);
				grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
				grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
				grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
				grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
				grdRecord.set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));

				UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
			}
		},
		//20200217 적용로직 변경
		setReceiveData: function(records){
			var newDetailRecords = new Array();
			var cbNo = masterForm.getValue('CHANGE_BASIS_NUM');
			var seq = directMasterStore1.max('CHANGE_BASIS_SEQ');
			if(!seq) seq = 1;
			else  seq += 1;

			Ext.each(records, function(record, i){
				if(i == 0){
					seq = seq;
				} else {
					seq += 1;
				}
				var r = {
					CHANGE_BASIS_NUM : cbNo,
					CHANGE_BASIS_SEQ : seq
				};

				newDetailRecords[i] = directMasterStore1.model.create( r );
				masterForm.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
				//20200220 로직 추가: 참조 적용 후에는 수정가능하도록 변경
				masterForm.getField('ACCOUNT_TYPE').setReadOnly(false);
				panelResult.getField('ACCOUNT_TYPE').setReadOnly(false);

				newDetailRecords[i].set('CHANGE_BASIS_NUM'	, masterForm.getValue('CHANGE_BASIS_NUM'));
				newDetailRecords[i].set('INOUT_NUM'			, record.data['INOUT_NUM']);
				newDetailRecords[i].set('INOUT_SEQ'			, record.data['INOUT_SEQ']);
				newDetailRecords[i].set('INSTOCK_DATE'		, record.data['INSTOCK_DATE']);
				newDetailRecords[i].set('ITEM_ACCOUNT'		, record.data['ITEM_ACCOUNT']);
				newDetailRecords[i].set('ITEM_CODE'			, record.data['ITEM_CODE']);
				newDetailRecords[i].set('ITEM_NAME'			, record.data['ITEM_NAME']);
				newDetailRecords[i].set('SPEC'				, record.data['SPEC']);
				newDetailRecords[i].set('ORDER_UNIT'		, record.data['ORDER_UNIT']);
				newDetailRecords[i].set('TAX_TYPE'			, record.data['TAX_TYPE']);
				newDetailRecords[i].set('TRNS_RATE'			, record.data['TRNS_RATE']);
				newDetailRecords[i].set('ORDER_UNIT_Q'		, record.data['REMAIN_Q']);
				newDetailRecords[i].set('REMAIN_Q'			, record.data['REMAIN_Q']);
				newDetailRecords[i].set('ORDER_UNIT_P'		, record.data['ORDER_UNIT_P']);
				newDetailRecords[i].set('ORDER_UNIT_FOR_P'	, record.data['ORDER_UNIT_FOR_P']);
				newDetailRecords[i].set('ORDER_UNIT_P'		, record.data['ORDER_UNIT_P']);
				newDetailRecords[i].set('AMOUNT_I'			, record.data['AMOUNT_I']);
				if(record.data['TAX_TYPE'] == '1'){
					//20191226 재계산 없이 그대로 값이 set 되도록 수정: 기존에 주석되어 있던 로직 원복
					newDetailRecords[i].set('TAX_I'			, record.data['INOUT_TAX_AMT']);
//					newDetailRecords[i].set('TAX_I'			, record.data['AMOUNT_I'] * (masterForm.getValue('VAT_RATE') / 100));
				} else {
					newDetailRecords[i].set('TAX_I'			, 0);
				}
				//20191226 합계금액 계산로직 원복
//				newDetailRecords[i].set('TOTAL_I'			, newDetailRecords[i].get('AMOUNT_I'));
				//20210317 수정: 거래처의 TAX_TYPE(포함/별도)에 따라 구별하여 작업 진행
				if(CustomCodeInfo.gsTaxCalcType == '1') {
					newDetailRecords[i].set('TOTAL_I'			, newDetailRecords[i].get('AMOUNT_I') + newDetailRecords[i].get('TAX_I'));
				} else {
					newDetailRecords[i].set('TOTAL_I'			, newDetailRecords[i].get('AMOUNT_I'));
				}
				newDetailRecords[i].set('FOREIGN_P'			, record.data['FOREIGN_P']);
				newDetailRecords[i].set('FOR_AMOUNT_O'		, record.data['FOR_AMOUNT_O']);
				newDetailRecords[i].set('MONEY_UNIT'		, record.data['MONEY_UNIT']);
				newDetailRecords[i].set('EXCHG_RATE_O'		, record.data['EXCHG_RATE_O']);
				newDetailRecords[i].set('BUY_Q'				, record.data['BUY_Q']);
				newDetailRecords[i].set('STOCK_UNIT'		, record.data['STOCK_UNIT']);
				newDetailRecords[i].set('ORDER_TYPE'		, record.data['ORDER_TYPE']);
				newDetailRecords[i].set('ORDER_PRSN'		, record.data['ORDER_PRSN']);
				newDetailRecords[i].set('LC_NUM'			, record.data['LC_NUM']);
				newDetailRecords[i].set('BL_NUM'			, record.data['BL_NUM']);
				newDetailRecords[i].set('ORDER_NUM'			, record.data['ORDER_NUM']);
				newDetailRecords[i].set('ORDER_SEQ'			, record.data['ORDER_SEQ']);
				newDetailRecords[i].set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));
				newDetailRecords[i].set('BILL_DIV_CODE'		, masterForm.getValue('BILL_DIV_CODE'));
				newDetailRecords[i].set('CUSTOM_CODE'		, masterForm.getValue('CUSTOM_CODE'));
				newDetailRecords[i].set('AMOUNT_P'			, record.data['AMOUNT_P']);
				CustomCodeInfo.gsTaxCalcType = record['TAX_CALC_TYPE'];
				newDetailRecords[i].set('ADVAN_YN'			, 'N');
				newDetailRecords[i].set('ADVAN_AMOUNT'		, record.data['ADVAN_AMOUNT']);
				//20210216 추가: CUSTOM_PRSN, PHONE, BANK_NAME, BANK_ACCOUNT, BIRTHDAY, ZIP_CODE, ADDR1
				newDetailRecords[i].set('CUSTOM_PRSN'		, record.data['CUSTOM_PRSN']);
				newDetailRecords[i].set('PHONE'				, record.data['PHONE']);
				newDetailRecords[i].set('BANK_NAME'			, record.data['BANK_NAME']);
				newDetailRecords[i].set('BANK_ACCOUNT'		, record.data['BANK_ACCOUNT']);
				newDetailRecords[i].set('BIRTHDAY'			, record.data['BIRTHDAY']);
				newDetailRecords[i].set('ZIP_CODE'			, record.data['ZIP_CODE']);
				newDetailRecords[i].set('ADDR1'				, record.data['ADDR1']);

				if(record['PROJECT_NO'] != ''){
					newDetailRecords[i].set('PROJECT_NO'	, record.data['PROJECT_NO']);
				} else {
					if(masterForm.getValue('PROJECT_NO') != ''){
						newDetailRecords[i].set('PROJECT_NO', masterForm.getValue('PROJECT_NO'));
					}
				}
				newDetailRecords[i].set('REMARK'			, record.data['REMARK']);
				newDetailRecords[i].set('PURCHASE_TYPE'		, record.data['PURCHASE_TYPE']);
				newDetailRecords[i].set('INOUT_TYPE'		, record.data['INOUT_TYPE']);
				
				if(!Ext.isEmpty(record.data['BILL_TYPE'])) {
					masterFrom.setValue('BILL_TYPE'	, record.data['BILL_TYPE']);
					panelResult.setValue('BILL_TYPE', record.data['BILL_TYPE']);
				} else if(receivehistorySearch.getValue('TAX_TYPE' == '1')){
					masterFrom.setValue('BILL_TYPE'	, '51');
					panelResult.setValue('BILL_TYPE', '51');
				} else if(receivehistorySearch.getValue('TAX_TYPE' == '2')){
					masterFrom.setValue('BILL_TYPE'	, '57');
					panelResult.setValue('BILL_TYPE', '57');
				}
	
				//20200211 로직 추가: 신규행일 경우에는 계산서일, 결의일 수정가능하게 변경
				if((masterGrid.getStore().data.items[0] && masterGrid.getStore().data.items[0].phantom) || (!masterGrid.getStore().data.items[0])) {
					panelResult.getField('BILL_DATE').setReadOnly(false);
					panelResult.getField('CHANGE_BASIS_DATE').setReadOnly(false);
				}
			});
			directMasterStore1.loadData(newDetailRecords, true);

			directMasterStore1.fnSumAmountI(newDetailRecords);
			directMasterStore1.fnSumAmountIForm();
		},
		setReturningData: function(record){
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('CHANGE_BASIS_NUM'	, masterForm.getValue('CHANGE_BASIS_NUM'));
	//		grdRecord.set('CHANGE_BASIS_SEQ'	, lSerNo); 추후
			grdRecord.set('INOUT_NUM'			, record['INOUT_NUM']);
			grdRecord.set('INOUT_SEQ'			, record['INOUT_SEQ']);
			grdRecord.set('INSTOCK_DATE'		, record['INSTOCK_DATE']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('ORDER_UNIT_Q'		, record['REMAIN_Q'] * -1);
			grdRecord.set('REMAIN_Q'			, record['REMAIN_Q'] * -1);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['ORDER_UNIT_FOR_P']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P']);
			grdRecord.set('AMOUNT_I'			, record['INOUT_I'] * -1);
			grdRecord.set('TAX_I'				, record['INOUT_TAX_AMT'] * -1);
			grdRecord.set('TOTAL_I'				, record['TOTAL_INOUT_I'] * -1);
			grdRecord.set('FOREIGN_P'			, record['FOREIGN_P']);
			grdRecord.set('FOR_AMOUNT_O'		, record['FOR_AMOUNT_O'] * -1);
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('EXCHG_RATE_O'		, record['EXCHG_RATE_O']);
			grdRecord.set('BUY_Q'				, record['BUY_Q'] * -1);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_PRSN'			, record['ORDER_PRSN']);
			grdRecord.set('LC_NUM'				, record['LC_NUM']);
			grdRecord.set('BL_NUM'				, record['BL_NUM']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));
			grdRecord.set('BILL_DIV_CODE'		, masterForm.getValue('BILL_DIV_CODE'));
			grdRecord.set('CUSTOM_CODE'			, masterForm.getValue('CUSTOM_CODE'));
			grdRecord.set('AMOUNT_P'			, record['AMOUNT_P']);
			CustomCodeInfo.gsTaxCalcType = record['TAX_CALC_TYPE'];
			grdRecord.set('ADVAN_YN'			, 'N');
			grdRecord.set('ADVAN_AMOUNT'		, record['ADVAN_AMOUNT']);
			if(record['PROJECT_NO'] != ''){
				grdRecord.set('PROJECT_NO'		, record['PROJECT_NO']);
			} else {
				if(masterForm.getValue('PROJECT_NO') != ''){
					grdRecord.set('PROJECT_NO'	, masterForm.getValue('PROJECT_NO'));
				}
			}
			grdRecord.set('REMARK'			, record['REMARK']);
			grdRecord.set('PURCHASE_TYPE'	, record['PURCHASE_TYPE']);
			grdRecord.set('INOUT_TYPE'		, record['INOUT_TYPE']);

			if(returninghistorySearch.getValue('TAX_TYPE' == '1')){
				masterFrom.setValue('BILL_TYPE','51');
				panelResult.setValue('BILL_TYPE','51');
			} else if(returninghistorySearch.getValue('TAX_TYPE' == '2')){
				masterFrom.setValue('BILL_TYPE','57');
				panelResult.setValue('BILL_TYPE','57');
			}
//			directMasterStore1.fnSumAmountI(grdRecord);
		},
		setOrderData: function(record){
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('CHANGE_BASIS_NUM'	, masterForm.getValue('CHANGE_BASIS_NUM'));
	//		grdRecord.set('CHANGE_BASIS_SEQ'	, lSerNo); 추후
			grdRecord.set('INOUT_NUM'			, '');
			grdRecord.set('INOUT_SEQ'			, '');
			grdRecord.set('INSTOCK_DATE'		, '');
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('ORDER_UNIT_Q'		, record['REMAIN_Q']);
			grdRecord.set('REMAIN_Q'			, record['REMAIN_Q']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['ORDER_UNIT_P']);
			grdRecord.set('AMOUNT_I'			, record['LOG_AMT']);
			grdRecord.set('FOREIGN_P'			, record['ORDER_UNIT_P']);
			grdRecord.set('FOR_AMOUNT_O'		, record['LOG_AMT']);
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('EXCHG_RATE_O'		, record['EXCHG_RATE_O']);
			grdRecord.set('BUY_Q'				, record['REMAIN_Q']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_PRSN'			, record['ORDER_PRSN']);
			grdRecord.set('LC_NUM'				, record['LC_NUM']);
			grdRecord.set('BL_NUM'				, '');
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));
			grdRecord.set('BILL_DIV_CODE'		, masterForm.getValue('BILL_DIV_CODE'));
			grdRecord.set('CUSTOM_CODE'			, masterForm.getValue('CUSTOM_CODE'));
			grdRecord.set('ADVAN_YN'			, 'Y');
			grdRecord.set('AMOUNT_P'			, record['ORDER_UNIT_P']);

			if(record['PROJECT_NO'] != ''){
				grdRecord.set('PROJECT_NO'		, record['PROJECT_NO']);
			} else {
				if(masterForm.getValue('PROJECT_NO') != ''){
					grdRecord.set('PROJECT_NO'	, masterForm.getValue('PROJECT_NO'));
				}
			}
			grdRecord.set('REMARK'			, record['REMARK']);
		},
		setProviderData: function(record, params) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('INOUT_NUM'			, record['INOUT_NUM']);
			grdRecord.set('INOUT_SEQ'			, record['INOUT_SEQ']);
			grdRecord.set('INOUT_TYPE'			, record['INOUT_TYPE']);		//20210607 추가
			grdRecord.set('INSTOCK_DATE'		, record['INOUT_DATE']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('TAX_TYPE'			, record['BPR_TAX_TYPE']);		//20210607 추가
			grdRecord.set('BUY_Q'				, record['INOUT_Q']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('ORDER_UNIT_Q'		, record['ORDER_UNIT_Q']);
			grdRecord.set('REMAIN_Q'			, record['ORDER_UNIT_Q']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['ORDER_UNIT_FOR_P']);
			grdRecord.set('AMOUNT_P'			, record['INOUT_P']);
			grdRecord.set('AMOUNT_I'			, record['INOUT_I']);			//////////////////
			if(record['TAX_TYPE'] == '1'){
				grdRecord.set('TAX_I'			, record['INOUT_I'] * (masterForm.getValue('VAT_RATE') / 100));
			} else {
				grdRecord.set('TAX_I'			, 0);
			}
			grdRecord.set('TOTAL_I'				, record['ORDER_UNIT_I']);
			grdRecord.set('FOREIGN_P'			, record['INOUT_FOR_P']);
			grdRecord.set('FOR_AMOUNT_O'		, record['INOUT_FOR_O']);
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('EXCHG_RATE_O'		, record['EXCHG_RATE_O']);
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('LC_NUM'				, record['LC_NUM']);
			grdRecord.set('BL_NUM'				, record['BL_NUM']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));
			grdRecord.set('BILL_DIV_CODE'		, masterForm.getValue('BILL_DIV_CODE'));
			grdRecord.set('CUSTOM_CODE'			, masterForm.getValue('CUSTOM_CODE'));
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			//20210421 추가: 지급결의 등록 시, 입고등록 한 고객정보 가져와서 MAP200T에 insert 하도록 수정
			grdRecord.set('CUSTOM_PRSN'			, record['CUSTOM_PRSN']);
			grdRecord.set('PHONE'				, record['PHONE']);
			grdRecord.set('BANK_NAME'			, record['BANK_NAME']);
			grdRecord.set('BANK_ACCOUNT'		, record['BANK_ACCOUNT']);
			grdRecord.set('ADDR1'				, record['ADDR1']);
			grdRecord.set('BIRTHDAY'			, record['BIRTHDAY']);
			grdRecord.set('ZIP_CODE'			, record['ZIP_CODE']);
			grdRecord.set('ADDR1'				, record['ADDR1']);				//20210607 추가
			directMasterStore1.fnSumAmountI(grdRecord);
		}
	});//End of var masterGrid = Unilite.createGrid('s_map100ukrv_wmGrid1', {

	var buyslipNoMasterGrid = Unilite.createGrid('s_map100ukrv_wmbuyslipNoMasterGrid', {	//조회버튼 누르면 나오는 조회창
		layout		: 'fit',
		excelTitle	: '<t:message code="system.label.purchase.eachpurchaseslipentry" default="개별 매입지급결의 등록"/>(<t:message code="system.label.purchase.purchaseslipsearch" default="매입전표번호검색"/>)',
		store		: buyslipNoMasterStore,
		uniOpt		: {
			expandLastColumn: true,
			useRowNumberer	: true
		},
		columns:  [
			{ dataIndex: 'CUSTOM_NAME'			, width:153},
			{ dataIndex: 'CHANGE_BASIS_DATE' 	, width:93},
			{ dataIndex: 'MONEY_UNIT'			, width:53,align:'center', hidden:true},
			{ dataIndex: 'AMOUNT_I'				, width:126},
			{ dataIndex: 'BILL_NUM'				, width:100},
			{ dataIndex: 'BILL_DATE'			, width:93},
			{ dataIndex: 'CHANGE_BASIS_NUM'		, width:130},
			{ dataIndex: 'DIV_CODE'				, width:66, hidden:true},
			{ dataIndex: 'BILL_DIV_CODE'		, width:66, hidden:true},
			{ dataIndex: 'CUSTOM_CODE'			, width:53, hidden:true},
			{ dataIndex: 'COMPANY_NUM'			, width:80, hidden:true},
			{ dataIndex: 'BILL_TYPE'			, width:93,align:'center', hidden:true},
			{ dataIndex: 'RECEIPT_TYPE'			, width:60,align:'center', hidden:true},
			{ dataIndex: 'ORDER_TYPE'			, width:60,align:'center', hidden:true},
			{ dataIndex: 'VAT_RATE'				, width:60, hidden:true},
			{ dataIndex: 'VAT_AMOUNT_O'			, width:80, hidden:true},
			{ dataIndex: 'DEPT_CODE'			, width:80, hidden:true},
			{ dataIndex: 'EX_DATE'				, width:80, hidden:true},
			{ dataIndex: 'EX_NUM'				, width:86, hidden:true},
			{ dataIndex: 'AGREE_YN'				, width:80, hidden:true},
			{ dataIndex: 'DRAFT_YN'				, width:80, hidden:true},
			{ dataIndex: 'DEPT_NAME'			, width:80, hidden:true},
			{ dataIndex: 'ISSUE_EXPECTED_DATE'	, width:80, hidden:true},
			{ dataIndex: 'ACCOUNT_TYPE'			, width:80, hidden:true},
			{ dataIndex: 'PROJECT_NO'			, width:86},
			{ dataIndex: 'CREDIT_NUM'			, width:120 , hidden:true},
			{ dataIndex: 'CRDT_NAME'			, width:100 , hidden:true},
			{ dataIndex: 'CUSTOM_PRSN'			, width:100 , hidden:false}		//20210315 추가
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				buyslipNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			masterForm.setValues({
				'DIV_CODE'				: record.get('DIV_CODE'),
				'CHANGE_BASIS_NUM'		: record.get('CHANGE_BASIS_NUM'),
				'CUSTOM_CODE'			: record.get('CUSTOM_CODE'),
				'CUSTOM_NAME'			: record.get('CUSTOM_NAME'),
				'DEPT_CODE'				: record.get('DEPT_CODE'),
				'DEPT_NAME'				: record.get('DEPT_NAME'),
				'BILL_TYPE'				: record.get('BILL_TYPE'),
				'MONEY_UNIT'			: record.get('MONEY_UNIT'),
				'ACCOUNT_TYPE'			: record.get('ACCOUNT_TYPE'),
				'BILL_DIV_CODE'			: record.get('BILL_DIV_CODE'),
				'COMPANY_NUM'			: record.get('COMPANY_NUM'),
				'ISSUE_EXPECTED_DATE'	: record.get('ISSUE_EXPECTED_DATE'),
				'ORDER_TYPE'			: record.get('ORDER_TYPE'),
				'PROJECT_NO'			: record.get('PROJECT_NO'),
				'CREDIT_NUM'			: record.get('CREDIT_NUM'),				//20200901 추가
				'TAX_INOUT'				: record.get('TAX_TYPE')				//20210318 추가
			});
			//20200901 추가: 조회 시, panelResult에 도 값 set하도록 수정
			panelResult.setValues({
				'DIV_CODE'				: record.get('DIV_CODE'),
				'CHANGE_BASIS_NUM'		: record.get('CHANGE_BASIS_NUM'),
				'CUSTOM_CODE'			: record.get('CUSTOM_CODE'),
				'CUSTOM_NAME'			: record.get('CUSTOM_NAME'),
				'DEPT_CODE'				: record.get('DEPT_CODE'),
				'DEPT_NAME'				: record.get('DEPT_NAME'),
				'BILL_TYPE'				: record.get('BILL_TYPE'),
				'MONEY_UNIT'			: record.get('MONEY_UNIT'),
				'ACCOUNT_TYPE'			: record.get('ACCOUNT_TYPE'),
				'BILL_DIV_CODE'			: record.get('BILL_DIV_CODE'),
				'COMPANY_NUM'			: record.get('COMPANY_NUM'),
				'ISSUE_EXPECTED_DATE'	: record.get('ISSUE_EXPECTED_DATE'),
				'ORDER_TYPE'			: record.get('ORDER_TYPE'),
				'PROJECT_NO'			: record.get('PROJECT_NO'),
				'CREDIT_NUM'			: record.get('CREDIT_NUM'),				//20200901 추가
				'TAX_INOUT'				: record.get('TAX_TYPE')				//20210318 추가
			});
			//매출기표 / 기표취소 버튼 show/hide
			UniAppManager.app.fnExSlipBtn();
			/**/
			if(masterForm.getValue('BILL_TYPE') == '53'){
				masterForm.setValue('CRDT_NUM'	, record.get('CREDIT_NUM'))
				panelResult.setValue('CRDT_NUM'	, record.get('CREDIT_NUM'))
				masterForm.setValue('CRDT_NAME'	, record.get('CRDT_NAME'))
				panelResult.setValue('CRDT_NAME', record.get('CRDT_NAME'))
			}
			if(masterForm.getValue('BILL_TYPE') == '62'){
				masterForm.setValue('CREDIT_NUMBER'	, record.get('CREDIT_NUM'))
				panelResult.setValue('CREDIT_NUMBER', record.get('CREDIT_NUM'))
			}

			/* 신용카드 필드 Show/hode */
			if(!Ext.isEmpty(record.get('CREDIT_NUM'))) {
				panelResult.getField('CREDIT_NUM').setHidden(false);
				panelResult.getField('CREDIT_NUM').setConfig('allowBlank', false);
				masterForm.getField('CREDIT_NUM').setHidden(false);
				masterForm.getField('CREDIT_NUM').setConfig('allowBlank', false);
			} else {
				panelResult.getField('CREDIT_NUM').setHidden(true);
				panelResult.getField('CREDIT_NUM').setConfig('allowBlank', true);
				masterForm.getField('CREDIT_NUM').setHidden(true);
				masterForm.getField('CREDIT_NUM').setConfig('allowBlank', true);
			}
			
			panelResult.setValues({
				'DIV_CODE'		: record.get('DIV_CODE'),
				'CUSTOM_CODE'	: record.get('CUSTOM_CODE'),
				'CUSTOM_NAME'	: record.get('CUSTOM_NAME'),
				'DEPT_CODE'		: record.get('DEPT_CODE'),
				'DEPT_NAME'		: record.get('DEPT_NAME')
			})
			CustomCodeInfo.gsUnderCalBase	= record.get('WON_CALC_BAS');
			CustomCodeInfo.gsTaxInclude		= record.get('TAX_TYPE');
			CustomCodeInfo.gsTaxCalcType	= record.get('TAX_CALC_TYPE');
			CustomCodeInfo.gsBillType		= record.get('BILL_TYPE');
		}
	});

	var receivehistoryGrid = Unilite.createGrid('s_map100ukrv_wmreceivehistoryGrid', {		//입고내역참조
		layout		: 'fit',
		excelTitle	: '<t:message code="system.label.purchase.eachpurchaseslipentry" default="개별 매입지급결의 등록"/>(<t:message code="system.label.purchase.receiptdetailsrefer" default="입고내역참조"/>)',
		store		: receiveHistoryStore,
		selModel	: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly		: true,
			toggleOnClick	: false,
			listeners		: {
				beforeselect: function(rowSelection, record, index, eOpts) {
					//20200217: 동일한 세구분만 선택되도록
					var selectedTaxtype = rowSelection.selected.items[0];
					if(Ext.isEmpty(selectedTaxtype) || selectedTaxtype.get('TAX_TYPE') == record.get('TAX_TYPE')) {
						return true;
					} else {
						Unilite.messageBox('<t:message code="system.message.purchase.message081" default="과제/면세 품목을 동시에 선택 할 수 없습니다."/>');
						return false;
					}
					UniAppManager.app.fnSumAmountIrefer();
				},
				select: function(grid, record, index, eOpts ){
					UniAppManager.app.fnSumAmountIrefer();
				},
				deselect: function(grid, record, index, eOpts ){
					UniAppManager.app.fnSumAmountIrefer();
					var record = receivehistoryGrid.getSelectedRecord();
//					record.set('INOUT_I', '');
//					record.set('INOUT_TAX_AMT', '');
				}
			}
		}),
		uniOpt: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		columns: [
//			{ dataIndex: 'GUBUN'			, width: 33},
			{ dataIndex: 'INSTOCK_DATE'		, width: 80},
			{ dataIndex: 'ITEM_ACCOUNT'		, width: 66,hidden:true},
			{ dataIndex: 'CUSTOM_PRSN'		, width: 100},	//20210225 추가
			{ dataIndex: 'PHONE'			, width: 110},	//20210225 추가
			{ dataIndex: 'ITEM_CODE'		, width: 126},
			{ dataIndex: 'ITEM_NAME'		, width: 300},
			{ dataIndex: 'SPEC'				, width: 88},
			{ dataIndex: 'ORDER_UNIT'		, width: 88,align:'center'},
			{ dataIndex: 'TAX_TYPE'			, width: 53,align:'center',hidden:false},
			{ dataIndex: 'ORDER_UNIT_P'		, width: 106},
			{ dataIndex: 'INOUT_Q'			, width: 100},
//			{ dataIndex: 'INOUT_I'			, width: 100},
			{ dataIndex: 'INOUT_TAX_AMT'	, width: 100, hidden: true},
			{ dataIndex: 'TOTAL_INOUT_I'	, width: 100, hidden: true},
			{ dataIndex: 'ORDER_UNIT_Q'		, width: 100},
			{ dataIndex: 'AMOUNT_P'			, width: 100,hidden:true},
			{ dataIndex: 'AMOUNT_I'			, width: 120},
			{ dataIndex: 'ORDER_UNIT_FOR_P'	, width: 100,hidden:true},
			{ dataIndex: 'FOREIGN_P'		, width: 100,hidden:true},
			{ dataIndex: 'FOR_AMOUNT_O'		, width: 118},
			{ dataIndex: 'ORDER_UNIT_FOR_P'	, width: 100},
			{ dataIndex: 'REMAIN_Q'			, width: 100},
			{ dataIndex: 'ADVAN_AMOUNT'		, width: 100},
			{ dataIndex: 'REMAIN_AMOUNT'	, width: 118},
			{ dataIndex: 'MONEY_UNIT'		, width: 53,align:'center'},
			{ dataIndex: 'EXCHG_RATE_O'		, width: 80},
			{ dataIndex: 'TRNS_RATE'		, width: 86},
			{ dataIndex: 'STOCK_UNIT'		, width: 100,align:'center'},
			{ dataIndex: 'BUY_Q'			, width: 100},
			{ dataIndex: 'ORDER_TYPE'		, width: 66,hidden:true},
			{ dataIndex: 'ORDER_PRSN'		, width: 66,hidden:true},
			{ dataIndex: 'ORDER_SEQ'		, width: 66,hidden:true},
			{ dataIndex: 'LC_NUM'			, width: 100,hidden:true},
			{ dataIndex: 'BL_NUM'			, width: 100,hidden:true},
			{ dataIndex: 'ORDER_NUM'		, width: 100},
			{ dataIndex: 'INOUT_NUM'		, width: 130},
			{ dataIndex: 'INOUT_SEQ'		, width: 33},
			{ dataIndex: 'TAX_CALC_TYPE'	, width: 100, align:'center',hidden:false},
			{ dataIndex: 'REMARK'			, width: 133},
			{ dataIndex: 'PROJECT_NO'		, width: 133},
			{ dataIndex: 'PURCHASE_TYPE'	, width: 133, hidden: true },
			{ dataIndex: 'INOUT_TYPE'		, width: 133, hidden: true }
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			gsTaxType		= receivehistorySearch.getValue('TAX_TYPE');
			var returnFlag	= false;
			var taxType;
			if(directMasterStore1.getCount() > 0 ){
				taxType = directMasterStore1.getAt(0).get('TAX_TYPE');
			}
			var records = this.sortedSelectedRecords(this);

			Ext.each(records, function(record,i){
				if(!Ext.isDefined(taxType) || record.get('TAX_TYPE') == taxType ){
					//20200217 적용로직 변경으로 주석처리
//					UniAppManager.app.onNewDataButtonDown();
//					masterGrid.setReceiveData(record.data);
				} else {
					receivehistorySearch.setValue('TAX_TYPE', '');
					returnFlag = true;
					return false;
				}
			});
			if(returnFlag) {
				Unilite.messageBox('<t:message code="system.message.purchase.message081" default="과제/면세 품목을 동시에 선택 할 수 없습니다."/>');
				return false;
			} else {
				//20200217 적용로직 변경
				masterGrid.setReceiveData(records);
				this.getStore().remove(records);
			}
		}
	});

	var returninghistoryGrid = Unilite.createGrid('s_map100ukrv_wmreturninghistoryGrid', {	//반품내역참조
		// title: '기본',
		layout: 'fit',
		excelTitle: '<t:message code="system.label.purchase.eachpurchaseslipentry" default="개별 매입지급결의 등록"/>(<t:message code="system.label.purchase.returndetailsrefer" default="반품내역참조"/>)',
		store: returningHistoryStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly: true,
			toggleOnClick: false
			/*listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
					UniAppManager.app.fnSumAmountIrefer3();
				},
				select: function(grid, record, index, eOpts ){
					UniAppManager.app.fnSumAmountIrefer3();
				},
				deselect: function(grid, record, index, eOpts ){
					UniAppManager.app.fnSumAmountIrefer3();
				}
			}*/
		}),
			uniOpt: {
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			onLoadSelectFirst : false,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		columns: [
		//	{ dataIndex: 'GUBUN'			, width: 33},
			{ dataIndex: 'INSTOCK_DATE'		, width: 80},
			{ dataIndex: 'ITEM_ACCOUNT'		, width: 66,hidden:true},
			{ dataIndex: 'ITEM_CODE'		, width: 126},
			{ dataIndex: 'ITEM_NAME'		, width: 300},
			{ dataIndex: 'SPEC'				, width: 88,hidden:true},
			{ dataIndex: 'ORDER_UNIT'		, width: 88,hidden:true},
			{ dataIndex: 'TAX_TYPE'			, width: 53,hidden:true},
			{ dataIndex: 'ORDER_UNIT_FOR_P'	, width: 100},
			{ dataIndex: 'INOUT_Q'			, width: 100},
			{ dataIndex: 'INOUT_I'			, width: 100},
			{ dataIndex: 'INOUT_TAX_AMT'	, width: 100},
			{ dataIndex: 'TOTAL_INOUT_I'	, width: 100},
			{ dataIndex: 'CONDITION'		, width: 66},
			{ dataIndex: 'TYPE'				, width: 66},
			{ dataIndex: 'GOOD_STOCK_Q'		, width: 66},
			{ dataIndex: 'ORDER_UNIT_Q'		, width: 100},
			{ dataIndex: 'ORDER_UNIT_P'		, width: 106},
			{ dataIndex: 'AMOUNT_P'			, width: 100,hidden:true},
			{ dataIndex: 'AMOUNT_I'			, width: 120},
			{ dataIndex: 'ORDER_UNIT_FOR_P'	, width: 100,hidden:true},
			{ dataIndex: 'FOREIGN_P'		, width: 100,hidden:true},
			{ dataIndex: 'FOR_AMOUNT_O'		, width: 118,hidden:true},
			{ dataIndex: 'REMAIN_Q'			, width: 100,hidden:true},
			{ dataIndex: 'ADVAN_AMOUNT'		, width: 100,hidden:true},
			{ dataIndex: 'REMAIN_AMOUNT'	, width: 118,hidden:true},
			{ dataIndex: 'MONEY_UNIT'		, width: 53,hidden:true},
			{ dataIndex: 'EXCHG_RATE_O'		, width: 80,hidden:true},
			{ dataIndex: 'TRNS_RATE'		, width: 86,hidden:true},
			{ dataIndex: 'STOCK_UNIT'		, width: 100,hidden:true},
			{ dataIndex: 'BUY_Q'			, width: 100,hidden:true},
			{ dataIndex: 'ORDER_TYPE'		, width: 66,hidden:true},
			{ dataIndex: 'ORDER_PRSN'		, width: 66,hidden:true},
			{ dataIndex: 'ORDER_SEQ'		, width: 66,hidden:true},
			{ dataIndex: 'LC_NUM'			, width: 100,hidden:true},
			{ dataIndex: 'BL_NUM'			, width: 100,hidden:true},
			{ dataIndex: 'ORDER_NUM'		, width: 100,hidden:true},
			{ dataIndex: 'INOUT_NUM'		, width: 130,hidden:false},
			{ dataIndex: 'INOUT_SEQ'		, width: 33,hidden:true},
			{ dataIndex: 'TAX_CALC_TYPE'	, width: 100, align:'center',hidden:false},
			{ dataIndex: 'REMARK'			, width: 133},
			{ dataIndex: 'PROJECT_NO'		, width: 133,hidden:true},
			{ dataIndex: 'PURCHASE_TYPE'	, width: 133, hidden: true },
			{ dataIndex: 'INOUT_TYPE'		, width: 133, hidden: true }
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var taxType;
			if(directMasterStore1.getCount() > 0 ){
				taxType = directMasterStore1.getAt(0).get('TAX_TYPE');
			}

			var records = this.sortedSelectedRecords(this);
			Ext.each(records, function(record,i){
				if(!Ext.isDefined(taxType) || record.get('TAX_TYPE') == taxType ){
					UniAppManager.app.onNewDataButtonDown();
					masterGrid.setReturningData(record.data);
					//directMasterStore1.fnSumAmountI(record);
				} else {
					alert('<t:message code="system.message.purchase.message081" default="과제/면세 품목을 동시에 선택 할 수 없습니다."/>');
					returninghistorySearch.setValue('TAX_TYPE', '');
				}
			});
			this.getStore().remove(records);
		}
	});

	var orderhistoryGrid = Unilite.createGrid('s_map100ukrv_wmorderhistoryGrid', {			//발주내역참조
		layout		: 'fit',
		excelTitle	: '<t:message code="system.label.purchase.eachpurchaseslipentry" default="개별 매입지급결의 등록"/>(<t:message code="system.label.purchase.purchasedetailsrefer" default="발주내역참조"/>)',
		store		: orderHistoryStore,
		uniOpt		: {
			onLoadSelectFirst : false
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly		: true,
			toggleOnClick	: false,
			listeners		: {
				beforeselect: function(rowSelection, record, index, eOpts) {
					UniAppManager.app.fnSumAmountIrefer2();
				},
				select: function(grid, record, index, eOpts ){
					UniAppManager.app.fnSumAmountIrefer2();
				},
				deselect: function(grid, record, index, eOpts ){
					UniAppManager.app.fnSumAmountIrefer2();
				}
			}
		}),
		columns: [
		//	{ dataIndex: 'GUBUN'			,  width: 33},
			{ dataIndex: 'ORDER_DATE'		,  width: 80},
			{ dataIndex: 'ITEM_CODE'		,  width: 100},
			{ dataIndex: 'ITEM_NAME'		,  width: 300},
			{ dataIndex: 'SPEC'				,  width: 88},
			{ dataIndex: 'ORDER_UNIT'		,  width: 88},
			{ dataIndex: 'ORDER_UNIT_Q'		,  width: 93},
			{ dataIndex: 'ORDER_UNIT_P'		,  width: 93},
			{ dataIndex: 'ORDER_O'			,  width: 93},
			{ dataIndex: 'ADVAN_AMOUNT'		,  width: 93},
			{ dataIndex: 'LOG_AMT'			,  width: 93},
			{ dataIndex: 'REMAIN_Q'			,  width: 93,hidden:true},
			{ dataIndex: 'MONEY_UNIT'		,  width: 53, align: 'center'},
			{ dataIndex: 'EXCHG_RATE_O'		,  width: 66},
			{ dataIndex: 'STOCK_UNIT'		,  width: 53},
			{ dataIndex: 'TRNS_RATE'		,  width: 66},
			{ dataIndex: 'LC_NUM'			,  width: 93},
			{ dataIndex: 'ORDER_NUM'		,  width: 93},
			{ dataIndex: 'ORDER_SEQ'		,  width: 66},
			{ dataIndex: 'REMARK'			,  width: 93},
			{ dataIndex: 'PROJECT_NO'		,  width: 93},
			{ dataIndex: 'ITEM_ACCOUNT'		,  width: 53,hidden:true},
			{ dataIndex: 'ORDER_TYPE'		,  width: 53,hidden:true},
			{ dataIndex: 'ORDER_PRSN'		,  width: 53,hidden:true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
////		var records = this.getSelectedRecords();
//			var records = this.sortedSelectedRecords(this);
//			Ext.each(records, function(record,i){
//				UniAppManager.app.onNewDataButtonDown();
//				masterGrid.setOrderData(record.data);
////		 	directMasterStore1.fnSumAmountI(e.store.data.items);
//			});
//			this.getStore().remove(records);

			//20200304 적용로직 변경
			gsTaxType		= orderhistorySearch.getValue('TAX_TYPE');
			var returnFlag	= false;
			var taxType;
			if(directMasterStore1.getCount() > 0 ){
				taxType = directMasterStore1.getAt(0).get('TAX_TYPE');
			}
			var records = this.sortedSelectedRecords(this);

			Ext.each(records, function(record,i){
				if(!Ext.isDefined(taxType) || record.get('TAX_TYPE') == taxType ){
					//20200217 적용로직 변경으로 주석처리
//					UniAppManager.app.onNewDataButtonDown();
//					masterGrid.setReceiveData(record.data);
				} else {
					orderhistorySearch.setValue('TAX_TYPE', '');
					returnFlag = true;
					return false;
				}
			});
			if(returnFlag) {
				Unilite.messageBox('<t:message code="system.message.purchase.message081" default="과제/면세 품목을 동시에 선택 할 수 없습니다."/>');
				return false;
			} else {
				//20200217 적용로직 변경
				masterGrid.setReceiveData(records);
				this.getStore().remove(records);
			}
		}
	});



	function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.purchase.purchaseslipsearch" default="매입전표번호검색"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [buyslipNoSearch, buyslipNoMasterGrid],
				tbar	: ['->', {
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler	: function() {
						buyslipNoMasterStore.loadStoreRecords();
					},
					disabled: false
				}, {
					itemId	: 'OrderNoCloseBtn',
					text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler	: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						buyslipNoSearch.clearForm();
						buyslipNoMasterGrid.reset();
						//buyslipNoDetailGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						buyslipNoSearch.clearForm();
						buyslipNoMasterGrid.reset();
						//buyslipNoDetailGrid.reset();
					},
					show: function( panel, eOpts ) {
						buyslipNoSearch.setValue('DIV_CODE'				, masterForm.getValue('DIV_CODE'));
						buyslipNoSearch.setValue('CUSTOM_CODE'			, masterForm.getValue('CUSTOM_CODE'));
						buyslipNoSearch.setValue('CUSTOM_NAME'			, masterForm.getValue('CUSTOM_NAME'));
						buyslipNoSearch.setValue('DEPT_CODE'			, masterForm.getValue('DEPT_CODE'));
						buyslipNoSearch.setValue('DEPT_NAME'			, masterForm.getValue('DEPT_NAME'));
						buyslipNoSearch.setValue('BILL_NUM'				, masterForm.getValue('BILL_NUM'));
						buyslipNoSearch.setValue('CHANGE_BASIS_DATE_FR'	, UniDate.get('startOfMonth', masterForm.getValue('CHANGE_BASIS_DATE')));
						buyslipNoSearch.setValue('CHANGE_BASIS_DATE_TO'	, masterForm.getValue('CHANGE_BASIS_DATE'));
						buyslipNoSearch.setValue('BILL_DATE_FR'			, UniDate.get('startOfMonth', masterForm.getValue('BILL_DATE')));
						buyslipNoSearch.setValue('BILL_DATE_TO'			, masterForm.getValue('BILL_DATE'));
						/***/
						/*if(masterForm.getValue('BILL_TYPE') == '62'){ 로직제거
							buyslipNoSearch.setValue('CREDIT_NUMBER',masterForm.getValue('CREDIT_NUMBER'));
						}
						else if(masterForm.getValue('BILL_TYPE') == '53'){
							buyslipNoSearch.setValue('CRDT_NUM',masterForm.getValue('CRDT_NUM'));
							buyslipNoSearch.setValue('CRDT_NAME',masterForm.getValue('CRDT_NAME'));
						}*/
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}

	function openReceiveHistoryWindow() {		//입고내역참조
//		if(!UniAppManager.app.checkForNewDetail()) return false;
//
//		receivehistorySearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
//		receivehistorySearch.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
//		receivehistorySearch.setValue('FR_ESTI_DATE', UniDate.get('startOfMonth', masterForm.getValue('ORDER_DATE')) );
//		receivehistorySearch.setValue('TO_ESTI_DATE', masterForm.getValue('ORDER_DATE'));
//		receivehistorySearch.setValue('DIV_CODE', masterForm.getValue('DIV_CODE'));
//		receiveHistoryStore.loadStoreRecords();

		receivehistorySearch.setValue('CUSTOM_CODE'	, masterForm.getValue('CUSTOM_CODE'));
		receivehistorySearch.setValue('MONEY_UNIT'	, masterForm.getValue('MONEY_UNIT'));
		if(!referReceiveHistoryWindow) {
			referReceiveHistoryWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.purchase.receiptdetailsrefer" default="입고내역참조"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [receivehistorySearch, receivehistoryGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler	: function() {
//						if(receivehistorySearch.setAllFieldsReadOnly(true) == false){
//							return false;
//						}
						receiveHistoryStore.loadStoreRecords();
						if(masterForm.getValue('BILL_TYPE') == '53' || masterForm.getValue('BILL_TYPE') == '62'){
//							receivehistorySearch.getField('TAX_TYPE').setReadOnly(false);
						}
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.purchase.purchaseapply" default="매입적용"/>',
					handler	: function() {
						receivehistoryGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.purchase.purchaseapplyclose" default="매입적용후 닫기"/>',
					handler	: function() {
						receivehistoryGrid.returnData();
						receivehistoryGrid.reset();
						receivehistorySearch.clearForm();
						referReceiveHistoryWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler	: function() {
						referReceiveHistoryWindow.hide();
						receivehistoryGrid.reset();
						receivehistorySearch.clearForm();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						//receivehistorySearch.clearForm();
						//receivehistoryGrid,reset();
					},
					beforeclose: function( panel, eOpts ) {
						//receivehistorySearch.clearForm();
						//receivehistoryGrid,reset();
					},
					beforeshow: function ( me, eOpts ) {
						receivehistorySearch.setValue('INOUT_DATE_FR'	, UniDate.get('startOfMonth'));
						receivehistorySearch.setValue('INOUT_DATE_TO'	, UniDate.get('today'));
						receivehistorySearch.setValue('DIV_CODE'		, masterForm.getValue('DIV_CODE'));
						receivehistorySearch.setValue('ORDER_TYPE'		, '1');
//						receivehistorySearch.setValue('ORDER_TYPE'		, masterForm.getValue('ORDER_TYPE'));
						var accountType = masterForm.getValue('ACCOUNT_TYPE');

						if(masterForm.getValue('BILL_TYPE') == '51'){
							receivehistorySearch.setValue('TAX_TYPE','1');
						} else if(masterForm.getValue('BILL_TYPE') == '57'){
							receivehistorySearch.setValue('TAX_TYPE','2');
						} else if(masterForm.getValue('BILL_TYPE') == '53'){

						} else if(masterForm.getValue('BILL_TYPE') == '56'){//수입계산서일 경우 직수입으로 세팅
							receivehistorySearch.setValue('ORDER_TYPE','5');
						}
						if(accountType == '40'){//매입유형이 외주가공비이면
							receivehistorySearch.setValue('ORDER_TYPE','4');
						}
						//receiveHistoryStore.loadStoreRecords();
					}
				}
			})
		}
		referReceiveHistoryWindow.center();
		referReceiveHistoryWindow.show();
	}

	function openReturningHistoryWindow() {		//반품내역참조
//		if(!UniAppManager.app.checkForNewDetail()) return false;
//
//		receivehistorySearch.setValue('CUSTOM_CODE'	, masterForm.getValue('CUSTOM_CODE'));
//		receivehistorySearch.setValue('CUSTOM_NAME'	, masterForm.getValue('CUSTOM_NAME'));
//		receivehistorySearch.setValue('FR_ESTI_DATE', UniDate.get('startOfMonth', masterForm.getValue('ORDER_DATE')) );
//		receivehistorySearch.setValue('TO_ESTI_DATE', masterForm.getValue('ORDER_DATE'));
//		receivehistorySearch.setValue('DIV_CODE'	, masterForm.getValue('DIV_CODE'));
//		receiveHistoryStore.loadStoreRecords();

		returninghistorySearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
		returninghistorySearch.setValue('MONEY_UNIT', masterForm.getValue('MONEY_UNIT'));
		if(!referReturningHistoryWindow) {
			referReturningHistoryWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.purchase.returndetailsrefer" default="반품내역참조"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [returninghistorySearch, returninghistoryGrid],
			tbar	: ['->', {
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler	: function() {
						if(returninghistorySearch.setAllFieldsReadOnly(true) == false){
							return false;
						}
						returningHistoryStore.loadStoreRecords();
						if(masterForm.getValue('BILL_TYPE') == '53' || masterForm.getValue('BILL_TYPE') == '62'){
							returninghistorySearch.getField('TAX_TYPE').setReadOnly(false);
						}
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.purchase.returnapply" default="반품적용"/>',
					handler	: function() {
						returninghistoryGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.purchase.returnapplyclose" default="반품적용후 닫기"/>',
					handler	: function() {
						returninghistoryGrid.returnData();
						returninghistoryGrid.reset();
						returninghistorySearch.clearForm();
						referReturningHistoryWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler	: function() {
						referReturningHistoryWindow.hide();
						returninghistoryGrid.reset();
						returninghistorySearch.clearForm();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						//receivehistorySearch.clearForm();
						//receivehistoryGrid,reset();
					},
					beforeclose: function( panel, eOpts ) {
						//receivehistorySearch.clearForm();
						//receivehistoryGrid,reset();
					},
					beforeshow: function ( me, eOpts ) {
						returninghistorySearch.setValue('INOUT_DATE_FR'	, UniDate.get('startOfMonth'));
						returninghistorySearch.setValue('INOUT_DATE_TO'	, UniDate.get('today'));
						returninghistorySearch.setValue('DIV_CODE'		, masterForm.getValue('DIV_CODE'));
						returninghistorySearch.setValue('ORDER_TYPE'	, masterForm.getValue('ORDER_TYPE'));
	////
						if(masterForm.getValue('BILL_TYPE') == '51'){
							returninghistorySearch.setValue('TAX_TYPE','1');
						} else if(masterForm.getValue('BILL_TYPE') == '57'){
							returninghistorySearch.setValue('TAX_TYPE','2');
						}
						//receiveHistoryStore.loadStoreRecords();
					}
				}
			})
		}
		referReturningHistoryWindow.center();
		referReturningHistoryWindow.show();
	}

	function openOrderHistoryWindow() {			//발주내역참조
		orderhistorySearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
		orderhistorySearch.setValue('MONEY_UNIT', masterForm.getValue('MONEY_UNIT'));
		if(!referOrderHistoryWindow) {
			referOrderHistoryWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.purchasedetailsrefer" default="발주내역참조"/>',/*(<t:message code="system.label.purchase.paymentinadvance2" default="선지급"/>)*/
				width: 1080,
				height: 580,
				layout: {type: 'vbox', align: 'stretch'},
				items: [orderhistorySearch, orderhistoryGrid],
				tbar: ['->',
					{
						itemId: 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							orderHistoryStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId: 'confirmBtn',
						text: '<t:message code="system.label.purchase.purchaseapply" default="매입적용"/>',
						handler: function() {
							orderhistoryGrid.returnData();
						},
						disabled: false
					},
					{
						itemId: 'confirmCloseBtn',
						text: '<t:message code="system.label.purchase.purchaseapplyclose" default="매입적용후 닫기"/>',
						handler: function() {
							orderhistoryGrid.returnData();
							referOrderHistoryWindow.hide();
						},
						disabled: false
					},{
						itemId: 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							referOrderHistoryWindow.hide();
						},
						disabled: false
					}
				],
				listeners: {
					beforehide: function(me, eOpt) {
						orderhistorySearch.clearForm();
						orderhistoryGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						orderhistorySearch.clearForm();
						orderhistoryGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						orderhistorySearch.setValue('ORDER_DATE_FR'	, UniDate.get('startOfMonth'));
						orderhistorySearch.setValue('ORDER_DATE_TO'	, UniDate.get('today'));
						orderhistorySearch.setValue('VATAMOUNTO'	, 0);
						orderhistorySearch.setValue('AMOUNTI'		, 0);
						orderhistorySearch.setValue('AMOUNTTOT'		, 0);
						//receiveHistoryStore.loadStoreRecords();
					}
				}
			})
		}
		referOrderHistoryWindow.center();
		referOrderHistoryWindow.show();
	}



	Unilite.Main({
		id			: 's_map100ukrv_wmApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			masterForm
		],
		fnInitBinding: function(params){				//20210607 수정: SETDEFAULT로 로직 옮김 / 불필요로직 삭제
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);

			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			} else {
				this.setDefault();
			}
		},
		//링크로 넘어오는 params 받는 부분
		processParams: function(params) {
			this.uniOpt.appParams = params;
			masterForm.clearForm();
			panelResult.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			directMasterStore1.loadData({});
			gsTaxType = '1';

			if(params.PGM_ID == 's_mms510ukrv_wm') {	//20210303 수정
				s_map100ukrv_wmService.selectMms510ukrv(params, function(provider, response) {
					var records = response.result;
					masterForm.setValue('DIV_CODE'				, params.DIV_CODE);
					masterForm.setValue('BILL_DIV_CODE'			, params.BILL_DIV_CODE);
					masterForm.setValue('CUSTOM_CODE'			, params.CUSTOM_CODE);
					masterForm.setValue('CUSTOM_NAME'			, params.CUSTOM_NAME);
					masterForm.setValue('MONEY_UNIT'			, Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
					masterForm.setValue('COMPANY_NUM'			, records[0]["COMPANY_NUM"]);

					panelResult.setValue('DIV_CODE'				, params.DIV_CODE);
					panelResult.setValue('BILL_DIV_CODE'		, params.BILL_DIV_CODE);
					panelResult.setValue('CUSTOM_CODE'			, params.CUSTOM_CODE);
					panelResult.setValue('CUSTOM_NAME'			, params.CUSTOM_NAME);
					panelResult.setValue('MONEY_UNIT'			, Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
					panelResult.setValue('COMPANY_NUM'			, records[0]["COMPANY_NUM"]);

					//20210607 추가: 링크받는 부분에서 초기값 설정하는 부분 따로 설정
					masterForm.setValue('ORDER_TYPE'			, '1');
					masterForm.setValue('ACCOUNT_TYPE'			, '10');
					masterForm.setValue('BILL_DATE'				, UniDate.get('today'));
					masterForm.setValue('CHANGE_BASIS_DATE'		, UniDate.get('today'));
					masterForm.setValue('DEPT_CODE'				, UserInfo.deptCode);
					masterForm.setValue('DEPT_NAME'				, UserInfo.deptName);
					masterForm.setValue('ISSUE_EXPECTED_DATE'	, UniDate.get('endOfNextMonth'));
					masterForm.setValue('EX_NUM'				, 0);
					masterForm.setValue('DRAFT_YN'				, 'N');

					panelResult.setValue('ORDER_TYPE'			, '1');
					panelResult.setValue('ACCOUNT_TYPE'			, '10');
					panelResult.setValue('BILL_DATE'			, UniDate.get('today'));
					panelResult.setValue('CHANGE_BASIS_DATE'	, UniDate.get('today'));
					panelResult.setValue('DEPT_CODE'			, UserInfo.deptCode);
					panelResult.setValue('DEPT_NAME'			, UserInfo.deptName);
					panelResult.setValue('ISSUE_EXPECTED_DATE'	, UniDate.get('endOfNextMonth'));
					panelResult.setValue('EX_NUM'				, 0);

					receivehistorySearch.getField('TAX_TYPE').setReadOnly(false);
					returninghistorySearch.getField('TAX_TYPE').setReadOnly(false);
					//20210607 추가: 여기까지

					CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"];
					CustomCodeInfo.gsTaxInclude		= records[0]["TAX_TYPE"];
					CustomCodeInfo.gsTaxCalcType	= records[0]["TAX_CALC_TYPE"];
					CustomCodeInfo.gsBillType		= records[0]["BCM_BILL_TYPE"];						//20210513 수정: BILL_TYPE -> BCM_BILL_TYPE

					var billType = '51';
					if(records[0]["BILL_TYPE"] == '*' && !Ext.isEmpty(records[0]["BCM_BILL_TYPE"])){	//20210513 추가: BCM_BILL_TYPE 관련 로직 추가
						billType = records[0]["BCM_BILL_TYPE"];
					} else if(!Ext.isEmpty(records[0]["BILL_TYPE"])){
						if(records[0]["BILL_TYPE"] > '50'){
							billType = records[0]["BILL_TYPE"];
						}
					}
					masterForm.setValue('BILL_TYPE'		, billType);
					panelResult.setValue('BILL_TYPE'	, billType);
////////////////////20210513 추가: BILL_TYPE 변경에 따른 로직 추가//////////////////
					UniAppManager.app.fnGetBillType(billType);
					panelResult.setValue('CRDT_NUM'		, '');
					panelResult.setValue('CRDT_NAME'	, '');
					masterForm.setValue('CRDT_NUM'		, '');
					masterForm.setValue('CRDT_NAME'		, '');
					panelResult.setValue('CREDIT_NUMBER', '');
					masterForm.setValue('CREDIT_NUMBER'	, '');

					//계산서유형이 '신용카드매입'일 때, show && 필수
					var commonCodes = Ext.data.StoreManager.lookup('CBS_AU_A022').data.items;
					var refCode1;
					Ext.each(commonCodes,function(commonCode, i) {
						if(commonCode.get('value') == billType) {
							refCode1 = commonCode.get('refCode1');
						}
					})
					if(refCode1 != 'E') {
						panelResult.down('#CREDIT_NUM').setHidden(true);
						panelResult.getField('CREDIT_NUM').setConfig('allowBlank', true);
						masterForm.down('#CREDIT_NUM').setHidden(true);
						masterForm.getField('CREDIT_NUM').setConfig('allowBlank', true);
						panelResult.setValue('CREDIT_NUM', '');
						masterForm.setValue('CREDIT_NUM', '');
					} else {
						panelResult.down('#CREDIT_NUM').setHidden(false);
						panelResult.getField('CREDIT_NUM').setConfig('allowBlank', false);
						masterForm.down('#CREDIT_NUM').setHidden(false);
						masterForm.getField('CREDIT_NUM').setConfig('allowBlank', false);
					}

					var param= Ext.getCmp('searchForm').getValues();
					s_map100ukrv_wmService.selectRefCode2(param, function(provider, response) {
						if(!Ext.isEmpty(provider)){
							masterForm.setValue('VAT_RATE'	, provider[0].VAT_RATE);
							panelResult.setValue('VAT_RATE'	, provider[0].VAT_RATE);
						} else {
							masterForm.setValue('VAT_RATE'	, records[0].VAT_RATE);
							panelResult.setValue('VAT_RATE'	, records[0].VAT_RATE);
						}
						masterForm.setValue('RECEIPT_TYPE'	, records[0]["SET_METH"]);
						panelResult.setValue('RECEIPT_TYPE'	, records[0]["SET_METH"]);
						masterForm.setValue('ORDER_TYPE'	, records[0].ORDER_TYPE);
						panelResult.setValue('ORDER_TYPE'	, records[0].ORDER_TYPE);
						masterForm.getField('TAX_INOUT').setValue(CustomCodeInfo.gsTaxInclude);
						panelResult.getField('TAX_INOUT').setValue(CustomCodeInfo.gsTaxInclude);
	
						Ext.each(records, function(record,i){
							UniAppManager.app.onNewDataButtonDown();
							masterGrid.setProviderData(record, params);
						});
					});
////////////////////여기까지.....//////////////////
				});
			//20210331 추가: 거래처원장 조회(매출/매입)에서 넘어오는 링크 받는 로직 추가
			} else if(params.PGM_ID == 'ssa615skrv') {
				s_map100ukrv_wmService.selectOrderNumMasterList(params, function(provider, response) {
					var record = provider[0];
					masterForm.setValues({
						'DIV_CODE'				: record.DIV_CODE,
						'CHANGE_BASIS_NUM'		: record.CHANGE_BASIS_NUM,
						'CUSTOM_CODE'			: record.CUSTOM_CODE,
						'CUSTOM_NAME'			: record.CUSTOM_NAME,
						'DEPT_CODE'				: record.DEPT_CODE,
						'DEPT_NAME'				: record.DEPT_NAME,
						'BILL_TYPE'				: record.BILL_TYPE,
						'MONEY_UNIT'			: record.MONEY_UNIT,
						'ACCOUNT_TYPE'			: record.ACCOUNT_TYPE,
						'BILL_DIV_CODE'			: record.BILL_DIV_CODE,
						'COMPANY_NUM'			: record.COMPANY_NUM,
						'ISSUE_EXPECTED_DATE'	: record.ISSUE_EXPECTED_DATE,
						'ORDER_TYPE'			: record.ORDER_TYPE,
						'PROJECT_NO'			: record.PROJECT_NO,
						'CREDIT_NUM'			: record.CREDIT_NUM,
						'TAX_INOUT'				: record.TAX_TYPE
					});
					panelResult.setValues({
						'DIV_CODE'				: record.DIV_CODE,
						'CHANGE_BASIS_NUM'		: record.CHANGE_BASIS_NUM,
						'CUSTOM_CODE'			: record.CUSTOM_CODE,
						'CUSTOM_NAME'			: record.CUSTOM_NAME,
						'DEPT_CODE'				: record.DEPT_CODE,
						'DEPT_NAME'				: record.DEPT_NAME,
						'BILL_TYPE'				: record.BILL_TYPE,
						'MONEY_UNIT'			: record.MONEY_UNIT,
						'ACCOUNT_TYPE'			: record.ACCOUNT_TYPE,
						'BILL_DIV_CODE'			: record.BILL_DIV_CODE,
						'COMPANY_NUM'			: record.COMPANY_NUM,
						'ISSUE_EXPECTED_DATE'	: record.ISSUE_EXPECTED_DATE,
						'ORDER_TYPE'			: record.ORDER_TYPE,
						'PROJECT_NO'			: record.PROJECT_NO,
						'CREDIT_NUM'			: record.CREDIT_NUM,
						'TAX_INOUT'				: record.TAX_TYPE
					});
					//매출기표 / 기표취소 버튼 show/hide
					UniAppManager.app.fnExSlipBtn();

					if(masterForm.getValue('BILL_TYPE') == '53'){
						masterForm.setValue('CRDT_NUM'	, record.CREDIT_NUM);
						masterForm.setValue('CRDT_NAME'	, record.CRDT_NAME);
						panelResult.setValue('CRDT_NUM'	, record.CREDIT_NUM);
						panelResult.setValue('CRDT_NAME', record.CRDT_NAME);
					}
					if(masterForm.getValue('BILL_TYPE') == '62'){
						masterForm.setValue('CREDIT_NUMBER'	, record.CREDIT_NUM);
						panelResult.setValue('CREDIT_NUMBER', record.CREDIT_NUM);
					}

					/* 신용카드 필드 Show/hode */
					if(!Ext.isEmpty(record.CREDIT_NUM)) {
						panelResult.getField('CREDIT_NUM').setHidden(false);
						panelResult.getField('CREDIT_NUM').setConfig('allowBlank'	, false);
						masterForm.getField('CREDIT_NUM').setHidden(false);
						masterForm.getField('CREDIT_NUM').setConfig('allowBlank'	, false);
					} else {
						panelResult.getField('CREDIT_NUM').setHidden(true);
						panelResult.getField('CREDIT_NUM').setConfig('allowBlank'	, true);
						masterForm.getField('CREDIT_NUM').setHidden(true);
						masterForm.getField('CREDIT_NUM').setConfig('allowBlank'	, true);
					}
					CustomCodeInfo.gsUnderCalBase	= record.WON_CALC_BAS;
					CustomCodeInfo.gsTaxInclude		= record.TAX_TYPE;
					CustomCodeInfo.gsTaxCalcType	= record.TAX_CALC_TYPE;
					CustomCodeInfo.gsBillType		= record.BILL_TYPE;

					UniAppManager.app.onQueryButtonDown();
				});
			}
		},
		setDefault: function() {
			masterForm.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			var param = {"DIV_CODE": UserInfo.divCode};
			s_map100ukrv_wmService.billDivCode(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('BILL_DIV_CODE'	, provider['BILL_DIV_CODE']);
					panelResult.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
				}
			});
//			masterForm.setValue('BILL_DIV_CODE'		, UserInfo.divCode);
			masterForm.setValue('ORDER_TYPE'		, '1');
			masterForm.setValue('ACCOUNT_TYPE'		, '10');
			masterForm.setValue('BILL_TYPE'			, '51');
			masterForm.setValue('BILL_DATE'			, UniDate.get('today'));
			masterForm.setValue('CHANGE_BASIS_DATE'	, UniDate.get('today'));
			masterForm.setValue('EX_NUM'			,0);
			masterForm.setValue('AMOUNTTOT'			,0);
			masterForm.setValue('AMOUNTI'			,0);
			masterForm.setValue('VAT_RATE'			,10);
			panelResult.setValue('VAT_RATE'			,10);
			masterForm.setValue('VATAMOUNTO'		,0);
			masterForm.setValue('DRAFT_YN'			,'N');

//			panelResult.setValue('BILL_DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('ORDER_TYPE'		, '1');
			panelResult.setValue('ACCOUNT_TYPE'		, '10');
			panelResult.setValue('BILL_TYPE'		, '51');
			panelResult.setValue('BILL_DATE'		, UniDate.get('today'));
			panelResult.setValue('CHANGE_BASIS_DATE', UniDate.get('today'));
			masterForm.setValue('DEPT_CODE'			, UserInfo.deptCode);
			panelResult.setValue('DEPT_CODE'		, UserInfo.deptCode);
			masterForm.setValue('DEPT_NAME'			, UserInfo.deptName);
			panelResult.setValue('DEPT_NAME'		, UserInfo.deptName);

			//20200309 추가
			masterForm.setValue('ISSUE_EXPECTED_DATE'	, UniDate.get('endOfNextMonth'));
			panelResult.setValue('ISSUE_EXPECTED_DATE'	, UniDate.get('endOfNextMonth'));
			//20210318 추가
			masterForm.getField('TAX_INOUT').setValue('2');
			panelResult.getField('TAX_INOUT').setValue('2');

			receivehistorySearch.getField('TAX_TYPE').setReadOnly(false);
			returninghistorySearch.getField('TAX_TYPE').setReadOnly(false);

			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);

			panelResult.down("#btnCancel").setDisabled(true);
			panelResult.down("#btnCreate").setDisabled(true);
		},
		onQueryButtonDown: function(){
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			var cbNo = masterForm.getValue('CHANGE_BASIS_NUM');
			if(Ext.isEmpty(cbNo)) {
				openSearchInfoWindow()
			} else {
				var param= masterForm.getValues();
				masterForm.uniOpt.inLoading=true;
				masterForm.getForm().load({
					params: param,
					success: function() {
						masterForm.setAllFieldsReadOnly(true)
						panelResult.setAllFieldsReadOnly(true)
//						if(BsaCodeInfo.gsDraftFlag == 'Y' && masterForm.getValue('STATUS') != '1') {
//							checkDraftStatus = true;
//						}
						masterForm.uniOpt.inLoading = false;
						panelResult.uniOpt.inLoading = false;
						UniAppManager.app.fnExSlipBtn();
					},
					failure: function(form, action) {
						masterForm.uniOpt.inLoading = false;
						panelResult.uniOpt.inLoading = false;
						UniAppManager.app.fnExSlipBtn();
					}
				})
				directMasterStore1.loadStoreRecords();
			}
/*
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ",viewLocked);
			console.log("viewNormal: ",viewNormal);
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	*/
		},
		onNewDataButtonDown: function() {
//		if(!this.checkForNewDetail()) return false;
			/**
			 * Detail Grid Default 값 설정
			 */
			var cbNo = masterForm.getValue('CHANGE_BASIS_NUM');
			var seq = directMasterStore1.max('CHANGE_BASIS_SEQ');
			if(!seq) seq = 1;
			else  seq += 1;
			var r = {
				CHANGE_BASIS_NUM: cbNo,
				CHANGE_BASIS_SEQ: seq
			};
			masterGrid.createRow(r);
			masterForm.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			panelResult.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			gsTaxType = '1';
			directMasterStore1.clearData();
			this.fnInitBinding();
			UniAppManager.app.fnExSlipBtn();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
		},
		fnSumAmountIrefer: function(){
			console.log("=============Exec fnSumAmountIrefer()");
			var dTaxInout		= panelResult.getValues().TAX_INOUT		//20210318 추가: 세액 포함여부 관련 계산로직 수정
			var dSumTax			= 0;
			var dSumAmountI		= 0;
			var dSumAmountTot	= 0;
			var taxType			= receivehistorySearch.getValue('TAX_TYPE');
			receivehistorySearch.setValue('AMOUNTI'		, '0');
			receivehistorySearch.setValue('VATAMOUNTO'	, '0');
			receivehistorySearch.setValue('AMOUNTTOT'	, '0');

			var dOrderUnitQ	= 0;
			var dOrderUnitP	= 0;
			var dCalAmoutI	= 0;
			var dAmountI	= 0;
			var dTax		= 0;
			var dVatRate	= 0;

			if(masterForm.getValue('VAT_RATE') == ''){
				dVatRate = 0;
			} else {
				dVatRate = masterForm.getValue('VAT_RATE');
			}
			if(taxType == '2'){
				dVatRate = 0;
			}

			var records = receivehistoryGrid.getSelectedRecords();
			Ext.each(records, function(record, index, records){
				dOrderUnitQ	= record.get('ORDER_UNIT_Q');
				dOrderUnitP	= record.get('ORDER_UNIT_P');
				dCalAmoutI	= record.get('AMOUNT_I');
				dAmountI	= dCalAmoutI;

				if(dAmountI == '0'){
					dAmountI = record.get('FOR_AMOUNT_O') * record.get('EXCHG_RATE_O');
				}

	//			var record = receivehistoryGrid.getSelectedRecord();
	//			if(records == ''){
	//				if(dCalAmoutI == (dOrderUnitQ * dOrderUnitP)){
	//					dAmountI = dCalAmoutI;
	//				} else {
	//					dAmountI = dOrderUnitQ * dOrderUnitP;
	//				}
	//			} else {
	//				dAmountI = dCalAmoutI;
	//			}
				if(dTaxInout == '1'){									//20210318 수정: 세액 포함여부 관련 계산로직 수정
					dAmountI	= Math.round(dAmountI,CustomCodeInfo.gsUnderCalBase);
					dTax		= dAmountI * (dVatRate / 100);
					dSumAmountI	= dSumAmountI + dAmountI;
					dTax		= Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
				} else {
					dTemp			= Math.round(dAmountI / ( dVatRate + 100 ) * 100,CustomCodeInfo.gsUnderCalBase);
					//20190821 fnAmtWonCalc 기능은 자동 버림처리.. round로 변경.
//					dTemp			= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '2');	//UniMatrl	??
					dTax			= dAmountI - dTemp;
					dTax			= Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
					dTemp			= dAmountI - dTax;
					dTemp			= Math.round(dTemp,CustomCodeInfo.gsUnderCalBase);
					dSumAmountTot	= dSumAmountTot + dAmountI;
				}
				dSumTax			= dSumTax + dTax;
				dSumAmountI		= Math.round(dSumAmountI,CustomCodeInfo.gsUnderCalBase);
				dSumAmountTot	= Math.round(dSumAmountTot,CustomCodeInfo.gsUnderCalBase);
				dSumTax			= Math.round(dSumTax,CustomCodeInfo.gsUnderCalBase);

				if(dTaxInout == '1'){									//20210318 수정: 세액 포함여부 관련 계산로직 수정
					receivehistorySearch.setValue('AMOUNTI'		, dSumAmountI);
					receivehistorySearch.setValue('AMOUNTTOT'	, dSumAmountI);
					record.set('INOUT_I', dAmountI);
				} else {
					receivehistorySearch.setValue('AMOUNTTOT', dSumAmountTot);
					record.set('INOUT_I', dAmountI);
				}

				if(CustomCodeInfo.gsTaxCalcType == '1'){
					if(dTaxInout == '1'){								//20210318 수정: 세액 포함여부 관련 계산로직 수정
						dTax = receivehistorySearch.getValue('AMOUNTI') * (dVatRate / 100);
						dTax = Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
					} else {
						dTemp	= receivehistorySearch.getValue('AMOUNTTOT') / ( dVatRate + 100 ) * 100;
						dTax	= receivehistorySearch.getValue('AMOUNTTOT') - dTemp;
						dTax	= Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
						receivehistorySearch.setValue('AMOUNTI', receivehistorySearch.getValue('AMOUNTTOT') - dTax);
						record.set('INOUT_I', record.get('INOUT_I') - dTax);
					}
					receivehistorySearch.setValue('VATAMOUNTO', dTax);
					record.set('INOUT_TAX_AMT', dTax);
				} else {
					receivehistorySearch.setValue('VATAMOUNTO', dSumTax);
					record.set('INOUT_TAX_AMT', dTax);
					if(dTaxInout != '1'){								//20210318 수정: 세액 포함여부 관련 계산로직 수정
						receivehistorySearch.setValue('AMOUNTI', receivehistorySearch.getValue('AMOUNTTOT') - dSumTax);
						record.set('INOUT_I', record.get('INOUT_I') - dTax);
					}
				}
				receivehistorySearch.setValue('AMOUNTTOT', receivehistorySearch.getValue('VATAMOUNTO') + receivehistorySearch.getValue('AMOUNTI'));
			})
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			gOrderType = selRow.get("ORDER_TYPE");
			if(selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
			} else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore1.data.items;
			var isNewData = false;
			gOrderType = directMasterStore1.data.items[0].data.ORDER_TYPE;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else {									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
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
		fnGetAccountType: function(subCode){
			var fRecord ='';
			Ext.each(BsaCodeInfo.AccountType, function(item, i) {
				if(item['codeNo'] == subCode) {
					fRecord = item['refCode2'];
				}
			});
//			masterForm.setValue('BILL_TYPE', fRecord);
//			panelResult.setValue('BILL_TYPE', fRecord);
		},
		fnGetBillType: function(subCode){
			var bRecord ='';
			Ext.each(BsaCodeInfo.BillType, function(item, i) {
				if(item['codeNo'] == subCode) {
					bRecord = item['refCode1'];
				}
			});
		},
		//매출기표 / 기표취소 버튼 show/hide
		fnExSlipBtn:function() {
			var cancelBtn = panelResult.down("#btnCancel");
			var createBtn = panelResult.down("#btnCreate");
			if(!Ext.isEmpty(masterForm.getValue('EX_NUM')) && masterForm.getValue('EX_NUM') != 0) {
				createBtn.setDisabled(true);
				cancelBtn.setDisabled(false);
			} else {
				createBtn.setDisabled(false);
				cancelBtn.setDisabled(true);
			}
		},
		//20200304 추가
		fnSumAmountIrefer2: function(){
			var dTaxInout		= panelResult.getValues().TAX_INOUT		//20210318 추가: 세액 포함여부 관련 계산로직 수정
			var dSumTax			= 0;
			var dSumAmountI		= 0;
			var dSumAmountTot	= 0;
			var dOrderUnitQ		= 0;
			var dOrderUnitP		= 0;
			var dCalAmoutI		= 0;
			var dAmountI		= 0;
			var dTax			= 0;
			var dVatRate		= 0;
			var dCalAmountI		= 0;
			orderhistorySearch.setValue('AMOUNTI'	, '0');
			orderhistorySearch.setValue('VATAMOUNTO', '0');
			orderhistorySearch.setValue('AMOUNTTOT'	, '0');

			var records = orderhistoryGrid.getSelectedRecords();
			Ext.each(records, function(record, index, records){
				if(masterForm.getValue('VAT_RATE') == ''){
					dVatRate = 0;
				} else{
					dVatRate = masterForm.getValue('VAT_RATE');
				}
				dAmountI = record.get('ORDER_O');

				if(dTaxInout == '1'){									//20210318 수정: 세액 포함여부 관련 계산로직 수정
					dAmountI	= Math.round(dAmountI,CustomCodeInfo.gsUnderCalBase);
					dTax		= dAmountI * (dVatRate / 100);
					dSumAmountI	= dSumAmountI + dAmountI;
					dTax		= Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
				} else{
					dTemp			= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '2');	//UniMatrl	??
					dTax			= dAmountI - dTemp;
					dTax			= Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
					dTemp			= dAmountI - dTax;
					dTemp			= Math.round(dTemp,CustomCodeInfo.gsUnderCalBase);
					dSumAmountTot	= dSumAmountTot + dAmountI;
				}
				dSumTax			= dSumTax + dTax;
				dSumAmountI		= Math.round(dSumAmountI,CustomCodeInfo.gsUnderCalBase);
				dSumAmountTot	= Math.round(dSumAmountTot,CustomCodeInfo.gsUnderCalBase);
				dSumTax			= Math.round(dSumTax,CustomCodeInfo.gsUnderCalBase);

				if(dTaxInout == '1'){									//20210318 수정: 세액 포함여부 관련 계산로직 수정
					orderhistorySearch.setValue('AMOUNTI'	, dSumAmountI);
					orderhistorySearch.setValue('AMOUNTTOT'	, dSumAmountI);
				} else{
					orderhistorySearch.setValue('AMOUNTTOT'	, dSumAmountTot);
				}
				if(CustomCodeInfo.gsTaxCalcType == '1'){
					if(dTaxInout == '1'){								//20210318 수정: 세액 포함여부 관련 계산로직 수정
						dTax = orderhistorySearch.getValue('AMOUNTI') * (dVatRate / 100);
						dTax = Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
					} else{
						dTemp	= orderhistorySearch.getValue('AMOUNTTOT') / ( dVatRate + 100 ) * 100;
						dTax	= orderhistorySearch.getValue('AMOUNTTOT') - dTemp;
						dTax	= Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
						orderhistorySearch.setValue('AMOUNTI',orderhistorySearch.getValue('AMOUNTTOT') - dTax);
					}
					orderhistorySearch.setValue('VATAMOUNTO', dTax);
				} else{
					orderhistorySearch.setValue('VATAMOUNTO', dSumTax);
					if(dTaxInout != '1'){								//20210318 수정: 세액 포함여부 관련 계산로직 수정
						orderhistorySearch.setValue('AMOUNTI', orderhistorySearch.getValue('AMOUNTTOT') - dSumTax);
					}
				}
				orderhistorySearch.setValue('AMOUNTTOT', orderhistorySearch.getValue('VATAMOUNTO') + orderhistorySearch.getValue('AMOUNTI'));
			})
		}
		/*cbStockQ: function(provider, params) {
			var rtnRecord = params.rtnRecord;

			//var dStockQ = Unilite.nvl(provider['STOCK_Q'], 0);
			//var dOrderQ = Unilite.nvl(rtnRecord.get('ORDER_Q'), 0);
			//var lTrnsRate = rtnRecord.get('TRANS_RATE');

			var dGoodStockQ = provider['GOOD_STOCK_Q'];
			var dBadStockQ = provider['BAD_STOCK_Q'];
			rtnRecord.set('GOOD_STOCK_Q', dGoodStockQ);
			rtnRecord.set('BAD_STOCK_Q', dBadStockQ);
		}*/
	});//End of Unilite.Main( {

	//거래처별 원미만 계산방식에 따라 금액 계산
	function fnWonCalcBas(amount){
		var calAmount;
		calAmount = amount;
		if(CustomCodeInfo.gsUnderCalBase == '1'){//절상
			calAmount = Math.ceil(calAmount);
		} else if(CustomCodeInfo.gsUnderCalBase == '2'){//절사
			calAmount = Math.floor(calAmount);
		} else {//반올림
			calAmount = Math.round(calAmount);
		}
		return calAmount;
	}

	//20200309 추가: 계산서일 변경 시, 지급예정일 익월 말일로 set하는 함수 생성
	function fnSetIssueExpectedDate(newValue){
		var tempdate = UniDate.extParseDate(UniDate.getDateStr(UniDate.add(newValue, {months:2})).substring(0, 6) + '01');
		var issueExpectedDate = UniDate.add(tempdate, {days: -1});
		masterForm.setValue('ISSUE_EXPECTED_DATE'	, issueExpectedDate);
		panelResult.setValue('ISSUE_EXPECTED_DATE'	, issueExpectedDate);
	}

	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "CHANGE_BASIS_SEQ" :	//순번
					if(newValue <= '0'){
						rv = '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					break;

				case "ORDER_UNIT_Q" :	//매입수량
					if(newValue <= '0'){
						rv = '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/> ';
						break;
					} else if(newValue > record.get('REMAIN_Q')){
						var a	= record.get('REMAIN_Q');
						rv		= '<t:message code="system.message.purchase.message082" default="매입가능수량을 초과하였습니다."/>' + '<t:message code="system.message.purchase.message083" default="매입잔량을 확인하십시오."/>' +
								'<t:message code="system.label.purchase.purchaseavailableqty" default="매입가능수량"/>' + ':' + a;
						break;
					}
					record.set('AMOUNT_I'	, newValue * record.get('ORDER_UNIT_P'));
					record.set('BUY_Q'		, newValue * record.get('TRNS_RATE'));

					if(record.get('EXCHG_RATE_O') != '0'){
						record.set('FOREIGN_P'			, record.get('AMOUNT_P') / record.get('EXCHG_RATE_O'));
						record.set('ORDER_UNIT_FOR_P'	, record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));
						record.set('FOR_AMOUNT_O'		, newValue * record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));
					} else {
						record.set('FOR_AMOUNT_O'		, '0');
						record.set('FOREIGN_P'			, '0');
						record.set('ORDER_UNIT_FOR_P'	, '0');
					}
					directMasterStore1.fnSumAmountI(e.store.data.items);
					break;

				case "ORDER_UNIT_P":
					if(newValue <= '0'){
						rv = '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					record.set('AMOUNT_I', record.get('ORDER_UNIT_Q')* newValue);

					if(record.get('EXCHG_RATE_O') != '0'){
						record.set('FOREIGN_P'			, record.get('AMOUNT_P') / record.get('EXCHG_RATE_O'));
						record.set('ORDER_UNIT_FOR_P'	, record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));
						record.set('FOR_AMOUNT_O'		, record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));
					} else {
						record.set('FOR_AMOUNT_O'		, '0');
						record.set('FOREIGN_P'			, '0');
						record.set('ORDER_UNIT_FOR_P'	, '0');
					}
					directMasterStore1.fnSumAmountI(e.store.data.items);
					break;

				case "AMOUNT_I" :
					if(record.get('ORDER_UNIT_Q') > ''){
						if(record.get('ORDER_UNIT_Q') > '0' && newValue <= '0'){
							rv = '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						} else if(record.get('ORDER_UNIT_Q') < '0' && newValue >= '0'){
							rv = '<t:message code="system.message.purchase.message034" default="음수만 입력가능합니다."/>';
							break;
						}
					}
					if(newValue > record.get('REMAIN_Q') * record.get('AMOUNT_P')){
						var a	= record.get('REMAIN_Q');
						rv		= '<t:message code="system.message.purchase.message082" default="매입가능수량을 초과하였습니다."/>' + '<t:message code="system.message.purchase.message083" default="매입잔량을 확인하십시오."/>' +
								'<t:message code="system.label.purchase.purchaseavailableqty" default="매입가능수량"/>' + ':' + a;
						break;
					}

					if(record.get('ADVAN_YN') == 'Y' || record.get('ADVAN_YN') > record.get('ADVAN_AMOUNT')){
						record.set('ORDER_UNIT_Q'	, record.get('AMOUNT_I') / record.get('ORDER_UNIT_P'));
						record.set('BUY_Q'			, record.get('ORDER_UNIT_Q'));
					}
					record.set('AMOUNT_I', newValue);

					if(record.get('ADVAN_YN') != 'Y' && record.get('ADVAN_AMOUNT') == '0'){
						if(record.get('BUY_Q') != '0'){
							record.set('AMOUNT_P'		, record.get('AMOUNT_I') / record.get('BUY_Q'));

							record.set('ORDER_UNIT_P'	, record.get('AMOUNT_I') / record.get('ORDER_UNIT_Q'));
						} else {
							record.set('AMOUNT_P'		, '0');
							record.set('ORDER_UNIT_P'	, '0');
						}
					}
					if(record.get('EXCHG_RATE_O') != '0'){
						record.set('FOREIGN_P'			, record.get('AMOUNT_P') / record.get('EXCHG_RATE_O'));
						record.set('ORDER_UNIT_FOR_P'	, record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));
						record.set('FOR_AMOUNT_O'		, record.get('AMOUNT_I') / record.get('EXCHG_RATE_O'));
					} else {
						record.set('FOR_AMOUNT_O'		, '0');
						record.set('FOREIGN_P'			, '0');
						record.set('ORDER_UNIT_FOR_P'	, '0');
					}
					directMasterStore1.fnSumAmountI(e.store.data.items);
					break;

				case "ORDER_UNIT_FOR_P" :
					if(newValue <= '0'){
						rv = '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					record.set('FOREIGN_P'		, newValue / record.get('TRNS_RATE'));
					record.set('FOR_AMOUNT_O'	, record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_FOR_P'));

					if(record.get('EXCHG_RATE_O') != '0'){
						record.set('AMOUNT_P'		, record.get('FOREIGN_P') * record.get('EXCHG_RATE_O'));
						record.set('ORDER_UNIT_P'	, record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O'));
						record.set('AMOUNT_I'		, record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P'));
					} else {
						record.set('INOUT_O'		, '0');
						record.set('AMOUNT_P'		, '0');
						record.set('ORDER_UNIT_P'	, '0');
					}
					directMasterStore1.fnSumAmountI(e.store.data.items);
					break;

				case "FOR_AMOUNT_O" :
					if(record.get('ORDER_UNIT_Q') != ''){
						if(newValue <= '0' && record.get('ORDER_UNIT_Q') > '0'){
							rv = '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						} else if(newValue >= '0' && record.get('ORDER_UNIT_Q') < '0'){
							rv = '<t:message code="system.message.purchase.message034" default="음수만 입력가능합니다."/>';
							break;
						}
					}
					if(record.get('BUY_Q') != '0'){
						record.set('FOREIGN_P'			, record.get('FOR_AMOUNT_O') / record.get('BUY_Q'));
						record.set('ORDER_UNIT_FOR_P'	, record.get('FOR_AMOUNT_O') / record.get('ORDER_UNIT_Q'))
					} else {
						record.set('FOREIGN_P'			, '0');
						record.set('ORDER_UNIT_FOR_P'	, '0');
					}
					if(record.get('EXCHG_RATE_O') != '0'){
						record.set('AMOUNT_P'		, record.get('FOREIGN_P') * record.get('EXCHG_RATE_O'));
						record.set('ORDER_UNIT_P'	, record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O'));
						record.set('AMOUNT_I'		, record.get('FOR_AMOUNT_O') * record.get('EXCHG_RATE_O'));
					} else {
						record.set('INOUT_O'		, '0');
						record.set('AMOUNT_P'		, '0');
						record.set('ORDER_UNIT_P'	, '0');
					}
					directMasterStore1.fnSumAmountI(e.store.data.items);
					break;

				case "TAX_I" :
					if(record.get('ORDER_UNIT_Q') > ''){
						if(record.get('ORDER_UNIT_Q') > '0' && newValue <= '0'){
							rv = '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						}
					} else if(record.get('ORDER_UNIT_Q') < '0' && newValue >= '0'){
						rv = '<t:message code="system.message.purchase.message034" default="음수만 입력가능합니다."/>';
						break;
					}

					var dAmountI;
					if(record.get('AMOUNT_I') == ''){
						dAmountI = 0;
					} else {
						dAmountI = record.get('AMOUNT_I');
					}
					var dTaxI = newValue;

					if(dAmountI > 0){
						if(dAmountI < dTaxI){
							rv = '<t:message code="system.message.purchase.message084" default="세액은 공급가액보다 작아야 합니다."/>';
							break;
						}
					} else {
						if(dAmountI > dTaxI){
							rv = '<t:message code="system.message.purchase.message085" default="세액은 공급가액보다 커야 합니다."/>';
							break;
						}
					}
					dTaxI = Math.round(dTaxI,CustomCodeInfo.gsUnderCalBase);
					directMasterStore1.fnSumTax();
					record.set('TOTAL_I', newValue + record.get('AMOUNT_I'));
					break;

				//20210222 추가: 전화번호 입력 시, 전화번호 유효성 체크로직 추가
				case "PHONE" :
					if(!Ext.isEmpty(newValue)) {
						if(!tel_check(newValue)) {
							rv = '올바른 전화번호를 입력하세요.'
							record.set('PHONE', oldValue);
							break;
						}
					}
					break;
			}
			return rv;
		}
	});

	//20210222 추가: 전화번호 체크로직 추가(안심번호 체크로직  포함)
	function tel_check(str) {
		str = str.replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
		var regTel = /^(050[2-8]{1}|01[016789]{1}|070|02|0[3-9]{1}[0-9]{1})-[0-9]{3,4}-[0-9]{4}$/;
		if(!regTel.test(str)) {
			return false;
		}
		return true;
	}
};
</script>