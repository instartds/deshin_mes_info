<%--
'	프로그램명 : 주문등록
'	작   성   자 : 시너지 시스템즈 개발팀
'	작   성   일 :
'	최종수정자 :
'	최종수정일 :
'	버	 전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof190ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sof190ukrv" />	<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B013"  />		<!-- 상태   -->
	<t:ExtComboStore comboType="AU" comboCode="B004"  />		<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B039"  />		<!-- 출고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="S002"  />		<!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"  />		<!-- 영업담당 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-change-blue {
		background-color: #A7EEFF;
	}
</style>
<script type="text/javascript" >


var BsaCodeInfo = {
	gsAgentType	: '${gsAgentType}',
	gsMoneyUnit	: '${gsMoneyUnit}',
	gsVatRate	: '${gsVatRate}'
}
var beforeRowIndex;		//마스터그리드 같은row중복 클릭시 다시 load되지 않게

var gschkgridCnt;		//mastergrid2 변경cnt

function appMain() {
	var statusStore = Unilite.createStore('statusComboStore', {  
		fields	: ['text', 'value'],
		data	: [
			{'text':'대기'	, 'value':'1'},
			{'text':'주문확정'	, 'value':'2'},
			{'text':'수주확정'	, 'value':'9'},
			{'text':'취소'	, 'value':'8'}
		]
	});


	/** Proxy 정의 
	 *  @type 
	 */
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sof190ukrvService.selectList1',
//			create	: 'sof190ukrvService.insertDetail',
			update	: 'sof190ukrvService.updateDetail',
//			destroy	: 'sof190ukrvService.deleteDetail',
			syncAll	: 'sof190ukrvService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sof190ukrvService.selectList2',
//			create	: 'sof190ukrvService.insertDetail2',
			update	: 'sof190ukrvService.updateDetail2',
//			destroy	: 'sof190ukrvService.deleteDetail2',
			syncAll	: 'sof190ukrvService.saveAll2'
		}
	});



	/** Model 정의
	 *  @type 
	 */
	Unilite.defineModel('sof190ukrvModel1', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'	,type:'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string'},
			{name: 'SO_NUM'			, text: '<t:message code="system.label.sales.orderno" default="주문번호"/>'			, type: 'string'},
			{name: 'SO_SEQ'			, text: '<t:message code="system.label.sales.orderseq" default="주문순번"/>'		, type: 'int'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.sales.customcode" default="거래처코드"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'SO_DATE'		, text: '<t:message code="system.label.sales.orderdate" default="주문일"/>'		, type: 'uniDate'},
			{name: 'ORDER_O'		, text: '<t:message code="system.label.sales.amount" default="금액"/>'			, type: 'uniPrice'},
			{name: 'ORDER_TAX_O'	, text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'		, type: 'uniPrice'},
			{name: 'ORDER_Q'		, text: '<t:message code="system.label.sales.orderqty" default="주문수량"/>'		, type: 'uniQty'},
			{name: 'STATUS_FLAG'	, text: '<t:message code="system.label.sales.status" default="상태"/>'			, type: 'string'	, xtype: 'uniCombobox'	, store: statusStore},
			{name: 'ORDER_NUM'		, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'			, type: 'string'},
			{name: 'SAVE_FLAG'		, text: 'SAVE_FLAG'	, type: 'string'},
			//SOF100T INSERT위해 추가
			{name: 'ORDER_TYPE'		, text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'		, type: 'string'	, allowBlank: false	, comboType: 'AU'	, comboCode: 'S002'},
			//20190716 영업담당자 추가(bcm100t.busi_prsn, bsa100t.s010.ref_code5 = 로그인 사용자 id)
			{name: 'ORDER_PRSN'		, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'		, type: 'string'	, allowBlank: false	, comboType: 'AU'	, comboCode: 'S010'},
			{name: 'MONEY_UNIT'		, text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'	, type: 'string'	, allowBlank: false	, comboType: 'AU'	, comboCode: 'B004'	, displayField: 'value'},
			{name: 'EXCHG_RATE_O'	, text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'		, type: 'uniER'		, allowBlank: false},
			{name: 'ITEM_LIST'		, text: '품목리스트'	, type: 'string'}
		]
	});

	Unilite.defineModel('sof190ukrvModel2', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'	,type:'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string'},
			{name: 'SO_NUM'			, text: '<t:message code="system.label.sales.orderno" default="주문번호"/>'			, type: 'string'},
			{name: 'SO_SEQ'			, text: '<t:message code="system.label.sales.orderseq" default="주문순번"/>'		, type: 'int'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.sales.customcode" default="거래처코드"/>'		, type: 'string'},
			{name: 'SO_DATE'		, text: '<t:message code="system.label.sales.orderdate" default="주문일"/>'		, type: 'uniDate'},
			{name: 'STATUS_FLAG'	, text: '<t:message code="system.label.sales.status" default="상태"/>'			, type: 'string'	, xtype: 'uniCombobox'	, store: statusStore},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname2" default="품명"/>'			, type: 'string'},
			{name: 'ORDER_Q'		, text: '<t:message code="system.label.sales.orderqty" default="주문수량"/>'		, type: 'uniQty'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'		, type: 'string', comboType:'AU',comboCode:'B013', displayField: 'value'},
			{name: 'TRNS_RATE'		, text: '<t:message code="system.label.sales.containedqty" default="입수"/>'		, type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'ORDER_P'		, text: '<t:message code="system.label.sales.price" default="단가"/>'				, type: 'uniUnitPrice'},
			{name: 'ORDER_O'		, text: '<t:message code="system.label.sales.amount" default="금액"/>'			, type: 'uniPrice'},
			{name: 'ORDER_TAX_O'	, text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'		, type: 'uniPrice'},
			{name: 'ORDER_TOT_O'	, text: '<t:message code="system.label.sales.totalamount2" default="총액"/>'		, type: 'uniPrice'},
			{name: 'REMARK'			, text: '사용자 비고'	, type: 'string'},
			{name: 'ORDER_NUM'		, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'			, type: 'string'},
			{name: 'SER_NO'			, text: '<t:message code="system.label.sales.seq" default="순번"/>'				, type: 'int'},
			{name: 'STATUS_REMARK'	, text: '사유'		, type: 'string'},
			{name: 'DVRY_DATE'		, text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'		, type: 'uniDate'},
			{name: 'SO_ITEM_SEQ'	, text: '<t:message code="system.label.sales.itemseq" default="품목순번"/>'			, type: 'int'},
			{name: 'SAVE_FLAG'		, text: 'SAVE_FLAG'	, type: 'string'},
			//20190711 납기가능일, 내부비고 추가
			{name: 'POSS_DVRY_DATE'	, text: '<t:message code="system.label.sales.deliverydate3" default="납기가능일"/>'	, type: 'uniDate'},
			//20190716 수주비고 추가
			{name: 'SO_REMARK'		, text: '수주비고'		, type: 'string'},
			{name: 'SO_REMARK_INTER', text: '수주내부비고'	, type: 'string'},
			//20210319 추가
			{name: 'DELIV_METHOD'	, text: '배송방법'		, type: 'string', comboType: 'AU', comboCode: 'ZM11'},
			{name: 'RECEIVER_NAME'	, text: '수령자명'		, type: 'string'},
			{name: 'TELEPHONE_NUM1'	, text: '수령자 연락처'	, type: 'string'},
			{name: 'ZIP_NUM'		, text: '우편번호'		, type: 'string'},
			{name: 'ADDRESS1'		, text: '주소'		, type: 'string'},
			{name: 'ADDRESS'		, text: '주소'		, type: 'string'}
		]
	});



	/** Store 정의(Service 정의)
	 *  @type 
	 */
	var directMasterStore1 = Unilite.createStore('sof190ukrvMasterStore1',{
		proxy	: directProxy1,
		model	: 'sof190ukrvModel1',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function(STATUS_FLAG) {
			var param= panelResult.getValues();
			if(!Ext.isEmpty(STATUS_FLAG)) {
				param.STATUS_FLAG = STATUS_FLAG;
			}
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);
			console.log("list:", list);

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	// syncAll 수정

			//2. detail data 저장로직에 추가
			var detailArray = [];
			directMasterStore2.clearFilter();
			var detailToUpdate = directMasterStore2.getUpdatedRecords();
//			var detailToDelete = directMasterStore2.getRemovedRecords();
			var detailList = [].concat(detailToUpdate/*, detailToDelete*/);
			if(detailList != null && detailList.length > 0){
				for(var i = 0; i < detailList.length; i++){
					var dataObj = detailList[i].data;
						dataObj.DVRY_DATE		= UniDate.getDateStr(dataObj.DVRY_DATE)
						dataObj.POSS_DVRY_DATE	= UniDate.getDateStr(dataObj.POSS_DVRY_DATE)
						detailArray.push(dataObj);
				}
			}
//			detailArray = [].concat(detailToUpdate, detailToDelete);
			paramMaster.detailArray = detailArray;

			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();

						//20190716 저장 후 해당상태 유지위해 재조회하지 않음
//						UniAppManager.app.onQueryButtonDown();

						//20210323 추가: 재조회 대신, 상태값 변경 / save_flag 초기화
						var panelStatus	= panelResult.getValues().STATUS_FLAG;
						var records1	= masterGrid1.getSelectedRecords();
						var records2	= masterGrid2.getSelectedRecords();
						masterGrid1.getSelectionModel().deselectAll();
						masterGrid2.getSelectionModel().deselectAll();
						Ext.each(records1, function(record1, index) {
							record1.set('SAVE_FLAG', '');
							if(panelStatus == '2') {
								record1.set('STATUS_FLAG', '9');
							} else {
								record1.set('STATUS_FLAG', '2');
							}
						});
						Ext.each(records2, function(record2, index) {
							record2.set('SAVE_FLAG', '');
							if(panelStatus == '2') {
								record2.set('STATUS_FLAG', '9');
							} else {
								record2.set('STATUS_FLAG', '2');
							}
						});
						masterGrid1.getStore().commitChanges();
						masterGrid2.getStore().commitChanges();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('sof190ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
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

	var directMasterStore2 = Unilite.createStore('sof190ukrvMasterStore2',{
		proxy	: directProxy2,
		model	: 'sof190ukrvModel2',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function(STATUS_FLAG) {
			var param= panelResult.getValues();
			if(!Ext.isEmpty(STATUS_FLAG)) {
				param.STATUS_FLAG = STATUS_FLAG;
			}
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);
			console.log("list:", list);

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	// syncAll 수정

			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();

//						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('sof190ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				// 20210216 알림메세지에서 로드된 경우
				if(!Ext.isEmpty(panelResult.getValue("SO_NUM"))){
					masterGrid2.getStore().clearFilter(); // filter 초기화

					// 주문번호, 주문순번 빈값 세팅
					panelResult.setValue("SO_NUM", '');
					panelResult.setValue("SO_SEQ", '');
					// 주문일 default 값으로 세팅
					panelResult.setValue('SO_DATE_FR'	, UniDate.get('startOfMonth'));
					panelResult.setValue('SO_DATE_TO'	, UniDate.get('today'));
					
				} else {
					this.filterBy (function(record){
						var masterRecord = masterGrid1.getStore().getAt(beforeRowIndex)
						if(!Ext.isEmpty(masterRecord)) {
							var masterSoNum		= masterRecord.get('SO_NUM');
							var masterOrderNum	= masterRecord.get('ORDER_NUM');
							fnSetDetailData(masterSoNum, masterOrderNum);
						} else {
							return false;
						}
					});
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



	/** Master Grid1 정의(Grid Panel)
	 *  @type 
	 */
	var masterGrid1 = Unilite.createGrid('sof190ukrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		flex	: 0.4,
		uniOpt	: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ 
			{id: 'masterGridSubTotal1'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
			{id: 'masterGridTotal1'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick: false,
			listeners: {
				//20210323 추가
				beforeselect: function(rowSelection, record, index, eOpts) {
					var panelStatus	= panelResult.getValues().STATUS_FLAG;
					if(record.get('STATUS_FLAG') != panelStatus) {
						return false;
					}
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var masterSoNum		= selectRecord.get('SO_NUM');
					var masterOrderNum	= selectRecord.get('ORDER_NUM');
					masterGrid2.getStore().clearFilter();
					
					var detailItemList = '';
					var detailRecords = directMasterStore2.data.items;
					chkdata = new Object();
					chkdata.records = [];
					Ext.each(detailRecords, function(detailRecord, index) {
						if(masterSoNum == detailRecord.get('SO_NUM') || masterGrid2.getSelectionModel().isSelected(detailRecord) == true) {
							if(masterSoNum == detailRecord.get('SO_NUM') && masterOrderNum == detailRecord.get('ORDER_NUM')){
								detailItemList = detailItemList + detailRecord.get('ITEM_CODE') + ',';	
							}
							chkdata.records.push(detailRecord);
						}
					});
					masterGrid2.getSelectionModel().select(chkdata.records);
					selectRecord.set('ITEM_LIST', detailItemList);
					fnSetDetailData(masterSoNum, masterOrderNum);
					gschkgridCnt = 0;
					UniAppManager.setToolbarButtons('save', false);
				},
				deselect: function(grid, selectRecord, index, eOpts ){
					selectRecord.set('SAVE_FLAG', '');
					var masterSoNum		= selectRecord.get('SO_NUM');
					var masterOrderNum	= selectRecord.get('ORDER_NUM');
					masterGrid2.getStore().clearFilter();
					
					var detailRecords = directMasterStore2.data.items;
					unchkdata = new Object();
					unchkdata.records = [];	
						
					Ext.each(detailRecords, function(detailRecord, index) {
						if(masterSoNum == detailRecord.get('SO_NUM') && masterOrderNum == detailRecord.get('ORDER_NUM')) {
							unchkdata.records.push(detailRecord);
						}
					});
					masterGrid2.getSelectionModel().deselect(unchkdata.records);
					selectRecord.set('ITEM_LIST', '');
					fnSetDetailData(masterSoNum, masterOrderNum);

					gschkgridCnt = 0;
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}),
		columns: [{
				xtype		: 'rownumberer',
				sortable	: false,
				align		: 'center !important',
				resizable	: true, 
				width		: 35
			},
			{dataIndex: 'SO_NUM'		, width: 130,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
				}
			},
			{dataIndex: 'CUSTOM_CODE'	, width: 80 },
			{dataIndex: 'CUSTOM_NAME'	, width: 100},
			{dataIndex: 'SO_DATE'		, width: 80 },
			{dataIndex: 'ORDER_TYPE'	, width: 120, align: 'center'},
			//20190716 추가
			{dataIndex: 'ORDER_PRSN'	, width: 90, align: 'center'},
			{dataIndex: 'MONEY_UNIT'	, width: 90 , align: 'center'},
			{dataIndex: 'EXCHG_RATE_O'	, width: 90 },
			{dataIndex: 'ORDER_O'		, width: 90	, summaryType: 'sum'},
			{dataIndex: 'ORDER_Q'		, width: 90	, summaryType: 'sum'},
			{dataIndex: 'ORDER_NUM'		, width: 130, hidden: true},
			{dataIndex: 'STATUS_FLAG'	, width: 90 , align: 'center'},
			{dataIndex: 'SAVE_FLAG'		, width: 80	, hidden: true},
			{dataIndex: 'ITEM_LIST'		, width: 500, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['ORDER_TYPE', 'ORDER_PRSN', 'MONEY_UNIT', 'EXCHG_RATE_O'])) {
					var selRecords = masterGrid1.getSelectionModel().getSelection();
					if(gschkgridCnt != 0 && selRecords.length > 1){
						Unilite.messageBox('주문 상세정보에 변경된 데이터가 있습니다. 수주확정 또는 취소 먼저 진행하십시오.');
						UniAppManager.setToolbarButtons('save', false);
						return false;
					}
					return true;
				} else {
					return false;
				}
			},
			beforecellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					var masterSoNum		= record.get('SO_NUM');
					var masterOrderNum	= record.get('ORDER_NUM');
					fnSetDetailData(masterSoNum, masterOrderNum);
				}
				beforeRowIndex = rowIndex;
			},
			edit: function(editor, e) {
				var fieldName = e.field;
				if(fieldName == 'ORDER_TYPE' || fieldName == 'MONEY_UNIT' || fieldName == 'EXCHG_RATE_O'){
					var saveYn = UniAppManager.app._needSave();
					directMasterStore1.commitChanges();
					UniAppManager.setToolbarButtons('save', saveYn);
				}
			}
		},
		//20210323 추가
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store) {
				var panelStatus	= panelResult.getValues().STATUS_FLAG;
				var cls			= '';
				if(record.get('STATUS_FLAG') != panelStatus) {
					cls = 'x-change-blue';
				}
				return cls;
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('sof190ukrvGrid2', {
		store	: directMasterStore2,
		layout	: 'fit',
		region	: 'south',
		flex	: 0.6,
		uniOpt	: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ 
			{id: 'masterGridSubTotal2'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
			{id: 'masterGridTotal2'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		selModel: Ext.create('Ext.selection.CheckboxModel', {showHeaderCheckbox: false,
			listeners: {
				//20210323 추가
				beforeselect: function(rowSelection, record, index, eOpts) {
					var panelStatus	= panelResult.getValues().STATUS_FLAG;
					if(record.get('STATUS_FLAG') != panelStatus) {
						return false;
					}
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var masterGrids		= directMasterStore1.data.items;
					var masterSoNum		= selectRecord.get('SO_NUM');
					var masterOrderNum	= selectRecord.get('ORDER_NUM');
					var detailItemList	= '';
					var selRecords		= masterGrid2.getSelectionModel().getSelection();
					Ext.each(selRecords, function(selRecord, index) {
						if(masterSoNum == selRecord.get('SO_NUM') && masterGrid2.getSelectionModel().isSelected(selRecord) == true) {
							if(masterOrderNum == selRecord.get('ORDER_NUM')) {
								detailItemList = detailItemList + selRecord.get('ITEM_CODE') + ',';
							}
						}
					});
					Ext.each(masterGrids, function(masterGrid, i) {
						if(masterSoNum == masterGrid.get('SO_NUM')) {
							masterGrid.set('ITEM_LIST', detailItemList);
						}
					});	
					gschkgridCnt = gschkgridCnt - 1;
					UniAppManager.setToolbarButtons('save', false);
				},
				deselect: function(grid, selectRecord, index, eOpts ){
					var masterGrids		= directMasterStore1.data.items;
					var masterSoNum		= selectRecord.get('SO_NUM');
					var masterOrderNum	= selectRecord.get('ORDER_NUM');
					var detailItemList = '';
					var selRecords = masterGrid2.getSelectionModel().getSelection();
					Ext.each(selRecords, function(selRecord, index) {
						if(masterSoNum == selRecord.get('SO_NUM') || masterGrid2.getSelectionModel().isSelected(selRecord) == true) {
							if(masterOrderNum == selRecord.get('ORDER_NUM')) {
								detailItemList = detailItemList + selRecord.get('ITEM_CODE') + ',';
							}
						}
					});
					Ext.each(masterGrids, function(masterGrid, i) {
						if(masterSoNum == masterGrid.get('SO_NUM')) {
							masterGrid.set('ITEM_LIST', detailItemList);
						}
					});
					gschkgridCnt = gschkgridCnt + 1;
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}),
		columns: [
			{dataIndex: 'SO_NUM'			, width: 130, hidden: true},
			{dataIndex: 'SO_SEQ'			, width: 80	, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 80 , hidden: true},
			{dataIndex: 'SO_DATE'			, width: 80 , hidden: true},
			{dataIndex: 'STATUS_FLAG'		, width: 80 , hidden: false, align: 'center'},
			{dataIndex: 'ITEM_CODE'			, width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
				}
			},
			{dataIndex: 'ITEM_NAME'			, width: 120},
			{dataIndex: 'ORDER_Q'			, width: 90	, summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT'		, width: 66 , align: 'center'},
			{dataIndex: 'TRNS_RATE'			, width: 66 },
			{dataIndex: 'ORDER_P'			, width: 80	},
			{dataIndex: 'ORDER_O'			, width: 80	, summaryType: 'sum'},
			{dataIndex: 'ORDER_TAX_O'		, width: 80	, summaryType: 'sum'},
			{dataIndex: 'ORDER_TOT_O'		, width: 80	, summaryType: 'sum'},
			{dataIndex: 'DVRY_DATE'			, width: 80	, hidden: false},
			{dataIndex: 'POSS_DVRY_DATE'	, width: 80	, hidden: false},
			{dataIndex: 'STATUS_REMARK'		, width: 200},
			{dataIndex: 'REMARK'			, width: 200, hidden: false},
			{dataIndex: 'ADDRESS'			, width: 200, hidden: true},
			{dataIndex: 'ORDER_NUM'			, width: 130, hidden: true},
			{dataIndex: 'SER_NO'			, width: 80	, hidden: true},
			{dataIndex: 'SO_ITEM_SEQ'		, width: 80	, hidden: true},
			{dataIndex: 'SAVE_FLAG'			, width: 80, hidden: true},
			//20190716 추가
			{dataIndex: 'SO_REMARK'			, width: 200, hidden: false},
			{dataIndex: 'SO_REMARK_INTER'	, width: 200, hidden: false},
			//20210319 추가
			{dataIndex: 'DELIV_METHOD'	, width: 100, hidden: true, align: 'center'},
			{dataIndex: 'RECEIVER_NAME'	, width: 100, hidden: true},
			{dataIndex: 'TELEPHONE_NUM1', width: 120, hidden: true},
			{dataIndex: 'ZIP_NUM'		, width: 100, hidden: true},
			{dataIndex: 'ADDRESS1'		, width: 200, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['POSS_DVRY_DATE', 'STATUS_REMARK', 'REMARK', 'SO_REMARK', 'SO_REMARK_INTER'])) {
					return true;
				} else {
					return false;
				}
			}
		},
		//20210323 추가
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store) {
				var panelStatus	= panelResult.getValues().STATUS_FLAG;
				var cls			= '';
				if(record.get('STATUS_FLAG') != panelStatus) {
					cls = 'x-change-blue';
				}
				return cls;
			}
		}
	});



	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel		: '<t:message code="system.label.sales.orderdate" default="주문일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'SO_DATE_FR',
			endFieldName	: 'SO_DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME'
		}),{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			width	: 300,
			items	: [{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.status" default="상태"/>',
				id			: 'statusFlag',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.order" default="주문"/>', 
					width		: 60,
					name		: 'STATUS_FLAG',
					inputValue	: '2'
					//checked		: true 
				},{
					boxLabel	: '<t:message code="system.label.sales.orderconfirmation" default="수주확정"/>', 
					width		: 80,
					name		: 'STATUS_FLAG',
					inputValue	: '9'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.STATUS_FLAG == '2') {
							//주문확정 데이터는 삭제, 수정 가능: 선택하여 수주확정도 가능
							directMasterStore1.uniOpt.editable	= true;
							directMasterStore1.uniOpt.deletable	= true;
							directMasterStore2.uniOpt.editable	= true;
							directMasterStore2.uniOpt.deletable	= true;
							panelResult.down('#btnConfirm').setText('<t:message code="system.label.sales.orderconfirmation" default="수주확정"/>');
							masterGrid1.getColumn('ORDER_NUM').setHidden(true);
							
						} else {
							//수주확정 데이터는 삭제, 수정 불가능: 선택하여 취소만 가능
							directMasterStore1.uniOpt.editable	= false;
							directMasterStore1.uniOpt.deletable	= false;
							directMasterStore2.uniOpt.editable	= false;
							directMasterStore2.uniOpt.deletable	= false;
							panelResult.down('#btnConfirm').setText('<t:message code="system.label.sales.cancel" default="취소"/>');
							masterGrid1.getColumn('ORDER_NUM').setHidden(false);
						}
						UniAppManager.app.onQueryButtonDown(newValue.STATUS_FLAG);
					}
				}
			}]
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.sales.orderconfirmation" default="수주확정"/>',
			itemId	: 'btnConfirm',
			name	: 'CONFIRM',
			width	: 110,	
			handler	: function() {
				//20210323 추가: 그리드 체크로직 먼저 수행
				var inValidRecs = directMasterStore1.getInvalidRecords()
				if(inValidRecs.length != 0) {
					masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
					return false;
				}
				if(masterGrid1.selModel.getCount() == 0) {
					Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
					return false;
				}
				masterGrid2.getStore().clearFilter();
				var records1 = masterGrid1.getSelectedRecords()
				var records2 = directMasterStore2.data.items;
				var saveCnt = 0;

				//수주확정, 취소 진행할 master Data에 flag값 set
				Ext.each(records1, function(record1, index) {
					if(record1.get('ITEM_LIST') != ''){
						saveCnt = saveCnt + 1;
					}
					record1.set('SAVE_FLAG', 'Y');
					//수주확정, 취소 진행할 detail Data에 flag값 set
					Ext.each(records2, function(record2, index) {
						if(record1.get('SO_NUM') == record2.get('SO_NUM') && record1.get('ORDER_NUM') == record2.get('ORDER_NUM')) {
							if(masterGrid2.getSelectionModel().isSelected(record2) == true){
								record2.set('SAVE_FLAG', 'Y');
							}
						}
					});
				});
				if(saveCnt != 0){
					directMasterStore1.saveStore();
				}else{
					Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
					return false;
				}
				// 20201130 추가
				var masterRecord	= masterGrid1.getStore().getAt(beforeRowIndex)
				var masterSoNum		= masterRecord.get('SO_NUM');
				var masterOrderNum	= masterRecord.get('ORDER_NUM');

				fnSetDetailData(masterSoNum, masterOrderNum);
			}
		}
		// 20210216 알림 메세지에서 조회 가능하도록 주문번호, 주문순번  hidden처리해서 추가
		,{
			fieldLabel: '<t:message code="system.label.sales.orderno" default="주문번호"/>',
			name:'SO_NUM',
			xtype: 'uniTextfield',
			readOnly: true,
			hidden:true
		},{
			fieldLabel: '<t:message code="system.label.sales.orderseq" default="주문순번"/>',
			name:'SO_SEQ',
			xtype:'uniTextfield',
			readOnly: true,
			hidden:true
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
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}

					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField')  ;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField')  ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});	



	Unilite.Main({
		id			: 'sof190ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid1, masterGrid2, panelResult
			]
		}],
		fnInitBinding : function(params) {
			if (!Ext.isEmpty(params && params.PGM_ID) && params.PGM_ID == 'sof190ukrv'){
				panelResult.setValue('CUSTOM_CODE'	, params["CUSTOM_CODE"]);
				panelResult.setValue('CUSTOM_NAME'	, params["CUSTOM_NAME"]);
				panelResult.setValue('SO_DATE_FR'	, params["SO_DATE"]);
				panelResult.setValue('SO_DATE_TO'	, params["SO_DATE"]);
				panelResult.setValue('STATUS_FLAG'	, params["STATUS_FLAG"]);
			// 20210216 수주확정 알림메세지의 param 세팅 후 조회
			} else if(!Ext.isEmpty(params && params.SO_NUM)){
				panelResult.setValue('SO_NUM'		, params["SO_NUM"]);
				panelResult.setValue('SO_SEQ'		, params["SO_SEQ"]);
				panelResult.setValue("SO_DATE_FR",	'');
				panelResult.setValue("SO_DATE_TO",	'');
				panelResult.setValue('STATUS_FLAG'	, '2');
				this.onQueryButtonDown();
			} else {
				panelResult.setValue('SO_DATE_FR'	, UniDate.get('startOfMonth'));
				panelResult.setValue('SO_DATE_TO'	, UniDate.get('today'));
				panelResult.setValue('STATUS_FLAG'	, '2');
				panelResult.setValue('CUSTOM_CODE'	, '');
                panelResult.setValue('CUSTOM_NAME'	, '');
			}
			
			UniAppManager.setToolbarButtons('reset', false);
		},
		onQueryButtonDown : function(STATUS_FLAG){
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			//전역변수 초기화
			beforeRowIndex = undefined;

			directMasterStore1.loadStoreRecords(STATUS_FLAG);
			directMasterStore2.loadStoreRecords(STATUS_FLAG);
			UniAppManager.setToolbarButtons('reset', true);
			gschkgridCnt = 0;
		},
		onResetButtonDown: function() {
			//전역변수 초기화
			beforeRowIndex = undefined;
			masterGrid1.getStore().loadData({});
			masterGrid2.getStore().loadData({});
			this.fnInitBinding();
			gschkgridCnt = 0;
		},
		onDeleteDataButtonDown: function() {
			//상태가 주문일 경우, detail data만 삭제 가능
			if(Ext.getCmp('statusFlag').getChecked()[0].inputValue == '2') {
				var selRow	= masterGrid2.getSelectedRecord();
				if(!Ext.isEmpty(selRow)) {
					var soNum	= selRow.get('SO_NUM');
					if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						//masterGrid1, masterGrid2의 상태 확인
						var dirtyFlag1 = false;
						var dirtyFlag2 = false;
						if(directMasterStore1.isDirty()) {
							dirtyFlag1 = true;
						}
						if(directMasterStore2.isDirty()) {
							dirtyFlag2 = true;
						}
						masterGrid2.deleteSelectedRow();
						//detail data삭제에 따른 master data 값 재계산
						var results = directMasterStore2.sumBy(function(record, id) {
							if(soNum == record.get('SO_NUM')) return true;
						}, ['ORDER_O', 'ORDER_Q']);
						//계산한 값 masterGrid1에 set
						var masterRecords = directMasterStore1.data.items;
						Ext.each(masterRecords, function(masterRecord, index) {
							if(selRow.get('SO_NUM') == masterRecord.get('SO_NUM')) {
								masterRecord.set('ORDER_O', results.ORDER_O);
								masterRecord.set('ORDER_Q', results.ORDER_Q);
							}
						});
					}
					if(!dirtyFlag1) directMasterStore1.commitChanges();
					if(!dirtyFlag2) directMasterStore2.commitChanges();
				} else {
					Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
					return false;
				}
			//상태가 수주확정일 경우, master data만 삭제 가능: 삭제로직 주석 -> 취소버튼과 동일로직
			} /*else {
				var selRow = masterGrid1.getSelectedRecord();
				if(!Ext.isEmpty(selRow)) {
					if(selRow.phantom === true) {
						masterGrid1.deleteSelectedRow();
					} else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						fnSetDetailData(selRow.get('SO_NUM'), selRow.get('ORDER_NUM'));
						masterGrid2.reset();
						masterGrid1.deleteSelectedRow();
					}
				} else {
					Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
					return false;
				}
			}*/
		},
		onSaveDataButtonDown: function(config) {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			if(!directMasterStore1.isDirty() && directMasterStore2.isDirty()){
				directMasterStore2.saveStore();
			} else if(directMasterStore1.isDirty()) {
				Unilite.messageBox('<t:message code="system.message.common.savecheck2" default="저장할 데이터가 없습니다."/>'+ '\n' + '<t:message code="system.message.sales.message129" default="수주 확정을 진행하세요."/>');
				return false;
			} else {
				Unilite.messageBox('<t:message code="system.message.common.savecheck2" default="저장할 데이터가 없습니다."/>');
				return false;
			}
		}
	});		//End of Unilite.Main({



	function fnSetDetailData(masterSoNum, masterOrderNum) {
		masterGrid2.getStore().clearFilter();
		masterGrid2.getStore().filterBy (function(record){
			if(!Ext.isEmpty(masterSoNum)) {
				if(masterSoNum == record.get("SO_NUM") && masterOrderNum == record.get("ORDER_NUM")){
					return true;
				} else{
					return false;
				}
			} else{
				return false;
			}
		});
	}


