<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo501ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo501ukrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001"/>			<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201"/>			<!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M007"/>			<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B038"/>			<!-- 결제조건 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>			<!-- 화폐 -->
	<t:ExtComboStore comboType="AU" comboCode="M301"/>			<!-- 단가형태 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/><!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="M002"/>			<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="Q002"/>			<!-- 품질대상여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>			<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B020"/>			<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B014"/>			<!-- 조달구분 opts='1;2'-->
	<t:ExtComboStore comboType="OU" />							<!-- 창고-->
</t:appConfig>
<script type="text/javascript" >

var SearchInfoWindow;		//조회버튼 누르면 나오는 조회창
var referOtherOrderWindow;	//타발주참조
var MRE100TWindow;			// 구매요청등록 참조
var excelWindow;			// 엑셀참조
var requestRegWindow;		//금형외주가공의뢰참조

var BsaCodeInfo = {
	gsAutoType		: '${gsAutoType}',
	gsOrderPrsn		: '${gsOrderPrsn}',
	gsOrderPrsnYN	: '${gsOrderPrsnYN}',
	gsDefaultMoney	: '${gsDefaultMoney}',
	gsLocalShowYN	: '${gsLocalShowYN}',
	gsMoneyShowYN	: '${gsMoneyShowYN}',
	gsExchgShowYN	: '${gsExchgShowYN}',
	gsApproveYN		: '${gsApproveYN}',
	gsSumTypeLot	: '${gsSumTypeLot}',
	gsTrnsRateEdtYn	: '${gsTrnsRateEdtYn}',
	gsReportGubun	: '${gsReportGubun}',
	gsSiteCode		: '${gsSiteCode}'
};


var CustomCodeInfo = {
	gsUnderCalBase: ''
};
var gsSaveRefFlag = 'N';				//검색후에만 수정 가능하게 조회버튼 활성화..



//var output ='';
//for(var key in BsaCodeInfo){
// output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);


