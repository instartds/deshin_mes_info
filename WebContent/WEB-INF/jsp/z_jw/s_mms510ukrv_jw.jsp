<%--
'	프로그램명 : 입고등록 (구매재고)
'	작	성	자 : (주)포렌 개발실
'	작	성	일 :
'	최종수정자 :
'	최종수정일 :
'	버		전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mms510ukrv_jw"	>
	<t:ExtComboStore comboType="BOR120" pgmId="s_mms510ukrv_jw" />			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" />						<!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />						<!-- 화폐 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />			<!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="M001" />						<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" />						<!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M505" opts= '2;6'/>			<!-- 생성경로 (폼) -->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '2;6'/>			<!-- 생성경로 (그리드) -->
	<t:ExtComboStore comboType="AU" comboCode="M103" />						<!-- 입고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B021" />						<!-- 품목상태 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" />						<!-- 단가형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />						<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="S014" />						<!-- 기표대상 -->
	<t:ExtComboStore comboType="AU" comboCode="YP08" />						<!-- 조건 -->
	<t:ExtComboStore comboType="AU" comboCode="YP09" />						<!-- 형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" />						<!-- 과세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="Z010" />						<!-- 사용처 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

</style>

<!-- zeber printer 관련 -->
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/zebraPrint/BrowserPrint-1.0.4.min.js" />'></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/zebraPrint/jquery-1.11.1.min.js" />'></script>


<script type="text/javascript" >


/* @@@@@@@@@@@@@@@@@@@@@@ zebra printer 관련  */
var available_printers = null;
var selected_category = null;
var default_printer = null;
var selected_printer = null;
var format_start = "^XA";
var format_end = "^XZ";
var default_mode = true;

function setup_web_print(){
	default_mode = true;
	selected_printer = null;
	available_printers = null;
	selected_category = null;
	default_printer = null;

	BrowserPrint.getDefaultDevice('printer', function(printer){
		default_printer = printer
		if((printer != null) && (printer.connection != undefined)){
			selected_printer = printer;
		}
		BrowserPrint.getLocalDevices(function(printers){
			available_printers = printers;
			var printers_available = false;
			if (printers != undefined){
				for(var i = 0; i < printers.length; i++){
					if (printers[i].connection == 'usb'){
						printers_available = true;

						console.log('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' +printer.uid);
					}
				}
			}
			if(!printers_available){
//				alert('No Zebra Printers could be found!');
				return;
			}else if(selected_printer == null){
				default_mode = false;
				changePrinter();
			}
		}, undefined, 'printer');
	},
	function(error_response){
		showBrowserPrintNotFound();
	});
};
function strFm(number, width) {
	number = number + '';
	return number.length >= width ? number : new Array(width - number.length + 1).join('0') + number;
}
function showBrowserPrintNotFound(){
//	alert('An error occured while attempting to connect to your Zebra Printer. You may not have Zebra Browser Print installed, or it may not be running. Install Zebra Browser Print, or start the Zebra Browser Print Service, and try again.');
};
function checkPrinterStatus(finishedFunction){
	selected_printer.sendThenRead("~HQES",function(text){
		var that = this;
		var statuses = new Array();
		var ok = false;
		var is_error = text.charAt(70);
		var media = text.charAt(88);
		var head = text.charAt(87);
		var pause = text.charAt(84);
		// check each flag that prevents printing
		if (is_error == '0')
		{
			ok = true;
			statuses.push("Ready to Print");
		}
		if (media == '1')
			statuses.push("Paper out");
		if (media == '2')
			statuses.push("Ribbon Out");
		if (media == '4')
			statuses.push("Media Door Open");
		if (media == '8')
			statuses.push("Cutter Fault");
		if (head == '1')
			statuses.push("Printhead Overheating");
		if (head == '2')
			statuses.push("Motor Overheating");
		if (head == '4')
			statuses.push("Printhead Fault");
		if (head == '8')
			statuses.push("Incorrect Printhead");
		if (pause == '1')
			statuses.push("Printer Paused");
		if ((!ok) && (statuses.Count == 0))
			statuses.push("Error: Unknown Error");
		finishedFunction(statuses.join());
	}, printerError);
};
function printComplete(){
	alert ("Printing complete");
}
function changePrinter(){
	default_mode = false;
	selected_printer = null;
	if(available_printers == null)	{
		setTimeout(changePrinter, 200);
		return;
	}
	onPrinterSelected();

}
function onPrinterSelected(){
	selected_printer = available_printers[$('#printers')[0].selectedIndex];
}
function printerError(text){
	alert('An error occurred while printing. Please try again. '+ text);
}
function trySetupAgain(){
	$('#main').show();
	$('#error_div').hide();
	setup_web_print();
}
//라벨출력 순서를 위해 delaytime 부여
function sendDataToPrint(ms, prinfText){
	var start = new Date().getTime();var end=start;
	while(end < start + ms) {
		end = new Date().getTime();
	}
	selected_printer.send(prinfText);
}
/* zebra printer 관련 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   */


var SearchInfoWindow;			//조회버튼 누르면 나오는 조회창
var referNoReceiveWindow;		//미입고참조
var referReturnPossibleWindow;	//반품가능발주참조
var referInspectResultWindow;	//검사결과참조 (무검사겸용)
var windowFlag		= '';		//검사결과, 무검사 참조 구분 플래그
var gsMaxInoutSeq	= 0;

//var referScmRefWindow; //업체출고 참조(SCM)
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
	gsQ008Sub			: '${gsQ008Sub}',		//가입고사용여부 관련
	gsWorker			: '${gsWorker}',		//라벨출력에 인쇄될 작업자 정보
	gsSelectLabel		: '${gsSelectLabel}',	//출력할 라벨 선택
	gsLotInitail		: '${gsLotInitail}',	//LOT 이니셜
	gsReportGubun		: '${gsReportGubun}'	// 레포트 구분
};
if(Ext.isEmpty(BsaCodeInfo.gsSelectLabel)) {
	BsaCodeInfo.gsSelectLabel = '2';
}
if(Ext.isEmpty(BsaCodeInfo.gsWorker)) {
	BsaCodeInfo.gsWorker = '';
}
if(Ext.isEmpty(BsaCodeInfo.gsLotInitail)) {
	BsaCodeInfo.gsLotInitail = 'X';
}
BsaCodeInfo.gsInTypeAccountYN = Ext.data.StoreManager.lookup('CBS_AU_M103').data.items;
var CustomCodeInfo = {
	gsUnderCalBase: ''
};
var gsInoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_M103').getAt(0).get('value');
var outDivCode = UserInfo.divCode;


//var output ='';
//	for(var key in BsaCodeInfo){
//		output += key + '	:	' + BsaCodeInfo[key] + '\n';
//	}
//	alert(output);


