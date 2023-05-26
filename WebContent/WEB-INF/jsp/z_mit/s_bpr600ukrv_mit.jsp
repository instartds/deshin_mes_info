<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bpr600ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >


function appMain() {
	var excelWindow;	//BOM정보 업로드 윈도우 생성

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_bpr600ukrv_mitService.selectDetailList',
			update	: 's_bpr600ukrv_mitService.updateDetail',
			create	: 's_bpr600ukrv_mitService.insertDetail',
			destroy	: 's_bpr600ukrv_mitService.deleteDetail',
			syncAll	: 's_bpr600ukrv_mitService.saveAll'
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
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
		})]
	});	



	/** main Model 정의 
	 */
	Unilite.defineModel('s_bpr600ukrv_mitModel', {
		fields: [
			{name: '_EXCEL_JOBID'	, text: 'EXCEL_JOBID'	, type: 'string'},
			{name: '_EXCEL_ROWNUM'	, text: '순번'			, type: 'int'},
			{name: 'DIV_CODE'		, text: 'DIV_CODE'		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'	, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.base.itemname" default="품목명"/>'	, type: 'string'},
			{name: 'B'				, text: 'B'				, type: 'string'},
			{name: 'C'				, text: 'C'				, type: 'string'},
			{name: 'D'				, text: 'D'				, type: 'string'},
			{name: 'E'				, text: 'E'				, type: 'string'},
			{name: 'F'				, text: 'F'				, type: 'string'},
			{name: 'G'				, text: 'G'				, type: 'string'},
			{name: 'H'				, text: 'H'				, type: 'string'},
			{name: 'I'				, text: 'I'				, type: 'string'},
			{name: 'J'				, text: 'J'				, type: 'string'},
			{name: 'K'				, text: 'K'				, type: 'string'},
			{name: 'L'				, text: 'L'				, type: 'string'},
			{name: 'M'				, text: 'M'				, type: 'string'},
			{name: 'N'				, text: 'N'				, type: 'string'},
			{name: 'O'				, text: 'O'				, type: 'string'},
			{name: 'P'				, text: 'P'				, type: 'string'},
			{name: 'Q'				, text: 'Q'				, type: 'string'},
			{name: 'R'				, text: 'R'				, type: 'string'},
			{name: 'S'				, text: 'S'				, type: 'string'},
			{name: 'T'				, text: 'T'				, type: 'string'},
			{name: 'U'				, text: 'U'				, type: 'string'},
			{name: 'V'				, text: 'V'				, type: 'string'},
			{name: 'W'				, text: 'W'				, type: 'string'},
			{name: 'X'				, text: 'X'				, type: 'string'},
			{name: 'Y'				, text: 'Y'				, type: 'string'},
			{name: 'Z'				, text: 'Z'				, type: 'string'},
			{name: 'AA'				, text: 'AA'			, type: 'string'},
			{name: 'AB'				, text: 'AB'			, type: 'string'},
			{name: 'AC'				, text: 'AC'			, type: 'string'},
			{name: 'AD'				, text: 'AD'			, type: 'string'},
			{name: 'AE'				, text: 'AE'			, type: 'string'},
			{name: 'AF'				, text: 'AF'			, type: 'string'},
			{name: 'AG'				, text: 'AG'			, type: 'string'},
			{name: 'AH'				, text: 'AH'			, type: 'string'},
			{name: 'AI'				, text: 'AI'			, type: 'string'},
			{name: 'AJ'				, text: 'AJ'			, type: 'string'},
			{name: 'AK'				, text: 'AK'			, type: 'string'},
			{name: 'AL'				, text: 'AL'			, type: 'string'},
			{name: 'AM'				, text: 'AM'			, type: 'string'},
			{name: 'AN'				, text: 'AN'			, type: 'string'},
			{name: 'AO'				, text: 'AO'			, type: 'string'},
			{name: 'AP'				, text: 'AP'			, type: 'string'},
			{name: 'AQ'				, text: 'AQ'			, type: 'string'},
			{name: 'AR'				, text: 'AR'			, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 */
	var directMasterStore = Unilite.createStore('s_bpr600ukrv_mitMasterStore1',{
		model	: 's_bpr600ukrv_mitModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
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
				var grid = Ext.getCmp('s_bpr600ukrv_mitGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	/** Master Grid 정의(Grid Panel)
	 */
	var masterGrid = Unilite.createGrid('s_bpr600ukrv_mitGrid', {
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
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'ITEM_CODE'		, width: 100},
			{dataIndex: 'ITEM_NAME'		, width: 250},
			{dataIndex: 'B'				, width: 90},
			{dataIndex: 'C'				, width: 90},
			{dataIndex: 'D'				, width: 90},
			{dataIndex: 'E'				, width: 90},
			{dataIndex: 'F'				, width: 90},
			{dataIndex: 'G'				, width: 90},
			{dataIndex: 'H'				, width: 90},
			{dataIndex: 'I'				, width: 90},
			{dataIndex: 'J'				, width: 90},
			{dataIndex: 'K'				, width: 90},
			{dataIndex: 'L'				, width: 90},
			{dataIndex: 'M'				, width: 90},
			{dataIndex: 'N'				, width: 90},
			{dataIndex: 'O'				, width: 90},
			{dataIndex: 'P'				, width: 90},
			{dataIndex: 'Q'				, width: 90},
			{dataIndex: 'R'				, width: 90},
			{dataIndex: 'S'				, width: 90},
			{dataIndex: 'T'				, width: 90},
			{dataIndex: 'U'				, width: 90},
			{dataIndex: 'V'				, width: 90},
			{dataIndex: 'W'				, width: 90},
			{dataIndex: 'X'				, width: 90},
			{dataIndex: 'Y'				, width: 90},
			{dataIndex: 'Z'				, width: 90},
			{dataIndex: 'AA'			, width: 90},
			{dataIndex: 'AB'			, width: 90},
			{dataIndex: 'AC'			, width: 90},
			{dataIndex: 'AD'			, width: 90},
			{dataIndex: 'AE'			, width: 90},
			{dataIndex: 'AF'			, width: 90},
			{dataIndex: 'AG'			, width: 90},
			{dataIndex: 'AH'			, width: 90},
			{dataIndex: 'AI'			, width: 90},
			{dataIndex: 'AJ'			, width: 90},
			{dataIndex: 'AK'			, width: 90},
			{dataIndex: 'AL'			, width: 90},
			{dataIndex: 'AM'			, width: 90},
			{dataIndex: 'AN'			, width: 90},
			{dataIndex: 'AO'			, width: 90},
			{dataIndex: 'AP'			, width: 90},
			{dataIndex: 'AQ'			, width: 90},
			{dataIndex: 'AR'			, width: 90},
			{dataIndex: '_EXCEL_JOBID'	, width: 90	, hidden: true},
			{dataIndex: '_EXCEL_ROWNUM'	, width: 90	, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if(UniUtils.indexOf(e.field, ['DIV_CODE', 'ITEM_CODE', 'ITEM_NAME'])) {
						return false;
					} else {
						return true;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['DIV_CODE', 'ITEM_CODE', 'ITEM_NAME'])) {
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
				excelConfigName: 's_bpr600ukrv_mit',
				width	: 600,
				height	: 400,
				modal	: false,
				extParam: {
					'PGM_ID'	: 's_bpr600ukrv_mit',
					'DIV_CODE'	: panelResult.getValue('DIV_CODE')
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid01',
						title		: '제품라벨정보',
						useCheckbox	: false,
						model		: 's_bpr600ukrv_mitModel',
						readApi		: 's_bpr600ukrv_mitService.selectExcelUploadSheet',
						columns		: [
							{dataIndex: 'DIV_CODE'	, width: 100, hidden: true},
							{dataIndex: 'ITEM_CODE'	, width: 100},
							{dataIndex: 'ITEM_NAME'	, width: 160},
							{dataIndex: 'B'			, width: 90},
							{dataIndex: 'C'			, width: 90},
							{dataIndex: 'D'			, width: 90},
							{dataIndex: 'E'			, width: 90},
							{dataIndex: 'F'			, width: 90},
							{dataIndex: 'G'			, width: 90},
							{dataIndex: 'H'			, width: 90},
							{dataIndex: 'I'			, width: 90},
							{dataIndex: 'J'			, width: 90},
							{dataIndex: 'K'			, width: 90},
							{dataIndex: 'L'			, width: 90},
							{dataIndex: 'M'			, width: 90},
							{dataIndex: 'N'			, width: 90},
							{dataIndex: 'O'			, width: 90},
							{dataIndex: 'P'			, width: 90},
							{dataIndex: 'Q'			, width: 90},
							{dataIndex: 'R'			, width: 90},
							{dataIndex: 'S'			, width: 90},
							{dataIndex: 'T'			, width: 90},
							{dataIndex: 'U'			, width: 90},
							{dataIndex: 'V'			, width: 90},
							{dataIndex: 'W'			, width: 90},
							{dataIndex: 'X'			, width: 90},
							{dataIndex: 'Y'			, width: 90},
							{dataIndex: 'Z'			, width: 90},
							{dataIndex: 'AA'		, width: 90},
							{dataIndex: 'AB'		, width: 90},
							{dataIndex: 'AC'		, width: 90},
							{dataIndex: 'AD'		, width: 90},
							{dataIndex: 'AE'		, width: 90},
							{dataIndex: 'AF'		, width: 90},
							{dataIndex: 'AG'		, width: 90},
							{dataIndex: 'AH'		, width: 90},
							{dataIndex: 'AI'		, width: 90},
							{dataIndex: 'AJ'		, width: 90},
							{dataIndex: 'AK'		, width: 90},
							{dataIndex: 'AL'		, width: 90},
							{dataIndex: 'AM'		, width: 90},
							{dataIndex: 'AN'		, width: 90},
							{dataIndex: 'AO'		, width: 90},
							{dataIndex: 'AP'		, width: 90},
							{dataIndex: 'AQ'		, width: 90},
							{dataIndex: 'AR'		, width: 90}
						]
					}
				],
				listeners: {
					beforeshow: function( panel, eOpts ) {
						this.down('#grid01').getStore().sort({property : '_EXCEL_ROWNUM', direction: 'ASC'});
					},
					close: function() {
						var me		= this;
						var grid	= this.down('#grid01');
						excelWindow.getEl().unmask();
						grid.getStore().removeAll();
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
		id			: 's_bpr600ukrv_mitApp',
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
		},
		onQueryButtonDown : function() {
			if(!panelResult.getInvalidMessage()){
				return false;
			}
			directMasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('save', false);
		},
		onResetButtonDown: function() {// 새로고침 버튼
			panelResult.clearForm();
			directMasterStore.loadData({});
			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save', false);
		},
//		onNewDataButtonDown: function() {
//			var divCode = panelResult.getValue('DIV_CODE');
//			var r = {
//				DIV_CODE: divCode
//			};
//			masterGrid.createRow(r);
//		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		}
	});
};
</script>
