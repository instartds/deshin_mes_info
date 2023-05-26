<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sof101ukrv_yp"  >
<t:ExtComboStore comboType="AU" comboCode="T019"/>  <!-- 국내외		-->
<t:ExtComboStore comboType="AU" comboCode="B004"/>  <!-- 화폐단위		-->
<t:ExtComboStore comboType="AU" comboCode="S002"/>  <!-- 수주구분		-->
<t:ExtComboStore comboType="AU" comboCode="S007"/>  <!-- 출고유형		-->
<t:ExtComboStore comboType="AU" comboCode="B013"/>  <!-- 판매단위		-->
<t:ExtComboStore comboType="AU" comboCode="B059"/>  <!-- 과세여부		-->
<t:ExtComboStore comboType="AU" comboCode="S014"/>  <!-- 계산서대상  -->
<t:ExtComboStore comboType="AU" comboCode="S003"/>  <!-- 단가구분		-->
<t:ExtComboStore comboType="AU" comboCode="S011"/>  <!-- 수주상태		-->
<t:ExtComboStore comboType="AU" comboCode="S010"/>  <!-- 담당자		-->
<t:ExtComboStore comboType="AU" comboCode="B038"/>  <!-- 결제방법		-->
<t:ExtComboStore comboType="AU" comboCode="S024"/>  <!-- 부가세유형  -->
<t:ExtComboStore comboType="AU" comboCode="S046"/>  <!-- 승인상태		-->
<t:ExtComboStore comboType="AU" comboCode="B030"/>  <!-- 세액포함여부	 -->
<t:ExtComboStore comboType="AU" comboCode="B116"/>  <!-- 단가계산기준	 -->
<t:ExtComboStore comboType="AU" comboCode="S065"/>  <!-- 주문구분		-->
<t:ExtComboStore comboType="AU" comboCode="WB06" /> <!--B/OUT관리여부-->
<t:ExtComboStore comboType="AU" comboCode="B010"/>  <!-- 예/아니오  -->

<t:ExtComboStore comboType="AU" comboCode="T005"/>  <!--가격조건-->
<t:ExtComboStore comboType="AU" comboCode="T006"/>  <!--결제조건-->
<t:ExtComboStore comboType="AU" comboCode="T016"/>  <!-- 대금결제방법  -->
<t:ExtComboStore comboType="AU" comboCode="T004"/>
<t:ExtComboStore comboType="AU" comboCode="T010"/>
<t:ExtComboStore comboType="AU" comboCode="T011"/>
<t:ExtComboStore comboType="AU" comboCode="T008"/>
<t:ExtComboStore comboType="AU" comboCode="Z011"/>	<!-- 20210913:jhj 농공산구분  -->
<t:ExtComboStore comboType="BOR120" pgmId="s_sof101ukrv_yp"/><!-- 사업장	-->
<t:ExtComboStore items="${CAL_NO}" storeId="s_bpr300ukrv_ypCAL_NO" />
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>

<script type="text/javascript">

var SearchInfoWindow;			//SearchInfoWindow : 검색창
var referEstimateWindow;		//견적참조
var referOrderRecordWindow;		//수주이력참조
var excelWindow;				// 엑셀참조
var contextMenu;
var isLoad = false;				//로딩 플래그 화폐단위 환율 change 로드시 계속 타므로 임시로 막음
var gsSaveRefFlag	= 'N';		//검색후에만 수정 가능하게 조회버튼 활성화..
var tempIndex		= 0;		//미등록상품 확인용..
var outDivCode		= UserInfo.divCode;
var gsI=0;

var gsReturnMaxI= 1;
var gsReturnI	= -1;
//일별 납기일 저장할 변수 선언
var queryYear   = '';
var gsDvryDate1 = '';
var gsDvryDate2 = '';
var gsDvryDate3 = '';
var gsDvryDate4 = '';
var gsDvryDate5 = '';
var gsDvryDate6 = '';
var gsDvryDate7 = '';
var gsReturnChk = 'N';
//controller에서 값을 받아서옴 model.Attribut()
var BsaCodeInfo = {
	gsBalanceOut	: '${gsBalanceOut}',
	gsCreditYn		: '${gsCreditYn}',
	gsAutoType		: '${gsAutoType}',
	gsMoneyUnit		: '${gsMoneyUnit}',
	gsVatRate		: ${gsVatRate},
	gsProdtDtAutoYN	: '${gsProdtDtAutoYN}',
	gsSaleAutoYN	: '${gsSaleAutoYN}',
	gsSof100ukrLink	: '${gsSof100ukrLink}',
	gsSrq100UkrLink	: '${gsSrq100UkrLink}',
	gsStr100UkrLink	: '${gsStr100UkrLink}',
	gsSsa100UkrLink	: '${gsSsa100UkrLink}',
	gsProcessFlag	: '${gsProcessFlag}',
	gsCondShowFlag	: '${gsCondShowFlag}',
	gsDraftFlag		: '${gsDraftFlag}',
	gsApp1AmtInfo	: ${gsApp1AmtInfo},
	gsApp2AmtInfo	: ${gsApp2AmtInfo},
	gsTimeYN		: '${gsTimeYN}',
	gsScmUseYN		: '${gsScmUseYN}',
	gsPjtCodeYN		: '${gsPjtCodeYN}',
	gsPointYn		: '${gsPointYn}',
	gsUnitChack		: '${gsUnitChack}',
	gsPriceGubun	: '${gsPriceGubun}',
	gsWeight		: '${gsWeight}',
	gsVolume		: '${gsVolume}',
	gsOrderTypeSaleYN: '${gsOrderTypeSaleYN}'
};

var CustomCodeInfo = {
	gsAgentType		: '',
	gsCustCrYn		: '',
	gsUnderCalBase	: '',
	gsRefTaxInout	: ''
};

//var output ='';
//for(var key in BsaCodeInfo){
//	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