/*	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ORDER_Q":
					if(newValue <= 0) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('ORDER_Q',oldValue);
						break
					}
					var digit			= UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
					var numDigitOfPrice	= UniFormat.Price.length - digit;
					var sOrderP			= record.get('ORDER_P');
					var sOrderQ			= newValue;
					var sTaxType		= record.get('TAX_TYPE');
					var sTaxInoutType	= record.get('TAX_CALC_TYPE');
					var sVatRate		= record.get('VAT_RATE');
					var dOrderAmtO		= 0;
					var dTaxAmtO		= 0;
					var dAmountI		= 0;

					if(sTaxInoutType == '1') {
						dOrderAmtO	= Unilite.multiply(sOrderP, sOrderQ);
						dTaxAmtO	= Unilite.multiply(dOrderAmtO, sVatRate) / 100;
						dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderAmtO	, '3'	, numDigitOfPrice);
						dTaxAmtO	= UniSales.fnAmtWonCalc(dTaxAmtO	, '2'	, numDigitOfPrice);
					} else if(sTaxInoutType == '2') {
						dAmountI	= Unilite.multiply(sOrderP, sOrderQ);
						dTemp		= UniSales.fnAmtWonCalc(Unilite.multiply((dAmountI / ( sVatRate + 100 )), 100), '2', numDigitOfPrice);
						dTaxAmtO	= UniSales.fnAmtWonCalc(Unilite.multiply(dTemp, sVatRate) / 100, '2', numDigitOfPrice);
						dOrderAmtO	= UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice) ;
					}
					if(sTaxType == '2') {
						dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderO, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice);
						dTaxAmtO	= 0;
					}
					record.set('ORDER_O'	, dOrderAmtO);
					record.set('ORDER_TAX_O', dTaxAmtO);
					record.set('ORDER_TOT_O', dOrderAmtO + dTaxAmtO);
				break;
			}
			return rv;
		}
	});*/
};
</script>
