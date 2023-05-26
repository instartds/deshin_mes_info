<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mpo501ukrv_jw"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_mpo501ukrv_jw"  />		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" />					<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" />					<!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" />					<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B038" />					<!-- 결제조건 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />					<!-- 화폐 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" />					<!-- 단가형태 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />		<!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="M002" />					<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="Q002" />					<!-- 품질대상여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />					<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />					<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" opts='1;2'/>		<!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="Z009" />					<!-- 납품처 -->
	<t:ExtComboStore comboType="AU" comboCode="Z010" />					<!-- 사용처 -->
</t:appConfig>
<script type="text/javascript" >

var SearchInfoWindow;	//조회버튼 누르면 나오는 조회창
var referOtherOrderWindow;	//타발주참조
var MRE100TWindow;	// 구매요청등록 참조
var excelWindow;	// 엑셀참조

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
    gsReportGubun : '${gsReportGubun}'	// 레포트 구분
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

function appMain() {
	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y')	{
		isAutoOrderNum = true;
	}

	var isOrderPrsn = true;
	if(BsaCodeInfo.gsApproveYN=='1') {
		isOrderPrsn = false;
	}

	var sumtypeLot = true;	//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeLot =='Y') {
		sumtypeLot = false;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_mpo501ukrv_jwService.selectList',
			update	: 's_mpo501ukrv_jwService.updateDetail',
			create	: 's_mpo501ukrv_jwService.insertDetail',
			destroy	: 's_mpo501ukrv_jwService.deleteDetail',
			syncAll	: 's_mpo501ukrv_jwService.saveAll'
		}
	});

	
	
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_mpo501ukrv_jwModel', {
		fields: [
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'					,type: 'string',child:'WH_CODE'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'				,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						,type: 'string',allowBlank: isAutoOrderNum},
			{name: 'ORDER_SEQ'			,text: '<t:message code="system.label.purchase.seq" default="순번"/>'							,type: 'int'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'						,type: 'string'},
			{name: 'STOCK_UNIT'	 		,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'				,type: 'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>'					,type: 'string'},
			{name: 'LOT_YN'				,text: '<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'			,type: 'string', comboType:'AU', comboCode:'A020'},
			{name: 'ORDER_UNIT_Q'		,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'						,type: 'uniQty' , allowBlank: false}, //, allowBlank: false
			{name: 'ORDER_UNIT'	 		,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				,type: 'string', allowBlank: false,comboType:'AU',comboCode:'B013',displayField: 'value'},
			{name: 'UNIT_PRICE_TYPE'	,text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'					,type: 'string',comboType:'AU',comboCode:'M301', allowBlank: false},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'				,type: 'string',comboType:'AU',comboCode:'B004', displayField: 'value'},
			{name: 'ORDER_UNIT_P'		,text: '<t:message code="system.label.purchase.price" default="단가"/>'						,type: 'uniUnitPrice' , allowBlank: false}, //, allowBlank: false
			{name: 'ORDER_O'			,text: '<t:message code="system.label.purchase.amount" default="금액"/>'						,type: 'uniUnitPrice'},
			{name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				,type: 'uniER'},
			{name: 'ORDER_LOC_P'		,text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'					,type: 'uniPrice'},
			{name: 'ORDER_LOC_O'		,text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'					,type: 'uniPrice'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				,type: 'uniDate', allowBlank: false},
			{name: 'DVRY_TIME'			,text: '<t:message code="system.label.purchase.deliverytime" default="납기시간"/>'				,type: 'string'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>'			,type: 'string',store: Ext.data.StoreManager.lookup('whList'), allowBlank: false},
			{name: 'TRNS_RATE'			,text: '<t:message code="system.label.purchase.containedqty.length" default="입수/길이(m)"/>'	,type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},

			//20180724 추가 (ITEM_WIDTH, SQM)
			{name: 'ITEM_WIDTH'			,text: '<t:message code="system.label.purchase.width" default="폭(mm)"/>'					,type: 'float'	, decimalPrecision: 0	, format:'0,000'},
			{name: 'SQM'				,text: 'SQM'																				,type: 'float'	, decimalPrecision: 2	, format:'0,000.00'},

			{name: 'ORDER_Q'			,text: '<t:message code="system.label.purchase.inventoryunitqty" default="재고단위량"/>'			,type: 'uniQty'},
			{name: 'PO_REQ_NUM'			,text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'		,type: 'string'},
			{name: 'PO_SER_NO'			,text: '<t:message code="system.label.purchase.purchaserequestseq" default="구매요청순번"/>'		,type: 'int'},
			{name: 'ORDER_P'			,text: '<t:message code="system.label.purchase.pounitpricestock" default="발주단가(재고)"/>'		,type: 'uniUnitPrice'},
			{name: 'CONTROL_STATUS'		,text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'				,type: 'string',comboType:'AU',comboCode:'M002'},
			{name: 'ORDER_REQ_NUM'		,text: '<t:message code="system.label.purchase.poreserveno" default="발주예정번호"/>'				,type: 'string'},
			{name: 'INSTOCK_Q'			,text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'					,type: 'uniQty'},
			{name: 'RECEIPT_Q'			,text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'				,type: 'uniQty'},
			{name: 'INSPEC_FLAG'		,text: '<t:message code="system.label.purchase.qualityyn" default="품질대상여부"/>'				,type: 'string',comboType:'AU',comboCode:'Q002', allowBlank: false},

			//20180724 추가 (DELIVERY_PLACE, USAGE_PLACE)
			{name: 'DELIVERY_PLACE'		,text: '<t:message code="system.label.purchase.customer" default="업체"/>'					,type: 'string',comboType:'AU',comboCode:'Z009'},
			{name: 'USAGE_PLACE'		,text: '<t:message code="system.label.purchase.usageplace" default="사용처"/>'					,type: 'string',comboType:'AU',comboCode:'Z010'},

			{name: 'REMARK'		 		,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'						,type: 'string'},
			{name: 'PROJECT_NO'	 		,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				,type: 'string'},
			{name: 'COMP_CODE'	 		,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER'		,type: 'string'},
			{name: 'UPDATE_DB_TIME'		,text: 'UPDATE_DB_TIME'		,type: 'string'},
			{name: 'TEMP_FOR_SAVE'		,text: 'TEMP_FOR_SAVE'		,type: 'string'},
			{name: 'SO_NUM'				,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'						,type: 'string'},
			{name: 'SO_SEQ'				,text: '<t:message code="system.label.purchase.soseq" default="수주순번"/>'						,type: 'int'}
		]
	});

	Unilite.defineModel('orderNoMasterModel', {			//조회버튼 누르면 나오는 조회창
		fields: [
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'ORDER_DATE'			, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'			, type: 'uniDate'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.poclass" default="발주유형"/>'			, type: 'string',comboType:'AU',comboCode:'M001'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		, type: 'string'},
			{name: 'DEPT_CODE'			, text: '<t:message code="system.label.purchase.departmencode" default="부서코드"/>'	, type: 'string'},
			{name: 'DEPT_NAME'			, text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'	, type: 'string'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'	, type: 'string',comboType:'AU',comboCode:'M201'},
			{name: 'AGREE_STATUS'		, text: '<t:message code="system.label.purchase.approved" default="승인"/>'			, type: 'string',comboType:'AU',comboCode:'M007'},
			{name: 'AGREE_PRSN'			, text: '<t:message code="system.label.purchase.approvaluser" default="승인자"/>'		, type: 'string'},
			{name: 'AGREE_PRSN_NAME'	, text: '<t:message code="system.label.purchase.approvalusername" default="승인자명"/>'	, type: 'string'},
			{name: 'AGREE_DATE'			, text: '<t:message code="system.label.purchase.approvaldate" default="승인일"/>'		, type: 'uniDate'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'			, type: 'string'},
			{name: 'RECEIPT_TYPE'		, text: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>'	, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'		, type: 'string'},
			{name: 'DRAFT_YN'			, text: '<t:message code="system.label.purchase.drafting" default="기안여부"/>'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string',comboType:'BOR120'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'COMP_NAME'	 		, text: '<t:message code="system.label.purchase.companyname" default="회사명"/>'		, type: 'string'}
		]
	});

	Unilite.defineModel('s_mpo501ukrv_jwOTHERModel', {	//타발주참조
		fields: [
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'ORDER_DATE'			, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'			, type: 'uniDate'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.poclass" default="발주유형"/>'			, type: 'string',comboType:'AU',comboCode:'M001'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		, type: 'string'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'	, type: 'string',comboType:'AU',comboCode:'M201'},
			{name: 'AGREE_STATUS'		, text: '<t:message code="system.label.purchase.approved" default="승인"/>'			, type: 'string',comboType:'AU',comboCode:'M007'},
			{name: 'AGREE_PRSN'			, text: '<t:message code="system.label.purchase.approvaluser" default="승인자"/>'		, type: 'string'},
			{name: 'AGREE_PRSN_NAME'	, text: '<t:message code="system.label.purchase.approvalusername" default="승인자명"/>'	, type: 'string'},
			{name: 'AGREE_DATE'			, text: '<t:message code="system.label.purchase.approvaldate" default="승인일"/>'		, type: 'uniDate'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'			, type: 'string'},
			{name: 'RECEIPT_TYPE'		, text: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>'	, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'		, type: 'string'},
			{name: 'DRAFT_YN'			, text: '<t:message code="system.label.purchase.drafting" default="기안여부"/>'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'DEPT_CODE'			, text: '<t:message code="system.label.purchase.departmencode" default="부서코드"/>'	, type: 'string'},
			{name: 'DEPT_NAME'			, text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'	, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'			, type: 'string'}
		]
	});

	Unilite.defineModel('Mre100ukrvModel', {			// 구매요청등록 참조
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.purchase.division" default="사업장"/>'					,type: 'string'},
			{name: 'PO_REQ_NUM'		,text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'		,type: 'string',allowBlank: isAutoOrderNum},
			{name: 'PO_SER_NO'		,text: '<t:message code="system.label.purchase.seq" default="순번"/>'				 			,type: 'int', allowBlank: false},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'				,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'				,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.purchase.spec" default="규격"/>'						,type: 'string'},
			{name: 'STOCK_UNIT'		,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'				,type: 'string'},
			{name: 'R_ORDER_Q'		,text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'				,type: 'uniQty'},
			{name: 'PAB_STOCK_Q'	,text: '<t:message code="system.label.purchase.onhandqty" default="현재고량"/>'					,type: 'uniQty'},
			{name: 'ORDER_UNIT_Q'	,text: '<t:message code="system.label.purchase.porequestqty" default="발주요청량"/>'
											+ '(' + '<t:message code="system.label.purchase.stock" default="재고"/>' + ')'		,type: 'uniQty', allowBlank: false},
			{name: 'ORDER_UNIT'		,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				,type: 'string', allowBlank: false,comboType:'AU',comboCode:'B013',displayField: 'value'},
			{name: 'TRNS_RATE'		,text: '<t:message code="system.label.purchase.purchasereceiptcount" default="구매입수"/>'		,type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
			{name: 'ORDER_Q'		,text: '<t:message code="system.label.purchase.porequestqty" default="발주요청량"/>'				,type: 'uniQty', allowBlank: false},
			{name: 'REMAIN_Q'		,text: '<t:message code="system.label.purchase.porequestremainqty" default="발주요청잔량"/>'		,type: 'uniQty'},
			{name: 'MONEY_UNIT'		,text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'				,type: 'string',comboType:'AU',comboCode:'B004', displayField: 'value'},
			{name: 'EXCHG_RATE_O'	,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				,type: 'uniER'},

			{name: 'UNIT_PRICE_TYPE',text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'					,type: 'string',comboType:'AU',comboCode:'M301', allowBlank: false},
			{name: 'ORDER_P'		,text: '<t:message code="system.label.purchase.price" default="단가"/>'						,type: 'uniUnitPrice', allowBlank: false},
			{name: 'ORDER_O'		,text: '<t:message code="system.label.purchase.amount" default="금액"/>'						,type: 'uniPrice'},
			{name: 'ORDER_LOC_P'	,text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'					,type: 'uniUnitPrice'},
			{name: 'ORDER_LOC_O'	,text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'					,type: 'uniPrice'},

			{name: 'DVRY_DATE'		,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				,type: 'uniDate', allowBlank: false},
			{name: 'WH_CODE'		,text: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>'			,type: 'string',store: Ext.data.StoreManager.lookup('whList'), allowBlank: false},
			{name: 'SUPPLY_TYPE'	,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'	,type: 'string',comboType:'AU',comboCode:'B014'},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.purchase.custom" default="거래처"/>'						,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'				,type: 'string'},

			{name: 'PO_REQ_DATE'	,text: '<t:message code="system.label.purchase.poreservedate" default="발주예정일"/>'			,type: 'uniDate'},
			{name: 'INSPEC_FLAG'	,text: '<t:message code="system.label.purchase.qualityyn" default="품질대상여부"/>'				,type: 'string',comboType:'AU',comboCode:'Q002', allowBlank: false},
			{name: 'REMARK'			,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'						,type: 'string'},

			{name: 'ORDER_REQ_NUM'	,text: '<t:message code="system.label.purchase.poreserveno" default="발주예정번호"/>'				,type: 'string'},
			{name: 'MRP_CONTROL_NUM',text: 'MRP<t:message code="system.label.purchase.number" default="번호"/>'					,type: 'string'},
			{name: 'ORDER_YN'		,text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'				,type: 'string'},

			{name: 'PURCH_LDTIME'	,text: '<t:message code="system.label.purchase.purchase2" default="구매"/>L/T'				,type: 'uniQty'},
			{name: 'WH_CODE'		,text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'					,type: 'string'},
			{name: 'LOT_YN'			,text: '<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'			,type: 'string'},
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				,type: 'string'},
			{name: 'UPDATE_DB_USER'	,text: 'UPDATE_DB_USER'	 ,type: 'string'},
			{name: 'UPDATE_DB_TIME'	,text: 'UPDATE_DB_TIME'	 ,type: 'string'}
		]
	});

	Unilite.Excel.defineModel('excel.mpo501.sheet01', {
		fields: [
			{name: 'ITEM_CODE'		,text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					,type: 'string'},
			{name: 'ITEM_NAME'		,text:'<t:message code="system.label.purchase.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'SPEC'			,text:'<t:message code="system.label.purchase.spec" default="규격"/>'							,type: 'string'},
			{name: 'STOCK_UNIT'		,text:'<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'				,type: 'string'},
			{name: 'ORDER_UNIT'		,text:'<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				,type: 'string'},
			{name: 'TRNS_RATE'		,text: '<t:message code="system.label.purchase.containedqty.length" default="입수/길이(m)"/>'	,type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
			{name: 'INSPEC_YN'		,text:'<t:message code="system.label.purchase.qualityinspectyn" default="품질검사여부"/>'			,type: 'string'},
			{name: 'ORDER_UNIT_P'	,text:'<t:message code="system.label.purchase.price" default="단가"/>'						,type: 'uniUnitPrice'},
			{name: 'ORDER_O'		,text:'<t:message code="system.label.purchase.amount" default="금액"/>'						,type: 'uniPrice'},
			{name: 'WH_CODE'		,text:'<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>'			,type: 'string'},
			{name: 'ORDER_UNIT_Q'	,text:'<t:message code="system.label.purchase.poqty" default="발주량"/>'						,type: 'uniQty'},
			{name: 'ITEM_WIDTH'		,text: '<t:message code="system.label.purchase.width" default="폭(mm)"/>'					,type: 'float'	, decimalPrecision: 0	, format:'0,000'}
		]
	});

	
	
	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_mpo501ukrv_jwMasterStore1',{
		model: 's_mpo501ukrv_jwModel',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			allDeletable: true,
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)) {
					Ext.each(records, function(record, i) {
						var itemWidth = record.get('ITEM_WIDTH');
						if(itemWidth == 0 || Ext.isEmpty(itemWidth)) {
							itemWidth = 1000;
						}
						record.set('SQM', record.get('ORDER_UNIT_Q') * record.get('TRNS_RATE') * itemWidth / 1000);

						//20190212 - 입고수량이나 접수수량이 있을 경우에는 수정 안 되도록 변경
						if((!Ext.isEmpty(record.data.INSTOCK_Q) && record.data.INSTOCK_Q != 0)
						|| (!Ext.isEmpty(record.data.RECEIPT_Q) && record.data.RECEIPT_Q != 0)) {
							var fields = panelResult.getForm().getFields();
							Ext.each(fields.items, function(item) {
								if(Ext.isDefined(item.holdable) )	{
									item.setReadOnly(true);
								}
								if(item.isPopupField)	{
									var popupFC = item.up('uniPopupField')	;
									popupFC.setReadOnly(true);
								}
							})
							panelResult.getField('PROJECT_NO').setReadOnly(true);
						}
					});
					this.commitChanges();
				}
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
			var param= panelResult.getValues();
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
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("ORDER_NUM", master.ORDER_NUM);
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
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
				var grid = Ext.getCmp('s_mpo501ukrv_jwGrid');
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
			panelResult.setValue('SumOrderO',sSumOrderO);
			panelResult.setValue('SumOrderLocO',sSumOrderLocO);
		}
	});

	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	//조회버튼 누르면 나오는 조회창
		model: 'orderNoMasterModel',
		autoLoad: false,
		uniOpt: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 's_mpo501ukrv_jwService.selectOrderNumMasterList'
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

	var otherOrderStore = Unilite.createStore('s_mpo501ukrv_jwOtherOrderStore', {//타발주참조
		model: 's_mpo501ukrv_jwOTHERModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 's_mpo501ukrv_jwService.selectOrderNumMasterList2'
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

	var otherOrderStore2 = Unilite.createStore('s_mpo501ukrv_jwOtherOrderStore2', {	 // 구매계획참조
		model: 'Mre100ukrvModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 's_mpo501ukrv_jwService.selectMre100tList'
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

	
	
	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3/*, tdAttrs: {style: 'border : 1px solid #ced9e7;'}*/},
		padding:'1 1 1 1',
		border:true,
		api: {
			load	: 's_mpo501ukrv_jwService.selectMaster',
			submit	: 's_mpo501ukrv_jwService.syncForm'
		},
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			holdable: 'hold',
			value: UserInfo.divCode,
			child:'WH_CODE',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			allowBlank: false,
			holdable: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
						panelResult.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
						//masterForm.setValue('EXCHG_RATE_O', '1');
						UniAppManager.app.fnExchngRateO();
						panelResult.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelResult.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));

				/*		if (panelResult.getValue('MONEY_UNIT') == 'KRW')
						{
						  panelResult.setValue('ORDER_TYPE',  '1');
						}
						else
						{
						  panelResult.setValue('ORDER_TYPE',  '5');
						}*/

					},
					scope: this
				},
				onClear: function(type) {
					CustomCodeInfo.gsUnderCalBase = '';
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				}
			}
		}),{
			xtype: 'component'
		},{
			fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype: 'uniDatefield',
			name: 'ORDER_DATE',
			value: UniDate.get('today'),
			allowBlank:false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name:'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M001',
			allowBlank:false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel:'<t:message code="system.label.purchase.approvaldate" default="승인일"/>',
			id:'AGREE_DATE',
			name: 'AGREE_DATE',
			xtype: 'uniDatefield',
//			value: UniDate.get('today'),
			readOnly:true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
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
					var param = {"SUB_CODE": newValue};
					s_mpo501ukrv_jwService.userName(param, function(provider, response)  {
						if(!Ext.isEmpty(provider)){
							panelResult.setValue('AGREE_PRSN', provider['USER_ID']);
							panelResult.setValue('USER_NAME', provider['USER_NAME']);
						}else{
							panelResult.setValue('AGREE_PRSN', '');
							panelResult.setValue('USER_NAME', '');
						}
					});
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>',
			id:'AGREE_STATUS',
			name:'AGREE_STATUS',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M007',
			readOnly: true,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
//		Unilite.popup('USER_SINGLE', {
		Unilite.popup('USER', {
			fieldLabel: '<t:message code="system.label.purchase.approvaluser" default="승인자"/>',
			valueFieldName:'AGREE_PRSN',
			textFieldName:'AGREE_PRSN_NAME',
			textFieldWidth: 150,
			showValue:false,
			id: 'AGREE_PRSN_NAME',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						var tfsRecord = directMasterStore1.data.items[0];
						
						if(!Ext.isEmpty(tfsRecord)){
							tfsRecord.set('TEMP_FOR_SAVE','temp');
							UniAppManager.setToolbarButtons('save', true);
						}
						panelResult.setValue('AGREE_PRSN', records[0]['USER_ID']);
						panelResult.setValue('AGREE_PRSN_NAME', records[0]['USER_NAME']);
					},
					scope: this
				},
				onClear: function(type) {
					var tfsRecord = directMasterStore1.data.items[0];
					
					if(!Ext.isEmpty(tfsRecord)){
						tfsRecord.set('TEMP_FOR_SAVE','temp');
						UniAppManager.setToolbarButtons('save', true);
					}
					panelResult.setValue('AGREE_PRSN', '');
					panelResult.setValue('AGREE_PRSN_NAME', '');
				}
			}
		}),{
			xtype: 'component',
			colspan: 4,
			tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' }
		},{
			fieldLabel:'<t:message code="system.label.purchase.pono" default="발주번호"/>',
			name: 'ORDER_NUM',
			xtype: 'uniTextfield',
			readOnly: isAutoOrderNum,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel:'<t:message code="system.label.purchase.lcno" default="L/C번호"/>',
			name: 'LC_NUM',
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('PROJECT',{
			fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
			textFieldWidth: 150,
			validateBlank: true,
			textFieldName:'PROJECT_NO',
			itemId:'project',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						var tfsRecord = directMasterStore1.data.items[0];
						
						if(!Ext.isEmpty(tfsRecord)){
							tfsRecord.set('TEMP_FOR_SAVE','temp');
							UniAppManager.setToolbarButtons('save', true);
						}
					},
					scope: this
				},
				onClear: function(type) {
					var tfsRecord = directMasterStore1.data.items[0];
					
					if(!Ext.isEmpty(tfsRecord)){
						tfsRecord.set('TEMP_FOR_SAVE','temp');
						UniAppManager.setToolbarButtons('save', true);
					}
				},
				applyextparam: function(popup){
					//거래처 관련 쿼리가 없음
//					popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
				},
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
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
//					UniAppManager.app.fnExchngRateO();
				},
				blur: function( field, The, eOpts )	{
				   UniAppManager.app.fnExchngRateO();
				}
			}
		},{
			fieldLabel:'<t:message code="system.label.purchase.exchangerate" default="환율"/>',
			name: 'EXCHG_RATE_O',
			xtype: 'uniNumberfield',
			allowBlank:false,
			decimalPrecision: 4,
			value: 1,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.payingmethod" default="결제방법"/>',
			name:'RECEIPT_TYPE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B038',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					var tfsRecord = directMasterStore1.data.items[0];
                        
                    if(!Ext.isEmpty(tfsRecord)){
                        tfsRecord.set('TEMP_FOR_SAVE','temp');
                        UniAppManager.setToolbarButtons('save', true);
                    }
				}
			}
		},{
			fieldLabel:'<t:message code="system.label.purchase.remarks" default="비고"/>',
			name: 'REMARK',
			xtype: 'textareafield',
			width: 670,
			colspan:2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype: 'component'
		},{
			fieldLabel:'<t:message code="system.label.purchase.cototal" default="자사총액"/>',
			name: 'SumOrderLocO',
			xtype: 'uniNumberfield',
			readOnly: true,
			hidden:true
		},{
			fieldLabel: '<t:message code="system.label.purchase.companyname" default="회사명"/>',
			name:'COMP_NAME',
			xtype: 'uniTextfield',
			hidden: true
		},{
			fieldLabel:'<t:message code="system.label.purchase.drafting" default="기안여부"/>',
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
				   	alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
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
			store: Ext.data.StoreManager.lookup('whList')
		}*/,
		{
			fieldLabel: '<t:message code="system.label.purchase.poclass" default="발주유형"/>',
			name:'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M001'
		},{
			fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			colspan: 2
		},{
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name:'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			readOnly: true,
			comboCode:'M201'/*,
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
			fieldLabel: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>',
			id:'AGREE_STATUSp',
			name:'AGREE_STATUS',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M007'
		},
		Unilite.popup('PROJECT',{
			fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
			name:'PROJECT_NO',
			textFieldWidth: 170,
			validateBlank: false
		})]
	});

	var otherorderSearch = Unilite.createSearchForm('otherorderForm', {		//타발주참조
		layout: {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120'
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
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
			fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
			name:'PROJECT_NO',
			textFieldWidth: 170,
			validateBlank: false
		}),{
			fieldLabel: '<t:message code="system.label.purchase.poclass" default="발주유형"/>',
			name:'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M001'
		},{
			fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
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
//	   	 	textFieldName: 'DEPT_NAME',
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
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name:'ORDER_PRSN',
			readOnly: true,
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M201'
		},{
			fieldLabel: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>',
			name: 'AGREE_STATUS',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M007'
		}]
	});

/*	var otherorderSearch2 = Unilite.createSearchForm('otherorderForm2', {	// 구매요청등록 참조
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
			}),{
				fieldLabel: '<t:message code="Mpo501.label.ORDER_PRSN" default="구매담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M201'
			},
			{
				fieldLabel: '<t:message code="Mpo501.label.MONEY_UNIT2" default="화폐"/>',
				name:'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType:'AU',
				displayField: 'value',
				comboCode:'B004',
				value: BsaCodeInfo.gsDefaultMoney,
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
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
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
	});*/

	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid= Unilite.createGrid('s_mpo501ukrv_jwGrid', {
		store: directMasterStore1,
		region: 'center' ,
		layout: 'fit',
		excelTitle: '<t:message code="system.label.purchase.poentry" default="발주등록"/>',
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
			xtype: 'splitbutton',
		   	itemId:'orderTool',
			text: '<t:message code="system.label.purchase.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'otherorderBtn',
					text: '<t:message code="system.label.purchase.otherporefer" default="타발주참조"/>',
					handler: function() {
						openOtherOrderWindow();
					}
				},{
//					itemId: 'otherorderBtn2',
//					text: '<t:message code="Mpo501.label.BTN_REF_REQ" default="구매계획참조"/>',
//					handler: function() {
//						if(!panelResult.setAllFieldsReadOnly(true)){
//								return false;
//						}
//						openMRE100TWindow();
//					}
//				}, {
					itemId: 'excelBtn',
					text: '<t:message code="system.label.purchase.excelrefer" default="엑셀참조"/>',
					handler: function() {
							openExcelWindow();
					}
				}]
			})
		}],
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
						useBarcodeScanner: false,
						autoPopup: true,
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
										masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
									},
									applyextparam: function(popup){
										var record = masterGrid.getSelectedRecord();
										var divCode = record.get('DIV_CODE');
										popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
										popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
									}
						}
				})
			},
			{dataIndex: 'ITEM_NAME'				 , width: 150,
			 editor: Unilite.popup('DIV_PUMOK_G', {
						autoPopup: true,
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
										masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
									},
									applyextparam: function(popup){
										var record = masterGrid.getSelectedRecord();
										var divCode = record.get('DIV_CODE');
										popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode});
										popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
									}
						}
				})
			},
			{dataIndex:'SPEC'					, width: 138 },
			{dataIndex:'ORDER_UNIT'	 			, width: 88, align: 'center'},
			{dataIndex:'ORDER_UNIT_Q'			, width: 110, summaryType: 'sum' },
			{dataIndex:'TRNS_RATE'				, width: 110 /*xtype: 'uniNnumberColumn'*/ },
			
			//20180724 추가
			{dataIndex:'ITEM_WIDTH'	 			, width: 110, align: 'center'},
			{dataIndex:'SQM'		 			, width: 110, align: 'center'},
			
			{dataIndex:'ORDER_UNIT_P'			, width: 93, summaryType: 'sum' },
			{dataIndex:'UNIT_PRICE_TYPE'		, width: 88/*, hidden: true */},
			{dataIndex:'ORDER_O'				, width: 106, summaryType: 'sum' },
			{dataIndex:'DVRY_DATE'				, width: 80 },
			{dataIndex:'WH_CODE'				, width: 120},
			{dataIndex:'STOCK_UNIT'	 			, width: 88, align: 'center'},
			{dataIndex:'INSPEC_FLAG'			, width: 90/*, hidden: true*/ },
			{dataIndex:'LOT_NO'					, width:120 ,hidden: sumtypeLot},
			{dataIndex:'ORDER_Q'				, width: 93, summaryType: 'sum' },
			{dataIndex:'CONTROL_STATUS'			, width: 100},
			{dataIndex:'ORDER_REQ_NUM'			, width: 100 ,hidden : true},
			{dataIndex:'PROJECT_NO'				, width: 200 ,hidden : true,
				editor: Unilite.popup('PROJECT_G', {
//					extParam: {DIV_CODE: UserInfo.divCode},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = masterGrid.uniOpt.currentRecord;
								Ext.each(records, function(record,i) {
									if(i==0) {
										grdRecord.set('PROJECT_NO', record['PJT_CODE']);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('PROJECT_NO', '');
						},
						applyextparam: function(popup){
							//거래처 관련 쿼리가 없음
//							popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
						}
					}
				})
			},
			
			//20180724 추가
			{dataIndex:'DELIVERY_PLACE'			, width: 93},
			{dataIndex:'USAGE_PLACE'			, width: 93},
			
			{dataIndex:'REMARK'		 			, width: 200 },

			{dataIndex:'DIV_CODE'				, width: 93 ,hidden: true},
			{dataIndex:'CUSTOM_CODE'			, width: 93 ,hidden: true},
			{dataIndex:'ORDER_NUM'				, width: 110 ,hidden: true},
			{dataIndex:'LOT_YN'					, width:120, hidden: true },
			{dataIndex:'MONEY_UNIT'				, width: 73 ,hidden : true},
			{dataIndex:'EXCHG_RATE_O'			, width: 80 ,hidden : true},
			{dataIndex:'ORDER_LOC_P'			, width: 93 ,hidden : true},
			{dataIndex:'ORDER_LOC_O'			, width: 106 ,hidden : true},
			{dataIndex:'DVRY_TIME'				, width: 80 ,hidden : true},
			{dataIndex:'PO_REQ_NUM'				, width: 93 ,hidden : true},
			{dataIndex:'PO_SER_NO'				, width: 93 ,hidden : true},
			{dataIndex:'ORDER_P'				, width: 93 ,hidden : true},
			{dataIndex:'INSTOCK_Q'				, width: 100 ,hidden : true},
			{dataIndex:'RECEIPT_Q'				, width: 100 ,hidden : true},
			{dataIndex:'COMP_CODE'	 			, width: 10 ,hidden : true},
			{dataIndex:'UPDATE_DB_USER'			, width: 10 ,hidden : true},
			{dataIndex:'UPDATE_DB_TIME'			, width: 10 ,hidden : true},
			{dataIndex:'SO_NUM'					, width: 100 ,hidden : true},
			{dataIndex:'SO_SEQ'					, width: 100 ,hidden : true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if((e.record.data.CONTROL_STATUS > '1' && e.record.data.CONTROL_STATUS != '9') || /*top.gsAutoOrder <> "Y" &&*/ panelResult.getValue('ORDER_YN') > '1'){
					if(e.field=='CONTROL_STATUS') return false;
				}
				//기 등록된 데이터의 경우
				if(!e.record.phantom) {
					//20181218 - 발주승인 방식이 수동승인 일 경우, 승인여부가 승인이면 수정 안 되도록 변경
					if(BsaCodeInfo.gsApproveYN == '1' && panelResult.getValue('AGREE_STATUS') == '2') {
						var fields = panelResult.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
								item.setReadOnly(true);
							}
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;
								popupFC.setReadOnly(true);
							}
						})
						return false;
					}
