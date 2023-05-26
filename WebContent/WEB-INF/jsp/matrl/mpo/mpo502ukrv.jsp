<%--
'   프로그램명 : 발주등록(외주통합본) (구매자재)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 : 20180514
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="*"  >
	<t:ExtComboStore comboType="BOR120" storeId="inDivList"  /> <!-- 사업장 -->
</t:appConfig>
<t:appConfig pgmId="mpo502ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo502ukrv"  /> <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" /> <!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B038" /> <!-- 결제조건 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" /> <!-- 단가형태 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="Q002" /> <!-- 품질대상여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" /> <!-- 조달구분 -->
	<t:ExtComboStore comboType="OU" />									  <!-- 창고-->
	<t:ExtComboStore comboType="AU" comboCode="M008" /> <!-- 발주승인방식 -->
</t:appConfig>
<script type="text/javascript" >


var SearchInfoWindow;					//조회버튼 누르면 나오는 조회창
var MRP400TWindow;					//구매요청등록 참조
var excelWindow;						//엑셀참조
var referOrderInformationWindow;	//수주정보참조
var referOtherOrderWindow;			//타발주참조(발주이력참조)
var orderHistorylWindow;				//발주이력참조
var searchOrderWindow;  //수주품목 팝업

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
	gsM008Ref3		: '${gsM008Ref3}',
	gsReportGubun	: '${gsReportGubun}',//클립리포트 추가로 인한 리포트 출력 방식 설정(CR:크리스탈 또는 jasper CLIP:클립리포트)
	gsCusomItemYn	: '${gsCusomItemYn}',
	gsBadReceiveYn  : '${gsBadReceiveYn}'
};

var CustomCodeInfo = {
	gsUnderCalBase: ''
};
var gsSaveRefFlag = 'N';				//검색후에만 수정 가능하게 조회버튼 활성화..


