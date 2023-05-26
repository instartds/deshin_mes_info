<%@page language="java" contentType="text/html; charset=utf-8"%>
	<t:appConfig pgmId="map110ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="map110ukrv"   />          <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" opts= '53;62' /> <!-- 계산서유형 -->
	<t:ExtComboStore comboType="AU" comboCode="M302" opts= '20;30'/> <!-- 매입유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B051" /> <!-- 세액계산법 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B038" /> <!-- 결제방법 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!-- 세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B030" /> <!-- 세액계산구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var SearchInfoWindow;	             //조회버튼 누르면 나오는 조회창
var referReceiveHistoryWindow;	     //입고내역참조
var referReturningHistoryWindow;	 //반품내역참조
var referOrderHistoryWindow;	     //발주내역참조(선지급)
var BsaCodeInfo = {	
	gsAdvanUseYn: '${gsAdvanUseYn}',
	gsDefaultMoney: '${gsDefaultMoney}',
	gsAutoType1: '${gsAutoType1}',
	gsAutoType2: '${gsAutoType2}',
	gsList1: '${gsList1}',
	gsList2: '${gsList2}',
	AccountType : ${AccountType},
	BillType: ${BillType}
};

var CustomCodeInfo = {
	gsUnderCalBase: '',
	gsTaxInclude: '',
	gsTaxCalcType: '',
	gsBillType: ''
};

/*alert(CustomCodeInfo.gsUnderCalBase);
alert(CustomCodeInfo.gsTaxInclude);
alert(CustomCodeInfo.gsTaxCalcType);*/


/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/