/*					//20181218 - 입고수량이나 접수수량이 있을 경우에는 수정 안 되도록 변경: 조회시 처리하도록 변경
					if((!Ext.isEmpty(e.record.data.INSTOCK_Q) && e.record.data.INSTOCK_Q != 0)
					|| (!Ext.isEmpty(e.record.data.RECEIPT_Q) && e.record.data.RECEIPT_Q != 0)) {
						var fields = panelResult.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
								item.setReadOnly(true);
							}
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;
								popupFC.setReadOnly(true);
							}
						})
						return false;
					}*/
				}
				if(e.record.phantom){
					if(e.record.data.ORDER_REQ_NUM != ''){
						if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','ORDER_SEQ','ORDER_O'])) return false;
					}else{
						if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','ORDER_SEQ', 'LOT_NO', 'DELIVERY_PLACE', 'USAGE_PLACE'])) return true;
					}
				}
				if(UniUtils.indexOf(e.field, [
					'ORDER_UNIT','DVRY_DATE','DVRY_TIME','ORDER_UNIT_P','MONEY_UNIT','EXCHG_RATE_O',
					'ORDER_LOC_P','ORDER_LOC_O','WH_CODE','UNIT_PRICE_TYPE','ORDER_UNIT_Q',/*'ORDER_O',*/
					'REMARK','PROJECT_NO','CONTROL_STATUS','INSPEC_FLAG', 'LOT_NO',
					//20190212 수정 가능하도록 변경
					'DELIVERY_PLACE', 'USAGE_PLACE'
				]))	return true;
				
				if(e.record.data.ORDER_UNIT != e.record.data.STOCK_UNIT){
					if(e.field=='TRNS_RATE') return true;
				}else{
					if(e.field=='TRNS_RATE') return false;
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
				grdRecord.set('ITEM_WIDTH'		, '');
				grdRecord.set('SQM'				, '');
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
				
				grdRecord.set('ITEM_WIDTH'		, record['ITEM_WIDTH']);
				var itemWidth = record['ITEM_WIDTH'];
				if(itemWidth == 0) {
					itemWidth = 1000;
				}
				grdRecord.set('SQM'				, grdRecord.get('ORDER_UNIT_Q') * record['TRNS_RATE'] * itemWidth / 1000);
				
				var param = {"ITEM_CODE": record['ITEM_CODE'],"DIV_CODE": record['DIV_CODE']};
				s_mpo501ukrv_jwService.callInspecyn(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)) {
						grdRecord.set('INSPEC_FLAG', provider['INSPEC_YN']);
					}
				});
				var param = {"DIV_CODE": record['DIV_CODE'],"DEPT_CODE": panelResult.getValue('DEPT_CODE')};
				s_mpo501ukrv_jwService.callDeptInspecFlag(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)) {
						grdRecord.set('INSPEC_FLAG', provider['INSPEC_FLAG']);
					}
				});
				var param = {
					"ITEM_CODE"		: record['ITEM_CODE'],
					"CUSTOM_CODE"	: panelResult.getValue('CUSTOM_CODE'),
					"DIV_CODE"		: panelResult.getValue('DIV_CODE'),
					"MONEY_UNIT"	: panelResult.getValue('MONEY_UNIT'),
					"ORDER_UNIT"	: record['ORDER_UNIT'],
					"ORDER_DATE"	: UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE')),
					"STOCK_UNIT"	: record['STOCK_UNIT']
				};
				s_mpo501ukrv_jwService.fnOrderPrice(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)) {
						grdRecord.set('ORDER_UNIT_P', provider['ORDER_P']);
						grdRecord.set('TRNS_RATE'	, provider['TRNS_RATE']);
					}else{
						grdRecord.set('ORDER_UNIT_P', 0);
						grdRecord.set('TRNS_RATE'	, '1');
					}
				});

				UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
			}
		},
		setExcelData: function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('SPEC'			, record['SPEC']);
			grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
			grdRecord.set('ORDER_UNIT'		, record['ORDER_UNIT']);
			grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			grdRecord.set('INSPEC_FLAG'		, record['INSPEC_YN']);
			grdRecord.set('ORDER_UNIT_P'	, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_O'			, record['ORDER_O']);
			grdRecord.set('WH_CODE'			, record['WH_CODE']);
			grdRecord.set('ORDER_UNIT_Q'	, record['ORDER_UNIT_Q']);
			grdRecord.set('PROJECT_NO'		, panelResult.getValue('PROJECT_NO'));
			
			//20180724 추가
			grdRecord.set('ITEM_WIDTH'		, record['ITEM_WIDTH']);
			var itemWidth = record['ITEM_WIDTH'];
			if(itemWidth == 0) {
				itemWidth = 1000;
			}
			grdRecord.set('SQM'				, grdRecord.get('ORDER_UNIT_Q') * record['TRNS_RATE'] * itemWidth / 1000);
			
			//강제로 계산로직 수행
			UniAppManager.app.fnCalOrderAmt(grdRecord, "Q", record['ORDER_UNIT_Q']);
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
//			grdRecord.set('EXCHG_RATE_O'	, record['EXCHG_RATE_O']);
			//화면에 있는 환율을 그리드에 그래로 뿌려줌
			grdRecord.set('EXCHG_RATE_O'	, panelResult.getValue('EXCHG_RATE_O'));
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
			if(!Ext.isEmpty(panelResult.getValue('PROJECT_NO'))) {
				grdRecord.set('PROJECT_NO'	, panelResult.getValue('PROJECT_NO'));
			} else {
				grdRecord.set('PROJECT_NO'	, record['PROJECT_NO']);
			}
			grdRecord.set('COMP_CODE'		, record['COMP_CODE']);
			
			//20180724 추가
			grdRecord.set('ITEM_WIDTH'		, record['ITEM_WIDTH']);
			var itemWidth = record['ITEM_WIDTH'];
			if(itemWidth == 0) {
				itemWidth = 1000;
			}
			grdRecord.set('SQM'				, grdRecord.get('ORDER_UNIT_Q') * record['TRNS_RATE'] * itemWidth / 1000);
			
			//강제로 계산로직 수행
			UniAppManager.app.fnCalOrderAmt(grdRecord, "Q", record['ORDER_UNIT_Q']);
		}
	});

	var orderNoMasterGrid = Unilite.createGrid('s_mpo501ukrv_jwOrderNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
		layout : 'fit',
		excelTitle: '<t:message code="system.label.purchase.poentry" default="발주등록"/>(<t:message code="system.label.purchase.ponosearch2" default="발주번호검색"/>)',
		store: orderNoMasterStore,
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false
		},
		columns: [
			{ dataIndex: 'CUSTOM_NAME'		,  width: 180},
			{ dataIndex: 'ORDER_DATE'		,  width: 133},
			{ dataIndex: 'ORDER_TYPE'		,  width: 93,align:'center'},
			{ dataIndex: 'ORDER_NUM'		,  width: 133},
			{ dataIndex: 'CUSTOM_CODE'		,  width: 80,hidden:true},
			{ dataIndex: 'DEPT_CODE'		,  width: 80,hidden:true},
			{ dataIndex: 'DEPT_NAME'		,  width: 80,hidden:true},
			{ dataIndex: 'ORDER_PRSN'		,  width: 93,align:'center'},
			{ dataIndex: 'AGREE_STATUS'		,  width: 66,align:'center'},
			{ dataIndex: 'AGREE_PRSN'		,  width: 100,hidden:true},
			{ dataIndex: 'AGREE_PRSN_NAME'	,  width: 100,hidden:true},
			{ dataIndex: 'AGREE_DATE'		,  width: 66,hidden:true},
			{ dataIndex: 'MONEY_UNIT'		,  width: 66,hidden:true},
			{ dataIndex: 'RECEIPT_TYPE'		,  width: 66,hidden:true},
			{ dataIndex: 'REMARK'			,  width: 66,hidden:true},
			{ dataIndex: 'EXCHG_RATE_O'		,  width: 66,hidden:true},
			{ dataIndex: 'DRAFT_YN'			,  width: 66,hidden:false},
			{ dataIndex: 'DIV_CODE'			,  width: 66,hidden:true},
			{ dataIndex: 'PROJECT_NO'		,  width: 66},
			{ dataIndex: 'COMP_NAME'		,  width: 200}
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
		  	panelResult.setValues({
				'DIV_CODE'			:record.get('DIV_CODE'),
				'CUSTOM_CODE'		:record.get('CUSTOM_CODE'),
				'CUSTOM_NAME'		:record.get('CUSTOM_NAME'),
				'ORDER_DATE'		:record.get('ORDER_DATE'),
				'ORDER_TYPE'		:record.get('ORDER_TYPE'),
				'ORDER_PRSN'		:record.get('ORDER_PRSN'),
				'ORDER_NUM'			:record.get('ORDER_NUM'),
				'MONEY_UNIT'		:record.get('MONEY_UNIT'),
				'EXCHG_RATE_O'		:record.get('EXCHG_RATE_O'),
				'COMP_NAME'			:record.get('COMP_NAME'),
				'AGREE_STATUS'		:record.get('AGREE_STATUS'),
				'AGREE_PRSN_NAME'	:record.get('AGREE_PRSN_NAME'),
				'DRAFT_YN'			:record.get('DRAFT_YN'),
				'DEPT_CODE'			:record.get('DEPT_CODE'),
				'DEPT_NAME'			:record.get('DEPT_NAME')
          	});
		}
	});

	var otherorderGrid = Unilite.createGrid('s_mpo501ukrv_jwOtherorderGrid', {				//타발주참조
		layout: 'fit',
		store: otherOrderStore,
		uniOpt: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: true,
			onLoadSelectFirst	: false,
			filter: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		selModel: 'rowmodel',
		columns: [
			{ dataIndex: 'CUSTOM_NAME'		,  width: 180},
			{ dataIndex: 'ORDER_DATE'		,  width: 133},
			{ dataIndex: 'ORDER_TYPE'		,  width: 93},
			{ dataIndex: 'ORDER_NUM'		,  width: 133},
			{ dataIndex: 'CUSTOM_CODE'		,  width: 80,hidden:true},
			{ dataIndex: 'ORDER_PRSN'		,  width: 93},
			{ dataIndex: 'AGREE_STATUS'		,  width: 66},
			{ dataIndex: 'AGREE_PRSN'		,  width: 100,hidden:true},
			{ dataIndex: 'AGREE_PRSN_NAME'	,  width: 100,hidden:true},
			{ dataIndex: 'AGREE_DATE'		,  width: 66,hidden:true},
			{ dataIndex: 'MONEY_UNIT'		,  width: 66,hidden:true},
			{ dataIndex: 'RECEIPT_TYPE'		,  width: 66,hidden:true},
			{ dataIndex: 'REMARK'			,  width: 66,hidden:true},
			{ dataIndex: 'EXCHG_RATE_O'		,  width: 66,hidden:true},
			{ dataIndex: 'DRAFT_YN'			,  width: 66,hidden:true},
			{ dataIndex: 'DIV_CODE'			,  width: 66,hidden:true},
			{ dataIndex: 'PROJECT_NO'		,  width: 66},
			{ dataIndex: 'DEPT_CODE'		,  width: 80,hidden:true},
			{ dataIndex: 'DEPT_NAME'		,  width: 80,hidden:true},
			{ dataIndex: 'WH_CODE'			,  width: 80,hidden:true}
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
			s_mpo501ukrv_jwService.selectList2(param, function(provider, response) {
				var records = response.result;
				panelResult.setValue('CUSTOM_CODE'	, record.get('CUSTOM_CODE'));
				panelResult.setValue('CUSTOM_NAME'	, record.get('CUSTOM_NAME'));
				panelResult.setValue('PROJECT_NO'	, record.get('PROJECT_NO'));
			 	panelResult.setValue('ORDER_TYPE'	, record.get('ORDER_TYPE'));

			 	Ext.each(records, function(record,i){
					UniAppManager.app.onNewDataButtonDown();
					masterGrid.setProviderData(record);
				});
				console.log("response",response)
				referOtherOrderWindow.hide();
			});
		}
	});

	
	
	function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.ponosearch2" default="발주번호검색"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [orderNoSearch, orderNoMasterGrid], //orderNomasterGrid],
				tbar:  ['->',{
					itemId : 'saveBtn',
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
					 	orderNoSearch.setValue('DIV_CODE',		panelResult.getValue('DIV_CODE'));
					 	orderNoSearch.setValue('DEPT_CODE',		panelResult.getValue('DEPT_CODE'));
					 	orderNoSearch.setValue('DEPT_NAME',		panelResult.getValue('DEPT_NAME'));
					 	orderNoSearch.setValue('WH_CODE',		panelResult.getValue('WH_CODE'));
					 	orderNoSearch.setValue('CUSTOM_CODE',	panelResult.getValue('CUSTOM_CODE'));
					 	orderNoSearch.setValue('CUSTOM_NAME',	panelResult.getValue('CUSTOM_NAME'));
					 	orderNoSearch.setValue('ORDER_DATE_FR',	UniDate.get('startOfMonth'));
						orderNoSearch.setValue('ORDER_DATE_TO',	panelResult.getValue('ORDER_DATE'));
					 	orderNoSearch.setValue('ORDER_PRSN',	panelResult.getValue('ORDER_PRSN'));
					 	orderNoSearch.setValue('ORDER_TYPE',	panelResult.getValue('ORDER_TYPE'));
					 	if(BsaCodeInfo.gsApproveYN == '2'){
					 		orderNoSearch.setValue('AGREE_STATUS','2');
					 	}else if(BsaCodeInfo.gsApproveYN == '1'){
					 		orderNoSearch.setValue('AGREE_STATUS',panelResult.getValue('AGREE_STATUS'));
					 	}
					 }
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}

	function openOtherOrderWindow() {			//타발주참조
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!referOtherOrderWindow) {
			referOtherOrderWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.otherporefer" default="타발주참조"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [otherorderSearch, otherorderGrid],
				tbar: ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						otherOrderStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmCloseBtn',
					text: '<t:message code="system.label.purchase.ponoapplyclose" default="발주적용 후 닫기"/>',
					handler: function() {
						otherorderGrid.returnData();
						referOtherOrderWindow.hide();
//						directMasterStore1.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.purchase.close" default="닫기"/>',
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
						otherorderSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
					 	otherorderSearch.setValue('DEPT_CODE'		, panelResult.getValue('DEPT_CODE'));
					 	otherorderSearch.setValue('DEPT_NAME'		, panelResult.getValue('DEPT_NAME'));
					 	otherorderSearch.setValue('WH_CODE'			, panelResult.getValue('WH_CODE'));
					 	otherorderSearch.setValue('CUSTOM_CODE'		, panelResult.getValue('CUSTOM_CODE'));
					 	otherorderSearch.setValue('CUSTOM_NAME'		, panelResult.getValue('CUSTOM_NAME'));
					 	otherorderSearch.setValue('ORDER_TYPE'		, panelResult.getValue('ORDER_TYPE'));
					 	otherorderSearch.setValue('ORDER_PRSN'		, panelResult.getValue('ORDER_PRSN'));
						otherorderSearch.setValue('AGREE_STATUS'	, panelResult.getValue('AGREE_STATUS'));
						otherorderSearch.setValue('ORDER_DATE_TO'	, UniDate.get('today'));
						otherorderSearch.setValue('ORDER_DATE_FR'	, UniDate.get('startOfMonth', otherorderSearch.getValue('ORDER_DATE_TO')));

					}
				}
			})
		}
		referOtherOrderWindow.center();
		referOtherOrderWindow.show();
	};