var outDivCode = UserInfo.divCode;
var aa = 0;
var hiddenChk = true;
if(BsaCodeInfo.gsBadReceiveYn == 'Y'){
	hiddenChk = false;
}
function appMain() {

	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
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
			read	: 'mpo502ukrvService.selectList',
			update	: 'mpo502ukrvService.updateDetail',
			create	: 'mpo502ukrvService.insertDetail',
			destroy	: 'mpo502ukrvService.deleteDetail',
			syncAll	: 'mpo502ukrvService.saveAll'
		}
	});

	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('Mpo502ukrvModel', {
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.purchase.division" default="사업장"/>'			,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		,type: 'string'},
			{name: 'ORDER_NUM'		,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				,type: 'string',allowBlank: isAutoOrderNum},
			{name: 'ORDER_SEQ'		,text: '<t:message code="system.label.purchase.seq" default="순번"/>'					,type: 'int'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'			,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.purchase.spec" default="규격"/>'				,type: 'string'},
			{name: 'STOCK_UNIT'		,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		,type: 'string'},
			{name: 'LOT_NO'			,text: 'LOT NO'				,type: 'string'},
			/*{name: 'LOT_YN'			 ,text: 'LOT관리여부'			 ,type: 'string', comboType:'AU', comboCode:'A020'}, */
			{name: 'ORDER_UNIT_Q'	,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				,type: 'uniQty' , allowBlank: false}, //, allowBlank: false
			{name: 'ORDER_UNIT'		,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		,type: 'string', allowBlank: false,comboType:'AU',comboCode:'B013',displayField: 'value'},
			{name: 'UNIT_PRICE_TYPE',text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'			,type: 'string',comboType:'AU',comboCode:'M301', allowBlank: false},
			{name: 'MONEY_UNIT'		,text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'		,type: 'string',comboType:'AU',comboCode:'B004', displayField: 'value'},
			{name: 'ORDER_UNIT_P'	,text: '<t:message code="system.label.purchase.price" default="단가"/>'				,type: 'uniFC' , allowBlank: true}, //, allowBlank: false
			{name: 'ORDER_O'		,text: '<t:message code="system.label.purchase.amount" default="금액"/>'				,type: 'uniFC'},
			{name: 'EXCHG_RATE_O'	,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'		,type: 'uniER'},
			{name: 'ORDER_LOC_P'	,text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'			,type: 'uniUnitPrice'},
			{name: 'ORDER_LOC_O'	,text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'			,type: 'uniPrice'},
			{name: 'DVRY_DATE'		,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'		,type: 'uniDate', allowBlank: false},
			{name: 'DVRY_TIME'		,text: '<t:message code="system.label.purchase.deliverytime" default="납기시간"/>'		,type: 'string'},
			{name: 'INIT_DVRY_DATE'	,text: '최초납기일'		,type: 'uniDate'},
			{name: 'WH_CODE'		,text: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>'	,type: 'string',  comboType   : 'OU',  allowBlank: false, parentNames:['IN_DIV_CODE']},
			{name: 'TRNS_RATE'		,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'		,type: 'float', decimalPrecision: 4, format:'0,000.0000'},
			{name: 'ORDER_Q'		,text: '<t:message code="system.label.purchase.inventoryunitqty" default="재고단위량"/>'	,type: 'uniQty'},
			/* {name: 'PO_REQ_NUM'		,text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'			,type: 'string'}, */
			/* {name: 'PO_SER_NO'		,text: '구매요청순번'			,type: 'int'}, */
			{name: 'ORDER_P'		,text: '발주단가(재고)'			,type: 'uniUnitPrice'},
			{name: 'CONTROL_STATUS'	,text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'		,type: 'string',comboType:'AU',comboCode:'M002'},
			{name: 'ORDER_REQ_NUM'	,text: '<t:message code="system.label.purchase.poreserveno" default="발주예정번호"/>'		,type: 'string'},
			{name: 'INSTOCK_Q'		,text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'			,type: 'uniQty'},
			{name: 'INSPEC_FLAG'	,text: '<t:message code="system.label.purchase.qualityyn" default="품질대상여부"/>'		,type: 'string',comboType:'AU',comboCode:'Q002', allowBlank: false},
			{name: 'REMARK'			,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				,type: 'string'},
			{name: 'PROJECT_NO'		,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		,type: 'string'},
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		,type: 'string'},
			{name: 'UPDATE_DB_USER'	,text: 'UPDATE_DB_USER'	,type: 'string'},
			{name: 'UPDATE_DB_TIME'	,text: 'UPDATE_DB_TIME'	,type: 'string'},
			{name: 'TEMP_FOR_SAVE'	,text: 'TEMP_FOR_SAVE'	,type: 'string'},
			{name: 'IN_DIV_CODE'	,text: '<t:message code="system.label.purchase.receiptdivision" default="입고사업장"/>'	,type: 'string', allowBlank: false , comboType: 'BOR120', child:'WH_CODE'},
			{name: 'SO_NUM'			,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'				,type: 'string'},
			{name: 'SO_SEQ'			,text: '<t:message code="system.label.purchase.soseq" default="수주순번"/>'				,type: 'int'},
			{name: 'SO_PLACE'		,text: '<t:message code="system.label.purchase.soplace" default="수주처"/>'			,type: 'string'},
			{name: 'SO_PLACE_NAME'	,text: '<t:message code="system.label.purchase.soplacename" default="수주처명"/>'		,type: 'string'},
			{name: 'SO_ITEM_NAME'	,text: '<t:message code="system.label.purchase.soitemname" default="수주품목명"/>'		,type: 'string'},
			{name: 'MODIFY_AUTH_CHK',text: 'MODIFY_AUTH_CHK'			,type: 'string'},
			{name: 'SUPPLY_TYPE'	,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'	,type: 'string', comboType:'AU', comboCode:'B014', editable:false},
			{name: 'OUT_DIV_CODE'	,text: '<t:message code="system.label.purchase.outdivcode" default="출고사업장"/>'		,type:'string', comboType: 'BOR120'},
			{name: 'OUT_DATE'		,text: '<t:message code="system.label.purchase.issuedate" default="출고일"/>'			,type:'uniDate'},
			{name: 'BAD_RETURN_Q'	,text: '<t:message code="system.label.purchase.defect" default="불량"/><t:message code="system.label.purchase.returnqty" default="반품수량"/>'		,type:'uniQty'}
		]
	});

	Unilite.defineModel('orderNoMasterModel', {	 //조회버튼 누르면 나오는 조회창
		fields: [
			{name: 'CUSTOM_NAME'		, text: '<t:message code="Mpo501.label.CUSTOM_NAME" default="거래처"/>'		, type: 'string'},
			{name: 'ORDER_DATE'			, text: '<t:message code="Mpo501.label.ORDER_DATE" default="발주일"/>'			, type: 'uniDate'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="Mpo501.label.ORDER_TYPE" default="발주유형"/>'		, type: 'string',comboType:'AU',comboCode:'M001'},
			{name: 'ORDER_NUM'			, text: '<t:message code="Mpo501.label.ORDER_NUM" default="발주번호"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="Mpo501.label.CUSTOM_CODE" default="거래처코드"/>'		, type: 'string'},
			{name: 'DEPT_CODE'			, text: '<t:message code="Mpo501.label.DEPT_CODE" default="부서코드"/>'			, type: 'string'},
			{name: 'DEPT_NAME'			, text: '<t:message code="Mpo501.label.DEPT_NAME" default="부서명"/>'			, type: 'string'},
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

	// 검색 모델(디테일)
	Unilite.defineModel('orderNoDetailPopModel', {//조회버튼 누르면 나오는 조회창
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="Mpo501.label.DIV_CODE" default="사업장"/>'			, type: 'string',comboType:'BOR120'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="Mpo501.label.CUSTOM_CODE" default="거래처코드"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="Mpo501.label.CUSTOM_NAME" default="거래처"/>'		, type: 'string'},
			{name: 'ORDER_DATE'			, text: '<t:message code="Mpo501.label.ORDER_DATE" default="발주일"/>'			, type: 'uniDate'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="Mpo501.label.ORDER_TYPE" default="발주유형"/>'		, type: 'string',comboType:'AU',comboCode:'M001'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.item" default="품목"/>'				, type:'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'			, type:'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type:'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				, type:'uniQty'},
			{name: 'ORDER_P'			, text: '<t:message code="system.label.purchase.pounitprice" default="발주단가"/>'		, type:'uniUnitPrice'},
			{name: 'ORDER_O'			, text: '<t:message code="system.label.product.poamount" default="발주액"/>'			, type:'uniPrice'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.pono" default="발주번호"/>'			, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'									,type:'integer'},
			{name: 'PROJECT_NO'			, text: '<t:message code="Mpo501.label.PROJECT_NO" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="Mpo501.label.ORDER_PRSN" default="구매담당"/>'		, type: 'string',comboType:'AU',comboCode:'M201'},
			{name: 'AGREE_STATUS'		, text: '<t:message code="Mpo501.label.AGREE_STATUS" default="승인"/>'		, type: 'string',comboType:'AU',comboCode:'M007'},
			{name: 'AGREE_PRSN'			, text: '<t:message code="Mpo501.label.AGREE_PRSN" default="승인자"/>'			, type: 'string'},
			{name: 'AGREE_PRSN_NAME'	, text: '<t:message code="Mpo501.label.AGREE_PRSN_NAME" default="승인자명"/>'	, type: 'string'},
			{name: 'AGREE_DATE'			, text: '<t:message code="Mpo501.label.AGREE_DATE" default="승인일"/>'			, type: 'uniDate'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="Mpo501.label.MONEY_UNIT" default="화폐"/>'			, type: 'string'}
		]
	});

	Unilite.defineModel('Mrp400ukrvModel', {	   // 구매요청등록 참조
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'					,type: 'string',child:'WH_CODE'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.custom" default="거래처"/>'						,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'				,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'						,type: 'string'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				,type: 'string', allowBlank: false,comboType:'AU',comboCode:'B013',displayField: 'value'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'				,type: 'string'},
			{name: 'SUPPLY_TYPE'		,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'	,type: 'string', comboType:'AU', comboCode:'B014'},
			{name: 'ORDER_P'			,text: '<t:message code="system.label.purchase.price" default="단가"/>'						,type: 'uniUnitPrice', allowBlank: false},
			{name: 'ORDER_Q'			,text: '구매요청량'			  ,type: 'uniQty', allowBlank: false},
			{name: 'ORDER_O'			,text: '<t:message code="system.label.purchase.amount" default="금액"/>'						,type: 'uniPrice'},
			{name: 'CSTOCK'				,text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'				,type: 'uniQty'},
			{name: 'PURCH_LDTIME'		,text: '구매LT'			   ,type: 'uniQty'},
			{name: 'REMARK'				,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'						,type: 'string'},
			{name: 'MRP_CONTROL_NUM'	,text: 'MPR번호'			  ,type: 'string'},
			{name: 'ORDER_REQ_NUM'		,text: '<t:message code="system.label.purchase.poreserveno" default="발주예정번호"/>'				,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'						,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER'	 ,type: 'string'},
			{name: 'UPDATE_DB_TIME'		,text: 'UPDATE_DB_TIME'	 ,type: 'string'},
			{name: 'IN_DIV_CODE'		,text: '<t:message code="system.label.purchase.receiptdivision" default="입고사업장"/>'			,type: 'string', allowBlank: true, store: Ext.data.StoreManager.lookup('inDivList')}
		]
	});

	Unilite.defineModel('mpo502ukrvOTHERModel', {	//타발주참조
		fields: [
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'				, type: 'string'},
			{name: 'ORDER_DATE'			, text: '<t:message code="Mpo501.label.ORDER_DATE" default="발주일"/>'							, type: 'uniDate'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'						, type: 'string',comboType:'AU',comboCode:'M001'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'						, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'						, type: 'string'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'			, type: 'string',comboType:'AU',comboCode:'M201'},
			{name: 'AGREE_STATUS'		, text: '<t:message code="system.label.purchase.approved" default="승인"/>'						, type: 'string',comboType:'AU',comboCode:'M007'},
			{name: 'AGREE_PRSN'			, text: '<t:message code="system.label.purchase.approvaluser" default="승인자"/>'				, type: 'string'},
			{name: 'AGREE_PRSN_NAME'	, text: '<t:message code="system.label.purchase.approvalusername" default="승인자명"/>'		, type: 'string'},
			{name: 'AGREE_DATE'			, text: '<t:message code="system.label.purchase.approvaldate" default="승인일"/>'				, type: 'uniDate'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'						, type: 'string'},
			{name: 'RECEIPT_TYPE'			, text: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>'		, type: 'string'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'							, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'					, type: 'string'},
			{name: 'DRAFT_YN'				, text: '<t:message code="system.label.purchase.drafting" default="기안여부"/>'					, type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'						, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'DEPT_CODE'				, text: '<t:message code="system.label.purchase.departmencode" default="부서코드"/>'			, type: 'string'},
			{name: 'DEPT_NAME'				, text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'			, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'						, type: 'string'}
		]
	});


	Unilite.defineModel('orderHistoryModel', {	   //발주이력참조모델
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'					,type: 'string',child:'WH_CODE'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.custom" default="거래처"/>'						,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'				,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'						,type: 'string'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				,type: 'string', allowBlank: false,comboType:'AU',comboCode:'B013',displayField: 'value'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'				,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						,type: 'string'},
			{name: 'ORDER_SEQ'		,text: '<t:message code="system.label.purchase.seq" default="순번"/>'					,type: 'int'},
			{name: 'IN_DIV_CODE'		,text: '<t:message code="system.label.purchase.receiptdivision" default="입고사업장"/>'			,type: 'string', allowBlank: true, store: Ext.data.StoreManager.lookup('inDivList')},
			{name: 'ORDER_UNIT_Q'	,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				,type: 'uniQty' , allowBlank: false}, //, allowBlank: false
			{name: 'ORDER_UNIT_P'	,text: '<t:message code="system.label.purchase.price" default="단가"/>'				,type: 'uniFC' , allowBlank: false}, //, allowBlank: false
			{name: 'ORDER_O'		,text: '<t:message code="system.label.purchase.amount" default="금액"/>'				,type: 'uniFC'},
			{name: 'ORDER_Q'		,text: '<t:message code="system.label.purchase.inventoryunitqty" default="재고단위량"/>'	,type: 'uniQty'},
			{name: 'ORDER_P'		,text: '발주단가(재고)'			,type: 'uniUnitPrice'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="Mpo501.label.ORDER_TYPE" default="발주유형"/>'		, type: 'string',comboType:'AU',comboCode:'M001'},
			{name: 'TRNS_RATE'		,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'		,type: 'float', decimalPrecision: 4, format:'0,000.0000'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'						, type: 'string'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'							, type: 'string'},
			{name: 'ORDER_DATE'			, text: '<t:message code="Mpo501.label.ORDER_DATE" default="발주일"/>'			, type: 'uniDate'}
		]
	});


// 엑셀참조
	Unilite.Excel.defineModel('excel.mpo502.sheet01', {
		fields: [
			{name: 'ITEM_CODE'		,text: '품목코드*'		,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.purchase.spec" default="규격"/>'				,type: 'string'},
			{name: 'ORDER_UNIT'		,text: '구매단위*'		,type: 'string'},
			{name: 'STOCK_UNIT'		,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		,type: 'string'},
			{name: 'TRNS_RATE'		,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'		,type: 'float', decimalPrecision: 4, format:'0,000.0000'},
			{name: 'ORDER_UNIT_Q'	,text: '발주량*'		,type: 'uniQty'},
			{name: 'ORDER_UNIT_P'	,text: '<t:message code="system.label.purchase.price" default="단가"/>'				,type: 'uniUnitPrice'},
			{name: 'DVRY_DATE'		,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'		,type: 'uniDate'},
			{name: 'INSPEC_FLAG'	,text: '<t:message code="system.label.purchase.qualityyn" default="품질대상여부"/>'		,type: 'string'},
			{name: 'WH_CODE'		,text: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>'	,type: 'string'},
			{name: 'OREDR_P'		,text: '발주단가(재고)'	,type: 'uniUnitPrice'}
		]
	});

	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';

		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.DIV_CODE = panelResult.getValue('DIV_CODE');
		}
		if(!excelWindow) {
			excelWindow =  Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
					modal: false,
					excelConfigName: 'mpo502ukrv',
					extParam: {
						'PGM_ID': 'mpo502ukrv',
						'DIV_CODE'  : panelResult.getValue('DIV_CODE')
					},
					grids: [{
							itemId: 'grid01',
							title: '발주등록엑셀참조',
							useCheckbox: true,
							model : 'excel.mpo502.sheet01',
							readApi: 'mpo502ukrvService.selectExcelUploadSheet1',
							columns: [
								{dataIndex: 'ITEM_CODE'		, width: 100},
								{dataIndex: 'ITEM_NAME'		, width: 150},
								{dataIndex: 'SPEC'			, width: 100},
								{dataIndex: 'ORDER_UNIT'	, width: 80},
								{dataIndex: 'STOCK_UNIT'	, width: 80},
								{dataIndex: 'TRNS_RATE'		, width: 80},
								{dataIndex: 'ORDER_UNIT_Q'	, width: 80},
								{dataIndex: 'ORDER_UNIT_P'	, width: 80},
								{dataIndex: 'DVRY_DATE'		, width: 80},
								{dataIndex: 'INSPEC_FLAG'	, width: 80},
								{dataIndex: 'WH_CODE'		, width: 80},
								{dataIndex: 'OREDR_P'		, width: 80}
							]
					}],
					listeners: {
						close: function() {
							this.hide();
						}
					},
					onApply:function()  {
						var grid = this.down('#grid01');
						var records = grid.getSelectionModel().getSelection();
						Ext.each(records, function(record,i){
							UniAppManager.app.onNewDataButtonDown();
							masterGrid.setExcelData(record.data);
						});
						grid.getStore().removeAll();
						this.hide();
						/*
							excelWindow.getEl().mask('로딩중...','loading-indicator');	 ///////// 엑셀업로드 최신로직
							var me = this;
							var grid = this.down('#grid01');
							var records = grid.getStore().getAt(0);
							var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
							mpo502ukrvService.selectExcelUploadSheet1(param, function(provider, response){
								var store = masterGrid.getStore();
								var records = response.result;
								var countDate = UniDate.getDbDateStr(masterForm.getValue('COUNT_DATE')).substring(0, 6);
//							  var monthDate = countDate.substring(0,4) + '.' + countDate.substring(4,6);
								for(var i=0; i<records.length; i++) {
									records[i].BASIS_YYYYMM = countDate;
								}
								store.insert(0, records);
								console.log("response",response)
								excelWindow.getEl().unmask();
								grid.getStore().removeAll();
								me.hide();
							});
							*/
					}
			 });
		}
		excelWindow.center();
		excelWindow.show();
	}
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mpo502ukrvMasterStore1',{
		model: 'Mpo502ukrvModel',
		uniOpt: {
			isMaster: true,		 // 상위 버튼 연결
			editable: true,		 // 수정 모드 사용
			deletable: true,			// 삭제 가능 여부
			allDeletable: true,
			useNavi: false			  // prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records[0].data.ORDER_NUM)){
					//Ext.getCmp('ORDER_PRINT').setDisabled(false);
					if(UserInfo.deptName == '시너지이노베이션'){
						UniAppManager.setToolbarButtons(['print'], true);
					}
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
			var isErr = false;
			console.log("list:", list);
			Ext.each(list, function(record, index) {
				if(record.get('SUPPLY_TYPE') != '4' && record.get('UNIT_PRICE_TYPE') != 'N'){
					var msg = '';
					if(record.get('ORDER_UNIT_P') == 0){
                        msg += '<t:message code="system.label.purchase.price" default="단가"/> ' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>';
                	}
					if(msg != ''){
                        alert((index + 1) +'<t:message code="system.message.purchase.message026" default="행의 입력값을 확인 해주세요."/>' +'\n'+ msg);
                        isErr = true;
                        return false;
                    }
				}
				if(Ext.isEmpty(record.get('INIT_DVRY_DATE')))	{
					record.set('INIT_DVRY_DATE', record.get('DVRY_DATE'));
				}
			})
			if(isErr) {
            	return false;
            }
			var paramMaster= panelResult.getValues();   //syncAll 수정

			if(BsaCodeInfo.gsApproveYN=='1') {	// 발주승인이 예 일 경우
				if(Ext.isEmpty(paramMaster.AGREE_PRSN)) {
					alert('<t:message code="system.message.purchase.message058" default="승인자는 필수 입니다."/>');

					return false;
				}
			}

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("ORDER_NUM", master.ORDER_NUM);
						 if(!Ext.isEmpty(master.ORDER_NUM)){
								//Ext.getCmp('ORDER_PRINT').setDisabled(false);
							 if(UserInfo.deptName == '시너지이노베이션'){
							 	UniAppManager.setToolbarButtons(['print'], true);
							 }
							}
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
				var grid = Ext.getCmp('mpo502ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		fnSumOrderO: function() {
			console.log("=============Exec fnOrderAmtSum()");
			var sSumOrderO = Ext.isNumeric(this.sum('ORDER_O')) ? this.sum('ORDER_O'):0;
			var sSumOrderLocO = Ext.isNumeric(this.sum('ORDER_LOC_O')) ? this.sum('ORDER_LOC_O'):0;
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
			useNavi : false		 // prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 'mpo502ukrvService.selectOrderNumMasterList'
			}
		},
		loadStoreRecords : function()   {
			var param= orderNoSearch.getValues();
			var authoInfo = pgmInfo.authoUser;			  //권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;			  //부서코드
			if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var orderNoDetailPopStore = Unilite.createStore('orderNoDetailPopStore', {//조회버튼 누르면 나오는 조회창
		model	: 'orderNoDetailPopModel',
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
				read: 'mpo502ukrvService.selectOrderNumDetail'
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
	var otherOrderStore = Unilite.createStore('mpo502ukrvOtherOrderStore', {//타발주참조
		model: 'mpo502ukrvOTHERModel',
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
				read: 'mpo502ukrvService.selectOrderNumMasterList2'
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

	var otherOrderStore2 = Unilite.createStore('mpo502ukrvOtherOrderStore2', {	 // 구매요청등록참조
		model: 'Mrp400ukrvModel',
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
				read: 'mpo502ukrvService.selectMrp400tList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
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
									if( record.data['ORDER_REQ_NUM'] == item.data['ORDER_REQ_NUM'] )
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

	var orderHistoryStore = Unilite.createStore('mpo502ukrvOrderHistoryStore', {	 // 발주이력참조스토어
		model: 'orderHistoryModel',
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
				read: 'mpo502ukrvService.selectOrderHistoryList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				 if(successful)  {
				/*    var masterRecords = directMasterStore1.data.filterBy(orderHistoryStore.filterNewOnly);
				   var deleteRecords = new Array();

				   if(masterRecords.items.length > 0)   {
					console.log("store.items :", store.items);
					console.log("records", records);

					   Ext.each(records,
							function(item, i)   {
								Ext.each(masterRecords.items, function(record, i)   {
										console.log("record :", record);
									if( record.data['ORDER_REQ_NUM'] == item.data['ORDER_REQ_NUM'] )
									{
										deleteRecords.push(item);
									}
								});
						});
					   store.remove(deleteRecords);
				   } */
				}
			}
		},
		loadStoreRecords : function()   {
			var param= orderHistorySearch.getValues();
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

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
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
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('ORDER_PRSN','');
				}
			}
		},
		Unilite.popup('CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			holdable: 'hold',
			allowBlank: false,
			listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
								panelResult.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
								//panelResult.setValue('EXCHG_RATE_O', '1');
								UniAppManager.app.fnExchngRateO();
								if(panelResult.getValue('MONEY_UNIT') == BsaCodeInfo.gsDefaultMoney){
								  panelResult.setValue('ORDER_TYPE',  '1');
								}else	{
								  panelResult.setValue('ORDER_TYPE',  '5');
								}
		
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
			fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name:'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M001',
			allowBlank:false,
			holdable: 'hold',
			colspan: 2
		},/* {
			xtype: 'container',
			layout : {type : 'uniTable'},
			tdAttrs: {align: 'right'},
			padding: '0 40 0 400',
			items:[
				{
					xtype: 'button',
					text: '발주서 출력',
					width: 110,
					id: 'ORDER_PRINT',
					handler : function(records, grid, record) {
						if(Ext.isEmpty(panelResult.getValue('ORDER_NUM'))){
							return false;
						}
						if(UniAppManager.app._needSave())  {
							 alert(Msg.sMB154);//먼저 저장하십시오.
						} else {
								var param = panelResult.getValues();
								var win = Ext.create('widget.ClipReport', {
									url: CPATH+'/matrl/mpo502clukrv.do',
									prgID: 'mpo502ukrv',
									extParam: param
								});
								win.center();
								win.show();
						}
					}
				}]
		}, */{
			fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype: 'uniDatefield',
			name: 'ORDER_DATE',
			value: UniDate.get('today'),
			allowBlank:false,
			holdable: 'hold'/* ,
			colspan: 2 */
		},{
			fieldLabel:'승인일',
			id:'AGREE_DATEr',
			name: 'AGREE_DATE',
			xtype: 'uniDatefield',
//			value: UniDate.get('today'),
			readOnly:true
		},{
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name:'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M201',
			colspan: 2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					var param = {"SUB_CODE": newValue};
					mpo502ukrvService.userName(param, function(provider, response)  {
						if(!Ext.isEmpty(provider)){
							panelResult.setValue('AGREE_PRSN', provider['USER_ID']);
							panelResult.setValue('AGREE_PRSN_NAME', provider['USER_NAME']);
						}else{
							panelResult.setValue('AGREE_PRSN_NAME', '');
							panelResult.setValue('AGREE_PRSN', '');
						}
					});
				},beforequery:function( queryPlan, eOpts )   {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('refCode4').indexOf(panelResult.getValue('DIV_CODE')) != -1 ;
						});
					}else{
						store.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>',
			id:'AGREE_STATUSr',
			name:'AGREE_STATUS',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M007',
			readOnly: true,
			holdable: 'hold'
		},
		Unilite.popup('USER_SINGLE', {
			fieldLabel: '<t:message code="system.label.purchase.approvaluser" default="승인자"/>',
			textFieldWidth: 150,
			textFieldOnly: false,
			valueFieldName:'AGREE_PRSN',
			textFieldName:'AGREE_PRSN_NAME',
			id: 'AGREE_PRSN_NAMEr',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						panelResult.setValue('AGREE_PRSN', records[0]["USER_ID"]);
					},
					scope: this
				},
				onClear: function(type) {
					panelResult.setValue('AGREE_PRSN', '');
				}
			}
		}),{
			xtype: 'component'//,
			//colspan: 4,
			//tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' }
		},{
			fieldLabel:'<t:message code="system.label.purchase.pono" default="발주번호"/>',
			name: 'ORDER_NUM',
			xtype: 'uniTextfield',
			readOnly: isAutoOrderNum
		},{
			fieldLabel:'<t:message code="system.label.purchase.lcno" default="L/C번호"/>',
			name: 'LC_NUM',
			xtype: 'uniTextfield'
		},
		Unilite.popup('PROJECT',{
			fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
			textFieldWidth: 150,
			validateBlank: false,
			textFieldName:'PROJECT_NO',
			itemId:'project',
			colspan: 2,
			listeners: {
				applyextparam: function(popup){
//					popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
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
				blur: function( field, The, eOpts ) {
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
			listeners:{
				change:function(field, newValue, oldValue)	{
					var dataList = directMasterStore1.getData();

					if(!Ext.isEmpty(dataList) && !Ext.isEmpty(newValue)) {	//20201005 추가:  && !Ext.isEmpty(newValue) 추가 - 초기화 시 오류 발생하여 수정
						Ext.each(dataList.items, function(record, idx){
							record.set('EXCHG_RATE_O', newValue);
							UniAppManager.app.fnCalOrderAmt(record, "X", newValue);
						})
					}
					directMasterStore1.fnSumOrderO();
				}
			}
		},{
			fieldLabel: '결제방법',
			name:'RECEIPT_TYPE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B038',
			colspan: 2
		},{
			fieldLabel:'<t:message code="system.label.purchase.remarks" default="비고"/>',
			name: 'REMARK',
			xtype: 'uniTextfield',
			width: 815,
			colspan:3
		},{
			fieldLabel:'자사총액',
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
		api: {
			load: 'mpo502ukrvService.selectMaster',
			submit: 'mpo502ukrvService.syncForm'
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

	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items: [{
			fieldLabel: '<t:message code="Mpo501.label.DIV_CODE" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			value: UserInfo.divCode,
			child:'WH_CODE'
		},
			Unilite.popup('CUST', {
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								orderNoSearch.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									orderNoSearch.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelResult.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									orderNoSearch.setValue('CUSTOM_CODE', '');
								}
							},
				            applyextparam: function(popup){
				                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
		                	}
					}
		}),
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
			xtype:'uniTextfield',
			fieldLabel:'<t:message code="system.label.purchase.pono" default="발주번호"/>',
			name:'ORDER_NUM'
		},{
			fieldLabel: '<t:message code="Mpo501.label.ORDER_PRSN" default="구매담당"/>',
			name:'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M201'
		},{
			fieldLabel: '<t:message code="Mpo501.label.AGREE_STATUS2" default="승인여부"/>',
			id:'AGREE_STATUSp',
			name:'AGREE_STATUS',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M007'
		},{
			fieldLabel	: '<t:message code="system.label.purchase.inquiryclass" default="조회구분"/>',
			xtype		: 'uniRadiogroup',
			name		: 'RDO_TYPE',
			allowBlank	: false,
			width		: 235,
			items		: [
				{boxLabel:'<t:message code="system.label.purchase.master" default="마스터"/>', name:'RDO_TYPE', inputValue:'master', checked:true},
				{boxLabel:'<t:message code="system.label.purchase.detail" default="디테일"/>', name:'RDO_TYPE', inputValue:'detail'}
			],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue.RDO_TYPE=='detail') {
						if(orderNoMasterGrid) orderNoMasterGrid.hide();
						if(orderNoDetailPopGrid) orderNoDetailPopGrid.show();
					} else {
						if(orderNoDetailPopGrid) orderNoDetailPopGrid.hide();
						if(orderNoMasterGrid) orderNoMasterGrid.show();
					}
				}
			}
		},
		Unilite.popup('PROJECT',{
			fieldLabel: '<t:message code="Mpo501.label.PROJECT_NO" default="프로젝트번호"/>',
			name:'PROJECT_NO',
			textFieldWidth: 170,
			validateBlank: false
		})]
	});

	var otherorderSearch2 = Unilite.createSearchForm('otherorderForm2', {	// 구매요청등록 참조
		layout: {type : 'uniTable', columns : 3},
		items :[{
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
		}, Unilite.popup('PROJECT',{
			fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
			DBvalueFieldName: 'PJT_CODE',
			DBtextFieldName: 'PJT_NAME',
			validateBlank: false,
			colspan: 2,
//		  allowBlank:false,
//			textFieldOnly: false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup) {
				},
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}),
		Unilite.popup('CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							otherorderSearch2.setValue('CUSTOM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								otherorderSearch2.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							otherorderSearch2.setValue('CUSTOM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								otherorderSearch2.setValue('CUSTOM_CODE', '');
							}
						},
			            applyextparam: function(popup){
			                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
			                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
			            	}
				}
		}),
		Unilite.popup('ORDER_NUM',{
			fieldLabel: '<t:message code="system.label.purchase.sono" default="수주번호"/>',
			valueFieldName: 'ORDER_NUM',
			textFieldName: 'ORDER_NUM',
//		  allowBlank:false,
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
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
//				  popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
				}
			}
		}),{
			name: 'SUPPLY_TYPE',
			fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B014'
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

	var orderHistorySearch = Unilite.createSearchForm('orderHistoryForm', {	// 발주이력조회폼
		layout: {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
	//		holdable: 'hold',
			value: UserInfo.divCode,
			child:'WH_CODE',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							orderHistorySearch.setValue('CUSTOM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								orderHistorySearch.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							orderHistorySearch.setValue('CUSTOM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								orderHistorySearch.setValue('CUSTOM_CODE', '');
							}
						},
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
		},{
			fieldLabel: '<t:message code="Mpo501.label.ORDER_PRSN" default="구매담당"/>',
			name:'ORDER_PRSN',
			readOnly: false,
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M201'
		},{
			fieldLabel: '<t:message code="Mpo501.label.AGREE_STATUS2" default="승인여부"/>',
			name: 'AGREE_STATUS',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M007'
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

	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid= Unilite.createGrid('mpo502ukrvGrid', {
		region: 'center' ,
		layout: 'fit',
		excelTitle: '발주등록',
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
		tbar: [/*{//20190724 해당기능 사용 안 함 (주석)
			itemId: 'requestBtn',
			text: '<div style="color: blue">수주정보참조</div>',
			handler: function() {
				openOrderInformationWindow();
			}
		},*/{
			xtype : 'uniDatefield',
			name  : 'DVRY_DATE',
			id    : 'changeDateAllField',
			labelWidth : 40,
			width : 140,
			fieldLabel :'<t:message code="system.label.purchase.deliverydate" default="납기일"/>'
		},{
			itemId: 'changeDateBtn',
			text: '<t:message code="system.label.purchase.changeselection" default="일괄변경"/>',
			hidden: false,
			handler: function() {
				var dvryDate = Ext.getCmp("changeDateAllField").getValue();
				//20210820 추가: 체크로직 추가
				if(Ext.isEmpty(dvryDate)) {
					Unilite.messageBox('납기일을 입력 후 진행하시오.');
					Ext.getCmp("changeDateAllField").focus();
					return false;
				}
				if(panelResult.getValue('ORDER_DATE') > dvryDate) {
					Unilite.messageBox('납기일은 발주일 이전일 수 없습니다.');
					Ext.getCmp("changeDateAllField").setValue('');
					Ext.getCmp("changeDateAllField").focus();
					return false;
				}
				var dataList = directMasterStore1.getData();
				Ext.each(dataList.items, function(record, idx){
					record.set('DVRY_DATE', dvryDate);
					if(Ext.isEmpty(record.get('ORDER_NUM')))  {
						record.set('INIT_DVRY_DATE', dvryDate);
					}
				});
			}
		},'-',{
			itemId: 'otherorderBtn3',
			text: '<div style="color: blue"><t:message code="system.label.purchase.orderhistoryrefer" default="발주이력참조"/></div>',
			hidden: false,
			handler: function() {
				openOrderHistoryWindow();
			}
		},{ //발주내역 개별 선택이 아니라 선택한 발주번호에 대한 것만 가져오는 것이라 사용 안함
			itemId: 'otherorderBtn1',
			text: '<div style="color: blue"><t:message code="system.label.purchase.orderhistoryrefer" default="발주이력참조"/></div>',
			hidden: true,
			handler: function() {
				openOtherOrderWindow();
			}
		},{
			itemId: 'excelBtn',
			text: '<div style="color: blue">엑셀참조</div>',
			handler: function() {
				if(!panelResult.getInvalidMessage()) return;	//필수체크
				openExcelWindow();
			}
		},{
			itemId: 'otherorderBtn2',
			text: '<div style="color: blue">구매요청등록참조</div>',
			handler: function() {
				openMRP400TWindow();
			}
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
			{dataIndex:'DIV_CODE'			, width: 93 ,hidden: true},
			{dataIndex:'CUSTOM_CODE'		, width: 93 ,hidden: true},
			{dataIndex:'ORDER_NUM'			, width: 110 ,hidden: true},
			{dataIndex:'ORDER_SEQ'			, width: 40 , align: 'center'/*,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.total" default="총계"/>');
			}*/},
			{dataIndex:'IN_DIV_CODE'		, width: 100 ,hidden: false },
			{dataIndex:'ITEM_CODE'			, width: 130,
			 editor: Unilite.popup('DIV_PUMOK_G', {
						textFieldName: 'ITEM_CODE',
						DBtextFieldName: 'ITEM_CODE',
						useBarcodeScanner: false,
						autoPopup: true,
						listeners: {
							'onSelected': {
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
								var divCode = record.get('IN_DIV_CODE');
								popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
								popup.setExtParam({'DIV_CODE': divCode});
								if(BsaCodeInfo.gsCusomItemYn == 'Y'){
									popup.setExtParam({'CUSTOM_ORDER_PUMOK_YN': 'Y'});
									popup.setExtParam({'CUSTOM_CODES': panelResult.getValue('CUSTOM_CODE')});
								}
							}
						}
				})
			},
			{dataIndex:'ITEM_NAME'			, width: 150,
			 editor: Unilite.popup('DIV_PUMOK_G', {
						autoPopup: true,
						listeners: {
							'onSelected': {
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
								var divCode = record.get('IN_DIV_CODE');
									popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
									popup.setExtParam({'DIV_CODE': divCode});
									if(BsaCodeInfo.gsCusomItemYn == 'Y'){
										popup.setExtParam({'CUSTOM_ORDER_PUMOK_YN': 'Y'});
										popup.setExtParam({'CUSTOM_CODES': panelResult.getValue('CUSTOM_CODE')});
									}
							}
						}
				})
			},
			{dataIndex:'SPEC'				, width: 138 },
//			{dataIndex:'LOT_YN'				, width:120, hidden: true },
			{dataIndex:'STOCK_UNIT'			, width: 88, align: 'center'},
			{dataIndex:'TRNS_RATE'			, width: 80, xtype: 'uniNnumberColumn' },
			{dataIndex:'ORDER_UNIT'			, width: 88, align: 'center'},
			{dataIndex:'MONEY_UNIT'			, width: 73 ,hidden : true},
			{dataIndex:'ORDER_UNIT_Q'		, width: 93, summaryType: 'sum' },
			{dataIndex:'ORDER_UNIT_P'		, width: 100, summaryType: 'sum' },
			{dataIndex:'ORDER_O'			, width: 100, summaryType: 'sum' },
			{dataIndex:'EXCHG_RATE_O'		, width: 80 ,hidden : true},
			{dataIndex:'ORDER_LOC_P'		, width: 93 ,hidden : true},
			{dataIndex:'ORDER_LOC_O'		, width: 106 ,hidden : true},
			{dataIndex:'DVRY_DATE'			, width: 80 },
			{dataIndex:'DVRY_TIME'			, width: 80 ,hidden : true},
			{dataIndex:'INIT_DVRY_DATE'		, width: 80 ,hidden : true},
			{dataIndex:'WH_CODE'			, width: 120,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filter('option', record.get('IN_DIV_CODE'));
				  }
			},
			{dataIndex:'LOT_NO'				, width:120 ,hidden: sumtypeLot},
			{dataIndex:'ORDER_Q'			, width: 100, summaryType: 'sum' },
			{dataIndex:'BAD_RETURN_Q'		, width: 100, summaryType: 'sum', hidden: hiddenChk },
			{dataIndex:'INSPEC_FLAG'		, width: 100, align: 'center'},
			{dataIndex:'UNIT_PRICE_TYPE'	, width: 88, align: 'center'},
//			{dataIndex:'PO_REQ_NUM'			, width: 93 ,hidden : true},
//			{dataIndex:'PO_SER_NO'			, width: 93 ,hidden : true},
			{dataIndex:'ORDER_P'			, width: 93 ,hidden : true},
			{dataIndex:'CONTROL_STATUS'		, width: 80, align: 'center'},
			{dataIndex:'ORDER_REQ_NUM'		, width: 100 },
			{dataIndex:'INSTOCK_Q'			, width: 100 ,hidden : true},
			{dataIndex:'PROJECT_NO'			, width: 200 },
			{dataIndex:'REMARK'				, width: 200 },
			{dataIndex:'COMP_CODE'			, width: 10  ,hidden : true},
			{dataIndex:'UPDATE_DB_USER'		, width: 10  ,hidden : true},
			{dataIndex:'UPDATE_DB_TIME'		, width: 10  ,hidden : true},
			{dataIndex:'SO_NUM'				, width: 100 ,hidden : true,
				 getEditor: function(record) {
	                	return openSearchOrderWindow(record);
	             }
			},
			{dataIndex:'SO_SEQ'				, width: 80 ,hidden : true},
			{dataIndex:'SO_PLACE'			, width: 100 ,hidden : true},
			{dataIndex:'SO_PLACE_NAME'		, width: 120 ,hidden : true},
			{dataIndex:'SO_ITEM_NAME'		, width: 120 ,hidden : true},
			{dataIndex:'MODIFY_AUTH_CHK'	, width: 50  ,hidden : true},
			{dataIndex:'SUPPLY_TYPE'		, width: 80  ,hidden : true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if((e.record.data.CONTROL_STATUS > '1' && e.record.data.CONTROL_STATUS != '9') || /*top.gsAutoOrder <> "Y" &&*/ panelResult.getValue('ORDER_YN') > '1'){
					if(e.field=='CONTROL_STATUS') return false;
				}
				if(e.record.phantom){
					if(e.record.data.ORDER_REQ_NUM != ''){
						if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','ORDER_SEQ','ORDER_O','SUPPLY_TYPE','BAD_RETURN_Q'])) return false;
					}else{
					if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','ORDER_SEQ', 'LOT_NO','IN_DIV_CODE','SO_NUM'])) return true;
					}
				}
				if(UniUtils.indexOf(e.field, [
					'ORDER_UNIT','DVRY_DATE','DVRY_TIME','INIT_DVRY_DATE','ORDER_UNIT_P','MONEY_UNIT','EXCHG_RATE_O',
					'ORDER_LOC_P','ORDER_LOC_O','WH_CODE','UNIT_PRICE_TYPE','ORDER_UNIT_Q','ORDER_O',
					'REMARK','PROJECT_NO','CONTROL_STATUS','INSPEC_FLAG', 'LOT_NO','IN_DIV_CODE','SO_NUM'
				])) return true;
				/* if(!e.record.phantom){
					if(e.record.data.MODIFY_AUTH_CHK == 'Y'){
						return true;
					}else{
						return false;
					}
				} */
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
				grdRecord.set('ITEM_CODE'		, "");
				grdRecord.set('ITEM_NAME'		, "");
				grdRecord.set('ITEM_ACCOUNT'	, "");
				grdRecord.set('SPEC'			, "");
				grdRecord.set('ORDER_UNIT'		, "");
				grdRecord.set('STOCK_UNIT'		, "");
				grdRecord.set('TRNS_RATE'		, '1');
				grdRecord.set('ORDER_P'			, 0);
				grdRecord.set('DVRY_DATE'		, UniDate.get('today'));
				grdRecord.set('INIT_DVRY_DATE'	, UniDate.get('today'));
				grdRecord.set('INSPEC_FLAG'		, "");
				grdRecord.set('ORDER_UNIT_P'	, 0);
				//grdRecord.set('LOT_YN'		, '');
				grdRecord.set('WH_CODE'			, '');
				grdRecord.set('SUPPLY_TYPE'		, '');
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('ORDER_UNIT'		, record['ORDER_UNIT']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('TRNS_RATE'		, record['PUR_TRNS_RATE']);
				grdRecord.set('ORDER_P'			, record['BASIS_P']);
				grdRecord.set('DVRY_DATE'		, moment().add('day',record['PURCH_LDTIME']).format('YYYYMMDD'));
				grdRecord.set('INIT_DVRY_DATE'		, moment().add('day',record['PURCH_LDTIME']).format('YYYYMMDD'));
				grdRecord.set('INSPEC_FLAG'		, record['INSPEC_YN']);
				//grdRecord.set('LOT_YN'		, record['LOT_YN']);
				grdRecord.set('WH_CODE'			, record['WH_CODE']);
				grdRecord.set('IN_DIV_CODE'		, record['DIV_CODE']);
				grdRecord.set('SUPPLY_TYPE'		, record['SUPPLY_TYPE']);
				var param = {"ITEM_CODE": record['ITEM_CODE'],
					"DIV_CODE": grdRecord.get('IN_DIV_CODE')};
				 mpo502ukrvService.callInspecyn(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						grdRecord.set('INSPEC_FLAG', provider['INSPEC_YN']);
					}
				});
				/* var param = {"DIV_CODE": record['DIV_CODE'],
					"DEPT_CODE": panelResult.getValue('DEPT_CODE')};
				mpo502ukrvService.callDeptInspecFlag(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						grdRecord.set('INSPEC_FLAG', provider['INSPEC_FLAG']);
					}
				}); */
				var param = {
					"ITEM_CODE"		: record['ITEM_CODE'],
					"CUSTOM_CODE"	: panelResult.getValue('CUSTOM_CODE'),
					"DIV_CODE"		: grdRecord.get('IN_DIV_CODE'),
					"MONEY_UNIT"	: panelResult.getValue('MONEY_UNIT'),
					"ORDER_UNIT"	: record['ORDER_UNIT'],
					"ORDER_DATE"	: panelResult.getValue('ORDER_DATE')
				};
				mpo502ukrvService.fnOrderPrice(param, function(provider, response)  {
					if(!Ext.isEmpty(provider)) {
						grdRecord.set('ORDER_UNIT_P', provider['ORDER_UNIT_P']);
						grdRecord.set('ORDER_P', provider['ORDER_UNIT_P'] / grdRecord.get('TRNS_RATE'));
					}else{
						var trnsRate = grdRecord.get('TRNS_RATE');

						if (trnsRate == 0.0) {
							trnsRate = 1;
						}
						grdRecord.set('ORDER_UNIT_P', record['PURCHASE_BASE_P']);
						grdRecord.set('ORDER_P', record['PURCHASE_BASE_P'] / trnsRate);

						//	grdRecord.get('TRNS_RATE') == record['PUR_TRNS_RATE'] == 품목마스터의 구매입수 : 0이면 산술 오류가 발생하여 저장 시 오류 발생.
						//grdRecord.set('ORDER_P', record['PURCHASE_BASE_P'] / grdRecord.get('TRNS_RATE'));
					}
				});
				UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('IN_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
			}
		},
		setEstiData: function(record) {		// 구매요청등록참조 셋팅
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('COMP_CODE'		, record['COMP_CODE']);
			grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('SPEC'			, record['SPEC']);
			grdRecord.set('ORDER_P'			, record['ORDER_P']);
			grdRecord.set('ORDER_Q'			, record['ORDER_Q']);
			grdRecord.set('ORDER_O'			, record['ORDER_O']);
			grdRecord.set('UNIT_PRICE_TYPE'	, 'Y');
			grdRecord.set('ORDER_UNIT_P'	, record['ORDER_P']);
			grdRecord.set('ORDER_UNIT_Q'	, record['ORDER_Q']);
			grdRecord.set('ORDER_UNIT'		, record['ORDER_UNIT']);
			grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
			grdRecord.set('TRNS_RATE'		, '1');
			grdRecord.set('DVRY_DATE'		, UniDate.get('today'));
			grdRecord.set('INIT_DVRY_DATE'	, UniDate.get('today'));
			grdRecord.set('MONEY_UNIT'		, panelResult.getValue('MONEY_UNIT'));
			grdRecord.set('EXCHG_RATE_O'	, panelResult.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_LOC_P'		, '0');
			grdRecord.set('ORDER_LOC_O'		, '0');
			grdRecord.set('IN_DIV_CODE'		, record['IN_DIV_CODE']);
//			grdRecord.set('WH_CODE'			, panelResult.getValue('WH_CODE'));
			//grdRecord.set('LOT_YN'		, record['LOT_YN']);
//			grdRecord.set('INSPEC_FLAG'		, record['INSPEC_FLAG']);
			var param = {"ITEM_CODE": record['ITEM_CODE'], "DIV_CODE": record['DIV_CODE']};
				 mpo502ukrvService.callInspecyn(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						grdRecord.set('INSPEC_FLAG', provider['INSPEC_YN']);
						grdRecord.set('WH_CODE', provider['WH_CODE']);
					}
				})
			grdRecord.set('ORDER_REQ_NUM'	, record['ORDER_REQ_NUM']);
			grdRecord.set('PROJECT_NO'		, record['PROJECT_NO']);

//			UniAppManager.app.fnCalOrderAmt(record, "O", newValue);
//			directMasterStore1.fnSumOrderO();
		},
		setOrderHistoryData: function(record) {		// 발주이력조회 셋팅
			var grdRecord = this.getSelectedRecord();
			var orderDate =  panelResult.getValue('ORDER_DATE');
			grdRecord.set('COMP_CODE'		, record['COMP_CODE']);
			grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('SPEC'			, record['SPEC']);
			grdRecord.set('UNIT_PRICE_TYPE'	, 'Y');
			grdRecord.set('ORDER_UNIT'		, record['ORDER_UNIT']);
			grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
			grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			grdRecord.set('DVRY_DATE'		, UniDate.get('today'));
			grdRecord.set('INIT_DVRY_DATE'	, UniDate.get('today'));
			grdRecord.set('MONEY_UNIT'		, panelResult.getValue('MONEY_UNIT'));
			grdRecord.set('EXCHG_RATE_O'	, panelResult.getValue('EXCHG_RATE_O'));
			grdRecord.set('IN_DIV_CODE'		, record['IN_DIV_CODE']);
			grdRecord.set('WH_CODE'			, record['WH_CODE']);
			var param = {
				"ITEM_CODE"		: record['ITEM_CODE'],
				"CUSTOM_CODE"	: panelResult.getValue('CUSTOM_CODE'),
				"DIV_CODE"		: grdRecord.get('IN_DIV_CODE'),
				"MONEY_UNIT"	: panelResult.getValue('MONEY_UNIT'),
				"ORDER_UNIT"	: record['ORDER_UNIT'],
				"ORDER_DATE"	: panelResult.getValue('ORDER_DATE')
			};
			mpo502ukrvService.fnOrderPrice(param, function(provider, response)  {
				if(!Ext.isEmpty(provider)) {
					grdRecord.set('ORDER_UNIT_P', provider['ORDER_UNIT_P']);
				}else{
					grdRecord.set('ORDER_UNIT_P', record['ORDER_UNIT_P']);
				}
				grdRecord.set('ITEM_CODE'	, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'	, record['ITEM_NAME']);
				grdRecord.set('SPEC'		, record['SPEC']);
				grdRecord.set('ORDER_UNIT'	, record['ORDER_UNIT']);
				grdRecord.set('STOCK_UNIT'	, record['STOCK_UNIT']);
				grdRecord.set('TRNS_RATE'	, record['TRNS_RATE']);
				grdRecord.set('ORDER_LOC_P'	, '0');
				grdRecord.set('ORDER_LOC_O'	, '0');
				grdRecord.set('ORDER_UNIT_Q', record['ORDER_UNIT_Q']);
				grdRecord.set('DVRY_DATE'	, record['DVRY_DATE']);
				grdRecord.set('INIT_DVRY_DATE'	, record['DVRY_DATE']);
				grdRecord.set('INSPEC_FLAG'	, record['INSPEC_FLAG']);
				grdRecord.set('WH_CODE'		, record['WH_CODE']);
				grdRecord.set('ORDER_O'		, grdRecord.get('ORDER_UNIT_P') * record['ORDER_UNIT_Q'] );									//금액
				grdRecord.set('ORDER_LOC_P'	, UniMatrl.fnExchangeApply(panelResult.getValue('MONEY_UNIT'), grdRecord.get('ORDER_UNIT_P') * grdRecord.get('EXCHG_RATE_O')));								//자사단가, 20200610 수정: 자사금액 계산시, 'JPY' 관련로직 추가
				grdRecord.set('ORDER_LOC_O'	, UniMatrl.fnExchangeApply(panelResult.getValue('MONEY_UNIT'), grdRecord.get('ORDER_UNIT_P') * grdRecord.get('EXCHG_RATE_O') * record['ORDER_UNIT_Q']));	//자사금액, 20200610 수정: 자사금액 계산시, 'JPY' 관련로직 추가
				grdRecord.set('ORDER_Q'		, record['ORDER_UNIT_Q'] / record['TRNS_RATE'] );											//재고단위량
				grdRecord.set('ORDER_P'		, grdRecord.get('ORDER_UNIT_P') / record['TRNS_RATE'] );									//재고단위단가
			});

			var param = {"ITEM_CODE": record['ITEM_CODE'], "DIV_CODE": record['IN_DIV_CODE']};
				 mpo502ukrvService.callInspecyn(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						var dvryDate = UniDate.add(orderDate, { days: + provider['PURCH_LDTIME']});
						grdRecord.set('INSPEC_FLAG'	, provider['INSPEC_YN']);
						grdRecord.set('DVRY_DATE'	, dvryDate);
						grdRecord.set('INIT_DVRY_DATE'	, dvryDate);
						grdRecord.set('WH_CODE'		, provider['WH_CODE']);
					}
				})
			grdRecord.set('ORDER_REQ_NUM'	, record['ORDER_REQ_NUM']);
			grdRecord.set('PROJECT_NO'		, record['PROJECT_NO']);

//			UniAppManager.app.fnCalOrderAmt(record, "O", newValue);
//			directMasterStore1.fnSumOrderO();
		},
		setExcelData: function(record) {	//엑셀 업로드 참조
			var grdRecord = this.getSelectedRecord();
			var param = {
				"ITEM_CODE"		: record['ITEM_CODE'],
				"CUSTOM_CODE"	: panelResult.getValue('CUSTOM_CODE'),
				"DIV_CODE"		: panelResult.getValue('DIV_CODE'),
				"MONEY_UNIT"	: panelResult.getValue('MONEY_UNIT'),
				"ORDER_UNIT"	: record['ORDER_UNIT'],
				"ORDER_DATE"	: panelResult.getValue('ORDER_DATE')
			};
			mpo502ukrvService.fnOrderPrice(param, function(provider, response)  {
				if(!Ext.isEmpty(record['ORDER_UNIT_P']) && record['ORDER_UNIT_P'] != 0){
					grdRecord.set('ORDER_UNIT_P', record['ORDER_UNIT_P']);
				}else{
					if(!Ext.isEmpty(provider)) {
						grdRecord.set('ORDER_UNIT_P', provider['ORDER_UNIT_P']);
					}
				}
				grdRecord.set('ITEM_CODE'	, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'	, record['ITEM_NAME']);
				grdRecord.set('SPEC'		, record['SPEC']);
				grdRecord.set('ORDER_UNIT'	, record['ORDER_UNIT']);
				grdRecord.set('STOCK_UNIT'	, record['STOCK_UNIT']);
				grdRecord.set('TRNS_RATE'	, record['TRNS_RATE']);

				grdRecord.set('ORDER_UNIT_Q', record['ORDER_UNIT_Q']);
				grdRecord.set('DVRY_DATE'	, record['DVRY_DATE']);
				grdRecord.set('INIT_DVRY_DATE'	, record['DVRY_DATE']);
				grdRecord.set('INSPEC_FLAG'	, record['INSPEC_FLAG']);
				grdRecord.set('WH_CODE'		, record['WH_CODE']);
				grdRecord.set('ORDER_P'		, record['ORDER_UNIT_P']);//단가
				grdRecord.set('ORDER_O'		, record['ORDER_UNIT_P'] * record['ORDER_UNIT_Q'] );//금액
				grdRecord.set('ORDER_LOC_P'	, UniMatrl.fnExchangeApply(panelResult.getValue('MONEY_UNIT'), grdRecord.get('ORDER_UNIT_P') * grdRecord.get('EXCHG_RATE_O')));								//자사단가, 20200610 수정: 자사금액 계산시, 'JPY' 관련로직 추가
				grdRecord.set('ORDER_LOC_O'	, UniMatrl.fnExchangeApply(panelResult.getValue('MONEY_UNIT'), grdRecord.get('ORDER_UNIT_P') * grdRecord.get('EXCHG_RATE_O') * record['ORDER_UNIT_Q']));	//자사금액, 20200610 수정: 자사금액 계산시, 'JPY' 관련로직 추가
				grdRecord.set('ORDER_Q'		, record['ORDER_UNIT_Q'] / record['TRNS_RATE'] ); //재고단위량
				grdRecord.set('ORDER_P'		, record['ORDER_UNIT_P'] / record['TRNS_RATE'] ); //재고단위단가
			});
		},
		//20190722 추가
		setData: function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('COMP_CODE'		, record['COMP_CODE']);
			grdRecord.set('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
			grdRecord.set('IN_DIV_CODE'		, panelResult.getValue('DIV_CODE'));
			grdRecord.set('CUSTOM_CODE'		, record['CUSTOM_CODE']);
			grdRecord.set('SO_NUM'			, record['ORDER_NUM']);
			grdRecord.set('SO_SEQ'			, record['SER_NO']);
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('SPEC'			, record['SPEC']);
			grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
			grdRecord.set('ORDER_UNIT'		, record['ORDER_UNIT']);			//구매단위
			grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);				//구매입수
			grdRecord.set('MONEY_UNIT'		, panelResult.getValue('MONEY_UNIT'));
			grdRecord.set('EXCHG_RATE_O'	, panelResult.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_Q'			, record['ORDER_Q']);				//수주량 SET
			grdRecord.set('PROJECT_NO'		, panelResult.getValue('PROJECT_NO'));
			grdRecord.set('DVRY_DATE'		, record['DVRY_DATE']);
			grdRecord.set('INIT_DVRY_DATE'	, record['DVRY_DATE']);

			grdRecord.set('ORDER_Q'			, record['ORDER_Q'] );				//재고단위량
			grdRecord.set('ORDER_UNIT_Q'	, record['ORDER_UNIT_Q']);

			var param = {
				"ITEM_CODE"		: record['ITEM_CODE'],
				"CUSTOM_CODE"	: panelResult.getValue('CUSTOM_CODE'),
				"DIV_CODE"		: panelResult.getValue('DIV_CODE'),
				"MONEY_UNIT"	: panelResult.getValue('MONEY_UNIT'),
				"ORDER_UNIT"	: record['ORDER_UNIT'],
				"ORDER_DATE"	: panelResult.getValue('ORDER_DATE')
			};
			mpo502ukrvService.fnOrderPrice(param, function(provider, response)  {
				if(!Ext.isEmpty(provider)) {	//단가 정보가  있어야 아래 로직 수행 됨
					grdRecord.set('ORDER_UNIT_P', provider['ORDER_UNIT_P']);

					grdRecord.set('ORDER_P'		, grdRecord['ORDER_UNIT_P'] / grdRecord['TRNS_RATE'] ); //재고단위단가
					grdRecord.set('ORDER_O'		, Unilite.multiply(grdRecord['ORDER_UNIT_P'], grdRecord['ORDER_UNIT_Q']) );//금액
					grdRecord.set('ORDER_UNIT_P', grdRecord['ORDER_UNIT_P']);
					grdRecord.set('ORDER_LOC_P'	, UniMatrl.fnExchangeApply(panelResult.getValue('MONEY_UNIT'), Unilite.multiply(grdRecord['ORDER_UNIT_P'], grdRecord.get('EXCHG_RATE_O'))));								//자사단가, 20200610 수정: 자사금액 계산시, 'JPY' 관련로직 추가
					grdRecord.set('ORDER_LOC_O'	, UniMatrl.fnExchangeApply(panelResult.getValue('MONEY_UNIT'), Unilite.multiply(Unilite.multiply(grdRecord['ORDER_UNIT_P'], grdRecord.get('EXCHG_RATE_O')), grdRecord['ORDER_UNIT_Q'])));	//자사금액, 20200610 수정: 자사금액 계산시, 'JPY' 관련로직 추가
				}
			});
		},
		setProviderData: function(record, orderUnitPrice) {
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
			grdRecord.set('EXCHG_RATE_O'	, record['EXCHG_RATE_O']);
//			grdRecord.set('DVRY_DATE'		, record['DVRY_DATE']);
//			grdRecord.set('DVRY_TIME'		, record['DVRY_TIME']);
			grdRecord.set('WH_CODE'			, record['WH_CODE']);
			grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			grdRecord.set('ORDER_Q'			, record['ORDER_Q']);
//			grdRecord.set('CONTROL_STATUS'	, record['CONTROL_STATUS']);
			grdRecord.set('ORDER_REQ_NUM'	, record['ORDER_REQ_NUM']);
			grdRecord.set('INSTOCK_Q'		, record['INSTOCK_Q']);
			grdRecord.set('INSPEC_FLAG'		, record['INSPEC_FLAG']);
			grdRecord.set('REMARK'			, record['REMARK']);
			grdRecord.set('PROJECT_NO'		, record['PROJECT_NO']);
			grdRecord.set('COMP_CODE'		, record['COMP_CODE']);

			if(orderUnitPrice != 0) {	//단가 정보가  있으면 아래 로직 수행 됨
				grdRecord.set('ORDER_UNIT_P', orderUnitPrice);
				grdRecord.set('ORDER_P'		, orderUnitPrice / grdRecord.get('TRNS_RATE')); //재고단위단가
				grdRecord.set('ORDER_O'		, Unilite.multiply(orderUnitPrice, grdRecord.get('ORDER_UNIT_Q')));//금액
				grdRecord.set('ORDER_LOC_P'	, UniMatrl.fnExchangeApply(panelResult.getValue('MONEY_UNIT'), Unilite.multiply(orderUnitPrice, grdRecord.get('EXCHG_RATE_O'))));								//자사단가, 20200610 수정: 자사금액 계산시, 'JPY' 관련로직 추가
				grdRecord.set('ORDER_LOC_O'	, UniMatrl.fnExchangeApply(panelResult.getValue('MONEY_UNIT'), Unilite.multiply(Unilite.multiply(orderUnitPrice, grdRecord.get('EXCHG_RATE_O')), grdRecord.get('ORDER_UNIT_Q'))));	//자사금액, 20200610 수정: 자사금액 계산시, 'JPY' 관련로직 추가
			}else{
				grdRecord.set('ORDER_UNIT_P'	, record['ORDER_UNIT_P']);
				grdRecord.set('ORDER_P'			, record['ORDER_P']);
				grdRecord.set('ORDER_O'			, record['ORDER_O']);
				grdRecord.set('ORDER_LOC_P'		, record['ORDER_LOC_P']);
				grdRecord.set('ORDER_LOC_O'		, record['ORDER_LOC_O']);
			}
		}
	});

	var orderNoMasterGrid = Unilite.createGrid('mpo502ukrvOrderNoMasterGrid', {	//조회버튼 누르면 나오는 조회창
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
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelResult.setValues({
				'DIV_CODE'			: record.get('DIV_CODE'),
				'CUSTOM_CODE'		: record.get('CUSTOM_CODE'),
				'CUSTOM_NAME'		: record.get('CUSTOM_NAME'),
				'ORDER_DATE'		: record.get('ORDER_DATE'),
				'ORDER_TYPE'		: record.get('ORDER_TYPE'),
				'ORDER_PRSN'		: record.get('ORDER_PRSN'),
				'ORDER_NUM'			: record.get('ORDER_NUM'),
				'MONEY_UNIT'		: record.get('MONEY_UNIT'),
				'EXCHG_RATE_O'		: record.get('EXCHG_RATE_O'),
				'COMP_NAME'			: record.get('COMP_NAME'),
				'AGREE_STATUS'		: record.get('AGREE_STATUS'),
				'AGREE_PRSN'		: record.get('AGREE_PRSN'),
				'AGREE_PRSN_NAME'	: record.get('AGREE_PRSN_NAME'),
				'DRAFT_YN'			: record.get('DRAFT_YN'),
				'DEPT_CODE'			: record.get('DEPT_CODE'),
				'DEPT_NAME'			: record.get('DEPT_NAME')
			});
		}
	});

		var orderNoDetailPopGrid = Unilite.createGrid('mpo502ukrvOrderNoDetailPopGrid', {
		store	: orderNoDetailPopStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: false
		},
		hidden	: true,
		columns	: [
			{ dataIndex: 'DIV_CODE'		    , width: 50,hidden:true},
			{ dataIndex: 'CUSTOM_CODE'		, width: 100,hidden:true},
			{ dataIndex: 'CUSTOM_NAME'		, width: 180},
			{ dataIndex: 'ORDER_DATE'		, width: 120},
			{ dataIndex: 'ORDER_TYPE'		, width: 93,align:'center'},
			{ dataIndex: 'ITEM_CODE'		, width: 120},
			{ dataIndex: 'ITEM_NAME'		, width: 180},
			{ dataIndex: 'SPEC'		        , width: 150},
			{ dataIndex: 'ORDER_Q'		    , width: 80},
			{ dataIndex: 'ORDER_P'		    , width: 80},
			{ dataIndex: 'ORDER_O'		    , width: 120},
			{ dataIndex: 'DVRY_DATE'		, width: 120},
			{ dataIndex: 'ORDER_NUM'		, width: 100},
			{ dataIndex: 'ORDER_SEQ'		, width: 50},
			{ dataIndex: 'PROJECT_NO'		, width: 66},
			{ dataIndex: 'ORDER_PRSN'		, width: 93,align:'center'},
			{ dataIndex: 'AGREE_STATUS'		, width: 66,align:'center'},
			{ dataIndex: 'AGREE_PRSN'		, width: 100,hidden:true},
			{ dataIndex: 'AGREE_PRSN_NAME'	, width: 100,hidden:true},
			{ dataIndex: 'AGREE_DATE'		, width: 66,hidden:true},
			{ dataIndex: 'MONEY_UNIT'		, width: 66,hidden:true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				orderNoDetailPopGrid.returnData(record)
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelResult.setValues({
				'DIV_CODE'			: record.get('DIV_CODE'),
				'CUSTOM_CODE'		: record.get('CUSTOM_CODE'),
				'CUSTOM_NAME'		: record.get('CUSTOM_NAME'),
				'ORDER_DATE'		: record.get('ORDER_DATE'),
				'ORDER_TYPE'		: record.get('ORDER_TYPE'),
				'ORDER_PRSN'		: record.get('ORDER_PRSN'),
				'ORDER_NUM'			: record.get('ORDER_NUM'),
				'MONEY_UNIT'		: record.get('MONEY_UNIT'),
		//		'EXCHG_RATE_O'		: record.get('EXCHG_RATE_O'),
		//		'COMP_NAME'			: record.get('COMP_NAME'),
				'AGREE_STATUS'		: record.get('AGREE_STATUS'),
				'AGREE_PRSN'		: record.get('AGREE_PRSN'),
				'AGREE_PRSN_NAME'	: record.get('AGREE_PRSN_NAME')
		//		'DRAFT_YN'			: record.get('DRAFT_YN'),
		//		'DEPT_CODE'			: record.get('DEPT_CODE'),
		//		'DEPT_NAME'			: record.get('DEPT_NAME')
			});
		}
	});
	var otherorderGrid = Unilite.createGrid('mpo502ukrvOtherorderGrid', {//타발주참조
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
			{ dataIndex: 'PROJECT_NO'		, width: 100},
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
			var param = {"ORDER_NUM": record.data.ORDER_NUM,
								"CUSTOM_CODE"	: record.get('CUSTOM_CODE'),
								"MONEY_UNIT"		: panelResult.getValue('MONEY_UNIT'),
								"ORDER_DATE"		: panelResult.getValue('ORDER_DATE')
							 };
			mpo502ukrvService.selectList2(param, function(provider, response) {
				var records = response.result;

				panelResult.setValue('CUSTOM_CODE'	, record.get('CUSTOM_CODE'));
				panelResult.setValue('CUSTOM_NAME'	, record.get('CUSTOM_NAME'));
				panelResult.setValue('PROJECT_NO'	 , record.get('PROJECT_NO'));

				Ext.each(records, function(record,i){
						UniAppManager.app.onNewDataButtonDown();
						var orderUnitPrice = record['ORDER_UNIT_P_CUR'];
						masterGrid.setProviderData(record, orderUnitPrice);
				});
				console.log("response",response)
				referOtherOrderWindow.hide();
			});
		}
	});

	var otherorderGrid2 = Unilite.createGrid('mpo502ukrvOtherorderGrid2', {		//구매요청등록참조
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
		selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns: [
			{dataIndex:'CUSTOM_CODE'			, width: 80 },
			{dataIndex:'CUSTOM_NAME'			, width: 120 },
			{dataIndex:'ITEM_CODE'			  , width: 100 },
			{dataIndex:'ITEM_NAME'			  , width: 150 },
			{dataIndex:'SPEC'				   , width: 120 },
			{dataIndex:'ORDER_UNIT'			 , width: 80, align: 'center'},
			{dataIndex:'SUPPLY_TYPE'			, width: 80, align: 'center'},
			{dataIndex:'ORDER_Q'				, width: 90},
			{dataIndex:'ORDER_P'				, width: 100},
			{dataIndex:'ORDER_O'				, width: 100},
			{dataIndex:'CSTOCK'				 , width: 80},
			{dataIndex:'PURCH_LDTIME'		   , width: 80},
			{dataIndex:'REMARK'				 , width: 200},
			{dataIndex:'MRP_CONTROL_NUM'		, width: 80},
			{dataIndex:'ORDER_REQ_NUM'		  , width: 100 ,hidden: true},
			{dataIndex:'PROJECT_NO'			 , width: 100 ,hidden: true},
			{dataIndex:'ORDER_NUM'			  , width: 100 ,hidden: true},
			{dataIndex:'DIV_CODE'			   , width: 90  ,hidden: true},
			{dataIndex:'COMP_CODE'			  , width: 80  ,hidden : true},
			{dataIndex:'IN_DIV_CODE'			  , width: 100  ,hidden : true}
			/* {dataIndex:'PO_REQ_NUM'			 , width: 110 ,hidden: false}, */
			/* {dataIndex:'PO_SER_NO'			  , width: 55 }, */
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function()  {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i) {
				if(Ext.isEmpty(record.get('CUSTOM_CODE'))){
					return false;
				}

				panelResult.setValue('CUSTOM_CODE'		, record.get('CUSTOM_CODE'));
				panelResult.setValue('CUSTOM_NAME'		, record.get('CUSTOM_NAME'));
				if(record.get('SUPPLY_TYPE') == '3'){
					panelResult.setValue('ORDER_TYPE'		, '4');
				}
				UniAppManager.app.onNewDataButtonDown();
//				debugger;
				masterGrid.setEstiData(record.data);
			});
			this.getStore().remove(records);
		}
	});

	var orderHistoryGrid = Unilite.createGrid('mpo502ukrvOrderHistoryGrid', {		//발주이력조회그리드
		layout: 'fit',
		store: orderHistoryStore,
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
		selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns: [
			{dataIndex:'CUSTOM_CODE'			, width: 80 },
			{dataIndex:'CUSTOM_NAME'			, width: 150 },
			{dataIndex:'ORDER_DATE'			  , width: 100 },
			{dataIndex:'ORDER_NUM'			  , width: 120 },
			{dataIndex:'ORDER_SEQ'			  , width: 60 },
			{dataIndex:'ITEM_CODE'			  , width: 100 },
			{dataIndex:'ITEM_NAME'			  , width: 200 },
			{dataIndex:'SPEC'				   , width: 120 },
			{dataIndex:'ORDER_UNIT'			 , width: 80, align: 'center'},
			{dataIndex:'TRNS_RATE'			 , width: 80, align: 'center'},
			{dataIndex:'ORDER_TYPE'			, width: 80, align: 'center'},
			{dataIndex:'ORDER_Q'				, width: 100},
			{dataIndex:'ORDER_P'				, width: 120},
			{dataIndex:'ORDER_O'				, width: 120},
			{dataIndex:'ORDER_UNIT_Q'				, width: 100},
			{dataIndex:'ORDER_UNIT_P'				, width: 100},
			{dataIndex:'REMARK'				, width: 200},
			{dataIndex:'ORDER_NUM'			  , width: 100 ,hidden: true},
			{dataIndex:'DIV_CODE'			   , width: 90  ,hidden: true},
			{dataIndex:'COMP_CODE'			  , width: 80  ,hidden : true},
			{dataIndex:'IN_DIV_CODE'			  , width: 100  ,hidden : true}

		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function()  {
			var records = orderHistoryGrid.getSelectedRecords();
			Ext.each(records, function(record,i) {
				if(Ext.isEmpty(record.get('CUSTOM_CODE'))){
					return false;
				}

			/* 	panelResult.setValue('CUSTOM_CODE'		, record.get('CUSTOM_CODE'));
				panelResult.setValue('CUSTOM_NAME'		, record.get('CUSTOM_NAME')); */

				UniAppManager.app.onNewDataButtonDown();
//				debugger;
				masterGrid.setOrderHistoryData(record.data);
			});
			this.getStore().remove(records);
		}
	});

	function openMRP400TWindow() {												//구매요청등록참조
		//if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!MRP400TWindow) {
			MRP400TWindow = Ext.create('widget.uniDetailWindow', {
				title: '구매요청등록참조',
				width: 1000,
				height: 500,
				layout: {type:'vbox', align:'stretch'},
				items: [otherorderSearch2, otherorderGrid2],
				tbar: ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						if(!otherorderSearch2.setAllFieldsReadOnly(true)){
								return false;
						}
						otherOrderStore2.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmCloseBtn',
					text: '적용 후 닫기',
					handler: function() {
						otherorderGrid2.returnData();
						MRP400TWindow.hide();
						//directMasterStore1.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler: function() {
						MRP400TWindow.hide();
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
						otherorderSearch2.setValue('CUSTOM_CODE', panelResult.getValue("CUSTOM_CODE"));
						otherorderSearch2.setValue('CUSTOM_NAME', panelResult.getValue("CUSTOM_NAME"));
						otherorderSearch2.setValue('ORDER_NUM', panelResult.getValue("ORDER_NUM"));
						otherorderSearch2.setValue('PO_REQ_DATE_TO', UniDate.get('today'));
						otherorderSearch2.setValue('PO_REQ_DATE_FR', UniDate.get('startOfMonth', otherorderSearch2.getValue('PO_REQ_DATE_TO')));
						otherorderSearch2.setValue('SUPPLY_TYPE', panelResult.getValue("SUPPLY_TYPE"));
						otherOrderStore2.loadStoreRecords();
					}
				}
			})
		}
		MRP400TWindow.center();
		MRP400TWindow.show();
	};

	function openSearchInfoWindow() {											//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '발주번호검색',
				width: 970,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [orderNoSearch, orderNoMasterGrid, orderNoDetailPopGrid],
				tbar:  ['->',{
					itemId	: 'OrderNosearchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						var rdoType = orderNoSearch.getValue('RDO_TYPE');
						console.log('rdoType : ',rdoType)
						if(rdoType.RDO_TYPE=='master') {
							orderNoMasterStore.loadStoreRecords();
						} else {
							orderNoDetailPopStore.loadStoreRecords();
						}
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
					beforehide: function(me, eOpt)  {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
						orderNoDetailPopGrid.reset();
					},
					beforeclose: function( panel, eOpts )   {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
						orderNoDetailPopGrid.reset();
					},
					show: function( panel, eOpts )  {
						orderNoSearch.setValue('DIV_CODE',	  panelResult.getValue('DIV_CODE'));
			//			orderNoSearch.setValue('DEPT_CODE',	 panelResult.getValue('DEPT_CODE'));
			//			orderNoSearch.setValue('DEPT_NAME',	 panelResult.getValue('DEPT_NAME'));
						orderNoSearch.setValue('PROJECT_NO',	   panelResult.getValue('PROJECT_NO'));
						orderNoSearch.setValue('CUSTOM_CODE',   panelResult.getValue('CUSTOM_CODE'));
						orderNoSearch.setValue('CUSTOM_NAME',   panelResult.getValue('CUSTOM_NAME'));
						orderNoSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth'));
						orderNoSearch.setValue('ORDER_DATE_TO', panelResult.getValue('ORDER_DATE'));
						orderNoSearch.setValue('ORDER_PRSN',	panelResult.getValue('ORDER_PRSN'));
						//orderNoSearch.setValue('ORDER_TYPE',	panelResult.getValue('ORDER_TYPE'));
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





	//수주참조 참조 메인
	function openOrderInformationWindow() {
		if(!panelResult.getInvalidMessage()) return;	//필수체크
		OrderSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));

		if(!referOrderInformationWindow) {
			referOrderInformationWindow = Ext.create('widget.uniDetailWindow', {
				title: '수주정보참조',
				width: 1200,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [OrderSearch, OrderGrid],
				tbar:['->',{
					itemId : 'saveBtn',
					id:'saveBtn1',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						OrderStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmBtn',
					id:'confirmBtn1',
					text: '확인',
					handler: function() {
						if(!Ext.isEmpty(masterGrid.getSelectedRecords)){
							OrderGrid.returnData();
							var maxIndex = 0;
							Ext.each(directMasterStore1.data.items, function(record, index, records){
								if(record.phantom){
									maxIndex = index
								}
							});
							masterGrid.getSelectionModel().selectRange(0, maxIndex);
						}
					},
					disabled: false
				},{
					itemId : 'confirmCloseBtn',
					id:'confirmCloseBtn1',
					text: '확인 후 닫기',
					handler: function() {
						if(!Ext.isEmpty(masterGrid.getSelectedRecords)){
							OrderGrid.returnData();
							var maxIndex = 0;
							Ext.each(directMasterStore1.data.items, function(record, index, records){
								if(record.phantom){
									maxIndex = index
								}
							});
							masterGrid.getSelectionModel().selectRange(0, maxIndex);
							referOrderInformationWindow.hide();
						}
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					id:'closeBtn1',
					text: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler: function() {
						referOrderInformationWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {},
					beforeclose: function( panel, eOpts ) {},
					beforeshow: function ( me, eOpts ) {
						OrderSearch.setValue('DIV_CODE'		, panelResult.getValue("DIV_CODE"));
						//상품만 보이도록 SET
						OrderSearch.setValue('ITEM_ACCOUNT'	, '00');
						OrderStore.loadStoreRecords();
					}
				}
			})
		}
		referOrderInformationWindow.center();
		referOrderInformationWindow.show();
	}

	function openOtherOrderWindow() {			//타발주참조(발주이력참조)
		if(!referOtherOrderWindow) {
			referOtherOrderWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.orderhistoryrefer" default="발주이력참조"/>',
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
						otherorderSearch.setValue('DIV_CODE',	panelResult.getValue('DIV_CODE'));
						otherorderSearch.setValue('DEPT_CODE',	panelResult.getValue('DEPT_CODE'));
						otherorderSearch.setValue('DEPT_NAME',	panelResult.getValue('DEPT_NAME'));
						otherorderSearch.setValue('WH_CODE',	panelResult.getValue('WH_CODE'));
						otherorderSearch.setValue('CUSTOM_CODE',panelResult.getValue('CUSTOM_CODE'));
						otherorderSearch.setValue('CUSTOM_NAME',panelResult.getValue('CUSTOM_NAME'));
						otherorderSearch.setValue('ORDER_TYPE', panelResult.getValue('ORDER_TYPE'));
						otherorderSearch.setValue('ORDER_PRSN', panelResult.getValue('ORDER_PRSN'));
						otherorderSearch.setValue('AGREE_STATUS', panelResult.getValue('AGREE_STATUS'));
						otherorderSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
						otherorderSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth', otherorderSearch.getValue('ORDER_DATE_TO')));

					}
				}
			})
		}
		referOtherOrderWindow.center();
		referOtherOrderWindow.show();
	};

	function openOrderHistoryWindow() {												//발주이력참조
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!orderHistorylWindow) {
			orderHistorylWindow = Ext.create('widget.uniDetailWindow', {
				title: '발주이력참조',
				width: 1000,
				height: 500,
				layout: {type:'vbox', align:'stretch'},
				items: [orderHistorySearch, orderHistoryGrid],
				tbar: ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						if(!orderHistorySearch.setAllFieldsReadOnly(true)){
							return false;
						}
						orderHistoryStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmCloseBtn',
					text: '적용 후 닫기',
					handler: function() {
						orderHistoryGrid.returnData();
						orderHistorylWindow.hide();
						//directMasterStore1.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler: function() {
						orderHistorylWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt)  {
						orderHistorySearch.clearForm();
						orderHistoryGrid.reset();
					},
					beforeclose: function( panel, eOpts )   {
						orderHistorySearch.clearForm();
						orderHistoryGrid.reset();
					},
					beforeshow: function ( me, eOpts ){
						orderHistorySearch.setValue('DIV_CODE', panelResult.getValue("DIV_CODE"));
						orderHistorySearch.setValue('CUSTOM_CODE', panelResult.getValue("CUSTOM_CODE"));
						orderHistorySearch.setValue('CUSTOM_NAME', panelResult.getValue("CUSTOM_NAME"));
						orderHistorySearch.setValue('ORDER_NUM', panelResult.getValue("ORDER_NUM"));
						orderHistorySearch.setValue('ORDER_TYPE', panelResult.getValue("ORDER_TYPE"));
						orderHistorySearch.setValue('ORDER_PRSN', panelResult.getValue("ORDER_PRSN"));
						orderHistorySearch.setValue('PROJECT_NO', panelResult.getValue("PROJECT_NO"));
						orderHistoryStore.loadStoreRecords();
					}
				}
			})
		}
		orderHistorylWindow.center();
		orderHistorylWindow.show();
	};

	function openSearchOrderWindow() {
        if (!searchOrderWindow) {
            searchOrderWindow = Ext.create('widget.uniDetailWindow', {
                title: '수주번호검색',
                width: 1000,
                height: 580,
                layout: {
                    type: 'vbox',
                    align: 'stretch'
                },
                items: [orderNoSearch2, orderNoDetailGrid],
                tbar: [
                       '->',{
                    itemId: 'searchBtn',
                    text: '조회',
                    handler: function() {
                        orderNoDetailStore.loadStoreRecords();
                    },
                    disabled: false
                }, {
                    itemId: 'closeBtn',
                    text: '닫기',
                    handler: function() {
                        searchOrderWindow.hide();
                    },
                    disabled: false
                }],
                listeners: {
                    beforehide: function(me, eOpt) {
                        orderNoSearch2.clearForm();
                        orderNoDetailGrid.reset();
                        orderNoDetailStore.clearData();
                    },
                    beforeclose: function(panel, eOpts) {
                    },
                    show: function(panel, eOpts) {
                    	orderNoSearch2.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
                    	orderNoSearch2.setValue('FR_ORDER_DATE', UniDate.get('startOfMonth'));
                    	orderNoSearch2.setValue('TO_ORDER_DATE', UniDate.get('today'));
                    }
                }
            })
        }
        searchOrderWindow.center();
        searchOrderWindow.show();
    }


	// 수주정보 참조 모델 정의
	Unilite.defineModel('mpo502ukrvOrderModel', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'						, type: 'string'},
			{name: 'ORDER_NUM'	 		, text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'							, type: 'string'},
			{name: 'SER_NO'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'							, type: 'int'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'					, type: 'uniDate'},
			{name: 'WEEK_NUM'			, text: '<t:message code="system.label.purchase.deliveryweek" default="납기주차"/>'					, type: 'string'},
			{name: 'ITEM_CODE'	 		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'						, type: 'string'},
			{name: 'ITEM_NAME'	 		, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'						, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'							, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.unit" default="단위"/>'							, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'					, type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'SUPPLY_TYPE'		, text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'	, type: 'string', comboType:'AU', comboCode:'B014'},
			{name: 'ORDER_DATE'			, text: '수주일'		, type: 'uniDate'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.purchase.soqty" default="수주량"/>' 						, type: 'uniQty'},
			{name: 'CSTOCK'				, text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'					, type: 'uniQty'},
			{name: 'WORK_SHOP_CODE'		, text: '주작업장'		, type: 'string' , comboType: 'WU'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'					, type: 'string'},
			{name: 'PROJECT_NAME'		, text: '프로젝트명'		, type: 'string'},
			{name: 'PJT_CODE'			, text: '프로젝트코드'	, type: 'string'}
		]
	});

	//수주정보 참조 스토어 정의
	var OrderStore = Unilite.createStore('mpo502ukrvOrderStore', {
		model	: 'mpo502ukrvOrderModel',
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
				read : 'mpo502ukrvService.selectOrderList'
			}
		},
		loadStoreRecords : function() {
			var param= OrderSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);

			var paramMaster= OrderSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						var param = {KEY_VALUE: master.KEY_VALUE};
						OrderStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('mpo502ukrvOrderGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords = directMasterStore1.data;
					var prodRecords = new Array();
					if(masterRecords.items.length > 0) {
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								if((record.data['DIV_CODE']		== item.data['DIV_CODE'])
								&& (record.data['ORDER_NUM']	== item.data['ORDER_NUM'])
								&& (record.data['SER_NO']		== item.data['SER_NO'])){
									prodRecords.push(item);
								}
							});
						});
						store.remove(prodRecords);
					}
				}
			}
		}
	});

	//수주정보 참조 폼 정의
	var OrderSearch = Unilite.createSearchForm('OrderForm', {
		layout	: {type : 'uniTable', columns : 3},
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			name		: 'ITEM_ACCOUNT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel		: '수주일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_ORDER_DATE',
			endFieldName	: 'TO_ORDER_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			width			: 350
		},
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
			valueFieldName	: 'PJT_CODE',
			textFieldName	: 'PJT_NAME',
			DBvalueFieldName: 'PJT_CODE',
			DBtextFieldName	: 'PJT_NAME',
			validateBlank	: false,
			textFieldOnly	: false,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('REMARK', records[0]['PJT_NAME']);
						panelResult.setValue('PJT_CODE', records[0]['PJT_CODE']);
						panelResult.setValue('PJT_NAME', records[0]['PJT_NAME']);
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup) {
				},
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}),{
			xtype		: 'fieldcontainer',
			fieldLabel	: '<t:message code="system.label.purchase.sono" default="수주번호"/>',
			combineErrors: true,
			msgTarget	: 'side',
			layout		: {type : 'table', columns : 3},
			defaults	: {
				flex		: 1,
				hideLabel	: true
			},
			defaultType : 'textfield',
			items		: [
				Unilite.popup('ORDER_NUM',{
					fieldLabel		: '',
					valueFieldName	: 'FROM_NUM',
					textFieldName	: 'FROM_NUM',
					allowBlank		: false,
					listeners		: {
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
						}
					}
				})]
			},{
				xtype		: 'fieldcontainer',
				fieldLabel	: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				combineErrors: true,
				msgTarget	: 'side',
				colspan		: 2,
				layout		: {type : 'table', columns : 3},
				defaults	: {
					flex		: 1,
					hideLabel	: true
				},
				defaultType	: 'textfield',
				items		: [
					Unilite.popup('DIV_PUMOK',{
						fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
						valueFieldName	: 'ITEM_CODE_FR',
						textFieldName	: 'ITEM_NAME_FR',
						allowBlank		: false,
						listeners		: {
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
							}
						}
					})
				]
			}
		]
	});

	/* 수주정보 그리드 */
	var OrderGrid = Unilite.createGrid('mpo502ukrvOrderGrid', {
		store	: OrderStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt	: {
			onLoadSelectFirst : false
		},
		columns	: [
			{ dataIndex: 'ORDER_NUM'		, width: 120},
			{ dataIndex: 'SER_NO'			, width: 80},
			{ dataIndex: 'DVRY_DATE'		, width: 80},
			{ dataIndex: 'WEEK_NUM'			, width: 80},
			{ dataIndex: 'ITEM_CODE'		, width: 120},
			{ dataIndex: 'ITEM_NAME'		, width: 140},
			{ dataIndex: 'SPEC'				, width: 126},
			{ dataIndex: 'STOCK_UNIT'		, width: 80},
			{ dataIndex: 'ITEM_ACCOUNT'		, width: 80},
			{ dataIndex: 'SUPPLY_TYPE'		, width: 80},
			{ dataIndex: 'ORDER_DATE'		, width: 80},
			{ dataIndex: 'ORDER_Q'			, width: 80},
			{ dataIndex: 'CSTOCK'			, width: 100},
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 100	, hidden: true},
			{ dataIndex: 'PROJECT_NO'		, width: 100},
			{ dataIndex: 'PROJECT_NAME'		, width: 130},
			{ dataIndex: 'PJT_CODE'			, width: 100 	, hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			},
			deselect: function( model, record, index, eOpts ){
			},
			select: function( model, record, index, eOpts ){
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				records = this.getSelectedRecords();
			}
			Ext.each(records, function(record,i) {
				panelResult.setValue('REMARK', record.data.PROJECT_NAME);
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setData(record.data);
			});
			panelResult.getField('DIV_CODE').setReadOnly(true);
		}
	});

