<%--
'   프로그램명 : 출고등록 (구매재고)
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'   최종수정자 :
'   최종수정일 :
'   버	  전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mtr202ukrv"  >
   <t:ExtComboStore comboType="BOR120"  />									<!-- 사업장 -->
   <t:ExtComboStore comboType="AU" comboCode="B005" opts= '1;2;3' />		<!-- 출고처 구분 -->
   <t:ExtComboStore comboType="AU" comboCode="B024" />						<!-- 출고담당 -->
   <t:ExtComboStore comboType="AU" comboCode="M101" />						<!-- 자동채번 -->
   <t:ExtComboStore comboType="AU" comboCode="M104" />						<!-- 출고유형 -->
   <t:ExtComboStore comboType="AU" comboCode="B021" />						<!-- 품목상태 -->
   <t:ExtComboStore comboType="AU" comboCode="B022" />						<!-- 재고상태 -->
   <t:ExtComboStore comboType="AU" comboCode="B031" />						<!-- 생성경로 -->
   <t:ExtComboStore comboType="AU" comboCode="B013" />						<!-- 재고단위 -->
   <t:ExtComboStore comboType="AU" comboCode="P106" />						<!-- 진행상태 -->
   <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />			<!--창고-->
   <t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />			<!--작업장-->
   <t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고Cell-->
   <t:ExtComboStore comboType="WU" />        <!-- 작업장-->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >


var SearchInfoWindow;	// 조회버튼 누르면 나오는 조회창
var RefSearchWindow;	// 출고요청 참조
var RefSearchWindow2;	// 반품가능요청 참조
var alertWindow;			//alertWindow : 경고창
var gsText			= ''	//바코드 알람 팝업 메세지

var gsMaxInoutSeq	= 0;
var gsSaveFlag		= false;

var BsaCodeInfo	= {
	gsAutoType			: '${gsAutoType}',
	gsInvstatus			: '${gsInvstatus}',
	gsMoneyUnit			: '${gsMoneyUnit}',
	gsInoutCodeType		: '${gsInoutCodeType}',
	gsManageLotNoYN		: '${gsManageLotNoYN}',
	gsBomPathYN			: '${gsBomPathYN}',
	gsSumTypeCell		: '${gsSumTypeCell}',
	gsOutDetailType		: '${gsOutDetailType}',
	whList				:  ${whList},
	gsUsePabStockYn		: '${gsUsePabStockYn}',
	gsCheckStockYn		: '${gsCheckStockYn}',
	gsFifo				: '${gsFifo}',
	gsLotNoMgntYn		: '${gsLotNoMgntYn}',
	gsReportGubun		: '${gsReportGubun}',
	gsBarcodeGbn		: '${gsBarcodeGbn}'
};
/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);
*/

var outDivCode = UserInfo.divCode;
var barcodeGbn = BsaCodeInfo.gsBarcodeGbn;
function appMain() {

	var gsSumTypeCell = false;
	if(BsaCodeInfo.gsSumTypeCell =='N')	{
		gsSumTypeCell = true;
	}

	var sumtypeCell = true;					//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeCell =='Y') {
		sumtypeCell = false;
	}

	var usePabStockYn = true;				//가용재고 컬럼 사용여부
	if(BsaCodeInfo.gsUsePabStockYn =='Y') {
		usePabStockYn = false;
	}

	var gsManageLotNoYN = false;
	if(BsaCodeInfo.gsManageLotNoYN =='N') {
		gsManageLotNoYN = true;
	}

	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoOrderNum = true;
	}

	var isCheckStockYn = false;
	if(BsaCodeInfo.gsCheckStockYn=='+') {
		isCheckStockYn = true;
	}





	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'mtr202ukrvService.selectList'//,
