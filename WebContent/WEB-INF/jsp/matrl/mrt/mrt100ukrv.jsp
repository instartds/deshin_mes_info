<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mrt100ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mrt100ukrv"   /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->		
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M505" /> <!-- 생성경로 (폼) -->
	<t:ExtComboStore comboType="AU" comboCode="B031" /> <!-- 생성경로 (그리드) -->
	<t:ExtComboStore comboType="AU" comboCode="M106" /> <!-- 입고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B021" /> <!-- 품목상태 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" /> <!-- 단가형태 -->
	<t:ExtComboStore comboType="AU" comboCode="S014" /> <!-- 기표대상 -->
	<t:ExtComboStore comboType="AU" comboCode="YP04" /> <!-- 반품처 -->
	<t:ExtComboStore comboType="AU" comboCode="YP08" /> <!-- 조건 -->
	<t:ExtComboStore comboType="AU" comboCode="YP09" /> <!-- 형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!-- 과세구분 -->
	
	
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

var SearchInfoWindow;	//조회버튼 누르면 나오는 조회창
var referReturningReceiptWindow;	//반품접수참조
var BsaCodeInfo = {	
//	gsInoutTypeDetail: '${gsInoutTypeDetail}',
	gsDefaultData: '${gsDefaultData}',
	gsInTypeAccountYN: ${gsInTypeAccountYN},
	gsExcessRate: '${gsExcessRate}',
	gsInvstatus: '${gsInvstatus}',
	gsProcessFlag: '${gsProcessFlag}',
	gsInspecFlag: '${gsInspecFlag}',
	gsMap100UkrLink: '${gsMap100UkrLink}',
	gsSumTypeLot: '${gsSumTypeLot}',
	gsSumTypeCell: '${gsSumTypeCell}',
	gsDefaultMoney: '${gsDefaultMoney}',
	gsInOutPrsn: '${gsInOutPrsn}',
	gsAutoType: '${gsAutoType}'
};
var CustomCodeInfo = {
	gsUnderCalBase: ''
};
/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/


var gsInoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_M106').getAt(0).get('value');
var outDivCode = UserInfo.divCode;


var aa = 0;

