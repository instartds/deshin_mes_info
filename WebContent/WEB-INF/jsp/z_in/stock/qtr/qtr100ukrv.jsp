<%--
'   프로그램명 : 출고등록 (구매재고)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="qtr100ukrv"  >
   <t:ExtComboStore comboType="BOR120"  />          <!-- 사업장 -->
   <t:ExtComboStore comboType="AU" comboCode="B005" opts= '1;2;3' /> <!-- 출고처 구분 -->
   <t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 출고담당 -->
   <t:ExtComboStore comboType="AU" comboCode="M101" /> <!-- 자동채번 -->
   <t:ExtComboStore comboType="AU" comboCode="M104" /> <!-- 출고유형 -->
   <t:ExtComboStore comboType="AU" comboCode="B021" /> <!-- 품목상태 -->
   <t:ExtComboStore comboType="AU" comboCode="B022" /> <!-- 재고상태 -->
   <t:ExtComboStore comboType="AU" comboCode="B031" /> <!-- 생성경로 -->
   <t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 재고단위 -->
   <t:ExtComboStore comboType="AU" comboCode="P106" /> <!-- 진행상태 -->
   <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
   <t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /><!--작업장-->
   <t:ExtComboStore comboType="WU" />        <!-- 작업장-->
   <t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" /><!--창고Cell-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var SearchInfoWindow;	// 조회버튼 누르면 나오는 조회창
var RefSearchWindow;    // 출고요청 참조
var RefSearchWindow2;   // 반품가능요청 참조
var alertWindow;        //alertWindow : 경고창
var purchaseReceiptWindow;   // 구매입고참조
var productionReceiptWindow;   // 생산입고참조
var initChk = 'N'; //초기화 체크
var referData = false;
var BsaCodeInfo = {
	gsAutoType:        '${gsAutoType}',
	gsInvstatus:       '${gsInvstatus}',
	gsMoneyUnit:       '${gsMoneyUnit}',
	gsInoutCodeType:   '${gsInoutCodeType}',
	gsManageLotNoYN:   '${gsManageLotNoYN}',
	gsBomPathYN:       '${gsBomPathYN}',
	gsSumTypeCell:     '${gsSumTypeCell}',
	gsOutDetailType:   '${gsOutDetailType}',
    whList :            ${whList},
    inoutPrsn: ${inoutPrsn},
    gsUsePabStockYn:   '${gsUsePabStockYn}',
    gsCheckStockYn:    '${gsCheckStockYn}'
};

/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);
*/
var outDivCode = UserInfo.divCode;

