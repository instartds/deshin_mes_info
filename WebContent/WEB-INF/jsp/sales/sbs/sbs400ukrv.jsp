<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sbs400ukrv">
	<t:ExtComboStore comboType="BOR120" />							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />				<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />				<!-- 단위 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="sbs400ukrvLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="sbs400ukrvLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="sbs400ukrvLevel3Store" />
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var excelWindow; 				//판매단가 업로드 윈도우 생성
	var copyWindow; 				//판매단가 복사 윈도우 생성
	var BsaCodeInfo = {
		gsMoneyUnit: '${gsMoneyUnit}'
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sbs400ukrvService.selectList',
			update	: 'sbs400ukrvService.updateList',
			create	: 'sbs400ukrvService.insertList',
			destroy	: 'sbs400ukrvService.deleteList',
			syncAll	: 'sbs400ukrvService.saveAll'
		}
	});




	Unilite.defineModel('sbs400ukrvModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'		 	, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'		 	, type: 'string'		, comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'		 	, type: 'string'		, allowBlank: false},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		 	, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'		 	, type: 'string'		, allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		 	, type: 'string'},
			{name: 'ITEM_NAME1'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>1'		 	, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'		 	, type: 'string'},
			{name: 'ITEM_P'				, text: '<t:message code="system.label.sales.price" default="단가"/>'		 	, type: 'uniUnitPrice'	, allowBlank: false},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.sales.currency" default="화폐"/>'		 	, type: 'string'		, comboType: 'AU'	, comboCode: 'B004', displayField: 'value'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'		 	, type: 'string'		, comboType: 'AU'	, comboCode: 'B013', displayField: 'value'},
			{name: 'APLY_START_DATE'	, text: '적용 시작일'		, type: 'uniDate'		, allowBlank: false},
			{name: 'APLY_END_DATE'		, text: '적용 종료일'	 	, type: 'uniDate'		, allowBlank: false},
			{name: 'REMARK'				, text: '<t:message code="system.label.sales.remarks" default="비고"/>'		 	, type: 'string'}
		]
	});

	// 엑셀업로드 window의 Grid Model
	Unilite.Excel.defineModel('excel.sbs400ukrv.sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'		, text:'EXCEL_JOBID'	, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'		 	, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'		 	, type: 'string'		, allowBlank: false},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		 	, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'		 	, type: 'string'		, allowBlank: false},
			{name: 'ITEM_P'				, text: '<t:message code="system.label.sales.price" default="단가"/>'		 	, type: 'uniUnitPrice'	, allowBlank: false},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.sales.currency" default="화폐"/>'		 	, type: 'string'		, comboType: 'AU'	, comboCode: 'B004', displayField: 'value'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'		 	, type: 'string'		, comboType: 'AU'	, comboCode: 'B013', displayField: 'value'},
			{name: 'APLY_START_DATE'	, text: '적용 시작일'		, type: 'uniDate'		, allowBlank: false},
			{name: 'APLY_END_DATE'		, text: '적용 종료일'	 	, type: 'uniDate'		, allowBlank: false}
		]
	});





	var masterStore = Unilite.createStore('sbs400ukrvMasterStore',{
		model	: 'sbs400ukrvModel',
	 	autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
	 	proxy	: directProxy,
		loadStoreRecords : function()	{
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();

			if(inValidRecs.length == 0 )	{
				if(config == null)	{
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
		 		if(!Ext.isEmpty(records)){
	 			}
	 		},
			write: function(proxy, operation){
				if (operation.action == 'destroy') {
//					Ext.getCmp('detailForm').reset();
				}
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
//				detailForm.setActiveRecord(record);
			},
			remove: function( store, records, index, isMove, eOpts ) {
				if(store.count() == 0) {
//					detailForm.clearForm();
//					detailForm.disable();
				}
			}
		}
	});




	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false
		},
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}/*,
				validateBlank	: false,
				extParam		: {'CUSTOM_TYPE':'3'}*/
		}),
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						var divCode = panelResult.getValue('DIV_CODE');
						popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
					}
				}
		}),{
			fieldLabel	: ' ',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '현재적용단가',
				name		: 'rdoSelect',
				inputValue	: 'C',
				width		: 100,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
				name		: 'rdoSelect',
				inputValue	: 'A',
				width		: 80
			}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 3 0',
			colspan	: 2,
			items	: [{
				fieldLabel	: '품목분류',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('sbs400ukrvLevel1Store'),
				child		: 'ITEM_LEVEL2',
				width		: 200
			}, {
				fieldLabel	: '',
				name		: 'ITEM_LEVEL2',
				xtype		:'uniCombobox',
				store		: Ext.data.StoreManager.lookup('sbs400ukrvLevel2Store'),
				child		: 'ITEM_LEVEL3',
				width		: 100

			 }, {
			 	fieldLabel	: '',
			 	name		: 'ITEM_LEVEL3',
			 	xtype		:'uniCombobox',
				store		: Ext.data.StoreManager.lookup('sbs400ukrvLevel3Store'),
				width		: 100
			}]
		}]
	});




	var masterGrid = Unilite.createGrid('sbs400ukrvGrid', {
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
		tbar	: [{
			fieldLabel  : '종료일자',
			xtype	   : 'uniDatefield',
			id		  : 'aplyEndDate',
			labelWidth  : 53,
			width	   : 180,
			value	   : new Date(),
			listeners   : {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			text	: '일괄변경',
			xtype   : 'button',
			id	  : 'aplyEndChangeButton',
			disabled: false,
			margin : '0 10 0 0',
			handler : function() {
				var records = masterGrid.getStore().data.items;
				if(records.length > 0){
					var newYear = Ext.getCmp('aplyEndDate').getValue();
					if(Ext.isEmpty(newYear)){
						Unilite.messageBox('종료일자를 입력하십시요.');
						return false;
					}
					if(confirm('종료일자를 일괄 변경하시겠습니까?')){
						Ext.each(records, function(record, i){
							record.set("APLY_END_DATE" , newYear);
						});
					}
				} else {
					Unilite.messageBox('종료일자를 변경할 데이터가 없습니다.\n변경할 데이터를 선택하세요');
					return false;
				}
			}
		},{
			text	: '단가 업로드',
			width	: 100,
			handler	: function() {
				openExcelWindow();
			}
		},{
			text	: '단가 복사',
			width	: 100,
			handler	: function() {
				openCopyWindow();
			}
		}],
		columns:[
			{dataIndex: 'COMP_CODE'			, width: 93		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 93		, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 100	,
			  'editor': Unilite.popup('AGENT_CUST_G',{
			  	 	textFieldName	: 'CUSTOM_CODE',
			  	 	DBtextFieldName	: 'CUSTOM_CODE',
			  	 	allowBlank		: false,
		         	autoPopup		: true,
			  	 	listeners		: {
			  	 		'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
			  	 		},
			  	 		'onClear' : function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
					  	},
						'applyextparam': function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
							popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
						}
			  	 	}
				})
			},
			{dataIndex: 'CUSTOM_NAME'		, width: 133	,
			  'editor': Unilite.popup('AGENT_CUST_G',{
			  	 	allowBlank		: false,
		         	autoPopup		: true,
			  	 	listeners		: {
			  	 		'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
					  	'onClear' : function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						},
						'applyextparam': function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
							popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
						}
			  	 	}
				})
			},
			{dataIndex: 'ITEM_CODE'			, width: 100	,
				editor: Unilite.popup('DIV_PUMOK_G',{
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
		         	autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE'	,records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME'	,records[0]['ITEM_NAME']);
								grdRecord.set('SPEC'		,records[0]['SPEC']);
								grdRecord.set('ORDER_UNIT'	,records[0]['SALE_UNIT']);
							},
							scope: this
						},
						'onClear' : function(type)  {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'	,'');
							grdRecord.set('ITEM_NAME'	,'');
							grdRecord.set('SPEC'		,'');
							grdRecord.set('ORDER_UNIT'	,'');
						},
						'applyextparam': function(popup){
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 133	,
				editor: Unilite.popup('ITEM_G',{
		         	autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE'	,records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME'	,records[0]['ITEM_NAME']);
								grdRecord.set('SPEC'		,records[0]['SPEC']);
								grdRecord.set('ORDER_UNIT'	,records[0]['SALE_UNIT']);
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
			{dataIndex: 'ITEM_NAME1'		, width: 133, hidden: true},
			{dataIndex: 'SPEC'				, width: 93},
			{dataIndex: 'ITEM_P'			, width: 100},
			{dataIndex: 'MONEY_UNIT'		, width: 93, align: 'center'},
			{dataIndex: 'ORDER_UNIT'		, width: 93, align: 'center'},
			{dataIndex: 'APLY_START_DATE'	, width: 100},
			{dataIndex: 'APLY_END_DATE'		, width: 100},
			{dataIndex: 'REMARK'			, width: 250}
		],
		listeners: {
	  		beforeedit  : function( editor, e, eOpts ) {
	  			if (!e.record.phantom){
		  			if (UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE', 'CUSTOM_CODE', 'CUSTOM_NAME', 'ITEM_CODE', 'ITEM_NAME', 'MONEY_UNIT', 'ORDER_UNIT', 'APLY_START_DATE'])){
						return false;
					}
	  			}
	  			if (UniUtils.indexOf(e.field, ['SPEC', 'ITEM_NAME1'])){
					return false;
				}
	  		},
			selectionchangerecord:function(selected)	{
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
//				if(!record.phantom) {
//					switch(colName)	{
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
		id			: 'sbs400ukrvApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		}],

		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['newData'],true);

			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');

			this.setDefault();
		},

		onQueryButtonDown: function () {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterStore.loadStoreRecords();
		},

		onNewDataButtonDown : function()	{
			var r = {
				COMP_CODE		: UserInfo.compCode,
				DIV_CODE		: panelResult.getValue('DIV_CODE'),
				APLY_START_DATE	: new Date(),
				APLY_END_DATE	: '2999.12.31',
				MONEY_UNIT		: UserInfo.currency
			};
			masterGrid.createRow(r, null, masterStore.getCount() - 1);
		},

		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom == true)	{
				masterGrid.deleteSelectedRow();

			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {					//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				masterGrid.deleteSelectedRow();
			}
		},

		onSaveDataButtonDown: function (config) {
			//필수 입력값 체크
			if (!panelResult.getInvalidMessage()) {
				return false;
			}
			masterStore.saveStore(config);
		},

		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterStore.clearData();
			this.fnInitBinding();
		},

		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		},

		setDefault: function() {
	 		panelResult.setValue('DIV_CODE', 		UserInfo.divCode);
	 		panelResult.setValue('rdoSelect', 		'C');
		}

	});



	//단가 엑셀업로드 윈도우 생성 함수
	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';
		if(!masterStore.isDirty())	{									//화면에 저장할 내용이 있을 경우 저장여부 확인
			masterStore.loadData({});
		} else {
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
				masterStore.loadData({});
			}
		}
		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.DIV_CODE		= panelResult.getValue('DIV_CODE');