/*20191030 수주정보 팝업 추가*/
	 // 검색 모델(디테일)
    Unilite.defineModel('orderNoDetailModel', {
        fields: [
             { name: 'DIV_CODE'     ,text:'<t:message code="unilite.msg.sMS631" default="사업장"/>'           ,type: 'string' ,comboType:'BOR120'}
            ,{ name: 'ITEM_CODE'    ,text:'<t:message code="unilite.msg.sMR004" default="품목코드"/>'       	,type: 'string' }
            ,{ name: 'ITEM_NAME'    ,text:'<t:message code="unilite.msg.sMR349" default="품명"/>'     		,type: 'string' }
            ,{ name: 'SPEC'         ,text:'<t:message code="unilite.msg.sMSR033" default="규격"/>'    		,type: 'string' }

            ,{ name: 'ORDER_DATE'   ,text:'<t:message code="unilite.msg.sMS122" default="수주일"/>'        	,type: 'uniDate'}
            ,{ name: 'DVRY_DATE'    ,text:'<t:message code="unilite.msg.sMS123" default="납기일"/>'        	,type: 'uniDate'}

            ,{ name: 'ORDER_Q'      ,text:'<t:message code="unilite.msg.sMS543" default="수주량"/>'        	,type: 'uniQty' }
            ,{ name: 'ORDER_TYPE'   ,text:'<t:message code="unilite.msg.sMS832" default="판매유형"/>'       	,type: 'string' ,comboType:'AU', comboCode:'S002'}
            ,{ name: 'ORDER_PRSN'   ,text:'<t:message code="unilite.msg.sMS669" default="수주담당"/>'       	,type: 'string' ,comboType:'AU', comboCode:'S010'}
            ,{ name: 'PO_NUM'       ,text:'<t:message code="unilite.msg.sMSR281" default="PO번호"/>'      	,type: 'string' }
            ,{ name: 'PROJECT_NO'   ,text:'<t:message code="unilite.msg.sMR161" default="프로젝트번호"/>'       	,type: 'string' }
            ,{ name: 'ORDER_NUM'    ,text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>'       	,type: 'string' }
            ,{ name: 'SER_NO'       ,text:'<t:message code="unilite.msg.sMS783" default="수주순번"/>'       	,type: 'string' }
            ,{ name: 'CUSTOM_CODE'  ,text:'<t:message code="unilite.msg.sMSR213" default="거래처"/>'       	,type: 'string' }
            ,{ name: 'CUSTOM_NAME'  ,text:'<t:message code="unilite.msg.sMSR279" default="거래처명"/>'      	,type: 'string' }
            ,{ name: 'COMP_CODE'    ,text:'COMP_CODE'       ,type: 'string' }
            ,{ name: 'PJT_CODE'     ,text:'프로젝트코드'        	                                         		,type: 'string' }
            ,{ name: 'PJT_NAME'     ,text:'프로젝트'                                                        	,type: 'string' }
            ,{ name: 'FR_DATE'      ,text:'시작일'			                                                  	,type: 'string' }
            ,{ name: 'TO_DATE'      ,text:'종료일'         	                                              	,type: 'string' }
        ]
    });

 // 검색 스토어(디테일)
    var orderNoDetailStore = Unilite.createStore('orderNoDetailStore', {
        model: 'orderNoDetailModel',
        autoLoad: false,
        uniOpt: {
            isMaster: false, // 상위 버튼 연결
            editable: false, // 수정 모드 사용
            deletable: false, // 삭제 가능 여부
            useNavi: false // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 'sof100ukrvService.selectOrderNumDetailList'
            }
        },
        loadStoreRecords: function() {
            var param = orderNoSearch2.getValues();
            var authoInfo = pgmInfo.authoUser; // 권한정보(N-전체,A-자기사업장>5-자기부서)
            var deptCode = UserInfo.deptCode; // 부서코드
            if (authoInfo == "5" && Ext.isEmpty(orderNoSearch2.getValue('DEPT_CODE'))) {
                param.DEPT_CODE = deptCode;
            }
            console.log(param);
            this.load({
                params: param
            });
        }
    });
    var orderNoSearch2 = Unilite.createSearchForm('orderNoSearchForm1', {
	    layout: {
	        type: 'uniTable',
	        columns: 3
	    },
	    trackResetOnLoad: true,
	    items: [{
	            fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
	            name: 'DIV_CODE',
	            xtype: 'uniCombobox',
	            comboType: 'BOR120',
	            value: UserInfo.divCode,
	            allowBlank: false,
	            listeners: {
	                change: function(combo, newValue, oldValue, eOpts) {
	                    combo.changeDivCode(combo, newValue, oldValue, eOpts);
	                    var field = orderNoSearch.getField('ORDER_PRSN');
	                    field.fireEvent('changedivcode', field, newValue, oldValue, eOpts); // panelResult의
	                    // 필터링
	                    // 처리
	                    // 위해..
	                }
	            }
	        }, {
	            fieldLabel: '<t:message code="unilite.msg.sMS122" default="수주일"/>',
	            xtype: 'uniDateRangefield',
	            startFieldName: 'FR_ORDER_DATE',
	            endFieldName: 'TO_ORDER_DATE',
	            width: 350,
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	            colspan: 2
	        }, {
	            fieldLabel: '<t:message code="unilite.msg.sMS573" default="sMS669"/>',
	            name: 'ORDER_PRSN',
	            xtype: 'uniCombobox',
	            comboType: 'AU',
	            comboCode: 'S010',
	            onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
	                if (eOpts) {
	                    combo.filterByRefCode('refCode1', newValue, eOpts.parent);
	                } else {
	                    combo.divFilterByRefCode('refCode1', newValue, divCode);
	                }
	            }
	        },
	        Unilite.popup('AGENT_CUST', {
	            fieldLabel: '<t:message code="unilite.msg.sMSR213" default="거래처"/>',
	            validateBlank: false,
	            colspan: 2,
	            listeners: {
	                applyextparam: function(popup) {
	                    popup.setExtParam({
	                        'AGENT_CUST_FILTER': ['1', '3']
	                    });
	                    popup.setExtParam({
	                        'CUSTOM_TYPE': ['1', '3']
	                    });
	                }
	            }
	        }),
	        // Unilite.popup('AGENT_CUST',{fieldLabel:'프로젝트' , valueFieldName:'PROJECT_NO',
	        // textFieldName:'PROJECT_NAME', validateBlank: false}),
	        Unilite.popup('DIV_PUMOK', {
	            colspan: 2,
	            listeners: {
	                applyextparam: function(popup) {
	                    popup.setExtParam({
	                        'DIV_CODE': orderNoSearch.getValue('DIV_CODE')
	                    });
	                }
	            }
	        }),
	        {
	            fieldLabel: '<t:message code="unilite.msg.sMS832" default="판매유형"/>',
	            name: 'ORDER_TYPE',
	            xtype: 'uniCombobox',
	            comboType: 'AU',
	            comboCode: 'S002'
	        },
	        {
	            fieldLabel: '<t:message code="unilite.msg.sMSR281" default="PO번호"/>',
	            name: 'PO_NUM'
	        }
	    ]
	}); // createSearchForm
    // 검색 그리드(디테일)
    var orderNoDetailGrid = Unilite.createGrid('mpo502ukrvOrderNoDetailGrid', {
        layout: 'fit',
        store: orderNoDetailStore,
        uniOpt: {
            useRowNumberer: false
        },
        columns: [
        	 { dataIndex: 'DIV_CODE'			,  width: 80 }
            ,{ dataIndex: 'ITEM_CODE'			,  width: 120 }
            ,{ dataIndex: 'ITEM_NAME'			,  width: 150 }
            ,{ dataIndex: 'SPEC'				,  width: 150 }
            ,{ dataIndex: 'ORDER_DATE'			,  width: 80 }
            ,{ dataIndex: 'DVRY_DATE'			,  width: 80 		,hidden:true}
            ,{ dataIndex: 'ORDER_Q'				,  width: 80 }
            ,{ dataIndex: 'ORDER_TYPE'			,  width: 90 }
            ,{ dataIndex: 'ORDER_PRSN'			,  width: 90 		,hidden:true}
            ,{ dataIndex: 'PO_NUM'				,  width: 100 }
            ,{ dataIndex: 'PROJECT_NO'			,  width: 90 }
            ,{ dataIndex: 'ORDER_NUM'			,  width: 120 }
            ,{ dataIndex: 'SER_NO'				,  width: 70 		,hidden:true}
            ,{ dataIndex: 'CUSTOM_CODE'			,  width: 120	 	,hidden:true}
            ,{ dataIndex: 'CUSTOM_NAME'			,  width: 200 }
            ,{ dataIndex: 'COMP_CODE'			,  width: 80 		,hidden:true}
            ,{ dataIndex: 'PJT_CODE'			,  width: 120 		,hidden:true}
            ,{ dataIndex: 'PJT_NAME'			,  width: 200 }
            ,{ dataIndex: 'FR_DATE'				,  width: 80	 	,hidden:true}
            ,{ dataIndex: 'TO_DATE'				,  width: 80 		,hidden:true}
        ],
        listeners: {
            onGridDblClick: function(grid, record, cellIndex, colName) {
                orderNoDetailGrid.returnData(record)
                searchOrderWindow.hide();
            }
        } // listeners
        ,
        returnData: function(record) {
            if (Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            var selRecord = masterGrid.getSelectedRecord();
            selRecord.set('SO_NUM', record.get('ORDER_NUM'));
            selRecord.set('SO_SEQ', record.get('SER_NO'));
            selRecord.set('SO_PLACE', record.get('CUSTOM_CODE'));
            selRecord.set('SO_PLACE_NAME', record.get('CUSTOM_NAME'));
            selRecord.set('SO_ITEM_NAME', record.get('ITEM_NAME'));
        }
    });




	Unilite.Main({
		id: 'mpo502ukrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult,masterGrid
			]
		}],
		fnInitBinding: function(params) {
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			UniAppManager.setToolbarButtons(['reset','newData','print', 'prev', 'next'], true);
			this.setDefault();
			panelResult.setValue('ORDER_PRSN',BsaCodeInfo.gsOrderPrsn);
			if(BsaCodeInfo.gsApproveYN == '1'){
				Ext.getCmp('AGREE_DATEr').setHidden(false);
				Ext.getCmp('AGREE_STATUSr').setHidden(false);
				Ext.getCmp('AGREE_PRSN_NAMEr').setHidden(false);
				Ext.getCmp('AGREE_STATUSp').setHidden(false);
			}else if(BsaCodeInfo.gsApproveYN == '2'){
				Ext.getCmp('AGREE_DATEr').setHidden(true);
				Ext.getCmp('AGREE_STATUSr').setHidden(true);
				Ext.getCmp('AGREE_PRSN_NAMEr').setHidden(true);
				Ext.getCmp('AGREE_STATUSp').setHidden(true);
				panelResult.setValue('AGREE_STATUS','2');
			}
			mpo502ukrvService.userWhcode({}, function(provider, response)   {
				if(!Ext.isEmpty(provider)){
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			});
			var param = {"SUB_CODE": BsaCodeInfo.gsOrderPrsn};
			mpo502ukrvService.userName(param, function(provider, response)  {
				if(!Ext.isEmpty(provider)){
					panelResult.setValue('AGREE_PRSN',provider['USER_ID']);
					panelResult.setValue('AGREE_PRSN_NAME',provider['USER_NAME']);
				}
			});

			panelResult.getField('AGREE_PRSN').setHidden(true);

			if(!Ext.isEmpty(params && params.PGM_ID)){
				//inoutTypeChk = params.PGM_ID;
				this.processParams(params);
			}
		},
		// 링크로 넘어오는 params 받는 부분
		processParams: function(params) {
			if(params.PGM_ID == 'mpo131skrv'){
				if(!Ext.isEmpty(params.ORDER_NUM)){
					panelResult.setValue('DIV_CODE',params.DIV_CODE);
					panelResult.setValue('ORDER_NUM',params.ORDER_NUM);
					panelResult.setValue('CUSTOM_CODE',params.CUSTOM_CODE);
					panelResult.setValue('CUSTOM_NAME',params.CUSTOM_NAME);
					panelResult.setValue('ORDER_DATE',params.ORDER_DATE);
					panelResult.setValue('MONEY_UNIT',params.MONEY_UNIT);
					panelResult.setValue('PROJECT_NO',params.PROJECT_NO);

					UniAppManager.app.onQueryButtonDown();
				}
			}
			else if(params.PGM_ID == 'mpo135skrv'){
				if(!Ext.isEmpty(params.ORDER_NUM)){
					panelResult.setValue('DIV_CODE',params.DIV_CODE);
					panelResult.setValue('ORDER_NUM',params.ORDER_NUM);
					panelResult.setValue('CUSTOM_CODE',params.CUSTOM_CODE);
					panelResult.setValue('CUSTOM_NAME',params.CUSTOM_NAME);
					panelResult.setValue('ORDER_DATE',params.ORDER_DATE);
					panelResult.setValue('MONEY_UNIT',params.MONEY_UNIT);
					panelResult.setValue('PROJECT_NO',params.PROJECT_NO);

					UniAppManager.app.onQueryButtonDown();
				}
			}
		},
		onQueryButtonDown: function()   {
			panelResult.setAllFieldsReadOnly(false);
			var orderNo = panelResult.getValue('ORDER_NUM');

			if(Ext.isEmpty(orderNo)) {
				openSearchInfoWindow()
			} else {
				var param= panelResult.getValues();
				panelResult.uniOpt.inLoading=true;
				panelResult.getForm().load({
					params: param,
					success:function(form, action)  {
						panelResult.setAllFieldsReadOnly(true);
						panelResult.uniOpt.inLoading=false;
					},
					failure: function(form, action) {
						panelResult.uniOpt.inLoading=false;
					}
				})
				directMasterStore1.loadStoreRecords();
			}
		},
		onNewDataButtonDown: function() {
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
			 var orderNum = panelResult.getValue('ORDER_NUM');
			 var seq = directMasterStore1.max('ORDER_SEQ');
			 if(!seq) seq = 1;
			 else  seq += 1;
			 var divCode = panelResult.getValue('DIV_CODE');
			 var cutomCode = panelResult.getValue('CUSTOM_CODE');
			 var controlStatus = '1';
			 var orderQ = '0';
			 var orderP = '0';
			 var orderUnitQ = '0';
			 var unitPriceType = 'Y';
			 var moneyUnit = panelResult.getValue('MONEY_UNIT');
			 var orderUnitP = '0';
			 var orderO = '0';
			 var trnsRate = '1';
			 var instockQ = '0';
			 var dvryDate = UniDate.get('today');
			 var compCode = panelResult.getValue('COMP_CODE');

			 var projectNo = panelResult.getValue('PROJECT_NO');
			 var exchgRateO = panelResult.getValue('EXCHG_RATE_O');
			 var inDivCode = '';
			 if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))) {
				 inDivCode = panelResult.getValue('DIV_CODE');
			 }

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
				MONEY_UNIT: moneyUnit,
				ORDER_UNIT_P: orderUnitP,
				ORDER_O: orderO,
				TRNS_RATE: trnsRate,
				INSTOCK_Q: instockQ,
				DVRY_DATE: dvryDate,
				COMP_CODE: compCode,
				PROJECT_NO: projectNo,
				EXCHG_RATE_O: exchgRateO,
				IN_DIV_CODE: inDivCode
			};
			masterGrid.createRow(r);
