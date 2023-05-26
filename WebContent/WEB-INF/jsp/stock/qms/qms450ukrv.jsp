<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="qms450ukrv"  >
	<t:ExtComboStore comboType="BOR120" /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>	<!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"/>	<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="P003"/>	<!-- 불량유형 -->
	<t:ExtComboStore comboType="AU" comboCode="P002"/>	<!-- 특기사항 분류 -->
	<t:ExtComboStore comboType="AU" comboCode="P507"/>	<!-- 작업조 -->
	<t:ExtComboStore comboType="AU" comboCode="P509"/>	<!-- 공정검사자 -->
	<t:ExtComboStore comboType="OU" />					<!-- 창고-->
	<t:ExtComboStore comboType="WU" />					<!-- 작업장-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var hasChanged = false;
	var gsSaveFlag		= false;

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 작업실적 등록
		api: {
			read: 'qms450ukrvService.selectList'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 공정별 등록1
		api: {
			read	: 'qms450ukrvService.selectDetailList',
			update	: 'qms450ukrvService.updateDetail',
			create	: 'qms450ukrvService.insertDetail',
			destroy	: 'qms450ukrvService.deleteDetail',
			syncAll	: 'qms450ukrvService.saveAll'
		}
	});



	Unilite.defineModel('qms450ukrvDetailModel', {
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'					,type:'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'					,type:'string'},
			{name: 'CONTROL_STATUS'		,text: '<t:message code="system.label.product.status" default="상태"/>'						,type:'string' , comboType:"AU", comboCode:"P001"},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.mainworkcenter" default="작업장"/>'				,type:'string' , comboType: "WU"},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			,type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'							,type:'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'					,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'							,type:'string'},
			{name: 'PROG_UNIT'			,text: '<t:message code="system.label.product.routingresultunit" default="공정실적단위"/>'		,type:'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'						,type:'string'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'			,type:'uniQty'},
			//20190403 추가 (INSPEC_DATE, INSPEC_TYPE, END_DECISION, INSPEC_PRSN)
			{name: 'INSPEC_DATE'		,text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'					,type:'uniDate'},
			{name: 'INSPEC_TYPE'		,text: '<t:message code="system.label.product.processinspectiontype" default="공정검사방법"/>'	,type:'string' , comboType:"AU", comboCode:"Q006"},
			{name: 'END_DECISION'		,text: '<t:message code="system.label.product.finaldecision" default="최종판정"/>'				,type:'string' , comboType:"AU", comboCode:"Q033"},
			{name: 'INSPEC_PRSN'		,text: '<t:message code="system.label.product.inspector" default="검사자"/>'					,type:'string' , comboType:"AU", comboCode:"P509"}

		]
	});

	Unilite.defineModel('qms450ukrvModel3', {  //Pmr100ns1v.htm
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'			, type:'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'			, type:'string'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	, type:'string'},
			{name: 'PROG_TEST_CODE'		,text: '<t:message code="system.label.product.inspeccode" default="검사유형코드"/>'		, type:'string'},
			{name: 'PROG_TEST_NAME'		,text: '<t:message code="system.label.product.inspectype" default="검사유형"/>'		, type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'					, type:'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'				, type:'string'},
			{name: 'RESULT_10'			,text: '10:00'		, type:'string'},
			{name: 'RESULT_11'			,text: '11:00'		, type:'string'},
			{name: 'RESULT_12'			,text: '12:00'		, type:'string'},
			{name: 'RESULT_13'			,text: '13:00'		, type:'string'},
			{name: 'RESULT_14'			,text: '14:00'		, type:'string'},
			{name: 'RESULT_15'			,text: '15:00'		, type:'string'},
			{name: 'RESULT_16'			,text: '16:00'		, type:'string'},
			{name: 'RESULT_17'			,text: '17:00'		, type:'string'},
			//20190403 추가 (INSPEC_DATE, INSPEC_TYPE, END_DECISION, INSPEC_PRSN)
			{name: 'INSPEC_DATE'		,text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'					,type:'uniDate'},
			{name: 'INSPEC_TYPE'		,text: '<t:message code="system.label.product.processinspectiontype" default="공정검사방법"/>'	,type:'string' , comboType:"AU", comboCode:"Q006"},
			{name: 'END_DECISION'		,text: '<t:message code="system.label.product.finaldecision" default="최종판정"/>'				,type:'string' , comboType:"AU", comboCode:"Q033"},
			{name: 'INSPEC_PRSN'		,text: '<t:message code="system.label.product.inspector" default="검사자"/>'					,type:'string' , comboType:"AU", comboCode:"P509"}
		]
	});



	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120' ,
			allowBlank:false,
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_SHOP_CODE','');
				}
			}
		} /* ,{
			fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
			xtype: 'uniDatefield',
			name: 'PRODT_DATE',
			value: new Date(),
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		} */ ,{
			fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'PRODT_START_DATE_FR',
			endFieldName:'PRODT_START_DATE_TO',
			width: 315,
			allowBlank:false,
			startDate: UniDate.get('mondayOfWeek'),
			endDate: UniDate.get('sundayOfNextWeek'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {

				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {

				}
		},{
			xtype: 'radiogroup',
			fieldLabel: '상태',
			id: 'rdoSelect2',
			items: [{
				boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
				width: 60,
				name: 'CONTROL_STATUS',
				inputValue: ''
			},{
				boxLabel : '<t:message code="system.label.product.process" default="진행"/>',
				width: 60,
				name: 'CONTROL_STATUS',
				inputValue: '2',
				checked: true
			},{
				boxLabel : '<t:message code="system.label.product.closing" default="마감"/>',
				width: 60,
				name: 'CONTROL_STATUS',
				inputValue: '8'
			},{
				boxLabel : '<t:message code="system.label.product.completion" default="완료"/>',
				width: 60,
				name: 'CONTROL_STATUS',
				inputValue: '9'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'WU',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts )   {
					var store	= queryPlan.combo.store;
					var prStore	= panelResult.getField('WORK_SHOP_CODE').store;
					store.clearFilter();
					prStore.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
						prStore.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
					} else {
						store.filterBy(function(record){
							return false;
						});
						prStore.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
				validateBlank:false,
				textFieldName: 'ITEM_NAME',
				valueFieldName: 'ITEM_CODE',
				listeners: {
					onValueFieldChange: function(field, newValue){
					},
					onTextFieldChange: function(field, newValue){
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
		})],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r=false;
					var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});



	var masterStore = Unilite.createStore('qms450ukrvDetailStore', {
		model: 'qms450ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)) {
					panelResult.setAllFieldsReadOnly(true);
					var wkordNum = '';
					Ext.each(records, function(record,i) {
						if(wkordNum == '') {
							wkordNum = record.get('WKORD_NUM');
						} else {
							wkordNum = wkordNum + ',' + record.get('WKORD_NUM');
						}
					});

					detailStore.loadStoreRecords(wkordNum);
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

	var detailStore = Unilite.createStore('qms450ukrvMasterStore3',{
		model: 'qms450ukrvModel3',
		proxy: directProxy2,
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function(wkordNum) {
			var param	= panelResult.getValues();
			var record	= masterGrid.getSelectedRecord();

			param.WKORD_NUM	= wkordNum;

			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);

			//1. 마스터 정보 파라미터 구성
			var paramMaster	= panelResult.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
//						//마스터 정보(Server 측 처리 시 가공) - 20190404 주석 처리
//						var master = batch.operations[0].getResultSet();
//						var record = masterGrid.getSelectedRecord();
//						if(!Ext.isEmpty(master.CONTROL_STATUS)) {
//							record.set("CONTROL_STATUS", master.CONTROL_STATUS);
//							masterGrid.getStore().commitChanges();
//						}
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						UniAppManager.app.onQueryButtonDown();
//						masterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('qms450ukrvGrid3');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				var masterSelectedRecord	= masterGrid.getSelectedRecord();
				if(!Ext.isEmpty(masterSelectedRecord)) {
					//조회된 detailGrid에 품목, LOT번호 입력
					Ext.each(records, function(record,i) {
						var masterRecords = masterStore.data.items;
						Ext.each(masterRecords, function(masterRecord,i) {
							if(record.get('WKORD_NUM') == masterRecord.get('WKORD_NUM')) {
								record.set('DIV_CODE'	, masterRecord.get('DIV_CODE'));
								record.set('ITEM_CODE'	, masterRecord.get('ITEM_CODE'));
								record.set('LOT_NO'		, masterRecord.get('LOT_NO'));
								detailStore.commitChanges();
							}
						});
					});
					detailStore.filterBy(function(record){
						return record.get('WKORD_NUM') == masterSelectedRecord.get('WKORD_NUM');
					})
				}
//				UniAppManager.setToolbarButtons(['save'], false);
			},
			update:function( store, records, operation, modifiedFieldNames, eOpts )	{
//				var gridRecords = store.getData().items;
//				var emptyCheck = true;
//				Ext.each(gridRecords, function(record,i){
//					if(Ext.isEmpty(record.get('RESULT_10'))&&Ext.isEmpty(record.get('RESULT_11'))&&Ext.isEmpty(record.get('RESULT_12'))&&Ext.isEmpty(record.get('RESULT_13'))	&&Ext.isEmpty(record.get('RESULT_14'))&&Ext.isEmpty(record.get('RESULT_15'))&&Ext.isEmpty(record.get('RESULT_16'))&&Ext.isEmpty(record.get('RESULT_17'))){
//						emptyCheck = true;
//					} else {
//						emptyCheck = false;
//						return false;
//					}
//				});
//				if(hasChanged == true){
//					if(emptyCheck == true){
//						detailStore.loadStoreRecords();
//						hasChanged = false;
//					} else {
//						UniAppManager.setToolbarButtons(['save'], true);
//					}
//				}
			},
			add: function(store, records, index, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});



	var masterGrid = Unilite.createGrid('qms450ukrvGrid', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			onLoadSelectFirst	: true,
			useRowNumberer		: false
		},
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 53	,hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 53	,hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100},
			{dataIndex: 'WKORD_NUM'			, width: 190},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'SPEC'				, width: 180},
			{dataIndex: 'PROG_UNIT'			, width: 100},
			{dataIndex: 'LOT_NO'			, width: 133},
			{dataIndex: 'WKORD_Q'			, width: 100},
			//20190403 추가 (INSPEC_DATE, INSPEC_TYPE, END_DECISION, INSPEC_PRSN)
			{dataIndex: 'INSPEC_DATE'		, width: 100},
			{dataIndex: 'INSPEC_TYPE'		, width: 100},
			{dataIndex: 'END_DECISION'		, width: 100},
			{dataIndex: 'INSPEC_PRSN'		, width: 100}
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm	= grid.getItemId();
				var store	= grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					//store.onStoreActionEnable();
					if( detailStore.isDirty() || gsSaveFlag) {
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
				});
			},
			beforeedit: function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['INSPEC_DATE','INSPEC_TYPE', 'END_DECISION', 'INSPEC_PRSN'])) {
					return true;
				} else {
					return false;
				}
			},
			selectionchange:function( model1, selected, eOpts ){
				//메인 조회 시 같이 조회되도록 로직 변경
//				if(selected.length > 0)	{
//					var record = selected[0];
//					this.returnCell(record);
//					detailStore.loadStoreRecords();
//				}
				//선택 변경 시 FILTER로직 필요
				detailStore.clearFilter();
				if(UniAppManager.app._needSave()) {
					gsSaveFlag = true;
				} else {
					gsSaveFlag = false;
				}
				//선택된 행의 저장된 데이터만 barcodeGrid에 보여주도록 filter
				if(!Ext.isEmpty(selected)) {
					detailStore.filterBy(function(record){
						return record.get('WKORD_NUM') == selected[0].get('WKORD_NUM');
					})
				}
			}
		},
		returnCell: function(record){
		},
		disabledLinkButtons: function(b) {
		}
	});

	var detailGrid = Unilite.createGrid('qms450ukrvGrid3', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'south',
		sortableColumns: false,
		uniOpt	: {
			userToolbar			: false,
			expandLastColumn	: true,
			useRowNumberer		: true,
			useMultipleSorting	: true,
			onLoadSelectFirst 	: true
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 120	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 120	, hidden: true},
			{dataIndex: 'WKORD_NUM'			, width: 120	, hidden: true},
			{dataIndex: 'PROG_TEST_CODE'	, width: 120	, hidden: true},
			{dataIndex: 'PROG_TEST_NAME'	, width: 120},
			{dataIndex: 'ITEM_CODE'			, width: 120	, hidden: true},
			{dataIndex: 'LOT_NO'			, width: 120	, hidden: true},
			{dataIndex: 'RESULT_10'			, width: 120},
			{dataIndex: 'RESULT_11'			, width: 120},
			{dataIndex: 'RESULT_12'			, width: 120},
			{dataIndex: 'RESULT_13'			, width: 120},
			{dataIndex: 'RESULT_14'			, width: 120},
			{dataIndex: 'RESULT_15'			, width: 120},
			{dataIndex: 'RESULT_16'			, width: 120},
			{dataIndex: 'RESULT_17'			, width: 120},
			//20190403 추가 (INSPEC_DATE, INSPEC_TYPE, END_DECISION, INSPEC_PRSN)
			{dataIndex: 'INSPEC_DATE'		, width: 100	, hidden: true},
			{dataIndex: 'INSPEC_TYPE'		, width: 100	, hidden: true},
			{dataIndex: 'END_DECISION'		, width: 100	, hidden: true},
			{dataIndex: 'INSPEC_PRSN'		, width: 100	, hidden: true}
		],
		listeners :{
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
					if(UniUtils.indexOf(e.field, ['RESULT_10', 'RESULT_11', 'RESULT_12', 'RESULT_13', 'RESULT_14', 'RESULT_15', 'RESULT_16', 'RESULT_17']))
						{
							return true;
						} else {
							return false;
						}
				} else {
					if(UniUtils.indexOf(e.field,['RESULT_10', 'RESULT_11', 'RESULT_12', 'RESULT_13', 'RESULT_14', 'RESULT_15', 'RESULT_16', 'RESULT_17'])) {
						return true;
					} else {
						return false;
					}
				}
			},
			render: function(grid, eOpts) {
//				var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
//					activeGridId = girdNm;
//					UniAppManager.setToolbarButtons(['newData', 'delete'], false);
				});
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ) {
			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
				}
			}
		}
	});



	Unilite.Main({
		id			: 'qms450ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items:[
				masterGrid,detailGrid, panelResult
			]
		}],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'], true);
			masterGrid.disabledLinkButtons(false);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
			//20190404 주석처리