//			update	: 'mtr202ukrvService.updateDetail',
//			create	: 'mtr202ukrvService.insertDetail',
//			destroy	: 'mtr202ukrvService.deleteDetail',
//			syncAll	: 'mtr202ukrvService.saveAll'
		}
	});

	//바코드 관련 Proxy
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'mtr202ukrvService.selectList2',
			update	: 'mtr202ukrvService.updateDetail',
			create	: 'mtr202ukrvService.insertDetail',
			destroy	: 'mtr202ukrvService.deleteDetail',
			syncAll	: 'mtr202ukrvService.saveAll'
		}
	});




	/** Model 정의
	* @type
	*/
	//mainGrid Model
	Unilite.defineModel('mtr202ukrvModel', {
		fields: [
			{name: 'REF_GUBUN'				, text: '<t:message code="system.label.purchase.referenceclassification" default="참조구분"/>'		, type: 'string'},
			{name: 'INOUT_NUM'				, text: '<t:message code="system.label.purchase.issueno" default="출고번호"/>'		, type: 'string'},
			{name: 'INOUT_SEQ'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'		, type: 'int'},
			{name: 'INOUT_METH'				, text: '<t:message code="system.label.purchase.method" default="방법"/>'		, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		, text: '<t:message code="system.label.purchase.issuetype" default="출고유형"/>'		, type: 'string', comboType: 'AU', comboCode: 'M104', allowBlank: false},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string', comboType: 'BOR120', child: 'WH_CODE'},
			{name: 'INOUT_CODE'				, text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>'		, type: 'string'},
			{name: 'INOUT_CODE_DETAIL'		, text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>Cell'	, type: 'string'},
			{name: 'INOUT_NAME'				, text: '<t:message code="system.label.purchase.issueplacename" default="출고처명"/>'		, type: 'string'},
			{name: 'INOUT_NAME1'			, text: '<t:message code="system.label.purchase.issueplacename" default="출고처명"/>'		, type: 'string'},
			{name: 'INOUT_NAME2'			, text: '<t:message code="system.label.purchase.issueplacename" default="출고처명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.purchase.spec" default="규격"/>'		, type: 'string'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'PATH_CODE'				, text: '<t:message code="system.label.purchase.pathinfo" default="PATH정보"/>'	, type: 'string'},
			{name: 'NOT_Q'					, text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>'		, type: 'uniQty'},
			{name: 'INOUT_Q'				, text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'		, type: 'uniQty', allowBlank: false},
			{name: 'ITEM_STATUS'			, text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>'		, type: 'string', comboType: 'AU', comboCode: 'B021', allowBlank: false},
			{name: 'ORIGINAL_Q'				, text: '<t:message code="system.label.purchase.issueqtywon" default="출고량(원)"/>'	, type: 'uniQty'},
			{name: 'PAB_STOCK_Q'			, text: '<t:message code="system.label.purchase.availableinventoryqty" default="가용재고량"/>'		, type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'			, text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>'		, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'			, text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'		, type: 'uniQty'},
			{name: 'BASIS_NUM'				, text: '<t:message code="system.label.purchase.basisno" default="근거번호"/>'		, type: 'string'},
			{name: 'BASIS_SEQ'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'		, type: 'int'},
			{name: 'INOUT_TYPE'				, text: '<t:message code="system.label.purchase.type" default="타입"/>'		, type: 'string'},
			{name: 'INOUT_CODE_TYPE'		, text: '<t:message code="system.label.purchase.tranplacedivision" default="수불처구분"/>'		, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('whList'), allowBlank: false, child: 'WH_CELL_CODE'},
			{name: 'WH_CELL_CODE'			, text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>Cell	' , type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','DIV_CODE']},
			{name: 'INOUT_DATE'				, text: '<t:message code="system.label.purchase.transdate" default="수불일자"/>'		, type: 'uniDate'},
			{name: 'INOUT_P'				, text: '<t:message code="system.label.purchase.tranprice" default="수불단가"/>'		, type: 'uniUnitPrice'},
			{name: 'INOUT_I'				, text: '<t:message code="system.label.purchase.localamount" default="원화금액"/>'		, type: 'uniPrice'},
			{name: 'MONEY_UNIT'				, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'		, type: 'string'},
			{name: 'INOUT_PRSN'				, text: '<t:message code="system.label.purchase.charger" default="담당자"/>'		, type: 'string'},
			{name: 'ACCOUNT_Q'				, text: '<t:message code="system.label.purchase.billqty" default="계산서량"/>'		, type: 'uniQty'},
			{name: 'ACCOUNT_YNC'			, text: '<t:message code="system.label.purchase.billobject" default="계산서대상"/>'		, type: 'string'},
			{name: 'CREATE_LOC'				, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'		, type: 'string', comboType: 'AU', comboCode: 'B031'},
			{name: 'ORDER_NUM'				, text: 'ORDER_NUM'	, type: 'string'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'		, type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'	, type: 'string'},
			{name: 'LOT_NO'					, text: 'LOT NO'	, type: 'string'},
			{name: 'SALE_DIV_CODE'			, text: '<t:message code="system.label.purchase.salesdivision" default="매출사업장"/>'		, type: 'string'},
			{name: 'SALE_CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.salesplace" default="매출처"/>'		, type: 'string'},
			{name: 'BILL_TYPE'				, text: '<t:message code="system.label.purchase.salestype" default="매출유형"/>'		, type: 'string'},
			{name: 'SALE_TYPE'				, text: '<t:message code="system.label.purchase.salesclass" default="매출구분"/>'		, type: 'string'},
			{name: 'COMP_CODE'				, text: 'COMP_CODE'	, type: 'string'},
			{name: 'ARRAY_OUTSTOCK_NUM'		, text: '<t:message code="system.label.purchase.issuerequestno" default="출고요청번호"/>'	, type: 'string'},
			{name: 'ARRAY_REF_WKORD_NUM'	, text: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>'	, type: 'string'},
			{name: 'ARRAY_OUTSTOCK_REQ_Q'	, text: '<t:message code="system.label.purchase.requestqty" default="요청량"/>'		, type: 'uniQty'},
			{name: 'ARRAY_OUTSTOCK_Q'		, text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'		, type: 'uniQty'},
			{name: 'ARRAY_REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'		, type: 'string'},
			{name: 'ARRAY_PROJECT_NO'		, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'	, type: 'string'},
			{name: 'ARRAY_LOT_NO'			, text: 'LOT NO'	, type: 'string'},
			{name: 'UPDATE_DB_USER'			, text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>'		, type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '<t:message code="system.label.purchase.updatedate" default="수정일"/>'		, type: 'string'},
			{name: 'LOT_YN'					, text: '<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'	, type: 'string'}
		]
	});//End of Unilite.defineModel('mtr202ukrvModel', {

	//조회팝업
	Unilite.defineModel('releaseNoMasterModel', {
		fields: [
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>'		, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
			{name: 'WH_CELL_CODE'		, text: 'CELL<t:message code="system.label.purchase.warehouse" default="창고"/>'	, type: 'string'},
			{name: 'WH_CELL_NAME'		, text: 'CELL<t:message code="system.label.purchase.warehouse" default="창고"/>'	, type: 'string'},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.purchase.issuedate" default="출고일"/>'		, type: 'uniDate'},
			{name: 'INOUT_CODE_TYPE'	, text: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>'		, type: 'string',comboType: 'AU',comboCode: 'B005'},
			{name: 'INOUT_CODE'			, text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>'		, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
			{name: 'INOUT_NAME'			, text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>'		, type: 'string'},
			{name: 'INOUT_PRSN'			, text: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>'		, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.issueno" default="출고번호"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>'		, type: 'string',comboType:'BOR120'},
			{name: 'LOT_NO'				, text: 'LOT NO'	, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'	, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'}
		]
	});

	//출고요청 참조
	Unilite.defineModel('refSearchMasterModel', {
		fields: [
			{name: 'CHOICE'				, text: '<t:message code="system.label.purchase.selection" default="선택"/>'			, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string', comboType: 'BOR120'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.purchase.workcentercode" default="작업장코드"/>'			, type: 'string'},
			{name: 'WORK_SHOP_NAME'		, text: '<t:message code="system.label.purchase.workcentername" default="작업장명"/>'			, type: 'string'},
			{name: 'WORK_WH_CODE'		, text: '<t:message code="system.label.purchase.processingwarehousecode" default="가공창고코드"/>'		, type: 'string'},
			{name: 'WORK_WH_NAME'		, text: '<t:message code="system.label.purchase.processingwarehouse" default="가공창고"/>'			, type: 'string'},
			{name: 'WORK_WH_CELL_CODE'	, text: '<t:message code="system.label.purchase.processingwarehousecell" default="가공창고CELL"/>'		, type: 'string'},
			{name: 'WORK_WH_CELL_NAME'	, text: '<t:message code="system.label.purchase.processingwarehousecellcode" default="가공창고CELL코드"/>'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string',comboType: 'AU',comboCode: 'B013', displayField: 'value'},
			{name: 'PATH_CODE'			, text: '<t:message code="system.label.purchase.pathinfo" default="PATH정보"/>'		, type: 'string'},
			{name: 'OUTSTOCK_REQ_DATE'	, text: '<t:message code="system.label.purchase.requestdate" default="요청일"/>'			, type: 'uniDate'},
			{name: 'OUTSTOCK_REQ_Q'		, text: '<t:message code="system.label.purchase.requestqty" default="요청량"/>'			, type: 'uniQty'},
			{name: 'OUTSTOCK_Q'			, text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'			, type: 'uniQty'},
			{name: 'NOT_Q'				, text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>'			, type: 'uniQty'},
			{name: 'STOCK_Q'			, text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'			, type: 'uniQty'},
			{name: 'PAB_STOCK_Q'		, text: '<t:message code="system.label.purchase.availableinventoryqty" default="가용재고량"/>'			, type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'		, text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>'			, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'		, text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'			, type: 'uniQty'},
			{name: 'AVERAGE_P'			, text: '<t:message code="system.label.purchase.inventoryprice" default="재고단가"/>'			, type: 'uniUnitPrice'},
			{name: 'MAIN_WH_CODE'		, text: '<t:message code="system.label.purchase.mainwarehousecode" default="주창고코드"/>'			, type: 'string'},
			{name: 'MAIN_WH_NAME'		, text: '<t:message code="system.label.purchase.mainwarehouse" default="주창고"/>'			, type: 'string'},
			{name: 'OUTSTOCK_NUM'		, text: '<t:message code="system.label.purchase.issuerequestno" default="출고요청번호"/>'		, type: 'string'},
			{name: 'CONTROL_STATUS'		, text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'			, type: 'string', comboType :"AU" , comboCode : "P106"},
			{name: 'CANCEL_Q'			, text: '<t:message code="system.label.purchase.cancelqty" default="취소량"/>'			, type: 'uniQty'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'			, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
			{name: 'WH_CELL_CODE'		, text: 'CELL<t:message code="system.label.purchase.warehouse" default="창고"/>'		, type: 'string'},
			{name: 'REF_WKORD_NUM'		, text: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>'		, type: 'string'},
			{name: 'WK_LOT_NO'			, text: 'LOT NO'		, type: 'string'},
			{name: 'WK_REMARK'			, text: '<t:message code="system.label.purchase.remarksworkorder" default="비고(작지)"/>'		, type: 'string'},
			{name: 'WK_PROJECT_NO'		, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>(<t:message code="system.label.purchase.workorder" default="작지"/>)'	, type: 'string'},
			{name: 'PROD_ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>(<t:message code="system.label.purchase.workorder" default="작지"/>)'		, type: 'string'},
			{name: 'PROD_ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>(<t:message code="system.label.purchase.workorder" default="작지"/>)'		, type: 'string'},
			{name: 'LOT_YN'				, text: '<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'		, type: 'string'}
		]
	});


	//반품가능 참조
	Unilite.defineModel('refSearchMasterModel2', {
		fields: [
			{name: 'CHOICE'				, text: '<t:message code="system.label.purchase.selection" default="선택"/>'			, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.purchase.workcentercode" default="작업장코드"/>'			, type: 'string'},
			{name: 'WORK_SHOP_NAME'		, text: '<t:message code="system.label.purchase.workcenter" default="작업장"/>'			, type: 'string'},
			{name: 'WORK_WH_CODE'		, text: '<t:message code="system.label.purchase.processingwarehousecode" default="가공창고코드"/>'		, type: 'string'},
			{name: 'WORK_WH_NAME'		, text: '<t:message code="system.label.purchase.processingwarehouse" default="가공창고"/>'			, type: 'string'},
			{name: 'OUTSTOCK_REQ_DATE'	, text: '<t:message code="system.label.purchase.requestdate" default="요청일"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string',comboType: 'AU',comboCode: 'B013', displayField: 'value'},
			{name: 'PATH_CODE'			, text: '<t:message code="system.label.purchase.pathinfo" default="PATH정보"/>'		, type: 'string'},
			{name: 'NOTOUTSTOCK_Q'		, text: '<t:message code="system.label.purchase.returnavaiableqty" default="반품가능량"/>'		, type: 'uniQty'},
			{name: 'OUTSTOCK_Q'			, text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'			, type: 'uniQty'},
			{name: 'NOT_Q'				, text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>'			, type: 'uniQty'},
			{name: 'STOCK_Q'			, text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'			, type: 'uniQty'},
			{name: 'OUTSTOCK_NUM'		, text: '<t:message code="system.label.purchase.issuerequestno" default="출고요청번호"/>'		, type: 'string'},
			{name: 'CONTROL_STATUS'		, text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'			, type: 'string', comboType :"AU" , comboCode : "P106"},
			{name: 'CANCEL_Q'			, text: '<t:message code="system.label.purchase.cancelqty" default="취소량"/>'			, type: 'uniQty'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'			, type: 'string'},
			{name: 'WH_CELL_CODE'		, text: 'CELL<t:message code="system.label.purchase.warehouse" default="창고"/>'		, type: 'string'},
			{name: 'REF_WKORD_NUM'		, text: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>'		, type: 'string'},
			{name: 'WK_LOT_NO'			, text: 'LOT NO'		, type: 'string'}
		]
	});





	/** Store 정의(Service 정의)
	* @type
	*/
	var directMasterStore1 = Unilite.createStore('mtr202ukrvMasterStore1',{
		model	: 'mtr202ukrvModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		//전체삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
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

			var inoutNum = panelResult.getValue('INOUT_NUM');
			var isErr = false;
			Ext.each(list, function(record, index) {
				if(record.data['INOUT_NUM'] != inoutNum) {
					record.set('INOUT_NUM', inoutNum);
				}
				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
					alert((index + 1) + '<t:message code="system.message.commonJS.grid.invalidColumn" default="행의 입력값을 확인해 주세요."/>' + '\n' + 'LOT NO: ' + '<t:message code="system.message.product.datacheck001" default="필수입력 항목입니다."/>');
					isErr = true;
					return false;
				}
			});
			if(isErr) return false;

//			var totRecords = directMasterStore1.data.items;
//			Ext.each(totRecords, function(record, index) {
//				record.set('SORT_SEQ', index+1);
//			});
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("INOUT_NUM", master.INOUT_NUM);
						panelResult.setValue("INOUT_NUM", master.INOUT_NUM);

						directMasterStore1.loadStoreRecords();
						if(directMasterStore1.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});//End of var directMasterStore1 = Unilite.createStore('mtr202ukrvMasterStore1',{

	//조회팝업
	var releaseNoMasterStore = Unilite.createStore('releaseNoMasterStore', {
		model	: 'releaseNoMasterModel',
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
				read : 'mtr202ukrvService.selectreleaseNoMasterList'
			}
		},
		loadStoreRecords : function() {
			var param= releaseNoSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	//출고요청 참조
	var refSearchMasterStore = Unilite.createStore('refSearchMasterStore', {
		model	: 'refSearchMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read : 'mtr202ukrvService.selectrefList'
			}
		},
		loadStoreRecords : function() {
			var param				= refSearch.getValues();
			param.DIV_CODE			= panelResult.getValue("DIV_CODE");
			param.OUT_WH_CODE		= panelResult.getValue("WH_CODE");
			param.INOUT_CODE_TYPE	= panelResult.getValue("INOUT_CODE_TYPE");
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(successful)  {
					var masterRecords = refSearchMasterStore.data.filterBy(refSearchMasterStore.filterNewOnly);
					var estiRecords = new Array();

					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);

						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								if(record.data['OUTSTOCK_NUM'] == item.data['OUTSTOCK_NUM']) {
									estiRecords.push(item);
								}
							});
						});
						store.remove(estiRecords);
					}
				}
			}
		}
	});

	//반품가능 참조
	var refSearchMasterStore2 = Unilite.createStore('refSearchMasterStore2', {
		model	: 'refSearchMasterModel2',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api : {
				read : 'mtr202ukrvService.selectrefList2'
			}
		},
		loadStoreRecords : function() {
			var param				= refSearch2.getValues();
			param.DIV_CODE			= panelResult.getValue("DIV_CODE");
			param.OUT_WH_CODE		= panelResult.getValue("WH_CODE");
			param.INOUT_CODE_TYPE	= panelResult.getValue("INOUT_CODE_TYPE");
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(successful)  {
					var masterRecords = refSearchMasterStore2.data.filterBy(refSearchMasterStore2.filterNewOnly);
					var estiRecords = new Array();

					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);

						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								if(record.data['OUTSTOCK_NUM'] == item.data['OUTSTOCK_NUM']){
									estiRecords.push(item);
								}
							});
						});
						store.remove(estiRecords);
					}
				}
			}
		}
	});

	//바코드관련 Store
	var barcodeStore = Unilite.createStore('mtr202ukrvBarcodeStore', {
		model	: 'mtr202ukrvModel',
		proxy	: directProxy2,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			allDeletable: true,			// 전체 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)) {
					gsMaxInoutSeq = records[0].get('MAX_INOUT_SEQ');
				}
				panelResult.getField('BARCODE').focus();
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		loadStoreRecords: function() {
			var param = panelResult.getValues();

			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success)	{
//						panelResult.setValue('LOT_NO_S', '');
					}
				}
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

			var orderNum = panelResult.getValue('INOUT_NUM');
			var isErr = false;
			Ext.each(list, function(record, index) {
				if(record.data['INOUT_NUM'] != orderNum) {
					record.set('INOUT_NUM', orderNum);
				}
				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
					alert((index + 1) + '<t:message code="system.message.commonJS.grid.invalidColumn" default="행의 입력값을 확인해 주세요."/>' + '\n' + 'LOT NO: ' + '<t:message code="system.message.product.datacheck001" default="필수입력 항목입니다."/>');
					isErr = true;
					return false;
				}
			});
			if(isErr) return false;

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("INOUT_NUM", master.INOUT_NUM);

						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
//						Ext.getCmp('btnPrint').setDisabled(false);			//출력버튼 활성화
						UniAppManager.setToolbarButtons(['print'], true);	//출력버튼 활성화(버튼 대신 상단 아이콘 사용)
						UniAppManager.setToolbarButtons('save', false);
						directMasterStore1.loadStoreRecords();
						if(directMasterStore1.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				barcodeGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});





	/** 검색조건 (Search Panel)
	* @type
	*/
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
			items: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				holdable	: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>',
				name		: 'INOUT_CODE_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B005',
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						UniAppManager.app.setHiddenColumn();
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
				xtype		: 'uniDatefield',
				name		: 'INOUT_DATE',
				value		: UniDate.get('today'),
				allowBlank	: false,
				holdable	: 'hold',
				colspan		: 2,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
				name		: 'INOUT_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B024',
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				allowBlank	: false,
				child		: 'WH_CELL_CODE',
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>Cell',
				name		: 'WH_CELL_CODE',
				xtype		: 'uniCombobox',
				holdable	: 'hold',
				hidden		: true,
				store		: Ext.data.StoreManager.lookup('whCellList'),
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.issueno" default="출고번호"/>',
				name		: 'INOUT_NUM',
				xtype		: 'uniTextfield',
				readOnly	: isAutoOrderNum,
				holdable	: 'hold',
				holdable	: isAutoOrderNum ? 'readOnly':'hold',
				colspan		: 2,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.issuerequestno" default="출고요청번호"/>',
				name		: 'OUTSTOCK_BARCODE',
				xtype		: 'uniTextfield',
				readOnly	: false,
				fieldStyle	: 'IME-MODE: inactive',				//IE에서만 적용 됨
//				autoCreate	: {tag: 'input', type: 'text', size: '20', style :'IME-MODE:DISABLED' ,autocomplete: 'off', maxlength: '8'},
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					},
					specialkey:function(field, event)	{
						if(event.getKey() == event.ENTER) {
							var newValue = panelResult.getValue('OUTSTOCK_BARCODE');
							var whCode	 = panelResult.getValue('WH_CODE');
							if(Ext.isEmpty(whCode)) {		//출고창고 필수 체크
								alert('<t:message code="system.message.purchase.message015" default="출고창고를 입력하십시오."/>');			//출고창고를 입력하십시오.
								panelResult.setValue('OUTSTOCK_BARCODE', '');
								panelResult.getField('WH_CODE').focus();
								return false;
							}
							if(!Ext.isEmpty(newValue)) {
								Ext.getBody().mask('<t:message code="system.label.purchase.loading" default="로딩중..."/>','loading-indicator');
								masterGrid.focus();
								fnEnterOutStockBarcode(newValue);
								panelResult.setValue('OUTSTOCK_BARCODE', '');
							}
						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.barcode" default="바코드"/>',
				name		: 'BARCODE',
				xtype		: 'uniTextfield',
				readOnly	: false,
				fieldStyle	: 'IME-MODE: inactive',				//IE에서만 적용 됨
	//			autoCreate	: {tag: 'input', type: 'text', size: '20', style :'IME-MODE:DISABLED' ,autocomplete: 'off', maxlength: '8'},
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					},
					specialkey:function(field, event)	{
						//반품가능요청 참조일 경우,
						if(event.getKey() == event.ENTER) {
							var newValue = panelResult.getValue('BARCODE');
							if(!Ext.isEmpty(newValue)) {
								if(Ext.getCmp('rdoSelect').getChecked()[0].inputValue == '2') {
									if(!panelResult.getInvalidMessage()) return false;
										var newValue = panelResult.getValue('BARCODE');
										if(!Ext.isEmpty(newValue)) {
											masterGrid.focus();
											fnEnterBarcode2(newValue);
											panelResult.setValue('BARCODE', '');
										}

								//출고요청 참조일 경우,
								} else {
									var masterRecords = masterGrid.getStore().count();
									//masterGrid에 데이터 존재여부 확인
									if(masterRecords == 0) {
										alert('<t:message code="system.message.purchase.message010" default="출고요청 바코드를 먼저 스캔하세요."/>');
										panelResult.setValue('BARCODE', '');
										panelResult.getField('OUTSTOCK_BARCODE').focus();
										return false;
									}
									masterGrid.focus();
									fnEnterBarcode(newValue);
									panelResult.setValue('BARCODE', '');
								}
							}
						}
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: ' ',
				id: 'rdoSelect',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.issuerequestrefer" default="출고요청 참조"/>',
					width: 110,
					name: 'CONTROL_STATUS',
					inputValue: '1',
				 	holdable: 'hold',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.purchase.returnavaiablerequestrefer" default="반품가능요청 참조"/>',
					width: 150,
					name: 'CONTROL_STATUS',
					holdable: 'hold',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.CONTROL_STATUS == "1"){
							panelResult.getField('OUTSTOCK_BARCODE').setReadOnly(false);
							if(Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
								panelResult.getField('WH_CODE').focus();
							} else {
								panelResult.getField('OUTSTOCK_BARCODE').focus();
							}
						}
						if(newValue.CONTROL_STATUS == "2"){
							panelResult.getField('OUTSTOCK_BARCODE').setReadOnly(true);
							if(Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
								panelResult.getField('WH_CODE').focus();
							} else {
								panelResult.getField('BARCODE').focus();
							}
						}
					}
				}
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
						if(Ext.isDefined(item.holdable) )	{
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
			}
	});

	//조회팝업
	var releaseNoSearch = Unilite.createSearchForm('releaseNoSearchForm', {
		layout	: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	:'BOR120'
		},{
			fieldLabel		: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_INOUT_DATE',
			endFieldName	: 'TO_INOUT_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			allowBlank		: false
		},{
			fieldLabel	: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>',
			name		: 'INOUT_CODE_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B005'
		},{
			fieldLabel	: '<t:message code="system.label.purchase.issueplace" default="출고처"/>',
			name		: 'INOUT_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList')
		},{
			fieldLabel	: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList')
		},{
			fieldLabel	: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
			name		: 'INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024'
		},{
			fieldLabel	: 'Lot No',
			name		: 'LOT_NO',
			xtype		: 'uniTextfield'
		},
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			validateBlank	: false
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
			name		: 'PROJECT_NO',
			xtype		: 'uniTextfield'
		}]
	}); // createSearchForm

	//출고요청 참조
	var refSearch = Unilite.createSearchForm('refSearchForm', {
		layout	: {type: 'uniTable', columns : 4},
		trackResetOnLoad: true,
		items	: [
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				listeners		: {
					'onSelected': {},
					'onClear'	: function(type) {},
					'applyextparam': function(popup){
						popup.setExtParam({'CUSTOM_TYPE': '3'/*, 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'*/});
					}
				}
//				extParam		: {'CUSTOM_TYPE': '3'}
			}),{
				fieldLabel	: '<t:message code="system.label.purchase.issuerequestno" default="출고요청번호"/>',
				name		: 'OUTSTOCK_NUM',
				xtype		: 'uniTextfield'
			},{
				fieldLabel	: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>',
				name		: 'WKORD_NUM',
				xtype		: 'uniTextfield'
			},{
				fieldLabel	: '<t:message code="system.label.purchase.mainwarehouse" default="주창고"/>',
				name		: 'MAIN_WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList')
			},{
				fieldLabel		: '<t:message code="system.label.purchase.requestperiod" default="요청기간"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'REQ_FR_DATE',
				endFieldName	: 'REQ_TO_DATE',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today')
			},{
				fieldLabel	: '<t:message code="system.label.purchase.workcenter" default="작업장"/>',
				name		: 'WORK_SHOP_CODE',
				xtype		: 'uniCombobox',
				comboType: 'WU'
			},{
				fieldLabel	: '<t:message code="system.label.purchase.processingwarehouse" default="가공창고"/>',
				name		: 'WORK_WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList')
			},{
				fieldLabel	: 'Lot No',
				name		: 'LOT_NO',
				xtype		: 'uniTextfield'
			}
		]
	}); // createSearchForm

	//반품가능 참조
	var refSearch2 = Unilite.createSearchForm('refSearchForm2', {
		layout	: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items	: [
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				listeners		: {
					'onSelected': {},
					'onClear'	: function(type) {},
					'applyextparam': function(popup){
						popup.setExtParam({'CUSTOM_TYPE': '3'/*, 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'*/});
					}
				}
//				extParam: {'CUSTOM_TYPE': '3'}
			}),{
				fieldLabel	: '<t:message code="system.label.purchase.issuerequestno" default="출고요청번호"/>',
				name		: 'OUTSTOCK_NUM',
				xtype		: 'uniTextfield'
			},{
				fieldLabel	: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>',
				name		: 'WKORD_NUM',
				xtype		: 'uniTextfield'
			},{
				fieldLabel		: '<t:message code="system.label.purchase.requestperiod" default="요청기간"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'REQ_FR_DATE',
				endFieldName	: 'REQ_TO_DATE',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today')
			},{
				fieldLabel	: '<t:message code="system.label.purchase.workcenter" default="작업장"/>',
				name		: 'WORK_SHOP_CODE',
				xtype		: 'uniCombobox',
				comboType: 'WU'
			},{
				fieldLabel	: 'Lot No',
				name		: 'LOT_NO',
				xtype		: 'uniTextfield'
			}
		]
	}); // createSearchForm





	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('mtr202ukrvGrid1', {
		store	: directMasterStore1,
		itemId	: 'mtr202ukrvGrid1',
		layout	: 'fit',
		region	: 'center',
		flex	: 1,
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			onLoadSelectFirst	: false,
			copiedRow			: false
		},
		tbar: [{
			itemId	: 'MoveReleaseBtn',
			text	: '<div style="color: blue"><t:message code="system.label.purchase.issuerequestrefer" default="출고요청 참조"/></div>',
			handler	: function() {
				openRefSearchWindow();
			}
		},'-',{
			itemId	: 'MoveReleaseBtn2',
			text	: '<div style="color: blue"><t:message code="system.label.purchase.returnavaiablerequestrefer" default="반품가능요청 참조"/></div>',
			handler	: function() {
				openRefSearchWindow2();
			}
		}],
//		features: [ {id: 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: true },
//					{id: 'masterGridTotal',		ftype: 'uniSummary',			showSummaryRow: true} ],
		columns: [
			{dataIndex: 'REF_GUBUN'				, width: 66		, hidden: true},
			{dataIndex: 'INOUT_NUM'				, width: 66		, hidden: true},
			{dataIndex: 'INOUT_SEQ'				, width: 60		, hidden: true},
			{dataIndex: 'WH_CODE'				, width: 85},
			{dataIndex: 'WH_CELL_CODE'			, width: 110	, hidden: true},
			{dataIndex: 'INOUT_METH'			, width: 46		, hidden: true},
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width: 85},
			{dataIndex: 'DIV_CODE'				, width: 110	, hidden: true},
			{dataIndex: 'INOUT_CODE'			, width: 53		, hidden: true},
			{dataIndex: 'INOUT_CODE_DETAIL'		, width: 53		, hidden: true},
			{dataIndex: 'INOUT_NAME'			, width: 150},
			{dataIndex: 'INOUT_NAME1'			, width: 150	, hidden: true,
				'editor' : Unilite.popup('WORK_SHOP_G',{
					textFieldName	: 'TREE_NAME',
					DBtextFieldName	: 'TREE_NAME',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('INOUT_CODE'	,records[0]['TREE_CODE']);
								grdRecord.set('INOUT_NAME1'	,records[0]['TREE_NAME']);
							},
							scope: this
						},
						'onClear'	: function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							record = records[0];
							grdRecord.set('INOUT_CODE'	, '');
							grdRecord.set('INOUT_NAME1'	, '');
						},
						'applyextparam': function(popup){
							var param =  panelResult.getValues();
							popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
						}
					}
				})
			},
			{dataIndex: 'INOUT_NAME2'			, width: 150, hidden: true,
				'editor': Unilite.popup('DEPT_G',{
					autoPopup		: true,
					DBtextFieldName	: 'REQ_DEPT_CODE',
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('INOUT_CODE'	,records[0]['TREE_CODE']);
								grdRecord.set('INOUT_NAME2'	,records[0]['TREE_NAME']);

							},
							scope: this
						},
						'onClear'	: function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('INOUT_CODE'	, '');
							grdRecord.set('INOUT_NAME2'	, '');
						},
						'applyextparam' : function(popup){
							var param =  panelResult.getValues();
							popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
						}
					}
				})
			},
			{dataIndex: 'ITEM_CODE'					, width: 100,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
//					extParam		: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup		: true,
					listeners		: {
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
						'applyextparam': function(popup){
							popup.setExtParam({SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'					, width: 120,
				editor: Unilite.popup('DIV_PUMOK_G', {
//					extParam	: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
					autoPopup	: true,
					listeners	: {
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
						'onClear'	: function(type) {
							masterGrid.setItemData(null,true);
						},
						'applyextparam': function(popup){
							popup.setExtParam({SELMODEL: 'MULTI', DIV_CODE: outDivCode});
						}
					}
				})
			},
			{dataIndex: 'SPEC'						, width: 150},
			{dataIndex: 'LOT_NO'					, width: 133	, hidden: true, //hidden: gsManageLotNoYN,
				editor: Unilite.popup('LOTNO_G', {
					textFieldName	: 'LOT_CODE',
					DBtextFieldName	: 'LOT_CODE',
					validateBlank	: false,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var rtnRecord;
								Ext.each(records, function(record,i) {
									if(i==0){
										rtnRecord = masterGrid.uniOpt.currentRecord
									}else{
										rtnRecord = masterGrid.getSelectedRecord()
									}
									rtnRecord.set('LOT_NO',			record['LOT_NO']);
									rtnRecord.set('WH_CODE',		record['WH_CODE']);
									rtnRecord.set('WH_CELL_CODE',	record['WH_CELL_CODE']);
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var rtnRecord = masterGrid.uniOpt.currentRecord;
							rtnRecord.set('LOT_NO', '');
						},
						'applyextparam': function(popup){
							var record		= masterGrid.getSelectedRecord();
							var divCode		= panelResult.getValue('DIV_CODE');
							var itemCode	= record.get('ITEM_CODE');
							var itemName	= record.get('ITEM_NAME');
							var whCode		= record.get('WH_CODE');
							var whCellCode	= record.get('WH_CELL_CODE');
							var stockYN		= 'Y'
							popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode, 'S_WH_CELL_CODE': whCellCode, 'STOCK_YN': stockYN});
						}
					}
				})
			},
			{dataIndex: 'LOT_YN'					, width: 90		, hidden: true},
			{dataIndex: 'STOCK_UNIT'				, width: 66		, align: 'center'},
			{dataIndex: 'PATH_CODE'					, width: 113	, hidden: true},
			{dataIndex: 'NOT_Q'						, width: 106},
			{dataIndex: 'INOUT_Q'					, width: 106},
			{dataIndex: 'ITEM_STATUS'				, width: 80		, hidden: true},
			{dataIndex: 'ORIGINAL_Q'				, width: 93		, hidden: true},
			{dataIndex: 'PAB_STOCK_Q'				, width: 100	, hidden: usePabStockYn},
			{dataIndex: 'GOOD_STOCK_Q'				, width: 100},
			{dataIndex: 'BAD_STOCK_Q'				, width: 100},
			{dataIndex: 'BASIS_NUM'					, width: 116	, hidden: true},
			{dataIndex: 'BASIS_SEQ'					, width: 33		, hidden: true},
			{dataIndex: 'INOUT_TYPE'				, width: 33		, hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'			, width: 33		, hidden: true},
			{dataIndex: 'INOUT_DATE'				, width: 80		, hidden: true},
			{dataIndex: 'INOUT_P'					, width: 33		, hidden: true},
			{dataIndex: 'INOUT_I'					, width: 106	, hidden: true},
			{dataIndex: 'MONEY_UNIT'				, width: 106	, hidden: true},
			{dataIndex: 'INOUT_PRSN'				, width: 106	, hidden: true},
			{dataIndex: 'ACCOUNT_Q'					, width: 106	, hidden: true},
			{dataIndex: 'ACCOUNT_YNC'				, width: 106	, hidden: true},
			{dataIndex: 'ARRAY_OUTSTOCK_NUM'		, width: 120},
			{dataIndex: 'CREATE_LOC'				, width: 73		, hidden: true},
			{dataIndex: 'ARRAY_REF_WKORD_NUM'		, width: 120},
			{dataIndex: 'ORDER_NUM'					, width: 116	, hidden: true},
			{dataIndex: 'REMARK'					, flex: 1		, minWidth: 133},
			{dataIndex: 'PROJECT_NO'				, width: 133	, hidden: true},
			{dataIndex: 'SALE_DIV_CODE'				, width: 66		, hidden: true},
			{dataIndex: 'SALE_CUSTOM_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'BILL_TYPE'					, width: 66		, hidden: true},
			{dataIndex: 'SALE_TYPE'					, width: 66		, hidden: true},
			{dataIndex: 'COMP_CODE'					, width: 66		, hidden: true},
			{dataIndex: 'ARRAY_OUTSTOCK_REQ_Q'		, width: 66		, hidden: true},
			{dataIndex: 'ARRAY_OUTSTOCK_Q'			, width: 66		, hidden: true},
			{dataIndex: 'ARRAY_REMARK'				, width: 66		, hidden: true},
			{dataIndex: 'ARRAY_PROJECT_NO'			, width: 66		, hidden: true},
			{dataIndex: 'ARRAY_LOT_NO'				, width: 66		, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'			, width: 66		, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'			, width: 66		, hidden: true}
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm	= grid.getItemId();
				var store	= grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
					//store.onStoreActionEnable();
					if( barcodeStore.isDirty() ) {
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
					if(grid.getStore().getCount() > 0) {
						UniAppManager.setToolbarButtons('delete', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}

					if(gsSaveFlag) {
						UniAppManager.setToolbarButtons('save', true);
					} else {
						UniAppManager.setToolbarButtons('save', false);
					}

				});
			},
			selectionChange: function( gird, selected, eOpts )	{
				barcodeStore.clearFilter();
				if(UniAppManager.app._needSave()) {
					gsSaveFlag = true;
				} else {
					gsSaveFlag = false;
				}
				//선택된 행의 저장된 데이터만 barcodeGrid에 보여주도록 filter
				if(!Ext.isEmpty(selected)) {
					barcodeStore.filterBy(function(record){
						return record.get('ARRAY_OUTSTOCK_NUM') == selected[0].get('ARRAY_OUTSTOCK_NUM')
							&& record.get('ITEM_CODE') == selected[0].get('ITEM_CODE');
					})
				}
//				var colName = e.position.column.dataIndex;
//				if(colName == 'INOUT_NUM') {
				panelResult.getField('BARCODE').focus();
//				}
			},
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['WH_CODE', 'INOUT_Q'])){
					return false;
				}
				if (UniUtils.indexOf(e.field, 'LOT_NO')){
					if(Ext.isEmpty(e.record.data.ITEM_CODE)){
						alert('<t:message code="system.message.purchase.message028" default="품목코드를 입력 하십시오."/>');
						return false;
					}
					if(Ext.isEmpty(e.record.data.WH_CODE) && BsaCodeInfo.gsManageLotNoYN == 'Y' ){
						alert('<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>' + ':' + '<t:message code="system.message.commonJS.numberfield.blankText" default="값을 입력하세요."/>');
						return false;
					}
					if(BsaCodeInfo.gsSumTypeCell == 'Y' && Ext.isEmpty(e.record.data.WH_CELL_CODE)){
						alert('<t:message code="system.label.purchase.issuewarehousecell" default="출고창고Cell"/>' + ':' + '<t:message code="system.message.commonJS.numberfield.blankText" default="값을 입력하세요."/>');
						return false;
					}
				}

				var sInoutmeth = e.record.data.INOUT_METH;
				if(e.record.phantom){
					if(sInoutmeth == '2'){
						if(panelResult.getValue('INOUT_CODE_TYPE') == '2'){
							if(e.field=='INOUT_TYPE_DETAIL') return false;
						}else{
							if(e.field=='INOUT_TYPE_DETAIL') return true;
						}

						if (UniUtils.indexOf(e.field,[
							'WH_CODE', 'WH_CELL_CODE', 'INOUT_Q', 'INOUT_NAME1', 'INOUT_NAME2', 'ITEM_CODE', 'ITEM_NAME', 'ITEM_STATUS', 'INOUT_SEQ', 'LOT_NO', 'REMARK','PROJECT_NO', 'ORDER_NUM'])){
							return true;
						}else{
							return false;
						}
					}else{
						if(panelResult.getValue('INOUT_CODE_TYPE') == '2'){
							if(e.field=='INOUT_TYPE_DETAIL') return false;
						}else{
							if(e.field=='INOUT_TYPE_DETAIL') return true;
						}

						if (UniUtils.indexOf(e.field,[
							'WH_CODE', 'WH_CELL_CODE', 'INOUT_METH','INOUT_Q', 'ITEM_STATUS', 'REMARK'])){
							return true;
						}

						if(BsaCodeInfo.gsManageLotNoYN == 'Y'){
							if(e.field == 'LOT_NO')	return true;
						}else{
							if(e.field == 'LOT_NO') return false;
							}

						if(e.field == 'PROJECT_NO') return true;

						return false;
					}
				}else{
					return false;
//					if(panelResult.getValue('INOUT_CODE_TYPE') == '2'){
//							if(e.field=='INOUT_TYPE_DETAIL') return false;
//						}else{
//							if(e.field=='INOUT_TYPE_DETAIL') return true;
//						}
//
//					if (UniUtils.indexOf(e.field,[
//							'WH_CODE', 'WH_CELL_CODE', 'INOUT_Q', 'ITEM_STATUS', 'INOUT_SEQ', 'REMARK'])){
//							return true;
//						}
//
//					if(BsaCodeInfo.gsManageLotNoYN == 'Y') {
//							if(e.field == 'LOT_NO')	return true;
//						}else{
//							if(e.field == 'LOT_NO') return false;
//							}
//					return false;
				}
			}
		},
		disabledLinkButtons: function(b) {
			this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
			this.down('#procTool').menu.down('#issueLinkBtn').setDisabled(b);
			this.down('#procTool').menu.down('#saleLinkBtn').setDisabled(b);
		},
		setItemData: function(record, dataClear) {
			var grdRecord = this.getSelectedRecord();
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, "");
				grdRecord.set('ITEM_NAME'		, "");
				grdRecord.set('SPEC'			, "");
				grdRecord.set('STOCK_UNIT'		, "");
				grdRecord.set('LOT_NO'			, "");
				grdRecord.set('LOT_YN'			, "");
				grdRecord.set('GOOD_STOCK_Q'	, 0);
				grdRecord.set('BAD_STOCK_Q'		, 0);
				grdRecord.set('INOUT_P'			, 0);
				grdRecord.set('INOUT_I'			, 0);
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('LOT_NO'			, record['LOT_NO']);
				grdRecord.set('LOT_YN'			, record['LOT_YN']);

				if(grdRecord.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
					UniMatrl.fnStockQ_kd(grdRecord, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, grdRecord.get('DIV_CODE'), UniDate.getDbDateStr(grdRecord.get('INOUT_DATE')), grdRecord.get('ITEM_CODE'));
				}
				UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'), grdRecord.get('WH_CODE'));
			}
		},
		setRefSearchGridData:function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('COMP_CODE'			, UserInfo.compCode);
			grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