var outDivCode = UserInfo.divCode;
var aa = 0;
function appMain() {

	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y')	{
		isAutoOrderNum = true;
	}

	var isOrderPrsn = true;
	if(BsaCodeInfo.gsApproveYN=='Y') {
		isOrderPrsn = false;
	}

	var sumtypeLot = true;	//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeLot =='Y') {
		sumtypeLot = false;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'mpo501ukrvService.selectList',
			update	: 'mpo501ukrvService.updateDetail',
			create	: 'mpo501ukrvService.insertDetail',
			destroy	: 'mpo501ukrvService.deleteDetail',
			syncAll	: 'mpo501ukrvService.saveAll'
		}
	});



	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Mpo501ukrvModel', {
		fields: [
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'				,type: 'string',child:'WH_CODE'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'			,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'					,type: 'string',allowBlank: isAutoOrderNum},
			{name: 'ORDER_SEQ'			,text: '<t:message code="system.label.purchase.seq" default="순번"/>'						,type: 'int'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'					,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			,type: 'string'},
			{name: 'LOT_NO'				,text: 'LOT NO'			,type: 'string'},
			{name: 'LOT_YN'				,text: 'LOT관리여부'		,type: 'string', comboType:'AU', comboCode:'A020'},
			{name: 'ORDER_UNIT_Q'		,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'					,type: 'uniQty' , allowBlank: false}, //, allowBlank: false
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			,type: 'string', allowBlank: false,comboType:'AU',comboCode:'B013',displayField: 'value'},
			{name: 'UNIT_PRICE_TYPE'	,text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'				,type: 'string',comboType:'AU',comboCode:'M301', allowBlank: false},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'			,type: 'string',comboType:'AU',comboCode:'B004', displayField: 'value'},
			{name: 'ORDER_UNIT_P'		,text: '<t:message code="system.label.purchase.price" default="단가"/>'					,type: 'uniFC' , allowBlank: false}, //, allowBlank: false
			{name: 'ORDER_O'			,text: '<t:message code="system.label.purchase.amount" default="금액"/>'					,type: 'uniFC'},
			{name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			,type: 'uniER'},
			{name: 'ORDER_LOC_P'		,text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'				,type: 'uniUnitPrice'},
			{name: 'ORDER_LOC_O'		,text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'				,type: 'uniPrice'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			,type: 'uniDate', allowBlank: false},
			{name: 'DVRY_TIME'			,text: '<t:message code="system.label.purchase.deliverytime" default="납기시간"/>'			,type: 'string'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>'		,type: 'string',  comboType   : 'OU', allowBlank: false},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'			,type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
//			{name: 'TRNS_RATE'			,text: '<t:message code="Mpo501.label.TRNS_RATE" default="입수"/>'						,type: 'uniQty'/*, decimalPrecision: 4, format:'0,000.0000'*/},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.purchase.inventoryunitqty" default="재고단위량"/>'		,type: 'uniQty'},
			{name: 'PO_REQ_NUM'			,text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'	,type: 'string'},
			{name: 'PO_SER_NO'			,text: '구매요청순번'	 		,type: 'int'},
			{name: 'ORDER_P'			,text: '발주단가(재고)'		,type: 'uniUnitPrice'},
			{name: 'CONTROL_STATUS'		,text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'			,type: 'string',comboType:'AU',comboCode:'M002'},
			{name: 'ORDER_REQ_NUM'		,text: '<t:message code="system.label.purchase.poreserveno" default="발주예정번호"/>'			,type: 'string'},
			{name: 'ORDER_REQ_SEQ'		,text: 'ORDER_REQ_SEQ'			,type: 'int'},
			{name: 'INSTOCK_Q'			,text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				,type: 'uniQty'},
			{name: 'INSPEC_FLAG'		,text: '<t:message code="system.label.purchase.qualityyn" default="품질대상여부"/>'			,type: 'string',comboType:'AU',comboCode:'Q002', allowBlank: false},
			{name: 'REMARK'				,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			,type: 'string'},
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER'	,type: 'string'},
			{name: 'UPDATE_DB_TIME'		,text: 'UPDATE_DB_TIME'	,type: 'string'},
			{name: 'TEMP_FOR_SAVE'		,text: 'TEMP_FOR_SAVE'	,type: 'string'},
			{name: 'SO_NUM'				,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'					,type: 'string'},
			{name: 'SO_SEQ'				,text: '<t:message code="system.label.purchase.soseq" default="수주순번"/>'					,type: 'int'}
		]
	});

	Unilite.defineModel('orderNoMasterModel', {		//조회버튼 누르면 나오는 조회창
		fields: [
			{name: 'CUSTOM_NAME'		, text: '<t:message code="Mpo501.label.CUSTOM_NAME" default="거래처"/>'		, type: 'string'},
			{name: 'ORDER_DATE'			, text: '<t:message code="Mpo501.label.ORDER_DATE" default="발주일"/>'			, type: 'uniDate'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="Mpo501.label.ORDER_TYPE" default="발주유형"/>'		, type: 'string',comboType:'AU',comboCode:'M001'},
			{name: 'ORDER_NUM'			, text: '<t:message code="Mpo501.label.ORDER_NUM" default="발주번호"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="Mpo501.label.CUSTOM_CODE" default="거래처코드"/>'		, type: 'string'},
			{name: 'DEPT_CODE'			, text: '<t:message code="Mpo501.label.DEPT_CODE" default="부서코드"/>'   		, type: 'string'},
			{name: 'DEPT_NAME'			, text: '<t:message code="Mpo501.label.DEPT_NAME" default="부서명"/>'   		, type: 'string'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="Mpo501.label.ORDER_PRSN" default="구매담당"/>'		, type: 'string',comboType:'AU',comboCode:'M201'},
			{name: 'AGREE_STATUS'		, text: '<t:message code="Mpo501.label.AGREE_STATUS" default="승인"/>'		, type: 'string',comboType:'AU',comboCode:'M007'},
			{name: 'AGREE_PRSN'			, text: '<t:message code="Mpo501.label.AGREE_PRSN" default="승인자"/>'			, type: 'string'},
			{name: 'AGREE_PRSN_NAME'	, text: '<t:message code="Mpo501.label.AGREE_PRSN_NAME" default="승인자명"/>'	, type: 'string'},
			{name: 'AGREE_DATE'			, text: '<t:message code="Mpo501.label.AGREE_DATE" default="승인일"/>'			, type: 'uniDate'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="Mpo501.label.MONEY_UNIT" default="화폐"/>'			, type: 'string'},
			{name: 'RECEIPT_TYPE'		, text: '<t:message code="Mpo501.label.RECEIPT_TYPE" default="결제조건"/>'		, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="Mpo501.label.REMARK" default="비고"/>'				, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="Mpo501.label.EXCHG_RATE_O" default="환율"/>'		, type: 'string'},
			{name: 'DRAFT_YN'			, text: '<t:message code="Mpo501.label.DRAFT_YN" default="기안여부"/>'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="Mpo501.label.DIV_CODE" default="사업장"/>'			, type: 'string',comboType:'BOR120'},
			{name: 'PROJECT_NO'			, text: '<t:message code="Mpo501.label.PROJECT_NO" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'COMP_NAME'			, text: '<t:message code="Mpo501.label.COMP_NAME" default="회사명"/>'			, type: 'string'}
		]
	});

	Unilite.defineModel('mpo501ukrvOTHERModel', {	//타발주참조
		fields: [
			{name: 'CUSTOM_NAME'		, text: '<t:message code="Mpo501.label.CUSTOM_NAME" default="거래처"/>'		, type: 'string'},
			{name: 'ORDER_DATE'			, text: '<t:message code="Mpo501.label.ORDER_DATE" default="발주일"/>'			, type: 'uniDate'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="Mpo501.label.ORDER_TYPE" default="발주유형"/>'		, type: 'string',comboType:'AU',comboCode:'M001'},
			{name: 'ORDER_NUM'			, text: '<t:message code="Mpo501.label.ORDER_NUM" default="발주번호"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="Mpo501.label.CUSTOM_CODE" default="거래처코드"/>'		, type: 'string'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="Mpo501.label.ORDER_PRSN" default="구매담당"/>'		, type: 'string',comboType:'AU',comboCode:'M201'},
			{name: 'AGREE_STATUS'		, text: '<t:message code="Mpo501.label.AGREE_STATUS" default="승인"/>'		, type: 'string',comboType:'AU',comboCode:'M007'},
			{name: 'AGREE_PRSN'			, text: '<t:message code="Mpo501.label.AGREE_PRSN" default="승인자"/>'			, type: 'string'},
			{name: 'AGREE_PRSN_NAME'	, text: '<t:message code="Mpo501.label.AGREE_PRSN_NAME" default="승인자명"/>'	, type: 'string'},
			{name: 'AGREE_DATE'			, text: '<t:message code="Mpo501.label.AGREE_DATE" default="승인일"/>'			, type: 'uniDate'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="Mpo501.label.MONEY_UNIT" default="화폐"/>'			, type: 'string'},
			{name: 'RECEIPT_TYPE'		, text: '<t:message code="Mpo501.label.RECEIPT_TYPE" default="결제조건"/>'		, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="Mpo501.label.REMARK" default="비고"/>'				, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="Mpo501.label.EXCHG_RATE_O" default="환율"/>'		, type: 'string'},
			{name: 'DRAFT_YN'			, text: '<t:message code="Mpo501.label.DRAFT_YN" default="기안여부"/>'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="Mpo501.label.DIV_CODE" default="사업장"/>'			, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="Mpo501.label.PROJECT_NO" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'DEPT_CODE'			, text: '<t:message code="Mpo501.label.PROJECT_NO" default="부서코드"/>'		, type: 'string'},
			{name: 'DEPT_NAME'			, text: '<t:message code="Mpo501.label.DEPT_NAME" default="부서명"/>'			, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="Mpo501.label.WH_CODE_G" default="창고"/>'			, type: 'string'}
		]
	});

	Unilite.defineModel('Mre100ukrvModel', {		// 구매요청등록 참조
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="Mpo501.label.DIV_CODE" default="사업장"/>'					,type: 'string'},
			{name: 'PO_REQ_NUM'		,text: '<t:message code="Mpo501.label.PO_REQ_NUM" default="구매요청번호"/>'				,type: 'string',allowBlank: isAutoOrderNum},
			{name: 'PO_SER_NO'		,text: '<t:message code="Mpo501.label.PO_SER_NO_G" default="순번"/>'					,type: 'int', allowBlank: false},
			{name: 'ITEM_CODE'		,text: '<t:message code="Mpo501.label.ITEM_CODE" default="품목코드"/>'					,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'		,text: '<t:message code="Mpo501.label.ITEM_NAME" default="품목명"/>'					,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="Mpo501.label.CUSTOM_CODE" default="거래처코드"/>'				,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="Mpo501.label.CUSTOM_NAME_G" default="거래처명"/>'				,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="Mpo501.label.SPEC" default="규격"/>'							,type: 'string'},
			{name: 'STOCK_UNIT'		,text: '<t:message code="Mpo501.label.STOCK_UNIT" default="재고단위"/>'					,type: 'string'},
			{name: 'R_ORDER_Q'		,text: '<t:message code="Mpo501.label.R_ORDER_Q" default="미입고량"/>'					,type: 'uniQty'},
			{name: 'PAB_STOCK_Q'	,text: '<t:message code="Mpo501.label.PAB_STOCK_Q" default="현재고량"/>'				,type: 'uniQty'},
			{name: 'ORDER_UNIT_Q'	,text: '<t:message code="Mpo501.label.ORDER_UNIT_Q_STOCK" default="발주요청량(재고)"/>'	,type: 'uniQty', allowBlank: false},
			{name: 'ORDER_UNIT'		,text: '<t:message code="Mpo501.label.ORDER_UNIT" default="구매단위"/>'					,type: 'string', allowBlank: false,comboType:'AU',comboCode:'B013',displayField: 'value'},
			{name: 'TRNS_RATE'		,text: '<t:message code="Mpo501.label.TRNS_RATE" default="구매입수"/>'					,type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
//			{name: 'TRNS_RATE'		,text: '<t:message code="Mpo501.label.TRNS_RATE_BUY" default="구매입수"/>'				,type: 'uniQty'},
			{name: 'ORDER_Q'		,text: '<t:message code="Mpo501.label.ORDER_REQ_Q" default="발주요청량"/>'				,type: 'uniQty', allowBlank: false},
			{name: 'REMAIN_Q'		,text: '<t:message code="Mpo501.label.REMAIN_Q" default="발주요청잔량"/>'					,type: 'uniQty'},
			{name: 'MONEY_UNIT'		,text: '<t:message code="Mpo501.label.MONEY_UNIT" default="화폐단위"/>'					,type: 'string',comboType:'AU',comboCode:'B004', displayField: 'value'},
			{name: 'EXCHG_RATE_O'	,text: '<t:message code="Mpo501.label.EXCHG_RATE_O" default="환율"/>'					,type: 'uniER'},
			{name: 'UNIT_PRICE_TYPE',text: '<t:message code="Mpo501.label.UNIT_PRICE_TYPE" default="단가형태"/>'			,type: 'string',comboType:'AU',comboCode:'M301', allowBlank: false},
			{name: 'ORDER_P'		,text: '<t:message code="Mpo501.label.ORDER_P_G" default="단가"/>'					,type: 'uniUnitPrice', allowBlank: false},
			{name: 'ORDER_O'		,text: '<t:message code="Mpo501.label.ORDER_O" default="금액"/>'						,type: 'uniPrice'},
			{name: 'ORDER_LOC_P'	,text: '<t:message code="Mpo501.label.ORDER_LOC_P" default="자사단가"/>'				,type: 'uniUnitPrice'},
			{name: 'ORDER_LOC_O'	,text: '<t:message code="Mpo501.label.ORDER_LOC_O" default="자사금액"/>'				,type: 'uniPrice'},
			{name: 'DVRY_DATE'		,text: '<t:message code="Mpo501.label.DVRY_DATE" default="납기일"/>'					,type: 'uniDate', allowBlank: false},
			{name: 'WH_CODE'		,text: '<t:message code="Mpo501.label.WH_CODE" default="납품창고"/>'					,type: 'string', comboType   : 'OU', allowBlank: false},
			{name: 'SUPPLY_TYPE'	,text: '<t:message code="Mpo501.label.SUPPLY_TYPE" default="조달구분"/>'				,type: 'string',comboType:'AU',comboCode:'B014'},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="Mpo501.label.CUSTOM_NAME" default="거래처"/>'					,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="Mpo501.label.CUSTOM_NAME_G" default="거래처명"/>'				,type: 'string'},
			{name: 'PO_REQ_DATE'	,text: '<t:message code="Mpo501.label.PO_REQ_DATE" default="발주예정일"/>'				,type: 'uniDate'},
			{name: 'INSPEC_FLAG'	,text: '<t:message code="Mpo501.label.INSPEC_FLAG" default="품질대상여부"/>'				,type: 'string',comboType:'AU',comboCode:'Q002', allowBlank: false},
			{name: 'REMARK'			,text: '<t:message code="Mpo501.label.REMARK" default="비고"/>'						,type: 'string'},
			{name: 'ORDER_REQ_NUM'	,text: '<t:message code="Mpo501.label.ORDER_REQ_NUM" default="발주예정번호"/>'			,type: 'string'},
			{name: 'MRP_CONTROL_NUM',text: '<t:message code="Mpo501.label.MRP_CONTROL_NUM" default="MRP번호"/>'			,type: 'string'},
			{name: 'ORDER_YN'		,text: '<t:message code="Mpo501.label.ORDER_YN" default="진행상태"/>'					,type: 'string'},
			{name: 'PURCH_LDTIME'	,text: '<t:message code="Mpo501.label.PURCH_LDTIME" default="구매L"/>T'				,type: 'uniQty'},
			{name: 'WH_CODE'		,text: '<t:message code="Mpo501.label.WH_CODE_G" default="창고"/>'					,type: 'string'},
			{name: 'LOT_YN'			,text: '<t:message code="Mpo501.label.LOT_YN" default="LOT_YN"/>'					,type: 'string'},
			{name: 'COMP_CODE'		,text: '<t:message code="Mpo501.label.COMP_CODE" default="법인코드"/>'					,type: 'string'},
			{name: 'UPDATE_DB_USER'	,text: 'UPDATE_DB_USER'	 ,type: 'string'},
			{name: 'UPDATE_DB_TIME'	,text: 'UPDATE_DB_TIME'	 ,type: 'string'}
		]
	});

	Unilite.Excel.defineModel('excel.mpo501.sheet01', {
		fields: [
			{name: 'ITEM_CODE',		text:'<t:message code="Mpo501.label.ITEM_CODE" default="품목코드"/>',		type: 'string'},
			{name: 'ITEM_NAME',		text:'<t:message code="Mpo501.label.ITEM_NAME" default="품목명"/>',		type: 'string'},
			{name: 'SPEC',  		text:'<t:message code="Mpo501.label.SPEC" default="규격"/>',				type: 'string'},
			{name: 'STOCK_UNIT',	text:'<t:message code="Mpo501.label.STOCK_UNIT" default="재고단위"/>',		type: 'string'},
			{name: 'ORDER_UNIT',	text:'<t:message code="Mpo501.label.ORDER_UNIT" default="구매단위"/>',		type: 'string'},
			{name: 'INSPEC_YN',		text:'<t:message code="Mpo501.label.INSPEC_YN" default="품질검사여부"/>',		type: 'string'},
			{name: 'ORDER_UNIT_P',	text:'<t:message code="Mpo501.label.ORDER_UNIT_P" default="단가"/>',		type: 'uniUnitPrice'},
			{name: 'ORDER_O',		text:'<t:message code="Mpo501.label.ORDER_O" default="금액"/>',			type: 'uniPrice'},
			{name: 'WH_CODE',		text:'<t:message code="Mpo501.label.WH_CODE" default="납품창고"/>',			type: 'string'},
			{name: 'ORDER_UNIT_Q',	text:'<t:message code="Mpo501.label.ORDER_UNIT_Q" default="발주량"/>',		type: 'uniQty'}
		]
	});

	Unilite.defineModel('requestRegModel', {  //금형외주가공의뢰참조
		fields: [
			{name: 'COMP_CODE'			 , text: '법인코드'			 , type: 'string'},
			{name: 'DIV_CODE'			  , text: '사업장'			   , type: 'string'},
			{name: 'ITEM_REQ_NUM'		  , text: '품목의뢰번호'		 , type: 'string'},
			{name: 'ITEM_REQ_SEQ'		  , text: '의뢰순번'			 , type: 'int'},
			{name: 'ITEM_CODE'			 , text: '품목코드'			 , type: 'string'},
			{name: 'ITEM_NAME'			 , text: '품목명'			   , type: 'string'},
			{name: 'SPEC'				  , text: '규격'				 , type: 'string'},
			{name: 'STOCK_UNIT'			, text: '재고단위'			 , type: 'string'},
			{name: 'ITEM_ACCOUNT'		  , text: '품목계정'			 , type: 'string',xtype:'uniCombobox', comboType:'AU', comboCode:'B020'},
			{name: 'GARO_NUM'			  ,text:'가로'				 		,type: 'int'},
			{name: 'GARO_NUM_UNIT'		 ,text:'단위'				 		,type: 'string',editable:false},
			{name: 'SERO_NUM'			  ,text:'세로'				 		,type: 'int'},
			{name: 'SERO_NUM_UNIT'		 ,text:'단위'				 		,type: 'string',editable:false},
			{name: 'THICK_NUM'			 ,text:'두께'				 		,type: 'int'},
			{name: 'THICK_NUM_UNIT'		,text:'단위'				 		,type: 'string',editable:false},
			{name: 'BJ_NUM'				,text:'비중'				 		,type: 'int',editable:false},
			{name: 'QTY'			   ,text:'수량'				  ,type: 'uniQty',editable:false},
			{name: 'PURCHASE_P'			,text:'구매단가'				  ,type: 'uniUnitPrice',editable:false},
			{name: 'TRNS_RATE'			 , text: '입수'				 , type: 'uniQty'},
			{name: 'ORDER_UNIT'			, text: '단위'			 , type: 'string'},
			{name: 'REQ_Q'				 , text: '의뢰량'			   , type: 'uniQty'},
			{name: 'ING_PLAN_Q'			, text: '진행수량'			 , type: 'uniQty'},
			{name: 'REMAIN_Q'			  , text: '잔량'				 , type: 'uniQty'},
			{name: 'DEPT_CODE'			 , text: '부서'				 , type: 'string'},
			{name: 'DEPT_NAME'			 , text: '요청부서명'		   , type: 'string'},
			{name: 'PERSON_NUMB'		   , text: '사원'				 , type: 'string'},
			{name: 'PERSON_NAME'		   , text: '사원명'				 , type: 'string'},
			{name: 'ITEM_REQ_DATE'		 , text: '의뢰일'			   , type: 'uniDate'},
			{name: 'MONEY_UNIT'			, text: '화폐단위'			 , type: 'string'},
			{name: 'EXCHG_RATE_O'		  , text: '환율'				 , type: 'uniER'},
			{name: 'DELIVERY_DATE'		 , text: '납기일'			   , type: 'uniDate'},
			{name: 'USE_REMARK'			, text: '용도'				 , type: 'string'},
			{name: 'GW_DOCU_NUM'		   , text: 'GW문서번호'		   , type: 'string'},
			{name: 'GW_FLAG'			   , text: 'GW기안상태'		   , type: 'string'},
			{name: 'NEXT_YN'			   , text: '진행상태'			 , type: 'string'},
			{name: 'LATEST_CUSTOM_CODE'	, text: '최근거래처코드'		  ,type: 'string'},
			{name: 'LATEST_CUSTOM_NAME'	, text: '최근거래처명'		   ,type: 'string'},
			{name: 'MAKE_GUBUN'			, text: '가공구분'			 , type: 'string',comboType:'AU', comboCode:'WZ21'},
			{name: 'HM_CODE'			   , text: '항목(부품)명'		   ,type: 'string',allowBlank:false},
//			{name: 'HM_CODE'			   , text:'항목(부품)명'		   ,type: 'string', comboType:'AU', comboCode:'WZ22',allowBlank:false},
			{name: 'MOLD_ITEM_NAME'		, text: '금형품명'			,type: 'string'},
			{name: 'CUSTOM_CODE'		   , text: '거래처코드'		   ,type: 'string'},
			{name: 'CUSTOM_NAME'		   , text: '거래처명'			,type: 'string'},
			{name: 'PRICE'			  ,text:'단가'				 		,type: 'uniUnitPrice',editable:false},
			{name: 'AMT'				,text:'금액'				 		,type: 'uniPrice',editable:false}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mpo501ukrvMasterStore1',{
		model: 'Mpo501ukrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,			// 삭제 가능 여부
			allDeletable: true,
			useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
		proxy: directProxy,
		listeners: {
			load: function(store, records, successful, eOpts) {
				this.fnSumOrderO();
			},
			add: function(store, records, index, eOpts) {
				this.fnSumOrderO();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				this.fnSumOrderO();
			},
			remove: function(store, record, index, isMove, eOpts) {
				this.fnSumOrderO();
			}
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("ORDER_NUM", master.ORDER_NUM);
						panelResult.setValue("ORDER_NUM", master.ORDER_NUM);
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						if(directMasterStore1.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}else{
							UniAppManager.app.onQueryButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('mpo501ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		fnSumOrderO: function() {
			console.log("=============Exec fnOrderAmtSum()");
			var results = this.sumBy(function(record, id){
										return true;},
									['ORDER_O', 'ORDER_LOC_O']);

			var sSumOrderO = results.ORDER_O;
			var sSumOrderLocO = results.ORDER_LOC_O;
			masterForm.setValue('SumOrderO',sSumOrderO);
			masterForm.setValue('SumOrderLocO',sSumOrderLocO);
			panelResult.setValue('SumOrderO',sSumOrderO);
			panelResult.setValue('SumOrderLocO',sSumOrderLocO);
		}
	});

	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	//조회버튼 누르면 나오는 조회창
		model: 'orderNoMasterModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'mpo501ukrvService.selectOrderNumMasterList'
			}
		},
		loadStoreRecords : function()	{
			var param= orderNoSearch.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;			   //부서코드
			if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var otherOrderStore = Unilite.createStore('mpo501ukrvOtherOrderStore', {//타발주참조
		model: 'mpo501ukrvOTHERModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			  // prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'mpo501ukrvService.selectOrderNumMasterList2'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful)  {
				   var masterRecords = otherOrderStore.data.filterBy(otherOrderStore.filterNewOnly);
				   var deleteRecords = new Array();

				   if(masterRecords.items.length > 0)   {
					console.log("store.items :", store.items);
					console.log("records", records);

					   Ext.each(records,
							function(item, i)   {
								Ext.each(masterRecords.items, function(record, i)   {
										console.log("record :", record);
									if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM']) // record = masterRecord   item = 참조 Record
										&& (record.data['ORDER_SEQ'] == item.data['SER_NO'])
										)
									{
										deleteRecords.push(item);
									}
								});
							});
					   store.remove(deleteRecords);
				   }
				}
			}
		},
		loadStoreRecords : function()	{
			var param= otherorderSearch.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(otherorderSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var otherOrderStore2 = Unilite.createStore('mpo501ukrvOtherOrderStore2', {	 // 구매계획참조
		model: 'Mre100ukrvModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			 // prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'mpo501ukrvService.selectMre100tList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(successful)  {
				   var masterRecords = directMasterStore1.data.filterBy(otherOrderStore2.filterNewOnly);
				   var deleteRecords = new Array();

				   if(masterRecords.items.length > 0)   {
					console.log("store.items :", store.items);
					console.log("records", records);

					   Ext.each(records,
							function(item, i)   {
								Ext.each(masterRecords.items, function(record, i)   {
										console.log("record :", record);
									if( (record.data['PO_REQ_NUM'] == item.data['PO_REQ_NUM']) // record = masterRecord   item = 참조 Record
										&& (record.data['PO_SER_NO'] == item.data['PO_SER_NO'])
										)
									{
										deleteRecords.push(item);
									}
								});
						});
					   store.remove(deleteRecords);
				   }
				}
			}
		},
		loadStoreRecords : function()   {
			var param= otherorderSearch2.getValues();
			var authoInfo = pgmInfo.authoUser;			  //권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;   //부서코드
			if(authoInfo == "5" && Ext.isEmpty(otherorderSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var requestRegStore = Unilite.createStore('requestRegStore', {   //의뢰서 등록 참조
		model: 'requestRegModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			 // prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'mpo501ukrvService.selectRequestRegList'
			}
		},
		loadStoreRecords : function()   {
			var param= requestRegSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField:'ITEM_REQ_NUM',

		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(successful)  {
				   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
				   var deleteRecords = new Array();

				   if(masterRecords.items.length > 0)   {
					console.log("store.items :", store.items);
					console.log("records", records);

					   Ext.each(records,
							function(item, i)   {
								Ext.each(masterRecords.items, function(record, i)   {
										console.log("record :", record);
									if( (record.data['SO_NUM'] == item.data['ITEM_REQ_NUM']) // record = masterRecord   item = 참조 Record
										&& (record.data['SO_SEQ'] == item.data['ITEM_REQ_SEQ'])
										)
									{
										deleteRecords.push(item);
									}
								});
							});
					   store.remove(deleteRecords);
				   }
				}
			}
		}
	});

	/** 검색조건 (Search Panel)
	 * @type
	 */
	var masterForm = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="Mpo501.label.ORDER_CONDITION" default="발주조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			},
			uniOnChange: function(basicForm, dirty, eOpts) {
				if(directMasterStore1.count() == 0 || Ext.isEmpty(masterForm.getValue('ORDER_NUM'))) return false; //수정일때만(폼만 저장시..)
				var record = directMasterStore1.data.items[0];
				if(!Ext.isEmpty(record)){
//				   record.set('TEMP_FOR_SAVE', dirty.value);  풀면 그리드 단가 수정시 fnSumOrderO 함수 무한으로 돌아 스택에러남...
				}
			}
		},
		items: [{
			title: '<t:message code="Mpo501.label.SEARH_PANEL_TITLE" default="기본정보"/>',
   			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items:[{
				fieldLabel: '<t:message code="Mpo501.label.DIV_CODE" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				holdable: 'hold',
				value: UserInfo.divCode,
				child:'WH_CODE',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},

//			Unilite.popup('DEPT', {
//				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
//				valueFieldName: 'DEPT_CODE',
//				textFieldName: 'DEPT_NAME',
//				allowBlank: false,
//				holdable: 'hold',
//				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							masterForm.setValue('WH_CODE',records[0]["WH_CODE"]);
//							panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
//							panelResult.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
//							panelResult.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
//						},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('DEPT_CODE', '');
//						panelResult.setValue('DEPT_NAME', '');
//					},
//					applyextparam: function(popup){
//						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
//						var deptCode = UserInfo.deptCode;	//부서정보
//						var divCode = '';					//사업장
//						if(authoInfo == "A"){	//자기사업장
//							popup.setExtParam({'DEPT_CODE': ""});
//							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
//						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
//							popup.setExtParam({'DEPT_CODE': ""});
//							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
//						}else if(authoInfo == "5"){		//부서권한
//							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
//							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
//						}
//					}
//				}
//			}),
//			{
//				fieldLabel: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>',
//				name: 'WH_CODE',
//				xtype: 'uniCombobox',
//				store: Ext.data.StoreManager.lookup('whList'),
//				listeners: {
//					change: function(field, newValue, oldValue, eOpts) {
//						panelResult.setValue('WH_CODE', newValue);
//					}
//				}
//			},


			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="Mpo501.label.CUSTOM_NAME" default="거래처"/>',
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				allowBlank: false,
				holdable: 'hold',
//				extParam: {'CUSTOM_TYPE': ['1','2']},
				listeners: {
					onSelected: {
						fn: function(records, type) {
		  							console.log('records : ', records);
		  							CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
		  							masterForm.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
		  							masterForm.setValue('EXCHG_RATE_O', '1');
		  							panelResult.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
		  							panelResult.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));

						if (masterForm.getValue('MONEY_UNIT') == 'KRW')
						{
						  panelResult.setValue('ORDER_TYPE',  '1');
						  masterForm.setValue('ORDER_TYPE',  '1');
						}
						else
						{
						  panelResult.setValue('ORDER_TYPE',  '5');
						  masterForm.setValue('ORDER_TYPE',  '5');
						}


						},
						scope: this
					},
					onClear: function(type)	{
						CustomCodeInfo.gsUnderCalBase = '';
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
					}
				}
			}),
			{
				fieldLabel: '<t:message code="Mpo501.label.ORDER_DATE" default="발주일"/>',
				xtype: 'uniDatefield',
				name: 'ORDER_DATE',
				value: UniDate.get('today'),
				allowBlank:false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="Mpo501.label.ORDER_TYPE2" default="발주형태"/>',
				name:'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M001',
				allowBlank:false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel:'<t:message code="Mpo501.label.AGREE_DATE" default="승인일"/>',
				id:'AGREE_DATE',
				name: 'AGREE_DATE',
				xtype: 'uniDatefield',
//				value: UniDate.get('today'),
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AGREE_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="Mpo501.label.ORDER_PRSN" default="구매담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
//				readOnly: true,
				comboType:'AU',
				comboCode:'M201',
//				allowBlank:false,
				holdable: 'hold',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					/*
					if(eOpts){
						combo.filterByRefCode('refCode4', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode4', newValue, divCode);
					}
					*/
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_PRSN', newValue);
						var param = {"SUB_CODE": newValue};
						mpo501ukrvService.userName(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								masterForm.setValue('AGREE_PRSN', provider['USER_ID']);
								masterForm.setValue('USER_NAME', provider['USER_NAME']);
								panelResult.setValue('AGREE_PRSN', provider['USER_ID']);
								panelResult.setValue('USER_NAME', provider['USER_NAME']);
							}else{
								masterForm.setValue('USER_NAME', '');
								masterForm.setValue('AGREE_PRSN', '');
								panelResult.setValue('AGREE_PRSN', '');
								panelResult.setValue('USER_NAME', '');
							}
						});
					}
				}
			},{
				fieldLabel: '<t:message code="Mpo501.label.AGREE_STATUS2" default="승인여부"/>',
				id:'AGREE_STATUS',
				name:'AGREE_STATUS',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M007',
				readOnly: true,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AGREE_STATUS', newValue);
					}
				}
			}/*,{
				fieldLabel:'<t:message code="Mpo501.label.AGREE_PRSN_ID" default="승인자ID"/>',
				name: 'AGREE_PRSN',
				xtype: 'uniTextfield',
				hidden: true
			}*/,
			Unilite.popup('USER', {
				fieldLabel: '<t:message code="Mpo501.label.AGREE_PRSN" default="승인자"/>',
			valueFieldName:'AGREE_PRSN',
			textFieldName:'AGREE_PRSN_NAME',
				textFieldWidth: 150,
			showValue:false,
				id: 'AGREE_PRSN_NAME',
				allowBlank: isOrderPrsn,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var tfsRecord = directMasterStore1.data.items[0];

							if(!Ext.isEmpty(tfsRecord)){
								tfsRecord.set('TEMP_FOR_SAVE','temp');
								UniAppManager.setToolbarButtons('save', true);
							}
							console.log('records : ', records);
							masterForm.setValue('AGREE_PRSN', records[0]["USER_ID"]);
							panelResult.setValue('AGREE_PRSN', records[0]["USER_ID"]);
							panelResult.setValue('USER_NAME', masterForm.getValue('USER_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						var tfsRecord = directMasterStore1.data.items[0];

						if(!Ext.isEmpty(tfsRecord)){
							tfsRecord.set('TEMP_FOR_SAVE','temp');
							UniAppManager.setToolbarButtons('save', true);
						}
						masterForm.setValue('AGREE_PRSN', '');
						panelResult.setValue('AGREE_PRSN', '');
						panelResult.setValue('USER_NAME', '');
					}
				}

			}),{
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

						param['CUSTOM_CODE']	= masterForm.getValue('CUSTOM_CODE');
						param['CUSTOM_NAME']	= masterForm.getValue('CUSTOM_NAME');
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
			}]
		},{
			title: '<t:message code="Mpo501.label.INPUT_PANEL_TITLE" default="입력조건"/>',
			itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items:[
				{
					fieldLabel:'<t:message code="Mpo501.label.ORDER_NUM" default="발주번호"/>',
					name: 'ORDER_NUM',
					xtype: 'uniTextfield',
					readOnly: isAutoOrderNum,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ORDER_NUM', newValue);
						}
					}
				},{
					fieldLabel:'<t:message code="Mpo501.label.LC_NUM" default="L/C번호"/>',
					name: 'LC_NUM',
					xtype: 'uniTextfield',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('LC_NUM', newValue);
						}
					}
				},
				Unilite.popup('PROJECT',{
					fieldLabel: '<t:message code="Mpo501.label.PROJECT_NO" default="프로젝트번호"/>',
					textFieldWidth: 150,
					validateBlank: true,
					textFieldName:'PROJECT_NO',
					itemId:'project',
					listeners: {
						applyextparam: function(popup){
							popup.setExtParam({'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE')});
						},
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('PROJECT_NO', newValue);
						}
					}
				}),{
					fieldLabel: '<t:message code="Mpo501.label.MONEY_UNIT2" default="화폐"/>',
					name:'MONEY_UNIT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B004',
					displayField: 'value',
					allowBlank:false,
					holdable: 'hold',
					fieldStyle: 'text-align: center;',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('MONEY_UNIT', newValue);
//							UniAppManager.app.fnExchngRateO();
						},
						blur: function( field, The, eOpts )	{

						   UniAppManager.app.fnExchngRateO();
						}
					}
				},{
					fieldLabel: '<t:message code="Mpo501.label.RECEIPT_TYPE2" default="결제방법"/>',
					name:'RECEIPT_TYPE',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B038',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('RECEIPT_TYPE', newValue);
						}
					}
				},{
					fieldLabel:'<t:message code="Mpo501.label.EXCHG_RATE_O" default="환율"/>',
					name: 'EXCHG_RATE_O',
					xtype: 'uniNumberfield',
					allowBlank:false,
					holdable: 'hold',
					decimalPrecision: 4,
					value: 1,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('EXCHG_RATE_O', newValue);
						}
					}
				},{
					fieldLabel:'<t:message code="Mpo501.label.SumOrderO" default="발주총액"/>',
					name: 'SumOrderO',
					xtype: 'uniNumberfield',
					readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('SumOrderO', newValue);
						}
					}
				},{
					fieldLabel:'<t:message code="Mpo501.label.SumOrderLocO" default="자사총액"/>',
					name: 'SumOrderLocO',
					xtype: 'uniNumberfield',
					readOnly: true,
					hidden:true
				},{
					fieldLabel:'<t:message code="Mpo501.label.REMARK" default="비고"/>',
					name: 'REMARK',
					xtype: 'textareafield',
					width: 300,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('REMARK', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="Mpo501.label.COMP_NAME" default="회사명"/>',
					name:'COMP_NAME',
					xtype: 'uniTextfield',
					hidden: true
				},{
					fieldLabel:'t:message code="Mpo501.label.DRAFT_YN" default="기안여부"/>',
					name: 'DRAFT_YN',
					xtype: 'uniTextfield',
					hidden:true
				}]
		}],
		api: {
			load: 'mpo501ukrvService.selectMaster',
			submit: 'mpo501ukrvService.syncForm'
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
						if(Ext.isDefined(item.holdable) )	{
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)	{
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
					if(Ext.isDefined(item.holdable) )	{
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
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
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3/*, tdAttrs: {style: 'border : 1px solid #ced9e7;'}*/},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="Mpo501.label.DIV_CODE" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			holdable: 'hold',
			value: UserInfo.divCode,
			child:'WH_CODE',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					masterForm.setValue('DIV_CODE', newValue);
				}
			}
		},
