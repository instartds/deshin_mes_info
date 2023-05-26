<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mms515ukrv_yp"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_mms515ukrv_yp" /> <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" /><!--창고Cell-->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M505" opts= '2;6'/><!-- 생성경로 (폼) -->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '2;6'/> <!-- 생성경로 (그리드) -->
	<t:ExtComboStore comboType="AU" comboCode="M103" /> <!-- 입고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B021" /> <!-- 품목상태 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" /> <!-- 단가형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="S014" /> <!-- 기표대상 -->
	<t:ExtComboStore comboType="AU" comboCode="YP08" /> <!-- 조건 -->
	<t:ExtComboStore comboType="AU" comboCode="YP09" /> <!-- 형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!-- 과세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="Z001" /> <!-- 인증구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

</style>
<script type="text/javascript" >

var SearchInfoWindow;	//조회버튼 누르면 나오는 조회창
var referNoReceiveWindow;	//미입고참조
var referReceiveWindow;	 //반품가능입고참조
var referReturnPossibleWindow;	//반품가능발주참조
var referInspectResultWindow;	//검사결과참조
var excelWindow;				// 엑셀참조
//var referScmRefWindow; //업체출고 참조(SCM)
var BsaCodeInfo = {
	gsDefaultData		: '${gsDefaultData}',
	gsInTypeAccountYN	: ${gsInTypeAccountYN},
	gsExcessRate		: '${gsExcessRate}',
	gsInvstatus			: '${gsInvstatus}',
	gsProcessFlag		: '${gsProcessFlag}',
	gsInspecFlag		: '${gsInspecFlag}',
	gsMap100UkrLink		: '${gsMap100UkrLink}',
	gsSumTypeLot		: '${gsSumTypeLot}',
	gsSumTypeCell		: '${gsSumTypeCell}',
	gsDefaultMoney		: '${gsDefaultMoney}',
	gsAutoType			: '${gsAutoType}',
	gsInOutPrsn			: '${gsInOutPrsn}',
	gsOScmYn			: '${gsOScmYn}',
	gsDbName			: '${gsDbName}',
	gsEssItemAccount	: '${gsEssItemAccount}',
	gsGwYn			  : '${gsGwYn}'
};
var CustomCodeInfo = {
	gsUnderCalBase: ''
};
var gsInoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_M103').getAt(0).get('value');
var outDivCode = UserInfo.divCode;

var gsGwYn = true; //그룹웨어 사용여부
if(BsaCodeInfo.gsGwYn == 'Y') {
	gsGwYn = false;
}
var gsLotNo				= '';					// LOT_NO 채번관련 전역변수
var gsCertType			= '';					// LOT_NO 채번관련 전역변수(인증구분 값)
//var output ='';
//  for(var key in BsaCodeInfo){
//	  output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//  }
//  alert(output);


