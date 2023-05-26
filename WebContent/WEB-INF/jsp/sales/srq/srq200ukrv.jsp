<%--
'	프로그램명 : 거래처출하품목등록 (srq200ukrv)
'	작   성   자 : 시너지시스템즈 개발실
'	작   성   일 :
'	최종수정자 :
'	최종수정일 :
'	버	 전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="srq200ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="srq200ukrv" />		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />				<!-- 판매단위-->
	<t:ExtComboStore comboType="AU" comboCode="B139" />				<!-- 포장박스형태-->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>

<script type="text/javascript">



var outDivCode = UserInfo.divCode;

function appMain() {
	// Direct Proxy 정의
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'srq200ukrvService.selectList',
			update	: 'srq200ukrvService.updateDetail',
			create	: 'srq200ukrvService.insertDetail',
			destroy	: 'srq200ukrvService.deleteDetail',
			syncAll	: 'srq200ukrvService.saveAll'
		}
	});


	/** 마스터 정보를 가지고 있는 Form
	 */
	var panelResult = Unilite.createSearchForm('panelResult',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			colspan		: 2,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelResult.setValue('WH_CODE', '');
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>' ,
			validateBlank	: false,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				}/*,
				onValueFieldChange: function(field, newValue){
					panelResult.setValue('CUSTOM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelResult.setValue('CUSTOM_NAME', newValue);
				}*/
			}
		}),
		Unilite.popup('DELIVERY',{
			fieldLabel		: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>',
			valueFieldName	: 'DELIVERY_CODE',
			textFieldName	: 'DELIVERY_NAME',
			showValue		: false,
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.itemnamespec" default="품명(규격)"/>',
			name		: 'SPEC',
			xtype		: 'uniTextfield'
		},{
			fieldLabel	: '<t:message code="system.label.sales.remarks" default="비고"/>',
			name		: 'REMARK',
			xtype		: 'uniTextfield'
		}],
		listeners: {
		}
	}); //End of var panelResult = Unilite.createForm('srq101ukrvpanelResult', {



	//마스터 모델 정의
	Unilite.defineModel('srq200ukrvModel', {
		fields: [
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string'	, comboType: 'BOR120', defaultValue: UserInfo.divCode},
			{name: 'SEQ'			, text: '순번'																			, type: 'int'	},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'	, allowBlank: false},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				, type: 'string'	, allowBlank: false},
			{name: 'DVRY_CUST_CD'	, text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			, type: 'string'	},
			{name: 'DVRY_CUST_NAME'	, text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			, type: 'string'	},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.sales.itemnamespec" default="품명(규격)"/>'			, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.sales.unit" default="단위"/>'						, type: 'string'	, comboType: 'AU', comboCode: 'B013', displayField: 'value'},
			//20200102 입수 정수로 입력 / 표현 
			{name: 'TRNS_RATE'		, text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				, type: 'int'},
			{name: 'BOX_TYPE'		, text: '<t:message code="system.label.sales.boxtype" default="BOX 종류"/>'				, type: 'string'	, comboType: 'AU', comboCode: 'B139'},
			{name: 'CAR_TYPE'		, text: '<t:message code="system.label.common.cartype" default="차종"/>'					, type: 'string'},	
			{name: 'LABEL_INDEX'	, text: '<t:message code="system.label.sales.componentidentifier" default="부품식별표"/>'	, type: 'string'},
			//20200121 추가: SORT_SEQ
			{name: 'SORT_SEQ'		, text: '<t:message code="system.label.sales.arrangeorder" default="정렬순서"/>'			, type: 'int'},
			{name: 'REMARK'			, text: '<t:message code="system.label.sales.remarks" default="비고"/>'					, type: 'string'},
			{name: 'ORDER_YN'		, text: 'ORDER_YN'	, type: 'string'}
		]
	});

	//마스터 스토어 정의
	var detailStore = Unilite.createStore('srq200ukrvDetailStore', {
		model	: 'srq200ukrvModel',
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
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();

						//3.기타 처리
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
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('srq200ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
// 				if (records.length > 0){
// 				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	//마스터 그리드 정의
	var detailGrid = Unilite.createGrid('srq200ukrvGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer	: true
		},
		tbar	: [],
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 110,
				'editor' : Unilite.popup('AGENT_CUST_G',{
					textFieldName	: 'CUSTOM_NAME',
					DBtextFieldName	: 'CUSTOM_NAME',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
							popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
						}
					}
				})
			},
			{dataIndex: 'CUSTOM_NAME'		, width: 150,
				editor: Unilite.popup('AGENT_CUST_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SALE_CUST_CD','');
							grdRecord.set('CUSTOM_NAME','');
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
							popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
						}
					}
				})
			},
			{dataIndex: 'DVRY_CUST_CD'		, width: 110, hidden: true},
			{dataIndex: 'DVRY_CUST_NAME'	, width: 110,
				editor: Unilite.popup('DELIVERY_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('DVRY_CUST_CD'	, records[0]['DELIVERY_CODE']);
								grdRecord.set('DVRY_CUST_NAME'	, records[0]['DELIVERY_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('DVRY_CUST_CD'	, '');
								grdRecord.set('DVRY_CUST_NAME'	, '');
						},
						applyextparam: function(popup){
							var grdRecord = detailGrid.uniOpt.currentRecord;
							popup.setExtParam({'CUSTOM_CODE': grdRecord.get('CUSTOM_CODE')});
						}
					}
				})
			},
			{dataIndex: 'ITEM_CODE'			, width: 110,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
									}
								});
							},
						scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var record = detailGrid.getSelectedRecord();
							var divCode = record.get('DIV_CODE');
							popup.setExtParam({/*'SELMODEL': 'MULTI', */'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({multiSelectItemAccount: true}); //20181224 폼목계정 상품, 제품 고정값 임시 해제, 유양은 반제품도 수주 함
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 150/*,
				editor: Unilite.popup('DIV_PUMOK_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
									}
								});
							},
							scope: this
							},
						'onClear': function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var record = detailGrid.getSelectedRecord();
							var divCode = record.get('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({multiSelectItemAccount: true}); //20181224 폼목계정 상품, 제품 고정값 임시 해제, 유양은 반제품도 수주 함
						}
					}
				})
			*/},
			{dataIndex: 'SPEC'				, width: 130},
			{dataIndex: 'ORDER_UNIT'		, width: 80		, align: 'center'},
			{dataIndex: 'TRNS_RATE'			, width: 80},
			{dataIndex: 'BOX_TYPE'			, width: 80},
			{dataIndex: 'CAR_TYPE'			, width: 150},
			{dataIndex: 'LABEL_INDEX'		, width: 100},
			//20200121 추가: SORT_SEQ
			{dataIndex: 'SORT_SEQ'			, width: 70		, align: 'center'},
			{dataIndex: 'REMARK'			, width: 120},
			{dataIndex: 'ORDER_YN'			, width: 80		, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom) {
					if (UniUtils.indexOf(e.field,['ITEM_NAME', 'SPEC', 'ORDER_UNIT', 'ORDER_YN'])){
							return false;
					}
				} else {
					if (UniUtils.indexOf(e.field,['CUSTOM_CODE', 'CUSTOM_NAME', 'ITEM_CODE', 'ITEM_NAME', 'SPEC' ])){
						return false;
					}
				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'	, '');
				grdRecord.set('ITEM_NAME'	, '');
				grdRecord.set('SPEC'		, '');
				grdRecord.set('ORDER_UNIT'	, '');
				grdRecord.set('TRNS_RATE'	, 0);
				
			} else {
				grdRecord.set('ITEM_CODE'	, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'	, record['ITEM_NAME']);
				grdRecord.set('SPEC'		, record['SPEC']);
				grdRecord.set('ORDER_UNIT'	, record['ORDER_UNIT']);
				grdRecord.set('TRNS_RATE'	, record['PUR_TRNS_RATE']);
				
			}
		}
	});




	Unilite.Main({
		id			: 'srq200ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid
			]
		}],
		fnInitBinding: function(params) {
			this.setDefault();
		},
		setDefault: function() {
			UniAppManager.setToolbarButtons(['newData'], true);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if (!panelResult.getInvalidMessage()) {
				return false;
			}
			detailStore.loadStoreRecords();
		},
		onNewDataButtonDown: function() {
			if (!panelResult.getInvalidMessage()) {
				return false;
			}
			var r = {
				DIV_CODE	: Ext.isEmpty(panelResult.getValue('DIV_CODE')) ? UserInfo.divCode : panelResult.getValue('DIV_CODE'),
				TRNS_RATE	: 1
			};
			detailGrid.createRow(r);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			detailStore.loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			} else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				detailGrid.deleteSelectedRow();
			}
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
				case "TRNS_RATE":
					if(newValue <= 0) {
						rv= '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('TRNS_RATE', oldValue);
						break
					}
				break;
			}
			return rv;
		}
	});
}
</script>