//		Unilite.popup('DEPT', {
//			fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
//			valueFieldName: 'DEPT_CODE',
//			textFieldName: 'DEPT_NAME',
//			allowBlank: false,
//			holdable: 'hold',
//			listeners: {
//				onSelected: {
//					fn: function(records, type) {
//						masterForm.setValue('WH_CODE',records[0]["WH_CODE"]);
//						panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
//						masterForm.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
//						masterForm.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
//					},
//					scope: this
//				},
//				onClear: function(type)	{
//					masterForm.setValue('DEPT_CODE', '');
//					masterForm.setValue('DEPT_NAME', '');
//				},
//				applyextparam: function(popup){
//					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
//					var deptCode = UserInfo.deptCode;	//부서정보
//					var divCode = '';					//사업장
//					if(authoInfo == "A"){	//자기사업장
//						popup.setExtParam({'DEPT_CODE': ""});
//						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
//					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
//						popup.setExtParam({'DEPT_CODE': ""});
//						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
//					}else if(authoInfo == "5"){		//부서권한
//						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
//						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
//					}
//				}
//			}
//		}),
//		{
//			fieldLabel: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>',
//			name: 'WH_CODE',
//			xtype: 'uniCombobox',
//			store: Ext.data.StoreManager.lookup('whList'),
//			listeners: {
//				change: function(field, newValue, oldValue, eOpts) {
//					masterForm.setValue('WH_CODE', newValue);
//				}
//			}
//		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel: '<t:message code="Mpo501.label.CUSTOM_NAME" default="거래처"/>',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			allowBlank: false,
			holdable: 'hold',
