<%--
'   프로그램명 : 수주등록 (영업)
'   작   성   자 : (주)시너지시스템즈 개발실
'   작   성   일 :
'   최종수정자 :
'   최종수정일 :
'   버         전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof100ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="T019"/>								<!-- 국내외 -->
<t:ExtComboStore comboType="AU" comboCode="B004"/>								<!-- 화폐단위 -->
<t:ExtComboStore comboType="AU" comboCode="S002"/>								<!-- 수주구분 -->
<t:ExtComboStore comboType="AU" comboCode="S007"/>								<!-- 출고유형 -->
<t:ExtComboStore comboType="AU" comboCode="S007" storeId="chkInoutDetailCode"/>	<!-- 출고유형 데이터 확인용 -->
<t:ExtComboStore comboType="AU" comboCode="B013"/>								<!-- 판매단위 -->
<t:ExtComboStore comboType="AU" comboCode="B059"/>								<!-- 과세여부 -->
<t:ExtComboStore comboType="AU" comboCode="S014"/>								<!-- 계산서대상 -->
<t:ExtComboStore comboType="AU" comboCode="S003"/>								<!-- 단가구분 -->
<t:ExtComboStore comboType="AU" comboCode="S011"/>								<!-- 수주상태 -->
<t:ExtComboStore comboType="AU" comboCode="S010"/>								<!-- 담당자 -->
<t:ExtComboStore comboType="AU" comboCode="B038"/>								<!-- 결제방법 -->
<t:ExtComboStore comboType="AU" comboCode="S024"/>								<!-- 부가세유형 -->
<t:ExtComboStore comboType="AU" comboCode="S046"/>								<!-- 승인상태 -->
<t:ExtComboStore comboType="AU" comboCode="B030"/>								<!-- 세액포함여부 -->
<t:ExtComboStore comboType="AU" comboCode="B116"/>								<!-- 단가계산기준 -->
<t:ExtComboStore comboType="AU" comboCode="S065"/>								<!-- 주문구분 -->
<t:ExtComboStore comboType="AU" comboCode="WB06"/>								<!-- B/OUT관리여부 -->
<t:ExtComboStore comboType="AU" comboCode="B131"/>								<!-- 예/아니오 -->
<t:ExtComboStore comboType="AU" comboCode="T005"/>								<!-- 가격조건 -->
<t:ExtComboStore comboType="AU" comboCode="T006"/>								<!-- 결제조건 -->
<t:ExtComboStore comboType="AU" comboCode="T016"/>								<!-- 대금결제방법 -->
<t:ExtComboStore comboType="AU" comboCode="T004"/>
<t:ExtComboStore comboType="AU" comboCode="T010"/>
<t:ExtComboStore comboType="AU" comboCode="T011"/>
<t:ExtComboStore comboType="AU" comboCode="T008"/>
<t:ExtComboStore comboType="BOR120" pgmId="sof100ukrv"/>						<!-- 사업장 -->
<t:ExtComboStore comboType="OU"  />												<!-- 창고 -->
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />					<!-- 창고 -->
<t:ExtComboStore comboType="AU" comboCode="S173"/>								<!-- 파렛트 종류 -->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<script type="text/javascript">
var srmWindow					//SRM 데이터 중 미등록된 데이터 보여줄 WINDOW
var SearchInfoWindow;			//SearchInfoWindow : 검색창
var referEstimateWindow;		//견적참조
var referOrderRecordWindow;		//수주이력참조
var referExpectedReqWindow;		//출하예정참조 - 20191231 추가
var excelWindow;				//엑셀참조
var detailWin;
var contextMenu;
var isLoad		= false;		//로딩 플래그 화폐단위 환율 change 로드시 계속 타므로 임시로 막음
var gsLastDate	= '';
var gsStatusM	= 'N';
var offerNoChk	= '';
var inoutTypeChk= 'Y';
var gsOldValue;					//20191017 추가: 수주일 변경 시, 유효일 변경여부 확인하기 위해 수주일 이전 값 저장하기 위한 변수 선언

// controller에서 값을 받아서옴 model.Attribut()
var BsaCodeInfo = {
	gsBalanceOut		: '${gsBalanceOut}',
	gsCreditYn			: '${gsCreditYn}',
	gsAutoType			: '${gsAutoType}',
	gsMoneyUnit			: '${gsMoneyUnit}',
	gsVatRate			: ${gsVatRate},
	gsProdtDtAutoYN		: '${gsProdtDtAutoYN}',
	gsSaleAutoYN		: '${gsSaleAutoYN}',
	gsSof100ukrLink		: '${gsSof100ukrLink}',
	gsSrq100UkrLink		: '${gsSrq100UkrLink}',
	gsSrq100UkrPath		: '${gsSrq100UkrPath}',
	gsStr100UkrLink		: '${gsStr100UkrLink}',
	gsSsa100UkrLink		: '${gsSsa100UkrLink}',
	gsProcessFlag		: '${gsProcessFlag}',
	gsCondShowFlag		: '${gsCondShowFlag}',
	gsDraftFlag			: '${gsDraftFlag}',
	gsApp1AmtInfo		: ${gsApp1AmtInfo},
	gsApp2AmtInfo		: ${gsApp2AmtInfo},
	gsTimeYN			: '${gsTimeYN}',
	gsScmUseYN			: '${gsScmUseYN}',
	gsPjtCodeYN			: '${gsPjtCodeYN}',
	gsPointYn			: '${gsPointYn}',
	gsUnitChack			: '${gsUnitChack}',
	gsPriceGubun		: '${gsPriceGubun}',
	gsWeight			: '${gsWeight}',
	gsVolume			: '${gsVolume}',
	gsOrderTypeSaleYN	: '${gsOrderTypeSaleYN}',
	gsProdSaleQ_WS03	: '${gsProdSaleQ_WS03}',
	gsProdDate_WS04		: '${gsProdDate_WS04}',		//20210222 수주등록시 생산요청일이 납기가 아닌 등록일자로 생성 체크여부  
	gsUseReceiveSrmYN   : '${gsUseReceiveSrmYN}',	//SRM 데이터수신 사용여부 확인 (공통코드 S146의 SUB_CODE = '1'의 REF_CODE1)
	gsSalesPrsn			: '${gsSalesPrsn}',
	gsDvryDate			: '${gsDvryDate}',			//계산된 납기일 관련 (S151)
	'gsSampleCodeYn'	: '${gsSampleCodeYn}',		//20190607 SAMPLE코드 사용여부(B912) - BsaCodeInfo.gsSampleCodeYn
	'gsPStockYn'		: '${gsPStockYn}',			//20190625 재고량, 가용재고로 표시 여부
	'gsRemarkInYn'		: '${gsRemarkInYn}',		//20190827 내부기록 필수여부 체크로직(S154)
	'gsAutoOfferNo'		: '${gsAutoOfferNo}',		//20190925 OFFER_NO 자동채번 여부
	'gsSNMinLen'		: '${gsSNMinLen}',			//수주번호 수동입력시 자릿수 제한 min값
	'gsSNMaxLen'		: '${gsSNMaxLen}',			//20191014 수주번호 수동입력일 경우, 자릿수 가져오는 로직		//수주번호 수동입력시 자릿수 제한 max값
	gsSiteCode			: '${gsSiteCode}',
	'gsButtonLink1'		: '${gsButtonLink1}',		//20210507 추가: 미수채권현황(정규), 매입/매출조회(WM) - 공통코드(S037.SUB_CODE = '1' 참고)
	'gsButtonLink2'		: '${gsButtonLink2}',		//20210507 추가: 기간별수불현황 조회(정규), 기간별 수불현황 조회(WM)(WM) - 공통코드(S037.SUB_CODE = '1' 참고)
	gsCreditMsg			: '${gsCreditMsg}',			//20210706추가 : 여신잔액 초과시 메세지 설정 - 공통코드('S181') 참고
	gsConfirmeYn		: '${gsConfirmeYn}'
};

var CustomCodeInfo = {
	gsAgentType		: '',
	gsCustCrYn		: '',
	gsUnderCalBase	: '',
	gsRefTaxInout	: ''
};

// var output ='';
// for(var key in BsaCodeInfo){
// output += key + ' : ' + BsaCodeInfo[key] + '\n';
// }
// Unilite.messageBox(output);

var outDivCode			= UserInfo.divCode;
// var checkDraftStatus = false;
var gsSaveRefFlag		= 'N';	//검색후에만 수정 가능하게 조회버튼 활성화..
var tempIndex			= 0;	//미등록상품 확인용..
var gsInoutDetailType	= '';	//전역 매출 유형 값
var gsAccountYnc		= '';	//전역 매출대상 값
var gsRemarkInYn		= BsaCodeInfo.gsRemarkInYn	== 'Y' ? false	: true;		//20190827 내부기록 필수여부 체크로직(S154)
var gsAutoOfferNo		= BsaCodeInfo.gsAutoOfferNo	== 'Y' ? true	: false;	//20190925 OFFER_NO 자동채번 여부
//20191014 추가: 수주번호 수동입력일 경우, 자릿수 가져오는 로직



var gsSNMinLen			= !Ext.isEmpty(BsaCodeInfo.gsSNMinLen) ? parseInt(BsaCodeInfo.gsSNMinLen) : 20
var gsSNMaxLen			= !Ext.isEmpty(BsaCodeInfo.gsSNMaxLen) ? parseInt(BsaCodeInfo.gsSNMaxLen) : gsSNMinLen


