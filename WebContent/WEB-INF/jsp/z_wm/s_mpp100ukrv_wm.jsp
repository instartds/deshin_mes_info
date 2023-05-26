<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mpp100ukrv_wm">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>	<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="Z001"/>	<!-- 단가구분(H-홈페이지, C-카페, Z-기타(기본값, REF1 = 'Y')) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM01"/>	<!-- 접수구분(10:홈페이지, 20:T전화, 30:카페, 40:입찰) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM03"/>	<!-- 진행상태(A-접수, B-도착, C-분해작업중, D-분해작업완료, E-검사, F-) -->
	<t:ExtComboStore comboType="OU" />					<!-- 창고 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var gsInitFlag	= true;

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_mpp100ukrv_wmService.selectList',
			update	: 's_mpp100ukrv_wmService.updateDetail',
			syncAll	: 's_mpp100ukrv_wmService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_mpp100ukrv_wmService.selectList2',
			update	: 's_mpp100ukrv_wmService.updateDetail2',
			create	: 's_mpp100ukrv_wmService.insertDetail2',
			destroy	: 's_mpp100ukrv_wmService.deleteDetail2',
			syncAll	: 's_mpp100ukrv_wmService.saveAll2'
		}
	});



	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 3},
		padding		: '1 1 1 1',
		border		: true,
		api			: {
			load	: 's_mpp100ukrv_wmService.selectMaster',
			submit	: 's_mpp100ukrv_wmService.saveMaster'
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
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					if(Ext.isEmpty(newValue)) {
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
				},
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
			xtype		: 'uniCombobox',
			name		: 'WH_CODE',
			comboType	: 'OU',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						})
					} else {
						store.filterBy(function(record){
							return false;
						})
					}
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
			fieldLabel		: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_RECEIPT_DATE',
			endFieldName	: 'TO_RECEIPT_DATE',
			colspan			: 2
		},{
			fieldLabel	: '연락처',
			xtype		: 'uniTextfield',
			name		: 'PHONE_NUM',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '상태',
			xtype		: 'radiogroup',
			colspan		: 2,
			items		: [{
				//20210113 수정: 도착, 작업 중 하나의 그룹으로 변경
				boxLabel	: '도착/작업중',
				name		: 'rdoSelect',
				inputValue	: 'B',
				width		: 95
			},{
//				boxLabel	: '작업중',
//				name		: 'rdoSelect',
//				inputValue	: 'C',
//				width		: 70
//			},{
				boxLabel	: '작업완료',
				name		: 'rdoSelect',
				inputValue	: 'D',
				width		: 80
			},{
				boxLabel	: '전체',
				name		: 'rdoSelect',
				inputValue	: 'Z',
				width		: 70
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					detailStore2.loadData({});
					detailStore.loadStoreRecords(newValue.rdoSelect);
				}
			}
		}],
		listeners: {
			uniOnChange:function( basicForm, dirty, eOpts ) {
			}
		}
	});



	Unilite.defineModel('s_mpp100ukrv_wmModel', {
		fields: [
			//S_MPO010T_WM (MASTER)
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'	, allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'	, allowBlank: false	, comboType:'BOR120'},
			{name: 'CUSTOM_PRSN'	, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'		, type: 'string'	, allowBlank: false},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'RECEIPT_DATE'	, text: '접수일'			, type: 'uniDate'},
			{name: 'PRICE_TYPE'		, text: '<t:message code="system.label.common.priceclass" default="단가구분"/>'			, type: 'string'	, comboType:'AU' , comboCode:'Z001'},
			//S_MPO020T_WM (DETAIL)
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'	, allowBlank: false},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.unit" default="단위"/>'				, type: 'string'},
			{name: 'INSTOCK_Q'		, text: '도착수량'			, type: 'uniQty'	, allowBlank: true},
			{name: 'CONTROL_STATUS'	, text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'	, type: 'string'	, allowBlank: false	, comboType:'AU' , comboCode:'ZM03'},
			{name: 'WORK_SEQ'		, text: '우선순위'			, type: 'int'},
			{name: 'RECEIPT_NUM'	, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'		, type: 'string'},
			{name: 'RECEIPT_SEQ'	, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'		, type: 'int'},
			{name: 'MONEY_UNIT'		, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'			, type: 'string'},
			{name: 'HOME_REMARK'	, text: 'HOME_REMARK'	, type: 'string'}			//20210119 추가
		]
	});

	var detailStore = Unilite.createStore('s_mpp100ukrv_wmDetailStore',{
		model	: 's_mpp100ukrv_wmModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
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
			var toUpdate	= this.getUpdatedRecords();
			var dRecord2	= detailGrid2.getStore().data.items;
			var isErr		= false;

			Ext.each(toUpdate, function(record, idx) {
				if(record.get('CONTROL_STATUS') == 'D' && dRecord2.length == 0) {
					Unilite.messageBox('분해부품 정보를 입력하신 후 저장하세요.');
					isErr = true;
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
							//20210113 수정: 주석
//							panelResult.resetDirtyStatus();
//							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);

							if(detailStore2.isDirty()) {
								detailStore2.saveStore();
							} else {
								if(detailStore.getCount() == 0){
									UniAppManager.app.onResetButtonDown();
								} else {
									detailStore2.loadData({});
									UniAppManager.app.onQueryButtonDown();
								}
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

	var detailGrid = Unilite.createGrid('s_mpp100ukrv_wmGrid', {
		store	: detailStore,
		region	: 'north',
		split	: true,			//20210119 추가
		height	: 300,
		uniOpt	: {
			onLoadSelectFirst	: true,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		columns:[
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'CUSTOM_PRSN'		, width: 110},
			{dataIndex: 'CUSTOM_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 150},
			{dataIndex: 'RECEIPT_DATE'		, width: 80		, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 110},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'ORDER_UNIT'		, width: 80		, align: 'center'},
			{dataIndex: 'INSTOCK_Q'			, width: 100},
			{dataIndex: 'CONTROL_STATUS'	, width: 90		, align: 'center'},
			{dataIndex: 'WORK_SEQ'			, width: 80		, align: 'center'},
			{dataIndex: 'RECEIPT_NUM'		, width: 120},
			{dataIndex: 'RECEIPT_SEQ'		, width: 80		, align: 'center'},
			{dataIndex: 'PRICE_TYPE'		, width: 80		, align: 'center'},
			{dataIndex: 'MONEY_UNIT'		, width: 80		, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['CONTROL_STATUS'])){
					return true;
				} else {
					return false;
				}
			},
			beforeselect: function(rowSelection, record, index, eOpts) {
				if(UniAppManager.app._needSave()) {
					Unilite.messageBox('저장할 데이타가 있습니다. 저장 후 진행해 주세요.')
					return false;
				}
			},
			selectionchangerecord:function(selected) {
				if(selected) {
					detailStore2.loadStoreRecords(selected);
					orderCommentViewer.setValue('HOME_REMARK', selected.get('HOME_REMARK'));		//20210119 추가
				}
			}
		}
	});


	Unilite.defineModel('s_mpp100ukrv_wmModel2', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'	, type: 'string'	, allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string'	, allowBlank: false	, comboType:'BOR120'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'	, allowBlank: false},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.purchase.unit" default="단위"/>'			, type: 'string'},	//재고단위
			{name: 'RECEIPT_Q'		, text: '<t:message code="system.label.purchase.qty" default="수량"/>'			, type: 'uniQty'	, allowBlank: false},
			{name: 'RECEIPT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'			, type: 'uniUnitPrice'},
			{name: 'RECEIPT_O'		, text: '<t:message code="system.label.purchase.amount" default="금액"/>'			, type: 'uniPrice'},
			{name: 'REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'		, type: 'string'},
			{name: 'BASIS_NUM'		, text: 'BASIS_NUM'		, type: 'string'},
			{name: 'BASIS_SEQ'		, text: 'BASIS_SEQ'		, type: 'int'},
			//저장용 데이터
			{name: 'CUSTOM_CODE'	, text: 'CUSTOM_CODE'		, type: 'string'},
			{name: 'RECEIPT_NUM'	, text: 'RECEIPT_NUM'		, type: 'string'},
			{name: 'RECEIPT_SEQ'	, text: 'RECEIPT_SEQ'		, type: 'int'},
			{name: 'RECEIPT_DATE'	, text: 'RECEIPT_DATE'		, type: 'uniDate'}
		]
	});

	var detailStore2 = Unilite.createStore('s_mpp100ukrv_wmDetailStore2',{
		model	: 's_mpp100ukrv_wmModel2',
		proxy	: directProxy2,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function(record) {
			var param = panelResult.getValues();
			if(record) {
				param.RECEIPT_NUM = record.get('RECEIPT_NUM');
				param.RECEIPT_SEQ = record.get('RECEIPT_SEQ');
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
//							} else {
//								UniAppManager.app.onQueryButtonDown();
							}
						}
					};
				}
				this.syncAllDirect(config);
			} else {
				 detailGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
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

	var detailGrid2 = Unilite.createGrid('s_mpp100ukrv_wmGrid2', {
		store	: detailStore2,
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: true,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		columns:[
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 110	,
				editor: Unilite.popup('DIV_PUMOK_G',{
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: { 
						'onSelected': {
							fn: function(records, type){
								//20200921 수정: 멀티 선택으로 변경
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid2.setItemData(record, false, detailGrid2.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid2.setItemData(record, false, detailGrid2.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear' : function(type) {
							//20200921 수정: 멀티 선택으로 변경
							detailGrid2.setItemData(null,true, detailGrid2.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
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
								//20200921 수정: 멀티 선택으로 변경
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid2.setItemData(record, false, detailGrid2.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid2.setItemData(record, false, detailGrid2.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear' : function(type) {
							//20200921 수정: 멀티 선택으로 변경
							detailGrid2.setItemData(null,true, detailGrid2.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'STOCK_UNIT'		, width: 80		, align: 'center'},
			{dataIndex: 'RECEIPT_Q'			, width: 100},
			{dataIndex: 'RECEIPT_P'			, width: 100	, hidden: true},
			{dataIndex: 'RECEIPT_O'			, width: 100	, hidden: true},
			{dataIndex: 'REMARK'			, width: 300},
			{dataIndex: 'BASIS_NUM'			, width: 100	, hidden: true},
			{dataIndex: 'BASIS_SEQ'			, width: 100	, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'RECEIPT_NUM'		, width: 100	, hidden: true},
			{dataIndex: 'RECEIPT_SEQ'		, width: 100	, hidden: true},
			{dataIndex: 'RECEIPT_DATE'		, width: 100	, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'REMARK'])){
					return true;
				} else if (UniUtils.indexOf(e.field, ['RECEIPT_Q'])){
					if(Ext.isEmpty(e.record.get('ITEM_CODE')) || Ext.isEmpty(e.record.get('ITEM_NAME'))) {
						Unilite.messageBox('품목을 먼저 선택하세요.');
						return false;
					} else {
						return true;
					}
				} else {
					return false;
				}
			},
			selectionchangerecord:function(selected) {
			}
		},
		//20200921 추가: 그리드 품목 컬럼 멀티 선택으로 변경
		setItemData: function(record, dataClear, grdRecord) {
			if(!dataClear) {
				grdRecord.set('ITEM_CODE'	, record.ITEM_CODE);
				grdRecord.set('ITEM_NAME'	, record.ITEM_NAME);
				grdRecord.set('SPEC'		, record.SPEC);
				grdRecord.set('STOCK_UNIT'	, record.STOCK_UNIT);
				//단가 가져오는 로직
				var selectedMRecord = detailGrid.getSelectedRecord();
				var param = {
					TYPE		: selectedMRecord.get('PRICE_TYPE'),
					DIV_CODE	: grdRecord.get('DIV_CODE'),
					ITEM_CODE	: record.ITEM_CODE,
					ORDER_UNIT	: record.STOCK_UNIT,
					MONEY_UNIT	: selectedMRecord.get('MONEY_UNIT'),
					RECEIPT_DATE: UniDate.getDateStr(selectedMRecord.get('RECEIPT_DATE'))
				}
				s_mpp100ukrv_wmService.getItemPrice(param, function(provider, response){
					if(provider && provider.ITEM_P) {
						grdRecord.set('RECEIPT_P', provider.ITEM_P);
						grdRecord.set('RECEIPT_O', Unilite.multiply(provider.ITEM_P, grdRecord.get('RECEIPT_Q')));
					} else {
						grdRecord.set('RECEIPT_P', 0);
						grdRecord.set('RECEIPT_O', 0);
					}
				});
			} else {
				grdRecord.set('ITEM_CODE'	, '');
				grdRecord.set('ITEM_NAME'	, '');
				grdRecord.set('SPEC'		, '');
				grdRecord.set('STOCK_UNIT'	, '');
				grdRecord.set('RECEIPT_P'	, 0);
			}
		}
	});



	//20210119 추가: 주문등록 시 등록된 접수내용 보여주기 위해 추가
	var orderCommentViewer = Unilite.createSearchForm('detailForm', {
		layout	: {type:'hbox', align:'stretch'},
		region	: 'center',
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
				xtype		: 'htmleditor',
				fieldLabel	: '',
				name		: 'HOME_REMARK',
				flex		: 1,
				readOnly	: true,
				listeners	: {
					afterrender: function(editor) {
						editor.getToolbar().hide();
					},
					scope: this
				}
		}]
	});



	Unilite.Main({
		id			: 's_mpp100ukrv_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid, detailGrid2,
				//20210119 추가: 주문등록 시 등록된 접수내용 보여주기 위해 추가
				{
					region	: 'east',
					xtype	: 'container',
					layout	: 'fit',
					flex	: 0.6,
					items	: [ orderCommentViewer ]
				}
			]
		}],
		fnInitBinding : function(params) {
			this.setDefault();
		},
		setDefault: function() {
			gsInitFlag = true;
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('rdoSelect'		, 'B');
			panelResult.setValue('TO_RECEIPT_DATE'	, UniDate.get('today'));
			panelResult.setValue('FR_RECEIPT_DATE'	, UniDate.add(panelResult.getValue('TO_RECEIPT_DATE'), {weeks: -1}));

			UniAppManager.setToolbarButtons(['newData'], true);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');
			gsInitFlag = false;
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

			var seq = detailStore2.max('RECEIPT_SEQ');
			if(!seq) seq = 1;
			else seq += 1;

			var selectedRecord = detailGrid.getSelectedRecord();
			if (selectedRecord) {
				var r = {
					'COMP_CODE'		: UserInfo.compCode,
					'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
					'CUSTOM_CODE'	: selectedRecord.get('CUSTOM_CODE'),
					'RECEIPT_NUM'	: '',
					'RECEIPT_SEQ'	: seq,
					'RECEIPT_DATE'	: UniDate.get('today'),
					'BASIS_NUM'		: selectedRecord.get('RECEIPT_NUM'),
					'BASIS_SEQ'		: selectedRecord.get('RECEIPT_SEQ')
				};
				detailGrid2.createRow(r, null, detailStore2.getCount() - 1);
			} else {
				Unilite.messageBox('접수/도착 데이터를 선택하세요.');
				return false;
			}
		},
		onDeleteDataButtonDown : function() {
			var selRow = detailGrid2.getSelectedRecord();
			if(selRow) {
				if(selRow.phantom == true) {
					detailGrid2.deleteSelectedRow();
				} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {	//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
					detailGrid2.deleteSelectedRow();
				}
			} else {
				Unilite.messageBox('선택된 데이터가 없습니다.');
				return false;
			}
		},
		onSaveDataButtonDown: function (config) {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			if(detailStore.isDirty()) {
				detailStore.saveStore();
			} else {
				detailStore2.saveStore();
			}
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			orderCommentViewer.clearForm();		//2021019 추가
			detailGrid.getStore().loadData({});
			detailGrid2.getStore().loadData({});
			this.fnInitBinding();
		}
	});



	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
//				case "INSTOCK_Q" :
//				break;
			}
			return rv;
		}
	})

	Unilite.createValidator('validator02', {
		store	: detailStore2,
		grid	: detailGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case 'RECEIPT_Q' :
					record.set('RECEIPT_O', Unilite.multiply(record.get('RECEIPT_P'), newValue));
				break;
			}
			return rv;
		}
	})
};
</script>