<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="str800ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="str800ukrv"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" />						<!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />						<!-- 판매단위 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />			<!-- 창고 -->
	<t:ExtComboStore comboType="AU" comboCode="B021" />						<!-- 양불구분 -->
	<t:ExtComboStore comboType="WU" />										<!-- 작업장-->
		<t:ExtComboStore comboType="OU" />										<!-- 창고-->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>

<!-- zeber printer 관련 -->
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/zebraPrint/BrowserPrint-1.0.4.min.js" />'></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/zebraPrint/jquery-1.11.1.min.js" />'></script>


<script type="text/javascript">

var gsMonClosing	= '';	//월마감 여부
var gsDayClosing	= '';	//일마감 여부

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
//				Unilite.messageBox('No Zebra Printers could be found!');
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

function showBrowserPrintNotFound(){
//	Unilite.messageBox('An error occured while attempting to connect to your Zebra Printer. You may not have Zebra Browser Print installed, or it may not be running. Install Zebra Browser Print, or start the Zebra Browser Print Service, and try again.');
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
	Unilite.messageBox('An error occurred while printing. Please try again. '+ text);
}
function trySetupAgain(){
	$('#main').show();
	$('#error_div').hide();
	setup_web_print();
}
/* zebra printer 관련 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   */

function strFm(number, width) {
  number = number + '';
  return number.length >= width ? number : new Array(width - number.length + 1).join('0') + number;
}



var BsaCodeInfo = {
	gsLotInitail		: '${gsLotInitail}',		//LOT 이니셜
	gsReportGubun: '${gsReportGubun}'//클립리포트 추가로 인한 리포트 출력 방식 설정(CR:크리스탈 또는 jasper CLIP:클립리포트)
};
if(Ext.isEmpty(BsaCodeInfo.gsLotInitail)) {
	BsaCodeInfo.gsLotInitail = 'X';
}

