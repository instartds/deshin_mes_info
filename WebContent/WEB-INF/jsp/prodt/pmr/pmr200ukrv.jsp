<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr200ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />	<!-- 창고 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />	<!-- 작업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />				<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B035"/>				<!-- 수불타입 -->
		<t:ExtComboStore comboType="OU" />										<!-- 창고-->
		<t:ExtComboStore comboType="WU" />		<!-- 작업장-->
		
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
//			var printer_details = $('#printer_details');
//			var selected_printer_div = $('#selected_printer');
//			
//			selected_printer_div.text("Using Default Printer: " + printer.name);
//			hideLoading();
//			printer_details.show();
//			$('#print_form').show();

		}
		BrowserPrint.getLocalDevices(function(printers){
			available_printers = printers;
//				var sel = document.getElementById("printers");
			var printers_available = false;
//				sel.innerHTML = "";
			if (printers != undefined){
				for(var i = 0; i < printers.length; i++){
					if (printers[i].connection == 'usb'){
//							var opt = document.createElement("option");
//							opt.innerHTML = printers[i].connection + ": " + printers[i].uid;
//							opt.value = printers[i].uid;
//							sel.appendChild(opt);
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

function showBrowserPrintNotFound(){
//	alert('An error occured while attempting to connect to your Zebra Printer. You may not have Zebra Browser Print installed, or it may not be running. Install Zebra Browser Print, or start the Zebra Browser Print Service, and try again.');
};
/*function sendData(value,cnt){
//	showLoading("Printing...");
	checkPrinterStatus( function (text){
		if (text == "Ready to Print"){
			for(var i = 0; i < cnt; i++){
				selected_printer.send(format_start + value + format_end);
			}
		}else{
			printerError(text);
		}
	});
};*/
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
//	$('#printer_details').hide();
	if(available_printers == null)	{
//		showLoading("Finding Printers...");
//		$('#print_form').hide();
		setTimeout(changePrinter, 200);
		return;
	}
//	$('#printer_select').show();
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
/* zebra printer 관련 @@@@@@@@@@@@@@@@@@@@@@@@ */




var BsaCodeInfo = {
	gsManageLotNoYN		: '${gsManageLotNoYN}',		// 작업지시와 생산실적 LOT 연계여부 설정 값 
	gsChkProdtDateYN	: '${gsChkProdtDateYN}',	// 착수예정일 체크여부
	glEndRate			: '${glEndRate}',
	gsSumTypeCell		: '${gsSumTypeCell}',		// 재고합산유형 : 창고 Cell 합산
	gsReportGubun		: '${gsReportGubun}',		// 레포트 구분
	gsFifo				: '${gsFifo}'
};
/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/



var outDivCode = UserInfo.divCode;

function appMain() {	 

var alertWindow;			//alertWindow : 경고창
var gsText			= ''	//바코드 알람 팝업 메세지
var gsWholeIssueFlag= false;

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'pmr200ukrvService.selectDetailList',
			update	: 'pmr200ukrvService.updateDetail',
			create	: 'pmr200ukrvService.insertDetail',
			destroy	: 'pmr200ukrvService.deleteDetail',
			syncAll	: 'pmr200ukrvService.saveAll'
		}
	});



	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 6},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			holdable	: 'hold',
			value		: outDivCode,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			holdable	: 'hold',
			comboType	: 'WU',
	 		allowBlank	: false,
	 		listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(newValue)) {
						var param = {
							WORK_SHOP_CODE : newValue
						}
						pmr200ukrvService.getWhCode(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								panelResult.setValue('WH_CODE', provider[0].WH_CODE);
							} else {
								panelResult.setValue('WH_CODE', '');
							}
						});
						panelResult.getField('REF_WKORD_NUM').focus();
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
			xtype		: 'uniDatefield',
			name		: 'INOUT_DATE',
	   		value		: UniDate.get('today'),
			holdable	: 'hold',
	 		allowBlank	: false
		},{
			xtype	: 'component',
			width	: 80
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.product.wholeissue" default="일괄출고"/>',
			id		: 'btnWholeIssue',
			width	: 80,
			colspan:2,
			handler	: function() {
				var recordAll = detailStore.data.items;
				
//				if(Ext.isEmpty(recordAll)){
//					alert('일괄출고 할 데이터가 없습니다.');
//					return false;	
//				}
				if(!Ext.isEmpty(recordAll)){
					Ext.each(recordAll,function(record,index){
						if(record.get('REMAIN_Q') != 0){
							record.set('OUTSTOCK_Q'	, record.get('REMAIN_Q'));
							record.set('REMAIN_Q'	, 0);
						}
					});
				}
				gsWholeIssueFlag = true;
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.issuewarehouse" default="출고창고"/>',
			name		: 'WH_CODE', 
			xtype		: 'uniCombobox', 
			comboType   : 'OU',
			holdable	: 'hold',
	 		allowBlank	: false
		},{
	 		fieldLabel	: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
	 		xtype		: 'uniTextfield',
	 		name		: 'REF_WKORD_NUM',
			holdable	: 'hold',
	 		allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						if(!panelResult.getInvalidMessage()) return false;
						var newValue = panelResult.getValue('REF_WKORD_NUM');
						if(!Ext.isEmpty(newValue)) {
							detailGrid.focus();
							fnGetOutstockData(newValue);
//							panelResult.setValue('REF_WKORD_NUM', '');
						}
					}
				}
			}
		},{
	 		fieldLabel	: '<t:message code="system.label.product.lotno" default="LOT번호"/>',
	 		xtype		: 'uniTextfield',
	 		name		: 'BARCODE',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						if(!panelResult.getInvalidMessage()) return false;
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
			xtype	: 'component',
			width	: 80
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.product.labelprint" default="라벨출력"/>',
			id		: 'btnPrint',
			width	: 80,
			handler	: function() {
			if(BsaCodeInfo.gsReportGubun == 'CLIP'){
				var i = 0;
				var param = panelResult.getValues();
				var selectedDetails = detailGrid.getSelectedRecords();
				var itemCodeList;
				var lotNoList;
				var whCodeList;
				
				param["PGM_ID"]			= PGM_ID;
				param["MAIN_CODE"]		= 'P010';					//생산용 공통 코드
//				param["WORKER"]			= BsaCodeInfo.gsWorker;
//				param["GSSELECTLABEL"]	= BsaCodeInfo.gsSelectLabel;
//				param["GSLOTINITAIL"]	= BsaCodeInfo.gsLotInitail;
				
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
					url		: CPATH+'/prodt/pmr200clukrv.do',
					prgID	: 'pmr200ukrv',
					extParam: param
				});
				win.center();
				win.show();
				
			} else {
				var selectedDetails = detailGrid.getSelectedRecords();

				if(Ext.isEmpty(selectedDetails)){
					return;
				}
				
				if(available_printers == null)	{
					alert('An error occurred while printing. Please try again.');
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
						var itemCode = dataRaw.ITEM_CODE;
						var itemName = dataRaw.ITEM_NAME;	
						var spec = dataRaw.SPEC;  
						var remainQ = dataRaw.REMAIN_Q;
						var stockUnit = dataRaw.STOCK_UNIT;//"EA";
						var lotDate		= '20' + dataRaw.LOT_NO.substring(1, 7);
						var lotEndDate	= UniDate.add(UniDate.extParseDate(lotDate), {months: + 6});
						var inoutDate = UniDate.getDbDateStr(lotDate).substring(0,4) + '-' + UniDate.getDbDateStr(lotDate).substring(4,6) + '-' + UniDate.getDbDateStr(lotDate).substring(6,8);//"2018-06-20";						  
						var endDate = UniDate.getDbDateStr(lotEndDate).substring(0,4) + '-' + UniDate.getDbDateStr(lotEndDate).substring(4,6) + '-' + UniDate.getDbDateStr(lotEndDate).substring(6,8);//"2018-12-20";							
						var lotNo = dataRaw.LOT_NO;//"A18062000037";	
						var itemLevel = dataRaw.ITEM_LEVEL1;
	//					var qtyFormat = ObjUtils.getSafeString(paramData.get("QTY_FORMAT"));
				
//						var orderUnitQ = dataRaw.ORDER_UNIT_Q;//ObjUtils.parseDouble(paramData.get("ORDER_UNIT_Q"));
				
						
						var DataMatrix = itemCode + "|" + lotNo + "|" + remainQ;//String.format("%."+ nvl(paramData.get("QTY_FORMAT")) +"f",orderUnitQ);
						
						
						console.log('DataMatrix : ', DataMatrix);
						
						var waterMarkCheckV = UniDate.getDbDateStr(lotDate).substring(4, 6);
						
						var stringZPL = "";
						if(panelResult.getValue('DPI_GUBUN') == '1'){
						
							/* zt230 300dpi 용*/
							
							stringZPL += "^SEE:UHANGUL.DAT^FS";
							stringZPL += "^CW1,E:TIMESBD.TTF^CI28^FS";//"^CW1,E:MALGUNBD.TTF^CI28^FS";//"^CW1,E:TIMESBD.TTF^CI28^FS";	//TIMES NEW ROMAN 볼드
							stringZPL += "^PW900";		//라벨 가로 크기관련
							stringZPL += "^LH110,15^FS";
						
							
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
                                    stringZPL +="^FO270,180^A1N,50,50^FD"+ spec+ "*" + remainQ + stockUnit + "^FS";
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
                                    
                                    stringZPL +="^FO230,70^GB0,370,6^FS";               //가운데 선
                                    
        							stringZPL +="^FO200,10^AUN,10,10^FD"+"Item Description"+"^FS";
        							stringZPL +="^FO20,110^A1N,40,40^FD"+"Item Name"+"^FS";
        							if(itemName.length > 13){	// 글씨가 클때는 13이 적당
        								stringZPL +="^FO270,80^A1N,38,38^FD"+itemName.substring(0, 18)+"^FS";		//글씨가 작을때는 18이 적당 다음 문자는 다음줄로
        								stringZPL +="^FO270,120^A1N,38,38^FD"+itemName.substring(18,36)+"^FS";
        							}else{
        								stringZPL +="^FO270,100^A1N,50,50^FD"+itemName+"^FS";
        							}
        						
        							stringZPL +="^FO20,180^A1N,40,40^FD"+"Spec"+"^FS";
        							stringZPL +="^FO270,180^A1N,50,50^FD"+ spec+ "*" + remainQ + stockUnit + "^FS";
        							stringZPL +="^FO20,250^A1N,40,40^FD"+"In.Date"+"^FS";
        							stringZPL +="^FO270,250^A1N,50,50^FD"+inoutDate+"^FS";
        							stringZPL +="^FO20,320^A1N,40,40^FD"+"Exp.Date"+"^FS";
        							stringZPL +="^FO270,320^A1N,50,50^FD"+endDate+"^FS";
        							stringZPL +="^FO20,390^A1N,40,40^FD"+"PD.Date"+"^FS";
        							stringZPL +="^FO270,390^A1N,50,50^FD"+" "+"^FS";
        							
        							stringZPL +="^FO70,455^BXN,5,200^FD"+DataMatrix+"^FS";
        							stringZPL +="^FO270,465^AVN,25,25^FD"+lotNo+"^FS";
							}
						
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
						}else{
						
							/* zt230 200dpi 용*/
							stringZPL += "^SEE:UHANGUL.DAT^FS";
							stringZPL += "^CW1,E:TIMESBD.TTF^CI28^FS";//"^CW1,E:MALGUNBD.TTF^CI28^FS";//"^CW1,E:TIMESBD.TTF^CI28^FS";	//TIMES NEW ROMAN 볼드
							stringZPL += "^PW600";		//라벨 가로 크기관련
				
							stringZPL += "^LH45,20^FS";
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
                                    stringZPL +="^FO180,125^A1N,35,35^FD"+spec+ "*" + remainQ + stockUnit + "^FS";
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
            						stringZPL +="^FO180,125^A1N,35,35^FD"+spec+ "*" + remainQ + stockUnit + "^FS";
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
						sendDataToPrint(500, format_start + stringZPL + format_end);
//						selected_printer.send(format_start + stringZPL + format_end);
						if(index == dataArr.length - 1 ){
							Ext.Msg.alert('<t:message code="system.label.purchase.confirm" default="확인"/>', '<t:message code="system.label.purchase.success" default="성공"/>');
						}
					
					});
					
				}else {
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
						var labelText = invalid.items[0]['fieldLabel']+': ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+': ';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField) {
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
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});	
	
	
	
	Unilite.defineModel('pmr200ukrvDetailModel', {
		fields: [
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.companycode" default="법인코드"/>'		,type:'string'},
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'			,type:'string'},
			{name: 'OUTSTOCK_NUM'	,text: '<t:message code="system.label.product.issuerequestno" default="출고요청번호"/>'	,type:'string'},
			{name: 'REF_WKORD_NUM'	,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.product.itemcode" default="품목코드"/>'			,type:'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type:'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.product.spec" default="규격"/>'					,type:'string'},
			{name: 'STOCK_UNIT'		,text: '<t:message code="system.label.product.unit" default="단위"/>'					,type:'string' , comboType:'AU', comboCode:'B013'},
			{name: 'PATH_CODE'		,text: '자재 BOM Path Code'	,type:'uniQty'},
			{name: 'INOUT_NUM'		,text: '<t:message code="system.label.product.tranno" default="수불번호"/>'				,type:'string'},
			{name: 'INOUT_SEQ'		,text: '<t:message code="system.label.product.transeq" default="수불순번"/>'			,type:'string'},
			{name: 'INOUT_DATE'		,text: '<t:message code="system.label.product.transdate" default="수불일"/>'			,type:'uniDate'},
			{name: 'INOUT_TYPE'		,text: '<t:message code="system.label.product.trantype1" default="수불타입"/>'			,type:'string'},

			{name: 'OUTSTOCK_REQ_Q'	,text: '<t:message code="system.label.product.issuerequestqty" default="출고요청량"/>'	,type:'uniQty'},
			{name: 'LOT_NO'			,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'				,type:'string', allowBlank: false},
			{name: 'OUTSTOCK_Q'		,text: '<t:message code="system.label.product.issueqty" default="출고량"/>'			,type:'uniQty'},
			{name: 'WH_CODE'		,text: '<t:message code="system.label.product.issuewarehouse" default="출고창고"/>'		,type:'string' , comboType   : 'OU'},
			{name: 'REMAIN_Q'		,text: '<t:message code="system.label.product.balanceqty" default="잔량"/>'			,type:'uniQty'},
			{name: 'REMARK'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'				,type:'string'},
			{name: 'PROJECT_NO'		,text: 'Project No.'		,type:'string'},
			{name: 'PJT_CODE'		,text: '<t:message code="system.label.product.projectcode" default="프로젝트코드"/>'		,type:'string'},
			
			{name: 'PRODT_INOUT_NUM',text: 'PRODT_INOUT_NUM'	,type:'string'},
			{name: 'PRODT_INOUT_SEQ',text: 'PRODT_INOUT_SEQ'	,type:'string'},
			{name: 'PRE_OUTSTOCK_Q'	,text: '<t:message code="system.label.product.existingoutqty" default="기존출고량"/>'	,type:'uniQty'},
			{name: 'PRE_OUTSTOCK_Q_BAK'	,text: 'PRE_OUTSTOCK_Q_BAK'	,type:'uniQty'},
			{name: 'QUERY_YN'		,text: 'QUERY_YN'			,type:'string'},
			{name: 'QUERY_FLAG'		,text: 'QUERY_FLAG'			,type:'string'},
			{name: 'ITEM_LEVEL1'      ,text: 'ITEM_LEVEL1'         ,type:'string'}
		]
	});
	
	var detailStore = Unilite.createStore('pmr200ukrvDetailStore', {
		model: 'pmr200ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("INOUT_NUM", master.INOUT_NUM);

						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						Ext.getCmp('btnPrint').disable();
						
						console.log("set was dirty to false");
						detailStore.commitChanges();

						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.app.onQueryButtonDown();
					},
					failure: function(batch, option) {
//						var records = directMasterStore5.data.items
//						Ext.each(records, function(record,i) {
//							record.set('TMP_TIME', new Date())
//						});
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('pmr200ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)) {
					panelResult.setAllFieldsReadOnly(true);
					
					UniAppManager.setToolbarButtons(['newData', 'delete'], false);
				} else {
					UniAppManager.app.onResetButtonDown();
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});
	
	/** detail Grid1 정의(Grid Panel)
	 * @type 
	 */
	var detailGrid = Unilite.createGrid('pmr200ukrvGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
			onLoadSelectFirst	: false,
			useRowNumberer		: false
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick: false,
			/** Toggle between selecting all and deselecting all when clicking on
			 * a checkbox header.
			 * @private
			 */
			onHeaderClick: function(headerCt, header, e) {
				var me		= this,
					store	= me.store,
					column	= me.column,
					isChecked, records, i, len,
					selections, selection;
		
				if (me.showHeaderCheckbox !== false && header === me.column && me.mode !== 'SINGLE') {
					e.stopEvent();
					isChecked = header.el.hasCls(Ext.baseCSSPrefix + 'grid-hd-checker-on');
					selections = this.getSelection();
					// selectAll will only select the contents of the store, whereas deselectAll
					// will remove all the current selections. In this case we only want to
					// deselect whatever is available in the view.
					if (selections.length > 0) {
						records = [];
						selections = this.getSelection();
						for (i = 0, len = selections.length; i < len; ++i) {
							selection = selections[i];
							if (store.indexOf(selection) > -1) {
								records.push(selection);
							}
						}
						if (records.length > 0) {
							me.deselect(records);
						}
					} else {
						records = [];
						selections = store.data.items;
						for (i = 0, len = selections.length; i < len; ++i) {
							if( selections[i].get('REMAIN_Q') > 0) {
								records.push(selections[i]);
							}
						}
						if (records.length > 0) {
							me.select(records);
						}
//						me.selectAll();
					}
				}
			},
			listeners: {  
				beforeselect: function(rowSelection, record, index, eOpts) {
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if (this.selected.getCount() > 0) {
						Ext.getCmp('btnPrint').enable();
//						selectRecord.set('QUERY_YN', 'Y');
//						UniAppManager.setToolbarButtons('save', true);
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var toDelete = detailStore.getRemovedRecords();
//					selectRecord.set('QUERY_YN', '');
					if (/*toDelete.length == 0 && */this.selected.getCount() == 0) {
//						UniAppManager.setToolbarButtons('save', false);
						Ext.getCmp('btnPrint').disable();
					}
				}
			}
		}),
		features: [ {
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false 
			//컬럼헤더에서 그룹핑 사용 안 함
//			enableGroupingMenu:false
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
//			dock			: 'top',
			showSummaryRow	: true
//			enableGroupingMenu:true
		}],
		columns	: [
			{dataIndex: 'COMP_CODE'			, width: 100		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100		, hidden: true},
			{dataIndex: 'OUTSTOCK_NUM'		, width: 120		, hidden: true},
			{dataIndex: 'REF_WKORD_NUM'		, width: 150,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 170},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'STOCK_UNIT'		, width: 80 },
			{dataIndex: 'PATH_CODE'			, width: 100		, hidden: true},
			{dataIndex: 'INOUT_NUM'			, width: 100		, hidden: true},
			{dataIndex: 'INOUT_SEQ'			, width: 100		, hidden: true},
			{dataIndex: 'INOUT_DATE'		, width: 100		, hidden: true},
			{dataIndex: 'INOUT_TYPE'		, width: 100		, hidden: true},

			{dataIndex: 'OUTSTOCK_REQ_Q'	, width: 100		, summaryType: 'sum'},
			{dataIndex: 'LOT_NO'			, width: 120},
			{dataIndex: 'PRE_OUTSTOCK_Q'	, width: 100		, summaryType: 'sum'},
//			{dataIndex: 'PRE_OUTSTOCK_Q_BAK', width: 100		, hidden: false},
			{dataIndex: 'OUTSTOCK_Q'		, width: 100		, summaryType: 'sum'},
			{dataIndex: 'WH_CODE'			, width: 100},
			{dataIndex: 'REMAIN_Q'			, width: 100		, summaryType: 'sum'},
			{dataIndex: 'REMARK'			, flex:1},
			{dataIndex: 'PROJECT_NO'		, width: 100		, hidden: true},
			{dataIndex: 'PJT_CODE'			, width: 100		, hidden: true},
			
			{dataIndex: 'PRODT_INOUT_NUM'	, width: 100		, hidden: true},
			{dataIndex: 'PRODT_INOUT_SEQ'	, width: 100		, hidden: true},
			{dataIndex: 'QUERY_YN'			, width: 100		, hidden: true},
			{dataIndex: 'ITEM_LEVEL1'       , width: 100        , hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false || e.record.get('QUERY_YN') == 'Y') {
					if(UniUtils.indexOf(e.field, ['OUTSTOCK_Q']) /*&& e.record.get('REMAIN_Q') > 0*/) {
						return true;
					} else if (UniUtils.indexOf(e.field, ['REMAIN_Q']) && gsWholeIssueFlag) {
						return true;
					}
					return false;
					
				} else {
//					if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'LOT_NO', 'REMARK', 'OUTSTOCK_Q'])) {
//						return true;
//					}
					return false;
				}
			}
		}
	});

	

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
				text	: '<t:message code="system.label.product.confirm" default="확인"/>',
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
				title	: '<t:message code="system.label.product.warntitle" default="경고"/>',
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
	
	
	
	Unilite.Main( {
		id			: 'pmr200ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				detailGrid,  panelResult
			]	
		}],
		fnInitBinding: function() {
			setup_web_print();
			UniAppManager.setToolbarButtons(['reset','print'], true);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
			Ext.getCmp('btnPrint').disable();
			
			detailStore.loadStoreRecords();
			panelResult.setAllFieldsReadOnly(true);
			gsWholeIssueFlag = false;
		},
		onNewDataButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
			records = detailStore.data.items;
			var r = {
				COMP_CODE		: UserInfo.compCode,
				DIV_CODE		: outDivCode, 
				OUTSTOCK_NUM	: records[0].get('OUTSTOCK_NUM'),
				REF_WKORD_NUM	: panelResult.getValue('REF_WKORD_NUM'),
				PATH_CODE		: records[0].get('PATH_CODE')
			};
			detailGrid.createRow(r);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {		// 새로고침 버튼
			this.suspendEvents();
			panelResult.clearForm();
			
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			this.fnInitBinding();
			detailStore.clearData();
			gsWholeIssueFlag = false;
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				detailGrid.deleteSelectedRow();
				var deSelect = detailGrid.getSelectedRecords();
				detailGrid.getSelectionModel().deselect(deSelect);
			}
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'		, outDivCode);
			panelResult.setValue('INOUT_DATE'	, UniDate.get('today'));
			Ext.getCmp('btnPrint').disable();
			
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);	
		},
		onPrintButtonDown: function() {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            
            var selectedRecords = detailGrid.getSelectedRecords();
            if(Ext.isEmpty(selectedRecords)){
            	alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
            	return;
            }
			var lotNoRecords = new Array();
			Ext.each(selectedRecords, function(record, idx) {
		   		lotNoRecords.push(record.get('LOT_NO'));
			});
				
			var param = panelResult.getValues();
			
			param["dataCount"] = selectedRecords.length;
			param["LOT_NO"] = lotNoRecords;
			
			param["sTxtValue2_fileTitle"]='자재 반납내역서';
			
			param["USER_LANG"] = UserInfo.userLang;
			param["RPT_ID"]='pmr200rkrv2';
			param["PGM_ID"]='pmr200ukrv';
			var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/prodt/pmr200crkrv2.do',
                prgID: 'pmr200rkrv',
                extParam: param
            });
			win.center();
			win.show();
		}
	});
	
	
	
	/** 작업지시번호 바코드 입력 시
	 */
	function fnGetOutstockData(newValue) {
		panelResult.setAllFieldsReadOnly(true);
		var flag = true;
		//동일한 작업지시번호 입력여부 확인
		var records  = detailStore.data.items;		//비교할 records 구성
		Ext.each(records, function(record, i) {
			if(record.get('REF_WKORD_NUM') == newValue) {
				beep();
				gsText = '<t:message code="system.message.product.message001" default="동일한 작업지시번호(이)가 이미 등록되었습니다."/>';
				openAlertWindow(gsText);
				panelResult.getField('REF_WKORD_NUM').focus();
				flag = false;
				return false;
			}
		});
		
		if(flag) {
			//PMP350T에서 OUTSTOCK_Q - PRODT_Q > 인 데이터 조회
			var param = {
				DIV_CODE		: panelResult.getValue('DIV_CODE'),
				WORK_SHOP_CODE	: panelResult.getValue('WORK_SHOP_CODE'),
				REF_WKORD_NUM	: newValue
			}
			pmr200ukrvService.selectDetailList(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					Ext.each(provider, function(outStockInfo, i) {
//						outStockInfo.phantom = true;
						outStockInfo.WH_CODE = panelResult.getValue('WH_CODE')
						detailStore.insert(i, outStockInfo);
						detailStore.commitChanges();
						UniAppManager.setToolbarButtons('save', false);
					});
				} else {
					beep();
					gsText = '<t:message code="system.message.product.message002" default="입력하신 작업지시번호의 데이터가 존재하지 않습니다.."/>';
					openAlertWindow(gsText);
					Ext.getBody().unmask();
					panelResult.setValue('REF_WKORD_NUM', '');
					panelResult.getField('REF_WKORD_NUM').focus();
					panelResult.setAllFieldsReadOnly(false);
					return false;
				}
				
				panelResult.getField('BARCODE').focus();
			});
		}
	}
	
	
	
	/** LOT_NO 바코드 입력 시
	 */
	function fnEnterBarcode(newValue) {
		var needSelect		= Ext.isEmpty(detailGrid.getSelectedRecords())? [] : detailGrid.getSelectedRecords();
		var barcodeItemCode	= newValue.split('|')[0].toUpperCase();
		var barcodeLotNo	= newValue.split('|')[1]
		var barcodeInoutQ	= newValue.split('|')[2];
		var count			= 0;
		
		if(!Ext.isEmpty(barcodeLotNo)) {
			barcodeLotNo = barcodeLotNo.toUpperCase();
		}

		var param = {
			ITEM_CODE		: barcodeItemCode,
			LOT_NO			: barcodeLotNo,
			WH_CODE			: panelResult.getValue('WH_CODE'),
			DIV_CODE		: panelResult.getValue('DIV_CODE'),
//			LOT_NO_S		: panelResult.getValue('LOT_NO_S'),
			GSFIFO			: BsaCodeInfo.gsFifo
		}
		str105ukrvService.getFifo(param, function(provider, response){
			if(!Ext.isEmpty(provider)){
				if(!Ext.isEmpty(provider[0].ERR_MSG)) {
					beep();
					gsText = provider[0].ERR_MSG;
					openAlertWindow(gsText);
					panelResult.getField('BARCODE').focus();
					return false;
					
				} else {
					//동일한 LOT_NO 존재여부 확인하여 체크하는 로직
					var records = detailStore.data.items;		//비교할 records 구성
					Ext.each(records, function(record, i) {
						if(record.get('ITEM_CODE').toUpperCase() == barcodeItemCode && record.get('LOT_NO').toUpperCase() == barcodeLotNo) {
							var outstockQ = provider[0].NEWVALUE.split('|')[2]
							if(record.get('REMAIN_Q') == 0) {
								beep();
								gsText = '<t:message code="system.message.product.message003" default="동일한 품목이 입력 되었습니다."/>';
								openAlertWindow(gsText);
								panelResult.getField('BARCODE').focus();
								count++;
							} else {
								var remainQ = record.get('REMAIN_Q') - parseInt(outstockQ);
								if(remainQ < 0) {
									beep();
									gsText = '<t:message code="system.message.product.message005" default="입력한 출고량이 참조한 출하지시건의 출고가능수량(출하지시량-출고량)보다 클 수 없습니다."/>';
									openAlertWindow(gsText);
									panelResult.getField('BARCODE').focus();
									count++;
									return false;
									
								} else {
									record.set('OUTSTOCK_Q'	, parseInt(outstockQ));
									record.set('REMAIN_Q'	, remainQ);
//									needSelect.push(record);
									panelResult.getField('BARCODE').focus();
									count++;
								}
							}
						}
					});
		
					if(count == 0) {
						beep();
						gsText = '<t:message code="system.label.sales.message004" default="입력한 품목의 작업지시 정보가 없습니다."/>';
						openAlertWindow(gsText);
						panelResult.getField('BARCODE').focus();
						return false;
						
					} else {
						//체크박스 체크로직 필요 없음
//						detailGrid.getSelectionModel().select(needSelect);
					}
				}
			}
		});
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
	
	
	
	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "OUTSTOCK_Q" :	// 생산량
					newValue = Unilite.nvl(newValue, 0);
					if(newValue < 0) {
						rv= Msg.sMB076;	
						break;
					}
					
					var remainQ = record.get('OUTSTOCK_REQ_Q') - (newValue + record.get('PRE_OUTSTOCK_Q'));
					if(remainQ < '0') {
						rv= '<t:message code="system.message.product.message005" default="입력한 출고량이 참조한 출하지시건의 출고가능수량(출하지시량-출고량)보다 클 수 없습니다."/>'
						break;
					}
					record.set('REMAIN_Q', remainQ);
				break;

				case "REMAIN_Q" :	// 잔량
					newValue = Unilite.nvl(newValue, 0);
					if(newValue < 0) {
						rv= Msg.sMB076;	
						break;
					}
					var outstockReqQ	= record.get('OUTSTOCK_REQ_Q');		//출고요청량
					var outstockQ		= record.get('OUTSTOCK_Q')			//출고량
					var preOutstockQ	= record.get('PRE_OUTSTOCK_Q');		//이전 출고량
					var preOutstockQBak	= record.get('PRE_OUTSTOCK_Q_BAK');	//이전 출고량 백업
					var diffPreQ		= preOutstockQBak - preOutstockQ;	//이전 출고량 변경량
					var diffValue		= oldValue - newValue;				//잔량 변경량
					
					if(newValue > outstockReqQ) {
						rv= '잔량이 출고요청량보다 클 수 없습니다.';
						break;
					}
					if(diffPreQ != 0) {
						if(diffValue > diffPreQ) {
							record.set('PRE_OUTSTOCK_Q', preOutstockQBak);
							preOutstockQ= preOutstockQBak;
							newValue	= diffValue - diffPreQ;
							
						} else {
							record.set('PRE_OUTSTOCK_Q', preOutstockQ + diffValue);
							break;
						}
					} else {
						newValue = oldValue - newValue;
					}
					
					outstockQ = outstockQ + newValue;
					if(outstockQ > 0) {
						record.set('OUTSTOCK_Q', outstockQ);
					} else {
						preOutstockQ = preOutstockQ + outstockQ;
						if(preOutstockQ >= 0) {
							record.set('OUTSTOCK_Q', 0);
							record.set('PRE_OUTSTOCK_Q', preOutstockQ);
						} else {
							rv= '잔량이 출고요청량보다 클 수 없습니다.';
							break;
						}
					}
				break;
			}
			return rv;
		}
	}); // validator
}
</script>