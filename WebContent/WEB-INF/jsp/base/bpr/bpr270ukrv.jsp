<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr270ukrv">
	<t:ExtComboStore comboType="BOR120"/>			<!-- 사업장 -->
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>	
</t:appConfig>
<script type="text/javascript" >
var excelWindow;

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bpr270ukrvService.selectList',
			update	: 'bpr270ukrvService.updateList',
			create	: 'bpr270ukrvService.updateList',
			syncAll	: 'bpr270ukrvService.saveAll'
		}
	});

	Unilite.defineModel('bpr270ukrvModel', {
		fields: [
			{name: 'DIV_CODE'	, text: '<t:message code="system.label.base.divisioncode" default="사업장코드"/>'	, type: 'string'	, allowBlank: false, comboType: 'BOR120', editable:false},
			{name: 'ITEM_CODE'	, text: '<t:message code="system.label.base.item" default="품목"/>'				, type: 'string'	, allowBlank: false, editable:false},
			{name: 'ITEM_NAME'	, text: '<t:message code="system.label.base.itemname" default="품목명"/>'			, type: 'string'	, editable:false},
			{name: 'SPEC'		, text: '<t:message code="system.label.base.spec" default="규격"/>'				, type: 'string'	, editable:false},
			{name: 'UPN_CODE'	, text: '<t:message code="system.label.sales.upncode" default="UPN 코드"/>'		, type: 'string'	, allowBlank: false}
		]
	});

	var masterStore = Unilite.createStore('bpr270ukrvMasterStore',{
		model	: 'bpr270ukrvModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs	= this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				this.syncAllDirect();
			} else {
				 masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
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
			value		: UserInfo.divCode,
			allowBlank	: false
		}, 
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.base.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE', 
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,			//20210817 추가
			listeners		: {
				//20210817 수정: 조회조건 팝업설정에 맞게 변경
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
				'applyextparam': function(popup){
					var divCode = panelResult.getValue('DIV_CODE');
					popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
				}
			}
		}),{
			fieldLabel	: 'UPN',
			name		: 'UPN_YN',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '<t:message code="system.label.base.whole" default="전체"/>',
				name		: 'UPN_YN', 
				inputValue	: '', 
				width		: 80
			},{
				boxLabel	: '<t:message code="system.label.base.none" default="없음"/>',
				name		: 'UPN_YN', 
				inputValue	: 'N',
				width		: 80/*,//20210817 주석: fninitBinding에 초기값 세팅 로직 추가
				checked		: true */
			},{
				boxLabel	: '<t:message code="system.label.base.exists" default="있음"/>',
				name		: 'UPN_YN', 
				inputValue	: 'Y',
				width		: 80
			}]
		}]
	});

	var masterGrid = Unilite.createGrid('bpr270ukrvGrid', {
		store	: masterStore,
		region	: 'center',
		tbar	: [{
			xtype	: 'button',
			text	: '<t:message code="system.label.commonJS.excel.title" default="엑셀 업로드"/>',
			width	: 100,
			handler	: function() {
				if(UniAppManager.app._needSave()) {
					Unilite.messageBox("저장할 내용이 있습니다. 저장 후 엑셀업로드 하세요.")
					return;
				}
				if(Ext.isEmpty(panelResult.getValue("DIV_CODE"))) {
					Unilite.messageBox("사업장 정보를 입력하세요.");
					return false;
				}
				masterStore.loadData({});
				var appName = 'Unilite.com.excel.ExcelUploadWin';
				if(!excelWindow) {
					Unilite.Excel.defineModel('excel.bpr270.sheet01', {
						fields: [
							{name: 'DIV_CODE'	, text: '<t:message code="system.label.base.divisioncode" default="사업장코드"/>'	, type: 'string'	, comboType: 'BOR120'},
							{name: 'ITEM_CODE'	, text: '<t:message code="system.label.base.item" default="품목"/>'				, type: 'string'	},
							{name: 'ITEM_NAME'	, text: '<t:message code="system.label.base.itemname" default="품목명"/>'			, type: 'string'	},
							{name: 'SPEC'		, text: '<t:message code="system.label.base.spec" default="규격"/>'				, type: 'string'	},
							{name: 'UPN_CODE'	, text: '<t:message code="system.label.sales.upncode" default="UPN 코드"/>'		, type: 'string'	}
						]
					});
					excelWindow =  Ext.WindowMgr.get(appName);
					excelWindow = Ext.create( appName, {
						excelConfigName: 'bpr270',
						modal: false,
						extParam: {
							'DIV_CODE': panelResult.getValue('DIV_CODE')
						},
						grids: [{
							itemId		: 'grid01',
							title		: '<t:message code="system.label.sales.upncode" default="UPN 코드"/> <t:message code="system.label.base.entry" default="등록"/>',
							useCheckbox	: true,
							model		: 'excel.bpr270.sheet01',
							readApi		: 'bpr270ukrvService.selectExcelUploadSheet1',
							columns		: [
								{ dataIndex: 'DIV_CODE',	width: 80	},
								{ dataIndex: 'ITEM_CODE',			width: 120	},
								{ dataIndex: 'ITEM_NAME',			width: 120	},
								{ dataIndex: 'SPEC',				width: 120	},
								{ dataIndex: 'UPN_CODE',			width: 120	}
							]
						}],
						listeners: {
							close: function() {
								this.hide();
							},
							hide: function() {
								excelWindow.down('#grid01').getStore().loadData({});
								this.hide();
							}
						},
						onApply:function() {
							var grid = this.down('#grid01');
							var records = grid.getSelectionModel().getSelection();
							Ext.each(records, function(rec,i){
								masterGrid.createRow(rec.data);
							});
							grid.getStore().remove(records);
							grid.getView().refresh();
						}
					});
				}
				excelWindow.center();
				excelWindow.show();
			}
		}],
		columns:[
			{dataIndex: 'DIV_CODE'	, width: 93	, hidden: true},
			{dataIndex: 'ITEM_CODE'	, width: 110},
			{dataIndex: 'ITEM_NAME'	, width: 200},
			{dataIndex: 'SPEC'		, width: 200},
			{dataIndex: 'UPN_CODE'	, width: 120}
		]
	});



	Unilite.Main({
		id			: 'bpr270ukrvApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid 
			]
		}],
		fnInitBinding : function(params) {
			//20210817 추가: 초기값 세팅로직 추가
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.getField('UPN_YN').setValue('N');
			UniAppManager.setToolbarButtons(['newData'], true);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function () {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterStore.loadStoreRecords();
		},
		onNewDataButtonDown : function() {
		},
		onDeleteDataButtonDown : function() {
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
		}
	});
};
</script>