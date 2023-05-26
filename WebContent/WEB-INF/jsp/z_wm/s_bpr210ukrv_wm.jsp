<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bpr210ukrv_wm">
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B131"/>				<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="Z005"/>				<!-- 품목그룹 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="s_bpr210ukrv_wmLevel1Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="s_bpr210ukrv_wmLevel2Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="s_bpr210ukrv_wmLevel3Store"/>
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{ 
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue) {
					if(Ext.isEmpty(newValue)) {
						panelResult.setValue('ITEM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue) {
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '품목그룹',
			name		: 'ITEM_GROUP',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'Z005'
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 3 0',
			items	: [{
				fieldLabel	: '<t:message code="system.label.base.itemgroup" default="품목분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_bpr210ukrv_wmLevel1Store'),
				child		: 'ITEM_LEVEL2',
				width		: 220
			}, {
				fieldLabel	: '',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_bpr210ukrv_wmLevel2Store'),
				child		: 'ITEM_LEVEL3',
				width		: 130

			 }, {
				fieldLabel	: '',
				name		: 'ITEM_LEVEL3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_bpr210ukrv_wmLevel3Store'),
				width		: 130
			}]
		}]
	});



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_bpr210ukrv_wmService.selectList',
			update	: 's_bpr210ukrv_wmService.updateList',
			create	: 's_bpr210ukrv_wmService.insertList',
			destroy	: 's_bpr210ukrv_wmService.deleteList',
			syncAll	: 's_bpr210ukrv_wmService.saveAll'
		}
	});

	Unilite.defineModel('s_bpr210ukrv_wmModel', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'	, comboType: 'BOR120'},
			{name: 'ITEM_GROUP'		, text: '<t:message code="system.label.base.itemgroup" default="품목분류"/>'			, type: 'string'	, allowBlank: false, comboType: 'AU'	, comboCode: 'Z005'},
			{name: 'SORT_SEQ'		, text: '순번'	, type: 'int'	, allowBlank: false},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'				, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.base.itemname" default="품목명"/>'				, type: 'string'	, allowBlank: false},
			{name: 'SPEC'			, text: '<t:message code="system.label.base.spec" default="규격"/>'					, type: 'string'},
			{name: 'USE_YN'			, text: '<t:message code="system.label.sales.applyys" default="적용여부"/>'				, type: 'string'	, allowBlank: false, comboType: 'AU'	, comboCode: 'B131'},
			{name: 'REMARK'			, text: '<t:message code="system.label.base.remarks" default="비고"/>'				, type: 'string'},
			{name: 'STOCK_Q'		, text: '<t:message code="system.label.base.onhandstock" default="현재고"/>'			, type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'	, text: '<t:message code="system.label.base.onhandstock" default="현재고"/>'			, type: 'uniQty'}
		]
	});

	var masterStore = Unilite.createStore('s_bpr210ukrv_wmMasterStore',{
		model	: 's_bpr210ukrv_wmModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy	: directProxy,
		loadStoreRecords : function() {
			var param = panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
//			var toCreate	= this.getNewRecords();
//			var toUpdate	= this.getUpdatedRecords();
//			var toDelete	= this.getRemovedRecords();
			var inValidRecs	= this.getInvalidRecords();

			if(inValidRecs.length == 0 ) {
				if(config == null) {
					config = {
						success : function() {
							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);
						}
					};
				}
				this.syncAllDirect(config);
			} else {
				 masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
				}
			},
			write: function(proxy, operation){
				if (operation.action == 'destroy') {
//					Ext.getCmp('detailForm').reset();
				}
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
//				detailForm.setActiveRecord(record);
			},
			remove: function( store, records, index, isMove, eOpts ) {
				if(store.count() == 0) {
//					detailForm.clearForm();
//					detailForm.disable();
				}
			}
		},
		groupField: 'ITEM_GROUP'				//20201211 추가: 소계/합계 추가
	});

	var masterGrid = Unilite.createGrid('s_bpr210ukrv_wmGrid', {
		store	: masterStore,
		region	: 'center',
		sortableColumns : true,
		uniOpt	:{
			onLoadSelectFirst	: true,
			expandLastColumn	: true,
			useRowNumberer		: true,
			dblClickToEdit		: true,
			useMultipleSorting	: true
		},
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},	//20201211 추가: 소계/합계 추가
					{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns:[
			{dataIndex: 'COMP_CODE'		, width: 93		, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 93		, hidden: true},
			{dataIndex: 'ITEM_GROUP'	, width: 110	, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData) {							//20201211 추가: 소계/합계 추가
					return Unilite.renderSummaryRow(summaryData, metaData, '품목계', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'SORT_SEQ'		, width: 80		, align: 'center'},		//20201210 추가
			{dataIndex: 'ITEM_CODE'		, width: 120	,
				editor: Unilite.popup('DIV_PUMOK_G',{
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
				 	autoPopup		: true,
					listeners		: { 
						'onSelected': {
							fn: function(records, type){
								Ext.each(records, function(record,i) {
									if(i==0) {
										masterGrid.setItemData(record, false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record, false, masterGrid.getSelectedRecord());
									}
								});
//								var grdRecord = masterGrid.uniOpt.currentRecord;
//								grdRecord.set('ITEM_CODE'	,records[0]['ITEM_CODE']);
//								grdRecord.set('ITEM_NAME'	,records[0]['ITEM_NAME']);
//								grdRecord.set('SPEC'		,records[0]['SPEC']);
							},
							scope: this
						},
						'onClear' : function(type) {
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
//							var grdRecord = masterGrid.uniOpt.currentRecord;
//							grdRecord.set('ITEM_CODE'	,'');
//							grdRecord.set('ITEM_NAME'	,'');
//							grdRecord.set('SPEC'		,'');
						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'		, width: 150	,
				editor: Unilite.popup('DIV_PUMOK_G',{
				 	autoPopup: true,
					listeners:{ 
						'onSelected': {
							fn: function(records, type){
								Ext.each(records, function(record,i) {
									if(i==0) {
										masterGrid.setItemData(record, false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record, false, masterGrid.getSelectedRecord());
									}
								});
//								var grdRecord = masterGrid.uniOpt.currentRecord;
//								grdRecord.set('ITEM_CODE'	,records[0]['ITEM_CODE']);
//								grdRecord.set('ITEM_NAME'	,records[0]['ITEM_NAME']);
//								grdRecord.set('SPEC'		,records[0]['SPEC']);
							},
							scope: this
						},
						'onClear' : function(type) {
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
//							var grdRecord = masterGrid.uniOpt.currentRecord;
//							grdRecord.set('ITEM_CODE'	,'');
//							grdRecord.set('ITEM_NAME'	,'');
//							grdRecord.set('SPEC'		,'');
						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'SPEC'			, width: 120},
			{dataIndex: 'USE_YN'		, width: 100	, align: 'center'},
			{dataIndex: 'STOCK_Q'		, width: 100	, summaryType: 'sum'},			//STOCK_Q인지 GOOD_STOCK_Q인지 확인 필요, 20201211 수정: 소계/합계 추가
			{dataIndex: 'REMARK'		, width: 200}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['SPEC', 'GOOD_STOCK_Q', 'STOCK_Q'])){
					return false;
				}
				if (!e.record.phantom){
					if (UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE', 'ITEM_GROUP', 'ITEM_CODE', 'ITEM_NAME'])){
						return false;
					}
				}
			},
			selectionchangerecord:function(selected) {
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(!dataClear) {
				grdRecord.set('ITEM_CODE'	, record.ITEM_CODE);
				grdRecord.set('ITEM_NAME'	, record.ITEM_NAME);
				grdRecord.set('SPEC'		, record.SPEC);
				grdRecord.set('STOCK_Q'		, record.STOCK_Q);
			} else {
				grdRecord.set('ITEM_CODE'	, '');
				grdRecord.set('ITEM_NAME'	, '');
				grdRecord.set('SPEC'		, '');
				grdRecord.set('STOCK_Q'		, 0);
			}
		}
	});



	Unilite.Main({
		id			: 's_bpr210ukrv_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		}],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['newData'], true);
			this.setDefault();
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function () {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterStore.loadStoreRecords();
		},
		onNewDataButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			//상위행의 ITEM_GROUP 적용
			var itemGroup		= '';
			var selectedRecord	= masterGrid.getSelectedRecord();
			//20201210 수정: 체크로직 순서 바꿈
			if(!Ext.isEmpty(panelResult.getValue('ITEM_GROUP'))) {
				itemGroup = panelResult.getValue('ITEM_GROUP');
			} else if(!Ext.isEmpty(selectedRecord)) {
				itemGroup = selectedRecord.get('ITEM_GROUP');
			}
			masterStore.filterBy(function(record){
				return record.get('ITEM_GROUP') == itemGroup;
			});
			var seq = masterStore.max('SORT_SEQ');
			if(!seq) seq = 1;
			else  seq += 1;
			masterStore.clearFilter();

			var r = {
				COMP_CODE		: UserInfo.compCode,
				DIV_CODE		: panelResult.getValue('DIV_CODE'),
				ITEM_GROUP		: itemGroup,
				SORT_SEQ		: seq,
				USE_YN			: 'Y'
			};
			masterGrid.createRow(r, null, masterStore.getCount() - 1);
		},
		onDeleteDataButtonDown : function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom == true) {
				masterGrid.deleteSelectedRow();
			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {	//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				masterGrid.deleteSelectedRow();
			}
		},
		onSaveDataButtonDown: function () {
			//필수 입력값 체크
			if (!panelResult.getInvalidMessage()) { 
				return false;
			}
			masterStore.saveStore();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});


	//20201210 추가: 품목그룹 변경하면 순번 다시 채번
	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				//일단 주석
//				case "ITEM_GROUP":
//					if(newValue != oldValue) {
//						masterStore.filterBy(function(record){
//							return record.get('ITEM_GROUP') == newValue;
//						});
//						var seq = masterStore.max('SORT_SEQ');
//						if(!seq) seq = 1;
//						else seq += 1;
//						masterStore.clearFilter();
//						record.set('SORT_SEQ', seq);
//					}
//				break;

			}
			return rv;
		}
	});
};
</script>