<%--
'   프로그램명 : 패킹출고
'
'   작  성  자 : (주)시너지시스템즈 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="srq600ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>						<!-- 수불담당 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">

var referRequestWindow;

function appMain() {
	
	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'srq600ukrvService.selectList1',
			update	: 'srq600ukrvService.update',
			syncAll : 'srq600ukrvService.saveAll'
		}
	});
	
	/**
	 * master grid Model
	 */
	Unilite.defineModel('srq600ukrvModel1', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.sales.companycode" default="법인코드"/>'				, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string'},
			{name: 'ISSUE_REQ_NUM'		, text: '<t:message code="system.label.inventory.issuerequestno" default="출고요청번호"/>'	, type: 'string'},
			{name: 'ISSUE_REQ_SEQ'		, text: '<t:message code="system.label.inventory.issuerequestseq" default="출고요청순번"/>'	, type: 'string'},
			{name: 'PACK_NO'			, text: '<t:message code="" default="출하지시 패킹번호"/>'										, type: 'string'},
			{name: 'ISSUE_PACK_NO'		, text: '<t:message code="" default="출고패킹번호"/>'											, type: 'string'},
			{name: 'ISSUE_DATE'			, text: '<t:message code="" default="패킹일자"/>'											, type: 'uniDate'},
			{name: 'ISSUE_PRSN'			, text: '<t:message code="" default="담당자"/>'											, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.customcode" default="거래처코드"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				, type: 'string'}
		]
	});
	
	/**
	 * master grid store
	 */
	var directMasterStore = Unilite.createStore('srq600ukrvMasterStore', {
		model : 'srq600ukrvModel1',
		uniOpt: {
			isMaster  : true,			// 상위 버튼 연결
			editable  : true,			// 수정 모드 사용
			deletable : false,			// 삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
		autoLoad : false,
		proxy: directMasterProxy,
		loadStoreRecords: function(){
			var param = panelResult.getValues();
			console.log(param);
			
			this.load({
				params : param,
				callback : function(batch, option) {
					setTimeout(function(){
						panelResult.getField('BARCODE').focus();
					}, 100);
				}
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			if(Ext.isEmpty(panelResult.getValue('ISSUE_PRSN'))) {
				Unilite.messageBox(UniUtils.getMessage('system.label.sales.issuecharger', '출고담당') + UniUtils.getMessage('system.message.commonJS..invalidText','은(는) 필수입력 항목입니다.'));
				return;
			}
			
			var param = panelResult.getValues();
			if(inValidRecs.length == 0) {
				config = {
					params: [param],
					success: function(batch, option) {
						directMasterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records.length > 0) {
					var refRecord;
					Ext.each(records, function(record){
						if(!Ext.isEmpty(record.get('ISSUE_PACK_NO'))) {
							refRecord = record;
							return;
						}
					});
					
					if(!Ext.isEmpty(refRecord)) {
						panelResult.setValue('CUSTOM_CODE'	, refRecord.get('CUSTOM_CODE'));
						panelResult.setValue('CUSTOM_NAME'	, refRecord.get('CUSTOM_NAME'));
						panelResult.setValue('ISSUE_DATE'	, refRecord.get('ISSUE_DATE'));
						panelResult.setValue('ISSUE_PRSN'	, refRecord.get('ISSUE_PRSN'));
						panelResult.getField('ISSUE_DATE').setReadOnly(true);
						panelResult.getField('ISSUE_PRSN').setReadOnly(true);
					}
					else {
						refRecord = records[0];
						panelResult.setValue('CUSTOM_CODE'	, refRecord.get('CUSTOM_CODE'));
						panelResult.setValue('CUSTOM_NAME'	, refRecord.get('CUSTOM_NAME'));
						panelResult.getField('ISSUE_DATE').setReadOnly(false);
						panelResult.getField('ISSUE_PRSN').setReadOnly(false);
					}
				}
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
//				this.commitChanges();
//				return true;
			}
		}
	});
	
	/**
	 * panelResult
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			holdable	: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
			name		: 'ISSUE_DATE',
			xtype		: 'uniDatefield',
			allowBlank	: false,
			holdable	: 'hold',
			value		: UniDate.get('today'),
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>',
			name		: 'ISSUE_REQ_NUM',
			xtype		: 'uniTextfield',
			readOnly	: true,
			//holdable	: 'hold',
			
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('CUST', {
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			textFieldWidth	: 170,
			allowBlank		: true,
			autoPopup		: false,
			validateBlank	: false,
			readOnly		: true,
			colspan			: 2,
			holdable		: 'hold',
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.issuecharger" default="출고담당"/>',
			name		: 'ISSUE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024',
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="" default="바코드"/>',
			name		: 'BARCODE',
			xtype		: 'uniTextfield',
			colspan		: 3,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					UniAppManager.app.fnCheckBarcode(newValue);
				}
			}
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
	});
	
	/**
	 * master Grid
	 */
	var masterGrid = Unilite.createGrid('masterGrid', {
		layout: 'fit',
		region: 'center',
		flex  : 1,
		uniOpt: {
			useLiveSearch		: true,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false,
			onLoadSelectFirst	: true,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowContext		: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		store: directMasterStore,
		selModel: 'rowmodel',
		tbar: [{
			itemId	: 'requestBtn',
			text	: '<div style="color: blue"><t:message code="system.label.sales.shipmentorderrefer" default="출하지시참조"/></div>',
			handler	: function() {
				if(panelResult.setAllFieldsReadOnly(true)) {
					openRequestWindow();
				}
			}
		}],
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'ISSUE_REQ_NUM'		, width: 100, hidden: true},
			{dataIndex: 'ISSUE_REQ_SEQ'		, width: 100, hidden: true},
			{dataIndex: 'PACK_NO'			, width: 300},
			{dataIndex: 'ISSUE_PACK_NO'		, width: 300},
			{dataIndex: 'ISSUE_DATE'		, width: 100, hidden: true},
			{dataIndex: 'ISSUE_PRSN'		, width: 100, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 100, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 100, hidden: true}
		],
		listeners: {
			beforeedit: function(editor, e, eOpts) {
				if(UniUtils.indexOf(e.field,['ISSUE_PACK_NO'])){
					return true;
				}
				
				return false;
			}
		},
		setPackNo:function(record) {
			if(Ext.isEmpty(record)) {
				beep();
				Unilite.messageBox('잘못된 바코드입니다.');
				return;
			}
			
			if(record['BARCODE_TYPE'] != '1') {
				beep();
				Unilite.messageBox('패킹번호가 아닙니다.');
				return;
			}
			
			var isDup = false;
			var mRow;
			
			Ext.each(directMasterStore.data.items, function(mRecord) {
				if(record['PACK_NO'] == mRecord.get('PACK_NO')){
					masterGrid.selectById(mRecord.id);
					mRow = masterGrid.getSelectedRecord();
					
					return;
				}
			});
			
			if(Ext.isEmpty(mRow)) {
				beep();
				Unilite.messageBox('출하지시되지 않은 패킹번호입니다.');
				return;
			}
			
			if(!Ext.isEmpty(mRow.get('ISSUE_PACK_NO'))) {
				beep();
				Unilite.messageBox('이미 출고 처리된 패킹번호입니다.');
				return;
			}
			
			mRow.set('ISSUE_PACK_NO', record['PACK_NO']);
		}
	});//End of var masterGrid = Unilite.createGrid('masterGrid', {
	
	/**
	 * Main
	 */
	Unilite.Main({
		borderItems:[{
			region : 'center',
			layout : 'border',
			border : false,
			items  : [
				masterGrid, panelResult
			]
		}],
		id : 'srq600ukrvApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('ISSUE_DATE'	, UniDate.get("today"));
			
			UniAppManager.setToolbarButtons(['deleteAll', 'save'], false);
			
			panelResult.setAllFieldsReadOnly(false);
			
			setTimeout(function() {
				panelResult.setValue('BARCODE', '');
				panelResult.getField('BARCODE').focus();
			}, 500);
		},
		onQueryButtonDown: function() {
			if(Ext.isEmpty(panelResult.getValue('ISSUE_REQ_NUM'))) {
				openRequestWindow();
			}
			
			if(panelResult.setAllFieldsReadOnly(true)) {
				directMasterStore.loadStoreRecords();
			}
		},
		onNewDataButtonDown: function()	{
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			
			masterGrid.reset();
			masterGrid.getStore().clearData();
			
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(directMasterStore.isDirty()) {
				directMasterStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
		},
		fnCheckBarcode: function(rawValue) {
			if(Ext.isEmpty(rawValue)) {
				return;
			}
			
			var values = rawValue.split('^');
			var value;
			
			if(values.length == 1) {
				value = values[0];
			}
			else if(values.length == 2 && values[0] == 'PK') {
				value = values[1];
			}
			
			var param = {
				COMP_CODE	: UserInfo.compCode,
				DIV_CODE	: panelResult.getValue('DIV_CODE'),
				BARCODE		: value
			};
			
			srq600ukrvService.checkBarcode(param, function(provider, response) {
				if(!Ext.isEmpty(provider)) {
					var rv = provider[0];
					masterGrid.setPackNo(rv);
					
					panelResult.setValue('BARCODE', '');
					panelResult.getField('BARCODE').focus();
				}
				else {
					beep();
					
					panelResult.setValue('BARCODE', '');
					panelResult.getField('BARCODE').focus();
				}
			});
		}
	});//End of Unilite.Main( {
	
	/**
	 * master grid validator
	 */
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			if(newValue == oldValue) {
				return true;
			}
			
			switch(fieldName) {
			}
			return rv;
		}
	});
	
	function setAllFieldsReadOnly(b){
		var r = true;
		if(b) {
			var invalid = this.getForm().getFields().filterBy(function(field) {
				return !field.validate();
			});
			
			if(invalid.length > 0) {
				r = false;
				var labelText = '';
				
				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					labelText = invalid.items[0]['fieldLabel']+':';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					labelText = invalid.items[0].ownerCt['fieldLabel']+':';
				}
				alert(labelText+Msg.sMB083);
				invalid.items[0].focus();
				
				return r;
			}
		}
		
		//this.unmask();
		var fields = this.getForm().getFields();
		Ext.each(fields.items, function(item) {
			if(Ext.isDefined(item.holdable) ) {
				if (item.holdable == 'hold') {
					item.setReadOnly(b);
				}
			} 
			if(item.isPopupField)	{
				var popupFC = item.up('uniPopupField');
				if(popupFC.holdable == 'hold') {
					item.setReadOnly(b);
				}
			}
		});
		
		return r;
	}
	
	function beep() {
		audioCtx = new(window.AudioContext || window.webkitAudioContext)();
		
		var oscillator = audioCtx.createOscillator();
		var gainNode = audioCtx.createGain();
		
		oscillator.connect(gainNode);
		gainNode.connect(audioCtx.destination);
		
		gainNode.gain.value = 1.0;			//VOLUME 크기
		oscillator.frequency.value = 4100;
		oscillator.type = 'square';			//sine, square, sawtooth, triangle
		
		oscillator.start();
		
		setTimeout(
			function() {
				oscillator.stop();
			}
		, 500);
	};
	
	/**
	 * 출하지시내역을 참조하기 위한 Search Form, Grid, Window 정의
	 */
	var requestSearch = Unilite.createSearchForm('requestForm', {
		layout :  {type : 'uniTable', columns : 3},
		items :[{
			xtype: 'uniCombobox',
			name:'DIV_CODE',
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			child: 'WH_CODE',
			comboType:'BOR120',
			allowBlank: false,
			readOnly: true
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>' , 
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						requestSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						requestSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': requestSearch.getValue('DIV_CODE')});
				}
			}
		}), {
			fieldLabel: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ISSUE_DATE_FR',
			endFieldName: 'ISSUE_DATE_TO',	
			width: 350,
			endDate: UniDate.get('tomorrow')
		}, {
			fieldLabel: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>',
			xtype: 'uniTextfield',
			name:'ISSUE_REQ_NUM'
		}, {
			fieldLabel: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			xtype: 'uniTextfield',
			name:'PROJECT_NO',
			hidden: true
		}, {
			fieldLabel: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
			name: 'WH_CODE',
			xtype:'uniCombobox',
			comboType:'OU',
			comboCode:'',
			hidden: true
		}, {
			xtype: 'hiddenfield',
			name:'MONEY_UNIT'
		}, 
		Unilite.popup('CUST', {
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			//textFieldWidth	: 170,
			allowBlank		: true,
			autoPopup		: false,
			validateBlank	: false,
			//hidden			: true,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
					//panelResult.setValue('CUSTOM_CODE', newValue);
					if(!Ext.isObject(oldValue)) {
						requestSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){		// 2021.08 표준화 작업
					//panelResult.setValue('CUSTOM_NAME', newValue);
					if(!Ext.isObject(oldValue)) {
						requestSearch.setValue('CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){								// 2021.08 표준화 작업
				}
			}
		}), {
			xtype: 'hiddenfield',
			name:'CREATE_LOC'
		}]
	});
	
	//출하지시 참조 모델 정의
	Unilite.defineModel('srq600ukrvRequestModel', {
		fields: [
			{name: 'COMP_CODE'				,text: '<t:message code="system.label.sales.companycode" default="법인코드"/>'																		, type: 'string'},
			{name: 'DIV_CODE'				,text: '<t:message code="system.label.sales.division" default="사업장"/>'																		, type: 'string'},
			{name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.sales.customcode" default="거래처코드"/>'																	, type: 'string'},
			{name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'},
			{name: 'ISSUE_REQ_NUM'			,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'		, type: 'string'},
			{name: 'ITEM_NAME'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'ISSUE_REQ_DATE'			,text: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'		, type: 'uniDate'}
		]
	});
	
	//출하지시 참조 스토어 정의
	var requestStore = Unilite.createStore('srq600ukrvRequestStore', {
		model: 'srq600ukrvRequestModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false				// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 'srq600ukrvService.selectRequestList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
			}
		},
		loadStoreRecords : function()	{
			var param = requestSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	//출하지시 참조 그리드 정의
	var requestGrid = Unilite.createGrid('srq600ukrvRequestGrid', {
		layout	: 'fit',
		store	: requestStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false, mode: 'SINGLE',
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
				}
			}
		}),
		uniOpt	:{
			onLoadSelectFirst	: false,
			useRowNumberer		: false
		},
		columns:  [
			{ dataIndex: 'COMP_CODE'			, width: 120, hidden: true },
			{ dataIndex: 'DIV_CODE'				, width: 120, hidden: true },
			{ dataIndex: 'CUSTOM_CODE'			, width: 120, hidden: true },
			{ dataIndex: 'CUSTOM_NAME'			, width: 120 },
			{ dataIndex: 'ISSUE_REQ_NUM'		, width: 100 },
			{ dataIndex: 'ITEM_NAME'			, minWidth: 200, flex: 1 },
			{ dataIndex: 'ISSUE_REQ_DATE'		, width: 100 }
		],
		listeners: {	
			onGridDblClick:function(grid, record, cellIndex, colName) {
				this.returnData();
				referRequestWindow.hide();
			}
		},
		returnData: function()	{
//			var records = this.getSelectedRecords();
//			Ext.each(records, function(record,i){
//				if(i == 0) {
//					if(Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
//						panelResult.setValue('CUSTOM_CODE', record.get('CUSTOM_CODE'));
//						panelResult.setValue('CUSTOM_NAME', record.get('CUSTOM_NAME'));
//					}
//				}
//				
//				UniAppManager.app.onNewDataButtonDown();
//				detailGrid.setRequestData(record.data);
//			});
//			this.deleteSelectedRow();
			
			var record = this.getSelectedRecord();
			
			panelResult.setValue('ISSUE_REQ_NUM', record.get('ISSUE_REQ_NUM'));
			//panelResult.getField('BARCODE').focus();
			UniAppManager.app.onQueryButtonDown();
		}
	});
	
	function openRequestWindow() {
		if(!panelResult.getInvalidMessage()) return false;
		
		if(!referRequestWindow) {
			referRequestWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.sales.shipmentorderrefer" default="출하지시참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [requestSearch, requestGrid],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
						handler: function() {
							requestStore.loadStoreRecords();
						},
						disabled: false
					}, 
					{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.sales.issueapply" default="출고적용"/>',
						handler: function() {
							requestGrid.returnData();
						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.sales.issueapplyclose" default="출고적용후 닫기"/>',
						handler: function() {
							requestGrid.returnData();
							referRequestWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.sales.close" default="닫기"/>',
						handler: function() {
							if(directMasterStore.getCount() == 0){
								panelResult.setAllFieldsReadOnly(false);
							}
							referRequestWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						requestSearch.clearForm();
						requestGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						requestSearch.clearForm();
						requestGrid.reset();
					},
					beforeshow: function ( me, eOpts )	{
						requestSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						requestSearch.setValue('CUSTOM_CODE'	, panelResult.getValue('CUSTOM_CODE'));
						requestSearch.setValue('CUSTOM_NAME'	, panelResult.getValue('CUSTOM_NAME'));
						requestSearch.setValue('ISSUE_DATE_TO'	, panelResult.getValue('ISSUE_DATE'));
						requestSearch.setValue('ISSUE_DATE_FR'	, UniDate.get('startOfMonth', panelResult.getValue('INOUT_DATE')));
						requestStore.loadStoreRecords();
					}
				}
			})
		}
		referRequestWindow.center();
		referRequestWindow.show();
	}

}
</script>