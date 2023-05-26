<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr201ukrv">
	<t:ExtComboStore comboType="BOR120" />							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />				<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />				<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />				<!-- 계정구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B131" />				<!-- 예/아니오 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="bpr201ukrvLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="bpr201ukrvLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="bpr201ukrvLevel3Store" />
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {	
	var BsaCodeInfo = {
		gsMoneyUnit: '${gsMoneyUnit}'
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bpr201ukrvService.selectList',
			update	: 'bpr201ukrvService.updateList',
			create	: 'bpr201ukrvService.insertList',
			destroy	: 'bpr201ukrvService.deleteList',
			syncAll	: 'bpr201ukrvService.saveAll'
		}
	});

	
	
	
	Unilite.defineModel('bpr201ukrvModel', {
		fields: [
			{name: 'QUERY_FLAG'			, text: 'QUERY_FLAG'															, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.base.compcode" default="법인코드"/>'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.base.divisioncode" default="사업장코드"/>'	, type: 'string'	, comboType: 'BOR120'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.base.item" default="품목"/>'				, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.base.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.base.spec" default="규격"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>'	, type: 'string'	, comboType:'AU', comboCode:'B013', displayField: 'value' },
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>'		, type: 'string'	, comboType:'AU', comboCode:'B020'},
	    	{name: 'STANDARD_TIME'		, text: '<t:message code="system.label.base.standardtime" default="표준시간"/>'		, type: 'float'		, decimalPrecision: 2	, format:'0,000.00'},
			{name: 'APLY_START_DATE'	, text: '<t:message code="system.label.base.applystartdate" default="적용시작일"/>'	, type: 'uniDate'	, allowBlank: false},
			{name: 'APLY_END_DATE'		, text: '<t:message code="system.label.base.applyenddate" default="적용종료일"/>'	, type: 'uniDate'},
			{name: 'REMARK'				, text: '<t:message code="system.label.sales.remarks" default="비고"/>'			, type: 'string'}
		]
	});
	
	
	
	
	var masterStore = Unilite.createStore('bpr201ukrvMasterStore',{
		model	: 'bpr201ukrvModel',
	 	proxy	: directProxy,
	 	autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();

			Ext.each(toDelete, function(deletedRecord,i) {
				deletedRecord.set('QUERY_FLAG', 'D');
			});
			
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
			},
			remove: function( store, records, index, isMove, eOpts ) { 
				if(store.count() == 0) {
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
			validateBlank	: false,
			listeners		: {
				'applyextparam': function(popup){
					var divCode = panelResult.getValue('DIV_CODE');
					popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.base.basisdate" default="기준일"/>',
	 		xtype		: 'uniDatefield',
			allowBlank	: false,
	 		name		: 'BASIS_DATE',
	 		value		: UniDate.get('today'),
	 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
		},{
			fieldLabel	: '<t:message code="system.label.base.accountclass" default="계정구분"/>',
			name		: 'ITEM_ACCOUNT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 3 0',
			items	: [{
				fieldLabel	: '<t:message code="system.label.base.itemgroup" default="품목분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('bpr201ukrvLevel1Store'),
				child		: 'ITEM_LEVEL2',
				width		: 200
			}, {
				fieldLabel	: '',
				name		: 'ITEM_LEVEL2',
				xtype		:'uniCombobox',
				store		: Ext.data.StoreManager.lookup('bpr201ukrvLevel2Store'),
				child		: 'ITEM_LEVEL3',
				width		: 100
				
			 }, {
			 	fieldLabel	: '',
			 	name		: 'ITEM_LEVEL3',
			 	xtype		:'uniCombobox',
				store		: Ext.data.StoreManager.lookup('bpr201ukrvLevel3Store'),
				width		: 100
			}]
		},{
			fieldLabel	: '<t:message code="system.label.base.itemsearch" default="품목검색"/>',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '<t:message code="system.label.base.currentapplied" default="현재적용"/>', 
				name		: 'rdoSelect', 
				inputValue	: 'C', 
				width		: 80, 
				checked		: true 
			},{
				boxLabel	: '<t:message code="system.label.base.whole" default="전체"/>', 
				name		: 'rdoSelect', 
				inputValue	: 'A',
				width		: 80
			}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
		},{
			fieldLabel	: '<t:message code="system.label.base.entryyn" default="등록여부"/>',
			name		: 'REG_YN', 
			xtype		: 'uniCombobox', 
			comboType	: 'AU', 
			comboCode	: 'B131',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		}]	
	});

	
	
	
	var masterGrid = Unilite.createGrid('bpr201ukrvGrid', {
		store	: masterStore,
	 	region	: 'center',
		sortableColumns : true,
		uniOpt	:{
			onLoadSelectFirst	: true,
			expandLastColumn	: true,
			useRowNumberer		: true,
			dblClickToEdit		: true,
			useMultipleSorting	: true
		},
		columns:[
			{dataIndex: 'QUERY_FLAG'		, width: 93		, hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 93		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 93		, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 110	,
				editor: Unilite.popup('DIV_PUMOK_G',{
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
				 	autoPopup		: true,
					listeners		: { 
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE'		,records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME'		,records[0]['ITEM_NAME']);
								grdRecord.set('SPEC'			,records[0]['SPEC']);
								grdRecord.set('STOCK_UNIT'		,records[0]['STOCK_UNIT']);
								grdRecord.set('ITEM_ACCOUNT'	,records[0]['ITEM_ACCOUNT']);
							},
							scope: this
						},
						'onClear' : function(type)  {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'		,'');
							grdRecord.set('ITEM_NAME'		,'');
							grdRecord.set('SPEC'			,'');
							grdRecord.set('STOCK_UNIT'		,'');
							grdRecord.set('ITEM_ACCOUNT'	,'');
						},
						'applyextparam': function(popup){
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 150	,
				editor: Unilite.popup('DIV_PUMOK_G',{
				 	autoPopup: true,
					listeners:{ 
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE'		,records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME'		,records[0]['ITEM_NAME']);
								grdRecord.set('SPEC'			,records[0]['SPEC']);	
								grdRecord.set('STOCK_UNIT'		,records[0]['STOCK_UNIT']);
								grdRecord.set('ITEM_ACCOUNT'	,records[0]['ITEM_ACCOUNT']);
							},
							scope: this
						},
						'onClear' : function(type)  {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'		,'');
							grdRecord.set('ITEM_NAME'		,'');
							grdRecord.set('SPEC'			,'');
							grdRecord.set('STOCK_UNIT'		,'');
							grdRecord.set('ITEM_ACCOUNT'	,'');
						}
					}
				})
			},
			{dataIndex: 'SPEC'				, width: 110},
			{dataIndex: 'STOCK_UNIT'		, width: 80 },
			{dataIndex: 'ITEM_ACCOUNT'		, width: 100},
			{dataIndex: 'STANDARD_TIME'		, width: 93		/*, align: 'center',
				renderer:function(value, metaData, record)	{
					var r = value;
					if(r.toString().substring(r.toString().length - 2, r.toString().length) >= 60) {
						Unilite.messageBox('<t:message code="system.message.base.message024" default="잘못된 숫자가 입력 되었습니다."/>');
						return 0;
					} 
					if(r.toString().length > 2) {
						r= r.toString().substring(0, r.toString().length - 2) + ':' + r.toString().substring(r.toString().length - 2, r.toString().length);
					}
					return r;
				}*/
			},
			{dataIndex: 'APLY_START_DATE'	, width: 100},
			{dataIndex: 'APLY_END_DATE'		, width: 100},
			{dataIndex: 'REMARK'			, width: 250}
		],
		listeners: {
	  		beforeedit  : function( editor, e, eOpts ) {
	  			if (UniUtils.indexOf(e.field, ['SPEC', 'ITEM_ACCOUNT'])){
					return false;
				}
	  			if (!e.record.phantom){
		  			if (UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE', 'ITEM_CODE', 'ITEM_NAME', 'STOCK_UNIT'])){
						return false;
					}
	  			}
	  			if (!e.record.phantom && e.record.get('QUERY_FLAG') == 'U'){
		  			if (UniUtils.indexOf(e.field, ['APLY_START_DATE'])){
						return false;
					}
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
		id			: 'bpr201ukrvApp',
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
				QUERY_FLAG		: 'N',
				COMP_CODE		: UserInfo.compCode,
				DIV_CODE		: panelResult.getValue('DIV_CODE'),
				APLY_START_DATE	: new Date()
			};
			masterGrid.createRow(r, null, masterStore.getCount() - 1);
		},
								
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom == true)	{
				masterGrid.deleteSelectedRow();
								
			} else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {					//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
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
	 		panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
	 		panelResult.setValue('BASIS_DATE'	, UniDate.get('today'));
	 		panelResult.setValue('rdoSelect'	, 'C');
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
								rv = '<t:message code="system.message.base.message030" default="적용 시작일은 종료일 보다 늦을 수 없습니다."/>';
							}
						}
					}
				break;
				
				case "APLY_END_DATE" :		// 적용 종료일
					var aplyEndDate = UniDate.getDbDateStr(newValue);
					if(aplyEndDate.length == 8) {
						var aplyStartDate = UniDate.getDbDateStr(record.get('APLY_START_DATE'));
						if (aplyEndDate < aplyStartDate) {
							rv = '<t:message code="system.message.base.message031" default="적용 종료일은 시작일 보다 빠를 수 없습니다."/>';
						}
					}
				break;

			}
			return rv;
		}
	})

};
</script>