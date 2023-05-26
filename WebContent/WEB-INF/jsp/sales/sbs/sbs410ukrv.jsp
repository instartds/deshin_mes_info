<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sbs410ukrv">
	<t:ExtComboStore comboType="BOR120" />							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />				<!-- 단위 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="sbs410ukrvLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="sbs410ukrvLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="sbs410ukrvLevel3Store" />
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var excelWindow; 				//거래처 품목정보 업로드 윈도우 생성
	var copyWindow; 				//거래처 품목정보 복사 윈도우 생성 (사용시 주석 해제)
	var BsaCodeInfo = {
		gsMoneyUnit: '${gsMoneyUnit}'
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sbs410ukrvService.selectList',
			update	: 'sbs410ukrvService.updateList',
			create	: 'sbs410ukrvService.insertList',
			destroy	: 'sbs410ukrvService.deleteList',
			syncAll	: 'sbs410ukrvService.saveAll'
		}
	});




	Unilite.defineModel('sbs410ukrvModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'			, type: 'string'		, allowBlank: false},
			{name: 'TYPE'				, text: 'TYPE'			, type: 'string'		, allowBlank: false},	//'2'
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'			, type: 'string'		, comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string'		, allowBlank: false},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'			, type: 'string'		, allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'APLY_START_DATE'	, text: '적용 시작일'		, type: 'uniDate'		, allowBlank: false},
			{name: 'APLY_END_DATE'		, text: '적용 종료일'		, type: 'uniDate'/*		, allowBlank: false*/},
			{name: 'CUSTOM_ITEM_CODE'	, text: '<t:message code="system.label.sales.item" default="품목"/>'			, type: 'string'		, allowBlank: false},		//거래처품목코드
			{name: 'CUSTOM_ITEM_NAME'	, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'		, allowBlank: false},		//거래처품명
			{name: 'CUSTOM_ITEM_SPEC'	, text: '<t:message code="system.label.sales.spec" default="규격"/>'			, type: 'string'},				//거래처규격
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'			, type: 'string'		, comboType: 'AU'	, comboCode: 'B013', displayField: 'value'},
			{name: 'ORDER_P'			, text: '<t:message code="system.label.sales.sellingprice" default="판매단가"/>'			, type: 'uniUnitPrice'},
			{name: 'TRNS_RATE'			, text: '변환계수'			, type: 'uniPercent'},
			{name: 'ORDER_PRSN'			, text: '담당'			, type: 'string'},
			{name: 'MAKER_NAME'			, text: '메이커명'			, type: 'string'},
			{name: 'AGREE_DATE'			, text: '승인일'			, type: 'uniDate'},
			{name: 'ORDER_RATE'			, text: 'ORDER_RATE'	, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.sales.remarks" default="비고"/>'			, type: 'string'},
			{name: 'BASIS_P'			, text: '<t:message code="system.label.sales.basisprice" default="기준단가"/>'			, type: 'uniUnitPrice'},
			{name: 'AGENT_P'			, text: '자거래처단가'		, type: 'uniUnitPrice'}
		]
	});

	// 엑셀업로드 window의 Grid Model
	Unilite.Excel.defineModel('excel.sbs410ukrv.sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'		, text: 'EXCEL_JOBID'	, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'			, type: 'string'		, allowBlank: false},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'CUSTOM_ITEM_CODE'	, text: '거래처품목코드'		, type: 'string'},				//거래처품목코드
			{name: 'CUSTOM_ITEM_NAME'	, text: '거래처품목명'		, type: 'string'},				//거래처품명
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'			, type: 'string'		, allowBlank: false},
			{name: 'ORDER_P'			, text: '<t:message code="system.label.sales.price" default="단가"/>'			, type: 'uniUnitPrice'	, allowBlank: false},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'			, type: 'string'		, comboType: 'AU'	, comboCode: 'B013', displayField: 'value'},
			{name: 'APLY_START_DATE'	, text: '적용 시작일'		, type: 'uniDate'		, allowBlank: false},
			{name: 'APLY_END_DATE'		, text: '적용 종료일'		, type: 'uniDate'		, allowBlank: false}
		]
	});





	var masterStore = Unilite.createStore('sbs410ukrvMasterStore',{
		model	: 'sbs410ukrvModel',
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
						popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'        : ['1','3']});
					}
				}
		}),
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners: {
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
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}

		}),{
			fieldLabel	: ' ',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '현재적용',
				name		: 'rdoSelect',
				inputValue	: 'C',
				width		: 90,
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
            xtype		: 'uniTextfield',
            name		: 'CUSTOM_ITEM',
            fieldLabel	: '거래처 품목',
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
				store		: Ext.data.StoreManager.lookup('sbs410ukrvLevel1Store'),
				child		: 'ITEM_LEVEL2',
				width		: 200
			}, {
				fieldLabel	: '',
				name		: 'ITEM_LEVEL2',
				xtype		:'uniCombobox',
				store		: Ext.data.StoreManager.lookup('sbs410ukrvLevel2Store'),
				child		: 'ITEM_LEVEL3',
				width		: 100

			 }, {
			 	fieldLabel	: '',
			 	name		: 'ITEM_LEVEL3',
			 	xtype		:'uniCombobox',
				store		: Ext.data.StoreManager.lookup('sbs410ukrvLevel3Store'),
				width		: 100
			}]
		}]
	});




	var masterGrid = Unilite.createGrid('sbs410ukrvGrid', {
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
			text	: '품목 업로드',
			width	: 100,
			handler	: function() {
				openExcelWindow();
			}
		},{
			text	: '거래처품목 복사',
			handler	: function() {
				openCopyWindow();
			}
		}],
		columns:[
			{dataIndex: 'COMP_CODE'			, width: 93		, hidden: true},
			{dataIndex: 'TYPE'				, width: 93		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 93		, hidden: true},
			{text	: '고객정보',
				columns: [
					{dataIndex: 'CUSTOM_CODE'		, width: 100	,
					  'editor': Unilite.popup('AGENT_CUST_G',{
					  	 	textFieldName	: 'CUSTOM_CODE',
					  	 	DBtextFieldName	: 'CUSTOM_CODE',
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
							  	}
					  	 	}
						}),
                        listeners       : {
                            applyextparam: function(popup){
                                popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','3']});
                                popup.setExtParam({'CUSTOM_TYPE'        : ['1','3']});
                            }
                        }
					},
					{dataIndex: 'CUSTOM_NAME'		, width: 133	,
					  'editor': Unilite.popup('AGENT_CUST_G',{
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
								}
					  	 	}
						}),
                        listeners       : {
                            applyextparam: function(popup){
                                popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','3']});
                                popup.setExtParam({'CUSTOM_TYPE'        : ['1','3']});
                            }
                        }
					},
					{dataIndex: 'CUSTOM_ITEM_CODE'	, width: 100	},
					{dataIndex: 'CUSTOM_ITEM_NAME'	, width: 133	},
					{dataIndex: 'CUSTOM_ITEM_SPEC'	, width: 250		, hidden: true}
				]
			},
			{text	: '품목정보',
				columns: [
					{dataIndex: 'ITEM_CODE'			, width: 100	,
						editor: Unilite.popup('ITEM_G',{
							textFieldName	: 'ITEM_CODE',
							DBtextFieldName	: 'ITEM_CODE',
					  	 	autoPopup		: true,
							listeners		: {
								'onSelected': {
									fn: function(records, type  ){
										var grdRecord = masterGrid.uniOpt.currentRecord;
										grdRecord.set('ITEM_CODE'	,records[0]['ITEM_CODE']);
										grdRecord.set('ITEM_NAME'	,records[0]['ITEM_NAME']);
										grdRecord.set('ORDER_UNIT'	,records[0]['SALE_UNIT']);
									},
									scope: this
								},
								'onClear' : function(type)  {
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('ITEM_CODE'	,'');
									grdRecord.set('ITEM_NAME'	,'');
									grdRecord.set('ORDER_UNIT'	,'');
								}
							}
						})
					},
					{dataIndex: 'ITEM_NAME'			, width: 133	,
						editor: Unilite.popup('ITEM_G',{
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
								}
							}
						})
					},
					{dataIndex: 'ORDER_UNIT'		, width: 93, align: 'center'}
				]
			},
			{text	: '적용기간',
				columns: [
					{dataIndex: 'APLY_START_DATE'	, width: 100},
					{dataIndex: 'APLY_END_DATE'		, width: 100}
				]
			},
			{dataIndex: 'ORDER_P'			, width: 250		, hidden: true},
			{dataIndex: 'TRNS_RATE'			, width: 250		, hidden: true},
			{dataIndex: 'ORDER_PRSN'		, width: 250		, hidden: true},
			{dataIndex: 'MAKER_NAME'		, width: 250		, hidden: true},
			{dataIndex: 'AGREE_DATE'		, width: 250		, hidden: true},
			{dataIndex: 'ORDER_RATE'		, width: 250		, hidden: true},
			{dataIndex: 'REMARK'			, width: 250		, hidden: false},
			{dataIndex: 'BASIS_P'			, width: 250		, hidden: true},
			{dataIndex: 'AGENT_P'			, width: 250		, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (!e.record.phantom){
					if (UniUtils.indexOf(e.field, ['COMP_CODE', 'TYPE', 'DIV_CODE', 'CUSTOM_CODE', 'CUSTOM_NAME', 'ITEM_CODE', 'ITEM_NAME', 'ORDER_UNIT', 'APLY_START_DATE'])){
						return false;
					}
				}
				if (UniUtils.indexOf(e.field, ['COMP_CODE', 'TYPE', 'DIV_CODE', 'CUSTOM_ITEM_SPEC', 'ORDER_UNIT', 'ORDER_P', 'TRNS_RATE', 'ORDER_PRSN', 'MAKER_NAME', 'AGREE_DATE', 'ORDER_RATE', 'BASIS_P', 'AGENT_P'])){
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
		id			: 'sbs410ukrvApp',
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
				TYPE			: '2',							//구분(1:구매, 2:판매)
				DIV_CODE		: panelResult.getValue('DIV_CODE'),
				APLY_START_DATE	: new Date()//,
//				MONEY_UNIT		: UserInfo.currency
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



	//거래처 품목정보 엑셀업로드 윈도우 생성 함수
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
				excelConfigName: 'sbs410ukrv',
				width	: 600,
				height	: 400,
				modal	: false,
				extParam: {
					'PGM_ID'	: 'sbs410ukrv',
					'DIV_CODE'	: panelResult.getValue('DIV_CODE')
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid01',
						title		: '거래처 품목정보 엑셀업로드',
						useCheckbox	: false,
						model		: 'excel.sbs410ukrv.sheet01',
						readApi		: 'sbs410ukrvService.selectExcelUploadSheet1',
						columns		: [
							{dataIndex: '_EXCEL_JOBID'		, width: 80		, hidden: true},
							{dataIndex: 'COMP_CODE'			, width: 93		, hidden: true},
							{dataIndex: 'DIV_CODE'			, width: 93		, hidden: true},
							{dataIndex: 'CUSTOM_CODE'		, width: 100},
							{dataIndex: 'CUSTOM_NAME'		, width: 133},
							{dataIndex: 'CUSTOM_ITEM_CODE'	, width: 100},
							{dataIndex: 'CUSTOM_ITEM_NAME'	, width: 100},
							{dataIndex: 'ITEM_CODE'			, width: 100},
							{dataIndex: 'ORDER_P'			, width: 100},
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
						sbs410ukrvService.selectExcelUploadSheet1(param, function(provider, response){
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


	//거래처 품목정보 엑셀업로드 윈도우 생성 함수
    function openCopyWindow() {
        if(!copyWindow) {
            copyWindow = Ext.create('widget.uniDetailWindow', {
                title   : '거래처품목 복사',
                width   : 830,
                height  : 580,
//              width   : 400,
//              height  : 155,
                layout  : {type:'vbox', align:'stretch'},

                items   : [copyForm, objGrid],
                tbar    : [
                    '->',{
                    id      : 'queryBtn',
                    text    : '대상거래처 조회',
                    handler : function() {
                        objGridStore.loadStoreRecords();
                    }
                },{
                    id      : 'confirmBtn',
                    text    : '거래처품목 복사',
                    disabled: true,
                    handler : function() {
                        if(Ext.isEmpty(copyForm.getValue('ORI_CUSTOM_CODE'))){
                            Unilite.messageBox('복사할 원본 거래처를 선택하세요.');
                            return false;
                        }

                        copyForm.getEl().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');

                        var selRecords = objGrid.getSelectionModel().getSelection();
                        Ext.each(selRecords, function(selRecord, index) {
                            selRecord.set('DIV_CODE'        , copyForm.getValue('DIV_CODE'));
                            selRecord.set('ORI_CUSTOM_CODE' , copyForm.getValue('ORI_CUSTOM_CODE'));
                            selRecord.phantom           = true;
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
            {name: 'CUSTOM_CODE'    ,text: '거래처 코드'     , type: 'string'},
            {name: 'CUSTOM_NAME'    ,text: '거래처 명'      , type: 'string'}
        ]
    });
    //대상 거래처 STORE
    var objGridStore = Unilite.createStore('objGridStore', {
        model   : 'objGridModel',
        autoLoad: false,
        uniOpt  : {
            isMaster    : false,            // 상위 버튼 연결
            editable    : false,            // 수정 모드 사용
            deletable   : false,            // 삭제 가능 여부
            useNavi     : false             // prev | next 버튼 사용
        },
        proxy: {
            type: 'direct',
            api : {
                read    : 'sbs410ukrvService.selectObjCustom'
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
    var objGrid = Unilite.createGrid('sbs410ukrvObjGrid', {
        layout      : 'fit',
        store       : objGridStore,
        uniOpt      :{
            onLoadSelectFirst   : false,
            expandLastColumn    : true,
            useRowNumberer      : false
        },
        selModel    :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false,
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
        columns     : [{
                xtype       : 'rownumberer',
                sortable    : false,
                align       : 'center  !important',
                resizable   : true,
                width       : 35
            },
            { dataIndex: 'CUSTOM_CODE'  , width: 90 },
            { dataIndex: 'CUSTOM_NAME'  , width: 150}
        ] ,
        listeners: {
            onGridDblClick: function(grid, record, cellIndex, colName) {
            }
        }
    });
    //거래처거래처품목 복사 Form
    var copyForm = Unilite.createSearchForm('copyForm', {
        layout  :  {type : 'uniTable', columns : 2, tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}/*, tdAttrs: {style: 'border : 1px solid #ced9e7;', valign:'top'}*/},
        items   :[{
                fieldLabel  : '<t:message code="system.label.sales.division" default="사업장"/>',
                name        : 'DIV_CODE',
                xtype       : 'uniCombobox',
                comboType   : 'BOR120',
                hidden      : true,
                allowBlank  : false
            },
            Unilite.popup('AGENT_CUST',{
                fieldLabel      : '원본 거래처',
                valueFieldName  : 'ORI_CUSTOM_CODE',
                textFieldName   : 'ORI_CUSTOM_NAME,',
                allowBlank      : false,
                listeners       : {
                    applyextparam: function(popup){
                        popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','3']});
                        popup.setExtParam({'CUSTOM_TYPE'        : ['1','3']});
                    }
                }/*,
                validateBlank   : false,
                extParam        : {'CUSTOM_TYPE':'3'}*/
            }),{
                fieldLabel: '기준일자'  ,
                name: 'BASIS_DATE',
                xtype:'uniDatefield',
                value:new Date()
            },{
                xtype       : 'component',
                name        : 'COPY_ITEM_P',
                itemId      : 'COPY_ITEM_P',
                align       : 'center',
                padding     : '0 0 0 100',
                height      : 18,
                colspan     : 2,
                autoEl      : {
                    tag : 'img',
                    src : CPATH+'/resources/images/sales/arrow_down.png',
                    cls : 'photo-wrap'
                },
                listeners   : {
//                  click : {
//                      element : 'el',
//                      fn      : function( e, t, eOpts )   {
//                          if(Ext.isEmpty(copyForm.getValue('ORI_CUSTOM_CODE'))){
//                              Unilite.messageBox('단가 복사할 원본 거래처를 선택하세요.');
//                              return false;
//                          }
//                          if(Ext.isEmpty(copyForm.getValue('OBJ_CUSTOM_CODE'))){
//                              Unilite.messageBox('단가 복사할 대상 거래처를 선택하세요.');
//                              return false;
//                          }
//
//                          copyForm.getEl().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
//
//                          var param = {
//                              DIV_CODE        : panelResult.getValue('DIV_CODE'),
//                              ORI_CUSTOM_CODE : copyForm.getValue('ORI_CUSTOM_CODE'),
//                              OBJ_CUSTOM_CODE : copyForm.getValue('OBJ_CUSTOM_CODE')
//                          };
//                          sbs400ukrvService.copyItemPrice(param, function(provider, response){
//                              if(provider == 0) {
//                                  UniAppManager.updateStatus("단가 복사가 완료 되었습니다.");
//                              }
//                              copyForm.getEl().unmask();
//                          });
//                      }
//                  }
                }
            },
            Unilite.popup('AGENT_CUST',{
                fieldLabel      : '대상 거래처',
                valueFieldName  : 'OBJ_CUSTOM_CODE',
                textFieldName   : 'OBJ_CUSTOM_NAME',
                colspan         : 2,
                validateBlank   : false,
//                autoPopup       : true,
                listeners       : {
                    applyextparam: function(popup){
                        popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','3']});
                        popup.setExtParam({'CUSTOM_TYPE'        : ['1','3']});
                    }
                }/*,
                validateBlank   : false,
                extParam        : {'CUSTOM_TYPE':'3'}*/
            })
        ]
    });

	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create  : 'sbs410ukrvService.copyItem',
            syncAll : 'sbs410ukrvService.itemCopySaveAll'
        }
    });
    var buttonStore = Unilite.createStore('copyItemButtonStore',{
        uniOpt: {
            isMaster    : false,            // 상위 버튼 연결
            editable    : false,            // 수정 모드 사용
            deletable   : false,            // 삭제 가능 여부
            useNavi     : false             // prev | next 버튼 사용
        },
        proxy       : directButtonProxy,
        saveStore   : function() {
            var inValidRecs = this.getInvalidRecords();
            var toCreate    = this.getNewRecords();

            var paramMaster = copyForm.getValues();

            if(inValidRecs.length == 0) {
                config = {
                    params  : [paramMaster],
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