//			grdRecord.set('WORK_SHOP_CODE'		, record['WORK_SHOP_CODE']);
//			grdRecord.set('WORK_WH_CODE'		, record['WORK_WH_CODE']);
			grdRecord.set('WH_CODE'				, record['WH_CODE']);
			grdRecord.set('WH_CELL_CODE'		, record['WH_CELL_CODE']);
			if(BsaCodeInfo.gsSumTypeCell == 'Y') {
				grdRecord.set('WH_CELL_CODE'		, record['WH_CELL_CODE']);
				if(Ext.isEmpty(grdRecord.get('WH_CELL_CODE'))){
				   grdRecord.set('WH_CELL_CODE'		, panelResult.getValue('WH_CELL_CODE'));
				}
			} else {
				grdRecord.set('WH_CELL_CODE'		, '');
			}
			if(panelResult.getValue('INOUT_CODE_TYPE') == '2') {
				grdRecord.set('INOUT_METH'			, '3');
				grdRecord.set('INOUT_TYPE_DETAIL'	, '95');
				grdRecord.set('INOUT_CODE'			, record['WORK_WH_CODE']);
				grdRecord.set('INOUT_CODE_DETAIL'	, record['WORK_WH_CELL_CODE']);
				grdRecord.set('INOUT_NAME'			, record['WORK_WH_NAME']);
				grdRecord.set('INOUT_NAME1'			, record['WORK_WH_NAME']);
				grdRecord.set('INOUT_NAME2'			, record['WORK_WH_NAME']);
			} else {
				grdRecord.set('INOUT_METH'			, '1');
				grdRecord.set('INOUT_TYPE_DETAIL'	, '10');
				grdRecord.set('INOUT_CODE'			, record['WORK_SHOP_CODE']);
				grdRecord.set('INOUT_CODE_DETAIL'	, '');
				grdRecord.set('INOUT_NAME'			, record['WORK_SHOP_NAME']);
				grdRecord.set('INOUT_NAME1'			, record['WORK_SHOP_NAME']);
				grdRecord.set('INOUT_NAME2'			, record['WORK_SHOP_NAME']);
			}
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('PATH_CODE'			, record['PATH_CODE']);
//			grdRecord.set('LOT_NO'				, record['WK_LOT_NO']);
			grdRecord.set('NOT_Q'				, record['NOT_Q']);
			//바코드로 입력된 수량으르 넣기 위해 0 입력
