<%--
'프로그램명 : 출하지시등록 (영업)
'작  성  자 : (주)포렌 개발실
'작  성  일 :
'최종수정자 :
'최종수정일 :
'버	  전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="srq100skrv"  >
	<t:ExtComboStore comboType="AU" comboCode="S010" />						<!--영업담당 -->
	<t:ExtComboStore comboType="BOR120" pgmId="srq100skrv" /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" />						<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" />						<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" />						<!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts='1;5' />			<!--생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="S007" />						<!--출고유형-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!-- 창고Cell-->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {

	/** Model 정의	COMP_CODE, DIV_CODE, ISSUE_REQ_NUM, ISSUE_REQ_SEQ
	 */
	Unilite.defineModel('Srq100skrvModel1', {
		fields: [
			{name: 'ITEM_CODE'				,text: '<t:message code="system.label.sales.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'ITEM_NAME1'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>1'				,type: 'string'},
			{name: 'SPEC'					,text: '<t:message code="system.label.sales.spec" default="규격"/>'					,type: 'string'},
			{name: 'ORDER_UNIT'				,text: '<t:message code="system.label.sales.unit" default="단위"/>'					,type: 'string'},
			{name: 'TRANS_RATE'				,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			,type: 'uniQty'},
			{name: 'ISSUE_REQ_QTY'			,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'	,type: 'uniQty'},
//			{name: 'ISSUE_REQ_PRICE'		,text: '<t:message code="system.label.sales.price" default="단가"/>'					,type: 'uniUnitPrice'},
			{name: 'ISSUE_REQ_PRICE'		,text: '<t:message code="system.label.sales.exchangeprice" default="환산단가"/>'		,type: 'uniUnitPrice'},
//			{name: 'ISSUE_REQ_AMT'			,text: '<t:message code="system.label.sales.shipmentorderamount" default="출하지시액"/>'	,type: 'uniPrice'},
			{name: 'ISSUE_REQ_AMT'			,text: '<t:message code="system.label.sales.exchangeshipmentorderamount" default="출하지시액(환산)"/>'	,type: 'uniPrice'},
			{name: 'ISSUE_QTY'				,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>'				,type: 'uniQty'},
//			{name: 'ISSUE_AMT'				,text: '<t:message code="system.label.sales.issueamount" default="출고액"/>'			,type: 'uniPrice'},
			{name: 'ISSUE_AMT'				,text: '<t:message code="system.label.sales.exchangeissueamount" default="출고액(환산)"/>'			,type: 'uniPrice'},
			{name: 'ISSUE_REQ_DATE'			,text: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'	,type: 'uniDate'},
			{name: 'LOT_NO'					,text: '<t:message code="system.label.sales.lotno" default="LOT_NO"/>'				,type: 'string'},
			{name: 'ISSUE_DATE'				,text: '<t:message code="system.label.sales.issueresevationdate" default="출고예정일"/>'	,type: 'uniDate'},
			{name: 'DELIVERY_TIME'			,text: '<t:message code="system.label.sales.deliverytime" default="납기시간"/>'			,type: 'uniDate'},
			{name: 'WH_CODE'				,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'				,type: 'string'},
			{name: 'WH_CODE_NM'				,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'				,type: 'string'},
			{name: 'ORDER_TYPE'				,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'			,type: 'string', comboType: 'AU', comboCode: 'S002'},
			{name: 'ORDER_TYPE_NM'			,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'			,type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'			,type: 'string', comboType: 'AU', comboCode: 'S007'},
			{name: 'INOUT_TYPE_DETAIL_NM'	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'			,type: 'string'},
			{name: 'DVRY_DATE'				,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'			,type: 'uniDate'},
			{name: 'DVRY_TIME'				,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'			,type: 'uniDate'},
			{name: 'DVRY_CUST_NM'			,text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			,type: 'string'},
			{name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.sales.custom" default="거래처"/>'				,type: 'string'},
			{name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.sales.custom" default="거래처"/>'				,type: 'string'},
			{name: 'SALE_CUSTOM_CODE'		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			,type: 'string'},
			{name: 'SALE_CUSTOM_NAME'		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			,type: 'string'},
			{name: 'ISSUE_DIV_CODE'			,text: '<t:message code="system.label.sales.division" default="사업장"/>'				,type: 'string'},
			{name: 'ISSUE_DIV_CODE_NM'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'				,type: 'string'},
			{name: 'ISSUE_REQ_PRSN'			,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			,type: 'string',comboType:"AU" ,comboCode:"S010"},
			{name: 'ISSUE_REQ_PRSN_NM'		,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			,type: 'string'},
			{name: 'ISSUE_REQ_NUM'			,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'	,type: 'string'},
			{name: 'ISSUE_REQ_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'					,type: 'integer'},
			{name: 'ORDER_NUM'				,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'					,type: 'string'},
			{name: 'SER_NO'					,text: '<t:message code="system.label.sales.seq" default="순번"/>'					,type: 'integer'},
			{name: 'PROJECT_NO'				,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			,type: 'string'},
			{name: 'PO_NUM'					,text: '<t:message code="system.label.sales.pono" default="PO번호"/>'					,type: 'string'},
			{name: 'BOOKING_NUM'			,text: '<t:message code="system.label.sales.bookingnum" default="부킹번호"/>'					,type: 'string'},
			{name: 'AGENT_TYPE'				,text: '<t:message code="system.label.sales.customclass2" default="거래처구분"/>'		,type: 'string'},
			{name: 'AREA_TYPE'				,text: '<t:message code="system.label.sales.area" default="지역"/>'					,type: 'string'},
			{name: 'ITEM_LEVEL1'			,text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'			,type: 'string'},
			{name: 'ITEM_LEVEL2'			,text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'			,type: 'string'},
			{name: 'ITEM_LEVEL3'			,text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'			,type: 'string'},
			{name: 'ITEM_GROUP'				,text: '<t:message code="system.label.sales.group" default="그룹"/>'					,type: 'string'},
			{name: 'ITEM_GROUP_NM'			,text: '<t:message code="system.label.sales.groupname" default="그룹명"/>'				,type: 'string'},
			{name: 'SORT'					,text: 'SORT'			,type: 'string'},
			//20181011 추가
			{name: 'MONEY_UNIT'				,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'			,type: 'string'},
			{name: 'ORIGINAL_PRICE'			,text: '<t:message code="system.label.sales.price" default="단가"/>'					,type: 'uniUnitPrice'},
			{name: 'ORIGINAL_REQ_AMT'		,text: '<t:message code="system.label.sales.shipmentorderamount" default="출하지시액"/>'	,type: 'uniFC'},
			{name: 'ORIGINAL_AMT'			,text: '<t:message code="system.label.sales.issueamount" default="출고액"/>'			,type: 'uniFC'},
			//20200116 추가
			{name: 'ITEM_INFO'				,text: '<t:message code="system.label.sales.item" default="품목"/>'					,type: 'string'},
			{name: 'STOCK_Q'				,text: '<t:message code="system.label.sales.onhandqty" default="현재고량"/>'			,type: 'uniQty'},
			//20200508 추가: 비고(출하)
			{name: 'OUT_REMARK'				,text: '비고(출하)'			,type: 'string'},
			//20200604 추가: 포장형태, 비고, 내부기록, 포장지시수량, 포장출고수량, 창고cell
			{name: 'PACK_TYPE'				,text: '포장형태'			,type: 'string', comboType: 'AU', comboCode: 'B138'},
			{name: 'REMARK'					,text: '비고'				,type: 'string'},
			{name: 'REMARK_INTER'			,text: '내부기록'			,type: 'string'},
			{name: 'ORDER_PACK_Q'			,text: '포장지시수량'			,type: 'uniQty'},
			{name: 'OUT_PACK_Q'				,text: '포장출고수량'			,type: 'uniQty'},
			{name: 'WH_CELL_CODE'			,text:'<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>'	, type: 'string', store: Ext.data.StoreManager.lookup('whCellList')}
		]
	});

	Unilite.defineModel('Srq100skrvModel2', {
		fields: [
			{name: 'ITEM_CODE'				,text: '<t:message code="system.label.sales.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'ITEM_NAME1'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>1'				,type: 'string'},
			{name: 'SPEC'					,text: '<t:message code="system.label.sales.spec" default="규격"/>'					,type: 'string'},
			{name: 'ORDER_UNIT'				,text: '<t:message code="system.label.sales.unit" default="단위"/>'					,type: 'string'},
			{name: 'TRANS_RATE'				,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			,type: 'uniQty'},
			{name: 'ISSUE_REQ_QTY'			,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'	,type: 'uniQty'},
//			{name: 'ISSUE_REQ_PRICE'		,text: '<t:message code="system.label.sales.price" default="단가"/>'					,type: 'uniUnitPrice'},
			{name: 'ISSUE_REQ_PRICE'		,text: '<t:message code="system.label.sales.exchangeprice" default="환산단가"/>'		,type: 'uniUnitPrice'},
//			{name: 'ISSUE_REQ_AMT'			,text: '<t:message code="system.label.sales.shipmentorderamount" default="출하지시액"/>'	,type: 'uniPrice'},
			{name: 'ISSUE_REQ_AMT'			,text: '<t:message code="system.label.sales.exchangeshipmentorderamount" default="출하지시액(환산)"/>'	,type: 'uniPrice'},
			{name: 'ISSUE_QTY'				,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>'				,type: 'uniQty'},
//			{name: 'ISSUE_AMT'				,text: '<t:message code="system.label.sales.issueamount" default="출고액"/>'			,type: 'uniPrice'},
			{name: 'ISSUE_AMT'				,text: '<t:message code="system.label.sales.exchangeissueamount" default="출고액(환산)"/>'			,type: 'uniPrice'},
			{name: 'ISSUE_REQ_DATE'			,text: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'	,type: 'uniDate'},
			{name: 'LOT_NO'					,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'				,type: 'string'},
			{name: 'ISSUE_DATE'				,text: '<t:message code="system.label.sales.issueresevationdate" default="출고예정일"/>'	,type: 'uniDate'},
			{name: 'DELIVERY_TIME'			,text: '<t:message code="system.label.sales.deliverytime" default="납기시간"/>'			,type: 'uniDate'},
			{name: 'WH_CODE'				,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'				,type: 'string'},
			{name: 'WH_CODE_NM'				,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'				,type: 'string'},
			{name: 'ORDER_TYPE'				,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'			,type: 'string', comboType: 'AU', comboCode: 'S002'},
			{name: 'ORDER_TYPE_NM'			,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'			,type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'			,type: 'string', comboType: 'AU', comboCode: 'S007'},
			{name: 'INOUT_TYPE_DETAIL_NM'	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'			,type: 'string'},
			{name: 'DVRY_DATE'				,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'			,type: 'uniDate'},
			{name: 'DVRY_TIME'				,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'			,type: 'uniDate'},
			{name: 'DVRY_CUST_NM'			,text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			,type: 'string'},
			{name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.sales.custom" default="거래처"/>'				,type: 'string'},
			{name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.sales.custom" default="거래처"/>'				,type: 'string'},
			{name: 'SALE_CUSTOM_CODE'		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			,type: 'string'},
			{name: 'SALE_CUSTOM_NAME'		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			,type: 'string'},
			{name: 'ISSUE_DIV_CODE'			,text: '<t:message code="system.label.sales.division" default="사업장"/>'				,type: 'string'},
			{name: 'ISSUE_DIV_CODE_NM'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'				,type: 'string'},
			{name: 'ISSUE_REQ_PRSN'			,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			,type: 'string',comboType:"AU" ,comboCode:"S010"},
			{name: 'ISSUE_REQ_PRSN_NM'		,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			,type: 'string'},
			{name: 'ISSUE_REQ_NUM'			,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'	,type: 'string'},
			{name: 'ISSUE_REQ_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'					,type: 'integer'},
			{name: 'ORDER_NUM'				,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'					,type: 'string'},
			{name: 'SER_NO'					,text: '<t:message code="system.label.sales.seq" default="순번"/>'					,type: 'integer'},
			{name: 'PROJECT_NO'				,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			,type: 'string'},
			{name: 'PO_NUM'					,text: '<t:message code="system.label.sales.pono" default="PO번호"/>'					,type: 'string'},
			{name: 'BOOKING_NUM'			,text: '<t:message code="system.label.sales.bookingnum" default="부킹번호"/>'					,type: 'string'},
			{name: 'AGENT_TYPE'				,text: '<t:message code="system.label.sales.customclass2" default="거래처구분"/>'		,type: 'string'},
			{name: 'AREA_TYPE'				,text: '<t:message code="system.label.sales.area" default="지역"/>'					,type: 'string'},
			{name: 'ITEM_LEVEL1'			,text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'			,type: 'string'},
			{name: 'ITEM_LEVEL2'			,text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'			,type: 'string'},
			{name: 'ITEM_LEVEL3'			,text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'			,type: 'string'},
			{name: 'ITEM_GROUP'				,text: '<t:message code="system.label.sales.group" default="그룹"/>'					,type: 'string'},
			{name: 'ITEM_GROUP_NM'			,text: '<t:message code="system.label.sales.groupname" default="그룹명"/>'				,type: 'string'},
			{name: 'SORT'					,text: 'SORT'			,type: 'string'},
			//20181011 추가
			{name: 'MONEY_UNIT'				,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'			,type: 'string'},
			{name: 'ORIGINAL_PRICE'			,text: '<t:message code="system.label.sales.price" default="단가"/>'					,type: 'uniUnitPrice'},
			{name: 'ORIGINAL_REQ_AMT'		,text: '<t:message code="system.label.sales.shipmentorderamount" default="출하지시액"/>'	,type: 'uniFC'},
			{name: 'ORIGINAL_AMT'			,text: '<t:message code="system.label.sales.issueamount" default="출고액"/>'			,type: 'uniFC'},
			//20200116 추가
			{name: 'STOCK_Q'				,text: '<t:message code="system.label.sales.onhandqty" default="현재고량"/>'			,type: 'uniQty'},
			//20200508 추가: 비고(출하)
			{name: 'OUT_REMARK'				,text: '비고(출하)'			,type: 'string'},
			//20200604 추가: 포장형태, 비고, 내부기록, 포장지시수량, 포장출고수량, 창고cell
			{name: 'PACK_TYPE'				,text: '포장형태'			,type: 'string', comboType: 'AU', comboCode: 'B138'},
			{name: 'REMARK'					,text: '비고'				,type: 'string'},
			{name: 'REMARK_INTER'			,text: '내부기록'			,type: 'string'},
			{name: 'ORDER_PACK_Q'			,text: '포장지시수량'			,type: 'uniQty'},
			{name: 'OUT_PACK_Q'				,text: '포장출고수량'			,type: 'uniQty'},
			{name: 'WH_CELL_CODE'			,text:'<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>'	, type: 'string', store: Ext.data.StoreManager.lookup('whCellList')}
		]
	});

	Unilite.defineModel('Srq100skrvModel3', {
		fields: [
			{name: 'ITEM_CODE'				,text: '<t:message code="system.label.sales.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'ITEM_NAME1'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>1'				,type: 'string'},
			{name: 'SPEC'					,text: '<t:message code="system.label.sales.spec" default="규격"/>'					,type: 'string'},
			{name: 'ORDER_UNIT'				,text: '<t:message code="system.label.sales.unit" default="단위"/>'					,type: 'string'},
			{name: 'TRANS_RATE'				,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			,type: 'uniQty'},
			{name: 'ISSUE_REQ_QTY'			,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'	,type: 'uniQty'},
//			{name: 'ISSUE_REQ_PRICE'		,text: '<t:message code="system.label.sales.price" default="단가"/>'					,type: 'uniUnitPrice'},
			{name: 'ISSUE_REQ_PRICE'		,text: '<t:message code="system.label.sales.exchangeprice" default="환산단가"/>'		,type: 'uniUnitPrice'},
//			{name: 'ISSUE_REQ_AMT'			,text: '<t:message code="system.label.sales.shipmentorderamount" default="출하지시액"/>'	,type: 'uniPrice'},
			{name: 'ISSUE_REQ_AMT'			,text: '<t:message code="system.label.sales.exchangeshipmentorderamount" default="출하지시액(환산)"/>'	,type: 'uniPrice'},
			{name: 'ISSUE_QTY'				,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>'				,type: 'uniQty'},
//			{name: 'ISSUE_AMT'				,text: '<t:message code="system.label.sales.issueamount" default="출고액"/>'			,type: 'uniPrice'},
			{name: 'ISSUE_AMT'				,text: '<t:message code="system.label.sales.exchangeissueamount" default="출고액(환산)"/>'			,type: 'uniPrice'},
			{name: 'ISSUE_REQ_DATE'			,text: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'	,type: 'uniDate'},
			{name: 'LOT_NO'					,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'				,type: 'string'},
			{name: 'ISSUE_DATE'				,text: '<t:message code="system.label.sales.issueresevationdate" default="출고예정일"/>'	,type: 'uniDate'},
			{name: 'DELIVERY_TIME'			,text: '<t:message code="system.label.sales.issueresevationdate" default="출고예정일"/>'	,type: 'uniDate'},
			{name: 'WH_CODE'				,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'				,type: 'string'},
			{name: 'WH_CODE_NM'				,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'				,type: 'string'},
			{name: 'ORDER_TYPE'				,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'			,type: 'string', comboType: 'AU', comboCode: 'S002'},
			{name: 'ORDER_TYPE_NM'			,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'			,type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'			,type: 'string', comboType: 'AU', comboCode: 'S007'},
			{name: 'INOUT_TYPE_DETAIL_NM'	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'			,type: 'string'},
			{name: 'DVRY_DATE'				,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'			,type: 'uniDate'},
			{name: 'DVRY_TIME'				,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'			,type: 'uniDate'},
			{name: 'DVRY_CUST_NM'			,text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			,type: 'string'},
			{name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.sales.custom" default="거래처"/>'				,type: 'string'},
			{name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.sales.custom" default="거래처"/>'				,type: 'string'},
			{name: 'SALE_CUSTOM_CODE'		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			,type: 'string'},
			{name: 'SALE_CUSTOM_NAME'		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			,type: 'string'},
			{name: 'ISSUE_DIV_CODE'			,text: '<t:message code="system.label.sales.division" default="사업장"/>'				,type: 'string'},
			{name: 'ISSUE_DIV_CODE_NM'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'				,type: 'string'},
			{name: 'ISSUE_REQ_PRSN'			,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			,type: 'string',comboType:"AU" ,comboCode:"S010"},
			{name: 'ISSUE_REQ_PRSN_NM'		,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			,type: 'string'},
			{name: 'ISSUE_REQ_NUM'			,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'	,type: 'string'},
			{name: 'ISSUE_REQ_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'					,type: 'integer'},
			{name: 'ORDER_NUM'				,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'					,type: 'string'},
			{name: 'SER_NO'					,text: '<t:message code="system.label.sales.seq" default="순번"/>'					,type: 'integer'},
			{name: 'PROJECT_NO'				,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			,type: 'string'},
			{name: 'PO_NUM'					,text: '<t:message code="system.label.sales.pono" default="PO번호"/>'					,type: 'string'},
			{name: 'BOOKING_NUM'			,text: '<t:message code="system.label.sales.bookingnum" default="부킹번호"/>'					,type: 'string'},
			{name: 'AGENT_TYPE'				,text: '<t:message code="system.label.sales.customclass2" default="거래처구분"/>'		,type: 'string'},
			{name: 'AREA_TYPE'				,text: '<t:message code="system.label.sales.area" default="지역"/>'					,type: 'string'},
			{name: 'ITEM_LEVEL1'			,text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'			,type: 'string'},
			{name: 'ITEM_LEVEL2'			,text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'			,type: 'string'},
			{name: 'ITEM_LEVEL3'			,text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'			,type: 'string'},
			{name: 'ITEM_GROUP'				,text: '<t:message code="system.label.sales.group" default="그룹"/>'					,type: 'string'},
			{name: 'ITEM_GROUP_NM'			,text: '<t:message code="system.label.sales.groupname" default="그룹명"/>'				,type: 'string'},
			{name: 'SORT'					,text: 'SORT'			,type: 'string'},
			//20181011 추가
			{name: 'MONEY_UNIT'				,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'			,type: 'string'},
			{name: 'ORIGINAL_PRICE'			,text: '<t:message code="system.label.sales.price" default="단가"/>'					,type: 'uniUnitPrice'},
			{name: 'ORIGINAL_REQ_AMT'		,text: '<t:message code="system.label.sales.shipmentorderamount" default="출하지시액"/>'	,type: 'uniFC'},
			{name: 'ORIGINAL_AMT'			,text: '<t:message code="system.label.sales.issueamount" default="출고액"/>'			,type: 'uniFC'},
			//20200116 추가
			{name: 'STOCK_Q'				,text: '<t:message code="system.label.sales.onhandqty" default="현재고량"/>'			,type: 'uniQty'},
			//20200508 추가: 비고(출하)
			{name: 'OUT_REMARK'				,text: '비고(출하)'			,type: 'string'},
			//20200604 추가: 포장형태, 비고, 내부기록, 포장지시수량, 포장출고수량, 창고cell
			{name: 'PACK_TYPE'				,text: '포장형태'			,type: 'string', comboType: 'AU', comboCode: 'B138'},
			{name: 'REMARK'					,text: '비고'				,type: 'string'},
			{name: 'REMARK_INTER'			,text: '내부기록'			,type: 'string'},
			{name: 'ORDER_PACK_Q'			,text: '포장지시수량'			,type: 'uniQty'},
			{name: 'OUT_PACK_Q'				,text: '포장출고수량'			,type: 'uniQty'},
			{name: 'WH_CELL_CODE'			,text:'<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>'	, type: 'string', store: Ext.data.StoreManager.lookup('whCellList')}
		]
	});



	/** Store 정의(Service 정의)
	 */
	var directMasterStore1 = Unilite.createStore('srq100skrvMasterStore1',{
		model: 'Srq100skrvModel1',
		uniOpt: {
			isMaster: true,		// 상위 버튼 연결
			editable: false,	// 수정 모드 사용
			deletable: false,	// 삭제 가능 여부
			useNavi: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'srq100skrvService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param["QRY_TYPE"] = "ITEM";
			console.log( param );
			this.load({
				params: param
			});
		},
		//20200116 수정: 동일한 품목명인데 다른 품목코드인 데이터 존재
//		groupField: 'ITEM_NAME',
		groupField: 'ITEM_INFO',
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				if(records && records.length > 0){
					masterGrid1.setShowSummaryRow(true);
				}
			}
		}
	});

	var directMasterStore2 = Unilite.createStore('srq100skrvMasterStore2',{
		model: 'Srq100skrvModel2',
		uniOpt: {
			isMaster: true,		// 상위 버튼 연결
			editable: false,	// 수정 모드 사용
			deletable: false,	// 삭제 가능 여부
			useNavi: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'srq100skrvService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param["QRY_TYPE"] = "CUSTOM";
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'SALE_CUSTOM_NAME',
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				if(records && records.length > 0){
					masterGrid2.setShowSummaryRow(true);
				}
			}
		}
	});

	var directMasterStore3 = Unilite.createStore('srq100skrvMasterStore3',{
		model: 'Srq100skrvModel3',
		uniOpt: {
			isMaster: true,		// 상위 버튼 연결
			editable: false,	// 수정 모드 사용
			deletable: false,	// 삭제 가능 여부
			useNavi: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'srq100skrvService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param["QRY_TYPE"] = "WHOUSE";
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'WH_CODE_NM',
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				if(records && records.length > 0){
					masterGrid3.setShowSummaryRow(true);
				}
			}
		}
	});



	/** 검색조건 (Search Panel)
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
			items: [{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 1},
				items: [{
					fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					value:UserInfo.divCode,
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'ISSUE_REQ_DATE_FR',
					endFieldName: 'ISSUE_REQ_DATE_TO',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('ISSUE_REQ_DATE_FR2',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();

						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('ISSUE_REQ_DATE_TO2',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'	,
					name: 'ORDER_TYPE',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'S002',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ORDER_TYPE', newValue);
						}
					}
				},
				Unilite.popup('AGENT_CUST',{
					fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					validateBlank	: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_CODE', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_NAME', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_CODE', '');
							}
						}
					}
				}),
				Unilite.popup('DIV_PUMOK',{
					fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>' ,
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					validateBlank	: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('ITEM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('ITEM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),{
					fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>'	,
					name: 'REF_LOC',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B031',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('REF_LOC', newValue);
						}
					}
				},{
					fieldLabel: 'LOT_NO',
					name: 'LOT_NO',
					xtype: 'uniTextfield',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('LOT_NO', newValue);
						}
					}
				}]
			}]
		},{
			title:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
				name: 'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'S010'
			},{
				fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'ITEM_LEVEL2'
			},{
				fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'ITEM_LEVEL3'
			},{
				fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store')
			},{
				fieldLabel: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>',
				name: 'ISSUE_REQ_QTY_FR',
				suffixTpl: '&nbsp;이상'
			},{
				fieldLabel: '~',
				name: 'ISSUE_REQ_QTY_TO',
				suffixTpl: '&nbsp;이하'
			},{
				fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B055'
			},{
				fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
				name: 'AREA_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B056'
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.sales.issuecomplateyn" default="출고완료여부"/>',
				id: 'rdoSelect4',
				items: [{
					boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
					name: 'rdoSelect4',
					inputValue: 'A',
					width: 60,
					checked: true
				},{
					boxLabel: '<t:message code="system.label.sales.completion" default="완료"/>',
					name: 'rdoSelect4',
					inputValue: 'Y',
					width: 60
				},{
					boxLabel: '<t:message code="system.label.sales.incompleted" default="미완료"/>',
					name: 'rdoSelect4' ,
					inputValue: 'N',
					width: 80
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('rdoSelect4', newValue.rdoSelect4);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'	,
				name: 'INOUT_TYPE_DETAIL',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'S007'
			},
			Unilite.popup('ITEM_GROUP',{
				fieldLabel: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
				textFieldName: 'ITEM_GROUP_NAME',
				valueFieldName: 'ITEM_GROUP_CODE',
				popupWidth: 710
		}), {
				xtype: 'hiddenfield'
			},{
		 	 	xtype: 'container',
				defaultType: 'uniTextfield',
 				layout: {type: 'uniTable', columns: 3},
 				width: 325,
 				items: [{
 					fieldLabel: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>',
 					suffixTpl: '&nbsp;~&nbsp;',
 					name: 'ISSUE_REQ_NUM_FR',
 					width: 218
 				},{
 					name: 'ISSUE_REQ_NUM_TO',
 					width: 107
 				}]
			},{
				fieldLabel		: '<t:message code="system.label.sales.issueresevationdate" default="출고예정일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'ISSUE_DATE_FR',
				endFieldName	: 'ISSUE_DATE_TO',
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ISSUE_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ISSUE_DATE_TO',newValue);
					}
				}
			},	//20200331 수정: panelResult에서 삭제 후 panelSearch에서 위치변경(추가정보로)
				Unilite.popup('PROJECT',{
					fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
					valueFieldName:'PJT_CODE',
					textFieldName:'PJT_NAME',
					DBvalueFieldName: 'PJT_CODE',
					DBtextFieldName: 'PJT_NAME',
					validateBlank: false,
	//				allowBlank:false,
					textFieldOnly: false,
					listeners: {/*
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('PJT_CODE', panelSearch.getValue('PJT_CODE'));
								panelResult.setValue('PJT_NAME', panelSearch.getValue('PJT_NAME'));
							},
							scope: this
						},
						onClear: function(type) {
							panelResult.setValue('PJT_CODE', '');
							panelResult.setValue('PJT_NAME', '');
						},
						applyextparam: function(popup) {
						},
						change: function(field, newValue, oldValue, eOpts) {
						}
					*/}
				})]
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}

					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				}
			}
			return r;
  		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			value:UserInfo.divCode,
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ISSUE_REQ_DATE_FR2',
			endFieldName: 'ISSUE_REQ_DATE_TO2',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ISSUE_REQ_DATE_FR',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ISSUE_REQ_DATE_TO',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'	,
			name: 'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'S002',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_TYPE', newValue);
				}
			}
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),
			Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>' ,
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_CODE', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_NAME', '');
						panelResult.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_NAME', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>'	,
			name: 'REF_LOC',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B031',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('REF_LOC', newValue);
				}
			}
		},{	//20200331 추가
			fieldLabel		: '<t:message code="system.label.sales.issueresevationdate" default="출고예정일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ISSUE_DATE_FR',
			endFieldName	: 'ISSUE_DATE_TO',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ISSUE_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ISSUE_DATE_TO',newValue);
				}
			}
		}/*,//20200331 주석
			Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
				valueFieldName:'PJT_CODE',
				textFieldName:'PJT_NAME',
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName: 'PJT_NAME',
				validateBlank: false,
//				allowBlank:false,
				textFieldOnly: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PJT_CODE', panelResult.getValue('PJT_CODE'));
							panelSearch.setValue('PJT_NAME', panelResult.getValue('PJT_NAME'));
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('PJT_CODE', '');
						panelSearch.setValue('PJT_NAME', '');
					},
					applyextparam: function(popup) {
					},
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
		})*/,{
			fieldLabel: 'LOT_NO',
			name: 'LOT_NO',
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('LOT_NO', newValue);
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.sales.issuecomplateyn" default="출고완료여부"/>',
			id: 'rdoSelect4-2',
			items: [{
				boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
				name: 'rdoSelect4',
				inputValue: 'A',
				width: 60,
				checked: true
			},{
				boxLabel: '<t:message code="system.label.sales.completion" default="완료"/>',
				name: 'rdoSelect4',
				inputValue: 'Y',
				width: 60
			},{
				boxLabel: '<t:message code="system.label.sales.incompleted" default="미완료"/>',
				name: 'rdoSelect4' ,
				inputValue: 'N',
				width: 80
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('rdoSelect4', newValue.rdoSelect4);
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 */
	var masterGrid1 = Unilite.createGrid('srq100skrvGrid1', {
		layout: 'fit',
		title: '<t:message code="system.label.sales.itemby" default="품목별"/>',
		store: directMasterStore1,
		tbar:[{xtype:'uniNumberfield',
				labelWidth: 110,
				fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>',
				itemId:'selectionSummary',
				readOnly: true,
				value:0,
				decimalPrecision:4,
				format:'0,000.0000'}],
		region: 'center',
		uniOpt: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useRowContext		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			excel: {
				useExcel		: true,			//엑셀 다운로드 사용 여부
				exportGroup		: true, 		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id: 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		columns:  [
			{ dataIndex: 'ITEM_CODE'					, width: 120 , locked: false ,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.itemtotal" default="품목계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex: 'ITEM_NAME'					, width: 150, locked: false },
			{ dataIndex: 'ITEM_NAME1'					, width: 150, hidden: true },
			{ dataIndex: 'SPEC'							, width: 150, locked: false },
			{ dataIndex: 'ORDER_UNIT'					, width: 64, align: 'center' },
			{ dataIndex: 'TRANS_RATE'					, width: 64, align: 'right' },
//			{ dataIndex: 'ISSUE_REQ_QTY'				, width: 100, summaryType: 'sum' },
			{ dataIndex: 'MONEY_UNIT'					, width: 65  },
			{ dataIndex: 'ORIGINAL_PRICE'				, width: 100 , hidden: true},
			{ dataIndex: 'ISSUE_REQ_PRICE'				, width: 113 , hidden: true},
			{ dataIndex: 'ISSUE_REQ_QTY'				, width: 100, summaryType: 'sum' },
			//20200116 추가: 현재고량(STOCK_Q)
			{ dataIndex: 'STOCK_Q'						, width: 100},
			{ dataIndex: 'ORIGINAL_REQ_AMT'				, width: 113, hidden: true, summaryType: 'sum' },
			{ dataIndex: 'ISSUE_REQ_AMT'				, width: 113 , hidden: true, summaryType: 'sum' },
			{ dataIndex: 'ISSUE_QTY'					, width: 100, summaryType: 'sum' },
			{ dataIndex: 'ORIGINAL_AMT'					, width: 113, hidden: true, summaryType: 'sum' },
			{ dataIndex: 'ISSUE_AMT'					, width: 113 , hidden: true, summaryType: 'sum' },
			{ dataIndex: 'ISSUE_REQ_DATE'				, width: 80 },
			{ dataIndex: 'LOT_NO'						, width: 100 },
			{ dataIndex: 'ISSUE_DATE'					, width: 80 },
			{ dataIndex: 'DELIVERY_TIME'				, width: 80, hidden: true  },
			{ dataIndex: 'WH_CODE'						, width: 40, hidden: true  },
			{ dataIndex: 'WH_CODE_NM'					, width: 100 },
			{ dataIndex: 'ORDER_TYPE'					, width: 100, hidden: true },
			{ dataIndex: 'ORDER_TYPE_NM'				, width: 100},
			{ dataIndex: 'INOUT_TYPE_DETAIL'			, width: 80, hidden: true },
			{ dataIndex: 'INOUT_TYPE_DETAIL_NM'			, width: 80 },
			{ dataIndex: 'DVRY_DATE'					, width: 80 },
			{ dataIndex: 'DVRY_TIME'					, width: 80 , hidden: true },
			{ dataIndex: 'DVRY_CUST_NM'					, width: 110 },
			{ dataIndex: 'CUSTOM_CODE'					, width: 120, hidden: true },
			{ dataIndex: 'CUSTOM_NAME'					, width: 120  },
			{ dataIndex: 'SALE_CUSTOM_CODE'				, width: 120, hidden: true },
			{ dataIndex: 'SALE_CUSTOM_NAME'				, width: 120 },
			{ dataIndex: 'ISSUE_DIV_CODE'				, width: 120, hidden: true },
			{ dataIndex: 'ISSUE_DIV_CODE_NM'			, width: 120  },
			{ dataIndex: 'ISSUE_REQ_PRSN'				, width: 80 , hidden: true },
			{ dataIndex: 'ISSUE_REQ_PRSN_NM'			, width: 80 },
			{ dataIndex: 'ISSUE_REQ_NUM'				, width: 120 },
			{ dataIndex: 'ISSUE_REQ_SEQ'				, width: 80 , hidden: true },
			{ dataIndex: 'ORDER_NUM'					, width: 120 },
			{ dataIndex: 'SER_NO'						, width: 40 , hidden: true },
			{ dataIndex: 'PROJECT_NO'					, width: 120 },
			{ dataIndex: 'PO_NUM'						, width: 120 },
			{ dataIndex: 'BOOKING_NUM'					, width: 120 },
			{ dataIndex: 'AGENT_TYPE'					, width: 80, hidden: true  },
			{ dataIndex: 'AREA_TYPE'					, width: 80, hidden: true  },
			{ dataIndex: 'ITEM_LEVEL1'					, width: 80, hidden: true  },
			{ dataIndex: 'ITEM_LEVEL2'					, width: 80, hidden: true  },
			{ dataIndex: 'ITEM_LEVEL3'					, width: 80, hidden: true  },
			{ dataIndex: 'ITEM_GROUP'					, width: 80, hidden: true  },
			{ dataIndex: 'ITEM_GROUP_NM'				, width: 80, hidden: true  },
			{ dataIndex: 'SORT'							, width: 80, hidden: true  },
			//20200116 추가
			{ dataIndex: 'ITEM_INFO'					, width: 80  },
			//20200508 추가: 비고(출하)
			{ dataIndex: 'OUT_REMARK'					, width: 150, hidden: true },
			//20200604 추가: 포장형태, 비고, 내부기록, 포장지시수량, 포장출고수량, 창고cell
			{ dataIndex: 'PACK_TYPE'					, width: 80, hidden: true, align: 'center'},
			{ dataIndex: 'REMARK'						, width: 150, hidden: true },
			{ dataIndex: 'REMARK_INTER'					, width: 150, hidden: true },
			{ dataIndex: 'ORDER_PACK_Q'					, width: 100, hidden: true },
			{ dataIndex: 'OUT_PACK_Q'					, width: 100, hidden: true },
			{ dataIndex: 'WH_CELL_CODE'					, width: 100, hidden: true,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filterBy(function(item){
						return item.get('option') == record.get('WH_CODE')
					})
				}
			}
		],
		listeners:{
			selectionchange:function( grid, selection, eOpts ) {
				if(selection && selection.startCell) {
					var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary");
						if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex) {

						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
						var sum = 0;

						for(var i=startIdx; i <= endIdx; i++){
							var record = store.getAt(i);
							sum += record.get(columnName);
						}
						this.down('#selectionSummary').setValue(sum);
					} else {
						this.down('#selectionSummary').setValue(0);
					}
				}
			},
			afterrender: function(grid) {
				/* 시간 관련 Grid 설정 */
                var TimeShow = '${TIMESHOW}';
                if(TimeShow == 'Y') {
                    masterGrid1.getColumn('DELIVERY_TIME').setVisible(false);
                    masterGrid1.getColumn('DVRY_TIME').setVisible(false);
                }
				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				this.contextMenu.add({
					text: '<t:message code="system.label.sales.issueentry" default="출고등록"/>', iconCls : '',
					handler: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						//출고등록 완료된 데이터는 링크하지 않음
						if(record.get('ISSUE_REQ_QTY') == record.get('ISSUE_QTY')) {
							Unilite.messageBox('출고완료된 데이터는 출고등록으로 링크할 수 없습니다.');
							return false;
						}
						var params = {
							sender: me,
							'PGM_ID'	: 'srq100skrv',
							COMP_CODE	: UserInfo.compCode,
							DIV_CODE	: panelResult.getValue('DIV_CODE'),
							'record'	: record
						}
						var rec = {data : {prgID : 'str103ukrv', 'text':''}};
						parent.openTab(rec, '/sales/str103ukrv.do', params);
					}
				});
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('srq100skrvGrid2', {
		layout: 'fit',
		title: '<t:message code="system.label.sales.salesplaceby" default="매출처별"/>',
		store: directMasterStore2,
		region: 'center',
		uniOpt: {
			useGroupSummary	: true,
			useLiveSearch	  : true,
			useContextMenu	 : true,
			useMultipleSorting : true,
			useRowNumberer	 : false,
			expandLastColumn: false,
			excel: {
				useExcel	  : true,			//엑셀 다운로드 사용 여부
				exportGroup: true, 		//group 상태로 export 여부
				onlyData	  : false,
				summaryExport : true
			}
		},
		features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id: 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		columns:  [
			{ dataIndex: 'SALE_CUSTOM_CODE'				,		 	width: 120,locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.custom" default="거래처"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex: 'SALE_CUSTOM_NAME'				, width: 120 ,locked: false},
			{ dataIndex: 'CUSTOM_CODE'					, width: 120,locked: false, hidden:true},
			{ dataIndex: 'CUSTOM_NAME'					, width: 120 ,locked: false , hidden:true},
			{ dataIndex: 'ITEM_CODE'					, width: 100 , locked: false },
			{ dataIndex: 'ITEM_NAME'					, width: 150, locked: false },
			{ dataIndex: 'ITEM_NAME1'					, width: 150, hidden: true },
			{ dataIndex: 'SPEC'							, width: 150, locked: false },
			{ dataIndex: 'ORDER_UNIT'					, width: 64, align: 'center' },
			{ dataIndex: 'TRANS_RATE'					, width: 64, align: 'right' },
//			{ dataIndex: 'ISSUE_REQ_QTY'				, width: 100, summaryType: 'sum' },
			{ dataIndex: 'MONEY_UNIT'					, width: 65  },
			{ dataIndex: 'ORIGINAL_PRICE'				, width: 100, hidden: true  },
			{ dataIndex: 'ISSUE_REQ_PRICE'				, width: 113 , hidden: true},
			{ dataIndex: 'ISSUE_REQ_QTY'				, width: 100, summaryType: 'sum' },
			//20200116 추가: 현재고량(STOCK_Q)
			{ dataIndex: 'STOCK_Q'						, width: 100},
			{ dataIndex: 'ORIGINAL_REQ_AMT'				, width: 113, hidden: true, summaryType: 'sum' },
			{ dataIndex: 'ISSUE_REQ_AMT'				, width: 113 , hidden: true, summaryType: 'sum' },
			{ dataIndex: 'ISSUE_QTY'					, width: 100, summaryType: 'sum' },
			{ dataIndex: 'ORIGINAL_AMT'					, width: 113, hidden: true, summaryType: 'sum' },
			{ dataIndex: 'ISSUE_AMT'					, width: 113 , hidden: true, summaryType: 'sum' },
			{ dataIndex: 'ISSUE_REQ_DATE'				, width: 80 },
			{ dataIndex: 'LOT_NO'						, width: 100 },
			{ dataIndex: 'ISSUE_DATE'					, width: 80 },
			{ dataIndex: 'DELIVERY_TIME'				, width: 80, hidden: true  },
			{ dataIndex: 'WH_CODE'						, width: 40, hidden: true  },
			{ dataIndex: 'WH_CODE_NM'					, width: 100 },
			{ dataIndex: 'ORDER_TYPE'					, width: 100, hidden: true },
			{ dataIndex: 'ORDER_TYPE_NM'				, width: 100  },
			{ dataIndex: 'INOUT_TYPE_DETAIL'			, width: 80, hidden: true },
			{ dataIndex: 'INOUT_TYPE_DETAIL_NM'			, width: 80  },
			{ dataIndex: 'DVRY_DATE'					, width: 80 },
			{ dataIndex: 'DVRY_TIME'					, width: 80, hidden: true  },
			{ dataIndex: 'DVRY_CUST_NM'					, width: 110 },
			{ dataIndex: 'ISSUE_DIV_CODE'				, width: 120, hidden: true },
			{ dataIndex: 'ISSUE_DIV_CODE_NM'			, width: 120  },
			{ dataIndex: 'ISSUE_REQ_PRSN'				, width: 80, hidden: true  },
			{ dataIndex: 'ISSUE_REQ_PRSN_NM'			, width: 80 },
			{ dataIndex: 'ISSUE_REQ_NUM'				, width: 120 },
			{ dataIndex: 'ISSUE_REQ_SEQ'				, width: 80, hidden: true  },
			{ dataIndex: 'ORDER_NUM'					, width: 120 },
			{ dataIndex: 'SER_NO'						, width: 40, hidden: true  },
			{ dataIndex: 'PROJECT_NO'					, width: 120 },
			{ dataIndex: 'PO_NUM'						, width: 120 },
			{ dataIndex: 'BOOKING_NUM'					, width: 120 },
			{ dataIndex: 'AGENT_TYPE'					, width: 80, hidden: true  },
			{ dataIndex: 'AREA_TYPE'					, width: 80, hidden: true  },
			{ dataIndex: 'ITEM_LEVEL1'					, width: 80, hidden: true  },
			{ dataIndex: 'ITEM_LEVEL2'					, width: 80, hidden: true  },
			{ dataIndex: 'ITEM_LEVEL3'					, width: 80, hidden: true  },
			{ dataIndex: 'ITEM_GROUP'					, width: 80, hidden: true  },
			{ dataIndex: 'ITEM_GROUP_NM'				, width: 80, hidden: true  },
			{ dataIndex: 'SORT'							, width: 80, hidden: true  },
			//20200508 추가: 비고(출하)
			{ dataIndex: 'OUT_REMARK'					, width: 150, hidden: true },
			//20200604 추가: 포장형태, 비고, 내부기록, 포장지시수량, 포장출고수량, 창고cell
			{ dataIndex: 'PACK_TYPE'					, width: 80, hidden: true, align: 'center' },
			{ dataIndex: 'REMARK'						, width: 150, hidden: true },
			{ dataIndex: 'REMARK_INTER'					, width: 150, hidden: true },
			{ dataIndex: 'ORDER_PACK_Q'					, width: 100, hidden: true },
			{ dataIndex: 'OUT_PACK_Q'					, width: 100, hidden: true },
			{ dataIndex: 'WH_CELL_CODE'					, width: 100, hidden: true,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filterBy(function(item){
						return item.get('option') == record.get('WH_CODE')
					})
				}
			}
		],
		listeners:{
			afterrender: function(grid) {
				/* 시간 관련 Grid 설정 */
                var TimeShow = '${TIMESHOW}';
                if(TimeShow == 'Y') {
                    masterGrid2.getColumn('DELIVERY_TIME').setVisible(false);
                    masterGrid2.getColumn('DVRY_TIME').setVisible(false);
                }
				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				this.contextMenu.add({
					text: '<t:message code="system.label.sales.issueentry" default="출고등록"/>', iconCls : '',
					handler: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						//출고등록 완료된 데이터는 링크하지 않음
						if(record.get('ISSUE_REQ_QTY') == record.get('ISSUE_QTY')) {
							Unilite.messageBox('출고완료된 데이터는 출고등록으로 링크할 수 없습니다.');
							return false;
						}
						var params = {
							sender: me,
							'PGM_ID'	: 'srq100skrv',
							COMP_CODE	: UserInfo.compCode,
							DIV_CODE	: panelResult.getValue('DIV_CODE'),
							'record'	: record
						}
						var rec = {data : {prgID : 'str103ukrv', 'text':''}};
						parent.openTab(rec, '/sales/str103ukrv.do', params);
					}
				});
			}
		}
	});

	var masterGrid3 = Unilite.createGrid('srq100skrvGrid3', {
		layout: 'fit',
		title: '<t:message code="system.label.sales.warehouseby" default="창고별"/>',
		store: directMasterStore3,
		region: 'center',
		uniOpt: {
			useGroupSummary	: true,
			useLiveSearch	  : true,
			useContextMenu	 : true,
			useMultipleSorting : true,
			useRowNumberer	 : false,
			expandLastColumn: false,
			excel: {
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: true,		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id: 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		columns:  [
			{ dataIndex: 'WH_CODE'						,		 	width: 80  , locked: false, hidden:true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.warehousetotal" default="창고계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex: 'WH_CODE_NM'					, width: 100, locked: false},
			{ dataIndex: 'ITEM_CODE'					, width: 93 , locked: false},
			{ dataIndex: 'ITEM_NAME'					, width: 150, locked: false },
			{ dataIndex: 'ITEM_NAME1'					, width: 150, hidden: true },
			{ dataIndex: 'SPEC'							, width: 150, locked: false },
			{ dataIndex: 'ORDER_UNIT'					, width: 64 , align: 'center' },
			{ dataIndex: 'TRANS_RATE'					, width: 64, align: 'right' },
//			{ dataIndex: 'ISSUE_REQ_QTY'				, width: 100, summaryType: 'sum' },
			{ dataIndex: 'MONEY_UNIT'					, width: 65  },
			{ dataIndex: 'ORIGINAL_PRICE'				, width: 100, hidden: true },
			{ dataIndex: 'ISSUE_REQ_PRICE'				, width: 113 , hidden: true},
			{ dataIndex: 'ISSUE_REQ_QTY'				, width: 100, summaryType: 'sum' },
			//20200116 추가: 현재고량(STOCK_Q)
			{ dataIndex: 'STOCK_Q'						, width: 100},
			{ dataIndex: 'ORIGINAL_REQ_AMT'				, width: 113, summaryType: 'sum' },
			{ dataIndex: 'ISSUE_REQ_AMT'				, width: 113 , hidden: true, summaryType: 'sum' },
			{ dataIndex: 'ISSUE_QTY'					, width: 100, summaryType: 'sum' },
			{ dataIndex: 'ORIGINAL_AMT'					, width: 113, hidden: true, summaryType: 'sum' },
			{ dataIndex: 'ISSUE_AMT'					, width: 113 , hidden: true, summaryType: 'sum' },
			{ dataIndex: 'ISSUE_REQ_DATE'				, width: 80 },
			{ dataIndex: 'LOT_NO'						, width: 100 },
			{ dataIndex: 'ISSUE_DATE'					, width: 80},
			{ dataIndex: 'DELIVERY_TIME'				, width: 80 , hidden: true  },
			{ dataIndex: 'DVRY_DATE'					, width: 80},
			{ dataIndex: 'DVRY_TIME'					, width: 80 , hidden: true  },
			{ dataIndex: 'ORDER_TYPE'					, width: 100, hidden: true },
			{ dataIndex: 'ORDER_TYPE_NM'				, width: 100},
			{ dataIndex: 'INOUT_TYPE_DETAIL'			, width: 80 , hidden: true },
			{ dataIndex: 'INOUT_TYPE_DETAIL_NM'			, width: 80 },
			{ dataIndex: 'ISSUE_REQ_PRSN'				, width: 80 , hidden: true  },
			{ dataIndex: 'ISSUE_REQ_PRSN_NM'			, width: 80 },
			{ dataIndex: 'ISSUE_DIV_CODE'				, width: 120, hidden: true },
			{ dataIndex: 'ISSUE_DIV_CODE_NM'			, width: 120},
			{ dataIndex: 'DVRY_CUST_NM'					, width: 110},
			{ dataIndex: 'CUSTOM_CODE'					, width: 120, hidden: true },
			{ dataIndex: 'CUSTOM_NAME'					, width: 120},
			{ dataIndex: 'SALE_CUSTOM_CODE'				, width: 120, hidden: true  },
			{ dataIndex: 'SALE_CUSTOM_NAME'				, width: 120},
			{ dataIndex: 'ISSUE_REQ_NUM'				, width: 120 },
			{ dataIndex: 'ISSUE_REQ_SEQ'				, width: 80, hidden: true  },
			{ dataIndex: 'ORDER_NUM'					, width: 120 },
			{ dataIndex: 'SER_NO'						, width: 40, hidden: true  },
			{ dataIndex: 'PROJECT_NO'					, width: 120 },
			{ dataIndex: 'PO_NUM'						, width: 100 },
			{ dataIndex: 'BOOKING_NUM'					, width: 120 },
			{ dataIndex: 'AGENT_TYPE'					, width: 80, hidden: true  },
			{ dataIndex: 'AREA_TYPE'					, width: 80, hidden: true  },
			{ dataIndex: 'ITEM_LEVEL1'					, width: 80, hidden: true  },
			{ dataIndex: 'ITEM_LEVEL2'					, width: 80, hidden: true  },
			{ dataIndex: 'ITEM_LEVEL3'					, width: 80, hidden: true  },
			{ dataIndex: 'ITEM_GROUP'					, width: 80, hidden: true  },
			{ dataIndex: 'ITEM_GROUP_NM'				, width: 80, hidden: true  },
			{ dataIndex: 'SORT'							, width: 80, hidden: true  },
			//20200508 추가: 비고(출하)
			{ dataIndex: 'OUT_REMARK'					, width: 150, hidden: true },
			//20200604 추가: 포장형태, 비고, 내부기록, 포장지시수량, 포장출고수량, 창고cell, 창고cell
			{ dataIndex: 'PACK_TYPE'					, width: 80, hidden: true, align: 'center' },
			{ dataIndex: 'REMARK'						, width: 150, hidden: true },
			{ dataIndex: 'REMARK_INTER'					, width: 150, hidden: true },
			{ dataIndex: 'ORDER_PACK_Q'					, width: 100, hidden: true },
			{ dataIndex: 'OUT_PACK_Q'					, width: 100, hidden: true },
			{ dataIndex: 'WH_CELL_CODE'					, width: 100, hidden: true,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filterBy(function(item){
						return item.get('option') == record.get('WH_CODE')
					})
				}
			}
		],
		listeners:{
			afterrender: function(grid) {
				/* 시간 관련 Grid 설정 */
                var TimeShow = '${TIMESHOW}';
                if(TimeShow == 'Y') {
                    masterGrid3.getColumn('DELIVERY_TIME').setVisible(false);
                    masterGrid3.getColumn('DVRY_TIME').setVisible(false);
                }
				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				this.contextMenu.add({
					text: '<t:message code="system.label.sales.issueentry" default="출고등록"/>', iconCls : '',
					handler: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						//출고등록 완료된 데이터는 링크하지 않음
						if(record.get('ISSUE_REQ_QTY') == record.get('ISSUE_QTY')) {
							Unilite.messageBox('출고완료된 데이터는 출고등록으로 링크할 수 없습니다.');
							return false;
						}
						var params = {
							sender: me,
							'PGM_ID'	: 'srq100skrv',
							COMP_CODE	: UserInfo.compCode,
							DIV_CODE	: panelResult.getValue('DIV_CODE'),
							'record'	: record
						}
						var rec = {data : {prgID : 'str103ukrv', 'text':''}};
						parent.openTab(rec, '/sales/str103ukrv.do', params);
					}
				});
			}
		}
	});

	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab:  0,
		region: 'center',
		items:  [
			//20190715 탭 순서 변경: 품목별/매출처별/창고별 -> 매출처별/품목별/창고별
			masterGrid2, masterGrid1, masterGrid3
		],
		listeners:  {
			beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
				switch(newCard.getId()) {
					case 'srq100skrvGrid1':
						break;
					case 'srq100skrvGrid2':
						break;
					case 'srq100skrvGrid3':
						break;
					default:
						break;
				}
			}
		}
	});



	Unilite.Main( {
		id : 'srq100skrvApp',
		borderItems:[{
			region: 'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		},
		panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue("ISSUE_REQ_DATE_FR",UniDate.get('startOfMonth'))
			panelSearch.setValue("ISSUE_REQ_DATE_TO",UniDate.get('today'))
			panelResult.setValue("ISSUE_REQ_DATE_FR2",UniDate.get('startOfMonth'))
			panelResult.setValue("ISSUE_REQ_DATE_TO2",UniDate.get('today'))
			panelSearch.getField('rdoSelect4').setValue("A");
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',false);
			
		},
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			var activeTabId = tab.getActiveTab().getId();
			var grid = masterGrid1;
			if(activeTabId == 'srq100skrvGrid1'){
				grid = masterGrid1;
				masterGrid1.reset();
				directMasterStore1.loadStoreRecords();
			}else if(activeTabId == 'srq100skrvGrid2'){
				grid = masterGrid2;
				masterGrid2.reset();
				directMasterStore2.loadStoreRecords();
			}else if(activeTabId == 'srq100skrvGrid3'){
				grid = masterGrid3;
				masterGrid3.reset();
				directMasterStore3.loadStoreRecords();
			}
			UniAppManager.setToolbarButtons('reset',true);
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		onResetButtonDown:function(){
			panelResult.clearForm();
			panelSearch.clearForm();
			masterGrid1.reset();
			masterGrid1.getStore().clearData();
			masterGrid2.reset();
			masterGrid2.getStore().clearData();
			masterGrid3.reset();
			masterGrid3.getStore().clearData();
			this.fnInitBinding();
		}
	});
};
</script>