<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="bsa580ukrv">
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장 -->
	<t:ExtComboStore items="${getCompCode}" storeId="getCompCode"/>		<!-- 법인코드-->
</t:appConfig>
<script type="text/javascript">

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bsa580ukrvService.selectListDetailBelow',
			create	: 'bsa580ukrvService.insertDetail',
			destroy	: 'bsa580ukrvService.deleteDetail',
			syncAll	: 'bsa580ukrvService.saveAll'
		}
	});
	
	Unilite.defineModel('directMasterModel', {
		fields: [
			{name: 'USER_ID'		, text: '사용자ID'			, type: 'string'},
			{name: 'USER_NAME'		, text: '사용자명'			, type: 'string'},
			{name: 'COMP_CODE'		, text: '법인코드'			, type: 'string'},
			{name: 'COMP_NAME'		, text: '법인명'			, type: 'string'}
		]
	});
	
	Unilite.defineModel('directDetailModelA', {
		fields: [
			{name: 'COMP_CODE'		, text: '법인코드'			, type: 'string'},
			{name: 'COMP_NAME'		, text: '법인명'			, type: 'string'},
			{name: 'DIV_CODE'		, text: '사업장코드'			, type: 'string'},
			{name: 'DIV_NAME'		, text: '사업장명'			, type: 'string'}
		]
	});
	
	Unilite.defineModel('directDetailModelB', {
		fields: [
			{name: 'COMP_CODE'		, text: '법인코드'			, type: 'string'},
			{name: 'COMP_NAME'		, text: '법인명'			, type: 'string'},
			{name: 'DIV_CODE'		, text: '사업장코드'			, type: 'string'},
			{name: 'DIV_NAME'		, text: '사업장명'			, type: 'string'}
		]
	});
	
	var directMasterStore = Unilite.createStore('directMasterStore', {
		model	: 'directMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy: {
			type	: 'direct',
			api		: {
				read: 'bsa580ukrvService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param = panelSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});
		}
	});
	
	var directDetailAStore = Unilite.createStore('directDetailAStore', {
		model	: 'directDetailModelA',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy: {
			type	: 'direct',
			api		: {
				read: 'bsa580ukrvService.selectListDetailAbove'
			}
		},
		loadStoreRecords: function(param) {
			console.log(param);
			this.load({
				params : param
			});
		}
	});
	
	var directDetailBStore = Unilite.createStore('directDetailBStore', {
		model	: 'directDetailModelB',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function(param) {
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var paramMaster = panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
			
			var mRecord = masterGrid.getSelectedRecord();
			paramMaster.USER_ID = mRecord.get('USER_ID');
			
			if(inValidRecs.length == 0 ) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						detailGridB.getSelectionModel().deselectAll();
						detailGridA.getSelectionModel().deselectAll();
					}
				};
				this.syncAllDirect(config);
				
			} else {
				detailGridB.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function() {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items		: [{
			title	: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
			itemId	: 'search_panel1',
			layout	: {type: 'uniTable', columns: 1},
			items	: [{
				fieldLabel	: '법인',
				name		: 'COMP_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('getCompCode'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('COMP_CODE', newValue);
					}
				}
			},
			Unilite.popup('USER_NOCOMP',{
				fieldLabel		: '사용자',
				valueFieldName	: 'USER_ID',
			    textFieldName	: 'USER_NAME',
				validateBlank	: false,
				autoPopup		: true,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('USER_ID', newValue);
					},	
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('USER_NAME', newValue);
					}
				}
			})]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '법인',
			name		: 'COMP_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('getCompCode'),
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('COMP_CODE', newValue);
				}
			}
		},
		Unilite.popup('USER_NOCOMP',{
			fieldLabel		: '사용자',
			valueFieldName	: 'USER_ID',
		    textFieldName	: 'USER_NAME',
			validateBlank	: false,
			autoPopup		: true,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('USER_ID', newValue);
				},	
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('USER_NAME', newValue);
				}
			}
		})]
	});
	
	var masterGrid = Unilite.createGrid('masterGrid', {
		region	: 'west',
		store	: directMasterStore,
		title	: '사용자',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true
		},
		selModel: 'rowmodel',
		columns	: [
			{dataIndex: 'USER_ID'			, width: 100},
			{dataIndex: 'USER_NAME'			, width: 100},
			{dataIndex: 'COMP_CODE'			, width: 80},
			{dataIndex: 'COMP_NAME'			, width: 166}
		],
		listeners: {
			selectionchangerecord : function( record ) {
				if(!Ext.isEmpty(record)) {
					var param = {
						USER_ID	: record.get('USER_ID')
					};
					directDetailAStore.loadStoreRecords(param);
					directDetailBStore.loadStoreRecords(param);
				}
			}
//			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
//				if(rowIndex != beforeRowIndex){
//					panelSearch.setValue('USER_ID_G1',record.get('USER_ID'));
//					panelSearch.setValue('COMP_CODE_G1',record.get('COMP_CODE'));
//					directMasterStore.loadStoreRecords(record);
//					programStore.loadStoreRecords();
//				}
//				beforeRowIndex = rowIndex;
//			}
		}
	});
	
	var detailGridA = Unilite.createGrid('detailGridA', {
		region	: 'north',
		store	: directDetailAStore,
		title	: '법인',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false }),
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true
		},
		columns: [
			{dataIndex: 'COMP_CODE'		,		width: 120},
			{dataIndex: 'COMP_NAME'		,		width: 166},
			{dataIndex: 'DIV_CODE'		,		width: 120},
			{dataIndex: 'DIV_NAME'		,		width: 166}
		]
	});
	
	var detailGridB = Unilite.createGrid('detailGridB', {
		region	: 'south',
		store	: directDetailBStore,
		title	: '등록된 법인',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false }),
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true
		},
		columns: [
			{dataIndex: 'COMP_CODE'		,		width: 120},
			{dataIndex: 'COMP_NAME'		,		width: 166},
			{dataIndex: 'DIV_CODE'		,		width: 120},
			{dataIndex: 'DIV_NAME'		,		width: 166}
		]
	});
	
	var btnArea = { 
		xtype	: 'container',
		id		: 'bsa560ukrvBtn',
		region	: 'center',
		margin	: '0 0 2 0',
		height	: 30,
		layout	: {
			type	: 'hbox',
			align	: 'center',
			pack	: 'center'
		},
		items	: [{
			xtype	: 'button',
			text	: '▽ 추가',
			margin	: '5 30 5 10',
			handler	: function() {
				var records, data = new Object();
				if (detailGridA.getSelectedRecords()) {
					records = detailGridA.getSelectedRecords();
					console.log("records: ", records);
					data.records = [];
					for (i = 0, len = records.length; i < len; i++) {
						var record = records[i].copy();
						record.phantom = true;	
						data.records.push(record);	
					}
					detailGridB.getStore().insert(0, data.records);
					detailGridB.getSelectionModel().select(data.records);
					detailGridA.getStore().remove(records);
				}
			}
		},{
			xtype	: 'button',
			text	: '△ 제거',
			margin	: '5 30 5 10',
			handler	: function() {
				var records, data = new Object();
				if (detailGridB.getSelectedRecords()) {
					records = detailGridB.getSelectedRecords();
					data.records = [];
					for (i = 0, len = records.length; i < len; i++) {
						data.records.push(records[i].copy());
					}
					detailGridA.getStore().insert(0, data.records);
					detailGridA.getSelectionModel().select(data.records);
					detailGridB.getStore().remove(records);
				}
			}
		}]
	};
	
	Unilite.Main({
		id			: 'bsa580ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [{
				region	: 'center',
				layout	: {type: 'vbox', align: 'stretch'},
				border	: false,
				flex	: 2,
				items	: [
					detailGridA, btnArea, detailGridB
				]},
				masterGrid, panelResult
			]},
			panelSearch
		],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'], true);
		},
		onQueryButtonDown: function() {
			directMasterStore.loadStoreRecords();
			detailGridB.reset();
			detailGridA.reset();
			beforeRowIndex = -1;
		},
		onSaveDataButtonDown: function (config) {
			if(directDetailBStore.isDirty()) {
				directDetailBStore.saveStore();
			}
		},
		onResetButtonDown: function() {
			masterGrid.reset();
			detailGridB.reset();
			detailGridA.reset();
			Ext.getCmp('searchForm').reset();
			UniAppManager.setToolbarButtons(['save'], false);
		}
	});
};

</script>