//			grdRecord.set('INOUT_Q'				, record['NOT_Q']);
			grdRecord.set('INOUT_Q'				, 0);
			grdRecord.set('OUTSTOCK_NUM'		, record['OUTSTOCK_NUM']);
			grdRecord.set('ARRAY_OUTSTOCK_NUM'	, record['OUTSTOCK_NUM']);
			grdRecord.set('ARRAY_REF_WKORD_NUM'	, record['REF_WKORD_NUM']);
			grdRecord.set('LOT_YN'				, record['LOT_YN']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ARRAY_OUTSTOCK_REQ_Q', record['OUTSTOCK_REQ_Q']);
			grdRecord.set('ARRAY_OUTSTOCK_Q'	, record['NOT_Q']);
			grdRecord.set('ARRAY_REMARK'		, record['REMARK']);
			grdRecord.set('ARRAY_PROJECT_NO'	, record['PROJECT_NO']);
			grdRecord.set('ARRAY_LOT_NO'		, record['WK_LOT_NO']);
			grdRecord.set('ARRAY_LOT_NO'		, record['PAB_STOCK_Q']);
			UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );

		},
		setRefSearchGridData2: function(record, refFlag) {
			var grdRecord = this.getSelectedRecord();
			if(panelResult.getValue('INOUT_CODE_TYPE') == '2') {
				grdRecord.set('REF_GUBUN'			, 'R');
				grdRecord.set('COMP_CODE'			, UserInfo.compCode);
				grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
				grdRecord.set('INOUT_METH'			, '3');
				grdRecord.set('INOUT_TYPE_DETAIL'	, '95');
				grdRecord.set('INOUT_CODE'			, record['WORK_WH_CODE']);
				grdRecord.set('INOUT_CODE_DETAIL'	, record['WORK_WH_CODE']);
				grdRecord.set('INOUT_NAME'			, record['WORK_WH_NAME']);
				grdRecord.set('INOUT_NAME1'			, record['WORK_WH_NAME']);
				grdRecord.set('INOUT_NAME2'			, record['WORK_WH_NAME']);
				grdRecord.set('BASIS_NUM'			, record['OUTSTOCK_NUM']);
				grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('PATH_CODE'			, record['PATH_CODE']);
				//바코드로 입력된 수량으르 넣기 위해 0 입력
				grdRecord.set('INOUT_Q'				, 0);
				if(refFlag == '2') {
					grdRecord.set('INOUT_Q'			, record['NOTOUTSTOCK_Q']);
				}
				grdRecord.set('NOT_Q'				, record['NOT_Q']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
//				grdRecord.set('INOUT_DATE'			, record['OUTSTOCK_REQ_DATE']);
				grdRecord.set('INOUT_DATE'			, panelResult.getValue('INOUT_DATE'));
				grdRecord.set('CREATE_LOC'			, '2');
				grdRecord.set('INOUT_TYPE'			, '2');
				grdRecord.set('WH_CODE'				, record['WH_CODE']);
				if(BsaCodeInfo.gsSumTypeCell == 'Y') {
					grdRecord.set('WH_CELL_CODE'	, record['WH_CELL_CODE']);
					if(Ext.isEmpty(grdRecord.get('WH_CELL_CODE'))){
					   grdRecord.set('WH_CELL_CODE'	, panelResult.getValue('WH_CELL_CODE'));
					}
				} else {
					grdRecord.set('WH_CELL_CODE'	, '');
				}
				grdRecord.set('ITEM_STATUS'			, '1');
				grdRecord.set('ORDER_NUM'			, record['REF_WKORD_NUM']);
				grdRecord.set('LOT_NO'				, record['WK_LOT_NO']);
				grdRecord.set('ARRAY_OUTSTOCK_NUM'	, record['OUTSTOCK_NUM']);
				grdRecord.set('ARRAY_REF_WKORD_NUM'	, record['REF_WKORD_NUM']);
				grdRecord.set('ARRAY_OUTSTOCK_REQ_Q', record['NOTOUTSTOCK_Q']);
				grdRecord.set('ARRAY_OUTSTOCK_Q'	, record['NOT_Q']);
				grdRecord.set('ARRAY_REMARK'		, record['REMARK']);
				grdRecord.set('ARRAY_PROJECT_NO'	, '');
				grdRecord.set('ARRAY_LOT_NO'		, record['WK_LOT_NO']);
//				grdRecord.set('GOOD_STOCK_Q'		, record['']);  //////////////////////////////// 함수??
//				grdRecord.set('BAD_STOCK_Q'			, record['']);
//				grdRecord.set('INOUT_P'				, record['']);
//				grdRecord.set('INOUT_Q'				, record['']);
				UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );
			} else {
				grdRecord.set('COMP_CODE'			, UserInfo.compCode);
				grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
				grdRecord.set('INOUT_METH'			, '1');
				grdRecord.set('INOUT_TYPE_DETAIL'	, '10');
				grdRecord.set('INOUT_CODE'			, record['WORK_SHOP_CODE']);
				grdRecord.set('INOUT_NAME'			, record['WORK_SHOP_NAME']);
				grdRecord.set('INOUT_NAME1'			, record['WORK_SHOP_NAME']);
				grdRecord.set('INOUT_NAME2'			, record['WORK_SHOP_NAME']);
				grdRecord.set('BASIS_NUM'			, record['OUTSTOCK_NUM']);
				grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('PATH_CODE'			, record['PATH_CODE']);
				//바코드로 입력된 수량으르 넣기 위해 0 입력
				grdRecord.set('INOUT_Q'				, 0);
				if(refFlag == '2') {
					grdRecord.set('INOUT_Q'			, record['NOTOUTSTOCK_Q']);
				}
				grdRecord.set('NOT_Q'				, record['NOT_Q']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
//				grdRecord.set('INOUT_DATE'			, record['OUTSTOCK_REQ_DATE']);
				grdRecord.set('INOUT_DATE'			, panelResult.getValue('INOUT_DATE'));
				grdRecord.set('CREATE_LOC'			, '2');
				grdRecord.set('INOUT_TYPE'			, '2');
				grdRecord.set('WH_CODE'				, record['WH_CODE']);
				if(BsaCodeInfo.gsSumTypeCell == 'Y') {
					grdRecord.set('WH_CELL_CODE'	, record['WH_CELL_CODE']);
				} else {
					grdRecord.set('WH_CELL_CODE'	, '');
				}
				grdRecord.set('ITEM_STATUS'			, '1');
				grdRecord.set('ORDER_NUM'			, record['REF_WKORD_NUM']);
				grdRecord.set('LOT_NO'				, record['WK_LOT_NO']);
				grdRecord.set('ARRAY_OUTSTOCK_NUM'	, record['OUTSTOCK_NUM']);
				grdRecord.set('ARRAY_REF_WKORD_NUM'	, record['REF_WKORD_NUM']);
				grdRecord.set('ARRAY_OUTSTOCK_REQ_Q', record['NOTOUTSTOCK_Q']);
				grdRecord.set('ARRAY_OUTSTOCK_Q'	, record['NOT_Q']);
				grdRecord.set('ARRAY_REMARK'		, record['REMARK']);
				grdRecord.set('ARRAY_PROJECT_NO'	, '');
				grdRecord.set('ARRAY_LOT_NO'		, record['WK_LOT_NO']);
//				grdRecord.set('INOUT_Q'				, 0);
//				grdRecord.set('GOOD_STOCK_Q'		, 0);  //////////////////////////////// 함수??
//				grdRecord.set('BAD_STOCK_Q'			, 0);
//				grdRecord.set('INOUT_P'				, 0);
				UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );

			}
		}

	});//End of var masterGrid = Unilite.createGrid('mtr202ukrvGrid1', {

	//조회 그리드
	var releaseNoMasterGrid = Unilite.createGrid('mtr202ukrvReleaseNoMasterGrid', {
		store	: releaseNoMasterStore,
		layout	: 'fit',
		uniOpt	:{
			expandLastColumn: false,
			useRowNumberer: false
		},
		columns:  [
				{ dataIndex: 'WH_CODE'			, width:120},
				{ dataIndex: 'WH_CELL_CODE'		, width:120,hidden:true},
				{ dataIndex: 'WH_CELL_NAME'		, width:120,hidden:true},
				{ dataIndex: 'INOUT_DATE'		, width:93},
				{ dataIndex: 'INOUT_CODE_TYPE'	, width:120},
				{ dataIndex: 'INOUT_NAME'		, width:120},
				{ dataIndex: 'INOUT_PRSN'		, width:100},
				{ dataIndex: 'INOUT_NUM'		, width:120},
				{ dataIndex: 'DIV_CODE'			, width:86},
				{ dataIndex: 'LOT_NO'			, width:86},
				{ dataIndex: 'PROJECT_NO'		, width:86},
				{ dataIndex: 'ITEM_CODE'		, width:100},
				{ dataIndex: 'ITEM_NAME'		, width:133}
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				releaseNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record)	{
			if(Ext.isEmpty(record))	{
				record = this.getSelectedRecord();
			}
			panelResult.setValues({
				'DIV_CODE'			: record.get('DIV_CODE'),
				'INOUT_NUM'			: record.get('INOUT_NUM'),
				'INOUT_CODE_TYPE'	: record.get('INOUT_CODE_TYPE'),
				'WH_CODE'			: record.get('WH_CODE'),
				'INOUT_DATE'		: record.get('INOUT_DATE')
			});
		}
	});

	//출고요청 참조 그리드
	var refSearchGrid = Unilite.createGrid('mtr202ukrvRefSearchGrid', {
		store	: refSearchMasterStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick: false }),
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false,
			onLoadSelectFirst	: false
		},
		columns:  [
			{ dataIndex: 'CHOICE'				, width:40, hidden: true},
			{ dataIndex: 'COMP_CODE'			, width:66, hidden: true},
			{ dataIndex: 'DIV_CODE'				, width:66, hidden: true},
			{ dataIndex: 'WORK_SHOP_CODE'		, width:46, hidden: true},
			{ dataIndex: 'OUTSTOCK_NUM'			, width:93},
			{ dataIndex: 'WORK_SHOP_NAME'		, width:100},
			{ dataIndex: 'WORK_WH_CODE'			, width:66, hidden: true},
			{ dataIndex: 'WORK_WH_NAME'			, width:100, hidden: true},
			{ dataIndex: 'WORK_WH_CELL_CODE'	, width:100, hidden: gsSumTypeCell, store: Ext.data.StoreManager.lookup('whCellList')},
			{ dataIndex: 'WORK_WH_CELL_NAME'	, width:100, hidden: true},
			{ dataIndex: 'ITEM_CODE'			, width:100},
			{ dataIndex: 'ITEM_NAME'			, width:200},
			{ dataIndex: 'SPEC'					, width:120},
			{ dataIndex: 'STOCK_UNIT'			, width:66, hidden: true},
			{ dataIndex: 'PATH_CODE'			, width:113},
			{ dataIndex: 'OUTSTOCK_REQ_DATE'	, width:80},
			{ dataIndex: 'OUTSTOCK_REQ_Q'		, width:80},
			{ dataIndex: 'OUTSTOCK_Q'			, width:80, hidden: true},
			{ dataIndex: 'NOT_Q'				, width:80},
			{ dataIndex: 'STOCK_Q'				, width:80, hidden: true},
			{ dataIndex: 'PAB_STOCK_Q'			, width:80},
			{ dataIndex: 'GOOD_STOCK_Q'			, width:80},
			{ dataIndex: 'BAD_STOCK_Q'			, width:80, hidden: true},
			{ dataIndex: 'AVERAGE_P'			, width:80, hidden: true},
			{ dataIndex: 'MAIN_WH_CODE'			, width:66, hidden: true},
			{ dataIndex: 'MAIN_WH_NAME'			, width:100},
			{ dataIndex: 'CONTROL_STATUS'		, width:40, hidden: true},
			{ dataIndex: 'CANCEL_Q'				, width:40, hidden: true},
			{ dataIndex: 'REMARK'				, width:100},
			{ dataIndex: 'PROJECT_NO'			, width:100},
			{ dataIndex: 'WH_CODE'				, width:66, hidden: true},
			{ dataIndex: 'WH_CELL_CODE'			, width:66, hidden: true},
			{ dataIndex: 'REF_WKORD_NUM'		, width:93},
			{ dataIndex: 'WK_LOT_NO'			, width:100},
			{ dataIndex: 'WK_REMARK'			, width:100},
			{ dataIndex: 'WK_PROJECT_NO'		, width:100},
			{ dataIndex: 'PROD_ITEM_CODE'		, width:100},
			{ dataIndex: 'PROD_ITEM_NAME'		, width:120},
			{ dataIndex: 'LOT_YN'				, width:120, hidden: true}
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function(outStockBarcode)	{
			var records = this.getSelectedRecords();
			if(!Ext.isEmpty(outStockBarcode)) {				//출고요청번호 바코드 입력 시,
				records = outStockBarcode;
			}
			Ext.each(records, function(record,i) {
				UniAppManager.app.onNewDataButtonDown(true);
				if(!Ext.isEmpty(outStockBarcode)) {			//출고요청번호 바코드 입력 시,
					masterGrid.setRefSearchGridData(record);

				} else {
					masterGrid.setRefSearchGridData(record.data);
				}
			});
			this.getStore().remove(records);
			directMasterStore1.sort([
							  {property: 'COMP_CODE'		, direction: 'ASC'	, mode: 'multi'}
							, {property: 'DIV_CODE'			, direction: 'ASC'	, mode: 'multi'}
							, {property: 'WORK_SHOP_CODE'	, direction: 'DESC'	, mode: 'multi'}
							, {property: 'TREE_CODE'		, direction: 'ASC'	, mode: 'multi'}
							, {property: 'ITEM_CODE'		, direction: 'ASC'	, mode: 'multi'}
							, {property: 'PATH_CODE'		, direction: 'ASC'	, mode: 'multi'}
			]);
		}
	});

	//반품가능 참조 그리드
	var refSearchGrid2 = Unilite.createGrid('mtr202ukrvRefSearchGrid2', {
		store	: refSearchMasterStore2,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick: false }),
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false,
			onLoadSelectFirst	: false
		},
		columns:  [
			{ dataIndex: 'CHOICE'				, width:40, hidden: true},
			{ dataIndex: 'COMP_CODE'			, width:66, hidden: true},
			{ dataIndex: 'DIV_CODE'				, width:66, hidden: true},
			{ dataIndex: 'WORK_SHOP_CODE'		, width:46, hidden: true},
			{ dataIndex: 'WORK_SHOP_NAME'		, width:100},
			{ dataIndex: 'WORK_WH_CODE'			, width:46, hidden: true},
			{ dataIndex: 'WORK_WH_NAME'			, width:100, hidden: true},
			{ dataIndex: 'OUTSTOCK_REQ_DATE'	, width:80},
			{ dataIndex: 'ITEM_CODE'			, width:100},
			{ dataIndex: 'ITEM_NAME'			, width:120},
			{ dataIndex: 'SPEC'					, width:120},
			{ dataIndex: 'STOCK_UNIT'			, width:66, hidden: true},
			{ dataIndex: 'PATH_CODE'			, width:113},
			{ dataIndex: 'NOTOUTSTOCK_Q'		, width:80},
			{ dataIndex: 'OUTSTOCK_Q'			, width:80, hidden: true},
			{ dataIndex: 'NOT_Q'				, width:80},
			{ dataIndex: 'STOCK_Q'				, width:80},
			{ dataIndex: 'OUTSTOCK_NUM'			, width:93},
			{ dataIndex: 'CONTROL_STATUS'		, width:40, hidden: true},
			{ dataIndex: 'CANCEL_Q'				, width:40, hidden: true},
			{ dataIndex: 'REMARK'				, width:40, hidden: true},
			{ dataIndex: 'WH_CODE'				, width:66, hidden: true},
			{ dataIndex: 'WH_CELL_CODE'			, width:66, hidden: true},
			{ dataIndex: 'REF_WKORD_NUM'		, width:93},
			{ dataIndex: 'WK_LOT_NO'			, width:80}
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function()	{
			var records = this.getSelectedRecords();

			Ext.each(records, function(record,i) {
				panelResult.setValue('OUTSTOCK_NUM', record.data.OUTSTOCK_NUM);
				UniAppManager.app.onNewDataButtonDown(true);
				masterGrid.setRefSearchGridData2(record.data);
			});
			this.getStore().remove(records);
		}
	});

	//바코드 관련 Grid
	var barcodeGrid = Unilite.createGrid('mtr202ukrvBarcodeGrid', {
		store	: barcodeStore,
		itemId	: 'mtr202ukrvBarcodeGrid',
		layout	: 'fit',
		region	: 'south',
		split	: true,
		flex	: 0.5,
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: true,
			onLoadSelectFirst	: false,
			userToolbar			: false,
			copiedRow			: true
		},
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false},
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: false} ],
		columns: [
			{dataIndex: 'INOUT_NUM'				, width: 66		, hidden: true},
			{dataIndex: 'INOUT_SEQ'				, width: 60		, hidden: true},
			{dataIndex: 'WH_CELL_CODE'			, width: 110	, hidden: true},
			{dataIndex: 'INOUT_METH'			, width: 46		, hidden: true},
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width: 85		, hidden: true},
			{dataIndex: 'DIV_CODE'				, width: 110	, hidden: true},
			{dataIndex: 'INOUT_CODE'			, width: 53		, hidden: true},
			{dataIndex: 'INOUT_CODE_DETAIL'		, width: 53		, hidden: true},
			{dataIndex: 'INOUT_NAME'			, width: 150	, hidden: true},
			{dataIndex: 'INOUT_NAME1'			, width: 150	, hidden: true},
			{dataIndex: 'INOUT_NAME2'			, width: 150	, hidden: true},
			{dataIndex: 'ITEM_CODE'				, width: 100},
			{dataIndex: 'ITEM_NAME'				, width: 120},
			{dataIndex: 'SPEC'					, width: 150},
			{dataIndex: 'STOCK_UNIT'			, width: 66		, align: 'center'},
			{dataIndex: 'INOUT_Q'				, width: 106},
			{dataIndex: 'LOT_NO'				, width: 133	,
				editor: Unilite.popup('LOTNO_G', {
					textFieldName	: 'LOT_CODE',
					DBtextFieldName	: 'LOT_CODE',
					validateBlank	: false,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var rtnRecord;
								Ext.each(records, function(record,i) {
									if(i==0){
										rtnRecord = masterGrid.uniOpt.currentRecord
									}else{
										rtnRecord = masterGrid.getSelectedRecord()
									}
									rtnRecord.set('LOT_NO',			record['LOT_NO']);
									rtnRecord.set('WH_CODE',		record['WH_CODE']);
									rtnRecord.set('WH_CELL_CODE',	record['WH_CELL_CODE']);
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var rtnRecord = masterGrid.uniOpt.currentRecord;
							rtnRecord.set('LOT_NO', '');
						},
						'applyextparam': function(popup){
							var record		= masterGrid.getSelectedRecord();
							var divCode		= panelResult.getValue('DIV_CODE');
							var itemCode	= record.get('ITEM_CODE');
							var itemName	= record.get('ITEM_NAME');
							var whCode		= record.get('WH_CODE');
							var whCellCode	= record.get('WH_CELL_CODE');
							var stockYN		= 'Y'
							popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode, 'S_WH_CELL_CODE': whCellCode, 'STOCK_YN': stockYN});
						}
					}
				})
			},
			{dataIndex: 'WH_CODE'				, width: 85		, hidden: false},
			{dataIndex: 'LOT_YN'				, width: 90		, hidden: true},
			{dataIndex: 'PATH_CODE'				, width: 113	, hidden: true},
			{dataIndex: 'NOT_Q'					, width: 106	, hidden: true},
			{dataIndex: 'ITEM_STATUS'			, width: 80		, hidden: true},
			{dataIndex: 'ORIGINAL_Q'			, width: 93		, hidden: true},
			{dataIndex: 'PAB_STOCK_Q'			, width: 100	, hidden: true},
			{dataIndex: 'GOOD_STOCK_Q'			, width: 100	, hidden: true},
			{dataIndex: 'BAD_STOCK_Q'			, width: 100	, hidden: true},
			{dataIndex: 'BASIS_NUM'				, width: 116	, hidden: true},
			{dataIndex: 'BASIS_SEQ'				, width: 33		, hidden: true},
			{dataIndex: 'INOUT_TYPE'			, width: 33		, hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'		, width: 33		, hidden: true},
			{dataIndex: 'INOUT_DATE'			, width: 33		, hidden: true},
			{dataIndex: 'INOUT_P'				, width: 33		, hidden: true},
			{dataIndex: 'INOUT_I'				, width: 106	, hidden: true},
			{dataIndex: 'MONEY_UNIT'			, width: 106	, hidden: true},
			{dataIndex: 'INOUT_PRSN'			, width: 106	, hidden: true},
			{dataIndex: 'ACCOUNT_Q'				, width: 106	, hidden: true},
			{dataIndex: 'ACCOUNT_YNC'			, width: 106	, hidden: true},
			{dataIndex: 'ARRAY_OUTSTOCK_NUM'	, width: 100	, hidden: true},
			{dataIndex: 'CREATE_LOC'			, width: 73		, hidden: true},
			{dataIndex: 'ARRAY_REF_WKORD_NUM'	, width: 100	, hidden: true},
			{dataIndex: 'ORDER_NUM'				, width: 116	, hidden: true},
			{dataIndex: 'REMARK'				, width: 133	, hidden: true},
			{dataIndex: 'PROJECT_NO'			, width: 133	, hidden: true},
			{dataIndex: 'SALE_DIV_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'SALE_CUSTOM_CODE'		, width: 66		, hidden: true},
			{dataIndex: 'BILL_TYPE'				, width: 66		, hidden: true},
			{dataIndex: 'SALE_TYPE'				, width: 66		, hidden: true},
			{dataIndex: 'COMP_CODE'				, width: 66		, hidden: true},
			{dataIndex: 'ARRAY_OUTSTOCK_REQ_Q'	, width: 66		, hidden: true},
			{dataIndex: 'ARRAY_OUTSTOCK_Q'		, width: 66		, hidden: true},
			{dataIndex: 'ARRAY_REMARK'			, width: 66		, hidden: true},
			{dataIndex: 'ARRAY_PROJECT_NO'		, width: 66		, hidden: true},
			{dataIndex: 'ARRAY_LOT_NO'			, width: 66		, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'		, width: 66		, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 66		, hidden: true}
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm	= grid.getItemId();
				var store	= grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
					//store.onStoreActionEnable();
					if( barcodeStore.isDirty() ) {
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
					if(grid.getStore().getCount() > 0) {
						UniAppManager.setToolbarButtons('delete', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
				});
			},
			beforeedit	: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, 'INOUT_Q')){
					return true;
				} else {
					return false;
				}
			}
		},
		setRefSearchGridData2: function(record) {
			var grdRecord = this.getSelectedRecord();
			if(panelResult.getValue('INOUT_CODE_TYPE') == '2') {
				grdRecord.set('REF_GUBUN'			, 'R');
				grdRecord.set('COMP_CODE'			, UserInfo.compCode);
				grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
				grdRecord.set('INOUT_METH'			, '3');
				grdRecord.set('INOUT_TYPE_DETAIL'	, '95');
				grdRecord.set('INOUT_CODE'			, record['WORK_WH_CODE']);
				grdRecord.set('INOUT_CODE_DETAIL'	, record['WORK_WH_CODE']);
				grdRecord.set('INOUT_NAME'			, record['WORK_WH_NAME']);
				grdRecord.set('INOUT_NAME1'			, record['WORK_WH_NAME']);
				grdRecord.set('INOUT_NAME2'			, record['WORK_WH_NAME']);
				grdRecord.set('BASIS_NUM'			, record['OUTSTOCK_NUM']);
				grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('PATH_CODE'			, record['PATH_CODE']);
				grdRecord.set('INOUT_Q'				, record['NOTOUTSTOCK_Q']);
				grdRecord.set('NOT_Q'				, record['NOT_Q']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
//				grdRecord.set('INOUT_DATE'			, record['OUTSTOCK_REQ_DATE']);
				grdRecord.set('INOUT_DATE'			, panelResult.getValue('INOUT_DATE'));
				grdRecord.set('CREATE_LOC'			, '2');
				grdRecord.set('INOUT_TYPE'			, '2');
				grdRecord.set('WH_CODE'				, record['WH_CODE']);
				if(BsaCodeInfo.gsSumTypeCell == 'Y') {
					grdRecord.set('WH_CELL_CODE'	, record['WH_CELL_CODE']);
					if(Ext.isEmpty(grdRecord.get('WH_CELL_CODE'))){
					   grdRecord.set('WH_CELL_CODE'	, panelResult.getValue('WH_CELL_CODE'));
					}
				} else {
					grdRecord.set('WH_CELL_CODE'	, '');
				}
				grdRecord.set('ITEM_STATUS'			, '1');
				grdRecord.set('ORDER_NUM'			, record['REF_WKORD_NUM']);
				grdRecord.set('LOT_NO'				, record['WK_LOT_NO']);
				grdRecord.set('ARRAY_OUTSTOCK_NUM'	, record['OUTSTOCK_NUM']);
				grdRecord.set('ARRAY_REF_WKORD_NUM'	, record['REF_WKORD_NUM']);
				grdRecord.set('ARRAY_OUTSTOCK_REQ_Q', record['NOTOUTSTOCK_Q']);
				grdRecord.set('ARRAY_OUTSTOCK_Q'	, record['NOT_Q']);
				grdRecord.set('ARRAY_REMARK'		, record['REMARK']);
				grdRecord.set('ARRAY_PROJECT_NO'	, '');
				grdRecord.set('ARRAY_LOT_NO'		, record['WK_LOT_NO']);
				UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );

				panelResult.getField('BARCODE').focus();

			} else {
				grdRecord.set('COMP_CODE'			, UserInfo.compCode);
				grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
				grdRecord.set('INOUT_METH'			, '1');
				grdRecord.set('INOUT_TYPE_DETAIL'	, '10');
				grdRecord.set('INOUT_CODE'			, record['WORK_SHOP_CODE']);
				grdRecord.set('INOUT_NAME'			, record['WORK_SHOP_NAME']);
				grdRecord.set('INOUT_NAME1'			, record['WORK_SHOP_NAME']);
				grdRecord.set('INOUT_NAME2'			, record['WORK_SHOP_NAME']);
				grdRecord.set('BASIS_NUM'			, record['OUTSTOCK_NUM']);
				grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('PATH_CODE'			, record['PATH_CODE']);
				grdRecord.set('INOUT_Q'				, record['NOTOUTSTOCK_Q']);
				grdRecord.set('NOT_Q'				, record['NOT_Q']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
//				grdRecord.set('INOUT_DATE'			, record['OUTSTOCK_REQ_DATE']);
				grdRecord.set('INOUT_DATE'			, panelResult.getValue('INOUT_DATE'));
				grdRecord.set('CREATE_LOC'			, '2');
				grdRecord.set('INOUT_TYPE'			, '2');
				grdRecord.set('WH_CODE'				, record['WH_CODE']);
				if(BsaCodeInfo.gsSumTypeCell == 'Y') {
					grdRecord.set('WH_CELL_CODE'	, record['WH_CELL_CODE']);
				} else {
					grdRecord.set('WH_CELL_CODE'	, '');
				}
				grdRecord.set('ITEM_STATUS'			, '1');
				grdRecord.set('ORDER_NUM'			, record['REF_WKORD_NUM']);
				grdRecord.set('LOT_NO'				, record['WK_LOT_NO']);
				grdRecord.set('ARRAY_OUTSTOCK_NUM'	, record['OUTSTOCK_NUM']);
				grdRecord.set('ARRAY_REF_WKORD_NUM'	, record['REF_WKORD_NUM']);
				grdRecord.set('ARRAY_OUTSTOCK_REQ_Q', record['NOTOUTSTOCK_Q']);
				grdRecord.set('ARRAY_OUTSTOCK_Q'	, record['NOT_Q']);
				grdRecord.set('ARRAY_REMARK'		, record['REMARK']);
				grdRecord.set('ARRAY_PROJECT_NO'	, '');
				grdRecord.set('ARRAY_LOT_NO'		, record['WK_LOT_NO']);
				UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );

				panelResult.getField('BARCODE').focus();
			}
		}
	});





	//조회 팝업
	function openSearchInfoWindow() {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.purchase.issuenosearch" default="출고번호검색"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [releaseNoSearch, releaseNoMasterGrid], //releaseNomasterGrid],
				tbar	: ['->',
					{
						itemId	: 'saveBtn',
						text	: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler	: function() {
							releaseNoMasterStore.loadStoreRecords();
						},
						disabled: false
					}, {
						itemId	: 'ReleaseNoCloseBtn',
						text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler	: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						releaseNoSearch.clearForm();
						releaseNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						releaseNoSearch.clearForm();
						releaseNoMasterGrid.reset();
					},
					show: function( panel, eOpts )	{
					 	releaseNoSearch.setValue('DIV_CODE'			, panelResult.getValue('DIV_CODE'));
					 	releaseNoSearch.setValue('INOUT_CODE_TYPE'	, panelResult.getValue('INOUT_CODE_TYPE'));
				 		releaseNoSearch.setValue('FR_INOUT_DATE'	, UniDate.get('startOfMonth', panelResult.getValue('INOUT_DATE')));
				 		releaseNoSearch.setValue('TO_INOUT_DATE'	, panelResult.getValue('INOUT_DATE'));
				/*	 	releaseNoSearch.setValue('DIV_CODE'			, panelResult.getValue('DIV_CODE'));
						releaseNoSearch.setValue('ORDER_PRSN'		, panelResult.getValue('ORDER_PRSN'));
						releaseNoSearch.setValue('CUSTOM_CODE'		, panelResult.getValue('CUSTOM_CODE'));
						releaseNoSearch.setValue('CUSTOM_NAME'		, panelResult.getValue('CUSTOM_NAME'));
						releaseNoSearch.setValue('ORDER_TYPE'		, panelResult.getValue('ORDER_TYPE'));
						releaseNoSearch.setValue('FR_ORDER_DATE'	, UniDate.get('startOfMonth', panelResult.getValue('ORDER_DATE')));
						releaseNoSearch.setValue('TO_ORDER_DATE'	, panelResult.getValue('ORDER_DATE'));*/
					}
				}
			})
		}
		SearchInfoWindow.show();
		SearchInfoWindow.center();
	}

	//출고요청 참조 팝업
	function openRefSearchWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;

		if(!RefSearchWindow) {
			RefSearchWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.purchase.issuerequestrefer" default="출고요청 참조"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [refSearch, refSearchGrid],
				tbar	: ['->',
					{
						itemId 	: 'saveBtn',
						text	: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler	: function() {
							refSearchMasterStore.loadStoreRecords();
						},
						disabled: false
					},{ itemId	: 'confirmBtn',
						text	: '<t:message code="system.label.purchase.apply" default="적용"/>',
						handler	: function() {
							refSearchGrid.returnData();
						},
						disabled: false
					},{ itemId	: 'confirmCloseBtn',
						text	: '<t:message code="system.label.purchase.afterapplyclose" default="적용 후 닫기"/>',
						handler	: function() {
							refSearchGrid.returnData();
							RefSearchWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					},{
						itemId	: 'closeBtn',
						text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler	: function() {
							RefSearchWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						refSearch.clearForm();
						refSearchGrid.reset();
					},
					beforeclose: function( panel, eOpts )   {
						refSearch.clearForm();
						refSearchGrid.reset();
					},
					beforeshow: function( panel, eOpts )  {
						refSearch.setValue('REQ_TO_DATE', UniDate.get('today'));
						refSearch.setValue('REQ_FR_DATE', UniDate.get('startOfMonth', refSearch.getValue('REQ_TO_DATE')));
					}
				}
			})
		}
		RefSearchWindow.show();
		RefSearchWindow.center();
	}

	//반품가능 참조 팝업
	function openRefSearchWindow2() {
		if(!UniAppManager.app.checkForNewDetail()) return false;

		if(!RefSearchWindow2) {
			RefSearchWindow2 = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.purchase.returnavaiablerequestrefer" default="반품가능요청 참조"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [refSearch2, refSearchGrid2],
				tbar	: ['->',
					{
						itemId	: 'saveBtn',
						text	: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler	: function() {
							refSearchMasterStore2.loadStoreRecords();
						},
						disabled: false
					},{ itemId	: 'confirmBtn',
						text	: '<t:message code="system.label.purchase.apply" default="적용"/>',
						handler	: function() {
							refSearchGrid2.returnData();
						},
						disabled: false
					},{ itemId	: 'confirmCloseBtn',
						text	: '<t:message code="system.label.purchase.afterapplyclose" default="적용 후 닫기"/>',
						handler	: function() {
							refSearchGrid2.returnData();
							RefSearchWindow2.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					},{
						itemId	: 'closeBtn',
						text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler	: function() {
							RefSearchWindow2.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						refSearch2.clearForm();
						refSearchGrid2.reset();
					},
					beforeclose: function( panel, eOpts ) {
						refSearch2.clearForm();
						refSearchGrid2.reset();
					},
					beforeshow: function( panel, eOpts ) {
					}
				}
			})
		}
		RefSearchWindow2.show();
		RefSearchWindow2.center();
	}


	//경고창
	var alertSearch = Unilite.createSearchForm('alertSearch', {
		layout	: {type : 'uniTable', columns : 1
		, tdAttrs: {width: '100%', align : 'center', style: 'background-color: #dfe8f6;'}		//cfd9e7
		},
		items	:[{
			xtype	: 'component',
			itemId	: 'TEXT_TEST',
			width	: 330,
			height	: 50,
			html	: '',
			style	: {
				marginTop	: '3px !important',
				font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
            }
		},{
			xtype	: 'container',
			padding	: '0 0 0 0',
			align	: 'center',
			items	: [{
				xtype	: 'button',
				text	: '<t:message code="system.label.purchase.confirm" default="확인"/>',
				width	: 80,
				handler	: function() {
					alertWindow.hide();
				},
				disabled: false
			}]
		}]
	});
	function openAlertWindow() {
		if(!alertWindow) {
			alertWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="unilite.msg.warnTitle" default="경고"/>',
				width	: 350,
				height	: 120,
				layout	: {type:'vbox', align:'stretch'},
				items	: [alertSearch],
				listeners : {
					beforehide: function(me, eOpt) {
						alertSearch.clearForm();
					},
					beforeclose: function( panel, eOpts ) {
						alertSearch.clearForm();
					},
					beforeshow: function( panel, eOpts ) {
						alertSearch.down('#TEXT_TEST').setHtml(gsText);
					}/*,
					specialkey:function(field, event)	{
						if(event.getKey() == event.ENTER) {
							beep();
						}
					}*/
				}
			})
		}
		alertWindow.center();
		alertWindow.show();
	}




	Unilite.Main({
		id			: 'mtr202ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items:[
				masterGrid, panelResult, barcodeGrid
			]
		}],
		fnInitBinding: function() {
			this.setDefault();
		},
		onQueryButtonDown: function() {
			var inoutNo = panelResult.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow()
			} else {
				if(panelResult.setAllFieldsReadOnly(true) == false){
					return false;
				}
				if(panelResult.setAllFieldsReadOnly(true) == false){
					return false;
				}
				directMasterStore1.loadStoreRecords();
				barcodeStore.clearFilter();
				barcodeStore.loadStoreRecords();
			};
		},
		onNewDataButtonDown: function(isReff, refFlag)	{
			if(panelResult.getValue("INOUT_CODE_TYPE") == '2' && !isReff) {
				alert('<t:message code="system.message.purchase.message011" default="출고처구분이 창고일경우에는 참조만 가능합니다."/>');
				return false;
			}
			if(BsaCodeInfo.gsAutoType == "N" && Ext.isEmpty(panelResult.getValue("OUTSTOCK_NUM"))){
				alert('<t:message code="system.message.purchase.message012" default="출고번호를 입력하십시오."/>');
				return false;
			}

			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			 var inoutNum = panelResult.getValue('INOUT_NUM');

			 var seq = directMasterStore1.max('INOUT_SEQ');
			 if(refFlag == '2') {							//반품가능요청 참조 바코드 입력일 경우
			 	seq = barcodeStore.max('INOUT_SEQ');
			 }
			 if(!seq){
			 	seq = 1;
			 }else{
			 	seq += 1;
			 }

			 var inoutType		= '2';
			 var inoutCodeType	= panelResult.getValue('INOUT_CODE_TYPE');
			 var whCode			= panelResult.getValue('WH_CODE');
			 var whCellCode		= panelResult.getValue('WH_CELL_CODE');
			 var inoutDate		= panelResult.getValue('INOUT_DATE');
			 var notQ			= '0';
			 var goodStockQ		= '0';
			 var badStockQ		= '0';
			 var inoutQ			= '0';
			 var inoutMeth		= '2';
			 var divCode		= panelResult.getValue('DIV_CODE');
			 var createLoc		= '2';
			 var inoutPrsn		= panelResult.getValue('INOUT_PRSN');
			 var itemStatus		= '1';
			 var originalQ		= '0';
			 var inoutTypeDetail= '10';	//gsInoutTypeDetail	??
			 /*if(BsaCodeInfo.gsSumTypeCell == 'Y'){
			 	whCellCode = panelResult.getValue('WH_CELL_CODE');
			 }*/
			 var saleDivCode	= '*';
			 var saleCustomCode	= '*';
			 var saleType		= '*';
			 var billType		= '*';
			 var compCode		= UserInfo.compCode;

			 var r = {
				INOUT_NUM			: inoutNum,
				INOUT_SEQ			: seq,
				INOUT_TYPE			: inoutType,
				INOUT_CODE_TYPE		: inoutCodeType,
				WH_CODE				: whCode,
				WH_CELL_CODE		: whCellCode,
				INOUT_DATE			: inoutDate,
				NOT_Q				: notQ,
				GOOD_STOCK_Q		: goodStockQ,
				BAD_STOCK_Q			: badStockQ,
				INOUT_Q				: inoutQ,
				INOUT_METH			: inoutMeth,
				DIV_CODE			: divCode,
				CREATE_LOC			: createLoc,
				INOUT_PRSN			: inoutPrsn,
				ITEM_STATUS			: itemStatus,
				ORIGINAL_Q			: originalQ,
				INOUT_TYPE_DETAIL	: inoutTypeDetail,
				SALE_DIV_CODE		: saleDivCode,
			 	SALE_CUSTOM_CODE	: saleCustomCode,
			 	SALE_TYPE			: saleType,
				BILL_TYPE			: billType,
				COMP_CODE			: compCode
			};
			if(refFlag == '2') {							//반품가능요청 참조 바코드 입력일 경우
				barcodeGrid.createRow(r);
			} else {
				masterGrid.createRow(r);
			}

		},
		onResetButtonDown: function() {
			gsMaxInoutSeq = 0;
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			directMasterStore1.loadData({});
			barcodeStore.loadData({});
			this.fnInitBinding();
		},

		onSaveDataButtonDown: function(config) {
			barcodeStore.clearFilter();
			if(barcodeStore.isDirty()) {
				barcodeStore.saveStore();
			}
		},

		onDeleteDataButtonDown: function() {
			var selRow			= masterGrid.getSelectedRecord();
			var selRow2			= barcodeGrid.getSelectedRecord();

			if(Ext.isEmpty(selRow) && Ext.isEmpty(selRow2)) {
				alert('<t:message code="system.message.purchase.message017" default="선택된 자료가 없습니다."/>');					//선택된 자료가 없습니다.
				return false;
			}
			if(activeGridId == 'mtr202ukrvGrid1' && !Ext.isEmpty(selRow) && selRow.phantom === true)	{			//masterGrid 삭제 함수 호출
				fnDeleteDetail(selRow);

			} else if(activeGridId != 'mtr202ukrvGrid1' && !Ext.isEmpty(selRow2) && selRow2.phantom === true) {	//barcodeGrid 삭제 함수 호출
				fnBarcodeGrid(selRow, selRow2)

			} else if (confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if( activeGridId == 'mtr202ukrvGrid1' && !Ext.isEmpty(selRow)) {			//masterGrid 삭제 함수 호출
					if(BsaCodeInfo.gsInoutAutoYN == "N" && selRow.get('ACCOUNT_Q') > 0) {	//동시매출발생이 아닌 경우,매출존재체크 제외
						alert('<t:message code="system.message.purchase.message044" default="매출이 진행된 건은 수정/삭제할 수 없습니다."/>');													//매출이 진행된 건은 수정/삭제할 수 없습니다.
						return false;
					}
					if(selRow.get('SALE_C_YN') == "Y"){
						alert('<t:message code="system.message.purchase.message045" default="계산서가 마감된 건은 수정/삭제가 불가능합니다."/>');													//계산서가 마감된 건은 수정/삭제가 불가능합니다.
						return false;
					}
					fnDeleteDetail(selRow);

				} else if(activeGridId != 'mtr202ukrvGrid1' && !Ext.isEmpty(selRow2)) {		//barcodeGrid 삭제 함수 호출
					if(BsaCodeInfo.gsInoutAutoYN == "N" && selRow2.get('ACCOUNT_Q') > 0) {	//동시매출발생이 아닌 경우,매출존재체크 제외
						alert('<t:message code="system.message.purchase.message044" default="매출이 진행된 건은 수정/삭제할 수 없습니다."/>');													//매출이 진행된 건은 수정/삭제할 수 없습니다.
						return false;
					}
					if(selRow2.get('SALE_C_YN') == "Y"){
						alert('<t:message code="system.message.purchase.message045" default="계산서가 마감된 건은 수정/삭제가 불가능합니다."/>');													//계산서가 마감된 건은 수정/삭제가 불가능합니다.
						return false;
					}
					fnBarcodeGrid(selRow, selRow2)
				}
			}
		},
		//전체삭제
		onDeleteAllButtonDown: function() {
			var records1	= directMasterStore1.data.items;
			var records2	= barcodeStore.data.items;
			var records		= [].concat(records1, records2);
			var isNewData	= false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.purchase.message008" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
//						if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
//							alert(Msg.sMS042);			//마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
//							return false;
//						}
						Ext.each(records, function(record,i) {
							if(BsaCodeInfo.gsInoutAutoYN == "N" && record.get('ACCOUNT_Q') > 0) {//동시매출발생이 아닌 경우,매출존재체크 제외
								alert('<t:message code="system.message.purchase.message044" default="매출이 진행된 건은 수정/삭제할 수 없습니다."/>');		//매출이 진행된 건은 수정/삭제할 수 없습니다.
								deletable = false;
								return false;
							}
							if(record.get('SALE_C_YN') == "Y"){
								alert('<t:message code="system.message.purchase.message045" default="계산서가 마감된 건은 수정/삭제가 불가능합니다."/>');		//계산서가 마감된 건은 수정/삭제가 불가능합니다.
								deletable = false;
								return false;
							}
						});
						/*---------삭제전 로직 구현 끝-----------*/

						if(deletable){
							masterGrid.reset();
							barcodeGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				barcodeGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},

		onPrintButtonDown: function() {
			if(Ext.isEmpty(panelResult.getValue('INOUT_NUM'))){
				alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');			//출력할 자료가 없습니다.
				return false;
			}
			if(UniAppManager.app._needSave()) {
				alert('<t:message code="system.message.common.savecheck" default="먼저 저장을 하십시오"/>');			//먼저 저장 후 다시 작업하십시오.
				return false;
			}
			var reportGubun = BsaCodeInfo.gsReportGubun;
			var win;
			var param = panelResult.getValues();
			param["USER_LANG"] = UserInfo.userLang;
			param["PGM_ID"]= PGM_ID;
			param["MAIN_CODE"] = 'M030';		//자재용 공통 코드

			if(Ext.isEmpty(reportGubun) || reportGubun == 'CR'){
				param["sTxtValue2_fileTitle"]='<t:message code="system.label.purchase.materialshipmentstatement" default="자재출고내역서"/>';
				win = Ext.create('widget.CrystalReport', {
	                url: CPATH+'/matrl/mtr202crkrv.do',
	                extParam: param
	            });
			}else{
				 win = Ext.create('widget.ClipReport', {
	                url: CPATH+'/matrl/mtr202clukrv.do',
	                prgID: 'mtr202ukrv',
	                extParam: param
	            });
			}
			win.center();
			win.show();
		},
		checkForNewDetail:function() {
			return panelResult.setAllFieldsReadOnly(true);
			return panelResult.setAllFieldsReadOnly(true);
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('INOUT_DATE'		, UniDate.get('today'));
			panelResult.setValue('INOUT_CODE_TYPE'	, '2');
			panelResult.getField('rdoSelect').setValue("1");
			panelResult.getField('OUTSTOCK_BARCODE').setReadOnly(false);
			UniAppManager.setToolbarButtons(['reset','newData','print'], true);

			//Reset 버튼 클릭 시, 출고창고 포커스(필수입력이므로 바코드 전에 창고선택부터 해야 함
			panelResult.getField('WH_CODE').focus();
			panelResult.onLoadSelectText('WH_CODE');
		},
		setHiddenColumn: function() {
			if(panelResult.getValue('INOUT_CODE_TYPE') == '3') {
				masterGrid.getColumn('INOUT_NAME').setVisible(false);
				masterGrid.getColumn('INOUT_NAME1').setVisible(true);
				masterGrid.getColumn('INOUT_NAME2').setVisible(false);

			} else if(panelResult.getValue('INOUT_CODE_TYPE') == '1'){
				masterGrid.getColumn('INOUT_NAME').setVisible(false);
				masterGrid.getColumn('INOUT_NAME1').setVisible(false);
				masterGrid.getColumn('INOUT_NAME2').setVisible(true);

			} else {
				masterGrid.getColumn('INOUT_NAME').setVisible(true);
				masterGrid.getColumn('INOUT_NAME1').setVisible(false);
				masterGrid.getColumn('INOUT_NAME2').setVisible(false);
			}
		},
		cbStockQ: function(provider, params) {
			var rtnRecord	= params.rtnRecord;
			var goodStockQ	= Unilite.nvl(provider['GOOD_STOCK_Q'], 0);
			var badtockQ	= Unilite.nvl(provider['BAD_STOCK_Q'], 0);
			var inoutP		= Unilite.nvl(provider['AVERAGE_P'], 0);
			var inoutI		= Unilite.nvl(provider['AVERAGE_P'], 0) * rtnRecord.get('INOUT_Q');

			rtnRecord.set('GOOD_STOCK_Q'	, goodStockQ);
			rtnRecord.set('BAD_STOCK_Q'		, badtockQ);
			rtnRecord.set('INOUT_P'			, inoutP);
			rtnRecord.set('INOUT_I'			, inoutI);
		},
		cbStockQ_kd: function(provider, params) {
			var rtnRecord = params.rtnRecord;
			var pabStockQ = Unilite.nvl(provider['PAB_STOCK_Q'], 0);//가용재고량
			rtnRecord.set('PAB_STOCK_Q', pabStockQ);
		}
	});//End of Unilite.Main( {





	Unilite.createValidator('validator01', {
		store	: barcodeStore,
		grid	: barcodeGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			switch(fieldName) {
				case "INOUT_SEQ":
					if(newValue <= '0'){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
					}else if(clng(grdsheet1.TextMatrix(lRow,lCol)) != fnCDbl(grdsheet1.TextMatrix(lRow,lCol))){ //?
						rv='<t:message code="system.message.purchase.message072" default="정수만 입력 가능합니다."/>';
					}

				case "WH_CODE" :
					if(!Ext.isEmpty(newValue)){
						record.set('WH_CODE', e.column.field.getRawValue());
						record.set('WH_CELL_CODE', "");
						record.set('WH_CELL_NAME', "");
						record.set('LOT_NO', "");
					}else{
						record.set('WH_CODE', "");
						record.set('WH_CELL_CODE', "");
						record.set('WH_CELL_NAME', "");
						record.set('LOT_NO', "");
					}
					if(!Ext.isEmpty(record.get('ITEM_CODE'))){
						if(record.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
							UniMatrl.fnStockQ_kd(record, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, record.get('DIV_CODE'), UniDate.getDbDateStr(record.get('INOUT_DATE')), record.get('ITEM_CODE'));
						}
						UniMatrl.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('DIV_CODE'), null, record.get('ITEM_CODE'), newValue );
					}
					//그리드 창고cell콤보 reLoad..
	//				cbStore.loadStoreRecords(newValue);
	//				UniAppManager.setToolbarButtons('save', true);
					break;

				case "WH_CELL_CODE" :
					record.set('WH_CELL_CODE', e.column.field.getRawValue());
					break;

					//추가

					if(record.get('CREATE_LOC') != '3'){
						if(newValue > 0 && record.get('BASIS_NUM') > ''){	// ''보다 크면??
							if(record.get('INOUT_Q') > (record.get('ORIGINAL_Q') + record.get('NOT_Q'))){
								rv='<t:message code="system.message.purchase.message073" default="출고량은 예약량을 초과 할 수 없습니다."/>';
							}
						}
					}

				case "INOUT_Q" :
					if(newValue < 0 && !Ext.isEmpty(newValue))  {
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					if(record.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
						var sInout_q = newValue;	//출고량
						var sInv_q = record.get('PAB_STOCK_Q'); //가용재고량
						var sOriginQ = record.get('ORIGINAL_Q'); //출고량(원)
						if(sInout_q > (sInv_q + sOriginQ)){
							rv='<t:message code="system.message.purchase.message014" default="출고량은 가용재고량을 초과할 수 없습니다."/>';  //출고량은 재고량을 초과할 수 없습니다.
							break;
						}
					}
					if(isCheckStockYn){   //예외 출고 및 가용재고체크 사용할시
						var sInout_q = newValue;	//출고량
						var sInv_q = record.get('ITEM_STATUS') == "1"? record.get('GOOD_STOCK_Q') : record.get('BAD_STOCK_Q');  //재고량
						var sOriginQ = record.get('ORIGINAL_Q'); //출고량(원)

						if(sInout_q > (sInv_q + sOriginQ)){
							rv='<t:message code="system.message.purchase.message014" default="출고량은 가용재고량을 초과할 수 없습니다."/>';  //출고량은 재고량을 초과할 수 없습니다.
							break;
						}
					}
					//masterGrid에 변경 수량 적용
					var masterRecords	= masterGrid.getStore().data.items;
					Ext.each(masterRecords, function(masterRecord, i) {
						if(masterRecord.get('ITEM_CODE') == record.get('ITEM_CODE')) {
							var newInoutQ = parseInt(masterRecord.get('INOUT_Q')) + newValue - oldValue;
							masterRecord.set('INOUT_Q', newInoutQ);
							UniMatrl.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode
											, record.get('DIV_CODE'), null, record.get('ITEM_CODE')
											, record.get('WH_CODE') );
							UniMatrl.fnStockQ(masterRecord, UniAppManager.app.cbStockQ, UserInfo.compCode
											, masterRecord.get('DIV_CODE'), null, masterRecord.get('ITEM_CODE')
											, masterRecord.get('WH_CODE') );
						}
					});

					break;
					//추가
			}
			return rv;
		}
	});





	//바코드 입력 로직 (출고요청번호)
	function fnEnterOutStockBarcode(newValue) {
		var masterRecords		= directMasterStore1.data.items;
		var OutStockReqBarcode	= newValue
		var flag = true;

		//동일한 출고요청번호 입력되었을 경우 처리
		Ext.each(masterRecords, function(masterRecord,i) {
			if(!Ext.isEmpty(masterRecord.get('OUTSTOCK_NUM'))) {
				if(masterRecord.get('OUTSTOCK_NUM').toUpperCase() == OutStockReqBarcode.toUpperCase()) {
					beep();
					gsText = '<t:message code="system.message.purchase.message001" default="동일한  출고요청번호가 이미 등록 되었습니다."/>';
					openAlertWindow(gsText);
					flag = false;
					Ext.getBody().unmask();
					panelResult.getField('OUTSTOCK_BARCODE').focus();
					return false;
				}
			}
		});

		if(flag) {
			var param = {
				DIV_CODE		: panelResult.getValue('DIV_CODE'),
				INOUT_CODE_TYPE	: panelResult.getValue('INOUT_CODE_TYPE'),
				OUT_WH_CODE		: panelResult.getValue('WH_CODE'),
				OUTSTOCK_NUM	: OutStockReqBarcode
			}
			//출하지시참조 조회쿼리 호출
			mtr202ukrvService.selectrefList(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
//					panelResult.setValue('INOUT_CODE_TYPE'	, provider[0].WH_CODE);
//					panelResult.setValue('WH_CODE'			, provider[0].WH_CODE);
					refSearchGrid.returnData(provider);
					Ext.getBody().unmask();
					panelResult.getField('BARCODE').focus();

				} else {
					beep();
					gsText = '<t:message code="system.message.purchase.message002" default="입력하신 출고요청번호의 데이터가 존재하지 않습니다."/>';
					openAlertWindow(gsText);
					Ext.getBody().unmask();
					panelResult.getField('OUTSTOCK_BARCODE').focus();
					return false;
				}
			});
		}
	}


	//출고요청 참조 바코드 입력 로직 (lot_no)
	function fnEnterBarcode(newValue) {
		var masterRecords	= masterGrid.getStore().data.items;
		var barcodeItemCode	= newValue.split(barcodeGbn)[0].toUpperCase();
		var barcodeLotNo	= newValue.split(barcodeGbn)[1];
		var barcodeInoutQ	= newValue.split(barcodeGbn)[2];

		if(Ext.isEmpty(barcodeLotNo)) {
			barcodeItemCode = '';
			barcodeLotNo	= newValue.split('|')[0].toUpperCase();
			barcodeInoutQ	= 0;

		} else {
			barcodeLotNo = barcodeLotNo.toUpperCase();
		}

		var param3			= {};
		var flag = true;

		//동일한 LOT_NO 입력되었을 경우 처리
		barcodeStore.clearFilter();						//filter clear 후
		var records		= barcodeStore.data.items;		//비교할 records 구성
		var lotNoMgntYn = BsaCodeInfo.gsLotNoMgntYn //lot_no중복체크 품목제외 여부(y이면 lotno만 중복체크 n이면 lotno + 품목코드까지 해서 중복 체크)

		Ext.each(records, function(record, i) {
			if(lotNoMgntYn == 'Y' || Ext.isEmpty(lotNoMgntYn) ){//기존대로 lotno로만 중복체크
				if(record.get('LOT_NO').toUpperCase() == barcodeLotNo ) {
					beep();
					gsText = '<t:message code="system.message.purchase.message003" default="동일한  Lot No.(이)가 이미 등록되었습니다."/>'
					openAlertWindow(gsText);
					panelResult.getField('BARCODE').focus();
					flag = false;
					return false;
				}
			}else{
				if(record.get('LOT_NO').toUpperCase() == barcodeLotNo && record.get('ITEM_CODE') == barcodeItemCode) {
					beep();
					gsText = '<t:message code="system.message.purchase.message003" default="동일한  Lot No.(이)가 이미 등록되었습니다."/>'
					openAlertWindow(gsText);
					panelResult.getField('BARCODE').focus();
					flag = false;
					return false;
				}
			}

		});

		gsMaxInoutSeq = gsMaxInoutSeq + 1;

		//바코드 정보 UPDATE
		param3.DIV_CODE		= panelResult.getValue('DIV_CODE');
		param3.ITEM_CODE	= barcodeItemCode;
		param3.LOT_NO		= barcodeLotNo;
		param3.INOUT_Q		= barcodeInoutQ;
		param3.WH_CODE		= panelResult.getValue('WH_CODE');
		param3.INOUT_SEQ	= gsMaxInoutSeq;
		param3.INOUT_DATE	= UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'));

		//LOT_NO만 입력되었을 때, ITEM_CODE가져오는 로직 추가(20180723)
		mtr202ukrvService.getItemInfo(param3, function(itemInfo, response){
			if(!Ext.isEmpty(itemInfo)){
				if(!Ext.isEmpty(itemInfo[0].ERR_MSG)) {
					beep();
					gsText = itemInfo[0].ERR_MSG;
					openAlertWindow(gsText);
					panelResult.getField('BARCODE').focus();
					flag = false;
					return false;

				} else {
					//masterGrid에서 필요한 데이터 가져옴
					Ext.each(masterRecords, function(masterRecord, i) {
						if(masterRecord.get('ITEM_CODE') == itemInfo[0].ITEM_CODE) {
							param3 = {
								COMP_CODE			: masterRecord.data.COMP_CODE,
								DIV_CODE			: masterRecord.data.DIV_CODE,
								INOUT_CODE			: masterRecord.data.INOUT_CODE,
								INOUT_NAME			: masterRecord.data.INOUT_NAME,
								INOUT_NUM			: masterRecord.data.INOUT_NUM,
								INOUT_SEQ			: gsMaxInoutSeq,
								INOUT_METH			: masterRecord.data.INOUT_METH,
								INOUT_TYPE_DETAIL	: masterRecord.data.INOUT_TYPE_DETAIL,
								INOUT_CODE_DETAIL	: masterRecord.data.INOUT_CODE_DETAIL,
								INOUT_CODE_TYPE		: masterRecord.data.INOUT_CODE_TYPE,
								WH_CODE				: masterRecord.data.WH_CODE,
								WH_CELL_CODE		: masterRecord.data.WH_CELL_CODE,
								INOUT_DATE			: UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE')),
								ITEM_STATUS			: masterRecord.data.ITEM_STATUS,
								INOUT_PRSN			: masterRecord.data.INOUT_PRSN,
								MONEY_UNIT			: masterRecord.data.MONEY_UNIT,
								OUTSTOCK_NUM		: masterRecord.data.ARRAY_OUTSTOCK_NUM,
								ARRAY_REF_WKORD_NUM	: masterRecord.data.ARRAY_REF_WKORD_NUM,
								PATH_CODE			: masterRecord.data.PATH_CODE,
								BASIS_NUM			: masterRecord.data.BASIS_NUM,
								BASIS_SEQ			: masterRecord.data.BASIS_SEQ,
								ORDER_NUM			: masterRecord.data.ORDER_NUM,
								PROJECT_NO			: masterRecord.data.PROJECT_NO,
								PJT_CODE			: masterRecord.data.PJT_CODE,
								ACCOUNT_YNC			: masterRecord.data.ACCOUNT_YNC,
								ACCOUNT_Q			: masterRecord.data.ACCOUNT_Q,

								ITEM_CODE			: masterRecord.data.ITEM_CODE,
								SPEC				: masterRecord.data.SPEC,
								STOCK_UNIT			: masterRecord.data.STOCK_UNIT,
								LOT_NO				: barcodeLotNo,
								INOUT_Q				: barcodeInoutQ,
								INOUT_P				: masterRecord.data.INOUT_P,
								REF_GUBUN			: masterRecord.data.REF_GUBUN
							};
							if(Ext.isEmpty(masterRecord.data.MONEY_UNIT)) {
								param3.MONEY_UNIT = BsaCodeInfo.gsMoneyUnit;
							}
						}
					});

					if(Ext.isEmpty(param3.COMP_CODE)) {
						beep();
						gsText = '<t:message code="system.message.purchase.message005" default="입력하신 바코드의 품목이 기조회된 데이터에 존재하지 않습니다."/>'
						openAlertWindow(gsText);
						flag = false;
						panelResult.getField('BARCODE').focus();
						return false;
					}

					//반품가능요청 참조일 경우, lot 정보 체크 하지 않음
					if(flag && param3.REF_GUBUN == 'R') {
						fnBarcodeInfo(masterRecords, param3);
					}
					if(flag && param3.REF_GUBUN != 'R') {
						var param = {
							ITEM_CODE		: barcodeItemCode,
							LOT_NO			: barcodeLotNo,
							ORDER_UNIT_Q	: barcodeInoutQ,
							WH_CODE			: panelResult.getValue('WH_CODE'),
							DIV_CODE		: panelResult.getValue('DIV_CODE'),
							LOT_NO_S		: panelResult.getValue('LOT_NO_S'),
							MONEY_UNIT		: BsaCodeInfo.gsMoneyUnit,
							GSFIFO			: BsaCodeInfo.gsFifo
						}
						str105ukrvService.getFifo(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								if(!Ext.isEmpty(provider[0].ERR_MSG)) {
									beep();
									gsText = provider[0].ERR_MSG;
									openAlertWindow(gsText);
									panelResult.getField('BARCODE').focus();
									return false;
								};
								fnBarcodeInfo(masterRecords, param3);
							}
						});
					}
				}
			}
		});
	}

	//반품가능 바코드 입력 로직 (lot_no)
	function fnEnterBarcode2(newValue) {
		var barcodeItemCode	= newValue.split(barcodeGbn)[0].toUpperCase();
		var barcodeLotNo	= newValue.split(barcodeGbn)[1];
		var barcodeInoutQ	= newValue.split(barcodeGbn)[2];
		var flag			= true;

		if(Ext.isEmpty(barcodeLotNo)/* && Ext.isEmpty(barcodeInoutQ)*/) {
			barcodeItemCode	= '';
			barcodeLotNo	= newValue.split(barcodeGbn)[0].toUpperCase();;
			barcodeInoutQ	= '';

		} else {
			barcodeLotNo = barcodeLotNo.toUpperCase();
		}

		//동일한 LOT_NO 입력되었을 경우 처리
		barcodeStore.clearFilter();						//filter clear 후
		var records		= barcodeStore.data.items;		//비교할 records 구성
		var lotNoMgntYn = BsaCodeInfo.gsLotNoMgntYn //lot_no중복체크 품목제외 여부(y이면 lotno만 중복체크 n이면 lotno + 품목코드까지 해서 중복 체크)
		Ext.each(records, function(record, i) {
			if(lotNoMgntYn == 'Y' || Ext.isEmpty(lotNoMgntYn)){//기존대로 lotno로만 중복체크
				if(record.get('LOT_NO').toUpperCase() == barcodeLotNo) {
					beep();
					gsText = '<t:message code="system.message.purchase.message003" default="동일한  Lot No.(이)가 이미 등록되었습니다."/>'
					openAlertWindow(gsText);
					panelResult.getField('BARCODE').focus();
					flag = false;
					return false;
				}
			}else{ // lotno와 품목코드까지해서 중복체크
				if(record.get('LOT_NO').toUpperCase() == barcodeLotNo && record.get('ITEM_CODE') == barcodeItemCode) {
					beep();
					gsText = '<t:message code="system.message.purchase.message003" default="동일한  Lot No.(이)가 이미 등록되었습니다."/>'
					openAlertWindow(gsText);
					panelResult.getField('BARCODE').focus();
					flag = false;
					return false;
				}
			}
		});

		if(flag) {
			var param = panelResult.getValues();
			param.ITEM_CODE	= barcodeItemCode;
			param.LOT_NO	= barcodeLotNo;

			//LOT_NO만 입력되었을 때, ITEM_CODE가져오는 로직 추가(20181114)
			if(Ext.isEmpty(barcodeItemCode)) {
				mtr202ukrvService.getItemInfo(param, function(itemInfo, response){
					if(!Ext.isEmpty(itemInfo)){
						if(!Ext.isEmpty(itemInfo[0].ERR_MSG)) {
							beep();
							gsText = itemInfo[0].ERR_MSG;
							openAlertWindow(gsText);
							panelResult.getField('BARCODE').focus();
							flag = false;
							return false;

						} else {
							param.ITEM_CODE	= itemInfo[0].ITEM_CODE;
							fnGetBarcodeInfo2(param);
						}
					}
				})
			} else {
				fnGetBarcodeInfo2(param);
			}
		}
	}





	//masterGrid 삭제
	function fnDeleteDetail(selRow) {
		var deleteRecords	= new Array();

		masterGrid.deleteSelectedRow();
		//barcode그리드의 관련 내용 삭제
		barcodeStore.clearFilter();
		var barcodeRecords = barcodeStore.data.items;
		Ext.each(barcodeRecords, function(barcodeRecord,i) {
			if(barcodeRecord.get('ITEM_CODE') == selRow.get('ITEM_CODE')) {
				deleteRecords.push(barcodeRecord);
			}
		});
		barcodeStore.remove(deleteRecords);
		gsMaxInoutSeq = Unilite.nvl(barcodeStore.max('INOUT_SEQ'), 0);
	}

	//barcodeGrid 삭제
	function fnBarcodeGrid(selRow, selRow2) {
		var deleteRecords	= new Array();
		var selRows = directMasterStore1.data.items;
		Ext.each(selRows, function(selRow,i) {
			if(selRow2.get('ITEM_CODE') == selRow.get('ITEM_CODE')) {
				selRow.set('INOUT_Q', selRow.get('INOUT_Q') - selRow2.get('INOUT_Q'));
				if(selRow.get('INOUT_Q') == 0) {
					deleteRecords.push(selRow);
				}
			}
		});
		directMasterStore1.remove(deleteRecords);
		barcodeGrid.deleteSelectedRow();
		gsMaxInoutSeq = Unilite.nvl(barcodeStore.max('INOUT_SEQ'), 0);
	}

	//bacode 정보  get / set
	function fnBarcodeInfo(masterRecords, param3) {
		mtr202ukrvService.getBarcodeInfo(param3, function(provider2, response){
			if(!Ext.isEmpty(provider2)){
				Ext.each(provider2, function(barcodeInfo, i) {
//					barcodeInfo.phantom = true;
//					barcodeStore.insert(i, barcodeInfo);
					UniAppManager.app.onNewDataButtonDown(true, '2');
					var newRecord	= barcodeGrid.getSelectedRecord();
					var columns		= barcodeGrid.getColumns();
					Ext.each(columns, function(column, index)	{
						var columnName = column.initialConfig.dataIndex;
						newRecord.set(columnName, barcodeInfo[columnName]);
					});

		//20181105 추가 (선택된 행의 저장된 데이터만 barcodeGrid에 보여주도록 filter)
		if(!Ext.isEmpty(barcodeInfo)) {
			barcodeStore.filterBy(function(record){
				return record.get('ARRAY_OUTSTOCK_NUM') == barcodeInfo.ARRAY_OUTSTOCK_NUM
					&& record.get('ITEM_CODE') == barcodeInfo.ITEM_CODE;
			})
		}
					//masterGird inout_q update
					Ext.each(masterRecords, function(masterRecord, i) {
						if(masterRecord.get('ITEM_CODE') == param3.ITEM_CODE) {
							var newInoutQ = parseInt(masterRecord.get('INOUT_Q')) + parseInt(barcodeInfo.INOUT_Q);
							masterRecord.set('INOUT_Q', newInoutQ);
							UniMatrl.fnStockQ(masterRecord, UniAppManager.app.cbStockQ, UserInfo.compCode
											, masterRecord.get('DIV_CODE'), null, masterRecord.get('ITEM_CODE')
											, masterRecord.get('WH_CODE') );
						}
					});
				});
				panelResult.getField('BARCODE').focus();

			} else {
				beep();
				gsText = '<t:message code="system.message.purchase.message004" default="입력하신 품목의 데이터가 존재하지 않습니다."/>'
				openAlertWindow(gsText);
				Ext.getBody().unmask();
				panelResult.getField('BARCODE').focus();
				return false;
			}
			//바코드 입력창으로 포커스 이동
			setTimeout(function(){
				panelResult.getField('BARCODE').focus();
			}, 100);
		});
	}

	function fnGetBarcodeInfo2(param) {
		mtr202ukrvService.getBarcodeInfo2(param, function(provider, response){
			if(!Ext.isEmpty(provider)) {
				Ext.each(provider, function(providerData,i) {
					UniAppManager.app.onNewDataButtonDown(true);
					masterGrid.setRefSearchGridData2(provider[i], '2');

					barcodeStore.clearFilter();
					UniAppManager.app.onNewDataButtonDown(true, '2');
					barcodeGrid.setRefSearchGridData2(provider[i]);
				});

			} else {
				beep();
				gsText = '<t:message code="system.message.purchase.message013" default="입력하신 바코드의 반품가능요청 데이터가 없습니다."/>';
				openAlertWindow(gsText);
				Ext.getBody().unmask();
				panelResult.getField('BARCODE').focus();
				return false;
			}
		});
	}



	function beep() {
		audioCtx = new(window.AudioContext || window.webkitAudioContext)();

		var oscillator = audioCtx.createOscillator();
		var gainNode = audioCtx.createGain();

		oscillator.connect(gainNode);
		gainNode.connect(audioCtx.destination);

		gainNode.gain.value = 0.1;				//VOLUME 크기
		oscillator.frequency.value = 4100;
		oscillator.type = 'sine';				//sine, square, sawtooth, triangle

		oscillator.start();

		setTimeout(
			function() {
			  oscillator.stop();
			},
			1000									//길이
		);
	};


	var activeGridId = 'mtr202ukrvGrid1';
};
</script>