var excelConNm = 'sof100';
if(BsaCodeInfo.gsSiteCode == 'KDG'){
	excelConNm = 'sof100_kdg'
}
//20200527 추가: 배송처 누락관련 체크 flag
var dvryCustFlag = false;
if(BsaCodeInfo.gsSiteCode == 'MIT'){
	dvryCustFlag = true;
}
function appMain() {
	//자동채번 여부
	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoOrderNum = true;
	}

	//수주승인 방식
	var isDraftFlag = true;
	if(BsaCodeInfo.gsDraftFlag=='Y') {
		isDraftFlag = false;
	}



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sof100ukrvService.selectDetailList',
			update	: 'sof100ukrvService.updateDetail',
			create	: 'sof100ukrvService.insertDetail',
			destroy	: 'sof100ukrvService.deleteDetail',
			syncAll	: 'sof100ukrvService.saveAll'
		}
	});



	// 수주의 디테일 정보를 가지고 있는 모델
	Unilite.defineModel('sof100ukrvDetailModel', {
		fields: [
			{name: 'DIV_CODE'				, text:'<t:message code="system.label.sales.division" default="사업장"/>'								, type: 'string', allowBlank: false, comboType: 'BOR120'},
			{name: 'ORDER_NUM'				, text:'<t:message code="system.label.sales.sono" default="수주번호"/>'									, type: 'string', allowBlank: isAutoOrderNum /*, isPk:true, pkGen:'user' */},
			{name: 'SER_NO'					, text:'<t:message code="system.label.sales.seq" default="순번"/>'									, type: 'int', allowBlank: false , editable:false},
			{name: 'OUT_DIV_CODE'			, text:'<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'						, type: 'string', allowBlank: false , comboType: 'BOR120'},
			{name: 'SO_KIND'				, text:'<t:message code="system.label.sales.ordertype" default="주문구분"/>'							, type: 'string', allowBlank: false , comboType: 'AU', comboCode: 'S065', defaultValue: '10'},
			{name: 'ITEM_CODE'				, text:'<t:message code="system.label.sales.itemcode" default="품목코드"/>'								, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'				, text:'<t:message code="system.label.sales.itemname2" default="품명"/>'								, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text:'<t:message code="system.label.sales.itemaccount" default="품목계정"/>'							, type: 'string'},
			{name: 'SPEC'					, text:'<t:message code="system.label.sales.spec" default="규격"/>'									, type: 'string', editable:false},
			{name: 'HS_CODE'				, text:'<t:message code="system.label.sales.hsno" default="HS번호"/>'									, type: 'string'},
			{name: 'HS_NAME'				, text:'<t:message code="system.label.sales.hsname" default="HS명"/>'								, type: 'string'},
			{name: 'ORDER_UNIT'				, text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'							, type: 'string', allowBlank: false , comboType: 'AU', comboCode: 'B013'},
			{name: 'PRICE_TYPE'				, text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'							, type: 'string', defaultValue: BsaCodeInfo.gsPriceGubun, comboType:'AU', comboCode:'B116'},
			{name: 'TRANS_RATE'				, text:'<t:message code="system.label.sales.containedqty" default="입수"/>'							, type: 'uniQty', allowBlank: false, defaultValue: 1},
			{name: 'ORDER_Q'				, text:'<t:message code="system.label.sales.soqty" default="수주량"/>'									, type: 'uniQty', allowBlank: false, defaultValue: 0},
			{name: 'ORDER_P'				, text:'<t:message code="system.label.sales.price" default="단가"/>'									, type: 'uniUnitPrice', allowBlank: true, defaultValue: 0},
			{name: 'ORDER_P_CAL'			, text:'<t:message code="system.label.sales.price" default="단가"/>(for calc)'						, type: 'uniUnitPrice', allowBlank: true, defaultValue: 0},
			{name: 'ORDER_WGT_Q'			, text:'<t:message code="system.label.sales.soqtyweight" default="수주량(중량)"/>'						, type: 'int', defaultValue: 0},
			{name: 'ORDER_WGT_P'			, text:'<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'						, type: 'int', defaultValue: 0},
			{name: 'ORDER_VOL_Q'			, text:'<t:message code="system.label.sales.soqtyvolumn" default="수주량(부피)"/>'						, type: 'int', defaultValue: 0},
			{name: 'ORDER_VOL_P'			, text:'<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'						, type: 'int', defaultValue: 0},
			{name: 'ORDER_O'				, text:'<t:message code="system.label.sales.amount" default="금액"/>'									, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'TAX_TYPE'				, text:'<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'						, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'B059'},
			{name: 'ORDER_TAX_O'			, text:'<t:message code="system.label.sales.vatamount" default="부가세액"/>'							, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_O_TAX_O'			, text:'<t:message code="system.label.sales.sototalsum" default="수주합계"/>'							, type: 'uniPrice', defaultValue: 0/*, editable:false*/},		//20210611 수정: , editable:false 주석 - 수정 가능하게 변경
			{name: 'WGT_UNIT'				, text:'<t:message code="system.label.sales.weightunit" default="중량단위"/>'							, type: 'string', defaultValue: BsaCodeInfo.gsWeight},
			{name: 'UNIT_WGT'				, text:'<t:message code="system.label.sales.unitweight" default="단위중량"/>'							, type: 'int', defaultValue: 0},
			{name: 'VOL_UNIT'				, text:'<t:message code="system.label.sales.volumnunit" default="부피단위"/>'							, type: 'string', defaultValue: BsaCodeInfo.gsVolume},
			{name: 'UNIT_VOL'				, text:'<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'							, type: 'int', defaultValue: 0},
			{name: 'DVRY_DATE'				, text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'							, type: 'uniDate', allowBlank: false},
			{name: 'DVRY_TIME'				, text:'<t:message code="system.label.sales.deliverytime" default="납기시간"/>'							, type:'uniTime' , format:'His'},
			{name: 'DISCOUNT_RATE'			, text:'<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'						, type: 'uniPercent'},
			{name: 'ACCOUNT_YNC'			, text:'<t:message code="system.label.sales.salessubject" default="매출대상"/>'							, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'S014',  defaultValue: 'Y'},
			{name: 'SALE_CUST_CD'			, text:'<t:message code="system.label.sales.salesplacecode" default="매출처코드"/>'						, type: 'string', allowBlank: false},
			{name: 'CUSTOM_NAME'			, text:'<t:message code="system.label.sales.salesplace" default="매출처"/>'							, type: 'string', allowBlank: false},
			{name: 'PRICE_YN'				, text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'							, type: 'string', allowBlank: false , comboType: 'AU', comboCode: 'S003', defaultValue:'2'},
			{name: 'STOCK_Q'				, text:'<t:message code="system.label.sales.inventoryqty" default="재고량"/>'							, type: 'uniQty', editable:false},
			{name: 'PROD_SALE_Q'			, text:'<t:message code="system.label.sales.productionrequestqty" default="생산요청량"/>'				, type: 'uniQty'},
			{name: 'PROD_Q'					, text:'<t:message code="system.label.sales.productionrequestqtystock" default="생산요청량(재고단위)"/>'	, type: 'uniQty'},
			{name: 'PROD_END_DATE'			, text:'<t:message code="system.label.sales.productionrequestdate" default="생산요청일"/>'				, type: 'uniDate'},		//20190902: 생산완료일 -> 생산요청일로 명칭 변경
			{name: 'DVRY_CUST_CD'			, text:'<t:message code="system.label.sales.deliveryplacecode" default="배송처코드"/>'					, type: 'string'},
			{name: 'DVRY_CUST_NAME'			, text:'<t:message code="system.label.sales.deliveryplacename" default="배송처명"/>'					, type: 'string'},
			{name: 'ORDER_STATUS'			, text:'<t:message code="system.label.sales.forceclosing" default="강제마감"/>'							, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'S011', defaultValue: 'N'},
			{name: 'PO_NUM'					, text:'<t:message code="system.label.sales.pono2" default="PO 번호"/>'								, type: 'string'},
			{name: 'PO_SEQ'					, text:'<t:message code="system.label.sales.poseq2" default="PO 순번"/>'								, type: 'int'},
			{name: 'PROJECT_NO'				, text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'							, type: 'string'},
			//20200102 프로젝트명 추가
			{name: 'PJT_NAME'				, text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>'							, type: 'string', editable: false},
			{name: 'ISSUE_REQ_Q'			, text:'<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'					, type: 'uniQty' , defaultValue: 0, editable: false},
			{name: 'OUTSTOCK_Q'				, text:'OUTSTOCK_Q'				, type: 'int', defaultValue: 0},
			{name: 'RETURN_Q'				, text:'RETURN_Q'				, type: 'int', defaultValue: 0},
			{name: 'SALE_Q'					, text:'SALE_Q'					, type: 'int', defaultValue: 0},
			{name: 'PROD_PLAN_Q'			, text:'PROD_PLAN_Q'			, type: 'int'},
			{name: 'ORDER_UNIT_Q'			, text:'ORDER_UNIT_Q'			, type: 'uniQty', defaultValue: 0, allowBlank: false},
			{name: 'ESTI_NUM'				, text:'<t:message code="system.label.sales.estimateno" default="견적번호"/>'							, type: 'string', editable:false},
			{name: 'ESTI_SEQ'				, text:'<t:message code="system.label.sales.estimateseq" default="견적순번"/>'							, type: 'int', editable:false},
			{name: 'LAB_NO'					, text:'LAB_NO'					, type: 'string'},
			{name: 'REQST_ID'				, text:'샘플ID'					, type: 'string'},
			{name: 'STOCK_UNIT'				, text:'STOCK_UNIT'				, type: 'string'},
			{name: 'PRE_ACCNT_YN'			, text:'PRE_ACCNT_YN'			, type: 'string', defaultValue: 'Y'},
			{name: 'REF_ORDER_DATE'			, text:'REF_ORDER_DATE'			, type: 'string'},
			{name: 'REF_ORD_CUST'			, text:'REF_ORD_CUST'			, type: 'string'},
			{name: 'REF_ORDER_TYPE'			, text:'REF_ORDER_TYPE'			, type: 'string'},
			{name: 'REF_PROJECT_NO'			, text:'REF_PROJECT_NO'			, type: 'string'},
			{name: 'REF_TAX_INOUT'			, text:'REF_TAX_INOUT'			, type: 'string', defaultValue: '1'},
			{name: 'REF_MONEY_UNIT'			, text:'REF_MONEY_UNIT'			, type: 'string', defaultValue: BsaCodeInfo.gsMoneyUnit},
			{name: 'REF_EXCHG_RATE_O'		, text:'REF_EXCHG_RATE_O'		, type: 'int', defaultValue: 1},
			{name: 'REF_REMARK'				, text:'REF_REMARK'				, type: 'string'},
			{name: 'REF_BILL_TYPE'			, text:'REF_BILL_TYPE'			, type: 'string'},
			{name: 'REF_RECEIPT_SET_METH'	, text:'REF_RECEIPT_SET_METH'	, type: 'string'},
			{name: 'ORIGIN_Q'				, text:'ORIGIN_Q'				, type: 'int'},
			{name: 'REF_STOCK_CARE_YN'		, text:'REF_STOCK_CARE_YN'		, type: 'string'},
			{name: 'REF_WH_CODE'			, text:'REF_WH_CODE'			, type: 'string'},
			{name: 'REF_FLAG'				, text:'REF_FLAG'				, type: 'string', defaultValue: 'F'},
			{name: 'REF_ORDER_PRSN'			, text:'REF_ORDER_PRSN'			, type: 'string'},
			{name: 'REF_DVRY_CUST_NM'		, text:'REF_DVRY_CUST_NM'		, type: 'string'},
			{name: 'REQ_ISSUE_QTY'			, text:'REQ_ISSUE_QTY'			, type: 'int', defaultValue: '0'},
			{name: 'COMP_CODE'				, text:'COMP_CODE'				, type: 'string', allowBlank: false , defaultValue: UserInfo.compCode},
			{name: 'REMARK'					, text:'<t:message code="system.label.sales.remarks" default="비고"/>'								, type: 'string'},
			{name: 'STOCK_Q_TY'				, text:'STOCK_Q_TY'				, type: 'string'},
			{name: 'SCM_FLAG_YN'			, text:'SCM_FLAG_YN'			, type: 'string', defaultValue:'N'},
			{name: 'BARCODE'				, text:'<t:message code="system.label.sales.barcode" default="바코드"/>'								, type: 'string'},
			{name: 'DISCOUNT_MONEY'			, text:'<t:message code="system.label.sales.discountprice" default="할인가"/>'							, type: 'uniPrice'},
			{name: 'AGENT_TYPE'				, text:'AGENT_TYPE'				, type: 'string'},
			{name: 'CREDIT_YN'				, text:'CREDIT_YN'				, type: 'string'},
			{name: 'WON_CALC_BAS'			, text:'WON_CALC_BAS'			, type: 'string'},
			//{name: 'OUT_WH_CODE'			, text:'<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'						, type: 'string',  comboType: 'OU'},
			{name: 'OUT_WH_CODE'			, text:'<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'						, type: 'string', store: Ext.data.StoreManager.lookup('whList')},
			{name: 'INOUT_TYPE_DETAIL'		, text:'<t:message code="system.label.sales.salestype" default="판매구분"/>'							, type: 'string' , comboType: 'AU', comboCode: 'S007', allowBlank:false},
			// {name: 'PACK_TYPE'			, text:'포장유형'					, type: 'string'	, comboType: 'AU', comboCode: 'B138'}
			// {name: 'OEM_ITEM_CODE'		, text:'' 						, type: 'string'}
			// {name: 'TAX_TYPE'			, text:'TAX_TYPE'				, type: 'string'}
			{name: 'REMARK_INTER'			, text:'<t:message code="system.label.sales.remarkinter" default="내부기록사항"/>'						, type: 'string' , allowBlank: gsRemarkInYn},
			{name: 'INIT_DVRY_DATE'			, text:'INIT_DVRY_DATE'			, type: 'string'}, //최초납기일 저장용도
			//20190306 추가
			{name: 'CARE_YN'				, text: 'CARE_YN'				, type: 'string', comboType: 'AU'	, comboCode: 'B010'},
			{name: 'CARE_REASON'			, text: 'CARE_REASON'			, type: 'string'},
			{name: 'LOT_NO'					, text: 'LOT NO'				, type: 'string'},
			//20190607 SAMPLE_KEY 추가
			{name: 'SAMPLE_KEY'				, text: 'SAMPLE_KEY'			, type: 'string'},
			//20190725 고객명(RECEIVER_NAME), 송장번호(INVOICE_NUM) 추가
			{name: 'RECEIVER_NAME'			, text: '<t:message code="system.label.sales.clientname" default="고객명"/>'							, type: 'string'},
			{name: 'INVOICE_NUM'			, text: '<t:message code="system.label.sales.invoice" default="송장번호"/>'								, type: 'string'},
			//20190805 구매요청등록할 데이터 체크 컬럼,
			{name: 'PURCHASE_YN'			, text: '<t:message code="system.label.sales.purchaserequest" default="구매요청"/>'						, type: 'boolean'},
			{name: 'ISSUE_PLAN_DATE'		, text: 'ISSUE_PLAN_DATE'		, type: 'uniDate'},
			//20200117 추가
			{name: 'ISSUE_REQ_YN'			, text: 'ISSUE_REQ_YN'			, type: 'string'},
			//20200121 추가
			{name: 'ISSUE_PLAN_NUM'			, text: 'ISSUE_PLAN_NUM'		, type: 'string'},
			//20200824 추가
			{name: 'UPN_CODE'	    , text: '<t:message code="system.label.sales.upncode" default="UPN 코드"/>'	, type: 'string'},
			{name: 'BILL_TYPE'			,text: 'BILL_TYPE'					, type: 'string'},
			{name: 'ORDER_TYPE'			,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'			, type: 'string'},
			{name: 'SALE_CUST_NAME'	    ,text: 'SALE_CUST_NAME'				, type: 'string'},
			{name: 'ORDER_PRSN'	    	,text: 'ORDER_PRSN'					, type: 'string'},
			{name: 'NOTOUT_Q'			,text: '<t:message code="system.label.sales.undeliveryqty" default="미납량"/>'			, type: 'uniQty'},
			{name: 'SALE_CUST_NAME'	    ,text: 'SALE_CUST_NAME'				, type: 'string'},
			{name: 'SALE_CUST_NAME'	    ,text: 'SALE_CUST_NAME'				, type: 'string'},
			{name: 'SALE_CUST_NAME'	    ,text: 'SALE_CUST_NAME'				, type: 'string'},
			{name: 'ORDER_FOR_P'		,text: 'ORDER_FOR_P'				, type: 'string'},
			{name: 'ORDER_FOR_O'		,text: 'ORDER_FOR_O'				, type: 'string'},
			{name: 'TAX_INOUT'			,text: 'TAX_INOUT'					, type: 'string'},
			{name: 'REF_AGENT_TYPE'		,text: 'REF_AGENT_TYPE'				, type: 'string'},
			{name: 'REF_WON_CALC_TYPE'	,text: 'REF_WON_CALC_TYPE'			, type: 'string'},
			{name: 'REF_LOC'			,text: 'REF_LOC'					, type: 'string'},
			{name: 'ORDER_FOR_WGT_P'	,text: 'ORDER_FOR_WGT_P'			, type: 'string'},
			{name: 'ORDER_FOR_VOL_P'	,text: 'ORDER_FOR_VOL_P'			, type: 'string'},
			{name: 'ADDRESS'			,text: '<t:message code="system.label.sales.address" default="주소"/>'			, type: 'string'}
		]
	});

	// 수주정보스토어
	var detailStore = Unilite.createStore('sof100ukrvDetailStore', {
		model	: 'sof100ukrvDetailModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				this.fnOrderAmtSum2();
				if(records.length > 0) {
					gsStatusM = 'U';
				}
			},
			add: function(store, records, index, eOpts) {
				this.fnOrderAmtSum();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				console.log("modifiedFieldNames :",modifiedFieldNames)
				console.log("record :",record)
				// validation.validate( 'grid', modifiedFieldNames[0],
				// record.get( modifiedFieldNames[0]),
				// record.data[modifiedFieldNames[0]], record);
				
//				this.fnOrderAmtSum(); //20210602 모든 필드 수정시 중복으로 체크 및 수주총액,여신잔액이 변경되기 전 값으로 비교됨으로 제거 validate에서 각 수량금액 관련 필드에서 이미 같은 함수 호출 되고 있음
			},
			remove: function(store, record, index, isMove, eOpts) {
				this.fnOrderAmtSum2();
			}
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();
			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {
						inoutTypeChk = 'N';
						//20200210 수정
//						masterForm.setLoadRecord(records[0]);
						setTimeout(
							masterForm.setLoadRecord(records[0])
						, 100);
						masterForm.setValue('DVRY_DATE'	, records[0].get('DVRY_DATE'));
						panelResult.setValue('DVRY_DATE', records[0].get('DVRY_DATE'));
// panelResult.setLoadRecord(records[0]);
					}
				}
			});
		},
		saveStore: function() {
			var toCreate= this.getNewRecords();
			var toUpdate= this.getUpdatedRecords();
			var toDelete= this.getRemovedRecords();
			var list	= [].concat(toUpdate, toCreate);
			var isErr	= false;
			console.log("list:", list);

			//20191014 추가: 수주번호 수동입력일 경우, 수주번호 대문자로 변경하롤 로직 변경 - .toUpperCase(); 추가
			var orderNum = masterForm.getValue('ORDER_NUM').toUpperCase();
			Ext.each(list, function(record, index) {
				//20190627 주석
//				if(BsaCodeInfo.gsSampleCodeYn == 'Y' ) {
//					if(Ext.isEmpty(record.get('SAMPLE_KEY'))) {
//						Unilite.messageBox('LAB_NO(은)는 필수 입력입니다.');
//						isErr = true;
//						return false;
//					}
//				}
				if(record.data['ORDER_NUM'] != orderNum) {
					record.set('ORDER_NUM', orderNum);
				}
				if(record.get('ACCOUNT_YNC') == 'Y') {
					if(record.get('ORDER_P')== 0){
						Unilite.messageBox((index + 1) + '<t:message code="system.message.sales.message060" default="행의 입력값을 확인해 주세요."/>\n' + '<t:message code="system.message.sales.message071" default="매출대상은 단가가 필수 입력값 입니다."/>');
						isErr = true;
						return false;
					}
					if(record.get('ORDER_O') == 0){
						Unilite.messageBox((index + 1) + '<t:message code="system.message.sales.message060" default="행의 입력값을 확인해 주세요."/>\n' + '<t:message code="system.message.sales.message072" default="매출대상은 금액이 필수 입력값 입니다."/>');
						isErr = true;
						return false;
					}
				}
			})
			if(isErr) return false;

			//20200527 추가: 배송처 누락관련 체크 로직
			if(dvryCustFlag) {
				var chckCnt = 0;
				var chckIdx;
				var records = detailGrid.getStore().data.items;
				Ext.each(records, function(record, index) {
					if(!Ext.isEmpty(record.get('DVRY_CUST_CD'))) {
						chckCnt = chckCnt + 1;
					} else {
						if(Ext.isEmpty(chckIdx)) {
							chckIdx = record.get('SER_NO');
						} else {
							chckIdx = chckIdx + ', ' + record.get('SER_NO');
						}
					}
				})
				if(chckCnt > 0 && chckCnt != records.length) {
					if(!confirm('<t:message code="system.label.sales.seq" default="순번"/> ' + chckIdx + '<t:message code="system.message.sales.message151" default="의 배송처가 누락되었습니다."/>' + '\n' + '<t:message code="system.message.sales.message043" default="계속하시겠습니까?"/>')) {
						return false;
					}
				}
			}

			// 1. 마스터 정보 파라미터 구성
			
			var paramMaster= masterForm.getValues();	// syncAll 수정
			paramMaster.OPR_FLAG = gsStatusM;
			
			var sconfirmeyn = Ext.getCmp('taxConfirmeyn').getChecked()[0].inputValue;
			if(BsaCodeInfo.gsConfirmeYn == 'Y' && sconfirmeyn=='N') {
				paramMaster.STATUS = '1';
			}else if(BsaCodeInfo.gsConfirmeYn == 'Y' && sconfirmeyn=='Y') {
				paramMaster.STATUS = '6';
			}
			//UPN 코드 필수입력 확인
			var upnChk = true;
			if(masterForm.getValue("UPN_CHECK") == "Y")	{
				Ext.each(list, function(item, idx){
					if(Ext.isEmpty(item.get("UPN_CODE")))	{
						upnChk = false;
					}
				});
			}
			if(!upnChk)	{
				Unilite.messageBox('<t:message code="system.label.sales.upncode" default="UPN 코드"/> <t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				return ;
			}
			var paramTrade = panelTrade.getValues();
			var params = Ext.merge(paramMaster , paramTrade);
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						// 2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("ORDER_NUM", master.ORDER_NUM);
						panelResult.setValue("ORDER_NUM", master.ORDER_NUM);

						// 3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						if(detailStore.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						} else {
							UniAppManager.app.onQueryButtonDown();
						}

						var orderNum = masterForm.getValue("ORDER_NUM");
						if(Ext.isEmpty(orderNum)) {
							gsStatusM = 'N';
						} else {
							gsStatusM = 'U';
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('sof100ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		fnOrderAmtSum: function() {
			console.log("=============Exec fnOrderAmtSum()");
			var sumOrder = Ext.isNumeric(this.sum('ORDER_O')) ? this.sum('ORDER_O'):0;
			var sumTax = Ext.isNumeric(this.sum('ORDER_TAX_O')) ? this.sum('ORDER_TAX_O'):0;
			var sumTot = sumOrder+sumTax;

			masterForm.setValue('ORDER_O',sumOrder);
			masterForm.setValue('ORDER_TAX_O',sumTax);
			masterForm.setValue('TOT_ORDER_AMT',sumTot);
			panelResult.setValue('ORDER_O',sumOrder);
			panelResult.setValue('ORDER_TAX_O',sumTax);
			panelResult.setValue('TOT_ORDER_AMT',sumTot);
			masterForm.fnCreditCheck();
		},
		fnOrderAmtSum2: function() {
			console.log("=============Exec fnOrderAmtSum()");
			var sumOrder = Ext.isNumeric(this.sum('ORDER_O')) ? this.sum('ORDER_O'):0;
			var sumTax = Ext.isNumeric(this.sum('ORDER_TAX_O')) ? this.sum('ORDER_TAX_O'):0;
			var sumTot = sumOrder+sumTax;
			masterForm.setValue('ORDER_O',sumOrder);
			masterForm.setValue('ORDER_TAX_O',sumTax);
			masterForm.setValue('TOT_ORDER_AMT',sumTot);
			panelResult.setValue('ORDER_O',sumOrder);
			panelResult.setValue('ORDER_TAX_O',sumTax);
			panelResult.setValue('TOT_ORDER_AMT',sumTot);
			UniAppManager.setToolbarButtons(['save'], false);
		}
	});



	//미등록된 SRM 데이터
	Unilite.Excel.defineModel('Sof100ukrvModel_notRegisteredSRM', {
		fields: [
			{name: 'CUSTOM_ITEM_CODE'	, text: '<t:message code="ssystem.label.sales.item" default="품목"/>'		, type: 'string'},
			{name: 'SPECIFICATION'		, text: '<t:message code="system.label.sales.spec" default="규격"/>'		, type: 'string'},
			{name: 'DESCRIPTION'		, text: '<t:message code="system.label.sales.remarks" default="비고"/>'	, type: 'string'}
		]
	});

	var notRegisteredSRMStore = Unilite.createStore('sof100ukrvNotRegisteredSRMStore',{
		model: 'Sof100ukrvModel_notRegisteredSRM',
		uniOpt: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false
//		groupField: ''
	});




	//수주의 마스터 정보를 가지고 있는 Form
	var masterForm = Unilite.createSearchPanel('sof100ukrvMasterForm', {
		title		: '<t:message code="system.label.sales.soinfo" default="수주정보"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			},
			uniOnChange: function(basicForm, dirty, eOpts) {
				if(gsSaveRefFlag == "Y" && basicForm.getField('REMARK').isDirty() || (basicForm.getField('PROJECT_NO').isDirty()) || (basicForm.getField('DVRY_DATE').isDirty()) ){
				// UniAppManager.setToolbarButtons('save', true);
				} else if(detailStore.getCount() != 0 && masterForm.isDirty()) {
				// UniAppManager.setToolbarButtons('save', true);
				}
			}
		},
		items: [{
			title		: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('ORDER_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.domesticoverseasclass" default="국내외구분"/>',
				name		: 'NATION_INOUT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'T109',
				value		: '1',
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('NATION_INOUT', newValue);
						if(masterForm.getValue('NATION_INOUT') == '2') {	// 국외일시만 무역폼 활성화
							//20190925 OFFER_NO 자동채번 로직관련 수정- 자동채번일 경우에는 readOnly(true) 유지
							if(!gsAutoOfferNo) {
								masterForm.getField('OFFER_NO').setReadOnly(false);
								panelResult.getField('OFFER_NO').setReadOnly(false);
							}
							masterForm.setValue('BILL_TYPE'	, '60');
							panelResult.setValue('BILL_TYPE', '60');
							panelTrade.getForm().getFields().each(function(field) {
								field.setReadOnly(false);
							});
							panelTrade.setConfig('collapsed', false);
						} else {
							// 무역폼 readOnly: true
							masterForm.setValue('OFFER_NO'	, '');
							panelResult.setValue('OFFER_NO'	, '');
							masterForm.getField('OFFER_NO').setReadOnly(true);
							panelResult.getField('OFFER_NO').setReadOnly(true);
							masterForm.setValue('BILL_TYPE'	, '10');
							panelResult.setValue('BILL_TYPE', '10');
							panelTrade.getForm().getFields().each(function(field) {
								field.setReadOnly(true);
							});
							panelTrade.setConfig('collapsed', true);
						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name		: 'ORDER_TYPE',
				id			: 'ORDER_TYPE_ID',
				comboType	: 'AU',
				comboCode	: 'S002',
				xtype		: 'uniCombobox',
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
							console.log("[[inoutTypeChk1]]" + inoutTypeChk);
							var chk = inoutTypeChk;
							panelResult.setValue('ORDER_TYPE', newValue);
							UniAppManager.app.fnGetInoutDetailType(newValue, chk);//선택한 값에 따라 매출 유형 세팅
							inoutTypeChk = 'Y';
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.currency" default="화폐"/>',
				name		: 'MONEY_UNIT',
				comboType	: 'AU',
				comboCode	: 'B004',
				value		: BsaCodeInfo.gsMoneyUnit,
				xtype		: 'uniCombobox',
				allowBlank	: false,
				displayField: 'value',	//20200225 추가
				holdable	: 'hold',
				fieldStyle	: 'text-align: center;',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('MONEY_UNIT', newValue);
						//20190614 컬럼 / 필드 속성 설정하는 함수 호출
						UniAppManager.app.fnSetColumnFormat();
						//20191018 fnSetColumnFormat에서 처리하지 않고 직접 change에서 처리
						if(masterForm.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
							masterForm.setValue('NATION_INOUT'	,'2');
							panelResult.setValue('NATION_INOUT'	,'2');

						} else {
							masterForm.setValue('NATION_INOUT'	,'1');
							panelResult.setValue('NATION_INOUT'	,'1');
						}

//						if(isLoad){
//							isLoad = false;
//						} else {
//							UniAppManager.app.fnExchngRateO();
//						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.offerno" default="OFFER번호"/>',
				name		: 'OFFER_NO',
				readOnly	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('OFFER_NO', newValue);
					},
					focus: function(field, The, eOpts){
						offerNoChk = field.getValue().replace(/-/g,'');
					},
					blur: function(field, The, eOpts){
						var newValue = field.getValue().replace(/-/g,'');
						var nationInout = masterForm.getValue("NATION_INOUT");
						if(newValue != offerNoChk && nationInout == '2' && !Ext.isEmpty(newValue)){ //해외 일 경우에만
							var checkOfferNo = '';
							var param = panelResult.getValues();
							if(!Ext.isEmpty(masterForm.getValue('OFFER_NO'))){
								sof100ukrvService.checkOfferNo(param, function(provider2, response){
									if(!Ext.isEmpty(provider2)){
										checkOfferNo = provider2.data.OFFER_NO;
										Unilite.messageBox('[' + checkOfferNo + ']' + ' <t:message code="system.message.sales.message028" default="OFFER번호가 존재합니다."/>');
										 return false;
									}
								});
							}
						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.sono" default="수주번호"/>',
				name		: 'ORDER_NUM',
				readOnly	: isAutoOrderNum,
				holdable	: isAutoOrderNum ? 'readOnly':'hold',
				//20191014 추가
				maxLength	: !isAutoOrderNum ? gsSNMaxLen : 20,
				enforceMaxLength: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_NUM', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		:'<t:message code="system.label.sales.custom" default="거래처"/>',
				id				: 'CUSTOM_ID',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				holdable		: 'hold',
				allowBlank		: false,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							CustomCodeInfo.gsAgentType		= records[0]["AGENT_TYPE"];
							CustomCodeInfo.gsCustCrYn		= records[0]["CREDIT_YN"];
							CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"];
							CustomCodeInfo.gsRefTaxInout	= records[0]["TAX_TYPE"];	// 세액포함여부

							if(!Ext.isEmpty(CustomCodeInfo.gsRefTaxInout)){
								masterForm.setValue('TAX_INOUT'	, CustomCodeInfo.gsRefTaxInout)
								panelResult.setValue('TAX_INOUT', CustomCodeInfo.gsRefTaxInout)
							}

							if(CustomCodeInfo.gsCustCrYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
								// 여신액 구하기
								var divCode		= masterForm.getValue('DIV_CODE');
								var CustomCode	= masterForm.getValue('CUSTOM_CODE');
								var orderDate	= masterForm.getField('ORDER_DATE').getSubmitValue()
								var moneyUnit	= BsaCodeInfo.gsMoneyUnit;
								// 마스터폼에 여신액 set
								UniAppManager.app.fnGetCustCredit(divCode, CustomCode, orderDate, moneyUnit);
							}

							panelResult.setValue('CUSTOM_CODE'	, masterForm.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME'	, masterForm.getValue('CUSTOM_NAME'));
							masterForm.setValue('MONEY_UNIT'	, records[0].MONEY_UNIT);
							panelResult.setValue('MONEY_UNIT'	, records[0].MONEY_UNIT);

							/*20190320 거래처정보의 무역정보(bcm103t) 값 세팅 추가*/
							panelTrade.setValue('PAY_TERMS'		, records[0].PAY_TERMS);
							panelTrade.setValue('PAY_DURING'	, records[0].PAY_DURING);
							panelTrade.setValue('PAY_METHODE1'	, records[0].PAY_METHODE1);
							panelTrade.setValue('TERMS_PRICE'	, records[0].TERMS_PRICE);
							panelTrade.setValue('AGENT_CODE'	, records[0].AGENT_CODE);
							panelTrade.setValue('AGENT_NAME'	, records[0].AGENT_NAME);
							panelTrade.setValue('METH_CARRY'	, records[0].METH_CARRY);
							panelTrade.setValue('COND_PACKING'	, records[0].COND_PACKING);
							panelTrade.setValue('METH_INSPECT'	, records[0].METH_INSPECT);
							panelTrade.setValue('SHIP_PORT'		, records[0].SHIP_PORT);
							panelTrade.setValue('DEST_PORT'		, records[0].DEST_PORT);
							//20200103 추가: 20200109 주석
//							masterForm.setValue('SALE_CUST_CD'	, records[0].BILL_CUSTOM_CODE);
//							masterForm.setValue('SALE_CUST_NM'	, records[0].BILL_CUSTOM_NAME);

							if(!Ext.isEmpty(records[0].BUSI_PRSN)){//거래처의 주영업담당자가 있으면 영업담당 다시 세팅
								masterForm.setValue('ORDER_PRSN'	, records[0].BUSI_PRSN);
								panelResult.setValue('ORDER_PRSN'	, records[0].BUSI_PRSN);
							}
							masterForm.setValue('UPN_CHECK'	, records[0].UPN_CHECK);
							panelResult.setValue('UPN_CHECK', records[0].UPN_CHECK);
						},
						scope: this
					},
					onClear: function(type) {
						CustomCodeInfo.gsAgentType		= '';
						CustomCodeInfo.gsCustCrYn		= '';
						CustomCodeInfo.gsUnderCalBase	= '';
						CustomCodeInfo.gsRefTaxInout	= '';
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
						//20200103 추가: 20200109 주석
//						masterForm.setValue('SALE_CUST_CD', '');
//						masterForm.setValue('SALE_CUST_NM', '');
					}
				}
			}),{
				fieldLabel : '<t:message code="system.label.sales.upncheckyn" default="UPN 체크여부"/>',
				name : 'UPN_CHECK',
				hidden: true
			},{
				fieldLabel	: '<t:message code="system.label.sales.exchangerate" default="환율"/>',
				name		: 'EXCHANGE_RATE',
				xtype		: 'uniNumberfield',
				type		: 'uniER',
				holdable	: 'hold',
				decimalPrecision: 4,
				value		: 1,
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EXCHANGE_RATE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				name		: 'ORDER_DATE',
				xtype		: 'uniDatefield',
				value		: new Date(),
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						if(CustomCodeInfo.gsCustCrYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
							// 여신액 구하기
							var divCode		= masterForm.getValue('DIV_CODE');
							var CustomCode	= masterForm.getValue('CUSTOM_CODE');
							var orderDate	= UniDate.getDbDateStr(newValue);
							var moneyUnit	= BsaCodeInfo.gsMoneyUnit;
							// 마스터폼에 여신액 set
							UniAppManager.app.fnGetCustCredit(divCode, CustomCode, orderDate, moneyUnit);
						}
						panelResult.setValue('ORDER_DATE'	, newValue);
						if(!isLoad){
							masterForm.setValue('DVRY_DATE'		, newValue);
							panelResult.setValue('DVRY_DATE'	, newValue);
						}

						//20191017 추가: 작성일, 유효일 동일하게 SET - 단, 유효일은 수주일과 다를 때만
						if(!Ext.isEmpty(newValue) && UniDate.getDbDateStr(newValue).replace(/\./g,'').length == 8) {
							panelTrade.setValue('DATE_DEPART', newValue);
							if(UniDate.getDbDateStr(panelTrade.getValue('DATE_EXP')) == UniDate.getDbDateStr(gsOldValue)) {
								panelTrade.setValue('DATE_EXP', newValue);
							}
							gsOldValue = newValue;
						}
					},
					blur : function (e, event, eOpts) {
						if(UniDate.getDbDateStr(gsLastDate) != UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE'))) {
							UniAppManager.app.fnExchngRateO();
						}
						gsLastDate = gsLastDate = masterForm.getValue('ORDER_DATE');
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.receiptsetmeth" default="결제방법"/>',
				name		: 'RECEIPT_SET_METH',
				xtype		: 'uniCombobox',
				holdable	: 'hold',
				comboType	: 'AU',
				comboCode	: 'B038',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('RECEIPT_SET_METH', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name		: 'ORDER_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010',
				autoSelect: false,
				allowBlank	: false,
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					} else {
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.vattype" default="부가세유형"/>',
				name		: 'BILL_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S024',
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BILL_TYPE', newValue);
						
						// 20210224 : 부가세유형이 카드매출인 경우 카드사 readonly 비활성
						if('40' == newValue){
							masterForm.getField('CARD_CUSTOM_CODE').setReadOnly(false);
							panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(false);
						} else {
							masterForm.setValue('CARD_CUSTOM_CODE', '');
							panelResult.setValue('CARD_CUSTOM_CODE', '');
							masterForm.getField('CARD_CUSTOM_CODE').setReadOnly(true);
							panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(true);
						}
					}
				}
			// 20210224 : 카드사(CARD_CUSTOM_CODE) 추가
			},{
				fieldLabel	: '<t:message code="system.label.sales.cardcustomnm" default="카드사"/>' ,
				name		: 'CARD_CUSTOM_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A028',
				allowBlank	: true,
				holdable	: 'hold',
				readOnly    : true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CARD_CUSTOM_CODE',newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
				name		: 'DVRY_DATE',
				xtype		: 'uniDatefield',
				value		: UniDate.get('today'),
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DVRY_DATE', newValue);
					},
					blur : function (e, event, eOpts) {
						if(!Ext.isEmpty(masterForm.getValue('DVRY_DATE')) && masterForm.getValue('DVRY_DATE') < masterForm.getValue('ORDER_DATE')) {
							Unilite.messageBox('<t:message code="system.message.sales.message037" default="수주일 이후이어야 합니다."/>');
							masterForm.setValue('DVRY_DATE', '');
							panelResult.setValue('DVRY_DATE', '');
							masterForm.getField('DVRY_DATE').focus();
							return false;
						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>',
				name		: 'TAX_INOUT',
				id			: 'taxInout',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'B030',
				allowBlank	: false,
				holdable	: 'hold',
				width		: 235,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('TAX_INOUT').setValue(newValue.TAX_INOUT);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.remarks" default="비고"/>',
				xtype		: 'textarea',
				name		: 'REMARK',
				height		: 50,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('REMARK', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.confirmedpending" default="확정여부"/>',
				name		: 'CONFIRMEYN',
				id			: 'taxConfirmeyn',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'B131',
				allowBlank	: false,
				width		: 235,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('CONFIRMEYN').setValue(newValue.CONFIRMEYN);
					}
				}
			},{
				margin	: '0 0 0 95',
				xtype	: 'button',
				text	: '<t:message code="system.label.sales.purchaserequestentry" default="구매요청등록"/>',
				itemId	: 'purchaseRequest1',
				holdable: 'hold',
				hidden	: true,
				handler	: function() {
					if(!Ext.isEmpty(masterForm.getValue('ORDER_NUM')/* && masterForm.getValue('ORDER_REQ_YN') == "N"*/)){
						var param = {
							COMP_CODE	: UserInfo.compCode,
							ORDER_NUM	: masterForm.getValue('ORDER_NUM'),
							DIV_CODE	: masterForm.getValue('DIV_CODE')
						}
						var me = this;
						sof100ukrvService.insertPurchaseRequest(param, function(provider, response) {
						// var isSuccess = provider;
							if(provider){
								UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave001" default="구매요청 정보가 반영되었습니다."/>');
							}
						});
					}
				}
			}]
		},{
			title		: '<t:message code="system.label.sales.etcinfo" default="기타정보"/>',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [
				Unilite.popup('PROJECT',{
				fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
				validateBlank	: false,
				autoPopup		: true,
				holdable		: 'hold',
				textFieldName	: 'PROJECT_NO',
				itemId			: 'project',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							if(records) {
								panelResult.setValue('PROJECT_NO', records[0]["PJT_CODE"]);
								masterForm.setValue('PROJECT_NO', records[0]["PJT_CODE"]);
								//20200102 추가
								masterForm.setValue('PJT_NAME', records[0]["PJT_NAME"]);
							}
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('PROJECT_NO', '');
						masterForm.setValue('PROJECT_NO', '');
						//20200102 추가
						masterForm.setValue('PJT_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'BPARAM0': 3});
						//20190108 거래처와 무관 && 쿼리도 없음
//						popup.setExtParam({'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE')});
					},
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PROJECT_NO', newValue);
					}
				}
			}),{
				fieldLable	: 'gsAutoType',
				name		: 'gsAutoType',
				hidden		: true,
				value		: BsaCodeInfo.gsAutoType
			},{
				fieldLable	: 'gsDraftFlag',
				name		: 'gsDraftFlag',
				hidden		: true,
				value		: BsaCodeInfo.gsDraftFlag
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.sales.salesplace" default="매출처"/>',
				valueFieldName	: 'SALE_CUST_CD',
				textFieldName	: 'SALE_CUST_NM',
				validateBlank	: false,
				holdable		: 'hold',
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							masterForm.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							masterForm.setValue('CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.sales.soamount" default="수주액"/>',
				name		: 'ORDER_O',
				xtype		: 'uniNumberfield',
				type		: 'uniPrice',
				value		: 0,
				readOnly	: true
			},{
				fieldLabel	: '<t:message code="system.label.sales.vatamount" default="부가세액"/>',
				name		: 'ORDER_TAX_O',
				xtype		: 'uniNumberfield',
				type		:'uniPrice',
				value		: 0,
				readOnly	: true
			},{
				fieldLabel	: '<t:message code="system.label.sales.sototalamount" default="수주총액"/>',
				name		: 'TOT_ORDER_AMT',
				xtype		: 'uniNumberfield',
				type		: 'uniPrice',
				value		: 0,
				readOnly	: true
			},{
				fieldLabel	: '<t:message code="system.label.sales.pono2" default="PO 번호"/>',
				name		: 'PO_NUM',
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						var grdRecord = detailGrid.getSelectedRecord();
						panelResult.setValue('PO_NUM', newValue);
						if(!Ext.isEmpty(grdRecord) && !Ext.isEmpty(grdRecord.get('PO_NUM'))){
							grdRecord.set('PO_NUM', newValue);
						}
					}
				}
			},{
				xtype: 'container',
				items:[{
					fieldLabel	: '<t:message code="system.label.sales.creditbalance" default="여신잔액"/>',
					name		: 'REMAIN_CREDIT',
					xtype		: 'uniNumberfield',
					type		: 'uniPrice',
					value		: 0,
					readOnly	: true
				}]
			},{
				fieldLabel	: '<t:message code="system.label.sales.purchaserequestapplyyn" default="구매요청반영여부"/>',
				name		: 'ORDER_REQ_YN',
				xtype		: 'uniTextfield',
				hidden		: true
			},{
				margin  : '0 0 0 95',
				xtype   : 'button',
				text	: '<t:message code="system.label.sales.poRequest" default="발주요청"/>',
				itemId  : 'soToPoReq',
				holdable: 'hold',
				handler : function() {
					if(UniAppManager.app._needSave()) {
						Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
						return false;
					}
					if(masterForm.getValue('SEND_FLAG') == 'Y') {
						var type = 'D';
					} else {
						var type = 'N';
					}

					var param = {
						DIV_CODE	: masterForm.getValue('DIV_CODE'),
						ORDER_NUM	: masterForm.getValue('ORDER_NUM'),
						TYPE		: type
					}
					Ext.getBody().mask('<t:message code="system.label.sales.working" default="작업 중..."/>','loading-indicator');
					sof100ukrvService.soToPoRequest(param, function(provider, response) {
						if(!Ext.isEmpty(provider)){
							if(provider=='Y'){
								Unilite.messageBox('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
								UniAppManager.app.onQueryButtonDown();
							} else {
								Unilite.messageBox('<t:message code="system.message.sales.message125" default="작업 중 오류가 발생했습니다."/>');
							}
						}
						Ext.getBody().unmask();
					});
				}
			},{
				fieldLabel	: 'SEND_FLAG',
				name		: 'SEND_FLAG',
				xtype		: 'uniTextfield',
				hidden		: true
			},{
				fieldLabel	: 'DOC_CNT',
				name		: 'DOC_CNT',
				xtype		: 'uniNumberfield',
				hidden		: false
			}]
		},{
			title		: '<t:message code="system.label.sales.approveinfo" default="승인정보"/>',
			itemId		: 'DraftFields',
			layout		: {type: 'uniTable', columns: 2},
			defaultType	: 'uniTextfield',
			items		: [
				Unilite.popup('USER', {
					fieldLabel		: '<t:message code="system.label.sales.firstapprovalperson" default="1차승인자"/>',
					textFieldName	: 'APP_1_NM',
					valueFieldName	: 'APP_1_ID',
					showValue		: false,
					width			: 260
			}),{
				xtype	: 'component', // '1차승인한도액',
				margin	: '0 0 0 10',
				width	: 150,
				html	: '<div>'+Ext.util.Format.number(BsaCodeInfo.gsApp1AmtInfo, UniFormat.Price)+'<t:message code="system.message.sales.message029" default="원 이하"/></div>'
			},{
				fieldLabel	: '<t:message code="system.label.sales.firstapprovaldate" default="1차승인일"/>',
				name		: 'APP_1_DATE',
				hidden		: true
			},{
				fieldLabel	: '<t:message code="system.label.sales.firstapprovalyn" default="1차승인여부"/>',
				name		: 'AGREE_1_YN',
				hidden		: true
			},
			Unilite.popup('USER', {
				fieldLabel		: '<t:message code="system.label.sales.secondapprovalperson" default="2차승인자"/>',
				textFieldName	: 'APP_2_NM',
				valueFieldName	: 'APP_2_ID',
				showValue		: false,
				width			: 260
			}),{
				xtype	: 'component', // '2차승인한도액',
				margin	: '0 0 0 10',
				html	: '<div>'+Ext.util.Format.number(BsaCodeInfo.gsApp2AmtInfo, UniFormat.Price)+ '<t:message code="system.message.sales.message029" default="원 이하"/>' + '</div>'
			},{
				fieldLabel	: '<t:message code="system.label.sales.secondapprovaldate" default="2차승인일"/>',
				name		: 'APP_2_DATE',
				hidden		: true
			},{
				fieldLabel	: '<t:message code="system.label.sales.secondapprovalyn" default="2차승인여부"/>',
				name		: 'AGREE_2_YN',
				hidden		: true
			},
			Unilite.popup('USER', {
				fieldLabel		: '<t:message code="system.label.sales.thirdapprovalperson" default="3차승인자"/>',
				textFieldName	: 'APP_3_NM',
				valueFieldName	: 'APP_3_ID',
				showValue		: false,
				width			: 260
			}),{
				xtype	: 'component', // '3차승인초과액',
				margin	: '0 0 0 10',
				html	: '<div>'+Ext.util.Format.number(BsaCodeInfo.gsApp2AmtInfo, UniFormat.Price)+'<t:message code="system.message.sales.message030" default="원 초과"/></div>'
			},{
				fieldLabel	: '<t:message code="system.label.sales.thirdapprovaldate" default="3차승인일"/>',
				name		: 'APP_3_DATE',
				hidden		: true
			},{
				fieldLabel	: '<t:message code="system.label.sales.thirdapprovalyn" default="3차승인여부"/>',
				name		: 'AGREE_3_YN',
				hidden		: true
			},{
				fieldLabel	: '<t:message code="system.label.sales.status" default="상태"/>',
				name		: 'STATUS',
				id			: 'status',
				xtype		: 'uniRadiogroup',
				allowBlank	: false,
				value		: '1',
				colspan		: 2,
				width		: 330,
				layout		: {type: 'table', columns:3, tableAttrs:{width:'100%'}},
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.draft" default="기안"/>',
					name		: 'STATUS',
					inputValue	: '1',
					readOnly	: true,
					readOnlyCls	: 'uniRadioReadonly'
				},{
					boxLabel	: '<t:message code="system.label.sales.giveback" default="반려"/>',
					name		: 'STATUS',
					inputValue	: '5',
					readOnly	: true,
					readOnlyCls	: 'uniRadioReadonly'
				},{
					boxLabel	: '<t:message code="system.label.sales.finalapproval" default="완결"/>',
					name		: 'STATUS',
					inputValue	: '6',
					readOnly	: true,
					readOnlyCls	: 'uniRadioReadonly'
				},{
					boxLabel	: '<t:message code="system.label.sales.firstapproval" default="1차승인"/>',
					name		: 'STATUS',
					inputValue	: '2',
					readOnly	: true,
					readOnlyCls	: 'uniRadioReadonly'
				},{
					boxLabel	: '<t:message code="system.label.sales.secondapproval" default="2차승인"/>',
					name		: 'STATUS',
					inputValue	: '3',
					readOnly	: true,
					readOnlyCls	: 'uniRadioReadonly'
				},{
					boxLabel	: '<t:message code="system.label.sales.thirdapproval" default="3차승인"/>',
					name		: 'STATUS',
					inputValue	: '4',
					readOnly	: true,
					readOnlyCls	: 'uniRadioReadonly'
				}]
			},{
				fieldLabel	: '<t:message code="system.label.sales.givebackreason" default="반려사유"/>',
				name		: 'RETURN_MSG',
				xtype		: 'textarea',
				readOnly	: true,
				colspan		: 2,
				height		: 50
			}]
		},{
			fieldLabel	: 'PJT_NAME',
			xtype		: 'uniTextfield',
			name		: 'PJT_NAME',
			hidden		: true
		}],
		api: {
			load	: 'sof100ukrvService.selectMaster',
			submit	: 'sof100ukrvService.syncForm'
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					// this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				// this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		fnCreditCheck: function(saveFlag) {
			if(CustomCodeInfo.gsCustCrYn=='Y' && BsaCodeInfo.gsCreditYn=='Y' ) {
				if(this.getValue('TOT_ORDER_AMT') > this.getValue('REMAIN_CREDIT')) {
					if(BsaCodeInfo.gsCreditMsg == "E"){
						Unilite.messageBox('<t:message code="system.message.sales.datacheck002" default="해당 업체에 대한 여신액이 부족합니다. 추가여신액 설정을 선행하시고 작업하시기 바랍니다."/>');
						return false;
					} else if(!Ext.isEmpty(saveFlag)) {
						if(!confirm('해당 업체에 대한 여신액이 부족합니다. \n그대로 진행 하시겠습니까?')){
							return false;
						}
					}
				}
			}
			return true;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			//me.setAllFieldsReadOnly(true);
		}

	}); // End of var masterForm = Unilite.createForm('sof100ukrvMasterForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = masterForm.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					masterForm.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.sono" default="수주번호"/>',
			name		: 'ORDER_NUM',
			readOnly	: isAutoOrderNum,
			holdable	: isAutoOrderNum ? 'readOnly':'hold',
			//20191014 추가
			maxLength	: !isAutoOrderNum ? gsSNMaxLen : 20,
			enforceMaxLength: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('ORDER_NUM', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.sodate" default="수주일"/>',
			name		: 'ORDER_DATE',
			xtype		: 'uniDatefield',
			value		: new Date(),
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					if(CustomCodeInfo.gsCustCrYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
						// 여신액 구하기
						var divCode = masterForm.getValue('DIV_CODE');
						var CustomCode = masterForm.getValue('CUSTOM_CODE');
						var orderDate = UniDate.getDbDateStr(newValue);
						var moneyUnit = BsaCodeInfo.gsMoneyUnit;
						// 마스터폼에 여신액 set
						UniAppManager.app.fnGetCustCredit(divCode, CustomCode, orderDate, moneyUnit);
					}
					masterForm.setValue('ORDER_DATE', newValue);
					if(!isLoad){
						masterForm.setValue('DVRY_DATE'		, newValue);
						panelResult.setValue('DVRY_DATE'	, newValue);
					}

					//20191017 추가: 작성일, 유효일 동일하게 SET - 단, 유효일은 수주일과 다를 때만
					if(!Ext.isEmpty(newValue) && UniDate.getDbDateStr(newValue).replace(/\./g,'').length == 8) {
						panelTrade.setValue('DATE_DEPART', newValue);
						if(UniDate.getDbDateStr(panelTrade.getValue('DATE_EXP')) == UniDate.getDbDateStr(gsOldValue)) {
							panelTrade.setValue('DATE_EXP', newValue);
						}
						gsOldValue = newValue;
					}
				},
				blur : function (e, event, eOpts) {
					if(UniDate.getDbDateStr(gsLastDate) != UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE'))) {
						UniAppManager.app.fnExchngRateO();
					}
					gsLastDate = panelResult.getValue('ORDER_DATE');
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.soamount" default="수주액"/>',
			name		: 'ORDER_O',
			id			: 'ORDER_O',
			xtype		: 'uniNumberfield',
			colspan		: 2,
			type		: 'uniPrice',
			value		: 0,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.domesticoverseasclass" default="국내외구분"/>',
			name		: 'NATION_INOUT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T109',
			value		: '1',
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('NATION_INOUT', newValue);
					if(masterForm.getValue('NATION_INOUT') == '2') {
						//20190925 OFFER_NO 자동채번 로직관련 수정- 자동채번일 경우에는 readOnly(true) 유지
						if(!gsAutoOfferNo) {
							masterForm.getField('OFFER_NO').setReadOnly(false);
							panelResult.getField('OFFER_NO').setReadOnly(false);
						}
						panelTrade.getForm().getFields().each(function(field) {
							field.setReadOnly(false);
						});
						masterForm.setValue('ORDER_TYPE'	, '40');// 직수출
						masterForm.setValue('BILL_TYPE'		, '60');// 직수출
						panelResult.setValue('ORDER_TYPE'	, '40');// 직수출
						panelResult.setValue('BILL_TYPE'	, '60');// 직수출
						panelTrade.setConfig('collapsed'	, false);
					} else {
						// 무역폼 readOnly: true
						masterForm.setValue('OFFER_NO'	,'');
						panelResult.setValue('OFFER_NO'	,'');
						masterForm.getField('OFFER_NO').setReadOnly(true);
						panelResult.getField('OFFER_NO').setReadOnly(true);
						panelTrade.getForm().getFields().each(function(field) {
							field.setReadOnly(true);
						});
						masterForm.setValue('ORDER_TYPE'	, '10');// 직수출
						masterForm.setValue('BILL_TYPE'		, '10');// 직수출
						panelResult.setValue('ORDER_TYPE'	, '10');// 직수출
						panelResult.setValue('BILL_TYPE'	, '10');// 직수출
						panelTrade.setConfig('collapsed'	, true);
					}
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			allowBlank		: false,
			autoPopup		: true,
			id				: 'CUSTOM_ID2',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			holdable		: 'hold',
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						CustomCodeInfo.gsAgentType		= records[0]["AGENT_TYPE"];
						CustomCodeInfo.gsCustCrYn		= records[0]["CREDIT_YN"];
						CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"];
						CustomCodeInfo.gsRefTaxInout	= records[0]["TAX_TYPE"];	 // 세액포함여부

						if(!Ext.isEmpty(CustomCodeInfo.gsRefTaxInout)){
							masterForm.setValue('TAX_INOUT'	, CustomCodeInfo.gsRefTaxInout)
							panelResult.setValue('TAX_INOUT', CustomCodeInfo.gsRefTaxInout)
						}

						if(CustomCodeInfo.gsCustCrYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
							// 여신액 구하기
							var divCode		= masterForm.getValue('DIV_CODE');
							var CustomCode	= panelResult.getValue('CUSTOM_CODE');
							var orderDate	= masterForm.getField('ORDER_DATE').getSubmitValue()
							var moneyUnit	= BsaCodeInfo.gsMoneyUnit;
							// 마스터폼에 여신액 set
							UniAppManager.app.fnGetCustCredit(divCode, CustomCode, orderDate, moneyUnit);
						}

						masterForm.setValue('CUSTOM_CODE'	, panelResult.getValue('CUSTOM_CODE'));
						masterForm.setValue('CUSTOM_NAME'	, panelResult.getValue('CUSTOM_NAME'));
						masterForm.setValue('MONEY_UNIT'	, records[0].MONEY_UNIT);
						panelResult.setValue('MONEY_UNIT'	, records[0].MONEY_UNIT);

						/*20190320 거래처정보의 무역정보(bcm103t) 값 세팅 추가*/
						panelTrade.setValue('PAY_TERMS'		, records[0].PAY_TERMS);
						panelTrade.setValue('PAY_DURING'	, records[0].PAY_DURING);
						panelTrade.setValue('PAY_METHODE1'	, records[0].PAY_METHODE1);
						panelTrade.setValue('TERMS_PRICE'	, records[0].TERMS_PRICE);
						panelTrade.setValue('AGENT_CODE'	, records[0].AGENT_CODE);
						panelTrade.setValue('AGENT_NAME'	, records[0].AGENT_NAME);
						panelTrade.setValue('METH_CARRY'	, records[0].METH_CARRY);
						panelTrade.setValue('COND_PACKING'	, records[0].COND_PACKING);
						panelTrade.setValue('METH_INSPECT'	, records[0].METH_INSPECT);
						panelTrade.setValue('SHIP_PORT'		, records[0].SHIP_PORT);
						panelTrade.setValue('DEST_PORT'		, records[0].DEST_PORT);
						//20200103 추가: 20200109 주석
//						masterForm.setValue('SALE_CUST_CD'	, records[0].BILL_CUSTOM_CODE);
//						masterForm.setValue('SALE_CUST_NM'	, records[0].BILL_CUSTOM_NAME);

						if(!Ext.isEmpty(records[0].BUSI_PRSN)) {//거래처의 주영업담당자가 있으면 영업담당 다시 세팅
							masterForm.setValue('ORDER_PRSN'	, records[0].BUSI_PRSN);
							panelResult.setValue('ORDER_PRSN'	, records[0].BUSI_PRSN);
						}
						masterForm.setValue('UPN_CHECK'	, records[0].UPN_CHECK);
						panelResult.setValue('UPN_CHECK', records[0].UPN_CHECK);
					},
					scope: this
				},
				onClear: function(type) {
					CustomCodeInfo.gsAgentType		= '';
					CustomCodeInfo.gsCustCrYn		= '';
					CustomCodeInfo.gsUnderCalBase	= '';
					CustomCodeInfo.gsRefTaxInout	= '';

					masterForm.setValue('CUSTOM_CODE', '');
					masterForm.setValue('CUSTOM_NAME', '');
					//20200103 추가: 20200109 주석
//					masterForm.setValue('SALE_CUST_CD', '');
//					masterForm.setValue('SALE_CUST_NM', '');
				},
					applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			fieldLabel : '<t:message code="system.label.sales.upncheckyn" default="UPN 체크여부"/>',
			name : 'UPN_CHECK',
			hidden: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			name		: 'DVRY_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			allowBlank	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('DVRY_DATE', newValue);
				},
				blur : function (e, event, eOpts) {
					if(!Ext.isEmpty(masterForm.getValue('DVRY_DATE')) && masterForm.getValue('DVRY_DATE') < masterForm.getValue('ORDER_DATE')) {
						Unilite.messageBox('<t:message code="system.message.sales.message037" default="수주일 이후이어야 합니다."/>');
						masterForm.setValue('DVRY_DATE', '');
						panelResult.setValue('DVRY_DATE', '');
						panelResult.getField('DVRY_DATE').focus();
						return false;
//					} else {		//20210917 개발 중 보류: 상단의 납기일은 추가입력에만 사용, 납기수정을 한다고 상단의 납기를 수정하는것은 아님 (윤 전무님 - 납기변경등록 사용)
//						var records = detailGrid.getStore().data.items;
//						Ext.each(records, function(record, i) {
//							if(record) {
//								record.set('DVRY_DATE', masterForm.getValue('DVRY_DATE'));
//							}
//						});
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.vatamount" default="부가세액"/>',
			name		: 'ORDER_TAX_O',
			id			: 'ORDER_TAX_O',
			xtype		: 'uniNumberfield',
			colspan		: 2,
			type		: 'uniPrice',
			value		: 0,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
			name		: 'ORDER_TYPE',
			comboType	: 'AU',
			id			: 'ORDER_TYPE_ID2',
			comboCode	: 'S002',
			xtype		: 'uniCombobox',
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					console.log("[[inoutTypeChk2]]" + inoutTypeChk);
					var chk = inoutTypeChk;
					masterForm.setValue('ORDER_TYPE', newValue);
					UniAppManager.app.fnGetInoutDetailType(newValue, chk);//선택한 값에 따라 매출 유형 세팅
					inoutTypeChk = 'Y';
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			autoSelect: false,
			allowBlank	: false,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('ORDER_PRSN', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.offerno" default="OFFER번호"/>',
			name		: 'OFFER_NO',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('OFFER_NO', newValue);
				},
				focus: function(field, The, eOpts){
					offerNoChk = field.getValue().replace(/-/g,'');
				},
				blur: function(field, The, eOpts){
					var newValue	= field.getValue().replace(/-/g,'');
					var nationInout	= panelResult.getValue("NATION_INOUT");
					if(newValue != offerNoChk && nationInout == '2' && !Ext.isEmpty(newValue)){ //해외 일 경우에만
						var checkOfferNo= '';
						var param		= panelResult.getValues();
						if(!Ext.isEmpty(panelResult.getValue('OFFER_NO'))){
							sof100ukrvService.checkOfferNo(param, function(provider2, response){
								if(!Ext.isEmpty(provider2)){
									checkOfferNo = provider2.data.OFFER_NO;
									Unilite.messageBox('[' + checkOfferNo + ']' + ' <t:message code="system.message.sales.message028" default="OFFER번호가 존재합니다."/>');
									return false;
								}
							});
						}
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.sototalamount" default="수주총액"/>',
			name		: 'TOT_ORDER_AMT',
			id			: 'TOT_ORDER_AMT',
			xtype		: 'uniNumberfield',
			colspan		: 2,
			type		: 'uniPrice',
			value		: 0,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.vattype" default="부가세유형"/>',
			name		: 'BILL_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S024',
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('BILL_TYPE', newValue);
					
					// 20210224 : 부가세유형이 카드매출인 경우 카드사 readonly 비활성
					if('40' == newValue){
						masterForm.getField('CARD_CUSTOM_CODE').setReadOnly(false);
						panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(false);
					} else {
						masterForm.setValue('CARD_CUSTOM_CODE', '');
						panelResult.setValue('CARD_CUSTOM_CODE', '');
						masterForm.getField('CARD_CUSTOM_CODE').setReadOnly(true);
						panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(true);
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.currency" default="화폐"/>',
			name		: 'MONEY_UNIT',
			comboType	: 'AU',
			comboCode	: 'B004',
			value		: BsaCodeInfo.gsMoneyUnit,
			xtype		: 'uniCombobox',
			allowBlank	: false,
			//20200225 추가
			displayField: 'value',
			holdable	: 'hold',
			fieldStyle	: 'text-align: center;',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('MONEY_UNIT', newValue);
					//20190614 컬럼 / 필드 속성 설정하는 함수 호출
//					UniAppManager.app.fnSetColumnFormat();
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.exchangerate" default="환율"/>',
			name		: 'EXCHANGE_RATE',
			xtype		: 'uniNumberfield',
			type		: 'uniER',
			holdable	: 'hold',
			value		: 1,
			decimalPrecision: 4,
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('EXCHANGE_RATE', newValue);
				}
			}
		},{
			xtype	: 'container',
			colspan		: 2,
			items	: [{
				fieldLabel	: '<t:message code="system.label.sales.creditbalance" default="여신잔액"/>',
				name		: 'REMAIN_CREDIT',
				id			: 'REMAIN_CREDIT',
				xtype		: 'uniNumberfield',
				type		: 'uniPrice',
				value		: 0,
				readOnly	: true
			}]
			
		// 20210224 : 카드사(CARD_CUSTOM_CODE) 추가
		},{
			fieldLabel	: '<t:message code="system.label.sales.cardcustomnm" default="카드사"/>' ,
			name		: 'CARD_CUSTOM_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A028',
			allowBlank	: true,
			holdable	: 'hold',
			readOnly    : true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('CARD_CUSTOM_CODE',newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.receiptsetmeth" default="결제방법"/>',
			name		: 'RECEIPT_SET_METH',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B038',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('RECEIPT_SET_METH', newValue);
				}
			}
		},
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			textFieldName	: 'PROJECT_NO',
			itemId			: 'project',
			validateBlank	: false,
			textFieldWidth	: 150,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						if(records) {
							panelResult.setValue('PROJECT_NO', records[0]["PJT_CODE"]);
							masterForm.setValue('PROJECT_NO', records[0]["PJT_CODE"]);
							//20200102 추가
							masterForm.setValue('PJT_NAME', records[0]["PJT_NAME"]);
						}
					},
					scope: this
				},
				onClear: function(type) {
					panelResult.setValue('PROJECT_NO', '');
					masterForm.setValue('PROJECT_NO', '');
					//20200102 추가
					masterForm.setValue('PJT_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'BPARAM0': 3});
					//20190108 거래처와 무관 && 쿼리도 없음
//					popup.setExtParam({'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE')});
				},
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('PROJECT_NO', newValue);
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.pono2" default="PO 번호"/>',
			name		: 'PO_NUM',
			xtype		: 'uniTextfield',
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					var grdRecord = detailGrid.getSelectedRecord();
					masterForm.setValue('PO_NUM', newValue);
					if(!Ext.isEmpty(grdRecord) && !Ext.isEmpty(grdRecord.get('PO_NUM'))){
						grdRecord.set('PO_NUM', newValue);
					}
				}
			}
			
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>',
			name		: 'TAX_INOUT',
			xtype		: 'uniRadiogroup',
			comboType	: 'AU',
			comboCode	: 'B030',
			width		: 235,
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.getField('TAX_INOUT').setValue(newValue.TAX_INOUT);
				}
			}

		},{
			fieldLabel	: '<t:message code="system.label.sales.remarks" default="비고"/>',
			xtype		: 'uniTextfield',
			name		: 'REMARK',
			width		: 815,
			colspan		: 2,
			layout		: {type : 'uniTable', columns : 3},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('REMARK', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.confirmedpending" default="확정여부"/>',
			name		: 'CONFIRMEYN',
			xtype		: 'uniRadiogroup',
			comboType	: 'AU',
			comboCode	: 'B131',
			width		: 235,
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.getField('CONFIRMEYN').setValue(newValue.CONFIRMEYN);
				}
			}

		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 5 95',
			items	: [{
				xtype: 'button',
				text: '문서등록',
				itemId: 'docaddbutton',
				holdable: 'hold',
				handler: function() {
					openDetailWindow();
				}
			},{	//20190724 구매요청정보반영 버튼로직 구현
				xtype	: 'button',
				text	: '<t:message code="system.label.sales.purchaserequestentry" default="구매요청등록"/>',
				itemId	: 'purchaseRequest2',
				holdable: 'hold',
				hidden	: false,
				handler	: function() {
					//저장버튼 활성화 체크,
					if(UniAppManager.app._needSave()) {
						Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
						return false;
					}
					var pSeqs = panelResult.getValue('SEQS');
					if(Ext.isEmpty(pSeqs)) {
						Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
						return false;
					}
					var param = {
						COMP_CODE	: UserInfo.compCode,
						DIV_CODE	: panelResult.getValue('DIV_CODE'),
						ORDER_NUM	: panelResult.getValue('ORDER_NUM'),
						SER_NO		: pSeqs
					}
					sof100ukrvService.insertPurchaseRequest(param, function(provider, response) {
						if(provider){
							UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave001" default="구매요청 정보가 반영되었습니다."/>');
							UniAppManager.app.onQueryButtonDown();
						}
					});
				}
			},{	//20210507 추가: 링크 버큰 추가
				xtype	: 'button',
				text	: BsaCodeInfo.gsButtonLink1 == '/sales/ssa615skrv.do' ? '채권현황':'미수채권 현황',			//20210510 수정: '매입/매출 조회':'미수채권 현황' -> '채권현황':'미수채권 현황'
				itemId	: 'gsButtonLink1',
				holdable: 'hold',
				hidden	: Ext.isEmpty(BsaCodeInfo.gsButtonLink1) ? true: false,
				handler	: function() {
					if(Ext.isEmpty(panelResult.getValue('CUSTOM_CODE')) || Ext.isEmpty(panelResult.getValue('CUSTOM_NAME'))) {
						Unilite.messageBox('거래처 정보를 입력하세요.');
						panelResult.getField('CUSTOM_CODE').focus();
						return false;
					}
					var linkPgmId	= BsaCodeInfo.gsButtonLink1.split('/')[2].substring(0, BsaCodeInfo.gsButtonLink1.split('/')[2].length - 3);
					var params = {
						action			: 'select',
						'PGM_ID'		: PGM_ID,
						'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
						'CUSTOM_CODE'	: panelResult.getValue('CUSTOM_CODE'),
						'CUSTOM_NAME'	: panelResult.getValue('CUSTOM_NAME'),
						'FrDate'		: UniDate.getDbDateStr(UniDate.get('twoMonthsAgo')).substring(0, 6) + '01',
						'ToDate'		: UniDate.get('today')
					}
					var rec = {data : {prgID : linkPgmId, 'text':''}};
					parent.openTab(rec, BsaCodeInfo.gsButtonLink1, params, CHOST+CPATH);
				}
			},{
				fieldLabel	: 'SEQS',
				name		: 'SEQS',
				xtype		: 'uniTextfield',
				colspan		: 4,
				width		: 1000,
				readOnly	: true,
				hidden		: true
			}]
		}],
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
				if (gsSaveRefFlag == "Y"
				&& (basicForm.getField('REMARK').isDirty() || basicForm.getField('ORDER_PRSN').isDirty() || basicForm.getField('CARD_CUSTOM_CODE').isDirty())){
					UniAppManager.setToolbarButtons('save', true);
				}
				if(!Ext.isEmpty(basicForm.getField('ORDER_NUM')) && basicForm.getField('ORDER_NUM').isDirty()){
					panelResult.down('#docaddbutton').setDisabled(false);
					masterForm.down('#purchaseRequest1').setDisabled(false);
					panelResult.down('#purchaseRequest2').setDisabled(false);
				} else {
					panelResult.down('#docaddbutton').setDisabled(true);
					masterForm.down('#purchaseRequest1').setDisabled(true);
					panelResult.down('#purchaseRequest2').setDisabled(true);
				}
			}
		},
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length == 0) {
					// this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				// this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});

	// 무역 master정보 폼
	var panelTrade = Unilite.createSearchForm('tradeForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 4},
		padding		: '1 1 1 1',
		border		:true,
		collapsible	: true,
		extensible	: true,
		hidden		: false,
		height		: 180,
		autoScroll	: true,
		//defaults	: {holdable: 'hold'},
		items		: [{
			layout	: {type:'uniTable', column:2},
			xtype	: 'container',
			defaults: {holdable: 'hold'},
			items	: [{
					fieldLabel	: '<t:message code="system.label.sales.approvalcondition" default="결재조건"/>',
					name		: 'PAY_TERMS',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'T006',
					allowBlank	: false
				},{
					xtype		: 'uniNumberfield',
					name		: 'PAY_DURING',
					suffixTpl	: 'Days',
					width		: 80
				}
			]
		},{
			fieldLabel	: '<t:message code="system.label.sales.amountpaymethod" default="대금결제방법"/>',
			name		: 'PAY_METHODE1',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T016',
			allowBlank	: false
		},{
			fieldLabel	: '<t:message code="system.label.sales.pricecondition" default="가격조건"/>',
			name		: 'TERMS_PRICE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T005',
			allowBlank	: false
		},{	//20191202 추가
			fieldLabel	: '<t:message code="system.label.sales.lcno" default="L/C번호"/>',
			xtype		: 'uniTextfield',
			name		: 'LC_SER_NO',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.sales.agent" default="대행자"/>',
			valueFieldName	: 'AGENT_CODE',
			textFieldName	: 'AGENT_NAME',
			holdable		: 'hold',
			listeners		: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.writtendate" default="작성일"/>',
			name		: 'DATE_DEPART',
			xtype		: 'uniDatefield',
			value		: new Date(),
			allowBlank	: false
		},{
			fieldLabel	: '<t:message code="system.label.sales.availabledate" default="유효일"/>',
			name		: 'DATE_EXP',
			xtype		: 'uniDatefield',
			value		: new Date()
			//colspan		: 2
		},
		{
			fieldLabel	: '선적일',
			name		: 'DATE_SHIPPING',
			xtype		: 'uniDatefield'
		}

		,{
			fieldLabel	: '<t:message code="system.label.sales.transportmethod" default="운송방법"/>',
			name		: 'METH_CARRY',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T004'
		},{
			fieldLabel	: '<t:message code="system.label.sales.packingmethod" default="포장방법"/>',
			name		: 'COND_PACKING',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T010'
		},{
			fieldLabel	: '<t:message code="system.label.sales.inspecmethod" default="검사방법"/>',
			name		: 'METH_INSPECT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T011'
			//colspan		: 2
		},
		{
			fieldLabel	: '도착일',
			name		: 'DUE_DATE',
			xtype		: 'uniDatefield'
		}
		,{
			fieldLabel	: '<t:message code="system.label.sales.shipmentport" default="선적항"/>',
			name		: 'SHIP_PORT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T008'
		},{
			fieldLabel	: '<t:message code="system.label.sales.arrivalport" default="도착항"/>',
			name		: 'DEST_PORT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T008'
		},
		{
			fieldLabel	: '도착지',
			name		: 'DEST_FINAL',
			xtype		: 'uniTextfield'
		},
		Unilite.popup('BANK',{
			fieldLabel		: '<t:message code="system.label.sales.transbank" default="송금은행"/>',
			valueFieldName	: 'BANK_CODE',
			textFieldName	: 'BANK_NAME'
			//colspan			: 2
		}),


		{
			fieldLabel	: '<t:message code="system.label.sales.bookingnum" default="부킹번호"/>',
			name		: 'BOOKING_NUM',
			xtype		: 'uniTextfield'
		}
/*		,
		{
			fieldLabel	: '<t:message code="system.label.sales.pallet" default="파렛트"/>',
			name		: 'PALLET_USE',
			xtype		: 'uniCombobox',
			width		: 200,
			comboType	: 'AU',
			comboCode	: 'S173'
		},
		{
			fieldLabel	: '',
			name		: 'PALLET_QTY',
			xtype		: 'uniTextfield',
			comboType	: 'AU',
			width		: 30
		}
*/
		,{
				xtype: 'container',
				layout: { type: 'uniTable', columns: 2},
				defaultType: 'uniTextfield',
				defaults : {enforceMaxLength: true},
				colspan:1,
				items:[{
					fieldLabel	: '<t:message code="system.label.sales.pallet" default="파렛트"/>',
					name		: 'PALLET_USE',
					xtype		: 'uniCombobox',
					width		: 200,
					comboType	: 'AU',
					comboCode	: 'S173'
				},{
					fieldLabel	: '',
					name		: 'PALLET_QTY',
					xtype		: 'uniNumberfield',
					value		: '0',
					width		: 46//,
//					listeners	: {
//						change: function(field, newValue, oldValue, eOpts) {
//							if(Ext.isEmpty(newValue)) {
//								panelTrade.setValue('PALLET_QTY', 0);
//							}
//						}
//					}
				}]
			}
		,
		{
			fieldLabel	: '<t:message code="system.label.sales.label" default="라벨"/>',
			name		: 'LABEL_USE',
			xtype		: 'uniTextfield'
		}
		,
        Unilite.popup('AGENT_CUST',{
            fieldLabel: '운송사',
            valueFieldName: 'TRANSPORT_CODE',
            textFieldName: 'TRANSPORT_NAME'
        })
		],
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
				if(gsSaveRefFlag == "Y" && basicForm.isDirty()){
					UniAppManager.setToolbarButtons('save', true);
				}
			}
		},
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length == 0) {
					// this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				// this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		},
		api: {
			load: 'sof100ukrvService.selectMaster',
			submit: 'sof100ukrvService.syncForm'
		}
	});




	//문서등록
	var detailSearch = Unilite.createSearchForm('DetailForm', {
		layout :  {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel	: ' ',
			xtype		: 'uniTextfield',
			name		: 'ADD_FIDS',
			hidden		: true,
			width		: 815
		},{
			fieldLabel	: ' ',
			xtype		: 'uniTextfield',
			name		: 'DEL_FIDS',
			hidden		: true,
			width		: 815
		}]
	});

	var detailForm = Unilite.createForm('sof100ukrvDetail', {
		autoScroll	: true,
		layout		: 'fit',
		layout		: {type: 'uniTable', columns: 4,tdAttrs: {valign:'top'}},
		defaults	: {labelWidth:60},
		disabled	: false,
		items		: [{
			xtype		: 'xuploadpanel',
			id			: 'sof100ukrvFileUploadPanel',
			itemId		: 'fileUploadPanel',
			flex		: 1,
			width		: 975,
			height		: 300,
			listeners	: {
			}
		}],
		loadForm: function() {
			// window 오픈시 form에 Data load
			this.reset();
//			this.setActiveRecord(record || null);
			this.resetDirtyStatus();
			var win = this.up('uniDetailFormWindow');

			if(win) {	// 처음 윈도열때는 윈독 존재 하지 않음.
				win.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
				win.setToolbarButtons(['prev','next'],true);
			}

			//첨부파일
			var fp = Ext.getCmp('sof100ukrvFileUploadPanel');
			var ordernum = panelResult.getValue('ORDER_NUM');
			if(!Ext.isEmpty(ordernum)) {
				sof100ukrvService.getFileList({DOC_NO : ordernum}, function(provider, response) {
					fp.loadData(response.result.data);
				})
			} else {
				fp.clear(); //  fp.loadData() 실행 시 데이타 삭제됨.
			}
		},
		listeners : {
//			uniOnChange : function( form, field, newValue, oldValue ) {
//				var b = form.isValid();
//				this.up('uniDetailFormWindow').setToolbarButtons(['saveBtn','saveCloseBtn'],b);
//				this.up('uniDetailFormWindow').setToolbarButtons(['prev','next'],!b);   // 저장이 필요할경우 이전 다음 disable
//			}
		}
	});

	function openDetailWindow(selRecord, isNew) {
		// 그리드 저장 여부 확인
		var edit = detailGrid.findPlugin('cellediting');
		if(edit && edit.editing) {
			setTimeout("edit.completeEdit()", 1000);
		}

		// 추가 Record 인지 확인
		if(isNew) {
			//var r = masterGrid.createRow();
			//selRecord = r[0];
			selRecord = detailGrid.createRow();
			if(!selRecord) {
				selRecord = detailGrid.getSelectedRecord();
			}
		}
		// form에 data load
		detailForm.loadForm();

		if(!detailWin) {
			detailWin = Ext.create('widget.uniDetailWindow', {
				title	: '문서등록',
				width	: 1000,
				height	: 370,
				isNew	: false,
				x		: 0,
				y		: 0,
				layout	: {type:'vbox', align:'stretch'},
				items	: [detailSearch,detailForm],
				tbar	: ['->',{
					itemId	: 'confirmBtn',
					text	: '문서저장',
					handler	: function() {
						var ordernum	= panelResult.getValue('ORDER_NUM');
						var fp			= Ext.getCmp('sof100ukrvFileUploadPanel');
						var addFiles	= fp.getAddFiles();
						console.log("addFiles : " , addFiles.length)

						if(addFiles.length > 0) {
							detailSearch.setValue('ADD_FIDS', addFiles );
						} else {
							detailSearch.setValue('ADD_FIDS', '' );
						}
						var param = {
							DOC_NO		: ordernum,
							ADD_FIDS	: detailSearch.getValue('ADD_FIDS')
						}
						sof100ukrvService.insertSOF102(param , function(provider, response){
							// 저장 완료 리턴 메세지
							if(!Ext.isEmpty(provider) && provider > 0){
								UniAppManager.updateStatus('<t:message code="system.message.sales.message033" default="저장되었습니다."/>');
								// 저장 후 재조회
								sof100ukrvService.getFileList({DOC_NO : ordernum}, function(provider, response) {
									fp.loadData(response.result.data);
								})
							}
						});
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '문서저장 후 닫기',
					handler	: function() {
						var ordernum	= panelResult.getValue('ORDER_NUM');
						var fp			= Ext.getCmp('sof100ukrvFileUploadPanel');
						var addFiles	= fp.getAddFiles();
						console.log("addFiles : " , addFiles.length)

						if(addFiles.length > 0) {
							detailSearch.setValue('ADD_FIDS', addFiles );
						} else {
							detailSearch.setValue('ADD_FIDS', '' );
						}
						var param = {
							DOC_NO		: ordernum,
							ADD_FIDS	: detailSearch.getValue('ADD_FIDS')
						}
						sof100ukrvService.insertSOF102(param , function(provider, response){})

						sof100ukrvService.selectDocCnt(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								if( provider > 0){
									panelResult.down('#docaddbutton').setText( '문서등록: ' + provider + '건');
								} else {
									panelResult.down('#docaddbutton').setText( '문서등록');
								}
							}
						});
						detailWin.hide();
					},
					disabled: false
				},{
					itemId	: 'DeleteBtn',
					text	: '삭제',
					handler	: function() {
						var fp			= Ext.getCmp('sof100ukrvFileUploadPanel');
						var delFiles	= fp.getRemoveFiles();
						if(delFiles.length > 0) {
							detailSearch.setValue('DEL_FIDS', delFiles );
						} else {
							detailSearch.setValue('DEL_FIDS', '' );
						}
						if(!Ext.isEmpty(detailSearch.getValue('DEL_FIDS'))){
							if(confirm('문서를 삭제 하시겠습니까?')) {
								var param = {
									DEL_FIDS: detailSearch.getValue('DEL_FIDS')
								}
								sof100ukrvService.deleteSOF102(param , function(provider, response){})
							}
						} else {
							Unilite.messageBox('삭제할 문서가 없습니다.');
							return false;
						}
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						var ordernum	= panelResult.getValue('ORDER_NUM');
						var param		= {
								DOC_NO : ordernum
						}
						sof100ukrvService.selectDocCnt(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								if( provider > 0){
									panelResult.down('#docaddbutton').setText( '문서등록: ' + provider + '건');
								} else {
									panelResult.down('#docaddbutton').setText( '문서등록');
								}
							}
						});
						detailWin.hide();
					},
					disabled: false
				}],
				listeners : {
					show:function( window, eOpts) {
						detailForm.body.el.scrollTo('top',0);
					}
				}
			})
		}
		detailWin.show();
		detailWin.center();
	}




	/** 수주정보 그리드 Context Menu
	 */
	var detailGrid = Unilite.createGrid('sof100ukrvGrid', {
		store: detailStore,
		layout: 'fit',
		region:'center',
		selModel:'rowmodel',
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
//			useContextMenu: true,
			onLoadSelectFirst : true,
			copiedRow: true
		},
		margin: 0,
		tbar: [{
			itemId: 'reqBtn',
			text: '<div style="color: blue"><t:message code="system.label.sales.referenceestimatedshipment" default="출하예정참조"/></div>',
			handler: function() {
				openReqWindow();
			}
		},{
			itemId: 'refBtn',
			text: '<div style="color: blue"><t:message code="system.label.sales.sohistoryrefer" default="수주이력참조"/></div>',
			handler: function() {
				openRefWindow();
			}
		},{
//			xtype   : 'button',
			text	: '<div style="color: blue"><t:message code="system.label.sales.Receivesrm" default="SRM 수신"/></div>',
			id	  : 'recieveSRM',
			width   : 100,
			handler : function() {
				if(!UniAppManager.app.checkForNewDetail()) return false;
//				Unilite.messageBox('srm수신작업');
				Ext.getCmp('mainItem').getEl().mask('Loading....');
				var param = panelResult.getValues();
				//세구분
				var taxType ='1';
				if(masterForm.getValue('BILL_TYPE')=='50' || masterForm.getValue('BILL_TYPE')=='60' || masterForm.getValue('BILL_TYPE')=='50') {
					taxType ='2';
				}
				//납기일 - SRM에서 수신된 납기일자로 set (주석)
//				var dvryDate = '';
//				if(!Ext.isEmpty(masterForm.getValue('DVRY_DATE'))) {
//					dvryDate=UniDate.getDbDateStr(masterForm.getValue('DVRY_DATE'));
//				} else {
//					dvryDate= new Date();
//				}
				var refOrderDate = '';
				if(!Ext.isEmpty(masterForm.getValue('ORDER_DATE'))) {
					refOrderDate=UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE'));
				}

				var refOrdCust = '';
				if(!Ext.isEmpty(masterForm.getValue('CUSTOM_CODE'))) {
					refOrdCust=masterForm.getValue('CUSTOM_CODE');
				}

				var customCode = '';
				if(!Ext.isEmpty(masterForm.getValue('SALE_CUST_CD'))) {
					customCode=masterForm.getValue('SALE_CUST_CD');
				} else {
					customCode=masterForm.getValue('CUSTOM_CODE');
				}

				var customName = '';
				if(!Ext.isEmpty(masterForm.getValue('SALE_CUST_NM'))) {
					customName=masterForm.getValue('SALE_CUST_NM');
				} else {
					customName=masterForm.getValue('CUSTOM_NAME');
				}

				var refOrderType = '';
				if(!Ext.isEmpty(masterForm.getValue('ORDER_TYPE'))) {
					refOrderType=masterForm.getValue('ORDER_TYPE');
				}

				var projectNo = '';
				if(!Ext.isEmpty(masterForm.getValue('PROJECT_NO'))) {
					projectNo=masterForm.getValue('PROJECT_NO');
				}

				var refBillType = '';
				if(!Ext.isEmpty(masterForm.getValue('BILL_TYPE'))) {
					refBillType=masterForm.getValue('BILL_TYPE');
				}

				var refReceiptSetMeth = '';
				if(!Ext.isEmpty(masterForm.getValue('RECEIPT_SET_METH'))) {
					refReceiptSetMeth=masterForm.getValue('RECEIPT_SET_METH');
				}

				param.taxType			= taxType;
				param.outDivCode		= outDivCode;
				param.saleCustCd		= customCode;
				param.customName		= customName;
				//납기일 - SRM에서 수신된 납기일자로 set (주석)
//				param.dvryDate			= dvryDate;
				param.refOrderDate		= refOrderDate;
				param.refOrdCust		= refOrdCust;
				param.refOrderType		= refOrderType;
				param.projectNo			= projectNo;
				param.refBillType		= refBillType;
				param.refReceiptSetMeth	= refReceiptSetMeth

				sof100ukrvService.receiveSRM(param, function(provider, response){
					detailGrid.getStore().loadData({});
					var store   = detailGrid.getStore();

					if(!Ext.isEmpty(provider)){
						Ext.each(provider, function(srmData, i) {
							if(srmData.SRM_FLAG == 'Registered') {		//'Registered' or 'Not Registered'
								srmData.phantom = true;
								store.insert(i, srmData);
							} else {
								notRegisteredSRMStore.insert(i, srmData);
							}
						});
					}
					Ext.getCmp('mainItem').unmask();
					if(notRegisteredSRMStore.count() > 0) {
						openSrmWindow();
					}
				});
			}
		},{
			itemId: 'excelBtn',
			text: '<div style="color: blue"><t:message code="system.label.sales.excelrefer" default="엑셀참조"/></div>',
			handler: function() {
					openExcelWindow();
			}
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbseparator'
		},{
			xtype: 'tbspacer'
		},{
			itemId: 'reqIssueLinkBtn',
			text: '<t:message code="system.label.sales.shipmentorderentry" default="출하지시등록"/>',
			handler: function() {
				if(detailStore.isDirty()){
					   Unilite.messageBox('<t:message code="system.message.sales.message032" default="저장작업 선행후 처리하시기 바랍니다."/>');
					   return false;
				}
				if(detailStore.getCount() != 0){
					//20210203 수정: 공통코드(S037) 사용하도록 수정
					var pgmId, pgmPath, pgmFullPath;
					if(Ext.isEmpty(BsaCodeInfo.gsSrq100UkrLink)) {
						pgmId = 'srq100ukrv';
					} else{
						pgmId = BsaCodeInfo.gsSrq100UkrLink;
					}
					if(Ext.isEmpty(BsaCodeInfo.gsSrq100UkrPath)) {
						pgmPath = 'sales';
					} else{
						pgmPath = BsaCodeInfo.gsSrq100UkrPath
					}
					pgmFullPath = '/' + pgmPath + '/' + pgmId + '.do';
					var params = {
						action		: 'select',
						'PGM_ID'	: 'sof100ukrv',
						'record'	: detailStore.data.items,
						'formPram'	: masterForm.getValues()
					}
					var rec = {data : {prgID : pgmId, 'text':''}};
					parent.openTab(rec, pgmFullPath, params, CHOST+CPATH);
//					parent.openTab(rec, '/sales/srq100ukrv.do', params, CHOST+CPATH);
				}
			}
		},{
			itemId: 'issueLinkBtn',
			text: '<t:message code="system.label.sales.issueentry" default="출고등록"/>',
			handler: function() {
				if(detailStore.isDirty()){
					Unilite.messageBox('<t:message code="system.message.sales.message032" default="저장작업 선행후 처리하시기 바랍니다."/>');
					return false;
				}

				if(detailStore.getCount() != 0){
					var params = {
						action		: 'select',
						'PGM_ID'	: 'sof100ukrv',
						'record'	: detailStore.data.items,
						'formPram'	: masterForm.getValues()
					}
					//20210309 추가: 월드와이드 메모리의 경우 site 출고등록으로 이동하도록 수정 - 컴퓨터 고장으로 공통코드화 생략
					if(BsaCodeInfo.gsSiteCode == 'WM'){
						var rec = {data : {prgID : 's_str104ukrv_wm', 'text':''}};
						parent.openTab(rec, '/z_wm/s_str104ukrv_wm.do', params, CHOST+CPATH);
					} else {
						var rec = {data : {prgID : 'str103ukrv', 'text':''}};
						parent.openTab(rec, '/sales/str103ukrv.do', params, CHOST+CPATH);
					}
				}
			}
		}],
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal',	ftype: 'uniSummary',	  showSummaryRow: true} ],
		columns: [
			{dataIndex: 'DIV_CODE',	 width: 100,hidden:true},
			{dataIndex: 'SER_NO',			width: 40 , align:'center'},
			{dataIndex: 'OUT_DIV_CODE',		width: 100, hidden: true},
			{dataIndex: 'SO_KIND',			width: 80, hidden: true},
			{dataIndex: 'INOUT_TYPE_DETAIL',width: 80, hidden: false,
				listeners:{
					render:function(elm) {
						var tGrid = elm.getView().ownerGrid;
						var intoutTypeDetailStore;
						elm.editor.on('beforequery',function(queryPlan, eOpts) {
							// var grid = tGrid;
							var store = queryPlan.combo.store;
							inoutTypeDetailStore = queryPlan.combo.store;
							store.clearFilter();
							store.filterBy(function(item){
								return item.get('refCode7') == 'Y';
							})
						}),
						elm.editor.on('change',function(field, newValue, oldValue, eOpts) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							Ext.each(inoutTypeDetailStore.data.items, function(record, index) {
								if(record.get('value') == newValue){
									if(record.get('refCode1') == 'Y'){
										grdRecord.set('ACCOUNT_YNC', 'Y');
									} else {
										grdRecord.set('ACCOUNT_YNC', 'N');
									}
								}
							});
						})
					}
				}
			},
			{dataIndex: 'ITEM_CODE',		width: 120,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
					useBarcodeScanner: false,
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
									}
								});
							},
						scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var record = detailGrid.getSelectedRecord();
							var divCode = record.get('OUT_DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': divCode});
							//popup.setExtParam({'ITEM_ACCOUNT' : ['10','00'], multiSelectItemAccount: true});	// 팝업창에서 품목계정을 멀티 선택 및 디폴트값을 여러개 줄 수 있도록 수정.
							popup.setExtParam({multiSelectItemAccount: true}); //20181224 폼목계정 상품, 제품 고정값 임시 해제, 유양은 반제품도 수주 함
// popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE':
// 'GRID_CODE'});
// popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							if(BsaCodeInfo.gsBalanceOut == 'Y') {
								popup.setExtParam({'ADD_QUERY': "ISNULL(B_OUT_YN, 'N') != N'Y'"});				// WHERE절 추카 쿼리
							}
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME',		width: 200,
				editor: Unilite.popup('DIV_PUMOK_G', {
					extParam: {SELMODEL: 'MULTI'},
					autoPopup:true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
									}
								});
							},
							scope: this
							},
						'onClear': function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var record = detailGrid.getSelectedRecord();
							var divCode = record.get('OUT_DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI'});
							popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': divCode});
							popup.setExtParam({multiSelectItemAccount: true}); //20181224 폼목계정 상품, 제품 고정값 임시 해제,  유양은 반제품도 수주 함
 // popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							if(BsaCodeInfo.gsBalanceOut == 'Y') {
								popup.setExtParam({'ADD_QUERY': "ISNULL(B_OUT_YN, 'N') != N'Y'"});		   // WHERE절 추가 쿼리
							}
						}
					}
				})
			},
			{dataIndex: 'ITEM_ACCOUNT',		width: 100, hidden: true},
			{dataIndex: 'SPEC',				width: 200},
			//{dataIndex: 'PACK_TYPE',			 width: 100 , align: 'center'},
			{dataIndex: 'ORDER_UNIT',		width: 80, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
			}},
			{dataIndex: 'TRANS_RATE',		width: 60 },
			{dataIndex: 'ORDER_Q',			width: 80, summaryType: 'sum'},
			{dataIndex: 'ORDER_P',			width: 100},
			//20190621 할인율 계산용 필드 추가
			{dataIndex: 'ORDER_P_CAL',		width: 100, hidden: true},
			{dataIndex: 'DISCOUNT_MONEY',	width: 70, hidden: true},
			{dataIndex: 'ORDER_O',			width: 100, summaryType: 'sum'},
			{dataIndex: 'ORDER_WGT_Q',		width: 110, hidden: true},
			{dataIndex: 'ORDER_WGT_P',		width: 100, hidden: true},
			{dataIndex: 'ORDER_VOL_Q',		width: 110, hidden: true},
			{dataIndex: 'ORDER_VOL_P',		width: 100, hidden: true},
			{dataIndex: 'TAX_TYPE',			width: 80, align: 'center'},
			{dataIndex: 'ORDER_TAX_O',		width: 110, summaryType: 'sum'},
			{dataIndex: 'ORDER_O_TAX_O',	width: 110, summaryType: 'sum'},
			{dataIndex: 'WGT_UNIT',			width: 80, hidden: true},
			{dataIndex: 'UNIT_WGT',			width: 90, hidden: true},
			{dataIndex: 'VOL_UNIT',			width: 80, hidden: true},
			{dataIndex: 'UNIT_VOL',			width: 90, hidden: true},
			{dataIndex: 'DVRY_DATE',		width: 90},
			{dataIndex: 'DVRY_TIME',		width: 100, hidden: false},
			//20190805 추가: 구매요청등록 체크로직
			{dataIndex: 'PURCHASE_YN',		width: 133, xtype : 'checkcolumn',
				listeners: {
					beforecheckchange: function( CheckColumn, rowIndex, checked, eOpts ){
						//저장버튼 활성화 체크,
						var saveYn = UniAppManager.app._needSave();
						if(saveYn) {
							Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
							return false;
						}
						var grdRecord = detailGrid.getStore().getAt(rowIndex);
						var param = {
							COMP_CODE	: UserInfo.compCode,
							DIV_CODE	: grdRecord.get('OUT_DIV_CODE'),
							ITEM_CODE	: grdRecord.get('ITEM_CODE')
						}
						detailGrid.mask();
						sof100ukrvService.getSupplyType(param, function(provider, response) {
							if(provider && provider[0].SUPPLY_TYPE == '1') {
								var seqs = grdRecord.get('OUT_DIV_CODE') + '-' + grdRecord.get('SER_NO');
								if(checked == true) {
									pSeqs = panelResult.getValue('SEQS');
									if(Ext.isEmpty(pSeqs)) {
										panelResult.setValue('SEQS', seqs);
									} else {
										panelResult.setValue('SEQS', pSeqs + ',' + seqs);
									}
								} else {
									pSeqs = panelResult.getValue('SEQS');
									var deletedNum0	= grdRecord.get('OUT_DIV_CODE') + '-' + grdRecord.get('SER_NO') + ',';
									var deletedNum1	= ',' + grdRecord.get('OUT_DIV_CODE') + '-' + grdRecord.get('SER_NO');
									var deletedNum2	= grdRecord.get('OUT_DIV_CODE') + '-' + grdRecord.get('SER_NO');
									pSeqs = pSeqs.split(deletedNum0).join("");
									pSeqs = pSeqs.split(deletedNum1).join("");
									pSeqs = pSeqs.split(deletedNum2).join("");
									panelResult.setValue('SEQS', pSeqs);
								}
								UniAppManager.setToolbarButtons('save', saveYn);
								detailGrid.unmask();
								return true
							} else {
								grdRecord.set('PURCHASE_YN', false);
								Unilite.messageBox('조달구분이 구매인 품목만 구매요청등록 할 수 있습니다.');
								detailGrid.unmask();
								return false;
							}
							detailGrid.unmask();
						});
					},
					checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
//						detailStore.commitChanges();
//						UniAppManager.setToolbarButtons('save', false);
					}
				}
			},
			{dataIndex: 'DISCOUNT_RATE',	width: 80},
			{dataIndex: 'UPN_CODE',		    width: 100 },
			{dataIndex: 'DVRY_CUST_NAME',	width: 100,
				editor: Unilite.popup('DELIVERY_G',{
						autoPopup: true,
						listeners:{ 'onSelected': {
							fn: function(records, type  ){
							// var grdRecord =
							// Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DVRY_CUST_CD',records[0]['DELIVERY_CODE']);
							grdRecord.set('DVRY_CUST_NAME',records[0]['DELIVERY_NAME']);
						},
					scope: this
				},
				'onClear' : function(type) {
						// var grdRecord =
						// Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
						var grdRecord = detailGrid.uniOpt.currentRecord;
						grdRecord.set('DVRY_CUST_CD','');
						grdRecord.set('DVRY_CUST_NAME','');
				},
				applyextparam: function(popup){
						popup.setExtParam({'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE')});
					}
				}
			})
			},
			{dataIndex: 'OUT_WH_CODE',		width: 100, hidden: false,
				listeners:{
					render:function(elm) {
						  elm.editor.on('beforequery',function(queryPlan, eOpts) {
							var store = queryPlan.combo.store;
							 store.clearFilter();
							store.filterBy(function(item){
								return item.get('option') == masterForm.getValue('DIV_CODE');
							})
						})
					}
				}
			},
			{dataIndex: 'ACCOUNT_YNC',		width: 80, align: 'center'},
			{dataIndex: 'SALE_CUST_CD',		width: 80, hidden: true},		//20200527 추가: ext-all-debug 오류 발생 -> hidden으로 컬럼 추가
			{dataIndex: 'CUSTOM_NAME',		width: 110,
				editor: Unilite.popup('AGENT_CUST_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
								// var grdRecord =
								// Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('SALE_CUST_CD',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							// var grdRecord =
							// Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SALE_CUST_CD','');
							grdRecord.set('CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'PRICE_YN',			width: 80, align: 'center'},
			{dataIndex: 'STOCK_Q',			width: 100},
			{dataIndex: 'PROD_SALE_Q',		width: 100, summaryType: 'sum'},
			{dataIndex: 'PROD_Q',			width: 140, summaryType: 'sum'},
			{dataIndex: 'PROD_END_DATE',	width: 100},
			{dataIndex: 'HS_CODE',			width: 120,
				editor: Unilite.popup('HS_G', {
					DBtextFieldName: 'HS_CODE',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('HS_CODE', records[0]['HS_NO']);
								grdRecord.set('HS_NAME', records[0]['HS_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('HS_CODE', '');
							grdRecord.set('HS_NAME', '');
						},
						applyextparam: function(popup){
						}
					}
				})
			},
			{dataIndex: 'HS_NAME',			width: 120, hidden: true},
			{dataIndex: 'DVRY_CUST_CD',		width: 100, hidden: true},
			{dataIndex: 'ORDER_STATUS',		width: 80, align: 'center' },
			{dataIndex: 'PO_NUM',			width: 110},
			{dataIndex: 'PO_SEQ',			width: 80 },
			{dataIndex: 'PROJECT_NO',		width: 130,
				editor: Unilite.popup('PROJECT_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = detailGrid.uniOpt.currentRecord;
								Ext.each(records, function(record,i) {
									if(i==0) {
										grdRecord.set('PROJECT_NO'	, record['PJT_CODE']);
										//20200102 프로젝트명 추가
										grdRecord.set('PJT_NAME'	, record['PJT_NAME']);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('PROJECT_NO'	, '');
							//20191226 프로젝트명 추가
							grdRecord.set('PJT_NAME'	, '');
						},
						applyextparam: function(popup){
							//거래처 관련 쿼리가 없음
//						  popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
						}
					}
				})
			},
			//20200102 프로젝트명 추가
			{dataIndex: 'PJT_NAME',			width: 120 },
			{dataIndex: 'ISSUE_REQ_Q',		width: 90, summaryType: 'sum' },
			{dataIndex: 'ESTI_NUM',			width: 100},
			{dataIndex: 'ESTI_SEQ',			width: 80 },
//			//20190607 SAMPLE_KEY 추가
//			{dataIndex: 'SAMPLE_KEY'	,	width: 100, hidden: true},
			{dataIndex: 'BARCODE'		,	width: 120},
			{dataIndex: 'REMARK'		,	width: 300},
			// 20210422 ADDRESS 추가
			{dataIndex: 'ADDRESS'		,	width: 200,hidden: true },
			{dataIndex: 'NATION_INOUT'	,	width: 80, hidden: true },
			{dataIndex: 'MONEY_UNIT'	,	width: 80, hidden: true },
			{dataIndex: 'OFFER_NO'		,	width: 80, hidden: true },
			{dataIndex: 'REMARK_INTER'	,	width: 300},
			//20190306 추가
			{dataIndex: 'CARE_YN'		,	width: 80	 , hidden: true },
			{dataIndex: 'CARE_REASON'	,	width: 80	 , hidden: true },
			{dataIndex: 'LOT_NO'		,	width: 120 , hidden: true },
			//20190725 고객명(RECEIVER_NAME),	송장번호(INVOICE_NUM) 추가
			{dataIndex: 'RECEIVER_NAME'	,	width: 150 , hidden: false },
			{dataIndex: 'INVOICE_NUM'	,	width: 120 , hidden: false },
			//20191231 추가
			{dataIndex: 'REFREQ_YN'		,	width: 120 , hidden: true },
			//20200117 추가
			{dataIndex: 'ISSUE_REQ_YN'		,	width: 120 , hidden: true },
			{dataIndex: 'ISSUE_PLAN_DATE'	,	width: 120 , hidden: true },
			{dataIndex: 'ISSUE_PLAN_NUM'	,	width: 120 , hidden: true }
		],
		listeners: {
			//20210611 추가: 금액 변경 시, 세액 포함여부가 포함이면 입력된 금액이 변경되나 validator에서 처리 못해 editor 추가
			edit: function(editor, e) {
				var fieldName = e.field;
				switch (fieldName) {
					case 'ORDER_O':
						if(Ext.isEmpty(Ext.getCmp('taxInout').getChecked())? '1' : Ext.getCmp('taxInout').getChecked()[0].inputValue == '2') {
							UniAppManager.app.fnOrderAmtCal(e.record, 'O', e.value);
							detailStore.fnOrderAmtSum();
						}
					break;
				}
			},
			//20210507 추가: 기간별 수불현황 조회로 링크기능 추가
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			},
			// contextMenu의 복사한 행 삽입 실행 전
			beforePasteRecord: function(rowIndex, record) {
				if(!UniAppManager.app.checkForNewDetail()) return false;

				var seq = detailStore.max('SER_NO');
				if(!seq) seq = 1;
				else  seq += 1;
				record.SER_NO = seq;

				return true;
			},
			// contextMenu의 복사한 행 삽입 실행 후
			afterPasteRecord: function(rowIndex, record) {
				console.log(">>masterGrid.afterPasteRecord");
				masterForm.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			},
			beforeedit  : function( editor, e, eOpts ) {
				//20190621 계산용 필드는 수정 불가능 하도록 설정
				if (UniUtils.indexOf(e.field,['ORDER_P_CAL'])) return false;
				if (UniUtils.indexOf(e.field,['SAMPLE_KEY'])) return false;
				//20191231 추가: 출하예정참조여부 컬럼은 수정 불가능하도록 설정
				if (UniUtils.indexOf(e.field,['REFREQ_YN'])) return false;

				if(BsaCodeInfo.gsDraftFlag == 'Y' && Ext.getCmp('status').getChecked()[0].inputValue != '1') {
					return false;
				} else if(e.record.phantom) {
					if(!Ext.isEmpty(e.record.data.ESTI_NUM)) {
						if (UniUtils.indexOf(e.field,
											['ITEM_CODE','ITEM_NAME','ORDER_UNIT','TRANS_RATE','TAX_TYPE','ACCOUNT_YNC','STOCK_Q','ORDER_STATUS',
											 'ESTI_NUM','ESTI_SEQ','PROD_Q'/*,'ORDER_O_TAX_O'*/,'WGT_UNIT','UNIT_WGT','VOL_UNIT','UNIT_VOL']))		//20210611 수정: ORDER_O_TAX_O 수정가능하게 변경
							return false;

					} else {
						if (UniUtils.indexOf(e.field,
											['SPEC','STOCK_Q','ORDER_STATUS','ESTI_NUM','PROD_Q',
											/*'ORDER_O_TAX_O',*/ 'WGT_UNIT', 'UNIT_WGT', 'VOL_UNIT', 'UNIT_VOL']))									//20210611 수정: ORDER_O_TAX_O 수정가능하게 변경
							return false;

						if(masterForm.getValue('BILL_TYPE') == '50') {
							if(e.field=='TAX_TYPE') return false;
						}
					}
					if(e.record.data.TAX_TYPE != '1') {
						if(e.field=='ORDER_TAX_O') return false;
					}
					if(e.record.data.ITEM_ACCOUNT == '00') {
						if(e.field=='PROD_SALE_Q') return false;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME']))
						return false;
					if(e.record.data.SALE_Q == 0) {
						if(e.record.data.ISSUE_REQ_Q > 0 || e.record.data.OUTSTOCK_Q > 0) {
							switch(e.field) {
								case 'ORDER_P':
									if(e.record.data.PRICE_YN != '1') return false;
									break;
								case 'PRICE_YN':
									if(e.record.data.PRICE_YN != '1') return false;
									break;
								case 'ACCOUNT_YNC':
									if(!Ext.isEmpty(e.record.data.ESTI_NUM)) return false;
									break;
								default:
									return false
									break;
							}
						} else {
							if(UniUtils.indexOf(e.field, ['SER_NO','SPEC','STOCK_Q','ESTI_NUM','ESTI_SEQ','PROD_Q'/*,'ORDER_O_TAX_O'*/]))			//20210611 수정: ORDER_O_TAX_O 수정가능하게 변경
								return false;

							if(!Ext.isEmpty(e.record.data.ESTI_NUM)) {
								if(UniUtils.indexOf(e.field, ['ORDER_UNIT','TRANS_RATE','ACCOUNT_YNC','ITEM_CODE','ITEM_NAME']))
									return false;
							}
							if(e.field=='TAX_TYPE') {
								if(masterForm.getValue('BILL_TYPE') != "50") {
									if(!Ext.isEmpty(e.record.data.ESTI_NUM)) {
										return false;
									}
								} else {
									return false;
								}
							}
							if(e.field=='PROD_SALE_Q') {
								if(masterForm.getValue('ITEM_ACCOUNT') == "00") {
									return false;
								}
							}
							if(UniUtils.indexOf(e.field, ['WGT_UNIT','UNIT_WGT','VOL_UNIT','UNIT_VOL'])) return false;
						}
					} else {
						switch(e.field) {
							case 'ORDER_P':
								if(e.record.data.PRICE_YN != '1') return false;
								break;
							case 'PRICE_YN':
								if(e.record.data.PRICE_YN != '1') return false;
								break;
							case 'ACCOUNT_YNC':
								if(!Ext.isEmpty(e.record.data.ESTI_NUM)) return false;
								break;
							default:
								return false
								break;
						}
					}
				}
			}
		},
		//20210507 추가: 기간별 수불현황 조회로 링크기능 추가
		onItemcontextmenu:function( menu, grid, record, item, index, event, e, eOpts ) {
			if(Ext.isEmpty(BsaCodeInfo.gsButtonLink2)) {
				menu.down('#gsButtonLink2').hide();
			} else {
				menu.down('#gsButtonLink2').show();
			}
			return true;
		},
		//20210507 추가: 기간별 수불현황 조회로 링크기능 추가
		uniRowContextMenu:{
			items: [{
				text	: '기간별 수불현황 조회',
				itemId	: 'gsButtonLink2',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					detailGrid.goto_biv360skrv(param.record);
				}
			}]
		},
		goto_biv360skrv:function(record) {
			if(record) {
				var linkPgmId	= BsaCodeInfo.gsButtonLink2.split('/')[2].substring(0, BsaCodeInfo.gsButtonLink2.split('/')[2].length - 3);
				var params		= {
					action			: 'select',
					'PGM_ID'		: PGM_ID,
					'DIV_CODE'		: record.get('DIV_CODE'),
					'ITEM_CODE'		: record.get('ITEM_CODE'),
					'ITEM_NAME'		: record.get('ITEM_NAME'),
					'ORDER_DATE_FR'	: UniDate.get('sixMonthsAgo'),
					'ORDER_DATE_TO'	: UniDate.get('today')
				}
				var rec1= {data: {prgID: linkPgmId, 'text': ''}};
				parent.openTab(rec1, BsaCodeInfo.gsButtonLink2, params, CHOST+CPATH);
			}
		},
		//품목정보 팝업에서 선택된 데이타 수주정보 그리드에 추가하는 함수, 품목팝업의 onSelected/onClear 이벤트가 일어날때 호출됨
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, '');
				grdRecord.set('ITEM_NAME'		, '');
				grdRecord.set('SPEC'			, '');
				grdRecord.set('ORDER_UNIT'		, '');
				grdRecord.set('STOCK_UNIT'		, '');
				grdRecord.set('ORDER_Q'			, 0);
				grdRecord.set('ORDER_P'			, 0);
				//20190621 할인율 계산용 필드 추가
				grdRecord.set('ORDER_P_CAL'		, 0);
				grdRecord.set('ORDER_WGT_Q'		, 0);
				grdRecord.set('ORDER_WGT_P'		, 0);
				grdRecord.set('ORDER_VOL_Q'		, 0);
				grdRecord.set('ORDER_VOL_P'		, 0);
				grdRecord.set('ORDER_O'			, 0);
				grdRecord.set('PROD_SALE_Q'		, 0);
				grdRecord.set('PROD_Q'			, 0);
				grdRecord.set('STOCK_Q'			, 0);
				grdRecord.set('DISCOUNT_RATE'	, 0);
				grdRecord.set('WGT_UNIT'		, '');
				grdRecord.set('UNIT_WGT'		, 0);
				grdRecord.set('VOL_UNIT'		, '');
				grdRecord.set('UNIT_VOL'		, 0);
				grdRecord.set('HS_CODE'			, '');
				grdRecord.set('HS_NAME'			, '');
				grdRecord.set('TRANS_RATE'		, 1);
				//20190306 추가
				grdRecord.set('CARE_YN'			, 'N');
				grdRecord.set('CARE_REASON'		, '');
				grdRecord.set('UPN_CODE'		, '');
