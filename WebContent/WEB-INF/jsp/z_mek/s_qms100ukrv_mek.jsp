<%--
'   프로그램명 : 품질업무일보 등럭
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
<t:appConfig pgmId="s_qms100ukrv_mek"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_qms100ukrv_mekService.selectList1',
			update  : 's_qms100ukrv_mekService.update',
			create  : 's_qms100ukrv_mekService.insert',
			destroy : 's_qms100ukrv_mekService.delete',
			syncAll : 's_qms100ukrv_mekService.saveAll'
		}
	});
	
	/**
	 * master grid Model
	 */
	Unilite.defineModel('s_qms100ukrv_mekModel1', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'	, allowBlank:false},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'	, allowBlank:false},
			{name: 'WORK_DATE'			, text: '<t:message code="" default="작업일"/>'										, type: 'uniDate'	, allowBlank:false},
			{name: 'WORK_USER_ID'		, text: '<t:message code="" default="작업자"/>'										, type: 'string'	, allowBlank:false},
			{name: 'FR_TIME'			, text: '<t:message code="system.label.purchase.starttime" default="시작시간"/>'		, type: 'uniTime'	, allowBlank:false	, format:'Hi'},
			{name: 'TO_TIME'			, text: '<t:message code="system.label.purchase.endtime" default="종료시간"/>'			, type: 'uniTime'	, allowBlank:false	, format:'Hi'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'WORK_DESC'			, text: '<t:message code="" default="업무명칭"/>'										, type: 'string'},
			{name: 'INSPEC_Q'			, text: '<t:message code="" default="검사수량"/>'										, type: 'uniQty'},
			{name: 'BAD_Q'				, text: '<t:message code="system.label.purchase.defectqty" default="불량수량"/>'		, type: 'uniQty'},
			{name: 'BAD_DESC'			, text: '<t:message code="system.label.purchase.defectdetails" default="불량내역"/>'	, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'S_REMARK'			, text: '<t:message code="" default="특이사항"/>'										, type: 'string'}
		]
	});
	
	/**
	 * master grid store
	 */
	var directMasterStore1 = Unilite.createStore('s_qms100ukrv_mekMasterStore1', {
		model : 's_qms100ukrv_mekModel1',
		uniOpt: {
			isMaster  : true,			// 상위 버튼 연결
			editable  : true,			// 수정 모드 사용
			deletable : true,			// 삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
		autoLoad : false,
		proxy	: directProxy,
		loadStoreRecords: function(){
			var param = panelSearch.getValues();
			console.log(param);
			
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			
			var param = panelSearch.getValues();
			if(inValidRecs.length == 0) {
				config = {
					params: [param],
					success: function(batch, option) {
						UniAppManager.app.onQueryButtonDown();
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
					UniAppManager.setToolbarButtons(['newData','delete','print'], true);
					
					remarkForm.clearForm();
					remarkForm.setValue('S_REMARK', records[0].get('S_REMARK'));
					remarkForm.getField('S_REMARK').setReadOnly(false);
				}
				else {
					UniAppManager.setToolbarButtons(['newData'], true);
					UniAppManager.setToolbarButtons(['delete','print'], false);
					
					remarkForm.clearForm();
					remarkForm.getField('S_REMARK').setReadOnly(true);
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
				holdable	: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="" default="작업일"/>',
				name		: 'WORK_DATE',
				xtype		: 'uniDatefield',
				value		: UniDate.get('today'),
				allowBlank	: false,
				holdable	: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_DATE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="" default="작업자"/>',
				name		: 'WORK_USER_ID',
				xtype		: 'uniTextfield',
				readOnly	: true
			}]
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
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
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="" default="작업일"/>',
			name		: 'WORK_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			allowBlank	: false,
			holdable	: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_DATE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="" default="작업자"/>',
			name		: 'WORK_USER_ID',
			xtype		: 'uniTextfield',
			readOnly	: true
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
	});
	
	var remarkForm = Unilite.createSearchForm('remarkForm', {
		region		: 'south',
		//title		: '특이사항',
		defaultType	: 'uniSearchSubPanel',
		border		: true,
		collapsible	: false,
		padding		: '1 1 1 1',
		items: [{
			fieldLabel	: '특이사항',
			xtype		: 'textareafield',
			name		: 'S_REMARK',
			height		: 120,
			width		: '98%',
			padding		: '5 0 5 0',
			readOnly	: true
		}]
	});
	
	/**
	 * masterGrid
	 */
	var masterGrid = Unilite.createGrid('masterGrid', {
		layout: 'fit',
		region: 'center',
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
		columns: [
			{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'WORK_DATE'		, width: 100, hidden: true},
			{dataIndex: 'WORK_USER_ID'	, width: 100, hidden: true},
			{dataIndex: 'FR_TIME'		, width: 80 , align:"center",
				editor: {
					xtype	 : 'timefield',
					format	 : 'H:i',
					increment: 10
				}
			},
			{dataIndex: 'TO_TIME'		, width: 80 , align:"center",
				editor: {
					xtype	 : 'timefield',
					format	 : 'H:i',
					increment: 10
				}
			},
			{dataIndex: 'ITEM_CODE'		, width: 100,
				editor: Unilite.popup('DIV_PUMOK_G',{
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE',records[0]['ITEM_CODE']);
							grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);
						},
						onClear:function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE','');
							grdRecord.set('ITEM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'		, width: 150,
				editor: Unilite.popup('DIV_PUMOK_G',{
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE',records[0]['ITEM_CODE']);
							grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);
						},
						onClear:function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE','');
							grdRecord.set('ITEM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'WORK_DESC'		, width: 300},
			{dataIndex: 'INSPEC_Q'		, width: 150},
			{dataIndex: 'BAD_Q'			, width: 150},
			{dataIndex: 'BAD_DESC'		, width: 300},
			{dataIndex: 'REMARK'		, width: 300},
			{dataIndex: 'S_REMARK'		, width: 100, hidden: true}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(e.record.phantom == true){
					if (UniUtils.indexOf(e.field,['COMP_CODE','DIV_CODE','WORK_DATE','WORK_USER_ID'])){
						return false;
					} else {
						return true;
					}
				}else{
					if (UniUtils.indexOf(e.field,['COMP_CODE','DIV_CODE','WORK_DATE','WORK_USER_ID','FR_TIME'])){
						return false;
					} else {
						return true;
					}
				}
			}
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
				masterGrid, panelResult, remarkForm
			]
		},
			panelSearch
		],
		id : 's_qms100ukrv_mekApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			
			panelSearch.setValue('WORK_DATE'	, UniDate.get("today"));
			panelResult.setValue('WORK_DATE'	, UniDate.get("today"));
			
			panelSearch.setValue('WORK_USER_ID'	, UserInfo.userName);
			panelResult.setValue('WORK_USER_ID'	, UserInfo.userName);
			
			UniAppManager.setToolbarButtons(['deleteAll', 'save'], false);
			UniAppManager.setToolbarButtons(['newData'], true);
			
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			remarkForm.getField('S_REMARK').setReadOnly(true);
		},
		onQueryButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
			
			directMasterStore1.loadStoreRecords();
		},
		onNewDataButtonDown: function(itemCode, orderType)	{
			var r = {
				COMP_CODE		: UserInfo.compCode,
				DIV_CODE		: panelSearch.getValue('DIV_CODE'),
				WORK_DATE		: panelSearch.getValue('WORK_DATE'),
				WORK_USER_ID	: UserInfo.userID
			};
			
			masterGrid.createRow(r);
			
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
			
			remarkForm.getField('S_REMARK').setReadOnly(false);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			
			remarkForm.clearForm();
			
			masterGrid.reset();
			masterGrid.getStore().clearData();
			
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			var sRemark = remarkForm.getValue('S_REMARK')
			Ext.each(directMasterStore1.data.items, function(record, index){
				record.set('S_REMARK', sRemark);
			});
			
			directMasterStore1.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
				
				if(masterGrid.getStore().getCount() < 1) {
					remarkForm.clearForm();
					remarkForm.getField('S_REMARK').setReadOnly(true);
				}
				
				return;
			}
			
			Ext.Msg.confirm('<t:message code="system.label.purchase.delete" default="삭제"/>', '<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>', function(btn){
				if (btn == 'yes') {
					masterGrid.deleteSelectedRow();
					
					if(masterGrid.getStore().getCount() < 1) {
						remarkForm.clearForm();
						remarkForm.getField('S_REMARK').setReadOnly(true);
					}
				}
			});
		},
		onPrintButtonDown: function() {
			if(directMasterStore1.isDirty()) {
				alert('저장 후 인쇄하실 수 있습니다.');
			}
			var param = panelSearch.getValues();
			param.PGM_ID = 's_qms100ukrv_mek';
			param.sTxtValue2_fileTitle = '일일업무일보';
			
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/z_mek/s_qms100clrkrv_mek.do',
				prgID: 's_qms100ukrv_mek',
				extParam: param
			});
			win.center();
			win.show();
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
				case "FR_TIME":
					var frTime = '';
					var toTime = record.get('TO_TIME');
					
					if(typeof newValue === "string") {
						frTime = newValue;
					}
					else {
						frTime = UniDate.getHHMI(newValue);
					}
					
					if(!Ext.isEmpty(toTime) && frTime > UniDate.getHHMI(toTime)) {
						rv = '시작시간은 종료시간보다 클 수 없습니다.';
					}
					break;
				
				case "TO_TIME":
					var frTime = record.get('FR_TIME');
					var toTime = '';
					
					if(typeof newValue === "string") {
						toTime = newValue;
					}
					else {
						toTime = UniDate.getHHMI(newValue);
					}
					
					if(!Ext.isEmpty(frTime) && UniDate.getHHMI(frTime) > toTime) {
						rv = '종료시간은 시작시간보다 작을 수 없습니다.';
					}
					break;
				
				case "INSPEC_Q":
					if(newValue == '' || newValue < '1'){
						rv = '<t:message code="" default="검사량이 1보다 작거나 데이터가 없습니다."/>';
					}
					break;
				
				case "BAD_Q":
					var inspecQ = record.get('INSPEC_Q');
					
					if(!Ext.isEmpty(inspecQ) && newValue > inspecQ){
						rv = '<t:message code="system.message.purchase.message067" default="불량수량이 검사수량보다 많을 수 없습니다."/>';
					}
					break;
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
					var labelText = invalid.items[0]['fieldLabel']+':';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
				}
				alert(labelText+Msg.sMB083);
				invalid.items[0].focus();
			}else{
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
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
				});
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
				if(item.isPopupField)	{
					var popupFC = item.up('uniPopupField');
					if(popupFC.holdable == 'hold' ) {
						item.setReadOnly(false);
					}
				}
			});
		}
		return r;
	}
}
</script>