//			extParam: {'CUSTOM_TYPE': ['1','2']},
			listeners: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
						masterForm.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
						//masterForm.setValue('EXCHG_RATE_O', '1');
						UniAppManager.app.fnExchngRateO();
						masterForm.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						masterForm.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));

						if (masterForm.getValue('MONEY_UNIT') == BsaCodeInfo.gsDefaultMoney)
						{
						  panelResult.setValue('ORDER_TYPE',  '1');
						  masterForm.setValue('ORDER_TYPE',  '1');
						}
						else
						{
						  panelResult.setValue('ORDER_TYPE',  '5');
						  masterForm.setValue('ORDER_TYPE',  '5');
						}

					},
					scope: this
				},
				onClear: function(type) {
					CustomCodeInfo.gsUnderCalBase = '';
					masterForm.setValue('CUSTOM_CODE', '');
					masterForm.setValue('CUSTOM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				}
			}
		}),{
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

					param['CUSTOM_CODE']	= masterForm.getValue('CUSTOM_CODE');
					param['CUSTOM_NAME']	= masterForm.getValue('CUSTOM_NAME');
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
		}/*,{
			xtype: 'component'
		}*/,{
			fieldLabel: '<t:message code="Mpo501.label.ORDER_DATE" default="발주일"/>',
			xtype: 'uniDatefield',
			name: 'ORDER_DATE',
			value: UniDate.get('today'),
			allowBlank:false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('ORDER_DATE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="Mpo501.label.ORDER_TYPE2" default="발주형태"/>',
			name:'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M001',
			allowBlank:false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('ORDER_TYPE', newValue);
				}
			}
		},{
			fieldLabel:'<t:message code="Mpo501.label.AGREE_DATE" default="승인일"/>',
			id:'AGREE_DATEr',
			name: 'AGREE_DATE',
			xtype: 'uniDatefield',
//			value: UniDate.get('today'),
			readOnly:true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('AGREE_DATE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="Mpo501.label.ORDER_PRSN" default="구매담당"/>',
			name:'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M201',
//			readOnly: true,
//			allowBlank:false,
			holdable: 'hold',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				/*
				if(eOpts){
					combo.filterByRefCode('refCode4', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode4', newValue, divCode);
				}
				*/
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('ORDER_PRSN', newValue);
					var param = {"SUB_CODE": newValue};
					mpo501ukrvService.userName(param, function(provider, response)  {
						if(!Ext.isEmpty(provider)){
							masterForm.setValue('AGREE_PRSN', provider['USER_ID']);
							masterForm.setValue('USER_NAME', provider['USER_NAME']);
							panelResult.setValue('AGREE_PRSN', provider['USER_ID']);
							panelResult.setValue('USER_NAME', provider['USER_NAME']);
						}else{
							masterForm.setValue('USER_NAME', '');
							masterForm.setValue('AGREE_PRSN', '');
							panelResult.setValue('AGREE_PRSN', '');
							panelResult.setValue('USER_NAME', '');
						}
					});
				}
			}
		},{
			fieldLabel: '<t:message code="Mpo501.label.AGREE_STATUS2" default="승인여부"/>',
			id:'AGREE_STATUSr',
			name:'AGREE_STATUS',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M007',
			readOnly: true,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('AGREE_STATUS', newValue);
				}
			}
		},
		Unilite.popup('USER', {
			fieldLabel: '<t:message code="Mpo501.label.AGREE_PRSN" default="승인자"/>',
			valueFieldName:'AGREE_PRSN',
			textFieldName:'AGREE_PRSN_NAME',
			textFieldWidth: 150,
			showValue:false,
			id: 'AGREE_PRSN_NAMEr',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						var tfsRecord = directMasterStore1.data.items[0];

						if(!Ext.isEmpty(tfsRecord)){
							tfsRecord.set('TEMP_FOR_SAVE','temp');
							UniAppManager.setToolbarButtons('save', true);
						}
						console.log('records : ', records);
						masterForm.setValue('AGREE_PRSN', records[0]["USER_ID"]);
						panelResult.setValue('AGREE_PRSN', records[0]["USER_ID"]);
						masterForm.setValue('USER_NAME', panelResult.getValue('USER_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					var tfsRecord = directMasterStore1.data.items[0];

					if(!Ext.isEmpty(tfsRecord)){
						tfsRecord.set('TEMP_FOR_SAVE','temp');
						UniAppManager.setToolbarButtons('save', true);
					}
					masterForm.setValue('AGREE_PRSN', '');
					panelResult.setValue('AGREE_PRSN', '');
					masterForm.setValue('USER_NAME', '');
				}
			}
		}),{
			xtype: 'component',
			colspan: 4,
			tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' }
		},{
			fieldLabel:'<t:message code="Mpo501.label.ORDER_NUM" default="발주번호"/>',
			name: 'ORDER_NUM',
			xtype: 'uniTextfield',
			readOnly: isAutoOrderNum,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('ORDER_NUM', newValue);
				}
			}
		},{
			fieldLabel:'<t:message code="Mpo501.label.LC_NUM" default="L/C번호"/>',
			name: 'LC_NUM',
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('LC_NUM', newValue);
				}
			}
		},
		Unilite.popup('PROJECT',{
			fieldLabel: '<t:message code="Mpo501.label.PROJECT_NO" default="프로젝트번호"/>',
			textFieldWidth: 150,
			validateBlank: true,
			textFieldName:'PROJECT_NO',
			itemId:'project',
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE')});
				},
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('PROJECT_NO', newValue);
				}
			}
		}),{
			fieldLabel: '<t:message code="Mpo501.label.MONEY_UNIT2" default="화폐"/>',
			name:'MONEY_UNIT',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B004',
			displayField: 'value',
			allowBlank:false,
			holdable: 'hold',
			fieldStyle: 'text-align: center;',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('MONEY_UNIT', newValue);
//					UniAppManager.app.fnExchngRateO();
				},
				blur: function( field, The, eOpts )	{
				   UniAppManager.app.fnExchngRateO();
				}
			}
		},{
			fieldLabel:'<t:message code="Mpo501.label.EXCHG_RATE_O" default="환율"/>',
			name: 'EXCHG_RATE_O',
			xtype: 'uniNumberfield',
			allowBlank:false,
			decimalPrecision: 4,
			value: 1,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('EXCHG_RATE_O', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="Mpo501.label.RECEIPT_TYPE2" default="결제방법"/>',
			name:'RECEIPT_TYPE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B038',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('RECEIPT_TYPE', newValue);
				}
			}
		},{
			fieldLabel:'<t:message code="Mpo501.label.REMARK" default="비고"/>',
			name: 'REMARK',
			xtype: 'textareafield',
			width: 670,
			colspan:2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('REMARK', newValue);
				}
			}
		}/*,{
			fieldLabel:'<t:message code="system.label.purchase.potatal" default="발주총액"/>',
			name: 'SumOrderO',
			xtype: 'uniNumberfield',
			readOnly: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('SumOrderO', newValue);
				}
			}
		}*/,{
			xtype: 'component'
		},{
			fieldLabel:'<t:message code="Mpo501.label.SumOrderLocO" default="자사총액"/>',
			name: 'SumOrderLocO',
			xtype: 'uniNumberfield',
			readOnly: true,
			hidden:true
		},{
			fieldLabel: '<t:message code="Mpo501.label.COMP_NAME" default="회사명"/>',
			name:'COMP_NAME',
			xtype: 'uniTextfield',
			hidden: true
		},{
			fieldLabel:'<t:message code="Mpo501.label.DRAFT_YN" default="기안여부"/>',
			name: 'DRAFT_YN',
			xtype: 'uniTextfield',
			hidden:true
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
						if(Ext.isDefined(item.holdable) )	{
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)	{
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
					if(Ext.isDefined(item.holdable) )	{
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
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

	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items: [{
			fieldLabel: '<t:message code="Mpo501.label.DIV_CODE" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			value: UserInfo.divCode,
			child:'WH_CODE'/*,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = orderNoSearch.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					var field2 = orderNoSearch.getField('WH_CODE');
					field2.getStore().clearFilter(true);
				}
			}*/
		},
			Unilite.popup('AGENT_CUST', {
			validateBlank: false,
			listeners: {
				applyextparam: function(popup){
				popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
				popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				}
			}
		})/*,
		{
			fieldLabel: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
		comboType   : 'OU'
		}*/,
		{
			fieldLabel: '<t:message code="Mpo501.label.ORDER_TYPE" default="발주유형"/>',
			name:'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M001'
		},{
			fieldLabel: '<t:message code="Mpo501.label.ORDER_DATE" default="발주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},{
			fieldLabel: '<t:message code="Mpo501.label.ORDER_PRSN" default="구매담당"/>',
			name:'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			readOnly: true,
			comboCode:'M201',
			//20200609: COLSPAN 이동 발주일에서 구매담당으로
			colspan: 2/*,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode4', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode4', newValue, divCode);
				}
			}*/
		}/*,{
			fieldLabel:'<t:message code="system.label.purchase.pono" default="발주번호"/>',
			name: 'ORDER_NUM',
			xtype: 'uniTextfield'
		}*/,{
			fieldLabel: '<t:message code="Mpo501.label.AGREE_STATUS2" default="승인여부"/>',
			id:'AGREE_STATUSp',
			name:'AGREE_STATUS',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M007'
		},
		Unilite.popup('PROJECT',{
			fieldLabel: '<t:message code="Mpo501.label.PROJECT_NO" default="프로젝트번호"/>',
			name:'PROJECT_NO',
			textFieldWidth: 170,
			validateBlank: false
		}),{	//20200609 추가: 조회 시, 발주번호로 조회할 수 있도록 수정
			fieldLabel	: '<t:message code="system.label.purchase.pono" default="발주번호"/>',
			name		: 'ORDER_NUM',
			xtype		: 'uniTextfield'
		}]
	});

	var otherorderSearch = Unilite.createSearchForm('otherorderForm', {	 //타발주참조
		layout: {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel: '<t:message code="Mpo501.label.DIV_CODE" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120'
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel: '<t:message code="Mpo501.label.CUSTOM_NAME" default="거래처"/>',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			listeners: {
				onSelected: {},
				onClear: function(type) {},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				}
			}
		}),
		Unilite.popup('PROJECT',{
			fieldLabel: '<t:message code="Mpo501.label.PROJECT_NO" default="프로젝트번호"/>',
			name:'PROJECT_NO',
			textFieldWidth: 170,
			validateBlank: false
		}),{
			fieldLabel: '<t:message code="Mpo501.label.ORDER_TYPE" default="발주유형"/>',
			name:'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M001'
		},{
			fieldLabel: '<t:message code="Mpo501.label.ORDER_DATE" default="발주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			colspan:2
		},
//		Unilite.popup('DEPT', {
//			fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
//			valueFieldName: 'DEPT_CODE',
//			textFieldName: 'DEPT_NAME',
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
//						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
//					}else if(authoInfo == "5"){		//부서권한
//						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
//						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
//					}
//				}
//			}
//		}),
		{
			fieldLabel: '<t:message code="Mpo501.label.ORDER_PRSN" default="구매담당"/>',
			name:'ORDER_PRSN',
			readOnly: true,
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M201'
		},{
			fieldLabel: '<t:message code="Mpo501.label.AGREE_STATUS2" default="승인여부"/>',
			name: 'AGREE_STATUS',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M007'
		}]
	});

	var otherorderSearch2 = Unilite.createSearchForm('otherorderForm2', {	 // 구매요청등록 참조
		layout: {type : 'uniTable', columns : 3},
		items :[{
				fieldLabel: '<t:message code="Mpo501.label.DIV_CODE" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value: UserInfo.divCode
			},
			{
				fieldLabel:'<t:message code="Mpo501.label.PO_REQ_NUM" default="구매요청번호"/>',
				name: 'PO_REQ_NUM',
				xtype: 'uniTextfield'
			},
			{
				fieldLabel: '<t:message code="Mpo501.label.REQ_DATE" default="요청일자"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PO_REQ_DATE_FR',
				endFieldName: 'PO_REQ_DATE_TO',
				allowBlank: false,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},
			Unilite.popup('DEPT', {
				fieldLabel: '<t:message code="Mpo501.label.DEPT" default="부서"/>',
				valueFieldName: 'DEPT_CODE',
				textFieldName: 'DEPT_NAME',
				listeners: {
					applyextparam: function(popup){
						var authoInfo = pgmInfo.authoUser;			  //권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;   //부서정보
						var divCode = '';				   //사업장

						if(authoInfo == "A"){   //자기사업장
							popup.setExtParam({'TREE_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
							popup.setExtParam({'TREE_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}else if(authoInfo == "5"){	 //부서권한
							popup.setExtParam({'TREE_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),//20200729 수정: 구매담당 콤보 -> 사원 팝업으로 변경
			Unilite.popup('Employee',{
				fieldLabel: '사원',
				valueFieldName:'PERSON_NUMB',
				textFieldName:'PERSON_NAME',
				holdable: 'hold',
				autoPopup:true,
				allowBlank:false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);
						var param= Ext.getCmp('otherorderForm2').getValues();
						s_mre090ukrv_kdService.selectPersonDept(param, function(provider, response) {
							if(!Ext.isEmpty(provider)){
								otherorderSearch2.setValue('DEPT_CODE', provider[0].DEPT_CODE);
								otherorderSearch2.setValue('DEPT_NAME', provider[0].DEPT_NAME);
							}
						});
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NAME', newValue);
						var param= Ext.getCmp('otherorderForm2').getValues();
						s_mre090ukrv_kdService.selectPersonDept(param, function(provider, response) {
							if(!Ext.isEmpty(provider)){
								otherorderSearch2.setValue('DEPT_CODE', provider[0].DEPT_CODE);
								otherorderSearch2.setValue('DEPT_NAME', provider[0].DEPT_NAME);
							}
						});
					}
				}
			}),/*{//20200729 수정: 구매담당 콤보 -> 사원 팝업으로 변경
				fieldLabel: '<t:message code="Mpo501.label.ORDER_PRSN" default="구매담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M201'
			},*/{
				fieldLabel: '<t:message code="Mpo501.label.MONEY_UNIT2" default="화폐"/>',
				name:'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType:'AU',
				displayField: 'value',
				comboCode:'B004',
				//value: BsaCodeInfo.gsDefaultMoney,
				fieldStyle: 'text-align: center;'

			},
			{
				fieldLabel: '<t:message code="Mpo501.label.SUPPLY_TYPE" default="조달구분"/>',
				name: 'SUPPLY_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B014',
				allowBlank:false,
				value: '1'
			},
			{
				fieldLabel: '<t:message code="Mpo501.label.ITEM_ACCOUNT" default="품목계정"/>',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020'
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="Mpo501.label.CUSTOM_NAME" default="거래처"/>',
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				listeners: {
					onSelected: {},
					onClear: function(type) {},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
					}
				}
			})
		]
	});

	var requestRegSearch = Unilite.createSearchForm('requestRegForm', {	 //금형외주가공의뢰참조
		layout: {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			value: UserInfo.divCode
		},
		Unilite.popup('DEPT', {
			fieldLabel: '부서',
		//	labelWidth: 100,
			valueFieldName: 'DEPT_CODE',
	   	 	textFieldName: 'DEPT_NAME',
			holdable: 'hold',
			listeners: {
				applyextparam: function(popup){
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장
					if(authoInfo == "A"){	//자기사업장
						popup.setExtParam({'TREE_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'TREE_CODE': ""});
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'TREE_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),
		{
			fieldLabel: '요청일',
			xtype: 'uniDateRangefield',
			startFieldName: 'ITEM_REQ_DATE_FR',
			endFieldName: 'ITEM_REQ_DATE_TO',
			allowBlank: false,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel:'거래처',
			autoPopup: true,
			valueFieldName: 'CUSTOM_CODE',
			textFieldName: 'CUSTOM_NAME'
		}),{
			fieldLabel: '가공구분',
			name:'MAKE_GUBUN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'WZ21'
		} ,
		{
			fieldLabel: '품목계정',
			name: 'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B020',
			readOnly: false,
			holdable: 'hold'
		},{
			fieldLabel: '금형품명',
			name:'ITEM_NAME',
			xtype: 'uniTextfield',
			width: 312
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
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )   {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)   {
							var popupFC = item.up('uniPopupField')  ;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )   {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)   {
						var popupFC = item.up('uniPopupField')  ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid= Unilite.createGrid('mpo501ukrvGrid', {
		region: 'center' ,
		layout: 'fit',
		excelTitle: '<t:message code="Mpo501.label.excelTitle_MASTER" default="발주등록"/>',
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
			xtype:'container',
			layout : {type : 'uniTable', columns : 3},
			padding : '0 0 2 0',
			items:[{
				fieldLabel  : '납기일',
				xtype	   : 'uniDatefield',
				id		  : 'NEW_DVRY_DATE',
				labelWidth  : 53,
				width	   : 180,
				value	   : new Date(),
				listeners   : {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			},{
				text	: '일괄변경',
				xtype   : 'button',
				id	  : 'DVRY_CHANGE_BUTTON',
				disabled: false,
				handler : function() {
					var records = masterGrid.getStore().data.items;
					if(records.length > 0){
						var newDvryDate = Ext.getCmp('NEW_DVRY_DATE').getValue();
						var orderDate = panelResult.getValue('ORDER_DATE');
						var newDvryDateStr =  UniDate.getDbDateStr(Ext.getCmp('NEW_DVRY_DATE').getValue());
						var orderDateStr =  UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE'));
						if(Ext.isEmpty(newDvryDate)){
							alert('납기일을 입력하십시요.');
							return false;
						}
						if(orderDateStr > newDvryDateStr){
							alert('납기일은 발주일보다 크거나 같아야 합니다.');
							return false;
						}
						if(confirm('납기일을 일괄 변경하시겠습니까?')){
							Ext.each(records, function(record, i){
								record.set("DVRY_DATE" , newDvryDate);
							});
						}
					} else {
						alert('납기일을 변경할 데이터가 없습니다.\n변경할 데이터를 선택하세요');
						return false;
					}
				}
			}]
		},{ xtype: 'tbspacer'
		  },{
				xtype: 'tbseparator'
			  },{
				xtype: 'tbspacer'
			  },{
			xtype: 'splitbutton',
			itemId:'orderTool',
			text: '<t:message code="Mpo501.label.BTN_REF" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'otherorderBtn',
					text: '<t:message code="Mpo501.label.BTN_REF_OTHER" default="타발주참조"/>',
					handler: function() {
						openOtherOrderWindow();
					}
				},{
					itemId: 'otherorderBtn2',
					text: '<t:message code="Mpo501.label.BTN_REF_REQ" default="구매계획참조"/>',
					handler: function() {
						if(!masterForm.setAllFieldsReadOnly(true)){
								return false;
						}
						openMRE100TWindow();
					}
				}, {
					itemId: 'excelBtn',
					text: '<t:message code="Mpo501.label.BTN_REF_EXCEL" default="엑셀참조"/>',
					handler: function() {
							openExcelWindow();
					}
				},{
					itemId: 'refBtn4',
					text: '금형의뢰 참조',
					handler: function() {
						openRequestRegWindow();
					}
				}]
			})
		}],
		store: directMasterStore1,
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns: [
			{dataIndex:'ORDER_SEQ'					, width: 40 , align: 'center'/*,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.total" default="총계"/>');
			}*/},
			{dataIndex: 'ITEM_CODE'				 , width: 130,
			 editor: Unilite.popup('DIV_PUMOK_G', {
						textFieldName: 'ITEM_CODE',
						DBtextFieldName: 'ITEM_CODE',
//									  extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
						useBarcodeScanner: false,
						autoPopup: false,
						validateBlank : false,
						listeners: {'onSelected': {
										fn: function(records, type) {
												console.log('records : ', records);
												Ext.each(records, function(record,i) {
																	console.log('record',record);
																	if(i==0) {
																		masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
																	} else {
																		UniAppManager.app.onNewDataButtonDown();
																		masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
																	}
												});
											},
										scope: this
										},
									'onClear': function(type) {
										//masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
									},
									applyextparam: function(popup){
										var record = masterGrid.getSelectedRecord();
										var divCode = record.get('DIV_CODE');
										popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
										popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
//										if(BsaCodeInfo.gsBalanceOut == 'Y') {
//											popup.setExtParam({'ADD_QUERY': "ISNULL(B_OUT_YN, 'N') != N'Y'"});		   //WHERE절 추카 쿼리
//										}
									}
						}
				})
			},
			{dataIndex: 'ITEM_NAME'				 , width: 150,
			 editor: Unilite.popup('DIV_PUMOK_G', {
//									  extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
//						useBarcodeScanner: false,
						autoPopup: false,
						validateBlank : false,
						listeners: {'onSelected': {
										fn: function(records, type) {
												console.log('records : ', records);
												Ext.each(records, function(record,i) {
																	console.log('record',record);
																	if(i==0) {
																		masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
																	} else {
																		UniAppManager.app.onNewDataButtonDown();
																		masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
																	}
												});
											},
										scope: this
										},
									'onClear': function(type) {
										//masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
									},
									applyextparam: function(popup){
										var record = masterGrid.getSelectedRecord();
										var divCode = record.get('DIV_CODE');
										popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode});
										popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
//										if(BsaCodeInfo.gsBalanceOut == 'Y') {
//											popup.setExtParam({'ADD_QUERY': "ISNULL(B_OUT_YN, 'N') != N'Y'"});		   //WHERE절 추카 쿼리
//										}
									}
						}
				})
			},
			{dataIndex:'SPEC'				, width: 138 },
			{dataIndex:'ORDER_UNIT'			, width: 88, align: 'center'},
			{dataIndex:'TRNS_RATE'			, width: 93 /*xtype: 'uniNnumberColumn'*/ },
			{dataIndex:'ORDER_UNIT_Q'		, width: 93, summaryType: 'sum' },
			{dataIndex:'ORDER_UNIT_P'		, width: 93, summaryType: 'sum' },
			{dataIndex:'MONEY_UNIT'			, width: 73 ,hidden : false},

			{dataIndex:'UNIT_PRICE_TYPE'	, width: 88/*, hidden: true */},
			{dataIndex:'ORDER_O'			, width: 106, summaryType: 'sum' },
			{dataIndex:'DVRY_DATE'			, width: 80 },
			{dataIndex:'WH_CODE'			, width: 120},
			{dataIndex:'STOCK_UNIT'			, width: 88, align: 'center'},
			{dataIndex:'INSPEC_FLAG'		, width: 90/*, hidden: true*/ },
			{dataIndex: 'LOT_NO'			, width:120 ,hidden: sumtypeLot},
			{dataIndex:'ORDER_Q'			, width: 93, summaryType: 'sum' },
			{dataIndex:'CONTROL_STATUS'		, width: 100},
			{dataIndex:'ORDER_REQ_NUM'		, width: 100 /*,hidden : true*/},
			{dataIndex:'PROJECT_NO'			, width: 200 },
			{dataIndex:'REMARK'				, width: 200 },

			{dataIndex:'DIV_CODE'			, width: 93 ,hidden: true},
			{dataIndex:'CUSTOM_CODE'		, width: 93 ,hidden: true},
			{dataIndex:'ORDER_NUM'			, width: 110 ,hidden: true},
			{dataIndex:'LOT_YN'				, width:120, hidden: true },
			{dataIndex:'ORDER_LOC_P'		, width: 93 ,hidden : true},
			{dataIndex:'ORDER_LOC_O'		, width: 106 ,hidden : true},
			{dataIndex:'EXCHG_RATE_O'		, width: 80 ,hidden : true},
			{dataIndex:'DVRY_TIME'			, width: 80 ,hidden : true},
			{dataIndex:'PO_REQ_NUM'			, width: 93 ,hidden : true},
			{dataIndex:'PO_SER_NO'			, width: 93 ,hidden : true},
			{dataIndex:'ORDER_P'			, width: 93 ,hidden : true},
			{dataIndex:'INSTOCK_Q'			, width: 100 ,hidden : true},
			{dataIndex:'COMP_CODE'			, width: 10 ,hidden : true},
			{dataIndex:'UPDATE_DB_USER'		, width: 10 ,hidden : true},
			{dataIndex:'UPDATE_DB_TIME'		, width: 10 ,hidden : true},
			{dataIndex:'SO_NUM'				, width: 100 ,hidden : true},
			{dataIndex:'SO_SEQ'				, width: 100 ,hidden : true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if((e.record.data.CONTROL_STATUS > '1' && e.record.data.CONTROL_STATUS != '9') || /*top.gsAutoOrder <> "Y" &&*/ masterForm.getValue('ORDER_YN') > '1'){
					if(e.field=='CONTROL_STATUS') return false;
				}
				if(e.record.phantom){
					if(e.record.data.ORDER_REQ_NUM != ''){
						if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','ORDER_SEQ','ORDER_O'])) return false;
					}else{
					if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','ORDER_SEQ', 'LOT_NO'])) return true;
					}
				}
				if(UniUtils.indexOf(e.field, [
					'ORDER_UNIT','DVRY_DATE','DVRY_TIME','ORDER_UNIT_P','MONEY_UNIT','EXCHG_RATE_O',
					'ORDER_LOC_P','ORDER_LOC_O','WH_CODE','UNIT_PRICE_TYPE','ORDER_UNIT_Q',/*'ORDER_O',*/
					'REMARK','PROJECT_NO','CONTROL_STATUS','INSPEC_FLAG', 'LOT_NO'
				]))	return true;

				if(e.record.data.ORDER_UNIT != e.record.data.STOCK_UNIT){
					if(e.field=='TRNS_RATE') return true;
				}else{
					if(BsaCodeInfo.gsTrnsRateEdtYn.toUpperCase() == 'Y'){ //구매단위와 재고단위가 같아도 수정 가능하게 할지 여부
						if(e.field=='TRNS_RATE') return true;
					}else{
						if(e.field=='TRNS_RATE') return false;
					}
				}
				return false;
			}
		},
		disabledLinkButtons: function(b) {
			this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
			this.down('#procTool').menu.down('#issueLinkBtn').setDisabled(b);
			this.down('#procTool').menu.down('#saleLinkBtn').setDisabled(b);
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		,"");
				grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('ITEM_ACCOUNT'	,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('STOCK_UNIT'		,"");
				grdRecord.set('TRNS_RATE'		,'1');
				grdRecord.set('ORDER_P'			,0);
				grdRecord.set('DVRY_DATE'		,UniDate.get('today'));
				grdRecord.set('INSPEC_FLAG'		,"");
				grdRecord.set('ORDER_UNIT_P'	,0);
				grdRecord.set('LOT_YN'			, '');
				grdRecord.set('WH_CODE'			, '');
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('ORDER_UNIT'		, record['ORDER_UNIT']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
				grdRecord.set('ORDER_P'			, record['BASIS_P']);
				grdRecord.set('DVRY_DATE'		, moment().add('day',record['PURCH_LDTIME']).format('YYYYMMDD'));
				grdRecord.set('INSPEC_FLAG'		, record['INSPEC_YN']);
				grdRecord.set('LOT_YN'			, record['LOT_YN']);
				grdRecord.set('WH_CODE'			, record['WH_CODE']);
				var param = {"ITEM_CODE": record['ITEM_CODE'],
					"DIV_CODE": record['DIV_CODE']};
				mpo501ukrvService.callInspecyn(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)) {
						grdRecord.set('INSPEC_FLAG', provider['INSPEC_YN']);
					}
				});
				var param = {"DIV_CODE": record['DIV_CODE'],
					"DEPT_CODE": masterForm.getValue('DEPT_CODE')};
				mpo501ukrvService.callDeptInspecFlag(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)) {
						grdRecord.set('INSPEC_FLAG', provider['INSPEC_FLAG']);
					}
				});
				var param = {"ITEM_CODE": record['ITEM_CODE'],
					"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE'),
					"DIV_CODE": masterForm.getValue('DIV_CODE'),
					"MONEY_UNIT": masterForm.getValue('MONEY_UNIT'),
					"ORDER_UNIT": record['ORDER_UNIT'],
					"ORDER_DATE": UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE')),
					"STOCK_UNIT": record['STOCK_UNIT']
				};
				mpo501ukrvService.fnOrderPrice(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)) {
						grdRecord.set('ORDER_UNIT_P', provider['ORDER_P']);
						grdRecord.set('TRNS_RATE', provider['TRNS_RATE']);
					}else{
						grdRecord.set('ORDER_UNIT_P', 0);
						grdRecord.set('TRNS_RATE', '1');
					}
				});
				UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
			}
		},
		setOrderData:function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('DIV_CODE'		, masterForm.getValue('DIV_CODE'));
			grdRecord.set('CUSTOM_CODE'		, masterForm.getValue('CUSTOM_CODE'));
			grdRecord.set('ORDER_NUM'		, '');
			grdRecord.set('CONTROL_STATUS'	, '1');
			grdRecord.set('ORDER_Q'			, '0');
			grdRecord.set('ORDER_P'			, '0');
			grdRecord.set('ORDER_UNIT_Q'	, '0');
			grdRecord.set('UNIT_PRICE_TYPE'	, 'Y');
			grdRecord.set('ORDER_UNIT_P'	, '0');
			grdRecord.set('ORDER_O'			, '0');
			grdRecord.set('TRNS_RATE'		, '1');
			grdRecord.set('INSTOCK_Q'		, '0');
			grdRecord.set('DVRY_DATE'		, UniDate.get('today'));
			grdRecord.set('COMP_CODE'		, record['COMP_CODE']);
			grdRecord.set('MONEY_UNIT'		, masterForm.getValue('MONEY_UNIT'));
			grdRecord.set('EXCHG_RATE_O'	, masterForm.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_LOC_P'		, '0');
			grdRecord.set('ORDER_LOC_O'		, '0');
			if(Ext.isEmpty(masterForm.getValue('PROJECT_NO'))){
				grdRecord.set('PROJECT_NO'		,masterForm.getValue('PROJECT_NO'));
			}
			if(Ext.isEmpty(masterForm.getValue('REMARK'))){
				grdRecord.set('REMARK'		,masterForm.getValue('REMARK'));
			}
			var param = {"DIV_CODE": record['DIV_CODE'],
				"DEPT_CODE": masterForm.getValue('DEPT_CODE')};
			mpo501ukrvService.callDeptInspecFlag(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					grdRecord.set('INSPEC_FLAG', provider['INSPEC_FLAG']);
				}
			});
		},
		setEstiData: function(record) {					 // 구매계획참조 셋팅
			var grdRecord = this.getSelectedRecord();
//			grdRecord.set('ORDER_NUM'		, record['']);
//			grdRecord.set('ORDER_SEQ'		, record['']);
			grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('SPEC'			, record['SPEC']);
//			grdRecord.set('CONTROL_STATUS'	, 'Y');
			grdRecord.set('PO_REQ_NUM'		, record['PO_REQ_NUM']);
			grdRecord.set('PO_SER_NO'		, record['PO_SER_NO']);
			grdRecord.set('ORDER_P'			, record['ORDER_P']);
			grdRecord.set('ORDER_UNIT_Q'	, record['REMAIN_Q']);
			grdRecord.set('ORDER_Q'			, grdRecord.get('ORDER_UNIT_Q') * grdRecord.get('TRNS_RATE'));
			grdRecord.set('UNIT_PRICE_TYPE'	, record['UNIT_PRICE_TYPE']);
			grdRecord.set('ORDER_UNIT_P'	, record['ORDER_P']);
			grdRecord.set('ORDER_O'			, record['ORDER_O']);
			grdRecord.set('ORDER_UNIT'		, record['ORDER_UNIT']);
			grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
			if(grdRecord.get('ORDER_UNIT') == grdRecord.get('STOCK_UNIT')) {
				grdRecord.set('TRNS_RATE'	, '1');
			} else {
				grdRecord.set('TRNS_RATE'	, record['TRNS_RATE']);
			}
//			grdRecord.set('INSTOCK_Q'		, record['']);
			grdRecord.set('DVRY_DATE'		, record['DVRY_DATE']);
			grdRecord.set('COMP_CODE'		, UserInfo.compCode);
			grdRecord.set('MONEY_UNIT'		, record['MONEY_UNIT']);
			grdRecord.set('EXCHG_RATE_O'	, record['EXCHG_RATE_O']);
			grdRecord.set('ORDER_LOC_P'		, record['ORDER_LOC_P']);
			grdRecord.set('ORDER_LOC_O'		, record['ORDER_LOC_O']);
			grdRecord.set('WH_CODE'			, record['WH_CODE']);
			grdRecord.set('LOT_YN'			, record['LOT_YN']);
			grdRecord.set('INSPEC_FLAG'		, record['INSPEC_FLAG']);


			var refOrderP = record['ORDER_P']
			if(refOrderP == 0){
				var param = {"ITEM_CODE": record['ITEM_CODE'],
						"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE'),
						"DIV_CODE": masterForm.getValue('DIV_CODE'),
						"MONEY_UNIT": record['MONEY_UNIT'],
						"ORDER_UNIT": record['ORDER_UNIT'],
						"ORDER_DATE": UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE')),
						"STOCK_UNIT": record['STOCK_UNIT']
					};
					mpo501ukrvService.fnOrderPrice(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)) {
								var param1 = {
									"AC_DATE"	: UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE')),
									"MONEY_UNIT" : record['MONEY_UNIT']
								};
								salesCommonService.fnExchgRateO(param1, function(provider1, response) {
									if(!Ext.isEmpty(provider1)){
										grdRecord.set('EXCHG_RATE_O', provider1.BASE_EXCHG);
										grdRecord.set('ORDER_UNIT_P', provider['ORDER_P']);
										grdRecord.set('TRNS_RATE', provider['TRNS_RATE']);
										UniAppManager.app.fnCalOrderAmt(grdRecord, "P", provider['ORDER_P']);
										directMasterStore1.fnSumOrderO();
									}
								})

						}else{
							  var param1 = {
										"AC_DATE"	: UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE')),
										"MONEY_UNIT" : record['MONEY_UNIT']
									};
									salesCommonService.fnExchgRateO(param1, function(provider1, response) {
										if(!Ext.isEmpty(provider1)){
											grdRecord.set('EXCHG_RATE_O', provider1.BASE_EXCHG);
											grdRecord.set('ORDER_UNIT_P', 0);
											grdRecord.set('TRNS_RATE', '1');
											UniAppManager.app.fnCalOrderAmt(grdRecord, "P", 0);
											directMasterStore1.fnSumOrderO();
										}
									})
						}
					});
			}


