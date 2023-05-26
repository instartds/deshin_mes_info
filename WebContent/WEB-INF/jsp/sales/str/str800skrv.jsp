<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="str800skrv"  >
	
	<t:ExtComboStore comboType="BOR120" pgmId="str800skrv"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S105" /> <!-- 라벨거래처 -->
	<t:ExtComboStore comboType="AU" comboCode="S106" /> <!-- 라벨종류 --> 
	<t:ExtComboStore comboType="OU" />					<!-- 창고-->
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
//라벨출력 순서를 위해 delaytime 부여
function sendDataToPrint(ms, prinfText){
	var start = new Date().getTime();var end=start;
	while(end < start + ms) {
		end = new Date().getTime();
	}
	selected_printer.send(prinfText);
}
/* zebra printer 관련 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
function strFm(number, width) {
  number = number + '';
  return number.length >= width ? number : new Array(width - number.length + 1).join('0') + number;
}


var BsaCodeInfo = {
	gsLotInitail		: '${gsLotInitail}',		//LOT 이니셜
	gsReportGubun: '${gsReportGubun}'
};
if(Ext.isEmpty(BsaCodeInfo.gsLotInitail)) {
	BsaCodeInfo.gsLotInitail = 'X';
}

function appMain() {
	Unilite.defineModel('str800skrvModel', {
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'		,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'},
			{name: 'BOX_BARCODE'		,text: 'BOX<t:message code="system.label.sales.number" default="번호"/>'		,type: 'string'},
			{name: 'PACK_DATE'			,text: '<t:message code="system.label.sales.packdate" default="포장일"/>'		,type: 'uniDate'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'			,type: 'string'},
			{name: 'QTY'				,text: '<t:message code="system.label.sales.qty" default="수량"/>'			,type: 'uniQty'},
			{name: 'STOCK_QTY'			,text: '<t:message code="system.label.sales.onhandqty" default="현재고량"/>'	,type: 'uniQty'},
			{name: 'UNIT'				,text: '<t:message code="system.label.sales.unit" default="단위"/>'			,type: 'string', comboType: 'AU', comboCode: 'B013'},
			{name: 'LABEL_CUSTOM'		,text: '<t:message code="system.label.sales.custom" default="거래처"/>'		,type: 'string'},
			{name: 'LABEL_CUSTOM_NAME'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'		,type: 'string'},
			{name: 'LABEL_TYPE'			,text: '<t:message code="system.label.sales.labeltype" default="라벨종류"/>'	,type: 'string'},
			{name: 'LABEL_TYPE_NAME'	,text: '<t:message code="system.label.sales.labeltype" default="라벨종류"/>'	,type: 'string'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'		,type: 'string'},
			{name: 'WH_NAME'			,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'		,type: 'string'},

			{name: 'CUSTOM_ITEM_CODE'	,text: 'CUSTOM_ITEM_CODE'	,type: 'string'},
			{name: 'PRODT_DATE'			,text: 'PRODT_DATE'			,type: 'string'},
			{name: 'ITEM_MODEL'			,text: 'ITEM_MODEL'			,type: 'string'},
			{name: 'PO_NO'				,text: '<t:message code="system.label.sales.pono2" default="P/O 번호"/>'		,type: 'string'},
			{name: 'BOX_QTY'			,text: '<t:message code="system.label.sales.boxqty" default="박스수량"/>'		,type: 'int'},
			//20190117 추가
			{name: 'PO_TYPE'		, text: 'PO TYPE'	, type: 'string'}
		]
	});
			
	var directMasterStore1 = Unilite.createStore('str800skrvMasterStore1',{
		model: 'str800skrvModel',
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,		// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'str800skrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params: param
			});
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
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,	
				value		: UserInfo.divCode,
				child		: 'WH_CODE',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE',newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.packdate" default="포장일"/>', 
				xtype: 'uniDateRangefield',  
				startFieldName: 'PACK_DATE_FR',
				endFieldName:'PACK_DATE_TO',
				width: 315,
				allowBlank	: false,
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PACK_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PACK_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel	: 'BOX<t:message code="system.label.sales.number" default="번호"/>',
				name		: 'BOX_BARCODE',
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('BOX_BARCODE',newValue);
					
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
				name		: 'LABEL_CUSTOM',
				xtype		: 'uniCombobox',
				comboType	: 'AU', 
				comboCode	: 'S105',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('LABEL_CUSTOM',newValue);
						if(!Ext.isEmpty(newValue)){
							panelSearch.setValue('LABEL_TYPE',combo.valueCollection.items[0].data.refCode1);
							panelResult.setValue('LABEL_TYPE',combo.valueCollection.items[0].data.refCode1);
						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.labeltype" default="라벨종류"/>',
				name		: 'LABEL_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU', 
				comboCode	: 'S106',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('LABEL_TYPE',newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>' ,
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			})]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 6
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;'}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,	
			value		: UserInfo.divCode,
			child		: 'WH_CODE',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE',newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.packdate" default="포장일"/>', 
			xtype: 'uniDateRangefield',  
			startFieldName: 'PACK_DATE_FR',
			endFieldName:'PACK_DATE_TO',
			width: 315,
			allowBlank	: false,
			startDate: UniDate.get('today'),
			endDate: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PACK_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PACK_DATE_TO',newValue);
				}
			}
		},{
			fieldLabel	: 'BOX<t:message code="system.label.sales.number" default="번호"/>',
			name		: 'BOX_BARCODE',
			xtype		: 'uniTextfield',
			colspan		: 4,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('BOX_BARCODE',newValue);
				
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
			name		: 'LABEL_CUSTOM',
			xtype		: 'uniCombobox',
			comboType	: 'AU', 
			comboCode	: 'S105',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('LABEL_CUSTOM',newValue);
					if(!Ext.isEmpty(newValue)){
						panelSearch.setValue('LABEL_TYPE',combo.valueCollection.items[0].data.refCode1);
						panelResult.setValue('LABEL_TYPE',combo.valueCollection.items[0].data.refCode1);
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.labeltype" default="라벨종류"/>',
			name		: 'LABEL_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU', 
			comboCode	: 'S106',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('LABEL_TYPE',newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>' , 
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_CODE', newValue);
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_NAME', '');
						panelResult.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_NAME', newValue);
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			xtype: 'component',
			width: 30
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.sales.labelprint" default="라벨출력"/>',
			id		: 'btnPrint',
			width	: 80,
			handler	: function() {
				var reportGubun = BsaCodeInfo.gsReportGubun;
				var selectedDetails = masterGrid.getSelectedRecords();
				if(Ext.isEmpty(selectedDetails)){
					return;
				}
				if(available_printers == null && reportGubun != 'CLIP')	{
					Unilite.messageBox('An error occurred while printing. Please try again.');
					return;
				}
				var dataArr = [];
				Ext.each(selectedDetails, function(record, idx){
					dataArr.push(record.data);
				});
				
				var win;
				var selectedDetails = masterGrid.getSelectedRecords();
	          	var boxNums = "";
	          	Ext.each(selectedDetails, function(record, idx) {
	          		if(idx ==0) {
	          			boxNums = record.get("BOX_BARCODE");
	              	}else{
	              		boxNums = boxNums + ',' + record.get('BOX_BARCODE');
	              	}
					});
	          	panelResult.setValue('BOX_NUMS', boxNums);
				var param ={
						"S_COMP_CODE": UserInfo.compCode,
						"DIV_CODE": panelResult.getValue('DIV_CODE'),
						"BOX_NUMS": panelResult.getValue('BOX_NUMS'),
						"PACK_DATE_FR": panelResult.getValue('PACK_DATE_FR'),
						"PACK_DATE_TO": panelResult.getValue('PACK_DATE_TO'),
						"LABEL_CUSTOM": panelResult.getValue('LABEL_CUSTOM'),
						"LABEL_TYPE": panelResult.getValue('LABEL_TYPE'),
						"ITEM_CODE": panelResult.getValue('ITEM_CODE'),
						"MAIN_CODE" : 'S036',
						"PGM_ID" : 'str800skrv'
					}
				if(reportGubun == 'CLIP'){
					win = Ext.create('widget.ClipReport', {
		                url: CPATH+'/sales/str800clskrv.do',
		                prgID: 'str800skrv',
		                extParam: param
		            });
					win.center();
					win.show();
				}else{
					checkPrinterStatus( function (text){
						if (text == "Ready to Print"){
							dataArr.sort(function(a, b){
								var x = a.BOX_BARCODE.toLowerCase();
								var y = b.BOX_BARCODE.toLowerCase();
								if (x < y) {return -1;}
								if (x > y) {return 1;}
								return 0;
							});
							Ext.each(dataArr, function(dataRaw,index){
								if(index == 0 ){
									Unilite.messageBox('<t:message code="system.label.purchase.success" default="성공"/>');
								}
								
								if(dataRaw.LABEL_TYPE == 'E1'){
									var mainBarcode		= '';
									var poNo			= '';
									if(!Ext.isEmpty(dataRaw.PO_NO)) {
										poNo			= dataRaw.PO_NO;
									}
									var iqc				= '(IQC)';
									var itemName		= dataRaw.ITEM_NAME;
									var customItemCode	= '';
									if(!Ext.isEmpty(dataRaw.CUSTOM_ITEM_CODE)) {
										customItemCode	= dataRaw.CUSTOM_ITEM_CODE;
									} else {
										customItemCode	= dataRaw.ITEM_NAME;
									}
									var supplier		= '1P0010';						//고정값
//									var partInfo		= '0000';						//고정값
									var partInfo		= Ext.isEmpty(dataRaw.REMARK) ? '0000' : dataRaw.REMARK;
									var partInfo2		= '01';							//고정값
									var stockDate		= UniDate.getDbDateStr(dataRaw.PACK_DATE);
									var qty				= dataRaw.QTY;							//.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
									if(!Ext.isEmpty(dataRaw.QTY)) {
										qty			= ('000000' + dataRaw.QTY).substring(dataRaw.QTY.toString().length, 6+dataRaw.QTY.toString().length);
									} else {
										qty			= '000000';
									}
									
									var boxqty			= ''
									if(!Ext.isEmpty(dataRaw.BOX_QTY)) {
										boxqty			= ('0000' + dataRaw.BOX_QTY).substring(dataRaw.BOX_QTY.toString().length, 4+dataRaw.BOX_QTY.toString().length);
									} else {
										boxqty			= '0000';
									}
									var boxBarcode		= dataRaw.BOX_BARCODE;
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
								
								} else if(dataRaw.LABEL_TYPE == 'S1'){
										var partNo = '';
										if(!Ext.isEmpty(dataRaw.CUSTOM_ITEM_CODE)) {
											partNo	= dataRaw.CUSTOM_ITEM_CODE;
										} else {
											partNo	= dataRaw.ITEM_NAME;
										}

										var specification = '';
										//20190117 추가
										var poType = '';
										if(Ext.isEmpty(dataRaw.PO_TYPE)) {
											poType = 'E1';									//고정값
										} else {
											poType = dataRaw.PO_TYPE;									//고정값
										}
										
										var packDate = UniDate.getDbDateStr(dataRaw.PACK_DATE);
										var lotNo = 'A1'+ packDate.substring(2,8) + '01';
										
										var qty = dataRaw.QTY;
										var formatQty = qty.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
										var qty = formatQty;
										
										var labelQty = dataRaw.QTY;
										var qtyString = strFm(labelQty,6);
										
										if(BsaCodeInfo.gsLotInitail == '1') {
											var vendorName = 'JWORLD';
										} else {
											var vendorName = 'JWORLDVINA';
										}
//										var vendorName = 'JWORLDVINA';
										var vendorCode = 'DXRX';
										
										var boxBarcode = dataRaw.BOX_BARCODE;
										
										var barCode = partNo + vendorCode + poType + lotNo + qtyString;//qty;
										
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
											
											stringZPL +="^FO30,1200^BXR,5,200^FD"+ boxBarcode +"^FS";	//dataMatrix
											stringZPL +="^FO30,1300^A1R,35,35^FD"+ boxBarcode + "^FS";
											
											
											stringZPL +="^FO310,1300^BQ,2,7^FDQA,"+barCode+"^FS";	//QR바코드
											
											
											stringZPL +="^FO90,1290^GFA,10752,10752,00028,:Z64:";
											stringZPL +="eJztmb1y20YQx49kNNDIBeNKJTwq0yhvcCqU59DkDdxFVe5iFeFMHsLqwmHjRwAzKdLqEeAqnFQoNDGMAbHZ+wBuAdydScrxxDFvxkMSP/3vY3dvbw9m7NiObfc2AdfeCve9HDI4siM7sv85q/UP/nEZPoaGCy/LNPPrdIL6PJnYT2fMB43wsCbCWt0PxJ6/W3uO++SOiSEDuOuzirKZ9Z9lt4RVnS4zixMuzh6Ydv5bO2XGCCumUBk2vVDtBWGMQRnSyTDDJyIPsA1jZ9Iwrrr5i7AcP6w9U+W7grA1e8FY5uwpe6zzg7bLlWMNY99SXUnmUrNJgSvsGOuxWUnZoseSmrDHvm7essZGGGF8i5/t/mN9loG8gzY+ZY/hP5m0rOjr8HkFLbvHh1Og7H3HrtRDGoOmKVapLi+dLiVMezABry43w/Vzj9BMy87J/gOna3B18o3TAWHaleBndnVA4iyxbGuHe0fibGqZmsoMqG5thrBsIiiTyrjGf8YohKEJb9x4cxjoXtt5bmz3NE8klrVTJvFpOlJ2scM5vz/vdLA+6bOz1bLVwWbeZ+ijn1vWmOVQH/3ZMsif9Rj+5R8de5iEdY3MBszpGmMjMpdfOwb5rGeX51/b9dXamylhp9366m7AsT11WOUTrz0128yIj/AjtUwZZYu/hIsJCUQHm2e9eLkhOj2gy1ldnHH9pZ+XhGXpkFU2flQMnmJbSOGJeU/ejTIhBkwEdJLmEA24t8+DmfJXE2A8wvQZFGD6pzn/RkxqFtM9iWn/Q+Fl2ubkvB2zOlYzBJmAHzv/1Yvl/XK5m67HMiisrcf1Cy4oUkd+dLYVHXup5rs9Bxq7hY3PguFmX0qn6zHUrdWuGo+HR7ba/pd+NlFmmvtYg132mehsBkwVT8ztd2JPmOrDmDDnh+3MHGXO1stV67/mzjBv/ZkMz37CUsV4wQMMk9uDj2Fg4omblT72eKNMxr0Mgx0LA1UcelmJj0rexadUOcWMpxb2KqgrlJsc0yWnYUrXYy5PFMrUCWU6IFqWo/dC7AF1dYCtUUfmqdOnnadYYz3h7GI2T2Z1Ek8Ox7qm16fOikKEGAdq6wRkalj6t3I6zS9zWGaalbzRwdKxLZtv2Ylmj0mp6pc1OXO0Y3ScTXXd4+IMrtCIpv6szRNXD+Kto5CmbsXVyV+gIWfcd2oPQFv3zHRB2rIEjX+fWR1OOnexu01BzgresrTWy7f2VKzM2rrukjIMZpmY+4oqMUX91bWr5zkyc19RdRZvvlllRMfO7d6s9UJJXsoa+bq9327e9HMWGjht2TodsAoHCeQ6jiVLHWIlE1XmZymymM7YZZzLz/EelwvD9OLc+dDMcwYboDqXd1WyWVPmziOYYv2Sg3c8UL42sTQ649TWKe29insZ956b6FBerTJ//ZKz9HbC/fVLs2j30b410efIcAt+wvFU/Xnqrz9T/cWbzywrI+zWW38K/aXx6gyrIyyms4y2yS4M4IOMjvd9x0yfP/nm4tH9S4xH2M3eOkH859fFWBJh8yF759gsoptG2CTCGB8wQVjaZyb5ZYbNfYwbdhJkDWsHdHUkdLXwkKnv7bmyGjA1t+D5QHRDpgM3xrIDdf8pJrxMqqwZWF+KNVvInlnkLiM+7f0IzD3Huz5wd6C9+myeMs9QnMXswiO6FF4G/aBfSQTZU2PJbNP3EVYeyFSNF9SJvXVCMWUjut8rwqpL6gdo81Kqvha9+233jkV1od8R+vKZbkmEzYfjCZ+O3I9q5clxn2LH8WYRNnk64zB89+T1g2Xu/cvpYrGQu+v2ZemHYjfAxKE6cZhuxC4upu37uhFz/88FI5ZFGMBvEfYqwmSIwcEsfP/TL5TLEFuwsyrErq+vg7rVahXUodeCOmybCMsj7D7CrsKsDOTdrh3ZkR3Zl8u+5PYPAkNLww==:3121";
											stringZPL +="^PQ1,0,1,Y";
										
										
										}else{
										
											/* zt230 200dpi 용*/
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
											
											stringZPL +="^FO30,850^BXR,4,200^FD"+ boxBarcode +"^FS";	//dataMatrix
											stringZPL +="^FO30,920^A1R,30,30^FD"+ boxBarcode + "^FS";
											
											
											stringZPL +="^FO220,900^BQ,2,5^FDQA,"+barCode+"^FS";	//QR바코드
											
											
											stringZPL +="^FO65,888^GFA,04480,04480,00020,:Z64:";
											stringZPL +="eJzt1jGO1DAUAFBnBilltqN0wT1wQS4wJ5grUFKgOAgkCooVJ8gROMJktUK03GAsUVASmIKg9fjz7YD229+LMgMrmrgYjZ7+xP7+3/EIsYz/PgryecJQ4IcOn4vdox0B9mfbZiNTs0L8pe0Abv5sR6f3wQ4kblR7aN4BfCL5Dj7u7WbzhJhRHehWiDWxXuIcr+qamPs170jMFm2wgdq6Vd5aaqU3TIyaMhoaMJHpUI8rURKbatSKKtp7NFyRTm0U4gvJ4yM+UPe4cJoHlh3zVZFJH1dAZBVAY1ZRfXFhoK2M++CzX9/L2L57M5m4UfE4eBjVHOfF/TM6WQua3XJzZK8g5NYBrubWWg2svmGvYpv6+Tyzdb1l5vulyVjap3N7HHb7vKXn8i6rt0d69h0+SwtpVBp3BTh7YtcQ9WT9APP94CILa760PN/OFixfNZbcBmbNY1PepHuvhoqbqQ7MenlIa656Rd4HtvyKJltF4lzlz+qlUNfEtLdeAMnXNatgbkXnXXf+HP2ge+BKNLMe35A4W+H63Daq0Vh1rG6jZLW0g+xYvzxVKjUnnk/2jZ6PZzKcD7ovYuTvv/f8fOTOzP1Ysr5gcW4zbRp3xbF7MG+OWZeJm2uvZ9qL5Pz6fu5l1AfeGid5XNIv8+/a6tzfnvYeig1gl/kPcv7zTv5vQe4ZW2Tsd9wu3Wc0yc0xay8uuInkPp+sTKzJWBI3ra/N3DNdPt9zLNxvsR2dytRD8/pm4sDy9xqYR+z9h99zxmoJ+EBuY8aA9dpi/9yWsYzc+Al0nwDx:0190";
											stringZPL +="^PQ1,0,1,Y";
											
										}
										
										
										
										
										
										
										
										/*
										//TIMES NEW ROMAN 볼드
										var stringZPL = "";
										stringZPL += "^SEE:UHANGUL.DAT^FS";
										stringZPL += "^CW1,E:TIMESBD.TTF^CI28^FS";//"^CW1,E:MALGUNBD.TTF^CI28^FS";//"^CW1,E:TIMESBD.TTF^CI28^FS";	//TIMES NEW ROMAN 볼드
			
										stringZPL += "^PW550";		//라벨 가로 크기관련
										stringZPL += "^LH10,10^FS";
										
										stringZPL +="^FO435,130^BY2,2.0,10^B3R,N,100,N,N,^FD"+ "*" + barCode+ "*" + "^FS";	//code39
				
										stringZPL +="^FO370,140^A1R,48,48^FD"+barCode+"^FS";
												
										
										stringZPL +="^FO320,20^A1R,35,35^FD"+"PART NO"+"^FS";
										stringZPL +="^FO320,330^A1R,35,35^FD"+":"+"^FS";
										stringZPL +="^FO320,380^A1R,35,35^FD"+ partNo + "^FS";
										
										stringZPL +="^FO280,20^A1R,35,35^FD"+"SPECIFICATION"+"^FS";
										stringZPL +="^FO280,330^A1R,35,35^FD"+":"+"^FS";
										stringZPL +="^FO280,380^A1R,35,35^FD"+ specification + "^FS";
										
										stringZPL +="^FO240,20^A1R,35,35^FD"+"PO TYPE"+"^FS";
										stringZPL +="^FO240,330^A1R,35,35^FD"+":"+"^FS";
										stringZPL +="^FO240,380^A1R,35,35^FD"+ poType + "^FS";
										
										stringZPL +="^FO200,20^A1R,35,35^FD"+"Lot No"+"^FS";
										stringZPL +="^FO200,330^A1R,35,35^FD"+":"+"^FS";
										stringZPL +="^FO200,380^A1R,35,35^FD"+ lotNo + "^FS";
										
										stringZPL +="^FO160,20^A1R,35,35^FD"+"Qty"+"^FS";
										stringZPL +="^FO160,330^A1R,35,35^FD"+":"+"^FS";
										stringZPL +="^FO160,380^A1R,35,35^FD"+ qty + "^FS";
										
										stringZPL +="^FO120,20^A1R,35,35^FD"+"VENDOR NAME"+"^FS";
										stringZPL +="^FO120,330^A1R,35,35^FD"+":"+"^FS";
										stringZPL +="^FO120,380^A1R,35,35^FD"+ vendorName + "^FS";
										
										stringZPL +="^FO80,20^A1R,35,35^FD"+"DXRX"+"^FS";
										stringZPL +="^FO80,330^A1R,35,35^FD"+":"+"^FS";
										stringZPL +="^FO80,380^A1R,35,35^FD"+ vendorCode + "^FS";
										
										stringZPL +="^FO30,850^BXR,4,200^FD"+ boxBarcode +"^FS";	//dataMatrix
										stringZPL +="^FO30,920^A1R,35,35^FD"+ boxBarcode + "^FS";
										
										
										stringZPL +="^FO220,900^BQ,2,5^FDQA,"+barCode+"^FS";	//QR바코드
										
										
										stringZPL +="^FO65,888^GFA,04480,04480,00020,:Z64:";
										stringZPL +="eJzt1jGO1DAUAFBnBilltqN0wT1wQS4wJ5grUFKgOAgkCooVJ8gROMJktUK03GAsUVASmIKg9fjz7YD229+LMgMrmrgYjZ7+xP7+3/EIsYz/PgryecJQ4IcOn4vdox0B9mfbZiNTs0L8pe0Abv5sR6f3wQ4kblR7aN4BfCL5Dj7u7WbzhJhRHehWiDWxXuIcr+qamPs170jMFm2wgdq6Vd5aaqU3TIyaMhoaMJHpUI8rURKbatSKKtp7NFyRTm0U4gvJ4yM+UPe4cJoHlh3zVZFJH1dAZBVAY1ZRfXFhoK2M++CzX9/L2L57M5m4UfE4eBjVHOfF/TM6WQua3XJzZK8g5NYBrubWWg2svmGvYpv6+Tyzdb1l5vulyVjap3N7HHb7vKXn8i6rt0d69h0+SwtpVBp3BTh7YtcQ9WT9APP94CILa760PN/OFixfNZbcBmbNY1PepHuvhoqbqQ7MenlIa656Rd4HtvyKJltF4lzlz+qlUNfEtLdeAMnXNatgbkXnXXf+HP2ge+BKNLMe35A4W+H63Daq0Vh1rG6jZLW0g+xYvzxVKjUnnk/2jZ6PZzKcD7ovYuTvv/f8fOTOzP1Ysr5gcW4zbRp3xbF7MG+OWZeJm2uvZ9qL5Pz6fu5l1AfeGid5XNIv8+/a6tzfnvYeig1gl/kPcv7zTv5vQe4ZW2Tsd9wu3Wc0yc0xay8uuInkPp+sTKzJWBI3ra/N3DNdPt9zLNxvsR2dytRD8/pm4sDy9xqYR+z9h99zxmoJ+EBuY8aA9dpi/9yWsYzc+Al0nwDx:0190";
										stringZPL +="^PQ1,0,1,Y";
										
										*/
										
										
										
									}else if(dataRaw.LABEL_TYPE == 'S2'){
										var partNumber = '';
										if(!Ext.isEmpty(dataRaw.CUSTOM_ITEM_CODE)) {
											partNumber	= dataRaw.CUSTOM_ITEM_CODE;
										} else {
											partNumber	= dataRaw.ITEM_NAME;
										}

										var description = '';
										
										if(BsaCodeInfo.gsLotInitail == '1') {
											var vendorName = 'JWORLD';
										} else {
											var vendorName = 'JWORLDVINA';
										}
//										var vendorName = 'JWORLDVINA';
										var vendorCode = 'DXRX';
										
										var packDate = UniDate.getDbDateStr(dataRaw.PACK_DATE);
										var lotNo = packDate + '01';
										
										var qty = dataRaw.QTY;
										var formatQty = qty.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
										var qty = formatQty;
										
										var labelQty = dataRaw.QTY;
										var qtyString = strFm(labelQty,6);
										
										var boxBarcode = dataRaw.BOX_BARCODE;
										
										var manufacturedDate = '';
										if(!Ext.isEmpty(dataRaw.PRODT_DATE)){
											manufacturedDate = UniDate.getDbDateStr(dataRaw.PRODT_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.PRODT_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.PRODT_DATE).substring(6,8);//"2018-06-20";
										}
										var barCode = partNumber + vendorCode + lotNo + qtyString;//qty;
										
										//Verdanab
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
											/* zt230 200dpi 용 */
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
										
										/*
										////TIMES NEW ROMAN 볼드
										var stringZPL = "";
										stringZPL += "^SEE:UHANGUL.DAT^FS";
										stringZPL += "^CW1,E:TIMESBD.TTF^CI28^FS";//"^CW1,E:MALGUNBD.TTF^CI28^FS";//"^CW1,E:TIMESBD.TTF^CI28^FS";	//TIMES NEW ROMAN 볼드
										
										stringZPL += "^PW550";		//라벨 가로 크기관련
										stringZPL += "^LH10,10^FS";
										
										stringZPL +="^FO435,130^BY2,2.0,10^B3R,N,100,N,N,^FD"+ "*" + barCode+ "*" + "^FS";	//code39
				
										stringZPL +="^FO370,140^A1R,48,48^FD"+barCode+"^FS";
												
										
										stringZPL +="^FO320,20^A1R,35,35^FD"+"Part Number"+"^FS";
										stringZPL +="^FO320,330^A1R,35,35^FD"+":"+"^FS";
										stringZPL +="^FO320,380^A1R,35,35^FD"+ partNumber + "^FS";
										
										stringZPL +="^FO280,20^A1R,35,35^FD"+"Description"+"^FS";
										stringZPL +="^FO280,330^A1R,35,35^FD"+":"+"^FS";
										stringZPL +="^FO280,380^A1R,35,35^FD"+ description + "^FS";
										
										stringZPL +="^FO240,20^A1R,35,35^FD"+"Vendor Code"+"^FS";
										stringZPL +="^FO240,330^A1R,35,35^FD"+":"+"^FS";
										stringZPL +="^FO240,380^A1R,35,35^FD"+ vendorCode + "^FS";
										
										stringZPL +="^FO200,20^A1R,35,35^FD"+"Vendor Name"+"^FS";
										stringZPL +="^FO200,330^A1R,35,35^FD"+":"+"^FS";
										stringZPL +="^FO200,380^A1R,35,35^FD"+ vendorName + "^FS";
										
										stringZPL +="^FO160,20^A1R,35,35^FD"+"Lot No"+"^FS";
										stringZPL +="^FO160,330^A1R,35,35^FD"+":"+"^FS";
										stringZPL +="^FO160,380^A1R,35,35^FD"+ lotNo + "^FS";
										
										stringZPL +="^FO120,20^A1R,35,35^FD"+"QTY"+"^FS";
										stringZPL +="^FO120,330^A1R,35,35^FD"+":"+"^FS";
										stringZPL +="^FO120,380^A1R,35,35^FD"+ qty + "^FS";
										
										stringZPL +="^FO80,20^A1R,35,35^FD"+"Manufactured Date"+"^FS";
										stringZPL +="^FO80,330^A1R,35,35^FD"+":"+"^FS";
										stringZPL +="^FO80,380^A1R,35,35^FD"+ manufacturedDate + "^FS";
										
										
										stringZPL +="^FO50,690^GB300,450,4^FS";
										stringZPL +="^FO170,690^GB0,450,4^FS";
										stringZPL +="^FO280,690^GB0,450,4^FS";
										stringZPL +="^FO170,910^GB110,0,4^FS";
										stringZPL +="^FO300,775^A1R,30,30^FD"+ "OQC" + "^FS";
										stringZPL +="^FO300,985^A1R,30,30^FD"+ "KHO" + "^FS";
										
										*/
										
										
										
									}else if(dataRaw.LABEL_TYPE == 'C1'){
										
										var itemCode = dataRaw.ITEM_NAME;
										var model = dataRaw.ITEM_MODEL
										var customItemCode = '';
										if(!Ext.isEmpty(dataRaw.CUSTOM_ITEM_CODE)) {
											customItemCode	= dataRaw.CUSTOM_ITEM_CODE;
										} else {
											customItemCode	= dataRaw.ITEM_NAME;
										}

										
										var dateOfManufacture = '';
										if(!Ext.isEmpty(dataRaw.PRODT_DATE)){
											dateOfManufacture = UniDate.getDbDateStr(dataRaw.PRODT_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.PRODT_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.PRODT_DATE).substring(6,8);//"2018-06-20";
										}
										var deliveryDate = '';
										if(!Ext.isEmpty(dataRaw.PACK_DATE)){
											deliveryDate = UniDate.getDbDateStr(dataRaw.PACK_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.PACK_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.PACK_DATE).substring(6,8);//"2018-06-20";
										}
										var quantity = dataRaw.QTY;
										var formatQuantity = quantity.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
										
										var labelCustom = dataRaw.LABEL_CUSTOM_NAME;
										
										var boxBarcode = dataRaw.BOX_BARCODE;
								
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
//											stringZPL +="^FO30,450^A1R,65,65^FD"+"JWORLD VINA.,CO LTD"+"^FS";
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
//											stringZPL +="^FO30,290^A1R,50,50^FD"+"JWORLD VINA.,CO LTD"+"^FS";
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
		//									stringZPL +="^FO140,20^A1R,25,25^FH^FD"+"_D0_94_D0_BE _D1_81_D0_B2_D0_B8_D0_B4_D0_B0_D0_BD_D0_B8_D1_8F"+"^FS";
											
			//								stringZPL +="^FO110,20^A1R,25,25^FH^FD"+"(SỐ LƯỢNG)"+"^FS";
			//								stringZPL +="^FO140,20^A1R,25,25^FH^FD"+"До свидания"+"^FS";
		//									stringZPL +="^FO125,420^A1R,25,25^FH^FD"+"가나다라"+"^FS";
											
		//									stringZPL +="^FO110,20^A1R,25,25^FD"+"(SỐ LƯỢNG)"+"^FS";
		//									stringZPL +="^FO140,20^A1R,25,25^FD"+"QUANTITY"+"^FS";
		//									stringZPL +="^FO125,420^A1R,25,25^FD"+formatQuantity+"^FS";
		//									
		//									stringZPL +="^FO185,20^A1R,25,25^FD"+"(NGÀY GIAO HÀNG)"+"^FS";
		//									stringZPL +="^FO215,20^A1R,25,25^FD"+"DELIVERY DATE"+"^FS";
		//									stringZPL +="^FO205,420^A1R,25,25^FD"+deliveryDate+"^FS";
		//									
		//									stringZPL +="^FO260,20^A1R,25,25^FD"+"(NGÀY SẢN XUẤT)"+"^FS";
		//									stringZPL +="^FO290,20^A1R,25,25^FD"+"DATE OF MANUFACTURE"+"^FS";
		//									stringZPL +="^FO280,420^A1R,25,25^FD"+dateOfManufacture+"^FS";
											
											stringZPL +="^FO125,20^A1R,25,25^FD"+"QUANTITY"+"^FS";
											stringZPL +="^FO125,420^A1R,25,25^FD"+formatQuantity+"^FS";
											
											stringZPL +="^FO205,20^A1R,25,25^FD"+"DELIVERY DATE"+"^FS";
											stringZPL +="^FO205,420^A1R,25,25^FD"+deliveryDate+"^FS";
										
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
//									selected_printer.send(format_start + stringZPL + format_end);		//이전 출력 호출
									sendDataToPrint(500, format_start + stringZPL + format_end);
//									Unilite.messageBox(stringZPL);
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
			},{
	             fieldLabel: 'BOX_NUMS',
	             xtype: 'uniTextfield',
	             name: 'BOX_NUMS',
	             hidden: false
	         }]	
		}]
	});
	
	var masterGrid = Unilite.createGrid('str800skrvGrid1', {
		layout : 'fit',
		region: 'center',
		uniOpt: {
			onLoadSelectFirst: false, 
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: true,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		selModel:Ext.create('Ext.selection.CheckboxModel', { checkOnly : true,
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
			{ dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{ dataIndex: 'BOX_BARCODE'		, width: 130, hidden: false},
			{ dataIndex: 'PACK_DATE'		, width: 100, hidden: true},
			{ dataIndex: 'ITEM_CODE'		, width: 130},
			{ dataIndex: 'ITEM_NAME'		, width: 150},	
			{ dataIndex: 'SPEC'				, width: 133},
			{ dataIndex: 'UNIT'				, width: 100},
			{ dataIndex: 'QTY'				, width: 100},
			{ dataIndex: 'STOCK_QTY'		, width: 100},
			{ dataIndex: 'LABEL_CUSTOM'		, width: 100, hidden: true}, 
			{ dataIndex: 'LABEL_CUSTOM_NAME', width: 100}, 
			{ dataIndex: 'LABEL_TYPE'		, width: 100, hidden: true},
			{ dataIndex: 'LABEL_TYPE_NAME'	, width: 100},
			{ dataIndex: 'WH_CODE'			, width: 200, hidden: true},
			{ dataIndex: 'WH_NAME'			, width: 200},
			
			{ dataIndex: 'CUSTOM_ITEM_CODE'	, width: 200, hidden: true},
			{ dataIndex: 'PRODT_DATE'		, width: 200, hidden: true},
			{ dataIndex: 'ITEM_MODEL'		, width: 200, hidden: true}, 
			{ dataIndex: 'PO_NO'			, width: 100, hidden: true}, 
			{ dataIndex: 'BOX_QTY'			, width: 100, hidden: true}, 
			{ dataIndex: 'PO_TYPE'			, width: 100, hidden: true}
		]
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
		id  : 'str800skrvApp',
		fnInitBinding : function(params) {
			setup_web_print();
			Ext.getCmp('btnPrint').disable();
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
			panelSearch.setValue('DIV_CODE'	, UserInfo.divCode);
			panelSearch.setValue('PACK_DATE', UniDate.get('today'));
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('PACK_DATE', UniDate.get('today'));
		}
	});
};


</script>