function appMain() {
	
	var isAutoInoutNum = false;
	if(BsaCodeInfo.gsAutoType=='Y')	{
		isAutoInoutNum = true;
	}
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mrt100ukrvService.selectList',
			update: 'mrt100ukrvService.updateDetail',
			create: 'mrt100ukrvService.insertDetail',
			destroy: 'mrt100ukrvService.deleteDetail',
			syncAll: 'mrt100ukrvService.saveAll'
		}
	});	
	
	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Mrt100ukrvModel', {
	    fields: [
	    	{name: 'INOUT_NUM'         ,text: '반품번호' 			,type: 'string'},
	    	{name: 'INOUT_SEQ'         ,text: 'INOUT_SEQ' 		,type: 'int', allowBlank: false},
	    	{name: 'SORT_SEQ'		   ,text:'<t:message code="system.label.purchase.seq" default="순번"/>'   			,type: 'int'},
	    	{name: 'INOUT_METH'        ,text: '<t:message code="system.label.purchase.method" default="방법"/>' 				,type: 'string'},
	    	{name: 'INOUT_TYPE_DETAIL' ,text: '반품유형' 			,type: 'string',comboType:'AU',comboCode:'M106', allowBlank: false},
	    	{name: 'ITEM_CODE'         ,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>' 			,type: 'string', allowBlank: false},
	    	{name: 'ITEM_NAME'         ,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>' 			,type: 'string'},
	    	{name: 'ITEM_ACCOUNT'      ,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>' 			,type: 'string'},
	    	{name: 'SPEC'              ,text: '<t:message code="system.label.purchase.spec" default="규격"/>' 				,type: 'string'},
	    	{name: 'ORDER_UNIT'        ,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>' 			,type: 'string'},
	    	
	    	
	    	{name: 'PURCHASE_TYPE'         ,text: '매입조건' 			,type: 'string',comboType:'AU',comboCode:'YP08', editable: false},
	    	{name: 'SALES_TYPE'        	   ,text: '판매형태' 			,type: 'string',comboType:'AU',comboCode:'YP09', editable: false},
	    	
	    	
	    	
	    	
	    	{name: 'ITEM_STATUS'       ,text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>' 			,type: 'string', allowBlank: false},
	    	{name: 'ORIGINAL_Q'        ,text: '기존반품량' 			,type: 'uniQty'},
	    	{name: 'GOOD_STOCK_Q'      ,text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>' 			,type: 'uniQty'},
	    	{name: 'BAD_STOCK_Q'       ,text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>' 			,type: 'uniQty'},
	    	{name: 'NOINOUT_Q'         ,text: '미반품량' 			,type: 'uniQty'},
	    	{name: 'PRICE_YN'          ,text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>' 			,type: 'string', allowBlank: false},
	    	{name: 'MONEY_UNIT'        ,text: '<t:message code="system.label.purchase.currency" default="화폐"/>' 				,type: 'string'},
	    	{name: 'INOUT_FOR_P'       ,text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>' 		,type: 'uniUnitPrice'},
	    	{name: 'INOUT_FOR_O'       ,text: '<t:message code="system.label.purchase.inventoryunitamount" default="재고단위금액"/>' 		,type: 'uniPrice'},
	    	
	    	{name: 'SALE_BASIS_P'	   ,text: '판매가' 		,type: 'uniUnitPrice'},
	    	{name: 'PURCHASE_RATE'     ,text: '매입율' 			,type: 'uniER'},
	    	
            {name: 'ORDER_UNIT_FOR_P'  ,text: '<t:message code="system.label.purchase.purchaseprice" default="구매단가"/>' 			,type: 'uniUnitPrice', allowBlank: false},
            {name: 'ORDER_UNIT_Q'      ,text: '반품수량' 			,type: 'uniQty', allowBlank: false},
            {name: 'ORDER_UNIT_FOR_O'  ,text: '<t:message code="system.label.purchase.amount" default="금액"/>' 				,type: 'uniPrice', allowBlank: false},
            
            {name: 'INOUT_P'           ,text: '<t:message code="system.label.purchase.copricestock" default="자사단가(재고)"/>' 		,type: 'uniUnitPrice'},
            
            {name: 'TAX_TYPE' 		   		, text: '과세구분'					, type: 'string',comboType:'AU',comboCode:'B059'},
	    	{name: 'INOUT_I'           ,text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>' 			,type: 'uniPrice', allowBlank: false},
	    	{name: 'INOUT_TAX_AMT'     ,text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'			,type: 'uniPrice'},
	    	{name: 'INOUT_TOTAL_I'     ,text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'			,type: 'uniPrice'},
	    	
	    	
	    	{name: 'ACCOUNT_YNC'       ,text: '<t:message code="system.label.purchase.sliptarget" default="기표대상"/>' 			,type: 'string', allowBlank: false,comboType:'AU',comboCode:'S014'},
	    	{name: 'EXCHG_RATE_O'      ,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>' 				,type: 'uniER'},
//	    	{name: 'INOUT_P'           ,text: '<t:message code="system.label.purchase.copricestock" default="자사단가(재고)"/>' 		,type: 'uniUnitPrice'},
//	    	{name: 'INOUT_I'           ,text: '<t:message code="system.label.purchase.coamountstock" default="자사금액(재고)"/>' 		,type: 'uniPrice'},
	    	{name: 'ORDER_UNIT_P'      ,text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>' 			,type: 'uniUnitPrice'},
	    	{name: 'ORDER_UNIT_I'      ,text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>' 			,type: 'uniPrice'},
	    	{name: 'STOCK_UNIT'        ,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>' 			,type: 'string'},
	    	{name: 'TRNS_RATE'         ,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>' 				,type: 'string'},
	    	{name: 'INOUT_Q'           ,text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>' 		,type: 'uniQty', allowBlank: false},
	    	{name: 'ORDER_TYPE'        ,text: '<t:message code="system.label.purchase.potype" default="발주형태"/>' 			,type: 'string', allowBlank: false},
	    	{name: 'LC_NUM'            ,text: 'LC/NO(*)' 		,type: 'string'},
	    	{name: 'BL_NUM'            ,text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>' 			,type: 'string'},
	    	{name: 'ORDER_NUM'         ,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>' 			,type: 'string'},
	    	{name: 'ORDER_SEQ'         ,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 				,type: 'int'},
	    	{name: 'ORDER_Q'           ,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>' 			,type: 'uniQty'},
	    	{name: 'INOUT_CODE_TYPE'   ,text: '반품처구분' 			,type: 'string'},
	    	{name: 'DEPT_CODE'          ,text: '<t:message code="system.label.purchase.departmencode" default="부서코드"/>' 			,type: 'string'},
	    	{name: 'WH_CODE'           ,text: '반품창고' 			,type: 'string'},
	    	{name: 'WH_CELL_CODE'	   ,text: 'CELL창고' 			,type: 'string'},
	    	{name: 'WH_CELL_NAME'	   ,text: 'CELL창고' 			,type: 'string'},
	    	{name: 'INOUT_DATE'        ,text: '반품일' 			,type: 'uniDate'},
	    	{name: 'INOUT_PRSN'        ,text: '반품담당' 			,type: 'string'},
	    	{name: 'ACCOUNT_Q'         ,text: '<t:message code="system.label.purchase.billqty" default="계산서량"/>' 			,type: 'uniQty'},
	    	{name: 'CREATE_LOC'        ,text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>' 			,type: 'string'},
	    	{name: 'SALE_C_DATE'       ,text: '<t:message code="system.label.purchase.billclosingdate" default="계산서마감일"/>' 		,type: 'uniDate'},
	    	{name: 'REMARK'            ,text: '<t:message code="system.label.purchase.remarks" default="비고"/>' 				,type: 'string'},
	    	{name: 'PROJECT_NO'        ,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>' 			,type: 'string'},
	    	{name: 'INOUT_TYPE'        ,text: '<t:message code="system.label.purchase.type" default="타입"/>' 				,type: 'string'},
	    	{name: 'INOUT_CODE'        ,text: '매입처' 			,type: 'string'},
	    	{name: 'DIV_CODE'          ,text: '<t:message code="system.label.purchase.division" default="사업장"/>' 			,type: 'string'},
	    	{name: 'CUSTOM_NAME'       ,text: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>' 			,type: 'string'},
	    	{name: 'COMPANY_NUM'       ,text: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>' 			,type: 'string'},
	    	{name: 'INSTOCK_Q'         ,text: '발주반품수량' 		,type: 'uniQty'},
	    	{name: 'SALE_DIV_CODE'     ,text: '<t:message code="system.label.purchase.salesdivision" default="매출사업장"/>' 			,type: 'string'},
	    	{name: 'SALE_CUSTOM_CODE'  ,text: '<t:message code="system.label.purchase.salesplace" default="매출처"/>' 			,type: 'string'},
	    	{name: 'BILL_TYPE'         ,text: '<t:message code="system.label.purchase.salestype" default="매출유형"/>' 			,type: 'string'},
	    	{name: 'SALE_TYPE'         ,text: '<t:message code="system.label.purchase.salesclass" default="매출구분"/>' 			,type: 'string'},
	    	{name: 'UPDATE_DB_USER'    ,text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>' 			,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'    ,text: '수정한 날짜' 		,type: 'uniDate'},
	    	{name: 'EXCESS_RATE'       ,text: '과반품허용율' 		,type: 'string'},
	    	{name: 'INSPEC_NUM'        ,text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>' 			,type: 'string'},
	    	{name: 'INSPEC_SEQ'        ,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 				,type: 'int'},
	    	{name: 'COMP_CODE'         ,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>' 			,type: 'string'},
	    	{name: 'BASIS_NUM'         ,text: 'BASIS_NUM' 		,type: 'string'},
	    	{name: 'BASIS_SEQ'         ,text: 'BASIS_SEQ' 		,type: 'int'},
	    	{name: 'SCM_FLAG_YN'       ,text: 'SCM_FLAG_YN' 	,type: 'string'},
	    	{name: 'LOT_NO'			   ,text: 'LOT NO'        	,type: 'string'},
	    	{name: 'LOT_ASSIGNED_YN'   ,text: 'LOT_ASSIGNED_YN' ,type: 'string', defaultValue: "N"},	//lot팝업에서 선택시 Y로 set..
//	    	{name: 'TEMP_ORDER_UNIT_Q' , text:'TEMP_ORDER_UNIT_Q', type: 'uniQty'},//LOT팝업에서 허용된 수량만 입력하기 위해..
	    	{name: 'RETURN_NUM'	 	   ,text: '반품접수번호'        ,type: 'string'},
	    	{name: 'RETURN_SEQ'	 	   ,text: '반품접수순번'        ,type: 'int'},
	    	
	    	{name: 'LOT_ASSIGNED_YN_DUMMY'	 	,text: 'LOT_ASSIGNED_YN_DUMMY'      ,type: 'string'},
	    	{name: 'PURCHASE_RATE_DUMMY'	 	,text: 'PURCHASE_RATE_DUMMY'        ,type: 'string'},
	    	{name: 'ORDER_UNIT_FOR_P_DUMMY'	 	,text: 'ORDER_UNIT_FOR_P_DUMMY'     ,type: 'string'},
	    	{name: 'INOUT_P_DUMMY'	 	   		,text: 'INOUT_P_DUMMY'        		,type: 'string'},
	    	{name: 'ORDER_UNIT_P_DUMMY'	 	    ,text: 'ORDER_UNIT_P_DUMMY'         ,type: 'string'},
	    	{name: 'SALES_TYPE_DUMMY'	 	    ,text: 'SALES_TYPE_DUMMY'        	,type: 'string'},
	    	{name: 'PURCHASE_TYPE_DUMMY'	 	,text: 'PURCHASE_TYPE_DUMMY'        ,type: 'string'},
	    	{name: 'ORDER_UNIT_FOR_O_DUMMY'	 	,text: 'ORDER_UNIT_FOR_O_DUMMY'     ,type: 'string'},
	    	{name: 'INOUT_FOR_P_DUMMY'	 		,text: 'INOUT_FOR_P_DUMMY'     		,type: 'string'},
	    	{name: 'INOUT_FOR_O_DUMMY'	 		,text: 'INOUT_FOR_O_DUMMY'     		,type: 'string'},
	    	{name: 'ORDER_UNIT_I_DUMMY'	 		,text: 'ORDER_UNIT_I_DUMMY'     	,type: 'string'},
	    	{name: 'INOUT_I_DUMMY'	 	   		,text: 'INOUT_I_DUMMY'        		,type: 'string'},
	    	{name: 'INOUT_TAX_AMT_DUMMY'	 	,text: 'INOUT_TAX_AMT_DUMMY'        ,type: 'string'},
	    	{name: 'INOUT_TOTAL_I_DUMMY'	 	,text: 'INOUT_TOTAL_I_DUMMY'        ,type: 'string'}
	    	
	    	
		]
	});
	
	Unilite.defineModel('inoutNoMasterModel', {		//조회버튼 누르면 나오는 조회창
	    fields: [
	    	{name: 'INOUT_NAME'       		    		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'    	, type: 'string'},
	    	{name: 'INOUT_DATE'       		    		, text: '반품일'    	, type: 'uniDate'},
	    	{name: 'INOUT_CODE'       		    		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'   , type: 'string'},
	    	{name: 'WH_CODE'          		    		, text: '반품창고'    	, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'WH_CELL_CODE'     		    		, text: '반품창고Cell' , type: 'string'},
	    	{name: 'DIV_CODE'         		    		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'    	, type: 'string',comboType:'BOR120'},
	    	{name: 'DEPT_CODE'         		    		, text: '<t:message code="system.label.purchase.department" default="부서"/>'    	, type: 'string'},
	    	{name: 'DEPT_NAME'         		    		, text: '<t:message code="system.label.purchase.department" default="부서"/>'    	, type: 'string'},
	    	{name: 'RETURN_CODE' 	     		    	, text: '반품처'    	, type: 'string',comboType:'AU', comboCode:'YP04'},
	    	{name: 'INOUT_PRSN' 	     		    	, text: '반품담당'    	, type: 'string',comboType:'AU', comboCode:'B024'},
	    	{name: 'INOUT_NUM'        		    		, text: '반품번호'    	, type: 'string'},
	    	{name: 'SUM_ORDER_UNIT_Q'      				, text: '<t:message code="system.label.purchase.qty" default="수량"/>' 		,type: 'uniPrice'},
	    	{name: 'SUM_ORDER_UNIT_FOR_O'      			, text: '<t:message code="system.label.purchase.amount" default="금액"/>' 		,type: 'uniPrice'},
	    	
	    	{name: 'MONEY_UNIT'       		    		, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'    	, type: 'string'},
	    	{name: 'EXCHG_RATE_O'     		    		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'    	, type: 'uniER'},
	    	{name: 'CREATE_LOC'       		    		, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'    	, type: 'string',comboType:'AU',comboCode:'M505'}
		]
	});
	
	Unilite.defineModel('mrt100ukrvRETRUTNINGRECEIPTModel', {	//반품접수참조 
	    fields: [
			{name: 'COMP_CODE'          ,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>' 			,type: 'string'},
	    	{name: 'DIV_CODE'       	,text: '<t:message code="system.label.purchase.division" default="사업장"/>' 			,type: 'string',comboType:'BOR120'},
	    	{name: 'RETURN_SEQ'         ,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 			,type: 'int'},
	    	{name: 'RETURN_NUM'         ,text: '반품접수번호' 		,type: 'string'},
	    	{name: 'ITEM_CODE'          ,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>' 			,type: 'string',allowBlank: false},
	    	{name: 'ITEM_NAME'          ,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>' 			,type: 'string',allowBlank: false},
	    	{name: 'SPEC'         		,text: '<t:message code="system.label.purchase.spec" default="규격"/>' 			,type: 'string'},
	    	{name: 'ORDER_UNIT'         ,text: '<t:message code="system.label.purchase.unit" default="단위"/>' 			,type: 'string'},
	    	{name: 'LOT_NO'         	,text: 'LOT NO' 		,type: 'string'},
	    	{name: 'LOT_ASSIGNED_YN'    ,text: 'LOT예약' 			,type: 'string'},
	    	{name: 'PURCHASE_TYPE'      ,text: '조건' 			,type: 'string',comboType:'AU',comboCode:'YP08'},
	    	{name: 'SALES_TYPE'         ,text: '형태' 			,type: 'string',comboType:'AU',comboCode:'YP09'},
	    	{name: 'GOOD_STOCK_Q'       ,text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>' 			,type: 'uniQty'},
	    	{name: 'SALE_BASIS_P'       ,text: '판매가' 			,type: 'uniUnitPrice'},
	    	{name: 'PURCHASE_RATE'      ,text: '매입율' 			,type: 'uniER'},
	    	{name: 'ORDER_UNIT_FOR_P'   ,text: '매입가' 			,type: 'uniUnitPrice'},
	    	{name: 'ORDER_UNIT_Q'       ,text: '반품접수수량' 		,type: 'uniQty',allowBlank: false},
	    	{name: 'RETURN_CONFIRM_Q'   ,text: '반품확정수량' 		,type: 'uniQty'},
	    	{name: 'ORDER_UNIT_FOR_O'   ,text: '<t:message code="system.label.purchase.amount" default="금액"/>' 			,type: 'uniPrice'},
	    	{name: 'REMARK'         	,text: '<t:message code="system.label.purchase.remarks" default="비고"/>' 			,type: 'string'},
	    	{name: 'WH_CODE'         	,text: '<t:message code="system.label.purchase.warehouse" default="창고"/>' 			,type: 'string'},
	    	{name: 'CUSTOM_CODE'        ,text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>' 		,type: 'string'},
	    	{name: 'CUSTOM_NAME'        ,text: '<t:message code="system.label.purchase.custom" default="거래처"/>' 			,type: 'string'},
	    	{name: 'RETURN_CODE'        ,text: '반품처' 			,type: 'string'},
	    	{name: 'INOUT_PRSN'         ,text: '<t:message code="system.label.purchase.trancharge" default="수불담당"/>' 			,type: 'string'},
	    	{name: 'RETURN_DATE'        ,text: '반품일' 			,type: 'string'},
	    	{name: 'DEPT_CODE'          ,text: '<t:message code="system.label.purchase.department" default="부서"/>' 			,type: 'string'},
	    	{name: 'DEPT_NAME'          ,text: '<t:message code="system.label.purchase.department" default="부서"/>' 			,type: 'string'}
	    	]
	    	
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mrt100ukrvMasterStore1', {
		model: 'Mrt100ukrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부 
			allDeletable: true,
			useNavi : false			// prev | newxt 버튼 사용
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
			
			var totRecords = directMasterStore1.data.items;			
			Ext.each(totRecords, function(record, index) {
				record.set('SORT_SEQ', index+1);
			});
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
						panelResult2.setValue("INOUT_NUM", master.INOUT_NUM);
				/*		var inoutNum = masterForm.getValue('INOUT_NUM');
						Ext.each(list, function(record, index) {
							if(record.data['INOUT_NUM'] != inoutNum) {
								record.set('INOUT_NUM', inoutNum);
							}
						})*/
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
//						directMasterStore1.loadStoreRecords();
						
						if (directMasterStore1.count() == 0) {   
							UniAppManager.app.onResetButtonDown();
						}//else{
//							directMasterStore1.loadStoreRecords();
//						}
					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('mrt100ukrvGrid1');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		this.fnSumAmountI();
           	},
           	add: function(store, records, index, eOpts) {
           		this.fnSumAmountI();
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           		this.fnSumAmountI();
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           		this.fnSumAmountI();
           	}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		},
		fnSumAmountI:function(){
			

				var dAmountI = Ext.isNumeric(this.sum('INOUT_FOR_O')) ? this.sum('INOUT_FOR_O'):0; // 재고단위금액
				var dIssueAmtWon = Ext.isNumeric(this.sum('INOUT_I')) ? this.sum('INOUT_I'):0;	// 자사금액(재고)
			
				panelResult.setValue('SumInoutO',dAmountI);
				panelResult.setValue('IssueAmtWon',dIssueAmtWon);
		}
	});//End of var directMasterStore1 = Unilite.createStore('mrt100ukrvMasterStore1', {
	var inoutNoMasterStore = Unilite.createStore('inoutNoMasterStore', {	//조회버튼 누르면 나오는 조회창
		model: 'inoutNoMasterModel',
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
            	read: 'mrt100ukrvService.selectinoutNoMasterList'
            }
        }
        ,loadStoreRecords : function()	{
			var param= inoutNoSearch.getValues();			
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(inoutNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var returningReceiptStore = Unilite.createStore('mrt100ukrvReturningReceiptStore', {//반품접수참조
		model: 'mrt100ukrvRETRUTNINGRECEIPTModel',
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
            	read: 'mrt100ukrvService.selectReturningReceiptList'                	
            }
        },
        listeners:{
        	load:function(store, records, successful, eOpts)	{
        			if(successful)	{
        			   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);  
        			   var returningReceiptRecords = new Array();
        			   if(masterRecords.items.length > 0)	{
        			   		console.log("store.items :", store.items);
        			   		console.log("records", records);
        			   	
            			   	Ext.each(records, 
            			   		function(item, i)	{           			   								
		   							Ext.each(masterRecords.items, function(record, i)	{
		   								console.log("record :", record);
		   							
		   									if( (record.data['RETURN_NUM'] == item.data['RETURN_NUM']) 
		   											&& (record.data['RETURN_SEQ'] == item.data['RETURN_SEQ'])
		   									  ) 
		   									{
		   										returningReceiptRecords.push(item);
		   									}
		   							});		
            			   	});
            			   store.remove(returningReceiptRecords);
        			   }
        			}
        	}
        }
        ,loadStoreRecords : function()	{
			var param= returningReceiptSearch.getValues();	
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(returningReceiptSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
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
	        	panelResult2.show();
	        },
	        expand: function() {
	        	panelResult2.hide();
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
				child:'WH_CODE',
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult2.getField('INOUT_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult2.setValue('DIV_CODE', newValue);
						var field2 = panelResult2.getField('WH_CODE');		
						field2.getStore().clearFilter(true);
					}
				}
			},
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							masterForm.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult2.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult2.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
							panelResult2.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelResult2.setValue('DEPT_CODE', '');
						panelResult2.setValue('DEPT_NAME', '');
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
			Unilite.popup('CUST', {
					fieldLabel: '매입처',
					valueFieldName:'CUSTOM_CODE',
			    	textFieldName:'CUSTOM_NAME',
					allowBlank: false,
					holdable: 'hold',
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
								masterForm.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
								masterForm.setValue('EXCHG_RATE_O', '1');
								masterForm.setValue('RETURN_CODE',records[0]["RETURN_CODE"]);
								panelResult2.setValue('RETURN_CODE',records[0]["RETURN_CODE"]);
								panelResult2.setValue('CUSTOM_CODE2', masterForm.getValue('CUSTOM_CODE'));
								panelResult2.setValue('CUSTOM_NAME2', masterForm.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult2.setValue('CUSTOM_CODE2', '');
							panelResult2.setValue('CUSTOM_NAME2', '');
						}
					}
				}),
			{
		        fieldLabel: '반품일',
		        name: 'INOUT_DATE',
		        xtype: 'uniDatefield',
		       	value: UniDate.get('today'),
		     	allowBlank: false,
		     	holdable: 'hold',
		     	width : 200,
		     	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult2.setValue('INOUT_DATE', newValue);
					}
				}
			},{
				fieldLabel: '반품창고',
				name: 'WH_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList'),
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult2.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '반품처', 
				name: 'RETURN_CODE', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'YP04', 
//				allowBlank: false,
//				holdable: 'hold',
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult2.setValue('RETURN_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.trancharge" default="수불담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				holdable: 'hold',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult2.setValue('INOUT_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '반품번호',
				xtype: 'uniTextfield',
				name:'INOUT_NUM',
				readOnly: isAutoInoutNum
			},{
				fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>', 
				name: 'MONEY_UNIT', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B004',
				displayField: 'value',
				allowBlank: false,
				fieldStyle: 'text-align: center;',
				holdable: 'hold'
			},{
				fieldLabel: '<t:message code="system.label.purchase.exchangerate" default="환율"/>',
				name:'EXCHG_RATE_O',
				xtype: 'uniTextfield',
				allowBlank: false,
				holdable: 'hold'
			},{
				fieldLabel: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
				name: 'CREATE_LOC',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M505',
				holdable: 'hold',
				hidden:false
			},{
				fieldLabel:'ITEM_CODE',
				name:'ITEM_CODE',
				xtype: 'uniTextfield',
				hidden: true
				
			},{
				fieldLabel:'ORDER_UNIT',
				name:'ORDER_UNIT',
				xtype: 'uniTextfield',
				hidden: true
				
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

	});//End of var masterForm = Unilite.createSearchForm('searchForm', {
	var panelResult2 = Unilite.createSearchForm('resultForm2',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				holdable: 'hold',
				child:'WH_CODE',
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);						
					var field = masterForm.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					masterForm.setValue('DIV_CODE', newValue);
					var field2 = masterForm.getField('WH_CODE');		
						field2.getStore().clearFilter(true);
				}
				}
			},
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							masterForm.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult2.setValue('WH_CODE',records[0]["WH_CODE"]);
							masterForm.setValue('DEPT_CODE', panelResult2.getValue('DEPT_CODE'));
							masterForm.setValue('DEPT_NAME', panelResult2.getValue('DEPT_NAME'));
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
				fieldLabel: '반품창고',
				name: 'WH_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList'),
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('WH_CODE', newValue);
					}
				}
			},{
		        fieldLabel: '반품일',
		        name: 'INOUT_DATE',
		        xtype: 'uniDatefield',
		       	value: UniDate.get('today'),
		     	allowBlank: false,
		     	holdable: 'hold',
		     	width : 200,
		     	colspan: 2,
		     	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('INOUT_DATE', newValue);
					}
				}
			},
			Unilite.popup('CUST', {
				fieldLabel: '매입처',
				valueFieldName:'CUSTOM_CODE2',
		    	textFieldName:'CUSTOM_NAME2',
				allowBlank: false,
				holdable: 'hold',
				extParam: {'CUSTOM_TYPE': ['1','2']},
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
							masterForm.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
							masterForm.setValue('EXCHG_RATE_O', '1');
							masterForm.setValue('RETURN_CODE',records[0]["RETURN_CODE"]);
							panelResult2.setValue('RETURN_CODE',records[0]["RETURN_CODE"]);
							masterForm.setValue('CUSTOM_CODE', panelResult2.getValue('CUSTOM_CODE2'));
							masterForm.setValue('CUSTOM_NAME', panelResult2.getValue('CUSTOM_NAME2'));
							
                    	},
						scope: this
					},
					onClear: function(type)	{
								masterForm.setValue('CUSTOM_CODE', '');
								masterForm.setValue('CUSTOM_NAME', '');
							}
				}
			}),
			{
				fieldLabel: '반품처', 
				name: 'RETURN_CODE', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'YP04', 
//				allowBlank: false,
//				holdable: 'hold',
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('RETURN_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.trancharge" default="수불담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				holdable: 'hold',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('INOUT_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '반품번호',
				xtype: 'uniTextfield',
				name:'INOUT_NUM',
				readOnly: isAutoInoutNum
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
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'south',
	    items: [{	
	    	xtype:'container',
	    	padding:'0 5 5 5',
	        defaultType: 'uniTextfield',
	        layout: {
	        	type: 'uniTable',
	        	columns : 2,
	        	tableAttrs: {align:'right'}
	        },
	        items: [{
	        	fieldLabel: '금액합계',
	        	name:'SumInoutO',
	        	xtype: 'uniNumberfield',
	        	readOnly: true
	        },{
	       	 	fieldLabel: '자사금액합계',
	       	 	name:'IssueAmtWon',
	       	 	xtype: 'uniNumberfield',
	        	readOnly: true
	        }]
	    }]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{    
    
    var inoutNoSearch = Unilite.createSearchForm('inoutNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 3},
	    trackResetOnLoad: true,
	    items: [
			{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				child:'WH_CODE',
				allowBlank:false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);						
						var field = inoutNoSearch.getField('INOUT_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						var field2 = inoutNoSearch.getField('WH_CODE');		
						field2.getStore().clearFilter(true);
					}
				}
			},
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
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
			}),	
			{
				fieldLabel: '반품창고', 
				name: 'WH_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList')
			},
			Unilite.popup('CUST',{ 
				fieldLabel: '매입처', 
				valueFieldName: 'INOUT_CODE',
		   	 	textFieldName: 'INOUT_NAME',
				
				validateBlank: false,
				extParam: {'CUSTOM_TYPE': ['1','2']}
			}),
			{
				fieldLabel: '반품일',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315
			},{
				fieldLabel: '<t:message code="system.label.purchase.trancharge" default="수불담당"/>', 
				name: 'INOUT_PRSN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B024',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			}]
    }); // createSearchForm
    
    var returningReceiptSearch = Unilite.createSearchForm('returningReceiptForm', {//반품접수참조
            layout :  {type : 'uniTable', columns : 3},
            items :[{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				holdable: 'hold',
				readOnly: true,
				child:'WH_CODE',
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);						
					var field = returningReceiptSearch.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					var field2 = returningReceiptSearch.getField('WH_CODE');		
						field2.getStore().clearFilter(true);
				}
				}
			},
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				allowBlank: false,
				holdable: 'hold',
				readOnly: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							returningReceiptSearch.setValue('WH_CODE',records[0]["WH_CODE"]);
						},
						scope: this
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
							popup.setExtParam({'DIV_CODE': returningReceiptSearch.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),
			{
				fieldLabel: '반품접수창고',
				name: 'WH_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList'),
				allowBlank: false,
				holdable: 'hold',
				readOnly: true
			},{
		        fieldLabel: '반품접수일',
		        name: 'RETURN_DATE',
		        xtype: 'uniDatefield',
		       	value: UniDate.get('today'),
		     	allowBlank: false,
		     	holdable: 'hold',
		     	width : 200
			},
			Unilite.popup('CUST', {
				fieldLabel: '매입처',
				valueFieldName:'CUSTOM_CODE',
		    	textFieldName:'CUSTOM_NAME',
				allowBlank: false,
				holdable: 'hold',
				readOnly: true,
				extParam: {'CUSTOM_TYPE': ['1','2']},
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							returningReceiptSearch.setValue('RETURN_CODE',records[0]["RETURN_CODE"]);
							
                    	},
						scope: this
					}
				}
			}),
			{
				fieldLabel: '반품처', 
				name: 'RETURN_CODE', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'YP04',
				readOnly: true
//				allowBlank: false,
//				holdable: 'hold',
//				readOnly:true
			},{
				fieldLabel: '<t:message code="system.label.purchase.trancharge" default="수불담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				holdable: 'hold',
				readOnly: true,
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},{
				fieldLabel: '반품접수번호',
				xtype: 'uniTextfield',
				name:'RETURN_NUM'
			}]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('mrt100ukrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		excelTitle: '반품등록',
		tbar: [{
			xtype: 'splitbutton',
           	itemId:'orderTool',
			text: '<t:message code="system.label.purchase.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'returningReceiptBtn',
					text: '반품접수참조',
					handler: function() {
						openReturningReceiptWindow();
					}
				}]
			})
		}],
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
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		store: directMasterStore1,
		columns: [        
               		 { dataIndex: 'INOUT_NUM'         , 	width:110, hidden: true},
               		 { dataIndex: 'INOUT_SEQ'         , 	width:50/*, locked: true*/, hidden: true },
               		 { dataIndex: 'SORT_SEQ'		  ,		width:60, locked: false, align: 'center' },
               		 { dataIndex: 'INOUT_METH'        , 	width:66, hidden: true},
               		 { dataIndex: 'INOUT_TYPE_DETAIL' , 	width:100, align: 'center'/*, locked: true*/},
               		 { dataIndex: 'ITEM_CODE' 	      , width:120,
	               		 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
	            	},/*locked: true,*/
						editor: Unilite.popup('CUST_PUMOK_G', {	
												popupWidth: 865,
					 							textFieldName: 'ITEM_CODE',
					 							DBtextFieldName: 'ITEM_CODE',
					 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
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
																		
																		
//																		masterGrid.editingPlugin.startEdit(masterGrid.uniOpt.currentRecord,masterGrid.getColumn('LOT_NO'));
																	/*	
																		setTimeout(function(){
																			if(masterGrid.uniOpt.currentRecord.get('ORDER_UNIT_FOR_P') <=0 ){
																				alert('해당되는 매입처의 제품이 아닙니다');	
																			}
																		}
																			, 1000
																			
																		)*/
																	},
																scope: this
																},
															'onClear': function(type) {
																	var a = masterGrid.uniOpt.currentRecord.get('ITEM_CODE');
																	
																	masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
																	if(a.length < 13){
																		if(!Ext.isEmpty(a)){
																			var zero = ''
																			var dataLength = a.length;
																			for(var i = 0; i < 13 - dataLength; i++){
																				zero += '0'
																			}
																			var itemCode = zero + a;
																			masterGrid.uniOpt.currentRecord.set('ITEM_CODE',itemCode);
																		}								
																	}else{
																		masterGrid.uniOpt.currentRecord.set('ITEM_CODE',a);	
																	}
																	if(aa == 0){
																//	alert(a);
																		if(a != ''){
																			alert("해당되는 매입처의 제품이 아니거나 미등록상품입니다.");
																			aa++;
																		}
																	}else{
																		aa=0;	
																	}
															},
													applyextparam: function(popup){							
														popup.setExtParam({'DIV_CODE': panelResult2.getValue('DIV_CODE')});
														popup.setExtParam({'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE')});
													}
												}
										})
					},
               		 {dataIndex: 'ITEM_NAME', width:300,/*locked: true,*/
						editor: Unilite.popup('CUST_PUMOK_G', {
												popupWidth: 865,
					 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
		                    					autoPopup: true,
												listeners: {'onSelected': {
																fn: function(records, type) {
													                    console.log('records : ', records);
													                    Ext.each(records, function(record,i) {													                   
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
														popup.setExtParam({'DIV_CODE': panelResult2.getValue('DIV_CODE')});
														popup.setExtParam({'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE')});
													}
													}
										})
					},
					  {dataIndex: 'LOT_NO'						,		width:125,
					  editor: Unilite.popup('LOTNO_G', {		
		 							textFieldName: 'LOTNO_CODE',
		 							DBtextFieldName: 'LOTNO_CODE',
	//			 							var grdRecord = masterGrid.getSelectedRecord(),
	//	 							extParam: {  DIV_CODE: '02', WH_CODE: masterForm, CUSTOM_CODE: masterForm.getValue('CUSTOM_CODE')/*,CUSTOM_NAME: masterForm.getValue('CUSTOM_NAME')*/},
	//			 										WH_CODE: masterGrid.currentRecord.get('WH_CODE'), ITEM_CODE: masterGrid.currentRecord.get('ITEM_CODE'), 
	//			 										ITEM_NAME: masterGrid.currentRecord.get('ITEM_NAME'), POPUP_TYPE: 'GRID_CODE'},
		 							
	//			 							WH_CODE: grdRecord.get('WH_CODE')},
		 							//validateBlank: false,
		 							//useBarcodeScanner: false,
		                    		autoPopup: true,
									listeners: {'onSelected': {
										fn: function(records, type) {
												var rtnRecord;
												Ext.each(records, function(record,i) {
													if(i==0){
														rtnRecord = masterGrid.uniOpt.currentRecord
													}else{
														rtnRecord = masterGrid.getSelectedRecord()
													}
													
													rtnRecord.set('LOT_ASSIGNED_YN_DUMMY' 	, rtnRecord.get('LOT_ASSIGNED_YN'));
													rtnRecord.set('PURCHASE_RATE_DUMMY' 	, rtnRecord.get('PURCHASE_RATE'));
													rtnRecord.set('ORDER_UNIT_FOR_P_DUMMY'  , rtnRecord.get('ORDER_UNIT_FOR_P'));
													rtnRecord.set('INOUT_P_DUMMY' 			, rtnRecord.get('INOUT_P'));
													rtnRecord.set('ORDER_UNIT_P_DUMMY' 		, rtnRecord.get('ORDER_UNIT_P'));
													rtnRecord.set('SALES_TYPE_DUMMY' 		, rtnRecord.get('SALES_TYPE'));
													rtnRecord.set('PURCHASE_TYPE_DUMMY' 	, rtnRecord.get('PURCHASE_TYPE'));
													rtnRecord.set('ORDER_UNIT_FOR_O_DUMMY'  , rtnRecord.get('ORDER_UNIT_FOR_O'));
													rtnRecord.set('INOUT_FOR_P_DUMMY'  		, rtnRecord.get('INOUT_FOR_P'));
													rtnRecord.set('INOUT_FOR_O_DUMMY'  		, rtnRecord.get('INOUT_FOR_O'));
													rtnRecord.set('ORDER_UNIT_I_DUMMY'  	, rtnRecord.get('ORDER_UNIT_I'));
													rtnRecord.set('INOUT_I_DUMMY' 			, rtnRecord.get('INOUT_I'));
													rtnRecord.set('INOUT_TAX_AMT_DUMMY' 	, rtnRecord.get('INOUT_TAX_AMT'));
													rtnRecord.set('INOUT_TOTAL_I_DUMMY' 	, rtnRecord.get('INOUT_TOTAL_I'));

													
													rtnRecord.set('LOT_NO', record['LOT_NO']);
													rtnRecord.set('LOT_ASSIGNED_YN', 'Y');
//													rtnRecord.set('TEMP_ORDER_UNIT_Q', record['STOCK_Q']);
//													rtnRecord.set('ORDER_UNIT_Q', 0);
													rtnRecord.set('PURCHASE_RATE', record['PURCHASE_RATE']);
													rtnRecord.set('ORDER_UNIT_FOR_P', record['PURCHASE_P']);
													rtnRecord.set('INOUT_P', record['PURCHASE_P']);
													rtnRecord.set('ORDER_UNIT_P', record['PURCHASE_P']);
													rtnRecord.set('SALES_TYPE', record['SALES_TYPE']);
													rtnRecord.set('PURCHASE_TYPE', record['PURCHASE_TYPE']);
													rtnRecord.set('ORDER_UNIT_FOR_O', record['PURCHASE_P'] * rtnRecord.get('ORDER_UNIT_Q'));
													rtnRecord.set('INOUT_FOR_P', record['PURCHASE_P']);
													rtnRecord.set('INOUT_FOR_O', record['PURCHASE_P'] * rtnRecord.get('ORDER_UNIT_Q'));
													rtnRecord.set('ORDER_UNIT_I', record['PURCHASE_P'] * rtnRecord.get('ORDER_UNIT_Q'));
													
													var param = {"COMP_CODE": rtnRecord.get('COMP_CODE'),
																"ITEM_CODE": rtnRecord.get('ITEM_CODE'),
																"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE'),
																"ORDER_UNIT_P": record['PURCHASE_P'],
																"ORDER_UNIT_Q" : rtnRecord.get('ORDER_UNIT_Q')
																};
																
												mrt100ukrvService.fnGetCalcTaxAmt(param, function(provider, response)	{
													if(!Ext.isEmpty(provider)){
													rtnRecord.set('INOUT_I', provider['INOUT_I']);
													rtnRecord.set('INOUT_TAX_AMT', provider['INOUT_TAX_AMT']);
													rtnRecord.set('INOUT_TOTAL_I', provider['INOUT_TOTAL_I']);//record.get('ORDER_UNIT_I') + record.get('INOUT_TAX_AMT'));
													

													}
													});
				
													
	//												if(i==0) { 
	//													masterGrid.setLotData(record,false);
	//												} 
												}); 
											},
										scope: this
										},
										'onClear': function(type) {
											/*	
											rtnRecord.set('LOT_NO', '');
											rtnRecord.set('LOT_ASSIGNED_YN', 'N');
											rtnRecord.set('TEMP_ORDER_UNIT_Q', '');
											rtnRecord.set('PURCHASE_RATE', 0);
											rtnRecord.set('ORDER_UNIT_FOR_P', 0);
											rtnRecord.set('INOUT_P', 0);
											rtnRecord.set('ORDER_UNIT_P', 0);
											rtnRecord.set('SALES_TYPE', '');
											rtnRecord.set('PURCHASE_TYPE', '');
											
											rtnRecord.set('ITEM_CODE', '');*/
											var rtnRecord = masterGrid.uniOpt.currentRecord;
											
											rtnRecord.set('LOT_ASSIGNED_YN' 	, rtnRecord.get('LOT_ASSIGNED_YN_DUMMY'));
											rtnRecord.set('PURCHASE_RATE' 		, rtnRecord.get('PURCHASE_RATE_DUMMY'));
											rtnRecord.set('ORDER_UNIT_FOR_P'  	, rtnRecord.get('ORDER_UNIT_FOR_P_DUMMY'));
											rtnRecord.set('INOUT_P' 			, rtnRecord.get('INOUT_P_DUMMY'));
											rtnRecord.set('ORDER_UNIT_P' 		, rtnRecord.get('ORDER_UNIT_P_DUMMY'));
											rtnRecord.set('SALES_TYPE' 			, rtnRecord.get('SALES_TYPE_DUMMY'));
											rtnRecord.set('PURCHASE_TYPE' 		, rtnRecord.get('PURCHASE_TYPE_DUMMY'));
											rtnRecord.set('ORDER_UNIT_FOR_O'  	, rtnRecord.get('ORDER_UNIT_FOR_O_DUMMY'));
											rtnRecord.set('INOUT_FOR_P'  		, rtnRecord.get('INOUT_FOR_P_DUMMY'));
											rtnRecord.set('INOUT_FOR_O'  		, rtnRecord.get('INOUT_FOR_O_DUMMY'));
											rtnRecord.set('ORDER_UNIT_I'  		, rtnRecord.get('ORDER_UNIT_I_DUMMY'));
											rtnRecord.set('INOUT_I' 			, rtnRecord.get('INOUT_I_DUMMY'));
											rtnRecord.set('INOUT_TAX_AMT' 		, rtnRecord.get('INOUT_TAX_AMT_DUMMY'));
											rtnRecord.set('INOUT_TOTAL_I' 		, rtnRecord.get('INOUT_TOTAL_I_DUMMY'));
//											rtnRecord.set('LOT_ASSIGNED_YN', 'N');
//											masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
											
										},
										applyextparam: function(popup){
											var record = masterGrid.getSelectedRecord();
											var divCode = masterForm.getValue('DIV_CODE');
											var customCode = masterForm.getValue('CUSTOM_CODE'); 
											var customName = masterForm.getValue('CUSTOM_NAME'); 
											var itemCode = record.get('ITEM_CODE');
											var itemName = record.get('ITEM_NAME');
											var whCode = record.get('WH_CODE');
											var whCellCode = record.get('WH_CELL_CODE');
											var stockYN = 'Y'
											popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode, 'S_WH_CELL_CODE': whCellCode, 'S_CUSTOM_CODE': customCode, 'S_CUSTOM_NAME': customName, 'STOCK_YN': stockYN});
										}									
									}
							})				  
					  },
               		 { dataIndex: 'ITEM_ACCOUNT'      , 	width:66, hidden: true},
               		 { dataIndex: 'SPEC'              , 	width:133, hidden: true},
               		 { dataIndex: 'ORDER_UNIT'        , 	width:66, hidden: true},
               		 
               		 { dataIndex: 'PURCHASE_TYPE'	  ,		width:66, align: 'center'},
               		 { dataIndex: 'SALES_TYPE'		  ,		width:66, align: 'center'},
               		 
               		
               		 { dataIndex: 'ITEM_STATUS'       , 	width:80, hidden: true},
               		 { dataIndex: 'ORIGINAL_Q'        , 	width:66, hidden: true},
               		 { dataIndex: 'GOOD_STOCK_Q'      , 	width:66},
               		 { dataIndex: 'BAD_STOCK_Q'       , 	width:66, hidden: true},
               		 { dataIndex: 'NOINOUT_Q'         , 	width:66, hidden: true},
               		 { dataIndex: 'PRICE_YN'          , 	width:66, hidden: true},
               		 { dataIndex: 'MONEY_UNIT'        , 	width:66, hidden: true},
               		 { dataIndex: 'INOUT_FOR_P'       , 	width:66, hidden: true},
               		 { dataIndex: 'INOUT_FOR_O'       , 	width:66, hidden: true},
               		 
               		 { dataIndex: 'SALE_BASIS_P'	  ,		width:66},
               		 { dataIndex: 'PURCHASE_RATE'	  ,		width:66},
               		 { dataIndex: 'ORDER_UNIT_FOR_P'  , 	width:120},
               		 { dataIndex: 'ORDER_UNIT_Q'      , 	width:102,summaryType: 'sum'},
               		 { dataIndex: 'ORDER_UNIT_FOR_O'  , 	width:116,summaryType: 'sum'},
               		 
               		 { dataIndex: 'INOUT_P'           , 	width:88, hidden: true},
               		 {dataIndex: 'TAX_TYPE' 		   		, width:80 ,align:'center'},
               		 { dataIndex: 'INOUT_I'           , 	width:66,summaryType: 'sum'},
               		 { dataIndex: 'INOUT_TAX_AMT'  	  , 	width:88,summaryType: 'sum'},
					 { dataIndex: 'INOUT_TOTAL_I'  	  , 	width:88,summaryType: 'sum'},	
               		 { dataIndex: 'ACCOUNT_YNC'       , 	width:66},
               		 { dataIndex: 'EXCHG_RATE_O'      , 	width:62, hidden: true},
//               		 { dataIndex: 'INOUT_P'           , 	width:66, hidden: true},
//               		 { dataIndex: 'INOUT_I'           , 	width:66, hidden: true},
               		 { dataIndex: 'ORDER_UNIT_P'      , 	width:88, hidden: true},
               		 { dataIndex: 'ORDER_UNIT_I'      , 	width:100, hidden: true},
               		 { dataIndex: 'STOCK_UNIT'        , 	width:80, hidden: true},
               		 { dataIndex: 'TRNS_RATE'         , 	width:80, hidden: true},
               		 { dataIndex: 'INOUT_Q'           , 	width:124, hidden: true},
               		 { dataIndex: 'ORDER_TYPE'        , 	width:60, hidden: true},
               		 { dataIndex: 'LC_NUM'            , 	width:100, hidden: true},
               		 { dataIndex: 'BL_NUM'            , 	width:66, hidden: true},
               		 { dataIndex: 'ORDER_NUM'         , 	width:133, hidden: true},
               		 { dataIndex: 'ORDER_SEQ'         , 	width:33, hidden: true},
               		 { dataIndex: 'ORDER_Q'           , 	width:100, hidden: true},
               		 { dataIndex: 'INOUT_CODE_TYPE'   , 	width:33, hidden: true},
               		 { dataIndex: 'DEPT_CODE'         , 	width:66, hidden: true},
               		 { dataIndex: 'WH_CODE'           , 	width:66, hidden: true},
               		 { dataIndex: 'WH_CELL_CODE'	  , 	width:166, hidden: true},
               		 { dataIndex: 'WH_CELL_NAME'	  , 	width:166, hidden: true},
               		 { dataIndex: 'INOUT_DATE'        , 	width:73, hidden: true},
               		 { dataIndex: 'INOUT_PRSN'        , 	width:33, hidden: true},
               		 { dataIndex: 'ACCOUNT_Q'         , 	width:33, hidden: true},
               		 { dataIndex: 'CREATE_LOC'        , 	width:33, hidden: true},
               		 { dataIndex: 'SALE_C_DATE'       , 	width:33, hidden: true},
               		 { dataIndex: 'REMARK'            , 	width:250},
               		 { dataIndex: 'PROJECT_NO'        , 	width:133, hidden: true},
               		 { dataIndex: 'INOUT_TYPE'        , 	width:33, hidden: true},
               		 { dataIndex: 'INOUT_CODE'        , 	width:66, hidden: true},
               		 { dataIndex: 'DIV_CODE'          , 	width:33, hidden: true},
               		 { dataIndex: 'CUSTOM_NAME'       , 	width:100, hidden: true},
               		 { dataIndex: 'COMPANY_NUM'       , 	width:88, hidden: true},
               		 { dataIndex: 'INSTOCK_Q'         , 	width:66, hidden: true},
               		 { dataIndex: 'SALE_DIV_CODE'     , 	width:66, hidden: true},
               		 { dataIndex: 'SALE_CUSTOM_CODE'  , 	width:66, hidden: true},
               		 { dataIndex: 'BILL_TYPE'         , 	width:66, hidden: true},
               		 { dataIndex: 'SALE_TYPE'         , 	width:66, hidden: true},
               		 { dataIndex: 'UPDATE_DB_USER'    , 	width:66, hidden: true},
               		 { dataIndex: 'UPDATE_DB_TIME'    , 	width:66, hidden: true},
               		 { dataIndex: 'EXCESS_RATE'       , 	width:66, hidden: true},
               		 { dataIndex: 'INSPEC_NUM'        , 	width:66, hidden: true},
               		 { dataIndex: 'INSPEC_SEQ'        , 	width:66, hidden: true},
               		 { dataIndex: 'COMP_CODE'         , 	width:66, hidden: true},
               		 { dataIndex: 'BASIS_NUM'         , 	width:66, hidden: true},
               		 { dataIndex: 'BASIS_SEQ'         , 	width:66, hidden: true},
               		 { dataIndex: 'SCM_FLAG_YN'       , 	width:66, hidden: true},
               		 { dataIndex: 'LOT_ASSIGNED_YN'	  ,		width:66, hidden: true },
//               		 { dataIndex: 'TEMP_ORDER_UNIT_Q' ,		width:66, hidden: true },
               		 { dataIndex: 'RETURN_NUM' 		  ,		width:66, hidden: true },
               		 { dataIndex: 'RETURN_SEQ' 		  ,		width:66, hidden: true }
               		 
        ],
        listeners: {
        	afterrender: function(masterGrid) {	
					    	var me = this;
					    	this.contextMenu = Ext.create('Ext.menu.Menu', {});
					     	this.contextMenu.add({	
									text: '상품정보 등록',   iconCls : '',
							        handler: function(menuItem, event) {	
							        	var records = masterGrid.getSelectionModel().getSelection();
							         	var record = records[0];
										var params = {
											appId: UniAppManager.getApp().id,
											sender: me,
											action: 'new',
//											_EXCEL_JOBID: excelWindow.jobID,			
//											_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'),	
											ITEM_CODE: record.get('ITEM_CODE'),
											DIV_CODE: record.get('DIV_CODE')
										}
										var rec = {data : {prgID : 'bpr101ukrv', 'text':''}};									
										parent.openTab(rec, '/base/bpr101ukrv.do', params);														
							                	}
							});
							this.contextMenu.add({	
									text: '도서정보 등록',   iconCls : '',
							        handler: function(menuItem, event) {	
							        	var records = masterGrid.getSelectionModel().getSelection();
							         	var record = records[0];
										var params = {
											appId: UniAppManager.getApp().id,
											sender: me,
											action: 'newB',
//											_EXCEL_JOBID: excelWindow.jobID,			
//											_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'),	
											ITEM_CODE: record.get('ITEM_CODE'),
											DIV_CODE: record.get('DIV_CODE')
										}
										var rec = {data : {prgID : 'bpr102ukrv', 'text':''}};									
										parent.openTab(rec, '/base/bpr102ukrv.do', params);														
							                	}
							});
						   /* me.on('cellcontextmenu', function( view, cell, cellIndex, record, row, rowIndex, event ) {
					        	event.stopEvent();
					        	if(record.get('ITEM_CODE') == '')
								me.contextMenu.showAt(event.getXY());
							});*/
						},
						
		beforeedit : function( editor, e, eOpts ) {
			if (UniUtils.indexOf(e.field, 'LOT_NO')){
				if(Ext.isEmpty(e.record.data.ITEM_CODE)){
					alert(Msg.sMS003);
					return false;
				}
			}
			if(e.record.data.ACCOUNT_Q != '0'){
				return false;
			}
			if(!Ext.isEmpty(e.record.data.INOUT_NUM)){
				if(e.record.phantom == false){
//					return true;
					if(UniUtils.indexOf(e.field, ['ORDER_UNIT_Q','REMARK'])){
						return true;
					}else{
						return false;
					}
				}else{
					if(UniUtils.indexOf(e.field, [/*'INOUT_SEQ',*/'INOUT_TYPE_DETAIL','ITEM_CODE','ITEM_NAME'/*,'PURCHASE_RATE','ORDER_UNIT_FOR_P'*/,'ORDER_UNIT_Q','REMARK', 'LOT_NO', 'PURCHASE_TYPE', 'SALES_TYPE'])){
						return true;
					}else{
						return false;
					}	
				}
			}else{
				if(UniUtils.indexOf(e.field, [/*'INOUT_SEQ',*/'INOUT_TYPE_DETAIL','ITEM_CODE','ITEM_NAME'/*,'PURCHASE_RATE','ORDER_UNIT_FOR_P'*/,'ORDER_UNIT_Q','REMARK','LOT_NO', 'PURCHASE_TYPE', 'SALES_TYPE' ])){
						return true;
					}else{
						return false;
					}	
			}
			
		/*	if(!Ext.isEmpty(e.record.data.ORDER_NUM)){
				if(e.record.phantom){
					if(e.record.ORDER_TYPE == '3'){
						if(e.field == 'BL_NUM') return true;
					}else{
						if(e.field == 'BL_NUM') return false;
					}
					if(e.field == 'EXCHG_RATE_O')return true;
					if(e.field == 'MONEY_UNIT')return true;
					if(e.field == 'ACCOUNT_YNC')return true;
					if(e.field == 'ORDER_UNIT_Q')return true;
					if(e.field == 'INOUT_TYPE_DETAIL')return true;
					if(e.field == 'ITEM_STATUS')return true;
					if(e.field == 'INOUT_SEQ')return true;
					if(e.field == 'INOUT_I')return true;
					if(e.field == 'INOUT_P')return true;
					if(e.field == 'PRICE_YN')return true;
					if(e.field == 'LOT_NO')return true;
					if(e.field == 'ORDER_UNIT_P')return true;
					if(e.field == 'ORDER_UNIT_I')return true;
					if(e.field == 'ORDER_UNIT_FOR_P')return true;
					if(e.field == 'ORDER_UNIT_FOR_O')return true;
					if(e.field == 'REMARK')return true;
					if(e.field == 'PROJECT_NO')return true;
					if(e.field == 'TRANS_COST')return true;
					if(e.field == 'TARIFF_AMT')return true;
					else{
						return false;
					}
				}
			}else{
				if(e.record.phantom){
					if(e.record.ORDER_TYPE == '3'){
						if(e.field == 'BL_NUM') return true;
					}else{
						if(e.field == 'BL_NUM') return false;
					}
					if(e.record.phantom){
						if(e.field == 'ITEM_CODE') return true;
						if(e.field == 'ITEM_NAME') return true;
						if(e.field == 'INOUT_METH') return true;
						if(e.field == 'WH_CODE') return true;
						if(e.field == 'WH_CELL_CODE') return true;
						if(e.field == 'ORDER_TYPE') return true;
						if(e.field == 'INOUT_SEQ') return true;
					}else{
						if(e.field == 'ITEM_CODE') return false;
						if(e.field == 'ITEM_NAME') return false;
						if(e.field == 'INOUT_METH') return false;
						if(e.field == 'WH_CODE') return false;
						if(e.field == 'WH_CELL_CODE') return false;
						if(e.field == 'ORDER_TYPE') return false;
						if(e.field == 'INOUT_SEQ') return false;
					}
					if(e.field == 'ORDER_UNIT_P')return true;
					if(e.field == 'ORDER_UNIT_I')return true;
					if(e.field == 'ORDER_UNIT_FOR_P')return true;
					if(e.field == 'ORDER_UNIT_FOR_O')return true;
					if(e.field == 'ORDER_UNIT')return true;
					if(e.field == 'REMARK')return true;
					if(e.field == 'PROJECT_NO')return true;
					if(e.field == 'TRANS_COST')return true;
					if(e.field == 'TARIFF_AMT')return true;
					if(e.field == 'LOT_NO')return true;
					if(e.record.data.ORDER_UNIT != e.record.data.STOCK_UNIT){
						if(e.field == 'TRNS_RATE')return true;
					}else{
						if(e.field == 'TRNS_RATE')return false;
					}
				}else{
					return false;
				}
			}
			if(e.record.phantom == false )
				{
					if(e.record.data.RECEIPT_Q == e.record.data.INSPEC_Q)	{
      					if(e.field=='RECEIPT_Q') return false;
      					if(e.field=='LOT_NO') return false;
						if(e.field=='REMARK') return false;
						if(e.field=='RECEIPT_PRSN') return false;
						if(e.field=='PROJECT_NO') return false;
      				}else {
      					if(e.field=='RECEIPT_Q') return true;
      					if(e.field=='LOT_NO') return true;
						if(e.field=='REMARK') return true;
						if(e.field=='RECEIPT_PRSN') return true;
						if(e.field=='PROJECT_NO') return true;
      				}
					if(e.field=='RECEIPT_SEQ') return false;
					if(e.field=='ITEM_CODE') return false;
					if(e.field=='ITEM_NAME') return false;
					if(e.field=='SPEC') return false;
					if(e.field=='ORDER_UNIT') return false;
					if(e.field=='NOT_RECEIPT_Q') return false;
					if(e.field=='INSPEC_Q') return false;
					if(e.field=='ORDER_NUM') return false;
					if(e.field=='ORDER_SEQ') return false;
					if(e.field=='TRADE_FLAG_YN') return false;
				}
				else if(e.record.phantom )	{					
						if(e.field=='LOT_NO') return true;
						if(e.field=='REMARK') return true;
						if(e.field=='RECEIPT_Q') return true;
						if(e.field=='RECEIPT_PRSN') return true;
						if(e.field=='PROJECT_NO') return true;
						if(e.field=='RECEIPT_SEQ') return false;
						if(e.field=='ITEM_CODE') return false;
						if(e.field=='ITEM_NAME') return false;
						if(e.field=='SPEC') return false;
						if(e.field=='ORDER_UNIT') return false;
						if(e.field=='NOT_RECEIPT_Q') return false;
						if(e.field=='INSPEC_Q') return false;
						if(e.field=='ORDER_NUM') return false;
						if(e.field=='ORDER_SEQ') return false;
						if(e.field=='TRADE_FLAG_YN') return false;
      			}*/
			}
		},
        setItemData: function(record, dataClear, grdRecord) {
//       		var grdRecord = this.uniOpt.currentRecord;
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'			, "");
       			grdRecord.set('ITEM_NAME'			, "");
       			grdRecord.set('SPEC'				, ""); 
				grdRecord.set('STOCK_UNIT'			, "");
				grdRecord.set('ORDER_UNIT'			, "");
				grdRecord.set('TRNS_RATE'			, 0);
				grdRecord.set('ITEM_ACCOUNT'		, "");				
				masterForm.setValue('ITEM_CODE'		, "");
				masterForm.setValue('ORDER_UNIT'	, "");
				grdRecord.set('ORDER_UNIT_FOR_P'	, 0);
				grdRecord.set('ORDER_UNIT_P'		, 0);
				grdRecord.set('SALE_BASIS_P'		, 0);
				
				
				grdRecord.set('GOOD_STOCK_Q'		, "");
				grdRecord.set('BAD_STOCK_Q'			, "");
				grdRecord.set('PURCHASE_TYPE'		, "");
				grdRecord.set('SALES_TYPE'			, "");
				grdRecord.set('PURCHASE_RATE'		, "");
				grdRecord.set('TAX_TYPE'			, "");
				
				grdRecord.set('ORDER_UNIT_Q'		, 0);
				grdRecord.set('ORDER_UNIT_FOR_O'	, 0);
				grdRecord.set('INOUT_I'		, 0);
				grdRecord.set('INOUT_TAX_AMT'	, 0);
				grdRecord.set('INOUT_TOTAL_I'	, 0);
				grdRecord.set('INOUT_FOR_P'		, 0);
				grdRecord.set('INOUT_FOR_O'	, 0);
				grdRecord.set('INOUT_P'	, 0);
				grdRecord.set('ORDER_UNIT_I'	, 0);
				grdRecord.set('INOUT_Q'	, 0);
				
				grdRecord.set('RETURN_NUM'	, "");
				grdRecord.set('RETURN_SEQ'	, "");
				
       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);

       			grdRecord.set('SPEC'				, record['SPEC']); 
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
				grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
				grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			//	grdRecord.set('ORDER_UNIT_FOR_P'    , record['ORDER_P']);
				grdRecord.set('SALE_BASIS_P'		, record['SALE_BASIS_P']);
				grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);	
				
				grdRecord.set('ORDER_UNIT_Q'		, 0);
				grdRecord.set('ORDER_UNIT_FOR_O'	, 0);
				grdRecord.set('INOUT_I'		, 0);
				grdRecord.set('INOUT_TAX_AMT'	, 0);
				grdRecord.set('INOUT_TOTAL_I'	, 0);
				grdRecord.set('INOUT_Q'	, 0);
				
				grdRecord.set('RETURN_NUM'	, "");
				grdRecord.set('RETURN_SEQ'	, "");
				
				masterForm.setValue('ITEM_CODE',record['ITEM_CODE']);
				masterForm.setValue('ORDER_UNIT',record['ORDER_UNIT']);
				
				
				var param = {"ITEM_CODE": record['ITEM_CODE'],
							"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE'),
							"DIV_CODE": masterForm.getValue('DIV_CODE'),
							"MONEY_UNIT": masterForm.getValue('MONEY_UNIT'),
							"ORDER_UNIT": masterForm.getValue('ORDER_UNIT'),
							"INOUT_DATE": masterForm.getValue('INOUT_DATE')
				};
					mrt100ukrvService.fnOrderPrice(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
					grdRecord.set('PURCHASE_TYPE', provider['PURCHASE_TYPE']);
					grdRecord.set('SALES_TYPE', provider['SALES_TYPE']);
					grdRecord.set('ORDER_UNIT_FOR_P', provider['ORDER_P']);
					grdRecord.set('ORDER_UNIT_P', (provider['ORDER_P'] * grdRecord.get('EXCHG_RATE_O')));
					grdRecord.set('PURCHASE_RATE', provider['PURCHASE_RATE']);
					grdRecord.set('INOUT_FOR_P', (provider['ORDER_P'] / grdRecord.get('TRNS_RATE')));
					grdRecord.set('INOUT_P', (provider['ORDER_P'] / grdRecord.get('TRNS_RATE') * grdRecord.get('EXCHG_RATE_O')));
					
					}
				})
				
				
