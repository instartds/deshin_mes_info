<%--
'   프로그램명 : 입고현황조회 (구매재고)
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
<t:appConfig pgmId="s_mtr110skrv_yp"  >
   <t:ExtComboStore comboType="BOR120"  />          <!-- 사업장 -->
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
	gsInOutPrsn: '${gsInOutPrsn}'
};
function appMain() {
   /**
    *   Model 정의
    * @type
    */

	Unilite.defineModel('s_mtr110skrv_ypModel1', {
		fields: [
			{name: 'ITEM_LEVEL1'		    , text: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>'				, type: 'string'},
            {name: 'ITEM_LEVEL2'		    , text: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>'				, type: 'string'},
            {name: 'ITEM_LEVEL3'		    , text: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>'				, type: 'string'},
            {name: 'INDEX01'		        , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},//ITEM_CODE
            {name: 'INDEX02'		        , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},//ITEM_NAME
            {name: 'BARCODE'		        , text: '바코드'				, type: 'string'},
            {name: 'INDEX03'		        , text: '<t:message code="system.label.purchase.spec" default="규격"/>'				    , type: 'string'},//SPEC
            {name: 'INDEX04'	    	    , text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate'},//INOUT_DATE
            {name: 'INDEX05'	            , text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},//INOUT_CODE
            {name: 'INDEX06'				, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},//CUSTOM_NAME
            {name: 'INOUT_Q'			    , text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				, type: 'uniQty'},
            {name: 'INOUT_P'			    , text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'				, type: 'uniUnitPrice'},
            {name: 'INOUT_I'			    , text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'				, type: 'uniPrice'},
            {name: 'EXPENSE_I'			    , text: '수입부대비'			, type: 'uniPrice'},
            {name: 'INOUT_I_TOTAL'		    , text: '합계금액(부대비포함)'	, type: 'uniPrice'},
            {name: 'TAX_TYPE'               , text: '과세여부'             , type: 'string', comboType: "AU", comboCode: "B059"},
            {name: 'INOUT_FOR_P'	        , text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>'				, type: 'uniFC'},
            {name: 'INOUT_FOR_O'	        , text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>'				, type: 'uniFC'},
            {name: 'MONEY_UNIT'			    , text: '통화'				    , type: 'string'},
            {name: 'EXCHG_RATE_O'		    , text: '입고환율'				, type: 'uniER'},
            {name: 'STOCK_UNIT'			    , text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'				, type: 'string'},
            {name: 'WH_CODE'			    , text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'				, type: 'string'},
            {name: 'INOUT_PRSN'			    , text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'				, type: 'string'},
            {name: 'INOUT_NUM'			    , text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string'},
            {name: 'INOUT_METH'			    , text: '수불방법'				, type: 'string'},
            {name: 'INOUT_TYPE_DETAIL'		, text: '수불유형'				, type: 'string'},
            {name: 'ORDER_DATE'			    , text: '<t:message code="system.label.purchase.podate" default="발주일"/>'				, type: 'uniDate'},
            {name: 'ORDER_NUM'			    , text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
            {name: 'ORDER_SEQ'			    , text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'				, type: 'int'},
            {name: 'ORDER_UNIT_Q'	       ,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'              ,type: 'uniQty'},
            {name: 'ORDER_UNIT'		       ,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'             ,type: 'string' ,comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank: false},
            {name: 'TRNS_RATE'		       ,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'               ,type: 'string'},
            {name: 'ORDER_UNIT_P'	       ,text: '<t:message code="system.label.purchase.price" default="단가"/>'               ,type: 'uniUnitPrice'},
            {name: 'DVRY_DATE'			    , text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				, type: 'uniDate'},
            {name: 'BUY_Q'				    , text: '<t:message code="system.label.purchase.purchaseqty" default="매입량"/>'				, type: 'uniQty'},
            {name: 'REMARK'				    , text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				    , type: 'string'},
            {name: 'PROJECT_NO'			    , text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
            {name: 'LOT_NO'			        , text: 'LOT NO'				, type: 'string'},
            {name: 'LC_NUM'				    , text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
            {name: 'BL_NUM'				    , text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'				, type: 'string'},
            {name: 'CREATE_LOC'			    , text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'				, type: 'string'},
            {name: 'DIV_CODE'			    , text: '<t:message code="system.label.purchase.division" default="사업장"/>'				, type: 'string'},
            {name: 'UPDATE_DB_TIME'		    , text: '등록일시'				, type: 'uniDate'},
            {name: 'FARM_CODE'			    , text: '농가코드'				, type: 'string'},
            {name: 'FARM_NAME'	            , text:  '농가명'					, type: 'string'},
            {name: 'ORIGIN'                 , text:  '원산지'                 , type: 'string'},
            {name: 'TRNS_RATE_IN'		       ,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'               ,type: 'string'}
		]
	});
	Unilite.defineModel('s_mtr110skrv_ypModel2', {
		fields: [
			{name: 'ITEM_LEVEL1'		    , text: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>'				, type: 'string'},
            {name: 'ITEM_LEVEL2'		    , text: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>'				, type: 'string'},
            {name: 'ITEM_LEVEL3'		    , text: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>'				, type: 'string'},
            {name: 'INDEX01'		        , text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},//INOUT_CODE
            {name: 'INDEX02'		        , text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},//CUSTOM_NAME
            {name: 'BARCODE'		        , text: '바코드'				, type: 'string'},
            {name: 'INDEX03'		        , text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate'},//INOUT_DATE
            {name: 'INDEX04'	    	    , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},//ITEM_CODE
            {name: 'INDEX05'	            , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},//ITEM_NAME
            {name: 'INDEX06'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				    , type: 'string'},//SPEC
            {name: 'INOUT_Q'			    , text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				, type: 'uniQty'},
            {name: 'INOUT_P'			    , text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'				, type: 'uniUnitPrice'},
            {name: 'INOUT_I'			    , text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'				, type: 'uniPrice'},
            {name: 'EXPENSE_I'			    , text: '수입부대비'			, type: 'uniPrice'},
            {name: 'INOUT_I_TOTAL'		    , text: '합계금액(부대비포함)'	, type: 'uniPrice'},
            {name: 'TAX_TYPE'               , text: '과세여부'             , type: 'string', comboType: "AU", comboCode: "B059"},
            {name: 'INOUT_FOR_P'	        , text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>'				, type: 'uniFC'},
            {name: 'INOUT_FOR_O'	        , text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>'				, type: 'uniFC'},
            {name: 'MONEY_UNIT'			    , text: '통화'				    , type: 'string'},
            {name: 'EXCHG_RATE_O'		    , text: '입고환율'				, type: 'uniER'},
            {name: 'STOCK_UNIT'			    , text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'				, type: 'string'},
            {name: 'WH_CODE'			    , text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'				, type: 'string'},
            {name: 'INOUT_PRSN'			    , text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'				, type: 'string'},
            {name: 'INOUT_NUM'			    , text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string'},
            {name: 'INOUT_METH'			    , text: '수불방법'				, type: 'string'},
            {name: 'INOUT_TYPE_DETAIL'		, text: '수불유형'				, type: 'string'},
            {name: 'ORDER_DATE'			    , text: '<t:message code="system.label.purchase.podate" default="발주일"/>'				, type: 'uniDate'},
            {name: 'ORDER_NUM'			    , text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
            {name: 'ORDER_SEQ'			    , text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'				, type: 'int'},
            {name: 'ORDER_UNIT_Q'	       ,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'              ,type: 'uniQty'},
            {name: 'ORDER_UNIT'		       ,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'             ,type: 'string' ,comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank: false},
            {name: 'TRNS_RATE'		       ,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'               ,type: 'string'},
            {name: 'ORDER_UNIT_P'	       ,text: '<t:message code="system.label.purchase.price" default="단가"/>'               ,type: 'uniUnitPrice'},
            {name: 'DVRY_DATE'			    , text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				, type: 'uniDate'},
            {name: 'BUY_Q'				    , text: '<t:message code="system.label.purchase.purchaseqty" default="매입량"/>'				, type: 'uniQty'},
            {name: 'REMARK'				    , text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				    , type: 'string'},
            {name: 'PROJECT_NO'			    , text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
            {name: 'LOT_NO'			        , text: 'LOT NO'				, type: 'string'},
            {name: 'LC_NUM'				    , text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
            {name: 'BL_NUM'				    , text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'				, type: 'string'},
            {name: 'CREATE_LOC'			    , text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'				, type: 'string'},
            {name: 'DIV_CODE'			    , text: '<t:message code="system.label.purchase.division" default="사업장"/>'				, type: 'string'},
            {name: 'UPDATE_DB_TIME'		    , text: '등록일시'				, type: 'uniDate'},
            {name: 'FARM_CODE'			    , text: '농가코드'				, type: 'string'},
            {name: 'FARM_NAME'			 , text:  '농가명'					, type: 'string'},
            {name: 'ORIGIN'                 , text:  '원산지'                 , type: 'string'},
            {name: 'TRNS_RATE_IN'		       ,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'               ,type: 'string'}
		]
	});
   Unilite.defineModel('s_mtr110skrv_ypModel3', {
		fields: [
			{name: 'ITEM_LEVEL1'		    , text: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>'				, type: 'string'},
            {name: 'ITEM_LEVEL2'		    , text: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>'				, type: 'string'},
            {name: 'ITEM_LEVEL3'		    , text: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>'				, type: 'string'},
            {name: 'INDEX01'		        , text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},//INOUT_CODE
            {name: 'INDEX02'		        , text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},//CUSTOM_NAME
            {name: 'BARCODE'		        , text: '바코드'				, type: 'string'},
            {name: 'INDEX06'		        , text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate'},//INOUT_DATE
            {name: 'INDEX03'	    	    , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},//ITEM_CODE
            {name: 'INDEX04'	            , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},//ITEM_NAME
            {name: 'INDEX05'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				    , type: 'string'},//SPEC
            {name: 'INOUT_Q'			    , text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				, type: 'uniQty'},
            {name: 'INOUT_P'			    , text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'				, type: 'uniUnitPrice'},
            {name: 'INOUT_I'			    , text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'				, type: 'uniPrice'},
            {name: 'EXPENSE_I'			    , text: '수입부대비'			, type: 'uniPrice'},
            {name: 'INOUT_I_TOTAL'		    , text: '합계금액(부대비포함)'	, type: 'uniPrice'},
            {name: 'TAX_TYPE'               , text: '과세여부'             , type: 'string', comboType: "AU", comboCode: "B059"},
            {name: 'INOUT_FOR_P'	        , text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>'				, type: 'uniFC'},
            {name: 'INOUT_FOR_O'	        , text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>'				, type: 'uniFC'},
            {name: 'MONEY_UNIT'			    , text: '통화'				    , type: 'string'},
            {name: 'EXCHG_RATE_O'		    , text: '입고환율'				, type: 'uniER'},
            {name: 'STOCK_UNIT'			    , text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'				, type: 'string'},
            {name: 'WH_CODE'			    , text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'				, type: 'string'},
            {name: 'INOUT_PRSN'			    , text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'				, type: 'string'},
            {name: 'INOUT_NUM'			    , text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string'},
            {name: 'INOUT_METH'			    , text: '수불방법'				, type: 'string'},
            {name: 'INOUT_TYPE_DETAIL'		, text: '수불유형'				, type: 'string'},
            {name: 'ORDER_DATE'			    , text: '<t:message code="system.label.purchase.podate" default="발주일"/>'				, type: 'uniDate'},
            {name: 'ORDER_NUM'			    , text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
            {name: 'ORDER_SEQ'			    , text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'				, type: 'int'},
            {name: 'ORDER_UNIT_Q'	       ,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'              ,type: 'uniQty'},
            {name: 'ORDER_UNIT'		       ,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'             ,type: 'string' ,comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank: false},
            {name: 'TRNS_RATE'		       ,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'               ,type: 'string'},
            {name: 'ORDER_UNIT_P'	       ,text: '<t:message code="system.label.purchase.price" default="단가"/>'               ,type: 'uniUnitPrice'},
            {name: 'DVRY_DATE'			    , text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				, type: 'uniDate'},
            {name: 'BUY_Q'				    , text: '<t:message code="system.label.purchase.purchaseqty" default="매입량"/>'				, type: 'uniQty'},
            {name: 'REMARK'				    , text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				    , type: 'string'},
            {name: 'PROJECT_NO'			    , text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
            {name: 'LOT_NO'			        , text: 'LOT NO'				, type: 'string'},
            {name: 'LC_NUM'				    , text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
            {name: 'BL_NUM'				    , text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'				, type: 'string'},
            {name: 'CREATE_LOC'			    , text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'				, type: 'string'},
            {name: 'DIV_CODE'			    , text: '<t:message code="system.label.purchase.division" default="사업장"/>'				, type: 'string'},
            {name: 'UPDATE_DB_TIME'		    , text: '등록일시'				, type: 'uniDate'},
            {name: 'FARM_CODE'			    , text: '농가코드'				, type: 'string'},
            {name: 'FARM_NAME'			 , text:  '농가명'					, type: 'string'},
            {name: 'ORIGIN'                 , text:  '원산지'                 , type: 'string'},
            {name: 'TRNS_RATE_IN'		       ,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'               ,type: 'string'}
		]
	});
   var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_mtr110skrv_ypService.selectList'
		}
	});
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_mtr110skrv_ypService.selectList'
		}
	});
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_mtr110skrv_ypService.selectList'
		}
	});
   /**
    * Store 정의(Service 정의)
    * @type
    */
	var directMasterStore1 = Unilite.createStore('s_mtr110skrv_ypMasterStore1',{
		model: 's_mtr110skrv_ypModel1',
		uniOpt: {
			isMaster: false,         // 상위 버튼 연결
			editable: false,         // 수정 모드 사용
			deletable:false,         // 삭제 가능 여부
			useNavi : false         // prev | newxt 버튼 사용
		},
			autoLoad: false,
			proxy: directProxy1,
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
		groupField: 'INDEX02'
	});//End of var directMasterStore1 = Unilite.createStore('s_mtr110skrv_ypMasterStore1',{

	var directMasterStore2 = Unilite.createStore('s_mtr110skrv_ypMasterStore2',{
		model: 's_mtr110skrv_ypModel2',
		uniOpt: {
			isMaster: false,         // 상위 버튼 연결
			editable: false,         // 수정 모드 사용
			deletable:false,         // 삭제 가능 여부
			useNavi : false         // prev | newxt 버튼 사용
		},
			autoLoad: false,
			proxy: directProxy2,
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
		groupField: 'INDEX02'
	});

	var directMasterStore3 = Unilite.createStore('s_mtr110skrv_ypMasterStore3',{
		model: 's_mtr110skrv_ypModel3',
		uniOpt: {
			isMaster: false,         // 상위 버튼 연결
			editable: false,         // 수정 모드 사용
			deletable:false,         // 삭제 가능 여부
			useNavi : false         // prev | newxt 버튼 사용
		},
			autoLoad: false,
			proxy: directProxy3,
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
		groupField: 'INDEX02'
	});
   /**
    * 검색조건 (Search Panel)
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
                //validateBlank	: false,
    			autoPopup : true,
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                    },
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('ITEM_CODE', newValue);
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('ITEM_NAME', newValue);
                    }
//                  onSelected: {
//                        fn: function(records, type) {
//                            panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
//                            panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
//                        },
//                        scope: this
//                    },
//                    onClear: function(type) {
//                        panelResult.setValue('ITEM_CODE', '');
//                        panelResult.setValue('ITEM_NAME', '');
//                    }
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
              //validateBlank	: false,
    			autoPopup : true,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('CUSTOM_CODE', newValue);
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('CUSTOM_NAME', newValue);
                    },
                    applyextparam: function(popup){
                        popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
                        popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
                    }
                }
            }),{
                fieldLabel: '합계표시',
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
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},
			{
				fieldLabel: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>',
				name: 'INOUT_TYPE_DETAIL',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M103',
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
				id:'DVRY_TYPE1',
				fieldLabel: '납기경과',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width: 80,
					name: 'DVRY_TYPE',
					inputValue: '0',
					checked: true
				},//All
				{
					boxLabel: '납기준수',
					width: 80,
					name: 'DVRY_TYPE',
					inputValue: '1'
				}, //Complete
				{
					boxLabel: '납기경과',
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
				fieldLabel: '통화',
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
			}
//			,Unilite.popup('DEPT', {
//				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
//				valueFieldName: 'DEPT_CODE',
//		   	 	textFieldName: 'DEPT_NAME',
//				valueFieldWidth: 50,
//				textFieldWidth: 185,
//				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
//							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
//                    	},
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

	var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            allowBlank: false,
            value: UserInfo.divCode,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DIV_CODE', newValue);
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
            fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
            valueFieldName: 'ITEM_CODE',
            textFieldName: 'ITEM_NAME',
            //validateBlank	: false,
			autoPopup : true,
            listeners: {
                applyextparam: function(popup){
                    popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                },
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('ITEM_CODE', newValue);
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('ITEM_NAME', newValue);
                }
//                    onSelected: {
//                        fn: function(records, type) {
//                          panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
//                          panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
//                        },
//                        scope: this
//                    },
//                    onClear: function(type) {
//                      panelSearch.setValue('ITEM_CODE', '');
//                        panelSearch.setValue('ITEM_NAME', '');
//                    }
            }
       })/*,{
            xtype : 'button',
            text:'입고현황 출력',
            margin: '0 0 0 95',
            handler: function() {
                var param = panelResult.getValues();
                var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/z_yp/mtr110cskrv_yp1.do',
                    prgID: 's_mtr110skrv_yp',
                        extParam: param
                });
                win.center();
                win.show();
            }
         }*/,{
            fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
            name: 'ORDER_TYPE',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'M001',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('ORDER_TYPE', newValue);
                }
            }
        },
        Unilite.popup('AGENT_CUST', {
            fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
            valueFieldName: 'CUSTOM_CODE',
            textFieldName: 'CUSTOM_NAME',
            //validateBlank	: false,
			autoPopup : true,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('CUSTOM_CODE', newValue);
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('CUSTOM_NAME', newValue);
                },
                applyextparam: function(popup){
                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
                }
            }
        }),{
            fieldLabel: '합계표시',
            xtype: 'uniCheckboxgroup',
            items: [{
                boxLabel: '',
                name: 'CHECK_SUM',
                width: 70,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('CHECK_SUM', newValue);
                    }
                }
            }]
        }/*,{
            xtype : 'button',
            text:'집계현황 출력',
            margin: '0 0 0 95',
            handler: function() {
                var param = panelResult.getValues();
                var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/z_yp/mtr110cskrv_yp2.do',
                    prgID: 's_mtr110skrv_yp',
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
	var itemGrid = Unilite.createGrid('s_mtr110skrv_ypGrid1', {
       // for tab
		layout: 'fit',
		region:'center',
		title: '<t:message code="system.label.purchase.itemby" default="품목별"/>',
		tbar:[{xtype:'uniNumberfield',
			labelWidth: 110,
			fieldLabel:'<t:message code="system.label.purchase.selectionsummary" default="선택된 데이터 합계"/>',
			itemId:'selectionSummaryItem',
			readOnly: true,
			value:0,
			decimalPrecision:4,
			format:'0,000.0000'}],
		uniOpt: {
    		useGroupSummary: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel      : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
			}
        },
        features: [{
        	id: 'masterGridSubTotal',
        	ftype: 'uniGroupingsummary',
        	showSummaryRow: true
        	},{
        	id: 'masterGridTotal',
        	ftype: 'uniSummary',
        	showSummaryRow: true
        	}
        ],
		store: directMasterStore1,
		columns: [
            {dataIndex: 'INDEX01'		        , width: 120, locked: false},
            {dataIndex: 'INDEX02'		        , width: 150, locked: false},
            {dataIndex: 'BARCODE'		        , width: 88, locked: false},
            {dataIndex: 'INDEX03'		        , width: 150, locked: false,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
            }},
            {dataIndex: 'INDEX04'	    	, width: 86, locked: false},
            {dataIndex: 'INDEX05'	        , width: 150, hidden: true},
            {dataIndex: 'INDEX06'			, width: 166},
            {dataIndex: 'FARM_CODE'				, width: 80},
            {dataIndex: 'FARM_NAME'				, width: 100},
            {dataIndex: 'ORIGIN'             , width: 100},
            {dataIndex: 'INOUT_Q'			    , width: 80,summaryType: 'sum'},
            {dataIndex: 'TRNS_RATE_IN'		       ,width:60, align: 'right'},
            {dataIndex: 'INOUT_P'			    , width: 100},
            {dataIndex: 'INOUT_I'			    , width: 100,summaryType: 'sum'},
            {dataIndex: 'EXPENSE_I'				, width: 100,summaryType: 'sum'},
            {dataIndex: 'INOUT_I_TOTAL'			, width: 140,summaryType: 'sum'},
            {dataIndex: 'TAX_TYPE'              , width: 90},
            {dataIndex: 'INOUT_FOR_P'	        , width: 100},
            {dataIndex: 'INOUT_FOR_O'	        , width: 100,summaryType: 'sum'},
            {dataIndex: 'MONEY_UNIT'			, width: 66, align: 'center'},
            {dataIndex: 'EXCHG_RATE_O'		    , width: 70},
            {dataIndex: 'STOCK_UNIT'			, width: 66},
            {dataIndex: 'WH_CODE'			    , width: 100},
            {dataIndex: 'INOUT_PRSN'			, width: 66},
            {dataIndex: 'INOUT_NUM'				, width: 130, align: 'center'},
            {dataIndex: 'INOUT_METH'			, width: 66},
            {dataIndex: 'INOUT_TYPE_DETAIL'		, width: 66},
            {dataIndex: 'ORDER_DATE'			, width: 93},
            {dataIndex: 'ORDER_NUM'				, width: 133},
            {dataIndex: 'ORDER_SEQ'				, width: 70},
            {dataIndex: 'ORDER_UNIT_Q'	       ,width:100,summaryType: 'sum'},
            {dataIndex: 'ORDER_UNIT'		   ,width:80, align: 'center'},
            {dataIndex: 'TRNS_RATE'		       ,width:60, align: 'right'},
            {dataIndex: 'ORDER_UNIT_P'	       ,width:100,summaryType: 'sum'},
            {dataIndex: 'DVRY_DATE'				, width: 93},
            {dataIndex: 'BUY_Q'					, width: 93,summaryType: 'sum'},
            {dataIndex: 'REMARK'				, width: 133},
            {dataIndex: 'PROJECT_NO'			, width: 133},
            {dataIndex: 'LOT_NO'			    , width: 113},
            {dataIndex: 'ITEM_LEVEL1'		    , width: 120, locked: false},
            {dataIndex: 'ITEM_LEVEL2'		    , width: 120, locked: false},
            {dataIndex: 'ITEM_LEVEL3'		    , width: 120, locked: false},
            {dataIndex: 'LC_NUM'				, width: 113},
            {dataIndex: 'BL_NUM'				, width: 113},
            {dataIndex: 'CREATE_LOC'			, width: 66, hidden: true},
            {dataIndex: 'DIV_CODE'			    , width: 6, hidden: true},
            {dataIndex: 'UPDATE_DB_TIME'		, width: 120}
		] ,
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
	     	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
                if(colName == "INOUT_NUM"){
                	itemGrid.gotoSmms510ukrvYp(record);
                }
            }
	   },
		 gotoSmms510ukrvYp:function(record)	{
		 		if(record)	{
			    	var params = {
			    		action				:'select',
				    	'PGM_ID' 			: 's_mtr110skrv_yp',
				    	'INOUT_NUM' 		: record.data['INOUT_NUM'],
				    	'INOUT_DATE' 		: record.data['INDEX04'],
				    	'CUSTOM_CODE' 			: record.data['INDEX05'],
				    	'CUSTOM_NAME' 			: record.data['INDEX06'],
				    	'MONEY_UNIT' 		: record.data['MONEY_UNIT'],
			    		'CREATE_LOC' 		: record.data['CREATE_LOC'],
			    		'EXCHG_RATE_O' 	: record.data['EXCHG_RATE_O']
			    	}
			    	var rec1 = {data : {prgID : 's_mms510ukrv_yp', 'text':''}};
					parent.openTab(rec1, '/z_yp/s_mms510ukrv_yp.do', params);
				}
			}
	});//End of var itemGrid = Unilite.createGrid('s_mtr110skrv_ypGrid1', {

	var customGrid = Unilite.createGrid('s_mtr110skrv_ypGrid2', {
       // for tab
		title: '<t:message code="system.label.purchase.customby" default="거래처별"/>',
		layout: 'fit',
		region:'center',
			tbar:[{xtype:'uniNumberfield',
				labelWidth: 110,
				fieldLabel:'<t:message code="system.label.purchase.selectionsummary" default="선택된 데이터 합계"/>',
				itemId:'selectionSummaryCustom',
				readOnly: true,
				value:0,
				decimalPrecision:4,
				format:'0,000.0000'}],
		uniOpt: {
    		useGroupSummary: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel      : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
			}
        },
        features: [{
        	id: 'masterGridSubTotal',
        	ftype: 'uniGroupingsummary',
        	showSummaryRow: true
        	},{
        	id: 'masterGridTotal',
        	ftype: 'uniSummary',
        	showSummaryRow: true
        	}
        ],
		store: directMasterStore2,
		columns: [
			{dataIndex: 'INDEX01'		        , width: 120, locked: false, hidden:true},
            {dataIndex: 'INDEX02'		        , width: 250, locked: false,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
            }},
            {dataIndex: 'FARM_CODE'				, width: 80},
            {dataIndex: 'FARM_NAME'				, width: 100},
            {dataIndex: 'ORIGIN'             , width: 100},
            {dataIndex: 'INDEX03'		        	, width: 88, locked: false},

            {dataIndex: 'INDEX04'	    	, width: 150, locked: false},
            {dataIndex: 'INDEX05'	        , width: 150, hidden: true},
            {dataIndex: 'BARCODE'		        , width: 88, locked: false},

            {dataIndex: 'INDEX06'			, width: 166},
            {dataIndex: 'INOUT_Q'			    , width: 80,summaryType: 'sum'},
            {dataIndex: 'TRNS_RATE_IN'		       ,width:60, align: 'right'},
            {dataIndex: 'INOUT_P'			    , width: 100},
            {dataIndex: 'INOUT_I'			    , width: 100,summaryType: 'sum'},
            {dataIndex: 'EXPENSE_I'				, width: 100,summaryType: 'sum'},
            {dataIndex: 'INOUT_I_TOTAL'			, width: 140,summaryType: 'sum'},
            {dataIndex: 'TAX_TYPE'              , width: 90},
            {dataIndex: 'INOUT_FOR_P'	        , width: 100},
            {dataIndex: 'INOUT_FOR_O'	        , width: 100,summaryType: 'sum'},
            {dataIndex: 'MONEY_UNIT'			, width: 66, align: 'center'},
            {dataIndex: 'EXCHG_RATE_O'		    , width: 70},

            {dataIndex: 'WH_CODE'			    , width: 100},
            {dataIndex: 'INOUT_PRSN'			, width: 66},
            {dataIndex: 'INOUT_NUM'				, width: 130},
            {dataIndex: 'INOUT_METH'			, width: 66},
            {dataIndex: 'INOUT_TYPE_DETAIL'		, width: 66},
            {dataIndex: 'ORDER_DATE'			, width: 93},
            {dataIndex: 'ORDER_NUM'				, width: 133},
            {dataIndex: 'ORDER_SEQ'				, width: 70},
            {dataIndex: 'ORDER_UNIT_Q'	       ,width:100,summaryType: 'sum'},
            {dataIndex: 'ORDER_UNIT'		   ,width:80, align: 'center'},
            {dataIndex: 'TRNS_RATE'		       ,width:60, align: 'right'},
            {dataIndex: 'ORDER_UNIT_P'	       ,width:100,summaryType: 'sum'},
            {dataIndex: 'DVRY_DATE'				, width: 93},
            {dataIndex: 'BUY_Q'					, width: 93,summaryType: 'sum'},
            {dataIndex: 'REMARK'				, width: 133},
            {dataIndex: 'PROJECT_NO'			, width: 133},
            {dataIndex: 'LOT_NO'			    , width: 113},
            {dataIndex: 'ITEM_LEVEL1'		    , width: 120, locked: false},
            {dataIndex: 'ITEM_LEVEL2'		    , width: 120, locked: false},
            {dataIndex: 'ITEM_LEVEL3'		    , width: 120, locked: false},
            {dataIndex: 'LC_NUM'				, width: 113},
            {dataIndex: 'BL_NUM'				, width: 113},
            {dataIndex: 'CREATE_LOC'			, width: 66, hidden: true},
            {dataIndex: 'DIV_CODE'			    , width: 6, hidden: true},
            {dataIndex: 'STOCK_UNIT'			, width: 66},
            {dataIndex: 'UPDATE_DB_TIME'		, width: 120}
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
	     	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
                if(colName == "INOUT_NUM"){
                	customGrid.gotoSmms510ukrvYp(record);
                }
            }
	     },gotoSmms510ukrvYp:function(record)	{
		 		if(record)	{
			    	var params = {
			    		action				:'select',
				    	'PGM_ID' 			: 's_mtr110skrv_yp',
				    	'INOUT_NUM' 		: record.data['INOUT_NUM'],
				    	'INOUT_DATE' 		: record.data['INDEX03'],
				    	'CUSTOM_CODE' 			: record.data['INDEX01'],
				    	'CUSTOM_NAME' 			: record.data['INDEX02'],
				    	'MONEY_UNIT' 		: record.data['MONEY_UNIT'],
			    		'CREATE_LOC' 		: record.data['CREATE_LOC'],
			    		'EXCHG_RATE_O' 	: record.data['EXCHG_RATE_O']
			    	}
			    	var rec1 = {data : {prgID : 's_mms510ukrv_yp', 'text':''}};
					parent.openTab(rec1, '/z_yp/s_mms510ukrv_yp.do', params);
				}
		}
	});

	var masterGrid = Unilite.createGrid('s_mtr110skrv_ypGrid3', {
       // for tab
		title: '거래처품목별',
		layout: 'fit',
		region:'center',
		tbar:[{xtype:'uniNumberfield',
			labelWidth: 110,
			fieldLabel:'<t:message code="system.label.purchase.selectionsummary" default="선택된 데이터 합계"/>',
			itemId:'selectionSummaryCustomItem',
			readOnly: true,
			value:0,
			decimalPrecision:4,
			format:'0,000.0000'}],
		uniOpt: {
    		useGroupSummary: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel      : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
			}
        },
        features: [{
        	id: 'masterGridSubTotal',
        	ftype: 'uniGroupingsummary',
        	showSummaryRow: true
        	},{
        	id: 'masterGridTotal',
        	ftype: 'uniSummary',
        	showSummaryRow: true
        	}
        ],
		store: directMasterStore3,
		columns: [
			{dataIndex: 'INDEX01'		        , width: 120, locked: false, hidden:true},
            {dataIndex: 'INDEX02'		        , width: 250, locked: false,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
            }},
            {dataIndex: 'FARM_CODE'				, width: 80},
            {dataIndex: 'FARM_NAME'				, width: 100},
            {dataIndex: 'ORIGIN'             , width: 100},
            {dataIndex: 'INDEX03'		        	, width: 150, locked: false},
            {dataIndex: 'INDEX04'	    	, width: 86, locked: false},
            {dataIndex: 'BARCODE'		        , width: 88, locked: false},
            {dataIndex: 'INDEX05'	        , width: 150, locked: false},
            {dataIndex: 'INDEX06'			, width: 166},

			{dataIndex: 'ITEM_LEVEL1'		    , width: 120},
            {dataIndex: 'ITEM_LEVEL2'		    , width: 120},
            {dataIndex: 'ITEM_LEVEL3'		    , width: 120},

            {dataIndex: 'INOUT_Q'			    , width: 80,summaryType: 'sum'},
            {dataIndex: 'TRNS_RATE_IN'		       ,width:60, align: 'right'},
            {dataIndex: 'INOUT_P'			    , width: 100},
            {dataIndex: 'INOUT_I'			    , width: 100,summaryType: 'sum'},
            {dataIndex: 'EXPENSE_I'				, width: 100,summaryType: 'sum'},
            {dataIndex: 'INOUT_I_TOTAL'			, width: 140,summaryType: 'sum'},
            {dataIndex: 'TAX_TYPE'              , width: 90},
            {dataIndex: 'INOUT_FOR_P'	        , width: 100},
            {dataIndex: 'INOUT_FOR_O'	        , width: 100,summaryType: 'sum'},
            {dataIndex: 'MONEY_UNIT'			, width: 66, align: 'center'},
            {dataIndex: 'EXCHG_RATE_O'		    , width: 70},
            {dataIndex: 'STOCK_UNIT'			, width: 66},
            {dataIndex: 'WH_CODE'			    , width: 100},
            {dataIndex: 'INOUT_PRSN'			, width: 66},
            {dataIndex: 'INOUT_NUM'				, width: 130},
            {dataIndex: 'INOUT_METH'			, width: 66},
            {dataIndex: 'INOUT_TYPE_DETAIL'		, width: 66},
            {dataIndex: 'ORDER_DATE'			, width: 93},
            {dataIndex: 'ORDER_NUM'				, width: 133},
            {dataIndex: 'ORDER_SEQ'				, width: 70},
            {dataIndex: 'ORDER_UNIT_Q'	       ,width:100,summaryType: 'sum'},
            {dataIndex: 'ORDER_UNIT'		   ,width:80, align: 'center'},
            {dataIndex: 'TRNS_RATE'		       ,width:60, align: 'right'},
            {dataIndex: 'ORDER_UNIT_P'	       ,width:100,summaryType: 'sum'},
            {dataIndex: 'DVRY_DATE'				, width: 93},
            {dataIndex: 'BUY_Q'					, width: 93,summaryType: 'sum'},
            {dataIndex: 'REMARK'				, width: 133},
            {dataIndex: 'PROJECT_NO'			, width: 133},
            {dataIndex: 'LOT_NO'			    , width: 113},
            {dataIndex: 'LC_NUM'				, width: 113},
            {dataIndex: 'BL_NUM'				, width: 113},
            {dataIndex: 'CREATE_LOC'			, width: 66, hidden: true},
            {dataIndex: 'DIV_CODE'			    , width: 6, hidden: true},
            {dataIndex: 'UPDATE_DB_TIME'		, width: 120}
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
		  	          			this.down('#selectionSummaryCustomItem').setValue(sum);
		  	          		} else {
		  	          			this.down('#selectionSummaryCustomItem').setValue(0);
		  	          		}
	     		}
	     	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
                if(colName == "INOUT_NUM"){
                	masterGrid.gotoSmms510ukrvYp(record);
                }
            }
	     },gotoSmms510ukrvYp:function(record)	{
		 		if(record)	{
			    	var params = {
			    		action				:'select',
				    	'PGM_ID' 			: 's_mtr110skrv_yp',
				    	'INOUT_NUM' 		: record.data['INOUT_NUM'],
				    	'INOUT_DATE' 		: record.data['INDEX06'],
				    	'CUSTOM_CODE' 			: record.data['INDEX01'],
				    	'CUSTOM_NAME' 			: record.data['INDEX02'],
				    	'MONEY_UNIT' 		: record.data['MONEY_UNIT'],
			    		'CREATE_LOC' 		: record.data['CREATE_LOC'],
			    		'EXCHG_RATE_O' 	: record.data['EXCHG_RATE_O']
			    	}
			    	var rec1 = {data : {prgID : 's_mms510ukrv_yp', 'text':''}};
					parent.openTab(rec1, '/z_yp/s_mms510ukrv_yp.do', params);
				}
		}
	});
	//创建标签页面板
	var tab = Unilite.createTabPanel('tabPanel',{
        activeTab: 0,
        region: 'center',
        items: [
        		itemGrid,customGrid,masterGrid
//                 {
//                     title: '<t:message code="system.label.purchase.itemby" default="품목별"/>'
//                     ,xtype:'container'
//                     ,layout:{type:'vbox', align:'stretch'}
//                     ,items:[itemGrid]
//                     ,id: 'itemGridTab'
//                 },
//                 {
//                     title: '<t:message code="system.label.purchase.customby" default="거래처별"/>'
//                     ,xtype:'container'
//                     ,layout:{type:'vbox', align:'stretch'}
//                     ,items:[customGrid]
//                     ,id: 'customGridTab'
//                 },
//                 {
//                     title: '거래처품목별'
//                     ,xtype:'container'
//                     ,layout:{type:'vbox', align:'stretch'}
//                     ,items:[masterGrid]
//                     ,id: 'masterGridTab'
//                 }
        ],
        listeners:  {
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
                var newTabId = newCard.getId();
                console.log("newCard:  " + newCard.getId());
                console.log("oldCard:  " + oldCard.getId());
                //탭 넘길때마다 초기화
                UniAppManager.setToolbarButtons(['save', 'newData' ], false);
                panelResult.setAllFieldsReadOnly(false);
//              Ext.getCmp('confirm_check').hide(); //확정버튼 hidden
                UniAppManager.app.onQueryButtonDown();

            }
        }
    });


	Unilite.Main( {
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
		id: 's_mtr110skrv_ypApp',
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
			s_mtr110skrv_ypService.userWhcode({}, function(provider, response)	{
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
				if(activeTabId == 's_mtr110skrv_ypGrid1'){
					itemGrid.reset();
					itemGrid.getStore().loadStoreRecords();
				}
				else if(activeTabId == 's_mtr110skrv_ypGrid2'){
					customGrid.reset();
					customGrid.getStore().loadStoreRecords();
				}
				else if(activeTabId == 's_mtr110skrv_ypGrid3'){
					masterGrid.reset();
					masterGrid.getStore().loadStoreRecords();
				}
				if(panelSearch.getValue("CHECK_SUM")){

					//var viewLocked = itemGrid.lockedGrid.getView();
					var viewNormal = itemGrid.getView();
					//console.log("viewLocked: ", viewLocked);
					console.log("viewNormal: ", viewNormal);
					//viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
					//viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
					viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);

					//var viewLocked = customGrid.lockedGrid.getView();
					var viewNormal = customGrid.getView();
					//viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
					//viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
					viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);

					//var viewLocked = masterGrid.lockedGrid.getView();
					var viewNormal = masterGrid.getView();
					//viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
					//viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
					viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				}else{
					//var viewLocked = itemGrid.lockedGrid.getView();
					var viewNormal = itemGrid.getView();
					//console.log("viewLocked: ", viewLocked);
					console.log("viewNormal: ", viewNormal);
					//viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
					//viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
					viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);

					//var viewLocked = customGrid.lockedGrid.getView();
					var viewNormal = customGrid.getView();
					//viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
					//viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
					viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);

					//var viewLocked = masterGrid.lockedGrid.getView();
					var viewNormal = masterGrid.getView();
					//viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
					//viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
					viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
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
/*        onSaveAsExcelButtonDown: function() {
			 itemGrid.downloadExcelXml();
		}*/
	});//End of Unilite.Main( {
};


</script>