// grdRecord.set('PROD_END_DATE' ,'');
// grdRecord.set('OEM_ITEM_CODE' ,"");
			} else {
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('ORDER_UNIT'			, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);
				grdRecord.set('OUT_WH_CODE'			, record['WH_CODE']);		//20190118 품목선택시 주창고로 출고창고 세팅
				if((masterForm.getValue('BILL_TYPE') != "50" && masterForm.getValue('BILL_TYPE') != "60") && masterForm.getValue('NATION_INOUT') == "1"){
					grdRecord.set('TAX_TYPE'		, record['TAX_TYPE']);
				}
				grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
				grdRecord.set('OUT_DIV_CODE'		, record['DIV_CODE']);
				grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
				grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
				grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
				grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
// grdRecord.set('OEM_ITEM_CODE' ,record['OEM_ITEM_CODE']);
				grdRecord.set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));
				grdRecord.set('HS_CODE'				, record['HS_NO']);
				grdRecord.set('HS_NAME'				, record['HS_NAME']);
				grdRecord.set('TRANS_RATE'			, record['TRNS_RATE']);
				//20190306 추가
				grdRecord.set('CARE_YN'				, record['CARE_YN']);
				grdRecord.set('CARE_REASON'			, record['CARE_REASON']);
				grdRecord.set('UPN_CODE'			, record['UPN_CODE']);

				UniSales.fnGetItemInfo(
						grdRecord
						, UniAppManager.app.cbGetItemInfo
						,'I'
						,UserInfo.compCode
						,masterForm.getValue('CUSTOM_CODE')
						,CustomCodeInfo.gsAgentType
						,record['ITEM_CODE']
						,masterForm.getValue('MONEY_UNIT')
						,record['SALE_UNIT']
						,record['STOCK_UNIT']
						,record['TRANS_RATE']
						,UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE'))
						,grdRecord.get('ORDER_Q')
						,record['WGT_UNIT']
						,record['VOL_UNIT']
						,record['UNIT_WGT']
						,record['UNIT_VOL']
						,record['PRICE_TYPE']
						,record['DIV_CODE']
						, null
						, ''
						//20190625 fnGetPABStock 함수 사용하여 재고 가져오기 위해 변수 추가로 넘김
						, ''								//useDefaultPrice
						//20190625 fnGetPABStock 함수 사용하여 재고(pab_stock_q) 가져오는 로직 수행
						, BsaCodeInfo.gsPStockYn			//showPstock
				);
			}
		},
		setEstiData: function(record) {
			var grdRecord = this.getSelectedRecord();

			// grdRecord.set('DIV_CODE' , record['DIV_CODE']);
			grdRecord.set('ORDER_NUM'		   , masterForm.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'		   , record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		   , record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'		  , record['ESTI_UNIT']);
			grdRecord.set('TRANS_RATE'		  , record['TRANS_RATE']);
			grdRecord.set('ORDER_Q'			 , record['ESTI_QTY']);
			grdRecord.set('ORDER_P'			 , record['ESTI_PRICE']);
			//20190621 할인율 계산용 필드 추가
			grdRecord.set('ORDER_P_CAL'		 , record['ESTI_PRICE']);
			grdRecord.set('SCM_FLAG_YN'		 , 'N');
			if(masterForm.getValue('TAX_INOUT') != 50)
			{
				grdRecord.set('TAX_TYPE'		,record['TAX_TYPE'] );
			}
			if(Ext.isEmpty(masterForm.getValue('DVRY_DATE'))) {
				grdRecord.set('DVRY_DATE'	   ,masterForm.getValue('ORDER_DATE'));
			} else {
				grdRecord.set('DVRY_DATE'	   ,masterForm.getValue('DVRY_DATE'));
			}
			grdRecord.set('DISCOUNT_RATE'	   , 0);
			grdRecord.set('REF_WH_CODE'		 , record['WH_CODE']);
			grdRecord.set('REF_STOCK_CARE_YN'   , record['STOCK_CARE_YN']);
			grdRecord.set('OUT_DIV_CODE'		, UserInfo.divCode);
			grdRecord.set('STOCK_UNIT'		  , record['STOCK_UNIT']);
			grdRecord.set('ACCOUNT_YNC'		 , 'Y');

			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_CD'))) {
				grdRecord.set('SALE_CUST_CD'		,masterForm.getValue('CUSTOM_CODE'));
			} else {
				grdRecord.set('SALE_CUST_CD'		,masterForm.getValue('SALE_CUST_CD'));
			}

			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_NM'))) {
				grdRecord.set('CUSTOM_NAME'	 ,masterForm.getValue('CUSTOM_NAME'));
			} else {
				grdRecord.set('CUSTOM_NAME'	 ,masterForm.getValue('SALE_CUST_NM'));
			}
			grdRecord.set('PROD_PLAN_Q'		 , 0);
			grdRecord.set('ESTI_NUM'			, record['ESTI_NUM']);
			grdRecord.set('ESTI_SEQ'			, record['ESTI_SEQ']);
			grdRecord.set('REF_ORDER_DATE'	  , masterForm.getValue('ORDER_DATE'));
			grdRecord.set('REF_ORD_CUST'		, masterForm.getValue('CUSTOM_CODE'));
			grdRecord.set('REF_ORDER_TYPE'	  , masterForm.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'	  , masterForm.getValue('PROJECT_NO'));
			grdRecord.set('REF_TAX_INOUT'	   , Ext.getCmp('taxInout').getChecked()[0].inputValue);
			// FIXME gsExchageRate값 설정
			// grdRecord.set('REF_EXCHG_RATE_O' ,gsExchageRate);
			grdRecord.set('REF_REMARK'		  , masterForm.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'			, record['ESTI_QTY']);
			grdRecord.set('REF_BILL_TYPE'	   , masterForm.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH', masterForm.getValue('RECEIPT_SET_METH'));
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);

			//20190306 추가
			grdRecord.set('CARE_YN'			 , record['CARE_YN']);
			grdRecord.set('CARE_REASON'		 , record['CARE_REASON']);

			if(!Ext.isEmpty(masterForm.getValue('PROJECT_NO'))) {
				grdRecord.set('PROJECT_NO'  , masterForm.getValue('PROJECT_NO'));
				//20200102 추가
				grdRecord.set('PJT_NAME' 	 , masterForm.getValue('PJT_NAME'));
			}

			UniSales.fnGetItemInfo(grdRecord, UniAppManager.app.cbGetItemInfo
									,'I'
									,UserInfo.compCode
									,masterForm.getValue('CUSTOM_CODE')
									,CustomCodeInfo.gsAgentType
									,record['ITEM_CODE']
									,BsaCodeInfo.gsMoneyUnit
									,record['ESTI_UNIT']
									,record['STOCK_UNIT']
									,record['TRANS_RATE']
									,UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE'))
									,grdRecord.get('ORDER_Q')
									,record['WGT_UNIT']
									,record['VOL_UNIT']
									,record['UNIT_WGT']
									,record['UNIT_VOL']
									,record['PRICE_TYPE']
									, UserInfo.divCode
									, null
									, ''
									//20190625 fnGetPABStock 함수 사용하여 재고 가져오기 위해 변수 추가로 넘김
									, ''								//useDefaultPrice
									//20190625 fnGetPABStock 함수 사용하여 재고(pab_stock_q) 가져오는 로직 수행
									, BsaCodeInfo.gsPStockYn			//showPstock
									);


			// 수주수량/단가(중량) 재계산
			var sUnitWgt   = record['UNIT_WGT'];
			var sOrderWgtQ = grdRecord.set('ORDER_WGT_Q', (record['ESTI_QTY'] * sUnitWgt));

			if( sUnitWgt == 0) {
				grdRecord.set('ORDER_WGT_P'	 ,0);
			} else {
				grdRecord.set('ORDER_WGT_P', (record['ESTI_PRICE'] / sUnitWgt))
			}

			// 수주수량/단가(부피) 재계산
			var sUnitVol   = record['UNIT_VOL'];
			var sOrderVolQ = grdRecord.set('ORDER_VOL_Q', (record['ESTI_QTY'] * sUnitVol));

			if( sUnitVol == 0) {
				grdRecord.set('ORDER_VOL_P'	 ,0);
			} else {
				grdRecord.set('ORDER_VOL_P', (record['ESTI_PRICE'] / sUnitVol))
			}
		},
		setRefData: function(record) {
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('ORDER_P'				, record['ORDER_P']);
			//20190621 할인율 계산용 필드 추가
			grdRecord.set('ORDER_P_CAL'			, record['ORDER_P']);

			grdRecord.set('ORDER_O'				, record['ORDER_O']);//	 금액
			grdRecord.set('ORDER_TAX_O'			, record['ORDER_TAX_O']);// 부가세액
			grdRecord.set('ORDER_O_TAX_O'		, (record['ORDER_O'] + record['ORDER_TAX_O']));//   수주합계
			grdRecord.set('PROD_END_DATE'		, UniDate.get('today'));	//생산완료일
			grdRecord.set('SCM_FLAG_YN'			, 'N');
			if(masterForm.getValue('TAX_INOUT') != 50) {
				grdRecord.set('TAX_TYPE'		, record['TAX_TYPE']);
			}
			if(Ext.isEmpty(masterForm.getValue('DVRY_DATE'))) {
				grdRecord.set('DVRY_DATE'		, masterForm.getValue('ORDER_DATE'));
			} else {
				grdRecord.set('DVRY_DATE'		, masterForm.getValue('DVRY_DATE'));
			}
			grdRecord.set('DISCOUNT_RATE'		, 0);
			grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);
			grdRecord.set('OUT_WH_CODE'			, record['WH_CODE']);		//20210504 추가: 수주이력 참조 적용 시, 출고창고 BPR200T.WH_CODE로 set
			grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
			grdRecord.set('OUT_DIV_CODE'		, record['OUT_DIV_CODE']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			//20191001 참조적용 시, 매출대상 여부는 "Y"로 set
			grdRecord.set('ACCOUNT_YNC'			, 'Y');
//			grdRecord.set('ACCOUNT_YNC'			, record['ACCOUNT_YNC']);
			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_CD'))) {
				grdRecord.set('SALE_CUST_CD'	, masterForm.getValue('CUSTOM_CODE'));
			} else {
				grdRecord.set('SALE_CUST_CD'	, masterForm.getValue('SALE_CUST_CD'));
			}
			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_NM'))) {
				grdRecord.set('CUSTOM_NAME'		, masterForm.getValue('CUSTOM_NAME'));
			} else {
				grdRecord.set('CUSTOM_NAME'		, masterForm.getValue('SALE_CUST_NM'));
			}

			grdRecord.set('OUTSTOCK_Q'			, 0);
			grdRecord.set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);
			grdRecord.set('DVRY_CUST_NAME'		, record['DVRY_CUST_NAME']);
			grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
			grdRecord.set('PROD_PLAN_Q'			, 0);
			grdRecord.set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
			grdRecord.set('PRE_ACCNT_YN'		, record['PRE_ACCNT_YN']);
			grdRecord.set('REF_ORDER_DATE'		, masterForm.getValue('ORDER_DATE'));
			grdRecord.set('REF_ORD_CUST'		, masterForm.getValue('CUSTOM_CODE'));
			grdRecord.set('REF_ORDER_TYPE'		, masterForm.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'		, masterForm.getValue('PROJECT_NO'));
			grdRecord.set('REF_TAX_INOUT'		, Ext.getCmp('taxInout').getChecked()[0].inputValue);
			// FIXME gsExchageRate값 설정
			// grdRecord.set('REF_EXCHG_RATE_O' ,gsExchageRate);
			grdRecord.set('REF_REMARK'			, masterForm.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'			, record['ORDER_Q']);
			grdRecord.set('REF_BILL_TYPE'		, masterForm.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH', masterForm.getValue('RECEIPT_SET_METH'));
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
			//20190306 추가
			grdRecord.set('CARE_YN'				, record['CARE_YN']);
			grdRecord.set('CARE_REASON'			, record['CARE_REASON']);
			if(!Ext.isEmpty(masterForm.getValue('PROJECT_NO'))) {
				grdRecord.set('PROJECT_NO'		, masterForm.getValue('PROJECT_NO'));
				//20200102 추가
				grdRecord.set('PJT_NAME' 	 	, masterForm.getValue('PJT_NAME'));
			}
			UniSales.fnGetItemInfo(grdRecord
									, UniAppManager.app.cbGetItemInfo
									,'I'
									,UserInfo.compCode
									,masterForm.getValue('CUSTOM_CODE')
									,CustomCodeInfo.gsAgentType
									,record['ITEM_CODE']
									,BsaCodeInfo.gsMoneyUnit
									,record['ORDER_UNIT']
									,record['STOCK_UNIT']
									,record['TRANS_RATE']
									,UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE'))
									,grdRecord.get('ORDER_Q')
									,grdRecord.get('WGT_UNIT')
									,grdRecord.get('VOL_UNIT')
									,grdRecord.get('UNIT_WGT')
									,grdRecord.get('UNIT_VOL')
									,grdRecord.get('PRICE_TYPE')
									, record['OUT_DIV_CODE']
									, null
									, ''
									//20190625 fnGetPABStock 함수 사용하여 재고 가져오기 위해 변수 추가로 넘김
									, ''								//useDefaultPrice
									//20190625 fnGetPABStock 함수 사용하여 재고(pab_stock_q) 가져오는 로직 수행
									, BsaCodeInfo.gsPStockYn			//showPstock
									);
			// UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
			// UniAppManager.app.fnStockQ(grdRecord, UserInfo.compCode,
			// record['OUT_DIV_CODE'],
			// null,record['ITEM_CODE'],record['WH_CODE']);
		},
		//20200102 출하예정참조 적용로직 추가
		setReqData: function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('REFREQ_YN'			, record['REFREQ_YN']);
			grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TRANS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('ORDER_Q'				, record['ISSUE_PLAN_QTY']);
			grdRecord.set('ORDER_P'				, record['ORDER_P']);
			grdRecord.set('ORDER_P_CAL'			, record['ORDER_P']);
			grdRecord.set('ORDER_O'				, record['ORDER_O']);
			grdRecord.set('ORDER_TAX_O'			, record['ORDER_TAX_O']);// 부가세액
			grdRecord.set('ORDER_O_TAX_O'		, record['ORDER_O'] + record['ORDER_TAX_O']);//   수주합계
			grdRecord.set('PROD_END_DATE'		, record['ISSUE_PLAN_DATE']);
			grdRecord.set('SCM_FLAG_YN'			, 'N');
			if(masterForm.getValue('TAX_INOUT') != 50) {
				grdRecord.set('TAX_TYPE'		, record['TAX_TYPE']);
			}
			if(Ext.isEmpty(masterForm.getValue('DVRY_DATE'))) {
				grdRecord.set('DVRY_DATE'		, masterForm.getValue('ORDER_DATE'));
			} else {
				grdRecord.set('DVRY_DATE'		, masterForm.getValue('DVRY_DATE'));
			}
			grdRecord.set('DISCOUNT_RATE'		, 0);
			grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);
			grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
			grdRecord.set('OUT_DIV_CODE'		, record['DIV_CODE']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			//20191001 참조적용 시, 매출대상 여부는 "Y"로 set
			grdRecord.set('ACCOUNT_YNC'			, 'Y');
			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_CD'))) {
				grdRecord.set('SALE_CUST_CD'	, masterForm.getValue('CUSTOM_CODE'));
			} else {
				grdRecord.set('SALE_CUST_CD'	, masterForm.getValue('SALE_CUST_CD'));
			}
			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_NM'))) {
				grdRecord.set('CUSTOM_NAME'		, masterForm.getValue('CUSTOM_NAME'));
			} else {
				grdRecord.set('CUSTOM_NAME'		, masterForm.getValue('SALE_CUST_NM'));
			}

			grdRecord.set('OUTSTOCK_Q'			, 0);

			grdRecord.set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);
			grdRecord.set('DVRY_CUST_NAME'		, record['DVRY_CUST_NAME']);
			grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
			grdRecord.set('PROD_PLAN_Q'			, 0);
			grdRecord.set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
			grdRecord.set('PRE_ACCNT_YN'		, record['PRE_ACCNT_YN']);
			grdRecord.set('REF_ORDER_DATE'		, masterForm.getValue('ORDER_DATE'));
			grdRecord.set('REF_ORD_CUST'		, masterForm.getValue('CUSTOM_CODE'));
			grdRecord.set('REF_ORDER_TYPE'		, masterForm.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'		, masterForm.getValue('PROJECT_NO'));
			grdRecord.set('REF_TAX_INOUT'		, Ext.getCmp('taxInout').getChecked()[0].inputValue);
			grdRecord.set('REF_REMARK'			, masterForm.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'			, record['ORDER_Q']);
			grdRecord.set('REF_BILL_TYPE'		, masterForm.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH', masterForm.getValue('RECEIPT_SET_METH'));
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
			grdRecord.set('CARE_YN'				, record['CARE_YN']);
			grdRecord.set('CARE_REASON'			, record['CARE_REASON']);
			grdRecord.set('ISSUE_PLAN_DATE'		, record['ISSUE_PLAN_DATE']);
			grdRecord.set('ISSUE_PLAN_NUM'		, record['ISSUE_PLAN_NUM']);
			if(!Ext.isEmpty(masterForm.getValue('PROJECT_NO'))) {
				grdRecord.set('PROJECT_NO'		, masterForm.getValue('PROJECT_NO'));
				//20200102 추가
				grdRecord.set('PJT_NAME' 		 , masterForm.getValue('PJT_NAME'));
			}
			grdRecord.set('REMARK'				, record['REMARK']);
			UniSales.fnGetItemInfo(grdRecord
									, UniAppManager.app.cbGetItemInfo
									,'I'
									,UserInfo.compCode
									,masterForm.getValue('CUSTOM_CODE')
									,CustomCodeInfo.gsAgentType
									,record['ITEM_CODE']
									,BsaCodeInfo.gsMoneyUnit
									,record['ORDER_UNIT']
									,record['STOCK_UNIT']
									,record['TRANS_RATE']
									,UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE'))
									,grdRecord.get('ORDER_Q')
									,grdRecord.get('WGT_UNIT')
									,grdRecord.get('VOL_UNIT')
									,grdRecord.get('UNIT_WGT')
									,grdRecord.get('UNIT_VOL')
									,grdRecord.get('PRICE_TYPE')
									, record['OUT_DIV_CODE']
									, null
									, ''
									//20190625 fnGetPABStock 함수 사용하여 재고 가져오기 위해 변수 추가로 넘김
									, ''								//useDefaultPrice
									//20190625 fnGetPABStock 함수 사용하여 재고(pab_stock_q) 가져오는 로직 수행
									, BsaCodeInfo.gsPStockYn			//showPstock
			);
		},
		setExcelData: function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));
			grdRecord.set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TRANS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('ORDER_Q'				, record['QTY']);
			grdRecord.set('ORDER_P'				, record['ORDER_P']);
			//20190621 할인율 계산용 필드 추가
			grdRecord.set('ORDER_P_CAL'			, record['ORDER_P']);
			grdRecord.set('SCM_FLAG_YN'			, 'N');
			grdRecord.set('TAX_TYPE'			, '1');
			grdRecord.set('REF_ORDER_TYPE'		, masterForm.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'		, masterForm.getValue('PROJECT_NO'));
			grdRecord.set('REF_MONEY_UNIT'		, record['']);
			// FIXME gsExchageRate값 설정
			// grdRecord.set('REF_EXCHG_RATE_O'	,gsExchageRate);
			grdRecord.set('REF_REMARK'			, masterForm.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'			, record['QTY']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);
			grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
			grdRecord.set('OUT_DIV_CODE'		, masterForm.getValue('DIV_CODE'));
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
			grdRecord.set('OUT_WH_CODE'			, record['OUT_WH_CODE']);
			// grdRecord.set('ORDER_O'			, record['QTY'] * record['PRICE']);
			grdRecord.set('ORDER_O'				, record['ORDER_O']);
			grdRecord.set('ORDER_TAX_O'			, record['ORDER_TAX_O']);
			grdRecord.set('ORDER_O_TAX_O'		, record['ORDER_O_TAX_O']);
			grdRecord.set('PROD_END_DATE'		, UniDate.get('today'));
			//20190306 추가
			grdRecord.set('CARE_YN'				, record['CARE_YN']);
			grdRecord.set('CARE_REASON'			, record['CARE_REASON']);
			//20190725 추가
			grdRecord.set('RECEIVER_NAME'		, record['RECEIVER_NAME']);
			grdRecord.set('INVOICE_NUM'			, record['INVOICE_NUM']);

			grdRecord.set('OUTSTOCK_Q'			, 0);

			if(!Ext.isEmpty(masterForm.getValue('PROJECT_NO'))) {
				grdRecord.set('PROJECT_NO'		, masterForm.getValue('PROJECT_NO'));
				//20200102 추가
				grdRecord.set('PJT_NAME' 		 , masterForm.getValue('PJT_NAME'));
			}
			UniSales.fnGetItemInfo(grdRecord
								, UniAppManager.app.cbGetItemInfo
								,'I'
								,UserInfo.compCode
								,masterForm.getValue('CUSTOM_CODE')
								,CustomCodeInfo.gsAgentType
								,record['ITEM_CODE']
								,BsaCodeInfo.gsMoneyUnit
								,record['ORDER_UNIT']
								,record['STOCK_UNIT']
								,record['TRANS_RATE']
								,UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE'))
								,grdRecord.get('ORDER_Q')
								,record['WGT_UNIT']
								,record['VOL_UNIT']
								,record['UNIT_WGT']
								,record['UNIT_VOL']
								,record['PRICE_TYPE']
								//20190625 fnGetPABStock 함수 사용하여 재고 가져오기 위해 변수 추가로 넘김
								, masterForm.getValue('DIV_CODE')	//divCode
								, ''								//bParam3
								, ''								//whCode
								, ''								//useDefaultPrice
								//20190625 fnGetPABStock 함수 사용하여 재고(pab_stock_q) 가져오는 로직 수행
								, BsaCodeInfo.gsPStockYn			//showPstock
								);
			if(!Ext.isEmpty(record['DVRY_DATE'])) {
				grdRecord.set('DVRY_DATE'		, record['DVRY_DATE']); //납기일
			}
			// 수주수량/단가(중량) 재계산
			var sUnitWgt   = grdRecord.get('UNIT_WGT');
			var sOrderWgtQ = grdRecord.set('ORDER_WGT_Q', (grdRecord.get('ORDER_Q') * sUnitWgt));

			if( sUnitWgt == 0) {
				grdRecord.set('ORDER_WGT_P'		, 0);
			} else {
				grdRecord.set('ORDER_WGT_P'		, (grdRecord.get('ORDER_P') / sUnitWgt))
			}

			// 수주수량/단가(부피) 재계산
			var sUnitVol   = grdRecord.get('UNIT_VOL');
			var sOrderVolQ = grdRecord.set('ORDER_VOL_Q', (grdRecord.get('ORDER_Q') * sUnitVol));

			if( sUnitVol == 0) {
				grdRecord.set('ORDER_VOL_P'		, 0);
			} else {
				grdRecord.set('ORDER_VOL_P'		, (grdRecord.get('ORDER_P') / sUnitVol))
			}
			// UniAppManager.app.fnOrderAmtCal(grdRecord, "Q");
			// UniAppManager.app.fnStockQ(grdRecord, UserInfo.compCode,
			// grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),
			// grdRecord.get('REF_WH_CODE') );
		},
		setEstimateLinkData:function(params){
			var grdRecord = this.getSelectedRecord();
			var seq = detailStore.max('SER_NO');
//				 if(!seq) seq = 1;
//				 else  seq += 1;
			grdRecord.set('DIV_CODE',				params.data.DIV_CODE);		//20200515 추가
			grdRecord.set('INOUT_TYPE_DETAIL',		'10');
			grdRecord.set('ITEM_CODE',				params.data.ITEM_CODE);
			grdRecord.set('ITEM_NAME',				params.data.ITEM_NAME);
			grdRecord.set('ITEM_ACCOUNT',			params.data.ITEM_ACCOUNT);
			grdRecord.set('SPEC',					params.data.SPEC);
			grdRecord.set('ORDER_UNIT',				params.data.ESTI_UNIT);
			grdRecord.set('TRANS_RATE',				params.data.TRANS_RATE);
			grdRecord.set('ORDER_Q',				params.data.ESTI_QTY);
			grdRecord.set('ORDER_P',				params.data.ESTI_CFM_PRICE);
			//20190621 할인율 계산용 필드 추가
			grdRecord.set('ORDER_P_CAL',			params.data.ESTI_CFM_PRICE);
			if(masterForm.getValue('BILL_TYPE') != '50') {
				grdRecord.set('TAX_TYPE',			params.data.TAX_TYPE);
			} else {
				grdRecord.set('TAX_TYPE',			'2');
			}
			grdRecord.set('DVRY_DATE',				masterForm.getValue('ORDER_DATE'));
			grdRecord.set('REF_WH_CODE',			params.data.WH_CODE);
			grdRecord.set('REF_STOCK_CARE_YN',		params.data.STOCK_CARE_YN);
			if(!Ext.isEmpty(params.data.CUSTOM_CODE)){
				grdRecord.set('SALE_CUST_CD',		params.data.CUSTOM_CODE);
			} else {
				grdRecord.set('SALE_CUST_CD',		masterForm.getValue('CUSTOM_CODE'));
			}
			if(!Ext.isEmpty(params.data.CUSTOM_NAME)){
				grdRecord.set('CUSTOM_NAME',		params.data.CUSTOM_NAME);
			} else {
				grdRecord.set('CUSTOM_NAME',		masterForm.getValue('CUSTOM_NAME'));
			}
			grdRecord.set('ESTI_NUM',				params.data.ESTI_NUM);
			grdRecord.set('ESTI_SEQ',				params.data.ESTI_SEQ);
			grdRecord.set('SER_NO',					seq);
			grdRecord.set('DISCOUNT_RATE',			'0');
			grdRecord.set('ACCOUNT_YNC',			'Y');
			grdRecord.set('PRICE_YN',				'2');
			grdRecord.set('ORDER_STATUS',			'N');
			grdRecord.set('ISSUE_REQ_Q',			'0');
			grdRecord.set('OUTSTOCK_Q',				'0');
			grdRecord.set('RETURN_Q',				'0');
			grdRecord.set('SALE_Q',					'0');
			grdRecord.set('PROD_PLAN_Q',			'0');
			grdRecord.set('PRE_ACCNT_YN',			'Y');
			grdRecord.set('REF_ORDER_DATE',			masterForm.getValue('ORDER_DATE'));
			grdRecord.set('REF_ORD_CUST',			masterForm.getValue('CUSTOM_CODE'));
			grdRecord.set('REF_ORDER_TYPE',			masterForm.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO',			masterForm.getValue('PROJECT_NO'));
			if(masterForm.getValue('TAX_INOUT') == '1') {
				grdRecord.set('REF_TAX_INOUT',	'1');
			} else {
				grdRecord.set('REF_TAX_INOUT',	'2');
			}
			grdRecord.set('REF_MONEY_UNIT',			BsaCodeInfo.gsMoneyUnit);
// grdRecord.set('REF_EXCHG_RATE_O', params.record[0].data.);
			grdRecord.set('REF_REMARK',				masterForm.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q',				params.data.ESTI_QTY);
			grdRecord.set('REF_FLAG',				'F');
			grdRecord.set('REF_BILL_TYPE',			masterForm.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH',	masterForm.getValue('RECEIPT_SET_METH'));

			//20190306 추가
			grdRecord.set('CARE_YN',				params.data.CARE_YN);
			grdRecord.set('CARE_REASON',			params.data.CARE_REASON);

			if(!Ext.isEmpty(masterForm.getValue('PROJECT_NO'))) {
				grdRecord.set('PROJECT_NO',			masterForm.getValue('PROJECT_NO'));
				//20200102 추가
				grdRecord.set('PJT_NAME',			masterForm.getValue('PJT_NAME'));
			}
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(record.get('CARE_YN') == 'Y'){
					cls = 'x-change-cell_pink';
				}
				return cls;
			}
		}
	});




	// 수주정보를 검색하기 위한 Search Form, Grid, Inner Window 정의
	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
		layout: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
			name: 'DIV_CODE',
			xtype:'uniCombobox',
			comboType:'BOR120',
			value:UserInfo.divCode,
			allowBlank:false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = orderNoSearch.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_ORDER_DATE',
			endFieldName: 'TO_ORDER_DATE',
			width: 350,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},{
			fieldLabel: '<t:message code="system.label.sales.pono" default="발주번호"/>',
			name: 'PO_NUM'
		},{
			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name: 'ORDER_PRSN',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'S010',
			value: '',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners:{
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						orderNoSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						orderNoSearch.setValue('CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.sales.sono" default="수주번호"/>'			, name: 'ORDER_NUM'},
			{fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'	, name: 'ORDER_TYPE',   xtype:'uniCombobox',comboType:'AU', comboCode:'S002'},
// Unilite.popup('AGENT_CUST',{fieldLabel:'<t:message code="system.label.sales.project" default="프로젝트"/>' , valueFieldName:'PROJECT_NO',
// textFieldName:'PROJECT_NAME', validateBlank: false}),
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						orderNoSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						orderNoSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': orderNoSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.offerno" default="OFFER번호"/>',
			name		: 'OFFER_NO'
		},{
			fieldLabel	: '<t:message code="system.label.sales.inquiryclass" default="조회구분"/>',
			xtype		: 'uniRadiogroup',
			name		: 'RDO_TYPE',
			allowBlank	: false,
			width		: 235,
			items		: [
				{boxLabel:'<t:message code="system.label.sales.master" default="마스터"/>', name:'RDO_TYPE', inputValue:'master', checked:true},
				{boxLabel:'<t:message code="system.label.sales.detail" default="디테일"/>', name:'RDO_TYPE', inputValue:'detail'}
			],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue.RDO_TYPE=='detail') {
						if(orderNoMasterGrid) orderNoMasterGrid.hide();
						if(orderNoDetailGrid) orderNoDetailGrid.show();
					} else {
						if(orderNoDetailGrid) orderNoDetailGrid.hide();
						if(orderNoMasterGrid) orderNoMasterGrid.show();
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.remarks" default="비고"/>',
			xtype		: 'uniTextfield',
			name		: 'REMARK',
			width		: 325
		},
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			textFieldName	: 'PROJECT_NO',
			validateBlank	: false,
			textFieldWidth	: 150,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'BPARAM0': 3});
				}
			}
		})
		]
	}); // createSearchForm
	// 검색 모델(마스터)
	Unilite.defineModel('orderNoMasterModel', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'	, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string', comboType:'BOR120'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				, type: 'string'},
			{name: 'ORDER_DATE'			, text: '<t:message code="system.label.sales.sodate" default="수주일"/>'					, type: 'uniDate'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'					, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'				, type: 'string', comboType: 'AU', comboCode: 'S002'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'				, type: 'string', comboType: 'AU', comboCode: 'S010'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'PROJECT_NAME'		, text: '<t:message code="system.label.sales.projectname" default="프로젝트명"/>'			, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.sales.soqty" default="수주량"/>'					, type: 'uniQty'},
			{name: 'ORDER_O'			, text: '<t:message code="system.label.sales.soamount" default="수주액"/>'					, type: 'uniPrice'},
			{name: 'NATION_INOUT'		, text: '<t:message code="system.label.sales.domesticoverseasclass" default="국내외구분"/>'	, type: 'string'},
			{name: 'OFFER_NO'			, text: '<t:message code="system.label.sales.offerno" default="OFFER번호"/>'				, type: 'string'},
			{name: 'DATE_DELIVERY'		, text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'				, type: 'string'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.sales.currency" default="화폐"/>'					, type: 'string'},
			{name: 'EXCHANGE_RATE'		, text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'				, type: 'string'},
			{name: 'RECEIPT_SET_METH'	, text: '<t:message code="system.label.sales.receiptsetmeth" default="결제방법"/>'			, type: 'string'}
		]
	});
	// 검색 스토어(마스터)
	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {
		model	: 'orderNoMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sof100ukrvService.selectOrderNumMasterList'
			}
		},
		loadStoreRecords : function() {
			var param		= orderNoSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;			// 권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;			// 부서코드
			if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	// 검색 그리드(마스터)
	var orderNoMasterGrid = Unilite.createGrid('sof100ukrvOrderNoMasterGrid', {
		store	: orderNoMasterStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: false
		},
		selModel: 'rowmodel',
		columns	: [
			{dataIndex: 'DIV_CODE'		, width: 80},
			{dataIndex: 'CUSTOM_NAME'	, width: 150},
			{dataIndex: 'ORDER_DATE'	, width: 80},
			{dataIndex: 'ORDER_NUM'		, width: 120},
			{dataIndex: 'ORDER_TYPE'	, width: 80},
			{dataIndex: 'ORDER_PRSN'	, width: 80},
			{dataIndex: 'PROJECT_NO'	, width: 100},
			{dataIndex: 'PROJECT_NAME'	, width: 150},
			{dataIndex: 'ORDER_Q'		, width: 110},
			{dataIndex: 'ORDER_O'		, width: 120}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			masterForm.setValues({'DIV_CODE':record.get('DIV_CODE'), 'ORDER_NUM':record.get('ORDER_NUM')});
			panelResult.setValues({'DIV_CODE':record.get('DIV_CODE'), 'ORDER_NUM':record.get('ORDER_NUM')});
			CustomCodeInfo.gsAgentType		= record.get("AGENT_TYPE");
			CustomCodeInfo.gsCustCrYn		= record.get("CREDIT_YN");		// 원미만계산
			CustomCodeInfo.gsUnderCalBase	= record.get("WON_CALC_BAS");
			CustomCodeInfo.gsRefTaxInout	= record.get("TAX_TYPE");		// 세액포함여부
		}
	});
	// 검색 모델(디테일)
	Unilite.defineModel('orderNoDetailModel', {
		fields: [
			{name: 'DIV_CODE'		, text:'<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string'	, comboType:'BOR120'},
			{name: 'ITEM_CODE'		, text:'<t:message code="system.label.sales.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'		, text:'<t:message code="system.label.sales.itemname2" default="품명"/>'			, type: 'string'},
			{name: 'SPEC'			, text:'<t:message code="system.label.sales.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_DATE'		, text:'<t:message code="system.label.sales.sodate" default="수주일"/>'			, type: 'uniDate'},
			{name: 'DVRY_DATE'		, text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'		, type: 'uniDate'},
			{name: 'ORDER_Q'		, text:'<t:message code="system.label.sales.soqty" default="수주량"/>'				, type: 'uniQty'},
			{name: 'ORDER_TYPE'		, text:'<t:message code="system.label.sales.sellingtype" default="판매유형"/>'		, type: 'string'	, comboType:'AU', comboCode:'S002'},
			{name: 'ORDER_PRSN'		, text:'<t:message code="system.label.sales.salesperson" default="수주담당"/>'		, type: 'string'	, comboType:'AU', comboCode:'S010'},
			{name: 'PO_NUM'			, text:'<t:message code="system.label.sales.pono" default="PO번호"/>'	  			, type: 'string'},
			{name: 'PROJECT_NO'		, text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'PROJECT_NAME'	, text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>'		, type: 'string'},
			{name: 'ORDER_NUM'		, text:'<t:message code="system.label.sales.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'SER_NO'			, text:'<t:message code="system.label.sales.soseq" default="수주순번"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'	, text:'<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'	, text:'<t:message code="system.label.sales.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'PJT_CODE'		, text:'<t:message code="system.label.sales.projectcode" default="프로젝트코드"/>'	, type: 'string'},
			{name: 'PJT_NAME'		, text:'<t:message code="system.label.sales.project" default="프로젝트"/>'			, type: 'string'},
			{name: 'COMP_CODE'		, text:'COMP_CODE'		, type: 'string' },
			//20190306 추가
			{name: 'CARE_YN'		, text: 'CARE_YN'		, type: 'string'	, comboType: 'AU'   , comboCode: 'B010'},
			{name: 'CARE_REASON'	, text: 'CARE_REASON'	, type: 'string'}
		]
	});
	// 검색 스토어(디테일)
	var orderNoDetailStore = Unilite.createStore('orderNoDetailStore', {
		model	: 'orderNoDetailModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sof100ukrvService.selectOrderNumDetailList'
			}
		},
		loadStoreRecords : function() {
			var param		= orderNoSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;			// 권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;			// 부서코드
			if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	// 검색 그리드(디테일)
	var orderNoDetailGrid = Unilite.createGrid('sof100ukrvOrderNoDetailGrid', {
		store	: orderNoDetailStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: false
		},
		hidden	: true,
		columns	: [
			{dataIndex: 'DIV_CODE'		, width: 80},
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 150},
			{dataIndex: 'SPEC'			, width: 150},
			{dataIndex: 'ORDER_DATE'	, width: 80},
			{dataIndex: 'DVRY_DATE'		, width: 80		, hidden:true},
			{dataIndex: 'ORDER_Q'		, width: 80},
			{dataIndex: 'ORDER_TYPE'	, width: 90},
			{dataIndex: 'ORDER_PRSN'	, width: 90		, hidden:true},
			{dataIndex: 'PO_NUM'		, width: 100},
			{dataIndex: 'PROJECT_NO'	, width: 100},
			{dataIndex: 'PROJECT_NAME'	, width: 120},
			{dataIndex: 'ORDER_NUM'		, width: 120},
			{dataIndex: 'SER_NO'		, width: 70		, hidden:true},
			{dataIndex: 'CUSTOM_CODE'	, width: 120},
			{dataIndex: 'CUSTOM_NAME'	, width: 200},
			{dataIndex: 'COMP_CODE'		, width: 80		, hidden:true},
			{dataIndex: 'PJT_CODE'		, width: 120	, hidden:true},
			{dataIndex: 'PJT_NAME'		, width: 200	, hidden:true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				orderNoDetailGrid.returnData(record)
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			masterForm.uniOpt.inLoading=true;
			masterForm.setValues({'DIV_CODE':record.get('DIV_CODE'), 'ORDER_NUM':record.get('ORDER_NUM')});
			panelResult.setValues({'DIV_CODE':record.get('DIV_CODE'), 'ORDER_NUM':record.get('ORDER_NUM')});
			masterForm.uniOpt.inLoading=false;
		}
	});
	// openSearchInfoWindow (검색 메인)
	function openSearchInfoWindow() {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.sonosearch" default="수주번호검색"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [orderNoSearch, orderNoMasterGrid, orderNoDetailGrid],
				tbar	: ['->', {
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						var rdoType = orderNoSearch.getValue('RDO_TYPE');
						console.log('rdoType : ',rdoType)
						if(rdoType.RDO_TYPE=='master') {
							orderNoMasterStore.loadStoreRecords();
						} else {
							orderNoDetailStore.loadStoreRecords();
						}
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
						orderNoDetailGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
						orderNoDetailGrid.reset();
					},
					show: function( panel, eOpts ) {
						var field = orderNoSearch.getField('ORDER_PRSN');
						field.fireEvent('changedivcode', field, masterForm.getValue('DIV_CODE'), null, null, "DIV_CODE");
						orderNoSearch.setValue('DIV_CODE'		, masterForm.getValue('DIV_CODE'));
						orderNoSearch.setValue('CUSTOM_CODE'	, masterForm.getValue('CUSTOM_CODE'));
						orderNoSearch.setValue('CUSTOM_NAME'	, masterForm.getValue('CUSTOM_NAME'));
						orderNoSearch.setValue('FR_ORDER_DATE'	, UniDate.get('startOfMonth', masterForm.getValue('ORDER_DATE')));
						orderNoSearch.setValue('TO_ORDER_DATE'	, masterForm.getValue('ORDER_DATE'));
						orderNoSearch.setValue('DEPT_CODE'		, masterForm.getValue('DEPT_CODE'));
						orderNoSearch.setValue('DEPT_NAME'		, masterForm.getValue('DEPT_NAME'));
						//orderNoSearch.setValue('ORDER_TYPE',masterForm.getValue('ORDER_TYPE'));
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}




	/** 사업장별 영업담당 정보
	 */
	var divPrsnStore = Unilite.createStore('SOF100UKRV_DIV_PRSN', {
		fields	: ["value","text","option"],
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'salesCommonService.fnRecordCombo'
			}
		},
		listeners: {
			load: function( store, records, successful, eOpts ) {
				console.log("영업담당 store",this);
				if(successful) {
					estimateSearch.setValue('ESTI_PRSN', masterForm.getValue('ORDER_PRSN'));
				}
			}
		},
		loadStoreRecords: function() {
			var param= {
				'COMP_CODE'	: UserInfo.compCode,
				'MAIN_CODE'	: 'S010',
				'DIV_CODE'	: masterForm.getValue('DIV_CODE'),
				'TYPE'		: 'DIV_PRSN'
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});




	/** 견적을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	var estimateSearch = Unilite.createSearchForm('estimateForm', {
		layout	: {type : 'uniTable', columns : 2},
		items	: [
		Unilite.popup('AGENT_CUST',{
			fieldLabel		:'<t:message code="system.label.sales.estimateplace" default="견적처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						estimateSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						estimateSearch.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.estimateno" default="견적번호"/>',
			name		: 'ESTI_NUM'
		},{
			fieldLabel		: '<t:message code="system.label.sales.estimatedate" default="견적일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_ESTI_DATE',
			endFieldName	: 'TO_ESTI_DATE',
			width			: 350,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today')
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'ESTI_PRSN',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('SOF100UKRV_DIV_PRSN')
		}]
	});
	// 견적참조 모델
	Unilite.defineModel('sof100ukrvESTIModel', {
		fields: [
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.sales.estimateplace" default="견적처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.estimateplacename" default="견적처명"/>'		, type: 'string'},
			{name: 'ESTI_DATE'		, text: '<t:message code="system.label.sales.estimatedate" default="견적일"/>'				, type: 'uniDate'},
			{name: 'ESTI_NUM'		, text: '<t:message code="system.label.sales.estimateno" default="견적번호"/>'				, type: 'string'},
			{name: 'ESTI_SEQ'		, text: '<t:message code="system.label.sales.seq" default="순번"/>'						, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname2" default="품명"/>'					, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.sales.spec" default="규격"/>'						, type: 'string'},
			{name: 'ESTI_UNIT'		, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'				, type: 'string'},
			{name: 'TRANS_RATE'		, text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				, type: 'string'},
			{name: 'ESTI_QTY'		, text: '<t:message code="system.label.sales.estimateqty" default="견적수량"/>'				, type: 'uniQty'},
			{name: 'ESTI_PRICE'		, text: '<t:message code="system.label.sales.estimateprice" default="견적단가"/>'			, type: 'uniUnitPrice'},
			{name: 'ESTI_AMT'		, text: '<t:message code="system.label.sales.estimateamount" default="견적금액"/>'			, type: 'uniPrice'},
			{name: 'ESTI_TAX_AMT'	, text: '<t:message code="system.label.sales.estimatetaxamount" default="견적세액"/>'		, type: 'uniPrice'},
			{name: 'TAX_TYPE'		, text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'			, type: 'string'},
			{name: 'MONEY_UNIT'		, text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'			, type: 'string'},
			{name: 'EXCHANGE_RATE'	, text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'				, type: 'string'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.sales.warehousecode" default="창고코드"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'			, type: 'string'},
			{name: 'STOCK_CARE_YN'	, text: '<t:message code="system.label.sales.inventorymanagementyn" default="재고관리여부"/>'	, type: 'string'},
			{name: 'ITEM_ACCOUNT'	, text: 'ITEM_ACCOUNT'	, type: 'string'},
			//20190306 추가
			{name: 'CARE_YN'		, text: 'CARE_YN'		, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'CARE_REASON'	, text: 'CARE_REASON'	, type: 'string'}
		]
	});
	// 견적참조 스토어
	var estimateStore = Unilite.createStore('sof100ukrvEstiStore', {
		model	: 'sof100ukrvESTIModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'sof100ukrvService.selectEstiList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords	= detailStore.data.filterBy(detailStore.filterNewOnly);
					var estiRecords		= new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								if((record.data['ESTI_NUM'] == item.data['ESTI_NUM']) && (record.data['ESTI_SEQ'] == item.data['ESTI_SEQ'])) {
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
			var param= estimateSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	// 견적참조 그리드
	var estimateGrid = Unilite.createGrid('sof100ukrvEstimateGrid', {
		store	: estimateStore,
		layout	: 'fit',
		selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt	: {
			onLoadSelectFirst : false
		},
		columns	: [
			{ dataIndex: 'CUSTOM_NAME',		width: 150},
			{ dataIndex: 'ESTI_DATE',		width: 110},
			{ dataIndex: 'ESTI_NUM',		width: 140},
			{ dataIndex: 'ESTI_SEQ',		width: 60 },
			{ dataIndex: 'ITEM_CODE',		width: 110},
			{ dataIndex: 'ITEM_NAME',		width: 150},
			{ dataIndex: 'SPEC',			width: 150},
			{ dataIndex: 'ESTI_UNIT',		width: 90 },
			{ dataIndex: 'TRANS_RATE',		width: 60 },
			{ dataIndex: 'ESTI_QTY',		width: 120},
			{ dataIndex: 'ESTI_PRICE',		width: 110},
			{ dataIndex: 'ESTI_AMT',		width: 100},
			{ dataIndex: 'ESTI_TAX_AMT',	width: 50 , hidden: true},
			{ dataIndex: 'TAX_TYPE',		width: 50 , hidden: true},
			{ dataIndex: 'MONEY_UNIT',		width: 50 , hidden: true},
			{ dataIndex: 'EXCHANGE_RATE',	width: 50 , hidden: true},
			{ dataIndex: 'WH_CODE',			width: 50 , hidden: true},
			{ dataIndex: 'STOCK_UNIT',		width: 50 , hidden: true},
			{ dataIndex: 'STOCK_CARE_YN',	width: 50 , hidden: true},
			{ dataIndex: 'ITEM_ACCOUNT',	width: 50 , hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown2();
				detailGrid.setEstiData(record.data);
			});
			// this.deleteSelectedRow();
			this.getStore().remove(records);
		}
	});
	// 견적참조 메인
	function openEstimateWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		estimateSearch.setValue('CUSTOM_CODE'	, masterForm.getValue('CUSTOM_CODE'));
		estimateSearch.setValue('CUSTOM_NAME'	, masterForm.getValue('CUSTOM_NAME'));
		estimateSearch.setValue('FR_ESTI_DATE'	, UniDate.get('startOfMonth', masterForm.getValue('ORDER_DATE')) );
		estimateSearch.setValue('TO_ESTI_DATE'	, masterForm.getValue('ORDER_DATE'));
		divPrsnStore.loadStoreRecords(); // 사업장별 영업사원 콤보
		if(!referEstimateWindow) {
			referEstimateWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.estimatereference" default="견적참조"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [estimateSearch, estimateGrid],
				tbar	: ['->', {
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						estimateStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.soapply" default="수주적용"/>',
					handler	: function() {
						estimateGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.sales.soapplyclose" default="수주적용후 닫기"/>',
					handler	: function() {
						estimateGrid.returnData();
						referEstimateWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						if(detailStore.getCount() == 0){
							masterForm.setAllFieldsReadOnly(false);
							panelResult.setAllFieldsReadOnly(false);
						}
						referEstimateWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						// estimateSearch.clearForm();
						// estimateGrid,reset();
					},
					beforeclose: function( panel, eOpts ) {
						// estimateSearch.clearForm();
						// estimateGrid,reset();
					},
					beforeshow: function ( me, eOpts ) {
						estimateStore.loadStoreRecords();
					}
				}
			})
		}
		referEstimateWindow.center();
		referEstimateWindow.show();
	}




	/** 수주이력을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	var refSearch = Unilite.createSearchForm('RefSForm', {
		layout	: {type : 'uniTable', columns : 3},
		items	:[
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.soplace" default="수주처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						refSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						refSearch.setValue('CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}}),
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							refSearch.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							refSearch.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel		: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_ORDER_DATE',
				endFieldName	: 'TO_ORDER_DATE',
				width			: 350,
				startDate		: UniDate.getDateStr(Ext.Date.add(UniDate.today(),Ext.Date.DAY,-365)), //1년전
				endDate			: UniDate.get('today')
			},{
				fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name		: 'ORDER_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					} else {
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.lasthistory" default="최근이력"/>',
				name		: 'RDO_YN',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'B131',
				width		: 230,
				allowBlank	: false,
				value		: 'Y'
			},{
				fieldLabel		: '납기일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_DVRY_DATE',
				endFieldName	: 'TO_DVRY_DATE',
				startDate		: '',
				endDate			: ''
			}
		]
	});
	// 수주이력 모델
	Unilite.defineModel('sof100ukrvRefModel', {
		fields: [
			{ name: 'CUSTOM_CODE'		, text:'<t:message code="system.label.sales.soplace" default="수주처"/>'			, type : 'string'},
			{ name: 'CUSTOM_NAME'		, text:'<t:message code="system.label.sales.soplacename" default="수주처명"/>'		, type : 'string'},
			{ name: 'ORDER_DATE'		, text:'<t:message code="system.label.sales.sodate" default="수주일"/>'			, type : 'string'},
			{ name: 'ORDER_NUM'			, text:'<t:message code="system.label.sales.sono" default="수주번호"/>'				, type : 'string'},
			{ name: 'SER_NO'			, text:'<t:message code="system.label.sales.seq" default="순번"/>'				, type : 'int'},
			{ name: 'ITEM_CODE'			, text:'<t:message code="system.label.sales.itemcode" default="품목코드"/>'			, type : 'string'},
			{ name: 'ITEM_NAME'			, text:'<t:message code="system.label.sales.itemname2" default="품명"/>'			, type : 'string'},
			{ name: 'SPEC'				, text:'<t:message code="system.label.sales.spec" default="규격"/>'				, type : 'string'},
			{ name: 'ORDER_UNIT'		, text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'		, type : 'string', comboType:'AU', comboCode:'B013'},
			{ name: 'TRANS_RATE'		, text:'<t:message code="system.label.sales.containedqty" default="입수"/>'		, type : 'uniQty'},
			{ name: 'ORDER_Q'			, text:'<t:message code="system.label.sales.soqty" default="수주량"/>'				, type : 'uniQty'},
			{ name: 'ORDER_P'			, text:'<t:message code="system.label.sales.eachprice" default="개별단가"/>'		, type : 'uniUnitPrice'},
			{ name: 'ORDER_WGT_Q'		, text:'<t:message code="system.label.sales.soqtyweight" default="수주량(중량)"/>'	, type : 'uniQty'},
			{ name: 'ORDER_WGT_P'		, text:'<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'	, type : 'uniUnitPrice'},
			{ name: 'ORDER_VOL_Q'		, text:'<t:message code="system.label.sales.soqtyvolumn" default="수주량(부피)"/>'	, type : 'uniQty'},
			{ name: 'ORDER_VOL_P'		, text:'<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'	, type : 'uniUnitPrice'},
			{ name: 'ORDER_O'			, text:'<t:message code="system.label.sales.amount" default="금액"/>'				, type : 'uniPrice'},
			{ name: 'REMARK'			, text:'<t:message code="system.label.sales.remarks" default="비고"/>'			, type : 'string'},
			{ name: 'ORDER_TAX_O'		, text:'ORDER_TAX_O'	, type : 'uniPrice'},
			{ name: 'TAX_TYPE'			, text:'TAX_TYPE'		, type : 'string'},
			{ name: 'DIV_CODE'			, text:'DIV_CODE'		, type : 'string'},
			{ name: 'OUT_DIV_CODE'		, text:'OUT_DIV_CODE'	, type : 'string'},
			{ name: 'ACCOUNT_YNC'		, text:'ACCOUNT_YNC'	, type : 'string'},
			{ name: 'SALE_CUST_CD'		, text:'SALE_CUST_CD'	, type : 'string'},
			{ name: 'SALE_CUST_NM'		, text:'SALE_CUST_NM'	, type : 'string'},
			{ name: 'PRICE_YN'			, text:'PRICE_YN'		, type : 'string'},
			{ name: 'STOCK_Q'			, text:'STOCK_Q'		, type : 'string'},
			{ name: 'DVRY_CUST_CD'		, text:'DVRY_CUST_CD'	, type : 'string'},
			{ name: 'DVRY_CUST_NAME'	, text:'DVRY_CUST_NAME'	, type : 'string'},
			{ name: 'STOCK_UNIT'		, text:'STOCK_UNIT'		, type : 'string'},
			{ name: 'WH_CODE'			, text:'WH_CODE'		, type : 'string'},
			{ name: 'STOCK_CARE_YN'		, text:'STOCK_CARE_YN'	, type : 'string'},
			{ name: 'DISCOUNT_RATE'		, text:'DISCOUNT_RATE'	, type : 'string'},
			{ name: 'ITEM_ACCOUNT'		, text:'ITEM_ACCOUNT'	, type : 'string'},
			{ name: 'PRICE_TYPE'		, text:'PRICE_TYPE'		, type : 'string'},
			{ name: 'WGT_UNIT'			, text:'WGT_UNIT'		, type : 'string'},
			{ name: 'UNIT_WGT'			, text:'UNIT_WGT'		, type : 'string'},
			{ name: 'VOL_UNIT'			, text:'VOL_UNIT'		, type : 'string'},
			{ name: 'UNIT_VOL'			, text:'UNIT_VOL'		, type : 'string'},
			{ name: 'SO_KIND'			, text:'SO_KIND'		, type : 'string'},
			//20190306 추가
			{name: 'CARE_YN'			, text: 'CARE_YN'		, type: 'string'	, comboType: 'AU'   , comboCode: 'B010'},
			{name: 'CARE_REASON'		, text: 'CARE_REASON'	, type: 'string'}
		]
	});
	// 수주이력 스토어
	var refStore = Unilite.createStore('sof100ukrvRefStore', {
		model	: 'sof100ukrvRefModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'sof100ukrvService.selectRefList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords	= detailStore.data.filterBy(detailStore.filterNewOnly);
					var estiRecords		= new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								if((record.data['ORDER_NUM'] == item.data['ORDER_NUM']) && (record.data['ESTI_SEQ'] == item.data['ESTI_SEQ'])) {
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
			var param= refSearch.getValues();
			//2021-08-18 수주이력참조조회시 masterForm의 사업장 조건 추가함
			param.DIV_CODE = masterForm.getValue("DIV_CODE");
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	// 수주이력 그리드
	var refGrid = Unilite.createGrid('sof100ukrvRefGrid', {
		store	: refStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt	: {
			onLoadSelectFirst : false,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		columns:  [
			{ dataIndex: 'CUSTOM_CODE',		width: 50 , hidden:true},
			{ dataIndex: 'CUSTOM_NAME',		width: 110},
			{ dataIndex: 'ORDER_DATE',		width: 80 },
			{ dataIndex: 'ORDER_NUM',		width: 100},
			{ dataIndex: 'SER_NO',			width: 60 },
			{ dataIndex: 'ITEM_CODE',		width: 00 },
			{ dataIndex: 'ITEM_NAME',		width: 110},
			{ dataIndex: 'SPEC',			width: 130},
			{ dataIndex: 'ORDER_UNIT',		width: 80 , align: 'center'},
			{ dataIndex: 'TRANS_RATE',		width: 60 },
			{ dataIndex: 'ORDER_Q',			width: 90 },
			{ dataIndex: 'ORDER_P',			width: 80 },
			{ dataIndex: 'ORDER_WGT_Q',		width: 90 , borderColor:'red', hidden:true},
			{ dataIndex: 'ORDER_WGT_P',		width: 90 , hidden:true},
			{ dataIndex: 'ORDER_VOL_Q',		width: 90 , hidden:true},
			{ dataIndex: 'ORDER_VOL_P',		width: 90 , hidden:true},
			{ dataIndex: 'ORDER_O',			width: 90 },
			{ dataIndex: 'REMARK',			width: 100},
			{ dataIndex: 'ORDER_TAX_O',		width: 50 , hidden:true},
			{ dataIndex: 'TAX_TYPE',		width: 50 , hidden:true},
			{ dataIndex: 'DIV_CODE',		width: 50 , hidden:true},
			{ dataIndex: 'OUT_DIV_CODE',	width: 50 , hidden:true},
			{ dataIndex: 'ACCOUNT_YNC',		width: 50 , hidden:true},
			{ dataIndex: 'SALE_CUST_CD',	width: 50 , hidden:true},
			{ dataIndex: 'SALE_CUST_NM',	width: 50 , hidden:true},
			{ dataIndex: 'PRICE_YN',		width: 50 , hidden:true},
			{ dataIndex: 'STOCK_Q',			width: 50 , hidden:true},
			{ dataIndex: 'DVRY_CUST_CD',	width: 50 , hidden:true},
			{ dataIndex: 'DVRY_CUST_NAME',	width: 50 , hidden:true},
			{ dataIndex: 'STOCK_UNIT',		width: 50 , hidden:true},
			{ dataIndex: 'WH_CODE',			width: 50 , hidden:true},
			{ dataIndex: 'STOCK_CARE_YN',	width: 50 , hidden:true},
			{ dataIndex: 'DISCOUNT_RATE',	width: 50 , hidden:true},
			{ dataIndex: 'ITEM_ACCOUNT',	width: 50 , hidden:true},
			{ dataIndex: 'PRICE_TYPE',		width: 50 , hidden:true},
			{ dataIndex: 'WGT_UNIT',		width: 50 , hidden:true},
			{ dataIndex: 'UNIT_WGT',		width: 50 , hidden:true},
			{ dataIndex: 'VOL_UNIT',		width: 50 , hidden:true},
			{ dataIndex: 'UNIT_VOL',		width: 50 , hidden:true},
			{ dataIndex: 'SO_KIND',			width: 50 , hidden:true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown2();
				detailGrid.setRefData(record.data);
			});
			this.getStore().remove(records);
		}
	});
	// 수주이력 메인
	function openRefWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		var field = refSearch.getField('ORDER_PRSN');
		field.fireEvent('changedivcode'		, field, masterForm.getValue('DIV_CODE'), null, null, "DIV_CODE");
		refSearch.setValue('CUSTOM_CODE'	, masterForm.getValue('CUSTOM_CODE'));
		refSearch.setValue('CUSTOM_NAME'	, masterForm.getValue('CUSTOM_NAME'));

		if(!referOrderRecordWindow) {
			referOrderRecordWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.sohistoryrefer" default="수주이력참조"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [refSearch, refGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						refStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.soapply" default="수주적용"/>',
					handler	: function() {
						refGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.sales.soapplyclose" default="수주적용후 닫기"/>',
					handler	: function() {
						refGrid.returnData();
						referOrderRecordWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						if(detailStore.getCount() == 0){
							masterForm.setAllFieldsReadOnly(false);
							panelResult.setAllFieldsReadOnly(false);
						}
						referOrderRecordWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						// refSearch.clearForm();
						// refGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						// RefSearch.clearForm();
						// refGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						refStore.loadStoreRecords();
					}
				}
			})
		}
		referOrderRecordWindow.center();
		referOrderRecordWindow.show();
	}



	/** 출하예정 참조하기 위한 Search Form, Grid, Inner Window 정의 - 20191231 추가
	 */
	var reqSearch = Unilite.createSearchForm('ReQForm', {
		layout	: {type : 'uniTable', columns : 3},
		items	:[
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.soplace" default="수주처"/>',
			validateBlank	: false,
			readOnly		: true,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}}),
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							reqSearch.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							reqSearch.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel		: '<t:message code="system.label.sales.estimatedshipmentdate" default="출하예정일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_ISSUE_PLAN_DATE',
				endFieldName	: 'TO_ISSUE_PLAN_DATE',
				width			: 350,
				startDate		: UniDate.get('tomorrow'),
				endDate			: UniDate.get('tomorrow')
			},{
				fieldLabel	: 'DIV_CODE',
				name		: 'DIV_CODE',
				xtype		: 'uniTextfield',
				hidden		: true
			}
		]
	});
	// 출하예정 모델
	Unilite.defineModel('sof100ukrvReqModel', {
		fields: [
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string'	, comboType: 'BOR120', defaultValue: UserInfo.divCode},
			{name: 'ISSUE_PLAN_NUM'	, text: '<t:message code="system.label.sales.estimatedshipmentno" default="출하예정번호"/>'	, type: 'string'	, editable: false},
			{name: 'ISSUE_PLAN_DATE', text: '<t:message code="system.label.sales.estimatedshipmentdate" default="출하예정일"/>'	, type: 'uniDate'	, allowBlank: false},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'	, allowBlank: false},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				, type: 'string'	, allowBlank: false},
			{name: 'DVRY_CUST_CD'	, text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			, type: 'string'	, allowBlank: false},
			{name: 'DVRY_CUST_NAME'	, text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			, type: 'string'	, allowBlank: false},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.sales.itemnamespec" default="품명(규격)"/>'			, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.sales.unit" default="단위"/>'						, type: 'string'	, comboType: 'AU', comboCode: 'B013', displayField: 'value'},
			{name: 'ISSUE_PLAN_QTY'	, text: '<t:message code="system.label.sales.estimatedshipment" default="출하예정량"/>'		, type: 'uniQty'},
			{name: 'BOX_TYPE'		, text: '<t:message code="system.label.sales.boxtype" default="BOX 종류"/>'				, type: 'string'	, comboType: 'AU', comboCode: 'B139', displayField: 'value'},
			{name: 'TRNS_RATE'		, text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				, type: 'float'		, decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'BOX_QTY'		, text: '<t:message code="system.label.sales.boxqty2" default="용기수"/>'					, type: 'int'},
			{name: 'CAR_TYPE'		, text: '<t:message code="system.label.common.cartype" default="차종"/>'					, type: 'string'	, comboType: 'AU', comboCode: 'WB04'},	//BPR100T.CAR_TYPE
			{name: 'LABEL_INDEX'	, text: '<t:message code="system.label.sales.componentidentifier" default="부품식별표"/>'	, type: 'string'},
			{name: 'REMARK'			, text: '<t:message code="system.label.sales.remarks" default="비고"/>'					, type: 'string'},
			{name: 'ORDER_YN'		, text: 'ORDER_YN'		, type: 'string'},
			{name: 'DATA_KIND'		, text: 'DATA_KIND'		, type: 'string'},
			{name: 'ORDER_P'		, text: '<t:message code="system.label.sales.eachprice" default="개별단가"/>'		, type : 'uniUnitPrice'},
			{name: 'ORDER_O'		, text: '<t:message code="system.label.sales.amount" default="금액"/>'				, type : 'uniPrice'},
			{name: 'ORDER_TAX_O'	, text: 'ORDER_TAX_O'	, type: 'uniPrice'},
			{name: 'STOCK_UNIT'		, text: 'STOCK_UNIT'	, type: 'string'},
			{name: 'WH_CODE'		, text: 'WH_CODE'		, type: 'string'},
			{name: 'STOCK_CARE_YN'	, text: 'STOCK_CARE_YN'	, type: 'string'},
			{name: 'ITEM_ACCOUNT'	, text: 'ITEM_ACCOUNT'	, type: 'string'},
			{name: 'WGT_UNIT'		, text: 'WGT_UNIT'		, type: 'string'},
			{name: 'UNIT_WGT'		, text: 'UNIT_WGT'		, type: 'string'},
			{name: 'VOL_UNIT'		, text: 'VOL_UNIT'		, type: 'string'},
			{name: 'UNIT_VOL'		, text: 'UNIT_VOL'		, type: 'string'},
			{name: 'CARE_YN'		, text: 'CARE_YN'		, type: 'string'	, comboType: 'AU'   , comboCode: 'B010'},
			{name: 'CARE_REASON'	, text: 'CARE_REASON'	, type: 'string'},
			{name: 'TAX_TYPE'		, text: 'TAX_TYPE'		, type: 'string'},
			{name: 'BILL_CUSTOM'	, text: 'BILL_CUSTOM'	, type: 'string'}
		]
	});
	// 출하예정 스토어
	var reqStore = Unilite.createStore('sof100ukrvReqStore', {
		model	: 'sof100ukrvReqModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'sof100ukrvService.selectRefReqList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords	= detailStore.data.filterBy(detailStore.filterNewOnly);
					var estiRecords		= new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								if((record.data['DIV_CODE'] == item.data['DIV_CODE'])
									//20200121 수정
									&& (UniDate.getDateStr(record.data['ISSUE_PLAN_NUM']) == UniDate.getDateStr(item.data['ISSUE_PLAN_NUM']))
//									&& (UniDate.getDateStr(record.data['ISSUE_PLAN_DATE']) == UniDate.getDateStr(item.data['ISSUE_PLAN_DATE']))
//									&& (record.data['SALE_CUST_CD']  == item.data['CUSTOM_CODE'])
//									&& (record.data['DVRY_CUST_CD']  == item.data['DVRY_CUST_CD'])
//									&& (record.data['ITEM_CODE']  == item.data['ITEM_CODE'])
								) {
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
			var param		= reqSearch.getValues();
			param.BILL_TYPE	= masterForm.getValue('BILL_TYPE');
			param.TAX_INOUT	= masterForm.getValue('TAX_INOUT').TAX_INOUT;
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	// 출하예정 그리드
	var reqGrid = Unilite.createGrid('sof100ukrvReqGrid', {
		store	: reqStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt	: {
			expandLastColumn	: true,
			onLoadSelectFirst	: false
		},
		columns:  [
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'ISSUE_PLAN_NUM'	, width: 100	, hidden: true},
			{dataIndex: 'ISSUE_PLAN_DATE'	, width: 100	, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 110},
			{dataIndex: 'CUSTOM_NAME'		, width: 150},
			{dataIndex: 'DVRY_CUST_CD'		, width: 110	, hidden: true},
			{dataIndex: 'DVRY_CUST_NAME'	, width: 110},
			{dataIndex: 'ITEM_CODE'			, width: 110},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'SPEC'				, width: 130},
			{dataIndex: 'ORDER_UNIT'		, width: 80		, align: 'center'},
			{dataIndex: 'ISSUE_PLAN_QTY'	, width: 100},
			{dataIndex: 'BOX_TYPE'			, width: 80		, hidden: true},
			{dataIndex: 'TRNS_RATE'			, width: 80		, hidden: true},
			{dataIndex: 'BOX_QTY'			, width: 80		, hidden: true},
			{dataIndex: 'CAR_TYPE'			, width: 100	, hidden: true},
			{dataIndex: 'LABEL_INDEX'		, width: 100	, hidden: true},
			{dataIndex: 'REMARK'			, width: 120},
			{dataIndex: 'ORDER_YN'			, width: 80		, hidden: true},
			{dataIndex: 'DATA_KIND'			, width: 80		, hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown2();
				detailGrid.setReqData(record.data);
			});
			this.getStore().remove(records);
		}
	});
	// 출하예정 메인
	function openReqWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		reqSearch.setValue('CUSTOM_CODE'	, masterForm.getValue('CUSTOM_CODE'));
		reqSearch.setValue('CUSTOM_NAME'	, masterForm.getValue('CUSTOM_NAME'));
		reqSearch.setValue('DIV_CODE'		, masterForm.getValue('DIV_CODE'));

		if(!referExpectedReqWindow) {
			referExpectedReqWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.referenceestimatedshipment" default="출하예정참조"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [reqSearch, reqGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						reqStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.soapply" default="수주적용"/>',
					handler	: function() {
						reqGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.sales.soapplyclose" default="수주적용후 닫기"/>',
					handler	: function() {
						reqGrid.returnData();
						referExpectedReqWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						if(detailStore.getCount() == 0){
							masterForm.setAllFieldsReadOnly(false);
							panelResult.setAllFieldsReadOnly(false);
						}
						referExpectedReqWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						// reqSearch.clearForm();
						// reqGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						// reqSearch.clearForm();
						// reqGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						reqStore.loadStoreRecords();
					}
				}
			})
		}
		referExpectedReqWindow.center();
		referExpectedReqWindow.show();
	}


	// 엑셀참조
	Unilite.Excel.defineModel('excel.sof100.sheet01', {
		fields: [
			{name: 'ITEM_CODE'			, text:'<t:message code="system.label.sales.itemcode" default="품목코드"/>'						, type: 'string'},
			{name: 'QTY'				, text:'<t:message code="system.label.sales.sellingqty" default="판매수량"/>'					, type: 'uniQty'},
			{name: 'ITEM_NAME'			, text:'<t:message code="system.label.sales.itemname" default="품목명"/>'						, type: 'string'},
			{name: 'SPEC'				, text:'<t:message code="system.label.sales.spec" default="규격"/>'							, type: 'string'},
			{name: 'ORDER_P'			, text:'<t:message code="system.label.sales.sellingprice" default="판매단가"/>'					, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT'			, text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'					, type: 'string'},
			{name: 'TRNS_RATE'			, text:'<t:message code="system.label.sales.containedqty" default="입수"/>'					, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text:'<t:message code="system.label.sales.itemaccount" default="품목계정"/>'					, type: 'string'},
			{name: 'OUT_WH_CODE'		, text:'<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'				, type: 'string'},
			{name: 'WH_CODE'			, text:'<t:message code="system.label.sales.mainwarehouse" default="주창고"/>'					, type: 'string'},

			{name: 'DVRY_CUST_CD'			, text:'<t:message code="system.label.sales.deliveryplacecode" default="배송처코드"/>'					, type: 'string'},
			{name: 'DVRY_CUST_NM'			, text:'<t:message code="system.label.sales.deliveryplacename" default="배송처명"/>'					, type: 'string'},

			{name: 'ORDER_O'			, text:'<t:message code="system.label.sales.amount" default="금액"/>'							, type: 'uniPrice'},
			{name: 'ORDER_TAX_O'		, text:'<t:message code="system.label.sales.vatamount" default="부가세액"/>'					, type: 'uniPrice'},
			{name: 'ORDER_O_TAX_O'		, text:'<t:message code="system.label.sales.salesordertotal" default="수주계"/>'				, type: 'uniPrice'},
			{name: 'STOCK_UNIT'			, text:'<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'				, type: 'string'},
			{name: 'STOCK_CARE_YN'		, text:'<t:message code="system.label.sales.inventorymanageobjectyn" default="재고관리대상여부"/>'	, type: 'string'},
			{name: 'WGT_UNIT'			, text:'<t:message code="system.label.sales.weightunit" default="중량단위"/>'					, type: 'string'},
			{name: 'UNIT_WGT'			, text:'<t:message code="system.label.sales.unitweight" default="단위중량"/>'					, type: 'string'},
			{name: 'VOL_UNIT'			, text:'<t:message code="system.label.sales.volumnunit" default="부피단위"/>'					, type: 'string'},
			{name: 'UNIT_VOL'			, text:'<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'					, type: 'string'},
			{name: 'DVRY_DATE'			, text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'					, type: 'string'},
			{name: 'REMARK'				, text:'<t:message code="system.label.sales.remarks" default="비고"/>'						, type: 'string'},
			{name: 'REMARK_INTER'		, text:'<t:message code="system.label.sales.remarkinter" default="내부기록사항"/>'				, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	, text:'<t:message code="system.label.sales.salestype" default="매출유형"/>'					, type: 'string' , comboType: 'AU', comboCode: 'S007', allowBlank:false},
			//20190306 추가
			{name: 'CARE_YN'			, text: 'CARE_YN'		, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'CARE_REASON'		, text: 'CARE_REASON'	, type: 'string'},
			//20190725 고객명(RECEIVER_NAME), 송장번호(INVOICE_NUM) 추가
			{name: 'RECEIVER_NAME'		, text: '<t:message code="system.label.sales.clientname" default="고객명"/>'					, type: 'string'},
			{name: 'INVOICE_NUM'		, text: '<t:message code="system.label.sales.invoice" default="송장번호"/>'						, type: 'string'}
		]
	});
	function openExcelWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUploadWin';
		if(!excelWindow) {
			excelWindow =  Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				modal: false,
				excelConfigName: excelConNm, //2020.03.13 극동 엑셀업로드를 위한 변수처리
				extParam: {
					'DIV_CODE'				: masterForm.getValue('DIV_CODE'),
					'CUSTOM_CODE'			: masterForm.getValue('CUSTOM_CODE'),
					'MONEY_UNIT'			: masterForm.getValue('MONEY_UNIT'),
					'ORDER_DATE'			: UniDate.getDateStr( masterForm.getValue('ORDER_DATE')),
					'AGENT_TYPE'			: CustomCodeInfo.gsAgentType,
					'GS_INOUT_DETAIL_TYPE'	: gsInoutDetailType
				},
				grids: [{
					itemId		: 'grid01',
					title		: '<t:message code="system.label.sales.soinfo" default="수주정보"/>',
					useCheckbox	: true,
					model		: 'excel.sof100.sheet01',
					readApi		: 'sof100ukrvService.selectExcelUploadSheet1',
					columns		: [
						{ dataIndex: 'INOUT_TYPE_DETAIL',	width: 80	},
						{ dataIndex: 'ITEM_CODE',			width: 120	},
						{ dataIndex: 'QTY',					width: 80	},
						{ dataIndex: 'ITEM_NAME',			width: 120	},
						{ dataIndex: 'SPEC',				width: 120	},
						{ dataIndex: 'ORDER_P',				width: 80	},
						{ dataIndex: 'ORDER_UNIT',			width: 80	, align: 'center'},
						{ dataIndex: 'TRNS_RATE',			width: 80	},
						{ dataIndex: 'ITEM_ACCOUNT',		width: 100	},
						{ dataIndex: 'OUT_WH_CODE',			width: 100	},
						{ dataIndex: 'WH_CODE',				width: 100	},
						{ dataIndex: 'DVRY_CUST_CD',		width: 100	},
						{ dataIndex: 'DVRY_CUST_NM',		width: 100	},
						{ dataIndex: 'ORDER_O',				width: 80	},
						{ dataIndex: 'ORDER_TAX_O',			width: 80	},
						{ dataIndex: 'ORDER_O_TAX_O',		width: 80	},
						{ dataIndex: 'DVRY_DATE',			width: 80	},
						{ dataIndex: 'REMARK',				width: 200	},
						{ dataIndex: 'REMARK_INTER',		width: 200	},
						{ dataIndex: 'RECEIVER_NAME',		width: 150	},
						{ dataIndex: 'INVOICE_NUM',			width: 120	}
					],
					listeners: {
						afterrender: function(grid) {
							var me = this;
							this.contextMenu = Ext.create('Ext.menu.Menu', {});
							this.contextMenu.add({
								text: '<t:message code="system.label.sales.goodsinfoentry" default="상품정보등록"/>',   iconCls : '',
								handler: function(menuItem, event) {
									var records = grid.getSelectionModel().getSelection();
									var record = records[0];
									var params = {
										appId: UniAppManager.getApp().id,
										sender: me,
										action: 'excelNew',
										_EXCEL_JOBID: excelWindow.jobID,			// SOF112T Key1
										_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'), // SOF112T Key2
										ITEM_CODE: record.get('ITEM_CODE'),
										DIV_CODE: masterForm.getValue('DIV_CODE')
									}
									var rec = {data : {prgID : 'bpr101ukrv', 'text':''}};
									parent.openTab(rec, '/base/bpr101ukrv.do', params);
								}
							});
							this.contextMenu.add({
								text: '<t:message code="system.label.sales.bookinfoentry" default="도서정보등록"/>',   iconCls : '',
								handler: function(menuItem, event) {
									var records = grid.getSelectionModel().getSelection();
									var record = records[0];
									var params = {
										appId: UniAppManager.getApp().id,
										sender: me,
										action: 'excelNew',
										_EXCEL_JOBID: excelWindow.jobID,			// SOF112T Key1
										_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'), // SOF112T Key2
										ITEM_CODE: record.get('ITEM_CODE'),
										DIV_CODE: masterForm.getValue('DIV_CODE')
									}
									var rec = {data : {prgID : 'bpr102ukrv', 'text':''}};
									parent.openTab(rec, '/base/bpr102ukrv.do', params);
								}
							});
							me.on('cellcontextmenu', function( view, cell, cellIndex, record, row, rowIndex, event ) {
								event.stopEvent();
								if(record.get('_EXCEL_HAS_ERROR') == 'Y')
									me.contextMenu.showAt(event.getXY());
							});
						}
					}
				}],
				listeners: {
					close: function() {
						this.hide();
					},
					hide: function() {
						excelWindow.down('#grid01').getStore().loadData({});
						this.hide();
					}
				},
				onApply:function() {
					var flag = true
					var grid = this.down('#grid01');
					var records = grid.getSelectionModel().getSelection();
					flag =  UniAppManager.app.fnMakeExcelRef(records);
					if(flag) {
						// grid.getStore().remove(records);
						var beforeRM = grid.getStore().count();
						grid.getStore().remove(records);
						var afterRM = grid.getStore().count();
						if (beforeRM > 0 && afterRM == 0){
						   excelWindow.close();
						}
					}
					var finalRecords = detailStore.data.items;
					Ext.each(finalRecords, function(rec,i){
						UniAppManager.app.fnOrderAmtCal(rec, "Q", rec.get('ORDER_Q'));
					});
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};




	//SRM 데이터 중 등록되지 않은 데이터 보여줄 그리드
	var unregisteredSrmGrid = Unilite.createGrid('sof100ukrvUnregisteredGrid', {
		store   : notRegisteredSRMStore,
		layout  : 'fit',
		uniOpt  : {
			expandLastColumn	: false,
			useRowNumberer	  : true
		},
		columns : [
			{ dataIndex: 'CUSTOM_ITEM_CODE' , width: 120 },
			{ dataIndex: 'SPECIFICATION'	, width: 133 },
			{ dataIndex: 'DESCRIPTION'	  , flex: 1 }
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function(record) {
		}
	});

	//SRM 데이터 중 ERP에 품목정보 등록하지 않은 데이터 보여주기 위한 window
	function openSrmWindow() {
		if(!srmWindow) {
			srmWindow = Ext.create('widget.uniDetailWindow', {
				title   : 'Unregistered SRM Data',
				width   : 550,
				height  : 300,
				layout  : {type:'vbox', align:'stretch'},
				items   : [unregisteredSrmGrid],
				tbar	:['->',{
					itemId  : 'closeBtn',
					text	: '<t:message code="system.label.sales.confirm" default="확인"/>',
					handler : function() {
						srmWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						unregisteredSrmGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						unregisteredSrmGrid.reset();
					},
					show: function( panel, eOpts ) {
					}
				}
			})
		}
		srmWindow.center();
		srmWindow.show();
	};




	Unilite.Main({
		id			: 'sof100ukrvApp',
		focusField	: masterForm.getField('CUSTOM_CODE'),
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			id		: 'mainItem',
			border	: false,
			items	: [
				panelResult, panelTrade , detailGrid
			]
		},
		masterForm
		],
		fnInitBinding: function(params) {
			//SRM 데이터 수신 버튼 사용여부 체크하여 숨기여부 결정
			if(Ext.isEmpty(BsaCodeInfo.gsUseReceiveSrmYN) || BsaCodeInfo.gsUseReceiveSrmYN != 'Y') {
				Ext.getCmp('recieveSRM').setHidden(true);
			}
			gsStatusM = 'N';
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);

// detailGrid.disabledLinkButtons(false);
// Ext.getCmp('nationButton').setDisabled(true);

			if(!Ext.isEmpty(params && params.PGM_ID)){
				inoutTypeChk = params.PGM_ID;
				this.processParams(params);
			} else {
				this.setDefault();
				if(params && params.ORDER_NUM ) {
					masterForm.setValue('ORDER_NUM',params.ORDER_NUM);
					//UniAppManager.app.onQueryButtonDown();
				}
				masterForm.down('#purchaseRequest1').setDisabled(true);
				panelResult.down('#purchaseRequest2').setDisabled(true);
				panelResult.down('#docaddbutton').setDisabled(true);
			}

			if(masterForm.getValue('NATION_INOUT') == '2') {
				//20190925 OFFER_NO 자동채번 로직관련 수정 - 자동채번일 경우에는 readOnly(true) 유지
				if(!gsAutoOfferNo) {
					masterForm.getField('OFFER_NO').setReadOnly(false);
					panelResult.getField('OFFER_NO').setReadOnly(false);
				}
				panelTrade.getForm().getFields().each(function(field) {
					field.setReadOnly(false);
				});
				panelTrade.setConfig('collapsed', false);
			} else {
				// 무역폼 readOnly: true
				masterForm.getField('OFFER_NO').setReadOnly(true);
				panelResult.getField('OFFER_NO').setReadOnly(true);
				panelTrade.getForm().getFields().each(function(field) {
					field.setReadOnly(true);
				});
				panelTrade.setConfig('collapsed', true);
				Ext.getCmp('taxInout').setValue('1');
			}
		},
		// 링크로 넘어오는 params 받는 부분
		processParams: function(params) {
			// this.uniOpt.appParams = params;
			if(params.PGM_ID == 'spp100ukrv') {
				//20200519 추가: 견적등록에서 링크로 넘어와서 데이터를 set할 때, 기존 데이터가 있으면 거래처가 같을 경우에만 set하도록 수정
				if(!Ext.isEmpty(masterForm.getValue('CUSTOM_CODE'))) {
					if(masterForm.getValue('CUSTOM_CODE') != params.formPram.CUSTOM_CODE) {
						return false;
					}
				}
				masterForm.setValue('CUSTOM_CODE'	, params.formPram.CUSTOM_CODE);
				masterForm.setValue('CUSTOM_NAME'	, params.formPram.CUSTOM_NAME);
				masterForm.setValue('ORDER_TYPE'	, '10');
				masterForm.setValue('ORDER_PRSN'	, params.ESTI_PRSN);
				panelResult.setValue('ORDER_PRSN'	, params.ESTI_PRSN);
				masterForm.setValue('BILL_TYPE'		, '10');
				panelResult.setValue('CUSTOM_CODE'	, params.formPram.CUSTOM_CODE);
				panelResult.setValue('CUSTOM_NAME'	, params.formPram.CUSTOM_NAME);
				masterForm.getField('CUSTOM_CODE').setReadOnly(true);
				masterForm.getField('CUSTOM_NAME').setReadOnly(true);
				panelResult.getField('CUSTOM_CODE').setReadOnly(true);
				panelResult.getField('CUSTOM_NAME').setReadOnly(true);
				//masterForm.getField('ORDER_TYPE').setReadOnly(true);
				//panelResult.getField('ORDER_TYPE').setReadOnly(true);

				Ext.each(params.record, function(rec,i){
					UniAppManager.app.onLinkNewData();
					detailGrid.setEstimateLinkData(rec);
					var dGridRecord	= detailGrid.getSelectedRecord();
					var lTrnsRate	= dGridRecord.data.TRANS_RATE
					var dStockQ		= dGridRecord.data.STOCK_Q;
					var dOrderQ		= dGridRecord.data.ORDER_Q;
					UniAppManager.app.fnOrderAmtCal(dGridRecord, "Q",dOrderQ);

					if(BsaCodeInfo.gsProdSaleQ_WS03 == 'N' || Ext.isEmpty(BsaCodeInfo.gsProdSaleQ_WS03)) {
						if(dStockQ > 0) {
							if(dStockQ > dOrderQ) {
								dGridRecord.data.PROD_SALE_Q	= '0';
								dGridRecord.data.PROD_Q			= '0';
								dGridRecord.data.PROD_END_DATE	= '';
							} else {
								dGridRecord.data.PROD_SALE_Q	= (dOrderQ * lTrnsRate - dStockQ) / lTrnsRate;
								dGridRecord.data.PROD_Q			= dOrderQ * lTrnsRate - dStockQ;
								if(BsaCodeInfo.gsProdDate_WS04 == 'N' || Ext.isEmpty(BsaCodeInfo.gsProdDate_WS04))  
									dGridRecord.data.PROD_END_DATE	= dGridRecord.data.DVRY_DATE;
								else
									dGridRecord.data.PROD_END_DATE	= UniDate.get('today');
							}
						} else if(dStockQ <= 0) {
							if(dGridRecord.data.ITEM_ACCOUNT == '00') {
								dGridRecord.data.PROD_SALE_Q	= '0';
								dGridRecord.data.PROD_Q			= '0';
								dGridRecord.data.PROD_END_DATE	= '';
							} else {
								dGridRecord.data.PROD_SALE_Q= dOrderQ;
								dGridRecord.data.PROD_Q		= dOrderQ * lTrnsRate;
							}
						}
					} else {
						if(dGridRecord.data.ITEM_ACCOUNT == '00') {
							dGridRecord.data.PROD_SALE_Q	= '0';
							dGridRecord.data.PROD_Q			= '0';
							dGridRecord.data.PROD_END_DATE	= '';
						} else {
							dGridRecord.data.PROD_SALE_Q	= dOrderQ;
							dGridRecord.data.PROD_Q			= dOrderQ * lTrnsRate;
							if(BsaCodeInfo.gsProdDate_WS04 == 'N' || Ext.isEmpty(BsaCodeInfo.gsProdDate_WS04))  
								dGridRecord.data.PROD_END_DATE	= dGridRecord.data.DVRY_DATE;
							else
								dGridRecord.data.PROD_END_DATE	= UniDate.get('today');
						}
					}

					if(BsaCodeInfo.gsProdtDtAutoYN == '1') {
						var dProdtQ = 0;
						if(!Ext.isEmpty(dGridRecord.data.PROD_SALE_Q)) {
							dProdtQ = dGridRecord.data.PROD_SALE_Q;
						}
						if(dProdtQ > 0) {
							if(BsaCodeInfo.gsProdDate_WS04 == 'N' || Ext.isEmpty(BsaCodeInfo.gsProdDate_WS04))  
								dGridRecord.data.PROD_END_DATE	= dGridRecord.data.DVRY_DATE;
							else
								dGridRecord.data.PROD_END_DATE	= UniDate.get('today');
						}
					}
				});
			} else if(params.PGM_ID == 'sof100skrv'){
				if(!Ext.isEmpty(params.ORDER_NUM)){
					masterForm.setValue('ORDER_NUM'	, params.ORDER_NUM);
					panelResult.setValue('ORDER_NUM', params.ORDER_NUM);
					masterForm.setValue('DIV_CODE'	, params.DIV_CODE);
					panelResult.setValue('DIV_CODE'	, params.DIV_CODE);
					UniAppManager.app.onQueryButtonDown();
				}
			} else if(params.PGM_ID == 'str500skrv'){
				if(!Ext.isEmpty(params.ORDER_NUM)){
					masterForm.setValue('ORDER_NUM'	, params.ORDER_NUM);
					panelResult.setValue('ORDER_NUM', params.ORDER_NUM);
					masterForm.setValue('DIV_CODE'	, params.DIV_CODE);
					panelResult.setValue('DIV_CODE'	, params.DIV_CODE);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},
		onQueryButtonDown: function() {
// masterForm.setAllFieldsReadOnly(false);
// panelResult.setAllFieldsReadOnly(false);
			var orderNo = masterForm.getValue('ORDER_NUM');
			if(Ext.isEmpty(orderNo)) {
				openSearchInfoWindow()
			} else {
				panelResult.setValue('SEQS', '');
				gsSaveRefFlag = 'N';
				isLoad = true;
				var param= masterForm.getValues();
				masterForm.uniOpt.inLoading=true;
				masterForm.getForm().load({
					params: param,
					success:function() {
						gsLastDate = masterForm.getValue('ORDER_DATE');
						panelResult.setValue('CUSTOM_CODE',masterForm.getValue('CUSTOM_CODE'));
						panelResult.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
						panelResult.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
						panelResult.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
						panelResult.setValue('TAX_INOUT', masterForm.getValue('TAX_INOUT'));
						panelResult.setValue('PROJECT_NO', masterForm.getValue('PROJECT_NO'));
						panelResult.setValue('PO_NUM', masterForm.getValue('PO_NUM'));
						panelResult.getForm().findField('CUSTOM_CODE').setReadOnly(true);
						panelResult.getForm().findField('CUSTOM_NAME').setReadOnly(true);
						if(masterForm.getValue('DOC_CNT') > 0){
							panelResult.down('#docaddbutton').setText( '문서등록: ' + masterForm.getValue('DOC_CNT') + '건');
						}

						if(CustomCodeInfo.gsCustCrYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
							// 여신액 구하기
							var divCode = masterForm.getValue('DIV_CODE');
							var CustomCode = masterForm.getValue('CUSTOM_CODE');
							var orderDate = masterForm.getField('ORDER_DATE').getSubmitValue()
							var moneyUnit = BsaCodeInfo.gsMoneyUnit;
							// 마스터폼에 여신액 set
							UniAppManager.app.fnGetCustCredit(divCode, CustomCode, orderDate, moneyUnit);
						}
						
						// 20210224 : 부가세유형이 카드매출인 경우 카드사 readonly 비활성
						if('40' == masterForm.getValue('BILL_TYPE')){
							masterForm.getField('CARD_CUSTOM_CODE').setReadOnly(false);
							panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(false);
						} else {
							masterForm.setValue('CARD_CUSTOM_CODE', '');
							panelResult.setValue('CARD_CUSTOM_CODE', '');
							masterForm.getField('CARD_CUSTOM_CODE').setReadOnly(true);
							panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(true);
						}
						
						if('6' == masterForm.getValue('STATUS').STATUS){
							masterForm.setValue('CONFIRMEYN', 'Y');
							panelResult.setValue('CONFIRMEYN', 'Y');
						}else{
							masterForm.setValue('CONFIRMEYN', 'N');
							panelResult.setValue('CONFIRMEYN', 'N');							
						}
						masterForm.getField('CONFIRMEYN').setReadOnly(true);
						panelResult.getField('CONFIRMEYN').setReadOnly(true);						
						
						masterForm.setAllFieldsReadOnly(true)
						panelResult.setAllFieldsReadOnly(true)
						//20190724 무역패널은 이후 프로세스에 영향이 없으므로 수정가능하도록 변경
//						panelTrade.setAllFieldsReadOnly(true);

						//20190724 무역패널 로드 후 gsSaveRefFlag = 'Y'로 변경
						panelTrade.getForm().load({
							params: param,
							success:function() {
								gsSaveRefFlag = 'Y';
							},
							failure: function(form, action) {
								panelTrade.uniOpt.inLoading=false;
							}
						})

// if(BsaCodeInfo.gsDraftFlag == 'Y' && masterForm.getValue('STATUS') != '1') {
// checkDraftStatus = true;
// }
/*						if(masterForm.getValue('ORDER_REQ_YN') != "N"){ // 구매요청정보
																		// 반영에
																		// 따른 버튼
																		// disabled
																		// 처리
							masterForm.down('#purchaseRequest1').setDisabled(true);
							panelResult.down('#purchaseRequest2').setDisabled(true);
						} else {
							masterForm.down('#purchaseRequest1').setDisabled(false);
							panelResult.down('#purchaseRequest2').setDisabled(false);
						}*/

						if(masterForm.getValue('SEND_FLAG') == 'Y') {
							masterForm.down('#soToPoReq').setText('<t:message code="system.label.sales.poCancel" default="요청취소"/>');
						} else {
							masterForm.down('#soToPoReq').setText('<t:message code="system.label.sales.poRequest" default="발주요청"/>');
						}
						//20190906 추가
						UniAppManager.app.fnSetColumnFormat();

						masterForm.uniOpt.inLoading=false;
						//20190906 위치 변경
						detailStore.loadStoreRecords();
					},
					failure: function(form, action) {
						masterForm.uniOpt.inLoading=false;
					}
				})
			}
		},
		//20191202 행 추가 시, 매출유형 상위행의 매출유형 따라가도록 설정하기 위해 수정: onNewDataButtonDown(상위행 매출유형) - 품목 멀티 선택, 행추가 / onNewDataButtonDown2(gsInoutDetailType) - 참조
		onNewDataButtonDown: function() {
/*			//20190925 OFFER_NO 자동채번 로직관련 수정 - - 무역이면서 자동채번이 아닐 때만 OFFER_NO 필수 체크, 원래 주석이어서 일단 주석 유지
			if(masterForm.getValue('NATION_INOUT') == 2 && Ext.isEmpty(masterForm.getValue('OFFER_NO')) && !gsAutoOfferNo) {
				Unilite.messageBox("OFFER번호는 필수입니다.");
				return true;
			}
			if(masterForm.getValue('NATION_INOUT') == 2){
				if(!panelTrade.getInvalidMessage()) return;
			} */
			/* if(panelResult.getValue('MONEY_UNIT') != 'KRW'){
				panelResult.getField('ORDER_O').type = 'uniUnitPrice';
				panelResult.getField('ORDER_TAX_O').type = 'uniUnitPrice';
				panelResult.getField('TOT_ORDER_AMT').type = 'uniUnitPrice';
				panelResult.getField('REMAIN_CREDIT').type = 'uniUnitPrice';
			} else {
				panelResult.getField('ORDER_O').type = 'uniNumber';
				panelResult.getField('ORDER_TAX_O').type = '';
				panelResult.getField('TOT_ORDER_AMT').type = '';
				panelResult.getField('REMAIN_CREDIT').type = '';
			} */
			if(!this.checkForNewDetail()) return false;

			//20190906 추가, 20210113 로직 수정: 행 추가 시, 화폐단위 / 환율로직 가져오는 로직 수행되지 않도록 처리
			UniAppManager.app.fnSetColumnFormat(true);

			//Detail Grid Default 값 설정
			var divCode = masterForm.getValue('DIV_CODE');

			 var orderNum = masterForm.getValue('ORDER_NUM');

			 var seq = detailStore.max('SER_NO');
			 if(!seq) seq = 1;
			 else  seq += 1;

			 var taxType ='1';
			 if(masterForm.getValue('BILL_TYPE')=='50' || masterForm.getValue('BILL_TYPE')=='60') {
				taxType ='2';
			 }

			 var outDivCode = '';
			 if(!Ext.isEmpty(masterForm.getValue('DIV_CODE'))) {
				outDivCode = masterForm.getValue('DIV_CODE');
			 }

			 var dvryDate = '';
			 if(!Ext.isEmpty(masterForm.getValue('DVRY_DATE'))) {
				dvryDate=masterForm.getValue('DVRY_DATE');
			 } else {
				dvryDate= new Date();
			 }

			 var refOrderDate = '';
			 if(!Ext.isEmpty(masterForm.getValue('ORDER_DATE'))) {
				refOrderDate=masterForm.getValue('ORDER_DATE');
			 }

			 var refOrdCust = '';
			 if(!Ext.isEmpty(masterForm.getValue('CUSTOM_CODE'))) {
				refOrdCust=masterForm.getValue('CUSTOM_CODE');
			 }

			 var customCode = '';
			 if(!Ext.isEmpty(masterForm.getValue('SALE_CUST_CD'))) {
				customCode=masterForm.getValue('SALE_CUST_CD');
			 } else {
				customCode=masterForm.getValue('CUSTOM_CODE');
			 }

			 var customName = '';
			 if(!Ext.isEmpty(masterForm.getValue('SALE_CUST_NM'))) {
				customName=masterForm.getValue('SALE_CUST_NM');
			 } else {
				customName=masterForm.getValue('CUSTOM_NAME');
			 }

			 var refOrderType = '';
			 if(!Ext.isEmpty(masterForm.getValue('ORDER_TYPE'))) {
				refOrderType=masterForm.getValue('ORDER_TYPE');
			 }

			 var projectNo = '';
			 if(!Ext.isEmpty(masterForm.getValue('PROJECT_NO'))) {
				projectNo=masterForm.getValue('PROJECT_NO');
			 }

			 var refBillType = '';
			 if(!Ext.isEmpty(masterForm.getValue('BILL_TYPE'))) {
				refBillType=masterForm.getValue('BILL_TYPE');
			 }

			 var refReceiptSetMeth = '';
			 if(!Ext.isEmpty(masterForm.getValue('RECEIPT_SET_METH'))) {
				refReceiptSetMeth=masterForm.getValue('RECEIPT_SET_METH');
			 }

			 var ponum = '';
			 if(!Ext.isEmpty(masterForm.getValue('PO_NUM'))) {
				ponum=masterForm.getValue('PO_NUM');
			 }

			 var r = {
			 	DIV_CODE			: divCode,
				ORDER_NUM			: orderNum,
				SER_NO				: seq,
				OUT_DIV_CODE		: outDivCode,
				TAX_TYPE			: taxType,
				DVRY_DATE			: dvryDate,
				SALE_CUST_CD		: customCode,
				CUSTOM_NAME			: customName,
				REF_ORDER_DATE		: refOrderDate,
				REF_ORD_CUST		: refOrdCust,
				REF_ORDER_TYPE		: refOrderType,
				PROJECT_NO			: projectNo,
				REF_BILL_TYPE		: refBillType,
				REF_RECEIPT_SET_METH: refReceiptSetMeth,
				PO_NUM				: ponum,
				INOUT_TYPE_DETAIL	: gsInoutDetailType,
				//20200106 추가: 매출휴형에 따른 매출대상 값 set하는 로직 추가
				ACCOUNT_YNC			: gsAccountYnc
			};
			detailGrid.createRow(r, 'ITEM_CODE', detailGrid.getSelectedRowIndex());

			//20191202 상위행의 매출유형, 매출대상여부 적용하는 로직 추가
			var records			= detailGrid.getStore().data.items;
			var selectedRecord	= detailGrid.getSelectedRecord();
			var selectedIndex	= 0
			Ext.each(records, function(record, i){
				if(record.get('SER_NO') == selectedRecord.get('SER_NO')) {
					selectedIndex = i;
				}
			});
			if(selectedIndex > 0) {
				selectedRecord.set('INOUT_TYPE_DETAIL'	, detailGrid.getStore().getAt(selectedIndex - 1).get('INOUT_TYPE_DETAIL'));
				selectedRecord.set('ACCOUNT_YNC'		, detailGrid.getStore().getAt(selectedIndex - 1).get('ACCOUNT_YNC'));
				// 20191212 출고창고 행추가시 복사추가
				selectedRecord.set('OUT_WH_CODE'		, detailGrid.getStore().getAt(selectedIndex - 1).get('OUT_WH_CODE'));
			}

			masterForm.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
			panelTrade.setAllFieldsReadOnly(true);

			if(gsSaveRefFlag == "Y"){
				masterForm.down('#purchaseRequest1').setDisabled(true);
				panelResult.down('#purchaseRequest2').setDisabled(true);
			}
			/*판매유형, 부가세유형, 영업담당, 수주일 행 추가시 비활성화 해제*/
			masterForm.getField('ORDER_TYPE').setReadOnly(false);
			masterForm.getField('BILL_TYPE').setReadOnly(false);
			masterForm.getField('ORDER_PRSN').setReadOnly(false);
			masterForm.getField('ORDER_DATE').setReadOnly(false);
			panelResult.getField('ORDER_TYPE').setReadOnly(false);
			panelResult.getField('BILL_TYPE').setReadOnly(false);
			panelResult.getField('ORDER_PRSN').setReadOnly(false);
			panelResult.getField('ORDER_DATE').setReadOnly(false);
			
			// 20210224 : 부가세 유형이 카드매출인경우 카드사 비활성화 해제
			if('40' == masterForm.getValue('BILL_TYPE')) {
				masterForm.getField('CARD_CUSTOM_CODE').setReadOnly(false);
				panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(false);
			}
		},
		//20191202 행 추가 시, 매출유형 상위행의 매출유형 따라가도록 설정하기 위해 추가: onNewDataButtonDown(상위행 매출유형), onNewDataButtonDown2(gsInoutDetailType)
		onNewDataButtonDown2: function() {
			if(!this.checkForNewDetail()) return false;

			//20210113 로직 수정: 행 추가 시, 화폐단위 / 환율로직 가져오는 로직 수행되지 않도록 처리
			UniAppManager.app.fnSetColumnFormat(true);

			var divCode		= masterForm.getValue('DIV_CODE');
			var orderNum	= masterForm.getValue('ORDER_NUM');

			var seq = detailStore.max('SER_NO');
			if(!seq) seq = 1;
			else  seq += 1;

			var taxType ='1';
			if(masterForm.getValue('BILL_TYPE')=='50' || masterForm.getValue('BILL_TYPE')=='60') {
				taxType ='2';
			}

			var outDivCode = '';
			if(!Ext.isEmpty(masterForm.getValue('DIV_CODE'))) {
				outDivCode = masterForm.getValue('DIV_CODE');
			}

			var dvryDate = '';
			if(!Ext.isEmpty(masterForm.getValue('DVRY_DATE'))) {
				dvryDate=masterForm.getValue('DVRY_DATE');
			} else {
				dvryDate= new Date();
			}

			var refOrderDate = '';
			if(!Ext.isEmpty(masterForm.getValue('ORDER_DATE'))) {
				refOrderDate=masterForm.getValue('ORDER_DATE');
			}

			var refOrdCust = '';
			if(!Ext.isEmpty(masterForm.getValue('CUSTOM_CODE'))) {
				refOrdCust=masterForm.getValue('CUSTOM_CODE');
			}

			var customCode = '';
			if(!Ext.isEmpty(masterForm.getValue('SALE_CUST_CD'))) {
				customCode=masterForm.getValue('SALE_CUST_CD');
			} else {
				customCode=masterForm.getValue('CUSTOM_CODE');
			}

			var customName = '';
			if(!Ext.isEmpty(masterForm.getValue('SALE_CUST_NM'))) {
				customName=masterForm.getValue('SALE_CUST_NM');
			} else {
				customName=masterForm.getValue('CUSTOM_NAME');
			}

			var refOrderType = '';
			if(!Ext.isEmpty(masterForm.getValue('ORDER_TYPE'))) {
				refOrderType=masterForm.getValue('ORDER_TYPE');
			}

			var projectNo = '';
			if(!Ext.isEmpty(masterForm.getValue('PROJECT_NO'))) {
				projectNo=masterForm.getValue('PROJECT_NO');
			}

			var refBillType = '';
			if(!Ext.isEmpty(masterForm.getValue('BILL_TYPE'))) {
				refBillType=masterForm.getValue('BILL_TYPE');
			}

			var refReceiptSetMeth = '';
			if(!Ext.isEmpty(masterForm.getValue('RECEIPT_SET_METH'))) {
				refReceiptSetMeth=masterForm.getValue('RECEIPT_SET_METH');
			}

			var ponum = '';
			if(!Ext.isEmpty(masterForm.getValue('PO_NUM'))) {
				ponum=masterForm.getValue('PO_NUM');
			}

			var r = {
				DIV_CODE			: divCode,
				ORDER_NUM			: orderNum,
				SER_NO				: seq,
				OUT_DIV_CODE		: outDivCode,
				TAX_TYPE			: taxType,
				DVRY_DATE			: dvryDate,
				SALE_CUST_CD		: customCode,
				CUSTOM_NAME			: customName,
				REF_ORDER_DATE		: refOrderDate,
				REF_ORD_CUST		: refOrdCust,
				REF_ORDER_TYPE		: refOrderType,
				PROJECT_NO			: projectNo,
				REF_BILL_TYPE		: refBillType,
				REF_RECEIPT_SET_METH: refReceiptSetMeth,
				PO_NUM				: ponum,
				INOUT_TYPE_DETAIL	: gsInoutDetailType,
				//20200106 추가: 매출휴형에 따른 매출대상 값 set하는 로직 추가
				ACCOUNT_YNC			: gsAccountYnc
			};
			detailGrid.createRow(r, 'ITEM_CODE', detailGrid.getSelectedRowIndex());
			masterForm.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
			panelTrade.setAllFieldsReadOnly(true);						

			if(gsSaveRefFlag == "Y"){
				masterForm.down('#purchaseRequest1').setDisabled(true);
				panelResult.down('#purchaseRequest2').setDisabled(true);
			}
			/*판매유형, 부가세유형, 영업담당, 수주일 행 추가시 비활성화 해제*/
			masterForm.getField('ORDER_TYPE').setReadOnly(false);
			masterForm.getField('BILL_TYPE').setReadOnly(false);
			masterForm.getField('ORDER_PRSN').setReadOnly(false);
			masterForm.getField('ORDER_DATE').setReadOnly(false);
			panelResult.getField('ORDER_TYPE').setReadOnly(false);
			panelResult.getField('BILL_TYPE').setReadOnly(false);
			panelResult.getField('ORDER_PRSN').setReadOnly(false);
			panelResult.getField('ORDER_DATE').setReadOnly(false);
			
			masterForm.getField('CONFIRMEYN').setReadOnly(false);
			panelResult.getField('CONFIRMEYN').setReadOnly(false);				
			
			// 20210224 : 부가세 유형이 카드매출인경우 카드사 비활성화 해제
			if('40' == masterForm.getValue('BILL_TYPE')) {
				masterForm.getField('CARD_CUSTOM_CODE').setReadOnly(false);
				panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(false);
			}
		},
		onLinkNewData: function() {
			 var orderNum = masterForm.getValue('ORDER_NUM')

			 var seq = detailStore.max('SER_NO');
			 if(!seq) seq = 1;
			 else  seq += 1;

			 var taxType ='1';
			 if(masterForm.getValue('BILL_TYPE')=='50') {
				taxType ='2';
			 }

			 var outDivCode = '';
			 if(!Ext.isEmpty(masterForm.getValue('DIV_CODE'))) {
				outDivCode = masterForm.getValue('DIV_CODE');
			 }

			 var dvryDate = '';
			 if(!Ext.isEmpty(masterForm.getValue('DVRY_DATE'))) {
				dvryDate=masterForm.getValue('DVRY_DATE');
			 } else {
				dvryDate= new Date();
			 }

			 var saleCustCd = '';
			 if(!Ext.isEmpty(masterForm.getValue('SALE_CUST_CD'))) {
				saleCustCd=masterForm.getValue('SALE_CUST_CD');
			 }

			 var refOrderDate = '';
			 if(!Ext.isEmpty(masterForm.getValue('ORDER_DATE'))) {
				refOrderDate=masterForm.getValue('ORDER_DATE');
			 }

			 var refOrdCust = '';
			 if(!Ext.isEmpty(masterForm.getValue('CUSTOM_CODE'))) {
				refOrdCust=masterForm.getValue('CUSTOM_CODE');
			 }

			 var customCode = '';
			 if(!Ext.isEmpty(masterForm.getValue('SALE_CUST_CD'))) {
				customCode=masterForm.getValue('SALE_CUST_CD');
			 } else {
				customCode=masterForm.getValue('CUSTOM_CODE');
			 }

			 var customName = '';
			 if(!Ext.isEmpty(masterForm.getValue('SALE_CUST_NM'))) {
				customName=masterForm.getValue('SALE_CUST_NM');
			 } else {
				customName=masterForm.getValue('CUSTOM_NAME');
			 }

			 var refOrderType = '';
			 if(!Ext.isEmpty(masterForm.getValue('ORDER_TYPE'))) {
				refOrderType=masterForm.getValue('ORDER_TYPE');
			 }

			 var projectNo = '';
			 if(!Ext.isEmpty(masterForm.getValue('PROJECT_NO'))) {
				projectNo=masterForm.getValue('PROJECT_NO');
			 }

			 var refBillType = '';
			 if(!Ext.isEmpty(masterForm.getValue('BILL_TYPE'))) {
				refBillType=masterForm.getValue('BILL_TYPE');
			 }

			 var refReceiptSetMeth = '';
			 if(!Ext.isEmpty(masterForm.getValue('RECEIPT_SET_METH'))) {
				refReceiptSetMeth=masterForm.getValue('RECEIPT_SET_METH');
			 }

			 var ponum = '';
			 if(!Ext.isEmpty(masterForm.getValue('PO_NUM'))) {
				ponum=masterForm.getValue('PO_NUM');
			 }

			 var r = {
				ORDER_NUM			: orderNum,
				SER_NO				: seq,
				OUT_DIV_CODE		: outDivCode,
				TAX_TYPE			: taxType,
				DVRY_DATE			: dvryDate,
				SALE_CUST_CD		: customCode,
				CUSTOM_NAME			: customName,
				REF_ORDER_DATE		: refOrderDate,
				REF_ORD_CUST		: refOrdCust,
				REF_ORDER_TYPE		: refOrderType,
				PROJECT_NO			: projectNo,
				REF_BILL_TYPE		: refBillType,
				REF_RECEIPT_SET_METH: refReceiptSetMeth,
				PO_NUM				: ponum
			};
			detailGrid.createRow(r, 'ITEM_CODE', detailGrid.getSelectedRowIndex());
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			detailGrid.reset();
			detailStore.clearData();
			panelTrade.clearForm();
			masterForm.clearForm();
			panelResult.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelTrade.setAllFieldsReadOnly(false);
			
			masterForm.setValue('CONFIRMEYN'	, BsaCodeInfo.gsConfirmeYn);
			panelResult.setValue('CONFIRMEYN'	, BsaCodeInfo.gsConfirmeYn);	
			
			masterForm.getField('CONFIRMEYN').setReadOnly(false);
			panelResult.getField('CONFIRMEYN').setReadOnly(false);	
			
			this.fnInitBinding();
			masterForm.getField('CUSTOM_CODE').focus();
			panelResult.down('#docaddbutton').setText( '문서등록');
		},
		onSaveDataButtonDown: function(config) {
			if(!masterForm.setAllFieldsReadOnly(true)) {
				return false;
			}
			//20190925 OFFER_NO 자동채번 로직관련 수정 - 무역이면서 자동채번이 아닐 때만 OFFER_NO 필수 체크
			if(masterForm.getValue('NATION_INOUT') == 2 && Ext.isEmpty(masterForm.getValue('OFFER_NO')) && !gsAutoOfferNo) {
				Unilite.messageBox('<t:message code="system.message.sales.datacheck003" default="OFFER번호는 필수입니다."/>');
				return true;
			}
			if(masterForm.getValue('NATION_INOUT') == 2){
				if(!panelTrade.getInvalidMessage()) return;
			}
// if(detailStore.data.length == 0) {
// Unilite.messageBox('수주상세정보를 입력하세요.');
// return;
// }
			//여신한도 확인
			if(!masterForm.fnCreditCheck('Y')) {
				return ;
			}

			if(isDraftFlag === false) { // 수동승인인 경우
				var amt = masterForm.getValue("TOT_ORDER_AMT");
				if(Ext.isEmpty(masterForm.getValue("APP_1_ID"))) {
					Unilite.messageBox('<t:message code="system.message.sales.datacheck004" default="1차 승인자는 필수 입력입니다."/>');
					masterForm.getField("APP_1_NM").focus();
					return false;
				} else if(amt > BsaCodeInfo.gsApp1AmtInfo) {
					if(Ext.isEmpty(masterForm.getValue("APP_2_ID"))) {
						Unilite.messageBox('<t:message code="system.message.sales.datacheck005" default="2차 승인자는 필수 입력입니다."/>');
						masterForm.getField("APP_2_NM").focus();
						return false;
					} else  if(amt > BsaCodeInfo.gsApp2AmtInfo) {
						if(Ext.isEmpty(masterForm.getValue("APP_3_ID"))) {
							Unilite.messageBox('<t:message code="system.message.sales.datacheck006" default="3차 승인자는 필수 입력입니다."/>');
							masterForm.getField("APP_3_NM").focus();
							return false;
						}
					}
				}
			}

			if(!detailStore.isDirty()) {
				if(masterForm.isDirty()) {
					this.fnMasterSave();
				}
			} else {
				detailStore.saveStore();
			}
		},
		onSaveDataButtonDown2: function(config) {   // masterForm.fnCreditCheck() 없는용..삭제시 호출
// if(detailStore.data.length == 0) {
// Unilite.messageBox('수주상세정보를 입력하세요.');
// return;
// }
			if(isDraftFlag === false) { // 수동승인인 경우
				var amt = masterForm.getValue("TOT_ORDER_AMT");
				if(Ext.isEmpty(masterForm.getValue("APP_1_ID"))) {
					Unilite.messageBox('<t:message code="system.message.sales.datacheck004" default="1차 승인자는 필수 입력입니다."/>');
					masterForm.getField("APP_1_NM").focus();
					return false;
				} else if(amt > BsaCodeInfo.gsApp1AmtInfo) {
					if(Ext.isEmpty(masterForm.getValue("APP_2_ID"))) {
						Unilite.messageBox('<t:message code="system.message.sales.datacheck005" default="2차 승인자는 필수 입력입니다."/>');
						masterForm.getField("APP_2_NM").focus();
						return false;
					} else  if(amt > BsaCodeInfo.gsApp2AmtInfo) {
						if(Ext.isEmpty(masterForm.getValue("APP_3_ID"))) {
							Unilite.messageBox('<t:message code="system.message.sales.datacheck006" default="3차 승인자는 필수 입력입니다."/>');
							masterForm.getField("APP_3_NM").focus();
							return false;
						}
					}
				}
			}

			if(!detailStore.isDirty()) {
				if(masterForm.isDirty()) {
					this.fnMasterSave();
				}
			} else {
				detailStore.saveStore();
			}
		},
		fnMasterSave: function(){
			//20191014 추가: 수주번호 수동입력일 경우, 수주번호 대문자로 변경하롤 로직 추가
			if(BsaCodeInfo.gsAutoType != 'Y' && !Ext.isEmpty(masterForm.getValue('ORDER_NUM'))) {
				masterForm.setValue('ORDER_NUM'	, masterForm.getValue('ORDER_NUM').toUpperCase());
				panelResult.setValue('ORDER_NUM', masterForm.getValue('ORDER_NUM').toUpperCase());
			}
			
//			if(BsaCodeInfo.gsDraftFlag != 'Y' && Ext.getCmp('taxConfirmeyn').getChecked()=='N') {
//				masterForm.setValue('STATUS', '1');
//				panelResult.setValue('STATUS', '1');
//			}			
			var paramMaster = masterForm.getValues();
			var paramTrade = panelTrade.getValues();
			var param = Ext.merge(paramMaster , paramTrade);
			masterForm.submit({
				params: param,
				success:function(comp, action) {
					UniAppManager.setToolbarButtons('save', false);
					UniAppManager.updateStatus('<t:message code="system.message.sales.message033" default="저장되었습니다."/>');
				},
				failure: function(form, action){

				}
			});
		},
		fnNationSave: function(){
			var param = nationSearch.getValues();
			nationSearch.submit({
				params: param,
				success:function(comp, action) {
					UniAppManager.updateStatus('<t:message code="system.message.sales.message033" default="저장되었습니다."/>');
				},
				failure: function(form, action){
				}
			});
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			} else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('ISSUE_REQ_Q') > 0 || selRow.get('OUTSTOCK_Q') > 0 ) {
					Unilite.messageBox('<t:message code="system.message.sales.datacheck007" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
				} else {
					detailGrid.deleteSelectedRow();
				}
			}
			// fnOrderAmtSum 호출(grid summary 이용)
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					 // 신규 레코드일시 isNewData에
														// true를 반환
					isNewData = true;
				} else {								  // 신규 레코드가 아닌게 중간에 나오면
														// 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						Ext.each(records, function(record,i) {
							if(record.get('ISSUE_REQ_Q') > 0 || record.get('OUTSTOCK_Q') > 0 ) {
								Unilite.messageBox('<t:message code="system.message.sales.datacheck007" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
								deletable = false;
								return false;
							}
						});
						/*---------삭제전 로직 구현 끝----------*/

						if(deletable){
							detailGrid.reset();
							UniAppManager.app.onSaveDataButtonDown2();
						}
					}
					return false;
				}
			});
			if(isNewData){							  // 신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();  // 삭제후 RESET..
			}

		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('sof100ukrvAdvanceSerch');
			if(as.isHidden()) {
				as.show();
			} else {
				as.hide()
			}
		},
		rejectSave: function() {
			var rowIndex = detailGrid.getSelectedRowIndex();
			detailGrid.select(rowIndex);
			detailStore.rejectChanges();

			detailStore.onStoreActionEnable();

		},
		confirmSaveData: function(config) {
			if(detailStore.isDirty() ) {
				if(confirm('<t:message code="system.message.sales.message021" default="변경된 내용을 저장하시겠습니까?"/>')) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
			// 무역 폼필드 readOnly
			panelTrade.getForm().getFields().each(function(field) {
				field.setReadOnly(true);
			});
			panelResult.setValue('SEQS', '');
			/* 영업담당 filter set */
			var field = masterForm.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			masterForm.setValue('ORDER_O'		, 0);
			panelResult.setValue('ORDER_O'		, 0);
			masterForm.setValue('ORDER_TAX_O'	, 0);
			panelResult.setValue('ORDER_TAX_O'	, 0);
			masterForm.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			masterForm.setValue('ORDER_DATE'	, new Date());
			panelResult.setValue('ORDER_DATE'	, new Date());
			//20191017 추가: 수주일 변경 시, 유효일 변경여부 확인하기 위해 수주일 이전 값 저장하기 위한 변수 선언
			gsOldValue = new Date();
			masterForm.setValue('TAX_INOUT'		, '1');
			panelResult.setValue('TAX_INOUT'	, '1');
			masterForm.setValue('STATUS'		, '1');
			panelResult.setValue('STATUS'		, '1');
			masterForm.setValue('MONEY_UNIT'	, BsaCodeInfo.gsMoneyUnit);
			panelResult.setValue('MONEY_UNIT'	, BsaCodeInfo.gsMoneyUnit);
			masterForm.setValue('EXCHANGE_RATE'	, '1');
			panelResult.setValue('EXCHANGE_RATE', '1');
			masterForm.setValue('DEPT_CODE'		, UserInfo.deptCode);
			masterForm.setValue('DEPT_NAME'		, UserInfo.deptName);
			panelResult.setValue('DEPT_CODE'	, UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME'	, UserInfo.deptName);
			
			if( BsaCodeInfo.gsConfirmeYn == 'Y') {
				masterForm.getField('CONFIRMEYN').show();
				panelResult.getField('CONFIRMEYN').show();
			} else {
				masterForm.getField('CONFIRMEYN').hide();
				panelResult.getField('CONFIRMEYN').hide();
			}			
			
			masterForm.setValue('CONFIRMEYN'	, BsaCodeInfo.gsConfirmeYn);
			panelResult.setValue('CONFIRMEYN'	, BsaCodeInfo.gsConfirmeYn);	
			
			masterForm.getField('CONFIRMEYN').setReadOnly(false);
			panelResult.getField('CONFIRMEYN').setReadOnly(false);				

			masterForm.setValue('NATION_INOUT'	,'1');
			panelResult.setValue('NATION_INOUT'	,'1');

			masterForm.setValue('DVRY_DATE',BsaCodeInfo.gsDvryDate);
			panelResult.setValue('DVRY_DATE',BsaCodeInfo.gsDvryDate);

			//masterForm.setValue('ORDER_PRSN', Ext.data.StoreManager.lookup('CBS_AU_S010').getAt(0).get('value')); // 영엽담당
			//panelResult.setValue('ORDER_PRSN', Ext.data.StoreManager.lookup('CBS_AU_S010').getAt(0).get('value')); // 영엽담당
			panelTrade.setValue('DATE_EXP', new Date());
			panelTrade.setValue('DATE_DEPART', new Date());
			panelTrade.setValue('METH_CARRY', '1');
			panelTrade.setValue('COND_PACKING', '1');
			panelTrade.setValue('METH_INSPECT', '1');
			masterForm.setValue('ORDER_PRSN', BsaCodeInfo.gsSalesPrsn);
			panelResult.setValue('ORDER_PRSN', BsaCodeInfo.gsSalesPrsn);
			gsLastDate = masterForm.getValue('ORDER_DATE');

			panelTrade.setValue('PALLET_QTY', '0');

// panelTrade.setValue('PAY_TERMS',
// Ext.data.StoreManager.lookup('CBS_AU_T006').getAt(0).get('value'));
// panelTrade.setValue('PAY_METHODE1',
// Ext.data.StoreManager.lookup('CBS_AU_T006').getAt(0).get('value'));
// panelTrade.setValue('TERMS_PRICE',
// Ext.data.StoreManager.lookup('CBS_AU_T005').getAt(0).get('value'));
// panelTrade.setValue('METH_CARRY',
// Ext.data.StoreManager.lookup('CBS_AU_T004').getAt(0).get('value'));
// panelTrade.setValue('COND_PACKING',
// Ext.data.StoreManager.lookup('CBS_AU_T010').getAt(0).get('value'));
// panelTrade.setValue('METH_INSPECT',
// Ext.data.StoreManager.lookup('CBS_AU_T011').getAt(0).get('value'));
// panelTrade.setValue('SHIP_PORT',
// Ext.data.StoreManager.lookup('CBS_AU_T008').getAt(0).get('value'));
// panelTrade.setValue('DEST_PORT',
// Ext.data.StoreManager.lookup('CBS_AU_T008').getAt(0).get('value'));

			if( BsaCodeInfo.gsCreditYn == 'Y') {
				masterForm.getField('REMAIN_CREDIT').show();
				panelResult.getField('REMAIN_CREDIT').show();
			} else {
				masterForm.getField('REMAIN_CREDIT').hide();
				panelResult.getField('REMAIN_CREDIT').show();
			}

			if(BsaCodeInfo.gsAutoType == 'Y') {
				masterForm.getField('ORDER_NUM').setReadOnly(true);
				panelResult.getField('ORDER_NUM').setReadOnly(true);
			} else {
				masterForm.getField('ORDER_NUM').setReadOnly(false);
				panelResult.getField('ORDER_NUM').setReadOnly(false);
			}

			var billType	= masterForm.getField('BILL_TYPE');
			var orderType	= masterForm.getField('ORDER_TYPE');
			var receiptMeth	= masterForm.getField('RECEIPT_SET_METH');

			billType.select(billType.getStore().getAt(0));
			orderType.select(orderType.getStore().getAt(0));
			receiptMeth.select(receiptMeth.getStore().getAt(0));

			if(BsaCodeInfo.gsDraftFlag=='Y') {
				masterForm.down('#DraftFields').show();
			} else {
				masterForm.down('#DraftFields').hide();
			}

// if(BsaCodeInfo.gsScmUseYN=='Y') {
// detailGrid.down().down('#scmBtn').show();
// } else {
// detailGrid.down().down('#scmBtn').hide();
// }
			masterForm.getField('ORDER_O').setReadOnly(true);
			masterForm.getField('ORDER_TAX_O').setReadOnly(true);
			masterForm.getField('TOT_ORDER_AMT').setReadOnly(true);
			UniAppManager.app.fnExchngRateO(true);
			gsSaveRefFlag = 'N';
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();

			masterForm.getField('OFFER_NO').setReadOnly(true);
			panelResult.getField('OFFER_NO').setReadOnly(true);
			UniAppManager.setToolbarButtons('save', false);
		},
		setNationInfoData: function(record, dataClear) {
			masterForm.setValue('CUSTOM_CODE_TEMP'	,nationSearch.getValue('CUSTOM_CODE'));
			masterForm.setValue('CUSTOM_NAME_TEMP'	,nationSearch.getValue('CUSTOM_NAME'));
			masterForm.setValue('DATE_DEPART'		,nationSearch.getValue('DATE_DEPART'));
			masterForm.setValue('DATE_EXP'			,nationSearch.getValue('DATE_EXP'));
			masterForm.setValue('PAY_METHODE1'		,nationSearch.getValue('PAY_METHODE1'));
			masterForm.setValue('PAY_TERMS'			,nationSearch.getValue('PAY_TERMS'));
			masterForm.setValue('PAY_DURING'		,nationSearch.getValue('PAY_DURING'));
			masterForm.setValue('TERMS_PRICE'		,nationSearch.getValue('TERMS_PRICE'));
			masterForm.setValue('COND_PACKING'		,nationSearch.getValue('COND_PACKING'));
			masterForm.setValue('METH_CARRY'		,nationSearch.getValue('METH_CARRY'));
			masterForm.setValue('METH_INSPECT'		,nationSearch.getValue('METH_INSPECT'));
			masterForm.setValue('DEST_PORT'			,nationSearch.getValue('DEST_PORT'));
			masterForm.setValue('DEST_PORT_NM'		,nationSearch.getValue('DEST_PORT_NM'));
			masterForm.setValue('SHIP_PORT'			,nationSearch.getValue('SHIP_PORT'));
			masterForm.setValue('SHIP_PORT_NM'		,nationSearch.getValue('SHIP_PORT_NM'));
			masterForm.setValue('BANK_SENDING'		,nationSearch.getValue('BANK_CODE'));
			//record.set('' ,nationSearch.getValue(''));
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE')),
				"MONEY_UNIT": masterForm.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni && !Ext.isEmpty(masterForm.getValue('MONEY_UNIT')) && masterForm.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
						Unilite.messageBox('<t:message code="system.message.sales.datacheck008" default="환율정보가 없습니다."/>');
					}
					masterForm.setValue('EXCHANGE_RATE'	, provider.BASE_EXCHG);
					panelResult.setValue('EXCHANGE_RATE', provider.BASE_EXCHG);
				}
			});
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType != 'Y' && Ext.isEmpty(masterForm.getValue('ORDER_NUM'))) {
				Unilite.messageBox('<t:message code="system.label.sales.sono" default="수주번호"/>:<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			//20191014 추가: 수주번호 수동입력일 경우, 자릿수 체크하는 로직 추가
			if(BsaCodeInfo.gsAutoType != 'Y' && !(masterForm.getValue('ORDER_NUM').length >= gsSNMinLen && masterForm.getValue('ORDER_NUM').length <= gsSNMaxLen)) {
				Unilite.messageBox('<t:message code="system.message.sales.message142" default="잘못된 수주번호가 입력되었습니다."/>'
								 , '<t:message code="system.message.sales.message144" default="지정된 수주번호 길이 :"/> ' + '(최소: ' + gsSNMinLen + ' 최대: ' + gsSNMaxLen + ') / <t:message code="system.message.sales.message143" default="입력된 수주번호 길이 :"/> ' + masterForm.getValue('ORDER_NUM').length);
				return false;
			}
			if(BsaCodeInfo.gsAutoType != 'Y' && !Ext.isEmpty(masterForm.getValue('ORDER_NUM'))) {
				masterForm.setValue('ORDER_NUM'	, masterForm.getValue('ORDER_NUM').toUpperCase());
				panelResult.setValue('ORDER_NUM', masterForm.getValue('ORDER_NUM').toUpperCase());
			}
			//여신한도 확인: 20200102 직접 실행으로 변경
			/* if(CustomCodeInfo.gsCustCrYn=='Y' && BsaCodeInfo.gsCreditYn=='Y') {
				if(masterForm.getValue('TOT_ORDER_AMT') > masterForm.getValue('REMAIN_CREDIT')) {
					Unilite.messageBox('<t:message code="system.message.sales.datacheck002" default="해당 업체에 대한 여신액이 부족합니다. 추가여신액 설정을 선행하시고 작업하시기 바랍니다."/>');
					return false;
				}
			}  */
			/* if(!masterForm.fnCreditCheck()) {
				return false;
			} */
			//마스터 데이타 수정 못 하도록 설정
			panelResult.setAllFieldsReadOnly(true);
			return masterForm.setAllFieldsReadOnly(true);
		},
		fnOrderAmtCal: function(rtnRecord, sType, nValue, taxType) {
			var dTransRate	= sType=='R' ? nValue : Unilite.nvl(rtnRecord.get('TRANS_RATE')		, 1);
			var dOrderQ		= sType=='Q' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_Q')		, 0);
			var dOrderP		= sType=='P' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_P')		, 0); // 단가
			var dOrderPCal	= sType=='P' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_P_CAL')	, 0); // 단가(할인율 계산용)
			var dOrderO		= sType=='O' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_O')		, 0); // 금액
			var dDcRate		= sType=='C' ? nValue : Unilite.nvl(rtnRecord.get('DISCOUNT_RATE')	, 0);

			if(sType == 'P' || sType == 'Q') {	// 업종별 프로세스 적용
				var dOrderUnitQ = 0;
				if(BsaCodeInfo.gsProcessFlag == 'PG') {
					dOrderO = dOrderQ * dOrderP * dTransRate;
				} else {
					dOrderO = Unilite.multiply(dOrderQ , dOrderP);
				}
				dOrderUnitQ = dOrderQ * dTransRate;
				rtnRecord.set('ORDER_O', dOrderO);
				rtnRecord.set('ORDER_UNIT_Q', dOrderUnitQ);
				this.fnTaxCalculate(rtnRecord, dOrderO)
			} else if(sType == 'R') {
				dOrderUnitQ = dOrderQ * dTransRate;
				rtnRecord.set('ORDER_UNIT_Q', dOrderUnitQ);
			} else if(sType == 'O') {
				if(dOrderQ != 0) {
					if(BsaCodeInfo.gsProcessFlag == 'PG') {
						dOrderP = dOrderO / (dOrderQ * dTransRate);
					} else {
						dOrderP = dOrderO / dOrderQ;
					}
				}
				//20210310 수정: 조건에 따라 단가 set하도록 수정, 20210611 수정: 조건 부 수정
				if(rtnRecord.get('ORDER_P') == 0) {
					rtnRecord.set('ORDER_P', dOrderP);
				}
//				if(taxType == '2') {
					this.fnTaxCalculate(rtnRecord, dOrderO, taxType)
//				} else {
//					var dTaxAmtO = rtnRecord.get('ORDER_TAX_O');
//					rtnRecord.set('ORDER_O_TAX_O',nValue+dTaxAmtO);
//				}
			} else if(sType == 'C') {
				//20190621 할인율 계산로직 수정
//				dOrderP = (dOrderP - (dOrderP * (dDcRate / 100)));
				dOrderP = (dOrderPCal - (dOrderPCal * (dDcRate / 100)));
				rtnRecord.set('ORDER_P', dOrderP);
				if(BsaCodeInfo.gsProcessFlag == 'PG') {
					dOrderO = dOrderQ * dOrderP * dTransRate ;
				} else {
					dOrderO = dOrderQ * dOrderP
				}
				this.fnTaxCalculate(rtnRecord, dOrderO)
			}
		},
		fnTaxCalculate: function(rtnRecord, dOrderO, taxType) {
			var sTaxType		= Ext.isEmpty(taxType)? rtnRecord.get('TAX_TYPE') : taxType;
			var sTaxInoutType	= Ext.isEmpty(Ext.getCmp('taxInout').getChecked())? '1' : Ext.getCmp('taxInout').getChecked()[0].inputValue;
			var dVatRate		= parseInt(BsaCodeInfo.gsVatRate);
			var dOrderAmtO		= 0;
			var dTaxAmtO		= 0;
			var dAmountI		= 0;
			//20191212 금액계산로직 변경으로 추가
			var sWonCalBas		= CustomCodeInfo.gsUnderCalBase;

			//20190624 화폐단위 관련로직 추가
			if(masterForm.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
				var digit = UniFormat.FC.indexOf(".") == -1 ? UniFormat.FC.length : UniFormat.FC.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.FC.length - digit;
			} else {
				var digit = UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.Price.length - digit;
			}
//			var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");

			if(sTaxInoutType=="1") {
				dOrderAmtO	= dOrderO;
				dTaxAmtO	= dOrderO * dVatRate / 100
				dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderAmtO, sWonCalBas, numDigitOfPrice);
				if(UserInfo.compCountry == 'CN') {
					//20191001 세액 구하는 함수 생성: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTaxAmtO, '3', numDigitOfPrice);
				} else {
					//20191001 세액 구하는 함수 생성: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTaxAmtO, sWonCalBas, numDigitOfPrice);	//세액은 절사처리함.
				}
			} else if(sTaxInoutType=="2") {
				dAmountI = dOrderO;
				if(UserInfo.compCountry == 'CN') {
					dTemp	= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '3', numDigitOfPrice);
					//20191001 세액 구하는 함수 생성: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, '3', numDigitOfPrice);	// 세액은 절사처리함.
				} else {
					dTemp	= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, sWonCalBas, numDigitOfPrice);
					//20191001 세액 구하는 함수 생성: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, sWonCalBas, numDigitOfPrice);	// 세액은 절사처리함.
				}
				dOrderAmtO = UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice) ;
			}
			if(sTaxType == "2" || sTaxType == "3") {
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderO, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice) ;
				dTaxAmtO = 0;
			}

			rtnRecord.set('ORDER_O'			, dOrderAmtO);
			rtnRecord.set('ORDER_TAX_O'		, dTaxAmtO);
			rtnRecord.set('ORDER_O_TAX_O'	, dOrderAmtO+dTaxAmtO);
		},
		fnCheckNum: function(value, record, fieldName, fieldLabel) {
			var r = true;
			if(record.get("PRICE_YN") == "1" || record.get("ACCOUNT_YNC")=="N") {
				r = true;
			} else if(record.get("PRICE_YN") == "2" ) {
				if(value < 0) {
					Unilite.messageBox(fieldLabel+'<t:message code="system.message.sales.message031" default="은"/> '+'<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>');
					r=false;
					return r;
				} else if(value == 0) {
					if(fieldName == "ORDER_TAX_O") {
						if(BsaCodeInfo.gsVatRate != 0) {
							Unilite.messageBox(fieldLabel+': <t:message code="system.message.sales.datacheck009" default="0보다 큰 값이 입력되어야 합니다."/>');
							r=false;
						}
					} else {
						Unilite.messageBox(fieldLabel+': <t:message code="system.message.sales.datacheck009" default="0보다 큰 값이 입력되어야 합니다."/>');
						r=false;
					}
				}
			}
			return r;
		},
		// UniSales.fnGetPriceInfo callback 함수
		cbGetPriceInfo: function(provider, params) {
			var dSalePrice=Unilite.nvl(provider['SALE_PRICE'],0);
			var dWgtPrice = Unilite.nvl(provider['WGT_PRICE'],0);// 판매단가(중량단위)
			var dVolPrice = Unilite.nvl(provider['VOL_PRICE'],0);// 판매단가(부피단위)

			if(params.sType=='I' && dSalePrice != 0) {
				// 단가구분별 판매단가 계산
				if(params.priceType == 'A') {						   // 단가구분(판매단위)
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					dVolPrice  = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				} else if(params.priceType == 'B') {					   // 단가구분(중량단위)
					dSalePrice = dWgtPrice  * params.unitWgt
					dVolPrice  = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				} else if(params.priceType == 'C') {					   // 단가구분(부피단위)
					dSalePrice = dVolPrice  * params.unitVol;
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
				} else {
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					dVolPrice = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				}

				// 판매단가 적용
				params.rtnRecord.set('ORDER_P',dSalePrice);
				//20190621 할인율 계산용 필드 추가
				params.rtnRecord.set('ORDER_P_CAL',dSalePrice);
				params.rtnRecord.set('ORDER_WGT_P',dWgtPrice);
				params.rtnRecord.set('ORDER_VOL_P',dVolPrice);

				params.rtnRecord.set('TRANS_RATE',provider['SALE_TRANS_RATE']);
				params.rtnRecord.set('DISCOUNT_RATE',provider['DC_RATE']);

				// 단가구분SET //1:가단가 2:진단가
				params.rtnRecord.set('PRICE_YN',provider['PRICE_TYPE']);
// params.rtnRecord.set('PRICE_TYPE',provider['PRICE_TYPE']);
			}
			// if(params.qty > 0)
			// UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P",
			// dSalePrice);

			if(params.qty > 0 && dSalePrice > 0 ) {
				UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P", dSalePrice)
			} else {
				var dTransRate = Unilite.nvl(params.rtnRecord.get('TRANS_RATE'),1);
				var dOrderQ = Unilite.nvl(params.rtnRecord.get('ORDER_Q'),0);
				var dOrderUnitQ = 0;

				dOrderUnitQ = dOrderQ * dTransRate;
				params.rtnRecord.set('ORDER_UNIT_Q', dOrderUnitQ);
			};
		},
		// UniSales.fnGetItemInfo callback 함수
		cbGetItemInfo: function(provider, params) {
			UniAppManager.app.cbGetPriceInfo(provider, params);
			UniAppManager.app.cbStockQ(provider, params);
		},
		// UniSales.fnStockQ callback 함수
		cbStockQ: function(provider, params) {
			var rtnRecord = params.rtnRecord;
			rtnRecord.set('STOCK_Q', provider['STOCK_Q']);

			var dStockQ = 0;
			var dOrderQ = 0;
			var lTrnsRate = rtnRecord.get('TRANS_RATE');

			if(!Ext.isEmpty(rtnRecord.get('STOCK_Q'))) {
				dStockQ = rtnRecord.get('STOCK_Q');
			}

			if(!Ext.isEmpty(rtnRecord.get('ORDER_Q'))) {
				dOrderQ = rtnRecord.get('ORDER_Q');
			}

			if(dStockQ > 0 ) {
				if(dStockQ > dOrderQ) {   // '재고량 > 수주량
					rtnRecord.set('PROD_SALE_Q'	 ,0);
					rtnRecord.set('PROD_Q'	  ,0);
					rtnRecord.set('PROD_END_DATE'	   ,'');
				} else {
					if(rtnRecord.get('ITEM_ACCOUNT')=="00") {
						rtnRecord.set('PROD_SALE_Q'	 ,0);
						rtnRecord.set('PROD_Q'	  ,0);
						rtnRecord.set('PROD_END_DATE'	   ,'');
					} else {
						if(lTrnsRate > 0 ) {
							rtnRecord.set('PROD_SALE_Q'	 ,((dOrderQ * lTrnsRate - dStockQ) / lTrnsRate));
							rtnRecord.set('PROD_Q'		  ,(dOrderQ * lTrnsRate - dStockQ ) );
							if(BsaCodeInfo.gsProdDate_WS04 == 'N' || Ext.isEmpty(BsaCodeInfo.gsProdDate_WS04))  
								rtnRecord.set('PROD_END_DATE'	, rtnRecord.get('DVRY_DATE'));
							else
								rtnRecord.set('PROD_END_DATE'	,  UniDate.get('today'));
						}
					}
				}
			} else {
				if(rtnRecord.get('ITEM_ACCOUNT')=="00") {
					rtnRecord.set('PROD_SALE_Q'	 ,0);
					rtnRecord.set('PROD_Q'	  ,0);
					rtnRecord.set('PROD_END_DATE'	   ,'');
				} else {
					if(lTrnsRate > 0 ) {
						rtnRecord.set('PROD_SALE_Q'	 ,dOrderQ);
						rtnRecord.set('PROD_Q'		  ,(dOrderQ * lTrnsRate ) );
					}
				}
			}

			if(BsaCodeInfo.gsProdtDtAutoYN=='1') {
				var dProdtQ = 0;
				if(!Ext.isEmpty(rtnRecord.get('PROD_SALE_Q'))) {
					dProdtQ = rtnRecord.get('PROD_SALE_Q');
				}
				if(dProdtQ > 0) {
					if(BsaCodeInfo.gsProdDate_WS04 == 'N' || Ext.isEmpty(BsaCodeInfo.gsProdDate_WS04))  
						rtnRecord.set('PROD_END_DATE'	, rtnRecord.get('DVRY_DATE'));
					else
						rtnRecord.set('PROD_END_DATE'	,  UniDate.get('today'));
				}
			}
			rtnRecord.set('PRICE_YN'	   ,provider['PRICE_TYPE']);
		},
		fnGetCustCredit: function(divCode, customCode, sDate, moneyUnit){
			var param = {"DIV_CODE": divCode, "CUSTOM_CODE": customCode, "SALE_DATE": sDate, "MONEY_UNIT": moneyUnit}
			sof100ukrvService.getCustCredit(param, function(provider, response) {
				var credit = Ext.isEmpty(provider[0]['CREDIT'])? 0 : provider[0]['CREDIT'];
				masterForm.setValue('REMAIN_CREDIT'	, credit);
				panelResult.setValue('REMAIN_CREDIT', credit);
			});
		},
		fnMakeExcelRef: function(records){
			var flag = true;
			if(!this.checkForNewDetail()){
				 flag = false;
				 return false;
			}
			//Detail Grid Default 값 설정
			var orderNum = masterForm.getValue('ORDER_NUM');
			var newDetailRecords = new Array();
			var seq = 0;
			seq = detailStore.max('SER_NO');

			if(Ext.isEmpty(seq)){
				seq = 1;
			} else {
				seq = seq + 1;
			}

			Ext.each(records, function(record,i){
				if(!Ext.isEmpty(record.get('DVRY_DATE'))) {
					if(record.get('DVRY_DATE') < UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE'))) {
						Unilite.messageBox('<t:message code="system.label.sales.deliverydate" default="납기일"/>: ' + '<t:message code="system.message.sales.message037" default="수주일 이후이어야 합니다."/>');
						flag = false;
						return false;
					} else {
						masterForm.setValue('DVRY_DATE'		, record.get('DVRY_DATE')); //납기일
						panelResult.setValue('DVRY_DATE'	, record.get('DVRY_DATE')); //납기일
					}
				}
				if(i == 0){
					seq = seq;
				} else {
					seq += 1;
				}
				var taxType ='1';
				if(masterForm.getValue('BILL_TYPE')=='50' || masterForm.getValue('BILL_TYPE')=='60' || masterForm.getValue('BILL_TYPE')=='50') {
					taxType ='2';
				}

				var outDivCode = '';
				if(!Ext.isEmpty(masterForm.getValue('DIV_CODE'))) {
					outDivCode = masterForm.getValue('DIV_CODE');
				}

				var dvryDate = '';
				if(!Ext.isEmpty(masterForm.getValue('DVRY_DATE'))) {
					dvryDate=masterForm.getValue('DVRY_DATE');
				} else {
					dvryDate= new Date();
				}

				var refOrderDate = '';
				if(!Ext.isEmpty(masterForm.getValue('ORDER_DATE'))) {
					refOrderDate=masterForm.getValue('ORDER_DATE');
				}

				var refOrdCust = '';
				if(!Ext.isEmpty(masterForm.getValue('CUSTOM_CODE'))) {
					refOrdCust=masterForm.getValue('CUSTOM_CODE');
				}

				var customCode = '';
				if(!Ext.isEmpty(masterForm.getValue('SALE_CUST_CD'))) {
					customCode=masterForm.getValue('SALE_CUST_CD');
				} else {
					customCode=masterForm.getValue('CUSTOM_CODE');
				}

				var customName = '';
				if(!Ext.isEmpty(masterForm.getValue('SALE_CUST_NM'))) {
					customName=masterForm.getValue('SALE_CUST_NM');
				} else {
					customName=masterForm.getValue('CUSTOM_NAME');
				}

				var refOrderType = '';
				if(!Ext.isEmpty(masterForm.getValue('ORDER_TYPE'))) {
					refOrderType=masterForm.getValue('ORDER_TYPE');
				}

				var projectNo = '';
				if(!Ext.isEmpty(masterForm.getValue('PROJECT_NO'))) {
					projectNo=masterForm.getValue('PROJECT_NO');
				}

				var refBillType = '';
				if(!Ext.isEmpty(masterForm.getValue('BILL_TYPE'))) {
					refBillType=masterForm.getValue('BILL_TYPE');
				}

				var refReceiptSetMeth = '';
				if(!Ext.isEmpty(masterForm.getValue('RECEIPT_SET_METH'))) {
					refReceiptSetMeth=masterForm.getValue('RECEIPT_SET_METH');
				}
				var r = {
					'ORDER_NUM'				: orderNum,
					'SER_NO'				: seq,
					'OUT_DIV_CODE'			: outDivCode,
					'TAX_TYPE'				: taxType,
					'DVRY_DATE'				: dvryDate,
					'SALE_CUST_CD'			: customCode,
					'CUSTOM_NAME'			: customName,
					'REF_ORDER_DATE'		: refOrderDate,
					'REF_ORD_CUST'			: refOrdCust,
					'REF_ORDER_TYPE'		: refOrderType,
					'PROJECT_NO'			: projectNo,
					'REF_BILL_TYPE'			: refBillType,
					'REF_RECEIPT_SET_METH'	: refReceiptSetMeth
				};
				newDetailRecords[i] = detailStore.model.create( r );
				masterForm.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
				panelTrade.setAllFieldsReadOnly(true);

				if(gsSaveRefFlag == "Y"){
					masterForm.down('#purchaseRequest1').setDisabled(true);
					panelResult.down('#purchaseRequest2').setDisabled(true);
				}
				newDetailRecords[i].set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));
				newDetailRecords[i].set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));
				newDetailRecords[i].set('ITEM_CODE'			, record.get('ITEM_CODE'));
				newDetailRecords[i].set('ITEM_NAME'			, record.get('ITEM_NAME'));
				newDetailRecords[i].set('ITEM_ACCOUNT'		, record.get('ITEM_ACCOUNT'));
				newDetailRecords[i].set('SPEC'				, record.get('SPEC'));
				newDetailRecords[i].set('ORDER_UNIT'		, record.get('ORDER_UNIT'));
				newDetailRecords[i].set('TRANS_RATE'		, record.get('TRNS_RATE'));
				newDetailRecords[i].set('ORDER_Q'			, record.get('QTY'));
				newDetailRecords[i].set('ORDER_P'			, record.get('ORDER_P'));
				//20190621 할인율 계산용 필드 추가
				newDetailRecords[i].set('ORDER_P_CAL'		, record.get('ORDER_P'));
				newDetailRecords[i].set('SCM_FLAG_YN'		, 'N');
				newDetailRecords[i].set('TAX_TYPE'			, '1');
				newDetailRecords[i].set('REF_ORDER_TYPE'	, masterForm.getValue('ORDER_TYPE'));
				newDetailRecords[i].set('REF_PROJECT_NO'	, masterForm.getValue('PROJECT_NO'));
				newDetailRecords[i].set('REF_MONEY_UNIT'	, record.get(''));
				// FIXME gsExchageRate값 설정
				// newDetailRecords[i].set('REF_EXCHG_RATE_O' ,gsExchageRate);
				newDetailRecords[i].set('REF_REMARK'		, masterForm.getValue('REMARK'));
				newDetailRecords[i].set('ORIGIN_Q'			, record.get('QTY'));
				newDetailRecords[i].set('STOCK_UNIT'		, record.get('STOCK_UNIT'));
				newDetailRecords[i].set('REF_WH_CODE'		, record.get('WH_CODE'));
				newDetailRecords[i].set('OUT_WH_CODE'		, record.get('WH_CODE'));//20190118출고창고 추가
				newDetailRecords[i].set('REF_STOCK_CARE_YN', record.get('STOCK_CARE_YN'));
				newDetailRecords[i].set('OUT_DIV_CODE'		, masterForm.getValue('DIV_CODE'));
				newDetailRecords[i].set('WGT_UNIT'			, record.get('WGT_UNIT'));
				newDetailRecords[i].set('UNIT_WGT'			, record.get('UNIT_WGT'));
				newDetailRecords[i].set('VOL_UNIT'			, record.get('VOL_UNIT'));
				newDetailRecords[i].set('UNIT_VOL'			, record.get('UNIT_VOL'));
				newDetailRecords[i].set('OUT_WH_CODE'		, record.get('OUT_WH_CODE'));
				//newDetailRecords[i].set('ORDER_O'			, record.get('QTY'] * record.get('PRICE']);
				newDetailRecords[i].set('ORDER_O'			, record.get('ORDER_O'));
				newDetailRecords[i].set('ORDER_TAX_O'		, record.get('ORDER_TAX_O'));
				newDetailRecords[i].set('ORDER_O_TAX_O'		, record.get('ORDER_O_TAX_O'));
				newDetailRecords[i].set('REMARK_INTER'		, record.get('REMARK_INTER'));
				newDetailRecords[i].set('PROD_END_DATE'		, UniDate.get('today'));

				//20190306 추가
				newDetailRecords[i].set('CARE_YN'			, record.get('CARE_YN'));
				newDetailRecords[i].set('CARE_REASON'		, record.get('CARE_REASON'));

				//20190725 추가
				newDetailRecords[i].set('RECEIVER_NAME'		, record.get('RECEIVER_NAME'));
				newDetailRecords[i].set('INVOICE_NUM'		, record.get('INVOICE_NUM'));

				if(Ext.isEmpty(record.get('INOUT_TYPE_DETAIL'))){ //매출유형(출고유형)
					newDetailRecords[i].set('INOUT_TYPE_DETAIL'	, gsInoutDetailType);
				} else {
					newDetailRecords[i].set('INOUT_TYPE_DETAIL'	, record.get('INOUT_TYPE_DETAIL'));
				}

				var inoutDetailCodeStore =  Ext.data.StoreManager.lookup('chkInoutDetailCode');//출고유형 데이터 확인용 스토어
				Ext.each(inoutDetailCodeStore.data.items, function(comboData, idx) {//lotno팝업에서 선택한 창고가 사용중인 창고이면 선택한 창고로 세팅
					if(comboData.get('value') == newDetailRecords[i].get('INOUT_TYPE_DETAIL')){
						newDetailRecords[i].set('ACCOUNT_YNC'		, comboData.get('refCode1'));
					}
				});
				//UniAppManager.app.onNewDataButtonDown2();
				// detailGrid.setExcelData(record.data);

				UniSales.fnGetItemInfo(
					  newDetailRecords[i]
					, UniAppManager.app.cbGetItemInfo
					, 'I'
					, UserInfo.compCode
					, masterForm.getValue('CUSTOM_CODE')
					, CustomCodeInfo.gsAgentType
					, record.get('ITEM_CODE')
					, BsaCodeInfo.gsMoneyUnit
					, record.get('ORDER_UNIT')
					, record.get('STOCK_UNIT')
					, record.get('TRANS_RATE')
					, UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE'))
					, newDetailRecords[i].get('ORDER_Q')
					, record.get('WGT_UNIT')
					, record.get('VOL_UNIT')
					, record.get('UNIT_WGT')
					, record.get('UNIT_VOL')
					, record.get('PRICE_TYPE')
					//20190625 fnGetPABStock 함수 사용하여 재고 가져오기 위해 변수 추가로 넘김
					, masterForm.getValue('DIV_CODE')	//divCode
					, ''								//bParam3
					, ''								//whCode
					, ''								//useDefaultPrice
					//20190625 fnGetPABStock 함수 사용하여 재고(pab_stock_q) 가져오는 로직 수행
					, BsaCodeInfo.gsPStockYn			//showPstock
				);

				if(!Ext.isEmpty(record['DVRY_DATE'])) {
					newDetailRecords[i].set('DVRY_DATE'		, record['DVRY_DATE']); //납기일
				}
				newDetailRecords[i].set('REMARK'			, record.get('REMARK'));
				// 수주수량/단가(중량) 재계산
				var sUnitWgt   = newDetailRecords[i].get('UNIT_WGT');
				var sOrderWgtQ = newDetailRecords[i].set('ORDER_WGT_Q', (newDetailRecords[i].get('ORDER_Q') * sUnitWgt));

				if( sUnitWgt == 0) {
					newDetailRecords[i].set('ORDER_WGT_P'	, 0);
				} else {
					newDetailRecords[i].set('ORDER_WGT_P'	, (newDetailRecords[i].get('ORDER_P') / sUnitWgt))
				}

				// 수주수량/단가(부피) 재계산
				var sUnitVol   = newDetailRecords[i].get('UNIT_VOL');
				var sOrderVolQ = newDetailRecords[i].set('ORDER_VOL_Q', (newDetailRecords[i].get('ORDER_Q') * sUnitVol));

				if( sUnitVol == 0) {
					newDetailRecords[i].set('ORDER_VOL_P'	, 0);
				} else {
					newDetailRecords[i].set('ORDER_VOL_P'	, (newDetailRecords[i].get('ORDER_P') / sUnitVol))
				}

				// UniAppManager.app.fnStockQ(grdRecord, UserInfo.compCode,
				// grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),
				// grdRecord.get('REF_WH_CODE') );

				newDetailRecords[i].set('DVRY_CUST_CD'			, record.get('DVRY_CUST_CD'));
				newDetailRecords[i].set('DVRY_CUST_NAME'		, record.get('DVRY_CUST_NM'));
			});
			detailStore.loadData(newDetailRecords, true);
			return flag;
		},
		fnGetInoutDetailType: function(selectData, chk){   //20181219 선택한 판매유형에 따라 매출유형 세팅
			if(chk == 'Y'){
				gsInoutDetailType = '';
				gsAccountYnc = '';
				var inoutDetailCodeChkStore =   Ext.data.StoreManager.lookup('chkInoutDetailCode');//출고유형 데이터 확인용 스토어

				Ext.each(inoutDetailCodeChkStore.data.items, function(comboData, idx) {//선택한 판매유형 값과 출고유형 스토어의 refcode6이 같은 출고유형을 세팅
					if (comboData.get('refCode6') == selectData
					 //20190610 refCode7 == 'Y'인 데이터 중에서  판매유형이 같은 값으로 그리드 매출유형 set하도록 수정
					 && comboData.get('refCode7') == 'Y'){
						gsInoutDetailType = comboData.get('value');
						gsAccountYnc = comboData.get('refCode1');
					}
				});

				if(Ext.isEmpty(gsInoutDetailType) || Ext.isEmpty(gsAccountYnc)){
					gsInoutDetailType = '10';
					gsAccountYnc = 'Y';
				}

				if(detailStore.getCount() > 0){
					Ext.each(detailStore.data.items, function(record, idx) {//전역변수에 세팅된 출고유형의 값으로 전체 적용
						record.set('INOUT_TYPE_DETAIL', gsInoutDetailType);
						record.set('ACCOUNT_YNC', gsAccountYnc);
					});
				}
			}
		},
		//20190613 화폐에 따라 컬럼 포맷설정하는 부분 함수로 뺀 후, 여러곳에서 호출하도록 수정
		fnSetColumnFormat: function(newDataFlag) {
			var length = 0
			var format = ''
			if(masterForm.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
				length = Ext.isEmpty(UniFormat.FC.split('.')[1]) ? 0 : UniFormat.FC.split('.')[1].length;
				format = UniFormat.FC;
				//20190619 화폐에 따라 국내외구분 값 set: 20191018 주석 - money_unit listener로 이동
//				masterForm.setValue('NATION_INOUT'	,'2');
//				panelResult.setValue('NATION_INOUT'	,'2');

			} else {
				length = Ext.isEmpty(UniFormat.Price.split('.')[1]) ? 0 : UniFormat.Price.split('.')[1].length;
				format = UniFormat.Price;
				//20190619 화폐에 따라 국내외구분 값 set: 20191018 주석 - money_unit listener로 이동
//				masterForm.setValue('NATION_INOUT'	,'1');
//				panelResult.setValue('NATION_INOUT'	,'1');
			}
			Ext.getCmp('TOT_ORDER_AMT').setConfig('decimalPrecision', length);
			Ext.getCmp('TOT_ORDER_AMT').focus();
			Ext.getCmp('TOT_ORDER_AMT').blur();
			Ext.getCmp('ORDER_O').setConfig('decimalPrecision'		, length);
			Ext.getCmp('ORDER_O').focus();
			Ext.getCmp('ORDER_O').blur();
			Ext.getCmp('ORDER_TAX_O').setConfig('decimalPrecision'	, length);
			Ext.getCmp('ORDER_TAX_O').focus();
			Ext.getCmp('ORDER_TAX_O').blur();
			Ext.getCmp('REMAIN_CREDIT').setConfig('decimalPrecision', length);
			Ext.getCmp('REMAIN_CREDIT').focus();
			Ext.getCmp('REMAIN_CREDIT').blur();
			detailGrid.getColumn("ORDER_O").setConfig('format',format);
			detailGrid.getColumn("ORDER_O").setConfig('decimalPrecision', length);
			//20190906 추가
			if(!Ext.isEmpty(detailGrid.getColumn("ORDER_O").config.editor) && !Ext.isEmpty(detailGrid.getColumn("ORDER_O").config.editor.decimalPrecision)) {
				detailGrid.getColumn("ORDER_O").config.editor.decimalPrecision = length;
			}
			if(!Ext.isEmpty(detailGrid.getColumn("ORDER_O").editor)) {
				detailGrid.getColumn("ORDER_O").editor.decimalPrecision = length;
			}
			detailGrid.getColumn("ORDER_O_TAX_O").setConfig('format',format);
			detailGrid.getColumn("ORDER_O_TAX_O").setConfig('decimalPrecision', length);

			//20210113 로직 수정: 행 추가 시, 화폐단위 / 환율로직 가져오는 로직 수행되지 않도록 처리
			if(isLoad || (!Ext.isEmpty(newDataFlag) && newDataFlag)){
				isLoad = false;
			} else {
				UniAppManager.app.fnExchngRateO();
			}
		}
	});




	var validation = Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "OUT_DIV_CODE" :
					var itemCode = record.get('ITEM_CODE');
					if(itemCode != "") {
						Ext.getBody().mask();
						var param = {'DIV_CODE':newValue, 'ITEM_CODE':itemCode, 'S_COMP_CODE':UserInfo.compCode, 'USELIKE':false, 'TYPE':'VALUE'};
						popupService.divPumokPopup(param, function(provider, response) {
							if(Ext.isEmpty(provider)) {
								Unilite.messageBox('<t:message code="system.message.sales.message035" default="사업장에 대한 품목정보가 존재하지 않습니다."/>');
								Ext.getBody().unmask();
							} else {
								console.log("provider",provider)
								if(!Ext.isEmpty('provider')) detailGrid.setItemData(provider[0],false,record);
								else detailGrid.setItemData(null, true);
							}
						});
						outDivCode=newValue;

						break;
					}
					if(Ext.isEmpty(newValue))  record.get("DIV_CODE") = newValue;

					break;

				case "ORDER_UNIT" :
					UniSales.fnGetPriceInfo2(record, UniAppManager.app.cbGetPriceInfo
													, 'I'
													, UserInfo.compCode
													, masterForm.getValue('CUSTOM_CODE')
													, CustomCodeInfo.gsAgentType
													, record.get('ITEM_CODE')
													, BsaCodeInfo.gsMoneyUnit
													, newValue
													, record.get('STOCK_UNIT')
													, record.get('TRANS_RATE')
													, UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE'))
													, record.get('ORDER_Q')
													, record.get('WGT_UNIT')
													, record.get('VOL_UNIT')
													, record.get('UNIT_WGT')
													, record.get('UNIT_VOL')
													, record.get('PRICE_TYPE')
													);
					UniAppManager.app.fnOrderAmtCal(record, "R");

					break;
				case "PRICE_YN" :
