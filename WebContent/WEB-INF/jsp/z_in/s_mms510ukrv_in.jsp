<%--
'	프로그램명 : 입고등록 (구매재고)
'	작	성	자 : (주)포렌 개발실
'	작	성	일 :
'	최종수정자 :
'	최종수정일 :
'	버		전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mms510ukrv_in"	>
	<t:ExtComboStore comboType="BOR120" pgmId="s_mms510ukrv_in" />			<!-- 사업장 -->
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
	gsQ008Sub			: '${gsQ008Sub}',				//가입고사용여부 관련 
	gsWorker			: '${gsWorker}',				//라벨출력에 인쇄될 작업자 정보
	gsSelectLabel		: '${gsSelectLabel}'			//출력할 라벨 선택
};
if(Ext.isEmpty(BsaCodeInfo.gsSelectLabel)) {
	BsaCodeInfo.gsSelectLabel = '2';
}
if(Ext.isEmpty(BsaCodeInfo.gsWorker)) {
	BsaCodeInfo.gsWorker = '';
}

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
			read	: 's_mms510ukrv_inService.selectList',
			update	: 's_mms510ukrv_inService.updateDetail',
			create	: 's_mms510ukrv_inService.insertDetail',
			destroy	: 's_mms510ukrv_inService.deleteDetail',
			syncAll	: 's_mms510ukrv_inService.saveAll'
		}
	});
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_mms510ukrv_inService.selectList2',
			update	: 's_mms510ukrv_inService.updateDetail',
			create	: 's_mms510ukrv_inService.insertDetail',
			destroy	: 's_mms510ukrv_inService.deleteDetail',
			syncAll	: 's_mms510ukrv_inService.saveAll2'
		}
	});
	
	
	
	Unilite.defineModel('s_mms510ukrv_inModel1', {
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
			{name: 'ORDER_UNIT_FOR_O'		, text: '<t:message code="system.label.purchase.receiptamount" default="입고금액"/>'			, type: 'uniPrice', allowBlank: false},
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
			{name: 'MAKE_LOT_NO'			,text: '<t:message code="system.label.purchase.mfglot" default="제조LOT"/>'					, type: 'string'}
//			{name: 'PURCHASE_TYPE'			, text: 'PURCHASE_TYPE'		, type: 'int'},
//			{name: 'PURCHASE_RATE'			, text: 'PURCHASE_RATE'		, type: 'int'}
		]
	});//Unilite.defineModel('s_mms510ukrv_inModel1', {

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

	Unilite.defineModel('s_mms510ukrv_inRECEIVEModel', {		//미입고참조
		fields: [
			{name: 'GUBUN'					, text: '<t:message code="system.label.purchase.selection" default="선택"/>'				, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'DVRY_DATE'				, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'				, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			, type: 'string'},
			{name: 'ORDER_UNIT_Q'			, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'					, type: 'uniQty'},
			{name: 'REMAIN_Q'				, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'			, type: 'uniQty'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'NOINOUT_Q'				, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'			, type: 'uniQty'},
			{name: 'ORDER_Q'				, text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>'	, type: 'uniQty'},
			{name: 'UNIT_PRICE_TYPE'		, text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'			, type: 'string',comboType:'AU', comboCode:'M301'},
			{name: 'MONEY_UNIT'				, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				, type: 'string'},
			{name: 'EXCHG_RATE_O'			, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			, type: 'uniER'},
			{name: 'ORDER_P'				, text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>'	, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_P'			, text: '<t:message code="system.label.purchase.price" default="단가"/>'					, type: 'uniUnitPrice'},
			{name: 'ORDER_O'				, text: '<t:message code="system.label.purchase.amount" default="금액"/>'					, type: 'uniPrice'},
			{name: 'ORDER_LOC_P'			, text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'				, type: 'uniUnitPrice'},
			{name: 'ORDER_LOC_O'			, text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'				, type: 'uniPrice'},
			{name: 'ORDER_NUM'				, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'string'},
			{name: 'INSPEC_NUM'				, text: '<t:message code="system.label.purchase.receiptinspecno" default="접수/검사번호"/>'	, type: 'string'},
			{name: 'INSPEC_SEQ'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'string'},
			{name: 'LC_NUM'					, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'				, type: 'string'},
			{name: 'ORDER_REQ_NUM'			, text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'	, type: 'string'},
			{name: 'ORDER_TYPE'				, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'				, type: 'string', allowBlank: false},
			{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},
			{name: 'TRNS_RATE'				, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'						, type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
			{name: 'INSTOCK_Q'				, text: '<t:message code="system.label.purchase.poreceiptqty" default="발주입고수량"/>'		, type: 'uniQty'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'EXCESS_RATE'			, text: '<t:message code="system.label.purchase.overreceiptrate" default="과입고허용율"/>'	, type: 'uniPercent'},
			{name: 'ORDER_PRSN'				, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'		, type: 'string',comboType:'AU', comboCode:'B024'},
			{name: 'GOOD_STOCK_Q'			, text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>'			, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'			, text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'		, type: 'uniQty'},
			{name: 'LC_NO'					, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'BL_NO'					, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'				, type: 'string'},
			{name: 'BASIS_NUM'				, text: '<t:message code="system.label.purchase.basisno" default="근거번호"/>'				, type: 'string'},
			{name: 'BASIS_SEQ'				, text: '<t:message code="system.label.purchase.basisseq" default="근거순번"/>'				, type: 'string'},
			{name: 'LC_DATE'				, text: '<t:message code="system.label.purchase.lcdate" default="LC일"/>'				, type: 'uniDate'},
			{name: 'INVOICE_DATE'			, text: '<t:message code="system.label.purchase.customdate" default="통관일"/>'			, type: 'uniDate'},
			{name: 'TRADE_LOC'				, text: '<t:message code="system.label.purchase.tradelocation" default="무역경로"/>'		, type: 'string'},
			{name: 'LOT_NO'					, text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>'				, type: 'string'},
			{name: 'LOT_YN'					, text: '<t:message code="system.label.purchase.lotyn" default="LOT관리 여부"/>'				, type: 'string'},
			//20180725 추가 (ITEM_WIDTH, SQM)
			{name: 'ITEM_WIDTH'				,text: '<t:message code="system.label.purchase.width" default="폭(mm)"/>'				, type: 'float'	, decimalPrecision: 0	, format:'0,000'},
			//20180807 추가 (PACK_QTY)
			{name: 'PACK_QTY'				,text: '<t:message code="system.label.purchase.packingqty" default="포장수량"/>'			, type: 'float'	, decimalPrecision: 0	, format:'0,000'}
		]
	});

	Unilite.defineModel('s_mms510ukrv_inINSPECTModel2', {		//검사결과참조
		fields: [
			{name: 'GUBUN'					, text: '<t:message code="system.label.purchase.selection" default="선택"/>'				, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'DVRY_DATE'				, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'INSPEC_DATE'			, text: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>'			, type: 'uniDate'},
			{name: 'ORDER_UNIT'				, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			, type: 'string'},
			{name: 'ORDER_O'				, text: '<t:message code="system.label.purchase.amount" default="금액"/>'					, type: 'uniPrice'},
			{name: 'NOINOUT_Q'				, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'			, type: 'uniQty'},
			{name: 'ITEM_STATUS'			, text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>'			, type: 'string',comboType:'AU', comboCode:'B021'},
			{name: 'UNIT_PRICE_TYPE'		, text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'			, type: 'string',comboType:'AU', comboCode:'M301'},
			{name: 'MONEY_UNIT'				, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				, type: 'string'},
			{name: 'ORDER_UNIT_P'			, text: '<t:message code="system.label.purchase.price" default="단가"/>'					, type: 'uniUnitPrice'},
			{name: 'EXCHG_RATE_O'			, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			, type: 'uniER'},
			{name: 'ORDER_LOC_P'			, text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'				, type: 'uniUnitPrice'},
			{name: 'ORDER_LOC_O'			, text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'				, type: 'uniPrice'},
			{name: 'ORDER_NUM'				, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'				, type: 'int'},
			{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'REMAIN_Q'				, text: '<t:message code="system.label.purchase.inspecqty" default="검사량"/>'				, type: 'uniQty'},
			{name: 'INSPEC_NUM'				, text: '<t:message code="system.label.purchase.receiptinspecno" default="접수/검사번호"/>'	, type: 'string'},
			{name: 'INSPEC_SEQ'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'int'},
			{name: 'PORE_Q'					, text: '<t:message code="system.label.purchase.pobalance" default="발주잔량"/>'			, type: 'uniQty'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'LOT_NO'					, text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>'				, type: 'string'},
			{name: 'LOT_YN'					, text: '<t:message code="system.label.purchase.lotyn" default="LOT관리 여부"/>'				, type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'LC_NO'					, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'BL_NO'					, text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'				, type: 'string'},
			{name: 'BASIS_NUM'				, text: '<t:message code="system.label.purchase.basisno" default="근거번호"/>'				, type: 'string'},
			{name: 'BASIS_SEQ'				, text: '<t:message code="system.label.purchase.basisseq" default="근거순번"/>'				, type: 'int'},
			{name: 'LC_DATE'				, text: '<t:message code="system.label.purchase.lcdate" default="LC일"/>'				, type: 'uniDate'},
			{name: 'INVOICE_DATE'			, text: '<t:message code="system.label.purchase.customdate" default="통관일"/>'			, type: 'uniDate'},
			{name: 'TRADE_LOC'				, text: '<t:message code="system.label.purchase.tradelocation" default="무역경로"/>'		, type: 'string',comboType:'AU',comboCode:'T104'},
			{name: 'ITEM_ACCOUNT'			, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			, type: 'string'},
			{name: 'LC_NUM'					, text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'				, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
			{name: 'ORDER_REQ_NUM'			, text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'	, type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>'				, type: 'string'},
			{name: 'ORDER_TYPE'				, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'				, type: 'string'},
			{name: 'TRNS_RATE'				, text: '˂t:message code="system.label.purchase.containedqty" default="입수"/˃'						, type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'ORDER_Q'				, text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>'	, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q'			, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'					, type: 'uniQty'},
			{name: 'ORDER_P'				, text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>'	, type: 'uniUnitPrice'},
			{name: 'INSTOCK_Q'				, text: '<t:message code="system.label.purchase.poreceiptqty" default="발주입고수량"/>'		, type: 'uniQty'},
			{name: 'EXCESS_RATE'			, text: '<t:message code="system.label.purchase.overreceiptrate" default="과입고허용율"/>'	, type: 'string'},
			//20180725 추가 (ITEM_WIDTH, SQM)
			{name: 'ITEM_WIDTH'				,text: '<t:message code="system.label.purchase.width" default="폭(mm)"/>'				, type: 'float'	, decimalPrecision: 0	, format:'0,000'},
			//20180807 추가 (PACK_QTY)
			{name: 'PACK_QTY'				,text: '<t:message code="system.label.purchase.packingqty" default="포장수량"/>'			, type: 'float'	, decimalPrecision: 0	, format:'0,000'}
		]
	});
	
	
	
	var directMasterStore1 = Unilite.createStore('s_mms510ukrv_inMasterStore1', {
		model: 's_mms510ukrv_inModel1',
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
				if(record.get('INOUT_TYPE_DETAIL') != '91'){
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
					if(msg != ''){
						alert((index + 1) + '<t:message code="system.message.purchase.message026" default="행의 입력값을 확인 해주세요."/>' + msg);
						isErr = true;
						return false;
					}
				}
			});

			if(inValidRecs.length == 0) {
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
				var grid = Ext.getCmp('s_mms510ukrv_inGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
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

	});//End of var directMasterStore1 = Unilite.createStore('s_mms510ukrv_inMasterStore1', {

	var detailStore = Unilite.createStore('s_mms510ukrv_indetailStore', {
		model	: 's_mms510ukrv_inModel1',
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
				if(activeGridId == 's_mms510ukrv_inGrid1') {
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
						//Ext.getCmp('btnPrint').setDisabled(false);//출력버튼 활성화
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
				read: 's_mms510ukrv_inService.selectinoutNoMasterList'
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

	var noReceiveStore = Unilite.createStore('s_mms510ukrv_inNoReceiveStore', {				//미입고참조
		model: 's_mms510ukrv_inRECEIVEModel',
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
				read : 's_mms510ukrv_inService.selectnoReceiveList'
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

	var inspectResultStore2 = Unilite.createStore('s_mms510ukrv_inInspectResultStore', {	//검사결과참조(무검사참조겸용)
		model: 's_mms510ukrv_inINSPECTModel2',
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
				read : 's_mms510ukrv_inService.selectinspectResultList'
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
				var win;
				var param = panelResult.getValues();
	     		param.PGM_ID = PGM_ID;  //프로그램ID
	     		param.MAIN_CODE = 'M030' //해당 모듈의 출력정보를 가지고 있는 공통코드
				 win = Ext.create('widget.ClipReport', {
	                url: CPATH+'/z_in/s_mms510clukrv_in.do',
	                prgID: 's_mms510ukrv_in',
	                extParam: param
	            });
				win.center();
				win.show();
			}
		}/* ,{
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
		} */],
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



	var masterGrid = Unilite.createGrid('s_mms510ukrv_inGrid1', {
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
					'PGM_ID'		: 's_mms510ukrv_in',
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
		},'-',{
			itemId: 'noreceiveBtn',
//			id:'noreceiveBtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.unreceiptreference" default="미입고참조"/></div>',
			handler: function() {
				openNoReceiveWindow();
			}
		},'-',{
			itemId: 'inspectnoBtn',
//			id:'inspectnoBtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.noinspecreference" default="무검사참조"/></div>',
			handler: function() {
				windowFlag = 'inspectNo';
				if(referInspectResultWindow) {
					referInspectResultWindow.setConfig('title', '무검사참조');
				}
				openInspectResultWindow();
			}
		},'-',{
			itemId: 'returnpossibleBtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.returnavaiableporefer" default="반품가능발주참조"/></div>',
			handler: function() {
				openReturnPossibleWindow();
			}
		},'-',{
			itemId: 'inspectresultBtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.inspecresultrefer" default="검사결과참조"/></div>',
			handler: function() {
				windowFlag = 'inspectResult';
				if(referInspectResultWindow) {
					referInspectResultWindow.setConfig('title', '<t:message code="system.label.purchase.inspecresultrefer" default="검사결과참조"/>');
				}
				openInspectResultWindow();

			}
		}/*,{
			itemId: 'scmRefBtn',
			text: '<div style="color: blue">업체출고 참조(SCM)</div>',
			handler: function() {
				opeScmRefWindow();
			}
		}*/],
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
			{dataIndex: 'TRNS_RATE'				, width:66	,maxLength:12	,hidden: true},
			{dataIndex: 'STOCK_UNIT'			, width:88	,align: 'center'},
			{dataIndex: 'MAKE_LOT_NO'			, width:120},
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
			{dataIndex: 'MAKE_DATE'				, width:100	,hidden: true}
			
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
					grdRecord.set('PACK_QTY'			, Unilite.nvl(record['PACK_QTY'], 1));

				var param = {
					"ITEM_CODE"		: record['ITEM_CODE'],
					"CUSTOM_CODE"	: panelResult.getValue('CUSTOM_CODE'),
					"DIV_CODE"		: panelResult.getValue('DIV_CODE'),
					"MONEY_UNIT"	: panelResult.getValue('MONEY_UNIT'),
					"ORDER_UNIT"	: record['ORDER_UNIT'],
					"INOUT_DATE"	: panelResult.getValue('INOUT_DATE')
				};
				s_mms510ukrv_inService.fnOrderPrice(param, function(provider, response)	{
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
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P']);
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
			grdRecord.set('ORDER_UNIT_Q'		, record['NOINOUT_Q']);
			grdRecord.set('ORDER_UNIT_FOR_P'	, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_FOR_O'	, record['ORDER_UNIT_P'] * record['NOINOUT_Q']);
//			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_LOC_P']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P']);	//자사단가

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
				grdRecord.set('EXCHG_RATE_O'	, panelResult.getValue('EXCHG_RATE_O'));
//			}else{
//				grdRecord.set('EXCHG_RATE_O'	, record['EXCHG_RATE_O']);
//			}
//			grdRecord.set('INOUT_I'			 , record['ORDER_UNIT_P']);	//자사단가
			
			
			//20180807 추가 (PACK_QTY),
			grdRecord.set('PACK_QTY'			, Unilite.nvl(record['PACK_QTY'], 1));
			
			grdRecord.set('INOUT_I', (record['ORDER_UNIT_P'] * record['NOINOUT_Q'])); // 자사단가(ORDER_UNIT_P)
			
			grdRecord.set('INOUT_P',(record['ORDER_UNIT_P'] * panelResult.getValue('EXCHG_RATE_O') / record['TRNS_RATE'] ));

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
			grdRecord.set('SQM'				, 1 * record['TRNS_RATE'] * itemWidth / 1000);

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

			s_mms510ukrv_inService.taxType(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
				grdRecord.set('TAX_TYPE', provider['TAX_TYPE']);
				}
			});

			directMasterStore1.fnSumAmountI();
		}
	});//End of var masterGrid = Unilite.createGrid('s_mms510ukrv_inGrid1', {
	
	var detailGrid = Unilite.createGrid('s_mms510ukrv_indetailGrid', {
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
						//Ext.getCmp('btnPrint').enable();
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var toDelete = detailStore.getRemovedRecords();
					if (/*toDelete.length == 0 && */this.selected.getCount() == 0) {
						//Ext.getCmp('btnPrint').disable();
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
			{dataIndex: 'ITEM_WIDTH'			, width:88	,align: 'center', hidden: true },
			{dataIndex: 'SQM'					, width:88	,align: 'center', hidden: true },
			
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
			{dataIndex: 'FLAG'					, width:80	,hidden: true}
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
				s_mms510ukrv_inService.fnOrderPrice(param, function(provider, response)	{
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
	});//End of var masterGrid = Unilite.createGrid('s_mms510ukrv_inGrid1', {

	var inoutNoMasterGrid = Unilite.createGrid('s_mms510ukrv_ininoutNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
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

	var noreceiveGrid = Unilite.createGrid('s_mms510ukrv_inNoreceiveGrid', {				//미입고참조
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
			{ dataIndex: 'GUBUN'				,	width:33,locked:true,hidden:true},
			{ dataIndex: 'ITEM_CODE'			,	width:120,locked:true},
			{ dataIndex: 'ITEM_NAME'			,	width:150,locked:true},
			{ dataIndex: 'ITEM_ACCOUNT'			,	width:120,hidden:true},
			{ dataIndex: 'SPEC'					,	width:150},
			{ dataIndex: 'DVRY_DATE'			,	width:86},
			{ dataIndex: 'DIV_CODE'				,	width:80,hidden:true},
			{ dataIndex: 'ORDER_UNIT'			,	width:66,align:"center"},
			{ dataIndex: 'ORDER_UNIT_Q'			,	width:100,hidden:true},
			{ dataIndex: 'REMAIN_Q'				,	width:100,summaryType: 'sum'},
			{ dataIndex: 'STOCK_UNIT'			,	width:53,hidden:true,align:"center"},
			{ dataIndex: 'NOINOUT_Q'			,	width:100,hidden:true},
			{ dataIndex: 'ORDER_Q'				,	width:100,hidden:true},
			{ dataIndex: 'UNIT_PRICE_TYPE'		,	width:100},
			{ dataIndex: 'MONEY_UNIT'			,	width:66,align:"center"},
			{ dataIndex: 'EXCHG_RATE_O'			,	width:90},
			{ dataIndex: 'ORDER_P'				,	width:93,hidden:true},
			{ dataIndex: 'ORDER_UNIT_P'			,	width:100},
			{ dataIndex: 'ORDER_O'				,	width:100,summaryType: 'sum'},
			{ dataIndex: 'ORDER_LOC_P'			,	width:100},
			{ dataIndex: 'ORDER_LOC_O'			,	width:100,summaryType: 'sum'},
			{ dataIndex: 'ORDER_NUM'			,	width:120},
			{ dataIndex: 'ORDER_SEQ'			,	width:66,align:"center"},
			{ dataIndex: 'LC_NUM'				,	width:33,hidden:true},
			{ dataIndex: 'WH_CODE'				,	width:33,hidden:true},
			{ dataIndex: 'ORDER_REQ_NUM'		,	width:33,hidden:true},
			{ dataIndex: 'ORDER_TYPE'			,	width:33,hidden:true},
			{ dataIndex: 'CUSTOM_CODE'			,	width:60,hidden:true},
			{ dataIndex: 'TRNS_RATE'			,	width:80,hidden:true},
			{ dataIndex: 'INSTOCK_Q'			,	width:80,hidden:true},
			{ dataIndex: 'REMARK'				,	width:150},
			{ dataIndex: 'PROJECT_NO'			,	width:120},
			{ dataIndex: 'EXCESS_RATE'			,	width:80,hidden:true},
			{ dataIndex: 'ORDER_PRSN'			,	width:100},
			{ dataIndex: 'GOOD_STOCK_Q'			,	width:66,hidden:true},
			{ dataIndex: 'BAD_STOCK_Q'			,	width:66,hidden:true},
			{ dataIndex: 'LC_NO'				,	width:66,hidden:true},
			{ dataIndex: 'BL_NO'				,	width:66,hidden:true},
			{ dataIndex: 'BASIS_NUM'			,	width:66,hidden:true},
			{ dataIndex: 'BASIS_SEQ'			,	width:53,hidden:true},
			{ dataIndex: 'LC_DATE'				,	width:66,hidden:true},
			{ dataIndex: 'INVOICE_DATE'			,	width:66,hidden:true},
			{ dataIndex: 'TRADE_LOC'			,	width:53,hidden:true},
			{ dataIndex: 'LOT_NO'				,	width:53},
			{ dataIndex: 'LOT_YN'				,	width:53,hidden: true},
			//20180807 추가 (PACK_QTY),
			{ dataIndex: 'PACK_QTY'				,	width:88	,align: 'center'	,hidden: true}
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

	var inspectresultGrid2 = Unilite.createGrid('s_mms510ukrv_inInspectResultGrid2', {		//검사결과참조
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
			{dataIndex: 'LOT_NO'							, width:100,hidden:false},
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
		id: 's_mms510ukrv_inApp',
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
			if(BsaCodeInfo.gsQ008Sub == 'Y'){ //무검사참조
				masterGrid.down('#noreceiveBtn').setHidden(true);
				masterGrid.down('#inspectnoBtn').setHidden(false);
        	}else{	//미입고참조
        		masterGrid.down('#noreceiveBtn').setHidden(false);
        		masterGrid.down('#inspectnoBtn').setHidden(true);
    		}
			setup_web_print();
			UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);
			this.setDefault();
//			cbStore.loadStoreRecords();
		},
		onQueryButtonDown: function() {
			panelResult.setAllFieldsReadOnly(false);
			//Ext.getCmp('btnPrint').disable();
			
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
					SALES_TYPE:		 0,
				//ORDER_UNIT_P : 
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
			//Ext.getCmp('btnPrint').disable();
			
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
	
	var activeGridId = 's_mms510ukrv_inGrid1';
};
</script>