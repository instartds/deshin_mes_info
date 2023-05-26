<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pbs405ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="pbs405ukrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="W"/>							<!-- 작업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('DIV_CODE', newValue);
					progWordComboStore.loadStoreRecords();
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'W',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_SHOP_CODE',newValue);
				},
				beforequery:function( queryPlan, eOpts )   {
					var store = queryPlan.combo.store;
					var prStore = panelResult.getField('WORK_SHOP_CODE').store;
					store.clearFilter();
					prStore.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
						prStore.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
					}else{
						store.filterBy(function(record){
							return false;
						});
						prStore.filterBy(function(record){
							return false;
						});
					}
				}
			}
		}]
	});


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'pbs405ukrvService.selectList',
			create	: 'pbs405ukrvService.insertList',
			update	: 'pbs405ukrvService.updateList',
			destroy	: 'pbs405ukrvService.deleteList',
			syncAll	: 'pbs405ukrvService.saveAll'
		}
	});


	var progWordComboStore = new Ext.data.Store({
		storeId: 'pbs405ukrvProgWordComboStore',
		fields	: ['value', 'text','refCode1','option'],
		//autoLoad: true,
		proxy: {
			type: 'direct',
			api: {
				 read: 'UniliteComboServiceImpl.getProgWorkCode'
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
					if(successful)  {
					}
			}
		},
		loadStoreRecords: function(records)	{
			var param= panelResult.getValues();
			param.WKORD_NUM = '';
			console.log(param);
			this.load({
				params : param
			});
		}
	});


	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('pbs405ukrvModel', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string', allowBlank: false, comboType:'W'},
			{name: 'EQU_CODE'			, text: '설비'				, type: 'string' , allowBlank: false, editable:false},
			{name: 'EQU_NAME'			, text: '생산설비'				, type: 'string' , allowBlank: false},
			{name: 'PROG_WORK_CODE'		, text: '공정'				, type: 'string' , store: Ext.data.StoreManager.lookup('pbs405ukrvProgWordComboStore') , allowBlank: false},
			{name: 'USE_YN' 			, text: '사용여부' 			, type: 'boolean'},
			{name: 'DISP_SEQ'			, text: '순번'				, type: 'string'},
			{name: 'DISP_RATE'			, text: '배부율'				, type: 'uniPercent'},
			{name: 'BATCH_PRODT_YN'		, text: 'Batch 적용여부' 		, type: 'boolean'},	// 2021.07.01 컬럼추가(Batch 적용여부)
			{name: 'MULTI_PRODT_CT'		, text: '연속C/T(분)'			, type: 'uniQty'},
			{name: 'STD_MEN'			, text: '기준인원'				, type: 'uniQty' , allowBlank: false},
			{name: 'STD_PRODT_Q'		, text: '적정생산LOT'			, type: 'uniQty' , allowBlank: false},
			{name: 'NET_UPH'			, text: 'UPH'				, type: 'uniQty' , allowBlank: false},
			{name: 'NET_MH_M'			, text: 'MH(분)'				, type: 'uniQty'},
			{name: 'NET_MH_S'			, text: 'MH(초)'				, type: 'uniQty'},
			{name: 'NET_CT_M'			, text: 'C/T(분)'			, type: 'uniQty'},
			{name: 'NET_CT_S'			, text: 'C/T(초)'			, type: 'uniQty'},
			{name: 'ACT_SET_M'			, text: '준비(분)'			, type: 'uniQty'},
			{name: 'ACT_OUT_M'			, text: '정리(분)'			, type: 'uniQty'},
			{name: 'ACT_UP_RATE'		, text: '여유율(%)'			, type: 'uniPercent'},
			{name: 'ACT_MH_M'			, text: 'MH(분)'				, type: 'uniQty'},
			{name: 'ACT_MH_S'			, text: 'MH(초)'				, type: 'uniQty'},
			{name: 'ACT_CT_M'			, text: 'C/T(분)'			, type: 'uniQty'},
			{name: 'ACT_CT_S'			, text: 'C/T(초)'			, type: 'uniQty'},
			{name: 'ACT_UPH'			, text: 'UPH'				, type: 'uniQty'},
			{name: 'ACT_UPH_M'			, text: 'UPH/Man'			, type: 'uniQty'},
			{name: 'REMARK'				, text: '비고	'				, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('pbs405ukrvMasterStore1',{
		model	: 'pbs405ukrvModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function() {
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function(config) {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate = this.getNewRecords();		// 추가
			var toUpdate = this.getUpdatedRecords();	// 수정
			var toDelete = this.getRemovedRecords();	// 삭제
			var list = [].concat(toCreate, toUpdate, toDelete);

				Ext.each(list, function(record,index) {
				// 저장 전처리 로직
					record.data.USE_YN = record.data.USE_YN == true ? 'Y' : 'N';
					record.data.BATCH_PRODT_YN = record.data.BATCH_PRODT_YN == true ? 'Y' : 'N';
				});

			if(inValidRecs.length == 0) {
				if(config == null) {
					config = {success : function() {
						directMasterStore1.loadStoreRecords();
					}};
				}
				this.syncAllDirect(config);
			} else {
				 masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
				}
			},
			 add: function(proxy, operation) {
				if (operation.action == 'destroy') {
				}
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {

			},
			remove: function(store, record, index, isMove, eOpts) {
				if(store.count() == 0) {
				}
			}
		}
	});


	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('pbs405ukrvGrid1', {
		store	: directMasterStore1,
		region	: 'center' ,
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn	: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useRowNumberer		: true//,
//			filter				: {
//				useFilter	: true,
//				autoCreate	: true
//			}
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [
			{dataIndex: 'DIV_CODE'			, width:80, hidden: true, locked: false},
			{dataIndex: 'WORK_SHOP_CODE'	, width:110, locked: false,
				listeners:{
					render:function(elm) {
						elm.editor.on('beforequery',function(queryPlan, eOpts) {
							var store = queryPlan.combo.store;
							var record = masterGrid1.uniOpt.currentRecord;
							store.clearFilter();
							store.filterBy(function(item){
								return item.get('option') == record.get('DIV_CODE')
							})
						})
					}
				}
			},
			{dataIndex: 'EQU_CODE'			, width:100 , locked: false},
			{dataIndex: 'EQU_NAME'			, width:130 , locked: false
				,editor : Unilite.popup('EQU_MACH_CODE_G',{
					textFieldName	: 'EQU_MACH_NAME',
					DBtextFieldName	: 'EQU_MACH_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid1.uniOpt.currentRecord;
								grdRecord.set('EQU_CODE'		,records[0]['EQU_MACH_CODE']);
								grdRecord.set('EQU_NAME'		,records[0]['EQU_MACH_NAME']);
								grdRecord.set('WORK_SHOP_CODE'	,records[0]['WORK_SHOP_CODE']);
								grdRecord.set('PROG_WORK_CODE'	,records[0]['PROG_WORK_CODE']);
							},
						scope: this
						},
						'onClear': function(type) {
							grdRecord = masterGrid1.getSelectedRecord();
							grdRecord.set('EQU_CODE'		, '');
							grdRecord.set('EQU_NAME'		, '');
							grdRecord.set('WORK_SHOP_CODE'	, '');
							grdRecord.set('PROG_WORK_CODE'	, '');

						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({/*'SELMODEL': 'MULTI',*/ 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': divCode});
						}
					}
				})
			},
			{dataIndex: 'PROG_WORK_CODE'	, width:110, locked: false,
				listeners:{
					render:function(elm) {
						var tGrid = elm.getView().ownerGrid;
						var progWordComboStore ;
						elm.editor.on('beforequery',function(queryPlan, eOpts)  {
						 progWordComboStore = queryPlan.combo.store;
						})
					}
				}
			},
			{dataIndex: 'USE_YN' 			, width:100, xtype: 'checkcolumn', align:'center', locked: false},
			{dataIndex: 'DISP_SEQ' 			, width:80},
			{dataIndex: 'DISP_RATE'			, width:150, hidden: true},
			{text: 'Batch생산',
				columns:[
					{dataIndex: 'BATCH_PRODT_YN'	, width:120, xtype: 'checkcolumn', align: 'center'},	//2021.07.01 컬럼추가(BATCH적용여부)
					{dataIndex: 'MULTI_PRODT_CT'	, width:150, hidden:false}
				]
			},
			{dataIndex: 'STD_MEN'			, width:120},
			{dataIndex: 'STD_PRODT_Q'		, width:120},
			{text: '순투입',
				columns:[
					{dataIndex: 'NET_UPH'			, width:100},
					{dataIndex: 'NET_MH_M'			, width:100},
					{dataIndex: 'NET_MH_S'			, width:100},
					{dataIndex: 'NET_CT_M'			, width:100},
					{dataIndex: 'NET_CT_S'			, width:100}
				]
			},
			{text: '실투입',
				columns:[
					{dataIndex: 'ACT_SET_M'			, width:100},
					{dataIndex: 'ACT_OUT_M'			, width:100},
					{dataIndex: 'ACT_UP_RATE'		, width:100},
					{dataIndex: 'ACT_MH_M'			, width:100},
					{dataIndex: 'ACT_MH_S'			, width:100},
					{dataIndex: 'ACT_CT_M'			, width:100},
					{dataIndex: 'ACT_CT_S'			, width:100},
					{dataIndex: 'ACT_UPH'			, width:100},
					{dataIndex: 'ACT_UPH_M'			, width:100}
				]
			},
			{dataIndex: 'REMARK'			, width:150}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (e.record.phantom){
					if (UniUtils.indexOf(e.field, ['WORK_SHOP_CODE'])) {
						return false;
					} else {
						return true;
					}
//					return true;
				} else {
					if (UniUtils.indexOf(e.field, ['DISP_SEQ','MULTI_PRODT_CT','STD_MEN','STD_PRODT_Q','NET_UPH','ACT_SET_M','ACT_OUT_M','ACT_UP_RATE','REAMARK'])) {
						return true;
					} else {
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
			if(dataClear) {
				grdRecord.set('SPEC'		,'');
				grdRecord.set('ORDER_UNIT'	,'');
			} else {
				grdRecord.set('SPEC'		,record['SPEC']);
				grdRecord.set('ORDER_UNIT'	,record['ORDER_UNIT']);
			}
		}
	});

	Unilite.Main({
		id			: 'pbs405ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid1, panelResult
			]
		}],
		fnInitBinding: function() {
			this.setDefault();
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}else{
				masterGrid1.getStore().loadStoreRecords();
			}
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid1.getStore().loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function() {
			if (!panelResult.getInvalidMessage()) {
				return false;
			}
			directMasterStore1.saveStore();
		},
		onNewDataButtonDown: function() {
			var r = {
				COMP_CODE		: UserInfo.compCode,
				DIV_CODE		: panelResult.getValue('DIV_CODE'),
				WORK_SHOP_CODE	: panelResult.getValue('WORK_SHOP_CODE'),
				USE_YN			: false,	// 'N' // 2021.07.14 체크박스로 변경
				EQU_START_DATE	: new Date()
			};
			masterGrid1.createRow(r);
		},
		onDeleteDataButtonDown: function() {
			var activeGrid, selRow;

			activeGrid = masterGrid1;

			selRow = activeGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)) {
				if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					activeGrid.deleteSelectedRow();
				}
			} else {
				Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
				return false;
			}
		},
		setDefault: function() {
			progWordComboStore.loadStoreRecords();
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('basis'	, '1');
			UniAppManager.setToolbarButtons(['reset', 'newData'], true);
		}
	});
};
</script>