//				var param = {"ITEM_CODE": record['ITEM_CODE']};
//					mrt100ukrvService.fnSaleBasisP(param, function(provider, response)	{
//					if(!Ext.isEmpty(provider)){
//					grdRecord.set('SALE_BASIS_P', provider['SALE_BASIS_P']);
//					}
//				})
				
				
				
				
				//UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
       			UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );
       		}
		},
		
		setReturningReceiptData:function(record){
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('ITEM_CODE'			,record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			,record['ITEM_NAME']);
			grdRecord.set('ORDER_UNIT'			,record['ORDER_UNIT']);
			grdRecord.set('LOT_NO'				,record['LOT_NO']);
			grdRecord.set('LOT_ASSIGNED_YN'		,record['LOT_ASSIGNED_YN']);
			grdRecord.set('PURCHASE_TYPE'		,record['PURCHASE_TYPE']);
			grdRecord.set('SALES_TYPE'			,record['SALES_TYPE']);
			grdRecord.set('GOOD_STOCK_Q'		,record['GOOD_STOCK_Q']);
			grdRecord.set('SALE_BASIS_P'		,record['SALE_BASIS_P']);
			grdRecord.set('PURCHASE_RATE'		,record['PURCHASE_RATE']);
			grdRecord.set('ORDER_UNIT_FOR_P'	,record['ORDER_UNIT_FOR_P']);
			grdRecord.set('ORDER_UNIT_Q'		,record['ORDER_UNIT_Q'] - record['RETURN_CONFIRM_Q']);
			grdRecord.set('ORDER_UNIT_FOR_O'	,(record['ORDER_UNIT_Q'] - record['RETURN_CONFIRM_Q']) * record['ORDER_UNIT_FOR_P']);
			grdRecord.set('REMARK'				,record['REMARK']);
			grdRecord.set('INOUT_P'				,record['ORDER_UNIT_FOR_P']);
			grdRecord.set('INOUT_Q'				,record['ORDER_UNIT_Q'] - record['RETURN_CONFIRM_Q']);
			
			grdRecord.set('INOUT_FOR_P'			,record['ORDER_UNIT_FOR_P']);
			grdRecord.set('ORDER_UNIT_P'		,record['ORDER_UNIT_FOR_P']);
			grdRecord.set('INOUT_FOR_O'			,(record['ORDER_UNIT_Q'] - record['RETURN_CONFIRM_Q']) * record['ORDER_UNIT_FOR_P']);
			
			grdRecord.set('INOUT_PRSN'			,record['INOUT_PRSN']);
			
			grdRecord.set('RETURN_NUM'			,record['RETURN_NUM']);
			grdRecord.set('RETURN_SEQ'			,record['RETURN_SEQ']);
			
			grdRecord.set('WH_CODE'				,record['WH_CODE']);
			grdRecord.set('INOUT_CODE'			,record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			,record['CUSTOM_NAME']);
//			grdRecord.set('INOUT_DATE'			,record['RETURN_DATE']);
			grdRecord.set('DEPT_CODE'			,record['DEPT_CODE']);
					
			var param = {"COMP_CODE": UserInfo.compCode,
						 "ITEM_CODE": record['ITEM_CODE'],
						 "CUSTOM_CODE": record['CUSTOM_CODE'],
						 "ORDER_UNIT_P": record['ORDER_UNIT_FOR_P'],
						 "ORDER_UNIT_Q" : record['ORDER_UNIT_Q'] - record['RETURN_CONFIRM_Q']
						};
							
			mrt100ukrvService.fnGetCalcTaxAmt(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
				grdRecord.set('INOUT_I', provider['INOUT_I']);
				grdRecord.set('INOUT_TAX_AMT', provider['INOUT_TAX_AMT']);
				grdRecord.set('INOUT_TOTAL_I', provider['INOUT_TOTAL_I']);
				
				//grdRecord.set('INOUT_P'				, provider['INOUT_I']/ record['NOINOUT_Q']);
				}
			});
			
			var param = {"COMP_CODE": UserInfo.compCode,
						 "ITEM_CODE": record['ITEM_CODE']};
							
			mrt100ukrvService.taxType(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					grdRecord.set('TAX_TYPE', provider['TAX_TYPE']);
				}
			});
			
