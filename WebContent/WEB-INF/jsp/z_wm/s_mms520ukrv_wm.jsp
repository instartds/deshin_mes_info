<%--
'	프로그램명 : 입고등록(WM)
'	작  성  자 : 시너지시스템즈 개발실
'	작  성  일 :
'	최종수정자 :
'	최종수정일 :
'	버	  전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mms520ukrv_wm">
	<t:ExtComboStore comboType="BOR120" pgmId="s_mms520ukrv_wm"/>			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>						<!-- 화폐 -->
	<t:ExtComboStore comboType="AU" comboCode="B020"/>						<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B021"/>						<!-- 품목상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>						<!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '2;6'/>			<!-- 생성경로 (그리드) -->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>						<!-- 과세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="M001"/>						<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M103"/>						<!-- 입고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="M201"/>						<!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M301"/>						<!-- 단가형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M505" opts= '2;6'/>			<!-- 생성경로 (폼) -->
	<t:ExtComboStore comboType="AU" comboCode="S014"/>						<!-- 기표대상 -->
	<t:ExtComboStore comboType="AU" comboCode="YP08"/>						<!-- 조건 -->
	<t:ExtComboStore comboType="AU" comboCode="YP09"/>						<!-- 형태 -->
	<t:ExtComboStore comboType="AU" comboCode="Z003"/>						<!-- 구분 -->
	<t:ExtComboStore comboType="OU" />										<!-- 창고 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>			<!-- 창고 -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList"/>	<!-- 창고Cell -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
	//우편번호 다음 API 연동
	var protocol = ("https:" == document.location.protocol) ? "https" : "http";
	if(protocol == "https") {
		document.write(unescape("%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	} else {
		document.write(unescape("%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	}
</script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >

var SearchInfoWindow;			//조회버튼 누르면 나오는 조회창
var gsSelRecord
var gsOriValue
var gsQueryFlag = false;
var BsaCodeInfo = {
	gsDefaultData		: '${gsDefaultData}',
	gsInTypeAccountYN	: '${gsInTypeAccountYN}',
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
	gsGwYn				: '${gsGwYn}',
	gsInoutType			: '${gsInoutType}',
	gsExchangeRate		: '${gsExchangeRate}'
};
var CustomCodeInfo = {
	gsUnderCalBase: ''
};
var gsInoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_M103').getAt(0).get('value');
var outDivCode = UserInfo.divCode;
var alertWindow;			//alertWindow : 경고창
var gsText			= ''	//바코드 알람 팝업 메세지


function appMain() {
	var sumtypeLot = true;	//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeLot =='Y') {
		sumtypeLot = false;
	}
	var sumtypeCell = true;	//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeCell =='Y') {
		sumtypeCell = false;
	}
	var isAutoInoutNum = BsaCodeInfo.gsAutoType=='Y'? true:false;

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_mms520ukrv_wmService.selectList',
			update	: 's_mms520ukrv_wmService.updateDetail',
			create	: 's_mms520ukrv_wmService.insertDetail',
			destroy	: 's_mms520ukrv_wmService.deleteDetail',
			syncAll	: 's_mms520ukrv_wmService.saveAll'
		}
	});



	Unilite.defineModel('s_mms520ukrv_wmModel1', {
		fields: [
			{name: 'TYPE'				, text: '구분'		, type: 'string',comboType:'AU',comboCode:'Z003'						, allowBlank: false},
			{name: 'CUSTOM_PRSN'		, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'				, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string',allowBlank: isAutoInoutNum},
			{name: 'INOUT_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'						, type: 'int', allowBlank: false},
			{name: 'INOUT_METH'			, text: '<t:message code="system.label.purchase.method" default="방법"/>'						, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>'				, type: 'string',comboType:'AU',comboCode:'M103', allowBlank: false},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				, type: 'string',comboType: 'AU',comboCode: 'B020'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'						, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				, type: 'string',comboType:'AU',comboCode:'B013', displayField: 'value'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				, type: 'uniQty', allowBlank: true},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string',comboType:'AU',comboCode:'B013', displayField: 'value'},
			{name: 'INOUT_Q'			, text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>'		, type: 'uniQty'},
			{name: 'ORIGINAL_Q'			, text: '<t:message code="system.label.purchase.existinginqty" default="기존입고량"/>'			, type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'		, text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'				, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'		, text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'			, type: 'uniQty'},
			{name: 'NOINOUT_Q'			, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'				, type: 'uniQty'},
			{name: 'PRICE_YN'			, text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'				, type: 'string',comboType:'AU',comboCode:'M301'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'					, type: 'string',comboType:'AU',comboCode:'B004', allowBlank: false, displayField: 'value',editable: false},//20200908 수정: 그리드 화폐는 수정 불가
			{name: 'INOUT_FOR_P'		, text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>'		, type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O'		, text: '<t:message code="system.label.purchase.inventoryunitamount" default="재고단위금액"/>'	, type: 'uniPrice'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				, type: 'uniER'},
			{name: 'INOUT_P'			, text: '<t:message code="system.label.purchase.copricestock" default="자사단가(재고)"/>'			, type: 'uniUnitPrice', allowBlank: true, editable: false},
			{name: 'INOUT_I'			, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'				, type: 'uniPrice'	, editable: false},//기존 자사금액(재고), 20200908 수정: 공급가액은 수정 불가
			{name: 'TRANS_COST'			, text: '<t:message code="system.label.purchase.shippingcharge" default="운반비"/>'			, type: 'uniPrice'},
			{name: 'TARIFF_AMT'			, text: '<t:message code="system.label.purchase.Customs" default="관세"/>'					, type: 'uniPrice'},
			{name: 'ACCOUNT_YNC'		, text: '<t:message code="system.label.purchase.sliptarget" default="기표대상"/>'				, type: 'string', comboType:'AU',comboCode:'S014', allowBlank: false},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string',comboType:'AU',comboCode:'M001', allowBlank: false},
			{name: 'LC_NUM'				, text: 'LC/NO(*)'		, type: 'string'},
			{name: 'BL_NUM'				, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'					, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'						, type: 'int'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'						, type: 'uniQty'},
			{name: 'INOUT_CODE_TYPE'	, text: '<t:message code="system.label.purchase.receiptplacetype" default="입고처구분"/>'		, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'			, type: 'string', comboType:'OU', allowBlank: false, child: 'WH_CELL_CODE'},
			{name: 'WH_CELL_CODE'		, text:'<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/> Cell'		, type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','SALE_DIV_CODE']},
			{name: 'ITEM_STATUS'		, text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>'				, type: 'string',comboType:'AU',comboCode:'B021', allowBlank: false},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate', allowBlank: false},
			{name: 'INOUT_PRSN'			, text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'			, type: 'string'},
			{name: 'ACCOUNT_Q'			, text: '<t:message code="system.label.purchase.billqty" default="계산서량"/>'					, type: 'uniQty'},
			{name: 'CREATE_LOC'			, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'				, type: 'string',comboType:'AU',comboCode:'B031'},
			{name: 'SALE_C_DATE'		, text: '<t:message code="system.label.purchase.billclosingdate" default="계산서마감일"/>'		, type: 'uniDate'},
			{name: 'MAKE_LOT_NO'		, text: '거래처LOT'		, type: 'string'},
			{name: 'MAKE_DATE'			, text: '제조일자'			, type: 'uniDate'},
			{name: 'MAKE_EXP_DATE'		, text: '유통기한'			, type: 'uniDate'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'LOT_NO'				, text: 'LOT NO'		, type: 'string'},
			{name: 'LOT_YN'				, text: '<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'			, type: 'string', comboType:'AU', comboCode:'A020'},
			{name: 'INOUT_TYPE'			, text: '<t:message code="system.label.purchase.type" default="타입"/>'						, type: 'string'},
			{name: 'INOUT_CODE'			, text: '<t:message code="system.label.purchase.receiptplace" default="입고처"/>'				, type: 'string', allowBlank: false},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'					, type: 'string', child: 'WH_CODE'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type: 'string'},
			{name: 'COMPANY_NUM'		, text: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				, type: 'string'},
			{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.purchase.poreceiptqty" default="발주입고수량"/>'			, type: 'uniQty'},
			{name: 'INSPEC_NUM'			, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'					, type: 'string'},
			{name: 'INSPEC_SEQ'			, text: '<t:message code="system.label.purchase.inspecseq" default="검사순번"/>'				, type: 'int'},
			{name: 'SALE_DIV_CODE'		, text: '<t:message code="system.label.purchase.salesdivision" default="매출사업장"/>'			, type: 'string'},
			{name: 'SALE_CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.salesplace" default="매출처"/>'				, type: 'string'},
			{name: 'BILL_TYPE'			, text: '<t:message code="system.label.purchase.salestype" default="매출유형"/>'				, type: 'string'},
			{name: 'SALE_TYPE'			, text: '<t:message code="system.label.purchase.salesclass" default="매출구분"/>'				, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>'				, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '<t:message code="system.label.purchase.updatedate" default="수정일"/>'				, type: 'string'},
			{name: 'EXCESS_RATE'		, text: '<t:message code="system.label.purchase.overreceiptrate" default="과입고허용율"/>'		, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'				, type: 'uniQty'},
			{name: 'ORDER_UNIT_FOR_P'	, text: '<t:message code="system.label.purchase.receiptprice" default="입고단가"/>'				, type: 'uniUnitPrice', allowBlank: true},
			{name: 'ORDER_UNIT_FOR_O'	, text: '<t:message code="system.label.purchase.receiptamount" default="입고금액"/>'			, type: 'uniFC'/* , allowBlank: false */},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'					, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_I'		, text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'					, type: 'uniPrice'},			///////////////////////////////////////////////////////	INOUT_I
			{name: 'BASIS_NUM'			, text: 'BASIS_NUM'		, type: 'string'},
			{name: 'BASIS_SEQ'			, text: 'BASIS_SEQ'		, type: 'int'},
			{name: 'SCM_FLAG_YN'		, text: 'SCM_FLAG_YN'	, type: 'string'},
			{name: 'TRADE_LOC'			, text: '<t:message code="system.label.purchase.tradelocation" default="무역경로"/>'			, type: 'string',comboType:'AU',comboCode:'T104'},
			{name: 'STOCK_CARE_YN'		, text: '<t:message code="system.label.purchase.inventorymanagementyn" default="재고관리여부"/>'	, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				, type: 'string'},
			{name: 'INSERT_DB_USER'		, text: 'INSERT_DB_USER', type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: 'INSERT_DB_TIME', type: 'string'},
			{name: 'SALES_TYPE'			, text: 'SALES_TYPE'	, type: 'int'},
			{name: 'FLAG'				, text: 'FLAG'			, type: 'string'},
			{name: 'RECEIPT_NUM'		, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'				, type: 'string'},
			{name: 'RECEIPT_SEQ'		, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'				, type: 'int'},
			{name: 'SOF_ORDER_NUM'		, text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'						, type: 'string'},
			{name: 'SOF_ORDER_SEQ'		, text: '<t:message code="system.label.purchase.soseq" default="수주순번"/>'					, type: 'int'},
			{name: 'SOF_CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.soplace" default="수주처"/>'					, type: 'string'},
			{name: 'SOF_ITEM_NAME'		, text: '<t:message code="system.label.purchase.soitemname" default="수주품목명"/>'				, type: 'string'},
			{name: 'TEMP_SEQ'			, text: 'TEMP_SEQ'		, type: 'string'},
			{name: 'CUSTOM_PRSN'		, text: '고객명'			, type: 'string'},
			{name: 'PHONE'				, text: '연락처'			, type: 'string'},
			{name: 'BANK_NAME'			, text: '은행명'			, type: 'string'},
			{name: 'BANK_ACCOUNT'		, text: '계좌번호'			, type: 'string'},
			{name: 'BANK_ACCOUNT_EXPOS'	, text: '계좌번호'			, type: 'string'},
			{name: 'BIRTHDAY'			, text: '생년월일'			, type: 'string'},	//20210317 수정: uniDate -> string
			{name: 'ZIP_CODE'			, text: '우편번호'			, type: 'string'},
			{name: 'ADDR1'				, text: '주소'			, type: 'string'}
		]
	});

	Unilite.defineModel('inoutNoMasterModel', {								//조회버튼 누르면 나오는 조회창
		fields: [
			{name: 'INOUT_NAME'			, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'			, type: 'uniDate'},
			{name: 'INOUT_CODE'			, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'			, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'		, type: 'string', comboType	: 'OU'},
			{name: 'WH_CELL_CODE'		, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>Cell'	, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'				, type: 'string', comboType:'BOR120'},
			{name: 'INOUT_PRSN'			, text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'		, type: 'string', comboType:'AU', comboCode:'B024'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'			, type: 'string'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			, type: 'uniER'},
			{name: 'CREATE_LOC'			, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'			, type: 'string', comboType:'AU',comboCode:'B031'},
			{name: 'PERSON_NAME'		, text: '<t:message code="system.label.purchase.employeename" default="사원명"/>'			, type: 'string'},
			{name: 'BL_NO'				, text: 'BL_NO'		, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'				, type: 'string',comboType:'AU',comboCode:'M001'}	//20210226 추가 
		]
	});



	var directMasterStore = Unilite.createStore('s_mms520ukrv_wmMasterStore1', {
		model	: 's_mms520ukrv_wmModel1',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			allDeletable: true,
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: directProxy,
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
				if(record.get('INOUT_TYPE_DETAIL') != '91') {//금액 보정이 아닐 경우
					var msg = '';
					if(record.get('ORDER_UNIT_Q') == 0) {
						msg += '\n<t:message code="system.label.purchase.receiptqty1" default="입고수량"/> ' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>';
					}
					if(record.get('INOUT_Q') == 0) {
						msg += '\n<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>';
					}
					if(msg != '') {
						Unilite.messageBox((index + 1) + '<t:message code="system.message.purchase.message026" default="행의 입력값을 확인 해주세요."/>' + msg);
						isErr = true;
						return false;
					}
				}
				if(record.get('INOUT_TYPE_DETAIL') != '91'	//금액 보정이 아닐 경우
					&& record.get('ACCOUNT_YNC') == 'Y'		//기표대상일 경우
					&& record.get('PRICE_YN')	== 'Y' ) {	//진단가일 경우
					//기존 20'(무상입고)에 '40'(사급입고) 추가
					if(record.get('INOUT_TYPE_DETAIL') != '20' && record.get('INOUT_TYPE_DETAIL') != '40') {
						var msg = '';
						if(record.get('ORDER_UNIT_FOR_P') == 0) {
							msg += '<t:message code="system.label.purchase.receiptprice" default="입고단가"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>';
						}
						if(record.get('ORDER_UNIT_FOR_O') == 0) {
							msg += '<t:message code="system.label.purchase.receiptamount" default="입고금액"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>';
						}
						if(record.get('ORDER_UNIT_P') == 0) {
							msg += '<t:message code="system.label.purchase.coprice" default="자사단가"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>';
						}
						if(msg != '') {
							Unilite.messageBox((index + 1) + '<t:message code="system.message.purchase.message026" default="행의 입력값을 확인 해주세요."/>' + msg);
							isErr = true;
							return false;
						}
					}
				}
			});
			if(isErr) {
				return false;
			}
			var paramMaster= panelResult2.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult2.setValue("INOUT_NUM", master.INOUT_NUM);
						panelResult2.getForm().wasDirty = false;
						panelResult2.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);

						if (directMasterStore.count() == 0) {
							UniAppManager.app.onResetButtonDown();
						} else {
							directMasterStore.loadStoreRecords();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_mms520ukrv_wmGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records.length > 0) {
					panelResult2.setValue('CUSTOM_PRSN'			, records[0].get('CUSTOM_PRSN'));
					panelResult2.setValue('PHONE'				, records[0].get('PHONE'));
					panelResult2.setValue('BANK_NAME'			, records[0].get('BANK_NAME'));
					panelResult2.setValue('BANK_ACCOUNT'		, records[0].get('BANK_ACCOUNT'));
					panelResult2.setValue('BANK_ACCOUNT_EXPOS'	, records[0].get('BANK_ACCOUNT_EXPOS'));
					panelResult2.setValue('BIRTHDAY'			, records[0].get('BIRTHDAY'));
					panelResult2.setValue('ZIP_CODE'			, records[0].get('ZIP_CODE'));
					panelResult2.setValue('ADDR1'				, records[0].get('ADDR1'));
					panelResult2.setValue('REMARK'				, records[0].get('REMARK'));
					this.fnSumBlAmountI(records[0]);
				}
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
		loadStoreRecords: function() {
			var param = panelResult2.getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		fnSumBlAmountI: function(record) {
			var blAmtWon = this.sumBy(function(record, id) {
							return record.get('TEMP_SEQ') == '1';},
							['BL_AMT_WON']);
			panelResult.setValue('BlSumInoutO', blAmtWon.BL_AMT_WON);
			this.fnSumAmountI();
		},
		fnSumAmountI:function() {
			var dAmountI	= Ext.isNumeric(this.sum('INOUT_FOR_O'))	? this.sum('INOUT_FOR_O')	: 0;	//재고단위금액
			var dIssueAmtWon= Ext.isNumeric(this.sum('ORDER_UNIT_I'))	? this.sum('ORDER_UNIT_I')	: 0;	//INOUT_I(자사금액(재고)) -> ORDER_UNIT_I(자사금액)로 변경

			panelResult.setValue('SumInoutO'	, dAmountI);
			panelResult.setValue('IssueAmtWon'	, dIssueAmtWon);

			//bl금액합계와 합계금액이 다를경우 bl금액합계 금액 다른색으로 표시
			if(!panelResult.getField('BlSumInoutO').hidden) {
				if(panelResult.getValue('BlSumInoutO') != panelResult.getValue('IssueAmtWon')) {
					panelResult.getField('IssueAmtWon').setFieldStyle('color:red');
				} else {
					panelResult.getField('IssueAmtWon').setFieldStyle('color:black');
				}
			}
		}
	});

	var inoutNoMasterStore = Unilite.createStore('inoutNoMasterStore', {	//조회버튼 누르면 나오는 조회창
		model	: 'inoutNoMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_mms520ukrv_wmService.selectinoutNoMasterList'
			}
		},
		loadStoreRecords : function() {
			var param		= inoutNoSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;			//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;			//부서코드
			if(authoInfo == "5" && Ext.isEmpty(inoutNoSearch.getValue('DEPT_CODE'))) {
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	var panelResult2 = Unilite.createSearchForm('resultForm2',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			holdable	: 'hold',
			child		: 'WH_CODE',
			value		: UserInfo.divCode,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelResult2.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					var field2 = panelResult2.getField('WH_CODE');
					field2.getStore().clearFilter(true);

					panelResult.setValue('WH_CODE', '');
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			allowBlank		: true,
			holdable		: 'hold',
			autoPopup		: true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
						panelResult2.setValue('MONEY_UNIT'	, Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
						panelResult2.setValue('EXCHG_RATE_O', '1');
						if(records[0]["MONEY_UNIT"] != BsaCodeInfo.gsDefaultMoney) {
							panelResult2.getField('CREATE_LOC').setValue('6');
						} else {
							panelResult2.getField('CREATE_LOC').setValue('2');
						}
						UniAppManager.app.fnExchngRateO();
					},
					scope: this
				},
				onClear: function(type) {
				},
				'applyextparam': function(popup){
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			allowBlank	: false,
			holdable	: 'hold',
			child		: 'WH_CELL_CODE',
			listConfig	: {minWidth: 230},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					var param = {
						DIV_CODE: panelResult2.getValue('DIV_CODE'),
						WH_CODE	: panelResult2.getValue('WH_CODE')
					}
					s_mms520ukrv_wmService.getWhCellCode(param, function(provider, response) {
						if(!Ext.isEmpty(provider) && !gsQueryFlag) {
							var whCellStore1 = panelResult2.getField('WH_CELL_CODE').getStore();
							whCellStore1.clearFilter(true);
							whCellStore1.filter([{
								property: 'option',
								value	: newValue
							}]);
							panelResult2.getField('WH_CELL_CODE').setValue(provider);
						}
						gsQueryFlag = false;
					})
				},
				beforequery:function( queryPlan, eOpts ) {
					var store	= queryPlan.combo.store;
					var psStore	= panelResult2.getField('WH_CODE').store;
					store.clearFilter();
					psStore.clearFilter();
					if(!Ext.isEmpty(panelResult2.getValue('DIV_CODE'))) {
						store.filterBy(function(record) {
							return record.get('option') == panelResult2.getValue('DIV_CODE');
						});
						psStore.filterBy(function(record) {
							return record.get('option') == panelResult2.getValue('DIV_CODE');
						});
					} else {
						store.filterBy(function(record) {
							return false;
						});
						psStore.filterBy(function(record) {
							return false;
						});
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>Cell',
			name		: 'WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			holdable	: 'hold',
			allowBlank	: sumtypeCell,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
			name		: 'INOUT_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					Ext.each(directMasterStore.data.items, function(record, index) {
						record.set('INOUT_DATE', newValue);
					});
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',
			name		: 'INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
				if(eOpts) {
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					Ext.each(directMasterStore.data.items, function(record, index) {
						record.set('INOUT_PRSN', newValue);
					});
				}
			}
		},{	//20210226 추가: 발주형태 필드 추가
			fieldLabel	: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name		: 'ORDER_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'M001',
			allowBlank	: false,
			holdable	: 'hold'
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>',
			xtype		: 'uniTextfield',
			name		: 'INOUT_NUM',
			readOnly	: isAutoInoutNum
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
			name		: 'CREATE_LOC',
			holdable	: 'hold',
			hidden		: true,
			items		: [{
				boxLabel	: '내수',
				name		: 'CREATE_LOC',
				inputValue	: '2',
				width		: 60
			},{
				boxLabel	: '수입',
				name		: 'CREATE_LOC',
				inputValue	: '6',
				width		: 60
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue.CREATE_LOC == '6') {
						panelResult.getField('BlSumInoutO').setHidden(false);
					} else {
						panelResult.getField('BlSumInoutO').setHidden(true);
					}
				}
			}
		},{
			xtype	: 'component',
			colspan	: 4
		},{
			fieldLabel	: '<t:message code="system.label.purchase.currency" default="화폐"/>',
			name		: 'MONEY_UNIT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B004',
			allowBlank	: true,
			displayField: 'value',
			holdable	: 'hold',
			fieldStyle	: 'text-align: center;',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				blur: function( field, The, eOpts ) {
					UniAppManager.app.fnExchngRateO();
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.exchangerate" default="환율"/>',
			name		: 'EXCHG_RATE_O',
			xtype		: 'uniNumberfield',
			allowBlank	: true,
			holdable	: 'hold',
			decimalPrecision: 4,
			value		: 1,
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{	//검사번호 필드 추가 -> 바코드 스캔 시, 출하지시참조/적용 로직 타도록 로직 추가
			fieldLabel	: '검사번호',
			name		: 'INSPEC_NUM',
			xtype		: 'uniTextfield',
			readOnly	: false,
			hidden		: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						if(!panelResult2.getInvalidMessage()) {
							panelResult2.setValue('INSPEC_NUM', '');
							return false;
						}
						var newValue = panelResult2.getValue('INSPEC_NUM');
						if(!Ext.isEmpty(newValue)) {
							Ext.getBody().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
							fnEnterInspecNumBarcode(newValue);
							Ext.getBody().unmask();
							panelResult2.setValue('INSPEC_NUM', '');
						}
					}
				}
			}
		},{
			fieldLabel	: 'ITEM_CODE',
			name		: 'ITEM_CODE',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: 'ORDER_UNIT',
			name		: 'ORDER_UNIT',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: '비고',
			name		: 'REMARK',
			xtype		: 'uniTextfield',
			colspan		: 4,
			width		: 815,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					var records = directMasterStore.data.items;
					Ext.each(records, function(record) {
						record.set('REMARK', newValue);
					});
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_PRSN',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					var records = directMasterStore.data.items;
					Ext.each(records, function(record) {
						record.set('CUSTOM_PRSN', newValue);
					});
				}
			}
		},{
			fieldLabel	: '연락처',
			name		: 'PHONE',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				blur: function( field, The, eOpts ) {
					//전화번호 입력 시, 자동으로 '-' 추가하도록 로직 추가, 20210218 수정: 안심번호 체크로직 추가
					if(!Ext.isEmpty(field.rawValue)) {
//						var newValue = field.rawValue.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
						var newValue = field.rawValue.replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
						if(!tel_check(newValue)) {
							newValue = '';
							Unilite.messageBox('올바른 전화번호를 입력하세요.');
						}
						panelResult2.setValue('PHONE', newValue);

						var records = directMasterStore.data.items;
						Ext.each(records, function(record) {
							record.set('PHONE', newValue);
						});
					}
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			colspan	: 2,
			items	: [{
				fieldLabel	: '계좌번호',
				xtype		: 'uniTextfield',
				name		: 'BANK_NAME',
				width		: 175,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						var records = directMasterStore.data.items;
						Ext.each(records, function(record) {
							record.set('BANK_NAME', newValue);
						});
					}
				}
			},{
				fieldLabel	: '',
				xtype		: 'uniTextfield',
				name		: 'BANK_ACCOUNT_EXPOS',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					blur: function(field, The, eOpts){
						var newValue = field.getValue().replace(/-/g,'');
						if(Ext.isEmpty(newValue)) {
							panelResult2.setValue('BANK_ACCOUNT'			, '');
							panelResult2.setValue('BANK_ACCOUNT_EXPOS'	, '');

							var records = directMasterStore.data.items;
							Ext.each(records, function(record) {
								record.set('BANK_ACCOUNT'		, '');
								record.set('BANK_ACCOUNT_EXPOS'	, '');
							});
							return false;
						}

						var param = {
							'DECRYP_WORD'	: newValue,
							'INCDRC_GUBUN'	: 'INC'
						}
						popupService.incryptDecryptPopup(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								panelResult2.setValue('BANK_ACCOUNT'			, provider);
								panelResult2.setValue('BANK_ACCOUNT_EXPOS'	, '*************');

								var records = directMasterStore.data.items;
								Ext.each(records, function(record) {
									record.set('BANK_ACCOUNT'		, provider);
									record.set('BANK_ACCOUNT_EXPOS'	, '*************');
								});
							}
						});
					},
					//20201209 추가: 포커스 시, 암호화 풀린 데이터 표시
					focus: function(field, event, eOpts) {
						var param = {
							'INCRYP_WORD'	: panelResult2.getValue('BANK_ACCOUNT'),
							'INCDRC_GUBUN'	: 'DEC'
						}
						popupService.incryptDecryptPopup(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								panelResult2.setValue('BANK_ACCOUNT_EXPOS'	, provider);
							}
						});
					}
				}
			}]
		},{
			fieldLabel	: 'BANK_ACCOUNT',
			name		: 'BANK_ACCOUNT',
			hidden		: true
		},{
			fieldLabel	: '생년월일',
			name		: 'BIRTHDAY',
			xtype		: 'uniTextfield',		//20210317 수정: uniDatefield -> uniTextfield
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					var records = directMasterStore.data.items;
					Ext.each(records, function(record) {
						record.set('BIRTHDAY', newValue);
					});
				}
			}
		},
		Unilite.popup('ZIP',{
			showValue		: false,
			textFieldName	: 'ZIP_CODE',
			DBtextFieldName	: 'ZIP_CODE',
			popupHeight		: 600,
			listeners		: {
				'onSelected': {
					fn: function(records, type  ){
						panelResult2.setValue('ADDR1', records[0]['ZIP_NAME'] + ' ' + records[0]['ADDR2']);

						var records2 = directMasterStore.data.items;
						Ext.each(records2, function(record) {
							record.set('ZIP_CODE'	, records[0]['ZIP_CODE']);
							record.set('ADDR1'		, records[0]['ZIP_NAME'] + ' ' + records[0]['ADDR2']);
						});
					},
					scope: this
				},
				'onClear' : function(type)	{
					panelResult.setValue('ADDR1', '');

					var records2 = directMasterStore.data.items;
					Ext.each(records2, function(record) {
						record.set('ZIP_CODE'	, '');
						record.set('ADDR1'		, '');
					});
				},
				applyextparam: function(popup){
					var paramAddr	= panelResult.getValue('ADDR1'); //우편주소 파라미터로 넘기기
					if(Ext.isEmpty(paramAddr)){
						popup.setExtParam({'GBN': 'post'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
					} else {
						popup.setExtParam({'GBN': 'addr'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
					}
					popup.setExtParam({'ADDR': paramAddr});
				}
			}
		}),{
			fieldLabel	: '주소',
			xtype		: 'uniTextfield',
			name		: 'ADDR1' ,
//			colspan		: 2,
			width		: 350,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					var records = directMasterStore.data.items;
					Ext.each(records, function(record) {
						record.set('ADDR1', newValue);
					});
				}
			}
		},{
			text	: '매입명세표',
			xtype	: 'button',
			margin	: '0 0 2 145',
			width	: 100,
			handler	: function() {
				if(UniAppManager.app._needSave()) {
					Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
					return false;
				}
				var inoutNum = panelResult2.getValue('INOUT_NUM');
				if(Ext.isEmpty(inoutNum)) {
					Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
					return false;
				}
				var param			= panelResult2.getValues();
				param.PGM_ID		= 's_mms520ukrv_wm';
				param.MAIN_CODE		= 'Z012';

				var win = Ext.create('widget.ClipReport', {
					url			: CPATH + '/z_wm/s_mms520clukrv_wm.do',
					prgID		: 's_mms520ukrv_wm',
					extParam	: param,
					submitType	: 'POST'
				});
				win.center();
				win.show();
			}
		}],
		setAllFieldsReadOnly: setAllFieldsReadOnly
	});

	var panelResult = Unilite.createSearchForm('detailForm', {							//합계 panel
		disabled	: false,
		border		: true,
		padding		: '1',
		region		: 'center',
		autoScroll	: true,
		masterGrid	: masterGrid,
		layout		: {
			type		: 'uniTable',
			columns		: 3,
			tableAttrs	: {align:'right'}
		},
		items: [{
			xtype		: 'container',
			defaultType	: 'uniTextfield',
			layout		: {type : 'vbox'},
			items		: [{
				fieldLabel	: 'B/L <t:message code="system.label.purchase.amounttotal" default="금액합계"/>',
				name		: 'BlSumInoutO',
				xtype		: 'uniNumberfield',
				readOnly	: true
			}]
		},{
			fieldLabel	: '<t:message code="system.label.purchase.amounttotal" default="금액합계"/>',
			name		: 'SumInoutO',
			xtype		: 'uniNumberfield',
			type		: 'uniFC',
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.purchase.ownamounttotal" default="자사금액합계"/>',
			name		: 'IssueAmtWon',
			xtype		: 'uniNumberfield',
			readOnly	: true
		}]
	});

	var inoutNoSearch = Unilite.createSearchForm('inoutNoSearchForm', {					//조회버튼 누르면 나오는 조회창
		layout			: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items			: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			child		: 'WH_CODE',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = inoutNoSearch.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					var field2 = inoutNoSearch.getField('WH_CODE');
					field2.getStore().clearFilter(true);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU'
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'INOUT_CODE',
			textFieldName	: 'INOUT_NAME',
			textFieldWidth	: 170,
			validateBlank	: false
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',
			name		: 'INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
				if(eOpts) {
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'INOUT_DATE_FR',
			endFieldName	: 'INOUT_DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today')
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
			name		: 'WH_CELL_CODE',
			hidden		: true
		},{
			fieldLabel	: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
			name		: 'CREATE_LOC',
			hidden		: true
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			textFieldWidth	: 170,
			autoPopup		: true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup) {
					popup.setExtParam({'DIV_CODE': panelResult2.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>',
			name		: 'INOUT_NUM'
		}]
	});



	var masterGrid = Unilite.createGrid('s_mms520ukrv_wmGrid1', {
		store		: directMasterStore,
		layout		: 'fit',
		region		: 'center',
		excelTitle	: '<t:message code="system.label.purchase.receiptentry" default="입고등록"/>',
		uniOpt		: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		tbar: [{
			xtype: 'button',
			text: '<div style="color: red"><t:message code="system.label.purchase.slipentry" default="지급결의 등록"/></div>',
			handler: function() {
				if(directMasterStore.count() == 0) {
					return false;
				}
				var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
				if(needSave) {
					Unilite.messageBox('<t:message code="system.message.common.savecheck" default="먼저 저장을 하십시오"/>');
					return false;
				}
				var params = {
					action			: 'select',
					'PGM_ID'		: 's_mms510ukrv_wm',				//20210305 수정: 사이트 지급결의 등록으로 가도록 수정
					'DIV_CODE'		: panelResult2.getValue('DIV_CODE'),
					'CUSTOM_CODE'	: panelResult2.getValue('CUSTOM_CODE'),
					'CUSTOM_NAME'	: panelResult2.getValue('CUSTOM_NAME'),
					'MONEY_UNIT'	: panelResult2.getValue('MONEY_UNIT'),
					'INOUT_DATE'	: UniDate.getDbDateStr(panelResult2.getValue('INOUT_DATE')),
					'WH_CODE'		: panelResult2.getValue('WH_CODE'),
					'INOUT_PRSN'	: panelResult2.getValue('INOUT_PRSN'),
					'CREATE_LOC'	: panelResult2.getValue('CREATE_LOC').CREATE_LOC,
					'INOUT_NUM'		: panelResult2.getValue('INOUT_NUM'),
					'ORDER_TYPE'	: directMasterStore.data.items[0].get('ORDER_TYPE')
				}
				//20210305 수정: 사이트 지급결의 등록으로 가도록 수정
				var rec1 = {data : {prgID : 's_map100ukrv_wm', 'text':'<t:message code="system.label.purchase.slipentry" default="지급결의 등록"/>'}};
				parent.openTab(rec1, '/z_wm/s_map100ukrv_wm.do', params);
			}
		},'-'],
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns: [
//			{dataIndex: 'PHONE'				, width:100	, hidden: false},
//			{dataIndex: 'BANK_NAME'			, width:100	, hidden: false},
//			{dataIndex: 'BANK_ACCOUNT'		, width:100	, hidden: false},
//			{dataIndex: 'BANK_ACCOUNT_EXPOS', width:100	, hidden: false},
//			{dataIndex: 'BIRTHDAY'			, width:100	, hidden: false},
//			{dataIndex: 'ZIP_CODE'			, width:100	, hidden: false},
//			{dataIndex: 'ADDR1'				, width:100	, hidden: false},
			{dataIndex: 'INOUT_SEQ'			, width:57	, align:'center'},
			{dataIndex: 'TYPE'				, width:100	, align:'center'},
			{dataIndex: 'CUSTOM_PRSN'		, width:100},
			{dataIndex: 'INOUT_TYPE_DETAIL'	, width:100	, align:'center'},
			{dataIndex: 'WH_CODE'			, width:80,
				listeners:{
					render:function(elm) {
						elm.editor.on('beforequery',function(queryPlan, eOpts)  {
							var store = queryPlan.combo.store;
							var selRecord =  masterGrid.uniOpt.currentRecord;
							store.clearFilter();
							if(!Ext.isEmpty(selRecord.get('DIV_CODE'))) {
								store.filterBy(function(record) {
									return record.get('option') == selRecord.get('DIV_CODE');
								});
							} else {
								store.filterBy(function(record) {
									return false;
								});
							}
						})
					}
				}
			},
			{dataIndex: 'WH_CELL_CODE'		, width:100	, hidden:sumtypeCell,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filter('option', record.get('WH_CODE'));
				}
			},
			{dataIndex: 'ITEM_CODE'			, width:130	,
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
						applyextparam: function(popup) {
							popup.setExtParam({'SELMODEL': 'MULTI'});
							popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': panelResult2.getValue("DIV_CODE")});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width:180	,
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
						applyextparam: function(popup) {
							popup.setExtParam({'SELMODEL': 'MULTI'});
							popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': panelResult2.getValue("DIV_CODE")});
						}
					}
				})
			},
			{dataIndex: 'SPEC'				, width:150},
			{dataIndex: 'LOT_NO'			, width:120	, hidden: sumtypeLot,
				getEditor: function(record) {
					var inoutTypeValue = record.get('INOUT_TYPE_DETAIL');
					return getLotPopupEditor(sumtypeLot, inoutTypeValue);
				}
			},
			{dataIndex: 'ORDER_UNIT'		, width:80	, align: 'center'},
			{dataIndex: 'ORDER_UNIT_Q'		, width:100	, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_FOR_P'	, width:100},
			{dataIndex: 'ORDER_UNIT_FOR_O'	, width:100	, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_P'		, width:100},
			{dataIndex: 'ORDER_UNIT_I'		, width:100	, summaryType: 'sum'},
			{dataIndex: 'LOT_YN'			, width:120	, hidden: true },
			{dataIndex: 'TRNS_RATE'			, width:66	, maxLength:12},
			{dataIndex: 'STOCK_UNIT'		, width:88	, align: 'center'},
			{dataIndex: 'INOUT_Q'			, width:100	, summaryType: 'sum'},
			{dataIndex: 'SOF_ORDER_NUM'		, width:100	, hidden:true},
			{dataIndex: 'SOF_ORDER_SEQ'		, width:80	, hidden:true},
			{dataIndex: 'SOF_CUSTOM_NAME'	, width:100	, hidden:true},
			{dataIndex: 'SOF_ITEM_NAME'		, width:120	, hidden:true},
			{dataIndex: 'PRICE_YN'			, width:100	, hidden: false },
			{dataIndex: 'MONEY_UNIT'		, width:88	, align: 'center', hidden: true},
			{dataIndex: 'EXCHG_RATE_O'		, width:88	, hidden: true },
			{dataIndex: 'INOUT_P'			, width:115},
			{dataIndex: 'INOUT_I'			, width:100	, summaryType: 'sum' },
			{dataIndex: 'TRANS_COST'		, width:88	},
			{dataIndex: 'TARIFF_AMT'		, width:88	},
			{dataIndex: 'ACCOUNT_YNC'		, width:88	},
			{dataIndex: 'ORDER_TYPE'		, width:88	},
			{dataIndex: 'BL_NUM'			, width:88	, maxLength:20},
			{dataIndex: 'ORDER_NUM'			, width:120},
			{dataIndex: 'ORDER_SEQ'			, width:57	,align: 'center'},
			{dataIndex: 'ITEM_STATUS'		, width:80	},
			{dataIndex: 'MAKE_LOT_NO'		, width:100},
			{dataIndex: 'MAKE_DATE'			, width:100},
			{dataIndex: 'MAKE_EXP_DATE'		, width:100},
			{dataIndex: 'REMARK'			, width:188	, maxLength:200},
			{dataIndex: 'PROJECT_NO'		, width:120	,
				getEditor : function(record) {
					return getPjtNoPopupEditor();
				}
			},
			{dataIndex: 'TRADE_LOC'			, width:88},
			{dataIndex: 'INOUT_NUM'			, width:110	, hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'	, width:80	, hidden: true},
			{dataIndex: 'LC_NUM'			, width:100	, hidden: true},
			{dataIndex: 'INOUT_PRSN'		, width:100	, hidden: true},
			{dataIndex: 'ACCOUNT_Q'			, width:80	, hidden: true},
			{dataIndex: 'CREATE_LOC'		, width:80	, hidden: true},
			{dataIndex: 'SALE_C_DATE'		, width:100	, hidden: true},
			{dataIndex: 'ITEM_ACCOUNT'		, width:100	, hidden: true},
			{dataIndex: 'INOUT_TYPE'		, width:100	, hidden: true},
			{dataIndex: 'INOUT_CODE'		, width:100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width:80	, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width:80	, hidden: true},
			{dataIndex: 'INOUT_DATE'		, width:100	, hidden: true},
			{dataIndex: 'INOUT_METH'		, width:80	, hidden: true},
			{dataIndex: 'ORDER_Q'			, width:80	, hidden: true},
			{dataIndex: 'GOOD_STOCK_Q'		, width:100	, hidden: true},
			{dataIndex: 'BAD_STOCK_Q'		, width:100	, hidden: true},
			{dataIndex: 'ORIGINAL_Q'		, width:100	, hidden: true},
			{dataIndex: 'NOINOUT_Q'			, width:80	, hidden: true},
			{dataIndex: 'COMPANY_NUM'		, width:80	, hidden: true},
			{dataIndex: 'INOUT_FOR_P'		, width:80	, hidden: true},
			{dataIndex: 'INOUT_FOR_O'		, width:80	, hidden: true},
			{dataIndex: 'INSTOCK_Q'			, width:80	, hidden: true},
			{dataIndex: 'SALE_DIV_CODE'		, width:80	, hidden: true},
			{dataIndex: 'SALE_CUSTOM_CODE'	, width:80	, hidden: true},
			{dataIndex: 'BILL_TYPE'			, width:80	, hidden: true},
			{dataIndex: 'SALE_TYPE'			, width:80	, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width:80	, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width:80	, hidden: true},
			{dataIndex: 'EXCESS_RATE'		, width:80	, hidden: true},
			{dataIndex: 'BASIS_NUM'			, width:80	, hidden: true},
			{dataIndex: 'BASIS_SEQ'			, width:80	, hidden: true},
			{dataIndex: 'SCM_FLAG_YN'		, width:80	, hidden: true},
			{dataIndex: 'STOCK_CARE_YN'		, width:88	, hidden: true},
			{dataIndex: 'COMP_CODE'			, width:80	, hidden: true},
			{dataIndex: 'INSERT_DB_USER'	, width:80	, hidden: true},
			{dataIndex: 'INSERT_DB_TIME'	, width:80	, hidden: true},
			{dataIndex: 'FLAG'				, width:80	, hidden: true},
			{dataIndex: 'INSPEC_NUM'		, width:105	, hidden: false},
			{dataIndex: 'INSPEC_SEQ'		, width:80	, hidden: false},
			{dataIndex: 'RECEIPT_NUM'		, width:105	, hidden: false},
			{dataIndex: 'RECEIPT_SEQ'		, width:80	, hidden: false}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.data.ACCOUNT_Q != '0') {
					return false;
				}
				if(e.record.data.ORDER_NUM != '') {
					if(UniUtils.indexOf(e.field, ['BL_NUM'])) {
						if(e.record.data.ORDER_TYPE != '3') {
							return true;
						} else {
							return false;
						}
					}
					if(UniUtils.indexOf(e.field, ['ACCOUNT_YNC','ORDER_UNIT_Q','INOUT_SEQ'
												 ,'WH_CELL_CODE','INOUT_I','INOUT_P','PRICE_YN','EXCHG_RATE_O','MONEY_UNIT','MAKE_LOT_NO','MAKE_DATE','MAKE_EXP_DATE'])) {
						return true;
					}
					if(UniUtils.indexOf(e.field, ['ITEM_STATUS'])) {
						if(BsaCodeInfo.gsProcessFlag == "PG") {
							return false;
						} else {
							return true;
						}
					}
					if(UniUtils.indexOf(e.field, ['LOT_NO','ORDER_UNIT_P','ORDER_UNIT_I','ORDER_UNIT_FOR_P'
												 ,'ORDER_UNIT_FOR_O','REMARK','PROJECT_NO','TRANS_COST','TARIFF_AMT'])) {
						return true;
					}
					if(UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL'])) {
						return true;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['BL_NUM'])) {
						if(e.record.data.ORDER_TYPE != '3') {
							return true;
						} else {
							return false;
						}
					}
					if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','INOUT_METH','WH_CODE'
												 ,'WH_CELL_CODE','ORDER_TYPE','INOUT_SEQ'])) {
						if(e.record.phantom == true) {
							return true;
						}
						return false;
					}
					if(UniUtils.indexOf(e.field, ['INOUT_P','ORDER_UNIT_Q','INOUT_I','ACCOUNT_YNC'
												 ,'PRICE_YN','MONEY_UNIT','EXCHG_RATE_O','MAKE_LOT_NO','MAKE_DATE','MAKE_EXP_DATE'])) {
						return true;
					}
					if(UniUtils.indexOf(e.field, ['ITEM_STATUS'])) {
						if(BsaCodeInfo.gsProcessFlag == "PG") {
							return false;
						} else {
							return true;
						}
					}
					if(UniUtils.indexOf(e.field, ['LOT_NO','ORDER_UNIT_P','ORDER_UNIT_I','ORDER_UNIT_FOR_P'
												 ,'ORDER_UNIT_FOR_O','ORDER_UNIT','REMARK','PROJECT_NO','TRANS_COST','TARIFF_AMT'])) {
						return true;
					}
					if(UniUtils.indexOf(e.field, ['TRNS_RATE'])) {
						if(e.record.data.ORDER_UNIT != e.record.data.STOCK_UNIT) {
							return true;
						} else {
							return false;
						}
					}
					if(UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL'])) {
						return true;
					}
				}
				return false;
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			var grdRecord = this.getSelectedRecord();
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, "");
				grdRecord.set('ITEM_NAME'		, "");
				grdRecord.set('SPEC'			, "");
				grdRecord.set('STOCK_UNIT'		, "");
				grdRecord.set('ORDER_UNIT'		, "");
				grdRecord.set('TRNS_RATE'		, 0);
				grdRecord.set('ITEM_ACCOUNT'	, "");
				grdRecord.set('STOCK_Q'			, "");
				grdRecord.set('GOOD_STOCK_Q'	, "");
				grdRecord.set('BAD_STOCK_Q'		, "");
				grdRecord.set('LOT_YN'			, '');
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('ORDER_UNIT'		, record['ORDER_UNIT']);
				grdRecord.set('TRNS_RATE'		, record['PUR_TRNS_RATE']);
				grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
				grdRecord.set('LOT_YN'			, record['LOT_YN']);
				grdRecord.set('INOUT_Q'			, grdRecord.get('ORDER_UNIT_Q') *  grdRecord.get('TRNS_RATE'));
				var param = {
					"ITEM_CODE"		: record['ITEM_CODE'],
					"CUSTOM_CODE"	: panelResult2.getValue('CUSTOM_CODE'),
					"DIV_CODE"		: panelResult2.getValue('DIV_CODE'),
					"MONEY_UNIT"	: panelResult2.getValue('MONEY_UNIT'),
					"ORDER_UNIT"	: record['ORDER_UNIT'],
					"INOUT_DATE"	: panelResult2.getValue('INOUT_DATE')
				};
				s_mms520ukrv_wmService.fnOrderPrice(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						if(provider['SALES_TYPE'] && provider['SALES_TYPE'] != '') {
							grdRecord.set('SALES_TYPE'	, provider['SALES_TYPE']);
						} else {
							grdRecord.set('SALES_TYPE'	, '0');
						}
						grdRecord.set('ORDER_UNIT_FOR_P', provider['ORDER_P']);
						grdRecord.set('ORDER_UNIT_P'	, (provider['ORDER_P'] * grdRecord.get('EXCHG_RATE_O')));
						grdRecord.set('INOUT_FOR_P'		, (provider['ORDER_P'] / grdRecord.get('TRNS_RATE')));
						grdRecord.set('INOUT_P'			, (provider['ORDER_P'] / grdRecord.get('TRNS_RATE') * grdRecord.get('EXCHG_RATE_O')));
					}
				})
				UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );
			}
		}
	});

	var inoutNoMasterGrid = Unilite.createGrid('s_mms520ukrv_wminoutNoMasterGrid', {	//조회버튼 누르면 나오는 조회창
		layout		: 'fit',
		excelTitle	: '<t:message code="system.label.purchase.receiptentry" default="입고등록"/>(<t:message code="system.label.purchase.receiptnosearch2" default="입고번호검색"/>)',
		store		: inoutNoMasterStore,
		uniOpt		: {
			expandLastColumn: false,
			useRowNumberer	: false
		},
		columns:  [
			{ dataIndex: 'INOUT_NAME'		, width:166},
			{ dataIndex: 'INOUT_DATE'		, width:86},
			{ dataIndex: 'INOUT_CODE'		, width:120	, hidden:true},
			{ dataIndex: 'WH_CODE'			, width:100},
			{ dataIndex: 'WH_CELL_CODE'		, width:120	, hidden:!sumtypeCell},
			{ dataIndex: 'DIV_CODE'			, width:100},
			{ dataIndex: 'INOUT_PRSN'		, width:100	, align: 'center'},
			{ dataIndex: 'INOUT_NUM'		, width:126	, align: 'center'},
			{ dataIndex: 'BL_NO'			, width:100	, align: 'center',hidden:false},
			{ dataIndex: 'INOUT_TYPE_DETAIL', width:100},
			{ dataIndex: 'ITEM_CODE'		, width:100	, hidden:true},
			{ dataIndex: 'ITEM_NAME'		, width:400},
			{ dataIndex: 'MONEY_UNIT'		, width:53	, align: 'center',hidden:true},
			{ dataIndex: 'EXCHG_RATE_O'		, width:53	, hidden:true},
			{ dataIndex: 'CREATE_LOC'		, width:53	, hidden:true},
			{ dataIndex: 'PERSON_NAME'		, width:53	, hidden:true},
			{ dataIndex: 'ORDER_TYPE'		, width:53	, hidden:true}	//20210226 추가: PANEL에 발주형태 필드 추가
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				inoutNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
				panelResult2.setAllFieldsReadOnly(true);
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			gsQueryFlag = true;
			panelResult2.setValues({
				'DIV_CODE'		: record.get('DIV_CODE'),
				'INOUT_DATE'	: record.get('INOUT_DATE'),
				'INOUT_NUM'		: record.get('INOUT_NUM'),
				'WH_CODE'		: record.get('WH_CODE'),
				'CUSTOM_CODE'	: record.get('INOUT_CODE'),
				'CUSTOM_NAME'	: record.get('INOUT_NAME'),
				'EXCHG_RATE_O'	: record.get('EXCHG_RATE_O'),
				'MONEY_UNIT'	: record.get('MONEY_UNIT'),
				'INOUT_PRSN'	: record.get('INOUT_PRSN'),
				'CREATE_LOC'	: record.get('CREATE_LOC'),
				'PERSON_NAME'	: record.get('PERSON_NAME'),
				'ORDER_TYPE'	: record.get('ORDER_TYPE')	//20210226 추가: PANEL에 발주형태 필드 추가
			});

			if(BsaCodeInfo.gsSumTypeCell=='Y') {
				panelResult2.getField('WH_CELL_CODE').getStore().getFilters().removeAll();
				panelResult2.getField('WH_CELL_CODE').getStore().filter('option', record.get('WH_CODE'));
				panelResult2.setValue('WH_CELL_CODE', record.get('WH_CELL_CODE'));
				//위의 필터 초기화 버그 때문에 아래 4줄 실행함 ( 필터가 한쪽만 초기화됨...)
				panelResult2.getField('WH_CELL_CODE').focus();
				panelResult2.getField('WH_CODE').focus();
				panelResult2.getField('WH_CELL_CODE').focus();
				panelResult2.getField('WH_CODE').focus();
			}
		}
	});



	function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.purchase.receiptnosearch2" default="입고번호검색"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'}, //위치 확인 필요
				items	: [inoutNoSearch, inoutNoMasterGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler	: function() {
						inoutNoMasterStore.loadStoreRecords();
					},
					disabled: false
				}, {
					itemId	: 'inoutNoCloseBtn',
					text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler	: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						inoutNoSearch.clearForm();
						inoutNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						inoutNoSearch.clearForm();
						inoutNoMasterGrid.reset();
					},
					show: function( panel, eOpts ) {
						inoutNoSearch.setValue('DIV_CODE'		, panelResult2.getValue('DIV_CODE'));
						inoutNoSearch.setValue('INOUT_DATE_FR'	, UniDate.get('startOfMonth'));
						inoutNoSearch.setValue('INOUT_DATE_TO'	, UniDate.get('today'));
						inoutNoSearch.setValue('WH_CODE'		, panelResult2.getValue('WH_CODE'));
						inoutNoSearch.setValue('INOUT_CODE'		, panelResult2.getValue('CUSTOM_CODE'));
						inoutNoSearch.setValue('INOUT_NAME'		, panelResult2.getValue('CUSTOM_NAME'));
						inoutNoSearch.setValue('INOUT_PRSN'		, panelResult2.getValue('INOUT_PRSN'));
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}



	Unilite.Main({
		id			: 's_mms520ukrv_wmApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [{
				region	: 'center',
				xtype	: 'container',
				layout	: 'fit',
				items	: [ masterGrid ]
			},
			panelResult2,
			{
				region	: 'north',
				xtype	: 'container',
				highth	: 20,
				layout	: 'fit',
				items	: [ panelResult ]
			}]
		}],
		fnInitBinding: function() {
			gsQueryFlag = false;
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			panelResult2.setAllFieldsReadOnly(false);
			gsBlSum = 0;
			var inoutNo = panelResult2.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow()
			} else {
				directMasterStore.loadStoreRecords();
			}
		},
		onNewDataButtonDown: function() {
			if(Ext.isEmpty(panelResult2.getValue('CUSTOM_CODE'))) {
				Unilite.messageBox('<t:message code="system.message.purchase.message059" default="거래처를 선택해 주세요."/>');
				return false;
			}
			if(!this.checkForNewDetail()) return false;

			var accountYnc		= 'Y';
			var inoutNum		= panelResult2.getValue('INOUT_NUM');
			var seq				= !directMasterStore.max('INOUT_SEQ')?1:directMasterStore.max('INOUT_SEQ')+1
			var inoutType		= '1';
			var inoutCodeType	= '4';
			var whCode			= panelResult2.getValue('WH_CODE');
			var whCellCode		= panelResult2.getValue('WH_CELL_CODE');
			var inoutPrsn		= panelResult2.getValue('INOUT_PRSN');
			var inoutCode		= panelResult2.getValue('CUSTOM_CODE');
			var customName		= panelResult2.getValue('CUSTOM_NAME');
			var createLoc		= panelResult2.getValue('CREATE_LOC').CREATE_LOC;
			var inoutDate		= panelResult2.getValue('INOUT_DATE');
			var inoutMeth		= '2';
			var inoutTypeDetail	= '99'; //gsInoutTypeDetail ?? 확인필요
			var itemStatus		= '1';
			var accountQ		= '0';
			var orderUnitQ		= '0';
			var inoutQ			= '0';
			var inoutI			= '0';
			var moneyUnit		= panelResult2.getValue('MONEY_UNIT');
			var inoutP			= '0';
			var inoutForP		= '0';
			var inoutForO		= '0';
			var originalQ		= '0';
			var noinoutQ		= '0';
			var goodStockQ		= '0';
			var badStockQ		= '0';
			var exchgRateO		= panelResult2.getValue('EXCHG_RATE_O');
			var trnsRate		= '1';
			var divCode			= panelResult2.getValue('DIV_CODE');
			var companyNum		= BsaCodeInfo.gsCompanyNum; // ??확인필요
			var saleDivCode		= '*';
			var saleCustomCode	= '*';
			var saleType		= '*';
			var billType		= '*';
			var priceYn			= 'Y';
			var excessRate		= '0';
			var orderType		= panelResult2.getValue('ORDER_TYPE');			//매입, 20210226 수정: 20210226 추가: PANEL에 발주형태 필드 추가하여 해당 값 가져가도록 수정 - '9'; -> panelResult2.getValue('ORDER_TYPE');
			var transCost		= '0';
			var tariffAmt		= '0';
			var deptCode		= panelResult2.getValue('DEPT_CODE');

			var r = {
				TYPE				: 'E',
				ACCOUNT_YNC			: accountYnc,
				INOUT_TYPE			: inoutType,
				INOUT_CODE_TYPE		: inoutCodeType,
				WH_CODE				: whCode,
				WH_CELL_CODE		: whCellCode,
				INOUT_PRSN			: inoutPrsn,
				INOUT_CODE			: inoutCode,
				CUSTOM_NAME			: customName,
				CREATE_LOC			: createLoc,
				INOUT_DATE			: inoutDate,
				INOUT_METH			: inoutMeth,
				INOUT_TYPE_DETAIL	: inoutTypeDetail,
				ITEM_STATUS			: itemStatus,
				ACCOUNT_Q			: accountQ,
				ORDER_UNIT_Q		: orderUnitQ,
				INOUT_Q				: inoutQ,
				INOUT_I				: inoutI,
				MONEY_UNIT			: moneyUnit,
				INOUT_P				: inoutP,
				INOUT_FOR_P			: inoutForP,
				INOUT_FOR_O			: inoutForO,
				ORIGINAL_Q			: originalQ,
				NOINOUT_Q			: noinoutQ,
				GOOD_STOCK_Q		: goodStockQ,
				BAD_STOCK_Q			: badStockQ,
				EXCHG_RATE_O		: exchgRateO,
				TRNS_RATE			: trnsRate,
				DIV_CODE			: divCode,
				COMPANY_NUM			: companyNum,
				SALE_DIV_CODE		: saleDivCode,
				SALE_CUSTOM_CODE	: saleCustomCode,
				SALE_TYPE			: saleType,
				BILL_TYPE			: billType,
				PRICE_YN			: priceYn,
				EXCESS_RATE			: excessRate,
				ORDER_TYPE			: orderType,
				TRANS_COST			: transCost,
				TARIFF_AMT			: tariffAmt,
				INOUT_NUM			: inoutNum,
				INOUT_SEQ			: seq,
				DEPT_CODE			: deptCode,
				SALES_TYPE			: 0,
				CUSTOM_PRSN			: panelResult2.getValue('CUSTOM_PRSN'),
				PHONE				: panelResult2.getValue('PHONE'),
				BANK_NAME			: panelResult2.getValue('BANK_NAME'),
				BANK_ACCOUNT		: panelResult2.getValue('BANK_ACCOUNT'),
				BANK_ACCOUNT_EXPOS	: panelResult2.getValue('BANK_ACCOUNT_EXPOS'),
				BIRTHDAY			: panelResult2.getValue('BIRTHDAY'),
				ZIP_CODE			: panelResult2.getValue('ZIP_CODE'),
				ADDR1				: panelResult2.getValue('ADDR1'),
				REMARK				: panelResult2.getValue('REMARK')
			}
			masterGrid.createRow(r);
		},
		onResetButtonDown: function() {
			gsQueryFlag = false;
			panelResult2.clearForm();
			panelResult.clearForm();
			panelResult2.setAllFieldsReadOnly(false);
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			gsBlSum = 0;
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
			} else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('ACCOUNT_Q') != 0) {
					Unilite.messageBox('<t:message code="system.message.purchase.message042" default="매입등록된 자료는 삭제, 수정할 수 없습니다."/>');
				} else {
					masterGrid.deleteSelectedRow();
				}
			}
			directMasterStore.fnSumBlAmountI();
			directMasterStore.fnSumAmountI();
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom) {						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else {									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('<t:message code="system.message.purchase.message008" default="전체삭제 하시겠습니까?"/>')) {
						if(record.get('ACCOUNT_Q') != 0) {
							Unilite.messageBox('<t:message code="system.message.purchase.message042" default="매입등록된 자료는 삭제, 수정할 수 없습니다."/>');
						} else {
							var deletable = true;
							if(deletable) {
								masterGrid.reset();
								UniAppManager.app.onSaveDataButtonDown();
							}
							isNewData = false;
						}
					}
					return false;
				}
			});
			if(isNewData) {								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelResult2.getValue('INOUT_NUM'))) {
				Unilite.messageBox('<t:message code="unilite.msg.sMS514" default="입고번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}
			if(panelResult2.setAllFieldsReadOnly(true)) {
				return true;
			}
			return false;
		},
		setDefault: function() {
			gsBlSum = 0;
			panelResult2.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult2.setValue('INOUT_DATE'	, new Date());
			panelResult2.setValue('ORDER_TYPE'	, '9');				//20210226 추가: PANEL에 발주형태 필드 추가
			panelResult2.getField('CREATE_LOC').setValue('2');
			panelResult2.getForm().wasDirty = false;
			panelResult2.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
			var field = panelResult2.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = inoutNoSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			UniAppManager.app.fnExchngRateO(true);
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelResult2.getValue('INOUT_DATE')),
				"MONEY_UNIT": panelResult2.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)) {
					if(provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(panelResult2.getValue('MONEY_UNIT')) && panelResult2.getValue('MONEY_UNIT') != "KRW") {
						Unilite.messageBox('<t:message code="system.message.purchase.datacheck002" default="환율정보가 없습니다."/>')
					}
					panelResult2.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
				}
			});
		},
		cbStockQ: function(provider, params) {
			var rtnRecord	= params.rtnRecord;
			var dStockQ		= provider['STOCK_Q'];
			var dGoodStockQ	= provider['GOOD_STOCK_Q'];
			var dBadStockQ	= provider['BAD_STOCK_Q'];
			rtnRecord.set('STOCK_Q'		, dStockQ);
			rtnRecord.set('GOOD_STOCK_Q', dGoodStockQ);
			rtnRecord.set('BAD_STOCK_Q'	, dBadStockQ);
		}
	});



	Unilite.createValidator('validator01', {
		store	: directMasterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			switch(fieldName) {
				case "MAKE_DATE" :
					if(!Ext.isEmpty(record.get('ITEM_CODE'))) {
						if(!Ext.isEmpty(newValue)) {
							var params = {
								'ITEM_CODE' : record.get('ITEM_CODE')
							};
							s_mms520ukrv_wmService.selectExpirationdate(params, function(provider, response) {
								if(!Ext.isEmpty(provider) && provider.EXPIRATION_DAY != 0) {
									record.set('MAKE_EXP_DATE',UniDate.getDbDateStr(UniDate.add(newValue, {months: + provider.EXPIRATION_DAY , days:-1})));
								} else {
									//Unilite.messageBox('유효기간을 설정하지 않은 품목입니다. 유효기간을 설정해주세요.');
									record.set('MAKE_EXP_DATE', '');
								}
							});
						}
					} else {
						rv ='작업지시를 할 품목을 입력해주세요.';
						break;
					}
					break;

				case "INOUT_SEQ" :
					if(newValue != '') {
						if(!isNaN(newValue)) {
							rv='<t:message code="system.message.purchase.message075" default="숫자만 입력가능합니다."/>';
							break;
						}
						if(newValue <= 0) {
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						}
					}
					break;

				case "ITEM_CODE" :
					if(record.get('ACCOUNT_YNC') == 'N' && record.get('INOUT_TYPE_DETAIL') != '20') {
						record.set('PRICE_YN'			, 'N');
						record.set('INOUT_FOR_O'		, '0');
						record.set('INOUT_FOR_P'		, '0');
						record.set('ORDER_UNIT_FOR_O'	, '0');
						record.set('ORDER_UNIT_FOR_P'	, '0');
						record.set('INOUT_I'			, '0');
						record.set('INOUT_P'			, '0');
						record.set('ORDER_UNIT_I'		, '0');
						record.set('ORDER_UNIT_P'		, '0');

						directMasterStore.fnSumAmountI();
					}
					break;

				case "ITEM_NAME" :
					if(record.get('ACCOUNT_YNC') == 'N' && record.get('INOUT_TYPE_DETAIL') != '20') {
						record.set('PRICE_YN'			, 'N');
						record.set('INOUT_FOR_O'		, '0');
						record.set('INOUT_FOR_P'		, '0');
						record.set('ORDER_UNIT_FOR_O'	, '0');
						record.set('ORDER_UNIT_FOR_P'	, '0');
						record.set('INOUT_I'			, '0');
						record.set('INOUT_P'			, '0');
						record.set('ORDER_UNIT_I'		, '0');
						record.set('ORDER_UNIT_P'		, '0');

						directMasterStore.fnSumAmountI();
					}
					break;

				case "WH_CODE" :
					if(!Ext.isEmpty(newValue)) {
						record.set('WH_CELL_CODE', "");
						record.set('WH_CELL_NAME', "");
						record.set('LOT_NO', "");
					} else {
						record.set('WH_CODE', "");
						record.set('WH_CELL_CODE', "");
						record.set('WH_CELL_NAME', "");
						record.set('LOT_NO', "");
					}
					//그리드 창고cell콤보 reLoad..
//					cbStore.loadStoreRecords(newValue);			//20201020 주석

					//20201020 추가: 그리드 창고 선택 시, 창고cell 값 set되도록 기능 추가
					var param = {
						DIV_CODE: panelResult2.getValue('DIV_CODE'),
						WH_CODE	: newValue
					}
					s_mms520ukrv_wmService.getWhCellCode(param, function(provider, response) {
						if(!Ext.isEmpty(provider)) {
							record.set('WH_CELL_CODE', provider);
						}
					})
					break;

				case "ORDER_UNIT_Q" :  //입고수량(구매단위)
					if(newValue != oldValue) {
						if(record.get('ITEM_CODE') == '') {
							rv='<t:message code="system.message.purchase.message028" default="품목코드를 입력 하십시오."/>';
							break;
						}
					}
					var dInoutQ3	= newValue * record.get('TRNS_RATE');
					var moneyUnit	= panelResult2.getValue('MONEY_UNIT');
					if(!(newValue < '0')) {
						if(record.get('ORDER_NUM') != '') {
							var dOrderQ		= record.get('ORDER_Q');				//발주량
							var dInoutQ		= newValue * record.get('TRNS_RATE');	//입력한 입고량  * 입수
							var dNoInoutQ	= record.get('NOINOUT_Q');				//미입고량
							var dEnableQ	= (dOrderQ + dOrderQ * record.get('EXCESS_RATE') / 100) / record.get('TRNS_RATE');			//(발주량 + 발주량 * 과입고허용률 / 100) / 입수
							var dTempQ		= ((dOrderQ - dNoInoutQ + dInoutQ - record.get('ORIGINAL_Q')) / record.get('TRNS_RATE'));	//(발주량 - 미입고량 + (입력한 입고량*입수) - 기존입고량	) / 입수
							if(dNoInoutQ > 0) {
								if(dTempQ > dEnableQ) {
									 dEnableQ = (dNoInoutQ + record.get('ORIGINAL_Q')) / record.get('TRNS_RATE') + (dEnableQ - (dOrderQ / record.get('TRNS_RATE')));
									//	(미입고량 + 기존입고량) / 입수 + (1100 - 발주량 /입수 )
									rv='<t:message code="system.message.purchase.message030" default="입고량은 발주량에 과입고허용률을 적용한 입고가능량보다 클 수 없습니다."/>' + '<t:message code="system.label.purchase.receiptavailbleqty" default="입고가능수량"/>' + ":" + dEnableQ;
									break;
								}
							}
						}
					}
					record.set('INOUT_Q',dInoutQ3);

					if(BsaCodeInfo.gsInvstatus == '+') {
						if(record.get('STOCK_CARE_YN') == 'Y') {
							if(newValue < 0) {
								var dInoutQ1 = 0;
								var dOriginalQ = 0;
								dInoutQ1 = dInoutQ1 + newValue;
								dOriginalQ = dOriginalQ + record.get('ORIGINAL_Q');

								if(record.get('ITEM_STATUS') == '1') {
									dStockQ = record.get('GOOD_STOCK_Q');
								} else {
									dStockQ = record.get('BAD_STOCK_Q');
								}
								if((dStockQ - dOriginalQ) < dInoutQ1 * -1) {
									rv='<t:message code="system.message.purchase.message069" default="(-) 입고 수량은 재고량을 초과할 수 없습니다."/>'+" : " + (dStockQ - dOriginalQ) ;
										record.set('INOUT_Q', oldValue);
								}
							}
						}
					}

					if(record.get('ORDER_UNIT_P') != '') {
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_P') * newValue));					//자사금액= 자사단가 * 입력한입고량
					} else {
						record.set('ORDER_UNIT_I','0');
					}

					if(record.get('ORDER_UNIT_FOR_P') != '') {
						record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_FOR_P') * newValue));			//구매금액 = 구매단가 * 입력한 입고량
					} else {
						record.set('ORDER_UNIT_FOR_O','0');
					}
					record.set('INOUT_Q'	, (newValue * record.get('TRNS_RATE')));						//수불수량(재고) = 입력수량 * 입수
					record.set('INOUT_P'	, (record.get('ORDER_UNIT_P') / record.get('TRNS_RATE')));		//자사단가(재고) = 자사단가 / 입수
					record.set('INOUT_I'	, record.get('ORDER_UNIT_I'));									//자사금액(재고) = 자사금액
					record.set('INOUT_FOR_P', (record.get('ORDER_UNIT_FOR_P')/ record.get('TRNS_RATE')));	//재고단위단가  = 구매단가 / 입수량
					record.set('INOUT_FOR_O', record.get('ORDER_UNIT_FOR_O'));								//재고단위금액  = 구매금액

					directMasterStore.fnSumAmountI();
				break;

				case "ORDER_UNIT_FOR_P":	//입고단가
					//20200908 수정: jpy 관련로직 추가로 전체 수정
					var moneyUnit = panelResult2.getValue('MONEY_UNIT');
					if((record.get('ACCOUNT_YNC')== 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')) {
						if(newValue <= 0) {
							rv='<t:message code="system.message.purchase.message032" default="기표대상여부가 기표일때 단가는 0보다 커야 합니다."/>';
							break;
						}
					} else {
						if(newValue < 0) {
							rv='<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
							break;
						}
					}
					record.set('ORDER_UNIT_FOR_O', (record.get('ORDER_UNIT_Q') * newValue));
					record.set('INOUT_FOR_P',(newValue / record.get('TRNS_RATE')));					//재고단위단가 = 입고단가 / 입수
					record.set('INOUT_FOR_O',(record.get('INOUT_FOR_P') * record.get('INOUT_Q')));	//재고단위금액 = 단가 * 수량

					directMasterStore.fnSumAmountI();
					if(record.get('EXCHG_RATE_O') != 0) {
						record.set('INOUT_P'		,UniMatrl.fnExchangeApply(moneyUnit, (record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O'))));	//자사단가(재고) = 재고단위단가 * 환율, 20200908 수정: jpy 관련로직 수정
						record.set('INOUT_I'		,(record.get('INOUT_P') * record.get('INOUT_Q'))); //
						record.set('ORDER_UNIT_P'	,UniMatrl.fnExchangeApply(moneyUnit, (newValue * record.get('EXCHG_RATE_O'))));				//자사단가 = 입력한 구매단가 * 환율, 20200908 수정: jpy 관련로직 수정
						record.set('ORDER_UNIT_I'	,(record.get('ORDER_UNIT_P') * record.get('ORDER_UNIT_Q')));	//자사금액 = 입고량 * 자사단가
					} else {
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					break;

				case "ORDER_UNIT_FOR_O" : //입고금액
					var moneyUnit = panelResult2.getValue('MONEY_UNIT');
					//20200403 변경: != '' -> != 0
					if(record.get('ORDER_UNIT_Q') != 0) {
						if((newValue <= 0) && (record.get('ORDER_UNIT_Q') > 0)) {
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						}else if((newValue >= 0) && (record.get('ORDER_UNIT_Q') < 0)) {
							rv='<t:message code="system.message.purchase.message034" default="음수만 입력가능합니다."/>';
							break;
						}
					}

					if(record.get('INOUT_TYPE_DETAIL') != '90' && record.get('INOUT_TYPE_DETAIL') != '91') {
						if(newValue <= '0') {
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						}
					}

					if(record.get('EXCHG_RATE_O') != 0) {
						record.set('INOUT_I'		, UniMatrl.fnExchangeApply(moneyUnit, (newValue * record.get('EXCHG_RATE_O'))));						//자사단가(재고) = 재고단위단가 * 환율, 20200908 수정: jpy 관련로직 수정
						record.set('INOUT_FOR_O'	, newValue);
						record.set('ORDER_UNIT_I'	, UniMatrl.fnExchangeApply(moneyUnit, (newValue * record.get('EXCHG_RATE_O'))));						//자사금액 = 입력한 구매금액 * 환율, 20200908 수정: jpy 관련로직 수정
					} else {
						record.set('INOUT_I'		, newValue);
						record.set('ORDER_UNIT_I'	, newValue);
						record.set('INOUT_FOR_O'	, newValue);
					}
					directMasterStore.fnSumAmountI();
					break;

				case "ORDER_UNIT_P":	//자사단가
					var moneyUnit = panelResult2.getValue('MONEY_UNIT');
					if((record.get('ACCOUNT_YNC') == 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')) {
						if(newValue <= 0) {
							rv='<t:message code="system.message.purchase.message032" default="기표대상여부가 기표일때 단가는 0보다 커야 합니다."/>';
							break;
						}
					} else {
						if(newValue < 0) {
							rv='<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
							break;
						}
					}

					record.set('INOUT_P',(newValue / record.get('TRNS_RATE')));	//자사단가(재고) = 입력한 자사단가 / 입수
					record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * newValue));	//자사금액 = 입고량 * 입력한 자사단가
					record.set('INOUT_I',(record.get('ORDER_UNIT_I')));	//자사금액(재고) = 자사금액
					if(record.get('EXCHG_RATE_O') != 0) {
						record.set('INOUT_FOR_P',UniMatrl.fnExchangeApply2(moneyUnit, (record.get('INOUT_P') / record.get('EXCHG_RATE_O'))));						//재고단위단가 = 자사단가(재고)/환율, 20200908 수정: jpy 관련로직 수정
						record.set('ORDER_UNIT_FOR_P',UniMatrl.fnExchangeApply2(moneyUnit, (newValue / record.get('EXCHG_RATE_O'))));								//구매단가 = 입력한 자사단가 / 환율, 20200908 수정: jpy 관련로직 수정
						record.set('ORDER_UNIT_FOR_O',UniMatrl.fnExchangeApply2(moneyUnit, (record.get('ORDER_UNIT_Q') * newValue / record.get('EXCHG_RATE_O'))));	//구매금액 = 입고량 * 입력한 자사단가 / 환율, 20200908 수정: jpy 관련로직 수정
						record.set('INOUT_FOR_O',record.get("ORDER_UNIT_FOR_O"));
					} else {
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}

					directMasterStore.fnSumAmountI();
					break;

				case "ORDER_UNIT_I" :	//자사금액
					var moneyUnit = panelResult2.getValue('MONEY_UNIT');

					if(record.get('ORDER_UNIT_Q') != 0) {
						if((newValue <= 0) && (record.get('ORDER_UNIT_Q') > 0)) {
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						}else if((newValue >= 0) && (record.get('ORDER_UNIT_Q') < 0)) {
							rv='<t:message code="system.message.purchase.message034" default="음수만 입력가능합니다."/>';
							break;
						}
					}

					record.set('INOUT_I', newValue);

					directMasterStore.fnSumAmountI();
					break;

				case "INOUT_P" :	//자사단가(재고)
					var moneyUnit = panelResult2.getValue('MONEY_UNIT');

					if((record.get('ACCOUNT_YNC')== 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')) {
						if(newValue <= 0) {
							rv='<t:message code="system.message.purchase.message032" default="기표대상여부가 기표일때 단가는 0보다 커야 합니다."/>';
							break;
						}
					} else {
						if(newValue < 0) {
							rv='<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
							break;
						}
					}

					record.set('INOUT_I', (record.get('INOUT_Q') * newValue));	//자사금액(재고) = 재고단위 수량 * 입력한 자사단가(재고)

					if(record.get('EXCHG_RATE_O') != 0) {
						record.set('INOUT_FOR_P',UniMatrl.fnExchangeApply2(moneyUnit, (newValue / record.get('EXCHG_RATE_O'))));							//재고단위단가 = 입력한 자사단가(재고) / 환율, 20200908 수정: jpy 관련로직 수정
						record.set('INOUT_FOR_O',UniMatrl.fnExchangeApply2(moneyUnit, (record.get('INOUT_Q') * newValue / record.get('EXCHG_RATE_O'))));	//재고단위금액 = 재고단위수량 * 입력한 자사단가(재고) / 환율, 20200908 수정: jpy 관련로직 수정
					} else {
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
					}
					directMasterStore.fnSumAmountI();
					break;

				case "TRNS_RATE" :	//입수
					if(newValue <= 0) {
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}

					if(record.get('ORDER_UNIT_Q') != '0') {
						record.set('INOUT_Q',record.get('ORDER_UNIT_Q') * newValue);	//재고단위수량 = 입고량 * 입력한 입수
					} else {
						record.set('INOUT_Q','0');
					}

					if(record.get('ORDER_UNIT_P') != '') {
						record.set('INOUT_P',(record.get('ORDER_UNIT_P') / newValue));	//자사단가(재고) = 자사단가 / 입력한 입수
					} else {
						record.set('INOUT_P','0');
					}

					if(record.get('ORDER_UNIT_FOR_P') != '') {
						record.set('INOUT_FOR_P',(record.get('ORDER_UNIT_FOR_P') / newValue));	//재고단위단가 = 구매단가 / 입력한 입수
					} else {
						record.set('INOUT_FOR_P','0');
					}
					break;

				case "EXCHG_RATE_O" :	//환율
					var moneyUnit = panelResult2.getValue('MONEY_UNIT');

					if((record.get('ACCOUNT_YNC')== 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')) {
						if(newValue <= 0) {
							rv='<t:message code="system.message.purchase.message032" default="기표대상여부가 기표일때 단가는 0보다 커야 합니다."/>';
							break;
						}
					} else {
						if(newValue < 0) {
							rv='<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
							break;
						}
					}

					record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					if(record.get('INOUT_Q') != 0) {
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}
					directMasterStore.fnSumAmountI();

					if(newValue != 0) {
						record.set('INOUT_P'		,UniMatrl.fnExchangeApply(moneyUnit, (record.get('INOUT_FOR_P') * newValue)));		//자사단가(재고) = 재고단위단가 * 입력한 환율, 20200908 수정: jpy 관련로직 수정
						record.set('INOUT_I'		,record.get('ORDER_UNIT_Q') * record.get('INOUT_P'));
						record.set('ORDER_UNIT_P'	,UniMatrl.fnExchangeApply(moneyUnit, (record.get('ORDER_UNIT_FOR_P') * newValue)));	//20200908 수정: jpy 관련로직 수정
						record.set('ORDER_UNIT_I'	,(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));
					} else {
						record.set('INOUT_P','0');
						record.set('INOUT_I','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					break;

				case "INOUT_TYPE_DETAIL" :
					if(record.get('ACCOUNT_YNC') == 'N') {
						record.set('PRICE_YN','N');
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');

						directMasterStore.fnSumAmountI();
					} else {
						record.set('PRICE_YN','Y');
					};

					if(newValue == '20') {
						if(Ext.isEmpty(BsaCodeInfo.gsInoutType)) {
							record.set('ACCOUNT_YNC','N');
						} else {
							record.set('ACCOUNT_YNC',BsaCodeInfo.gsInoutType);
						}
					} else {
						record.set('ACCOUNT_YNC','Y');
					}
					break;

				case "ACCOUNT_YNC":
					if(newValue == 'N') {
						record.set('PRICE_YN','N');
					}
					break;
				case "PRICE_YN":
					if(newValue == 'Y') {
						if((record.get('INOUT_P') == 0) || (record.get('ORDER_UNIT_P') == 0)) {
							rv='<t:message code="system.message.purchase.message070" default="단가는 0보다 커야 합니다."/>';
							break;
						}
					}
					break;
				case "PROJECT_NO":
					break;
				case "TRANS_COST":
					if(newValue < 0) {
						rv='<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
						break;
					}
				case "TARIFF_AMT":
					if(newValue < 0) {
						rv='<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
						break;
					}
			}
			return rv;
		}
	});

	Unilite.createValidator('validator02', {
		forms: {'formA:':panelResult2},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate2 >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "EXCHG_RATE_O" :  // 환율
					if(panelResult2.getValue('MONEY_UNIT') == BsaCodeInfo.gsDefaultMoney) {
						if(newValue != '1') {
							rv='<t:message code="system.message.purchase.message071" default="화폐단위가 자사화폐인 경우 환율은 1이어야 합니다."/>';
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
					if(item.isPopupField) {
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
				if(Ext.isDefined(item.holdable) ) {
					if (item.holdable == 'hold') {
						item.setReadOnly(false);
					}
				}
				if(item.isPopupField) {
					var popupFC = item.up('uniPopupField')	;
					if(popupFC.holdable == 'hold' ) {
						item.setReadOnly(false);
					}
				}
			})
			}
		return r;
	}

	function getPjtNoPopupEditor() {
		var editField = Unilite.popup('PROJECT_G',{
			DBtextFieldName	: 'PROJECT_NO',
			textFieldName	: 'PROJECT_NO',
			autoPopup		: true,
			listeners		: {
				'applyextparam': function(popup) {
					var selectRec = masterGrid.getSelectedRecord();
					if(selectRec) {
						popup.setExtParam({'BPARAM0': 3});
						popup.setExtParam({'CUSTOM_CODE': selectRec.get("CUSTOM_CODE")});
						popup.setExtParam({'CUSTOM_NAME': selectRec.get("CUSTOM_NAME")});
					}
				},
				'onSelected': {
					fn: function(record, type) {
						var selectRec = masterGrid.getSelectedRecord()
						if(selectRec) {
							selectRec.set('PROJECT_NO', record[0]["PJT_CODE"]);
						}
					},
					scope: this
				},
				'onClear': function(type) {
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

	function getLotPopupEditor(sumtypeLot, inoutTypeValue) {
		var editField;
		if(inoutTypeValue == '90' && ! sumtypeLot) {
			editField = Unilite.popup('LOTNO_G',{
				textFieldName	: 'LOTNO_CODE',
				DBtextFieldName	: 'LOTNO_CODE',
				width			: 1000,
				autoPopup		: true,
				listeners		: {
					'onSelected': {
						fn: function(record, type) {
							var selectRec = masterGrid.getSelectedRecord()
							if(selectRec) {
								selectRec.set('LOT_NO'		, record[0]["LOT_NO"]);
								selectRec.set('GOOD_STOCK_Q', record[0]["GOOD_STOCK_Q"]);
								selectRec.set('BAD_STOCK_Q'	, record[0]["BAD_STOCK_Q"]);
							}
						},
						scope: this
					},
					'onClear': {
						fn: function(record, type) {
							var selectRec = masterGrid.getSelectedRecord()
							if(selectRec) {
								selectRec.set('LOT_NO'		, '');
								selectRec.set('GOOD_STOCK_Q', 0);
								selectRec.set('BAD_STOCK_Q'	, 0);
							}
						},
						scope: this
					},
					applyextparam: function(popup) {
						var selectRec = masterGrid.getSelectedRecord();
						if(selectRec) {
							popup.setExtParam({'DIV_CODE'		:  selectRec.get('DIV_CODE')});
							popup.setExtParam({'ITEM_CODE'		: selectRec.get('ITEM_CODE')});
							popup.setExtParam({'ITEM_NAME'		: selectRec.get('ITEM_NAME')});
							popup.setExtParam({'CUSTOM_CODE'	: panelResult2.getValue('CUSTOM_CODE')});
							popup.setExtParam({'CUSTOM_NAME'	: panelResult2.getValue('CUSTOM_NAME')});
							popup.setExtParam({'WH_CODE'		: selectRec.get('WH_CODE')});
							popup.setExtParam({'WH_CELL_CODE'	: selectRec.get('WH_CELL_CODE')});
							popup.setExtParam({'stockYN'		: 'Y'});
						}
					}
				 }
			});
		} else {
			editField = {xtype : 'textfield', maxLength:20}
		}

		var editor = Ext.create('Ext.grid.CellEditor', {
			ptype			: 'cellediting',
			clicksToEdit	: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
			autoCancel		: false,
			selectOnFocus	: true,
			field			: editField
		});
		return editor;
	}





	//바코드 입력 로직 (검사번호)
	function fnEnterInspecNumBarcode(newValue) {
		var detailRecords	= directMasterStore.data.items;
		var InspecNum		= newValue
		var flag			= true;

		//동일한 검사번호 입력되었을 경우 처리
		Ext.each(detailRecords, function(detailRecord,i) {
			if(detailRecord.get('INSPEC_NUM').toUpperCase() == InspecNum.toUpperCase()) {
				beep();
				gsText	= '<t:message code="system.label.sales.message001" default="동일한  검사번호가 이미 등록 되었습니다."/>';
				flag	= false;
				openAlertWindow(gsText);
				Ext.getBody().unmask();
				panelResult2.getField('INSPEC_NUM').focus();
				return false;
			}
		});

		if(flag) {
			var param = {
				CUSTOM_CODE		: panelResult2.getValue('CUSTOM_CODE'),
				CREATE_LOC		: panelResult2.getValues().CREATE_LOC,
				WINDOW_FLAG		: 'inspectResult',
				TYPE			: 'R',					//매입접수: 'P' - 구매발주
				INSPEC_NUM		: InspecNum
			}
			//검사결과참조 쿼리 호출
			s_mms520ukrv_wmService.selectinspectResultList(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					panelResult2.setValue('CUSTOM_CODE'	, provider[0].CUSTOM_CODE);
					panelResult2.setValue('CUSTOM_NAME'	, provider[0].CUSTOM_NAME);
					panelResult2.setValue('MONEY_UNIT'	, provider[0].MONEY_UNIT);

					var isIni = false;
					var param = {
						"AC_DATE"	: UniDate.getDbDateStr(panelResult2.getValue('INOUT_DATE')),
						"MONEY_UNIT": panelResult2.getValue('MONEY_UNIT')
					};
					salesCommonService.fnExchgRateO(param, function(provider2, response) {
						if(!Ext.isEmpty(provider2)) {
							if(provider2.BASE_EXCHG == "1" && !isIni && !Ext.isEmpty(panelResult2.getValue('MONEY_UNIT')) && panelResult2.getValue('MONEY_UNIT') != "KRW") {
								Unilite.messageBox('<t:message code="system.message.purchase.datacheck002" default="환율정보가 없습니다."/>')
							}
							panelResult2.setValue('EXCHG_RATE_O', provider2.BASE_EXCHG);

							Ext.each(provider, function(record,i) {
								UniAppManager.app.onNewDataButtonDown();
								masterGrid.setInspectData(record);
							});
						} else {
							Ext.each(provider, function(record,i) {
								UniAppManager.app.onNewDataButtonDown();
								masterGrid.setInspectData(record);
							});
						}
						setTimeout(function() { panelResult2.getField('INSPEC_NUM').focus();}, 1000);
					});
				} else {
					Unilite.messageBox('<t:message code="system.label.sales.message002" default="입력하신 검사번호의 데이터가 존재하지 않습니다."/>');
					Ext.getBody().unmask();
					panelResult2.setValue('INSPEC_NUM', '');
					panelResult2.getField('INSPEC_NUM').focus();
					return false;
				}
			});
		}
	}

	//바코드 입력 로직 (검사번호)
	function beep() {
		audioCtx					= new(window.AudioContext || window.webkitAudioContext)();
		var oscillator				= audioCtx.createOscillator();
		var gainNode				= audioCtx.createGain();
		oscillator.connect(gainNode);
		gainNode.connect(audioCtx.destination);
		gainNode.gain.value			= 0.1;			//VOLUME 크기
		oscillator.frequency.value	= 4100;
		oscillator.type				= 'sine';		//sine, square, sawtooth, triangle
		oscillator.start();

		setTimeout(
			function() {
				oscillator.stop();
			},
			1000									//길이
		);
	};

	//메세지 창
	var alertSearch = Unilite.createSearchForm('alertSearch', {
		layout	: {
			type	: 'uniTable',
			columns	: 1,
			tdAttrs	: {width: '100%', align : 'center', style: 'background-color: #dfe8f6;'}	//cfd9e7
		},
		items	:[{
			xtype	: 'component',
			itemId	: 'TEXT_TEST',
			html	: '',
			width	: 330,
			height	: 50,
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
				text	: '<t:message code="system.label.sales.confirm" default="확인"/>',
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
				title	: '<t:message code="system.label.sales.warntitle" default="경고"/>',
				layout	: {type: 'vbox', align: 'stretch'},
				items	: [alertSearch],
				width	: 350,
				height	: 120,
				listeners: {
					beforehide: function(me, eOpt) {
						alertSearch.clearForm();
					},
					beforeclose: function( panel, eOpts ) {
						alertSearch.clearForm();
					},
					beforeshow: function( panel, eOpts ) {
						alertSearch.down('#TEXT_TEST').setHtml(gsText);
					}
				}
			})
		}
		alertWindow.center();
		alertWindow.show();
	}



	//전화번호 체크로직 추가, 20210218 수정: 안심번호 체크로직 추가
	function tel_check(str) {
//		var regTel = /^(01[016789]{1}|070|02|0[3-9]{1}[0-9]{1})-[0-9]{3,4}-[0-9]{4}$/;
		var regTel = /^(050[2-8]{1}|01[016789]{1}|070|02|0[3-9]{1}[0-9]{1})-[0-9]{3,4}-[0-9]{4}$/;
		if(!regTel.test(str)) {
			return false;
		}
		return true;
	}
};
</script>