//			UniAppManager.app.fnCalOrderAmt(record, "O", newValue);
//			directMasterStore1.fnSumOrderO();
		},
		setExcelData: function(record) {
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('SPEC'			, record['SPEC']);
			grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
			grdRecord.set('ORDER_UNIT'		, record['ORDER_UNIT']);
			grdRecord.set('INSPEC_FLAG'		, record['INSPEC_YN']);
			grdRecord.set('ORDER_UNIT_P'	, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_O'			, record['ORDER_O']);
			grdRecord.set('WH_CODE'			, record['WH_CODE']);
			grdRecord.set('ORDER_UNIT_Q'	, record['ORDER_UNIT_Q']);

		},
		setProviderData: function(record) {
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			grdRecord.set('CUSTOM_CODE'		, record['CUSTOM_CODE']);
//			grdRecord.set('ORDER_NUM'		, record['ORDER_NUM']);
//			grdRecord.set('ORDER_SEQ'		, record['ORDER_SEQ']);
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('SPEC'			, record['SPEC']);
			grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
			grdRecord.set('ORDER_UNIT_Q'	, record['ORDER_UNIT_Q']);
			grdRecord.set('ORDER_UNIT'		, record['ORDER_UNIT']);
			grdRecord.set('UNIT_PRICE_TYPE'	, record['UNIT_PRICE_TYPE']);
			grdRecord.set('MONEY_UNIT'		, record['MONEY_UNIT']);
			grdRecord.set('ORDER_UNIT_P'	, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_O'			, record['ORDER_O']);
			grdRecord.set('EXCHG_RATE_O'	, record['EXCHG_RATE_O']);
			grdRecord.set('ORDER_LOC_P'		, record['ORDER_LOC_P']);
			grdRecord.set('ORDER_LOC_O'		, record['ORDER_LOC_O']);
//			grdRecord.set('DVRY_DATE'		, record['DVRY_DATE']);
//			grdRecord.set('DVRY_TIME'		, record['DVRY_TIME']);
			grdRecord.set('WH_CODE'			, record['WH_CODE']);
			grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			grdRecord.set('ORDER_Q'			, record['ORDER_Q']);
			grdRecord.set('ORDER_P'			, record['ORDER_P']);
//			grdRecord.set('CONTROL_STATUS'	, record['CONTROL_STATUS']);
			grdRecord.set('ORDER_REQ_NUM'	, record['ORDER_REQ_NUM']);
			grdRecord.set('INSTOCK_Q'		, record['INSTOCK_Q']);
			grdRecord.set('INSPEC_FLAG'		, record['INSPEC_FLAG']);
			grdRecord.set('REMARK'			, record['REMARK']);
			grdRecord.set('PROJECT_NO'		, record['PROJECT_NO']);
			grdRecord.set('COMP_CODE'		, record['COMP_CODE']);
		},
		setRequestRegData:function(record) {
		 var grdRecord = this.getSelectedRecord();
			grdRecord.set('DIV_CODE'			, panelResult.getValue('DIV_CODE'));
			grdRecord.set('ITEM_CODE'		   , record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		   , record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('STOCK_UNIT'		  , record['STOCK_UNIT']);
			grdRecord.set('ORDER_UNIT'		  , record['ORDER_UNIT']);

			var remark = record['ITEM_NAME']
			if(record['MAKE_GUBUN'] == '01'){
				if(record['GARO_NUM'] != 0){
					remark = remark + ' ' + record['GARO_NUM'] + record['GARO_NUM_UNIT'];
				}
				if(record['THICK_NUM'] != 0){
					remark = remark + ',' + record['THICK_NUM'] + record['THICK_NUM_UNIT'];
				}
				remark = remark + ' ' + record['HM_CODE'] + ' ' + record['QTY'] + 'EA';
			}else{
				if(record['GARO_NUM'] != 0){
					remark = remark + ' ' + record['GARO_NUM'] + record['GARO_NUM_UNIT'];
				}
				if(record['SERO_NUM'] != 0){
					remark = remark + '*' + record['SERO_NUM'] + record['SERO_NUM_UNIT'];
				}
				if(record['THICK_NUM'] != 0){
					remark = remark + '*' + record['THICK_NUM'] + record['THICK_NUM_UNIT'];
				}
				remark = remark + ' ' + record['HM_CODE'] + ' ' + record['QTY'] + 'EA';
			}

			grdRecord.set('REMARK'	   		, remark);
			grdRecord.set('CUSTOM_CODE'		 , record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'		 , record['CUSTOM_NAME']);
			grdRecord.set('SO_NUM'	   , record['ITEM_REQ_NUM']);
			grdRecord.set('SO_SEQ'	   , record['ITEM_REQ_SEQ']);
			grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			grdRecord.set('ORDER_P'			, record['PRICE']);
			grdRecord.set('ORDER_UNIT_Q'	, record['REMAIN_Q']);
			grdRecord.set('ORDER_Q'			, record['REMAIN_Q'] * grdRecord.get('TRNS_RATE'));
			grdRecord.set('ORDER_UNIT_P'	, record['PRICE']);
			grdRecord.set('ORDER_O'			, record['AMT']);
			grdRecord.set('EXCHG_RATE_O'	, 1);
			grdRecord.set('ORDER_LOC_P'		, record['PRICE']);
			grdRecord.set('ORDER_LOC_O'		, record['AMT']);
		}
	});

	var orderNoMasterGrid = Unilite.createGrid('mpo501ukrvOrderNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
		layout : 'fit',
		excelTitle: '<t:message code="Mpo501.label.excelTitle_ORDER_NO" default="발주등록(발주번호검색)"/>',
		store: orderNoMasterStore,
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false
		},
		columns: [
			{ dataIndex: 'CUSTOM_NAME'		, width: 180},
			{ dataIndex: 'ORDER_DATE'		, width: 133},
			{ dataIndex: 'ORDER_TYPE'		, width: 93,align:'center'},
			{ dataIndex: 'ORDER_NUM'		, width: 133},
			{ dataIndex: 'CUSTOM_CODE'		, width: 80,hidden:true},
			{ dataIndex: 'DEPT_CODE'		, width: 80,hidden:true},
			{ dataIndex: 'DEPT_NAME'		, width: 80,hidden:true},
			{ dataIndex: 'ORDER_PRSN'		, width: 93,align:'center'},
			{ dataIndex: 'AGREE_STATUS'		, width: 66,align:'center'},
			{ dataIndex: 'AGREE_PRSN'		, width: 100,hidden:true},
			{ dataIndex: 'AGREE_PRSN_NAME'	, width: 100,hidden:true},
			{ dataIndex: 'AGREE_DATE'		, width: 66,hidden:true},
			{ dataIndex: 'MONEY_UNIT'		, width: 66,hidden:true},
			{ dataIndex: 'RECEIPT_TYPE'		, width: 66,hidden:true},
			{ dataIndex: 'REMARK'			, width: 66,hidden:true},
			{ dataIndex: 'EXCHG_RATE_O'		, width: 66,hidden:true},
			{ dataIndex: 'DRAFT_YN'			, width: 66,hidden:false},
			{ dataIndex: 'DIV_CODE'			, width: 66,hidden:true},
			{ dataIndex: 'PROJECT_NO'		, width: 66},
			{ dataIndex: 'COMP_NAME'		, width: 200}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record)	{
			if(Ext.isEmpty(record))	{
				record = this.getSelectedRecord();
			}
			masterForm.setValues({
				'DIV_CODE':record.get('DIV_CODE'),
				'CUSTOM_CODE':record.get('CUSTOM_CODE'),
				'CUSTOM_NAME':record.get('CUSTOM_NAME'),
				'ORDER_DATE':record.get('ORDER_DATE'),
				'ORDER_TYPE':record.get('ORDER_TYPE'),
				'ORDER_PRSN':record.get('ORDER_PRSN'),
				'ORDER_NUM':record.get('ORDER_NUM'),
				'MONEY_UNIT':record.get('MONEY_UNIT'),
				'EXCHG_RATE_O':record.get('EXCHG_RATE_O'),
				'COMP_NAME':record.get('COMP_NAME'),
				'AGREE_STATUS':record.get('AGREE_STATUS'),
				'AGREE_PRSN_NAME':record.get('AGREE_PRSN_NAME'),
				'DRAFT_YN':record.get('DRAFT_YN'),
				'DEPT_CODE':record.get('DEPT_CODE'),
				'DEPT_NAME':record.get('DEPT_NAME')
		  	});
		  	panelResult.setValues({
		  		'DIV_CODE':record.get('DIV_CODE'),
		  		'DEPT_CODE':record.get('DEPT_CODE'),
		  		'DEPT_NAME':record.get('DEPT_NAME'),
		  		'ORDER_NUM':record.get('ORDER_NUM'),
		  		'CUSTOM_CODE':record.get('CUSTOM_CODE'),
		  		'CUSTOM_NAME':record.get('CUSTOM_NAME'),
		  		'ORDER_DATE':record.get('ORDER_DATE'),
		  		'ORDER_PRSN':record.get('ORDER_PRSN'),
				'AGREE_STATUS':record.get('AGREE_STATUS'),
		  		'AGREE_PRSN_NAME':record.get('AGREE_PRSN_NAME')
		  	});
		}
	});

	var otherorderGrid = Unilite.createGrid('mpo501ukrvOtherorderGrid', {//타발주참조
		layout: 'fit',
		store: otherOrderStore,
		uniOpt: {
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		selModel: 'rowmodel',
		columns: [
			{ dataIndex: 'CUSTOM_NAME'		, width: 180},
			{ dataIndex: 'ORDER_DATE'		, width: 133},
			{ dataIndex: 'ORDER_TYPE'		, width: 93},
			{ dataIndex: 'ORDER_NUM'		, width: 133},
			{ dataIndex: 'CUSTOM_CODE'		, width: 80,hidden:true},
			{ dataIndex: 'ORDER_PRSN'		, width: 93},
			{ dataIndex: 'AGREE_STATUS'		, width: 66},
			{ dataIndex: 'AGREE_PRSN'		, width: 100,hidden:true},
			{ dataIndex: 'AGREE_PRSN_NAME'	, width: 100,hidden:true},
			{ dataIndex: 'AGREE_DATE'		, width: 66,hidden:true},
			{ dataIndex: 'MONEY_UNIT'		, width: 66,hidden:true},
			{ dataIndex: 'RECEIPT_TYPE'		, width: 66,hidden:true},
			{ dataIndex: 'REMARK'			, width: 66,hidden:true},
			{ dataIndex: 'EXCHG_RATE_O'		, width: 66,hidden:true},
			{ dataIndex: 'DRAFT_YN'			, width: 66,hidden:true},
			{ dataIndex: 'DIV_CODE'			, width: 66,hidden:true},
			{ dataIndex: 'PROJECT_NO'		, width: 66},
			{ dataIndex: 'DEPT_CODE'		, width: 80,hidden:true},
			{ dataIndex: 'DEPT_NAME'		, width: 80,hidden:true},
			{ dataIndex: 'WH_CODE'			, width: 80,hidden:true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				otherorderGrid.returnData();
				referOtherOrderWindow.hide();
			}
		},
		returnData: function(record)	{
			if(Ext.isEmpty(record))	{
		  		record = this.getSelectedRecord();
		  	}
//			var grid = this.down('#grid01');
			var param = {"ORDER_NUM": record.data.ORDER_NUM};
			mpo501ukrvService.selectList2(param, function(provider, response) {
				var records = response.result;

				masterForm.setValue('CUSTOM_CODE'	 , record.get('CUSTOM_CODE'));
				masterForm.setValue('CUSTOM_NAME'	 , record.get('CUSTOM_NAME'));
				masterForm.setValue('PROJECT_NO'	  , record.get('PROJECT_NO'));
				panelResult.setValue('CUSTOM_CODE'	, record.get('CUSTOM_CODE'));
				panelResult.setValue('CUSTOM_NAME'	, record.get('CUSTOM_NAME'));
				panelResult.setValue('PROJECT_NO'	 , record.get('PROJECT_NO'));

				Ext.each(records, function(record,i){
					UniAppManager.app.onNewDataButtonDown();
					masterGrid.setProviderData(record);
				});
				console.log("response",response)
				referOtherOrderWindow.hide();
			});
		}
	});

	var otherorderGrid2 = Unilite.createGrid('mpo501ukrvOtherorderGrid2', {	//구매계획참조
		layout: 'fit',
		store: otherOrderStore2,
		uniOpt: {
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false ,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ) {
					if(Ext.isEmpty(selectRecord.get('ITEM_CODE'))){
						otherorderGrid2.getSelectionModel().deselect(selectRecord);
						return false;
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ) {
				}
			}
		}),
		columns: [
			{dataIndex:'DIV_CODE'		, width: 93 ,hidden: true},
			{dataIndex:'PO_REQ_NUM'		, width: 110 ,hidden: false},
			{dataIndex:'PO_SER_NO'		, width: 55, align: 'center'},
			{dataIndex:'ITEM_CODE'		, width: 120 },
			{dataIndex:'ITEM_NAME'		, width: 250 },
			{dataIndex:'CUSTOM_CODE'	, width: 120 },
			{dataIndex:'CUSTOM_NAME'	, width: 250 },
			{dataIndex:'SPEC'			, width: 138 },
			{dataIndex:'STOCK_UNIT'		, width: 88},
			{dataIndex:'R_ORDER_Q'		, width: 90 },
			{dataIndex:'PAB_STOCK_Q'	, width: 90 },
			{dataIndex:'ORDER_UNIT_Q'	, width: 125 },
			{dataIndex:'REMAIN_Q'		, width: 125 },
			{dataIndex:'ORDER_UNIT'		, width: 88, align: 'center'},
			{dataIndex:'TRNS_RATE'		, width: 93 },
			{dataIndex:'ORDER_Q'		, width: 93 },
			{dataIndex:'MONEY_UNIT'		, width: 73 ,hidden : false},
			{dataIndex:'EXCHG_RATE_O'	, width: 80 ,hidden : true},
			{dataIndex:'UNIT_PRICE_TYPE', width: 88},
			{dataIndex:'ORDER_P'		, width: 93 },
			{dataIndex:'ORDER_O'		, width: 106 },
			{dataIndex:'ORDER_LOC_P'	, width: 93 },
			{dataIndex:'ORDER_LOC_O'	, width: 106 },
			{dataIndex:'SUPPLY_TYPE'	, width: 80 ,hidden : true},
			{dataIndex:'DVRY_DATE'		, width: 80 },
			{dataIndex:'PO_REQ_DATE'	, width: 80 },
			{dataIndex:'WH_CODE'		, width: 120},
			{dataIndex:'INSPEC_FLAG'	, width: 95},
			{dataIndex:'REMARK'			, width: 200 },
			{dataIndex:'ORDER_REQ_NUM'	, width: 100 },
			{dataIndex:'MRP_CONTROL_NUM', width: 100 },
			{dataIndex:'WH_CODE'		, width: 100,hidden : true },
			{dataIndex:'LOT_YN'			, width: 100,hidden : true },
			{dataIndex:'ORDER_YN'		, width: 80 ,hidden : true},
			{dataIndex:'PURCH_LDTIME'	, width: 80 ,hidden : true},
			{dataIndex:'COMP_CODE'		, width: 10 ,hidden : true},
			{dataIndex:'UPDATE_DB_USER'	, width: 10 ,hidden : true},
			{dataIndex:'UPDATE_DB_TIME'	, width: 10 ,hidden : true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function()  {
			var records = this.getSelectedRecords();

			Ext.each(records, function(record,i) {
				masterForm.setValue('CUSTOM_CODE'		, record.data.CUSTOM_CODE);
				masterForm.setValue('CUSTOM_NAME'		, record.data.CUSTOM_NAME);
				panelResult.setValue('CUSTOM_CODE'		, record.data.CUSTOM_CODE);
				panelResult.setValue('CUSTOM_NAME'		, record.data.CUSTOM_NAME);
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setEstiData(record.data);
			});
			this.getStore().remove(records);
		}
	});

	var requestRegGrid = Unilite.createGrid('s_mre101ukrv_kdRequestRegGrid', {   // 금형외주가공의뢰참조
		layout: 'fit',
		store: requestRegStore,
		uniOpt: {
			useGroupSummary: true,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
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
			{ dataIndex: 'COMP_CODE'			,  width: 90, hidden: true},
			{ dataIndex: 'DIV_CODE'			 ,  width: 90, hidden: true},
			{ dataIndex: 'ITEM_REQ_DATE'		,  width: 90},
			{ dataIndex: 'MOLD_ITEM_NAME'	   ,  width: 150},
			{ dataIndex: 'MAKE_GUBUN'		   ,  width: 100, align: 'center'},
			{ dataIndex: 'HM_CODE'			  ,  width: 100, align: 'center'},
			{ dataIndex: 'ITEM_CODE'			,  width: 90},
			{ dataIndex: 'ITEM_NAME'			,  width: 150},
			{ dataIndex: 'SPEC'				 ,  width: 100},
			{ dataIndex: 'ORDER_UNIT'		   ,  width: 70, align: 'center'},
			{ dataIndex: 'REQ_Q'				,  width: 90},
			{ dataIndex: 'ING_PLAN_Q'		   ,  width: 90},
			{ dataIndex: 'REMAIN_Q'			 ,  width: 90},
			{ dataIndex: 'PRICE'		   		,  width: 90},
			{ dataIndex: 'AMT'			 		,  width: 110},
			{ dataIndex: 'QTY'			  ,  width: 90, hidden: true},
			{ dataIndex: 'PURCHASE_P'		   ,  width: 90, hidden: true},
			{ dataIndex: 'CUSTOM_CODE'		  ,  width: 90},
			{ dataIndex: 'CUSTOM_NAME'		  ,  width: 150},
			{ dataIndex: 'ITEM_REQ_NUM'		 ,  width: 90},
			{ dataIndex: 'ITEM_REQ_SEQ'		 ,  width: 90},
			{ dataIndex: 'DEPT_CODE'			,  width: 90},
			{ dataIndex: 'DEPT_NAME'			,  width: 90},
			{ dataIndex: 'PERSON_NUMB'		  ,  width: 90},
			{ dataIndex: 'PERSON_NAME'		  ,  width: 90},
			{ dataIndex: 'ITEM_ACCOUNT'		 ,  width: 70, align: 'center', hidden: true},
			{ dataIndex: 'STOCK_UNIT'		   ,  width: 70, align: 'center', hidden: true},
			{ dataIndex: 'TRNS_RATE'			,  width: 90, hidden: true},
			{ dataIndex: 'DELIVERY_DATE'		,  width: 90, hidden: true},
			{ dataIndex: 'GARO_NUM'			 ,  width: 60, hidden: true},
			{ dataIndex: 'GARO_NUM_UNIT'		,  width: 60, hidden: true},
			{ dataIndex: 'SERO_NUM'			 ,  width: 60, hidden: true},
			{ dataIndex: 'SERO_NUM_UNIT'		,  width: 60, hidden: true},
			{ dataIndex: 'THICK_NUM'			,  width: 60, hidden: true},
			{ dataIndex: 'THICK_NUM_UNIT'	   ,  width: 60, hidden: true},
			{ dataIndex: 'BJ_NUM'			   ,  width: 60, hidden: true},
			{ dataIndex: 'LATEST_CUSTOM_CODE'   ,  width: 100, hidden: true},
			{ dataIndex: 'LATEST_CUSTOM_NAME'   ,  width: 120, hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				if(Ext.isEmpty(record)) {
					record = this.getSelectedRecord();
				}
			}
		},
		returnData: function(record)	{
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setRequestRegData(record.data);
			});
			this.deleteSelectedRow();
		}
	});

	function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="Mpo501.label.WIN_TITLE_ORDER_NO" default="발주번호검색"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [orderNoSearch, orderNoMasterGrid], //orderNomasterGrid],
				tbar:  ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="Mpo501.label.WIN_BTN_SEARCH" default="조회"/>',
					handler: function() {
						orderNoMasterStore.loadStoreRecords();
					},
					disabled: false
				}, {
					itemId : 'OrderNoCloseBtn',
					text: '<t:message code="Mpo501.label.WIN_BTN_CLOSE" default="닫기"/>',
					handler: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt)	{
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					show: function( panel, eOpts )	{
						orderNoSearch.setValue('DIV_CODE',		masterForm.getValue('DIV_CODE'));
						orderNoSearch.setValue('DEPT_CODE',		masterForm.getValue('DEPT_CODE'));
						orderNoSearch.setValue('DEPT_NAME',		masterForm.getValue('DEPT_NAME'));
						orderNoSearch.setValue('WH_CODE',		masterForm.getValue('WH_CODE'));
						orderNoSearch.setValue('CUSTOM_CODE',	masterForm.getValue('CUSTOM_CODE'));
						orderNoSearch.setValue('CUSTOM_NAME',	masterForm.getValue('CUSTOM_NAME'));
						orderNoSearch.setValue('ORDER_DATE_FR',	UniDate.get('startOfMonth'));
						orderNoSearch.setValue('ORDER_DATE_TO',	masterForm.getValue('ORDER_DATE'));
						orderNoSearch.setValue('ORDER_PRSN',	masterForm.getValue('ORDER_PRSN'));
						orderNoSearch.setValue('ORDER_TYPE',	masterForm.getValue('ORDER_TYPE'));
						if(BsaCodeInfo.gsApproveYN == '2'){
							orderNoSearch.setValue('AGREE_STATUS','2');
						}else if(BsaCodeInfo.gsApproveYN == '1'){
							orderNoSearch.setValue('AGREE_STATUS',masterForm.getValue('AGREE_STATUS'));
						}
					 }
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}

	function openOtherOrderWindow() {			//타발주참조
		if(!referOtherOrderWindow) {
			referOtherOrderWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="Mpo501.label.WIN_TITLE_REF_OTHER" default="타발주참조"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [otherorderSearch, otherorderGrid],
				tbar: ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="Mpo501.label.WIN_BTN_SEARCH" default="조회"/>',
					handler: function() {
						otherOrderStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmCloseBtn',
					text: '<t:message code="Mpo501.label.WIN_BTN_APPLY_CLOSE_ORDER" default="발주적용 후 닫기"/>',
					handler: function() {
						otherorderGrid.returnData();
						referOtherOrderWindow.hide();
//						directMasterStore1.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="Mpo501.label.WIN_BTN_CLOSE" default="닫기"/>',
					handler: function() {
						referOtherOrderWindow.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt)	{
						otherorderSearch.clearForm();
						otherorderGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						otherorderSearch.clearForm();
						otherorderGrid.reset();
					},
					beforeshow: function ( me, eOpts )	{
					},
					show: function( panel, eOpts )	{
						otherorderSearch.setValue('DIV_CODE',	masterForm.getValue('DIV_CODE'));
						otherorderSearch.setValue('DEPT_CODE',	masterForm.getValue('DEPT_CODE'));
						otherorderSearch.setValue('DEPT_NAME',	masterForm.getValue('DEPT_NAME'));
						otherorderSearch.setValue('WH_CODE',	masterForm.getValue('WH_CODE'));
						otherorderSearch.setValue('CUSTOM_CODE',masterForm.getValue('CUSTOM_CODE'));
						otherorderSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
						otherorderSearch.setValue('ORDER_TYPE', masterForm.getValue('ORDER_TYPE'));
						otherorderSearch.setValue('ORDER_PRSN', masterForm.getValue('ORDER_PRSN'));
						otherorderSearch.setValue('AGREE_STATUS', masterForm.getValue('AGREE_STATUS'));
						otherorderSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
						otherorderSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth', otherorderSearch.getValue('ORDER_DATE_TO')));
					}
				}
			})
		}
		referOtherOrderWindow.center();
		referOtherOrderWindow.show();
	};

	function openMRE100TWindow() {		  //구매계획참조
//		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!MRE100TWindow) {
			MRE100TWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="Mpo501.label.WIN_TITLE_REF_REQ" default="구매계획참조"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [otherorderSearch2, otherorderGrid2],
				tbar: ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="Mpo501.label.WIN_BTN_SEARCH" default="조회"/>',
					handler: function() {
						otherOrderStore2.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmCloseBtn',
					text: '<t:message code="Mpo501.label.WIN_BTN_APPLY_CLOSE" default="적용 후 닫기"/>',
					handler: function() {
						otherorderGrid2.returnData();
						MRE100TWindow.hide();
//						directMasterStore1.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="Mpo501.label.WIN_BTN_CLOSE" default="닫기"/>',
					handler: function() {
						MRE100TWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt)  {
						otherorderSearch2.clearForm();
						otherorderGrid2.reset();
					},
					beforeclose: function( panel, eOpts )   {
						otherorderSearch2.clearForm();
						otherorderGrid2.reset();
					},
					beforeshow: function ( me, eOpts ){
						otherorderSearch2.setValue('DIV_CODE', masterForm.getValue("DIV_CODE"));
						otherorderSearch2.setValue('ORDER_PRSN', masterForm.getValue("ORDER_PRSN"));
						//otherorderSearch2.setValue('MONEY_UNIT', masterForm.getValue("MONEY_UNIT"));
						otherorderSearch2.setValue('CUSTOM_CODE', masterForm.getValue("CUSTOM_CODE"));
						otherorderSearch2.setValue('CUSTOM_NAME', masterForm.getValue("CUSTOM_NAME"));
						otherorderSearch2.setValue('PO_REQ_DATE_TO', UniDate.get('today'));
						otherorderSearch2.setValue('PO_REQ_DATE_FR', UniDate.get('startOfMonth', otherorderSearch2.getValue('PO_REQ_DATE_TO')));
						otherorderSearch2.setValue('SUPPLY_TYPE', '1');
						otherOrderStore2.loadStoreRecords();
					}
				}
			})
		}
		MRE100TWindow.center();
		MRE100TWindow.show();
	};

	function openExcelWindow() { //엑셀 업로드
		if(!UniAppManager.app.checkForNewDetail()) return false;
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUploadWin';
		if(!excelWindow) {
			excelWindow =  Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				title: '<t:message code="Mpo501.label.WIN_TITLE_REF_EXCEL" default="엑셀업로드참조"/>',
				width: 1080,
				height: 580,
				modal: false,
				excelConfigName: 'mpo501',
				extParam: {
					'DIV_CODE': masterForm.getValue('DIV_CODE'),
					'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE'),
					'MONEY_UNIT': masterForm.getValue('MONEY_UNIT'),
					'ORDER_DATE': UniDate.getDateStr( masterForm.getValue('ORDER_DATE'))
				},
				grids: [{
					itemId: 'grid01',
					title: '<t:message code="Mpo501.label.WIN_TITLE_ORDER_INFO" default="발주정보"/>',
					useCheckbox: true,
					model : 'excel.mpo501.sheet01',
					readApi: 'mpo501ukrvService.selectExcelUploadSheet1',
					columns: [
						{ dataIndex: 'ITEM_CODE',  	  	width: 120},
						{ dataIndex: 'ITEM_NAME',	   width: 250},
						{ dataIndex: 'SPEC',			width: 88},
						{ dataIndex: 'STOCK_UNIT',	  width: 88},
						{ dataIndex: 'ORDER_UNIT',	  width: 88, align: 'center'},
						{ dataIndex: 'INSPEC_YN',	   width: 120},
						{ dataIndex: 'ORDER_UNIT_P',	width: 88},
						{ dataIndex: 'ORDER_O',		 width: 120},
						{ dataIndex: 'WH_CODE',		 width: 120},
						{ dataIndex: 'ORDER_UNIT_Q',  	width: 100}
					]/*,
					listeners: {
						afterrender: function(grid) {
							var me = this;
							this.contextMenu = Ext.create('Ext.menu.Menu', {});
							this.contextMenu.add({
								text: '상품정보 등록',   iconCls : '',
								handler: function(menuItem, event) {
									var records = grid.getSelectionModel().getSelection();
									var record = records[0];
									var params = {
										appId: UniAppManager.getApp().id,
										sender: me,
										action: 'excelNew',
										_EXCEL_JOBID: excelWindow.jobID,
										_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'),
										ITEM_CODE: record.get('ITEM_CODE'),
										DIV_CODE: masterForm.getValue('DIV_CODE')
									}
										var rec = {data : {prgID : 'bpr101ukrv', 'text':''}};
										parent.openTab(rec, '/base/bpr101ukrv.do', params);
									}
							});
							this.contextMenu.add({
								text: '도서정보 등록',   iconCls : '',
								handler: function(menuItem, event) {
									var records = grid.getSelectionModel().getSelection();
									var record = records[0];
									var params = {
										appId: UniAppManager.getApp().id,
										sender: me,
										action: 'excelNew',
										_EXCEL_JOBID: excelWindow.jobID,
										_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'),
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
					}*/
				}],
				listeners: {
					close: function() {
						this.hide();
					},
					beforehide: function(me, eOpt)  {
					},
					beforeclose: function( panel, eOpts )   {
					}
				},
				onApply:function()	{
					var grid = this.down('#grid01');
					var records = grid.getSelectionModel().getSelection();
					Ext.each(records, function(record,i){
						UniAppManager.app.onNewDataButtonDown();
						masterGrid.setExcelData(record.data);
					});

					var beforeRM = grid.getStore().count();
					grid.getStore().remove(records);
					var afterRM = grid.getStore().count();
					if (beforeRM > 0 && afterRM == 0){
					   excelWindow.close();
					}
				}
			 });
		}
		excelWindow.center();
		excelWindow.show();
	};

	function openRequestRegWindow() {			//금형외주가공의뢰참조
		//if(!Unilite.Main.checkForNewDetail()) return false;
		if(!panelResult.setAllFieldsReadOnly(true)) return false;

		if(!requestRegWindow) {
			requestRegWindow = Ext.create('widget.uniDetailWindow', {
				title: '금형외주가공의뢰참조',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [requestRegSearch, requestRegGrid],
				tbar: ['->',{
					itemId : 'saveBtn',
					text: '조회',
					handler: function() {
//						if(requestRegSearch.setAllFieldsReadOnly(true) == false){
//							return false;
//						}
						requestRegStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmCloseBtn',
					text: '적용 후 닫기',
					handler: function() {
						requestRegGrid.returnData();
						requestRegWindow.hide();
						//directMasterStore1.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '닫기',
					handler: function() {
						requestRegWindow.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt)  {
						requestRegSearch.clearForm();
						requestRegStore.clearData();
						requestRegGrid.reset();
					},
					beforeclose: function( panel, eOpts )   {
					},
					beforeshow: function ( me, eOpts )  {
						requestRegSearch.setValue('DIV_CODE',		   panelResult.getValue('DIV_CODE'));
						requestRegSearch.setValue('ITEM_ACCOUNT',	   panelResult.getValue('ITEM_ACCOUNT'));
						requestRegSearch.setValue('ITEM_REQ_DATE_FR',	 UniDate.get('startOfMonth'));
						requestRegSearch.setValue('ITEM_REQ_DATE_TO',	 UniDate.get('today'));
						requestRegSearch.setValue('CUSTOM_CODE',panelResult.getValue('CUSTOM_CODE'));
						requestRegSearch.setValue('CUSTOM_NAME',panelResult.getValue('CUSTOM_NAME'));
					},
					show: function( panel, eOpts )  {
						requestRegStore.loadStoreRecords();
					}
				}
			})
		}
		requestRegWindow.center();
		requestRegWindow.show();
	};



	Unilite.Main({
		id: 'mpo501ukrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			masterForm
		],
		fnInitBinding: function(params) {
			masterForm.setValue('DEPT_CODE',UserInfo.deptCode);
			masterForm.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			UniAppManager.setToolbarButtons(['reset','newData','print', 'prev', 'next'], true);
			this.setDefault(params);
			masterForm.setValue('ORDER_PRSN',BsaCodeInfo.gsOrderPrsn);
			panelResult.setValue('ORDER_PRSN',BsaCodeInfo.gsOrderPrsn);
			if(BsaCodeInfo.gsApproveYN == '1'){
				Ext.getCmp('AGREE_DATE').setHidden(false);
				Ext.getCmp('AGREE_STATUS').setHidden(false);
				Ext.getCmp('AGREE_PRSN_NAME').setHidden(false);
				Ext.getCmp('AGREE_DATEr').setHidden(false);
				Ext.getCmp('AGREE_STATUSr').setHidden(false);
				Ext.getCmp('AGREE_PRSN_NAMEr').setHidden(false);
				Ext.getCmp('AGREE_STATUSp').setHidden(false);
			}else if(BsaCodeInfo.gsApproveYN == '2'){
				Ext.getCmp('AGREE_DATE').setHidden(true);
				Ext.getCmp('AGREE_STATUS').setHidden(true);
				Ext.getCmp('AGREE_PRSN_NAME').setHidden(true);
				Ext.getCmp('AGREE_DATEr').setHidden(true);
				Ext.getCmp('AGREE_STATUSr').setHidden(true);
				Ext.getCmp('AGREE_PRSN_NAMEr').setHidden(true);
				Ext.getCmp('AGREE_STATUSp').setHidden(true);
				masterForm.setValue('AGREE_STATUS','2');
				panelResult.setValue('AGREE_STATUS','2');
			}
			mpo501ukrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			});
			var param = {"SUB_CODE": BsaCodeInfo.gsOrderPrsn};
			mpo501ukrvService.userName(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('AGREE_PRSN',provider['USER_ID']);
					panelResult.setValue('AGREE_PRSN',provider['USER_ID']);
					masterForm.setValue('USER_NAME',provider['USER_NAME']);
					panelResult.setValue('USER_NAME',provider['USER_NAME']);

				}
			});
			if(!Ext.isEmpty(params && params.PGM_ID)){
				if(!Ext.isEmpty(params.ORDER_NUM)){
					masterForm.setValue('ORDER_NUM', params.ORDER_NUM);
					masterForm.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
					masterForm.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
					masterForm.setValue('ORDER_TYPE', params.ORDER_TYPE);
					masterForm.setValue('MONEY_UNIT', params.MONEY_UNIT);
					masterForm.setValue('EXCHG_RATE_O', params.EXCHG_RATE_O);
					masterForm.setValue('ORDER_DATE', params.ORDER_DATE);

					panelResult.setValue('ORDER_NUM', params.ORDER_NUM);
					panelResult.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
					panelResult.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
					panelResult.setValue('ORDER_TYPE', params.ORDER_TYPE);
					panelResult.setValue('MONEY_UNIT', params.MONEY_UNIT);
					panelResult.setValue('EXCHG_RATE_O', params.EXCHG_RATE_O);
					panelResult.setValue('ORDER_DATE', params.ORDER_DATE);
					//panelResult2.setValue('CREATE_LOC', params.CREATE_LOC);
					UniAppManager.app.onQueryButtonDown();
					panelResult.setAllFieldsReadOnly(true);
				}
			}
		},
		onQueryButtonDown: function()	{
			masterForm.setAllFieldsReadOnly(false);
			var orderNo = masterForm.getValue('ORDER_NUM');
			if(Ext.isEmpty(orderNo)) {
				openSearchInfoWindow()
			} else {
				var param= masterForm.getValues();
				masterForm.uniOpt.inLoading=true;
				masterForm.getForm().load({
					params: param,
					success:function()  {
						masterForm.setAllFieldsReadOnly(true)
						panelResult.setAllFieldsReadOnly(true)
						masterForm.uniOpt.inLoading=false;
					},
					failure: function(form, action) {
						masterForm.uniOpt.inLoading=false;
					}
				})
				directMasterStore1.loadStoreRecords();
				gsSaveRefFlag = 'Y';
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
			 var orderNum = masterForm.getValue('ORDER_NUM');
			 var seq = directMasterStore1.max('ORDER_SEQ');
			 if(!seq) seq = 1;
			 else  seq += 1;
			 var divCode = masterForm.getValue('DIV_CODE');
			 var cutomCode = masterForm.getValue('CUSTOM_CODE');
			 var controlStatus = '1';
			 var orderQ = '0';
			 var orderP = '0';
			 var orderUnitQ = '0';
			 var unitPriceType = 'Y';
			 var orderUnitP = '0';
			 var orderO = '0';
			 var trnsRate = '1';
			 var instockQ = '0';
			 var dvryDate = UniDate.get('today');
			 var compCode = masterForm.getValue('COMP_CODE');
			 var moneyUnit = masterForm.getValue('MONEY_UNIT'); // MoneyUnit
			 var exchgRateO = masterForm.getValue('EXCHG_RATE_O');
			 var orderLocP = '0';
			 var orderLocO = '0';
			 var whCode = masterForm.getValue('WH_CODE');
			 var r = {
				ORDER_NUM: orderNum,
				ORDER_SEQ: seq,
				DIV_CODE: divCode,
				CUSTOM_CODE: cutomCode,
				CONTROL_STATUS: controlStatus,
				ORDER_Q: orderQ,
				ORDER_P: orderP,
				ORDER_UNIT_Q: orderUnitQ,
				UNIT_PRICE_TYPE: unitPriceType,
				ORDER_UNIT_P: orderUnitP,
				ORDER_O: orderO,
				TRNS_RATE: trnsRate,
				INSTOCK_Q: instockQ,
				DVRY_DATE: dvryDate,
				COMP_CODE: compCode,
				MONEY_UNIT: moneyUnit,
				EXCHG_RATE_O: exchgRateO,
				ORDER_LOC_P: orderLocP,
				ORDER_LOC_O: orderLocO,
				WH_CODE: whCode
			};
			masterGrid.createRow(r);
			masterForm.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			masterForm.clearForm();
			panelResult.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
//			if(!directMasterStore1.isDirty())  {
//				if(masterForm.isDirty())	{
//					this.fnMasterSave();
//				}
//			} else {
//				if(masterForm.isDirty())	{
//					this.fnMasterSave();
//				} else {
//				}
//			alert(record.get('ORDER_UNIT_Q'));

//			var record = masterGrid.getSelectedRecord();
//			var ordUnitQ = record.get('ORDER_UNIT_Q'); //발주량
//			var ordUnitP = record.get('ORDER_UNIT_P'); //단가
//			if (ordUnitQ <= 0 && ordUnitP <= 0){
//				alert('단가와 발주량은 ' + Msg.sMB076);
//				UniAppManager.setToolbarButtons('save', false);
//			}else if(ordUnitQ <= 0 && ordUnitP > 0) {
//				alert('발주량은 ' + Msg.sMB076);
//				UniAppManager.setToolbarButtons('save', false);
//			}else if(ordUnitQ > 0 && ordUnitP <= 0) {
//				alert('단가는 ' + Msg.sMB076);
//				UniAppManager.setToolbarButtons('save', false);
//			}else {
//				directMasterStore1.saveStore();
//			}
				directMasterStore1.saveStore();
//			}
		},
//		fnMasterSave: function(){
//			var param = masterForm.getValues();
//			masterForm.submit({
//				params: param,
//				success:function(comp, action)  {
//					UniAppManager.setToolbarButtons('save', false);
//					UniAppManager.updateStatus(Msg.sMB011);
//				},
//				failure: function(form, action){
//
//				}
//			});
//		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('INSPEC_Q') > 1)
				{
					alert('<t:message code="unilite.msg.sMM435"/>');
				}else{
					masterGrid.deleteSelectedRow();
				}
			}
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore1.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						if(record.get('INSPEC_Q') > 1){
								alert('<t:message code="unilite.msg.sMM435"/>');
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
		onPrintButtonDown: function() {
			var reportGubun = BsaCodeInfo.gsReportGubun;//BsaCodeInfo.gsReportGubun
			if(masterForm.getValue('AGREE_STATUS') != '2'){
				alert('미승인건은 인쇄할 수 없습니다.');
				return false;
			}
			if(Ext.isEmpty(reportGubun) || reportGubun == 'CR'){
				var param = masterForm.getValues();
				var win = Ext.create('widget.CrystalReport', {
					url: CPATH+'/matrl/mpo501cukrv.do',
					prgID: 'mpo501ukrv',
					extParam: param
				});
				win.center();
				win.show();
			}else{
				if(BsaCodeInfo.gsSiteCode == "KDG"){
					var param = masterForm.getValues();
					param["UNIT_PRICE_YN"] = 'Y'
					param.PGM_ID= 'mpo501ukrv';
					param.MAIN_CODE= 'M030';
					if(param.ORDER_TYPE == '5'){
						param.FORM = 'F'//수입이면 외자
					}else{
						param.FORM = 'K' //그 외에는 국문
					}

					var win = Ext.create('widget.ClipReport', {
						url: CPATH+'/z_kd/s_mpo150clrkrv_kd.do',
						prgID: 'mpo501ukrv',
						extParam: param
					});
					win.center();
					win.show();
				}
			}

//			var param= Ext.getCmp('searchForm').getValues();
//			var win = Ext.create('widget.PDFPrintWindow', {
//				url: CPATH+'/mpo/mpo502rkrPrint.do',
//				prgID: 'mpo502rkr',
//					extParam: {
//						ORDER_NUM : param.ORDER_NUM,
//						DIV_CODE : masterForm.getValue('DIV_CODE')
//					}
//			});
//			win.center();
//			win.show();
		},
		setDefault: function(params) {
			var param = masterForm.getValues();
			mpo501ukrvService.selectOrderPrsn(param, function(provider, response){
				if(!Ext.isEmpty(provider)) {
					masterForm.setValue('ORDER_PRSN', provider[0].SUB_CODE);
					panelResult.setValue('ORDER_PRSN', provider[0].SUB_CODE);
					masterForm.getField('ORDER_PRSN').setReadOnly(true);
					panelResult.getField('ORDER_PRSN').setReadOnly(true);
				} else {
					masterForm.getField('ORDER_PRSN').setReadOnly(false);
					panelResult.getField('ORDER_PRSN').setReadOnly(false);
				}
			});
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
//			masterForm.setValue('ORDER_TYPE','1');
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('AGREE_STATUS','1');
			panelResult.setValue('AGREE_STATUS','1');
//			masterForm.setValue('AGREE_DATE',UniDate.get('today'));
//			panelResult.setValue('AGREE_DATE',UniDate.get('today'));
			if(Ext.isEmpty(params)) {
				masterForm.setValue('ORDER_DATE',new Date());
				panelResult.setValue('ORDER_DATE',new Date());
				masterForm.setValue('MONEY_UNIT',BsaCodeInfo.gsDefaultMoney);
				panelResult.setValue('MONEY_UNIT',BsaCodeInfo.gsDefaultMoney);
				UniAppManager.app.fnExchngRateO(true);
			}
			masterForm.setValue('DRAFT_YN','N');
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
			var field = masterForm.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = orderNoSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			gsSaveRefFlag = 'N';
			if(BsaCodeInfo.gsSiteCode == "KDG"){
				masterGrid.down('#orderTool').down('#refBtn4').setHidden(false);
			}else{
				masterGrid.down('#orderTool').down('#refBtn4').setHidden(true);
			}
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('ORDER_NUM')))	{
				alert('<t:message code="unilite.msg.sMS533" default="수주번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}
			return masterForm.setAllFieldsReadOnly(true);
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE')),
				"MONEY_UNIT" : masterForm.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni && !Ext.isEmpty(masterForm.getValue('MONEY_UNIT')) && masterForm.getValue('MONEY_UNIT') != BsaCodeInfo.gsDefaultMoney){
					}
					masterForm.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
					panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
				}
			});
		},
		fnCalOrderAmt: function(rtnRecord, sType, nValue) {
			var dOrderUnitQ= sType =='Q' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_Q'),0);
			var dOrderUnitP= sType =='P' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_P'),0);
			var dOrderO= sType =='O' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_O'),0);
			var dTransRate= sType =='R' ? nValue : Unilite.nvl(rtnRecord.get('TRNS_RATE'),1);
			var dOrderQ;
			var dOrderP;
			var dExchgRateO= sType =='X' ? nValue : Unilite.nvl(rtnRecord.get('EXCHG_RATE_O'),1);
			var dOrderLocP= sType =='L' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_LOC_P'),0);
			var dOrderLocO= sType =='I' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_LOC_O'),0);
			//20200610 추가: 'JPY' 관련로직 추가
			var moneyUnit = rtnRecord.get('MONEY_UNIT');

			if(sType == 'P' || sType == 'Q'){
				dOrderO = Unilite.multiply(dOrderUnitQ, dOrderUnitP); //금액 = 발주량 * 단가
//				dOrderO = (dOrderUnitQ * (dOrderUnitP * 1000)) / 1000
//				dOrderO = dOrderO.toFixed(3);
				rtnRecord.set('ORDER_O', dOrderO);

				dOrderQ = Unilite.multiply(dOrderUnitQ, dTransRate)
				rtnRecord.set('ORDER_Q', dOrderQ);

				dOrderP = dOrderUnitP / dTransRate;
				rtnRecord.set('ORDER_P', dOrderP);

				dOrderLocP = UniMatrl.fnExchangeApply(moneyUnit, Unilite.multiply(dOrderUnitP, dExchgRateO));	//20200610 수정: 'JPY' 관련로직 추가
				rtnRecord.set('ORDER_LOC_P', dOrderLocP);

				dOrderLocO = Unilite.multiply(dOrderUnitQ, dOrderLocP)
				rtnRecord.set('ORDER_LOC_O', dOrderLocO);
			}else if(sType == 'R'){
				dOrderQ = Unilite.multiply(dOrderUnitQ, dTransRate)
				rtnRecord.set('ORDER_Q', dOrderQ);

				dOrderP = dOrderUnitP / dTransRate;
				rtnRecord.set('ORDER_P', dOrderP);
			}else if(sType == 'O'){
				if(Math.abs(dOrderUnitQ) > '0'){
					dOrderUnitP = Math.abs(dOrderO) / Math.abs(dOrderUnitQ);
					rtnRecord.set('ORDER_UNIT_P', dOrderUnitP);

					dOrderP = dOrderUnitP / dTransRate;
					rtnRecord.set('ORDER_P', dOrderP);

					dOrderLocP = UniMatrl.fnExchangeApply(moneyUnit, Unilite.multiply(dOrderUnitP, dExchgRateO));	//20200610 수정: 'JPY' 관련로직 추가
					rtnRecord.set('ORDER_LOC_P', dOrderLocP);

					dOrderLocO =  Unilite.multiply(dOrderUnitQ, dOrderLocP);
					rtnRecord.set('ORDER_LOC_O', dOrderLocO);
				}else{
					rtnRecord.set('ORDER_UNIT_P', '0');
					rtnRecord.set('ORDER_P', '0');
					rtnRecord.set('ORDER_LOC_P', '0');

					dOrderLocO = UniMatrl.fnExchangeApply(moneyUnit, Unilite.multiply(dOrderO, dExchgRateO));	//20200610 수정: 'JPY' 관련로직 추가
					rtnRecord.set('ORDER_LOC_O', dOrderLocO);
				}
			}else if(sType == 'X'){
				dOrderLocP = UniMatrl.fnExchangeApply(moneyUnit, Unilite.multiply(dOrderUnitP, dExchgRateO));	//20200610 수정: 'JPY' 관련로직 추가
				rtnRecord.set('ORDER_LOC_P', dOrderLocP);

				dOrderLocO =  Unilite.multiply(dOrderUnitQ, dOrderLocP);
				rtnRecord.set('ORDER_LOC_O', dOrderLocO);
			}else if(sType == 'L'){
				dOrderLocO =  Unilite.multiply(dOrderLocP, dOrderUnitQ);
				rtnRecord.set('ORDER_LOC_O', dOrderLocO);

				dOrderUnitP = UniMatrl.fnExchangeApply2(moneyUnit, dOrderLocP / dExchgRateO);	//20200610 수정: 'JPY' 관련로직 추가
				rtnRecord.set('ORDER_UNIT_P', dOrderUnitP);

				dOrderO = Unilite.multiply(dOrderUnitQ, dOrderUnitP);
				rtnRecord.set('ORDER_O', dOrderO);

				dOrderQ = Unilite.multiply(dOrderUnitQ, dTransRate);
				rtnRecord.set('ORDER_Q', dOrderQ);

				dOrderP = dOrderUnitP / dTransRate;
				rtnRecord.set('ORDER_P', dOrderP);
			}else if(sType == 'I'){
				dOrderLocP = dOrderLocO / dOrderUnitQ;
				rtnRecord.set('ORDER_LOC_P', dOrderLocP);

				dOrderUnitP = UniMatrl.fnExchangeApply2(moneyUnit, dOrderLocP / dExchgRateO);	//20200610 수정: 'JPY' 관련로직 추가
				rtnRecord.set('ORDER_UNIT_P', dOrderUnitP);

				dOrderO = Unilite.multiply(dOrderUnitQ, dOrderUnitP);
				rtnRecord.set('ORDER_O', dOrderO);

				dOrderQ = Unilite.multiply(dOrderUnitQ, dTransRate);
				rtnRecord.set('ORDER_Q', dOrderQ);

				dOrderP = dOrderUnitP / dTransRate;
				rtnRecord.set('ORDER_P', dOrderP);
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
				case "ORDER_SEQ" : //발주순번
					if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}

				case "ORDER_UNIT" :
					var param = {"ITEM_CODE": record.get('ITEM_CODE'),
						"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE'),
						"DIV_CODE": masterForm.getValue('DIV_CODE'),
						"MONEY_UNIT": masterForm.getValue('MONEY_UNIT'),
						"ORDER_UNIT": newValue,
						"ORDER_DATE": UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE')),
						"STOCK_UNIT": record.get('STOCK_UNIT')
					};
					mpo501ukrvService.fnOrderPrice(param, function(provider, response)  {
						if(!Ext.isEmpty(provider)) {
							record.set('ORDER_UNIT_P', provider['ORDER_P']);
							record.set('TRNS_RATE', provider['TRNS_RATE']);
						}else{
							record.set('ORDER_UNIT_P', 0);
							record.set('TRNS_RATE', '1');
						}
					});
//					directMasterStore1.fnSumOrderO();
				break;

				case "ORDER_UNIT_Q" : //발주량
					if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "Q", newValue);
