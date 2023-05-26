<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp110ukrv_wm">
	<t:ExtComboStore comboType="BOR120"/>									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>						<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>						<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>						<!-- 영업담당 -->
	<t:ExtComboStore comboType="WU"/>										<!-- 작업장 -->
	<t:ExtComboStore items="${gsWorkShopList}" storeId="gsWorkShopList"/>	<!-- 공정정보 포함한 작업장 콤보데이터 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLevel1Store"/>	<!-- 대분류 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var BsaCodeInfo = {
		defaultRegiPrsn: '${defaultRegiPrsn}'
	}
	var initFlag	= false;			//20201020 추가
	var initFlag2	= false;			//20201020 추가

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pmp110ukrv_wmService.selectList'
		}
	});

	Unilite.defineModel('s_pmp110ukrv_wmModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'	, comboType: 'BOR120'},
			//20201020 수정: 작업장 변경 시, 공정정보 변경을 위해 combo 변경(gsWorkShopList 사용)
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			, type: 'string'	, store: Ext.data.StoreManager.lookup('gsWorkShopList')},
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'		, type: 'string'},
			{name: 'PROG_WORK_CODE'		, text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'		, type: 'string'	, allowBlank: false},
			{name: 'PROG_WORK_NAME'		, text: '<t:message code="system.label.product.routingname" default="공정명"/>'		, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.product.custom" default="거래처"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text:'<t:message code="system.label.sales.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'				, type: 'string'	, comboType: 'AU', comboCode: 'B013' , displayField: 'value', allowBlank: false},
			{name: 'WKORD_Q'			, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		, type: 'uniQty'},
			{name: 'REMARK'				, text: '<t:message code="system.label.product.specialremark" default="특기사항"/>'		, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'				, type: 'uniQty'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'SER_NO'				, text:'<t:message code="system.label.sales.soseq" default="수주순번"/>'				, type: 'int'},
			{name: 'CUSTOM_PRSN'		, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'		, type: 'string'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string'	, comboType:'AU', comboCode: 'S010'},
			{name: 'PRODT_START_DATE'	, text: '착수예정일'		, type: 'uniDate'},
			{name: 'PRODT_END_DATE'		, text: '완료예정일'		, type: 'uniDate'},
			{name: 'PRODT_WKORD_DATE'	, text: '작업지시일'		, type: 'uniDate'}
		]
	});

	var masterStore = Unilite.createStore('s_pmp110ukrv_wmMasterStore',{
		model	: 's_pmp110ukrv_wmModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 , 20201020 true로 변경
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		loadStoreRecords : function(newValue1, newValue2) {
			var param = Ext.getCmp('resultForm').getValues();
			if(newValue1 || newValue1 == '') {			//20201020 추가: 라디오 변경 시 자동조회
				param.rdoSelect = newValue1;
			}
			if(newValue2 || newValue2 == '') {			//20201020 추가: 라디오 변경 시 자동조회
				param.rdoSelect2 = newValue2;
			}
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();

			if(inValidRecs.length == 0 ) {
				if(config == null) {
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
				if(!Ext.isEmpty(records)) {
					setPanelReadOnly(true);
				}
			},
			write: function(proxy, operation) {
				if (operation.action == 'destroy') {
//					Ext.getCmp('detailForm').reset();
				}
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
				masterStore.commitChanges();				//20201020 추가
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
			holdable	: 'hold',
			allowBlank	: false
		},{
			fieldLabel		: '<t:message code="system.label.sales.sodate" default="수주일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_ORDER_DATE',
			endFieldName	: 'TO_ORDER_DATE'
		},{
			fieldLabel	: '등록여부',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '미등록',
				name		: 'rdoSelect',
				inputValue	: 'N',
				width		: 70
			},{
				boxLabel	: '등록',
				name		: 'rdoSelect',
				inputValue	: 'Y',
				width		: 70
			},{
				boxLabel	: '전체',
				name		: 'rdoSelect',
				inputValue	: '',
				width		: 70
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//20201020 추가: 초기화 시 조회로직 타지 않도록 해당로직 추가
					if(!initFlag) {
						masterStore.loadStoreRecords(newValue.rdoSelect, null);
					} else {
						initFlag = false;
					}
				}
			}
		},{
			fieldLabel	: '작업지시일',
			name		: 'PRODT_WKORD_DATE',
			xtype		: 'uniDatefield',
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				blur : function (e, event, eOpts) {
				}
			}
		},{
			fieldLabel	: '등록자',
			name		: 'WKORD_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'P510',
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{	//20201020 추가: 조회조건 외주여부 추가
			fieldLabel	: '외주여부',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '전체',
				name		: 'rdoSelect2',
				inputValue	: 'A',
				width		: 70
			},{
				boxLabel	: '제외',
				name		: 'rdoSelect2',
				inputValue	: 'N',
				width		: 70
			},{
				boxLabel	: '외주만',
				name		: 'rdoSelect2',
				inputValue	: 'Y',
				width		: 70
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//20201020 추가: 초기화 시 조회로직 타지 않도록 해당로직 추가
					if(!initFlag2) {
						masterStore.loadStoreRecords(null, newValue.rdoSelect2);
					} else {
						initFlag2 = false;
					}
				}
			}
		},{	//20210323 추가
			fieldLabel	: '대분류',
			name		: 'ITEM_LEVEL1',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('itemLevel1Store'),
			multiSelect	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{	//20210323 추가
			fieldLabel	: '작업장',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('gsWorkShopList'),
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{	//20210323 추가
			fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_PRSN',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]
	});

	var masterGrid = Unilite.createGrid('s_pmp110ukrv_wmGrid', {
		store	: masterStore,
		region	: 'center',
		uniOpt	:{
			useLiveSearch		: true,		//20210311 추가
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true,
			dblClickToEdit		: true,
			useMultipleSorting	: true
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
//					var selectedCustom = rowSelection.selected.items[0];
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ) {
					masterGrid.down('#printBtn').enable();
					masterGrid.down('#bulkChangeButton').enable();			//20201020 추가
				},
				deselect:  function(grid, selectRecord, index, eOpts ) {
					if (this.selected.getCount() == 0) {
						masterGrid.down('#printBtn').disable();
						masterGrid.down('#bulkChangeButton').disable();		//20201020 추가
					}
				}
			}
		}),
		tbar	: [{
			//20201020 추가: 일괄변경로직 추가
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 2 0',
			items	: [{
				itemId		: 'WORK_SHOP_CODE',
				fieldLabel	: '작업장',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('gsWorkShopList'),
				labelWidth	: 53,
				width		: 180,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			},{	//20201020 추가: 일괄변경로직 추가
				text	: '일괄변경',
				xtype	: 'button',
				itemId	: 'bulkChangeButton',
				disabled: true,
				margin	: '0 0 0 2',
				handler : function() {
					var records = masterGrid.getSelectionModel().getSelection();
					if(records.length > 0){
						var workShopCode = masterGrid.down('#WORK_SHOP_CODE').getValue();
						if(Ext.isEmpty(workShopCode)){
							Unilite.messageBox('변경할 작업장을 입력하십시요.');
							return false;
						}
						if(confirm('작업장을 일괄 변경하시겠습니까?')){
							Ext.each(records, function(record, i){
								record.set("WORK_SHOP_CODE" , workShopCode);
								var commonCodes	= Ext.data.StoreManager.lookup('gsWorkShopList').data.items;
								var basisValue	= '';
								Ext.each(commonCodes,function(commonCode, i) {
									if(commonCode.get('value') == workShopCode) {
										basisValue = commonCode.get('refCode10');
									}
								})
								record.set('PROG_WORK_CODE', basisValue);
							});
						}
					} else {
						Unilite.messageBox('변경할 데이터가 없습니다.\n변경할 데이터를 선택하세요');
						return false;
					}
				}
			}]
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbseparator'
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbspacer'
		},{
			text	: '등록 / 삭제',
			itemId	: 'printBtn',
			width	: 100,
			handler	: function() {
				var selectedRecs= masterGrid.getSelectedRecords();
				if(selectedRecs.length == 0) return false;

				Ext.getCmp('s_pmp110ukrv_wmApp').mask('<t:message code="system.message.human.message010" default="저장중..."/>','loading-indicator');
				var selRecords = masterGrid.getSelectionModel().getSelection();
				Ext.each(selRecords, function(selRecord, index) {
					selRecord.phantom = true;
					regiWorkOrderStore.insert(index, selRecord);

					if(selRecords.length == index + 1) {
						regiWorkOrderStore.saveStore();
					}
				})
			}
		}],
		columns:[
			{dataIndex: 'COMP_CODE'			, width: 93		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 93		, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100	, align: 'center'},
			{dataIndex: 'WKORD_NUM'			, width: 120},
			{dataIndex: 'PROG_WORK_CODE'	, width: 100},
			{dataIndex: 'CUSTOM_CODE'		, width: 100},
			{dataIndex: 'CUSTOM_NAME'		, width: 150},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'ORDER_UNIT'		, width: 80		, align: 'center'},
			{dataIndex: 'WKORD_Q'			, width: 100},
			{dataIndex: 'REMARK'			, width: 120},
			{dataIndex: 'ORDER_Q'			, width: 100},
			{dataIndex: 'ORDER_NUM'			, width: 120},
			{dataIndex: 'SER_NO'			, width: 80		, align: 'center'},
			{dataIndex: 'CUSTOM_PRSN'		, width: 100},
			{dataIndex: 'ORDER_PRSN'		, width: 100},
			{dataIndex: 'PRODT_START_DATE'	, width: 100	, hidden: true},
			{dataIndex: 'PRODT_END_DATE'	, width: 100	, hidden: true},
			{dataIndex: 'PRODT_WKORD_DATE'	, width: 100	, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				//20201020 수정: 작업장 변경 가능하도록 수정
				if (UniUtils.indexOf(e.field, ['WORK_SHOP_CODE'])) {
					return true;
				} else {
					return false;
				}
			},
			selectionchangerecord:function(selected) {
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		}
	});



	/* 작업지시등록 버튼관련 로직
	 */
	var regiWorkOrderProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 's_pmp110ukrv_wmService.insertLogTable',
			syncAll	: 's_pmp110ukrv_wmService.regiWorkOrder'
		}
	});

	var regiWorkOrderStore = Unilite.createStore('regiWorkOrderStore',{
		uniOpt: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy		: regiWorkOrderProxy,
		saveStore	: function() {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();

			var paramMaster = panelResult.getValues();

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						Ext.getCmp('s_pmp110ukrv_wmApp').unmask();
						regiWorkOrderStore.clearData();
						masterStore.loadStoreRecords();
					},
					failure: function(batch, option) {
						Ext.getCmp('s_pmp110ukrv_wmApp').unmask();
						regiWorkOrderStore.clearData();
					}
				};
				this.syncAllDirect(config);
			} else {
				var invalidRec	= Ext.isArray(inValidRecs) ? inValidRecs[0] : inValidRecs;
				var errColumn	= invalidRec.validate().items[0].field
				var errMsg		= masterGrid.getColumn(errColumn).text + '<t:message code="system.label.purchase.required" default="은(는) 필수입력 사항입니다."/>';
				Unilite.messageBox(errMsg);
				Ext.getCmp('s_pmp110ukrv_wmApp').unmask();
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



	Unilite.Main({
		id			: 's_pmp110ukrv_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		}],
		fnInitBinding : function(params) {
			this.setDefault();
		},
		setDefault: function() {
			initFlag	= true;				//20201020 추가
			initFlag2	= true;				//20201020 추가
			setPanelReadOnly(false);
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('rdoSelect'		, 'N');
			panelResult.setValue('rdoSelect2'		, 'A');		//20201020 추가: 조회조건 외주여부 추가
			panelResult.setValue('FR_ORDER_DATE'	, UniDate.get('todayOfLastWeek'));
			panelResult.setValue('TO_ORDER_DATE'	, UniDate.get('today'));
			panelResult.setValue('PRODT_WKORD_DATE'	, UniDate.get('today'));
			panelResult.setValue('WKORD_PRSN'		, BsaCodeInfo.defaultRegiPrsn);
			masterGrid.down('#printBtn').disable();
			initFlag	= false;				//20201020 추가
			initFlag2	= false;				//20201020 추가

			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function () {
			if(!this.isValidSearchForm()) {
				return false;
			}
			masterGrid.down('#printBtn').disable();
			masterStore.loadStoreRecords();
		},
		onSaveDataButtonDown: function (config) {
			//필수 입력값 체크
			if (!panelResult.getInvalidMessage()) {
				return false;
			}
			masterStore.saveStore(config);
		},
		onResetButtonDown: function() {
			initFlag	= true;				//20201020 추가
			initFlag2	= true;				//20201020 추가
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterStore.clearData();
			this.fnInitBinding();
		}
	});



	//panelResult readOnly 설정
	function setPanelReadOnly(flag) {
		var fields = panelResult.getForm().getFields();
		Ext.each(fields.items, function(item) {
			if(Ext.isDefined(item.holdable) ) {
				if (item.holdable == 'hold') {
					item.setReadOnly(flag);
				}
			}
			if(item.isPopupField) {
				var popupFC = item.up('uniPopupField');
				if(popupFC.holdable == 'hold') {
					popupFC.setReadOnly(flag);
				}
			}
		})
	}



	//20201020 추가: 작업장 변경 / 변경 시, 공정정보 자동설정을 위해 추가
	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "WORK_SHOP_CODE" :
					var commonCodes	= Ext.data.StoreManager.lookup('gsWorkShopList').data.items;
					var basisValue	= '';
					Ext.each(commonCodes,function(commonCode, i) {
						if(commonCode.get('value') == newValue) {
							basisValue = commonCode.get('refCode10');
						}
					})
					record.set('PROG_WORK_CODE', basisValue);
				break;
			}
			return rv;
		}
	});
};
</script>