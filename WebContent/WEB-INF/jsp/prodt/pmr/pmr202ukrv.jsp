<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr202ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />	<!-- 창고 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />	<!-- 작업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />				<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B035"/>				<!-- 수불타입 -->
	<t:ExtComboStore comboType="OU" />										<!-- 창고-->
	<t:ExtComboStore comboType="WU" />		<!-- 작업장-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고Cell-->
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
	var workProgressWindow;		//20200330 추가: 진척이력 윈도우

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'pmr202ukrvService.selectDetailList',
			update	: 'pmr202ukrvService.updateDetail',
			create	: 'pmr202ukrvService.insertDetail',
			destroy	: 'pmr202ukrvService.deleteDetail',
			syncAll	: 'pmr202ukrvService.saveAll'
		}
	});



	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			child:'WH_CODE',
			holdable	: 'hold',
			value		: outDivCode,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_SHOP_CODE','');
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
						pmr202ukrvService.getWhCode(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								panelResult.setValue('WH_CODE', provider[0].WH_CODE);
							} else {
								panelResult.setValue('WH_CODE', '');
							}
						});

					}
				},
				beforequery:function( queryPlan, eOpts )   {
					var store = queryPlan.combo.store;
					var prStore = panelResult.getField('WORK_SHOP_CODE').store;
					store.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});

					}else{
						store.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
			xtype		: 'uniDatefield',
			name		: 'INOUT_DATE',
			value		: UniDate.get('today'),
			//20200330 수정: 주석
//			holdable	: 'hold',
			colspan  : 2,
	 		allowBlank	: false
		},{
			xtype	: 'component',
			width	: 80
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.product.wholeissue" default="일괄출고"/>',
			id		: 'btnWholeIssue',
			width	: 80,
			hidden:true,
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
			child: 'WH_CELL_CODE',
			store:Ext.data.StoreManager.lookup('whList'),
			holdable	: 'hold',
	 		allowBlank	: false
		},{
			fieldLabel: '<t:message code="system.label.product.issuewarehousecell" default="출고창고Cell"/>',
			name:'WH_CELL_CODE',
			xtype: 'uniCombobox',
			holdable: 'hold',
			allowBlank	: false,
			store:Ext.data.StoreManager.lookup('whCellList'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				}
			}
		},
		Unilite.popup('WKORD_NUM', {
			fieldLabel: '작업지시번호',
			allowBlank:false,
			popupWidth:1000,
			listeners: {
			   applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE' : panelResult.getValue('DIV_CODE')});
				},
				'onValueFieldChange': function(field, newValue, oldValue  ){
					panelResult.setValue('REF_WKORD_NUM',newValue);
				},
				'onTextFieldChange':  function( field, newValue, oldValue  ){
					panelResult.setValue('REF_WKORD_NUM',newValue);
				}
			}
		}),{
	 		fieldLabel	: 'REF_WKORD_NUM',
	 		xtype		: 'uniTextfield',
	 		name		: 'REF_WKORD_NUM',
	 		hidden   : true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'component',
			width	: 80
		},{
			xtype: 'radiogroup',
			fieldLabel: '',
			items: [{
				boxLabel: '미등록',
				width: 60,
				name: 'REGISTER_YN',
				inputValue: 'N',
				checked: true
			},{
				boxLabel : '등록',
				width: 60,
				name: 'REGISTER_YN',
				inputValue: 'Y'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					detailGrid.reset();
					detailStore.clearData();
					detailStore.commitChanges();
					UniAppManager.setToolbarButtons(['save'], false);
					if(newValue.REGISTER_YN == 'Y') {
						detailGrid.getColumn('PRE_OUTSTOCK_Q').setHidden(true);
						detailGrid.getColumn('REMAIN_Q').setHidden(true);
						//20200401 주석: 미등록 상태에서도 투입공수 버튼 활성화
//						detailGrid.down('#HISTORY_WORK_PROGRESS').enable();
					} else {
						detailGrid.getColumn('PRE_OUTSTOCK_Q').setHidden(false);
						detailGrid.getColumn('REMAIN_Q').setHidden(false);
						//20200401 주석: 미등록 상태에서도 투입공수 버튼 활성화
//						detailGrid.down('#HISTORY_WORK_PROGRESS').disable();
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



	Unilite.defineModel('pmr202ukrvDetailModel', {
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.product.companycode" default="법인코드"/>'			,type:'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'				,type:'string'},
			{name: 'OUTSTOCK_NUM'		,text: '<t:message code="system.label.product.issuerequestno" default="출고요청번호"/>'		,type:'string'},
			{name: 'REF_WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			,type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.itemcode" default="품목코드"/>'				,type:'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'						,type:'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>'						,type:'string' , comboType:'AU', comboCode:'B013'},
			{name: 'PATH_CODE'			,text: '자재 BOM Path Code'	,type:'uniQty'},
			{name: 'INOUT_NUM'			,text: '<t:message code="system.label.product.tranno" default="수불번호"/>'					,type:'string'},
			{name: 'INOUT_SEQ'			,text: '<t:message code="system.label.product.transeq" default="수불순번"/>'				,type:'string'},
			{name: 'INOUT_DATE'			,text: '<t:message code="system.label.product.transdate" default="수불일"/>'				,type:'uniDate'},
			{name: 'INOUT_TYPE'			,text: '<t:message code="system.label.product.trantype1" default="수불타입"/>'				,type:'string'},
			{name: 'OUTSTOCK_REQ_Q'		,text: '<t:message code="system.label.product.issuerequestqty" default="출고요청량"/>'		,type:'uniQty'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'					,type:'string', allowBlank: false},
			{name: 'OUTSTOCK_Q'			,text: '<t:message code="system.label.product.issueqty" default="출고량"/>'				,type:'uniQty'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.product.issuewarehouse" default="출고창고"/>'			,type:'string' , comboType   : 'OU'},
			{name: 'WH_CELL_CODE'		,text: '<t:message code="system.label.product.issuewarehousecell" default="출고창고cell"/>'	,type: 'string', store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','DIV_CODE']},
			{name: 'REMAIN_Q'			,text: '<t:message code="system.label.product.balanceqty" default="잔량"/>'				,type:'uniQty'},
			{name: 'REMARK'				,text: '<t:message code="system.label.product.remarks" default="비고"/>'					,type:'string'},
			{name: 'PROJECT_NO'			,text: 'Project No.'		,type:'string'},
			{name: 'PJT_CODE'			,text: '<t:message code="system.label.product.projectcode" default="프로젝트코드"/>'			,type:'string'},
			{name: 'PRODT_INOUT_NUM'	,text: 'PRODT_INOUT_NUM'	,type:'string'},
			{name: 'PRODT_INOUT_SEQ'	,text: 'PRODT_INOUT_SEQ'	,type:'string'},
			{name: 'PRE_OUTSTOCK_Q'		,text: '<t:message code="system.label.product.existingoutqty" default="기존출고량"/>'		,type:'uniQty'},
			{name: 'PRE_OUTSTOCK_Q_BAK'	,text: 'PRE_OUTSTOCK_Q_BAK'	,type:'uniQty'},
			{name: 'QUERY_YN'			,text: 'QUERY_YN'			,type:'string'},
			{name: 'QUERY_FLAG'			,text: 'QUERY_FLAG'			,type:'string'},
			{name: 'SAVE_FLAG'			,text: 'SAVE_FLAG'			,type:'string'},
			{name: 'SAVED_YN'			,text: 'SAVED_YN'			,type:'string'},
			{name: 'STOCK_Q'			,text: '<t:message code="system.label.product.onhandstock" default="현재고"/>'				,type:'uniQty'}
		]
	});

	var detailStore = Unilite.createStore('pmr202ukrvDetailStore', {
		model	: 'pmr202ukrvDetailModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
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

			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var isErr = false;
			Ext.each(list, function(record, index) {
				if(record.get('OUTSTOCK_Q') == 0 || Ext.isEmpty(record.get('OUTSTOCK_Q'))){
					alert(record.get('ITEM_NAME') + "의 재고가없어서 출고할 수 없습니다.");
					isErr = true;
				}
			})

			if(isErr) {
				return false;
			}
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
				var grid = Ext.getCmp('pmr202ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)) {
					panelResult.setAllFieldsReadOnly(true);
					UniAppManager.setToolbarButtons(['newData'], false);
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
	var detailGrid = Unilite.createGrid('pmr202ukrvGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
			onLoadSelectFirst	: false,
			useRowNumberer		: false
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', {itemId: 'CheckModel', checkOnly : false, toggleOnClick: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if (selectRecord.get('SAVED_YN') !='Y' && this.selected.getCount() > 0) {
						selectRecord.set('SAVE_FLAG', 'Y');
					}
				},
				deselect: function(grid, selectRecord, index, eOpts ){
					var toDelete = detailStore.getRemovedRecords();
					var toUpdate = detailStore.getUpdatedRecords();
					selectRecord.set('SAVE_FLAG', 'N');
				}
			}
		}),
		tbar: [{
			itemId	: 'HISTORY_WORK_PROGRESS',
			text	: '투입공수',
			handler	: function() {
				//20200401 수정: 체크로직 변경
//				var detailRecord = detailGrid.getSelectedRecord();
//				if(!detailRecord) {
				if(Ext.isEmpty(panelResult.getValue('WKORD_NUM')) || detailStore.getCount() == 0) {
					Unilite.messageBox('선택된 작업지시 데이터가 없습니다.');
					return false;
				}
				openworkProgressWindow();
			}
		}],
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
			{dataIndex: 'LOT_NO'			, width: 120,
				editor : Unilite.popup('LOTNO_G', {
					textFieldName : 'LOTNO_CODE',
					DBtextFieldName : 'LOTNO_CODE',
					validateBlank : false,
					autoPopup : true,
					listeners : {
						'onSelected' : {
							fn : function(records,type) {
								var rtnRecord;
								Ext.each(records,function(record,i) {
									if (i == 0) {
										rtnRecord = detailGrid.uniOpt.currentRecord
									} else {
										rtnRecord = detailGrid.getSelectedRecord()
									}
									var outstockReqQ = rtnRecord.get('REMAIN_Q');
									if(outstockReqQ > record["STOCK_Q"]){
										rtnRecord.set('OUTSTOCK_Q', record["STOCK_Q"]);
									}else{
										rtnRecord.set('OUTSTOCK_Q', outstockReqQ);
									}
									rtnRecord.set('LOT_NO',record["LOT_NO"]);
									rtnRecord.set('STOCK_Q',record["STOCK_Q"]);
									rtnRecord.set('WH_CODE',record["WH_CODE"]);
								});
							},
							scope : this
						},
						'onClear' : function(type) {
							var rtnRecord = detailGrid.uniOpt.currentRecord;
							rtnRecord.set('LOT_NO','');
							rtnRecord.set('STOCK_Q',0);
						},
						applyextparam : function(popup) {
							var selectRec = detailGrid.getSelectedRecord();
							if (!Ext.isEmpty(selectRec)) {
								popup.setExtParam({
									'DIV_CODE'			: selectRec.get('DIV_CODE'),
									'ITEM_CODE'			: selectRec.get('ITEM_CODE'),
									'ITEM_NAME'			: selectRec.get('ITEM_NAME'),
									'S_WH_CODE'			: selectRec.get('WH_CODE'),
									'S_WH_CELL_CODE'	: selectRec.get('WH_CELL_CODE'),
									'LOT_NO'			: selectRec.get('LOT_NO'),
									'stockYN'			: 'Y',
									//20191122 조회조건 창고 변경 못하도록 변수 추가
									'S_WH_CODE_YN'		: 'Y'
								});
							}
						}
					}
				})
			},
			{dataIndex: 'PRE_OUTSTOCK_Q'	, width: 100		, summaryType: 'sum'},
//			{dataIndex: 'PRE_OUTSTOCK_Q_BAK', width: 100		, hidden: false},
			{dataIndex: 'OUTSTOCK_Q'		, width: 100		, summaryType: 'sum'},
			{dataIndex: 'WH_CODE'			, width: 100},
			{dataIndex: 'WH_CELL_CODE'		, width: 100,
				//20191121 수정
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filterBy(function(item){
						return item.get('option') == record.get('WH_CODE')
					})
				}
			},
			{dataIndex: 'REMAIN_Q'			, width: 100		, summaryType: 'sum'},
			{dataIndex: 'STOCK_Q'		, width: 100},
			{dataIndex: 'REMARK'			, flex:1},
			{dataIndex: 'PROJECT_NO'		, width: 100		, hidden: true},
			{dataIndex: 'PJT_CODE'			, width: 100		, hidden: true},
			{dataIndex: 'PRODT_INOUT_NUM'	, width: 100		, hidden: true},
			{dataIndex: 'PRODT_INOUT_SEQ'	, width: 100		, hidden: true},
			{dataIndex: 'QUERY_YN'			, width: 100		, hidden: true},
			{dataIndex: 'SAVE_FLAG'			, width: 100		, hidden: true},
			{dataIndex: 'SAVED_YN'			, width: 100		, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false || e.record.get('QUERY_YN') == 'Y') {
					//20191121 추가
					if(e.record.get('SAVED_YN') == 'Y') {
						return false;
					}
					if(UniUtils.indexOf(e.field, ['OUTSTOCK_Q']) /*&& e.record.get('REMAIN_Q') > 0*/) {
						return true;
					} else if (UniUtils.indexOf(e.field, ['REMAIN_Q']) && gsWholeIssueFlag) {
						return true;
					} else if (UniUtils.indexOf(e.field, ['LOT_NO'])) {
						return true;
					}
					return false;

				} else {
//					if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'LOT_NO', 'REMARK', 'OUTSTOCK_Q'])) {
//						return true;
//					}
					return false;
				}
			},
			afterrender: function(grid) { 
				grid.getColumn('PRE_OUTSTOCK_Q').setHidden(false);
				grid.getColumn('REMAIN_Q').setHidden(false);
			}
		}
	});



	//20200330 추가: 진척이력 윈도우
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 'pmr202ukrvService.selectWorkProgressList',
			update	: 'pmr202ukrvService.updateWorkProgress',
			syncAll	: 'pmr202ukrvService.savetWorkProgress'
		}
	});
	Unilite.defineModel('workProgressModel', {
		fields: [
			{name: 'WORK_PROGRESS'	,text: '진척율'			,type:'uniPercent'	, allowBlank: true, editable: false},
			{name: 'SUM_PROGRESS'	,text: '진척율(누계)'		,type:'uniPercent'	, allowBlank: false, editable: true},
			{name: 'WORK_MONTH'		,text: '실적월'			,type:'string'		, editable: false},
			{name: 'MAN_HOUR'		,text: '투입공수'			,type:'uniQty'		, allowBlank: false}
		]
	});	
	var workProgressStore = Unilite.createStore('s_pmr100ukrv_mitWorkProgressStore',{
		model	: 'workProgressModel',
		proxy	: directProxy2,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var detailRecord		= detailGrid.getSelectedRecord();
			var param				= panelResult.getValues();
			param.DIV_CODE			= panelResult.getValue('DIV_CODE');
			param.WORK_SHOP_CODE	= panelResult.getValue('WORK_SHOP_CODE');
			param.WKORD_NUM			= panelResult.getValue('WKORD_NUM');

			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {
					}
				}
			});
		},
		saveStore: function() {
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var inValidRecs = this.getInvalidRecords();

			// 1. 마스터 정보 파라미터 구성
			var paramMaster				= panelResult.getValues();	// syncAll 수정
			var detailRecord			= detailGrid.getSelectedRecord();
			paramMaster.DIV_CODE		= panelResult.getValue('DIV_CODE');
			paramMaster.WORK_SHOP_CODE	= panelResult.getValue('WORK_SHOP_CODE');
			//20200402 수정: 작업지시번호 PANEL에서 가져오도록 변경
			paramMaster.WKORD_NUM		= panelResult.getValue('WKORD_NUM');

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						workProgressStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmr100ukrv_mitWorkProgressGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	var workProgressGrid = Unilite.createGrid('s_pmr100ukrv_mitWorkProgressGrid', {
		store	: workProgressStore,
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: true
		},
		columns : [
			{ dataIndex: 'WORK_MONTH'		, width: 150 , align: 'center' },
			{ dataIndex: 'MAN_HOUR'			, width: 200},
			{ dataIndex: 'WORK_PROGRESS'	, flex: 1},
			{ dataIndex: 'SUM_PROGRESS'		, flex: 1}
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function(record) {
		}
	});
	var workProgressPanel = Unilite.createSearchForm('workProgressPanel', {
		layout	: {type: 'uniTable', columns : 3},
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			readOnly	: true
		},{
			xtype: 'component',
			width: 30
		},{
			fieldLabel	: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			xtype		: 'uniTextfield',
			name		: 'WKORD_NUM',
			allowBlank	: false,
			readOnly	: true
		}]
	});
	function openworkProgressWindow() {
		if(!workProgressWindow) {
			workProgressWindow = Ext.create('widget.uniDetailWindow', {
				title	: '진척이력 조회',
				width	: 650,
				height	: 300,
				layout	: {type:'vbox', align:'stretch'},
				items	: [workProgressPanel, workProgressGrid],
				tbar	:['->',{
					itemId  : 'queryBtn',
					text	: '조회',
					handler : function() {
						if(!workProgressPanel.getInvalidMessage()) return;	//필수체크
						workProgressStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId  : 'saveBtn',
					text	: '저장',
					handler : function() {
						workProgressStore.saveStore();
					},
					disabled: false
				},{
					itemId  : 'closeBtn',
					text	: '<t:message code="system.label.sales.confirm" default="확인"/>',
					handler : function() {
						workProgressWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						workProgressGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						workProgressGrid.reset();
					},
					show: function( panel, eOpts ) {
						workProgressPanel.setValue('DIV_CODE'	, panelResult.getValue('DIV_CODE'));
						workProgressPanel.setValue('WKORD_NUM'	, panelResult.getValue('WKORD_NUM'));

						if(!workProgressPanel.getInvalidMessage()) return;	//필수체크
						workProgressStore.loadStoreRecords();
					}
				}
			})
		}
		workProgressWindow.center();
		workProgressWindow.show();
	};



	Unilite.Main( {
		id			: 'pmr202ukrvApp',
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
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;

			detailStore.loadStoreRecords();
			panelResult.setAllFieldsReadOnly(true);
			gsWholeIssueFlag = false;
		},
		onNewDataButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
			records = detailStore.data.items;
			//20191122 추가
			if(records.length == 0) return false;
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
			//20200330 수정: panel 개별 추기화로 변경
			if(Ext.isEmpty(panelResult.getValue('DIV_CODE'))) {
				panelResult.setValue('DIV_CODE', outDivCode);
			}
			panelResult.setValue('INOUT_DATE'	, UniDate.get('today'));
			panelResult.setValue('WKORD_NUM'	, '');
			panelResult.getField('REGISTER_YN').setValue('N');

			//20200401 주석: 미등록 상태에서도 투입공수 버튼 활성화
//			detailGrid.down('#HISTORY_WORK_PROGRESS').disable();

//			panelResult.clearForm();
			
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailStore.clearData();
			//20200330 수정: 위로직 변경에 따라 초기화도 개별로 진행
//			this.fnInitBinding();
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			gsWholeIssueFlag = false;
			
			detailGrid.getColumn('PRE_OUTSTOCK_Q').setHidden(false);
			detailGrid.getColumn('REMAIN_Q').setHidden(false);
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow && selRow.get('SAVED_YN') =='Y') {
				if(selRow.phantom === true)	{
					detailGrid.deleteSelectedRow();
				}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					detailGrid.deleteSelectedRow();
					var deSelect = detailGrid.getSelectedRecords();
					detailGrid.getSelectionModel().deselect(deSelect);
				}
			}
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'		, outDivCode);
			panelResult.setValue('INOUT_DATE'	, UniDate.get('today'));
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			//20200401 주석: 미등록 상태에서도 투입공수 버튼 활성화
//			detailGrid.down('#HISTORY_WORK_PROGRESS').disable();
			UniAppManager.setToolbarButtons('save', false);
			//detailGrid.getColumn('PRE_OUTSTOCK_Q').setHidden(false);
			//detailGrid.getColumn('REMAIN_Q').setHidden(false);
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
			param["PGM_ID"]='pmr202ukrv';
			var win = Ext.create('widget.CrystalReport', {
				url: CPATH+'/prodt/pmr200crkrv2.do',
				prgID: 'pmr200rkrv',
				extParam: param
			});
			win.center();
			win.show();
		}
	});



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
					/*
					//출고요청량보다 더 출고하는 경우 있으므로 제약조건 해제
					if(remainQ < '0') {
						rv= '<t:message code="system.message.product.message005" default="입력한 출고량이 참조한 출하지시건의 출고가능수량(출하지시량-출고량)보다 클 수 없습니다."/>'
						break;
					}
					*/
					
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