function appMain() {
	var searchInfoWindow;		//searchInfoWindow : 검색창
	var alertWindow;			//alertWindow : 경고창
	var gsText			= ''	//바코드 알람 팝업 메세지



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'str800ukrvService.selectDetailList',
			update	: 'str800ukrvService.updateDetail',
			create	: 'str800ukrvService.insertDetail',
			destroy	: 'str800ukrvService.deleteDetail',
			syncAll	: 'str800ukrvService.saveAll'
		}
	});
	
	
	
	/** BOX 정보를 가지고 있는 Form
	 */	 
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,	
			value		: UserInfo.divCode,
			holdable	: 'hold',
			child		: 'WH_CODE',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					if(!Ext.isEmpty(newValue) && !Ext.isEmpty(panelResult.getValue('PACK_DATE'))){
						UniSales.fnGetClosingInfo(
							UniAppManager.app.cbGetClosingInfo,
							newValue,
							"I",
							panelResult.getField('PACK_DATE').getSubmitValue()
						);
					}
				}
			}
		},{
			fieldLabel	: 'BOX<t:message code="system.label.sales.number" default="번호"/>',
			name		: 'BOX_BARCODE',
			xtype		: 'uniTextfield',
			readOnly	: true,
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(newValue)){
						Ext.getCmp('btnPrint').enable();
					}else{
						Ext.getCmp('btnPrint').disable();
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.packdate" default="포장일"/>',
			name		: 'PACK_DATE',
			xtype		: 'uniDatefield',
			allowBlank	: false,
			value		: UniDate.get('today'),
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.sales.labelprint" default="라벨출력"/>',
			id		: 'btnPrint',
			width	: 80,
			margin	: '0 0 0 100', 
			handler	: function() {
				var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
				var reportGubun = BsaCodeInfo.gsReportGubun;
				var param = panelResult.getValues();
				var win;
				if(needSave){
				   Unilite.messageBox('<t:message code="system.message.common.savecheck" default="먼저 저장을 하십시오"/>'); //먼저 저장하십시오.
				   return false;
				}
				if(available_printers == null && reportGubun != 'CLIP')	{
					Unilite.messageBox('An error occurred while printing. Please try again.');
					return;
				}
				
				if(Ext.isEmpty(panelResult.getValue('BOX_BARCODE'))){
					return;
				}
				var param ={
					"S_COMP_CODE": UserInfo.compCode,
					"DIV_CODE": panelResult.getValue('DIV_CODE'),
					"BOX_BARCODE": panelResult.getValue('BOX_BARCODE'),
					"CUSTOM_CODE": panelResult.getValue('LABEL_CUSTOM'),
					"MAIN_CODE" : 'S036',
					"PGM_ID" : 'str800ukrv'
				}
				if(reportGubun == 'CLIP'){
					win = Ext.create('widget.ClipReport', {
		                url: CPATH+'/sales/str800clukrv.do',
		                prgID: 'str800ukrv',
		                extParam: param
		            });
					win.center();
					win.show();
				}else{
					str800ukrvService.selectPrintList(param, function(provider, response)  {
						if(!Ext.isEmpty(provider)){
							Unilite.messageBox('<t:message code="system.label.sales.success" default="성공"/>');	
							Ext.each(provider, function(record, index){
								
								if(panelResult.getValue('LABEL_TYPE') == 'E1'){
									var mainBarcode		= '';
									var poNo			= '';
									if(!Ext.isEmpty(record.PO_NO)) {
										poNo			= record.PO_NO;
									}
									var iqc				= '(IQC)';
									var itemName		= record.ITEM_NAME;
									var customItemCode	= '';
									if(!Ext.isEmpty(record.CUSTOM_ITEM_CODE)) {
										customItemCode	= record.CUSTOM_ITEM_CODE;
									} else {
										customItemCode	= record.ITEM_NAME;
									}
									var supplier		= '1P0010';						//고정값
//									var partInfo		= '0000';						//고정값
									var partInfo		= Ext.isEmpty(record.REMARK) ? '0000' : record.REMARK;
									var partInfo2		= '01';							//고정값
									var stockDate		= record.PACK_DATE
									var qty				= record.SUM_QTY;							//.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
									if(!Ext.isEmpty(record.SUM_QTY)) {
										qty			= ('000000' + record.SUM_QTY).substring(record.SUM_QTY.toString().length, 6+record.SUM_QTY.toString().length);
									} else {
										qty			= '000000';
									}
									
									var boxqty			= ''
									if(!Ext.isEmpty(record.BOX_QTY)) {
										boxqty			= ('0000' + record.BOX_QTY).substring(record.BOX_QTY.toString().length, 4+record.BOX_QTY.toString().length);
									} else {
										boxqty			= '0000';
									}
									var boxBarcode		= record.BOX_BARCODE;
									mainBarcode			= customItemCode.replace(/\-/g,'') + supplier + partInfo + partInfo2 + stockDate + qty + boxqty;
									
									var stringZPL = "";
									
									if(panelResult.getValue('DPI_GUBUN') == '1'){
										//zt230 300dpi 용 
										stringZPL += "^SEE:UHANGUL.DAT^FS";
										stringZPL += "^CW1,E:VERDANAB.TTF^CI28^FS";	//Verdanab
										
										stringZPL += "^PW900";						//라벨 가로 크기관련
										stringZPL += "^LH55,0^FS";

										stringZPL +="^FO550,205^BXN,8,200^FD"+ mainBarcode +"^FS";			//Main Barcode

										if(BsaCodeInfo.gsLotInitail == '1') {
											stringZPL +="^FO30,450^A1R,50,50^FD"+"JWORLD.,CO LTD"+"^FS";	//가장 하단 회사명
										} else {
											stringZPL +="^FO30,450^A1R,50,50^FD"+"JWORLD VINA.,CO LTD"+"^FS";	//가장 하단 회사명
										}
//										stringZPL +="^FO30,450^A1R,50,50^FD"+"JWORLD VINA.,CO LTD"+"^FS";	//가장 하단 회사명
										stringZPL +="^FO30,1200^BXR,5,200^FD"+ boxBarcode +"^FS";			//가장 하단 박스번호 바코드
										stringZPL +="^FO30,1300^A1R,35,35^FD"+ boxBarcode +"^FS";			//가장 하단 박스번호
										
										stringZPL +="^FO120,90^GB655,1600,6^FS";							//가장 외곽 박스
										stringZPL +="^FO120,502^GB655,0,6^FS";								//1번째 칸
										stringZPL +="^FO300,1091^GB475,0,6^FS";								//2번째 칸
										
										stringZPL +="^FO210,90^GB95,1600,6^FS";								//아래에서 1, 2번째 행
										stringZPL +="^FO210,90^GB190,1600,6^FS";							//아래에서 3번째 행
										stringZPL +="^FO393,90^GB95,1007,6^FS";								//아래에서 4번째 행
										stringZPL +="^FO578,502^GB98,595,6^FS";								//아래에서 5, 6, 7번째 행
										
										//아랫쪽 행부터 데이터 및 text 입력
										stringZPL +="^FO145,120^A1R,40,40^FD"+"Qty / BoxNo"+"^FS";
										stringZPL +="^FO145,550^A1R,40,40^FD"+ qty + " / " + boxqty +"^FS";
										
										stringZPL +="^FO235,120^A1R,40,40^FD"+"Stock Date"+"^FS";
										stringZPL +="^FO235,550^A1R,40,40^FD"+ stockDate +"^FS";
										
										stringZPL +="^FO325,120^A1R,40,40^FD"+"Part Info"+"^FS";
										stringZPL +="^FO325,550^A1R,40,40^FD"+ partInfo +"^FS";
										stringZPL +="^FO325,1120^A1R,40,40^FD"+ partInfo2 +"^FS";
										
										stringZPL +="^FO415,120^A1R,40,40^FD"+"SUPPLIER"+"^FS";
										stringZPL +="^FO415,550^A1R,40,40^FD"+ supplier +"^FS";

										stringZPL +="^FO505,550^A1R,40,40^FD"+ customItemCode +"^FS";

										stringZPL +="^FO600,550^A1R,40,40^FD"+ itemName +"^FS";

										stringZPL +="^FO695,550^A1R,40,40^FD"+ poNo +"^FS";
										stringZPL +="^FO705,1120^A1R,40,40^FD"+ iqc +"^FS";

									}else{
									}
								
								} else if(panelResult.getValue('LABEL_TYPE') == 'S1'){
									var partNo = '';
									if(!Ext.isEmpty(record.CUSTOM_ITEM_CODE)) {
										partNo	= record.CUSTOM_ITEM_CODE;
									} else {
										partNo	= record.ITEM_NAME;
									}
									var specification = '';
									//20190117 추가
									var poType ='';
									if(Ext.isEmpty(record.PO_TYPE)) {
										poType = 'E1';									//고정값
									} else {
										poType = record.PO_TYPE;									//고정값
									}
									
									var packDate = record.PACK_DATE;
									var lotNo = 'A1'+ packDate.substring(2,8) + '01';
									
									var sumQty = record.SUM_QTY;
									var formatSumQty = sumQty.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
									var qty = formatSumQty;
									var sumQtyString = strFm(sumQty,6);
									
									if(BsaCodeInfo.gsLotInitail == '1') {
										var vendorName = 'JWORLD';
									} else {
										var vendorName = 'JWORLDVINA';
									}
//									var vendorName = 'JWORLDVINA';
									var vendorCode = 'DXRX';
									
									var boxBarcode = record.BOX_BARCODE;
									
									var barCode = partNo + vendorCode + poType + lotNo + sumQtyString;//qty;
									
									var endDate  = '';
                                    if(!Ext.isEmpty(record.END_DATE)){
                                        endDate= UniDate.getDbDateStr(record.END_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(record.END_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(record.END_DATE).substring(6,8);//"2018-12-20";
                                    }
									 
									var stringZPL = "";
									
									if(panelResult.getValue('DPI_GUBUN') == '1'){
										/* zt230 300dpi 용*/
										//Verdanab
										stringZPL += "^SEE:UHANGUL.DAT^FS";
										
										stringZPL += "^CW1,E:VERDANAB.TTF^CI28^FS";//Verdanab
										stringZPL += "^PW900";		//라벨 가로 크기관련
										stringZPL += "^LH55,0^FS";
										
									
										stringZPL +="^FO640,150^BY3,2.0,10^B3R,N,150,N,N,^FD"+ "*" + barCode+ "*" + "^FS";	//code39
				
										stringZPL +="^FO540,150^A1R,65,65^FD"+barCode+"^FS";
												
										
										stringZPL +="^FO450,50^A1R,45,45^FD"+"PART NO"+"^FS";
										stringZPL +="^FO450,500^A1R,45,45^FD"+":"+"^FS";
										stringZPL +="^FO450,550^A1R,45,45^FD"+ partNo + "^FS";
										
										stringZPL +="^FO390,50^A1R,45,45^FD"+"SPECIFICATION"+"^FS";
										stringZPL +="^FO390,500^A1R,45,45^FD"+":"+"^FS";
										stringZPL +="^FO390,550^A1R,45,45^FD"+ specification + "^FS";
										
										stringZPL +="^FO330,50^A1R,45,45^FD"+"PO TYPE"+"^FS";
										stringZPL +="^FO330,500^A1R,45,45^FD"+":"+"^FS";
										stringZPL +="^FO330,550^A1R,45,45^FD"+ poType + "^FS";
										
										stringZPL +="^FO270,50^A1R,45,45^FD"+"Lot No"+"^FS";
										stringZPL +="^FO270,500^A1R,45,45^FD"+":"+"^FS";
										stringZPL +="^FO270,550^A1R,45,45^FD"+ lotNo + "^FS";
										
										stringZPL +="^FO210,50^A1R,45,45^FD"+"Qty"+"^FS";
										stringZPL +="^FO210,500^A1R,45,45^FD"+":"+"^FS";
										stringZPL +="^FO210,550^A1R,45,45^FD"+ qty + "^FS";
										
										stringZPL +="^FO150,50^A1R,45,45^FD"+"VENDOR NAME"+"^FS";
										stringZPL +="^FO150,500^A1R,45,45^FD"+":"+"^FS";
										stringZPL +="^FO150,550^A1R,45,45^FD"+ vendorName + "^FS";
										
										stringZPL +="^FO90,50^A1R,45,45^FD"+"DXRX"+"^FS";
										stringZPL +="^FO90,500^A1R,45,45^FD"+":"+"^FS";
										stringZPL +="^FO90,550^A1R,45,45^FD"+ vendorCode + "^FS";
										
										stringZPL +="^FO30,50^A1R,45,45^FD"+"Exp.Date"+"^FS";
                                        stringZPL +="^FO30,500^A1R,45,45^FD"+":"+"^FS";
                                        stringZPL +="^FO30,550^A1R,45,45^FD"+ endDate + "^FS";
										
										stringZPL +="^FO30,1200^BXR,5,200^FD"+ boxBarcode +"^FS";	//dataMatrix
										stringZPL +="^FO30,1300^A1R,35,35^FD"+ boxBarcode + "^FS";
										
										
										stringZPL +="^FO310,1300^BQ,2,7^FDQA,"+barCode+"^FS";	//QR바코드
										
										
										stringZPL +="^FO90,1290^GFA,10752,10752,00028,:Z64:";
										stringZPL +="eJztmb1y20YQx49kNNDIBeNKJTwq0yhvcCqU59DkDdxFVe5iFeFMHsLqwmHjRwAzKdLqEeAqnFQoNDGMAbHZ+wBuAdydScrxxDFvxkMSP/3vY3dvbw9m7NiObfc2AdfeCve9HDI4siM7sv85q/UP/nEZPoaGCy/LNPPrdIL6PJnYT2fMB43wsCbCWt0PxJ6/W3uO++SOiSEDuOuzirKZ9Z9lt4RVnS4zixMuzh6Ydv5bO2XGCCumUBk2vVDtBWGMQRnSyTDDJyIPsA1jZ9Iwrrr5i7AcP6w9U+W7grA1e8FY5uwpe6zzg7bLlWMNY99SXUnmUrNJgSvsGOuxWUnZoseSmrDHvm7essZGGGF8i5/t/mN9loG8gzY+ZY/hP5m0rOjr8HkFLbvHh1Og7H3HrtRDGoOmKVapLi+dLiVMezABry43w/Vzj9BMy87J/gOna3B18o3TAWHaleBndnVA4iyxbGuHe0fibGqZmsoMqG5thrBsIiiTyrjGf8YohKEJb9x4cxjoXtt5bmz3NE8klrVTJvFpOlJ2scM5vz/vdLA+6bOz1bLVwWbeZ+ijn1vWmOVQH/3ZMsif9Rj+5R8de5iEdY3MBszpGmMjMpdfOwb5rGeX51/b9dXamylhp9366m7AsT11WOUTrz0128yIj/AjtUwZZYu/hIsJCUQHm2e9eLkhOj2gy1ldnHH9pZ+XhGXpkFU2flQMnmJbSOGJeU/ejTIhBkwEdJLmEA24t8+DmfJXE2A8wvQZFGD6pzn/RkxqFtM9iWn/Q+Fl2ubkvB2zOlYzBJmAHzv/1Yvl/XK5m67HMiisrcf1Cy4oUkd+dLYVHXup5rs9Bxq7hY3PguFmX0qn6zHUrdWuGo+HR7ba/pd+NlFmmvtYg132mehsBkwVT8ztd2JPmOrDmDDnh+3MHGXO1stV67/mzjBv/ZkMz37CUsV4wQMMk9uDj2Fg4omblT72eKNMxr0Mgx0LA1UcelmJj0rexadUOcWMpxb2KqgrlJsc0yWnYUrXYy5PFMrUCWU6IFqWo/dC7AF1dYCtUUfmqdOnnadYYz3h7GI2T2Z1Ek8Ox7qm16fOikKEGAdq6wRkalj6t3I6zS9zWGaalbzRwdKxLZtv2Ylmj0mp6pc1OXO0Y3ScTXXd4+IMrtCIpv6szRNXD+Kto5CmbsXVyV+gIWfcd2oPQFv3zHRB2rIEjX+fWR1OOnexu01BzgresrTWy7f2VKzM2rrukjIMZpmY+4oqMUX91bWr5zkyc19RdRZvvlllRMfO7d6s9UJJXsoa+bq9327e9HMWGjht2TodsAoHCeQ6jiVLHWIlE1XmZymymM7YZZzLz/EelwvD9OLc+dDMcwYboDqXd1WyWVPmziOYYv2Sg3c8UL42sTQ649TWKe29insZ956b6FBerTJ//ZKz9HbC/fVLs2j30b410efIcAt+wvFU/Xnqrz9T/cWbzywrI+zWW38K/aXx6gyrIyyms4y2yS4M4IOMjvd9x0yfP/nm4tH9S4xH2M3eOkH859fFWBJh8yF759gsoptG2CTCGB8wQVjaZyb5ZYbNfYwbdhJkDWsHdHUkdLXwkKnv7bmyGjA1t+D5QHRDpgM3xrIDdf8pJrxMqqwZWF+KNVvInlnkLiM+7f0IzD3Huz5wd6C9+myeMs9QnMXswiO6FF4G/aBfSQTZU2PJbNP3EVYeyFSNF9SJvXVCMWUjut8rwqpL6gdo81Kqvha9+233jkV1od8R+vKZbkmEzYfjCZ+O3I9q5clxn2LH8WYRNnk64zB89+T1g2Xu/cvpYrGQu+v2ZemHYjfAxKE6cZhuxC4upu37uhFz/88FI5ZFGMBvEfYqwmSIwcEsfP/TL5TLEFuwsyrErq+vg7rVahXUodeCOmybCMsj7D7CrsKsDOTdrh3ZkR3Zl8u+5PYPAkNLww==:3121";
										stringZPL +="^PQ1,0,1,Y";
									
									}else{
										/*	zt230 200dpi 용 */
										//Verdanab
										stringZPL += "^SEE:UHANGUL.DAT^FS";
										
										stringZPL += "^CW1,E:VERDANAB.TTF^CI28^FS";//Verdanab
										stringZPL += "^PW600";		//라벨 가로 크기관련
										stringZPL += "^LH10,10^FS";
										
										stringZPL +="^FO435,130^BY2,2.0,10^B3R,N,100,N,N,^FD"+ "*" + barCode+ "*" + "^FS";	//code39
				
										stringZPL +="^FO370,140^A1R,42,42^FD"+barCode+"^FS";
												
										
										stringZPL +="^FO320,20^A1R,30,30^FD"+"PART NO"+"^FS";
										stringZPL +="^FO320,330^A1R,30,30^FD"+":"+"^FS";
										stringZPL +="^FO320,380^A1R,30,30^FD"+ partNo + "^FS";
										
										stringZPL +="^FO280,20^A1R,30,30^FD"+"SPECIFICATION"+"^FS";
										stringZPL +="^FO280,330^A1R,30,30^FD"+":"+"^FS";
										stringZPL +="^FO280,380^A1R,30,30^FD"+ specification + "^FS";
										
										stringZPL +="^FO240,20^A1R,30,30^FD"+"PO TYPE"+"^FS";
										stringZPL +="^FO240,330^A1R,30,30^FD"+":"+"^FS";
										stringZPL +="^FO240,380^A1R,30,30^FD"+ poType + "^FS";
										
										stringZPL +="^FO200,20^A1R,30,30^FD"+"Lot No"+"^FS";
										stringZPL +="^FO200,330^A1R,30,30^FD"+":"+"^FS";
										stringZPL +="^FO200,380^A1R,30,30^FD"+ lotNo + "^FS";
										
										stringZPL +="^FO160,20^A1R,30,30^FD"+"Qty"+"^FS";
										stringZPL +="^FO160,330^A1R,30,30^FD"+":"+"^FS";
										stringZPL +="^FO160,380^A1R,30,30^FD"+ qty + "^FS";
										
										stringZPL +="^FO120,20^A1R,30,30^FD"+"VENDOR NAME"+"^FS";
										stringZPL +="^FO120,330^A1R,30,30^FD"+":"+"^FS";
										stringZPL +="^FO120,380^A1R,30,30^FD"+ vendorName + "^FS";
										
										stringZPL +="^FO80,20^A1R,30,30^FD"+"DXRX"+"^FS";
										stringZPL +="^FO80,330^A1R,30,30^FD"+":"+"^FS";
										stringZPL +="^FO80,380^A1R,30,30^FD"+ vendorCode + "^FS";
										
										stringZPL +="^FO40,50^A1R,45,45^FD"+"Exp.Date"+"^FS";
                                        stringZPL +="^FO40,500^A1R,45,45^FD"+":"+"^FS";
                                        stringZPL +="^FO40,550^A1R,45,45^FD"+ endDate + "^FS";
										
										stringZPL +="^FO30,850^BXR,4,200^FD"+ boxBarcode +"^FS";	//dataMatrix
										stringZPL +="^FO30,920^A1R,30,30^FD"+ boxBarcode + "^FS";
										
										
										stringZPL +="^FO220,900^BQ,2,5^FDQA,"+barCode+"^FS";	//QR바코드
										
										
										stringZPL +="^FO65,888^GFA,04480,04480,00020,:Z64:";
										stringZPL +="eJzt1jGO1DAUAFBnBilltqN0wT1wQS4wJ5grUFKgOAgkCooVJ8gROMJktUK03GAsUVASmIKg9fjz7YD229+LMgMrmrgYjZ7+xP7+3/EIsYz/PgryecJQ4IcOn4vdox0B9mfbZiNTs0L8pe0Abv5sR6f3wQ4kblR7aN4BfCL5Dj7u7WbzhJhRHehWiDWxXuIcr+qamPs170jMFm2wgdq6Vd5aaqU3TIyaMhoaMJHpUI8rURKbatSKKtp7NFyRTm0U4gvJ4yM+UPe4cJoHlh3zVZFJH1dAZBVAY1ZRfXFhoK2M++CzX9/L2L57M5m4UfE4eBjVHOfF/TM6WQua3XJzZK8g5NYBrubWWg2svmGvYpv6+Tyzdb1l5vulyVjap3N7HHb7vKXn8i6rt0d69h0+SwtpVBp3BTh7YtcQ9WT9APP94CILa760PN/OFixfNZbcBmbNY1PepHuvhoqbqQ7MenlIa656Rd4HtvyKJltF4lzlz+qlUNfEtLdeAMnXNatgbkXnXXf+HP2ge+BKNLMe35A4W+H63Daq0Vh1rG6jZLW0g+xYvzxVKjUnnk/2jZ6PZzKcD7ovYuTvv/f8fOTOzP1Ysr5gcW4zbRp3xbF7MG+OWZeJm2uvZ9qL5Pz6fu5l1AfeGid5XNIv8+/a6tzfnvYeig1gl/kPcv7zTv5vQe4ZW2Tsd9wu3Wc0yc0xay8uuInkPp+sTKzJWBI3ra/N3DNdPt9zLNxvsR2dytRD8/pm4sDy9xqYR+z9h99zxmoJ+EBuY8aA9dpi/9yWsYzc+Al0nwDx:0190";
										stringZPL +="^PQ1,0,1,Y";
									}
									
								}else if(panelResult.getValue('LABEL_TYPE') == 'S2'){
									var partNumber = '';
									if(!Ext.isEmpty(record.CUSTOM_ITEM_CODE)) {
										partNumber	= record.CUSTOM_ITEM_CODE;
									} else {
										partNumber	= record.ITEM_NAME;
									}

									var description = '';
									
									if(BsaCodeInfo.gsLotInitail == '1') {
										var vendorName = 'JWORLD';
									} else {
										var vendorName = 'JWORLDVINA';
									}
//									var vendorName = 'JWORLDVINA';
									var vendorCode = 'DXRX';
									
									var packDate = record.PACK_DATE;
									var lotNo = packDate + '01';
									
									var sumQty = record.SUM_QTY;
									var formatSumQty = sumQty.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
									var qty = formatSumQty;
									var sumQtyString = strFm(sumQty,6);
									
									var manufacturedDate = '';
									if(!Ext.isEmpty(record.PRODT_DATE)){
										manufacturedDate = UniDate.getDbDateStr(record.PRODT_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(record.PRODT_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(record.PRODT_DATE).substring(6,8);//"2018-06-20";
									}
									
									var endDate  = '';
									if(!Ext.isEmpty(record.END_DATE)){
									    endDate= UniDate.getDbDateStr(record.END_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(record.END_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(record.END_DATE).substring(6,8);//"2018-12-20";
									}
									
									var barCode = partNumber + vendorCode + lotNo + sumQtyString;//qty;
									
									var stringZPL = "";
									
									var boxBarcode = record.BOX_BARCODE;
									
									if(panelResult.getValue('DPI_GUBUN') == '1'){
										/* zt230 300dpi 용*/
										//Verdanab
										stringZPL += "^SEE:UHANGUL.DAT^FS";
										
										stringZPL += "^CW1,E:VERDANAB.TTF^CI28^FS";//Verdanab
										stringZPL += "^PW900";		//라벨 가로 크기관련
										stringZPL += "^LH55,0^FS";
										
									
										stringZPL +="^FO640,150^BY3,2.0,10^B3R,N,150,N,N,^FD"+ "*" + barCode+ "*" + "^FS";	//code39
				
										stringZPL +="^FO540,150^A1R,65,65^FD"+barCode+"^FS";
												
										
										stringZPL +="^FO450,50^A1R,45,45^FD"+"Part Number"+"^FS";
										stringZPL +="^FO450,550^A1R,45,45^FD"+":"+"^FS";
										stringZPL +="^FO450,600^A1R,45,45^FD"+ partNumber + "^FS";
										
										stringZPL +="^FO390,50^A1R,45,45^FD"+"Description"+"^FS";
										stringZPL +="^FO390,550^A1R,45,45^FD"+":"+"^FS";
										stringZPL +="^FO390,600^A1R,45,45^FD"+ description + "^FS";
										
										stringZPL +="^FO330,50^A1R,45,45^FD"+"Vendor Code"+"^FS";
										stringZPL +="^FO330,550^A1R,45,45^FD"+":"+"^FS";
										stringZPL +="^FO330,600^A1R,45,45^FD"+ vendorCode + "^FS";
										
										stringZPL +="^FO270,50^A1R,45,45^FD"+"Vendor Name"+"^FS";
										stringZPL +="^FO270,550^A1R,45,45^FD"+":"+"^FS";
										stringZPL +="^FO270,600^A1R,45,45^FD"+ vendorName + "^FS";
										
										stringZPL +="^FO210,50^A1R,45,45^FD"+"Lot No"+"^FS";
										stringZPL +="^FO210,550^A1R,45,45^FD"+":"+"^FS";
										stringZPL +="^FO210,600^A1R,45,45^FD"+ lotNo + "^FS";
										
										stringZPL +="^FO150,50^A1R,45,45^FD"+"QTY"+"^FS";
										stringZPL +="^FO150,550^A1R,45,45^FD"+":"+"^FS";
										stringZPL +="^FO150,600^A1R,45,45^FD"+ qty + "^FS";
										
										stringZPL +="^FO90,50^A1R,45,45^FD"+"Manufactured Date"+"^FS";
										stringZPL +="^FO90,550^A1R,45,45^FD"+":"+"^FS";
										stringZPL +="^FO90,600^A1R,45,45^FD"+ manufacturedDate + "^FS";
										
										stringZPL +="^FO30,50^A1R,45,45^FD"+"Exp.Date"+"^FS";
                                        stringZPL +="^FO30,550^A1R,45,45^FD"+":"+"^FS";
                                        stringZPL +="^FO30,600^A1R,45,45^FD"+ endDate + "^FS";
                                        
										stringZPL +="^FO100,1050^GB400,600,6^FS";
										stringZPL +="^FO250,1050^GB0,600,6^FS";
										stringZPL +="^FO400,1050^GB0,600,6^FS";
										stringZPL +="^FO250,1350^GB150,0,6^FS";
										stringZPL +="^FO420,1150^A1R,45,45^FD"+ "OQC" + "^FS";
										stringZPL +="^FO420,1450^A1R,45,45^FD"+ "KHO" + "^FS";

										//20180820 추가
										stringZPL +="^FO25,1200^BXR,5,200^FD"+ boxBarcode +"^FS";		//dataMatrix
										stringZPL +="^FO25,1300^A1R,35,35^FD"+ boxBarcode + "^FS";

									}else{
										/*	zt230 200dpi 용 */
										//Verdanab
										var stringZPL = "";
										stringZPL += "^SEE:UHANGUL.DAT^FS";
										stringZPL += "^CW1,E:VERDANAB.TTF^CI28^FS";//Verdanab
										stringZPL += "^PW600";		//라벨 가로 크기관련
										stringZPL += "^LH10,10^FS";
										
										stringZPL +="^FO435,130^BY2,2.0,10^B3R,N,100,N,N,^FD"+ "*" + barCode+ "*" + "^FS";	//code39
				
										stringZPL +="^FO370,140^A1R,45,45^FD"+barCode+"^FS";
												
										
										stringZPL +="^FO320,20^A1R,30,30^FD"+"Part Number"+"^FS";
										stringZPL +="^FO320,330^A1R,30,30^FD"+":"+"^FS";
										stringZPL +="^FO320,380^A1R,30,30^FD"+ partNumber + "^FS";
										
										stringZPL +="^FO280,20^A1R,30,30^FD"+"Description"+"^FS";
										stringZPL +="^FO280,330^A1R,30,30^FD"+":"+"^FS";
										stringZPL +="^FO280,380^A1R,30,30^FD"+ description + "^FS";
										
										stringZPL +="^FO240,20^A1R,30,30^FD"+"Vendor Code"+"^FS";
										stringZPL +="^FO240,330^A1R,30,30^FD"+":"+"^FS";
										stringZPL +="^FO240,380^A1R,30,30^FD"+ vendorCode + "^FS";
										
										stringZPL +="^FO200,20^A1R,30,30^FD"+"Vendor Name"+"^FS";
										stringZPL +="^FO200,330^A1R,30,30^FD"+":"+"^FS";
										stringZPL +="^FO200,380^A1R,30,30^FD"+ vendorName + "^FS";
										
										stringZPL +="^FO160,20^A1R,30,30^FD"+"Lot No"+"^FS";
										stringZPL +="^FO160,330^A1R,30,30^FD"+":"+"^FS";
										stringZPL +="^FO160,380^A1R,30,30^FD"+ lotNo + "^FS";
										
										stringZPL +="^FO120,20^A1R,30,30^FD"+"QTY"+"^FS";
										stringZPL +="^FO120,330^A1R,30,30^FD"+":"+"^FS";
										stringZPL +="^FO120,380^A1R,30,30^FD"+ qty + "^FS";
										
										stringZPL +="^FO80,20^A1R,28,28^FD"+"Manufactured Date"+"^FS";
										stringZPL +="^FO80,330^A1R,28,28^FD"+":"+"^FS";
										stringZPL +="^FO80,380^A1R,28,28^FD"+ manufacturedDate + "^FS";
										
										stringZPL +="^FO40,50^A1R,45,45^FD"+"Exp.Date"+"^FS";
                                        stringZPL +="^FO40,550^A1R,45,45^FD"+":"+"^FS";
                                        stringZPL +="^FO40,600^A1R,45,45^FD"+ endDate + "^FS";
										
										stringZPL +="^FO50,690^GB300,450,4^FS";
										stringZPL +="^FO170,690^GB0,450,4^FS";
										stringZPL +="^FO280,690^GB0,450,4^FS";
										stringZPL +="^FO170,910^GB110,0,4^FS";
										stringZPL +="^FO300,775^A1R,30,30^FD"+ "OQC" + "^FS";
										stringZPL +="^FO300,985^A1R,30,30^FD"+ "KHO" + "^FS";
										
										//20180820 추가
										stringZPL +="^FO25,850^BXR,4,200^FD"+ boxBarcode +"^FS";		//dataMatrix
										stringZPL +="^FO25,920^A1R,30,30^FD"+ boxBarcode + "^FS";
									}
									
								}else if(panelResult.getValue('LABEL_TYPE') == 'C1'){
									
									var itemCode = record.ITEM_NAME;
									var model = record.ITEM_MODEL
									var customItemCode = '';
									if(!Ext.isEmpty(record.CUSTOM_ITEM_CODE)) {
										customItemCode	= record.CUSTOM_ITEM_CODE;
									} else {
										customItemCode	= record.ITEM_NAME;
									}

									var dateOfManufacture = '';
									if(!Ext.isEmpty(record.PRODT_DATE)){
										dateOfManufacture = UniDate.getDbDateStr(record.PRODT_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(record.PRODT_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(record.PRODT_DATE).substring(6,8);//"2018-06-20";
									}
									var deliveryDate = '';
									if(!Ext.isEmpty(record.PACK_DATE)){
										deliveryDate = UniDate.getDbDateStr(record.PACK_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(record.PACK_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(record.PACK_DATE).substring(6,8);//"2018-06-20";
									}
									
									var quantity = record.SUM_QTY;
									var formatQuantity = quantity.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
									
									var labelCustom = record.LABEL_CUSTOM_NAME;
									
									var boxBarcode = record.BOX_BARCODE;
							
									
									var stringZPL = "";
									
									if(panelResult.getValue('DPI_GUBUN') == '1'){
									
										/* zt230 300dpi 용 */
										stringZPL += "^SEE:UHANGUL.DAT^FS";
										stringZPL += "^CW1,E:VERDANAB.TTF^CI28^FS";//Verdanab
										
										stringZPL += "^PW900";		//라벨 가로 크기관련
										stringZPL += "^LH55,0^FS";
										
										if(BsaCodeInfo.gsLotInitail == '1') {
											stringZPL +="^FO30,450^A1R,65,65^FD"+"JWORLD.,CO LTD"+"^FS";
										} else {
											stringZPL +="^FO30,450^A1R,65,65^FD"+"JWORLD VINA.,CO LTD"+"^FS";
										}
//										stringZPL +="^FO30,450^A1R,65,65^FD"+"JWORLD VINA.,CO LTD"+"^FS";
										stringZPL +="^FO120,20^GB690,1730,6^FS";
										stringZPL +="^FO120,600^GB690,0,6^FS";
										stringZPL +="^FO120,1160^GB690,0,6^FS";
										
										
										stringZPL +="^FO235,20^GB0,1140,6^FS";
										stringZPL +="^FO350,20^GB0,1140,6^FS";
										stringZPL +="^FO465,20^GB0,1730,6^FS";
										stringZPL +="^FO580,20^GB0,1140,6^FS";
										stringZPL +="^FO695,20^GB0,1140,6^FS";
										
										stringZPL +="^FO155,40^A1R,40,40^FD"+"QUANTITY"+"^FS";
										stringZPL +="^FO150,620^A1R,45,45^FD"+formatQuantity+"^FS";
										
										stringZPL +="^FO270,40^A1R,40,40^FD"+"DELIVERY DATE"+"^FS";
										stringZPL +="^FO265,620^A1R,45,45^FD"+deliveryDate+"^FS";
										
										stringZPL +="^FO385,40^A1R,40,40^FD"+"DATE OF MANUFACTURE"+"^FS";
										stringZPL +="^FO380,620^A1R,45,45^FD"+dateOfManufacture+"^FS";
										
										stringZPL +="^FO500,40^A1R,40,40^FD"+"CUSTOM ITEM CODE"+"^FS";
										stringZPL +="^FO495,620^A1R,45,45^FD"+customItemCode+"^FS";
										
										stringZPL +="^FO615,40^A1R,40,40^FD"+"MODEL"+"^FS";
										stringZPL +="^FO610,620^A1R,45,45^FD"+model+"^FS";
										
										
										
										stringZPL +="^FO730,40^A1R,40,40^FD"+"ITEM CODE"+"^FS";
										if(itemCode.length > 15){
											stringZPL +="^FO745,620^A1R,45,45^FD"+itemCode.substring(0, 15)+"^FS";
							
											stringZPL +="^FO705,620^A1R,45,45^FD"+itemCode.substring(15,31)+"^FS";
										}else{
											stringZPL +="^FO725,620^A1R,45,45^FD"+itemCode+"^FS";
										}
										
										
										stringZPL +="^FO150,1220^A1R,55,55^FD"+boxBarcode+"^FS";
										
										stringZPL +="^FO270,1360^BQ,2,7^FDQA,"+boxBarcode+"^FS";	//QR바코드
										
										var labelCustomArray = labelCustom.split(',');
											
										if(Ext.isEmpty(labelCustomArray[1])){
											stringZPL +="^FO620,1300^A1R,55,55^FD"+labelCustom+"^FS";
										}else{
											stringZPL +="^FO650,1300^A1R,55,55^FD"+labelCustomArray[0]+"^FS";
											stringZPL +="^FO590,1300^A1R,55,55^FD"+labelCustomArray[1]+"^FS";
										}
										
									}else{
									
										/* zt230 200dpi 용 */
										stringZPL += "^SEE:UHANGUL.DAT^FS";
						//				stringZPL += "^CW1,E:TIMESBD.TTF^CI28^FS";//"^CW1,E:MALGUNBD.TTF^CI28^FS";//"^CW1,E:TIMESBD.TTF^CI28^FS";	//TIMES NEW ROMAN 볼드
						//				stringZPL += "^CW1,E:VERDANA.TTF^CI28^FS";//Verdana
										stringZPL += "^CW1,E:VERDANAB.TTF^CI28^FS";//Verdanab
		//								stringZPL += "^CW1,E:MALGUNBD.TTF^CI28^FS";
		//								stringZPL += "^CW1,E:ARIAL.TTF^CI28^FS";
		//								stringZPL += "^CW1,E:MICROSS.TTF^CI28^FS";
		//								stringZPL += "^CW1,E:COURBD.TTF^CI28^FS";
										
										stringZPL += "^PW600";		//라벨 가로 크기관련
										stringZPL += "^LH10,10^FS";
										
										
										if(BsaCodeInfo.gsLotInitail == '1') {
											stringZPL +="^FO30,290^A1R,50,50^FD"+"JWORLD.,CO LTD"+"^FS";
										} else {
											stringZPL +="^FO30,290^A1R,50,50^FD"+"JWORLD VINA.,CO LTD"+"^FS";
										}
//										stringZPL +="^FO30,290^A1R,50,50^FD"+"JWORLD VINA.,CO LTD"+"^FS";
										stringZPL +="^FO100,10^GB460,1165,4^FS";
										stringZPL +="^FO100,390^GB460,0,4^FS";
										stringZPL +="^FO100,780^GB460,0,4^FS";
										
										
										stringZPL +="^FO178,10^GB0,770,4^FS";
										stringZPL +="^FO254,10^GB0,770,4^FS";
										stringZPL +="^FO330,10^GB0,1165,4^FS";
										stringZPL +="^FO406,10^GB0,770,4^FS";
										stringZPL +="^FO482,10^GB0,770,4^FS";
										
		//								^FT0,50^FDДо свидания^FS
		//								^FT0,50^FH^FD_D0_94_D0_BE _D1_81_D0_B2_D0_B8_D0_B4_D0_B0_D0_BD_D0_B8_D1_8F^FS
		//								stringZPL +="^FO140,20^A1R,25,25^FH^FD"+"До свидания"+"^FS";
		//								stringZPL +="^FO110,20^A1R,25,25^FD"+"До свидания"+"^FS";
		//								stringZPL +="^FO140,20^A1R,25,25^FH^FD"+"_D0_94_D0_BE _D1_81_D0_B2_D0_B8_D0_B4_D0_B0_D0_BD_D0_B8_D1_8F"+"^FS";
										
		//								stringZPL +="^FO110,20^A1R,25,25^FH^FD"+"(SỐ LƯỢNG)"+"^FS";
		//								stringZPL +="^FO140,20^A1R,25,25^FH^FD"+"До свидания"+"^FS";
		//								stringZPL +="^FO125,420^A1R,25,25^FH^FD"+"가나다라"+"^FS";
										
		//								stringZPL +="^FO110,20^A1R,25,25^FD"+"(SỐ LƯỢNG)"+"^FS";
										stringZPL +="^FO125,20^A1R,25,25^FD"+"QUANTITY"+"^FS";
										stringZPL +="^FO125,420^A1R,25,25^FD"+formatQuantity+"^FS";
										
		//								stringZPL +="^FO185,20^A1R,25,25^FD"+"(NGÀY GIAO HÀNG)"+"^FS";
										stringZPL +="^FO205,20^A1R,25,25^FD"+"DELIVERY DATE"+"^FS";
										stringZPL +="^FO205,420^A1R,25,25^FD"+deliveryDate+"^FS";
										
		//								stringZPL +="^FO260,20^A1R,25,25^FD"+"(NGÀY SẢN XUẤT)"+"^FS";
										stringZPL +="^FO280,20^A1R,25,25^FD"+"DATE OF MANUFACTURE"+"^FS";
										stringZPL +="^FO280,420^A1R,25,25^FD"+dateOfManufacture+"^FS";
										
										stringZPL +="^FO355,20^A1R,25,25^FD"+"CUSTOM ITEM CODE"+"^FS";
										stringZPL +="^FO355,420^A1R,25,25^FD"+customItemCode+"^FS";
										
										stringZPL +="^FO430,20^A1R,25,25^FD"+"MODEL"+"^FS";
										stringZPL +="^FO430,420^A1R,25,25^FD"+model+"^FS";
										
										
										
										stringZPL +="^FO505,20^A1R,25,25^FD"+"ITEM CODE"+"^FS";
										if(itemCode.length > 18){
											stringZPL +="^FO520,420^A1R,25,25^FD"+itemCode.substring(0, 18)+"^FS";
							
											stringZPL +="^FO490,420^A1R,25,25^FD"+itemCode.substring(18,36)+"^FS";
										}else{
											stringZPL +="^FO505,420^A1R,25,25^FD"+itemCode+"^FS";
										}
										
										
										stringZPL +="^FO125,825^A1R,35,35^FD"+boxBarcode+"^FS";
										
										stringZPL +="^FO200,915^BQ,2,5^FDQA,"+boxBarcode+"^FS";	//QR바코드
										
										var labelCustomArray = labelCustom.split(',');
											
										if(Ext.isEmpty(labelCustomArray[1])){
											stringZPL +="^FO415,845^A1R,50,50^FD"+labelCustom+"^FS";
										}else{
											stringZPL +="^FO445,845^A1R,50,50^FD"+labelCustomArray[0]+"^FS";
											stringZPL +="^FO385,845^A1R,50,50^FD"+labelCustomArray[1]+"^FS";
										}
									}
								}
								
								selected_printer.send(format_start + stringZPL + format_end);
//								Unilite.messageBox(stringZPL);
							})
						}else{
							Unilite.messageBox('<t:message code="system.label.sales.failure" default="실패"/>');	
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
		},{
			fieldLabel	: '<t:message code="system.label.sales.barcode" default="바코드"/>',
			name		: 'BARCODE',
			xtype		: 'uniTextfield',
			readOnly	: false,
			fieldStyle	: 'IME-MODE: inactive',				//IE에서만 적용 됨
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						if(!panelResult.getInvalidMessage()) {
							panelResult.setValue('BARCODE', '');
							return false;
						}
						var newValue = panelResult.getValue('BARCODE');
						if(!Ext.isEmpty(newValue)) {
							detailGrid.focus();
							fnEnterBarcode(newValue);
							panelResult.setValue('BARCODE', '');
						}
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.warehouse" default="창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType   : 'OU',
			allowBlank	: false,
			holdable	: 'hold'
		},{
			fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
			name		: 'LABEL_CUSTOM',
			xtype		: 'uniCombobox',
			comboType	: 'AU', 
			comboCode	: 'S105',
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(newValue)){
						panelResult.setValue('LABEL_TYPE'	,combo.valueCollection.items[0].data.refCode1);
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.labeltype" default="라벨종류"/>',
			name		: 'LABEL_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU', 
			comboCode	: 'S106',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					var detailDatas = detailStore.data.items;
					
					if(!Ext.isEmpty(detailDatas)){
						Ext.each(detailDatas,function(data,index){
							data.set('LABEL_TYPE',newValue);
						})
					}
				}
			}
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.sales.reset2" default="초기화"/>',
			id		: 'btnReset',
			width	: 80,
			margin	: '0 0 1 20', 
			handler	: function() {
				panelResult.setAllFieldsReadOnly(false);
				panelResult.setValue('BOX_BARCODE', '');
				Ext.getCmp('btnPrint').disable();
				UniAppManager.setToolbarButtons(['reset'], true);
				UniAppManager.setToolbarButtons(['newData'], false);
				detailGrid.reset();
				detailStore.clearData();
				panelResult.getForm().wasDirty = false;
				panelResult.resetDirtyStatus();
				UniAppManager.setToolbarButtons('save', false);
				panelResult.getField('WH_CODE').focus();
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.pono2" default="P/O 번호"/>',
			name		: 'PO_NO',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					var detailDatas = detailStore.data.items;
					
					if(!Ext.isEmpty(detailDatas)){
						Ext.each(detailDatas,function(data,index){
							data.set('PO_NO',newValue);
						})
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.boxqty" default="박스수량"/>',
			name		: 'BOX_QTY',
			xtype		: 'uniNumberfield',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					var detailDatas = detailStore.data.items;
					
					if(!Ext.isEmpty(detailDatas)){
						Ext.each(detailDatas,function(data,index){
							data.set('BOX_QTY',newValue);
						})
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}

					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable)) {
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
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record)	{
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});
	
	
	
	
	
	/** BOX포장 정보를 가지고 있는 Grid
	 */
	//마스터 모델 정의
	Unilite.defineModel('str800ukrvDetailModel', {
		fields: [
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'		,type: 'string', allowBlank:false},
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string', allowBlank:false},
			{name: 'BOX_BARCODE'	,text: 'BOX<t:message code="system.label.sales.number" default="번호"/>'		,type: 'string'		, allowBlank: true },
			{name: 'PACK_DATE'		,text: '<t:message code="system.label.sales.packdate" default="포장일"/>'		,type: 'uniDate'	, allowBlank: false},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.sales.spec" default="규격"/>'			,type: 'string'},
			{name: 'LOT_NO'			,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'		,type: 'string', allowBlank:false},
			{name: 'QTY'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'		, allowBlank: true },
			{name: 'UNIT'			,text: '<t:message code="system.label.sales.unit" default="단위"/>'			,type: 'string'		, allowBlank: true , comboType: 'AU', comboCode: 'B013'},
			{name: 'INOUT_NUM'		,text: '<t:message code="system.label.sales.tranno" default="수불번호"/>'		,type: 'string'		, allowBlank: true },
			{name: 'INOUT_SEQ'		,text: '<t:message code="system.label.sales.transeq" default="수불순번"/>'		,type: 'string'		, allowBlank: true },
			{name: 'REMARK'			,text: '<t:message code="system.label.sales.remarks" default="비고"/>'		,type: 'string'		, allowBlank: true },
			{name: 'WH_CODE'		,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'		,type: 'string'		, allowBlank: false },
			{name: 'LABEL_CUSTOM'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'		,type: 'string'		, allowBlank: false },
			{name: 'LABEL_TYPE'		,text: '<t:message code="system.label.sales.labeltype" default="라벨종류"/>'	,type: 'string'		, allowBlank: false },
			{name: 'PO_NO'			,text: '<t:message code="system.label.sales.pono2" default="P/O 번호"/>'		,type: 'string'},
			{name: 'BOX_QTY'		,text: '<t:message code="system.label.sales.boxqty" default="박스수량"/>'		,type: 'int'},
			//20190117 추가
			{name: 'PO_TYPE'		,text: 'PO TYPE'	, type: 'string'}
		]
	});
	//마스터 스토어 정의
	var detailStore = Unilite.createStore('str800ukrvDetailStore', {
		model	: 'str800ukrvDetailModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: directProxy,
		loadStoreRecords: function() {
			var param = panelResult.getValues();
			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success)	{
						panelResult.setLoadRecord(records[0]);
					}
				}
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			
			var boxBarcode = panelResult.getValue('BOX_BARCODE');
			Ext.each(list, function(record, index) {
				if(record.data['BOX_BARCODE'] != boxBarcode) {
					record.set('BOX_BARCODE', boxBarcode);
				}
			})
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("BOX_BARCODE", master.BOX_BARCODE);
						Ext.getCmp('btnPrint').enable();
						
						//3.기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						
						if(detailStore.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('str800ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				// Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(Ext.isEmpty(records)) {
					return false;
				}
				Ext.each(records, function(record, index){
					panelResult.setValue('PO_NO'	, record.get('PO_NO'));
					panelResult.setValue('BOX_QTY'	, record.get('BOX_QTY'));
				});
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});
	//마스터 그리드 정의
	var detailGrid = Unilite.createGrid('str800ukrvGrid', {
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer	: false
		},
		store	: detailStore,
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: true },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true} ],
		columns	: [
				{ dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
				{ dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
				{ dataIndex: 'BOX_BARCODE'		, width: 100, hidden: true},
				{ dataIndex: 'PACK_DATE'		, width: 100, hidden: true},
				{ dataIndex: 'ITEM_CODE'		, width: 130,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.totalamount" default="합계"/>');
					},
					editor: Unilite.popup('DIV_PUMOK_G', {
						textFieldName	: 'ITEM_CODE',
						DBtextFieldName	: 'ITEM_CODE',
						autoPopup		: true,
						listeners: {
							'onSelected': {
								fn: function(records, type) {
									console.log('records : ', records);
									Ext.each(records, function(record,i) {
										if(i==0) {
											detailGrid.setItemData(record, false, detailGrid.uniOpt.currentRecord);
										} else {
											UniAppManager.app.onNewDataButtonDown();
											detailGrid.setItemData(record, false, detailGrid.getSelectedRecord());
										}
									}); 
								},
								scope: this
							},
							'onClear': function(type) {
								detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
							},
							'applyextparam': function(popup){
								var divCode = panelResult.getValue('DIV_CODE');
								popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': UserInfo.divCode, 'POPUP_TYPE': 'GRID_CODE'});
							}
						}
					})
				},
				{ dataIndex: 'ITEM_NAME'		, width: 150,
					editor: Unilite.popup('DIV_PUMOK_G', {
						autoPopup	: true,
						listeners	: {
							'onSelected': {
								fn: function(records, type) {
										console.log('records : ', records);
										Ext.each(records, function(record,i) {
											if(i==0) {
												detailGrid.setItemData(record, false, detailGrid.uniOpt.currentRecord);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												detailGrid.setItemData(record, false, detailGrid.getSelectedRecord());
											}
										}); 
								},
								scope: this
							},
							'onClear': function(type) {
								detailGrid.setItemData(null, true, detailGrid.uniOpt.currentRecord);
							},
							'applyextparam': function(popup){
								var divCode = panelResult.getValue('DIV_CODE');
								popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': UserInfo.divCode, 'POPUP_TYPE': 'GRID_CODE'});
							}
						}
					})
				},	
				{ dataIndex: 'SPEC'				, width: 133},
				{ dataIndex: 'LOT_NO'			, width: 120,
					editor: Unilite.popup('LOTNO_G', {
						textFieldName: 'LOTNO_CODE',
						DBtextFieldName: 'LOTNO_CODE',
						extParam: {SELMODEL: 'MULTI', DIV_CODE: UserInfo.divCode, POPUP_TYPE: 'GRID_CODE'},
						listeners: {
							'onSelected': {
								fn: function(records, type) {
									console.log('records : ', records);
									var rtnRecord;
									Ext.each(records, function(record,i) {
										if(i==0){
											rtnRecord = detailGrid.uniOpt.currentRecord
										}else{
											rtnRecord = detailGrid.getSelectedRecord()
										}
										rtnRecord.set('LOT_NO'	, record['LOT_NO']);
										rtnRecord.set('QTY'		, record['INSTOCK_Q']);
									}); 
								},
								scope: this
							},
							'onClear': function(type) {
								var rtnRecord = detailGrid.uniOpt.currentRecord;
								rtnRecord.set('LOT_NO'	, '');
								rtnRecord.set('QTY'		, 0);
							},
							applyextparam: function(popup){
								var record = detailGrid.getSelectedRecord();
								var divCode = panelResult.getValue('DIV_CODE');
//								var customCode = panelResult.getValue('CUSTOM_CODE'); 
//								var customName = panelResult.getValue('CUSTOM_NAME'); 
								var itemCode = record.get('ITEM_CODE');
								var itemName = record.get('ITEM_NAME');
								var whCode = record.get('WH_CODE');
								var whCellCode = record.get('WH_CELL_CODE');
								var stockYN = 'Y'
								popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode, 'S_WH_CELL_CODE': whCellCode, 'STOCK_YN': stockYN});
							}
						}
					})
				},
				{ dataIndex: 'QTY'			, width: 100, hidden: false		, summaryType: 'sum'},
				{ dataIndex: 'UNIT'			, width: 100, hidden: false},
				{ dataIndex: 'INOUT_NUM'	, width: 100, hidden: true},
				{ dataIndex: 'INOUT_SEQ'	, width: 100, hidden: true},
				{ dataIndex: 'REMARK'		, width: 200, hidden: false},
				{ dataIndex: 'WH_CODE'		, width: 200, hidden: true},
				{ dataIndex: 'LABEL_CUSTOM'	, width: 100, hidden: true}, 
				{ dataIndex: 'LABEL_TYPE'	, width: 100, hidden: true}, 
				{ dataIndex: 'PO_NO'		, width: 100, hidden: true}, 
				{ dataIndex: 'BOX_QTY'		, width: 100, hidden: true},
				//20190117 추가
				{ dataIndex: 'PO_TYPE'		, width: 100, hidden: true}
		], 
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom){
					if (UniUtils.indexOf(e.field, ['SPEC', 'PACK_DATE'])) {
						return false;
					} else {
						return true;
					}

				} else {
					if (UniUtils.indexOf(e.field, [/*'QTY', */'REMARK'])) {
						return true;
					} else {
						return false;
					}
				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'	,'');
				grdRecord.set('ITEM_NAME'	,'');
				grdRecord.set('SPEC'		,''); 
				grdRecord.set('UNIT'		,'');
			} else {
				grdRecord.set('ITEM_CODE'	, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'	, record['ITEM_NAME']);
				grdRecord.set('SPEC'		, record['SPEC']); 
				grdRecord.set('UNIT'		, record['STOCK_UNIT']);
			}
		}
	});





	/** BOX정보를 검색하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//검색창 폼 정의
	var inNoSearch = Unilite.createSearchForm('inNoSearchForm', {
		layout	: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,	
			value		: UserInfo.divCode,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		}, {
			 fieldLabel		: '<t:message code="system.label.sales.packdate" default="포장일"/>',
			 xtype			: 'uniDateRangefield',
			 startFieldName	: 'PACK_DATE_FR',
			 endFieldName	: 'PACK_DATE_TO',
			 startDate		: UniDate.get('startOfMonth'),
			 endDate		: UniDate.get('today'),	 
			 width			: 315
		}, {
			fieldLabel	: '<t:message code="system.label.sales.receiptwarehouse" default="입고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType   : 'OU'
			
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						inNoSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						inNoSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': inNoSearch.getValue('DIV_CODE')});
				}
			}
		}), {
			fieldLabel	: 'BOX<t:message code="system.label.sales.number" default="번호"/>',
			name		: 'BOX_BARCODE',
			xtype		: 'uniTextfield'
		}]
	}); // createSearchForm
	//검색창 모델 정의
	Unilite.defineModel('inNoMasterModel', {
		fields: [
			{name: 'BOX_BARCODE'	, text: 'BOX<t:message code="system.label.sales.number" default="번호"/>'		, type: 'string'},
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'	, type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>'		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.item" default="품목"/>'			, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.sales.spec" default="규격"/>'			, type: 'string'},
			{name: 'PACK_DATE'		, text: '<t:message code="system.label.sales.packdate" default="포장일"/>'		, type: 'uniDate'},
			{name: 'QTY'			, text: '<t:message code="system.label.sales.qty" default="수량"/>'			, type: 'uniQty'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.sales.warehouse" default="창고"/>'		, type: 'string', comboType : 'OU'},
			{name: 'LOT_NO'			, text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'		, type: 'string'},
			
			{name: 'LABEL_CUSTOM'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'		, type: 'string'},
			{name: 'LABEL_TYPE'		, text: '<t:message code="system.label.sales.labeltype" default="라벨종류"/>'	, type: 'string'},
			//20190117 추가
			{name: 'PO_TYPE'		, text: 'PO TYPE'	, type: 'string'}
		]
	});
	//검색창 스토어 정의
	var inNoMasterStore = Unilite.createStore('inNoMasterStore', {
		model	: 'inNoMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read : 'str800ukrvService.selectInNumMasterList'
			}
		},
		loadStoreRecords : function()	{
			var param= inNoSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색창 그리드 정의
	var orderNoMasterGrid = Unilite.createGrid('str800ukrvInNoMasterGrid', {
		// title: '기본',
		layout	: 'fit',	
		store	: inNoMasterStore,
		uniOpt	: {
			useRowNumberer: false
		},
		columns	: [
			{ dataIndex: 'BOX_BARCODE'	, width: 100 },
			{ dataIndex: 'COMP_CODE'	, width: 66, hidden: true},
			{ dataIndex: 'DIV_CODE'		, width: 66, hidden: true},
			{ dataIndex: 'ITEM_CODE'	, width: 120 },
			{ dataIndex: 'ITEM_NAME'	, width: 133 },
			{ dataIndex: 'SPEC'			, width: 133 },
			{ dataIndex: 'PACK_DATE'	, width: 73},
			{ dataIndex: 'QTY'	 		, width: 100 },
			{ dataIndex: 'WH_CODE'		, width: 93}, 
			{ dataIndex: 'LOT_NO'		, width: 100 }, 
			{ dataIndex: 'LABEL_CUSTOM'	, width: 100 , hidden:true}, 
			{ dataIndex: 'LABEL_TYPE'	, width: 100 , hidden:true }
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				searchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelResult.setValues({'DIV_CODE'		: record.get('DIV_CODE')
								 , 'PACK_DATE'		: record.get('PACK_DATE')
								 , 'BOX_BARCODE'	: record.get('BOX_BARCODE')
								 , 'WH_CODE'		: record.get('WH_CODE')
								 , 'LABEL_CUSTOM'	: record.get('LABEL_CUSTOM')
								 , 'LABEL_TYPE'		: record.get('LABEL_TYPE')
								 });
		}
	});
	//검색창 메인 (openSearchInfoWindow)
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.receiptnosearch" default="입고번호검색"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [inNoSearch, orderNoMasterGrid],
				tbar	:['->',{
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						inNoMasterStore.loadStoreRecords();
					},
					disabled: false
				}, {
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						searchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt)	{
						inNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						inNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					show: function( panel, eOpts )	{
						inNoSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						inNoSearch.setValue('WH_CODE'		, panelResult.getValue('WH_CODE'));
						inNoSearch.setValue('PACK_DATE_FR'	, UniDate.get('startOfMonth', panelResult.getValue('PACK_DATE')));
						inNoSearch.setValue('PACK_DATE_TO'	, panelResult.getValue('PACK_DATE'));
					}
				}
			})
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
	}
	
	
	
	
	
	/** main app
	 */
	Unilite.Main({
		id			: 'str800ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid
			]	
		}],
		fnInitBinding: function() {
			setup_web_print();
			Ext.getCmp('btnPrint').disable();
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['newData'], false);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			var boxBarcode = panelResult.getValue('BOX_BARCODE');
			if(Ext.isEmpty(boxBarcode)) {
				openSearchInfoWindow() 
			} else {
				if(!panelResult.getInvalidMessage()) return false;
				detailStore.loadStoreRecords();	
				UniAppManager.setToolbarButtons(['newData'], false);
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function(newValue)	{
			if(!this.checkForNewDetail()) return false;
			/** Detail Grid Default 값 설정
			 */
			var barcodeItemCode	= ''; 
			var barcodeItemName	= ''; 
			var barcodeSpec		= ''; 
			var barcodeUnit		= ''; 
			var barcodeLotNo	= ''; 
			var barcodeInoutQ	= ''; 
			var barcodeInoutNum	= ''; 
			var barcodeInoutSeq	= 0; 
			var barcodeRemark	= ''; 
			
			if(!Ext.isEmpty(newValue)) {
				barcodeItemCode	= newValue.split('|')[0].toUpperCase();
				barcodeItemName	= newValue.split('|')[3];
				barcodeSpec		= newValue.split('|')[4];
				barcodeUnit		= newValue.split('|')[5];
				barcodeLotNo	= newValue.split('|')[1].toUpperCase();
				barcodeInoutQ	= newValue.split('|')[2];
				barcodeInoutNum	= newValue.split('|')[6];
				barcodeInoutSeq	= newValue.split('|')[7];
				barcodeRemark	= newValue.split('|')[8];
			}
			
			var boxBarcode = '';
			if(!Ext.isEmpty(panelResult.getValue('BOX_BARCODE')))	{
				boxBarcode = panelResult.getValue('BOX_BARCODE');
			}

			var packDate = '';
			if(!Ext.isEmpty(panelResult.getValue('PACK_DATE')))	{
				packDate = panelResult.getValue('PACK_DATE');
			} else {
				packDate = new Date();
			}
			
			var whCode = '';
			if(!Ext.isEmpty(panelResult.getValue('WH_CODE')))	{
				whCode = panelResult.getValue('WH_CODE');
			}
			
			var labelCustom = '';
			if(!Ext.isEmpty(panelResult.getValue('LABEL_CUSTOM')))	{
				labelCustom = panelResult.getValue('LABEL_CUSTOM');
			}	
			
			var labelType = '';
			if(!Ext.isEmpty(panelResult.getValue('LABEL_TYPE')))	{
				labelType = panelResult.getValue('LABEL_TYPE');
			}	
			var r = {
				COMP_CODE	: UserInfo.compCode,
				DIV_CODE	: UserInfo.divCode,
				BOX_BARCODE	: boxBarcode,
				PACK_DATE	: packDate,
				ITEM_CODE	: barcodeItemCode,
				ITEM_NAME	: barcodeItemName,
				SPEC		: barcodeSpec,
				LOT_NO		: barcodeLotNo,
				QTY			: barcodeInoutQ,
				UNIT		: barcodeUnit,
				WH_CODE		: whCode,
				INOUT_NUM	: barcodeInoutNum,	
				INOUT_SEQ	: barcodeInoutSeq,
				REMARK		: barcodeRemark,
				LABEL_CUSTOM: labelCustom,
				LABEL_TYPE	: labelType
			};
			
			detailGrid.createRow(r, null, /*'ITEM_CODE',*/ -1);			//데이터가 많을 경우, 제일 아래에 행이 추가되면 포커스가 barcode로 가지 않음 -> 제일 위에 행 추가하도록 수정 
			panelResult.setAllFieldsReadOnly(true);
			panelResult.getField('BARCODE').focus();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitBinding();
			panelResult.getField('WH_CODE').focus();
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
				
			}else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. /n삭제 하시겠습니까?"/>')) {
				detailGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
//						if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
//							Unilite.messageBox(Msg.sMS042); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
//							return false;
//						}
						/*---------삭제전 로직 구현 끝----------*/
						
						if(deletable){
							detailGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
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
		setDefault: function() {
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('PACK_DATE', new Date());
			
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		},
		checkForNewDetail:function() {
			return panelResult.setAllFieldsReadOnly(true);
		},
		fnGetWkShopDivCode: function(wkShopCode){	//작업장의 사업장 가져오기
			var wkDivCode ='';
//			Ext.each(BsaCodeInfo.gsWkShopDivCode, function(item, i)	{
				if(item['S_CODE4'] == wkShopCode) {
					wkDivCode = item['S_CODE2'];
				}				
//			});
			return wkDivCode;
		},
		cbGetClosingInfo: function(params){
			gsMonClosing = params.gsMonClosing
			gsDayClosing = params.gsDayClosing
		}
		
		
	});



	//바코드 입력 로직 (lot_no)
	function fnEnterBarcode(newValue) {
		var barcodeItemCode	= newValue.split('|')[0].toUpperCase();
		var barcodeLotNo	= newValue.split('|')[1];
		var barcodeInoutQ	= newValue.split('|')[2];
		var flag = true;
		
		if(Ext.isEmpty(barcodeLotNo)/* && Ext.isEmpty(barcodeInoutQ)*/) {
			barcodeItemCode	= '';
			barcodeLotNo	= newValue.split('|')[0].toUpperCase();;
			barcodeInoutQ	= '';
			
		} else {
			barcodeLotNo = barcodeLotNo.toUpperCase();
		}
		
		//동일한 LOT_NO 입력되었을 경우 처리
		var records  = detailStore.data.items;		//비교할 records 구성
		Ext.each(records, function(record, i) {
			if(record.get('LOT_NO').toUpperCase() == barcodeLotNo) {
				beep();
				gsText = '<t:message code="system.label.sales.message005" default="동일한  Lot No.(이)가 이미 등록되었습니다."/>'
				openAlertWindow(gsText);
				panelResult.getField('BARCODE').focus();
				flag = false;
				return false;
			}
		});
		
		
		//LOT_NO만 입력되었을 때, ITEM_CODE가져오는 로직 추가(20181114)
		//현재 프로그램에서는 선입선출 체크하지 않음
		var param = {
			ITEM_CODE		: barcodeItemCode,
			LOT_NO			: barcodeLotNo,
			WH_CODE			: panelResult.getValue('WH_CODE'),
			DIV_CODE		: panelResult.getValue('DIV_CODE'),
			GSFIFO			: 'N'
		}
		if(Ext.isEmpty(barcodeItemCode)) {
			str800ukrvService.getItemInfo(param, function(itemInfo, response){
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
						fnGetBarcodeInfo(records, param, flag);
					}
				}
			})
		} else {
			fnGetBarcodeInfo(records, param, flag);
		}
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



	function fnGetBarcodeInfo(records, param, flag) {
		//동일한ITEM_CODE만 입력되도록 처리
		if(records.length > 0) {
			Ext.each(records, function(record, i) {
				if(record.get('ITEM_CODE').toUpperCase() != param.ITEM_CODE) {
					beep();
					gsText = '<t:message code="system.message.sales.datacheck021" default="같은 품목만 박스포장이 가능합니다."/>'
					openAlertWindow(gsText);
					panelResult.getField('BARCODE').focus();
					flag = false;
					return false;
				}
			});
		}
		
		if(flag) {
			str105ukrvService.getFifo(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					if(!Ext.isEmpty(provider[0].ERR_MSG)) {
						Unilite.messageBox(provider[0].ERR_MSG);
						panelResult.getField('BARCODE').focus();
						return false;
					};
					UniAppManager.app.onNewDataButtonDown(provider[0].NEWVALUE);
				}
				panelResult.getField('BARCODE').focus();
			});
		}
	}



	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			//Unilite.messageBox(type+ ' : ' + fieldName+ ' : ' +newValue+ ' : ' +oldValue+ ' : ' +record)
			var rv = true;
			switch(fieldName) {
//				case "INOUT_SEQ" :
//					if(newValue <= 0 && !Ext.isEmpty(newValue))	{
//						rv=Msg.sMB076;
//						break;
//					}
//					break;
//				
//				case "INOUT_Q" :	//입고량
//					if(newValue < 0 && !Ext.isEmpty(newValue))	{
//						rv=Msg.sMB076;
//						break;
//					}
//					var notinQ = record.get('NOTIN_Q');
//					var originQ = record.get('ORIGINAL_Q'); 
//					if(newValue > notinQ + originQ ){
//						rv = '<t:message code="unilite.msg.sMS222" default="입고량은 미입고량을 초과할수 없습니다." />'
//						break;
//					}else{
//						var sInvPrice = record.get('BASIS_P');	
//						record.set('INOUT_FOR_O', sInvPrice * newValue);
//						break;
//					}
//				case "LOT_NO" :	////구현해야함
//					break;
			}	
			
			return rv;
		}
	}); // validator
}
</script>