//					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_UNIT_P":	// 단가
					if(record.get('UNIT_PRICE_TYPE') == 'Y'){
						if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
						}
					}
					UniAppManager.app.fnCalOrderAmt(record, "P", newValue);
//					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_O" :
					if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "O", newValue);
//					directMasterStore1.fnSumOrderO();
					break;

				case "MONEY_UNIT" :
					var exchgRateO = record.get('EXCHG_RATE_O');
					if(newValue == BsaCodeInfo.gsDefaultMoney){
						exchgRateO = '1'
						record.set('EXCHG_RATE_O', '1');
						UniAppManager.app.fnCalOrderAmt(record, "X",exchgRateO);

					}else{
						var param = {
								"AC_DATE"	: UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE')),
								"MONEY_UNIT" : newValue
							};
							salesCommonService.fnExchgRateO(param, function(provider, response) {
								if(!Ext.isEmpty(provider)){
									exchgRateO = provider.BASE_EXCHG
									record.set('EXCHG_RATE_O', provider.BASE_EXCHG);
									var param1 = {"ITEM_CODE": record.get('ITEM_CODE'),
											"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE'),
											"DIV_CODE": masterForm.getValue('DIV_CODE'),
											"MONEY_UNIT": newValue,
											"ORDER_UNIT": record.get('ORDER_UNIT'),
											"ORDER_DATE": UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE')),
											"STOCK_UNIT": record.get('STOCK_UNIT')
										};
									mpo501ukrvService.fnOrderPrice(param1, function(provider, response)	{
										if(!Ext.isEmpty(provider)) {
											record.set('ORDER_UNIT_P', provider['ORDER_P']);
											record.set('TRNS_RATE', provider['TRNS_RATE']);
											UniAppManager.app.fnCalOrderAmt(record, "P", provider['ORDER_P']);
											directMasterStore1.fnSumOrderO();
										}else{
											record.set('ORDER_UNIT_P', 0);
											record.set('TRNS_RATE', '1');
											UniAppManager.app.fnCalOrderAmt(record, "P", 0);
											directMasterStore1.fnSumOrderO();
										}
									});
								}
							});
					}
