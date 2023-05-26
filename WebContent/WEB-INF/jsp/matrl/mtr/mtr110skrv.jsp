<%--
'   프로그램명 : 입고현황조회 (구매재고)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mtr110skrv"  >
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
	gsInOutPrsn	: '${gsInOutPrsn}',
	gsPrintUrl	: '${gsPrintUrl}',				//20200519 추가: 프린트 시 호출할 url
	gsPrintPath	: '${gsPrintPath}',				//20200519 추가: 프린트 시 호출할 파일 경로
	gsItemAccnt	: '${gsItemAccnt}'
};
//20200520 추가: 라벨출력버튼 hidden여부 설정 - 출력호출 URL(M030.REF_CODE8), crf파일경로(M030.REF_CODE9)가 있으면 체크박스 / 라벨출력 버튼 보이도록 설정 , 20200521 사용 안 함 -> 신규프로그램으로 대체
//var buttonHidden = false;
//if(Ext.isEmpty(BsaCodeInfo.gsPrintUrl) || Ext.isEmpty(BsaCodeInfo.gsPrintPath)) {
//	buttonHidden = true;
//}

function appMain() {
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mtr110skrvService.selectList'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mtr110skrvService.selectList'
		}
	});

	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mtr110skrvService.selectList'
		}
	});



	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Mtr110skrvModel1', {
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
			{name: 'MAKE_EXP_DATE'			, text: '<t:message code="system.label.inventory.expirationdate" default="유통기한"/>'			, type: 'string'},
			{name: 'INOUT_NUM'				, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string'},
			{name: 'INOUT_METH'				, text: '<t:message code="system.label.purchase.tranmethod" default="수불방법"/>'				, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		, text: '<t:message code="system.label.purchase.trantype" default="수불유형"/>'					, type: 'string'},
			
			{name: 'SO_NUM'		, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'					, type: 'string'},

			{name: 'ORDER_DATE'				, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'					, type: 'uniDate'},
			{name: 'ORDER_NUM'				, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'					, type: 'int'},
			{name: 'DVRY_DATE'				, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				, type: 'uniDate'},
			{name: 'BUY_Q'					, text: '<t:message code="system.label.purchase.purchaseqty" default="매입량"/>'				, type: 'uniQty'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'+'1'					, type: 'string'},
			{name: 'REMARK2'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'+'2'					, type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'LOT_NO'					, text: 'LOT NO'				, type: 'string'},
			{name: 'LC_NUM'					, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'					, type: 'string'},
			{name: 'BL_NUM'					, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'					, type: 'string'},
			{name: 'CREATE_LOC'				, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'				, type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'					, type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '<t:message code="system.label.purchase.entrydate" default="등록일"/>'					, type: 'uniDate'},
			//20190111 입고량(ORDER_UNIT_Q), 발주단위(ORDER_UNIT) 추가
			{name: 'ORDER_UNIT_Q'			, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				, type: 'uniQty'},
			{name: 'ORDER_UNIT'				, text: '<t:message code="system.label.purchase.pounit2" default="발주단위"/>'					, type: 'string'},
			{name: 'RECEIPT_DATE'			, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'				, type: 'uniDate'},
			{name: 'ORDER_UNIT_FOR_P'		, text: '<t:message code="system.label.purchase.receiptprice" default="입고단가"/>'				, type: 'uniUnitPrice', allowBlank: true},
			{name: 'ORDER_UNIT_FOR_O'		, text: '<t:message code="system.label.purchase.receiptamount" default="입고금액"/>'			, type: 'uniPrice'/*, allowBlank: false*/},
			{name: 'SQM'					, text: 'SQM'																				, type: 'float'	, decimalPrecision: 2	, format:'0,000.00'},
			{name: 'ORDER_TYPE'				, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string', comboType: "AU", comboCode: "M001"},
			//20200520 추가
			{name: 'ITEM_ACCOUNT'			, text: 'ITEM_ACCOUNT'			, type: 'string'},
			//20200521 추가
			{name: 'INOUT_SEQ'				, text: 'INOUT_SEQ'				, type: 'int'},
			// 20210215 조달구분(SUPPLY_TYPE) 추가
			{name: 'SUPPLY_TYPE'			, text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>', type: 'string', comboType: "AU", comboCode: "B014"}
		]
	});

	Unilite.defineModel('Mtr110skrvModel2', {
		fields: [
			{name: 'ITEM_LEVEL1'			, text: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL2'			, text: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL3'			, text: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>'				, type: 'string'},
			{name: 'INDEX01'				, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type: 'string'},//INOUT_CODE
			{name: 'INDEX02'				, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type: 'string'},//CUSTOM_NAME
			{name: 'BARCODE'				, text: '<t:message code="system.label.purchase.barcode" default="바코드"/>'					, type: 'string'},
			{name: 'INDEX03'				, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate'},//INOUT_DATE
			{name: 'INDEX04'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					, type: 'string'},//ITEM_CODE
			{name: 'INDEX05'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					, type: 'string'},//ITEM_NAME
			{name: 'INDEX06'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'						, type: 'string'},//SPEC
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
			{name: 'MAKE_EXP_DATE'			, text: '<t:message code="system.label.inventory.expirationdate" default="유통기한"/>'			, type: 'string'},
			{name: 'INOUT_NUM'				, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string'},
			{name: 'INOUT_METH'				, text: '<t:message code="system.label.purchase.tranmethod" default="수불방법"/>'				, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		, text: '<t:message code="system.label.purchase.trantype" default="수불유형"/>'					, type: 'string'},
			{name: 'SO_NUM'		, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'					, type: 'string'},

			{name: 'ORDER_DATE'				, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'					, type: 'uniDate'},
			{name: 'ORDER_NUM'				, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'					, type: 'int'},
			{name: 'DVRY_DATE'				, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				, type: 'uniDate'},
			{name: 'BUY_Q'					, text: '<t:message code="system.label.purchase.purchaseqty" default="매입량"/>'				, type: 'uniQty'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'+'1'					, type: 'string'},
			{name: 'REMARK2'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'+'2'					, type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'LOT_NO'					, text: 'LOT NO'				, type: 'string'},
			{name: 'LC_NUM'					, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'					, type: 'string'},
			{name: 'BL_NUM'					, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'					, type: 'string'},
			{name: 'CREATE_LOC'				, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'				, type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'					, type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '<t:message code="system.label.purchase.entrydate" default="등록일"/>'					, type: 'uniDate'},
			//20190111 입고량(ORDER_UNIT_Q), 발주단위(ORDER_UNIT) 추가
			{name: 'ORDER_UNIT_Q'			, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				, type: 'uniQty'},
			{name: 'ORDER_UNIT'				, text: '<t:message code="system.label.purchase.pounit2" default="발주단위"/>'					, type: 'string'},
			{name: 'RECEIPT_DATE'			, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'				, type: 'uniDate'},
			{name: 'ORDER_UNIT_FOR_P'		, text: '<t:message code="system.label.purchase.receiptprice" default="입고단가"/>'				, type: 'uniUnitPrice', allowBlank: true},
			{name: 'ORDER_UNIT_FOR_O'		, text: '<t:message code="system.label.purchase.receiptamount" default="입고금액"/>'			, type: 'uniPrice'/*, allowBlank: false*/},
			{name: 'SQM'					, text: 'SQM'																				, type: 'float'	, decimalPrecision: 2	, format:'0,000.00'},
			{name: 'ORDER_TYPE'				, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string', comboType: "AU", comboCode: "M001"},
			//20200520 추가
			{name: 'ITEM_ACCOUNT'			, text: 'ITEM_ACCOUNT'			, type: 'string'},
			//20200521 추가
			{name: 'INOUT_SEQ'				, text: 'INOUT_SEQ'				, type: 'int'},
			// 20210215 조달구분(SUPPLY_TYPE) 추가
			{name: 'SUPPLY_TYPE'			, text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>', type: 'string', comboType: "AU", comboCode: "B014"}
		]
	});

	Unilite.defineModel('Mtr110skrvModel3', {
		fields: [
			{name: 'ITEM_LEVEL1'			, text: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL2'			, text: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>'				, type: 'string'},
			{name: 'ITEM_LEVEL3'			, text: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>'				, type: 'string'},
			{name: 'INDEX01'				, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type: 'string'},//INOUT_CODE
			{name: 'INDEX02'				, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type: 'string'},//CUSTOM_NAME
			{name: 'BARCODE'				, text: '<t:message code="system.label.purchase.barcode" default="바코드"/>'					, type: 'string'},
			{name: 'INDEX06'				, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate'},//INOUT_DATE
			{name: 'INDEX03'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					, type: 'string'},//ITEM_CODE
			{name: 'INDEX04'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					, type: 'string'},//ITEM_NAME
			{name: 'INDEX05'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'						, type: 'string'},//SPEC
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
			{name: 'MAKE_EXP_DATE'			, text: '<t:message code="system.label.inventory.expirationdate" default="유통기한"/>'			, type: 'string'},
			{name: 'INOUT_NUM'				, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string'},
			{name: 'INOUT_METH'				, text: '<t:message code="system.label.purchase.tranmethod" default="수불방법"/>'				, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		, text: '<t:message code="system.label.purchase.trantype" default="수불유형"/>'					, type: 'string'},
			{name: 'SO_NUM'		, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'					, type: 'string'},

			{name: 'ORDER_DATE'				, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'					, type: 'uniDate'},
			{name: 'ORDER_NUM'				, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'					, type: 'int'},
			{name: 'DVRY_DATE'				, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				, type: 'uniDate'},
			{name: 'BUY_Q'					, text: '<t:message code="system.label.purchase.purchaseqty" default="매입량"/>'				, type: 'uniQty'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'+'1'				, type: 'string'},
			{name: 'REMARK2'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'+'2'				, type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'LOT_NO'					, text: 'LOT NO'				, type: 'string'},
			{name: 'LC_NUM'					, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'					, type: 'string'},
			{name: 'BL_NUM'					, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'					, type: 'string'},
			{name: 'CREATE_LOC'				, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'				, type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'					, type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '<t:message code="system.label.purchase.entrydate" default="등록일"/>'					, type: 'uniDate'},
			//20190111 입고량(ORDER_UNIT_Q), 발주단위(ORDER_UNIT) 추가
			{name: 'ORDER_UNIT_Q'			, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				, type: 'uniQty'},
			{name: 'ORDER_UNIT'				, text: '<t:message code="system.label.purchase.pounit2" default="발주단위"/>'					, type: 'string'},
			{name: 'ORDER_UNIT_FOR_P'		, text: '<t:message code="system.label.purchase.receiptprice" default="입고단가"/>'				, type: 'uniUnitPrice', allowBlank: true},
			{name: 'ORDER_UNIT_FOR_O'		, text: '<t:message code="system.label.purchase.receiptamount" default="입고금액"/>'			, type: 'uniPrice'/*, allowBlank: false*/},
			{name: 'SQM'					, text: 'SQM'																				, type: 'float'	, decimalPrecision: 2	, format:'0,000.00'},
			{name: 'ORDER_TYPE'				, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string', comboType: "AU", comboCode: "M001"},
			//20200520 추가
			{name: 'ITEM_ACCOUNT'			, text: 'ITEM_ACCOUNT'			, type: 'string'},
			//20200521 추가
			{name: 'INOUT_SEQ'				, text: 'INOUT_SEQ'				, type: 'int'},
			// 20210215 조달구분(SUPPLY_TYPE) 추가
			{name: 'SUPPLY_TYPE'			, text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>', type: 'string', comboType: "AU", comboCode: "B014"}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mtr110skrvMasterStore1',{
		proxy: directProxy1,
		model: 'Mtr110skrvModel1',
		uniOpt: {
			isMaster: false,		 // 상위 버튼 연결
			editable: false,		 // 수정 모드 사용
			deletable:false,		 // 삭제 가능 여부
			useNavi : false		 // prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
//			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
//			var deptCode = UserInfo.deptCode;	//부서코드
//			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('searchForm').getValue('DEPT_CODE'))){
//				param.DEPT_CODE = deptCode;
//			}
			param.QUERY_TYPE='1';
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'INDEX02',
		listeners:{
			load:function( store, records, successful, operation, eOpts )	{
				if(records && records.length > 0){
					itemGrid.setShowSummaryRow(true);
				}
			}
		}
	});//End of var directMasterStore1 = Unilite.createStore('mtr110skrvMasterStore1',{

	var directMasterStore2 = Unilite.createStore('mtr110skrvMasterStore2',{
		proxy: directProxy2,
		model: 'Mtr110skrvModel2',
		uniOpt: {
			isMaster: false,		 // 상위 버튼 연결
			editable: false,		 // 수정 모드 사용
			deletable:false,		 // 삭제 가능 여부
			useNavi : false		 // prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
//			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
//			var deptCode = UserInfo.deptCode;	//부서코드
//			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('searchForm').getValue('DEPT_CODE'))){
//				param.DEPT_CODE = deptCode;
//			}
			param.QUERY_TYPE='2';
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'INDEX02',
		listeners:{
			load:function( store, records, successful, operation, eOpts )	{
				if(records && records.length > 0){
					customGrid.setShowSummaryRow(true);
				}
			}
		}
	});

	var directMasterStore3 = Unilite.createStore('mtr110skrvMasterStore3',{
		proxy: directProxy3,
		model: 'Mtr110skrvModel3',
		uniOpt: {
			isMaster: false,		 // 상위 버튼 연결
			editable: false,		 // 수정 모드 사용
			deletable:false,		 // 삭제 가능 여부
			useNavi : false		 // prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
//			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
//			var deptCode = UserInfo.deptCode;	//부서코드
//			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('searchForm').getValue('DEPT_CODE'))){
//				param.DEPT_CODE = deptCode;
//			}
			param.QUERY_TYPE='3';
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'INDEX02',
		listeners:{
			load:function( store, records, successful, operation, eOpts )	{
				if(records && records.length > 0){
					masterGrid.setShowSummaryRow(true);
				}
			}
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
   			collapsible:false,
		   	layout: {type: 'uniTable', columns: 1},
		   	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				child: 'WH_CODE',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_FR_DATE',
				endFieldName: 'INOUT_TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				//holdable: 'hold',
				width: 315,
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
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_CODE', newValue);
								panelResult.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_NAME', '');
									panelResult.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_NAME', newValue);
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_CODE', '');
									panelResult.setValue('ITEM_CODE', '');
								}
							},
						applyextparam: function(popup){	// 2021.08 표준화 작업
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							popup.setExtParam({'ITEM_ACCOUNT_FILTER': BsaCodeInfo.gsItemAccnt.split(',')});
						}
					}
		   }),{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M001',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_CODE', newValue);
								panelResult.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_NAME', '');
									panelResult.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_NAME', newValue);
								panelResult.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_CODE', '');
									panelResult.setValue('CUSTOM_CODE', '');
								}
							},
				            applyextparam: function(popup){
				                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
		                	}
					}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.grid.btnSummary" default="합계표시"/>',
				xtype: 'uniCheckboxgroup',
				items: [{
					boxLabel: '',
					name: 'CHECK_SUM',
					width: 70,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('CHECK_SUM', newValue);
						}
					}
				}]
			}]
   			},{
			title:'<t:message code="system.label.purchase.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			collapsible: true,
			layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					},beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						store.clearFilter();
						if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
							 store.filterBy(function(record){
							 return record.get('option') == panelSearch.getValue('DIV_CODE');
							})
						 }else{
						   store.filterBy(function(record){
								return false;
						   })
						 }
					}
				}
			},
			{
				fieldLabel: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020',
				multiSelect: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					},
					beforequery: function(queryPlan, eOpts )	{
					/*	var fValue = BsaCodeInfo.gsItemAccnt;
						var store = queryPlan.combo.getStore();
						if(!Ext.isEmpty(fValue) )	{
							store.clearFilter(true);
							queryPlan.combo.queryFilter = null;
							console.log("fValue :",fValue);

							//20190227 - 품목계정 콤보 값 설정을 위한 REF_CODE3값 확인
							var records = store.data.items;
							var count = 0;
							Ext.each(records, function(record, i)	{
								if(!Ext.isEmpty(record.get('refCode3'))) {
									count++;
								}
							});
							if(count > 0) {
								store.filterBy(function(record, id){
									return fValue.indexOf(record.get('refCode3')) > -1 ? record:null;
								});

							} else {
								store.filterBy(function(record, id){
									console.log("record :",record.get('value'),fValue.indexOf(record.get('value')));
									return fValue.indexOf(record.get('value')) > -1 ? record:null;
								});
							}
						} else {
							store.clearFilter(true);
							queryPlan.combo.queryFilter = null;
							store.loadRawData(store.proxy.data);
						}*/
					}
				}
			},
			{
				fieldLabel: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>',
				name: 'INOUT_TYPE_DETAIL',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M103',
				multiSelect: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_TYPE_DETAIL', newValue);
					}
				}
			},
			//프로젝트번호
			Unilite.popup('PJT',{
				fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				valueFieldName: 'PJT_CODE',
				listeners: {
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
			}),
			{
				xtype: 'radiogroup',
				id:'DVRY_TYPE',
				fieldLabel: '<t:message code="system.label.purchase.deliverylapse" default="납기경과"/>',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width: 60,				//20200521 수정: 80 -> 60
					name: 'DVRY_TYPE',
					inputValue: '0',
					checked: true
				},//All
				{
					boxLabel: '<t:message code="system.label.purchase.deliveryobservance" default="납기준수"/>',
					width: 80,
					name: 'DVRY_TYPE',
					inputValue: '1'
				}, //Complete
				{
					boxLabel: '<t:message code="system.label.purchase.deliverylapse" default="납기경과"/>',
					width: 80,
					name: 'DVRY_TYPE',
					inputValue: '2'
				} //Over
				],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						Ext.getCmp('DVRY_TYPE').setValue(newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
				name: 'CREATE_LOC',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M505',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CREATE_LOC', newValue);
					}
				}

			},{
				fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_FR_DATE',
				endFieldName: 'ORDER_TO_DATE',
				width: 315,
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
				fieldLabel: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'DVRY_FR_DATE',
				endFieldName: 'DVRY_TO_DATE',
				width: 315,
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
				fieldLabel: '<t:message code="system.label.purchase.currency2" default="통화"/>',
				name: 'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B004',
				displayField: 'value',
				fieldStyle: 'text-align: center;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('MONEY_UNIT', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'TXTLV_L2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'TXTLV_L3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL3', newValue);
					}
				}
			},{
				fieldLabel: 'LOT NO',
				name: 'LOT_NO',
				xtype: 'uniTextfield'
			}
//			,Unilite.popup('DEPT', {
//				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
//				valueFieldName: 'DEPT_CODE',
//		   		textFieldName: 'DEPT_NAME',
//				valueFieldWidth: 50,
//				textFieldWidth: 185,
//				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
//							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
//						},
//						scope: this
//					},
//					onClear: function(type)	{
//								panelResult.setValue('DEPT_CODE', '');
//								panelResult.setValue('DEPT_NAME', '');
//					},
//						applyextparam: function(popup){
//							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
//							var deptCode = UserInfo.deptCode;	//부서정보
//							var divCode = '';					//사업장
//
//							if(authoInfo == "A"){	//자기사업장
//								popup.setExtParam({'DEPT_CODE': ""});
//								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
//
//							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
//								popup.setExtParam({'DEPT_CODE': ""});
//								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
//
//							}else if(authoInfo == "5"){		//부서권한
//								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
//								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
//							}
//						}
//				}
//			})
			]}
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
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
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
			colspan			: 2,				//20200520 추가
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_CODE', newValue);
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_NAME', newValue);
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){	// 2021.08 표준화 작업
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							popup.setExtParam({'ITEM_ACCOUNT_FILTER': BsaCodeInfo.gsItemAccnt.split(',')});
						}
				}
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
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
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('CUSTOM_CODE', newValue);
							panelResult.setValue('CUSTOM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('CUSTOM_NAME', newValue);
							panelResult.setValue('CUSTOM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_CODE', '');
							}
						},
						applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
						}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.grid.btnSummary" default="합계표시"/>',
			xtype		: 'uniCheckboxgroup',
			items		: [{
				boxLabel	: '',
				name		: 'CHECK_SUM',
				width		: 70,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('CHECK_SUM', newValue);
					}
				}
			}]
		}/*,{	//20200520 추가: 라벨출력 기능 추가(이노베이션), 20200521 사용 안 함 -> 신규프로그램으로 대체
			xtype	: 'button',
			text	: '<div style="color: red"><t:message code="system.label.purchase.labelprint" default="라벨출력"/></div>',
			margin	: '0 0 0 95',
			hidden	: buttonHidden,
			handler	: function() {
				//이노베이션의 경우,
				if(BsaCodeInfo.gsPrintPath == '/Clipreport4/Z_in/') {
					var activeTabId = tab.getActiveTab().getId();
					var records;
					var dataErr	= false;
					var errMsg	= '';
					var errItem;
					var data;
					var data2;																					//20200521 추가
					if(activeTabId == 'mtr110skrvGrid1'){
						records = itemGrid.getSelectedRecords();
						errItem = 'INDEX01';
					} else if(activeTabId == 'mtr110skrvGrid2'){
						records = customGrid.getSelectedRecords();
						errItem = 'INDEX04';
					} else if(activeTabId == 'mtr110skrvGrid3'){
						records = masterGrid.getSelectedRecords();
						errItem = 'INDEX03';
					}
					Ext.each(records, function(record, index) {
						if(record.get('ITEM_ACCOUNT') != '00' && record.get('ITEM_ACCOUNT') != '05' && record.get('ITEM_ACCOUNT') != '40' && record.get('ITEM_ACCOUNT') != '50') {
							errMsg	= '<t:message code="system.message.purchase.message107" default="출력양식이 없어 출력할 수 없습니다."/>(<t:message code="system.label.purchase.itemcode" default="품목코드"/>: ' + record.get(errItem) + ')';
							dataErr	 = true;
							return false;
						} else {
							if(index == 0) {
								data = record.get('INOUT_NUM') + '/' + record.get('INOUT_SEQ');					//20200521 수정: INOUT_SEQ 추가
								data2 = record.get('INOUT_NUM');												//20200521 추가
							} else {
								data = data + ',' + record.get('INOUT_NUM') + '/' + record.get('INOUT_SEQ');	//20200521 수정: INOUT_SEQ 추가
								data2 = data2 + ',' + record.get('INOUT_NUM');									//20200521 추가
							}
						}
					});
					if(dataErr) {
						Unilite.messageBox(errMsg);
						return false;
					}
				}
				var param	= {
					PGM_ID		: PGM_ID,
					MAIN_CODE	: 'M030',
					CRF_PATH	: BsaCodeInfo.gsPrintPath,
					DIV_CODE	: panelResult.getValue('DIV_CODE'),
					INOUT_DATA	: data,
					INOUT_NUMS	: data2																			//20200521 추가
				};
				var win		= Ext.create('widget.ClipReport', {
					url		: CPATH + BsaCodeInfo.gsPrintUrl,
					prgID	: 'mtr110skrv',
					extParam: param
				});
				win.center();
				win.show();
			}
		}*/],
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
					Unilite.messageBox(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					  var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)   {
							var popupFC = item.up('uniPopupField');
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
					if(item.isPopupField)   {
						var popupFC = item.up('uniPopupField');
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
	var itemGrid = Unilite.createGrid('mtr110skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		title	: '<t:message code="system.label.purchase.itemby" default="품목별"/>',
		tbar	: [{
			xtype		: 'uniNumberfield',
			fieldLabel	: '<t:message code="system.label.purchase.selectionsummary" default="선택된 데이터 합계"/>',
			itemId		: 'selectionSummaryItem',
			readOnly	: true,
			value		: 0,
			format		: '0,000.0000',
			labelWidth	: 110,
			decimalPrecision:4
		}],
		uniOpt: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			onLoadSelectFirst	: false,	//20200520 추가: false
			//20191205 필터기능 추가
			filter				: {
				useFilter	: true,
				autoCreate	: true
			},
			excel: {
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: true,		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		//20200520 추가: 출력여부에 따라 그리드 selModel 설정, 20200521 사용 안 함 -> 신규프로그램으로 대체
/*		selModel	: buttonHidden ? 'rowmodel' : Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false,
													listeners: {
														select: function(grid, selectRecord, index, rowIndex, eOpts ){
														},
														deselect:  function(grid, selectRecord, index, eOpts ){
														}
													}
												}),*/
		columns		: [{
				//20200520 추가
				xtype	: 'rownumberer',
				sortable: false,
				width	: 35,
				align	: 'center  !important',
				resizable: true
			},
//			{dataIndex: 'ITEM_ACCOUNT'		, width: 120, locked: false},
			{dataIndex: 'INDEX01'			, width: 120, locked: false},
			{dataIndex: 'INDEX02'			, width: 150, locked: false},
			{dataIndex: 'BARCODE'			, width: 88, locked: false},
			{dataIndex: 'INDEX03'			, width: 150, locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.subtotal" default="소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
			}},
			{dataIndex: 'RECEIPT_DATE'		, width: 86, locked: false },
			{dataIndex: 'INDEX04'			, width: 86, locked: false},
			{dataIndex: 'INDEX05'			, width: 150},
			{dataIndex: 'INDEX06'			, width: 166},
			//20190111 입고량(ORDER_UNIT_Q), 발주단위(ORDER_UNIT) 추가
			{dataIndex: 'ORDER_UNIT_Q'		, width: 95	, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT'		, width: 66},
			{dataIndex: 'SQM'				, width: 95,summaryType: 'sum', hidden: true},
			{dataIndex: 'ORDER_UNIT_FOR_P'	, width: 100,summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_FOR_O'	, width: 100,summaryType: 'sum'},
			{dataIndex: 'INOUT_Q'			, width: 95,summaryType: 'sum'},
			{dataIndex: 'INOUT_P'			, width: 100},
			{dataIndex: 'INOUT_I'			, width: 100,summaryType: 'sum'},
			{dataIndex: 'EXPENSE_I'			, width: 100,summaryType: 'sum'},
			{dataIndex: 'INOUT_I_TOTAL'		, width: 140,summaryType: 'sum'},
			{dataIndex: 'TAX_TYPE'			, width: 90},
			{dataIndex: 'INOUT_FOR_P'		, width: 100},
			{dataIndex: 'INOUT_FOR_O'		, width: 100,summaryType: 'sum'},
			{dataIndex: 'MONEY_UNIT'		, width: 66, align: 'center'},
			{dataIndex: 'EXCHG_RATE_O'		, width: 66},
			{dataIndex: 'STOCK_UNIT'		, width: 66},
			{dataIndex: 'SUPPLY_TYPE'		, width: 100},
			{dataIndex: 'WH_CODE'			, width: 100},
			{dataIndex: 'INOUT_PRSN'		, width: 66},
			{dataIndex: 'MAKE_EXP_DATE'		, width: 100},
			{dataIndex: 'INOUT_NUM'			, width: 110},
			{dataIndex: 'INOUT_SEQ'			, width: 66	, text: '순번'},
			{dataIndex: 'INOUT_METH'		, width: 66},
			{dataIndex: 'INOUT_TYPE_DETAIL'	, width: 66},
			{dataIndex: 'SO_NUM'			, width: 100, hidden: true},
			{dataIndex: 'ORDER_DATE'		, width: 93},
			{dataIndex: 'ORDER_NUM'			, width: 133},
			{dataIndex: 'ORDER_SEQ'			, width: 66},
			{dataIndex: 'DVRY_DATE'			, width: 93},
			{dataIndex: 'BUY_Q'				, width: 93,summaryType: 'sum'},
			{dataIndex: 'REMARK'			, width: 133},
			{dataIndex: 'REMARK2'			, width: 133},
			{dataIndex: 'PROJECT_NO'		, width: 133},
			{dataIndex: 'LOT_NO'			, width: 113},
			{dataIndex: 'ITEM_LEVEL1'		, width: 120, locked: false},
			{dataIndex: 'ITEM_LEVEL2'		, width: 120, locked: false},
			{dataIndex: 'ITEM_LEVEL3'		, width: 120, locked: false},
			{dataIndex: 'LC_NUM'			, width: 113},
			{dataIndex: 'BL_NUM'			, width: 113},
			{dataIndex: 'ORDER_TYPE'		, width: 100},
			{dataIndex: 'CREATE_LOC'		, width: 66, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 6, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 120}
		],
		listeners: {
			selectionchange:function( grid, selection, eOpts )	{
				if(selection && selection.startCell)	{
					var columnName = selection.startCell.column.dataIndex;
					if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex)	{
						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
						var sum = 0;

						for(var i=startIdx; i <= endIdx; i++){
							var record = store.getAt(i);
							sum += record.get(columnName);
						}
						this.down('#selectionSummaryItem').setValue(sum);
					} else {
						this.down('#selectionSummaryItem').setValue(0);
					}
				}
			}
		 }
	});//End of var itemGrid = Unilite.createGrid('mtr110skrvGrid1', {

	var customGrid = Unilite.createGrid('mtr110skrvGrid2', {
		store: directMasterStore2,
		title: '<t:message code="system.label.purchase.customby" default="거래처별"/>',
		layout: 'fit',
		region:'center',
		tbar:[{
			xtype		: 'uniNumberfield',
			fieldLabel	: '<t:message code="system.label.purchase.selectionsummary" default="선택된 데이터 합계"/>',
			itemId		: 'selectionSummaryCustom',
			readOnly	: true,
			value		: 0,
			format		: '0,000.0000',
			labelWidth	: 110,
			decimalPrecision:4
		}],
		uniOpt: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			onLoadSelectFirst	: false,	//20200520 추가: false
			//20191205 필터기능 추가
			filter				: {
				useFilter	: true,
				autoCreate	: true
			},
			excel: {
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: true,		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		//20200520 추가: 출력여부에 따라 그리드 selModel 설정, 20200521 사용 안 함 -> 신규프로그램으로 대체
/*		selModel	: buttonHidden ? 'rowmodel' : Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false,
													listeners: {
														select: function(grid, selectRecord, index, rowIndex, eOpts ){
														},
														deselect:  function(grid, selectRecord, index, eOpts ){
														}
													}
												}),*/
		columns		: [{
				//20200520 추가
				xtype	: 'rownumberer',
				sortable: false,
				width	: 35,
				align	: 'center  !important',
				resizable: true
			},
			{dataIndex: 'INDEX01'			, width: 120, locked: false, hidden:true},
			{dataIndex: 'INDEX02'			, width: 250, locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				   return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.subtotal" default="소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
			}},
			{dataIndex: 'RECEIPT_DATE'		, width: 88, locked: false },
			{dataIndex: 'INDEX03'			, width: 88, locked: false},
			{dataIndex: 'INDEX04'			, width: 150, locked: false},
			{dataIndex: 'INDEX05'			, width: 150, locked: false},
			{dataIndex: 'BARCODE'			, width: 88, locked: false},
			{dataIndex: 'INDEX06'			, width: 166},
			//20190111 입고량(ORDER_UNIT_Q), 발주단위(ORDER_UNIT) 추가
			{dataIndex: 'ORDER_UNIT_Q'		, width: 95	, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT'		, width: 66},
			{dataIndex: 'SQM'				, width: 95,summaryType: 'sum', hidden: true},
			{dataIndex: 'ORDER_UNIT_FOR_P'	, width: 100,summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_FOR_O'	, width: 100,summaryType: 'sum'},
			{dataIndex: 'INOUT_Q'			, width: 95,summaryType: 'sum'},
			{dataIndex: 'INOUT_P'			, width: 100},
			{dataIndex: 'INOUT_I'			, width: 100,summaryType: 'sum'},
			{dataIndex: 'EXPENSE_I'			, width: 100,summaryType: 'sum'},
			{dataIndex: 'INOUT_I_TOTAL'		, width: 140,summaryType: 'sum'},
			{dataIndex: 'TAX_TYPE'			, width: 90},
			{dataIndex: 'INOUT_FOR_P'		, width: 100},
			{dataIndex: 'INOUT_FOR_O'		, width: 100,summaryType: 'sum'},
			{dataIndex: 'MONEY_UNIT'		, width: 66, align: 'center'},
			{dataIndex: 'EXCHG_RATE_O'		, width: 66},
			{dataIndex: 'SUPPLY_TYPE'		, width: 100},
			{dataIndex: 'WH_CODE'			, width: 100},
			{dataIndex: 'INOUT_PRSN'		, width: 66},
			{dataIndex: 'MAKE_EXP_DATE'		, width: 100},
			{dataIndex: 'INOUT_NUM'			, width: 110},
			{dataIndex: 'INOUT_SEQ'			, width: 66	, text: '순번'},
			{dataIndex: 'INOUT_METH'		, width: 66},
			{dataIndex: 'INOUT_TYPE_DETAIL'	, width: 66},
			{dataIndex: 'SO_NUM'			, width: 100, hidden: true},
			{dataIndex: 'ORDER_DATE'		, width: 93},
			{dataIndex: 'ORDER_NUM'			, width: 133},
			{dataIndex: 'ORDER_SEQ'			, width: 66},
			{dataIndex: 'DVRY_DATE'			, width: 93},
			{dataIndex: 'BUY_Q'				, width: 93,summaryType: 'sum'},
			{dataIndex: 'REMARK'			, width: 133},
			{dataIndex: 'REMARK2'			, width: 133},
			{dataIndex: 'PROJECT_NO'		, width: 133},
			{dataIndex: 'LOT_NO'			, width: 113},
			{dataIndex: 'ITEM_LEVEL1'		, width: 120, locked: false},
			{dataIndex: 'ITEM_LEVEL2'		, width: 120, locked: false},
			{dataIndex: 'ITEM_LEVEL3'		, width: 120, locked: false},
			{dataIndex: 'LC_NUM'			, width: 113},
			{dataIndex: 'BL_NUM'			, width: 113},
			{dataIndex: 'ORDER_TYPE'		, width: 100},
			{dataIndex: 'CREATE_LOC'		, width: 66, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 6, hidden: true},
			{dataIndex: 'STOCK_UNIT'		, width: 66},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 120}
		],
		listeners: {
			 selectionchange:function( grid, selection, eOpts )	{
				if(selection && selection.startCell)	{
					var columnName = selection.startCell.column.dataIndex;
					if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex)	{
						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
						var sum = 0;

						for(var i=startIdx; i <= endIdx; i++){
							var record = store.getAt(i);
							sum += record.get(columnName);
						}
						this.down('#selectionSummaryCustom').setValue(sum);
					} else {
						this.down('#selectionSummaryCustom').setValue(0);
					}
				}
			}
		 }
	});

	var masterGrid = Unilite.createGrid('mtr110skrvGrid3', {
		store: directMasterStore3,
		title: '<t:message code="system.label.purchase.customparenbyeachitem" default="거래처품목별"/>',
		layout: 'fit',
		region:'center',
		tbar:[{
			xtype		: 'uniNumberfield',
			fieldLabel	: '<t:message code="system.label.purchase.selectionsummary" default="선택된 데이터 합계"/>',
			itemId		: 'selectionSummaryCustomItem',
			readOnly	: true,
			value		: 0,
			format		: '0,000.0000',
			labelWidth	: 110,
			decimalPrecision:4
		}],
		uniOpt: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			onLoadSelectFirst	: false,	//20200520 추가: false
			//20191205 필터기능 추가
			filter				: {
				useFilter	: true,
				autoCreate	: true
			},
			excel: {
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: true,		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		//20200520 추가: 출력여부에 따라 그리드 selModel 설정, 20200521 사용 안 함 -> 신규프로그램으로 대체
/*		selModel	: buttonHidden ? 'rowmodel' : Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false,
													listeners: {
														select: function(grid, selectRecord, index, rowIndex, eOpts ){
														},
														deselect:  function(grid, selectRecord, index, eOpts ){
														}
													}
												}),*/
		columns		: [{
				//20200520 추가
				xtype	: 'rownumberer',
				sortable: false,
				width	: 35,
				align	: 'center  !important',
				resizable: true
			},
			{dataIndex: 'INDEX01'			, width: 120, locked: false, hidden:true},
			{dataIndex: 'INDEX02'			, width: 250, locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				   return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.subtotal" default="소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
			}},
			{dataIndex: 'INDEX03'			, width: 120, locked: false},
			{dataIndex: 'INDEX04'			, width: 150, locked: false},
			{dataIndex: 'BARCODE'			, width: 88, locked: false},
			{dataIndex: 'INDEX05'			, width: 150, locked: false},
			{dataIndex: 'INDEX06'			, width: 166},
			{dataIndex: 'ITEM_LEVEL1'		, width: 120},
			{dataIndex: 'ITEM_LEVEL2'		, width: 120},
			{dataIndex: 'ITEM_LEVEL3'		, width: 120},
			//20190111 입고량(ORDER_UNIT_Q), 발주단위(ORDER_UNIT) 추가
			{dataIndex: 'ORDER_UNIT_Q'		, width: 95	, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT'		, width: 66},
			{dataIndex: 'SQM'				, width: 95,summaryType: 'sum', hidden: true},
			{dataIndex: 'ORDER_UNIT_FOR_P'	, width: 100,summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_FOR_O'	, width: 100,summaryType: 'sum'},
			{dataIndex: 'INOUT_Q'			, width: 95,summaryType: 'sum'},
			{dataIndex: 'INOUT_P'			, width: 100},
			{dataIndex: 'INOUT_I'			, width: 100,summaryType: 'sum'},
			{dataIndex: 'EXPENSE_I'			, width: 100,summaryType: 'sum'},
			{dataIndex: 'INOUT_I_TOTAL'		, width: 140,summaryType: 'sum'},
			{dataIndex: 'TAX_TYPE'			, width: 90},
			{dataIndex: 'INOUT_FOR_P'		, width: 100},
			{dataIndex: 'INOUT_FOR_O'		, width: 100,summaryType: 'sum'},
			{dataIndex: 'MONEY_UNIT'		, width: 66, align: 'center'},
			{dataIndex: 'EXCHG_RATE_O'		, width: 66},
			{dataIndex: 'STOCK_UNIT'		, width: 66},
			{dataIndex: 'SUPPLY_TYPE'		, width: 100},
			{dataIndex: 'WH_CODE'			, width: 100},
			{dataIndex: 'INOUT_PRSN'		, width: 66},
			{dataIndex: 'MAKE_EXP_DATE'		, width: 100},
			{dataIndex: 'INOUT_NUM'			, width: 110},
			{dataIndex: 'INOUT_SEQ'			, width: 66	, text: '순번'},
			{dataIndex: 'INOUT_METH'		, width: 66},
			{dataIndex: 'INOUT_TYPE_DETAIL'	, width: 66},
			{dataIndex: 'SO_NUM'			, width: 100, hidden: true},
			{dataIndex: 'ORDER_DATE'		, width: 93},
			{dataIndex: 'ORDER_NUM'			, width: 133},
			{dataIndex: 'ORDER_SEQ'			, width: 66},
			{dataIndex: 'DVRY_DATE'			, width: 93},
			{dataIndex: 'BUY_Q'				, width: 93,summaryType: 'sum'},
			{dataIndex: 'REMARK'			, width: 133},
			{dataIndex: 'REMARK2'			, width: 133},
			{dataIndex: 'PROJECT_NO'		, width: 133},
			{dataIndex: 'LOT_NO'			, width: 113},
			{dataIndex: 'LC_NUM'			, width: 113},
			{dataIndex: 'BL_NUM'			, width: 113},
			{dataIndex: 'ORDER_TYPE'		, width: 100},
			{dataIndex: 'CREATE_LOC'		, width: 66, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 6, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 120}
		],
		listeners: {
			selectionchange:function( grid, selection, eOpts )	{
				if(selection && selection.startCell)	{
					var columnName = selection.startCell.column.dataIndex;
					if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex) {
						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
						var sum = 0;

						for(var i=startIdx; i <= endIdx; i++){
							var record = store.getAt(i);
							sum += record.get(columnName);
						}
						this.down('#selectionSummaryCustomItem').setValue(sum);
					} else {
						this.down('#selectionSummaryCustomItem').setValue(0);
					}
				}
			}
		}
	});



	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab: 0,
		region: 'center',
		items: [
			itemGrid,customGrid,masterGrid
		],
		listeners:  {
			tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
				var newTabId = newCard.getId();
				console.log("newCard:  " + newCard.getId());
				console.log("oldCard:  " + oldCard.getId());
				//탭 넘길때마다 초기화
				UniAppManager.setToolbarButtons(['save', 'newData' ], false);
				panelResult.setAllFieldsReadOnly(false);
//				Ext.getCmp('confirm_check').hide(); //확정버튼 hidden
				UniAppManager.app.onQueryButtonDown();
			}
		}
	});



	Unilite.Main({
		id: 'mtr110skrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function(params) {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);

			panelSearch.setValue('CHECK_SUM', true);
			panelResult.setValue('CHECK_SUM', true);

			panelSearch.setValue('INOUT_FR_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('INOUT_TO_DATE', UniDate.get('today'));
			panelResult.setValue('INOUT_FR_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('INOUT_TO_DATE', UniDate.get('today'));
//			panelSearch.setValue('CREATE_LOC', '1');
//			panelSearch.setValue('INOUT_TYPE_DETAIL', '10');

//			panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
//			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			panelSearch.setValue('INOUT_PRSN',BsaCodeInfo.gsInOutPrsn);
			panelResult.setValue('INOUT_PRSN',BsaCodeInfo.gsInOutPrsn);
			mtr110skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
					UniAppManager.app.processParams(params);
					if(params && params.INOUT_DATE){
						itemGrid.getStore().loadStoreRecords();
					}
				}
			});

			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 'mtr110skrvGrid1'){
					itemGrid.reset();
					itemGrid.getStore().loadStoreRecords();
				}
				else if(activeTabId == 'mtr110skrvGrid2'){
					customGrid.reset();
					customGrid.getStore().loadStoreRecords();
				}
				else if(activeTabId == 'mtr110skrvGrid3'){
					masterGrid.reset();
					masterGrid.getStore().loadStoreRecords();
				}
				UniAppManager.setToolbarButtons(['excel','reset'],true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			itemGrid.reset();
			customGrid.reset();
			masterGrid.reset();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			this.fnInitBinding();
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true),
					panelResult.setAllFieldsReadOnly(true);
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params && params.INOUT_DATE) {
				if(params.action == 'new') {
		//				alert('assd')
					panelSearch.setValue('INOUT_FR_DATE', params.INOUT_DATE);
					panelSearch.setValue('INOUT_TO_DATE', params.INOUT_DATE);
					panelResult.setValue('INOUT_FR_DATE', params.INOUT_DATE);
					panelResult.setValue('INOUT_TO_DATE', params.INOUT_DATE);

					panelSearch.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
					panelSearch.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
					panelResult.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
					panelResult.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
					panelSearch.setValue('DIV_CODE', params.DIV_CODE);
					panelResult.setValue('DIV_CODE', params.DIV_CODE);
//					panelSearch.setValue('DEPT_CODE', params.DEPT_CODE);
//					panelResult.setValue('DEPT_CODE', params.DEPT_CODE);
//					panelSearch.setValue('DEPT_NAME', params.DEPT_NAME);
//					panelResult.setValue('DEPT_NAME', params.DEPT_NAME);
					panelSearch.setValue('WH_CODE', params.WH_CODE);
					panelResult.setValue('WH_CODE', params.WH_CODE);
					panelSearch.setValue('INOUT_PRSN','');
					panelResult.setValue('INOUT_PRSN','');
				}
			}
		}
/*		onSaveAsExcelButtonDown: function() {
			 itemGrid.downloadExcelXml();
		}*/
	});//End of Unilite.Main( {
};
</script>