function appMain() {
	// 자동채번 여부
	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoOrderNum = true;
	}

	// 수주승인 방식
	var isDraftFlag = true;
	if(BsaCodeInfo.gsDraftFlag=='1')	{
		isDraftFlag = false;
	}



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_sof101ukrv_ypService.selectDetailList',
			update	: 's_sof101ukrv_ypService.updateDetail',
			create	: 's_sof101ukrv_ypService.insertDetail',
			destroy	: 's_sof101ukrv_ypService.deleteDetail',
			syncAll	: 's_sof101ukrv_ypService.saveAll'
		}
	});



	/** 수주의 디테일 정보를 가지고 있는 Model
	 */
	Unilite.defineModel('s_sof101ukrv_ypDetailModel', {
		fields: [
			{name: 'DIV_CODE'				, text:'<t:message code="unilite.msg.sMS631"		default="사업장"/>'			, type: 'string', allowBlank: false, comboType: 'BOR120', defaultValue: UserInfo.divCode},
			{name: 'ORDER_NUM'				, text:'<t:message code="unilite.msg.sMS533"		default="수주번호"/>'			, type: 'string', allowBlank: isAutoOrderNum /*, isPk:true, pkGen:'user'*/},
			{name: 'SER_NO'					, text:'<t:message code="unilite.msg.sMSR003"		default="순번"/>'				, type: 'int', allowBlank: true , editable:false},
			{name: 'OUT_DIV_CODE'			, text:'<t:message code="unilite.msg.sMSR291"		default="출고사업장"/>'			, type: 'string', allowBlank: false , comboType: 'BOR120'},
			{name: 'SO_KIND'				, text:'<t:message code="unilite.msg.fSbMsgS0070"	default="주문구분"/>'			, type: 'string', allowBlank: false , comboType: 'AU', comboCode: 'S065', defaultValue: '10'},
			{name: 'ITEM_CODE'				, text:'<t:message code="unilite.msg.sMS501"		default="품목코드"/>'			, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'				, text:'<t:message code="unilite.msg.sMS688"		default="품명"/>'				, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text:'<t:message code="unilite.msg.sMS763"		default="품목계정"/>'			, type: 'string'},
			{name: 'SPEC'					, text:'<t:message code="unilite.msg.sMSR033"		default="규격"/>'				, type: 'string', editable:false},
			{name: 'ORDER_UNIT'				, text:'<t:message code="unilite.msg.sMS690"		default="판매단위"/>'			, type: 'string', allowBlank: false , comboType: 'AU', comboCode: 'B013', displayField: 'value'},
			{name: 'PRICE_TYPE'				, text:'<t:message code="unilite.msg.sMS767"		default="단가구분"/>'			, type: 'string', defaultValue: BsaCodeInfo.gsPriceGubun, comboType:'AU', comboCode:'B116'},
			{name: 'TRANS_RATE'				, text:'<t:message code="unilite.msg.sMSR010"		default="입수"/>'				, type: 'uniQty', allowBlank: false, defaultValue: 1},
			{name: 'ORDER_WGT_Q'			, text:'수주량(중량)'																, type: 'int', defaultValue: 0},
			{name: 'ORDER_WGT_P'			, text:'단가(중량)'																	, type: 'int', defaultValue: 0},
			{name: 'ORDER_VOL_Q'			, text:'수주량(부피)'																, type: 'int', defaultValue: 0},
			{name: 'ORDER_VOL_P'			, text:'단가(부피)'																	, type: 'int', defaultValue: 0},
			{name: 'TAX_TYPE'				, text:'<t:message code="unilite.msg.sMSR289"		default="과세구분"/>'			, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'B059'},
			{name: 'WGT_UNIT'				, text:'<t:message code="unilite.msg.sMR202"		default="중량단위"/>'			, type: 'string', defaultValue: BsaCodeInfo.gsWeight},
			{name: 'UNIT_WGT'				, text:'<t:message code="unilite.msg.sMR201"		default="단위중량"/>'			, type: 'int', defaultValue: 0},
			{name: 'VOL_UNIT'				, text:'부피단위'																	, type: 'string', defaultValue: BsaCodeInfo.gsVolume},
			{name: 'UNIT_VOL'				, text:'단위부피'																	, type: 'int', defaultValue: 0},
			{name: 'DISCOUNT_RATE'			, text:'<t:message code="unilite.msg.sMS716"		default="할인율(%)"/>'			, type: 'uniPercent'},
			{name: 'ACCOUNT_YNC'			, text:'<t:message code="unilite.msg.sMSR049"		default="매출대상"/>'			, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'S014',  defaultValue: 'Y'},
			{name: 'SALE_CUST_CD'			, text:'<t:message code="unilite.msg.sMS665"		default="매출처"/><t:message code="unilite.msg.sMS603" default="코드"/>'				, type: 'string', allowBlank: false},
			{name: 'CUSTOM_NAME'			, text:'<t:message code="unilite.msg.sMS665"		default="매출처"/>'			, type: 'string', allowBlank: false},
			{name: 'PRICE_YN'				, text:'<t:message code="unilite.msg.sMS767"		default="단가구분"/>'			, type: 'string', allowBlank: false , comboType: 'AU', comboCode: 'S003', defaultValue:'2'},
			{name: 'STOCK_Q'				, text:'<t:message code="unilite.msg.sMS768"		default="재고수량"/>'			, type: 'uniQty', editable:false},
			{name: 'DVRY_CUST_CD'			, text:'<t:message code="unilite.msg.sMSR293"		default="배송처"/><t:message code="unilite.msg.sMS603" default="코드"/>'			  , type: 'string'},
			{name: 'DVRY_CUST_NAME'			, text:'<t:message code="unilite.msg.sMSR293"		default="배송처"/>'			, type: 'string'},
			{name: 'ORDER_STATUS'			, text:'<t:message code="unilite.msg.sMS771"		default="강제마감"/>'			, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'S011', defaultValue: 'N'},
			{name: 'PO_NUM'					, text:'<t:message code="unilite.msg.sMSR281"		default="PO번호"/>'			, type: 'string'},
			{name: 'PO_SEQ'					, text:'<t:message code="unilite.msg.sMS772" 		default="P/O 순번"/>'			, type: 'int'},
			{name: 'PROJECT_NO'				, text:'<t:message code="unilite.msg.sMR049" 		default="프로젝트번호"/>'			, type: 'string'},
			{name: 'RETURN_Q'				, text:'RETURN_Q'																, type: 'int', defaultValue: 0},
//			{name: 'SALE_Q'					, text:'SALE_Q'																	, type: 'int', defaultValue: 0},
			{name: 'PROD_PLAN_Q'			, text:'PROD_PLAN_Q'															, type: 'int'},
			{name: 'ESTI_NUM'				, text:'<t:message code="unilite.msg.sMS538" default="견적번호"/>'					, type: 'string', editable:false},
			{name: 'ESTI_SEQ'				, text:'<t:message code="unilite.msg.sMS773" default="견적순번"/>'					, type: 'int', editable:false},
			{name: 'STOCK_UNIT'				, text:'STOCK_UNIT'																, type: 'string'},
			{name: 'PRE_ACCNT_YN'			, text:'PRE_ACCNT_YN'															, type: 'string', defaultValue: 'Y'},
			{name: 'REF_ORDER_DATE'			, text:'REF_ORDER_DATE'															, type: 'string'},
			{name: 'REF_ORD_CUST'			, text:'REF_ORD_CUST'															, type: 'string'},
			{name: 'REF_ORDER_TYPE'			, text:'REF_ORDER_TYPE'															, type: 'string'},
			{name: 'REF_PROJECT_NO'			, text:'REF_PROJECT_NO'															, type: 'string'},
			{name: 'REF_TAX_INOUT'			, text:'REF_TAX_INOUT'															, type: 'string', defaultValue: '1'},
			{name: 'REF_MONEY_UNIT'			, text:'REF_MONEY_UNIT'															, type: 'string', defaultValue: BsaCodeInfo.gsMoneyUnit},
			{name: 'REF_EXCHG_RATE_O'		, text:'REF_EXCHG_RATE_O'														, type: 'int', defaultValue: 1},
			{name: 'REF_REMARK'				, text:'REF_REMARK'																, type: 'string'},
			{name: 'REF_BILL_TYPE'			, text:'REF_BILL_TYPE'															, type: 'string'},
			{name: 'REF_RECEIPT_SET_METH'	, text:'REF_RECEIPT_SET_METH'													, type: 'string'},
			{name: 'ORIGIN_Q'				, text:'ORIGIN_Q'																, type: 'int'},
			{name: 'REF_STOCK_CARE_YN'		, text:'REF_STOCK_CARE_YN'														, type: 'string'},
			{name: 'REF_WH_CODE'			, text:'REF_WH_CODE'															, type: 'string'},
			{name: 'REF_FLAG'				, text:'REF_FLAG'																, type: 'string', defaultValue: 'F'},
			{name: 'REF_ORDER_PRSN'			, text:'REF_ORDER_PRSN'															, type: 'string'},
			{name: 'REF_DVRY_CUST_NM'		, text:'REF_DVRY_CUST_NM'														, type: 'string'},
			{name: 'REQ_ISSUE_QTY'			, text:'REQ_ISSUE_QTY'															, type: 'int', defaultValue: '0'},
			{name: 'COMP_CODE'				, text:'COMP_CODE'																, type: 'string', allowBlank: false , defaultValue: UserInfo.compCode},
			{name: 'REMARK'					, text:'<t:message code="unilite.msg.sMS742" default="비고"/>'					, type: 'string'},
			{name: 'STOCK_Q_TY'				, text:'STOCK_Q_TY'																, type: 'string'},
			{name: 'SCM_FLAG_YN'			, text:'SCM_FLAG_YN'															, type: 'string', defaultValue:'N'},
			{name: 'BARCODE'				, text:'바코드'																	, type: 'string'},
			{name: 'DISCOUNT_MONEY'			, text:'할인가'																	, type: 'uniPrice'},
			{name: 'AGENT_TYPE'				, text:'AGENT_TYPE'																, type: 'string'},
			{name: 'CREDIT_YN'				, text:'CREDIT_YN'																, type: 'string'},
			{name: 'WON_CALC_BAS'			, text:'WON_CALC_BAS'															, type: 'string'},
			{name: 'OUT_WH_CODE'			, text:'출고창고'																	, type: 'string'},
			{name: 'CUSTOM_ITEM_CODE'		, text:'주문상품코드'																	, type: 'string'},
			{name: 'CUSTOM_ITEM_NAME'		, text:'주문상품명'																	, type: 'string'},
			{name: 'CUSTOM_ITEM_DESC'		, text:'주문상품 설명'																, type: 'string'},

			{name: 'DVRY_DATE'				, text:'<t:message code="unilite.msg.sMS510" default="납기일"/>'					, type: 'uniDate', allowBlank: true},
			{name: 'ORDER_P'				, text:'단가'																		, type: 'uniUnitPrice', allowBlank: false, defaultValue: 0},
			{name: 'ORDER_Q'				, text:'총수주량'					, type: 'uniQty', allowBlank: true, defaultValue: 0},
			{name: 'PROD_END_DATE'			, text:'<t:message code="unilite.msg.sMS770" default="생산완료일"/>'					, type: 'uniDate'},
			{name: 'EXP_ISSUE_DATE'			, text:'출하예정일'																	, type: 'uniDate'},
			//20210913 jhj:컬럼추가
			{name: 'GOODS_DIVISION'			, text:'농공산구분'																	, type: 'string', comboType: 'AU', comboCode: 'Z011'},

			{name: 'ORDER_O'				, text:'<t:message code="unilite.msg.sMS681" default="금액"/>'					, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_TAX_O'			, text:'<t:message code="unilite.msg.sMS764" default="부가세액"/>'					, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_O_TAX_O'			, text:'<t:message code="unilite.msg.sMS765" default="수주합계"/>'					, type: 'uniPrice', defaultValue: 0, editable:false},
			{name: 'PROD_SALE_Q'			, text:'생산요청량'																	, type: 'uniQty'},
			{name: 'PROD_Q'					, text:'<t:message code="unilite.msg.sMS769"		default="생산요청량(재고단위)"/>'	, type: 'uniQty'},
			{name: 'OUTSTOCK_Q'				, text:'출고량'																	, type: 'uniQty', defaultValue: 0},
			{name: 'ORDER_UNIT_Q'			, text:'ORDER_UNIT_Q'															, type: 'uniQty', allowBlank: true},

			{name: 'NEW_YN1'				, text:'저장flag'																	, type: 'string'},
			{name: 'SER_NO1'				, text:'순번'																		, type: 'int'},
			{name: 'ORDER_Q1'				, text:'수주량'																	, type: 'uniQty'	, allowBlank: true},
			{name: 'DVRY_DATE1'				, text:'<t:message code="unilite.msg.sMS510" default="납기일"/>'					, type: 'uniDate', allowBlank: true},
			{name: 'PROD_END_DATE1'			, text:'생산완료일'																	, type: 'uniDate'},
			{name: 'EXP_ISSUE_DATE1'		, text:'출하예정일'																	, type: 'uniDate'},
			//20210913 jhj:컬럼추가
			{name: 'GOODS_DIVISION1'		, text:'농공산구분'																	, type: 'string', comboType: 'AU', comboCode: 'Z011'},
			{name: 'WONSANGI1'				, text:'원산지'																	, type: 'string', editable:false},
			{name: 'FARM_NAME1'				, text:'농가코드'		, type: 'string'	,editable:false},
			{name: 'CUSTOM_CODE1'				, text:'거래처코드'		, type: 'string'	,editable:false},
			{name: 'PREV_ORDER_Q1'			, text:'이전수주량'																	, type: 'uniQty'},
			{name: 'ORDER_O1'				, text:'금액'																		, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_TAX_O1'			, text:'부가세액'																	, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_O_TAX_O1'			, text:'수주계'																	, type: 'uniPrice', defaultValue: 0, editable:false},
			{name: 'PROD_SALE_Q1'			, text:'생산요청량'																	, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q1'			, text:'수주량(재고단위)'																, type: 'uniQty', allowBlank: true},
			{name: 'PROD_Q1'				, text:'<t:message code="unilite.msg.sMS769"		default="생산요청량(재고단위)"/>'	, type: 'uniQty'},
			{name: 'STOCK_Q1'				, text:'<t:message code="unilite.msg.sMS768"		default="재고수량"/>'			, type: 'uniQty', editable:false},
			{name: 'OUTSTOCK_Q1'			, text:'출고량'																	, type: 'uniQty', defaultValue: 0},
			{name: 'ISSUE_REQ_Q1'			, text:'<t:message code="unilite.msg.sMS683" 		default="출하지시량"/>'			, type: 'uniQty' , defaultValue: 0},
			{name: 'SALE_Q1'				, text:'매출량'																	, type: 'int', defaultValue: 0},
			{name: 'REMARK1'				, text:'비고'																		, type: 'string'},

			{name: 'NEW_YN2'				, text:'저장flag'																	, type: 'string'},
			{name: 'SER_NO2'				, text:'순번'																		, type: 'int'},
			{name: 'ORDER_Q2'				, text:'수주량'																	, type: 'uniQty'	, allowBlank: true},
			{name: 'DVRY_DATE2'				, text:'<t:message code="unilite.msg.sMS510" default="납기일"/>'					, type: 'uniDate', allowBlank: true},
			{name: 'PROD_END_DATE2'			, text:'생산완료일'																	, type: 'uniDate'},
			{name: 'EXP_ISSUE_DATE2'		, text:'출하예정일'																	, type: 'uniDate'},
			//20210913 jhj:컬럼추가
			{name: 'GOODS_DIVISION2'		, text:'농공산구분'																	, type: 'string', comboType: 'AU', comboCode: 'Z011'},
			{name: 'WONSANGI2'				, text:'원산지'																	, type: 'string', editable:false},
			{name: 'FARM_NAME2'				, text:'농가코드'		, type: 'string'	,editable:false},
			{name: 'CUSTOM_CODE2'				, text:'거래처코드'		, type: 'string'	,editable:false},
			{name: 'PREV_ORDER_Q2'			, text:'이전수주량'																	, type: 'uniQty'},
			{name: 'ORDER_O2'				, text:'금액'																		, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_TAX_O2'			, text:'부가세액'																	, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_O_TAX_O2'			, text:'수주계'																	, type: 'uniPrice', defaultValue: 0, editable:false},
			{name: 'PROD_SALE_Q2'			, text:'생산요청량'																	, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q2'			, text:'수주량(재고단위)'																, type: 'uniQty', allowBlank: true},
			{name: 'PROD_Q2'				, text:'<t:message code="unilite.msg.sMS769"		default="생산요청량(재고단위)"/>'	, type: 'uniQty'},
			{name: 'STOCK_Q2'				, text:'<t:message code="unilite.msg.sMS768"		default="재고수량"/>'			, type: 'uniQty', editable:true},
			{name: 'OUTSTOCK_Q2'			, text:'출고량'																	, type: 'uniQty', defaultValue: 0},
			{name: 'ISSUE_REQ_Q2'			, text:'<t:message code="unilite.msg.sMS683" 		default="출하지시량"/>'			, type: 'uniQty' , defaultValue: 0},
			{name: 'SALE_Q2'				, text:'매출량'																	, type: 'int', defaultValue: 0},
			{name: 'REMARK2'				, text:'비고'																		, type: 'string'},

			{name: 'NEW_YN3'				, text:'저장flag'																	, type: 'string'},
			{name: 'SER_NO3'				, text:'순번'																		, type: 'int'},
			{name: 'ORDER_Q3'				, text:'수주량'																	, type: 'uniQty'	, allowBlank: true},
			{name: 'DVRY_DATE3'				, text:'<t:message code="unilite.msg.sMS510" default="납기일"/>'					, type: 'uniDate', allowBlank: true},
			{name: 'PROD_END_DATE3'			, text:'생산완료일'																	, type: 'uniDate'},
			{name: 'EXP_ISSUE_DATE3'		, text:'출하예정일'																	, type: 'uniDate'},
			//20210913 jhj:컬럼추가
			{name: 'GOODS_DIVISION3'		, text:'농공산구분'																	, type: 'string', comboType: 'AU', comboCode: 'Z011'},
			{name: 'WONSANGI3'				, text:'원산지'																	, type: 'string', editable:false},
			{name: 'FARM_NAME3'				, text:'농가코드'		, type: 'string'	,editable:false},
			{name: 'CUSTOM_CODE3'				, text:'거래처코드'		, type: 'string'	,editable:false},
			{name: 'PREV_ORDER_Q3'			, text:'이전수주량'																	, type: 'uniQty'},
			{name: 'ORDER_O3'				, text:'금액'																		, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_TAX_O3'			, text:'부가세액'																	, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_O_TAX_O3'			, text:'수주계'																	, type: 'uniPrice', defaultValue: 0, editable:false},
			{name: 'PROD_SALE_Q3'			, text:'생산요청량'																	, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q3'			, text:'수주량(재고단위)'																, type: 'uniQty', allowBlank: true},
			{name: 'PROD_Q3'				, text:'<t:message code="unilite.msg.sMS769"		default="생산요청량(재고단위)"/>'	, type: 'uniQty'},
			{name: 'STOCK_Q3'				, text:'<t:message code="unilite.msg.sMS768"		default="재고수량"/>'			, type: 'uniQty', editable:true},
			{name: 'OUTSTOCK_Q3'			, text:'출고량'																	, type: 'uniQty', defaultValue: 0},
			{name: 'ISSUE_REQ_Q3'			, text:'<t:message code="unilite.msg.sMS683" 		default="출하지시량"/>'			, type: 'uniQty' , defaultValue: 0},
			{name: 'SALE_Q3'				, text:'매출량'																	, type: 'int', defaultValue: 0},
			{name: 'REMARK3'				, text:'비고'																		, type: 'string'},

			{name: 'NEW_YN4'				, text:'저장flag'																	, type: 'string'},
			{name: 'SER_NO4'				, text:'순번'																		, type: 'int'},
			{name: 'ORDER_Q4'				, text:'수주량'																	, type: 'uniQty'	, allowBlank: true},
			{name: 'DVRY_DATE4'				, text:'<t:message code="unilite.msg.sMS510" default="납기일"/>'					, type: 'uniDate', allowBlank: true},
			{name: 'PROD_END_DATE4'			, text:'생산완료일'																	, type: 'uniDate'},
			{name: 'EXP_ISSUE_DATE4'		, text:'출하예정일'																	, type: 'uniDate'},
			//20210913 jhj:컬럼추가
			{name: 'GOODS_DIVISION4'		, text:'농공산구분'																	, type: 'string', comboType: 'AU', comboCode: 'Z011'},
			{name: 'WONSANGI4'				, text:'원산지'																	, type: 'string', editable:false},
			{name: 'FARM_NAME4'				, text:'농가코드'		, type: 'string'	,editable:false},
			{name: 'CUSTOM_CODE4'				, text:'거래처코드'		, type: 'string'	,editable:false},
			{name: 'PREV_ORDER_Q4'			, text:'이전수주량'																	, type: 'uniQty'},
			{name: 'ORDER_O4'				, text:'금액'																		, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_TAX_O4'			, text:'부가세액'																	, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_O_TAX_O4'			, text:'수주계'																	, type: 'uniPrice', defaultValue: 0, editable:false},
			{name: 'PROD_SALE_Q4'			, text:'생산요청량'																	, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q4'			, text:'수주량(재고단위)'																, type: 'uniQty', allowBlank: true},
			{name: 'PROD_Q4'				, text:'<t:message code="unilite.msg.sMS769"		default="생산요청량(재고단위)"/>'	, type: 'uniQty'},
			{name: 'STOCK_Q4'				, text:'<t:message code="unilite.msg.sMS768"		default="재고수량"/>'			, type: 'uniQty', editable:true},
			{name: 'OUTSTOCK_Q4'			, text:'출고량'																	, type: 'uniQty', defaultValue: 0},
			{name: 'ISSUE_REQ_Q4'			, text:'<t:message code="unilite.msg.sMS683" 		default="출하지시량"/>'			, type: 'uniQty' , defaultValue: 0},
			{name: 'SALE_Q4'				, text:'매출량'																	, type: 'int', defaultValue: 0},
			{name: 'REMARK4'				, text:'비고'																		, type: 'string'},

			{name: 'NEW_YN5'				, text:'저장flag'																	, type: 'string'},
			{name: 'SER_NO5'				, text:'순번'																		, type: 'int'},
			{name: 'ORDER_Q5'				, text:'수주량'																	, type: 'uniQty'	, allowBlank: true},
			{name: 'DVRY_DATE5'				, text:'<t:message code="unilite.msg.sMS510" default="납기일"/>'					, type: 'uniDate', allowBlank: true},
			{name: 'PROD_END_DATE5'			, text:'생산완료일'																	, type: 'uniDate'},
			{name: 'EXP_ISSUE_DATE5'		, text:'출하예정일'																	, type: 'uniDate'},
			//20210913 jhj:컬럼추가
			{name: 'GOODS_DIVISION5'		, text:'농공산구분'																	, type: 'string', comboType: 'AU', comboCode: 'Z011'},
			{name: 'WONSANGI5'				, text:'원산지'																	, type: 'string', editable:false},
			{name: 'FARM_NAME5'				, text:'농가코드'		, type: 'string'	,editable:false},
			{name: 'CUSTOM_CODE5'				, text:'거래처코드'		, type: 'string'	,editable:false},
			{name: 'PREV_ORDER_Q5'			, text:'이전수주량'																	, type: 'uniQty'},
			{name: 'ORDER_O5'				, text:'금액'																		, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_TAX_O5'			, text:'부가세액'																	, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_O_TAX_O5'			, text:'수주계'																	, type: 'uniPrice', defaultValue: 0, editable:false},
			{name: 'PROD_SALE_Q5'			, text:'생산요청량'																	, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q5'			, text:'수주량(재고단위)'																, type: 'uniQty', allowBlank: true},
			{name: 'PROD_Q5'				, text:'<t:message code="unilite.msg.sMS769"		default="생산요청량(재고단위)"/>'	, type: 'uniQty'},
			{name: 'STOCK_Q5'				, text:'<t:message code="unilite.msg.sMS768"		default="재고수량"/>'			, type: 'uniQty', editable:true},
			{name: 'OUTSTOCK_Q5'			, text:'출고량'																	, type: 'uniQty', defaultValue: 0},
			{name: 'ISSUE_REQ_Q5'			, text:'<t:message code="unilite.msg.sMS683" 		default="출하지시량"/>'			, type: 'uniQty' , defaultValue: 0},
			{name: 'SALE_Q5'				, text:'매출량'																	, type: 'int', defaultValue: 0},
			{name: 'REMARK5'				, text:'비고'																		, type: 'string'},

			{name: 'NEW_YN6'				, text:'저장flag'																	, type: 'string'},
			{name: 'SER_NO6'				, text:'순번'																		, type: 'int'},
			{name: 'ORDER_Q6'				, text:'수주량'																	, type: 'uniQty'	, allowBlank: true},
			{name: 'DVRY_DATE6'				, text:'<t:message code="unilite.msg.sMS510" default="납기일"/>'					, type: 'uniDate', allowBlank: true},
			{name: 'PROD_END_DATE6'			, text:'생산완료일'																	, type: 'uniDate'},
			{name: 'EXP_ISSUE_DATE6'		, text:'출하예정일'																	, type: 'uniDate'},
			//20210913 jhj:컬럼추가
			{name: 'GOODS_DIVISION6'		, text:'농공산구분'																	, type: 'string', comboType: 'AU', comboCode: 'Z011'},
			{name: 'WONSANGI6'				, text:'원산지'																	, type: 'string', editable:false},
			{name: 'FARM_NAME6'				, text:'농가코드'		, type: 'string'	,editable:false},
			{name: 'CUSTOM_CODE6'				, text:'거래처코드'		, type: 'string'	,editable:false},
			{name: 'PREV_ORDER_Q6'			, text:'이전수주량'																	, type: 'uniQty'},
			{name: 'ORDER_O6'				, text:'금액'																		, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_TAX_O6'			, text:'부가세액'																	, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_O_TAX_O6'			, text:'수주계'																	, type: 'uniPrice', defaultValue: 0, editable:false},
			{name: 'PROD_SALE_Q6'			, text:'생산요청량'																	, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q6'			, text:'수주량(재고단위)'																, type: 'uniQty', allowBlank: true},
			{name: 'PROD_Q6'				, text:'<t:message code="unilite.msg.sMS769"		default="생산요청량(재고단위)"/>'	, type: 'uniQty'},
			{name: 'STOCK_Q6'				, text:'<t:message code="unilite.msg.sMS768"		default="재고수량"/>'			, type: 'uniQty', editable:true},
			{name: 'OUTSTOCK_Q6'			, text:'출고량'																	, type: 'uniQty', defaultValue: 0},
			{name: 'ISSUE_REQ_Q6'			, text:'<t:message code="unilite.msg.sMS683" 		default="출하지시량"/>'			, type: 'uniQty' , defaultValue: 0},
			{name: 'SALE_Q6'				, text:'매출량'																	, type: 'int', defaultValue: 0},
			{name: 'REMARK6'				, text:'비고'																		, type: 'string'},

			{name: 'NEW_YN7'				, text:'저장flag'																	, type: 'string'},
			{name: 'SER_NO7'				, text:'순번'																		, type: 'int'},
			{name: 'ORDER_Q7'				, text:'수주량'																	, type: 'uniQty'	, allowBlank: true},
			{name: 'DVRY_DATE7'				, text:'<t:message code="unilite.msg.sMS510" default="납기일"/>'					, type: 'uniDate', allowBlank: true},
			{name: 'PROD_END_DATE7'			, text:'생산완료일'																	, type: 'uniDate'},
			{name: 'EXP_ISSUE_DATE7'		, text:'출하예정일'																	, type: 'uniDate'},
			//20210913 jhj:컬럼추가
			{name: 'GOODS_DIVISION7'		, text:'농공산구분'																	, type: 'string', comboType: 'AU', comboCode: 'Z011'},
			{name: 'WONSANGI7'				, text:'원산지'																	, type: 'string', editable:false},
			{name: 'FARM_NAME7'				, text:'농가코드'		, type: 'string'	,editable:false},
			{name: 'CUSTOM_CODE7'				, text:'거래처코드'		, type: 'string'	,editable:false},
			{name: 'PREV_ORDER_Q7'			, text:'이전수주량'																	, type: 'uniQty'},
			{name: 'ORDER_O7'				, text:'금액'																		, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_TAX_O7'			, text:'부가세액'																	, type: 'uniPrice', allowBlank: true , defaultValue: 0},
			{name: 'ORDER_O_TAX_O7'			, text:'수주계'																	, type: 'uniPrice', defaultValue: 0, editable:false},
			{name: 'PROD_SALE_Q7'			, text:'생산요청량'																	, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q7'			, text:'수주량(재고단위)'																, type: 'uniQty', allowBlank: true},
			{name: 'PROD_Q7'				, text:'<t:message code="unilite.msg.sMS769"		default="생산요청량(재고단위)"/>'	, type: 'uniQty'},
			{name: 'STOCK_Q7'				, text:'<t:message code="unilite.msg.sMS768"		default="재고수량"/>'			, type: 'uniQty', editable:true},
			{name: 'OUTSTOCK_Q7'			, text:'출고량'																	, type: 'uniQty', defaultValue: 0},
			{name: 'ISSUE_REQ_Q7'			, text:'<t:message code="unilite.msg.sMS683" 		default="출하지시량"/>'			, type: 'uniQty' , defaultValue: 0},
			{name: 'SALE_Q7'				, text:'매출량'																	, type: 'int', defaultValue: 0},
			{name: 'REMARK7'				, text:'비고'																		, type: 'string'}

		]
	});
	//수주정보스토어
	var detailStore = Unilite.createStore('s_sof101ukrv_ypDetailStore', {
		model	: 's_sof101ukrv_ypDetailModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy		: directProxy,
		listeners	: {
			load: function(store, records, successful, eOpts) {
				this.fnOrderAmtSum2();
			},
			add: function(store, records, index, eOpts) {
				this.fnOrderAmtSum();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				console.log("modifiedFieldNames :",modifiedFieldNames)
				console.log("record :",record)
//				validation.validate( 'grid', modifiedFieldNames[0], record.get( modifiedFieldNames[0]), record.data[modifiedFieldNames[0]], record);
//				this.fnOrderAmtSum();
			},
			remove: function(store, record, index, isMove, eOpts) {
				this.fnOrderAmtSum2();
			}
		},
		loadStoreRecords: function(drvyDate) {
			var param = panelSearch.getValues();
			if(Ext.isEmpty(drvyDate) && Ext.isEmpty(queryYear)) {
				param.CAL_YEAR = panelSearch.getValue('ORDER_DATE').getFullYear();
			} else {
				if(Ext.isEmpty(queryYear)) {
					queryYear	= drvyDate.substring(0, 4);
				}
				param.CAL_YEAR	= queryYear;
			}
			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success)	{
					if(success) {
						console.log(records);
						panelSearch.setLoadRecord(records[0]);
						fnSetValue2(records[0]);//그리드 날짜 컬럼명 세팅
					}
				}
			});
		},
		saveStore: function() {
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list	 = [].concat(toUpdate, toCreate);
			var checkList = detailStore.data.items;

			var checkCount	= 0;
			var checkFlag	= 'Y';
			var itemCode	= '';
			var itemName	= '';

			console.log("list:", list);

			var orderNum = panelSearch.getValue('ORDER_NUM');
			Ext.each(checkList, function(record, index) {
				checkCount = 0;
				if(record.data['ORDER_NUM'] != orderNum) {
					record.set('ORDER_NUM', orderNum);
				}
				Ext.each(checkList, function(record2, index2) {
					if(record.get('ITEM_CODE') == record2.get('ITEM_CODE')
					&& record.get('CUSTOM_ITEM_NAME') == record2.get('CUSTOM_ITEM_NAME')
					&& record.get('CUSTOM_ITEM_DESC') == record2.get('CUSTOM_ITEM_DESC')) {
						checkCount++;
						if(checkCount >= 2) {
							checkFlag	= 'error';
							itemCode	= record2.get('ITEM_CODE');
							itemName	= record2.get('ITEM_NAME');
							return false;
						}
					}
				});
			})
			//console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			if (checkFlag != 'error') {
				//1. 마스터 정보 파라미터 구성
				var paramMaster	= panelSearch.getValues();	//syncAll 수정
				var paramTrade	= panelTrade.getValues();
				var params		= Ext.merge(paramMaster , paramTrade);
				var inValidRecs	= this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0) {
					config = {
						params: [paramMaster],
						success: function(batch, option) {
							//2.마스터 정보(Server 측 처리 시 가공)
							var master = batch.operations[0].getResultSet();
							panelSearch.setValue("ORDER_NUM", master.ORDER_NUM);
							panelResult.setValue("ORDER_NUM", master.ORDER_NUM);

							//3.기타 처리
							panelSearch.getForm().wasDirty = false;
							panelSearch.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);

							if(detailStore.getCount() == 0){
								UniAppManager.app.onResetButtonDown();
							}else{
								UniAppManager.app.onQueryButtonDown();
							}
						 }
					};
					this.syncAllDirect(config);
				} else {
					var grid = Ext.getCmp('s_sof101ukrv_ypGrid');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} else {
				alert('동일 품목이 ' + checkCount + '번 이상 등록 되었습니다.' + '\n' + '품목코드 : ' + itemCode + ', 품목명 : ' + itemName);
				return false;
			}
		},
		fnOrderAmtSum: function() {
			console.log("=============Exec fnOrderAmtSum()");
			var sumOrder1= Ext.isNumeric(this.sum('ORDER_O1'))		? this.sum('ORDER_O1')		: 0;
			var sumOrder2= Ext.isNumeric(this.sum('ORDER_O2'))		? this.sum('ORDER_O2')		: 0;
			var sumOrder3= Ext.isNumeric(this.sum('ORDER_O3'))		? this.sum('ORDER_O3')		: 0;
			var sumOrder4= Ext.isNumeric(this.sum('ORDER_O4'))		? this.sum('ORDER_O4')		: 0;
			var sumOrder5= Ext.isNumeric(this.sum('ORDER_O5'))		? this.sum('ORDER_O5')		: 0;
			var sumOrder6= Ext.isNumeric(this.sum('ORDER_O6'))		? this.sum('ORDER_O6')		: 0;
			var sumOrder7= Ext.isNumeric(this.sum('ORDER_O7'))		? this.sum('ORDER_O7')		: 0;
			var sumOrder	= sumOrder1 + sumOrder2 + sumOrder3 + sumOrder4 + sumOrder5 + sumOrder6 + sumOrder7;

			var sumTax1	= Ext.isNumeric(this.sum('ORDER_TAX_O1'))	? this.sum('ORDER_TAX_O1')	: 0;
			var sumTax2	= Ext.isNumeric(this.sum('ORDER_TAX_O2'))	? this.sum('ORDER_TAX_O2')	: 0;
			var sumTax3	= Ext.isNumeric(this.sum('ORDER_TAX_O3'))	? this.sum('ORDER_TAX_O3')	: 0;
			var sumTax4	= Ext.isNumeric(this.sum('ORDER_TAX_O4'))	? this.sum('ORDER_TAX_O4')	: 0;
			var sumTax5	= Ext.isNumeric(this.sum('ORDER_TAX_O5'))	? this.sum('ORDER_TAX_O5')	: 0;
			var sumTax6	= Ext.isNumeric(this.sum('ORDER_TAX_O6'))	? this.sum('ORDER_TAX_O6')	: 0;
			var sumTax7	= Ext.isNumeric(this.sum('ORDER_TAX_O7'))	? this.sum('ORDER_TAX_O7')	: 0;
			var sumTax	= sumTax1 + sumTax2 + sumTax3 + sumTax4 + sumTax5 + sumTax6 + sumTax7;

			var sumTot1	= sumOrder1 + sumTax1;
			var sumTot2	= sumOrder2 + sumTax2;
			var sumTot3	= sumOrder3 + sumTax3;
			var sumTot4	= sumOrder4 + sumTax4;
			var sumTot5	= sumOrder5 + sumTax5;
			var sumTot6	= sumOrder6 + sumTax6;
			var sumTot7	= sumOrder7 + sumTax7;
			var sumTot	= sumTot1 + sumTot2 + sumTot3 + sumTot4 + sumTot5 + sumTot6 + sumTot7;

			panelSearch.setValue('ORDER_O'		,sumOrder);
			panelSearch.setValue('ORDER_TAX_O'	,sumTax);
			panelSearch.setValue('TOT_ORDER_AMT',sumTot);

			panelResult.setValue('ORDER_O'		,sumOrder);
			panelResult.setValue('ORDER_TAX_O'	,sumTax);
			panelResult.setValue('TOT_ORDER_AMT',sumTot);

			panelSearch.fnCreditCheck();
		},
		fnOrderAmtSum2: function() {
			console.log("=============Exec fnOrderAmtSum()");
			var sumOrder1= Ext.isNumeric(this.sum('ORDER_O1'))		? this.sum('ORDER_O1')		: 0;
			var sumOrder2= Ext.isNumeric(this.sum('ORDER_O2'))		? this.sum('ORDER_O2')		: 0;
			var sumOrder3= Ext.isNumeric(this.sum('ORDER_O3'))		? this.sum('ORDER_O3')		: 0;
			var sumOrder4= Ext.isNumeric(this.sum('ORDER_O4'))		? this.sum('ORDER_O4')		: 0;
			var sumOrder5= Ext.isNumeric(this.sum('ORDER_O5'))		? this.sum('ORDER_O5')		: 0;
			var sumOrder6= Ext.isNumeric(this.sum('ORDER_O6'))		? this.sum('ORDER_O6')		: 0;
			var sumOrder7= Ext.isNumeric(this.sum('ORDER_O7'))		? this.sum('ORDER_O7')		: 0;
			var sumOrder	= sumOrder1 + sumOrder2 + sumOrder3 + sumOrder4 + sumOrder5 + sumOrder6 + sumOrder7;

			var sumTax1	= Ext.isNumeric(this.sum('ORDER_TAX_O1'))	? this.sum('ORDER_TAX_O1')	: 0;
			var sumTax2	= Ext.isNumeric(this.sum('ORDER_TAX_O2'))	? this.sum('ORDER_TAX_O2')	: 0;
			var sumTax3	= Ext.isNumeric(this.sum('ORDER_TAX_O3'))	? this.sum('ORDER_TAX_O3')	: 0;
			var sumTax4	= Ext.isNumeric(this.sum('ORDER_TAX_O4'))	? this.sum('ORDER_TAX_O4')	: 0;
			var sumTax5	= Ext.isNumeric(this.sum('ORDER_TAX_O5'))	? this.sum('ORDER_TAX_O5')	: 0;
			var sumTax6	= Ext.isNumeric(this.sum('ORDER_TAX_O6'))	? this.sum('ORDER_TAX_O6')	: 0;
			var sumTax7	= Ext.isNumeric(this.sum('ORDER_TAX_O7'))	? this.sum('ORDER_TAX_O7')	: 0;
			var sumTax	= sumTax1 + sumTax2 + sumTax3 + sumTax4 + sumTax5 + sumTax6 + sumTax7;

			var sumTot1	= sumOrder1 + sumTax1;
			var sumTot2	= sumOrder2 + sumTax2;
			var sumTot3	= sumOrder3 + sumTax3;
			var sumTot4	= sumOrder4 + sumTax4;
			var sumTot5	= sumOrder5 + sumTax5;
			var sumTot6	= sumOrder6 + sumTax6;
			var sumTot7	= sumOrder7 + sumTax7;
			var sumTot	= sumTot1 + sumTot2 + sumTot3 + sumTot4 + sumTot5 + sumTot6 + sumTot7;

			panelSearch.setValue('ORDER_O'		,sumOrder);
			panelSearch.setValue('ORDER_TAX_O'	,sumTax);
			panelSearch.setValue('TOT_ORDER_AMT',sumTot);

			panelResult.setValue('ORDER_O'		,sumOrder);
			panelResult.setValue('ORDER_TAX_O'	,sumTax);
			panelResult.setValue('TOT_ORDER_AMT',sumTot);
		}
	});



	/** 수주의 마스터 정보를 가지고 있는 Form
	 */
	var panelSearch = Unilite.createSearchPanel('s_sof101ukrv_ypMasterForm', {
		title		: '<t:message code="unilite.msg.sMS178" default="수주정보"/>',
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
//					UniAppManager.setToolbarButtons('save', true);
				} else if(detailStore.getCount() != 0 && panelSearch.isDirty()) {
//					UniAppManager.setToolbarButtons('save', true);
				}
			}
		 },
		items	: [{
			title		: '기본정보',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '사업장',
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
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="unilite.msg.sMS533" default="수주번호"/>',
				name		: 'ORDER_NUM',
				readOnly	: isAutoOrderNum,
				holdable	: isAutoOrderNum ? 'readOnly':'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_NUM', newValue);
					}
				}
			},{
				fieldLabel	: '수주일자',
				name		: 'ORDER_DATE',
				xtype		: 'uniDatefield',
				value		: new Date(),
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						if(CustomCodeInfo.gsCustCrYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
							//여신액 구하기
							var divCode = panelSearch.getValue('DIV_CODE');
							var CustomCode = panelSearch.getValue('CUSTOM_CODE');
							var orderDate = UniDate.getDbDateStr(newValue);
							var moneyUnit = BsaCodeInfo.gsMoneyUnit;
							//마스터폼에 여신액 set
							UniAppManager.app.fnGetCustCredit(divCode, CustomCode, orderDate, moneyUnit);
						}
						panelResult.setValue('DVRY_DATE', newValue);
						panelSearch.setValue('DVRY_DATE', newValue);
						panelResult.setValue('ORDER_DATE', newValue);

//						if(!Ext.isEmpty(newValue)) {
//							fnGetCalNo(newValue);
//						}
					}
				}
			},{
				fieldLabel	: '주차',
				name		: 'CAL_NO',
				xtype		: 'uniCombobox',
				holdable	: 'hold',
				store		: Ext.data.StoreManager.lookup('s_bpr300ukrv_ypCAL_NO'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CAL_NO', newValue);
//						fnGetCalDate(newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="unilite.msg.sMS832" default="판매유형"/>',
				name		: 'ORDER_TYPE',
				id			: 'ORDER_TYPE_ID',
				comboType	: 'AU',
				comboCode	: 'S002',
				xtype		: 'uniCombobox',
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="unilite.msg.sMSR213" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				id				: 'CUSTOM_ID',
				allowBlank		: false,
				holdable		: 'hold',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							CustomCodeInfo.gsAgentType		= records[0]["AGENT_TYPE"];
							CustomCodeInfo.gsCustCrYn		= records[0]["CREDIT_YN"];
							CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"];
							CustomCodeInfo.gsRefTaxInout	= records[0]["TAX_TYPE"];		//세액포함여부

							if(!Ext.isEmpty(CustomCodeInfo.gsRefTaxInout)){
								panelSearch.setValue('TAX_INOUT', CustomCodeInfo.gsRefTaxInout)
								panelResult.setValue('TAX_INOUT', CustomCodeInfo.gsRefTaxInout)
							}

							if(CustomCodeInfo.gsCustCrYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
								//여신액 구하기
								var divCode		= panelSearch.getValue('DIV_CODE');
								var CustomCode	= panelSearch.getValue('CUSTOM_CODE');
								var orderDate	= panelSearch.getField('ORDER_DATE').getSubmitValue()
								var moneyUnit	= BsaCodeInfo.gsMoneyUnit;
								//마스터폼에 여신액 set
								UniAppManager.app.fnGetCustCredit(divCode, CustomCode, orderDate, moneyUnit);
							}

							panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));

							panelSearch.setValue('SALE_CUST_CD', records[0].BILL_CUSTOM_CODE);
							panelSearch.setValue('SALE_CUST_NM', records[0].BILL_CUSTOM_NAME);
							panelResult.setValue('SALE_CUST_CD', records[0].BILL_CUSTOM_CODE);
							panelResult.setValue('SALE_CUST_NM', records[0].BILL_CUSTOM_NAME);
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

						panelSearch.setValue('SALE_CUST_CD', '');
						panelSearch.setValue('SALE_CUST_NM', '');
						panelResult.setValue('SALE_CUST_CD', '');
						panelResult.setValue('SALE_CUST_NM', '');
					}
				}
			}),{
				fieldLabel	: '납기일',
				name		: 'DVRY_DATE',
				xtype		: 'uniDatefield',
				value		: UniDate.get('today'),
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DVRY_DATE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="unilite.msg.sMS717" default="부가세유형"/>',
				name		: 'BILL_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S024',
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BILL_TYPE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="unilite.msg.sMS986" default="세액포함여부"/>',
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
				fieldLabel	: '<t:message code="unilite.msg.sMS742" default="비고"/>',
				xtype		: 'uniTextfield',
				name		: 'REMARK',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('REMARK', newValue);
					}
				}
			},{
				fieldLabel	: '국내외구분',
				name		: 'NATION_INOUT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'T109',
				value		: '1',
				allowBlank	: false,
				holdable	: 'hold',
				hidden		: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('NATION_INOUT', newValue);
						if(panelSearch.getValue('NATION_INOUT') == '2') {	//국외일시만 무역폼 활성화
							//무역폼 readOnly: false
							panelSearch.getField('OFFER_NO').setReadOnly(false);
							panelResult.getField('OFFER_NO').setReadOnly(false);
							panelSearch.setValue('BILL_TYPE', '60');
							panelResult.setValue('BILL_TYPE', '60');
							panelTrade.getForm().getFields().each(function(field) {
								field.setReadOnly(false);
							});
							panelTrade.setConfig('collapsed', false);
						} else {
							//무역폼 readOnly: true
							panelSearch.getField('OFFER_NO').setReadOnly(true);
							panelResult.getField('OFFER_NO').setReadOnly(true);
							panelSearch.setValue('BILL_TYPE', '10');
							panelResult.setValue('BILL_TYPE', '10');
							panelTrade.getForm().getFields().each(function(field) {
								field.setReadOnly(true);
							});
							panelTrade.setConfig('collapsed', true);
						}
					}
				}
			},{
				fieldLabel	: '화폐',
				name		: 'MONEY_UNIT',
				comboType	: 'AU',
				comboCode	: 'B004',
				value		: BsaCodeInfo.gsMoneyUnit,
				xtype		: 'uniCombobox',
				holdable	: 'hold',
				displayField: 'value',
				allowBlank	: false,
				hidden		: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('MONEY_UNIT', newValue);
						if(isLoad){
							isLoad = false;
						}else{
							UniAppManager.app.fnExchngRateO();
						}
					}
				}
			},{
				fieldLabel	: 'OFFER번호',
				name		: 'OFFER_NO',
				holdable	: 'hold',
				readOnly	: true,
				hidden		: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('OFFER_NO', newValue);
					}
				}
			},{
				fieldLabel	: '환율',
				name		: 'EXCHANGE_RATE',
				xtype		: 'uniNumberfield',
				holdable	: 'hold',
				value		: 1,
				allowBlank	: false,
				hidden		: true,
				decimalPrecision: 4,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EXCHANGE_RATE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="unilite.msg.sMB189" default="결제방법"/>',
				name		: 'RECEIPT_SET_METH',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B038',
				holdable	: 'hold',
				hidden		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('RECEIPT_SET_METH', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="unilite.msg.sMS573" default="영업담당"/>',
				name		: 'ORDER_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010',
				holdable	: 'hold',
				allowBlank	: false,
//				hidden		: true,
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				}
			},{
				margin	: '0 0 0 95',
				xtype	: 'button',
				text	: '구매요청정보반영',
				itemId	: 'purchaseRequest1',
				holdable: 'hold',
				hidden	: true,
				handler	: function() {
					if(!Ext.isEmpty(panelSearch.getValue('ORDER_NUM') && panelSearch.getValue('ORDER_REQ_YN') == "N")){
						var param = {
							CompCode	: UserInfo.compCode,
							OrderNum	: panelSearch.getValue('ORDER_NUM'),
							DivCode		: panelSearch.getValue('DIV_CODE')
						}
						var me = this;
						s_sof101ukrv_ypService.insertPurchaseRequest(param, function(provider, response) {
							if(provider){
								UniAppManager.updateStatus("구매요청 정보가 반영되었습니다.");
								me.setDisabled(true);
							}

						});
					}
				}
			}]
		},{
			xtype	: 'container',
			padding : '0 0 3 95',
			layout	: {type:'uniTable', tdAttrs: {align: 'right'}},
			items	: [{
				xtype	: 'button',
				text	: 'SMS 발송',
				handler	: function()  {
					this.openPopup();
				},
				//공통팝업(SMS 전송팝업 호출)
				app			: 'Unilite.app.popup.SendSMS',
				api			: 'popupService.sendSMS',
				openPopup	: function() {
					var me		= this;
					var param	= {};

					param['CUSTOM_CODE']	= panelSearch.getValue('CUSTOM_CODE');
					param['CUSTOM_NAME']	= panelSearch.getValue('CUSTOM_NAME');
					param['TYPE']			= 'TEXT';
					param['pageTitle']		= me.pageTitle;

					if(me.app) {
						var fn = function() {
							var oWin =  Ext.WindowMgr.get(me.app);
							if(!oWin) {
								oWin = Ext.create( me.app, {
									id				: me.app,
									callBackFn		: me.processResult,
									callBackScope	: me,
									popupType		: 'TEXT',
									width			: 750,
									height			: 450,
									title			: 'SMS 전송',
									param			: param
								});
							}
							oWin.fnInitBinding(param);
							oWin.center();
							oWin.show();
						}
					}
				Unilite.require(me.app, fn, this, true);
				}
			}]
		},{
			title		: '기타정보',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [
				Unilite.popup('PROJECT',{
					fieldLabel		: '프로젝트번호',
					textFieldName	: 'PROJECT_NO',
					itemId			: 'project',
					holdable		: 'hold',
					validateBlank	: true,
					hidden			: true,
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('PROJECT_NO', panelSearch.getValue('PROJECT_NO'));
							},
							scope: this
						},
						onClear: function(type) {
							panelResult.setValue('PROJECT_NO', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'BPARAM0': 3});
							popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')});
						},
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('PROJECT_NO', newValue);
						}
					}
			}), {
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
				fieldLabel		: '<t:message code="unilite.msg.sMS665" default="매출처"/>',
				valueFieldName	: 'SALE_CUST_CD',
				textFieldName	: 'SALE_CUST_NM',
				holdable		: 'hold',
				listeners		: {
					onSelected		: {
						fn: function(records, type) {
							panelResult.setValue('SALE_CUST_CD', panelSearch.getValue('SALE_CUST_CD'));
							panelResult.setValue('SALE_CUST_NM', panelSearch.getValue('SALE_CUST_NM'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('SALE_CUST_CD', '');
						panelResult.setValue('SALE_CUST_NM', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
					}
				}
			}),{
				fieldLabel	: '<t:message code="unilite.msg.sMS176" default="수주금액"/>',
				name		: 'ORDER_O',
				xtype		: 'uniNumberfield',
				value		: 0,
				readOnly	: true
			},{
				fieldLabel	: '<t:message code="unilite.msg.sMS764" default="부가세액"/>',
				name		: 'ORDER_TAX_O',
				xtype		: 'uniNumberfield',
				value		: 0,
				readOnly	: true
			},{
				fieldLabel	: '수주총액',
				name		: 'TOT_ORDER_AMT',
				xtype		: 'uniNumberfield',
				value		: 0,
				readOnly	: true
			},{
				xtype	: 'container',
				hidden	: true,
				items	: [{
					fieldLabel	: '<t:message code="unilite.msg.sMS628" default="여신잔액"/>',
					name		: 'REMAIN_CREDIT',
					xtype		: 'uniNumberfield',
					value		: 0,
					readOnly	: true,
					hidden		: true
				}]
			},{
				fieldLabel	: '구매요청 반영여부',
				name		: 'ORDER_REQ_YN',
				xtype		: 'uniTextfield',
				hidden		: true
			},{
				xtype		: 'uniCheckboxgroup',
				fieldLabel	: ' ',
				items		: [{
					boxLabel	: '월',
					name		: 'HOLYDAY1',
					inputValue	: '2',
					width		: 35,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('HOLYDAY1', newValue);
						}
					}
				},{
					boxLabel	: '화',
					name		: 'HOLYDAY2',
					inputValue	: '3',
					width		: 35,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('HOLYDAY2', newValue);
						}
					}
				},{
					boxLabel	: '수',
					name		: 'HOLYDAY3',
					inputValue	: '4',
					width		: 35,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('HOLYDAY3', newValue);
						}
					}
				},{
					boxLabel	: '목',
					name		: 'HOLYDAY4',
					inputValue	: '5',
					width		: 35,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('HOLYDAY4', newValue);
						}
					}
				},{
					boxLabel	: '금',
					name		: 'HOLYDAY5',
					inputValue	: '6',
					width		: 35,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('HOLYDAY5', newValue);
						}
					}
				},{
					boxLabel	: '토',
					name		: 'HOLYDAY6',
					inputValue	: '7',
					width		: 35,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('HOLYDAY6', newValue);
						}
					}
				},{
					boxLabel	: '일',
					name		: 'HOLYDAY7',
					inputValue	: '1',
					width		: 35,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('HOLYDAY7', newValue);
						}
					}
				}]
			},{
				xtype	: 'button',
				text	: '선납적용',
				holdable: 'hold',
				tdAttrs	: {align: 'center'},
//				width	: 70,
				handler	: function() {
					fnPrePayment();
				}
			}]
		},{
			title		: '승인정보',
			itemId		: 'DraftFields',
			layout		: {type: 'uniTable', columns: 2},
			defaultType	: 'uniTextfield',
			items		: [
				Unilite.popup('USER', {
					fieldLabel		: '<t:message code="unilite.msg.fSbMsgS0007" default="1차승인자"/>',
					textFieldName	: 'APP_1_NM',
					valueFieldName	: 'APP_1_ID',
					showValue		: false,
					width			: 180
				}),
			{
				xtype	: 'component', //'1차승인한도액',
				margin	: '0 0 0 10',
				width	: 150,
				html	: '<div>'+Ext.util.Format.number(BsaCodeInfo.gsApp1AmtInfo, UniFormat.Price)+'원 이하</div>'
			},{
				fieldLabel	: '<t:message code="unilite.msg.fSbMsgS0008" default="1차 승인일"/>',
				name		: 'APP_1_DATE',
				hidden		: true
			},{
				fieldLabel	: '1차 승인여부',
				name		: 'AGREE_1_YN',
				hidden		: true
			},
				Unilite.popup('USER', {
					fieldLabel		: '<t:message code="unilite.msg.fSbMsgS0009" default="2차승인자"/>',
					textFieldName	: 'APP_2_NM',
					valueFieldName	: 'APP_2_ID',
					showValue		: false,
					width			: 180
				}),
			{
				xtype	: 'component', //'2차승인한도액',
				margin	: '0 0 0 10',
				html	: '<div>'+Ext.util.Format.number(BsaCodeInfo.gsApp2AmtInfo, UniFormat.Price)+'원 이하</div>'
			},{
				fieldLabel	: '<t:message code="unilite.msg.fSbMsgS0010" default="2차승인일"/>',
				name		: 'APP_2_DATE',
				hidden		: true
			},{
				fieldLabel	: '2차 승인여부',
				name		: 'AGREE_2_YN',
				hidden		: true
			},
				Unilite.popup('USER', {
					fieldLabel		: '<t:message code="unilite.msg.fSbMsgS0011" default="3차승인자"/>',
					textFieldName	: 'APP_3_NM',
					valueFieldName	: 'APP_3_ID',
					showValue		: false,
					width			: 180
				}),
			{
				xtype	: 'component', //'3차승인초과액',
				margin	: '0 0 0 10',
				html	: '<div>'+Ext.util.Format.number(BsaCodeInfo.gsApp2AmtInfo, UniFormat.Price)+'원 초과</div>'
			},{
				fieldLabel	: '<t:message code="unilite.msg.fSbMsgS0012" default="3차승인일"/>',
				name		: 'APP_3_DATE',
				hidden		: true
			},{
				fieldLabel	: '3차 승인여부',
				name		: 'AGREE_3_YN',
				hidden		: true
			},{
				fieldLabel	: '상태',
				name		: 'STATUS',
				id			: 'status',
				xtype		: 'uniRadiogroup',
				//comboType: 'AU',
				//comboCode: 'S046',
				allowBlank	: false,
				value		: '1',
				colspan		: 2,
				width		: 330,
				layout		: {type: 'table', columns:3, tableAttrs:{width:'100%'}},
				items		: [{
						boxLabel	: '기안',
						name		: 'STATUS',
						inputValue	: '1',
						readOnly	: true,
						readOnlyCls	: 'uniRadioReadonly'
					},{
						boxLabel	: '반려',
						name		: 'STATUS',
						inputValue	: '5',
						readOnly	: true,
						readOnlyCls	: 'uniRadioReadonly'
					},{
						boxLabel	: '완결',
						name		: 'STATUS',
						inputValue	: '6',
						readOnly	: true,
						readOnlyCls	: 'uniRadioReadonly'
					},{
						boxLabel	: '1차승인',
						name		: 'STATUS',
						inputValue	: '2',
						readOnly	: true,
						readOnlyCls	: 'uniRadioReadonly'
					},{
						boxLabel	: '2차승인',
						name		: 'STATUS',
						inputValue	: '3',
						readOnly	: true,
						readOnlyCls	: 'uniRadioReadonly'
					},{
						boxLabel	: '3차승인',
						name		: 'STATUS',
						inputValue	: '4',
						readOnly	: true,
						readOnlyCls	: 'uniRadioReadonly'
					}
				]
			},{
				fieldLabel	: '반려사유',
				name		: 'RETURN_MSG',
				xtype		: 'textarea',
				height		: 50,
				readOnly	: true,
				colspan		: 2
			}]
		},{
			fieldLabel	: 'FIRST_YN',
			xtype		: 'uniTextfield',
			name		: 'FIRST_YN',
			hidden: true
		}],
		api: {
			load	: 's_sof101ukrv_ypService.selectMaster',
			submit	: 's_sof101ukrv_ypService.syncForm'
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
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}

					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')  ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},

		fnCreditCheck: function() {
			if(CustomCodeInfo.gsCustCrYn=='Y' && BsaCodeInfo.gsCreditYn=='Y') {
				if(this.getValue('TOT_ORDER_AMT') > this.getValue('REMAIN_CREDIT')) {
					alert('<t:message code="unilite.msg.sMS284" default="해당 업체에 대한 여신액이 부족합니다. 추가여신액 설정을 선행하시고 작업하시기 바랍니다."/>');
					return false;
				}
			}
			return true;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
//		  me.setAllFieldsReadOnly(true);
		}

	}); //End of var panelSearch = Unilite.createForm('s_sof101ukrv_ypMasterForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4/*,
				tdAttrs: {style: 'border : 1px solid #ced9e7;'}*/
		},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			holdable	: 'hold',
			tdAttrs		: {width: 280},
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelSearch.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS533" default="수주번호"/>',
			name		: 'ORDER_NUM',
			readOnly	: isAutoOrderNum,
			holdable	: isAutoOrderNum ? 'readOnly':'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_NUM', newValue);
				}
			}
		},{
			fieldLabel	: '수주일자',
			name		: 'ORDER_DATE',
			xtype		: 'uniDatefield',
			value		: new Date(),
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					if(CustomCodeInfo.gsCustCrYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
						//여신액 구하기
						var divCode = panelSearch.getValue('DIV_CODE');
						var CustomCode = panelSearch.getValue('CUSTOM_CODE');
						var orderDate = UniDate.getDbDateStr(newValue);
						var moneyUnit = BsaCodeInfo.gsMoneyUnit;
						//마스터폼에 여신액 set
						UniAppManager.app.fnGetCustCredit(divCode, CustomCode, orderDate, moneyUnit);
					}
					panelSearch.setValue('DVRY_DATE', newValue);
					panelResult.setValue('DVRY_DATE', newValue);
					panelSearch.setValue('ORDER_DATE', newValue);

					if(!Ext.isEmpty(newValue)) {
						fnGetCalNo(newValue);
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS176" default="수주금액"/>',
			name		: 'ORDER_O',
			xtype		: 'uniNumberfield',
			value		: 0,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS832" default="판매유형"/>',
			name		: 'ORDER_TYPE',
			id			: 'ORDER_TYPE_ID2',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S002',
			allowBlank	: false,
			holdable	: 'hold',
			tdAttrs		: {width: 280},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_TYPE', newValue);
				}
			}
		},{
			fieldLabel	: '국내외구분',
			name		: 'NATION_INOUT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T109',
			value		: '1',
			allowBlank	: false,
			holdable	: 'hold',
			hidden		: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('NATION_INOUT', newValue);
					if(panelSearch.getValue('NATION_INOUT') == '2') {
						//무역폼 readOnly: false
						panelSearch.getField('OFFER_NO').setReadOnly(false);
						panelResult.getField('OFFER_NO').setReadOnly(false);
						panelTrade.getForm().getFields().each(function(field) {
							field.setReadOnly(false);
						});
						panelSearch.setValue('ORDER_TYPE', '40');//직수출
						panelSearch.setValue('BILL_TYPE', '60');//직수출
						panelResult.setValue('ORDER_TYPE', '40');//직수출
						panelResult.setValue('BILL_TYPE', '60');//직수출

						panelTrade.setConfig('collapsed', false);
					} else {
						//무역폼 readOnly: true
						panelSearch.getField('OFFER_NO').setReadOnly(true);
						panelResult.getField('OFFER_NO').setReadOnly(true);
						panelTrade.getForm().getFields().each(function(field) {
							field.setReadOnly(true);
						});
						panelSearch.setValue('ORDER_TYPE', '10');//직수출
						panelSearch.setValue('BILL_TYPE', '10');//직수출
						panelResult.setValue('ORDER_TYPE', '10');//직수출
						panelResult.setValue('BILL_TYPE', '10');//직수출
						panelTrade.setConfig('collapsed', true);
					}
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		:'<t:message code="unilite.msg.sMSR213" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			id				: 'CUSTOM_ID2',
			allowBlank		: false,
			holdable		: 'hold',
//			colspan			: 2,
//			tdAttrs			: {width: 370},
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						CustomCodeInfo.gsAgentType		= records[0]["AGENT_TYPE"];
						CustomCodeInfo.gsCustCrYn		= records[0]["CREDIT_YN"];
						CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"];
						CustomCodeInfo.gsRefTaxInout	= records[0]["TAX_TYPE"];	 //세액포함여부

						if(!Ext.isEmpty(CustomCodeInfo.gsRefTaxInout)){
							panelSearch.setValue('TAX_INOUT', CustomCodeInfo.gsRefTaxInout)
							panelResult.setValue('TAX_INOUT', CustomCodeInfo.gsRefTaxInout)
						}

						if(CustomCodeInfo.gsCustCrYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
							//여신액 구하기
							var divCode		= panelSearch.getValue('DIV_CODE');
							var CustomCode	= panelResult.getValue('CUSTOM_CODE');
							var orderDate	= panelSearch.getField('ORDER_DATE').getSubmitValue()
							var moneyUnit	= BsaCodeInfo.gsMoneyUnit;
							//마스터폼에 여신액 set
							UniAppManager.app.fnGetCustCredit(divCode, CustomCode, orderDate, moneyUnit);
						}

						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));

						panelSearch.setValue('SALE_CUST_CD', records[0].BILL_CUSTOM_CODE);
						panelSearch.setValue('SALE_CUST_NM', records[0].BILL_CUSTOM_NAME);
						panelResult.setValue('SALE_CUST_CD', records[0].BILL_CUSTOM_CODE);
						panelResult.setValue('SALE_CUST_NM', records[0].BILL_CUSTOM_NAME);
					},
					scope: this
				},
				onClear: function(type) {
					CustomCodeInfo.gsAgentType		= '';
					CustomCodeInfo.gsCustCrYn		= '';
					CustomCodeInfo.gsUnderCalBase	= '';
					CustomCodeInfo.gsRefTaxInout	= '';

					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');

					panelSearch.setValue('SALE_CUST_CD', '');
					panelSearch.setValue('SALE_CUST_NM', '');
					panelResult.setValue('SALE_CUST_CD', '');
					panelResult.setValue('SALE_CUST_NM', '');
				},
					applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			fieldLabel	: '주차',
			name		: 'CAL_NO',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('s_bpr300ukrv_ypCAL_NO'),
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CAL_NO', newValue);
					console.log("[[gsReturnChk]]" + gsReturnChk);
					if(gsReturnChk == 'N'){
						panelResult.setValue('FIRST_YN', 'N');
						panelSearch.setValue('FIRST_YN', 'N');
						//fnGetCalDate(newValue, '', panelResult.getValue('FIRST_YN'));
					}
					gsReturnChk = 'N'
				}
			}
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMB189" default="결제방법"/>',
			name		: 'RECEIPT_SET_METH',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B038',
			holdable	: 'hold',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('RECEIPT_SET_METH', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS764" default="부가세액"/>',
			name		: 'ORDER_TAX_O',
			xtype		: 'uniNumberfield',
			value		: 0,
			readOnly	: true
		},{
			fieldLabel	: 'OFFER번호',
			name		: 'OFFER_NO',
			holdable	: 'hold',
			readOnly	: true,
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('OFFER_NO', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS717" default="부가세유형"/>',
			name		: 'BILL_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S024',
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BILL_TYPE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS986" default="세액포함여부"/>',
			name		: 'TAX_INOUT',
			xtype		: 'uniRadiogroup',
			comboType	: 'AU',
			comboCode	: 'B030',
			width		: 235,
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('TAX_INOUT').setValue(newValue.TAX_INOUT);
				}
			}
		},{
			fieldLabel	: '납기일',
			name		: 'DVRY_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			holdable	: 'hold',
			allowBlank	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DVRY_DATE', newValue);
				}
			}
		},{
			fieldLabel	: '수주총액',
			name		: 'TOT_ORDER_AMT',
			xtype		: 'uniNumberfield',
			value		: 0,
			readOnly	: true

		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS573" default="영업담당"/>',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			allowBlank	: false,
			holdable	: 'hold',
//			hidden		: true,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_PRSN', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="unilite.msg.sMS665" default="매출처"/>',
			valueFieldName	: 'SALE_CUST_CD',
			textFieldName	: 'SALE_CUST_NM',
			holdable		: 'hold',
//			colspan			: 2,
			listeners		: {
				onSelected		: {
					fn: function(records, type) {
						panelSearch.setValue('SALE_CUST_CD', panelResult.getValue('SALE_CUST_CD'));
						panelSearch.setValue('SALE_CUST_NM', panelResult.getValue('SALE_CUST_NM'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('SALE_CUST_CD', '');
					panelSearch.setValue('SALE_CUST_NM', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
				}
			}
		}),{
			fieldLabel	: '화폐',
			name		: 'MONEY_UNIT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B004',
			value		: BsaCodeInfo.gsMoneyUnit,
			allowBlank	: false,
			holdable	: 'hold',
			displayField: 'value',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('MONEY_UNIT', newValue);
//					if(isLoad){
//						isLoad = false;
//					}else{
//						UniAppManager.app.fnExchngRateO();
//					}
				}
			}
		},{
			fieldLabel	: '환율',
			name		: 'EXCHANGE_RATE',
			xtype		: 'uniNumberfield',
			holdable	: 'hold',
			value		: 1,
			allowBlank	: false,
			hidden		: true,
			decimalPrecision: 4,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('EXCHANGE_RATE', newValue);
				}
			}
		},{
			xtype	: 'container',
			hidden	: true,
			items	: [{
				fieldLabel	: '<t:message code="unilite.msg.sMS628" default="여신잔액"/>',
				name		: 'REMAIN_CREDIT',
				xtype		: 'uniNumberfield',
				value		: 0,
				readOnly	: true
			}]
		},
		Unilite.popup('PROJECT',{
			fieldLabel		: '프로젝트번호',
			itemId			: 'project',
			textFieldName	: 'PROJECT_NO',
			holdable		: 'hold',
			validateBlank	: true,
			textFieldWidth	: 150,
			colspan			: 2,
			hidden			: true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PROJECT_NO', panelResult.getValue('PROJECT_NO'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('PROJECT_NO', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'BPARAM0': 3});
					popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')});
				},
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PROJECT_NO', newValue);
				}
			}
		}),{
			margin	: '0 0 0 95',
			xtype	: 'button',
			text	: '구매요청정보반영',
			itemId	: 'purchaseRequest2',
			holdable: 'hold',
			hidden	: true,
			handler	: function() {
				if(!Ext.isEmpty(panelSearch.getValue('ORDER_NUM') && panelSearch.getValue('ORDER_REQ_YN') == "N")){
					var param = {
						CompCode: UserInfo.compCode,
						OrderNum: panelSearch.getValue('ORDER_NUM'),
						DivCode: panelSearch.getValue('DIV_CODE')
					}
					var me = this;
					s_sof101ukrv_ypService.insertPurchaseRequest(param, function(provider, response) {
						if(provider){
							UniAppManager.updateStatus("구매요청 정보가 반영되었습니다.");
							me.setDisabled(true);
						}

					});
				}
			}
		},{
			xtype	: 'container',
			layout	: {type:'uniTable', column:2},
			padding : '0 0 3 0',
			colspan	: 2,
			items	: [{
				xtype		: 'uniCheckboxgroup',
				fieldLabel	: ' ',
				items		: [{
					boxLabel	: '월',
					name		: 'HOLYDAY1',
					inputValue	: '2',
					width		: 45,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('HOLYDAY1', newValue);
						}
					}
				},{
					boxLabel	: '화',
					name		: 'HOLYDAY2',
					inputValue	: '3',
					width		: 45,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('HOLYDAY2', newValue);
						}
					}
				},{
					boxLabel	: '수',
					name		: 'HOLYDAY3',
					inputValue	: '4',
					width		: 45,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('HOLYDAY3', newValue);
						}
					}
				},{
					boxLabel	: '목',
					name		: 'HOLYDAY4',
					inputValue	: '5',
					width		: 45,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('HOLYDAY4', newValue);
						}
					}
				},{
					boxLabel	: '금',
					name		: 'HOLYDAY5',
					inputValue	: '6',
					width		: 45,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('HOLYDAY5', newValue);
						}
					}
				},{
					boxLabel	: '토',
					name		: 'HOLYDAY6',
					inputValue	: '7',
					width		: 45,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('HOLYDAY6', newValue);
						}
					}
				},{
					boxLabel	: '일',
					name		: 'HOLYDAY7',
					inputValue	: '1',
					width		: 47,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('HOLYDAY7', newValue);
						}
					}
				}]
			},{
				xtype	: 'button',
				text	: '선납적용',
				holdable: 'hold',
				width	: 70,
				handler	: function() {
					fnPrePayment();
				}
			}]
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS742" default="비고"/>',
			xtype		: 'uniTextfield',
			name		: 'REMARK',
			layout		: {type : 'uniTable', columns : 3},
			width		: 605,
			colspan		: 3,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('REMARK', newValue);
				}
			}
		},{
			fieldLabel	: 'FIRST_YN',
			xtype		: 'uniTextfield',
			name		: 'FIRST_YN',
			hidden: true
		},{
			xtype	: 'container',
			padding : '0 0 3 0',
			layout	: {type:'uniTable'},
			tdAttrs	: {align: 'right'},
			items	: [{
				xtype	: 'button',
				text	: 'SMS 발송',
				width	: 70,
				handler	: function() {
					this.openPopup();
				},
				//공통팝업(SMS 전송팝업 호출)
				app			: 'Unilite.app.popup.SendSMS',
				api			: 'popupService.sendSMS',
				openPopup	: function() {
					var me		= this;
					var param	= {};

					param['CUSTOM_CODE']	= panelSearch.getValue('CUSTOM_CODE');
					param['CUSTOM_NAME']	= panelSearch.getValue('CUSTOM_NAME');
					param['TYPE']			= 'TEXT';
					param['pageTitle']		= me.pageTitle;

					if(me.app) {
						var fn = function() {
							var oWin =  Ext.WindowMgr.get(me.app);
							if(!oWin) {
								oWin = Ext.create( me.app, {
									id				: me.app,
									callBackFn		: me.processResult,
									callBackScope	: me,
									popupType		: 'TEXT',
									width			: 750,
									height			: 450,
									title			: 'SMS 전송',
									param			: param
								});
							}
							oWin.fnInitBinding(param);
							oWin.center();
							oWin.show();
						}
					}
				Unilite.require(me.app, fn, this, true);
				}
			}]
		}],
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
				if(gsSaveRefFlag == "Y" && basicForm.getField('REMARK').isDirty()){
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
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}

						}
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
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

	//무역 master정보 폼
	var panelTrade = Unilite.createSearchForm('tradeForm',{
		region		: 'south',
		layout		: {type : 'uniTable', columns : 3},
		padding		: '1 1 1 1',
		border		: true,
		collapsible	: true,
		extensible	: true,
		height		: 10,
		flex		: 0.4,
		autoScroll	: true,
		defaults	: {holdable: 'hold'},
		items		: [{
			xtype	: 'container',
			layout	: {type:'uniTable', column:2},
			defaults: {holdable: 'hold'},
			items	: [{
					name		: 'PAY_TERMS',
					fieldLabel	: '결제조건',
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
			name		: 'PAY_METHODE1',
			fieldLabel	: '대금결제방법',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T016',
			allowBlank	: false
		},{
			name		: 'TERMS_PRICE',
			fieldLabel	: '가격조건',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T005',
			allowBlank	: false
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '대행자',
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
			name		: 'DATE_DEPART',
			fieldLabel	: '작성일',
			xtype		: 'uniDatefield',
			value		: new Date(),
			allowBlank	: false
		},{
			name		: 'DATE_EXP',
			fieldLabel	: '유효일',
			xtype		: 'uniDatefield',
			value		: new Date()
		},{
			name		: 'METH_CARRY',
			fieldLabel	: '운송방법',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T004'
		},{
			name		: 'COND_PACKING',
			fieldLabel	: '포장방법',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T010'
		},{
			name		: 'METH_INSPECT',
			fieldLabel	: '검사방법',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T011'
		},{
			name		: 'SHIP_PORT',
			fieldLabel	: '선적항',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T008'
		},{
			name		: 'DEST_PORT',
			fieldLabel	: '도착항',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T008'
		},
		Unilite.popup('BANK',{
			fieldLabel		: '송금은행',
			valueFieldName	: 'BANK_CODE',
			textFieldName	: 'BANK_NAME'
		})],
		listeners: {
//			uniOnChange: function(basicForm, dirty, eOpts) {
//				if(gsSaveRefFlag == "Y" && basicForm.getField('REMARK').isDirty()){
//					UniAppManager.setToolbarButtons('save', true);
//				}
//			}
		},
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
				if(invalid.length == 0) {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}

						}
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')  ;
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
			load	: 's_sof101ukrv_ypService.selectMaster',
			submit	: 's_sof101ukrv_ypService.syncForm'
		}
	});



	/** 수주정보 그리드 Context Menu
	 */
	var detailGrid = Unilite.createGrid('s_sof101ukrv_ypGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true,
//			useContextMenu		: true,
			onLoadSelectFirst	: true,
			copiedRow			: false
		},
		margin	: 0,
		tbar	: [{
			xtype	: 'button',
			itemId	: 'refTool',
			text	: '참조...',
			iconCls	: 'icon-referance',
			menu	: Ext.create('Ext.menu.Menu', {
				items: [/*{
					itemId	: 'estimateBtn',
					text	: '견적참조',
					handler	: function() {
						openEstimateWindow();
					}
				},{
					itemId	: 'refBtn',
					text	: '수주이력참조',
					handler	: function() {
						openRefWindow();
					}
				}, {
					itemId	: 'scmBtn',
					text	: '업체발주참조(SCM)',
					handler	: function() {
						openScmWindow();
					}
				},*/{
					itemId	: 'excelBtn',
					text	: '엑셀참조',
					handler	: function() {
						openExcelWindow();
					}
				}]
			})
		},{
			xtype	: 'button',
			itemId	: 'procTool',
			text	: '프로세스...',  iconCls: 'icon-link',
			menu	: Ext.create('Ext.menu.Menu', {
				items: [
					/* {
					itemId	: 'reqIssueLinkBtn',
					text	: '출하지시등록',
					handler	: function() {
						var params = {
							'ORDER_NUM' : panelSearch.getValue('ORDER_NUM')
						}
						var rec = {data : {prgID : 'srq101ukrv', 'text':'출하지시등록'}};
						parent.openTab(rec, '/sales/srq101ukrv.do', params);
						// srq100ukrv의 fnInitBinding(params)에서 처리되도록 구현되어야 함. (cmb200ukrv.jsp 참고)

					}
				} ,*/
				{
					itemId	: 'issueLinkBtn',
					text	: '출고등록(개별)(양평)',
					handler	: function() {
						if(detailStore.isDirty()){
							alert(Msg.sMS027);
							return false;
						}
						if(detailStore.getCount() != 0){
							var params = {
								action		: 'select',
								'PGM_ID'	: 's_sof101ukrv_yp',
								'record'	: detailStore.data.items,
								'formPram'	: panelSearch.getValues()
							}

							var rec = {data : {prgID : 's_str103ukrv_yp', 'text':''}};
							parent.openTab(rec, '/z_yp/s_str103ukrv_yp.do', params, CHOST+CPATH);
						} else {
							alert('링크할 데이터가 없습니다.');
							return false;
						}
					}
				},{
					itemId	: 'issueLinkBtn2',
					text	: '수주등록(일반)(양평)',
					handler	: function() {
						if(detailStore.isDirty()){
							alert(Msg.sMS027);
							return false;
						}
						if(detailStore.getCount() != 0){
							var params = {
								action		: 'select',
								'PGM_ID'	: 's_sof101ukrv_yp',
								'ORDER_NUM'	: panelSearch.getValue('ORDER_NUM')
							}

							var rec = {data : {prgID : 's_sof100ukrv_yp', 'text':''}};
							parent.openTab(rec, '/z_yp/s_sof100ukrv_yp.do', params, CHOST+CPATH);
						} else {
							alert('링크할 데이터가 없습니다.');
							return false;
						}
					}
				}/*, {
					itemId: 'saleLinkBtn',
					text: '매출등록',
					handler: function() {
						var params = {
							ORDER_NO : panelSearch.getValue('ORDER_NO')
						}
						var rec = {data : {prgID : 'ssa100ukrv', 'text':''}};
						parent.openTab(rec, '/sales/ssa100ukrv.do', params);
					}
				}*/]
			})
		}],
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} ],
		columns: [
			{dataIndex: 'SER_NO'			, width: 60		, hidden: true},
			{dataIndex: 'OUT_DIV_CODE'		, width: 120	, hidden: true},
			{dataIndex: 'SO_KIND'			, width: 80		, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 100	, locked: false,
			 editor: Unilite.popup('DIV_PUMOK_YP_G', {
				textFieldName	: 'ITEM_CODE',
				DBtextFieldName	: 'ITEM_CODE',
				autoPopup		: true,
				extParam		: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
				listeners		: {
					'onSelected': {
						fn: function(records, type) {
							console.log('records : ', records);
							Ext.each(records, function(record,i) {
								console.log('record',record);
								if(i==0) {
									detailGrid.setItemData(record, false, detailGrid.uniOpt.currentRecord);
								} else {
									UniAppManager.app.onNewDataButtonDown();
									detailGrid.setItemData(record, false, detailGrid.getSelectedRecord());
								}
								param = {
									DIV_CODE		: record.DIV_CODE,
									ITEM_CODE		: record.ITEM_CODE,
									CUSTOM_CODE		: panelSearch.getValue('CUSTOM_CODE')
								}
								s_sof101ukrv_ypService.getCustomItemCode(param, function(provider, response){
									if(!Ext.isEmpty(provider)) {
										grdRecord = detailGrid.getSelectedRecord();
										if(!Ext.isEmpty(provider.CUSTOM_ITEM_CODE)) {
											if(Ext.isEmpty(grdRecord.get('CUSTOM_ITEM_CODE'))) {
												grdRecord.set('CUSTOM_ITEM_CODE', provider.CUSTOM_ITEM_CODE);
											}
										}
										if(Ext.isEmpty(grdRecord.get('CUSTOM_ITEM_NAME'))) {
											grdRecord.set('CUSTOM_ITEM_NAME', provider.CUSTOM_ITEM_NAME);
										}
									}
								});
							});
						},
						scope: this
					},
					'onClear': function(type) {
//						detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
					},
					applyextparam: function(popup){
						var record = detailGrid.getSelectedRecord();
						var divCode = record.get('OUT_DIV_CODE');
						popup.setExtParam({'PGM_ID': 'S_SOF101UKRV'});
						popup.setExtParam({'SELMODEL': 'MULTI'});
						popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
						popup.setExtParam({'DIV_CODE': divCode});
						popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
						popup.setExtParam({'ORDER_DATE': UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE'))});

						if(BsaCodeInfo.gsBalanceOut == 'Y') {
							popup.setExtParam({'ADD_QUERY': "ISNULL(A.B_OUT_YN, 'N') != N'Y'"});			//WHERE절 추가 쿼리
						}
					}
				}
			})},
			{dataIndex: 'ITEM_NAME'			, width: 150	, locked: false,
			 editor: Unilite.popup('DIV_PUMOK_YP_G', {
				autoPopup	: true,
				extParam	: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
				listeners	: {
					'onSelected': {
						fn: function(records, type) {
							console.log('records : ', records);
							Ext.each(records, function(record,i) {
								console.log('record',record);
								if(i==0) {
									detailGrid.setItemData(record, false, detailGrid.uniOpt.currentRecord);
								} else {
									UniAppManager.app.onNewDataButtonDown();
									detailGrid.setItemData(record, false, detailGrid.getSelectedRecord());
								}
								param = {
									DIV_CODE		: record.DIV_CODE,
									ITEM_CODE		: record.ITEM_CODE,
									CUSTOM_CODE		: panelSearch.getValue('CUSTOM_CODE')
								}
								s_sof101ukrv_ypService.getCustomItemCode(param, function(provider, response){
									if(!Ext.isEmpty(provider)) {
										grdRecord = detailGrid.getSelectedRecord();
										if(!Ext.isEmpty(provider.CUSTOM_ITEM_CODE)) {
											if(Ext.isEmpty(grdRecord.get('CUSTOM_ITEM_CODE'))) {
												grdRecord.set('CUSTOM_ITEM_CODE', provider.CUSTOM_ITEM_CODE);
											}
										}
										if(Ext.isEmpty(grdRecord.get('CUSTOM_ITEM_NAME'))) {
											grdRecord.set('CUSTOM_ITEM_NAME', provider.CUSTOM_ITEM_NAME);
										}
									}
								});
							});
						},
						scope: this
					},
					'onClear': function(type) {
//						detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
					},
					applyextparam: function(popup){
						var record = detailGrid.getSelectedRecord();
						var divCode = record.get('OUT_DIV_CODE');
						popup.setExtParam({'PGM_ID': 'S_SOF101UKRV'});
						popup.setExtParam({'SELMODEL': 'MULTI'});
						popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
						popup.setExtParam({'DIV_CODE': divCode});
						popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
						popup.setExtParam({'ORDER_DATE': UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE'))});
						if(BsaCodeInfo.gsBalanceOut == 'Y') {
							popup.setExtParam({'ADD_QUERY': "ISNULL(A.B_OUT_YN, 'N') != N'Y'"});			//WHERE절 추카 쿼리
						}
					}
				}
			})},
			{dataIndex: 'ITEM_ACCOUNT'		, width: 150	, hidden: true},
			{dataIndex: 'SPEC'				, width: 150,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
				}
			},
			{dataIndex: 'CUSTOM_ITEM_CODE'	, width: 80		, hidden: true},
			{dataIndex: 'CUSTOM_ITEM_NAME'	, width: 120},
			{dataIndex: 'CUSTOM_ITEM_DESC'	, width: 200	},
			{dataIndex: 'ORDER_UNIT'		, width: 80		, hidden: false},
			{dataIndex: 'TRANS_RATE'		, width: 90		, hidden: true},
			{dataIndex: 'ORDER_P'			, width: 100	, hidden: false/*	, summaryType: 'sum'*/},
			{dataIndex: 'ORDER_Q'			, width: 100	, hidden: false	, summaryType: 'sum'},
			{id	: 'dvryDate1',
				columns: [
					{dataIndex: 'NEW_YN1'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'SER_NO1'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_Q1'			, width: 100	, summaryType: 'sum'},
					{dataIndex: 'ORDER_O1'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_TAX_O1'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_O_TAX_O1'	, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'DVRY_DATE1'		, width: 90		, editable: false},
					{dataIndex: 'PROD_END_DATE1'	, width: 90},
					{dataIndex: 'EXP_ISSUE_DATE1'	, width: 90},
					{dataIndex: 'GOODS_DIVISION1'	, width: 90},	//202109 jhj:농공수산 추가
					{dataIndex: 'WONSANGI1'			, width: 110,   hidden: true},		//202109 jhj:농공수산 추가
					{dataIndex: 'FARM_NAME1'		, width: 110,   hidden: true},		//202109 jhj:농가코드 추가
					{dataIndex: 'CUSTOM_CODE1'		, width: 110,   hidden: true},		//202109 jhj거래처코드 추가
					{dataIndex: 'PREV_ORDER_Q1'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'STOCK_Q1'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'OUTSTOCK_Q1'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ISSUE_REQ_Q1'		, width: 90		, editable: false		, hidden: true},
					{dataIndex: 'ORDER_UNIT_Q1'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'PROD_SALE_Q1'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'SALE_Q1'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'PROD_Q1'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'REMARK1'			, width: 100	}
				]
			},
			{id	: 'dvryDate2',
				columns: [
					{dataIndex: 'NEW_YN2'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'SER_NO2'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_Q2'			, width: 100	, summaryType: 'sum'},
					{dataIndex: 'ORDER_O2'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_TAX_O2'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_O_TAX_O2'	, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'DVRY_DATE2'		, width: 90		, editable: false},
					{dataIndex: 'PROD_END_DATE2'	, width: 90},
					{dataIndex: 'EXP_ISSUE_DATE2'	, width: 90},
					{dataIndex: 'GOODS_DIVISION2'	, width: 90},	//202109 jhj:농공수산 추가
					{dataIndex: 'WONSANGI2'			, width: 110,   hidden: true},	//202109 jhj:농공수산 추가
					{dataIndex: 'FARM_NAME2'		, width: 110,   hidden: true},		//202109 jhj농가코드 추가
					{dataIndex: 'CUSTOM_CODE2'		, width: 110,   hidden: true},		//202109 jhj거래처코드 추가
					{dataIndex: 'PREV_ORDER_Q2'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'STOCK_Q2'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'OUTSTOCK_Q2'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ISSUE_REQ_Q2'		, width: 90		, editable: false		, hidden: true},
					{dataIndex: 'ORDER_UNIT_Q2'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'PROD_SALE_Q2'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'SALE_Q2'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'PROD_Q2'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'REMARK2'			, width: 100	}
				]
			},
			{id	: 'dvryDate3',
				columns: [
					{dataIndex: 'NEW_YN3'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'SER_NO3'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_Q3'			, width: 100	, summaryType: 'sum'},
					{dataIndex: 'ORDER_O3'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_TAX_O3'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_O_TAX_O3'	, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'DVRY_DATE3'		, width: 90		, editable: false},
					{dataIndex: 'PROD_END_DATE3'	, width: 90},
					{dataIndex: 'EXP_ISSUE_DATE3'	, width: 90},
					{dataIndex: 'GOODS_DIVISION3'	, width: 90},	//202109 jhj:농공수산 추가
					{dataIndex: 'WONSANGI3'			, width: 110,   hidden: true},	//202109 jhj:농공수산 추가
					{dataIndex: 'FARM_NAME3'		, width: 110,   hidden: true},		//202109 jhj농가코드 추가
					{dataIndex: 'CUSTOM_CODE3'		, width: 110,   hidden: true},		//202109 jhj거래처코드 추가
					{dataIndex: 'PREV_ORDER_Q3'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'STOCK_Q3'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'OUTSTOCK_Q3'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ISSUE_REQ_Q3'		, width: 90		, editable: false		, hidden: true},
					{dataIndex: 'ORDER_UNIT_Q3'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'PROD_SALE_Q3'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'SALE_Q3'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'PROD_Q3'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'REMARK3'			, width: 100	}
				]
			},
			{id	: 'dvryDate4',
				columns: [
					{dataIndex: 'NEW_YN4'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'SER_NO4'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_Q4'			, width: 100	, summaryType: 'sum'},
					{dataIndex: 'ORDER_O4'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_TAX_O4'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_O_TAX_O4'	, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'DVRY_DATE4'		, width: 90		, editable: false},
					{dataIndex: 'PROD_END_DATE4'	, width: 90},
					{dataIndex: 'EXP_ISSUE_DATE4'	, width: 90},
					{dataIndex: 'GOODS_DIVISION4'	, width: 90},	//202109 jhj:농공수산 추가
					{dataIndex: 'WONSANGI4'			, width: 110,   hidden: true},	//202109 jhj:농공수산 추가
					{dataIndex: 'FARM_NAME4'		, width: 110,   hidden: true},		//202109 jhj농가코드 추가
					{dataIndex: 'CUSTOM_CODE4'		, width: 110,   hidden: true},		//202109 jhj거래처코드 추가
					{dataIndex: 'PREV_ORDER_Q4'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'STOCK_Q4'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'OUTSTOCK_Q4'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ISSUE_REQ_Q4'		, width: 90		, editable: false		, hidden: true},
					{dataIndex: 'ORDER_UNIT_Q4'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'PROD_SALE_Q4'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'SALE_Q4'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'PROD_Q4'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'REMARK4'			, width: 100	}
				]
			},
			{id	: 'dvryDate5',
				columns: [
					{dataIndex: 'NEW_YN5'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'SER_NO5'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_Q5'			, width: 100	, summaryType: 'sum'},
					{dataIndex: 'ORDER_O5'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_TAX_O5'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_O_TAX_O5'	, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'DVRY_DATE5'		, width: 90		, editable: false},
					{dataIndex: 'PROD_END_DATE5'	, width: 90},
					{dataIndex: 'EXP_ISSUE_DATE5'	, width: 90},
					{dataIndex: 'GOODS_DIVISION5'	, width: 90},	//202109 jhj:농공수산 추가
					{dataIndex: 'WONSANGI5'			, width: 110,   hidden: true},	//202109 jhj:농공수산 추가
					{dataIndex: 'FARM_NAME5'		, width: 110,   hidden: true},		//202109 jhj농가코드 추가
					{dataIndex: 'CUSTOM_CODE5'		, width: 110,   hidden: true},		//202109 jhj거래처코드 추가
					{dataIndex: 'PREV_ORDER_Q5'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'STOCK_Q5'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'OUTSTOCK_Q5'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ISSUE_REQ_Q5'		, width: 90		, editable: false		, hidden: true},
					{dataIndex: 'ORDER_UNIT_Q5'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'PROD_SALE_Q5'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'SALE_Q5'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'PROD_Q5'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'REMARK5'			, width: 100	}
				]
			},
			{id	: 'dvryDate6',
				columns: [
					{dataIndex: 'NEW_YN6'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'SER_NO6'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_Q6'			, width: 100	, summaryType: 'sum'},
					{dataIndex: 'ORDER_O6'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_TAX_O6'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_O_TAX_O6'	, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'DVRY_DATE6'		, width: 90		, editable: false},
					{dataIndex: 'PROD_END_DATE6'	, width: 90},
					{dataIndex: 'EXP_ISSUE_DATE6'	, width: 90},
					{dataIndex: 'GOODS_DIVISION6'	, width: 90},	//202109 jhj:농공수산 추가
					{dataIndex: 'WONSANGI6'			, width: 110,   hidden: true},	//202109 jhj:농공수산 추가
					{dataIndex: 'FARM_NAME6'		, width: 110,   hidden: true},		//202109 jhj농가코드 추가
					{dataIndex: 'CUSTOM_CODE6'		, width: 110,   hidden: true},		//202109 jhj거래처코드 추가
					{dataIndex: 'PREV_ORDER_Q6'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'STOCK_Q6'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'OUTSTOCK_Q6'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ISSUE_REQ_Q6'		, width: 90		, editable: false		, hidden: true},
					{dataIndex: 'ORDER_UNIT_Q6'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'PROD_SALE_Q6'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'SALE_Q6'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'PROD_Q6'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'REMARK6'			, width: 100	}
				]
			},
			{id	: 'dvryDate7',
				columns: [
					{dataIndex: 'NEW_YN7'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'SER_NO7'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_Q7'			, width: 100	, summaryType: 'sum'},
					{dataIndex: 'ORDER_O7'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_TAX_O7'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ORDER_O_TAX_O7'	, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'DVRY_DATE7'		, width: 90		, editable: false},
					{dataIndex: 'PROD_END_DATE7'	, width: 90},
					{dataIndex: 'EXP_ISSUE_DATE7'	, width: 90},
					{dataIndex: 'GOODS_DIVISION7'	, width: 90},	//202109 jhj:농공수산 추가
					{dataIndex: 'WONSANGI7'			, width: 110,   hidden: true},	//202109 jhj:농공수산 추가
					{dataIndex: 'FARM_NAME7'		, width: 110,   hidden: true},		//202109 jhj농가코드 추가
					{dataIndex: 'CUSTOM_CODE7'		, width: 110,   hidden: true},		//202109 jhj거래처코드 추가
					{dataIndex: 'PREV_ORDER_Q7'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'STOCK_Q7'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'OUTSTOCK_Q7'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'ISSUE_REQ_Q7'		, width: 90		, editable: false		, hidden: true},
					{dataIndex: 'ORDER_UNIT_Q7'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'PROD_SALE_Q7'		, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'SALE_Q7'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'PROD_Q7'			, width: 100	, editable: false		, hidden: true},
					{dataIndex: 'REMARK7'			, width: 100	}
				]
			},

			{dataIndex: 'DISCOUNT_MONEY'	, width: 70		, hidden: true},
			{dataIndex: 'ORDER_O'			, width: 100	, hidden: true	, summaryType: 'sum'},
			{dataIndex: 'ORDER_WGT_Q'		, width: 110	, hidden: true},
			{dataIndex: 'ORDER_WGT_P'		, width: 100	, hidden: true},
			{dataIndex: 'ORDER_VOL_Q'		, width: 110	, hidden: true},
			{dataIndex: 'ORDER_VOL_P'		, width: 100	, hidden: true},

			{dataIndex: 'TAX_TYPE'			, width: 80},
			{dataIndex: 'ORDER_TAX_O'		, width: 110	, hidden: true	, summaryType: 'sum'},
			{dataIndex: 'ORDER_O_TAX_O'		, width: 110	, hidden: true	, summaryType: 'sum'},
			{dataIndex: 'WGT_UNIT'			, width: 80		, hidden: true},
			{dataIndex: 'UNIT_WGT'			, width: 90		, hidden: true},
			{dataIndex: 'VOL_UNIT'			, width: 80		, hidden: true},
			{dataIndex: 'UNIT_VOL'			, width: 90		, hidden: true},
			{dataIndex: 'DVRY_DATE'			, width: 90		, hidden: true},
			{dataIndex: 'DISCOUNT_RATE'		, width: 80		, hidden: true},
			{dataIndex: 'DVRY_CUST_NAME'	, width: 100	, hidden: true	,
			 editor: Unilite.popup('DELIVERY_G',{
				listeners:{
					'onSelected': {
						fn: function(records, type  ){
							//var grdRecord = Ext.getCmp('s_sof101ukrv_ypGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DVRY_CUST_CD',records[0]['DELIVERY_CODE']);
							grdRecord.set('DVRY_CUST_NAME',records[0]['DELIVERY_NAME']);
						},
						scope: this
					},
					'onClear' : function(type)	{
							//var grdRecord = Ext.getCmp('s_sof101ukrv_ypGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DVRY_CUST_CD','');
							grdRecord.set('DVRY_CUST_NAME','');
					},
					applyextparam: function(popup){
						popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')});
					}
				}
			})},
			{dataIndex: 'DVRY_TIME'			, width: 100	, hidden: true},
			{dataIndex: 'OUT_WH_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'ACCOUNT_YNC'		, width: 80		, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 110	, hidden: false,
			 editor: Unilite.popup('AGENT_CUST_G',{
				listeners:{
					'onSelected': {
						fn: function(records, type  ){
							//var grdRecord = Ext.getCmp('s_sof101ukrv_ypGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SALE_CUST_CD',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
						},
						scope: this
					},
					'onClear' : function(type)	{
						//var grdRecord = Ext.getCmp('s_sof101ukrv_ypGrid').uniOpt.currentRecord;
						var grdRecord = detailGrid.uniOpt.currentRecord;
						grdRecord.set('SALE_CUST_CD','');
						grdRecord.set('CUSTOM_NAME','');
					}
				}
			})},
			{dataIndex: 'PRICE_YN'			, width: 80		, hidden: true},
			{dataIndex: 'STOCK_Q'			, width: 100	, hidden: true},
			{dataIndex: 'PROD_SALE_Q'		, width: 100	, hidden: true},
			{dataIndex: 'PROD_Q'			, width: 140	, hidden: true},
			{dataIndex: 'PROD_END_DATE'		, width: 90		, hidden: true},
			{dataIndex: 'DVRY_CUST_CD'		, width: 100	, hidden: true},

			{dataIndex: 'ORDER_STATUS'		, width: 80		, hidden: true},
			{dataIndex: 'PO_NUM'			, width: 110	, hidden: true},
			{dataIndex: 'PO_SEQ'			, width: 80		, hidden: true},
			{dataIndex: 'PROJECT_NO'		, width: 130	, hidden: true},
//			{dataIndex: 'ISSUE_REQ_Q'		, width: 90		, hidden: true},
			{dataIndex: 'ESTI_NUM'			, width: 100	, hidden: true},
			{dataIndex: 'ESTI_SEQ'			, width: 80		, hidden: true},
			{dataIndex: 'BARCODE'			, width: 120	, hidden: true},
			{dataIndex: 'REMARK'			, width: 300	, hidden: true},
			{dataIndex: 'NATION_INOUT'		, width: 80		, hidden: true},
			{dataIndex: 'MONEY_UNIT'		, width: 80		, hidden: true},
			{dataIndex: 'OFFER_NO'			, width: 80		, hidden: true},
			{dataIndex: 'EXP_ISSUE_DATE'	, width: 90		, hidden: true},
			{dataIndex: 'GOODS_DIVISION'	, width: 90		, hidden: true}	//202109 jhj:농공수산 추가
		],
		listeners: {
			//contextMenu의 복사한 행 삽입 실행 전
			beforePasteRecord: function(rowIndex, record) {
				if(!UniAppManager.app.checkForNewDetail()) return false;

				var seq = detailStore.max('SER_NO');
				if(!seq) seq = 1;
				else  seq += 1;
				record.SER_NO = seq;

				return true;
			},
			//contextMenu의 복사한 행 삽입 실행 후
			afterPasteRecord: function(rowIndex, record) {
				panelSearch.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(BsaCodeInfo.gsDraftFlag == 'Y' && Ext.getCmp('status').getChecked()[0].inputValue != '1')  {
					return false;
				} else if(e.record.phantom ) {
					if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
						if (UniUtils.indexOf(e.field,
											['ITEM_CODE','ITEM_NAME','ORDER_UNIT','TRANS_RATE','TAX_TYPE','ACCOUNT_YNC','ORDER_STATUS',
											 'ESTI_NUM','ESTI_SEQ','WGT_UNIT','UNIT_WGT','VOL_UNIT','UNIT_VOL',
											 'ORDER_P1','ORDER_P2','ORDER_P3','ORDER_P4','ORDER_P5','ORDER_P6','ORDER_P7',
											 'STOCK_Q1','STOCK_Q2','STOCK_Q3','STOCK_Q4','STOCK_Q5','STOCK_Q6','STOCK_Q7',
											 'PROD_Q1','PROD_Q2','PROD_Q3','PROD_Q4','PROD_Q5','PROD_Q6','PROD_Q7',
											 'ORDER_O_TAX_O1','ORDER_O_TAX_O2','ORDER_O_TAX_O3','ORDER_O_TAX_O4','ORDER_O_TAX_O5','ORDER_O_TAX_O6','ORDER_O_TAX_O7']))
							return false;

					} else {
						if (UniUtils.indexOf(e.field,
											['SPEC','ORDER_STATUS','ESTI_NUM','WGT_UNIT','UNIT_WGT','VOL_UNIT','UNIT_VOL',
											'STOCK_Q1','STOCK_Q2','STOCK_Q3','STOCK_Q4','STOCK_Q5','STOCK_Q6','STOCK_Q7',
											'PROD_Q1','PROD_Q2','PROD_Q3','PROD_Q4','PROD_Q5','PROD_Q6','PROD_Q7',
											'ORDER_O_TAX_O1','ORDER_O_TAX_O2','ORDER_O_TAX_O3','ORDER_O_TAX_O4','ORDER_O_TAX_O5','ORDER_O_TAX_O6','ORDER_O_TAX_O7']))
							return false;

						if(panelSearch.getValue('BILL_TYPE') == '50')	{
							if(e.field=='TAX_TYPE') return false;
						}
					}
					if(e.record.data.TAX_TYPE != '1')	{
						if(e.field=='ORDER_TAX_O1') return false;
						if(e.field=='ORDER_TAX_O2') return false;
						if(e.field=='ORDER_TAX_O3') return false;
						if(e.field=='ORDER_TAX_O4') return false;
						if(e.field=='ORDER_TAX_O5') return false;
						if(e.field=='ORDER_TAX_O6') return false;
						if(e.field=='ORDER_TAX_O7') return false;
					}
					if(e.record.data.ITEM_ACCOUNT == '00')  {
						if(e.field=='PROD_SALE_Q1') return false;
						if(e.field=='PROD_SALE_Q2') return false;
						if(e.field=='PROD_SALE_Q3') return false;
						if(e.field=='PROD_SALE_Q4') return false;
						if(e.field=='PROD_SALE_Q5') return false;
						if(e.field=='PROD_SALE_Q6') return false;
						if(e.field=='PROD_SALE_Q7') return false;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','ORDER_P1','ORDER_P2','ORDER_P3','ORDER_P4','ORDER_P5','ORDER_P6','ORDER_P7']))
						return false;
					if(e.record.data.SALE_Q1 == 0)	{
						if(e.record.data.ISSUE_REQ_Q1 > 0 || e.record.data.OUTSTOCK_Q1 > 0)	{
							switch(e.field) {
								case 'ORDER_P1':
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
							if(UniUtils.indexOf(e.field, ['SER_NO','SPEC','STOCK_Q1','ESTI_NUM','ESTI_SEQ','PROD_Q1','ORDER_O_TAX_O1']))
								return false;

							if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
								if(UniUtils.indexOf(e.field, ['ORDER_UNIT','TRANS_RATE','ACCOUNT_YNC','ITEM_CODE','ITEM_NAME']))
									return false;

							}
							if(e.field=='TAX_TYPE') {
								if(panelSearch.getValue('BILL_TYPE') != "50")	{
									if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
											 return false;
									}
								}else {
									 return false;
								}
							}
							if(e.field=='PROD_SALE_Q1')  {
								if(panelSearch.getValue('ITEM_ACCOUNT') == "00") {
									return false;
								}
							}
							if(UniUtils.indexOf(e.field, ['WGT_UNIT','UNIT_WGT','VOL_UNIT','UNIT_VOL'])) return false;
						}
					}else {
						switch(e.field) {
							case 'ORDER_P1':
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
					if(e.record.data.SALE_Q2 == 0)	{
						if(e.record.data.ISSUE_REQ_Q2 > 0 || e.record.data.OUTSTOCK_Q2 > 0)	{
							switch(e.field) {
								case 'ORDER_P2':
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
							if(UniUtils.indexOf(e.field, ['SER_NO','SPEC','STOCK_Q2','ESTI_NUM','ESTI_SEQ','PROD_Q2','ORDER_O_TAX_O2']))
								return false;

							if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
								if(UniUtils.indexOf(e.field, ['ORDER_UNIT','TRANS_RATE','ACCOUNT_YNC','ITEM_CODE','ITEM_NAME']))
									return false;

							}
							if(e.field=='TAX_TYPE') {
								if(panelSearch.getValue('BILL_TYPE') != "50")	{
									if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
											 return false;
									}
								}else {
									 return false;
								}
							}
							if(e.field=='PROD_SALE_Q2')  {
								if(panelSearch.getValue('ITEM_ACCOUNT') == "00") {
									return false;
								}
							}
							if(UniUtils.indexOf(e.field, ['WGT_UNIT','UNIT_WGT','VOL_UNIT','UNIT_VOL'])) return false;
						}
					}else {
						switch(e.field) {
							case 'ORDER_P2':
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
					if(e.record.data.SALE_Q3 == 0)	{
						if(e.record.data.ISSUE_REQ_Q3 > 0 || e.record.data.OUTSTOCK_Q3 > 0)	{
							switch(e.field) {
								case 'ORDER_P3':
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
							if(UniUtils.indexOf(e.field, ['SER_NO','SPEC','STOCK_Q3','ESTI_NUM','ESTI_SEQ','PROD_Q3','ORDER_O_TAX_O3']))
								return false;

							if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
								if(UniUtils.indexOf(e.field, ['ORDER_UNIT','TRANS_RATE','ACCOUNT_YNC','ITEM_CODE','ITEM_NAME']))
									return false;

							}
							if(e.field=='TAX_TYPE') {
								if(panelSearch.getValue('BILL_TYPE') != "50")	{
									if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
											 return false;
									}
								}else {
									 return false;
								}
							}
							if(e.field=='PROD_SALE_Q3')  {
								if(panelSearch.getValue('ITEM_ACCOUNT') == "00") {
									return false;
								}
							}
							if(UniUtils.indexOf(e.field, ['WGT_UNIT','UNIT_WGT','VOL_UNIT','UNIT_VOL'])) return false;
						}
					}else {
						switch(e.field) {
							case 'ORDER_P3':
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
					if(e.record.data.SALE_Q4 == 0)	{
						if(e.record.data.ISSUE_REQ_Q4 > 0 || e.record.data.OUTSTOCK_Q4 > 0)	{
							switch(e.field) {
								case 'ORDER_P4':
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
							if(UniUtils.indexOf(e.field, ['SER_NO','SPEC','STOCK_Q4','ESTI_NUM','ESTI_SEQ','PROD_Q4','ORDER_O_TAX_O4']))
								return false;

							if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
								if(UniUtils.indexOf(e.field, ['ORDER_UNIT','TRANS_RATE','ACCOUNT_YNC','ITEM_CODE','ITEM_NAME']))
									return false;

							}
							if(e.field=='TAX_TYPE') {
								if(panelSearch.getValue('BILL_TYPE') != "50")	{
									if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
											 return false;
									}
								}else {
									 return false;
								}
							}
							if(e.field=='PROD_SALE_Q4')  {
								if(panelSearch.getValue('ITEM_ACCOUNT') == "00") {
									return false;
								}
							}
							if(UniUtils.indexOf(e.field, ['WGT_UNIT','UNIT_WGT','VOL_UNIT','UNIT_VOL'])) return false;
						}
					}else {
						switch(e.field) {
							case 'ORDER_P4':
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
					if(e.record.data.SALE_Q5 == 0)	{
						if(e.record.data.ISSUE_REQ_Q5 > 0 || e.record.data.OUTSTOCK_Q5 > 0)	{
							switch(e.field) {
								case 'ORDER_P5':
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
							if(UniUtils.indexOf(e.field, ['SER_NO','SPEC','STOCK_Q5','ESTI_NUM','ESTI_SEQ','PROD_Q5','ORDER_O_TAX_O5']))
								return false;

							if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
								if(UniUtils.indexOf(e.field, ['ORDER_UNIT','TRANS_RATE','ACCOUNT_YNC','ITEM_CODE','ITEM_NAME']))
									return false;

							}
							if(e.field=='TAX_TYPE') {
								if(panelSearch.getValue('BILL_TYPE') != "50")	{
									if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
											 return false;
									}
								}else {
									 return false;
								}
							}
							if(e.field=='PROD_SALE_Q5')  {
								if(panelSearch.getValue('ITEM_ACCOUNT') == "00") {
									return false;
								}
							}
							if(UniUtils.indexOf(e.field, ['WGT_UNIT','UNIT_WGT','VOL_UNIT','UNIT_VOL'])) return false;
						}
					}else {
						switch(e.field) {
							case 'ORDER_P5':
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
					if(e.record.data.SALE_Q6 == 0)	{
						if(e.record.data.ISSUE_REQ_Q6 > 0 || e.record.data.OUTSTOCK_Q6 > 0)	{
							switch(e.field) {
								case 'ORDER_P6':
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
							if(UniUtils.indexOf(e.field, ['SER_NO','SPEC','STOCK_Q6','ESTI_NUM','ESTI_SEQ','PROD_Q6','ORDER_O_TAX_O6']))
								return false;

							if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
								if(UniUtils.indexOf(e.field, ['ORDER_UNIT','TRANS_RATE','ACCOUNT_YNC','ITEM_CODE','ITEM_NAME']))
									return false;

							}
							if(e.field=='TAX_TYPE') {
								if(panelSearch.getValue('BILL_TYPE') != "50")	{
									if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
											 return false;
									}
								}else {
									 return false;
								}
							}
							if(e.field=='PROD_SALE_Q6')  {
								if(panelSearch.getValue('ITEM_ACCOUNT') == "00") {
									return false;
								}
							}
							if(UniUtils.indexOf(e.field, ['WGT_UNIT','UNIT_WGT','VOL_UNIT','UNIT_VOL'])) return false;
						}
					}else {
						switch(e.field) {
							case 'ORDER_P6':
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
					if(e.record.data.SALE_Q7 == 0)	{
						if(e.record.data.ISSUE_REQ_Q7 > 0 || e.record.data.OUTSTOCK_Q7 > 0)	{
							switch(e.field) {
								case 'ORDER_P7':
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
							if(UniUtils.indexOf(e.field, ['SER_NO','SPEC','STOCK_Q7','ESTI_NUM','ESTI_SEQ','PROD_Q7','ORDER_O_TAX_O7']))
								return false;

							if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
								if(UniUtils.indexOf(e.field, ['ORDER_UNIT','TRANS_RATE','ACCOUNT_YNC','ITEM_CODE','ITEM_NAME']))
									return false;

							}
							if(e.field=='TAX_TYPE') {
								if(panelSearch.getValue('BILL_TYPE') != "50")	{
									if(!Ext.isEmpty(e.record.data.ESTI_NUM))	{
											 return false;
									}
								}else {
									 return false;
								}
							}
							if(e.field=='PROD_SALE_Q7')  {
								if(panelSearch.getValue('ITEM_ACCOUNT') == "00") {
									return false;
								}
							}
							if(UniUtils.indexOf(e.field, ['WGT_UNIT','UNIT_WGT','VOL_UNIT','UNIT_VOL'])) return false;
						}
					}else {
						switch(e.field) {
							case 'ORDER_P7':
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
				if(e.record.data.ORDER_Q1 == 0) {
					if(UniUtils.indexOf(e.field, ['REMARK1'])) return false;
				}
				if(e.record.data.ORDER_Q2 == 0) {
					if(UniUtils.indexOf(e.field, ['REMARK2'])) return false;
				}
				if(e.record.data.ORDER_Q3 == 0) {
					if(UniUtils.indexOf(e.field, ['REMARK3'])) return false;
				}
				if(e.record.data.ORDER_Q4 == 0) {
					if(UniUtils.indexOf(e.field, ['REMARK4'])) return false;
				}
				if(e.record.data.ORDER_Q5 == 0) {
					if(UniUtils.indexOf(e.field, ['REMARK5'])) return false;
				}
				if(e.record.data.ORDER_Q6 == 0) {
					if(UniUtils.indexOf(e.field, ['REMARK6'])) return false;
				}
				if(e.record.data.ORDER_Q7 == 0) {
					if(UniUtils.indexOf(e.field, ['REMARK7'])) return false;
				}
			}
		},
/*		// 프로세스 버튼 활성(false)/비활성화(true)
		disabledLinkButtons: function(b) {
			this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
			this.down('#procTool').menu.down('#issueLinkBtn').setDisabled(b);
			this.down('#procTool').menu.down('#saleLinkBtn').setDisabled(b);
		},*/
		////품목정보 팝업에서 선택된 데이타 수주정보 그리드에 추가하는 함수, 품목팝업의 onSelected/onClear 이벤트가 일어날때 호출됨
		setItemData: function(record, dataClear, grdRecord) {
//			var grdRecord = this.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		,"");
				grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('STOCK_UNIT'		,"");
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

				grdRecord.set('STOCK_Q1'		,0);
				grdRecord.set('STOCK_Q2'		,0);
				grdRecord.set('STOCK_Q3'		,0);
				grdRecord.set('STOCK_Q4'		,0);
				grdRecord.set('STOCK_Q5'		,0);
				grdRecord.set('STOCK_Q6'		,0);
				grdRecord.set('STOCK_Q7'		,0);

				grdRecord.set('ORDER_P1'		,0);
				grdRecord.set('ORDER_P2'		,0);
				grdRecord.set('ORDER_P3'		,0);
				grdRecord.set('ORDER_P4'		,0);
				grdRecord.set('ORDER_P5'		,0);
				grdRecord.set('ORDER_P6'		,0);
				grdRecord.set('ORDER_P7'		,0);

				grdRecord.set('ORDER_O1'		,0);
				grdRecord.set('ORDER_O2'		,0);
				grdRecord.set('ORDER_O3'		,0);
				grdRecord.set('ORDER_O4'		,0);
				grdRecord.set('ORDER_O5'		,0);
				grdRecord.set('ORDER_O6'		,0);
				grdRecord.set('ORDER_O7'		,0);

				grdRecord.set('ORDER_Q1'		,0);
				grdRecord.set('ORDER_Q2'		,0);
				grdRecord.set('ORDER_Q3'		,0);
				grdRecord.set('ORDER_Q4'		,0);
				grdRecord.set('ORDER_Q5'		,0);
				grdRecord.set('ORDER_Q6'		,0);
				grdRecord.set('ORDER_Q7'		,0);

				grdRecord.set('PROD_SALE_Q1'	,0);
				grdRecord.set('PROD_SALE_Q2'	,0);
				grdRecord.set('PROD_SALE_Q3'	,0);
				grdRecord.set('PROD_SALE_Q4'	,0);
				grdRecord.set('PROD_SALE_Q5'	,0);
				grdRecord.set('PROD_SALE_Q6'	,0);
				grdRecord.set('PROD_SALE_Q7'	,0);

				grdRecord.set('PROD_Q1'			,0);
				grdRecord.set('PROD_Q2'			,0);
				grdRecord.set('PROD_Q3'			,0);
				grdRecord.set('PROD_Q4'			,0);
				grdRecord.set('PROD_Q5'			,0);
				grdRecord.set('PROD_Q6'			,0);
				grdRecord.set('PROD_Q7'			,0);

			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('ORDER_UNIT'		, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('REF_WH_CODE'		, record['WH_CODE']);

				if(panelSearch.getValue('BILL_TYPE') != "50"){
					grdRecord.set('TAX_TYPE'		, record['TAX_TYPE']);
				}else{
					grdRecord.set('TAX_TYPE'		, "2");
				}
				grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
				grdRecord.set('OUT_DIV_CODE'		,record['DIV_CODE']);
				grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
				grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
				grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
				grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
				grdRecord.set('ORDER_NUM'			, panelSearch.getValue('ORDER_NUM'));

				UniSales.fnGetItemInfo(
					  grdRecord
					, UniAppManager.app.cbGetItemInfo
					, 'I'
					, UserInfo.compCode
					, panelSearch.getValue('CUSTOM_CODE')
					, CustomCodeInfo.gsAgentType
					, record['ITEM_CODE']
					, panelSearch.getValue('MONEY_UNIT')
					, record['SALE_UNIT']
					, record['STOCK_UNIT']
					, record['TRANS_RATE']
					, UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE'))
					, grdRecord.get('ORDER_Q')
					, record['WGT_UNIT']
					, record['VOL_UNIT']
					, record['UNIT_WGT']
					, record['UNIT_VOL']
					, record['PRICE_TYPE']
					, UserInfo.divCode
					, null
					, ''
				);
//				setTimeout( function() {
//					UniAppManager.app.fnOrderAmtCal(grdRecord, 'P');			//rtnRecord, sType, nValue, taxType, orderQ
//					detailStore.fnOrderAmtSum();
//				}, 1000)
			}
		},
/*		setEstiData:function(record) {											//견적참조 사용 안 함
			var grdRecord = this.getSelectedRecord();
			//grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('ORDER_NUM'			, panelSearch.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ESTI_UNIT']);
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);
			grdRecord.set('ORDER_Q'				, record['ESTI_QTY']);
			grdRecord.set('ORDER_P'				, record['ESTI_PRICE']);
			grdRecord.set('SCM_FLAG_YN'			, 'N');
			if(panelSearch.getValue('TAX_INOUT') != 50)
			{
				grdRecord.set('TAX_TYPE'		, record['TAX_TYPE'] );
			}
			if(Ext.isEmpty(panelSearch.getValue('DVRY_DATE')))	{

				grdRecord.set('DVRY_DATE'		, panelSearch.getValue('ORDER_DATE'));
			} else {
				grdRecord.set('DVRY_DATE'		, panelSearch.getValue('DVRY_DATE'));
			}
			grdRecord.set('DISCOUNT_RATE'		, 0);
			grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);
			grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
			grdRecord.set('OUT_DIV_CODE'		, UserInfo.divCode);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('ACCOUNT_YNC'			, 'Y');

			if(Ext.isEmpty(panelSearch.getValue('SALE_CUST_CD')))	{
				grdRecord.set('SALE_CUST_CD'	,panelSearch.getValue('CUSTOM_CODE'));
			} else {
				grdRecord.set('SALE_CUST_CD'	,panelSearch.getValue('SALE_CUST_CD'));
			}

			if(Ext.isEmpty(panelSearch.getValue('SALE_CUST_NM')))	{
				grdRecord.set('CUSTOM_NAME'		,panelSearch.getValue('CUSTOM_NAME'));
			} else {
				grdRecord.set('CUSTOM_NAME'		,panelSearch.getValue('SALE_CUST_NM'));
			}
			grdRecord.set('PROD_PLAN_Q'			, 0);
			grdRecord.set('ESTI_NUM'			, record['ESTI_NUM']);
			grdRecord.set('ESTI_SEQ'			, record['ESTI_SEQ']);
			grdRecord.set('REF_ORDER_DATE'		, panelSearch.getValue('ORDER_DATE'));
			grdRecord.set('REF_ORD_CUST'		, panelSearch.getValue('CUSTOM_CODE'));
			grdRecord.set('REF_ORDER_TYPE'		, panelSearch.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'		, panelSearch.getValue('PLAN_NUM'));
			grdRecord.set('REF_TAX_INOUT'		, Ext.getCmp('taxInout').getChecked()[0].inputValue);
			//FIXME gsExchageRate값 설정
			//grdRecord.set('REF_EXCHG_RATE_O'	  ,gsExchageRate);
			grdRecord.set('REF_REMARK'			, panelSearch.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'			, record['ESTI_QTY']);
			grdRecord.set('REF_BILL_TYPE'		, panelSearch.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH', panelSearch.getValue('RECEIPT_SET_METH'));
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);

			UniSales.fnGetItemInfo(grdRecord, UniAppManager.app.cbGetItemInfo
				, 'R'
				, UserInfo.compCode
				, panelSearch.getValue('CUSTOM_CODE')
				, CustomCodeInfo.gsAgentType
				, record['ITEM_CODE']
				, BsaCodeInfo.gsMoneyUnit
				, record['ESTI_UNIT']
				, record['STOCK_UNIT']
				, record['TRANS_RATE']
				, UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE'))
				, grdRecord.get('ORDER_Q')
				, record['WGT_UNIT']
				, record['VOL_UNIT']
				, record['UNIT_WGT']
				, record['UNIT_VOL']
				, record['PRICE_TYPE']
				, UserInfo.divCode
				, null
				, ''
			);


			//수주수량/단가(중량) 재계산
			var sUnitWgt	= record['UNIT_WGT'];
			var sOrderWgtQ = grdRecord.set('ORDER_WGT_Q', (record['ESTI_QTY'] * sUnitWgt));

			if( sUnitWgt == 0)  {
				grdRecord.set('ORDER_WGT_P'	 ,0);
			} else {
				grdRecord.set('ORDER_WGT_P', (record['ESTI_PRICE'] / sUnitWgt))
			}

			//수주수량/단가(부피) 재계산
			var sUnitVol	= record['UNIT_VOL'];
			var sOrderVolQ = grdRecord.set('ORDER_VOL_Q', (record['ESTI_QTY'] * sUnitVol));

			if( sUnitVol == 0)  {
				grdRecord.set('ORDER_VOL_P'	 ,0);
			} else {
				grdRecord.set('ORDER_VOL_P', (record['ESTI_PRICE'] / sUnitVol))
			}

		},
		setRefData: function(record) {											//수주참조 사용 안 함
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('ORDER_NUM'			, panelSearch.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('ORDER_P'				, record['ORDER_P']);
			grdRecord.set('SCM_FLAG_YN'		 , 'N');

			if(panelSearch.getValue('TAX_INOUT') != 50)
			{
				grdRecord.set('TAX_TYPE'		,record['TAX_TYPE']);
			}
			if(Ext.isEmpty(panelSearch.getValue('DVRY_DATE')))	{

				grdRecord.set('DVRY_DATE'		,panelSearch.getValue('ORDER_DATE'));
			}else {
				grdRecord.set('DVRY_DATE'		,panelSearch.getValue('DVRY_DATE'));
			}
			grdRecord.set('DISCOUNT_RATE'		, 0);
			grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);
			grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
			grdRecord.set('OUT_DIV_CODE'		, record['OUT_DIV_CODE']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('ACCOUNT_YNC'			, record['ACCOUNT_YNC']);


			if(Ext.isEmpty(panelSearch.getValue('SALE_CUST_CD')))	{
				grdRecord.set('SALE_CUST_CD'	,panelSearch.getValue('CUSTOM_CODE'));
			}else {
				grdRecord.set('SALE_CUST_CD'	,panelSearch.getValue('SALE_CUST_CD'));
			}

			if(Ext.isEmpty(panelSearch.getValue('SALE_CUST_NM')))	{
				grdRecord.set('CUSTOM_NAME'		,panelSearch.getValue('CUSTOM_NAME'));
			}else {
				grdRecord.set('CUSTOM_NAME'		,panelSearch.getValue('SALE_CUST_NM'));
			}

			grdRecord.set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);
			grdRecord.set('DVRY_CUST_NAME'		, record['DVRY_CUST_NAME']);
			grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
			grdRecord.set('PROD_PLAN_Q'			, 0);
			grdRecord.set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
			grdRecord.set('PRE_ACCNT_YN'		, record['PRE_ACCNT_YN']);
			grdRecord.set('REF_ORDER_DATE'		, panelSearch.getValue('ORDER_DATE'));
			grdRecord.set('REF_ORD_CUST'		, panelSearch.getValue('CUSTOM_CODE'));
			grdRecord.set('REF_ORDER_TYPE'		, panelSearch.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'		, panelSearch.getValue('PLAN_NUM'));
			grdRecord.set('REF_TAX_INOUT'		, Ext.getCmp('taxInout').getChecked()[0].inputValue);
			//FIXME gsExchageRate값 설정
			//grdRecord.set('REF_EXCHG_RATE_O'	  ,gsExchageRate);
			grdRecord.set('REF_REMARK'			, panelSearch.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'			, record['ORDER_Q']);
			grdRecord.set('REF_BILL_TYPE'		, panelSearch.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH', panelSearch.getValue('RECEIPT_SET_METH'));
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);

			UniSales.fnGetItemInfo(grdRecord
				, UniAppManager.app.cbGetItemInfo
				, 'R'
				, UserInfo.compCode
				, panelSearch.getValue('CUSTOM_CODE')
				, CustomCodeInfo.gsAgentType
				, record['ITEM_CODE']
				, BsaCodeInfo.gsMoneyUnit
				, record['ORDER_UNIT']
				, record['STOCK_UNIT']
				, record['TRANS_RATE']
				, UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE'))
				, grdRecord.get('ORDER_Q')
				, grdRecord.get('WGT_UNIT')
				, grdRecord.get('VOL_UNIT')
				, grdRecord.get('UNIT_WGT')
				, grdRecord.get('UNIT_VOL')
				, grdRecord.get('PRICE_TYPE')
				, record['OUT_DIV_CODE']
				, null
				, ''
			);

			//UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
			//UniAppManager.app.fnStockQ(grdRecord, UserInfo.compCode, record['OUT_DIV_CODE'], null,record['ITEM_CODE'],record['WH_CODE']);
		},*/
		setExcelData: function(record, returnMaxI, returnI) {
			UniAppManager.app.onNewDataButtonDown();
			var grdRecord = this.getSelectedRecord();
			var orderQ1 = Math.floor(record['ORDER_Q1'] * 100) / 100 ;
			var orderQ2 = Math.floor(record['ORDER_Q2'] * 100) / 100 ;
			var orderQ3 = Math.floor(record['ORDER_Q3'] * 100) / 100 ;
			var orderQ4 = Math.floor(record['ORDER_Q4'] * 100) / 100 ;
			var orderQ5 = Math.floor(record['ORDER_Q5'] * 100) / 100 ;
			var orderQ6 = Math.floor(record['ORDER_Q6'] * 100) / 100 ;
			var orderQ7 = Math.floor(record['ORDER_Q7'] * 100) / 100 ;

			grdRecord.set('ORDER_NUM'			, panelSearch.getValue('ORDER_NUM'));
			grdRecord.set('SCM_FLAG_YN'			, 'N');
			grdRecord.set('TAX_TYPE'			, '1');
			grdRecord.set('REF_ORDER_TYPE'		, panelSearch.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'		, panelSearch.getValue('PLAN_NUM'));
			grdRecord.set('REF_MONEY_UNIT'		, record['']);
			grdRecord.set('REF_REMARK'			, panelSearch.getValue('REMARK'));

			grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('CUSTOM_ITEM_NAME'	, record['CUSTOM_ITEM_NAME']);
			grdRecord.set('CUSTOM_ITEM_DESC'	, record['CUSTOM_ITEM_DESC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('ORDER_Q1'			, orderQ1);
			grdRecord.set('ORDER_Q2'			, orderQ2);
			grdRecord.set('ORDER_Q3'			, orderQ3);
			grdRecord.set('ORDER_Q4'			, orderQ4);
			grdRecord.set('ORDER_Q5'			, orderQ5);
			grdRecord.set('ORDER_Q6'			, orderQ6);
			grdRecord.set('ORDER_Q7'			, orderQ7);
			grdRecord.set('OUT_DIV_CODE'		, record['DIV_CODE']);

			grdRecord.set('GOODS_DIVISION1'		, record['GOODS_DIVISION']);	//202109 jhj:농공수산구분 추가
			grdRecord.set('GOODS_DIVISION2'		, record['GOODS_DIVISION']);	//202109 jhj:농공수산구분 추가
			grdRecord.set('GOODS_DIVISION3'		, record['GOODS_DIVISION']);	//202109 jhj:농공수산구분 추가
			grdRecord.set('GOODS_DIVISION4'		, record['GOODS_DIVISION']);	//202109 jhj:농공수산구분 추가
			grdRecord.set('GOODS_DIVISION5'		, record['GOODS_DIVISION']);	//202109 jhj:농공수산구분 추가
			grdRecord.set('GOODS_DIVISION6'		, record['GOODS_DIVISION']);	//202109 jhj:농공수산구분 추가
			grdRecord.set('GOODS_DIVISION7'		, record['GOODS_DIVISION']);	//202109 jhj:농공수산구분 추가

			//주문 아이템코드로 ITEM_CODE 찾아서 정보 가져오는 로직
			var param = {
				"S_COMP_CODE"		: UserInfo.compCode,
				"DIV_CODE"			: record['DIV_CODE'],
				"CUSTOM_CODE"		: record['CUSTOM_CODE'],
				"CUSTOM_ITEM_NAME"	: record['CUSTOM_ITEM_NAME'],
				"ORDER_DATE"		: UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE'))
/*				"DVRY_DATE1"		: grdRecord.get('DVRY_DATE1'),
				"DVRY_DATE2"		: grdRecord.get('DVRY_DATE2'),
				"DVRY_DATE3"		: grdRecord.get('DVRY_DATE3'),
				"DVRY_DATE4"		: grdRecord.get('DVRY_DATE4'),
				"DVRY_DATE5"		: grdRecord.get('DVRY_DATE5'),
				"DVRY_DATE6"		: grdRecord.get('DVRY_DATE6'),*/
			};
			s_sof101ukrv_ypService.getItemCode(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					grdRecord.set('CUSTOM_ITEM_CODE'	, provider[0].CUSTOM_ITEM_CODE);

					var param = {
						"S_COMP_CODE"		: UserInfo.compCode,
						"ITEM_CODE"			: provider[0].ITEM_CODE,
						"DIV_CODE"			: record.DIV_CODE
					};
					s_sof101ukrv_ypService.getItemInfo(param, function(provider, response) {
						var itemRecord = provider[0];
						if(!Ext.isEmpty(provider)){
							console.log("[[itemQTY]]" + itemRecord['QTY'])
							grdRecord.set('ITEM_CODE'			, itemRecord['ITEM_CODE']);
							grdRecord.set('ITEM_NAME'			, itemRecord['ITEM_NAME']);
							grdRecord.set('ITEM_ACCOUNT'		, itemRecord['ITEM_ACCOUNT']);
							grdRecord.set('SPEC'				, itemRecord['SPEC']);
							grdRecord.set('TRANS_RATE'			, itemRecord['TRNS_RATE']);
							grdRecord.set('ORDER_Q'				, itemRecord['QTY']);
							grdRecord.set('ORDER_P'				, itemRecord['PRICE']);
							grdRecord.set('ORIGIN_Q'			, itemRecord['QTY']);
							grdRecord.set('TAX_TYPE'			, itemRecord['TAX_TYPE']);
							grdRecord.set('STOCK_UNIT'			, itemRecord['STOCK_UNIT']);
							grdRecord.set('REF_WH_CODE'			, itemRecord['WH_CODE']);
							grdRecord.set('REF_STOCK_CARE_YN'	, itemRecord['STOCK_CARE_YN']);
							grdRecord.set('WGT_UNIT'			, itemRecord['WGT_UNIT']);
							grdRecord.set('UNIT_WGT'			, itemRecord['UNIT_WGT']);
							grdRecord.set('VOL_UNIT'			, itemRecord['VOL_UNIT']);
							grdRecord.set('UNIT_VOL'			, itemRecord['UNIT_VOL']);
							grdRecord.set('OUT_WH_CODE'			, itemRecord['OUT_WH_CODE']);
							grdRecord.set('ORDER_O'				, itemRecord['ORDER_O']);
							grdRecord.set('ORDER_TAX_O'			, itemRecord['ORDER_TAX_O']);
							grdRecord.set('ORDER_O_TAX_O'		, itemRecord['ORDER_O_TAX_O']);

							UniSales.fnGetItemInfo(
								  grdRecord
								, UniAppManager.app.cbGetItemInfo
								, 'I'
								, UserInfo.compCode
								, panelSearch.getValue('CUSTOM_CODE')
								, CustomCodeInfo.gsAgentType
								, itemRecord['ITEM_CODE']
								, panelSearch.getValue('MONEY_UNIT')
//								, BsaCodeInfo.gsMoneyUnit
								, itemRecord['SALE_UNIT']
								, itemRecord['STOCK_UNIT']
								, itemRecord['TRANS_RATE']
								, UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE'))
								, grdRecord.get('ORDER_Q')
								, itemRecord['WGT_UNIT']
								, itemRecord['VOL_UNIT']
								, itemRecord['UNIT_WGT']
								, itemRecord['UNIT_VOL']
								, itemRecord['PRICE_TYPE']
								, record['DIV_CODE']
								, null
								, ''
							);
//							setTimeout( function() {
//								UniAppManager.app.fnOrderAmtCal(grdRecord, 'P');			//rtnRecord, sType, nValue, taxType, orderQ
//								detailStore.fnOrderAmtSum();
//							}, 1000)
						}
					});
				} else {
					gsI=gsI+1
				}
				if( returnMaxI == gsI ) {
					Ext.getBody().unmask();
				}
			});
		}
	});





	/** 수주정보를 검색하기 위한 Search Form, Grid, Inner Window 정의
	 */
	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
		layout: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items: [{
			fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>'  ,
			name: 'DIV_CODE',
			xtype:'uniCombobox',
			comboType:'BOR120',
			value:UserInfo.divCode,
			allowBlank:false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = orderNoSearch.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
				}
			}
		},{
				fieldLabel: '<t:message code="unilite.msg.sMS122" default="수주일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_ORDER_DATE',
				endFieldName: 'TO_ORDER_DATE',
				width: 350,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				colspan:2
			},{
				fieldLabel: '<t:message code="unilite.msg.sMS573" default="sMS669"/>'		,
				name: 'ORDER_PRSN',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'S010',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},
			Unilite.popup('AGENT_CUST',{fieldLabel:'<t:message code="unilite.msg.sMSR213" default="거래처"/>' , validateBlank: false,colspan:2,
				listeners:{
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
					}
				}}),
//			Unilite.popup('AGENT_CUST',{fieldLabel:'프로젝트' , valueFieldName:'PROJECT_NO', textFieldName:'PROJECT_NAME', validateBlank: false}),
			Unilite.popup('DIV_PUMOK',{
				colspan:2,
				listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': orderNoSearch.getValue('DIV_CODE')});
					}
				}
			}),
			{fieldLabel: '<t:message code="unilite.msg.sMS832" default="판매유형"/>'		, name: 'ORDER_TYPE',	xtype:'uniCombobox',comboType:'AU', comboCode:'S002'},
			{fieldLabel: '<t:message code="unilite.msg.sMSR281" default="PO번호"/>'		, name: 'PO_NUM'},
			{
				fieldLabel	: '조회구분'  ,
				xtype		: 'uniRadiogroup',
				name		: 'RDO_TYPE',
				allowBlank	: false,
				width		: 235,
				items		: [
					{boxLabel:'마스터', name:'RDO_TYPE', inputValue:'master', checked:true},
					{boxLabel:'디테일', name:'RDO_TYPE', inputValue:'detail'}
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
			}
		]
	}); // createSearchForm
	//검색 모델(마스터)
	Unilite.defineModel('orderNoMasterModel', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'													, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="unilite.msg.sMS631" default="사업장"/>'		, type: 'string', comboType:'BOR120'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="unilite.msg.sMSR213" default="거래처"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="unilite.msg.sMSR279" default="거래처명"/>'	, type: 'string'},
			{name: 'ORDER_DATE'			, text: '<t:message code="unilite.msg.sMS122" default="수주일"/>'		, type: 'uniDate'},
			{name: 'ORDER_NUM'			, text: '<t:message code="unilite.msg.sMS533" default="수주번호"/>'		, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="unilite.msg.sMS832" default="판매유형"/>'		, type: 'string', comboType: 'AU', comboCode: 'S002'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="unilite.msg.sMS669" default="수주담당"/>'		, type: 'string', comboType: 'AU', comboCode: 'S010'},
			{name: 'PJT_CODE'			, text: '프로젝트코드'													, type: 'string'},
			{name: 'PJT_NAME'			, text: '프로젝트'														, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="unilite.msg.sMS543" default="수주량"/>'		, type: 'uniQty'},
			{name: 'ORDER_O'			, text: '수주금액'														, type: 'uniPrice'},
			{name: 'NATION_INOUT'		, text: '국내외구분'														, type: 'string'},
			{name: 'OFFER_NO'			, text: 'OFFER번호'													, type: 'string'},
			{name: 'DATE_DELIVERY'		, text: '납기일'														, type: 'string'},
			{name: 'MONEY_UNIT'			, text: '화폐'														, type: 'string'},
			{name: 'EXCHANGE_RATE'		, text: '환율'														, type: 'string'},
			{name: 'RECEIPT_SET_METH'	, text: '결제방법'														, type: 'string'},
			{name: 'CAL_NO'				, text: 'CAL_NO'													, type: 'string'}
		]
	});
	//검색 스토어(마스터)
	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {
		model	: 'orderNoMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false				// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 's_sof101ukrv_ypService.selectOrderNumMasterList'
			}
		},
		loadStoreRecords : function()  {
			var param		= orderNoSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;			  //권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색 그리드(마스터)
	var orderNoMasterGrid = Unilite.createGrid('s_sof101ukrv_ypOrderNoMasterGrid', {
		// title: '기본',
		layout : 'fit',
		store: orderNoMasterStore,
		uniOpt:{
					useRowNumberer: false
		},
		columns:  [
					 { dataIndex: 'DIV_CODE'	, width: 80 }
					,{ dataIndex: 'CUSTOM_NAME'	, width: 150 }
					,{ dataIndex: 'ORDER_DATE'	, width: 80 }
					,{ dataIndex: 'ORDER_NUM'	, width: 120 }
					,{ dataIndex: 'ORDER_TYPE'	, width: 80 }
					,{ dataIndex: 'ORDER_PRSN'	, width: 80 }
					,{ dataIndex: 'PJT_NAME'	, width: 150 }
					,{ dataIndex: 'ORDER_Q'		, width: 110 }
					,{ dataIndex: 'ORDER_O'		, width: 120 }

		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
					orderNoMasterGrid.returnData(record);
					SearchInfoWindow.hide();
			}
		}, // listeners
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelSearch.uniOpt.inLoading=true;

			gsReturnChk = 'Y';
			//fnGetCalDate(record.get('CAL_NO'), UniDate.getDbDateStr(record.get('DVRY_DATE')), panelResult.getValue('FIRST_YN'));
			panelSearch.setValues({'DIV_CODE':record.get('DIV_CODE'), 'ORDER_NUM':record.get('ORDER_NUM'), 'CAL_NO':record.get('CAL_NO')});
			panelResult.setValues({'DIV_CODE':record.get('DIV_CODE'), 'ORDER_NUM':record.get('ORDER_NUM'), 'CAL_NO':record.get('CAL_NO')});
			CustomCodeInfo.gsAgentType		= record.get("AGENT_TYPE");
			CustomCodeInfo.gsCustCrYn		= record.get("CREDIT_YN"); //원미만계산
			CustomCodeInfo.gsUnderCalBase	= record.get("WON_CALC_BAS");
			CustomCodeInfo.gsRefTaxInout	= record.get("TAX_TYPE");	//세액포함여부
			panelSearch.uniOpt.inLoading=false;
			UniAppManager.app.onQueryButtonDown(UniDate.getDbDateStr(record.get('DVRY_DATE')));
		}
	});
	//검색 모델(디테일)
	Unilite.defineModel('orderNoDetailModel', {
		fields: [
			 { name: 'DIV_CODE'		,text:'<t:message code="unilite.msg.sMS631" default="사업장"/>'		,type: 'string' ,comboType:'BOR120'}
			,{ name: 'ITEM_CODE'	,text:'<t:message code="unilite.msg.sMR004" default="품목코드"/>'		,type: 'string' }
			,{ name: 'ITEM_NAME'	,text:'<t:message code="unilite.msg.sMR349" default="품명"/>'			,type: 'string' }
			,{ name: 'SPEC'			,text:'<t:message code="unilite.msg.sMSR033" default="규격"/>'		,type: 'string' }

			,{ name: 'ORDER_DATE'	,text:'<t:message code="unilite.msg.sMS122" default="수주일"/>'		,type: 'uniDate'}
			,{ name: 'DVRY_DATE'	,text:'<t:message code="unilite.msg.sMS123" default="납기일"/>'		,type: 'uniDate'}

			,{ name: 'ORDER_Q'		,text:'<t:message code="unilite.msg.sMS543" default="수주량"/>'		,type: 'uniQty' }
			,{ name: 'ORDER_TYPE'	,text:'<t:message code="unilite.msg.sMS832" default="판매유형"/>'		,type: 'string' ,comboType:'AU', comboCode:'S002'}
			,{ name: 'ORDER_PRSN'	,text:'<t:message code="unilite.msg.sMS669" default="수주담당"/>'		,type: 'string' ,comboType:'AU', comboCode:'S010'}
			,{ name: 'PO_NUM'		,text:'<t:message code="unilite.msg.sMSR281" default="PO번호"/>'		,type: 'string' }
			,{ name: 'PROJECT_NO'	,text:'<t:message code="unilite.msg.sMR161" default="프로젝트번호"/>'		,type: 'string' }
			,{ name: 'ORDER_NUM'	,text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>'		,type: 'string' }
			,{ name: 'SER_NO'		,text:'<t:message code="unilite.msg.sMS783" default="수주순번"/>'		,type: 'string' }
			,{ name: 'CUSTOM_CODE'	,text:'<t:message code="unilite.msg.sMSR213" default="거래처"/>'		,type: 'string' }
			,{ name: 'CUSTOM_NAME'	,text:'<t:message code="unilite.msg.sMSR279" default="거래처명"/>'		,type: 'string' }
			,{ name: 'COMP_CODE'	,text:'COMP_CODE'		,type: 'string' }
			,{ name: 'PJT_CODE'		,text:'프로젝트코드'														,type: 'string' }
			,{ name: 'PJT_NAME'		,text:'프로젝트'														,type: 'string' }
			,{ name: 'CAL_NO'		,text: 'CAL_NO'														,type: 'string' }
		]
	});
	//검색 스토어(디테일)
	var orderNoDetailStore = Unilite.createStore('orderNoDetailStore', {
		model	: 'orderNoDetailModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false				// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read	: 's_sof101ukrv_ypService.selectOrderNumDetailList'
			}
		},
		loadStoreRecords : function()  {
			var param		= orderNoSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;			  //권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색 그리드(디테일)
	var orderNoDetailGrid = Unilite.createGrid('s_sof101ukrv_ypOrderNoDetailGrid', {
		layout	: 'fit',
		store	: orderNoDetailStore,
		uniOpt	:{
			useRowNumberer: false
		},
		hidden : true,
		columns: [
			 { dataIndex: 'DIV_CODE'		, width: 80 }
			,{ dataIndex: 'ITEM_CODE'		, width: 120}
			,{ dataIndex: 'ITEM_NAME'		, width: 150}
			,{ dataIndex: 'SPEC'			, width: 150}
			,{ dataIndex: 'ORDER_DATE'		, width: 80 }
			,{ dataIndex: 'DVRY_DATE'		, width: 80		, hidden:true}
			,{ dataIndex: 'ORDER_Q'			, width: 80 }
			,{ dataIndex: 'ORDER_TYPE'		, width: 90 }
			,{ dataIndex: 'ORDER_PRSN'		, width: 90		, hidden:true}
			,{ dataIndex: 'PO_NUM'			, width: 100}
			,{ dataIndex: 'PROJECT_NO'		, width: 90 }
			,{ dataIndex: 'ORDER_NUM'		, width: 120}
			,{ dataIndex: 'SER_NO'			, width: 70		, hidden:true}
			,{ dataIndex: 'CUSTOM_CODE'		, width: 120	, hidden:true}
			,{ dataIndex: 'CUSTOM_NAME'		, width: 200}
			,{ dataIndex: 'COMP_CODE'		, width: 80		, hidden:true}
			,{ dataIndex: 'PJT_CODE'		, width: 120	, hidden:true}
			,{ dataIndex: 'PJT_NAME'		, width: 200}
		] ,
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				orderNoDetailGrid.returnData(record)
				SearchInfoWindow.hide();
			}
		}, // listeners
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelSearch.uniOpt.inLoading=true;
			gsReturnChk = 'Y';
			var dvrtDate = UniDate.getDbDateStr(record.get('DVRY_DATE'));
			//fnGetCalDate(record.get('CAL_NO'), dvrtDate);
			panelSearch.setValues({'DIV_CODE':record.get('DIV_CODE'), 'ORDER_NUM':record.get('ORDER_NUM'), 'CAL_NO':record.get('CAL_NO')});
			panelResult.setValues({'DIV_CODE':record.get('DIV_CODE'), 'ORDER_NUM':record.get('ORDER_NUM'), 'CAL_NO':record.get('CAL_NO')});
			panelSearch.uniOpt.inLoading=false;
			UniAppManager.app.onQueryButtonDown(dvrtDate);
		}
	});
	//openSearchInfoWindow
	function openSearchInfoWindow() {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '수주번호검색',
				width	: 830,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [orderNoSearch, orderNoMasterGrid, orderNoDetailGrid],
				tbar	: [
					'->',{
						itemId	: 'searchBtn',
						text	: '조회',
						handler	: function() {
							var rdoType = orderNoSearch.getValue('RDO_TYPE');
							console.log('rdoType : ',rdoType)
							if(rdoType.RDO_TYPE=='master')  {
								orderNoMasterStore.loadStoreRecords();
							}else {
								orderNoDetailStore.loadStoreRecords();
							}
						},
						disabled: false
					},{
						xtype: 'tbspacer'
					},{
						xtype: 'tbseparator'
					},{
						xtype: 'tbspacer'
					},{
						itemId	: 'closeBtn',
						text	: '닫기',
						handler	: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
						orderNoDetailGrid.reset();
					},
					beforeclose: function( panel, eOpts )  {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
						orderNoDetailGrid.reset();
					},
					show: function( panel, eOpts ) {
						var field = orderNoSearch.getField('ORDER_PRSN');
						field.fireEvent('changedivcode', field, panelSearch.getValue('DIV_CODE'), null, null, "DIV_CODE");
						orderNoSearch.setValue('DIV_CODE'		, panelSearch.getValue('DIV_CODE'));
						orderNoSearch.setValue('ORDER_PRSN'		, panelSearch.getValue('ORDER_PRSN'));
						orderNoSearch.setValue('CUSTOM_CODE'	, panelSearch.getValue('CUSTOM_CODE'));
						orderNoSearch.setValue('CUSTOM_NAME'	, panelSearch.getValue('CUSTOM_NAME'));
						orderNoSearch.setValue('ORDER_TYPE'		, panelSearch.getValue('ORDER_TYPE'));
						orderNoSearch.setValue('FR_ORDER_DATE'	, UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE')));
						orderNoSearch.setValue('TO_ORDER_DATE'	, panelSearch.getValue('ORDER_DATE'));
						orderNoSearch.setValue('DEPT_CODE'		, panelSearch.getValue('DEPT_CODE'));
						orderNoSearch.setValue('DEPT_NAME'		, panelSearch.getValue('DEPT_NAME'));
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}





	/** 사업장별 영업담당 정보
	 */
	var divPrsnStore = Unilite.createStore('s_sof101ukrv_yp_DIV_PRSN', {
		fields: ["value","text","option"],
		autoLoad: false,
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false				// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'salesCommonService.fnRecordCombo'
			}
		},
		listeners: {
			load: function( store, records, successful, eOpts ) {
				console.log("영업담당 store",this);

				if(successful) {
					estimateSearch.setValue('ESTI_PRSN', panelSearch.getValue('ORDER_PRSN'));
				}
			}
		},
		loadStoreRecords: function() {
			var param= {
				'COMP_CODE' : UserInfo.compCode,
				'MAIN_CODE' : 'S010',
				'DIV_CODE'  : panelSearch.getValue('DIV_CODE'),
				'TYPE'	  :'DIV_PRSN'
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});





/*	// 견적을 참조하기 위한 Search Form, Grid, Inner Window 정의
	var estimateSearch = Unilite.createSearchForm('estimateForm', {
		layout :  {type : 'uniTable', columns : 2},
		items :[
			Unilite.popup('AGENT_CUST',{fieldLabel:'견적처' , validateBlank: false}),
			{ fieldLabel: '<t:message code="unilite.msg.sMS538" default="견적번호"/>'  ,		name: 'ESTI_NUM'},
			{ fieldLabel: '<t:message code="unilite.msg.sMS147" default="견적일"/>'
				,xtype: 'uniDateRangefield'
				,startFieldName: 'FR_ESTI_DATE'
				,endFieldName: 'TO_ESTI_DATE'
				,width: 350
				,startDate: UniDate.get('startOfMonth')
				,endDate: UniDate.get('today')
			},
			{fieldLabel: '<t:message code="unilite.msg.sMS573" default="영업담당"/>'  , name: 'ESTI_PRSN',	xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('s_sof101ukrv_yp_DIV_PRSN') }
		]
	});
	//견적참조 모델
	Unilite.defineModel('s_sof101ukrv_ypESTIModel', {
		fields: [
			{name: 'CUSTOM_CODE'		,text: '<t:message code="unilite.msg.sMS774" default="견적처"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="unilite.msg.sMS774" default="견적처"/>'		, type: 'string'},
			{name: 'ESTI_DATE'			,text: '<t:message code="unilite.msg.sMSR002" default="견적일"/>'		, type: 'uniDate'},
			{name: 'ESTI_NUM'			,text: '<t:message code="unilite.msg.sMS538" default="견적번호"/>'		, type: 'string'},
			{name: 'ESTI_SEQ'			,text: '<t:message code="unilite.msg.sMSR003" default="순번"/>'		, type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="unilite.msg.sMS501" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="unilite.msg.sMS688" default="품명"/>'		, type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="unilite.msg.sMSR033" default="규격"/>'		, type: 'string'},
			{name: 'ESTI_UNIT'			,text: '<t:message code="unilite.msg.sMS690" default="판매단위"/>'		, type: 'string'},
			{name: 'TRANS_RATE'			,text: '<t:message code="unilite.msg.sMSR010" default="입수"/>'		, type: 'string'},
			{name: 'ESTI_QTY'			,text: '<t:message code="unilite.msg.sMSR004" default="견적수량"/>'		, type: 'uniQty'},
			{name: 'ESTI_PRICE'			,text: '<t:message code="unilite.msg.sMSR005" default="견적단가"/>'		, type: 'uniUnitPrice'},
			{name: 'ESTI_AMT'			,text: '<t:message code="unilite.msg.sMSR006" default="견적금액"/>'		, type: 'uniPrice'},
			{name: 'ESTI_TAX_AMT'		,text: '<t:message code="unilite.msg.sMS775" default="견적세액"/>'		, type: 'uniPrice'},
			{name: 'TAX_TYPE'			,text: '<t:message code="unilite.msg.sMSR289" default="과세구분"/>'		, type: 'string'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="unilite.msg.sMSR047" default="화폐단위"/>'		, type: 'string'},
			{name: 'EXCHANGE_RATE'		,text: '<t:message code="unilite.msg.sMSR031" default="환율"/>'		, type: 'string'},
			{name: 'WH_CODE'			,text: '<t:message code="unilite.msg.sMS698" default="창고코드"/>'		, type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="unilite.msg.sMS700" default="재고단위"/>'		, type: 'string'},
			{name: 'STOCK_CARE_YN'		,text: '<t:message code="unilite.msg.sMS776" default="재고관리여부"/>'	, type: 'string'},
			{name: 'ITEM_ACCOUNT'		,text: 'ITEM_ACCOUNT'												, type: 'string'}
		]
	});
	//견적참조 스토어
	var estimateStore = Unilite.createStore('s_sof101ukrv_ypEstiStore', {
		model: 's_sof101ukrv_ypESTIModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false		 // prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 's_sof101ukrv_ypService.selectEstiList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(successful)  {
					var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
					var estiRecords = new Array();

					if(masterRecords.items.length > 0)	{
						console.log("store.items :", store.items);
						console.log("records", records);

						Ext.each(records,
							function(item, i)	{
								Ext.each(masterRecords.items, function(record, i)	{
									console.log("record :", record);

										if( (record.data['ESTI_NUM'] == item.data['ESTI_NUM'])
												&& (record.data['ESTI_SEQ'] == item.data['ESTI_SEQ'])
										  )
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
		loadStoreRecords : function()  {
			var param= estimateSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//견적참조 그리드
	var estimateGrid = Unilite.createGrid('s_sof101ukrv_ypEstimateGrid', {
		// title: '기본',
		layout : 'fit',
		store: estimateStore,
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns:  [
			{ dataIndex: 'CUSTOM_NAME'		, width: 150},
			{ dataIndex: 'ESTI_DATE'		, width: 110},
			{ dataIndex: 'ESTI_NUM'			, width: 140},
			{ dataIndex: 'ESTI_SEQ'			, width: 60 },
			{ dataIndex: 'ITEM_CODE'		, width: 110},
			{ dataIndex: 'ITEM_NAME'		, width: 150},
			{ dataIndex: 'SPEC'				, width: 150},
			{ dataIndex: 'ESTI_UNIT'		, width: 90 },
			{ dataIndex: 'TRANS_RATE'		, width: 60 },
			{ dataIndex: 'ESTI_QTY'			, width: 120},
			{ dataIndex: 'ESTI_PRICE'		, width: 110},
			{ dataIndex: 'ESTI_AMT'			, width: 100},
			{ dataIndex: 'ESTI_TAX_AMT'		, width: 50 , hidden: true},
			{ dataIndex: 'TAX_TYPE'			, width: 50 , hidden: true},
			{ dataIndex: 'MONEY_UNIT'		, width: 50 , hidden: true},
			{ dataIndex: 'EXCHANGE_RATE'	, width: 50 , hidden: true},
			{ dataIndex: 'WH_CODE'			, width: 50 , hidden: true},
			{ dataIndex: 'STOCK_UNIT'		, width: 50 , hidden: true},
			{ dataIndex: 'STOCK_CARE_YN'	, width: 50 , hidden: true},
			{ dataIndex: 'ITEM_ACCOUNT'		, width: 50 , hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();

			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				detailGrid.setEstiData(record.data);
			});
			//this.deleteSelectedRow();
			this.getStore().remove(records);
		}
	});
	//견적참조 메인
	function openEstimateWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;

		estimateSearch.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
		estimateSearch.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
		estimateSearch.setValue('FR_ESTI_DATE', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE')) );
		estimateSearch.setValue('TO_ESTI_DATE', panelSearch.getValue('ORDER_DATE'));
//		estimateSearch.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
//
//		estimateSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
//		estimateSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
//		estimateSearch.setValue('FR_ESTI_DATE', UniDate.get('startOfMonth', panelResult.getValue('ORDER_DATE')) );
//		estimateSearch.setValue('TO_ESTI_DATE', panelResult.getValue('ORDER_DATE'));
//		estimateSearch.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
		divPrsnStore.loadStoreRecords(); // 사업장별 영업사원 콤보

		if(!referEstimateWindow) {
			referEstimateWindow = Ext.create('widget.uniDetailWindow', {
				title: '견적참조',
				width: 830,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [estimateSearch, estimateGrid],
				tbar:  [{
						itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							estimateStore.loadStoreRecords();
						},
						disabled: false
					},
					{	itemId : 'confirmBtn',
						text: '수주적용',
						handler: function() {
							estimateGrid.returnData();
						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						text: '수주적용 후 닫기',
						handler: function() {
							estimateGrid.returnData();
							referEstimateWindow.hide();
						},
						disabled: false
					},{
							xtype: 'tbspacer'
					},{
							xtype: 'tbseparator'
					},{
							xtype: 'tbspacer'
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							if(detailStore.getCount() == 0){
								panelSearch.setAllFieldsReadOnly(false);
								panelResult.setAllFieldsReadOnly(false);
							}
							referEstimateWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						//estimateSearch.clearForm();
						//estimateGrid,reset();
					},
					beforeclose: function( panel, eOpts )  {
						//estimateSearch.clearForm();
						//estimateGrid,reset();
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
*/




/*	// 수주이력을 참조하기 위한 Search Form, Grid, Inner Window 정의
	var refSearch = Unilite.createSearchForm('RefSForm', {
		layout :  {type : 'uniTable', columns : 3},
		items :[
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'수주처',
				validateBlank: false,
				listeners:{
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
					}
				}
			}),
			Unilite.popup('DIV_PUMOK',{
				validateBlank: false,
				colspan:2,
				listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel: '수주일',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_ORDER_DATE',
				endFieldName: 'TO_ORDER_DATE',
				width: 350,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},{
				fieldLabel: '<t:message code="unilite.msg.sMS573" default="영업담당"/>'	 ,
				name: 'ORDER_PRSN',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'S010',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},{
				fieldLabel: '최근수주',
				name: 'RDO_YN',
				xtype:'uniRadiogroup',
				comboType:'AU',
				comboCode:'B010',
				width:210,
				allowBlank:false,
				value:'Y'
			}
		]
	});
	//수주이력 모델
	Unilite.defineModel('s_sof101ukrv_ypRefModel', {
		fields: [
			 { name: 'CUSTOM_CODE'		, text:'<t:message code="unilite.msg.sMS777" default="수주처"/>'	,type : 'string' }
			,{ name: 'CUSTOM_NAME'		, text:'<t:message code="unilite.msg.sMS777" default="수주처"/>'	,type : 'string' }
			,{ name: 'ORDER_DATE'		, text:'<t:message code="unilite.msg.sMS508" default="수주일"/>'	,type : 'string' }
			,{ name: 'ORDER_NUM'		, text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>'	,type : 'string' }
			,{ name: 'SER_NO'			, text:'<t:message code="unilite.msg.sMSR003" default="순번"/>'	,type : 'int' }
			,{ name: 'ITEM_CODE'		, text:'<t:message code="unilite.msg.sMS501" default="품목코드"/>'	,type : 'string' }
			,{ name: 'ITEM_NAME'		, text:'<t:message code="unilite.msg.sMS688" default="품명"/>'	,type : 'string' }
			,{ name: 'SPEC'				, text:'<t:message code="unilite.msg.sMSR033" default="규격"/>'	,type : 'string' }
			,{ name: 'ORDER_UNIT'		, text:'<t:message code="unilite.msg.sMS690" default="판매단위"/>'	,type : 'string'	, comboType:'AU', comboCode:'B013', displayField: 'value'}
			,{ name: 'TRANS_RATE'		, text:'<t:message code="unilite.msg.sMSR010" default="입수"/>'	,type : 'uniQty' }
			,{ name: 'ORDER_Q'			, text:'<t:message code="unilite.msg.sMS543" default="수주량"/>'	,type : 'uniQty' }
			,{ name: 'ORDER_P'			, text:'개별단가'					,type : 'uniUnitPrice' }
			,{ name: 'ORDER_WGT_Q'		, text:'수주량(중량)'				,type : 'uniQty' }
			,{ name: 'ORDER_WGT_P'		, text:'단가(중량)'					,type : 'uniQty' }
			,{ name: 'ORDER_VOL_Q'		, text:'수주량(부피)'				,type : 'uniUnitPrice' }
			,{ name: 'ORDER_VOL_P'		, text:'단가(부피)'					,type : 'uniQty' }
			,{ name: 'ORDER_O'			, text:'<t:message code="unilite.msg.sMS681" default="금액"/>' ,type : 'uniPrice' }
			,{ name: 'ORDER_TAX_O'		, text:'ORDER_TAX_O'			,type : 'uniPrice' }
			,{ name: 'TAX_TYPE'			, text:'TAX_TYPE'				,type : 'string' }
			,{ name: 'DIV_CODE'			, text:'DIV_CODE'				,type : 'string' }
			,{ name: 'OUT_DIV_CODE'		, text:'OUT_DIV_CODE'			,type : 'string' }
			,{ name: 'ACCOUNT_YNC'		, text:'ACCOUNT_YNC'			,type : 'string' }
			,{ name: 'SALE_CUST_CD'		, text:'SALE_CUST_CD'			,type : 'string' }
			,{ name: 'SALE_CUST_NM'		, text:'SALE_CUST_NM'			,type : 'string' }
			,{ name: 'PRICE_YN'			, text:'PRICE_YN'				,type : 'string' }
			,{ name: 'STOCK_Q'			, text:'STOCK_Q'				,type : 'string' }
			,{ name: 'DVRY_CUST_CD'		, text:'DVRY_CUST_CD'			,type : 'string' }
			,{ name: 'DVRY_CUST_NAME'	, text:'DVRY_CUST_NAME'			,type : 'string' }
			,{ name: 'STOCK_UNIT'		, text:'STOCK_UNIT'				,type : 'string' }
			,{ name: 'WH_CODE'			, text:'WH_CODE'				,type : 'string' }
			,{ name: 'STOCK_CARE_YN'	, text:'STOCK_CARE_YN'			,type : 'string' }
			,{ name: 'DISCOUNT_RATE'	, text:'DISCOUNT_RATE'			,type : 'string' }
			,{ name: 'ITEM_ACCOUNT'		, text:'ITEM_ACCOUNT'			,type : 'string' }
			,{ name: 'PRICE_TYPE'		, text:'PRICE_TYPE'				,type : 'string' }
			,{ name: 'WGT_UNIT'			, text:'WGT_UNIT'				,type : 'string' }
			,{ name: 'UNIT_WGT'			, text:'UNIT_WGT'				,type : 'string' }
			,{ name: 'VOL_UNIT'			, text:'VOL_UNIT'				,type : 'string' }
			,{ name: 'UNIT_VOL'			, text:'UNIT_VOL'				,type : 'string' }
			,{ name: 'SO_KIND'			, text:'SO_KIND'				,type : 'string' }
		]
	});
	//수주이력 스토어
	var refStore = Unilite.createStore('s_sof101ukrv_ypRefStore', {
			model: 's_sof101ukrv_ypRefModel',
			autoLoad: false,
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false				// prev | newxt 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read	: 's_sof101ukrv_ypService.selectRefList'

				}
			},
			listeners:{
				load:function(store, records, successful, eOpts)	{
					if(successful)  {
						var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
						var estiRecords = new Array();

						if(masterRecords.items.length > 0)	{
							console.log("store.items :", store.items);
							console.log("records", records);

							Ext.each(records,
								function(item, i)	{
									Ext.each(masterRecords.items, function(record, i)	{
										console.log("record :", record);

											if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM'])
													&& (record.data['ESTI_SEQ'] == item.data['ESTI_SEQ'])
											  )
											{
												estiRecords.push(item);
											}
									});
							});
							store.remove(estiRecords);
						}
					}
				}
			}
			,loadStoreRecords : function()  {
				var param= refSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	//수주이력 그리드
	var refGrid = Unilite.createGrid('s_sof101ukrv_ypRefGrid', {
		// title: '기본',
		layout : 'fit',
		store: refStore,
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns:  [
					 { dataIndex: 'CUSTOM_CODE'			, width: 50		, hidden:true}
					,{ dataIndex: 'CUSTOM_NAME'			, width: 110 }
					,{ dataIndex: 'ORDER_DATE'			, width: 80 }
					,{ dataIndex: 'ORDER_NUM'			, width: 100 }
					,{ dataIndex: 'SER_NO'				, width: 60 }
					,{ dataIndex: 'ITEM_CODE'			, width: 00 }
					,{ dataIndex: 'ITEM_NAME'			, width: 110 }
					,{ dataIndex: 'SPEC'				, width: 130 }
					,{ dataIndex: 'ORDER_UNIT'			, width: 80 }
					,{ dataIndex: 'TRANS_RATE'			, width: 60 }
					,{ dataIndex: 'ORDER_Q'				, width: 90 }
					,{ dataIndex: 'ORDER_P'				, width: 80 }
					,{ dataIndex: 'ORDER_WGT_Q'			, width: 90		, borderColor:'red'}
					,{ dataIndex: 'ORDER_WGT_P'			, width: 90 }
					,{ dataIndex: 'ORDER_VOL_Q'			, width: 90 }
					,{ dataIndex: 'ORDER_VOL_P'			, width: 90 }
					,{ dataIndex: 'ORDER_O'				, width: 90 }
					,{ dataIndex: 'ORDER_TAX_O'			, width: 50		, hidden:true}
					,{ dataIndex: 'TAX_TYPE'			, width: 50		, hidden:true}
					,{ dataIndex: 'DIV_CODE'			, width: 50		, hidden:true}
					,{ dataIndex: 'OUT_DIV_CODE'		, width: 50		, hidden:true}
					,{ dataIndex: 'ACCOUNT_YNC'			, width: 50		, hidden:true}
					,{ dataIndex: 'SALE_CUST_CD'		, width: 50		, hidden:true}
					,{ dataIndex: 'SALE_CUST_NM'		, width: 50		, hidden:true}
					,{ dataIndex: 'PRICE_YN'			, width: 50		, hidden:true}
					,{ dataIndex: 'STOCK_Q'				, width: 50		, hidden:true}
					,{ dataIndex: 'DVRY_CUST_CD'		, width: 50		, hidden:true}
					,{ dataIndex: 'DVRY_CUST_NAME'		, width: 50		, hidden:true}
					,{ dataIndex: 'STOCK_UNIT'			, width: 50		, hidden:true}
					,{ dataIndex: 'WH_CODE'				, width: 50		, hidden:true}
					,{ dataIndex: 'STOCK_CARE_YN'		, width: 50		, hidden:true}
					,{ dataIndex: 'DISCOUNT_RATE'		, width: 50		, hidden:true}
					,{ dataIndex: 'ITEM_ACCOUNT'		, width: 50		, hidden:true}
					,{ dataIndex: 'PRICE_TYPE'			, width: 50		, hidden:true}
					,{ dataIndex: 'WGT_UNIT'			, width: 50		, hidden:true}
					,{ dataIndex: 'UNIT_WGT'			, width: 50		, hidden:true}
					,{ dataIndex: 'VOL_UNIT'			, width: 50		, hidden:true}
					,{ dataIndex: 'UNIT_VOL'			, width: 50		, hidden:true}
					,{ dataIndex: 'SO_KIND'				, width: 50		, hidden:true}

		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				detailGrid.setRefData(record.data);
			});
			this.getStore().remove(records);
		}
	});
	//수주이력 메인
	function openRefWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		var field = refSearch.getField('ORDER_PRSN');
		field.fireEvent('changedivcode', field, panelSearch.getValue('DIV_CODE'), null, null, "DIV_CODE");
		refSearch.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
		refSearch.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
		refSearch.setValue('ORDER_PRSN', panelSearch.getValue('ORDER_PRSN'));

		refSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
		refSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
		refSearch.setValue('ORDER_PRSN', panelResult.getValue('ORDER_PRSN'));

		if(!referOrderRecordWindow) {
			referOrderRecordWindow = Ext.create('widget.uniDetailWindow', {
				title: '수주이력참조',
				width: 830,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [refSearch, refGrid],
				tbar:  [
					'->',{
						itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							refStore.loadStoreRecords();
						},
						disabled: false
					},
					{	itemId : 'confirmBtn',
						text: '수주적용',
						handler: function() {
							refGrid.returnData();
						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						text: '수주적용 후 닫기',
						handler: function() {
							refGrid.returnData();
							referOrderRecordWindow.hide();
						},
						disabled: false
					},{
						xtype: 'tbspacer'
					},{
						xtype: 'tbseparator'
					},{
						xtype: 'tbspacer'
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							if(detailStore.getCount() == 0){
								panelSearch.setAllFieldsReadOnly(false);
								panelResult.setAllFieldsReadOnly(false);
							}
							referOrderRecordWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {beforehide: function(me, eOpt) {
											//refSearch.clearForm();
											//refGrid.reset();
										},
							 beforeclose: function( panel, eOpts )  {
											//RefSearch.clearForm();
											//refGrid.reset();
										},
							  beforeshow: function ( me, eOpts )	{
								refStore.loadStoreRecords();
							 }
				}
			})
		}
		referOrderRecordWindow.center();
		referOrderRecordWindow.show();
	}
*/




	//엑셀참조
	Unilite.Excel.defineModel('excel.s_sof101ukrv_yp.sheet01', {
		fields: [
			{name: 'COMP_CODE'				, text: '법인코드'		, type: 'string'},
			{name: 'DIV_CODE'				, text: '사업장코드'		, type: 'string'},
			{name: 'CUSTOM_CODE'			, text: '거래처코드'		, type: 'string'},
			{name: 'SEQ'					, text: '순번'		, type: 'int'},
			{name: 'CUSTOM_ITEM_NAME'		, text: '식품명'		, type: 'string'},
			{name: 'CUSTOM_ITEM_DESC'		, text: '식품설명'		, type: 'string'},
			{name: 'ORDER_UNIT'				, text: '단위'		, type: 'string'},
			{name: 'ORDER_Q1'				, text: '월'			, type: 'uniQty'},
			{name: 'ORDER_Q2'				, text: '화'			, type: 'uniQty'},
			{name: 'ORDER_Q3'				, text: '수'			, type: 'uniQty'},
			{name: 'ORDER_Q4'				, text: '목'			, type: 'uniQty'},
			{name: 'ORDER_Q5'				, text: '금'			, type: 'uniQty'},
			{name: 'ORDER_Q6'				, text: '토'			, type: 'uniQty'},
			{name: 'ORDER_Q7'				, text: '일'			, type: 'uniQty'},
			{name: 'TOT_ORDER_Q'			, text: '총량'		, type: 'uniQty'},
			{name: 'GOODS_DIVISION'			, text: '농공수산구분'	, type: 'string'}	//202109 jhj:컬럼추가
		]
	});

	function openExcelWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;

		var me		= this;
		var vParam	= {};
		var appName	= 'Unilite.com.excel.ExcelUpload';

		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.DIV_CODE		= panelSearch.getValue('DIV_CODE');
			excelWindow.extParam.CUSTOM_CODE	= panelSearch.getValue('CUSTOM_CODE');
			excelWindow.extParam.MONEY_UNIT		= panelSearch.getValue('MONEY_UNIT');
			excelWindow.extParam.ORDER_DATE		= UniDate.getDateStr( panelSearch.getValue('ORDER_DATE'))	//수주일자
		}
		if(!excelWindow) {
			excelWindow =  Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: 's_sof101ukrv_yp',
				width	: 600,
				height	: 400,
				modal	: false,
				extParam: {
					'PGM_ID'        : 's_sof101ukrv_yp',
					'DIV_CODE'		: panelSearch.getValue('DIV_CODE'),
					'CUSTOM_CODE'	: panelSearch.getValue('CUSTOM_CODE'),
					'MONEY_UNIT'	: panelSearch.getValue('MONEY_UNIT'),
					'ORDER_DATE'	: UniDate.getDateStr( panelSearch.getValue('ORDER_DATE'))	//수주일자
				},
				grids: [{
					itemId		: 'grid01',
					title		: '수주정보',
					useCheckbox	: true,
					model		: 'excel.s_sof101ukrv_yp.sheet01',
					readApi		: 's_sof101ukrv_ypService.selectExcelUploadSheet1',
					columns		: [
						{ dataIndex: 'COMP_CODE'		, width: 120		, hidden: true},
						{ dataIndex: 'DIV_CODE'			, width: 120		, hidden: true},
						{ dataIndex: 'CUSTOM_CODE'		, width: 120		, hidden: true},
						{ dataIndex: 'SEQ'				, width: 80},
						{ dataIndex: 'CUSTOM_ITEM_NAME'	, width: 120},
						{ dataIndex: 'CUSTOM_ITEM_DESC'	, width: 200},
						{ dataIndex: 'ORDER_UNIT'		, width: 90},
						{ dataIndex: 'ORDER_Q1'			, width: 110},
						{ dataIndex: 'ORDER_Q2'			, width: 110},
						{ dataIndex: 'ORDER_Q3'			, width: 110},
						{ dataIndex: 'ORDER_Q4'			, width: 110},
						{ dataIndex: 'ORDER_Q5'			, width: 110},
						{ dataIndex: 'ORDER_Q6'			, width: 110},
						{ dataIndex: 'ORDER_Q7'			, width: 110},
						{ dataIndex: 'TOT_ORDER_Q'		, width: 110},
						{ dataIndex: 'GOODS_DIVISION'	, width: 110}	//202109 jhj:컬럼추가
					],
					listeners: {
						afterrender: function(grid) {
							var me = this;
							this.contextMenu = Ext.create('Ext.menu.Menu', {});
							this.contextMenu.add(
								{
									text: '상품정보 등록',	iconCls : '',
									handler: function(menuItem, event) {
										var records = grid.getSelectionModel().getSelection();
										var record = records[0];
										var params = {
											appId: UniAppManager.getApp().id,
											sender: me,
											action: 'excelNew',
											_EXCEL_JOBID: excelWindow.jobID,			//SOF112T Key1
											_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'), //SOF112T Key2
											ITEM_CODE: record.get('ITEM_CODE'),
											DIV_CODE: panelSearch.getValue('DIV_CODE')
										}
										var rec = {data : {prgID : 'bpr101ukrv', 'text':''}};
										parent.openTab(rec, '/base/bpr101ukrv.do', params);
									}
								}
							);

							this.contextMenu.add(
								{
									text: '도서정보 등록',	iconCls : '',
									handler: function(menuItem, event) {
										var records = grid.getSelectionModel().getSelection();
										var record = records[0];
										var params = {
											appId: UniAppManager.getApp().id,
											sender: me,
											action: 'excelNew',
											_EXCEL_JOBID: excelWindow.jobID,			//SOF112T Key1
											_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'), //SOF112T Key2
											ITEM_CODE: record.get('ITEM_CODE'),
											DIV_CODE: panelSearch.getValue('DIV_CODE')
										}
										var rec = {data : {prgID : 'bpr102ukrv', 'text':''}};
										parent.openTab(rec, '/base/bpr102ukrv.do', params);
									}
								}
							);

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
					}
				},
				onApply:function()  {
					gsI = 0;
					Ext.getBody().mask('적용 중...','loading-indicator');
					var grid = this.down('#grid01');
					var records = grid.getSelectionModel().getSelection();
					Ext.each(records, function(record,i){
						detailGrid.setExcelData(record.data, records.length, i);
					});
					//grid.getStore().remove(records);
					var beforeRM = grid.getStore().count();
					grid.getStore().remove(records);
					var afterRM = grid.getStore().count();
					if (beforeRM > 0 && afterRM == 0){
						excelWindow.close();
					}
				},

				//툴바 세팅
				_setToolBar: function() {
					var me = this;
					me.tbar = [
					'->',
					{
						xtype	: 'button',
						text	: '업로드',
						tooltip	: '업로드',
						width	: 60,
						handler: function() {
							me.jobID = null;
							me.uploadFile();
						}
					},{
						xtype	: 'button',
						text	: '적용',
						tooltip	: '적용',
						width	: 60,
						handler	: function() {
							var grids	= me.down('grid');
							var isError	= false;
							if(Ext.isDefined(grids.getEl()))	{
								grids.getEl().mask();
							}
							Ext.each(grids, function(grid, i){
								var records = grid.getStore().data.items;
								return Ext.each(records, function(record, i){
									if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
										console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
										isError = true;
										return false;
									}
								});
							});
							if(Ext.isDefined(grids.getEl()))	{
								grids.getEl().unmask();
							}
							if(!isError) {
								me.onApply();
							}else {
								alert("에러가 있는 행은 적용이 불가능합니다.");
							}
						}
					},{
							xtype: 'tbspacer'
					},{
							xtype: 'tbseparator'
					},{
							xtype: 'tbspacer'
					},{
						xtype	: 'button',
						text	: '닫기',
						tooltip	: '닫기',
						handler	: function() {
							var grid = me.down('#grid01');
							grid.getStore().removeAll();
							me.hide();
						}
					}
				]}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};





	/** main app
	 */
	Unilite.Main({
		id: 's_sof101ukrv_ypApp',
		focusField:panelSearch.getField('CUSTOM_CODE'),
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, detailGrid, panelTrade
			]
		},
		panelSearch
		],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
//			detailGrid.disabledLinkButtons(false);
//			Ext.getCmp('nationButton').setDisabled(true);

			this.setDefault();

			panelSearch.down('#purchaseRequest1').setDisabled(true);
			panelResult.down('#purchaseRequest2').setDisabled(true);

			if(panelSearch.getValue('NATION_INOUT') == '2') {
				//무역폼 readOnly: false
				panelSearch.getField('OFFER_NO').setReadOnly(false);
				panelResult.getField('OFFER_NO').setReadOnly(false);
				panelTrade.getForm().getFields().each(function(field) {
					field.setReadOnly(false);
				});
//				panelTrade.setConfig('collapsed', false);
				Ext.getCmp('tradeForm').setHidden(true);
			} else {
				//무역폼 readOnly: true
				panelSearch.getField('OFFER_NO').setReadOnly(true);
				panelResult.getField('OFFER_NO').setReadOnly(true);
				panelTrade.getForm().getFields().each(function(field) {
					field.setReadOnly(true);
				});
//				panelTrade.setConfig('collapsed', true);
				Ext.getCmp('tradeForm').setHidden(true);
			}
		},
		onQueryButtonDown: function(drvyDate) {
			var orderNo = panelSearch.getValue('ORDER_NUM');
			if(Ext.isEmpty(orderNo)) {
				openSearchInfoWindow()
			} else {
				isLoad = true;
				var param= panelSearch.getValues();
				panelSearch.uniOpt.inLoading=true;
				panelSearch.getForm().load({
					params: param,
					success:function()  {
						gsSaveRefFlag = 'N';
						panelResult.setValue('CUSTOM_CODE'	, panelSearch.getValue('CUSTOM_CODE'));
						panelResult.setValue('CUSTOM_NAME'	, panelSearch.getValue('CUSTOM_NAME'));
						panelResult.setValue('DEPT_CODE'	, panelSearch.getValue('DEPT_CODE'));
						panelResult.setValue('DEPT_NAME'	, panelSearch.getValue('DEPT_NAME'));
						panelResult.setValue('TAX_INOUT'	, panelSearch.getValue('TAX_INOUT'));
						panelResult.setValue('PROJECT_NO'	, panelSearch.getValue('PROJECT_NO'));
						panelResult.getForm().findField('CUSTOM_CODE').setReadOnly(true);
						panelResult.getForm().findField('CUSTOM_NAME').setReadOnly(true);
						if(CustomCodeInfo.gsCustCrYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
							//여신액 구하기
							var divCode = panelSearch.getValue('DIV_CODE');
							var CustomCode = panelSearch.getValue('CUSTOM_CODE');
							var orderDate = panelSearch.getField('ORDER_DATE').getSubmitValue()
							var moneyUnit = BsaCodeInfo.gsMoneyUnit;
							//마스터폼에 여신액 set
							UniAppManager.app.fnGetCustCredit(divCode, CustomCode, orderDate, moneyUnit);
						}
						panelSearch.setAllFieldsReadOnly(true)
						panelResult.setAllFieldsReadOnly(true)
						panelTrade.setAllFieldsReadOnly(true);

//					  if(BsaCodeInfo.gsDraftFlag == 'Y' && panelSearch.getValue('STATUS') != '1')  {
//						  checkDraftStatus = true;
//					  }
						if(panelSearch.getValue('ORDER_REQ_YN') != "N"){ //구매요청정보 반영에 따른 버튼 disabled 처리
							panelSearch.down('#purchaseRequest1').setDisabled(true);
							panelResult.down('#purchaseRequest2').setDisabled(true);
						}else{
							panelSearch.down('#purchaseRequest1').setDisabled(false);
							panelResult.down('#purchaseRequest2').setDisabled(false);
						}

						panelSearch.uniOpt.inLoading=false;
						gsSaveRefFlag = 'Y';
					},
					failure: function(form, action) {
						panelSearch.uniOpt.inLoading=false;
					}
				})
//				panelTrade.getForm().load({
//					params: param,
//					success:function()  {
//					},
//					failure: function(form, action) {
//						panelTrade.uniOpt.inLoading=false;
//					}
//				})
				detailStore.loadStoreRecords(drvyDate);
			}
		},
		onNewDataButtonDown: function() {
			if(panelSearch.getValue('NATION_INOUT') == 2 && Ext.isEmpty(panelSearch.getValue('OFFER_NO'))) {
				alert("OFFER번호는 필수입니다.");
				return true;
			}
			if(!this.checkForNewDetail()) return false;

			/**
			 * Detail Grid Default 값 설정
			 */
			 var orderNum = panelSearch.getValue('ORDER_NUM');

			 var seq = detailStore.max('SER_NO');
			 if(!seq) seq = 1;
			 else  seq += 1;

			 seq1 = fnGetMaxSerNo();

			 var taxType ='1';
			 if(panelSearch.getValue('BILL_TYPE')=='50' || panelSearch.getValue('BILL_TYPE')=='60' || panelSearch.getValue('BILL_TYPE')=='50') {
				taxType ='2';
			 }

			 var outDivCode = '';
			 if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))) {
				outDivCode = panelSearch.getValue('DIV_CODE');
			 }

			 var dvryDate1 = '';
			 if(!Ext.isEmpty(gsDvryDate1)) {
				dvryDate1 = new Date(gsDvryDate1);
			 }else {
				dvryDate1= new Date();
			 }

			 var prodEndDate1	= '';
			 if(!Ext.isEmpty(gsDvryDate1)) {
				prodEndDate1 = new Date(gsDvryDate1);
			 }else {
				prodEndDate1= new Date();
			 }
			 prodEndDate1 = UniDate.add(prodEndDate1, {days: -1});

			 var dvryDate2 = '';
			 if(!Ext.isEmpty(gsDvryDate2)) {
				dvryDate2 = new Date(gsDvryDate2);
			 }else {
				dvryDate2= new Date();
			 }

			 var prodEndDate2	= '';
			 if(!Ext.isEmpty(gsDvryDate2)) {
				prodEndDate2 = new Date(gsDvryDate2);
			 }else {
				prodEndDate2= new Date();
			 }
			 prodEndDate2 = UniDate.add(prodEndDate2, {days: -1});

			 var dvryDate3 = '';
			 if(!Ext.isEmpty(gsDvryDate3)) {
				dvryDate3 = new Date(gsDvryDate3);
			 }else {
				dvryDate3= new Date();
			 }

			 var prodEndDate3	= '';
			 if(!Ext.isEmpty(gsDvryDate3)) {
				prodEndDate3 = new Date(gsDvryDate3);
			 }else {
				prodEndDate3= new Date();
			 }
			 prodEndDate3 = UniDate.add(prodEndDate3, {days: -1});

			 var dvryDate4 = '';
			 if(!Ext.isEmpty(gsDvryDate4)) {
				dvryDate4 = new Date(gsDvryDate4);
			 }else {
				dvryDate4= new Date();
			 }

			 var prodEndDate4	= '';
			 if(!Ext.isEmpty(gsDvryDate4)) {
				prodEndDate4 = new Date(gsDvryDate4);
			 }else {
				prodEndDate4= new Date();
			 }
			 prodEndDate4 = UniDate.add(prodEndDate4, {days: -1});

			 var dvryDate5 = '';
			 if(!Ext.isEmpty(gsDvryDate5)) {
				dvryDate5 = new Date(gsDvryDate5);
			 }else {
				dvryDate5= new Date();
			 }

			 var prodEndDate5	= '';
			 if(!Ext.isEmpty(gsDvryDate5)) {
				prodEndDate5 = new Date(gsDvryDate5);
			 }else {
				prodEndDate5= new Date();
			 }
			 prodEndDate5 = UniDate.add(prodEndDate5, {days: -1});

			 var dvryDate6 = '';
			 if(!Ext.isEmpty(gsDvryDate6)) {
				dvryDate6 = new Date(gsDvryDate6);
			 }else {
				dvryDate6= new Date();
			 }

			 var prodEndDate6	= '';
			 if(!Ext.isEmpty(gsDvryDate6)) {
				prodEndDate6 = new Date(gsDvryDate6);
			 }else {
				prodEndDate6= new Date();
			 }
			 prodEndDate6 = UniDate.add(prodEndDate6, {days: -1});

			 var dvryDate7 = '';
			 if(!Ext.isEmpty(gsDvryDate7)) {
				dvryDate7 = new Date(gsDvryDate7);
			 }else {
				dvryDate7= new Date();
			 }

			 var prodEndDate7	= '';
			 if(!Ext.isEmpty(gsDvryDate7)) {
				prodEndDate7 = new Date(gsDvryDate7);
			 }else {
				prodEndDate7= new Date();
			 }
			 prodEndDate7 = UniDate.add(prodEndDate7, {days: -1});

			 var saleCustCd = '';
			 if(!Ext.isEmpty(panelSearch.getValue('SALE_CUST_CD'))) {
				saleCustCd=panelSearch.getValue('SALE_CUST_CD');
			 }

			 var refOrderDate = '';
			 if(!Ext.isEmpty(panelSearch.getValue('ORDER_DATE'))) {
				refOrderDate=panelSearch.getValue('ORDER_DATE');
			 }

			 var refOrdCust = '';
			 if(!Ext.isEmpty(panelSearch.getValue('CUSTOM_CODE'))) {
				refOrdCust=panelSearch.getValue('CUSTOM_CODE');
			 }

			 var customCode = '';
			 if(!Ext.isEmpty(panelSearch.getValue('SALE_CUST_CD'))) {
				customCode=panelSearch.getValue('SALE_CUST_CD');
			 }else{
				customCode=panelSearch.getValue('CUSTOM_CODE');
			 }

			 var customName = '';
			 if(!Ext.isEmpty(panelSearch.getValue('SALE_CUST_NM'))) {
				customName=panelSearch.getValue('SALE_CUST_NM');
			 }else{
				customName=panelSearch.getValue('CUSTOM_NAME');
			 }

			 var refOrderType = '';
			 if(!Ext.isEmpty(panelSearch.getValue('ORDER_TYPE'))) {
				refOrderType=panelSearch.getValue('ORDER_TYPE');
			 }

			 var projectNo = '';
			 if(!Ext.isEmpty(panelSearch.getValue('PLAN_NUM'))) {
				projectNo=panelSearch.getValue('PLAN_NUM');
			 }

			 var refBillType = '';
			 if(!Ext.isEmpty(panelSearch.getValue('BILL_TYPE'))) {
				refBillType=panelSearch.getValue('BILL_TYPE');
			 }

			 var refReceiptSetMeth = '';
			 if(!Ext.isEmpty(panelSearch.getValue('RECEIPT_SET_METH'))) {
				refReceiptSetMeth=panelSearch.getValue('RECEIPT_SET_METH');
			 }

			 var r = {
				ORDER_NUM			: orderNum,
				SER_NO				: seq,
				OUT_DIV_CODE		: outDivCode,
				TAX_TYPE			: taxType,

				NEW_YN1				: 'N',								//신규
				SER_NO1				: seq1,								//수주순번
				DVRY_DATE1			: dvryDate1,						//납기일
				PROD_END_DATE1		: prodEndDate1,						//생산완료일
				EXP_ISSUE_DATE1		: dvryDate1,						//출하예정일

				NEW_YN2				: 'N',								//신규
				SER_NO2				: seq1 + 1,							//수주순번
				DVRY_DATE2			: dvryDate2,						//납기일
				PROD_END_DATE2		: prodEndDate2,						//생산완료일
				EXP_ISSUE_DATE2		: dvryDate2,						//출하예정일

				NEW_YN3				: 'N',								//신규
				SER_NO3				: seq1 + 2,							//수주순번
				DVRY_DATE3			: dvryDate3,						//납기일
				PROD_END_DATE3		: prodEndDate3,						//생산완료일
				EXP_ISSUE_DATE3		: dvryDate3,						//출하예정일

				NEW_YN4				: 'N',								//신규
				SER_NO4				: seq1 + 3,							//수주순번
				DVRY_DATE4			: dvryDate4,						//납기일
				PROD_END_DATE4		: prodEndDate4,						//생산완료일
				EXP_ISSUE_DATE4		: dvryDate4,						//출하예정일

				NEW_YN5				: 'N',								//신규
				SER_NO5				: seq1 + 4,							//수주순번
				DVRY_DATE5			: dvryDate5,						//납기일
				PROD_END_DATE5		: prodEndDate5,						//생산완료일
				EXP_ISSUE_DATE5		: dvryDate5,						//출하예정일

				NEW_YN6				: 'N',								//신규
				SER_NO6				: seq1 + 5,							//수주순번
				DVRY_DATE6			: dvryDate6,						//납기일
				PROD_END_DATE6		: prodEndDate6,						//생산완료일
				EXP_ISSUE_DATE6		: dvryDate6,						//출하예정일

				NEW_YN7				: 'N',								//신규
				SER_NO7				: seq1 + 6,							//수주순번
				DVRY_DATE7			: dvryDate7,						//납기일
				PROD_END_DATE7		: prodEndDate7,						//생산완료일
				EXP_ISSUE_DATE7		: dvryDate7,						//출하예정일

				SALE_CUST_CD		: customCode,
				CUSTOM_NAME			: customName,
				REF_ORDER_DATE		: refOrderDate,
				REF_ORD_CUST		: refOrdCust,
				REF_ORDER_TYPE		: refOrderType,
				PROJECT_NO			: projectNo,
				REF_BILL_TYPE		: refBillType,
				REF_RECEIPT_SET_METH: refReceiptSetMeth
			};
			detailGrid.createRow(r, 'ITEM_CODE', detailStore.getCount()-1);
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
			panelTrade.setAllFieldsReadOnly(true);

			if(gsSaveRefFlag == "Y"){
				panelSearch.down('#purchaseRequest1').setDisabled(true);
				panelResult.down('#purchaseRequest2').setDisabled(true);
			}
		},
		onLinkNewData: function() {
			 var orderNum = panelSearch.getValue('ORDER_NUM')

			 var seq = detailStore.max('SER_NO');
			 if(!seq) seq = 1;
			 else  seq += 1;

			 var taxType ='1';
			 if(panelSearch.getValue('BILL_TYPE')=='50') {
				taxType ='2';
			 }

			 var outDivCode = '';
			 if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))) {
				outDivCode = panelSearch.getValue('DIV_CODE');
			 }

			 var dvryDate = '';
			 if(!Ext.isEmpty(panelSearch.getValue('DVRY_DATE'))) {
				dvryDate=panelSearch.getValue('DVRY_DATE');
			 }else {
				dvryDate= new Date();
			 }

			 var saleCustCd = '';
			 if(!Ext.isEmpty(panelSearch.getValue('SALE_CUST_CD'))) {
				saleCustCd=panelSearch.getValue('SALE_CUST_CD');
			 }

			 var refOrderDate = '';
			 if(!Ext.isEmpty(panelSearch.getValue('ORDER_DATE'))) {
				refOrderDate=panelSearch.getValue('ORDER_DATE');
			 }

			 var refOrdCust = '';
			 if(!Ext.isEmpty(panelSearch.getValue('CUSTOM_CODE'))) {
				refOrdCust=panelSearch.getValue('CUSTOM_CODE');
			 }

			 var customCode = '';
			 if(!Ext.isEmpty(panelSearch.getValue('SALE_CUST_CD'))) {
				customCode=panelSearch.getValue('SALE_CUST_CD');
			 }else{
				customCode=panelSearch.getValue('CUSTOM_CODE');
			 }

			 var customName = '';
			 if(!Ext.isEmpty(panelSearch.getValue('SALE_CUST_NM'))) {
				customName=panelSearch.getValue('SALE_CUST_NM');
			 }else{
				customName=panelSearch.getValue('CUSTOM_NAME');
			 }

			 var refOrderType = '';
			 if(!Ext.isEmpty(panelSearch.getValue('ORDER_TYPE'))) {
				refOrderType=panelSearch.getValue('ORDER_TYPE');
			 }

			 var projectNo = '';
			 if(!Ext.isEmpty(panelSearch.getValue('PLAN_NUM'))) {
				projectNo=panelSearch.getValue('PLAN_NUM');
			 }

			 var refBillType = '';
			 if(!Ext.isEmpty(panelSearch.getValue('BILL_TYPE'))) {
				refBillType=panelSearch.getValue('BILL_TYPE');
			 }

			 var refReceiptSetMeth = '';
			 if(!Ext.isEmpty(panelSearch.getValue('RECEIPT_SET_METH'))) {
				refReceiptSetMeth=panelSearch.getValue('RECEIPT_SET_METH');
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
				REF_RECEIPT_SET_METH: refReceiptSetMeth
			};
			detailGrid.createRow(r, 'ITEM_CODE', detailGrid.getSelectedRowIndex());
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelTrade.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailStore.clearData();
			panelTrade.clearForm();

			//전역변수 초기화
			queryYear = ''
			this.fnInitBinding();
			panelSearch.getField('CUSTOM_CODE').focus();
		},
		onSaveDataButtonDown: function(config) {
			//여신한도 확인
			if(!panelSearch.fnCreditCheck()) {
				return ;
			}

			if(isDraftFlag === false)	{ // 수동승인인 경우
				var amt = panelSearch.getValue("TOT_ORDER_AMT");
				if(Ext.isEmpty(panelSearch.getValue("APP_1_ID")))	{
					alert("1차 승인자는 필수 입력입니다.");
					panelSearch.getField("APP_1_NM").focus();
					return false;
				}else if(amt > BsaCodeInfo.gsApp1AmtInfo)	{
					if(Ext.isEmpty(panelSearch.getValue("APP_2_ID")))	{
						alert("2차 승인자는 필수 입력입니다.");
						panelSearch.getField("APP_2_NM").focus();
						return false;
					}else  if(amt > BsaCodeInfo.gsApp2AmtInfo)  {
						if(Ext.isEmpty(panelSearch.getValue("APP_3_ID")))	{
							alert("3차 승인자는 필수 입력입니다.");
							panelSearch.getField("APP_3_NM").focus();
							return false;
						}
					}
				}
			}

			if(!detailStore.isDirty())  {
				if(panelSearch.isDirty())	{
					this.fnMasterSave();
				}
			}else {
				detailStore.saveStore();
			}
		},
		onSaveDataButtonDown2: function(config) {	//panelSearch.fnCreditCheck() 없는용..삭제시 호출
//			if(detailStore.data.length == 0) {
//				alert('수주상세정보를 입력하세요.');
//				return;
//			}
			// 여신한도 확인
//			if(!panelSearch.fnCreditCheck()) {
//				return ;
//			}

			if(isDraftFlag === false)	{ // 수동승인인 경우
				var amt = panelSearch.getValue("TOT_ORDER_AMT");
				if(Ext.isEmpty(panelSearch.getValue("APP_1_ID")))	{
					alert("1차 승인자는 필수 입력입니다.");
					panelSearch.getField("APP_1_NM").focus();
					return false;
				}else if(amt > BsaCodeInfo.gsApp1AmtInfo)	{
					if(Ext.isEmpty(panelSearch.getValue("APP_2_ID")))	{
						alert("2차 승인자는 필수 입력입니다.");
						panelSearch.getField("APP_2_NM").focus();
						return false;
					}else  if(amt > BsaCodeInfo.gsApp2AmtInfo)  {
						if(Ext.isEmpty(panelSearch.getValue("APP_3_ID")))	{
							alert("3차 승인자는 필수 입력입니다.");
							panelSearch.getField("APP_3_NM").focus();
							return false;
						}
					}
				}
			}

			if(!detailStore.isDirty())  {
				if(panelSearch.isDirty())	{
					this.fnMasterSave();
				}
			}else {
				detailStore.saveStore();
			}
		},
		fnMasterSave: function(){
			var param = panelSearch.getValues();
			panelSearch.submit({
				params: param,
				success:function(comp, action)  {
					UniAppManager.setToolbarButtons('save', false);
					UniAppManager.updateStatus(Msg.sMB011);
				},
				failure: function(form, action){

				}
			});
		},
		fnNationSave: function(){
			var param = nationSearch.getValues();
			nationSearch.submit({
				params: param,
				success:function(comp, action)  {
					UniAppManager.updateStatus(Msg.sMB011);
				},
				failure: function(form, action){

				}
			});
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('ISSUE_REQ_Q1') > 0 || selRow.get('OUTSTOCK_Q1') > 0
				 ||selRow.get('ISSUE_REQ_Q2') > 0 || selRow.get('OUTSTOCK_Q2') > 0
				 ||selRow.get('ISSUE_REQ_Q3') > 0 || selRow.get('OUTSTOCK_Q3') > 0
				 ||selRow.get('ISSUE_REQ_Q4') > 0 || selRow.get('OUTSTOCK_Q4') > 0
				 ||selRow.get('ISSUE_REQ_Q5') > 0 || selRow.get('OUTSTOCK_Q5') > 0
				 ||selRow.get('ISSUE_REQ_Q6') > 0 || selRow.get('OUTSTOCK_Q6') > 0
				 ||selRow.get('ISSUE_REQ_Q7') > 0 || selRow.get('OUTSTOCK_Q7') > 0
				){
					alert('<t:message code="unilite.msg.sMS216" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
				}else {
					detailGrid.deleteSelectedRow();
				}
			}
			// fnOrderAmtSum 호출(grid summary 이용)
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					 //신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{								  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						Ext.each(records, function(record,i) {
							if(record.get('ISSUE_REQ_Q1') > 0 || record.get('OUTSTOCK_Q1') > 0
							 ||record.get('ISSUE_REQ_Q2') > 0 || record.get('OUTSTOCK_Q2') > 0
							 ||record.get('ISSUE_REQ_Q3') > 0 || record.get('OUTSTOCK_Q3') > 0
							 ||record.get('ISSUE_REQ_Q4') > 0 || record.get('OUTSTOCK_Q4') > 0
							 ||record.get('ISSUE_REQ_Q5') > 0 || record.get('OUTSTOCK_Q5') > 0
							 ||record.get('ISSUE_REQ_Q6') > 0 || record.get('OUTSTOCK_Q6') > 0
							 ||record.get('ISSUE_REQ_Q7') > 0 || record.get('OUTSTOCK_Q7') > 0
							){
								alert('<t:message code="unilite.msg.sMS216" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
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
			if(isNewData){							  //신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('s_sof101ukrv_ypAdvanceSerch');
			if(as.isHidden())	{
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
		confirmSaveData: function(config)	{
			if(detailStore.isDirty() )  {
				if(confirm(Msg.sMB061)) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
			//무역 폼필드 readOnly
			panelTrade.getForm().getFields().each(function(field) {
				field.setReadOnly(true);
			});

			/*영업담당 filter set*/
			var field = panelSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE',new Date());
			panelResult.setValue('ORDER_DATE',new Date());
			panelSearch.setValue('TAX_INOUT','1');
			panelResult.setValue('TAX_INOUT','1');
			panelSearch.setValue('STATUS','1');
			panelResult.setValue('STATUS','1');
			panelSearch.setValue('MONEY_UNIT','KRW');
			panelResult.setValue('MONEY_UNIT','KRW');
			panelSearch.setValue('EXCHANGE_RATE','1');
			panelResult.setValue('EXCHANGE_RATE','1');
			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
//			panelSearch.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);
			panelSearch.setValue('ORDER_PRSN','70');
			panelResult.setValue('ORDER_PRSN', '70');
			panelSearch.setValue('NATION_INOUT','1');
			panelResult.setValue('NATION_INOUT','1');
			panelSearch.setValue('DVRY_DATE',new Date());
			panelResult.setValue('DVRY_DATE',new Date());
//			panelSearch.setValue('ORDER_PRSN', Ext.data.StoreManager.lookup('CBS_AU_S010').getAt(0).get('value')); //영엽담당
//			panelResult.setValue('ORDER_PRSN', Ext.data.StoreManager.lookup('CBS_AU_S010').getAt(0).get('value')); //영엽담당
			panelTrade.setValue('DATE_EXP', new Date());
			panelTrade.setValue('DATE_DEPART', new Date());

			if( BsaCodeInfo.gsCreditYn == 'Y')  {
				panelSearch.getField('REMAIN_CREDIT').show();
				panelResult.getField('REMAIN_CREDIT').show();
			} else {
				panelSearch.getField('REMAIN_CREDIT').hide();
				panelResult.getField('REMAIN_CREDIT').show();
			}

			if(BsaCodeInfo.gsAutoType=='Y') {
				panelSearch.getField('ORDER_NUM').setReadOnly(true);
				panelResult.getField('ORDER_NUM').setReadOnly(true);
			} else {
				panelSearch.getField('ORDER_NUM').setReadOnly(false);
				panelResult.getField('ORDER_NUM').setReadOnly(false);
			}

			var billType = panelSearch.getField('BILL_TYPE');
			var orderType = panelSearch.getField('ORDER_TYPE');
			var receiptMeth = panelSearch.getField('RECEIPT_SET_METH');

			billType.select(billType.getStore().getAt(0));
			//판매유형 기본값 삭제(20171215)
//			orderType.select(orderType.getStore().getAt(0));
			receiptMeth.select(receiptMeth.getStore().getAt(0));

			if(BsaCodeInfo.gsDraftFlag=='1')	{
				panelSearch.down('#DraftFields').show();
			} else {
				panelSearch.down('#DraftFields').hide();
			}

//			if(BsaCodeInfo.gsScmUseYN=='Y') {
//				detailGrid.down().down('#scmBtn').show();
//			} else {
//				detailGrid.down().down('#scmBtn').hide();
//			}
			panelSearch.getField('ORDER_O').setReadOnly(true);
			panelSearch.getField('ORDER_TAX_O').setReadOnly(true);
			panelSearch.getField('TOT_ORDER_AMT').setReadOnly(true);
			UniAppManager.app.fnExchngRateO(true);
			gsSaveRefFlag = 'N';
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();

			fnGetCalNo(new Date());

			panelSearch.getField('OFFER_NO').setReadOnly(true);
			panelResult.getField('OFFER_NO').setReadOnly(true);
			UniAppManager.setToolbarButtons('save', false);
		},
		setNationInfoData: function(record, dataClear) {
			panelSearch.setValue('CUSTOM_CODE_TEMP'		,nationSearch.getValue('CUSTOM_CODE'));
			panelSearch.setValue('CUSTOM_NAME_TEMP'		,nationSearch.getValue('CUSTOM_NAME'));
			panelSearch.setValue('DATE_DEPART'			,nationSearch.getValue('DATE_DEPART'));
			panelSearch.setValue('DATE_EXP'				,nationSearch.getValue('DATE_EXP'));
			panelSearch.setValue('PAY_METHODE1'			,nationSearch.getValue('PAY_METHODE1'));
			panelSearch.setValue('PAY_TERMS'			,nationSearch.getValue('PAY_TERMS'));
			panelSearch.setValue('PAY_DURING'			,nationSearch.getValue('PAY_DURING'));
			panelSearch.setValue('TERMS_PRICE'			,nationSearch.getValue('TERMS_PRICE'));
			panelSearch.setValue('COND_PACKING'			,nationSearch.getValue('COND_PACKING'));
			panelSearch.setValue('METH_CARRY'			,nationSearch.getValue('METH_CARRY'));
			panelSearch.setValue('METH_INSPECT'			,nationSearch.getValue('METH_INSPECT'));
			panelSearch.setValue('DEST_PORT'			,nationSearch.getValue('DEST_PORT'));
			panelSearch.setValue('DEST_PORT_NM'			,nationSearch.getValue('DEST_PORT_NM'));
			panelSearch.setValue('SHIP_PORT'			,nationSearch.getValue('SHIP_PORT'));
			panelSearch.setValue('SHIP_PORT_NM'			,nationSearch.getValue('SHIP_PORT_NM'));
			panelSearch.setValue('BANK_SENDING'			,nationSearch.getValue('BANK_CODE'));
			//record.set(''					,nationSearch.getValue(''));
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"		: UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE')),
				"MONEY_UNIT"	: panelSearch.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni && !Ext.isEmpty(panelSearch.getValue('MONEY_UNIT')) && panelSearch.getValue('MONEY_UNIT') != "KRW"){
						alert('환율정보가 없습니다.');
					}
					panelSearch.setValue('EXCHANGE_RATE', provider.BASE_EXCHG);
					panelResult.setValue('EXCHANGE_RATE', provider.BASE_EXCHG);
				}
			});
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelSearch.getValue('ORDER_NUM')))	{
				alert('<t:message code="unilite.msg.sMS533" default="수주번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}

			/**
			 * 여신한도 확인
			 */
			if(!panelSearch.fnCreditCheck()) {
				return false;
			}

			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			panelResult.setAllFieldsReadOnly(true);
			return panelSearch.setAllFieldsReadOnly(true);
		},
		fnOrderAmtCal: function(rtnRecord, sType, nValue, taxType, orderQ) {
			var dTransRate	= Unilite.nvl(rtnRecord.get('TRANS_RATE'),1);
			var dDcRate		= Unilite.nvl(rtnRecord.get('DISCOUNT_RATE'),0);	//할인율
			var dOrderP		= sType=='P' && orderQ == 'ORDER_P'		? nValue : Unilite.nvl(rtnRecord.get('ORDER_P'),0);				//단가

/*			var dOrderO1	= Unilite.nvl(rtnRecord.get('ORDER_O1'),0);			//금액1
			var dOrderO2	= Unilite.nvl(rtnRecord.get('ORDER_O2'),0);			//금액2
			var dOrderO3	= Unilite.nvl(rtnRecord.get('ORDER_O3'),0);			//금액3
			var dOrderO4	= Unilite.nvl(rtnRecord.get('ORDER_O4'),0);			//금액4
			var dOrderO5	= Unilite.nvl(rtnRecord.get('ORDER_O5'),0);			//금액5
			var dOrderO6	= Unilite.nvl(rtnRecord.get('ORDER_O6'),0);			//금액6
			var dOrderO7	= Unilite.nvl(rtnRecord.get('ORDER_O7'),0);			//금액7
*/
			var dOrderQ1	= sType=='Q' && orderQ == 'ORDER_Q1'	? nValue : Unilite.nvl(rtnRecord.get('ORDER_Q1'),0);			//금액1
			var dOrderQ2	= sType=='Q' && orderQ == 'ORDER_Q2'	? nValue : Unilite.nvl(rtnRecord.get('ORDER_Q2'),0);			//금액2
			var dOrderQ3	= sType=='Q' && orderQ == 'ORDER_Q3'	? nValue : Unilite.nvl(rtnRecord.get('ORDER_Q3'),0);			//금액3
			var dOrderQ4	= sType=='Q' && orderQ == 'ORDER_Q4'	? nValue : Unilite.nvl(rtnRecord.get('ORDER_Q4'),0);			//금액4
			var dOrderQ5	= sType=='Q' && orderQ == 'ORDER_Q5'	? nValue : Unilite.nvl(rtnRecord.get('ORDER_Q5'),0);			//금액5
			var dOrderQ6	= sType=='Q' && orderQ == 'ORDER_Q6'	? nValue : Unilite.nvl(rtnRecord.get('ORDER_Q6'),0);			//금액6
			var dOrderQ7	= sType=='Q' && orderQ == 'ORDER_Q7'	? nValue : Unilite.nvl(rtnRecord.get('ORDER_Q7'),0);			//금액7

			if(sType == 'P' || sType == 'Q')	{	//업종별 프로세스 적용
				var dOrderUnitQ = 0;
				if(BsaCodeInfo.gsProcessFlag == 'PG') {
					dOrderO1 = dOrderQ1 * dOrderP * dTransRate;
					dOrderO2 = dOrderQ2 * dOrderP * dTransRate;
					dOrderO3 = dOrderQ3 * dOrderP * dTransRate;
					dOrderO4 = dOrderQ4 * dOrderP * dTransRate;
					dOrderO5 = dOrderQ5 * dOrderP * dTransRate;
					dOrderO6 = dOrderQ6 * dOrderP * dTransRate;
					dOrderO7 = dOrderQ7 * dOrderP * dTransRate;

				} else {
					dOrderO1 = dOrderQ1 * dOrderP;
					dOrderO2 = dOrderQ2 * dOrderP;
					dOrderO3 = dOrderQ3 * dOrderP;
					dOrderO4 = dOrderQ4 * dOrderP;
					dOrderO5 = dOrderQ5 * dOrderP;
					dOrderO6 = dOrderQ6 * dOrderP;
					dOrderO7 = dOrderQ7 * dOrderP;
				}
				dOrderUnitQ1 = dOrderQ1 * dTransRate;
				dOrderUnitQ2 = dOrderQ2 * dTransRate;
				dOrderUnitQ3 = dOrderQ3 * dTransRate;
				dOrderUnitQ4 = dOrderQ4 * dTransRate;
				dOrderUnitQ5 = dOrderQ5 * dTransRate;
				dOrderUnitQ6 = dOrderQ6 * dTransRate;
				dOrderUnitQ7 = dOrderQ7 * dTransRate;

				rtnRecord.set('ORDER_O1', dOrderO1);
				rtnRecord.set('ORDER_O2', dOrderO2);
				rtnRecord.set('ORDER_O3', dOrderO3);
				rtnRecord.set('ORDER_O4', dOrderO4);
				rtnRecord.set('ORDER_O5', dOrderO5);
				rtnRecord.set('ORDER_O6', dOrderO6);
				rtnRecord.set('ORDER_O7', dOrderO7);

				rtnRecord.set('ORDER_UNIT_Q1', dOrderUnitQ1);
				rtnRecord.set('ORDER_UNIT_Q2', dOrderUnitQ2);
				rtnRecord.set('ORDER_UNIT_Q3', dOrderUnitQ3);
				rtnRecord.set('ORDER_UNIT_Q4', dOrderUnitQ4);
				rtnRecord.set('ORDER_UNIT_Q5', dOrderUnitQ5);
				rtnRecord.set('ORDER_UNIT_Q6', dOrderUnitQ6);
				rtnRecord.set('ORDER_UNIT_Q7', dOrderUnitQ7);

				this.fnTaxCalculate(rtnRecord)

			}/* 이 프로그램에서는 R(입수), P(단가), C(할인율) 변경사항 없음
				 else if(sType == 'R') {
				dOrderUnitQ1 = dOrderQ1 * dTransRate;
				dOrderUnitQ2 = dOrderQ2 * dTransRate;
				dOrderUnitQ3 = dOrderQ3 * dTransRate;
				dOrderUnitQ4 = dOrderQ4 * dTransRate;
				dOrderUnitQ5 = dOrderQ5 * dTransRate;
				dOrderUnitQ6 = dOrderQ6 * dTransRate;
				dOrderUnitQ7 = dOrderQ7 * dTransRate;

				rtnRecord.set('ORDER_UNIT_Q1', dOrderUnitQ1);
				rtnRecord.set('ORDER_UNIT_Q2', dOrderUnitQ2);
				rtnRecord.set('ORDER_UNIT_Q3', dOrderUnitQ3);
				rtnRecord.set('ORDER_UNIT_Q4', dOrderUnitQ4);
				rtnRecord.set('ORDER_UNIT_Q5', dOrderUnitQ5);
				rtnRecord.set('ORDER_UNIT_Q6', dOrderUnitQ6);
				rtnRecord.set('ORDER_UNIT_Q7', dOrderUnitQ7);

			} else if(sType == 'O') {
				if(dOrderQ != 0)	{
					if(BsaCodeInfo.gsProcessFlag == 'PG') {
						dOrderP =dOrderO / (dOrderQ * dTransRate);
					}else {
						dOrderP = dOrderO / dOrderQ;
					}
				}
				rtnRecord.set('ORDER_P', dOrderP);
				this.fnTaxCalculate(rtnRecord, dOrderO, taxType)
			} else if(sType == 'C') {
				dOrderP = (dOrderP - (dOrderP * (dDcRate / 100)));
				rtnRecord.set('ORDER_P', dOrderP);
				if(BsaCodeInfo.gsProcessFlag == 'PG')	{
					dOrderO = dOrderQ * dOrderP * dTransRate ;
				} else {
					dOrderO = dOrderQ * dOrderP
				}
				this.fnTaxCalculate(rtnRecord, dOrderO)
			}*/
		},
		fnTaxCalculate: function(rtnRecord, dOrderO, taxType) {
			var sTaxType		= Ext.isEmpty(taxType)? rtnRecord.get('TAX_TYPE') : taxType;
			var sTaxInoutType	= Ext.getCmp('taxInout').getChecked()[0].inputValue;
			var dVatRate		= parseInt(BsaCodeInfo.gsVatRate);
			var numDigitOfPrice	= UniFormat.Price.length - (UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length: UniFormat.Price.indexOf("."));
			var dOrderO1	= Unilite.nvl(rtnRecord.get('ORDER_O1'),0);			//금액1
			var dOrderO2	= Unilite.nvl(rtnRecord.get('ORDER_O2'),0);			//금액2
			var dOrderO3	= Unilite.nvl(rtnRecord.get('ORDER_O3'),0);			//금액3
			var dOrderO4	= Unilite.nvl(rtnRecord.get('ORDER_O4'),0);			//금액4
			var dOrderO5	= Unilite.nvl(rtnRecord.get('ORDER_O5'),0);			//금액5
			var dOrderO6	= Unilite.nvl(rtnRecord.get('ORDER_O6'),0);			//금액6
			var dOrderO7	= Unilite.nvl(rtnRecord.get('ORDER_O7'),0);			//금액7

			var dOrderAmtO1		= 0;
			var dOrderAmtO2		= 0;
			var dOrderAmtO3		= 0;
			var dOrderAmtO4		= 0;
			var dOrderAmtO5		= 0;
			var dOrderAmtO6		= 0;
			var dOrderAmtO7		= 0;

			var dTaxAmtO1		= 0;
			var dTaxAmtO2		= 0;
			var dTaxAmtO3		= 0;
			var dTaxAmtO4		= 0;
			var dTaxAmtO5		= 0;
			var dTaxAmtO6		= 0;
			var dTaxAmtO7		= 0;

			var dAmountI1		= 0;
			var dAmountI2		= 0;
			var dAmountI3		= 0;
			var dAmountI4		= 0;
			var dAmountI5		= 0;
			var dAmountI6		= 0;
			var dAmountI7		= 0;

			if(sTaxInoutType=="1") {
				dOrderAmtO1	= dOrderO1;
				dOrderAmtO2	= dOrderO2;
				dOrderAmtO3	= dOrderO3;
				dOrderAmtO4	= dOrderO4;
				dOrderAmtO5	= dOrderO5;
				dOrderAmtO6	= dOrderO6;
				dOrderAmtO7	= dOrderO7;

				dTaxAmtO1	= dOrderO1 * dVatRate / 100
				dTaxAmtO2	= dOrderO2 * dVatRate / 100
				dTaxAmtO3	= dOrderO3 * dVatRate / 100
				dTaxAmtO4	= dOrderO4 * dVatRate / 100
				dTaxAmtO5	= dOrderO5 * dVatRate / 100
				dTaxAmtO6	= dOrderO6 * dVatRate / 100
				dTaxAmtO7	= dOrderO7 * dVatRate / 100

				dOrderAmtO1	= UniSales.fnAmtWonCalc(dOrderAmtO1,'3', numDigitOfPrice);
				dOrderAmtO2	= UniSales.fnAmtWonCalc(dOrderAmtO2,'3', numDigitOfPrice);
				dOrderAmtO3	= UniSales.fnAmtWonCalc(dOrderAmtO3,'3', numDigitOfPrice);
				dOrderAmtO4	= UniSales.fnAmtWonCalc(dOrderAmtO4,'3', numDigitOfPrice);
				dOrderAmtO5	= UniSales.fnAmtWonCalc(dOrderAmtO5,'3', numDigitOfPrice);
				dOrderAmtO6	= UniSales.fnAmtWonCalc(dOrderAmtO6,'3', numDigitOfPrice);
				dOrderAmtO7	= UniSales.fnAmtWonCalc(dOrderAmtO7,'3', numDigitOfPrice);

				if(UserInfo.compCountry == 'CN') {
					dTaxAmtO1	= UniSales.fnAmtWonCalc(dTaxAmtO1, "3", numDigitOfPrice);							  //세액은 절사처리함.
					dTaxAmtO2	= UniSales.fnAmtWonCalc(dTaxAmtO2, "3", numDigitOfPrice);							  //세액은 절사처리함.
					dTaxAmtO3	= UniSales.fnAmtWonCalc(dTaxAmtO3, "3", numDigitOfPrice);							  //세액은 절사처리함.
					dTaxAmtO4	= UniSales.fnAmtWonCalc(dTaxAmtO4, "3", numDigitOfPrice);							  //세액은 절사처리함.
					dTaxAmtO5	= UniSales.fnAmtWonCalc(dTaxAmtO5, "3", numDigitOfPrice);							  //세액은 절사처리함.
					dTaxAmtO6	= UniSales.fnAmtWonCalc(dTaxAmtO6, "3", numDigitOfPrice);							  //세액은 절사처리함.
					dTaxAmtO7	= UniSales.fnAmtWonCalc(dTaxAmtO7, "3", numDigitOfPrice);							  //세액은 절사처리함.

				} else {
					dTaxAmtO1	= UniSales.fnAmtWonCalc(dTaxAmtO1, "2", numDigitOfPrice);							  //세액은 절사처리함.
					dTaxAmtO2	= UniSales.fnAmtWonCalc(dTaxAmtO2, "2", numDigitOfPrice);							  //세액은 절사처리함.
					dTaxAmtO3	= UniSales.fnAmtWonCalc(dTaxAmtO3, "2", numDigitOfPrice);							  //세액은 절사처리함.
					dTaxAmtO4	= UniSales.fnAmtWonCalc(dTaxAmtO4, "2", numDigitOfPrice);							  //세액은 절사처리함.
					dTaxAmtO5	= UniSales.fnAmtWonCalc(dTaxAmtO5, "2", numDigitOfPrice);							  //세액은 절사처리함.
					dTaxAmtO6	= UniSales.fnAmtWonCalc(dTaxAmtO6, "2", numDigitOfPrice);							  //세액은 절사처리함.
					dTaxAmtO7	= UniSales.fnAmtWonCalc(dTaxAmtO7, "2", numDigitOfPrice);							  //세액은 절사처리함.
				}

			} else if(sTaxInoutType=="2") {
				dAmountI1 = dOrderO1;
				dAmountI2 = dOrderO2;
				dAmountI3 = dOrderO3;
				dAmountI4 = dOrderO4;
				dAmountI5 = dOrderO5;
				dAmountI6 = dOrderO6;
				dAmountI7 = dOrderO7;

				if(UserInfo.compCountry == 'CN') {
					dTemp1		= UniSales.fnAmtWonCalc((dAmountI1 / ( dVatRate + 100 )) * 100, "3", numDigitOfPrice);	 //세액은 절사처리함.
					dTemp2		= UniSales.fnAmtWonCalc((dAmountI2 / ( dVatRate + 100 )) * 100, "3", numDigitOfPrice);	 //세액은 절사처리함.
					dTemp3		= UniSales.fnAmtWonCalc((dAmountI3 / ( dVatRate + 100 )) * 100, "3", numDigitOfPrice);	 //세액은 절사처리함.
					dTemp4		= UniSales.fnAmtWonCalc((dAmountI4 / ( dVatRate + 100 )) * 100, "3", numDigitOfPrice);	 //세액은 절사처리함.
					dTemp5		= UniSales.fnAmtWonCalc((dAmountI5 / ( dVatRate + 100 )) * 100, "3", numDigitOfPrice);	 //세액은 절사처리함.
					dTemp6		= UniSales.fnAmtWonCalc((dAmountI6 / ( dVatRate + 100 )) * 100, "3", numDigitOfPrice);	 //세액은 절사처리함.
					dTemp7		= UniSales.fnAmtWonCalc((dAmountI7 / ( dVatRate + 100 )) * 100, "3", numDigitOfPrice);	 //세액은 절사처리함.

					dTaxAmtO1	= UniSales.fnAmtWonCalc(dTemp1 * dVatRate / 100, "3", numDigitOfPrice);					//세액은 절사처리함.
					dTaxAmtO2	= UniSales.fnAmtWonCalc(dTemp2 * dVatRate / 100, "3", numDigitOfPrice);					//세액은 절사처리함.
					dTaxAmtO3	= UniSales.fnAmtWonCalc(dTemp3 * dVatRate / 100, "3", numDigitOfPrice);					//세액은 절사처리함.
					dTaxAmtO4	= UniSales.fnAmtWonCalc(dTemp4 * dVatRate / 100, "3", numDigitOfPrice);					//세액은 절사처리함.
					dTaxAmtO5	= UniSales.fnAmtWonCalc(dTemp5 * dVatRate / 100, "3", numDigitOfPrice);					//세액은 절사처리함.
					dTaxAmtO6	= UniSales.fnAmtWonCalc(dTemp6 * dVatRate / 100, "3", numDigitOfPrice);					//세액은 절사처리함.
					dTaxAmtO7	= UniSales.fnAmtWonCalc(dTemp7 * dVatRate / 100, "3", numDigitOfPrice);					//세액은 절사처리함.

				} else {
					dTemp1		= UniSales.fnAmtWonCalc((dAmountI1 / ( dVatRate + 100 )) * 100, "2", numDigitOfPrice);	 //세액은 절사처리함.
					dTemp2		= UniSales.fnAmtWonCalc((dAmountI2 / ( dVatRate + 100 )) * 100, "2", numDigitOfPrice);	 //세액은 절사처리함.
					dTemp3		= UniSales.fnAmtWonCalc((dAmountI3 / ( dVatRate + 100 )) * 100, "2", numDigitOfPrice);	 //세액은 절사처리함.
					dTemp4		= UniSales.fnAmtWonCalc((dAmountI4 / ( dVatRate + 100 )) * 100, "2", numDigitOfPrice);	 //세액은 절사처리함.
					dTemp5		= UniSales.fnAmtWonCalc((dAmountI5 / ( dVatRate + 100 )) * 100, "2", numDigitOfPrice);	 //세액은 절사처리함.
					dTemp6		= UniSales.fnAmtWonCalc((dAmountI6 / ( dVatRate + 100 )) * 100, "2", numDigitOfPrice);	 //세액은 절사처리함.
					dTemp7		= UniSales.fnAmtWonCalc((dAmountI7 / ( dVatRate + 100 )) * 100, "2", numDigitOfPrice);	 //세액은 절사처리함.

					dTaxAmtO1	= UniSales.fnAmtWonCalc(dTemp1 * dVatRate / 100, "2", numDigitOfPrice);							//세액은 절사처리함.
					dTaxAmtO2	= UniSales.fnAmtWonCalc(dTemp2 * dVatRate / 100, "2", numDigitOfPrice);							//세액은 절사처리함.
					dTaxAmtO3	= UniSales.fnAmtWonCalc(dTemp3 * dVatRate / 100, "2", numDigitOfPrice);							//세액은 절사처리함.
					dTaxAmtO4	= UniSales.fnAmtWonCalc(dTemp4 * dVatRate / 100, "2", numDigitOfPrice);							//세액은 절사처리함.
					dTaxAmtO5	= UniSales.fnAmtWonCalc(dTemp5 * dVatRate / 100, "2", numDigitOfPrice);							//세액은 절사처리함.
					dTaxAmtO6	= UniSales.fnAmtWonCalc(dTemp6 * dVatRate / 100, "2", numDigitOfPrice);							//세액은 절사처리함.
					dTaxAmtO7	= UniSales.fnAmtWonCalc(dTemp7 * dVatRate / 100, "2", numDigitOfPrice);							//세액은 절사처리함.
				}
				dOrderAmtO1 = UniSales.fnAmtWonCalc((dAmountI1 - dTaxAmtO1), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice) ;
				dOrderAmtO2 = UniSales.fnAmtWonCalc((dAmountI2 - dTaxAmtO2), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice) ;
				dOrderAmtO3 = UniSales.fnAmtWonCalc((dAmountI3 - dTaxAmtO3), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice) ;
				dOrderAmtO4 = UniSales.fnAmtWonCalc((dAmountI4 - dTaxAmtO4), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice) ;
				dOrderAmtO5 = UniSales.fnAmtWonCalc((dAmountI5 - dTaxAmtO5), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice) ;
				dOrderAmtO6 = UniSales.fnAmtWonCalc((dAmountI6 - dTaxAmtO6), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice) ;
				dOrderAmtO7 = UniSales.fnAmtWonCalc((dAmountI7 - dTaxAmtO7), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice) ;
			}
			if(sTaxType == "2") {
				dOrderAmtO1 = UniSales.fnAmtWonCalc(dOrderO1, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice ) ;
				dOrderAmtO2 = UniSales.fnAmtWonCalc(dOrderO2, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice ) ;
				dOrderAmtO3 = UniSales.fnAmtWonCalc(dOrderO3, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice ) ;
				dOrderAmtO4 = UniSales.fnAmtWonCalc(dOrderO4, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice ) ;
				dOrderAmtO5 = UniSales.fnAmtWonCalc(dOrderO5, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice ) ;
				dOrderAmtO6 = UniSales.fnAmtWonCalc(dOrderO6, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice ) ;
				dOrderAmtO7 = UniSales.fnAmtWonCalc(dOrderO7, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice ) ;

				dTaxAmtO1 = 0;
				dTaxAmtO2 = 0;
				dTaxAmtO3 = 0;
				dTaxAmtO4 = 0;
				dTaxAmtO5 = 0;
				dTaxAmtO6 = 0;
				dTaxAmtO7 = 0;
			}

			rtnRecord.set('ORDER_O1'			, dOrderAmtO1);
			rtnRecord.set('ORDER_O2'			, dOrderAmtO2);
			rtnRecord.set('ORDER_O3'			, dOrderAmtO3);
			rtnRecord.set('ORDER_O4'			, dOrderAmtO4);
			rtnRecord.set('ORDER_O5'			, dOrderAmtO5);
			rtnRecord.set('ORDER_O6'			, dOrderAmtO6);
			rtnRecord.set('ORDER_O7'			, dOrderAmtO7);

			rtnRecord.set('ORDER_TAX_O1'		, dTaxAmtO1);
			rtnRecord.set('ORDER_TAX_O2'		, dTaxAmtO2);
			rtnRecord.set('ORDER_TAX_O3'		, dTaxAmtO3);
			rtnRecord.set('ORDER_TAX_O4'		, dTaxAmtO4);
			rtnRecord.set('ORDER_TAX_O5'		, dTaxAmtO5);
			rtnRecord.set('ORDER_TAX_O6'		, dTaxAmtO6);
			rtnRecord.set('ORDER_TAX_O7'		, dTaxAmtO7);

			rtnRecord.set('ORDER_O_TAX_O1'	, dOrderAmtO1 + dTaxAmtO1);
			rtnRecord.set('ORDER_O_TAX_O2'	, dOrderAmtO2 + dTaxAmtO2);
			rtnRecord.set('ORDER_O_TAX_O3'	, dOrderAmtO3 + dTaxAmtO3);
			rtnRecord.set('ORDER_O_TAX_O4'	, dOrderAmtO4 + dTaxAmtO4);
			rtnRecord.set('ORDER_O_TAX_O5'	, dOrderAmtO5 + dTaxAmtO5);
			rtnRecord.set('ORDER_O_TAX_O6'	, dOrderAmtO6 + dTaxAmtO6);
			rtnRecord.set('ORDER_O_TAX_O7'	, dOrderAmtO7 + dTaxAmtO7);
		},
		fnCheckNum: function(value, record, fieldName, fieldLabel) {
			var r = true;
			if(record.get("PRICE_YN") == "1" || record.get("ACCOUNT_YNC")=="N") {
				r = true;
			} else if(record.get("PRICE_YN") == "2" )	{
				if(value < 0)	{
					alert(fieldLabel+'은 '+Msg.sMB076);
					r=false;
					return r;
				}else if(value == 0)	{
					if(fieldName == "ORDER_TAX_O")  {
						if(BsaCodeInfo.gsVatRate != 0)  {
							alert(fieldLabel+'은 0보다 큰 값이 입력되어야 합니다.');
							r=false;
						}
					}else {
						alert(fieldLabel+'은 0보다 큰 값이 입력되어야 합니다.');
						r=false;
					}
				}
			}
			return r;
		},
		// UniSales.fnGetItemInfo callback 함수
		cbGetItemInfo: function(provider, params)	{
			UniAppManager.app.cbGetPriceInfo(provider, params);

			UniAppManager.app.fnOrderAmtCal(params.rtnRecord, 'P');			//rtnRecord, sType, nValue, taxType, orderQ
			detailStore.fnOrderAmtSum();
			Ext.getBody().unmask();
//			gsI=gsI+1;

			//재고관련 로직은 일단 주석 : 추후 로직 재정립해서 구현(20171013)
//			UniAppManager.app.cbStockQ(provider, params);
		},
		// UniSales.fnGetPriceInfo callback 함수
		cbGetPriceInfo: function(provider, params)  {
			var dSalePrice=Unilite.nvl(provider['SALE_PRICE'],0);

			var dWgtPrice = Unilite.nvl(provider['WGT_PRICE'],0);//판매단가(중량단위)
			var dVolPrice = Unilite.nvl(provider['VOL_PRICE'],0);//판매단가(부피단위)

			if(params.sType=='I')	{
				//단가구분별 판매단가 계산
				if(params.priceType == 'A') {							//단가구분(판매단위)
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					dVolPrice = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				}else if(params.priceType == 'B')	{						//단가구분(중량단위)
					dSalePrice = dWgtPrice  * params.unitWgt
					dVolPrice  = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				}else if(params.priceType == 'C')	{						//단가구분(부피단위)
					dSalePrice = dVolPrice  * params.unitVol;
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
				}else {
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					dVolPrice = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				}


				//판매단가 적용
				params.rtnRecord.set('ORDER_P'		,dSalePrice);
				params.rtnRecord.set('ORDER_WGT_P'	,dWgtPrice);
				params.rtnRecord.set('ORDER_VOL_P'	,dVolPrice);

				params.rtnRecord.set('TRANS_RATE'	,provider['SALE_TRANS_RATE']);
				params.rtnRecord.set('DISCOUNT_RATE',provider['DC_RATE']);

				//단가구분SET  //1:가단가 2:진단가
				params.rtnRecord.set('PRICE_YN'		,provider['PRICE_TYPE']);
//				params.rtnRecord.set('PRICE_TYPE'	,provider['PRICE_TYPE']);
			}
			//if(params.qty > 0)  UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P", dSalePrice);

			if(params.qty > 0 && dSalePrice > 0 )  {
				UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P", dSalePrice)
			}else{
				var dTransRate = Unilite.nvl(params.rtnRecord.get('TRANS_RATE'),1);
				var dOrderQ = Unilite.nvl(params.rtnRecord.get('ORDER_Q'),0);
				var dOrderUnitQ = 0;

				dOrderUnitQ = dOrderQ * dTransRate;
				params.rtnRecord.set('ORDER_UNIT_Q', dOrderUnitQ);
			};
		},
		// UniSales.fnStockQ callback 함수
		cbStockQ: function(provider, params)	{
			var rtnRecord = params.rtnRecord;
			rtnRecord.set('STOCK_Q', provider['STOCK_Q']);

			var dStockQ = 0;
			var dOrderQ = 0;
			var lTrnsRate = rtnRecord.get('TRANS_RATE');

			if(!Ext.isEmpty(rtnRecord.get('STOCK_Q')))  {
				dStockQ = rtnRecord.get('STOCK_Q');
			}

			var calcPrdQ = 0;									//생산량 계산하기 위한 변수
			for(var i = 1; i < 8 ; i++) {
				dStockQ = dStockQ - calcPrdQ;

				if(!Ext.isEmpty(rtnRecord.get('ORDER_Q'+i)))  {
					dOrderQi = rtnRecord.get('ORDER_Q'+i);
				}

				if(dStockQ > 0 )	{
					if(dStockQ > dOrderQi)	{	//'재고량 > 수주량
						rtnRecord.set('PROD_SALE_Q'+i		,0);
						rtnRecord.set('PROD_Q'+i			,0);
						rtnRecord.set('PROD_END_DATE'+i		,'');
						rtnRecord.set('EXP_ISSUE_DATE'+i	,'');
						calcPrdQ = dOrderQi;

					} else {
						if(rtnRecord.get('ITEM_ACCOUNT')=="00") {
							rtnRecord.set('PROD_SALE_Q'+i		,0);
							rtnRecord.set('PROD_Q'+i			,0);
							rtnRecord.set('PROD_END_DATE'+i		,'');
							rtnRecord.set('EXP_ISSUE_DATE'+i	,'');
							calcPrdQ = 0;
						}else {
							if(lTrnsRate > 0 )  {
								rtnRecord.set('PROD_SALE_Q'+i		,((dOrderQ * lTrnsRate - dStockQ) / lTrnsRate));
								rtnRecord.set('PROD_Q'+i			,(dOrderQ * lTrnsRate - dStockQ ) );
								rtnRecord.set('PROD_END_DATE'+i		, UniDate.add(rtnRecord.get('DVRY_DATE'), {days: -1}));
								rtnRecord.set('EXP_ISSUE_DATE'+i	, rtnRecord.get('DVRY_DATE'));
								calcPrdQ = dStockQ;
							}
						}
					}
				}else {
					if(rtnRecord.get('ITEM_ACCOUNT')=="00") {
						rtnRecord.set('PROD_SALE_Q'+i		,0);
						rtnRecord.set('PROD_Q'+i			,0);
						rtnRecord.set('PROD_END_DATE'+i		,'');
						rtnRecord.set('EXP_ISSUE_DATE'+i	,'');
					}else {
						if(lTrnsRate > 0 )  {
							rtnRecord.set('PROD_SALE_Q'+i	,dOrderQ);
							rtnRecord.set('PROD_Q'+i		,(dOrderQ * lTrnsRate ) );
						}
					}
					calcPrdQ = dStockQ;
				}

				if(BsaCodeInfo.gsProdtDtAutoYN=='Y')	{
					var dProdtQ = 0;
					if(!Ext.isEmpty(rtnRecord.get('PROD_SALE_Q'+i)))  {
						dProdtQ = rtnRecord.get('PROD_SALE_Q'+i);
					}

					if(dProdtQ > 0) {
						rtnRecord.set('PROD_END_DATE'+i		,UniDate.add(rtnRecord.get('DVRY_DATE'), {days: -1}));
						rtnRecord.set('EXP_ISSUE_DATE'+i	,rtnRecord.get('DVRY_DATE'));
					}
				}
			}
			rtnRecord.set('PRICE_YN'		,provider['PRICE_TYPE']);
		},
		fnGetCustCredit: function(divCode, customCode, sDate, moneyUnit){
			var param = {"DIV_CODE": divCode, "CUSTOM_CODE": customCode, "SALE_DATE": sDate, "MONEY_UNIT": moneyUnit}
			s_sof101ukrv_ypService.getCustCredit(param, function(provider, response) {
				var credit = Ext.isEmpty(provider[0]['CREDIT'])? 0 : provider[0]['CREDIT'];
				panelSearch.setValue('REMAIN_CREDIT', credit);
				panelResult.setValue('REMAIN_CREDIT', credit);
			});
		}
	});





	//수주일자 입력에 따른 주차 가져오는 로직
	function fnGetCalNo(newValue) {
		param = {
			CAL_DATE	: UniDate.getDbDateStr(newValue)
		}
		s_sof101ukrv_ypService.getCalNo(param, function(provider, response){
			if(!Ext.isEmpty(provider)) {
				var calNo = provider[0].CAL_NO;
				var firstYn = 'N';

				/* if(calNo >= 52 || (calNo == 2 && UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE')).substring(4, 6) == '12')) {
					calNo = 52;
					} */

				if((calNo == 2 || calNo == 1 || calNo == 53) && UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE')).substring(4, 6) == '12') {
					firstYn = 'Y';
				}
//				else if(calNo > 52){//다음해 첫째주
//					calNo = 1;
//					firstYn = 'Y';
//				}
				panelSearch.setValue('CAL_NO'	, calNo);
				panelResult.setValue('CAL_NO'	, calNo);
				panelSearch.setValue('FIRST_YN'	, firstYn);
				panelResult.setValue('FIRST_YN'	, firstYn);
				//날짜 가져오는 로직 호출;
				fnGetCalDate(calNo, '', firstYn);
//				fnGetCalDate(provider[0].CAL_NO);
			}
		});
	}
	//수주일자 입력에 따른 날짜 가져오는 로직
	function fnGetCalDate(newValue, dvryDate, firstYn) {
		if(!Ext.isEmpty(newValue)) {
			if(!Ext.isEmpty(dvryDate)) {
				var calYear = dvryDate.substring(0,4);
			} else {
				var calYear = panelSearch.getValue('ORDER_DATE').getFullYear();
			}
			param = {
				CAL_NO	: newValue ,
				CAL_YEAR: calYear,
				FIRST_YN: firstYn,
				ORDER_DATE: UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE'))
			}
			s_sof101ukrv_ypService.getCalDate(param, function(provider, response){
				if(!Ext.isEmpty(provider)) {
					fnSetValue(provider);
				}
			});
		}
	}
	//만들어진 날짜를 그리드컬럼에 set
	function fnSetValue(provider) {
		if(Ext.isEmpty(provider)) {
			return false;
		}
		gsDvryDate1 = provider[0].CAL_DATE.substring(0, 4) + '-' + provider[0].CAL_DATE.substring(4, 6) + '-' + provider[0].CAL_DATE.substring(6, 8);
		gsDvryDate2 = provider[1].CAL_DATE.substring(0, 4) + '-' + provider[1].CAL_DATE.substring(4, 6) + '-' + provider[1].CAL_DATE.substring(6, 8);
		gsDvryDate3 = provider[2].CAL_DATE.substring(0, 4) + '-' + provider[2].CAL_DATE.substring(4, 6) + '-' + provider[2].CAL_DATE.substring(6, 8);
		gsDvryDate4 = provider[3].CAL_DATE.substring(0, 4) + '-' + provider[3].CAL_DATE.substring(4, 6) + '-' + provider[3].CAL_DATE.substring(6, 8);
		gsDvryDate5 = provider[4].CAL_DATE.substring(0, 4) + '-' + provider[4].CAL_DATE.substring(4, 6) + '-' + provider[4].CAL_DATE.substring(6, 8);
		gsDvryDate6 = provider[5].CAL_DATE.substring(0, 4) + '-' + provider[5].CAL_DATE.substring(4, 6) + '-' + provider[5].CAL_DATE.substring(6, 8);
		gsDvryDate7 = provider[6].CAL_DATE.substring(0, 4) + '-' + provider[6].CAL_DATE.substring(4, 6) + '-' + provider[6].CAL_DATE.substring(6, 8);

		var dvryDate1 = provider[0].CAL_DATE.substring(4, 6) + '월 ' + provider[0].CAL_DATE.substring(6, 8) + '일 (' + getInputDayLabel(provider[0].CAL_DATE) + ')';
		var dvryDate2 = provider[1].CAL_DATE.substring(4, 6) + '월 ' + provider[1].CAL_DATE.substring(6, 8) + '일 (' + getInputDayLabel(provider[1].CAL_DATE) + ')';
		var dvryDate3 = provider[2].CAL_DATE.substring(4, 6) + '월 ' + provider[2].CAL_DATE.substring(6, 8) + '일 (' + getInputDayLabel(provider[2].CAL_DATE) + ')';
		var dvryDate4 = provider[3].CAL_DATE.substring(4, 6) + '월 ' + provider[3].CAL_DATE.substring(6, 8) + '일 (' + getInputDayLabel(provider[3].CAL_DATE) + ')';
		var dvryDate5 = provider[4].CAL_DATE.substring(4, 6) + '월 ' + provider[4].CAL_DATE.substring(6, 8) + '일 (' + getInputDayLabel(provider[4].CAL_DATE) + ')';
		var dvryDate6 = provider[5].CAL_DATE.substring(4, 6) + '월 ' + provider[5].CAL_DATE.substring(6, 8) + '일 (' + getInputDayLabel(provider[5].CAL_DATE) + ')';
		var dvryDate7 = provider[6].CAL_DATE.substring(4, 6) + '월 ' + provider[6].CAL_DATE.substring(6, 8) + '일 (' + getInputDayLabel(provider[6].CAL_DATE) + ')';

		Ext.getCmp('dvryDate1').setText(dvryDate1);
		Ext.getCmp('dvryDate2').setText(dvryDate2);
		Ext.getCmp('dvryDate3').setText(dvryDate3);
		Ext.getCmp('dvryDate4').setText(dvryDate4);
		Ext.getCmp('dvryDate5').setText(dvryDate5);
		Ext.getCmp('dvryDate6').setText(dvryDate6);
		Ext.getCmp('dvryDate7').setText(dvryDate7);
	}
	//스토어 데이터로 그리드 컬럼명 세팅(조회시에는 sof110t에 저장된 dvrydate를 컬럼으로 만들어주면 됨)
	function fnSetValue2(provider) {

			gsDvryDate1 = UniDate.getDbDateStr(provider.get('DVRY_DATE1')).substring(0, 4) + '-' + UniDate.getDbDateStr(provider.get('DVRY_DATE1')).substring(4, 6) + '-' + UniDate.getDbDateStr(provider.get('DVRY_DATE1')).substring(6, 8);
			gsDvryDate2 = UniDate.getDbDateStr(provider.get('DVRY_DATE2')).substring(0, 4) + '-' + UniDate.getDbDateStr(provider.get('DVRY_DATE2')).substring(4, 6) + '-' + UniDate.getDbDateStr(provider.get('DVRY_DATE2')).substring(6, 8);
			gsDvryDate3 = UniDate.getDbDateStr(provider.get('DVRY_DATE3')).substring(0, 4) + '-' + UniDate.getDbDateStr(provider.get('DVRY_DATE3')).substring(4, 6) + '-' + UniDate.getDbDateStr(provider.get('DVRY_DATE3')).substring(6, 8);
			gsDvryDate4 = UniDate.getDbDateStr(provider.get('DVRY_DATE4')).substring(0, 4) + '-' + UniDate.getDbDateStr(provider.get('DVRY_DATE4')).substring(4, 6) + '-' + UniDate.getDbDateStr(provider.get('DVRY_DATE4')).substring(6, 8);
			gsDvryDate5 = UniDate.getDbDateStr(provider.get('DVRY_DATE5')).substring(0, 4) + '-' + UniDate.getDbDateStr(provider.get('DVRY_DATE5')).substring(4, 6) + '-' + UniDate.getDbDateStr(provider.get('DVRY_DATE5')).substring(6, 8);
			gsDvryDate6 = UniDate.getDbDateStr(provider.get('DVRY_DATE6')).substring(0, 4) + '-' + UniDate.getDbDateStr(provider.get('DVRY_DATE6')).substring(4, 6) + '-' + UniDate.getDbDateStr(provider.get('DVRY_DATE6')).substring(6, 8);
			gsDvryDate7 = UniDate.getDbDateStr(provider.get('DVRY_DATE7')).substring(0, 4) + '-' + UniDate.getDbDateStr(provider.get('DVRY_DATE7')).substring(4, 6) + '-' + UniDate.getDbDateStr(provider.get('DVRY_DATE7')).substring(6, 8);

			var dvryDate1 = UniDate.getDbDateStr(provider.get('DVRY_DATE1')).substring(4, 6) + '월 ' + UniDate.getDbDateStr(provider.get('DVRY_DATE1')).substring(6, 8) + '일 (' + getInputDayLabel(UniDate.getDbDateStr(provider.get('DVRY_DATE1'))) + ')';
			var dvryDate2 = UniDate.getDbDateStr(provider.get('DVRY_DATE2')).substring(4, 6) + '월 ' + UniDate.getDbDateStr(provider.get('DVRY_DATE2')).substring(6, 8) + '일 (' + getInputDayLabel(UniDate.getDbDateStr(provider.get('DVRY_DATE2'))) + ')';
			var dvryDate3 = UniDate.getDbDateStr(provider.get('DVRY_DATE3')).substring(4, 6) + '월 ' + UniDate.getDbDateStr(provider.get('DVRY_DATE3')).substring(6, 8) + '일 (' + getInputDayLabel(UniDate.getDbDateStr(provider.get('DVRY_DATE3'))) + ')';
			var dvryDate4 = UniDate.getDbDateStr(provider.get('DVRY_DATE4')).substring(4, 6) + '월 ' + UniDate.getDbDateStr(provider.get('DVRY_DATE4')).substring(6, 8) + '일 (' + getInputDayLabel(UniDate.getDbDateStr(provider.get('DVRY_DATE4'))) + ')';
			var dvryDate5 = UniDate.getDbDateStr(provider.get('DVRY_DATE5')).substring(4, 6) + '월 ' + UniDate.getDbDateStr(provider.get('DVRY_DATE5')).substring(6, 8) + '일 (' + getInputDayLabel(UniDate.getDbDateStr(provider.get('DVRY_DATE5'))) + ')';
			var dvryDate6 = UniDate.getDbDateStr(provider.get('DVRY_DATE6')).substring(4, 6) + '월 ' + UniDate.getDbDateStr(provider.get('DVRY_DATE6')).substring(6, 8) + '일 (' + getInputDayLabel(UniDate.getDbDateStr(provider.get('DVRY_DATE6'))) + ')';
			var dvryDate7 = UniDate.getDbDateStr(provider.get('DVRY_DATE7')).substring(4, 6) + '월 ' + UniDate.getDbDateStr(provider.get('DVRY_DATE7')).substring(6, 8) + '일 (' + getInputDayLabel(UniDate.getDbDateStr(provider.get('DVRY_DATE7'))) + ')';



			Ext.getCmp('dvryDate1').setText(dvryDate1);
			Ext.getCmp('dvryDate2').setText(dvryDate2);
			Ext.getCmp('dvryDate3').setText(dvryDate3);
			Ext.getCmp('dvryDate4').setText(dvryDate4);
			Ext.getCmp('dvryDate5').setText(dvryDate5);
			Ext.getCmp('dvryDate6').setText(dvryDate6);
			Ext.getCmp('dvryDate7').setText(dvryDate7);

	}
	//날짜 입력 받아 요일 구하는 함수
	function getInputDayLabel(date) {
		date		= date.substring(0, 4) + '-' + date.substring(4, 6) + '-' + date.substring(6, 8);
		var week	= new Array('일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일');
		var today	= new Date(date).getDay();
		var todayLabel = week[today];

		return todayLabel;
	}

	//SER_NO 최대값 구하는 합수
	function fnGetMaxSerNo() {
		var serNo1 = detailStore.max('SER_NO1');
		var serNo2 = detailStore.max('SER_NO2');
		var serNo3 = detailStore.max('SER_NO3');
		var serNo4 = detailStore.max('SER_NO4');
		var serNo5 = detailStore.max('SER_NO5');
		var serNo6 = detailStore.max('SER_NO6');
		var serNo7 = detailStore.max('SER_NO7');
		var seq1 = Math.max(serNo1, serNo2, serNo3, serNo4, serNo5, serNo6, serNo7);

		if(!seq1) seq1 = 1;
		else  seq1 += 1;

		return seq1;
	}


	//선납적용 버튼 수행 로직
	function fnPrePayment() {
		records = detailStore.data.items;
		Ext.each(records, function(record,i) {
			if(panelSearch.getValue('HOLYDAY1')) {
				//pantom이 아닌 경우, ISSUE_REQ_Q1이 있으면 수정 안 됨
				if(!record.phantom && record.get('ISSUE_REQ_Q1') > 0) {
					return false;
				} else {
					if(!Ext.isEmpty(record.get('ORDER_Q1')) && !Ext.isEmpty(record.get('PROD_END_DATE1'))) {
						record.set('PROD_END_DATE1'	, UniDate.add(record.get('DVRY_DATE1'), {days: -2}));
					}
					if(!Ext.isEmpty(record.get('ORDER_Q1')) && !Ext.isEmpty(record.get('EXP_ISSUE_DATE1'))) {
						record.set('EXP_ISSUE_DATE1', UniDate.add(record.get('DVRY_DATE1'), {days: -1}));
					}
				}
			}

			if(panelSearch.getValue('HOLYDAY2')) {
				//pantom이 아닌 경우, ISSUE_REQ_Q2이 있으면 수정 안 됨
				if(!record.phantom && record.get('ISSUE_REQ_Q2') > 0) {
					return false;
				} else {
					if(!Ext.isEmpty(record.get('ORDER_Q2')) && !Ext.isEmpty(record.get('PROD_END_DATE2'))) {
						record.set('PROD_END_DATE2'	, UniDate.add(record.get('DVRY_DATE2'), {days: -2}));
					}
					if(!Ext.isEmpty(record.get('ORDER_Q2')) && !Ext.isEmpty(record.get('EXP_ISSUE_DATE2'))) {
						record.set('EXP_ISSUE_DATE2', UniDate.add(record.get('DVRY_DATE2'), {days: -1}));
					}
				}
			}

			if(panelSearch.getValue('HOLYDAY3')) {
				//pantom이 아닌 경우, ISSUE_REQ_Q3이 있으면 수정 안 됨
				if(!record.phantom && record.get('ISSUE_REQ_Q3') > 0) {
					return false;
				} else {
					if(!Ext.isEmpty(record.get('ORDER_Q3')) && !Ext.isEmpty(record.get('PROD_END_DATE3'))) {
						record.set('PROD_END_DATE3'	, UniDate.add(record.get('DVRY_DATE3'), {days: -2}));
					}
					if(!Ext.isEmpty(record.get('ORDER_Q3')) && !Ext.isEmpty(record.get('EXP_ISSUE_DATE3'))) {
						record.set('EXP_ISSUE_DATE3', UniDate.add(record.get('DVRY_DATE3'), {days: -1}));
					}
				}
			}

			if(panelSearch.getValue('HOLYDAY4')) {
				//pantom이 아닌 경우, ISSUE_REQ_Q4이 있으면 수정 안 됨
				if(!record.phantom && record.get('ISSUE_REQ_Q4') > 0) {
					return false;
				} else {
					if(!Ext.isEmpty(record.get('ORDER_Q4')) && !Ext.isEmpty(record.get('PROD_END_DATE4'))) {
						record.set('PROD_END_DATE4'	, UniDate.add(record.get('DVRY_DATE4'), {days: -2}));
					}
					if(!Ext.isEmpty(record.get('ORDER_Q4')) && !Ext.isEmpty(record.get('EXP_ISSUE_DATE4'))) {
						record.set('EXP_ISSUE_DATE4', UniDate.add(record.get('DVRY_DATE4'), {days: -1}));
					}
				}
			}

			if(panelSearch.getValue('HOLYDAY5')) {
				//pantom이 아닌 경우, ISSUE_REQ_Q5이 있으면 수정 안 됨
				if(!record.phantom && record.get('ISSUE_REQ_Q5') > 0) {
					return false;
				} else {
					if(!Ext.isEmpty(record.get('ORDER_Q5')) && !Ext.isEmpty(record.get('PROD_END_DATE5'))) {
						record.set('PROD_END_DATE5'	, UniDate.add(record.get('DVRY_DATE5'), {days: -2}));
					}
					if(!Ext.isEmpty(record.get('ORDER_Q5')) && !Ext.isEmpty(record.get('EXP_ISSUE_DATE5'))) {
						record.set('EXP_ISSUE_DATE5', UniDate.add(record.get('DVRY_DATE5'), {days: -1}));
					}
				}
			}

			if(panelSearch.getValue('HOLYDAY6')) {
				//pantom이 아닌 경우, ISSUE_REQ_Q6이 있으면 수정 안 됨
				if(!record.phantom && record.get('ISSUE_REQ_Q6') > 0) {
					return false;
				} else {
					if(!Ext.isEmpty(record.get('ORDER_Q6')) && !Ext.isEmpty(record.get('PROD_END_DATE6'))) {
						record.set('PROD_END_DATE6'	, UniDate.add(record.get('DVRY_DATE6'), {days: -2}));
					}
					if(!Ext.isEmpty(record.get('ORDER_Q6')) && !Ext.isEmpty(record.get('EXP_ISSUE_DATE6'))) {
						record.set('EXP_ISSUE_DATE6', UniDate.add(record.get('DVRY_DATE6'), {days: -1}));
					}
				}
			}

			if(panelSearch.getValue('HOLYDAY7')) {
				//pantom이 아닌 경우, ISSUE_REQ_Q2이 있으면 수정 안 됨
				if(!record.phantom && record.get('ISSUE_REQ_Q7') > 0) {
					return false;
				} else {
					if(!Ext.isEmpty(record.get('ORDER_Q7')) && !Ext.isEmpty(record.get('PROD_END_DATE7'))) {
						record.set('PROD_END_DATE7'	, UniDate.add(record.get('DVRY_DATE7'), {days: -2}));
					}
					if(!Ext.isEmpty(record.get('ORDER_Q7')) && !Ext.isEmpty(record.get('EXP_ISSUE_DATE7'))) {
						record.set('EXP_ISSUE_DATE7', UniDate.add(record.get('DVRY_DATE7'), {days: -1}));
					}
				}
			}
		});
	}





	/** detailGrid Validation
	 */
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				//단가
				case "ORDER_P" :
					if(newValue <= 0)	{
						rv=Msg.sMB076;
						record.set('ORDER_P',oldValue);
						break
					}

					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName,'<t:message code="unilite.msg.sMSR029" default="단가"/>') )  {
						record.set('ORDER_P',oldValue, fieldName);
						break;
					}
					UniAppManager.app.fnOrderAmtCal(record, "P", newValue, null, 'ORDER_P');
					detailStore.fnOrderAmtSum();
					break;


				case "ORDER_Q1" :
					if(newValue < 0)	{
						rv="0 또는 양수만 입력 가능합니다.";
						record.set('ORDER_Q1',oldValue);
						break
					}

//					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName,'<t:message code="unilite.msg.sMS543" default="수주량"/>') )  {
//						record.set('ORDER_Q1',oldValue, fieldName);
//						break;
//					}

					if(record.get('NEW_YN1') == 'N' && record.get('SER_NO1') == 0){
						record.set('SER_NO1', fnGetMaxSerNo())
					}
					if(newValue != oldValue && !e.record.phantom) {
						record.set('PREV_ORDER_Q1', oldValue);
					}

					var sOrderQ = Unilite.nvl(newValue,0);
					var sIssueQ = Unilite.nvl(record.get('OUTSTOCK_Q1'),0);
					if(sOrderQ < sIssueQ)	{
						rv = Msg.sMS286;
						break;
					}
					var dStockQ = 0;
					var dOrderQ = 0;
					var dProdSaleQ = 0;
					var lTrnsRate = record.get('TRANS_RATE');

					if(Ext.isNumeric(record.get('STOCK_Q1')))	dStockQ = record.get('STOCK_Q1');
					if(Ext.isNumeric(record.get('ORDER_Q1')))	dOrderQ = newValue;

					if(dStockQ > 0) {
						if(dStockQ > dOrderQ) {				 //재고량 > 수주량
							record.set('PROD_SALE_Q1'		, 0);
							record.set('PROD_Q1'			, 0);
							record.set('PROD_END_DATE1'		, '');
							record.set('EXP_ISSUE_DATE1'	, '');

						} else if(dStockQ <= dOrderQ)	{		//재고량 <= 수주량
							dProdQ		= (dOrderQ * lTrnsRate - dStockQ) / lTrnsRate ;
							dProdSaleQ	= (dOrderQ * lTrnsRate - dStockQ)

							record.set('PROD_SALE_Q1'	, dProdSaleQ);
							record.set('PROD_Q1'		, dProdQ);

							if(dProdSaleQ == 0) {
								record.set('PROD_END_DATE1'		, '');
								record.set('EXP_ISSUE_DATE1'	, '');

							} else {
								record.set('PROD_END_DATE1'		, UniDate.add(record.get('DVRY_DATE1'), {days: -1}));
								record.set('EXP_ISSUE_DATE1'	, record.get('DVRY_DATE1'));
							}
						}

					} else if(dStockQ <= 0 )	{
						record.set('PROD_SALE_Q1'	, dOrderQ);
						record.set('PROD_Q1'		, dOrderQ * lTrnsRate);
					}

					UniAppManager.app.fnOrderAmtCal(record, "Q", newValue, null, 'ORDER_Q1');
					detailStore.fnOrderAmtSum();

					if(BsaCodeInfo.gsProdtDtAutoYN == 'Y')  {
						var dProdtQ =Unilite.nvl(record.get('PROD_SALE_Q1'), 0);
						if(dProdtQ > 0) {
							record.set('PROD_END_DATE1'		, UniDate.add(record.get('DVRY_DATE1'), {days: -1}));
							record.set('EXP_ISSUE_DATE1'	, record.get('DVRY_DATE1'));
						}
					}else{
						record.set('PROD_END_DATE1'		, UniDate.add(record.get('DVRY_DATE1'), {days: -1}));
						record.set('EXP_ISSUE_DATE1'	, record.get('DVRY_DATE1'));
					}

					break;


				case "ORDER_Q2" :
					if(newValue < 0)	{
						rv="0 또는 양수만 입력 가능합니다.";
						record.set('ORDER_Q2',oldValue);
						break
					}

//					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName,'<t:message code="unilite.msg.sMS543" default="수주량"/>') )  {
//						record.set('ORDER_Q2',oldValue, fieldName);
//						break;
//					}

					if(record.get('NEW_YN2') == 'N' && record.get('SER_NO2') == 0){
						record.set('SER_NO2', fnGetMaxSerNo())
					}
					if(newValue != oldValue && !e.record.phantom) {
						record.set('PREV_ORDER_Q2', oldValue);
					}

					var sOrderQ = Unilite.nvl(newValue,0);
					var sIssueQ = Unilite.nvl(record.get('OUTSTOCK_Q2'),0);
					if(sOrderQ < sIssueQ)	{
						rv = Msg.sMS286;
						break;
					}
					var dStockQ = 0;
					var dOrderQ = 0;
					var dProdSaleQ = 0;
					var lTrnsRate = record.get('TRANS_RATE');

					if(Ext.isNumeric(record.get('STOCK_Q2')))	dStockQ = record.get('STOCK_Q2');
					if(Ext.isNumeric(record.get('ORDER_Q2')))	dOrderQ = newValue;

					if(dStockQ > 0) {
						if(dStockQ > dOrderQ) {				 //재고량 > 수주량
							record.set('PROD_SALE_Q2'		, 0);
							record.set('PROD_Q2'			, 0);
							record.set('PROD_END_DATE2'		, '');
							record.set('EXP_ISSUE_DATE2'	, '');

						} else if(dStockQ <= dOrderQ)	{		//재고량 <= 수주량
							dProdQ		= (dOrderQ * lTrnsRate - dStockQ) / lTrnsRate ;
							dProdSaleQ	= (dOrderQ * lTrnsRate - dStockQ)

							record.set('PROD_SALE_Q2'	, dProdSaleQ);
							record.set('PROD_Q2'		, dProdQ);

							if(dProdSaleQ == 0) {
								record.set('PROD_END_DATE2'		, '');
								record.set('EXP_ISSUE_DATE2'	, '');

							} else {
								record.set('PROD_END_DATE2'		, UniDate.add(record.get('DVRY_DATE2'), {days: -1}));
								record.set('EXP_ISSUE_DATE2'	, record.get('DVRY_DATE2'));
							}
						}

					} else if(dStockQ <= 0 )	{
						record.set('PROD_SALE_Q2'	, dOrderQ);
						record.set('PROD_Q2'		, dOrderQ * lTrnsRate);
					}

					UniAppManager.app.fnOrderAmtCal(record, "Q", newValue, null, 'ORDER_Q2');
					detailStore.fnOrderAmtSum();

					if(BsaCodeInfo.gsProdtDtAutoYN == 'Y')  {
						var dProdtQ =Unilite.nvl(record.get('PROD_SALE_Q2'), 0);
						if(dProdtQ > 0) {
							record.set('PROD_END_DATE2'		, UniDate.add(record.get('DVRY_DATE2'), {days: -1}));
							record.set('EXP_ISSUE_DATE2'	, record.get('DVRY_DATE2'));
						}
					}else{
						record.set('PROD_END_DATE2'		, UniDate.add(record.get('DVRY_DATE2'), {days: -1}));
						record.set('EXP_ISSUE_DATE2'	, record.get('DVRY_DATE2'));
					}

					break;


				case "ORDER_Q3" :
					if(newValue < 0)   {
						rv="0 또는 양수만 입력 가능합니다.";
						record.set('ORDER_Q3',oldValue);
						break
					}

//					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName,'<t:message code="unilite.msg.sMS543" default="수주량"/>') )  {
//						record.set('ORDER_Q3',oldValue, fieldName);
//						break;
//					}

					if(record.get('NEW_YN3') == 'N' && record.get('SER_NO3') == 0){
						record.set('SER_NO3', fnGetMaxSerNo())
					}
					if(newValue != oldValue && !e.record.phantom) {
						record.set('PREV_ORDER_Q3', oldValue);
					}

					var sOrderQ = Unilite.nvl(newValue,0);
					var sIssueQ = Unilite.nvl(record.get('OUTSTOCK_Q3'),0);
					if(sOrderQ < sIssueQ)	{
						rv = Msg.sMS286;
						break;
					}
					var dStockQ = 0;
					var dOrderQ = 0;
					var dProdSaleQ = 0;
					var lTrnsRate = record.get('TRANS_RATE');

					if(Ext.isNumeric(record.get('STOCK_Q3')))	dStockQ = record.get('STOCK_Q3');
					if(Ext.isNumeric(record.get('ORDER_Q3')))	dOrderQ = newValue;

					if(dStockQ > 0) {
						if(dStockQ > dOrderQ) {				 //재고량 > 수주량
							record.set('PROD_SALE_Q3'		, 0);
							record.set('PROD_Q3'			, 0);
							record.set('PROD_END_DATE3'		, '');
							record.set('EXP_ISSUE_DATE3'	, '');

						} else if(dStockQ <= dOrderQ)	{		//재고량 <= 수주량
							dProdQ		= (dOrderQ * lTrnsRate - dStockQ) / lTrnsRate ;
							dProdSaleQ	= (dOrderQ * lTrnsRate - dStockQ)

							record.set('PROD_SALE_Q3'	, dProdSaleQ);
							record.set('PROD_Q3'		, dProdQ);

							if(dProdSaleQ == 0) {
								record.set('PROD_END_DATE3'		, '');
								record.set('EXP_ISSUE_DATE3'	, '');

							} else {
								record.set('PROD_END_DATE3'		, UniDate.add(record.get('DVRY_DATE3'), {days: -1}));
								record.set('EXP_ISSUE_DATE3'	, record.get('DVRY_DATE3'));
							}
						}

					} else if(dStockQ <= 0 )	{
						record.set('PROD_SALE_Q3'	, dOrderQ);
						record.set('PROD_Q3'		, dOrderQ * lTrnsRate);
					}

					UniAppManager.app.fnOrderAmtCal(record, "Q", newValue, null, 'ORDER_Q3');
					detailStore.fnOrderAmtSum();

					if(BsaCodeInfo.gsProdtDtAutoYN == 'Y')  {
						var dProdtQ =Unilite.nvl(record.get('PROD_SALE_Q3'), 0);
						if(dProdtQ > 0) {
							record.set('PROD_END_DATE3'		, UniDate.add(record.get('DVRY_DATE3'), {days: -1}));
							record.set('EXP_ISSUE_DATE3'	, record.get('DVRY_DATE3'));
						}
					}else{
						record.set('PROD_END_DATE3'		, UniDate.add(record.get('DVRY_DATE3'), {days: -1}));
						record.set('EXP_ISSUE_DATE3'	, record.get('DVRY_DATE3'));
					}

					break;


				case "ORDER_Q4" :
					if(newValue < 0)   {
						rv="0 또는 양수만 입력 가능합니다.";
						record.set('ORDER_Q4',oldValue);
						break
					}

//					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName,'<t:message code="unilite.msg.sMS543" default="수주량"/>') )  {
//						record.set('ORDER_Q4',oldValue, fieldName);
//						break;
//					}

					if(record.get('NEW_YN4') == 'N' && record.get('SER_NO4') == 0){
						record.set('SER_NO4', fnGetMaxSerNo())
					}
					if(newValue != oldValue && !e.record.phantom) {
						record.set('PREV_ORDER_Q4', oldValue);
					}

					var sOrderQ = Unilite.nvl(newValue,0);
					var sIssueQ = Unilite.nvl(record.get('OUTSTOCK_Q4'),0);
					if(sOrderQ < sIssueQ)	{
						rv = Msg.sMS286;
						break;
					}
					var dStockQ = 0;
					var dOrderQ = 0;
					var dProdSaleQ = 0;
					var lTrnsRate = record.get('TRANS_RATE');

					if(Ext.isNumeric(record.get('STOCK_Q4')))	dStockQ = record.get('STOCK_Q4');
					if(Ext.isNumeric(record.get('ORDER_Q4')))	dOrderQ = newValue;

					if(dStockQ > 0) {
						if(dStockQ > dOrderQ) {				 //재고량 > 수주량
							record.set('PROD_SALE_Q4'		, 0);
							record.set('PROD_Q4'			, 0);
							record.set('PROD_END_DATE4'		, '');
							record.set('EXP_ISSUE_DATE4'	, '');

						} else if(dStockQ <= dOrderQ)	{		//재고량 <= 수주량
							dProdQ		= (dOrderQ * lTrnsRate - dStockQ) / lTrnsRate ;
							dProdSaleQ	= (dOrderQ * lTrnsRate - dStockQ)

							record.set('PROD_SALE_Q4'	, dProdSaleQ);
							record.set('PROD_Q4'		, dProdQ);

							if(dProdSaleQ == 0) {
								record.set('PROD_END_DATE4'		, '');
								record.set('EXP_ISSUE_DATE4'	, '');

							} else {
								record.set('PROD_END_DATE4'		, UniDate.add(record.get('DVRY_DATE4'), {days: -1}));
								record.set('EXP_ISSUE_DATE4'	, record.get('DVRY_DATE4'));
							}
						}

					} else if(dStockQ <= 0 )	{
						record.set('PROD_SALE_Q4'	, dOrderQ);
						record.set('PROD_Q4'		, dOrderQ * lTrnsRate);
					}

					UniAppManager.app.fnOrderAmtCal(record, "Q", newValue, null, 'ORDER_Q4');
					detailStore.fnOrderAmtSum();

					if(BsaCodeInfo.gsProdtDtAutoYN == 'Y')  {
						var dProdtQ =Unilite.nvl(record.get('PROD_SALE_Q4'), 0);
						if(dProdtQ > 0) {
							record.set('PROD_END_DATE4'		, UniDate.add(record.get('DVRY_DATE4'), {days: -1}));
							record.set('EXP_ISSUE_DATE4'	, record.get('DVRY_DATE4'));
						}
					}else{
						record.set('PROD_END_DATE4'		, UniDate.add(record.get('DVRY_DATE4'), {days: -1}));
						record.set('EXP_ISSUE_DATE4'	, record.get('DVRY_DATE4'));
					}

					break;


				case "ORDER_Q5" :
					if(newValue < 0)   {
						rv="0 또는 양수만 입력 가능합니다.";
						record.set('ORDER_Q5',oldValue);
						break
					}

//					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName,'<t:message code="unilite.msg.sMS543" default="수주량"/>') )  {
//						record.set('ORDER_Q5',oldValue, fieldName);
//						break;
//					}

					if(record.get('NEW_YN5') == 'N' && record.get('SER_NO5') == 0){
						record.set('SER_NO5', fnGetMaxSerNo())
					}
					if(newValue != oldValue && !e.record.phantom) {
						record.set('PREV_ORDER_Q5', oldValue);
					}

					var sOrderQ = Unilite.nvl(newValue,0);
					var sIssueQ = Unilite.nvl(record.get('OUTSTOCK_Q5'),0);
					if(sOrderQ < sIssueQ)	{
						rv = Msg.sMS286;
						break;
					}
					var dStockQ = 0;
					var dOrderQ = 0;
					var dProdSaleQ = 0;
					var lTrnsRate = record.get('TRANS_RATE');

					if(Ext.isNumeric(record.get('STOCK_Q5')))	dStockQ = record.get('STOCK_Q5');
					if(Ext.isNumeric(record.get('ORDER_Q5')))	dOrderQ = newValue;

					if(dStockQ > 0) {
						if(dStockQ > dOrderQ) {				 //재고량 > 수주량
							record.set('PROD_SALE_Q5'		, 0);
							record.set('PROD_Q5'			, 0);
							record.set('PROD_END_DATE5'		, '');
							record.set('EXP_ISSUE_DATE5'	, '');

						} else if(dStockQ <= dOrderQ)	{		//재고량 <= 수주량
							dProdQ		= (dOrderQ * lTrnsRate - dStockQ) / lTrnsRate ;
							dProdSaleQ	= (dOrderQ * lTrnsRate - dStockQ)

							record.set('PROD_SALE_Q5'	, dProdSaleQ);
							record.set('PROD_Q5'		, dProdQ);

							if(dProdSaleQ == 0) {
								record.set('PROD_END_DATE5'		, '');
								record.set('EXP_ISSUE_DATE5'	, '');

							} else {
								record.set('PROD_END_DATE5'		, UniDate.add(record.get('DVRY_DATE5'), {days: -1}));
								record.set('EXP_ISSUE_DATE5'	, record.get('DVRY_DATE5'));
							}
						}

					} else if(dStockQ <= 0 )	{
						record.set('PROD_SALE_Q5'	, dOrderQ);
						record.set('PROD_Q5'		, dOrderQ * lTrnsRate);
					}

					UniAppManager.app.fnOrderAmtCal(record, "Q", newValue, null, 'ORDER_Q5');
					detailStore.fnOrderAmtSum();

					if(BsaCodeInfo.gsProdtDtAutoYN == 'Y')  {
						var dProdtQ =Unilite.nvl(record.get('PROD_SALE_Q5'), 0);
						if(dProdtQ > 0) {
							record.set('PROD_END_DATE5'		, UniDate.add(record.get('DVRY_DATE5'), {days: -1}));
							record.set('EXP_ISSUE_DATE5'	, record.get('DVRY_DATE5'));
						}
					}else{
						record.set('PROD_END_DATE5'		, UniDate.add(record.get('DVRY_DATE5'), {days: -1}));
						record.set('EXP_ISSUE_DATE5'	, record.get('DVRY_DATE5'));
					}

					break;


				case "ORDER_Q6" :
					if(newValue < 0)   {
						rv="0 또는 양수만 입력 가능합니다.";
						record.set('ORDER_Q6',oldValue);
						break
					}

//					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName,'<t:message code="unilite.msg.sMS543" default="수주량"/>') )  {
//						record.set('ORDER_Q6',oldValue, fieldName);
//						break;
//					}

					if(record.get('NEW_YN6') == 'N' && record.get('SER_NO6') == 0){
						record.set('SER_NO6', fnGetMaxSerNo())
					}
					if(newValue != oldValue && !e.record.phantom) {
						record.set('PREV_ORDER_Q6', oldValue);
					}

					var sOrderQ = Unilite.nvl(newValue,0);
					var sIssueQ = Unilite.nvl(record.get('OUTSTOCK_Q6'),0);
					if(sOrderQ < sIssueQ)	{
						rv = Msg.sMS286;
						break;
					}
					var dStockQ = 0;
					var dOrderQ = 0;
					var dProdSaleQ = 0;
					var lTrnsRate = record.get('TRANS_RATE');

					if(Ext.isNumeric(record.get('STOCK_Q6')))	dStockQ = record.get('STOCK_Q6');
					if(Ext.isNumeric(record.get('ORDER_Q6')))	dOrderQ = newValue;

					if(dStockQ > 0) {
						if(dStockQ > dOrderQ) {				 //재고량 > 수주량
							record.set('PROD_SALE_Q6'		, 0);
							record.set('PROD_Q6'			, 0);
							record.set('PROD_END_DATE6'		, '');
							record.set('EXP_ISSUE_DATE6'	, '');

						} else if(dStockQ <= dOrderQ)	{		//재고량 <= 수주량
							dProdQ		= (dOrderQ * lTrnsRate - dStockQ) / lTrnsRate ;
							dProdSaleQ	= (dOrderQ * lTrnsRate - dStockQ)

							record.set('PROD_SALE_Q6'	, dProdSaleQ);
							record.set('PROD_Q6'		, dProdQ);

							if(dProdSaleQ == 0) {
								record.set('PROD_END_DATE6'		, '');
								record.set('EXP_ISSUE_DATE6'	, '');

							} else {
								record.set('PROD_END_DATE6'		, UniDate.add(record.get('DVRY_DATE6'), {days: -1}));
								record.set('EXP_ISSUE_DATE6'	, record.get('DVRY_DATE6'));
							}
						}

					} else if(dStockQ <= 0 )	{
						record.set('PROD_SALE_Q6'	, dOrderQ);
						record.set('PROD_Q6'		, dOrderQ * lTrnsRate);
					}

					UniAppManager.app.fnOrderAmtCal(record, "Q", newValue, null, 'ORDER_Q6');
					detailStore.fnOrderAmtSum();

					if(BsaCodeInfo.gsProdtDtAutoYN == 'Y')  {
						var dProdtQ =Unilite.nvl(record.get('PROD_SALE_Q6'), 0);
						if(dProdtQ > 0) {
							record.set('PROD_END_DATE6'		, UniDate.add(record.get('DVRY_DATE6'), {days: -1}));
							record.set('EXP_ISSUE_DATE6'	, record.get('DVRY_DATE6'));
						}
					}else{
						record.set('PROD_END_DATE6'		, UniDate.add(record.get('DVRY_DATE6'), {days: -1}));
						record.set('EXP_ISSUE_DATE6'	, record.get('DVRY_DATE6'));
					}

					break;


				case "ORDER_Q7" :
					if(newValue < 0)   {
						rv="0 또는 양수만 입력 가능합니다.";
						record.set('ORDER_Q7',oldValue);
						break
					}

//					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName,'<t:message code="unilite.msg.sMS543" default="수주량"/>') )  {
//						record.set('ORDER_Q7',oldValue, fieldName);
//						break;
//					}

					if(record.get('NEW_YN7') == 'N' && record.get('SER_NO7') == 0){
						record.set('SER_NO7', fnGetMaxSerNo())
					}
					if(newValue != oldValue && !e.record.phantom) {
						record.set('PREV_ORDER_Q7', oldValue);
					}

					var sOrderQ = Unilite.nvl(newValue,0);
					var sIssueQ = Unilite.nvl(record.get('OUTSTOCK_Q7'),0);
					if(sOrderQ < sIssueQ)	{
						rv = Msg.sMS286;
						break;
					}
					var dStockQ = 0;
					var dOrderQ = 0;
					var dProdSaleQ = 0;
					var lTrnsRate = record.get('TRANS_RATE');

					if(Ext.isNumeric(record.get('STOCK_Q7')))	dStockQ = record.get('STOCK_Q7');
					if(Ext.isNumeric(record.get('ORDER_Q7')))	dOrderQ = newValue;

					if(dStockQ > 0) {
						if(dStockQ > dOrderQ) {				 //재고량 > 수주량
							record.set('PROD_SALE_Q7'		, 0);
							record.set('PROD_Q7'			, 0);
							record.set('PROD_END_DATE7'		, '');
							record.set('EXP_ISSUE_DATE7'	, '');

						} else if(dStockQ <= dOrderQ)	{		//재고량 <= 수주량
							dProdQ		= (dOrderQ * lTrnsRate - dStockQ) / lTrnsRate ;
							dProdSaleQ	= (dOrderQ * lTrnsRate - dStockQ)

							record.set('PROD_SALE_Q7'	, dProdSaleQ);
							record.set('PROD_Q7'		, dProdQ);

							if(dProdSaleQ == 0) {
								record.set('PROD_END_DATE7'		, '');
								record.set('EXP_ISSUE_DATE7'	, '');

							} else {
								record.set('PROD_END_DATE7'		, UniDate.add(record.get('DVRY_DATE7'), {days: -1}));
								record.set('EXP_ISSUE_DATE7'	, record.get('DVRY_DATE7'));
							}
						}

					} else if(dStockQ <= 0 )	{
						record.set('PROD_SALE_Q7'	, dOrderQ);
						record.set('PROD_Q7'		, dOrderQ * lTrnsRate);
					}

					UniAppManager.app.fnOrderAmtCal(record, "Q", newValue, null, 'ORDER_Q7');
					detailStore.fnOrderAmtSum();

					if(BsaCodeInfo.gsProdtDtAutoYN == 'Y')  {
						var dProdtQ =Unilite.nvl(record.get('PROD_SALE_Q7'), 0);
						if(dProdtQ > 0) {
							record.set('PROD_END_DATE7'		, UniDate.add(record.get('DVRY_DATE7'), {days: -1}));
							record.set('EXP_ISSUE_DATE7'	, record.get('DVRY_DATE7'));
						}
					}else{
						record.set('PROD_END_DATE7'		, UniDate.add(record.get('DVRY_DATE7'), {days: -1}));
						record.set('EXP_ISSUE_DATE7'	, record.get('DVRY_DATE7'));
					}

					break;


				case "PROD_END_DATE1" :
					if( Ext.isEmpty(newValue) ) {
						record.set('PROD_END_DATE1', oldValue);
						break;
					}

//					if(newValue < panelSearch.getValue('ORDER_DATE'))	{
//						rv = Msg.sMS217;
//						record.set('PROD_END_DATE1', oldValue);
//						break;
//					}

					if(newValue > record.get('DVRY_DATE1'))  {
						rv = Msg.sMS218;
						record.set('PROD_END_DATE1', oldValue);
						break;
					}
					break;


				case "PROD_END_DATE2" :
					if( Ext.isEmpty(newValue) ) {
						record.set('PROD_END_DATE2', oldValue);
						break;
					}

//					if(newValue < panelSearch.getValue('ORDER_DATE'))	{
//						rv = Msg.sMS217;
//						record.set('PROD_END_DATE2', oldValue);
//						break;
//					}

					if(newValue > record.get('DVRY_DATE2'))  {
						rv = Msg.sMS218;
						record.set('PROD_END_DATE2', oldValue);
						break;
					}
					break;


				case "PROD_END_DATE3" :
					if( Ext.isEmpty(newValue) ) {
						record.set('PROD_END_DATE3', oldValue);
						break;
					}

//					if(newValue < panelSearch.getValue('ORDER_DATE'))	{
//						rv = Msg.sMS217;
//						record.set('PROD_END_DATE3', oldValue);
//						break;
//					}

					if(newValue > record.get('DVRY_DATE3'))  {
						rv = Msg.sMS218;
						record.set('PROD_END_DATE3', oldValue);
						break;
					}
					break;


				case "PROD_END_DATE4" :
					if( Ext.isEmpty(newValue) ) {
						record.set('PROD_END_DATE4', oldValue);
						break;
					}

//					if(newValue < panelSearch.getValue('ORDER_DATE'))	{
//						rv = Msg.sMS217;
//						record.set('PROD_END_DATE4', oldValue);
//						break;
//					}

					if(newValue > record.get('DVRY_DATE4'))  {
						rv = Msg.sMS218;
						record.set('PROD_END_DATE4', oldValue);
						break;
					}
					break;


				case "PROD_END_DATE5" :
					if( Ext.isEmpty(newValue) ) {
						record.set('PROD_END_DATE5', oldValue);
						break;
					}

//					if(newValue < panelSearch.getValue('ORDER_DATE'))	{
//						rv = Msg.sMS217;
//						record.set('PROD_END_DATE5', oldValue);
//						break;
//					}

					if(newValue > record.get('DVRY_DATE5'))  {
						rv = Msg.sMS218;
						record.set('PROD_END_DATE5', oldValue);
						break;
					}
					break;


				case "PROD_END_DATE6" :
					if( Ext.isEmpty(newValue) ) {
						record.set('PROD_END_DATE6', oldValue);
						break;
					}

//					if(newValue < panelSearch.getValue('ORDER_DATE'))	{
//						rv = Msg.sMS217;
//						record.set('PROD_END_DATE6', oldValue);
//						break;
//					}

					if(newValue > record.get('DVRY_DATE6'))  {
						rv = Msg.sMS218;
						record.set('PROD_END_DATE6', oldValue);
						break;
					}
					break;


				case "PROD_END_DATE7" :
					if( Ext.isEmpty(newValue) ) {
						record.set('PROD_END_DATE7', oldValue);
						break;
					}

//					if(newValue < panelSearch.getValue('ORDER_DATE'))	{
//						rv = Msg.sMS217;
//						record.set('PROD_END_DATE7', oldValue);
//						break;
//					}

					if(newValue > record.get('DVRY_DATE7'))  {
						rv = Msg.sMS218;
						record.set('PROD_END_DATE7', oldValue);
						break;
					}
					break;


				case "EXP_ISSUE_DATE1" :
					if( Ext.isEmpty(newValue) ) {
						record.set('EXP_ISSUE_DATE1', oldValue);
						break;
					}

//					if(newValue < panelSearch.getValue('ORDER_DATE'))	{
//						rv = Msg.sMS217;
//						record.set('EXP_ISSUE_DATE1', oldValue);
//						break;
//					}

					if(newValue > record.get('DVRY_DATE1'))  {
						rv = Msg.sMS218;
						record.set('EXP_ISSUE_DATE1', oldValue);
						break;
					}
					record.set('PROD_END_DATE1'	, UniDate.add(newValue, {days: -1}));
					break;


				case "EXP_ISSUE_DATE2" :
					if( Ext.isEmpty(newValue) ) {
						record.set('EXP_ISSUE_DATE2', oldValue);
						break;
					}

//					if(newValue < panelSearch.getValue('ORDER_DATE'))	{
//						rv = Msg.sMS217;
//						record.set('EXP_ISSUE_DATE2', oldValue);
//						break;
//					}

					if(newValue > record.get('DVRY_DATE2'))  {
						rv = Msg.sMS218;
						record.set('EXP_ISSUE_DATE2', oldValue);
						break;
					}
					record.set('PROD_END_DATE2'	, UniDate.add(newValue, {days: -1}));
					break;


				case "EXP_ISSUE_DATE3" :
					if( Ext.isEmpty(newValue) ) {
						record.set('EXP_ISSUE_DATE3', oldValue);
						break;
					}

//					if(newValue < panelSearch.getValue('ORDER_DATE'))	{
//						rv = Msg.sMS217;
//						record.set('EXP_ISSUE_DATE3', oldValue);
//						break;
//					}

					if(newValue > record.get('DVRY_DATE3'))  {
						rv = Msg.sMS218;
						record.set('EXP_ISSUE_DATE3', oldValue);
						break;
					}
					record.set('PROD_END_DATE3'	, UniDate.add(newValue, {days: -1}));
					break;


				case "EXP_ISSUE_DATE4" :
					if( Ext.isEmpty(newValue) ) {
						record.set('EXP_ISSUE_DATE4', oldValue);
						break;
					}

//					if(newValue < panelSearch.getValue('ORDER_DATE'))	{
//						rv = Msg.sMS217;
//						record.set('EXP_ISSUE_DATE4', oldValue);
//						break;
//					}

					if(newValue > record.get('DVRY_DATE4'))  {
						rv = Msg.sMS218;
						record.set('EXP_ISSUE_DATE4', oldValue);
						break;
					}
					record.set('PROD_END_DATE4'	, UniDate.add(newValue, {days: -1}));
					break;


				case "EXP_ISSUE_DATE5" :
					if( Ext.isEmpty(newValue) ) {
						record.set('EXP_ISSUE_DATE5', oldValue);
						break;
					}

//					if(newValue < panelSearch.getValue('ORDER_DATE'))	{
//						rv = Msg.sMS217;
//						record.set('EXP_ISSUE_DATE5', oldValue);
//						break;
//					}

					if(newValue > record.get('DVRY_DATE5'))  {
						rv = Msg.sMS218;
						record.set('EXP_ISSUE_DATE5', oldValue);
						break;
					}
					record.set('PROD_END_DATE5'	, UniDate.add(newValue, {days: -1}));
					break;


				case "EXP_ISSUE_DATE6" :
					if( Ext.isEmpty(newValue) ) {
						record.set('EXP_ISSUE_DATE6', oldValue);
						break;
					}

//					if(newValue < panelSearch.getValue('ORDER_DATE'))	{
//						rv = Msg.sMS217;
//						record.set('EXP_ISSUE_DATE6', oldValue);
//						break;
//					}

					if(newValue > record.get('DVRY_DATE6'))  {
						rv = Msg.sMS218;
						record.set('EXP_ISSUE_DATE6', oldValue);
						break;
					}
					record.set('PROD_END_DATE6'	, UniDate.add(newValue, {days: -1}));
					break;


				case "EXP_ISSUE_DATE7" :
					if( Ext.isEmpty(newValue) ) {
						record.set('EXP_ISSUE_DATE7', oldValue);
						break;
					}

//					if(newValue < panelSearch.getValue('ORDER_DATE'))	{
//						rv = Msg.sMS217;
//						record.set('EXP_ISSUE_DATE7', oldValue);
//						break;
//					}

					if(newValue > record.get('DVRY_DATE7'))  {
						rv = Msg.sMS218;
						record.set('EXP_ISSUE_DATE7', oldValue);
						break;
					}
					record.set('PROD_END_DATE7'	, UniDate.add(newValue, {days: -1}));
					break;
			}
			return rv;
		}
	}); // validator
}
</script>