function appMain() {
	
	var isAutoInoutNum1 = false;
	if(BsaCodeInfo.gsAutoType1=='Y')	{
		isAutoInoutNum1 = true;
	}
	var isAutoInoutNum2 = false;
	if(BsaCodeInfo.gsAutoType2=='Y')	{
		isAutoInoutNum2 = true;
	}
	
   /**
    *   Model 정의 
    * @type 
    */

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'map110ukrvService.selectList',
			update: 'map110ukrvService.updateDetail',
			create: 'map110ukrvService.insertDetail',
			destroy: 'map110ukrvService.deleteDetail',
			syncAll: 'map110ukrvService.saveAll'
		}
	});	
	
	Unilite.defineModel('map110ukrvModel', {
		fields: [
			{name: 'CHANGE_BASIS_NUM' , text: '<t:message code="system.label.purchase.purchaseno" default="매입번호"/>'			, type: 'string',allowBlank: isAutoInoutNum1},
			{name: 'CHANGE_BASIS_SEQ' , text: '<t:message code="system.label.purchase.seq" default="순번"/>'				, type: 'int'},
			{name: 'INSTOCK_DATE'     , text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'			, type: 'uniDate'},
			{name: 'ITEM_ACCOUNT'     , text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			, type: 'string'},
			{name: 'ITEM_CODE'	      , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'        , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			    , type: 'string'},
			{name: 'SPEC'		      , text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'	      , text: '<t:message code="system.label.purchase.unit" default="단위"/>'				, type: 'string'},
			{name: 'ORDER_UNIT_Q'     , text: '<t:message code="system.label.purchase.qty" default="수량"/>'				, type: 'uniQty'},
			{name: 'REMAIN_Q'	      , text: '<t:message code="system.label.purchase.purchasebalanceqty" default="매입잔량"/>'			, type: 'uniQty'},
			{name: 'ORDER_UNIT_P'     , text: '<t:message code="system.label.purchase.purchaseprice" default="구매단가"/>'			, type: 'uniUnitPrice'},
			{name: 'AMOUNT_P'	      , text: '<t:message code="system.label.purchase.price" default="단가"/>'				, type: 'uniUnitPrice'},
			{name: 'AMOUNT_I'         , text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'			, type: 'uniPrice'},
			{name: 'TAX_I'	          , text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'			    , type: 'uniPrice'},
			{name: 'TOTAL_I'	      , text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'			, type: 'uniPrice'},
			{name: 'ORDER_UNIT_FOR_P' , text: '구매단위외화단가'	, type: 'uniUnitPrice'},
			{name: 'FOREIGN_P'	      , text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>'			, type: 'uniUnitPrice'},
			{name: 'FOR_AMOUNT_O'     , text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>'			, type: 'uniFC'},
			{name: 'MONEY_UNIT'	      , text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				, type: 'string'},
			{name: 'EXCHG_RATE_O'     , text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				, type: 'uniER'},
			{name: 'STOCK_UNIT'	      , text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string'},
			{name: 'TRNS_RATE'	      , text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'				, type: 'uniQty'},
			{name: 'BUY_Q'		      , text: '<t:message code="system.label.purchase.inventoryunitqty" default="재고단위량"/>'			, type: 'uniQty'},
			{name: 'ORDER_TYPE'	      , text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'			, type: 'string'},
			{name: 'ORDER_PRSN'	      , text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'			, type: 'string'},
			{name: 'LC_NUM'		      , text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'			    , type: 'string'},
			{name: 'BL_NUM'	          , text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'			    , type: 'string'},
			{name: 'ORDER_NUM'	      , text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'			, type: 'string'},
			{name: 'ORDER_SEQ'	      , text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'			, type: 'int'},
			{name: 'INOUT_NUM'	      , text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'			, type: 'string'},
			{name: 'INOUT_SEQ'	      , text: '입고순번'			, type: 'int'},
			{name: 'DIV_CODE'	      , text: '<t:message code="system.label.purchase.division" default="사업장"/>'			    , type: 'string',comboType:'BOR120'},
			{name: 'BILL_DIV_CODE'    , text: '<t:message code="system.label.purchase.declaredivsion" default="신고사업장"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'	  , text: '고객코드'			, type: 'string'},
			{name: 'REMARK'           , text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'PROJECT_NO'       , text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'UPDATE_DB_USER'   , text: 'UPDATE_DB_USER'	    , type: 'string'},
			{name: 'UPDATE_DB_TIME'   , text: 'UPDATE_DB_TIME'	    , type: 'string'},
			{name: 'COMP_CODE'	      , text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			, type: 'string'},
			{name: 'ADVAN_YN'         , text: 'ADVAN_YN'		    , type: 'string'},
			{name: 'ADVAN_AMOUNT'     , text: 'ADVAN_AMOUNT'	    , type: 'string'},
			{name: 'PURCHASE_TYPE'    , text: 'PURCHASE_TYPE'	    , type: 'string'},
			{name: 'INOUT_TYPE'       , text: 'INOUT_TYPE'		    , type: 'string'},
			
			{name: 'TAX_TYPE'         , text: '세구분'		        , type: 'string' ,comboType:'AU', comboCode:'B059'}
		]
	});//End of Unilite.defineModel('map110ukrvModel', {
   
	Unilite.defineModel('buyslipNoMasterModel', {		//조회버튼 누르면 나오는 조회창
	    fields: [
	    	{name: 'CUSTOM_NAME'			   , text: '<t:message code="system.label.purchase.custom" default="거래처"/>'    	                  , type: 'string'},
	    	{name: 'CHANGE_BASIS_DATE'  	   , text: '<t:message code="system.label.purchase.exdate" default="결의일"/>'    	                  , type: 'uniDate'},
	    	{name: 'MONEY_UNIT'		    	   , text: '<t:message code="system.label.purchase.currency" default="화폐"/>'    		              , type: 'string'},
	    	{name: 'AMOUNT_I'		    	   , text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'    	              , type: 'uniPrice'},
	    	{name: 'BILL_NUM'		    	   , text: '<t:message code="system.label.purchase.billno" default="계산서번호"/>'                   , type: 'string'},
	    	{name: 'BILL_DATE'		    	   , text: '<t:message code="system.label.purchase.billdate" default="계산서일"/>'                   , type: 'uniDate'},
	    	{name: 'CHANGE_BASIS_NUM'   	   , text: '<t:message code="system.label.purchase.purchaseno" default="매입번호"/>'    	              , type: 'string'},
	    	{name: 'DIV_CODE'	        	   , text: '<t:message code="system.label.purchase.division" default="사업장"/>'   	                  , type: 'string',comboType:'BOR120'},
	    	{name: 'BILL_DIV_CODE'	    	   , text: '<t:message code="system.label.purchase.declaredivsion" default="신고사업장"/>'                   , type: 'string',comboType:'BOR120'},
	    	{name: 'CUSTOM_CODE'			   , text: '<t:message code="system.label.purchase.custom" default="거래처"/>'    	                  , type: 'string'},
	    	{name: 'COMPANY_NUM'			   , text: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>'                   , type: 'string'},
	    	{name: 'BILL_TYPE'		    	   , text: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>'                   , type: 'string'},
	    	{name: 'RECEIPT_TYPE'	    	   , text: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>'    	              , type: 'string'},
	    	{name: 'ORDER_TYPE'		    	   , text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'    	              , type: 'string'},
	    	{name: 'VAT_RATE'		    	   , text: '<t:message code="system.label.purchase.vatrate" default="부가세율"/>'    	              , type: 'string'},
	    	{name: 'VAT_AMOUNT_O'	    	   , text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'    	              , type: 'uniPrice'},
	    	{name: 'DEPT_CODE'		    	   , text: '<t:message code="system.label.purchase.department" default="부서"/>'    		              , type: 'string'},
	    	{name: 'EX_DATE'				   , text: '<t:message code="system.label.purchase.purchasepostdate" default="매입기표일"/>'                  , type: 'uniDate'},
	    	{name: 'EX_NUM'			    	   , text: '<t:message code="system.label.purchase.slipno" default="전표번호"/>'    	              , type: 'int'},
	    	{name: 'AGREE_YN'		    	   , text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'    	              , type: 'string'},
	    	{name: 'DRAFT_YN'		    	   , text: '<t:message code="system.label.purchase.drafting" default="기안여부"/>'    	              , type: 'string'},
	    	{name: 'DEPT_NAME'		    	   , text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'    	                  , type: 'string'},
	    	{name: 'ISSUE_EXPECTED_DATE'	   , text: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>'                   , type: 'uniDate'},
	    	{name: 'ACCOUNT_TYPE'	    	   , text: '<t:message code="system.label.purchase.purchasetype" default="매입유형"/>'    	              , type: 'string'},
	    	{name: 'PROJECT_NO'		    	   , text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'    	              , type: 'string'},
	    	{name: 'CREDIT_NUM'		    	   , text: '법인카드/현금영수증번호'      , type: 'string'},
	    	{name: 'CRDT_NAME'		      	 	, text: '법인카드명'                  , type: 'string'}
		]
	});
	
	Unilite.defineModel('map110ukrvRECEIVEModel', {	//입고내역참조 
	    fields: [
			//{name: 'GUBUN'		     	    , text: '<t:message code="system.label.purchase.selection" default="선택"/>'    	, type: 'string'},
			{name: 'INSTOCK_DATE'    	    , text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'    	    , type: 'uniDate'},
			{name: 'ITEM_ACCOUNT'    	    , text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'    	    , type: 'string'},
			{name: 'ITEM_CODE'	     	    , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'    	    , type: 'string'},
			{name: 'ITEM_NAME'	     	    , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'    	    , type: 'string'},
			{name: 'SPEC'		     	    , text: '<t:message code="system.label.purchase.spec" default="규격"/>'    	        , type: 'string'},
			{name: 'ORDER_UNIT'	     	    , text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'    	    , type: 'string'},
			{name: 'TAX_TYPE'	     	    , text: '세구분'    	    , type: 'string',comboType:'AU', comboCode:'B059'},
			
			{name: 'ORDER_UNIT_FOR_P'    	, text: '<t:message code="system.label.purchase.receiptprice" default="입고단가"/>'          , type: 'uniUnitPrice'},
			{name: 'INOUT_Q'    	    	, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'          , type: 'uniQty'},
			{name: 'INOUT_I'    	    	, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'          , type: 'uniPrice'},
			{name: 'INOUT_TAX_AMT'    	    , text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'          , type: 'uniPrice'},
			{name: 'TOTAL_INOUT_I'    	    , text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'          , type: 'uniPrice'},
			
			{name: 'ORDER_UNIT_Q'    	    , text: '구매단위수량'      , type: 'uniQty'},
			{name: 'ORDER_UNIT_P'    	    , text: '<t:message code="system.label.purchase.purchaseprice" default="구매단가"/>'          , type: 'uniUnitPrice'},
			{name: 'AMOUNT_P'        	    , text: '<t:message code="system.label.purchase.price" default="단가"/>'    	        , type: 'uniUnitPrice'},
//			{name: 'INOUT_TAX_AMT'        	, text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'    	, type: 'uniPrice'},
			{name: 'AMOUNT_I'        	    , text: '<t:message code="system.label.purchase.amount" default="금액"/>'    	        , type: 'uniPrice'},
			{name: 'ORDER_UNIT_FOR_P'	    , text: '구매단위외화단가'  , type: 'uniUnitPrice'},
			{name: 'FOREIGN_P'	     	    , text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>'    	    , type: 'uniUnitPrice'},
			{name: 'FOR_AMOUNT_O'    	    , text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>'    	    , type: 'uniFC'},
			{name: 'REMAIN_Q'        	    , text: '<t:message code="system.label.purchase.purchasebalanceqty" default="매입잔량"/>'    	    , type: 'uniQty'},
			{name: 'ADVAN_AMOUNT'	 	    , text: '<t:message code="system.label.purchase.paymentinadvance" default="선지급금"/>'    	    , type: 'uniPrice'},
			{name: 'REMAIN_AMOUNT'   	    , text: '<t:message code="system.label.purchase.balanceamount" default="잔여액"/>'    	    , type: 'uniPrice'},
			{name: 'MONEY_UNIT'	     	    , text: '<t:message code="system.label.purchase.currency" default="화폐"/>'    	        , type: 'string'},
			{name: 'EXCHG_RATE_O'    	    , text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'    	        , type: 'uniER'},
			{name: 'TRNS_RATE'	     	    , text: '<t:message code="system.label.purchase.conversioncoeff" default="변환계수"/>'    	    , type: 'string'},
			{name: 'STOCK_UNIT'	     	    , text: '<t:message code="system.label.purchase.unit" default="단위"/>'    	        , type: 'string'},
			{name: 'BUY_Q'	         	    , text: '<t:message code="system.label.purchase.qty" default="수량"/>'    	        , type: 'uniQty'},
			{name: 'ORDER_TYPE'	     	    , text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'    	    , type: 'string'},
			{name: 'ORDER_PRSN'	     	    , text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'    	    , type: 'string'},
			{name: 'ORDER_SEQ'	     	    , text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'    	    , type: 'string'},
			{name: 'LC_NUM'		     	    , text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'    	    , type: 'string'},
			{name: 'BL_NUM'		     	    , text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'    	    , type: 'string'},
			{name: 'ORDER_NUM'		 	    , text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'    	    , type: 'string'},
			{name: 'INOUT_NUM'	     	    , text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'    	    , type: 'string'},
			{name: 'INOUT_SEQ'	     	    , text: '<t:message code="system.label.purchase.seq" default="순번"/>'    	        , type: 'string'},
			{name: 'TAX_CALC_TYPE'	 	    , text: '<t:message code="system.label.purchase.taxcalculationmethod" default="세액계산방법"/>'      , type: 'string',comboType:'AU', comboCode:'B030'},
			{name: 'REMARK'	         	    , text: '<t:message code="system.label.purchase.remarks" default="비고"/>'    	        , type: 'string'},
			{name: 'PROJECT_NO'      	    , text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'    	    , type: 'string'},
			{name: 'PURCHASE_TYPE'          , text: 'PURCHASE_TYPE'	    , type: 'string'},
			{name: 'INOUT_TYPE'             , text: 'INOUT_TYPE'		, type: 'string'}
		]
	});
	
	Unilite.defineModel('map110ukrvRETURNINGModel', {	//반품내역참조 
	    fields: [
			//{name: 'GUBUN'		     	    , text: '<t:message code="system.label.purchase.selection" default="선택"/>'    	, type: 'string'},
			{name: 'INSTOCK_DATE'    	    , text: '반품일'    	  , type: 'uniDate'},
			{name: 'ITEM_ACCOUNT'    	    , text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'    	  , type: 'string'},
			{name: 'ITEM_CODE'	     	    , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'    	  , type: 'string'},
			{name: 'ITEM_NAME'	     	    , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'    	  , type: 'string'},
			{name: 'SPEC'		     	    , text: '<t:message code="system.label.purchase.spec" default="규격"/>'    	      , type: 'string'},
			{name: 'ORDER_UNIT'	     	    , text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'    	  , type: 'string'},
			{name: 'TAX_TYPE'	     	    , text: '세구분'    	  , type: 'string' ,comboType:'AU', comboCode:'B059'},
			
			{name: 'ORDER_UNIT_FOR_P'    	, text: '반품단가'        , type: 'uniUnitPrice'},
			{name: 'INOUT_Q'    	    	, text: '반품수량'        , type: 'uniQty'},
			{name: 'INOUT_I'    	    	, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'        , type: 'uniPrice'},
			{name: 'INOUT_TAX_AMT'    	    , text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'        , type: 'uniPrice'},
			{name: 'TOTAL_INOUT_I'    	    , text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'        , type: 'uniPrice'},
			
			{name: 'CONDITION'              ,text: '조건' 			  ,type: 'string'},
	    	{name: 'TYPE'        	        ,text: '형태' 			  ,type: 'string'},
	    	{name: 'GOOD_STOCK_Q'           ,text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>' 		  ,type: 'uniQty'},
			
			{name: 'ORDER_UNIT_Q'    	    , text: '반품단위수량'    , type: 'uniQty'},
			{name: 'ORDER_UNIT_P'    	    , text: '반품단위단가'    , type: 'uniUnitPrice'},
			{name: 'AMOUNT_P'        	    , text: '<t:message code="system.label.purchase.price" default="단가"/>'    	      , type: 'uniUnitPrice'},
			{name: 'AMOUNT_I'        	    , text: '<t:message code="system.label.purchase.amount" default="금액"/>'    	      , type: 'uniPrice'},
			{name: 'ORDER_UNIT_FOR_P'	    , text: '구매단위외화단가', type: 'uniUnitPrice'},
			{name: 'FOREIGN_P'	     	    , text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>'    	  , type: 'uniUnitPrice'},
			{name: 'FOR_AMOUNT_O'    	    , text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>'    	  , type: 'uniFC'},
			{name: 'REMAIN_Q'        	    , text: '<t:message code="system.label.purchase.purchasebalanceqty" default="매입잔량"/>'    	  , type: 'uniQty'},
			{name: 'ADVAN_AMOUNT'	 	    , text: '<t:message code="system.label.purchase.paymentinadvance" default="선지급금"/>'    	  , type: 'uniPrice'},
			{name: 'REMAIN_AMOUNT'   	    , text: '<t:message code="system.label.purchase.balanceamount" default="잔여액"/>'    	  , type: 'uniPrice'},
			{name: 'MONEY_UNIT'	     	    , text: '<t:message code="system.label.purchase.currency" default="화폐"/>'    	      , type: 'string'},
			{name: 'EXCHG_RATE_O'    	    , text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'    	      , type: 'uniER'},
			{name: 'TRNS_RATE'	     	    , text: '<t:message code="system.label.purchase.conversioncoeff" default="변환계수"/>'    	  , type: 'string'},
			{name: 'STOCK_UNIT'	     	    , text: '<t:message code="system.label.purchase.unit" default="단위"/>'    	      , type: 'string'},
			{name: 'BUY_Q'	         	    , text: '<t:message code="system.label.purchase.qty" default="수량"/>'    	      , type: 'uniQty'},
			{name: 'ORDER_TYPE'	     	    , text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'    	  , type: 'string'},
			{name: 'ORDER_PRSN'	     	    , text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'    	  , type: 'string'},
			{name: 'ORDER_SEQ'	     	    , text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'    	  , type: 'string'},
			{name: 'LC_NUM'		     	    , text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'    	  , type: 'string'},
			{name: 'BL_NUM'		     	    , text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'    	  , type: 'string'},
			{name: 'ORDER_NUM'		 	    , text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'    	  , type: 'string'},
			{name: 'INOUT_NUM'	     	    , text: '반품번호'    	  , type: 'string'},
			{name: 'INOUT_SEQ'	     	    , text: '<t:message code="system.label.purchase.seq" default="순번"/>'    	      , type: 'string'},
			{name: 'TAX_CALC_TYPE'	 	    , text: '<t:message code="system.label.purchase.taxcalculationmethod" default="세액계산방법"/>'    , type: 'string',comboType:'AU', comboCode:'B030'},
			{name: 'REMARK'	         	    , text: '<t:message code="system.label.purchase.remarks" default="비고"/>'    	      , type: 'string'},
			{name: 'PROJECT_NO'      	    , text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'    	  , type: 'string'},
			{name: 'PURCHASE_TYPE'    		, text: 'PURCHASE_TYPE'	  , type: 'string'},
			{name: 'INOUT_TYPE'       		, text: 'INOUT_TYPE'	  , type: 'string'}
		]
	});
	
	Unilite.defineModel('map110ukrvORDERModel', {	//발주내역참조(선지급)
	    fields: [
		//	{name: 'GUBUN'        		, text: '<t:message code="system.label.purchase.selection" default="선택"/>'    	, type: 'string'},
			{name: 'ORDER_DATE'   		, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'    	, type: 'uniDate'},
			{name: 'ITEM_CODE'    		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'    	, type: 'string'},
			{name: 'ITEM_NAME'    		, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'    	    , type: 'string'},
			{name: 'SPEC'         		, text: '<t:message code="system.label.purchase.spec" default="규격"/>'    	    , type: 'string'},
			{name: 'ORDER_UNIT'   		, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'    	, type: 'string'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'    	, type: 'uniQty'},
			{name: 'ORDER_UNIT_P' 		, text: '<t:message code="system.label.purchase.price" default="단가"/>'    	    , type: 'uniUnitPrice'},
			{name: 'ORDER_O'      		, text: '<t:message code="system.label.purchase.amount" default="금액"/>'    	    , type: 'uniPrice'},
			{name: 'ADVAN_AMOUNT' 		, text: '<t:message code="system.label.purchase.paymentinadvance" default="선지급금"/>'    	, type: 'uniPrice'},
			{name: 'LOG_AMT'      		, text: '<t:message code="system.label.purchase.balanceamount" default="잔여액"/>'    	, type: 'uniPrice'},
			{name: 'REMAIN_Q'     		, text: 'REMAIN_Q'      , type: 'uniQty'},
			{name: 'MONEY_UNIT'   		, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'    	    , type: 'string'},
			{name: 'EXCHG_RATE_O' 		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'    	    , type: 'string'},
			{name: 'STOCK_UNIT'   		, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'    	, type: 'string'},
			{name: 'TRNS_RATE'    		, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'    	    , type: 'string'},
			{name: 'LC_NUM'       		, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'    	, type: 'string'},
			{name: 'ORDER_NUM'    		, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'    	, type: 'string'},
			{name: 'ORDER_SEQ'    		, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'    	, type: 'int'},
			{name: 'REMARK'       		, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'    	    , type: 'string'},
			{name: 'PROJECT_NO'   		, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'    	, type: 'string'},
			{name: 'ITEM_ACCOUNT' 		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'    	, type: 'string'},
			{name: 'ORDER_TYPE'   		, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'    	, type: 'string'},
			{name: 'ORDER_PRSN'   		, text: '<t:message code="system.label.purchase.charger" default="담당자"/>'    	, type: 'string'}
		]
	});

   /**
    * Store 정의(Service 정의)
    * @type 
    */               
	var directMasterStore1 = Unilite.createStore('map110ukrvMasterStore1',{
		model: 'map110ukrvModel',
		uniOpt: {
			isMaster: true,         // 상위 버튼 연결 
			editable: true,         // 수정 모드 사용 
			deletable: true,         // 삭제 가능 여부 
			allDeletable: true,
			useNavi: false         // prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,	
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
						masterForm.setValue("CHANGE_BASIS_NUM", master.CHANGE_BASIS_NUM);
						
						masterForm.setValue("BILL_NUM", master.BILL_NUM);
						panelResult.setValue("BILL_NUM", master.BILL_NUM);
						var cbNum = masterForm.getValue('CHANGE_BASIS_NUM');
						var bNum = masterForm.getValue('BILL_NUM');
						Ext.each(list, function(record, index) {
							if(record.data['CHANGE_BASIS_NUM'] != cbNum && record.data['BILL_NUM'] != bNum) {
								record.set('CHANGE_BASIS_NUM', cbNum);
								record.set('BILL_NUM', bNum);
							}
						})
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
						
						if (directMasterStore1.count() == 0) {   
							UniAppManager.app.onResetButtonDown();
						}else{
							directMasterStore1.loadStoreRecords();	
						}
					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('mms510ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
       		load: function(store, records, successful, eOpts) {
				this.fnSumAmountIForm();
				/*	if(BsaCodeInfo.gsAdvanUseYn == 'Y'){		
					var	btn = Ext.getCmp('orderhistoryBtn');	
						btn.hide(false);
					}else{
						btn.hide();
					}*/
           	},
           	add: function(store, records, index, eOpts) {
           		this.fnSumAmountIForm();
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           		this.fnSumAmountIForm();
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           		this.fnSumAmountIForm();
           	}
		},
		
		fnSumAmountIForm: function() {
			console.log("=============Exec fnSumAmountIForm()");
			var sumAmontI = Ext.isNumeric(this.sum('AMOUNT_I')) ? this.sum('AMOUNT_I'):0;
			var sumVatAmountO = Ext.isNumeric(this.sum('TAX_I')) ? this.sum('TAX_I'):0;
			var sumAmountTot = sumAmontI + sumVatAmountO;
			masterForm.setValue('AMOUNTI',sumAmontI);
			masterForm.setValue('VATAMOUNTO',sumVatAmountO);
			masterForm.setValue('AMOUNTTOT',sumAmountTot);
			//masterForm.fnCreditCheck()
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();         
			console.log( param );
			this.load({
				params: param
			});
		}
/*		fnSumAmountI:function(records){
			console.log("=============Exec fnSumAmountI()");
	//		var records = masterGrid.getSelectedRecords();
	//		var record = records[0].get('ITEM_CODE');
//			alert(record);
			//var records = directMasterStore1.loadStoreRecords();	
			var dSumTax = 0;
			var dSumAmountI = 0;
			var dSumAmountTot = 0;
			
			var dOrderUnitQ = 0;
			var dOrderUnitP = 0;
			var dCalAmoutI = 0;
			
			var dAmountI = 0;
			var dTax = 0;
			var dVatRate = 0;
			
			
			
////		조회시 값받아오질 못함	alert(CustomCodeInfo.gsUnderCalBase);
////						alert(CustomCodeInfo.gsTaxInclude);
////							alert(CustomCodeInfo.gsTaxCalcType);
			
			Ext.each(records,  function(record, index, recs){
			for(var i = 0; i<records.length-1;i++){
			var record = records[i];
		
			
				if(masterForm.getValue('VAT_RATE') == ''){
					dVatRate = 0;
				}else{
					dVatRate = masterForm.getValue('VAT_RATE');
				}
				
				dOrderUnitQ = Ext.isNumeric(this.sum('ORDER_UNIT_Q')) ? this.sum('ORDER_UNIT_Q'):0;
				dOrderUnitP = Ext.isNumeric(this.sum('ORDER_UNIT_P')) ? this.sum('ORDER_UNIT_P'):0;
				dCalAmoutI = Ext.isNumeric(this.sum('AMOUNT_I')) ? this.sum('AMOUNT_I'):0;
				
				
				dOrderUnitQ = record.get('ORDER_UNIT_Q');
				dOrderUnitP = record.get('ORDER_UNIT_P');
				dCalAmoutI = record.get('AMOUNT_I');
					
				if(Ext.isEmpty(records)){
					if(dCalAmoutI == (dOrderUnitQ * dOrderUnitP)){
						dAmountI = dCalAmoutI;
					}else{
						dAmountI = dOrderUnitQ * dOrderUnitP;
					}
				}else{
					dAmountI = dCalAmoutI;
				}
				
				if(dAmountI == '0'){
					dAmountI = record.get('FOR_AMOUNT_O') * record.get('EXCHG_RATE_O');
				}
				
				if(CustomCodeInfo.gsTaxInclude == '1'){
					Math.round(dAmountI,CustomCodeInfo.gsUnderCalBase);
					dTax = dAmountI * (dVatRate / 100);
					dSumAmountI = dSumAmountI + dAmountI;
					Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
					record.set('AMOUNT_I',dAmountI);
					
					if(record.phantom){
						record.set('TAX_I',dTax);
					}
				}else{
					dTemp = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '2');	//UniMatrl	??
					dTax  =	dAmountI - dTemp;	
					Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
					dTemp = dAmountI - dTax;
					Math.round(dTemp,CustomCodeInfo.gsUnderCalBase);
					dSumAmountTot = dSumAmountTot + dAmountI;
					
					record.set('AMOUNT_I',dTemp);
					if(record.phantom){
						record.set('TAX_I',dTax);
					}
				}
				
				dSumTax = dSumTax + dTax;
				
				Math.round(dSumAmountI,CustomCodeInfo.gsUnderCalBase);
				Math.round(dSumAmountTot,CustomCodeInfo.gsUnderCalBase);
				Math.round(dSumTax,CustomCodeInfo.gsUnderCalBase);
				
				if(CustomCodeInfo.gsTaxInclude == '1'){
					masterForm.setValue('AMOUNTI',dSumAmountI);
					masterForm.setValue('AMOUNTTOT',dSumAmountI);
				}else{
					masterForm.setValue('AMOUNTTOT',dSumAmountTot);
				}
				
				if(CustomCodeInfo.gsTaxCalcType == '1'){
					if(CustomCodeInfo.gsTaxInclude == '1'){
						dTax = masterForm.getValue('AMOUNTI') * (dVatRate / 100);
						Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
					}else{
						dTemp = masterForm.getValue('AMOUNTTOT') / ( dVatRate + 100 ) * 100;
						dTax = masterForm.getValue('AMOUNTTOT')	- dTemp;
						Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
						masterForm.setValue('AMOUNTI',masterForm.getValue('AMOUNTTOT') - dTax);
					
					}
					masterForm.setValue('VATAMOUNTO',dTax);
				}else{
					masterForm.setValue('VATAMOUNTO',dSumTax);
					if(CustomCodeInfo.gsTaxInclude != '1'){
						masterForm.setValue('AMOUNTI',masterForm.getValue('AMOUNTTOT') - dSumTax);
					}
					directMasterStore1.fnSumTax();
				}
				masterForm.setValue('AMOUNTTOT',masterForm.getValue('VATAMOUNTO') + masterForm.getValue('AMOUNTI'));
			})
			//	}
		},*/
		
	/*	fnSumTax: function() {
			var records = masterGrid.getSelectedRecords();
			Ext.each(records,  function(record, index, recs){
			
			var dSumTax = 0 ;
			var dSumAmountI = 0;
			var dSumAmountTot = 0;
			
			var dVatRate;
			var dAmountI;
			var dTax;
			var dTaxI = 0;
			
			if(masterForm.getValue('VAT_RATE') == ''){
				dVatRate = 0;	
			}else{
				dVatRate = masterForm.getValue('VAT_RATE');
			}
			
			dAmountI = record.get('AMOUNT_I');
			if(CustomCodeInfo.gsTaxInclude == '1'){
				dTax = record.get('TAX_I');
				dSumAmountI = dSumAmountI + dAmountI;
			}else{
				dTax = record.get('TAX_I');
				dSumAmountTot = dSumAmountTot + dAmountI + dTax;
			}
			
			dSumTax = dSumTax + dTax;
			
			Math.round(dSumAmountI,CustomCodeInfo.gsUnderCalBase);
			Math.round(dSumAmountTot,CustomCodeInfo.gsUnderCalBase);
			Math.round(dSumTax,CustomCodeInfo.gsUnderCalBase);
			
			if(CustomCodeInfo.gsTaxInclude == '1'){
				masterForm.setValue('AMOUNTI', dSumAmountI);
				masterForm.setValue('AMOUNTTOT', dSumAmountI);
			}else{
				masterForm.setValue('AMOUNTTOT', dSumAmountTot);	
			}
			
			if(record.get('TAX_I') != ''){
				dTaxI = dTaxI + record.get('TAX_I');	
			}
			
			masterForm.setValue('VATAMOUNTO',dTaxI);
			
			if(CustomCodeInfo.gsTaxInclude != '1'){
				masterForm.setValue('AMOUNTI', masterForm.getValue('AMOUNTTOT') - dSumTax);  	
			}
			
			masterForm.setValue('AMOUNTTOT',masterForm.getValue('VATAMOUNTO') + masterForm.getValue('AMOUNTI'));
			})
		}*/
	});//End of var directMasterStore1 = Unilite.createStore('map110ukrvMasterStore1',{

	var buyslipNoMasterStore = Unilite.createStore('buyslipNoMasterStore', {	//조회버튼 누르면 나오는 조회창
		model: 'buyslipNoMasterModel',
        autoLoad: false,
        uniOpt: {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable: false,			// 삭제 가능 여부
            useNavi: false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 'map110ukrvService.selectOrderNumMasterList'
            }
        },
        loadStoreRecords : function()	{
			var param= buyslipNoSearch.getValues();	
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(buyslipNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var receiveHistoryStore = Unilite.createStore('map110ukrvReceiveHistoryStore', {//입고내역참조
		model: 'map110ukrvRECEIVEModel',
        autoLoad: false,
        uniOpt: {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable: false,			// 삭제 가능 여부
            useNavi: false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 'map110ukrvService.selectreceiveHistoryList'                	
            }
        },
        
        listeners: {
        	load: function(store, records, successful, eOpts)	{
        			if(successful)	{
        			   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);  
        			   var receiveRecords = new Array();
        			   
        			   if(masterRecords.items.length > 0)	{
        			   		console.log("store.items :", store.items);
        			   		console.log("records", records);
        			   	
            			   	Ext.each(records, 
            			   		function(item, i)	{           			   								
		   							Ext.each(masterRecords.items, function(record, i)	{
		   								console.log("record :", record);
		   							
		   									if( (record.data['INOUT_NUM'] == item.data['INOUT_NUM']) 
		   											&& (record.data['INOUT_SEQ'] == item.data['INOUT_SEQ'])
		   									  ) 
		   									{
		   										receiveRecords.push(item);
		   									}
		   							});		
            			   	});
            			   store.remove(receiveRecords);
        			   }
        			}
        	}
        },
        loadStoreRecords : function()	{
			var param= receivehistorySearch.getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var returningHistoryStore = Unilite.createStore('map110ukrvReturningHistoryStore', {//반품내역참조
		model: 'map110ukrvRETURNINGModel',
        autoLoad: false,
        uniOpt: {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable: false,			// 삭제 가능 여부
            useNavi: false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 'map110ukrvService.selectreturningHistoryList'                	
            }
        },
        
        listeners: {
        	load: function(store, records, successful, eOpts)	{
        			if(successful)	{
        			   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);  
        			   var returningRecords = new Array();
        			   
        			   if(masterRecords.items.length > 0)	{
        			   		console.log("store.items :", store.items);
        			   		console.log("records", records);
        			   	
            			   	Ext.each(records, 
            			   		function(item, i)	{           			   								
		   							Ext.each(masterRecords.items, function(record, i)	{
		   								console.log("record :", record);
		   							
		   									if( (record.data['INOUT_NUM'] == item.data['INOUT_NUM']) 
		   											&& (record.data['INOUT_SEQ'] == item.data['INOUT_SEQ'])
		   									  ) 
		   									{
		   										returningRecords.push(item);
		   									}
		   							});		
            			   	});
            			   store.remove(returningRecords);
        			   }
        			}
        	}
        },
        loadStoreRecords : function()	{
			var param= returninghistorySearch.getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var orderHistoryStore = Unilite.createStore('map110ukrvOrderHistoryStore', {//발주내역참조(선지급)
		model: 'map110ukrvORDERModel',
        autoLoad: false,
        uniOpt: {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable: false,			// 삭제 가능 여부
            useNavi: false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read : 'map110ukrvService.selectorderHistoryList'               	
            }
        },
        listeners: {
        	load:function(store, records, successful, eOpts)	{
        			if(successful)	{
        			   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);  
        			   var orderRecords = new Array();
        			   
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
		   										orderRecords.push(item);
		   									}
		   							});		
            			   	});
            			   store.remove(orderRecords);
        			   }
        			}
        	}
        },
        loadStoreRecords : function()	{
			var param= orderhistorySearch.getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
   /**
    * 검색조건 (Search Panel)
    * @type 
    */
    var masterForm = Unilite.createSearchPanel('searchForm', {		
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
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [
				Unilite.popup('CUST', {
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					valueFieldName: 'CUSTOM_CODE',
			    	textFieldName: 'CUSTOM_NAME',
					allowBlank: false,
					holdable: 'hold',
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
								CustomCodeInfo.gsTaxInclude = records[0]["TAX_TYPE"];
								CustomCodeInfo.gsTaxCalcType = records[0]["TAX_CALC_TYPE"];
//								CustomCodeInfo.gsBillType = records[0]["BILL_TYPE"];
								
			/*				alert(CustomCodeInfo.gsUnderCalBase);
							alert(CustomCodeInfo.gsTaxInclude);
							alert(CustomCodeInfo.gsTaxCalcType);
							alert(CustomCodeInfo.gsBillType);*/
							
								masterForm.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
//								masterForm.setValue('BILL_TYPE', Unilite.nvl(records[0]["BILL_TYPE"],'51'));
								
//								panelResult.setValue('BILL_TYPE', Unilite.nvl(records[0]["BILL_TYPE"],'51'));
								panelResult.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							CustomCodeInfo.gsUnderCalBase = '';
							panelResult.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					}
				}),
				Unilite.popup('DEPT', { 
					fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
					valueFieldName: 'DEPT_CODE',
			   	 	textFieldName: 'DEPT_NAME',
					allowBlank: false,
					holdable: 'hold',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
								panelResult.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
									panelResult.setValue('DEPT_CODE', '');
									panelResult.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': masterForm.getValue('BILL_DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
				}),
			{
				fieldLabel: '매입사업장', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
						var param = {"DIV_CODE": masterForm.getValue('DIV_CODE')};
						map110ukrvService.billDivCode(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								masterForm.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
								panelResult.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
							}
						});
						masterForm.setValue('DEPT_CODE','');
						masterForm.setValue('DEPT_NAME','');
						panelResult.setValue('DEPT_CODE','');
						panelResult.setValue('DEPT_NAME','');
						
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				name:'BILL_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('endOfMonth'),
	            allowBlank: false,
	            width: 200,
	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_DATE', newValue);
					}
				}
	        },{
				fieldLabel: '<t:message code="system.label.purchase.billno" default="계산서번호"/>',
				name: 'BILL_NUM',
				xtype: 'uniTextfield',
				readOnly: isAutoInoutNum2,
			//	holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_NUM', newValue);
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.exdate" default="결의일"/>',
				name: 'CHANGE_BASIS_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('today'),
	            allowBlank: false,
	            width: 200,
	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CHANGE_BASIS_DATE', newValue);
					}
				}
	        },{
				fieldLabel: '<t:message code="system.label.purchase.purchaseno" default="매입번호"/>',
				name: 'CHANGE_BASIS_NUM',
				xtype: 'uniTextfield',
				readOnly: isAutoInoutNum1
		//		holdable: 'hold'
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasetype" default="매입유형"/>', 
				name: 'ACCOUNT_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M302',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						UniAppManager.app.fnGetAccountType(newValue);
						panelResult.setValue('ACCOUNT_TYPE', newValue);
						if(newValue == '10' ){
							panelResult.setValue('BILL_TYPE', '51');
						}
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>', 
				name: 'BILL_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'A022',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
						panelResult.setValue('BILL_TYPE', newValue);
						UniAppManager.app.fnGetBillType(newValue);
						panelResult.setValue('CRDT_NUM', '');
						panelResult.setValue('CRDT_NAME', '');
						masterForm.setValue('CRDT_NUM', '');
						masterForm.setValue('CRDT_NAME', '');
						
						panelResult.setValue('CREDIT_NUMBER', '');
						masterForm.setValue('CREDIT_NUMBER', '');
						
						if(masterForm.getValue('BILL_TYPE') == '53'){
							panelResult.setValue('ACCOUNT_TYPE', '20');
							masterForm.setValue('ACCOUNT_TYPE', '20');
						}
						else if(masterForm.getValue('BILL_TYPE') == '62'){
							panelResult.setValue('ACCOUNT_TYPE', '30');
							masterForm.setValue('ACCOUNT_TYPE', '30');
						}
						
						if(newValue == '51' || newValue == '57' ){
							panelResult.setValue('ACCOUNT_TYPE', '10');
						}
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>', 
				name: 'ORDER_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M001',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				xtype: 'container',
				layout: {type:'hbox' , align : 'stretch'},
				items:[
					Unilite.popup('CREDIT_CARD2', {
						fieldLabel: '법인카드',
						id:'MAP100_CUSTOM_CODE_SE',
						valueFieldName: 'CRDT_NUM',
				    	textFieldName: 'CRDT_NAME',
						valueFieldWidth: 85,
						textFieldWidth: 150,
						holdable: 'hold',
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('CRDT_NUM', masterForm.getValue('CRDT_NUM'));
									panelResult.setValue('CRDT_NAME', masterForm.getValue('CRDT_NAME'));
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('CRDT_NUM', '');
								panelResult.setValue('CRDT_NAME', '');
							}
						}
				}),{
					fieldLabel: '현금영수증번호',
					name: 'CREDIT_NUMBER',
					xtype: 'uniTextfield',
					id:'MAP100_CREDIT_NUM_SE',
					holdable: 'hold',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('CREDIT_NUMBER', newValue);
						}
					}
				}]
			},{
				fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>', 
				name: 'MONEY_UNIT', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B004',
				allowBlank: false,
				displayField: 'value',
				fieldStyle: 'text-align: center;',
				holdable: 'hold'
			},{
				fieldLabel: '<t:message code="system.label.purchase.declaredivsion" default="신고사업장"/>', 
				name: 'BILL_DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120',
				allowBlank: false,
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>',
				name: 'COMPANY_NUM',
				xtype: 'uniTextfield',
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasepostdate" default="매입기표일"/>',
				name: 'EX_DATE',
				xtype: 'uniDatefield',
				readOnly: true
			},{
				fieldLabel: 'DRAFT_YN',
				name: 'DRAFT_YN',
				xtype: 'uniTextfield',
				hidden: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>',
				name: 'ISSUE_EXPECTED_DATE',
	            xtype: 'uniDatefield',
	            width: 200,
	            holdable: 'hold'
	        },{
				fieldLabel: '결제방법', 
				name: 'RECEIPT_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B038',
				holdable: 'hold'
			},{
				fieldLabel: '<t:message code="system.label.purchase.slipno" default="전표번호"/>',
				name: 'EX_NUM',
				xtype: 'uniNumberfield',
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				name: 'PROJECT_NO',
				xtype: 'uniTextfield',
				readOnly: true
			},{
				fieldLabel: '총매입금액[(1)+(2)]',
				name: 'AMOUNTTOT',
				xtype: 'uniNumberfield',
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.vatrate" default="부가세율"/>',
				name: 'VAT_RATE',
				xtype: 'uniNumberfield',
				holdable: 'hold'
			},{
				fieldLabel: '총부가세액(1)',
				name: 'VATAMOUNTO',
				xtype: 'uniNumberfield',
				readOnly: true
			},{
				fieldLabel: '총공급가액(2)',
				name: 'AMOUNTI',
				xtype: 'uniNumberfield',
				readOnly: true
			}]	
		}],
		api: {
			load: 'map110ukrvService.selectForm',
			submit: 'map110ukrvService.syncForm'				
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
	});//End of var masterForm = Unilite.createSearchForm('searchForm', {

	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [
			Unilite.popup('CUST', {
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					valueFieldName: 'CUSTOM_CODE',
			    	textFieldName: 'CUSTOM_NAME',
					allowBlank: false,
					holdable: 'hold',
					colspan:2,
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
								CustomCodeInfo.gsTaxInclude = records[0]["TAX_TYPE"];
								CustomCodeInfo.gsTaxCalcType = records[0]["TAX_CALC_TYPE"];
								
//							alert(CustomCodeInfo.gsUnderCalBase);
//							alert(CustomCodeInfo.gsTaxInclude);
//							alert(CustomCodeInfo.gsTaxCalcType);
//								
								masterForm.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
//								masterForm.setValue('BILL_TYPE', Unilite.nvl(records[0]["BILL_TYPE"],'51'));
								
//								panelResult.setValue('BILL_TYPE', Unilite.nvl(records[0]["BILL_TYPE"],'51'));
								masterForm.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
								masterForm.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							CustomCodeInfo.gsUnderCalBase = '';
							masterForm.setValue('CUSTOM_CODE', '');
							masterForm.setValue('CUSTOM_NAME', '');
						}
					}
				}),
				Unilite.popup('DEPT', { 
					fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
					valueFieldName: 'DEPT_CODE',
			   	 	textFieldName: 'DEPT_NAME',
					allowBlank: false,
					holdable: 'hold',
					colspan:2,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
								masterForm.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
									masterForm.setValue('DEPT_CODE', '');
									masterForm.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
				}),
			{
				fieldLabel: '매입사업장', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('DIV_CODE', newValue);
						var param = {"DIV_CODE": masterForm.getValue('DIV_CODE')};
						map110ukrvService.billDivCode(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								masterForm.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
								panelResult.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
							}
						});
						masterForm.setValue('DEPT_CODE','');
						masterForm.setValue('DEPT_NAME','');
						panelResult.setValue('DEPT_CODE','');
						panelResult.setValue('DEPT_NAME','');
						
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				name:'BILL_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('endOfMonth'),
	            allowBlank: false,
	            width: 200,
	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('BILL_DATE', newValue);
					}
				}
	        },{
				fieldLabel: '<t:message code="system.label.purchase.billno" default="계산서번호"/>',
				name: 'BILL_NUM',
				xtype: 'uniTextfield',
				readOnly: isAutoInoutNum2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('BILL_NUM', newValue);
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.exdate" default="결의일"/>',
				name: 'CHANGE_BASIS_DATE',
	            xtype: 'uniDatefield',
	            value: UniDate.get('today'),
	            allowBlank: false,
	            width: 200,
	            holdable: 'hold',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('CHANGE_BASIS_DATE', newValue);
					}
				}
	        },{
				fieldLabel: '<t:message code="system.label.purchase.declaredivsion" default="신고사업장"/>', 
				name: 'BILL_DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120',
				allowBlank: false,
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasetype" default="매입유형"/>', 
				name: 'ACCOUNT_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M302',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						UniAppManager.app.fnGetAccountType(newValue);
						masterForm.setValue('ACCOUNT_TYPE', newValue);
						if(newValue == '10' ){
							masterForm.setValue('BILL_TYPE', '51');
						}	
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.billtype" default="계산서유형"/>', 
				name: 'BILL_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'A022',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('BILL_TYPE', newValue);
						UniAppManager.app.fnGetBillType(newValue);
						panelResult.setValue('CRDT_NUM', '');
						panelResult.setValue('CRDT_NAME', '');
						masterForm.setValue('CRDT_NUM', '');
						masterForm.setValue('CRDT_NAME', '');
						
						panelResult.setValue('CREDIT_NUMBER', '');
						masterForm.setValue('CREDIT_NUMBER', '');
						
						if(masterForm.getValue('BILL_TYPE') == '53'){
							panelResult.setValue('ACCOUNT_TYPE', '20');
							masterForm.setValue('ACCOUNT_TYPE', '20');
						}
						else if(masterForm.getValue('BILL_TYPE') == '62'){
							panelResult.setValue('ACCOUNT_TYPE', '30');
							masterForm.setValue('ACCOUNT_TYPE', '30');
							
						}else if(masterForm.getValue('BILL_TYPE') == '51'){
							panelResult.setValue('ACCOUNT_TYPE', '10');
							masterForm.setValue('ACCOUNT_TYPE', '10');
							
						}if(newValue == '51' || newValue == '57' ){
							masterForm.setValue('ACCOUNT_TYPE', '10');
						}
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>', 
				name: 'ORDER_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M001',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				xtype: 'container',
				colspan:4,
				layout: {type:'hbox' , align : 'stretch'},
				items:[
					Unilite.popup('CREDIT_CARD2', {
					fieldLabel: '법인카드',
					id:'MAP100_CUSTOM_CODE_RE',
					valueFieldName: 'CRDT_NUM',
			    	textFieldName: 'CRDT_NAME',
					valueFieldWidth: 85,
					textFieldWidth: 150,
					holdable: 'hold',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('CRDT_NUM', panelResult.getValue('CRDT_NUM'));
								masterForm.setValue('CRDT_NAME', panelResult.getValue('CRDT_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							masterForm.setValue('CRDT_NUM', '');
							masterForm.setValue('CRDT_NUM', '');
						}
					}
			}),{
				fieldLabel: '현금영수증번호',
				name: 'CREDIT_NUMBER',
				xtype: 'uniTextfield',
				id:'MAP100_CREDIT_NUM_RE',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('CREDIT_NUMBER', newValue);
					}
				}
			}]
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
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
	
	
	
	var buyslipNoSearch = Unilite.createSearchForm('buyslipNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns: 2},
	    trackResetOnLoad: true,
	    items: [
			{
				fieldLabel: '매입사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				colspan: 2
			},
				Unilite.popup('CUST',{ 
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					validateBlank: false,
					extParam: {'CUSTOM_TYPE': ['1','2']}
				}),
				Unilite.popup('DEPT', { 
					fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
					valueFieldName: 'DEPT_CODE',
			   	 	textFieldName: 'DEPT_NAME',
					validateBlank: false,
					listeners: {
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
				}),
			{
				fieldLabel: '<t:message code="system.label.purchase.exdate" default="결의일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'CHANGE_BASIS_DATE_FR',
				endFieldName: 'CHANGE_BASIS_DATE_TO',
				width: 315
			},{
				fieldLabel: '<t:message code="system.label.purchase.billno" default="계산서번호"/>',
				name: 'BILL_NUM',
				xtype: 'uniTextfield'
			},{
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'BILL_DATE_FR',
				endFieldName: 'BILL_DATE_TO',
				width: 315
			},
				Unilite.popup('', { 
					fieldLabel: '<t:message code="system.label.purchase.manageno" default="관리번호"/>', 
					textFieldWidth: 170, 
					validateBlank: false
			})
		]
    }); // createSearchForm
    
    var receivehistorySearch = Unilite.createSearchForm('receivehistoryForm', {//입고내역참조
            layout:  {type: 'uniTable', columns: 4},
            items: [
            	{
					fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'INOUT_DATE_FR',
					endFieldName: 'INOUT_DATE_TO',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width: 315
				},{
					fieldLabel: '세구분',
					name: 'TAX_TYPE',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B059',
					allowBlank: false,
					fieldStyle: 'text-align: center;',
					holdable: 'hold'/*,
					readOnly:true*/
				},
					Unilite.popup('',{ 
						fieldLabel: '<t:message code="system.label.purchase.manageno" default="관리번호"/>', 
						validateBlank: false,
						colspan: 2
					}),
					Unilite.popup('DIV_PUMOK',{ 
						fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>', 
						validateBlank: false
					}),
				/*{
					fieldLabel: '총부가세액',
					name: 'VATAMOUNTO',
					xtype: 'uniNumberfield',
					readOnly: true
				},{
					fieldLabel: '총공급가액',
					name: 'AMOUNTI',
					xtype: 'uniNumberfield',
					readOnly: true
				},{
					fieldLabel: '총매입금액',
					name: 'AMOUNTTOT',
					xtype: 'uniNumberfield',
					readOnly: true
				},*/{
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					name: 'CUSTOM_CODE',
					xtype: 'uniTextfield',
					hidden: true
				},{
					fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
					name: 'MONEY_UNIT',
					xtype: 'uniTextfield',
					hidden: true
				},{
					fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniTextfield',
					hidden: true
				},{
					fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
					name: 'ORDER_TYPE',
					xtype: 'uniTextfield',
					hidden: true
				},{
					xtype: 'radiogroup',		            		
					fieldLabel: '불량포함여부',						            		
					id: 'rdoSelect',
					items: [
						{boxLabel: '예', width: 60, name: 'rdoSelect', inputValue: 'Y', checked: true},
						{boxLabel: '아니오', width: 60,  name: 'rdoSelect', inputValue: 'N'}
					]
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
    
    var returninghistorySearch = Unilite.createSearchForm('returninghistoryForm', {//반품내역참조
            layout:  {type: 'uniTable', columns: 4},
            items: [
            	{
					fieldLabel: '반품일',
					xtype: 'uniDateRangefield',
					startFieldName: 'INOUT_DATE_FR',
					endFieldName: 'INOUT_DATE_TO',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width: 315
				},{
					fieldLabel: '세구분',
					name: 'TAX_TYPE',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B059',
					allowBlank: false,
					fieldStyle: 'text-align: center;',
					holdable: 'hold'/*,
					readOnly:true*/
				},
					Unilite.popup('',{ 
						fieldLabel: '<t:message code="system.label.purchase.manageno" default="관리번호"/>', 
						validateBlank: false,
						colspan: 2
					}),
					Unilite.popup('DIV_PUMOK',{ 
						fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>', 
						validateBlank: false
					}),
				/*{
					fieldLabel: '총부가세액',
					name: 'VATAMOUNTO',
					xtype: 'uniNumberfield',
					readOnly: true
				},{
					fieldLabel: '총공급가액',
					name: 'AMOUNTI',
					xtype: 'uniNumberfield',
					readOnly: true
				},{
					fieldLabel: '총반품금액',
					name: 'AMOUNTTOT',
					xtype: 'uniNumberfield',
					readOnly: true
				},*/{
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					name: 'CUSTOM_CODE',
					xtype: 'uniTextfield',
					hidden: true
				},{
					fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
					name: 'MONEY_UNIT',
					xtype: 'uniTextfield',
					hidden: true
				},{
					fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniTextfield',
					hidden: true
				},{
					fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
					name: 'ORDER_TYPE',
					xtype: 'uniTextfield',
					hidden: true
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
    
    var orderhistorySearch = Unilite.createSearchForm('orderhistoryForm', {//발주내역참조(선지급)
        layout:  {type: 'uniTable', columns: 4},
        items: [
        	{
				fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315
			},{
				fieldLabel: '세구분',
				name: 'TAX_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B059',
				fieldStyle: 'text-align: center;'
			},
				Unilite.popup('',{ 
					fieldLabel: '<t:message code="system.label.purchase.manageno" default="관리번호"/>',
					name: 'PROJECT_NO',
					validateBlank: false,
					colspan: 2
				}),
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					valueFieldName: 'ITEM_CODE',
		   	 		textFieldName: 'ITEM_NAME',
					validateBlank: false
				}),
			{
				fieldLabel: '총부가세액',
				name: 'VATAMOUNTO',
				xtype: 'uniNumberfield',
				readOnly: true
			},{
				fieldLabel: '총공급가액',
				name: 'AMOUNTI',
				xtype: 'uniNumberfield',
				readOnly: true
			},{
				fieldLabel: '총매입금액',
				name: 'AMOUNTTOT',
				xtype: 'uniNumberfield',
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				name: 'CUSTOM_CODE',
				xtype: 'uniTextfield',
				hidden: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
				name: 'MONEY_UNIT',
				xtype: 'uniTextfield',
				hidden: true
			}]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('map110ukrvGrid1', {
       // for tab       
		layout: 'fit',
		region:'center',
		excelTitle: '개별 매입지급결의 등록',
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
           	itemId: 'orderTool',
			text: '<t:message code="system.label.purchase.reference" default="참조..."/>',
			iconCls: 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'receivehistoryBtn',
					text: '입고내역참조',
					handler: function() {
							if(masterForm.setAllFieldsReadOnly(true) == false){
								return false;
							}
							var viewCustomCodeSE = Ext.getCmp('MAP100_CUSTOM_CODE_RE');
				        	var viewCreditNumSE = Ext.getCmp('MAP100_CREDIT_NUM_RE');
				        	
							if(masterForm.getValue('BILL_TYPE') == '53'){
								if(viewCustomCodeSE.setVisible(true)){
									if(masterForm.getValue('CRDT_NUM') ==''){
										alert('법인카드는 필수 입력 사항입니다.');
										return false;
									}
								}else{
								}
							}
							if(masterForm.getValue('BILL_TYPE') == '62'){
								if(viewCreditNumSE.setVisible(true)){
									if(masterForm.getValue('CREDIT_NUMBER') ==''){
										alert('현금영수증번호는 필수 입력 사항입니다.');
										return false;
									}
								}else{
								}
							}
							openReceiveHistoryWindow();
							
							
					}
				},{
					itemId: 'returninghistoryBtn',
					text: '반품내역참조',
					handler: function() {
							if(masterForm.setAllFieldsReadOnly(true) == false){
								return false;
							}
							var viewCustomCodeSE = Ext.getCmp('MAP100_CUSTOM_CODE_SE');
				        	var viewCreditNumSE = Ext.getCmp('MAP100_CREDIT_NUM_SE');
				        	
							if(masterForm.getValue('BILL_TYPE') == '53'){
								if(viewCustomCodeSE.setVisible(true)){
									if(masterForm.getValue('CRDT_NUM') ==''){
										alert('법인카드는 필수 입력 사항입니다.');
										return false;
									}
								}else{
								}
							}
							if(masterForm.getValue('BILL_TYPE') == '62'){
								if(viewCreditNumSE.setVisible(true)){
									if(masterForm.getValue('CREDIT_NUMBER') ==''){
										alert('현금영수증번호는 필수 입력 사항입니다.');
										return false;
									}
								}else{
								}
							}
						openReturningHistoryWindow();
					}
				}/*,{
					itemId: 'orderhistoryBtn',
					id: 'orderhistoryBtn',
					text: '발주내역참조(선지급)',
					handler: function() {
							if(masterForm.setAllFieldsReadOnly(true) == false){
								return false;
							}
						openOrderHistoryWindow();
					}
				}*/]
			})
		}], 
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'CHANGE_BASIS_NUM' , width: 93, hidden: true },
			{dataIndex: 'CHANGE_BASIS_SEQ' , width: 33 },
			{dataIndex: 'INSTOCK_DATE'     , width: 80 },
			{dataIndex: 'ITEM_ACCOUNT'     , width: 66, hidden: true  },
			{dataIndex: 'ITEM_CODE'	       , width: 120 },
			{dataIndex: 'ITEM_NAME'        , width: 300 },
			{dataIndex: 'SPEC'		       , width: 88 },
			{dataIndex: 'ORDER_UNIT'	   , width: 88,align:'center' },
			{dataIndex: 'ORDER_UNIT_Q'     , width: 100 },
			{dataIndex: 'REMAIN_Q'	       , width: 80, hidden: true  },
			{dataIndex: 'ORDER_UNIT_P'     , width: 86 },
			{dataIndex: 'AMOUNT_P'	       , width: 100, hidden: true  },
			{dataIndex: 'AMOUNT_I'         , width: 100 },
			{dataIndex: 'TAX_I'	           , width: 80 },
			{dataIndex: 'TOTAL_I'          , width: 120 },
			{dataIndex: 'ORDER_UNIT_FOR_P' , width: 133 },
			{dataIndex: 'FOREIGN_P'	       , width: 100, hidden: true  },
			{dataIndex: 'FOR_AMOUNT_O'     , width: 100 },
			{dataIndex: 'MONEY_UNIT'	   , width: 53,align:'center' },
			{dataIndex: 'EXCHG_RATE_O'     , width: 80 },
			{dataIndex: 'STOCK_UNIT'	   , width: 80,align:'center' },
			{dataIndex: 'TRNS_RATE'	       , width: 80 },
			{dataIndex: 'BUY_Q'		       , width: 100 },
			{dataIndex: 'ORDER_TYPE'	   , width: 66,align:'center', hidden: true  },
			{dataIndex: 'ORDER_PRSN'	   , width: 66,align:'center', hidden: true  },
			{dataIndex: 'LC_NUM'		   , width: 86, hidden: true  },
			{dataIndex: 'BL_NUM'	       , width: 86, hidden: true  },
			{dataIndex: 'ORDER_NUM'	       , width: 93, hidden: true  },
			{dataIndex: 'ORDER_SEQ'	       , width: 33, hidden: true  },
			{dataIndex: 'INOUT_NUM'	       , width: 130 },
			{dataIndex: 'INOUT_SEQ'	       , width: 66 },
			{dataIndex: 'DIV_CODE'	       , width: 33, hidden: true  },
			{dataIndex: 'BILL_DIV_CODE'    , width: 33, hidden: true  },
			{dataIndex: 'CUSTOM_CODE'	   , width: 33, hidden: true  },
			{dataIndex: 'REMARK'           , width: 133 },
			{dataIndex: 'PROJECT_NO'       , width: 133 },
			{dataIndex: 'UPDATE_DB_USER'   , width: 33, hidden: true  },
			{dataIndex: 'UPDATE_DB_TIME'   , width: 33, hidden: true  },
			{dataIndex: 'COMP_CODE'	       , width: 33, hidden: true  },
			{dataIndex: 'ADVAN_YN'         , width: 53, hidden: true  },
			{dataIndex: 'ADVAN_AMOUNT'     , width: 53, hidden: true  },
			{dataIndex: 'PURCHASE_TYPE'    , width: 53,align:'center', hidden: true  },
			{dataIndex: 'INOUT_TYPE'       , width: 53,align:'center', hidden: true },
			
			{dataIndex: 'TAX_TYPE'     	   , width: 53, hidden: true  }
		],
		
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				return false;	
    		}
		},
	/*listeners: {
		beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom){
					if(e.field == 'ORDER_UNIT_Q' || e.field == 'TAX_I') {
						return true;
					}else{
						return false;
					}
					
					if(e.record.data.ADVAN_YN == 'Y' || e.record.data.ADVAN_AMOUNT > 0){
						if(e.field == 'AMOUNT_I') return true;	
					}else{
						if(e.field == 'AMOUNT_I') return false;		
					}
				}else{
					return false;	
				}
		}
			
	},*/
/*		disabledLinkButtons: function(b) {
       		this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
       		this.down('#procTool').menu.down('#issueLinkBtn').setDisabled(b);
       		this.down('#procTool').menu.down('#saleLinkBtn').setDisabled(b);
		},*/
		setItemData: function(record, dataClear) {
       		var grdRecord = this.getSelectedRecord();
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'		,"");
       			grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,""); 
				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('STOCK_UNIT'		,"");
				grdRecord.set('ORDER_Q'			,0);
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
       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
       			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'				, record['SPEC']); 
				grdRecord.set('ORDER_UNIT'			, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);
				grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
				// grdRecord.set('OUT_DIV_CODE' ,record['DIV_CODE']);
				grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
				grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
				grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
				grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
				grdRecord.set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));
				
				UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
       		}
		},
		setReceiveData: function(record){
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('CHANGE_BASIS_NUM'	, masterForm.getValue('CHANGE_BASIS_NUM'));	
	//		grdRecord.set('CHANGE_BASIS_SEQ'	, lSerNo); 추후
			grdRecord.set('INOUT_NUM'			, record['INOUT_NUM']);
			grdRecord.set('INOUT_SEQ'			, record['INOUT_SEQ']);
			grdRecord.set('INSTOCK_DATE'		, record['INSTOCK_DATE']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('ORDER_UNIT_Q'		, record['REMAIN_Q']);
			grdRecord.set('REMAIN_Q'			, record['REMAIN_Q']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['ORDER_UNIT_FOR_P']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P']);
			
			grdRecord.set('AMOUNT_I'			, record['INOUT_I']);
			grdRecord.set('TAX_I'				, record['INOUT_TAX_AMT']);
			grdRecord.set('TOTAL_I'				, record['TOTAL_INOUT_I']);
			
			grdRecord.set('FOREIGN_P'			, record['FOREIGN_P']);
			grdRecord.set('FOR_AMOUNT_O'		, record['FOR_AMOUNT_O']);
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('EXCHG_RATE_O'		, record['EXCHG_RATE_O']);
			grdRecord.set('BUY_Q'				, record['BUY_Q']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_PRSN'			, record['ORDER_PRSN']);
			grdRecord.set('LC_NUM'				, record['LC_NUM']);
			grdRecord.set('BL_NUM'				, record['BL_NUM']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));	
			grdRecord.set('BILL_DIV_CODE'		, masterForm.getValue('BILL_DIV_CODE'));	
			grdRecord.set('CUSTOM_CODE'			, masterForm.getValue('CUSTOM_CODE'));	
			grdRecord.set('AMOUNT_P'			, record['AMOUNT_P']);
			CustomCodeInfo.gsTaxCalcType = record['TAX_CALC_TYPE'];
			grdRecord.set('ADVAN_YN'			, 'N');
			grdRecord.set('ADVAN_AMOUNT'			, record['ADVAN_AMOUNT']);
			if(record['PROJECT_NO'] != ''){
				grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);	
			}else{
				if(masterForm.getValue('PROJECT_NO') != ''){
					grdRecord.set('PROJECT_NO'			, masterForm.getValue('PROJECT_NO'));	
				}
			}
			
			grdRecord.set('REMARK'			, record['REMARK']);
			grdRecord.set('PURCHASE_TYPE'	, record['PURCHASE_TYPE']);
			grdRecord.set('INOUT_TYPE'		, record['INOUT_TYPE']);
			
			if(receivehistorySearch.getValue('TAX_TYPE' == '1')){
				masterFrom.setValue('BILL_TYPE','51');
				panelResult.setValue('BILL_TYPE','51');
			}else if(receivehistorySearch.getValue('TAX_TYPE' == '2')){
				masterFrom.setValue('BILL_TYPE','57');
				panelResult.setValue('BILL_TYPE','57');
			}
			
//			directMasterStore1.fnSumAmountI(grdRecord);
		},
		
		setReturningData: function(record){
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('CHANGE_BASIS_NUM'	, masterForm.getValue('CHANGE_BASIS_NUM'));	
	//		grdRecord.set('CHANGE_BASIS_SEQ'	, lSerNo); 추후
			grdRecord.set('INOUT_NUM'			, record['INOUT_NUM']);
			grdRecord.set('INOUT_SEQ'			, record['INOUT_SEQ']);
			grdRecord.set('INSTOCK_DATE'		, record['INSTOCK_DATE']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('ORDER_UNIT_Q'		, record['REMAIN_Q'] * -1);
			grdRecord.set('REMAIN_Q'			, record['REMAIN_Q'] * -1);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['ORDER_UNIT_FOR_P']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P']);
			
			grdRecord.set('AMOUNT_I'			, record['INOUT_I'] * -1);
			grdRecord.set('TAX_I'				, record['INOUT_TAX_AMT'] * -1);
			grdRecord.set('TOTAL_I'             , record['TOTAL_INOUT_I'] * -1);	
			
			grdRecord.set('FOREIGN_P'			, record['FOREIGN_P']);
			grdRecord.set('FOR_AMOUNT_O'		, record['FOR_AMOUNT_O'] * -1);
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('EXCHG_RATE_O'		, record['EXCHG_RATE_O']);
			grdRecord.set('BUY_Q'				, record['BUY_Q'] * -1);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_PRSN'			, record['ORDER_PRSN']);
			grdRecord.set('LC_NUM'				, record['LC_NUM']);
			grdRecord.set('BL_NUM'				, record['BL_NUM']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));	
			grdRecord.set('BILL_DIV_CODE'		, masterForm.getValue('BILL_DIV_CODE'));	
			grdRecord.set('CUSTOM_CODE'			, masterForm.getValue('CUSTOM_CODE'));	
			grdRecord.set('AMOUNT_P'			, record['AMOUNT_P']);
			CustomCodeInfo.gsTaxCalcType = record['TAX_CALC_TYPE'];
			grdRecord.set('ADVAN_YN'			, 'N');
			grdRecord.set('ADVAN_AMOUNT'			, record['ADVAN_AMOUNT']);
			if(record['PROJECT_NO'] != ''){
				grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);	
			}else{
				if(masterForm.getValue('PROJECT_NO') != ''){
					grdRecord.set('PROJECT_NO'			, masterForm.getValue('PROJECT_NO'));	
				}
			}
			
			grdRecord.set('REMARK'			, record['REMARK']);
			grdRecord.set('PURCHASE_TYPE'	, record['PURCHASE_TYPE']);
			grdRecord.set('INOUT_TYPE'		, record['INOUT_TYPE']);
			
			if(returninghistorySearch.getValue('TAX_TYPE' == '1')){
				masterFrom.setValue('BILL_TYPE','51');
				panelResult.setValue('BILL_TYPE','51');
			}else if(returninghistorySearch.getValue('TAX_TYPE' == '2')){
				masterFrom.setValue('BILL_TYPE','57');
				panelResult.setValue('BILL_TYPE','57');
			}
//			directMasterStore1.fnSumAmountI(grdRecord);
		},
		
		setOrderData: function(record){
			var grdRecord = this.getSelectedRecord();
			
			grdRecord.set('CHANGE_BASIS_NUM'	, masterForm.getValue('CHANGE_BASIS_NUM'));	
	//		grdRecord.set('CHANGE_BASIS_SEQ'	, lSerNo); 추후
			grdRecord.set('INOUT_NUM'			, '');
			grdRecord.set('INOUT_SEQ'			, '');
			grdRecord.set('INSTOCK_DATE'		, '');
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('ORDER_UNIT_Q'		, record['REMAIN_Q']);
			grdRecord.set('REMAIN_Q'			, record['REMAIN_Q']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['ORDER_UNIT_P']);
			grdRecord.set('AMOUNT_I'			, record['LOG_AMT']);
			
			grdRecord.set('FOREIGN_P'			, record['ORDER_UNIT_P']);
			grdRecord.set('FOR_AMOUNT_O'		, record['LOG_AMT']);
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('EXCHG_RATE_O'		, record['EXCHG_RATE_O']);
			grdRecord.set('BUY_Q'				, record['REMAIN_Q']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_PRSN'			, record['ORDER_PRSN']);
			grdRecord.set('LC_NUM'				, record['LC_NUM']);
			grdRecord.set('BL_NUM'				, '');
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));	
			grdRecord.set('BILL_DIV_CODE'		, masterForm.getValue('BILL_DIV_CODE'));	
			grdRecord.set('CUSTOM_CODE'			, masterForm.getValue('CUSTOM_CODE'));	
			grdRecord.set('ADVAN_YN'			, 'Y');
			grdRecord.set('AMOUNT_P'			, record['ORDER_UNIT_P']);
			
			if(record['PROJECT_NO'] != ''){
				grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);	
			}else{
				if(masterForm.getValue('PROJECT_NO') != ''){
					grdRecord.set('PROJECT_NO'			, masterForm.getValue('PROJECT_NO'));	
				}
			}
			
			grdRecord.set('REMARK'			, record['REMARK']);
			
		}
	});//End of var masterGrid = Unilite.createGrid('map110ukrvGrid1', {   

    var buyslipNoMasterGrid = Unilite.createGrid('map110ukrvbuyslipNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
        // title: '기본',
        layout: 'fit',       
        excelTitle: '개별 매입지급결의 등록(매입전표번호검색)',
		store: buyslipNoMasterStore,
		uniOpt: {	
					expandLastColumn: false,
					useRowNumberer: false
		},
        columns:  [ 
			{ dataIndex: 'CUSTOM_NAME'			    	,  width:153},
			{ dataIndex: 'CHANGE_BASIS_DATE'  	    	,  width:93},
			{ dataIndex: 'MONEY_UNIT'		    	    ,  width:53,align:'center', hidden:true},
			{ dataIndex: 'AMOUNT_I'		    	    	,  width:126},
			{ dataIndex: 'BILL_NUM'		    	    	,  width:100},
			{ dataIndex: 'BILL_DATE'		    	    ,  width:93},
			{ dataIndex: 'CHANGE_BASIS_NUM'   	    	,  width:130},
			{ dataIndex: 'DIV_CODE'	        	    	,  width:66, hidden:true},
			{ dataIndex: 'BILL_DIV_CODE'	    	    ,  width:66, hidden:true},
			{ dataIndex: 'CUSTOM_CODE'			    	,  width:53, hidden:true},
			{ dataIndex: 'COMPANY_NUM'			    	,  width:80, hidden:true},
			{ dataIndex: 'BILL_TYPE'		    	    ,  width:93,align:'center', hidden:true},
			{ dataIndex: 'RECEIPT_TYPE'	    	    	,  width:60,align:'center', hidden:true},
			{ dataIndex: 'ORDER_TYPE'		    	    ,  width:60,align:'center', hidden:true},
			{ dataIndex: 'VAT_RATE'		    	    	,  width:60, hidden:true},
			{ dataIndex: 'VAT_AMOUNT_O'	    	    	,  width:80, hidden:true},
			{ dataIndex: 'DEPT_CODE'		    	    ,  width:80, hidden:true},
			{ dataIndex: 'EX_DATE'				    	,  width:80, hidden:true},
			{ dataIndex: 'EX_NUM'			    	    ,  width:86, hidden:true},
			{ dataIndex: 'AGREE_YN'		    	    	,  width:80, hidden:true},
			{ dataIndex: 'DRAFT_YN'		    	    	,  width:80, hidden:true},
			{ dataIndex: 'DEPT_NAME'		    	    ,  width:80, hidden:true},
			{ dataIndex: 'ISSUE_EXPECTED_DATE'	    	,  width:80, hidden:true},
			{ dataIndex: 'ACCOUNT_TYPE'	    	    	,  width:80, hidden:true},
			{ dataIndex: 'PROJECT_NO'		    	    ,  width:86},
			{ dataIndex: 'CREDIT_NUM'		    	    ,  width:120 , hidden:true},
			{ dataIndex: 'CRDT_NAME'		    	    ,  width:100 , hidden:true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				buyslipNoMasterGrid.returnData(record);
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
          		'CHANGE_BASIS_NUM':record.get('CHANGE_BASIS_NUM'),
          		'CUSTOM_CODE':record.get('CUSTOM_CODE'),
          		'CUSTOM_NAME':record.get('CUSTOM_NAME'),
          		'DEPT_CODE':record.get('DEPT_CODE'),
          		'DEPT_NAME':record.get('DEPT_NAME'),
          		//'BILL_NUM':record.get('BILL_NUM'),
         	 	//'BILL_DATE':record.get('BILL_DATE'),
          		//'CHANGE_BASIS_DATE':record.get('CHANGE_BASIS_DATE'),
        	  	'BILL_TYPE':record.get('BILL_TYPE'),
          		'MONEY_UNIT':record.get('MONEY_UNIT'),
          		'ACCOUNT_TYPE':record.get('ACCOUNT_TYPE'),
          		'BILL_DIV_CODE':record.get('BILL_DIV_CODE'),
          		'COMPANY_NUM':record.get('COMPANY_NUM'),
          		//'EX_DATE':record.get('EX_DATE'),
          		'ISSUE_EXPECTED_DATE':record.get('ISSUE_EXPECTED_DATE'),
          		'ORDER_TYPE':record.get('ORDER_TYPE'),
          		//'EX_NUM':record.get('EX_NUM'),
          		'PROJECT_NO':record.get('PROJECT_NO')
          		//'VAT_RATE':record.get('VAT_RATE')
          		
          	});
          	/**/
          	if(masterForm.getValue('BILL_TYPE') == '53'){
          		masterForm.setValue('CRDT_NUM' ,record.get('CREDIT_NUM'))
          		panelResult.setValue('CRDT_NUM' ,record.get('CREDIT_NUM'))
          		
          		masterForm.setValue('CRDT_NAME' ,record.get('CRDT_NAME'))
          		panelResult.setValue('CRDT_NAME' ,record.get('CRDT_NAME'))
          		
          	}
          	if(masterForm.getValue('BILL_TYPE') == '62'){
          		masterForm.setValue('CREDIT_NUMBER' ,record.get('CREDIT_NUM'))
          		panelResult.setValue('CREDIT_NUMBER' ,record.get('CREDIT_NUM'))
          	}
          	
          	panelResult.setValues({
          		'DIV_CODE':record.get('DIV_CODE'),
          		'CUSTOM_CODE':record.get('CUSTOM_CODE'),
          		'CUSTOM_NAME':record.get('CUSTOM_NAME'),
          		'DEPT_CODE':record.get('DEPT_CODE'),
          		'DEPT_NAME':record.get('DEPT_NAME')
          	})
          }
    });
    
    var receivehistoryGrid = Unilite.createGrid('map110ukrvreceivehistoryGrid', {//입고내역참조
        // title: '기본',
        layout: 'fit',
        excelTitle: '개별 매입지급결의 등록(입고내역참조)',
    	store: receiveHistoryStore,
    	selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: false
        /*	listeners: { 
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			UniAppManager.app.fnSumAmountIrefer();
        		},
				select: function(grid, record, index, eOpts ){					
					UniAppManager.app.fnSumAmountIrefer();
	          	},
				deselect: function(grid, record, index, eOpts ){		
					UniAppManager.app.fnSumAmountIrefer();
        		}
        	}*/
        }),
			uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			onLoadSelectFirst : false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        columns: [  
		//	{ dataIndex: 'GUBUN'		     	    ,  width: 33},
			{ dataIndex: 'INSTOCK_DATE'    	    	,  width: 80},
			{ dataIndex: 'ITEM_ACCOUNT'    	    	,  width: 66,hidden:true},
			{ dataIndex: 'ITEM_CODE'	     	    ,  width: 126},
			{ dataIndex: 'ITEM_NAME'	     	    ,  width: 300},
			{ dataIndex: 'SPEC'		     	    	,  width: 88},
			{ dataIndex: 'ORDER_UNIT'	     	    ,  width: 88,align:'center'},
			{ dataIndex: 'TAX_TYPE'	     	    	,  width: 53,align:'center', align: 'center', hidden:false},
			{ dataIndex: 'ORDER_UNIT_P'    	    	,  width: 106},
			
			{ dataIndex: 'INOUT_Q'    	      	    ,  width: 100},
			{ dataIndex: 'INOUT_I'    	      	    ,  width: 100},
			{ dataIndex: 'INOUT_TAX_AMT'        	,  width: 100},
			{ dataIndex: 'TOTAL_INOUT_I'        	,  width: 100},
			
			{ dataIndex: 'ORDER_UNIT_Q'    	    	,  width: 100},
			
			{ dataIndex: 'AMOUNT_P'        	    	,  width: 100,hidden:true},
//			{ dataIndex: 'INOUT_TAX_AMT'   			,  width: 100 },
			{ dataIndex: 'AMOUNT_I'        	    	,  width: 120},
			{ dataIndex: 'ORDER_UNIT_FOR_P'	    	,  width: 100,hidden:true},
			{ dataIndex: 'FOREIGN_P'	     	    ,  width: 100,hidden:true},
			{ dataIndex: 'FOR_AMOUNT_O'    	    	,  width: 118},
			{ dataIndex: 'ORDER_UNIT_FOR_P'     	,  width: 100},
			{ dataIndex: 'REMAIN_Q'        	    	,  width: 100},
			{ dataIndex: 'ADVAN_AMOUNT'	 	    	,  width: 100},
			{ dataIndex: 'REMAIN_AMOUNT'   	    	,  width: 118},
			{ dataIndex: 'MONEY_UNIT'	     	    ,  width: 53,align:'center'},
			{ dataIndex: 'EXCHG_RATE_O'    	    	,  width: 80},
			{ dataIndex: 'TRNS_RATE'	     	    ,  width: 86},
			{ dataIndex: 'STOCK_UNIT'	     	    ,  width: 100,align:'center'},
			{ dataIndex: 'BUY_Q'	         	    ,  width: 100},
			{ dataIndex: 'ORDER_TYPE'	     	    ,  width: 66,hidden:true},
			{ dataIndex: 'ORDER_PRSN'	     	    ,  width: 66,hidden:true},
			{ dataIndex: 'ORDER_SEQ'	     	    ,  width: 66,hidden:true},
			{ dataIndex: 'LC_NUM'		     	    ,  width: 100,hidden:true},
			{ dataIndex: 'BL_NUM'		     	    ,  width: 100,hidden:true},
			{ dataIndex: 'ORDER_NUM'		 	    ,  width: 100},
			{ dataIndex: 'INOUT_NUM'	     	    ,  width: 130},
			{ dataIndex: 'INOUT_SEQ'	     	    ,  width: 33},
			{ dataIndex: 'TAX_CALC_TYPE'	 	    ,  width: 100,align:'center',hidden:false},
			{ dataIndex: 'REMARK'	         	    ,  width: 133},
			{ dataIndex: 'PROJECT_NO'      	    	,  width: 133},
			{ dataIndex: 'PURCHASE_TYPE'	        ,  width: 133, hidden: true },
			{ dataIndex: 'INOUT_TYPE'      	    	,  width: 133, hidden: true }
          ],
        listeners: {	
	  		onGridDblClick: function(grid, record, cellIndex, colName) {
				
			}
       	},
       	returnData: function()	{
			var taxType; 
       		
       		if(directMasterStore1.getCount() > 0 ){			
       			taxType = directMasterStore1.getAt(0).get('TAX_TYPE');
       		}
       			    		
       		var records = this.sortedSelectedRecords(this);
       		
			Ext.each(records, function(record,i){
				
				if(!Ext.isDefined(taxType) || record.get('TAX_TYPE') == taxType ){
		        	UniAppManager.app.onNewDataButtonDown();
		        	masterGrid.setReceiveData(record.data);	
		        	//directMasterStore1.fnSumAmountI(record);
			    }else{
			    	alert('과세/면세 품목을 동시에 선택 할 수 없습니다.');
			    	receivehistorySearch.setValue('TAX_TYPE', '');
			    }
			}); 
			this.getStore().remove(records);
       	}
    });
    var returninghistoryGrid = Unilite.createGrid('map110ukrvreturninghistoryGrid', {//반품내역참조
        // title: '기본',
        layout: 'fit',
        excelTitle: '개별 매입지급결의 등록(반품내역참조)',
    	store: returningHistoryStore,
    	selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: false
        	/*listeners: { 
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			UniAppManager.app.fnSumAmountIrefer3();
        		},
				select: function(grid, record, index, eOpts ){					
					UniAppManager.app.fnSumAmountIrefer3();
	          	},
				deselect: function(grid, record, index, eOpts ){		
					UniAppManager.app.fnSumAmountIrefer3();
        		}
        	}*/
        }),
			uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
    		onLoadSelectFirst : false,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        columns: [  
		//	{ dataIndex: 'GUBUN'		     	    ,  width: 33},
			{ dataIndex: 'INSTOCK_DATE'    	    	,  width: 80},
			{ dataIndex: 'ITEM_ACCOUNT'    	    	,  width: 66,hidden:true},
			{ dataIndex: 'ITEM_CODE'	     	    ,  width: 126},
			{ dataIndex: 'ITEM_NAME'	     	    ,  width: 300},
			{ dataIndex: 'SPEC'		     	    	,  width: 88,hidden:true},
			{ dataIndex: 'ORDER_UNIT'	     	    ,  width: 88,hidden:true},
			{ dataIndex: 'TAX_TYPE'	     	    	,  width: 53,hidden:true},
			
			{ dataIndex: 'ORDER_UNIT_FOR_P'     	,  width: 100},
			{ dataIndex: 'INOUT_Q'    	      	    ,  width: 100},
			{ dataIndex: 'INOUT_I'    	      	    ,  width: 100},
			{ dataIndex: 'INOUT_TAX_AMT'        	,  width: 100},
			{ dataIndex: 'TOTAL_INOUT_I'        	,  width: 100},
			
			{ dataIndex: 'CONDITION'		 ,		width:66},
            { dataIndex: 'TYPE'			  	 ,		width:66},
            { dataIndex: 'GOOD_STOCK_Q'      , 		width:66},
			
			{ dataIndex: 'ORDER_UNIT_Q'    	    	,  width: 100},
			{ dataIndex: 'ORDER_UNIT_P'    	    	,  width: 106},
			{ dataIndex: 'AMOUNT_P'        	    	,  width: 100,hidden:true},
			{ dataIndex: 'AMOUNT_I'        	    	,  width: 120},
			{ dataIndex: 'ORDER_UNIT_FOR_P'	    	,  width: 100,hidden:true},
			{ dataIndex: 'FOREIGN_P'	     	    ,  width: 100,hidden:true},
			{ dataIndex: 'FOR_AMOUNT_O'    	    	,  width: 118,hidden:true},
			{ dataIndex: 'REMAIN_Q'        	    	,  width: 100,hidden:true},
			{ dataIndex: 'ADVAN_AMOUNT'	 	    	,  width: 100,hidden:true},
			{ dataIndex: 'REMAIN_AMOUNT'   	    	,  width: 118,hidden:true},
			{ dataIndex: 'MONEY_UNIT'	     	    ,  width: 53,hidden:true},
			{ dataIndex: 'EXCHG_RATE_O'    	    	,  width: 80,hidden:true},
			{ dataIndex: 'TRNS_RATE'	     	    ,  width: 86,hidden:true},
			{ dataIndex: 'STOCK_UNIT'	     	    ,  width: 100,hidden:true},
			{ dataIndex: 'BUY_Q'	         	    ,  width: 100,hidden:true},
			{ dataIndex: 'ORDER_TYPE'	     	    ,  width: 66,hidden:true},
			{ dataIndex: 'ORDER_PRSN'	     	    ,  width: 66,hidden:true},
			{ dataIndex: 'ORDER_SEQ'	     	    ,  width: 66,hidden:true},
			{ dataIndex: 'LC_NUM'		     	    ,  width: 100,hidden:true},
			{ dataIndex: 'BL_NUM'		     	    ,  width: 100,hidden:true},
			{ dataIndex: 'ORDER_NUM'		 	    ,  width: 100,hidden:true},
			{ dataIndex: 'INOUT_NUM'	     	    ,  width: 130,hidden:false},
			{ dataIndex: 'INOUT_SEQ'	     	    ,  width: 33,hidden:true},
			{ dataIndex: 'TAX_CALC_TYPE'	 	    ,  width: 100, align:'center',hidden:false},
			{ dataIndex: 'REMARK'	         	    ,  width: 133},
			{ dataIndex: 'PROJECT_NO'      	    	,  width: 133,hidden:true},
			{ dataIndex: 'PURCHASE_TYPE'	        ,  width: 133, hidden: true },
			{ dataIndex: 'INOUT_TYPE'      	    	,  width: 133, hidden: true }
          ],
        listeners: {	
	  		onGridDblClick: function(grid, record, cellIndex, colName) {
				
			}
       	},
       	returnData: function()	{
			var taxType; 
       		
       		if(directMasterStore1.getCount() > 0 ){			
       			taxType = directMasterStore1.getAt(0).get('TAX_TYPE');
       		}
       			    		
       		var records = this.sortedSelectedRecords(this);
       		
			Ext.each(records, function(record,i){
				
				if(!Ext.isDefined(taxType) || record.get('TAX_TYPE') == taxType ){
		        	UniAppManager.app.onNewDataButtonDown();
		        	masterGrid.setReturningData(record.data);	
		        	//directMasterStore1.fnSumAmountI(record);
			    }else{
			    	alert('과세/면세 품목을 동시에 선택 할 수 없습니다.');
			    	returninghistorySearch.setValue('TAX_TYPE', '');
			    }
			}); 
			this.getStore().remove(records);
       	}
    });
    var orderhistoryGrid = Unilite.createGrid('map110ukrvorderhistoryGrid', {//발주내역참조(선지급)
        // title: '기본',
        layout: 'fit',
        excelTitle: '개별 매입지급결의 등록(발주내역참조(선지급))',
    	store: orderHistoryStore,
    	selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: false,
        	listeners: { 
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			UniAppManager.app.fnSumAmountIrefer2();
        		},
				select: function(grid, record, index, eOpts ){					
					UniAppManager.app.fnSumAmountIrefer2();
	          	},
				deselect: function(grid, record, index, eOpts ){		
					UniAppManager.app.fnSumAmountIrefer2();
        		}
        	}
        }),
        uniOpt:{
            onLoadSelectFirst : false
        },
        columns: [  
		//	{ dataIndex: 'GUBUN'           	,  width: 33},
			{ dataIndex: 'ORDER_DATE'      	,  width: 80},
			{ dataIndex: 'ITEM_CODE'       	,  width: 100},
			{ dataIndex: 'ITEM_NAME'       	,  width: 300},
			{ dataIndex: 'SPEC'            	,  width: 88},
			{ dataIndex: 'ORDER_UNIT'      	,  width: 88},
			{ dataIndex: 'ORDER_UNIT_Q'    	,  width: 93},
			{ dataIndex: 'ORDER_UNIT_P'    	,  width: 93},
			{ dataIndex: 'ORDER_O'         	,  width: 93},
			{ dataIndex: 'ADVAN_AMOUNT'    	,  width: 93},
			{ dataIndex: 'LOG_AMT'         	,  width: 93},
			{ dataIndex: 'REMAIN_Q'        	,  width: 93,hidden:true},
			{ dataIndex: 'MONEY_UNIT'      	,  width: 53, align: 'center'},
			{ dataIndex: 'EXCHG_RATE_O'    	,  width: 66},
			{ dataIndex: 'STOCK_UNIT'      	,  width: 53},
			{ dataIndex: 'TRNS_RATE'       	,  width: 66},
			{ dataIndex: 'LC_NUM'          	,  width: 93},
			{ dataIndex: 'ORDER_NUM'       	,  width: 93},
			{ dataIndex: 'ORDER_SEQ'       	,  width: 66},
			{ dataIndex: 'REMARK'          	,  width: 93},
			{ dataIndex: 'PROJECT_NO'      	,  width: 93},
			{ dataIndex: 'ITEM_ACCOUNT'    	,  width: 53,hidden:true},
			{ dataIndex: 'ORDER_TYPE'      	,  width: 53,hidden:true},
			{ dataIndex: 'ORDER_PRSN'      	,  width: 53,hidden:true}
		],
		listeners: {	
      		onGridDblClick:function(grid, record, cellIndex, colName) {
				
			}
   		},
   		returnData: function()	{
//       		var records = this.getSelectedRecords();
   			var records = this.sortedSelectedRecords(this);
			Ext.each(records, function(record,i){	
	        	UniAppManager.app.onNewDataButtonDown();
	        	masterGrid.setOrderData(record.data);
	     //   	directMasterStore1.fnSumAmountI(e.store.data.items);
		    }); 
			this.getStore().remove(records);
       	}
    });
    function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '매입전표번호검색',
                width: 830,				                
                height: 700,
                layout: {type:'vbox', align:'stretch'},	                
                items: [buyslipNoSearch, buyslipNoMasterGrid],
                tbar: ['->',
			        {	
			        	itemId: 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							buyslipNoMasterStore.loadStoreRecords();
						},
						disabled: false
					}, {
						itemId: 'OrderNoCloseBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
			    ],
				listeners: {
					beforehide: function(me, eOpt)	{
						buyslipNoSearch.clearForm();
						buyslipNoMasterGrid.reset();
						//buyslipNoDetailGrid.reset();	                							
					},
        			beforeclose: function( panel, eOpts )	{
						buyslipNoSearch.clearForm();
						buyslipNoMasterGrid.reset();
						//buyslipNoDetailGrid.reset();
		 			},
        			show: function( panel, eOpts )	{
        			 	buyslipNoSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
			    		buyslipNoSearch.setValue('CUSTOM_CODE',masterForm.getValue('CUSTOM_CODE'));
			    		buyslipNoSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
			    		buyslipNoSearch.setValue('DEPT_CODE',masterForm.getValue('DEPT_CODE'));
			    		buyslipNoSearch.setValue('DEPT_NAME',masterForm.getValue('DEPT_NAME'));
			    		buyslipNoSearch.setValue('BILL_NUM',masterForm.getValue('BILL_NUM'));

			    		buyslipNoSearch.setValue('CHANGE_BASIS_DATE_FR', UniDate.get('startOfMonth', masterForm.getValue('CHANGE_BASIS_DATE')));
			    		buyslipNoSearch.setValue('CHANGE_BASIS_DATE_TO',masterForm.getValue('CHANGE_BASIS_DATE'));
						buyslipNoSearch.setValue('BILL_DATE_FR', UniDate.get('startOfMonth', masterForm.getValue('BILL_DATE')));
			    		buyslipNoSearch.setValue('BILL_DATE_TO',masterForm.getValue('BILL_DATE'));
			    		
			    		/***/
			    		/*if(masterForm.getValue('BILL_TYPE') == '62'){ 로직제거
			    			buyslipNoSearch.setValue('CREDIT_NUMBER',masterForm.getValue('CREDIT_NUMBER'));
			    		}
			    		else if(masterForm.getValue('BILL_TYPE') == '53'){
			    			buyslipNoSearch.setValue('CRDT_NUM',masterForm.getValue('CRDT_NUM'));
			    			buyslipNoSearch.setValue('CRDT_NAME',masterForm.getValue('CRDT_NAME'));
			    		}*/
        			}
                }		
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
		
    }
    
    function openReceiveHistoryWindow() {    		//입고내역참조
//  		if(!UniAppManager.app.checkForNewDetail()) return false;
//  	
//  		receivehistorySearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));	
//  		receivehistorySearch.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
//  		receivehistorySearch.setValue('FR_ESTI_DATE', UniDate.get('startOfMonth', masterForm.getValue('ORDER_DATE')) );
//  		receivehistorySearch.setValue('TO_ESTI_DATE', masterForm.getValue('ORDER_DATE'));
//  		receivehistorySearch.setValue('DIV_CODE', masterForm.getValue('DIV_CODE'));      		
//  		receiveHistoryStore.loadStoreRecords(); 
//  		*/
    	receivehistorySearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
		receivehistorySearch.setValue('MONEY_UNIT', masterForm.getValue('MONEY_UNIT'));	
		if(!referReceiveHistoryWindow) {
			referReceiveHistoryWindow = Ext.create('widget.uniDetailWindow', {
                title: '입고내역참조',
                width: 1300,				                
                height: 340,
                layout: {type:'vbox', align:'stretch'},
                
                items: [receivehistorySearch, receivehistoryGrid],
                tbar:  ['->',
					{	
				        itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							if(receivehistorySearch.setAllFieldsReadOnly(true) == false){
								return false;
							}
							receiveHistoryStore.loadStoreRecords();
							if(masterForm.getValue('BILL_TYPE') == '53' || masterForm.getValue('BILL_TYPE') == '62'){
								receivehistorySearch.getField('TAX_TYPE').setReadOnly(false);
							}
						},
						disabled: false
					},{	
						itemId: 'confirmBtn',
						text: '매입적용',
						handler: function() {
							receivehistoryGrid.returnData();
						},
						disabled: false
					},
					{	
						itemId: 'confirmCloseBtn',
						text: '매입적용 후 닫기',
						handler: function() {
							receivehistoryGrid.returnData();
							receivehistoryGrid.reset();
							receivehistorySearch.clearForm();
							referReceiveHistoryWindow.hide();
						},
						disabled: false
					},{
						itemId: 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							referReceiveHistoryWindow.hide();
							receivehistoryGrid.reset();
							receivehistorySearch.clearForm();
						},
						disabled: false
					}
			    ],
                listeners: {
                	beforehide: function(me, eOpt)	{
						//receivehistorySearch.clearForm();
						//receivehistoryGrid,reset();
					},
        			beforeclose: function( panel, eOpts )	{
						//receivehistorySearch.clearForm();
						//receivehistoryGrid,reset();
		 			},
        			beforeshow: function ( me, eOpts )	{
        				receivehistorySearch.setValue('INOUT_DATE_FR',UniDate.get('startOfMonth'));
        				receivehistorySearch.setValue('INOUT_DATE_TO',UniDate.get('today'));
        				receivehistorySearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
        				receivehistorySearch.setValue('ORDER_TYPE',masterForm.getValue('ORDER_TYPE'));
   ////
        				if(masterForm.getValue('BILL_TYPE') == '51'){
        					receivehistorySearch.setValue('TAX_TYPE','1');
        				}else if(masterForm.getValue('BILL_TYPE') == '57'){
        					receivehistorySearch.setValue('TAX_TYPE','2');
        				}else if(masterForm.getValue('BILL_TYPE') == '53'){
        				}
        				
        			 	//receiveHistoryStore.loadStoreRecords();
        			}
                }
			})
		}
		referReceiveHistoryWindow.center();
		referReceiveHistoryWindow.show();
    }
    
    function openReturningHistoryWindow() {    		//반품내역참조
//  		if(!UniAppManager.app.checkForNewDetail()) return false;
//  	
//  		receivehistorySearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));	
//  		receivehistorySearch.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
//  		receivehistorySearch.setValue('FR_ESTI_DATE', UniDate.get('startOfMonth', masterForm.getValue('ORDER_DATE')) );
//  		receivehistorySearch.setValue('TO_ESTI_DATE', masterForm.getValue('ORDER_DATE'));
//  		receivehistorySearch.setValue('DIV_CODE', masterForm.getValue('DIV_CODE'));      		
//  		receiveHistoryStore.loadStoreRecords(); 
//  		*/
    	returninghistorySearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
		returninghistorySearch.setValue('MONEY_UNIT', masterForm.getValue('MONEY_UNIT'));	
		if(!referReturningHistoryWindow) {
			referReturningHistoryWindow = Ext.create('widget.uniDetailWindow', {
                title: '반품내역참조',
                width: 1300,				                
                height: 340,
                layout: {type:'vbox', align:'stretch'},
                
                items: [returninghistorySearch, returninghistoryGrid],
                tbar:  ['->',
					{	
				        itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							if(returninghistorySearch.setAllFieldsReadOnly(true) == false){
								return false;
							}					
							returningHistoryStore.loadStoreRecords();
							if(masterForm.getValue('BILL_TYPE') == '53' || masterForm.getValue('BILL_TYPE') == '62'){
								returninghistorySearch.getField('TAX_TYPE').setReadOnly(false);
							}
						},
						disabled: false
					},{	
						itemId: 'confirmBtn',
						text: '반품적용',
						handler: function() {
							returninghistoryGrid.returnData();
						},
						disabled: false
					},
					{	
						itemId: 'confirmCloseBtn',
						text: '반품적용 후 닫기',
						handler: function() {
							returninghistoryGrid.returnData();
							returninghistoryGrid.reset();
							returninghistorySearch.clearForm();
							referReturningHistoryWindow.hide();
						},
						disabled: false
					},{
						itemId: 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							referReturningHistoryWindow.hide();
							returninghistoryGrid.reset();
							returninghistorySearch.clearForm();
						},
						disabled: false
					}
			    ],
                listeners: {
                	beforehide: function(me, eOpt)	{
						//receivehistorySearch.clearForm();
						//receivehistoryGrid,reset();
					},
        			beforeclose: function( panel, eOpts )	{
						//receivehistorySearch.clearForm();
						//receivehistoryGrid,reset();
		 			},
        			beforeshow: function ( me, eOpts )	{
        				returninghistorySearch.setValue('INOUT_DATE_FR',UniDate.get('startOfMonth'));
        				returninghistorySearch.setValue('INOUT_DATE_TO',UniDate.get('today'));
        				returninghistorySearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
        				returninghistorySearch.setValue('ORDER_TYPE',masterForm.getValue('ORDER_TYPE'));
      ////  				
        				if(masterForm.getValue('BILL_TYPE') == '51'){
        					returninghistorySearch.setValue('TAX_TYPE','1');
        				}else if(masterForm.getValue('BILL_TYPE') == '57'){
        					returninghistorySearch.setValue('TAX_TYPE','2');
        				}
        			 	//receiveHistoryStore.loadStoreRecords();
        			}
                }
			})
		}
		referReturningHistoryWindow.center();
		referReturningHistoryWindow.show();
    }
    
     function openOrderHistoryWindow() {    		//발주내역참조(선지급)
		orderhistorySearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));	
		orderhistorySearch.setValue('MONEY_UNIT', masterForm.getValue('MONEY_UNIT'));	
		if(!referOrderHistoryWindow) {
			referOrderHistoryWindow = Ext.create('widget.uniDetailWindow', {
                title: '발주내역참조(선지급)',
                width: 830,				                
                height: 580,
                layout: {type: 'vbox', align: 'stretch'},
                
                items: [orderhistorySearch, orderhistoryGrid],
                tbar: ['->',
			        {	
			        	itemId: 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							orderHistoryStore.loadStoreRecords();
						},
						disabled: false
					},{	
						itemId: 'confirmBtn',
						text: '매입적용',
						handler: function() {
							orderhistoryGrid.returnData();
						},
						disabled: false
					},
					{	
						itemId: 'confirmCloseBtn',
						text: '매입적용 후 닫기',
						handler: function() {
							orderhistoryGrid.returnData();
							referOrderHistoryWindow.hide();
						},
						disabled: false
					},{
						itemId: 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							referOrderHistoryWindow.hide();
						},
						disabled: false
					}
			    ],
                listeners: {
                	beforehide: function(me, eOpt)	{
						//receivehistorySearch.clearForm();
						//receivehistoryGrid,reset();
					},
        			beforeclose: function( panel, eOpts )	{
						//receivehistorySearch.clearForm();
						//receivehistoryGrid,reset();
		 			},
        			beforeshow: function ( me, eOpts )	{
        			 	//receiveHistoryStore.loadStoreRecords();
        			}
                }
			})
		}
		referOrderHistoryWindow.center();
		referOrderHistoryWindow.show();
    }
	
	Unilite.Main( {
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
		id: 'map110ukrvApp',
		fnInitBinding: function(){
//			masterForm.setValue('DEPT_CODE',UserInfo.deptCode);
//			masterForm.setValue('DEPT_NAME',UserInfo.deptName);
//			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			var param = {"DIV_CODE": masterForm.getValue('DIV_CODE')};
				map110ukrvService.billDivCode(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						masterForm.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
						panelResult.setValue('BILL_DIV_CODE', provider['BILL_DIV_CODE']);
					}
				});
			this.setDefault();	
		},
		setDefault: function() {
//			gsStatusM = 'N'
//			gsAgreeYN = 'N'
//			Call fnFirstCombo(ComRs, 0, txtOrderType)
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('BILL_DIV_CODE',UserInfo.divCode);
			masterForm.setValue('ORDER_TYPE','1');
			masterForm.setValue('ACCOUNT_TYPE','20');
			masterForm.setValue('BILL_TYPE','53');
			Ext.getCmp('MAP100_CUSTOM_CODE_SE').setVisible(true);
			Ext.getCmp('MAP100_CREDIT_NUM_SE').setVisible(false);
        	masterForm.setValue('BILL_DATE', UniDate.get('endOfMonth'));
        	masterForm.setValue('CHANGE_BASIS_DATE', UniDate.get('today'));
			
			masterForm.setValue('EX_NUM',0);
        	masterForm.setValue('AMOUNTTOT',0);
        	masterForm.setValue('AMOUNTI',0);
        	masterForm.setValue('VAT_RATE',10);
        	masterForm.setValue('VATAMOUNTO',0);
        	masterForm.setValue('DRAFT_YN','N');
        	
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('BILL_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ORDER_TYPE','1');
			panelResult.setValue('ACCOUNT_TYPE','20');
			panelResult.setValue('BILL_TYPE','53');
			Ext.getCmp('MAP100_CUSTOM_CODE_RE').setVisible(true);
			Ext.getCmp('MAP100_CREDIT_NUM_RE').setVisible(false);
        	panelResult.setValue('BILL_DATE', UniDate.get('endOfMonth'));
        	panelResult.setValue('CHANGE_BASIS_DATE', UniDate.get('today'));
        
        	receivehistorySearch.getField('TAX_TYPE').setReadOnly(false);
        	returninghistorySearch.getField('TAX_TYPE').setReadOnly(false);
        	
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
			
//			btn= Ext.getCmp('orderhistoryBtn');
//			if(BsaCodeInfo.gsAdvanUseYn != 'Y'){
//				btn.hide();
//			}
						//btn= Ext.get('orderhistoryBtn'); 
	//					btn.setVisivle(false);
		},
		onQueryButtonDown: function(){
			masterForm.setAllFieldsReadOnly(false);
			var cbNo = masterForm.getValue('CHANGE_BASIS_NUM');
			if(Ext.isEmpty(cbNo)) {
				openSearchInfoWindow() 
			} else {
				var param= masterForm.getValues();
				masterForm.uniOpt.inLoading=true;
				masterForm.getForm().load({
					params: param,
					success: function()	{
						masterForm.setAllFieldsReadOnly(true)
//						if(BsaCodeInfo.gsDraftFlag == 'Y' && masterForm.getValue('STATUS') != '1') 	{
//							checkDraftStatus = true;							
//						}
						masterForm.uniOpt.inLoading=false;
					},
					failure: function(form, action) {
                        masterForm.uniOpt.inLoading=false;
                    }
				})
				directMasterStore1.loadStoreRecords();	
			}
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
		onNewDataButtonDown: function()	{
	//		if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				 var cbNo = masterForm.getValue('CHANGE_BASIS_NUM');
				 var seq = directMasterStore1.max('CHANGE_BASIS_SEQ');
            	 if(!seq) seq = 1;
            	 else  seq += 1;
            	 var r = {
					CHANGE_BASIS_NUM: cbNo,
					CHANGE_BASIS_SEQ: seq
		        };
				masterGrid.createRow(r);
				masterForm.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			},		
		
		onResetButtonDown: function() {
			masterForm.clearForm();
			panelResult.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
	/*	confirmSaveData: function(config)	{
			if(directMasterStore1.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},*/
		
		onSaveDataButtonDown: function(config) {				
			directMasterStore1.saveStore();
		},
		fnSumAmountIrefer: function(){
			console.log("=============Exec fnSumAmountIrefer()");
			var dSumTax = 0;
			var dSumAmountI = 0;
			var dSumAmountTot = 0;
			
			receivehistorySearch.setValue('AMOUNTI','0');
			receivehistorySearch.setValue('VATAMOUNTO','0');
			receivehistorySearch.setValue('AMOUNTTOT','0');
			
			var dOrderUnitQ = 0;
			var dOrderUnitP = 0;
			var dCalAmoutI = 0;
			
			var dAmountI = 0;
			var dTax = 0;
			var dVatRate = 0;
			var dCalAmountI = 0;
			
////		조회시 값받아오질 못함	alert(CustomCodeInfo.gsUnderCalBase);
////						alert(CustomCodeInfo.gsTaxInclude);
////							alert(CustomCodeInfo.gsTaxCalcType);
		//	alert(CustomCodeInfo.gsTaxInclude);
			var records = receivehistoryGrid.getSelectedRecords();
			Ext.each(records,  function(record, index, records){
			if(masterForm.getValue('VAT_RATE') == ''){
				dVatRate = 0;
			}else{
				dVatRate = masterForm.getValue('VAT_RATE');
			}
			
			dOrderUnitQ = record.get('ORDER_UNIT_Q');
			dOrderUnitP = record.get('ORDER_UNIT_P');
			dCalAmoutI = record.get('AMOUNT_I');
			
			dAmountI = dCalAmountI;
			
			if(dAmountI == '0'){
				dAmountI = record.get('FOR_AMOUNT_O') * record.get('EXCHG_RATE_O');
			}
//			if(records == ''){
//				if(dCalAmoutI == (dOrderUnitQ * dOrderUnitP)){
//					dAmountI = dCalAmoutI;
//				}else{
//					dAmountI = dOrderUnitQ * dOrderUnitP;
//				}
//			}else{
//				dAmountI = dCalAmoutI;
//			}
			if(CustomCodeInfo.gsTaxInclude == '1'){
				dAmountI = Math.round(dAmountI,CustomCodeInfo.gsUnderCalBase);
				dTax = dAmountI * (dVatRate / 100);
				dSumAmountI = dSumAmountI + dAmountI;
				dTax = Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
				
			}else{
				dTemp = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '2');	//UniMatrl	??
				dTax =	dAmountI - dTemp;	
				dTax = Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
				dTemp = dAmountI - dTax;
				dTemp = Math.round(dTemp,CustomCodeInfo.gsUnderCalBase);
				dSumAmountTot = dSumAmountTot + dAmountI;
			}
			dSumTax = dSumTax + dTax;
			
			dSumAmountI = Math.round(dSumAmountI,CustomCodeInfo.gsUnderCalBase);
			dSumAmountTot = Math.round(dSumAmountTot,CustomCodeInfo.gsUnderCalBase);
			dSumTax = Math.round(dSumTax,CustomCodeInfo.gsUnderCalBase);
			
			if(CustomCodeInfo.gsTaxInclude == '1'){
				receivehistorySearch.setValue('AMOUNTI',dSumAmountI);
				receivehistorySearch.setValue('AMOUNTTOT',dSumAmountI);
			}else{
				receivehistorySearch.setValue('AMOUNTTOT',dSumAmountTot);
			}
			
			if(CustomCodeInfo.gsTaxCalcType == '1'){
				if(CustomCodeInfo.gsTaxInclude == '1'){
					dTax = receivehistorySearch.getValue('AMOUNTI') * (dVatRate / 100);
					dTax = Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
				}else{
					dTemp = receivehistorySearch.getValue('AMOUNTTOT') / ( dVatRate + 100 ) * 100;
					dTax  =	receivehistorySearch.getValue('AMOUNTTOT')	- dTemp;
					dTax = Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
					receivehistorySearch.setValue('AMOUNTI',receivehistorySearch.getValue('AMOUNTTOT') - dTax);
				}
				receivehistorySearch.setValue('VATAMOUNTO',dTax);
			}else{
				receivehistorySearch.setValue('VATAMOUNTO',dSumTax);
				if(CustomCodeInfo.gsTaxInclude != '1'){
					receivehistorySearch.setValue('AMOUNTI',receivehistorySearch.getValue('AMOUNTTOT') - dSumTax);
				}
			}
			receivehistorySearch.setValue('AMOUNTTOT',receivehistorySearch.getValue('VATAMOUNTO') + receivehistorySearch.getValue('AMOUNTI'));
						})
		},
	/*	fnSumAmountIrefer3: function(){
			console.log("=============Exec fnSumAmountIrefer3()");
			var dSumTax = 0;
			var dSumAmountI = 0;
			var dSumAmountTot = 0;
			
			returninghistorySearch.setValue('AMOUNTI','0');
			returninghistorySearch.setValue('VATAMOUNTO','0');
			returninghistorySearch.setValue('AMOUNTTOT','0');
			
			var dOrderUnitQ = 0;
			var dOrderUnitP = 0;
			var dCalAmoutI = 0;
			
			var dAmountI = 0;
			var dTax = 0;
			var dVatRate = 0;
			var dCalAmountI = 0;
			
////		조회시 값받아오질 못함	alert(CustomCodeInfo.gsUnderCalBase);
////						alert(CustomCodeInfo.gsTaxInclude);
////							alert(CustomCodeInfo.gsTaxCalcType);
		//	alert(CustomCodeInfo.gsTaxInclude);
			var records = returninghistoryGrid.getSelectedRecords();
			Ext.each(records,  function(record, index, records){
			if(masterForm.getValue('VAT_RATE') == ''){
				dVatRate = 0;
			}else{
				dVatRate = masterForm.getValue('VAT_RATE');
			}
			
			dOrderUnitQ = record.get('ORDER_UNIT_Q');
			dOrderUnitP = record.get('ORDER_UNIT_P');
			dCalAmoutI = record.get('AMOUNT_I');
			
			dAmountI = dCalAmountI;
			
			if(dAmountI == '0'){
				dAmountI = record.get('FOR_AMOUNT_O') * record.get('EXCHG_RATE_O');
			}
//			if(records == ''){
//				if(dCalAmoutI == (dOrderUnitQ * dOrderUnitP)){
//					dAmountI = dCalAmoutI;
//				}else{
//					dAmountI = dOrderUnitQ * dOrderUnitP;
//				}
//			}else{
//				dAmountI = dCalAmoutI;
//			}
			if(CustomCodeInfo.gsTaxInclude == '1'){
				dAmountI = Math.round(dAmountI,CustomCodeInfo.gsUnderCalBase);
				dTax = dAmountI * (dVatRate / 100);
				dSumAmountI = dSumAmountI + dAmountI;
				dTax = Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
				
			}else{
				dTemp = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '2');	//UniMatrl	??
				dTax =	dAmountI - dTemp;	
				dTax = Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
				dTemp = dAmountI - dTax;
				dTemp = Math.round(dTemp,CustomCodeInfo.gsUnderCalBase);
				dSumAmountTot = dSumAmountTot + dAmountI;
			}
			dSumTax = dSumTax + dTax;
			
			dSumAmountI = Math.round(dSumAmountI,CustomCodeInfo.gsUnderCalBase);
			dSumAmountTot = Math.round(dSumAmountTot,CustomCodeInfo.gsUnderCalBase);
			dSumTax = Math.round(dSumTax,CustomCodeInfo.gsUnderCalBase);
			
			if(CustomCodeInfo.gsTaxInclude == '1'){
				returninghistorySearch.setValue('AMOUNTI',dSumAmountI);
				returninghistorySearch.setValue('AMOUNTTOT',dSumAmountI);
			}else{
				returninghistorySearch.setValue('AMOUNTTOT',dSumAmountTot);
			}
			
			if(CustomCodeInfo.gsTaxCalcType == '1'){
				if(CustomCodeInfo.gsTaxInclude == '1'){
					dTax = returninghistorySearch.getValue('AMOUNTI') * (dVatRate / 100);
					dTax = Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
				}else{
					dTemp = returninghistorySearch.getValue('AMOUNTTOT') / ( dVatRate + 100 ) * 100;
					dTax  =	returninghistorySearch.getValue('AMOUNTTOT')	- dTemp;
					dTax = Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
					returninghistorySearch.setValue('AMOUNTI',returninghistorySearch.getValue('AMOUNTTOT') - dTax);
				}
				returninghistorySearch.setValue('VATAMOUNTO',dTax);
			}else{
				returninghistorySearch.setValue('VATAMOUNTO',dSumTax);
				if(CustomCodeInfo.gsTaxInclude != '1'){
					returninghistorySearch.setValue('AMOUNTI',returninghistorySearch.getValue('AMOUNTTOT') - dSumTax);
				}
			}
			returninghistorySearch.setValue('AMOUNTTOT',returninghistorySearch.getValue('VATAMOUNTO') + returninghistorySearch.getValue('AMOUNTI'));
						})
		},*/
		
	/*	fnSumAmountIrefer2: function(){
			console.log("=============Exec fnSumAmountIrefer()");
			
			var dSumTax = 0;
			var dSumAmountI = 0;
			var dSumAmountTot = 0;
			
			orderhistorySearch.setValue('AMOUNTI','0');
			orderhistorySearch.setValue('VATAMOUNTO','0');
			orderhistorySearch.setValue('AMOUNTTOT','0');
			
			var dOrderUnitQ = 0;
			var dOrderUnitP = 0;
			var dCalAmoutI = 0;
			
			var dAmountI = 0;
			var dTax = 0;
			var dVatRate = 0;
			var dCalAmountI = 0;
			
////		조회시 값받아오질 못함	alert(CustomCodeInfo.gsUnderCalBase);
////						alert(CustomCodeInfo.gsTaxInclude);
////							alert(CustomCodeInfo.gsTaxCalcType);
		//	alert(CustomCodeInfo.gsTaxInclude);
			var records = orderhistoryGrid.getSelectedRecords();
			Ext.each(records,  function(record, index, records){
			
			if(masterForm.getValue('VAT_RATE') == ''){
				dVatRate = 0;
			}else{
				dVatRate = masterForm.getValue('VAT_RATE');
			}
			dAmountI = record.get('ORDER_O');
			
//			if(records == ''){
//				if(dCalAmoutI == (dOrderUnitQ * dOrderUnitP)){
//					dAmountI = dCalAmoutI;
//				}else{
//					dAmountI = dOrderUnitQ * dOrderUnitP;
//				}
//			}else{
//				dAmountI = dCalAmoutI;
//			}
			if(CustomCodeInfo.gsTaxInclude == '1'){
				dAmountI = Math.round(dAmountI,CustomCodeInfo.gsUnderCalBase);
				dTax = dAmountI * (dVatRate / 100);
				dSumAmountI = dSumAmountI + dAmountI;
				dTax = Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
				
			}else{
				dTemp = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '2');	//UniMatrl	??
				dTax  =	dAmountI - dTemp;	
				dTax = Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
				dTemp = dAmountI - dTax;
				dTemp = Math.round(dTemp,CustomCodeInfo.gsUnderCalBase);
				dSumAmountTot = dSumAmountTot + dAmountI;
			}
			dSumTax = dSumTax + dTax;
			
			dSumAmountI = Math.round(dSumAmountI,CustomCodeInfo.gsUnderCalBase);
			dSumAmountTot = Math.round(dSumAmountTot,CustomCodeInfo.gsUnderCalBase);
			dSumTax = Math.round(dSumTax,CustomCodeInfo.gsUnderCalBase);
			
			if(CustomCodeInfo.gsTaxInclude == '1'){
				orderhistorySearch.setValue('AMOUNTI',dSumAmountI);
				orderhistorySearch.setValue('AMOUNTTOT',dSumAmountI);
			}else{
				orderhistorySearch.setValue('AMOUNTTOT',dSumAmountTot);
			}
			
			if(CustomCodeInfo.gsTaxCalcType == '1'){
				if(CustomCodeInfo.gsTaxInclude == '1'){
					dTax = orderhistorySearch.getValue('AMOUNTI') * (dVatRate / 100);
					dTax = Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
				}else{
					dTemp = orderhistorySearch.getValue('AMOUNTTOT') / ( dVatRate + 100 ) * 100;
					dTax  =	orderhistorySearch.getValue('AMOUNTTOT')	- dTemp;
					dTax = Math.round(dTax,CustomCodeInfo.gsUnderCalBase);
					orderhistorySearch.setValue('AMOUNTI',orderhistorySearch.getValue('AMOUNTTOT') - dTax);
				}
				orderhistorySearch.setValue('VATAMOUNTO',dTax);
			}else{
				orderhistorySearch.setValue('VATAMOUNTO',dSumTax);
				if(CustomCodeInfo.gsTaxInclude != '1'){
					orderhistorySearch.setValue('AMOUNTI',orderhistorySearch.getValue('AMOUNTTOT') - dSumTax);
				}
			}
			orderhistorySearch.setValue('AMOUNTTOT',orderhistorySearch.getValue('VATAMOUNTO') + orderhistorySearch.getValue('AMOUNTI'));
						})
		},*/
/*		checkForNewDetail:function() { 
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('CHANGE_BASIS_NUM')))	{
				alert('<t:message code="unilite.msg.sMS533" default="수주번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}
			
			*//**
			 * 여신한도 확인
			 *//* 
			if(!masterForm.fnCreditCheck())	{
				return false;
			}
			
			*//**
			 * 마스터 데이타 수정 못 하도록 설정
			 *//*
			return masterForm.setAllFields(true);
        },*/
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				
				
				masterGrid.deleteSelectedRow();
				
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				
					masterGrid.deleteSelectedRow();
				
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
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},fnGetAccountType: function(subCode){	
        	var fRecord ='';
        	Ext.each(BsaCodeInfo.AccountType, function(item, i)	{
        		if(item['codeNo'] == subCode) {
        			fRecord = item['refCode2'];
        		}
        	});
        	masterForm.setValue('BILL_TYPE', fRecord);
        	panelResult.setValue('BILL_TYPE', fRecord);

        },
        
        fnGetBillType: function(subCode){	
        	var bRecord ='';
        	Ext.each(BsaCodeInfo.BillType, function(item, i)	{
        		if(item['codeNo'] == subCode) {
        			bRecord = item['refCode1'];
        		}
        	});
        	
        	var viewCustomCodeSE = Ext.getCmp('MAP100_CUSTOM_CODE_SE');
        	var viewCreditNumSE = Ext.getCmp('MAP100_CREDIT_NUM_SE');
        	
        	var viewCustomCodeRE = Ext.getCmp('MAP100_CUSTOM_CODE_RE');
        	var viewCreditNumRE = Ext.getCmp('MAP100_CREDIT_NUM_RE');
        	
        	
        	
 			
        	if(bRecord == 'E'){		
        		viewCustomCodeSE.setVisible(true);
        		viewCreditNumSE.setVisible(false);
        		
        		viewCustomCodeRE.setVisible(true);	
        		viewCreditNumRE.setVisible(false);
        		
        		
        		receivehistorySearch.getField('TAX_TYPE').setReadOnly(false);
        		returninghistorySearch.getField('TAX_TYPE').setReadOnly(false);
        		
        	}
        	else if(bRecord == 'F'){
        		
        		viewCustomCodeSE.setVisible(false);
        		viewCreditNumSE.setVisible(true);
        		
        		viewCustomCodeRE.setVisible(false);
        		viewCreditNumRE.setVisible(true);
        		
        		receivehistorySearch.getField('TAX_TYPE').setReadOnly(false);
        		returninghistorySearch.getField('TAX_TYPE').setReadOnly(false);

        	}
        	else {
        		viewCustomCodeSE.setVisible(false);
        		viewCreditNumSE.setVisible(false);   		
        		
        		viewCustomCodeRE.setVisible(false);
        		viewCreditNumRE.setVisible(false);
        		
        		receivehistorySearch.getField('TAX_TYPE').setReadOnly(true);
        		returninghistorySearch.getField('TAX_TYPE').setReadOnly(true);
        		
        	}
        }
		
		/*cbStockQ: function(provider, params)	{  
	    	var rtnRecord = params.rtnRecord;
			
			//var dStockQ = Unilite.nvl(provider['STOCK_Q'], 0);
			//var dOrderQ = Unilite.nvl(rtnRecord.get('ORDER_Q'), 0);
			//var lTrnsRate = rtnRecord.get('TRANS_RATE');
			
	    	var dGoodStockQ = provider['GOOD_STOCK_Q'];
	    	var dBadStockQ = provider['BAD_STOCK_Q'];
			rtnRecord.set('GOOD_STOCK_Q', dGoodStockQ);
			rtnRecord.set('BAD_STOCK_Q', dBadStockQ);
	    }*/
	});//End of Unilite.Main( {
	
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "CHANGE_BASIS_SEQ" :	//순번
					if(newValue <= '0'){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}
				case "ORDER_UNIT_Q" :	//매입수량
					if(newValue <= '0'){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}else if(newValue > record.get('REMAIN_Q')){
						
						var a = record.get('REMAIN_Q');
						rv='<t:message code = "unilite.msg.sMM412"/>' + '<t:message code = "unilite.msg.sMM413"/>' +
						   '<t:message code = "unilite.msg.sMM586"/>' + ':' + a; 
						break;
					}
					
					record.set('AMOUNT_I', newValue * record.get('ORDER_UNIT_P'));
					record.set('BUY_Q', newValue * record.get('TRNS_RATE'));
					
					if(record.get('EXCHG_RATE_O') != '0'){
						record.set('FOREIGN_P',record.get('AMOUNT_P') / record.get('EXCHG_RATE_O'));
						record.set('ORDER_UNIT_FOR_P',record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));
						record.set('FOR_AMOUNT_O',newValue * record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));
					}else{
						record.set('FOR_AMOUNT_O','0');
						record.set('FOREIGN_P','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}
					directMasterStore1.fnSumAmountI(e.store.data.items);
					break;
				case "ORDER_UNIT_P":
					if(newValue <= '0'){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					
					record.set('AMOUNT_I',record.get('ORDER_UNIT_Q')* newValue);
					
					if(record.get('EXCHG_RATE_O') != '0'){
						record.set('FOREIGN_P',record.get('AMOUNT_P') / record.get('EXCHG_RATE_O'));
						record.set('ORDER_UNIT_FOR_P',record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));
						record.set('FOR_AMOUNT_O',record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));
					}else{
						record.set('FOR_AMOUNT_O','0');	
						record.set('FOREIGN_P','0');	
						record.set('ORDER_UNIT_FOR_P','0');	
					}
					directMasterStore1.fnSumAmountI(e.store.data.items);
					
					break;
				case "AMOUNT_I" :
					if(record.get('ORDER_UNIT_Q') > ''){
						if(record.get('ORDER_UNIT_Q') > '0' && newValue <= '0'){
							rv='<t:message code="unilite.msg.sMB076"/>';
							break;
						}else if(record.get('ORDER_UNIT_Q') < '0' && newValue >= '0'){
							rv='<t:message code="unilite.msg.sMB077"/>';
							break;	
						}
					}
					if(newValue > record.get('REMAIN_Q') * record.get('AMOUNT_P')){
						
						var a = record.get('REMAIN_Q');
						rv='<t:message code = "unilite.msg.sMM412"/>' + '<t:message code = "unilite.msg.sMM413"/>' +
						   '<t:message code = "unilite.msg.sMM586"/>' + ':' + a; 
						break;
					}
					
					if(record.get('ADVAN_YN') == 'Y' || record.get('ADVAN_YN') > record.get('ADVAN_AMOUNT')){
						record.set('ORDER_UNIT_Q', record.get('AMOUNT_I') / record.get('ORDER_UNIT_P'));
						record.set('BUY_Q',record.get('ORDER_UNIT_Q'));
					}
					record.set('AMOUNT_I',newValue);
					
					if(record.get('ADVAN_YN') != 'Y' && record.get('ADVAN_AMOUNT') == '0'){
						if(record.get('BUY_Q') != '0'){
							record.set('AMOUNT_P', record.get('AMOUNT_I') / record.get('BUY_Q'));
							
							record.set('ORDER_UNIT_P', record.get('AMOUNT_I') / record.get('ORDER_UNIT_Q'));
						}else{
							record.set('AMOUNT_P','0');
							record.set('ORDER_UNIT_P','0');
						}
					}
					
					if(record.get('EXCHG_RATE_O') != '0'){
						record.set('FOREIGN_P',record.get('AMOUNT_P') / record.get('EXCHG_RATE_O'));
						record.set('ORDER_UNIT_FOR_P', record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));
						record.set('FOR_AMOUNT_O', record.get('AMOUNT_I') / record.get('EXCHG_RATE_O'));
					}else{
						record.set('FOR_AMOUNT_O','0');
						record.set('FOREIGN_P','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}
					directMasterStore1.fnSumAmountI(e.store.data.items);
					break;
				case "ORDER_UNIT_FOR_P" :
					if(newValue <= '0'){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					
					record.set('FOREIGN_P',newValue / record.get('TRNS_RATE'));
					record.set('FOR_AMOUNT_O',record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_FOR_P'));
					
					if(record.get('EXCHG_RATE_O') != '0'){
						record.set('AMOUNT_P',record.get('FOREIGN_P') * record.get('EXCHG_RATE_O'));
						record.set('ORDER_UNIT_P',record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O'));
						record.set('AMOUNT_I',record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P'));
					}else{
						record.set('INOUT_O','0');
						record.set('AMOUNT_P','0');
						record.set('ORDER_UNIT_P','0');	
					}
					directMasterStore1.fnSumAmountI(e.store.data.items);
					break;
				case "FOR_AMOUNT_O" :
					if(record.get('ORDER_UNIT_Q') != ''){
						if(newValue <= '0' && record.get('ORDER_UNIT_Q') > '0'){
							rv='<t:message code="unilite.msg.sMB076"/>';
							break;	
						}else if(newValue >= '0' && record.get('ORDER_UNIT_Q') < '0'){
							rv='<t:message code="unilite.msg.sMB077"/>';
							break;	
						}
					}
					if(record.get('BUY_Q') != '0'){
						record.set('FOREIGN_P', record.get('FOR_AMOUNT_O') / record.get('BUY_Q'));
						record.set('ORDER_UNIT_FOR_P',record.get('FOR_AMOUNT_O') / record.get('ORDER_UNIT_Q'))
					}else{
						record.set('FOREIGN_P','0');
						record.set('ORDER_UNIT_FOR_P','0');		
					}
					
					if(record.get('EXCHG_RATE_O') != '0'){
						record.set('AMOUNT_P', record.get('FOREIGN_P') * record.get('EXCHG_RATE_O'));
						record.set('ORDER_UNIT_P', record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O'));
						record.set('AMOUNT_I', record.get('FOR_AMOUNT_O') * record.get('EXCHG_RATE_O'));
					}else{
						record.set('INOUT_O','0');
						record.set('AMOUNT_P','0');
						record.set('ORDER_UNIT_P','0');		
					}
					directMasterStore1.fnSumAmountI(e.store.data.items);
					break;
				case "TAX_I" :
					if(record.get('ORDER_UNIT_Q') > ''){
						if(record.get('ORDER_UNIT_Q') > '0' && newValue <= '0'){
							rv='<t:message code="unilite.msg.sMB076"/>';
							break;		
						}
					}else if(record.get('ORDER_UNIT_Q') < '0' && newValue >= '0'){
						rv='<t:message code="unilite.msg.sMB077"/>';
						break;	
					}
					
					var	dAmountI;
					
					if(record.get('AMOUNT_I') == ''){
						dAmountI = 0;	
					}else{
						dAmountI = record.get('AMOUNT_I');	
					}
					var dTaxI = newValue;
					
					if(dAmountI > 0){
						if(dAmountI < dTaxI){
							rv='<t:message code="unilite.msg.sMM371"/>';
							break;		
						}
					}else{
						if(dAmountI > dTaxI){
							rv='<t:message code="unilite.msg.sMM372"/>';
							break;	
						}
					}
					dTaxI = Math.round(dTaxI,CustomCodeInfo.gsUnderCalBase);
					directMasterStore1.fnSumTax();
			}
				return rv;
		}
	});	
};
</script>