//			excelWindow.extParam.ISSUE_GUBUN	= Ext.getCmp('rdoSelect0').getChecked()[0].inputValue;
//			excelWindow.extParam.APPLY_YN		= Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue;
		}
		if(!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: 'sbs400ukrv',
				width	: 600,
				height	: 400,
				modal	: false,
				extParam: {
					'PGM_ID'	: 'sbs400ukrv',
					'DIV_CODE'	: panelResult.getValue('DIV_CODE')
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid01',
						title		: '판매단가 엑셀업로드',
						useCheckbox	: false,
						model		: 'excel.sbs400ukrv.sheet01',
						readApi		: 'sbs400ukrvService.selectExcelUploadSheet1',
						columns		: [
							{dataIndex: '_EXCEL_JOBID'		, width: 80		, hidden: true},
							{dataIndex: 'COMP_CODE'			, width: 93		, hidden: true},
							{dataIndex: 'DIV_CODE'			, width: 93		, hidden: true},
							{dataIndex: 'CUSTOM_CODE'		, width: 100},
							{dataIndex: 'CUSTOM_NAME'		, width: 133},
							{dataIndex: 'ITEM_CODE'			, width: 100},
							{dataIndex: 'ITEM_P'			, width: 100},
							{dataIndex: 'MONEY_UNIT'		, width: 93, align: 'center'},
							{dataIndex: 'ORDER_UNIT'		, width: 93, align: 'center'},
							{dataIndex: 'APLY_START_DATE'	, width: 100},
							{dataIndex: 'APLY_END_DATE'		, width: 100}
						]
					}
				],
				listeners: {
					close: function() {
						this.hide();
					}
				},

				onApply:function()	{
					excelWindow.getEl().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
					var me		= this;
					var grid	= this.down('#grid01');
					var records	= grid.getStore().getAt(0);
					if (!Ext.isEmpty(records)) {
						var param	= {
							"_EXCEL_JOBID"	: records.get('_EXCEL_JOBID')
						};
						excelUploadFlag = "Y"
						sbs400ukrvService.selectExcelUploadSheet1(param, function(provider, response){
							var store	= masterGrid.getStore();
							var records	= response.result;
							console.log("response",response);

							Ext.each(records, function(record, idx) {
								record.SEQ	= idx + 1;
								store.insert(i, record);
							});

							excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();
						});
						excelUploadFlag = "N"
					} else {
						alert (Msg.fSbMsgH0284);
						this.unmask();
					}

					//버튼세팅
	   				UniAppManager.setToolbarButtons('newData',	true);
	   				UniAppManager.setToolbarButtons('delete',	false);
				},

				//툴바 세팅
				_setToolBar: function() {
					var me = this;
					me.tbar = [
					'->',
					{
						xtype	: 'button',
						text	: '업로드',
						tooltip	: '업로드',
						width	: 60,
						handler: function() {
							me.jobID = null;
							me.uploadFile();
						}
					},{
						xtype	: 'button',
						text	: '적용',
						tooltip	: '적용',
						width	: 60,
						handler	: function() {
							var grids	= me.down('grid');
							var isError	= false;
							if(Ext.isDefined(grids.getEl()))	{
								grids.getEl().mask();
							}
							Ext.each(grids, function(grid, i){
								var records = grid.getStore().data.items;
								return Ext.each(records, function(record, i){
									if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
										console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
										isError = true;
										return false;
									}
								});
							});
							if(Ext.isDefined(grids.getEl()))	{
								grids.getEl().unmask();
							}
							if(!isError) {
								me.onApply();
							}else {
								Unilite.messageBox('<t:message code="system.message.commonJS.excel.rowErrorText" default="에러가 있는 행은 적용이 불가능합니다."/>');
							}
						}
					},{
							xtype: 'tbspacer'
					},{
							xtype: 'tbseparator'
					},{
							xtype: 'tbspacer'
					},{
						xtype: 'button',
						text : '<t:message code="system.label.sales.close" default="닫기"/>',
						tooltip : '<t:message code="system.label.sales.close" default="닫기"/>',
						handler: function() {
							var grid = me.down('#grid01');
							grid.getStore().removeAll();
							me.hide();
						}
					}
				]}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};




	//단가복사 윈도우 생성 함수
	function openCopyWindow() {
		if(!copyWindow) {
			copyWindow = Ext.create('widget.uniDetailWindow', {
				title	: '판매단가 복사',
				width	: 830,
				height	: 580,
//				width	: 400,
//				height	: 155,
				layout	: {type:'vbox', align:'stretch'},

				items	: [copyForm, objGrid],
				tbar	: [
					'->',{
					id		: 'queryBtn',
					text	: '대상거래처 조회',
					handler	: function() {
						objGridStore.loadStoreRecords();
					}
				},{
					id		: 'confirmBtn',
					text	: '단가 복사',
					disabled: true,
					handler	: function() {
						if(Ext.isEmpty(copyForm.getValue('ORI_CUSTOM_CODE'))){
							Unilite.messageBox('단가 복사할 원본 거래처를 선택하세요.');
							return false;
						}

						copyForm.getEl().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');

						var selRecords = objGrid.getSelectionModel().getSelection();
						Ext.each(selRecords, function(selRecord, index) {
							selRecord.set('DIV_CODE'		, copyForm.getValue('DIV_CODE'));
							selRecord.set('ORI_CUSTOM_CODE'	, copyForm.getValue('ORI_CUSTOM_CODE'));
							selRecord.phantom			= true;
							buttonStore.insert(index, selRecord);

							if (selRecords.length == index +1) {
								buttonStore.saveStore();
							}
						})
					}
				},{
						xtype: 'tbspacer'
				},{
						xtype: 'tbseparator'
				},{
						xtype: 'tbspacer'
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler: function() {
						copyWindow.hide();
					},
					disabled: false
				}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						copyForm.clearForm();
						objGrid.reset();
						objGridStore.clearData();
					},
					beforeclose: function( panel, eOpts )  {
						copyForm.clearForm();
						objGrid.reset();
						objGridStore.clearData();
					},
					beforeshow: function ( me, eOpts ) {
						copyForm.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
						copyForm.setValue('BASIS_DATE', UniDate.get('today'));
					}
				}
			})
		}
		copyWindow.center();
		copyWindow.show();
	}

	//대상 거래처 모델
	Unilite.defineModel('objGridModel', {
		fields: [
			{name: 'CUSTOM_CODE'	,text: '거래처 코드'		, type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '거래처 명'		, type: 'string'}
		]
	});
	//대상 거래처 STORE
	var objGridStore = Unilite.createStore('objGridStore', {
		model	: 'objGridModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false				// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read	: 'sbs400ukrvService.selectObjCustom'
			}
		},
		loadStoreRecords : function()  {
			var param = copyForm.getValues();

			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});
	//대상 거래처 그리드
	var objGrid = Unilite.createGrid('s_sof100ukrv_ypobjGrid', {
		layout		: 'fit',
		store		: objGridStore,
		uniOpt		:{
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: false
		},
		selModel	:	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if (this.selected.getCount()) {
						Ext.getCmp('confirmBtn').enable();
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					if (this.selected.getCount() == 0) {
						Ext.getCmp('confirmBtn').disable();
					}
				}
			}
		}),
		columns		: [{
				xtype		: 'rownumberer',
				sortable	: false,
				align		: 'center  !important',
				resizable	: true,
				width		: 35
			},
			{ dataIndex: 'CUSTOM_CODE'	, width: 90 },
			{ dataIndex: 'CUSTOM_NAME'	, width: 150}
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		}
	});
	//판매단가 복사 Form
	var copyForm = Unilite.createSearchForm('copyForm', {
		layout	:  {type : 'uniTable', columns : 2, tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}/*, tdAttrs: {style: 'border : 1px solid #ced9e7;', valign:'top'}*/},
		items	:[{
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				hidden		: true,
				allowBlank	: false
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '원본 거래처',
				valueFieldName	: 'ORI_CUSTOM_CODE',
				textFieldName	: 'ORI_CUSTOM_NAME,',
				allowBlank      : false,
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}/*,
				validateBlank	: false,
				extParam		: {'CUSTOM_TYPE':'3'}*/
			}),{
                fieldLabel: '기준일자'  ,
                name: 'BASIS_DATE',
                xtype:'uniDatefield',
                value:new Date()
			},{
				xtype		: 'component',
				name		: 'COPY_ITEM_P',
				itemId		: 'COPY_ITEM_P',
				align		: 'center',
				padding		: '0 0 0 100',
				height		: 18,
				colspan     : 2,
				autoEl		: {
					tag	: 'img',
					src	: CPATH+'/resources/images/sales/arrow_down.png',
					cls	: 'photo-wrap'
				},
				listeners	: {
//					click : {
//						element	: 'el',
//						fn		: function( e, t, eOpts )	{
//							if(Ext.isEmpty(copyForm.getValue('ORI_CUSTOM_CODE'))){
//								Unilite.messageBox('단가 복사할 원본 거래처를 선택하세요.');
//								return false;
//							}
//							if(Ext.isEmpty(copyForm.getValue('OBJ_CUSTOM_CODE'))){
//								Unilite.messageBox('단가 복사할 대상 거래처를 선택하세요.');
//								return false;
//							}
//
//							copyForm.getEl().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
//
//							var param = {
//								DIV_CODE		: panelResult.getValue('DIV_CODE'),
//								ORI_CUSTOM_CODE	: copyForm.getValue('ORI_CUSTOM_CODE'),
//								OBJ_CUSTOM_CODE	: copyForm.getValue('OBJ_CUSTOM_CODE')
//							};
//							sbs400ukrvService.copyItemPrice(param, function(provider, response){
//								if(provider == 0) {
//                            		UniAppManager.updateStatus("단가 복사가 완료 되었습니다.");
//								}
//		                        copyForm.getEl().unmask();
//							});
//						}
//					}
				}
  			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '대상 거래처',
				valueFieldName	: 'OBJ_CUSTOM_CODE',
				textFieldName	: 'OBJ_CUSTOM_NAME',
				colspan			: 2,
				validateBlank   : false,
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}/*,
				validateBlank	: false,
				extParam		: {'CUSTOM_TYPE':'3'}*/
			})
		]
	});


	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'sbs400ukrvService.copyItemPrice',
			syncAll	: 'sbs400ukrvService.itemPrice'
		}
	});
	var buttonStore = Unilite.createStore('copyItemPriceButtonStore',{
		uniOpt: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false				// prev | next 버튼 사용
		},
		proxy		: directButtonProxy,
		saveStore	: function() {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();

			var paramMaster = copyForm.getValues();

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success : function(batch, option) {
						copyForm.getEl().unmask();
						buttonStore.clearData();
					},
					failure: function(batch, option) {
						copyForm.getEl().unmask();
						buttonStore.clearData();
					}
				};
				this.syncAllDirect(config);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});



	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "APLY_START_DATE" :	// 적용 시작일
					var aplyStartDate = UniDate.getDbDateStr(newValue);
					if(aplyStartDate.length == 8) {
						if (!Ext.isEmpty(record.get('APLY_END_DATE'))) {
							var aplyEndDate = UniDate.getDbDateStr(record.get('APLY_END_DATE'));
							if (aplyStartDate > aplyEndDate) {
								rv = '적용 시작일은 종료일 보다 늦을 수 없습니다.';
							}
						}
					}
				break;

				case "APLY_END_DATE" :		// 적용 종료일
					var aplyEndDate = UniDate.getDbDateStr(newValue);
					if(aplyEndDate.length == 8) {
						var aplyStartDate = UniDate.getDbDateStr(record.get('APLY_START_DATE'));
						if (aplyEndDate < aplyStartDate) {
							rv = '적용 종료일은 시작일 보다 빠를 수 없습니다.';
						}
					}
				break;

			}
			return rv;
		}
	})

};
</script>