<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr305rkrv"  >

	<t:ExtComboStore comboType="BOR120" pgmId="bpr305rkrv"  />		<!-- 사업장 -->
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

function appMain() {
	Unilite.defineModel('bpr305rkrvModel', {
		fields: [
			{name: 'WH_NAME'		, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',		type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.inventory.item" default="품목"/>',				type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',		type: 'string', maxLength: 100},
			{name: 'SPEC'			, text: '<t:message code="system.label.inventory.spec" default="규격"/>',				type: 'string'},
	  		{name: 'LOT_NO'			, text: '<t:message code="system.label.base.lotno" default="LOT번호"/>',				type: 'string'},
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',	type: 'string'},
			{name: 'STOCK'			, text: '<t:message code="system.label.base.onhandqtybylot" default="현재고현황(LOT별)"/>',		type: 'uniQty'},
			{name: 'PACK_QTY'		, text: '<t:message code="system.label.base.qty" default="수량"/>',					type: 'uniQty'},
			{name: 'LABEL_QTY'		, text: 'Label Qty.',	type: 'uniQty'},
			//{name: 'REMARK'		, text: '<t:message code="system.label.inventory.remarks" default="비고"/>',			type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.inventory.division" default="사업장"/>',		type: 'string'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>',		type: 'string'},
			{name: 'DATE'			, text: '<t:message code="system.label.base.caldate" default="일자"/>',				type: 'uniDate'},
			{name: 'END_DATE'		, text: 'END_DATE',		type: 'string'},
			//20181012 추가
			{name: 'ITEM_ACCOUNT'	, text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',			type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'GOOD_STOCK_Q'	, text: '<t:message code="system.label.base.onhandstock" default="현재고"/>',		type: 'uniQty'},
			{name: 'GROUP_KEY'	, text: 'GROUP_KEY',		type: 'string'},
			{name: 'EDIT_YN1'	, text: 'EDIT_YN1'  ,		type: 'string'},
			{name: 'EDIT_YN2'	, text: 'EDIT_YN2'  ,		type: 'string'}


		]
	});

	var directMasterStore1 = Unilite.createStore('bpr305rkrvMasterStore1',{
		model: 'bpr305rkrvModel',
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
				read: 'bpr305rkrvService.selectList'
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
		layout : {type : 'uniTable', columns : 7
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
			colspan: 3,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
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
					if(!panelResult.getInvalidMessage()) return;		//필수체크

					var selectedRecords = masterGrid.getSelectedRecords();
					if(Ext.isEmpty(selectedRecords)){
						Unilite.messageBox('출력할 데이터를 선택하여 주십시오.');
						return;
					}
					var groupKeys = '';
					var packQty = '';
					var labelQty = '';
					var editYn1 = '';
					var editYn2 = '';
					var param = panelResult.getValues();
					Ext.each(selectedRecords, function(selectedRecord, index){
						if(index ==0) {
							groupKeys	= groupKeys + selectedRecord.get('GROUP_KEY');
							packQty		= packQty + selectedRecord.get('PACK_QTY');
							labelQty	= labelQty + selectedRecord.get('LABEL_QTY');
							editYn1		= editYn1 + selectedRecord.get('EDIT_YN1');
							editYn2		= editYn2 + selectedRecord.get('EDIT_YN2');
						}else{
							groupKeys	= groupKeys + ',' + selectedRecord.get('GROUP_KEY');
							packQty		= packQty + ',' + selectedRecord.get('PACK_QTY');
							labelQty	= labelQty + ',' + selectedRecord.get('LABEL_QTY');
							editYn1		= editYn1 + ',' + selectedRecord.get('EDIT_YN1');
							editYn2		= editYn2 + ',' + selectedRecord.get('EDIT_YN2');
						}
					});

					param["dataCount"] = selectedRecords.length;
					param["GROUP_KEYS"] = groupKeys;
					param["PACK_QTY"] = packQty;
					param["LABEL_QTY"] = labelQty;
					param["EDIT_YN1"] = editYn1;
					param["EDIT_YN2"] = editYn2;
					param["MAIN_CODE"] = 'M030';
					param["sTxtValue2_fileTitle"]='라벨출력';

					param["RPT_ID"]='bpr305rkrv';
					param["PGM_ID"]='bpr305rkrv';
					var win = '';
						 win = Ext.create('widget.ClipReport', {
							url: CPATH+'/base/bpr305clrkrv.do',
							prgID: 'bpr305rkrv',
							extParam: param
						});
						win.center();
						win.show();
				}
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
		}]
	});

	var masterGrid = Unilite.createGrid('bpr305rkrvGrid1', {
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
			{dataIndex: 'STOCK'				, width: 130},
			{dataIndex: 'GOOD_STOCK_Q'		, width: 130},
			{dataIndex: 'PACK_QTY'			, width: 100},
			{dataIndex: 'LABEL_QTY'			, width: 100},
			//{dataIndex: 'REMARK'			, width: 100},
			{dataIndex: 'DIV_CODE'			, width: 66, hidden: true},
			{dataIndex: 'WH_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DATE'				, width: 100},
			{dataIndex: 'END_DATE'			, width: 100, hidden: true},
			//20181012 추가
			{dataIndex: 'ITEM_ACCOUNT'		, width: 80, hidden: true},
			{dataIndex: 'GROUP_KEY'			, width: 80, hidden: true},
			{dataIndex: 'EDIT_YN1'			, width: 80, hidden: true},
			{dataIndex: 'EDIT_YN2'			, width: 80, hidden: true}

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
		id  : 'bpr305rkrvApp',
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
						if(newValue != oldValue){
						record.set('EDIT_YN1','Y');
					}
					}
				break;
				case "LABEL_QTY" :
					if(newValue != oldValue){
						record.set('EDIT_YN2','Y');
					}
				break;
			}
			return rv;
		}
	});
};
</script>
