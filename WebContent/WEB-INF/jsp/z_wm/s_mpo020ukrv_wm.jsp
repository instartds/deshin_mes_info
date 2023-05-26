<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mpo020ukrv_wm">
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>				<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M007"/>				<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="Z001"/>				<!-- 단가구분(H-홈페이지, C-카페, Z-기타(기본값, REF1 = 'Y')) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM01"/>				<!-- 접수구분(10:홈페이지, 20:T전화, 30:카페, 40:입찰) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM02"/>				<!-- 접수담당(01-홍길동(REF1-사용자ID)) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM03"/>				<!-- 진행상태(A-접수, B-도착, C-분해작업중, D-분해작업완료, E-검사, F-) -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var gsInitFlag	= true;
	var BsaCodeInfo	= {
		defaultRectiptPrsn: '${defaultRectiptPrsn}'
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_mpo020ukrv_wmService.selectList',
			update	: 's_mpo020ukrv_wmService.updateDetail',
			create	: 's_mpo020ukrv_wmService.insertDetail',
			destroy	: 's_mpo020ukrv_wmService.deleteDetail',
			syncAll	: 's_mpo020ukrv_wmService.saveAll'
		}
	});

	Unilite.defineModel('s_mpo020ukrv_wmModel', {
		fields: [
			//S_MPO010T_WM (MASTER)
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'	, allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'	, allowBlank: false	, comboType:'BOR120'},
			{name: 'CUSTOM_PRSN'	, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'		, type: 'string'	, allowBlank: false},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'PHONE_NUM'		, text: '연락처'			, type: 'string'	, allowBlank: false},
			{name: 'ORDER_PRSN'		, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string'	, allowBlank: false	, comboType:'AU' , comboCode:'S010'},
			{name: 'RECEIPT_TYPE'	, text: '접수구분'			, type: 'string'	, comboType:'AU' , comboCode:'ZM01'},
			{name: 'PRICE_TYPE'		, text: '<t:message code="system.label.common.priceclass" default="단가구분"/>'			, type: 'string'	, comboType:'AU' , comboCode:'Z001'},
			{name: 'REPRE_NUM'		, text: '주민등록번호'		, type: 'string'},
			{name: 'REPRE_NUM_EXPOS', text: '주민등록번호'		, type: 'string'},
			{name: 'RECEIPT_DATE'	, text: '접수일'			, type: 'uniDate'},
			{name: 'RECEIPT_PRSN'	, text: '<t:message code="system.label.purchase.receiptcharge2" default="접수담당"/>'	, type: 'string'	, comboType:'AU'	, comboCode:'ZM02'	, editable: false},	//20201103 추가: 
			//S_MPO020T_WM (DETAIL)
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'	, allowBlank: false},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.unit" default="단위"/>'				, type: 'string'},
			{name: 'INSTOCK_Q'		, text: '도착수량'			, type: 'uniQty'	, allowBlank: true},
			{name: 'CONTROL_STATUS'	, text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'	, type: 'string'	, allowBlank: false	, comboType:'AU' , comboCode:'ZM03'},
			{name: 'ARRIVAL_DATE'	, text: '도착일'			, type: 'uniDate'},
			{name: 'ARRIVAL_PRSN'	, text: '도착확인'			, type: 'string'	, comboType:'AU'	, comboCode:'ZM02'},
			{name: 'WORK_SEQ'		, text: '우선순위'			, type: 'int'},
			{name: 'RECEIPT_NUM'	, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'		, type: 'string'},
			{name: 'RECEIPT_SEQ'	, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'		, type: 'int'},
			{name: 'RECEIPT_Q'		, text: '접수수량'				, type: 'uniQty'},
			{name: 'RECEIPT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'				, type: 'uniUnitPrice'},
			{name: 'RECEIPT_O'		, text: '<t:message code="system.label.purchase.amount" default="금액"/>'				, type: 'uniPrice'},
			{name: 'DVRY_DATE'		, text: '도착예정일'			, type: 'uniDate'},
			{name: 'REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'MONEY_UNIT'		, text: 'MONEY_UNIT'	, type: 'string'},
			{name: 'EXCHG_RATE_O'	, text: 'EXCHG_RATE_O'	, type: 'uniER'},
			{name: 'AGREE_STATUS'	, text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'		, type: 'string'	, comboType:'AU'	, comboCode:'M007', editable: false}
		]
	});

	var detailStore = Unilite.createStore('s_mpo020ukrv_wmDetailStore',{
		model	: 's_mpo020ukrv_wmModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 - 일단 삭제기능 제외 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function(newValue) {
			var param = panelResult.getValues();
			if(newValue || newValue == '') {
				param.rdoSelect = newValue;
			}
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);
			var isErr		= false;

			Ext.each(list, function(record, idx) {
				//진행상태가 '접수'가 아닐 경우, 도착수량은 필수
				if(record.get('CONTROL_STATUS') != 'A' && record.get('INSTOCK_Q') == 0) {
					Unilite.messageBox('진행상태가 접수가 아닐 경우, 도착수량은 필수 입력사항 입니다.');
					isErr = true;
					return false;
				}
			});
			if(isErr) {
				return false;
			}
			var paramMaster	= panelResult.getValues();

			if(inValidRecs.length == 0) {
				if(config == null) {
					config = {
						params	: [paramMaster],
						success	: function(batch, option) {
							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);
	
							if(detailStore.getCount() == 0){
								UniAppManager.app.onResetButtonDown();
							} else {
								UniAppManager.app.onQueryButtonDown();
							}
						}
					};
				}
				this.syncAllDirect(config);
			} else {
				 detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
					setPanelReadOnly(true);
					Ext.each(records, function(record, idx) {
						record.set('ARRIVAL_DATE', panelResult.getValue('RECEIPT_DATE'));
						record.set('ARRIVAL_PRSN', panelResult.getValue('RECEIPT_PRSN'));
						record.commit();
					});
//					detailStore.commitChanges();
				}
			},
			write: function(proxy, operation){
//				if (operation.action == 'destroy') {
//					Ext.getCmp('detailForm').reset();
//				}
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
//				detailForm.setActiveRecord(record);
			},
			remove: function( store, records, index, isMove, eOpts ) {
//				if(store.count() == 0) {
//					detailForm.clearForm();
//					detailForm.disable();
//				}
			}
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 3},
		padding		: '1 1 1 1',
		border		: true,
		api			: {
			load	: 's_mpo020ukrv_wmService.selectMaster',
			submit	: 's_mpo020ukrv_wmService.saveMaster'
		},
		items	: [{ 
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_PRSN',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '상태',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '접수',
				name		: 'rdoSelect',
				inputValue	: 'A',
				width		: 60
			},{
				boxLabel	: '도착',
				name		: 'rdoSelect',
				inputValue	: 'B',
				width		: 60
			},{
				boxLabel	: '전체',
				name		: 'rdoSelect',
				inputValue	: 'Z',
				width		: 70
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					detailStore.loadStoreRecords(newValue.rdoSelect);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
			xtype		: 'uniDatefield',
			name		: 'RECEIPT_DATE',
			holdable	: 'hold',
			allowBlank	: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptcharge2" default="접수담당"/>',
			name		: 'RECEIPT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZM02',
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}],
		listeners: {
			uniOnChange:function( basicForm, dirty, eOpts ) {
			}
		}
	});

	var detailGrid = Unilite.createGrid('s_mpo020ukrv_wmGrid', {
		store	: detailStore,
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		columns:[
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'CUSTOM_PRSN'		, width: 110},
			{dataIndex: 'CUSTOM_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 100	, hidden: true},
			{dataIndex: 'PHONE_NUM'			, width: 100},
			{dataIndex: 'ORDER_PRSN'		, width: 80		, align: 'center'},
			{dataIndex: 'RECEIPT_TYPE'		, width: 80		, align: 'center'},
			{dataIndex: 'PRICE_TYPE'		, width: 80		, align: 'center'},
//			{dataIndex: 'REPRE_NUM'			, width: 110},
			{dataIndex: 'REPRE_NUM_EXPOS'	, width: 110},
			{dataIndex: 'RECEIPT_DATE'		, width: 80		, hidden: true},
			{dataIndex: 'RECEIPT_PRSN'		, width: 80		, hidden: true},		//20201103 추가
			{dataIndex: 'ITEM_CODE'			, width: 110	,
				editor: Unilite.popup('DIV_PUMOK_G',{
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: { 
						'onSelected': {
							fn: function(records, type){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE'	,records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME'	,records[0]['ITEM_NAME']);
								grdRecord.set('SPEC'		,records[0]['SPEC']);
								grdRecord.set('ORDER_UNIT'	,records[0]['ORDER_UNIT']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'	,'');
							grdRecord.set('ITEM_NAME'	,'');
							grdRecord.set('SPEC'		,'');
							grdRecord.set('ORDER_UNIT'	,'');
						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 150	,
				editor: Unilite.popup('DIV_PUMOK_G',{
					autoPopup: true,
					listeners:{ 
						'onSelected': {
							fn: function(records, type){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE'	,records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME'	,records[0]['ITEM_NAME']);
								grdRecord.set('SPEC'		,records[0]['SPEC']);
								grdRecord.set('ORDER_UNIT'	,records[0]['ORDER_UNIT']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'	,'');
							grdRecord.set('ITEM_NAME'	,'');
							grdRecord.set('SPEC'		,'');
							grdRecord.set('ORDER_UNIT'	,'');
						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'ORDER_UNIT'		, width: 80		, align: 'center'},
			{dataIndex: 'INSTOCK_Q'			, width: 100},
			{dataIndex: 'CONTROL_STATUS'	, width: 80		, align: 'center'},
			{dataIndex: 'ARRIVAL_DATE'		, width: 100},
			{dataIndex: 'ARRIVAL_PRSN'		, width: 100},
			{dataIndex: 'WORK_SEQ'			, width: 80		, align: 'center'},
			{dataIndex: 'RECEIPT_NUM'		, width: 120},
			{dataIndex: 'RECEIPT_SEQ'		, width: 80		, align: 'center'},
			{dataIndex: 'RECEIPT_Q'			, width: 100},
			{dataIndex: 'RECEIPT_P'			, width: 100	, hidden: true},
			{dataIndex: 'RECEIPT_O'			, width: 120	, hidden: true},
			{dataIndex: 'REMARK'			, width: 150	, hidden: true},
			{dataIndex: 'DVRY_DATE'			, width: 100	, hidden: true},
			{dataIndex: 'MONEY_UNIT'		, width: 100	, hidden: true	, align: 'center'},
			{dataIndex: 'EXCHG_RATE_O'		, width: 100	, hidden: true},
			{dataIndex: 'AGREE_STATUS'		, width: 66		, hidden: true	, align: 'center'}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				//20201109 추가: 팝업 없이 수정가능하도록 변경
				if (UniUtils.indexOf(e.field,['REPRE_NUM_EXPOS'])) {
					//일단 보여주는 로직은 주석
//					var repreNum = e.record.get('REPRE_NUM');
//					if(!Ext.isEmpty(repreNum)) {
//						var param = {
//							'INCRYP_WORD'	: repreNum,
//							'INCDRC_GUBUN'	: 'DEC'
//						}
//						popupService.incryptDecryptPopup(param, function(provider, response){
//							if(!Ext.isEmpty(provider)){
//								e.record.set('REPRE_NUM_EXPOS', provider);
//							}
//						});
//					}
					return true;
				} else {
					if (!e.record.phantom) {
						if (UniUtils.indexOf(e.field,['INSTOCK_Q', 'CONTROL_STATUS', 'ARRIVAL_DATE', 'ARRIVAL_PRSN', 'WORK_SEQ'
													//20210119 추가: 단가구분 수정가능하도록 변경
													, 'PRICE_TYPE'])){
							return true;
						} else {
							return false;
						}
					} else {
						if (UniUtils.indexOf(e.field,['CUSTOM_PRSN', 'PHONE_NUM', 'ORDER_PRSN', 'RECEIPT_TYPE', 'ITEM_CODE', 'ITEM_NAME', 'INSTOCK_Q', 'CONTROL_STATUS', 'ARRIVAL_DATE', 'ARRIVAL_PRSN', 'WORK_SEQ', 'RECEIPT_Q'
													//20210119 추가: 단가구분 수정가능하도록 변경
													, 'PRICE_TYPE'])){
							return true;
						} else {
							return false;
						}
					}
				}
			},
			selectionchangerecord:function(selected) {
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
				//20201109 주석: 팝업 없이 수정가능하도록 변경
//				if (colName == 'REPRE_NUM_EXPOS') {
//					grid.ownerGrid.openCryptRepreNoPopup(record);
//				}
			}
		}//,
		//20201109 주석: 팝업 없이 수정가능하도록 변경
/*		openCryptRepreNoPopup:function( record ) {
			if(record) {
				//20201103 수정: 신규행의 경우 주민등록변호 입력 가능하게 변경, 신규 아닐때도 수정가능하게 또 변경
				if(record.phantom) {
					var inputYn = 'Y';
				} else {
					var inputYn = 'Y';
				}
				var params = {'REPRE_NUM': record.get('REPRE_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': inputYn}
				Unilite.popupCipherComm('grid', record, 'REPRE_NUM_EXPOS', 'REPRE_NUM', params);
			}
		}*/
	});




	Unilite.Main({
		id			: 's_mpo020ukrv_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid
			]
		}],
		fnInitBinding : function(params) {
			this.setDefault();
		},
		setDefault: function() {
			gsInitFlag = true;
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('rdoSelect'	, 'A');
			panelResult.setValue('RECEIPT_PRSN'	, BsaCodeInfo.defaultRectiptPrsn);
			panelResult.setValue('RECEIPT_DATE'	, UniDate.get('today'));

			UniAppManager.setToolbarButtons(['newData'], true);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');
			gsInitFlag = false;
			setPanelReadOnly(false);
		},
		onQueryButtonDown: function () {
			if(!panelResult.getInvalidMessage()) {
				return false;
			}
			detailStore.loadStoreRecords();
		},
		onNewDataButtonDown : function() {
			if(!panelResult.getInvalidMessage()){
				return false;
			}
			var r = {
				'COMP_CODE'			: UserInfo.compCode,
				'DIV_CODE'			: panelResult.getValue('DIV_CODE'),
				'CUSTOM_CODE'		: 'A00001',
//				'RECEIPT_NUM'		: '',
				'RECEIPT_SEQ'		: 1,
				'CONTROL_STATUS'	: 'B',
//				'REMARK'			: '',
				'RECEIPT_DATE'		: panelResult.getValue('RECEIPT_DATE'),
				'RECEIPT_PRSN'		: panelResult.getValue('RECEIPT_PRSN'),		//20201103 추가
				'DVRY_DATE'			: panelResult.getValue('RECEIPT_DATE'),
				'ARRIVAL_DATE'		: panelResult.getValue('RECEIPT_DATE'),
				'ARRIVAL_PRSN'		: panelResult.getValue('RECEIPT_PRSN'),
				'PRICE_TYPE'		: 'Z',
				'RECEIPT_TYPE'		: '90'										//20210119 추가
//				'MONEY_UNIT'		: '',
//				'EXCHG_RATE_O'		: '',
//				'AGREE_STATUS'		: '1',
//				'CUSTOM_PRSN'		: panelResult.getValue('CUSTOM_PRSN'),
//				'REPRE_NUM'			: panelResult.getValue('REPRE_NUM')
			};
			detailGrid.createRow(r, null, detailStore.getCount() - 1);
			setPanelReadOnly(true);
		},
//		onDeleteDataButtonDown : function() {	//일단 삭제기능 제외
//			var selRow = detailGrid.getSelectedRecord();
//			if(selRow.phantom == true) {
//				detailGrid.deleteSelectedRow();
//			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {	//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
//				detailGrid.deleteSelectedRow();
//			}
//		},
		onSaveDataButtonDown: function (config) {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			detailStore.saveStore();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			detailGrid.getStore().loadData({});
			detailStore.clearData();
			this.fnInitBinding();
		}
	});



	//panelResult readOnly 설정
	function setPanelReadOnly(flag) {
		var fields = panelResult.getForm().getFields();
		Ext.each(fields.items, function(item) {
			if(Ext.isDefined(item.holdable) ) {
				if (item.holdable == 'hold') {
					item.setReadOnly(flag);
				}
			}
			if(item.isPopupField) {
				var popupFC = item.up('uniPopupField');
				if(popupFC.holdable == 'hold') {
					popupFC.setReadOnly(flag);
				}
			}
		})
	}



	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "INSTOCK_Q" :
					//신규행일 경우에는 도착수량 입력 시, 접수수량 동일하게 변경
					if(Ext.isEmpty(record.get('RECEIPT_NUM'))) {
						record.set('RECEIPT_Q', newValue);
					} else {
						if(newValue == 0) {
							record.set('CONTROL_STATUS'	, 'A');
						} else {
							record.set('CONTROL_STATUS'	, 'B');
						}
					}
				break;

				case "REPRE_NUM_EXPOS" :
						var newValue = newValue.replace(/-/g,'');
						if(Ext.isEmpty(newValue)) {
							record.set('REPRE_NUM'		, '');
							record.set('REPRE_NUM_EXPOS', '');
							break;
						}
						if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue)) {
							record.set('REPRE_NUM'		, '');
							record.set('REPRE_NUM_EXPOS', '');
							rv = Msg.sMB074;
							break;
						}
						if(Unilite.validate('residentno', newValue) != true && !Ext.isEmpty(newValue)) {
							if(!confirm(Msg.sMB174+"\n"+Msg.sMB176)) {
								record.set('REPRE_NUM_EXPOS', '');
								rv = '입력을 취소하였습니다.';
								break;
							}
						}
						var param = {
							'DECRYP_WORD'	: newValue,
							'INCDRC_GUBUN'	: 'INC'
						}
						popupService.incryptDecryptPopup(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								record.set('REPRE_NUM', provider);
							}
						});
				break;
			}
			return rv;
		}
	})
};
</script>