//					directMasterStore1.fnSumOrderO();
					break;

				case "EXCHG_RATE_O":
					if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "X", newValue);
//					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_LOC_P":
					if(record.get('UNIT_PRICE_TYPE') == 'Y'){
						if(newValue <= 0){
							rv='<t:message code="unilite.msg.sMB076"/>';
							break;
						}
					}
					UniAppManager.app.fnCalOrderAmt(record, "L", newValue);
//					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_LOC_O":
					if(newValue <= 0){
							rv='<t:message code="unilite.msg.sMB076"/>';
							break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "I", newValue);
//					directMasterStore1.fnSumOrderO();
					break;

				case "DVRY_DATE":
					if(newValue < masterForm.getValue('ORDER_DATE')){
						rv='<t:message code="unilite.msg.sMM374"/>';
								break;
					}
					break;

				case "CONTROL_STATUS":
					if(oldValue != '8'){
						if (!(newValue < '2' || newValue =='9')){
							rv='<t:message code="unilite.msg.sMM013"/>';
								break;
						}
					}else{
						rv='<t:message code="unilite.msg.sMM013"/>';
								break;
					}
					if((masterForm.getValue('ORDER_YN')== '1') && newValue == '9'){
						rv='<t:message code="unilite.msg.sMM366"/>';
								break;
					}
					break;

				case "TRNS_RATE":
					if(newValue <= 0){
							rv='<t:message code="unilite.msg.sMB076"/>';
							break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "R", newValue);
//					directMasterStore1.fnSumOrderO();
					break;

				case "PROJECT_NO":
					break;

			}
			return rv;
		}
	});

	Unilite.createValidator('validator02', {
		forms: {'formA:':panelResult},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "REMARK" :
					var tfsRecord = directMasterStore1.data.items[0];
					if(!Ext.isEmpty(tfsRecord)){
						tfsRecord.set('TEMP_FOR_SAVE','temp');
						UniAppManager.setToolbarButtons('save', true);
					}
					break;
			}
			return rv;
		}
	});
};
</script>