// UniSales.fnGetPriceInfo2(record, UniAppManager.app.cbGetPriceInfo
// , 'I'
// , UserInfo.compCode
// , masterForm.getValue('CUSTOM_CODE')
// , CustomCodeInfo.gsAgentType
// , record.get('ITEM_CODE')
// , BsaCodeInfo.gsMoneyUnit
// , record.get('ORDER_UNIT')
// , record.get('STOCK_UNIT')
// , record.get('TRANS_RATE')
// , UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE'))
// , record.get('ORDER_Q')
// , record.get('WGT_UNIT')
// , record.get('VOL_UNIT')
// , record.get('UNIT_WGT')
// , record.get('UNIT_VOL')
// , newValue
// );
// UniAppManager.app.fnOrderAmtCal(record, "P");
// detailStore.fnOrderAmtSum();
// record.set('DISCOUNT_RATE', 0);
					break;
				case "TRANS_RATE" :	//입수
					if(newValue <= 0) {
						rv= '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('TRANS_RATE',oldValue);
						break
					}

					//생산요청량
					var sOrderQ = Unilite.nvl(newValue,0);
					var sIssueQ = Unilite.nvl(record.get('OUTSTOCK_Q'),0);
					if(sOrderQ < sIssueQ) {
						rv = '<t:message code="system.message.sales.message039" default="납기일 이전이어야 합니다."/>';
						break;
					}
					var dStockQ = 0;
					var dOrderQ = 0;
					var dProdSaleQ = 0;
					var lTrnsRate = newValue;

					if(Ext.isNumeric(record.get('STOCK_Q')))	dStockQ = record.get('STOCK_Q');
					if(Ext.isNumeric(record.get('ORDER_Q')))	dOrderQ = record.get('ORDER_Q');

					//20191001 추가: 수주시 생산량생성기준(WS03)(Y:무조건생성, N:재고량감안생성)
					if(BsaCodeInfo.gsProdSaleQ_WS03 == 'Y') {
						if(record.get('ITEM_ACCOUNT') == '00') {
							record.set('PROD_SALE_Q'	, 0);
							record.set('PROD_Q'			, 0);
							record.set('PROD_END_DATE'	, '');
						} else {
							record.set('PROD_SALE_Q'	, dOrderQ);
							record.set('PROD_Q'			, Unilite.multiply(dOrderQ, lTrnsRate));
							if(BsaCodeInfo.gsProdDate_WS04 == 'N' || Ext.isEmpty(BsaCodeInfo.gsProdDate_WS04))  
								record.set('PROD_END_DATE'	, record.get('DVRY_DATE'));
							else
								record.set('PROD_END_DATE'	,  UniDate.get('today'));
						}
					} else {
						if(record.get('ITEM_ACCOUNT') == '00') {
							record.set('PROD_SALE_Q'	, 0);
							record.set('PROD_Q'			, 0);
							record.set('PROD_END_DATE'	, '');
						} else {
						//20191001: 기존로직
							if(dStockQ > 0) {
								if(dStockQ > Unilite.multiply(dOrderQ, lTrnsRate)) {				// 재고량 > 수주량
									record.set('PROD_SALE_Q'	, 0);
									record.set('PROD_Q'			, 0);
									record.set('PROD_END_DATE'	, '');
								} else if(dStockQ <= Unilite.multiply(dOrderQ, lTrnsRate)) {		// 재고량 <= 수주량
									dProdSaleQ	= (Unilite.multiply(dOrderQ, lTrnsRate) - dStockQ) / lTrnsRate ;
									dProdQ		= (Unilite.multiply(dOrderQ, lTrnsRate) - dStockQ);
									record.set('PROD_SALE_Q', dProdSaleQ);
									record.set('PROD_Q'		, dProdQ);
									if(dProdSaleQ == 0) {
										record.set('PROD_END_DATE', '');
									} else {
										if(BsaCodeInfo.gsProdDate_WS04 == 'N' || Ext.isEmpty(BsaCodeInfo.gsProdDate_WS04))  
											record.set('PROD_END_DATE'	, record.get('DVRY_DATE'));
										else
											record.set('PROD_END_DATE'	,  UniDate.get('today'));
									}
								}
							} else if(dStockQ <= 0 ) {
								record.set('PROD_SALE_Q', dOrderQ);
								record.set('PROD_Q'		, Unilite.multiply(dOrderQ, lTrnsRate));
							}
						}
					}
					//20191010 추가
					if(BsaCodeInfo.gsProdtDtAutoYN == '1') {
						var dProdtQ =Unilite.nvl(record.get('PROD_SALE_Q'), 0);
						if(dProdtQ > 0) {
							if(BsaCodeInfo.gsProdDate_WS04 == 'N' || Ext.isEmpty(BsaCodeInfo.gsProdDate_WS04))  
								record.set('PROD_END_DATE'	, record.get('DVRY_DATE'));
							else
								record.set('PROD_END_DATE'	,  UniDate.get('today'));
						}
					//20191001 수주등록내 생산완료일설정(S031)이 수동일 경우에는 생산요청일 set하지 않음
//					} else {
//						record.set('PROD_END_DATE', record.get('DVRY_DATE'));
					}
					//생산요청량end

					UniSales.fnGetPriceInfo2(record, UniAppManager.app.cbGetPriceInfo
											, 'R'
											, UserInfo.compCode
											, masterForm.getValue('CUSTOM_CODE')
											, CustomCodeInfo.gsAgentType
											, record.get('ITEM_CODE')
											, BsaCodeInfo.gsMoneyUnit
											, record.get('ORDER_UNIT')
											, record.get('STOCK_UNIT')
											, newValue
											, UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE'))
											, record.get('ORDER_Q')
											, record.get('WGT_UNIT')
											, record.get('VOL_UNIT')
											, record.get('UNIT_WGT')
											, record.get('UNIT_VOL')
											, record.get('PRICE_TYPE')
											)
					UniAppManager.app.fnOrderAmtCal(record, "R", newValue);
					break;

				case "ORDER_Q" :  //수주량
					if(newValue <= 0) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('ORDER_Q',oldValue);
						break
					}

					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName,'<t:message code="system.label.sales.soqty" default="수주량"/>') ) {
						record.set('ORDER_Q',oldValue, fieldName);
						break;
					}

					var sOrderQ = Unilite.nvl(newValue,0);
					var sIssueQ = Unilite.nvl(record.get('OUTSTOCK_Q'),0);
					if(sOrderQ < sIssueQ) {
						rv = '<t:message code="system.message.sales.message039" default="납기일 이전이어야 합니다."/>';
						break;
					}
					var dStockQ = 0;
					var dOrderQ = 0;
					var dProdSaleQ = 0;
					var lTrnsRate = record.get('TRANS_RATE');

					if(Ext.isNumeric(record.get('STOCK_Q')))	dStockQ = record.get('STOCK_Q');
					if(Ext.isNumeric(record.get('ORDER_Q')))	dOrderQ = newValue;


					//20191001 추가: 수주시 생산량생성기준(WS03)(Y:무조건생성, N:재고량감안생성)
					if(BsaCodeInfo.gsProdSaleQ_WS03 == 'Y') {
						if(record.get('ITEM_ACCOUNT') == '00') {
							record.set('PROD_SALE_Q'	, 0);
							record.set('PROD_Q'			, 0);
							record.set('PROD_END_DATE'	, '');
						} else {
							record.set('PROD_SALE_Q'	, newValue);
							record.set('PROD_Q'			, Unilite.multiply(newValue, lTrnsRate));
							if(BsaCodeInfo.gsProdDate_WS04 == 'N' || Ext.isEmpty(BsaCodeInfo.gsProdDate_WS04))  
								record.set('PROD_END_DATE'	, record.get('DVRY_DATE'));
							else
								record.set('PROD_END_DATE'	,  UniDate.get('today'));
						}
					} else {
						if(record.get('ITEM_ACCOUNT') == '00') {
							record.set('PROD_SALE_Q'	, 0);
							record.set('PROD_Q'			, 0);
							record.set('PROD_END_DATE'	, '');
						} else {
							//20191001: 기존로직
							if(dStockQ > 0) {
								if(dStockQ > Unilite.multiply(dOrderQ, lTrnsRate)) {				// 재고량 > 수주량
									record.set('PROD_SALE_Q', 0);
									record.set('PROD_Q', 0);
									record.set('PROD_END_DATE', '');
								} else if(dStockQ <= Unilite.multiply(dOrderQ, lTrnsRate)) {		// 재고량 <= 수주량
									dProdSaleQ	= (Unilite.multiply(dOrderQ, lTrnsRate) - dStockQ) / lTrnsRate ;
									dProdQ		= (Unilite.multiply(dOrderQ, lTrnsRate) - dStockQ);
									record.set('PROD_SALE_Q', dProdSaleQ);
									record.set('PROD_Q'		, dProdQ);
									if(dProdSaleQ == 0) {
										record.set('PROD_END_DATE', '');
									} else {
										if(BsaCodeInfo.gsProdDate_WS04 == 'N' || Ext.isEmpty(BsaCodeInfo.gsProdDate_WS04))  
											record.set('PROD_END_DATE'	, record.get('DVRY_DATE'));
										else
											record.set('PROD_END_DATE'	,  UniDate.get('today'));
									}
								}
							} else if(dStockQ <= 0 ) {
								record.set('PROD_SALE_Q', dOrderQ);
								record.set('PROD_Q'		, Unilite.multiply(dOrderQ, lTrnsRate));
							}
						}
					}

					UniAppManager.app.fnOrderAmtCal(record, "Q", newValue);
					detailStore.fnOrderAmtSum();
					if(BsaCodeInfo.gsProdtDtAutoYN == '1') {
						var dProdtQ =Unilite.nvl(record.get('PROD_SALE_Q'), 0);
						if(dProdtQ > 0) {
							if(BsaCodeInfo.gsProdDate_WS04 == 'N' || Ext.isEmpty(BsaCodeInfo.gsProdDate_WS04))  
								record.set('PROD_END_DATE'	, record.get('DVRY_DATE'));
							else
								record.set('PROD_END_DATE'	,  UniDate.get('today'));
						}
					//20191001 수주등록내 생산완료일설정(S031)이 수동일 경우에는 생산요청일 set하지 않음
//					} else {
//						record.set('PROD_END_DATE', record.get('DVRY_DATE'));
					}

					break;

				case "ORDER_P" :
					var accountYnc = record.get('ACCOUNT_YNC');
					if(accountYnc == 'Y'){//매출대상일 경우에만 양수체크
					   if(newValue <= 0) {
						  rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						  record.set('ORDER_P',oldValue);
						  break
					   }
					}
					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName,'<t:message code="system.label.sales.eachprice" default="개별단가"/>') ) {
						record.set('ORDER_P',oldValue);
						break;
					}
					//20190621 계산용 필드에 값 set
					record.set('ORDER_P_CAL',newValue);
					UniAppManager.app.fnOrderAmtCal(record, "P", newValue)
					detailStore.fnOrderAmtSum();
					record.set('DISCOUNT_RATE', 0);
					break;

				case "ORDER_O" :
					rv = true;
					if(oldValue == newValue){
						rv = false;
						break;
					}
					var accountYnc = record.get('ACCOUNT_YNC');
					if(accountYnc == 'Y'){//매출대상일 경우에만 양수체크
						if(newValue <= 0) {
							rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							record.set('ORDER_O',oldValue);
							rv = false;
							break
						}
					}
					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName,'<t:message code="system.label.sales.amount" default="금액"/>') ) {
						record.set('ORDER_O',oldValue);
						rv = false;
						break;
					}
					var dTaxAmtO = Unilite.nvl(record.get('ORDER_TAX_O'),0);
					if(newValue > 0 && dTaxAmtO > newValue)	 {
						rv='<t:message code="system.message.sales.message040" default="매출금액은 세액보다 커야 합니다."/>';
					} else {
						UniAppManager.app.fnOrderAmtCal(record, "O", newValue);
						detailStore.fnOrderAmtSum();
						//rv = false;
						break;
					}
					break;

				//20210611 추가: 합계금액 수정 가능하도록 변경
				case "ORDER_O_TAX_O" :
					rv = true;
					if(oldValue == newValue){
						rv = false;
						break;
					}
					var accountYnc = record.get('ACCOUNT_YNC');
					if(accountYnc == 'Y'){//매출대상일 경우에만 양수체크
						if(newValue <= 0) {
							rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							record.set('ORDER_O', oldValue);
							rv = false;
							break
						}
					}
					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName,'<t:message code="system.label.sales.sototalsum" default="수주합계"/>')) {
						record.set('ORDER_O', oldValue);
						rv = false;
						break;
					}
					var dTaxAmtO = Unilite.nvl(record.get('ORDER_TAX_O'),0);
					if(newValue > 0 && dTaxAmtO > newValue)	 {
						rv='<t:message code="system.message.sales.message040" default="매출금액은 세액보다 커야 합니다."/>';
					} else {
						var sTaxInoutType		= Ext.isEmpty(Ext.getCmp('taxInout').getChecked())? '1' : Ext.getCmp('taxInout').getChecked()[0].inputValue;	//세액포함여부
						var dVatRate			= parseInt(BsaCodeInfo.gsVatRate);																				//세율
						var sWonCalBas			= CustomCodeInfo.gsUnderCalBase;																				//원단위 계산(올림, 반올림, 버림)
						if(masterForm.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
							var digit			= UniFormat.FC.indexOf(".") == -1 ? UniFormat.FC.length : UniFormat.FC.indexOf(".") + 1;
							var numDigitOfPrice	= UniFormat.FC.length - digit;
						} else {
							var digit			= UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
							var numDigitOfPrice	= UniFormat.Price.length - digit;
						}
						var sTaxtype			= record.get('TAX_TYPE');																						//과세구분
						var dOrderAmtO			= 0;
						var dTaxAmtO			= 0;
						var dOrderP				= record.get('ORDER_P');
	
						dTaxAmtO			= newValue * dVatRate / (100 + dVatRate);								//세액
						dTaxAmtO			= UniSales.fnAmtWonCalc(dTaxAmtO, sWonCalBas, numDigitOfPrice);			//세액 끝전 처리
						dOrderAmtO			= newValue - dTaxAmtO													//공급가액
						if(dOrderP == 0) {		//단가는 0일 때만 변경
							if(sTaxInoutType == '1') {																//별도
								dOrderP = UniSales.fnAmtWonCalc(dOrderAmtO / record.get('ORDER_Q'), sWonCalBas, 0);
							} else if(sTaxInoutType == '2') {
								dOrderP = UniSales.fnAmtWonCalc(newValue / record.get('ORDER_Q'), sWonCalBas, 0);
							}
						} else if(BsaCodeInfo.gsSiteCode == 'WM') {		// 20210715 추가: 월드메모리는 0이아니어도 적용
							if(sTaxInoutType == '1') {																// 별도
								dOrderP = UniSales.fnAmtWonCalc(dOrderAmtO / record.get('ORDER_Q'), sWonCalBas, 0);
							} else if(sTaxInoutType == '2') {
								dOrderP = UniSales.fnAmtWonCalc(newValue / record.get('ORDER_Q'), sWonCalBas, 0);
							}
						}
						if(sTaxtype == '2' || sTaxtype == '3') {
							dOrderAmtO	= newValue;
							dTaxAmtO	= 0;
							if(dOrderP == 0) {	//단가는 0일 때만 변경
								dOrderP	= UniSales.fnAmtWonCalc(newValue / record.get('ORDER_Q'), sWonCalBas, 0);
							}
						}
						record.set('ORDER_P'	, dOrderP);
						record.set('ORDER_O'	, dOrderAmtO);
						record.set('ORDER_TAX_O', dTaxAmtO);
						//합계 표시하는 로직 실행
						detailStore.fnOrderAmtSum();
						break;
					}
					break;

				case "DISCOUNT_MONEY" :
				case "TAX_TYPE" :
					if(masterForm.getValue('BILL_TYPE')=="50") {
						rv='<t:message code="system.message.sales.message041" default="부가세유형이 영세매출일때 해당 과세구분은 선택할 수 없습니다."/>';
						record.set('TAX_TYPE', '2');
					}
					// 업종별 프로세스 적용
					if(BsaCodeInfo.gsProcessFlag == 'PG') {
						var dOrderO=record.get('ORDER_Q')*record.get('ORDER_P')*record.get('TRANS_RATE');
						record.set('ORDER_O', dOrderO);
					} else {
						var dOrderO=record.get('ORDER_Q')*record.get('ORDER_P');
						record.set('ORDER_O', dOrderO);
					}
					UniAppManager.app.fnOrderAmtCal(record, "O", dOrderO, newValue);
					detailStore.fnOrderAmtSum();

					break;

				case "ORDER_TAX_O" :
					if(newValue <= 0) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('ORDER_TAX_O',oldValue);
						break
					}

					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName, '<t:message code="system.label.sales.vatamount" default="부가세액"/>')) {
						record.set('ORDER_TAX_O', oldValue);
					}
					var dSaleAmtO = Unilite.nvl(record.get('ORDER_O'),0);
					if(dSaleAmtO > 0) {
						if( dSaleAmtO < newValue) {
							rv='<t:message code="system.message.sales.message036" default="세액은 매출액보다 작아야 합니다."/>';
							break;
						}
					}
					//20190621 세액 변경 시, 수주합계 계산로직 수정
					var dOrderOTaxO = record.get('ORDER_O') + newValue;
					record.set('ORDER_O_TAX_O', dOrderOTaxO);
					break;

				case "DVRY_DATE" :
					if(newValue < masterForm.getValue('ORDER_DATE')) {
						rv = '<t:message code="system.message.sales.message037" default="수주일 이후이어야 합니다."/>';
						break;
					}

					if(Ext.isNumeric(record.get('PROD_SALE_Q')) && record.get('PROD_SALE_Q')==0) {
						record.set('PROD_END_DATE', '');
					} else {
						record.set('PROD_END_DATE', newValue);
					}
					break;

				case "DISCOUNT_RATE" :
					if(newValue < 0) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('DISCOUNT_RATE', oldValue);
						break;
					}
					UniAppManager.app.fnOrderAmtCal(record, "C", newValue);
					detailStore.fnOrderAmtSum();
					break;

				case "ACCOUNT_YNC" :
					if(record.phantom && !Ext.isEmpty(record.get('PRE_ACCNT_YN'))) {
						if(newValue != record.get('PRE_ACCNT_YN')) {
							if(confirm('<t:message code="system.message.sales.message042" default="수주내역의 매출대상이 변경되었습니다."/>'+'/n'+'<t:message code="system.message.sales.message043" default="계속하시겠습니까?"/>')) {
								record.set('REF_FLAG', newValue);
							} else {
								record.set('REF_FLAG', 'F');
							}
						} else {
							record.set('REF_FLAG', 'F');
						}
					}

					break;

				case "PROD_SALE_Q" :   //생산요청량
					if(!Ext.isEmpty(record.get('PROD_END_DATE'))) {
						if(Ext.isEmpty(newValue) || newValue == 0) {
							rv='<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>';
							break;
						}
					}

					var lTrnsRate = record.get("TRANS_RATE");
					var chkValue=0;
					var dProdQ=0;

					if(newValue  < 0 ) {
						rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('PROD_SALE_Q', oldValue);
						if(Ext.isEmpty(oldValue))   oldValue = 0;
						record.set('PROD_Q', (oldValue*lTrnsRate));
						break;
					}

					if(!Ext.isNumeric(newValue) || newValue==0) {
						record.set('PROD_END_DATE','');
						record.set('PROD_SALE_Q',0);
						record.set('PROD_Q',0);
					} else {
						if(BsaCodeInfo.gsProdDate_WS04 == 'N' || Ext.isEmpty(BsaCodeInfo.gsProdDate_WS04))  
							record.set('PROD_END_DATE'	, record.get('DVRY_DATE'));
						else
							record.set('PROD_END_DATE'	,  UniDate.get('today'));
						record.set('PROD_Q',(newValue*lTrnsRate) );
					}
					break;

				case "PROD_END_DATE" :
					if( Ext.isEmpty(newValue) ) record.set('PROD_END_DATE', oldValue);
					break;

					if(newValue < masterForm.getValue('ORDER_DATE')) {
						rv =  '<t:message code="system.message.sales.message037" default="수주일 이후이어야 합니다."/>';
						if(BsaCodeInfo.gsProdDate_WS04 == 'N' || Ext.isEmpty(BsaCodeInfo.gsProdDate_WS04))  
							record.set('PROD_END_DATE'	, record.get('DVRY_DATE'));
						else
							record.set('PROD_END_DATE'	,  UniDate.get('today'));
						break;
					}

					if(newValue > record.get('DVRY_DATE')) {
						rv = '<t:message code="system.message.sales.message038" default="납기일 이전이어야 합니다."/>';
						if(BsaCodeInfo.gsProdDate_WS04 == 'N' || Ext.isEmpty(BsaCodeInfo.gsProdDate_WS04))  
							record.set('PROD_END_DATE'	, record.get('DVRY_DATE'));
						else
							record.set('PROD_END_DATE'	,  UniDate.get('today'));
						break;
					}
					break;
				case "UPN_CODE" :
    				var param = {
                                COMP_CODE   : UserInfo.compCode,
                                DIV_CODE    : masterForm.getValue('DIV_CODE'),
                                ITEM_CODE   : record.get('ITEM_CODE')
                            }
                    if( masterForm.getValue('MONEY_UNIT')== "JPY") {
                        sof100ukrvService.checkUpnCode(param, function(provider2, response){
                            if(Ext.isEmpty(provider2) || provider2.data.UPN_CODE == ""){
                                Unilite.messageBox('['+ record.get('ITEM_CODE')+ ']' + '해당 품목에 UPN 코드가 존재하지 않습니다. 품목정보를 확인 부탁드립니다.');
                                record.set('UPN_CODE',"");
                                 return false;
                            }
                        });
                    }

                    break;
			}
			return rv;
		}
	}); // validator
}
</script>
<form id="exportform" method="get" target="_blank">
		<input type="hidden" id="fid" name="fid" value="" />
		<input type="hidden" name="inline" value="N" />
</form>