<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mba033ukrv">
	<t:ExtComboStore comboType="BOR120" />							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />				<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />				<!-- 단위 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="mba033ukrvLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="mba033ukrvLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="mba033ukrvLevel3Store" />
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {	
	var excelWindow; 				//구매단가 업로드 윈도우 생성
	var copyWindow; 				//구매단가 복사 윈도우 생성
	var BsaCodeInfo = {
		gsMoneyUnit: '${gsMoneyUnit}'
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'mba033ukrvService.selectList',
			update	: 'mba033ukrvService.updateList',
			create	: 'mba033ukrvService.insertList',
			destroy	: 'mba033ukrvService.deleteList',
			syncAll	: 'mba033ukrvService.saveAll'
		}
	});

	
	
	
	Unilite.defineModel('mba033ukrvModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'		, comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		, type: 'string'		, allowBlank: false},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'		, allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'ITEM_P'				, text: '<t:message code="system.label.purchase.price" default="단가"/>'				, type: 'uniUnitPrice'	, allowBlank: false},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'			, type: 'string'		, comboType: 'AU'	, comboCode: 'B004'	, displayField: 'value'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		, type: 'string'		, comboType: 'AU'	, comboCode: 'B013'	, displayField: 'value'},
			{name: 'APLY_START_DATE'	, text: '<t:message code="system.label.purchase.applystartdate" default="적용시작일"/>'	, type: 'uniDate'		, allowBlank: false},
			{name: 'APLY_END_DATE'		, text: '<t:message code="system.label.purchase.applyenddate" default="적용종료일"/>'	, type: 'uniDate'		, allowBlank: false},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'}
		]
	});

	// 엑셀업로드 window의 Grid Model
	Unilite.Excel.defineModel('excel.mba033ukrv.sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'		, text: 'EXCEL_JOBID'	, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		, type: 'string'		, allowBlank: false},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'		, allowBlank: false},
			{name: 'ITEM_P'				, text: '<t:message code="system.label.purchase.price" default="단가"/>'				, type: 'uniUnitPrice'	, allowBlank: false},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'			, type: 'string'		, comboType: 'AU'	, comboCode: 'B004'	, displayField: 'value'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		, type: 'string'		, comboType: 'AU'	, comboCode: 'B013'	, displayField: 'value'},
			{name: 'APLY_START_DATE'	, text: '<t:message code="system.label.purchase.applystartdate" default="적용시작일"/>'	, type: 'uniDate'		, allowBlank: false},
			{name: 'APLY_END_DATE'		, text: '<t:message code="system.label.purchase.applyenddate" default="적용종료일"/>'	, type: 'uniDate'		, allowBlank: false}
		]
	});
	
	
	
	
	
	var masterStore = Unilite.createStore('mba033ukrvMasterStore',{
		model	: 'mba033ukrvModel',
	 	autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
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
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelResult.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelResult.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_CODE', '');
								}
							},
				            applyextparam: function(popup){
				            	popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
								popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				            	}
				}/*,
				validateBlank	: false,
				extParam		: {'CUSTOM_TYPE':'3'}*/
		}), 
			Unilite.popup('ITEM',{
				fieldLabel		: '<t:message code="system.label.purchase.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE', 
				textFieldName	: 'ITEM_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelResult.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('ITEM_CODE', '');
								}
							},
							applyextparam: function(popup){	// 2021.08 표준화 작업
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
					}					
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
					}
				}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 3 0',
			colspan	: 2,
			items	: [{
				fieldLabel	: '<t:message code="system.label.purchase.itemgroup" default="품목분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('mba033ukrvLevel1Store'),
				child		: 'ITEM_LEVEL2',
				width		: 200
			}, {
				fieldLabel	: '',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('mba033ukrvLevel2Store'),
				child		: 'ITEM_LEVEL3',
				width		: 100
				
			 }, {
			 	fieldLabel	: '',
			 	name		: 'ITEM_LEVEL3',
			 	xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('mba033ukrvLevel3Store'),
				width		: 100
			}]
		}]	
	});

	
	
	
	var masterGrid = Unilite.createGrid('mba033ukrvGrid', {
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
			text	: '<t:message code="system.label.purchase.excelupload" default="엑셀 업로드"/>',
			width	: 100,
			handler	: function() {
				openExcelWindow();
			}
		},{
			text	: '<t:message code="system.label.purchase.unitpricecopy" default="단가 복사"/>',
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
							popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
							popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
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
							popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
							popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
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
								grdRecord.set('ORDER_UNIT'	,records[0]['ORDER_UNIT']);	
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
			{dataIndex: 'ITEM_NAME'			, width: 133	,
				editor: Unilite.popup('DIV_PUMOK_G',{
		         	autoPopup: true,
					listeners:{ 
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE'	,records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME'	,records[0]['ITEM_NAME']);
								grdRecord.set('SPEC'		,records[0]['SPEC']);	
								grdRecord.set('ORDER_UNIT'	,records[0]['ORDER_UNIT']);
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
	  			if (UniUtils.indexOf(e.field, ['SPEC'])){
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
		id			: 'mba033ukrvApp',
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
				APLY_END_DATE	: '29991231',
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
			if(confirm('<t:message code="system.message.purchase.message025" default="변경된 내용을 저장하시겠습니까?"/>')){
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
				excelConfigName: 'mba033ukrv',
				width	: 600,
				height	: 400,
				modal	: false,
				extParam: { 
					'PGM_ID'	: 'mba033ukrv',
					'DIV_CODE'	: panelResult.getValue('DIV_CODE')
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid01',
						title		: '<t:message code="system.label.purchase.purchaseprice" default="구매단가"/>' + '<t:message code="system.label.purchase.excelupload" default="엑셀 업로드"/>',
						useCheckbox	: false,
						model		: 'excel.mba033ukrv.sheet01',
						readApi		: 'mba033ukrvService.selectExcelUploadSheet1',
						columns		: [	
							{dataIndex: '_EXCEL_JOBID'		, width: 80		, hidden: true},
							{dataIndex: 'COMP_CODE'			, width: 93		, hidden: true},
							{dataIndex: 'DIV_CODE'			, width: 93		, hidden: true},
							{dataIndex: 'CUSTOM_CODE'		, width: 100},
							{dataIndex: 'CUSTOM_NAME'		, width: 133},
							{dataIndex: 'ITEM_CODE'			, width: 100},
							{dataIndex: 'ITEM_P'			, width: 100},
							{dataIndex: 'MONEY_UNIT'		, width: 93		, align: 'center'},
							{dataIndex: 'ORDER_UNIT'		, width: 93		, align: 'center'},
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
					excelWindow.getEl().mask('<t:message code="system.label.purchase.loading" default="로딩중..."/>','loading-indicator');
					var me		= this;
					var grid	= this.down('#grid01');
					var records	= grid.getStore().getAt(0);	
					if (!Ext.isEmpty(records)) {
						var param	= {
							"_EXCEL_JOBID"	: records.get('_EXCEL_JOBID')
						};
						excelUploadFlag = "Y"
						mba033ukrvService.selectExcelUploadSheet1(param, function(provider, response){
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
						text	: '<t:message code="system.label.commonJS.excel.btnUpload" default="업로드"/>',
						tooltip	: '<t:message code="system.label.commonJS.excel.btnUpload" default="업로드"/>', 
						width	: 60,
						handler: function() {
							me.jobID = null;
							me.uploadFile();
						}
					},{
						xtype	: 'button',
						text	: '<t:message code="system.label.purchase.apply" default="적용"/>',
						tooltip	: '<t:message code="system.label.purchase.apply" default="적용"/>',  
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
								alert('<t:message code="system.message.commonJS.excel.rowErrorText" default="에러가 있는 행은 적용이 불가능합니다."/>');
							}
						}
					},{
							xtype: 'tbspacer'	
					},{
							xtype: 'tbseparator'	
					},{
							xtype: 'tbspacer'	
					},{
						xtype	: 'button',
						text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
						tooltip	: '<t:message code="system.label.purchase.close" default="닫기"/>', 
						handler	: function() { 
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
	
	
	//단가 엑셀업로드 윈도우 생성 함수
	function openCopyWindow() {
		if(!copyWindow) {
			copyWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.purchase.purchase2" default="구매"/>' + '<t:message code="system.label.purchase.unitpricecopy" default="단가 복사"/>',
				width	: 400,
				height	: 155,
				layout	: {type:'vbox', align:'stretch'},
				
				items	: [copyForm],
				tbar	: [
					'->',
					{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.purchase.unitpricecopy" default="단가 복사"/>',
					handler	: function() {
						if(Ext.isEmpty(copyForm.getValue('ORI_CUSTOM_CODE'))){
							alert('<t:message code="system.message.purchase.message100" default="단가 복사할 원본 거래처를 선택하세요."/>');
							return false;
						}
						if(Ext.isEmpty(copyForm.getValue('OBJ_CUSTOM_CODE'))){
							alert('<t:message code="system.message.purchase.message101" default="단가 복사할 대상 거래처를 선택하세요."/>');
							return false;
						}
						
						copyForm.getEl().mask('<t:message code="system.label.purchase.loading" default="로딩중..."/>','loading-indicator');
						
						var param = {
							DIV_CODE		: panelResult.getValue('DIV_CODE'),
							ORI_CUSTOM_CODE	: copyForm.getValue('ORI_CUSTOM_CODE'),
							OBJ_CUSTOM_CODE	: copyForm.getValue('OBJ_CUSTOM_CODE')
						};
						mba033ukrvService.copyItemPrice(param, function(provider, response){
							if(provider == 0) {
                        		UniAppManager.updateStatus('<t:message code="system.message.purchase.message102" default="단가 복사가 완료 되었습니다."/>');
							}
	                        copyForm.getEl().unmask();
							copyWindow.hide();
							UniAppManager.app.onQueryButtonDown();
						});
					},
					disabled: false
				},{
						xtype: 'tbspacer'	
				},{
						xtype: 'tbseparator'	
				},{
						xtype: 'tbspacer'	
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler	: function() {
						copyWindow.hide();
					},
					disabled: false
				}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						 copyForm.clearForm();
					},
					beforeclose: function( panel, eOpts )  {
						 copyForm.clearForm()
					},
					beforeshow: function ( me, eOpts ) {
					}
				}
			})
		}
		copyWindow.center();
		copyWindow.show();
	}
	
	//구매단가 복사 Form
	var copyForm = Unilite.createSearchForm('copyForm', {
		layout	:  {type : 'uniTable', columns : 2, tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}/*, tdAttrs: {style: 'border : 1px solid #ced9e7;', valign:'top'}*/},
		items	:[  
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.purchase.sourcecustom" default="원본 거래처"/>',
				valueFieldName	: 'ORI_CUSTOM_CODE',
				textFieldName	: 'ORI_CUSTOM_NAME,',
				colspan			: 2,
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
					}
				}/*,
				validateBlank	: false,
				extParam		: {'CUSTOM_TYPE':'3'}*/
			}),{
				xtype		: 'component',
				width		: 30
			},{ 
				xtype		: 'component',
				name		: 'COPY_ITEM_P',
				itemId		: 'COPY_ITEM_P',
				align		: 'center',
				padding		: '0 0 0 100',
				height		: 18,
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
//								alert('단가 복사할 원본 거래처를 선택하세요.');
//								return false;
//							}
//							if(Ext.isEmpty(copyForm.getValue('OBJ_CUSTOM_CODE'))){
//								alert('단가 복사할 대상 거래처를 선택하세요.');
//								return false;
//							}
//							
//							copyForm.getEl().mask('로딩중...','loading-indicator');
//							
//							var param = {
//								DIV_CODE		: panelResult.getValue('DIV_CODE'),
//								ORI_CUSTOM_CODE	: copyForm.getValue('ORI_CUSTOM_CODE'),
//								OBJ_CUSTOM_CODE	: copyForm.getValue('OBJ_CUSTOM_CODE')
//							};
//							mba033ukrvService.copyItemPrice(param, function(provider, response){
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
				fieldLabel		: '<t:message code="system.label.purchase.targetcustom" default="대상 거래처"/>',
				valueFieldName	: 'OBJ_CUSTOM_CODE',
				textFieldName	: 'OBJ_CUSTOM_NAME',
				colspan			: 2,
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
					}
				}/*,
				validateBlank	: false,
				extParam		: {'CUSTOM_TYPE':'3'}*/
			})
		]
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
								rv = '<t:message code="system.message.purchase.message098" default="적용 시작일은 종료일 보다 늦을 수 없습니다."/>';
							}
						}
					}
				break;
				
				case "APLY_END_DATE" :		// 적용 종료일
					var aplyEndDate = UniDate.getDbDateStr(newValue);
					if(aplyEndDate.length == 8) {
						var aplyStartDate = UniDate.getDbDateStr(record.get('APLY_START_DATE'));
						if (aplyEndDate < aplyStartDate) {
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