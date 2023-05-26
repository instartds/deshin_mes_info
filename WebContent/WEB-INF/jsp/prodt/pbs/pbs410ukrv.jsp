<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pbs410ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="pbs410ukrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="W"/>							<!-- 작업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

var excelWindow;						//엑셀참조

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
		},
		Unilite.popup('EQU_MACH_CODE',{
			fieldLabel: '설비',
			valueFieldName:'EQU_MACH_CODE',
			textFieldName:'EQU_MACH_NAME',
			validateBlank:false,
			autoPopup:false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
									panelResult.setValue('EQU_MACH_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('EQU_MACH_NAME', '');
									}
				},
				onTextFieldChange: function(field, newValue, oldValue){
								panelResult.setValue('EQU_MACH_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('EQU_MACH_CODE', '');
								}
				},
				applyextparam: function(popup){
						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}else{
							UniAppManager.app.checkForNewDetail();
							panelResult.getField('DIV_CODE').focus();
							return false;
						}
					}
			}
		}),
		Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
				validateBlank:false,// 默认true，设置成false时，手动删除内容，不影响组件value
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				autoPopup:false,
//				colspan:2,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){	// 2021.08.18 표준화 작업
									panelResult.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelResult.setValue('ITEM_NAME', '');
									}
						},
					onTextFieldChange: function(field, newValue, oldValue){		// 2021.08.18 표준화 작업
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('ITEM_CODE', '');
								}
					},
					applyextparam: function(popup){
						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}else{
							UniAppManager.app.checkForNewDetail();
							panelResult.getField('DIV_CODE').focus();
							return false;
						}
					}
				}
		}),
		{
			fieldLabel	: '기준: ',
			xtype		: 'radiogroup',
			id: 'rdo_basis',
			items		: [{
				boxLabel	: '<t:message code="system.label.product.facilities" default="설비"/>',
				name		: 'basis',
				inputValue	: '1',
				width		: 60,
				checked: true
			},{
				boxLabel	: '<t:message code="system.label.product.item" default="품목"/>',
				name		: 'basis',
				inputValue	: '2',
				width		: 60
			}],
			listeners: {
				statesave: function(field, state, eOpts ){

				},
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue.basis == '2') {
						masterGrid1.setHidden(true);
						masterGrid2.setHidden(false);
						masterGrid1.setConfig('region', 'south');
						masterGrid2.setConfig('region', 'center');
						directMasterStore1.group('ITEM_CODE');
					} else {
						masterGrid1.setHidden(false);
						masterGrid2.setHidden(true);
						masterGrid2.setConfig('region', 'south');
						masterGrid1.setConfig('region', 'center');
						directMasterStore1.group('');
					}

					//그리드 초기화
					console.log(panelResult.getValues().basis);
					masterGrid1.getStore().loadData({});
					directMasterStore1.loadStoreRecords(newValue.basis);	// 기준 변경시 자동 조회


				}
			}
		}]
	});


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'pbs410ukrvService.selectList',
			create	: 'pbs410ukrvService.insertList',
			update	: 'pbs410ukrvService.updateList',
			destroy	: 'pbs410ukrvService.deleteList',
			syncAll	: 'pbs410ukrvService.saveAll'
		}
	});


	var progWordComboStore = new Ext.data.Store({
		storeId: 'pbs410ukrvProgWordComboStore',
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
//			param.basis = panelResult.getValues().basis;
			console.log(param);
			this.load({
				params : param
			});
		}
	});


	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('pbs410ukrvModel', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			, type: 'string', allowBlank: false, comboType:'W'},
			{name: 'EQU_CODE'			, text: '설비'				, type: 'string' , allowBlank: false},
			{name: 'EQU_NAME'			, text: '생산설비'				, type: 'string' , allowBlank: false},
			{name: 'PROG_WORK_CODE'		, text: '공정'				, type: 'string' , store: Ext.data.StoreManager.lookup('pbs410ukrvProgWordComboStore') , allowBlank: false},
			{name: 'ITEM_CODE'			, text: '품목코드'  			, type: 'string' , allowBlank: false},
			{name: 'ITEM_NAME'			, text: '품목명'				, type: 'string' , allowBlank: false},
			{name: 'USE_YN' 			, text: '사용여부' 			, type: 'boolean'},// comboType:'AU',comboCode:'B018' , defaultValue: 'N'}, //2021.07.14 체크박스로 변경
			{name: 'DISP_SEQ'			, text: '순번'				, type: 'string'},
			{name: 'DISP_RATE'			, text: '배부율'				, type: 'uniPercent'},
			{name: 'EQU_START_DATE'		, text: '적용시작일'			, type: 'uniDate'},
			{name: 'EQU_END_DATE'		, text: '적용종료일'			, type: 'uniDate'},
			{name: 'BATCH_PRODT_YN'		, text: 'Batch 적용여부' 		, type: 'boolean'},	// 2021.07.01 컬럼추가(Batch 적용여부)
			{name: 'SINGLE_PRODT_CT'	, text: '개별C/T(분)'			, type: 'uniQty'},
			{name: 'MULTI_PRODT_CT'		, text: '연속C/T(분)'			, type: 'uniQty'},
			{name: 'MIN_PRODT_Q'		, text: '최소생산량'			, type: 'uniQty'},	// 2021.07.14 컬럼추가
			{name: 'MAX_PRODT_Q'		, text: '최대생산량'			, type: 'uniQty'},	// 2021.07.14 컬럼추가
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
			{name: 'PROD_RATE'			, text: '설비가동적용율'			, type: 'uniPercent'},
			{name: 'REMARK'				, text: '비고	'				, type: 'string'},
			{name: 'MOLD_LINE_CNT'		, text: '몰드,라인수'			, type: 'uniQty'}
		]
	});

	// 엑셀 모델
	Unilite.Excel.defineModel('excel.pbs410.sheet01', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'		, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'	, type: 'string', allowBlank: false, comboType:'W'},
			{name: 'EQU_CODE'			, text: '생산설비코드'			, type: 'string' , allowBlank: false},
			{name: 'EQU_NAME'			, text: '생산설비'				, type: 'string' , allowBlank: false},
			{name: 'PROG_WORK_CODE'		, text: '공정'				, type: 'string' , store: Ext.data.StoreManager.lookup('pbs410ukrvProgWordComboStore') , allowBlank: false},
			{name: 'ITEM_CODE'			, text: '품목코드'  			, type: 'string' , allowBlank: false},
			{name: 'ITEM_NAME'			, text: '품목명'				, type: 'string' , allowBlank: false},
			{name: 'USE_YN' 			, text: '사용여부' 			, type: 'string' , disabledCls : ''},// comboType:'AU',comboCode:'B018' , defaultValue: 'N'}, //2021.07.14 체크박스로 변경
			{name: 'DISP_SEQ'			, text: '순번'				, type: 'string'},
			{name: 'DISP_RATE'			, text: '배부율'				, type: 'uniPercent'},
			{name: 'EQU_START_DATE'		, text: '적용시작일'			, type: 'uniDate'},
			{name: 'EQU_END_DATE'		, text: '적용종료일'			, type: 'uniDate'},
			{name: 'BATCH_PRODT_YN'		, text: 'Batch 적용여부' 		, type: 'string' , disabledCls : ''},	// 2021.07.01 컬럼추가(Batch 적용여부)
			{name: 'SINGLE_PRODT_CT'	, text: '개별C/T(분)'			, type: 'uniQty'},
			{name: 'MULTI_PRODT_CT'		, text: '연속C/T(분)'			, type: 'uniQty'},
			{name: 'MIN_PRODT_Q'		, text: '최소생산량'			, type: 'uniQty'},	// 2021.07.14 컬럼추가
			{name: 'MAX_PRODT_Q'		, text: '최대생산량'			, type: 'uniQty'},	// 2021.07.14 컬럼추가
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
			{name: 'PROD_RATE'			, text: '설비가동적용율'			, type: 'uniPercent'},
			{name: 'REMARK'				, text: '비고	'				, type: 'string'},
			{name: 'MOLD_LINE_CNT'		, text: '몰드,라인수'			, type: 'uniQty'}
		]
	});

	/* 엑셀 업로드 기능 추가 */
	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';	// Custom Excel Format

		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.DIV_CODE = panelResult.getValue('DIV_CODE');
		}
		if(!excelWindow) {
			excelWindow =  Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
					modal: false,
//					width: 1200,
//					height: 300,
					excelConfigName: 'pbs410ukrv',	// .xml
					extParam: {
						'PGM_ID': 'pbs410ukrv',	// Program ID
						'DIV_CODE'  : panelResult.getValue('DIV_CODE')
					},
					grids: [{
							itemId: 'grid01',
							title: '설비별생산공수 엑셀업로드',
							useCheckbox: true,
							model : 'excel.pbs410.sheet01',	// 엑셀 1번째 sheet
							readApi: 'pbs410ukrvService.selectExcelUploadSheet1',	//엑셀업로드 서비스 매핑
							columns: [	// 팝업 도움창 그리드 컬럼 설정
										{dataIndex: 'DIV_CODE'			, width:80},
										{dataIndex: 'WORK_SHOP_CODE'	, width:110},
										{dataIndex: 'EQU_NAME'			, width:130},
										{dataIndex: 'PROG_WORK_CODE'	, width:110},
										{dataIndex: 'ITEM_CODE'			, width:120},
										{dataIndex: 'ITEM_NAME'			, width:200},
										{dataIndex: 'USE_YN' 			, width:100},
										{dataIndex: 'DISP_SEQ' 			, width:80},
										{dataIndex: 'DISP_RATE'			, width:150},
										{dataIndex: 'EQU_START_DATE'	, width:120},
										{dataIndex: 'EQU_END_DATE'		, width:120},
										{text: 'Batch생산',
											columns:[
												{dataIndex: 'BATCH_PRODT_YN'	, width:120},	//2021.07.01 컬럼추가(BATCH적용여부)
												{dataIndex: 'SINGLE_PRODT_CT'	, width:150},
												{dataIndex: 'MULTI_PRODT_CT'	, width:150},
												{dataIndex: 'MIN_PRODT_Q'		, width:150},	//2021.07.14 컬럼추가
												{dataIndex: 'MAX_PRODT_Q'		, width:150}	//2021.07.14 컬럼추가
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
										{dataIndex: 'PROD_RATE'			, width:150},
										{dataIndex: 'REMARK'			, width:150},
										{dataIndex: 'MOLD_LINE_CNT'		, width:150}
								]
					}],
					listeners: {
						close: function() {
							this.hide();
						}
					},
					onApply:function()  {
						var grid = this.down('#grid01');
						var records = grid.getSelectionModel().getSelection();
						var flag = true;
						flag =  UniAppManager.app.fnMakeExcelRef(records);
						if(flag) {
								var beforeRM = grid.getStore().count();
								grid.getStore().remove(records);
								var afterRM = grid.getStore().count();
								if (beforeRM > 0 && afterRM == 0){
								   excelWindow.close();
								}
							}
						this.hide();
						/*
							excelWindow.getEl().mask('로딩중...','loading-indicator');	 ///////// 엑셀업로드 최신로직
							var me = this;
							var grid = this.down('#grid01');
							var records = grid.getStore().getAt(0);
							var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
							mpo502ukrvService.selectExcelUploadSheet1(param, function(provider, response){
								var store = masterGrid.getStore();
								var records = response.result;
								var countDate = UniDate.getDbDateStr(masterForm.getValue('COUNT_DATE')).substring(0, 6);
//							  var monthDate = countDate.substring(0,4) + '.' + countDate.substring(4,6);
								for(var i=0; i<records.length; i++) {
									records[i].BASIS_YYYYMM = countDate;
								}
								store.insert(0, records);
								console.log("response",response)
								excelWindow.getEl().unmask();
								grid.getStore().removeAll();
								me.hide();
							});
							*/
					}
			 });
		}
		excelWindow.center();
		excelWindow.show();
	}

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('pbs410ukrvMasterStore1',{
		model	: 'pbs410ukrvModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function(newrdo) {
			var param= Ext.getCmp('resultForm').getValues();
			param.basis = newrdo;
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
	var masterGrid1 = Unilite.createGrid('pbs410ukrvGrid1', {
		tbar: [{
			itemId: 'excelBtn',
			text: '<div style="color: blue">엑셀업로드</div>',
			handler: function() {
				if(!panelResult.getInvalidMessage()) return;	//필수체크
				openExcelWindow();
			}
		}],
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
			{dataIndex: 'ITEM_CODE'			, width:120, locked: false
				,editor: Unilite.popup('DIV_PUMOK_G',{
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
				 	autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type){
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										masterGrid1.setItemData(record,false, masterGrid1.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid1.setItemData(record,false, masterGrid1.getSelectedRecord());
									}
								});
							},
						scope: this
						},
						'onClear' : function(type) {
							masterGrid1.setItemData(null,true, masterGrid1.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({/*'SELMODEL': 'MULTI',*/ 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': divCode});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width:200, locked: false
				, editor: Unilite.popup('DIV_PUMOK_G',{
				 	autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type){
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										masterGrid1.setItemData(record,false, masterGrid1.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid1.setItemData(record,false, masterGrid1.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear' : function(type) {
							masterGrid1.setItemData(null,true, masterGrid1.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({/*'SELMODEL': 'MULTI',*/ 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': divCode});
						}
					}
				})
			},
			{dataIndex: 'USE_YN' 			, width:100, xtype: 'checkcolumn', align:'center', locked: false},
			{dataIndex: 'DISP_SEQ' 			, width:80},
			{dataIndex: 'DISP_RATE'			, width:150, hidden: true},
			{dataIndex: 'EQU_START_DATE'	, width:120},
			{dataIndex: 'EQU_END_DATE'		, width:120},
			{text: 'Batch생산',
				columns:[
					{dataIndex: 'BATCH_PRODT_YN'	, width:120, xtype: 'checkcolumn', align: 'center'},	//2021.07.01 컬럼추가(BATCH적용여부)
					{dataIndex: 'SINGLE_PRODT_CT'	, width:150, hidden:true},
					{dataIndex: 'MULTI_PRODT_CT'	, width:150, hidden:false},
					{dataIndex: 'MIN_PRODT_Q'	, width:150, hidden:true},	//2021.07.14 컬럼추가
					{dataIndex: 'MAX_PRODT_Q'	, width:150, hidden:true}	//2021.07.14 컬럼추가
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
			{dataIndex: 'PROD_RATE'			, width:150},
			{dataIndex: 'REMARK'			, width:150},
			{dataIndex: 'MOLD_LINE_CNT'		, width:150}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (e.record.phantom){
					return true;
				} else {
					if (UniUtils.indexOf(e.field, ['DISP_SEQ','EQU_START_DATE','EQU_END_DATE','SINGLE_PRODT_CT','MULTI_PRODT_CT','STD_MEN','STD_PRODT_Q','NET_UPH','ACT_SET_M','ACT_OUT_M','ACT_UP_RATE','MOLD_LINE_CNT','REAMARK'])) {
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
				grdRecord.set('ITEM_CODE'	,'');
				grdRecord.set('ITEM_NAME'	,'');
				grdRecord.set('SPEC'		,'');
				grdRecord.set('ORDER_UNIT'	,'');
			} else {
				grdRecord.set('ITEM_CODE'	,record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'	,record['ITEM_NAME']);
				grdRecord.set('SPEC'		,record['SPEC']);
				grdRecord.set('ORDER_UNIT'	,record['ORDER_UNIT']);
			}
		},
		setExcelData: function(record) {	//엑셀 업로드 참조
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			grdRecord.set('WORK_SHOP_CODE'	, record['WORK_SHOP_CODE']);
			grdRecord.set('EQU_CODE'		, record['EQU_CODE']);
			grdRecord.set('EQU_NAME'		, record['EQU_NAME']);
			grdRecord.set('PROG_WORK_CODE'	, record['PROG_WORK_CODE']);
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('USE_YN'			, record['USE_YN'] == "Y" ? true : false);
			grdRecord.set('DISP_SEQ'		, record['DISP_SEQ']);
			grdRecord.set('DISP_RATE'		, record['DISP_RATE']);
			grdRecord.set('EQU_START_DATE'	, record['EQU_START_DATE']);
			grdRecord.set('EQU_END_DATE'	, record['EQU_END_DATE']);
			grdRecord.set('BATCH_PRODT_YN'	, record['BATCH_PRODT_YN'] == "Y" ? true : false);
			grdRecord.set('SINGLE_PRODT_CT'	, record['SINGLE_PRODT_CT']);
			grdRecord.set('MULTI_PRODT_CT'	, record['MULTI_PRODT_CT']);
			grdRecord.set('MIN_PRODT_Q'		, record['MIN_PRODT_Q']);
			grdRecord.set('MAX_PRODT_Q'		, record['MAX_PRODT_Q']);
			grdRecord.set('STD_MEN'			, record['STD_MEN']);
			grdRecord.set('STD_PRODT_Q'		, record['STD_PRODT_Q']);
			grdRecord.set('NET_UPH'			, record['NET_UPH']);
			grdRecord.set('NET_MH_M'		, record['NET_MH_M']);
			grdRecord.set('NET_MH_S'		, record['NET_MH_S']);
			grdRecord.set('NET_CT_M'		, record['NET_CT_M']);
			grdRecord.set('NET_CT_S'		, record['NET_CT_S']);
			grdRecord.set('ACT_SET_M'		, record['ACT_SET_M']);
			grdRecord.set('ACT_OUT_M'		, record['ACT_OUT_M']);
			grdRecord.set('ACT_UP_RATE'		, record['ACT_UP_RATE']);
			grdRecord.set('ACT_MH_M'		, record['ACT_MH_M']);
			grdRecord.set('ACT_MH_S'		, record['ACT_MH_S']);
			grdRecord.set('ACT_CT_M'		, record['ACT_CT_M']);
			grdRecord.set('ACT_CT_S'		, record['ACT_CT_S']);
			grdRecord.set('ACT_UPH'			, record['ACT_UPH']);
			grdRecord.set('ACT_UPH_M'		, record['ACT_UPH_M']);
			grdRecord.set('PROD_RATE'		, record['PROD_RATE']);
			grdRecord.set('REMARK'			, record['REMARK']);
			grdRecord.set('MOLD_LINE_CNT'	, record['MOLD_LINE_CNT']);
		}
	});

	var masterGrid2 = Unilite.createGrid('pbs410ukrvGrid2', {	// 여기 locked 주면 오류!!!
		store	: directMasterStore1,
		region	: 'south' ,
		layout	: 'fit',
		hidden	: true,
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
			{dataIndex: 'DIV_CODE'			, width:80, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width:120
				,editor: Unilite.popup('DIV_PUMOK_G',{
				textFieldName	: 'ITEM_CODE',
				DBtextFieldName	: 'ITEM_CODE',
				extParam		: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
				autoPopup		: true,
				listeners		: {
					'onSelected': {
						fn: function(records, type){
							console.log('records : ', records);
							Ext.each(records, function(record,i) {
								console.log('record',record);
								if(i==0) {
									masterGrid2.setItemData(record,false, masterGrid2.uniOpt.currentRecord);
								} else {
									UniAppManager.app.onNewDataButtonDown();
									masterGrid2.setItemData(record,false, masterGrid2.getSelectedRecord());
								}
							});
						},
						scope: this
						},
						'onClear' : function(type) {
							masterGrid2.setItemData(null,true, masterGrid2.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({/*'SELMODEL': 'MULTI',*/ 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': divCode});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width:200
				, editor: Unilite.popup('DIV_PUMOK_G',{
				 	autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type){
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										masterGrid2.setItemData(record,false, masterGrid2.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid2.setItemData(record,false, masterGrid2.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear' : function(type) {
							masterGrid2.setItemData(null,true, masterGrid2.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({/*'SELMODEL': 'MULTI',*/ 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': divCode});
						}
					}
				})
			},
			{dataIndex: 'EQU_CODE'			, width:100},
			{dataIndex: 'EQU_NAME'			, width:130
				,editor : Unilite.popup('EQU_MACH_CODE_G',{
					textFieldName:'EQU_MACH_NAME',
					DBtextFieldName: 'EQU_MACH_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid2.uniOpt.currentRecord;
								grdRecord.set('EQU_CODE'		,records[0]['EQU_MACH_CODE']);
								grdRecord.set('EQU_NAME'		,records[0]['EQU_MACH_NAME']);
								grdRecord.set('WORK_SHOP_CODE' 	,records[0]['WORK_SHOP_CODE']);
								grdRecord.set('PROG_WORK_CODE' 	,records[0]['PROG_WORK_CODE']);
							},
							scope: this
						},
						'onClear': function(type) {
							grdRecord = masterGrid2.getSelectedRecord();
							grdRecord.set('EQU_CODE'		, '');
							grdRecord.set('EQU_NAME'		, '');
							grdRecord.set('WORK_SHOP_CODE' 	, '');
							grdRecord.set('PROG_WORK_CODE' 	, '');
						},
						applyextparam: function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({/*'SELMODEL': 'MULTI',*/ 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': divCode});
						}
					}
				})
			},
			{dataIndex: 'WORK_SHOP_CODE'	, width:110,
				listeners:{
					render:function(elm) {
						elm.editor.on('beforequery',function(queryPlan, eOpts) {
							var store = queryPlan.combo.store;
							var record = masterGrid2.uniOpt.currentRecord;
							store.clearFilter();
							store.filterBy(function(item){
								return item.get('option') == record.get('DIV_CODE')
							})
						})
					}
				}
			},
			{dataIndex: 'PROG_WORK_CODE'	, width:110,
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
			{dataIndex: 'EQU_START_DATE'	, width:120},
			{dataIndex: 'EQU_END_DATE'		, width:120},
			{text: 'Batch생산',
				columns:[
					{dataIndex: 'BATCH_PRODT_YN'	, width: 80, xtype: 'checkcolumn', align: 'center', disabledCls : '', sortable: false
					,listeners:{
							beforecheckchange: function( CheckColumn, rowIndex, checked, record, e, eOpts ) {
								var grdRecord = directMasterStore1.getAt(rowIndex);
								if(grdRecord.phantom == false){
									return false;
								}
							}
						}
					},	//2021.07.01 컬럼추가(BATCH적용여부)
					{dataIndex: 'SINGLE_PRODT_CT'	, width:150},
					{dataIndex: 'MULTI_PRODT_CT'	, width:150},
					{dataIndex: 'MIN_PRODT_Q'	, width:150},	//2021.07.14 컬럼추가
					{dataIndex: 'MAX_PRODT_Q'	, width:150}	//2021.07.14 컬럼추가
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
			{dataIndex: 'PROD_RATE'			, width:150},
			{dataIndex: 'REMARK'			, width:150},
			{dataIndex: 'MOLD_LINE_CNT'		, width:150}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (e.record.phantom){
					return true;
				} else {
					if (UniUtils.indexOf(e.field, ['DISP_SEQ','EQU_START_DATE','EQU_END_DATE','SINGLE_PRODT_CT','MULTI_PRODT_CT','STD_MEN','STD_PRODT_Q','NET_UPH','ACT_SET_M','ACT_OUT_M','ACT_UP_RATE','MOLD_LINE_CNT','REAMARK'])) {
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
				grdRecord.set('ITEM_CODE'	,'');
				grdRecord.set('ITEM_NAME'	,'');
				grdRecord.set('SPEC'		,'');
				grdRecord.set('ORDER_UNIT'	,'');
			} else {
				grdRecord.set('ITEM_CODE'	,record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'	,record['ITEM_NAME']);
				grdRecord.set('SPEC'		,record['SPEC']);
				grdRecord.set('ORDER_UNIT'	,record['ORDER_UNIT']);
			}
		}
	});


	Unilite.Main({
		id			: 'pbs410ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid1, masterGrid2, panelResult
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

			if(masterGrid2.isHidden()) {
				activeGrid = masterGrid1;
			} else {
				activeGrid = masterGrid2;
			}
			selRow = activeGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)) {
				if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					activeGrid.deleteSelectedRow();
				}
			} else {
				Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
				return false;
			}
		},fnMakeExcelRef: function(records){
			var flag = true;
			var newDetailRecords = new Array();
			Ext.each(records, function(record,i){

				var r = {
					COMP_CODE		: UserInfo.compCode,
					DIV_CODE		: panelResult.getValue('DIV_CODE'),
					WORK_SHOP_CODE	: panelResult.getValue('WORK_SHOP_CODE'),
					USE_YN			: false,	// 'N' // 2021.07.14 체크박스로 변경
					EQU_START_DATE	: new Date()
				};
				newDetailRecords[i] = directMasterStore1.model.create( r );
				newDetailRecords[i].set('DIV_CODE'		, record.get('DIV_CODE'));
				newDetailRecords[i].set('WORK_SHOP_CODE'	, record.get('WORK_SHOP_CODE'));
				newDetailRecords[i].set('EQU_CODE'		, record.get('EQU_CODE'));
				newDetailRecords[i].set('EQU_NAME'		, record.get('EQU_NAME'));
				newDetailRecords[i].set('PROG_WORK_CODE'	, record.get('PROG_WORK_CODE'));
				newDetailRecords[i].set('ITEM_CODE'		, record.get('ITEM_CODE'));
				newDetailRecords[i].set('ITEM_NAME'		, record.get('ITEM_NAME'));
				newDetailRecords[i].set('USE_YN'			, record.get('USE_YN') == "Y" ? true : false);
				newDetailRecords[i].set('DISP_SEQ'		, record.get('DISP_SEQ'));
				newDetailRecords[i].set('DISP_RATE'		, record.get('DISP_RATE'));
				newDetailRecords[i].set('EQU_START_DATE'	, record.get('EQU_START_DATE'));
				newDetailRecords[i].set('EQU_END_DATE'	, record.get('EQU_END_DATE'));
				newDetailRecords[i].set('BATCH_PRODT_YN'	, record.get('BATCH_PRODT_YN') == "Y" ? true : false);
				newDetailRecords[i].set('SINGLE_PRODT_CT'	, record.get('SINGLE_PRODT_CT'));
				newDetailRecords[i].set('MULTI_PRODT_CT'	, record.get('MULTI_PRODT_CT'));
				newDetailRecords[i].set('MIN_PRODT_Q'		, record.get('MIN_PRODT_Q'));
				newDetailRecords[i].set('MAX_PRODT_Q'		, record.get('MAX_PRODT_Q'));
				newDetailRecords[i].set('STD_MEN'			, record.get('STD_MEN'));
				newDetailRecords[i].set('STD_PRODT_Q'		, record.get('STD_PRODT_Q'));
				newDetailRecords[i].set('NET_UPH'			, record.get('NET_UPH'));
				newDetailRecords[i].set('NET_MH_M'		, record.get('NET_MH_M'));
				newDetailRecords[i].set('NET_MH_S'		, record.get('NET_MH_S'));
				newDetailRecords[i].set('NET_CT_M'		, record.get('NET_CT_M'));
				newDetailRecords[i].set('NET_CT_S'		, record.get('NET_CT_S'));
				newDetailRecords[i].set('ACT_SET_M'		, record.get('ACT_SET_M'));
				newDetailRecords[i].set('ACT_OUT_M'		, record.get('ACT_OUT_M'));
				newDetailRecords[i].set('ACT_UP_RATE'		, record.get('ACT_UP_RATE'));
				newDetailRecords[i].set('ACT_MH_M'		, record.get('ACT_MH_M'));
				newDetailRecords[i].set('ACT_MH_S'		, record.get('ACT_MH_S'));
				newDetailRecords[i].set('ACT_CT_M'		, record.get('ACT_CT_M'));
				newDetailRecords[i].set('ACT_CT_S'		, record.get('ACT_CT_S'));
				newDetailRecords[i].set('ACT_UPH'			, record.get('ACT_UPH'));
				newDetailRecords[i].set('ACT_UPH_M'		, record.get('ACT_UPH_M'));
				newDetailRecords[i].set('PROD_RATE'		, record.get('PROD_RATE'));
				newDetailRecords[i].set('REMARK'			, record.get('REMARK'));
				newDetailRecords[i].set('MOLD_LINE_CNT'	, record.get('MOLD_LINE_CNT'));
			});
			directMasterStore1.loadData(newDetailRecords, true);
			return flag;

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