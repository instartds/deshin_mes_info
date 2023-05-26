<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mms200ukrv_wm">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="Q005"/>	<!-- 검사유형 -->
	<t:ExtComboStore comboType="AU" comboCode="Q022"/>	<!-- 검사담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M414"/>	<!-- 합격여부 -->
	<t:ExtComboStore comboType="AU" comboCode="M001"/>	<!-- 발주유형 -->
	<t:ExtComboStore comboType="AU" comboCode="Q033"/>	<!-- 최종판정 -->
	<t:ExtComboStore comboType="AU" comboCode="Q002"/>	<!-- 최종판정 -->
	<t:ExtComboStore comboType="OU"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="s_mms200ukrv_wmLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="s_mms200ukrv_wmLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="s_mms200ukrv_wmLevel3Store" />
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >
var BsaCodeInfo	= {
	gsAutoInputFlag		: '${gsAutoInputFlag}',		//수입검사후 자동입고여부
	gsLotNoInputMethod	: '${gsLotNoInputMethod}',
	gsLotNoEssential	: '${gsLotNoEssential}',
	gsManageLotNoYN		: '${gsManageLotNoYN}',		//LOT관리기준 설정
	gsInspecPrsn		: '${gsInspecPrsn}'			//로그인사용자에 해당하는 검사자정보 refcode1 사업장, refcode2 부서, refcode3 id, refcode4 명(codeName과 같이 사용)
};


