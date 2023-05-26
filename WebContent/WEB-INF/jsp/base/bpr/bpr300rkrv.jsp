<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr300rkrv"  >

	<t:ExtComboStore comboType="BOR120" pgmId="bpr300rkrv"  />		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />				<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="S105" />				<!-- 라벨거래처 -->
	<t:ExtComboStore comboType="AU" comboCode="S106" />				<!-- 라벨종류 -->
	<t:ExtComboStore comboType="OU" />								<!-- 창고-->
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
function strFm(number, width) {
	number = number + '';
	return number.length >= width ? number : new Array(width - number.length + 1).join('0') + number;
}
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
	Unilite.messageBox ("Printing complete");
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
//라벨출력 순서를 위해 delaytime 부여
function sendDataToPrint(ms, prinfText){
	var start = new Date().getTime();var end=start;
	while(end < start + ms) {
		end = new Date().getTime();
	}
	selected_printer.send(prinfText);
}
/* zebra printer 관련 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   */

var BsaCodeInfo = {
	gsWorker		: '${gsWorker}',		//라벨출력에 인쇄될 작업자 정보
	gsSelectLabel	: '${gsSelectLabel}',	//출력할 라벨 선택
	gsLotInitail	: '${gsLotInitail}',		//LOT 이니셜
	gsReportGubun : '${gsReportGubun}'	// 레포트 구분
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
var dyehPrintHiddenYn = true;
if(UserInfo.deptName == '(주)제이월드'){
	dyehPrintHiddenYn = false;
}
function appMain() {
	Unilite.defineModel('bpr300rkrvModel', {
		fields: [
			{name: 'WH_NAME'		, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',		type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.inventory.item" default="품목"/>',				type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',		type: 'string', maxLength: 100},
			{name: 'SPEC'			, text: '<t:message code="system.label.inventory.spec" default="규격"/>',				type: 'string'},
	  		{name: 'LOT_NO'			, text: '<t:message code="system.label.base.lotno" default="LOT번호"/>',				type: 'string'},
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',	type: 'string'},
			{name: 'STOCK'			, text: '<t:message code="system.label.base.inventoryqty2" default="재고수량"/>',		type: 'uniQty'},
			{name: 'PACK_QTY'		, text: '<t:message code="system.label.base.qty" default="수량"/>',					type: 'uniQty'},
			{name: 'LABEL_QTY'		, text: 'Label Qty.',	type: 'uniQty'},
			//{name: 'REMARK'		, text: '<t:message code="system.label.inventory.remarks" default="비고"/>',			type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.inventory.division" default="사업장"/>',		type: 'string'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',		type: 'string'},
			{name: 'DATE'			, text: '<t:message code="system.label.base.caldate" default="일자"/>',				type: 'uniDate'},
			{name: 'END_DATE'		, text: 'END_DATE',		type: 'string'},
			//20181012 추가
			{name: 'ITEM_ACCOUNT'	, text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',			type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'QR_CODE'		, text: 'QR_CODE',			type: 'string'},
			{name: 'SERIAL_NO'		, text: 'SERIAL_NO',		type: 'string'}


		]
	});

	var directMasterStore1 = Unilite.createStore('bpr300rkrvMasterStore1',{
		model: 'bpr300rkrvModel',
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api	: {
				read: 'bpr300rkrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				Ext.getCmp('btnPrint').disable();
			}
		}
	});

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
		   	layout: {type: 'uniTable', columns: 1},
		   	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				child:'WH_CODE',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType   : 'OU',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.base.account" default="계정"/>',
				name:'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					validateBlank: false,
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ITEM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ITEM_NAME', newValue);
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
				xtype:'uniTextfield',
				fieldLabel : '<t:message code="system.label.base.lotno" default="LOT번호"/>',
				name:'LOT_NO',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('LOT_NO', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 8
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			child:'WH_CODE',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			comboType : 'OU',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.base.account" default="계정"/>',
			name:'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B020',
			colspan: 5,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},{
			xtype : 'component',
			width : 95
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			validateBlank: false,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),
		{
			xtype:'uniTextfield',
			fieldLabel : '<t:message code="system.label.base.lotno" default="LOT번호"/>',
			name:'LOT_NO',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('LOT_NO', newValue);
				}
			}
		},{
			xtype : 'component',
			width : 95
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.base.labelprint" default="라벨출력"/>',
			id		: 'btnPrint',
			width	: 80,
//			margin	: '0 0 0 50',
			handler	: function() {

				var selectedDetails = masterGrid.getSelectedRecords();

				if(Ext.isEmpty(selectedDetails)){
					return;
				}

				if(available_printers == null)	{
					Unilite.messageBox('An error occurred while printing. Please try again.');
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
								Unilite.messageBox('<t:message code="system.label.purchase.success" default="성공"/>');
							}

							var itemCode = dataRaw.ITEM_CODE;
							var itemName = dataRaw.ITEM_NAME;
							var spec = dataRaw.SPEC;
							var stockUnit = dataRaw.STOCK_UNIT;//"EA";
							var prodtDate = '';
							if(!Ext.isEmpty(dataRaw.DATE)){
								if(UniDate.getDbDateStr(dataRaw.DATE).length == 8){
									prodtDate=UniDate.getDbDateStr(dataRaw.DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.DATE).substring(6,8);//"2018-06-20";
								}
							}

							var endDate = '';
							if(!Ext.isEmpty(dataRaw.END_DATE)){
								if(UniDate.getDbDateStr(dataRaw.END_DATE).length == 8){
									endDate=UniDate.getDbDateStr(dataRaw.END_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.END_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.END_DATE).substring(6,8);//"2018-12-20";
								}
							}
							var goodWorkQ = dataRaw.PACK_QTY;
							var formatGoodWorkQ = goodWorkQ.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
							var prodtPrsnName = dataRaw.PRODT_PRSN_NAME;
							if(Ext.isEmpty(prodtPrsnName)) {
								prodtPrsnName = ''
							}

							var pqcName = dataRaw.PQC_NAME;

							var lotNo = dataRaw.LOT_NO;//"A18062000037";


							var DataMatrix = itemCode + "|" + lotNo + "|" + goodWorkQ;

							var waterMarkCheckV = UniDate.getDbDateStr(dataRaw.DATE).substring(4, 6);
							var labelQty = dataRaw.LABEL_QTY;

							var stringZPL = "";

							if(panelResult.getValue('DPI_GUBUN') == '1'){
								/* zt230 300dpi 용*/
								stringZPL += "^SEE:UHANGUL.DAT^FS";
								stringZPL += "^CW1,E:TIMESBD.TTF^CI28^FS";//"^CW1,E:MALGUNBD.TTF^CI28^FS";//"^CW1,E:TIMESBD.TTF^CI28^FS";	//TIMES NEW ROMAN 볼드
								stringZPL += "^PW900";		//라벨 가로 크기관련
								stringZPL += "^LH110,15^FS";

								if(dataRaw.ITEM_ACCOUNT == '00' || dataRaw.ITEM_ACCOUNT == '10' || dataRaw.LOT_NO.substring(0,1) == 'M' || dataRaw.LOT_NO.substring(0,1) == 'F') {	//20181123 'F'조건 추가
									if(BsaCodeInfo.gsSelectLabel == '2') {
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

										if(BsaCodeInfo.gsLotInitail == '1') {
											stringZPL +="^FO230,10^AUN,10,10^FD"+"QC-JWORLD"+"^FS";
										} else {
											stringZPL +="^FO155,10^AUN,10,10^FD"+"QC-JWORLD VINA"+"^FS";
										}

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
										stringZPL +="^FO270,235^A1N,40,40^FD"+prodtDate+"^FS";
										stringZPL +="^FO20,295^A1N,40,40^FD"+"Qty"+"^FS";
										stringZPL +="^FO270,295^A1N,40,40^FD"+formatGoodWorkQ+"^FS";
										stringZPL +="^FO20,355^A1N,40,40^FD"+"Worker"+"^FS";
										stringZPL +="^FO270,355^A1N,40,40^FD"+prodtPrsnName+"^FS";
										stringZPL +="^FO20,415^A1N,40,40^FD"+"Weight"+"^FS";

										stringZPL +="^FO70,475^BXN,4,200^FD"+DataMatrix+"^FS";
										stringZPL +="^FO270,470^AVN,25,25^FD"+lotNo+"^FS";

									} else {
										if(BsaCodeInfo.gsSelectLabel == '2') {
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

											if(BsaCodeInfo.gsLotInitail == '1') {
												stringZPL +="^FO230,10^AUN,10,10^FD"+"QC-JWORLD"+"^FS";
											} else {
												stringZPL +="^FO155,10^AUN,10,10^FD"+"QC-JWORLD VINA"+"^FS";
											}

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
											stringZPL +="^FO270,355^A1N,40,40^FD"+prodtPrsnName+"^FS";
											stringZPL +="^FO20,415^A1N,40,40^FD"+"Weight"+"^FS";

											stringZPL +="^FO70,475^BXN,4,200^FD"+DataMatrix+"^FS";
											stringZPL +="^FO270,470^AVN,25,25^FD"+lotNo+"^FS";

										} else {
											var partNumber		= dataRaw.ITEM_NAME;
	//										var description = '';
											var specification	= dataRaw.SPEC;
											if(Ext.isEmpty(Ext.getCmp('poType').getChecked()[0].inputValue)) {
												var potype		= 'E1';									//고정값
											} else {
												var potype		= Ext.getCmp('poType').getChecked()[0].inputValue;									//고정값
											}
											var date			= UniDate.getDbDateStr(dataRaw.DATE).substring(2, UniDate.getDbDateStr(dataRaw.DATE).length);
											var lotNo			= 'A1' + date + '01';		//'A1' + 날짜  + '01'
											var qty				= dataRaw.PACK_QTY;

											if(BsaCodeInfo.gsLotInitail == '1') {
												var vendorName	= 'JWORLD';							//고정값
											} else {
												var vendorName	= 'JWORLD VINA';					//고정값
											}
											var vendorCode		= 'DXRX';								//고정값

											var vItemCode		= dataRaw.ITEM_CODE;
											var vLotNo			= dataRaw.LOT_NO;
											var itemDataMatrix	= vItemCode + "|" + vLotNo + "|" + qty;

											var sumQty			= qty;
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
												endDate = UniDate.add(dataRaw.DATE, {months: + 12});
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
											stringZPL +="^FO220,355^A1R,30,25^FD"+ qty + "^FS";

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
									}
								} else if(dataRaw.LOT_NO.substring(0,1) != 'M' && dataRaw.LOT_NO.substring(0,1) != 'F'){	//20181123 'F'조건 추가
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
									if(dataRaw.LOT_NO.substring(0,1) == 'A' || dataRaw.LOT_NO.substring(0,1) == 'R'){	//20181123 'R'조건 추가
										stringZPL +="^FO0,0^GB735,560,6^FS";

										stringZPL +="^FO0,70^GB735,0,6^FS";

										stringZPL +="^FO0,160^GB735,0,6^FS";
										stringZPL +="^FO0,230^GB735,0,6^FS";
										stringZPL +="^FO0,300^GB735,0,6^FS";
										stringZPL +="^FO0,370^GB735,0,6^FS";
										stringZPL +="^FO0,440^GB735,0,6^FS";

										stringZPL +="^FO230,70^GB0,370,6^FS";				//가운데 선

										//글자부분 시작
										stringZPL +="^FO200,10^AUN,10,10^FD"+"Item Description"+"^FS";
										stringZPL +="^FO20,100^A1N,40,40^FD"+"Item Name"+"^FS";
										if(itemName.length > 15){	// 글씨가 클때는 13이 적당
											stringZPL +="^FO270,80^A1N,38,38^FD"+itemName.substring(0, 15)+"^FS";		//글씨가 작을때는 18이 적당 다음 문자는 다음줄로

											stringZPL +="^FO270,120^A1N,38,38^FD"+itemName.substring(15,30)+"^FS";
										}else{
											stringZPL +="^FO270,100^A1N,50,50^FD"+itemName+"^FS";
										}

										stringZPL +="^FO20,180^A1N,40,40^FD"+"Spec"+"^FS";
										stringZPL +="^FO270,180^A1N,50,50^FD"+ spec+ "*" + goodWorkQ + stockUnit + "^FS";
										stringZPL +="^FO20,250^A1N,40,40^FD"+"In.Date"+"^FS";
										stringZPL +="^FO270,250^A1N,50,50^FD"+prodtDate+"^FS";
										stringZPL +="^FO20,320^A1N,40,40^FD"+"Exp.Date"+"^FS";
										stringZPL +="^FO270,320^A1N,50,50^FD"+endDate+"^FS";
										stringZPL +="^FO20,390^A1N,40,40^FD"+"PD.Date"+"^FS";
										stringZPL +="^FO270,390^A1N,50,50^FD"+" "+"^FS";
										//글자부분 끝

										stringZPL +="^FO70,455^BXN,5,200^FD"+DataMatrix+"^FS";
										stringZPL +="^FO270,465^AVN,25,25^FD"+lotNo+"^FS";


									}else if(dataRaw.LOT_NO.substring(0,1) == 'B' || dataRaw.LOT_NO.substring(0,1) == 'C' || dataRaw.LOT_NO.substring(0,1) == 'D'
											//20181123 'L', 'T', 'S'조건 추가
											|| dataRaw.LOT_NO.substring(0,1) == 'L' || dataRaw.LOT_NO.substring(0,1) == 'T' || dataRaw.LOT_NO.substring(0,1) == 'S'){
										stringZPL +="^FO0,0^GB735,560,6^FS";

										stringZPL +="^FO0,70^GB735,0,6^FS";

										stringZPL +="^FO0,160^GB735,0,6^FS";
										stringZPL +="^FO0,230^GB735,0,6^FS";
										stringZPL +="^FO0,300^GB735,0,6^FS";
										stringZPL +="^FO0,370^GB735,0,6^FS";
										stringZPL +="^FO0,440^GB735,0,6^FS";

										stringZPL +="^FO230,70^GB0,370,6^FS";

										if(dataRaw.LOT_NO.substring(0,1) == 'B' || dataRaw.LOT_NO.substring(0,1) == 'L'){		//20181123 'L'조건 추가
											stringZPL +="^FO340,10^AUN,10,10^FD"+"SX1"+"^FS";
										}else if(dataRaw.LOT_NO.substring(0,1) == 'C' || dataRaw.LOT_NO.substring(0,1) == 'T'){	//20181123 'T'조건 추가
											stringZPL +="^FO340,10^AUN,10,10^FD"+"SX2"+"^FS";
										}else if(dataRaw.LOT_NO.substring(0,1) == 'D' || dataRaw.LOT_NO.substring(0,1) == 'S'){	//20181123 'S'조건 추가
											stringZPL +="^FO300,10^AUN,10,10^FD"+"Slitting"+"^FS";
										}


										stringZPL +="^FO20,100^A1N,40,40^FD"+"Item Name"+"^FS";
										if(itemName.length > 18){
											stringZPL +="^FO270,85^A1N,38,38^FD"+itemName.substring(0, 18)+"^FS";

											stringZPL +="^FO270,120^A1N,38,38^FD"+itemName.substring(18,36)+"^FS";
										}else{
											stringZPL +="^FO270,100^A1N,40,40^FD"+itemName+"^FS";
										}


										if(dataRaw.LOT_NO.substring(0,1) == 'B' || dataRaw.LOT_NO.substring(0,1) == 'C'
											//20181123 'L', 'T'조건 추가
											|| dataRaw.LOT_NO.substring(0,1) == 'L' || dataRaw.LOT_NO.substring(0,1) == 'T'){

											stringZPL +="^FO20,180^A1N,40,40^FD"+"Date"+"^FS";
											stringZPL +="^FO270,180^A1N,40,40^FD"+ prodtDate + "^FS";
											stringZPL +="^FO20,250^A1N,40,40^FD"+"Qty"+"^FS";
											stringZPL +="^FO270,250^A1N,40,40^FD"+formatGoodWorkQ+"^FS";
											stringZPL +="^FO20,320^A1N,40,40^FD"+"Worker"+"^FS";
											stringZPL +="^FO270,320^A1N,40,40^FD"+prodtPrsnName+"^FS";
											stringZPL +="^FO20,390^A1N,40,40^FD"+"PQC"+"^FS";
											stringZPL +="^FO270,390^A1N,40,40^FD"+pqcName+"^FS";

											stringZPL +="^FO70,455^BXN,5,200^FD"+DataMatrix+"^FS";
											stringZPL +="^FO270,465^AVN,25,25^FD"+lotNo+"^FS";

										}else if(dataRaw.LOT_NO.substring(0,1) == 'D' || dataRaw.LOT_NO.substring(0,1) == 'S'){	//20181123 'S'조건 추가

											stringZPL +="^FO20,180^A1N,40,40^FD"+"Spec"+"^FS";
											stringZPL +="^FO270,180^A1N,40,40^FD"+ spec + "^FS";
											stringZPL +="^FO20,250^A1N,40,40^FD"+"Date"+"^FS";
											stringZPL +="^FO270,250^A1N,40,40^FD"+prodtDate+"^FS";
											stringZPL +="^FO20,320^A1N,40,40^FD"+"Qty"+"^FS";
											stringZPL +="^FO270,320^A1N,40,40^FD"+formatGoodWorkQ+"^FS";
											stringZPL +="^FO20,390^A1N,40,40^FD"+"Worker"+"^FS";
											stringZPL +="^FO270,390^A1N,40,40^FD"+prodtPrsnName+"^FS";

											stringZPL +="^FO70,455^BXN,5,200^FD"+DataMatrix+"^FS";
											stringZPL +="^FO270,465^AVN,25,25^FD"+lotNo+"^FS";
										}
									}
								}

							}else{

								/* zt230 200dpi 용*/
								stringZPL += "^SEE:UHANGUL.DAT^FS";
								stringZPL += "^CW1,E:TIMESBD.TTF^CI28^FS";//"^CW1,E:MALGUNBD.TTF^CI28^FS";//"^CW1,E:TIMESBD.TTF^CI28^FS";	//TIMES NEW ROMAN 볼드
								stringZPL += "^PW600";		//라벨 가로 크기관련
								stringZPL += "^LH45,20^FS";

								if(dataRaw.ITEM_ACCOUNT == '00' || dataRaw.ITEM_ACCOUNT == '10' || dataRaw.LOT_NO.substring(0,1) == 'M' || dataRaw.LOT_NO.substring(0,1) == 'F') {	//20181123 'F'조건 추가
									if(BsaCodeInfo.gsSelectLabel == '2') {
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
										stringZPL +="^FO180,159^A1N,25,25^FD"+ prodtDate + "^FS";
										stringZPL +="^FO20,197^A1N,25,25^FD"+"Qty"+"^FS";
										stringZPL +="^FO180,197^A1N,25,25^FD"+formatGoodWorkQ+"^FS";
										stringZPL +="^FO20,235^A1N,25,25^FD"+"Worker"+"^FS";
										stringZPL +="^FO180,235^A1N,25,25^FD"+prodtPrsnName+"^FS";
										stringZPL +="^FO20,273^A1N,25,25^FD"+"Weight"+"^FS";

										stringZPL +="^FO45,310^BXN,3,200^FD"+DataMatrix+"^FS";
										stringZPL +="^FO170,310^AUN,25,25^FD"+lotNo+"^FS";

									} else {
										var partNumber		= dataRaw.ITEM_NAME;
//										var description = '';
										var specification	= dataRaw.SPEC;
										if(Ext.isEmpty(Ext.getCmp('poType').getChecked()[0].inputValue)) {
											var potype		= 'E1';									//고정값
										} else {
											var potype		= Ext.getCmp('poType').getChecked()[0].inputValue;									//고정값
										}
										var date			= UniDate.getDbDateStr(dataRaw.DATE).substring(2, UniDate.getDbDateStr(dataRaw.DATE).length);
										var lotNo			= 'A1' + date + '01';		//'A1' + 날짜  + '01'
										var qty				= dataRaw.PACK_QTY;

										if(BsaCodeInfo.gsLotInitail == '1') {
											var vendorName	= 'JWORLD';							//고정값
										} else {
											var vendorName	= 'JWORLD VINA';					//고정값
										}
										var vendorCode		= 'DXRX';								//고정값

										var vItemCode		= dataRaw.ITEM_CODE;
										var vLotNo			= dataRaw.LOT_NO;
										var itemDataMatrix	= vItemCode + "|" + vLotNo + "|" + qty;

										var sumQty			= qty;
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
											endDate = UniDate.add(dataRaw.DATE, {months: + 12});
										}

										var stringZPL = "";

										/*	zt230 200dpi 용 (Verdanab)*/
//										var stringZPL = "";
										stringZPL += "^SEE:UHANGUL.DAT^FS";
										stringZPL += "^CW1,E:VERDANAB.TTF^CI28^FS";//Verdanab
										stringZPL += "^PW600";		//라벨 가로 크기관련
										stringZPL += "^LH10,10^FS";
										//상단 바코드
										//stringZPL +="^FO360,100^BY1,3,10^B3R,N,95,N,N,^FD"+ "*" + barCode+ "*" + "^FS";	//code39			-- 7.1mm
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
										stringZPL +="^FO191,247^A1R,19,19^FD"+ qty + "^FS";

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
								} else if(dataRaw.LOT_NO.substring(0,1) != 'M' && dataRaw.LOT_NO.substring(0,1) != 'F'){	//20181123 'F'조건 추가
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

								if(dataRaw.LOT_NO.substring(0,1) == 'A' || dataRaw.LOT_NO.substring(0,1) == 'R'){	//20181123 'R'조건 추가
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
										stringZPL +="^FO180,125^A1N,35,35^FD"+spec+ "*" + goodWorkQ + stockUnit + "^FS";
										stringZPL +="^FO20,170^A1N,25,25^FD"+"In.Date"+"^FS";
										stringZPL +="^FO180,170^A1N,35,35^FD"+prodtDate+"^FS";
										stringZPL +="^FO20,215^A1N,25,25^FD"+"Exp.Date"+"^FS";
										stringZPL +="^FO180,215^A1N,35,35^FD"+endDate+"^FS";
										stringZPL +="^FO20,260^A1N,25,25^FD"+"PD.Date"+"^FS";
										stringZPL +="^FO180,260^A1N,35,35^FD"+" "+"^FS";

										stringZPL +="^FO45,308^BXN,3,200^FD"+DataMatrix+"^FS";
										stringZPL +="^FO170,308^AUN,25,25^FD"+lotNo+"^FS";

									} else if(dataRaw.LOT_NO.substring(0,1) == 'B' || dataRaw.LOT_NO.substring(0,1) == 'C' || dataRaw.LOT_NO.substring(0,1) == 'D'
											//20181123 'L', 'T', 'S'조건 추가
											|| dataRaw.LOT_NO.substring(0,1) == 'L' || dataRaw.LOT_NO.substring(0,1) == 'T' || dataRaw.LOT_NO.substring(0,1) == 'S'){
										stringZPL +="^FO0,0^GB500,380,4^FS";

										stringZPL +="^FO0,50^GB500,0,4^FS";

										stringZPL +="^FO0,110^GB500,0,4^FS";
										stringZPL +="^FO0,155^GB500,0,4^FS";
										stringZPL +="^FO0,200^GB500,0,4^FS";
										stringZPL +="^FO0,245^GB500,0,4^FS";
										stringZPL +="^FO0,290^GB500,0,4^FS";

										stringZPL +="^FO150,50^GB0,240,4^FS";

										if(dataRaw.LOT_NO.substring(0,1) == 'B' || dataRaw.LOT_NO.substring(0,1) == 'L'){		//20181123 'L'조건 추가
											stringZPL +="^FO220,5^ATN,8,8^FD"+"SX1"+"^FS";
										}else if(dataRaw.LOT_NO.substring(0,1) == 'C' || dataRaw.LOT_NO.substring(0,1) == 'T'){	//20181123 'T'조건 추가
											stringZPL +="^FO220,5^ATN,8,8^FD"+"SX2"+"^FS";
										}else if(dataRaw.LOT_NO.substring(0,1) == 'D' || dataRaw.LOT_NO.substring(0,1) == 'S'){	//20181123 'S'조건 추가
											stringZPL +="^FO200,5^ATN,8,8^FD"+"Slitting"+"^FS";
										}


										stringZPL +="^FO20,72^A1N,25,25^FD"+"Item Name"+"^FS";
										if(itemName.length > 18){
											stringZPL +="^FO180,61^A1N,24,24^FD"+itemName.substring(0, 18)+"^FS";

											stringZPL +="^FO180,86^A1N,24,24^FD"+itemName.substring(18,36)+"^FS";
										}else{
											stringZPL +="^FO180,72^A1N,25,25^FD"+itemName+"^FS";
										}

										if(dataRaw.LOT_NO.substring(0,1) == 'B' || dataRaw.LOT_NO.substring(0,1) == 'C'
											//20181123 'L', 'T'조건 추가
											|| dataRaw.LOT_NO.substring(0,1) == 'L' || dataRaw.LOT_NO.substring(0,1) == 'T' ){

											stringZPL +="^FO20,125^A1N,25,25^FD"+"Date"+"^FS";
											stringZPL +="^FO180,125^A1N,25,25^FD"+ prodtDate + "^FS";
											stringZPL +="^FO20,170^A1N,25,25^FD"+"Qty"+"^FS";
											stringZPL +="^FO180,170^A1N,25,25^FD"+formatGoodWorkQ+"^FS";
											stringZPL +="^FO20,215^A1N,25,25^FD"+"Worker"+"^FS";
											stringZPL +="^FO180,215^A1N,25,25^FD"+prodtPrsnName+"^FS";
											stringZPL +="^FO20,260^A1N,25,25^FD"+"PQC"+"^FS";
											stringZPL +="^FO180,260^A1N,25,25^FD"+pqcName+"^FS";

											stringZPL +="^FO45,308^BXN,3,200^FD"+DataMatrix+"^FS";
											stringZPL +="^FO170,308^AUN,25,25^FD"+lotNo+"^FS";

										}else if(dataRaw.LOT_NO.substring(0,1) == 'D' || dataRaw.LOT_NO.substring(0,1) == 'S'){	//20181123 'S'조건 추가

											stringZPL +="^FO20,125^A1N,25,25^FD"+"Spec"+"^FS";
											stringZPL +="^FO180,125^A1N,25,25^FD"+ spec + "^FS";
											stringZPL +="^FO20,170^A1N,25,25^FD"+"Date"+"^FS";
											stringZPL +="^FO180,170^A1N,25,25^FD"+ prodtDate + "^FS";
											stringZPL +="^FO20,215^A1N,25,25^FD"+"Qty"+"^FS";
											stringZPL +="^FO180,215^A1N,25,25^FD"+formatGoodWorkQ+"^FS";
											stringZPL +="^FO20,260^A1N,25,25^FD"+"Worker"+"^FS";
											stringZPL +="^FO180,260^A1N,25,25^FD"+prodtPrsnName+"^FS";

											stringZPL +="^FO45,308^BXN,3,200^FD"+DataMatrix+"^FS";
											stringZPL +="^FO170,308^AUN,25,25^FD"+lotNo+"^FS";
										}
									}
								}
							}

							for(var i = 0; i<labelQty; i++){
								sendDataToPrint(500, format_start + stringZPL + format_end);
//								selected_printer.send(format_start + stringZPL + format_end);
							}
						});
					}else {
						printerError(text);
					}
				});

			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '',
			items: [{
				boxLabel: '300dpi',
				width	: 60,
				name	: 'DPI_GUBUN',
				inputValue: '1',
				checked: true
			},{
				boxLabel: '200dpi',
				width	: 60,
				name	: 'DPI_GUBUN',
				inputValue: '2'
			}]
		},{
			xtype		: 'radiogroup',
			fieldLabel	: 'PO TYPE',
			id			: 'poType',
			items		: [{
				boxLabel: 'E1',
				width	: 50,
				name	: 'PO_TYPE',
				inputValue: 'E1',
				checked: true
			},{
				boxLabel: 'E2',
				width	: 50,
				name	: 'PO_TYPE',
				inputValue: 'E2'
			}]
		},{
			xtype	: 'button',
			text	: 'DYHE_<t:message code="system.label.product.labelprint" default="라벨출력"/>',
			id		: 'btnPrint2',
			width	: 100,
			hidden  : dyehPrintHiddenYn,
//			margin	: '0 0 0 50',
			handler	: function() {
				var selectedDetails = masterGrid.getSelectedRecords();

				if(Ext.isEmpty(selectedDetails)){
					return;
				}

				if(available_printers == null)	{
					Unilite.messageBox('An error occurred while printing. Please try again.');
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
								Unilite.messageBox('<t:message code="system.label.purchase.success" default="성공"/>');
							}
										var itemCode = dataRaw.ITEM_CODE;
										var itemName = dataRaw.ITEM_NAME;
										var spec = dataRaw.SPEC;
										var stockUnit = dataRaw.STOCK_UNIT;//"EA";
										var prodtDate = '';
										if(!Ext.isEmpty(dataRaw.DATE)){
											if(UniDate.getDbDateStr(dataRaw.DATE).length == 8){
												prodtDate=UniDate.getDbDateStr(dataRaw.DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.DATE).substring(6,8);//"2018-06-20";
											}
										}

										var endDate = '';
										if(!Ext.isEmpty(dataRaw.END_DATE)){
											if(UniDate.getDbDateStr(dataRaw.END_DATE).length == 8){
												endDate=UniDate.getDbDateStr(dataRaw.END_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.END_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.END_DATE).substring(6,8);//"2018-12-20";
											}
										}
										var goodWorkQ = dataRaw.PACK_QTY;
										var formatGoodWorkQ = goodWorkQ.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
										var prodtPrsnName = dataRaw.PRODT_PRSN_NAME;
										if(Ext.isEmpty(prodtPrsnName)) {
											prodtPrsnName = ''
										}
										var pqcName = dataRaw.PQC_NAME;

										var lotNo = dataRaw.LOT_NO;//"A18062000037";


										var DataMatrix = itemCode + "|" + lotNo + "|" + goodWorkQ;

										var waterMarkCheckV = UniDate.getDbDateStr(dataRaw.DATE).substring(4, 6);
										var labelQty = dataRaw.LABEL_QTY;

										var partNumber		= dataRaw.ITEM_NAME;
//										var description = '';
										var specification	= '';
										if(Ext.isEmpty(Ext.getCmp('poType').getChecked()[0].inputValue)) {
											var potype		= 'E1';									//고정값
										} else {
											var potype		= Ext.getCmp('poType').getChecked()[0].inputValue;									//고정값
										}
										var date			= UniDate.getDbDateStr(dataRaw.DATE).substring(2, UniDate.getDbDateStr(dataRaw.DATE).length);
										var lotNo			= 'A1' + date + '01';		//'A1' + 날짜  + '01'
										var qty				= dataRaw.PACK_QTY;

										if(BsaCodeInfo.gsLotInitail == '1') {
											var vendorName	= 'JWORLD';							//고정값
										} else {
											var vendorName	= 'JWORLD VINA';					//고정값
										}
										var vendorCode		= 'DXRX';								//고정값

										var vItemCode		= dataRaw.ITEM_CODE;
										var vLotNo			= dataRaw.LOT_NO;
										var itemDataMatrix	= vItemCode + "|" + vLotNo + "|" + qty;

										var sumQty			= qty;
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
											endDate = UniDate.add(dataRaw.DATE, {months: + 12});
										}
										var qrCode		    = dataRaw.QR_CODE;
										var serialNum		= dataRaw.SERIAL_NO;
										var stringZPL = "";
										var date = UniDate.getDbDateStr(dataRaw.DATE);
										/* zt230 300dpi 용*/				//Verdanab
										stringZPL += "^SEE:UHANGUL.DAT^FS";
										stringZPL += "^CW1,E:VERDANAB.TTF^CI28^FS";		//Verdanab
										stringZPL += "^PW900";							//라벨 가로 크기관련
										stringZPL += "^LH55,0^FS";
										stringZPL +="^FO260,80^BQ,6,7^FDQA,"+qrCode+"^FS";
										//상단 바코드
										//stringZPL +="^FO460,130^BY2,2,10^B3R,N,140,N,N,^FD"+ "*" + barCode+ "*" + "^FS";	//code39

										stringZPL +="^FO440,355^A1R,42,42^FD"+ partNumber +"^FS";

										stringZPL +="^FO320,355^A1R,42,42^FD"+ 'VJW' + "^FS";

										stringZPL +="^FO195,355^A1R,42,42^FD"+ date + "^FS";

										stringZPL +="^FO195,619^A1R,42,42^FD"+ serialNum + "^FS";

										//QR 코드
										//stringZPL +="^FO270,1000^BQ,2,3^FDQA,"+barCode+"^FS";	//QR바코드
										//ITEM 바코드
										stringZPL +="^FO80,800^BXN,3,200^FD"+ itemDataMatrix+"^FS";
										stringZPL +="^FO80,870^A1R,25,25^FD"+ vLotNo+"^FS";

										stringZPL +="^FO125,900	^GFA,04480,04480,00020,:Z64:";
										stringZPL +="eJzt1jGO1DAUAFBnBilltqN0wT1wQS4wJ5grUFKgOAgkCooVJ8gROMJktUK03GAsUVASmIKg9fjz7YD229+LMgMrmrgYjZ7+xP7+3/EIsYz/PgryecJQ4IcOn4vdox0B9mfbZiNTs0L8pe0Abv5sR6f3wQ4kblR7aN4BfCL5Dj7u7WbzhJhRHehWiDWxXuIcr+qamPs170jMFm2wgdq6Vd5aaqU3TIyaMhoaMJHpUI8rURKbatSKKtp7NFyRTm0U4gvJ4yM+UPe4cJoHlh3zVZFJH1dAZBVAY1ZRfXFhoK2M++CzX9/L2L57M5m4UfE4eBjVHOfF/TM6WQua3XJzZK8g5NYBrubWWg2svmGvYpv6+Tyzdb1l5vulyVjap3N7HHb7vKXn8i6rt0d69h0+SwtpVBp3BTh7YtcQ9WT9APP94CILa760PN/OFixfNZbcBmbNY1PepHuvhoqbqQ7MenlIa656Rd4HtvyKJltF4lzlz+qlUNfEtLdeAMnXNatgbkXnXXf+HP2ge+BKNLMe35A4W+H63Daq0Vh1rG6jZLW0g+xYvzxVKjUnnk/2jZ6PZzKcD7ovYuTvv/f8fOTOzP1Ysr5gcW4zbRp3xbF7MG+OWZeJm2uvZ9qL5Pz6fu5l1AfeGid5XNIv8+/a6tzfnvYeig1gl/kPcv7zTv5vQe4ZW2Tsd9wu3Wc0yc0xay8uuInkPp+sTKzJWBI3ra/N3DNdPt9zLNxvsR2dytRD8/pm4sDy9xqYR+z9h99zxmoJ+EBuY8aA9dpi/9yWsYzc+Al0nwDx:0190";
										stringZPL +="^PQ1,0,1,Y";

							for(var i = 0; i<labelQty; i++){
								sendDataToPrint(500, format_start + stringZPL + format_end);
							}
						});
					}else {
						printerError(text);
					}
				});

			}
		}]
	});

	var masterGrid = Unilite.createGrid('bpr300rkrvGrid1', {
		layout : 'fit',
		region: 'center',
		uniOpt: {
			onLoadSelectFirst: false,
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if (this.selected.getCount() > 0) {
						Ext.getCmp('btnPrint').enable();
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					if (this.selected.getCount() == 0) {
						Ext.getCmp('btnPrint').disable();
					}
				}
			}
		}),
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
				   	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'WH_NAME'			, width: 150},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'SPEC'				, width: 140},
			{dataIndex: 'LOT_NO'			, width: 115},
			{dataIndex: 'STOCK_UNIT'		, width: 80},
			{dataIndex: 'STOCK'				, width: 100},
			{dataIndex: 'PACK_QTY'			, width: 100},
			{dataIndex: 'LABEL_QTY'			, width: 100},
			//{dataIndex: 'REMARK'			, width: 100},
			{dataIndex: 'DIV_CODE'			, width: 66, hidden: true},
			{dataIndex: 'WH_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DATE'				, width: 100},
			{dataIndex: 'END_DATE'			, width: 100, hidden: true},
			//20181012 추가
			{dataIndex: 'ITEM_ACCOUNT'		, width: 80, hidden: true},
			{dataIndex: 'QR_CODE'			, width: 200, hidden: dyehPrintHiddenYn},
			{dataIndex: 'SERIAL_NO'			, width: 80, hidden: dyehPrintHiddenYn}
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['PACK_QTY','LABEL_QTY'])){
					return true;
				}else{
					return false;
				}
			}

		}
	});

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
		id  : 'bpr300rkrvApp',
		fnInitBinding : function(params) {
			setup_web_print();
			Ext.getCmp('btnPrint').disable();
			UniAppManager.setToolbarButtons(['save'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
			this.setDefault();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		onQueryButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return false;
			directMasterStore1.loadStoreRecords();
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			panelSearch.setValue('DIV_CODE'	, UserInfo.divCode);
//			panelResult.setValue('PACK_DATE', UniDate.get('today'));
		}
	});

	Unilite.createValidator('validator00', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			switch(fieldName) {
				case "PACK_QTY" :
					if(record.get('STOCK') > 0 ){
						record.set('LABEL_QTY',Math.ceil(record.get('STOCK')/newValue));
					}
				break;
			}
			return rv;
		}
	});
};
</script>
