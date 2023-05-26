<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bpr200ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="level1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="level2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="level3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >


function appMain() {
	var excelWindow;	//BOM정보 업로드 윈도우 생성

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_bpr200ukrv_mitService.selectDetailList',
			update	: 's_bpr200ukrv_mitService.updateDetail',
			create	: 's_bpr200ukrv_mitService.insertDetail',
			destroy	: 's_bpr200ukrv_mitService.deleteDetail',
			syncAll	: 's_bpr200ukrv_mitService.saveAll'
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false
		},
		Unilite.popup('ITEM',{
			fieldLabel		: '<t:message code="system.label.base.item" default="품목"/>',
			textFieldName	: 'ITEM_NAME',
			valueFieldName	: 'ITEM_CODE',
			validateBlank	: false
		}),{
			fieldLabel	: '<t:message code="system.label.base.spec" default="규격"/>',
			name		: 'SPEC',
			xtype		: 'uniTextfield',
			maxLength	: 160
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 3 0',
			colspan	: 3,
			items	: [{
				fieldLabel	: '<t:message code="system.label.base.itemgroup" default="품목분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('level1Store'),
				child		: 'ITEM_LEVEL2',
				width		: 210
			}, {
				fieldLabel	: '',
				name		: 'ITEM_LEVEL2',
				xtype		:'uniCombobox',
				store		: Ext.data.StoreManager.lookup('level2Store'),
				child		: 'ITEM_LEVEL3',
				width		: 110
				
			 }, {
			 	fieldLabel	: '',
			 	name		: 'ITEM_LEVEL3',
			 	xtype		:'uniCombobox',
				store		: Ext.data.StoreManager.lookup('level3Store'),
				width		: 110
			}]
		}]
	});	



	/** main Model 정의 
	 */
	Unilite.defineModel('s_bpr200ukrv_mitModel', {
		fields: [
			{name: '_EXCEL_JOBID'	, text: 'EXCEL_JOBID'				, type: 'string'},
			{name: '_EXCEL_ROWNUM'	, text: '순번'						, type: 'int'},
			{name: 'DIV_CODE'		, text: 'DIV_CODE'					, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'	, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.base.itemname" default="품목명"/>'	, type: 'string'},
			{name: 'SPEC'			, text: '규격'						, type: 'string'},
			{name: 'C'				, text: '직경'						, type: 'string'},
			{name: 'D'				, text: '길이'						, type: 'string'},
			{name: 'E'				, text: '골드위치'						, type: 'string'},
			{name: 'F'				, text: '열처리온도'					, type: 'string'},
			{name: 'G'				, text: '열처리시간'					, type: 'string'},
			{name: 'H'				, text: '적재패턴'						, type: 'string'},
			{name: 'I'				, text: 'RPM'						, type: 'string'},
			{name: 'J'				, text: '직경'						, type: 'string'},
			{name: 'K'				, text: '길이'						, type: 'string'},
			{name: 'L'				, text: '길이'						, type: 'string'},
			{name: 'M'				, text: '간격 (a)'					, type: 'string'},
			{name: 'N'				, text: 'Reposition block (b) (mm)'	, type: 'string'},
			{name: 'O'				, text: '간격 (c) (mm)'				, type: 'string'},
			{name: 'P'				, text: 'Visible Marker (d) (mm)'	, type: 'string'},
			{name: 'AM'             , text: '멘드렐'                        , type: 'string'},
			{name: 'Q'				, text: '라쏘'						, type: 'string'},
			{name: 'R'				, text: '손잡이/올리브팁'				, type: 'string'},
			{name: 'S'				, text: '박스'						, type: 'string'},
//			{name: 'T'				, text: '박스(고객이중국일때)'			, type: 'string'},
			{name: 'U'				, text: '국내'						, type: 'string'},
			{name: 'V'				, text: '프랑스(독일올림푸스)'			, type: 'string'},
			{name: 'W'				, text: '독일'						, type: 'string'},
			{name: 'X'				, text: '중국'						, type: 'string'},
			{name: 'Y'				, text: '우크라이나'					, type: 'string'},
			{name: 'Z'				, text: '일본'						, type: 'string'},
			{name: 'AA'				, text: '국내'						, type: 'string'},
			{name: 'IFU_US'			, text: '미국'						, type: 'string'},
			{name: 'IFU_DE'			, text: '독일'						, type: 'string'},
			{name: 'IFU_ETC'		, text: '기타해외'						, type: 'string'},
			{name: 'AB'				, text: '엑세서리'						, type: 'string'},
			{name: 'AC'				, text: '상품직경'						, type: 'string'},
			{name: 'AD'				, text: '상품길이'						, type: 'string'},
			{name: 'AE'				, text: '상품유형'						, type: 'string'},
			{name: 'AF'				, text: '상품형상'						, type: 'string'},
			{name: 'AG'				, text: '상품허가번호'					, type: 'string'},
			{name: 'AH'				, text: '상품제조국'						, type: 'string'},
			{name: 'AI'				, text: '상품제조사'						, type: 'string'},
			{name: 'AJ'				, text: '작지공정구분'					, type: 'string'},
			{name: 'AK'				, text: '작지투입공정'					, type: 'string'},
			{name: 'AL'				, text: '라벨'						, type: 'string'}
			
		]
	});

	/** Store 정의(Service 정의)
	 */
	var directMasterStore = Unilite.createStore('s_bpr200ukrv_mitMasterStore1',{
		model	: 's_bpr200ukrv_mitModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,	// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_bpr200ukrv_mitGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records.length > 0){
					panelResult.getField('DIV_CODE').setReadOnly(true);
				} else {
					panelResult.getField('DIV_CODE').setReadOnly(false);
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	/** Master Grid 정의(Grid Panel)
	 */
	var masterGrid = Unilite.createGrid('s_bpr200ukrv_mitGrid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: true,
			useMultipleSorting	: true
		},
		tbar:[{
			xtype	: 'button',
			text	: '엑셀업로드',
			id		: 'excelUploadButton',
			width	: 100,
			handler	: function() {
				if(!panelResult.getInvalidMessage()) return false;
				openExcelWindow();
			}
		}/*,'-'*/],
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns	: [
			{dataIndex: 'DIV_CODE'		, width: 110, hidden: true},
			{dataIndex: 'ITEM_CODE'		, width: 110,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
									console.log('records : ', records);
									Ext.each(records, function(record,i) {
											if(i==0) {
												masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
											}
									});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var record = masterGrid.getSelectedRecord();
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'		, width: 250,
				editor: Unilite.popup('DIV_PUMOK_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
									console.log('records : ', records);
									Ext.each(records, function(record,i) {
										if(i==0) {
											masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
										} else {
											UniAppManager.app.onNewDataButtonDown();
											masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
										}
									});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var record = masterGrid.getSelectedRecord();
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode});
						}
					}
				})
			},
			{dataIndex: 'SPEC'			, width: 120},
			{text: '스텐트',
				columns: [ 
					{dataIndex: 'C'		, width: 110},
					{dataIndex: 'D'		, width: 110},
					{dataIndex: 'E'		, width: 110},
					{dataIndex: 'F'		, width: 110},
					{dataIndex: 'G'		, width: 110},
					{dataIndex: 'H'		, width: 110}
				]
			},
			{text: '코팅',
				columns: [ 
					{dataIndex: 'I'		, width: 110}
				]
			},
			{text: '삽입O/S',
				columns: [ 
					{dataIndex: 'J'		, width: 110},
					{dataIndex: 'K'		, width: 110}
				]
			},
			{text: '삽입I/S',
				columns: [ 
					{dataIndex: 'L'		, width: 110}
				]
			},
			{text: '걸림턱',
				columns: [ 
					{dataIndex: 'M'		, width: 110},
					{dataIndex: 'N'		, width: 110},
					{dataIndex: 'O'		, width: 110},
					{dataIndex: 'P'		, width: 110}
				]
			},
			{text: '조립',
				columns: [ 
					{dataIndex: 'AM'    , width: 110},
					{dataIndex: 'Q'		, width: 110},
					{dataIndex: 'R'		, width: 110}
				]
			},
			{text: '포장',
				columns: [ 
					{dataIndex: 'S'		, width: 110},
//					{dataIndex: 'T'		, width: 110},
					{dataIndex: 'U'		, width: 110},
					{dataIndex: 'V'		, width: 110},
					{dataIndex: 'W'		, width: 110},
					{dataIndex: 'X'		, width: 110},
					{dataIndex: 'Y'		, width: 110},
					{dataIndex: 'Z'		, width: 110}
				]
			},
			{text: '사용자설명서IFU',
				columns:[
					{dataIndex: 'AA'			, width: 110},
					{dataIndex: 'IFU_US'		, width: 110},
					{dataIndex: 'IFU_DE'		, width: 110},
					{dataIndex: 'IFU_ETC'		, width: 110}
				]
			},
			{dataIndex: 'AB'			, width: 110},
			{dataIndex: 'AC'			, width: 110},
			{dataIndex: 'AD'			, width: 110},
			{dataIndex: 'AE'			, width: 110},
			{dataIndex: 'AF'			, width: 110},
			{dataIndex: 'AG'			, width: 110},
			{dataIndex: 'AH'			, width: 110},
			{dataIndex: 'AI'			, width: 110},
			{dataIndex: 'AJ'			, width: 110	, hidden: true},
			{dataIndex: 'AK'			, width: 110	, hidden: true},
			{dataIndex: 'AL'			, width: 110	, hidden: true},
			{dataIndex: '_EXCEL_JOBID'	, width: 110	, hidden: true},
			{dataIndex: '_EXCEL_ROWNUM'	, width: 110	, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if(UniUtils.indexOf(e.field, ['DIV_CODE', 'ITEM_CODE', 'ITEM_NAME', 'SPEC', '_EXCEL_JOBID', '_EXCEL_ROWNUM'])) {
						return false;
					} else {
						return true;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['DIV_CODE', 'SPEC', '_EXCEL_JOBID', '_EXCEL_ROWNUM'])) {
						return false;
					} else {
						return true;
					}
				}
			},
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
				});
			},
			selectionchange:function( model1, selected, eOpts ){
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'	, '');
				grdRecord.set('ITEM_NAME'	, '');
				grdRecord.set('SPEC'		, '');
			} else {
				grdRecord.set('ITEM_CODE'	, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'	, record['ITEM_NAME']);
				grdRecord.set('SPEC'		, record['SPEC']);
			}
		},
		setExcelData: function(records) {
			var grdRecord			= this.getSelectedRecord();
			var newDetailRecords	= new Array();
			var columns				= this.getColumns();
			Ext.each(records, function(record, i){
				var r = {
					'DIV_CODE': panelResult.getValue('DIV_CODE')
				};
				newDetailRecords[i] = directMasterStore.model.create( r );
				Ext.each(columns, function(column, index) {
					newDetailRecords[i].set(column.initialConfig.dataIndex, record.get(column.initialConfig.dataIndex));
				});
			});
			panelResult.getField('DIV_CODE').setReadOnly(true);
			directMasterStore.loadData(newDetailRecords, true);
		}
	});





	//엑셀업로드 윈도우 생성 함수
	function openExcelWindow() {
		var me		= this;
		var vParam	= {};
		var appName	= 'Unilite.com.excel.ExcelUpload';
		if(UniAppManager.app._needSave()) {	//화면에 저장할 내용이 있을 경우 저장여부 확인
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			} else {
				return false;
			}
		}
		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.DIV_CODE = panelResult.getValue('DIV_CODE');
		}
		if(!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: 's_bpr200ukrv_mit',
				width	: 600,
				height	: 400,
				modal	: false,
				extParam: {
					'PGM_ID'	: 's_bpr200ukrv_mit',
					'DIV_CODE'	: panelResult.getValue('DIV_CODE')
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid01',
						title		: '품목추가정보 업로드',
						useCheckbox	: false,
						model		: 's_bpr200ukrv_mitModel',
						readApi		: 's_bpr200ukrv_mitService.selectExcelUploadSheet',
						columns		: [
							{dataIndex: 'DIV_CODE'	, width: 110, hidden: true},
							{dataIndex: 'ITEM_CODE'	, width: 110},
							{dataIndex: 'ITEM_NAME'	, width: 160},
							{dataIndex: 'C'			, width: 110},
							{dataIndex: 'D'			, width: 110},
							{dataIndex: 'E'			, width: 110},
							{dataIndex: 'F'			, width: 110},
							{dataIndex: 'G'			, width: 110},
							{dataIndex: 'H'			, width: 110},
							{dataIndex: 'I'			, width: 110},
							{dataIndex: 'J'			, width: 110},
							{dataIndex: 'K'			, width: 110},
							{dataIndex: 'L'			, width: 110},
							{dataIndex: 'M'			, width: 110},
							{dataIndex: 'N'			, width: 110},
							{dataIndex: 'O'			, width: 110},
							{dataIndex: 'P'			, width: 110},
							{dataIndex: 'AM'        , width: 110},
							{dataIndex: 'Q'			, width: 110},
							{dataIndex: 'R'			, width: 110},
							{dataIndex: 'S'			, width: 110},
//							{dataIndex: 'T'			, width: 110},
							{dataIndex: 'U'			, width: 110},
							{dataIndex: 'V'			, width: 110},
							{dataIndex: 'W'			, width: 110},
							{dataIndex: 'X'			, width: 110},
							{dataIndex: 'Y'			, width: 110},
							{dataIndex: 'Z'			, width: 110},
							{dataIndex: 'AA'		, width: 110},
							{dataIndex: 'IFU_US'	, width: 110},
							{dataIndex: 'IFU_DE'	, width: 110},
							{dataIndex: 'IFU_ETC'	, width: 110},
							{dataIndex: 'AB'		, width: 110},
							{dataIndex: 'AC'		, width: 110},
							{dataIndex: 'AD'		, width: 110},
							{dataIndex: 'AE'		, width: 110},
							{dataIndex: 'AF'		, width: 110},
							{dataIndex: 'AG'		, width: 110},
							{dataIndex: 'AH'		, width: 110},
							{dataIndex: 'AI'		, width: 110},
							{dataIndex: 'AJ'		, width: 110},
							{dataIndex: 'AK'		, width: 110},
							{dataIndex: 'AL'		, width: 110}
							
						]
					}
				],
				listeners: {
					beforeshow: function( panel, eOpts ) {
						this.down('#grid01').getStore().sort({property : '_EXCEL_ROWNUM', direction: 'ASC'});
					},
					beforehide: function(me, eOpt) {
						var me		= this;
						var grid	= this.down('#grid01');
						excelWindow.getEl().unmask();
						grid.getStore().removeAll();
					},
					beforeclose: function() {
						this.hide();
					}
				},
				onApply:function() {
					var flag = true
					var grid = this.down('#grid01');
					var records = grid.getStore().data.items;
					Ext.each(records, function(record,i){
						if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
							console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
							flag = false;
							return false;
						}
					});
					if(!flag){
						Unilite.messageBox("에러가 있는 행은 적용이 불가능합니다.");
					} else{
						if(UniAppManager.app._needSave())	{
							return;
						}
						masterGrid.store.loadData({});
						masterGrid.setExcelData(records);
						// grid.getStore().remove(records);
						var beforeRM = grid.getStore().count();
						grid.getStore().remove(records);
						var afterRM = grid.getStore().count();
						if (beforeRM > 0 && afterRM == 0){
							excelWindow.close();
						}
					}
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};





	Unilite.Main({
		id			: 's_bpr200ukrv_mitApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]}
		],
		fnInitBinding: function(params) {
			this.setDefault();
			if(params)	{
				panelResult.setValue("ITEM_CODE", params.ITEM_CODE)
				panelResult.setValue("ITEM_NAME", params.ITEM_NAME)
				//panelResult.setValue("SPEC"     , params.SPEC)
				setTimeout(UniAppManager.app.onQueryButtonDown(), 1000);
			}
		},
		onQueryButtonDown : function() {
			if(!panelResult.getInvalidMessage()){
				return false;
			}
			directMasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		setDefault: function() {
			panelResult.getField('DIV_CODE').setReadOnly(false);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('newData'	, true);
			UniAppManager.setToolbarButtons('save'		, false);
		},
		onResetButtonDown: function() {// 새로고침 버튼
			panelResult.clearForm();
			directMasterStore.loadData({});
			this.fnInitBinding();
		},
		onNewDataButtonDown: function() {
			panelResult.getField('DIV_CODE').setReadOnly(true);
			var divCode = panelResult.getValue('DIV_CODE');
			var r = {
				DIV_CODE: divCode
			};
			masterGrid.createRow(r);
		},
		onDeleteDataButtonDown: function() {
			if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		}
	});
};
</script>