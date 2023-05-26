<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="btr901ukrv">
	<t:ExtComboStore comboType="BOR120"/>									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>						<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>						<!-- 구매단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B018"/>						<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="B021"/>						<!-- 양불구분 -->
	<t:ExtComboStore comboType="AU" comboCode="M301"/>						<!-- 단가형태 -->
	<t:ExtComboStore comboType="AU" comboCode="Q002"/>						<!-- 품질대상여부 -->
	<t:ExtComboStore comboType="W" comboCode="A"/>							<!-- 창고 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>			<!-- 창고 -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList"/>	<!-- 창고Cell -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">

var BsaCodeInfo = {		// 컨트롤러에서 받아온 데이터
	gsLotNoInputMethod	: '${gsLotNoInputMethod}',		//입력형태(Y/E/N)
	gsLotNoEssential	: '${gsLotNoEssential}',		//필수입력(Y/N)
	gsEssItemAccount	: '${gsEssItemAccount}',		//품목계정(필수Y,문자열)
	gsSumTypeCell		: '${gsSumTypeCell}'			//재고합산유형  - 창고 Cell 합산  - 20210405 추가
};
var ItemInfo = {
	gsItemAccount		: ''
}
var SearchInfoWindow;					//검색 윈도우
var gsQueryFlag		= false;				//20210406 추가: 창고변경 시, 창고에 설정되어 있는 기본창고cell 가져오는 로직 추가
var gsQueryFlag2	= false;				//20210406 추가: 조회 시, 분해수량 체크로직 수행하지 않기 위해 추가
var createBtnCount	= 0;

