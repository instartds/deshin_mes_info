<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="qms400ukrv">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P505"/>	<!-- 작업자 -->
	<t:ExtComboStore comboType="AU" comboCode="P507"/>	<!-- 작업조 -->
	<t:ExtComboStore comboType="AU" comboCode="P509"/>	<!-- 공정검사자 -->
	<t:ExtComboStore comboType="AU" comboCode="Q006"/>	<!-- 공정검사방법(01:전수검사, 02:출하샘플검사) -->
	<t:ExtComboStore comboType="AU" comboCode="Q043"/>	<!-- 검사차수 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">

function appMain() {
	var searchInfoWindow;		//조회 팝업 창
	var refProdtOrderWindow;	//refProdtOrderWindow : 작업지시번호 참조창
	var gsSaveFlag = '';
	var gsBadQtyInfo;			//detilGrid 조회용 배열
	var gsBadQtyInfo2;			//detilGrid 조회용 배열2
	var gsSeq;					//참조 적용 시 detail data 가져오기 위해 seq 정보 저장변수
	//동적 그리드 구현(공통코드(p03)에서 컬럼 가져오는 로직)
	var colData	= ${colData};
	var fields	= createModelField(colData);
	var columns	= createGridColumn(colData);

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120' ,
			value		: UserInfo.divCode,
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_SHOP_CODE','');
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
			xtype		: 'uniDatefield',
			name		: 'INSPEC_DATE',
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			validateBlank	: false,
			textFieldName	: 'ITEM_NAME',
			valueFieldName	: 'ITEM_CODE',
			colspan			: 2,
			listeners		: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		})/*,{	//20201005 주석
			fieldLabel	: '<t:message code="system.label.product.inspector" default="검사자"/>',
			name		: 'INSPEC_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU' ,
			comboCode	: 'P509',
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.inspectype" default="검사유형"/>',
			name		: 'INSPEC_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU' ,
			comboCode	: 'Q006',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}*/,
		Unilite.popup('EQU_MACH_CODE',{
			fieldLabel		: '<t:message code="system.label.product.facilities" default="설비"/>',
			validateBlank	: false,
			valueFieldName	: 'EQU_MACH_CODE',
			textFieldName	: 'EQU_MACH_NAME',
			listeners		: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.product.inspecno" default="검사번호"/>',
			name		: 'INSPEC_NUM',
			xtype		: 'uniTextfield',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}],
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



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 작업지시참조된 데이터(master)
		api: {
			read	: 'qms400ukrvService.selectList',
			update	: 'qms400ukrvService.updateDetail',
			create	: 'qms400ukrvService.insertDetail',
			destroy	: 'qms400ukrvService.deleteDetail',
			syncAll	: 'qms400ukrvService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 불량유형(detail)
		api: {
			read	: 'qms400ukrvService.selectList2',
			update	: 'qms400ukrvService.updateDetail2',
			syncAll	: 'qms400ukrvService.saveAll2'
		}
	});



	Unilite.defineModel('qms400ukrvDetailModel', {
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'					,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'					,type: 'string'},
			{name: 'INSPEC_NUM'			,text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'					,type: 'string'},
			{name: 'INSPEC_SEQ'			,text: '순번'			,type: 'int'},
			{name: 'INSPEC_DATE'		,text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'					,type: 'uniDate'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'							,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'							,type: 'string'},
			{name: 'INSPEC_TYPE'		,text: '<t:message code="system.label.product.inspectype" default="검사유형"/>'					,type: 'string'	, comboType:'AU' , comboCode:'Q006'},
			{name: 'INSPEC_Q'			,text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'					,type: 'uniQty'},
			{name: 'INSPEC_PRSN'		,text: '<t:message code="system.label.product.inspector" default="검사자"/>'					,type :'string'	, comboType:"AU", comboCode:"P509"},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'				,type: 'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'						,type: 'string'},
			{name: 'EQUIP_CODE'			,text: '<t:message code="system.label.product.facilities" default="설비코드"/>'					,type: 'string'},
			{name: 'EQUIP_NAME'			,text: '<t:message code="system.label.product.facilitiesname" default="설비명"/>'				,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.inventory.remarks" default="비고"/>'					,type: 'string'}
		]
	});

	var masterStore = Unilite.createStore('qms400ukrvDetailStore', {
		model	: 'qms400ukrvDetailModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var paramMaster	= panelResult.getValues();

			if(inValidRecs.length == 0) {
				if(config == null) {
					config = {
						params	: [paramMaster],
						success	: function(batch, option) {
							if(Ext.isEmpty(panelResult.getValue('INSPEC_NUM'))) {
								var master = batch.operations[0].getResultSet();
								panelResult.setValue('INSPEC_NUM', master.INSPEC_NUM);
							}
							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);
	
							if(detailStore.isDirty()){
								detailStore.clearFilter();
								detailStore.saveStore(master.INSPEC_NUM);
							}
						}
					};
				}
				this.syncAllDirect(config);
			} else {
				 detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records.length > 0) {
					UniAppManager.setToolbarButtons('delete', true);
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

	var masterGrid = Unilite.createGrid('qms400ukrvGrid', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		flex	: .3,				//20201006 추가
		uniOpt	: {
			expandLastColumn	: true,
			onLoadSelectFirst	: true,
			useRowNumberer		: false
		},
		tbar: [{
			itemId	: 'reqBtn',
			text	: '<div style="color: blue">작업지시 참조</div>',
			handler	: function() {
				openrefProdtOrderWindow();
			}
		}],
		columns: [
			{ dataIndex: 'COMP_CODE'		, width: 66	, hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 66	, hidden: true},
			{ dataIndex: 'INSPEC_NUM'		, width: 120, hidden: true},
			{ dataIndex: 'INSPEC_SEQ'		, width: 80	, align: 'center'},
			{ dataIndex: 'INSPEC_DATE'		, width: 80	, hidden: true},
			{ dataIndex: 'ITEM_CODE'		, width: 110},
			{ dataIndex: 'ITEM_NAME'		, width: 150},
			{ dataIndex: 'SPEC'				, width: 150},
			{ dataIndex: 'INSPEC_TYPE'		, width: 100, hidden: true	, align: 'center'},
			{ dataIndex: 'INSPEC_Q'			, width: 100, hidden: true},
			{ dataIndex: 'INSPEC_PRSN'		, width: 100, hidden: true},
			{ dataIndex: 'WKORD_NUM'		, width: 120},
			{ dataIndex: 'LOT_NO'			, width: 100},
			{ dataIndex: 'EQUIP_CODE'		, width: 100},
			{ dataIndex: 'EQUIP_NAME'		, width: 100},
			{ dataIndex: 'REMARK'			, flex: 1}
		],
		listeners: {
			render: function(grid, eOpts){
				if(masterStore.isDirty() || detailStore.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				}
			},
			beforeedit: function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['INSPEC_TYPE', 'INSPEC_Q'])) {
					return true;
				} else {
					return false;
				}
			},
			selectionchange:function( model1, selected, eOpts ){
				//선택 변경 시 FILTER로직 필요
				detailStore.clearFilter();
				//선택된 행의 저장된 데이터만 barcodeGrid에 보여주도록 filter
				if(!Ext.isEmpty(selected)) {
					detailStore.filterBy(function(record){
						return record.get('INSPEC_NUM') == selected[0].get('INSPEC_NUM')
						    && record.get('INSPEC_SEQ') == selected[0].get('INSPEC_SEQ');
					})
				}
				if(masterStore.isDirty() || detailStore.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				}
			}
		},
		setRefProdtOrderData: function(record) {		//작업지시 참조 적용로직
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('COMP_CODE'		, UserInfo.compCode);
			grdRecord.set('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
			grdRecord.set('INSPEC_NUM'		, panelResult.getValue('INSPEC_NUM'));
			grdRecord.set('INSPEC_DATE'		, panelResult.getValue('INSPEC_DATE'));
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('SPEC'			, record['SPEC']);
			grdRecord.set('INSPEC_TYPE'		, panelResult.getValue('INSPEC_TYPE'));
			grdRecord.set('INSPEC_Q'		, 0);
			grdRecord.set('INSPEC_PRSN'		, panelResult.getValue('INSPEC_PRSN'));
			grdRecord.set('WKORD_NUM'		, record['WKORD_NUM']);
			grdRecord.set('LOT_NO'			, record['LOT_NO']);
			grdRecord.set('EQUIP_CODE'		, record['EQUIP_CODE']);
			grdRecord.set('EQUIP_NAME'		, record['EQUIP_NAME']);
			grdRecord.set('REMARK'			, record['REMARK']);
		}
	});



	Unilite.defineModel('qms400ukrvModel2', {
		fields : fields
	});

	var detailStore = Unilite.createStore('qms400ukrvMasterStore3',{
		model	: 'qms400ukrvModel2',
		proxy	: directProxy2,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function(badQtyArray, badQtyArray2, REF_FLAG) {
			var param = panelResult.getValues();
			if(!Ext.isEmpty(badQtyArray)) {
				param.badQtyArray = badQtyArray;
			}
			if(!Ext.isEmpty(badQtyArray2)) {
				param.badQtyArray2 = badQtyArray2;
			}
			//참조 적용 시 DETAIL DATA 가져오도록 FLAG 적용
			if(!Ext.isEmpty(REF_FLAG)) {
				param.REF_FLAG	= REF_FLAG;
				param.MAX_SEQ	= gsSeq;
			}

			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function(INSPEC_NUM) {
			var inValidRecs = this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);

			//1. 마스터 정보 파라미터 구성
			var paramMaster				= panelResult.getValues();	//syncAll 수정
			paramMaster.badQtyArray		= gsBadQtyInfo.split(',');
			paramMaster.badQtyArray2	= gsBadQtyInfo2.split(',');
			if(INSPEC_NUM) {
				paramMaster.INSPEC_NUM	= INSPEC_NUM;
			}

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('qms400ukrvGrid2');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				var masterSelectedRecord = masterGrid.getSelectedRecord();
				if(masterSelectedRecord) {
					UniAppManager.setToolbarButtons('delete', true);
					detailStore.filterBy(function(record){
						return record.get('INSPEC_NUM') == masterSelectedRecord.get('INSPEC_NUM')
						    && record.get('INSPEC_SEQ') == masterSelectedRecord.get('INSPEC_SEQ');
					})
				} else {
					detailStore.filterBy(function(record){
						return record.get('INSPEC_NUM') == 'zzzzzzz'
						    && record.get('INSPEC_SEQ') == 'zzzzzzz';
					})
				}
			},
			update:function( store, records, operation, modifiedFieldNames, eOpts ) {
			},
			add: function(store, records, index, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				console.log("onStoreLoad");
				if(records) {
					if(records.length > 0) {
						if(masterStore.isDirty()) {
							UniAppManager.setToolbarButtons('save', true);
						}
					}
				}
			}
		}
	});

	var detailGrid = Unilite.createGrid('qms400ukrvGrid2', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'south',
		sortableColumns: false,
		flex	: .7,				//20201006 추가
		split	: true,				//20201006 추가
		uniOpt	: {
			userToolbar			: false,
			expandLastColumn	: true,
			useRowNumberer		: true,
			useMultipleSorting	: true,
			onLoadSelectFirst 	: false
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns	: columns,
		listeners :{
			beforeedit : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE', 'INSPEC_NUM', 'INSPEC_SEQ', 'INSPEC_TIME', 'P507', 'SUM_BAD_QTY', 'SUM_BAD_QTY'])) {
					return false;
				} else {
					return true;
				}
			},
			render: function(grid, eOpts) {
				if(masterStore.isDirty() || detailStore.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				}
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ) {
			},
			selectionchange:function( model1, selected, eOpts ){
			}
		}
	});



	/** 작업지시참조기 위한 Search Form, Grid, Inner Window 정의
	 */
	var productionNoSearch = Unilite.createSearchForm('productionNoSearchForm', {
		layout	: {type: 'uniTable', columns : 2},
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			hidden		: true
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'WU',
			allowBlank	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();

					if(!Ext.isEmpty(productionNoSearch.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == productionNoSearch.getValue('DIV_CODE');
						});
					}else{
						store.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_PRODT_DATE',
			endFieldName	: 'TO_PRODT_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today')
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
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
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.product.lotno" default="LOT번호"/>',
			xtype		: 'uniTextfield',
			name		: 'LOT_NO'
		},{
			fieldLabel	: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			xtype		: 'uniTextfield',
			name		: 'WKORD_NUM'
		},
		Unilite.popup('EQU_MACH_CODE',{
			fieldLabel		: '<t:message code="system.label.product.facilities" default="설비"/>',
			validateBlank	: false,
			valueFieldName	: 'EQU_MACH_CODE',
			textFieldName	: 'EQU_MACH_NAME',
			listeners		: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		})]
	});
	//작업지시참조 모델 정의
	Unilite.defineModel('productionNoMasterModel', {
		fields: [
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.item" default="품목"/>'						, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'						, type: 'string'},
			{name: 'PRODT_WKORD_DATE'	, text: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>'			, type: 'uniDate'},
			{name: 'PRODT_START_DATE'	, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'			, type: 'uniDate'},
			{name: 'PRODT_END_DATE'		, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'			, type: 'uniDate'},
			{name: 'WKORD_Q'			, text: '<t:message code="system.label.product. wkordq" default="작지수량"/>'					, type: 'uniQty'},
			{name: 'WK_PLAN_NUM'		, text: '<t:message code="system.label.product.planno" default="계획번호"/>'					, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.product.division" default="사업장"/>'					, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'					, type: 'string' , comboType: 'WU'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.product.sono" default="수주번호"/>'						, type: 'string'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.product.soqty" default="수주량"/>'						, type: 'uniQty'},
			{name: 'REMARK'				, text: '<t:message code="system.label.product.remarks" default="비고"/>'						, type: 'string'},
			{name: 'PRODT_Q'			, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'				, type: 'uniQty'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'				, type: 'uniDate'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.product.unit" default="단위"/>'						, type: 'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'PJT_CODE'			, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'LOT_NO'				, text: 'LOT_NO'			, type: 'string'},
			{name: 'WORK_END_YN'		, text: '<t:message code="system.label.product.forceclosingflag" default="강제마감여부"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.product.custom" default="거래처"/>'						, type: 'string'},
			{name: 'REWORK_YN'			, text: '<t:message code="system.label.product.reworkorderyn" default="재작업지시여부"/>'			, type: 'string'},
			{name: 'STOCK_EXCHG_TYPE'	, text: '<t:message code="system.label.product.inventoryexchangetype" default="재고대체유형"/>'	, type: 'string'},
			{name: 'WKORD_PRSN'			, text: 'WKORD_PRSN'		, type: 'string'},
			{name: 'EQUIP_CODE'			, text: '<t:message code="system.label.product.facilities" default="설비코드"/>'				,type: 'string'},
			{name: 'EQUIP_NAME'			, text: '<t:message code="system.label.product.facilitiesname" default="설비명"/>'				,type: 'string'}
		]
	});
	//작업지시참조 스토어 정의
	var productionStore = Unilite.createStore('productionStore', {
		model	: 'productionNoMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 'qms400ukrvService.selectWorkNum'
			}
		},
		loadStoreRecords : function() {
			var param= productionNoSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//작업지시참조 그리드 정의
	var productionGrid = Unilite.createGrid('pmp110ukrvproductionGrid', {
		store	: productionStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
				}
			}
		}),
		uniOpt	: {
			onLoadSelectFirst	: false,
			useRowNumberer		: true
		},
		columns: [
//			{ dataIndex: 'WORK_SHOP_CODE'	, width: 120 },
			{ dataIndex: 'EQUIP_CODE'		, width: 100 },
			{ dataIndex: 'EQUIP_NAME'		, width: 133 },
			{ dataIndex: 'WKORD_NUM'		, width: 120 },
			{ dataIndex: 'ITEM_CODE'		, width: 100 },
			{ dataIndex: 'ITEM_NAME'		, width: 166 },
			{ dataIndex: 'SPEC'				, width: 100 },
			{ dataIndex: 'ORDER_NUM'		, width: 120 ,hidden: false},		//20201006 수정: 위치변경 / hidden: false
			{ dataIndex: 'CUSTOM_NAME'		, width: 150 ,hidden: false},		//20201006 수정: 위치변경 / hidden: false
			{ dataIndex: 'PRODT_WKORD_DATE'	, width: 80 },
			{ dataIndex: 'PRODT_START_DATE'	, width: 80 },
			{ dataIndex: 'PRODT_END_DATE'	, width: 80 },
			{ dataIndex: 'WKORD_Q'			, width: 73 },
			{ dataIndex: 'WK_PLAN_NUM'		, width: 100 ,hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 100 ,hidden: true},
			{ dataIndex: 'ORDER_Q'			, width: 100 ,hidden: true},
			{ dataIndex: 'REMARK'			, width: 100 },
			{ dataIndex: 'PRODT_Q'			, width: 100 ,hidden: true},
			{ dataIndex: 'DVRY_DATE'		, width: 100 ,hidden: true},
			{ dataIndex: 'STOCK_UNIT'		, width: 33  ,hidden: true},
			{ dataIndex: 'PROJECT_NO'		, width: 100 },
			{ dataIndex: 'PJT_CODE'			, width: 100 },
			{ dataIndex: 'LOT_NO'			, width: 133 },
			{ dataIndex: 'WORK_END_YN'		, width: 100 ,hidden: true},
			{ dataIndex: 'CUSTOM_CODE'		, width: 100 ,hidden: true},
			{ dataIndex: 'REWORK_YN'		, width: 100 ,hidden: true},
			{ dataIndex: 'STOCK_EXCHG_TYPE'	, width: 100 ,hidden: true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				this.returnData(record);
				refProdtOrderWindow.hide();
			}
		},
		returnData: function(record) {
			var records = this.getSelectedRecords();
			if(records) {
				Ext.each(records, function(record, i) {
					UniAppManager.app.onNewDataButtonDown();
					masterGrid.setRefProdtOrderData(record.data);
				});
				panelResult.uniOpt.inLoading = true;
				panelResult.setAllFieldsReadOnly(true);

				var badQtyArray		= new Array();
				var badQtyArray2	= new Array();
				badQtyArray			= gsBadQtyInfo.split(',');
				badQtyArray2		= gsBadQtyInfo2.split(',');
				gsBadQtyInfo2
				detailGrid.getStore().loadStoreRecords(badQtyArray, badQtyArray2, 'ref');

				panelResult.uniOpt.inLoading = false;
			}
		}
	});
	//작업지시참조 메인
	function openrefProdtOrderWindow() {
		if(!panelResult.setAllFieldsReadOnly(true)){
			return false;
		}
		if(!Ext.isEmpty(panelResult.getValue('INSPEC_NUM'))) {
			Unilite.messageBox('신규 버튼을 누른 후 진행하세요.');
			return false;
		}
		if(!refProdtOrderWindow) {
			refProdtOrderWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.product.workorderinfo" default="작업지시정보"/>',
				width	: 830,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [productionNoSearch, productionGrid],
				tbar	: ['->',{
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.product.inquiry" default="조회"/>',
					handler	: function() {
						if(!productionNoSearch.getInvalidMessage()) {
							return false;
						}
						productionStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.purchase.apply" default="적용"/>',
					handler	: function() {
						productionGrid.returnData();
						refProdtOrderWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.product.close" default="닫기"/>',
					handler	: function() {
						refProdtOrderWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						productionNoSearch.clearForm();
						productionGrid.reset();
					},
					beforeclose: function( panel, eOpts ){
						productionNoSearch.clearForm();
						productionGrid.reset();
					},
					show: function( panel, eOpts ) {
						productionNoSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						productionNoSearch.setValue('ITEM_CODE'		, panelResult.getValue('ITEM_CODE'));
						productionNoSearch.setValue('ITEM_NAME'		, panelResult.getValue('ITEM_NAME'));
						productionNoSearch.setValue('EQU_MACH_CODE'	, panelResult.getValue('EQU_MACH_CODE'));
						productionNoSearch.setValue('EQU_MACH_NAME'	, panelResult.getValue('EQU_MACH_NAME'));
						productionNoSearch.setValue('FR_PRODT_DATE'	, UniDate.get('startOfMonth'));
						productionNoSearch.setValue('TO_PRODT_DATE'	, UniDate.get('today'));
					}
				}
			})
		}
		refProdtOrderWindow.center();
		refProdtOrderWindow.show();
	}



	//조회창 폼 정의
	var searchWindowPanel = Unilite.createSearchForm('searchWindowPanelForm', {
		layout	: {type: 'uniTable', columns : 3},
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.inspecno" default="검사번호"/>',
			name		: 'INSPEC_NUM',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '순번',
			name		: 'INSPEC_SEQ',
			xtype		: 'uniNumberfield',
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
			xtype		: 'uniDatefield',
			name		: 'INSPEC_DATE',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			validateBlank	: false,
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			listeners		: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),
		//20201006 추가
		Unilite.popup('EQU_MACH_CODE',{
			fieldLabel		: '<t:message code="system.label.product.facilities" default="설비"/>',
			validateBlank	: false,
			valueFieldName	: 'EQU_MACH_CODE',
			textFieldName	: 'EQU_MACH_NAME',
			listeners		: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: 'DIV_CODE',
			name		: 'DIV_CODE',
			xtype		: 'uniTextfield',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]
	});
	//조회창 모델 정의
	Unilite.defineModel('searchWindowModel', {
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'					,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'					,type: 'string'},
			{name: 'INSPEC_NUM'			,text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'					,type: 'string'},
			{name: 'INSPEC_SEQ'			,text: '검사순번'			,type: 'int'},
			{name: 'INSPEC_DATE'		,text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'					,type: 'uniDate'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'							,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'							,type: 'string'},
			{name: 'INSPEC_TYPE'		,text: '<t:message code="system.label.product.inspectype" default="검사유형"/>'					,type: 'string'	, comboType:'AU' , comboCode:'Q006', allowBlank: false},
			{name: 'INSPEC_Q'			,text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'					,type: 'uniQty'	, allowBlank: false},
			{name: 'INSPEC_PRSN'		,text: '<t:message code="system.label.product.inspector" default="검사자"/>'					,type :'string'	, comboType:"AU", comboCode:"P509"},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'				,type: 'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'						,type: 'string'},
			{name: 'EQUIP_CODE'			,text: '<t:message code="system.label.product.facilities" default="설비코드"/>'					,type: 'string'},
			{name: 'EQUIP_NAME'			,text: '<t:message code="system.label.product.facilitiesname" default="설비명"/>'				,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.inventory.remarks" default="비고"/>'					,type: 'string'}
		]
	});
	//조회창 스토어 정의
	var searchWindowStore = Unilite.createStore('searchWindowStore', {
		model	: 'searchWindowModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'qms400ukrvService.searchWindowSelectList'
			}
		},
		loadStoreRecords : function() {
			var param= searchWindowPanel.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//조회창 그리드 정의
	var searchWindowGrid = Unilite.createGrid('srq100ukrvOrderNoMasterGrid', {
		store	: searchWindowStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: false
		},
		columns	: [
			{ dataIndex: 'COMP_CODE'		, width: 66	, hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 66	, hidden: true},
			{ dataIndex: 'INSPEC_NUM'		, width: 120 },
			{ dataIndex: 'INSPEC_SEQ'		, width: 80},
			{ dataIndex: 'INSPEC_DATE'		, width: 80},
			{ dataIndex: 'ITEM_CODE'		, width: 110},
			{ dataIndex: 'ITEM_NAME'		, width: 150},
			{ dataIndex: 'SPEC'				, width: 150},
			{ dataIndex: 'EQUIP_CODE'		, width: 100, hidden: false},		//20201006 수정: 위치변경 / hidden: false
			{ dataIndex: 'EQUIP_NAME'		, width: 100, hidden: false},		//20201006 수정: 위치변경 / hidden: false
			{ dataIndex: 'INSPEC_TYPE'		, width: 80},
			{ dataIndex: 'INSPEC_Q'			, width: 100, hidden: true},
			{ dataIndex: 'INSPEC_PRSN'		, width: 100, hidden: true},
			{ dataIndex: 'WKORD_NUM'		, width: 100, hidden: true},
			{ dataIndex: 'LOT_NO'			, width: 100, hidden: true},
			{ dataIndex: 'REMARK'			, flex: 1}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				searchWindowGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				searchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelResult.uniOpt.inLoading = true;
			panelResult.setValues({
				'DIV_CODE'		: record.get('DIV_CODE'),
				'INSPEC_NUM'	: record.get('INSPEC_NUM'),
				'INSPEC_SEQ'	: record.get('INSPEC_SEQ'),
				'INSPEC_PRSN'	: record.get('INSPEC_PRSN'),
				'INSPEC_DATE'	: record.get('INSPEC_DATE')			//20201006 추가
			});
			panelResult.uniOpt.inLoading = false;
		}
	});
	//조회창 메인
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '자주검사 데이터 조회',
				width	: 1000,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [searchWindowPanel, searchWindowGrid],
				tbar	: ['->',{
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						searchWindowStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						searchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						searchWindowPanel.clearForm();
						searchWindowGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						searchWindowPanel.clearForm();
						searchWindowGrid.reset();
					},
					beforeshow: function( panel, eOpts ) {
						searchWindowPanel.setValue('DIV_CODE'	, panelResult.getValue('DIV_CODE'));
						searchWindowPanel.setValue('INSPEC_DATE', UniDate.get('today'));
					}
				}
			})
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
	}



	Unilite.Main({
		id			: 'qms400ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items:[
				masterGrid, detailGrid, panelResult
			]
		}],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'], true);
			this.setDefault();
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('INSPEC_DATE'	, UniDate.get('today'));
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		},
		onNewDataButtonDown: function() {
			var inspec_num = panelResult.getValue('INSPEC_NUM');
			var inspecType = panelResult.getValue('INSPEC_TYPE');
			if(Ext.isEmpty(inspecType)){
				inspecType = '01'
			}
			var inspecPrsn = panelResult.getValue('INSPEC_PRSN');
			var seq = masterStore.max('INSPEC_SEQ');
			if(!seq) seq = 1;
			else seq += 1;
			//참조 적용 시 detail data 가져오기 위해 seq 정보 저장변수
			gsSeq = seq;

			var r = {
				INSPEC_NUM	: inspec_num,
				INSPEC_SEQ	: seq,
				INSPEC_TYPE	: inspecType,
				INSPEC_PRSN	: inspecPrsn
			};
			masterGrid.createRow(r);
			panelResult.setAllFieldsReadOnly(false);
		},
		onQueryButtonDown: function() {
			detailStore.loadData({});
			var inspecNum = panelResult.getValue('INSPEC_NUM');
			if(Ext.isEmpty(inspecNum)) {
				openSearchInfoWindow();
			} else {
				panelResult.setAllFieldsReadOnly(true);
				masterStore.loadStoreRecords();
				var badQtyArray		= new Array();
				var badQtyArray2	= new Array();
				badQtyArray			= gsBadQtyInfo.split(',');
				badQtyArray2		= gsBadQtyInfo2.split(',');
				gsBadQtyInfo2
				detailGrid.getStore().loadStoreRecords(badQtyArray, badQtyArray2);
			}
		},
		onResetButtonDown: function() {		// 새로고침 버튼
			this.suspendEvents();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterStore.loadData({});
			detailStore.loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(masterStore.isDirty()){
				masterStore.saveStore();
			} else {
				detailStore.clearFilter();
				detailStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow			= masterGrid.getSelectedRecord();
			var detailRecords	= new Array();
			if(selRow) {
				var deleteFlag = true;
				if(selRow.phantom != true)	{
					if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						detailStore.clearFilter();
						var detailData2 = detailStore.data.items;
						if(!Ext.isEmpty(detailData2)) {
							Ext.each(detailData2, function(data2, i) {
								if(Ext.isDefined(data2) && data2.data.INSPEC_NUM == selRow.data.INSPEC_NUM && data2.data.INSPEC_SEQ == selRow.data.INSPEC_SEQ) {
									detailRecords.push(data2);
								}
							});
							detailStore.remove(detailRecords);
						}
						masterGrid.deleteSelectedRow();
					} else {
						return false;
					}
				} else {
					detailStore.clearFilter();
					var detailData2 = detailStore.data.items;
					if(!Ext.isEmpty(detailData2)) {
						Ext.each(detailData2, function(data2, i) {
							if(Ext.isDefined(data2) && data2.data.INSPEC_NUM == selRow.data.INSPEC_NUM && data2.data.INSPEC_SEQ == selRow.data.INSPEC_SEQ) {
								detailRecords.push(data2);
							}
						});
						detailStore.remove(detailRecords);
					}
					masterGrid.deleteSelectedRow();
				}
			} else {
				Unilite.messageBox(Msg.sMB016);
				return false;
			}
		}
	});



	/** Validation
	 */
