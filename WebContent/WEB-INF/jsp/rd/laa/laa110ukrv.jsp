<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="laa110ukrv">
	<t:ExtComboStore comboType="AU" comboCode="B001" /><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A004" /><!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /><!-- 단위 -->
	<t:ExtComboStore items="${regulation}" storeId="regulation" />
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>	
</t:appConfig>

<script type="text/javascript" >

var SearchInfoWindow;	// SearchInfoWindow : 검색창

function appMain(){
	/** directProxy 정의 (Service 정의)
	 * @type 
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'laa110ukrvService.selectList',
			update	: 'laa110ukrvService.updateMulti',
			create	: 'laa110ukrvService.insertMulti',
			destroy	: 'laa110ukrvService.deleteMulti',
			syncAll	: 'laa110ukrvService.saveAll'
		}
	});


	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('laa110ukrvMaterModel',{
		fields: [
			{name: 'COMP_CODE'			,text: '법인코드'		,type: 'string' ,allowBlank:false},		//법인코드'
			{name: 'ITEM_CODE'			,text: '품목코드'		,type: 'string' ,allowBlank:false},		//품목코드'
			{name: 'ITEM_NAME'			,text: '품명'			,type: 'string'},						//품명'
			{name: 'ITEM_NAME1'			,text: '품명1'		,type: 'string'},						//품명1'
			{name: 'ITEM_NAME2'			,text: '품명2'		,type: 'string'},						//품명2'
			{name: 'CHEMICAL_CODE'		,text: '성분코드'		,type: 'string' ,allowBlank:false},		//성분코드'
			{name: 'CHEMICAL_NAME'		,text: '한글명'		,type: 'string'},						//성분명_한글'
			{name: 'CHEMICAL_NAME_EN'	,text: '영문명'		,type: 'string'},						//성분명_영문'
			{name: 'CHEMICAL_NAME_CH'	,text: '중문명'		,type: 'string'},						//성분명_중문'
			{name: 'CHEMICAL_NAME_JP'	,text: '일문명'		,type: 'string'},						//성분명_일문'
			{name: 'UNIT_RATE'			,text: '구성성분비(%)'	,type: 'float' , decimalPrecision: 2 , format:'0,000.00' ,allowBlank: false},				//UNIT_RATE'
			{name: 'CAS_NO'				,text: 'CAS NO'		,type: 'string'},						//CAS NO'
			{name: 'FUNCTION_DESC'		,text: 'Function'	,type: 'string'},						//기능'
			{name: 'CONTROL_CH'			,text: '중국규제'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('regulation')},	//규제_중국'
			{name: 'CONTROL_JP'			,text: '일본규제'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('regulation')},	//규제_일본'
			{name: 'CONTROL_USA'		,text: '미국규제'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('regulation')},	//규제_미국'
			{name: 'CONTROL_ETC1'		,text: '기타1규제'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('regulation')},	//규제_기타1'
			{name: 'CONTROL_ETC2'		,text: '기타2규제'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('regulation')},	//규제_기타2'
			{name: 'CONTROL_ETC3'		,text: '기타3규제'		,type: 'string'},						//규제_기타3'
			{name: 'CONTROL_ETC4'		,text: '기타4규제'		,type: 'string'},						//규제_기타4'
			{name: 'CONTROL_ETC5'		,text: '기타5규제'		,type: 'string'},						//규제_기타5'
			{name: 'REMARK'				,text: '비고'			,type: 'string'}						//비고'
		]
	});


	/** directMasterStore 정의
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('laa110ukrvMasterStore',{
		model	: 'laa110ukrvMaterModel',
		autoLoad: false,
		proxy	: directProxy,
		uniOpt	:{
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용 
		},
		// 검색 조건을 통해 DB에서 데이타 읽어 오기 
		loadStoreRecords : function() {
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		// 수정/추가/삭제된 내용 DB에 적용 하기 
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toCreate, toUpdate);
			var checkFlag = true;
			
			//저장시 구성성분비의 합이 100이 아니면 오류 - 20190910 체크로직 수정, 단, 삭제시에는 체크하지 않음
			if(!Ext.isEmpty(list)) {
				Ext.each(list, function(record, idx) {
					var results = directMasterStore.sumBy(function(item, id) {
						if(record.get('ITEM_CODE') == item.get('ITEM_CODE')) return true;
						},
						['UNIT_RATE']
					);
					if(results.UNIT_RATE != 100) {
						checkFlag = false;
						return false;
					}
				});
				if(!checkFlag) {
					Unilite.messageBox('구성성분비의 합은 100이어야 합니다.');
					return false;
				}
			}
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 ) {
				//this.syncAll({});
				this.syncAllDirect();

			} else {
				var grid = Ext.getCmp('masterGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records != null && records.length > 0 ){
					//20190910 panelResult가 입력 조건에서 단순 조회조건으로 변경되어 아래 로직 주석
//					var fields = panelResult.getForm().getFields();
//					Ext.each(fields.items, function(item) {
//						item.setReadOnly(true);
//					});
				}
			}
		}
	});


	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable' , columns: 3 },
		padding	: '1 1 1 1',
		border	: true,
		items	: [
			Unilite.popup('ITEM',{ 
				fieldLabel		: '원료', 
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				textFieldWidth	: 300,
				validateBlank	: false,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
						},
						scope: this
					},
					onClear: function(type) {
					},
					applyextparam: function(popup){
//						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
		})]
	});


	/** Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('masterGrid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		selModel: 'rowmodel',
		uniOpt	: {
			useRowNumberer: true
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns:[
			{dataIndex:'COMP_CODE'			, width:105 , hidden: true},
			{dataIndex:'ITEM_CODE'			, width:105,
				editor: Unilite.popup('ITEM_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE'	, records[0].ITEM_CODE);
								grdRecord.set('ITEM_NAME'	, records[0].ITEM_NAME);
								grdRecord.set('ITEM_NAME1'	, records[0].ITEM_NAME1);
								grdRecord.set('ITEM_NAME2'	, records[0].ITEM_NAME2);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'	, '');
							grdRecord.set('ITEM_NAME'	, '');
							grdRecord.set('ITEM_NAME1'	, '');
							grdRecord.set('ITEM_NAME2'	, '');
						},
						applyextparam: function(popup){
						}
					}
				})
			},
			{dataIndex:'ITEM_NAME'			, width:150,
				editor: Unilite.popup('ITEM_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE'	, records[0].ITEM_CODE);
								grdRecord.set('ITEM_NAME'	, records[0].ITEM_NAME);
								grdRecord.set('ITEM_NAME1'	, records[0].ITEM_NAME1);
								grdRecord.set('ITEM_NAME2'	, records[0].ITEM_NAME2);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'	, '');
							grdRecord.set('ITEM_NAME'	, '');
							grdRecord.set('ITEM_NAME1'	, '');
							grdRecord.set('ITEM_NAME2'	, '');
						},
						applyextparam: function(popup){
						}
					}
				})
			},
			{dataIndex:'ITEM_NAME1'			, width:150, hidden: true},
			{dataIndex:'ITEM_NAME2'			, width:150, hidden: true},
			{dataIndex:'CHEMICAL_CODE'		, width:100,
				editor: Unilite.popup('CHEMICAL_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type){
								var masterRecords = masterGrid.getStore().data.items;
								var grdRecord = masterGrid.uniOpt.currentRecord;
								var checkFlag = false;
								Ext.each(records, function(record,i) {
									Ext.each(masterRecords, function(masterRecord, j) {
										if ( record.CHEMICAL_CODE == masterRecord.get('CHEMICAL_CODE') 
										  && masterGrid.getSelectedRowIndex() != j
										  //20190910 품목코드 입력 가능하게 변경 됨에 따라 품목코드도 체크 조건에 추가
										  && masterRecord.get('ITEM_CODE') == grdRecord.get('ITEM_CODE')) {
											Unilite.messageBox('이미 등록된 데이터 입니다.');
											masterGrid.setItemData(null, true, masterGrid.uniOpt.currentRecord);
											checkFlag = true;
											return false;
										}
									});
									if(!checkFlag) {
										if(i==0) {
											masterGrid.setItemData(record, false, masterGrid.uniOpt.currentRecord);
										} else {
											UniAppManager.app.onNewDataButtonDown();
											masterGrid.setItemData(record, false, masterGrid.getSelectedRecord());
										}
									}
								});
							},
							scope: this
						},
						'onClear' : function(type) {
							masterGrid.setItemData(null, true, masterGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
////						popup.setExtParam({'SELMODEL': 'MULTI'});
						}
					}
				})
			},
			{dataIndex:'CHEMICAL_NAME_EN'	, width:200},
			{dataIndex:'CHEMICAL_NAME'		, width:200,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '');
				}
			},
			{dataIndex:'UNIT_RATE'			, width:110 , summaryType: 'sum',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<div align="right">' + Ext.util.Format.number(value,'0,000.00')+'</div>', '');
				}
			},
			{dataIndex:'CAS_NO'				, width:100},
			{dataIndex:'FUNCTION_DESC'		, width:100},
			{dataIndex:'CHEMICAL_NAME_CH'	, width:200},
			{dataIndex:'CHEMICAL_NAME_JP'	, width:200},
			{dataIndex:'CONTROL_CH'			, width:100},
			{dataIndex:'CONTROL_JP'			, width:100},
			{dataIndex:'CONTROL_USA'		, width:100},
//			{dataIndex:'CONTROL_ETC1'		, width:100},
//			{dataIndex:'CONTROL_ETC2'		, width:100},
//			{dataIndex:'CONTROL_ETC3'		, width:100},
//			{dataIndex:'CONTROL_ETC4'		, width:100},
//			{dataIndex:'CONTROL_ETC5'		, width:100},
			{dataIndex:'REMARK'				, width:100}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				//신규 데이터는 성분코드, 구성성분비, 비고만 수정 가능 - 20190910 품목코드, 품목명 수정 가능하도록 변경
				if(e.record.phantom){
					if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME'/*, 'CHEMICAL_CODE'*/, 'UNIT_RATE', 'REMARK'])){
						return true;
					//20190910  품목코드 입력 가능하게 변경 됨에 따라 성분코드는 품목코드 입력 후에 입력가능하도록 수정 
					} else if(UniUtils.indexOf(e.field, ['CHEMICAL_CODE'])){
						if(Ext.isEmpty(e.record.get('ITEM_CODE'))) {
							Unilite.messageBox('품목코드를 입력 하신 후, 작업을 진행하세요');
							return false;
						} else {
							return true;
						}
					} else {
						return false;
					}
				//조회된 데이터는 구성성분비, 비고만 수정 가능
				} else if(UniUtils.indexOf(e.field, ['UNIT_RATE', 'REMARK'])){
					return true;
					
				} else {
					return false;
				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(!dataClear) {
				grdRecord.set('CHEMICAL_CODE'	, record['CHEMICAL_CODE']);
				grdRecord.set('CHEMICAL_NAME'	, record['CHEMICAL_NAME']);
				grdRecord.set('CHEMICAL_NAME_EN', record['CHEMICAL_NAME_EN']);
				grdRecord.set('CHEMICAL_NAME_CH', record['CHEMICAL_NAME_CH']);
				grdRecord.set('CHEMICAL_NAME_JP', record['CHEMICAL_NAME_JP']);
				grdRecord.set('CAS_NO'			, record['CAS_NO']);
				grdRecord.set('FUNCTION_DESC'	, record['FUNCTION_DESC']);
				grdRecord.set('CONTROL_CH'		, record['CONTROL_CH']);
				grdRecord.set('CONTROL_JP'		, record['CONTROL_JP']);
				grdRecord.set('CONTROL_USA'		, record['CONTROL_USA']);
				grdRecord.set('CONTROL_ETC1'	, record['CONTROL_ETC1']);
				grdRecord.set('CONTROL_ETC2'	, record['CONTROL_ETC2']);
				grdRecord.set('REMARK'			, record['REMARK']);
			} else {
				grdRecord.set('CHEMICAL_CODE'	, '');
				grdRecord.set('CHEMICAL_NAME'	, '');
				grdRecord.set('CHEMICAL_NAME_EN', '');
				grdRecord.set('CHEMICAL_NAME_CH', '');
				grdRecord.set('CHEMICAL_NAME_JP', '');
				grdRecord.set('CAS_NO'			, '');
				grdRecord.set('FUNCTION_DESC'	, '');
				grdRecord.set('CONTROL_CH'		, '');
				grdRecord.set('CONTROL_JP'		, '');
				grdRecord.set('CONTROL_USA'		, '');
				grdRecord.set('CONTROL_ETC1'	, '');
				grdRecord.set('CONTROL_ETC2'	, '');
				grdRecord.set('REMARK'			, '');
			}
		}
	});





	/** 조회 팝업관련
	 * 
	 */
	var itemCodeSearch = Unilite.createSearchForm('itemCodeSearchForm', {
		layout: {
			type: 'uniTable',
			columns: 3
		},
		items: [
			Unilite.popup('ITEM',{ 
				fieldLabel		: '원료', 
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
						},
						scope: this
					},
					onClear: function(type) {
					},
					applyextparam: function(popup){
//						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}
				}
			})
		]
	});
	
	Unilite.defineModel('itemCodeSearchModel', {
		fields: [
			{name: 'COMP_CODE'	, text: 'COMP_CODE'	, type: 'string'},
			{name: 'ITEM_CODE'	, text: '원료코드'		, type: 'string'},
			{name: 'ITEM_NAME'	, text: '원료명'		, type: 'string'}
		]
	});

	var itemCodeSearchStore = Unilite.createStore('itemCodeSearchStore', {
		model	: 'itemCodeSearchModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'laa110ukrvService.itemCodeList'
			}
		},
		loadStoreRecords: function() {
			var param = itemCodeSearch.getValues();
			console.log(param);
			this.load({
				params: param
			});
		}
	});

	var itemCodeSearchGrid = Unilite.createGrid('itemCodeSearchGrid', {
		store	: itemCodeSearchStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: false
		},
		columns: [
			{ dataIndex: 'ITEM_CODE', width: 100 },
			{ dataIndex: 'ITEM_NAME', width: 200 }
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				itemCodeSearchGrid.returnData(record);
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if (Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelResult.setValues({
				'ITEM_CODE': record.get('ITEM_CODE'),
				'ITEM_NAME': record.get('ITEM_NAME')
			})
			UniAppManager.app.onQueryButtonDown();
		}
	});

	function openSearchInfoWindow() {
		if (!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '원료정보 검색',
				width	: 500,
				height	: 580,
				layout	: {
					type: 'vbox',
					align: 'stretch'
				},
				items	: [itemCodeSearch, itemCodeSearchGrid],
				tbar	: ['->',{
					itemId	: 'searchBtn',
					text	: '조회',
					handler	: function() {
						itemCodeSearchStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '닫기',
					handler	: function() {
						SearchInfoWindow.hide();
					}
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						itemCodeSearch.clearForm();
						itemCodeSearchGrid.reset();
						itemCodeSearchStore.clearData();
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	};





	Unilite.Main({
		id			: 'laa110ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [panelResult, masterGrid]
		}],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData'],true);
		},
		onQueryButtonDown : function() {
//			if(!this.isValidSearchForm()){
//				return false;
//			}
			var itemCode = panelResult.getValue('ITEM_CODE');
			//20190910 그냥 조회되도록 변경
//			if(Ext.isEmpty(itemCode)) {
				directMasterStore.loadStoreRecords(); 
//			} else {
//				openSearchInfoWindow();
//			}
		},
		onNewDataButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			var compCode = UserInfo.compCode;
			var itemCode = panelResult.getValue('ITEM_CODE');
			param = {'COMP_CODE':compCode, 'ITEM_CODE':itemCode}
	
			masterGrid.createRow(param);
			UniAppManager.setToolbarButtons(['save'],true);
		},
		onSaveDataButtonDown: function () {
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown : function() {
			masterGrid.deleteSelectedRow();
			UniAppManager.setToolbarButtons(['save'],true);
		},
		onResetButtonDown:function() {
			var fields = panelResult.getForm().getFields();
			Ext.each(fields.items, function(item) {
				item.setReadOnly(false);
			});
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		}
	});

	Unilite.createValidator('validator01',{
		store	: directMasterStore,
		grid	: masterGrid,
		
		validate: function(type, fieldName, newValue, oldValue, record, eopt, editor, e){
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			
			switch(fieldName){
			/*  case "USE_YN" :
				if(newValue == 'Y'){
					break;
				}else if(newValue == 'N'){
					break;
				}else if(newValue == 'y'){
					record.set('USE_YN','Y');
					break;					
				}else if(newValue == 'n'){
					record.set('USE_YN','N');
					break;
				}
					rv = Msg.sMBC04 */
			}
			return rv;
		}
	});
};
</script>