/*			
			masterForm.setValue('RETURN_CODE'			,record['RETURN_CODE']);
			panelResult2.setValue('RETURN_CODE'			,record['RETURN_CODE']);
			masterForm.setValue('INOUT_PRSN'			,record['INOUT_PRSN']);
			panelResult2.setValue('INOUT_PRSN'			,record['INOUT_PRSN']);
			
			
			masterForm.setValue('DIV_CODE',record['DIV_CODE']);
			masterForm.setValue('DEPT_CODE',record['DEPT_CODE']);
			masterForm.setValue('DEPT_NAME',record['DEPT_NAME']);
			masterForm.setValue('WH_CODE',record['WH_CODE']);
//			masterForm.setValue('INOUT_DATE',returningReceiptSearch.getValue('RETURN_DATE'));
			masterForm.setValue('CUSTOM_CODE',record['CUSTOM_CODE']);
			masterForm.setValue('CUSTOM_NAME',record['CUSTOM_NAME']);
//			masterForm.setValue('RETURN_CODE',returningReceiptSearch.getValue('RETURN_CODE'));
//			masterForm.setValue('INOUT_PRSN',returningReceiptSearch.getValue('INOUT_PRSN'));
			
			panelResult2.setValue('DIV_CODE',record['DIV_CODE']);
			panelResult2.setValue('DEPT_CODE',record['DEPT_CODE']);
			panelResult2.setValue('DEPT_NAME',record['DEPT_NAME']);
			panelResult2.setValue('WH_CODE',record['WH_CODE']);
//			panelResult2.setValue('INOUT_DATE',returningReceiptSearch.getValue('RETURN_DATE'));
			panelResult2.setValue('CUSTOM_CODE2',record['CUSTOM_CODE']);
			panelResult2.setValue('CUSTOM_NAME2',record['CUSTOM_NAME']);
//			panelResult2.setValue('RETURN_CODE',returningReceiptSearch.getValue('RETURN_CODE'));
//			panelResult2.setValue('INOUT_PRSN',returningReceiptSearch.getValue('INOUT_PRSN'));
			*/
		}
    });   
	
    var inoutNoMasterGrid = Unilite.createGrid('mrt100ukrvinoutNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
        // title: '기본',
        layout : 'fit',   
        excelTitle: '반품등록(반품번호검색)',
		store: inoutNoMasterStore,
		uniOpt:{	
			expandLastColumn: false,
			useRowNumberer: false
		},
        columns:  [ 
			{ dataIndex: 'INOUT_NAME'       		    ,  width:166},
			{ dataIndex: 'INOUT_DATE'       		    ,  width:80},
			{ dataIndex: 'INOUT_CODE'       		    ,  width:100,hidden:true},
			{ dataIndex: 'WH_CODE'          		    ,  width:120,align:'center'},
			{ dataIndex: 'WH_CELL_CODE'     		    ,  width:120,hidden:true},
			{ dataIndex: 'DIV_CODE'         		    ,  width:100},
			{ dataIndex: 'DEPT_CODE'         		    ,  width:100,hidden:true},
			{ dataIndex: 'DEPT_NAME'         		    ,  width:100,align:'center'},
			{ dataIndex: 'RETURN_CODE' 	     		    ,  width:100},
			{ dataIndex: 'INOUT_PRSN' 	     		    ,  width:80,align:'center'},
			{ dataIndex: 'INOUT_NUM'        		    ,  width:146},
			{ dataIndex: 'SUM_ORDER_UNIT_Q' 	     	,  width:100},
			{ dataIndex: 'SUM_ORDER_UNIT_FOR_O' 	    ,  width:100},
			{ dataIndex: 'MONEY_UNIT'       		    ,  width:53,hidden:true},
			{ dataIndex: 'EXCHG_RATE_O'     		    ,  width:53,hidden:true},
			{ dataIndex: 'CREATE_LOC'       		    ,  width:53,hidden:true}
		],
        listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				inoutNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
				masterForm.setAllFieldsReadOnly(true);
			     // 	directMasterStore1.fnSumAmountI();
			}
		},
		returnData: function(record)	{
          	if(Ext.isEmpty(record))	{
          		record = this.getSelectedRecord();
          	}
          	masterForm.setValues({
          		'DIV_CODE':record.get('DIV_CODE'),
          		'INOUT_DATE':record.get('INOUT_DATE'), 
          		'INOUT_NUM':record.get('INOUT_NUM'),
          		'WH_CODE':record.get('WH_CODE'),
          		'CUSTOM_CODE':record.get('INOUT_CODE'),
          		'CUSTOM_NAME':record.get('INOUT_NAME'),
          		'EXCHG_RATE_O':record.get('EXCHG_RATE_O'),
          		'MONEY_UNIT':record.get('MONEY_UNIT'),
          		'DEPT_CODE':record.get('DEPT_CODE'),
          		'DEPT_NAME':record.get('DEPT_NAME'),
          		'RETURN_CODE':record.get('RETURN_CODE')
          		});
        //  	UniAppManager.app.fnSumAmountI();
       //   		directMasterStore1.fnSumAmountI();
          	panelResult2.setValues({
          		'DIV_CODE':record.get('DIV_CODE'),
          		/*'INOUT_DATE':record.get('INOUT_DATE'), 
          		'INOUT_NUM':record.get('INOUT_NUM'),
          		'WH_CODE':record.get('WH_CODE'),*/
          		'CUSTOM_CODE2':record.get('INOUT_CODE'),
          		'CUSTOM_NAME2':record.get('INOUT_NAME'),
          		'INOUT_PRSN':record.get('INOUT_PRSN'),
          		'WH_CODE':record.get('WH_CODE'),
          		'INOUT_DATE':record.get('INOUT_DATE'),
          		'INOUT_NUM':record.get('INOUT_NUM'),
          		'DEPT_CODE':record.get('DEPT_CODE'),
          		'DEPT_NAME':record.get('DEPT_NAME'),
          		'RETURN_CODE':record.get('RETURN_CODE')
          	/*	'EXCHG_RATE_O':record.get('EXCHG_RATE_O'),
          		'MONEY_UNIT':record.get('MONEY_UNIT')*/
          		});
          }
    });
    
    var returningReceiptGrid = Unilite.createGrid('mrt100ukrvReturningReceiptGrid', {//반품접수참조
        // title: '기본',
        layout : 'fit',
        excelTitle: '반품등록(반품접수참조)',
    	store: returningReceiptStore,
    	uniOpt: {
    		onLoadSelectFirst: false  
        },
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
        columns:  [  
					 { dataIndex: 'COMP_CODE'                  , 	width:88,hidden:true},        
               		 { dataIndex: 'DIV_CODE'       	           , 	width:88,hidden:true},        
               		 { dataIndex: 'RETURN_SEQ'         	       , 	width:60,align:'center'},
               		 { dataIndex: 'RETURN_NUM'                 , 	width:120,hidden:false},
               		 { dataIndex: 'ITEM_CODE'                  , 	width:120},
               		 { dataIndex: 'ITEM_NAME'                  , 	width:250},        
               		 { dataIndex: 'SPEC'         		       , 	width:88,hidden:true},        
               		 { dataIndex: 'ORDER_UNIT'                 , 	width:88,hidden:true},        
               		 { dataIndex: 'LOT_NO'         	           , 	width:150},        
               		 { dataIndex: 'LOT_ASSIGNED_YN'            , 	width:70,align:'center'},        
               		 { dataIndex: 'PURCHASE_TYPE'              , 	width:80,align:'center'},        
               		 { dataIndex: 'SALES_TYPE'                 , 	width:80,align:'center'},        
               		 { dataIndex: 'GOOD_STOCK_Q'         	   , 	width:88},        
               		 { dataIndex: 'SALE_BASIS_P'               , 	width:88},        
               		 { dataIndex: 'PURCHASE_RATE'              , 	width:88},        
               		 { dataIndex: 'ORDER_UNIT_FOR_P'           , 	width:88},        
               		 { dataIndex: 'ORDER_UNIT_Q'               , 	width:88},
               		 { dataIndex: 'RETURN_CONFIRM_Q'           , 	width:88,hidden:false},
               		 { dataIndex: 'ORDER_UNIT_FOR_O'           , 	width:88},        
               		 { dataIndex: 'REMARK'         	           , 	width:200},
               		 { dataIndex: 'WH_CODE'         	       , 	width:88,hidden:true},
               		 { dataIndex: 'CUSTOM_CODE'         	   , 	width:88,hidden:true},
               		 { dataIndex: 'CUSTOM_NAME'         	   , 	width:88,hidden:true},
               		 { dataIndex: 'RETURN_CODE'         	   , 	width:88,hidden:true},
               		 { dataIndex: 'INOUT_PRSN'         	   	   , 	width:88,hidden:true},
               		 { dataIndex: 'RETURN_DATE'         	   , 	width:88,hidden:true},
               		 { dataIndex: 'DEPT_CODE'         	  	   , 	width:88,hidden:true},
               		 { dataIndex: 'DEPT_NAME'         	  	   , 	width:88,hidden:true}
		], 
		listeners: {	
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function()	{
       		//var records = this.getSelectedRecords();
       		var records = this.sortedSelectedRecords(this);
       		
			Ext.each(records, function(record,i){	
							        	UniAppManager.app.onNewDataButtonDown();
							        	masterGrid.setReturningReceiptData(record.data);								        
								    }); 
			this.getStore().remove(records);
       	}
    });
    
    function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '반품번호검색',
                width: 1150,				                
                height: 380,
                layout: {type:'vbox', align:'stretch'},	                
                items: [inoutNoSearch, inoutNoMasterGrid], //inoutNoDetailGrid],
                tbar:  ['->',
			        {	
			        	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							inoutNoMasterStore.loadStoreRecords();
						},
						disabled: false
					}, {
						itemId : 'inoutNoCloseBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
		    ],
				listeners : {
					beforehide: function(me, eOpt)	{
						inoutNoSearch.clearForm();
						inoutNoMasterGrid.reset();
						//inoutNoDetailGrid.reset();	                							
					},
					 beforeclose: function( panel, eOpts )	{
						inoutNoSearch.clearForm();
						inoutNoMasterGrid.reset();
						//inoutNoDetailGrid.reset();
		 			},
					 show: function( panel, eOpts )	{
			    		inoutNoSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
				 		inoutNoSearch.setValue('INOUT_DATE_FR',UniDate.get('startOfMonth', masterForm.getValue('INOUT_DATE')));
				 		inoutNoSearch.setValue('INOUT_DATE_TO',masterForm.getValue('INOUT_DATE'));
				 		inoutNoSearch.setValue('WH_CODE',masterForm.getValue('WH_CODE'));
				 		inoutNoSearch.setValue('CUSTOM_CODE',masterForm.getValue('CUSTOM_CODE'));
				 		inoutNoSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
				 		inoutNoSearch.setValue('INOUT_PRSN',masterForm.getValue('INOUT_PRSN'));
				 		inoutNoSearch.setValue('DEPT_CODE',masterForm.getValue('DEPT_CODE'));
				 		inoutNoSearch.setValue('DEPT_NAME',masterForm.getValue('DEPT_NAME'));
//				 		inoutNoSearch.setValue('RETURN_CODE',masterForm.getValue('RETURN_CODE'));
				 		
			    	/*	inoutNoSearch.setValue('ORDER_PRSN',masterForm.getValue('ORDER_PRSN'));
			    		inoutNoSearch.setValue('CUSTOM_CODE',masterForm.getValue('CUSTOM_CODE'));
			    		inoutNoSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
			    		inoutNoSearch.setValue('ORDER_TYPE',masterForm.getValue('ORDER_TYPE'));
			    		*/
					 }
                }		
			})
		}
		SearchInfoWindow.show();
		SearchInfoWindow.center();
    }
    function openReturningReceiptWindow() {    		//반품접수참조
  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		
  		
  		
  		
//  		returningReceiptStore.loadStoreRecords(); 
		if(!referReturningReceiptWindow) {
			referReturningReceiptWindow = Ext.create('widget.uniDetailWindow', {
                title: '반품접수참조',
                width: 1100,				                
                height: 350,
                layout:{type:'vbox', align:'stretch'},
                items: [returningReceiptSearch, returningReceiptGrid],
                tbar:  ['->',
					{	
						itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							returningReceiptStore.loadStoreRecords();
						},
						disabled: false
					},{	
						itemId : 'confirmBtn',
						text: '접수적용',
						handler: function() {
							returningReceiptGrid.returnData();
						},
						disabled: false
					},{	
						itemId : 'confirmCloseBtn',
						text: '접수적용 후 닫기',
						handler: function() {
							returningReceiptGrid.returnData();
							referReturningReceiptWindow.hide();
							returningReceiptGrid.reset();
							returningReceiptSearch.clearForm();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							referReturningReceiptWindow.hide();
							returningReceiptGrid.reset();
							returningReceiptSearch.clearForm();
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{
						//orderSearch.clearForm();
						//orderGrid.reset();
					},
		 			beforeclose: function( panel, eOpts )	{
						//orderSearch.clearForm();
						//orderGrid.reset();
		 			},
				/*	beforeshow: function ( me, eOpts )	{
						returningReceiptSearch.setValue('DIV_CODE', masterForm.getValue('DIV_CODE'));
				  		returningReceiptSearch.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
				  		returningReceiptSearch.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
				  		returningReceiptSearch.setValue('WH_CODE', masterForm.getValue('WH_CODE'));
				  		returningReceiptSearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
				  		returningReceiptSearch.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
				  		returningReceiptSearch.setValue('RETURN_DATE', masterForm.getValue('INOUT_DATE'));
				  		returningReceiptSearch.setValue('RETURN_CODE', masterForm.getValue('RETURN_CODE'));
				  		returningReceiptSearch.setValue('INOUT_PRSN', masterForm.getValue('INOUT_PRSN'));
						
//		 				orderStore.loadStoreRecords();
		 			},*/
		 			
		 			show: function ( panel, eOpts )	{
						returningReceiptSearch.setValue('DIV_CODE', masterForm.getValue('DIV_CODE'));
				  		returningReceiptSearch.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
				  		returningReceiptSearch.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
				  		returningReceiptSearch.setValue('WH_CODE', masterForm.getValue('WH_CODE'));
				  		returningReceiptSearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
				  		returningReceiptSearch.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
				  		returningReceiptSearch.setValue('RETURN_DATE', masterForm.getValue('INOUT_DATE'));
				  		returningReceiptSearch.setValue('RETURN_CODE', masterForm.getValue('RETURN_CODE'));
				  		returningReceiptSearch.setValue('INOUT_PRSN', masterForm.getValue('INOUT_PRSN'));
						
//		 				orderStore.loadStoreRecords();
		 			}
		 			
				}
			})
		}
		referReturningReceiptWindow.center();
		referReturningReceiptWindow.show();
    }
    
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult2/*, panelResult*/
			]	
		},
			masterForm
		],
		id  : 'mrt100ukrvApp',
		fnInitBinding: function(){
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','newData','print', 'prev', 'next'], true);
			this.setDefault();
			/*masterForm.setValue('DEPT_CODE',UserInfo.deptCode);
			masterForm.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult2.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult2.setValue('DEPT_NAME',UserInfo.deptName);*/
//			masterForm.setValue('INOUT_PRSN',BsaCodeInfo.gsInOutPrsn);
//			panelResult2.setValue('INOUT_PRSN',BsaCodeInfo.gsInOutPrsn);
			/*mrt100ukrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('WH_CODE',provider['WH_CODE']);
					panelResult2.setValue('WH_CODE',provider['WH_CODE']);
				}
			});*/
			
		},
		onQueryButtonDown: function() {         
			masterForm.setAllFieldsReadOnly(false);
			var inoutNo = masterForm.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow() 
			} else {
			//	var param= masterForm.getValues();
			//	masterForm.getForm().load({params: param})
				directMasterStore1.loadStoreRecords();	
				masterForm.setAllFieldsReadOnly(true);
				panelResult2.setAllFieldsReadOnly(true);
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
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				 var accountYnc = 'Y';
				 var inoutNum = masterForm.getValue('INOUT_NUM');
				 var seq = directMasterStore1.max('INOUT_SEQ');
            	 if(!seq){
            	 	seq = 1;
            	 }else{
            	 	seq += 1;
            	 }
				 var sortSeq = directMasterStore1.max('SORT_SEQ');
            	 if(!sortSeq){
            	 	sortSeq = 1;
            	 }else{
            	 	sortSeq += 1;
            	 }
            	 var inoutType = '4';
            	 var inoutCodeType = '4';
            	 var whCode = masterForm.getValue('WH_CODE');
            	 var whCellCode = masterForm.getValue('WH_CELL_CODE');
            	 var inoutPrsn = masterForm.getValue('INOUT_PRSN');
            	 var inoutCode = masterForm.getValue('CUSTOM_CODE');
            	 var customName = masterForm.getValue('CUSTOM_NAME');
            	 var createLoc = '2';
            	 var inoutDate = masterForm.getValue('INOUT_DATE');
            	 var inoutMeth = '1';
            	 var inoutTypeDetail = gsInoutTypeDetail; //gsInoutTypeDetail ?? 확인필요
            	 var itemStatus = '1';
            	 var accountQ = '0';
            	 var orderUnitQ = '0';
            	 var inoutQ = '0';
            	 var inoutI = '0';
            	 var moneyUnit = masterForm.getValue('MONEY_UNIT');
            	 var inoutP = '0';
            	 var inoutForP = '0';
            	 var inoutForO = '0';
            	 var originalQ = '0';
            	 var noinoutQ = '0';
            	 var goodStockQ ='0';
            	 var badStockQ = '0';
            	 var exchgRateO = masterForm.getValue('EXCHG_RATE_O');
            	 var trnsRate = '1';
            	 var divCode = masterForm.getValue('DIV_CODE');
            	 var companyNum = BsaCodeInfo.gsCompanyNum // ??확인필요
            	 var saleDivCode = '*';
            	 var saleCustomCode = '*';
            	 var saleType = '*';
            	 var billType = '*';
            	 var priceYn = 'Y';
            	 var excessRate = '0';
            	 var orderType = '1';
            	 var transCost = '0';
            	 var tariffAmt = '0';
            	 var deptCode = masterForm.getValue('DEPT_CODE');
				 var compCode = UserInfo.compCode;
            	 
           // 	 var compCode =  ??확인 필요
            	 
            	 
            	 var r = {
            	 	ACCOUNT_YNC: 		accountYnc,
            	 	INOUT_TYPE:         inoutType,
            	 	INOUT_CODE_TYPE:    inoutCodeType,
            	 	WH_CODE:            whCode,
            	 	WH_CELL_CODE:       whCellCode,
            	 	INOUT_PRSN:         inoutPrsn,
            	 	INOUT_CODE:         inoutCode, 
            	 	CUSTOM_NAME:        customName, 
            	 	CREATE_LOC:         createLoc, 
            	 	INOUT_DATE:         inoutDate, 
            	 	INOUT_METH:         inoutMeth, 
            	 	INOUT_TYPE_DETAIL:  inoutTypeDetail, 
            	 	ITEM_STATUS:        itemStatus, 
            	 	ACCOUNT_Q:          accountQ,  
            	 	ORDER_UNIT_Q:       orderUnitQ, 
            	 	INOUT_Q:            inoutQ,  
            	 	INOUT_I:            inoutI, 
            	 	MONEY_UNIT:         moneyUnit, 
            	 	INOUT_P:            inoutP,
            	 	INOUT_FOR_P:        inoutForP, 
            	 	INOUT_FOR_O:        inoutForO, 
            	 	ORIGINAL_Q:         originalQ,  
            	 	NOINOUT_Q:          noinoutQ, 
            	 	GOOD_STOCK_Q:       goodStockQ, 
            	 	BAD_STOCK_Q:        badStockQ, 
            	 	EXCHG_RATE_O:       exchgRateO,
            	 	TRNS_RATE:          trnsRate, 
            	 	DIV_CODE:           divCode, 
            	 	COMPANY_NUM:        companyNum, 
            	 	SALE_DIV_CODE:      saleDivCode, 
            	 	SALE_CUSTOM_CODE:   saleCustomCode, 
            	 	SALE_TYPE:          saleType, 
            	 	BILL_TYPE:          billType,   
            	 	PRICE_YN:           priceYn,  
            	 	EXCESS_RATE:        excessRate,  
            	 	ORDER_TYPE:         orderType, 
            	 	TRANS_COST:         transCost, 
            	 	TARIFF_AMT:         tariffAmt,
            	// 	COMP_CODE:
					INOUT_NUM: inoutNum,
					INOUT_SEQ: seq,
					SORT_SEQ: sortSeq, 
					DEPT_CODE: deptCode,
					COMP_CODE: compCode
		        };
				masterGrid.createRow(r);
				masterForm.setAllFieldsReadOnly(true);
				panelResult2.setAllFieldsReadOnly(true);
			},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult2.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult2.clearForm();
			panelResult.clearForm();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		
		onSaveDataButtonDown: function(config) {				
			directMasterStore1.saveStore();
		},
		
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				
				
				masterGrid.deleteSelectedRow();
				
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('ACCOUNT_Q') != 0)
				{
					alert('<t:message code="unilite.msg.sMM008"/>');
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
						if(record.get('ACCOUNT_Q') != 0)
							{
								alert('<t:message code="unilite.msg.sMM008"/>');
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
		checkForNewDetail:function() { 
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('INOUT_NUM')))	{
				alert('<t:message code="unilite.msg.sMS533" default="반품번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}
			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return masterForm.setAllFieldsReadOnly(true);
        },
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('searchForm').getValues();
	
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/mrt/mrt100rkrPrint.do',
	            prgID: 'mrt100rkr',
	               extParam: {
	                  INOUT_NUM : param.INOUT_NUM,
	                  DIV_CODE  : param.DIV_CODE
	               }
	            });
	            win.center();
	            win.show();
	               
	      },
		setDefault: function() {
			
        	masterForm.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult2.setValue('DIV_CODE',UserInfo.divCode);
        	masterForm.setValue('INOUT_DATE',new Date());
        	panelResult2.setValue('INOUT_DATE',new Date());
        	masterForm.setValue('CREATE_LOC','1');
//        	panelResult2.setValue('CREATE_LOC','1');
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
			var field = masterForm.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult2.getField('INOUT_PRSN');			
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");	
			field = inoutNoSearch.getField('INOUT_PRSN');			
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
		},
		
 		fnInTypeAccountYN:function(subCode){
 			var fRecord ='';
        	Ext.each(BsaCodeInfo.gsInTypeAccountYN, function(item, i)	{
        		if(item['codeNo'] == subCode && !Ext.isEmpty(item['refCode4'])) {
        			fRecord = item['refCode4'];
        		}
        	});
        	if(Ext.isEmpty(fRecord)){
        		fRecord = 'N'
        	}
        	return fRecord;
        },
        cbStockQ: function(provider, params)	{  
	    	var rtnRecord = params.rtnRecord;
			
			//var dStockQ = Unilite.nvl(provider['STOCK_Q'], 0);
			//var dOrderQ = Unilite.nvl(rtnRecord.get('ORDER_Q'), 0);
			//var lTrnsRate = rtnRecord.get('TRANS_RATE');
			
	    	var dGoodStockQ = provider['GOOD_STOCK_Q'];
	    	var dBadStockQ = provider['BAD_STOCK_Q'];
			rtnRecord.set('GOOD_STOCK_Q', dGoodStockQ);
			rtnRecord.set('BAD_STOCK_Q', dBadStockQ);
	    }
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
					
				case "INOUT_SEQ" :
					if(newValue != ''){
						if(newValue <= 0){
							rv='<t:message code="unilite.msg.sMB076"/>';
							break;
						}
//						else if(clng(grdsheet1.TextMatrix(lRow,lCol)) != fnCDbl(grdsheet1.TextMatrix(lRow,lCol))){ //?
//							rv='<t:message code="unilite.msg.sMB087"/>';
//						}
					}
					
				case "ITEM_CODE" :
					if(record.get('ACCOUNT_YNC') == 'N'){
						record.set('PRICE_YN','N');
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
						
						directMasterStore1.fnSumAmountI();
					}
					break;
				case "ITEM_NAME" :
					if(record.get('ACCOUNT_YNC') == 'N'){
						record.set('PRICE_YN','N');
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
						
						directMasterStore1.fnSumAmountI();
					}
					break;
				case "ORDER_UNIT_Q" :	//입고량
					if(newValue != oldValue){		
						if(record.get('ITEM_CODE') == ''){
							rv='<t:message code="unilite.msg.sMM033"/>';
							break;
						}
					}
					/*var order_q = newValue;
					var lot_q = record.get('TEMP_ORDER_UNIT_Q');//로트팝업에서 넘겨받는 수량
					if(!Ext.isEmpty(lot_q) && lot_q!= 0){
						if(order_q > lot_q){
							rv = "반품량은 lot재고량을 초과할 수 없습니다. 현재고: " + lot_q;
							break;
						}
					}*/
					var dInoutQ3 = newValue * record.get('TRNS_RATE');
					
					if(!(newValue < '0')){
						if(record.get('ORDER_NUM') != ''){
							
							//var dTempQ =0;
							var dOrderQ = record.get('ORDER_Q');	//발주량
							var dInoutQ = newValue * record.get('TRNS_RATE');	//입력한 입고량  * 입수
							var dNoInoutQ =  record.get('NOINOUT_Q');	//미입고량
							
							var dEnableQ = (dOrderQ + dOrderQ * record.get('EXCESS_RATE') / 100) / record.get('TRNS_RATE');	
											//(발주량 + 발주량 * 과입고허용률 / 100) / 입수
							var dTempQ = ((dOrderQ - dNoInoutQ + dInoutQ - record.get('ORIGINAL_Q')) / record.get('TRNS_RATE'));
											// ( 발주량 - 미입고량 + (입력한 입고량*입수) - 기존입고량	) / 입수

							if(dNoInoutQ > 0){
								if(dTempQ > dEnableQ){
									 dEnableQ = (dNoInoutQ + record.get('ORIGINAL_Q')) / record.get('TRNS_RATE') + (dEnableQ - (dOrderQ / record.get('TRNS_RATE')));
									//	(미입고량 + 기존입고량) / 입수 + (1100 - 발주량 /입수 )
									rv='<t:message code = "unilite.msg.sMM351"/>' + '<t:message code = "unilite.msg.sMM534"/>' + ":" + dEnableQ;
									break;
								}
							}
						}
					}
					
						
					record.set('INOUT_Q',dInoutQ3);
					
					if(BsaCodeInfo.gsInvstatus == '+'){
						if(record.get('STOCK_CARE_YN') == 'Y'){
							if(newValue < 0){
								var dInoutQ1 = 0;
								var dOriginalQ = 0;
								
								dInoutQ1 = dInoutQ1 + newValue;
								dOriginalQ = dOriginalQ + record.get('ORIGINAL_Q');
								
								if(record.get('ITEM_STATUS') == '1'){
									dStockQ = record.get('GOOD_STOCK_Q');	
								}else{
									dStockQ = record.get('BAD_STOCK_Q');	
								}
								
								if((dStockQ - dOriginalQ) < dInoutQ1 * -1){
									rv='<t:message code = "unilite.msg.sMM349"/>'+" : " + (dStockQ - dOriginalQ) ;
										record.set('INOUT_Q', oldValue);
								}
							}
						}
					}
					
					if(!Ext.isEmpty(record.get('ORDER_UNIT_P')) && record.get('ORDER_UNIT_P') != 0){
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_P') * newValue));	//자사금액= 자사단가 * 입력한입고량
						
						var param = {"COMP_CODE": record.get('COMP_CODE'),
									"ITEM_CODE": record.get('ITEM_CODE'),
									"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE'),
									"ORDER_UNIT_P": record.get('ORDER_UNIT_P'),
									"ORDER_UNIT_Q" : newValue
									};
									
					mrt100ukrvService.fnGetCalcTaxAmt(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
						record.set('INOUT_I', provider['INOUT_I']);
						record.set('INOUT_TAX_AMT', provider['INOUT_TAX_AMT']);
						record.set('INOUT_TOTAL_I', provider['INOUT_TOTAL_I']);//record.get('ORDER_UNIT_I') + record.get('INOUT_TAX_AMT'));
						
//						record.set('INOUT_I',record.get('ORDER_UNIT_I'));	//자사금액(재고) = 자사금액
						}
					});
					//	record.set('ORDER_UNIT_I') = 
				//보류 반올림		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
					}else{
						record.set('ORDER_UNIT_I','0'); 
					}
					
					if(record.get('ORDER_UNIT_FOR_P') != ''){
						record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_FOR_P') * newValue));	//구매금액 = 구매단가 * 입력한 입고량
						//record.set('ORDER_UNIT_FOR_O') = 
				//보류 반올림		Math.round(record.get('ORDER_UNIT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_FOR_O")), top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
						record.set('INOUT_FOR_O',record.get('ORDER_UNIT_FOR_O'));	//재고단위금액  = 구매금액
					}else{
						record.set('ORDER_UNIT_FOR_O','0');
					}

					record.set('INOUT_P',(record.get('ORDER_UNIT_P') / record.get('TRNS_RATE')));	//자사단가(재고) = 자사단가 / 입수
					record.set('INOUT_I',record.get('ORDER_UNIT_I'));	//자사금액(재고) = 자사금액
					record.set('INOUT_FOR_O',record.get('ORDER_UNIT_FOR_O'));	//재고단위금액  = 구매금액  
					
					directMasterStore1.fnSumAmountI();
					
				break;
				case "INOUT_P" :	//자사단가(재고)
					if((record.get('ACCOUNT_YNC')== 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')){
						if(newValue <= 0){
							rv='<t:message code = "unilite.msg.sMM375"/>';
							break;
						}
					}else{
						if(newValue < 0){
							rv='<t:message code = "unilite.msg.sMM376"/>';
							break;
						}
					}
					
					record.set('INOUT_I', (record.get('INOUT_Q') * newValue));	//자사금액(재고) = 재고단위 수량 * 입력한 자사단가(재고)
					//record.set('INOUT_I') = 
			//보류 반올림		Math.round(record.get('INOUT_I'),CustomCodeInfo.gsUnderCalBase);
					//fnRound(grdsheet1.TextMatrix(grdsheet1.Row, grdsheet1.colindex("INOUT_I")),top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
				
                    if(record.get('EXCHG_RATE_O') != 0){
                    	record.set('INOUT_FOR_P',(newValue / record.get('EXCHG_RATE_O')));	//재고단위단가 = 입력한 자사단가(재고) / 환율
                    	record.set('INOUT_FOR_O',(record.get('INOUT_Q') * newValue / record.get('EXCHG_RATE_O')));	//재고단위금액 = 재고단위수량 * 입력한 자사단가(재고) / 환율
                    	//record.set('INOUT_FOR_O') = 
             //보류 반올림       	Math.round(record.get('INOUT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
                    	//fnRound(grdsheet1.TextMatrix(grdsheet1.Row, grdsheet1.colindex("INOUT_FOR_O")),top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
                    }else{
                    	record.set('INOUT_FOR_O','0');
                    	record.set('INOUT_FOR_P','0');
                    }
                    directMasterStore1.fnSumAmountI();
					break;
				case "INOUT_I" :	//자사금액(재고)
					if(newValue < 0){
						rv='<t:message code = "unilite.msg.sMB076"/>';
						break;
					}
                    
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_P',(newValue / record.get('INOUT_Q')));	// 자사단가(재고) = 입력한 자사금액(재고) / 재고단위수량
					}else{
						record.set('INOUT_P','0');	
					}
					
					if(record.get('EXCHG_RATE_O') != 0){
                    	record.set('INOUT_FOR_P',(record.get('INOUT_P') / record.get('EXCHG_RATE_O')));	//재고단위단가 = 자사단가(재고) / 환율
                    	record.set('INOUT_FOR_O',(newValue / record.get('EXCHG_RATE_O')));	//재고단위금액 = 입력한 자사금액(재고) / 환율
                    	//record.set('INOUT_FOR_O' =
           //보류 반올림         	Math.round(record.get('INOUT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
                    	//fnRound(grdsheet1.TextMatrix(grdsheet1.Row, grdsheet1.colindex("INOUT_FOR_O")),top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
                    }else{
                    	record.set('INOUT_FOR_O','0');
                    	record.set('INOUT_FOR_P','0');
                    }
                    directMasterStore1.fnSumAmountI();
					break;
