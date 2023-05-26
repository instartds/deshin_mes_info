<%--
'	프로그램명 : 출고등록 (구매재고)
'
'	작  성  자 : (주)포렌 개발실
'	작  성  일 :
'
'	최종수정자 :
'	최종수정일 :
'
'	버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mtr210ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B005" opts= '1;2;3' />		<!-- 출고처 구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" />						<!-- 출고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M101" />						<!-- 자동채번 -->
	<t:ExtComboStore comboType="AU" comboCode="M104" />						<!-- 출고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B021" />						<!-- 품목상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B022" />						<!-- 재고상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B031" />						<!-- 생성경로 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />						<!-- 재고단위 -->
	<t:ExtComboStore comboType="AU" comboCode="P106" />						<!-- 진행상태 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />			<!--창고-->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />			<!--작업장-->
	<t:ExtComboStore comboType="WU" />										<!--작업장(사용여부 Y) -->
	<t:ExtComboStore comboType="OU" />										<!--창고(사용여부 Y) -->
	<t:ExtComboStore comboType="O" />										<!--창고 -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고Cell-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var SearchInfoWindow;	// 조회버튼 누르면 나오는 조회창
var RefSearchWindow;	// 출고요청 참조
var RefSearchWindow2;	// 반품가능요청 참조
var RefSearchWindow3;	//재고참조
var refSearch3YN = false;

var BsaCodeInfo = {
	gsAutoType		: '${gsAutoType}',
	gsInvstatus		: '${gsInvstatus}',
	gsMoneyUnit		: '${gsMoneyUnit}',
	gsInoutCodeType	: '${gsInoutCodeType}',
	gsManageLotNoYN	: '${gsManageLotNoYN}',
	gsBomPathYN		: '${gsBomPathYN}',
	gsSumTypeCell	: '${gsSumTypeCell}',
	gsOutDetailType	: '${gsOutDetailType}',
	whList			: ${whList},
	gsUsePabStockYn	: '${gsUsePabStockYn}',
	gsCheckStockYn	: '${gsCheckStockYn}'
};

/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);
*/
var outDivCode = UserInfo.divCode;