var aa = 0;
function appMain() {

	//창고에 따른 창고cell 콤보load..
	var cbStore = Unilite.createStore('s_s_mms515ukrv_yp_ypComboStoreGrid',{
		autoLoad: false,
		uniOpt: {
			isMaster: false		 // 상위 버튼 연결
		},
		fields: [
				{name: 'SUB_CODE', type : 'string'},
				{name: 'CODE_NAME', type : 'string'}
				],
		proxy: {
			type: 'direct',
			api: {
				read: 'salesCommonService.fnRecordCombo'
			}
		},
		loadStoreRecords: function(whCode) {
			var param= masterForm.getValues();
			param.COMP_CODE= UserInfo.compCode;
//			param.DIV_CODE = UserInfo.divCode;
			param.WH_CODE = whCode;
			param.TYPE = 'BSA225T';
			console.log( param );
			this.load({
				params: param
			});
		}
	});

//	var sumtypeLot = BsaCodeInfo.gsSumTypeLot == "Y"?true:false;
	var sumtypeLot = true;	//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeLot =='Y') {
		sumtypeLot = false;
	}
	var sumtypeCell = true;	//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeCell =='Y') {
		sumtypeCell = false;
	}
	var isAutoInoutNum = BsaCodeInfo.gsAutoType=='Y'?true:false;

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_mms515ukrv_ypService.selectList',
			update: 's_mms515ukrv_ypService.updateDetail',
			create: 's_mms515ukrv_ypService.insertDetail',
			destroy: 's_mms515ukrv_ypService.deleteDetail',
			syncAll: 's_mms515ukrv_ypService.saveAll'
		}
	});

	Unilite.defineModel('s_mms515ukrv_ypModel1', {
		fields: [
			{name: 'INOUT_NUM'				, text: '입고번호'				, type: 'string',allowBlank: isAutoInoutNum},
			{name: 'INOUT_SEQ'				, text: '순번'				, type: 'int', allowBlank: false},
			{name: 'INOUT_METH'				, text: '방법'				, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		, text: '입고유형'				, type: 'string',comboType:'AU',comboCode:'M103', allowBlank: false},
			{name: 'ITEM_CODE' 				, text: '품목코드'				, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME' 				, text: '품목명'				, type: 'string'},
			{name: 'ITEM_ACCOUNT' 			, text: '품목계정'				, type: 'string',comboType: 'AU',comboCode: 'B020'},
			{name: 'SPEC'  					, text: '규격'				, type: 'string'},
			{name: 'ORDER_UNIT'				, text: '구매단위'				, type: 'string',comboType:'AU',comboCode:'B013', displayField: 'value'},
			{name: 'ORDER_UNIT_Q'			, text: '입고수량'				, type: 'uniQty', allowBlank: true},
			{name: 'STOCK_UNIT'  			, text: '재고단위'				, type: 'string',comboType:'AU',comboCode:'B013', displayField: 'value'},
			{name: 'INOUT_Q'  				, text: '재고단위수량'			, type: 'uniQty'},
			{name: 'ORIGINAL_Q'				, text: '기존입고량'				, type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'			, text: '현재고'				, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'			, text: '불량재고'				, type: 'uniQty'},
			{name: 'NOINOUT_Q'  			, text: '미입고량'				, type: 'uniQty'},
			{name: 'PRICE_YN' 				, text: '단가형태'				, type: 'string',comboType:'AU',comboCode:'M301'},
			{name: 'MONEY_UNIT' 			, text: '화폐'				, type: 'string',comboType:'AU',comboCode:'B004', allowBlank: false, displayField: 'value' },
			{name: 'INOUT_FOR_P' 			, text: '재고단위단가'			, type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O' 			, text: '재고단위금액'			, type: 'uniPrice'},

			{name: 'EXCHG_RATE_O' 			, text: '환율'				, type: 'uniER'},
			{name: 'INOUT_P' 		   		, text: '자사단가(재고)'			, type: 'uniUnitPrice', allowBlank: true, editable: false},
			{name: 'INOUT_I' 		   		, text: '공급가액'				, type: 'uniPrice'},//기존 자사금액(재고)
			{name: 'TRANS_COST'	   			, text: '운반비'				, type: 'uniPrice'},
			{name: 'TARIFF_AMT'	   			, text: '관세'				, type: 'uniPrice'},
			{name: 'ACCOUNT_YNC' 		  	, text: '기표대상'				, type: 'string', comboType:'AU',comboCode:'S014', allowBlank: false},
			{name: 'ORDER_TYPE' 		  	, text: '발주형태'				, type: 'string',comboType:'AU',comboCode:'M001', allowBlank: false},
			{name: 'LC_NUM'  			   	, text: 'LC/NO(*)'			, type: 'string'},
			{name: 'BL_NUM'  				, text: 'BL번호'				, type: 'string'},
			{name: 'ORDER_NUM' 			  	, text: '발주번호'				, type: 'string'},
			{name: 'ORDER_SEQ'  			, text: '순번'				, type: 'int'},
			{name: 'ORDER_Q'  			   	, text: '발주량'				, type: 'uniQty'},
			{name: 'INOUT_CODE_TYPE'		, text: '입고처구분'				, type: 'string'},
			{name: 'WH_CODE'				, text: '입고창고'				, type: 'string',store: Ext.data.StoreManager.lookup('whList'), allowBlank: false, child: 'WH_CELL_CODE'},
			{name: 'WH_CELL_CODE'			, text: '입고창고 Cell'			, type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','SALE_DIV_CODE']},
			//20171205추가(농가정보)
			{name: 'FARM_CODE'  		   	, text: '농가코드'				, type: 'string'},
			{name: 'FARM_NAME'  		   	, text: '농가명'				, type: 'string'},
			{name: 'WONSANGI_NUM'			, text: '원산지'				, type: 'string'},
			{name: 'ITEM_STATUS'  		  	, text: '품목상태'				, type: 'string',comboType:'AU',comboCode:'B021', allowBlank: false},
			{name: 'INOUT_DATE'  			, text: '입고일'				, type: 'uniDate', allowBlank: false},
			{name: 'INOUT_PRSN'  		   	, text: '입고담당'				, type: 'string'},
			{name: 'ACCOUNT_Q'  			, text: '계산서량'				, type: 'uniQty'},
			{name: 'CREATE_LOC'  			, text: '생성경로'				, type: 'string',comboType:'AU',comboCode:'B031'},
			{name: 'SALE_C_DATE'  		   	, text: '계산서마감일자'			, type: 'uniDate'},
			{name: 'REMARK'  			   	, text: '비고'				, type: 'string'},
			{name: 'PROJECT_NO'				, text: '프로젝트 번호'			, type: 'string'},
			{name: 'CERT_TYPE'  		   	, text: '인증구분'				, type: 'string'	, comboType: 'AU'	, comboCode: 'Z001'},
			{name: 'LOT_NO'  			   	, text: 'LOT NO'			, type: 'string'},
			{name: 'LOT_YN'					, text: 'LOT관리여부'			, type: 'string', comboType:'AU', comboCode:'A020'},
			{name: 'INOUT_TYPE'  			, text: '타입'				, type: 'string'},
			{name: 'INOUT_CODE'  			, text: '거래처'				, type: 'string', allowBlank: false},
			{name: 'DIV_CODE'  			  	, text: '사업장'				, type: 'string', child: 'WH_CODE'},
			{name: 'INOUT_NAME'  		  	, text: '거래처명'				, type: 'string'},
			{name: 'COMPANY_NUM'  		   	, text: '사업자번호'				, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text: '품목계정'				, type: 'string'},
			{name: 'INSTOCK_Q'  			, text: '발주입고수량'			, type: 'uniQty'},
			{name: 'INSPEC_NUM' 			, text: '접수번호'				, type: 'string'},
			{name: 'INSPEC_SEQ' 			, text: '접수순번'				, type: 'int'},
			{name: 'SALE_DIV_CODE'			, text: '매출사업장'				, type: 'string'},
			{name: 'SALE_CUSTOM_CODE' 		, text: '매출처'				, type: 'string'},
			{name: 'BILL_TYPE'		   		, text: '매출유형'				, type: 'string'},
			{name: 'SALE_TYPE'		   		, text: '매출구분'				, type: 'string'},
			{name: 'UPDATE_DB_USER'			, text: '수정자'				, type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '수정한날짜'				, type: 'string'},
			{name: 'EXCESS_RATE'			, text: '과입고허용률'			, type: 'string'},
			{name: 'TRNS_RATE'				, text: '<t:message code="Mpo501.label.TRNS_RATE" default="입수"/>'		,type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
			{name: 'ORDER_UNIT_FOR_P'  		, text: '입고단가'				, type: 'uniUnitPrice'/*, allowBlank: false*/},
			{name: 'ORDER_UNIT_FOR_O'  		, text: '입고금액'				, type: 'uniPrice'/*, allowBlank: false*/},
			{name: 'ORDER_UNIT_P'  		  	, text: '자사단가'				, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_I' 		   	, text: '자사금액'				, type: 'uniPrice'},		   ///////////////////////////////////////////////////////   INOUT_I
			{name: 'BASIS_NUM'  			, text: 'BASIS_NUM'			, type: 'string'},
			{name: 'BASIS_SEQ'  		   	, text: 'BASIS_SEQ'			, type: 'int'},
			{name: 'SCM_FLAG_YN'  			, text: 'SCM_FLAG_YN'		, type: 'string'},
			{name: 'TRADE_LOC'	   			, text: '무역경로'				, type: 'string',comboType:'AU',comboCode:'T104'},
			{name: 'STOCK_CARE_YN'	   		, text: '재고관리여부'			, type: 'string'},
			{name: 'COMP_CODE'  		  	, text: '법인코드'				, type: 'string'},
			{name: 'INSERT_DB_USER'  		, text: 'INSERT_DB_USER'	, type: 'string'},
			{name: 'INSERT_DB_TIME'			, text: 'INSERT_DB_TIME'	, type: 'string'},
			{name: 'SALES_TYPE'				, text: 'SALES_TYPE'		, type: 'int'},
			{name: 'FLAG'					, text: 'FLAG'				, type: 'string'},
			{name: 'PERSON_NUMB'			, text: '사원'				, type: 'string'}
//			{name: 'PURCHASE_TYPE'		  , text: 'PURCHASE_TYPE'		, type: 'int'},
//			{name: 'PURCHASE_RATE'		  , text: 'PURCHASE_RATE'		, type: 'int'}
		]
	});//Unilite.defineModel('s_mms515ukrv_ypModel1', {

	Unilite.defineModel('inoutNoMasterModel', {			 //조회버튼 누르면 나오는 조회창
		fields: [
			{name: 'INOUT_NAME'	   			, text: '거래처'		, type: 'string'},
			{name: 'INOUT_DATE'	   			, text: '입고일'		, type: 'uniDate'},
			{name: 'INOUT_CODE'	   			, text: '거래처코드'		, type: 'string'},
			{name: 'WH_CODE'		  		, text: '입고창고'		, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
			{name: 'WH_CELL_CODE'	 		, text: '입고창고Cell'	, type: 'string'},
			{name: 'DIV_CODE'		 		, text: '사업장'		, type: 'string',comboType:'BOR120'},
			{name: 'INOUT_PRSN' 		 	, text: '입고담당'		, type: 'string',comboType:'AU', comboCode:'B024'},
			{name: 'INOUT_NUM'				, text: '입고번호'		, type: 'string'},
			{name: 'MONEY_UNIT'	   			, text: '화폐'		, type: 'string'},
			{name: 'EXCHG_RATE_O'	 		, text: '환율'		, type: 'uniER'},
			{name: 'CREATE_LOC'	   			, text: '생성경로'		, type: 'string',comboType:'AU',comboCode:'B031'},
			{name: 'PERSON_NUMB'			, text: '사원'		, type: 'string'},
			{name: 'PERSON_NAME'			, text: '사원명'		, type: 'string'},
			{name: 'CHANNEL'			   	, text: '약어'		, type: 'string'}
		]
	});

	Unilite.defineModel('s_mms515ukrv_ypNoReceiveModel', {		 //미입고참조
		fields: [
			{name: 'GUBUN'					, text: '선택'			, type: 'string'},
			{name: 'ITEM_CODE'				, text: '품목코드'			, type: 'string'},
			{name: 'ITEM_NAME'				, text: '품목명'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text: '품목계정'			, type: 'string'},
			{name: 'SPEC'					, text: '규격'			, type: 'string'},
			{name: 'DVRY_DATE'				, text: '납기일'			, type: 'uniDate'},
			{name: 'DIV_CODE'				, text: '제조처'			, type: 'string'},
			{name: 'ORDER_UNIT'				, text: '구매단위'			, type: 'string'},
			{name: 'ORDER_UNIT_Q'			, text: '발주량'			, type: 'uniQty'},
			{name: 'REMAIN_Q'				, text: '미입고량'			, type: 'uniQty'},
			{name: 'STOCK_UNIT'				, text: '재고단위'			, type: 'string'},
			{name: 'NOINOUT_Q'				, text: '미입고량'			, type: 'uniQty'},
			{name: 'ORDER_Q'				, text: '재고단위수량'		, type: 'uniQty'},
			{name: 'UNIT_PRICE_TYPE'		, text: '단가형태'			, type: 'string',comboType:'AU', comboCode:'M301'},
			{name: 'MONEY_UNIT'				, text: '화폐'			, type: 'string'},
			{name: 'EXCHG_RATE_O'			, text: '환율'			, type: 'uniER'},
			{name: 'ORDER_P'				, text: '재고단위단가'		, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_P'			, text: '단가'			, type: 'uniUnitPrice'},
			{name: 'ORDER_O'				, text: '금액'			, type: 'uniPrice'},
			{name: 'ORDER_LOC_P'			, text: '자사단가'			, type: 'uniUnitPrice'},
			{name: 'ORDER_LOC_O'			, text: '자사금액'			, type: 'uniPrice'},
			{name: 'ORDER_NUM'				, text: '발주번호'			, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '순번'			, type: 'string'},
			{name: 'LC_NUM'					, text: 'LC번호'			, type: 'string'},
			{name: 'WH_CODE'				, text: '창고'			, type: 'string'},
			{name: 'ORDER_REQ_NUM'			, text: '구매요청번호'		, type: 'string'},
			{name: 'ORDER_TYPE'				, text: '발주형태'			, type: 'string', allowBlank: false},
			{name: 'CUSTOM_CODE'			, text: '거래처'			, type: 'string'},
			{name: 'TRNS_RATE'				, text: '<t:message code="Mpo501.label.TRNS_RATE" default="입수"/>'		,type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
//			{name: 'TRNS_RATE'				, text: '변환계수'			, type: 'uniQty'},
			{name: 'INSTOCK_Q'				, text: '발주입고수량'		, type: 'uniQty'},
			{name: 'REMARK'					, text: '비고'			, type: 'string'},
			{name: 'PROJECT_NO'				, text: '프로젝트 번호'		, type: 'string'},
			{name: 'EXCESS_RATE'			, text: '과입고허용율'		, type: 'uniPercent'},
			{name: 'ORDER_PRSN'				, text: '구매담당'			, type: 'string',comboType:'AU', comboCode:'M201'},
			{name: 'GOOD_STOCK_Q'			, text: '양품재고'			, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'			, text: '불량재고'			, type: 'uniQty'},
			{name: 'LC_NO'					, text: 'LC번호'			, type: 'string'},
			{name: 'BL_NO'					, text: 'BL번호'			, type: 'string'},
			{name: 'BASIS_NUM'				, text: '기준번호'			, type: 'string'},
			{name: 'BASIS_SEQ'				, text: '기준순번'			, type: 'string'},
			{name: 'LC_DATE'				, text: 'L/C일자'			, type: 'uniDate'},
			{name: 'INVOICE_DATE'			, text: '통관일자'			, type: 'uniDate'},
			{name: 'TRADE_LOC'				, text: '무역경로'			, type: 'string'},
			{name: 'LOT_NO'					, text: 'LOT NO'		, type: 'string'},
			{name: 'LOT_YN'					, text: 'LOT_YN'		, type: 'string'}
		]
	});

	Unilite.defineModel('s_mms515ukrv_ypRETURNModel', {		 //반품가능발주참조
		fields: [
			{name: 'GUBUN'					, text: '선택'			, type: 'string'},
			{name: 'ITEM_CODE'				, text: '품목코드'			, type: 'string'},
			{name: 'ITEM_NAME'				, text: '품목명'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text: '품목계정'			, type: 'string'},
			{name: 'SPEC'					, text: '규격'			, type: 'string'},
			{name: 'DVRY_DATE'				, text: '납기일'			, type: 'uniDate'},
			{name: 'DIV_CODE'				, text: '제조처'			, type: 'string'},
			{name: 'ORDER_UNIT'				, text: '구매단위'			, type: 'string'},
			{name: 'ORDER_UNIT_Q'			, text: '발주량'			, type: 'uniQty'},
			{name: 'REMAIN_Q'				, text: '반품가능수량'		, type: 'uniQty'},
			{name: 'STOCK_UNIT'				, text: '재고단위'			, type: 'string'},
			{name: 'NOINOUT_Q'				, text: '미입고량'			, type: 'uniQty'},
			{name: 'ORDER_Q'				, text: '재고단위수량'		, type: 'uniQty'},
			{name: 'UNIT_PRICE_TYPE'		, text: '단가형태'			, type: 'string',comboType:'AU', comboCode:'M301'},
			{name: 'MONEY_UNIT'				, text: '화폐'			, type: 'string'},
			{name: 'EXCHG_RATE_O'			, text: '환율'			, type: 'uniER'},
			{name: 'ORDER_P'				, text: '재고단위단가'		, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_P'			, text: '단가'			, type: 'uniUnitPrice'},
			{name: 'ORDER_O'				, text: '금액'			, type: 'uniPrice'},
			{name: 'ORDER_LOC_P'			, text: '자사단가'			, type: 'uniPrice'},
			{name: 'ORDER_LOC_O'			, text: '자사금액'			, type: 'uniPrice'},
			{name: 'ORDER_NUM'				, text: '발주번호'			, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '순번'			, type: 'string'},
			{name: 'LC_NUM'					, text: 'LC번호'			, type: 'string'},
			{name: 'WH_CODE'				, text: '창고'			, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
			{name: 'ORDER_REQ_NUM'			, text: '구매요청번호'		, type: 'string'},
			{name: 'ORDER_TYPE'				, text: '발주형태'			, type: 'string'},
			{name: 'CUSTOM_CODE'			, text: '거래처'			, type: 'string'},
			{name: 'TRNS_RATE'				, text: '<t:message code="Mpo501.label.TRNS_RATE" default="입수"/>'		,type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
//			{name: 'TRNS_RATE'				, text: '변환계수'			, type: 'uniQty'},
			{name: 'INSTOCK_Q'				, text: '발주입고수량'		, type: 'uniQty'},
			{name: 'REMARK'					, text: '비고'			, type: 'string'},
			{name: 'PROJECT_NO'				, text: '프로젝트 번호'		, type: 'string'},
			{name: 'EXCESS_RATE'			, text: '과입고허용율'		, type: 'string'},
			{name: 'LC_NO'					, text: 'L/C번호'			, type: 'string'},
			{name: 'BL_NO'					, text: 'BL번호'			, type: 'string'},
			{name: 'BASIS_NUM'				, text: '기준번호'			, type: 'string'},
			{name: 'BASIS_SEQ'				, text: '기준순번'			, type: 'string'},
			{name: 'LC_DATE'				, text: 'L/C일자'			, type: 'uniDate'},
			{name: 'INVOICE_DATE'			, text: '통관일자'			, type: 'uniDate'},
			{name: 'TRADE_LOC'				, text: '무역경로'			, type: 'string'}
		]
	});

	Unilite.defineModel('s_mms515ukrv_ypReceiveModel', {		 //입고참조
		fields: [
			{name: 'GUBUN'					, text: '선택'			, type: 'string'},
			{name: 'ITEM_CODE'				, text: '품목코드'			, type: 'string'},
			{name: 'ITEM_NAME'				, text: '품목명'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text: '품목계정'			, type: 'string'},
			{name: 'SPEC'					, text: '규격'			, type: 'string'},
			{name: 'DVRY_DATE'				, text: '납기일'			, type: 'uniDate'},
			{name: 'DIV_CODE'				, text: '제조처'			, type: 'string'},
			{name: 'ORDER_UNIT'				, text: '구매단위'			, type: 'string'},
			{name: 'ORDER_UNIT_Q'			, text: '발주량'			, type: 'uniQty'},
			{name: 'REMAIN_Q'				, text: '반품가능수량'		, type: 'uniQty'},
			{name: 'STOCK_UNIT'				, text: '재고단위'			, type: 'string'},
			{name: 'NOINOUT_Q'				, text: '미입고량'			, type: 'uniQty'},
			{name: 'ORDER_Q'				, text: '재고단위수량'		, type: 'uniQty'},
			{name: 'UNIT_PRICE_TYPE'		, text: '단가형태'			, type: 'string',comboType:'AU', comboCode:'M301'},
			{name: 'MONEY_UNIT'				, text: '화폐'			, type: 'string'},
			{name: 'EXCHG_RATE_O'			, text: '환율'			, type: 'uniER'},
			{name: 'ORDER_P'				, text: '재고단위단가'		, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_P'			, text: '단가'			, type: 'uniUnitPrice'},
			{name: 'ORDER_O'				, text: '금액'			, type: 'uniPrice'},
			{name: 'ORDER_LOC_P'			, text: '자사단가'			, type: 'uniPrice'},
			{name: 'ORDER_LOC_O'			, text: '자사금액'			, type: 'uniPrice'},
			{name: 'ORDER_NUM'				, text: '발주번호'			, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '순번'			, type: 'string'},
			{name: 'LC_NUM'					, text: 'LC번호'			, type: 'string'},
			{name: 'WH_CODE'				, text: '창고'			, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
			{name: 'ORDER_REQ_NUM'			, text: '구매요청번호'		, type: 'string'},
			{name: 'ORDER_TYPE'				, text: '발주형태'			, type: 'string'},
			{name: 'CUSTOM_CODE'			, text: '거래처'			, type: 'string'},
			{name: 'TRNS_RATE'				, text: '<t:message code="Mpo501.label.TRNS_RATE" default="입수"/>'		,type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
//			{name: 'TRNS_RATE'				, text: '변환계수'			, type: 'int'},
			{name: 'INSTOCK_Q'				, text: '발주입고수량'		, type: 'uniQty'},
			{name: 'REMARK'					, text: '비고'			, type: 'string'},
			{name: 'PROJECT_NO'				, text: '프로젝트 번호'		, type: 'string'},
			{name: 'EXCESS_RATE'			, text: '과입고허용율'		, type: 'string'},
			{name: 'LC_NO'					, text: 'L/C번호'			, type: 'string'},
			{name: 'BL_NO'					, text: 'BL번호'			, type: 'string'},
			{name: 'BASIS_NUM'				, text: '기준번호'			, type: 'string'},
			{name: 'BASIS_SEQ'				, text: '기준순번'			, type: 'string'},
			{name: 'LC_DATE'				, text: 'L/C일자'			, type: 'uniDate'},
			{name: 'INVOICE_DATE'			, text: '통관일자'			, type: 'uniDate'},
			{name: 'TRADE_LOC'				, text: '무역경로'			, type: 'string'},
			{name: 'LOT_NO'					, text: 'LOT NO'		, type: 'string'}
		]
	});

	Unilite.defineModel('s_mms515ukrv_ypSCMREFModel1', {		 //검사결과참조
		fields: [
			{name: 'GUBUN'	 				, text: '선택'			, type: 'string'},
			{name: 'CUSTOM_NAME'	 		, text: '출고처'			, type: 'string'},
			{name: 'INOUT_NUM'				, text: '출고번호'			, type: 'string'},
			{name: 'INOUT_SEQ'				, text: '순번'			, type: 'int'},
			{name: 'INOUT_DATE'				, text: '출고일'			, type: 'string'},
			{name: 'CUSTOM_ITEM_CODE'		, text: '업체품목코드'		, type: 'string'},
			{name: 'ITEM_CODE'				, text: '자사품목코드'		, type: 'string'},
			{name: 'ITEM_NAME'				, text: '자사품명'			, type: 'string'},
			{name: 'SPEC'					, text: '자사규격'			, type: 'string'},
			{name: 'MONEY_UNIT'				, text: '화폐단위'			, type: 'string'},
			{name: 'EXCHG_RATE_O'			, text: '환율'			, type: 'uniER'},
			{name: 'ORDER_UNIT'				, text: '구매단위'			, type: 'string'},
			{name: 'TRNS_RATE'				, text: '<t:message code="Mpo501.label.TRNS_RATE" default="입수"/>'		,type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
//			{name: 'TRNS_RATE'				, text: '입수'			, type: 'int'},
			{name: 'INOUT_Q'				, text: '출고량'			, type: 'uniQty'},
			{name: 'INOUT_P'				, text: '출고단가'			, type: 'uniUnitPrice'},
			{name: 'INOUT_I'				, text: '출고금액'			, type: 'uniPrice'},
			{name: 'INOUT_PRSN'				, text: '출고담당자'			, type: 'string'},
			{name: 'ORDER_NUM'				, text: '발주번호'			, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '순번'			, type: 'string'},
			{name: 'REMARK'					, text: '비고'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text: '품목계정'			, type: 'string'},
			{name: 'STOCK_CARE_YN'			, text: '재고관리여부'		, type: 'string'},
			{name: 'WH_CODE'				, text: '창고'			, type: 'string'},
			{name: 'STOCK_UNIT'				, text: '재고단위'			, type: 'string'},
			{name: 'INOUT_FOR_P'			, text: '재고단위단가'		, type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O'			, text: '재고단위금액'		, type: 'uniPrice'},
			{name: 'ORDER_TYPE'				, text: '발주형태'			, type: 'string'}

		]
	});

	Unilite.defineModel('s_mms515ukrv_ypINSPECTModel2', {	 //검사결과참조
		fields: [
			{name: 'GUBUN'					, text: '선택'			, type: 'string'},
			{name: 'ITEM_CODE'				, text: '품목코드'			, type: 'string'},
			{name: 'ITEM_NAME'				, text: '품목명'			, type: 'string'},
			{name: 'SPEC'					, text: '규격'			, type: 'string'},
			{name: 'DVRY_DATE'				, text: '납기일'			, type: 'uniDate'},
			{name: 'INSPEC_DATE'			, text: '검사일'			, type: 'uniDate'},
			{name: 'ORDER_UNIT'				, text: '구매단위'			, type: 'string'},
			{name: 'ORDER_O'				, text: '금액'			, type: 'uniPrice'},
			{name: 'NOINOUT_Q'				, text: '미입고량'			, type: 'uniQty'},
			{name: 'ITEM_STATUS'			, text: '품목상태'			, type: 'string',comboType:'AU', comboCode:'B021'},
			{name: 'UNIT_PRICE_TYPE'		, text: '단가형태'			, type: 'string',comboType:'AU', comboCode:'M301'},
			{name: 'MONEY_UNIT'				, text: '화폐'			, type: 'string'},
			{name: 'ORDER_UNIT_P'			, text: '단가'			, type: 'uniUnitPrice'},
			{name: 'EXCHG_RATE_O'			, text: '환율'			, type: 'uniER'},
			{name: 'ORDER_LOC_P'			, text: '자사단가'			, type: 'uniUnitPrice'},
			{name: 'ORDER_LOC_O'			, text: '자사금액'			, type: 'uniPrice'},
			{name: 'ORDER_NUM'				, text: '발주번호'			, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '발주순번'			, type: 'int'},
			{name: 'CUSTOM_CODE'			, text: '거래처'			, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '거래처명'			, type: 'string'},
			{name: 'REMAIN_Q'				, text: '검사수량'			, type: 'uniQty'},
			{name: 'INSPEC_NUM'				, text: '검사번호'			, type: 'string'},
			{name: 'INSPEC_SEQ'				, text: '검사순번'			, type: 'int'},
			{name: 'PORE_Q'					, text: '발주잔량'			, type: 'uniQty'},
			{name: 'REMARK'					, text: '비고'			, type: 'string'},
			{name: 'LOT_NO'  				, text: 'LOT NO'		, type: 'string'},
			{name: 'LOT_YN'					, text: 'LOT_YN'		, type: 'string'},
			{name: 'PROJECT_NO'				, text: '프로젝트 번호'		, type: 'string'},
			{name: 'LC_NO'					, text: 'L/C번호'			, type: 'string'},
			{name: 'BL_NO'					, text: 'BL번호'			, type: 'string'},
			{name: 'BASIS_NUM'				, text: '기준번호'			, type: 'string'},
			{name: 'BASIS_SEQ'				, text: '기준순번'			, type: 'int'},
			{name: 'LC_DATE'				, text: 'L/C일자'			, type: 'uniDate'},
			{name: 'INVOICE_DATE'			, text: '통관일자'			, type: 'uniDate'},
			{name: 'TRADE_LOC'				, text: '무역경로'			, type: 'string',comboType:'AU',comboCode:'T104'},
			{name: 'ITEM_ACCOUNT'			, text: '품목계정'			, type: 'string'},
			{name: 'LC_NUM'					, text: 'LC번호'			, type: 'string'},
			{name: 'WH_CODE'				, text: '창고'			, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
			{name: 'ORDER_REQ_NUM'			, text: '구매요청번호'		, type: 'string'},
			{name: 'DIV_CODE'				, text: '제조처'			, type: 'string'},
			{name: 'ORDER_TYPE'				, text: '발주형태'			, type: 'string'},
			{name: 'TRNS_RATE'				, text: '<t:message code="Mpo501.label.TRNS_RATE" default="입수"/>'		,type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
//			{name: 'TRNS_RATE'				, text: '변환계수'			, type: 'int'},
			{name: 'STOCK_UNIT'				, text: '재고단위'			, type: 'string'},
			{name: 'ORDER_Q'				, text: '재고단위수량'		, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q'			, text: '발주량'			, type: 'uniQty'},
			{name: 'ORDER_P'				, text: '재고단위단가'		, type: 'uniUnitPrice'},
			{name: 'INSTOCK_Q'				, text: '발주입고수량'		, type: 'uniQty'},
			{name: 'EXCESS_RATE'			, text: '과입고허용율'		, type: 'string'}
		]
	});

	var directMasterStore1 = Unilite.createStore('s_mms515ukrv_ypMasterStore1', {
		model: 's_mms515ukrv_ypModel1',
		uniOpt: {
			isMaster	 : true,			// 상위 버튼 연결
			editable	 : true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			allDeletable : true,
			useNavi	  : false			// prev | newxt 버튼 사용
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
			var isErr = false;
			Ext.each(list, function(record, index) {
				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + 'LOT NO: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				var msg = '';
				if(record.get('PRICE_YN') == "Y"){
					if(record.get('ORDER_UNIT_FOR_P') == 0){
						msg += '입고단가: 필수 입력값 입니다.\n';
					}
					if(record.get('ORDER_UNIT_FOR_O') == 0){
						msg += '입고금액: 필수 입력값 입니다.\n';
					}
				}
				if(record.get('INOUT_TYPE_DETAIL') != '91'){
					if(record.get('ORDER_UNIT_Q') == 0){
						msg += '입고수량: 필수 입력값 입니다.\n';
					}
				   /*
					if(record.get('INOUT_Q') == 0){
						msg += '재고단위수량: 필수 입력값 입니다.\n';
					}
					if(record.get('ORDER_UNIT_FOR_P') == 0){
						msg += '입고단가: 필수 입력값 입니다.\n';
					}
					if(record.get('ORDER_UNIT_P') == 0){
						msg += '자사단가: 필수 입력값 입니다.\n';
					}*/
				}


				if(msg != ''){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + msg);
					isErr = true;
					return false;
				}

			});

			if(BsaCodeInfo.gsGwYn == 'Y') {
				if(Ext.isEmpty(panelResult2.getValue('PERSON_NUMB'))) {
					alert('사원은 필수입력값 입니다.');
					isErr = true;
					return false;
				}
			}
			if(isErr) return false;

			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
						panelResult2.setValue("INOUT_NUM", master.INOUT_NUM);
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
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
				var grid = Ext.getCmp('s_mms515ukrv_ypGrid1');
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

	});//End of var directMasterStore1 = Unilite.createStore('s_mms515ukrv_ypMasterStore1', {

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
				read: 's_mms515ukrv_ypService.selectinoutNoMasterList'
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

	var noReceiveStore = Unilite.createStore('s_mms515ukrv_ypNoReceiveStore', {//미입고참조
			model: 's_mms515ukrv_ypNoReceiveModel',
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
					read : 's_mms515ukrv_ypService.selectnoReceiveList'
				}
			},
			listeners:{
				load:function(store, records, successful, eOpts)	{
					if(successful)	{
					   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					   var estiRecords = new Array();

					   if(masterRecords.items.length > 0)	{
						   	Ext.each(records, function(item, i)	{
	   							Ext.each(masterRecords.items, function(record, i)	{
	   									if((record.data['ORDER_NUM'] == item.data['ORDER_NUM'])
	   										&& (record.data['ORDER_SEQ'] == item.data['ORDER_SEQ']))
	   									{
	   										estiRecords.push(item);
	   									}
	   							});
						   	});
						   store.remove(estiRecords);
					   }
					}
				}
			},
			loadStoreRecords : function()	{
				var param= noreceiveSearch.getValues();
				this.load({params : param});
			},
			groupField:'ORDER_NUM'
	});

	var returnPossibleStore = Unilite.createStore('s_mms515ukrv_ypReturnPossibleStore', {//반품가능발주참조
			model: 's_mms515ukrv_ypRETURNModel',
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
					read : 's_mms515ukrv_ypService.selectreturnPossibleList'
				}
			},
			listeners:{
				load:function(store, records, successful, eOpts)	{
					if(successful)	{
					   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					   var estiRecords = new Array();
					   if(masterRecords.items.length > 0)	{
						   	Ext.each(records, function(item, i)	{
	   							Ext.each(masterRecords.items, function(record, i)	{
   									if((record.data['ORDER_NUM'] == item.data['ORDER_NUM'])
   										&& (record.data['ORDER_SEQ'] == item.data['ORDER_SEQ']))
   									{
   										estiRecords.push(item);
   									}
	   							});
						   	});
						   store.remove(estiRecords);
					   }
					}
				}
			},
			loadStoreRecords : function()	{
				var param= returnpossibleSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField:'ORDER_NUM'
	});

	var receiveStore = Unilite.createStore('s_mms515ukrv_ypReceiveStore', {// 입고참조
			model: 's_mms515ukrv_ypReceiveModel',
			autoLoad: false,
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false		 // prev | newxt 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read : 's_mms515ukrv_ypService.selectReceiveList'
				}
			},
			listeners:{
				load:function(store, records, successful, eOpts)	{
					if(successful)  {
					   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					   var estiRecords = new Array();
					   if(masterRecords.items.length > 0)   {
							Ext.each(records, function(item, i) {
								Ext.each(masterRecords.items, function(record, i)   {
									if((record.data['ORDER_NUM'] == item.data['ORDER_NUM'])
										&& (record.data['ORDER_SEQ'] == item.data['ORDER_SEQ']))
									{
										estiRecords.push(item);
									}
								});
							});
						   store.remove(estiRecords);
					   }
					}
				}
			},
			loadStoreRecords : function()   {
				var param= receiveSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField:'ORDER_NUM'
	});

	var scmRefStore = Unilite.createStore('s_mms515ukrv_ypScmRefStore', {//검사결과참조
			model: 's_mms515ukrv_ypSCMREFModel1',
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
					read : 's_mms515ukrv_ypService.selectScmRefList'
				}
			},
			listeners:{
				load:function(store, records, successful, eOpts)	{
					if(successful)	{
					   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					   var scmRefRecords = new Array();
					   if(masterRecords.items.length > 0)	{
						   	Ext.each(records, function(item, i)	{
	   							Ext.each(masterRecords.items, function(record, i)	{
   									if((record.data['INOUT_NUM'] == item.data['INOUT_NUM'])
   										&& (record.data['INOUT_SEQ'] == item.data['INOUT_SEQ']))
   									{
   										scmRefRecords.push(item);
   									}
	   							});
						   	});
						   store.remove(scmRefRecords);
					   }
					}
				}
			},
			loadStoreRecords : function()	{
				var param= scmRefSearch.getValues();
				param["DIV_CODE"] = masterForm.getValue("DIV_CODE")
				param["CUSTOM_CODE"] = masterForm.getValue("CUSTOM_CODE")
				this.load({
					params : param
				});
			},
			groupField:'INOUT_NUM'
	});

	var inspectResultStore2 = Unilite.createStore('s_mms515ukrv_ypInspectResultStore', {//검사결과참조
			model: 's_mms515ukrv_ypINSPECTModel2',
			autoLoad: false,
			uniOpt : {
				isMaster: true,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false			// prev | newxt 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read : 's_mms515ukrv_ypService.selectinspectResultList'
				}
			},
			listeners:{
				load:function(store, records, successful, eOpts)	{
						if(successful)	{
						   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
						   var inspectRecords = new Array();

						   if(masterRecords.items.length > 0)	{
						   		console.log("store.items :", store.items);
						   		console.log("records", records);

							   	Ext.each(records,
							   		function(item, i)	{
			   							Ext.each(masterRecords.items, function(record, i)	{
			   								console.log("record :", record);

			   									if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM']) && (record.data['INSPEC_SEQ'] == item.data['INSPEC_SEQ'])
			   									  )
			   									{
			   										inspectRecords.push(item);
			   									}
			   							});
							   	});
							   store.remove(inspectRecords);
						   }
						}
				}
			},
			loadStoreRecords : function()	{
				var param= inspectresultSearch.getValues();
				param["oScmYn"] = BsaCodeInfo.gsOScmYn;
				param["sDbName"] = BsaCodeInfo.gsDbName;
				param["DIV_CODE"] = masterForm.getValue("DIV_CODE")
				param["CUSTOM_CODE"] = masterForm.getValue("CUSTOM_CODE")
				param["ORDER_PRSN"] = masterForm.getValue("INOUT_PRSN")
				param["MONEY_UNIT"] = masterForm.getValue("MONEY_UNIT")
				param["EXCHG_RATE_O"] = masterForm.getValue("EXCHG_RATE_O")
				this.load({
					params : param
				});
			},groupField:'INSPEC_NUM'
	});

	var masterForm = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
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
			title: '기본정보',
   			itemId: 'search_panel1',
		   	layout: {type: 'uniTable', columns: 1},
		   	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				holdable: 'hold',
				child: 'WH_CODE',
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
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '거래처',
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				allowBlank: true,
				hidden:true,
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
							masterForm.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
							masterForm.setValue('EXCHG_RATE_O', '1');
							panelResult2.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
							panelResult2.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
							panelResult2.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
							panelResult2.setValue('EXCHG_RATE_O', '1');
							masterForm.setValue('CHANNEL', records[0]["CHANNEL"]);
							UniAppManager.app.fnExchngRateO();
							UniAppManager.app.fnAutoLotNo(UniDate.getDbDateStr(masterForm.getValue('INOUT_DATE')));	   //LOT채번
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult2.setValue('CUSTOM_CODE', '');
						panelResult2.setValue('CUSTOM_NAME', '');
						masterForm.setValue('CHANNEL', '');
						masterForm.setValue('AUTO_LOT_NO', '');
						gsCertType = '';
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
					}
				}
			}),
			{
				fieldLabel: '입고일',
				name: 'INOUT_DATE',
				xtype: 'uniDatefield',
			   	value: UniDate.get('today'),
			 	allowBlank: false,
			 	holdable: 'hold',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('INOUT_DATE', newValue);
						UniAppManager.app.fnAutoLotNo(UniDate.getDbDateStr(newValue));	   //LOT채번
					}
				}
			},{
				fieldLabel: '입고창고',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
//				allowBlank: false,
				child: 'WH_CELL_CODE',
				holdable: 'hold',
				listConfig:{minWidth:230},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '입고창고Cell',
				name: 'WH_CELL_CODE',
				xtype:'uniCombobox',
				store: Ext.data.StoreManager.lookup('whCellList'),
				holdable: 'hold',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult2.setValue('WH_CELL_CODE', newValue);
					}
				}
			}/*,{
				fieldLabel: '입고창고 Cell',
				holdable:'hold',
				name: 'WH_CELL_CODE',
				hidden:!sumtypeCell,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('WH_CELL_CODE', newValue);
					}
				}
			}*/,{
				fieldLabel: '입고담당',
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
				fieldLabel: '생성경로',
				name: 'CREATE_LOC',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B031',
				allowBlank: true,
				hidden:true,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('CREATE_LOC', newValue);
					}
				}
			},
			Unilite.popup('Employee', {
				fieldLabel: '사원',
				valueFieldName:'PERSON_NUMB',
				textFieldName:'PERSON_NAME',
				hidden: gsGwYn,
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult2.setValue('PERSON_NUMB', masterForm.getValue('PERSON_NUMB'));
							panelResult2.setValue('PERSON_NAME', masterForm.getValue('PERSON_NAME'));},
						scope: this
					},
					onClear: function(type) {
						panelResult2.setValue('PERSON_NUMB', '');
						panelResult2.setValue('PERSON_NAME', '');
					}
				}
			})]
		},{
			title:'입력정보',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '입고번호',
				xtype: 'uniTextfield',
				name:'INOUT_NUM',
				readOnly: isAutoInoutNum,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('INOUT_NUM', newValue);
					}
				}
			},{
				fieldLabel: '화폐',
				name: 'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B004',
				allowBlank: true,
				hidden: true,
				displayField: 'value',
				holdable: 'hold',
				fieldStyle: 'text-align: center;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('MONEY_UNIT', newValue);
//						UniAppManager.app.fnExchngRateO();
					},
					blur: function( field, The, eOpts )	{
					   UniAppManager.app.fnExchngRateO();
					}
				}
			},{
				fieldLabel: '환율',
				name:'EXCHG_RATE_O',
				xtype: 'uniNumberfield',
				allowBlank: true,
				hidden: true,
				holdable: 'hold',
				decimalPrecision: 4,
				value: 1,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('EXCHG_RATE_O', newValue);
					}
				}
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
			},{
				name:'CHANNEL',
				hidden: true
			},{
				name:'AUTO_LOT_NO',
				hidden: true
			}]
		}],
		setAllFieldsReadOnly: setAllFieldsReadOnly

	});//End of var masterForm = Unilite.createSearchForm('searchForm', {

	var panelResult2 = Unilite.createSearchForm('resultForm2',{
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				holdable: 'hold',
				child: 'WH_CODE',
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
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '거래처',
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				allowBlank: true,
				hidden:true,
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
							masterForm.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
							masterForm.setValue('EXCHG_RATE_O', '1');
							masterForm.setValue('CUSTOM_CODE', panelResult2.getValue('CUSTOM_CODE'));
							masterForm.setValue('CUSTOM_NAME', panelResult2.getValue('CUSTOM_NAME'));
							panelResult2.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
							panelResult2.setValue('EXCHG_RATE_O', '1');
							masterForm.setValue('CHANNEL', records[0]["CHANNEL"]);
							UniAppManager.app.fnExchngRateO();
							UniAppManager.app.fnAutoLotNo(UniDate.getDbDateStr(masterForm.getValue('INOUT_DATE')));	   //LOT채번
						},
						scope: this
					},
					onClear: function(type)	{
						masterForm.setValue('CUSTOM_CODE', '');
						masterForm.setValue('CUSTOM_NAME', '');
						masterForm.setValue('CHANNEL', '');
						masterForm.setValue('AUTO_LOT_NO', '');
						gsCertType = '';
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
					}
				}
			}),
			{
				fieldLabel: '입고창고',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
//				allowBlank: false,
				holdable: 'hold',
				child: 'WH_CELL_CODE',
				listConfig:{minWidth:230},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '입고창고Cell',
				name: 'WH_CELL_CODE',
				xtype:'uniCombobox',
				store: Ext.data.StoreManager.lookup('whCellList'),
				holdable: 'hold',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						masterForm.setValue('WH_CELL_CODE', newValue);
					}
				}
			}/*,{
				fieldLabel: '입고창고 Cell',
				holdable:'hold',
				name: 'WH_CELL_CODE',
				hidden:!sumtypeCell,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('WH_CELL_CODE', newValue);
					}
				}
			}*/,
			{
				fieldLabel: '입고일',
				name: 'INOUT_DATE',
				xtype: 'uniDatefield',
			   	value: UniDate.get('today'),
			 	allowBlank: false,
			 	holdable: 'hold',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('INOUT_DATE', newValue);
						UniAppManager.app.fnAutoLotNo(UniDate.getDbDateStr(newValue));	   //LOT채번
					}
				}
			},{
				fieldLabel: '입고담당',
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
				fieldLabel: '입고번호',
				xtype: 'uniTextfield',
				name:'INOUT_NUM',
				readOnly: isAutoInoutNum
			},{
				fieldLabel: '생성경로',
				name: 'CREATE_LOC',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B031',
				allowBlank: true,
				hidden:true,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('CREATE_LOC', newValue);
					}
				}
			},
			Unilite.popup('Employee', {
				fieldLabel: '사원',
				valueFieldName:'PERSON_NUMB',
				textFieldName:'PERSON_NAME',
				hidden: gsGwYn,
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							masterForm.setValue('PERSON_NUMB', panelResult2.getValue('PERSON_NUMB'));
							masterForm.setValue('PERSON_NAME', panelResult2.getValue('PERSON_NAME'));},
						scope: this
					},
					onClear: function(type) {
						masterForm.setValue('PERSON_NUMB', '');
						masterForm.setValue('PERSON_NAME', '');
					}
				}
			}),{
				xtype: 'component',
				colspan: 4/*,
				tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' }*/
			},{
				fieldLabel: '화폐',
				name: 'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B004',
				allowBlank: true,
				hidden:true,
				displayField: 'value',
				holdable: 'hold',
				fieldStyle: 'text-align: center;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('MONEY_UNIT', newValue);
//						UniAppManager.app.fnExchngRateO();
					},
					blur: function( field, The, eOpts )	{
					   UniAppManager.app.fnExchngRateO();
					}
				}
			},{
				fieldLabel: '환율',
				name:'EXCHG_RATE_O',
				xtype: 'uniNumberfield',
				allowBlank: true,
				hidden:true,
				holdable: 'hold',
				decimalPrecision: 4,
				colspan: 2,
				value: 1,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('EXCHG_RATE_O', newValue);
					}
				}
			}],
			setAllFieldsReadOnly: setAllFieldsReadOnly
	});

	var inoutNoSearch = Unilite.createSearchForm('inoutNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items: [
			{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				child:'WH_CODE',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = inoutNoSearch.getField('INOUT_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						var field2 = inoutNoSearch.getField('WH_CODE');
						field2.getStore().clearFilter(true);
					}
				}
			},{
				fieldLabel: '입고창고',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
			},
				Unilite.popup('AGENT_CUST',{
				fieldLabel: '거래처',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				validateBlank: false,
				listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
					}
				}
			}),
			{
				fieldLabel: '입고담당',
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
			},
			{
				fieldLabel: '입고일',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},{
				fieldLabel: '입고창고',
				name: 'WH_CELL_CODE',
				hidden:true
			},{
				fieldLabel: '생성경로',
				name: 'CREATE_LOC',
				hidden:true
			}]
	}); // createSearchForm

	var noreceiveSearch = Unilite.createSearchForm('noreceiveForm', {//미입고참조
		layout:  {type : 'uniTable', columns : 3},
		items: [
		{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			readOnly:true,
			child:'WH_CODE',
			value: UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = noreceiveSearch.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					var field2 = noreceiveSearch.getField('WH_CODE');
					field2.getStore().clearFilter(true);
				}
			}
		},{
			fieldLabel: '납기일',
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_ESTI_DATE',
			endFieldName: 'TO_ESTI_DATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315,
			allowBlank:false
		},
			Unilite.popup('AGENT_CUST', {
			fieldLabel: '거래처',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			readOnly: true,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				}
			}
		}),{
			fieldLabel: '발주창고',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('whList')
		},{
			fieldLabel: '구매담당',
			name: 'INOUT_PRSN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M201',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
				//	combo.filterByRefCode('refCode4', newValue, eOpts.parent);
				}else{
				//	combo.divFilterByRefCode('refCode4', newValue, divCode);
				}
			}
		},{
			fieldLabel: '발주형태',
			name: 'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M001',
			value:'1'
		},{
			fieldLabel: '생성경로',
			name: 'CREATE_LOC',
			hidden:true
		}]
	});

	var returnpossibleSearch = Unilite.createSearchForm('returnpossibleForm', {//반품가능발주참조
			layout :  {type : 'uniTable', columns : 2},
			items :[{
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				readOnly:true
			},{
				fieldLabel: '발주일',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank:false
			},
				Unilite.popup('AGENT_CUST',{
				fieldLabel: '거래처',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				validateBlank: false,
				readOnly: true,
				listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
					}
				}
			}),{
				fieldLabel: '발주형태',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M001',
				value:'1'
			},{
				fieldLabel: '생성경로',
				name: 'CREATE_LOC',
				hidden:true
			}]
	});

	//입고참조
	var receiveSearch = Unilite.createSearchForm('receiveSearchForm', {
			layout :  {type : 'uniTable', columns : 3},
			items :[{
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				readOnly:true
			},{
				fieldLabel: '입고일',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank:false
			},
				Unilite.popup('AGENT_CUST',{
				fieldLabel: '거래처',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				validateBlank: false,
				readOnly: true,
				listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
					}
				}
			}),{
				fieldLabel: '생성경로',
				name: 'CREATE_LOC',
				hidden: true
			}]
	});