//				case "ORDER_UNIT" :
				case "TRNS_RATE" :	//입수
					if(newValue <= 0){
						rv='<t:message code = "unilite.msg.sMB076"/>';
						break;
					}
					
					if(record.get('ORDER_UNIT_Q') != ''){
						record.set('INOUT_Q',record.get('ORDER_UNIT_Q') * newValue); 	//재고단위수량 = 입고량 * 입력한 입수
					}else{
						record.set('INOUT_Q','0');
					}
					
					
					
					if(record.get('ORDER_UNIT_P') != ''){
						record.set('INOUT_P',(record.get('ORDER_UNIT_P') / newValue));	//자사단가(재고) = 자사단가 / 입력한 입수
					}else{
						record.set('INOUT_P','0');
					}
					
					if(record.get('ORDER_UNIT_FOR_P') != ''){
						record.set('INOUT_FOR_P',(record.get('ORDER_UNIT_FOR_P') / newValue));	//재고단위단가 = 구매단가 / 입력한 입수
					}else{
						record.set('INOUT_FOR_P','0');
					}
					break;
				case "ORDER_UNIT_P":	//자사단가
					if((record.get('ACCOUNT_YNC') == 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')){
						if(newValue <= 0){
							rv='<t:message code = "unilite.msg.sMM375"/>';
							break;
						}					
					}else{
						if(newValue < 0){
							rv='<t:message code = "unilite.msg.sMM376"/>';
							break;
						}
						
					}
					
					record.set('INOUT_P',(newValue / record.get('TRNS_RATE')));	//자사단가(재고) = 입력한 자사단가 / 입수
					record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * newValue));	//자사금액 = 입고량 * 입력한 자사단가
					//record.set('ORDER_UNIT_I') = 
				//보류 반올림	Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
					//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")),top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
                    record.set('INOUT_I',(record.get('ORDER_UNIT_I')));	//자사금액(재고) = 자사금액
                    //record.set('INOUT_I') = 
               //보류 반올림     Math.round(record.get('INOUT_I'),CustomCodeInfo.gsUnderCalBase);
                    //fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("INOUT_I")), top.sWonflag,top.goCnn.GetFSET("M_FSET_IS"));
                    
                    if(record.get('EXCHG_RATE_O') != 0){
                    	record.set('INOUT_FOR_P',(record.get('INOUT_P') / record.get('EXCHG_RATE_O')));	//재고단위단가 = 자사단가(재고)/환율
                    	record.set('ORDER_UNIT_FOR_P',(newValue / record.get('EXCHG_RATE_O')));	//	구매단가 = 입력한 자사단가 / 환율
                    	record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_Q') * newValue / record.get('EXCHG_RATE_O')));	//구매금액 = 입고량 * 입력한 자사단가 / 환율
                    	//record.set('ORDER_UNIT_FOR_O') = 
               //보류 반올림     	Math.round(record.get('ORDER_UNIT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
                    	//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_FOR_O")),top.sWonflag, top.goCnn.GetFSET("M_FSET_OS")); 
                    	
                    	record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
                    	//record.set('INOUT_FOR_O') = 
               //보류 반올림     	Math.round(record.get('INOUT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
                    	//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("INOUT_FOR_O")),top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
                    	
                    }else{
                    	record.set('INOUT_FOR_O','0');
                    	record.set('INOUT_FOR_P','0');
                    	record.set('ORDER_UNIT_FOR_O','0');
                    	record.set('ORDER_UNIT_FOR_P','0');
                    }
                    directMasterStore1.fnSumAmountI();
                    break;
				case "ORDER_UNIT_I" :	//자사금액
					if(record.get('ORDER_UNIT_Q') != ''){
						if((newValue <= 0) && (record.get('ORDER_UNIT_Q') > 0)){
							rv='<t:message code = "unilite.msg.sMB076"/>';
							break;
						}else if((newValue >= 0) && (record.get('ORDER_UNIT_Q') < 0)){
							rv='<t:message code = "unilite.msg.sMB077"/>';
							break;
						}
					}
					
					//record.set('INOUT_I') = 
		//보류 반올림			Math.round(newValue,CustomCodeInfo.gsUnderCalBase);
					//fnRound(grdsheet1.TextMatrix(lRow,lCol), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_P',(record.get('INOUT_I') / record.get('INOUT_Q')));	//자사단가(재고) = 자사금액(재고) / 재고단위수량
						record.set('ORDER_UNIT_P',(newValue / record.get('ORDER_UNIT_Q')));	//자사단가 = 입력한 자사금액 / 입고량
					}else{
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_P','0');
					}
					
					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_P') / record.get('EXCHG_RATE_O')));	//재고단위단가 = 자사단가(재고) / 환율
						record.set('ORDER_UNIT_FOR_P',(record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O')));	//구매단가 = 자사단가 / 환율
						record.set('ORDER_UNIT_FOR_O',(newValue / record.get('EXCHG_RATE_O')));	//구매금액 = 입력한 자사금액 / 환율
						//record.set('ORDER_UNIT_FOR_O') = 
			//보류 반올림			Math.round(record.get('ORDER_UNIT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_FOR_O")),top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
						record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					}else{
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}
                    directMasterStore1.fnSumAmountI();
                    break;
				case "PURCHASE_RATE" :	//매입율& 단가 & 수량 & 판매가 관계 추가
                	record.set("ORDER_UNIT_FOR_P",record.get('SALE_BASIS_P') * newValue / 100);
                	record.set("ORDER_UNIT_FOR_O",(record.get('SALE_BASIS_P') * newValue / 100)* record.get("ORDER_UNIT_Q"));
                	
                	record.set("INOUT_FOR_P",record.get("ORDER_UNIT_FOR_P")/record.get("TRNS_RATE"));
                	record.set("INOUT_FOR_O",record.get("INOUT_FOR_P")*record.get("ORDER_UNIT_Q") * record.get("TRNS_RATE"));
                	
                	record.set("INOUT_P",record.get("ORDER_UNIT_FOR_P") / record.get("TRNS_RATE") * record.get("EXCHG_RATE_O"));
                	record.set("INOUT_I",record.get("INOUT_P") * record.get("ORDER_UNIT_Q") * record.get("TRNS_RATE"));
                	
                	record.set("ORDER_UNIT_P",record.get("ORDER_UNIT_FOR_P") * record.get("EXCHG_RATE_O"));
                	record.set("ORDER_UNIT_I",record.get("ORDER_UNIT_P") * record.get("ORDER_UNIT_Q"));
                	
                	
                	var param = {"COMP_CODE": record.get('COMP_CODE'),
									"ITEM_CODE": record.get('ITEM_CODE'),
									"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE'),
									"ORDER_UNIT_P": record.get('ORDER_UNIT_P'),
									"ORDER_UNIT_Q" : record.get('ORDER_UNIT_Q')
									};
					mrt100ukrvService.fnGetCalcTaxAmt(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
						record.set('INOUT_I', provider['INOUT_I']);
						record.set('INOUT_TAX_AMT', provider['INOUT_TAX_AMT']);
						record.set('INOUT_TOTAL_I', provider['INOUT_TOTAL_I']);//record.get('ORDER_UNIT_I') + record.get('INOUT_TAX_AMT'));

						
						
						}
					});
                    break; 	
				case "ORDER_UNIT_FOR_P":	//구매단가
					if((record.get('ACCOUNT_YNC')== 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')){
						if(newValue <= 0){
							rv='<t:message code = "unilite.msg.sMM375"/>';
							break;
						}
					}else{
						if(newValue < 0){
							rv='<t:message code = "unilite.msg.sMM376"/>';
							break;
						}
						
					}
					record.set("PURCHASE_RATE", newValue / record.get("SALE_BASIS_P") * 100);	//매입율& 단가 & 수량 & 판매가 관계 추가
					//record.set('ORDER_UNIT_FOR_O') = 
		//보류 반올림			Math.round((record.get('ORDER_UNIT_Q') * newValue),CustomCodeInfo.gsUnderCalBase);
					record.set('ORDER_UNIT_FOR_O', record.get('ORDER_UNIT_Q') * newValue);
					//fnRound(fnCDbl(grdsheet1.TextMatrix(lRow,grdsheet1.colindex("ORDER_UNIT_Q")))  *  fnCDbl(grdsheet1.TextMatrix(lRow,	grdsheet1.colindex("ORDER_UNIT_FOR_P"))), top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
					record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}
                    directMasterStore1.fnSumAmountI();
				
					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P',(newValue * record.get('EXCHG_RATE_O')));	//자사단가 = 입력한 구매단가 * 환율
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));	//자사금액 = 입고량 * 자사단가
						
						record.set('INOUT_FOR_P',(newValue / record.get('TRNS_RATE')));
						record.set('INOUT_P',(newValue / record.get('TRNS_RATE') * record.get('EXCHG_RATE_O')));
						record.set('INOUT_I', (record.get('INOUT_P') * record.get('ORDER_UNIT_Q')));
						
						
						
						var param = {"COMP_CODE": record.get('COMP_CODE'),
									"ITEM_CODE": record.get('ITEM_CODE'),
									"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE'),
									"ORDER_UNIT_P": record.get('ORDER_UNIT_P'),
									"ORDER_UNIT_Q" : record.get('ORDER_UNIT_Q')
									};
					mrt100ukrvService.fnGetCalcTaxAmt(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
						record.set('INOUT_I', provider['INOUT_I']);
						record.set('INOUT_TAX_AMT', provider['INOUT_TAX_AMT']);
						record.set('INOUT_TOTAL_I', provider['INOUT_TOTAL_I']);//record.get('ORDER_UNIT_I') + record.get('INOUT_TAX_AMT'));

						
						
						}
					});
						
						
						
						//record.set('ORDER_UNIT_I') = 
				//보류 반올림		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS")); 
						//record.set('INOUT_I') = 
				//보류 반올림		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag,top.goCnn.GetFSET("M_FSET_IS"));
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					break;
					
				case "EXCHG_RATE_O" :	//환율
					if((record.get('ACCOUNT_YNC')== 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')){
						if(newValue <= 0){
							rv='<t:message code = "unilite.msg.sMM375"/>';
							break;
						}
					}else{
						if(newValue < 0){
							rv='<t:message code = "unilite.msg.sMM376"/>';
							break;
						}
					}
					
					//record.set('ORDER_UNIT_FOR_O') = 
		//보류 반올림			Math.round((record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_FOR_P')),CustomCodeInfo.gsUnderCalBase);
					//fnRound(fnCDbl(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_Q")))  *  fnCDbl(grdsheet1.TextMatrix(lRow,grdsheet1.colindex("ORDER_UNIT_FOR_P"))), top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
					record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}
                    directMasterStore1.fnSumAmountI();
				
					if(newValue != 0){
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * newValue));	//자사단가(재고) = 재고단위단가 * 입력한 환율
						record.set('ORDER_UNIT_P',(record.get('ORDER_UNIT_FOR_P') * newValue));	
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));
						//record.set('ORDER_UNIT_I') = 
			//보류 반올림			Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS")); 
						//record.set('INOUT_I') = 
			//보류 반올림			Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					break;
		
				case "ORDER_UNIT_FOR_O" : //구매금액
					if(record.get('ORDER_UNIT_Q') != ''){
						if((newValue <= 0) && (record.get('ORDER_UNIT_Q') > 0)){
							rv='<t:message code = "unilite.msg.sMB076"/>';
							break;
						}else if((newValue >= 0) && (record.get('ORDER_UNIT_Q') < 0)){
							rv='<t:message code = "unilite.msg.sMB077"/>';
							break;
						}
					}
					
					//record.set('INOUT_FOR_O') = 
			//보류 반올림 		Math.round(newValue,CustomCodeInfo.gsUnderCalBase);
					//fnRound(grdsheet1.TextMatrix(lRow,lCol) , top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
						record.set('ORDER_UNIT_FOR_P',(newValue / record.get('ORDER_UNIT_Q')));	//구매단가 = 입력한 구매금액 / 입고량
					}else{
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}
					
					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P',(record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가 = 구매단가 * 환율
						record.set('ORDER_UNIT_I',(newValue * record.get('EXCHG_RATE_O')));	//자사금액 = 입력한 구매금액 * 환율
						//record.set('ORDER_UNIT_I') = 
			//보류 반올림			Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")),top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
						//record.set('INOUT_I') = 
			//보류 반올림			Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")),top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"))
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
                    directMasterStore1.fnSumAmountI();
                    break;
		
				case "MONEY_UNIT" :
			//			"mms510ukrs1v
			//			1392줄~1404줄"
									
			//			"mms510ukrs1v
			//			1406줄~1416줄"
					if(newValue == BsaCodeInfo.gsDefaultMoney){
						record.set('EXCHG_RATE_O','1');	
					}//else
					
					//record.set('ORDER_UNIT_FOR_O') = 
		//보류 반올림			Math.round((record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_FOR_P')),CustomCodeInfo.gsUnderCalBase);
				
					record.set('ORDER_UNIT_FOR_O', record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_FOR_P'));	//구매금액 = 입고량 * 구매단가
					//fnRound(fnCDbl(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_Q"))) * fnCDbl(grdsheet1.TextMatrix(lRow,grdsheet1.colindex("ORDER_UNIT_FOR_P"))), top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
					record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}
                    directMasterStore1.fnSumAmountI();
					
					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P',(record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가 = 구매단가 * 환율
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));	//자사금액 = 입고량 * 자사단가
						//record.set('ORDER_UNIT_I') = 
				//보류 반올림		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
						//record.set('INOUT_I') = 
				//보류 반올림		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")),top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					break;
	
				case "INOUT_TYPE_DETAIL" :
				record.set('ACCOUNT_YNC', UniAppManager.app.fnInTypeAccountYN(newValue));
				
					if(record.get('ACCOUNT_YNC') == 'N'){
						record.set('PRICE_YN','N');
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
						
                    	directMasterStore1.fnSumAmountI();
					}else{
						record.set('PRICE_YN','Y');	
					}
					break;
	
				case "ACCOUNT_YNC":
					if(newValue == 'N'){
						record.set('PRICE_YN','N');	
					}
					break;
				case "PRICE_YN":
					if(newValue == 'Y'){
						if((record.get('INOUT_P') == 0) || (record.get('ORDER_UNIT_P') == 0)){
							rv='<t:message code = "unilite.msg.sMM327"/>';	
							break;
						}
					}
					break;
				case "PROJECT_NO":
				//	UniAppManager.app.fnPlanNumChange(); //fnPlanNumChange 만들어야함
					break;
				case "TRANS_COST":
					if(newValue < 0){
						rv='<t:message code = "unilite.msg.sMM376"/>';	
						break;
					}
					
				case "TARIFF_AMT":
					if(newValue < 0){
						rv='<t:message code = "unilite.msg.sMM376"/>';	
						break;
					}
	/*				
*//*							이전값 != 입력값 일때
			If "" & grdSheet1.TextMatrix(lRow,0) = " " Then               '갱신될 자료
			       grdSheet1.TextMatrix(lRow,0)    =        "U"
			       glAffectedCnt = glAffectedCnt + 1
			End If
			
			
			'        변경된 자료가 존재함으로 저장할 수 있음
			If top.goCnn.bEnableSaveBtn = 0 Then        
			   top.goCnn.bEnableSaveBtn        = 1
			    grdSheet1.RowData(grdSheet1.row) = "S"
			End If*/
	//				break;
			}
				return rv;
						}
			});	
	Unilite.createValidator('validator02', {
		forms: {'formA:':masterForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {				
				case "EXCHG_RATE_O" :  // 환율
					if(masterForm.getValue('MONEY_UNIT') == BsaCodeInfo.gsDefaultMoney){
							if(newValue != '1'){
								rv='<t:message code = "unilite.msg.sMM336"/>';
								break;
							}
					}
					break;
				
			}
			return rv;
		}
	}); // validator02			
			
};

</script>