function appMain() {
	var lotNoEssential	= BsaCodeInfo.gsLotNoEssential	== "Y" ? true : false;
	var lotNoInputMethod= BsaCodeInfo.gsLotNoInputMethod== "Y" ? true : false;
	//20201230 추가 - 동적 그리드 구현: 불량코드(수입검사)
	var colData			= Ext.isEmpty(${colData}) ? '' : ${colData};
	var fields			= createModelField(colData);
	var columns			= createGridColumn(colData);
	var gsBadQArray, gsBadQArray2; 

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
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('INSPEC_PRSN', '');
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
			name		: 'INSPEC_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
//					var records = directMasterStore1.data.items;
//					Ext.each(records, function(record,i){
//						record.set('INSPEC_DATE', newValue);
//					});
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.inspeccharge" default="검사담당"/>',
			name		: 'INSPEC_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'Q022',
			allowBlank	: false,		//20210107 추가
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
//					var records = directMasterStore1.data.items;
//					Ext.each(records, function(record,i){
//						record.set('INSPEC_PRSN', newValue);
//					});
				},
				beforequery:function( queryPlan, eOpts ) {
					var store	= queryPlan.combo.store;
					var pRStore	= panelResult.getField('INSPEC_PRSN').store;
					var divChk	= false;
					Ext.each(store.data.items, function(record,i){
						if(!Ext.isEmpty(record.get('refCode1'))){
							divChk = true;
						}
					});
					store.clearFilter();
					pRStore.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE')) && divChk == true ){
						store.filterBy(function(record){
							return record.get('refCode1') == panelResult.getValue('DIV_CODE');
						});
						pRStore.filterBy(function(record){
							return record.get('refCode1') == panelResult.getValue('DIV_CODE');
						});
					}else if(divChk == false){
							return true;
					} else {
						store.filterBy(function(record){
							return false;
						});
						pRStore.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>',
			name		: 'INSPEC_NUM',
			xtype		: 'uniTextfield',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{	//20201230 추가
			fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_PRSN',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{	//20201230 추가
			fieldLabel	: '상태',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '미검사',
				name		: 'rdoSelect',
				inputValue	: 'N',
				width		: 80,
				checked		: true
			},{
				boxLabel	: '검사완료',
				name		: 'rdoSelect',
				inputValue	: 'Y',
				width		: 80
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					UniAppManager.app.onQueryButtonDown(newValue.rdoSelect);
				}
			}
		},{	//20210119 추가 - 조회조건 "품목분류" 추가
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 3 0',
			items	: [{
				fieldLabel	: '<t:message code="system.label.base.itemgroup" default="품목분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_mms200ukrv_wmLevel1Store'),
				child		: 'ITEM_LEVEL2'
			}, {
				fieldLabel	: '',
				name		: 'ITEM_LEVEL2',
				xtype		:'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_mms200ukrv_wmLevel2Store'),
				child		: 'ITEM_LEVEL3'

			 }, {
				fieldLabel	: '',
				name		: 'ITEM_LEVEL3',
				xtype		:'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_mms200ukrv_wmLevel3Store')
			}]
		},{
			fieldLabel	: '<t:message code="system.label.purchase.itemcodevalue" default="아이템코드값"/>',
			name		: 'ITEM_CODE',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: '<t:message code="system.label.purchase.seq" default="순번"/>',
			name		: 'INSPEC_SEQ',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: 'GOOD_WH_CODE',
			name		: 'GOOD_WH_CODE',
			xtype		: 'uniTextfield',
			readOnly	: true,
			hidden		: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: 'BAD_WH_CODE',
			name		: 'BAD_WH_CODE',
			xtype		: 'uniTextfield',
			readOnly	: true,
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
	});



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_mms200ukrv_wmService.selectList1',
			update	: 's_mms200ukrv_wmService.updateDetail',
			create	: 's_mms200ukrv_wmService.insertDetail',
			destroy	: 's_mms200ukrv_wmService.deleteDetail',
			syncAll	: 's_mms200ukrv_wmService.saveAll'
		}
	});

	/** grid1 Model
	 */
	Unilite.defineModel('s_mms200ukrv_wmModel1', {
		//20201230 추가 - 동적 그리드 구현: 불량코드(수입검사)
		fields: fields
/*		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'				, type: 'string'},
			{name: 'CUSTOM_PRSN'		, text: '고객명'	, type: 'string'},
			{name: 'INSPEC_NUM'			, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'				, type: 'string'},
			{name: 'INSPEC_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'int'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'INSPEC_TYPE'		, text: '<t:message code="system.label.purchase.inspectype" default="검사유형"/>'			, type: 'string',comboType: 'AU',comboCode: 'Q005', allowBlank:false},
			{name: 'GOODBAD_TYPE'		, text: '<t:message code="system.label.purchase.passyn" default="합격여부"/>'				, type: 'string',comboType: 'AU',comboCode: 'M414', allowBlank:false},
			{name: 'END_DECISION'		, text: '<t:message code="system.label.purchase.finaldecision" default="최종판정"/>'		, type: 'string',comboType: 'AU',comboCode: 'Q033', allowBlank:false},
			{name: 'RECEIPT_Q'			, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'			, type: 'uniQty'},
			{name: 'ORDER_UNIT'			, text: '단위'	, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'			, type: 'uniQty'},
			{name: 'INSPEC_Q'			, text: '<t:message code="system.label.product.inspecqty2" default="검사량(시료)"/>'			, type: 'uniQty', allowBlank:false},
			{name: 'BAD_INSPEC_Q'		, text: '불량수량'	, type: 'uniQty'},
			{name: 'BAD_INSPEC_PER'		, text: '<t:message code="system.label.product.defectratepercent" default="불량률(%)"/>'	, type: 'uniPercent'},
			{name: 'GOOD_INSPEC_Q'		, text: '양품수량'	, type: 'uniQty'},
			{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'			, type: 'uniQty'},
			{name: 'INSPEC_PRSN'		, text: '<t:message code="system.label.purchase.inspecchargeperson" default="검사담당자"/>'	, type: 'string',comboType: 'AU',comboCode: 'Q022', allowBlank:false},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처'	, type: 'string'},
			{name: 'RECEIPT_NUM'		, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'			, type: 'string'},
			{name: 'RECEIPT_SEQ'		, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'			, type: 'int'},
			{name: 'MAKE_LOT_NO'		, text: '<t:message code="system.label.purchase.customLOT" default="거래처LOT"/>'			, type: 'string'},
			{name: 'MAKE_DATE'			, text: '<t:message code="system.label.purchase.makedate" default="제조일자"/>'				, type: 'uniDate'},
			{name: 'MAKE_EXP_DATE'		, text: '<t:message code="system.label.purchase.expirationdate" default="유통기한"/>'		, type: 'uniDate'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'INSPEC_DATE'		, text: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>'			, type: 'uniDate'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.poclass" default="발주유형"/>'				, type: 'string'},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>'				, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'				, type: 'int'},
			{name: 'SO_NUM'				, text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'					, type: 'string'},
			{name: 'SO_CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.soplace" default="수주처"/>'				, type: 'string'},
			{name: 'SO_ITEM_NAME'		, text: '수주품목명'		, type: 'string'}
		]*/
	});

	/**grid1 store
	 */
	var directMasterStore1 = Unilite.createStore('s_mms200ukrv_wmMasterStore1', {
		model	: 's_mms200ukrv_wmModel1',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부, 20210129 수정
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(newValue){
			var param = panelResult.getValues();
			//20201230 추가
			if(!Ext.isEmpty(newValue)) {
				param.rdoSelect = newValue;
			}
			if(!Ext.isEmpty(gsBadQArray)) {
				param.gsBadQArray = gsBadQArray;
			}
			if(!Ext.isEmpty(gsBadQArray2)) {
				param.gsBadQArray2 = gsBadQArray2;
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			//20201230 추가
			var paramMaster			= panelResult.getValues();	//syncAll 수정
			paramMaster.gsBadQArray	= gsBadQArray;
			paramMaster.gsBadQArray2= gsBadQArray2;

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						var result = batch.operations[0].getResultSet();
//						panelResult.setValue("INSPEC_NUM"	, result["INSPEC_NUM"]);	//20201230 주석
						Ext.getCmp('receiveBadWhCode').setValue('');
						Ext.getCmp('receiveGoodWhCode').setValue('');
						if(directMasterStore1.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						} else {
							UniAppManager.app.onQueryButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				Ext.getCmp('s_mms200ukrv_wmGrid1').uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				UniAppManager.setToolbarButtons(['delete'], false);
				if(directMasterStore1.getCount() == 0){
//					UniAppManager.app.onResetButtonDown();
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		groupField: 'CUSTOM_PRSN'		//20210107 추가
	});

	var masterGrid = Unilite.createGrid('s_mms200ukrv_wmGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			useLiveSearch		: true,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		//20201230 추가
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
					var checkFlag = false;
					var queryFlag = panelResult.getValues().rdoSelect;
					if(queryFlag == 'Y') {
						var records = masterGrid.getStore().data.items;
						Ext.each(records, function(record, idx) {
							if(record.get('OPR_FLAG') == 'U') {
								checkFlag = true;
								return false;
							}
						});
						if(checkFlag) {
							Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
							return false;
						}
					}
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ) {
					if(panelResult.getValues().rdoSelect == 'Y') {
						UniAppManager.setToolbarButtons(['print'], true);
						UniAppManager.setToolbarButtons(['delete'], true);
//						selectRecord.set('OPR_FLAG', 'D');
					} else {
						var seq = directMasterStore1.max('INSPEC_SEQ');
						if(!seq) seq = 1;
						else seq += 1;
						selectRecord.set('INSPEC_SEQ'	, seq);
						selectRecord.set('OPR_FLAG'		, 'N');
						UniAppManager.setToolbarButtons(['delete'], false);
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ) {
					if (this.selected.getCount() == 0) {
						UniAppManager.setToolbarButtons(['print'], false);
					}
					if(panelResult.getValues().rdoSelect == 'N') {
						selectRecord.set('INSPEC_SEQ', 0);
					}
					selectRecord.set('OPR_FLAG', '');
				}
			}
		}),
		tbar: [{
			fieldLabel	: '<t:message code="system.label.product.receiptwarehouse" default="입고창고"/>',
			name		: 'GOOD_WH_CODE',
			id			: 'receiveGoodWhCode',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			labelWidth	: 70,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						})
					} else {
						store.filterBy(function(record){
							return false;
						})
					}
				}
			}
		},{
			xtype	: 'component',
			tdAttrs	: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' },
			width	: 20
		},{
			fieldLabel	: '<t:message code="system.label.product.badwarehouse" default="불량창고"/>',
			name		: 'BAD_WH_CODE',
			id			: 'receiveBadWhCode',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			labelWidth	: 70,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
						store.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
						return record.get('option') == panelResult.getValue('DIV_CODE');
						})
					} else {
						store.filterBy(function(record){
						return false;
						})
					}
				}
			}
		},{
			xtype	: 'component',
			tdAttrs	: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' },
			width	: 30
		}],
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		//20201230 추가 - 동적 그리드 구현: 불량코드(수입검사)
		columns	: columns,