function appMain() {

	var gsSumTypeCell = false;
    if(BsaCodeInfo.gsSumTypeCell =='N')    {
        gsSumTypeCell = true;
    }

    var sumtypeCell = true; //재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
    if(BsaCodeInfo.gsSumTypeCell =='Y') {
        sumtypeCell = false;
    }

    var usePabStockYn = true; //가용재고 컬럼 사용여부
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

    //창고에 따른 창고cell 콤보load..
//    var cbStore = Unilite.createStore('hat510ukrsComboStoreGrid',{
//        autoLoad: false,
//        fields: [
//                {name: 'SUB_CODE', type : 'string'},
//                {name: 'CODE_NAME', type : 'string'}
//                ],
//        proxy: {
//            type: 'direct',
//            api: {
//                read: 'salesCommonService.fnRecordCombo'
//            }
//        },
//        loadStoreRecords: function(whCode) {
//            var param= panelSearch.getValues();
//            param.COMP_CODE= UserInfo.compCode;
////            param.DIV_CODE = UserInfo.divCode;
//            param.WH_CODE = whCode;
//            param.TYPE = 'BSA225T';
//            console.log( param );
//            this.load({
//                params: param
//            });
//        }
//    });


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'qtr100ukrvService.selectList',
			update: 'qtr100ukrvService.updateDetail',
			create: 'qtr100ukrvService.insertDetail',
			destroy: 'qtr100ukrvService.deleteDetail',
			syncAll: 'qtr100ukrvService.saveAll'
		}
	});
   /**
    *   Model 정의
    * @type
    */

	Unilite.defineModel('Qtr100ukrvModel', {
		fields: [
			{name: 'INOUT_NUM'				, text: '<t:message code="system.label.purchase.issueno" default="출고번호"/>'		, type: 'string'},
			{name: 'INOUT_SEQ'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'		    , type: 'int'},
			{name: 'INOUT_METH'				, text: '<t:message code="system.label.purchase.method" default="방법"/>'		    , type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		, text: '<t:message code="system.label.purchase.issuetype" default="출고유형"/>'		, type: 'string', comboType: 'AU', comboCode: 'M104', allowBlank: false},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string', comboType: 'BOR120', child: 'WH_CODE'},
			{name: 'INOUT_CODE'				, text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>'		, type: 'string', allowBlank: false},
			{name: 'INOUT_CODE_DETAIL'      , text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>Cell'       , type: 'string'},
            {name: 'INOUT_NAME'             , text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>'      , type: 'string', allowBlank: true},
			{name: 'INOUT_NAME1'			, text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>'		, type: 'string', allowBlank: true},
            {name: 'INOUT_NAME2'            , text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>'      , type: 'string', allowBlank: true},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.purchase.spec" default="규격"/>'		    , type: 'string'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'PATH_CODE'				, text: '<t:message code="system.label.purchase.pathinfo" default="PATH정보"/>'	    , type: 'string'},
			{name: 'NOT_Q'					, text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>'		, type: 'uniQty'},
			{name: 'INOUT_Q'				, text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'		, type: 'uniQty', allowBlank: false},
			{name: 'ITEM_STATUS'			, text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>'		, type: 'string', comboType: 'AU', comboCode: 'B021', allowBlank: false},
			{name: 'ORIGINAL_Q'				, text: '<t:message code="system.label.purchase.issueqtywon" default="출고량(원)"/>'	, type: 'uniQty'},
			{name: 'PAB_STOCK_Q'            , text: '<t:message code="system.label.purchase.availableinventoryqty" default="가용재고량"/>'   , type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'			, text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>'		, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'			, text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'		, type: 'uniQty'},
			{name: 'BASIS_NUM'				, text: '<t:message code="system.label.purchase.basisno" default="근거번호"/>'		, type: 'string'},
			{name: 'BASIS_SEQ'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'		    , type: 'int'},
			{name: 'INOUT_TYPE'				, text: '<t:message code="system.label.purchase.type" default="타입"/>'		    , type: 'string'},
			{name: 'INOUT_CODE_TYPE'		, text: '<t:message code="system.label.purchase.tranplacedivision" default="수불처구분"/>'	, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('whList'), allowBlank: false, child: 'WH_CELL_CODE'},
			{name: 'WH_CELL_CODE'           , text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>Cell' , type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','DIV_CODE']},
			{name: 'INOUT_DATE'				, text: '<t:message code="system.label.purchase.transdate" default="수불일자"/>'		, type: 'uniDate'},
			{name: 'INOUT_P'				, text: '<t:message code="system.label.purchase.tranprice" default="수불단가"/>'		, type: 'uniUnitPrice'},
			{name: 'INOUT_I'				, text: '<t:message code="system.label.purchase.localamount" default="원화금액"/>'		, type: 'uniPrice'},
			{name: 'MONEY_UNIT'				, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'		    , type: 'string'},
			{name: 'INOUT_PRSN'				, text: '<t:message code="system.label.purchase.charger" default="담당자"/>'		, type: 'string'},
			{name: 'ACCOUNT_Q'				, text: '<t:message code="system.label.purchase.billqty" default="계산서량"/>'		, type: 'uniQty'},
			{name: 'ACCOUNT_YNC'			, text: '<t:message code="system.label.purchase.billobject" default="계산서대상"/>'	, type: 'string'},
			{name: 'CREATE_LOC'				, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'		, type: 'string', comboType: 'AU', comboCode: 'B031'},
			{name: 'ORDER_NUM'				, text: 'ORDER_NUM'	    , type: 'string'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'		    , type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'LOT_NO'					, text: 'LOT NO'		, type: 'string'},
			{name: 'SALE_DIV_CODE'			, text: '<t:message code="system.label.purchase.salesdivision" default="매출사업장"/>'	, type: 'string'},
			{name: 'SALE_CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.salesplace" default="매출처"/>'		, type: 'string'},
			{name: 'BILL_TYPE'				, text: '<t:message code="system.label.purchase.salestype" default="매출유형"/>'		, type: 'string'},
			{name: 'SALE_TYPE'				, text: '<t:message code="system.label.purchase.salesclass" default="매출구분"/>'		, type: 'string'},
			{name: 'COMP_CODE'				, text: 'COMP_CODE'	    , type: 'string'},
			{name: 'ARRAY_OUTSTOCK_NUM'		, text: '<t:message code="system.label.purchase.requestno" default="요청번호"/>'		, type: 'string'},
			{name: 'ARRAY_REF_WKORD_NUM'	, text: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>'	, type: 'string'},
			{name: 'ARRAY_OUTSTOCK_REQ_Q'	, text: '<t:message code="system.label.purchase.requestqty" default="요청량"/>'		, type: 'uniQty'},
			{name: 'ARRAY_OUTSTOCK_Q'		, text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'		, type: 'uniQty'},
			{name: 'ARRAY_REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'		    , type: 'string'},
			{name: 'ARRAY_PROJECT_NO'		, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'ARRAY_LOT_NO'			, text: 'LOT NO'		, type: 'string'},
			{name: 'UPDATE_DB_USER'			, text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>'		, type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '<t:message code="system.label.purchase.updatedate" default="수정일"/>'	, type: 'string'},
            {name: 'LOT_YN'                 , text: '<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'   , type: 'string'}
		]
	});//End of Unilite.defineModel('Qtr100ukrvModel', {

	Unilite.defineModel('releaseNoMasterModel', {		//조회버튼 누르면 나오는 조회창
	    fields: [
	    	{name: 'WH_CODE'     		  , text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>'    	, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'WH_CELL_CODE'   	  , text: 'CELL'        , type: 'string'},
	    	{name: 'WH_CELL_NAME'   	  , text: 'CELL<t:message code="system.label.purchase.warehouse" default="창고"/>'        , type: 'string'},
	    	{name: 'INOUT_DATE'    		  , text: '<t:message code="system.label.purchase.issuedate" default="출고일"/>'    	    , type: 'uniDate'},
	    	{name: 'INOUT_CODE_TYPE'	  , text: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>'      , type: 'string',comboType: 'AU',comboCode: 'B005'},
	    	{name: 'INOUT_CODE'    		  , text: '<t:message code="system.label.purchase.issueplacecode" default="출고처코드"/>'    	    , type: 'string'},
	    	{name: 'INOUT_NAME'    		  , text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>'    	    , type: 'string'},
	    	{name: 'INOUT_PRSN' 		  , text: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>'    	, type: 'string'},
	    	{name: 'INOUT_NUM'     		  , text: '<t:message code="system.label.purchase.issueno" default="출고번호"/>'    	, type: 'string'},
	    	{name: 'INOUT_SEQ'     		  , text: '<t:message code="system.label.purchase.seq" default="순번"/>'    		, type: 'string'},
	    	{name: 'INOUT_TYPE'     	  , text: '<t:message code="system.label.purchase.trantype1" default="수불타입"/>' 		, type: 'string'},
	    	{name: 'COMP_CODE'            , text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'       , type: 'string'},
	    	{name: 'DIV_CODE' 			  , text: '<t:message code="system.label.purchase.division" default="사업장"/>'    	    , type: 'string',comboType:'BOR120'},
	    	{name: 'LOT_NO' 			  , text: 'LOT NO'          , type: 'string'},
	    	{name: 'PROJECT_NO' 		  , text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'   , type: 'string'},
	    	{name: 'ITEM_CODE' 			  , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'    	, type: 'string'},
	    	{name: 'ITEM_NAME' 			  , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'    	    , type: 'string'}
		]
	});

	Unilite.defineModel('refSearchMasterModel', {      // 출고요청 참조
        fields: [
            {name: 'CHOICE'                 , text: '<t:message code="system.label.purchase.selection" default="선택"/>'                  , type: 'string'},
            {name: 'COMP_CODE'              , text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'              , type: 'string'},
            {name: 'DIV_CODE'               , text: '<t:message code="system.label.purchase.division" default="사업장"/>'                , type: 'string', comboType: 'BOR120'},
            {name: 'WORK_SHOP_CODE'         , text: '<t:message code="system.label.purchase.workcentercode" default="작업장코드"/>'            , type: 'string'},
            {name: 'WORK_SHOP_NAME'         , text: '<t:message code="system.label.purchase.workcentername" default="작업장명"/>'              , type: 'string'},
            {name: 'WORK_WH_CODE'           , text: '<t:message code="system.label.purchase.processingwarehousecode" default="가공창고코드"/>'          , type: 'string'},
            {name: 'WORK_WH_NAME'           , text: '<t:message code="system.label.purchase.processingwarehouse" default="가공창고"/>'            , type: 'string'},
            {name: 'WORK_WH_CELL_CODE'      , text: '<t:message code="system.label.purchase.processingwarehousecellcode" default="가공창고CELL코드"/>'          , type: 'string'},
            {name: 'WORK_WH_CELL_NAME'      , text: '<t:message code="system.label.purchase.processingwarehousecell" default="가공창고CELL"/>'            , type: 'string'},
            {name: 'ITEM_CODE'              , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'              , type: 'string'},
            {name: 'ITEM_NAME'              , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'                , type: 'string'},
            {name: 'SPEC'                   , text: '<t:message code="system.label.purchase.spec" default="규격"/>'                  , type: 'string'},
            {name: 'STOCK_UNIT'             , text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'              , type: 'string',comboType: 'AU',comboCode: 'B013', displayField: 'value'},
            {name: 'PATH_CODE'              , text: '<t:message code="system.label.purchase.pathinfo" default="PATH정보"/>'              , type: 'string'},
            {name: 'OUTSTOCK_REQ_DATE'      , text: '<t:message code="system.label.purchase.requestdate" default="요청일"/>'                , type: 'uniDate'},
            {name: 'OUTSTOCK_REQ_Q'         , text: '<t:message code="system.label.purchase.requestqty" default="요청량"/>'                , type: 'uniQty'},
            {name: 'OUTSTOCK_Q'             , text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'                , type: 'uniQty'},
            {name: 'NOT_Q'                  , text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>'              , type: 'uniQty'},
            {name: 'STOCK_Q'                , text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'                , type: 'uniQty'},
            {name: 'PAB_STOCK_Q'            , text: '<t:message code="system.label.purchase.availableinventoryqty" default="가용재고량"/>'              , type: 'uniQty'},
            {name: 'GOOD_STOCK_Q'           , text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>'              , type: 'uniQty'},
            {name: 'BAD_STOCK_Q'            , text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'              , type: 'uniQty'},
            {name: 'AVERAGE_P'              , text: '<t:message code="system.label.purchase.inventoryprice" default="재고단가"/>'              , type: 'uniUnitPrice'},
            {name: 'MAIN_WH_CODE'           , text: '<t:message code="system.label.purchase.mainwarehousecode" default="주창고코드"/>'            , type: 'string'},
            {name: 'MAIN_WH_NAME'           , text: '<t:message code="system.label.purchase.mainwarehouse" default="주창고"/>'              , type: 'string'},
            {name: 'OUTSTOCK_NUM'           , text: '<t:message code="system.label.purchase.issuerequestno" default="출고요청번호"/>'          , type: 'string'},
            {name: 'CONTROL_STATUS'         , text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'              , type: 'string', comboType :"AU" , comboCode : "P106"},
            {name: 'CANCEL_Q'               , text: '<t:message code="system.label.purchase.cancelqty" default="취소량"/>'                , type: 'uniQty'},
            {name: 'REMARK'                 , text: '<t:message code="system.label.purchase.remarks" default="비고"/>'                  , type: 'string'},
            {name: 'PROJECT_NO'             , text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'          , type: 'string'},
            {name: 'WH_CODE'                , text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'                  , type: 'string',store: Ext.data.StoreManager.lookup('whList')},
            {name: 'WH_CELL_CODE'           , text: 'CELL<t:message code="system.label.purchase.warehouse" default="창고"/>'              , type: 'string'},
            {name: 'REF_WKORD_NUM'          , text: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>'          , type: 'string'},
            {name: 'WK_LOT_NO'              , text: 'LOT NO'                , type: 'string'},
            {name: 'WK_REMARK'              , text: '<t:message code="system.label.purchase.remarksworkorder" default="비고(작지)"/>'            , type: 'string'},
            {name: 'WK_PROJECT_NO'          , text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>(<t:message code="system.label.purchase.workorder" default="작지"/>)'    , type: 'string'},
            {name: 'PROD_ITEM_CODE'         , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>(<t:message code="system.label.purchase.workorder" default="작지"/>)'        , type: 'string'},
            {name: 'PROD_ITEM_NAME'         , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>(<t:message code="system.label.purchase.workorder" default="작지"/>)'          , type: 'string'},
            {name: 'LOT_YN'                 , text: '<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'           , type: 'string'}
        ]
    });

    Unilite.defineModel('refSearchMasterModel2', {      // 반품가능 참조
        fields: [
            {name: 'CHOICE'                 , text: '<t:message code="system.label.purchase.selection" default="선택"/>'                  , type: 'string'},
            {name: 'COMP_CODE'              , text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'              , type: 'string'},
            {name: 'DIV_CODE'               , text: '<t:message code="system.label.purchase.division" default="사업장"/>'                , type: 'string'},
            {name: 'WORK_SHOP_CODE'         , text: '<t:message code="system.label.purchase.workcentercode" default="작업장코드"/>'            , type: 'string'},
            {name: 'WORK_SHOP_NAME'         , text: '<t:message code="system.label.purchase.workcentername" default="작업장명"/>'              , type: 'string'},
            {name: 'WORK_WH_CODE'           , text: '<t:message code="system.label.purchase.processingwarehousecode" default="가공창고코드"/>'          , type: 'string'},
            {name: 'WORK_WH_NAME'           , text: '<t:message code="system.label.purchase.processingwarehouse" default="가공창고"/>'            , type: 'string'},
            {name: 'OUTSTOCK_REQ_DATE'      , text: '<t:message code="system.label.purchase.requestdate" default="요청일"/>'                , type: 'string'},
            {name: 'ITEM_CODE'              , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'              , type: 'string'},
            {name: 'ITEM_NAME'              , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'                , type: 'string'},
            {name: 'SPEC'                   , text: '<t:message code="system.label.purchase.spec" default="규격"/>'                  , type: 'string'},
            {name: 'STOCK_UNIT'             , text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'              , type: 'string',comboType: 'AU',comboCode: 'B013', displayField: 'value'},
            {name: 'PATH_CODE'              , text: '<t:message code="system.label.purchase.pathinfo" default="PATH정보"/>'             , type: 'string'},
            {name: 'NOTOUTSTOCK_Q'          , text: '<t:message code="system.label.purchase.returnavaiableqty" default="반품가능량"/>'          , type: 'uniQty'},
            {name: 'OUTSTOCK_Q'             , text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'                , type: 'uniQty'},
            {name: 'NOT_Q'                  , text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>'              , type: 'uniQty'},
            {name: 'STOCK_Q'                , text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'                , type: 'uniQty'},
            {name: 'OUTSTOCK_NUM'           , text: '<t:message code="system.label.purchase.issuerequestno" default="출고요청번호"/>'          , type: 'string'},
            {name: 'CONTROL_STATUS'         , text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'              , type: 'string', comboType :"AU" , comboCode : "P106"},
            {name: 'CANCEL_Q'               , text: '<t:message code="system.label.purchase.cancelqty" default="취소량"/>'                , type: 'uniQty'},
            {name: 'REMARK'                 , text: '<t:message code="system.label.purchase.remarks" default="비고"/>'                  , type: 'string'},
            {name: 'WH_CODE'                , text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'                  , type: 'string'},
            {name: 'WH_CELL_CODE'           , text: 'CELL<t:message code="system.label.purchase.warehouse" default="창고"/>'              , type: 'string'},
            {name: 'REF_WKORD_NUM'          , text: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>'          , type: 'string'},
            {name: 'WK_LOT_NO'              , text: 'LOT NO'                , type: 'string'}
        ]
    });

    Unilite.defineModel('purchaseReceiptModel', {      // 구매입고참조
        fields: [
            {name: 'CHOICE'                  , text: '<t:message code="system.label.purchase.selection" default="선택"/>'                  , type: 'string'},
            {name: 'COMP_CODE'            , text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'              , type: 'string'},
            {name: 'INOUT_DATE'  			, text: '입고일'				, type: 'uniDate', allowBlank: false},
            {name: 'DIV_CODE'               , text: '<t:message code="system.label.purchase.division" default="사업장"/>'                , type: 'string', comboType: 'BOR120'},
	        {name: 'INOUT_CODE'		 , text:'<t:message code="system.label.purchase.customcode" default="거래처코드"/>'     	 		, type: 'string', allowBlank:false},
		    {name: 'CUSTOM_NAME'		 , text:'<t:message code="system.label.purchase.customname" default="거래처명"/>'     	 		, type: 'string', allowBlank:false},
            {name: 'ITEM_CODE'             , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'              , type: 'string'},
            {name: 'ITEM_NAME'             , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'                , type: 'string'},
            {name: 'SPEC'                   	 , text: '<t:message code="system.label.purchase.spec" default="규격"/>'                  , type: 'string'},
            {name: 'LOT_NO'              	 , text: 'LOT NO'                , type: 'string'},
            {name: 'INOUT_Q'         , text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'					, type: 'uniQty', allowBlank: true},
            {name: 'BASIS_NUM'             , text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'					, type: 'string', allowBlank: true},
            {name: 'BASIS_SEQ'             , text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'int', allowBlank: true},
            {name: 'LOT_YN'                  , text: '<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'           , type: 'string'},
            {name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('whList'), allowBlank: false},
        	{name: 'GOOD_STOCK_Q'			, text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>'		, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'			, text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'		, type: 'uniQty'},

        ]
    });

    Unilite.defineModel('productionReceiptModel', {      // 생산입고참조
        fields: [
            {name: 'CHOICE'                  , text: '<t:message code="system.label.purchase.selection" default="선택"/>'                  , type: 'string'},
            {name: 'COMP_CODE'            , text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'              , type: 'string'},
            {name: 'DIV_CODE'               , text: '<t:message code="system.label.purchase.division" default="사업장"/>'                , type: 'string', comboType: 'BOR120'},
            {name: 'INOUT_DATE'  			, text: '생산일'				, type: 'uniDate', allowBlank: false},
        	{name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'		, type: 'string', allowBlank: false},
        	{name: 'WH_NAME'				, text: '창고명'		, type: 'string', allowBlank: true},
        	{name: 'WH_CELL_CODE'				, text: '창고cell'		, type: 'string', allowBlank: true},
	        {name: 'ITEM_CODE'             , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'              , type: 'string'},
            {name: 'ITEM_NAME'             , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'                , type: 'string'},
            {name: 'SPEC'                   	 , text: '<t:message code="system.label.purchase.spec" default="규격"/>'                  , type: 'string'},
            {name: 'LOT_NO'              	 , text: 'LOT NO'                , type: 'string'},
            {name: 'INOUT_Q'         , text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'					, type: 'uniQty', allowBlank: true},
            {name: 'BASIS_NUM'             , text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'					, type: 'string', allowBlank: true},
            {name: 'BASIS_SEQ'             , text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'int', allowBlank: true},
            {name: 'LOT_YN'                  , text: '<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'           , type: 'string'},
        	{name: 'GOOD_STOCK_Q'			, text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>'		, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'			, text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'		, type: 'uniQty'},
        ]
    });
   /**
    * Store 정의(Service 정의)
    * @type
    */

	var directMasterStore1 = Unilite.createStore('qtr100ukrvMasterStore1',{
        model: 'Qtr100ukrvModel',
        autoLoad: false,
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: true,         // 수정 모드 사용
            deletable: true,        // 삭제 가능 여부
            allDeletable:   true,    //전체삭제 가능 여부
            useNavi : false         // prev | next 버튼 사용
        },
        proxy: directProxy,
        loadStoreRecords: function() {
            var param= panelSearch.getValues();
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

			var inoutNum = panelSearch.getValue('INOUT_NUM');
			var isErr = false;
			Ext.each(list, function(record, index) {
				if(record.data['INOUT_NUM'] != inoutNum) {
					record.set('INOUT_NUM', inoutNum);
				}
				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
				    alert((index + 1) + '<t:message code="system.message.purchase.message026" default="행의 입력값을 확인 해주세요."/>' + 'LOT NO:' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
			var paramMaster= panelSearch.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
					config = {
							params: [paramMaster],
							success: function(batch, option) {
								var master = batch.operations[0].getResultSet();
								panelSearch.setValue("INOUT_NUM", master.INOUT_NUM);
								panelResult.setValue("INOUT_NUM", master.INOUT_NUM);

//								var inoutNum = panelSearch.getValue('INOUT_NUM');
//								Ext.each(list, function(record, index) {
//									if(record.data['INOUT_NUM'] != inoutNum) {
//										record.set('INOUT_NUM', inoutNum);
//									}
//								})
//								panelSearch.getForm().wasDirty = false;
//								panelSearch.resetDirtyStatus();
//								UniAppManager.setToolbarButtons('save', false);
								directMasterStore1.loadStoreRecords();
								if(directMasterStore1.getCount() == 0){
									UniAppManager.app.onResetButtonDown();
								}

							 }
					};
				this.syncAllDirect(config);
			}else{
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
    });//End of var directMasterStore1 = Unilite.createStore('qtr100ukrvMasterStore1',{

	var releaseNoMasterStore = Unilite.createStore('releaseNoMasterStore', {	// 검색팝업창
			model: 'releaseNoMasterModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read    : 'qtr100ukrvService.selectreleaseNoMasterList'
                }
            },
            loadStoreRecords : function()	{
				var param= releaseNoSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});

	var refSearchMasterStore = Unilite.createStore('refSearchMasterStore', {   //참조
            model: 'refSearchMasterModel',
            autoLoad: false,
            uniOpt : {
                isMaster: false,            // 상위 버튼 연결
                editable: false,            // 수정 모드 사용
                deletable:false,            // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                    read    : 'qtr100ukrvService.selectrefList'
                }
            },
            loadStoreRecords : function()   {
                var param= refSearch.getValues();
                param.DIV_CODE = panelSearch.getValue("DIV_CODE");
                param.OUT_WH_CODE = panelSearch.getValue("WH_CODE");
                param.INOUT_CODE_TYPE = panelSearch.getValue("INOUT_CODE_TYPE");
                console.log( param );
                this.load({
                    params : param
                });
            },
            listeners:{
                load:function(store, records, successful, eOpts)    {
                        if(successful)  {
                           var masterRecords = refSearchMasterStore.data.filterBy(refSearchMasterStore.filterNewOnly);
                           var estiRecords = new Array();

                           if(masterRecords.items.length > 0)   {
                                console.log("store.items :", store.items);
                                console.log("records", records);

                                Ext.each(records,
                                    function(item, i)   {
                                        Ext.each(masterRecords.items, function(record, i)   {
                                            console.log("record :", record);

                                                if( (record.data['OUTSTOCK_NUM'] == item.data['OUTSTOCK_NUM'])
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
    });

    var refSearchMasterStore2 = Unilite.createStore('refSearchMasterStore2', {    //참조2
            model: 'refSearchMasterModel2',
            autoLoad: false,
            uniOpt : {
                isMaster: false,            // 상위 버튼 연결
                editable: false,            // 수정 모드 사용
                deletable:false,            // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                    read    : 'qtr100ukrvService.selectrefList2'
                }
            },
            loadStoreRecords : function()   {
                var param= refSearch2.getValues();
                param.DIV_CODE = panelSearch.getValue("DIV_CODE");
                param.OUT_WH_CODE = panelSearch.getValue("WH_CODE");
                param.INOUT_CODE_TYPE = panelSearch.getValue("INOUT_CODE_TYPE");
                console.log( param );
                this.load({
                    params : param
                });
            },
            listeners:{
                load:function(store, records, successful, eOpts)    {
                        if(successful)  {
                           var masterRecords = refSearchMasterStore2.data.filterBy(refSearchMasterStore2.filterNewOnly);
                           var estiRecords = new Array();

                           if(masterRecords.items.length > 0)   {
                                console.log("store.items :", store.items);
                                console.log("records", records);

                                Ext.each(records,
                                    function(item, i)   {
                                        Ext.each(masterRecords.items, function(record, i)   {
                                            console.log("record :", record);

                                                if( (record.data['OUTSTOCK_NUM'] == item.data['OUTSTOCK_NUM'])
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
    });

	var purchaseReceiptStore = Unilite.createStore('purchaseReceiptStore', {   //참조
        model: 'purchaseReceiptModel',
        autoLoad: false,
        uniOpt : {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read    : 'qtr100ukrvService.selectPurchaseReceiptList'
            }
        },
        loadStoreRecords : function()   {
            var param= purchaseReceiptSearch.getValues();
            param.DIV_CODE = panelSearch.getValue("DIV_CODE");
            param.OUT_WH_CODE = panelSearch.getValue("WH_CODE");
            param.INOUT_CODE_TYPE = panelSearch.getValue("INOUT_CODE_TYPE");
            console.log( param );
            this.load({
                params : param
            });
        },
        listeners:{
            load:function(store, records, successful, eOpts)    {
            	  if(successful)  {
                      var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
                      var estiRecords = new Array();

                      if(masterRecords.items.length > 0)   {
                           console.log("store.items :", store.items);
                           console.log("records", records);

                           Ext.each(records,
                               function(item, i)   {
                                   Ext.each(masterRecords.items, function(record, i)   {
                                       console.log("record :", record);

                                           if( (record.data['BASIS_NUM'] == item.data['BASIS_NUM'] && record.data['BASIS_SEQ'] == item.data['BASIS_SEQ'])
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
	});

	var productionReceiptStore = Unilite.createStore('productionReceiptStore', {   //참조
        model: 'productionReceiptModel',
        autoLoad: false,
        uniOpt : {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read    : 'qtr100ukrvService.selectProductionReceiptList'
            }
        },
        loadStoreRecords : function()   {
            var param= productionReceiptSearch.getValues();
            param.DIV_CODE = panelSearch.getValue("DIV_CODE");
            param.OUT_WH_CODE = panelSearch.getValue("WH_CODE");
            param.INOUT_CODE_TYPE = panelSearch.getValue("INOUT_CODE_TYPE");
            console.log( param );
            this.load({
                params : param
            });
        },
        listeners:{
            load:function(store, records, successful, eOpts)    {
          	  if(successful)  {
                  var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
                  var estiRecords = new Array();

                  if(masterRecords.items.length > 0)   {
                       console.log("store.items :", store.items);
                       console.log("records", records);

                       Ext.each(records,
                           function(item, i)   {
                               Ext.each(masterRecords.items, function(record, i)   {
                                   console.log("record :", record);

                                       if( (record.data['BASIS_NUM'] == item.data['BASIS_NUM'] && record.data['BASIS_SEQ'] == item.data['BASIS_SEQ'])
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
	});
   /**
    * 검색조건 (Search Panel)
    * @type
    */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
        collapsed:true,
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
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>',
				name: 'INOUT_CODE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B005',
				allowBlank: false,
				holdable: 'hold',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_CODE_TYPE', newValue);
                        if(initChk != 'Y'){
                        	UniAppManager.app.setHiddenColumn();
                        }
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
				xtype: 'uniDatefield',
				name:'INOUT_DATE',
				value: UniDate.get('today'),
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				child: 'WH_CELL_CODE',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
                fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>Cell',
                name: 'WH_CELL_CODE',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('whCellList'),
                holdable: 'hold',
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        panelResult.setValue('WH_CELL_CODE', newValue);
                    }
                }
            },{
				fieldLabel: '<t:message code="system.label.purchase.issueno" default="출고번호"/>',
				name: 'INOUT_NUM',
				xtype: 'uniTextfield',
                readOnly: isAutoOrderNum,
                holdable: isAutoOrderNum ? 'readOnly':'hold',
                holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_NUM', newValue);
					}
				}
			},{
                fieldLabel: 'OUTSTOCK_NUM',
                name: 'OUTSTOCK_NUM',
                xtype: 'uniTextfield',
                hidden: true
            }/*,{
				fieldLabel: 'Lot No',
				name: 'LOT_NO',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('LOT_NO', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.manageno" default="관리번호"/>',
				name: 'PROJECT_NO',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PROJECT_NO', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			        	valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						extParam: {'CUSTOM_TYPE': '3'},
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
									panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						}
			  })*/]
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
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {



	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>',
				name: 'INOUT_CODE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B005',
				holdable: 'hold',
				allowBlank: false,
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('INOUT_CODE_TYPE', newValue);
						console.log("[iniChk2]" + initChk);
						 if(initChk != 'Y'){
							  UniAppManager.app.setHiddenColumn();
						 }
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
				xtype: 'uniDatefield',
				name:'INOUT_DATE',
				value: UniDate.get('today'),
				allowBlank: false,
				holdable: 'hold',
				colspan: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('INOUT_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('INOUT_PRSN', newValue);
					}
				}
			}, Unilite.popup('DEPT', {
                fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>'
                    , valueFieldName:'DEPT_CODE'
                    , textFieldName: 'DEPT_NAME'
                    , holdable: 'hold'
                    , allowBlank: false
                    , listeners: {
                        onSelected: {
                            fn: function(records, type) {

                              }, scope: this
                       }, onClear: function(type) {
                           panelResult.setValue('DEPT_CODE', '');
                           panelResult.setValue('DEPT_NAME', '');

                       }, applyextparam:function(popup){
                             var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                             var deptCode = UserInfo.deptCode;   //부서정보
                             var divCode = '';                   //사업장

                             if(authoInfo == "A"){   //자기사업장
                                 popup.setExtParam({'DEPT_CODE': ""});
                                 popup.setExtParam({'DIV_CODE': UserInfo.divCode});

                             }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                                 popup.setExtParam({'DEPT_CODE': ""});
                                 popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});

                             }else if(authoInfo == "5"){     //부서권한
                                 popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
                                 popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                             }
                       }
                   }
           }),{
				fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				allowBlank: false,
				child: 'WH_CELL_CODE',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WH_CODE', newValue);
					}
				}
			},{
                fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>Cell',
                name: 'WH_CELL_CODE',
                xtype:'uniCombobox',
                holdable: 'hold',
                store: Ext.data.StoreManager.lookup('whCellList'),
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        panelSearch.setValue('WH_CELL_CODE', newValue);
                    }
                }
            },{
                fieldLabel  : '<t:message code="system.label.sales.barcode" default="바코드"/>',
                name        : 'BARCODE',
                xtype       : 'uniTextfield',
                readOnly    : false,
                fieldStyle  : 'IME-MODE: inactive',             //IE에서만 적용 됨
                listeners   : {
                    change: function(combo, newValue, oldValue, eOpts) {
                    },
                    specialkey:function(field, event)   {
                        if(event.getKey() == event.ENTER) {
                            if(!panelResult.getInvalidMessage()) return;    //필수체크

                            var newValue = panelResult.getValue('BARCODE');
                            if(!Ext.isEmpty(newValue)) {
                                //detailGrid에 데이터 존재여부 확인
                                if(Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
                                    beep();
                                    gsText = '<t:message code="system.message.inventory.message031" default="바코드 입력 시, 출고창고는 필수입력 입니다."/>';
                                    openAlertWindow(gsText);
                                    panelResult.setValue('BARCODE', '');
                                    panelResult.getField('WH_CODE').focus();
                                    return false;
                                }
                               // masterGrid.focus();
                                fnEnterBarcode(newValue);
                                panelResult.setValue('BARCODE', '');
                                panelResult.getField('BARCODE').focus();
                            }
                        }
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.purchase.issueno" default="출고번호"/>',
                name: 'INOUT_NUM',
                xtype: 'uniTextfield',
                readOnly: isAutoOrderNum,
                holdable: 'hold',
                holdable: isAutoOrderNum ? 'readOnly':'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('INOUT_NUM', newValue);
                    }
                }
            }
                /*,{
				fieldLabel: 'Lot No',
				name: 'LOT_NO',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('LOT_NO', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.manageno" default="관리번호"/>',
				name: 'PROJECT_NO',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('PROJECT_NO', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			        	valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
						extParam: {'CUSTOM_TYPE': '3'},
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
									panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						}
			})*/],
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



	var releaseNoSearch = Unilite.createSearchForm('releaseNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 2},
	    trackResetOnLoad: true,
	    items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120'
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false
			},{
				fieldLabel: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>',
				name: 'INOUT_CODE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B005',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						UniAppManager.app.setHiddenField();
					}
				}
			},{
		    	xtype:'container',
		        layout: {type: 'vbox'},
		        items: [
	            Unilite.popup('WORK_SHOP',{
	            	itemId : 'workShopP',
	                fieldLabel: '<t:message code="system.label.purchase.issueplace" default="출고처"/>',
	                valueFieldName: 'INOUT_CODE_WORK_SHOP',
	                textFieldName: 'INOUT_NAME_WORK_SHOP',
	                hidden:true,
					listeners: {
						applyextparam: function(popup){
							popup.setExtParam({'TYPE_LEVEL': releaseNoSearch.getValue('DIV_CODE')});
						}
					}
	        	}),

	            Unilite.popup('DEPT',{
	            	itemId : 'deptP',
	                fieldLabel: '<t:message code="system.label.purchase.issueplace" default="출고처"/>',
	                valueFieldName: 'INOUT_CODE_DEPT',
	                textFieldName: 'INOUT_NAME_DEPT',
	                hidden:true,
					listeners: {
						applyextparam: function(popup){
							popup.setExtParam({'TYPE_LEVEL': releaseNoSearch.getValue('DIV_CODE')});
						}
					}
	        	}),
	        	{
					fieldLabel: '<t:message code="system.label.purchase.issueplacewarehouse" default="출고처창고"/>',
	            	itemId : 'inoutWh',
					name: 'INOUT_CODE_WH',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList'),
	                hidden:true
				}]
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024'
			},{
				fieldLabel: 'Lot No',
				name: 'LOT_NO',
				xtype: 'uniTextfield'
			},
			Unilite.popup('DIV_PUMOK', {
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				validateBlank: false
			}),{
				fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				name: 'PROJECT_NO',
				xtype: 'uniTextfield'
			}]
    }); // createSearchForm

    var refSearch = Unilite.createSearchForm('refSearchForm', {     // 참조
        layout: {type: 'uniTable', columns : 4},
        trackResetOnLoad: true,
        items: [
            Unilite.popup('DIV_PUMOK',{
                        fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
                        valueFieldName: 'ITEM_CODE',
                        textFieldName: 'ITEM_NAME',
                        extParam: {'CUSTOM_TYPE': '3'}
            }),{
                fieldLabel: '<t:message code="system.label.purchase.issuerequestno" default="출고요청번호"/>',
                name: 'OUTSTOCK_NUM',
                xtype: 'uniTextfield'
            },{
                fieldLabel: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>',
                name: 'WKORD_NUM',
                xtype: 'uniTextfield'
            },{
                fieldLabel: '<t:message code="system.label.purchase.mainwarehouse" default="주창고"/>',
                name: 'MAIN_WH_CODE',
                xtype: 'uniCombobox',
                store: Ext.data.StoreManager.lookup('whList')
            },{
                fieldLabel: '<t:message code="system.label.purchase.requestperiod" default="요청기간"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'REQ_FR_DATE',
                endFieldName: 'REQ_TO_DATE',
                startDate: UniDate.get('today'),
                endDate: UniDate.get('today')
            },{
                fieldLabel: '<t:message code="system.label.purchase.workcenter" default="작업장"/>',
                name: 'WORK_SHOP_CODE',
                xtype: 'uniCombobox',
                comboType: 'WU'
            },{
                fieldLabel: '<t:message code="system.label.purchase.processingwarehouse" default="가공창고"/>',
                name: 'WORK_WH_CODE',
                xtype: 'uniCombobox',
                store: Ext.data.StoreManager.lookup('whList')
            },{
                fieldLabel: 'Lot No',
                name: 'LOT_NO',
                xtype: 'uniTextfield'
            }
        ]
    }); // createSearchForm

    var refSearch2 = Unilite.createSearchForm('refSearchForm2', {     // 참조2
        layout: {type: 'uniTable', columns : 3},
        trackResetOnLoad: true,
        items: [
            Unilite.popup('DIV_PUMOK',{
                        fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
                        valueFieldName: 'ITEM_CODE',
                        textFieldName: 'ITEM_NAME',
                        extParam: {'CUSTOM_TYPE': '3'}
            }),{
                fieldLabel: '<t:message code="system.label.purchase.issuerequestno" default="출고요청번호"/>',
                name: 'OUTSTOCK_NUM',
                xtype: 'uniTextfield'
            },{
                fieldLabel: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>',
                name: 'WKORD_NUM',
                xtype: 'uniTextfield'
            },{
                fieldLabel: '<t:message code="system.label.purchase.requestperiod" default="요청기간"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'REQ_FR_DATE',
                endFieldName: 'REQ_TO_DATE',
                startDate: UniDate.get('today'),
                endDate: UniDate.get('today')
            },{
                fieldLabel: '<t:message code="system.label.purchase.workcenter" default="작업장"/>',
                name: 'WORK_SHOP_CODE',
                xtype: 'uniCombobox',
                comboType: 'WU'
            },{
                fieldLabel: 'Lot No',
                name: 'LOT_NO',
                xtype: 'uniTextfield'
            }
        ]
    }); // createSearchForm

    var purchaseReceiptSearch = Unilite.createSearchForm('purchaseReceiptForm', {     // 구매입고참조
        layout: {type: 'uniTable', columns : 2},
        trackResetOnLoad: true,
        items: [,
            Unilite.popup('AGENT_CUST', {
                    fieldLabel:'<t:message code="system.label.purchase.custom" default="거래처"/>',
                    allowBlank: true,
                    holdable: 'hold',
                    id: 'CUSTOM_ID',
                    valueFieldName: 'CUSTOM_CODE',
                    textFieldName: 'CUSTOM_NAME',
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                console.log('records : ', records);

                            },
                            scope: this
                        },
                        onClear: function(type) {
                        			purchaseReceiptSearch.setValue('CUSTOM_CODE', '');
                        			purchaseReceiptSearch.setValue('CUSTOM_NAME', '');
                        }
                    }
            }),{
                fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'INOUT_DATE_FR',
                endFieldName: 'INOUT_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            },
            Unilite.popup('DIV_PUMOK',{
                        fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목"/>',
                        valueFieldName: 'ITEM_CODE',
                        textFieldName: 'ITEM_NAME',
                        extParam: {'CUSTOM_TYPE': '3'}
            }),{
				fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				allowBlank: false,
				readOnly: true,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

					}
				}
			}
        ]
    }); // createSearchForm

    var productionReceiptSearch = Unilite.createSearchForm('productionReceiptForm', {     // 구매입고참조
        layout: {type: 'uniTable', columns : 2},
        trackResetOnLoad: true,
        items: [,
            Unilite.popup('AGENT_CUST', {
                    fieldLabel:'<t:message code="system.label.purchase.custom" default="거래처"/>',
                    allowBlank: true,
                    holdable: 'hold',
                    valueFieldName: 'CUSTOM_CODE',
                    textFieldName: 'CUSTOM_NAME',
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                console.log('records : ', records);

                            },
                            scope: this
                        },
                        onClear: function(type) {
                        	productionReceiptSearch.setValue('CUSTOM_CODE', '');
                        	productionReceiptSearch.setValue('CUSTOM_NAME', '');
                        }
                    }
            }),{
                fieldLabel: '<t:message code="system.label.purchase.productiondate" default="생산일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'INOUT_DATE_FR',
                endFieldName: 'INOUT_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            },
            Unilite.popup('DIV_PUMOK',{
                        fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목"/>',
                        valueFieldName: 'ITEM_CODE',
                        textFieldName: 'ITEM_NAME',
                        extParam: {'CUSTOM_TYPE': '3'}
            }),{
				fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				allowBlank: false,
				holdable: 'hold',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

					}
				}
			},{	//20200520 추가
                fieldLabel: 'WH_CELL_CODE',
                name: 'WH_CELL_CODE',
                xtype: 'uniTextfield',
                hidden: true
            }
        ]
    }); // createSearchForm


    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('qtr100ukrvGrid1', {
       // for tab
		layout: 'fit',
		region:'center',
		uniOpt: {
			  onLoadSelectFirst   : false,
	            expandLastColumn    : true,
	            useRowNumberer      : false,
	            dblClickToEdit      : true,
	            useMultipleSorting  : true
        },
        store: directMasterStore1,
        tbar: [{
	            	xtype: 'button',
		            text: '입고참조',
		            handler: function() {
		                	openPurchaseReceiptWindow();
			        }
		        },{
		            xtype: 'button',
		            text: '생산참조',
		            handler: function() {
		                	openProductionReceiptWindow();
			        }
			   }],
       /*  tbar: [{
            xtype: 'splitbutton',
            itemId:'orderTool',
            text: '<t:message code="system.label.purchase.reference" default="참조..."/>',
            iconCls : 'icon-referance',
            menu: Ext.create('Ext.menu.Menu', {
                items: [{
                    itemId: 'MoveReleaseBtn',
                    text: '<t:message code="system.label.purchase.issuerequestrefer" default="출고요청 참조"/>',
                    handler: function() {
                        openRefSearchWindow();
                    }
                },{
                    itemId: 'MoveReleaseBtn2',
                    text: '<t:message code="system.label.purchase.returnavaiablerequestrefer" default="반품가능요청 참조"/>',
                    handler: function() {
                        openRefSearchWindow2();
                    }
                }]
            })
        }], */
        features: [
                   {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
                   {id: 'masterGridTotal', ftype: 'uniSummary',        showSummaryRow: true}
               ],
		columns: [
			{dataIndex: 'INOUT_NUM'					, width: 66, hidden: true},
			{dataIndex: 'INOUT_SEQ'					, width: 60},
            {dataIndex: 'WH_CODE'                   , width: 85, hidden: true},
//            {dataIndex: 'WH_CELL_CODE'              , width: 110, hidden: sumtypeCell},
            {dataIndex: 'WH_CELL_CODE'              , width: 110, hidden: true},
			{dataIndex: 'INOUT_METH'				, width: 46, hidden: true},
			{dataIndex: 'INOUT_TYPE_DETAIL'			, width: 85},
			{dataIndex: 'DIV_CODE'					, width: 110},
			{dataIndex: 'INOUT_CODE'				, width: 80, hidden: true},
			{dataIndex: 'INOUT_CODE_DETAIL'         , width: 53, hidden: true},
            {dataIndex: 'INOUT_NAME'                , width: 150, hidden: true},				//창고
			{dataIndex: 'INOUT_NAME1'				, width: 150, hidden: true		//작업장
                ,'editor' : Unilite.popup('WORK_SHOP_G',{textFieldName:'TREE_NAME', textFieldWidth:100, DBtextFieldName: 'TREE_NAME',
                				autoPopup: true,
		                    	listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        var grdRecord = masterGrid.uniOpt.currentRecord;
                                        grdRecord.set('INOUT_CODE',records[0]['TREE_CODE']);
                                        grdRecord.set('INOUT_NAME1',records[0]['TREE_NAME']);

                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    var grdRecord = masterGrid.uniOpt.currentRecord;

                                    grdRecord.set('INOUT_CODE', '');
                                    grdRecord.set('INOUT_NAME1', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelSearch.getValues();
                                    popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
                                }
                            }
                })
            },
            {dataIndex: 'INOUT_NAME2'                , width: 150, hidden: false		//부서
                ,'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    DBtextFieldName: 'REQ_DEPT_CODE',
                    listeners: { 'onSelected': {
                        fn: function(records, type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('INOUT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('INOUT_NAME2',records[0]['TREE_NAME']);

                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('INOUT_CODE','');
                            grdRecord.set('INOUT_NAME2','');
                      },
                        applyextparam: function(popup){
                            var param =  panelSearch.getValues();
                            popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
                        }
                    }
                })
            },
			{dataIndex: 'ITEM_CODE'					, width: 100,
			editor: Unilite.popup('DIV_PUMOK_G', {
			 							textFieldName: 'ITEM_CODE',
			 							DBtextFieldName: 'ITEM_CODE',
			 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
		                    			autoPopup: true,
										listeners: {'onSelected': {
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
																}
										}
								})
			},
			{dataIndex: 'ITEM_NAME'					, width: 120,
			editor: Unilite.popup('DIV_PUMOK_G', {
			 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
		                    			autoPopup: true,
										listeners: {'onSelected': {
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
													'onClear': function(type) {
																	masterGrid.setItemData(null,true);
																}
															}
								})
			},
			{dataIndex: 'SPEC'						, width: 150},
            {dataIndex: 'LOT_NO'                    , width: 133, hidden: gsManageLotNoYN,
                editor: Unilite.popup('LOTNO_G', {
                    textFieldName: 'LOT_CODE',
                    DBtextFieldName: 'LOT_CODE',
                    autoPopup: true,
                    validateBlank: false,
                    listeners: {
                    	'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                var rtnRecord;
                                var goodStockQ = 0;
                                var outQ = 0;
                                Ext.each(records, function(record,i) {
                                    if(i==0){
                                        rtnRecord = masterGrid.uniOpt.currentRecord
                                    }else{
                                        rtnRecord = masterGrid.getSelectedRecord()
                                    }
                                    rtnRecord.set('LOT_NO',         record['LOT_NO']);
                                    rtnRecord.set('WH_CODE',        record['WH_CODE']);
                                    rtnRecord.set('WH_CELL_CODE',   record['WH_CELL_CODE']);
                                    goodStockQ = record['GOOD_STOCK_Q'];
                                    outQ = rtnRecord.get('INOUT_Q') ;
                                    console.log("[LOT 재고량]" + goodStockQ);
                                    console.log("[출고량]" + outQ);
                                    if(goodStockQ < outQ){
                                    	rtnRecord.set('INOUT_Q',goodStockQ);
                                    	rtnRecord.set('GOOD_STOCK_Q',goodStockQ);
                                    }
                                });
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            var rtnRecord = masterGrid.uniOpt.currentRecord;
                            rtnRecord.set('LOT_NO', '');
                        },applyextparam: function(popup){
                            var record = masterGrid.getSelectedRecord();
                            var divCode = panelSearch.getValue('DIV_CODE');
                            var itemCode = record.get('ITEM_CODE');
                            var itemName = record.get('ITEM_NAME');
                            var whCode = record.get('WH_CODE');
                            var whCellCode = record.get('WH_CELL_CODE');
                            var stockYN = 'Y'
                            popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode, 'S_WH_CELL_CODE': whCellCode, 'STOCK_YN': stockYN});
                        }
                    }
                })
            },
            {dataIndex: 'LOT_YN'                    , width: 90, hidden: true},
			{dataIndex: 'STOCK_UNIT'				, width: 66, align: 'center',
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
                }
            },
			{dataIndex: 'PATH_CODE'					, width: 113, hidden: true},
			{dataIndex: 'NOT_Q'						, width: 106, hidden: true},
			{dataIndex: 'INOUT_Q'					, width: 106, summaryType: 'sum'},
			{dataIndex: 'ITEM_STATUS'				, width: 80},
			{dataIndex: 'ORIGINAL_Q'				, width: 93},
			{dataIndex: 'PAB_STOCK_Q'               , width: 100, hidden: usePabStockYn},
			{dataIndex: 'GOOD_STOCK_Q'				, width: 100},
			{dataIndex: 'BAD_STOCK_Q'				, width: 100},
			{dataIndex: 'BASIS_NUM'					, width: 116, hidden: true},
			{dataIndex: 'BASIS_SEQ'					, width: 33, hidden: true},
			{dataIndex: 'INOUT_TYPE'				, width: 33, hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'			, width: 33, hidden: true},
			{dataIndex: 'INOUT_DATE'				, width: 80, hidden: false},
			{dataIndex: 'INOUT_P'					, width: 33, hidden: true},
			{dataIndex: 'INOUT_I'					, width: 106, hidden: true},
			{dataIndex: 'MONEY_UNIT'				, width: 106, hidden: true},
			{dataIndex: 'INOUT_PRSN'				, width: 106, hidden: true},
			{dataIndex: 'ACCOUNT_Q'					, width: 106, hidden: true},
			{dataIndex: 'ACCOUNT_YNC'				, width: 106, hidden: true},
            {dataIndex: 'ARRAY_OUTSTOCK_NUM'        , width: 120, hidden: true},
			{dataIndex: 'CREATE_LOC'				, width: 73, hidden: true},
            {dataIndex: 'ARRAY_REF_WKORD_NUM'       , width: 120, hidden: true},
			{dataIndex: 'ORDER_NUM'					, width: 116, hidden: true},
			{dataIndex: 'REMARK'					, width: 133},
			{dataIndex: 'PROJECT_NO'				, width: 133},
			{dataIndex: 'SALE_DIV_CODE'				, width: 66, hidden: true},
			{dataIndex: 'SALE_CUSTOM_CODE'			, width: 66, hidden: true},
			{dataIndex: 'BILL_TYPE'					, width: 66, hidden: true},
			{dataIndex: 'SALE_TYPE'					, width: 66, hidden: true},
			{dataIndex: 'COMP_CODE'					, width: 66, hidden: true},
			{dataIndex: 'ARRAY_OUTSTOCK_REQ_Q'		, width: 66, hidden: true},
			{dataIndex: 'ARRAY_OUTSTOCK_Q'			, width: 66, hidden: true},
			{dataIndex: 'ARRAY_REMARK'				, width: 66, hidden: true},
			{dataIndex: 'ARRAY_PROJECT_NO'			, width: 66, hidden: true},
			{dataIndex: 'ARRAY_LOT_NO'				, width: 66, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'			, width: 66, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'			, width: 66, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, 'LOT_NO')){
                    if(Ext.isEmpty(e.record.data.ITEM_CODE)){
                        alert('<t:message code="system.message.purchase.message028" default="품목코드를 입력 하십시오."/>');
                        return false;
                    }
                    if(Ext.isEmpty(e.record.data.WH_CODE) && BsaCodeInfo.gsManageLotNoYN == 'Y' ){
                        alert('<t:message code="system.message.purchase.message015" default="출고창고를 입력하십시오."/>');
                        return false;
                    }
                    if(BsaCodeInfo.gsSumTypeCell == 'Y' && Ext.isEmpty(e.record.data.WH_CELL_CODE)){
                        alert('<t:message code="system.message.purchase.message016" default="출고창고 CELL코드를 입력하십시오."/>');
                        return false;
                    }
                }

				var sInoutmeth = e.record.data.INOUT_METH;
				if(!referData){
					if(e.record.phantom){
						if(sInoutmeth == '2'){
							if(panelSearch.getValue('INOUT_CODE_TYPE') == '2'){
								if(e.field=='INOUT_TYPE_DETAIL') return false;
							}else{
								if(e.field=='INOUT_TYPE_DETAIL') return true;
							}

							if (UniUtils.indexOf(e.field,[
								'WH_CODE', 'WH_CELL_CODE', 'INOUT_Q', 'INOUT_NAME1', 'INOUT_NAME2', 'ITEM_CODE', 'ITEM_NAME', 'ITEM_STATUS', 'INOUT_SEQ', 'LOT_NO', 'REMARK','PROJECT_NO', 'ORDER_NUM'])){
								//추가 버튼
								return true;
							}else{
								return false;
							}
						}else{
							if(panelSearch.getValue('INOUT_CODE_TYPE') == '2'){
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
						if(panelSearch.getValue('INOUT_CODE_TYPE') == '2'){
								if(e.field=='INOUT_TYPE_DETAIL') return false;
							}else{
								if(e.field=='INOUT_TYPE_DETAIL') return true;
							}

						if (UniUtils.indexOf(e.field,[
								'WH_CODE', 'WH_CELL_CODE', 'INOUT_Q', 'ITEM_STATUS', 'INOUT_SEQ', 'REMARK'])){
								return true;
							}

						if(BsaCodeInfo.gsManageLotNoYN == 'Y') {
								if(e.field == 'LOT_NO')	return true;
							}else{
								if(e.field == 'LOT_NO') return false;
								}
						return false;
					}
				}else{
					if (UniUtils.indexOf(e.field,[
						'INOUT_Q', 'INOUT_TYPE_DETAIL', 'REMARK'])){
						return true;
					}else{
						return false;
					}
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
                grdRecord.set('LOT_NO'          , "");
                grdRecord.set('LOT_YN'          , "");
                grdRecord.set('GOOD_STOCK_Q', 0);
                grdRecord.set('BAD_STOCK_Q', 0);
                grdRecord.set('INOUT_P', 0);
                grdRecord.set('INOUT_I', 0);
       		} else {
                grdRecord.set('ITEM_CODE'       , record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME'       , record['ITEM_NAME']);
                grdRecord.set('SPEC'            , record['SPEC']);
                grdRecord.set('STOCK_UNIT'      , record['STOCK_UNIT']);
                grdRecord.set('LOT_NO'          , record['LOT_NO']);
                grdRecord.set('LOT_YN'          , record['LOT_YN']);

                if(grdRecord.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
                    UniMatrl.fnStockQ_kd(grdRecord, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, grdRecord.get('DIV_CODE'), UniDate.getDbDateStr(grdRecord.get('INOUT_DATE')), grdRecord.get('ITEM_CODE'));
                }
                UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'), grdRecord.get('WH_CODE'));

            }
		},
		setRefSearchGridData:function(record) {
		    var grdRecord = this.getSelectedRecord();
            grdRecord.set('COMP_CODE'               , UserInfo.compCode);
            grdRecord.set('DIV_CODE'                , record['DIV_CODE']);
//            grdRecord.set('WORK_SHOP_CODE'          , record['WORK_SHOP_CODE']);
//            grdRecord.set('WORK_WH_CODE'            , record['WORK_WH_CODE']);
            grdRecord.set('WH_CODE'                 , record['WH_CODE']);
            grdRecord.set('WH_CELL_CODE'        , record['WH_CELL_CODE']);
            if(BsaCodeInfo.gsSumTypeCell == 'Y') {
                grdRecord.set('WH_CELL_CODE'        , record['WH_CELL_CODE']);
                if(Ext.isEmpty(grdRecord.get('WH_CELL_CODE'))){
                   grdRecord.set('WH_CELL_CODE'        , panelSearch.getValue('WH_CELL_CODE'));
                }
            } else {
                grdRecord.set('WH_CELL_CODE'        , '');
            }
            if(panelSearch.getValue('INOUT_CODE_TYPE') == '2') {
                grdRecord.set('INOUT_METH'                , '3');
                grdRecord.set('INOUT_TYPE_DETAIL'         , '95');
                grdRecord.set('INOUT_CODE'                , record['WORK_WH_CODE']);
                grdRecord.set('INOUT_CODE_DETAIL'         , record['WORK_WH_CELL_CODE']);
                grdRecord.set('INOUT_NAME'                , record['WORK_WH_NAME']);
                grdRecord.set('INOUT_NAME1'               , record['WORK_WH_NAME']);
                grdRecord.set('INOUT_NAME2'               , record['WORK_WH_NAME']);
            } else {
                grdRecord.set('INOUT_METH'                , '1');
                grdRecord.set('INOUT_TYPE_DETAIL'         , '10');
                grdRecord.set('INOUT_CODE'                , record['WORK_SHOP_CODE']);
                grdRecord.set('INOUT_CODE_DETAIL'         , '');
                grdRecord.set('INOUT_NAME'                , record['WORK_SHOP_NAME']);
                grdRecord.set('INOUT_NAME1'               , record['WORK_SHOP_NAME']);
                grdRecord.set('INOUT_NAME2'               , record['WORK_SHOP_NAME']);
            }
            grdRecord.set('ITEM_CODE'               , record['ITEM_CODE']);
            grdRecord.set('ITEM_NAME'               , record['ITEM_NAME']);
            grdRecord.set('PATH_CODE'               , record['PATH_CODE']);
//            grdRecord.set('LOT_NO'                  , record['WK_LOT_NO']);
            grdRecord.set('INOUT_Q'                 , record['NOT_Q']);
            grdRecord.set('NOT_Q'                   , record['NOT_Q']);
            grdRecord.set('OUTSTOCK_NUM'            , record['OUTSTOCK_NUM']);
            grdRecord.set('ARRAY_OUTSTOCK_NUM'      , record['OUTSTOCK_NUM']);
            grdRecord.set('ARRAY_REF_WKORD_NUM'     , record['REF_WKORD_NUM']);
            grdRecord.set('LOT_YN'                  , record['LOT_YN']);
            grdRecord.set('STOCK_UNIT'              , record['STOCK_UNIT']);
            grdRecord.set('SPEC'                    , record['SPEC']);
            grdRecord.set('ARRAY_OUTSTOCK_REQ_Q'    , record['OUTSTOCK_REQ_Q']);
            grdRecord.set('ARRAY_OUTSTOCK_Q'        , record['NOT_Q']);
            grdRecord.set('ARRAY_REMARK'            , record['REMARK']);
            grdRecord.set('ARRAY_PROJECT_NO'        , record['PROJECT_NO']);
            grdRecord.set('ARRAY_LOT_NO'            , record['WK_LOT_NO']);
            grdRecord.set('ARRAY_LOT_NO'            , record['PAB_STOCK_Q']);
            UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );

		},
		setRefSearchGridData2: function(record) {
		    var grdRecord = this.getSelectedRecord();
		    if(panelSearch.getValue('INOUT_CODE_TYPE') == '2') {
                grdRecord.set('COMP_CODE'               , UserInfo.compCode);
                grdRecord.set('DIV_CODE'                , record['DIV_CODE']);
                grdRecord.set('INOUT_METH'              , '3');
                grdRecord.set('INOUT_TYPE_DETAIL'       , '95');
                grdRecord.set('INOUT_CODE'              , record['WORK_WH_CODE']);
                grdRecord.set('INOUT_CODE_DETAIL'       , record['WORK_WH_CODE']);
                grdRecord.set('INOUT_NAME'              , record['WORK_WH_NAME']);
                grdRecord.set('INOUT_NAME1'             , record['WORK_WH_NAME']);
                grdRecord.set('INOUT_NAME2'             , record['WORK_WH_NAME']);
                grdRecord.set('BASIS_NUM'               , record['OUTSTOCK_NUM']);
                grdRecord.set('DIV_CODE'                , record['DIV_CODE']);
                grdRecord.set('ITEM_CODE'               , record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME'               , record['ITEM_NAME']);
                grdRecord.set('SPEC'                    , record['SPEC']);
                grdRecord.set('PATH_CODE'               , record['PATH_CODE']);
                grdRecord.set('INOUT_Q'                 , record['NOTOUTSTOCK_Q']);
                grdRecord.set('NOT_Q'                   , record['NOT_Q']);
                grdRecord.set('STOCK_UNIT'              , record['STOCK_UNIT']);
                grdRecord.set('INOUT_DATE'              , record['OUTSTOCK_REQ_DATE']);
                grdRecord.set('CREATE_LOC'              , '2');
                grdRecord.set('INOUT_TYPE'              , '2');
                grdRecord.set('WH_CODE'                 , record['WH_CODE']);
                if(BsaCodeInfo.gsSumTypeCell == 'Y') {
                	grdRecord.set('WH_CELL_CODE'        , record['WH_CELL_CODE']);
                	if(Ext.isEmpty(grdRecord.get('WH_CELL_CODE'))){
                	   grdRecord.set('WH_CELL_CODE'        , panelSearch.getValue('WH_CELL_CODE'));
                	}
                } else {
                	grdRecord.set('WH_CELL_CODE'        , '');
                }
                grdRecord.set('ITEM_STATUS'             , '1');
                grdRecord.set('ORDER_NUM'               , record['REF_WKORD_NUM']);
                grdRecord.set('LOT_NO'                  , record['WK_LOT_NO']);
                grdRecord.set('ARRAY_OUTSTOCK_NUM'      , record['OUTSTOCK_NUM']);
                grdRecord.set('ARRAY_REF_WKORD_NUM'     , record['REF_WKORD_NUM']);
                grdRecord.set('ARRAY_OUTSTOCK_REQ_Q'    , record['NOTOUTSTOCK_Q']);
                grdRecord.set('ARRAY_OUTSTOCK_Q'        , record['NOT_Q']);
                grdRecord.set('ARRAY_REMARK'            , record['REMARK']);
                grdRecord.set('ARRAY_PROJECT_NO'        , '');
                grdRecord.set('ARRAY_LOT_NO'            , record['WK_LOT_NO']);
                /*
                grdRecord.set('GOOD_STOCK_Q'            , record['']);  //////////////////////////////// 함수??
                grdRecord.set('BAD_STOCK_Q'             , record['']);
                grdRecord.set('INOUT_P'                 , record['']);*/
                UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );
		    } else {
                grdRecord.set('COMP_CODE'               , UserInfo.compCode);
                grdRecord.set('DIV_CODE'                , record['DIV_CODE']);
                grdRecord.set('INOUT_METH'              , '1');
                grdRecord.set('INOUT_TYPE_DETAIL'       , '10');
                grdRecord.set('INOUT_CODE'              , record['WORK_SHOP_CODE']);
                grdRecord.set('INOUT_NAME'              , record['WORK_SHOP_NAME']);
                grdRecord.set('INOUT_NAME1'             , record['WORK_SHOP_NAME']);
                grdRecord.set('INOUT_NAME2'             , record['WORK_SHOP_NAME']);
                grdRecord.set('BASIS_NUM'               , record['OUTSTOCK_NUM']);
                grdRecord.set('DIV_CODE'                , record['DIV_CODE']);
                grdRecord.set('ITEM_CODE'               , record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME'               , record['ITEM_NAME']);
                grdRecord.set('SPEC'                    , record['SPEC']);
                grdRecord.set('PATH_CODE'               , record['PATH_CODE']);
                grdRecord.set('INOUT_Q'                 , record['NOTOUTSTOCK_Q']);
                grdRecord.set('NOT_Q'                   , record['NOT_Q']);
                grdRecord.set('STOCK_UNIT'              , record['STOCK_UNIT']);
                grdRecord.set('INOUT_DATE'              , record['OUTSTOCK_REQ_DATE']);
                grdRecord.set('CREATE_LOC'              , '2');
                grdRecord.set('INOUT_TYPE'              , '2');
                grdRecord.set('WH_CODE'                 , record['WH_CODE']);
                if(BsaCodeInfo.gsSumTypeCell == 'Y') {
                    grdRecord.set('WH_CELL_CODE'        , record['WH_CELL_CODE']);
                } else {
                    grdRecord.set('WH_CELL_CODE'        , '');
                }
                grdRecord.set('ITEM_STATUS'             , '1');
                grdRecord.set('ORDER_NUM'               , record['REF_WKORD_NUM']);
                grdRecord.set('LOT_NO'                  , record['WK_LOT_NO']);
                grdRecord.set('ARRAY_OUTSTOCK_NUM'      , record['OUTSTOCK_NUM']);
                grdRecord.set('ARRAY_REF_WKORD_NUM'     , record['REF_WKORD_NUM']);
                grdRecord.set('ARRAY_OUTSTOCK_REQ_Q'    , record['NOTOUTSTOCK_Q']);
                grdRecord.set('ARRAY_OUTSTOCK_Q'        , record['NOT_Q']);
                grdRecord.set('ARRAY_REMARK'            , record['REMARK']);
                grdRecord.set('ARRAY_PROJECT_NO'        , '');
                grdRecord.set('ARRAY_LOT_NO'            , record['WK_LOT_NO']);
                /*grdRecord.set('GOOD_STOCK_Q'            , 0);  //////////////////////////////// 함수??
                grdRecord.set('BAD_STOCK_Q'             , 0);
                grdRecord.set('INOUT_P'                 , 0);*/
                UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );

            }
		}

	});//End of var masterGrid = Unilite.createGrid('qtr100ukrvGrid1', {

	var releaseNoMasterGrid = Unilite.createGrid('qtr100ukrvReleaseNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
        // title: '기본',
        layout : 'fit',
		store: releaseNoMasterStore,
		uniOpt:{
					expandLastColumn: false,
					useRowNumberer: false
		},
        columns:  [
					 { dataIndex: 'WH_CODE'     		    ,  width:120},
					 { dataIndex: 'WH_CELL_CODE'   	    	,  width:120,hidden:true},
					 { dataIndex: 'WH_CELL_NAME'   	    	,  width:120,hidden:true},
					 { dataIndex: 'INOUT_DATE'    		    ,  width:93},
					 { dataIndex: 'INOUT_CODE_TYPE'	    	,  width:120},
					 { dataIndex: 'INOUT_CODE'    		    ,  width:120,hidden:true},
					 { dataIndex: 'INOUT_NAME'    		    ,  width:120},
					 { dataIndex: 'INOUT_PRSN' 		    	,  width:100},
					 { dataIndex: 'INOUT_NUM'     		    ,  width:120},
					 { dataIndex: 'DIV_CODE' 			    ,  width:86},
					 { dataIndex: 'LOT_NO' 			    	,  width:86},
					 { dataIndex: 'PROJECT_NO' 		    	,  width:86},
					 { dataIndex: 'ITEM_CODE' 			    ,  width:100},
					 { dataIndex: 'ITEM_NAME' 			    ,  width:133}
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
    	      	panelSearch.setValues({
    	      		'DIV_CODE':record.get('DIV_CODE'),
    	      		'INOUT_NUM':record.get('INOUT_NUM'),
    	      		'INOUT_CODE_TYPE':record.get('INOUT_CODE_TYPE'),
    	      		'WH_CODE':record.get('WH_CODE'),
    	      		'WH_CELL_CODE':record.get('WH_CELL_CODE'),
    	      		'INOUT_DATE':record.get('INOUT_DATE'),

              	});
    	      	panelResult.setValues({
    	      		'DEPT_CODE':record.get('INOUT_CODE'),
    	      		'DEPT_NAME':record.get('INOUT_NAME')
    	      	});
          }
    });

    var refSearchGrid = Unilite.createGrid('qtr100ukrvRefSearchGrid', {     // 참조
        // title: '기본',
        layout : 'fit',
        store: refSearchMasterStore,
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick: false }),
        uniOpt:{
            expandLastColumn: false,
            useRowNumberer: false,
            onLoadSelectFirst: false

        },
        columns:  [
             { dataIndex: 'CHOICE'                            ,  width:40, hidden: true},
             { dataIndex: 'COMP_CODE'                         ,  width:66, hidden: true},
             { dataIndex: 'DIV_CODE'                          ,  width:66, hidden: true},
             { dataIndex: 'WORK_SHOP_CODE'                    ,  width:46, hidden: true},
             { dataIndex: 'OUTSTOCK_NUM'                      ,  width:120},
             { dataIndex: 'WORK_SHOP_NAME'                    ,  width:100},
             { dataIndex: 'WORK_WH_CODE'                      ,  width:66, hidden: true},
             { dataIndex: 'WORK_WH_NAME'                      ,  width:100, hidden: true},
             { dataIndex: 'WORK_WH_CELL_CODE'                 ,  width:100, hidden: gsSumTypeCell, store: Ext.data.StoreManager.lookup('whCellList')},
             { dataIndex: 'WORK_WH_CELL_NAME'                 ,  width:100, hidden: true},
             { dataIndex: 'ITEM_CODE'                         ,  width:100},
             { dataIndex: 'ITEM_NAME'                         ,  width:200},
             { dataIndex: 'SPEC'                              ,  width:120},
             { dataIndex: 'STOCK_UNIT'                        ,  width:66, hidden: true},
             { dataIndex: 'PATH_CODE'                         ,  width:113},
             { dataIndex: 'OUTSTOCK_REQ_DATE'                 ,  width:80},
             { dataIndex: 'OUTSTOCK_REQ_Q'                    ,  width:80},
             { dataIndex: 'OUTSTOCK_Q'                        ,  width:80, hidden: true},
             { dataIndex: 'NOT_Q'                             ,  width:80},
             { dataIndex: 'STOCK_Q'                           ,  width:80, hidden: true},
             { dataIndex: 'PAB_STOCK_Q'                       ,  width:80},
             { dataIndex: 'GOOD_STOCK_Q'                      ,  width:80},
             { dataIndex: 'BAD_STOCK_Q'                       ,  width:80, hidden: true},
             { dataIndex: 'AVERAGE_P'                         ,  width:80, hidden: true},
             { dataIndex: 'MAIN_WH_CODE'                      ,  width:66, hidden: true},
             { dataIndex: 'MAIN_WH_NAME'                      ,  width:100},
             { dataIndex: 'CONTROL_STATUS'                    ,  width:40, hidden: true},
             { dataIndex: 'CANCEL_Q'                          ,  width:40, hidden: true},
             { dataIndex: 'REMARK'                            ,  width:100},
             { dataIndex: 'PROJECT_NO'                        ,  width:100},
             { dataIndex: 'WH_CODE'                           ,  width:66, hidden: true},
             { dataIndex: 'WH_CELL_CODE'                      ,  width:66, hidden: true},
             { dataIndex: 'REF_WKORD_NUM'                     ,  width:93},
             { dataIndex: 'WK_LOT_NO'                         ,  width:100},
             { dataIndex: 'WK_REMARK'                         ,  width:100},
             { dataIndex: 'WK_PROJECT_NO'                     ,  width:100},
             { dataIndex: 'PROD_ITEM_CODE'                    ,  width:100},
             { dataIndex: 'PROD_ITEM_NAME'                    ,  width:120},
             { dataIndex: 'LOT_YN'                            ,  width:120, hidden: true}
          ] ,
          listeners: {
              onGridDblClick: function(grid, record, cellIndex, colName) {
              }
          },
          returnData: function()    {
            var records = this.getSelectedRecords();

            Ext.each(records, function(record,i) {
            	panelSearch.setValue('OUTSTOCK_NUM', record.data.OUTSTOCK_NUM);
                UniAppManager.app.onNewDataButtonDown(true);
                masterGrid.setRefSearchGridData(record.data);
            });
            this.getStore().remove(records);
        }
    });

    var refSearchGrid2 = Unilite.createGrid('qtr100ukrvRefSearchGrid2', {     // 참조2
        // title: '기본',
        layout : 'fit',
        store: refSearchMasterStore2,
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick: false }),
        uniOpt:{
            expandLastColumn: false,
            useRowNumberer: false,
            onLoadSelectFirst: false
        },
        columns:  [
             { dataIndex: 'CHOICE'                         ,  width:40, hidden: true},
             { dataIndex: 'COMP_CODE'                      ,  width:66, hidden: true},
             { dataIndex: 'DIV_CODE'                       ,  width:66, hidden: true},
             { dataIndex: 'WORK_SHOP_CODE'                 ,  width:46, hidden: true},
             { dataIndex: 'WORK_SHOP_NAME'                 ,  width:100},
             { dataIndex: 'WORK_WH_CODE'                   ,  width:46, hidden: true},
             { dataIndex: 'WORK_WH_NAME'                   ,  width:100, hidden: true},
             { dataIndex: 'OUTSTOCK_REQ_DATE'              ,  width:80},
             { dataIndex: 'ITEM_CODE'                      ,  width:100},
             { dataIndex: 'ITEM_NAME'                      ,  width:120},
             { dataIndex: 'SPEC'                           ,  width:120},
             { dataIndex: 'STOCK_UNIT'                     ,  width:66, hidden: true},
             { dataIndex: 'PATH_CODE'                      ,  width:113},
             { dataIndex: 'NOTOUTSTOCK_Q'                  ,  width:80},
             { dataIndex: 'OUTSTOCK_Q'                     ,  width:80, hidden: true},
             { dataIndex: 'NOT_Q'                          ,  width:80},
             { dataIndex: 'STOCK_Q'                        ,  width:80},
             { dataIndex: 'OUTSTOCK_NUM'                   ,  width:93},
             { dataIndex: 'CONTROL_STATUS'                 ,  width:40, hidden: true},
             { dataIndex: 'CANCEL_Q'                       ,  width:40, hidden: true},
             { dataIndex: 'REMARK'                         ,  width:40, hidden: true},
             { dataIndex: 'WH_CODE'                        ,  width:66, hidden: true},
             { dataIndex: 'WH_CELL_CODE'                   ,  width:66, hidden: true},
             { dataIndex: 'REF_WKORD_NUM'                  ,  width:93},
             { dataIndex: 'WK_LOT_NO'                      ,  width:80}
          ] ,
          listeners: {
              onGridDblClick: function(grid, record, cellIndex, colName) {
              }
          },
          returnData: function()    {
            var records = this.getSelectedRecords();

            Ext.each(records, function(record,i) {
                panelSearch.setValue('OUTSTOCK_NUM', record.data.OUTSTOCK_NUM);
                UniAppManager.app.onNewDataButtonDown(true);
                masterGrid.setRefSearchGridData2(record.data);
            });
            this.getStore().remove(records);
        }
    });

    var purchaseReceiptGrid = Unilite.createGrid('purchaseReceiptGrid', {     //구매입고참조그리드
        // title: '기본',
        layout : 'fit',
        store: purchaseReceiptStore,
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick: false }),
        uniOpt:{
            expandLastColumn: false,
            useRowNumberer: false,
            onLoadSelectFirst: false
        },
        columns:  [
             { dataIndex: 'CHOICE'                         ,  width:40, hidden: true},
             { dataIndex: 'COMP_CODE'                      ,  width:66, hidden: true},
             { dataIndex: 'DIV_CODE'                       ,  width:66, hidden: true},
             { dataIndex: 'INOUT_DATE'                       ,  width:80, hidden: false},
             { dataIndex: 'INOUT_CODE'                 ,  width:80, hidden: false},
             { dataIndex: 'CUSTOM_NAME'                 ,  width:120},
             { dataIndex: 'WH_CODE'                 ,  width:120, hidden: false},
             { dataIndex: 'ITEM_CODE'                   ,  width:80, hidden: false},
             { dataIndex: 'ITEM_NAME'                   ,  width:150, hidden: false},
             { dataIndex: 'SPEC'              ,  width:80},
             { dataIndex: 'LOT_NO'                      ,  width:100},
             { dataIndex: 'INOUT_Q'                      ,  width:80},
             { dataIndex: 'BASIS_NUM'                           ,  width:120},
             { dataIndex: 'BASIS_SEQ'                           ,  width:60},
             { dataIndex: 'LOT_YN'                     ,  width:66, hidden: true},
             { dataIndex: 'GOOD_STOCK_Q'                           ,  width:80, hidden: true},
             { dataIndex: 'BAD_STOCK_Q'                     ,  width:80, hidden: true}
          ] ,
          listeners: {
              onGridDblClick: function(grid, record, cellIndex, colName) {
              }
          },
          returnData: function()    {
            var records = this.getSelectedRecords();

           // Ext.each(records, function(record,i) {
                //panelSearch.setValue('OUTSTOCK_NUM', record.data.OUTSTOCK_NUM);
                //UniAppManager.app.onNewDataButtonDown(true);
                UniAppManager.app.fnMakePurchaseReceiveDataRef(records);
                //masterGrid.setPurchaseReceiptData(record.data);
           // });
           referData = true;
            this.getStore().remove(records);
        }
    });


    var productionReceiptGrid = Unilite.createGrid('productionReceiptGrid', {     //생산입고참조그리드
        // title: '기본',
        layout : 'fit',
        store: productionReceiptStore,
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick: false }),
        uniOpt:{
            expandLastColumn: false,
            useRowNumberer: false,
            onLoadSelectFirst: false
        },
        columns:  [
             { dataIndex: 'CHOICE'                         ,  width:40, hidden: true},
             { dataIndex: 'COMP_CODE'                      ,  width:66, hidden: true},
             { dataIndex: 'DIV_CODE'                       ,  width:66, hidden: true},
             { dataIndex: 'INOUT_DATE'                       ,  width:80, hidden: false},
             { dataIndex: 'WH_CODE'                 ,  width:80, hidden: false},
             { dataIndex: 'WH_NAME'                 ,  width:120},
             { dataIndex: 'WH_CELL_CODE'                 ,  width:120, hidden: true},
             { dataIndex: 'ITEM_CODE'                   ,  width:80, hidden: false},
             { dataIndex: 'ITEM_NAME'                   ,  width:150, hidden: false},
             { dataIndex: 'SPEC'              ,  width:80},
             { dataIndex: 'LOT_NO'                      ,  width:100},
             { dataIndex: 'INOUT_Q'                      ,  width:80},
             { dataIndex: 'BASIS_NUM'                           ,  width:120},
             { dataIndex: 'BASIS_SEQ'                           ,  width:60},
             { dataIndex: 'LOT_YN'                     ,  width:66, hidden: true},
             { dataIndex: 'GOOD_STOCK_Q'                  ,  width:80, hidden: true},
             { dataIndex: 'BAD_STOCK_Q'                     ,  width:80, hidden: true}
          ] ,
          listeners: {
              onGridDblClick: function(grid, record, cellIndex, colName) {
              }
          },
          returnData: function()    {
            var records = this.getSelectedRecords();

           // Ext.each(records, function(record,i) {
                //panelSearch.setValue('OUTSTOCK_NUM', record.data.OUTSTOCK_NUM);
                //UniAppManager.app.onNewDataButtonDown(true);
                UniAppManager.app.fnMakeProductionReceiveDataRef(records);
                //masterGrid.setPurchaseReceiptData(record.data);
           // });
           referData = true;
            this.getStore().remove(records);
        }
    });


    function openSearchInfoWindow() {			// 조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.purchase.issuenosearch" default="출고번호검색"/>',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [releaseNoSearch, releaseNoMasterGrid], //releaseNomasterGrid],
                tbar:  ['->',
			        {
			        	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							releaseNoMasterStore.loadStoreRecords();
						},
						disabled: false
					}, {
						itemId : 'ReleaseNoCloseBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
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
        			 	releaseNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
        			 	releaseNoSearch.setValue('INOUT_CODE_TYPE',panelSearch.getValue('INOUT_CODE_TYPE'));
       			 		releaseNoSearch.setValue('FR_INOUT_DATE',UniDate.get('startOfMonth', panelSearch.getValue('INOUT_DATE')));
       			 		releaseNoSearch.setValue('TO_INOUT_DATE',panelSearch.getValue('INOUT_DATE'));
        		/*	 	releaseNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
			    		releaseNoSearch.setValue('ORDER_PRSN',panelSearch.getValue('ORDER_PRSN'));
			    		releaseNoSearch.setValue('CUSTOM_CODE',panelSearch.getValue('CUSTOM_CODE'));
			    		releaseNoSearch.setValue('CUSTOM_NAME',panelSearch.getValue('CUSTOM_NAME'));
			    		releaseNoSearch.setValue('ORDER_TYPE',panelSearch.getValue('ORDER_TYPE'));
			    		releaseNoSearch.setValue('FR_ORDER_DATE', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE')));
			    		releaseNoSearch.setValue('TO_ORDER_DATE',panelSearch.getValue('ORDER_DATE'));*/
        			 }
                }
			})
		}
		SearchInfoWindow.show();
		SearchInfoWindow.center();
    }

    function openRefSearchWindow() {           // 참조
    	if(!UniAppManager.app.checkForNewDetail()) return false;

        if(!RefSearchWindow) {
            RefSearchWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.purchase.issuerequestrefer" default="출고요청 참조"/>',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [refSearch, refSearchGrid],
                tbar:  ['->',
                    {   itemId : 'saveBtn',
                        text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
                        handler: function() {
                            refSearchMasterStore.loadStoreRecords();
                        },
                        disabled: false
                    },{ itemId : 'confirmBtn',
                        text: '<t:message code="system.label.purchase.apply" default="적용"/>',
                        handler: function() {
                            refSearchGrid.returnData();
                        },
                        disabled: false
                    },{ itemId : 'confirmCloseBtn',
                        text: '<t:message code="system.label.purchase.afterapplyclose" default="적용 후 닫기"/>',
                        handler: function() {
                            refSearchGrid.returnData();
                            RefSearchWindow.hide();
                            UniAppManager.setToolbarButtons('reset', true)
                        },
                        disabled: false
                    },{
                        itemId : 'closeBtn',
                        text: '<t:message code="system.label.purchase.close" default="닫기"/>',
                        handler: function() {
                            RefSearchWindow.hide();
                            UniAppManager.setToolbarButtons('reset', true)
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                        refSearch.clearForm();
                        refSearchGrid.reset();
                    },
                    beforeclose: function( panel, eOpts )   {
                        refSearch.clearForm();
                        refSearchGrid.reset();
                    },
                    beforeshow: function( panel, eOpts )  {
                        refSearch.setValue('REQ_FR_DATE', UniDate.get('today'));
                        refSearch.setValue('REQ_TO_DATE', UniDate.get('today'));
                    }
                }
            })
        }
        RefSearchWindow.show();
        RefSearchWindow.center();
    }

    function openRefSearchWindow2() {           // 참조2
        if(!UniAppManager.app.checkForNewDetail()) return false;

        if(!RefSearchWindow2) {
            RefSearchWindow2 = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.purchase.returnavaiablerequestrefer" default="반품가능요청 참조"/>',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [refSearch2, refSearchGrid2],
                tbar:  ['->',
                    {   itemId : 'saveBtn',
                        text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
                        handler: function() {
                            refSearchMasterStore2.loadStoreRecords();
                        },
                        disabled: false
                    },{ itemId : 'confirmBtn',
                        text: '<t:message code="system.label.purchase.apply" default="적용"/>',
                        handler: function() {
                            refSearchGrid2.returnData();
                        },
                        disabled: false
                    },{ itemId : 'confirmCloseBtn',
                        text: '<t:message code="system.label.purchase.afterapplyclose" default="적용 후 닫기"/>',
                        handler: function() {
                            refSearchGrid2.returnData();
                            RefSearchWindow2.hide();
                            UniAppManager.setToolbarButtons('reset', true)
                        },
                        disabled: false
                    },{
                        itemId : 'closeBtn',
                        text: '<t:message code="system.label.purchase.close" default="닫기"/>',
                        handler: function() {
                            RefSearchWindow2.hide();
                            UniAppManager.setToolbarButtons('reset', true)
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                        refSearch2.clearForm();
                        refSearchGrid2.reset();
                    },
                    beforeclose: function( panel, eOpts )   {
                        refSearch2.clearForm();
                        refSearchGrid2.reset();
                    },
                    beforeshow: function( panel, eOpts )  {

                    }
                }
            })
        }
        RefSearchWindow2.show();
        RefSearchWindow2.center();
    }
    function openPurchaseReceiptWindow() {      // 구매입고참조
    	if(!UniAppManager.app.checkForNewDetail()) return false;

        if(!purchaseReceiptWindow) {
        	purchaseReceiptWindow = Ext.create('widget.uniDetailWindow', {
                title: '입고참조',
                width: 950,
                height: 480,
                layout:{type:'vbox', align:'stretch'},

                items: [purchaseReceiptSearch, purchaseReceiptGrid],
                tbar:  ['->',
                    {   itemId : 'saveBtn',
                        text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
                        handler: function() {
                            purchaseReceiptStore.loadStoreRecords();
                        },
                        disabled: false
                    },{ itemId : 'confirmBtn',
                        text: '적용',
                        handler: function() {
                            purchaseReceiptGrid.returnData();
                        },
                        disabled: false
                    },{ itemId : 'confirmCloseBtn',
                        text: '적용 후 닫기',
                        handler: function() {
                            purchaseReceiptGrid.returnData();
                            purchaseReceiptWindow.hide();
                            UniAppManager.setToolbarButtons('reset', true)
                        },
                        disabled: false
                    },{
                        itemId : 'closeBtn',
                        text: '<t:message code="system.label.sales.close" default="닫기"/>',
                        handler: function() {
                        	purchaseReceiptWindow.hide();
                            UniAppManager.setToolbarButtons('reset', true)
                        },
                        disabled: false
                    }
                ],
                listeners : {beforehide: function(me, eOpt)
                    {
                        purchaseReceiptSearch.clearForm();
                        purchaseReceiptGrid.reset();
                    },
                    beforeclose: function(panel, eOpts)
                    {
                        purchaseReceiptSearch.clearForm();
                        purchaseReceiptGrid.reset();
                    },
                    beforeshow: function (me, eOpts)
                    {
                    	purchaseReceiptSearch.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth'));
                    	purchaseReceiptSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));
                    	purchaseReceiptSearch.setValue('WH_CODE', panelResult.getValue('WH_CODE'));
                        purchaseReceiptStore.loadStoreRecords();
                     }
                }
            })
        }
        purchaseReceiptWindow.show();
        purchaseReceiptWindow.center();
    }

    function openProductionReceiptWindow() {      // 생산입고참조
    	if(!UniAppManager.app.checkForNewDetail()) return false;

        if(!productionReceiptWindow) {
        	productionReceiptWindow = Ext.create('widget.uniDetailWindow', {
                title: '생산참조',
                width: 950,
                height: 480,
                layout:{type:'vbox', align:'stretch'},

                items: [productionReceiptSearch, productionReceiptGrid],
                tbar:  ['->',
                    {   itemId : 'saveBtn',
                        text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
                        handler: function() {
                        	productionReceiptStore.loadStoreRecords();
                        },
                        disabled: false
                    },{ itemId : 'confirmBtn',
                        text: '적용',
                        handler: function() {
                        	productionReceiptGrid.returnData();
                        },
                        disabled: false
                    },{ itemId : 'confirmCloseBtn',
                        text: '적용 후 닫기',
                        handler: function() {
                        	productionReceiptGrid.returnData();
                        	productionReceiptWindow.hide();
                            UniAppManager.setToolbarButtons('reset', true)
                        },
                        disabled: false
                    },{
                        itemId : 'closeBtn',
                        text: '<t:message code="system.label.sales.close" default="닫기"/>',
                        handler: function() {
                        	productionReceiptWindow.hide();
                            UniAppManager.setToolbarButtons('reset', true)
                        },
                        disabled: false
                    }
                ],
                listeners : {beforehide: function(me, eOpt)
                    {
                        productionReceiptSearch.clearForm();
                        productionReceiptGrid.reset();
                    },
                    beforeclose: function(panel, eOpts)
                    {
                        productionReceiptSearch.clearForm();
                        productionReceiptGrid.reset();
                    },
                    beforeshow: function (me, eOpts)
                    {
                    	productionReceiptSearch.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth'));
                    	productionReceiptSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));
                    	productionReceiptSearch.setValue('WH_CODE', panelResult.getValue('WH_CODE'));
                    	//20200520 추가
                    	productionReceiptSearch.setValue('WH_CELL_CODE', panelResult.getValue('WH_CELL_CODE'));
                    	productionReceiptStore.loadStoreRecords();
                     }
                }
            })
        }
        productionReceiptWindow.show();
        productionReceiptWindow.center();
    }

    Unilite.Main({
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            masterGrid, panelResult
         ]
      },
         panelSearch
      ],
		id: 'qtr100ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			referData = false;
			this.setDefault();
		},
		onQueryButtonDown: function() {
			var inoutNo = panelSearch.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow()
			} else {
				if(panelSearch.setAllFieldsReadOnly(true) == false){
                    return false;
                }
                if(panelResult.setAllFieldsReadOnly(true) == false){
                    return false;
                }
                var whCode = panelSearch.getValue('WH_CODE');
//                cbStore.loadStoreRecords(whCode);
				directMasterStore1.loadStoreRecords();
			};
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
		onNewDataButtonDown: function(isReff)	{
			if(panelSearch.getValue("INOUT_CODE_TYPE") == '2' && !isReff) {
                 alert('<t:message code="system.message.purchase.message011" default="출고처구분이 창고일경우에는 참조만 가능합니다."/>');
                 return false;
            }
            if(BsaCodeInfo.gsAutoType == "N" && Ext.isEmpty(panelSearch.getValue("OUTSTOCK_NUM"))){
                alert('<t:message code="system.message.purchase.message012" default="출고번호를 입력하십시오."/>');
                return false;
            }

			if(panelSearch.setAllFieldsReadOnly(true) == false){
                return false;
            }
            if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
			 var inoutNum = panelSearch.getValue('INOUT_NUM');
			 var seq = directMasterStore1.max('INOUT_SEQ');
        	 if(!seq){
        	 	seq = 1;
        	 }else{
        	 	seq += 1;
        	 }
        	 var inoutType = '2';
        	 var inoutCodeType = panelSearch.getValue('INOUT_CODE_TYPE');
        	 var whCode = panelSearch.getValue('WH_CODE');
        	 var whCellCode = panelSearch.getValue('WH_CELL_CODE');
        	 var inoutDate = panelSearch.getValue('INOUT_DATE');
        	 var notQ = '0';
        	 var goodStockQ = '0';
        	 var badStockQ = '0';
        	 var inoutQ = '0';
        	 var inoutMeth = '2';
        	 var divCode = panelSearch.getValue('DIV_CODE');
        	 var createLoc = '2';
        	 var inoutPrsn = panelSearch.getValue('INOUT_PRSN');
        	 var itemStatus = '1';
        	 var originalQ = '0';
        	 var inoutTypeDetail = '92';	//gsInoutTypeDetail	??
        	 /*if(BsaCodeInfo.gsSumTypeCell == 'Y'){
        	 	whCellCode = panelSearch.getValue('WH_CELL_CODE');
        	 }*/
        	 var saleDivCode = '*';
        	 var saleCustomCode = '*';
        	 var saleType = '*';
        	 var billType = '*';
        	 var compCode = UserInfo.compCode;
        	 var inoutCode = panelResult.getValue('DEPT_CODE');
             var inoutName = panelResult.getValue('DEPT_NAME');
        	 var r = {
        	    INOUT_NUM: inoutNum,
				INOUT_SEQ: seq,
				INOUT_TYPE: inoutType,
				INOUT_CODE_TYPE: inoutCodeType,
				WH_CODE: whCode,
				WH_CELL_CODE: whCellCode,
				INOUT_DATE: inoutDate,
				NOT_Q: notQ,
				GOOD_STOCK_Q: goodStockQ,
				BAD_STOCK_Q: badStockQ,
				INOUT_Q: inoutQ,
				INOUT_METH: inoutMeth,
				DIV_CODE: divCode,
				CREATE_LOC: createLoc,
				INOUT_PRSN: inoutPrsn,
				ITEM_STATUS: itemStatus,
				ORIGINAL_Q: originalQ,
				INOUT_TYPE_DETAIL: inoutTypeDetail,
				SALE_DIV_CODE: saleDivCode,
        	 	SALE_CUSTOM_CODE: saleCustomCode,
        	 	SALE_TYPE: saleType,
        		BILL_TYPE: billType,
        		COMP_CODE:compCode,
                INOUT_CODE : inoutCode,
                INOUT_NAME2: inoutName
	        };
	        masterGrid.createRow(r);
		},
		onResetButtonDown: function() {
			var inoutPrsn = panelResult.getValue('INOUT_PRSN');
			var whCode = panelResult.getValue('WH_CODE');
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
//			masterGrid.reset();
//			directMasterStore1.clearData();
			directMasterStore1.loadData({});
			panelResult.setValue('INOUT_PRSN',inoutPrsn);
			panelResult.setValue('WH_CODE',whCode);
			this.fnInitBinding();
			  masterGrid.getColumn('INOUT_NAME').setHidden(true);
              masterGrid.getColumn('INOUT_NAME1').setHidden(true);
              masterGrid.getColumn('INOUT_NAME2').setHidden(false);
		},

		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();

			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('ACCOUNT_Q') != 0)
				{
					alert('<t:message code="system.message.purchase.message042" default="매입등록된 자료는 삭제, 수정할 수 없습니다."/>');
				}else{
					masterGrid.deleteSelectedRow();
				}
			}
		},
		//전체삭제
		onDeleteAllButtonDown: function() {
            var records = directMasterStore1.data.items;
            var isNewData = false;
            Ext.each(records, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    if(confirm('<t:message code="system.message.purchase.message008" default="전체삭제 하시겠습니까?"/>')) {		//모두 삭제 됩니다. 전체삭제 하시겠습니까?
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
            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋
                masterGrid.reset();
                UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
            }
        },


        checkForNewDetail:function() {
        	return panelResult.setAllFieldsReadOnly(true);
        	return panelSearch.setAllFieldsReadOnly(true);

        },
        setDefault: function() {
        	var inoutPrsn;
            if(!Ext.isEmpty(BsaCodeInfo.inoutPrsn[0].refCode10)){
                inoutPrsn = UniAppManager.app.fnGetInoutPrsnUserId(UserInfo.userID);      //로그인 아이디에 따른 영업담당자 set
            }
            if(Ext.isEmpty(panelResult.getValue('INOUT_PRSN')) && Ext.isEmpty(inoutPrsn)){
                inoutPrsn = UniAppManager.app.fnGetInoutPrsnDivCode(UserInfo.divCode);      //사업장의 첫번째 영업담당자 set
            }
//            masterGrid.getColumn('INOUT_NAME1').setVisible(true);
//            masterGrid.getColumn('INOUT_NAME2').setVisible(false);
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.setValue('INOUT_PRSN',inoutPrsn);
        	panelResult.setValue('INOUT_PRSN',inoutPrsn);
        	panelSearch.setValue('INOUT_DATE',UniDate.get('today'));
        	panelResult.setValue('INOUT_DATE',UniDate.get('today'));
        	
        	initChk = 'Y';
        	panelSearch.setValue('INOUT_CODE_TYPE','1');
        	panelSearch.getField('INOUT_CODE_TYPE').setReadOnly(true);
        	panelResult.getField('INOUT_CODE_TYPE').setReadOnly(true);
        	//panelResult.setValue('DEPT_CODE','');
            //panelResult.setValue('DEPT_NAME','');
        	initChk = 'N';
//			panelSearch.getForm().wasDirty = false;
//			panelSearch.resetDirtyStatus();
//			UniAppManager.setToolbarButtons('save', false);
		},
		fnGetInoutPrsnUserId: function(subCode){ //로그인 아이디의 영업담당자 가져오기..
            var fRecord ='';
            Ext.each(BsaCodeInfo.inoutPrsn, function(item, i) {
                if(item['refCode10'] == subCode) {
                    fRecord = item['codeNo'];
                    return false;
                }
            });
            return fRecord;
        },
        fnGetInoutPrsnDivCode: function(subCode){   //사업장의 첫번째 영업담당자 가져오기..
            var fRecord ='';
            Ext.each(BsaCodeInfo.inoutPrsn, function(item, i)   {
                if(item['refCode1'] == subCode) {
                    fRecord = item['codeNo'];
                    return false;
                }
            });
            return fRecord;
        },
        setHiddenColumn: function() {
        	console.log("[iniChk3]" + initChk);
        	if(panelSearch.getValue('INOUT_CODE_TYPE') == '3') {
            	masterGrid.getColumn('INOUT_NAME').setHidden(true);
                masterGrid.getColumn('INOUT_NAME1').setHidden(false);
                masterGrid.getColumn('INOUT_NAME2').setHidden(true);
            } else if(panelSearch.getValue('INOUT_CODE_TYPE') == '1'){
                masterGrid.getColumn('INOUT_NAME').setHidden(true);
                masterGrid.getColumn('INOUT_NAME1').setHidden(true);
                masterGrid.getColumn('INOUT_NAME2').setHidden(false);
            } else {
                masterGrid.getColumn('INOUT_NAME').setHidden(false);
                masterGrid.getColumn('INOUT_NAME1').setHidden(true);
                masterGrid.getColumn('INOUT_NAME2').setHidden(true);
            }
            initChk = 'N';
            console.log("[iniChk4]" + initChk);
        },
        setHiddenField: function() {
            if(releaseNoSearch.getValue('INOUT_CODE_TYPE') == '3') {	//출고처구분 작업장
            	releaseNoSearch.down('#workShopP').setHidden(false);//작업장

            	releaseNoSearch.setValue('INOUT_CODE_WH','');
            	releaseNoSearch.down('#inoutWh').setHidden(true);//창고
            	releaseNoSearch.setValue('INOUT_CODE_DEPT','');
            	releaseNoSearch.setValue('INOUT_NAME_DEPT','');
            	releaseNoSearch.down('#deptP').setHidden(true);//부서
            } else if(releaseNoSearch.getValue('INOUT_CODE_TYPE') == '1'){	//출고처구분 부서
            	releaseNoSearch.down('#deptP').setHidden(false);//부서

            	releaseNoSearch.setValue('INOUT_CODE_WH','');
            	releaseNoSearch.down('#inoutWh').setHidden(true);//창고
            	releaseNoSearch.setValue('INOUT_CODE_WORK_SHOP','');
            	releaseNoSearch.setValue('INOUT_NAME_WORK_SHOP','');
            	releaseNoSearch.down('#workShopP').setHidden(true);//작업장

            } else if(releaseNoSearch.getValue('INOUT_CODE_TYPE') == '2'){	//출고처구분 창고
            	releaseNoSearch.down('#inoutWh').setHidden(false);//창고

            	releaseNoSearch.setValue('INOUT_CODE_WORK_SHOP','');
            	releaseNoSearch.setValue('INOUT_NAME_WORK_SHOP','');
            	releaseNoSearch.down('#workShopP').setHidden(true);//작업장
            	releaseNoSearch.setValue('INOUT_CODE_DEPT','');
            	releaseNoSearch.setValue('INOUT_NAME_DEPT','');
            	releaseNoSearch.down('#deptP').setHidden(true);//부서
        	} else {
            	releaseNoSearch.setValue('INOUT_CODE_WORK_SHOP','');
            	releaseNoSearch.setValue('INOUT_NAME_WORK_SHOP','');
            	releaseNoSearch.down('#workShopP').setHidden(true);//작업장
            	releaseNoSearch.setValue('INOUT_CODE_DEPT','');
            	releaseNoSearch.setValue('INOUT_NAME_DEPT','');
            	releaseNoSearch.down('#deptP').setHidden(true);//부서
            	releaseNoSearch.setValue('INOUT_CODE_WH','');
            	releaseNoSearch.down('#inoutWh').setHidden(true);//창고
            }
        },
        cbStockQ: function(provider, params)    {
            var rtnRecord = params.rtnRecord;
            var goodStockQ = Unilite.nvl(provider['GOOD_STOCK_Q'], 0);
            var badtockQ = Unilite.nvl(provider['BAD_STOCK_Q'], 0);
            var inoutP = Unilite.nvl(provider['AVERAGE_P'], 0);
            var inoutI = Unilite.nvl(provider['AVERAGE_P'], 0)  * rtnRecord.get('INOUT_Q');

            rtnRecord.set('GOOD_STOCK_Q', goodStockQ);
            rtnRecord.set('BAD_STOCK_Q', badtockQ);
            rtnRecord.set('INOUT_P', inoutP);
            rtnRecord.set('INOUT_I', inoutI);
        },
        cbStockQ_kd: function(provider, params)    {
            var rtnRecord = params.rtnRecord;
            var pabStockQ = Unilite.nvl(provider['PAB_STOCK_Q'], 0);//가용재고량
            rtnRecord.set('PAB_STOCK_Q', pabStockQ);
        },onNewDataButtonDown2: function(lotValue, isReff) {


        	if(panelSearch.getValue("INOUT_CODE_TYPE") == '2' && !isReff) {
                alert('<t:message code="system.message.purchase.message011" default="출고처구분이 창고일경우에는 참조만 가능합니다."/>');
                return false;
           }
           if(BsaCodeInfo.gsAutoType == "N" && Ext.isEmpty(panelSearch.getValue("OUTSTOCK_NUM"))){
               alert('<t:message code="system.message.purchase.message012" default="출고번호를 입력하십시오."/>');
               return false;
           }

           if(panelSearch.setAllFieldsReadOnly(true) == false){
               return false;
           }
           if(panelResult.setAllFieldsReadOnly(true) == false){
               return false;
           }
           var itemCode   = lotValue.split('|')[0];
           var itemName    = lotValue.split('|')[3];
           var lotNo       = lotValue.split('|')[1];
           var spec        = lotValue.split('|')[4];
           var unit        = lotValue.split('|')[5];
           var inoutQ     = lotValue.split('|')[2];
           var goodStockQ      = lotValue.split('|')[9];
           var badStockQ      = lotValue.split('|')[10];
           var inoutNum = panelSearch.getValue('INOUT_NUM');
            var seq = directMasterStore1.max('INOUT_SEQ');
            if(!seq){
               seq = 1;
            }else{
               seq += 1;
            }
            var inoutType = '2';
            var inoutCodeType = panelSearch.getValue('INOUT_CODE_TYPE');
            var whCode = panelSearch.getValue('WH_CODE');
            var whCellCode = panelSearch.getValue('WH_CELL_CODE');
            var inoutDate = panelSearch.getValue('INOUT_DATE');
            var notQ = '0';
            var inoutMeth = '2';
            var divCode = panelSearch.getValue('DIV_CODE');
            var createLoc = '2';
            var inoutPrsn = panelSearch.getValue('INOUT_PRSN');
            var itemStatus = '1';
            var originalQ = '0';
            var inoutTypeDetail = '92';    //gsInoutTypeDetail ??
            /*if(BsaCodeInfo.gsSumTypeCell == 'Y'){
               whCellCode = panelSearch.getValue('WH_CELL_CODE');
            }*/
            var saleDivCode = '*';
            var saleCustomCode = '*';
            var saleType = '*';
            var billType = '*';
            var compCode = UserInfo.compCode;
            var inoutCode = panelResult.getValue('DEPT_CODE');
            var inoutName = panelResult.getValue('DEPT_NAME');
            var r = {
               INOUT_NUM: inoutNum,
               INOUT_SEQ: seq,
               INOUT_TYPE: inoutType,
               INOUT_CODE_TYPE: inoutCodeType,
               WH_CODE: whCode,
               WH_CELL_CODE: whCellCode,
               INOUT_DATE: inoutDate,
               NOT_Q: notQ,
               GOOD_STOCK_Q: goodStockQ,
               BAD_STOCK_Q: badStockQ,
               INOUT_Q: inoutQ,
               INOUT_METH: inoutMeth,
               DIV_CODE: divCode,
               CREATE_LOC: createLoc,
               INOUT_PRSN: inoutPrsn,
               ITEM_STATUS: itemStatus,
               ORIGINAL_Q: originalQ,
               INOUT_TYPE_DETAIL: inoutTypeDetail,
               SALE_DIV_CODE: saleDivCode,
               SALE_CUSTOM_CODE: saleCustomCode,
               SALE_TYPE: saleType,
               BILL_TYPE: billType,
               COMP_CODE:compCode,
               ITEM_CODE   : itemCode,
               ITEM_NAME   : itemName,
               LOT_NO      : lotNo,
               SPEC        : spec,
               STOCK_UNIT  : unit,
               INOUT_CODE : inoutCode,
               INOUT_NAME2: inoutName
           };
           masterGrid.createRow(r);
           panelResult.getField('BARCODE').focus();
        },
		//구매입고 참조시
		fnMakePurchaseReceiveDataRef: function(records) {
			  if(panelSearch.getValue("INOUT_CODE_TYPE") == '2' && !isReff) {
	                 alert('<t:message code="system.message.purchase.message011" default="출고처구분이 창고일경우에는 참조만 가능합니다."/>');
	                 return false;
	            }
	            if(BsaCodeInfo.gsAutoType == "N" && Ext.isEmpty(panelSearch.getValue("OUTSTOCK_NUM"))){
	                alert('<t:message code="system.message.purchase.message012" default="출고번호를 입력하십시오."/>');
	                return false;
	            }

				if(panelSearch.setAllFieldsReadOnly(true) == false){
	                return false;
	            }
	            if(panelResult.setAllFieldsReadOnly(true) == false){
	                return false;
	            }
				 var inoutNum = panelSearch.getValue('INOUT_NUM');
				 //var seq = directMasterStore1.max('INOUT_SEQ');
				 var newDetailRecords = new Array();
				 var seq = 0;
				 seq =  directMasterStore1.max('INOUT_SEQ');

				 if(Ext.isEmpty(seq)){
					 	seq = 1;
		         }else{
		         		seq = seq + 1;
		         }
				 var inoutType = '2';
	        	 var inoutCodeType = panelSearch.getValue('INOUT_CODE_TYPE');
	        	 var whCode = panelSearch.getValue('WH_CODE');
	        	 var whCellCode = panelSearch.getValue('WH_CELL_CODE');
	        	 var inoutDate = panelSearch.getValue('INOUT_DATE');
	        	 var notQ = '0';
	        	 var goodStockQ = '0';
	        	 var badStockQ = '0';
	        	 var inoutQ = '0';
	        	 var inoutMeth = '2';
	        	 var divCode = panelSearch.getValue('DIV_CODE');
	        	 var createLoc = '2';
	        	 var inoutPrsn = panelSearch.getValue('INOUT_PRSN');
	        	 var itemStatus = '1';
	        	 var originalQ = '0';
	        	 var inoutTypeDetail = '92';	//gsInoutTypeDetail	??
	        	 /*if(BsaCodeInfo.gsSumTypeCell == 'Y'){
	        	 	whCellCode = panelSearch.getValue('WH_CELL_CODE');
	        	 }*/
	        	 var saleDivCode = '*';
	        	 var saleCustomCode = '*';
	        	 var saleType = '*';
	        	 var billType = '*';
	        	 var compCode = UserInfo.compCode;
	        	 var inoutCode = panelResult.getValue('DEPT_CODE');
	             var inoutName = panelResult.getValue('DEPT_NAME');

				Ext.each(records, function(record,i) {
					if(i == 0){
						 seq = seq;
		        	 }else{
		        		 seq += 1;
		        	 }
					goodStockQ = record.get('GOOD_STOCK_Q');
					badStockQ = record.get('BAD_STOCK_Q');
				 	console.log("[goodStockQ]" + goodStockQ);
				 	console.log("[badStockQ]" + badStockQ);
					 var r = {
				        	    'INOUT_NUM': inoutNum,
								'INOUT_SEQ': seq,
								'INOUT_TYPE': inoutType,
								'INOUT_CODE_TYPE': inoutCodeType,
								'WH_CODE': whCode,
								'WH_CELL_CODE': whCellCode,
								'INOUT_DATE': inoutDate,
								'NOT_Q': notQ,
								'GOOD_STOCK_Q': goodStockQ,
								'BAD_STOCK_Q': badStockQ,
								'INOUT_Q': inoutQ,
								'INOUT_METH': inoutMeth,
								'DIV_CODE': divCode,
								'CREATE_LOC': createLoc,
								'INOUT_PRSN': inoutPrsn,
								'ITEM_STATUS': itemStatus,
								'ORIGINAL_Q': originalQ,
								'INOUT_TYPE_DETAIL': inoutTypeDetail,
								'SALE_DIV_CODE': saleDivCode,
				        	 	'SALE_CUSTOM_CODE': saleCustomCode,
				        	 	'SALE_TYPE': saleType,
				        		'BILL_TYPE': billType,
				        		'COMP_CODE':compCode,
				                'INOUT_CODE' : inoutCode,
				                'INOUT_NAME2': inoutName
					        };
							newDetailRecords[i] = directMasterStore1.model.create( r );
					        newDetailRecords[i].set('ITEM_CODE'               , record.get('ITEM_CODE'));
				            newDetailRecords[i].set('ITEM_NAME'               , record.get('ITEM_NAME'));
				            newDetailRecords[i].set('LOT_NO'                  , record.get('LOT_NO'));
				            newDetailRecords[i].set('INOUT_Q'                 , record.get('INOUT_Q'));
				            newDetailRecords[i].set('LOT_YN'                  , record.get('LOT_YN'));
				            newDetailRecords[i].set('STOCK_UNIT'              , record.get('STOCK_UNIT'));
				            newDetailRecords[i].set('SPEC'                    , record.get('SPEC'));
				            newDetailRecords[i].set('BASIS_NUM'                    , record.get('BASIS_NUM'));
				            newDetailRecords[i].set('BASIS_SEQ'                    , record.get('BASIS_SEQ'));

				          //  UniMatrl.fnStockQ(newDetailRecords[i], UniAppManager.app.cbStockQ, UserInfo.compCode, newDetailRecords[i].get('DIV_CODE'), null, newDetailRecords[i].get('ITEM_CODE'),newDetailRecords[i].get('WH_CODE') );
				});
							directMasterStore1.loadData(newDetailRecords, true);
		},
		//생산입고 참조시
		fnMakeProductionReceiveDataRef: function(records) {
			  if(panelSearch.getValue("INOUT_CODE_TYPE") == '2' && !isReff) {
	                 alert('<t:message code="system.message.purchase.message011" default="출고처구분이 창고일경우에는 참조만 가능합니다."/>');
	                 return false;
	            }
	            if(BsaCodeInfo.gsAutoType == "N" && Ext.isEmpty(panelSearch.getValue("OUTSTOCK_NUM"))){
	                alert('<t:message code="system.message.purchase.message012" default="출고번호를 입력하십시오."/>');
	                return false;
	            }

				if(panelSearch.setAllFieldsReadOnly(true) == false){
	                return false;
	            }
	            if(panelResult.setAllFieldsReadOnly(true) == false){
	                return false;
	            }
				 var inoutNum = panelSearch.getValue('INOUT_NUM');
				 //var seq = directMasterStore1.max('INOUT_SEQ');
				 var newDetailRecords = new Array();
				 var seq = 0;
				 seq =  directMasterStore1.max('INOUT_SEQ');

				 if(Ext.isEmpty(seq)){
					 	seq = 1;
		         }else{
		         		seq = seq + 1;
		         }
				 var inoutType = '2';
	        	 var inoutCodeType = panelSearch.getValue('INOUT_CODE_TYPE');
	        	 var whCode = "";
	        	 var whCellCode = '';
	        	 var inoutDate = panelSearch.getValue('INOUT_DATE');
	        	 var notQ = '0';
	        	 var goodStockQ = '0';
	        	 var badStockQ = '0';
	        	 var inoutQ = '0';
	        	 var inoutMeth = '2';
	        	 var divCode = panelSearch.getValue('DIV_CODE');
	        	 var createLoc = '2';
	        	 var inoutPrsn = panelSearch.getValue('INOUT_PRSN');
	        	 var itemStatus = '1';
	        	 var originalQ = '0';
	        	 var inoutTypeDetail = '92';	//gsInoutTypeDetail	??
	        	 /*if(BsaCodeInfo.gsSumTypeCell == 'Y'){
	        	 	whCellCode = panelSearch.getValue('WH_CELL_CODE');
	        	 }*/
	        	 var saleDivCode = '*';
	        	 var saleCustomCode = '*';
	        	 var saleType = '*';
	        	 var billType = '*';
	        	 var compCode = UserInfo.compCode;
	        	 var inoutCode = panelResult.getValue('DEPT_CODE');
	             var inoutName = panelResult.getValue('DEPT_NAME');

				Ext.each(records, function(record,i) {
					if(i == 0){
						 seq = seq;
		        	 }else{
		        		 seq += 1;
		        	 }
					 whCode = record.get('WH_CODE');
					 whCellCode = record.get('WH_CELL_CODE');
					 var r = {
				        	    'INOUT_NUM': inoutNum,
								'INOUT_SEQ': seq,
								'INOUT_TYPE': inoutType,
								'INOUT_CODE_TYPE': inoutCodeType,
								'WH_CODE': whCode,
								'WH_CELL_CODE': whCellCode,
								'INOUT_DATE': inoutDate,
								'NOT_Q': notQ,
								'GOOD_STOCK_Q': goodStockQ,
								'BAD_STOCK_Q': badStockQ,
								'INOUT_Q': inoutQ,
								'INOUT_METH': inoutMeth,
								'DIV_CODE': divCode,
								'CREATE_LOC': createLoc,
								'INOUT_PRSN': inoutPrsn,
								'ITEM_STATUS': itemStatus,
								'ORIGINAL_Q': originalQ,
								'INOUT_TYPE_DETAIL': inoutTypeDetail,
								'SALE_DIV_CODE': saleDivCode,
				        	 	'SALE_CUSTOM_CODE': saleCustomCode,
				        	 	'SALE_TYPE': saleType,
				        		'BILL_TYPE': billType,
				        		'COMP_CODE':compCode,
				                'INOUT_CODE' : inoutCode,
				                'INOUT_NAME2': inoutName
					        };
							newDetailRecords[i] = directMasterStore1.model.create( r );
					        newDetailRecords[i].set('ITEM_CODE'               , record.get('ITEM_CODE'));
				            newDetailRecords[i].set('ITEM_NAME'               , record.get('ITEM_NAME'));
				            newDetailRecords[i].set('LOT_NO'                  , record.get('LOT_NO'));
				            newDetailRecords[i].set('INOUT_Q'                 , record.get('INOUT_Q'));
				            newDetailRecords[i].set('LOT_YN'                  , record.get('LOT_YN'));
				            newDetailRecords[i].set('STOCK_UNIT'              , record.get('STOCK_UNIT'));
				            newDetailRecords[i].set('SPEC'                    , record.get('SPEC'));
				            newDetailRecords[i].set('BASIS_NUM'                    , record.get('BASIS_NUM'));
				            newDetailRecords[i].set('BASIS_SEQ'                    , record.get('BASIS_SEQ'));

				            UniMatrl.fnStockQ(newDetailRecords[i], UniAppManager.app.cbStockQ, UserInfo.compCode, newDetailRecords[i].get('DIV_CODE'), null, newDetailRecords[i].get('ITEM_CODE'),newDetailRecords[i].get('WH_CODE') );
				});
							directMasterStore1.loadData(newDetailRecords, true);
		}
        	/*,
        fnWorkShopChange: function(records) {
            grdRecord = masterGrid.getSelectedRecord();
            record = records[0];
            grdRecord.set('INOUT_CODE', record.TREE_CODE);
            grdRecord.set('INOUT_NAME', record.TREE_NAME);
            if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
                grdRecord.set('DIV_CODE', record.TYPE_LEVEL);
            }
        },
        fnDeptCodeChange: function(records) {
            grdRecord = masterGrid.getSelectedRecord();
            record = records[0];
            grdRecord.set('INOUT_CODE', record.TREE_CODE);
            grdRecord.set('INOUT_NAME', record.TREE_NAME);
            if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
                grdRecord.set('DIV_CODE', record.TYPE_LEVEL);
            }
        }*/
	});//End of Unilite.Main( {

	//바코드 입력 로직 (lot_no)
    function fnEnterBarcode(newValue) {
        var barcodeItemCode = newValue.split('|')[0].toUpperCase();
        var barcodeLotNo    = newValue.split('|')[1];
        var barcodeInoutQ   = newValue.split('|')[2];
        var flag = true;

        if(!Ext.isEmpty(barcodeLotNo)) {
            barcodeLotNo = barcodeLotNo.toUpperCase();
        } else {
            barcodeItemCode = '';
            barcodeLotNo    = newValue.split('|')[0].toUpperCase();
            barcodeInoutQ   = 0;
        }

        //동일한 LOT_NO 입력되었을 경우 처리
        var records  = directMasterStore1.data.items;       //비교할 records 구성
        Ext.each(records, function(record, i) {
            if(record.get('LOT_NO').toUpperCase() == barcodeLotNo && record.get('ITEM_CODE') == barcodeItemCode) {
                beep();
                gsText = '<t:message code="system.label.sales.message005" default="동일한  Lot No.(이)가 이미 등록되었습니다."/>'
                openAlertWindow(gsText);
                panelResult.setValue('BARCODE', '');
                panelResult.getField('WH_CODE').focus();
                flag = false;
                return false;
            }
        });

        var param = {
            ITEM_CODE       : barcodeItemCode,
            LOT_NO          : barcodeLotNo,
            ORDER_UNIT_Q    : barcodeInoutQ,
            WH_CODE         : panelResult.getValue('WH_CODE'),
            DIV_CODE        : panelResult.getValue('DIV_CODE')
        }
        qtr100ukrvService.getFifo(param, function(provider2, response){
            if(!Ext.isEmpty(provider2[0].ERR_MSG)) {
                beep();
                gsText = provider2[0].ERR_MSG;
                openAlertWindow(gsText);
                panelResult.setValue('BARCODE', '');
                panelResult.getField('BARCODE').focus();
                return false;
            };
            Ext.each(records, function(record,j) {
                if(record.get('LOT_NO').toUpperCase() == provider2[0].NEWVALUE.split('|')[1] && record.get('ITEM_CODE') == provider2[0].NEWVALUE.split('|')[0]) {
                    beep();
                    gsText = '<t:message code="system.label.sales.message005" default="동일한  Lot No.(이)가 이미 등록되었습니다."/>'
                    openAlertWindow(gsText);
                    flag = false;
                    panelResult.setValue('BARCODE', '');
                    panelResult.getField('BARCODE').focus();
                    flag = false;
                    return false;
                }
            });
            panelResult.getField('BARCODE').focus();
            if(flag) {
                UniAppManager.app.onNewDataButtonDown2(provider2[0].NEWVALUE);
                return;
            }
        });
    }

  //경고창
    var alertSearch = Unilite.createSearchForm('alertSearch', {
        layout  : {type : 'uniTable', columns : 1
        , tdAttrs: {width: '100%', align : 'center', style: 'background-color: #dfe8f6;'}       //cfd9e7
        },
        items   :[{
            xtype   : 'component',
            itemId  : 'TEXT_TEST',
            width   : 330,
            height  : 50,
            html    : '',
            style   : {
                marginTop   : '3px !important',
                font        : '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
            }
        },{
            xtype   : 'container',
            padding : '0 0 0 0',
            align   : 'center',
            items   : [{
                xtype   : 'button',
                text    : '<t:message code="system.label.sales.confirm" default="확인"/>',
                width   : 80,
                handler : function() {
                    alertWindow.hide();
                },
                disabled: false
            }]
        }]
    });
    
    function openAlertWindow() {
        if(!alertWindow) {
            alertWindow = Ext.create('widget.uniDetailWindow', {
                title   : '<t:message code="system.label.sales.warntitle" default="경고"/>',
                width   : 350,
                height  : 120,
                layout  : {type:'vbox', align:'stretch'},
                items   : [alertSearch],
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
                    specialkey:function(field, event)   {
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

    function beep() {
        audioCtx = new(window.AudioContext || window.webkitAudioContext)();

        var oscillator = audioCtx.createOscillator();
        var gainNode = audioCtx.createGain();

        oscillator.connect(gainNode);
        gainNode.connect(audioCtx.destination);

        gainNode.gain.value = 0.1;              //VOLUME 크기
        oscillator.frequency.value = 4100;
        oscillator.type = 'sine';               //sine, square, sawtooth, triangle

        oscillator.start();

        setTimeout(
            function() {
              oscillator.stop();
            },
            1000                                    //길이
        );
    };





	Unilite.createValidator('validator01', {
	store: directMasterStore1,
	grid: masterGrid,
	validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
	console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
		var rv = true;
		switch(fieldName) {

		case "INOUT_TYPE_DETAIL":
			var param = {"INOUT_TYPE_DETAIL": newValue};
			qtr100ukrvService.selectInoutType(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					record.set('INOUT_TYPE','3');
				}else{
					record.set('INOUT_TYPE','2');
				}
			});
			break;


			case "INOUT_SEQ":
				if(newValue <= '0'){
					rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
				}else if(clng(grdsheet1.TextMatrix(lRow,lCol)) != fnCDbl(grdsheet1.TextMatrix(lRow,lCol))){ //?
					rv='<t:message code="system.message.purchase.message072" default="정수만 입력 가능합니다."/>';
				}
				break;

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
//                cbStore.loadStoreRecords(newValue);
//                UniAppManager.setToolbarButtons('save', true);
                break;

            case "WH_CELL_CODE" :
                record.set('WH_CELL_CODE', e.column.field.getRawValue());
                break;

				//추가

				if(record.get('CREATE_LOC') != '3'){
					if(newValue > 0 && record.get('BASIS_NUM') > ''){	// ''보다 크면??
						if(record.get('INOUT_Q') > (record.get('ORIGINAL_Q') + record.get('NOT_Q'))){
							rv='<t:message code="unilite.msg.sMM337"/>';
						}
					}
				}
            case "INOUT_Q" :
                if(newValue < 0 && !Ext.isEmpty(newValue))  {
                    rv=Msg.sMB076;
                    break;
                }
                if(record.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
                	var sInout_q = newValue;    //출고량
                    var sInv_q = record.get('PAB_STOCK_Q'); //가용재고량
                    var sOriginQ = record.get('ORIGINAL_Q'); //출고량(원)
                    if(sInout_q > (sInv_q + sOriginQ)){
                        rv='<t:message code="system.message.purchase.message014" default="출고량은 가용재고량을 초과할 수 없습니다."/>';  //출고량은 재고량을 초과할 수 없습니다.
                        break;
                    }
                }
                if(isCheckStockYn){   //예외 출고 및 가용재고체크 사용할시
	                var sInout_q = newValue;    //출고량
	                var sInv_q = record.get('ITEM_STATUS') == "1"? record.get('GOOD_STOCK_Q') : record.get('BAD_STOCK_Q');  //재고량
	                var sOriginQ = record.get('ORIGINAL_Q'); //출고량(원)

	                if(sInout_q > (sInv_q + sOriginQ)){
	                    rv='<t:message code="system.message.purchase.message036" default="출고량은 재고량을 초과할 수 없습니다."/>';  //출고량은 재고량을 초과할 수 없습니다.
	                    break;
	                }
                }
	            break;
				//추가

/*			case "PROJECT_NO":
				UniAppManager.app.fnPlanNumChange();	//함수생성해야함

			case "LOT_NO":
				//소스분석안됨
			case "ORDER_NUM":
				UniAppManager.app.fnWkPlanChange();		//함수생성해야함
*/
		}
			return rv;
					}
		});
};
</script>