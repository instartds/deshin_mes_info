<%--
'	프로그램명 : 출하예정표등록 (srq210ukrv)
'	작   성   자 : 시너지시스템즈 개발실
'	작   성   일 :
'	최종수정자 :
'	최종수정일 :
'	버	 전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="srq210ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="srq210ukrv" />		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />				<!-- 판매단위-->
	<t:ExtComboStore comboType="AU" comboCode="B139" />				<!-- 포장박스형태-->
</t:appConfig>

<style type="text/css">
.x-grid-cell-essential {background-color:yellow;}
.search-hr {height: 1px;}
</style>

<script type="text/javascript">



var outDivCode = UserInfo.divCode;

function appMain() {
	// Direct Proxy 정의
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'srq210ukrvService.selectList',
			update	: 'srq210ukrvService.updateDetail',
			create	: 'srq210ukrvService.insertDetail',
			destroy	: 'srq210ukrvService.deleteDetail',
			syncAll	: 'srq210ukrvService.saveAll'
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
			hodable		: 'hold',
			allowBlank	: false,
			colspan		: 2,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>' ,
//			validateBlank	: false,		//20210325 주석: 고객과 협의
			allowBlank		: false,		//20210325 추가
			listeners		: {
				//20200102 로직 추가
				onValueFieldChange: function(field, newValue){
					if(Ext.isEmpty(newValue)) {
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue){
					if(Ext.isEmpty(newValue)) {
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.estimatedshipmentdate" default="출하예정일"/>',
			name		: 'ISSUE_PLAN_DATE',
			xtype		: 'uniDatefield',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				blur : function (e, event, eOpts) {
				}
			}
		},{
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
	Unilite.defineModel('srq210ukrvModel', {
		fields: [
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string'	, comboType: 'BOR120', defaultValue: UserInfo.divCode},
			{name: 'ISSUE_PLAN_NUM'	, text: '<t:message code="system.label.sales.estimatedshipmentno" default="출하예정번호"/>'	, type: 'string'	, editable: false},
			{name: 'ISSUE_PLAN_DATE', text: '<t:message code="system.label.sales.estimatedshipmentdate" default="출하예정일"/>'	, type: 'uniDate'	, allowBlank: false},
			{name: 'SEQ'			, text: '순번'					, type: 'int'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'	, allowBlank: false},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				, type: 'string'	, allowBlank: false},
			{name: 'DVRY_CUST_CD'	, text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			, type: 'string'	, allowBlank: false},
			{name: 'DVRY_CUST_NAME'	, text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			, type: 'string'	, allowBlank: false},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.sales.itemnamespec" default="품명(규격)"/>'			, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.sales.unit" default="단위"/>'						, type: 'string'	, comboType: 'AU', comboCode: 'B013', displayField: 'value'},
			//20200103 추가: 현재고량
			{name: 'STOCK_Q'		, text: '<t:message code="system.label.sales.onhandqty" default="현재고량"/>'				, type: 'uniQty'},
			{name: 'ISSUE_PLAN_QTY'	, text: '<t:message code="system.label.sales.estimatedshipment" default="출하예정량"/>'		, type: 'uniQty'},
			{name: 'BOX_TYPE'		, text: '<t:message code="system.label.sales.boxtype" default="BOX 종류"/>'				, type: 'string'	, comboType: 'AU', comboCode: 'B139', displayField: 'value'},
			//20200102 입수 정수로 입력 / 표현 
			{name: 'TRNS_RATE'		, text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				, type: 'int'},
			{name: 'BOX_QTY'		, text: '<t:message code="system.label.sales.boxqty2" default="용기수"/>'					, type: 'int'},
			{name: 'CAR_TYPE'		, text: '<t:message code="system.label.common.cartype" default="차종"/>'					, type: 'string'},	
			{name: 'LABEL_INDEX'	, text: '<t:message code="system.label.sales.componentidentifier" default="부품식별표"/>'	, type: 'string'},
			{name: 'REMARK'			, text: '<t:message code="system.label.sales.remarks" default="비고"/>'					, type: 'string'},
			{name: 'ORDER_YN'		, text: 'ORDER_YN'	, type: 'string'},
			{name: 'DATA_KIND'		, text: 'DATA_KIND'	, type: 'string'},
			//20200121 추가: 
			{name: 'USE_YN'			, text: 'USE_YN'	, type: 'string'},
			//20210325 추가: 입력한 순서대로 보여주기 위해
			{name: 'SAVE_IDX'		, text: 'SAVE_IDX'	, type: 'int'	, editable: false}
		]
	});

	//마스터 스토어 정의
	var detailStore = Unilite.createStore('srq210ukrvDetailStore', {
		model	: 'srq210ukrvModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
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
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var err_flag	= false;
			//20200121 추가
			var list		= [].concat(toUpdate, toCreate);
			Ext.each(list, function(record,i) {
				if(Ext.isEmpty(record.get('ISSUE_PLAN_NUM')) && record.get('ISSUE_PLAN_QTY') == 0) {
					Unilite.messageBox('<t:message code="system.label.sales.estimatedshipment" default="출하예정량"/>:<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					err_flag = true;
					return false;
				}
				if(record.get('USE_YN') == 'N') {
					Unilite.messageBox('<t:message code="system.message.sales.message147" default="사용정지 품목입니다."/> ' + '<t:message code="system.label.sales.itemcode" default="품목코드"/>:' + record.get('ITEM_CODE'));
					err_flag = true;
					return false;
				}
			});
			//20210325 추가: 저장한 화면 그대로 보여주기 위해 추가
			detailStore.filterBy(function(record){
				return !Ext.isEmpty(record.get('ISSUE_PLAN_NUM'))
			})
			var queryData	= detailStore.data.items;
			detailStore.clearFilter();
			var list2		= [].concat(list, queryData);
			Ext.each(list2, function(record,i) {
				record.set('SAVE_IDX', detailStore.indexOf(record));
			});
			if(err_flag) {
				return false;
			}

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

						//20200122 주석
//						if(detailStore.getCount() == 0){
//							UniAppManager.app.onResetButtonDown();
//						} else {
//							UniAppManager.app.onQueryButtonDown();
//						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('srq210ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
// 				if (records.length > 0){
// 					panelResult.getField('DIV_CODE').setReadOnly(true);
// 					panelResult.getField('ISSUE_PLAN_DATE').setReadOnly(true);
// 				} else {
// 					panelResult.getField('DIV_CODE').setReadOnly(false);
// 					panelResult.getField('ISSUE_PLAN_DATE').setReadOnly(false);
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
	var detailGrid = Unilite.createGrid('srq210ukrvGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer	: true,
			//20200121 추가
			copiedRow		: true
		},
		tbar	: [],
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
//			{dataIndex: 'SAVE_IDX'			, width: 100	, hidden: false},	//20210325 추가
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'ISSUE_PLAN_NUM'	, width: 100	, hidden: true},
			{dataIndex: 'ISSUE_PLAN_DATE'	, width: 100	, hidden: true},
			{dataIndex: 'SEQ'	, width: 100	, hidden: true},
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
			//20200103 추가: 현재고량
			{dataIndex: 'STOCK_Q'			, width: 100},
			{dataIndex: 'ISSUE_PLAN_QTY'	, width: 100,
				//20190102 컬럼 색상 추가: 노랑색
				renderer: function(value, meta, record) {
				 		meta.tdCls = 'x-grid-cell-essential';
				 	return value;
				}
			},
			{dataIndex: 'BOX_TYPE'			, width: 80},
			{dataIndex: 'TRNS_RATE'			, width: 80},
			{dataIndex: 'BOX_QTY'			, width: 80},
			{dataIndex: 'CAR_TYPE'			, width: 150},
			{dataIndex: 'LABEL_INDEX'		, width: 100},
			{dataIndex: 'REMARK'			, width: 120},
			{dataIndex: 'ORDER_YN'			, width: 80		, hidden: true},
			{dataIndex: 'DATA_KIND'			, width: 80		, hidden: true}
		],
		listeners: {
			//20200121 추가
			beforePasteRecord: function(rowIndex, record) {
				record.ISSUE_PLAN_NUM	= '';
				record.ISSUE_PLAN_QTY	= 0;
				record.DATA_KIND		= 'N';
				return true;
			},
			afterPasteRecord: function(rowIndex, record) {
			},
			beforeedit: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field,['CUSTOM_CODE', 'CUSTOM_NAME', 'DVRY_CUST_CD'/*, 'DVRY_CUST_NAME'*/, 'ITEM_CODE'
											, 'ITEM_NAME', 'SPEC', 'ORDER_UNIT', 'ORDER_YN'])){
					return false;
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
		id			: 'srq210ukrvApp',
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
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('ISSUE_PLAN_DATE'	, UniDate.get('tomorrow'));
			panelResult.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if (!panelResult.getInvalidMessage()) {
				return false;
			}
			detailStore.loadStoreRecords();
		},
/*		onNewDataButtonDown: function() {
			if (!panelResult.getInvalidMessage()) {
				return false;
			}
			var r = {
				DIV_CODE : Ext.isEmpty(panelResult.getValue('DIV_CODE')) ? UserInfo.divCode : panelResult.getValue('DIV_CODE')
			};
			detailGrid.createRow(r);
		},*/
		onResetButtonDown: function() {
			panelResult.getField('DIV_CODE').setReadOnly(false);
			panelResult.getField('ISSUE_PLAN_DATE').setReadOnly(false);

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
				case "ISSUE_PLAN_QTY":
					if(newValue < 0) {
						rv= '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('ISSUE_PLAN_QTY', oldValue);
						break
					}
//					if(record.get('DATA_KIND') == 'N' && newValue == 0) {
//						rv= '<t:message code="system.label.sales.estimatedshipment" default="출하예정량"/>:<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>';
//						record.set('ISSUE_PLAN_QTY', oldValue);
//						break
//					}
					record.set('BOX_QTY', Math.ceil(newValue / record.get('TRNS_RATE')));
				break;

				case "TRNS_RATE":
					if(newValue <= 0) {
						rv= '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('TRNS_RATE', oldValue);
						break
					}
					record.set('BOX_QTY', Math.ceil(record.get('ISSUE_PLAN_QTY') / newValue));
				break;

				case "BOX_QTY":
					if(newValue <= 0) {
						rv= '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('BOX_QTY', oldValue);
						break
					}
					if(newValue < Math.ceil(record.get('ISSUE_PLAN_QTY') / record.get('TRNS_RATE'))) {
						rv= '<t:message code="system.message.sales.message145" default="용기수(은)는 출하예정량 / 입수 보다 작을 수 없습니다."/>';
						record.set('BOX_QTY', oldValue);
						break
					}
				break;
			}
			return rv;
		}
	});
}
</script>