<%--
'   프로그램명 : 생산실적등록 (생산)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr100ukrv_jw"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList"/>	<!-- 작업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"/>				<!-- 진행상태 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />	<!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>				<!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="P003"/>				<!-- 불량유형 -->
	<t:ExtComboStore comboType="AU" comboCode="P002"/>				<!-- 특기사항 분류 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<!-- zeber printer 관련 -->
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/zebraPrint/BrowserPrint-1.0.4.min.js" />'></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/zebraPrint/jquery-1.11.1.min.js" />'></script>

<script type="text/javascript" >


var gsProdtNum		= '';
var gsArrayCnt		= '';
var gsBasicArrayCnt	= '';
/* @@@@@@@@@@@@@@@@@@@@@@ zebra printer 관련  */
var available_printers = null;
var selected_category = null;
var default_printer = null;
var selected_printer = null;
var format_start = "^XA";
var format_end = "^XZ";
var default_mode = true;
var dyehPrintHiddenYn = true;
if(UserInfo.deptName == '(주)제이월드'){
	dyehPrintHiddenYn = false;
}
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



var BsaCodeInfo = {
	gsManageLotNoYN	: '${gsManageLotNoYN}',		// 작업지시와 생산실적 LOT 연계여부 설정 값
	gsChkProdtDateYN: '${gsChkProdtDateYN}',	// 착수예정일 체크여부
	glEndRate		: '${glEndRate}',
	gsSumTypeCell	: '${gsSumTypeCell}',		// 재고합산유형 : 창고 Cell 합산
	gsMoldPunchQ_Yn	: '${gsMoldPunchQ_Yn}',		//금형타발수 사용 여부 (P601)
	gsSelectLabel	: '${gsSelectLabel}',		//출력할 라벨 선택
	gsLotInitail	: '${gsLotInitail}'	,		//LOT 이니셜
	gsReportGubun : '${gsReportGubun}'	// 레포트 구분
};
if(Ext.isEmpty(BsaCodeInfo.gsSelectLabel)) {
	BsaCodeInfo.gsSelectLabel = '2';
}
if(Ext.isEmpty(BsaCodeInfo.gsLotInitail)) {
	BsaCodeInfo.gsLotInitail = 'X';
}

/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/

