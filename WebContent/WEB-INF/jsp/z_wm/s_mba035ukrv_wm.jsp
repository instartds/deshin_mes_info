<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mba035ukrv_wm">
	<t:ExtComboStore comboType="BOR120"/>									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>						<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>						<!-- 단위 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="s_mba035ukrv_wmLevel1Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="s_mba035ukrv_wmLevel2Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="s_mba035ukrv_wmLevel3Store"/>

	<style type="text/css">
		#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	</style>	
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type: 'uniTable', columns: 3},
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
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup) {
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),
		Unilite.popup('ITEM',{
			fieldLabel		: '<t:message code="system.label.purchase.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME'
		}),{
			fieldLabel	: ' ',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '<t:message code="system.label.purchase.nowapplyprice" default="현재적용단가"/>',
				name		: 'rdoSelect',
				inputValue	: 'C',
				width		: 100,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
				name		: 'rdoSelect',
				inputValue	: 'A',
				width		: 80
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					UniAppManager.app.onQueryButtonDown(newValue.rdoSelect);
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 2 0',
			colspan	: 2,
			items	: [{
				fieldLabel	: '<t:message code="system.label.purchase.itemgroup" default="품목분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_mba035ukrv_wmLevel1Store'),
				child		: 'ITEM_LEVEL2',
				width		: 210
			}, {
				fieldLabel	: '',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_mba035ukrv_wmLevel2Store'),
				child		: 'ITEM_LEVEL3',
				width		: 110
				
			 }, {
				fieldLabel	: '',
				name		: 'ITEM_LEVEL3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_mba035ukrv_wmLevel3Store'),
				width		: 110
			}]
		}]
	});



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_mba035ukrv_wmService.selectList',
			update	: 's_mba035ukrv_wmService.updateList',
			create	: 's_mba035ukrv_wmService.insertList',
			destroy	: 's_mba035ukrv_wmService.deleteList',
			syncAll	: 's_mba035ukrv_wmService.saveAll'
		}
	});

	Unilite.defineModel('s_mba035ukrv_wmModel', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'	, comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		, type: 'string'	, allowBlank: false},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		, type: 'string'	, comboType: 'AU'	, comboCode: 'B013'	, displayField: 'value'},
			{name: 'UNIT_PRICE'		, text: '판매단가'		, type: 'uniUnitPrice'	, allowBlank: false},
			{name: 'AVAILABLE_QTY'	, text: '가능수량'		, type: 'uniQty'		, allowBlank: true},
			{name: 'COMPLETE_QTY'	, text: '판매수량'		, type: 'uniQty'		, allowBlank: true},
			{name: 'START_DATE'		, text: '<t:message code="system.label.purchase.applystartdate" default="적용시작일"/>'	, type: 'uniDate'	, allowBlank: false},
			{name: 'END_DATE'		, text: '<t:message code="system.label.purchase.applyenddate" default="적용종료일"/>'	, type: 'uniDate'	, allowBlank: false},
			{name: 'GOODS_CODE'		, text: '상품코드'		, type: 'string'},
			{name: 'REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'}
		]
	});

	var masterStore = Unilite.createStore('s_mba035ukrv_wmMasterStore',{
		model	: 's_mba035ukrv_wmModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy	: directProxy,
		loadStoreRecords: function(rdoSelect) {
			var param = Ext.getCmp('resultForm').getValues();
			if(!Ext.isEmpty(rdoSelect)) {
				param.rdoSelect = rdoSelect;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore: function(config) {
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0) {
				if(config == null) {
					config = {success : function() {
						masterStore.loadStoreRecords();
					}};
				}
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)) {
				}
			},
			write: function(proxy, operation) {
//				if(operation.action == 'destroy') {
//					Ext.getCmp('detailForm').reset();
//				}
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts) {
//				detailForm.setActiveRecord(record);
			},
			remove: function( store, records, index, isMove, eOpts) { 
//				if(store.count() == 0) {
//					detailForm.clearForm();
//					detailForm.disable();
				}
//			}
		}
	});

	var masterGrid = Unilite.createGrid('s_mba035ukrv_wmGrid', {
		store	: masterStore,
		region	: 'center',
		flex	: 1,
		sortableColumns : true,
		uniOpt	:{
			onLoadSelectFirst	: true,
			expandLastColumn	: true,
			useRowNumberer		: true,
			dblClickToEdit		: true,
			useMultipleSorting	: true
		},
		columns:[
			{dataIndex: 'COMP_CODE'		, width: 93	, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 93	, hidden: true},
			{dataIndex: 'CUSTOM_CODE'	, width: 100,
				'editor': Unilite.popup('AGENT_CUST_G',{
					textFieldName	: 'CUSTOM_CODE',
					DBtextFieldName	: 'CUSTOM_CODE',
					allowBlank		: false,
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE', '');
							grdRecord.set('CUSTOM_NAME', '');
						},
						'applyextparam': function(popup) {
							popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
							popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
						}
					}
				})
			},
			{dataIndex: 'CUSTOM_NAME'	, width: 133,
				'editor': Unilite.popup('AGENT_CUST_G',{
					allowBlank		: false,
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE', '');
							grdRecord.set('CUSTOM_NAME', '');
						},
						'applyextparam': function(popup) {
							popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
							popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
						}
					}
				})
			},
			{dataIndex: 'ITEM_CODE'		, width: 100,
				'editor': Unilite.popup('DIV_PUMOK_G',{
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE'	, records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME'	, records[0]['ITEM_NAME']);
								grdRecord.set('SPEC'		, records[0]['SPEC']);
								grdRecord.set('ORDER_UNIT'	, records[0]['ORDER_UNIT']);
							},
							scope: this
						},
						'onClear' : function(type)  {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'	,'');
							grdRecord.set('ITEM_NAME'	,'');
							grdRecord.set('SPEC'		,'');
							grdRecord.set('ORDER_UNIT'	,'');
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'		, width: 133,
				'editor': Unilite.popup('DIV_PUMOK_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE'	, records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME'	, records[0]['ITEM_NAME']);
								grdRecord.set('SPEC'		, records[0]['SPEC']);
								grdRecord.set('ORDER_UNIT'	, records[0]['ORDER_UNIT']);
							},
							scope: this
						},
						'onClear' : function(type)  {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'	,'');
							grdRecord.set('ITEM_NAME'	,'');
							grdRecord.set('SPEC'		,'');
							grdRecord.set('ORDER_UNIT'	,'');
						}
					}
				})
			},
			{dataIndex: 'SPEC'			, width: 93},
			{dataIndex: 'ORDER_UNIT'	, width: 93	, align: 'center'},
			{dataIndex: 'UNIT_PRICE'	, width: 100},
			{dataIndex: 'AVAILABLE_QTY'	, width: 100},
			{dataIndex: 'COMPLETE_QTY'	, width: 100},
			{dataIndex: 'START_DATE'	, width: 100},
			{dataIndex: 'END_DATE'		, width: 100},
			{dataIndex: 'GOODS_CODE'	, width: 110},
			{dataIndex: 'REMARK'		, width: 250}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if(UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE', 'CUSTOM_CODE', 'CUSTOM_NAME', 'ITEM_CODE', 'ITEM_NAME', 'ORDER_UNIT', 'START_DATE'])) {
						return false;
					}
				}
				if(UniUtils.indexOf(e.field, ['SPEC'])) {
					return false;
				}
			},
			selectionchangerecord:function(selected) {
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
//				if(!record.phantom) {
//					switch(colName) {
//					case 'ITEM_CODE' :
//							masterGrid.hide();
//							break;
//					default:
//							break;
//					}
//				}
			}
		}
	});
	
	
	
	
	Unilite.Main({
		id			: 's_mba035ukrv_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		}],
		fnInitBinding : function(params) {
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');
			this.setDefault();
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('rdoSelect', 'C');

			UniAppManager.setToolbarButtons(['newData'], true);
		},
		onQueryButtonDown: function (rdoSelect) {
			if(!this.isValidSearchForm()) {
				return false;
			}
			masterStore.loadStoreRecords(rdoSelect);
		},
		onNewDataButtonDown : function() {
			var r = {
				COMP_CODE	: UserInfo.compCode,
				DIV_CODE	: panelResult.getValue('DIV_CODE'),
				START_DATE	: new Date(),
				END_DATE	: '29991231'
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
		onSaveDataButtonDown: function (config) {
			if(!panelResult.getInvalidMessage()) {					//필수 입력값 체크
				return false;
			}
			masterStore.saveStore(config);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterStore.clearData();
			this.fnInitBinding();
		}
	});



	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
//			console.log('validate >>> ', {'type': type, 'fieldName': fieldName, 'newValue': newValue, 'oldValue': oldValue, 'record': record});
			var rv = true;
			switch(fieldName) {
				case "START_DATE" :	// 적용 시작일
					var startDate = UniDate.getDbDateStr(newValue);
					if(startDate.length == 8) {
						if(!Ext.isEmpty(record.get('END_DATE'))) {
							var endDate = UniDate.getDbDateStr(record.get('END_DATE'));
							if(startDate > endDate) {
								rv = '<t:message code="system.message.purchase.message098" default="적용 시작일은 종료일 보다 늦을 수 없습니다."/>';
							}
						}
					}
				break;
				
				case "END_DATE" :		// 적용 종료일
					var endDate = UniDate.getDbDateStr(newValue);
					if(endDate.length == 8) {
						var startDate = UniDate.getDbDateStr(record.get('START_DATE'));
						if(endDate < startDate) {
							rv = '<t:message code="system.message.purchase.message099" default="적용 종료일은 시작일 보다 빠를 수 없습니다."/>';
						}
					}
				break;
			}
			return rv;
		}
	})
};
</script>