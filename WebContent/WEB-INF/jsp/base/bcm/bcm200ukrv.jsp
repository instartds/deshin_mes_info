<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm200ukrv">
	<t:ExtComboStore comboType="AU" comboCode="A071"/>	<!-- 반제유형 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('bcm200ukrvModel', {
		fields: [
			{name: 'CREDIT_CODE'		,text: '<t:message code="system.label.base.customcode" default="거래처코드"/>'			,type: 'string', allowBlank: false},
			{name: 'CREDIT_NAME'		,text: '<t:message code="system.label.base.customname" default="거래처명"/>'			,type: 'string', allowBlank: false},
			{name: 'JOIN_NUM'			,text: '<t:message code="system.label.base.franchiseenum" default="가맹점번호"/>'		,type: 'string', allowBlank: false},
			{name: 'SET_DATE'			,text: '<t:message code="system.label.base.paydate" default="결제일"/>'				,type: 'uniQty', maxLength: 2},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.base.bankcode" default="은행코드"/>'				,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.base.bankname" default="은행명"/>'				,type: 'string'},
			{name: 'FEE_RATE'			,text: '<t:message code="system.label.base.commissionrate" default="수수료율"/>'		,type: 'uniPercent', allowBlank: false},
			{name: 'CARD_COMP_CODE'		,text: '<t:message code="system.label.base.cardcompanycode" default="카드회사코드"/>'		,type: 'string', allowBlank: false},
			{name: 'CARD_COMP_NAME'		,text: '<t:message code="system.label.base.cardcompanyname" default="카드회사명"/>'		,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.base.updateuser" default="수정자"/>'				,type: 'string'},
			{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.base.updatedate" default="수정일"/>'				,type: 'uniDate'} 
		]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bcm200ukrvService.selectDetailList',
			update	: 'bcm200ukrvService.updateDetail',
			create	: 'bcm200ukrvService.insertDetail',
			destroy	: 'bcm200ukrvService.deleteDetail',
			syncAll	: 'bcm200ukrvService.saveAll'
		}
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('bcm200ukrvMasterStore',{
		model	: 'bcm200ukrvModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function() {
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function(config) {	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			console.log("toUpdate",toUpdate);
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
//						detailForm.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});



	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title		: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [
				Unilite.popup('CUST_CREDIT_CARD',{ 
				fieldLabel		: '<t:message code="system.label.base.custom" default="거래처"/>',
				validateBlank	: false,			//20210817 추가 
				listeners		: {
					//20210817 수정: 조회조건 팝업설정에 맞게 변경
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUST_CREDIT_CODE_V', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUST_CREDIT_NAME_V', '');
							panelResult.setValue('CUST_CREDIT_NAME_V', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUST_CREDIT_NAME_V', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUST_CREDIT_CODE_V', '');
							panelResult.setValue('CUST_CREDIT_CODE_V', '');
						}
//					},
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('CUST_CREDIT_CODE_V', panelSearch.getValue('CUST_CREDIT_CODE_V'));
//							panelResult.setValue('CUST_CREDIT_NAME_V', panelSearch.getValue('CUST_CREDIT_NAME_V'));
//						},
//						scope: this
//					},
//					onClear: function(type) {
//						panelResult.setValue('CUST_CREDIT_CODE_V', '');
//						panelResult.setValue('CUST_CREDIT_NAME_V', '');
					}
				}
			}),
				Unilite.popup('CREDIT_CARD',{ 
				fieldLabel		: '<t:message code="system.label.base.creditcardcomp" default="신용카드사"/>',
				validateBlank	: false,			//20210817 추가  
				listeners		: {
					//20210817 수정: 조회조건 팝업설정에 맞게 변경
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CREDIT_CODE_V', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CREDIT_NAME_V', '');
							panelResult.setValue('CREDIT_NAME_V', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CREDIT_NAME_V', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CREDIT_CODE_V', '');
							panelResult.setValue('CREDIT_CODE_V', '');
						}
//					},
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('CREDIT_CODE_V', panelSearch.getValue('CREDIT_CODE_V'));
//							panelResult.setValue('CREDIT_NAME_V', panelSearch.getValue('CREDIT_NAME_V'));
//						},
//						scope: this
//					},
//					onClear: function(type) {
//						panelResult.setValue('CREDIT_CODE_V', '');
//						panelResult.setValue('CREDIT_NAME_V', '');
					}
				}
			})]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			Unilite.popup('CUST_CREDIT_CARD',{ 
				fieldLabel		: '<t:message code="system.label.base.custom" default="거래처"/>',
				validateBlank	: false,			//20210817 추가 
				listeners		: {
					//20210817 수정: 조회조건 팝업설정에 맞게 변경
					onValueFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('CUST_CREDIT_CODE_V', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUST_CREDIT_NAME_V', '');
							panelResult.setValue('CUST_CREDIT_NAME_V', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('CUST_CREDIT_NAME_V', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUST_CREDIT_CODE_V', '');
							panelResult.setValue('CUST_CREDIT_CODE_V', '');
						}
//					},
//					onSelected: {
//						fn: function(records, type) {
//							panelSearch.setValue('CUST_CREDIT_CODE_V', panelResult.getValue('CUST_CREDIT_CODE_V'));
//							panelSearch.setValue('CUST_CREDIT_NAME_V', panelResult.getValue('CUST_CREDIT_NAME_V'));
//						},
//						scope: this
//					},
//					onClear: function(type) {
//						panelSearch.setValue('CUST_CREDIT_CODE_V', '');
//						panelSearch.setValue('CUST_CREDIT_NAME_V', '');
					}
				}
			}),
			Unilite.popup('CREDIT_CARD',{ 
				fieldLabel		: '<t:message code="system.label.base.creditcardcomp" default="신용카드사"/>',
				validateBlank	: false,			//20210817 추가 
				listeners		: {
					//20210817 수정: 조회조건 팝업설정에 맞게 변경
					onValueFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('CREDIT_CODE_V', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CREDIT_NAME_V', '');
							panelResult.setValue('CREDIT_NAME_V', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('CREDIT_NAME_V', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CREDIT_CODE_V', '');
							panelResult.setValue('CREDIT_CODE_V', '');
						}
//					},
//					onSelected: {
//						fn: function(records, type) {
//							panelSearch.setValue('CREDIT_CODE_V', panelResult.getValue('CREDIT_CODE_V'));
//							panelSearch.setValue('CREDIT_NAME_V', panelResult.getValue('CREDIT_NAME_V'));
//						},
//						scope: this
//					},
//					onClear: function(type) {
//						panelSearch.setValue('CREDIT_CODE_V', '');
//						panelSearch.setValue('CREDIT_NAME_V', '');
					}
				}
			})]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('bcm200ukrvGrid', {
		layout : 'fit',
		region:'center',
		store : directMasterStore, 
		uniOpt:{
			expandLastColumn: true,
			useRowNumberer: true,
			useMultipleSorting: true
		},
		tbar: [{
			text:'<t:message code="system.label.base.detailsview" default="상세보기"/>',
			handler: function() {
				var record = masterGrid.getSelectedRecord();
				if(record) {
					openDetailWindow(record);
				}
			}
		}],
		columns: [
			{dataIndex: 'CREDIT_CODE'		, width: 80,
				editor: Unilite.popup('AGENT_CUST_G', {
// 				textFieldName: 'CUST_CREDIT_NAME_V',
 				DBtextFieldName: 'CUSTOM_CODE',
 				extParam: {AGENT_TYPE: '4'},
				autoPopup: true,
 				listeners: {'onSelected': {
					fn: function(records, type) {
						Ext.each(records, function(record,i) {
							if(i==0) {
								var grdRecord = masterGrid.getSelectedRecord(); 
								grdRecord.set('CREDIT_CODE',record['CUSTOM_CODE'] );
								grdRecord.set('CREDIT_NAME',record['CUSTOM_NAME'] );
							}
						}); 
					},
					scope: this
					},
					'onClear': function(type) {
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('CREDIT_CODE','');
						grdRecord.set('CREDIT_NAME','');
					}
				}
	 		})},
			{dataIndex: 'CREDIT_NAME'			, width: 166,
				editor: Unilite.popup('AGENT_CUST_G', {	
				extParam: {AGENT_TYPE: '4'},
				autoPopup: true,
 				listeners: {'onSelected': {
					fn: function(records, type) {
						Ext.each(records, function(record,i) {
							if(i==0) {
								var grdRecord = masterGrid.getSelectedRecord(); 
								grdRecord.set('CREDIT_CODE',record['CUSTOM_CODE'] );
								grdRecord.set('CREDIT_NAME',record['CUSTOM_NAME'] );
							}
						}); 
					},
					scope: this
					},
					'onClear': function(type) {
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('CREDIT_CODE','');
						grdRecord.set('CREDIT_NAME','');
					}
				}
	 		})},
			{dataIndex: 'JOIN_NUM' 				, width: 133}, 
			{dataIndex: 'SET_DATE' 				, width: 66, align: 'center'},
			{dataIndex: 'CUSTOM_CODE'			, width: 66,
				'editor' : Unilite.popup('BANK_G',	{
 				DBtextFieldName: 'BANK_CODE',
				autoPopup: true,
				listeners: {
					'onSelected': function(records, type  ){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('CUSTOM_CODE',records[0]['BANK_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['BANK_NAME']);
					},
					'onClear':  function( type  ){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
					}
				} // listeners
			})},
			{dataIndex: 'CUSTOM_NAME'			, width: 166,
				'editor' : Unilite.popup('BANK_G',	{
				autoPopup: true,
				listeners: {
					'onSelected': function(records, type  ){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('CUSTOM_CODE',records[0]['BANK_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['BANK_NAME']);
					},
					'onClear':  function( type  ){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
					}
				} // listeners
			})}, 
			{dataIndex: 'FEE_RATE' 				, width: 80},
			{dataIndex: 'CARD_COMP_CODE'		, width: 100,
				editor: Unilite.popup('CREDIT_CARD_G', {
// 				textFieldName: 'CUST_CREDIT_NAME_V',
 				DBtextFieldName: 'CREDIT_CODE',
// 				extParam: {TYPE: 'VALUE'},
				autoPopup: true,
 				listeners: {'onSelected': {
					fn: function(records, type) {
						Ext.each(records, function(record,i) {
							if(i==0) {
								var grdRecord = masterGrid.getSelectedRecord(); 
								grdRecord.set('CARD_COMP_CODE',record['CREDIT_CODE'] );
								grdRecord.set('CARD_COMP_NAME',record['CREDIT_NAME'] );
							}
						}); 
					},
					scope: this
					},
					'onClear': function(type) {
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('CARD_COMP_CODE','');
						grdRecord.set('CARD_COMP_NAME','');
					}
				}
	 		})},
			{dataIndex: 'CARD_COMP_NAME'		, width: 166,
				editor: Unilite.popup('CREDIT_CARD_G', {
//				textFieldName: 'CUST_CREDIT_NAME_V',
//				extParam: {TYPE: 'VALUE'},
				autoPopup: true,
				listeners: {'onSelected': {
					fn: function(records, type) {
						Ext.each(records, function(record,i) {
							if(i==0) {
								var grdRecord = masterGrid.getSelectedRecord(); 
								grdRecord.set('CARD_COMP_CODE',record['CREDIT_CODE'] );
								grdRecord.set('CARD_COMP_NAME',record['CREDIT_NAME'] );
							}
						}); 
					},
					scope: this
					},
					'onClear': function(type) {
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('CARD_COMP_CODE','');
						grdRecord.set('CARD_COMP_NAME','');
					}
				}
	 		})}, 
			{dataIndex: 'UPDATE_DB_USER'		, width: 66 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 100, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if (UniUtils.indexOf(e.field, ['CREDIT_CODE','CREDIT_NAME','CARD_COMP_CODE','CARD_COMP_NAME']))
					return false;
				}
			}
		}
	});



	Unilite.Main({
		id			: 'bcm200ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('newData'	, true);
			UniAppManager.setToolbarButtons('save'		, false);
		},
		onQueryButtonDown : function() {
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {	// 초기화
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onNewDataButtonDown : function(additemCode) {
			var r = {
			};
			masterGrid.createRow(r);
		},
		onDeleteDataButtonDown: function() {
			if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onSaveDataButtonDown: function (config) {
			directMasterStore.saveStore(config);
		}
	});
};
</script>