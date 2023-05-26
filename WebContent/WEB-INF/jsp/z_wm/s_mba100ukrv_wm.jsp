<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mba100ukrv_wm">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P401"/>	<!-- 단가확정여부 (1: 미확정, 2: 확정) -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>	<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="Z001"/>	<!-- 단가구분(H-홈페이지, C-카페, Z-기타(기본값, REF1 = 'Y')) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM01"/>	<!-- 접수구분(10:홈페이지, 20:T전화, 30:카페, 40:입찰) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM03"/>	<!-- 진행상태(A-접수, B-도착, C-분해작업중, D-분해작업완료, E-검사, F-) -->
	<t:ExtComboStore comboType="OU"/>
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	var initFlag = true;
	var BsaCodeInfo	= {
		defaultSalesPrsn	: '${defaultSalesPrsn}'		//20201022 추가 - 사용자의 영업담당 가져와서 기본값 SET하는 로직
	}
	//20201022 추가: 동적컬럼 조회로직 단순화를 위해 전역변수로 변경
	var gsBadQtyArray	= new Array();
	var gsBadQtyArray2	= new Array();
	//20201022 추가: 불량유형 동적으로 구현하기 위해 추가
	var colData			= ${colData};
	var fields			= createModelField(colData);
	var columns			= createGridColumn(colData);

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelResult.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					if(Ext.isEmpty(newValue)) {
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{//20201022 추가
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{	//20201022 추가
			fieldLabel	: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>',
			name		: 'INSPEC_NUM',
			xtype		: 'uniTextfield',
			fieldStyle	: 'IME-MODE: inactive',				//IE에서만 적용 됨
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						var newValue = panelResult.getValue('INSPEC_NUM');
						if(!Ext.isEmpty(newValue)) {
							directMasterStore1.loadStoreRecords(null, newValue);
							directMasterStore2.loadStoreRecords(null, newValue);
							panelResult.setValue('INSPEC_NUM', '');
						}
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_PRSN',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'INSPEC_DATE_FR',
			endFieldName	: 'INSPEC_DATE_TO'
		},{
			fieldLabel	: '상태',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '미확정',
				name		: 'rdoSelect',
				inputValue	: '1',
				width		: 70
			},{
				boxLabel	: '확정',
				name		: 'rdoSelect',
				inputValue	: '2',
				width		: 60
			},{
				boxLabel	: '전체',
				name		: 'rdoSelect',
				inputValue	: '',
				width		: 70
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!initFlag) {
						directMasterStore1.loadStoreRecords(newValue.rdoSelect);
						directMasterStore2.loadStoreRecords(newValue.rdoSelect);
					}
				}
			}
		}]
	});


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_mba100ukrv_wmService.selectList1',
			update	: 's_mba100ukrv_wmService.updateList1',
			syncAll	: 's_mba100ukrv_wmService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_mba100ukrv_wmService.selectList2',
			update	: 's_mba100ukrv_wmService.updateList2',
			syncAll	: 's_mba100ukrv_wmService.saveAll2'
		}
	});

	Unilite.defineModel('s_mba100ukrv_wmModel1', {
		fields: [
			//S_MPO010T_WM (MASTER)
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'	, allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'	, allowBlank: false	, comboType:'BOR120'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'CUSTOM_PRSN'	, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'		, type: 'string'},
			{name: 'RECEIPT_DATE'	, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'		, type: 'uniDate'},
			{name: 'PRICE_TYPE'		, text: '<t:message code="system.label.common.priceclass" default="단가구분"/>'			, type: 'string'	, comboType:'AU' , comboCode:'Z001'},
			{name: 'ORDER_PRSN'		, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string'	, comboType:'AU' , comboCode:'S010'},	//20201022 추가
			//S_MPO020T_WM (DETAIL)
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.unit" default="단위"/>'				, type: 'string'},
			{name: 'INSTOCK_Q'		, text: '수량'		, type: 'uniQty'},
			{name: 'CONTROL_STATUS'	, text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'	, type: 'string'	, comboType:'AU' , comboCode:'ZM03'},
			{name: 'RECEIPT_NUM'	, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'		, type: 'string'},
			{name: 'RECEIPT_SEQ'	, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'		, type: 'int'},
			{name: 'CONFIRM_YN'		, text: '확정여부'		, type: 'string'	, comboType:'AU' , comboCode:'P401'},
			{name: 'CONFIRM_DATE'	, text: '단가확정일'		, type: 'uniDate'},
			{name: 'CONFIRM_PRSN'	, text: '단가확정자'		, type: 'string'}
		]
	});

	Unilite.defineModel('s_mba100ukrv_wmModel2', {
		fields : fields				//20201022 수정: 동적 그리드 구현
/*		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'	, type: 'string', allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string', allowBlank: false},
			{name: 'INSPEC_NUM'		, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'		, type: 'string'},
			{name: 'INSPEC_SEQ'		, text: '<t:message code="system.label.purchase.seq" default="순번"/>'			, type: 'int'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'			, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.unit" default="단위"/>'			, type: 'string'},
			{name: 'GOOD_INSPEC_Q'	, text: '양품수량'		, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q'	, text: '불량수량'		, type: 'uniQty'},
			{name: 'RECEIPT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'			, type: 'uniUnitPrice'},
			{name: 'RECEIPT_O'		, text: '<t:message code="system.label.purchase.amount" default="금액"/>'			, type: 'uniPrice'},
			{name: 'RECEIPT_NUM'	, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'	, type: 'string'},
			{name: 'RECEIPT_SEQ'	, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'	, type: 'int'},
			{name: 'CONFIRM_YN'		, text: '단가확정여부'	, type: 'string'},
			{name: 'CONFIRM_DATE'	, text: '단가확정일'		, type: 'uniDate'},
			{name: 'CONFIRM_PRSN'	, text: '단가확정자'		, type: 'string'},
			{name: 'RECEIPT_DATE'	, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'	, type: 'uniDate'},
			{name: 'MONEY_UNIT'		, text: 'MONEY_UNIT', type: 'string'},			//단가가져오는 용
			{name: 'PRICE_TYPE'		, text: 'PRICE_TYPE', type: 'string'},			//단가가져오는 용
			{name: 'CONFIRM_YN'		, text: '확정여부'		, type: 'string'	, comboType:'AU' , comboCode:'P401'}
		]*/
	});

	var directMasterStore1 = Unilite.createStore('s_mba100ukrv_wmMasterStore1', {
		model	: 's_mba100ukrv_wmModel1',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(newValue, barcodeData){	//20201022 추가: , barcodeData
			var param = panelResult.getValues();
			if(newValue || newValue == '') {
				param.rdoSelect = newValue;
			}
			//20201022 추가: 바코드 스캔 시 조회
			if(!Ext.isEmpty(barcodeData)) {
				param.INSPEC_NUM = barcodeData;
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs	= this.getInvalidRecords();
//			var toCreate	= this.getNewRecords();
//			var toUpdate	= this.getUpdatedRecords();
//			var toDelete	= this.getRemovedRecords();
//			var list		= [].concat(toUpdate, toCreate);
//			console.log("list:", list);
			var paramMaster	= panelResult.getValues();

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						if(directMasterStore2.isDirty()){
							directMasterStore2.saveStore();
						} else {
							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				Ext.getCmp('s_mba100ukrv_wmGrid1').uniSelectInvalidColumnAndAlert(inValidRecs);
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

	var directMasterStore2 = Unilite.createStore('s_mba100ukrv_wmMasterStore2', {
		model	: 's_mba100ukrv_wmModel2',
		proxy	: directProxy2,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결, 20201223 수정: true로 변경 - 저장버튼 활성화 안 됨;;
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(newValue, barcodeData){
			var param = panelResult.getValues();
			if(newValue || newValue == '') {
				param.rdoSelect = newValue;
			}
			//20201022 추가: 바코드 스캔 시 조회
			if(!Ext.isEmpty(barcodeData)) {
				param.INSPEC_NUM = barcodeData;
			}
			//20201022 추가: 동적 그리드 데이터 조회하기 위해 추가
			if(!Ext.isEmpty(gsBadQtyArray)) {
				param.badQtyArray = gsBadQtyArray;
			}
			if(!Ext.isEmpty(gsBadQtyArray2)) {
				param.badQtyArray2 = gsBadQtyArray2;
			}
			this.load({
				params : param
			});
		},
		saveStore: function() {
			directMasterStore2.clearFilter();
			var inValidRecs	= this.getInvalidRecords();
			var paramMaster	= panelResult.getValues();

			if(inValidRecs.length == 0) {
				var config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
//						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				directMasterStore2.filterBy(function(record){
					return record.get('RECEIPT_NUM') == 'ZZZZZ'
						&& record.get('RECEIPT_SEQ') == 'ZZZZZ';
				})
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	var masterGrid = Unilite.createGrid('s_mba100ukrv_wmGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			useLiveSearch		: true,
			expandLastColumn	: true,
			useRowNumberer		: false
		},
		tbar: [{
			itemId	: 'receiptBtn',
			text	: '확정/미확정',
			width	: 100,
			handler	: function() {
				if(UniAppManager.app._needSave()) {
					Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
					return false;
				}
				var records = masterGrid.getSelectionModel().getSelection();
				if(Ext.isEmpty(records)) {
					Unilite.messageBox('선택된 데이터가 없습니다.');
					return false;
				}
				var confirmYN = records[0].get('CONFIRM_YN') == '1' ? 'Y' : 'N'
				buttonStore.saveStore(confirmYN);
			}
		},'-'],
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
					var selectedCustom = rowSelection.selected.items[0];
					if(Ext.isEmpty(selectedCustom) || selectedCustom.get('CONFIRM_YN') == record.get('CONFIRM_YN')) {
						return true;
					} else {
//						Unilite.messageBox('동일한 상태의 데이터만 선택할 수 있습니다.');
						return false;
					}
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					if (this.selected.getCount() == 0) {
						directMasterStore2.filterBy(function(record){
							return record.get('RECEIPT_NUM') == 'ZZZZZ'
								&& record.get('RECEIPT_SEQ') == 'ZZZZZ';
						})
					}
				}
			}
		}),
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'CONFIRM_YN'		, width: 80	, align:'center'},
//			{dataIndex: 'CUSTOM_CODE'		, width: 100},
			{dataIndex: 'CUSTOM_NAME'		, width: 150},
			{dataIndex: 'CUSTOM_PRSN'		, width: 120},
			{dataIndex: 'RECEIPT_DATE'		, width: 90},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'ORDER_UNIT'		, width: 80	, align:'center'},
			{dataIndex: 'INSTOCK_Q'			, width: 100},
			{dataIndex: 'CONTROL_STATUS'	, width: 100, align:'center'},
			{dataIndex: 'RECEIPT_NUM'		, width: 120},
			{dataIndex: 'RECEIPT_SEQ'		, width: 66	, align:'center'},
			{dataIndex: 'PRICE_TYPE'		, width: 100, align:'center'},
			{dataIndex: 'ORDER_PRSN'		, width: 100, align:'center'},	//20201022 추가
			{dataIndex: 'CONFIRM_YN'		, width: 100, hidden: true},
			{dataIndex: 'CONFIRM_DATE'		, width: 100, hidden: true},
			{dataIndex: 'CONFIRM_PRSN'		, width: 100, hidden: true}
		],
		listeners: {
			selectionchange: function( grid, selected, eOpts ){
				directMasterStore2.clearFilter();
				//선택된 행의 저장된 데이터만 detailGrid에 보여주도록 filter
				if(selected && selected[0]) {
					directMasterStore2.filterBy(function(record){
						return record.get('RECEIPT_NUM') == selected[0].get('RECEIPT_NUM')
							&& record.get('RECEIPT_SEQ') == selected[0].get('RECEIPT_SEQ');
					})
					//20210315 추가
					sumAmount(selected[0]);
				} else {
					directMasterStore2.filterBy(function(record){
						return record.get('RECEIPT_NUM') == 'ZZZZZ'
							&& record.get('RECEIPT_SEQ') == 'ZZZZZ';
					})
				}
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ){
				directMasterStore2.clearFilter();
				//선택된 행의 저장된 데이터만 detailGrid에 보여주도록 filter
				if(thisRecord) {
					directMasterStore2.filterBy(function(record){
						return record.get('RECEIPT_NUM') == thisRecord.get('RECEIPT_NUM')
							&& record.get('RECEIPT_SEQ') == thisRecord.get('RECEIPT_SEQ');
					})
					//20210315 추가
					sumAmount(thisRecord);
				}
			},
			beforeedit: function( editor, e, eOpts ) {
				//확정인 데이터는 수정 불가
				if(e.record.data.CONFIRM_YN == '2') {
					return false;
				}
				if(UniUtils.indexOf(e.field,['PRICE_TYPE', 'ORDER_PRSN'])){	//20201022 추가: ORDER_PRSN 추가
					return true;
				} else {
					return false;
				}
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('s_mba100ukrv_wmGrid2', {
		store	: directMasterStore2,
		layout	: 'fit',
		region	: 'south',
		uniOpt	: {
			useLiveSearch	: true,
			expandLastColumn: true
		},
		tbar	: [{
			//20210315 추가
			xtype		: 'uniNumberfield',
			fieldLabel	: '합계',
			type		: 'uniPrice',
			itemId		: 'summaryAmount',
			readOnly	: true,
			value		: 0,
			labelWidth	: 30
		}],
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns	: columns,				//20201022 수정: 동적 그리드 구현
/*		columns: [
			{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'INSPEC_NUM'	, width: 120, hidden: true},
			{dataIndex: 'INSPEC_SEQ'	, width: 66	, hidden: true, align:'center'},
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 150},
			{dataIndex: 'SPEC'			, width: 150},
			{dataIndex: 'ORDER_UNIT'	, width: 80	,align:'center'},
			{dataIndex: 'GOOD_INSPEC_Q'	, width: 100},
			{dataIndex: 'BAD_INSPEC_Q'	, width: 100},
			{dataIndex: 'RECEIPT_P'		, width: 100},
			{dataIndex: 'RECEIPT_O'		, width: 100},
			{dataIndex: 'RECEIPT_NUM'	, width: 120, hidden: true},
			{dataIndex: 'RECEIPT_SEQ'	, width: 66	, hidden: true},
			{dataIndex: 'RECEIPT_DATE'	, width: 100, hidden: true},
			{dataIndex: 'CONFIRM_YN'	, width: 100, hidden: true},
			{dataIndex: 'CONFIRM_DATE'	, width: 100, hidden: true},
			{dataIndex: 'CONFIRM_PRSN'	, width: 100, hidden: true},
			{dataIndex: 'MONEY_UNIT'	, width: 100, hidden: true},
			{dataIndex: 'ORDER_UNIT'	, width: 100, hidden: true},
			{dataIndex: 'PRICE_TYPE'	, width: 100, hidden: true},
			{dataIndex: 'CONFIRM_YN'	, width: 100, hidden: true}
		],*/
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				//확정인 데이터는 수정 불가
				if(e.record.data.CONFIRM_YN == '2') {
					return false;
				}
				if (UniUtils.indexOf(e.field,['RECEIPT_P', 'RECEIPT_O', 'BAD_RECEIPT_P', 'BAD_RECEIPT_O'])){	//20210204 추가: 'BAD_RECEIPT_P', 'BAD_RECEIPT_O'
					return true;
				} else {
					return false;
				}
			}
		}
	});



	/*
	 * 확정/미확정 저장로직
	 */
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 's_mba100ukrv_wmService.confirmDetail',
			syncAll	: 's_mba100ukrv_wmService.confirmAll'
		}
	});
	var buttonStore = Unilite.createStore('buttonStore',{
		proxy		: directButtonProxy,
		uniOpt		: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		saveStore	: function(saveFlag) {
			var inValidRecs			= this.getInvalidRecords();
			var paramMaster			= panelResult.getValues();
			paramMaster.confirmFlag	= saveFlag;
			var confirmMsg			= '';
			
			if(saveFlag == 'Y') {
				confirmMsg = '해당 데이터의 단가를 확정하시겠습니까?';
			} else {
				confirmMsg = '확정된 단가를 취소하시겠습니까?';
			}
			//작업진행 여부 확인
			if(!confirm(confirmMsg)) {
				return false;
			}

			var selRecords = masterGrid.getSelectionModel().getSelection();
			Ext.each(selRecords, function(selRecord, index) {
				selRecord.phantom = true;
				buttonStore.insert(index, selRecord);
			})

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success : function(batch, option) {
						buttonStore.clearData();
						UniAppManager.app.onQueryButtonDown();
					},
					failure: function(batch, option) {
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



	Unilite.Main({
		id			: 's_mba100ukrv_wmApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, masterGrid2, panelResult
			]
		}],
		fnInitBinding : function() {
			initFlag = true;
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('INSPEC_DATE_TO'	, UniDate.get('today'));
			panelResult.setValue('INSPEC_DATE_FR'	, UniDate.add(panelResult.getValue('INSPEC_DATE_TO'), {weeks: -1}));
			panelResult.setValue('rdoSelect'		, '1');

			//20201022 추가: 조회조건 / 기본값 setting로직 추가, 20210119 주석 해제
			var field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, 'DIV_CODE');
			panelResult.setValue('ORDER_PRSN', BsaCodeInfo.defaultSalesPrsn);

			UniAppManager.setToolbarButtons(['reset'], true);
			initFlag = false;
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) {
				return false;
			}
			masterGrid2.getStore().loadData({});
			directMasterStore1.loadStoreRecords();
			directMasterStore2.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			directMasterStore1.loadData({});
			directMasterStore2.loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(directMasterStore1.isDirty()){
				directMasterStore1.saveStore();
			}else if(directMasterStore2.isDirty()){
				directMasterStore2.saveStore();
			}
		}
	});



	//20210315 추가
	function sumAmount(thisRecord) {
		var sumAmount	= 0;
		var goodAmount	= 0;
		var baddAmount	= 0;
		var results = directMasterStore2.sumBy(function(record, id) {
			return record.get('RECEIPT_NUM') == thisRecord.get('RECEIPT_NUM')
				&& record.get('RECEIPT_SEQ') == thisRecord.get('RECEIPT_SEQ');
			},
			['RECEIPT_O', 'BAD_RECEIPT_O']);
		goodAmount	= results.RECEIPT_O;
		baddAmount	= results.BAD_RECEIPT_O;
		sumAmount	= goodAmount + baddAmount;
		masterGrid2.down('#summaryAmount').setValue(sumAmount);
	}



	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case 'PRICE_TYPE':
					if(newValue != oldValue) {
						//20201022 추가: 단가구분, 영업담당은 접수번호가 동일하면 동일한 값으로 SET
						var mRecords = directMasterStore1.data.items;
						Ext.each(mRecords, function(mRecord, index) {
							if(record.get('RECEIPT_NUM') == mRecord.get('RECEIPT_NUM')) {
								mRecord.set('PRICE_TYPE', newValue);
							}
						});

						var dRecords = directMasterStore2.data.items;
						Ext.each(dRecords, function(dRecord, index) {
							dRecord.set('PRICE_TYPE', newValue);
							if(!Ext.isEmpty(newValue)) {
								var param = {
									DIV_CODE	: dRecord.get('DIV_CODE'),
									TYPE		: newValue,
									ITEM_CODE	: dRecord.get('ITEM_CODE'),
									MONEY_UNIT	: dRecord.get('MONEY_UNIT'),
									ORDER_UNIT	: dRecord.get('ORDER_UNIT'),
									RECEIPT_DATE: UniDate.getDbDateStr(dRecord.get('RECEIPT_DATE'))
								}
								s_mba100ukrv_wmService.getBasicP(param, function(provider, response){
									if(provider && provider.length == 0) {
										dRecord.set('RECEIPT_P', 0);
										dRecord.set('RECEIPT_O', 0);
									} else {
										//단가 정보가 있을 경우
										dRecord.set('RECEIPT_P', provider);
										dRecord.set('RECEIPT_O', Unilite.multiply(dRecord.get('GOOD_INSPEC_Q'), provider));
									}
								});
							}
						});
					}
				break;

				//20201022 추가: 단가구분, 영업담당은 접수번호가 동일하면 동일한 값으로 SET
				case 'ORDER_PRSN':
					if(newValue != oldValue) {
						var mRecords = directMasterStore1.data.items;
						Ext.each(mRecords, function(mRecord, index) {
							if(record.get('RECEIPT_NUM') == mRecord.get('RECEIPT_NUM')) {
								mRecord.set('ORDER_PRSN', newValue);
							}
						});
					}
			}
			return rv;
		}
	});

	Unilite.createValidator('validator02', {
		store	: directMasterStore2,
		grid	: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(newValue == oldValue){
				return true;
			}
			var rv = true;
			switch(fieldName) {
				case 'RECEIPT_P':
					if(newValue <= 0){
						rv = '<t:message code="system.message.purchase.message068" default="0보다 큰 값이 입력되어야 합니다."/>';
						record.set('RECEIPT_P', oldValue)
						break;
					}
					record.set('RECEIPT_O', Unilite.multiply(record.get('GOOD_INSPEC_Q'), newValue));
					//20210315 추가
					sumAmount(record);
				break;

				case 'RECEIPT_O':
					if(newValue <= 0){
						rv = '<t:message code="system.message.purchase.message068" default="0보다 큰 값이 입력되어야 합니다."/>';
						record.set('RECEIPT_O', oldValue)
						break;
					}
					record.set('RECEIPT_P', newValue / record.get('GOOD_INSPEC_Q'));
					//20210315 추가
					record.set('RECEIPT_O', newValue);
					sumAmount(record);
				break;

				//20210204 추가: 'BAD_RECEIPT_P', 'BAD_RECEIPT_O'
				case 'BAD_RECEIPT_P':
					if(Ext.isEmpty(record.get('BAD_INSPEC_Q')) || record.get('BAD_INSPEC_Q') == 0) {
						rv = '불량수량이 0인 데이터는 단가/금액을 입력할 수 없습니다.';
						record.set('BAD_RECEIPT_P', oldValue)
						break;
					}
					if(newValue < 0){
						rv = '<t:message code="system.message.purchase.message068" default="0보다 큰 값이 입력되어야 합니다."/>';
						record.set('BAD_RECEIPT_P', oldValue)
						break;
					}
					record.set('BAD_RECEIPT_O', Unilite.multiply(record.get('BAD_INSPEC_Q'), newValue));
					//20210315 추가
					sumAmount(record);
				break;

				case 'BAD_RECEIPT_O':
					if(Ext.isEmpty(record.get('BAD_INSPEC_Q')) || record.get('BAD_INSPEC_Q') == 0) {
						rv = '불량수량이 0인 데이터는 단가/금액을 입력할 수 없습니다.';
						record.set('BAD_RECEIPT_O', oldValue)
						break;
					}
					if(newValue < 0){
						rv = '<t:message code="system.message.purchase.message068" default="0보다 큰 값이 입력되어야 합니다."/>';
						record.set('BAD_RECEIPT_O', oldValue)
						break;
					}
					record.set('BAD_RECEIPT_P', newValue / record.get('BAD_INSPEC_Q'));
					//20210315 추가
					record.set('BAD_RECEIPT_O', newValue);
					sumAmount(record);
				break;
			}
			return rv;
		}
	});





	// 모델 필드 생성
	function createModelField(colData) {
		var fields = [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'	, type: 'string', allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string', allowBlank: false},
			{name: 'INSPEC_NUM'		, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'		, type: 'string'},
			{name: 'INSPEC_SEQ'		, text: '<t:message code="system.label.purchase.seq" default="순번"/>'			, type: 'int'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'			, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.unit" default="단위"/>'			, type: 'string'},
			{name: 'GOOD_INSPEC_Q'	, text: '양품'		, type: 'uniQty'},
			{name: 'RECEIPT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'			, type: 'uniUnitPrice'},
			{name: 'RECEIPT_O'		, text: '<t:message code="system.label.purchase.amount" default="금액"/>'			, type: 'uniPrice'},
			{name: 'BAD_INSPEC_Q'	, text: '불량'		, type: 'uniQty'},
			{name: 'BAD_RECEIPT_P'	, text: '<t:message code="system.label.purchase.price" default="단가"/>'			, type: 'uniUnitPrice'},	//20210204 추가
			{name: 'BAD_RECEIPT_O'	, text: '<t:message code="system.label.purchase.amount" default="금액"/>'			, type: 'uniPrice'},		//20210204 추가
			{name: 'RECEIPT_NUM'	, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'	, type: 'string'},
			{name: 'RECEIPT_SEQ'	, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'	, type: 'int'},
			{name: 'CONFIRM_YN'		, text: '단가확정여부'	, type: 'string'},
			{name: 'CONFIRM_DATE'	, text: '단가확정일'		, type: 'uniDate'},
			{name: 'CONFIRM_PRSN'	, text: '단가확정자'		, type: 'string'},
			{name: 'RECEIPT_DATE'	, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'	, type: 'uniDate'},
			{name: 'MONEY_UNIT'		, text: 'MONEY_UNIT', type: 'string'},			//단가가져오는 용
			{name: 'PRICE_TYPE'		, text: 'PRICE_TYPE', type: 'string'},			//단가가져오는 용
			{name: 'CONFIRM_YN'		, text: '확정여부'		, type: 'string'	, comboType:'AU' , comboCode:'P401'},
			{name: 'REMARK'			, text: '비고'		, type: 'string'}			//20210113 추가
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
			{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'INSPEC_NUM'	, width: 120, hidden: true},
			{dataIndex: 'INSPEC_SEQ'	, width: 66	, hidden: true, align:'center'},
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 150},
			{dataIndex: 'SPEC'			, width: 150},
			{dataIndex: 'ORDER_UNIT'	, width: 80	,align:'center'},
			//20210204 수정
			{text: '양품',
				columns: [
					{dataIndex: 'GOOD_INSPEC_Q'	, width: 80},
					{dataIndex: 'RECEIPT_P'		, width: 100},
					{dataIndex: 'RECEIPT_O'		, width: 100}
				]
			},
			{text: '불량',
				columns: [
					{dataIndex: 'BAD_INSPEC_Q'	, width: 80},
					{dataIndex: 'BAD_RECEIPT_P'	, width: 100},			//20210204 추가
					{dataIndex: 'BAD_RECEIPT_O'	, width: 100}			//20210204 추가
				]
			},
			{dataIndex: 'RECEIPT_NUM'	, width: 120, hidden: true},
			{dataIndex: 'RECEIPT_SEQ'	, width: 66	, hidden: true},
			{dataIndex: 'RECEIPT_DATE'	, width: 100, hidden: true},
			{dataIndex: 'CONFIRM_YN'	, width: 100, hidden: true},
			{dataIndex: 'CONFIRM_DATE'	, width: 100, hidden: true},
			{dataIndex: 'CONFIRM_PRSN'	, width: 100, hidden: true},
			{dataIndex: 'MONEY_UNIT'	, width: 100, hidden: true},
			{dataIndex: 'ORDER_UNIT'	, width: 100, hidden: true},
			{dataIndex: 'PRICE_TYPE'	, width: 100, hidden: true},
			{dataIndex: 'CONFIRM_YN'	, width: 100, hidden: true},
			{dataIndex: 'REMARK'		, width: 150}			//20210113 추가
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
		gsBadQtyArray	= gsBadQtyInfo.split(',');
		gsBadQtyArray2	= gsBadQtyInfo2.split(',');
		console.log(columns);
		return columns;
	}
};
</script>