//		  panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('INSPEC_Q') > 1)
				{
					alert('<t:message code="unilite.msg.sMM435"/>');
				}else if(selRow.get('MODIFY_AUTH_CHK') == 'N'){
					alert('<t:message code="system.message.purchase.message104" default="해당건에 대해 거래처 납품등록이 되어 수정 또는 삭제할 수 없습니다."/>');
				}else{
					masterGrid.deleteSelectedRow();
				}
			}
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore1.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					 //신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{								  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						if(record.get('INSPEC_Q') > 1){
								alert('<t:message code="unilite.msg.sMM435"/>');
						}else if(record.get('MODIFY_AUTH_CHK') == 'N'){
							alert('<t:message code="system.message.purchase.message104" default="해당건에 대해 거래처 납품등록이 되어 수정 또는 삭제할 수 없습니다."/>');
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
			if(isNewData){							  //신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
			}
		},
		onPrintButtonDown: function() {
			if(panelResult.getValue('AGREE_STATUS') != '2'){
				if(BsaCodeInfo.gsM008Ref3 != 'Y'){//사전승인일때만
					alert('미승인건은 인쇄할 수 없습니다.');
					return false;
				}
			}

			var param= Ext.getCmp('resultForm').getValues();
			param.PGM_ID = PGM_ID;  //프로그램ID
			param.MAIN_CODE = 'M030'; //해당 모듈의 출력정보를 가지고 있는 공통코드
			param.sTxtValue2_fileTitle = '발 주 서';
			var reportGubun = BsaCodeInfo.gsReportGubun;//BsaCodeInfo.gsReportGubun
			if(Ext.isEmpty(reportGubun) || reportGubun == 'CR'){
			var win = Ext.create('widget.CrystalReport', {
				url: CPATH+'/matrl/mpo150crkrv.do',
				prgID: 'mpo502rkr',
					extParam: {
						sTxtValue2_fileTitle : '발 주 서',
						ORDER_NUM : param.ORDER_NUM,
						DIV_CODE : panelResult.getValue('DIV_CODE')
					}
				});
			}else{
				param.REMARK = '';				//20210726 추가: 코브에서 remark에 '%'들어가 있어서 출력 오류 발생, remark는 출력시 데이터 조회와 관계 없으므로 ''로 변경하고 진행 
				var win = Ext.create('widget.ClipReport', {
					url: CPATH+'/matrl/mpo150clrkrv.do',
					prgID: 'mpo502ukrv',
					extParam: param
				});
			}
			win.center();
			win.show();
		},
		setDefault: function() {
			var param = panelResult.getValues();
			mpo502ukrvService.selectOrderPrsn(param, function(provider, response){
				if(!Ext.isEmpty(provider)) {
					panelResult.setValue('ORDER_PRSN', provider[0].SUB_CODE);
//					panelResult.getField('ORDER_PRSN').setReadOnly(true);
//					panelResult.getField('ORDER_PRSN').setReadOnly(true);
				} else {
					panelResult.getField('ORDER_PRSN').setReadOnly(false);
				}
			});
			UniAppManager.app.fnExchngRateO(true);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ORDER_DATE',new Date());
			panelResult.setValue('ORDER_TYPE','1');
			panelResult.setValue('AGREE_STATUS','1');
			panelResult.setValue('MONEY_UNIT',BsaCodeInfo.gsDefaultMoney);
			panelResult.setValue('DRAFT_YN','N');
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
			var field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = orderNoSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			gsSaveRefFlag = 'N';
			panelResult.setValue('RECEIPT_TYPE','100');
			//Ext.getCmp('ORDER_PRINT').setDisabled(true);
			if(UserInfo.deptName == '시너지이노베이션'){
				UniAppManager.setToolbarButtons(['print'], false);
			}
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelResult.getValue('ORDER_NUM')))   {
				alert('<t:message code="unilite.msg.sMS533" default="수주번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
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
					if(provider.BASE_EXCHG == "1" && !isIni && !Ext.isEmpty(panelResult.getValue('MONEY_UNIT')) && panelResult.getValue('MONEY_UNIT') != "KRW"){
					}
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
				dOrderO = Unilite.multiply(dOrderUnitQ, dOrderUnitP) //금액 = 발주량 * 단가
//			  dOrderO = (dOrderUnitQ * (dOrderUnitP * 1000)) / 1000
//			  dOrderO = dOrderO.toFixed(3);
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
					directMasterStore1.fnSumOrderO();
				break;

				case "ORDER_UNIT_Q" : //발주량
					if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "Q", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_UNIT_P":	// 단가
					if(record.get('UNIT_PRICE_TYPE') == 'Y' && record.get('SUPPLY_TYPE') != '4'){
						if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
						}
					}
					UniAppManager.app.fnCalOrderAmt(record, "P", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_O" :
					if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "O", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "MONEY_UNIT" :
					if(newValue == BsaCodeInfo.gsDefaultMoney){
						record.set('EXCHG_RATE_O', '1');
					}
					UniAppManager.app.fnCalOrderAmt(record, "X");
					directMasterStore1.fnSumOrderO();
					break;

				case "EXCHG_RATE_O":
					if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "X", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_LOC_P":
					if(record.get('UNIT_PRICE_TYPE') == 'Y'){
						if(newValue <= 0){
							rv='<t:message code="unilite.msg.sMB076"/>';
							break;
						}
					}
					UniAppManager.app.fnCalOrderAmt(record, "L", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_LOC_O":
					if(newValue <= 0){
							rv='<t:message code="unilite.msg.sMB076"/>';
							break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "I", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "DVRY_DATE":
					if(newValue < panelResult.getValue('ORDER_DATE')){
						rv='<t:message code="unilite.msg.sMM374"/>';
								break;
					}
					var ordernum = record.get('ORDER_NUM');
					if(ordernum == "")  {
						record.set('INIT_DVRY_DATE', newValue);
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
					if((panelResult.getValue('ORDER_YN')== '1') && newValue == '9'){
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
					directMasterStore1.fnSumOrderO();
					break;

				case "PROJECT_NO":

					break;
				case "IN_DIV_CODE" : //입고사업장
					 var itemCode = record.get('ITEM_CODE');
					 if(itemCode != "")  {
						// Ext.getBody().mask();
						 var param = {'DIV_CODE':newValue, 'ITEM_CODE':itemCode, 'S_COMP_CODE':UserInfo.compCode, 'USELIKE':false, 'TYPE':'VALUE'};
						  popupService.divPumokPopup(param, function(provider, response)  {
															 if(Ext.isEmpty(provider))   {
																 alert('<t:message code="system.message.sales.message035" default="사업장에 대한 품목정보가 존재하지 않습니다."/>');
																 Ext.getBody().unmask();
															 } else {
																 console.log("provider",provider)
																 if(!Ext.isEmpty('provider')) masterGrid.setItemData(provider[0],false,record);
																 else masterGrid.setItemData(null, true);
															 }
						 });
					 }
					break;
			}
			return rv;
		}
	});
};
</script>