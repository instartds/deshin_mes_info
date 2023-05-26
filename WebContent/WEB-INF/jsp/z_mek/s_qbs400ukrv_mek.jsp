<%--
'   프로그램명 : 수리등록
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
<t:appConfig pgmId="s_qbs400ukrv_mek"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="ZP04" />				<!-- 수리진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="P509" />				<!-- 공정검사자 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

div .x-grid-widgetcolumn-cell-inner {padding: 0px;}
</style>

<script type="text/javascript">

var repPartWindow;

function appMain() {
	
	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_qbs400ukrv_mekService.selectList1',
			update	: 's_qbs400ukrv_mekService.update',
			destroy	: 's_qbs400ukrv_mekService.delete',
			syncAll	: 's_qbs400ukrv_mekService.saveAll'
		}
	});
	
	var directBadProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_qbs400ukrv_mekService.selectListBad',
			update  : 's_qbs400ukrv_mekService.updateBad',
			syncAll : 's_qbs400ukrv_mekService.saveAllBad'
		}
	});
	
	/**
	 * master grid Model
	 */
	Unilite.defineModel('s_qbs400ukrv_mekModel1', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'	, allowBlank:false},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'	, allowBlank:false},
			{name: 'REPAIR_NUM'			, text: '<t:message code="" default="REPAIR_NUM"/>'									, type: 'string'	, allowBlank:false},
			{name: 'INSPECT_NO'			, text: '<t:message code="" default="Inspection No"/>'									, type: 'string'	, allowBlank:false},
			{name: 'INSPECT_TYPE'		, text: '<t:message code="" default="INSPECT_TYPE"/>'								, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'MODEL'				, text: '<t:message code="" default="모델코드"/>'										, type: 'string'},
			{name: 'MODEL_NAME'			, text: '<t:message code="" default="모델"/>'											, type: 'string'},
			{name: 'REV_NO'				, text: '<t:message code="" default="REV_NO"/>'										, type: 'string'},
			{name: 'REQ_DATE'			, text: '<t:message code="" default="REQ_DATE"/>'									, type: 'uniDate'},
			{name: 'WORK_DATE'			, text: '<t:message code="" default="WORK_DATE"/>'									, type: 'uniDate'	, allowBlank:false},
			{name: 'WORK_USER'			, text: '<t:message code="" default="WORK_USER"/>'									, type: 'string'	, allowBlank:false},
			{name: 'REPAIR_DESC'		, text: '<t:message code="" default="REPAIR_DESC"/>'								, type: 'string'},
			{name: 'STATUS'				, text: '<t:message code="system.label.purchase.status" default="진행상테"/>'			, type: 'string'	, comboType: 'AU'	, comboCode: 'ZP04'	, allowBlank:false},
			{name: 'WKORD_NUM'			, text: '<t:message code="" default="작업지시번호"/>'										, type: 'string'}
		]
	});
	
	/**
	 * Machine grid Model
	 */
	Unilite.defineModel('s_qbs400ukrv_mekBadModel1', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'	, allowBlank:false},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'	, allowBlank:false},
			{name: 'BAD_CODE'			, text: '<t:message code="" default="불량코드"/>'										, type: 'string'	, allowBlank:false},
			{name: 'BAD_NAME'			, text: '<t:message code="" default="불량명"/>'										, type: 'string'	, allowBlank:false},
			{name: 'REPAIR_NUM'			, text: '<t:message code="" default="수리번호"/>'										, type: 'string'},
			{name: 'BAD_Q'				, text: '<t:message code="" default="불량"/>'											, type: 'int'},
			{name: 'REASON'				, text: '<t:message code="" default="증상"/>'											, type: 'string'},
			{name: 'INSPECT_VALUE'		, text: '<t:message code="" default="세부수치"/>'										, type: 'string'},
			{name: 'OPR_FLAG'			, text: '<t:message code="" default="OPR_FLAG"/>'									, type: 'string'}
		]
	});
	
	/**
	 * master grid store
	 */
	var directMasterStore1 = Unilite.createStore('s_qbs400ukrv_mekMasterStore1', {
		model : 's_qbs400ukrv_mekModel1',
		uniOpt: {
			isMaster  : true,			// 상위 버튼 연결
			editable  : false,			// 수정 모드 사용
			deletable : false,			// 삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
		autoLoad : false,
		proxy: directMasterProxy,
		loadStoreRecords: function(){
			var param = panelSearch.getValues();
			console.log(param);
			
			masterForm.clearForm();
			masterForm.setValue('WORK_DATE', UniDate.get("today"));
			
			badGrid.reset();
			badGrid.getStore().clearData();
			
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			var param = panelSearch.getValues();
			if(inValidRecs.length == 0) {
				config = {
					params: [param],
					success: function(batch, option) {
						directMasterStore1.loadStoreRecords();
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
					UniAppManager.setToolbarButtons(['deleteAll'], true);
				}
				else {
					UniAppManager.setToolbarButtons(['deleteAll'], false);
				}
			}
		}
	});
	
	/**
	 * Machine grid store
	 */
	var directBadStore = Unilite.createStore('s_qbs400ukrv_mekBadStore1', {
		model : 's_qbs400ukrv_mekBadModel1',
		uniOpt: {
			isMaster  : false,			// 상위 버튼 연결
			editable  : true,			// 수정 모드 사용
			deletable : false,			// 삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directBadProxy,
		loadStoreRecords: function(mRow){
			if(Ext.isEmpty(mRow)) {
				return;
			}
			
			var param = {
				DIV_CODE	: mRow.get('DIV_CODE'),
				INSPECT_NO	: mRow.get('INSPECT_NO'),
				REPAIR_NUM	: mRow.get('REPAIR_NUM')
			};
			console.log(param);
			
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var mRow = masterGrid.getSelectedRecord();
			Ext.each(this.data.items, function(record){
				if(Ext.isEmpty(record.get('REPAIR_NUM')) && record.get('BAD_Q') > 0) {
					record.set('DIV_CODE'	, mRow.get('DIV_CODE'));
					record.set('REPAIR_NUM'	, mRow.get('REPAIR_NUM'));
					record.set('OPR_FLAG'	, 'N');
				}
			});
			
			var toUpdate = this.getUpdatedRecords();
			if(Ext.isEmpty(toUpdate)) {
				return;
			}
			
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			var param = panelSearch.getValues();
			if(inValidRecs.length == 0) {
				config = {
					params: [param],
					success: function(batch, option) {
						directBadStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				badGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				if(store.isDirty()) {
					UniAppManager.setToolbarButtons(['save'], true);
				}
				else {
					if(!directMasterStore1.isDirty()) {
						UniAppManager.setToolbarButtons(['save'], false);
					}
				}
				
				return true;
			}
		}
	});
	
	/**
	 * searchPanel
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		defaultType	: 'uniSearchSubPanel',
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title  : '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId : 'search_panel1',
			layout : {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				//holdable	: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="" default="Inspection No"/>',
				name		: 'INSPECT_NO',
				xtype		: 'uniTextfield',
		 		listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPECT_NO', newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="" default="수리요청일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'REQ_DATE_FR',
				endFieldName	: 'REQ_DATE_TO',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('REQ_DATE_FR', newValue);
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('REQ_DATE_TO', newValue);
				}
			},{
				xtype		: 'uniRadiogroup',
				fieldLabel	: '진행상태',
				name		: 'STATUS',
				comboType	: 'AU',
				comboCode	: 'ZP04',
				width		: 350,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('STATUS', newValue.STATUS);
					}
				}
			}]
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
	});
	
	/**
	 * panelResult
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			//holdable	: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="" default="수리요청일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'REQ_DATE_FR',
			endFieldName	: 'REQ_DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('REQ_DATE_FR', newValue);
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('REQ_DATE_TO', newValue);
			}
		},{
			fieldLabel	: '<t:message code="" default="Inspection No"/>',
			name		: 'INSPECT_NO',
			xtype		: 'uniTextfield',
	 		listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INSPECT_NO', newValue);
				}
			}
		},{
			xtype		: 'uniRadiogroup',
			fieldLabel	: '진행상태',
			name		: 'STATUS',
			comboType	: 'AU',
			comboCode	: 'ZP04',
			width		: 440,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('STATUS', newValue.STATUS);
				}
			}
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
	});
	
	/**
	 * masterGrid
	 */
	var masterGrid = Unilite.createGrid('masterGrid', {
		layout: 'fit',
		region: 'west',
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
		store: directMasterStore1,
		sortableColumns : false,
		selModel: 'rowmodel',
		columns: [
			{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'REPAIR_NUM'	, width: 100, hidden: true},
			{dataIndex: 'INSPECT_NO'	, width: 100},
			{dataIndex: 'INSPECT_TYPE'	, width: 100, hidden: true},
			{dataIndex: 'ITEM_CODE'		, width: 100},
			{dataIndex: 'ITEM_NAME'		, minWidth: 150, flex: 1},
			{dataIndex: 'MODEL'			, width: 100, hidden: true},
			{dataIndex: 'MODEL_NAME'	, width: 120},
			{dataIndex: 'REV_NO'		, width: 100, hidden: true},
			{dataIndex: 'REQ_DATE'		, width: 100, hidden: true},
			{dataIndex: 'WORK_DATE'		, width: 100, hidden: true},
			{dataIndex: 'WORK_USER'		, width: 100, hidden: true},
			{dataIndex: 'REPAIR_DESC'	, width: 100, hidden: true},
			{dataIndex: 'STATUS'		, width: 100},
			{dataIndex: 'WKORD_NUM'		, width: 100, hidden: true}
		],
		listeners: {
			selectionchangerecord: function(record) {
				masterForm.setActiveRecord(record);
				directBadStore.loadStoreRecords(record);
			}
		}
	});//End of var masterGrid = Unilite.createGrid('masterGrid', {
	
	/**
	 * badGrid
	 */
	var badGrid = Unilite.createGrid('badGrid', {
		layout	: 'fit',
		region	: 'south',
		//flex	: 3,
		uniOpt: {
			useLiveSearch		: true,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false,
			onLoadSelectFirst	: false,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowContext		: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		store: directBadStore,
		sortableColumns : false,
		columns: [
			{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'BAD_CODE'		, width:  80},
			{dataIndex: 'BAD_NAME'		, width: 150},
			{dataIndex: 'REPAIR_NUM'	, width: 100, hidden: true},
			{dataIndex: 'BAD_Q'			, width: 100},
			{dataIndex: 'REASON'		, minWidth: 200, flex: 1},
			{dataIndex: 'INSPECT_VALUE'	, width: 150}
		],
		listeners: {
			beforeedit: function(editor, e, eOpts) {
				if(UniUtils.indexOf(e.field, ['BAD_Q', 'REASON', 'INSPECT_VALUE'])) {
					return true;
				}
				
				return false;
			}
		}
	});//End of var masterGrid = Unilite.createGrid('masterGrid', {
	
	var masterForm = Unilite.createSearchForm('inspectSearchForm',{
		region	: 'center',
		layout	: {type : 'uniTable', columns : 2, tableAttrs:{width:'100%'}},
		padding	: '1 1 1 1',
		border	: false,
		items: [{
			fieldLabel	: '<t:message code="" default="수리번호"/>',
			name		: 'REPAIR_NUM',
			xtype		: 'uniTextfield',
			readOnly	: true,
			width		: 250
		},{
			fieldLabel	: '<t:message code="" default="Inspection No"/>',
			name		: 'INSPECT_NO',
			xtype		: 'uniTextfield',
			readOnly	: true,
			width		: 250
		},{
			fieldLabel	: '<t:message code="" default="작업일"/>',
			name		: 'WORK_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			allowBlank	: false,
			width		: 250
		},{
			fieldLabel	: '<t:message code="" default="검사자"/>',
			name		: 'WORK_USER',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'P509',
			allowBlank	: false,
			width		: 250
		},{
			fieldLabel	: '<t:message code="" default="수리상태"/>',
			name		: 'STATUS',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZP04',
			allowBlank	: false,
			width		: 250
		},{
			xtype	: 'button',
			text	: '주요파트변경',
			width	: 155,
			tdAttrs	: {style: 'padding-left: 95px;'},
			handler	: function() {
				if(directMasterStore1.getCount() < 1) {
					return;
				}
				
				openRepPartWindow();
			}
		},{
			fieldLabel	: '<t:message code="" default="수리내역"/>',
			name		: 'REPAIR_DESC',
			xtype		: 'textareafield',
			colspan		: 2,
			width		: '99%',
			height		: 200
		}]
	});
	
	var inspectForm = Unilite.createSimpleForm('inspectForm', {
		region	: 'center',
		layout	: {type:'vbox', align:'stretch'},
		flex	: 2,
		border	: true,
		scrollable:true,
		items:[masterForm, badGrid]
	});
	
	/**
	 * Main
	 */
	Unilite.Main({
		borderItems:[{
			region : 'center',
			layout : 'border',
			border : false,
			items  : [
				masterGrid, panelResult, inspectForm
			]
		},
			panelSearch
		],
		id : 's_qbs400ukrv_mekApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			
			panelSearch.setValue('REQ_DATE_FR'	, UniDate.get("aMonthAgo"));
			panelResult.setValue('REQ_DATE_FR'	, UniDate.get("aMonthAgo"));
			
			panelSearch.setValue('REQ_DATE_TO'	, UniDate.get("today"));
			panelResult.setValue('REQ_DATE_TO'	, UniDate.get("today"));
			
			panelSearch.setValue('STATUS'		, '');
			panelResult.setValue('STATUS'		, '');
			
			UniAppManager.setToolbarButtons(['deleteAll', 'save'], false);
			
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
		},
		fnSetDefault : function() {
			masterForm.setValue('WORK_DATE', UniDate.get("today"));
		},
		onQueryButtonDown: function() {
			if(panelSearch.setAllFieldsReadOnly(true) && panelResult.setAllFieldsReadOnly(true)) {
				directMasterStore1.loadStoreRecords();
			}
		},
		onNewDataButtonDown: function(itemCode, orderType)	{
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterForm.clearForm();
			
			masterGrid.reset();
			masterGrid.getStore().clearData();
			
			badGrid.reset();
			badGrid.getStore().clearData();
			
			this.fnInitBinding();
			this.fnSetDefault();
		},
		onSaveDataButtonDown: function(config) {
			directBadStore.saveStore();
			
			if(directMasterStore1.isDirty()) {
				directMasterStore1.saveStore();
			}
		},
		onDeleteAllButtonDown: function() {
			Ext.Msg.confirm('<t:message code="system.label.purchase.delete" default="삭제"/>', '<t:message code="system.message.product.confirm002" default="전체삭제 하시겠습니까?"/>', function(btn){
				if (btn == 'yes') {
					masterGrid.deleteSelectedRow();
					directMasterStore1.saveStore();
				}
			});
		}
	});//End of Unilite.Main( {
	
	/**
	 * master grid validator
	 */
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
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
	
	var directRepPartProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_qbs400ukrv_mekService.selectListRepPart',
			create	: 's_qbs400ukrv_mekService.insertRepPart',
			update	: 's_qbs400ukrv_mekService.updateRepPart',
			syncAll	: 's_qbs400ukrv_mekService.saveAllRepPart'
		}
	});
	
	/**
	 * Replacement Part grid Model
	 */
	Unilite.defineModel('s_qbs400ukrv_mekRepPartModel1', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'},
			{name: 'WKORD_NUM'			, text: '<t:message code="" default="작업지시번호"/>'										, type: 'string'},
			{name: 'INSPECT_NO'			, text: '<t:message code="" default="Inspection No"/>'								, type: 'string'},
			{name: 'LOT_NO'				, text: '<t:message code="" default="LOT_NO"/>'										, type: 'string'},
			{name: 'PROD_ITEM_CODE'		, text: '<t:message code="" default="모품목코드"/>'										, type: 'string'},
			{name: 'MODEL_CODE'			, text: '<t:message code="" default="모델코드"/>'										, type: 'string'},
			{name: 'HW_VER'				, text: '<t:message code="" default="HW 버전"/>'										, type: 'string'},
			{name: 'SW_VER'				, text: '<t:message code="" default="SW 버전"/>'										, type: 'string'},
			{name: 'USE_YN'				, text: '<t:message code="" default="사용여부"/>'										, type: 'boolean'},
			{name: 'REPAIR_YN'			, text: '<t:message code="" default="수리여부"/>'										, type: 'string'},
			{name: 'REPAIR_NUM'			, text: '<t:message code="" default="수리번호"/>'										, type: 'string'}
		]
	});
	
	/**
	 * master grid store
	 */
	var directRepPartStore = Unilite.createStore('s_qbs400ukrv_mekRepPartStore1', {
		model : 's_qbs400ukrv_mekRepPartModel1',
		uniOpt: {
			isMaster  : false,			// 상위 버튼 연결
			editable  : true,			// 수정 모드 사용
			deletable : false,			// 삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
		autoLoad : false,
		proxy: directRepPartProxy,
		loadStoreRecords: function(){
			var param = repPartForm.getValues();
			console.log(param);
			
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			var param = repPartForm.getValues();
			if(inValidRecs.length == 0) {
				config = {
					params: [param],
					success: function(batch, option) {
						directRepPartStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				repPartGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				setTimeout(function(){
					repPartForm.setValue('BARCODE', '');
					repPartForm.getField('BARCODE').focus();
				}, 500);
			}
		}
	});
	
	/**
	 * panelResult
	 */
	var repPartForm = Unilite.createSearchForm('repPartForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		width: '100%',
		border:true,
		items: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			width		: 245,
			allowBlank	: false,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="" default="작업지시번호"/>',
			name		: 'WKORD_NUM',
			xtype		: 'uniTextfield',
			width		: 245,
			allowBlank	: false,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="" default="Inspection No"/>',
			name		: 'INSPECT_NO',
			xtype		: 'uniTextfield',
			width		: 245,
			allowBlank	: false,
			readOnly	: true
		},{
			xtype		: 'component',
			html		: '&nbsp;',
			tdAttrs		: {width:'100%'}
 		},{
			xtype		: 'button',
			text		: '저장',
			width		: 80,
			tdAttrs		: { style: 'padding-right: 5px;' },
			handler: function() {
				repPartWindow.fnSaveData();
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.barcode" default="바코드"/>',
			name		: 'BARCODE',
			xtype		: 'uniTextfield',
			colspan		: 5,
			width		: 735,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					repPartGrid.fnProcessBarcode(newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="" default="PROD_ITEM_CODE"/>',
			name		: 'PROD_ITEM_CODE',
			xtype		: 'uniTextfield',
			allowBlank	: false,
			readOnly	: true,
			hidden		: true
		},{
			fieldLabel	: '<t:message code="" default="MODEL_CODE"/>',
			name		: 'MODEL_CODE',
			xtype		: 'uniTextfield',
			allowBlank	: false,
			readOnly	: true,
			hidden		: true
		},{
			fieldLabel	: '<t:message code="" default="REPAIR_NUM"/>',
			name		: 'REPAIR_NUM',
			xtype		: 'uniTextfield',
			allowBlank	: false,
			readOnly	: true,
			hidden		: true
		}]
	});
	
	/**
	 * replacement part Grid
	 */
	var repPartGrid = Unilite.createGrid('repPartGrid', {
		layout: 'fit',
		region: 'center',
		flex  : 1,
		uniOpt: {
			useLiveSearch		: false,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false,
			onLoadSelectFirst	: true,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowContext		: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		store: directRepPartStore,
		sortableColumns : false,
		selModel: 'rowmodel',
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'WKORD_NUM'			, width: 100, hidden: true},
			{dataIndex: 'INSPECT_NO'		, width: 100, hidden: true},
			{dataIndex: 'LOT_NO'			, minWidth: 120, flex: 1},
			{dataIndex: 'PROD_ITEM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'MODEL_CODE'		, width: 100, hidden: true},
			{dataIndex: 'HW_VER'			, minWidth: 120, flex: 1},
			{dataIndex: 'SW_VER'			, minWidth: 120, flex: 1},
			{dataIndex: 'REPAIR_YN'			, width: 100, align: 'center'},
			{dataIndex: 'USE_YN'			, width: 100, xtype: 'checkcolumn'},
			{dataIndex: 'REPAIR_NUM'		, width: 100, hidden: true}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['USE_YN'])) {
					return true;
				}
				
				return false;
			}
		},
		fnProcessBarcode : function(val) {
			var parseVal	= val.split('^');
			var mRow		= repPartGrid.getSelectedRecord();
			var bEditYN		= true;
			
			// 행추가로 변경해야함.
			var r = {
				COMP_CODE		: UserInfo.compCode,
				DIV_CODE		: repPartForm.getValue('DIV_CODE'),
				WKORD_NUM		: repPartForm.getValue('WKORD_NUM'),
				INSPECT_NO		: repPartForm.getValue('INSPECT_NO'),
				LOT_NO			: parseVal[0],
				PROD_ITEM_CODE	: repPartForm.getValue('PROD_ITEM_CODE'),
				MODEL_CODE		: repPartForm.getValue('MODEL_CODE'),
				HW_VER			: parseVal[1],
				SW_VER			: parseVal[2],
				REPAIR_YN		: 'Y',
				USE_YN			: true,
				REPAIR_NUM		: repPartForm.getValue('REPAIR_NUM')
			};
			
			repPartGrid.createRow(r);
			
			repPartForm.setValue('BARCODE', '');
			repPartForm.getField('BARCODE').focus();
		}
	});//End of var masterGrid = Unilite.createGrid('masterGrid', {
	
	function openRepPartWindow() {
		if(!repPartWindow) {
			repPartWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="" default="계측결과입력"/>',
				width	: 1200,
				height	: 800,
				layout	: {type:'vbox', align:'stretch'},
				items	: [repPartForm, repPartGrid],
				tbar	: ['->',
					{
						itemId	: 'resultWinCloseBtn',
						text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler : function() {
							repPartWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						repPartForm.clearForm();
						repPartGrid.reset();
					},
					beforeclose: function(panel, eOpts)	{
						repPartForm.clearForm();
						repPartGrid.reset();
					},
					show: function(panel, eOpts)	{
						var mRow = masterGrid.getSelectedRecord();
						
						repPartForm.setValue('DIV_CODE'			, mRow.get('DIV_CODE'));
						repPartForm.setValue('WKORD_NUM'		, mRow.get('WKORD_NUM'));
						repPartForm.setValue('INSPECT_NO'		, mRow.get('INSPECT_NO'));
						repPartForm.setValue('PROD_ITEM_CODE'	, mRow.get('ITEM_CODE'));
						repPartForm.setValue('MODEL_CODE'		, mRow.get('MODEL'));
						repPartForm.setValue('REPAIR_NUM'		, mRow.get('REPAIR_NUM'));
						
						directRepPartStore.loadStoreRecords();
					}
				},
				fnSaveData: function() {
					if(directRepPartStore.isDirty()) {
						directRepPartStore.saveStore();
					}
				}
			});
		}
		else {
			repPartForm.clearForm();
			repPartGrid.reset();
			directRepPartStore.clearData();
			
			var mRow = masterGrid.getSelectedRecord();
			
			repPartForm.setValue('DIV_CODE'			, mRow.get('DIV_CODE'));
			repPartForm.setValue('WKORD_NUM'		, mRow.get('WKORD_NUM'));
			repPartForm.setValue('INSPECT_NO'		, mRow.get('INSPECT_NO'));
			repPartForm.setValue('PROD_ITEM_CODE'	, mRow.get('ITEM_CODE'));
			repPartForm.setValue('MODEL_CODE'		, mRow.get('MODEL'));
			repPartForm.setValue('REPAIR_NUM'		, mRow.get('REPAIR_NUM'));
			
			directRepPartStore.loadStoreRecords();
		}
		repPartWindow.show();
		repPartWindow.center();
	}
	
}
</script>