/*	Unilite.createValidator('validator00', {
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
				break;
			}
			return rv;
		}
	});*/

/*	Unilite.createValidator('validator01', {
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
	});*/



	// 모델 필드 생성
	function createModelField(colData) {
		var fields = [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'					,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'					,type: 'string'},
			{name: 'INSPEC_NUM'			,text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'					,type: 'string'},
			{name: 'INSPEC_SEQ'			,text: '순번'			,type: 'int'},
			{name: 'INSPEC_TIME'		,text: '검사차수'		,type: 'string'	, comboType:'AU' , comboCode:'Q043'},
			{name: 'P507'				,text: '작업조'		,type: 'string'	, comboType:'AU' , comboCode:'P507'},
			{name: 'INSPEC_PRSN'		,text: '작업자'		,type :'string'	, comboType: 'AU', comboCode: 'P505'},
			{name: 'REMARK'				,text: '비고'			,type :'string'}				//20201006 추가
		];
		//동적 컬럼 모델 push
		Ext.each(colData, function(item, index){
			fields.push({name: 'BAD_' + item.SUB_CODE, type:'uniQty' });
		});
		fields.push({name: 'SUM_BAD_QTY', type:'uniQty' });
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var array1  = new Array();
		var columns = [
			{dataIndex: 'COMP_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'INSPEC_NUM'		, width: 120	, hidden: true},
			{dataIndex: 'INSPEC_SEQ'		, width: 80		, hidden: true},
			{dataIndex: 'INSPEC_TIME'		, width: 120	, align: 'center'},
			{dataIndex: 'P507'				, width: 100	, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
			},
			{dataIndex: 'INSPEC_PRSN'		, width: 100	, align: 'center'}
		];
		Ext.each(colData, function(item, index){
			if(index == 0){
				gsBadQtyInfo	= 'BAD_' + item.SUB_CODE;
				gsBadQtyInfo2	= item.SUB_CODE;
			} else {
				gsBadQtyInfo	+= ',' + 'BAD_' + item.SUB_CODE;
				gsBadQtyInfo2	+= ',' + item.SUB_CODE;
			}
			array1[index] = Ext.applyIf({dataIndex: 'BAD_' + item.SUB_CODE	, text: item.CODE_NAME	, width:100},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum' });
		});
		columns.push(
			{text: '불량유형',
				columns: array1
			}
		);
		columns.push({dataIndex: 'SUM_BAD_QTY'	, text: '합계', width: 100, align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum' });
		//20201006 추가
		columns.push({dataIndex: 'REMARK'		, text: '비고', width: 150});
		console.log(columns);
		return columns;
	}
}
</script>