var aa = 0;
function appMain() {

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
			read	: 's_mms510ukrv_jwService.selectList',
			update	: 's_mms510ukrv_jwService.updateDetail',
			create	: 's_mms510ukrv_jwService.insertDetail',
			destroy	: 's_mms510ukrv_jwService.deleteDetail',
			syncAll	: 's_mms510ukrv_jwService.saveAll'
		}
	});
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_mms510ukrv_jwService.selectList2',
			update	: 's_mms510ukrv_jwService.updateDetail',
			create	: 's_mms510ukrv_jwService.insertDetail',
			destroy	: 's_mms510ukrv_jwService.deleteDetail',
			syncAll	: 's_mms510ukrv_jwService.saveAll2'
		}
	});



	Unilite.defineModel('s_mms510ukrv_jwModel1', {
		fields: [
			{name: 'INOUT_NUM'				, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string',allowBlank: isAutoInoutNum},
			{name: 'INOUT_SEQ'				, text: '<t:message code="system.label.purchase.receiptseq2" default="입고순번"/>'				, type: 'int', allowBlank: true},
			{name: 'INOUT_METH'				, text: '<t:message code="system.label.purchase.method" default="방법"/>'						, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		, text: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>'				, type: 'string',comboType:'AU',comboCode:'M103', allowBlank: false},
			{name: 'ITEM_CODE' 				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME' 				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'ITEM_ACCOUNT' 			, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				, type: 'string',comboType: 'AU',comboCode: 'B020'},
			{name: 'SPEC'					, text: '<t:message code="system.label.purchase.spec" default="규격"/>'						, type: 'string'},
			{name: 'ORDER_UNIT'				, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				, type: 'string',comboType:'AU',comboCode:'B013', displayField: 'value'},
			{name: 'ORDER_UNIT_Q'			, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				, type: 'uniQty', allowBlank: true},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string',comboType:'AU',comboCode:'B013', displayField: 'value'},
			{name: 'INOUT_Q'				, text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>'		, type: 'uniQty'},
			{name: 'ORIGINAL_Q'				, text: '<t:message code="system.label.purchase.existinginqty" default="기존입고량"/>'			, type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'			, text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'				, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'			, text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'			, type: 'uniQty'},
			{name: 'NOINOUT_Q'				, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'				, type: 'uniQty'},
			{name: 'PRICE_YN' 				, text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'				, type: 'string',comboType:'AU',comboCode:'M301'},
			{name: 'MONEY_UNIT' 			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'					, type: 'string',comboType:'AU',comboCode:'B004', allowBlank: false, displayField: 'value' },
			{name: 'INOUT_FOR_P' 			, text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>'		, type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O' 			, text: '<t:message code="system.label.purchase.inventoryunitamount" default="재고단위금액"/>'	, type: 'uniPrice'},

			{name: 'EXCHG_RATE_O' 			, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				, type: 'uniER'},
			{name: 'INOUT_P' 				, text: '<t:message code="system.label.purchase.copricestock" default="자사단가(재고)"/>'			, type: 'uniUnitPrice', allowBlank: true, editable: false},
			{name: 'INOUT_I' 				, text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'				, type: 'uniPrice'},//기존 자사금액(재고)
			{name: 'TRANS_COST'				, text: '<t:message code="system.label.purchase.shippingcharge" default="운반비"/>'			, type: 'uniPrice'},
			{name: 'TARIFF_AMT'				, text: '<t:message code="system.label.purchase.Customs" default="관세"/>'					, type: 'uniPrice'},
			{name: 'ACCOUNT_YNC' 			, text: '<t:message code="system.label.purchase.sliptarget" default="기표대상"/>'				, type: 'string', comboType:'AU',comboCode:'S014', allowBlank: false},
			{name: 'ORDER_TYPE' 			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string',comboType:'AU',comboCode:'M001', allowBlank: false},
			{name: 'LC_NUM'					, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'					, type: 'string'},
			{name: 'BL_NUM'					, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'					, type: 'string'},
			{name: 'ORDER_NUM' 				, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'						, type: 'int'},
			{name: 'ORDER_Q'				, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'						, type: 'uniQty'},
			{name: 'INOUT_CODE_TYPE'		, text: '<t:message code="system.label.purchase.receiptplacetype" default="입고처구분"/>'		, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'			, type: 'string',store: Ext.data.StoreManager.lookup('whList'), allowBlank: false, child: 'WH_CELL_CODE'},
			{name: 'WH_CELL_CODE'			, text: '<t:message code="system.label.purchase.receiptwarehousecell" default="입고창고Cell"/>'	, type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','SALE_DIV_CODE']},
			{name: 'ITEM_STATUS'			, text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>'				, type: 'string',comboType:'AU',comboCode:'B021', allowBlank: false},
			{name: 'INOUT_DATE'				, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate', allowBlank: false},
			{name: 'END_DATE'				, text: '<t:message code="system.label.purchase.availableperiod" default="유효기간"/>(<t:message code="system.label.purchase.labelprint" default="라벨출력"/>)'																		, type: 'uniDate'},

			{name: 'DUMMY_INOUT_DATE'		, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'string'},
			{name: 'DUMMY_END_DATE'			, text: '<t:message code="system.label.purchase.availableperiod" default="유효기간"/>(<t:message code="system.label.purchase.labelprint" default="라벨출력"/>)'																		, type: 'string'},
			{name: 'QTY_FORMAT'				, text: '<t:message code="system.label.purchase.qtyformat" default="수량입력포맷"/>(<t:message code="system.label.purchase.labelprint" default="라벨출력"/>)'																		, type: 'string'},
			{name: 'INOUT_PRSN'				, text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'			, type: 'string'},
			{name: 'INOUT_PRSN_NAME'		, text: 'INOUT_PRSN_NAME'																	, type: 'string'},

			{name: 'ACCOUNT_Q'				, text: '<t:message code="system.label.purchase.billqty" default="계산서량"/>'					, type: 'uniQty'},
			{name: 'CREATE_LOC'				, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'				, type: 'string',comboType:'AU',comboCode:'B031'},
			{name: 'SALE_C_DATE'			, text: '<t:message code="system.label.purchase.billclosingdate" default="계산서마감일"/>'		, type: 'uniDate'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					, type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'LOT_NO'					, text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>'					, type: 'string'},
			{name: 'LOT_YN'					, text: '<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'			, type: 'string', comboType:'AU', comboCode:'A020'},
			{name: 'INOUT_TYPE'				, text: '<t:message code="system.label.purchase.type" default="타입"/>'						, type: 'string'},
			{name: 'INOUT_CODE'				, text: '<t:message code="system.label.purchase.receiptplace" default="입고처"/>'				, type: 'string', allowBlank: false},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'					, type: 'string', child: 'WH_CODE'},
			{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type: 'string'},
			{name: 'COMPANY_NUM'			, text: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				, type: 'string'},
			{name: 'INSTOCK_Q'				, text: '<t:message code="system.label.purchase.poreceiptqty" default="발주입고수량"/>'			, type: 'uniQty'},
			{name: 'INSPEC_NUM' 			, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'				, type: 'string'},
			{name: 'INSPEC_SEQ' 			, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'				, type: 'int'},
			{name: 'SALE_DIV_CODE'			, text: '<t:message code="system.label.purchase.salesdivision" default="매출사업장"/>'			, type: 'string'},
			{name: 'SALE_CUSTOM_CODE' 		, text: '<t:message code="system.label.purchase.salesplace" default="매출처"/>'				, type: 'string'},
			{name: 'BILL_TYPE'				, text: '<t:message code="system.label.purchase.salestype" default="매출유형"/>'				, type: 'string'},
			{name: 'SALE_TYPE'				, text: '<t:message code="system.label.purchase.salesclass" default="매출구분"/>'				, type: 'string'},
			{name: 'EXCESS_RATE'			, text: '<t:message code="system.label.purchase.overreceiptrate" default="과입고허용율"/>'		, type: 'string'},
			{name: 'TRNS_RATE'				, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'							, type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
			{name: 'ORDER_UNIT_FOR_P'		, text: '<t:message code="system.label.purchase.receiptprice" default="입고단가"/>'				, type: 'uniUnitPrice', allowBlank: true},
			{name: 'ORDER_UNIT_FOR_O'		, text: '<t:message code="system.label.purchase.receiptamount" default="입고금액"/>'			, type: 'uniPrice'/*, allowBlank: false*/},
			{name: 'ORDER_UNIT_P'			, text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'					, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_I' 			, text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'					, type: 'uniPrice'},			///////////////////////////////////////////////////////	INOUT_I
			{name: 'BASIS_NUM'				, text: '<t:message code="system.label.purchase.basisno" default="근거번호"/>'					, type: 'string'},
			{name: 'BASIS_SEQ'				, text: '<t:message code="system.label.purchase.basisseq" default="근거순번"/>'					, type: 'int'},
			{name: 'SCM_FLAG_YN'			, text: 'SCM_FLAG_YN'																		, type: 'string'},
			{name: 'TRADE_LOC'				, text: '<t:message code="system.label.purchase.tradelocation" default="무역경로"/>'			, type: 'string',comboType:'AU',comboCode:'T104'},
			{name: 'STOCK_CARE_YN'			, text: '<t:message code="system.label.purchase.inventorymanagementyn" default="재고관리여부"/>'		, type: 'string'},
			{name: 'COMP_CODE'				, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				, type: 'string'},
			{name: 'SALES_TYPE'				, text: '<t:message code="system.label.purchase.salestype" default="매출유형"/>'				, type: 'int'},
			{name: 'FLAG'					, text: 'FLAG'																				, type: 'string'},
			//20180725 추가 (ITEM_WIDTH, SQM)
			{name: 'ITEM_WIDTH'				,text: '<t:message code="system.label.purchase.width" default="폭(mm)"/>'					, type: 'float'	, decimalPrecision: 0	, format:'0,000'},
			{name: 'SQM'					,text: 'SQM'																				, type: 'float'	, decimalPrecision: 2	, format:'0,000.00'},
			//20180807 추가 (PACK_QTY)
			{name: 'PACK_QTY'				,text: '<t:message code="system.label.purchase.packingqty" default="포장수량"/>'				, type: 'float'	, decimalPrecision: 0	, format:'0,000'},
			//20181121 추가 (제조일: MAKE_DATE, 제조LOT: MAKE_LOT_NO)
			{name: 'MAKE_DATE'				,text: '<t:message code="system.label.purchase.mfgdate" default="제조일"/>'					, type: 'uniDate'},
			{name: 'MAKE_LOT_NO'			,text: '<t:message code="system.label.purchase.mfglot" default="제조LOT"/>'					, type: 'string'},
			{name: 'ITEM_LEVEL1'            ,text: 'ITEM_LEVEL1'                                                                        , type: 'string'}
//			{name: 'PURCHASE_TYPE'			, text: 'PURCHASE_TYPE'		, type: 'int'},
//			{name: 'PURCHASE_RATE'			, text: 'PURCHASE_RATE'		, type: 'int'}
		]
	});//Unilite.defineModel('s_mms510ukrv_jwModel1', {

	Unilite.defineModel('inoutNoMasterModel', {					//조회버튼 누르면 나오는 조회창
		fields: [
			{name: 'INOUT_NAME'				, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type: 'string'},
			{name: 'INOUT_DATE'				, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate'},
			{name: 'INOUT_CODE'				, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'				, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'			, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
			{name: 'WH_CELL_CODE'			, text: '<t:message code="system.label.purchase.receiptwarehousecell" default="입고창고Cell"/>'	, type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'					, type: 'string',comboType:'BOR120'},
			{name: 'INOUT_PRSN' 			, text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'			, type: 'string',comboType:'AU', comboCode:'B024'},
			{name: 'INOUT_NUM'				, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string'},
			{name: 'MONEY_UNIT'				, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'					, type: 'string'},
			{name: 'EXCHG_RATE_O'			, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				, type: 'uniER'},
			{name: 'CREATE_LOC'				, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'				, type: 'string',comboType:'AU',comboCode:'B031'},
			{name: 'PERSON_NAME'			, text: '<t:message code="system.label.purchase.employeename" default="사원명"/>'				, type: 'string'}
		]
	});

	Unilite.defineModel('s_mms510ukrv_jwRECEIVEModel', {		//미입고참조
		fields: [
			{name: 'GUBUN'					, text: '<t:message code="system.label.purchase.selection" default="선택"/>'				, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'DVRY_DATE'				, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'				, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		, type: 'string'},
			{name: 'ORDER_UNIT_Q'			, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				, type: 'uniQty'},
			{name: 'REMAIN_Q'				, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'		, type: 'uniQty'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'NOINOUT_Q'				, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량" />'		, type: 'uniQty'},
			{name: 'ORDER_Q'				, text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>', type: 'uniQty'},
			{name: 'UNIT_PRICE_TYPE'		, text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'			, type: 'string',comboType:'AU', comboCode:'M301'},
			{name: 'MONEY_UNIT'				, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				, type: 'string'},
			{name: 'EXCHG_RATE_O'			, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			, type: 'uniER'},
			{name: 'ORDER_P'				, text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>', type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_P'			, text: '<t:message code="system.label.purchase.price" default="단가"/>'					, type: 'uniUnitPrice'},
			{name: 'ORDER_O'				, text: '<t:message code="system.label.purchase.amount" default="금액"/>'					, type: 'uniPrice'},
			{name: 'ORDER_LOC_P'			, text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'				, type: 'uniUnitPrice'},
			{name: 'ORDER_LOC_O'			, text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'			, type: 'uniPrice'},
			{name: 'ORDER_NUM'				, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'string'},
			{name: 'INSPEC_NUM'				, text: '<t:message code="system.label.purchase.receiptinspecno" default="접수/검사번호"/>'	, type: 'string'},
			{name: 'INSPEC_SEQ'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'string'},
			{name: 'LC_NUM'					, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'				, type: 'string'},
			{name: 'ORDER_REQ_NUM'			, text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>', type: 'string'},
			{name: 'ORDER_TYPE'				, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'				, type: 'string', allowBlank: false},
			{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},
			{name: 'TRNS_RATE'				, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'			, type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
			{name: 'INSTOCK_Q'				, text: '<t:message code="system.label.purchase.poreceiptqty" default="발주입고수량"/>'		, type: 'uniQty'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'EXCESS_RATE'			, text: '<t:message code="system.label.purchase.overreceiptrate" default="과입고허용율"/>'	, type: 'uniPercent'},
			{name: 'ORDER_PRSN'				, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'		, type: 'string',comboType:'AU', comboCode:'M201'},
			{name: 'GOOD_STOCK_Q'			, text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>'			, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'			, text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'		, type: 'uniQty'},
			{name: 'LC_NO'					, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'BL_NO'					, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'				, type: 'string'},
			{name: 'BASIS_NUM'				, text: '<t:message code="system.label.purchase.basisno" default="근거번호"/>'				, type: 'string'},
			{name: 'BASIS_SEQ'				, text: '<t:message code="system.label.purchase.basisseq" default="근거순번"/>'			, type: 'string'},
			{name: 'LC_DATE'				, text: '<t:message code="system.label.purchase.lcdate" default="LC일"/>'				, type: 'uniDate'},
			{name: 'INVOICE_DATE'			, text: '<t:message code="system.label.purchase.customdate" default="통관일"/>'			, type: 'uniDate'},
			{name: 'TRADE_LOC'				, text: '<t:message code="system.label.purchase.tradelocation" default="무역경로"/>'		, type: 'string'},
			{name: 'LOT_NO'					, text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>'				, type: 'string'},
			{name: 'LOT_YN'					, text: '<t:message code="system.label.purchase.lotyn" default="LOT관리 여부"/>'			, type: 'string'},
			//20180725 추가 (ITEM_WIDTH, SQM)
			{name: 'ITEM_WIDTH'				, text: '<t:message code="system.label.purchase.width" default="폭(mm)"/>'				, type: 'float'	, decimalPrecision: 0	, format:'0,000'},
			//20180807 추가 (PACK_QTY)
			{name: 'PACK_QTY'				, text: '<t:message code="system.label.purchase.packingqty" default="포장수량"/>'			, type: 'float'	, decimalPrecision: 0	, format:'0,000'},
			//20190313 추가 (USAGE_PLACE)
			{name: 'USAGE_PLACE'			, text: '<t:message code="system.label.purchase.usageplace" default="사용처"/>'			, type: 'string',comboType:'AU',comboCode:'Z010'}
		]
	});

	Unilite.defineModel('s_mms510ukrv_jwINSPECTModel2', {		//검사결과참조
		fields: [
			{name: 'GUBUN'					, text: '<t:message code="system.label.purchase.selection" default="선택"/>'				, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'DVRY_DATE'				, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'INSPEC_DATE'			, text: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>'			, type: 'uniDate'},
			{name: 'ORDER_UNIT'				, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		, type: 'string'},
			{name: 'ORDER_O'				, text: '<t:message code="system.label.purchase.amount" default="금액"/>'					, type: 'uniPrice'},
			{name: 'NOINOUT_Q'				, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'		, type: 'uniQty'},
			{name: 'ITEM_STATUS'			, text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>'			, type: 'string',comboType:'AU', comboCode:'B021'},
			{name: 'UNIT_PRICE_TYPE'		, text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'			, type: 'string',comboType:'AU', comboCode:'M301'},
			{name: 'MONEY_UNIT'				, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				, type: 'string'},
			{name: 'ORDER_UNIT_P'			, text: '<t:message code="system.label.purchase.price" default="단가"/>'					, type: 'uniUnitPrice'},
			{name: 'EXCHG_RATE_O'			, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			, type: 'uniER'},
			{name: 'ORDER_LOC_P'			, text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'				, type: 'uniUnitPrice'},
			{name: 'ORDER_LOC_O'			, text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'			, type: 'uniPrice'},
			{name: 'ORDER_NUM'				, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'				, type: 'int'},
			{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'REMAIN_Q'				, text: '<t:message code="system.label.purchase.inspecqty" default="검사량"/>'			, type: 'uniQty'},
			{name: 'INSPEC_NUM'				, text: '<t:message code="system.label.purchase.receiptinspecno" default="접수/검사번호"/>'	, type: 'string'},
			{name: 'INSPEC_SEQ'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'int'},
			{name: 'PORE_Q'					, text: '<t:message code="system.label.purchase.pobalance" default="발주잔량"/>'			, type: 'uniQty'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'LOT_NO'					, text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>'				, type: 'string'},
			{name: 'LOT_YN'					, text: '<t:message code="system.label.purchase.lotyn" default="LOT관리 여부"/>'			, type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'LC_NO'					, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'BL_NO'					, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'				, type: 'string'},
			{name: 'BASIS_NUM'				, text: '<t:message code="system.label.purchase.basisno" default="근거번호"/>'				, type: 'string'},
			{name: 'BASIS_SEQ'				, text: '<t:message code="system.label.purchase.basisseq" default="근거순번"/>'			, type: 'int'},
			{name: 'LC_DATE'				, text: '<t:message code="system.label.purchase.lcdate" default="LC일"/>'				, type: 'uniDate'},
			{name: 'INVOICE_DATE'			, text: '<t:message code="system.label.purchase.customdate" default="통관일"/>'			, type: 'uniDate'},
			{name: 'TRADE_LOC'				, text: '<t:message code="system.label.purchase.tradelocation" default="무역경로"/>'		, type: 'string',comboType:'AU',comboCode:'T104'},
			{name: 'ITEM_ACCOUNT'			, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			, type: 'string'},
			{name: 'LC_NUM'					, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'				, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
			{name: 'ORDER_REQ_NUM'			, text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>', type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>'				, type: 'string'},
			{name: 'ORDER_TYPE'				, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'				, type: 'string'},
			{name: 'TRNS_RATE'				, text: '˂t:message code="system.label.purchase.containedqty" default="입수"/˃'			, type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'ORDER_Q'				, text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>', type: 'uniQty'},
			{name: 'ORDER_UNIT_Q'			, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				, type: 'uniQty'},
			{name: 'ORDER_P'				, text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>', type: 'uniUnitPrice'},
			{name: 'INSTOCK_Q'				, text: '<t:message code="system.label.purchase.poreceiptqty" default="발주입고수량"/>'		, type: 'uniQty'},
			{name: 'EXCESS_RATE'			, text: '<t:message code="system.label.purchase.overreceiptrate" default="과입고허용율"/>'	, type: 'string'},
			//20180725 추가 (ITEM_WIDTH, SQM)
			{name: 'ITEM_WIDTH'				,text: '<t:message code="system.label.purchase.width" default="폭(mm)"/>'				, type: 'float'	, decimalPrecision: 0	, format:'0,000'},
			//20180807 추가 (PACK_QTY)
			{name: 'PACK_QTY'				,text: '<t:message code="system.label.purchase.packingqty" default="포장수량"/>'			, type: 'float'	, decimalPrecision: 0	, format:'0,000'}
		]
	});



	var directMasterStore1 = Unilite.createStore('s_mms510ukrv_jwMasterStore1', {
		model: 's_mms510ukrv_jwModel1',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,
			useNavi		: false			// prev | newxt 버튼 사용
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

			var paramMaster	= panelResult.getValues();	//syncAll 수정
			var inoutSeq	= detailGrid.getStore().max('INOUT_SEQ') + 1;
			if(Ext.isEmpty(inoutSeq)) {
				inoutSeq = 1;
			}
			paramMaster.MAX_SEQ	= inoutSeq;

			Ext.each(list, function(record, index) {
				var inoutNum = panelResult.getValue('INOUT_NUM');

				if(!Ext.isEmpty(inoutNum)) {
					record.set('INOUT_NUM', inoutNum);
				}
				//lot_no 자동채번
//				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
//					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + 'LOT NO: 필수 입력값 입니다.');
//					isErr = true;
//					return false;
//				}
				if(record.get('INOUT_TYPE_DETAIL') != '91' && (record.get('INOUT_TYPE_DETAIL') != '20' || record.get('ACCOUNT_YNC') != 'N')){
					var msg = '';
					if(record.get('ORDER_UNIT_Q') == 0){
						msg += '<t:message code="system.label.purchase.receiptqty" default="입고량"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>' + '\n';
					}
					if(record.get('INOUT_Q') == 0){
						msg += '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>' + '\n';
					}
					if(record.get('ORDER_UNIT_FOR_P') == 0){
						msg += '<t:message code="system.label.purchase.receiptprice" default="입고단가"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>' + '\n';
					}
					if(record.get('ORDER_UNIT_P') == 0){
						msg += '<t:message code="system.label.purchase.coprice" default="자사단가"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>' + '\n';
					}
					if(record.get('ORDER_UNIT_FOR_O') == 0){
						msg += '<t:message code="system.label.purchase.receiptamount" default="입고금액"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>' + '\n';
					}
					if(msg != ''){
						alert((index + 1) + '<t:message code="system.message.purchase.message026" default="행의 입력값을 확인 해주세요."/>' + msg);
						isErr = true;
						return false;
					}
				} else if(record.get('INOUT_TYPE_DETAIL') == '20' && record.get('ACCOUNT_YNC') == 'N') {
					var msg = '';
					if(record.get('ORDER_UNIT_Q') == 0){
						msg += '<t:message code="system.label.purchase.receiptqty" default="입고량"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>' + '\n';
					}
					if(msg != ''){
						alert((index + 1) + '<t:message code="system.message.purchase.message026" default="행의 입력값을 확인 해주세요."/>' + msg);
						isErr = true;
						return false;
					}
				}
			});

			if(inValidRecs.length == 0 && !isErr) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("INOUT_NUM", master.INOUT_NUM);
						panelResult.setValue("INOUT_NUM", master.INOUT_NUM);
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);

						if(detailStore.isDirty()) {
							detailStore.saveStore();
						}
						if (directMasterStore1.count() == 0) {
							UniAppManager.app.onResetButtonDown();
						}else{
							directMasterStore1.loadStoreRecords();
							detailStore.loadStoreRecords();
						}
					 }
				};
				this.syncAllDirect(config);
			} else {
				if(!Ext.isEmpty(inValidRecs)){
					var grid = Ext.getCmp('s_mms510ukrv_jwGrid1');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		},
		listeners: {
				load: function(store, records, successful, eOpts) {
					this.fnSumAmountI();
					if(!Ext.isEmpty(records)) {
						Ext.each(records, function(record, i) {
							var itemWidth = record.get('ITEM_WIDTH');
							if(itemWidth == 0 || Ext.isEmpty(itemWidth)) {
								itemWidth = 1000;
							}
							record.set('SQM', record.get('ORDER_UNIT_Q') * record.get('TRNS_RATE') * itemWidth / 1000);
						});
						this.commitChanges();
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
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		fnSumAmountI:function(){
			var dAmountI = Ext.isNumeric(this.sum('INOUT_FOR_O')) ? this.sum('INOUT_FOR_O'):0;	// 재고단위금액
			var dIssueAmtWon = Ext.isNumeric(this.sum('INOUT_I')) ? this.sum('INOUT_I'):0;		// 자사금액(재고)

			panelResult.setValue('SumInoutO',dAmountI);
			panelResult.setValue('IssueAmtWon',dIssueAmtWon);
		}

	});//End of var directMasterStore1 = Unilite.createStore('s_mms510ukrv_jwMasterStore1', {

	var detailStore = Unilite.createStore('s_mms510ukrv_jwdetailStore', {
		model	: 's_mms510ukrv_jwModel1',
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
				if(activeGridId == 's_mms510ukrv_jwGrid1') {
					var oldGrid = Ext.getCmp(activeGridId);
					masterGrid.changeFocusCls(oldGrid);
					UniAppManager.setToolbarButtons('delete', false);
				}
				directMasterStore1.fnSumAmountI();
				if(!Ext.isEmpty(records)) {
					Ext.each(records, function(record, i) {
						var itemWidth = record.get('ITEM_WIDTH');
						if(itemWidth == 0 || Ext.isEmpty(itemWidth)) {
							itemWidth = 1000;
						}
						record.set('SQM', record.get('ORDER_UNIT_Q') * record.get('TRNS_RATE') * itemWidth / 1000);
					});
					this.commitChanges();
				}
			},
			add: function(store, records, index, eOpts) {
				directMasterStore1.fnSumAmountI();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				directMasterStore1.fnSumAmountI();
			},
			remove: function(store, record, index, isMove, eOpts) {
				directMasterStore1.fnSumAmountI();
			}
		},
		loadStoreRecords: function() {
			var param = panelResult.getValues();

			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success)	{
						//FIFO 위한 데이터 생성 (초기화)
//						gsLotNoS = ''
						panelResult.setValue('LOT_NO_S', '');
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
					alert((index + 1) + '˂t:message code="system.message.purchase.message026" default="행의 입력값을 확인 해주세요."/˃' + '\n' + 'LOT NO: ' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					isErr = true;
					return false;
				}
			});
			if(isErr) return false;

//			var totRecords = detailStore.data.items;
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

//						var inoutNum = panelResult.getValue('INOUT_NUM');
//						Ext.each(list, function(record, index) {
//							if(record.data['INOUT_NUM'] != inoutNum) {
//								record.set('INOUT_NUM', inoutNum);
//							}
//						})
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						Ext.getCmp('btnPrint').setDisabled(false);//출력버튼 활성화
						UniAppManager.setToolbarButtons('save', false);

						directMasterStore1.loadStoreRecords();
						detailStore.loadStoreRecords();

						if(detailStore.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var inoutNoMasterStore = Unilite.createStore('inoutNoMasterStore', {					//조회버튼 누르면 나오는 조회창
		model: 'inoutNoMasterModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 's_mms510ukrv_jwService.selectinoutNoMasterList'
			}
		},
		loadStoreRecords : function()	{
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

	var noReceiveStore = Unilite.createStore('s_mms510ukrv_jwNoReceiveStore', {				//미입고참조
		model: 's_mms510ukrv_jwRECEIVEModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 's_mms510ukrv_jwService.selectnoReceiveList'
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

	var inspectResultStore2 = Unilite.createStore('s_mms510ukrv_jwInspectResultStore', {	//검사결과참조(무검사참조겸용)
		model: 's_mms510ukrv_jwINSPECTModel2',
		autoLoad: false,
		uniOpt : {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 's_mms510ukrv_jwService.selectinspectResultList'
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
			param.WINDOW_FLAG = windowFlag;
			param["oScmYn"] = BsaCodeInfo.gsOScmYn;
			param["sDbName"] = BsaCodeInfo.gsDbName;
			param["DIV_CODE"] = panelResult.getValue("DIV_CODE")
			param["CUSTOM_CODE"] = panelResult.getValue("CUSTOM_CODE")
			param["ORDER_PRSN"] = panelResult.getValue("INOUT_PRSN")
			param["MONEY_UNIT"] = panelResult.getValue("MONEY_UNIT")
			param["EXCHG_RATE_O"] = panelResult.getValue("EXCHG_RATE_O")
			this.load({
				params : param
			});
		},groupField:'INSPEC_NUM'
	});



	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 6},
		padding:'1 1 1 1',
		border:true,
		items: [{
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
					var field = panelResult.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					var field2 = panelResult.getField('WH_CODE');
					field2.getStore().clearFilter(true);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			allowBlank		: false,
			holdable		: 'hold',
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
						panelResult.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
						panelResult.setValue('EXCHG_RATE_O', '1');
						panelResult.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelResult.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
						panelResult.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
						panelResult.setValue('EXCHG_RATE_O', '1');
						UniAppManager.app.fnExchngRateO();
					},
					scope: this
				},
				onClear: function(type)	{
					panelResult.setValue('CUSTOM_CODE', '');
					panelResult.setValue('CUSTOM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'CUSTOM_TYPE':  ['1', '2']});
				}
			}
		}),
		{
			fieldLabel	: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList'),
			allowBlank	: false,
			holdable	: 'hold',
//				child		: 'WH_CELL_CODE',
			listConfig	: {minWidth:230},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.amounttotal" default="금액합계"/>',
			name		: 'SumInoutO',
			xtype		: 'uniNumberfield',
			readOnly	: true,
			colspan		: 3
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
			name		: 'INOUT_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
		 	allowBlank	: false,
		 	holdable	: 'hold',
		 	listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',
			name		: 'INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024',
			holdable	: 'hold',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
			name		: 'CREATE_LOC',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B031',
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.ownamounttotal" default="자사금액합계"/>',
			name		: 'IssueAmtWon',
			xtype		: 'uniNumberfield',
			readOnly	: true,
			colspan		: 3
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>',
			xtype		: 'uniTextfield',
			name		: 'INOUT_NUM',
			readOnly	: isAutoInoutNum
		},{
			fieldLabel	: '<t:message code="system.label.purchase.currency" default="화폐"/>',
			name		: 'MONEY_UNIT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B004',
			allowBlank	: false,
			displayField: 'value',
			holdable	: 'hold',
			fieldStyle	: 'text-align: center;',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				blur: function( field, The, eOpts )	{
					UniAppManager.app.fnExchngRateO();
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.exchangerate" default="환율"/>',
			name		: 'EXCHG_RATE_O',
			xtype		: 'uniNumberfield',
			allowBlank	: false,
			holdable	: 'hold',
			decimalPrecision: 4,
			value		: 1,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype: 'component',
			width: 50
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.purchase.labelprint" default="라벨출력"/>',
			id		: 'btnPrint',
			width	: 80,
			handler	: function() {
				if(BsaCodeInfo.gsReportGubun == 'CLIP'){
					var param			= panelResult.getValues();
					var selectedDetails	= detailGrid.getSelectedRecords();
					var itemCodeList;
					var lotNoList;
					var whCodeList;

					param["PGM_ID"]			= PGM_ID;
					param["MAIN_CODE"]		= 'Z012';					//site report관련 공통코드
					param["WORKER"]			= BsaCodeInfo.gsWorker;
					param["GSSELECTLABEL"]	= BsaCodeInfo.gsSelectLabel;
					param["GSLOTINITAIL"]	= BsaCodeInfo.gsLotInitail;
					Ext.each(selectedDetails, function(record, idx) {
						if(idx ==0) {
							itemCodeList= record.get("ITEM_CODE");
							lotNoList	= record.get("LOT_NO");
							whCodeList	= record.get("WH_CODE");
						} else {
							itemCodeList= itemCodeList	+ ',' + record.get("ITEM_CODE");
							lotNoList	= lotNoList		+ ',' + record.get("LOT_NO");
							whCodeList	= whCodeList	+ ',' + record.get("WH_CODE");
						}
	  				});

					param.ITEM_CODE	= itemCodeList;
					param.LOT_NO	= lotNoList;
					param.WH_CODE	= whCodeList;

					var win = null;
					win = Ext.create('widget.ClipReport', {
						url		: CPATH+'/z_jw/s_mms510clukrv_jw.do',
						prgID	: 's_mms510ukrv_jw',
						extParam: param
					});
					win.center();
					win.show();

				} else {
					if(available_printers == null)	{
						alert('An error occurred while printing. Please try again.');
						return;
					}
					var selectedDetails = detailGrid.getSelectedRecords();
					if(Ext.isEmpty(selectedDetails)){
						return;
					}
					var dataArr = [];
					Ext.each(selectedDetails, function(record, idx) {
						dataArr.push(record.data);
					});

					checkPrinterStatus( function (text){
						if (text == "Ready to Print"){
							dataArr.sort(function(a, b){
								var x = a.LOT_NO.toLowerCase();
								var y = b.LOT_NO.toLowerCase();
								if (x < y) {return -1;}
								if (x > y) {return 1;}
								return 0;
							});
							Ext.each(dataArr, function(dataRaw,index){
								if(index == 0 ){
									Ext.Msg.alert('<t:message code="system.label.purchase.confirm" default="확인"/>', '<t:message code="system.label.purchase.success" default="성공"/>');
								}

								var itemCode = dataRaw.ITEM_CODE;
								var itemName = dataRaw.ITEM_NAME;
								var spec = dataRaw.SPEC;
								var trnsRate = dataRaw.TRNS_RATE;
//								var strTrnsRate = String.format("%.0f",trnsRate);;
								var stockUnit = dataRaw.STOCK_UNIT;//"EA";
								var inoutDate = UniDate.getDbDateStr(dataRaw.DUMMY_INOUT_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.DUMMY_INOUT_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.DUMMY_INOUT_DATE).substring(6,8);//"2018-06-20";
								var endDate = UniDate.getDbDateStr(dataRaw.DUMMY_END_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.DUMMY_END_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.DUMMY_END_DATE).substring(6,8);//"2018-12-20";
								var lotNo = dataRaw.LOT_NO;//"A18062000037";
//								var qtyFormat = ObjUtils.getSafeString(paramData.get("QTY_FORMAT"));
//								var orderUnitQ = dataRaw.ORDER_UNIT_Q;//ObjUtils.parseDouble(paramData.get("ORDER_UNIT_Q"));

								var orderUnitQ = dataRaw.ORDER_UNIT_Q;
								orderUnitQ = Unilite.multiply(orderUnitQ, trnsRate);
								var formatOrderUnitQ = orderUnitQ.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
								var inoutPrsnName = dataRaw.INOUT_PRSN_NAME;
								var itemLevel = dataRaw.ITEM_LEVEL1;

//								var DataMatrix = itemCode + "|" + lotNo + "|" + trnsRate;//String.format("%."+ nvl(paramData.get("QTY_FORMAT")) +"f",orderUnitQ);
								var DataMatrix = itemCode + "|" + lotNo + "|" + orderUnitQ;


								console.log('DataMatrix : ', DataMatrix);

								var waterMarkCheckV = UniDate.getDbDateStr(dataRaw.DUMMY_INOUT_DATE).substring(4, 6);

								var stringZPL = "";


								if(panelResult.getValue('DPI_GUBUN') == '1'){
									/* zt230 300dpi 용*/
									stringZPL += "^SEE:UHANGUL.DAT^FS";
									stringZPL += "^CW1,E:TIMESBD.TTF^CI28^FS";//"^CW1,E:MALGUNBD.TTF^CI28^FS";//"^CW1,E:TIMESBD.TTF^CI28^FS";	//TIMES NEW ROMAN 볼드
									stringZPL += "^PW900";			//라벨 가로 크기관련
									stringZPL += "^LH110,15^FS";	//x,y 축 시작점 지정

									if(lotNo.substring(0,1) == 'M' || lotNo.substring(0,1) == 'F'){		//20181126 'F'조건 추가
										if(BsaCodeInfo.gsSelectLabel == '2') {
											DataMatrix = itemCode + "|" + lotNo + "|" + orderUnitQ;
											//선그리기 시작
											stringZPL +="^FO0,0^GB735,560,6^FS";
											stringZPL +="^FO0,70^GB735,0,6^FS";
											stringZPL +="^FO0,160^GB735,0,6^FS";

											stringZPL +="^FO0,220^GB735,0,6^FS";
											stringZPL +="^FO0,280^GB735,0,6^FS";
											stringZPL +="^FO0,340^GB735,0,6^FS";
											stringZPL +="^FO0,400^GB735,0,6^FS";
											stringZPL +="^FO0,460^GB735,0,6^FS";
											stringZPL +="^FO230,70^GB0,390,6^FS";
											stringZPL +="^FO470,400^GB0,60,6^FS";
											//선그리기 끝

											//글자시작
											if(BsaCodeInfo.gsLotInitail == '1') {
												stringZPL +="^FO230,10^AUN,10,10^FD"+"QC-JWORLD"+"^FS";	//^A 폰트
											} else {
												stringZPL +="^FO155,10^AUN,10,10^FD"+"QC-JWORLD VINA"+"^FS";	//^A 폰트
											}
//											stringZPL +="^FO155,10^AUN,10,10^FD"+"QC-JWORLD VINA"+"^FS";	//^A 폰트


											stringZPL +="^FO20,100^A1N,40,40^FD"+"Item Name"+"^FS";
											if(itemName.length > 18){
												stringZPL +="^FO270,85^A1N,38,38^FD"+itemName.substring(0, 18)+"^FS";

												stringZPL +="^FO270,120^A1N,38,38^FD"+itemName.substring(18,36)+"^FS";
											}else{
												stringZPL +="^FO270,100^A1N,40,40^FD"+itemName+"^FS";
											}

											stringZPL +="^FO20,175^A1N,40,40^FD"+"Spec"+"^FS";
											stringZPL +="^FO270,175^A1N,40,40^FD"+ spec + "^FS";
											stringZPL +="^FO20,235^A1N,40,40^FD"+"Date"+"^FS";
											stringZPL +="^FO270,235^A1N,40,40^FD"+inoutDate+"^FS";
											stringZPL +="^FO20,295^A1N,40,40^FD"+"Qty"+"^FS";
											stringZPL +="^FO270,295^A1N,40,40^FD"+formatOrderUnitQ+"^FS";
											stringZPL +="^FO20,355^A1N,40,40^FD"+"Worker"+"^FS";
											stringZPL +="^FO270,355^A1N,40,40^FD"+inoutPrsnName+"^FS";
											stringZPL +="^FO20,415^A1N,40,40^FD"+"Weight"+"^FS";

											stringZPL +="^FO70,475^BXN,4,200^FD"+DataMatrix+"^FS";		//^B 바코드 종류
											stringZPL +="^FO270,470^AVN,25,25^FD"+lotNo+"^FS";

										} else {
											var partNumber		= dataRaw.ITEM_NAME;
//												var description = '';
											var specification	= dataRaw.SPEC;
											var potype			= 'E1';						//고정값
											var date			= UniDate.getDbDateStr(dataRaw.INOUT_DATE).substring(2, UniDate.getDbDateStr(dataRaw.INOUT_DATE).length);
											var lotNo			= 'A1' + date + '01';		//'A1' + 날짜  + '01'
											var qty				= dataRaw.PACK_QTY;

											if(BsaCodeInfo.gsLotInitail == '1') {
												var vendorName	= 'JWORLD';					//고정값
											} else {
												var vendorName	= 'JWORLD VINA';			//고정값
											}
//											var vendorName		= 'JWORLD VINA';			//고정값
											var vendorCode		= 'DXRX';					//고정값

											var vItemCode		= dataRaw.ITEM_CODE;
											var vLotNo			= dataRaw.LOT_NO;
//											var itemDataMatrix	= vItemCode + "|" + vLotNo + "|" + qty;
//											var sumQty			= qty;
											var itemDataMatrix	= vItemCode + "|" + vLotNo + "|" + orderUnitQ;
											var sumQty			= orderUnitQ;
											var formatSumQty	= sumQty.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
											var sumQtyString	= strFm(sumQty, 6);
											var barCode			= partNumber + vendorCode + potype + lotNo + sumQtyString;
											//20181108 Exp.Date 추가
											var endDate			= '';
											if(!Ext.isEmpty(dataRaw.END_DATE)){
												if(UniDate.getDbDateStr(dataRaw.END_DATE).length == 8){
													endDate=UniDate.getDbDateStr(dataRaw.END_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.END_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.END_DATE).substring(6,8);//"2018-12-20";
												}
											} else {
												endDate = UniDate.add(dataRaw.INOUT_DATE, {months: + 12});
											}

											var stringZPL = "";

											/* zt230 300dpi 용*/				//Verdanab
											stringZPL += "^SEE:UHANGUL.DAT^FS";

											stringZPL += "^CW1,E:VERDANAB.TTF^CI28^FS";		//Verdanab
											stringZPL += "^PW900";							//라벨 가로 크기관련
											stringZPL += "^LH55,0^FS";

											//상단 바코드
											//stringZPL +="^FO460,130^BY2,2,10^B3R,N,140,N,N,^FD"+ "*" + barCode+ "*" + "^FS";	//code39
											stringZPL +="^FO460,100^BY3,2,10^BAR,140,N,N,N,^FD"+ "□" + barCode+ "□" + "^FS";	//code93
											stringZPL +="^FO420,150^A1R,35,35^FD"+ barCode +"^FS";

											stringZPL +="^FO360,50^A1R,30,25^FD"+"PART NO"+"^FS";
											stringZPL +="^FO360,330^A1R,30,25^FD"+":"+"^FS";
											stringZPL +="^FO360,355^A1R,30,25^FD"+ partNumber + "^FS";

											stringZPL +="^FO325,50^A1R,30,25^FD"+"SPECIFICATION"+"^FS";
											stringZPL +="^FO325,330^A1R,30,25^FD"+":"+"^FS";
											stringZPL +="^FO325,355^A1R,30,25^FD"+ specification + "^FS";

											stringZPL +="^FO290,50^A1R,30,25^FD"+"PO TYPE"+"^FS";
											stringZPL +="^FO290,330^A1R,30,25^FD"+":"+"^FS";
											stringZPL +="^FO290,355^A1R,30,25^FD"+ potype + "^FS";

											stringZPL +="^FO255,50^A1R,30,25^FD"+"Lot No"+"^FS";
											stringZPL +="^FO255,330^A1R,30,25^FD"+":"+"^FS";
											stringZPL +="^FO255,355^A1R,30,25^FD"+ lotNo + "^FS";

											stringZPL +="^FO220,50^A1R,30,25^FD"+"Qty"+"^FS";
											stringZPL +="^FO220,330^A1R,30,25^FD"+":"+"^FS";
											stringZPL +="^FO220,355^A1R,30,25^FD"+ orderUnitQ + "^FS";

											stringZPL +="^FO185,50^A1R,30,25^FD"+"Vendor Name"+"^FS";
											stringZPL +="^FO185,330^A1R,30,25^FD"+":"+"^FS";
											stringZPL +="^FO185,355^A1R,30,25^FD"+ vendorName + "^FS";

											stringZPL +="^FO150,50^A1R,30,25^FD"+"Vendor Code"+"^FS";
											stringZPL +="^FO150,330^A1R,30,25^FD"+":"+"^FS";
											stringZPL +="^FO150,355^A1R,30,25^FD"+ vendorCode + "^FS";

											stringZPL +="^FO115,50^A1R,30,25^FD"+"Worker"+"^FS";
											stringZPL +="^FO115,330^A1R,30,25^FD"+":"+"^FS";
											stringZPL +="^FO115,355^A1R,30,25^FD"+ BsaCodeInfo.gsWorker + "^FS";
											//20181108 Exp.Date 추가
											stringZPL +="^FO80,50^A1R,30,25^FD"+"Exp.Date"+"^FS";
											stringZPL +="^FO80,330^A1R,30,25^FD"+":"+"^FS";
											stringZPL +="^FO80,355^A1R,30,25^FD"+ endDate + "^FS";

											//QR 코드
											stringZPL +="^FO270,1000^BQ,2,3^FDQA,"+barCode+"^FS";	//QR바코드
											//ITEM 바코드
											stringZPL +="^FO80,800^BXN,3,200^FD"+ itemDataMatrix+"^FS";
											stringZPL +="^FO80,870^A1R,25,25^FD"+ vLotNo+"^FS";

											stringZPL +="^FO125,900	^GFA,04480,04480,00020,:Z64:";
											stringZPL +="eJzt1jGO1DAUAFBnBilltqN0wT1wQS4wJ5grUFKgOAgkCooVJ8gROMJktUK03GAsUVASmIKg9fjz7YD229+LMgMrmrgYjZ7+xP7+3/EIsYz/PgryecJQ4IcOn4vdox0B9mfbZiNTs0L8pe0Abv5sR6f3wQ4kblR7aN4BfCL5Dj7u7WbzhJhRHehWiDWxXuIcr+qamPs170jMFm2wgdq6Vd5aaqU3TIyaMhoaMJHpUI8rURKbatSKKtp7NFyRTm0U4gvJ4yM+UPe4cJoHlh3zVZFJH1dAZBVAY1ZRfXFhoK2M++CzX9/L2L57M5m4UfE4eBjVHOfF/TM6WQua3XJzZK8g5NYBrubWWg2svmGvYpv6+Tyzdb1l5vulyVjap3N7HHb7vKXn8i6rt0d69h0+SwtpVBp3BTh7YtcQ9WT9APP94CILa760PN/OFixfNZbcBmbNY1PepHuvhoqbqQ7MenlIa656Rd4HtvyKJltF4lzlz+qlUNfEtLdeAMnXNatgbkXnXXf+HP2ge+BKNLMe35A4W+H63Daq0Vh1rG6jZLW0g+xYvzxVKjUnnk/2jZ6PZzKcD7ovYuTvv/f8fOTOzP1Ysr5gcW4zbRp3xbF7MG+OWZeJm2uvZ9qL5Pz6fu5l1AfeGid5XNIv8+/a6tzfnvYeig1gl/kPcv7zTv5vQe4ZW2Tsd9wu3Wc0yc0xay8uuInkPp+sTKzJWBI3ra/N3DNdPt9zLNxvsR2dytRD8/pm4sDy9xqYR+z9h99zxmoJ+EBuY8aA9dpi/9yWsYzc+Al0nwDx:0190";
											stringZPL +="^PQ1,0,1,Y";

										}

									}else{
										if(itemLevel == '6000'){
											stringZPL +="^FO0,0^GB735,560,6^FS";
    
                                            stringZPL +="^FO0,70^GB735,0,6^FS";
    
                                            stringZPL +="^FO0,160^GB735,0,6^FS";
                                            stringZPL +="^FO0,230^GB735,0,6^FS";
                                            stringZPL +="^FO0,300^GB735,0,6^FS";
                                            stringZPL +="^FO0,370^GB735,0,6^FS";
                                            stringZPL +="^FO0,440^GB735,0,6^FS";
    
                                            stringZPL +="^FO230,70^GB0,370,6^FS";               //가운데 선
    
                                            stringZPL +="^FO200,10^AUN,10,10^FD"+"IQC PASS(RoHS , H/F)"+"^FS";
                                            stringZPL +="^FO20,110^A1N,40,40^FD"+"Item Name"+"^FS";
                                            if(itemName.length > 13){   // 글씨가 클때는 13이 적당
                                                stringZPL +="^FO270,80^A1N,38,38^FD"+itemName.substring(0, 18)+"^FS";       //글씨가 작을때는 18이 적당 다음 문자는 다음줄로
                                                stringZPL +="^FO270,120^A1N,38,38^FD"+itemName.substring(18,36)+"^FS";
                                            }else{
                                                stringZPL +="^FO270,100^A1N,50,50^FD"+itemName+"^FS";
                                            }
    
                                            stringZPL +="^FO20,180^A1N,40,40^FD"+"Spec"+"^FS";
                                            stringZPL +="^FO270,180^A1N,50,50^FD"+ spec+ "*" + trnsRate + stockUnit + "^FS";
                                            stringZPL +="^FO20,250^A1N,40,40^FD"+"In.Date"+"^FS";
                                            stringZPL +="^FO270,250^A1N,50,50^FD"+inoutDate+"^FS";
                                            stringZPL +="^FO20,320^A1N,40,40^FD"+"Exp.Date"+"^FS";
                                            stringZPL +="^FO270,320^A1N,50,50^FD"+endDate+"^FS";
                                            stringZPL +="^FO20,390^A1N,40,40^FD"+"PD.Date"+"^FS";
                                            stringZPL +="^FO270,390^A1N,50,50^FD"+" "+"^FS";
    
                                            stringZPL +="^FO70,455^BXN,5,200^FD"+DataMatrix+"^FS";
                                            stringZPL +="^FO270,465^AVN,25,25^FD"+lotNo+"^FS";
										}else{
    										stringZPL +="^FO0,0^GB735,560,6^FS";
    
    										stringZPL +="^FO0,70^GB735,0,6^FS";
    
    										stringZPL +="^FO0,160^GB735,0,6^FS";
    										stringZPL +="^FO0,230^GB735,0,6^FS";
    										stringZPL +="^FO0,300^GB735,0,6^FS";
    										stringZPL +="^FO0,370^GB735,0,6^FS";
    										stringZPL +="^FO0,440^GB735,0,6^FS";
    
    										stringZPL +="^FO230,70^GB0,370,6^FS";				//가운데 선
    
    										stringZPL +="^FO200,10^AUN,10,10^FD"+"Item Description"+"^FS";
    										stringZPL +="^FO20,110^A1N,40,40^FD"+"Item Name"+"^FS";
    										if(itemName.length > 13){	// 글씨가 클때는 13이 적당
    											stringZPL +="^FO270,80^A1N,38,38^FD"+itemName.substring(0, 18)+"^FS";		//글씨가 작을때는 18이 적당 다음 문자는 다음줄로
    											stringZPL +="^FO270,120^A1N,38,38^FD"+itemName.substring(18,36)+"^FS";
    										}else{
    											stringZPL +="^FO270,100^A1N,50,50^FD"+itemName+"^FS";
    										}
    
    										stringZPL +="^FO20,180^A1N,40,40^FD"+"Spec"+"^FS";
    										stringZPL +="^FO270,180^A1N,50,50^FD"+ spec+ "*" + trnsRate + stockUnit + "^FS";
    										stringZPL +="^FO20,250^A1N,40,40^FD"+"In.Date"+"^FS";
    										stringZPL +="^FO270,250^A1N,50,50^FD"+inoutDate+"^FS";
    										stringZPL +="^FO20,320^A1N,40,40^FD"+"Exp.Date"+"^FS";
    										stringZPL +="^FO270,320^A1N,50,50^FD"+endDate+"^FS";
    										stringZPL +="^FO20,390^A1N,40,40^FD"+"PD.Date"+"^FS";
    										stringZPL +="^FO270,390^A1N,50,50^FD"+" "+"^FS";
    
    										stringZPL +="^FO70,455^BXN,5,200^FD"+DataMatrix+"^FS";
    										stringZPL +="^FO270,465^AVN,25,25^FD"+lotNo+"^FS";
										}
										//waterMark 이미지 관련 시작
										if(waterMarkCheckV == "01"){
											stringZPL +="^FO0,64^GFA,11648,11648,00028,:Z64:";
											stringZPL +="eJzt1TFuwkAQheG1SeQihUvKPUKOYAruwVHWR8lN8FEoU7qgQAhnEPGaWHjeUxQpUqS8aYePfxcQDkGj0Wg0f3SettsN2tVmLdpFs47soGuIa4hLxO2JM+xKw64gbkVc9UO3Jq4iLhLXELcjLhGXiDPsbh8nciVxFXEr4iJxkbgdcQ1xiTjD7vNjAa4kriKuJi4SF4nbEWfYjdfzXUFcRdwLcZG4hrhEnGGXr+C6FXGRuJq4RFyD3XRMz03H9FxF3Ctxkbg9ds9GnGEXidsTl7ArDbvCsKuJG3ND8tz45V2S43Lu6Ll8zN7rrfPOc/nmrdeb7x5dvpr7Pz/tsDt5z5V8vZ64A+l1xL2Rnv8cy8fEvSNxB/e5WUw/Buha3LsE7M4B93ri2oB7HXa3HOoNAbt+3n3YbbD7CLg33HdLd77fZdnrsBtzfm/YYPd+v8uyd/x6z4VrcW8I2J0m7/Sm13ouzHaPbr5Dzut9x6mnnnrqqaeeeuqpp5566qmnnnrqqaeeev+3p9FoNBqN5jfmClqQH/w=:EEC9";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "02"){
											stringZPL +="^FO0,32^GFA,11648,11648,00028,:Z64:";
											stringZPL +="eJztmU1u2zAQhSUThhYGqlXhpfbd+Aj0TXIU+ije9whdOEfIEbzs0osUMIwkbE3qZ4aceYzdpmgBzSrC56fhmxmZlFNVc8wxxxxzzDHHHP9CfPb+x1ZhX72/7GW09tcQhW1A/m0nsGVkrwJaHCLz3wXoenZS0/2KPKEbWS4cUZ6wnthLyszE3lK2nlhWGoKyhI6wI0crqrtozq/xftYxxhdqGXtkVXGMsYoahvhCa6/rVpyxijaAcXvc4EPCqEGbMGrQJeyJsATRLvX2Xsf2E4Or6dPxr3Om244rPqe6S/Intb6drJLCbMjiYtF2I+uu1y/0HhOz5D4iO9E1T0VjtUiYo5dO0EkJhiljix4bURML/ULHoi3ZVZid5+HKMGbyTw4WpAx7tuo3ptsxt1w3MZvpRhQMjroNZ5Y2kH2wnzWqI1PQUp3lOpbe8qljlm5ghjLn2ROQMfLdt0gn5DixGrBMt5tYuB4Yb1+87u9TA13tE3ZIdASFWjwpOkt0XtcZSXdSdN3EkG5Z0qVrIbpXRdf45FuYzMHNOsI0XQvyNT7Zm2/Ip+k+pbqO+HO6rlp8U/NV9VrXVdUXzV8WXMfDAva3dWSusyDP0R/T0ec9DX8fW6TPFYka6AxgRZ2S716WbDM5u0N3HQnxVD8wRWcB69Ln8Z06B3QHwK66ZxmFtiuPX2ifMvKmxJSxDqeEo8zWYFxawDrQWguYA8yDtju9RaGcCuPHLB7hwHuRWQNKzY+DPDqgc6AND6B9HrQh3HMrolAW5QkzgK1AOVtQzhaUs1gWpZxO18U3hKPMnF5OA8rZlMqisA6UzIKyOFDOkE76hWKwJ5fFgLJEe1uRrUBZOmA9vgjuRGZL9uSu12AiDCjLElhvAetAWZC9sEzpB6YK2/N6WZqiPbnrZXvyMg/Ani/Zk+8Z7ck7XwssNIDZor1HkQF79Z32lkV78jLXRXt7kSF7AckbJhqy+AzJX1cNsNeAoV6DZTowZA+lAVTOA063ULaHBvAj7ImoAstEG4MBy4wW5H1vVXyGtiJLf6XLdIqFILt93zOgQzVgyF4LuoAYsmf1LsSuKwwsM+57CgMDiA5ziDXAXltiir1QFnn/iuwoM2AdnXErMJyhZMoXfA3sLfXhhNaLrwxKWdDbWTh+7GVm9c6W38CQTmFOL2cFShamWmOgnMUXYdSGNJ4BO5d16T+BPPGLdBuQT7wn0vX5OqCzIJ/Iet0B5HO36s5lnYSGfCJDuvOdut/LV4usnA/pZFbOJ7OPy2dEVs4n67TfoeeYY445/r/4CZIG0SM=:1235";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "03"){
											stringZPL +="^FO0,32^GFA,11648,11648,00028,:Z64:";
											stringZPL +="eJztmbGO3EYMhmclBALuCiWVuqhP40eQm/TpUupRZksjT7FlcCn8CKdHURm48RY2YBh3O9mVNBr+HJK7vnPSRKwkfPpFDoea5ew4t9lmm2222Wab/W9t14fnHxV29zGc/lRYH872VkRvwmR7ibUTepZQMcvC36pMFi7uwklgfmFSMBGFQ4Z+WNmXjHUrC2qYUqBJljncETYyVhDGM1MR9sRYbbCWMB5ooMYC9ZTtDR0GugOGGS0NVgN7upm1wHCAHTAcRI9MGN6Hd38IiVndNNPVQNA8e6dDrNIxS8vxcunXK9CN6xVNTJmia/ngp7Sc0mMnzj5Nl5WoG5PrTHdMQ6UJ7UgyPEtoT5LYsIR25NmW6TzxUTFGc1GyifDr8BY2oG4Ub+bbo8yKTJcqu4TQPEwghuZz3XrXwuTewzuRVaBrgNXAapjcCqasAlbDVCNrSTolXborDR2yLs8S6JA9g268SbczdAXoPLCdwXLdsN45YFiRRVYhlm7v5Fufs5t07Iv7Lro3hq4xdO69rnO/G7rzDKbrgoXtGl3n3jNGdY4xBWX+iO2u6RRm6corTOyaFiY1PxfD7/bbdJq/2nin5a99Bcv7sNl6g/kr7KiwyzRITWhko4xKg02L92Cwg8waowRrQ9cbpRQM5vVpz/oJHqYyfbXBpjCVKQo6mzugUWSPQU/L5E5O59KHSuwnH7QhvHuYZUJa1sZWGMJNbMzZfWRCmKtOCDPqpNkr9VBWncTi3mMwdAddJxZZrbuLTCykuBmQ9qqRSQ4jO+11Jg1wZcIq0UYmRJo2LbnDxCzdqPsT0lYbLOnyQBPLKyYxa/ubTz1hA2fd14eHRyWj7eepQ7hYtl7/vHdxZyYvFJU2Ey4WvrKgea1kXMzqXmSNMoPJ4cFg8judoZuXtFFm3mCNmNDZKj2hJiuvMe0H3mL+ik5rYHp9IrIdZ8YUXW3o+A6XGt/F3sr4Djdjg8xw24q2e6HO6nzMjsm/Qqd1aF4vNJN1ButfqGv/Bd019pJO+b/WNQarr+he7+8OSgd0v4aMRX/FXzlbdLs+qOzuIwuLsJqXMWOg65B9MnRPii7bgPWoOxm6Z647Kjpv6Mh3e8/XRPK9Z5tdrtvLumwDTdalUtKN13V8ow/rIGN0/SzY+gzrNVtnITa2lgJj6yX87RcERnWk0BquI6w2dC3VdVhMnrIeWU/roMOCCfRRcGCywmDYa+APs8CGeFdBKu4hoS0ps+XJlTW5br3r4MmpQNYv1+eRrYkJWD6BZHA+G3DAAn0JKUk6KxV9icMWsAPnyFpI9fLsF+KbLFMtGaBnujbFVnLd3DdPDvtAfDP2GGAa4osug1qO5dLQ4+nY11+WjXj2pYbw2e18YOlkx1XC6kYsW92IZas+MVj18bwKmx7GBsrwfAwbRcYcmD48Nogng7HfWhjggAwGMSKDQBHB+WbWy5NgspagU7J5sV4Nk/yJIrTdsVKkDiQFKnQgreru3B1oo3PpaFTcai4H2+IJ/OLwrcTmSD9I6OzxvJn+TUZTH6O145ttttlmm30X+weHqS2x:D3AC";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "04"){
											stringZPL +="^FO0,32^GFA,11648,11648,00028,:Z64:";
											stringZPL +="eJzt1z1u20AQBWCuCIIBVLBUSSAX0BGom+goVOlbJEiZS0hH8A3iMqUQuBAMmmuN+Lcm5z1FW6TJjBuLHx4JvV2TdJLY2NjY2NjY3JkvT08HZLX3Z2QemyOWRuYKYnlkroy0PbGKWI1Nvjo0kktZjhjL5cSKSNsSqyKtJuaxOZJzJJcRS4nlxIrI3JZYSexIrI7M+ThzxFJiGbGCWE6sIlZG5mKtJubjLCWWEcsjrSC2uR7/BUxq+QasJHbdnS0yOWcJ7Hq4JdYAW5GcVP1K7AJM6nwGJnW+ANuQnBw+RZhUdgAmuxM9G6UWkmtYDpjcJC7A1sS6twycQ5YTuy0DMDm6AyZ1noDtpU5gt1qA1TiXkpw8+pBJ7o3YGVi3DLrlt8p0kzp/EzsBq+7YDphUdiCWAPPYXFf1wyb33AZYvwyqDe+5mvV1wtwLsC2xsqtatYpYXye0g26yO99BzvWVPWpptztVy0iuILmir+xRG+rUTJbhO7Cqr0wzT2xYBpBrib0DS0kuG48sLR/qBIZyBbFyqFqxaqgT5E7AjiQ3LoNiUguxJtFtNda5tJTkpjp1ewUW/DO8sA2xqbKl7YlNlS2tJua5tYluK2KO2Hqqc2EpsYJY+FnLIQuqXlg17vil7UkuqHNhNTY37WrVvPZdk/AmoduF2BuwPPw4s4KcU+wZWFjn3EqSq4OqNUuAeWzujrXEGmDrsM6ZfVqGmQ1vEsjOwIY3Cc2qsDLFUE7q3BED53SflmGW8+q0Y245t6eh03P+Xs6uZ9ez6/3d9WZT+vDv9uvPH8HP8Wp/5Le7OTMzMzMzM7N/bTY2NjY2/8t8ADxukCA=:989E";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "05"){
											stringZPL +="^FO0,32^GFA,11648,11648,00028,:Z64:";
											stringZPL +="eJztmT1u2zAUxyULgoFk0FR41AE6+AjyUvQYPoo09hhBp6AdegR7KbrmCBqLDoWHFDBS26r1QfL9H8UnhbELD3pZrPz84yMpmV8KgimmmGKKKaaYYorLxOzLZ/wb6UUVxqkwbM5ZIDDBqzy9S+RLPPOlgrcQ8kmexTy9S+TLPPPlgrcW8kkeZ2PzWYx4vMix+V7jXTufxcZ79Ks0ZgLz9cIzO1zYq4elF4G5vPsz2wuei90P5JM8F6uHl52DJYKXDHg/BVbeCEsH2NazTJeXeXq+LBPY+sxWV/AKB8txRIGo3uC5mKcXXsELB4YXF4uu5PkMZ2/xpKHu0sPZW7x6ODvfxz99Xj2c3VXV74KxefeTznv6p/NmfFYkXtpMi2wcbYdPteYtLFYGcd6go+2VwbLzfllsG+qJuMfTc7TtxdpbWZ5ZupaUNcNSqtnOYhphQsYOnP0wDHqmZt8J4x6NUmC0ohlje8Ebu2pdM0YbkXNWCmwrsL3ASI9yRBoRenp2PnMnQguZxtv5TAOVd3r89M3Fjqvgg4s9mFuyY2xHcj8z1nTiHWt8x1bNxQJZZNKphCf0DvSLJ/TUeqllBXiqSXmPV3ZXGUmumPrmAkqJoJTE9lhrVYZ6ODPjNWaP6EXXiB31DNtQNoc71v6qFGtqVmiW6ZuivBV6z8QjT2RCm5RU8CTHlC3Rg26aV/CrajpGjb5JD9PlxGsYUqh3nhk2JWEbbO+CspzeThbMg8gELxO8xJPNh7wHwdsKrHy9FwleKLCrea7tkuAFQ56D/e98zQN6aW8jsGzAc63zhvK5PN98Q96l23drnm/7bsXzfT6Hfg+l4Cl293VTOL13a6vMNt/sGx+CjRdb04FhkTV0GxZyLxznxZyFZryO+HRA/hH2eoX5aHmEbQmLR3q02+uYmwZbQ/58nNd0Az0FS0iZ/PHg3r7fax4Pzo4ORtczNaN7qZRccy9j7MDYM/lMtz0b8t2swt1pzjx+uLx3eOaxttYrEWUplgnT3xIfCpimE2SwnFjijU/oJVuTpLRq93jjodpQaVbthpnzkLo7T+CZm5RZnr4ReNrQruDhiu1X+ktp90SqJ5rW6v1Ru7pXDJbX3f5WsaZ5T1hr1cAN9uCaPwXES0nVZpAcWcgY3dq0nwvN2rdqO5Ob7xi6yjT9QDbwZCMHe7o6ug3gi2odLbPbOD6pdKQ79YZa72/pyJC3/1oFH00JKrIKoyQsZawYydjrRjicYa8p6bkG393jekFiOTCcM7GBJbA1sCdgWNECGFSUHdnBe2Z+ZEcryqd2d/OwolvGaG8Hr2Azg+wTVPPml6ejPVpaTPfM0UKmZ/oOllNnOi32nkeHznRBN/xWj70sdmtB8L6q/j442BRTTDHFjcc/qGOvyg==:9785";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "06"){
											stringZPL +="^FO0,64^GFA,11648,11648,00028,:Z64:";
											stringZPL +="eJztmTuO6zYUhqUxDAFxoSq4pZbgJXCWkC7lrCSgLlJkgFtkCXG6i2myBHsJswSVg1s5wBTGwCPmShTJ/z+k6HlkkCJiJfnzp3MOqQdFFcXSlra0pS3Nt6u9MXczrPzZmJ9mmBnaQ5rdDOw6idTomTYVzSJzTLAfJnZKsGZiJkZXDqUOqh27j1DtvaeIVZ6dI6Y8iyvUgUUBAzKdQCUwWcQGmOyZBphMFNKMEr3JMEQi0ZIYJ7oixolWGW9DjEeiIcYFUnmmpyKoPHHKMKLip/L+Ln60G4eYfbv9MseG9D6NWzjyK5+eioqv/C9lxLYhu70sfjxxn0MPPcpueQqsB6aHH7qQci+9h5By5EH3IRvT3AFrQ7don+Z0/MBWWNOWWYk11QnviOyQZhWzTSg9YjWeI2WC7TBA51kTeWEAFXXTwE7knYmxF/65pz1FQ62jvSN5Z2Kc9RyjrMfhO3hWo1fyqNTkMavQW13yiozHrEcGV8dasl54LbDHGW/Dx1yhV7FXolfTMHBXpJjb2Rq+1aLXCKaBqYwnmTbP/jEfe/1X9A7AfrkO2wquBtkwr1eyfgaN7C2eeZtHYymZTs0F3uetcp7Jx5tjaz49o3ipydUlr/oArzLpSeDQ6gz7KK97l/f9Av42441zgvu0Nz5eHtJsuGbE3MWxacbbppidgnDKjlnEp5xjeoLIptuSn6J1wBp7m2gck5OXDqZoeA7U1nPhKJnteHsJ83m8hm08mGUepBfm8xjQesBgKNToqcCemLU4nzfSAwSJqjEeMEh09K6QsdfSJPqeWY3slGE8m9gpZE/sNZljYulQ4MA+EzPE/jTz7DOzA7IvzDrHhlC/MrtH76/xp7u7vShiYL+NP8XXxMB+H34ZLj0rnjHeH2aauK6ZDd7w9/GctVdFjywE0UnWwp7rGNeVdq+Bbe9Nx6lS3jS/XqeY6wvqbG3iXbejuO/3uKMxzSnRe2I0C/LBNaY5FeEGQrFXYWdbzz9Z1rinqTw7lWLPZW2Ld0wlWE9e65mO2C7jeURzaCXYcJ9yV5L0GtjV1C38EqSxoGLqtBbiSW8H3jHjnQSb8dZwwijB8AVJslKyLrAC9jUc3//wAk/x8NErkeLho2PqSx4yJVgxz/p/yzsBQ6/JeNsL3uMMe6tXs3eW7AXxmoy3TcU7f6wXsXO0aVt1Id7pshex98R7gVdnvOq13mnGq/87r3qtd5zx4Pxcp475To/WFZw3MbEcQtd7mbpPdC/zovuZ8/T8va7IeOP98gBMAxu8XcbrZjzJzAXPxVcJbwf/w+cR1qtM/Kx6KYPnJi1vNSZaX6L1HvGc9uMpLlw6t2ipUlwfgpG34QEkT6zJNRh+wwO4jbyDZwrLXbGn8Jg4ESjEOiYt4Yq10TLDeIU1EcFHX3PWGiuqYs8Q42ppZS/LWs+2GEIxayLmEU+pDZ89uJZOU+FiGsAe/gee/ehgtz8Jz76ItiH2WXqHkDO++o/sKWzKK84WYQ+BiyLKB6zh8LaNHryPHSJvOOgeUi5C4sPHzen9r4jZ11v7/kh3U/7MxU8L/szF36uExytfOXZDjNeKFLGOGL32iwXWHKNExQIkFSg+jNoRTJbAiUqGBcrvophoJxgmKpD/WmxSa70hYO77bbyu18ymiQGjcJBohNyZmfrMHD6Npr7Au3W3LsGmCpMrr1f72XBuDJNoLLG/nWHfIz5fz7GlLW1pS1va0pb2f27/AFGFTuI=:A394";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "07"){
											stringZPL +="^FO0,64^GFA,11648,11648,00028,:Z64:";
											stringZPL +="eJztmEFOwlAQhinGNJEFS5Y9AkfAm3AUehSWxkvQI3CELl26YGEMUtNiCIE338TftonJ/NvPn6cz/8x7OJmEQqFQaAg9vSb0cmZFk9DxzFYpdhJ9x5HPC1/0ry/fAXwf4NuLvgp8Jfh+2K3anz0ZbN1cynKnTXMpS5IdDNbAZ7bsPY0eWlYD26fZ/Kpkt8qBzb2SpZFczradnwbb2GWZXqXlTmI5MyjnzCuZ8asQKxxmldpLJ5XTKFn3p78Bq9PMTWeVZjPwUTqXYqlXTnIVH5SzS6DRhszzUYvqNMuBPXrJNZi6JKgN1L621F/AKPHErFIP0AaaBmoDtS/3Sm2w3GsDfabho2mgFu2cFllX5k7b8RNvxwt3g9u+LbDy92zh3RuGz1tm9Jk0fbQE1bZT+4a42tUXFrFtmqltp6ktoA0LZzLp7qOXWd8PXc9Hy5pegjV8pvGiI18G007PGpeVaTZEXObQvtyJBMVMecgX0NoVsLW4JbztYjHPVwOr0kiN2VSM2QziQhEknxszw0cRJEZbSfWNHU/yqZefGM/uG4exBek5q27Bzvc8gK8ElkbnWBuMYq361MgvxY3s+ZRxoOh6sVZ9NEbG/yU6X90zoy0v+rrxqwwmjt9gY0u+EnxpJI+tymhs/+Kzvhp5467cYp5PYUsYP8+nnEfjrt62/4mp62yINTjm+vRY1bPPW9fk24KvFH3CeZl4HvkyWtfeeYLPPc84bmxfKBQKhUKhEOkbQv5ZUw==:AAF5";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "08"){
											stringZPL +="^FO0,64^GFA,11648,11648,00028,:Z64:";
											stringZPL +="eJztmb9u3DgQxle3EARcCiFFsCWvvmYfgXqEO+CMlH4U6VFSXnePID2CXyDAlotUW1xhGPYyWVGivm+GpL0OjCCIplr6p+H8IUXOyJvNKqusssoqP0qKG+c+p+Dvzv2bQB/dN3mKs/2FPUTRBzfKXYz1nkUVW89co9F2Qu6gmZnZo2Z2Ztpg4YJogwvrJCoXdkq64tx9hilH+4Wd027qlCITjlbIhKPbDDPIRBAWmchoi0wE0SNz6fCcG5LhiQBLZhRElWG7DPOhn7vNfzr4KS03Nz5OWkGflsNm85sOvg0hGxW8DWncK73x4f+XaBrJuuUnJK1Y/lBE2RlMKz1wGXbaNri52dRTpLNUkET8HfQO8BvYDuyXItk1LjbYvoiBXBRiIQzm0Kb1xgAh2RaHe82CiZoX0KLbNeu1qFexXo8pFKzFNOX0Cq0XWMkbhpcMk+tnGeKjjR6xXpN5kr0eMnp3r9BrM3o2kyWLeoVe6ZzeKaG3z+iZjL09zlleZ4+YsJfSqzP2cno/i73cOlA+X7tfInoD6TWB5fanfosHepL1OtIbMno8OtCoiz8pZtGesR6zJqMXEJ+RlWbHebDVLHV+Wlx4ce4aHBq9e+icl/fDPGj1Tg6sZz28x8bQ4R6rML0xlrg3x3kS9y3eeVJvtHFewnvp/a7qiQ6YDUZKmALYMUxP9YsJTxvFxqDGqJxIy1yf3c3miPmyNdRnVLtN9eA/U33GRa0jGYi1xAhx3SpqWpNhufq6zDAy2DGiQrkRejbpSr5fgUlVvwKZkeagxI40cqHEjvRjS4CdROCnsgfxST+zeQEk80KNgEiMRZbrc0SEjiTtpnB0y+yAzDCL9SRR1jLTvYV7mN8jdHRy8+nv97cJ9u31m5exW5jfD9CvyD7AnxO1ZLslG4UMogYjkhlwrhUBWkhiFWN47oqbmfoOUe9S/yDu22CiJ8Ytyug03+9hc+3B6eld4PuPu4Lw5JYSU+lZqEMRXgdmMDwRkdFZekgwi0OjM3+ODsQ01tE7V0sG7xwVBr2DcmJKTAcBwa4rMRWUsklvYqJA8uO7uF5xjR4wnEfqYUEoCjIf7wniaYC1CxMFGRXDZYaJ8ppKuUrqGUdvFentn9EDRkdtvbCdnLN+uR4d0RXr3V+j95jQAwd2MfaoplcTXa032TPfYU99MQO9o2QvtKf0fqC9lN5brd9V++WN92fqfaikHrDtM++YYqfn9dT5AueEOl9yeuJcejXrMmwA5mDDSnY5dw9xvWfP+QF+H4TezPoI60BPdoqol7r/WqfvzWYaWN4wdEYbTqi6i0WXnOu8HT4IC2GVXhNYi4zaaR8u1z38tSlRE3GTXurRKf4k11nYTk8R8fclypKoBynzUA/2cjUhS5dM+PJ6bpSawMZpjuCmzLzTv8MYvzPAavq6fFh8Bubr5i+LOfldw2811cBPvUU3R6d2srv077f+h/o+4c5/+CKZG6TWsTTAesE6YFYwQFPjEYROU8OMTjDRx9HpLfq/3PeJQ4Y1xDjAjhg7Soj/QSb6W+qLZQefdpNXohEMHe0EQ0cFyn6fyH3XyH1nyH7XeJc0B878pVkw+CnCPsST6aWOrMEstwkvR/lzegcjcvl//1PMy1VWWWWVVVZZ5ZeQr0quWLQ=:CC0C";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "09"){
											stringZPL +="^FO0,64^GFA,11648,11648,00028,:Z64:";
											stringZPL +="eJztmUuO20YURUUQAjMjPDA05BJ6CcUlJAMjQy+llJ14B9lBKCAb6EnmGvZQAWxAVrpVaYn1ufe9qlJb9iQBa0Ti8Op96veqtFotbWlLW9rS/lftd3faFtDaOvdzgU3OuXNeuHGX9pJl/ZWdstbc3B5z0LN90Vze4OSZy3hqAxsVagNyB8WGyJxifUQ6Qpt0yuCUmHS0SUhlpgV2FKwD9lwOwZ3LbipHDTJ2FN1UWSO2r+g4iJYYZ7QjxkEMb2YcoGFGAfq0fPgwP1BPpLhU8D68xzC6NbuG1cvg18m9j5cH7ME2pbGVAc5zYZfcAtZDVJPQDfDxIBJjwLku/Xz6tsBMdNPHuk/MwvtaJHTC3+GkNRST4aRVGOsGSmgTe+HSenyZXYufdqS75v4J31JCO3K70yymoiG2oRQ21IE9p5eY6DJ6G7irDf7KwEPEIjOse5AMdAY70FAGr27HaC33WI9ZMhVmaRRcUxhfxcjq8Gec1h0LurbC1hXWAGvEDGhwwGTYCXUjszOyFTTJhM69QbcWOhxMPJAzOmSW7ZFuSqzL6caCPVPRmaTrnNgSLmybGP2mfZtu48ReCZOFxs736GAiKd2QJtI36cwN3T7piIG9XrL+hu5QsXe4rcvae4Puh9mr6cwNe8c7/QSd6r+SztzQHW/rOqmzzNR8uEc3MVPzzzM130Gn1hdX0bmy7rr2Pd+pO8JzTTfm7V2ft4Kd4HmXGJUXQtdKX0DXSd1esIK9mo5KUOdo3+yl7kmwMBCgny/NoG5i9oD2LHeSRZ1h5tCe4U5yUidZsDdQBzakGyhpDdlj1pGup4S2ZG9DCe1Jhx3m0xJfqcN8kR5eufafyN58fAjMkm6OaItp4UIkBOjPIFTAhAD90YyKovBlL3QTOGrYnncNn5POgKOvD/+gPUjFJbcvOk1PwZWvaM/fFYw+1L9R5/3eepe/or1w3PTnvy+o4yOs+xN1a2Z/IeNjsfutwtZoD28LXhNLhSufYZ/XZXZqiA1Kl+zRWfvA9jbE2B4lZteU2Sg2L2RcmHMQXJgTO0kdBPjMBwi6aNhLHQT/qDbZxLaK2eSmtJccPeuNO2b0oHXxfumoWRxqj5oFg+dVhgVHc6wNWREHMhCOOR1Mes3eey9nJi61LuxTiHXP7DU1n1f530wtoyOWvV70bFdgw3foSuxe3YPL3mbe1JmKzrrcLWjSFRCe/36Yzuk7SWT36FQt9w26mi/36PDcn2PyrjY0sSxRU3V6Ude8xzyIpeenP0rsV84fTT/Rz+repsRu6cbEjBP3S9vE4HgrLrfqOvpU6GyFOfwZnm98HTPwOkRDkNm6wngoDbTu1XR87NmQTt9HpkHA958bxbgqOBE7EksWbMW6IR1H5EjHEU06E6N/aVhHh6AWXwST99DIOup2dm2gbueD1YNYeRyEawWbgBmxgsC3V5+RmcSu4Z0kG1N4uEoMKUD1/8MQP24sp9N//BRdJjYXL9EcbZpddHyuKnaSXTb32RxtRnOpeP7kz0a0sPoy8pd3H120HJujxouuJcaL50SMF11D7PBmNhDjWoL/y9oSo/pa7NFUQ4v9hpjcG8rhcWJkiWUqDAPcCQb1tdoW8YQkGfSE3vqSo7oyS47uFduUzSWDmZ02ZvRzRhcK822GhcyMGSbO7TlPszI907G9Ftgvpf/tl7a0pS1taUtb2n+n/QsHcukG:EA50";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "10"){
											stringZPL +="^FO0,64^GFA,11648,11648,00028,:Z64:";
											stringZPL +="eJztmT2S2zgQRkmxVAwYIJyQewNdYGuhI+wNdInNydzBXmFuYmabzg1WoUMFDlRTMuEh0N1ooBsczXhc5XIRgS3pzeNH/BAkgarayla2spVfs/Rugk+D+ztjhthhfix5vXOuxDrn5jFlJ2D18OI9pcwCa16Qu+leqzD0zMKywAHYcpr5iSKznj1yVLvAao/cJfGAVQpDbx/YTWPNCmsDS060AWaAjQrrV7yD4rXABmATYx18/QzszFgfGDRLWnkDHrIvjNnMu62wK2NDYPsVD5vMzdJ7QPaNMaguNidvtDr3nPR6X7WU7YGd/K990qANfLO+Cw4Ja+Hb4GvWltg1HiUUE9kltNyZGCa4MKQtZ31k56BHZon5S+igsBpGkeUd/zmwHXSAYR1Yw9BqoeNa3oHAGvA65u0zr2EeHrOL7Jk3GXhf4W9pUBhgBs+dsR5YD6xmnWujd17x/FS2DB/Fm/wPA3lhpE90Nflxw5sF2IgH4tVb2Il5x8B2wuvJe2AesSNrloVZnDkNzRTcqzLPIqNqUUVhUvEsehOrnu41yGpiLd4jdtLrsEN65t0yryOPhgl5J9W7sGZJvAY8f+f633s0ZBs2cNynFfafzhrF2wHzvf5vympgy7U+Z14Fn5bTvPl5vomXK3xaeu+5E4y8q0kZHn3xriveReaRN6F3lt6TEd4NvWrFO/q8NnoDebPwhtCTw3JsA96T8J6D1/E89C5VK7wZvC/kTWmeXX4x8I/0xqAY7s2Qdwx5ktnlv6L3raK8yFzwrtKz6F0qyjvmeefojbk3Ql68ynHGsAtTvNF7FeTFWYW8pYe9d+AzashbpnZT8M7Mw7we8i7lvL9GJQ+8Pys9j1jB+6fCPCu8P1a8ivKY17PHtw5YpbA8717PrLBX84aETSXP5Hnv8PK8B+nNmndH/VTvh/LW6/dT8+713pLXbnlb3pa35f2kvF9p/vzAvB++/733fvth9/d3eB/1/HLKvbXnpX7lPAte4XlQ9aySt+aNivdqnny+TvKmN3qF5/n78uT7Q+JFJvM0tuYV3o+iJ9+rYl67kteJ97+YJ9//VI+vSBbeN6Mn31OTvOz9NvEuild4n37VK7y/vzWv5gt9mbcTeXJ9InrJukaWJ9dDCl5k5n4vYZiXr/eQp6wT8bx8fYl7M//K87Q1MvpDnYU8uup61Rulh3lxnS/3LGNjmqetD5LXM0YI8k4Yc1rxLPcMMrFuip6ybkp5r3hn/zXZEKA8sb7LvCuwOE1AnlHWk9HT1qExr1XWr9HT1r0xr4Hz6/nwBI+ts7MNlpCnrs9HDxnzYOp0yn4ADmRgLmGGGOw/TJon9i0wb1D2O9AbHO6TjCJvcHJ/Bb3l13xfBvMWFkolPNoH4vtHkKfuH+Ue35OCvFZj4Kn7XJC31xhOKMj4vlqbHfOy4j3KvLv2/0aZB8v/6X4jegeFYV4vm5O8Vlad8oB91Tyo4FnL0/ZvybOiWeKjhBVViN4hHy1stmrzXmdeJ6oXi7Yfzo/+XEC+RUvspQsfi0zu929lK1vZyla2spWt/A7lO11YdBw=:4D6F";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "11"){
											stringZPL +="^FO0,32^GFA,11648,11648,00028,:Z64:";
											stringZPL +="eJzt1jGO2kAYxfEZLDRFCm9HOVGqdLSp4hwkEkcxUi6Ckm4vAUfYI7hLpDQUW6AV2AkDhveXNiMXI2WL7+uGH2+eP8SucM7GxsbGxsbmTcyHx42cZo/f5dQMnZz80P/TKlgLm8MGWJ3Jhak5z9xCrWKuUZvTYolcyORyVtOGqbaEzWAR5mENrIK1sJDJhcm5AVareeYWahVzDXK0qFbTBrVAa6fmIszDlrAZrIFVsG3GBlg91TwtqlW0Rm1OW6nVtEEtwjysgVWTbQt7B2thQS1dcrdGzdOiWqC1GVupRdilvdc33szD2kyOFmADbKnmaVGtprVqIWMN7PKYo0WYhw2wWs1nrKIt1QKtVatpW7UIG9t7fcyr1Wq+hQW1yzd1O1r6kH5fLf0N9e1oqf3n1dI+L83VZunCH1dLl+xHu9QFtcNolw/pm9rT2Lc4n07h1TvTaajUdqOlxzzC1sgdYLf/86vUoH29Q66rXrXU12nuwNxaczv0HZ3mOuR6p7kv6Ht2vFNzR7WTQ99e+w4OuY3mjg59O839Qq5fa65DX+80t2HOSe7k0Pek1jvkOrVnh76d9h2YW2uuQ9/5xVvu7z6aO99yzzn07ZFzyHWae1KL6Zabdcj1MIe+c929b43ci+Y+OfTtNPce9tlp7gF9X53mHHIfkaM9ZMy9Yi0s9/ssd+f0XJk+269sn+1Xts/2K9tn+5Xts/3K9tl+Zftsv7J9tl/ZPtuvbJ/tV7bP9ivbZ/uV7bP9yvbZfmX73u5+NjY2NjY2/3P+AH4JqLY=:A7BB";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "12"){
											stringZPL +="^FO0,32^GFA,11648,11648,00028,:Z64:";
											stringZPL +="eJztmTuO4zgQhqUWDAYdCBMMOtQRfAT6ELPxXGOCXdBHmZvYR+hkc4cbKuhAGLjNbYnFYr3E8RqLwQIrJi3796dfVUXx1U2zta1tbWtb29rW/vPtty8PYW18g6uv8U+lTeniOcZ4XOFePrRXrnVxTBf+Q/thc2340K6Sm+BvVIYOuGHRRpPbL9rF5MKiccNn4BYp3pjWJ65NWhTaWB5TPOiQuKydqbZPfs+WFhIXQHujmk/cHrSxwl0NzoM2aa7N3I1rIwmdaS1wWWOJSRYdaiQxbQrJoXZm2sz1qH0v2i5xA2ok+E5yl6K5CufSp73F9YmbU/b+KXCuT36nJbKOJ3RI3EwclleCFNCnX0J1eJF8+uVsl7JKtBNyl/RLoiWHFhLZsyKlp24hkUxrE7eD4jhWwBTRx09ux5Tdwu0S5+C7HeVc4lx+Plp4h9w126PWIzflcCX3kvNIO8w+xdfnunnSYXzihjwkDaS4PvkN+VZ7wkXkzvnZRqpNC37MWr5nW+Fa5G7HHFPmdsDhPV3hHPRWn9NPuAG5G95opNpEtLZoAbhAuNxBfYWLyF1RA+4pAnfCbokvhMscdlkYNpo8OoxE+7h7jYOrPvuV1w65AFx5uvLE3uKuP+ei5jxoy2MGyb1jeD/m8fOpZJFyN+BGwS0vwxyQwX2dh4WZ6zQXMteVXpIrOWuvwL0Kbhn2FHdF7jxzzvY7z/Gt+DXCzxe/WwN+Z8OvAT/5nGFeQKzHd634TRW/cc0vJm2pn+H3mubNzxZ3TB3yyfI7wHz7Wcd3Ix1ZcTi/N4JbeuUqN65yYY4q8CVE4c4Vv7PyC8gdDA60a7POvTeSw/c9/qW5/CbCPQUHE8X3RsWHXKM5nGCOyq/N3B+aw/Hz98bikv03k0vaUXP4dh8059hChMdH5oefchPXHuL6Cie1e7lBaDS+PVsQKu685ufZApRz4UGOrZcEd8oTveZaydH4+AJbclybKhrhdhWuq3CObyAYpzTO8ezqVbPJDZIjv9zznRzjPN8EMc5XuFDhTutcXmYXjdwlsu6puOOKn9YKt+PdhXFO7dUK91Lh+jpn7P9SGyqcF/tN6ufN/Wa+lpMF46z97dKiOGkg3FO099Nz6zQ3Uu24wjl9T/SrcbIMlOsjGyUYJ1NNuUEepBAuyHMNEl8UZRCc1PBzlGcshesMLXNzGS4rnJNlIFwnUy24g9Cyv+zVlBtkGYifr3ChwgV1nlU4lWrCWRrZEI1Sgy+eLA04nc7i18veSbhBpZpzjdQId1jhdDqRm0+YtDbmi3UuquNB9Gt1OpHrTK2cK15WOKdTjdyzThlyvamlO+11GZDzOtXoZ2t4jvm+xhnpzFyrBonCWelEzihDjs9KZ+bU2En81NhJOKPnIreiLZx+2QsnpynKWenM8ckpTHDWPSfQ1rjW6GXIWekEbmelE7h80GdxzkoZxGe87IyzNDhv1aED11vpBG5f4bxYEVBOrggoF1a0+cuTlU7gzFSDn5myxMmFIOVaObMLztQmtY5nnFzsoTZWtHRuaqQ6+bk17U2txxk3mKlGztYmubXjnFdTGGjL+aeVauRsbZLbN86FCmeXL3F2+e7iDKmB8yWrfA2cD65oU5Ur/12JzBnOwUq7Vbj3BznmNz7s5yrcSyW+uznh19/Lifhq3FDxG+7l4oPcv+I3/mK/Cf9J+U/9ahzTRHy/1u+x+La2ta1tbWv/v/Y3G4KUWg==:3BD0";
											stringZPL +="^PQ1,0,1,Y";
										}
										//waterMark이미지 관련
									}
								}else{
									/* zt230 200dpi 용*/
									stringZPL += "^SEE:UHANGUL.DAT^FS";
									stringZPL += "^CW1,E:TIMESBD.TTF^CI28^FS";//"^CW1,E:MALGUNBD.TTF^CI28^FS";//"^CW1,E:TIMESBD.TTF^CI28^FS";	//TIMES NEW ROMAN 볼드
									stringZPL += "^PW600";		//라벨 가로 크기관련
									stringZPL += "^LH45,20^FS";

									if(lotNo.substring(0,1) == 'M' || lotNo.substring(0,1) == 'F'){	//20181126 'F'조건 추가
										if(BsaCodeInfo.gsSelectLabel == '2') {
											DataMatrix = itemCode + "|" + lotNo + "|" + orderUnitQ;

											stringZPL +="^FO0,0^GB500,380,4^FS";
											stringZPL +="^FO0,50^GB500,0,4^FS";
											stringZPL +="^FO0,110^GB500,0,4^FS";
											stringZPL +="^FO0,148^GB500,0,4^FS";
											stringZPL +="^FO0,186^GB500,0,4^FS";
											stringZPL +="^FO0,224^GB500,0,4^FS";
											stringZPL +="^FO0,262^GB500,0,4^FS";
											stringZPL +="^FO0,300^GB500,0,4^FS";
											stringZPL +="^FO150,50^GB0,250,4^FS";
											stringZPL +="^FO320,262^GB0,38,4^FS";

											if(BsaCodeInfo.gsLotInitail == '1') {
												stringZPL +="^FO150,5^ATN,8,8^FD"+"QC-JWORLD"+"^FS";
											} else {
												stringZPL +="^FO100,5^ATN,8,8^FD"+"QC-JWORLD VINA"+"^FS";
											}
//											stringZPL +="^FO100,5^ATN,8,8^FD"+"QC-JWORLD VINA"+"^FS";

											stringZPL +="^FO20,72^A1N,25,25^FD"+"Item Name"+"^FS";
											if(itemName.length > 18){
												stringZPL +="^FO180,61^A1N,24,24^FD"+itemName.substring(0, 18)+"^FS";
												stringZPL +="^FO180,86^A1N,24,24^FD"+itemName.substring(18,36)+"^FS";
											}else{
												stringZPL +="^FO180,72^A1N,25,25^FD"+itemName+"^FS";
											}

											stringZPL +="^FO20,121^A1N,25,25^FD"+"Spec"+"^FS";
											stringZPL +="^FO180,121^A1N,25,25^FD"+ spec + "^FS";
											stringZPL +="^FO20,159^A1N,25,25^FD"+"Date"+"^FS";
											stringZPL +="^FO180,159^A1N,25,25^FD"+ inoutDate + "^FS";
											stringZPL +="^FO20,197^A1N,25,25^FD"+"Qty"+"^FS";
											stringZPL +="^FO180,197^A1N,25,25^FD"+formatOrderUnitQ+"^FS";
											stringZPL +="^FO20,235^A1N,25,25^FD"+"Worker"+"^FS";
											stringZPL +="^FO180,235^A1N,25,25^FD"+inoutPrsnName+"^FS";
											stringZPL +="^FO20,273^A1N,25,25^FD"+"Weight"+"^FS";

											stringZPL +="^FO45,310^BXN,3,200^FD"+DataMatrix+"^FS";
											stringZPL +="^FO170,310^AUN,25,25^FD"+lotNo+"^FS";
										} else {
											var partNumber		= dataRaw.ITEM_NAME;
//												var description = '';
											var specification	= dataRaw.SPEC;
											var potype			= 'E1';						//고정값
											var date			= UniDate.getDbDateStr(dataRaw.INOUT_DATE).substring(2, UniDate.getDbDateStr(dataRaw.INOUT_DATE).length);
											var lotNo			= 'A1' + date + '01';		//'A1' + 날짜  + '01'
											var qty				= dataRaw.PACK_QTY;

											if(BsaCodeInfo.gsLotInitail == '1') {
												var vendorName	= 'JWORLD';					//고정값
											} else {
												var vendorName	= 'JWORLD VINA';			//고정값
											}
//											var vendorName		= 'JWORLD VINA';			//고정값
											var vendorCode		= 'DXRX';					//고정값

											var vItemCode		= dataRaw.ITEM_CODE;
											var vLotNo			= dataRaw.LOT_NO;
//											var itemDataMatrix	= vItemCode + "|" + vLotNo + "|" + qty;
//											var sumQty			= qty;
											var itemDataMatrix	= vItemCode + "|" + vLotNo + "|" + orderUnitQ;
											var sumQty			= orderUnitQ;
											var formatSumQty	= sumQty.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
											var sumQtyString	= strFm(sumQty, 6);
											var barCode			= partNumber + vendorCode + potype + lotNo + sumQtyString;
											//20181108 Exp.Date 추가
											var endDate			= '';
											if(!Ext.isEmpty(dataRaw.END_DATE)){
												if(UniDate.getDbDateStr(dataRaw.END_DATE).length == 8){
													endDate=UniDate.getDbDateStr(dataRaw.END_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.END_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.END_DATE).substring(6,8);//"2018-12-20";
												}
											} else {
												endDate = UniDate.add(dataRaw.INOUT_DATE, {months: + 12});
											}

											var stringZPL = "";

											/*	zt230 200dpi 용 (Verdanab)*/
//												var stringZPL = "";
											stringZPL += "^SEE:UHANGUL.DAT^FS";
											stringZPL += "^CW1,E:VERDANAB.TTF^CI28^FS";//Verdanab
											stringZPL += "^PW600";		//라벨 가로 크기관련
											stringZPL += "^LH10,10^FS";
											//상단 바코드
//											stringZPL +="^FO360,100^BY1,3,10^B3R,N,95,N,N,^FD"+ "*" + barCode+ "*" + "^FS";	//code39			-- 7.1mm
											stringZPL +="^FO360,60^BY2,3,10^BAR,85,N,N,N,^FD"+ "□" + barCode+ "□" + "^FS";	//code93
											stringZPL +="^FO330,110^A1R,23,23^FD"+ barCode +"^FS";

											stringZPL +="^FO291,50^A1R,19,19^FD"+"PART NO"+"^FS";
											stringZPL +="^FO291,232^A1R,19,19^FD"+":"+"^FS";
											stringZPL +="^FO291,247^A1R,19,19^FD"+ partNumber + "^FS";

											stringZPL +="^FO266,50^A1R,19,19^FD"+"SPECIFICATION"+"^FS";
											stringZPL +="^FO266,232^A1R,19,19^FD"+":"+"^FS";
											stringZPL +="^FO266,247^A1R,19,19^FD"+ specification + "^FS";

											stringZPL +="^FO241,50^A1R,19,19^FD"+"PO TYPE"+"^FS";
											stringZPL +="^FO241,232^A1R,19,19^FD"+":"+"^FS";
											stringZPL +="^FO241,247^A1R,19,19^FD"+ potype + "^FS";

											stringZPL +="^FO216,50^A1R,19,19^FD"+"Lot No"+"^FS";
											stringZPL +="^FO216,232^A1R,19,19^FD"+":"+"^FS";
											stringZPL +="^FO216,247^A1R,19,19^FD"+ lotNo + "^FS";

											stringZPL +="^FO191,50^A1R,19,19^FD"+"Qty"+"^FS";
											stringZPL +="^FO191,232^A1R,19,19^FD"+":"+"^FS";
											stringZPL +="^FO191,247^A1R,19,19^FD"+ orderUnitQ + "^FS";

											stringZPL +="^FO166,50^A1R,19,19^FD"+"Vendor Name"+"^FS";
											stringZPL +="^FO166,232^A1R,19,19^FD"+":"+"^FS";
											stringZPL +="^FO166,247^A1R,19,19^FD"+ vendorName + "^FS";

											stringZPL +="^FO141,50^A1R,19,19^FD"+"Vendor Code"+"^FS";
											stringZPL +="^FO141,232^A1R,19,19^FD"+":"+"^FS";
											stringZPL +="^FO141,247^A1R,19,19^FD"+ vendorCode + "^FS";

											stringZPL +="^FO116,50^A1R,19,19^FD"+"Worker"+"^FS";
											stringZPL +="^FO116,232^A1R,19,19^FD"+":"+"^FS";
											stringZPL +="^FO116,247^A1R,19,19^FD"+ BsaCodeInfo.gsWorker + "^FS";
											//20181108 Exp.Date 추가
											stringZPL +="^FO91,50^A1R,19,19^FD"+"Exp.Date"+"^FS";
											stringZPL +="^FO91,232^A1R,19,19^FD"+":"+"^FS";
											stringZPL +="^FO91,247^A1R,19,19^FD"+ endDate + "^FS";

											//QR 코드
											stringZPL +="^FO203,685^BQ,2,2^FDQA,"+barCode+"^FS";	//QR바코드
											//ITEM 바코드
											stringZPL +="^FO91,530^BXN,3,200^FD"+ itemDataMatrix+"^FS";
											stringZPL +="^FO91,590^A1R,19,19^FD"+ vLotNo+"^FS";

											stringZPL +="^FO123,620^GFA,01920,01920,00012,:Z64:";
											stringZPL +="eJzllMFKw0AQhjdGya3Vk7fmIXyAHPQBBL37CoIehEJS6aEP4osEvPgGXosevKZE3A077rjpZHe2NNLcFF0IfAyTn39mZ1aIv3kiRAT7md/IBjXz2SmziHfzpwaJkrjRoNGQ/qqG5uicuKxBCUEsEvvvkvL3YptfEo/aOOWYbAyoOi4kYBl1Pq3nWez9g0iJZ2j1u7pEAZA4nwWYsauxAHxE1lEF8aWNY+rzERdeB3FFfI/sH5nbvvWy7U/IiB/bfTu8YDbcfzQI71fPPq6yiDmPvE4DTj8BDaPcxWs18SxVmjtvssqYl0XuaqmXOemMU6hLYpwk1j8Q3x4DHFSUc3cDED91PAV0fVZTruVaci3ijTla8GzMH3r7OZS9zprX+uvTw2HOYG6CvVBZsCNpz7608yx37EhwvybfvOvenJDbe9zQ1NuMtfWvvTfdzS3NZPQNd/OzH0MVzKoesO+eVVBLxTOALyfBOxPMA77++Fs3gP/z+QLeyTC6:0AD4";
											stringZPL +="^PQ1,0,1,Y";

										}

									}else{
										if(waterMarkCheckV == "01"){
											stringZPL +="^FO0,32^GFA,05120,05120,00020,:Z64:";
											stringZPL +="eJzt0zESgjAQheHFFCljaWWOAjeLN/BKdF7DzpaSAllDHAvyXpHGRnfLnW/+AENEbGx+caKOZHdpcj1xibjU6BRdp+g64hxxjjhPXCAuEtcTl4hLbe6g6PLjgQvEReJio+uJS8Qpuk7ROeI8cYG4RJyiK8dWzhHniQvEJeIU3Tu3d4G4SNz2kR97V97itnflLa57V3LVf7odu3p0z8ptuzmgm4gbSW9Et9b3I++W+h7l3SzYm4i7kB7cy5iPxd5C3B3ub9QBXc5BbxF0OQe9Ad1ZsHcUdCfBnhD32TU561nPetaznvWsZ71/79nYfHlezm5vbA==:7868";
											stringZPL +="^PQ1,0,1,Y";

										}else if(waterMarkCheckV == "02"){
											stringZPL +="^FO0,32^GFA,05120,05120,00020,:Z64:";
											stringZPL +="eJztlTFSwzAQRSVUqKBQxVDqCBxBXIKaoygH4hA+SkpKyhQhC7Ete1f7xQgyEApvg+flR3q7wNqYrbba6s/rjt4VI6LXCt1/MnqULJ3ZXiB7RnQU7HZkJ8HiyGhQx8kDp+OI3hhzMzsw5mfGLwkzI30t0U5dK1gujMmQZnZhq4wDbNR7ehaTCeNJN0I6TiPJXDpOgcAF83SQ5xNMs1iVG/hP/nlijZT7Ipt08QprzhZ/v+Zs6dOtDbvysWR7+QV2jF0Hs+SMyA2loZILS5t5GSBnOpeWXFzGm5anwJjO8acTeNK5xK2++AbKYVOUO4LcUeUyyD2AnH3WOWNeVG6tCFhvLlYroZVLF+QyYDh3VKxeY212qJHtZE5utibzgIV69ZpxLIo1ckPNkliAU2XASI/eYqbG7DFTIw2YqfFFMJYE2s2AkW7N1i8kM23zOudBuwG0FkEbCbSRQRuklS1gDih7oByAcgQsAeUMGOk2LOk2HFD2QDkA5YaemvKV9HKnHvXp+YYeUkGsviIDFfTLBSrobw+p/LN/jZ/qoaX0Cwuo1mstoJoZoId2qwPKaLd60MYlrxf0Kmm8XtbaTSwD1ptDjPqYFcx05r7H3AU5yUxnrs18Z26rra5WH3gppcs=:5299";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "03"){
											stringZPL +="^FO0,32^GFA,05120,05120,00020,:Z64:";
											stringZPL +="eJztlzFu4zAQRcUlFixZpiSQdoH1EXQ06ixb7gnSWUdRuaVLITDEjSgNZ8j5jpUuhdjYeHohRxPyS+66c5zjHE/HJf1rkUkpaS2lqWHxg91rZNM6hoq5zMaK9ZnNarp2wozS0laXmgrdzgbA5ML9zuYnLO7s/jmjUmQxiK1deX+9VgW6XJqrCvTZsFWr/bZilCxs1X5UfpPstunM+u2PvLy5uBVh5I0wWyTbP9mj69KjeSIzQ+v13ARDdQVmlrzAjSmer7yJ2MBszF8cMwc8J7xxZ+WyZVameeKVsiz2pp0F4En2ubco76dg5HVX7XUGeN1v7dGw7dF84DngHWW+jYQvsKCzaN1XRz3FImBNwqzDqGjLbVHMAebbZOvK8WzLUyzq1td5UJZQLbhq9tKG5x53iN0BuwE2AtYsG9t83r22K1EvkdmC5hsBmwFr7kM/GCjKR+BNwLsBbwasXnj5c1GNHjsTdWdya4aGOVUg3ggGsA4xtAED2KgOMLSh0WGwBw8SOnDwYCKGDvUXAgF5ij0Ip/EIexCA0xHPfU/vx5v2XmblXdKsPH59YC8e9oh5wNjry27i/9txRrskAMb7JUhPXa28gSolz2M2AjZt3/h8lA6Jc1Q8W3k3YuSV9ytxfstlV7Gl9cq7oMwNyqlebJdU3hN5W+35Y2WGRWYDsX5br3qYha3AIHMybEKVpz5PbqrcXdny91rlM/0MkPFnCyu3Id7bS8kU7HU8R2KMym8ImWoh6ceCT/rxQQVOglnAaGGJ9oXrMPXN3fKE1XT4MX1JOusNeBZ1v9J7i85xju8y/gNsoY1l:03BC";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "04"){
											stringZPL +="^FO0,32^GFA,05120,05120,00020,:Z64:";
											stringZPL +="eJzt1kFugzAUBFAsKrH0EXwUd9F7maNxlBwhSxYI1zbQ4j8T6TcsqkSe5dMoyljEpOtaWlqezcfXJ5iNdzBHzBMLSos6M8R6YsMFs8QcMU8sXOhFNEOsv2ADMUvMKc0rLRCLaIaYttcTG6itYC4uYDbOqp4nvfSAg8V4U9okzRBLc0dpaS78ZtJcMEt6Ni5gjliaCxaI5bsAe2jpCKTlucRGaT03uDcGYjYdi7Q8F20G86TnSa9cc8LyXGFl7pNWjkBYmSuszFXZAuaIlbnCtltd2k3afoPXvUh7k7Rtbm0Dt06apbaCbXNr2+bWFqjdVbbNrWyfW1mvt1HafgSV7XMrc9QWME9tBjve7Wfb557NEHvQm6Qdc892zK1tBXOk52hvAcsvtt+Mx+edMj3s+X/qvfP3+4nyv2OzZs3+aC0tr5Rv/Vq7Gg==:C5D0";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "05"){
											stringZPL +="^FO0,32^GFA,05120,05120,00020,:Z64:";
											stringZPL +="eJztlz1WrTAQgIkcDyWVdXobl0DlEl7tUkLnMtyG3aWzdQlZwi0sOB4ekZ9kfpJRI5dKSSPn42OSgTuTWBTHOMZfHTf/wkDWuDBaYAZYJ7B9PCd4bl9PXeCpnb1S8MpMr6LrR6+NWSWwT7wYZbM62xuznpW9PKazvWEza7K9PutZyTPis5d4583MObvZc3mekp+d2Ok98rrpXbtX7nXFybGPPHsVL/KF1TOznJmZDYy1S7GRgFPJvKwVyNhj3IUm9rSyM2WnleFnqaCiB+r5MQqeEzzWDpK2QZgVGCywRtYL3sA8e5Wy+ddPFlivgRRNRPuFmcibE7gjiWh/P/j+ug95E7asX3G25kkS1uG2wYSbMF3DGA+8sBEW2sdejS8BSrpC79ogwy/8vP4pXdoElMAKJzSuXGaExmoyvSaftTHTgqdlbzOrL/O6Pb16/3hZ7Af5xug779bGcyhs9+CVrMrWC+VEL6koJVSekr1QUfjbFRipHgNX6MFd4slXGDl9woirSrP8klVCH6rxTTbhV6Jl1nkGtwmDMA3rp+ewgBa93qcLnzy0KcXZ6NMYCXPU9/eX2KRNLnHsOi1uen7ToXvP7P2f2iVlyybRLtuDZezt3tD9Tfw3RQMDhBsc6X6wwZGuCxsrOT7BuZ0eYwKzhBnPOsLCxC1hYWKCwsT81JZOGzK2jOkknA8YHwJNEo5/2zDUAz9eHeMYv3l8AP3k8eU=:0DE1";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "06"){
											stringZPL +="^FO0,32^GFA,05120,05120,00020,:Z64:";
											stringZPL +="eJztl7GV2zAMhkXz5ankCBjghmA2ySjUKClvi2iEjKDyShUpXPjMWBQB/iB5si+p8mJWep/+AwHq+AMehud6rn98vcS3GpkY49eKuRtbKlm4sYtmNm5rUowSmxXziZ0VC4npgAnFK6JxZ7HOrt6YMsOsfWZrs61OJrbMMINkbIdxepigTaF+qAS3lH+mJGdk111dGKUjMaoQv2fmkYW9KsLiwr6hw0JyEqNm15ymMFOYfBF532FGsxXj5mNZc07IllyPMMe1+3KAjs8NGPEjKV31B1rHTLYDXeD0XTl8D6zRjUUX+Ngs6tZGJ5/Gdtn7IGzJ7JWRaW4f6soy9UX7BLP1xdWZHurGx3U1elj3KHPaL+7oTsr/9n+hoPzP8aVcKkbarhLz2oboxkzlf5vOVta06cbK/zadq+yFbu9DZS+usAl0bFhzYVc2rAV0bFhrh52BscdegLHHXjsMruqFfReu5YV9F6/bltoJGcX3FIkg6cTO+pNQrsBAIfIpQimEODFfCvFcAPik50JHrUvvbSmYeD9TCvaSV9F5qUnr9vMIcjAkrwvzEsZ3GMlh9RhJ+orlMl1HJ6bMXUYxiuBrq7D81h7qfF+Xn0wnnmLzx2y4p5tEd/5Y5w51A57a3+ga1tM57C4H+bkH9+11ofFPdE1XM4dd7a5uEbZ0dIU1b9XTQ1GGfuReny79vLC278ej+YDQ2HrzRju/eH70x4zKPATGm7cLapZacqKoY7+6gI6ZGP7Y+p/Mgjg72mxYBA3EFLYgm/e6hQ3ZKCN2xyA+XpgXv5+Q3Zr0t4iNfXPPt1NU87i0I+jUMrfDfD92dDLzr8dMflfMdxj3UEDd3zO2SU82xm15k0WxveJJsRSwGotSwF+apYDfK/YlltkUSpka9lzP9R+t3/mkV4A=:BF74";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "07"){
											stringZPL +="^FO0,32^GFA,05120,05120,00020,:Z64:";
											stringZPL +="eJztlDEOg0AMBEEUlPcEnsLT4Gk8JU+gTBHlkiIKkT0nLfFJSXFbjhYkr9fXdU1NTS+l/KG9zCbR1/5n2EX831Zmh+ac3QYXYDnfLepzvoHvatHAbLdsBJbe4x6aYIwnWy2j0WY/RmTc/o/GVSOgcReMxTOOwDE1ggHGVWNJEEviWJxvBh/FEmgLRUXHoTaIYvlVfLWPjdtH8UntOxEzRarGrLLNskL0xFbL1MOfAutgn49ZZbwO1efWoTJa24n1bt8yWltkvQWfRTLj9XpWuwaBukQe03+qVeR1qV3TEWql1ln1Repc21ef+fOI+OjcVJ/KJjgj9dumpibSA7tXrYA=:EF16";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "08"){
											stringZPL +="^FO0,32^GFA,05120,05120,00020,:Z64:";
											stringZPL +="eJztlz1u3DAQhaWoEJAULFPyCD4CfTOqzimClGlyhOgIOYJKlypSCIuFxqbIGc6Qs7RguHCQZWHIn5/mhyLfwF13X/f1b6/PsE8l8wB/CvQFAPaC2RcGj5IFBE8C9Qe7CmYOJgMe4QAEc5EtRXVhrVVagK1KKxObxHjiMTGe2CKbFDZX5YkCPTJWYPj1x4Ngoby/x8/Mhrh3opE+ZrS8kSFWa3gjYxQMnJkYqOeNmJSQN2xSA57pbGrUMeYym5lu4nr+jmEb41K+Ueh2ZKTzqc9BsF1hUdezDYTMtrZuKx6CjlhTR38+q/OcfUjdu+zLK99jben071szPC/8XFn1XNXnD8+nlWd34Xr+jpdsi/1kNua7hQgvn7iDSTCW93fKYeOKTuBK37h0n6SxBX95/Co9R/Mh8quMVP/TfFLzU0wyc2Yqm9T9vqvDofEK9rtqg+rjfj8kdqnDiYC0L6xA8mfWCKLCn0sW0u7ffonuxkPR+8J34XvMTszSOcjMkWeLs4v+zNmSSqed8fk8s/tG557dc7ofyHrId+ua2VU+HH/e5AsHI//TGDaXLd0Ty9fR0Rcx1KblbCpZ+0lEyRXMlK2qQNexjki3n9I5vpPLbZ0/qRPx1ts59HhbW7feflfTnY13vr63799ZneVsbula52Vs6oxy/l59msootnk/Rs5y9fQFNca6pDmNTLvnN/yg8g3VXzQfQr9ykq1JvzCW5qWY0+iTMzITBQ7k/A0BPcj5C/Az+LOcv1BMpMyKuVoOGk1nlflBbMpMm0c4t940f22VVp+/Y5WiU+dvDDhLZqpw3bE1a4Fe/iG8lLL7uq//aj0DAf55YQ==:155C";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "09"){
											stringZPL +="^FO0,32^GFA,05120,05120,00020,:Z64:";
											stringZPL +="eJztlzGS3CAQRUVRLgUOKAeOOQp7iz0OyvcSvom5hHMdQYEDBWPhGdHd/AZmPbXOtoZE0uOL7kaiG6bp2Z7t87Xv+XfHfua8NGjOuROGKzs0MvHKclLM3lBeu+FyvijmTqYHPIfLWbGClIeG2NaZzXnvzGrDjhga9sTQcGAGhiMziJgRRHy69+tVOWiKScVsefLotC2jf0V2C+PlvFSnHT0g8xRphEB48ACBBHLCQyCBAnCgi9Q/gy5Sv4WA2d4MjP0ylRmeYFMnwcjHqQFXFoVZ6Q5Ddqlsa9kszCNbmR3vMwrdDRlPdJ02xZK80ekq8wNWdVbuvPTOA2t3dKmNaKSzY116ULe2OjPQmcHsVhaG44Fuu/+u8kW+/j/868Yb6ez/6bZWV/9EN3x3qFta5gdM/X+VJXljpNtllE6HawGYzC7fWfiCMB71RtTtwnZhsvZBVxnpDOQSSRzMbGWSX2alKwE7KA2c1zzoIgUStG6nq+g4TCw1vhg2WJJcMWyRecn3Uen2Wwk+arKbuX4cVcflLV8qMwMm9WjPPdtAx7VsBcY1LwHzXAZzzybQUa09JigC5PRlwqpH7qGOnNmUrjiTlK4YnpTOFrNKZ4pZg+w0smodfTqto1Kk2eutAjc6NjVi6aPMPq5bWjY/ruvYHV2LhswN2dEx/wHd28KMdV8ie6rq/oilcheHuv19HTG1L0l8A0twZV3HRjrYN0m3VUt1u6vDz8tu6f1acd+r/dqFwkXdQdc6zUHYASyTfdSd45hm35mKe3Wj7Yr/DvexVEo8MhIEXNEzL8pmlf84s+Wq2J9vMeNfLzkR/ubKptoY4d/HORHPC5wT8VzB+Q/PH3yuWIHx+SMB40S+AGMHJ2yxc4UNb4q5ziwbflFsaqPlAbeGXT08loZd819/bny2Z/us7S8pJEtL:61E5";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "10"){
											stringZPL +="^FO0,32^GFA,05120,05120,00020,:Z64:";
											stringZPL +="eJztl01u2zAQRikIhZY8AoGeIosiPBp1kx6gl+BNomWXXnrhaMoZ/s1QlKs4RlCgIhDBeHkaf6Ioa6jUOc5xjueM71s0AB3ft8zC7w1zcGNsBDrA2mHQMh2Yr2xCZjrMBna5zzSygHiYHjOAuUEELIwFtBAjA8yCTQ1zd1m9EKytYf0FsGQ0IDMhnKtsRGbDhdmN58PfpfF8qHmt00JsDh+KpyPDE4pnkDm65sIsMpyTljmcuzqB0SNWJtAV5opHc0mlioczHA4YzWVGiyJGs5lN1bP5hujoCWYiW1S8gTleZsVzHQ8q0+nG0QIIX+4ZGxPjXoj3lr0psRDvJ4QjPzfEM9XzKd5qIBn5XAs38mbh3XT1Mruae2xMCyYsnsDilY7FWzqe73gzY9lTW7bis9WwW/WGzK4IrPQW7sWFaj15q/DodpmVe6+Ke5H96Hgv9OzLeqrjKVbvi1nJp/iDibO4e+4xT9ZzB71NvZ18D9e7m099/DpCPvfMeubJ9f6x+fv8/X1s/X3++Th67ijY/nP+oAeNt/f7In7/Uj045pld7zjzLJ/8vY8etUTl/ZHZR7zjbGZMvgdzPq/q+5J7LVt2PfVXb1HsvU8fm/4gsYv09KbfoH8PHdb0L8xzDRP9UGKyb6IIIHsuYqgMjOltvxY96LOxYZZ61EvDsJ+UrOk7kyf60+RhH+tFvtjveuHppi+ubBZsavpx0+nHzU4vP3bY7t7g2nhO7itMZ69hOvsU09nPEJvkvsd09kdxOP4Vacj9Vhzf3jfoHOf4f8YfcFNogA==:9A6B";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "11"){
											stringZPL +="^FO0,32^GFA,05120,05120,00020,:Z64:";
											stringZPL +="eJzt1DFOxDAQhWEbFy59hFyDAuGjORIH4Eq7FdeIREGJ6SIRYuzVvH1IsVysaEAzVfTll71bTIzR0dH52xM2eYj5ahMsdayMu9jpkpi9wYqYo1mY71gYd67TedhEC7A4tgmWxhZhhZbE7A8rYo5mYZ7mYGFsHhY7NtEmWBpbEqt3HczS2uMmd43MwyItdCzCCi11rIg5moV5moMFWn39dbH6t9/E6rWfF6vVO+2jWTv3hfbarJ37TDs3a9d62pN0e6BZsY3d7sRWdpuV8zK7Fd3CLqM7sVvQzexm6XbDzki3X/ej7rP8vsxuRbewy0bOO7Fb0M3sZC/9zr18lL10K/fyAV1md49uOe65M8c9vzM3fQ+000477bTTTjvtfrPT0fkn8w1SEEfj:BD80";
											stringZPL +="^PQ1,0,1,Y";
										}else if(waterMarkCheckV == "12"){
											stringZPL +="^FO0,32^GFA,05120,05120,00020,:Z64:";
											stringZPL +="eJztls2N3DAMRmUIgY9OB04FW8KqNLuTtOJO4hJ8NBaCuKJ+SZEZTJCrdZidffOG5id5ZBnzjGc84/UI+LKEnaApsQ0OwiwyC/BFPYgvMwCM3hLZPrA1MlJwDukSACdhWCgiuDpbAl4njlthnjOLLHS2Qm6PNuhCbo82uIbcHmXouYFtUFkPAs3rQbaArv9BGXoYgrAJ+8JaWw9ss7fHfm7KkrtwL7lz92LU6Hn8sE3MkrybsTWxy2S5xK3M9AmMsWLNswSqUxBizZN5yOY0Jd2D5B1lImtciGxPlVuM5DE2Z5Y7bTGat9YFwRUrRvMcevm/pXobZa29yHJn1Us3VPHmwqzixfb+hHTLdC+293v0YnuxmGNenOVVeh6Zz97x0oPm1Xq34l1KvVPxjlhvGrwdg31wr4Sl1w2dNc/3ZWjerXiXZO5UvKPXq2/crnims+p9Elbvq59G1vuleEapR1m7n8nHW5CeyrxkoNQDzZNsUpglG2WtN1GmeYXNZOOtbKEMXnmnYCvZJytz1KvLqnq7YJvC2D4OlRnFE2xiz4r83o7PD8O2zubNKrsFWxiD8ucSHp2Wzg7BNuZBYdJjz9/MJvaczsxyBgorG1hQmBeMxW2b8y08p7CNTktjp6jHzyXZA8kmNgWZ2YGV84sZvYXFrcwr7GYMzBg3e05hPG5lp6jH42aPx0iMr25mdmSgsDCubmVesCFuqrfyGOUspbFTMDcyEHGTt/G4hRnBYGQgpgW9aYibmRfMDnGxnmSB/+4buwRbhrhYbxZM8+pZirNVMOinI+I5ha3DtGQP+OEWzxuCaV5IJ/m/sZ3U0zx4s570QP3uvzLS3/Qf9ZTvvl1P8xpr/T3jGc94e3wDXMFCCw==:CC6C";
											stringZPL +="^PQ1,0,1,Y";
										}

                                        if(itemLevel == '6000'){
                                        	stringZPL +="^FO0,0^GB500,380,4^FS";
                                            stringZPL +="^FO0,50^GB500,0,4^FS";
                                            stringZPL +="^FO0,110^GB500,0,4^FS";
                                            stringZPL +="^FO0,155^GB500,0,4^FS";
                                            stringZPL +="^FO0,200^GB500,0,4^FS";
                                            stringZPL +="^FO0,245^GB500,0,4^FS";
                                            stringZPL +="^FO0,290^GB500,0,4^FS";
    
                                            stringZPL +="^FO150,50^GB0,240,4^FS";
    
                                            stringZPL +="^FO120,5^ATN,8,8^FD"+"IQC PASS(RoHS , H/F)"+"^FS";
                                            stringZPL +="^FO20,72^A1N,25,25^FD"+"Item Name"+"^FS";
    
                                            if(itemName.length > 15){
                                                stringZPL +="^FO180,61^A1N,35,35^FD"+itemName.substring(0, 15)+"^FS";
    
                                                stringZPL +="^FO180,86^A1N,35,35^FD"+itemName.substring(15,30)+"^FS";
                                            }else{
                                                stringZPL +="^FO180,72^A1N,35,35^FD"+itemName+"^FS";
                                            }
                                            stringZPL +="^FO20,125^A1N,25,25^FD"+"Spec"+"^FS";
                                            stringZPL +="^FO180,125^A1N,35,35^FD"+spec+ "*" + trnsRate + stockUnit + "^FS";
                                            stringZPL +="^FO20,170^A1N,25,25^FD"+"In.Date"+"^FS";
                                            stringZPL +="^FO180,170^A1N,35,35^FD"+inoutDate+"^FS";
                                            stringZPL +="^FO20,215^A1N,25,25^FD"+"Exp.Date"+"^FS";
                                            stringZPL +="^FO180,215^A1N,25,35^FD"+endDate+"^FS";
                                            stringZPL +="^FO20,260^A1N,25,25^FD"+"PD.Date"+"^FS";
                                            stringZPL +="^FO180,260^A1N,35,35^FD"+" "+"^FS";
    
                                            stringZPL +="^FO45,308^BXN,3,200^FD"+DataMatrix+"^FS";
                                            stringZPL +="^FO170,308^AUN,25,25^FD"+lotNo+"^FS";
                                        }else{
    										stringZPL +="^FO0,0^GB500,380,4^FS";
    										stringZPL +="^FO0,50^GB500,0,4^FS";
    										stringZPL +="^FO0,110^GB500,0,4^FS";
    										stringZPL +="^FO0,155^GB500,0,4^FS";
    										stringZPL +="^FO0,200^GB500,0,4^FS";
    										stringZPL +="^FO0,245^GB500,0,4^FS";
    										stringZPL +="^FO0,290^GB500,0,4^FS";
    
    										stringZPL +="^FO150,50^GB0,240,4^FS";
    
    										stringZPL +="^FO120,5^ATN,8,8^FD"+"Item Description"+"^FS";
    										stringZPL +="^FO20,72^A1N,25,25^FD"+"Item Name"+"^FS";
    
    										if(itemName.length > 15){
    											stringZPL +="^FO180,61^A1N,35,35^FD"+itemName.substring(0, 15)+"^FS";
    
    											stringZPL +="^FO180,86^A1N,35,35^FD"+itemName.substring(15,30)+"^FS";
    										}else{
    											stringZPL +="^FO180,72^A1N,35,35^FD"+itemName+"^FS";
    										}
    										stringZPL +="^FO20,125^A1N,25,25^FD"+"Spec"+"^FS";
    										stringZPL +="^FO180,125^A1N,35,35^FD"+spec+ "*" + trnsRate + stockUnit + "^FS";
    										stringZPL +="^FO20,170^A1N,25,25^FD"+"In.Date"+"^FS";
    										stringZPL +="^FO180,170^A1N,35,35^FD"+inoutDate+"^FS";
    										stringZPL +="^FO20,215^A1N,25,25^FD"+"Exp.Date"+"^FS";
    										stringZPL +="^FO180,215^A1N,25,35^FD"+endDate+"^FS";
    										stringZPL +="^FO20,260^A1N,25,25^FD"+"PD.Date"+"^FS";
    										stringZPL +="^FO180,260^A1N,35,35^FD"+" "+"^FS";
    
    										stringZPL +="^FO45,308^BXN,3,200^FD"+DataMatrix+"^FS";
    										stringZPL +="^FO170,308^AUN,25,25^FD"+lotNo+"^FS";
                                        }

									}
								}
								sendDataToPrint(500, format_start + stringZPL + format_end);
//								selected_printer.send(format_start + stringZPL + format_end);
							});

						} else {
							printerError(text);
						}
					});
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '',
			items: [{
				boxLabel: '300dpi',
				width: 60,
				name: 'DPI_GUBUN',
				inputValue: '1',
				checked: true
			},{
				boxLabel : '200dpi',
				width: 60,
				name: 'DPI_GUBUN',
				inputValue: '2'
			}]
		}],
		setAllFieldsReadOnly: setAllFieldsReadOnly
	});

	var inoutNoSearch = Unilite.createSearchForm('inoutNoSearchForm', {						//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items: [{
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
				store		: Ext.data.StoreManager.lookup('whList')
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel			: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName		: 'INOUT_CODE',
			 		textFieldName	: 'INOUT_NAME',
				validateBlank		: false
			}),{
				fieldLabel	: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',
				name		: 'INOUT_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B024',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
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
			}]
	}); // createSearchForm

	var noreceiveSearch = Unilite.createSearchForm('noreceiveForm', {						//미입고참조
		layout:	{type : 'uniTable', columns : 3},
		items: [
		{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			readOnly	: true,
			child		: 'WH_CODE',
			value		: UserInfo.divCode,
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
			fieldLabel		: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_ESTI_DATE',
			endFieldName	: 'TO_ESTI_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			width			: 315,
			allowBlank		: false
		},
			Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			readOnly		: true
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.powarehouse" default="발주창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList')
		},{
			fieldLabel	: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name		: 'INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'M201',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode4', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode4', newValue, divCode);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name		: 'ORDER_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'M001',
			value		: '1'
		},{
			fieldLabel	: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
			name		: 'CREATE_LOC',
			hidden		: true
		},{
			fieldLabel	: '<t:message code="system.label.purchase.currency" default="화폐"/>',
			name		: 'MONEY_UNIT',
			hidden		: true
		}]
	});

	var inspectresultSearch = Unilite.createSearchForm('inspectresultForm', {				//검사결과참조
		layout :	{type : 'uniTable', columns : 4},
		items :[{
			fieldLabel		: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DVRY_DATE',
			endFieldName	: 'TO_DVRY_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			width			: 315,
			allowBlank		: true
		},
		{
			fieldLabel	: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name		: 'ORDER_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'M001'
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptinspecno" default="접수/검사번호"/>',
			name		: 'INSPEC_NUM',
			xtype		: 'uniTextfield'
		},{
			fieldLabel	: '<t:message code="system.label.purchase.powarehouse" default="발주창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('whList')
		},{
			fieldLabel	: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
			name		: 'CREATE_LOC',
			hidden		: true
		},{
			fieldLabel	: '<t:message code="system.label.purchase.currency" default="화폐"/>',
			name		: 'MONEY_UNIT',
			hidden		: true
		}]
	});



	var masterGrid = Unilite.createGrid('s_mms510ukrv_jwGrid1', {
		excelTitle	: '<t:message code="system.label.purchase.receiptentry" default="입고등록"/>',
		store		: directMasterStore1,
		layout		: 'fit',
		region		: 'center',
		flex		: 1,
		uniOpt		: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		selModel	: 'rowmodel',
		tbar		: [{
			xtype	: 'button',
			text	: '<t:message code="system.label.purchase.slipentry" default="지급결의 등록"/>',
			margin	: '0 0 0 100',
			handler	: function() {
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
					'PGM_ID'		: 's_mms510ukrv_jw',
					'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
					'CUSTOM_CODE'	: panelResult.getValue('CUSTOM_CODE'),
					'CUSTOM_NAME'	: panelResult.getValue('CUSTOM_NAME'),
					'MONEY_UNIT'	: panelResult.getValue('MONEY_UNIT'),
					'INOUT_DATE'	: UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE')),
					'WH_CODE'		: panelResult.getValue('WH_CODE'),
					'INOUT_PRSN'	: panelResult.getValue('INOUT_PRSN'),
					'CREATE_LOC'	: panelResult.getValue('CREATE_LOC'),
					'INOUT_NUM'		: panelResult.getValue('INOUT_NUM'),
					'ORDER_TYPE'	: directMasterStore1.data.items[0].get('ORDER_TYPE')
				}
				var rec1 = {data : {prgID : 'map100ukrv', 'text':'<t:message code="system.label.purchase.slipentry" default="지급결의 등록"/>'}};
				parent.openTab(rec1, '/matrl/map100ukrv.do', params);
			}
		},{
			xtype	: 'splitbutton',
			itemId	: 'orderTool',
			text	: '<t:message code="system.label.purchase.reference" default="참조..."/>',
			iconCls	: 'icon-referance',
			menu	: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId	: 'noreceiveBtn',
//					id:'noreceiveBtn',
					text	: '<t:message code="system.label.purchase.unreceiptreference" default="미입고참조"/>',
					handler	: function() {
						openNoReceiveWindow();
					}
				},{
					itemId	: 'inspectnoBtn',
//					id:'inspectnoBtn',
					text	: '<t:message code="system.label.purchase.noinspecreference" default="무검사참조"/>',
					handler	: function() {
						windowFlag = 'inspectNo';
						if(referInspectResultWindow) {
							referInspectResultWindow.setConfig('title', '<t:message code="system.label.purchase.noinspecreference" default="무검사참조"/>');
						}
						openInspectResultWindow();
					}
				}/*,{
					itemId	: 'returnpossibleBtn',
					text	: '반품가능발주참조',
					handler	: function() {
						openReturnPossibleWindow();
					}
				}*/,{
					itemId	: 'inspectresultBtn',
					text	: '<t:message code="system.label.sales.inspecresultrefer" default="검사결과참조"/>',
					handler	: function() {
						windowFlag = 'inspectResult';
						if(referInspectResultWindow) {
							referInspectResultWindow.setConfig('title', '<t:message code="system.label.sales.inspecresultrefer" default="검사결과참조"/>');
						}
						openInspectResultWindow();

					}
				}],
				listeners:{
						beforeshow:function( menu, eOpts ) {
						if(BsaCodeInfo.gsQ008Sub == 'Y'){ //무검사참조
							menu.down('#noreceiveBtn').setHidden(true);
							menu.down('#inspectnoBtn').setHidden(false);
						}else{	//미입고참조
							menu.down('#noreceiveBtn').setHidden(false);
							menu.down('#inspectnoBtn').setHidden(true);
						}
					}
				}
			})
		}],
		features: [
			{id: 'masterGridSubTotal'	,ftype: 'uniGroupingsummary',showSummaryRow: false},
			{id: 'masterGridTotal'		,ftype: 'uniSummary'		,showSummaryRow: true
		}],
		columns: [
//			{dataIndex: 'INOUT_SEQ'				, width:57 , align:'center'		,hidden: true},
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width:100, align:'center'},
			{dataIndex: 'WH_CODE'				, width:80 },
			{dataIndex: 'WH_CELL_CODE'			, width:100,	hidden:sumtypeCell},
			{dataIndex: 'ITEM_CODE'				, width:130,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					extParam		: {POPUP_TYPE: 'GRID_CODE'},
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
						applyextparam: function(popup){
//							popup.setExtParam({'SELMODEL': 'MULTI'});
							popup.setExtParam({'POPUP_TYPE'	: 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE'	: panelResult.getValue("DIV_CODE")});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'				, width:180,
				editor: Unilite.popup('DIV_PUMOK_G', {
					extParam		: {POPUP_TYPE: 'GRID_CODE'},
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
						applyextparam: function(popup){
//							popup.setExtParam({'SELMODEL': 'MULTI'});
							popup.setExtParam({'POPUP_TYPE'	: 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE'	: panelResult.getValue("DIV_CODE")});
						}
					}
				})
			},
			{dataIndex: 'SPEC'					, width:150},
			{dataIndex: 'ORDER_UNIT'			, width:80	,align: 'center'},
			{dataIndex: 'ORDER_UNIT_Q'			, width:100 ,summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_FOR_P'		, width:100 },
			{dataIndex: 'ORDER_UNIT_FOR_O'		, width:100 ,summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_P'			, width:100	,hidden: true},
			{dataIndex: 'ORDER_UNIT_I'			, width:100	,hidden: true	,summaryType: 'sum'},
			{dataIndex: 'LOT_NO'				, width:120	,hidden: true},
			{dataIndex: 'LOT_YN'				, width:120	,hidden: true},
			{dataIndex: 'TRNS_RATE'				, width:66	,maxLength:12	,hidden: false},
			{dataIndex: 'STOCK_UNIT'			, width:88	,align: 'center'},
			{dataIndex: 'INOUT_Q'				, width:100 ,summaryType: 'sum'},
			{dataIndex: 'PRICE_YN'				, width:100	,hidden: true},
			{dataIndex: 'MONEY_UNIT'			, width:88	,hidden: true	,align: 'center'},
			{dataIndex: 'EXCHG_RATE_O'			, width:88	,hidden: true },
			{dataIndex: 'INOUT_P'				, width:115	,hidden: true},
			{dataIndex: 'INOUT_I'				, width:100	,hidden: true	,summaryType: 'sum'},
			{dataIndex: 'TRANS_COST'			, width:88	,hidden: true},
			{dataIndex: 'TARIFF_AMT'			, width:88	,hidden: true},
			{dataIndex: 'ACCOUNT_YNC'			, width:88	,hidden: true},
			{dataIndex: 'ORDER_TYPE'			, width:88	,hidden: true},
			{dataIndex: 'BL_NUM'				, width:88	,hidden: true	,maxLength:20},
			{dataIndex: 'ORDER_NUM' 			, width:120	,hidden: true},
			{dataIndex: 'ORDER_SEQ'				, width:57	,hidden: true	,align: 'center'},
			{dataIndex: 'ITEM_STATUS'			, width:80	,hidden: true},
			{dataIndex: 'REMARK'				, width:188	,hidden: true	,maxLength:200},
			{dataIndex: 'PROJECT_NO'			, width:120	,hidden: true},
			{dataIndex: 'TRADE_LOC' 			, width:88	,hidden: true},

			{dataIndex: 'INOUT_NUM'				, width:110	,hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'		, width:80	,hidden: true},
			{dataIndex: 'LC_NUM'				, width:100	,hidden: true},
			{dataIndex: 'INOUT_PRSN'			, width:100	,hidden: true},
			{dataIndex: 'INOUT_PRSN_NAME'		, width:100	,hidden: true},
			{dataIndex: 'ACCOUNT_Q'				, width:80	,hidden: true},
			{dataIndex: 'CREATE_LOC'			, width:80	,hidden: true},
			{dataIndex: 'SALE_C_DATE'			, width:100	,hidden: true},
			{dataIndex: 'ITEM_ACCOUNT'			, width:100	,hidden: true},
			{dataIndex: 'INOUT_TYPE'			, width:100	,hidden: true},
			{dataIndex: 'INOUT_CODE'			, width:100	,hidden: true},
			{dataIndex: 'DIV_CODE'				, width:80	,hidden: true},
			{dataIndex: 'CUSTOM_NAME'			, width:80	,hidden: true},
			{dataIndex: 'INOUT_DATE'			, width:100	,hidden: true},
			{dataIndex: 'INOUT_METH'		 	, width:80	,hidden: true},
			{dataIndex: 'ORDER_Q'				, width:80	,hidden: true},
			{dataIndex: 'GOOD_STOCK_Q'			, width:100	,hidden: true},
			{dataIndex: 'BAD_STOCK_Q'			, width:100	,hidden: true},
			{dataIndex: 'ORIGINAL_Q'		 	, width:100	,hidden: true},
			{dataIndex: 'NOINOUT_Q'				, width:80	,hidden: true},
			{dataIndex: 'COMPANY_NUM'			, width:80	,hidden: true},
			{dataIndex: 'INSPEC_NUM' 			, width:88	,hidden: true},
			{dataIndex: 'INSPEC_SEQ' 			, width:88	,hidden: true},
			{dataIndex: 'INOUT_FOR_P' 			, width:80	,hidden: true},
			{dataIndex: 'INOUT_FOR_O' 			, width:80	,hidden: true},
			{dataIndex: 'INSTOCK_Q'				, width:80	,hidden: true},
			{dataIndex: 'SALE_DIV_CODE'			, width:80	,hidden: true},
			{dataIndex: 'SALE_CUSTOM_CODE' 		, width:80	,hidden: true},
			{dataIndex: 'BILL_TYPE'				, width:80	,hidden: true},
			{dataIndex: 'SALE_TYPE'				, width:80	,hidden: true},
			{dataIndex: 'EXCESS_RATE'			, width:80	,hidden: true},
			{dataIndex: 'BASIS_NUM'				, width:80	,hidden: true},
			{dataIndex: 'BASIS_SEQ'				, width:80	,hidden: true},
			{dataIndex: 'SCM_FLAG_YN'			, width:80	,hidden: true},
			{dataIndex: 'STOCK_CARE_YN' 		, width:88	,hidden: true},
			{dataIndex: 'COMP_CODE'				, width:80	,hidden: true},
			{dataIndex: 'FLAG'					, width:80	,hidden: true},

			//20180725 추가 (ITEM_WIDTH, SQM)
			{dataIndex: 'ITEM_WIDTH'			, width:88	,align: 'center'	,hidden: true},
			{dataIndex: 'SQM'					, width:88	,align: 'center'	,hidden: true},
			//20180807 추가 (PACK_QTY),
			{dataIndex: 'PACK_QTY'				, width:88	,align: 'center'	,hidden: false},
			//20181121 추가 (제조일: MAKE_DATE, 제조LOT: MAKE_LOT_NO)
			{dataIndex: 'MAKE_DATE'				, width:100	,hidden: true},
			{dataIndex: 'MAKE_LOT_NO'			, width:120	,hidden: true},
			{dataIndex: 'ITEM_LEVEL1'            , width:120 ,hidden: true}
		],

		listeners: {
			beforeedit	: function( editor, e, eOpts ) {
				if(e.record.phantom != true){
					return false;
				}
				//20181121 추가 (제조일: MAKE_DATE, 제조LOT: MAKE_LOT_NO)
				if(UniUtils.indexOf(e.field, ['MAKE_DATE', 'MAKE_LOT_NO'])) {
					return true;
				}
				if(UniUtils.indexOf(e.field, ['INOUT_SEQ'])) {
					return false;
				}
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
					if(UniUtils.indexOf(e.field, ['ACCOUNT_YNC','ORDER_UNIT_Q','INOUT_SEQ', 'TRNS_RATE'//,'WH_CODE'
												 ,'WH_CELL_CODE'/*,'INOUT_I','INOUT_P'*/,'PRICE_YN','EXCHG_RATE_O','MONEY_UNIT'
												 //20180809 추가
												 ,'PACK_QTY'])){
						return true;
					}
					if(UniUtils.indexOf(e.field, ['ITEM_STATUS'])){
						if(BsaCodeInfo.gsProcessFlag == "PG"){
							return false;
						}else{
							return true;
						}
					}
					if(UniUtils.indexOf(e.field, ['LOT_NO','ORDER_UNIT_P','ORDER_UNIT_I','ORDER_UNIT_FOR_P'
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

				} else {
					if(UniUtils.indexOf(e.field, ['BL_NUM'])){
						if(e.record.data.ORDER_TYPE != '3'){
							return true;
						}else{
							return false;
						}
					}
					if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','INOUT_METH','WH_CODE'
												 ,'WH_CELL_CODE','ORDER_TYPE','INOUT_SEQ'
												 //20180809 추가
												 ,'PACK_QTY'])){
						if(e.record.phantom == true){
							return true;
						}
						return false;
					}
					if(UniUtils.indexOf(e.field, ['INOUT_P','ORDER_UNIT_Q','INOUT_I','ACCOUNT_YNC'
												 ,'PRICE_YN','MONEY_UNIT','EXCHG_RATE_O'])){
						return true;
					}
					if(UniUtils.indexOf(e.field, ['ITEM_STATUS'])){
						if(BsaCodeInfo.gsProcessFlag == "PG"){
							return false;
						}else{
							return true;
						}
					}
					if(UniUtils.indexOf(e.field, ['LOT_NO','ORDER_UNIT_P','ORDER_UNIT_I','ORDER_UNIT_FOR_P'
												 ,'ORDER_UNIT_FOR_O','ORDER_UNIT','REMARK','PROJECT_NO','TRANS_COST','TARIFF_AMT'])){
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
			render: function(grid, eOpts){
				var girdNm	= grid.getItemId();
				var store	= grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
					//store.onStoreActionEnable();
					if( store.isDirty() || detailStore.isDirty() ) {
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
				});
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

					grdRecord.set('ITEM_WIDTH'			, '');
					grdRecord.set('SQM'					, '');
					//20180807 추가 (PACK_QTY),
					grdRecord.set('PACK_QTY'			, '');

				} else {
					grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
					grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
					grdRecord.set('SPEC'				, record['SPEC']);
					grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
					grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
					grdRecord.set('TRNS_RATE'			, record['PUR_TRNS_RATE']);
					grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);

					grdRecord.set('LOT_YN'				, record['LOT_YN']);

					grdRecord.set('ITEM_WIDTH'		, record['ITEM_WIDTH']);
					var itemWidth = record['ITEM_WIDTH'];
					if(itemWidth == 0) {
						itemWidth = 1000;
					}
					//저장시에 그냥 저장하기 위해 ORDER_UNIT_Q = 1로 계산
					grdRecord.set('SQM'				, 1 * record['TRNS_RATE'] * itemWidth / 1000);

					//20180807 추가 (PACK_QTY),
					if(Ext.isEmpty(record['PACK_QTY']) || record['PACK_QTY'] == 0) {
						grdRecord.set('PACK_QTY', 1);
					} else {
						grdRecord.set('PACK_QTY', Unilite.nvl(record['PACK_QTY']));
					}

				var param = {
					"ITEM_CODE"		: record['ITEM_CODE'],
					"CUSTOM_CODE"	: panelResult.getValue('CUSTOM_CODE'),
					"DIV_CODE"		: panelResult.getValue('DIV_CODE'),
					"MONEY_UNIT"	: panelResult.getValue('MONEY_UNIT'),
					"ORDER_UNIT"	: record['ORDER_UNIT'],
					"INOUT_DATE"	: panelResult.getValue('INOUT_DATE')
				};
				s_mms510ukrv_jwService.fnOrderPrice(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						if(provider['SALES_TYPE'] && provider['SALES_TYPE'] != ''){
							grdRecord.set('SALES_TYPE'	, provider['SALES_TYPE']);
						}else{
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
		},
		setNoreceiveData:function(record){
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('INOUT_TYPE'			,'1');
			grdRecord.set('INOUT_METH'			,'1');
			grdRecord.set('INOUT_NUM'			, panelResult.getValue('INOUT_NUM'));
			grdRecord.set('INOUT_TYPE_DETAIL'	, gsInoutTypeDetail);//gsInoutTypeDetail ?확인필요
			grdRecord.set('INOUT_CODE_TYPE'		, '4');
			grdRecord.set('INOUT_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, panelResult.getValue('CUSTOM_NAME'));
			grdRecord.set('INOUT_DATE'			, panelResult.getValue('INOUT_DATE'));
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
//			if(record['EXCHG_RATE_O'] == '0' || record['EXCHG_RATE_O'] == '1'){
				grdRecord.set('EXCHG_RATE_O'	, panelResult.getValue('EXCHG_RATE_O'));
//			}else{
//				grdRecord.set('EXCHG_RATE_O'	, record['EXCHG_RATE_O']);
//			}
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('LC_NUM'				, record['LC_NUM']);
			grdRecord.set('BL_NUM'				, record['BL_NO']);
			grdRecord.set('WH_CODE'				, panelResult.getValue('WH_CODE'));
			grdRecord.set('WH_CELL_CODE'		, panelResult.getValue('WH_CELL_CODE'));
			grdRecord.set('INOUT_PRSN'			, panelResult.getValue('INOUT_PRSN'));
			grdRecord.set('COMPANY_NUM'			, BsaCodeInfo.gsCompanyNum);// gsCompanyNum 확인필요
			grdRecord.set('INSTOCK_Q'			, record['INSTOCK_Q']);
			grdRecord.set('PRICE_YN'			, record['UNIT_PRICE_TYPE']);
			grdRecord.set('BASIS_NUM'			, record['BASIS_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['BASIS_SEQ']);
			grdRecord.set('TRADE_LOC'			, record['TRADE_LOC']);
			grdRecord.set('GOOD_STOCK_Q'		, record['GOOD_STOCK_Q']);
			grdRecord.set('BAD_STOCK_Q'			, record['BAD_STOCK_Q']);
			grdRecord.set('ORIGINAL_Q'			, '0');
			if(panelResult.getValue('DIV_CODE') == ''){
				grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			}else{
				grdRecord.set('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
			}
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('EXCESS_RATE'			, record['EXCESS_RATE']);
			grdRecord.set('LOT_YN'				, record['LOT_YN']);
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');

			//20180807 추가 (PACK_QTY),
			grdRecord.set('PACK_QTY'			, Unilite.nvl(record['PACK_QTY'], 1));

			if(panelResult.getValue("CREATE_LOC") == "2"){
				grdRecord.set('CREATE_LOC'		, "2");
			}else{
				grdRecord.set('CREATE_LOC'		, "6");
			}
			//ITEM_WIDTH, SQM 관련 계산로직(20180726 추가)
			grdRecord.set('ITEM_WIDTH'		, record['ITEM_WIDTH']);
			var itemWidth = record['ITEM_WIDTH'];
			if(itemWidth == 0) {
				itemWidth = 1000;
			}
			grdRecord.set('SQM'					, record['REMAIN_Q'] * record['TRNS_RATE'] * itemWidth / 1000);
			grdRecord.set('ORDER_UNIT_FOR_O'	, record['ORDER_UNIT_P'] * grdRecord.get('SQM'));
			grdRecord.set('ORDER_UNIT_I'		, record['ORDER_LOC_P'] * grdRecord.get('SQM'));
			grdRecord.set('INOUT_I'				, record['ORDER_LOC_P'] * grdRecord.get('SQM'));
			grdRecord.set('INOUT_P'				, isNaN(grdRecord.get('INOUT_I')/ (grdRecord.get('INOUT_Q')))?0:grdRecord.get('INOUT_I')/ grdRecord.get('INOUT_Q'));
			grdRecord.set('INOUT_FOR_O'			, record['ORDER_UNIT_P'] * grdRecord.get('SQM'));
			grdRecord.set('INOUT_FOR_P'			, isNaN(grdRecord.get('INOUT_FOR_O') / (grdRecord.get('INOUT_Q')))?0:grdRecord.get('INOUT_FOR_O')/ grdRecord.get('INOUT_Q'));

			UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE'));
		},
		setReturnPossibleData:function(record){
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('INOUT_TYPE'			,'1');
			grdRecord.set('INOUT_METH'			,'1');
			grdRecord.set('INOUT_NUM'			, panelResult.getValue('INOUT_NUM'));
			grdRecord.set('INOUT_TYPE_DETAIL'	, gsInoutTypeDetail);//gsInoutTypeDetail ?확인필요
			grdRecord.set('INOUT_CODE_TYPE'		, '4');
			grdRecord.set('INOUT_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, panelResult.getValue('CUSTOM_NAME'));
			grdRecord.set('INOUT_DATE'			, panelResult.getValue('INOUT_DATE'));
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
			grdRecord.set('EXCHG_RATE_O'		, panelResult.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('LC_NUM'				, record['LC_NUM']);
			grdRecord.set('BL_NUM'				, record['BL_NO']);
			grdRecord.set('WH_CODE'				, panelResult.getValue('WH_CODE'));
			grdRecord.set('WH_CELL_CODE'		, panelResult.getValue('WH_CELL_CODE'));
			grdRecord.set('INOUT_PRSN'			, panelResult.getValue('INOUT_PRSN'));
			grdRecord.set('COMPANY_NUM'			, BsaCodeInfo.gsCompanyNum);// gsCompanyNum 확인필요
			grdRecord.set('INSTOCK_Q'			, record['INSTOCK_Q']);
			grdRecord.set('PRICE_YN'			, record['UNIT_PRICE_TYPE']);
			grdRecord.set('BASIS_NUM'			, record['BASIS_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['BASIS_SEQ']);
			grdRecord.set('TRADE_LOC'			, record['TRADE_LOC']);
			grdRecord.set('ORIGINAL_Q'			, '0');
			if(panelResult.getValue('DIV_CODE') == ''){
				grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			}else{
				grdRecord.set('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
			}
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('EXCESS_RATE'			, record['EXCESS_RATE']);
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');

			//20180807 추가 (PACK_QTY),
			grdRecord.set('PACK_QTY'			, Unilite.nvl(record['PACK_QTY'], 1));

			if(panelResult.getValue("CREATE_LOC") == "2"){
				grdRecord.set('CREATE_LOC'		, "2");
			}else{
				grdRecord.set('CREATE_LOC'		, "6");
			}

			//ITEM_WIDTH, SQM 관련 계산로직(20180726 추가)
			grdRecord.set('ITEM_WIDTH'		, record['ITEM_WIDTH']);
			var itemWidth = record['ITEM_WIDTH'];
			if(itemWidth == 0) {
				itemWidth = 1000;
			}
			grdRecord.set('SQM'					, record['REMAIN_Q'] * record['TRNS_RATE'] * itemWidth / 1000);
			grdRecord.set('ORDER_UNIT_FOR_O'	, record['ORDER_UNIT_P'] * grdRecord.get('SQM'));
			grdRecord.set('ORDER_UNIT_I'		, record['ORDER_LOC_P'] * grdRecord.get('SQM'));
			grdRecord.set('INOUT_I'				, record['ORDER_LOC_P'] * grdRecord.get('SQM'));
			grdRecord.set('INOUT_P'				, isNaN(grdRecord.get('INOUT_I')/ (grdRecord.get('INOUT_Q')))?0:grdRecord.get('INOUT_I')/ grdRecord.get('INOUT_Q'));
			grdRecord.set('INOUT_FOR_O'			, record['ORDER_UNIT_P'] * grdRecord.get('SQM'));
			grdRecord.set('INOUT_FOR_P'			, isNaN(grdRecord.get('INOUT_FOR_O') / (grdRecord.get('INOUT_Q')))?0:grdRecord.get('INOUT_FOR_O')/ grdRecord.get('INOUT_Q'));

			UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE'));

/*			//참조적용 시에는 masterGrid에만 데이터 보여 줌 - 주석
			directMasterStore1.commitChanges();
			for(j=0; j<record.ORDER_UNIT_Q; j++) {
				UniAppManager.app.onNewDataButtonDown2();
				detailGrid.setReturnPossibleData(record);
			}
*/
		},
		setInspectData:function(record){
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('INOUT_TYPE'			,'1');
			grdRecord.set('INOUT_METH'			,'1');
			grdRecord.set('INOUT_NUM'			, panelResult.getValue('INOUT_NUM'));
			grdRecord.set('INOUT_TYPE_DETAIL'	, gsInoutTypeDetail);//BsaCodeInfo.gsInoutTypeDetail);//gsInoutTypeDetail ?확인필요
			grdRecord.set('INOUT_CODE_TYPE'		, '4');
			grdRecord.set('INOUT_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, panelResult.getValue('CUSTOM_NAME'));
			grdRecord.set('INOUT_DATE'			, panelResult.getValue('INOUT_DATE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ITEM_STATUS'			, record['ITEM_STATUS']);
			grdRecord.set('ACCOUNT_Q'			, '0');
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			if(record['TRNS_RATE'] == '0'){
				grdRecord.set('TRNS_RATE'		, '1');
			}else{
				grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			}
			//grdRecord.set('ORDER_UNIT_Q'		, record['NOINOUT_Q']);
			grdRecord.set('ORDER_UNIT_Q'     , record['REMAIN_Q']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['ORDER_UNIT_P']);
			//grdRecord.set('ORDER_UNIT_FOR_O'	, record['ORDER_UNIT_P'] * record['NOINOUT_Q']);
			grdRecord.set('ORDER_UNIT_FOR_O' , record['ORDER_UNIT_P'] * record['REMAIN_Q']);
//			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_LOC_P']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_LOC_P']);	//자사단가

			grdRecord.set('ORDER_UNIT_I'		, record['ORDER_LOC_P'] * record['REMAIN_Q']);


			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('INOUT_Q'				, record['NOINOUT_Q']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('NOINOUT_Q'			, record['NOINOUT_Q']);
			grdRecord.set('ACCOUNT_YNC'			, 'Y');
			grdRecord.set('INOUT_I'             , (record['ORDER_LOC_P'] * record['REMAIN_Q'])); // 자사단가(ORDER_UNIT_P)
			grdRecord.set('INOUT_P'             , isNaN(grdRecord.get('INOUT_I')/ grdRecord.get('INOUT_Q'))?0:grdRecord.get('INOUT_I')/ grdRecord.get('INOUT_Q'));
//			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);

			grdRecord.set('INOUT_FOR_O'			, record['ORDER_UNIT_P'] * record['REMAIN_Q']);
			grdRecord.set('INOUT_FOR_P'			, isNaN(grdRecord.get('INOUT_FOR_O') / grdRecord.get('INOUT_Q'))?0:grdRecord.get('INOUT_FOR_O')/ grdRecord.get('INOUT_Q'));
//			if(record['EXCHG_RATE_O'] == 0 || record['EXCHG_RATE_O'] == 1){
				grdRecord.set('EXCHG_RATE_O'	, panelResult.getValue('EXCHG_RATE_O'));
//			}else{
//				grdRecord.set('EXCHG_RATE_O'	, record['EXCHG_RATE_O']);
//			}
//			grdRecord.set('INOUT_I'			 , record['ORDER_UNIT_P']);	//자사단가


			//20180807 추가 (PACK_QTY),
			grdRecord.set('PACK_QTY'			, Unilite.nvl(record['PACK_QTY'], 1));





			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('LC_NUM'				, record['LC_NO']);
			grdRecord.set('BL_NUM'				, record['BL_NO']);
			grdRecord.set('WH_CODE'				, panelResult.getValue('WH_CODE'));
			grdRecord.set('WH_CELL_CODE'		, panelResult.getValue('WH_CELL_CODE'));
			grdRecord.set('INOUT_PRSN'			, panelResult.getValue('INOUT_PRSN'));
			grdRecord.set('COMPANY_NUM'			, BsaCodeInfo.gsCompanyNum);// gsCompanyNum 확인필요
			grdRecord.set('INSTOCK_Q'			, record['INSTOCK_Q']);
			grdRecord.set('PRICE_YN'			, record['UNIT_PRICE_TYPE']);
			grdRecord.set('BASIS_NUM'			, record['BASIS_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['BASIS_SEQ']);
			grdRecord.set('TRADE_LOC'			, record['TRADE_LOC']);
			grdRecord.set('GOOD_STOCK_Q'		, record['GOOD_STOCK_Q']);
			grdRecord.set('BAD_STOCK_Q'			, record['BAD_STOCK_Q']);
			grdRecord.set('ORIGINAL_Q'			, '0');
			if(panelResult.getValue('DIV_CODE') == ''){
				grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			}else{
				grdRecord.set('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
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
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('LOT_YN'				, record['LOT_YN']);

			grdRecord.set('ITEM_WIDTH'		, record['ITEM_WIDTH']);
			var itemWidth = record['ITEM_WIDTH'];
			if(itemWidth == 0) {
				itemWidth = 1000;
			}
			//저장시에 그냥 저장하기 위해 ORDER_UNIT_Q = 1로 계산
			//grdRecord.set('SQM'				, 1 * record['TRNS_RATE'] * itemWidth / 1000);
			grdRecord.set('SQM'                  , record['REMAIN_Q'] * record['TRNS_RATE'] * itemWidth / 1000);
			grdRecord.set('ORDER_UNIT_FOR_O' , record['ORDER_UNIT_P'] * grdRecord.get('SQM'));
            grdRecord.set('ORDER_UNIT_I'        , record['ORDER_LOC_P'] * grdRecord.get('SQM'));
            grdRecord.set('INOUT_I'             , record['ORDER_LOC_P'] * grdRecord.get('SQM'));
            grdRecord.set('INOUT_P'             , isNaN(grdRecord.get('INOUT_I')/ (grdRecord.get('INOUT_Q')))?0:grdRecord.get('INOUT_I')/ grdRecord.get('INOUT_Q'));
            grdRecord.set('INOUT_FOR_O'         , record['ORDER_UNIT_P'] * grdRecord.get('SQM'));
            grdRecord.set('INOUT_FOR_P'         , isNaN(grdRecord.get('INOUT_FOR_O') / (grdRecord.get('INOUT_Q')))?0:grdRecord.get('INOUT_FOR_O')/ grdRecord.get('INOUT_Q'));

            UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE'));


			//ORDER_UNIT_P

//			grdRecord.set('PURCHASE_RATE'		, record['PURCHASE_RATE']);
			panelResult.setValue('CUSTOM_CODE'	, record['CUSTOM_CODE']);
			panelResult.setValue('CUSTOM_NAME'	, record['CUSTOM_NAME']);
			panelResult.setValue('CUSTOM_CODE'	, record['CUSTOM_CODE']);
			panelResult.setValue('CUSTOM_NAME'	, record['CUSTOM_NAME']);

			var param = {
				"COMP_CODE": UserInfo.compCode,
				"ITEM_CODE": record['ITEM_CODE']
			};

			s_mms510ukrv_jwService.taxType(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
				grdRecord.set('TAX_TYPE', provider['TAX_TYPE']);
				}
			});

			directMasterStore1.fnSumAmountI();
		}
	});//End of var masterGrid = Unilite.createGrid('s_mms510ukrv_jwGrid1', {

	var detailGrid = Unilite.createGrid('s_mms510ukrv_jwdetailGrid', {
		excelTitle	: '<t:message code="system.label.purchase.receiptentry" default="입고등록"/>',
		store		: detailStore,
		layout		: 'fit',
		region		: 'south',
		split		: true,
		flex		: 1.2,
		uniOpt		: {
			onLoadSelectFirst	: false,
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if (this.selected.getCount() > 0) {
						Ext.getCmp('btnPrint').enable();
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var toDelete = detailStore.getRemovedRecords();
					if (/*toDelete.length == 0 && */this.selected.getCount() == 0) {
						Ext.getCmp('btnPrint').disable();
					}
				}
			}
		}),
		columns: [
			{dataIndex: 'INOUT_SEQ'				, width:57 , align:'center'},
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width:100	,hidden: true, align:'center'},
			{dataIndex: 'WH_CODE'				, width:80	,hidden: true},
			{dataIndex: 'WH_CELL_CODE'			, width:100	,hidden: true},
			{dataIndex: 'ITEM_CODE'				, width:130 ,
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
							popup.setExtParam({'SELMODEL'	: 'MULTI'});
							popup.setExtParam({'POPUP_TYPE'	: 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE'	: Ext.getCmp("resultForm").getValue("DIV_CODE")});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'				, width: 180,
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
							popup.setExtParam({'SELMODEL'	: 'MULTI'});
							popup.setExtParam({'POPUP_TYPE'	: 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE'	: Ext.getCmp("resultForm").getValue("DIV_CODE")});
						}
					}
				})
			},
			{dataIndex: 'SPEC'					, width:150 },

			/*{dataIndex: 'LOT_NO'				, width:120 ,hidden: sumtypeLot,
				getEditor: function(record) {
					return getLotPopupEditor(sumtypeLot);
				}*/
			{dataIndex: 'ORDER_UNIT'			, width:80	,align: 'center'},
			{dataIndex: 'ORDER_UNIT_Q'			, width:100 ,summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT_P'			, width:100	,hidden: true},
			{dataIndex: 'ORDER_UNIT_I'			, width:100	,hidden: true,summaryType: 'sum'},
			{dataIndex: 'LOT_NO'				, width:120 },
			{dataIndex: 'LOT_YN'				, width:120, hidden: true },
			{dataIndex: 'TRNS_RATE'				, width:66	,maxLength:12},
			{dataIndex: 'STOCK_UNIT'			, width:88	,align: 'center'},

			//20180725 추가 (ITEM_WIDTH, SQM)
			{dataIndex: 'ITEM_WIDTH'			, width:88	,align: 'center'},
			{dataIndex: 'SQM'					, width:88	,align: 'center'},

			{dataIndex: 'ORDER_UNIT_FOR_P'		, width:100	,hidden: false},
			{dataIndex: 'ORDER_UNIT_FOR_O'		, width:100	,hidden: false,summaryType: 'sum'},

			//20181121 추가 (제조일: MAKE_DATE, 제조LOT: MAKE_LOT_NO)
			{dataIndex: 'MAKE_DATE'				, width:100	,hidden: true},
			{dataIndex: 'MAKE_LOT_NO'			, width:120	,hidden: true},

			{dataIndex: 'INOUT_Q'				, width:100	,hidden: true,summaryType: 'sum'},
			{dataIndex: 'PRICE_YN'				, width:100	,hidden: true},
			{dataIndex: 'MONEY_UNIT'			, width:88	,align: 'center', hidden: true},
			{dataIndex: 'EXCHG_RATE_O'			, width:88	,hidden: true},
			{dataIndex: 'INOUT_P'				, width:115	,hidden: true},
			{dataIndex: 'INOUT_I'				, width:100	,hidden: true,summaryType: 'sum' },
			{dataIndex: 'TRANS_COST'			, width:88	,hidden: true},
			{dataIndex: 'TARIFF_AMT'			, width:88	,hidden: true},
			{dataIndex: 'ACCOUNT_YNC'			, width:88	,hidden: true},
			{dataIndex: 'ORDER_TYPE'			, width:88	,hidden: true},
			{dataIndex: 'BL_NUM'				, width:88	,hidden: true,maxLength:20},
			{dataIndex: 'ORDER_NUM' 			, width:120	,hidden: true},
			{dataIndex: 'ORDER_SEQ'				, width:57	,hidden: true,align: 'center'},
			{dataIndex: 'ITEM_STATUS'			, width:80	,hidden: true},
			{dataIndex: 'REMARK'				, width:188	,hidden: true,maxLength:200},
			{dataIndex: 'PROJECT_NO'			, width:120	,hidden: true,
				getEditor : function(record){
					return getPjtNoPopupEditor();
				}
			},
			{dataIndex: 'TRADE_LOC' 			, width:88	,hidden: true},

			{dataIndex: 'INOUT_NUM'				, width:110	,hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'		, width:80	,hidden: true},
			{dataIndex: 'LC_NUM'				, width:100	,hidden: true},
			{dataIndex: 'INOUT_PRSN'			, width:100	,hidden: true},
			{dataIndex: 'ACCOUNT_Q'				, width:80	,hidden: true},
			{dataIndex: 'CREATE_LOC'			, width:80	,hidden: true},
			{dataIndex: 'SALE_C_DATE'			, width:100	,hidden: true},
			{dataIndex: 'ITEM_ACCOUNT'			, width:100	,hidden: true},
			{dataIndex: 'INOUT_TYPE'			, width:100	,hidden: true},
			{dataIndex: 'INOUT_CODE'			, width:100	,hidden: true},
			{dataIndex: 'DIV_CODE'				, width:80	,hidden: true},
			{dataIndex: 'CUSTOM_NAME'			, width:80	,hidden: true},
			{dataIndex: 'INOUT_DATE'			, width:100	,hidden: true},
			{dataIndex: 'END_DATE'				, width:100	,hidden: true},		//라벨출력시 사용
			{dataIndex: 'QTY_FORMAT'			, width:100	,hidden: true},		//라벨출력시 사용
			{dataIndex: 'INOUT_METH'		 	, width:80	,hidden: true},
			{dataIndex: 'ORDER_Q'				, width:80	,hidden: true},
			{dataIndex: 'GOOD_STOCK_Q'			, width:100	,hidden: true},
			{dataIndex: 'BAD_STOCK_Q'			, width:100	,hidden: true},
			{dataIndex: 'ORIGINAL_Q'		 	, width:100	,hidden: true},
			{dataIndex: 'NOINOUT_Q'				, width:80	,hidden: true},
			{dataIndex: 'COMPANY_NUM'			, width:80	,hidden: true},
			{dataIndex: 'INSPEC_NUM' 			, width:88	,hidden: true},
			{dataIndex: 'INSPEC_SEQ' 			, width:88	,hidden: true},
			{dataIndex: 'INOUT_FOR_P' 			, width:80	,hidden: true},
			{dataIndex: 'INOUT_FOR_O' 			, width:80	,hidden: true},
			{dataIndex: 'INSTOCK_Q'				, width:80	,hidden: true},
			{dataIndex: 'SALE_DIV_CODE'			, width:80	,hidden: true},
			{dataIndex: 'SALE_CUSTOM_CODE' 		, width:80	,hidden: true},
			{dataIndex: 'BILL_TYPE'				, width:80	,hidden: true},
			{dataIndex: 'SALE_TYPE'				, width:80	,hidden: true},
			{dataIndex: 'EXCESS_RATE'			, width:80	,hidden: true},
			{dataIndex: 'BASIS_NUM'				, width:80	,hidden: true},
			{dataIndex: 'BASIS_SEQ'				, width:80	,hidden: true},
			{dataIndex: 'SCM_FLAG_YN'			, width:80	,hidden: true},
			{dataIndex: 'STOCK_CARE_YN' 		, width:88	,hidden: true},
			{dataIndex: 'COMP_CODE'				, width:80	,hidden: true},
			{dataIndex: 'FLAG'					, width:80	,hidden: true},
			{dataIndex: 'ITEM_LEVEL1'           , width:80  ,hidden: true}
		],
		listeners: {
			beforeedit	: function( editor, e, eOpts ) {
				//20181121 추가 (제조일: MAKE_DATE, 제조LOT: MAKE_LOT_NO)
				if(UniUtils.indexOf(e.field, ['MAKE_DATE', 'MAKE_LOT_NO'])) {
					return true;
				}
				if(UniUtils.indexOf(e.field, ['INOUT_SEQ'])) {
					return false;
				}
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
					if(UniUtils.indexOf(e.field, ['ACCOUNT_YNC','ORDER_UNIT_Q','INOUT_SEQ'
												 ,'WH_CELL_CODE','INOUT_I','INOUT_P','PRICE_YN','EXCHG_RATE_O','MONEY_UNIT'])){
						return true;
					}
					if(UniUtils.indexOf(e.field, ['ITEM_STATUS'])){
						if(BsaCodeInfo.gsProcessFlag == "PG"){
							return false;
						}else{
							return true;
						}
					}
					if(UniUtils.indexOf(e.field, ['LOT_NO','ORDER_UNIT_P','ORDER_UNIT_I','ORDER_UNIT_FOR_P', 'TRNS_RATE'
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

				} else {
					if(UniUtils.indexOf(e.field, ['BL_NUM'])){
						if(e.record.data.ORDER_TYPE != '3'){
							return true;
						}else{
							return false;
						}
					}
					if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','INOUT_METH','WH_CODE'
												 ,'WH_CELL_CODE','ORDER_TYPE','INOUT_SEQ'])){
						if(e.record.phantom == true){
							return true;
						}
						return false;
					}
					if(UniUtils.indexOf(e.field, ['INOUT_P','ORDER_UNIT_Q','INOUT_I','ACCOUNT_YNC', 'TRNS_RATE'
												 ,'PRICE_YN','MONEY_UNIT','EXCHG_RATE_O'])){
						return true;
					}
					if(UniUtils.indexOf(e.field, ['ITEM_STATUS'])){
						if(BsaCodeInfo.gsProcessFlag == "PG"){
							return false;
						}else{
							return true;
						}
					}
					if(UniUtils.indexOf(e.field, ['LOT_NO','ORDER_UNIT_P','ORDER_UNIT_I','ORDER_UNIT_FOR_P'
												 ,'ORDER_UNIT_FOR_O','ORDER_UNIT','REMARK','PROJECT_NO','TRANS_COST','TARIFF_AMT'])){
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
			render: function(grid, eOpts){
				var girdNm	= grid.getItemId();
				var store	= grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;

					//store.onStoreActionEnable();
					if( detailStore.isDirty() ) {
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

				} else {
					grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
					grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
					grdRecord.set('SPEC'				, record['SPEC']);
					grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
					grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
					grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
					grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);

					grdRecord.set('LOT_YN'				, record['LOT_YN']);

				var param = {
					"ITEM_CODE"		: record['ITEM_CODE'],
					"CUSTOM_CODE"	: panelResult.getValue('CUSTOM_CODE'),
					"DIV_CODE"		: panelResult.getValue('DIV_CODE'),
					"MONEY_UNIT"	: panelResult.getValue('MONEY_UNIT'),
					"ORDER_UNIT"	: record['ORDER_UNIT'],
					"INOUT_DATE"	: panelResult.getValue('INOUT_DATE')
				};
				s_mms510ukrv_jwService.fnOrderPrice(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
//						if(provider['PURCHASE_TYPE'] && provider['PURCHASE_TYPE'] != ''){
//							grdRecord.set('PURCHASE_RATE'	, provider['PURCHASE_RATE']);
//						}else{
//							grdRecord.set('PURCHASE_RATE'	, '0');
//						}
						if(provider['SALES_TYPE'] && provider['SALES_TYPE'] != ''){
							grdRecord.set('SALES_TYPE'	, provider['SALES_TYPE']);
						}else{
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
	});//End of var masterGrid = Unilite.createGrid('s_mms510ukrv_jwGrid1', {

	var inoutNoMasterGrid = Unilite.createGrid('s_mms510ukrv_jwinoutNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
		layout : 'fit',
		excelTitle: '<t:message code="system.label.purchase.receiptentry" default="입고등록"/>' + '(' + '<t:message code="system.label.purchase.receiptnosearch2" default="입고번호검색"/>' + ')',
		store: inoutNoMasterStore,
		uniOpt:{
			expandLastColumn	: false,
			useRowNumberer		: false
		},
		columns:	[
			{ dataIndex: 'INOUT_NAME'			,	width:166},
			{ dataIndex: 'INOUT_DATE'		,	width:86},
			{ dataIndex: 'INOUT_CODE'		,	width:120,hidden:true},
			{ dataIndex: 'WH_CODE'			,	width:100},
			{ dataIndex: 'WH_CELL_CODE'		,	width:120,hidden:!sumtypeCell},
			{ dataIndex: 'DIV_CODE'			,	width:100},
			{ dataIndex: 'INOUT_PRSN' 		,	width:100, align: 'center'},
			{ dataIndex: 'INOUT_NUM'		,	width:126, align: 'center'},
			{ dataIndex: 'MONEY_UNIT'		,	width:53, align: 'center',hidden:true},
			{ dataIndex: 'EXCHG_RATE_O'		,	width:53,hidden:true},
			{ dataIndex: 'CREATE_LOC'		,	width:53,hidden:true},
			{ dataIndex: 'PERSON_NAME'		,	width:53,hidden:true}

		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				inoutNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
				panelResult.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
				 // 	directMasterStore1.fnSumAmountI();
			}
		},
		returnData: function(record)	{
				if(Ext.isEmpty(record))	{
					record = this.getSelectedRecord();
				}
				panelResult.setValues({
					'DIV_CODE':record.get('DIV_CODE'),
					'INOUT_DATE':record.get('INOUT_DATE'),
					'INOUT_NUM':record.get('INOUT_NUM'),
					'WH_CODE':record.get('WH_CODE'),
					'CUSTOM_CODE':record.get('INOUT_CODE'),
					'CUSTOM_NAME':record.get('INOUT_NAME'),
					'EXCHG_RATE_O':record.get('EXCHG_RATE_O'),
					'MONEY_UNIT':record.get('MONEY_UNIT'),
					'INOUT_PRSN':record.get('INOUT_PRSN'),
					'CREATE_LOC':record.get('CREATE_LOC'),
					'PERSON_NAME':record.get('PERSON_NAME')
				});
				if(BsaCodeInfo.gsSumTypeCell!='Y'){
					panelResult.setValue('WH_CELL_CODE', record.get('WH_CELL_CODE'));
				}
			}
	});

	var noreceiveGrid = Unilite.createGrid('s_mms510ukrv_jwNoreceiveGrid', {				//미입고참조
		layout : 'fit',
		excelTitle: '<t:message code="system.label.purchase.receiptentry" default="입고등록"/>' + '(' + '<t:message code="system.label.purchase.unreceiptreference" default="미입고참조"/>' + ')',
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
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns:	[
			{ dataIndex: 'GUBUN'				, width:33,locked:true,hidden:true},
			{ dataIndex: 'ITEM_CODE'			, width:120,locked:true},
			{ dataIndex: 'ITEM_NAME'			, width:150,locked:true},
			{ dataIndex: 'ITEM_ACCOUNT'			, width:120,hidden:true},
			{ dataIndex: 'SPEC'					, width:150},
			{ dataIndex: 'DVRY_DATE'			, width:86},
			{ dataIndex: 'DIV_CODE'				, width:80,hidden:true},
			{ dataIndex: 'ORDER_UNIT'			, width:66,align:"center"},
			{ dataIndex: 'ORDER_UNIT_Q'			, width:100,hidden:true},
			{ dataIndex: 'REMAIN_Q'				, width:100,summaryType: 'sum'},
			{ dataIndex: 'STOCK_UNIT'			, width:53,hidden:true,align:"center"},
			{ dataIndex: 'NOINOUT_Q'			, width:100,hidden:true},
			{ dataIndex: 'ORDER_Q'				, width:100,hidden:true},
			{ dataIndex: 'UNIT_PRICE_TYPE'		, width:100},
			{ dataIndex: 'MONEY_UNIT'			, width:66,align:"center"},
			{ dataIndex: 'EXCHG_RATE_O'			, width:90},
			{ dataIndex: 'ORDER_P'				, width:93,hidden:true},
			{ dataIndex: 'ORDER_UNIT_P'			, width:100},
			{ dataIndex: 'ORDER_O'				, width:100,summaryType: 'sum'},
			//20190313 추가
			{ dataIndex: 'USAGE_PLACE'			, width: 93},

			{ dataIndex: 'ORDER_LOC_P'			, width:100},
			{ dataIndex: 'ORDER_LOC_O'			, width:100,summaryType: 'sum'},
			{ dataIndex: 'ORDER_NUM'			, width:120},
			{ dataIndex: 'ORDER_SEQ'			, width:66,align:"center"},
			{ dataIndex: 'LC_NUM'				, width:33,hidden:true},
			{ dataIndex: 'WH_CODE'				, width:33,hidden:true},
			{ dataIndex: 'ORDER_REQ_NUM'		, width:33,hidden:true},
			{ dataIndex: 'ORDER_TYPE'			, width:33,hidden:true},
			{ dataIndex: 'CUSTOM_CODE'			, width:60,hidden:true},
			{ dataIndex: 'TRNS_RATE'			, width:80,hidden:true},
			{ dataIndex: 'INSTOCK_Q'			, width:80,hidden:true},
			{ dataIndex: 'REMARK'				, width:150},
			{ dataIndex: 'PROJECT_NO'			, width:120},
			{ dataIndex: 'EXCESS_RATE'			, width:80,hidden:true},
			{ dataIndex: 'ORDER_PRSN'			, width:100},
			{ dataIndex: 'GOOD_STOCK_Q'			, width:66,hidden:true},
			{ dataIndex: 'BAD_STOCK_Q'			, width:66,hidden:true},
			{ dataIndex: 'LC_NO'				, width:66,hidden:true},
			{ dataIndex: 'BL_NO'				, width:66,hidden:true},
			{ dataIndex: 'BASIS_NUM'			, width:66,hidden:true},
			{ dataIndex: 'BASIS_SEQ'			, width:53,hidden:true},
			{ dataIndex: 'LC_DATE'				, width:66,hidden:true},
			{ dataIndex: 'INVOICE_DATE'			, width:66,hidden:true},
			{ dataIndex: 'TRADE_LOC'			, width:53,hidden:true},
			{ dataIndex: 'LOT_NO'				, width:53},
			{ dataIndex: 'LOT_YN'				, width:53,hidden: true},
			//20180807 추가 (PACK_QTY),
			{ dataIndex: 'PACK_QTY'				, width:88	,align: 'center'	,hidden: true}
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

	var inspectresultGrid2 = Unilite.createGrid('s_mms510ukrv_jwInspectResultGrid2', {		//검사결과참조
		region: 'east' ,
		layout : 'fit',
		excelTitle: '<t:message code="system.label.purchase.receiptentry" default="입고등록"/>' + '(' + '<t:message code="system.label.sales.inspecresultrefer" default="검사결과참조"/>' + ')',
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
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns:	[
			{dataIndex: 'GUBUN'						, width:80,hidden:true},
			{dataIndex: 'ITEM_CODE'					, width:120,hidden:false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.subtotal" default="소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
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
			{dataIndex: 'LOT_NO'					, width:100,hidden:false},
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
			{dataIndex: 'EXCESS_RATE'				, width:100,hidden:true},
			//20180807 추가 (PACK_QTY),
			{dataIndex: 'PACK_QTY'				, width:88	,align: 'center'	,hidden: false}
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
				title: '<t:message code="system.label.purchase.receiptnosearch2" default="입고번호검색"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'}, //위치 확인 필요
				items: [inoutNoSearch, inoutNoMasterGrid],
				tbar:	['->',
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
					},
					 beforeclose: function( panel, eOpts )	{
						inoutNoSearch.clearForm();
						inoutNoMasterGrid.reset();
		 			},
					show: function( panel, eOpts )	{
						inoutNoSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
				 		inoutNoSearch.setValue('INOUT_DATE_FR',UniDate.get('startOfMonth'));
				 		inoutNoSearch.setValue('INOUT_DATE_TO',UniDate.get('today'));
				 		inoutNoSearch.setValue('WH_CODE',panelResult.getValue('WH_CODE'));
				 		inoutNoSearch.setValue('INOUT_CODE',panelResult.getValue('CUSTOM_CODE'));
				 		inoutNoSearch.setValue('INOUT_NAME',panelResult.getValue('CUSTOM_NAME'));
				 		inoutNoSearch.setValue('INOUT_PRSN',panelResult.getValue('INOUT_PRSN'));
					 }
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}

	function openNoReceiveWindow() {			//미입고참조
			if(!UniAppManager.app.checkForNewDetail()) return false;

//			noreceiveSearch.setValue('FR_ESTI_DATE', UniDate.get('startOfMonth'));
//			noreceiveSearch.setValue('TO_ESTI_DATE', UniDate.get('today'));
			noreceiveSearch.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));

		if(!referNoReceiveWindow) {
			referNoReceiveWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.unreceiptreference" default="미입고참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [noreceiveSearch, noreceiveGrid],
				tbar:	['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							noReceiveStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'confirmBtn',
						text: '<t:message code="system.label.purchase.receiptapply2" default="입고적용"/>',
						handler: function() {
							noreceiveGrid.returnData();
						},
						disabled: false
					},
					{
						itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.purchase.receiptapplyclose" default="입고적용후 닫기"/>',
						handler: function() {
							noreceiveGrid.returnData();
							referNoReceiveWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							if(directMasterStore1.getCount() == 0){
								panelResult.setAllFieldsReadOnly(false);
								panelResult.setAllFieldsReadOnly(false);
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
						noReceiveStore.clearData();
					},
					beforeclose: function( panel, eOpts )	{
						noreceiveSearch.clearForm();
						noreceiveGrid.reset();
						noReceiveStore.clearData();
		 			},
					beforeshow: function ( me, eOpts ){
						noreceiveSearch.setValue('FR_ESTI_DATE',UniDate.get('startOfMonth'));
	 					noreceiveSearch.setValue('TO_ESTI_DATE',UniDate.get('today'));
						noreceiveSearch.setValue('ORDER_TYPE', '1');
					 	noreceiveSearch.setValue('MONEY_UNIT',panelResult.getValue('MONEY_UNIT'));
					 	noreceiveSearch.setValue('WH_CODE',panelResult.getValue('WH_CODE'));
					 	noreceiveSearch.setValue('INOUT_PRSN',panelResult.getValue('INOUT_PRSN'));
					 	noreceiveSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
					 	noreceiveSearch.setValue('CREATE_LOC',panelResult.getValue('CREATE_LOC'));
					 	noreceiveSearch.setValue('CUSTOM_CODE',panelResult.getValue('CUSTOM_CODE'));
					 	noreceiveSearch.setValue('CUSTOM_NAME',panelResult.getValue('CUSTOM_NAME'));
					 	noReceiveStore.loadStoreRecords();
					}
				}
			})
		}
		referNoReceiveWindow.center();
		referNoReceiveWindow.show();
	}

	function openInspectResultWindow() {		//검사결과참조(무검사겸용)
			if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!referInspectResultWindow) {
			referInspectResultWindow = Ext.create('widget.uniDetailWindow', {
				title: windowFlag == 'inspectResult' ?	'<t:message code="system.label.sales.inspecresultrefer" default="검사결과참조"/>' : '<t:message code="system.label.purchase.noinspecreference" default="무검사참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [inspectresultSearch,inspectresultGrid2],
				tbar:	['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							inspectResultStore2.loadStoreRecords();
						},
						disabled: false
					}
					,{
						itemId : 'confirmBtn',
						text: '<t:message code="system.label.purchase.receiptapply2" default="입고적용"/>',
						handler: function() {
							inspectresultGrid2.returnData();
						},
						disabled: false
					},
					{
						itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.purchase.receiptapplyclose" default="입고적용후 닫기"/>',
						handler: function() {
							inspectresultGrid2.returnData();
							referInspectResultWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							if(directMasterStore1.getCount() == 0){
								panelResult.setAllFieldsReadOnly(false);
								panelResult.setAllFieldsReadOnly(false);
							}
							referInspectResultWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						inspectresultSearch.clearForm();
						inspectresultGrid2.reset();
						inspectResultStore2.clearData();
					},
					beforeclose: function( panel, eOpts )	{
						inspectresultSearch.clearForm();
						inspectresultGrid2.reset();
						inspectResultStore2.clearData();
						windowFlag = '';
		 			},
					beforeshow: function ( me, eOpts )	{
					 	inspectresultSearch.setValue('FR_DVRY_DATE',UniDate.get('startOfMonth'));
	 					inspectresultSearch.setValue('TO_DVRY_DATE',UniDate.get('today'));
					 	inspectresultSearch.setValue('CREATE_LOC',panelResult.getValue('CREATE_LOC'));
					 	inspectresultSearch.setValue('MONEY_UNIT',panelResult.getValue('MONEY_UNIT'));
					 	inspectResultStore2.loadStoreRecords();
					}
				}
			})
		}
		referInspectResultWindow.center();
		referInspectResultWindow.show();
	}



	Unilite.Main({
		id: 's_mms510ukrv_jwApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			id:'pageAll',
			items:[
				panelResult, masterGrid, detailGrid
			]
		}],
		fnInitBinding: function(){
			setup_web_print();
			UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);
			this.setDefault();
//			cbStore.loadStoreRecords();
		},
		onQueryButtonDown: function() {
			panelResult.setAllFieldsReadOnly(false);
			Ext.getCmp('btnPrint').disable();

			var inoutNo = panelResult.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow()
			} else {
				directMasterStore1.loadStoreRecords();
				detailStore.loadStoreRecords();
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				 var accountYnc		= 'Y';
				 var inoutNum		= panelResult.getValue('INOUT_NUM');
				 seq = gsMaxInoutSeq;
				 if(!seq) seq = 1;
				 else seq += 1;
				 var inoutType		= '1';
				 var inoutCodeType	= '4';
				 var whCode			= panelResult.getValue('WH_CODE');
				 var whCellCode		= panelResult.getValue('WH_CELL_CODE');
				 var inoutPrsn		= panelResult.getValue('INOUT_PRSN');
				 var inoutCode		= panelResult.getValue('CUSTOM_CODE');
				 var customName		= panelResult.getValue('CUSTOM_NAME');
				 var createLoc		= panelResult.getValue('CREATE_LOC');
				 var inoutDate		= panelResult.getValue('INOUT_DATE');
				 var inoutMeth		= '2';
				 var inoutTypeDetail = BsaCodeInfo.gsInoutTypeDetail; //gsInoutTypeDetail ?? 확인필요
				 var itemStatus		= '1';
				 var accountQ		= '0';
				 var orderUnitQ		= '0';
				 var inoutQ			= '0';
				 var inoutI			= '0';
				 var moneyUnit		= panelResult.getValue('MONEY_UNIT');
				 var inoutP			= '0';
				 var inoutForP		= '0';
				 var inoutForO		= '0';
				 var originalQ		= '0';
				 var noinoutQ		= '0';
				 var goodStockQ		= '0';
				 var badStockQ		= '0';
				 var exchgRateO		= panelResult.getValue('EXCHG_RATE_O');
				 var trnsRate		= '1';
				 var divCode		 = panelResult.getValue('DIV_CODE');
				 var companyNum		= BsaCodeInfo.gsCompanyNum; // ??확인필요
				 var saleDivCode	 = '*';
				 var saleCustomCode	= '*';
				 var saleType		= '*';
				 var billType		= '*';
				 var priceYn		 = 'Y';
				 var excessRate		= '0';
				 var orderType		= '1';
				 var transCost		= '0';
				 var tariffAmt		= '0';
				 var deptCode		= panelResult.getValue('DEPT_CODE');

				 var r = {
					ACCOUNT_YNC:		accountYnc,
					INOUT_TYPE:		 inoutType,
					INOUT_CODE_TYPE:	inoutCodeType,
					WH_CODE:			whCode,
					WH_CELL_CODE:		whCellCode,
					INOUT_PRSN:		 inoutPrsn,
					INOUT_CODE:		 inoutCode,
					CUSTOM_NAME:		customName,
					CREATE_LOC:		 createLoc,
					INOUT_DATE:		 inoutDate,
					INOUT_METH:		 inoutMeth,
					INOUT_TYPE_DETAIL:	inoutTypeDetail,
					ITEM_STATUS:		itemStatus,
					ACCOUNT_Q:			accountQ,
					ORDER_UNIT_Q:		orderUnitQ,
					INOUT_Q:			inoutQ,
					INOUT_I:			inoutI,
					MONEY_UNIT:		 moneyUnit,
					INOUT_P:			inoutP,
					INOUT_FOR_P:		inoutForP,
					INOUT_FOR_O:		inoutForO,
					ORIGINAL_Q:		 originalQ,
					NOINOUT_Q:			noinoutQ,
					GOOD_STOCK_Q:		goodStockQ,
					BAD_STOCK_Q:		badStockQ,
					EXCHG_RATE_O:		exchgRateO,
					TRNS_RATE:			trnsRate,
					DIV_CODE:			divCode,
					COMPANY_NUM:		companyNum,
					SALE_DIV_CODE:		saleDivCode,
					SALE_CUSTOM_CODE:	saleCustomCode,
					SALE_TYPE:			saleType,
					BILL_TYPE:			billType,
					PRICE_YN:			priceYn,
					EXCESS_RATE:		excessRate,
					ORDER_TYPE:		 orderType,
					TRANS_COST:		 transCost,
					TARIFF_AMT:		 tariffAmt,
					INOUT_NUM:			inoutNum,
					INOUT_SEQ:			seq,
					DEPT_CODE:			deptCode,
					SALES_TYPE:		 0
//					PURCHASE_TYPE:		0,
//					PURCHASE_RATE:		0
				}

//				cbStore.loadStoreRecords(whCode);
				masterGrid.createRow(r);
		},
		onResetButtonDown: function() {
			gsMaxInoutSeq = 0;
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			directMasterStore1.clearData();
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			var detailCount	= detailStore.count();
			//masterGird 행 추가 되었을 때, 저장로직 활성화를 위한 변수 선언
			var toCreate	= directMasterStore1.getNewRecords();

//			if ((config != 'deleteAll' && detailCount == 0) || (toCreate.length > 0)) {
			if (directMasterStore1.isDirty()) {
				directMasterStore1.saveStore();
			} else {
				detailStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)) {
				if(selRow.phantom === true) {
					detailGrid.deleteSelectedRow();

				}else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					if(selRow.get('ACCOUNT_Q') != 0){
						alert('<t:message code="system.message.purchase.message042" default="매입등록된 자료는 삭제, 수정할 수 없습니다."/>');
					}else{
						detailGrid.deleteSelectedRow();
					}
				}
			} else {
				var selRow2 = masterGrid.getSelectedRecord();
				if(!Ext.isEmpty(selRow2)) {
					if(selRow2.phantom === true) {
						masterGrid.deleteSelectedRow();
					}
				}
			}
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('<t:message code="system.message.purchase.message008" default="전체삭제 하시겠습니까?"/>')) {
						if(record.get('ACCOUNT_Q') != 0){
							alert('<t:message code="system.message.purchase.message042" default="매입등록된 자료는 삭제, 수정할 수 없습니다."/>');
						}else{
							var deletable = true;
							if(deletable){
								detailGrid.reset();
								UniAppManager.app.onSaveDataButtonDown('deleteAll');
							}
							isNewData = false;
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelResult.getValue('INOUT_NUM')))	{
				alert('<t:message code="system.label.purchase.receiptno" default="입고번호"/>:<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true)){
				panelResult.setAllFieldsReadOnly(true);
				return true;
			}
			return false;
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('INOUT_DATE'	, new Date());
			panelResult.setValue('CREATE_LOC'	, '2');
			panelResult.setValue('MONEY_UNIT'	, UserInfo.currency);
			Ext.getCmp('btnPrint').disable();

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
			var field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = inoutNoSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = noreceiveSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
//			panelResult.setValue('INOUT_PRSN',BsaCodeInfo.gsInOutPrsn);
//			panelResult.setValue('INOUT_PRSN',BsaCodeInfo.gsInOutPrsn);
			UniAppManager.app.fnExchngRateO(true);


		},
 		fnInTypeAccountYN:function(subCode){
 			var fRecord ='';
			Ext.each(BsaCodeInfo.gsInTypeAccountYN, function(item, i)	{
				if(item.get('value') == subCode && !Ext.isEmpty(item.get('refCode4'))) {
					fRecord = item.get('refCode4');
				}
			});
			if(Ext.isEmpty(fRecord)){
				//refcode4가 비어있으면 그리드에 있는 값 그대로 사용
				fRecord = ''
			}
			return fRecord;
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE')),
				"MONEY_UNIT" : panelResult.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni	&& !Ext.isEmpty(panelResult.getValue('MONEY_UNIT')) && panelResult.getValue('MONEY_UNIT') != BsaCodeInfo.gsDefaultMoney){
						alert('<t:message code="system.message.purchase.datacheck002" default="환율정보가 없습니다."/>')
					}
					panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
					panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
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
		}
	});



	Unilite.createValidator('validator00', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			switch(fieldName) {
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
						record.set('LOT_NO', "");
					}else{
						record.set('WH_CODE', "");
						record.set('WH_CELL_CODE', "");
						record.set('WH_CELL_NAME', "");
						record.set('LOT_NO', "");
					}
					//그리드 창고cell콤보 reLoad..
					cbStore.loadStoreRecords(newValue);
					break;
				case "ORDER_UNIT_Q" :
					if(newValue != oldValue){
						if(record.get('ITEM_CODE') == ''){
							rv='<t:message code="system.message.purchase.message028" default="품목코드를 입력 하십시오."/>';
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
									rv='<t:message code="system.message.purchase.message030" default="입고량은 발주량에 과입고허용률을 적용한 입고가능량보다 클 수 없습니다."/>' + '<t:message code="system.label.purchase.receiptavailbleqty" default="입고가능수량"/>' + ":" + dEnableQ;
									break;
								}
							}
						}
					}

					record.set('INOUT_Q', dInoutQ3);

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
									rv='<t:message code="system.message.purchase.message069" default="(-) 입고 수량은 재고량을 초과할 수 없습니다."/>'+" : " + (dStockQ - dOriginalQ) ;
										record.set('INOUT_Q', oldValue);
								}
							}
						}
					}

					var dOrderUnitQ	= newValue;
					var dTransRate	= record.get('TRNS_RATE');
					var dItemWidth	= record.get('ITEM_WIDTH');
					if(dItemWidth == 0) {
						dItemWidth = 1000;
					}
					var dSQM		= Unilite.multiply(Unilite.multiply(dOrderUnitQ, dTransRate), dItemWidth) / 1000	//SQM= 발주량  * 입수 * 폭 / 1000 * 단가;
					record.set('SQM', dSQM);

					if(record.get('ORDER_UNIT_P') != ''){
//						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_P') * newValue));			//자사금액= 자사단가 * 입력한입고량
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_P') * dSQM));			//자사금액= 자사단가 * 입력한입고량
					}else{
						record.set('ORDER_UNIT_I','0');
					}

					if(record.get('ORDER_UNIT_FOR_P') != ''){
//						record.set('ORDER_UNIT_FOR_O'	,(record.get('ORDER_UNIT_FOR_P') * newValue));	//구매금액 = 구매단가 * 입력한 입고량
						record.set('ORDER_UNIT_FOR_O'	,(record.get('ORDER_UNIT_FOR_P') * dSQM));	//구매금액 = 구매단가 * 입력한 입고량
						record.set('INOUT_FOR_O'		, record.get('ORDER_UNIT_FOR_O') /** record.get('EXCHG_RATE_O')*/);
					}else{
						record.set('ORDER_UNIT_FOR_O','0');
					}

					record.set('INOUT_Q'	,(newValue * record.get('TRNS_RATE')));	//수불수량(재고) = 입력수량 * 입수
					record.set('INOUT_I'	,record.get('ORDER_UNIT_I'));								//자사금액(재고) = 자사금액
					record.set('INOUT_P'	,record.get('INOUT_I') / record.get('INOUT_Q'));			//자사단가(재고) = 자사금액 / 재고단위수량
					record.set('INOUT_FOR_P',(record.get('ORDER_UNIT_FOR_P') * dItemWidth / 1000 /** record.get('EXCHG_RATE_O')*/));	//재고단위단가  = 구매단가 / 입수량

					directMasterStore1.fnSumAmountI();
				break;


				case "TRNS_RATE" :	//입수
					if(newValue <= 0){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}

					var dOrderUnitQ	= record.get('ORDER_UNIT_Q');
					var dItemWidth	= record.get('ITEM_WIDTH');
					if(dItemWidth == 0) {
						dItemWidth = 1000;
					}
					var dSQM = Unilite.multiply(Unilite.multiply(dOrderUnitQ, newValue), dItemWidth) / 1000	//SQM= 발주량  * 입수 * 폭 / 1000 * 단가;
					record.set('SQM', dSQM);

					record.set('ORDER_UNIT_FOR_O'	, record.get('ORDER_UNIT_FOR_P') * dSQM);							//구매금액 = 구매단가 * 입력한 입고량
					record.set('INOUT_FOR_O'		, record.get('ORDER_UNIT_FOR_O')/* * record.get('EXCHG_RATE_O')*/);	//재고단위금액  = 구매금액
					record.set('ORDER_UNIT_I'		, record.get('ORDER_UNIT_P') * dSQM);								//자사금액 = 입고량 * 자사단가
					record.set('INOUT_I'			, record.get('ORDER_UNIT_I'));

					if(record.get('ORDER_UNIT_Q') != '0'){
						record.set('INOUT_Q', record.get('ORDER_UNIT_Q') * newValue); 	//재고단위수량 = 입고량 * 입력한 입수
					}else{
						record.set('INOUT_Q', '0');
					}

					if(record.get('ORDER_UNIT_P') != ''){
						record.set('INOUT_P', record.get('INOUT_I') / record.get('INOUT_Q'));
					}else{
						record.set('INOUT_P', '0');
					}

					if(record.get('ORDER_UNIT_FOR_P') != ''){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}else{
						record.set('INOUT_FOR_P','0');
					}
					break;

				case "ORDER_UNIT_FOR_P":	//입고단가
					if((record.get('ACCOUNT_YNC')== 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')){
						if(newValue <= 0){
							rv='<t:message code="system.message.purchase.message032" default="기표대상여부가 기표일때 단가는 0보다 커야 합니다."/>';
							break;
						}
					} else {
						if(newValue < 0){
							rv='<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
							break;
						}
					}

					var dOrderUnitQ	= record.get('ORDER_UNIT_Q');
					var dTransRate	= record.get('TRNS_RATE');
					var dItemWidth	= record.get('ITEM_WIDTH');
					if(dItemWidth == 0) {
						dItemWidth = 1000;
					}
					var dSQM		= Unilite.multiply(Unilite.multiply(dOrderUnitQ, dTransRate), dItemWidth) / 1000	//SQM= 발주량  * 입수 * 폭 / 1000 * 단가;
					record.set('SQM', dSQM);

//					record.set('ORDER_UNIT_FOR_O', record.get('ORDER_UNIT_Q') * newValue);
					record.set('ORDER_UNIT_FOR_O'	, dSQM * newValue);
					record.set('INOUT_FOR_O'		, record.get('ORDER_UNIT_FOR_O')/* * record.get('EXCHG_RATE_O')*/);
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}
					directMasterStore1.fnSumAmountI();
					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_P'		,(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));		//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P'	,(newValue * record.get('EXCHG_RATE_O')));						//자사단가 = 입력한 구매단가 * 환율
						record.set('ORDER_UNIT_I'	,(dSQM * record.get('ORDER_UNIT_P')));							//자사금액 = 입고량 * 자사단가

						record.set('INOUT_FOR_P'	,(newValue * dItemWidth / 1000));
						record.set('INOUT_P'		,(newValue * dItemWidth / 1000 * record.get('EXCHG_RATE_O')));
						record.set('INOUT_I'		,(record.get('ORDER_UNIT_I')));							//	자사단가(ORDER_UNIT_P)

					} else {
						record.set('INOUT_I'		,'0');
						record.set('INOUT_P'		,'0');
						record.set('ORDER_UNIT_I'	,'0');
						record.set('ORDER_UNIT_P'	,'0');
					}
					break;

				case "ORDER_UNIT_FOR_O" : //입고금액
					if(record.get('ORDER_UNIT_Q') != ''){
						if((newValue <= 0) && (record.get('ORDER_UNIT_Q') > 0)){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						}else if((newValue >= 0) && (record.get('ORDER_UNIT_Q') < 0)){
							rv='<t:message code="system.message.purchase.message034" default="음수만 입력가능합니다."/>';
							break;
						}
					}

					if(record.get('INOUT_TYPE_DETAIL') != '90'){
						if(newValue <= '0'){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						}
					}

					var dOrderUnitQ	= record.get('ORDER_UNIT_Q');
					var dTransRate	= record.get('TRNS_RATE');
					var dItemWidth	= record.get('ITEM_WIDTH');
					if(dItemWidth == 0) {
						dItemWidth = 1000;
					}
					var dSQM		= Unilite.multiply(Unilite.multiply(dOrderUnitQ, dTransRate), dItemWidth) / 1000	//SQM= 발주량  * 입수 * 폭 / 1000 * 단가;
					record.set('SQM', dSQM);

					record.set('INOUT_FOR_O', newValue /** record.get('EXCHG_RATE_O')*/);

					if(record.get('INOUT_Q') != 0){
						record.set('ORDER_UNIT_FOR_P'	,(newValue / dSQM));	//구매단가 = 입력한 구매금액 / 입고량
						record.set('INOUT_FOR_P'		,(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));
//						record.set('INOUT_FOR_P'		,(record.get('ORDER_UNIT_FOR_P') / record.get('TRNS_RATE')));
					}else{
						record.set('INOUT_FOR_P'		,'0');
						record.set('ORDER_UNIT_FOR_P'	,'0');
					}
					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_P'		,(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P'	,(record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가 = 구매단가 * 환율
						record.set('ORDER_UNIT_I'	,(newValue * record.get('EXCHG_RATE_O')));	//자사금액 = 입력한 구매금액 * 환율
					}else{
						record.set('INOUT_I'		,'0');
						record.set('INOUT_P'		,'0');
						record.set('ORDER_UNIT_I'	,'0');
						record.set('ORDER_UNIT_P'	,'0');
					}
					directMasterStore1.fnSumAmountI();
					break;

/*				case "MONEY_UNIT" :
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
*/

				case "INOUT_TYPE_DETAIL" :
					//20181206 입고구분에 따른 기표대상여부 db에서 가져오는 로직
					var accountYn = UniAppManager.app.fnInTypeAccountYN(newValue);
					if(!Ext.isEmpty(accountYn)) {
						record.set('ACCOUNT_YNC', accountYn);
					}

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

					} else {
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
							rv='<t:message code="system.message.purchase.message070" default="단가는 0보다 커야 합니다."/>';
							break;
						}
					}
					break;

				case "PROJECT_NO":
					break;

				case "TRANS_COST":
					if(newValue < 0){
						rv='<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
						break;
					}
					break;
				case "TARIFF_AMT":
					if(newValue < 0){
						rv='<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
						break;
					}
					break;
			}
			return rv;
		}
	});

	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			switch(fieldName) {
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
						record.set('LOT_NO', "");
					}else{
						record.set('WH_CODE', "");
						record.set('WH_CELL_CODE', "");
						record.set('WH_CELL_NAME', "");
						record.set('LOT_NO', "");
					}
					//그리드 창고cell콤보 reLoad..
					cbStore.loadStoreRecords(newValue);
					break;
				case "ORDER_UNIT_Q" :
					if(newValue != oldValue){
						if(record.get('ITEM_CODE') == ''){
							rv='<t:message code="system.message.purchase.message028" default="품목코드를 입력 하십시오."/>';
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
									rv='<t:message code="system.message.purchase.message030" default="입고량은 발주량에 과입고허용률을 적용한 입고가능량보다 클 수 없습니다."/>' + '<t:message code="system.message.purchase.message031" default="입고가능수량 : "/>' + dEnableQ;
									break;
								}
							}
						}
					}

					record.set('INOUT_Q', dInoutQ3);

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
									rv='<t:message code="system.message.purchase.message069" default="(-) 입고 수량은 재고량을 초과할 수 없습니다."/>'+" : " + (dStockQ - dOriginalQ) ;
										record.set('INOUT_Q', oldValue);
								}
							}
						}
					}

					var dOrderUnitQ	= newValue;
					var dTransRate	= record.get('TRNS_RATE');
					var dItemWidth	= record.get('ITEM_WIDTH');
					if(dItemWidth == 0) {
						dItemWidth = 1000;
					}
					var dSQM		= Unilite.multiply(Unilite.multiply(dOrderUnitQ, dTransRate), dItemWidth) / 1000	//SQM= 발주량  * 입수 * 폭 / 1000 * 단가;
					record.set('SQM', dSQM);

					if(record.get('ORDER_UNIT_P') != ''){
//						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_P') * newValue));			//자사금액= 자사단가 * 입력한입고량
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_P') * dSQM));			//자사금액= 자사단가 * 입력한입고량
					}else{
						record.set('ORDER_UNIT_I','0');
					}

					if(record.get('ORDER_UNIT_FOR_P') != ''){
//						record.set('ORDER_UNIT_FOR_O'	,(record.get('ORDER_UNIT_FOR_P') * newValue));	//구매금액 = 구매단가 * 입력한 입고량
						record.set('ORDER_UNIT_FOR_O'	,(record.get('ORDER_UNIT_FOR_P') * dSQM));	//구매금액 = 구매단가 * 입력한 입고량
						record.set('INOUT_FOR_O'		, record.get('ORDER_UNIT_FOR_O')/* * record.get('EXCHG_RATE_O')*/);			//재고단위금액  = 구매금액

					}else{
						record.set('ORDER_UNIT_FOR_O','0');
					}

					record.set('INOUT_Q'	,(newValue * record.get('TRNS_RATE')));	//수불수량(재고) = 입력수량 * 입수
					record.set('INOUT_I'	,record.get('ORDER_UNIT_I'));								//자사금액(재고) = 자사금액
					record.set('INOUT_P'	,record.get('INOUT_I') / record.get('INOUT_Q'));			//자사단가(재고) = 자사금액 / 재고단위수량
//					record.set('INOUT_FOR_P',(record.get('ORDER_UNIT_FOR_P')/ record.get('TRNS_RATE')));	//재고단위단가  = 구매단가 / 입수량
					record.set('INOUT_FOR_P',(record.get('ORDER_UNIT_FOR_P') * dItemWidth / 1000/* * record.get('EXCHG_RATE_O')*/));	//재고단위단가  = 구매단가 / 입수량

					directMasterStore1.fnSumAmountI();
				break;


				case "TRNS_RATE" :	//입수
					if(newValue <= 0){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}

					var dOrderUnitQ	= record.get('ORDER_UNIT_Q');
					var dItemWidth	= record.get('ITEM_WIDTH');
					if(dItemWidth == 0) {
						dItemWidth = 1000;
					}
					var dSQM = Unilite.multiply(Unilite.multiply(dOrderUnitQ, newValue), dItemWidth) / 1000	//SQM= 발주량  * 입수 * 폭 / 1000 * 단가;
					record.set('SQM', dSQM);

					record.set('ORDER_UNIT_FOR_O'	, record.get('ORDER_UNIT_FOR_P') * dSQM);							//구매금액 = 구매단가 * 입력한 입고량
					record.set('INOUT_FOR_O'		, record.get('ORDER_UNIT_FOR_O')/* * record.get('EXCHG_RATE_O')*/);	//재고단위금액  = 구매금액
					record.set('ORDER_UNIT_I'		, record.get('ORDER_UNIT_P') * dSQM);								//자사금액 = 입고량 * 자사단가
					record.set('INOUT_I'			, record.get('ORDER_UNIT_I'));

					if(record.get('ORDER_UNIT_Q') != '0'){
						record.set('INOUT_Q', record.get('ORDER_UNIT_Q') * newValue); 	//재고단위수량 = 입고량 * 입력한 입수
					}else{
						record.set('INOUT_Q', '0');
					}

					if(record.get('ORDER_UNIT_P') != ''){
						record.set('INOUT_P', record.get('INOUT_I') / record.get('INOUT_Q'));
					}else{
						record.set('INOUT_P', '0');
					}

					if(record.get('ORDER_UNIT_FOR_P') != ''){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}else{
						record.set('INOUT_FOR_P','0');
					}
					break;

				case "ORDER_UNIT_FOR_P":	//입고단가
					if((record.get('ACCOUNT_YNC')== 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')){
						if(newValue <= 0){
							rv='<t:message code="system.message.purchase.message032" default="기표대상여부가 기표일때 단가는 0보다 커야 합니다."/>';
							break;
						}
					} else {
						if(newValue < 0){
							rv='<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
							break;
						}
					}

					var dOrderUnitQ	= record.get('ORDER_UNIT_Q');
					var dTransRate	= record.get('TRNS_RATE');
					var dItemWidth	= record.get('ITEM_WIDTH');
					if(dItemWidth == 0) {
						dItemWidth = 1000;
					}
					var dSQM		= Unilite.multiply(Unilite.multiply(dOrderUnitQ, dTransRate), dItemWidth) / 1000	//SQM= 발주량  * 입수 * 폭 / 1000 * 단가;
					record.set('SQM', dSQM);

//					record.set('ORDER_UNIT_FOR_O', record.get('ORDER_UNIT_Q') * newValue);
					record.set('ORDER_UNIT_FOR_O'	, dSQM * newValue);
					record.set('INOUT_FOR_O'		, record.get('ORDER_UNIT_FOR_O') /** record.get('EXCHG_RATE_O')*/);	//재고단위금액 = 구매금액
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}

					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_I'		,(record.get('INOUT_FOR_O') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('INOUT_P'		,(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));		//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P'	,(newValue * record.get('EXCHG_RATE_O')));						//자사단가 = 입력한 구매단가 * 환율
						record.set('ORDER_UNIT_I'	,(dSQM * record.get('ORDER_UNIT_P')));							//자사금액 = 입고량 * 자사단가

						record.set('INOUT_FOR_P'	,(newValue * dItemWidth / 1000));
						record.set('INOUT_P'		,(newValue * dItemWidth / 1000 * record.get('EXCHG_RATE_O')));
						record.set('INOUT_I'		,(record.get('ORDER_UNIT_P') * dSQM));							//	자사단가(ORDER_UNIT_P)

					} else {
						record.set('INOUT_I'		,'0');
						record.set('INOUT_P'		,'0');
						record.set('ORDER_UNIT_I'	,'0');
						record.set('ORDER_UNIT_P'	,'0');
					}
					directMasterStore1.fnSumAmountI();
					break;

				case "ORDER_UNIT_FOR_O" : //입고금액
					if(record.get('ORDER_UNIT_Q') != ''){
						if((newValue <= 0) && (record.get('ORDER_UNIT_Q') > 0)){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						}else if((newValue >= 0) && (record.get('ORDER_UNIT_Q') < 0)){
							rv='<t:message code="system.message.purchase.message034" default="음수만 입력가능합니다."/>';
							break;
						}
					}

					if(record.get('INOUT_TYPE_DETAIL') != '90'){
						if(newValue <= '0'){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						}
					}

					var dOrderUnitQ	= record.get('ORDER_UNIT_Q');
					var dTransRate	= record.get('TRNS_RATE');
					var dItemWidth	= record.get('ITEM_WIDTH');
					if(dItemWidth == 0) {
						dItemWidth = 1000;
					}
					var dSQM		= Unilite.multiply(Unilite.multiply(dOrderUnitQ, dTransRate), dItemWidth) / 1000	//SQM= 발주량  * 입수 * 폭 / 1000 * 단가;
					record.set('SQM', dSQM);

					record.set('INOUT_FOR_O', newValue/* * record.get('EXCHG_RATE_O')*/);

					if(record.get('INOUT_Q') != 0){
						record.set('ORDER_UNIT_FOR_P'	,(newValue / dSQM));	//구매단가 = 입력한 구매금액 / 입고량
						record.set('INOUT_FOR_P'		,(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));
//						record.set('INOUT_FOR_P'		,(record.get('ORDER_UNIT_FOR_P') / record.get('TRNS_RATE')));
					}else{
						record.set('INOUT_FOR_P'		,'0');
						record.set('ORDER_UNIT_FOR_P'	,'0');
					}

					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_I'		,(record.get('INOUT_FOR_O') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('INOUT_P'		,(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P'	,(record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가 = 구매단가 * 환율
						record.set('ORDER_UNIT_I'	,(newValue * record.get('EXCHG_RATE_O')));	//자사금액 = 입력한 구매금액 * 환율
					}else{
						record.set('INOUT_I'		,'0');
						record.set('INOUT_P'		,'0');
						record.set('ORDER_UNIT_I'	,'0');
						record.set('ORDER_UNIT_P'	,'0');
					}
					directMasterStore1.fnSumAmountI();
					break;

/*				case "MONEY_UNIT" :
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
*/

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
							rv='<t:message code="system.message.purchase.message070" default="단가는 0보다 커야 합니다."/>';
							break;
						}
					}
					break;
				case "PROJECT_NO":
					break;
				case "TRANS_COST":
					if(newValue < 0){
						rv='<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
						break;
					}
				case "TARIFF_AMT":
					if(newValue < 0){
						rv='<t:message code="system.message.purchase.message033" default="0이상의 값만 입력 가능합니다."/>';
						break;
					}
			}
			return rv;
		}
	});

	Unilite.createValidator('validator02', {
		forms: {'formA:':panelResult},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "EXCHG_RATE_O" :	// 환율
					if(panelResult.getValue('MONEY_UNIT') == BsaCodeInfo.gsDefaultMoney){
						if(newValue != '1'){
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
							popup.setExtParam({'DIV_CODE': selectRec.get('DIV_CODE')});
							popup.setExtParam({'ITEM_CODE': selectRec.get('ITEM_CODE')});
							popup.setExtParam({'ITEM_NAME': selectRec.get('ITEM_NAME')});
							popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
							popup.setExtParam({'CUSTOM_NAME': panelResult.getValue('CUSTOM_NAME')});
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

	var activeGridId = 's_mms510ukrv_jwGrid1';
};
</script>