/*	function openMRE100TWindow() {				//구매계획참조
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
						otherorderSearch2.setValue('DIV_CODE', panelResult.getValue("DIV_CODE"));
						otherorderSearch2.setValue('ORDER_PRSN', panelResult.getValue("ORDER_PRSN"));
						otherorderSearch2.setValue('MONEY_UNIT', panelResult.getValue("MONEY_UNIT"));
						otherorderSearch2.setValue('CUSTOM_CODE', panelResult.getValue("CUSTOM_CODE"));
						otherorderSearch2.setValue('CUSTOM_NAME', panelResult.getValue("CUSTOM_NAME"));
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
	};*/

	function openExcelWindow() {				//엑셀 업로드
		if(!UniAppManager.app.checkForNewDetail()) return false;
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUploadWin';
		if(!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				title: '<t:message code="system.label.purchase.excelupdaterefer" default="엑셀업로드참조"/>',
				width: 1080,
				height: 580,
				modal: false,
				excelConfigName: 'mpo501',
				extParam: {
					'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
					'CUSTOM_CODE'	: panelResult.getValue('CUSTOM_CODE'),
					'MONEY_UNIT'	: panelResult.getValue('MONEY_UNIT'),
					'ORDER_DATE'	: UniDate.getDateStr( panelResult.getValue('ORDER_DATE'))
				},
				grids: [{
					itemId: 'grid01',
					title: '<t:message code="system.label.purchase.ponoinfo" default="발주정보"/>',
					useCheckbox: true,
					model : 'excel.mpo501.sheet01',
					readApi: 's_mpo501ukrv_jwService.selectExcelUploadSheet1',
					columns: [
		 				{ dataIndex: 'ITEM_CODE',		width: 120},
		 				{ dataIndex: 'ITEM_NAME',		width: 250},
		 				{ dataIndex: 'TRNS_RATE',       width: 250},
		 				{ dataIndex: 'SPEC',			width: 88},
		 				{ dataIndex: 'STOCK_UNIT',		width: 88},
		 				{ dataIndex: 'ORDER_UNIT',		width: 88, align: 'center'},
		 				{ dataIndex: 'TRNS_RATE',		width: 100},
		 				{ dataIndex: 'INSPEC_YN',		width: 120},
		 				{ dataIndex: 'ORDER_UNIT_P',	width: 88},
		 				{ dataIndex: 'ORDER_O',			width: 120},
		 				{ dataIndex: 'WH_CODE',			width: 120},
		 				{ dataIndex: 'ORDER_UNIT_Q',	width: 100}
					]
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

	
	
	
	
	
	Unilite.Main({
		id: 's_mpo501ukrv_jwApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		}],
		fnInitBinding: function(params) {
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			UniAppManager.setToolbarButtons(['reset','newData','print', 'prev', 'next'], true);
			this.setDefault(params);
			panelResult.setValue('ORDER_PRSN',BsaCodeInfo.gsOrderPrsn);
			if(BsaCodeInfo.gsApproveYN == '1'){
				Ext.getCmp('AGREE_DATE').setHidden(false);
				Ext.getCmp('AGREE_STATUS').setHidden(false);
				Ext.getCmp('AGREE_PRSN_NAME').setHidden(false);
				Ext.getCmp('AGREE_STATUSp').setHidden(false);
			}else if(BsaCodeInfo.gsApproveYN == '2'){
				Ext.getCmp('AGREE_DATE').setHidden(true);
				Ext.getCmp('AGREE_STATUS').setHidden(true);
				Ext.getCmp('AGREE_PRSN_NAME').setHidden(true);
				Ext.getCmp('AGREE_STATUSp').setHidden(true);
				panelResult.setValue('AGREE_STATUS','2');
			}
			s_mpo501ukrv_jwService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			});
			var param = {"SUB_CODE": BsaCodeInfo.gsOrderPrsn};
			s_mpo501ukrv_jwService.userName(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelResult.setValue('AGREE_PRSN',provider['USER_ID']);
					panelResult.setValue('USER_NAME',provider['USER_NAME']);

				}
			});

			if(!Ext.isEmpty(params && params.PGM_ID)){
				if(!Ext.isEmpty(params.ORDER_NUM)){
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
			var fields = panelResult.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) )	{
					item.setReadOnly(false);
				}
				if(item.isPopupField)	{
					var popupFC = item.up('uniPopupField')	;
					popupFC.setReadOnly(false);
				}
			})

			panelResult.setAllFieldsReadOnly(false);
			var orderNo = panelResult.getValue('ORDER_NUM');
			if(Ext.isEmpty(orderNo)) {
				openSearchInfoWindow()
			} else {
				var param= panelResult.getValues();
				panelResult.uniOpt.inLoading=true;
				panelResult.getForm().load({
					params: param,
					success:function()  {
						if(BsaCodeInfo.gsApproveYN == '1' && panelResult.getValue('AGREE_STATUS') == '2') {
							var fields = panelResult.getForm().getFields();
							Ext.each(fields.items, function(item) {
								if(Ext.isDefined(item.holdable) )	{
									item.setReadOnly(true);
								}
								if(item.isPopupField)	{
									var popupFC = item.up('uniPopupField')	;
									popupFC.setReadOnly(true);
								}
							})
						} else {
							var fields = panelResult.getForm().getFields();
							Ext.each(fields.items, function(item) {
								if(Ext.isDefined(item.holdable) )	{
									item.setReadOnly(false);
								}
								if(item.isPopupField)	{
									var popupFC = item.up('uniPopupField')	;
									popupFC.setReadOnly(false);
								}
							})
						}
						panelResult.setAllFieldsReadOnly(true)
						panelResult.uniOpt.inLoading=false;
						
						directMasterStore1.loadStoreRecords();
					},
					failure: function(form, action) {
						panelResult.uniOpt.inLoading=false;
					}
				})
				gsSaveRefFlag = 'Y';
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
			var orderNum		= panelResult.getValue('ORDER_NUM');
			var seq				= directMasterStore1.max('ORDER_SEQ');
			if(!seq) seq = 1;
			else  seq += 1;
			var divCode			= panelResult.getValue('DIV_CODE');
			var cutomCode		= panelResult.getValue('CUSTOM_CODE');
			var controlStatus	= '1';
			var orderQ			= '0';
			var orderP			= '0';
			var orderUnitQ		= '0';
			var unitPriceType	= 'Y';
			var orderUnitP		= '0';
			var orderO			= '0';
			var trnsRate		= '1';
			var instockQ		= '0';
			var dvryDate		= UniDate.get('today');
			var compCode		= panelResult.getValue('COMP_CODE');
			var moneyUnit		= panelResult.getValue('MONEY_UNIT'); // MoneyUnit
			var exchgRateO		= panelResult.getValue('EXCHG_RATE_O');
			var orderLocP		= '0';
			var orderLocO		= '0';
			var whCode			= panelResult.getValue('WH_CODE');
			if(!Ext.isEmpty(panelResult.getValue('PROJECT_NO'))) {
				var projectNo = panelResult.getValue('PROJECT_NO');
			} else {
				var projectNo = '';
			}
			
			var r = {
				ORDER_NUM		: orderNum,
				ORDER_SEQ		: seq,
				DIV_CODE		: divCode,
				CUSTOM_CODE		: cutomCode,
				CONTROL_STATUS	: controlStatus,
				ORDER_Q			: orderQ,
				ORDER_P			: orderP,
				ORDER_UNIT_Q	: orderUnitQ,
				UNIT_PRICE_TYPE	: unitPriceType,
				ORDER_UNIT_P	: orderUnitP,
				ORDER_O			: orderO,
				TRNS_RATE		: trnsRate,
				INSTOCK_Q		: instockQ,
				DVRY_DATE		: dvryDate,
				COMP_CODE		: compCode,
				MONEY_UNIT		: moneyUnit,
				EXCHG_RATE_O	: exchgRateO,
				ORDER_LOC_P		: orderLocP,
				ORDER_LOC_O		: orderLocO,
				WH_CODE			: whCode,
				PROJECT_NO		: projectNo
			};
			masterGrid.createRow(r);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			panelResult.clearForm();
			var fields = panelResult.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) )	{
					item.setReadOnly(false);
				}
				if(item.isPopupField)	{
					var popupFC = item.up('uniPopupField')	;
					popupFC.setReadOnly(false);
				}
			})
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(BsaCodeInfo.gsApproveYN == '1' && Ext.isEmpty(panelResult.getValue('AGREE_PRSN'))) {
				alert('<t:message code="system.message.purchase.message103" default="수동승인일 경우, 승인자는 필수 입력 사항입니다."/>');
				return false;
			}
			directMasterStore1.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('INSPEC_Q') > 1)
				{
					alert('<t:message code="system.message.purchase.message049" default="검사된 수량이 존재합니다. 데이터를 삭제할 수 없습니다."/>');
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
					if(confirm('<t:message code="system.message.purchase.message008" default="전체삭제 하시겠습니까?"/>')) {
						if(record.get('INSPEC_Q') > 1){
								alert('<t:message code="system.message.purchase.message049" default="검사된 수량이 존재합니다. 데이터를 삭제할 수 없습니다."/>');
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
			
			if(panelResult.getValue('AGREE_STATUS') != '2'){
				alert('<t:message code="system.message.purchase.message009" default="미승인건은 인쇄할 수 없습니다."/>');
				return false;
			}
			if(Ext.isEmpty(panelResult.getValue('ORDER_NUM'))){
				alert('<t:message code="system.message.purchase.message104" default="발주정보가 없습니다."/>');
				return false;
			}
			
			var param = panelResult.getValues();
			
            param["USER_LANG"] = UserInfo.userLang;
            param["PGM_ID"]= PGM_ID;
            param["MAIN_CODE"] = 'M030';  //구매용 공통 코드
            param["sTxtValue2_fileTitle"]='발 주 서';
            var win = null;
            if(BsaCodeInfo.gsReportGubun == 'CLIP'){
	        	win = Ext.create('widget.ClipReport', {
	                url: CPATH+'/z_jw/s_mpo501clukrv_jw.do',
	                prgID: 's_mpo501ukrv_jw',
	                extParam: param
	            });
            }else{
	        	win = Ext.create('widget.CrystalReport', {
					url: CPATH+'/matrl/mpo501cukrv.do',
					prgID: 's_mpo501ukrv_jw',
					extParam: param
	            });
            }
			win.center();
			win.show(); 
            
		},
		setDefault: function(params) {
			var param = panelResult.getValues();
			s_mpo501ukrv_jwService.selectOrderPrsn(param, function(provider, response){
				if(!Ext.isEmpty(provider)) {
					panelResult.setValue('ORDER_PRSN', provider[0].SUB_CODE);
					panelResult.getField('ORDER_PRSN').setReadOnly(true);
				} else {
					panelResult.getField('ORDER_PRSN').setReadOnly(false);
				}
			});
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('AGREE_STATUS','1');
			
			//20181207 링크로 넘어온 데이터는 그대로 유지하도록 로직 추가
			if(Ext.isEmpty(params)) {
				panelResult.setValue('ORDER_DATE',new Date());
				panelResult.setValue('MONEY_UNIT',BsaCodeInfo.gsDefaultMoney);
				UniAppManager.app.fnExchngRateO(true);
			}

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
			var field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = orderNoSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			gsSaveRefFlag = 'N';
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelResult.getValue('ORDER_NUM')))	{
				alert('<t:message code="system.label.purchase.sono" default="수주번호"/>'+ ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			return panelResult.setAllFieldsReadOnly(true);
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE')),
				"MONEY_UNIT" : panelResult.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni && !Ext.isEmpty(panelResult.getValue('MONEY_UNIT')) && panelResult.getValue('MONEY_UNIT') != BsaCodeInfo.gsDefaultMoney){
						alert('<t:message code="system.message.purchase.datacheck002" default="환율정보가 없습니다."/>');
					}
					panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
				}

			});
		},
		fnCalOrderAmt: function(rtnRecord, sType, nValue) {
			var dOrderUnitQ	= sType =='Q' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_Q'),0);
			var dOrderUnitP	= sType =='P' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_P'),0);
			var dOrderO		= sType =='O' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_O'),0);
			var dTransRate	= sType =='R' ? nValue : Unilite.nvl(rtnRecord.get('TRNS_RATE'),1);
			var dOrderQ;
			var dOrderP;
			var dExchgRateO	= sType =='X' ? nValue : Unilite.nvl(rtnRecord.get('EXCHG_RATE_O'),1);
			var dOrderLocP	= sType =='L' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_LOC_P'),0);
			var dOrderLocO	= sType =='I' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_LOC_O'),0);
			var dItemWidth	= Unilite.nvl(rtnRecord.get('ITEM_WIDTH'),0);
			if(dItemWidth == 0) {
				dItemWidth = 1000;
			}
			var dSQM		= Unilite.multiply(Unilite.multiply(dOrderUnitQ, dTransRate), dItemWidth) / 1000	//SQM= 발주량  * 입수 * 폭 / 1000 * 단가;
			
			if(sType == 'P' || sType == 'Q'){
				dOrderO = Unilite.multiply(dSQM, dOrderUnitP);							//금액 = SQM * 단가
				rtnRecord.set('SQM'		, dSQM);
				rtnRecord.set('ORDER_O'	, dOrderO);

				dOrderQ = Unilite.multiply(dOrderUnitQ, dTransRate);
				rtnRecord.set('ORDER_Q', dOrderQ);

				dOrderP = dOrderUnitP * dItemWidth / 1000 * dExchgRateO;
				rtnRecord.set('ORDER_P', dOrderP);

				dOrderLocP = Unilite.multiply(dOrderUnitP, dExchgRateO);
				rtnRecord.set('ORDER_LOC_P', dOrderLocP);

				dOrderLocO = Unilite.multiply(dOrderO, dExchgRateO);
				rtnRecord.set('ORDER_LOC_O', dOrderLocO);
				
				rtnRecord.set('SQM', dSQM);
				
			}else if(sType == 'R'){
				dOrderQ = Unilite.multiply(dOrderUnitQ, dTransRate)
				rtnRecord.set('ORDER_Q'	, dOrderQ);
				
				dOrderO = Unilite.multiply(dSQM, dOrderUnitP);							//금액 = SQM * 단가
				rtnRecord.set('ORDER_O'	, dOrderO);

				dOrderP = dOrderUnitP * dItemWidth / 1000 * dExchgRateO;
				rtnRecord.set('ORDER_P', dOrderP);

				dOrderLocO = Unilite.multiply(dOrderO, dExchgRateO);
				rtnRecord.set('ORDER_LOC_O', dOrderLocO);
				
				rtnRecord.set('SQM', dSQM);
				
			}else if(sType == 'O'){
				if(Math.abs(dOrderUnitQ) > '0'){
					dOrderUnitP = Math.abs(dOrderO) / Math.abs(dSQM);
					rtnRecord.set('ORDER_UNIT_P', dOrderUnitP);

					dOrderP = dOrderUnitP * dItemWidth / 1000 * dExchgRateO;
					rtnRecord.set('ORDER_P', dOrderP);
	
					dOrderLocP = Unilite.multiply(dOrderUnitP, dExchgRateO);
					rtnRecord.set('ORDER_LOC_P', dOrderLocP);

					dOrderLocO = Unilite.multiply(dOrderO, dExchgRateO);
					rtnRecord.set('ORDER_LOC_O', dOrderLocO);
					
				}else{
					rtnRecord.set('ORDER_UNIT_P', '0');
					rtnRecord.set('ORDER_P'		, '0');
					rtnRecord.set('ORDER_LOC_P'	, '0');

					dOrderLocO =  Unilite.multiply(dOrderO, dExchgRateO);
					rtnRecord.set('ORDER_LOC_O', dOrderLocO);
				}
				
			} else if(sType == 'X'){
				dOrderLocP = Unilite.multiply(dOrderUnitP, dExchgRateO);
				rtnRecord.set('ORDER_LOC_P', dOrderLocP);

				dOrderLocO = Unilite.multiply(dSQM, dOrderLocP);
				rtnRecord.set('ORDER_LOC_O', dOrderLocO);
				
			} else if(sType == 'L'){
				dOrderLocO = Unilite.multiply(dSQM, dOrderLocP);
				rtnRecord.set('ORDER_LOC_O', dOrderLocO);

				dOrderUnitP = dOrderLocP / dExchgRateO;
				rtnRecord.set('ORDER_UNIT_P', dOrderUnitP);

				dOrderO = Unilite.multiply(dSQM, dOrderUnitP)							//금액 = SQM * 단가
				rtnRecord.set('ORDER_O', dOrderO);

				dOrderQ = Unilite.multiply(dOrderUnitQ, dTransRate);
				rtnRecord.set('ORDER_Q', dOrderQ);

				dOrderP = dOrderUnitP * dItemWidth / 1000 * dExchgRateO;
				rtnRecord.set('ORDER_P', dOrderP);

			} else if(sType == 'I'){
				dOrderLocP = dOrderLocO / dSQM
				rtnRecord.set('ORDER_LOC_P', dOrderLocP);

				dOrderUnitP = dOrderLocP / dExchgRateO;
				rtnRecord.set('ORDER_UNIT_P', dOrderUnitP);

				dOrderO = Unilite.multiply(dSQM, dOrderUnitP)							//금액 = SQM * 단가
				rtnRecord.set('ORDER_O', dOrderO);

				dOrderQ = Unilite.multiply(dOrderUnitQ, dTransRate);
				rtnRecord.set('ORDER_Q', dOrderQ);

				dOrderP = dOrderUnitP * dItemWidth / 1000 * dExchgRateO;
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
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}

				case "ORDER_UNIT" :
					var param = {"ITEM_CODE": record.get('ITEM_CODE'),
						"CUSTOM_CODE": panelResult.getValue('CUSTOM_CODE'),
						"DIV_CODE"	: panelResult.getValue('DIV_CODE'),
						"MONEY_UNIT": panelResult.getValue('MONEY_UNIT'),
						"ORDER_UNIT": newValue,
						"ORDER_DATE": UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE')),
						"STOCK_UNIT": record.get('STOCK_UNIT')
					};
					s_mpo501ukrv_jwService.fnOrderPrice(param, function(provider, response)  {
						if(!Ext.isEmpty(provider)) {
							record.set('ORDER_UNIT_P'	, provider['ORDER_P']);
							record.set('TRNS_RATE'		, provider['TRNS_RATE']);
						}else{
							record.set('ORDER_UNIT_P'	, 0);
							record.set('TRNS_RATE'		, '1');
						}
					});
//					directMasterStore1.fnSumOrderO();
				break;

				case "ORDER_UNIT_Q" : //발주량
					if(newValue <= 0){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "Q", newValue);
//					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_UNIT_P":	// 단가
					if(record.get('UNIT_PRICE_TYPE') == 'Y'){
						if(newValue <= 0){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
						}
					}
					UniAppManager.app.fnCalOrderAmt(record, "P", newValue);
//					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_O" :
					if(newValue <= 0){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "O", newValue);
//					directMasterStore1.fnSumOrderO();
					break;

				case "MONEY_UNIT" :
					if(newValue == BsaCodeInfo.gsDefaultMoney){
						record.set('EXCHG_RATE_O', '1');
					}
					UniAppManager.app.fnCalOrderAmt(record, "X", record.get('EXCHG_RATE_O'));
//					directMasterStore1.fnSumOrderO();
					break;

				case "EXCHG_RATE_O":
					if(newValue <= 0){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "X", newValue);
//					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_LOC_P":
					if(record.get('UNIT_PRICE_TYPE') == 'Y'){
						if(newValue <= 0){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						}
					}
					UniAppManager.app.fnCalOrderAmt(record, "L", newValue);
//					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_LOC_O":
					if(newValue <= 0){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "I", newValue);
//					directMasterStore1.fnSumOrderO();
					break;

				case "DVRY_DATE":
					if(newValue < panelResult.getValue('ORDER_DATE')){
						rv='<t:message code="system.message.purchase.message050" default="납기일은 발주일 보다 크거나 같아야 합니다."/>';
								break;
					}
					break;

				case "CONTROL_STATUS":
					if(oldValue != '8'){
						if (!(newValue < '2' || newValue =='9')){
							rv='<t:message code="system.message.purchase.message035" default="선택할 수 없는 코드입니다."/>';
								break;
						}
					}else{
						rv='<t:message code="system.message.purchase.message035" default="선택할 수 없는 코드입니다."/>';
								break;
					}
					if((panelResult.getValue('ORDER_YN')== '1') && newValue == '9'){
						rv='<t:message code="system.message.purchase.message051" default="승인되지 않은 자료는 강제마감시킬 수 없습니다."/>';
								break;
					}
					break;

				case "TRNS_RATE":
					if(newValue <= 0){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "R", newValue);
//					directMasterStore1.fnSumOrderO();
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
				case "LC_NUM" :
					var tfsRecord = directMasterStore1.data.items[0];
					
					if(!Ext.isEmpty(tfsRecord)){
						tfsRecord.set('TEMP_FOR_SAVE','temp');
						UniAppManager.setToolbarButtons('save', true);
					}
					break;
				case "PROJECT_NO" :
					var detailRecords	= directMasterStore1.data.items;
					
					if(!Ext.isEmpty(detailRecords)){
						detailRecords[0].set('TEMP_FOR_SAVE','temp');
						
						Ext.each(detailRecords, function(detailRecord, i) {
							detailRecord.set('PROJECT_NO', newValue);
						});
						UniAppManager.setToolbarButtons('save', true);
					}
					break;
				case "RECEIPT_TYPE" :
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
