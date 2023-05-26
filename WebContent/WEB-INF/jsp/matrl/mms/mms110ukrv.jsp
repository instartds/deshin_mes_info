<%--
'   프로그램명 : 접수등록 (구매재고)
'   작   성   자 : 시너지시스템즈 개발팀
'   작   성   일 :
'   최종수정자 :
'   최종수정일 :
'   버		 전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms110ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="mms110ukrv"/>		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001"/>				<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201"/>				<!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="Q021"/>				<!-- 접수담당 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>	<!--창고-->
	<t:ExtComboStore comboType="OU"/>								<!-- 창고-->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js"/>'></script>
<script type="text/javascript" >

var SearchInfoWindow;						//조회버튼 누르면 나오는 조회창
var referOrderWindow;						//발주참조
var referCustWindow;						//거래처참조
var referCommerceWindow;					//무역참조
var referVmiWindow;							//vmi참조
var labelPartitionPrintWindow;				//라벨분할출력
var BsaCodeInfo = {
	glPerCent		: ${glPerCent},			//발주량 대비 접수율	''빼야함
	gsReceiptPrsn	: '${gsReceiptPrsn}',	//로그인ID 접수담당자 정보
	gsReportGubun	: '${gsReportGubun}',
	gsVmiReferYn	: '${gsVmiReferYn}',	//거래처납품등록참조(vmi)
	gsSiteCode		: '${gsSiteCode}'
};
var detailWin;
var gsSelRecord;
var gsSelRecord2;
var gsVmiYn			= true;
var printHiddenYn	= true;
if(BsaCodeInfo.gsReportGubun == 'CLIP'){
	printHiddenYn = false
}
if(BsaCodeInfo.gsVmiReferYn == 'Y'){
	gsVmiYn = false;
}
/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);
*/

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'mms110ukrvService.selectMaster',
			update	: 'mms110ukrvService.updateDetail',
			create	: 'mms110ukrvService.insertDetail',
			destroy	: 'mms110ukrvService.deleteDetail',
			syncAll	: 'mms110ukrvService.saveAll'
		}
	});
	var statusStore = Unilite.createStore('statusComboStore', {
		fields	: ['text', 'value'],
		data	: [
			{'text':'<t:message code="system.label.purchase.unapproved" default="미승인"/>'  , 'value':'1'},
			{'text':'<t:message code="system.label.purchase.approved" default="승인"/>'  , 'value':'2'}
		]
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Mms110ukrvModel1', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string' ,comboType: 'BOR120'},
			{name: 'RECEIPT_NUM'		, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'		, type: 'string'},
			{name: 'RECEIPT_SEQ'		, text: '<t:message code="system.label.purchase.seq" default="순번"/>'				, type: 'int'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		, type: 'string'},
			//20191127 발주단가 type 변경: uniPrice -> uniUnitPrice
			{name: 'ORDER_UNIT_P'		, text: '발주단가'			, type: 'uniUnitPrice'},
			{name: 'NOT_RECEIPT_Q'		, text: '<t:message code="system.label.purchase.notreceiveqty" default="미접수량"/>'	, type: 'uniQty'},
			{name: 'RECEIPT_Q'			, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'		, type: 'uniQty' ,allowBlank: false},
			{name: 'INSPEC_Q'			, text: '<t:message code="system.label.product.inspecqty2" default="검사량(시료)"/>'		, type: 'uniQty'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'			, type: 'int'},
			{name: 'INSPEC_FLAG'		, text: '<t:message code="system.label.purchase.searchobject" default="검사대상"/>'		, type: 'string' ,comboType: 'AU' ,comboCode:'Q002', allowBlank: false},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>'			, type: 'string'},
			{name: 'MAKE_LOT_NO'		, text: '거래처LOT'		, type: 'string'},
			{name: 'MAKE_DATE'			, text: '제조일자'			, type: 'uniDate'},
			{name: 'MAKE_EXP_DATE'		, text: '유통기한'			, type: 'uniDate'},
			{name: 'RECEIPT_PRSN'		, text: '<t:message code="system.label.purchase.receiptcharger" default="접수담당자"/>'	, type: 'string' ,comboType: 'AU' ,comboCode: 'Q021'},
			{name: 'DEPT_CODE'			, text: '<t:message code="system.label.purchase.departmencode" default="부서코드"/>'	, type: 'string'},
			{name: 'DEPT_NAME'			, text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'	, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'RECEIPT_DATE'		, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'		, type: 'uniDate'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'			, type: 'string' ,comboType   : 'OU'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'			, type: 'string' ,comboType: 'AU' ,comboCode: 'M001'},
			{name: 'OLD_VAL'			, text: '<t:message code="system.label.purchase.prereceiptqty2" default="이전 접수량"/>'	, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				, type: 'uniQty'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'		, type: 'string'},
			{name: 'INOUT_SEQ'			, text: '<t:message code="system.label.purchase.receiptseq2" default="입고순번"/>'		, type: 'int'},
			{name: 'TRADE_FLAG_YN'		, text: '<t:message code="system.label.purchase.tradeconnect" default="무역연계"/>'		, type: 'string'},
			{name: 'BASIS_NUM'			, text: '<t:message code="system.label.purchase.basisno" default="근거번호"/>'			, type: 'string'},
			{name: 'BASIS_SEQ'			, text: '<t:message code="system.label.purchase.basisseq" default="근거순번"/>'			, type: 'int'},
			{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'		, type: 'uniQty'},
			{name: 'ORDER_DATE'			, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'			, type: 'uniDate'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'	, type: 'string',comboType:'AU',comboCode:'B013', displayField: 'value'},
			{name: 'REF_ISSUE_NUM'		, text: 'REF_ISSUE_NUM'		, type: 'string'},
			{name: 'REF_ISSUE_SEQ'		, text: 'REF_ISSUE_SEQ'		, type: 'int'},
			{name: 'SAVE_FLAG'			, text: 'SAVE_FLAG'			, type: 'string'},
			//20191029 추가: 수주번호, 수주처, 수주품목명
			{name: 'SO_NUM'				, text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'SO_CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.soplace" default="수주처"/>'			, type: 'string'},
			{name: 'SO_ITEM_NAME'		, text: '수주품목명'				, type: 'string'}
		]
	});

	Unilite.defineModel('receiptNoMasterModel', {		//조회버튼 누르면 나오는 조회창
		fields: [
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'},
			{name: 'RECEIPT_NUM'	, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'		, type: 'string'},
			{name: 'RECEIPT_SEQ'	, text: '<t:message code="system.label.purchase.seq" default="순번"/>'				, type: 'int'},
			{name: 'RECEIPT_DATE'	, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'		, type: 'uniDate'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_UNIT_P'	, text: '발주단가'		, type: 'uniPrice'},
			{name: 'ORDER_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				, type: 'uniQty'},
			{name: 'RECEIPT_Q'		, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'		, type: 'uniQty'},
			{name: 'NOT_RECEIPT_Q'	, text: '<t:message code="system.label.purchase.notreceiveqty" default="미접수량"/>'	, type: 'uniQty'},
			{name: 'RECEIPT_PRSN'	, text: '<t:message code="system.label.purchase.receiptcharge2" default="접수담당"/>'	, type: 'string' ,comboType: 'AU' ,comboCode: 'Q021'},
			{name: 'ORDER_NUM'		, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
			{name: 'ORDER_SEQ'		, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'			, type: 'int'},
			{name: 'ORDER_PRSN'		, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'	, type: 'string' ,comboType: 'AU' ,comboCode: 'M201'},
			{name: 'LOT_NO'			, text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>'			, type: 'string'},
			{name: 'ORDER_TYPE'		, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'			, type: 'string' ,comboType: 'AU' ,comboCode: 'M001'},
			{name: 'DEPT_CODE'		, text: '<t:message code="system.label.purchase.departmencode" default="부서코드"/>'	, type: 'string'},
			{name: 'DEPT_NAME'		, text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'	, type: 'string'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'			, type: 'string' ,comboType: 'OU'},
			{name: 'BL_NO'			, text: 'BL_NO'		, type: 'string'}
		]
	});

	Unilite.defineModel('mms110ukrvORDERModel', {		//발주참조
		fields: [
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string' ,comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'DEPT_CODE'		, text: '<t:message code="system.label.purchase.departmencode" default="부서코드"/>'	, type: 'string'},
			{name: 'DEPT_NAME'		, text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'	, type: 'string'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'			, type: 'string' ,comboType   : 'OU'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'DVRY_DATE'		, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'		, type: 'uniDate'},
			{name: 'ORDER_DATE'		, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'			, type: 'uniDate'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		, type: 'string'},
			{name: 'ORDER_UNIT_Q'	, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				, type: 'uniQty'},
			{name: 'NOT_RECEIPT_Q'	, text: '<t:message code="system.label.purchase.notreceiveqty" default="미접수량"/>'	, type: 'uniQty'},
			{name: 'MONEY_UNIT'		, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'			, type: 'string'},
			{name: 'ORDER_UNIT_P'	, text: '<t:message code="system.label.purchase.price" default="단가"/>'				, type: 'uniUnitPrice'},
			{name: 'ORDER_O'		, text: '<t:message code="system.label.purchase.amount" default="금액"/>'				, type: 'uniPrice'},
			{name: 'ORDER_NUM'		, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
			{name: 'ORDER_SEQ'		, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'			, type: 'int'},
			{name: 'INSPEC_FLAG'	, text: '<t:message code="system.label.purchase.searchobject" default="검사대상"/>'		, type: 'string'},
			{name: 'LOT_NO'			, text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>'			, type: 'string'},
			{name: 'ORDER_TYPE'		, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'			, type: 'string' ,comboType: 'AU' ,comboCode: 'M001'},
			{name: 'ORDER_PRSN'		, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'	, type: 'string' ,comboType: 'AU' ,comboCode: 'M201'},
			{name: 'AGREE_STATUS'   , text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'		,type: 'string',store: Ext.data.StoreManager.lookup('statusComboStore')},
			{name: 'REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'PROJECT_NO'		, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			//20191029 추가: 수주번호, 수주처, 수주품목명
			{name: 'SO_NUM'			, text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'SO_CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.soplace" default="수주처"/>'			, type: 'string'},
			{name: 'SO_ITEM_NAME'	, text: '수주품목명'				, type: 'string'},
			//20201124 추가: 재고단위
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'	, type: 'string',comboType:'AU',comboCode:'B013', displayField: 'value'}
		]
	});

	Unilite.defineModel('refCustModel', {				//거래처참조
		fields: [
			{name: 'CUSTOM_CODE'	, text: '거래처'		, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '거래처명'		, type: 'string'},
			{name: 'ITEM_CNT'		, text: '미입고건수'		, type: 'uniQty'}
		]
	});

	Unilite.defineModel('refCustDetailModel', {			//거래처참조detail 정보
		fields: [
			{name: 'DIV_CODE'		, text: 'DIV_CODE'		, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: 'CUSTOM_CODE'	, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: 'CUSTOM_NAME'	, type: 'string'},
			{name: 'ITEM_CODE'		, text: 'ITEM_CODE'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: 'ITEM_NAME'		, type: 'string'},
			{name: 'ORDER_NUM'		, text: 'ORDER_NUM'		, type: 'string'},
			{name: 'ORDER_SEQ'		, text: 'ORDER_SEQ'		, type: 'int'},
			{name: 'ORDER_DATE'		, text: 'ORDER_DATE'	, type: 'uniDate'},
			{name: 'DVRY_DATE'		, text: 'DVRY_DATE'		, type: 'uniDate'},
			{name: 'ORDER_UNIT_Q'	, text: 'ORDER_Q'		, type: 'uniQty'},
			{name: 'RECEIPT_Q'		, text: 'RECEIPT_Q'		, type: 'uniQty'},
			{name: 'NOT_RECEIPT_Q'	, text: 'NOT_RECEIPT_Q'	, type: 'uniQty'},
			{name: 'INSPEC_FLAG'	, text: 'INSPEC_FLAG'	, type: 'string'},
			{name: 'WH_CODE'		, text: 'WH_CODE'		, type: 'string'},
			{name: 'MAKE_LOT_NO'	, text: 'MAKE_LOT_NO'	, type: 'string'},
			{name: 'MAKE_DATE'		, text: 'MAKE_DATE'		, type: 'uniDate'},
			{name: 'MAKE_EXP_DATE'	, text: 'MAKE_EXP_DATE'	, type: 'uniDate'}
		]
	});

	Unilite.defineModel('mms110ukrvCOMMERCEModel', {	//무역참조
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'LOT_NO'			, text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>'				, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.unit" default="단위"/>'					, type: 'string'},
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			, type: 'string'},
			{name: 'PRICE'			, text: '단가'		, type: 'uniPrice'},
			{name: 'QTY'			, text: '<t:message code="system.label.purchase.qty" default="수량"/>'					, type: 'uniQty'},
			{name: 'NOT_RECEIPT_Q'	, text: '<t:message code="system.label.purchase.notreceiveqty" default="미접수량"/>'		, type: 'uniQty'},
			{name: 'INVOICE_DATE'	, text: '<t:message code="system.label.purchase.customdate" default="통관일"/>'			, type: 'uniDate'},
			{name: 'LC_DATE'		, text: '<t:message code="system.label.purchase.lcdate" default="LC일"/>'				, type: 'uniDate'},
			{name: 'MONEY_UNIT'		, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				, type: 'string'},
			{name: 'EXCHANGE_RATE'	, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			, type: 'uniER'},
			{name: 'PRICE'			, text: '<t:message code="system.label.purchase.price" default="단가"/>'					, type: 'uniUnitPrice'},
			{name: 'AMT_O'			, text: '<t:message code="system.label.purchase.amount" default="금액"/>'					, type: 'uniPrice'},
			{name: 'AMT_I'			, text: '<t:message code="system.label.purchase.assetsamount" default="자산금"/>'			, type: 'uniPrice'},
			{name: 'LC_NO'			, text: '<t:message code="system.label.purchase.lcmanageno" default="L/C관리번호"/>'		, type: 'string'},
			{name: 'BL_NO'			, text: '<t:message code="system.label.purchase.shipmentmanageno" default="선적관리번호"/>'	, type: 'string'},
			{name: 'BASIS_NUM'		, text: '<t:message code="system.label.purchase.referencenum" default="참조번호"/>'			, type: 'string'},
			{name: 'BASIS_SEQ'		, text: '<t:message code="system.label.purchase.referenceseq" default="참조번호"/>'			, type: 'string'},
			{name: 'INSPEC_FLAG'	, text: '<t:message code="system.label.purchase.searchobject" default="검사대상"/>'			, type: 'string'},
			{name: 'ORDER_TYPE'		, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'				, type: 'string'},
			{name: 'TRADE_LOC'		, text: '<t:message code="system.label.purchase.tradelocation" default="무역경로"/>'		, type: 'string'},
			{name: 'SO_SER_NO'		, text: '<t:message code="system.label.purchase.sosernum" default="수입오퍼번호"/>'			, type: 'string'},
			{name: 'SO_SER'			, text: '<t:message code="system.label.purchase.soserseq" default="수입오퍼순번"/>'			, type: 'string'},
			{name: 'PROJECT_NO'		, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'BL_NUM'			, text: 'BL_NO'		, type: 'string'}
		]
	});

	Unilite.defineModel('mms110ukrvVMIModel', {			//VMI참조
		fields: [
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string' ,comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'DEPT_CODE'		, text: '<t:message code="system.label.purchase.departmencode" default="부서코드"/>'	, type: 'string'},
			{name: 'DEPT_NAME'		, text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'	, type: 'string'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'			, type: 'string' ,comboType   : 'OU'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'DVRY_DATE'		, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'		, type: 'uniDate'},
			{name: 'ORDER_DATE'		, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'			, type: 'uniDate'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		, type: 'string'},
			{name: 'ORDER_UNIT_Q'	, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				, type: 'uniQty'},
			{name: 'NOT_RECEIPT_Q'	, text: '<t:message code="system.label.purchase.notreceiveqty" default="미접수량"/>'	, type: 'uniQty'},
			{name: 'MONEY_UNIT'		, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'			, type: 'string'},
			{name: 'ORDER_UNIT_P'	, text: '<t:message code="system.label.purchase.price" default="단가"/>'				, type: 'uniUnitPrice'},
			{name: 'ORDER_O'		, text: '<t:message code="system.label.purchase.amount" default="금액"/>'				, type: 'uniPrice'},
			{name: 'ORDER_NUM'		, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
			{name: 'ORDER_SEQ'		, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'			, type: 'int'},
			{name: 'INSPEC_FLAG'	, text: '<t:message code="system.label.purchase.searchobject" default="검사대상"/>'		, type: 'string'},
			{name: 'LOT_NO'			, text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>'			, type: 'string'},
			{name: 'ORDER_TYPE'		, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'			, type: 'string' ,comboType: 'AU' ,comboCode: 'M001'},
			{name: 'ORDER_PRSN'		, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'	, type: 'string' ,comboType: 'AU' ,comboCode: 'M201'},
			{name: 'AGREE_STATUS'	, text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'		, type: 'string' ,store: Ext.data.StoreManager.lookup('statusComboStore')},
			{name: 'REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'PROJECT_NO'		, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'ISSUE_NUM'		, text: 'ISSUE_NUM'			, type: 'string'},
			{name: 'ISSUE_SEQ'		, text: 'ISSUE_SEQ'			, type: 'int'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mms110ukrvMasterStore1', {
		model	: 'Mms110ukrvModel1',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			allDeletable: true,
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		saveStore: function() {
			var inValidRecs	= this.getInvalidRecords();
			var paramMaster	= panelSearch.getValues();		//syncAll 수정
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var list		= [].concat(toUpdate, toCreate);
			console.log("list:", list);

			Ext.each(list, function(record, index) {
				record.set('RECEIPT_DATE', UniDate.getDbDateStr(panelResult.getValue('RECEIPT_DATE')));
			});

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelSearch.setValue("RECEIPT_NUM", master.RECEIPT_NUM);
						panelResult.setValue("RECEIPT_NUM", master.RECEIPT_NUM);
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						directMasterStore1.loadStoreRecords();
						if(directMasterStore1.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('mms110ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			panelResult.setValue('RECEIPT_NUMS'	, '');
			panelResult.setValue('ITEM_CODES'	, '');
			this.load({
				params: param
			});
		}
	});

	var receiptNoMasterStore = Unilite.createStore('receiptNoMasterStore', {	//조회버튼 누르면 나오는 조회창
		model	: 'receiptNoMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'mms110ukrvService.selectreceiptNumMasterList'
			}
		},
		loadStoreRecords: function() {
			var param= receiptNoSearch.getValues();
//				var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
//				var deptCode = UserInfo.deptCode;	//부서코드
//				if(authoInfo == "5" && Ext.isEmpty(receiptNoSearch.getValue('DEPT_CODE'))){
//					param.DEPT_CODE = deptCode;
//				}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var orderStore = Unilite.createStore('mms110ukrvOrderStore', {				//발주참조
		model	: 'mms110ukrvORDERModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 'mms110ukrvService.selectorderList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					var orderRecords = new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM'])
								 && (record.data['ORDER_SEQ'] == item.data['ORDER_SEQ'])
								){
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
			var param= orderSearch.getValues();
//			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
//			var deptCode = UserInfo.deptCode;	//부서코드
//			if(authoInfo == "5" && Ext.isEmpty(orderSearch.getValue('DEPT_CODE'))){
//				param.DEPT_CODE = deptCode;
//			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var custStore = Unilite.createStore('custStore', {							//거래처참조
		model	: 'refCustModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 'mms110ukrvService.selectCustList'
			}
		},
		loadStoreRecords: function() {
			var param= custSearch.getValues();
			console.log( param );
			this.load({
				params : param,
				callback : function(records, operation, success) {
					if(success){
					}
				}
			});
		}
	});

	var custStoreDetail = Unilite.createStore('custStoreDetail', {				//거래처참조
		model	: 'refCustDetailModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 'mms110ukrvService.selectCustDetailList'
			}
		},
		loadStoreRecords: function(rec) {
			var param= Ext.merge(custSearch.getValues(),panelResult.getValues());
			param.CUSTOM_CODE = rec.CUSTOM_CODE;
//			console.log( param );
			this.load({
				params	: param,
				callback: function(records, operation, success) {
					if(success){
						var records	= directMasterStore1.data.items;
						data		= new Object();
						data.records= [];
						Ext.each(records, function(record, i){
							data.records.push(record);
						});
						masterGrid.getSelectionModel().select(data.records);
					}
				}
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				Ext.each(records, function(record,index){
					record.phantom = true;
					directMasterStore1.insert(index, record);
				})
				UniAppManager.setToolbarButtons(['save'], false);
			}
		}
	});

	var commerceStore = Unilite.createStore('mms110ukrvCommerceStore', {		//무역참조
		model	: 'mms110ukrvCOMMERCEModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 'mms110ukrvService.selectcommerceList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					var estiRecords = new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								if( (record.data['ORDER_NUM'] == item.data['BASIS_NUM'])
								 && (record.data['ORDER_SEQ'] == item.data['BASIS_SEQ'])
								){
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
			var param= commerceSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var vmiStore = Unilite.createStore('mms110ukrvVmiStore', {					//vmi참조
		model	: 'mms110ukrvVMIModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 'mms110ukrvService.selectvmiList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					var vmiRecords = new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM'])
								 && (record.data['ORDER_SEQ'] == item.data['ORDER_SEQ'])
								){
									vmiRecords.push(item);
								}
							});
						});
						store.remove(vmiRecords);
					}
				}
			}
		},
		loadStoreRecords : function() {
			var param= vmiSearch.getValues();
//			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
//			var deptCode = UserInfo.deptCode;	//부서코드
//			if(authoInfo == "5" && Ext.isEmpty(orderSearch.getValue('DEPT_CODE'))){
//				param.DEPT_CODE = deptCode;
//			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
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
				child:'WH_CODE',
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
//						combo.changeDivCode(combo, newValue, oldValue, eOpts);
//						var field = panelResult.getField('RECEIPT_PRSN');
//						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
						panelResult.setValue('RECEIPT_PRSN', '');
						panelSearch.setValue('RECEIPT_PRSN', '');
//						var field2 = panelResult.getField('WH_CODE');
//						field2.getStore().clearFilter(true);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M001',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
				xtype: 'uniDatefield',
				name:'RECEIPT_DATE',
				value: UniDate.get('today'),
				allowBlank: false,
				//holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('RECEIPT_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptcharge2" default="접수담당"/>',
				name: 'RECEIPT_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'Q021',
				allowBlank: false,
//				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
//					if(eOpts){
//						combo.filterByRefCode('refCode4', newValue, eOpts.parent);
//					}else{
//						combo.divFilterByRefCode('refCode4', newValue, divCode);
//					}
//				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('RECEIPT_PRSN', newValue);
					},beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var pRStore = panelResult.getField('RECEIPT_PRSN').store;
						var divChk = false;
						Ext.each(store.data.items, function(record,i){
							if(!Ext.isEmpty(record.get('refCode1'))){
								divChk = true;
							}
						});
						store.clearFilter();
						pRStore.clearFilter();
						if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE')) && divChk == true ){
							store.filterBy(function(record){
								return record.get('refCode1') == panelSearch.getValue('DIV_CODE');
							});
							pRStore.filterBy(function(record){
								return record.get('refCode1') == panelSearch.getValue('DIV_CODE');
							});
						}else if(divChk == false){
								return true;
						}else{
							store.filterBy(function(record){
								return false;
							});
							pRStore.filterBy(function(record){
								return false;
							});

						}
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>',
				xtype: 'uniTextfield',
				name:'RECEIPT_NUM',
				readOnly: true
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

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			holdable: 'hold',
			child:'WH_CODE',
			value: UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
//					combo.changeDivCode(combo, newValue, oldValue, eOpts);
//					var field = panelResult.getField('RECEIPT_PRSN');
//					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
					panelResult.setValue('RECEIPT_PRSN', '');
					panelSearch.setValue('RECEIPT_PRSN', '');
//					var field2 = panelResult.getField('WH_CODE');
//					field2.getStore().clearFilter(true);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name: 'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M001',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_TYPE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
			xtype: 'uniDatefield',
			name:'RECEIPT_DATE',
			value: UniDate.get('today'),
			allowBlank: false,
//			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('RECEIPT_DATE', newValue);
					Ext.each(masterGrid.getStore().data.items, function(record, index){
						record.set('RECEIPT_DATE', newValue);
					});
				}
			}
		},{
			xtype: 'container',
			layout:{type:'uniTable',columns:2},
			colspan:2,
			items:[{
				text:'<div style="color: red">시험의뢰서 출력</div>',
				xtype: 'button',
				margin: '0 0 0 15',
				itemId	: 'btnReceiptPrint',
				hidden: printHiddenYn,
				handler: function(){
					if(!panelResult.getInvalidMessage()) return;	//필수체크

					var selectedRecords = masterGrid.getSelectedRecords();
					if(Ext.isEmpty(selectedRecords)){
						alert('출력할 데이터를 선택하여 주십시오.');
						return;
					}
					var receiptNums = '';
					var receiptSeqs = '';
					var itemCodes = '';
					var param = panelResult.getValues();
					Ext.each(selectedRecords, function(selectedRecord, index){
						if(index ==0) {
							receiptNums	= receiptNums + selectedRecord.get('RECEIPT_NUM');
							receiptSeqs		= receiptSeqs + selectedRecord.get('RECEIPT_SEQ');
							itemCodes		= itemCodes + selectedRecord.get('ITEM_CODE');
						}else{
							receiptNums	= receiptNums + ',' + selectedRecord.get('RECEIPT_NUM');
							receiptSeqs		= receiptSeqs + ',' + selectedRecord.get('RECEIPT_SEQ');
							itemCodes	= itemCodes + ',' + selectedRecord.get('ITEM_CODE');
						}
					});

					var param = panelResult.getValues();

					param["dataCount"] = selectedRecords.length;
					param["RECEIPT_NUMS"] = receiptNums;
					param["RECEIPT_SEQS"] = receiptSeqs;
					param["ITEM_CODES"] = itemCodes;
					param["MAIN_CODE"] = 'M030';
					param["sTxtValue2_fileTitle"]='검사결과서';

					param["RPT_ID"]='mms110rkrv';
					param["PGM_ID"]='mms110ukrv';

					var win = '';
						 win = Ext.create('widget.ClipReport', {
								url: CPATH+'/matrl/mms110clukrv_2.do',
								prgID: 'mms110ukrv',
								extParam: param
							});
							win.center();
							win.show();

				}
			},{
				text	: '<div style="color: red">라벨출력</div>',
				xtype	: 'button',
				margin	: '0 0 0 20',
				handler	: function(){
					UniAppManager.app.onPrintButtonDown();
				}
			},{	/*20210616 추가: 극동의 라벨 출력 원부자재, 제품으로 구분해서 출력하기 위해 추가
				(공통코드 B706 읽어서 라디오버튼 필드 생성하므로 다른 사이트의 경우에도 초기화 시, hidden: false 조건에 추가하여 사용 가능)*/
				fieldLabel	: '구분',
				xtype		: 'uniRadiogroup',
				itemId		: 'GUBUN',
				name		: 'GUBUN',
				comboType	: 'AU',
				comboCode	: 'B706',
				allowBlank	: false,
				value		: BsaCodeInfo.gsSiteCode == 'KDG' ? 'A' : '',
				width		: 260,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		},{
			fieldLabel: '<t:message code="system.label.purchase.receiptcharge2" default="접수담당"/>',
			name: 'RECEIPT_PRSN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'Q021',
			allowBlank: false,
//			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
//				if(eOpts){
//					combo.filterByRefCode('refCode4', newValue, eOpts.parent);
//				}else{
//					combo.divFilterByRefCode('refCode4', newValue, divCode);
//				}
//			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('RECEIPT_PRSN', newValue);
				},
				beforequery:function( queryPlan, eOpts )   {
					var store = queryPlan.combo.store;
					var pRStore = panelSearch.getField('RECEIPT_PRSN').store;
					var divChk = false;
					Ext.each(store.data.items, function(record,i){
						if(!Ext.isEmpty(record.get('refCode1'))){
							divChk = true;
						}
					});
					store.clearFilter();
					pRStore.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE')) && divChk == true ){
						store.filterBy(function(record){
							return record.get('refCode1') == panelResult.getValue('DIV_CODE');
						});
						pRStore.filterBy(function(record){
							return record.get('refCode1') == panelResult.getValue('DIV_CODE');
						});
					}else if(divChk == false){
							return true;
					}else{
						store.filterBy(function(record){
							return false;
						});
						pRStore.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>',
			xtype: 'uniTextfield',
			name:'RECEIPT_NUM',
			readOnly: true
		},{
			fieldLabel: 'RECEIPT_NUMS',
			xtype: 'uniTextfield',
			name: 'RECEIPT_NUMS',
			hidden: true
		},{
			fieldLabel: 'ITEM_CODES',
			xtype: 'uniTextfield',
			name: 'ITEM_CODES',
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
	});

	var receiptNoSearch = Unilite.createSearchForm('receiptNoSearchForm', {		//조회버튼 누르면 나오는 조회창
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
//					combo.changeDivCode(combo, newValue, oldValue, eOpts);
//					var field = receiptNoSearch.getField('RECEIPT_PRSN');
//					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
//					var field2 = receiptNoSearch.getField('WH_CODE');
//					field2.getStore().clearFilter(true);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'RECEIPT_DATE_FR',
			endFieldName: 'RECEIPT_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank:false
		},
//		Unilite.popup('DEPT', {
//			fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
//			valueFieldName: 'DEPT_CODE',
//			textFieldName: 'DEPT_NAME',
//			valueFieldWidth: 50,
//			textFieldWidth: 180,
//			listeners: {
//				applyextparam: function(popup){
//					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
//					var deptCode = UserInfo.deptCode;	//부서정보
//					var divCode = '';					//사업장
//					if(authoInfo == "A"){	//자기사업장
//						popup.setExtParam({'DEPT_CODE': ""});
//						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
//					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
//						popup.setExtParam({'DEPT_CODE': ""});
//						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
//					}else if(authoInfo == "5"){		//부서권한
//						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
//						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
//					}
//				}
//			}
//		}),
		Unilite.popup('CUST',{
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				textFieldWidth: 170,
				validateBlank: false,
				extParam: {'CUSTOM_TYPE': ['1','2']}
		}),{
			fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name: 'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M001'
		},{
			fieldLabel: 'LOT NO',
			name: 'LOT_NO',
			xtype: 'uniTextfield'
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel	 : '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			textFieldWidth : 170,
			validateBlank  : false
		}),
//		{
//			fieldLabel: '접수창고',
//			name: 'WH_CODE',
//			xtype: 'uniCombobox',
//			store: Ext.data.StoreManager.lookup('whList')
//		},
		{
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name: 'RECEIPT_PRSN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'Q021'/*,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode4', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode4', newValue, divCode);
				}
			}*/
		},{
			fieldLabel:'<t:message code="system.label.purchase.pono" default="발주번호"/>',
			name: 'ORDER_NUM',
			xtype: 'uniTextfield'
		},{
			fieldLabel: '품목계정',
			name: 'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B020'
		}


		]
	});

	var orderSearch = Unilite.createSearchForm('orderForm', {//발주참조
		layout :  {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			child:'WH_CODE',
			value:UserInfo.divCode,
			readOnly: true,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
//					combo.changeDivCode(combo, newValue, oldValue, eOpts);
//					var field = orderSearch.getField('ORDER_PRSN');
//					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
//					var field2 = orderSearch.getField('WH_CODE');
//					field2.getStore().clearFilter(true);
				}
			}
		},
//		Unilite.popup('DEPT', {
//			fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
//			valueFieldName: 'DEPT_CODE',
//			textFieldName: 'DEPT_NAME',
//			valueFieldWidth: 50,
//			textFieldWidth: 180,
//			readOnly: true,
//			listeners: {
//				applyextparam: function(popup){
//					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
//					var deptCode = UserInfo.deptCode;	//부서정보
//					var divCode = '';					//사업장
//					if(authoInfo == "A"){	//자기사업장
//						popup.setExtParam({'DEPT_CODE': ""});
//						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
//					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
//						popup.setExtParam({'DEPT_CODE': ""});
//						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
//					}else if(authoInfo == "5"){		//부서권한
//						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
//						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
//					}
//				}
//			}
//		}),
//		Unilite.popup('CUST',{
//			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
//			textFieldWidth: 170,
//			validateBlank: false,
//			extParam: {'CUSTOM_TYPE': ['1','2']},
//			readOnly: true
//		}),
		Unilite.popup('CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			holdable: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				}
			}
		}),
		{
			fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfLastMonth'),
			endDate: UniDate.get('today'),
			allowBlank:false
		},{
			fieldLabel: 'LOT NO',
			name: 'LOT_NO',
			xtype: 'uniTextfield'
		},{
			fieldLabel: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			comboType   : 'OU'
		},{
			fieldLabel: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'DVRY_DATE_FR',
			endFieldName: 'DVRY_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank:true
		},{
			fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name: 'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M001',
			hidden:false
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			validateBlank: false
		}),{
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name: 'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M201'

		},{
			fieldLabel:'<t:message code="system.label.purchase.pono" default="발주번호"/>',
			name: 'ORDER_NUM',
			xtype: 'uniTextfield'
		}]
	});
	var custSearch = Unilite.createSearchForm('custForm', {//거래처참조
		layout :  {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			child:'WH_CODE',
			value:UserInfo.divCode,
			readOnly: true,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfLastMonth'),
			endDate: UniDate.get('today')
		},{
			fieldLabel: '거래처분류',
			name: 'AGENT_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B055'
		},
		Unilite.popup('CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			autoPopup:true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				}
			}
		})
		]
	});
	var commerceSearch = Unilite.createSearchForm('commerceForm', {//무역참조
		layout :  {type : 'uniTable', columns : 2},
		items :[{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			hidden: true,
			value: UserInfo.divCode
		},
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				textFieldWidth: 170,
				validateBlank: false,
				extParam: {'CUSTOM_TYPE': ['1','2']}
		}),
		{
			fieldLabel: '<t:message code="system.label.purchase.customdate" default="통관일"/>(<t:message code="system.label.purchase.lcdate" default="LC일"/>)',
			xtype: 'uniDateRangefield',
			startFieldName: 'INVOICE_DATE_FR',
			endFieldName: 'INVOICE_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},
		Unilite.popup('DIV_PUMOK', {
			fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			validateBlank: false
		})]
	});

	var vmiSearch = Unilite.createSearchForm('vmiSearchForm', {//vmi참조
		layout :  {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			child:'WH_CODE',
			value:UserInfo.divCode,
			readOnly: true,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
//					combo.changeDivCode(combo, newValue, oldValue, eOpts);
//					var field = orderSearch.getField('ORDER_PRSN');
//					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
//					var field2 = orderSearch.getField('WH_CODE');
//					field2.getStore().clearFilter(true);
				}
			}
		},
		Unilite.popup('CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			holdable: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				}
			}
		}),
		{
			fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfLastMonth'),
			endDate: UniDate.get('today'),
			allowBlank:false
		},{
			fieldLabel: 'LOT NO',
			name: 'LOT_NO',
			xtype: 'uniTextfield'
		},{
			fieldLabel: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			comboType   : 'OU'
		},{
			fieldLabel: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'DVRY_DATE_FR',
			endFieldName: 'DVRY_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank:true
		},{
			fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name: 'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M001',
			hidden:false
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			validateBlank: false
		}),{
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name: 'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M201'

		},{
			fieldLabel:'<t:message code="system.label.purchase.pono" default="발주번호"/>',
			name: 'ORDER_NUM',
			xtype: 'uniTextfield'
		}]
	});

	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('mms110ukrvGrid1', {
		layout: 'fit',
		region: 'center',
		excelTitle: '<t:message code="system.label.purchase.receiptentry2" default="접수등록"/>',
		store: directMasterStore1,
		tbar: [{
			itemId: 'orderBtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.porefer" default="발주참조"/></div>',
			handler: function() {
				openOrderWindow();
			}
		},'-',{
			itemId: 'custBtn',
			text: '<div style="color: blue">거래처참조</div>',
			handler: function() {
				openCustWindow();
			}
		},'-',{
			itemId: 'commerceBtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.importrefer" default="수입참조"/></div>',
			handler: function() {
				openCommerceWindow();
				commerceSearch.getField('INVOICE_DATE_FR').focus();
			}
		},'-'
		,{
			itemId: 'vmiBtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.customdeliveryrefer" default="거래처납품참조"/></div>',
			hidden:gsVmiYn,
			handler: function() {
				openVmiWindow();
			}
		}],
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
			onLoadSelectFirst : false
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			//20191127 발주단가, 발주량, 미접수량, 접수량, 검사량, 입고량 합계 표시위해 사용으로 변경
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if(Ext.isEmpty(selectRecord)){
						UniAppManager.setToolbarButtons(['print'], false);
					}else{
						UniAppManager.setToolbarButtons(['print'], true);
					}

				 if(selectRecord.phantom == true){
						selectRecord.set('SAVE_FLAG','Y');
					}

					if(Ext.isEmpty(panelResult.getValue('RECEIPT_NUMS'))) {
						panelResult.setValue('RECEIPT_NUMS', selectRecord.get('RECEIPT_NUM') + selectRecord.get('RECEIPT_SEQ'));
					} else {
						var receiptNums = panelResult.getValue('RECEIPT_NUMS');
						receiptNums = receiptNums + ',' + selectRecord.get('RECEIPT_NUM') + selectRecord.get('RECEIPT_SEQ');
						panelResult.setValue('RECEIPT_NUMS', receiptNums);
					}
					if(Ext.isEmpty(panelResult.getValue('ITEM_CODES'))) {
						panelResult.setValue('ITEM_CODES', selectRecord.get('ITEM_CODE'));
					} else {
						var itemCodes = panelResult.getValue('ITEM_CODES');
						itemCodes = itemCodes + ',' + selectRecord.get('ITEM_CODE') ;
						panelResult.setValue('ITEM_CODES', itemCodes);
					}

				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var selectedDetails = masterGrid.getSelectedRecords();
					if(Ext.isEmpty(selectedDetails)){
						UniAppManager.setToolbarButtons(['print'], false);
					}else{
						UniAppManager.setToolbarButtons(['print'], true);
					}
					if(selectRecord.phantom == true){
						selectRecord.set('SAVE_FLAG','N');
						 var toCreate = directMasterStore1.getNewRecords();
						 var toUpdate = directMasterStore1.getUpdatedRecords();
						 var toDelete = directMasterStore1.getRemovedRecords();
						 var saveDataChk = false;
							if(toCreate.length > 0 && toUpdate.length == 0 && toDelete.length == 0){
								Ext.each(directMasterStore1.data.items, function(record, index) {
									if(record.get('SAVE_FLAG') == 'Y' && record.phantom == true ){
										saveDataChk = true;
									}
								});
								if(!saveDataChk){
									UniAppManager.setToolbarButtons(['save'], false);
								}else{
									UniAppManager.setToolbarButtons(['save'], true);
								}
							}
					}

					var receiptNums	 = panelResult.getValue('RECEIPT_NUMS');
					var deselectedNum0  = selectRecord.get('RECEIPT_NUM') + selectRecord.get('RECEIPT_SEQ') + ',';
					var deselectedNum1  = ',' + selectRecord.get('RECEIPT_NUM') + selectRecord.get('RECEIPT_SEQ');
					var deselectedNum2  = selectRecord.get('RECEIPT_NUM') + selectRecord.get('RECEIPT_SEQ');

					receiptNums = receiptNums.split(deselectedNum0).join("");
					receiptNums = receiptNums.split(deselectedNum1).join("");
					receiptNums = receiptNums.split(deselectedNum2).join("");

					var itemCodes	 = panelResult.getValue('ITEM_CODES');
					var deselectedNum00  = selectRecord.get('ITEM_CODE') + ',';
					var deselectedNum11  = ',' + selectRecord.get('ITEM_CODE') ;
					var deselectedNum22  = selectRecord.get('ITEM_CODE') ;

					itemCodes = itemCodes.split(deselectedNum00).join("");
					itemCodes = itemCodes.split(deselectedNum11).join("");
					itemCodes = itemCodes.split(deselectedNum22).join("");

					panelResult.setValue('RECEIPT_NUMS', receiptNums);
					panelResult.setValue('ITEM_CODES', itemCodes);
				}
			}
		}),
		columns: [
			{dataIndex: 'DIV_CODE'				, width: 100 ,hidden: true},
			{dataIndex: 'RECEIPT_NUM'			, width: 120 ,hidden: true},
			{dataIndex: 'RECEIPT_SEQ'			, width: 50},
			{dataIndex: 'ITEM_CODE'				, width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'ITEM_NAME'				, width: 180},
			{dataIndex: 'SPEC'					, width: 100},
			{dataIndex: 'ORDER_UNIT'			, width: 80 ,align: 'center'},
			//20191127 발주단가, 발주량, 미접수량, 접수량, 검사량, 입고량 합계 표시
			{dataIndex: 'ORDER_UNIT_P'			, width: 80, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_Q'			, width: 80, summaryType: 'sum'},
			{dataIndex: 'NOT_RECEIPT_Q'			, width: 80, summaryType: 'sum'},
			{dataIndex: 'RECEIPT_Q'				, width: 80, summaryType: 'sum'},
			{dataIndex: 'INSPEC_Q'				, width: 120, summaryType: 'sum'},
			{dataIndex: 'STOCK_UNIT'			, width: 80,align:'center'},
			{dataIndex: 'INSTOCK_Q'				, width: 80, summaryType: 'sum'},
			{  text: '<t:message code="system.label.purchase.print" default="출력"/>',
				width: 100,
				xtype: 'widgetcolumn',
				widget: {
					xtype: 'button',
					text: '<t:message code="system.label.purchase.label" default="라벨"/><t:message code="system.label.purchase.partition" default="분할"/>',
					listeners: {
						buffer:1,
						click: function(button, event, eOpts) {
							gsSelRecord2 = event.record.data;
							labelPartitionPrintSearch.setValue('LABEL_ITEM_CODE'  , gsSelRecord2.ITEM_CODE);
							labelPartitionPrintSearch.setValue('LABEL_LOT_NO'	, gsSelRecord2.LOT_NO);
							labelPartitionPrintSearch.setValue('LABEL_RECEIPT_QTY', gsSelRecord2.RECEIPT_Q * gsSelRecord2.TRNS_RATE);
							labelPartitionPrintSearch.setValue('LABEL_RECEIPT_NUM', gsSelRecord2.RECEIPT_NUM);
							labelPartitionPrintSearch.setValue('LABEL_RECEIPT_SEQ', gsSelRecord2.RECEIPT_SEQ);
							Ext.getCmp('LABEL_STOCK_UNIT').setText(gsSelRecord2.STOCK_UNIT);
							openLabelPartitionWindow(gsSelRecord2);
						}
					}
				}
			},
			{dataIndex: 'CUSTOM_NAME'			, width: 150},
			{dataIndex: 'ORDER_NUM'				, width: 120},
			{dataIndex: 'ORDER_SEQ'				, width: 80},
			{dataIndex: 'ORDER_DATE'				, width: 100},
			{dataIndex: 'INSPEC_FLAG'			, width: 80 ,align:'center'},
			{dataIndex: 'LOT_NO'				, width: 100},

			{dataIndex: 'MAKE_LOT_NO'			, width: 100},
			{dataIndex: 'MAKE_DATE'				, width: 100},
			{dataIndex: 'MAKE_EXP_DATE'			, width: 100},

			{dataIndex: 'RECEIPT_PRSN'			, width: 90 ,align:'center'},
			{dataIndex: 'DEPT_CODE'				, width: 100 ,hidden: true},
			{dataIndex: 'DEPT_NAME'				, width: 110 ,align:'center'},
			{dataIndex: 'REMARK'				, width: 133},
			{dataIndex: 'PROJECT_NO'			, width: 100},
			{dataIndex: 'RECEIPT_DATE'			, width: 100 ,hidden: true},
			{dataIndex: 'WH_CODE'				, width: 100 ,align: 'center' ,hidden: true},
			{dataIndex: 'CUSTOM_CODE'			, width: 100,hidden: true},
			{dataIndex: 'ORDER_TYPE'			, width: 80 ,align: 'center' ,hidden: true},
			{dataIndex: 'OLD_VAL'				, width: 80 ,hidden: true	, editable: false},
			{dataIndex: 'COMP_CODE'				, width: 80 ,hidden: true},
			{dataIndex: 'INOUT_NUM'				, width: 80 ,hidden: true},
			{dataIndex: 'INOUT_SEQ'				, width: 53 ,hidden: true},
			{dataIndex: 'TRADE_FLAG_YN'		, width: 70 ,align: 'center', hidden: true},
			{dataIndex: 'BASIS_NUM'				, width: 100 ,hidden: false},
			{dataIndex: 'BASIS_SEQ'				, width: 70 ,hidden: false},
			{
				text: '파일',
				width: 100,
				xtype: 'widgetcolumn',
				widget: {
					xtype: 'button',
					text: '파일첨부',
					listeners: {
						buffer:1,
						click: function(button, event, eOpts) {
						/*   var record = event.record.data;
							itemInfoStore.loadStoreRecords(record.ITEM_CODE);
							openItemInformationWindow(); */
							gsSelRecord = event.record.data;
							if(event.record.phantom == true){
								alert('저장되지 않은 데이터입니다.\n접수내역을 저장 후 다시 시도해주세요.');
								return ;
							}
								openDetailWindow(gsSelRecord);
						}
					}
				}
			},
			{dataIndex: 'REF_ISSUE_NUM'			, width: 100 ,hidden: true},
			{dataIndex: 'REF_ISSUE_SEQ'			, width: 70 ,hidden: true},
			{dataIndex: 'SAVE_FLAG'				, width: 70 ,hidden: true},
			//20191029 추가: 수주번호, 수주처, 수주품목명
			{ dataIndex: 'SO_NUM'				, width:100 ,hidden: false},
			{ dataIndex: 'SO_CUSTOM_NAME'		, width:150 ,hidden: false},
			{ dataIndex: 'SO_ITEM_NAME'			, width:200 ,hidden: false}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom == false )
				{
					if(e.record.data.RECEIPT_Q == e.record.data.INSPEC_Q) {
						if(e.field=='RECEIPT_Q') return false;
						if(e.field=='LOT_NO') return false;
						if(e.field=='REMARK') return false;
						if(e.field=='RECEIPT_PRSN') return false;
						if(e.field=='PROJECT_NO') return false;
					}else {
						if(e.field=='RECEIPT_Q') return true;
						if(e.field=='LOT_NO' && e.record.data.INSPEC_Q == 0 && e.record.data.INSTOCK_Q == 0) return true;
						if(e.field=='REMARK') return true;
						if(e.field=='RECEIPT_PRSN') return true;
						if(e.field=='PROJECT_NO') return true;
					}

					if(e.field=='RECEIPT_SEQ') return false;
					if(e.field=='ITEM_CODE') return false;
					if(e.field=='ITEM_NAME') return false;
					if(e.field=='SPEC') return false;
					if(e.field=='ORDER_UNIT') return false;
					if(e.field=='NOT_RECEIPT_Q') return false;
					if(e.field=='INSPEC_Q') return false;
					if(e.field=='ORDER_NUM') return false;
					if(e.field=='ORDER_SEQ') return false;
					if(e.field=='INSPEC_FLAG') return true;
					if(e.field=='BASIS_NUM') return false;
					if(e.field=='BASIS_SEQ') return false;
					if(e.field=='TRADE_FLAG_YN') return false;
					if(e.field=='ORDER_UNIT_P') return false;
					if(e.field=='ORDER_UNIT_Q') return false;
					if(e.field=='LOT_NO') return false;
					if(e.field=='CUSTOM_NAME') return false;
					if(e.field=='INSTOCK_Q') return false;

				}
				else if(e.record.phantom ) {
					if(e.field=='LOT_NO') return true;
					if(e.field=='REMARK') return true;
					if(e.field=='RECEIPT_Q') return true;
					if(e.field=='RECEIPT_PRSN') return true;
					if(e.field=='PROJECT_NO') return true;
					if(e.field=='RECEIPT_SEQ') return false;
					if(e.field=='ITEM_CODE') return false;
					if(e.field=='ITEM_NAME') return false;
					if(e.field=='SPEC') return false;
					if(e.field=='ORDER_UNIT') return false;
					if(e.field=='NOT_RECEIPT_Q') return false;
					if(e.field=='INSPEC_Q') return false;
					if(e.field=='ORDER_NUM') return false;
					if(e.field=='ORDER_SEQ') return false;
					if(e.field=='INSPEC_FLAG') return true;
					if(e.field=='BASIS_NUM') return false;
					if(e.field=='BASIS_SEQ') return false;
					if(e.field=='TRADE_FLAG_YN') return false;
					if(e.field=='ORDER_UNIT_P') return false;
					if(e.field=='ORDER_UNIT_Q') return false;
					if(e.field=='CUSTOM_NAME') return false;
					if(e.field=='INSTOCK_Q') return false;
				}
			}
		},
		setOrderData:function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('RECEIPT_NUM'			, panelSearch.getValue('RECEIPT_NUM'));
			grdRecord.set('DIV_CODE'			, panelSearch.getValue('DIV_CODE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('RECEIPT_Q'			, record['NOT_RECEIPT_Q']);
			grdRecord.set('NOT_RECEIPT_Q'		, record['NOT_RECEIPT_Q']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('INSPEC_FLAG'			, record['INSPEC_FLAG']);
			grdRecord.set('INOUT_NUM'			, '');
			grdRecord.set('INOUT_SEQ'			, 0);
			grdRecord.set('BASIS_NUM'			, '');
			grdRecord.set('BASIS_SEQ'			, 0);
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_Q'		, record['ORDER_UNIT_Q']);
			grdRecord.set('COMP_CODE'			, record['COMP_CODE']);
			grdRecord.set('RECEIPT_PRSN'		, panelSearch.getValue('RECEIPT_PRSN'));
			grdRecord.set('RECEIPT_DATE'		, panelSearch.getValue('RECEIPT_DATE'));
			grdRecord.set('DEPT_CODE'			, record['DEPT_CODE']);
			grdRecord.set('DEPT_NAME'			, record['DEPT_NAME']);
			grdRecord.set('WH_CODE'				, record['WH_CODE']);
			grdRecord.set('TRADE_FLAG_YN'		, 'N');

			//20191029 추가: 수주번호, 수주처, 수주품목명
			grdRecord.set('SO_NUM'				, record['SO_NUM']);
			grdRecord.set('SO_CUSTOM_NAME'		, record['SO_CUSTOM_NAME']);
			grdRecord.set('SO_ITEM_NAME'		, record['SO_ITEM_NAME']);
			//20201124추가: 재고단위
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);

			panelSearch.setValue('CUSTOM_CODE'	, record['CUSTOM_CODE']);
			panelSearch.setValue('CUSTOM_NAME'	, record['CUSTOM_NAME']);
			panelResult.setValue('CUSTOM_CODE'	, record['CUSTOM_CODE']);
			panelResult.setValue('CUSTOM_NAME'	, record['CUSTOM_NAME']);
			panelSearch.setValue('DEPT_CODE'		, record['DEPT_CODE']);
			panelSearch.setValue('DEPT_NAME'		, record['DEPT_NAME']);
			panelResult.setValue('DEPT_CODE'	, record['DEPT_CODE']);
			panelResult.setValue('DEPT_NAME'	, record['DEPT_NAME']);
		/*	panelSearch.setValue('DIV_CODE'		, record['DIV_CODE']);
			panelResult.setValue('DIV_CODE'		, record['DIV_CODE']); */
			panelSearch.setValue('WH_CODE'		, record['WH_CODE']);
			panelResult.setValue('WH_CODE'		, record['WH_CODE']);
		},

		setCommerceData:function(record) {	//무역참조시 set
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('RECEIPT_NUM'			, panelSearch.getValue('RECEIPT_NUM'));
			grdRecord.set('DIV_CODE'			, panelSearch.getValue('DIV_CODE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('ORDER_UNIT_P'		, record['PRICE']);
			grdRecord.set('ORDER_UNIT_Q'		, record['QTY']);
			grdRecord.set('RECEIPT_Q'			, record['NOT_RECEIPT_Q']);
			grdRecord.set('NOT_RECEIPT_Q'		, record['NOT_RECEIPT_Q']);
			grdRecord.set('ORDER_NUM'			, record['SO_SER_NO']);
			grdRecord.set('ORDER_SEQ'			, record['SO_SER']);
			grdRecord.set('INSPEC_FLAG'			, record['INSPEC_FLAG']);
			grdRecord.set('INOUT_NUM'			, '');
			grdRecord.set('INOUT_SEQ'			, 0);
			grdRecord.set('BASIS_NUM'			, record['BASIS_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['BASIS_SEQ']);
			grdRecord.set('LOT_NO'				, '');
			grdRecord.set('REMARK'				, '');
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('COMP_CODE'			, record['COMP_CODE']);
			grdRecord.set('RECEIPT_PRSN'		, panelSearch.getValue('RECEIPT_PRSN'));
			grdRecord.set('RECEIPT_DATE'		, panelSearch.getValue('RECEIPT_DATE'));
			grdRecord.set('INOUT_Q'				, 0);
			grdRecord.set('OLD_VAL'				, 0);
			grdRecord.set('LOT_NO'			, record['LOT_NO']);
			grdRecord.set('TRADE_FLAG_YN'	, 'Y');
		},
		setVmiData:function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('RECEIPT_NUM'			, panelSearch.getValue('RECEIPT_NUM'));
			grdRecord.set('DIV_CODE'			, panelSearch.getValue('DIV_CODE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('RECEIPT_Q'			, record['NOT_RECEIPT_Q']);
			grdRecord.set('NOT_RECEIPT_Q'		, record['NOT_RECEIPT_Q']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('INSPEC_FLAG'			, record['INSPEC_FLAG']);
			grdRecord.set('INOUT_NUM'			, '');
			grdRecord.set('INOUT_SEQ'			, 0);
			grdRecord.set('BASIS_NUM'			, '');
			grdRecord.set('BASIS_SEQ'			, 0);
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_Q'		, record['ORDER_UNIT_Q']);
			grdRecord.set('COMP_CODE'			, record['COMP_CODE']);
			grdRecord.set('RECEIPT_PRSN'		, panelSearch.getValue('RECEIPT_PRSN'));
			grdRecord.set('RECEIPT_DATE'		, panelSearch.getValue('RECEIPT_DATE'));
			grdRecord.set('DEPT_CODE'			, record['DEPT_CODE']);
			grdRecord.set('DEPT_NAME'			, record['DEPT_NAME']);
			grdRecord.set('WH_CODE'				, record['WH_CODE']);
			grdRecord.set('REF_ISSUE_NUM'		, record['ISSUE_NUM']);
			grdRecord.set('REF_ISSUE_SEQ'		, record['ISSUE_SEQ']);
			grdRecord.set('TRADE_FLAG_YN'	, 'N');
			panelSearch.setValue('CUSTOM_CODE'	, record['CUSTOM_CODE']);
			panelSearch.setValue('CUSTOM_NAME'	, record['CUSTOM_NAME']);
			panelResult.setValue('CUSTOM_CODE'	, record['CUSTOM_CODE']);
			panelResult.setValue('CUSTOM_NAME'	, record['CUSTOM_NAME']);
			panelSearch.setValue('DEPT_CODE'		, record['DEPT_CODE']);
			panelSearch.setValue('DEPT_NAME'		, record['DEPT_NAME']);
			panelResult.setValue('DEPT_CODE'	, record['DEPT_CODE']);
			panelResult.setValue('DEPT_NAME'	, record['DEPT_NAME']);
		/*	panelSearch.setValue('DIV_CODE'		, record['DIV_CODE']);
			panelResult.setValue('DIV_CODE'		, record['DIV_CODE']); */
			panelSearch.setValue('WH_CODE'		, record['WH_CODE']);
			panelResult.setValue('WH_CODE'		, record['WH_CODE']);

		}
	});

	var receiptNoMasterGrid = Unilite.createGrid('mms110ukrvreceiptNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
		layout : 'fit',
		excelTitle: '<t:message code="system.label.purchase.receiptentry2" default="접수등록"/>(<t:message code="system.label.purchase.receiptnosearch" default="접수번호검색"/>)',
		store: receiptNoMasterStore,
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false
		},
		columns:  [
			{ dataIndex: 'DIV_CODE'		,width:100 ,hidden: true},
			{ dataIndex: 'RECEIPT_NUM'	,width:110},
			{ dataIndex: 'RECEIPT_SEQ'	,width:50},
			{ dataIndex: 'RECEIPT_DATE'	,width:80},
			{ dataIndex: 'CUSTOM_CODE'	,width:80},
			{ dataIndex: 'CUSTOM_NAME'	,width:100},
			{ dataIndex: 'ITEM_CODE'		,width:100},
			{ dataIndex: 'ITEM_NAME'		,width:150},
			{ dataIndex: 'SPEC'				,width:100},
			{ dataIndex: 'ORDER_Q'			,width:80},
			{ dataIndex: 'RECEIPT_Q'		,width:80},
			{ dataIndex: 'NOT_RECEIPT_Q'	,width:80},
			{ dataIndex: 'RECEIPT_PRSN'		,width:80 ,align: 'center' ,hidden: true},
			{ dataIndex: 'ORDER_NUM'		,width:100},
			{ dataIndex: 'ORDER_SEQ'		,width:80},
			{ dataIndex: 'ORDER_PRSN'		,width:80 ,align: 'center'},
			{ dataIndex: 'LOT_NO'			,width:100},
			{ dataIndex: 'ORDER_TYPE'		,width:50 ,align: 'center' ,hidden: true},
			{ dataIndex: 'WH_CODE'			,width:50 ,align: 'center' ,hidden: true},
			{ dataIndex: 'BL_NO'			,width:100}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				receiptNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
				panelSearch.getField('ORDER_TYPE').focus();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelSearch.setValues({'DIV_CODE':record.get('DIV_CODE')});
			panelResult.setValues({'DIV_CODE':record.get('DIV_CODE')});
			panelSearch.setValues({'RECEIPT_NUM':record.get('RECEIPT_NUM')});
			panelSearch.setValues({'RECEIPT_DATE':record.get('RECEIPT_DATE')});
			panelResult.setValues({'RECEIPT_NUM':record.get('RECEIPT_NUM')});
			panelResult.setValues({'RECEIPT_DATE':record.get('RECEIPT_DATE')});
			panelSearch.setValues({'DEPT_CODE':record.get('DEPT_CODE')});
			panelSearch.setValues({'DEPT_NAME':record.get('DEPT_NAME')});
			panelResult.setValues({'DEPT_CODE':record.get('DEPT_CODE')});
			panelResult.setValues({'DEPT_NAME':record.get('DEPT_NAME')});
			panelSearch.setValues({'CUSTOM_CODE':record.get('CUSTOM_CODE')});
			panelSearch.setValues({'CUSTOM_NAME':record.get('CUSTOM_NAME')});
			panelResult.setValues({'CUSTOM_CODE':record.get('CUSTOM_CODE')});
			panelResult.setValues({'CUSTOM_NAME':record.get('CUSTOM_NAME')});
			panelSearch.setValues({'WH_CODE':record.get('WH_CODE')});
			panelResult.setValues({'WH_CODE':record.get('WH_CODE')});
			panelSearch.setValues({'RECEIPT_PRSN':record.get('RECEIPT_PRSN')});
			panelResult.setValues({'RECEIPT_PRSN':record.get('RECEIPT_PRSN')});
		}
	});

	var orderGrid = Unilite.createGrid('mms110ukrvOrderGrid', {//발주참조
		layout : 'fit',
		excelTitle: '<t:message code="system.label.purchase.receiptentry2" default="접수등록"/>(<t:message code="system.label.purchase.porefer" default="발주참조"/>)',
		store: orderStore,
		uniOpt:{
			onLoadSelectFirst : false
		},
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ) {
					 var records = orderStore.data.items;
					 var customCode = '';
					 data = new Object();
					 data.records = [];
					 var isErr = false;
					 Ext.each(records, function(record, i){
						 if( orderGrid.getSelectionModel().isSelected(record) == true) {
							 if(!Ext.isEmpty(customCode) && customCode != record.get('CUSTOM_CODE')){
								 alert("발주정보의 거래처를 2개 이상 선택할 수 없습니다.");
								 isErr = true;
								 return false;
							 }else{
								customCode = record.get('CUSTOM_CODE');
								 data.records.push(record);
							 }
						 }
					 });
					 orderGrid.getSelectionModel().select(data.records);
					 if(isErr == true){
						 return false;
					 }

				},
				deselect:  function(grid, selectRecord, index, eOpts ) {

				}
			}
		}),
		columns:  [
			{ dataIndex: 'DIV_CODE'				,width:93 ,hidden: true},
			{ dataIndex: 'CUSTOM_CODE'			,width:93 ,hidden: true},
			{ dataIndex: 'CUSTOM_NAME'			,width:150},
			{ dataIndex: 'ITEM_CODE'			,width:100},
			{ dataIndex: 'ITEM_NAME'			,width:200},
//			{ dataIndex: 'DEPT_CODE'			,width:80},
//			{ dataIndex: 'DEPT_NAME'			,width:80 ,align: 'center'},
			{ dataIndex: 'WH_CODE'				,width:80 ,align: 'center'},
			{ dataIndex: 'SPEC'					,width:80},
			{ dataIndex: 'DVRY_DATE'			,width:80},
			{ dataIndex: 'ORDER_DATE'			,width:80},
			{ dataIndex: 'ORDER_UNIT'			,width:86 ,align: 'center'},
			{ dataIndex: 'ORDER_UNIT_Q'			,width:86},
			{ dataIndex: 'NOT_RECEIPT_Q'		,width:86},
			{ dataIndex: 'MONEY_UNIT'			,width:80 ,align: 'center'},
			{ dataIndex: 'ORDER_UNIT_P'			,width:93},
			{ dataIndex: 'ORDER_O'				,width:93},
			{ dataIndex: 'ORDER_NUM'			,width:120},
			{ dataIndex: 'ORDER_SEQ'			,width:80},
			{ dataIndex: 'LOT_NO'				,width:100},
			{ dataIndex: 'ORDER_TYPE'			,width:93 ,align: 'center' ,hidden: true},
			{ dataIndex: 'ORDER_PRSN'			,width:93 ,align: 'center'},
			{ dataIndex: 'AGREE_STATUS'		,width:80 ,align: 'center'},
			{ dataIndex: 'REMARK'				,width:133},
			{ dataIndex: 'PROJECT_NO'			,width:133},
			{ dataIndex: 'COMP_CODE'			,width:80 ,hidden: true},
			//20191029 추가: 수주번호, 수주처, 수주품목명
			{ dataIndex: 'SO_NUM'				,width:100 ,hidden: false},
			{ dataIndex: 'SO_CUSTOM_NAME'		,width:150 ,hidden: false},
			{ dataIndex: 'SO_ITEM_NAME'			,width:200 ,hidden: false}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				var records = this.sortedSelectedRecords(this);
				Ext.each(records, function(record,i){
					UniAppManager.app.onNewDataButtonDown();
					masterGrid.setOrderData(record.data);
				});
				this.getStore().remove(records);
				 var records = directMasterStore1.data.items;
				 data = new Object();
				 data.records = [];
				 Ext.each(records, function(record, i){
					if(record.phantom == true) {
					 data.records.push(record);
					}
				 });
				 masterGrid.getSelectionModel().select(data.records);
				 referOrderWindow.hide();
			}
		},
		returnData: function() {
//			var records = this.getSelectedRecords();
			var records = this.sortedSelectedRecords(this);
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setOrderData(record.data);
			});
			this.getStore().remove(records);

		 /*	var records = directMasterStore1.data.items;
			Ext.each(records, function(record, i){
				masterGrid.getSelectionModel().select(i);
			}); */

			 var records = directMasterStore1.data.items;
			 data = new Object();
			 data.records = [];
			 Ext.each(records, function(record, i){
				if(record.phantom == true) {
				 data.records.push(record);
				}
			 });
			 masterGrid.getSelectionModel().select(data.records);

		}
	});
	var custGrid = Unilite.createGrid('custGrid', {//거래처참조
		layout : 'fit',
		excelTitle: '거래처참조',
		store: custStore,
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: true
		},
		selModel:'rowmodel',
		columns:  [
			{ dataIndex: 'CUSTOM_CODE'	,width:100 },
			{ dataIndex: 'CUSTOM_NAME'	,width:250 },
			{ dataIndex: 'ITEM_CNT'	,width:100 }
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {

				masterGrid.reset();
				directMasterStore1.clearData();

				custStoreDetail.clearData();
				custStoreDetail.loadStoreRecords(record.data);
				referCustWindow.hide();
			}
		}
	});
	var commerceGrid = Unilite.createGrid('mms110ukrvCommerceGrid', {//무역참조
		layout: 'fit',
		excelTitle: '<t:message code="system.label.purchase.receiptentry2" default="접수등록"/>(<t:message code="system.label.purchase.importrefer" default="수입참조"/>)',
		store: commerceStore,
		uniOpt:{
			onLoadSelectFirst : false
		},
		selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false }),
		columns: [
			{ dataIndex: 'COMP_CODE'			,width:66 ,hidden: true},
			{ dataIndex: 'CUSTOM_CODE'			,width:93 ,hidden: true},
			{ dataIndex: 'CUSTOM_NAME'			,width:120},
			{ dataIndex: 'ITEM_CODE'			,width:100},
			{ dataIndex: 'ITEM_NAME'			,width:150},
			{ dataIndex: 'SPEC'					,width:100},
			{ dataIndex: 'LOT_NO'			,width:100 },
			{ dataIndex: 'ORDER_UNIT'			,width:50, align:'center'},
			{ dataIndex: 'STOCK_UNIT'			,width:50 ,hidden: true},
			{ dataIndex: 'PRICE'					,width:80},
			{ dataIndex: 'QTY'					,width:80},
			{ dataIndex: 'NOT_RECEIPT_Q'		,width:80},
			{ dataIndex: 'INVOICE_DATE'			,width:80},
			{ dataIndex: 'LC_DATE'				,width:80},
			{ dataIndex: 'MONEY_UNIT'			,width:50 ,hidden: true},
			{ dataIndex: 'EXCHANGE_RATE'		,width:80},
			{ dataIndex: 'PRICE'				,width:80},
			{ dataIndex: 'AMT_O'				,width:93},
			{ dataIndex: 'AMT_I'				,width:133 ,hidden: true},
			{ dataIndex: 'LC_NO'				,width:100},
			{ dataIndex: 'BL_NO'				,width:100},
			{ dataIndex: 'BASIS_NUM'			,width:100},
			{ dataIndex: 'BASIS_SEQ'			,width:30},
			{ dataIndex: 'ORDER_TYPE'			,width:133 ,hidden: true},
			{ dataIndex: 'TRADE_LOC'			,width:66},
			{ dataIndex: 'SO_SER_NO'			,width:100},
			{ dataIndex: 'SO_SER'				,width:30},
			{ dataIndex: 'BL_NUM'				,width:100},
			{ dataIndex: 'PROJECT_NO'			,width:133 ,hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				var records = this.getSelectedRecords();
				Ext.each(records, function(record,i){
					UniAppManager.app.onNewDataButtonDown();
					masterGrid.setCommerceData(record.data);
				});
				this.deleteSelectedRow();
				referCommerceWindow.hide();

			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setCommerceData(record.data);
			});
			this.deleteSelectedRow();
			/* var records = directMasterStore1.data.items;
			Ext.each(records, function(record, i){
				masterGrid.getSelectionModel().deselect(i);
			}); */
			 var records = directMasterStore1.data.items;
			 data = new Object();
			 data.records = [];
			 Ext.each(records, function(record, i){
				if(record.phantom == true) {
				 data.records.push(record);
				}
			 });
			 masterGrid.getSelectionModel().select(data.records);
		}
	});

	var vmiGrid = Unilite.createGrid('mms110ukrvVmiGrid', {//vmi참조
		layout : 'fit',
		excelTitle: '<t:message code="system.label.purchase.receiptentry2" default="접수등록"/>(<t:message code="system.label.purchase.porefer" default="발주참조"/>)',
		store: vmiStore,
		uniOpt:{
			onLoadSelectFirst : false
		},
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ) {
					 var records = vmiStore.data.items;
					 var customCode = '';
					 data = new Object();
					 data.records = [];
					 var isErr = false;
					 Ext.each(records, function(record, i){
						 if( vmiGrid.getSelectionModel().isSelected(record) == true) {
							 if(!Ext.isEmpty(customCode) && customCode != record.get('CUSTOM_CODE')){
								 alert("발주정보의 거래처를 2개 이상 선택할 수 없습니다.");
								 isErr = true;
								 return false;
							 }else{
								customCode = record.get('CUSTOM_CODE');
								 data.records.push(record);
							 }
						 }
					 });
					 vmiGrid.getSelectionModel().select(data.records);
					 if(isErr == true){
						 return false;
					 }

				},
				deselect:  function(grid, selectRecord, index, eOpts ) {

				}
			}
		}),
		columns:  [
			{ dataIndex: 'DIV_CODE'				,width:93 ,hidden: true},
			{ dataIndex: 'CUSTOM_CODE'			,width:93 ,hidden: true},
			{ dataIndex: 'CUSTOM_NAME'			,width:150},
			{ dataIndex: 'ITEM_CODE'			,width:100},
			{ dataIndex: 'ITEM_NAME'			,width:200},
//			{ dataIndex: 'DEPT_CODE'			,width:80},
//			{ dataIndex: 'DEPT_NAME'			,width:80 ,align: 'center'},
			{ dataIndex: 'WH_CODE'				,width:80 ,align: 'center'},
			{ dataIndex: 'SPEC'					,width:80},
			{ dataIndex: 'DVRY_DATE'			,width:80},
			{ dataIndex: 'ORDER_DATE'			,width:80},
			{ dataIndex: 'ORDER_UNIT'			,width:86 ,align: 'center'},
			{ dataIndex: 'ORDER_UNIT_Q'			,width:86},
			{ dataIndex: 'NOT_RECEIPT_Q'		,width:86},
			{ dataIndex: 'MONEY_UNIT'			,width:80 ,align: 'center'},
			{ dataIndex: 'ORDER_UNIT_P'			,width:93},
			{ dataIndex: 'ORDER_O'				,width:93},
			{ dataIndex: 'ORDER_NUM'			,width:120},
			{ dataIndex: 'ORDER_SEQ'			,width:80},
			{ dataIndex: 'LOT_NO'				,width:100},
			{ dataIndex: 'ORDER_TYPE'			,width:93 ,align: 'center' ,hidden: true},
			{ dataIndex: 'ORDER_PRSN'			,width:93 ,align: 'center'},
			{ dataIndex: 'AGREE_STATUS'		,width:80 ,align: 'center'},
			{ dataIndex: 'REMARK'				,width:133},
			{ dataIndex: 'PROJECT_NO'			,width:133},
			{ dataIndex: 'COMP_CODE'			,width:80 ,hidden: true},
			{ dataIndex: 'ISSUE_NUM'			,width:133,hidden: true},
			{ dataIndex: 'ISSUE_SEQ'			,width:80 ,hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
//			var records = this.getSelectedRecords();
			var records = this.sortedSelectedRecords(this);
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setVmiData(record.data);
			});
			this.getStore().remove(records);
			var records = directMasterStore1.data.items;
			Ext.each(records, function(record, i){
				masterGrid.getSelectionModel().deselect(i);
			});
		}
	});

	function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.receiptnosearch" default="접수번호검색"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [receiptNoSearch, receiptNoMasterGrid], //receiptNoDetailGrid],
				tbar:  ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						receiptNoMasterStore.loadStoreRecords();
					},
					disabled: false
				}, {
					itemId : 'receiptNoCloseBtn',
					text: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						receiptNoSearch.clearForm();
						receiptNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						receiptNoSearch.clearForm();
						receiptNoMasterGrid.reset();
					},
					show: function( panel, eOpts ) {
						receiptNoSearch.setValue('DIV_CODE'			,panelSearch.getValue('DIV_CODE'));
						receiptNoSearch.setValue('RECEIPT_DATE_FR'	,UniDate.get('startOfMonth', panelSearch.getValue('RECEIPT_DATE')));
						receiptNoSearch.setValue('RECEIPT_DATE_TO'	,panelSearch.getValue('RECEIPT_DATE'));
						receiptNoSearch.setValue('DEPT_CODE'		,panelSearch.getValue('DEPT_CODE'));
						receiptNoSearch.setValue('DEPT_NAME'		,panelSearch.getValue('DEPT_NAME'));
						receiptNoSearch.setValue('WH_CODE'			,panelSearch.getValue('WH_CODE'));
						receiptNoSearch.setValue('CUSTOM_CODE'		,panelSearch.getValue('CUSTOM_CODE'));
						receiptNoSearch.setValue('CUSTOM_NAME'		,panelSearch.getValue('CUSTOM_NAME'));
						receiptNoSearch.setValue('RECEIPT_PRSN'		,panelSearch.getValue('RECEIPT_PRSN'));
						receiptNoSearch.setValue('ORDER_TYPE'		,panelSearch.getValue('ORDER_TYPE'));
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}

	function openOrderWindow() {			//발주참조
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!referOrderWindow) {
			referOrderWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.porefer" default="발주참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [orderSearch, orderGrid],
				tbar:  ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						orderStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmBtn',
					text: '<t:message code="system.label.purchase.receiptapply" default="접수적용"/>',
					handler: function() {
						orderGrid.returnData();
					},
					disabled: false
				},{
					itemId : 'confirmCloseBtn',
					text: '<t:message code="system.label.purchase.receiptafterapplyclose" default="접수적용 후 닫기"/>',
					handler: function() {
						orderGrid.returnData();
						referOrderWindow.hide();
						orderGrid.reset();
						orderSearch.clearForm();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler: function() {
						referOrderWindow.hide();
						orderGrid.reset();
						orderSearch.clearForm();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function ( me, eOpts ) {
					},
					show: function ( me, eOpts ) {
						orderSearch.setValue('DIV_CODE'		, panelSearch.getValue('DIV_CODE'));
						orderSearch.setValue('DEPT_CODE'	, panelSearch.getValue('DEPT_CODE'));
						orderSearch.setValue('DEPT_NAME'	, panelSearch.getValue('DEPT_NAME'));
						orderSearch.setValue('WH_CODE'		, panelSearch.getValue('WH_CODE'));
						orderSearch.setValue('CUSTOM_CODE'	, panelSearch.getValue('CUSTOM_CODE'));
						orderSearch.setValue('CUSTOM_NAME'	, panelSearch.getValue('CUSTOM_NAME'));
						orderSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfLastMonth'));
						orderSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
						orderSearch.setValue('DVRY_DATE_FR'	, '');
						orderSearch.setValue('DVRY_DATE_TO'	, '');
						orderSearch.setValue('ORDER_TYPE'	, panelSearch.getValue('ORDER_TYPE'));
					}
				}
			})
		}
		referOrderWindow.center();
		referOrderWindow.show();
	}
	function openCustWindow() {			//거래처참조
		if(!panelResult.getInvalidMessage()) return;	//필수체크
		if(!referCustWindow) {
			referCustWindow = Ext.create('widget.uniDetailWindow', {
				title: '거래처참조',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [custSearch, custGrid], //receiptNoDetailGrid],
				tbar:  ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						custStore.loadStoreRecords();
					},
					disabled: false
				}, {
					itemId : 'receiptNoCloseBtn',
					text: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler: function() {
						referCustWindow.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						custSearch.clearForm();
						custGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						custSearch.clearForm();
						custGrid.reset();
					},
					show: function( panel, eOpts ) {
						custSearch.setValue('DIV_CODE'			,panelSearch.getValue('DIV_CODE'));
						custSearch.setValue('ORDER_DATE_FR'	, UniDate.get('startOfLastMonth'));
						custSearch.setValue('ORDER_DATE_TO'	, UniDate.get('today'));
					}
				}
			})
		}
		referCustWindow.center();
		referCustWindow.show();
	}

	function openCommerceWindow() {			//무역참조
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!referCommerceWindow) {
			referCommerceWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.importrefer" default="수입참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [commerceSearch, commerceGrid],
				tbar:  ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						commerceStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmBtn',
					text: '<t:message code="system.label.purchase.receiptapply" default="접수적용"/>',
					handler: function() {
						commerceGrid.returnData();
					},
					disabled: false
				},{
					itemId : 'confirmCloseBtn',
					text: '<t:message code="system.label.purchase.receiptafterapplyclose" default="접수적용 후 닫기"/>',
					handler: function() {
						commerceGrid.returnData();
						referCommerceWindow.hide();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler: function() {
						referCommerceWindow.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function ( me, eOpts ) {
						commerceSearch.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
						commerceStore.loadStoreRecords();
					}
				}
			})
		}
		referCommerceWindow.center();
		referCommerceWindow.show();
	}

	function openVmiWindow() {			//vmi참조
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!referVmiWindow) {
			referVmiWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.porefer" default="발주참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [vmiSearch, vmiGrid],
				tbar:  ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						vmiStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmBtn',
					text: '<t:message code="system.label.purchase.receiptapply" default="접수적용"/>',
					handler: function() {
						vmiGrid.returnData();
					},
					disabled: false
				},{
					itemId : 'confirmCloseBtn',
					text: '<t:message code="system.label.purchase.receiptafterapplyclose" default="접수적용 후 닫기"/>',
					handler: function() {
						vmiGrid.returnData();
						referVmiWindow.hide();
						vmiGrid.reset();
						vmiSearch.clearForm();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler: function() {
						referVmiWindow.hide();
						vmiGrid.reset();
						vmiSearch.clearForm();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function ( me, eOpts ) {
					},
					show: function ( me, eOpts ) {
						vmiSearch.setValue('DIV_CODE'		, panelSearch.getValue('DIV_CODE'));
						vmiSearch.setValue('DEPT_CODE'	, panelSearch.getValue('DEPT_CODE'));
						vmiSearch.setValue('DEPT_NAME'	, panelSearch.getValue('DEPT_NAME'));
						vmiSearch.setValue('WH_CODE'		, panelSearch.getValue('WH_CODE'));
						vmiSearch.setValue('CUSTOM_CODE'	, panelSearch.getValue('CUSTOM_CODE'));
						vmiSearch.setValue('CUSTOM_NAME'	, panelSearch.getValue('CUSTOM_NAME'));
						vmiSearch.setValue('ORDER_DATE_FR'	, UniDate.get('startOfLastMonth'));
						vmiSearch.setValue('ORDER_DATE_TO'	, UniDate.get('today'));
						vmiSearch.setValue('DVRY_DATE_FR'	, '');
						vmiSearch.setValue('DVRY_DATE_TO'	, '');
						vmiSearch.setValue('ORDER_TYPE'	, panelSearch.getValue('ORDER_TYPE'));
					}
				}
			})
		}
		referVmiWindow.center();
		referVmiWindow.show();
	}


	var detailSearch = Unilite.createSearchForm('DetailForm', {
		layout :  {type : 'uniTable', columns : 3},
		items :[{
					fieldLabel: ' ',
					xtype:'uniTextfield',
					name: 'ADD_FIDS',
					hidden: true,
					width: 815
				},{
					fieldLabel: ' ',
					xtype:'uniTextfield',
					name: 'DEL_FIDS',
					hidden: true,
					width: 815
				}]
});

	var detailForm = Unilite.createForm('mms110ukrvDetail', {
		autoScroll:true,
		layout : 'fit',
		layout: {type: 'uniTable', columns: 4,tdAttrs: {valign:'top'}},
		defaults:{labelWidth:60},
		disabled:false,
		items :[{
					xtype:'xuploadpanel',
					id : 'mms110ukrvFileUploadPanel',
					itemId:'fileUploadPanel',
					flex:1,
					width: 975,
					height:300,
					listeners : {
					}
				}
		 ]
				,loadForm: function(gsSelRecord) {
					// window 오픈시 form에 Data load
					this.reset();
//					this.setActiveRecord(record || null);
					this.resetDirtyStatus();
					var win = this.up('uniDetailFormWindow');
//
					if(win) {	 // 처음 윈도열때는 윈독 존재 하지 않음.
						 win.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
						 win.setToolbarButtons(['prev','next'],true);
					}

					//첨부파일
					var fp = Ext.getCmp('mms110ukrvFileUploadPanel');
					//var selRecord1 = masterGrid.getSelectedRecord();
					var reiceptNumSeq = gsSelRecord.RECEIPT_NUM + gsSelRecord.RECEIPT_SEQ;
					if(!Ext.isEmpty(reiceptNumSeq)) {
						mms110ukrvService.getFileList({DOC_NO : reiceptNumSeq},
															function(provider, response) {
																fp.loadData(response.result.data);
															}
														 )
					}else {
						fp.clear(); //  fp.loadData() 실행 시 데이타 삭제됨.
					}
				}

				, listeners : {
//					uniOnChange : function( form, field, newValue, oldValue )   {
//						var b = form.isValid();
//						this.up('uniDetailFormWindow').setToolbarButtons(['saveBtn','saveCloseBtn'],b);
//						this.up('uniDetailFormWindow').setToolbarButtons(['prev','next'],!b);   // 저장이 필요할경우 이전 다음 disable
//					}

				}
	});  // detailForm


		function openDetailWindow(selRecord, isNew) {
			// 그리드 저장 여부 확인
			var edit = masterGrid.findPlugin('cellediting');
			if(edit && edit.editing) {
				setTimeout("edit.completeEdit()", 1000);
			}
			// 추가 Record 인지 확인
			if(isNew)   {
				//var r = masterGrid.createRow();
				//selRecord = r[0];
				selRecord = masterGrid.createRow();
				if(!selRecord)  {
					selRecord = masterGrid.getSelectedRecord();
				}
			}
			// form에 data load
			detailForm.loadForm(gsSelRecord);

			if(!detailWin) {
				detailWin = Ext.create('widget.uniDetailWindow', {
					title: '문서등록',
					width: 1000,
					height: 370,
					isNew: false,
					x:0,
					y:0,
					layout:{type:'vbox', align:'stretch'},
					items: [detailSearch,detailForm],
					tbar:  ['->',	{   itemId : 'confirmBtn',
											text: '문서저장',
											handler: function() {
												 //var selRecord1 = masterGrid.getSelectedRecord();
												 var reiceptNumSeq = gsSelRecord.RECEIPT_NUM + gsSelRecord.RECEIPT_SEQ;
												var fp = Ext.getCmp('mms110ukrvFileUploadPanel');
												var addFiles = fp.getAddFiles();
												console.log("addFiles : " , addFiles.length)

												if(addFiles.length > 0) {
													detailSearch.setValue('ADD_FIDS', addFiles );
												} else {
													detailSearch.setValue('ADD_FIDS', '' );
												}
												var param = {
													DOC_NO : reiceptNumSeq,
													ADD_FIDS : detailSearch.getValue('ADD_FIDS')
												}
												mms110ukrvService.insertQMS101(param , function(provider, response){})
											},
											disabled: false
										},
										{   itemId : 'confirmCloseBtn',
											text: '문저저장 후 닫기',
											handler: function() {
												//var selRecord1 = masterGrid.getSelectedRecord();
												var reiceptNumSeq = gsSelRecord.RECEIPT_NUM + gsSelRecord.RECEIPT_SEQ;
												var fp = Ext.getCmp('mms110ukrvFileUploadPanel');
												var addFiles = fp.getAddFiles();
												console.log("addFiles : " , addFiles.length)

												if(addFiles.length > 0) {
													detailSearch.setValue('ADD_FIDS', addFiles );
												} else {
													detailSearch.setValue('ADD_FIDS', '' );
												}
												var param = {
													DOC_NO : reiceptNumSeq,
													ADD_FIDS : detailSearch.getValue('ADD_FIDS')
												}
												mms110ukrvService.insertQMS101(param , function(provider, response){})

												detailWin.hide();
											},
											disabled: false
										},{   itemId : 'DeleteBtn',
											text: '삭제',
											handler: function() {
												var fp = Ext.getCmp('mms110ukrvFileUploadPanel');
												var delFiles = fp.getRemoveFiles();
												if(delFiles.length > 0) {
												 detailSearch.setValue('DEL_FIDS', delFiles );
												} else {
												 detailSearch.setValue('DEL_FIDS', '' );
												}
												if(!Ext.isEmpty(detailSearch.getValue('DEL_FIDS'))){
													if(confirm('문서를 삭제 하시겠습니까?')) {
														var param = {
															DEL_FIDS : detailSearch.getValue('DEL_FIDS')
														}
														mms110ukrvService.deleteQMS101(param , function(provider, response){})
													}
												}else{
													alert('삭제할 문서가 없습니다.');
													return false;
												}
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											text: '<t:message code="system.label.sales.close" default="닫기"/>',
											handler: function() {
												detailWin.hide();
											},
											disabled: false
										}
								],
					listeners : {
								 show:function( window, eOpts)  {
									detailForm.body.el.scrollTo('top',0);
								 }
					}
				})
			}

			detailWin.show();
			detailWin.center();

	}

	/***************************
	 *라벨 분할 출력 코드
	 *2019-11-04
	 ***************************/

	//라벨분할출력 폼
	var labelPartitionPrintSearch = Unilite.createSearchForm('labelPartitionPrintForm', {
		layout	: {type : 'uniTable', columns : 2},
		border:true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.oemitemcode" default="품번"/>',
			name		: 'LABEL_ITEM_CODE',
			xtype		: 'uniTextfield',
			align		: 'center',
			margin		: '0 0 0 0',
			decimalPrecision: 0,
			value		: 1,
			colspan		: 2,
			hidden		: false,
			readOnly	: true,
			fieldStyle: 'text-align: center;',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: 'LOT_NO',
			xtype		: 'uniTextfield',
			name		: 'LABEL_LOT_NO',
			margin		: '0 0 0 0',
			colspan		: 2,
			allowBlank	: true,
			align		: 'center',
			readOnly	: true,
			fieldStyle	: 'text-align: center;',
			holdable	: 'hold'
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>',
			xtype		: 'uniNumberfield',
			name		: 'LABEL_RECEIPT_QTY',
			margin		: '0 0 0 0',
			allowBlank	: true,
//			suffixTpl	: '&nbsp;M',
			hidden		: false,
			fieldStyle	: 'text-align: center;',
			holdable	: 'hold'
		},{
			xtype	: 'label',
			id		: 'LABEL_STOCK_UNIT',
			text	: '&nbsp;M',
			margin	: '0 0 0 0'
		},{
			fieldLabel	: 'LABEL_RECEIPT_NUM',
			xtype		: 'uniTextfield',
			name		: 'LABEL_RECEIPT_NUM',
			margin		: '0 0 0 0',
			allowBlank	: true,
			readOnly	: true,
			hidden		: true,
			holdable	: 'hold'
		},{
			fieldLabel	: 'LABEL_RECEIPT_SEQ',
			xtype		: 'uniNumberfield',
			name		: 'LABEL_RECEIPT_SEQ',
			margin		: '0 0 0 0',
			allowBlank	: true,
			hidden		: true,
			holdable	: 'hold'
		}]
	});


	 Unilite.defineModel('labelPartitonPrintModel', {		//라벨 분할 출력 모델
		fields: [
			{name: 'SEQ'		, text: '<t:message code="system.label.purchase.seq" default="순번"/>'		, type: 'int'},
			{name: 'PACK_QTY'	, text: '<t:message code="system.label.purchase.qty" default="수량"/>'		, type: 'int'},
			{name: 'PRINT_QTY'	, text: '<t:message code="system.label.purchase.printqty" default="출력매수"/>'	, type: 'int'}
		]
	});

	 var labelPartitonPrintStore = Unilite.createStore('labelPartitonPrintStore', {	//라벨분할출력스토어
		model: 'labelPartitonPrintModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'mms110ukrvService.selectLabelPrintList'
			}
		},
		loadStoreRecords: function() {
			var param= labelPartitionPrintSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
			}
		}
	});



	//라벨분할출력 폼
	var labelPartitionPrintSearch2 = Unilite.createSearchForm('labelPartitionPrintForm2', {
		layout		: {type:'vbox', align:'center', pack: 'center' },
		region: 'south',
		padding :'1 1 1 1',
		border:true,
		items	: [{
			xtype		: 'container',
			defaultType	: 'uniTextfield',
			layout		: {type : 'uniTable', columns : 2},
			items		: [{
				xtype	: 'button',
				name	: 'labelPrint',
				text	: '<t:message code="system.label.purchase.labelprint" default="라벨출력"/>',
				width	: 80,
				hidden	: false,
				handler : function() {
					var param		= labelPartitionPrintSearch.getValues();
					param.PGM_ID	= 'mms110ukrv';
					param.MAIN_CODE	= 'M030';
					param.GUBUN		= panelResult.getValues().GUBUN;	//20210616 추가: 출력할 리포트 파일 선택 시, 최우선적으로 공통코드 B706 검색해서 REF_CODE2, REF_CODE3 값이 없을 때, 기존로직 수행하도록 변경.. 구분값에 sub_code값을 넘김
					var packQtyList;
					var printQtyList;
					var receiptNumList;
					var receiptSeqList;
					var seqList;
					var dataCount = 0;

					Ext.each(labelPartitonPrintStore.data.items, function(record, idx) {
						if(record.get("PACK_QTY") > 0 && record.get("PRINT_QTY") > 0) {
							if(dataCount == 0){
								packQtyList	= record.get("PACK_QTY");
								printQtyList= record.get("PRINT_QTY");
								seqList		= record.get("SEQ");
								dataCount	= dataCount + 1;
							}else{
								packQtyList	= packQtyList	+ ',' + record.get("PACK_QTY");
								printQtyList= printQtyList	+ ',' + record.get("PRINT_QTY");
								seqList		= seqList		+ ',' + record.get("SEQ");
								dataCount	= dataCount		+ 1;
							}
						}
					});
					if(dataCount == 0){
						alert('출력할 데이터가 없습니다.');
						return false;
					}
					param["seqList"]	= seqList;
					param["dataCount"]	= dataCount;
					param["PACK_QTY"]	= packQtyList;
					param["PRINT_QTY"]	= printQtyList;
					param["DIV_CODE"]	= panelResult.getValue('DIV_CODE');

					//20210616 추가: 출력할 리포트 파일 선택 시, 최우선적으로 공통코드 B706 검색해서 REF_CODE2, REF_CODE3 값이 없을 때, 기존로직 수행하도록 변경
					if(!Ext.isEmpty(param.GUBUN)) {		//구분필드에 값이 있을 때만 B706 먼저 검색
						mms110ukrvService.getReportFileInfo(param, function(provider, response) {
							if(provider) {
								param.RPT_INFO = provider;
							}
							var win = Ext.create('widget.ClipReport', {
								url		: CPATH+'/mms/mms110clukrv_partition.do',
								prgID	: 'mms110ukrv',
								extParam: param
							});
							win.center();
							win.show();
						});
					} else {							//아니면 기존로직 수행
						var win = Ext.create('widget.ClipReport', {
							url		: CPATH+'/mms/mms110clukrv_partition.do',
							prgID	: 'mms110ukrv',
							extParam: param
						});
						win.center();
						win.show();
					}
				}
			},{
				xtype	: 'button',
				name	: 'btnCancel',
				text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
				width	: 80,
				hidden	: false,
				handler	: function() {
					labelPartitionPrintSearch.clearForm();
					labelPartitionPrintWindow.hide();
				}
			}]
		}]
	});
	var labelPartitionPrintGrid = Unilite.createGrid('mms110ukrvPartitionPrintGrid', {		//라벨분할그리드
		layout :'fit',
		store: labelPartitonPrintStore,
		uniOpt: {
			userToolbar:true,
			expandLastColumn: false,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: false,
			state: {
				useState: false,
				useStateList: false
			}
		},
		tbar: [{itemId: 'labelPartitonReset',
				text: '<div style="color: blue"><t:message code="system.label.purchase.reset2" default="초기화"/></div>',
				handler: function() {
					labelPartitonPrintStore.loadStoreRecords();
				}
			 }],
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false},
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true} ],
		columns:  [
			{ dataIndex: 'SEQ'			,width:50, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
					}
			},
			{ dataIndex: 'PACK_QTY'		,width:147 ,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {

					var sumPrintQ = 0;
					Ext.each(labelPartitonPrintStore.data.items, function(record, idx) {
						sumPrintQ = sumPrintQ + record.get('PACK_QTY') * record.get('PRINT_QTY');
					});

					return  Ext.util.Format.number(sumPrintQ, '0,000');
				}
			},
			{ dataIndex: 'PRINT_QTY'		,width:147, summaryType: 'sum'}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['PACK_QTY','PRINT_QTY'])){
					return true;
				}else{
					return false;
				}
			}
		}
	});

	function openLabelPartitionWindow() {
		//if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!labelPartitionPrintWindow) {
			labelPartitionPrintWindow = Ext.create('widget.uniDetailWindow', {
				title		: '<t:message code="system.label.purchase.label" default="라벨"/><t:message code="system.label.purchase.partition" default="분할"/><t:message code="system.label.purchase.print" default="출력"/>',
				width		: 360,
				height		: 380,
				//resizable	: false,
				layout		:{type:'vbox', align:'stretch'},
				items		: [labelPartitionPrintSearch, labelPartitionPrintGrid, labelPartitionPrintSearch2],
				listeners	: {
					beforehide	: function(me, eOpt) {
						labelPartitionPrintGrid.reset();
						labelPartitonPrintStore.clearData();
						labelPartitionPrintSearch.clearForm();
						//labelPartitonPrintStore.loadStoreRecords();
					},
					beforeclose: function( panel, eOpts ) {

					},
					beforeshow: function ( me, eOpts ) {

					},
					show: function(me, eOpts) {
						labelPartitonPrintStore.loadStoreRecords();
					}
				}
			})
		}
		labelPartitionPrintWindow.center();
		labelPartitionPrintWindow.show();
	}

	Unilite.Main({
		id			: 'mms110ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function(){
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			this.setDefault();
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);

			/*20210616 추가: 극동의 라벨 출력 원부자재, 제품으로 구분해서 출력하기 위해 추가
			(공통코드 B706 읽어서 라디오버튼 필드 생성하므로 다른 사이트의 경우에도 초기화 시, hidden: false 조건에 추가하여 사용 가능)*/
			if(BsaCodeInfo.gsSiteCode == 'KDG'){
				panelResult.down('#GUBUN').setHidden(false);
			} else {
				panelResult.down('#GUBUN').setConfig('allowBlank', true);
				panelResult.down('#GUBUN').setHidden(true);
			}
			if(BsaCodeInfo.gsSiteCode == 'MIT'){
				panelResult.down('#btnReceiptPrint').setText( '<div style="color: red">수입검사요청서</div>');
				//Ext.getCmp('btnReceiptPrint').btnInnerEl.setStyle({color:"red"});
			}
//			panelSearch.setValue('ORDER_TYPE'	,'1');
//			panelSearch.setValue('RECEIPT_PRSN'	,BsaCodeInfo.gsReceiptPrsn);
//			panelResult.setValue('RECEIPT_PRSN'	,BsaCodeInfo.gsReceiptPrsn);
		},
		onQueryButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			var receiptNo = panelSearch.getValue('RECEIPT_NUM');
			if(Ext.isEmpty(receiptNo)) {
				openSearchInfoWindow()
				receiptNoSearch.getField('DIV_CODE').focus();
			} else {
				var param= panelSearch.getValues();
				directMasterStore1.loadStoreRecords();
			};
		},
		onNewDataButtonDown: function() {
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
			 var receiptNum = panelSearch.getValue('RECEIPT_NUM');
			 var seq = directMasterStore1.max('RECEIPT_SEQ');
			 if(!seq) seq = 1;
			 else  seq += 1;
			 var r = {
				RECEIPT_NUM: receiptNum,
				RECEIPT_SEQ: seq
			};
			masterGrid.createRow(r,'ITEM_CODE',seq-2);
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			//20200507 수정: 저장 시, 체크여부 확인하여 체크되지 않은 데이터가 존재할 경우 저장여부 확인 후 저장 진행
			var records	= directMasterStore1.data.items;
			var saveFlag= true;
			Ext.each(records, function(record, i) {
				if(masterGrid.getSelectionModel().isSelected(record) == false) {
					saveFlag = false;
					return false;
				}
			});
			if(!saveFlag) {
				if(confirm('체크되지 않은 항목이 존재합니다. 진행하시겠습니까?')) {
//					alert('저장진행')
					directMasterStore1.saveStore();
				}
			} else {
//				alert('저장진행');
				directMasterStore1.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom == true) {
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')){
						var divCode = panelSearch.getValue('DIV_CODE');
						var receiptNum = selRow.get('RECEIPT_NUM');
						var receiptSeq = selRow.get('RECEIPT_SEQ');
						UniAppManager.app.fnInOutQtyCheck(selRow, divCode, receiptNum, receiptSeq);
			}
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore1.data.items;
			var isNewData = false;

			var firstRecord = directMasterStore1.getAt(0);
			var divCode = panelSearch.getValue('DIV_CODE');
			var receiptNum = firstRecord.get('RECEIPT_NUM');
			var isErr = false;
			var param = {
					'DIV_CODE'   : divCode,
					'RECEIPT_NUM' : receiptNum
				}
			mms110ukrvService.inOutQtyCheck(param, function(provider, response){
				if(!Ext.isEmpty(provider) && provider.length > 0 ) {
						alert('<t:message code="system.message.purchase.message065" default="입고된 수량이 존재합니다. 삭제 할 수 없습니다."/>');
						return false;
				}else{
					Ext.each(records, function(record,i) {
						if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
							isNewData = true;
						}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
							if(confirm('<t:message code="system.message.purchase.message008" default="전체삭제 하시겠습니까?"/>')) {
								{
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
				}
			})
		},
		setDefault: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('RECEIPT_DATE',new Date());
			panelResult.setValue('RECEIPT_DATE',new Date());
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
			var field = panelSearch.getField('RECEIPT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('RECEIPT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = receiptNoSearch.getField('RECEIPT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = orderSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			panelSearch.setValue('RECEIPT_PRSN'	,BsaCodeInfo.gsReceiptPrsn);
			panelResult.setValue('RECEIPT_PRSN'	,BsaCodeInfo.gsReceiptPrsn);

		},
		fnInspecQtyCheck: function(rtnRecord, fieldName, oldValue, divCode, receiptNum, receiptSeq) {
			var param = {
				'DIV_CODE':divCode,
				'RECEIPT_NUM':receiptNum,
				'RECEIPT_SEQ':receiptSeq
			}
			mms110ukrvService.inspecQtyCheck(param, function(provider, response) {				//QMS200T의 검사량 가져옴
				if(!Ext.isEmpty(provider) && provider.length > 0 ) {
					alert('<t:message code="system.message.purchase.message049" default="검사된 수량이 존재합니다. 데이터를 삭제할 수 없습니다."/>');
					rtnRecord.set(fieldName, oldValue);
					UniAppManager.app.onQueryButtonDown();
				}
			})
		},
		fnInOutQtyCheck: function(rtnRecord, divCode, receiptNum, receiptSeq) {
			var isErr = true;
			var param = {
				'DIV_CODE'   : divCode,
				'RECEIPT_NUM' : receiptNum,
				'RECEIPT_SEQ' : receiptSeq
			}
			mms110ukrvService.inOutQtyCheck(param, function(provider, response){
				if(!Ext.isEmpty(provider) && provider.length > 0 ) {
						alert('<t:message code="system.message.purchase.message065" default="입고된 수량이 존재합니다. 삭제 할 수 없습니다."/>');
						isErr = false;
				}else{
					masterGrid.deleteSelectedRow();
				}
			})
			return isErr;
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelSearch.getValue('RECEIPT_NUM'))) {
				alert('<t:message code="system.label.purchase.receiptno2" default="접수번호"/>:<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return panelSearch.setAllFieldsReadOnly(true);
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		onPrintButtonDown: function(){
			var param			= panelResult.getValues();
			var selectedDetails	= masterGrid.getSelectedRecords();
			if(Ext.isEmpty(selectedDetails)){
				Unilite.messageBox('출력할 데이터를 선택하여 주십시오.');
				return;
			}
			param.PGM_ID	= PGM_ID;
			param.MAIN_CODE	= 'M030';
			param.GUBUN		= panelResult.getValues().GUBUN;	//20210616 추가: 출력할 리포트 파일 선택 시, 최우선적으로 공통코드 B706 검색해서 REF_CODE2, REF_CODE3 값이 없을 때, 기존로직 수행하도록 변경.. 구분값에 sub_code값을 넘김
			var seqPrint	= '';
			Ext.each(selectedDetails, function(record, idx) {
				if(idx ==0) {
					seqPrint = record.get("RECEIPT_SEQ");
				}else{
					seqPrint = seqPrint + ',' + record.get("RECEIPT_SEQ");
				}
			});
			param.RECEIPT_SEQS= seqPrint;

			//20210616 추가: 출력할 리포트 파일 선택 시, 최우선적으로 공통코드 B706 검색해서 REF_CODE2, REF_CODE3 값이 없을 때, 기존로직 수행하도록 변경
			if(!Ext.isEmpty(param.GUBUN)) {		//구분필드에 값이 있을 때만 B706 먼저 검색
				mms110ukrvService.getReportFileInfo(param, function(provider, response) {
					if(provider) {
						param.RPT_INFO = provider;
					}
					var win = Ext.create('widget.ClipReport', {
						url		: CPATH+'/mms/mms110clukrv.do',
						prgID	: 'mms110ukrv',
						extParam: param
					});
					win.center();
					win.show();
				});
			} else {							//아니면 기존로직 수행
				var win = Ext.create('widget.ClipReport', {
					url		: CPATH+'/mms/mms110clukrv.do',
					prgID	: 'mms110ukrv',
					extParam: param
				});
				win.center();
				win.show();
			}
		}
	});

	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "RECEIPT_Q" ://접수량, 과입고 가능량 체크
					if(newValue < 1 ){
						rv='<t:message code="system.label.purchase.message064" default="접수량이 1보다 작거나 데이터가 없습니다."/>';
						break;
					}
					if(newValue != "-"){
						var dOrderQ		= record.get('ORDER_UNIT_Q');												//발주량
						var dReceiptQ	= newValue - Unilite.nvl(record.get('OLD_VAL'), 0);							//실접수량
						var dNReceiptQ	= record.get('NOT_RECEIPT_Q');												//미접수량
						var dEnableQ	= (dOrderQ + (dOrderQ * Unilite.nvl(BsaCodeInfo.glPerCent, 0) / 100));		//접수가능량
						var dTempQ		= (dOrderQ - dNReceiptQ + dReceiptQ);										//실접수량
						if(dNReceiptQ > 0){																			//미접수량이 있으면
							if (dTempQ > dEnableQ){
								dEnableQ = dNReceiptQ + Unilite.nvl(record.get('OLD_VAL'), 0) + (dEnableQ - dOrderQ);
								rv ='<t:message code="system.label.purchase.message065" default="접수량은 발주량에 과접수허용률을 적용한 접수가능량보다 클 수 없습니다."/>' + '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>' + ": " + dEnableQ;
							}
						break;
						}
					}
					if(record.obj.phantom == false){
						var divCode		= panelSearch.getValue('DIV_CODE');
						var receiptNum	= record.get('RECEIPT_NUM');
						var receiptSeq	= record.get('RECEIPT_SEQ');
						UniAppManager.app.fnInspecQtyCheck(record, fieldName, oldValue, divCode, receiptNum, receiptSeq );
					}
				break;

				case "MAKE_DATE" :
					if(!Ext.isEmpty(record.get('ITEM_CODE'))){
						if(!Ext.isEmpty(newValue)){
							var params = {
								'ITEM_CODE' : record.get('ITEM_CODE')
							};
							mms110ukrvService.selectExpirationdate(params, function(provider, response) {
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
			}
			return rv;
		}
	});
};
</script>