var outDivCode = UserInfo.divCode;
var checkDraftStatus = false;
var outouProdtSave;					// 생산실적 자동입고
var woodenInfoWindow				// 목형정보 window

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 작업실적 등록
		api: {
			read: 's_pmr100ukrv_jwService.selectDetailList'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 작업지시별 등록
		api: {
			read	: 's_pmr100ukrv_jwService.selectDetailList2',
			update	: 's_pmr100ukrv_jwService.updateDetail2',
			create	: 's_pmr100ukrv_jwService.insertDetail2',
			destroy	: 's_pmr100ukrv_jwService.deleteDetail2',
			syncAll	: 's_pmr100ukrv_jwService.saveAll2'
		}
	});

	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 공정별 등록1
		api: {
			read	: 's_pmr100ukrv_jwService.selectDetailList3',
			update	: 's_pmr100ukrv_jwService.updateDetail3',
			create	: 's_pmr100ukrv_jwService.insertDetail3',
			destroy	: 's_pmr100ukrv_jwService.deleteDetail3',
			syncAll	: 's_pmr100ukrv_jwService.saveAll3'
		}
	});

	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 공정별 등록2
		api: {
			read	: 's_pmr100ukrv_jwService.selectDetailList4',
			update	: 's_pmr100ukrv_jwService.updateDetail4',
			create	: 's_pmr100ukrv_jwService.insertDetail4',
			destroy	: 's_pmr100ukrv_jwService.deleteDetail4',
			syncAll	: 's_pmr100ukrv_jwService.saveAll4'
		}
	});

	var directProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 불량내역 등록
		api: {
			read	: 's_pmr100ukrv_jwService.selectDetailList5',
			update	: 's_pmr100ukrv_jwService.updateDetail5',
			create	: 's_pmr100ukrv_jwService.insertDetail5',
			destroy	: 's_pmr100ukrv_jwService.deleteDetail5',
			syncAll	: 's_pmr100ukrv_jwService.saveAll5'
		}
	});

	var directProxy6 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 특기사항 등록
		api: {
			read	: 's_pmr100ukrv_jwService.selectDetailList6',
			update	: 's_pmr100ukrv_jwService.updateDetail6',
			create	: 's_pmr100ukrv_jwService.insertDetail6',
			destroy	: 's_pmr100ukrv_jwService.deleteDetail6',
			syncAll	: 's_pmr100ukrv_jwService.saveAll6'
		}
	});



	var masterForm = Unilite.createSearchPanel('s_pmr100ukrv_jwMasterForm', {
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120' ,
				allowBlank:false,
				holdable: 'hold',
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
				endFieldName:'PRODT_START_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				holdable: 'hold',
				width: 315,
				textFieldWidth:170,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_START_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_START_DATE_TO',newValue);
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: ' ',
				id: 'rdoSelect',
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'CONTROL_STATUS',
					inputValue: '',
					holdable: 'hold',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'CONTROL_STATUS',
					holdable: 'hold',
					inputValue: '2'
				},{
					boxLabel : '<t:message code="system.label.product.closing" default="마감"/>',
					width: 60,
					name: 'CONTROL_STATUS',
					holdable: 'hold',
					inputValue: '8'
				},{
					boxLabel : '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'CONTROL_STATUS',
					holdable: 'hold',
					inputValue: '9'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('CONTROL_STATUS').setValue(newValue.CONTROL_STATUS);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				holdable: 'hold',
				store: Ext.data.StoreManager.lookup('wsList'),
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
						masterForm.getField('WKORD_NUM').focus();
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					holdable: 'hold',
					validateBlank:false,
					textFieldName: 'ITEM_NAME',
					valueFieldName: 'ITEM_CODE',
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ITEM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ITEM_NAME', newValue);
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
				xtype: 'uniTextfield',
				name: 'WKORD_NUM',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WKORD_NUM', newValue);
					},
					specialkey:function(field, event)	{
						if(event.getKey() == event.ENTER) {
							if(!panelResult.getInvalidMessage()) return false;
							var newValue = panelResult.getValue('WKORD_NUM');
							if(!Ext.isEmpty(newValue)) {
								UniAppManager.app.onQueryButtonDown();
							}
						}
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
				xtype: 'uniTextfield',
				name: 'WKORD_Q',
				holdable: 'hold',
				hidden: true
			},{
				fieldLabel: '<t:message code="system.label.product.routingcode" default="공정코드"/>',
				xtype: 'uniTextfield',
				name: 'PROG_WORK_CODE',
				holdable: 'hold',
				hidden: true
			},{
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
				xtype: 'uniTextfield',
				name: 'ITEM_CODE1',
				holdable: 'hold',
				hidden: true
			},{
				fieldLabel: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>',
				xtype: 'uniTextfield',
				name: 'PRODT_NUM',
				holdable: 'hold',
				hidden: true
			},{
				fieldLabel: 'RESULT_TYPE',
				xtype: 'uniTextfield',
				name: 'RESULT_TYPE',
				hidden: true
			},
			Unilite.popup('Employee',{
				fieldLabel: '<t:message code="system.label.product.worker" default="작업자"/>',
				valueFieldName:'PERSON_NUMB',
				textFieldName:'NAME',
//				holdable: 'hold',
				showValue:false,
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);
						if(Ext.isEmpty(newValue)) {
							masterForm.setValue('PERSON_NUMB', '');
							panelResult.setValue('PERSON_NUMB', '');
						}
					}
				}
			})]
		}],
		/*api: {
			load: 's_pmr100ukrv_jwService.selectDetailList',
			submit: 's_pmr100ukrv_jwService.syncMaster'
		},
		listeners: {
			dirtychange: function(basicForm, dirty, eOpts) {
				console.log("onDirtyChange");
				UniAppManager.setToolbarButtons('save', true);
			}
		},*/
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
							var popupFC = item.up('uniPopupField') ;
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
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 5
//			,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120' ,
			allowBlank:false,
			holdable: 'hold',
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'PRODT_START_DATE_FR',
			endFieldName:'PRODT_START_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315,
			holdable: 'hold',
			textFieldWidth:170,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(masterForm) {
					masterForm.setValue('PRODT_START_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(masterForm) {
					masterForm.setValue('PRODT_START_DATE_TO',newValue);
				}
			}
		},{
			xtype: 'component',
			width: 40
		},{
			xtype: 'radiogroup',
			fieldLabel: '',
			id: 'rdoSelect2',
			colspan: 2,
			items: [{
				boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
				width: 50,
				name: 'CONTROL_STATUS',
				holdable: 'hold',
				inputValue: '',
				checked: true
			},{
				boxLabel : '<t:message code="system.label.product.process" default="진행"/>',
				width: 50,
				name: 'CONTROL_STATUS',
				holdable: 'hold',
				inputValue: '2'
			},{
				boxLabel : '<t:message code="system.label.product.closing" default="마감"/>',
				width: 50,
				name: 'CONTROL_STATUS',
				holdable: 'hold',
				inputValue: '8'
			},{
				boxLabel : '<t:message code="system.label.product.completion" default="완료"/>',
				width: 50,
				name: 'CONTROL_STATUS',
				holdable: 'hold',
				inputValue: '9'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.getField('CONTROL_STATUS').setValue(newValue.CONTROL_STATUS);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('wsList'),
			allowBlank:false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('WORK_SHOP_CODE', newValue);
					panelResult.getField('WKORD_NUM').focus();
				}
			}
		},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
				validateBlank:false,
				textFieldName: 'ITEM_NAME',
				valueFieldName: 'ITEM_CODE',
				holdable: 'hold',
				listeners: {
					onValueFieldChange: function(field, newValue){
						masterForm.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						masterForm.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}
				}
		}),{
			xtype: 'component',
			width: 40
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.product.resultsstatusprint" default="실적현황출력"/>',
			id		: 'btnPrint2',
			width	: 100,
			colspan : 2,
			handler	: function() {
				if(!panelResult.getInvalidMessage()) return;   //필수체크

				var selectedRecords = masterGrid4.getSelectedRecords();
				if(Ext.isEmpty(selectedRecords)){
					alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
					return;
				}
				var prodtNumRecords = new Array();
				var prodtNumRecordsClip = "";
				Ext.each(selectedRecords, function(record, idx) {
					prodtNumRecords.push(record.get('PRODT_NUM'));
					if(Ext.isEmpty(prodtNumRecordsClip)){
						prodtNumRecordsClip = record.get('PRODT_NUM');
					}else{
						prodtNumRecordsClip = prodtNumRecordsClip + ','+record.get('PRODT_NUM');
					}
				});

				var param = panelResult.getValues();
				param.WKORD_NUM = selectedRecords[0].get('WKORD_NUM');

				param["dataCount"] = selectedRecords.length;
				param["PRODT_NUM"] = prodtNumRecords;
				param["PRODT_NUM_CLIP"] = prodtNumRecordsClip;
				param["sTxtValue2_fileTitle"]='생산실적목록';

				param["USER_LANG"] = UserInfo.userLang;
				param["RPT_ID"]='s_pmr100rkrv_jw';
				param["PGM_ID"]='s_pmr100ukrv_jw';
				param["MAIN_CODE"] = 'Z012';  //생산용 공통 코드
				var win = null;
				 if(BsaCodeInfo.gsReportGubun == 'CLIP'){
		            win = Ext.create('widget.ClipReport', {
		                url: CPATH+'/z_jw/s_pmr100clukrv2_jw.do',
		                prgID: 's_pmr100ukrv_jw',
		                extParam: param
		            });
	            }else{
	         	var win = Ext.create('widget.CrystalReport', {
						url: CPATH+'/z_jw/s_pmr100rkrv_jwcrkrv.do',
						extParam: param
					});
				}
				win.center();
				win.show();
			}
		},{
			fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			xtype: 'uniTextfield',
			name: 'WKORD_NUM',
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('WKORD_NUM', newValue);
				},
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						if(!panelResult.getInvalidMessage()) return false;
						var newValue = panelResult.getValue('WKORD_NUM');
						if(!Ext.isEmpty(newValue)) {
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			}
		},
		Unilite.popup('Employee',{
			fieldLabel: '<t:message code="system.label.product.worker" default="작업자"/>',
			valueFieldName:'PERSON_NUMB',
			textFieldName:'NAME',
//			holdable: 'hold',
			showValue:false,
			validateBlank:false,
			autoPopup:true,
			listeners: {
				onValueFieldChange: function(field, newValue){
					masterForm.setValue('PERSON_NUMB', newValue);
				},
				onTextFieldChange: function(field, newValue){
					masterForm.setValue('NAME', newValue);
					if(Ext.isEmpty(newValue)) {
						masterForm.setValue('PERSON_NUMB', '');
						panelResult.setValue('PERSON_NUMB', '');
					}
				}
			}
		}),{
			xtype: 'component',
			width: 40
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.product.labelprint" default="라벨출력"/>',
			id		: 'btnPrint',
			width	: 80,
			handler	: function() {
				  var param = panelResult.getValues();
				  var selectedDetails = masterGrid4.getSelectedRecords();
				  var prodtNumList;
				  var progWorkCodeList;
				  var wkordNumList;

                param["PGM_ID"]= PGM_ID;
                param["MAIN_CODE"] = 'Z012';  //생산용 공통 코드
                param["WORK_SHOP_CODE"] = masterForm.getValue('WORK_SHOP_CODE');
                param["GSSELECTLABEL"] = BsaCodeInfo.gsSelectLabel;
                param["GSLOTINITAIL"] = BsaCodeInfo.gsLotInitail;
                Ext.each(selectedDetails, function(record, idx) {
         		if(idx ==0) {
         			prodtNumList = record.get("PRODT_NUM");
         			progWorkCodeList = record.get("PROG_WORK_CODE");
         			wkordNumList = record.get("WKORD_NUM");
             	}else{
             		prodtNumList = prodtNumList + ',' + record.get("PRODT_NUM");
             		progWorkCodeList = progWorkCodeList + ',' + record.get("PROG_WORK_CODE");
             		wkordNumList = wkordNumList + ',' + record.get("WKORD_NUM");
             	}
				});

                param.PRODT_NUM		= prodtNumList;
                param.PROG_WORK_CODE	= progWorkCodeList;
                param.WKORD_NUM		= wkordNumList;

                if(BsaCodeInfo.gsReportGubun == 'CLIP'){
         	  var win = null;
			            win = Ext.create('widget.ClipReport', {
			                url: CPATH+'/z_jw/s_pmr100clukrv_jw.do',
			                prgID: 's_pmr100ukrv_jw',
			                extParam: param
			            });
			            win.center();
			            win.show();
		            }else{


						var selectedDetails = masterGrid4.getSelectedRecords();

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
								dataArr.sort(function(obj1, obj2) {
									return obj1.SORT_SEQ - obj2.SORT_SEQ;
								});
								Ext.each(dataArr, function(dataRaw,index){
									if(index == 0 ){
										Ext.Msg.alert('<t:message code="system.label.purchase.confirm" default="확인"/>', '<t:message code="system.label.purchase.success" default="성공"/>');
									}
									var itemCode = dataRaw.ITEM_CODE;
									var itemName = dataRaw.ITEM_NAME;
									var spec = dataRaw.SPEC;
									var stockUnit = dataRaw.STOCK_UNIT;//"EA";
									var prodtDate = UniDate.getDbDateStr(dataRaw.PRODT_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.PRODT_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.PRODT_DATE).substring(6,8);//"2018-06-20";
									var endDate = UniDate.getDbDateStr(dataRaw.END_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.END_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.END_DATE).substring(6,8);//"2018-12-20";
									var goodWorkQ = dataRaw.GOOD_WORK_Q;
									var formatGoodWorkQ = goodWorkQ.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
									var prodtPrsnName = dataRaw.PRODT_PRSN;
									var pqcName = dataRaw.PQC;
			//							var prodtPrsnName = dataRaw.PRODT_PRSN_NAME;
			//							var pqcName = dataRaw.PQC_NAME;

									var lotNo = dataRaw.LOT_NO;//"A18062000037";

									var DataMatrix = itemCode + "|" + lotNo + "|" + goodWorkQ;

									var waterMarkCheckV = UniDate.getDbDateStr(dataRaw.PRODT_DATE).substring(4, 6);


									if(panelResult.getValue('DPI_GUBUN') == '1'){
										/* zt230 300dpi 용*/
										var stringZPL = "";
										stringZPL += "^SEE:UHANGUL.DAT^FS";
										stringZPL += "^CW1,E:TIMESBD.TTF^CI28^FS";//"^CW1,E:MALGUNBD.TTF^CI28^FS";//"^CW1,E:TIMESBD.TTF^CI28^FS";	//TIMES NEW ROMAN 볼드
										stringZPL += "^PW900";		//라벨 가로 크기관련
										stringZPL += "^LH110,15^FS";
										if(panelResult.getValue('WORK_SHOP_CODE') == 'WC10' || panelResult.getValue('WORK_SHOP_CODE') == 'WC20' || panelResult.getValue('WORK_SHOP_CODE') == 'WC30'){

											stringZPL +="^FO0,0^GB735,560,6^FS";

											stringZPL +="^FO0,70^GB735,0,6^FS";

											stringZPL +="^FO0,160^GB735,0,6^FS";
											stringZPL +="^FO0,230^GB735,0,6^FS";
											stringZPL +="^FO0,300^GB735,0,6^FS";
											stringZPL +="^FO0,370^GB735,0,6^FS";
											stringZPL +="^FO0,440^GB735,0,6^FS";

											stringZPL +="^FO230,70^GB0,370,6^FS";

											if(panelResult.getValue('WORK_SHOP_CODE') == 'WC10'){
												stringZPL +="^FO340,10^AUN,10,10^FD"+"SX1"+"^FS";
											}else if(panelResult.getValue('WORK_SHOP_CODE') == 'WC20'){
												stringZPL +="^FO340,10^AUN,10,10^FD"+"SX2"+"^FS";
											}else if(panelResult.getValue('WORK_SHOP_CODE') == 'WC30'){
												stringZPL +="^FO300,10^AUN,10,10^FD"+"Slitting"+"^FS";
											}

											stringZPL +="^FO20,100^A1N,40,40^FD"+"Item Name"+"^FS";
											if(itemName.length > 18){
												stringZPL +="^FO270,85^A1N,38,38^FD"+itemName.substring(0, 18)+"^FS";

												stringZPL +="^FO270,120^A1N,38,38^FD"+itemName.substring(18,36)+"^FS";
											}else{
												stringZPL +="^FO270,100^A1N,40,40^FD"+itemName+"^FS";
											}

											if(panelResult.getValue('WORK_SHOP_CODE') == 'WC10' || panelResult.getValue('WORK_SHOP_CODE') == 'WC20' ){
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

											}else if(panelResult.getValue('WORK_SHOP_CODE') == 'WC30'){
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

										 }else if(panelResult.getValue('WORK_SHOP_CODE') == 'WC40'||panelResult.getValue('WORK_SHOP_CODE') == 'WT20'||panelResult.getValue('WORK_SHOP_CODE') == 'WT40'||panelResult.getValue('WORK_SHOP_CODE') == 'WT60'||panelResult.getValue('WORK_SHOP_CODE') == 'WT80'||panelResult.getValue('WORK_SHOP_CODE') == 'WT91' || panelResult.getValue('WORK_SHOP_CODE') == 'WV40'|| panelResult.getValue('WORK_SHOP_CODE') == 'WT12'|| panelResult.getValue('WORK_SHOP_CODE') == 'WT22'){
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
//												stringZPL +="^FO155,10^AUN,10,10^FD"+"QC-JWORLD VINA"+"^FS";

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
												var partNumber		= dataRaw.ITEM_NAME;
//												var description = '';
												var specification	= dataRaw.SPEC;
												var potype			= 'E1';						//고정값
												var date			= UniDate.getDbDateStr(dataRaw.PRODT_DATE).substring(2, UniDate.getDbDateStr(dataRaw.PRODT_DATE).length);
												var lotNo			= 'A1' + date + '01';		//'A1' + 날짜  + '01'
												var qty				= dataRaw.PACK_QTY;

												if(BsaCodeInfo.gsLotInitail == '1') {
													var vendorName	= 'JWORLD';					//고정값
												} else {
													var vendorName	= 'JWORLD VINA';			//고정값
												}
//												var vendorName		= 'JWORLD VINA';			//고정값
												var vendorCode		= 'DXRX';					//고정값

												var vItemCode		= dataRaw.ITEM_CODE;
												var vLotNo			= dataRaw.LOT_NO;
			//									var itemDataMatrix	= vItemCode + "|" + vLotNo + "|" + qty;
			//									var sumQty			= qty;
												var itemDataMatrix	= vItemCode + "|" + vLotNo + "|" + goodWorkQ;
												var sumQty			= goodWorkQ;
												var formatSumQty	= sumQty.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
												var sumQtyString	= strFm(sumQty, 6);
												var barCode			= partNumber + vendorCode + potype + lotNo + sumQtyString;
												var worker			= dataRaw.PRODT_PRSN
												//20181108 Exp.Date 추가
												var endDate			= '';
												if(!Ext.isEmpty(dataRaw.END_DATE)){
													if(UniDate.getDbDateStr(dataRaw.END_DATE).length == 8){
														endDate=UniDate.getDbDateStr(dataRaw.END_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.END_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.END_DATE).substring(6,8);//"2018-12-20";
													}
												} else {
													endDate = UniDate.add(dataRaw.PRODT_DATE, {months: + 12});
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
												stringZPL +="^FO220,355^A1R,30,25^FD"+ goodWorkQ + "^FS";

												stringZPL +="^FO185,50^A1R,30,25^FD"+"Vendor Name"+"^FS";
												stringZPL +="^FO185,330^A1R,30,25^FD"+":"+"^FS";
												stringZPL +="^FO185,355^A1R,30,25^FD"+ vendorName + "^FS";

												stringZPL +="^FO150,50^A1R,30,25^FD"+"Vendor Code"+"^FS";
												stringZPL +="^FO150,330^A1R,30,25^FD"+":"+"^FS";
												stringZPL +="^FO150,355^A1R,30,25^FD"+ vendorCode + "^FS";

												stringZPL +="^FO115,50^A1R,30,25^FD"+"Worker"+"^FS";
												stringZPL +="^FO115,330^A1R,30,25^FD"+":"+"^FS";
												stringZPL +="^FO115,355^A1R,30,25^FD"+ worker + "^FS";
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

										} else { //if(panelResult.getValue('WORK_SHOP_CODE') == 'WC70'){
											if(panelResult.getValue('WORK_SHOP_CODE') == 'WC70' || panelResult.getValue('WORK_SHOP_CODE') == 'WC72'|| panelResult.getValue('WORK_SHOP_CODE') == 'WC91'|| panelResult.getValue('WORK_SHOP_CODE') == 'WC92'|| panelResult.getValue('WORK_SHOP_CODE') == 'WC93'
											|| panelResult.getValue('WORK_SHOP_CODE') == 'WC94'|| panelResult.getValue('WORK_SHOP_CODE') == 'WC95'|| panelResult.getValue('WORK_SHOP_CODE') == 'WC96'|| panelResult.getValue('WORK_SHOP_CODE') == 'WC98'|| panelResult.getValue('WORK_SHOP_CODE') == 'WC99'){
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
                                                stringZPL +="^FO270,180^A1N,50,50^FD"+ spec+ "*" + goodWorkQ + stockUnit + "^FS";
                                                stringZPL +="^FO20,250^A1N,40,40^FD"+"In.Date"+"^FS";
                                                stringZPL +="^FO270,250^A1N,50,50^FD"+prodtDate+"^FS";
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
    											stringZPL +="^FO270,180^A1N,50,50^FD"+ spec+ "*" + goodWorkQ + stockUnit + "^FS";
    											stringZPL +="^FO20,250^A1N,40,40^FD"+"In.Date"+"^FS";
    											stringZPL +="^FO270,250^A1N,50,50^FD"+prodtDate+"^FS";
    											stringZPL +="^FO20,320^A1N,40,40^FD"+"Exp.Date"+"^FS";
    											stringZPL +="^FO270,320^A1N,50,50^FD"+endDate+"^FS";
    											stringZPL +="^FO20,390^A1N,40,40^FD"+"PD.Date"+"^FS";
    											stringZPL +="^FO270,390^A1N,50,50^FD"+" "+"^FS";
    
    											stringZPL +="^FO70,455^BXN,5,200^FD"+DataMatrix+"^FS";
    											stringZPL +="^FO270,465^AVN,25,25^FD"+lotNo+"^FS";
											}
										}

										if(panelResult.getValue('WORK_SHOP_CODE') != 'WC40' && panelResult.getValue('WORK_SHOP_CODE') != 'WT20' && panelResult.getValue('WORK_SHOP_CODE') != 'WT40' && panelResult.getValue('WORK_SHOP_CODE') != 'WT60' && panelResult.getValue('WORK_SHOP_CODE') != 'WT80' && panelResult.getValue('WORK_SHOP_CODE') != 'WT91' && panelResult.getValue('WORK_SHOP_CODE') != 'WV40' && panelResult.getValue('WORK_SHOP_CODE') != 'WT12' && panelResult.getValue('WORK_SHOP_CODE') != 'WT22'){
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
										}

									} else {
										/* zt230 200dpi 용 */
										var stringZPL = "";
										stringZPL += "^SEE:UHANGUL.DAT^FS";
										stringZPL += "^CW1,E:TIMESBD.TTF^CI28^FS";//"^CW1,E:MALGUNBD.TTF^CI28^FS";//"^CW1,E:TIMESBD.TTF^CI28^FS";	//TIMES NEW ROMAN 볼드
										stringZPL += "^PW600";		//라벨 가로 크기관련
										stringZPL += "^LH45,20^FS";

										if(panelResult.getValue('WORK_SHOP_CODE') == 'WC10' || panelResult.getValue('WORK_SHOP_CODE') == 'WC20' || panelResult.getValue('WORK_SHOP_CODE') == 'WC30'){

											stringZPL +="^FO0,0^GB500,380,4^FS";

											stringZPL +="^FO0,50^GB500,0,4^FS";

											stringZPL +="^FO0,110^GB500,0,4^FS";
											stringZPL +="^FO0,155^GB500,0,4^FS";
											stringZPL +="^FO0,200^GB500,0,4^FS";
											stringZPL +="^FO0,245^GB500,0,4^FS";
											stringZPL +="^FO0,290^GB500,0,4^FS";

											stringZPL +="^FO150,50^GB0,240,4^FS";

											if(panelResult.getValue('WORK_SHOP_CODE') == 'WC10'){
												stringZPL +="^FO220,5^ATN,8,8^FD"+"SX1"+"^FS";
											}else if(panelResult.getValue('WORK_SHOP_CODE') == 'WC20'){
												stringZPL +="^FO220,5^ATN,8,8^FD"+"SX2"+"^FS";
											}else if(panelResult.getValue('WORK_SHOP_CODE') == 'WC30'){
												stringZPL +="^FO200,5^ATN,8,8^FD"+"Slitting"+"^FS";
											}

											stringZPL +="^FO20,72^A1N,25,25^FD"+"Item Name"+"^FS";
											if(itemName.length > 18){
												stringZPL +="^FO180,61^A1N,24,24^FD"+itemName.substring(0, 18)+"^FS";

												stringZPL +="^FO180,86^A1N,24,24^FD"+itemName.substring(18,36)+"^FS";

											} else {
												stringZPL +="^FO180,72^A1N,25,25^FD"+itemName+"^FS";
											}

											if(panelResult.getValue('WORK_SHOP_CODE') == 'WC10' || panelResult.getValue('WORK_SHOP_CODE') == 'WC20' ){
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

											} else if(panelResult.getValue('WORK_SHOP_CODE') == 'WC30'){
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

										} else if(panelResult.getValue('WORK_SHOP_CODE') == 'WC40' || panelResult.getValue('WORK_SHOP_CODE') == 'WT20' || panelResult.getValue('WORK_SHOP_CODE') == 'WT40' || panelResult.getValue('WORK_SHOP_CODE') == 'WT60' || panelResult.getValue('WORK_SHOP_CODE') == 'WT80' || panelResult.getValue('WORK_SHOP_CODE') == 'WT91'|| panelResult.getValue('WORK_SHOP_CODE') == 'WV40'|| panelResult.getValue('WORK_SHOP_CODE') == 'WT12'|| panelResult.getValue('WORK_SHOP_CODE') == 'WT22'){
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
//												stringZPL +="^FO100,5^ATN,8,8^FD"+"QC-JWORLD VINA"+"^FS";

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
//												var description = '';
												var specification	= dataRaw.SPEC;
												var potype			= 'E1';						//고정값
												var date			= UniDate.getDbDateStr(dataRaw.PRODT_DATE).substring(2, UniDate.getDbDateStr(dataRaw.PRODT_DATE).length);
												var lotNo			= 'A1' + date + '01';		//'A1' + 날짜  + '01'
												var qty				= dataRaw.PACK_QTY;

												if(BsaCodeInfo.gsLotInitail == '1') {
													var vendorName	= 'JWORLD';					//고정값
												} else {
													var vendorName	= 'JWORLD VINA';			//고정값
												}
//												var vendorName		= 'JWORLD VINA';			//고정값
												var vendorCode		= 'DXRX';					//고정값

												var vItemCode		= dataRaw.ITEM_CODE;
												var vLotNo			= dataRaw.LOT_NO;
			//									var itemDataMatrix	= vItemCode + "|" + vLotNo + "|" + qty;
			//									var sumQty			= qty;
												var itemDataMatrix	= vItemCode + "|" + vLotNo + "|" + goodWorkQ;
												var sumQty			= goodWorkQ;
												var formatSumQty	= sumQty.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
												var sumQtyString	= strFm(sumQty, 6);
												var barCode			= partNumber + vendorCode + potype + lotNo + sumQtyString;
												var worker			= dataRaw.PRODT_PRSN
												//20181108 Exp.Date 추가
												var endDate			= '';
												if(!Ext.isEmpty(dataRaw.END_DATE)){
													if(UniDate.getDbDateStr(dataRaw.END_DATE).length == 8){
														endDate=UniDate.getDbDateStr(dataRaw.END_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.END_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.END_DATE).substring(6,8);//"2018-12-20";
													}
												} else {
													endDate = UniDate.add(dataRaw.PRODT_DATE, {months: + 12});
												}

												var stringZPL = "";

												/*	zt230 200dpi 용 (Verdanab)*/
//												var stringZPL = "";
												stringZPL += "^SEE:UHANGUL.DAT^FS";
												stringZPL += "^CW1,E:VERDANAB.TTF^CI28^FS";//Verdanab
												stringZPL += "^PW600";		//라벨 가로 크기관련
												stringZPL += "^LH10,10^FS";
												//상단 바코드
//												stringZPL +="^FO360,100^BY1,3,10^B3R,N,95,N,N,^FD"+ "*" + barCode+ "*" + "^FS";	//code39			-- 7.1mm
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
												stringZPL +="^FO191,247^A1R,19,19^FD"+ goodWorkQ + "^FS";

												stringZPL +="^FO166,50^A1R,19,19^FD"+"Vendor Name"+"^FS";
												stringZPL +="^FO166,232^A1R,19,19^FD"+":"+"^FS";
												stringZPL +="^FO166,247^A1R,19,19^FD"+ vendorName + "^FS";

												stringZPL +="^FO141,50^A1R,19,19^FD"+"Vendor Code"+"^FS";
												stringZPL +="^FO141,232^A1R,19,19^FD"+":"+"^FS";
												stringZPL +="^FO141,247^A1R,19,19^FD"+ vendorCode + "^FS";

												stringZPL +="^FO116,50^A1R,19,19^FD"+"Worker"+"^FS";
												stringZPL +="^FO116,232^A1R,19,19^FD"+":"+"^FS";
												stringZPL +="^FO116,247^A1R,19,19^FD"+ worker + "^FS";
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

										}else{		//if(panelResult.getValue('WORK_SHOP_CODE') == 'WC70'){
											if(panelResult.getValue('WORK_SHOP_CODE') == 'WC70' || panelResult.getValue('WORK_SHOP_CODE') == 'WC72'|| panelResult.getValue('WORK_SHOP_CODE') == 'WC91'|| panelResult.getValue('WORK_SHOP_CODE') == 'WC92'|| panelResult.getValue('WORK_SHOP_CODE') == 'WC93'
                                            || panelResult.getValue('WORK_SHOP_CODE') == 'WC94'|| panelResult.getValue('WORK_SHOP_CODE') == 'WC95'|| panelResult.getValue('WORK_SHOP_CODE') == 'WC96'|| panelResult.getValue('WORK_SHOP_CODE') == 'WC98'|| panelResult.getValue('WORK_SHOP_CODE') == 'WC99'){
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
    
                                                } else {
                                                    stringZPL +="^FO180,72^A1N,35,35^FD"+itemName+"^FS";
                                                }
                                                stringZPL +="^FO20,125^A1N,25,25^FD"+"Spec"+"^FS";
                                                stringZPL +="^FO180,125^A1N,35,35^FD"+spec+ "*" + goodWorkQ + stockUnit + "^FS";
                                                stringZPL +="^FO20,170^A1N,25,25^FD"+"In.Date"+"^FS";
                                                stringZPL +="^FO180,170^A1N,35,35^FD"+prodtDate+"^FS";
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
    
    											} else {
    												stringZPL +="^FO180,72^A1N,35,35^FD"+itemName+"^FS";
    											}
    											stringZPL +="^FO20,125^A1N,25,25^FD"+"Spec"+"^FS";
    											stringZPL +="^FO180,125^A1N,35,35^FD"+spec+ "*" + goodWorkQ + stockUnit + "^FS";
    											stringZPL +="^FO20,170^A1N,25,25^FD"+"In.Date"+"^FS";
    											stringZPL +="^FO180,170^A1N,35,35^FD"+prodtDate+"^FS";
    											stringZPL +="^FO20,215^A1N,25,25^FD"+"Exp.Date"+"^FS";
    											stringZPL +="^FO180,215^A1N,25,35^FD"+endDate+"^FS";
    											stringZPL +="^FO20,260^A1N,25,25^FD"+"PD.Date"+"^FS";
    											stringZPL +="^FO180,260^A1N,35,35^FD"+" "+"^FS";
    
    											stringZPL +="^FO45,308^BXN,3,200^FD"+DataMatrix+"^FS";
    											stringZPL +="^FO170,308^AUN,25,25^FD"+lotNo+"^FS";
                                            }
										}
										if(panelResult.getValue('WORK_SHOP_CODE') != 'WC40' && panelResult.getValue('WORK_SHOP_CODE') != 'WT20' && panelResult.getValue('WORK_SHOP_CODE') != 'WT40' && panelResult.getValue('WORK_SHOP_CODE') != 'WT60' && panelResult.getValue('WORK_SHOP_CODE') != 'WT80' && panelResult.getValue('WORK_SHOP_CODE') != 'WT91' && panelResult.getValue('WORK_SHOP_CODE') != 'WV40' && panelResult.getValue('WORK_SHOP_CODE') != 'WT12' && panelResult.getValue('WORK_SHOP_CODE') != 'WT22'){
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
										}
									}
									sendDataToPrint(500, format_start + stringZPL + format_end);
			//							selected_printer.send(format_start + stringZPL + format_end);
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
			},{
				xtype	: 'button',
				text	: 'DYHE_<t:message code="system.label.product.labelprint" default="라벨출력"/>',
				id		: 'btnPrint3',
				width	: 100,
				hidden  : dyehPrintHiddenYn,
//				margin	: '0 0 0 50',
				handler	: function() {
					var selectedDetails = masterGrid4.getSelectedRecords();

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
							dataArr.sort(function(obj1, obj2) {
								return obj1.SORT_SEQ - obj2.SORT_SEQ;
							});
							Ext.each(dataArr, function(dataRaw,index){
								if(index == 0 ){
									Unilite.messageBox('<t:message code="system.label.purchase.success" default="성공"/>');
								}
											var itemCode = dataRaw.ITEM_CODE;
											var itemName = dataRaw.ITEM_NAME;
											var spec = dataRaw.SPEC;
											var stockUnit = dataRaw.STOCK_UNIT;//"EA";
											var prodtDate = UniDate.getDbDateStr(dataRaw.PRODT_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.PRODT_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.PRODT_DATE).substring(6,8);//"2018-06-20";
											var endDate = UniDate.getDbDateStr(dataRaw.END_DATE).substring(0,4) + '-' + UniDate.getDbDateStr(dataRaw.END_DATE).substring(4,6) + '-' + UniDate.getDbDateStr(dataRaw.END_DATE).substring(6,8);//"2018-12-20";
											var goodWorkQ = dataRaw.GOOD_WORK_Q;
											var formatGoodWorkQ = goodWorkQ.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
											var prodtPrsnName = dataRaw.PRODT_PRSN;
											var pqcName = dataRaw.PQC;
					//							var prodtPrsnName = dataRaw.PRODT_PRSN_NAME;
					//							var pqcName = dataRaw.PQC_NAME;

											var lotNo = dataRaw.LOT_NO;//"A18062000037";

											var DataMatrix = itemCode + "|" + lotNo + "|" + goodWorkQ;

											var waterMarkCheckV = UniDate.getDbDateStr(dataRaw.PRODT_DATE).substring(4, 6);

											var partNumber		= dataRaw.ITEM_NAME;
//																		var date			= UniDate.getDbDateStr(dataRaw.DATE).substring(2, UniDate.getDbDateStr(dataRaw.DATE).length);
											var lotNo			= 'A1' + date + '01';		//'A1' + 날짜  + '01'
											var qty				= dataRaw.PACK_QTY;
											var vItemCode		= dataRaw.ITEM_CODE;
											var vLotNo			= dataRaw.LOT_NO;
											var itemDataMatrix	= vItemCode + "|" + vLotNo + "|" + goodWorkQ;

											var qrCode		    = dataRaw.QR_CODE;
											var serialNum		= dataRaw.SERIAL_NO;
											var date = UniDate.getDbDateStr(dataRaw.PRODT_DATE);
											var stringZPL = "";

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

									sendDataToPrint(500, format_start + stringZPL + format_end);

							});
						}else {
							printerError(text);
						}
					});

				}
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
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
							var popupFC = item.up('uniPopupField') ;
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
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});



	Unilite.defineModel('s_pmr100ukrv_jwDetailModel', {
		fields: [
			{name: 'CONTROL_STATUS'		,text: '<t:message code="system.label.product.status" default="상태"/>'			,type:'string' , comboType:"AU", comboCode:"P001"},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'		,type:'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'		,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'			,type:'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>'			,type:'string'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		,type:'uniQty'},

			//20180713(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
			{name: 'PRODT_PRSN'			,text: '<t:message code="system.label.product.worker" default="작업자"/>'					,type:'string',comboType:'AU',comboCode:'P505'},
			{name: 'PRODT_MACH'			,text: '<t:message code="system.label.product.Workingmachine" default="작업호기"/>'			,type:'string'	,comboType:'AU',comboCode:'P506'},
			{name: 'PRODT_TIME'			,text: '<t:message code="system.label.product.workhour" default="작업시간"/>'				,type:'number'},
			{name: 'DAY_NIGHT'			,text: '<t:message code="system.label.product.daynightclass" default="주야구분"/>'			,type:'string'	,comboType:'AU',comboCode:'P507'},

			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'		,type:'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.workenddate" default="작업완료일"/>'		,type:'uniDate'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'	,type:'string'},
			{name: 'PJT_CODE'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type:'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.product.remarks" default="비고"/>'			,type:'string'},
			//Hidden: true
			{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'		,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'		,type:'string'},
			{name: 'WORK_Q'				,text: '<t:message code="system.label.product.workqty" default="작업량"/>'		,type:'uniQty'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		,type:'uniQty'},
			{name: 'WK_PLAN_NUM'		,text: '<t:message code="system.label.product.workplanno" default="작업계획번호"/>'		,type:'string'},
			{name: 'LINE_END_YN'		,text: '<t:message code="system.label.product.lastroutingexistyn" default="최종공정유무"/>'		,type:'string'},
			{name: 'WORK_END_YN'		,text: '<t:message code="system.label.product.closingyn" default="마감여부"/>'		,type:'string'},
			{name: 'LINE_SEQ'			,text: '<t:message code="system.label.product.routingorder" default="공정순서"/>'		,type:'string'},
			{name: 'PROG_UNIT'			,text: '<t:message code="system.label.product.routingresultunit" default="공정실적단위"/>'		,type:'string'},
			{name: 'PROG_UNIT_Q'		,text: '<t:message code="system.label.product.routingunitqty" default="공정원단위량"/>'		,type:'uniQty'},
			{name: 'OUT_METH'			,text: '<t:message code="system.label.product.issuemethod" default="출고방법"/>'		,type:'string'},
			{name: 'AB'					,text: ' '			,type:'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'		,type:'string'},
			{name: 'RESULT_YN'			,text: '<t:message code="system.label.product.receiptmethod" default="입고방법"/>'		,type:'string'},
			{name: 'INSPEC_YN'			,text: '<t:message code="system.label.product.receiptmethod" default="입고방법"/>'		,type:'string'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.product.basiswarehouse" default="기준창고"/>'		,type:'string'},
			{name: 'BASIS_P'			,text: '<t:message code="system.label.product.inventoryamount" default="재고금액"/>'		,type:'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'		,type:'string'},
			//20180714 추가
			{name: 'ARRAY_CNT'			,text: '<t:message code="system.label.product.arraycount" default="배열수"/>'		,type:'int'},
			//20180823 추가
			{name: 'MAIN_ITEM_CODE'		,text: 'MAIN_ITEM_CODE'		,type:'string'},
			{name: 'MAIN_ITEM_NAME'		,text: 'MAIN_ITEM_NAME'		,type:'string'}
		]
	});

	var detailStore = Unilite.createStore('s_pmr100ukrv_jwDetailStore', {
		model: 's_pmr100ukrv_jwDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)) {
					masterForm.setAllFieldsReadOnly(true);
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

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var detailGrid = Unilite.createGrid('s_pmr100ukrv_jwGrid', {
		store: detailStore,
		layout: 'fit',
		region:'center',
		uniOpt: {
			expandLastColumn: false,
			onLoadSelectFirst: true,
			useRowNumberer: false
		},
		tbar: [{
			xtype	: 'splitbutton',
			itemId	: 'refTool',
			text	: '<t:message code="system.label.product.processbutton" default="프로세스..."/>',
			iconCls	: 'icon-referance',
			menu	: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId	: 'requestBtn',
					text	: '<t:message code="system.label.product.employeestatusentry" default="인원현황등록"/>',
					handler	: function() {
						if(masterForm.setAllFieldsReadOnly(true) == false){
							return false;
						} else{
							var params = {
								'DIV_CODE'				: masterForm.getValue('DIV_CODE'),
								'PRODT_START_DATE_FR'	: masterForm.getValue('PRODT_START_DATE_FR'),
								'PRODT_START_DATE_TO'	: masterForm.getValue('PRODT_START_DATE_TO'),
								'WORK_SHOP_CODE'		: masterForm.getValue('WORK_SHOP_CODE')
							}
							var rec = {data : {prgID : 'pmr800ukrv', 'text':'인원현황 등록'}};
							parent.openTab(rec, '/prodt/pmr800ukrv.do', params);
						}
					}
				}]
			})
		}],
		columns: [
			{dataIndex: 'CONTROL_STATUS'	, width: 53  ,locked:false},
			{dataIndex: 'WKORD_NUM'			, width: 120 ,locked:false},
			{dataIndex: 'ITEM_CODE'			, width: 100 ,locked:false},
			{dataIndex: 'ITEM_NAME'			, width: 170 ,locked:false},
			{dataIndex: 'SPEC'				, width: 150 ,locked:false},
			{dataIndex: 'STOCK_UNIT'		, width: 53  ,align:'center' ,locked:false},
			{dataIndex: 'WKORD_Q'			, width: 100 ,locked:false},

			//20180713(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
			{dataIndex: 'PRODT_PRSN'		, width: 150},
			{dataIndex: 'PRODT_MACH'		, width: 100},
			{dataIndex: 'PRODT_TIME'		, width: 100, align: 'center',
				renderer:function(value, metaData, record)	{
					var r = value;

					if(r.toString().length > 2) {
						r= r.toString().substring(0, r.toString().length - 2) + ':' + r.toString().substring(r.toString().length - 2, r.toString().length);
					}
					return r;
				}
			},
			{dataIndex: 'DAY_NIGHT'			, width: 100},

			{dataIndex: 'PRODT_START_DATE'	, width: 86},
			{dataIndex: 'PRODT_END_DATE'	, width: 86},
			{dataIndex: 'LOT_NO'			, width: 133},
			{dataIndex: 'PROJECT_NO'		, width: 133},
			{dataIndex: 'REMARK'			, width: 200},
//			{dataIndex: 'PJT_CODE'			, width: 133},
			{dataIndex: 'PROG_WORK_CODE'	, width: 0 ,hidden:true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 0 ,hidden:true},
			{dataIndex: 'WORK_Q'			, width: 0 ,hidden:true},
			{dataIndex: 'PRODT_Q'			, width: 0 ,hidden:true},
			{dataIndex: 'WK_PLAN_NUM'		, width: 0 ,hidden:true},
			{dataIndex: 'LINE_END_YN'		, width: 0 ,hidden:true},
			{dataIndex: 'WORK_END_YN'		, width: 0 ,hidden:true},
			{dataIndex: 'LINE_SEQ'			, width: 0 ,hidden:true},
			{dataIndex: 'PROG_UNIT'			, width: 0 ,hidden:true},
			{dataIndex: 'PROG_UNIT_Q'		, width: 0 ,hidden:true},
			{dataIndex: 'OUT_METH'			, width: 0 ,hidden:true},
			{dataIndex: 'AB'				, width: 0 ,hidden:true},

			{dataIndex: 'RESULT_YN'			, width: 10 ,hidden:true},
			{dataIndex: 'INSPEC_YN'		, width: 10 ,hidden:true},
			{dataIndex: 'WH_CODE'			, width: 10 ,hidden:true},
			{dataIndex: 'BASIS_P'			, width: 10 ,hidden:true},
			{dataIndex: 'DIV_CODE'			, width: 10 ,hidden:true},
			{dataIndex: 'ARRAY_CNT'			, width: 10 ,hidden:true},
			//20180823 추가
			{dataIndex: 'MAIN_ITEM_CODE'	, width: 10 ,hidden:true},
			{dataIndex: 'MAIN_ITEM_NAME'	, width: 10 ,hidden:true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
					return false;
				} else {
					return false;
				}
			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
					var activeTabId = tab.getActiveTab().getId();

					this.returnCell(record);
					if(activeTabId == 's_pmr100ukrv_jwGrid2'){
						directMasterStore2.loadStoreRecords();
					} else if(activeTabId == 's_pmr100ukrv_jwGrid3_1'){
						directMasterStore3.loadStoreRecords();
					} else if(activeTabId == 's_pmr100ukrv_jwGrid5'){
						directMasterStore5.loadStoreRecords();
					} else {
						directMasterStore6.loadStoreRecords();
					}
				}
			}
		},
		returnCell: function(record){
			var itemCode	= record.get("ITEM_CODE");
			var prodtNum	= record.get("PRODT_NUM");
			masterForm.setValues({'ITEM_CODE1':itemCode});
			masterForm.setValues({'PRODT_NUM':prodtNum});
		},
		disabledLinkButtons: function(b) {
			this.down('#refTool').menu.down('#requestBtn').setDisabled(b);
		}
	});



	/** 작업지시별등록 정의
	 * @type
	 */
	Unilite.defineModel('s_pmr100ukrv_jwModel2', {  //Pmr100ns3v.htm
		fields: [
			{name: 'PRODT_DATE'		,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'			,type:'uniDate'},
			{name: 'PRODT_Q'		,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'			,type:'uniQty', allowBlank:false},
			{name: 'GOOD_PRODT_Q'	,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'				,type:'uniQty', allowBlank:false},
			{name: 'BAD_PRODT_Q'	,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'				,type:'uniQty'},
			{name: 'MAN_HOUR'		,text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'				,type:'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'WKORD_Q'		,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'			,type:'uniQty'},
			{name: 'PRODT_SUM'		,text: '<t:message code="system.label.product.productiontotal" default="생산누계"/>'		,type:'uniQty'},
			{name: 'JAN_Q'			,text: '<t:message code="system.label.product.productionleftqty" default="생산잔량"/>'		,type:'uniQty'},
			{name: 'IN_STOCK_Q'		,text: '<t:message code="system.label.product.receiptqty" default="입고량"/>'				,type:'uniQty'},

			//20180713(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
			{name: 'PRODT_PRSN'		,text: '<t:message code="system.label.product.worker" default="작업자"/>'					,type:'string'	,comboType:'AU',comboCode:'P505'},
			{name: 'PRODT_MACH'		,text: '<t:message code="system.label.product.Workingmachine" default="작업호기"/>'			,type:'string'	,comboType:'AU',comboCode:'P506'},
			{name: 'PRODT_TIME'		,text: '<t:message code="system.label.product.workhour" default="작업시간"/>'				,type:'string'},
			{name: 'DAY_NIGHT'		,text: '<t:message code="system.label.product.daynightclass" default="주야구분"/>'			,type:'string'	,comboType:'AU',comboCode:'P507'},

			{name: 'LOT_NO'			,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'					,type:'string'},
			{name: 'REMARK'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'					,type:'string'},
			{name: 'PROJECT_NO'		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
			{name: 'PJT_CODE'		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
			{name: 'FR_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(<t:message code="system.label.product.start" default="시작"/>)'	,type:'string'},
			{name: 'TO_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(<t:message code="system.label.product.end" default="종료"/>)'	,type:'string'},
			//Hidden:true
			{name: 'NEW_DATA'		,text: 'NEW_DATA'		,type:'string'},
			{name: 'PRODT_NUM'		,text: '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'	,type:'string'},
			{name: 'PROG_WORK_CODE'	,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'},
			{name: 'UPDATE_DB_USER'	,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'				,type:'string'},
			{name: 'UPDATE_DB_TIME'	,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'				,type:'uniDate'},
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'			,type:'string'},
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'				,type:'string'},
			{name: 'WORK_SHOP_CODE'	,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				,type:'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.product.item" default="품목"/>'						,type:'string'},
			{name: 'CONTROL_STATUS'	,text: 'CONTROL_STATUS'	,type:'string'},
			{name: 'GOOD_WH_CODE'	,text: '<t:message code="system.label.product.goodreceiptwarehouse" default="양품입고창고"/>'		,type:'string'},
			{name: 'GOOD_PRSN'		,text: '<t:message code="system.label.product.goodreceiptincharge" default="양품입고담당"/>'		,type:'string'},
			{name: 'BAD_WH_CODE'	,text: '<t:message code="system.label.product.defectreceiptwarehouse" default="불량입고창고"/>'	,type:'string'},
			{name: 'BAD_PRSN'		,text: '<t:message code="system.label.product.defectreceiptincharge" default="불량입고담당"/>'	,type:'string'},
			//20180605 추가
			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.defectreceiptincharge" default="불량입고담당"/>'	,type:'string'}
		]
	});

	/** 공정별등록 정의 center
	 * @type
	 */
	Unilite.defineModel('s_pmr100ukrv_jwModel3', {  //Pmr100ns1v.htm
		fields: [
			{name: 'SEQ'			,text: '<t:message code="system.label.product.seq" default="순번"/>'					,type:'string'},
			{name: 'PROG_WORK_NAME'	,text: '<t:message code="system.label.product.routingname" default="공정명"/>'			,type:'string'},
			{name: 'PROG_UNIT'		,text: '<t:message code="system.label.product.unit" default="단위"/>'					,type:'string'},
			{name: 'PROG_WKORD_Q'	,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		,type:'uniQty'},
			{name: 'SUM_Q'			,text: '<t:message code="system.label.product.productiontotal2" default="생산계"/>'	,type:'uniQty'},
			{name: 'PRODT_DATE'		,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'		,type:'uniDate'	, allowBlank:false},
			{name: 'PASS_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		,type:'uniQty'	, allowBlank:false},
			{name: 'GOOD_WORK_Q'	,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'			,type:'uniQty'	/*, allowBlank:false*/},
			{name: 'BAD_WORK_Q'		,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'			,type:'uniQty'},

			//20180713(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
			{name: 'PRODT_PRSN'		,text: '<t:message code="system.label.product.worker" default="작업자"/>'				,type:'string'/*,comboType:'AU',comboCode:'P505'*/},
			{name: 'PQC'			,text: '<t:message code="system.label.product.routinginspector" default="공정검사자"/>'	,type:'string'/*,comboType:'AU',comboCode:'P509'*/},
			{name: 'PRODT_MACH'		,text: '<t:message code="system.label.product.Workingmachine" default="작업호기"/>'		,type:'string'	,comboType:'AU',comboCode:'P506'},
			{name: 'PRODT_TIME'		,text: '<t:message code="system.label.product.workhour" default="작업시간"/>'			,type:'string'	,value:'00:00'},
			{name: 'DAY_NIGHT'		,text: '<t:message code="system.label.product.daynightclass" default="주야구분"/>'		,type:'string'	,comboType:'AU',comboCode:'P507'},

			{name: 'MAN_HOUR'		,text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'			,type:'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'JAN_Q'			,text: '<t:message code="system.label.product.productionleftqty" default="생산잔량"/>'	,type:'uniQty'},
			{name: 'LOT_NO'			,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'				,type:'string'},
			{name: 'FR_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(시작)'		,type:'string'},
			{name: 'TO_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(종료)'		,type:'string'},
			{name: 'REMARK'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'				,type:'string'},
			//Hidden: true
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'			,type:'string'},
			{name: 'PROG_WORK_CODE'	,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'		,type:'string'},
			{name: 'WORK_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		,type:'string'},
			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string'},
			{name: 'LINE_END_YN'	,text: '<t:message code="system.label.product.lastyn" default="최종여부"/>'				,type:'string'},
			{name: 'WK_PLAN_NUM'	,text: '<t:message code="system.label.product.planno" default="계획번호"/>'				,type:'string'},
			{name: 'PRODT_NUM'		,text: ''	,type:'string'},
			{name: 'CONTROL_STATUS'	,text: ''	,type:'string'},
			{name: 'UPDATE_DB_USER'	,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'					,type:'string'},
			{name: 'UPDATE_DB_TIME'	,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'					,type:'uniDate'},
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'				,type:'string'},
			{name: 'GOOD_WH_CODE'	,text: '<t:message code="system.label.product.goodreceiptwarehouse" default="양품입고창고"/>'		,type:'string'},
			{name: 'GOOD_PRSN'		,text: '<t:message code="system.label.product.goodreceiptincharge" default="양품입고담당"/>'		,type:'string'},
			{name: 'BAD_WH_CODE'	,text: '<t:message code="system.label.product.defectreceiptwarehouse" default="불량입고창고"/>'	,type:'string'},
			{name: 'BAD_PRSN'		,text: '<t:message code="system.label.product.defectreceiptincharge" default="불량입고담당"/>'	,type:'string'},
			//20180714 추가
			{name: 'ARRAY_CNT'		,text: '<t:message code="system.label.product.arraycount" default="배열수"/>'		,type:'int'}
		]
	});

	/** 공정별등록 정의 east
	 * @type
	 */
	Unilite.defineModel('s_pmr100ukrv_jwModel4', {  //Pmr100ns1v.htm
		fields: [
			{name: 'PRODT_NUM'		,text: '<t:message code="system.label.product.productionno" default="생산번호"/>'				,type:'string'},
			{name: 'PRODT_DATE'		,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'				,type:'uniDate'},
			{name: 'PASS_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'				,type:'uniQty'},
			{name: 'GOOD_WORK_Q'	,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'					,type:'uniQty'},
			{name: 'BAD_WORK_Q'		,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'					,type:'uniQty'},

			//20180713(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
			{name: 'PRODT_PRSN'		,text: '<t:message code="system.label.product.worker" default="작업자"/>'						,type:'string'/*,comboType:'AU',comboCode:'P505'*/},
			{name: 'PQC'			,text: '<t:message code="system.label.product.routinginspector" default="공정검사자"/>'			,type:'string'/*,comboType:'AU',comboCode:'P509'*/},
			{name: 'PRODT_MACH'		,text: '<t:message code="system.label.product.Workingmachine" default="작업호기"/>'				,type:'string'	,comboType:'AU',comboCode:'P506'},
			{name: 'PRODT_TIME'		,text: '<t:message code="system.label.product.workhour" default="작업시간"/>'					,type:'string'},
			{name: 'DAY_NIGHT'		,text: '<t:message code="system.label.product.daynightclass" default="주야구분"/>'				,type:'string'	,comboType:'AU',comboCode:'P507'},

			{name: 'MAN_HOUR'		,text: '<t:message code="system.label.product.inputtime" default="투입공수"/>'					,type:'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'IN_STOCK_Q'		,text: '<t:message code="system.label.product.receiptqty" default="입고량"/>'					,type:'uniQty'},
			{name: 'LOT_NO'			,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'						,type:'string'},
			{name: 'FR_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(시작)'				,type:'string'},
			{name: 'TO_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(종료)'				,type:'string'},
			{name: 'REMARK'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'						,type:'string'},
			//Hidden: true
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'					,type:'string'},
			{name: 'PROG_WKORD_Q'	,text: ''	,type:'uniQty'},
			{name: 'CAL_PASS_Q'		,text: ''	,type:'uniQty'},
			{name: 'PROG_WORK_CODE'	,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'				,type:'string'},
			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'				,type:'string'},
			{name: 'WK_PLAN_NUM'	,text: '<t:message code="system.label.product.planno" default="계획번호"/>'						,type:'string'},
			{name: 'LINE_END_YN'	,text: '<t:message code="system.label.product.lastyn" default="최종여부"/>'						,type:'string'},
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'				,type:'string'},
			{name: 'CONTROL_STATUS'	,text: ''	,type:'string'},
			{name: 'GOOD_WH_CODE'	,text: '<t:message code="system.label.product.goodreceiptwarehouse" default="양품입고창고"/>'		,type:'string'},
			{name: 'GOOD_PRSN'		,text: '<t:message code="system.label.product.goodreceiptincharge" default="양품입고담당"/>'		,type:'string'},
			{name: 'BAD_WH_CODE'	,text: '<t:message code="system.label.product.defectreceiptwarehouse" default="불량입고창고"/>'	,type:'string'},
			{name: 'BAD_PRSN'		,text: '<t:message code="system.label.product.defectreceiptincharge" default="불량입고담당"/>'	,type:'string'},

			{name: 'ITEM_CODE'		,text: ''	,type:'string'},		//라벨출력용
			{name: 'ITEM_NAME'		,text: ''	,type:'string'},		//라벨출력용
			{name: 'SPEC'			,text: ''	,type:'string'},		//라벨출력용
			{name: 'PRODT_PRSN_NAME',text: ''	,type:'string'},		//라벨출력용
			{name: 'PQC_NAME'		,text: ''	,type:'string'},		//라벨출력용
			{name: 'STOCK_UNIT'		,text: ''	,type:'string'},		//라벨출력용
			{name: 'END_DATE'		,text: ''	,type:'string'},		//라벨출력용
			{name: 'SORT_SEQ'		,text: ''	,type:'string'},		//라벨출력용
			{name: 'PACK_QTY'		,text: '<t:message code="system.label.base.qty" default="수량"/>'								,type: 'uniQty'},
			{name: 'DATE'			, text: '<t:message code="system.label.base.caldate" default="일자"/>',				type: 'uniDate'},
			{name: 'QR_CODE'		, text: 'QR_CODE',			type: 'string'},
			{name: 'SERIAL_NO'		, text: 'SERIAL_NO',		type: 'string'}
		]
	});

	/** 불량내역등록
	 * @type
	 */
	Unilite.defineModel('s_pmr100ukrv_jwModel5', {
		fields: [
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			,type:'string', allowBlank:false},
			{name: 'PROG_WORK_NAME'		,text: '<t:message code="system.label.product.routingname" default="공정명"/>'				,type:'string', allowBlank:false},
			{name: 'PRODT_DATE'			,text: '<t:message code="system.label.product.occurreddate" default="발생일"/>'			,type:'uniDate', allowBlank:false},
			{name: 'BAD_CODE'			,text: '<t:message code="system.label.product.defecttype" default="불량유형"/>'				,type:'string', allowBlank:false, comboType: 'AU', comboCode: 'P003'},
			{name: 'BAD_Q'				,text: '<t:message code="system.label.product.qty" default="수량"/>'						,type:'uniQty', allowBlank:false},
			{name: 'REMARK'				,text: '<t:message code="system.label.product.issueandmeasures" default="문제점 및 대책"/>'	,type:'string'},
			//Hidden : true
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'				,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'			,type:'string'},
			{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type:'string'},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'				,type:'string'},
			{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'				,type:'uniDate'},
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'			,type:'string'}
		]
	});

	/** 특기사항등록
	 * @type
	 */
	Unilite.defineModel('s_pmr100ukrv_jwModel6', {
		fields: [
			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			,type:'string'},
			{name: 'PROG_WORK_NAME'	,text: '<t:message code="system.label.product.routingname" default="공정명"/>'				,type:'string', allowBlank:false},
			{name: 'PRODT_DATE'		,text: '<t:message code="system.label.product.occurreddate" default="발생일"/>'			,type:'uniDate', allowBlank:false},
			{name: 'CTL_CD1'		,text: '<t:message code="system.label.product.specialremarkclass" default="특기사항 분류"/>'	,type:'string', allowBlank:false, comboType: 'AU', comboCode: 'P002'},
			{name: 'TROUBLE_TIME'	,text: '<t:message code="system.label.product.occurredtime" default="발생시간"/>'			,type:'int'},
			{name: 'TROUBLE'		,text: '<t:message code="system.label.product.summary" default="요약"/>'					,type:'string'},
			{name: 'TROUBLE_CS'		,text: '<t:message code="system.label.product.reason" default="원인"/>'					,type:'string'},
			{name: 'ANSWER'			,text: '<t:message code="system.label.product.action" default="조치"/>'					,type:'string'},
			{name: 'SEQ'			,text: 'SEQ'	,type:'string'},
			//Hidden : true
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'				,type:'string'},
			{name: 'WORK_SHOP_CODE' ,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'			,type:'string'},
			{name: 'PROG_WORK_CODE' ,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'},
			{name: 'UPDATE_DB_USER' ,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'				,type:'string'},
			{name: 'UPDATE_DB_TIME'	,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'				,type:'uniDate'},
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'			,type:'string'}
		]
	});



	var directMasterStore2 = Unilite.createStore('s_pmr100ukrv_jwMasterStore2',{
		model: 's_pmr100ukrv_jwModel2',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy2,
		loadStoreRecords : function()	{
			var param	= masterForm.getValues();
			var record	= detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.WKORD_Q			= record.get('WKORD_Q');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
			}
			console.log(param);
			this.load({
				params		: param,
				callback	: function(records, operation, success) {
					if(success)	{
						directMasterStore2.commitChanges();
					}
				}
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate, toDelete);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));


			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				var detailRecord = detailGrid.getSelectedRecord();
//				var saveFlag	= true;

				var fnCal = 0;
				var prodtSum	= this.sumBy(function(record, id){
									return true
								  }, ['PRODT_Q']);
				var A = detailRecord.get('WKORD_Q');			//작업지시량
				var D = detailRecord.get('LINE_END_YN');

				if(D == 'Y') {
					fnCal = ( prodtSum.PRODT_Q / A ) * 100
				} else {
					fnCal = 0;
				}
				if(fnCal > (100 * (BsaCodeInfo.glEndRate / 100))) {
//					saveFlag	= false;
					alert('<t:message code="system.message.product.message009" default="초과 생산 실적 범위를 벗어났습니다."/>');
					return false;
				}
//				if (saveFlag) {
					if(fnCal >= '95' /*|| ((fnCal < '95') && detailRecord.get('CONTROL_STATUS') == '9')*/) {
						if(confirm('<t:message code="system.message.product.confirm004" default="완료하시겠습니까?"/>')) {
							Ext.each(list, function(record2,i) {
								record2.set('CONTROL_STATUS', '9');
							});

						} else {
							Ext.each(list, function(record2,i) {
								if(detailRecord.get('CONTROL_STATUS') == '9') {
									record2.set('CONTROL_STATUS', '3');
								}
							});
						}
					}else{
						Ext.each(list, function(record2,i) {
							if(detailRecord.get('CONTROL_STATUS') == '9') {
								record2.set('CONTROL_STATUS', '3');
							}
						});
					}
//				}
//				if (!saveFlag) {
//					saveFlag = true;
//					return false;
//				}

				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						var record = detailGrid.getSelectedRecord();
						if(!Ext.isEmpty(master.CONTROL_STATUS)) {
							record.set("CONTROL_STATUS", master.CONTROL_STATUS);
							detailGrid.getStore().commitChanges();
						}
						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						directMasterStore2.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr100ukrv_jwGrid2');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				var wkordQ = detailGrid.getSelectedRecord().get('WKORD_Q');
				if(!Ext.isEmpty(records)) {
					var prodtSum = 0;
					var janQ	 = wkordQ;
					Ext.each(records, function(record,i) {
						prodtSum = prodtSum + record.get('PRODT_SUM');
						janQ	 = janQ - record.get('PRODT_Q');
						record.set('PRODT_SUM'	, prodtSum);
						record.set('JAN_Q'		, janQ);
					});
				}
			}
		}
	});

	var directMasterStore3 = Unilite.createStore('s_pmr100ukrv_jwMasterStore3',{
		model: 's_pmr100ukrv_jwModel3',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy3,
		loadStoreRecords : function()	{
			var param	= masterForm.getValues();
			var record	= detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.WKORD_Q			= record.get('WKORD_Q');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정

			//2. 초과실적 체크로직
			if(inValidRecs.length == 0) {
				var detailRecord = detailGrid.getSelectedRecord();
				var saveFlag= true;
				var fnCal	= 0;
				Ext.each(list, function(record,i) {
					var prodtSum	= record.get('SUM_Q') + record.get('PASS_Q');
					var A = record.get('PROG_WKORD_Q');			//작업지시량
					var D = record.get('LINE_END_YN');

					if(D == 'Y') {
						fnCal = ( prodtSum / A ) * 100
					} else {
						fnCal = 0;
					}
					if(fnCal > (100 * (BsaCodeInfo.glEndRate / 100))) {
						saveFlag	= false;
						alert('<t:message code="system.message.product.message009" default="초과 생산 실적 범위를 벗어났습니다."/>');
						return false;
					}
					if (D == 'Y') {
						if(fnCal >= '95'/* || ((fnCal < '95') && detailRecord.get('CONTROL_STATUS') == '9')*/) {
							if(confirm('<t:message code="system.message.product.confirm004" default="완료하시겠습니까?"/>')) {
								record.set('CONTROL_STATUS', '9');

							} else {
								if(detailRecord.get('CONTROL_STATUS') == '9') {
									record.set('CONTROL_STATUS', '3');
								}
							}
						}else{
							if(detailRecord.get('CONTROL_STATUS') == '9') {
								record.set('CONTROL_STATUS', '3');
							}
						}
					}
				});

				if (!saveFlag) {
					return false;
				}

				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master  = batch.operations[0].getResultSet();
						var record  = detailGrid.getSelectedRecord();
						var record2 = masterGrid3.getSelectedRecord();
						if(!Ext.isEmpty(master.CONTROL_STATUS)) {
							record.set("CONTROL_STATUS", master.CONTROL_STATUS);
							detailGrid.getStore().commitChanges();
						}

						if (BsaCodeInfo.gsMoldPunchQ_Yn == 'Y'
						&& (panelResult.getValue('WORK_SHOP_CODE') == 'WC10' || panelResult.getValue('WORK_SHOP_CODE') == 'WC20')) {
							if(!Ext.isEmpty(master.PRODT_NUM)) {
								gsProdtNum = master.PRODT_NUM;
							}
							if(!Ext.isEmpty(record2)) {
								gsArrayCnt = record2.get('ARRAY_CNT');
							}

							//목형정보 팝업 호출
							openWoodenInfoWindow();
						}

						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						directMasterStore3.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr100ukrv_jwGrid3');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				directMasterStore4.loadData({});
				gsBasicArrayCnt = records[0].get('ARRAY_CNT');
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
//				var records = masterGrid3.getStore().getData();
//				Ext.each(records, function(record,i) {
//					masterGrid3.setOutouProdtSave(record);
//				});
			}
		}
	});

	var directMasterStore4 = Unilite.createStore('s_pmr100ukrv_jwMasterStore4',{
		model: 's_pmr100ukrv_jwModel4',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy4,
		loadStoreRecords : function(record)	{
			var param= masterForm.getValues();
			if(!Ext.isEmpty(record)) {
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.WKORD_Q			= record.get('WKORD_Q');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate, toDelete);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			paramMaster.MOLDPUNCHQ_YN = BsaCodeInfo.gsMoldPunchQ_Yn;

			if(inValidRecs.length == 0) {
				var detailRecord = detailGrid.getSelectedRecord();
				var saveFlag	= true;
				var fnCal		= 0;
				var prodtSum	= this.sumBy(function(record, id){
					return true
				  }, ['PASS_Q']);

				Ext.each(list, function(record,i) {
					var A = detailRecord.get('WKORD_Q');			//작업지시량
					var D = record.get('LINE_END_YN');

					if(D == 'Y') {
						fnCal = ( prodtSum.PASS_Q / A ) * 100
					} else {
						fnCal = 0;
					}
					if(fnCal > (100 * (BsaCodeInfo.glEndRate / 100))) {
						saveFlag	= false;
						alert('<t:message code="system.message.product.message009" default="초과 생산 실적 범위를 벗어났습니다."/>');
						return false;
					}
					if (D == 'Y') {
						if(fnCal >= '95'/* || ((fnCal < '95') && detailRecord.get('CONTROL_STATUS') == '9')*/) {
							if(confirm('<t:message code="system.message.product.confirm004" default="완료하시겠습니까?"/>')) {
								record.set('CONTROL_STATUS', '9');

							} else {
								if(detailRecord.get('CONTROL_STATUS') == '9') {
									record.set('CONTROL_STATUS', '3');
								}
							}
						}else{
							if(detailRecord.get('CONTROL_STATUS') == '9') {
								record.set('CONTROL_STATUS', '3');
							}
						}
					}
				});

				if (!saveFlag) {
					return false;
				}


				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						var record = detailGrid.getSelectedRecord();
						if(!Ext.isEmpty(master.CONTROL_STATUS)) {
							record.set("CONTROL_STATUS", master.CONTROL_STATUS);
							detailGrid.getStore().commitChanges();
						}
						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						directMasterStore3.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr100ukrv_jwGrid4');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				var selectedRecord = masterGrid4.getSelectedRecord();
				if (selectedRecord) {
					UniAppManager.setToolbarButtons(['delete'], true);
				} else {
					UniAppManager.setToolbarButtons(['delete'], false);
				}
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{

			}
		}
	});

	var directMasterStore5 = Unilite.createStore('s_pmr100ukrv_jwMasterStore5',{
		model: 's_pmr100ukrv_jwModel5',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy5,
		loadStoreRecords : function()	{
			var param	= masterForm.getValues();
			var record	= detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.WKORD_Q			= record.get('WKORD_Q');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
				param.ITEM_CODE			= record.get('ITEM_CODE');
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
					/*	var master = batch.operations[0].getResultSet();
						masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
						*/
						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						directMasterStore5.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr100ukrv_jwGrid5');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				console.log("onStoreLoad");
				if(records) {
					if(records.length > 0) {
						var msg = records.length + Msg.sMB001;				//'건이 조회되었습니다.';
						UniAppManager.updateStatus(msg, true);
					}
					if(records[0].get('QUERY_FLAG') == 'N') {
						UniAppManager.setToolbarButtons(['newData', 'delete'], false);

					} else {
						UniAppManager.setToolbarButtons(['newData', 'delete'], true);
					}
				}
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
			}
		}
	});

	var directMasterStore6 = Unilite.createStore('s_pmr100ukrv_jwMasterStore6',{
		model: 's_pmr100ukrv_jwModel6',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy6,
		loadStoreRecords : function()	{
			var param	= masterForm.getValues();
			var record	= detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(record)) {
				param.WKORD_NUM			= record.get('WKORD_NUM');
				param.WKORD_Q			= record.get('WKORD_Q');
				param.PROG_WORK_CODE	= record.get('PROG_WORK_CODE');
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
					/*	var master = batch.operations[0].getResultSet();
						masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
						*/
						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr100ukrv_jwGrid6');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
			}
		}
	});



	var masterGrid2 = Unilite.createGrid('s_pmr100ukrv_jwGrid2', {
		layout : 'fit',
		region:'center',
		title : '<t:message code="system.label.product.workorderperentry" default="작업지시별등록"/>',
		store : directMasterStore2,
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: true,
			useMultipleSorting: false
		},
		sortableColumns: false,
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary',		showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'PRODT_DATE'		, width: 80},
			{dataIndex: 'PRODT_Q'			, width: 93},
			{dataIndex: 'GOOD_PRODT_Q'		, width: 93},
			{dataIndex: 'BAD_PRODT_Q'		, width: 93},
			{dataIndex: 'MAN_HOUR'			, width: 93},
			{dataIndex: 'WKORD_Q'			, width: 93 , hidden: true},
			{dataIndex: 'PRODT_SUM'			, width: 93},
			{dataIndex: 'JAN_Q'				, width: 93},
			{dataIndex: 'IN_STOCK_Q'		, width: 93},

			//20180713(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
			{dataIndex: 'PRODT_PRSN'		, width: 150},
			{dataIndex: 'PRODT_MACH'		, width: 93},
			{dataIndex: 'PRODT_TIME'		, width: 93},
			{dataIndex: 'DAY_NIGHT'			, width: 93},

			{dataIndex: 'LOT_NO'			, width: 93},

//			{dataIndex: 'PJT_CODE'			, width: 93},
			{dataIndex: 'FR_SERIAL_NO'		, width: 105},
			{dataIndex: 'TO_SERIAL_NO'		, width: 105},
			{dataIndex: 'REMARK'			, width: 200},
			{dataIndex: 'PROJECT_NO'		, width: 93},
			{dataIndex: 'NEW_DATA'			, width: 90 , hidden: true},
			{dataIndex: 'PRODT_NUM'			, width: 90 , hidden: true},
			{dataIndex: 'PROG_WORK_CODE'	, width: 80 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width: 80 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 80 , hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 80 , hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 80, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 80, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 80, hidden: true},
			{dataIndex: 'CONTROL_STATUS'	, width: 80, hidden: true},
			{dataIndex: 'GOOD_WH_CODE'		, width: 80, hidden: true},
			{dataIndex: 'GOOD_PRSN'			, width: 80, hidden: true},
			{dataIndex: 'BAD_WH_CODE'		, width: 80, hidden: true},
			{dataIndex: 'BAD_PRSN'			, width: 80, hidden: true},
			//20180605 추가
			{dataIndex: 'WKORD_NUM'			, width: 80, hidden: true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
					if(UniUtils.indexOf(e.field)) {
						return false;
					} else {
						return false;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['PRODT_DATE', 'PRODT_Q', 'GOOD_PRODT_Q', 'BAD_PRODT_Q', 'MAN_HOUR', 'LOT_NO', 'REMARK', 'FR_SERIAL_NO', 'TO_SERIAL_NO','PROJECT_NO'
												//20180713(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
												, 'PRODT_PRSN', 'PRODT_MACH', 'PRODT_TIME', 'DAY_NIGHT'
					])) {
						return true;
					} else {
						return false;
					}
				}
			},
			render: function(grid, eOpts) {
				grid.getEl().on('click', function(e, t, eOpt) {
					var detailRecord = detailGrid.getSelectedRecord();
					if(!Ext.isEmpty(detailRecord)) {
						if(detailRecord.get('CONTROL_STATUS') == '9') {
							UniAppManager.setToolbarButtons(['newData'], false);
						} else {
							UniAppManager.setToolbarButtons(['newData'], true);
						}
					}
				});
			},
			cellclick	: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ){
				if(grid.getStore().count() > 0) {
					UniAppManager.setToolbarButtons(['delete'], true);
				}
			}
		},
		setOutouProdtSave: function(grdRecord) {
			grdRecord.set('GOOD_WH_CODE'	, outouProdtSaveSearch.getValue('GOOD_WH_CODE'));
			grdRecord.set('GOOD_PRSN'		, outouProdtSaveSearch.getValue('GOOD_PRSN'));
			grdRecord.set('BAD_WH_CODE'	, outouProdtSaveSearch.getValue('BAD_WH_CODE'));
			grdRecord.set('BAD_PRSN'		, outouProdtSaveSearch.getValue('BAD_PRSN'));
		}
	});

	var masterGrid3 = Unilite.createGrid('s_pmr100ukrv_jwGrid3', {
//		split: true,
		layout	: 'fit',
		region	: 'center',
		flex	: 7,
		title	: '<t:message code="system.label.product.routingperentry" default="공정별등록"/>',
		store	: directMasterStore3,
		sortableColumns: false,
		uniOpt	:{
			//20190131 - 그리드 설정 가능하도록 주석처리
//			userToolbar		: false,
			expandLastColumn: false,
			useRowNumberer	: true,
			useMultipleSorting: true
		},
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary', showSummaryRow: false}
		],
		columns: [
			//{dataIndex: 'SEQ'				, width: 35},
			{dataIndex: 'PROG_WORK_NAME'	, width: 120},
			{dataIndex: 'PROG_UNIT'			, width: 50 , align:'center' },
			{dataIndex: 'PROG_WKORD_Q'		, width: 73},
			{dataIndex: 'SUM_Q'				, width: 66},
			{dataIndex: 'PRODT_DATE'		, width: 86 , align:'center' },
			{dataIndex: 'PASS_Q'			, width: 73},
			{dataIndex: 'GOOD_WORK_Q'		, width: 73},
			{dataIndex: 'BAD_WORK_Q'		, width: 73},
			//20180714 추가
			{dataIndex: 'ARRAY_CNT'			, width: 73},

			//20180713(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
			{dataIndex: 'PRODT_PRSN'		, width: 100,
				'editor' : Unilite.popup('Employee_G',{
					textFieldName	: 'PRODT_PRSN',
					validateBlank	: true,
					autoPopup		: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid3.uniOpt.currentRecord;
								grdRecord.set('PRODT_PRSN', records[0].PERSON_NUMB);
							},
							scope: this
						},
						'onClear': function(type) {
								var grdRecord = masterGrid3.uniOpt.currentRecord;
								grdRecord.set('PRODT_PRSN', '');
						}
						}
					})
//				editor:{ xtype: 'uniCombobox', type: 'string',comboType:'AU',comboCode:'P505',
//					listeners:{
//						beforequery:function( queryPlan, eOpts )	{
//							var store = queryPlan.combo.store;
//							store.clearFilter();
//							store.filterBy(function(record){
//								return record.get('refCode1') == panelResult.getValue('WORK_SHOP_CODE');
//							});
//						}
//					}
//				}
			},
			{dataIndex: 'PQC'		, width: 100,
				'editor' : Unilite.popup('Employee_G',{
					textFieldName	: 'PQC',
					validateBlank	: true,
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid3.uniOpt.currentRecord;
								grdRecord.set('PQC', records[0].PERSON_NUMB);
							},
							scope: this
						},
						'onClear': function(type) {
								var grdRecord = masterGrid3.uniOpt.currentRecord;
								grdRecord.set('PQC', '');
						}
						}
					})
//				editor:{ xtype: 'uniCombobox', type: 'string',comboType:'AU',comboCode:'P509',
//					listeners:{
//						beforequery:function( queryPlan, eOpts )	{
//							var store = queryPlan.combo.store;
//							store.clearFilter();
//							store.filterBy(function(record){
//								return record.get('refCode1') == panelResult.getValue('WORK_SHOP_CODE');
//							});
//						}
//					}
//				}
			},

			{dataIndex: 'PRODT_MACH'		, width: 93,
				editor:{ xtype: 'uniCombobox', type: 'string',comboType:'AU',comboCode:'P506',
					listeners:{
						beforequery:function( queryPlan, eOpts )	{
							var store = queryPlan.combo.store;
							store.clearFilter();
							store.filterBy(function(record){
								return record.get('refCode1') == panelResult.getValue('WORK_SHOP_CODE');
							});
						}
					}
				}
			},
			{dataIndex: 'PRODT_TIME'		, width: 93/*,
				renderer:function(value, metaData, record)	{
					var r = value;
					if(r.toString().length > 2) {
						r= r.toString().substring(0, r.toString().length - 2) + ':' + r.toString().substring(r.toString().length - 2, r.toString().length);

					} else {
						if(r.toString().length == 2) {
							r = '00:' + r;
						} else {
							r = '00:0' + r;
						}
					}
					return r;
				}*/
			},
			{dataIndex: 'DAY_NIGHT'			, width: 93},

			{dataIndex: 'MAN_HOUR'			, width: 90	, hidden: true},
			{dataIndex: 'JAN_Q'				, width: 76},
			{dataIndex: 'LOT_NO'			, width: 93},
			{dataIndex: 'FR_SERIAL_NO'		, width: 106},
			{dataIndex: 'TO_SERIAL_NO'		, width: 106},
			{dataIndex: 'REMARK'			, flex: 1	,minWidth: 100},

			{dataIndex: 'DIV_CODE'			, width: 10	, hidden: true},
			{dataIndex: 'PROG_WORK_CODE'	, width: 10	, hidden: true},
			{dataIndex: 'WORK_Q'			, width: 10	, hidden: true},
			{dataIndex: 'WKORD_NUM'			, width: 10	, hidden: true},
			{dataIndex: 'LINE_END_YN'		, width: 10	, hidden: true},
			{dataIndex: 'WK_PLAN_NUM'		, width: 10	, hidden: true},
			{dataIndex: 'PRODT_NUM'			, width: 10	, hidden: true},
			{dataIndex: 'CONTROL_STATUS'	, width: 10	, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width: 10	, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 10	, hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 10	, hidden: true},
			{dataIndex: 'GOOD_WH_CODE'		, width: 80	, hidden: true},
			{dataIndex: 'GOOD_PRSN'			, width: 80	, hidden: true},
			{dataIndex: 'BAD_WH_CODE'		, width: 80	, hidden: true},
			{dataIndex: 'BAD_PRSN'			, width: 80	, hidden: true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
				var detailRecord = detailGrid.getSelectedRecord();
				if(detailRecord.get('CONTROL_STATUS') == '9') {
					//unilite상에서 두 컬럼이 수정이 되나 저장은 안됨 (투입공수나 생산량 둘 중에 하나는 0이 아니어야 하는데 둘다 수정 불가능) - 그냥 return false 처리
//					if(UniUtils.indexOf(e.field, ['FR_SERIAL_NO', 'TO_SERIAL_NO'])) {
//						return true;
//					} else {
						return false;
//					}

				} else {
					if(UniUtils.indexOf(e.field, ['PRODT_DATE', 'PASS_Q', 'GOOD_WORK_Q', 'BAD_WORK_Q', 'MAN_HOUR', 'FR_SERIAL_NO', 'TO_SERIAL_NO', 'LOT_NO', 'REMARK'
												//20180713(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
												, 'PRODT_PRSN','PQC', 'PRODT_MACH', 'PRODT_TIME', 'DAY_NIGHT', 'ARRAY_CNT'
					])) {
//						if(panelResult.getValue('WORK_SHOP_CODE') == 'WC70'
//						  && UniUtils.indexOf(e.field, ['ARRAY_CNT'])) {
//							return false;
//
//						} else {
							return true;
//						}
					} else {
						return false;
					}
				}
			},
			render: function(grid, eOpts) {
//				var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
//					activeGridId = girdNm;
					UniAppManager.setToolbarButtons(['newData', 'delete'], false);
				});
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ) {
			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
					directMasterStore4.loadData({})
					directMasterStore4.loadStoreRecords(record);
				}
			},
			edit: function(editor, e) {
				var fieldName = e.field;
				if(fieldName == 'PRODT_TIME'){
					var r = e.record.get('PRODT_TIME').replace(/\:/g,'');
					if(r.toString().substring(r.toString().length - 2, r.toString().length) >= 60) {
						e.record.set(fieldName, '00:00');
						alert('<t:message code="system.message.base.message024" default="잘못된 숫자가 입력 되었습니다."/>');
						return false;
					}
					if(r.toString().length > 2) {
						r= r.toString().substring(0, r.toString().length - 2) + ':' + r.toString().substring(r.toString().length - 2, r.toString().length);

					} else {
						if(r.toString().length == 2) {
							r = '00:' + r;
						} else {
							r = '00:0' + r;
						}
					}
					e.record.set(fieldName, r);
				}
			}
		},
		setOutouProdtSave: function(grdRecord) {
			grdRecord.set('GOOD_WH_CODE'	, outouProdtSaveSearch.getValue('GOOD_WH_CODE'));
			grdRecord.set('GOOD_PRSN'		, outouProdtSaveSearch.getValue('GOOD_PRSN'));
			grdRecord.set('BAD_WH_CODE'		, outouProdtSaveSearch.getValue('BAD_WH_CODE'));
			grdRecord.set('BAD_PRSN'		, outouProdtSaveSearch.getValue('BAD_PRSN'));
		}
	});

	var masterGrid4 = Unilite.createGrid('s_pmr100ukrv_jwGrid4', {
		split: true,
		layout : 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if (this.selected.getCount() > 0) {
						Ext.getCmp('btnPrint').enable();
						Ext.getCmp('btnPrint2').enable();
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var toDelete = detailStore.getRemovedRecords();
					if (/*toDelete.length == 0 && */this.selected.getCount() == 0) {
						Ext.getCmp('btnPrint').disable();
						Ext.getCmp('btnPrint2').disable();
					}
				}
			}
		}),
		region:'center',
		flex: 3,
		title : '<t:message code="system.label.product.resultsstatus" default="실적현황"/>',
		store : directMasterStore4,
		uniOpt:{
			userToolbar			: false,
			expandLastColumn	: false,
			onLoadSelectFirst	: false,
			useRowNumberer		: true,
			useMultipleSorting	: true
		},
		sortableColumns: false,
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary',		showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'PRODT_NUM'			, width: 100, hidden: true},
			{dataIndex: 'PRODT_DATE'		, width: 80, summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.total" default="총계"/>');
					}},
			{dataIndex: 'PASS_Q'			, width: 73		, summaryType: 'sum'},
			{dataIndex: 'GOOD_WORK_Q'		, width: 73		, summaryType: 'sum'},
			{dataIndex: 'BAD_WORK_Q'		, width: 73		, summaryType: 'sum'},

			//20180713(제이월드 추가 - 작업자, 작업호기, 작업시간, 주야구분)
			{dataIndex: 'LOT_NO'			, width: 100},
			{dataIndex: 'PRODT_PRSN'		, width: 100},
			{dataIndex: 'PQC'				, width: 100},
			{dataIndex: 'PRODT_MACH'		, width: 93},
			{dataIndex: 'PRODT_TIME'		, width: 93},
			{dataIndex: 'DAY_NIGHT'			, width: 93},

			{dataIndex: 'MAN_HOUR'			, width: 76		, summaryType: 'sum'},
			{dataIndex: 'IN_STOCK_Q'		, width: 76		, summaryType: 'sum'},
			{dataIndex: 'FR_SERIAL_NO'		, width: 106	, hidden: true},
			{dataIndex: 'TO_SERIAL_NO'		, width: 106	, hidden: true},
			{dataIndex: 'REMARK'			, width: 80		, hidden: true},

			{dataIndex: 'DIV_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'PROG_WKORD_Q'		, width: 66		, hidden: true},
			{dataIndex: 'CAL_PASS_Q'		, width: 66		, hidden: true},
			{dataIndex: 'PROG_WORK_CODE'	, width: 66		, hidden: true},
			{dataIndex: 'WKORD_NUM'			, width: 66		, hidden: true},
			{dataIndex: 'WK_PLAN_NUM'		, width: 80		, hidden: true},
			{dataIndex: 'LINE_END_YN'		, width: 106	, hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 106	, hidden: true},
			{dataIndex: 'GOOD_WH_CODE'		, width: 80		, hidden: true},
			{dataIndex: 'GOOD_PRSN'			, width: 80		, hidden: true},
			{dataIndex: 'BAD_WH_CODE'		, width: 80		, hidden: true},
			{dataIndex: 'BAD_PRSN'			, width: 80		, hidden: true},

			{dataIndex: 'ITEM_CODE'			, width: 50		, hidden: true},
			{dataIndex: 'ITEM_NAME'			, width: 50		, hidden: true},
			{dataIndex: 'SPEC'				, width: 50		, hidden: true},
			{dataIndex: 'PRODT_PRSN_NAME'	, width: 50		, hidden: true},
			{dataIndex: 'PQC_NAME'			, width: 50		, hidden: true},
			{dataIndex: 'STOCK_UNIT'		, width: 50		, hidden: true},
			{dataIndex: 'END_DATE'			, width: 50		, hidden: true},
			{dataIndex: 'SORT_SEQ'			, width: 50		, hidden: true},// 라벨출력관련

			{dataIndex: 'PACK_QTY'			, width: 100	, hidden: false},
			{dataIndex: 'DATE'				, width: 100, hidden: true},
			{dataIndex: 'QR_CODE'			, width: 200, hidden: true},
			{dataIndex: 'SERIAL_NO'			, width: 80, hidden: true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {},
			render: function(grid, eOpts) {
//				var girdNm = grid.getItemId();
					grid.getEl().on('click', function(e, t, eOpt) {
	//					activeGridId = girdNm;
						UniAppManager.setToolbarButtons(['newData'], false);
						var selectedGrid = masterGrid4.getSelectedRecord();
						if(grid.getStore().count() > 0 && selectedGrid) {
							UniAppManager.setToolbarButtons(['delete'], true);
						} else {
							UniAppManager.setToolbarButtons(['delete'], false);
						}
					});
			}
		},
		setOutouProdtSave: function(grdRecord) {
			grdRecord.set('GOOD_WH_CODE'	, outouProdtSaveSearch.getValue('GOOD_WH_CODE'));
			grdRecord.set('GOOD_PRSN'		, outouProdtSaveSearch.getValue('GOOD_PRSN'));
			grdRecord.set('BAD_WH_CODE'		, outouProdtSaveSearch.getValue('BAD_WH_CODE'));
			grdRecord.set('BAD_PRSN'		, outouProdtSaveSearch.getValue('BAD_PRSN'));
		}
	});

	var masterGrid5 = Unilite.createGrid('s_pmr100ukrv_jwGrid5', {
		layout : 'fit',
		region: 'center',
		title : '<t:message code="system.label.product.defectdetailsentry" default="불량내역등록"/>',
		store : directMasterStore5,
		uniOpt:{	expandLastColumn: true,
					useRowNumberer: true,
					useMultipleSorting: true
		},
		sortableColumns: false,
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
		columns: [
			{dataIndex: 'QUERY_FLAG'		, width: 60		, hidden: true},
			{dataIndex: 'WKORD_NUM'			, width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{dataIndex: 'PROG_WORK_NAME'	, width: 166,
				'editor': Unilite.popup('PROG_WORK_CODE_G',{
					textFieldName : 'PROG_WORK_NAME',
					DBtextFieldName : 'PROG_WORK_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid5.uniOpt.currentRecord;
								grdRecord.set('PROG_WORK_CODE',records[0]['PROG_WORK_CODE']);
								grdRecord.set('PROG_WORK_NAME',records[0]['PROG_WORK_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)	{
								var grdRecord = masterGrid5.uniOpt.currentRecord;
								grdRecord.set('PROG_WORK_CODE','');
								grdRecord.set('PROG_WORK_NAME','');
						},
						applyextparam: function(popup){
							var param =  panelResult.getValues();
							record = detailGrid.getSelectedRecord();
							popup.setExtParam({'DIV_CODE': param.DIV_CODE});
							popup.setExtParam({'ITEM_CODE': record.get('ITEM_CODE')});
							popup.setExtParam({'WORK_SHOP_CODE': record.get('WORK_SHOP_CODE')});
						}
					}
				})
			},
			{dataIndex: 'PRODT_DATE'		, width: 100},
			{dataIndex: 'BAD_CODE'			, width: 106},
			{dataIndex: 'BAD_Q'				, width: 100, summaryType: 'sum'},
			{dataIndex: 'REMARK'			, width: 800},

			{dataIndex: 'DIV_CODE'			, width: 0 , hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 0 , hidden: true},
			{dataIndex: 'PROG_WORK_CODE'	, width: 0 , hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 0 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width: 0 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 0 , hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 0 , hidden: true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom && e.record.get('QUERY_FLAG') == 'Y'){
					if (UniUtils.indexOf(e.field,
											['PROG_WORK_CODE','PROG_WORK_NAME','PRODT_DATE','BAD_CODE']))
						return false
				}
				if(e.record.phantom || e.record.get('QUERY_FLAG') == 'N'){
					if (UniUtils.indexOf(e.field,
											['WKORD_NUM']))
						return false
				}
			},
			render: function(grid, eOpts) {
				grid.getEl().on('click', function(e, t, eOpt) {
					if(Ext.isEmpty(e.record)) {
						return false;
					}
					if(e.record.get('QUERY_FLAG') == 'N') {
						UniAppManager.setToolbarButtons(['newData', 'delete'], false);

					} else {
						UniAppManager.setToolbarButtons('newData', true);
						if(grid.getStore().count() > 0) {
							UniAppManager.setToolbarButtons(['delete'], true);
						} else {
							UniAppManager.setToolbarButtons(['delete'], false);
						}
					}
				});
			}
		}
	});

	var masterGrid6 = Unilite.createGrid('s_pmr100ukrv_jwGrid6', {
		layout : 'fit',
		region:'center',
		title : '<t:message code="system.label.product.specialremarkentry" default="특기사항등록"/>',
		store : directMasterStore6,
		uniOpt:{
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: true
		},
		sortableColumns: false,
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary',		showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'WKORD_NUM'			, width: 120 , hidden: true},
			{dataIndex: 'PROG_WORK_NAME'		, width: 166 ,
				'editor': Unilite.popup('PROG_WORK_CODE_G',{
				textFieldName : 'PROG_WORK_NAME',
				DBtextFieldName : 'PROG_WORK_NAME',
				autoPopup: true,
				listeners: {
					'onSelected': {
						fn: function(records, type  ){
							var grdRecord = masterGrid6.uniOpt.currentRecord;
							grdRecord.set('PROG_WORK_CODE',records[0]['PROG_WORK_CODE']);
							grdRecord.set('PROG_WORK_NAME',records[0]['PROG_WORK_NAME']);
						},
						scope: this
					},
					'onClear' : function(type)	{
							var grdRecord = masterGrid6.uniOpt.currentRecord;
							grdRecord.set('PROG_WORK_CODE','');
							grdRecord.set('PROG_WORK_NAME','');
					},
					applyextparam: function(popup){
							var param =  panelResult.getValues();
							record = detailGrid.getSelectedRecord();
							popup.setExtParam({'DIV_CODE': param.DIV_CODE});
							popup.setExtParam({'ITEM_CODE': record.get('ITEM_CODE')});
							popup.setExtParam({'WORK_SHOP_CODE': record.get('WORK_SHOP_CODE')});
					}
				}
			})},
			{dataIndex: 'PRODT_DATE'			, width: 100},
			{dataIndex: 'CTL_CD1'			, width: 106},
			{dataIndex: 'TROUBLE_TIME'		, width: 100},
			{dataIndex: 'TROUBLE'			, width: 166},
			{dataIndex: 'TROUBLE_CS'			, width: 166},
			{dataIndex: 'ANSWER'				, width: 800},
			{dataIndex: 'SEQ'				, width: 0},
			//Hidden : true
			{dataIndex: 'DIV_CODE'			, width: 0 , hidden:true},
			{dataIndex: 'WORK_SHOP_CODE'		, width: 0 , hidden:true},
			{dataIndex: 'PROG_WORK_CODE'		, width: 0 , hidden:true},
			{dataIndex: 'UPDATE_DB_USER'		, width: 0 , hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 0 , hidden:true},
			{dataIndex: 'COMP_CODE'			, width: 0 , hidden:true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if (UniUtils.indexOf(e.field,
											['PROG_WORK_CODE','PROG_WORK_NAME','PRODT_DATE','CTL_CD1']))
						return false
				}if(!e.record.phantom||e.record.phantom){
					if (UniUtils.indexOf(e.field,
											['WKORD_NUM']))
						return false
				}
			},
			render: function(grid, eOpts) {
				grid.getEl().on('click', function(e, t, eOpt) {
					UniAppManager.setToolbarButtons(['newData'], true);
					if(grid.getStore().count() > 0) {
						UniAppManager.setToolbarButtons(['delete'], true);
					} else {
						UniAppManager.setToolbarButtons(['delete'], false);
					}
				});
			}
		}
	});



	var tab = Unilite.createTabPanel('tabPanel',{
		split: true,
		border : false,
		region:'south',
		items: [
//			 masterGrid2,									//작업지시별등록 사용 안 함
			{	layout: {type: 'hbox', align: 'stretch'},
				title : '<t:message code="system.label.product.routingperentry" default="공정별등록"/>' ,
				id: 's_pmr100ukrv_jwGrid3_1',
				items: [
					masterGrid3,
					masterGrid4
				]
			},
			masterGrid5,
			masterGrid6
		],
		listeners:  {
			beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )   {
				if(!UniAppManager.app.isValidSearchForm()){
					return false;
				}
				if(UniAppManager.app._needSave()) {
					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
						UniAppManager.app.onSaveDataButtonDown();
						return false;
					}
				}
			},
			tabChange:  function ( tabPanel, newCard, oldCard, eOpts ) {
				UniAppManager.setToolbarButtons(['newData', 'delete'], false);
				Ext.getCmp('btnPrint').setDisabled(true);//출력버튼 활성화
				Ext.getCmp('btnPrint2').setDisabled(true);//출력버튼 활성화

				var newTabId	= newCard.getId();
				var record		= detailGrid.getSelectedRecord();
				if(!Ext.isEmpty(record)) {
					if(newTabId == 's_pmr100ukrv_jwGrid2'){
						directMasterStore2.loadStoreRecords(record);
					} else if(newTabId == 's_pmr100ukrv_jwGrid3_1'){
						directMasterStore3.loadStoreRecords(record);
					} else if(newTabId == 's_pmr100ukrv_jwGrid5'){
						directMasterStore5.loadStoreRecords(record);
					} else {
						directMasterStore6.loadStoreRecords(record);
					}
				}
			}
		}
	});



	var outouProdtSaveSearch = Unilite.createSearchForm('outouProdtSaveForm', {		// 생산실적 자동입고
		layout: {type : 'uniTable', columns : 2},
		height: 230,
		items:[
			{
				xtype: 'container',
				html: '※ <t:message code="system.label.product.goodreceipt" default="양품입고"/>',
				colspan: 2,
				style: {
					color: 'blue'
				}
			},{
				fieldLabel: '<t:message code="system.label.product.receiptwarehouse" default="입고창고"/>',
				name:'GOOD_WH_CODE',
				allowBlank: false,
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				colspan: 2
			},{
				fieldLabel: '<t:message code="system.label.product.receiptcharger" default="입고담당자"/>',
				name:'GOOD_PRSN',
				allowBlank: false,
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024'
			},{
				fieldLabel: '<t:message code="system.label.product.gooditemqty" default="양품량"/>',
				name:'GOOD_Q',
				xtype: 'uniTextfield'
			},{
				xtype: 'container',
				html: '※ <t:message code="system.label.product.defectreceipt" default="불량입고"/>',
				colspan: 2,
				style: {
					color: 'blue'
				}
			},{
				fieldLabel: '<t:message code="system.label.product.receiptwarehouse" default="입고창고"/>',
				name:'BAD_WH_CODE',
				allowBlank: true,
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				colspan: 2
			},{
				fieldLabel: '<t:message code="system.label.product.receiptcharger" default="입고담당자"/>',
				name:'BAD_PRSN',
				allowBlank: true,
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024'
			},{
				fieldLabel: '<t:message code="system.label.product.defectqty" default="불량수량"/>',
				name:'BAD_Q',
				xtype: 'uniTextfield'
			}
		],
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
							var popupFC = item.up('uniPopupField') ;
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
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	function openoutouProdtSave() {	// 생산실적 자동입고
		if(!outouProdtSave) {
			outouProdtSave = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.product.productionautoinput" default="생산실적 자동입고"/>',
				width: 550,
				height: 230,
				layout: {type:'vbox', align:'stretch'},
				items: [outouProdtSaveSearch],
				tbar:  ['->',
					{itemId : 'saveBtn',
					text: '<t:message code="system.label.product.confirm" default="확인"/>',
					handler: function() {
						var activeTabId = tab.getActiveTab().getId();
						if(activeTabId == 's_pmr100ukrv_jwGrid2') {	// 작업지시별 등록
							if(outouProdtSaveSearch.setAllFieldsReadOnly(true) == false){
								return false;
							} else {
								var records = masterGrid2.getStore().getNewRecords();
								Ext.each(records, function(record,i) {
									masterGrid2.setOutouProdtSave(record);
								});
								outouProdtSave.hide();
								directMasterStore2.saveStore();
							}
						}
						if(activeTabId == 's_pmr100ukrv_jwGrid3_1') {	// 공정별 등록
							if(outouProdtSaveSearch.setAllFieldsReadOnly(true) == false){
								return false;
							} else {
								//공정별등록 그리드 관련 로직
								if(Ext.isEmpty(outouProdtSaveSearch.getValue('BAD_WH_CODE')) && outouProdtSaveSearch.getValue('BAD_Q') > 0) {
									alert('불량재고 입고창고를 선택하세요');
									return false;
								}
								var updateData = masterGrid3.getStore().getUpdatedRecords();
								if(!Ext.isEmpty(updateData)) {
									Ext.each(updateData, function(updateRecord,i) {
										if(updateRecord.get('LINE_END_YN') == 'Y'){
											masterGrid3.setOutouProdtSave(updateRecord);
										}
									});
									outouProdtSave.hide();
									directMasterStore3.saveStore();
								}

								//실적현황 그리드 관련 로직
								var deleteData = masterGrid4.getStore().getRemovedRecords();	//실적현황 그리드의 삭제된 데이터
								if(!Ext.isEmpty(deleteData)) {
									Ext.each(deleteData, function(deleteRecord,i) {
										if(deleteRecord.get('LINE_END_YN') == 'Y'){
											masterGrid4.setOutouProdtSave(deleteRecord);
										}
									});
									outouProdtSave.hide();
									directMasterStore4.saveStore();
								}
							}
						}
					},
					disabled: false
					}, {
						itemId : 'CloseBtn',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							outouProdtSave.hide();
						}
					}
				],
				listeners: {beforehide: function(me, eOpt)
					{
						outouProdtSaveSearch.clearForm();
					},
					beforeshow: function( panel, eOpts )	{
						var activeTabId = tab.getActiveTab().getId();
						var detailRecord = detailGrid.getSelectedRecord();
						if(activeTabId == 's_pmr100ukrv_jwGrid2') {	// 작업지시별 등록
							var record = masterGrid2.getSelectedRecord();
							outouProdtSaveSearch.setValue('GOOD_Q',record.get('GOOD_PRODT_Q'));
							outouProdtSaveSearch.setValue('BAD_Q',record.get('BAD_PRODT_Q'));

							outouProdtSaveSearch.setValue('GOOD_WH_CODE',detailRecord.get('WH_CODE'));
							outouProdtSaveSearch.setValue('GOOD_PRSN','05');


						}
						if(activeTabId == 's_pmr100ukrv_jwGrid3_1') {	// 공정 등록
							var record = masterGrid3.getSelectedRecord();
							outouProdtSaveSearch.setValue('GOOD_Q',record.get('GOOD_WORK_Q'));
							outouProdtSaveSearch.setValue('BAD_Q',record.get('BAD_WORK_Q'));

							outouProdtSaveSearch.setValue('GOOD_WH_CODE',detailRecord.get('WH_CODE'));
							outouProdtSaveSearch.setValue('GOOD_PRSN','05');
						}
					}
				}
			})
		}
		outouProdtSave.center();
		outouProdtSave.show();
	}




	//목형정보 window
	var woodenInfoProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 목형정보
		api: {
			read	: 's_pmr100ukrv_jwService.selectWoodenInfo',
			update	: 's_pmr100ukrv_jwService.updateWoodenInfoDetail',
			create	: 's_pmr100ukrv_jwService.insertWoodenInfoDetail',
			destroy	: 's_pmr100ukrv_jwService.deleteWoodenInfoDetail',
			syncAll	: 's_pmr100ukrv_jwService.saveWoodenInfoAll'
		}
	});
	var woodenInfoSearch = Unilite.createSearchForm('woodenInfoSearchForm', {
		layout	: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items	: [{
				fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				readOnly	: true
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				readOnly		: true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
						},
						scope: this
					},
					onClear: function(type)	{
					},
					applyextparam: function(popup){
					}
				}
			}),{
				fieldLabel	: 'PRODT_NUM',
				name		: 'PRODT_NUM',
				xtype		: 'uniTextfield',
				readOnly	: true,
				hidden		: true
			},{
				fieldLabel	: 'WKORD_NUM',
				name		: 'WKORD_NUM',
				xtype		: 'uniTextfield',
				readOnly	: true,
				hidden		: true
			},{
				fieldLabel	: 'PRODT_DATE',
				name		: 'PRODT_DATE',
				xtype		: 'uniDatefield',
				readOnly	: true,
				hidden		: true
			},{
				fieldLabel	: 'PRODT_QTY',
				name		: 'PRODT_QTY',
				xtype		: 'uniNumberfield',
				type		: 'uniQty',
				readOnly	: true,
				hidden		: true
			},{
				fieldLabel	: '<t:message code="system.label.product.totalpunchcount" default="총타발수"/>',
				name		: 'PRESS_CNT',
				xtype		: 'uniNumberfield',
				readOnly	: true,
				hidden		: false
			},{
				fieldLabel	: 'WORK_SHOP_CODE',
				name		: 'WORK_SHOP_CODE',
				xtype		: 'uniTextfield',
				readOnly	: true,
				hidden		: true
			},{
				fieldLabel	: 'ARRAY_CNT',
				name		: 'ARRAY_CNT',
				xtype		: 'uniNumberfield',
				readOnly	: true,
				hidden		: false
			}]
	}); //createSearchForm
	Unilite.defineModel('S_pmr100ukrv_jwWoodenInfoModel', {
		fields: [
			{name: 'WOODEN_CODE'	, text: '<t:message code="system.label.product.woodencode" default="목형코드"/>'		, type: 'string'	, editable: false},
			{name: 'SN_NO'			, text: 'S/N (LOT)'			, type: 'string'	, editable: false},
			{name: 'PUNCH_Q'		, text: '<t:message code="system.label.product.punchqty" default="타발수"/>'			, type: 'int'		, allowBlank: false},
			{name: 'TOT_PUNCH_Q'	, text: '<t:message code="system.label.product.totalpunchqty" default="누적타발수"/>'	, type: 'int'		, editable: false},
			{name: 'MIN_PUNCH_Q'	, text: 'Min'				, type: 'int'		, editable: false},
			{name: 'MAX_PUNCH_Q'	, text: 'Max'				, type: 'int'		, editable: false},

			{name: 'PRODT_NUM'		, text: 'PRODT_NUM'			, type: 'string'	, editable: false},
			{name: 'PRODT_DATE'		, text: 'PRODT_DATE'		, type: 'uniDate'	, editable: false},
			{name: 'PRODT_QTY'		, text: 'PRODT_QTY'			, type: 'uniQty'	, editable: false},
			{name: 'ARRAY_CNT'		, text: 'ARRAY_CNT'			, type: 'int'		, editable: false},
			{name: 'PRESS_CNT'		, text: 'PRESS_CNT'			, type: 'int'		, editable: false},
			{name: 'WORK_SHOP_CODE'	, text: 'WORK_SHOP_CODE'	, type: 'string'	, editable: false},
			{name: 'QUERY_FLAG'		, text: 'QUERY_FLAG'		, type: 'string'	, editable: false},
			{name: 'EQU_CODE'		, text: 'EQU_CODE'			, type: 'string'	, hidden: true}
		]
	});
	var woodenInfoStore = Unilite.createStore('S_pmr100ukrv_jwWoodenInfoStore',{
		model: 'S_pmr100ukrv_jwWoodenInfoModel',
		uniOpt: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: true,				// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false				// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: woodenInfoProxy,
		loadStoreRecords : function(QUERY_FLAG)  {
			var param= woodenInfoSearch.getValues();
			param.QUERY_FLAG = QUERY_FLAG;

			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			// 1. 마스터 정보 파라미터 구성
			var paramMaster= woodenInfoSearch.getValues();	// syncAll 수정

			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						// 2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
//						woodenInfoStore.loadStoreRecords('2');
						woodenInfoWindow.hide();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('S_pmr100ukrv_jwWoodenInfoGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	//목형정보 저장할 그리드 정의
	var woodenInfoGrid = Unilite.createGrid('S_pmr100ukrv_jwWoodenInfoGrid', {
		layout	: 'fit',
		store	: woodenInfoStore,
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: false,
			onLoadSelectFirst	: false
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if(selectRecord.get('QUERY_FLAG') == '2') {
						woodenInfoWindow.down('#saveBtn').disable();
						return false;
					}
					var master3Record	= masterGrid3.getSelectedRecord();
					var punchQ			= woodenInfoSearch.getValue('PRESS_CNT');
					selectRecord.set('PUNCH_Q'	, punchQ);											//전체 타발 수
					selectRecord.set('ARRAY_CNT', punchQ / woodenInfoSearch.getValue('ARRAY_CNT'));	//실적하나당 타발 수 입력하는 걸로 변경(SP에서 바로 뺄 수 있도록)

					if (this.selected.getCount() > 0) {
						woodenInfoWindow.down('#saveBtn').enable();
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					selectRecord.set('PUNCH_Q'	, 0);
					selectRecord.set('ARRAY_CNT', 0);

					if (this.selected.getCount() == 0) {
						woodenInfoWindow.down('#saveBtn').disable();
					}
				}
			}
		}),
		columns	: [
			{ dataIndex: 'WOODEN_CODE'	, width: 110},
			{ dataIndex: 'SN_NO'		, width: 120},
			{ dataIndex: 'PUNCH_Q'		, width: 90 },
			{ dataIndex: 'TOT_PUNCH_Q'	, width: 90 },
			{ dataIndex: 'MIN_PUNCH_Q'	, width: 90 },
			{ dataIndex: 'MAX_PUNCH_Q'	, width: 90 },
			{ dataIndex: 'ARRAY_CNT'	, width: 90 , hidden: true},
			{ dataIndex: 'EQU_CODE'		, width: 90 , hidden: true}
		] ,
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.get('QUERY_FLAG') == '2') {
					return false;
				}
			},
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function(record) {
		}
	});

	//목형정보 window
	function openWoodenInfoWindow() {
		if(!woodenInfoWindow) {
			woodenInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: 'Wooden Infomation Window',
				width	: 650,
				height	: 300,
				layout	: {type:'vbox', align:'stretch'},
				items	: [woodenInfoSearch, woodenInfoGrid],
				tbar	:['->',{
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.commonJS.btnSave" default="저장"/>',
					handler	: function() {
						var records = woodenInfoGrid.getSelectedRecords();
						if(Ext.isEmpty(records)) {
							return false;
						}
//						var sumRecords	= 0;
//						var totPunchQ	= woodenInfoSearch.getValue('PRESS_CNT');
//						Ext.each(records, function(record,i) {
//							sumRecords = sumRecords + record.get('PUNCH_Q');
//						});
//						if(sumRecords != totPunchQ) {
//							alert('<t:message code="system.message.product.message010" default="총타발 수와 입력한 타발 수의 합이 일치하지 않습니다."/>');
//							return false;
//						}
						woodenInfoStore.saveStore();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.product.close" default="닫기"/>',
					handler	: function() {
						woodenInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforeshow: function( panel, eOpts )	{
						var detailRecord	= detailGrid.getSelectedRecord();
						var master3Record	= masterGrid3.getSelectedRecord();
						var arraycnt		= detailRecord.get('ARRAY_CNT');
						if(arraycnt == 0) {
							arraycnt = 1;
						}
						woodenInfoSearch.setValue('DIV_CODE'		, detailRecord.get('DIV_CODE'));
						woodenInfoSearch.setValue('ITEM_CODE'		, detailRecord.get('MAIN_ITEM_CODE'));
						woodenInfoSearch.setValue('ITEM_NAME'		, detailRecord.get('MAIN_ITEM_NAME'));

						woodenInfoSearch.setValue('PRODT_NUM'		, gsProdtNum);
						woodenInfoSearch.setValue('WKORD_NUM'		, detailRecord.get('WKORD_NUM'));
						woodenInfoSearch.setValue('PRODT_DATE'		, master3Record.get('PRODT_DATE'));
						woodenInfoSearch.setValue('PRODT_QTY'		, master3Record.get('PASS_Q'));
						woodenInfoSearch.setValue('PRESS_CNT'		, Unilite.nvl(master3Record.get('PASS_Q'), 0) / Unilite.nvl(arraycnt , 1));
						woodenInfoSearch.setValue('WORK_SHOP_CODE'	, panelResult.getValue('WORK_SHOP_CODE'));
						woodenInfoSearch.setValue('ARRAY_CNT'		, gsArrayCnt);

						woodenInfoStore.loadStoreRecords('1');
						gsProdtNum = '';
						gsArrayCnt = '';
					},
					beforehide: function(me, eOpt)	{
						woodenInfoGrid.reset();
//						fnGrid3Save(selectDetailRecord);
					},
					beforeclose: function( panel, eOpts )	{
						woodenInfoGrid.reset();
//						fnGrid3Save(selectDetailRecord);
					},
					show: function( panel, eOpts )	{
					}
				}
			})
		}
		woodenInfoWindow.center();
		woodenInfoWindow.show();
	};





	Unilite.Main( {
		id: 's_pmr100ukrv_jwApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border : false,
			items:[
				detailGrid, tab, panelResult
			]
		},
			masterForm
		],
		fnInitBinding: function() {
			setup_web_print();
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			detailGrid.disabledLinkButtons(false);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
/*	기존로직
			if(masterForm.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
		var orderNo = masterForm.getValue('WKORD_NUM');
			if(Ext.isEmpty(orderNo)) {
				var param= masterForm.getValues();
				detailStore.loadStoreRecords();
			}
*/
			detailStore.loadStoreRecords();

			//모든 탭 초기화 후, detailGrid 조회
			directMasterStore2.loadData({})
			directMasterStore3.loadData({})
			directMasterStore4.loadData({})
			directMasterStore5.loadData({})
			directMasterStore6.loadData({})

			UniAppManager.setToolbarButtons(['newData'], true);
		},
		onNewDataButtonDown: function()	{
			//if(!this.checkForNewDetail()) return false;
			var selectedDetailGrid = detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(selectedDetailGrid)) {
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 's_pmr100ukrv_jwGrid2') {
					var allRecords = directMasterStore2.data.items;
					var cnt = 0;
					Ext.each(allRecords,function(r,i){
						if(r.phantom == true){
							cnt = cnt + 1;
						}
					})
					if(cnt == 0){
						var record = detailGrid.getSelectedRecord();
						var wkordNum = record.get('WKORD_NUM');
						//var prodtNum = masterForm.getValue('PRODT_NUM');
						var seq = detailStore.max('PRODT_Q');
						if(!seq) seq = 1;
						else  seq += 1;
						var prodtDate	= UniDate.get('today');
						var progWorkCode = record.get('PROG_WORK_CODE');
						var wkordQ	= record.get('WKORD_Q');
						var prodtQ	= 0; //생산량
						var goodProdtQ= 0; //양품량
						var badProdtQ	= 0; //불량량
						var manHour	  = 0; //투입공수
						var lotNo		= record.get('LOT_NO');
						var remark	= record.get('REMARK');
						var projectNo	= record.get('PROJECT_NO');
						var pjtCode	  = record.get('PJT_CODE');
						var divCode	  = masterForm.getValue('DIV_CODE');
						var workShopCode = masterForm.getValue('WORK_SHOP_CODE');
						var itemCode	  = masterForm.getValue('ITEM_CODE1');
						var controlStatus= Ext.getCmp('rdoSelect').getChecked()[0].inputValue
						var newData		= 'N';
						var prodtPrsn	= record.get('PRODT_PRSN');
						var prodtTime	= record.get('PRODT_TIME');
						var prodtMach	= record.get('PRODT_MACH');
						var dayNight	= record.get('DAY_NIGHT');

						var r = {
							WKORD_NUM		: wkordNum,
							//PRODT_NUM		: prodtNum,
							PRODT_Q			: seq,
							PRODT_DATE		: prodtDate,
							PROG_WORK_CODE	: progWorkCode,
							WKORD_Q			: wkordQ,
							PRODT_Q			: prodtQ,
							GOOD_PRODT_Q	: goodProdtQ,
							BAD_PRODT_Q		: badProdtQ,
							MAN_HOUR		: manHour,
							LOT_NO			: lotNo,
							REMARK			: remark,
							PROJECT_NO		: projectNo,
							PJT_CODE		: pjtCode,
							DIV_CODE		: divCode,
							WORK_SHOP_CODE	: workShopCode,
							ITEM_CODE		: itemCode,
							CONTROL_STATUS	: controlStatus,
							NEW_DATA		: newData,
							PRODT_PRSN		: prodtPrsn,
							PRODT_TIME		: prodtTime,
							PRODT_MACH		: prodtMach,
							DAY_NIGHT		: dayNight
							//COMP_CODE		:compCode
						};
						masterGrid2.createRow(r, 'PRODT_Q', masterGrid2.getStore().getCount() - 1);
					}else{
						return false;
					}
				} else if(activeTabId == 's_pmr100ukrv_jwGrid5') {
					 var record			= detailGrid.getSelectedRecord();
					 var divCode		= masterForm.getValue('DIV_CODE');
					 var prodtDate		= UniDate.get('today');
					 var workShopcode	= record.get('WORK_SHOP_CODE');
					 var wkordNum		= record.get('WKORD_NUM');
					 var itemCode		= record.get('ITEM_CODE');
					 //20181213 불량내역 추가 시, 바로 위의 공정 그래도 뿌려주도록 수정
					 var progWorkCode	= masterGrid5.getStore().getAt(0).get('PROG_WORK_CODE');
					 var progWorkName	= masterGrid5.getStore().getAt(0).get('PROG_WORK_NAME');
					 var badCode		= '';
					 var badQ			= 0;
					 var remark			= '';

					 var r = {
						DIV_CODE			: divCode,
						PRODT_DATE			: prodtDate,
						WORK_SHOP_CODE		: workShopcode,
						WKORD_NUM			: wkordNum,
						ITEM_CODE			: itemCode,
						PROG_WORK_CODE		: progWorkCode,
						PROG_WORK_NAME		: progWorkName,
						BAD_CODE			: badCode,
						BAD_Q				: badQ,
						REMARK				: remark
						//COMP_CODE			:compCode
					};
					masterGrid5.createRow(r);
				} else if(activeTabId == 's_pmr100ukrv_jwGrid6') {
					var record = detailGrid.getSelectedRecord();
					 var divCode		= masterForm.getValue('DIV_CODE');
					 var prodtDate		= UniDate.get('today');
					 var workShopcode	= record.get('WORK_SHOP_CODE');
					 var wkordNum		= record.get('WKORD_NUM');
					 var itemCode		= record.get('ITEM_CODE');
					 var progWorkName	= '';
					 var ctlCd1			= '';
					 var troubleTime	= '';
					 var trouble		= '';
					 var troubleCs		= '';
					 var answer			= '';

					 var r = {
						DIV_CODE				: divCode,
						PRODT_DATE				: prodtDate,
						WORK_SHOP_CODE			: workShopcode,
						WKORD_NUM				: wkordNum,
						ITEM_CODE				: itemCode,
						PROG_WORK_NAME			: progWorkName,
						CTL_CD1					: ctlCd1,
						TROUBLE_TIME			: troubleTime,
						TROUBLE					: trouble,
						TROUBLE_CS				: troubleCs,
						ANSWER					: answer
						//COMP_CODE				:compCode
					};
					masterGrid6.createRow(r);
				}
				masterForm.setAllFieldsReadOnly(false);
			} else {
				alert(Msg.sMA0256);
				return false;
			}
		},
		onResetButtonDown: function() {		// 새로고침 버튼
			this.suspendEvents();
			masterForm.clearForm();
			panelResult.clearForm();

			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			masterGrid2.reset();
			masterGrid3.reset();
			masterGrid4.reset();
			masterGrid5.reset();
			masterGrid6.reset();
			this.fnInitBinding();
			detailStore.clearData();
			directMasterStore2.clearData();
			directMasterStore3.clearData();
			directMasterStore4.clearData();
			directMasterStore5.clearData();
			directMasterStore6.clearData();
		},
		onDeleteDataButtonDown: function() {
			var selectedDetailGrid = detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(selectedDetailGrid)) {
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 's_pmr100ukrv_jwGrid2') {
					var selRow = masterGrid2.getSelectedRecord();
					if(selRow.phantom === true)	{
						masterGrid2.deleteSelectedRow();
					}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						masterGrid2.deleteSelectedRow();
					}
				} else if(activeTabId == 's_pmr100ukrv_jwGrid3_1') {	//masterGrid3은 삭제로직 없음, masterGrid4가 삭제
					var selRow = masterGrid4.getSelectedRecord();
					if(selRow.phantom === true)	{
						masterGrid4.deleteSelectedRow();
					}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						var detailGridSelectedRecord = detailGrid.getSelectedRecord();
						var saveFlag = true;
						//20190124 무검사품이고 수동입고일 때,
						if(detailGridSelectedRecord.get('INSPEC_YN') == 'N' && detailGridSelectedRecord.get('RESULT_YN') == '1') {
							var masterGrid4SelectedRecords = masterGrid4.getSelectedRecords();
							Ext.each(masterGrid4SelectedRecords, function(masterGrid4SelectedRecord,i) {
								if(masterGrid4SelectedRecord.get('IN_STOCK_Q') > 0) {
									saveFlag = false;
									return false;
								}
							});
						}
						if(saveFlag) {
							masterGrid4.deleteSelectedRow();
						} else {
							alert('<t:message code="system.message.product.message041" default="입고된 수량이 존재합니다. 삭제 할 수 없습니다."/>');
							return false;
						}
					}
				} else if(activeTabId == 's_pmr100ukrv_jwGrid5') {
					var selRow = masterGrid5.getSelectedRecord();
					if(selRow.phantom === true)	{
						masterGrid5.deleteSelectedRow();
					}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						masterGrid5.deleteSelectedRow();
					}
				} else if(activeTabId == 's_pmr100ukrv_jwGrid6') {
					var selRow = masterGrid6.getSelectedRecord();
					if(selRow.phantom === true)	{
						masterGrid6.deleteSelectedRow();
					}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						masterGrid6.deleteSelectedRow();
					}
				}
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('s_pmr100ukrv_jwAdvanceSerch');
			if(as.isHidden())	{
				as.show();
			} else {
				as.hide()
			}
		},
		onSaveDataButtonDown: function(config) {
			var activeTabId = tab.getActiveTab().getId();
			var selectDetailRecord = detailGrid.getSelectedRecord();

			//detailStore.saveStore();
			if(activeTabId == 's_pmr100ukrv_jwGrid2') {						// 작업지시별 등록
				masterForm.setValue('RESULT_TYPE', "1");
				var inValidRecs	= masterGrid2.getStore().getInvalidRecords();
				var newData		= masterGrid2.getStore().getNewRecords();

				if(inValidRecs.length == 0) {
					if(newData && newData.length > 0) {
						if(selectDetailRecord.get('RESULT_YN') == '2'){
							openoutouProdtSave();
						} else {
							directMasterStore2.saveStore();
						}
					} else {
						directMasterStore2.saveStore();
					}
				} else {
					var grid = Ext.getCmp('s_pmr100ukrv_jwGrid2');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}

			} else if(activeTabId == 's_pmr100ukrv_jwGrid3_1') {				// 공정별 등록
				masterForm.setValue('RESULT_TYPE', "2");
				var inValidRecs1	= masterGrid3.getStore().getInvalidRecords();
				var inValidRecs2	= masterGrid4.getStore().getInvalidRecords();
				var updateData		= masterGrid3.getStore().getUpdatedRecords();	//공정별 등록 그리드의 수정된 데이터
				var deleteData		= masterGrid4.getStore().getRemovedRecords();	//실적현황 그리드의 삭제된 데이터

				//공정별 등록 그리드의 수정된 데이터 관련 로직
				if(inValidRecs1.length != 0) {
					var grid = Ext.getCmp('s_pmr100ukrv_jwGrid3');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs1);
				}

				//실적현황 그리드의 삭제된 데이터 관련 로직
				if(inValidRecs2.length != 0) {
					var grid = Ext.getCmp('s_pmr100ukrv_jwGrid3');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs2);
				}