/*		columns: [
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'INSPEC_NUM'		, width: 120, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 120},
			{dataIndex: 'CUSTOM_PRSN'		, width: 120},
//			{dataIndex: 'INSPEC_SEQ'		, width: 60	, align:'center'},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 150},
//			{dataIndex: 'LOT_NO'			, width: 120,
//				getEditor: function(record) {
//				}
//			},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'ORDER_UNIT'		, width: 80	,align:'center'},
//			{dataIndex: 'INSPEC_TYPE'		, width: 90},
//			{dataIndex: 'GOODBAD_TYPE'		, width: 90},
//			{dataIndex: 'END_DECISION'		, width: 90},
			{dataIndex: 'RECEIPT_Q'			, width: 120},
//			{dataIndex: 'TRNS_RATE'			, width: 100},
//			{dataIndex: 'INSPEC_Q'			, width: 120},
			{dataIndex: 'GOOD_INSPEC_Q'		, width: 120},
			{dataIndex: 'BAD_INSPEC_Q'		, width: 120},
			{dataIndex: 'BAD_INSPEC_PER'	, width: 120, hidden: true},
//			{dataIndex: 'INSTOCK_Q'			, width: 100},
//			{dataIndex: 'INSPEC_PRSN'		, width: 100},
			{dataIndex: 'CUSTOM_CODE'		, width: 120, hidden: true},
//			{dataIndex: 'RECEIPT_NUM'		, width: 120},
//			{dataIndex: 'RECEIPT_SEQ'		, width: 80, align:'center'},
//			{dataIndex: 'MAKE_LOT_NO'		, width: 100},
//			{dataIndex: 'MAKE_DATE'			, width: 100},
//			{dataIndex: 'MAKE_EXP_DATE'		, width: 100},
			{dataIndex: 'REMARK'			, width: 250}
//			{dataIndex: 'PROJECT_NO'		, width: 120,
//				getEditor : function(record){
//					return getPjtNoPopupEditor();
//				}
//			},
//			{dataIndex: 'INSPEC_DATE'		, width: 80, hidden: false},
//			{dataIndex: 'ORDER_TYPE'		, width: 80, hidden: true},
//			{dataIndex: 'ORDER_NUM'			, width: 80, hidden: true},
//			{dataIndex: 'ORDER_SEQ'			, width: 80, hidden: true, align:'center'},
//			{dataIndex: 'SO_NUM'			, width:100 ,hidden: false},
//			{dataIndex: 'SO_CUSTOM_NAME'	, width:150 ,hidden: false},
//			{dataIndex: 'SO_ITEM_NAME'		, width:200 ,hidden: false}
		],*/
		listeners: {
			//20200105 추가: 그리드 클릭 시, 동일한 접수번호/순번 전체 선택/해제, 체크박스는 개별로 동작하도록 구성
			cellclick: function( view, td, cellIndex, selRecord, tr, rowIndex, e, eOpts ) {
				//20210107 수정: edit되는 컬럼 클릭 시 체크되지 않도록 하기 위해서 수정
				if(cellIndex == masterGrid.getColumnIndex('CUSTOM_NAME')	|| cellIndex == masterGrid.getColumnIndex('CUSTOM_PRSN')
				|| cellIndex == masterGrid.getColumnIndex('ITEM_CODE')		|| cellIndex == masterGrid.getColumnIndex('ITEM_NAME')	|| cellIndex == masterGrid.getColumnIndex('SPEC')) {
					var sm		= masterGrid.getSelectionModel();
					var records	= directMasterStore1.data.items;
					var data	= masterGrid.getSelectionModel().getSelection();
					var data2	= new Array;
					Ext.each(records, function(record, idx) {
						if(selRecord.get('BASIS_NUM') == record.get('BASIS_NUM') && selRecord.get('BASIS_SEQ') == record.get('BASIS_SEQ')){
							data.push(record);
							data2.push(record);
						}
					});
					if(masterGrid.getSelectionModel().isSelected(selRecord)) {
						sm.deselect(data2);
					} else {
						sm.select(data);
					}
				}
			},
			selectionchange: function( grid, selected, eOpts ){
				if(selected && selected[0]){
				}
			},
			beforeedit: function( editor, e, eOpts ) {
				//20201230 일괄 수정
				if (UniUtils.indexOf(e.field,['DIV_CODE', 'INSPEC_NUM', 'INSPEC_SEQ', 'INSPEC_TYPE', 'CUSTOM_PRSN', 'CUSTOM_NAME', 'ITEM_CODE', 'ITEM_NAME', 'SPEC', 'ORDER_UNIT', 'INSTOCK_Q', 'RECEIPT_Q'])){
					return false;
				}
				if(UniUtils.indexOf(e.field,['LOT_NO'])){
					if(e.record.get("ITEM_CODE") == ''){
						alert('<t:message code="system.message.purchase.message028" default="품목코드를 입력 하십시오."/>');
						return false;
					}
					return true;
				}
				if(e.record.data.INSTOCK_Q == e.record.data.INSPEC_Q){
					return false;
				} else {
					return true;
				}
				return true;
			}
		}
	});





	Unilite.Main({
		id			: 's_mms200ukrv_wmApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		}],
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('INSPEC_DATE'	, UniDate.get("today"));
			panelResult.setValue('INSPEC_PRSN'	, BsaCodeInfo.gsInspecPrsn);
			panelResult.getField('rdoSelect').setValue('N');

			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['deleteAll', 'save'], false);
			if(BsaCodeInfo.gsAutoInputFlag == 'Y') {
				Ext.getCmp('receiveBadWhCode').setHidden(false);
				Ext.getCmp('receiveGoodWhCode').setHidden(false);
			} else {
				Ext.getCmp('receiveBadWhCode').setHidden(true);
				Ext.getCmp('receiveGoodWhCode').setHidden(true);
			}
			UniAppManager.setToolbarButtons(['print'], false);	//20201021 추가: 출력기능 추가
		},
		onQueryButtonDown: function(newValue) {
			//2020130 추가
			if(!Ext.isEmpty(newValue)) {
				if(newValue == 'N') {
					if(Ext.isEmpty(panelResult.getValue('INSPEC_DATE'))) {
						Unilite.messageBox('검사일: 필수입력 항목입니다.');
						panelResult.getField('INSPEC_DATE').focus();
						return false;
					}
					if(Ext.isEmpty(panelResult.getValue('INSPEC_PRSN'))) {
						Unilite.messageBox('검사담당: 필수입력 항목입니다.');
						panelResult.getField('INSPEC_PRSN').focus();
						return false;
					}
				}
			} else {
				if(panelResult.getValues().rdoSelect == 'N') {
					if(Ext.isEmpty(panelResult.getValue('INSPEC_DATE'))) {
						Unilite.messageBox('검사일: 필수입력 항목입니다.');
						panelResult.getField('INSPEC_DATE').focus();
						return false;
					}
					if(Ext.isEmpty(panelResult.getValue('INSPEC_PRSN'))) {
						Unilite.messageBox('검사담당: 필수입력 항목입니다.');
						panelResult.getField('INSPEC_PRSN').focus();
						return false;
					}
				}
			}
			if(!panelResult.setAllFieldsReadOnly(true)) return false;
			directMasterStore1.loadStoreRecords(newValue);
			UniAppManager.setToolbarButtons(['print'], false);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.getStore().loadData({});
			Ext.getCmp('receiveBadWhCode').setValue('');
			Ext.getCmp('receiveGoodWhCode').setValue('');
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
		},
		onDeleteDataButtonDown: function() {
			if(panelResult.getValues().rdoSelect != 'Y') {
				Unilite.messageBox('미등록 된 데이터는 삭제할 수 없습니다.');
				return false;
			}
			var selRow = masterGrid.getSelectedRecord();
			//2020130 추가
			if(!selRow) {
				Unilite.messageBox('삭제할 데이터가 없습니다.');
				return false;
			}
			//2020130 추가
			if(panelResult.getValues().rdoSelect == 'N') {
				Unilite.messageBox('미검사된 데이터는 삭제할 수 없습니다.');
				return false;
			}
			if(selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
				return;
			}
			Ext.Msg.confirm('<t:message code="system.label.purchase.delete" default="삭제"/>', '<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>', function(btn){
				if (btn == 'yes') {
					var divCode		= panelResult.getValue('DIV_CODE');
					var inspecNum	= selRow.get('INSPEC_NUM');
					var inspecSeq	= selRow.get('INSPEC_SEQ');
					UniAppManager.app.fnInspecQtyCheck2(selRow, divCode, inspecNum, inspecSeq )
				}
			})
		},
		fnInspecQtyCheck: function(rtnRecord, fieldName, oldValue, divCode, inspecNum, inspecSeq, msgFlag) {
			//20210304 추가
			var queryFlag = panelResult.getValues().rdoSelect;
			if(queryFlag == 'Y') {
				var param = {
					'DIV_CODE'	: divCode,
					'INSPEC_NUM': inspecNum,
					'INSPEC_SEQ': inspecSeq
				}
				s_mms200ukrv_wmService.inspecQtyCheck(param, function(provider, response){
					if(!Ext.isEmpty(provider) && provider.length > 0 ) {
						if(msgFlag == 'inspectList'){
							Unilite.messageBox('입고된 수량이 존재합니다. 검사수량을 변경할 수 없습니다.');
							rtnRecord.set(fieldName, oldValue);
						} else {
							alert('<t:message code="system.message.purchase.message065" default="입고된 수량이 존재합니다. 삭제 할 수 없습니다."/>');
							rtnRecord.set(fieldName, oldValue);
						}
					} else {
						UniAppManager.app.fnCheckIsModify();
					}
				})
			}
		},
		fnInspecQtyCheck2: function(rtnRecord, divCode, inspecNum, inspecSeq) {
			//20210304 추가
			var queryFlag = panelResult.getValues().rdoSelect;
			if(queryFlag == 'Y') {
				var isErr = true;
				var param = {
					'DIV_CODE'	: divCode,
					'INSPEC_NUM': inspecNum,
					'INSPEC_SEQ': inspecSeq
				}
				s_mms200ukrv_wmService.inspecQtyCheck(param, function(provider, response){
					if(!Ext.isEmpty(provider) && provider.length > 0 ) {
						Unilite.messageBox('<t:message code="system.message.purchase.message065" default="입고된 수량이 존재합니다. 삭제 할 수 없습니다."/>');
						isErr = false;
					} else {
						masterGrid.deleteSelectedRow();
					}
				})
				return isErr;
			}
		},
		fnCheckIsModify:function(){
			var store1 = Ext.getCmp("s_mms200ukrv_wmGrid1").getStore();
			if(store1.isDirty()){
				UniAppManager.setToolbarButtons(['save'], true);
			} else {
				UniAppManager.setToolbarButtons(['save'], false);
			}
		},
		//20201021 추가: 출력기능 추가
		onPrintButtonDown: function() {
			//20210104 추가: 화면단 전체 수정으로 출력로직 수정 
			var selectedMasters	= masterGrid.getSelectedRecords();
			if(Ext.isEmpty(selectedMasters)) {
				Unilite.messageBox('출력할 데이터가 없습니다.');
				return false;
			}
			var workOrderInfo;
			Ext.each(selectedMasters, function(record, idx) {
				if(idx ==0) {
					workOrderInfo = record.get('INSPEC_NUM') + '/' + record.get('INSPEC_SEQ');
				} else {
					workOrderInfo = workOrderInfo + ',' + record.get('INSPEC_NUM') + '/' + record.get('INSPEC_SEQ');
				}
			});
			var param			= panelResult.getValues();
			param.PGM_ID		= 's_mms200ukrv_wm';
			param.MAIN_CODE		= 'Z012';
			param.dataCount		= selectedMasters.length;
			param.workOrderInfo	= workOrderInfo;

			var win = Ext.create('widget.ClipReport', {
				url			: CPATH+'/z_wm/s_mms200clukrv_wm.do',
				prgID		: 's_mms200ukrv_wm',
				extParam	: param,
				submitType	: 'POST'
			});
			win.center();
			win.show();
		}
	});



	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "GOOD_INSPEC_Q":
					if(newValue == '' || newValue < '1'){
						rv ='합격수량이 1보다 작거나 데이터가 없습니다.';
						break;
					}
					if(record.get('RECEIPT_Q') * record.get('TRNS_RATE') < newValue){
						rv ='합격수량은 잔량보다 적어야 합니다';
						break;
					}

					//2020130 추가
					var checkFlag = false;
					var queryFlag = panelResult.getValues().rdoSelect;
					if(queryFlag == 'Y') {
						var records = masterGrid.getStore().data.items;
						Ext.each(records, function(record, idx) {
							if(record.get('OPR_FLAG') == 'D') {
								checkFlag = true;
								return false;
							}
						});
						if(checkFlag) {
							rv = '<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>';
							break;
						}
						record.set('OPR_FLAG', 'U');
					}
				break;

				case "BAD_INSPEC_Q":
					if(record.get('RECEIPT_Q') * record.get('TRNS_RATE') < newValue){
						rv ='불량수량은 잔량보다 작아야합니다.';
						break;
					}

					//2020130 추가
					var checkFlag = false;
					var queryFlag = panelResult.getValues().rdoSelect;
					if(queryFlag == 'Y') {
						var records = masterGrid.getStore().data.items;
						Ext.each(records, function(record, idx) {
							if(record.get('OPR_FLAG') == 'D') {
								checkFlag = true;
								return false;
							}
						});
						if(checkFlag) {
							rv = '<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>';
							break;
						}
						record.set('OPR_FLAG', 'U');
					}
					record.set('GOOD_INSPEC_Q', record.get('RECEIPT_Q') * record.get('TRNS_RATE') - newValue);
					break;

				case "REMARK":
					if(record.obj.phantom == false){
						var divCode = panelResult.getValue('DIV_CODE');
						var inspecNum = record.get('INSPEC_NUM');
						var inspecSeq = record.get('INSPEC_SEQ');
						UniAppManager.app.fnInspecQtyCheck(record, fieldName, oldValue, divCode, inspecNum, inspecSeq );

						//2020130 추가
						var checkFlag = false;
						var queryFlag = panelResult.getValues().rdoSelect;
						if(queryFlag == 'Y') {
							var records = masterGrid.getStore().data.items;
							Ext.each(records, function(record, idx) {
								if(record.get('OPR_FLAG') == 'D') {
									checkFlag = true;
									return false;
								}
							});
							if(checkFlag) {
								rv = '<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>';
								break;
							}
							record.set('OPR_FLAG', 'U');
						}
						break;
					}

					//2020130 추가
					var checkFlag = false;
					var queryFlag = panelResult.getValues().rdoSelect;
					if(queryFlag == 'Y') {
						var records = masterGrid.getStore().data.items;
						Ext.each(records, function(record, idx) {
							if(record.get('OPR_FLAG') == 'D') {
								checkFlag = true;
								return false;
							}
						});
						if(checkFlag) {
							rv = '<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>';
							break;
						}
						record.set('OPR_FLAG', 'U');
					}
					break;
			}
			return rv;
		}
	});



	function qtyUpdateByType(record){
		if(record.get('INSPEC_TYPE') == '01' || record.get('INSPEC_TYPE') == ''){
			record.set('GOOD_INSPEC_Q', record.get('RECEIPT_Q') * record.get('TRNS_RATE') - record.get('BAD_INSPEC_Q'));
		}else if(record.get('INSPEC_TYPE') == '02'){
			if(record.get('GOODBAD_TYPE') == '01'){
				if(record.obj.phantom){
					record.set('GOOD_INSPEC_Q'	, record.get('RECEIPT_Q') * record.get('TRNS_RATE'));
					record.set('BAD_INSPEC_Q'	,'0');
				} else {
					record.set('GOOD_INSPEC_Q'	, record.get('RECEIPT_Q') * record.get('TRNS_RATE'));
					record.set('BAD_INSPEC_Q'	,'0');
				}
			}else if(record.get('GOODBAD_TYPE') == '02'){
				record.set('GOOD_INSPEC_Q'	,'0');
				record.set('BAD_INSPEC_Q'	,record.get('RECEIPT_Q') * record.get('TRNS_RATE') );
			}else if(record.get('GOODBAD_TYPE') == '03'){
//				record.set('GOOD_INSPEC_Q'	,'0');
//				record.set('BAD_INSPEC_Q'	,'0');
			}
		}
		UniAppManager.app.fnCheckIsModify();
	}

	function setAllFieldsReadOnly(b){
		var r= true
		if(b) {
			var invalid = this.getForm().getFields().filterBy(function(field) {
				return !field.validate();
			});
			if(invalid.length > 0) {
				r=false;
				var labelText = ''
				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+':';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold') {
							popupFC.setReadOnly(true);
						}
					}
				});
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
					var popupFC = item.up('uniPopupField');
					if(popupFC.holdable == 'hold') {
						popupFC.setReadOnly(false);
					}
				}
			});
			this.unmask();
		}
		return r;
	}



	//20201230 추가 - 동적 그리드 구현: 불량코드(수입검사)
	function createModelField(colData) {
		var fields = [
			{name: 'OPR_FLAG'			, text: 'OPR_FLAG'	, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'				, type: 'string'},
			{name: 'INSPEC_NUM'			, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'				, type: 'string'},
			{name: 'INSPEC_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'int'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처'		, type: 'string'},
			{name: 'CUSTOM_PRSN'		, text: '고객명'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'INSPEC_TYPE'		, text: '<t:message code="system.label.purchase.inspectype" default="검사유형"/>'			, type: 'string',comboType: 'AU',comboCode: 'Q005', allowBlank:false},
			{name: 'GOODBAD_TYPE'		, text: '<t:message code="system.label.purchase.passyn" default="합격여부"/>'				, type: 'string',comboType: 'AU',comboCode: 'M414', allowBlank:false},
			{name: 'END_DECISION'		, text: '<t:message code="system.label.purchase.finaldecision" default="최종판정"/>'		, type: 'string',comboType: 'AU',comboCode: 'Q033', allowBlank:false},
			{name: 'RECEIPT_Q'			, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'			, type: 'uniQty'},
			{name: 'ORDER_UNIT'			, text: '단위'		, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'			, type: 'uniQty'},
			{name: 'INSPEC_Q'			, text: '<t:message code="system.label.product.inspecqty2" default="검사량(시료)"/>'			, type: 'uniQty', allowBlank:false},
			{name: 'BAD_INSPEC_Q'		, text: '불량수량'		, type: 'uniQty'},
			{name: 'BAD_INSPEC_PER'		, text: '<t:message code="system.label.product.defectratepercent" default="불량률(%)"/>'	, type: 'uniPercent'},
			{name: 'GOOD_INSPEC_Q'		, text: '양품수량'		, type: 'uniQty'},
			{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'			, type: 'uniQty'},
			{name: 'INSPEC_PRSN'		, text: '<t:message code="system.label.purchase.inspecchargeperson" default="검사담당자"/>'	, type: 'string',comboType: 'AU',comboCode: 'Q022', allowBlank:false},
			{name: 'RECEIPT_NUM'		, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'			, type: 'string'},
			{name: 'RECEIPT_SEQ'		, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'			, type: 'int'},
			{name: 'MAKE_LOT_NO'		, text: '<t:message code="system.label.purchase.customLOT" default="거래처LOT"/>'			, type: 'string'},
			{name: 'MAKE_DATE'			, text: '<t:message code="system.label.purchase.makedate" default="제조일자"/>'				, type: 'uniDate'},
			{name: 'MAKE_EXP_DATE'		, text: '<t:message code="system.label.purchase.expirationdate" default="유통기한"/>'		, type: 'uniDate'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'INSPEC_DATE'		, text: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>'			, type: 'uniDate'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.poclass" default="발주유형"/>'				, type: 'string'},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>'				, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'					, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'				, type: 'int'},
			{name: 'SO_NUM'				, text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'					, type: 'string'},
			{name: 'SO_CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.soplace" default="수주처"/>'				, type: 'string'},
			{name: 'SO_ITEM_NAME'		, text: '수주품목명'		, type: 'string'},
			//20200105 추가: 그리드 클릭 시, 동일한 접수번호/순번 전체 선택/해제, 체크박스는 개별로 동작하도록 구성
			{name: 'BASIS_NUM'			, text: '접수번호'		, type: 'string', editable: false},
			{name: 'BASIS_SEQ'			, text: '접수순번'		, type: 'int'	, editable: false}
		];
		//동적 컬럼 모델 push
		Ext.each(colData, function(item, index){
			fields.push({name: 'BAD_' + item.SUB_CODE, type: 'uniQty' });
		});
		return fields;
	}

	//20201230 추가 - 동적 그리드 구현: 불량코드(수입검사)
	function createGridColumn(colData) {
		var array1	= new Array();
		var columns	= [
			{dataIndex: 'OPR_FLAG'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'INSPEC_NUM'		, width: 120, hidden: true},
			{dataIndex: 'INSPEC_SEQ'		, width: 80	, hidden: true, align: 'center'},
			{dataIndex: 'CUSTOM_CODE'		, width: 120, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 120},
			{dataIndex: 'CUSTOM_PRSN'		, width: 120},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'ORDER_UNIT'		, width: 80	,align:'center'},
			{dataIndex: 'RECEIPT_Q'			, width: 120},
			{dataIndex: 'GOOD_INSPEC_Q'		, width: 120},
			{dataIndex: 'BAD_INSPEC_Q'		, width: 120},
			{dataIndex: 'BAD_INSPEC_PER'	, width: 120, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 120, hidden: true},
			{dataIndex: 'REMARK'			, width: 250},
			//20200105 추가: 그리드 클릭 시, 동일한 접수번호/순번 전체 선택/해제, 체크박스는 개별로 동작하도록 구성
			{dataIndex: 'BASIS_NUM'			, width: 120, hidden: true},
			{dataIndex: 'BASIS_SEQ'			, width: 120, hidden: true}
		];
		//불량컬럼 추가
		Ext.each(colData, function(item, index){
			if(index == 0){
				gsBadQArrayInfo	= 'BAD_' + item.SUB_CODE;
				gsBadQArrayInfo2= item.SUB_CODE;
			} else {
				gsBadQArrayInfo	+= ',' + 'BAD_' + item.SUB_CODE;
				gsBadQArrayInfo2+= ',' + item.SUB_CODE;
			}
			columns.push(Ext.applyIf({dataIndex: 'BAD_' + item.SUB_CODE	, text: item.CODE_NAME	, width:110	, style: {textAlign: 'center'}},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum' }));
		});
		gsBadQArray	= gsBadQArrayInfo.split(',');
		gsBadQArray2= gsBadQArrayInfo2.split(',');
		return columns;
	}
};
</script>