function appMain() {
	var gsSumTypeCell = false;
	if(BsaCodeInfo.gsSumTypeCell =='N')	{
		gsSumTypeCell = true;
	}

	var sumtypeCell = true; //재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeCell =='Y') {
		sumtypeCell = false;
	}

	var usePabStockYn = true; //가용재고 컬럼 사용여부
	if(BsaCodeInfo.gsUsePabStockYn =='Y') {
		usePabStockYn = false;
	}

	var gsManageLotNoYN = false;
	if(BsaCodeInfo.gsManageLotNoYN =='N') {
		gsManageLotNoYN = true;
	}

	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoOrderNum = true;
	}

	var isCheckStockYn = false;
	if(BsaCodeInfo.gsCheckStockYn=='+') {
		isCheckStockYn = true;
	}


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'mtr210ukrvService.selectList',
			update	: 'mtr210ukrvService.updateDetail',
			create	: 'mtr210ukrvService.insertDetail',
			destroy	: 'mtr210ukrvService.deleteDetail',
			syncAll	: 'mtr210ukrvService.saveAll'
		}
	});



	/** Model 정의
	* @type
	*/
	Unilite.defineModel('mtr210ukrvModel', {
		fields: [
			{name: 'INOUT_NUM'				, text: '<t:message code="system.label.purchase.issueno" default="출고번호"/>'					, type: 'string'},
			{name: 'INOUT_SEQ'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'						, type: 'int'},
			{name: 'INOUT_METH'				, text: '<t:message code="system.label.purchase.method" default="방법"/>'						, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		, text: '<t:message code="system.label.purchase.issuetype" default="출고유형"/>'				, type: 'string', comboType: 'AU', comboCode: 'M104', allowBlank: false},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'					, type: 'string', comboType: 'BOR120', child: 'WH_CODE'},
			{name: 'INOUT_CODE'				, text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>'				, type: 'string', allowBlank: false},
			{name: 'INOUT_CODE_DETAIL'		, text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>Cell'			, type: 'string'},
			{name: 'INOUT_NAME'				, text: '<t:message code="system.label.purchase.issueplacename" default="출고처명"/>'			, type: 'string', type: 'string', comboType: 'OU'},
			{name: 'INOUT_NAME1'			, text: '<t:message code="system.label.purchase.issueplacename" default="출고처명"/>'			, type: 'string'},
			{name: 'INOUT_NAME2'			, text: '<t:message code="system.label.purchase.issueplacename" default="출고처명"/>'			, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.purchase.spec" default="규격"/>'						, type: 'string'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string'},
			{name: 'PATH_CODE'				, text: '<t:message code="system.label.purchase.pathinfo" default="PATH정보"/>'				, type: 'string'},
			{name: 'NOT_Q'					, text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>'				,type : 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'INOUT_Q'				, text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'					,type : 'float', decimalPrecision: 6, format:'0,000.000000', allowBlank: false},
			{name: 'ITEM_STATUS'			, text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>'				, type: 'string', comboType: 'AU', comboCode: 'B021', allowBlank: false},
			{name: 'ORIGINAL_Q'				, text: '<t:message code="system.label.purchase.issueqtywon" default="출고량(원)"/>'			, type: 'uniQty'},
			{name: 'PAB_STOCK_Q'			, text: '<t:message code="system.label.purchase.availableinventoryqty" default="가용재고량"/>'	, type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'			, text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>'				,type : 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'BAD_STOCK_Q'			, text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'			,type : 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'BASIS_NUM'				, text: '<t:message code="system.label.purchase.basisno" default="근거번호"/>'					, type: 'string'},
			{name: 'BASIS_SEQ'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'						, type: 'int'},
			{name: 'INOUT_TYPE'				, text: '<t:message code="system.label.purchase.type" default="타입"/>'						, type: 'string'},
			{name: 'INOUT_CODE_TYPE'		, text: '<t:message code="system.label.purchase.tranplacedivision" default="수불처구분"/>'		, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>'			, type: 'string', comboType: 'OU', allowBlank: false, child: 'WH_CELL_CODE'},
			{name: 'WH_CELL_CODE'			, text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>Cell'		, type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','DIV_CODE']},
			{name: 'INOUT_DATE'				, text: '<t:message code="system.label.purchase.transdate" default="수불일자"/>'				, type: 'uniDate'},
			{name: 'INOUT_P'				, text: '<t:message code="system.label.purchase.tranprice" default="수불단가"/>'				, type: 'uniUnitPrice'},
			{name: 'INOUT_I'				, text: '<t:message code="system.label.purchase.localamount" default="원화금액"/>'				, type: 'uniPrice'},
			{name: 'MONEY_UNIT'				, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'					, type: 'string'},
			{name: 'INOUT_PRSN'				, text: '<t:message code="system.label.purchase.charger" default="담당자"/>'					, type: 'string'},
			{name: 'ACCOUNT_Q'				, text: '<t:message code="system.label.purchase.billqty" default="계산서량"/>'					, type: 'uniQty'},
			{name: 'ACCOUNT_YNC'			, text: '<t:message code="system.label.purchase.billobject" default="계산서대상"/>'				, type: 'string'},
			{name: 'CREATE_LOC'				, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'				, type: 'string', comboType: 'AU', comboCode: 'B031'},
			{name: 'ORDER_NUM'				, text: '수주번호'		, type: 'string'},
			{name: 'ORDER_SEQ'				, text: '수주순번'		, type: 'string'},
			{name: 'REMARK'					, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					, type: 'string'},
			{name: 'PROJECT_NO'				, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'LOT_NO'					, text: 'LOT NO'	, type: 'string'},
			{name: 'SALE_DIV_CODE'			, text: '<t:message code="system.label.purchase.salesdivision" default="매출사업장"/>'			, type: 'string'},
			{name: 'SALE_CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.salesplace" default="매출처"/>'				, type: 'string'},
			{name: 'BILL_TYPE'				, text: '<t:message code="system.label.purchase.salestype" default="매출유형"/>'				, type: 'string'},
			{name: 'SALE_TYPE'				, text: '<t:message code="system.label.purchase.salesclass" default="매출구분"/>'				, type: 'string'},
			{name: 'COMP_CODE'				, text: 'COMP_CODE'	, type: 'string'},
			{name: 'ARRAY_OUTSTOCK_NUM'		, text: '<t:message code="system.label.purchase.requestno" default="요청번호"/>'				, type: 'string'},
			{name: 'ARRAY_REF_WKORD_NUM'	, text: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>'			, type: 'string'},
			{name: 'ARRAY_OUTSTOCK_REQ_Q'	, text: '<t:message code="system.label.purchase.requestqty" default="요청량"/>'				, type: 'uniQty'},
			{name: 'ARRAY_OUTSTOCK_Q'		, text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'					, type: 'uniQty'},
			{name: 'ARRAY_REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					, type: 'string'},
			{name: 'ARRAY_PROJECT_NO'		, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'ARRAY_LOT_NO'			, text: 'LOT NO'	, type: 'string'},
			{name: 'UPDATE_DB_USER'			, text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>'				, type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '<t:message code="system.label.purchase.updatedate" default="수정일"/>'				, type: 'string'},
			{name: 'LOT_YN'					, text: '<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'			, type: 'string'}/*,
			//panelResult의 "REMARK" 값 임시 저장
			{name: 'REMARK_PANEL'			, text: 'TEMP'		, type: 'string'}*/
		]
	});//End of Unilite.defineModel('mtr210ukrvModel', {

	Unilite.defineModel('releaseNoMasterModel', {		//조회버튼 누르면 나오는 조회창
		fields: [
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>'			, type: 'string',comboType: 'OU'},
			{name: 'WH_CELL_CODE'		, text: 'CELL'		, type: 'string'},
			{name: 'WH_CELL_NAME'		, text: 'CELL<t:message code="system.label.purchase.warehouse" default="창고"/>'				, type: 'string'},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.purchase.issuedate" default="출고일"/>'					, type: 'uniDate'},
			{name: 'INOUT_CODE_TYPE'	, text: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>'	, type: 'string',comboType: 'AU',comboCode: 'B005'},
			{name: 'INOUT_CODE'			, text: '<t:message code="system.label.purchase.issueplacecode" default="출고처코드"/>'			, type: 'string'},
			{name: 'INOUT_NAME'			, text: '<t:message code="system.label.purchase.issueplace" default="출고처"/>'				, type: 'string'},
			{name: 'INOUT_PRSN' 		, text: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>'				, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.issueno" default="출고번호"/>'					, type: 'string'},
			{name: 'INOUT_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'						, type: 'string'},
			{name: 'INOUT_TYPE'			, text: '<t:message code="system.label.purchase.trantype1" default="수불타입"/>'				, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				, type: 'string'},
			{name: 'DIV_CODE' 			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'					, type: 'string',comboType:'BOR120'},
			{name: 'LOT_NO' 			, text: 'LOT NO'	, type: 'string'},
			{name: 'PROJECT_NO' 		, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'ITEM_CODE' 			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					, type: 'string'},
			{name: 'ITEM_NAME' 			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					, type: 'string'},
			//20190605 필수 값인데 입력하는 부분 누락되어 추가
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.purchase.issuetype" default="출고유형"/>'				, type: 'string', comboType: 'AU', comboCode: 'M104'}
		]
	});



	/** Store 정의(Service 정의)
	* @type
	*/
	var directMasterStore1 = Unilite.createStore('mtr210ukrvMasterStore1',{
		model	: 'mtr210ukrvModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		//전체삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var inoutNum = panelResult.getValue('INOUT_NUM');
			var isErr = false;
			Ext.each(list, function(record, index) {
				if(record.data['INOUT_NUM'] != inoutNum) {
					record.set('INOUT_NUM', inoutNum);
				}
				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
					alert((index + 1) + '<t:message code="system.message.purchase.message026" default="행의 입력값을 확인 해주세요."/>' + 'LOT NO:' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					isErr = true;
					return false;
				}
			});
			if(isErr) return false;

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("INOUT_NUM", master.INOUT_NUM);
						panelResult.setValue("INOUT_NUM", master.INOUT_NUM);

						directMasterStore1.loadStoreRecords();
						if(directMasterStore1.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}

					}
				};
				this.syncAllDirect(config);
			}else{
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts){
				if(successful)	{
					panelResult.setValue('REMARK', '');
				}
			}
		}
	});//End of var directMasterStore1 = Unilite.createStore('mtr210ukrvMasterStore1',{

	var releaseNoMasterStore = Unilite.createStore('releaseNoMasterStore', {	// 검색팝업창
		model	: 'releaseNoMasterModel',
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
				read: 'mtr210ukrvService.selectreleaseNoMasterList'
			}
		},
		loadStoreRecords : function()	{
			var param= releaseNoSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	/** 검색조건 (Search Panel)
	* @type
	*/
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
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
					panelResult.setValue('WH_CODE','');
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>',
			name		: 'INOUT_CODE_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B005',
			holdable	: 'hold',
			allowBlank	: false,
			value		: BsaCodeInfo.gsInoutCodeType,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					UniAppManager.app.setHiddenColumn();
				}
			}
		},{
			xtype	: 'container',
			layout	: {type: 'vbox'},
			items	: [{
				//출고처명
				fieldLabel	: '<t:message code="system.label.purchase.issueplacename" default="출고처명"/>',
				itemId		: 'inoutWh',
				name		: 'INOUT_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'OU',
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					beforequery:function( queryPlan, eOpts )	{
						var store = queryPlan.combo.store;
						var psStore = panelResult.getField('INOUT_CODE').store;
						store.clearFilter();
						psStore.clearFilter();
						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == panelResult.getValue('DIV_CODE');
							});
							psStore.filterBy(function(record){
								return record.get('option') == panelResult.getValue('DIV_CODE');
							});
						}else{
							store.filterBy(function(record){
								return false;
							});
							psStore.filterBy(function(record){
								return false;
							});
						}
					}
				}
			},	//출고처명1
			Unilite.popup('WORK_SHOP',{
				fieldLabel		: '<t:message code="system.label.purchase.issueplacename" default="출고처명"/>',
				itemId			: 'workShopP',
				textFieldName	: 'TREE_NAME',
				DBtextFieldName	: 'TREE_NAME',
				autoPopup		: true,
				holdable		: 'hold',
				textFieldWidth	: 90,
				listeners: {
					'onSelected': {
						fn: function(records, type) {
							panelResult.setValue('TREE_CODE'	, records[0]['TREE_CODE']);
							panelResult.setValue('TREE_NAME'	, records[0]['TREE_NAME']);
						},
						scope: this
					},
					'onClear': function(type) {
						panelResult.setValue('TREE_CODE'	, '');
						panelResult.setValue('TREE_NAME'	, '');
					},
					applyextparam: function(popup){
						var param =  panelResult.getValues();
						popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
					}
				}
			}),	//출고처명2
			Unilite.popup('DEPT',{
				fieldLabel		: '<t:message code="system.label.purchase.issueplacename" default="출고처명"/>',
				itemId			: 'deptP',
				DBtextFieldName	: 'DEPT_CODE',
				autoPopup		: true,
				holdable		: 'hold',
				valueFieldWidth	: 60,
				textFieldWidth	: 90,
				listeners		: {
					'onSelected': {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE'	, records[0]['TREE_CODE']);
							panelResult.setValue('DEPT_NAME'	, records[0]['TREE_NAME']);
						},
						scope: this
					},
					'onClear' : function(type)	{
						var grdRecord = masterGrid.uniOpt.currentRecord;
						panelResult.setValue('DEPT_CODE'	, '');
						panelResult.setValue('DEPT_NAME'	, '');
					},
					applyextparam: function(popup){
						var param =  panelResult.getValues();
						popup.setExtParam({'DIV_CODE': param.DIV_CODE});
					}
				}
			})]
		},{	//출고유형
			fieldLabel	: '<t:message code="system.label.purchase.issuetype" default="출고유형"/>',
			name		: 'INOUT_TYPE_DETAIL',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'M104',
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
			xtype		: 'uniDatefield',
			name		: 'INOUT_DATE',
			value		: UniDate.get('today'),
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			child		: 'WH_CELL_CODE',
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts )	{
					var store = queryPlan.combo.store;
					var psStore = panelResult.getField('WH_CODE').store;
					store.clearFilter();
					psStore.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
						psStore.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
					}else{
						store.filterBy(function(record){
							return false;
						});
						psStore.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>Cell',
			name		: 'WH_CELL_CODE',
			xtype		: 'uniCombobox',
			holdable	: 'hold',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
			name		: 'INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024',
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.remarks" default="비고"/>',
			name		: 'REMARK',
			xtype		: 'uniTextfield',
			//20190605 수정: 행 추가 후에도 입력가능하도록 수정 - 저장 시, 그리드 행의 remark에 데이터가 없으면 여기에 있는 값 저장하도록 로직 변경
//			holdable	: 'hold',
			colspan		: 3,
			width		: 738,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					var masterRecords = masterGrid.getStore().data.items;
					Ext.each(masterRecords, function(masterRecord, index) {
						//20190605 비고가 비어 있거나, (신규행이고: 일단 주석 필요하면 해제) masterGrid.REMARK == panelResult.REMARK 일 때, panelRult에 입력된 값을 masterGrid.REMARK에 set
						if(Ext.isEmpty(masterRecord.get('REMARK')) || (/*masterRecord.phantom && */masterRecord.get('REMARK') == oldValue)) {
							masterRecord.set('REMARK', newValue);
						}
					});
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.issueno" default="출고번호"/>',
			name		: 'INOUT_NUM',
			xtype		: 'uniTextfield',
			readOnly	: isAutoOrderNum,
			holdable	: 'hold',
			holdable	: isAutoOrderNum ? 'readOnly':'hold',
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
						var labelText = invalid.items[0]['fieldLabel']+':';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
					}
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();

				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField');
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
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	var releaseNoSearch = Unilite.createSearchForm('releaseNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120'
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false
			},{
				fieldLabel: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>',
				name: 'INOUT_CODE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B005',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						UniAppManager.app.setHiddenField();
					}
				}
			},{
				xtype:'container',
				layout: {type: 'vbox'},
				items: [
				Unilite.popup('WORK_SHOP',{
					itemId : 'workShopP',
					fieldLabel: '<t:message code="system.label.purchase.issueplace" default="출고처"/>',
					valueFieldName: 'INOUT_CODE_WORK_SHOP',
					textFieldName: 'INOUT_NAME_WORK_SHOP',
					hidden:true,
					listeners: {
						applyextparam: function(popup){
							popup.setExtParam({'TYPE_LEVEL': releaseNoSearch.getValue('DIV_CODE')});
						}
					}
				}),

				Unilite.popup('DEPT',{
					itemId : 'deptP',
					fieldLabel: '<t:message code="system.label.purchase.issueplace" default="출고처"/>',
					valueFieldName: 'INOUT_CODE_DEPT',
					textFieldName: 'INOUT_NAME_DEPT',
					hidden:true,
					listeners: {
						applyextparam: function(popup){
							popup.setExtParam({'TYPE_LEVEL': releaseNoSearch.getValue('DIV_CODE')});
						}
					}
				}),
				{
					fieldLabel: '<t:message code="system.label.purchase.issueplacewarehouse" default="출고처창고"/>',
					itemId : 'inoutWh',
					name: 'INOUT_CODE_WH',
					xtype: 'uniCombobox',
					comboType: 'OU',
					hidden:true
				}]
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType: 'OU'
			},{
				fieldLabel: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024'
			},{
				fieldLabel: 'Lot No',
				name: 'LOT_NO',
				xtype: 'uniTextfield'
			},
			Unilite.popup('DIV_PUMOK', {
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				validateBlank: false
			}),{
				fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				name: 'PROJECT_NO',
				xtype: 'uniTextfield'
			}]
	}); // createSearchForm



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('mtr210ukrvGrid1', {
		// for tab
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer: false
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'INOUT_NUM'					, width: 66, hidden: true},
			{dataIndex: 'INOUT_SEQ'					, width: 60},
			{dataIndex: 'WH_CODE'					, width: 85},
//			{dataIndex: 'WH_CELL_CODE'				, width: 110, hidden: sumtypeCell},
			{dataIndex: 'WH_CELL_CODE'				, width: 110, hidden: true},
			{dataIndex: 'INOUT_METH'				, width: 46, hidden: true},
			{dataIndex: 'INOUT_TYPE_DETAIL'			, width: 85},
			{dataIndex: 'DIV_CODE'					, width: 110},
			{dataIndex: 'INOUT_CODE'				, width: 80, hidden: true,
				'editor' : Unilite.popup('WORK_SHOP_G',{textFieldName:'TREE_NAME', textFieldWidth:100, DBtextFieldName: 'TREE_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('INOUT_CODE',records[0]['TREE_CODE']);
								grdRecord.set('INOUT_NAME1',records[0]['TREE_NAME']);

							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;

							grdRecord.set('INOUT_CODE', '');
							grdRecord.set('INOUT_NAME1', '');
						},
						applyextparam: function(popup){
							var param =  panelResult.getValues();
							popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
						}
					}
				})
			},
			{dataIndex: 'INOUT_CODE_DETAIL'			, width: 53, hidden: true},
			{dataIndex: 'INOUT_NAME'				, width: 150},					//창고
			{dataIndex: 'INOUT_NAME1'				, width: 150, hidden: true,		//작업장
				'editor' : Unilite.popup('WORK_SHOP_G',{
					textFieldName:'TREE_NAME',
					DBtextFieldName: 'TREE_NAME',
					autoPopup: true,
					textFieldWidth:100,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('INOUT_CODE',records[0]['TREE_CODE']);
								grdRecord.set('INOUT_NAME1',records[0]['TREE_NAME']);

							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;

							grdRecord.set('INOUT_CODE', '');
							grdRecord.set('INOUT_NAME1', '');
						},
						applyextparam: function(popup){
							var param =  panelResult.getValues();
							popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
						}
					}
				})
			},
			{dataIndex: 'INOUT_NAME2'				, width: 150, hidden: true,		//부서
				'editor': Unilite.popup('DEPT_G',{
					autoPopup: true,
					DBtextFieldName: 'REQ_DEPT_CODE',
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('INOUT_CODE',records[0]['TREE_CODE']);
								grdRecord.set('INOUT_NAME2',records[0]['TREE_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('INOUT_CODE','');
							grdRecord.set('INOUT_NAME2','');
						},
						applyextparam: function(popup){
							var param =  panelResult.getValues();
							popup.setExtParam({'DIV_CODE': param.DIV_CODE});
						}
					}
				})
			},
			{dataIndex: 'ITEM_CODE'					, width: 100,
				editor: Unilite.popup('LOT_STOCK_G', {
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										masterGrid.setItemData(record,false);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record,false);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setItemData(null,true);
						},
						applyextparam: function(popup){
							var param		= panelResult.getValues();
							var record		= masterGrid.getSelectedRecord();
							var divCode		= panelResult.getValue('DIV_CODE');
							var itemCode	= record.get('ITEM_CODE');
							var itemName	= record.get('ITEM_NAME');
							var whCode		= record.get('WH_CODE');
							var whCellCode	= record.get('WH_CELL_CODE');
							popup.setExtParam({
								'SELMODEL'		: 'MULTI',
								'DIV_CODE'		: divCode,
								'POPUP_TYPE'	: 'GRID_CODE',
								'ITEM_CODE'		: itemCode,
								'ITEM_NAME'		: itemName,
								'WH_CODE'		: whCode,
								'WH_CELL_CODE'	: whCellCode
							});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'					, width: 200,
				editor: Unilite.popup('LOT_STOCK_G', {
					textFieldName: 'ITEM_NAME',
					DBtextFieldName: 'ITEM_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										masterGrid.setItemData(record,false);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record,false);
									}
								});
							},
						scope: this
						},
						'onClear': function(type) {
							masterGrid.setItemData(null,true);
						},
						applyextparam: function(popup){
							var param		= panelResult.getValues();
							var record		= masterGrid.getSelectedRecord();
							var divCode		= panelResult.getValue('DIV_CODE');
							var itemCode	= record.get('ITEM_CODE');
							var itemName	= record.get('ITEM_NAME');
							var whCode		= record.get('WH_CODE');
							var whCellCode	= record.get('WH_CELL_CODE');
							popup.setExtParam({
								'SELMODEL'		: 'MULTI',
								'DIV_CODE'		: outDivCode,
								'ITEM_CODE'		: itemCode,
								'ITEM_NAME'		: itemName,
								'WH_CODE'		: whCode,
								'WH_CELL_CODE'	: whCellCode
							});
						}
					}
				})
			},
			{dataIndex: 'SPEC'						, width: 150},
			{dataIndex: 'LOT_NO'					, width: 133, hidden: gsManageLotNoYN,
				editor: Unilite.popup('LOT_MULTI_G', {
					textFieldName: 'LOT_CODE',
					DBtextFieldName: 'LOT_CODE',
					autoPopup: true,
					validateBlank: false,
					listeners: {
						applyextparam: function(popup){
							var record		= masterGrid.getSelectedRecord();
							var divCode		= panelResult.getValue('DIV_CODE');
							var itemCode	= record.get('ITEM_CODE');
							var itemName	= record.get('ITEM_NAME');
							var whCode		= record.get('WH_CODE');
							var whCellCode	= record.get('WH_CELL_CODE');
							popup.setExtParam({SELMODEL: 'MULTI', 'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode, 'S_WH_CELL_CODE': whCellCode});
						},
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord	= masterGrid.uniOpt.currentRecord;
								var rtnRecord;
								var goodStockQ	= 0;
								var badStockQ	= 0;
								var outQ		= 0;
								Ext.each(records, function(record,i) {
									if(i==0){
										rtnRecord = grdRecord;
									}else{
										UniAppManager.app.onNewDataButtonDown();
										rtnRecord = masterGrid.getSelectedRecord();
										var columns		= masterGrid.getColumns();
										Ext.each(columns, function(column, index)	{
										 if(column.dataIndex != 'INOUT_SEQ' && column.dataIndex != 'INOUT_Q' &&
											column.dataIndex != 'NOT_Q' && column.dataIndex != 'ORIGINAL_Q' &&
											column.dataIndex != 'PAB_STOCK_Q' && column.dataIndex != 'GOOD_STOCK_Q' &&
											column.dataIndex != 'BAD_STOCK_Q' && column.dataIndex != 'ACCOUNT_Q' ) {
												rtnRecord.set(column.initialConfig.dataIndex, grdRecord.get(column.initialConfig.dataIndex));
											}
										});
									}
									rtnRecord.set('LOT_NO',			record['LOT_NO']);
									rtnRecord.set('WH_CODE',		record['WH_CODE']);
									rtnRecord.set('WH_CELL_CODE',	record['WH_CELL_CODE']);
									goodStockQ	= record['GOOD_STOCK_Q'];
									badStockQ	= record['BAD_STOCK_Q'];
									outQ		= rtnRecord.get('INOUT_Q') ;

									if(goodStockQ < outQ){
										rtnRecord.set('INOUT_Q',goodStockQ);
									}
									rtnRecord.set('GOOD_STOCK_Q', goodStockQ);
									rtnRecord.set('BAD_STOCK_Q', badStockQ);
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var rtnRecord = masterGrid.uniOpt.currentRecord;
							rtnRecord.set('LOT_NO', '');
						}
					}
				})
			},
			{dataIndex: 'LOT_YN'					, width: 90 , hidden: true},
			{dataIndex: 'STOCK_UNIT'				, width: 66 , align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'PATH_CODE'					, width: 113, hidden: true},
			{dataIndex: 'NOT_Q'						, width: 106, summaryType: 'sum'},
			{dataIndex: 'INOUT_Q'					, width: 106, summaryType: 'sum'},
			{dataIndex: 'ITEM_STATUS'				, width: 80 , align: 'center'},
			{dataIndex: 'ORIGINAL_Q'				, width: 93},
			{dataIndex: 'PAB_STOCK_Q'				, width: 100, hidden: usePabStockYn},
			{dataIndex: 'GOOD_STOCK_Q'				, width: 100},
			{dataIndex: 'BAD_STOCK_Q'				, width: 100},
			{dataIndex: 'BASIS_NUM'					, width: 116, hidden: true},
			{dataIndex: 'BASIS_SEQ'					, width: 33 , hidden: true},
			{dataIndex: 'INOUT_TYPE'				, width: 33 , hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'			, width: 33 , hidden: true},
			{dataIndex: 'INOUT_DATE'				, width: 80 , hidden: false},
			{dataIndex: 'INOUT_P'					, width: 33 , hidden: true},
			{dataIndex: 'INOUT_I'					, width: 106, hidden: true},
			{dataIndex: 'MONEY_UNIT'				, width: 106, hidden: true},
			{dataIndex: 'INOUT_PRSN'				, width: 106, hidden: true},
			{dataIndex: 'ACCOUNT_Q'					, width: 106, hidden: true},
			{dataIndex: 'ACCOUNT_YNC'				, width: 106, hidden: true},
			{dataIndex: 'ARRAY_OUTSTOCK_NUM'		, width: 120},
			{dataIndex: 'CREATE_LOC'				, width: 73 , hidden: true},
			{dataIndex: 'ARRAY_REF_WKORD_NUM'		, width: 120,
	              'editor': Unilite.popup('WKORD_NUM_G',{
	                    textFieldName : 'WKORD_NUM',
	                    DBtextFieldName : 'WKORD_NUM',
				    	autoPopup: true,
	                    listeners: { 'onSelected': {
	                        fn: function(records, type  ){
	                            var grdRecord = masterGrid.uniOpt.currentRecord;
	                            grdRecord.set('ARRAY_REF_WKORD_NUM',records[0]['WKORD_NUM']);

	                            if(panelResult.getValue('INOUT_CODE_TYPE') == '3'){ //21.04.23 출고처구분이 작업장일 경우에는 선택한 작업지시의 작업장을 세팅
									grdRecord.set('INOUT_CODE',records[0]['WORK_SHOP_CODE']);
									grdRecord.set('INOUT_NAME1',records[0]['WORK_SHOP_CODE_NM']);
								}
	                        },
	                        scope: this
	                      },
	                      'onClear' : function(type)    {
	                            var grdRecord = masterGrid.uniOpt.currentRecord;
	                            grdRecord.set('ARRAY_REF_WKORD_NUM','');
	                      },
	                        applyextparam: function(popup){
	                            var param =  panelResult.getValues();
	                            popup.setExtParam({'DIV_CODE': param.DIV_CODE});
	                        }
	                    }
	                })},
			{dataIndex: 'ORDER_NUM'					, width: 116, hidden: true},
			{dataIndex: 'ORDER_SEQ'					, width: 66 , hidden: true},
			{dataIndex: 'REMARK'					, width: 133},
			{dataIndex: 'PROJECT_NO'				, width: 133},
			{dataIndex: 'SALE_DIV_CODE'				, width: 66 , hidden: true},
			{dataIndex: 'SALE_CUSTOM_CODE'			, width: 66 , hidden: true},
			{dataIndex: 'BILL_TYPE'					, width: 66 , hidden: true},
			{dataIndex: 'SALE_TYPE'					, width: 66 , hidden: true},
			{dataIndex: 'COMP_CODE'					, width: 66 , hidden: true},
			{dataIndex: 'ARRAY_OUTSTOCK_REQ_Q'		, width: 66 , hidden: true},
			{dataIndex: 'ARRAY_OUTSTOCK_Q'			, width: 66 , hidden: true},
			{dataIndex: 'ARRAY_REMARK'				, width: 66 , hidden: true},
			{dataIndex: 'ARRAY_PROJECT_NO'			, width: 66 , hidden: true},
			{dataIndex: 'ARRAY_LOT_NO'				, width: 66 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'			, width: 66 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'			, width: 66 , hidden: true}/*,
			//panelResult의 "REMARK" 값 임시 저장
			{dataIndex: 'REMARK_PANEL'				, width: 66 , hidden: true}*/
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, 'LOT_NO')){
					if(Ext.isEmpty(e.record.data.ITEM_CODE)){
						alert('<t:message code="system.message.purchase.message028" default="품목코드를 입력 하십시오."/>');
						return false;
					}
					if(Ext.isEmpty(e.record.data.WH_CODE) && BsaCodeInfo.gsManageLotNoYN == 'Y' ){
						alert('<t:message code="system.message.purchase.message015" default="출고창고를 입력하십시오."/>');
						return false;
					}
					if(BsaCodeInfo.gsSumTypeCell == 'Y' && Ext.isEmpty(e.record.data.WH_CELL_CODE)){
						alert('<t:message code="system.message.purchase.message016" default="출고창고 CELL코드를 입력하십시오."/>');
						return false;
					}
				}

				var sInoutmeth = e.record.data.INOUT_METH;
				if(e.record.phantom){
					if(sInoutmeth == '2'){
						if(panelResult.getValue('INOUT_CODE_TYPE') == '2'){
							if(e.field=='INOUT_TYPE_DETAIL') return false;
						}else{
							if(e.field=='INOUT_TYPE_DETAIL') return true;
						}

						if (UniUtils.indexOf(e.field,[
							'WH_CODE', 'WH_CELL_CODE', 'INOUT_Q', 'INOUT_CODE','INOUT_NAME1', 'INOUT_NAME2', 'ITEM_CODE', 'ITEM_NAME', 'ITEM_STATUS', 'INOUT_SEQ', 'LOT_NO', 'REMARK','PROJECT_NO', 'ORDER_NUM', 'ARRAY_REF_WKORD_NUM'])){
							return true;
						}else{
							return false;
						}
					}else{
						if(panelResult.getValue('INOUT_CODE_TYPE') == '2'){
							if(e.field=='INOUT_TYPE_DETAIL') return false;
						}else{
							if(e.field=='INOUT_TYPE_DETAIL') return true;
						}

						if (UniUtils.indexOf(e.field,[
							'INOUT_CODE','WH_CODE', 'WH_CELL_CODE', 'INOUT_METH','INOUT_Q', 'ITEM_STATUS', 'REMARK', 'ARRAY_REF_WKORD_NUM'])){
							return true;
						}

						if(BsaCodeInfo.gsManageLotNoYN == 'Y'){
							if(e.field == 'LOT_NO')	return true;
						}else{
							if(e.field == 'LOT_NO') return false;
						}

						if(e.field == 'PROJECT_NO') return true;

						return false;
					}
				}else{
					if(panelResult.getValue('INOUT_CODE_TYPE') == '2'){
						if(e.field=='INOUT_TYPE_DETAIL') return false;
					}else{
						if(e.field=='INOUT_TYPE_DETAIL') return true;
					}

					if (UniUtils.indexOf(e.field,[
						'INOUT_Q', 'ITEM_STATUS', 'INOUT_SEQ', 'REMARK'])){
						return true;
					}

					if(BsaCodeInfo.gsManageLotNoYN == 'Y') {
						if(e.field == 'LOT_NO')	return true;
					}else{
						if(e.field == 'LOT_NO') return false;
					}
					return false;
				}
			}, afterrender: function(grid) {
				UniAppManager.app.setHiddenColumn();
			}
		},
		setItemData: function(record, dataClear) {
			var grdRecord = this.getSelectedRecord();
			if(dataClear) {
				grdRecord.set('ITEM_CODE'	, "");
				grdRecord.set('ITEM_NAME'	, "");
				grdRecord.set('SPEC'		, "");
				grdRecord.set('STOCK_UNIT'	, "");
				grdRecord.set('LOT_NO'		, "");
				grdRecord.set('LOT_YN'		, "");
				grdRecord.set('GOOD_STOCK_Q', 0);
				grdRecord.set('BAD_STOCK_Q'	, 0);
				grdRecord.set('INOUT_P'		, 0);
				grdRecord.set('INOUT_I'		, 0);
			} else {
				grdRecord.set('ITEM_CODE'	, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'	, record['ITEM_NAME']);
				grdRecord.set('SPEC'		, record['SPEC']);
				grdRecord.set('STOCK_UNIT'	, record['STOCK_UNIT']);
				grdRecord.set('LOT_NO'		, record['LOT_NO']);
				grdRecord.set('LOT_YN'		, record['LOT_YN']);

				if(grdRecord.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){	//예외 출고 및 가용재고체크 사용할시
					UniMatrl.fnStockQ_kd(grdRecord, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, grdRecord.get('DIV_CODE'), UniDate.getDbDateStr(grdRecord.get('INOUT_DATE')), grdRecord.get('ITEM_CODE'));
				}
				UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'), grdRecord.get('WH_CODE'));
				//20190610 수량은 LOT의 수량을 넣기 위해서 위 함수에서 set하는 값 대신 팝업의 값 set
				grdRecord.set('GOOD_STOCK_Q'	, record['GOOD_STOCK_Q']);
				grdRecord.set('BAD_STOCK_Q'		, record['BAD_STOCK_Q']);
				grdRecord.set('INOUT_Q'			, record['GOOD_STOCK_Q']);
			}
		}
	});//End of var masterGrid = Unilite.createGrid('mtr210ukrvGrid1', {

	var releaseNoMasterGrid = Unilite.createGrid('mtr210ukrvReleaseNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
		// title: '기본',
		layout : 'fit',
		store: releaseNoMasterStore,
		uniOpt:{
					expandLastColumn: false,
					useRowNumberer: false
		},
		columns:  [
			{ dataIndex: 'WH_CODE'				,  width:120},
			{ dataIndex: 'WH_CELL_CODE'			,  width:120,hidden:true},
			{ dataIndex: 'WH_CELL_NAME'			,  width:120,hidden:true},
			{ dataIndex: 'INOUT_DATE'			,  width:93},
			{ dataIndex: 'INOUT_CODE_TYPE'		,  width:120},
			{ dataIndex: 'INOUT_CODE'			,  width:120,hidden:true},
			{ dataIndex: 'INOUT_NAME'			,  width:120},
			{ dataIndex: 'INOUT_PRSN' 			,  width:100},
			{ dataIndex: 'INOUT_NUM'			,  width:120},
			{ dataIndex: 'DIV_CODE' 			,  width:86},
			{ dataIndex: 'LOT_NO' 				,  width:86},
			{ dataIndex: 'PROJECT_NO' 			,  width:86},
			{ dataIndex: 'ITEM_CODE' 			,  width:100},
			{ dataIndex: 'ITEM_NAME' 			,  width:133},
			//20190605 필수 값인데 입력하는 부분 누락되어 추가
			{ dataIndex: 'INOUT_TYPE_DETAIL' 	,  width:133,hidden:true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				releaseNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record)	{
			if(Ext.isEmpty(record))	{
				record = this.getSelectedRecord();
			}
			panelResult.setValues({
				'DIV_CODE'			: record.get('DIV_CODE'),
				'INOUT_NUM'			: record.get('INOUT_NUM'),
				'INOUT_CODE_TYPE'	: record.get('INOUT_CODE_TYPE'),
				'WH_CODE'			: record.get('WH_CODE'),
				'WH_CELL_CODE'		: record.get('WH_CELL_CODE'),
				'INOUT_DATE'		: record.get('INOUT_DATE'),
				//20190605 필수 값인데 입력하는 부분 누락되어 추가
				'INOUT_TYPE_DETAIL'	: record.get('INOUT_TYPE_DETAIL')
			});
		}
	});



	function openSearchInfoWindow() {			// 조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.issuenosearch" default="출고번호검색"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [releaseNoSearch, releaseNoMasterGrid], //releaseNomasterGrid],
				tbar:  ['->',
					{
						itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							releaseNoMasterStore.loadStoreRecords();
						},
						disabled: false
					}, {
						itemId : 'ReleaseNoCloseBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						releaseNoSearch.clearForm();
						releaseNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						releaseNoSearch.clearForm();
						releaseNoMasterGrid.reset();
					},
					show: function( panel, eOpts )	{
						releaseNoSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
						releaseNoSearch.setValue('INOUT_CODE_TYPE',panelResult.getValue('INOUT_CODE_TYPE'));
							releaseNoSearch.setValue('FR_INOUT_DATE',UniDate.get('startOfMonth', panelResult.getValue('INOUT_DATE')));
							releaseNoSearch.setValue('TO_INOUT_DATE',panelResult.getValue('INOUT_DATE'));
				/*		releaseNoSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
						releaseNoSearch.setValue('ORDER_PRSN',panelResult.getValue('ORDER_PRSN'));
						releaseNoSearch.setValue('CUSTOM_CODE',panelResult.getValue('CUSTOM_CODE'));
						releaseNoSearch.setValue('CUSTOM_NAME',panelResult.getValue('CUSTOM_NAME'));
						releaseNoSearch.setValue('ORDER_TYPE',panelResult.getValue('ORDER_TYPE'));
						releaseNoSearch.setValue('FR_ORDER_DATE', UniDate.get('startOfMonth', panelResult.getValue('ORDER_DATE')));
						releaseNoSearch.setValue('TO_ORDER_DATE',panelResult.getValue('ORDER_DATE'));*/
					 }
				}
			})
		}
		SearchInfoWindow.show();
		SearchInfoWindow.center();
	}



	Unilite.Main({
		id			: 'mtr210ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		}],
		fnInitBinding: function(params) {
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			this.setDefault();
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);

				UniAppManager.setToolbarButtons(['deleteAll'], true);
			}			
		},
		processParams: function(params) {
			if(params.PGM_ID == 'pmp284ukrv') { 
				var formPram = params.formPram;
				panelResult.setValue('DIV_CODE'		, formPram.DIV_CODE);
				panelResult.setValue('INOUT_CODE_TYPE'	, '3');
				panelResult.setValue('INOUT_TYPE_DETAIL'	, '10');
				panelResult.setValue('INOUT_DATE'		, UniDate.get('today'));
				panelResult.setValue('WH_CODE'	, 'WS04');
//				panelResult.setValue('TREE_CODE'		, formPram.WORK_SHOP_CODE);

				var seq = directMasterStore1.max('INOUT_SEQ');
				
				Ext.each(params.record, function(rec,i){
					
					if(rec.get('SAVE_FLAG') =='Y'){
					
						if(!seq){
							 seq = 1;
						} else {
							 seq += 1;
						}
						
						var wkordNum        = rec.get('WKORD_NUM');
						var inoutType		= '2';
						var itemCode		= rec.get('ITEM_CODE');
						var itemName		= rec.get('ITEM_NAME');
						var inoutCodeType	= panelResult.getValue('INOUT_CODE_TYPE');
						var whCode			= panelResult.getValue('WH_CODE');
						var whCellCode		= panelResult.getValue('WH_CELL_CODE');
						var inoutDate		= panelResult.getValue('INOUT_DATE');
						var notQ			= '0';
						var goodStockQ		= '0';
						var badStockQ		= '0';
						var inoutQ			= rec.get('PRODT_Q');
						var inoutMeth		= '2';
						var divCode			= panelResult.getValue('DIV_CODE');
						var createLoc		= '2';
						var inoutPrsn		= panelResult.getValue('INOUT_PRSN');
						var itemStatus		= '1';
						var originalQ		= '0';
						var orderseq		= 0;
						var inoutTypeDetail	= panelResult.getValue('INOUT_TYPE_DETAIL');
						var saleDivCode		= '*';
						var saleCustomCode	= '*';
						var saleType		= '*';
						var billType		= '*';
						var compCode		= UserInfo.compCode;
						var moneyUnit		= UserInfo.currency;
			
						var inoutName		= panelResult.getValue('INOUT_CODE');
						var inoutName1		= rec.get('WORK_SHOP_CODE');
						var inoutName2		= panelResult.getValue('DEPT_CODE');
						var remark			= panelResult.getValue('REMARK');
						var inoutCode		= '';
						if(!Ext.isEmpty(inoutName)) {
							inoutCode	= inoutName;
			
						} else if(!Ext.isEmpty(inoutName1)) {
							inoutCode	= inoutName1;
			
						} else if(!Ext.isEmpty(inoutName2)) {
							inoutCode	= inoutName2;
						}
			
						var r = {
							INOUT_SEQ			: seq,
							INOUT_TYPE			: inoutType,
							INOUT_CODE_TYPE		: inoutCodeType,
							ITEM_CODE           : itemCode,
							ITEM_NAME           : itemName,
							WH_CODE				: whCode,
							WH_CELL_CODE		: whCellCode,
							INOUT_DATE			: inoutDate,
							NOT_Q				: notQ,
							GOOD_STOCK_Q		: goodStockQ,
							BAD_STOCK_Q			: badStockQ,
							INOUT_Q				: inoutQ,
							INOUT_METH			: inoutMeth,
							DIV_CODE			: divCode,
							CREATE_LOC			: createLoc,
							INOUT_PRSN			: inoutPrsn,
							ITEM_STATUS			: itemStatus,
							ORIGINAL_Q			: originalQ,
							INOUT_TYPE_DETAIL	: inoutTypeDetail,
							SALE_DIV_CODE		: saleDivCode,
							SALE_CUSTOM_CODE	: saleCustomCode,
							SALE_TYPE			: saleType,
							BILL_TYPE			: billType,
							COMP_CODE			: compCode,
							ORDER_SEQ			: orderseq,
							MONEY_UNIT			: moneyUnit,
							ARRAY_REF_WKORD_NUM : wkordNum,
			
							INOUT_CODE			: inoutCode,
							INOUT_NAME			: panelResult.getValue('INOUT_CODE'),
							INOUT_NAME1			: rec.get('WORK_SHOP_NAME'),
							INOUT_NAME2			: panelResult.getValue('DEPT_NAME'),
							REMARK				: remark
						};
						
						masterGrid.createRow(r, 'INOUT_SEQ');
				
					}
				});
			}
		},		
		onQueryButtonDown: function() {
			var inoutNo = panelResult.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow()
			} else {
				if(panelResult.setAllFieldsReadOnly(true) == false){
					return false;
				}
				if(panelResult.setAllFieldsReadOnly(true) == false){
					return false;
				}
				var whCode = panelResult.getValue('WH_CODE');
				directMasterStore1.loadStoreRecords();
			};
		},
		onNewDataButtonDown: function(isReff)	{
//			if(panelResult.getValue("INOUT_CODE_TYPE") == '2' && !isReff) {
//				 alert('<t:message code="system.message.purchase.message011" default="출고처구분이 창고일경우에는 참조만 가능합니다."/>');
//				 return false;
//			}
			if(BsaCodeInfo.gsAutoType == "N" && Ext.isEmpty(panelResult.getValue("OUTSTOCK_NUM"))){
				alert('<t:message code="system.message.purchase.message012" default="출고번호를 입력하십시오."/>');
				return false;
			}

			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			var inoutNum	= panelResult.getValue('INOUT_NUM');
			var seq			= directMasterStore1.max('INOUT_SEQ');
			if(!seq){
				seq = 1;
			}else{
				seq += 1;
			}
			var inoutType		= '2';
			var inoutCodeType	= panelResult.getValue('INOUT_CODE_TYPE');
			var whCode			= panelResult.getValue('WH_CODE');
			var whCellCode		= panelResult.getValue('WH_CELL_CODE');
			var inoutDate		= panelResult.getValue('INOUT_DATE');
			var notQ			= '0';
			var goodStockQ		= '0';
			var badStockQ		= '0';
			var inoutQ			= '0';
			var inoutMeth		= '2';
			var divCode			= panelResult.getValue('DIV_CODE');
			var createLoc		= '2';
			var inoutPrsn		= panelResult.getValue('INOUT_PRSN');
			var itemStatus		= '1';
			var originalQ		= '0';
			var orderseq		= 0;
			var inoutTypeDetail	= panelResult.getValue('INOUT_TYPE_DETAIL');
			var saleDivCode		= '*';
			var saleCustomCode	= '*';
			var saleType		= '*';
			var billType		= '*';
			var compCode		= UserInfo.compCode;
			var moneyUnit		= UserInfo.currency;

			var inoutName		= panelResult.getValue('INOUT_CODE');
			var inoutName1		= panelResult.getValue('TREE_CODE');
			var inoutName2		= panelResult.getValue('DEPT_CODE');
			var remark			= panelResult.getValue('REMARK');
			var inoutCode		= '';
			if(!Ext.isEmpty(inoutName)) {
				inoutCode	= inoutName;

			} else if(!Ext.isEmpty(inoutName1)) {
				inoutCode	= inoutName1;

			} else if(!Ext.isEmpty(inoutName2)) {
				inoutCode	= inoutName2;
			}

			var r = {
				INOUT_NUM			: inoutNum,
				INOUT_SEQ			: seq,
				INOUT_TYPE			: inoutType,
				INOUT_CODE_TYPE		: inoutCodeType,
				WH_CODE				: whCode,
				WH_CELL_CODE		: whCellCode,
				INOUT_DATE			: inoutDate,
				NOT_Q				: notQ,
				GOOD_STOCK_Q		: goodStockQ,
				BAD_STOCK_Q			: badStockQ,
				INOUT_Q				: inoutQ,
				INOUT_METH			: inoutMeth,
				DIV_CODE			: divCode,
				CREATE_LOC			: createLoc,
				INOUT_PRSN			: inoutPrsn,
				ITEM_STATUS			: itemStatus,
				ORIGINAL_Q			: originalQ,
				INOUT_TYPE_DETAIL	: inoutTypeDetail,
				SALE_DIV_CODE		: saleDivCode,
				SALE_CUSTOM_CODE	: saleCustomCode,
				SALE_TYPE			: saleType,
				BILL_TYPE			: billType,
				COMP_CODE			: compCode,
				ORDER_SEQ			: orderseq,
				MONEY_UNIT			: moneyUnit,

				INOUT_CODE			: inoutCode,
				INOUT_NAME			: panelResult.getValue('INOUT_CODE'),
				INOUT_NAME1			: panelResult.getValue('TREE_NAME'),
				INOUT_NAME2			: panelResult.getValue('DEPT_NAME'),
				REMARK				: remark
			};
			masterGrid.createRow(r);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
//			masterGrid.reset();
//			directMasterStore1.clearData();
			directMasterStore1.loadData({});
			this.fnInitBinding();
			panelResult.setValue('INOUT_CODE_TYPE',BsaCodeInfo.gsInoutCodeType);
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
			},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(Ext.isEmpty(selRow)){
				alert("한개 행열을 선택해 주십시오");
				return false;
			}else{
				if(selRow.phantom === true )	{
					masterGrid.deleteSelectedRow();
				}else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					if(selRow.get('ACCOUNT_Q') != 0)
					{
						alert('<t:message code="system.message.purchase.message042" default="매입등록된 자료는 삭제, 수정할 수 없습니다."/>');
					}else{
						masterGrid.deleteSelectedRow();
					}
				}
			}
		},
		//전체삭제
		onDeleteAllButtonDown: function() {
			var records = directMasterStore1.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{								//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('<t:message code="system.message.purchase.message008" default="전체삭제 하시겠습니까?"/>')) {		//모두 삭제 됩니다. 전체삭제 하시겠습니까?
						var deletable = true;
						if(deletable){
							masterGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
						isNewData = false;
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('INOUT_DATE',UniDate.get('today'));
//			panelResult.setValue('INOUT_DATE',UniDate.get('today'));
		},
		setHiddenColumn: function() {
			if(panelResult.getValue('INOUT_CODE_TYPE') == '3') {
				panelResult.down('#workShopP').setHidden(false);	//작업장
				panelResult.setValue('TREE_CODE','');
				panelResult.setValue('TREE_NAME','');
				panelResult.down('#inoutWh').setHidden(true);		//창고
				panelResult.setValue('INOUT_CODE','');
				panelResult.down('#deptP').setHidden(true);			//부서
				panelResult.setValue('DEPT_CODE','');
				panelResult.setValue('DEPT_NAME','');

				masterGrid.getColumn('INOUT_NAME').setVisible(false);
				masterGrid.getColumn('INOUT_NAME1').setVisible(true);
				masterGrid.getColumn('INOUT_NAME2').setVisible(false);

			} else if(panelResult.getValue('INOUT_CODE_TYPE') == '1'){
				panelResult.down('#workShopP').setHidden(true);		//작업장
				panelResult.setValue('TREE_CODE','');
				panelResult.setValue('TREE_NAME','');
				panelResult.down('#inoutWh').setHidden(true);		//창고
				panelResult.setValue('INOUT_CODE','');
				panelResult.down('#deptP').setHidden(false);		//부서
				panelResult.setValue('DEPT_CODE','');
				panelResult.setValue('DEPT_NAME','');

				masterGrid.getColumn('INOUT_NAME').setVisible(false);
				masterGrid.getColumn('INOUT_NAME1').setVisible(false);
				masterGrid.getColumn('INOUT_NAME2').setVisible(true);

			} else {
				panelResult.down('#workShopP').setHidden(true);		//작업장
				panelResult.setValue('TREE_CODE','');
				panelResult.setValue('TREE_NAME','');
				panelResult.down('#inoutWh').setHidden(false);		//창고
				panelResult.setValue('INOUT_CODE','');
				panelResult.down('#deptP').setHidden(true);			//부서
				panelResult.setValue('DEPT_CODE','');
				panelResult.setValue('DEPT_NAME','');

				masterGrid.getColumn('INOUT_NAME').setVisible(true);
				masterGrid.getColumn('INOUT_NAME1').setVisible(false);
				masterGrid.getColumn('INOUT_NAME2').setVisible(false);
			}
		},
		setHiddenField: function() {
			if(releaseNoSearch.getValue('INOUT_CODE_TYPE') == '3') {	//출고처구분 작업장
				releaseNoSearch.down('#workShopP').setHidden(false);//작업장
				releaseNoSearch.setValue('INOUT_CODE_WH','');
				releaseNoSearch.down('#inoutWh').setHidden(true);//창고
				releaseNoSearch.setValue('INOUT_CODE_DEPT','');
				releaseNoSearch.setValue('INOUT_NAME_DEPT','');
				releaseNoSearch.down('#deptP').setHidden(true);//부서
			} else if(releaseNoSearch.getValue('INOUT_CODE_TYPE') == '1'){	//출고처구분 부서
				releaseNoSearch.down('#deptP').setHidden(false);//부서

				releaseNoSearch.setValue('INOUT_CODE_WH','');
				releaseNoSearch.down('#inoutWh').setHidden(true);//창고
				releaseNoSearch.setValue('INOUT_CODE_WORK_SHOP','');
				releaseNoSearch.setValue('INOUT_NAME_WORK_SHOP','');
				releaseNoSearch.down('#workShopP').setHidden(true);//작업장

			} else if(releaseNoSearch.getValue('INOUT_CODE_TYPE') == '2'){	//출고처구분 창고
				releaseNoSearch.down('#inoutWh').setHidden(false);//창고

				releaseNoSearch.setValue('INOUT_CODE_WORK_SHOP','');
				releaseNoSearch.setValue('INOUT_NAME_WORK_SHOP','');
				releaseNoSearch.down('#workShopP').setHidden(true);//작업장
				releaseNoSearch.setValue('INOUT_CODE_DEPT','');
				releaseNoSearch.setValue('INOUT_NAME_DEPT','');
				releaseNoSearch.down('#deptP').setHidden(true);//부서
			} else {
				releaseNoSearch.setValue('INOUT_CODE_WORK_SHOP','');
				releaseNoSearch.setValue('INOUT_NAME_WORK_SHOP','');
				releaseNoSearch.down('#workShopP').setHidden(true);//작업장
				releaseNoSearch.setValue('INOUT_CODE_DEPT','');
				releaseNoSearch.setValue('INOUT_NAME_DEPT','');
				releaseNoSearch.down('#deptP').setHidden(true);//부서
				releaseNoSearch.setValue('INOUT_CODE_WH','');
				releaseNoSearch.down('#inoutWh').setHidden(true);//창고
			}
		},
		cbStockQ: function(provider, params) {
			var rtnRecord	= params.rtnRecord;
			var goodStockQ	= Unilite.nvl(provider['GOOD_STOCK_Q']	, 0);
			var badtockQ	= Unilite.nvl(provider['BAD_STOCK_Q']	, 0);
			var inoutP		= Unilite.nvl(provider['AVERAGE_P']		, 0);
			var inoutI		= Unilite.nvl(provider['AVERAGE_P']		, 0) * rtnRecord.get('INOUT_Q');
			//20190610 수량은 LOT의 수량을 넣기 위해서 주석
//			rtnRecord.set('GOOD_STOCK_Q', goodStockQ);
//			rtnRecord.set('BAD_STOCK_Q'	, badtockQ);
			rtnRecord.set('INOUT_P'		, inoutP);
			rtnRecord.set('INOUT_I'		, inoutI);
		},
		cbStockQ_kd: function(provider, params) {
			var rtnRecord = params.rtnRecord;
			var pabStockQ = Unilite.nvl(provider['PAB_STOCK_Q'], 0);//가용재고량
			rtnRecord.set('PAB_STOCK_Q', pabStockQ);
		}
	});//End of Unilite.Main( {



	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "INOUT_TYPE_DETAIL":
					var param = {"INOUT_TYPE_DETAIL": newValue};
					mtr210ukrvService.selectInoutType(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
							record.set('INOUT_TYPE','3');
						}else{
							record.set('INOUT_TYPE','2');
						}
					});
					break;

				case "INOUT_SEQ":
					if(newValue <= '0'){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
					}else if(clng(grdsheet1.TextMatrix(lRow,lCol)) != fnCDbl(grdsheet1.TextMatrix(lRow,lCol))){ //?
						rv='<t:message code="system.message.purchase.message072" default="정수만 입력 가능합니다."/>';
					}
					break;

				case "WH_CODE" :
					if(!Ext.isEmpty(newValue)){
						record.set('WH_CODE', e.column.field.getRawValue());
						record.set('WH_CELL_CODE', "");
						record.set('WH_CELL_NAME', "");
						record.set('LOT_NO', "");
					}else{
						record.set('WH_CODE', "");
						record.set('WH_CELL_CODE', "");
						record.set('WH_CELL_NAME', "");
						record.set('LOT_NO', "");
					}
					if(!Ext.isEmpty(record.get('ITEM_CODE'))){
						if(record.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){	//예외 출고 및 가용재고체크 사용할시
							UniMatrl.fnStockQ_kd(record, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, record.get('DIV_CODE'), UniDate.getDbDateStr(record.get('INOUT_DATE')), record.get('ITEM_CODE'));
						}
						UniMatrl.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('DIV_CODE'), null, record.get('ITEM_CODE'), newValue );
					}
					//그리드 창고cell콤보 reLoad..
	//				cbStore.loadStoreRecords(newValue);
	//				UniAppManager.setToolbarButtons('save', true);
					break;

				case "WH_CELL_CODE" :
					record.set('WH_CELL_CODE', e.column.field.getRawValue());
					break;

					//추가

					if(record.get('CREATE_LOC') != '3'){
						if(newValue > 0 && record.get('BASIS_NUM') > ''){	// ''보다 크면??
							if(record.get('INOUT_Q') > (record.get('ORIGINAL_Q') + record.get('NOT_Q'))){
								rv='<t:message code="unilite.msg.sMM337"/>';
							}
						}
					}
				case "INOUT_Q" :
					/*if(newValue < 0 && !Ext.isEmpty(newValue))  {
						rv=Msg.sMB076;
						break;
					}*/
					if(record.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){	//예외 출고 및 가용재고체크 사용할시
						var sInout_q = newValue;	//출고량
						var sInv_q = record.get('PAB_STOCK_Q'); //가용재고량
						var sOriginQ = record.get('ORIGINAL_Q'); //출고량(원)
						if(sInout_q > (sInv_q + sOriginQ)){
							rv='<t:message code="system.message.purchase.message014" default="출고량은 가용재고량을 초과할 수 없습니다."/>';  //출고량은 재고량을 초과할 수 없습니다.
							break;
						}
					}
					if(isCheckStockYn){	//예외 출고 및 가용재고체크 사용할시
						var sInout_q = newValue;	//출고량
						var sInv_q = record.get('ITEM_STATUS') == "1"? record.get('GOOD_STOCK_Q') : record.get('BAD_STOCK_Q');  //재고량
						var sOriginQ = record.get('ORIGINAL_Q'); //출고량(원)

						if(sInout_q > (sInv_q + sOriginQ)){
							rv='<t:message code="system.message.purchase.message036" default="출고량은 재고량을 초과할 수 없습니다."/>';  //출고량은 재고량을 초과할 수 없습니다.
							break;
						}
					}
					break;
					//추가
			}
			return rv;
		}
	});
};
</script>