//				if (BsaCodeInfo.gsMoldPunchQ_Yn == 'Y'
//				&& (panelResult.getValue('WORK_SHOP_CODE') == 'WC10' || panelResult.getValue('WORK_SHOP_CODE') == 'WC20')) {
//					//목형정보 팝업 호출
//					openWoodenInfoWindow(selectDetailRecord);
//
//				} else {
					fnGrid3Save(selectDetailRecord);
//				}

			} else if(activeTabId == 's_pmr100ukrv_jwGrid5') {	// 불량내역 등록
				masterForm.setValue('RESULT_TYPE', "3");
				directMasterStore5.saveStore();
			} else if(activeTabId == 's_pmr100ukrv_jwGrid6') {	// 특기사항 등록
				masterForm.setValue('RESULT_TYPE', "4");
				directMasterStore6.saveStore();
			}
		},
		rejectSave: function() {
			var rowIndex = detailGrid.getSelectedRowIndex();
			detailGrid.select(rowIndex);
			detailStore.rejectChanges();

			if(rowIndex >= 0){
				detailGrid.getSelectionModel().select(rowIndex);
				var selected = detailGrid.getSelectedRecord();

				var selected_doc_no = selected.data['DOC_NO'];
				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {
					}
				);
			}
			detailStore.onStoreActionEnable();

		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('s_pmr100ukrv_jwFileUploadPanel');
			if(detailStore.isDirty() || fp.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('PRODT_START_DATE_FR',UniDate.get('startOfMonth'));
			masterForm.setValue('PRODT_START_DATE_TO',UniDate.get('today'));
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('PRODT_START_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('PRODT_START_DATE_TO',UniDate.get('today'));
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
			Ext.getCmp('btnPrint').setDisabled(true);//출력버튼 활성화
			Ext.getCmp('btnPrint2').setDisabled(true);//출력버튼 활성화

			//초기화 시 전표일로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = masterForm;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		}
	});



	function fnGrid3Save(selectDetailRecord) {
		var updateData		= masterGrid3.getStore().getUpdatedRecords();	//공정별 등록 그리드의 수정된 데이터
		var deleteData		= masterGrid4.getStore().getRemovedRecords();	//실적현황 그리드의 삭제된 데이터
		if(updateData && updateData.length > 0) {
			if(selectDetailRecord.get('RESULT_YN') == '2'){
				var cnt = 0;
				Ext.each(updateData, function(updateRecord,i) {
					if(updateRecord.get('LINE_END_YN') == 'Y'){
						cnt = cnt + 1;
					}
				});
				if(cnt > 0){
					openoutouProdtSave();
				}else{
					directMasterStore3.saveStore();

				}
			}else{
				directMasterStore3.saveStore();
			}
		}

		if(deleteData && deleteData.length > 0) {
			directMasterStore4.saveStore();
		}
	}



	/**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {

			}
			return rv;
		}
	}); // validator

	Unilite.createValidator('validator02', {
		store: directMasterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PRODT_Q" :	// 생산량
					if(newValue < '0') {
						rv= Msg.sMB076;
						break;
					}
					record.set('GOOD_PRODT_Q', newValue);
				break;

				case "GOOD_PRODT_Q" :	// 양품량
					var record1 = masterGrid2.getSelectedRecord();
					if(newValue > record1.get('PRODT_Q')) {
						alert('<t:message code="system.message.product.message011" default="양품량은 생산량 보다 많을 수 없습니다."/>');
						break;
					}
					record.set('BAD_PRODT_Q', record.get('PRODT_Q') - newValue);
				break;

				case "BAD_PRODT_Q" :	// 불량량
					var record1 = masterGrid2.getSelectedRecord();
					if(newValue > "PRODT_Q") {
						alert('<t:message code="system.message.product.message012" default="불량량은 생산량 보다 많을 수 없습니다."/>');
						break;
					}
					record.set('GOOD_PRODT_Q', record.get('PRODT_Q') - newValue);
				break;

				case "MAN_HOUR" :	// 투입공수
					if(newValue < '0') {
						rv= Msg.sMB076;
						break;
					}
				break;
			}
			return rv;
		}
	}); // validator

	Unilite.createValidator('validator03', {
		store: directMasterStore3,
		grid: masterGrid3,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ARRAY_CNT" :	//배열수
					if(newValue < '0') {
						rv= Msg.sMB076;
						break;
					}
					//작업장이 WC70 또는 WC90이상일 때만 적용 - 20180907: 권부장님 지시사항
//					if(panelResult.getValue('WORK_SHOP_CODE') == 'WC70' || panelResult.getValue('WORK_SHOP_CODE') >= 'WC90') {
//						var masterRecord= detailGrid.getSelectedRecord();
//						var progWkordQ	= masterRecord.get('WKORD_Q');					//작업지시량
//						var basicQ		= progWkordQ / gsBasicArrayCnt;					//최초 단위생산량
//						var newPassQ	= Unilite.multiply(basicQ , newValue);
//
//						record.set('PASS_Q'		, newPassQ);
//						record.set('GOOD_WORK_Q', newPassQ - record.get('BAD_WORK_Q'));
//						record.set('WORK_Q'		, newPassQ);
//					}
				break;

				case "PASS_Q" :	// 생산량
					if(newValue < '0') {
						rv= Msg.sMB076;
						break;
					}
					record.set('GOOD_WORK_Q', newValue);
					record.set('WORK_Q'		, newValue);
//					if(panelResult.getValue('WORK_SHOP_CODE') == 'WC70') {
//						record.set('ARRAY_CNT', newValue);
//					}
				break;

				case "GOOD_WORK_Q" :	// 양품량
					if(newValue > record.get('PASS_Q')) {
						rv = '<t:message code="system.message.product.message011" default="양품량은 생산량 보다 많을 수 없습니다."/>';
//						record.set('GOOD_WORK_Q', oldValue);
						break;
					}
					record.set('BAD_WORK_Q', record.get('PASS_Q') - newValue);
				break;

				case "BAD_WORK_Q" :	// 불량량
					if(newValue > record.get('PASS_Q')) {
						rv = '<t:message code="system.message.product.message012" default="불량량은 생산량 보다 많을 수 없습니다."/>';
//						record.set('BAD_WORK_Q', oldValue);
						break;
					}
					record.set('GOOD_WORK_Q', record.get('PASS_Q') - newValue);
				break;

				case "MAN_HOUR" :	// 투입공수
					if(newValue < '0') {
						rv= Msg.sMB076;
						break;
					}
				break;

				case "PRODT_TIME" :	// 작업시간
					if(isNaN(newValue)){
						rv = Msg.sMB074;	//숫자만 입력가능합니다.
						break;
					}
				break;
			}
			return rv;
		}
	});

	Unilite.createValidator('validator05', {
		store: directMasterStore5,
		grid: masterGrid5,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "BAD_Q" :	// 수량
					if(newValue < '0') {
						rv= Msg.sMB076;
						break;
					}
				break;
			}
			return rv;
		}
	});

	Unilite.createValidator('validator06', {
		store: directMasterStore6,
		grid: masterGrid6,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "TROUBLE_TIME" :	// 발생시간
					if(newValue < '0') {
						rv= Msg.sMB076;
						break;
					}
				break;
			}
			return rv;
		}
	});
}
</script>