//			detailStore.loadData({})
			masterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons(['delete'], false);
			UniAppManager.setToolbarButtons(['deleteAll'], true);
		},
		onResetButtonDown: function() {		// 새로고침 버튼
			this.suspendEvents();
			panelResult.clearForm();

			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			detailGrid.reset();
			this.fnInitBinding();
			masterStore.clearData();
			detailStore.clearData();
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){
					isNewData = true;
				} else {
					isNewData = false;
					if(confirm('전체삭제 하시겠습니까?')) {
						detailStore.clearFilter();
						detailGrid.reset();
						UniAppManager.app.onSaveDataButtonDown();
					}
					return false;
				}
			});
			if(isNewData){								// 신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	// 삭제후 RESET..
			}
		},
		onSaveDataButtonDown: function(config) {
			detailStore.clearFilter();
			detailStore.saveStore();
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('PRODT_DATE'	, UniDate.get('today'));
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		}
	});



	/** Validation
	 */
	Unilite.createValidator('validator00', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "INSPEC_DATE"	:
				case "INSPEC_TYPE"	:
				case "END_DECISION"	:
				case "INSPEC_PRSN"	:
					var detailRecords = detailStore.data.items;
					Ext.each(detailRecords, function(detailRecord) {
						detailRecord.set(fieldName, newValue);
					});
				break;
			}
			return rv;
		}
	}); // validator

	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "RESULT_10" :
					hasChanged = true;
				break;

				case "RESULT_11" :
					hasChanged = true;
				break;

				case "RESULT_12" :
					hasChanged = true;
				break;

				case "RESULT_13" :
					hasChanged = true;
				break;

				case "RESULT_14" :
					hasChanged = true;
				break;

				case "RESULT_15" :
					hasChanged = true;
				break;

				case "RESULT_16" :
					hasChanged = true;
				break;

				case "RESULT_17" :
					hasChanged = true;
				break;
			}
			return rv;
		}
	}); // validator
}
</script>