//	var scmRefSearch = Unilite.createSearchForm('scmRefForm', {//업체출고 참조(SCM)
//			layout :  {type : 'uniTable', columns : 4},
//			items :[{
//				fieldLabel: '출고일',
//				xtype: 'uniDateRangefield',
//				startFieldName: 'FR_INOUT_DATE',
//				endFieldName: 'TO_INOUT_DATE',
//				startDate: UniDate.get('startOfMonth'),
//				endDate: UniDate.get('today'),
//				width: 315,
//				allowBlank:true
//			},
//			{
//				fieldLabel: '발주형태',
//				name: 'ORDER_TYPE',
//				xtype: 'uniCombobox',
//				comboType: 'AU',
//				comboCode: 'M001',
//				value:'1'
//			},{
//				fieldLabel: '발주창고',
//				name: 'WH_CODE',
//				xtype: 'uniCombobox',
//				store: Ext.data.StoreManager.lookup('whList')
//			},{
//				fieldLabel: '생성경로',
//				name: 'CREATE_LOC',
//				hidden:true
//			}]
//	});

	var inspectresultSearch = Unilite.createSearchForm('inspectresultForm', {//검사결과참조
			layout :  {type : 'uniTable', columns : 4},
			items :[{
				fieldLabel: '납기일',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DVRY_DATE',
				endFieldName: 'TO_DVRY_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank:true
			},
			{
				fieldLabel: '발주형태',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M001'
			},{
				fieldLabel: '발주창고',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
			},{
				fieldLabel: '생성경로',
				name: 'CREATE_LOC',
				hidden:true
			}]
	});

	var panelResult = Unilite.createSearchForm('detailForm', { //createForm
		disabled: false,
		border:true,
		padding: '1',
		region: 'center',
		autoScroll: true,
		masterGrid: masterGrid,
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
	});		// end of var panelResult = Unilite.createSearchForm('resultForm',{

	var masterGrid = Unilite.createGrid('s_mms515ukrv_ypGrid1', {
		// for tab
		layout: 'fit',
		region: 'center',
		excelTitle: '입고등록',
		uniOpt: {
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			copiedRow		: true,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		tbar: [{
			xtype: 'button',
			text: '지급결의등록',
			margin:'0 0 0 100',
			hidden: true,
			handler: function() {
				if(directMasterStore1.count() == 0){
				   return false;
				}
				var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
				if(needSave) {
					alert(Msg.sMB154); //먼저 저장하십시오.
					return false;
				}
				var params = {
					action:'select',
					'PGM_ID'		  : 's_mms515ukrv_yp',
					'DIV_CODE'		: masterForm.getValue('DIV_CODE'),
					'CUSTOM_CODE'	 : masterForm.getValue('CUSTOM_CODE'),
					'CUSTOM_NAME'	 : masterForm.getValue('CUSTOM_NAME'),
					'MONEY_UNIT'	  : masterForm.getValue('MONEY_UNIT'),
					'INOUT_DATE'	  : UniDate.getDbDateStr(masterForm.getValue('INOUT_DATE')),
					'WH_CODE'		 : masterForm.getValue('WH_CODE'),
					'INOUT_PRSN'	  : masterForm.getValue('INOUT_PRSN'),
					'CREATE_LOC'	  : masterForm.getValue('CREATE_LOC'),
					'INOUT_NUM'	   : masterForm.getValue('INOUT_NUM'),
					'ORDER_TYPE'	  : directMasterStore1.data.items[0].get('ORDER_TYPE')
				}
				var rec1 = {data : {prgID : 'map100ukrv', 'text':'지급결의등록'}};
				parent.openTab(rec1, '/matrl/map100ukrv.do', params);
			}
		},{
			xtype: 'splitbutton',
		   	itemId:'orderTool',
			text: '참조...',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'noreceiveBtn',
					text: '미입고참조',
					hidden:true,
					handler: function() {
						if(BsaCodeInfo.gsGwYn == 'Y' && Ext.isEmpty(panelResult2.getValue('PERSON_NUMB'))) {
							alert('사원은 필수 입니다.');
							return false;
						} else {
							openNoReceiveWindow();
						}
					}
				}/*,{
					itemId: 'returnpossibleBtn',
					text: '반품가능발주참조',
					handler: function() {
						if(BsaCodeInfo.gsGwYn == 'Y' && Ext.isEmpty(panelResult2.getValue('PERSON_NUMB'))) {
							alert('사원은 필수 입니다.');
							return false;
						} else {
							openReturnPossibleWindow();
						}
					}
				}*/,{
					itemId: 'receiveBtn',
					text: '반품가능입고참조',
				    hidden:true,
					handler: function() {
						if(BsaCodeInfo.gsGwYn == 'Y' && Ext.isEmpty(panelResult2.getValue('PERSON_NUMB'))) {
							alert('사원은 필수 입니다.');
							return false;
						} else {
							openReceiveWindow();
						}
					}
				},{
					itemId	: 'excelBtn',
					text	: '엑셀참조',
					handler	: function() {
						openExcelWindow();
					}
				}/*,{
					itemId: 'inspectresultBtn',
					text: '검사결과참조',
					handler: function() {
						if(BsaCodeInfo.gsGwYn == 'Y' && Ext.isEmpty(panelResult2.getValue('PERSON_NUMB'))) {
							alert('사원은 필수 입니다.');
							return false;
						} else {
							openInspectResultWindow();
						}
					}
				}*//*,{
					itemId: 'scmRefBtn',
					text: '업체출고 참조(SCM)',
					handler: function() {
						opeScmRefWindow();
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
			showSummaryRow: true
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'INOUT_SEQ'  			, width:57 , align:'center'},
			{dataIndex: 'INOUT_TYPE_DETAIL'  	, width:100, align:'center'},
			{dataIndex: 'INOUT_CODE'  			, width:100  ,hidden: false,
	              'editor': Unilite.popup('AGENT_CUST_G',{
	                    textFieldName : 'CUSTOM_CODE',
	                    DBtextFieldName : 'CUSTOM_CODE',
	                    autoPopup:true,
	                    listeners: { 'onSelected': {
	                        fn: function(records, type  ){

	                          	  var grdRecord = masterGrid.uniOpt.currentRecord;
	                          	  var channel = '';
	                          	  var customCode = '';
	                          	  var autoLotNo = '';

	                            	    grdRecord.set('INOUT_CODE',records[0]['CUSTOM_CODE']);
			                            grdRecord.set('INOUT_NAME',records[0]['CUSTOM_NAME']);
			                            channel = records[0]["CHANNEL"];
			                            customCode = records[0]['CUSTOM_CODE'];
			                            autoLotNo = UniAppManager.app.fnAutoLotNoNew(UniDate.getDbDateStr(masterForm.getValue('INOUT_DATE')), channel, customCode );	   //LOT채번

	                        },
	                        scope: this
	                      },
	                      'onClear' : function(type)    {
	                            var grdRecord = masterGrid.uniOpt.currentRecord;
	                            grdRecord.set('INOUT_CODE','');
	                            grdRecord.set('INOUT_NAME','');
	                            grdRecord.set('LOT_NO','');
	                            //gsCertType = '';

	                      },
	                  	applyextparam: function(popup){
	                  		popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
							popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
	                    }
	                    }
	                })},
			{dataIndex: 'INOUT_NAME'  			, width:150   ,hidden: false,
	  	              'editor': Unilite.popup('AGENT_CUST_G',{
		                    textFieldName : 'CUSTOM_CODE',
		                    DBtextFieldName : 'CUSTOM_CODE',
		                    autoPopup:true,
		                    listeners: { 'onSelected': {
		                        fn: function(records, type  ){

		                          	  var grdRecord = masterGrid.uniOpt.currentRecord;
		                          	  var channel = '';
		                          	  var customCode = '';
		                          	  var autoLotNo = '';
		                            	    grdRecord.set('INOUT_CODE',records[0]['CUSTOM_CODE']);
				                            grdRecord.set('INOUT_NAME',records[0]['CUSTOM_NAME']);
				                            channel = records[0]["CHANNEL"];
				                            customCode = records[0]['CUSTOM_CODE'];
				                            autoLotNo = UniAppManager.app.fnAutoLotNoNew(UniDate.getDbDateStr(masterForm.getValue('INOUT_DATE')), channel, customCode );	   //LOT채번

		                        },
		                        scope: this
		                      },
		                      'onClear' : function(type)    {
		                            var grdRecord = masterGrid.uniOpt.currentRecord;
		                            grdRecord.set('INOUT_CODE','');
		                            grdRecord.set('INOUT_NAME','');
		                            grdRecord.set('LOT_NO','');
		                            //gsCertType = '';

		                      },
			                  	applyextparam: function(popup){
			                  		popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
									popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
			                    }
	  	              		}
		                })},
			{dataIndex: 'ITEM_CODE'			, width:130 ,
					editor: Unilite.popup('DIV_PUMOK_G', {
						textFieldName: 'ITEM_CODE',
						DBtextFieldName: 'ITEM_CODE',
						extParam: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
						autoPopup: true,
						listeners: {
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
							applyextparam: function(popup){
								popup.setExtParam({'SELMODEL': 'MULTI'});
								popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
								popup.setExtParam({'DIV_CODE': Ext.getCmp("searchForm").getValue("DIV_CODE")});
							}
						}
					})
				},
			{dataIndex: 'ITEM_NAME'				 , width: 180,
				editor: Unilite.popup('DIV_PUMOK_G', {
					extParam: {SELMODEL: 'MULTI'},
					autoPopup: true,
					listeners: {
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
						'onClear': function(type) {
							masterGrid.setItemData(null,true);
						},
						applyextparam: function(popup){
							popup.setExtParam({'SELMODEL': 'MULTI'});
							popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': Ext.getCmp("searchForm").getValue("DIV_CODE")});
						}
					}
				})
			},
			{dataIndex: 'SPEC'				  , width:150 },
			{dataIndex: 'MONEY_UNIT' 			, width:88  ,align: 'center', hidden: true},
			{dataIndex: 'EXCHG_RATE_O' 			, width:88 , hidden: true },
			{dataIndex: 'ORDER_UNIT_Q'		  , width:100 ,summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT'		 	, width:80  ,align: 'center'},
			{dataIndex: 'ORDER_UNIT_FOR_P'	  , width:100 },
			{dataIndex: 'ORDER_UNIT_FOR_O'	  , width:100 ,summaryType: 'sum'},
			{dataIndex: 'CERT_TYPE'	 		, width:100},
			{dataIndex: 'LOT_NO'				, width:120 ,hidden: sumtypeLot/*,
				getEditor: function(record) {
					return getLotPopupEditor(sumtypeLot);
				}*/
			},
			{dataIndex: 'WH_CODE'			   , width:80   },
			//20171205 추가
			{dataIndex: 'FARM_CODE'			 , width:80   ,
				editor: Unilite.popup('FARM_INOUT_G', {
					textFieldName	: 'FARM_CODE',
					DBtextFieldName	: 'FARM_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.getSelectedRecord();
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										grdRecord.set('FARM_CODE'	, record.FARM_CODE);
										grdRecord.set('FARM_NAME'	, record.FARM_NAME);
										if(record.ORDER_UNIT_Q != 0 && !Ext.isEmpty(record.ORDER_UNIT_Q)) {
											grdRecord.set('ORDER_UNIT_Q', record.ORDER_UNIT_Q);
										}
										grdRecord.set('CERT_TYPE'	, record.CERT_TYPE);
										if(!Ext.isEmpty(record.FARM_CODE)) {
											var newLotNo = grdRecord.get('LOT_NO').substring(0, 7) + record.FARM_CODE + grdRecord.get('CERT_TYPE');
											grdRecord.set('LOT_NO'		, newLotNo);
										}
										caluator(grdRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										var newRecord	= masterGrid.getSelectedRecord();
										var columns		= masterGrid.getColumns();
										Ext.each(columns, function(column, index)	{
											newRecord.set(column.initialConfig.dataIndex, grdRecord.get(column.initialConfig.dataIndex));
										});
										var inoutSeq	= directMasterStore1.max('INOUT_SEQ')+1;
//										var basisSeq	= directMasterStore1.max('BASIS_SEQ')+1;
//										var orderSeq	= directMasterStore1.max('ORDER_SEQ')+1;
										newRecord.set('INOUT_SEQ'	, inoutSeq);
//										newRecord.set('BASIS_SEQ'	, basisSeq);
//										newRecord.set('ORDER_SEQ'	, orderSeq);
										newRecord.set('FARM_CODE'	, record.FARM_CODE);
										newRecord.set('FARM_NAME'	, record.FARM_NAME);
										newRecord.set('ORDER_UNIT_Q', record.ORDER_UNIT_Q);
										newRecord.set('CERT_TYPE'	, record.CERT_TYPE);
										if(!Ext.isEmpty(record.FARM_CODE)) {
											var newLotNo = newRecord.get('LOT_NO').substring(0, 7) + record.FARM_CODE + newRecord.get('CERT_TYPE');
											newRecord.set('LOT_NO'		, newLotNo);
										}
										caluator(newRecord);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('FARM_CODE'	, '');
							grdRecord.set('FARM_NAME'	, '');
							grdRecord.set('ORDER_UNIT_Q', 0);
							grdRecord.set('CERT_TYPE'	, gsCertType);
							grdRecord.set('LOT_NO'		, masterForm.getValue('AUTO_LOT_NO') + '00' + grdRecord.get('CERT_TYPE'));
						},
						applyextparam: function(popup){
							var record = masterGrid.getSelectedRecord();
							if(!Ext.isEmpty(record)) {
								popup.setExtParam({'SELMODEL'		: 'MULTI'});
								popup.setExtParam({'POPUP_TYPE'		: 'GRID_CODE'});
								popup.setExtParam({'CUSTOM_CODE'	: record.get('INOUT_CODE')});
								popup.setExtParam({'CUSTOM_NAME'	: record.get('INOUT_NAME')});
								popup.setExtParam({'ITEM_CODE'		: record.get('ITEM_CODE')});
								popup.setExtParam({'ITEM_NAME'		: record.get('ITEM_NAME')});
								popup.setExtParam({'ORDER_UNIT_Q'	: record.get('ORDER_UNIT_Q')});
								popup.setExtParam({'ORDER_UNIT'		: record.get('ORDER_UNIT')});
							}
						}
					}
				})
			},
			{dataIndex: 'FARM_NAME'			 , width:110		,
				editor: Unilite.popup('FARM_INOUT_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.getSelectedRecord();
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										grdRecord.set('FARM_CODE'	, record.FARM_CODE);
										grdRecord.set('FARM_NAME'	, record.FARM_NAME);
										if(record.ORDER_UNIT_Q != 0 && !Ext.isEmpty(record.ORDER_UNIT_Q)) {
											grdRecord.set('ORDER_UNIT_Q', record.ORDER_UNIT_Q);
										}
										grdRecord.set('CERT_TYPE'	, record.CERT_TYPE);
										if(!Ext.isEmpty(record.FARM_CODE)) {
											var newLotNo = grdRecord.get('LOT_NO').substring(0, 7) + record.FARM_CODE + grdRecord.get('CERT_TYPE');
											grdRecord.set('LOT_NO'		, newLotNo);
										}
										caluator(grdRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										var newRecord	= masterGrid.getSelectedRecord();
										var columns		= masterGrid.getColumns();
										Ext.each(columns, function(column, index)	{
											newRecord.set(column.initialConfig.dataIndex, grdRecord.get(column.initialConfig.dataIndex));
										});
										var inoutSeq	= directMasterStore1.max('INOUT_SEQ')+1;
//										var basisSeq	= directMasterStore1.max('BASIS_SEQ')+1;
//										var orderSeq	= directMasterStore1.max('ORDER_SEQ')+1;
										newRecord.set('INOUT_SEQ'	, inoutSeq);
//										newRecord.set('BASIS_SEQ'	, basisSeq);
//										newRecord.set('ORDER_SEQ'	, orderSeq);
										newRecord.set('FARM_CODE'	, record.FARM_CODE);
										newRecord.set('FARM_NAME'	, record.FARM_NAME);
										newRecord.set('ORDER_UNIT_Q', record.ORDER_UNIT_Q);
										newRecord.set('CERT_TYPE'	, record.CERT_TYPE);
										if(!Ext.isEmpty(record.FARM_CODE)) {
											var newLotNo = newRecord.get('LOT_NO').substring(0, 7) + record.FARM_CODE + newRecord.get('CERT_TYPE');
											newRecord.set('LOT_NO'		, newLotNo);
										}
										caluator(newRecord);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('FARM_CODE'	, '');
							grdRecord.set('FARM_NAME'	, '');
							grdRecord.set('ORDER_UNIT_Q', 0);
							grdRecord.set('CERT_TYPE'	, gsCertType);
							grdRecord.set('LOT_NO'		, masterForm.getValue('AUTO_LOT_NO') + '00' + grdRecord.get('CERT_TYPE'));
						},
						applyextparam: function(popup){
							var record = masterGrid.getSelectedRecord();
							if(!Ext.isEmpty(record)) {
								popup.setExtParam({'SELMODEL'		: 'MULTI'});
								popup.setExtParam({'POPUP_TYPE'		: 'GRID_CODE'});
								popup.setExtParam({'CUSTOM_CODE'	: masterForm.getValue('CUSTOM_CODE')});
								popup.setExtParam({'CUSTOM_NAME'	: masterForm.getValue('CUSTOM_NAME')});
								popup.setExtParam({'ITEM_CODE'		: record.get('ITEM_CODE')});
								popup.setExtParam({'ITEM_NAME'		: record.get('ITEM_NAME')});
								popup.setExtParam({'ORDER_UNIT_Q'	: record.get('ORDER_UNIT_Q')});
								popup.setExtParam({'ORDER_UNIT'		: record.get('ORDER_UNIT')});
							}
						}
					}
				})
			},
			{dataIndex: 'WONSANGI_NUM'		  , width:100},
			//여기까지
			{dataIndex: 'STOCK_UNIT'  			, width:88  ,align: 'center'},
			{dataIndex: 'TRNS_RATE'			 , width:88  ,maxLength:12},
			{dataIndex: 'INOUT_Q'  				, width:100 ,summaryType: 'sum'},
			{dataIndex: 'PRICE_YN'			  , width:100, hidden: false },
			{dataIndex: 'ACCOUNT_YNC' 			, width:88  },
			{dataIndex: 'ORDER_TYPE' 			, width:88  },
			{dataIndex: 'ORDER_NUM' 			, width:120 },
			{dataIndex: 'ORDER_SEQ'  			, width:57  ,align: 'center'},
			{dataIndex: 'ITEM_STATUS'  			, width:80  },
			{dataIndex: 'REMARK'  				, width:188 ,maxLength:200},
			{dataIndex: 'LOT_YN'				, width:120, hidden: true },
			{dataIndex: 'WH_CELL_CODE'		  , width:100,  hidden:sumtypeCell},

			{dataIndex: 'ORDER_UNIT_P'		  , width:100, hidden: true },
			{dataIndex: 'ORDER_UNIT_I'		  , width:100 ,summaryType: 'sum', hidden: true},
			{dataIndex: 'INOUT_P' 		   		, width:115, hidden: true },
			{dataIndex: 'INOUT_I' 		   		, width:100 ,summaryType: 'sum', hidden: true },
			{dataIndex: 'TRANS_COST' 			, width:88, hidden: true  },
			{dataIndex: 'TARIFF_AMT' 			, width:88, hidden: true  },
			{dataIndex: 'BL_NUM'  				, width:88  ,maxLength:20, hidden: true},
			{dataIndex: 'PROJECT_NO'  			, width:120, hidden: true ,
				getEditor : function(record){
					return getPjtNoPopupEditor();
				}
			},
			{dataIndex: 'TRADE_LOC' 			, width:88, hidden: true  },

			{dataIndex: 'INOUT_NUM'				, width:110  ,hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'		, width:80   ,hidden: true},
			{dataIndex: 'LC_NUM'  				, width:100  ,hidden: true},
			{dataIndex: 'INOUT_PRSN'  			, width:100  ,hidden: true},
			{dataIndex: 'ACCOUNT_Q'  			, width:80   ,hidden: true},
			{dataIndex: 'CREATE_LOC'  			, width:80   ,hidden: true},
			{dataIndex: 'SALE_C_DATE'  			, width:100  ,hidden: true},
			{dataIndex: 'ITEM_ACCOUNT'  		, width:100  ,hidden: true},
			{dataIndex: 'INOUT_TYPE'  			, width:100  ,hidden: true},

			{dataIndex: 'DIV_CODE'  			, width:80   ,hidden: true},
			{dataIndex: 'INOUT_DATE'  			, width:100  ,hidden: true},
			{dataIndex: 'INOUT_METH'		 	, width:80   ,hidden: true},
			{dataIndex: 'ORDER_Q'  				, width:80   ,hidden: true},
			{dataIndex: 'GOOD_STOCK_Q'	   	, width:100  ,hidden: true},
			{dataIndex: 'BAD_STOCK_Q'			, width:100  ,hidden: true},
			{dataIndex: 'ORIGINAL_Q'		 	, width:100  ,hidden: true},
			{dataIndex: 'NOINOUT_Q'  			, width:80   ,hidden: true},
			{dataIndex: 'COMPANY_NUM'  			, width:80   ,hidden: true},
			{dataIndex: 'INSPEC_NUM' 			, width:88   ,hidden: true},
			{dataIndex: 'INSPEC_SEQ' 			, width:88   ,hidden: true},
			{dataIndex: 'INOUT_FOR_P' 			, width:80   ,hidden: true},
			{dataIndex: 'INOUT_FOR_O' 			, width:80   ,hidden: true},
			{dataIndex: 'INSTOCK_Q'  			, width:80   ,hidden: true},
			{dataIndex: 'SALE_DIV_CODE'			, width:80   ,hidden: true},
			{dataIndex: 'SALE_CUSTOM_CODE' 		, width:80   ,hidden: true},
			{dataIndex: 'BILL_TYPE'		   		, width:80   ,hidden: true},
			{dataIndex: 'SALE_TYPE'		   		, width:80   ,hidden: true},
			{dataIndex: 'UPDATE_DB_USER'		, width:80   ,hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'		, width:80   ,hidden: true},
			{dataIndex: 'EXCESS_RATE'			, width:80   ,hidden: true},
			{dataIndex: 'BASIS_NUM'  			, width:80   ,hidden: true},
			{dataIndex: 'BASIS_SEQ'  			, width:80   ,hidden: true},
			{dataIndex: 'SCM_FLAG_YN'  			, width:80   ,hidden: true},
			{dataIndex: 'STOCK_CARE_YN' 		, width:88   ,hidden: true},
			{dataIndex: 'COMP_CODE'  			, width:80   ,hidden: true},
			{dataIndex: 'INSERT_DB_USER'  		, width:80   ,hidden: true},
			{dataIndex: 'INSERT_DB_TIME'	 	, width:80   ,hidden: true},
			{dataIndex: 'FLAG'				  , width:80   ,hidden: true},
			{dataIndex: 'PERSON_NUMB'		   , width:80   ,hidden: true}
		],

		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.data.ACCOUNT_Q != '0'){
					return false;
				}
				if(e.record.data.ORDER_NUM != ''){
					if(UniUtils.indexOf(e.field, ['BL_NUM'])){
						if(e.record.data.ORDER_TYPE != '3'){
							return true;
						}else{
							return false;
						}
					}
					if(UniUtils.indexOf(e.field, ['TRNS_RATE'])){
						if(e.record.data.ORDER_UNIT != e.record.data.STOCK_UNIT){
							return true;
						}else{
							return false;
						}
					}
					if(UniUtils.indexOf(e.field, ['ACCOUNT_YNC','ORDER_UNIT_Q','INOUT_SEQ' ,'FARM_CODE','FARM_NAME', 'WONSANGI_NUM'
												 //2018.04.10 수주등록 된 데이터도 주문수량 변경가능하도록 수정 (단순 변경만 가능하도록 수정)
												 ,'ORDER_UNIT'
												 ,'WH_CELL_CODE','INOUT_I','INOUT_P','PRICE_YN','INOUT_CODE','INOUT_NAME'])){
						return true;
					}
					if(UniUtils.indexOf(e.field, ['ITEM_STATUS'])){
						if(BsaCodeInfo.gsProcessFlag == "PG"){
							return false;
						}else{
							return true;
						}
					}
					if(UniUtils.indexOf(e.field, ['CERT_TYPE','LOT_NO','ORDER_UNIT_P','ORDER_UNIT_I','ORDER_UNIT_FOR_P' , 'WH_CODE'
												 ,'ORDER_UNIT_FOR_O','REMARK','PROJECT_NO','TRANS_COST','TARIFF_AMT'])){
						return true;
					}
					if(e.record.data.FLAG == 'FLAG') {
						if(UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL'])){
							return false;
						}
					} else {
						if(UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL'])){
							return true;
						}
					}
				}else{
					if(UniUtils.indexOf(e.field, ['BL_NUM'])){
						if(e.record.data.ORDER_TYPE != '3'){
							return true;
						}else{
							return false;
						}
					}
					if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','INOUT_METH'/*,'WH_CODE'*/,'FARM_CODE','FARM_NAME'
												 ,'WH_CELL_CODE','ORDER_TYPE','INOUT_SEQ'])){
						if(e.record.phantom == true){
							return true;
						}
						return false;
					}
					if(UniUtils.indexOf(e.field, ['INOUT_P','ORDER_UNIT_Q','INOUT_I','ACCOUNT_YNC' , 'WH_CODE'
												 ,'PRICE_YN', 'WONSANGI_NUM'])){
						return true;
					}
					if(UniUtils.indexOf(e.field, ['ITEM_STATUS'])){
						if(BsaCodeInfo.gsProcessFlag == "PG"){
							return false;
						}else{
							return true;
						}
					}
					if(UniUtils.indexOf(e.field, ['CERT_TYPE','LOT_NO','ORDER_UNIT_P','ORDER_UNIT_I','ORDER_UNIT_FOR_P'
												 ,'ORDER_UNIT_FOR_O','ORDER_UNIT','REMARK','PROJECT_NO','TRANS_COST','TARIFF_AMT','INOUT_CODE','INOUT_NAME'])){
						return true;
					}
					if(UniUtils.indexOf(e.field, ['TRNS_RATE'])){
						if(e.record.data.ORDER_UNIT != e.record.data.STOCK_UNIT){
							return true;
						}else{
							return false;
						}
					}
					if(e.record.data.FLAG == 'FLAG') {
						if(UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL'])){
							return false;
						}
					} else {
						if(UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL'])){
							return true;
						}
					}
				}
				return false;
			},
			beforePasteRecord: function(rowIndex, record) {
				if(!UniAppManager.app.checkForNewDetail()) return false;
				var seq = directMasterStore1.max('INOUT_SEQ');
				if(!seq) seq = 1;
				else  seq += 1;
				record.INOUT_SEQ = seq;

				return true;
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			var grdRecord = this.getSelectedRecord();
	   		if(dataClear) {
	   			grdRecord.set('ITEM_CODE'			, "");
	   			grdRecord.set('ITEM_NAME'			, "");
	   			grdRecord.set('SPEC'				, "");
				grdRecord.set('STOCK_UNIT'			, "");
				grdRecord.set('ORDER_UNIT'			, "");
				grdRecord.set('TRNS_RATE'			, 0);
				grdRecord.set('ITEM_ACCOUNT'		, "");

				grdRecord.set('STOCK_Q'				, "");
				grdRecord.set('GOOD_STOCK_Q'		, "");
				grdRecord.set('BAD_STOCK_Q'			, "");

				grdRecord.set('LOT_YN'				, '');
				grdRecord.set('ORDER_UNIT_Q'		, '');
				grdRecord.set('WH_CODE'				, masterForm.getValue('WH_CODE'));
	   		} else {
	   			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
	   			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
	   			grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
				grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
				grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);

				grdRecord.set('LOT_YN'				, record['LOT_YN']);
				grdRecord.set('ORDER_UNIT_Q'		, record['ORDER_UNIT_Q']);
				grdRecord.set('WH_CODE'				, record['WH_CODE']);

				var param = {
					"ITEM_CODE"   : record['ITEM_CODE'],
					"CUSTOM_CODE" : masterForm.getValue('CUSTOM_CODE'),
					"DIV_CODE"	: masterForm.getValue('DIV_CODE'),
					"MONEY_UNIT"  : masterForm.getValue('MONEY_UNIT'),
					"ORDER_UNIT"  : record['ORDER_UNIT'],
					"INOUT_DATE"  : masterForm.getValue('INOUT_DATE')
				};
				s_mms515ukrv_ypService.fnOrderPrice(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
//						if(provider['PURCHASE_TYPE'] && provider['PURCHASE_TYPE'] != ''){
//							grdRecord.set('PURCHASE_RATE'   , provider['PURCHASE_RATE']);
//						}else{
//							grdRecord.set('PURCHASE_RATE'   , '0');
//						}
						if(provider['SALES_TYPE'] && provider['SALES_TYPE'] != ''){
							grdRecord.set('SALES_TYPE'   , provider['SALES_TYPE']);
						}else{
							grdRecord.set('SALES_TYPE'   , '0');
						}

						grdRecord.set('ORDER_UNIT_FOR_P', provider['ORDER_P']);
						grdRecord.set('ORDER_UNIT_P'	, (provider['ORDER_P'] * grdRecord.get('EXCHG_RATE_O')));
						grdRecord.set('INOUT_FOR_P'	 , (provider['ORDER_P'] / grdRecord.get('TRNS_RATE')));
						grdRecord.set('INOUT_P'		 , (provider['ORDER_P'] / grdRecord.get('TRNS_RATE') * grdRecord.get('EXCHG_RATE_O')));
					}
				})

	   			UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );
	   		}
		},
		setNoreceiveData:function(record){
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('INOUT_TYPE'			,'1');
			grdRecord.set('INOUT_METH'			,'1');
			grdRecord.set('INOUT_NUM'			, masterForm.getValue('INOUT_NUM'));
			grdRecord.set('INOUT_TYPE_DETAIL'	, gsInoutTypeDetail);//gsInoutTypeDetail ?확인필요
			grdRecord.set('INOUT_CODE_TYPE'		, '4');
			grdRecord.set('INOUT_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, masterForm.getValue('CUSTOM_NAME'));
			grdRecord.set('INOUT_DATE'			, masterForm.getValue('INOUT_DATE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ITEM_STATUS'			, '1');
			grdRecord.set('ACCOUNT_Q'			, '0');
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			if(record['TRNS_RATE'] == '0'){
				grdRecord.set('TRNS_RATE'		, '1');
			}else{
				grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			}
			grdRecord.set('ORDER_UNIT_Q'		, record['REMAIN_Q']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_FOR_O'	, record['ORDER_UNIT_P'] * record['REMAIN_Q']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_LOC_P']);
			grdRecord.set('ORDER_UNIT_I'		, record['ORDER_LOC_P'] * record['REMAIN_Q']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('INOUT_Q'				, record['NOINOUT_Q']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('NOINOUT_Q'			, record['NOINOUT_Q']);
			grdRecord.set('INOUT_I'				, record['ORDER_LOC_P'] * record['REMAIN_Q']);
			grdRecord.set('ACCOUNT_YNC'			, 'Y');
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('INOUT_P'				, isNaN(grdRecord.get('INOUT_I')/ grdRecord.get('INOUT_Q'))?0:grdRecord.get('INOUT_I')/ grdRecord.get('INOUT_Q'));
			grdRecord.set('INOUT_FOR_O'			, record['ORDER_UNIT_P'] * record['REMAIN_Q']);
			grdRecord.set('INOUT_FOR_P'			, isNaN(grdRecord.get('INOUT_FOR_O') / grdRecord.get('INOUT_Q'))?0:grdRecord.get('INOUT_FOR_O')/ grdRecord.get('INOUT_Q'));
			if(record['EXCHG_RATE_O'] == '0' || record['EXCHG_RATE_O'] == '1'){
				grdRecord.set('EXCHG_RATE_O'	, masterForm.getValue('EXCHG_RATE_O'));
			}else{
				grdRecord.set('EXCHG_RATE_O'	, record['EXCHG_RATE_O']);
			}
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('LC_NUM'				, record['LC_NUM']);
			grdRecord.set('BL_NUM'				, record['BL_NO']);
			grdRecord.set('WH_CODE'				, record['WH_CODE']);
//			grdRecord.set('WH_CODE'				, masterForm.getValue('WH_CODE'));
			grdRecord.set('WH_CELL_CODE'		, masterForm.getValue('WH_CELL_CODE'));
			grdRecord.set('INOUT_PRSN'			, masterForm.getValue('INOUT_PRSN'));
			grdRecord.set('COMPANY_NUM'			, BsaCodeInfo.gsCompanyNum);// gsCompanyNum 확인필요
			grdRecord.set('INSTOCK_Q'			, record['INSTOCK_Q']);
			grdRecord.set('PRICE_YN'			, record['UNIT_PRICE_TYPE']);
			grdRecord.set('BASIS_NUM'			, record['BASIS_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['BASIS_SEQ']);
			grdRecord.set('TRADE_LOC'			, record['TRADE_LOC']);
			grdRecord.set('GOOD_STOCK_Q'		, record['GOOD_STOCK_Q']);
			grdRecord.set('BAD_STOCK_Q'			, record['BAD_STOCK_Q']);
			grdRecord.set('ORIGINAL_Q'			, '0');
			if(masterForm.getValue('DIV_CODE') == ''){
				grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			}else{
				grdRecord.set('DIV_CODE'		, masterForm.getValue('DIV_CODE'));
			}
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('EXCESS_RATE'			, record['EXCESS_RATE']);
			grdRecord.set('LOT_YN'			  , record['LOT_YN']);
//			grdRecord.set('LOT_NO'			  , record['LOT_NO']);
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');

			if(masterForm.getValue("CREATE_LOC") == "2"){
				grdRecord.set('CREATE_LOC'		, "2");
			}else{
				grdRecord.set('CREATE_LOC'		, "6");
			}
			UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE'));
		},
		setReturnPossibleData:function(record){
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('INOUT_TYPE'			,'1');
			grdRecord.set('INOUT_METH'			,'1');
			grdRecord.set('INOUT_NUM'			, masterForm.getValue('INOUT_NUM'));
			grdRecord.set('INOUT_TYPE_DETAIL'	, '90');
			grdRecord.set('INOUT_CODE_TYPE'		, '4');
			grdRecord.set('INOUT_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, masterForm.getValue('CUSTOM_NAME'));
			grdRecord.set('INOUT_DATE'			, masterForm.getValue('INOUT_DATE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ITEM_STATUS'			, '1');
			grdRecord.set('ACCOUNT_Q'			, '0');
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			if(record['TRNS_RATE'] == '0'){
				grdRecord.set('TRNS_RATE') = '1'
			}else{
				grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			}
			grdRecord.set('ORDER_UNIT_Q'		, record['REMAIN_Q']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_FOR_O'	, record['ORDER_UNIT_P'] * record['REMAIN_Q']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_LOC_P']);
			grdRecord.set('ORDER_UNIT_I'		, record['ORDER_LOC_P'] * record['REMAIN_Q']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('INOUT_Q'				, record['NOINOUT_Q']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('NOINOUT_Q'			, record['NOINOUT_Q']);
			grdRecord.set('INOUT_I'				, record['ORDER_LOC_P'] * record['REMAIN_Q']);
			grdRecord.set('ACCOUNT_YNC'			, 'Y');
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('INOUT_P'				, isNaN(grdRecord.get('INOUT_I')/ grdRecord.get('INOUT_Q'))?0:grdRecord.get('INOUT_I')/ grdRecord.get('INOUT_Q'));
			grdRecord.set('INOUT_FOR_O'			, record['ORDER_UNIT_P'] * record['REMAIN_Q']);
			grdRecord.set('INOUT_FOR_P'			, isNaN(grdRecord.get('INOUT_FOR_O') / grdRecord.get('INOUT_Q'))?0:grdRecord.get('INOUT_FOR_O')/ grdRecord.get('INOUT_Q'));
			grdRecord.set('EXCHG_RATE_O'		, masterForm.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('LC_NUM'				, record['LC_NUM']);
			grdRecord.set('BL_NUM'				, record['BL_NO']);
			grdRecord.set('WH_CODE'				, record['WH_CODE']);
			grdRecord.set('WH_CELL_CODE'		, masterForm.getValue('WH_CELL_CODE'));
			grdRecord.set('INOUT_PRSN'			, masterForm.getValue('INOUT_PRSN'));
			grdRecord.set('COMPANY_NUM'			, BsaCodeInfo.gsCompanyNum);// gsCompanyNum 확인필요
			grdRecord.set('INSTOCK_Q'			, record['INSTOCK_Q']);
			grdRecord.set('PRICE_YN'			, record['UNIT_PRICE_TYPE']);
			grdRecord.set('BASIS_NUM'			, record['BASIS_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['BASIS_SEQ']);
			grdRecord.set('TRADE_LOC'			, record['TRADE_LOC']);
			grdRecord.set('ORIGINAL_Q'			, '0');
			if(masterForm.getValue('DIV_CODE') == ''){
				grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			}else{
				grdRecord.set('DIV_CODE'		, masterForm.getValue('DIV_CODE'));
			}
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('EXCESS_RATE'			, record['EXCESS_RATE']);
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');

			if(masterForm.getValue("CREATE_LOC") == "2"){
				grdRecord.set('CREATE_LOC'		, "2");
			}else{
				grdRecord.set('CREATE_LOC'		, "6");
			}
			grdRecord.set('LOT_NO'		  , record['LOT_NO']);
			UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE'));
		},
		setInspectData:function(record){
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('INOUT_TYPE'			,'1');
			grdRecord.set('INOUT_METH'			,'1');
			grdRecord.set('INOUT_NUM'			, masterForm.getValue('INOUT_NUM'));
			grdRecord.set('INOUT_TYPE_DETAIL'	, gsInoutTypeDetail);//BsaCodeInfo.gsInoutTypeDetail);//gsInoutTypeDetail ?확인필요
			grdRecord.set('INOUT_CODE_TYPE'		, '4');
			grdRecord.set('INOUT_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, masterForm.getValue('CUSTOM_NAME'));
			grdRecord.set('INOUT_DATE'			, masterForm.getValue('INOUT_DATE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ITEM_STATUS'			, record['ITEM_STATUS']);
			grdRecord.set('ACCOUNT_Q'			, '0');
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			if(record['TRNS_RATE'] == '0'){
				grdRecord.set('TRNS_RATE') = '1'
			}else{
				grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			}
			grdRecord.set('ORDER_UNIT_Q'		, record['NOINOUT_Q']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_FOR_O'	, record['ORDER_UNIT_P'] * record['NOINOUT_Q']);
//			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_LOC_P']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P']);   //자사단가

			grdRecord.set('ORDER_UNIT_I'		, record['ORDER_LOC_P'] * record['REMAIN_Q']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('INOUT_Q'				, record['NOINOUT_Q'] * record['TRNS_RATE']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('NOINOUT_Q'			, record['NOINOUT_Q'] * record['TRNS_RATE']);
			grdRecord.set('ACCOUNT_YNC'			, 'Y');
//			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);

			grdRecord.set('INOUT_FOR_O'			, record['ORDER_UNIT_P'] * record['REMAIN_Q']);
			grdRecord.set('INOUT_FOR_P'			, grdRecord.get('INOUT_FOR_O') / grdRecord.get('INOUT_Q'));
//			if(record['EXCHG_RATE_O'] == 0 || record['EXCHG_RATE_O'] == 1){
				grdRecord.set('EXCHG_RATE_O'	, masterForm.getValue('EXCHG_RATE_O'));
//			}else{
//				grdRecord.set('EXCHG_RATE_O'	, record['EXCHG_RATE_O']);
//			}

			grdRecord.set('INOUT_I'			 , record['ORDER_UNIT_P']);	//자사단가

			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('LC_NUM'				, record['LC_NO']);
			grdRecord.set('BL_NUM'				, record['BL_NO']);
			grdRecord.set('WH_CODE'				, masterForm.getValue('WH_CODE'));
			grdRecord.set('WH_CELL_CODE'		, masterForm.getValue('WH_CELL_CODE'));
			grdRecord.set('INOUT_PRSN'			, masterForm.getValue('INOUT_PRSN'));
			grdRecord.set('COMPANY_NUM'			, BsaCodeInfo.gsCompanyNum);// gsCompanyNum 확인필요
			grdRecord.set('INSTOCK_Q'			, record['INSTOCK_Q']);
			grdRecord.set('PRICE_YN'			, record['UNIT_PRICE_TYPE']);
			grdRecord.set('BASIS_NUM'			, record['BASIS_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['BASIS_SEQ']);
			grdRecord.set('TRADE_LOC'			, record['TRADE_LOC']);
			grdRecord.set('GOOD_STOCK_Q'		, record['GOOD_STOCK_Q']);
			grdRecord.set('BAD_STOCK_Q'			, record['BAD_STOCK_Q']);
			grdRecord.set('ORIGINAL_Q'			, '0');
			if(masterForm.getValue('DIV_CODE') == ''){
				grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			}else{
				grdRecord.set('DIV_CODE'		, masterForm.getValue('DIV_CODE'));
			}
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, '');
			grdRecord.set('EXCESS_RATE'			, record['EXCESS_RATE']);
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');

			grdRecord.set('INSPEC_NUM'			, record['INSPEC_NUM']);
			grdRecord.set('INSPEC_SEQ'			, record['INSPEC_SEQ']);


//			grdRecord.set('PURCHASE_TYPE'		, !record['PURCHASE_TYPE']?'0':record['PURCHASE_TYPE']);
			grdRecord.set('SALES_TYPE'			, record['SALES_TYPE']);
			grdRecord.set('SALE_BASIS_P'		, record['SALE_BASIS_P']);
			grdRecord.set('LOT_NO'			  , record['LOT_NO']);
			grdRecord.set('LOT_YN'			  , record['LOT_YN']);

			//ORDER_UNIT_P

//			grdRecord.set('PURCHASE_RATE'		, record['PURCHASE_RATE']);
			masterForm.setValue('CUSTOM_CODE'	, record['CUSTOM_CODE']);
			masterForm.setValue('CUSTOM_NAME'	, record['CUSTOM_NAME']);
			panelResult2.setValue('CUSTOM_CODE'	, record['CUSTOM_CODE']);
			panelResult2.setValue('CUSTOM_NAME'	, record['CUSTOM_NAME']);

			var param = {
				"COMP_CODE": UserInfo.compCode,
				"ITEM_CODE": record['ITEM_CODE']
			};

			s_mms515ukrv_ypService.taxType(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
				grdRecord.set('TAX_TYPE', provider['TAX_TYPE']);
				}
			});

			directMasterStore1.fnSumAmountI();
		},
		setScmRefData:function(record){
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('INOUT_TYPE'			,'1');
			grdRecord.set('INOUT_METH'			,'1');
			grdRecord.set('INOUT_NUM'			, masterForm.getValue('INOUT_NUM'));
			grdRecord.set('INOUT_TYPE_DETAIL'	, gsInoutTypeDetail);//gsInoutTypeDetail ?확인필요
			grdRecord.set('INOUT_CODE_TYPE'		, '4');
			grdRecord.set('INOUT_CODE'			, masterForm.getValue('CUSTOM_CODE'));
			grdRecord.set('CUSTOM_NAME'			, masterForm.getValue('CUSTOM_NAME'));
			grdRecord.set('CREATE_LOC'			, '2');
			grdRecord.set('INOUT_DATE'			, masterForm.getValue('INOUT_DATE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ITEM_STATUS'			, '1');
			grdRecord.set('ACCOUNT_Q'			, '0');
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			if(record['TRNS_RATE'] == '0'){
				grdRecord.set('TRNS_RATE') = '1'
			}else{
				grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			}
			grdRecord.set('ORDER_UNIT_Q'		, record['INOUT_Q']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['INOUT_P']);
			grdRecord.set('ORDER_UNIT_FOR_O'	, record['INOUT_P'] * record['INOUT_Q']);
			grdRecord.set('ORDER_UNIT_P'		, record['INOUT_P'] * masterForm.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_UNIT_I'		, record['INOUT_P'] * record['INOUT_Q'] * masterForm.getValue('EXCHG_RATE_O'));
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('INOUT_Q'				, record['INOUT_Q']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('NOINOUT_Q'			, record['INOUT_Q'] * record['TRNS_RATE']);
			grdRecord.set('INOUT_I'				, record['INOUT_P'] * record['INOUT_Q']);
			grdRecord.set('ACCOUNT_YNC'			, 'Y');
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('INOUT_P'				, record['ORDER_UNIT_P'] / record['TRNS_RATE']);
			grdRecord.set('INOUT_FOR_O'			, record['INOUT_P'] * record['INOUT_Q']);
			grdRecord.set('INOUT_FOR_P'			, isNaN(grdRecord.get('INOUT_FOR_O') / grdRecord.get('INOUT_Q'))?0:grdRecord.get('INOUT_FOR_O')/ grdRecord.get('INOUT_Q'));
			grdRecord.set('EXCHG_RATE_O'		, masterForm.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('ORDER_Q'				, '0');
			grdRecord.set('LC_NUM'				, '');
			grdRecord.set('WH_CODE'				, masterForm.getValue('WH_CODE'));
			grdRecord.set('WH_CELL_CODE'		, masterForm.getValue('WH_CELL_CODE'));
			grdRecord.set('INOUT_PRSN'			, masterForm.getValue('INOUT_PRSN'));
			grdRecord.set('COMPANY_NUM'			, BsaCodeInfo.gsCompanyNum);// gsCompanyNum 확인필요
			grdRecord.set('INSTOCK_Q'			, '0');
			grdRecord.set('PRICE_YN'			, 'Y');
			grdRecord.set('SCM_FLAG_YN'			, 'Y');
			grdRecord.set('ORIGINAL_Q'			, '0');
			grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, '');
			grdRecord.set('EXCESS_RATE'			, '');
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');
			grdRecord.set('BASIS_NUM'			, record['INOUT_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['INOUT_SEQ']);

			UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE'));
		},setExcelData: function(record) {

			var grdRecord = this.getSelectedRecord();
			var whCode = masterForm.getValue('WH_CODE');
        	grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('INOUT_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('INOUT_NAME'			, record['CUSTOM_NAME']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('ORDER_UNIT'			, record['STOCK_UNIT']);
			if(record['TRNS_RATE'] == '0'){
				grdRecord.set('TRNS_RATE') = '1'
			}else{
				grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			}
			grdRecord.set('INOUT_Q'			, record['INOUT_Q']);
			grdRecord.set('ORDER_UNIT_Q'		, record['INOUT_Q']);
			grdRecord.set('NOINOUT_Q'			, record['INOUT_Q'] * record['TRNS_RATE']);
			grdRecord.set('ORDER_Q'				, '0');
			grdRecord.set('INSTOCK_Q'			, '0');
			grdRecord.set('ORIGINAL_Q'			, '0');
			grdRecord.set('ACCOUNT_Q'			, '0');
			grdRecord.set('EXCHG_RATE_O'		, 1);
			grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');
			grdRecord.set('ORDER_UNIT_FOR_P'			,record['PRICE']);
			if(Ext.isEmpty(whCode)){
				grdRecord.set('WH_CODE', 'WH003');
			}else{
				grdRecord.set('WH_CODE', whCode);
			}
			grdRecord.set('INOUT_TYPE_DETAIL'			,'15');

			grdRecord.set('ORDER_UNIT_FOR_O', grdRecord.get('ORDER_UNIT_Q') * grdRecord.get('ORDER_UNIT_FOR_P'));
			grdRecord.set('INOUT_FOR_O',(grdRecord.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
			if(grdRecord.get('INOUT_Q') != 0){
				grdRecord.set('INOUT_FOR_P',(grdRecord.get('INOUT_FOR_O') / grdRecord.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
			}

			grdRecord.set('INOUT_P',record['PRICE']);
			grdRecord.set('ORDER_UNIT_P',record['PRICE']);
			grdRecord.set('ORDER_UNIT_I',(grdRecord.get('ORDER_UNIT_Q') * grdRecord.get('ORDER_UNIT_P')));	//자사금액 = 입고량 * 자사단가

			grdRecord.set('INOUT_FOR_P',record['PRICE']);
				grdRecord.set('INOUT_P',record['PRICE']);
				grdRecord.set('INOUT_I', (grdRecord.get('ORDER_UNIT_P') * grdRecord.get('ORDER_UNIT_Q'))); // 자사단가(ORDER_UNIT_P)

			var  channel = record["CHANNEL"];
            var  customCode = record['CUSTOM_CODE'];
            autoLotNo = UniAppManager.app.fnAutoLotNoNewExcel(UniDate.getDbDateStr(masterForm.getValue('INOUT_DATE')), channel, customCode, grdRecord );	   //LOT채번

        }
	});//End of var masterGrid = Unilite.createGrid('s_mms515ukrv_ypGrid1', {

	var inoutNoMasterGrid = Unilite.createGrid('s_mms515ukrv_ypinoutNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
		layout : 'fit',
		excelTitle: '입고등록(입고번호검색)',
		store: inoutNoMasterStore,
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false
		},
		columns:  [
			{ dataIndex: 'INOUT_NAME'	   			,  width:166},
			{ dataIndex: 'INOUT_DATE'	   			,  width:86},
			{ dataIndex: 'INOUT_CODE'	   			,  width:120,hidden:true},
			{ dataIndex: 'WH_CODE'		  			,  width:100},
			{ dataIndex: 'WH_CELL_CODE'	 			,  width:120,hidden:!sumtypeCell},
			{ dataIndex: 'DIV_CODE'		 			,  width:100},
			{ dataIndex: 'INOUT_PRSN' 		 			,  width:100, align: 'center'},
			{ dataIndex: 'INOUT_NUM'					,  width:126, align: 'center'},
			{ dataIndex: 'MONEY_UNIT'	   			,  width:53, align: 'center',hidden:true},
			{ dataIndex: 'EXCHG_RATE_O'	 			,  width:53,hidden:true},
			{ dataIndex: 'CREATE_LOC'	   			,  width:53,hidden:true},
			{ dataIndex: 'PERSON_NUMB'				  ,  width:53,hidden:true},
			{ dataIndex: 'PERSON_NAME'				  ,  width:53,hidden:true},
			{ dataIndex: 'CHANNEL'			   		,  width:53,hidden:true}

		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				inoutNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
				masterForm.setAllFieldsReadOnly(true);
				panelResult2.setAllFieldsReadOnly(true);
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
//		  		'WH_CODE':record.get('WH_CODE'),
		  		'CUSTOM_CODE':record.get('INOUT_CODE'),
		  		'CUSTOM_NAME':record.get('INOUT_NAME'),
		  		'EXCHG_RATE_O':record.get('EXCHG_RATE_O'),
		  		'MONEY_UNIT':record.get('MONEY_UNIT'),
		  		'INOUT_PRSN':record.get('INOUT_PRSN'),
		  		'CREATE_LOC':record.get('CREATE_LOC'),
				'PERSON_NUMB':record.get('PERSON_NUMB'),
				'PERSON_NAME':record.get('PERSON_NAME'),
				'CHANNEL':record.get('CHANNEL')
		  	});
		  	panelResult2.setValues({
		  		'DIV_CODE':record.get('DIV_CODE'),
		  		'INOUT_DATE':record.get('INOUT_DATE'),
		  		'INOUT_NUM':record.get('INOUT_NUM'),
//		  		'WH_CODE':record.get('WH_CODE'),
		  		'CUSTOM_CODE':record.get('INOUT_CODE'),
		  		'CUSTOM_NAME':record.get('INOUT_NAME'),
		  		'EXCHG_RATE_O':record.get('EXCHG_RATE_O'),
		  		'MONEY_UNIT':record.get('MONEY_UNIT'),
		  		'INOUT_PRSN':record.get('INOUT_PRSN'),
		  		'CREATE_LOC':record.get('CREATE_LOC'),
				'PERSON_NUMB':record.get('PERSON_NUMB'),
				'PERSON_NAME':record.get('PERSON_NAME')
		  	});
			UniAppManager.app.fnAutoLotNo(UniDate.getDbDateStr(masterForm.getValue('INOUT_DATE')));	   //LOT채번
		  	if(BsaCodeInfo.gsSumTypeCell!='Y'){
		  		masterForm.setValue('WH_CELL_CODE', record.get('WH_CELL_CODE'));
		  		panelResult2.setValue('WH_CELL_CODE', record.get('WH_CELL_CODE'));
		  	}
		  }
	});

	var noreceiveGrid = Unilite.createGrid('s_mms515ukrv_ypNoreceiveGrid', {//미입고참조
		layout : 'fit',
		excelTitle: '입고등록(미입고참조)',
		store: noReceiveStore,
		uniOpt: {
			onLoadSelectFirst : false,
			useGroupSummary: true,
			useLiveSearch: true
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns:  [
			{ dataIndex: 'GUBUN'				,  width:33,locked:true,hidden:true},
			{ dataIndex: 'ITEM_CODE'			,  width:120,locked:true},
			{ dataIndex: 'ITEM_NAME'			,  width:150,locked:true},
			{ dataIndex: 'ITEM_ACCOUNT'			,  width:120,hidden:true},
			{ dataIndex: 'SPEC'					,  width:150},
			{ dataIndex: 'DVRY_DATE'			,  width:86},
			{ dataIndex: 'DIV_CODE'				,  width:80,hidden:true},
			{ dataIndex: 'ORDER_UNIT'			,  width:66,align:"center"},
			{ dataIndex: 'ORDER_UNIT_Q'			,  width:100,hidden:true},
			{ dataIndex: 'REMAIN_Q'				,  width:100,summaryType: 'sum'},
			{ dataIndex: 'STOCK_UNIT'			,  width:53,hidden:true,align:"center"},
			{ dataIndex: 'NOINOUT_Q'			,  width:100,hidden:true},
			{ dataIndex: 'ORDER_Q'				,  width:100,hidden:true},
			{ dataIndex: 'UNIT_PRICE_TYPE'		,  width:100},
			{ dataIndex: 'MONEY_UNIT'			,  width:66,align:"center"},
			{ dataIndex: 'EXCHG_RATE_O'			,  width:90},
			{ dataIndex: 'ORDER_P'				,  width:93,hidden:true},
			{ dataIndex: 'ORDER_UNIT_P'			,  width:100},
			{ dataIndex: 'ORDER_O'				,  width:100,summaryType: 'sum'},
			{ dataIndex: 'ORDER_LOC_P'			,  width:100},
			{ dataIndex: 'ORDER_LOC_O'			,  width:100,summaryType: 'sum'},
			{ dataIndex: 'ORDER_NUM'			,  width:120},
			{ dataIndex: 'ORDER_SEQ'			,  width:66,align:"center"},
			{ dataIndex: 'LC_NUM'				,  width:33,hidden:true},
			{ dataIndex: 'WH_CODE'				,  width:33,hidden:true},
			{ dataIndex: 'ORDER_REQ_NUM'		,  width:33,hidden:true},
			{ dataIndex: 'ORDER_TYPE'			,  width:33,hidden:true},
			{ dataIndex: 'CUSTOM_CODE'			,  width:60,hidden:true},
			{ dataIndex: 'TRNS_RATE'			,  width:80,hidden:true},
			{ dataIndex: 'INSTOCK_Q'			,  width:80,hidden:true},
			{ dataIndex: 'REMARK'				,  width:150},
			{ dataIndex: 'PROJECT_NO'			,  width:120},
			{ dataIndex: 'EXCESS_RATE'			,  width:80,hidden:true},
			{ dataIndex: 'ORDER_PRSN'			,  width:100},
			{ dataIndex: 'GOOD_STOCK_Q'			,  width:66,hidden:true},
			{ dataIndex: 'BAD_STOCK_Q'			,  width:66,hidden:true},
			{ dataIndex: 'LC_NO'				,  width:66,hidden:true},
			{ dataIndex: 'BL_NO'				,  width:66,hidden:true},
			{ dataIndex: 'BASIS_NUM'			,  width:66,hidden:true},
			{ dataIndex: 'BASIS_SEQ'			,  width:53,hidden:true},
			{ dataIndex: 'LC_DATE'				,  width:66,hidden:true},
			{ dataIndex: 'INVOICE_DATE'			,  width:66,hidden:true},
			{ dataIndex: 'TRADE_LOC'			,  width:53,hidden:true},
			{ dataIndex: 'LOT_NO'			   ,  width:53},
			{ dataIndex: 'LOT_YN'			   ,  width:53,hidden: true}
		  ],
		listeners: {
	  		onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function()	{
	   		var records = this.getSelectedRecords();

			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setNoreceiveData(record.data);
			});
			this.deleteSelectedRow();
	   	}
	});

	var returnpossibleGrid = Unilite.createGrid('s_mms515ukrv_ypReturnpossibleGrid', {//반품가능발주참조
		layout: 'fit',
		excelTitle: '입고등록(반품가능발주참조)',
		store: returnPossibleStore,
		uniOpt: {
			onLoadSelectFirst : false,
			useGroupSummary: true,
			useLiveSearch: true
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns:  [
			{ dataIndex: 'GUBUN'				,  width:33,locked:true,hidden:true},
			{ dataIndex: 'ITEM_CODE'			,  width:120,locked:true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{ dataIndex: 'ITEM_NAME'			,  width:150,locked:true},
			{ dataIndex: 'ITEM_ACCOUNT'			,  width:120,hidden:true},
			{ dataIndex: 'SPEC'					,  width:150},
			{ dataIndex: 'DVRY_DATE'			,  width:86},
			{ dataIndex: 'DIV_CODE'				,  width:66,hidden:true},
			{ dataIndex: 'ORDER_UNIT'			,  width:80,align:"center"},
			{ dataIndex: 'ORDER_UNIT_Q'			,  width:100,hidden:true},
			{ dataIndex: 'REMAIN_Q'				,  width:100,summaryType: 'sum'},
			{ dataIndex: 'STOCK_UNIT'			,  width:80,hidden:true},
			{ dataIndex: 'NOINOUT_Q'			,  width:100,hidden:true},
			{ dataIndex: 'ORDER_Q'				,  width:113,hidden:true},
			{ dataIndex: 'UNIT_PRICE_TYPE'		,  width:90},
			{ dataIndex: 'MONEY_UNIT'			,  width:80,align:"center"},
			{ dataIndex: 'EXCHG_RATE_O'			,  width:80,hidden:true},
			{ dataIndex: 'ORDER_P'				,  width:93,hidden:true},
			{ dataIndex: 'ORDER_UNIT_P'			,  width:100},
			{ dataIndex: 'ORDER_O'				,  width:100,summaryType: 'sum'},
			{ dataIndex: 'ORDER_LOC_P'			,  width:100},
			{ dataIndex: 'ORDER_LOC_O'			,  width:100,summaryType: 'sum'},
			{ dataIndex: 'ORDER_NUM'			,  width:120},
			{ dataIndex: 'ORDER_SEQ'			,  width:66,align:"center"},
			{ dataIndex: 'LC_NUM'				,  width:80,hidden:true},
			{ dataIndex: 'WH_CODE'				,  width:80,hidden:true},
			{ dataIndex: 'ORDER_REQ_NUM'		,  width:80,hidden:true},
			{ dataIndex: 'ORDER_TYPE'			,  width:80,hidden:true},
			{ dataIndex: 'CUSTOM_CODE'			,  width:60,hidden:true},
			{ dataIndex: 'TRNS_RATE'			,  width:80,hidden:true},
			{ dataIndex: 'INSTOCK_Q'			,  width:80,hidden:true},
			{ dataIndex: 'REMARK'				,  width:133},
			{ dataIndex: 'PROJECT_NO'			,  width:133},
			{ dataIndex: 'EXCESS_RATE'			,  width:80,hidden:true},
			{ dataIndex: 'LC_NO'				,  width:80,hidden:true},
			{ dataIndex: 'BL_NO'				,  width:80,hidden:true},
			{ dataIndex: 'BASIS_NUM'			,  width:80,hidden:true},
			{ dataIndex: 'BASIS_SEQ'			,  width:80,hidden:true},
			{ dataIndex: 'LC_DATE'				,  width:66,hidden:true},
			{ dataIndex: 'INVOICE_DATE'			,  width:66,hidden:true},
			{ dataIndex: 'TRADE_LOC'			,  width:53,hidden:true}
		],
		listeners: {
	  		onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function()	{
	   		var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setReturnPossibleData(record.data);
			});
			this.deleteSelectedRow();
	   	}
	});

	var receiveGrid = Unilite.createGrid('s_mms515ukrv_ypReceiveGrid', {//입고참조
		layout: 'fit',
		excelTitle: '입고등록(입고참조)',
		store: receiveStore,
		uniOpt: {
			onLoadSelectFirst : false,
			useGroupSummary: true,
			useLiveSearch: true
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns:  [
			{ dataIndex: 'GUBUN'				,  width:33,locked:true,hidden:true},
			{ dataIndex: 'ITEM_CODE'			,  width:120,locked:true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{ dataIndex: 'ITEM_NAME'			,  width:150,locked:true},
			{ dataIndex: 'ITEM_ACCOUNT'		 ,  width:120,hidden:true},
			{ dataIndex: 'SPEC'				 ,  width:150},
			{ dataIndex: 'DVRY_DATE'			,  width:86},
			{ dataIndex: 'DIV_CODE'			 ,  width:66,hidden:true},
			{ dataIndex: 'ORDER_UNIT'		   ,  width:80,align:"center"},
			{ dataIndex: 'ORDER_UNIT_Q'		 ,  width:100,hidden:true},
			{ dataIndex: 'REMAIN_Q'			 ,  width:100,summaryType: 'sum'},
			{ dataIndex: 'STOCK_UNIT'		   ,  width:80,hidden:true},
			{ dataIndex: 'NOINOUT_Q'			,  width:100,hidden:true},
			{ dataIndex: 'ORDER_Q'			  ,  width:113,hidden:true},
			{ dataIndex: 'UNIT_PRICE_TYPE'	  ,  width:90},
			{ dataIndex: 'MONEY_UNIT'		   ,  width:80,align:"center"},
			{ dataIndex: 'EXCHG_RATE_O'		 ,  width:80,hidden:true},
			{ dataIndex: 'ORDER_P'			  ,  width:93,hidden:true},
			{ dataIndex: 'ORDER_UNIT_P'		 ,  width:100},
			{ dataIndex: 'ORDER_O'			  ,  width:100,summaryType: 'sum'},
			{ dataIndex: 'ORDER_LOC_P'		  ,  width:100},
			{ dataIndex: 'ORDER_LOC_O'		  ,  width:100,summaryType: 'sum'},
			{ dataIndex: 'ORDER_NUM'			,  width:120},
			{ dataIndex: 'ORDER_SEQ'			,  width:66,align:"center"},
			{ dataIndex: 'LC_NUM'			   ,  width:80,hidden:true},
			{ dataIndex: 'WH_CODE'			  ,  width:80,hidden:true},
			{ dataIndex: 'ORDER_REQ_NUM'		,  width:80,hidden:true},
			{ dataIndex: 'ORDER_TYPE'		   ,  width:80,hidden:true},
			{ dataIndex: 'CUSTOM_CODE'		  ,  width:60,hidden:true},
			{ dataIndex: 'TRNS_RATE'			,  width:80,hidden:true},
			{ dataIndex: 'INSTOCK_Q'			,  width:80,hidden:true},
			{ dataIndex: 'REMARK'			   ,  width:133},
			{ dataIndex: 'PROJECT_NO'		   ,  width:133},
			{ dataIndex: 'EXCESS_RATE'		  ,  width:80,hidden:true},
			{ dataIndex: 'LC_NO'				,  width:80,hidden:true},
			{ dataIndex: 'BL_NO'				,  width:80,hidden:true},
			{ dataIndex: 'BASIS_NUM'			,  width:80,hidden:true},
			{ dataIndex: 'BASIS_SEQ'			,  width:80,hidden:true},
			{ dataIndex: 'LC_DATE'			  ,  width:66,hidden:true},
			{ dataIndex: 'INVOICE_DATE'		 ,  width:66,hidden:true},
			{ dataIndex: 'TRADE_LOC'			,  width:53,hidden:true},
			{ dataIndex: 'LOT_NO'			   ,  width:53,hidden:true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function()  {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setReturnPossibleData(record.data);
			});
			this.deleteSelectedRow();
		}
	});

//	var scmRefGrid= Unilite.createGrid('s_mms515ukrv_ypScmRefGrid1', {//업체출고 참조(SCM)
//		region: 'center' ,
//		layout: 'fit',
//		store: scmRefStore,
//		uniOpt: {
//			onLoadSelectFirst : false,
//			useGroupSummary: true,
//			useLiveSearch: true
//		},
//		features: [{
//			id: 'masterGridSubTotal',
//			ftype: 'uniGroupingsummary',
//			showSummaryRow: true
//		},{
//			id: 'masterGridTotal',
//			ftype: 'uniSummary',
//			showSummaryRow: true
//		}],
//		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
//		columns: [
//	  			{dataIndex:'GUBUN'	 			 		,width:80,hidden:true},
//	  			{dataIndex:'CUSTOM_NAME'	 	 		,width:150},
//	  			{dataIndex:'INOUT_NUM'			 	 	,width:120},
//	  			{dataIndex:'INOUT_SEQ'			 	 	,width:66,align:"center"},
//	  			{dataIndex:'INOUT_DATE'			 	 	,width:86},
//	  			{dataIndex:'CUSTOM_ITEM_CODE'	 	 	,width:120},
//	  			{dataIndex:'ITEM_CODE'			 	 	,width:120},
//	  			{dataIndex:'ITEM_NAME'			 	 	,width:150},
//	  			{dataIndex:'SPEC'				 	 	,width:150},
//	  			{dataIndex:'MONEY_UNIT'			 	 	,width:66,align:"center"},
//	  			{dataIndex:'EXCHG_RATE_O'		 	 	,width:66},
//	  			{dataIndex:'ORDER_UNIT'			 	 	,width:66,align:"center"},
//	  			{dataIndex:'TRNS_RATE'			 	 	,width:66},
//	  			{dataIndex:'INOUT_Q'			 	 	,width:100,summaryType: 'sum'},
//	  			{dataIndex:'INOUT_P'			 	 	,width:100},
//	  			{dataIndex:'INOUT_I'			 	 	,width:100,summaryType: 'sum'},
//	  			{dataIndex:'INOUT_PRSN'			 	 	,width:100},
//	  			{dataIndex:'ORDER_NUM'			 	 	,width:120},
//	  			{dataIndex:'ORDER_SEQ'			 	 	,width:80,align:"center"},
//	  			{dataIndex:'REMARK'				 	 	,width:80},
//	  			{dataIndex:'ITEM_ACCOUNT'		 	 	,width:80,hidden:true},
//	  			{dataIndex:'STOCK_CARE_YN'		 	 	,width:80,hidden:true},
//	  			{dataIndex:'WH_CODE'			 	 	,width:80,hidden:true},
//	  			{dataIndex:'STOCK_UNIT'			 	 	,width:80,hidden:true,align:"center"},
//	  			{dataIndex:'INOUT_FOR_P'		 	 	,width:80,hidden:true},
//	  			{dataIndex:'INOUT_FOR_O'		 	 	,width:80,hidden:true},
//	  			{dataIndex:'ORDER_TYPE'			 	 	,width:80,hidden:true}
//		],
//		listeners: {
//	  		onGridDblClick:function(grid, record, cellIndex, colName) {
//			}
//		},
//		returnData: function()	{
//	   		var records = this.getSelectedRecords();
//			Ext.each(records, function(record,i){
//				UniAppManager.app.onNewDataButtonDown();
//				masterGrid.setScmRefData(record.data);
//			});
//			this.deleteSelectedRow();
//	   	}
//	});

	var inspectresultGrid2 = Unilite.createGrid('s_mms515ukrv_ypInspectResultGrid2', {//검사결과참조
		region: 'east' ,
		layout : 'fit',
		excelTitle: '입고등록(검사결과참조)',
		store: inspectResultStore2,
		uniOpt: {
			onLoadSelectFirst : false,
			useGroupSummary: true,
			useLiveSearch: true
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns:  [
			{dataIndex: 'GUBUN'						, width:80,hidden:true},
			{dataIndex: 'ITEM_CODE'					, width:120,hidden:false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{dataIndex: 'ITEM_NAME'					, width:160,hidden:false},
			{dataIndex: 'SPEC'						, width:150,hidden:false},
			{dataIndex: 'DVRY_DATE'					, width:86,hidden:false},
			{dataIndex: 'INSPEC_DATE'				, width:86,hidden:false},
			{dataIndex: 'ORDER_UNIT'				, width:66,hidden:false,align:"center"},
			{dataIndex: 'ORDER_O'					, width:100,hidden:false,summaryType: 'sum'},
			{dataIndex: 'NOINOUT_Q'					, width:100,hidden:false,summaryType: 'sum'},
			{dataIndex: 'UNIT_PRICE_TYPE'			, width:100,hidden:false},
			{dataIndex: 'MONEY_UNIT'				, width:66,hidden:false,align:"center"},
			{dataIndex: 'ORDER_UNIT_P'				, width:100,hidden:false},
			{dataIndex: 'ORDER_LOC_P'				, width:100,hidden:false},
			{dataIndex: 'ORDER_LOC_O'				, width:100,hidden:false,summaryType: 'sum'},
			{dataIndex: 'ORDER_NUM'					, width:120,hidden:false},
			{dataIndex: 'ORDER_SEQ'					, width:80,hidden:false,align:"center"},
			{dataIndex: 'CUSTOM_CODE'				, width:120,hidden:false},
			{dataIndex: 'CUSTOM_NAME'				, width:150,hidden:false},
			{dataIndex: 'REMAIN_Q'					, width:100,hidden:false,summaryType: 'sum'},
			{dataIndex: 'INSPEC_NUM'				, width:120,hidden:false},
			{dataIndex: 'INSPEC_SEQ'				, width:80,hidden:false,align:"center"},
			{dataIndex: 'PORE_Q'					, width:100,hidden:false,summaryType: 'sum'},
			{dataIndex: 'REMARK'					, width:150,hidden:false},
			{dataIndex: 'LOT_NO'  			   		, width:100,hidden:false},
			{dataIndex: 'LOT_YN'					, width:100,hidden:true},
			{dataIndex: 'ITEM_STATUS'				, width:88,hidden:true},
			{dataIndex: 'EXCHG_RATE_O'				, width:100,hidden:true},
			{dataIndex: 'PROJECT_NO'				, width:100,hidden:true},
			{dataIndex: 'LC_NO'						, width:100,hidden:true},
			{dataIndex: 'BL_NO'						, width:100,hidden:true},
			{dataIndex: 'BASIS_NUM'					, width:120,hidden:true},
			{dataIndex: 'BASIS_SEQ'					, width:66,hidden:true},
			{dataIndex: 'LC_DATE'					, width:86,hidden:true},
			{dataIndex: 'INVOICE_DATE'				, width:86,hidden:true},
			{dataIndex: 'TRADE_LOC'					, width:100,hidden:true},

			{dataIndex: 'ITEM_ACCOUNT'				, width:100,hidden:true},
			{dataIndex: 'LC_NUM'					, width:100,hidden:true},
			{dataIndex: 'WH_CODE'					, width:100,hidden:true},
			{dataIndex: 'ORDER_REQ_NUM'				, width:100,hidden:true},
			{dataIndex: 'DIV_CODE'					, width:100,hidden:true},
			{dataIndex: 'ORDER_TYPE'				, width:100,hidden:true},
			{dataIndex: 'TRNS_RATE'					, width:100,hidden:true},
			{dataIndex: 'STOCK_UNIT'				, width:100,hidden:true},
			{dataIndex: 'ORDER_Q'					, width:100,hidden:true},
			{dataIndex: 'ORDER_UNIT_Q'				, width:100,hidden:true},
			{dataIndex: 'ORDER_P'					, width:100,hidden:true},
			{dataIndex: 'INSTOCK_Q'					, width:100,hidden:true},
			{dataIndex: 'EXCESS_RATE'				, width:100,hidden:true}

		],
		listeners: {
	  		onGridDblClick:function(grid, record, cellIndex, colName) {
			}
	   	},
	   	returnData: function()	{
	   		var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setInspectData(record.data);
			});
			this.getStore().remove(records);
	   	}
	});

	function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '입고번호검색',
				width: 1000,
				height: 500,
				layout: {type:'vbox', align:'stretch'}, //위치 확인 필요
				items: [inoutNoSearch, inoutNoMasterGrid],
				tbar:  ['->',
					{
						itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							inoutNoMasterStore.loadStoreRecords();
						},
						disabled: false
					}, {
						itemId : 'inoutNoCloseBtn',
						text: '닫기',
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
					},
					 beforeclose: function( panel, eOpts )	{
						inoutNoSearch.clearForm();
						inoutNoMasterGrid.reset();
		 			},
					show: function( panel, eOpts )	{
						inoutNoSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
				 		inoutNoSearch.setValue('INOUT_DATE_FR',UniDate.get('startOfMonth'));
				 		inoutNoSearch.setValue('INOUT_DATE_TO',masterForm.getValue('INOUT_DATE'));
				 		inoutNoSearch.setValue('WH_CODE',masterForm.getValue('WH_CODE'));
				 		inoutNoSearch.setValue('CUSTOM_CODE',masterForm.getValue('CUSTOM_CODE'));
				 		inoutNoSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
				 		inoutNoSearch.setValue('INOUT_PRSN',masterForm.getValue('INOUT_PRSN'));
					 }
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}

	function openNoReceiveWindow() {			//미입고참조
  		if(!UniAppManager.app.checkForNewDetail()) return false;

  		noreceiveSearch.setValue('FR_ESTI_DATE', UniDate.get('today'));
  		noreceiveSearch.setValue('TO_ESTI_DATE', UniDate.get('today'));
  		noreceiveSearch.setValue('DIV_CODE', masterForm.getValue('DIV_CODE'));

		if(!referNoReceiveWindow) {
			referNoReceiveWindow = Ext.create('widget.uniDetailWindow', {
				title: '미입고참조',
				width: 1300,
				height: 550,
				layout:{type:'vbox', align:'stretch'},
				items: [noreceiveSearch, noreceiveGrid],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							noReceiveStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'confirmBtn',
						text: '입고적용',
						handler: function() {
							noreceiveGrid.returnData();
						},
						disabled: false
					},
					{
						itemId : 'confirmCloseBtn',
						text: '입고적용 후 닫기',
						handler: function() {
							noreceiveGrid.returnData();
							referNoReceiveWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							if(directMasterStore1.getCount() == 0){
								masterForm.setAllFieldsReadOnly(false);
								panelResult2.setAllFieldsReadOnly(false);
							}
							referNoReceiveWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						noreceiveSearch.clearForm();
						noreceiveGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						noreceiveSearch.clearForm();
						noreceiveGrid.reset();
		 			},
					beforeshow: function ( me, eOpts ){
						noreceiveSearch.setValue('FR_ESTI_DATE',UniDate.get('startOfMonth'), masterForm.getValue("INOUT_DATE"));
	 					noreceiveSearch.setValue('TO_ESTI_DATE',masterForm.getValue("INOUT_DATE"));
  						noreceiveSearch.setValue('ORDER_TYPE', '1');
					 	noreceiveSearch.setValue('WH_CODE',masterForm.getValue('WH_CODE'));
					 	noreceiveSearch.setValue('INOUT_PRSN',masterForm.getValue('INOUT_PRSN'));
					 	noreceiveSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
					 	noreceiveSearch.setValue('CREATE_LOC',masterForm.getValue('CREATE_LOC'));
					 	noreceiveSearch.setValue('CUSTOM_CODE',masterForm.getValue('CUSTOM_CODE'));
					 	noreceiveSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
					 	noReceiveStore.loadStoreRecords();
					}
				}
			})
		}
		referNoReceiveWindow.center();
		referNoReceiveWindow.show();
	}

	function openReturnPossibleWindow() {	   //반품가능발주참조
  		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!referReturnPossibleWindow) {
			referReturnPossibleWindow = Ext.create('widget.uniDetailWindow', {
				title: '반품가능발주참조',
				width: 1300,
				height: 550,
				layout:{type:'vbox', align:'stretch'},
				items: [returnpossibleSearch, returnpossibleGrid],
				tbar:  ['->',
					{
						itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							returnPossibleStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'confirmBtn',
						text: '입고적용',
						handler: function() {
							returnpossibleGrid.returnData();
						},
						disabled: false
					},{
						itemId : 'confirmCloseBtn',
						text: '입고적용 후 닫기',
						handler: function() {
							returnpossibleGrid.returnData();
							referReturnPossibleWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							if(directMasterStore1.getCount() == 0){
								masterForm.setAllFieldsReadOnly(false);
								panelResult2.setAllFieldsReadOnly(false);
							}
							referReturnPossibleWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						returnpossibleSearch.clearForm();
						returnpossibleGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						returnpossibleSearch.clearForm();
						returnpossibleGrid.reset();
		 			},
					beforeshow: function ( me, eOpts )	{
					 	returnpossibleSearch.setValue('CREATE_LOC',masterForm.getValue('CREATE_LOC'));
					 	returnpossibleSearch.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'), masterForm.getValue("INOUT_DATE"));
						returnpossibleSearch.setValue('ORDER_DATE_TO',masterForm.getValue("INOUT_DATE"));
						returnpossibleSearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
						returnpossibleSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
						returnpossibleSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
						returnPossibleStore.loadStoreRecords();

					}
				}
			})
		}
		referReturnPossibleWindow.center();
		referReturnPossibleWindow.show();
	}

	function openReceiveWindow() {	   //입고참조
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!referReceiveWindow) {
			referReceiveWindow = Ext.create('widget.uniDetailWindow', {
				title: '반품가능입고참조',
				width: 1300,
				height: 550,
				layout:{type:'vbox', align:'stretch'},
				items: [receiveSearch, receiveGrid],
				tbar:  ['->',
					{
						itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							receiveStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'confirmBtn',
						text: '입고적용',
						handler: function() {
							receiveGrid.returnData();
						},
						disabled: false
					},{
						itemId : 'confirmCloseBtn',
						text: '입고적용 후 닫기',
						handler: function() {
							receiveGrid.returnData();
							referReceiveWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							if(directMasterStore1.getCount() == 0){
								masterForm.setAllFieldsReadOnly(false);
								panelResult2.setAllFieldsReadOnly(false);
							}
							referReceiveWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)  {
						receiveSearch.clearForm();
						receiveGrid.reset();
					},
					beforeclose: function( panel, eOpts )   {
						receiveSearch.clearForm();
						receiveGrid.reset();
					},
					beforeshow: function ( me, eOpts )  {
						receiveSearch.setValue('INOUT_DATE_FR',UniDate.get('startOfMonth'), masterForm.getValue("INOUT_DATE"));
						receiveSearch.setValue('INOUT_DATE_TO',masterForm.getValue("INOUT_DATE"));
						receiveSearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
						receiveSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
						receiveSearch.setValue('CREATE_LOC',masterForm.getValue('CREATE_LOC'));
						receiveSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
						receiveStore.loadStoreRecords();
					}
				}
			})
		}
		referReceiveWindow.center();
		referReceiveWindow.show();
	}

//	function opeScmRefWindow() {				//업체출고 참조(SCM)
//  		if(!UniAppManager.app.checkForNewDetail()) return false;
//		if(!referScmRefWindow) {
//			referScmRefWindow = Ext.create('widget.uniDetailWindow', {
//				title: '업체출고 참조(SCM)',
//				width: 1000,
//				height: 540,
//				layout:{type:'vbox', align:'stretch'},
//
//				items: [scmRefSearch,scmRefGrid],
//				tbar:  [
//					{	itemId : 'saveBtn',
//						text: '조회',
//						handler: function() {
//							scmRefStore.loadStoreRecords();
//						},
//						disabled: false
//					}
//					,{
//						itemId : 'confirmBtn',
//						text: '입고적용',
//						handler: function() {
//							scmRefGrid.returnData();
//						},
//						disabled: false
//					},
//					{
//						itemId : 'confirmCloseBtn',
//						text: '입고적용 후 닫기',
//						handler: function() {
//							scmRefGrid.returnData();
//							referInspectResultWindow.hide();
//						},
//						disabled: false
//					},'->',{
//						itemId : 'closeBtn',
//						text: '닫기',
//						handler: function() {
//							referScmRefWindow.hide();
//						},
//						disabled: false
//					}
//				],
//				listeners : {
//					beforehide: function(me, eOpt)	{
//					},
//					beforeclose: function( panel, eOpts )	{
//		 			},
//					beforeshow: function ( me, eOpts )	{
//					 	scmRefSearch.setValue('FR_INOUT_DATE',UniDate.get('startOfMonth'), masterForm.getValue("INOUT_DATE"));
//	 					scmRefSearch.setValue('TO_INOUT_DATE',masterForm.getValue("INOUT_DATE"));
//  						scmRefSearch.setValue('ORDER_TYPE', '1');
//					 	scmRefSearch.setValue('WH_CODE',masterForm.getValue('WH_CODE'));
//					 	scmRefSearch.setValue('CREATE_LOC',masterForm.getValue('CREATE_LOC'));
//					 	scmRefStore.loadStoreRecords();
//					}
//				}
//			})
//		}
//		referScmRefWindow.center();
//		referScmRefWindow.show();
//	}

	function openInspectResultWindow() {		//검사결과참조
  		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!referInspectResultWindow) {
			referInspectResultWindow = Ext.create('widget.uniDetailWindow', {
				title: '검사결과참조',
				width: 1000,
				height: 540,
				layout:{type:'vbox', align:'stretch'},

				items: [inspectresultSearch,inspectresultGrid2],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							inspectResultStore2.loadStoreRecords();
						},
						disabled: false
					}
					,{
						itemId : 'confirmBtn',
						text: '입고적용',
						handler: function() {
							inspectresultGrid2.returnData();
						},
						disabled: false
					},
					{
						itemId : 'confirmCloseBtn',
						text: '입고적용 후 닫기',
						handler: function() {
							inspectresultGrid2.returnData();
							referInspectResultWindow.hide();
							inspectresultGrid2.reset();
							inspectresultSearch.clearForm();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							if(directMasterStore1.getCount() == 0){
								masterForm.setAllFieldsReadOnly(false);
								panelResult2.setAllFieldsReadOnly(false);
							}
							inspectresultGrid2.reset();
							inspectresultSearch.clearForm();
							referInspectResultWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						inspectresultSearch.clearForm();
						inspectresultGrid2.reset();
					},
					beforeclose: function( panel, eOpts )	{
						inspectresultSearch.clearForm();
						inspectresultGrid2.reset();
		 			},
					beforeshow: function ( me, eOpts )	{
					 	inspectresultSearch.setValue('FR_DVRY_DATE',UniDate.get('startOfMonth'), masterForm.getValue("INOUT_DATE"));
	 					inspectresultSearch.setValue('TO_DVRY_DATE',masterForm.getValue("INOUT_DATE"));
					 	inspectresultSearch.setValue('CREATE_LOC',masterForm.getValue('CREATE_LOC'));
					 	inspectResultStore2.loadStoreRecords();
					}
				}
			})
		}
		referInspectResultWindow.center();
		referInspectResultWindow.show();
	}
	  // 엑셀참조
    Unilite.Excel.defineModel('excel.s_mms515ukrv_yp.sheet01', {
        fields: [
             	{name: 'CUSTOM_CODE'	   			, text: '거래처코드'		, type: 'string'},
    			{name: 'CUSTOM_NAME'	   			, text: '거래처명'		, type: 'string'},
    			{name: 'ITEM_CODE'	   					, text: '품목'		, type: 'string'},
    			{name: 'ITEM_NAME'		  				, text: '품목명'		, type: 'string'},
    			{name: 'INOUT_Q'		  				, text: '수량'		, type: 'uniQty'},
    			{name: 'TRNS_RATE'	   					, text: '입수'		,type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
    			{name: 'STOCK_UNIT'	   				, text: '재고단위'		, type: 'string'},
    			{name: 'SPEC'	   				, text: '규격'		, type: 'string'},
    			{name: 'PRICE'	   				, text: '단가'		, type: 'uniUnitPrice', defaultValue: 0}
        ]
    });
	 // 엑셀업로드
    function openExcelWindow() {

        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUploadWin';


        if(!excelWindow) {
        	excelWindow =  Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
            		excelConfigName: 's_mms515ukrv_yp',
                    grids: [
                    	 {
                    		itemId: 'grid01',
                    		title: '수매정보',
                    		useCheckbox: true,
                    		model : 'excel.s_mms515ukrv_yp.sheet01',
                    		readApi: 's_mms515ukrv_ypService.selectExcelUploadSheet1',
                    		columns: [
                     		     	 { dataIndex: 'CUSTOM_CODE',  		width: 80}
                     		     	,{ dataIndex: 'CUSTOM_NAME',  		width: 120}
									,{ dataIndex: 'ITEM_CODE',  	width: 80}
									,{ dataIndex: 'ITEM_NAME',  		width: 120}
									,{ dataIndex: 'SPEC',  		width: 120}
									,{ dataIndex: 'INOUT_Q',  		width: 80}
									,{ dataIndex: 'PRICE',  		width: 200}
									,{ dataIndex: 'STOCK_UNIT',  		width: 80}
									,{ dataIndex: 'TRNS_RATE',  		width: 80}
                    		]
                    	}
                    ],
                    listeners: {
                        close: function() {
                            this.hide();
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
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[{
					region : 'center',
					xtype : 'container',
					layout : 'fit',
					items : [ masterGrid ]
				},
				panelResult2,
				{
					region : 'north',
					xtype : 'container',
					highth: 20,
					layout : 'fit',
					items : [ panelResult ]
				}
			]
		},
			masterForm
		],
		id: 's_mms515ukrv_ypApp',
		fnInitBinding: function(params){
			UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);
			this.setDefault();
			cbStore.loadStoreRecords();
			if(!Ext.isEmpty(params && params.PGM_ID)){
				if(!Ext.isEmpty(params.INOUT_NUM)){

					masterForm.setValue('INOUT_NUM', params.INOUT_NUM);
					panelResult2.setValue('INOUT_NUM', params.INOUT_NUM);
					panelResult2.setValue('INOUT_DATE', params.INOUT_DATE);
					panelResult2.setValue('MONEY_UNIT', params.MONEY_UNIT);
					panelResult2.setValue('EXCHG_RATE_O', params.EXCHG_RATE_O);
					panelResult2.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
					panelResult2.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
					//panelResult2.setValue('CREATE_LOC', params.CREATE_LOC);
					UniAppManager.app.onQueryButtonDown();
					panelResult2.setAllFieldsReadOnly(true);

				}
			}
		},
		onQueryButtonDown: function() {
			masterForm.setAllFieldsReadOnly(false);
			var inoutNo = masterForm.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow()
			} else {
				directMasterStore1.loadStoreRecords();
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				 var accountYnc	  = 'Y';
				 var inoutNum		= masterForm.getValue('INOUT_NUM');
				 var seq			 = !directMasterStore1.max('INOUT_SEQ')?1:directMasterStore1.max('INOUT_SEQ')+1
				 var inoutType	   = '1';
				 var inoutCodeType   = '4';
				 var whCode		  = masterForm.getValue('WH_CODE');
				 var whCellCode	  = masterForm.getValue('WH_CELL_CODE');
				 var inoutPrsn	   = masterForm.getValue('INOUT_PRSN');
				 var inoutCode	   = masterForm.getValue('CUSTOM_CODE');
				 var customName	  = masterForm.getValue('CUSTOM_NAME');
				// var createLoc	   = masterForm.getValue('CREATE_LOC');
				 var createLoc	   = 2;
				 var inoutDate	   = masterForm.getValue('INOUT_DATE');
				 var inoutMeth	   = '2';
				 var inoutTypeDetail = BsaCodeInfo.gsInoutTypeDetail; //gsInoutTypeDetail ?? 확인필요
				 var itemStatus	  = '1';
				 var accountQ		= '0';
				 var orderUnitQ	  = '0';
				 var inoutQ		  = '0';
				 var inoutI		  = '0';
				 //var moneyUnit	   = masterForm.getValue('MONEY_UNIT');
				 var moneyUnit	   = 'KRW';
				 var inoutP		  = '0';
				 var inoutForP	   = '0';
				 var inoutForO	   = '0';
				 var originalQ	   = '0';
				 var noinoutQ		= '0';
				 var goodStockQ	  = '0';
				 var badStockQ	   = '0';
				 //var exchgRateO	  = masterForm.getValue('EXCHG_RATE_O');
				 var exchgRateO	  = 1;
				 var trnsRate		= '1';
				 var divCode		 = masterForm.getValue('DIV_CODE');
				 var companyNum	  = BsaCodeInfo.gsCompanyNum; // ??확인필요
				 var saleDivCode	 = '*';
				 var saleCustomCode  = '*';
				 var saleType		= '*';
				 var billType		= '*';
				 var priceYn		 = 'Y';
				 var excessRate	  = '0';
				 var orderType	   = '1';
				 var transCost	   = '0';
				 var tariffAmt	   = '0';
				 var deptCode		= masterForm.getValue('DEPT_CODE');
				 var lotNO		   = masterForm.getValue('AUTO_LOT_NO') + '00';

				if(BsaCodeInfo.gsGwYn == 'Y') {
					 var r = {
					 	ACCOUNT_YNC: 		accountYnc,
					 	INOUT_TYPE:		 inoutType,
					 	INOUT_CODE_TYPE:	inoutCodeType,
					 	WH_CODE:			whCode,
					 	WH_CELL_CODE:	   whCellCode,
					 	INOUT_PRSN:		 inoutPrsn,
					 	INOUT_CODE:		 inoutCode,
					 	CUSTOM_NAME:		customName,
					 	CREATE_LOC:		 createLoc,
					 	INOUT_DATE:		 inoutDate,
					 	INOUT_METH:		 inoutMeth,
					 	INOUT_TYPE_DETAIL:  inoutTypeDetail,
					 	ITEM_STATUS:		itemStatus,
					 	ACCOUNT_Q:		  accountQ,
					 	ORDER_UNIT_Q:	   orderUnitQ,
					 	INOUT_Q:			inoutQ,
					 	INOUT_I:			inoutI,
					 	MONEY_UNIT:		 moneyUnit,
					 	INOUT_P:			inoutP,
					 	INOUT_FOR_P:		inoutForP,
					 	INOUT_FOR_O:		inoutForO,
					 	ORIGINAL_Q:		 originalQ,
					 	NOINOUT_Q:		  noinoutQ,
					 	GOOD_STOCK_Q:	   goodStockQ,
					 	BAD_STOCK_Q:		badStockQ,
					 	EXCHG_RATE_O:	   exchgRateO,
					 	TRNS_RATE:		  trnsRate,
					 	DIV_CODE:		   divCode,
					 	COMPANY_NUM:		companyNum,
					 	SALE_DIV_CODE:	  saleDivCode,
					 	SALE_CUSTOM_CODE:   saleCustomCode,
					 	SALE_TYPE:		  saleType,
					 	BILL_TYPE:		  billType,
					 	PRICE_YN:		   priceYn,
					 	EXCESS_RATE:		excessRate,
					 	ORDER_TYPE:		 orderType,
					 	TRANS_COST:		 transCost,
					 	TARIFF_AMT:		 tariffAmt,
						INOUT_NUM:		  inoutNum,
						INOUT_SEQ:		  seq,
						DEPT_CODE:			deptCode,
						SALES_TYPE:		 0,
						PERSON_NUMB: panelResult2.getValue('PERSON_NUMB'),
						CERT_TYPE:			gsCertType,
						LOT_NO:			 lotNO + gsCertType
	//				  PURCHASE_TYPE:	  0,
	//				  PURCHASE_RATE:	  0
					}
				} else {
					 var r = {
						ACCOUNT_YNC:		accountYnc,
						INOUT_TYPE:		 inoutType,
						INOUT_CODE_TYPE:	inoutCodeType,
						WH_CODE:			whCode,
						WH_CELL_CODE:	   whCellCode,
						INOUT_PRSN:		 inoutPrsn,
						INOUT_CODE:		 inoutCode,
						CUSTOM_NAME:		customName,
						CREATE_LOC:		 createLoc,
						INOUT_DATE:		 inoutDate,
						INOUT_METH:		 inoutMeth,
						INOUT_TYPE_DETAIL:  inoutTypeDetail,
						ITEM_STATUS:		itemStatus,
						ACCOUNT_Q:		  accountQ,
						ORDER_UNIT_Q:	   orderUnitQ,
						INOUT_Q:			inoutQ,
						INOUT_I:			inoutI,
						MONEY_UNIT:		 moneyUnit,
						INOUT_P:			inoutP,
						INOUT_FOR_P:		inoutForP,
						INOUT_FOR_O:		inoutForO,
						ORIGINAL_Q:		 originalQ,
						NOINOUT_Q:		  noinoutQ,
						GOOD_STOCK_Q:	   goodStockQ,
						BAD_STOCK_Q:		badStockQ,
						EXCHG_RATE_O:	   exchgRateO,
						TRNS_RATE:		  trnsRate,
						DIV_CODE:		   divCode,
						COMPANY_NUM:		companyNum,
						SALE_DIV_CODE:	  saleDivCode,
						SALE_CUSTOM_CODE:   saleCustomCode,
						SALE_TYPE:		  saleType,
						BILL_TYPE:		  billType,
						PRICE_YN:		   priceYn,
						EXCESS_RATE:		excessRate,
						ORDER_TYPE:		 orderType,
						TRANS_COST:		 transCost,
						TARIFF_AMT:		 tariffAmt,
						INOUT_NUM:		  inoutNum,
						INOUT_SEQ:		  seq,
						DEPT_CODE:		  deptCode,
						SALES_TYPE:		 0,
						CERT_TYPE:			gsCertType,
						LOT_NO:			 ''
	//				  PURCHASE_TYPE:	  0,
	//				  PURCHASE_RATE:	  0
					}
				}

			if(BsaCodeInfo.gsGwYn == 'Y') {
				if(!Ext.isEmpty(panelResult2.getValue('PERSON_NUMB'))) {
					cbStore.loadStoreRecords(whCode);
					masterGrid.createRow(r, null, masterGrid.getStore().getCount()-1);
				} else {
					alert('사원은 필수입력값 입니다.');
					return false;
				}
			} else {
				cbStore.loadStoreRecords(whCode);
				masterGrid.createRow(r, null, masterGrid.getStore().getCount()-1);
			}
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
//			debugger;
//			if(UniAppManager.app.updateChanges()){
				directMasterStore1.saveStore();
//			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();

			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('ACCOUNT_Q') != 0){
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
						if(record.get('ACCOUNT_Q') != 0){
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
		selectOrderPrice: function(flag, grdRecord, orderUnit){
			var param = {
				'DIV_CODE'		: grdRecord.get("DIV_CODE"),
				'ITEM_CODE'		: grdRecord.get("ITEM_CODE"),
				'ITEM_ACCOUNT'	: grdRecord.get("ITEM_ACCOUNT"),
				'CUSTOM_CODE'	: masterForm.getValue("CUSTOM_CODE"),
				'MONEY_UNIT'	: grdRecord.get("MONEY_UNIT"),
				'ORDER_DATE'	: grdRecord.get("ORDER_DATE"),
				'ORDER_UNIT'	: orderUnit
			}
			s_mms515ukrv_ypService.selectGetOrderPrice(param, function(provider, response){
				if(Ext.isEmpty(provider)) {
					alert(Msg.sMM329);
					return false;

				} else {
					var dExchangeRate = 0;
					if(masterForm.getValue("EXCHG_RATE_O") != ""){
						dExchangeRate = masterForm.getValue("EXCHG_RATE_O")
					}
					if(grdRecord.get("ORDER_UNIT_Q") == ""){
						grdRecord.set("ORDER_UNIT_Q", '0')
					}
					//재고단위 입고량 산출
					if(grdRecord.get("ORDER_UNIT_Q") != "0"){
						grdRecord.set("INOUT_Q", grdRecord.get("ORDER_UNIT_Q") * provider['TRNS_RATE'])
					}

					if(grdRecord.get("ORDER_UNIT_FOR_P") == "" || grdRecord.get("ORDER_UNIT_FOR_P") == "0" || flag == "N") {
						if (provider.ORDER_P != "0") {
							grdRecord.set("ORDER_UNIT_FOR_P", provider.ORDER_P);
							grdRecord.set("ORDER_UNIT_P"	, provider.ORDER_P * dExchangeRate);
						} else {
							grdRecord.set("ORDER_UNIT_FOR_P", 0);
							grdRecord.set("ORDER_UNIT_P"	, 0);
						}
					} else {
						grdRecord.set("ORDER_UNIT_FOR_P", provider.ORDER_P);
						grdRecord.set("ORDER_UNIT_P"	, provider.ORDER_P * dExchangeRate);
					}

					if(provider['TRNS_RATE'] != '0'){
						grdRecord.set("TRNS_RATE", provider['TRNS_RATE'])
					}else{
						grdRecord.set("TRNS_RATE", '1')
					}
					grdRecord.set("ORDER_UNIT"			, provider['ORDER_UNIT'])
					grdRecord.set("STOCK_UNIT"			, provider['STOCK_UNIT'])
					grdRecord.set("ORDER_UNIT_FOR_O"	, grdRecord.get("ORDER_UNIT_FOR_P") * grdRecord.get("ORDER_UNIT_Q"))
					grdRecord.set("ORDER_UNIT_I"		, grdRecord.get("ORDER_UNIT_P") * grdRecord.get("ORDER_UNIT_Q"))
					grdRecord.set("INOUT_FOR_P"			, grdRecord.get("ORDER_UNIT_FOR_P") / grdRecord.get("TRNS_RATE"))
					grdRecord.set("INOUT_P"				, grdRecord.get("ORDER_UNIT_P") / grdRecord.get("TRNS_RATE"))
					grdRecord.set("INOUT_I"				, grdRecord.get("INOUT_P") * grdRecord.get("INOUT_P"))
					grdRecord.set("INOUT_FOR_O"			, grdRecord.get("INOUT_FOR_P") * grdRecord.get("INOUT_Q"))

				}
			})
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('INOUT_NUM')))	{
				alert('<t:message code="unilite.msg.sMS514" default="입고번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}
			if(masterForm.setAllFieldsReadOnly(true)){
				panelResult2.setAllFieldsReadOnly(true);
				return true;
			}
			return false;
		},
		setDefault: function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			panelResult2.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('INOUT_DATE',new Date());
			panelResult2.setValue('INOUT_DATE',new Date());
			masterForm.setValue('CREATE_LOC','2');
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
			var field = masterForm.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult2.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = inoutNoSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = noreceiveSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
//			masterForm.setValue('INOUT_PRSN',BsaCodeInfo.gsInOutPrsn);
//			panelResult2.setValue('INOUT_PRSN',BsaCodeInfo.gsInOutPrsn);
			UniAppManager.app.fnExchngRateO(true);
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
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(masterForm.getValue('INOUT_DATE')),
				"MONEY_UNIT" : masterForm.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(masterForm.getValue('MONEY_UNIT')) && masterForm.getValue('MONEY_UNIT') != "KRW"){
						alert('환율정보가 없습니다.')
					}
					masterForm.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
					panelResult2.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
				}

			});
		},
		cbStockQ: function(provider, params)	{
			var rtnRecord = params.rtnRecord;
			var dStockQ = provider['STOCK_Q'];
			var dGoodStockQ = provider['GOOD_STOCK_Q'];
			var dBadStockQ = provider['BAD_STOCK_Q'];
			rtnRecord.set('STOCK_Q', dStockQ);
			rtnRecord.set('GOOD_STOCK_Q', dGoodStockQ);
			rtnRecord.set('BAD_STOCK_Q', dBadStockQ);
		},
		updateChanges:function(){
//			var saveRecs = directMasterStore1.data.items;
//			var toSave = true;
//			Ext.each(saveRecs, function(saveRec,i) {
//				if(saveRec.get("ORDER_UNIT_Q") == '0' && saveRec.get("INOUT_TYPE_DETAIL") != '91'){
//					alert('<t:message code = "unilite.msg.sMM350"/>');
//					toSave = false
//				}
//				if(!UniAppManager.app.isQtyCheck(saveRec)){
//					toSave = false
//				}
//				if(saveRec.get("INOUT_Q") == '0' && saveRec.get("INOUT_TYPE_DETAIL") != '91'){
//					alert('<t:message code = "unilite.msg.sMM350"/>');
//					toSave = false
//				}
//				if(saveRec.get("ACCOUNT_YNC") == 'Y' && saveRec.get("INOUT_TYPE_DETAIL") != '91' && saveRec.get("PRICE_YN") == 'Y'){
//					if(saveRec.get("ORDER_UNIT_FOR_P") == '0'){
//						alert('<t:message code = "unilite.msg.sMM375"/>');
//						toSave = false
//					}
//				}
//			});
//			return toSave;
		},
		isQtyCheck:function(record){
			var dInoutQ,dOriginalQ,dOrderQ,dNoInoutQ,dEnableQ,dStockQ
			var isQtycheck = false;
			if(record.get("INOUT_Q") == '0' && record.get("INOUT_TYPE_DETAIL") != '91'){
				alert('<t:message code = "unilite.msg.sMM350"/>');
				return false;
			}
			var recordSts = "N";
			if(record.phantom !== true){
				if(record.dirty === true){
					recordSts = "U"
				}else{
					recordSts = "D"
				}
			}

			if(BsaCodeInfo.gsInvstatus == '+'){
				if(record.get("STOCK_CARE_YN") == 'Y'){
					if((record.get("INOUT_Q") < 0 && recordSts == "D")
					|| (record.get("INOUT_Q") < record.get("ORIGINAL_Q")) && recordSts == "U"){
						dInoutQ = 0
						dOriginalQ = 0;
						var findRecs = directMasterStore1.findBy(function(rec,id){
							 return rec['ITEM_CODE'] == record['ITEM_CODE'];
						});
						if(findRecs.length > 0){
							Ext.each(findRecs, function(findRec,i) {
								if(findRec.phantom === true || findRec.dirty === true){
									if(findRec.get("INOUT_Q") != ""){
										dOriginalQ = dOriginalQ + findRec.get("ORIGINAL_Q")
									}
								}
							});
						}
					}
					if(recordSts == "N" || recordSts == "U"){
						dInoutQ = dInoutQ + record.get("INOUT_Q")
						dOriginalQ = dOriginalQ + record.get("ORIGINAL_Q")
					}else{
						dOriginalQ = dOriginalQ + record.get("ORIGINAL_Q")
					}
					if(record.get("ITEM_STATUS") == "1"){
						dStockQ = record.get("GOOD_STOCK_Q")
					}else{
						dStockQ = record.get("BAD_STOCK_Q")
					}
					if((dStockQ - dOriginalQ) < dInoutQ * (-1)){
						alert('<t:message code = "unilite.msg.sMM349"/>'+" : " + (dStockQ - dOriginalQ));
						return false;
					}
				}
			}
			return true;
		},
		fnAutoLotNo: function(newValue){
			if(Ext.isEmpty(newValue)) {
				return false;
			}
			var channel = masterForm.getValue('CHANNEL');
			var fullDate =  newValue;
			var dd =  fullDate.substr(6, 2);
			var yy = fullDate.substr(2, 2);
			var mm =fullDate.substr(4, 2);
			var m = '';
			switch(mm) {
				case '01' :
					m = 'A';
				break;
				case '02' :
					m = 'B';
				break;
				case '03' :
					m = 'C';
				break;
				case '04' :
					m = 'D';
				break;
				case '05' :
					m = 'E';
				break;
				case '06' :
					m = 'F';
				break;
				case '07' :
					m = 'G';
				break;
				case '08' :
					m = 'H';
				break;
				case '09' :
					m = 'I';
				break;
				case '10' :
					m = 'J';
				break;
				case '11' :
					m = 'K';
				break;
				case '12' :
					m = 'L';
				break;
			}
			var autoLotNo = channel + dd + m + yy
			masterForm.setValue('AUTO_LOT_NO', autoLotNo);

			param = {
				'COMP_CODE'		: UserInfo.compCode,
				'CUSTOM_CODE'	: panelResult2.getValue('CUSTOM_CODE'),
				'INOUT_DATE'	: UniDate.getDbDateStr(panelResult2.getValue('INOUT_DATE'))
			}
			s_mms515ukrv_ypService.getCertType(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)) {
					gsCertType = provider;
				} else {
					gsCertType = 0;
				}
			})
		},
		fnAutoLotNoNew: function(newValue, channel, customCode){
			if(Ext.isEmpty(newValue)) {
				return false;
			}

			var fullDate =  newValue;
			var dd =  fullDate.substr(6, 2);
			var yy = fullDate.substr(2, 2);
			var mm =fullDate.substr(4, 2);
			var m = '';
			switch(mm) {
				case '01' :
					m = 'A';
				break;
				case '02' :
					m = 'B';
				break;
				case '03' :
					m = 'C';
				break;
				case '04' :
					m = 'D';
				break;
				case '05' :
					m = 'E';
				break;
				case '06' :
					m = 'F';
				break;
				case '07' :
					m = 'G';
				break;
				case '08' :
					m = 'H';
				break;
				case '09' :
					m = 'I';
				break;
				case '10' :
					m = 'J';
				break;
				case '11' :
					m = 'K';
				break;
				case '12' :
					m = 'L';
				break;
			}
			var autoLotNo = channel + dd + m + yy

			param = {
				'COMP_CODE'		: UserInfo.compCode,
				'CUSTOM_CODE'	: customCode,
				'INOUT_DATE'	: UniDate.getDbDateStr(panelResult2.getValue('INOUT_DATE'))
			}
			var grdRecord = masterGrid.uniOpt.currentRecord;
			s_mms515ukrv_ypService.getCertType(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)) {
					gsCertType = provider;
					autoLotNo = autoLotNo + '00' +  gsCertType;
					grdRecord.set('LOT_NO',autoLotNo);
					console.log("[autoLotNo]" + autoLotNo);
				} else {
					gsCertType = 0;
					autoLotNo = autoLotNo + '00' +  gsCertType;
					grdRecord.set('LOT_NO',autoLotNo);
					console.log("[autoLotNo]" + autoLotNo);
				}
			})
		},
		fnAutoLotNoNewExcel: function(newValue, channel, customCode, grdRecord){
			if(Ext.isEmpty(newValue)) {
				return false;
			}

			var fullDate =  newValue;
			var dd =  fullDate.substr(6, 2);
			var yy = fullDate.substr(2, 2);
			var mm =fullDate.substr(4, 2);
			var m = '';
			switch(mm) {
				case '01' :
					m = 'A';
				break;
				case '02' :
					m = 'B';
				break;
				case '03' :
					m = 'C';
				break;
				case '04' :
					m = 'D';
				break;
				case '05' :
					m = 'E';
				break;
				case '06' :
					m = 'F';
				break;
				case '07' :
					m = 'G';
				break;
				case '08' :
					m = 'H';
				break;
				case '09' :
					m = 'I';
				break;
				case '10' :
					m = 'J';
				break;
				case '11' :
					m = 'K';
				break;
				case '12' :
					m = 'L';
				break;
			}
			var autoLotNo = channel + dd + m + yy

			param = {
				'COMP_CODE'		: UserInfo.compCode,
				'CUSTOM_CODE'	: customCode,
				'INOUT_DATE'	: UniDate.getDbDateStr(panelResult2.getValue('INOUT_DATE'))
			}

			s_mms515ukrv_ypService.getCertType(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)) {
					gsCertType = provider;
					autoLotNo = autoLotNo + '00' +  gsCertType;
					grdRecord.set('LOT_NO',autoLotNo);
					console.log("[autoLotNo]" + autoLotNo);
				} else {
					gsCertType = 0;
					autoLotNo = autoLotNo + '00' +  gsCertType;
					grdRecord.set('LOT_NO',autoLotNo);
					console.log("[autoLotNo]" + autoLotNo);
				}
			})



		}
	});

	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			switch(fieldName) {
				case "CERT_TYPE" :
					if(newValue != ''){
						var newLotNo = record.get('LOT_NO').substring(0, 9) + newValue;
					} else {
						var newLotNo = record.get('LOT_NO').substring(0, 9) + 0;
					}
					record.set('LOT_NO', newLotNo);
					break;
				case "INOUT_SEQ" :
					if(newValue != ''){
						if(!isNaN(newValue)){
							rv='<t:message code="unilite.msg.sMB074"/>';
							break;
						}
						if(newValue <= 0){
							rv='<t:message code="unilite.msg.sMB076"/>';
							break;
						}
					}
					break;
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
				case "WH_CODE" :
					if(!Ext.isEmpty(newValue)){
						record.set('WH_CELL_CODE', "");
						record.set('WH_CELL_NAME', "");
//						record.set('LOT_NO', "");
					}else{
						record.set('WH_CODE', "");
						record.set('WH_CELL_CODE', "");
						record.set('WH_CELL_NAME', "");
//						record.set('LOT_NO', "");
					}
					//그리드 창고cell콤보 reLoad..
					cbStore.loadStoreRecords(newValue);
					break;
				case "ORDER_UNIT_Q" :
					if(newValue != oldValue){
						if(record.get('ITEM_CODE') == ''){
							rv='<t:message code="unilite.msg.sMM033"/>';
							break;
						}
					}

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

					if(record.get('ORDER_UNIT_P') != ''){
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_P') * newValue));	//자사금액= 자사단가 * 입력한입고량
					}else{
						record.set('ORDER_UNIT_I','0');
					}

					if(record.get('ORDER_UNIT_FOR_P') != ''){
						record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_FOR_P') * newValue));	//구매금액 = 구매단가 * 입력한 입고량
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

					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_FOR_P',(newValue / record.get('EXCHG_RATE_O')));	//재고단위단가 = 입력한 자사단가(재고) / 환율
						record.set('INOUT_FOR_O',(record.get('INOUT_Q') * newValue / record.get('EXCHG_RATE_O')));	//재고단위금액 = 재고단위수량 * 입력한 자사단가(재고) / 환율
					}else{
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
					}
					directMasterStore1.fnSumAmountI();
					break;
				case "INOUT_I" :	//자사금액(재고)
					if(!isNaN(newValue)){
						rv='<t:message code="unilite.msg.sMB074"/>';
						break;
					}
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
					}else{
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
					}
					directMasterStore1.fnSumAmountI();
					break;
				case "ORDER_UNIT" :
					if(record.get('STOCK_UNIT') == newValue){
						record.set('TRNS_RATE', '1');
						if(record.get('ORDER_UNIT_Q') != '0'){
							record.set('INOUT_Q',record.get('ORDER_UNIT_Q') * record.get('TRNS_RATE'));	//재고단위수량 = 입고량 * 입력한 입수
						}else{
							record.set('INOUT_Q','0');
						}

						if(record.get('ORDER_UNIT_P') != ''){
							record.set('INOUT_P',(record.get('ORDER_UNIT_P') / record.get('TRNS_RATE')));  //자사단가(재고) = 자사단가 / 입력한 입수
						}else{
							record.set('INOUT_P','0');
						}

						if(record.get('ORDER_UNIT_FOR_P') != ''){
							record.set('INOUT_FOR_P',(record.get('ORDER_UNIT_FOR_P') / record.get('TRNS_RATE')));  //재고단위단가 = 구매단가 / 입력한 입수
						}else{
							record.set('INOUT_FOR_P','0');
						}
					}
					//2018.04.10 수주등록 된 데이터도 주문수량 변경가능하도록 수정 (단순 변경만 가능하도록 수정)
//					UniAppManager.app.selectOrderPrice("U", record, newValue)
					break;
				case "TRNS_RATE" :	//입수
//					if(!isNaN(newValue)){
//						rv='<t:message code="unilite.msg.sMB074"/>';
//						break;
//					}
					if(newValue <= 0){
						rv='<t:message code = "unilite.msg.sMB076"/>';
						break;
					}

					if(record.get('ORDER_UNIT_Q') != '0'){
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
					record.set('INOUT_I',(record.get('ORDER_UNIT_I')));	//자사금액(재고) = 자사금액
					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_P') / record.get('EXCHG_RATE_O')));	//재고단위단가 = 자사단가(재고)/환율
						record.set('ORDER_UNIT_FOR_P',(newValue / record.get('EXCHG_RATE_O')));	//	구매단가 = 입력한 자사단가 / 환율
						record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_Q') * newValue / record.get('EXCHG_RATE_O')));	//구매금액 = 입고량 * 입력한 자사단가 / 환율
						record.set('INOUT_FOR_O',record.get("ORDER_UNIT_FOR_O"));
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
						record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					}else{
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}
					directMasterStore1.fnSumAmountI();
					break;

//				case "PURCHASE_RATE" :	//매입율& 단가 & 수량 & 판매가 관계 추가
//					record.set("ORDER_UNIT_FOR_P",record.get('SALE_BASIS_P') * newValue / 100);
//					record.set("ORDER_UNIT_FOR_O",(record.get('SALE_BASIS_P') * newValue / 100)* record.get("ORDER_UNIT_Q"));
//
//					record.set("INOUT_FOR_P",record.get("ORDER_UNIT_FOR_P")/record.get("TRNS_RATE"));
//					record.set("INOUT_FOR_O",record.get("INOUT_FOR_P")*record.get("ORDER_UNIT_Q") * record.get("TRNS_RATE"));
//
//					record.set("INOUT_P",record.get("ORDER_UNIT_FOR_P") / record.get("TRNS_RATE") * record.get("EXCHG_RATE_O"));
//					record.set("INOUT_I",record.get("INOUT_P") * record.get("ORDER_UNIT_Q") * record.get("TRNS_RATE"));
//
//					record.set("ORDER_UNIT_P",record.get("ORDER_UNIT_FOR_P") * record.get("EXCHG_RATE_O"));
//					record.set("ORDER_UNIT_I",record.get("ORDER_UNIT_P") * record.get("ORDER_UNIT_Q"));
//
//					break;
				case "ORDER_UNIT_FOR_P":	//입고단가
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
					record.set('ORDER_UNIT_FOR_O', record.get('ORDER_UNIT_Q') * newValue);
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
						record.set('INOUT_I', (record.get('ORDER_UNIT_P') * record.get('ORDER_UNIT_Q'))); // 자사단가(ORDER_UNIT_P)
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

					record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}
					directMasterStore1.fnSumAmountI();

					if(newValue != 0){
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * newValue));	//자사단가(재고) = 재고단위단가 * 입력한 환율
						record.set('ORDER_UNIT_P',(record.get('ORDER_UNIT_FOR_P') * newValue));
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					break;

				case "ORDER_UNIT_FOR_O" : //입고금액
					if(record.get('ORDER_UNIT_Q') != ''){
						if((newValue <= 0) && (record.get('ORDER_UNIT_Q') > 0)){
							rv='<t:message code = "unilite.msg.sMB076"/>';
							break;
						}else if((newValue >= 0) && (record.get('ORDER_UNIT_Q') < 0)){
							rv='<t:message code = "unilite.msg.sMB077"/>';
							break;
						}
					}

					if(record.get('INOUT_TYPE_DETAIL') != '90'){
						if(newValue <= '0'){
							rv='<t:message code="unilite.msg.sMB076"/>';
							break;
						}
					} else {

					}
				//	record.set('INOUT_FOR_P',(record.get('ORDER_UNIT_FOR_P') / record.get('TRNS_RATE')));	//재고단위단가 = 입고단가 / 입수
				//	record.set('INOUT_FOR_O',(record.get('INOUT_FOR_P') * record.get('INOUT_Q')));	//재고단위금액 = 단가 * 수량
					record.set('INOUT_FOR_P',(newValue / (record.get('INOUT_Q') * record.get('TRNS_RATE'))));	////20180904 재고단위단가 = 입력값 / (수량 * 입수)
					record.set('INOUT_FOR_O',(newValue * record.get('EXCHG_RATE_O')));	////20180904입력값 * 환율
					record.set('ORDER_UNIT_FOR_P',(newValue / (record.get('INOUT_Q') * record.get('TRNS_RATE'))));////20180904 입고단가 = 입력값 / (수량 * 입수)
				/* 	if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
						record.set('ORDER_UNIT_FOR_P',(newValue / record.get('ORDER_UNIT_Q')));	//구매단가 = 입력한 구매금액 / 입고량
					}else{
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_P','0');
					} */

					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P',(record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가 = 구매단가 * 환율
						record.set('ORDER_UNIT_I',(newValue * record.get('EXCHG_RATE_O')));	//자사금액 = 입력한 구매금액 * 환율
						record.set('INOUT_I',(record.get('ORDER_UNIT_I')));	//자사금액(재고) = 자사금액
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					directMasterStore1.fnSumAmountI();
					break;

				case "MONEY_UNIT" :
					if(newValue == BsaCodeInfo.gsDefaultMoney){
						record.set('EXCHG_RATE_O','1');
					}//else
					record.set('ORDER_UNIT_FOR_O', record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_FOR_P'));	//구매금액 = 입고량 * 구매단가
					record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}
					directMasterStore1.fnSumAmountI();

					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P',(record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가 = 구매단가 * 환율
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));	//자사금액 = 입고량 * 자사단가
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					var param = {
						"AC_DATE"	: UniDate.getDbDateStr(masterForm.getValue('INOUT_DATE')),
						"MONEY_UNIT" : newValue
					};
					salesCommonService.fnExchgRateO(param, function(provider, response) {
						if(!Ext.isEmpty(provider)){
							if(provider.BASE_EXCHG == "1" && !Ext.isEmpty(newValue) && newValue != "KRW"){
								rv = '환율정보가 없습니다.';
							}
							record.set('EXCHG_RATE_O', provider.BASE_EXCHG);
						}

					});
					break;

				case "INOUT_TYPE_DETAIL" :
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
	});

	function setAllFieldsReadOnly(b) {
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

   function getPjtNoPopupEditor(){
		var editField = Unilite.popup('PROJECT_G',{
		 	DBtextFieldName: 'PROJECT_NO',
		 	textFieldName:'PROJECT_NO',
			autoPopup: true,
		 	listeners: {
		 		'applyextparam': function(popup){
		 			var selectRec = masterGrid.getSelectedRecord();
		 			if(selectRec){
		 				popup.setExtParam({'BPARAM0': 3});
		 				popup.setExtParam({'CUSTOM_CODE': selectRec.get("CUSTOM_CODE")});
		 				popup.setExtParam({'CUSTOM_NAME': selectRec.get("CUSTOM_NAME")});
		 			}
		 		},
		 		'onSelected': {
		 			fn: function(record, type) {
		 				var selectRec = masterGrid.getSelectedRecord()
		 				if(selectRec){
		 					selectRec.set('PROJECT_NO', record[0]["PJT_CODE"]);
		 				}
					},
		 			scope: this
		 		},
		 		'onClear': function(type){
		 			scope: this
		 		}
		 	}
		})

		var editor = Ext.create('Ext.grid.CellEditor', {
			ptype: 'cellediting',
			clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
			autoCancel : false,
			selectOnFocus:true,
			field: editField
		});

		return editor;
	}

   function getLotPopupEditor(sumtypeLot){
		var editField;
		if(sumtypeLot){
					 editField = Unilite.popup('LOTNO_G',{
						 textFieldName: 'LOTNO_CODE',
						 DBtextFieldName: 'LOTNO_CODE',
						 width:1000,
						 autoPopup: true,
						 listeners: {
						 	'onSelected': {
						 		fn: function(record, type) {
						 			var selectRec = masterGrid.getSelectedRecord()
						 			if(selectRec){
						 				debugger;
						 				selectRec.set('LOT_NO', record[0]["LOT_NO"]);
						 				selectRec.set('GOOD_STOCK_Q', record[0]["GOOD_STOCK_Q"]);
						 				selectRec.set('BAD_STOCK_Q', record[0]["BAD_STOCK_Q"]);
						 			}
							 	},
						 		scope: this
						 	},
						 	'onClear': {
						 		fn: function(record, type) {
						 			var selectRec = masterGrid.getSelectedRecord()
						 			if(selectRec){
						 				selectRec.set('LOT_NO', '');
						 				selectRec.set('GOOD_STOCK_Q', 0);
						 				selectRec.set('BAD_STOCK_Q', 0);
						 			}
							 	},
						 		scope: this
						 	},
						 	applyextparam: function(popup){
						 		var selectRec = masterGrid.getSelectedRecord();
						 		if(selectRec){
						 			popup.setExtParam({'DIV_CODE':  selectRec.get('DIV_CODE')});
						 			popup.setExtParam({'ITEM_CODE': selectRec.get('ITEM_CODE')});
						 			popup.setExtParam({'ITEM_NAME': selectRec.get('ITEM_NAME')});
						 			popup.setExtParam({'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE')});
						 			popup.setExtParam({'CUSTOM_NAME': masterForm.getValue('CUSTOM_NAME')});
						 			popup.setExtParam({'WH_CODE': selectRec.get('WH_CODE')});
						 			popup.setExtParam({'WH_CELL_CODE': selectRec.get('WH_CELL_CODE')});
						 			popup.setExtParam({'stockYN': 'Y'});
						 		}
						 	}
						 }
					});
		}else {
			editField = {xtype : 'textfield', maxLength:20}
		}

		var editor = Ext.create('Ext.grid.CellEditor', {
			ptype: 'cellediting',
			clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
			autoCancel : false,
			selectOnFocus:true,
			field: editField
		});

		return editor;
	}




	function caluator(record){
		var newValue = record.get('ORDER_UNIT_Q');
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
						return false;
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

		if(record.get('ORDER_UNIT_P') != ''){
			record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_P') * newValue));	//자사금액= 자사단가 * 입력한입고량
		}else{
			record.set('ORDER_UNIT_I','0');
		}

		if(record.get('ORDER_UNIT_FOR_P') != ''){
			record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_FOR_P') * newValue));	//구매금액 = 구매단가 * 입력한 입고량
			record.set('INOUT_FOR_O',record.get('ORDER_UNIT_FOR_O'));	//재고단위금액  = 구매금액
		}else{
			record.set('ORDER_UNIT_FOR_O','0');
		}

		record.set('INOUT_P',(record.get('ORDER_UNIT_P') / record.get('TRNS_RATE')));	//자사단가(재고) = 자사단가 / 입수
		record.set('INOUT_I',record.get('ORDER_UNIT_I'));	//자사금액(재고) = 자사금액
		record.set('INOUT_FOR_O',record.get('ORDER_UNIT_FOR_O'));	//재고단위금액  = 구매금액

		directMasterStore1.fnSumAmountI();
	}
};
</script>