function appMain() {
	var sumtypeCell = true;				//20210405 추가: 재고합산유형 - 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeCell == 'Y') {
		sumtypeCell = false;
	}

	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		padding		: '1 1 1 1',
		border		: true,
		autoScroll	: true,
		layout		: {type : 'uniTable', columns : 4},
		items		: [{
			fieldLabel	: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120', 
			allowBlank	: false
		},{
			fieldLabel	: '분해창고',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox', 
			store		: Ext.data.StoreManager.lookup('whList'),
			child		: 'WH_CELL_CODE',							//20210405 추가
			allowBlank	: false,
			colspan		: sumtypeCell ? 2:1,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					//20210405 추가: 창고변경 시, 창고에 설정되어 있는 기본창고cell 가져오는 로직 추가
					var param = {
						DIV_CODE: panelResult.getValue('DIV_CODE'),
						WH_CODE	: panelResult.getValue('WH_CODE')
					}
					matrlCommonService.getWhCellCode(param, function(provider, response) {
						if(!Ext.isEmpty(provider) && !gsQueryFlag) {
							var whCellStore = panelResult.getField('WH_CELL_CODE').getStore();
							whCellStore.clearFilter(true);
							whCellStore.filter([{
								property: 'option',
								value	: newValue
							}]);
							panelResult.getField('WH_CELL_CODE').setValue(provider);
						}
						gsQueryFlag = false;
					})
					if((!panelResult.getField('LOT_NO').allowBlank && !Ext.isEmpty(panelResult.getValue('LOT_NO')))
					 || !sumtypeCell) {		//20210405 추가
						findLotStockQ();
					} else {
						findStockQ();
					}
				},
				beforequery:function( queryPlan, eOpts ) {
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
		},{	//20210405 추가
			fieldLabel	: '분해창고CELL',
			name		: 'WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			allowBlank	: sumtypeCell,
			hidden		: sumtypeCell,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					findLotStockQ();
				},
				beforequery:function( queryPlan, eOpts ) {
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
			xtype	: 'button',
			itemId	: 'createButton',
			text	: '자료생성',
			width	: 80,
			handler	: function() {
				BtnCreateStock();
			}
		},{
			fieldLabel	: '분해일',
			name		: 'INOUT_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			allowBlank	: false
		},
		Unilite.popup('DIV_PUMOK', { 
			fieldLabel		: '<t:message code="system.label.inventory.item" default="품목"/>',
			allowBlank		: false,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						panelResult.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
						panelResult.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
						ItemInfo.gsItemAccount = records[0].ITEM_ACCOUNT;
						panelResult.setValue('LOT_NO'	, '');
						findStockQ();
						fnSetFormLotNoEssential();
					},
					scope: this
				},
				onClear: function(type) {
					panelResult.setValue('ITEM_CODE', '');
					panelResult.setValue('ITEM_NAME', '');
					ItemInfo.gsItemAccount = '';
					panelResult.setValue('LOT_NO'	, '');
				},
				applyextparam: function(popup){
					if(Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
						Unilite.messageBox('<t:message code="system.message.inventory.message038" default="분해창고를 입력 하십시오."/>');
						panelResult.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_NAME', '');
						panelResult.getField('WH_CODE').focus();
						return false;
					}
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE'), 'ITEM_ACCOUNT': ['10','20']});
				}
			}
		}),
		Unilite.popup('LOT_NO',{
			fieldLabel		: 'LOT NO',
			validateBlank	: false,
			valueFieldName	: 'LOT_NO',
			colspan			: 2,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('STOCK_Q'		, records[0].STOCK_Q);
						panelResult.setValue('GOOD_STOCK_Q'	, records[0].GOOD_STOCK_Q);
						panelResult.setValue('BAD_STOCK_Q'	, records[0].BAD_STOCK_Q);
					},
					scope: this
				},
				onClear: function(type) {
					findStockQ();
					fnSetFormLotNoEssential();
				},
				applyextparam: function(popup){
					if(Ext.isEmpty(panelResult.getValue('ITEM_CODE'))) {
						Unilite.messageBox('<t:message code="system.message.inventory.message022" default="품목코드를 입력 하십시오."/>');
//						panelResult.setValue('LOT_NO', '');
//						panelResult.getField('ITEM_CODE').focus();
						return false;
					}
					if(UniAppManager.app._needSave()) {
						if(confirm('<t:message code="system.message.inventory.message036" default="저장할 데이터가 있습니다. 저장하시겠습니까?"/>')) {
							UniAppManager.app.onSaveDataButtonDown();
						}
						return false;
					}
					popup.setExtParam({
						'DIV_CODE'	: panelResult.getValue('DIV_CODE'),
						'ITEM_CODE'	: panelResult.getValue('ITEM_CODE'),
						'ITEM_NAME'	: panelResult.getValue('ITEM_NAME')
					});
				}
			}
		}),{
			fieldLabel	: '재고수량',
			name		: 'STOCK_Q',
			xtype		: 'uniNumberfield',
			type		: 'uniQty',
			readOnly	: true
		},{
			fieldLabel	: '양품수량',
			name		: 'GOOD_STOCK_Q',
			xtype		: 'uniNumberfield',
			type		: 'uniQty',
			readOnly	: true
		},{
			fieldLabel	: '불량수량',
			name		: 'BAD_STOCK_Q',
			xtype		: 'uniNumberfield',
			type		: 'uniQty',
			readOnly	: true,
			colspan		: 2
		},{
			fieldLabel	: '분해대상재고',
			xtype		: 'radiogroup',
			itemId		: 'optConTrol',
			items		: [{
				boxLabel	: '<t:message code="system.label.inventory.good" default="양품"/>',
				name		: 'optConTrol',
				inputValue	: '1',
				width		: 80
			},{
				boxLabel	: '<t:message code="system.label.inventory.defect" default="불량"/>',
				name		: 'optConTrol',
				inputValue	: '2',
				width		: 80
			}],
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!gsQueryFlag2) {
						fnChageStockQ(newValue, oldValue);
						gsQueryFlag2 = false;
					}
				}
			}
		},{
			fieldLabel	: '분해수량',
			name		: 'CHANGESTOCK_Q',
			xtype		: 'uniNumberfield',
			type		: 'uniQty',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue < 0){
						Unilite.messageBox('<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>');
						panelResult.setValue('CHANGESTOCK_Q', 0);
					}
				},
				blur: function(field, The, eOpts){
					if(panelResult.getValues().optConTrol == '1' && panelResult.getValue('CHANGESTOCK_Q') > panelResult.getValue('GOOD_STOCK_Q')) {
						Unilite.messageBox('<t:message code="system.message.inventory.message037" default="현 재고량이 분해수량보다 작습니다."/>');
						panelResult.setValue('CHANGESTOCK_Q', 0);
						panelResult.getField('CHANGESTOCK_Q').focus();
						return false;
					} else if(panelResult.getValues().optConTrol == '2' && panelResult.getValue('CHANGESTOCK_Q') > panelResult.getValue('BAD_STOCK_Q')) {
						Unilite.messageBox('<t:message code="system.message.inventory.message037" default="현 재고량이 분해수량보다 작습니다."/>');
						panelResult.setValue('CHANGESTOCK_Q', 0);
						panelResult.getField('CHANGESTOCK_Q').focus();
						return false;
					} else {
						var records = masterGrid.getStore().data.items;
						if(records) {
							Ext.each(records, function(record,i) {
								record.set('SUM_INOUT_Q'	, Unilite.multiply(panelResult.getValue('CHANGESTOCK_Q'), record.get('UNIT_Q')));
								record.set('GOOD_INOUT_Q'	, record.get('SUM_INOUT_Q') - record.get('BAD_INOUT_Q'));
							});
						}
					}
				}
			}
		},{
			xtype		: 'radiogroup',
			itemId		: 'useBom',
			fieldLabel	: 'BOM사용여부',
			items		: [{
				boxLabel	: '<t:message code="system.label.inventory.whole" default="전체"/>',
				name		: 'useBom',
				inputValue	: '',
				width		: 60
			},{
				boxLabel	: '사용',
				name		: 'useBom',
				inputValue	: '1',
				width		: 60
			},{
				boxLabel	: '미사용',
				name		: 'useBom',
				inputValue	: '2',
				width		: 80
			}]
		},{
			fieldLabel	: '분해번호',
			name		: 'INOUT_NUM',
			xtype		: 'uniTextfield',
			hidden		: true,
			listeners	: {
			}
		}]
	});



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'btr901ukrvService.selectList',
			create	: 'btr901ukrvService.insertDetail',
			update	: 'btr901ukrvService.updateDetail',
			destroy	: 'btr901ukrvService.deleteDetail',
			syncAll	: 'btr901ukrvService.saveAll'
		}
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Btr901ukrvModel', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>'			, type: 'string'	, allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.inventory.division" default="사업장"/>'				, type: 'string'	, allowBlank: false},
			{name: 'INOUT_NUM'		, text: '<t:message code="system.label.inventory.receiptno" default="입고번호"/>'			, type: 'string'/*	, allowBlank: false*/},
			{name: 'INOUT_SEQ'		, text: '<t:message code="system.label.inventory.seq" default="순번"/>'					, type: 'int'/*		, allowBlank: false*/},
			{name: 'INOUT_SEQ_NEW'	, text: '<t:message code="system.label.inventory.seq" default="순번"/>'					, type: 'int'},
			{name: 'INOUT_TYPE'		, text: '<t:message code="system.label.inventory.trantype" default="수불유형"/>'			, type: 'string'	, allowBlank: false},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.inventory.item" default="품목"/>'					, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.inventory.spec" default="규격"/>'					, type: 'string'},
			{name: 'STOCK_UNIT'		, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'UNIT_Q'			, text: '원단위량'			, type: 'uniQty'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'	, type: 'string'	, allowBlank: false			, store: Ext.data.StoreManager.lookup('whList')},
			{name: 'WH_CELL_CODE'	, text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'		, type: 'string'	, allowBlank: sumtypeCell	, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','DIV_CODE']},	//20210405 추가
			{name: 'SUM_INOUT_Q'	, text: '<t:message code="system.label.inventory.receiptqty" default="입고량"/>'			, type: 'uniQty'},
			{name: 'GOOD_INOUT_Q'	, text: '<t:message code="system.label.inventory.goodqty" default="양품수량"/>'				, type: 'uniQty'},
			{name: 'BAD_INOUT_Q'	, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'				, type: 'uniQty'},
			{name: 'LOT_NO'			, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'				, type: 'string'	, allowBlank: BsaCodeInfo.gsLotNoEssential == 'Y' ? false: true},
			{name: 'INOUT_DATE'		, text: '분해일'			, type: 'uniDate'	, allowBlank: false},
			{name: 'INOUT_P'		, text: '<t:message code="system.label.inventory.price" default="단가"/>'					, type: 'uniUnitPrice'/*, allowBlank: false*/},
			{name: 'INOUT_I'		, text: '<t:message code="system.label.inventory.amount" default="금액"/>'				, type: 'uniPrice'	/*, allowBlank: false*/},
			{name: 'USE_YN'			, text: 'BOM사용여부'		, type: 'string'	, allowBlank: false	, comboType: "AU"	, comboCode: "B018"},
			{name: 'ACCOUNT_YNC'	, text: '기표대상'			, type: 'string'	, allowBlank: false	, comboType: "AU"	, comboCode: "B018"},
			{name: 'INOUT_CODE_TYPE', text: '<t:message code="system.label.inventory.tranplacedivision" default="수불처구분"/>'	, type: 'string'	, allowBlank: false},
			{name: 'TRNS_RATE'		, text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				, type: 'float'		, decimalPrecision: 6 , format:'0,000.000000'	, allowBlank: false},
			{name: 'ITEM_ACCOUNT'	, text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>'			, type: 'string'},
			{name: 'UPDATE_DB_USER'	, text: '수정자'			, type: 'string'},
			{name: 'UPDATE_DB_TIME'	, text: '수정시간'			, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('btr901ukrvMasterStore1',{
		model	: 'Btr901ukrvModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			allDeletable: true		// 전체 삭제 가능 여부
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log( param );
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});
		},
		saveStore: function() {
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);
			var errFlag		= false;
			console.log("list:", list);

			//1. 마스터 정보 파라미터 구성
			var paramMaster	= panelResult.getValues();	// syncAll 수정
			var dDataLen	= directMasterStore.data.items.length;
			if(dDataLen == 0) {
				paramMaster.OPR_FLAG = 'D'
			} else if(Ext.isEmpty(panelResult.getValue('INOUT_NUM'))) {
				paramMaster.OPR_FLAG = 'N'
			} else {
				paramMaster.OPR_FLAG = 'U'
			}
			Ext.each(list, function(record,i) {
				if(record.get('SUM_INOUT_Q') != record.get('GOOD_INOUT_Q') + record.get('BAD_INOUT_Q')) {
					errFlag = true;
					return false;
				}
			});

			if(errFlag) {
				Unilite.messageBox('양품수량과 불량수량의 합이 입고량과 같지 않습니다.');				//20210406 수정: 메세지 수정
				return false;
			}

			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue('INOUT_NUM', master.INOUT_NUM);
						//기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);

						if(!Ext.isEmpty(panelResult.getValue('INOUT_NUM'))) {	//20210405 추가: 삭제일 때, 조회 팝업 발생하는 오류 수정
							UniAppManager.app.onQueryButtonDown();
						}
						if(directMasterStore.getCount() == 0) {
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('btr901ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records && records.length > 0) {
					fnMasterDisAble(true);
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		groupField: ''
	});

	/** Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('btr901ukrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer	: true,
			copiedRow		: false
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns: [
			{dataIndex: 'COMP_CODE'			, width:80,hidden:true},
			{dataIndex: 'DIV_CODE'			, width:80,hidden:true},
			{dataIndex: 'INOUT_NUM'			, width:80,hidden:true},
			{dataIndex: 'INOUT_SEQ'			, width:66,hidden:true},
			{dataIndex: 'INOUT_TYPE'		, width:80,hidden:true},
			{dataIndex: 'ITEM_CODE'			, width:113,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								Ext.each(records, function(record,i) {
									if(i==0) {
										//20210406 추가: 중복체크로직 추가
										var existsRecords	= masterGrid.getStore().data.items;
										var existsFlag		= false;
										Ext.each(existsRecords, function(existsRecord, i) {
											if(existsRecord.get('ITEM_NAME') == record.ITEM_NAME) {
												Unilite.messageBox('<t:message code="system.message.product.message003" default="동일한 품목이 입력 되었습니다."/>')
												existsFlag = true;
												return false;
											}
										});
										if(!existsFlag) {
											masterGrid.setItemData(record, false, masterGrid.uniOpt.currentRecord);
										} else {
											masterGrid.setItemData(null, true, masterGrid.uniOpt.currentRecord);
										}
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record, false, masterGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'SINGLE', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'				, width:200,
				editor: Unilite.popup('DIV_PUMOK_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								Ext.each(records, function(record, i) {
									if(i==0) {
										//20210406 추가: 중복체크로직 추가
										var existsRecords	= masterGrid.getStore().data.items;
										var existsFlag		= false;
										Ext.each(existsRecords, function(existsRecord, i) {
											if(existsRecord.get('ITEM_CODE') == record.ITEM_CODE) {
												Unilite.messageBox('<t:message code="system.message.product.message003" default="동일한 품목이 입력 되었습니다."/>')
												existsFlag = true;
												return false;
											}
										});
										if(!existsFlag) {
											masterGrid.setItemData(record, false, masterGrid.uniOpt.currentRecord);
										} else {
											masterGrid.setItemData(null, true, masterGrid.uniOpt.currentRecord);
										}
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record, false, masterGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setItemData(null, true, masterGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'SINGLE', 'DIV_CODE': divCode});
						}
					}
				})
			},
			{dataIndex: 'SPEC'				, width:133},
			{dataIndex: 'STOCK_UNIT'		, width:88 , align: 'center'},
			{dataIndex: 'UNIT_Q'			, width:88},
			{dataIndex: 'WH_CODE'			, width:100,
				listeners:{
					render:function(elm) {
						elm.editor.on('beforequery',function(queryPlan, eOpts) {
							var store	= queryPlan.combo.store;
							var record	= masterGrid.getSelectedRecord();
							store.clearFilter();
							store.filterBy(function(item){
								return item.get('option') == (Ext.isEmpty(record.get('DIV_CODE')) ? panelResult.getValue('DIV_CODE') : record.get('DIV_CODE'));
							})
						})
					}
				}
			},
			{dataIndex: 'WH_CELL_CODE'		, width:100, hidden: sumtypeCell,				//20210405 추가
				listeners:{
					render:function(elm) {
						elm.editor.on('beforequery',function(queryPlan, eOpts) {
							var store	= queryPlan.combo.store;
							var record	= masterGrid.getSelectedRecord();
							store.clearFilter();
							store.filterBy(function(item){
								return item.get('option') == (Ext.isEmpty(record.get('WH_CODE')) ? panelResult.getValue('WH_CODE') : record.get('WH_CODE'));
							})
						})
					}
				},
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filterBy(function(item){
						return item.get('option') == record.get('WH_CODE')
							//BSA225T의 CUSTOM_CODE가 비어 있거나 panelResult의 값과 동일한 데이터만 show
							&&(item.get('refCode10') == panelResult.getValue('CUSTOM_CODE') || item.get('refCode10') == '*')
					})
				}
			},
			{dataIndex: 'SUM_INOUT_Q'		, width:100},
			{dataIndex: 'GOOD_INOUT_Q'		, width:100},
			{dataIndex: 'BAD_INOUT_Q'		, width:100},
			{dataIndex: 'LOT_NO'			, width:120,
				editor: Unilite.popup('LOTNO_G', {
					textFieldName	: 'LOT_NO',
					DBtextFieldName	: 'LOT_NO',
					validateBlank	: false,
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var rtnRecord;
								Ext.each(records, function(record,i) {
									if(i==0){
										rtnRecord = masterGrid.uniOpt.currentRecord
									}else{
										rtnRecord = masterGrid.getSelectedRecord();
									}
									rtnRecord.set('LOT_NO'	, record['LOT_NO']);
									rtnRecord.set('WH_CODE'	, record['WH_CODE']);
								});
							},
						scope: this
						},
						'onClear': function(type) {
							var rtnRecord = masterGrid.uniOpt.currentRecord;
							rtnRecord.set('LOT_NO'				, '');
						},
						'applyextparam': function(popup){
							var record		= masterGrid.getSelectedRecord();
							var divCode		= record.get('DIV_CODE');
							var itemCode	= record.get('ITEM_CODE');
							var itemName	= record.get('ITEM_NAME');
							var whCode		= record.get('WH_CODE');
							var stockYN		= 'Y'
							popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode, 'STOCK_YN': stockYN});
						}
					}
				})
			},
			{dataIndex: 'INOUT_DATE'		, width:86 , hidden: true},
			{dataIndex: 'INOUT_P'			, width:86 , hidden: true},
			{dataIndex: 'INOUT_I'			, width:86 , hidden: true},
			{dataIndex: 'USE_YN'			, width:100, align: 'center'},
			{dataIndex: 'ACCOUNT_YNC'		, width:66 , hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'	, width:66 , hidden: true},
			{dataIndex: 'TRNS_RATE'			, width:66 , hidden: true},
			{dataIndex: 'ITEM_ACCOUNT'		, width:66 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width:86 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width:86 , hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'INOUT_SEQ', 'WH_CODE','WH_CELL_CODE'])) {	//20210405 추가: WH_CELL_CODE, 신규행이 아닐 때 수정 불가하도록 변경 (WH_CODE, WH_CELL_CODE)
					if(e.record.phantom){
						return true;
					} else {
						return false;
					}
				}
				if (UniUtils.indexOf(e.field, ['GOOD_INOUT_Q', 'BAD_INOUT_Q'])) {
						return true;
				} else {
					return false;
				}
			}
		},
		//20210406 추가: 누락된 로직 추가
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, '');
				grdRecord.set('ITEM_NAME'		, '');
				grdRecord.set('SPEC'			, '');
				grdRecord.set('STOCK_UNIT'		, '');
				grdRecord.set('UNIT_Q'			, 0);
				grdRecord.set('WH_CODE'			, '');
				grdRecord.set('WH_CELL_CODE'	, '');
				grdRecord.set('SUM_INOUT_Q'		, 0);
				grdRecord.set('GOOD_INOUT_Q'	, 0);
				grdRecord.set('BAD_INOUT_Q'		, 0);
				grdRecord.set('LOT_NO'			, '');
				grdRecord.set('INOUT_P'			, 0);
				grdRecord.set('INOUT_I'			, 0);
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('UNIT_Q'			, 1);
				grdRecord.set('WH_CODE'			, record['WH_CODE']);
				grdRecord.set('WH_CELL_CODE'	, record['WH_CELL_CODE']);
				grdRecord.set('SUM_INOUT_Q'		, panelResult.getValue('CHANGESTOCK_Q'));
				grdRecord.set('GOOD_INOUT_Q'	, panelResult.getValue('CHANGESTOCK_Q'));
				grdRecord.set('BAD_INOUT_Q'		, 0);
				grdRecord.set('LOT_NO'			, '');
				grdRecord.set('INOUT_P'			, record['BASIS_P']);
				grdRecord.set('INOUT_I'			, Unilite.multiply(panelResult.getValue('CHANGESTOCK_Q'), record['BASIS_P']));

				//20210406 추가: 창고변경 시, 창고에 설정되어 있는 기본창고cell 가져오는 로직 추가
				if(Ext.isEmpty(grdRecord.set('WH_CELL_CODE'))) {
					var param = {
						DIV_CODE: grdRecord.get('DIV_CODE'),
						WH_CODE	: grdRecord.get('WH_CODE')
					}
					matrlCommonService.getWhCellCode(param, function(provider, response) {
						if(!Ext.isEmpty(provider) && !gsQueryFlag) {
							var whCellStore = masterGrid.getColumn('WH_CELL_CODE').editor.getStore();
							whCellStore.clearFilter(true);
							whCellStore.filter([{
								property: 'option',
								value	: provider
							}]);
							grdRecord.set('WH_CELL_CODE', provider);
						}
					})
				}
			}
		}
	});



	//검색을 위한 Search Form, Grid, Inner Window 정의
	var inoutNumSearch = Unilite.createSearchForm('inoutNumSearchForm', {
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			tdAttrs		: {width: 330},
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel		: '분해일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			allowBlank		: false
		},{
			fieldLabel	: '분해창고',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox', 
			store		: Ext.data.StoreManager.lookup('whList')
		},
		Unilite.popup('DIV_PUMOK', { 
			fieldLabel		: '<t:message code="system.label.inventory.item" default="품목"/>',
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE'), 'ITEM_ACCOUNT': ['10','20']});
				}
			}
		}),{
			fieldLabel	: '분해번호',
			name		: 'INOUT_NUM',
			xtype		: 'uniTextfield',
			listeners	: {
			}
		},{
			fieldLabel	: '프로젝트번호',
			name		: 'PROJECT_NO',
			xtype		: 'uniTextfield',
			listeners	: {
			}
		}]
	}); // createSearchForm
	//검색 모델(마스터)
	Unilite.defineModel('inoutNumSearchModel', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>'			, type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.inventory.division" default="사업장"/>'				, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.inventory.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.inventory.spec" default="규격"/>'					, type: 'string'},
			{name: 'INOUT_DATE'		, text: '분해일'			, type: 'uniDate'	, allowBlank: false},
			{name: 'INOUT_Q'		, text: '분해수량'			, type: 'uniQty'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'	, type: 'string'	, store: Ext.data.StoreManager.lookup('whList')},
			{name: 'WH_CELL_CODE'	, text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'		, type: 'string'	, store: Ext.data.StoreManager.lookup('whCellList')},	//20210405 추가
			{name: 'INOUT_NUM'		, text: '<t:message code="system.label.inventory.receiptno" default="입고번호"/>'			, type: 'string'},
			{name: 'PROJECT_NO'		, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'ITEM_STATUS'	, text: '<t:message code="system.label.inventory.itemstatus" default="품목상태"/>'			, type: 'string'	, comboType: 'AU', comboCode: 'B021'},
			{name: 'LOT_NO'			, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'				, type: 'string'}
		]
	});
	//검색 스토어
	var inoutNumSearchStore = Unilite.createStore('inoutNumSearchStore', {
		model	: 'inoutNumSearchModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 'btr901ukrvService.searchPopupList'
			}
		},
		loadStoreRecords : function() {
			var param		= inoutNumSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;			// 권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;			// 부서코드
			if(authoInfo == "5" && Ext.isEmpty(inoutNumSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색 그리드
	var inoutNumSearchGrid = Unilite.createGrid('sof100ukrvinoutNumSearchGrid', {
		store	: inoutNumSearchStore,
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer	: true
		},
		selModel: 'rowmodel',
		columns	: [
			{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'ITEM_CODE'		, width: 100},
			{dataIndex: 'ITEM_NAME'		, width: 120},
			{dataIndex: 'SPEC'			, width: 120},
			{dataIndex: 'INOUT_DATE'	, width: 80},
			{dataIndex: 'INOUT_Q'		, width: 100},
			{dataIndex: 'WH_CODE'		, width: 100},
			{dataIndex: 'WH_CELL_CODE'	, width: 100 , hidden: sumtypeCell,				//20210405 추가
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filter('option', record.get('WH_CODE'));
				}
			},
			{dataIndex: 'INOUT_NUM'		, width: 120},
			{dataIndex: 'PROJECT_NO'	, width: 120},
			{dataIndex: 'ITEM_STATUS'	, width: 100, hidden: true},
			{dataIndex: 'LOT_NO'		, width: 100, hidden: true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				inoutNumSearchGrid.returnData(record);
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			gsQueryFlag  = true;
			gsQueryFlag2 = true;
			panelResult.setValues({
				'DIV_CODE'		: record.get('DIV_CODE'),
				'WH_CODE'		: record.get('WH_CODE'),
				'WH_CELL_CODE'	: record.get('WH_CELL_CODE'),		//20210405 추가
				'INOUT_DATE'	: record.get('INOUT_DATE'),
				'ITEM_CODE'		: record.get('ITEM_CODE'),
				'ITEM_NAME'		: record.get('ITEM_NAME'),
				'CHANGESTOCK_Q'	: record.get('INOUT_Q'),
				'INOUT_NUM'		: record.get('INOUT_NUM'),
				'optConTrol'	: record.get('ITEM_STATUS'),
				'LOT_NO'		: record.get('LOT_NO')
			});
			UniAppManager.app.onQueryButtonDown();
		}
	});
	//검색 팝업: openSearchInfoWindow
	function openSearchInfoWindow() {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '분해번호 검색',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [inoutNumSearch, inoutNumSearchGrid],
				tbar	: ['->', {
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						if(!inoutNumSearch.getInvalidMessage()) return;
						inoutNumSearchStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						inoutNumSearch.clearForm();
						inoutNumSearchGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						inoutNumSearch.clearForm();
						inoutNumSearchGrid.reset();
					},
					show: function( panel, eOpts ) {
						inoutNumSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						inoutNumSearch.setValue('WH_CODE'		, panelResult.getValue('WH_CODE'));
						inoutNumSearch.setValue('FR_DATE'		, UniDate.get('startOfMonth', panelResult.getValue('INOUT_DATE')));
						inoutNumSearch.setValue('TO_DATE'		, panelResult.getValue('INOUT_DATE'));
						inoutNumSearch.setValue('ITEM_CODE'		, panelResult.getValue('ITEM_CODE'));
						inoutNumSearch.setValue('ITEM_NAME'		, panelResult.getValue('ITEM_NAME'));

						inoutNumSearch.getField('FR_DATE').focus();
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}






	Unilite.Main({
		id			: 'btr901ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		}],
		fnInitBinding: function() {
			ItemInfo.gsItemAccount = '';
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('INOUT_DATE'	, UniDate.get('today'));
			panelResult.setValue('STOCK_Q'		, 0);
			panelResult.setValue('CHANGESTOCK_Q', 0);
			panelResult.setValue('STOCK_Q'		, 0);
			panelResult.setValue('GOOD_STOCK_Q'	, 0);
			panelResult.setValue('BAD_STOCK_Q'	, 0);
			panelResult.getField('optConTrol').setValue('1');
			panelResult.getField('useBom').setValue('1');
			UniAppManager.setToolbarButtons('newData', true);		//20210406 수정: 행 추가 기능 사용

			//전체권한이 아닌 경우,  사업장 비활성화 - 일단 주석
//			if(pgmInfo.authoUser != 'N') {
//				panelResult.getField('DIV_CODE').setReadOnly(true);
//			}
			//프리폼 LOT NO 필수여부 설정 (모품목)
			fnSetFormLotNoEssential(true);
		},
		onResetButtonDown: function() {
			//20210406 추가: 창고변경 시, 창고에 설정되어 있는 기본창고cell 가져오는 로직 추가 등 초기화
			gsQueryFlag		= false;
			gsQueryFlag2	= false;
			createBtnCount	= 0;

			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			fnMasterDisAble(false);
			panelResult.down('#createButton').enable();
			this.fnInitBinding();
		},
		//20210406 추가: 행 추가 기능 사용
		onNewDataButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
			if(createBtnCount == 0) {
				Unilite.messageBox('자료생성을 하신 후에 진행하시기 바랍니다.');
				return false;
			}

			var r = {
				COMP_CODE		: UserInfo.compCode,
				DIV_CODE		: panelResult.getValue('DIV_CODE'),
				INOUT_NUM		: panelResult.getValue('INOUT_NUM'),
				INOUT_TYPE		: '1',
				UPDATE_DB_USER	: UserInfo.userID,
				INOUT_DATE		: panelResult.getValue('INOUT_DATE'),
				USE_YN			: '2',
				ACCOUNT_YNC		: 'N',
				INOUT_CODE_TYPE	: '2',
				TRNS_RATE		: 1
			};
			masterGrid.createRow(r, 'ITEM_CODE', masterGrid.getStore().getCount() - 1);
		},
		onQueryButtonDown: function() {
			var inoutNo = panelResult.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow()
			} else {
				panelResult.getField('useBom').setValue('');
				if((!panelResult.getField('LOT_NO').allowBlank && !Ext.isEmpty(panelResult.getValue('LOT_NO')))
				 || !sumtypeCell) {		//20210405 추가
					findLotStockQ('QUERY');
				} else {
					findStockQ('QUERY');
				}
			}
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			fnMasterDisAble(false);
			panelResult.down('#createButton').enable();
			this.fnInitBinding();

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
		},
		onDeleteDataButtonDown: function() {
			var selRow	= masterGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)) {
				if(selRow.phantom === true) {
					masterGrid.deleteSelectedRow();
				} else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid.deleteSelectedRow();
				}
			} else {
				Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
				return false;
			}
		},
		onDeleteAllButtonDown: function() {
			var records		= directMasterStore.data.items;
			var isNewData	= false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else {								// 신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						/*---------삭제전 로직 구현 끝----------*/
						if(deletable){
							masterGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){								// 신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	// 삭제후 RESET..
			}
		},
		onSaveDataButtonDown: function(config) {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			directMasterStore.saveStore();
		}
	});



	//프리폼 및 그리드 Lot No 입력가능여부 및 입력형태 설정 (모품목)
	function fnSetFormLotNoEssential(init) {
		if(BsaCodeInfo.gsLotNoEssential == 'Y') {
			if(BsaCodeInfo.gsEssItemAccount == '') {
				panelResult.getField('LOT_NO').setConfig('allowBlank', false);
				masterGrid.getColumn('LOT_NO').setConfig('allowBlank', false);
			} else {
				if(ItemInfo.gsItemAccount == '' || BsaCodeInfo.gsEssItemAccount.indexOf(ItemInfo.gsItemAccount) == -1) {
					panelResult.getField('LOT_NO').setConfig('allowBlank'	, true);
					panelResult.getField('LOT_NO').setConfig('validateBlank', false);
					masterGrid.getColumn('LOT_NO').setConfig('allowBlank'	, true);
				} else {
					panelResult.getField('LOT_NO').setConfig('allowBlank', false);
					masterGrid.getColumn('LOT_NO').setConfig('allowBlank', false);
				}
			}
		}
/*		uniLITE 원소스
		If gsLotNoEssential = "Y" Then
			If gsEssItemAccount = "" Then
				txtLotNo.ClassName = "cssEssInput"
				txtLotNo.Style.Cursor = "n-resize"
			Else
				If gsItemAccount = "" Or InStr(gsEssItemAccount, gsItemAccount) < 1 Then
					txtLotNo.ClassName = ""
					txtLotNo.Style.Cursor = ""
				Else
					txtLotNo.ClassName = "cssEssInput"
					txtLotNo.Style.Cursor = "n-resize"
				End If
			End If
		End If*/
		//초기화 시 포커스 이동
		if(init) {
			panelResult.onLoadSelectText('DIV_CODE');
		}
	}

	//LOT별 재고수량 가져오기
	function findLotStockQ(QUERY_FLAG) {
		var param = {
			DIV_CODE	: panelResult.getValue('DIV_CODE'),
			ITEM_CODE	: panelResult.getValue('ITEM_CODE'),
			WH_CODE		: panelResult.getValue('WH_CODE'),
			WH_CELL_CODE: panelResult.getValue('WH_CELL_CODE'),
			LOT_NO		: panelResult.getValue('LOT_NO')
		}
		btr901ukrvService.findLotStockQ(param, function(provider, response) {
			if(provider && provider.length > 0) {
				panelResult.setValue('STOCK_Q'		, provider[0].STOCK_Q);
				panelResult.setValue('GOOD_STOCK_Q'	, provider[0].GOOD_STOCK_Q);
				panelResult.setValue('BAD_STOCK_Q'	, provider[0].BAD_STOCK_Q);
			} else {
				panelResult.setValue('STOCK_Q'		, 0);
				panelResult.setValue('GOOD_STOCK_Q'	, 0);
				panelResult.setValue('BAD_STOCK_Q'	, 0);
			}
			if(QUERY_FLAG == 'QUERY') {
				directMasterStore.loadStoreRecords();
			}
		});
	}

	//재고수량 가져오기
	function findStockQ(QUERY_FLAG) {
		var param = {
			DIV_CODE	: panelResult.getValue('DIV_CODE'),
			WH_CODE		: panelResult.getValue('WH_CODE'),
			ITEM_CODE	: panelResult.getValue('ITEM_CODE'),
			LOT_NO		: panelResult.getValue('LOT_NO')
		}
		btr901ukrvService.findStockQ(param, function(provider, response) {
			if(provider && provider.length > 0) {
				panelResult.setValue('STOCK_Q'		, provider[0].STOCK_Q);
				panelResult.setValue('GOOD_STOCK_Q'	, provider[0].GOOD_STOCK_Q);
				panelResult.setValue('BAD_STOCK_Q'	, provider[0].BAD_STOCK_Q);
			} else {
				panelResult.setValue('STOCK_Q'		, 0);
				panelResult.setValue('GOOD_STOCK_Q'	, 0);
				panelResult.setValue('BAD_STOCK_Q'	, 0);
			}
			if(QUERY_FLAG == 'QUERY') {
				directMasterStore.loadStoreRecords();
			}
		});
	}

	//자료생성 버튼 로직
	function BtnCreateStock() {
		if(!panelResult.getInvalidMessage()){
			return false;
		}
		createBtnCount++;
		var param = {
			DIV_CODE		: panelResult.getValue('DIV_CODE'),
			INOUT_DATE		: UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE')),
			ITEM_CODE		: panelResult.getValue('ITEM_CODE'),
			useBom			: panelResult.getValues().useBom,
			CHANGESTOCK_Q	: panelResult.getValue('CHANGESTOCK_Q')
		}
		btr901ukrvService.BtnCreateStock(param, function(provider, response) {
			if(provider && provider.length > 0) {
//				Ext.each(provider, function(record, index) {
//					record.phantom = true;
//				});
				directMasterStore.loadData(provider, true);
				fnMasterDisAble(true);
				panelResult.down('#createButton').disable();
			}
		});
	}

	//panel 비활성화
	function fnMasterDisAble(bValue) {
		panelResult.getField('DIV_CODE').setReadOnly(bValue);
		panelResult.getField('WH_CODE').setReadOnly(bValue);
		panelResult.getField('WH_CELL_CODE').setReadOnly(bValue);	//20210405 추가
		panelResult.getField('INOUT_DATE').setReadOnly(bValue);
		panelResult.getField('ITEM_CODE').setReadOnly(bValue);
		panelResult.getField('ITEM_NAME').setReadOnly(bValue);
		panelResult.getField('INOUT_NUM').setReadOnly(bValue);
		panelResult.getField('LOT_NO').setReadOnly(bValue);
		panelResult.down('#optConTrol').setReadOnly(bValue);
		panelResult.down('#useBom').setReadOnly(bValue);
	}
	
	function fnChageStockQ(newValue, oldValue) {
		var changeStockQ	= panelResult.getValue('CHANGESTOCK_Q');
		var goodStockQ		= panelResult.getValue('GOOD_STOCK_Q');
		var badStockQ		= panelResult.getValue('BAD_STOCK_Q');
		var masterRecords	= masterGrid.getStore().data.items;
		if(Ext.isEmpty(changeStockQ) || changeStockQ == 0) return false;
		if(newValue.optConTrol == '1') {
			if(goodStockQ < changeStockQ) {
				panelResult.setValue('CHANGESTOCK_Q', 0);
				Unilite.messageBox('<t:message code="system.message.sales.message149" default="현 재고량이 분해수량보다 작거나 0이하입니다."/>');
				return false;
			}
		} else {
			if(badStockQ < changeStockQ) {
				panelResult.setValue('CHANGESTOCK_Q', 0);
				Unilite.messageBox('<t:message code="system.message.sales.message149" default="현 재고량이 분해수량보다 작거나 0이하입니다."/>');
				return false;
			}
		}
		if(masterRecords.length > 0) {
			Ext.each(masterRecords, function(masterRecord,i) {
				masterRecord.set('SUM_INOUT_Q'	, Unilite.multiply(changeStockQ, masterRecord.get('UNIT_Q')));
				masterRecord.set('GOOD_INOUT_Q'	, masterRecord.get('SUM_INOUT_Q') - masterRecord.get('BAD_INOUT_Q'));
			});
		}
	}


	var validation = Unilite.createValidator('validator01', {
		store	: directMasterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, masterGrid, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case 'GOOD_INOUT_Q' :
						if(isNaN(newValue)){
							rv = '<t:message code="system.message.sales.message027" default="숫자만 입력 하세요."/>';	//숫자만 입력 하세요.
							break;
						}
					break;

				case 'BAD_INOUT_Q' :
						if(isNaN(newValue)){
							rv = '<t:message code="system.message.sales.message027" default="숫자만 입력 하세요."/>';	//숫자만 입력 하세요.
							break;
						}
					break;
			}
			return rv;
		}
	});
};
</script>