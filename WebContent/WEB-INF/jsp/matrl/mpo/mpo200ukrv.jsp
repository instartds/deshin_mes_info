<%--
'   프로그램명 : 구매오더조정 및 확정 (구매)
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'   최종수정자 :
'   최종수정일 :
'   버	  전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo200ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="mpo200ukrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P401"/>			<!-- 확정여부 -->
	<t:ExtComboStore comboType="AU" comboCode="M001"/>			<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201"/>			<!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>			<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B014"/>			<!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B019"/>			<!-- 국내외구분 -->
	<t:ExtComboStore comboType="AU" comboCode="M301"/>			<!-- 단가구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>			<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="Q032"/>			<!-- 검사여부 -->
	<t:ExtComboStore comboType="AU" comboCode="M002"/>			<!-- 진행상태 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/><!-- 창고 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="MPO200ukrvLevel1Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="MPO200ukrvLevel2Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="MPO200ukrvLevel3Store"/>
</t:appConfig>
<script type="text/javascript" >
var referPurchaseWindow;	//구매요청참조
var BsaCodeInfo = {
	gsApproveYN	: '${gsApproveYN}',
	gsExchgRegYN: '${gsExchgRegYN}'
};
var CustomCodeInfo = {
	gsUnderCalBase: ''
};
var isExchgReg = false;
if(BsaCodeInfo.gsExchgRegYN =='Y') {
	isExchgReg = true;
}
var outDivCode = UserInfo.divCode;
var excelWindow;	// 엑셀참조
var gsSyncFlag = false;

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'mpo200ukrvService.gridDown'/*,
			update	: 'mpo200ukrvService.updateDetail',
			syncAll	: 'mpo200ukrvService.orderConfirm'*/
		}
	});

	var adjustProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'mpo200ukrvService.selectAdjustList',
			create	: 'mpo200ukrvService.insertAdjust',
			update	: 'mpo200ukrvService.updateAdjust',
			destroy	: 'mpo200ukrvService.deleteAdjust',
			syncAll	: 'mpo200ukrvService.saveAll'
		}
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Mpo200ukrvModel', {
		fields: [
			{name: 'CHK'				,text: 'CHK'			,type: 'string'},
			{name: 'CONFIRM_YN'			,text: '<t:message code="system.label.purchase.confirmedpending" default="확정여부"/>'			,type: 'string'},
			{name: 'COMP_CODE'			,text: 'COMP_CODE'		,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'					,type: 'string',comboType:'BOR120'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.custom" default="거래처"/>'						,type: 'string', allowBlank: false},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'				,type: 'string', allowBlank: false},
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.purchase.podate" default="발주일"/>'						,type: 'uniDate', allowBlank: false},
			{name: 'ORDER_PLAN_DATE'	,text: '<t:message code="system.label.purchase.poreservedate" default="발주예정일"/>'			,type: 'uniDate'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						,type: 'string'},
			{name: 'SUPPLY_TYPE'		,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'	,type: 'string',comboType:'AU', comboCode:'B014'},
			{name: 'ORDER_TYPE'			,text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					,type: 'string',comboType:'AU', comboCode:'M001'},
			{name: 'ORDER_PRSN'			,text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'			,type: 'string',comboType:'AU', comboCode:'M201', allowBlank: false},
			{name: 'ORDER_PRSN1'		,text: '<t:message code="system.label.purchase.charger" default="담당자"/>'					,type: 'string'},
			{name: 'AGREE_PRSN'			,text: '<t:message code="system.label.purchase.approvaluser" default="승인자"/>'				,type: 'string'},
			{name: 'AGREE_NAME'			,text: '<t:message code="system.label.purchase.approvalusername" default="승인자명"/>'			,type: 'string'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.purchase.currency" default="화폐"/>'					,type: 'string',comboType:'AU', comboCode:'B004', displayField: 'value'},
			{name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				,type: 'uniER'},
			{name: 'RECEIPT_TYPE'		,text: '<t:message code="system.label.purchase.payingmethod" default="결제방법"/>'			,type: 'string',comboType:'AU', comboCode:'B038', allowBlank: false},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		  ,type: 'string'},
			{name: 'ORDER_O'			,text: '<t:message code="system.label.purchase.poamount" default="발주금액"/>'			,type: 'string'},
			{name: 'AGREE_STATUS'		,text: '<t:message code="system.label.purchase.approvalstatus" default="승인상태"/>'			,type: 'string',comboType:'AU', comboCode:'M007'},
			{name: 'CHECKTYPE'			,text: '<t:message code="system.label.purchase.checktype" default="체크상태"/>'			,type: 'string'},
			{name: 'CHECKSEQ'			,text: '<t:message code="system.label.purchase.checkseq" default="체크순번"/>'			,type: 'int'},
			{name: 'REMARK'				,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			  ,type: 'string'},
			{name: 'ORDER_REQ_PRSN'		,text: 'ORDER_REQ_PRSN'	,type: 'string'}
		]
	});

	Unilite.defineModel('Mpo200ukrvModel2', {
		fields: [
			{name: 'CHK'				,text: '<t:message code="system.label.purchase.selection" default="선택"/>'					,type: 'string'},
			{name: 'COMP_CODE'			,text: 'COMP_CODE'		,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'					,type: 'string'},
			{name: 'IN_DIV_CODE'		,text: '입고사업장'			 ,type: 'string',comboType:'BOR120',child:'WH_CODE'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.custom" default="거래처"/>'						,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'						,type: 'string'},
			{name: 'ORDER_SEQ'			,text: '<t:message code="system.label.purchase.seq" default="순번"/>'							,type: 'int'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'						,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'				,type: 'string',comboType:'AU', comboCode:'B013', displayField: 'value'},
			{name: 'ORDER_UNIT_Q'		,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'						,type: 'uniQty', allowBlank: false},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				,type: 'string' ,comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank: false},
			{name: 'UNIT_PRICE_TYPE'	,text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'					,type: 'string',comboType:'AU', comboCode:'M301', allowBlank: false},
			{name: 'ORDER_UNIT_P'		,text: '<t:message code="system.label.purchase.price" default="단가"/>'						,type: 'uniUnitPrice'},
			{name: 'ORDER_O'			,text: '<t:message code="system.label.purchase.amount" default="금액"/>'						,type: 'uniPrice'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				,type: 'uniDate', allowBlank: false},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>'			,type: 'string', allowBlank: false, store: Ext.data.StoreManager.lookup('whList')},
			{name: 'INSPEC_YN'			,text: '<t:message code="system.label.purchase.qualityyn" default="품질대상여부"/>'				,type: 'string',comboType:'AU', comboCode:'Q032'},
			{name: 'TRNS_RATE'			,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'				,type: 'float', decimalPrecision: 4, format:'0,000.0000'},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.purchase.inventoryunitqty" default="재고단위량"/>'			,type: 'uniQty'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'				,type: 'string'},
			{name: 'ORDER_P'			,text: '<t:message code="system.label.purchase.inventoryprice" default="재고단가"/>'			,type: 'uniPrice'},
			{name: 'CONTROL_STATUS'		,text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'				,type: 'string',comboType:'AU', comboCode:'M002'},
			{name: 'ORDER_REQ_NUM'		,text: '<t:message code="system.label.purchase.poreserveno" default="발주예정번호"/>'				,type: 'string'},
			{name: 'PURCH_LDTIME'		,text: '<t:message code="system.label.purchase.ldtime" default="리드타임"/>'					,type: 'string'},
			{name: 'BASIS_DATE'			,text: '<t:message code="system.label.purchase.basisdate" default="기준일"/>'					,type: 'string'},
			{name: 'CREATE_DATE'		,text: '<t:message code="system.label.purchase.creationdate" default="생성일"/>'				,type: 'uniDate'},
			{name: 'ORDER_PLAN_DATE'	,text: '<t:message code="system.label.purchase.podate" default="발주일"/>'						,type: 'uniDate'},
			{name: 'SUPPLY_TYPE'		,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'	,type: 'string'},
			{name: 'CHECKSEQ'			,text: '<t:message code="system.label.purchase.checkseq" default="체크순번"/>'					,type: 'int'},
			{name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER'	,type: 'string'},
			{name: 'UPDATE_DB_TIME'		,text: 'UPDATE_DB_TIME'	,type: 'string'},
			{name: 'ORDER_PRSN'			,text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'			,type: 'string'},
			{name: 'LOT_NO'				,text: 'LOT NO'			 ,type: 'string'},
			{name: 'SO_NUM'				,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'						,type: 'string'},
			{name: 'SO_SEQ'				,text: '<t:message code="system.label.purchase.soseq" default="수주순번"/>'						,type: 'int'},
			//마스터 정보
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.purchase.podate" default="발주일"/>'						,type: 'uniDate'},
			{name: 'ORDER_TYPE'			,text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					,type: 'string'},
			{name: 'ORDER_PRSN1'		,text: '<t:message code="system.label.purchase.charger" default="담당자"/>'					,type: 'string'},
			{name: 'AGREE_PRSN'			,text: '<t:message code="system.label.purchase.approvaluser" default="승인자"/>'				,type: 'string'},
			{name: 'AGREE_NAME'			,text: '<t:message code="system.label.purchase.approvalusername" default="승인자명"/>'			,type: 'string'},
			{name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				,type: 'uniER'},
			{name: 'AGREE_STATUS'		,text: '<t:message code="system.label.purchase.approvalstatus" default="승인상태"/>'			,type: 'string',comboType:'AU', comboCode:'M007'},
			{name: 'RECEIPT_TYPE'		,text: '<t:message code="system.label.purchase.payingmethod" default="결제방법"/>'				,type: 'string',comboType:'AU', comboCode:'B038'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'						,type: 'string'},
			{name: 'CHECKTYPE'			,text: '<t:message code="system.label.purchase.checktype" default="체크상태"/>'					,type: 'string'},
			{name: 'OUT_DATE'			,text: '<t:message code="system.label.purchase.issuedate" default="출고일"/>'					,type: 'uniDate'},
			{name: 'OUT_DIV_CODE'		,text: '<t:message code="system.label.purchase.outdivcode" default="출고사업장"/>'				,type: 'string' ,comboType:'BOR120'}
		]
	});

	Unilite.defineModel('Mpo200ukrvModel3', {	//구매요청정보조정
		fields: [
			{name: 'COMP_CODE'				,text: 'COMP_CODE'		,type: 'string'},
			{name: 'DIV_CODE'				,text: '<t:message code="system.label.purchase.division" default="사업장"/>'					,type: 'string'},
			{name: 'IN_DIV_CODE'			,text: '입고사업장'			,type: 'string',comboType:'BOR120'},
			{name: 'ORDER_PLAN_DATE'		,text: '<t:message code="system.label.purchase.poreservedate" default="발주예정일"/>'			,type: 'uniDate'},
			{name: 'DVRY_DATE'				,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				,type: 'uniDate'},
			{name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'				,type: 'string'},
			{name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.purchase.custom" default="거래처"/>'						,type: 'string'},
			{name: 'PROD_ITEM_CODE'			,text: '제품코드'			,type: 'string'},
			{name: 'PROD_ITEM_NAME'			,text: '제품명'			,type: 'string'},
			{name: 'ITEM_CODE'				,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					,type: 'string'},
			{name: 'ITEM_NAME'				,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'					,type: 'string'},
			{name: 'SPEC'					,text: '<t:message code="system.label.purchase.spec" default="규격"/>'						,type: 'string'},
			{name: 'ORDER_PLAN_Q'			,text: '<t:message code="system.label.purchase.purchaseplannedqty" default="발주예정량"/>'		,type : 'float', decimalPrecision:2, format:'0,000.00'},
			{name: 'ORDER_UNIT'				,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				,type: 'string',comboType:'AU', comboCode:'B013', displayField: 'value'},
			{name: 'BASIS_DATE'				,text: '<t:message code="system.label.purchase.productionstartdate" default="생산시작일"/>'		,type: 'uniDate'},
			{name: 'REQ_PLAN_Q'				,text: '<t:message code="system.label.purchase.requestqty" default="요청량"/>'					,type: 'uniQty'},
			{name: 'SUPPLY_TYPE'			,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'	,type: 'string',comboType:'AU', comboCode:'B014'},
			{name: 'PAB_STOCK_Q'			,text: '<t:message code="system.label.purchase.availableinventoryqty" default="가용재고량"/>'	,type: 'string'},
			{name: 'EXCHG_EXIST_YN'			,text: '<t:message code="system.label.purchase.subitemexistyn" default="대체품존재여부"/>'			,type: 'string'},
			{name: 'REF_ITEM_CODE'			,text: '<t:message code="system.label.purchase.subbeforeitemcode" default="대체전품목코드"/>'		,type: 'string'},
			{name: 'REF_ITEM_NAME'			,text: '<t:message code="system.label.purchase.subbeforeitemname" default="대체전품목명"/>'		,type: 'string'},
			{name: 'EXCHG_YN'				,text: '<t:message code="system.label.purchase.subyn" default="대체여부"/>'						,type: 'string'},
			{name: 'DOM_FORIGN'				,text: '<t:message code="system.label.purchase.domesticoverseasclass" default="국내외구분"/>'	,type: 'string',comboType:'AU', comboCode:'B019'},
			{name: 'ORDER_REQ_DEPT_CODE'	,text: '<t:message code="system.label.purchase.requestdepartment" default="요청부서"/>'			,type: 'string'},
			{name: 'ORDER_PRSN'				,text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'			,type: 'string',comboType:'AU', comboCode:'M201'},
			{name: 'ORDER_YN'				,text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'				,type: 'string',comboType:'AU', comboCode:'M002'},
			{name: 'ORDER_NUM'				,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'						,type: 'string'},
			{name: 'ORDER_SEQ'				,text: '<t:message code="system.label.purchase.soseq" default="수주순번"/>'						,type: 'int'},
			{name: 'ORDER_REQ_NUM'			,text: '<t:message code="system.label.purchase.requestno" default="요청번호"/>'					,type: 'string'},
			{name: 'MRP_CONTROL_NUM'		,text: '<t:message code="system.label.purchase.grgiplanno" default="수급계획번호"/>'				,type: 'string'},
			{name: 'WKORD_NUM'				,text: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>'				,type: 'string'},
			{name: 'ITEM_ACCOUNT'			,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				,type: 'string'},
			{name: 'PURCH_LDTIME'			,text: '<t:message code="system.label.purchase.purchaseldtime" default="구매리드타임"/>'			,type: 'string'},
			{name: 'CREATE_DATE'			,text: '<t:message code="system.label.purchase.requestdate" default="요청일"/>'				,type: 'uniDate'},
			{name: 'MRP_YN'					,text: '<t:message code="system.label.purchase.reqtype" default="소요량구분"/>'					,type: 'string'},
			{name: 'LOT_NO'					,text: 'LOT NO'			,type: 'string'},
			{name: 'REMARK'					,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'						,type: 'string'},
			{name: 'PROJECT_NO'				,text: '<t:message code="system.label.purchase.manageno" default="관리번호"/>'					,type: 'string'}
		]
	});



	/* 20200713 - 구매오더확정 관련로직 추가
	 */
	var buttonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'mpo200ukrvService.insertDetail',
			syncAll	: 'mpo200ukrvService.orderConfirm'
		}
	});

	var buttonStore = Unilite.createStore('orderConfirmButtonStore',{
		uniOpt: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy		: buttonProxy,
		saveStore	: function() {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();

			var paramMaster = panelResult.getValues();

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success : function(batch, option) {
						Ext.getCmp('mpo200ukrvApp').unmask();
						buttonStore.clearData();
						directMasterStore1.loadStoreRecords();
						directMasterStore2.loadStoreRecords();
					},
					failure: function(batch, option) {
						Ext.getCmp('mpo200ukrvApp').unmask();
						buttonStore.clearData();
					}
				};
				this.syncAllDirect(config);
			} else {
				var invalidRec	= Ext.isArray(inValidRecs) ? inValidRecs[0] : inValidRecs;
				var errColumn	= invalidRec.validate().items[0].field
				var errMsg		= masterGrid2.getColumn(errColumn).text + '<t:message code="system.label.purchase.required" default="은(는) 필수입력 사항입니다."/>';
				Unilite.messageBox(errMsg);
//				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
				Ext.getCmp('mpo200ukrvApp').unmask();
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



	// 엑셀참조
	Unilite.Excel.defineModel('excel.mpo200.sheet01', {
		fields: [
			{name: 'CUSTOM_CODE'		,text: '거래처'	,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '거래처명'	,type: 'string'},
			{name: 'ITEM_CODE'			,text: '품목코드'	,type: 'string'},
			{name: 'ITEM_NAME'			,text: '품목명'	,type: 'string'},
			{name: 'ORDER_PLAN_Q'		,text: '발주예정량'	,type: 'uniQty'},
			{name: 'ORDER_PLAN_DATE'	,text: '발주예정일'	,type: 'uniDate'},
			{name: 'DVRY_DATE'			,text: '납기일'	,type: 'uniDate'}
		]
	});

	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';

		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.DIV_CODE = panelResult.getValue('DIV_CODE');
		}
		if(!excelWindow) {
			excelWindow =  Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				modal: false,
				excelConfigName: 'mpo200ukrv',
				extParam: {
					'PGM_ID': 'mpo200ukrv',
					'DIV_CODE': panelResult.getValue('DIV_CODE')
				},
				grids: [{
					itemId: 'grid01',
					title: '구매요청정보엑셀참조',
					useCheckbox: true,
					model: 'excel.mpo200.sheet01',
					readApi: 'mpo200ukrvService.selectExcelUploadSheet1',
					columns: [
						{dataIndex: 'CUSTOM_CODE'		,width: 100},
						{dataIndex: 'CUSTOM_NAME'		,width: 200},
						{dataIndex: 'ITEM_CODE'			,width: 100},
						{dataIndex: 'ITEM_NAME'			,width: 250},
						{dataIndex: 'ORDER_PLAN_Q'		,width: 100},
						{dataIndex: 'ORDER_PLAN_DATE'	,width: 100},
						{dataIndex: 'DVRY_DATE'			,width: 100}
					]
				}],
				listeners: {
					close: function() {
						this.hide();
					}
				},
				onApply:function() {
					adjustGrid.reset();
					adjustStore.clearData();
					var grid = this.down('#grid01');
					var records = grid.getSelectionModel().getSelection();
					Ext.each(records, function(record,i){
						if(!panelResult.getInvalidMessage()) return false;   //필수체크
						var r = {
							DIV_CODE: panelResult.getValue('DIV_CODE')
						};
						adjustGrid.createRow(r);
						adjustGrid.setExcelData(record.data);
					});
					grid.getStore().removeAll();
					this.hide();
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	}



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mpo200ukrvMasterStore1',{
		model	: 'Mpo200ukrvModel',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {
				read: 'mpo200ukrvService.gridUp'
			}
		},
		loadStoreRecords: function() {
			var param		= panelResult.getValues();
			var authoInfo	= pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;	//부서코드
			if(authoInfo	== "5" && Ext.isEmpty(panelResult.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log(param);
			this.load({
				params : param
			});
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

	var directMasterStore2 = Unilite.createStore('mpo200ukrvMasterStore2', {
		model	: 'Mpo200ukrvModel2',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(record){
			//20200709 추가
			var param		= panelResult.getValues();
			var authoInfo	= pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelResult.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log(param);
			this.load({
				params : param
			});
		},
/*		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						masterGrid2.deleteSelectedRow();
						if(directMasterStore2.count() == 0){
							directMasterStore1.loadStoreRecords();
						}else{
							var record = masterGrid.getSelectedRecord();
							directMasterStore2.loadData({});
							if(!record.phantom){
								directMasterStore2.loadStoreRecords(record);
							}
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},*/
		listeners: {
			load: function(store, records, successful, eOpts) {
				var masterSelectedRecord = masterGrid.getSelectedRecord();
				if(Ext.isEmpty(masterSelectedRecord)) {
					directMasterStore2.filterBy(function(record){
						return record.get('CUSTOM_CODE') == '' && record.get('ORDER_PLAN_DATE') == '';
					})
				} else {
					directMasterStore2.filterBy(function(record){
						return record.get('CUSTOM_CODE') == selected[selected.length - 1].get('CUSTOM_CODE') && UniDate.getDbDateStr(record.get('ORDER_PLAN_DATE')) == UniDate.getDbDateStr(selected[selected.length - 1].get('ORDER_PLAN_DATE'));
					})
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

	var adjustStore = Unilite.createStore('mpo200ukrvadjustStore', {
		model: 'Mpo200ukrvModel3',
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
			autoLoad: false,
			proxy: adjustProxy,
		loadStoreRecords: function(){
			var param = panelResult.getValues();
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

			var paramMaster= panelResult.getValues();   //syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();

						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();

						UniAppManager.setToolbarButtons('save', false);

						adjustStore.loadStoreRecords();

					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('mpo200ukrvGrid');
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

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			value: UserInfo.divCode
		},{
			fieldLabel: '<t:message code="system.label.purchase.poreservedate" default="발주예정일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_FR_DATE',
			endFieldName: 'ORDER_TO_DATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},{
			fieldLabel: '<t:message code="system.label.purchase.domesticoverseasclass" default="국내외구분"/>',
			name: 'DOM_FORIGN',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B019'
		},{
			width: 100,
			xtype: 'button',
			text: '<t:message code="system.label.purchase.purchaseconfirm" default="구매오더확정"/>',
			margin: '0 0 0 95',
			id: 'btnConfirm',
			handler : function() {
				var detailSelectedRecs	= masterGrid2.getSelectedRecords();
				if(detailSelectedRecs.length == 0) return false;

				if(confirm('<t:message code="system.message.purchase.message056" default="확정 하시겠습니까?"/>')){
					Ext.getCmp('mpo200ukrvApp').mask('<t:message code="system.message.human.message010" default="저장중..."/>','loading-indicator');

					var selRecords = masterGrid2.getSelectionModel().getSelection();
					Ext.each(selRecords, function(selRecord, index) {
						if(selRecord.get('SAVE_FLAG') == 'Y') {
							selRecord.phantom = true;
							buttonStore.insert(index, selRecord);
						}
						if(selRecords.length == index + 1) {
							buttonStore.saveStore();
						}
					})
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>',
			name: 'SUPPLY_TYPE',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B014'
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelResult.setValue('CUSTOM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelResult.setValue('CUSTOM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_CODE', '');
							}
						},
			            applyextparam: function(popup){
			                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
			                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
			            	}
				}
		}),{
			xtype: 'uniTextfield',
			fieldLabel: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>',
			name: 'LOT_NO',
			colspan:2
		},{
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name: 'ORDER_PRSN',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'M201'
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
							}
						},
					applyextparam: function(popup){	// 2021.08 표준화 작업
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
		}),{
			fieldLabel: '품목계정',
			name: 'ITEM_ACCOUNT',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B020',
			colspan:2
		}]
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid= Unilite.createGrid('mpo200ukrvGrid', {
		store		: directMasterStore1,
		region		: 'center' ,
		layout		: 'fit',
		excelTitle	: '<t:message code="system.label.purchase.purchaserordercontrol" default="구매오더조정/확정"/>',
		selModel	: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true,
			listeners: {
				beforeselect : function( me, record, index, eOpts ){
					if(Ext.isEmpty(record.get('ORDER_PRSN'))) {
						Unilite.messageBox('<t:message code="system.message.purchase.message057" default="구매담당은 필수 입니다."/>');
						return false;
					}
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if(!gsSyncFlag) {
						directMasterStore2.clearFilter();
						var detailGrids	= directMasterStore2.data.items;
						var needSelect	= masterGrid2.getSelectionModel().getSelection();
						Ext.each(detailGrids, function(detailGrid, i) {
							if(detailGrid.get('CUSTOM_CODE') == selectRecord.get('CUSTOM_CODE')
							&& UniDate.getDbDateStr(detailGrid.get('ORDER_PLAN_DATE')) == UniDate.getDbDateStr(selectRecord.get('ORDER_PLAN_DATE'))) {
								needSelect.push(detailGrid);
								detailGrid.set('ORDER_DATE'		, selectRecord.get('ORDER_DATE'));
								detailGrid.set('ORDER_TYPE'		, selectRecord.get('ORDER_TYPE'));
								detailGrid.set('ORDER_PRSN1'	, selectRecord.get('ORDER_PRSN'));
								detailGrid.set('AGREE_PRSN'		, selectRecord.get('AGREE_PRSN'));
								detailGrid.set('AGREE_NAME'		, selectRecord.get('AGREE_NAME'));
								detailGrid.set('EXCHG_RATE_O'	, selectRecord.get('EXCHG_RATE_O'));
								detailGrid.set('AGREE_STATUS'	, selectRecord.get('AGREE_STATUS'));
								detailGrid.set('CHECKTYPE'		, selectRecord.get('CHECKTYPE'));
								detailGrid.set('OUT_DIV_CODE'	, panelResult.getValue('DIV_CODE'));
								detailGrid.set('SAVE_FLAG'		, 'Y');
							}
						});
						gsSyncFlag = true;
						masterGrid2.getSelectionModel().select(needSelect);
						directMasterStore2.filterBy(function(record){
							return record.get('CUSTOM_CODE') == selectRecord.get('CUSTOM_CODE') && UniDate.getDbDateStr(record.get('ORDER_PLAN_DATE')) == UniDate.getDbDateStr(selectRecord.get('ORDER_PLAN_DATE'));
						})
						gsSyncFlag = false;
					}
				},
				beforedeselect: function(grid, selectRecord, index, rowIndex, eOpts) {
				},
				deselect: function(grid, selectRecord, index, rowIndex, eOpts ){
					directMasterStore2.clearFilter();
					var detailGrids = directMasterStore2.data.items;
					Ext.each(detailGrids, function(detailGrid, i) {
						if(detailGrid.get('CUSTOM_CODE') == selectRecord.get('CUSTOM_CODE')
						&& UniDate.getDbDateStr(detailGrid.get('ORDER_PLAN_DATE')) == UniDate.getDbDateStr(selectRecord.get('ORDER_PLAN_DATE'))) {
							masterGrid2.getSelectionModel().deselect(detailGrid);
							detailGrid.set('SAVE_FLAG', '');
						}
					});
					directMasterStore2.filterBy(function(record){
						return record.get('CUSTOM_CODE') == selectRecord.get('CUSTOM_CODE') && UniDate.getDbDateStr(record.get('ORDER_PLAN_DATE')) == UniDate.getDbDateStr(selectRecord.get('ORDER_PLAN_DATE'));
					})
				}
			}
		}),
		uniOpt: {
			allowDeselect : false,
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			onLoadSelectFirst : false,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns: [
			{dataIndex:'CONFIRM_YN'			, width: 100, hidden: true },
			{dataIndex:'COMP_CODE'			, width: 100, hidden: true },
			{dataIndex:'DIV_CODE'			, width: 100, hidden: true },
			{dataIndex:'CUSTOM_CODE'		, width: 100 },
			{dataIndex:'CUSTOM_NAME'		, width: 160 },
			{dataIndex:'ORDER_DATE'			, width: 100 },
			{dataIndex:'ORDER_PLAN_DATE'	, width: 100 },
			{dataIndex:'ORDER_NUM'			, width: 120, hidden: true },
			{dataIndex:'SUPPLY_TYPE'		, width: 100, hidden: true },
			{dataIndex:'ORDER_TYPE'			, width: 80, align:'center' },
			{dataIndex:'ORDER_PRSN'			, width: 100, align:'center' },
			{dataIndex:'ORDER_PRSN1'		, width: 100, hidden: true },
			{dataIndex:'AGREE_PRSN'			, width: 100, hidden: true },
			{dataIndex: 'AGREE_NAME'		, width: 100, align:'center',
				'editor' : Unilite.popup('USER_G',{
						DBtextFieldName: 'USER_NAME',
						autoPopup: true,
						listeners: {
							'onSelected': {
								fn: function(records, type) {
									grdRecord = masterGrid.uniOpt.currentRecord;
									record = records[0];
									grdRecord.set('AGREE_PRSN', record.USER_ID);
									grdRecord.set('AGREE_NAME', record.USER_NAME);
									var detailSelectedRecs = masterGrid2.getSelectedRecords();
									Ext.each(detailSelectedRecs, function(rec, i){
										rec.set('AGREE_PRSN', record.USER_ID);
										rec.set('AGREE_NAME', record.USER_NAME);
									});
								},
								scope: this
							},
							'onClear': function(type) {
								grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('AGREE_PRSN', '');
								grdRecord.set('AGREE_NAME', '');
								var detailSelectedRecs = masterGrid2.getSelectedRecords();
								Ext.each(detailSelectedRecs, function(rec, i){
									rec.set('AGREE_PRSN', '');
									rec.set('AGREE_NAME', '');
								});
							}/*,
							applyextparam: function(popup){
								grdRecord = Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord();
								popup.setExtParam({'ALLOW_TAG'  : grdRecord.data.ALLOW_TAG});
							}*/
						}
					})
			  },
//			{dataIndex:'AGREE_NAME'			, width: 100 },
			{dataIndex:'MONEY_UNIT'			, width: 66, align:'center' },
			{dataIndex:'EXCHG_RATE_O'		, width: 66, align:'center' },
			{dataIndex:'RECEIPT_TYPE'		, width: 100 , align:'center'},
			{dataIndex:'ORDER_O'			, width: 100, hidden: true },
			{dataIndex:'AGREE_STATUS'		, width: 100 , align:'center' },
			{dataIndex:'PROJECT_NO'			, width: 100},
			{dataIndex:'CHECKTYPE'			, width: 100, hidden: true },
			{dataIndex:'CHECKSEQ'			, width: 100, hidden: true },
			{dataIndex:'REMARK'				, width: 300 }
		],
		listeners: {
			selectionchange:function( model1, selected, eOpts ){
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				directMasterStore2.clearFilter();
				var selectedMrecord = masterGrid.getStore().getAt(rowIndex);
				if(Ext.isEmpty(selectedMrecord)) {
					directMasterStore2.filterBy(function(record){
						return record.get('CUSTOM_CODE') == '' && record.get('ORDER_PLAN_DATE') == '';
					})
				} else {
					directMasterStore2.filterBy(function(record){
						return record.get('CUSTOM_CODE') == selectedMrecord.get('CUSTOM_CODE') && UniDate.getDbDateStr(record.get('ORDER_PLAN_DATE')) == UniDate.getDbDateStr(selectedMrecord.get('ORDER_PLAN_DATE'));
					})
				}
			},
			beforeedit: function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['ORDER_DATE','ORDER_TYPE', 'ORDER_PRSN', 'AGREE_NAME', 'MONEY_UNIT', 'EXCHG_RATE_O', 'RECEIPT_TYPE' ])){
					return true;
				}else{
					return false;
				}
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('mpo200ukrvGrid2', {
		store		: directMasterStore2,
		layout		: 'fit',
		region		: 'south',
		excelTitle	: '<t:message code="system.label.purchase.purchaserordercontrol" default="구매오더조정/확정"/>(detail)',
		selModel	: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true,
			listeners: {
				beforeselect: function(grid, record, index, eOpts){
					var mainGrids = directMasterStore1.data.items;
					var checkFlag = false;
					Ext.each(mainGrids, function(mainGrid, i) {
						if(mainGrid.get('CUSTOM_CODE') == record.get('CUSTOM_CODE')
						&& UniDate.getDbDateStr(mainGrid.get('ORDER_PLAN_DATE')) == UniDate.getDbDateStr(record.get('ORDER_PLAN_DATE'))) {
							if(Ext.isEmpty(mainGrid.get('ORDER_PRSN'))){
								Unilite.messageBox('<t:message code="system.message.purchase.message057" default="구매담당은 필수 입니다."/>');
								checkFlag = true;
								return false;
							}else if(Ext.isEmpty(mainGrid.get('AGREE_PRSN'))){
								if(BsaCodeInfo.gsApproveYN == '1'){// 발주승인방식 -> 수동승인
									Unilite.messageBox('<t:message code="system.message.purchase.message058" default="승인자는 필수 입니다."/>');
									checkFlag = true;
									return false;
								}
							}
						}
					});
					if(checkFlag) return false;
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if(!gsSyncFlag) {
						var mainGrids = directMasterStore1.data.items;
						var needSelect= masterGrid.getSelectionModel().getSelection();
						Ext.each(mainGrids, function(mainGrid, i) {
							if(mainGrid.get('CUSTOM_CODE') == selectRecord.get('CUSTOM_CODE')
							&& UniDate.getDbDateStr(mainGrid.get('ORDER_PLAN_DATE')) == UniDate.getDbDateStr(selectRecord.get('ORDER_PLAN_DATE'))) {
								needSelect.push(mainGrid);
								selectRecord.set('ORDER_DATE'	, mainGrid.get('ORDER_DATE'));
								selectRecord.set('ORDER_TYPE'	, mainGrid.get('ORDER_TYPE'));
								selectRecord.set('ORDER_PRSN1'	, mainGrid.get('ORDER_PRSN'));
								selectRecord.set('AGREE_PRSN'	, mainGrid.get('AGREE_PRSN'));
								selectRecord.set('AGREE_NAME'	, mainGrid.get('AGREE_NAME'));
								selectRecord.set('EXCHG_RATE_O'	, mainGrid.get('EXCHG_RATE_O'));
								selectRecord.set('AGREE_STATUS'	, mainGrid.get('AGREE_STATUS'));
								selectRecord.set('CHECKTYPE'	, mainGrid.get('CHECKTYPE'));
								selectRecord.set('SAVE_FLAG'	, 'Y');
							}
						});
						gsSyncFlag = true;
						masterGrid.getSelectionModel().select(needSelect);
						gsSyncFlag = false;
					}
				},
				deselect: function(grid, selectRecord, index, rowIndex, eOpts ){
					var selRecords	= masterGrid2.getSelectionModel().getSelection()
					var count		= 0
					Ext.each(selRecords, function(selRecord, i) {
						if(selRecord.get('CUSTOM_CODE') == selectRecord.get('CUSTOM_CODE')
						&& UniDate.getDbDateStr(selRecord.get('ORDER_PLAN_DATE')) == UniDate.getDbDateStr(selectRecord.get('ORDER_PLAN_DATE'))) {
							count++;
						}
					});
					if(count == 0) {
						var mainGrids = directMasterStore1.data.items;
						Ext.each(mainGrids, function(mainGrid, i) {
							if(mainGrid.get('CUSTOM_CODE') == selectRecord.get('CUSTOM_CODE')
							&& UniDate.getDbDateStr(mainGrid.get('ORDER_PLAN_DATE')) == UniDate.getDbDateStr(selectRecord.get('ORDER_PLAN_DATE'))) {
								masterGrid.getSelectionModel().deselect(mainGrid);
							}
						});
					}
					selectRecord.set('SAVE_FLAG', '');
				},
				beforedeselect: function(grid, selectRecord, index, rowIndex, eOpts) {
				}
			}
		}),
		uniOpt: {
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			onLoadSelectFirst : false,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		columns: [
				{dataIndex: 'CHK'				,width:100, hidden: true},
				{dataIndex: 'COMP_CODE'			,width:100, hidden: true},
				{dataIndex: 'DIV_CODE'			,width:100, hidden: true},
				{dataIndex: 'IN_DIV_CODE'		,width:100},
				{dataIndex: 'CUSTOM_CODE'		,width:100, hidden: true},
				{dataIndex: 'ORDER_NUM'			,width:100, hidden: true},
				{dataIndex: 'ORDER_SEQ'			,width:60, align: 'center'},
				{dataIndex: 'ITEM_CODE'			,width:80},
				{dataIndex: 'ITEM_NAME'			,width:140},
				{dataIndex: 'SPEC'				,width:100},
				{dataIndex: 'STOCK_UNIT'		,width:80, align: 'center'},
				{dataIndex: 'TRNS_RATE'			,width:80, align: 'right'},
				{dataIndex: 'ORDER_UNIT'		,width:80, align: 'center'},
				{dataIndex: 'ORDER_UNIT_Q'		,width:100},
				{dataIndex: 'ORDER_UNIT_P'		,width:100},
				{dataIndex: 'ORDER_O'			,width:100},
				{dataIndex: 'DVRY_DATE'			,width:100},
				{dataIndex: 'WH_CODE'			,width:100},
				{dataIndex: 'INSPEC_YN'			,width:100, align: 'center'},
				{dataIndex: 'UNIT_PRICE_TYPE'	,width:100, align: 'center'},
				{dataIndex: 'ORDER_Q'			,width:100},
				{dataIndex: 'MONEY_UNIT'		,width:100, hidden: true},
				{dataIndex: 'ORDER_P'			,width:100, hidden: true},
				{dataIndex: 'CONTROL_STATUS'	,width:100, align: 'center'},
				{dataIndex: 'ORDER_REQ_NUM'		,width:120},
				{dataIndex: 'PURCH_LDTIME'		,width:100, hidden: true},
				{dataIndex: 'BASIS_DATE'		,width:100, hidden: true},
				{dataIndex: 'CREATE_DATE'		,width:100, hidden: true},
				{dataIndex: 'ORDER_PLAN_DATE'	,width:100, hidden: true},
				{dataIndex: 'SUPPLY_TYPE'		,width:100, hidden: true},
				{dataIndex: 'CHECKSEQ'			,width:100, hidden: true},
				{dataIndex: 'UPDATE_DB_USER'	,width:100, hidden: true},
				{dataIndex: 'UPDATE_DB_TIME'	,width:100, hidden: true},
				{dataIndex: 'ORDER_PRSN'		,width:100, hidden: true},
				{dataIndex: 'LOT_NO'			,width:100},
				{dataIndex: 'REMARK'			,width:100},
				{dataIndex: 'PROJECT_NO'		,width:100},
				{dataIndex: 'ORDER_DATE'		,width:100, hidden: true},
				{dataIndex: 'ORDER_TYPE'		,width:100, hidden: true},
				{dataIndex: 'ORDER_PRSN1'		,width:100, hidden: true},
				{dataIndex: 'AGREE_PRSN'		,width:100, hidden: true},
				{dataIndex: 'AGREE_NAME'		,width:100, hidden: true},
				{dataIndex: 'EXCHG_RATE_O'		,width:100, hidden: true},
				{dataIndex: 'AGREE_STATUS'		,width:100, hidden: true},
				{dataIndex: 'CHECKTYPE'			,width:100, hidden: true},
				{dataIndex: 'OUT_DIV_CODE'		,width:100, hidden: false},
				{dataIndex: 'OUT_DATE'			,width:100, hidden: false},
				{dataIndex: 'SO_NUM'			,width:120, hidden: false},
				{dataIndex: 'SO_SEQ'			,width:80, hidden: false},
				{dataIndex: 'SAVE_FLAG'			,width:80, hidden: true}
		],
		listeners: {
/*			select: function(grid, record, index, eOpts ){
				var mRecord = masterGrid.getSelectedRecord();
				record.set('ORDER_DATE'		, mRecord.get('ORDER_DATE'));
				record.set('ORDER_TYPE'		, mRecord.get('ORDER_TYPE'));
				record.set('ORDER_PRSN1'	, mRecord.get('ORDER_PRSN'));
				record.set('AGREE_PRSN'		, mRecord.get('AGREE_PRSN'));
				record.set('AGREE_NAME'		, mRecord.get('AGREE_NAME'));
				record.set('EXCHG_RATE_O'	, mRecord.get('EXCHG_RATE_O'));
				record.set('AGREE_STATUS'	, mRecord.get('AGREE_STATUS'));
				record.set('CHECKTYPE'		, mRecord.get('CHECKTYPE'));
				record.set('SAVE_FLAG'		, 'Y');
			},
			deselect:  function(grid, record, index, eOpts ){
				var mRecord = masterGrid.getSelectedRecord();
				record.set('ORDER_DATE', '');
				record.set('ORDER_TYPE', '');
				record.set('ORDER_PRSN1', '');
				record.set('AGREE_PRSN', '');
				record.set('AGREE_NAME', '');
				record.set('EXCHG_RATE_O', '');
				record.set('AGREE_STATUS', '');
				record.set('CHECKTYPE', '');
				record.set('SAVE_FLAG', 'N');
				record.commit();
			},
			beforeselect: function(grid, record, index, eOpts){
				var mRecord = masterGrid.getSelectedRecord();
				if(mRecord && Ext.isEmpty(mRecord.get('ORDER_PRSN'))){
					Unilite.messageBox('<t:message code="system.message.purchase.message057" default="구매담당은 필수 입니다."/>');
					return false;
				}else if(mRecord && Ext.isEmpty(mRecord.get('AGREE_PRSN'))){
					if(BsaCodeInfo.gsApproveYN == '1'){// 발주승인방식 -> 수동승인
						Unilite.messageBox('<t:message code="system.message.purchase.message058" default="승인자는 필수 입니다."/>');
						return false;
					}
				}
			},*/
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['ORDER_UNIT_P','ORDER_O', 'DVRY_DATE', 'WH_CODE', 'INSPEC_YN', 'IN_DIV_CODE', 'OUT_DIV_CODE', 'OUT_DATE'])){
					return true;
				}else{
					return false;
				}
			}
		}
	});



	var adjustForm = Unilite.createSearchForm('adjustForm', { //createForm
		layout : {type : 'uniTable', columns : 4
//			,tableAttrs:{width:'100%'}
//			,tdAttrs: {style: 'border : 1px solid #ced9e7;'}
		},
		disabled: false,
		border:true,
		padding:'1 1 1 1',
//		region: 'north',
//		masterGrid: masterGrid2,
		items: [{
			xtype: 'container',
			layout: {type: 'uniTable', column: 2},
			width:450,
			items:[{
				fieldLabel: '입고사업장',
				name:'IN_DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120'
			},{
				width: 150,
				xtype: 'button',
				text: '입고사업장 일괄적용',
				margin: '0 0 0 10',
				handler : function() {
					if(Ext.isEmpty(adjustForm.getValue('IN_DIV_CODE'))){
						Unilite.messageBox('입고사업장을 선택해주세요.');
						return false;
					}
					var mRecord = adjustGrid.getSelectedRecords();
					Ext.each(mRecord, function(rec, i) {
						rec.set('IN_DIV_CODE', adjustForm.getValue('IN_DIV_CODE'));
					});
				}
			}]
		},{
			xtype: 'container',
			layout: {type: 'uniTable', column: 2},
			width:450,
			items:[
				Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="Mpo501.label.CUSTOM_NAME" default="거래처"/>',
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelResult.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelResult.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_CODE', '');
								}
							},
				            applyextparam: function(popup){
				                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
		                	}
					}
			}),{
				width: 100,
				xtype: 'button',
				text: '<t:message code="system.label.purchase.customallapply" default="거래처일괄적용"/>',
				margin: '0 0 0 10',
				handler : function() {
					if(Ext.isEmpty(adjustForm.getValue('CUSTOM_CODE'))){
						Unilite.messageBox('<t:message code="system.message.purchase.message059" default="거래처를 선택해주세요."/>');
						return false;
					}
					var mRecord = adjustGrid.getSelectedRecords();
					Ext.each(mRecord, function(rec, i) {
						rec.set('CUSTOM_CODE', adjustForm.getValue('CUSTOM_CODE'));
						rec.set('CUSTOM_NAME', adjustForm.getValue('CUSTOM_NAME'));
					});
				}
			}]
		},{
			xtype: 'container',
			layout: {type: 'uniTable', column: 2},
			width:600,
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
				xtype: 'uniDatefield',
				name: 'DVRY_DATE'
			},{
//				width: 100,
				xtype: 'button',
				text: '납기일 일괄적용',
				margin: '0 0 0 10',
				handler : function() {
					if(Ext.isEmpty(adjustForm.getValue('DVRY_DATE'))){
						Unilite.messageBox('납기일을 선택해주세요.');
						return false;
					}
					var mRecord = adjustGrid.getSelectedRecords();
					Ext.each(mRecord, function(rec, i) {
						rec.set('DVRY_DATE', adjustForm.getValue('DVRY_DATE'));
					});
				}
			}]
		},{
			xtype: 'container',
			layout: {type: 'uniTable', column: 1},
			width:300,
			items:[{
				xtype:'button',
				text:'엑셀업로드',
				width:100,
	//			margin: '0 0 0 50',
				handler:function(){
					if(!panelResult.getInvalidMessage()) return;   //필수체크
					openExcelWindow();
				}
			}]
		}]
	});

	var adjustGrid = Unilite.createGrid('mpo200ukrvAdjustGrid', {
		layout: 'fit',
		region: 'south',
		excelTitle: '<t:message code="system.label.purchase.purchaserequestinfoupdate" default="구매요청정보조정"/>',
		selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false }),
		uniOpt: {
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			onLoadSelectFirst : false,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		store: adjustStore,
		columns: [
				{dataIndex: 'COMP_CODE'							 ,width:100, hidden: true},
				{dataIndex: 'DIV_CODE'							  ,width:100, hidden: true},
				{dataIndex: 'IN_DIV_CODE'						  ,width:100},
				{dataIndex: 'ORDER_PLAN_DATE'						,width:90},
				{dataIndex: 'DVRY_DATE'						,width:90},
				{dataIndex: 'CUSTOM_CODE'		, width: 100	,
				  editor: Unilite.popup('AGENT_CUST_G',{
						DBtextFieldName : 'CUSTOM_CODE',
						autoPopup		: true,
						listeners		: {
							'onSelected': {
								fn: function(records, type  ){
									var grdRecord = adjustGrid.uniOpt.currentRecord;
									grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
									grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								},
								scope: this
							},
							'onClear' : function(type)  {
								var grdRecord = adjustGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE','');
								grdRecord.set('CUSTOM_NAME','');
							},
							'applyextparam': function(popup){
								popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','2']});
								popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
							}
						}
					})
				},
				{dataIndex: 'CUSTOM_NAME'		, width: 140	,
				  editor: Unilite.popup('AGENT_CUST_G',{
						DBtextFieldName : 'CUSTOM_NAME',
						autoPopup		: true,
						listeners		: {
							'onSelected': {
								fn: function(records, type  ){
									var grdRecord = adjustGrid.uniOpt.currentRecord;
									grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
									grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								},
								scope: this
							},
							'onClear' : function(type)  {
								var grdRecord = adjustGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE','');
								grdRecord.set('CUSTOM_NAME','');
							},
							'applyextparam': function(popup){
								popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','2']});
								popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
							}
						}
					})
				},
				{dataIndex: 'PROD_ITEM_CODE'						,width:100, hidden: true},
				{dataIndex: 'PROD_ITEM_NAME'						,width:200},
				{dataIndex: 'ITEM_CODE'							 ,width:90},
				{dataIndex: 'ITEM_NAME'							 ,width:200},
				{dataIndex: 'SPEC'								  ,width:100},
				{dataIndex: 'ORDER_PLAN_Q'						  ,width:100},
				{dataIndex: 'ORDER_UNIT'							,width:80, align:'center'},
				{dataIndex: 'BASIS_DATE'							,width:100, hidden: true},
				{dataIndex: 'REQ_PLAN_Q'							,width:90, hidden: true},
				{dataIndex: 'SUPPLY_TYPE'							,width:100, hidden: true},
				{dataIndex: 'PAB_STOCK_Q'							,width:90, hidden: true},
				{dataIndex: 'EXCHG_EXIST_YN'						,width:100, hidden: true},
				{dataIndex: 'REF_ITEM_CODE'						 ,width:100, hidden: true},
				{dataIndex: 'REF_ITEM_NAME'						 ,width:100, hidden: true},
				{dataIndex: 'EXCHG_YN'							  ,width:100, hidden: true},
				{dataIndex: 'DOM_FORIGN'							,width:80},
				{dataIndex: 'ORDER_REQ_DEPT_CODE'					,width:100},
				{dataIndex: 'ORDER_PRSN'							,width:90},
				{dataIndex: 'ORDER_YN'							  ,width:100, hidden: true},
				{dataIndex: 'ORDER_NUM'							 ,width:120},
				{dataIndex: 'ORDER_SEQ'							 ,width:66},
				{dataIndex: 'ORDER_REQ_NUM'						 ,width:120},
				{dataIndex: 'MRP_CONTROL_NUM'						,width:110, hidden: true},
				{dataIndex: 'WKORD_NUM'							 ,width:110},
				{dataIndex: 'ITEM_ACCOUNT'						  ,width:100, hidden: true},
				{dataIndex: 'PURCH_LDTIME'						  ,width:100, hidden: true},
				{dataIndex: 'CREATE_DATE'							,width:100, hidden: true},
				{dataIndex: 'MRP_YN'								,width:100, hidden: true},
				{dataIndex: 'LOT_NO'								,width:100},
				{dataIndex: 'REMARK'								,width:100},
				{dataIndex: 'PROJECT_NO'							,width:100,
					editor: Unilite.popup('PROJECT_G', {
						extParam: {DIV_CODE: UserInfo.divCode},
						autoPopup: true,
						listeners: {'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										var grdRecord = masterGrid.uniOpt.currentRecord;
										Ext.each(records, function(record,i) {
											if(i==0) {
												grdRecord.set('PROJECT_NO', record['PJT_CODE']);
											}
										});
									},
									scope: this
									},
									'onClear': function(type) {
										var grdRecord = masterGrid.uniOpt.currentRecord;
										grdRecord.set('PROJECT_NO', '');
									}
						}
					})
				}
		],
		listeners: {
			select: function(grid, record, index, eOpts ){

			},
			deselect:  function(grid, record, index, eOpts ){

			},
			selectionchange: function(){

			},
			beforeselect: function(grid, record, index, eOpts){
//				if(Ext.isEmpty(record.get('CUSTOM_CODE'))){
//					return true;
//				}else{
//					return false;
//				}
//				if(Ext.isEmpty(adjustForm.getValue('CUSTOM_CODE'))){
//					Unilite.messageBox('거래처를 선택해 주세요.');
//					return false;
//				}
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['IN_DIV_CODE','ORDER_PLAN_DATE','DVRY_DATE','CUSTOM_CODE', 'CUSTOM_NAME', 'ORDER_PLAN_Q', 'SUPPLY_TYPE', 'DOM_FORIGN', 'ORDER_PRSN', 'REMARK', 'PROJECT_NO'])){
					return true;
				}else{
					return false;
				}
			}
		},
		setExcelData: function(record) {	//엑셀 업로드 참조
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('CUSTOM_CODE'		, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'		, record['CUSTOM_NAME']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ORDER_PLAN_Q'		, record['ORDER_PLAN_Q']);
			grdRecord.set('ORDER_PLAN_DATE'	, record['ORDER_PLAN_DATE']);
			grdRecord.set('DVRY_DATE'			, record['DVRY_DATE']);
		}
	});



	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab: 0,
		region: 'center',
		items: [{
			xtype: 'container',
			layout: {type: 'vbox', align: 'stretch'},
			title: '<t:message code="system.label.purchase.purchaseconfirm" default="구매오더확정"/>',
			items:[
				masterGrid, masterGrid2
			],
			id: 'mpo200ukrvMasterTab'
		},{
			xtype: 'container',
			layout: {type: 'vbox', align: 'stretch'},
			title: '<t:message code="system.label.purchase.purchaserequestinfoupdate" default="구매요청정보조정"/>',
			items:[
				adjustForm,adjustGrid
			],
			id: 'mpo200ukrvAdjustTab'
		}],
		listeners:  {
			tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
				if(newCard.id == 'mpo200ukrvAdjustTab'){
					UniAppManager.setToolbarButtons(['delete'], true);
					
					masterGrid.reset();
					masterGrid2.reset();
					
					directMasterStore1.clearData();
					directMasterStore2.clearData();
					UniAppManager.setToolbarButtons(['save'], false);
					
					panelResult.getField('DOM_FORIGN').colspan = 2;
					panelResult.down('#btnConfirm').hide();
				}else{
					adjustForm.clearForm();
					adjustGrid.reset();
					adjustStore.clearData();
					UniAppManager.setToolbarButtons(['delete','save'], false);
					
					panelResult.getField('DOM_FORIGN').colspan = 1;
					panelResult.down('#btnConfirm').show();
				}
			}
		}
	});



	Unilite.Main({
		id			: 'mpo200ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				tab, panelResult
			]
		}],
		fnInitBinding: function(params) {
			this.setDefault(params);
			tab.setActiveTab(Ext.getCmp('mpo200ukrvMasterTab'));
		},
		onQueryButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'mpo200ukrvMasterTab'){
				//20200709 추가
				masterGrid.getStore().loadStoreRecords();
				masterGrid2.getStore().loadStoreRecords();
				//20200709 주석
//				masterGrid2.reset();
			}else if(activeTabId == 'mpo200ukrvAdjustTab'){
				adjustGrid.getStore().loadStoreRecords();
			}
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.reset();
			masterGrid2.reset();
			adjustGrid.reset();
			panelResult.clearForm();
			adjustForm.clearForm();
			directMasterStore1.clearData();
			directMasterStore2.clearData();
			adjustStore.clearData();
			this.fnInitBinding();

			UniAppManager.setToolbarButtons(['save'], false);
		},
		onDeleteDataButtonDown: function() {
			var selRow = adjustGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)){
				if(selRow.phantom === true) {
					adjustGrid.deleteSelectedRow();
				}else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					adjustGrid.deleteSelectedRow();
				}
			}
		},
		onSaveDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'mpo200ukrvAdjustTab'){
				adjustStore.saveStore();
			}
		},
		setDefault: function(params) {
			gsSyncFlag = false;
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('ORDER_TO_DATE', UniDate.get('today'));
			panelResult.setValue('ORDER_FR_DATE', UniDate.get('startOfMonth', panelResult.getValue('TO_DATE')));
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params) {
				if(params.action == 'newMpo060') {
					panelResult.setValue('DIV_CODE'			, params.DIV_CODE);
					panelResult.setValue('DIV_CODE'			, params.DIV_CODE);
					panelResult.setValue('DEPT_CODE'		, params.DEPT_CODE);
					panelResult.setValue('DEPT_CODE'		, params.DEPT_CODE);
					panelResult.setValue('DEPT_NAME'		, params.DEPT_NAME);
					panelResult.setValue('DEPT_NAME'		, params.DEPT_NAME);
					panelResult.setValue('WH_CODE'			, params.WH_CODE);
					panelResult.setValue('WH_CODE'			, params.WH_CODE);
					panelResult.setValue('ORDER_PRSN'		, params.ORDER_PRSN);
					panelResult.setValue('ORDER_PRSN'		, params.ORDER_PRSN);
					panelResult.setValue('ORDER_EXPECTED_FR' , params.ORDER_EXPECTED_FR);
					panelResult.setValue('ORDER_EXPECTED_FR', params.ORDER_EXPECTED_FR);
					panelResult.setValue('ORDER_EXPECTED_TO' , params.ORDER_EXPECTED_TO);
					panelResult.setValue('ORDER_EXPECTED_TO', params.ORDER_EXPECTED_TO);
				}
			}
		}
	});



	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var detailSelectedRecs = masterGrid2.getSelectedRecords();
			//var detailSelectedRecs = directMasterStore2.data.items;
			if(detailSelectedRecs.length == 0) return rv;
			switch(fieldName) {
				case "ORDER_DATE" :
					Ext.each(detailSelectedRecs, function(rec, i){
						rec.set('ORDER_DATE', newValue);
					});
				break;
				case "ORDER_TYPE" :
					Ext.each(detailSelectedRecs, function(rec, i){
						rec.set('ORDER_TYPE', newValue);
					});
				break;
				case "ORDER_PRSN" :
					Ext.each(detailSelectedRecs, function(rec, i){
						rec.set('ORDER_PRSN', newValue);
					});
				break;
				case "AGREE_NAME" :
					Ext.each(detailSelectedRecs, function(rec, i){
						rec.set('AGREE_NAME', newValue);
					});
				break;
				case "MONEY_UNIT" :
					Ext.each(detailSelectedRecs, function(rec, i){
						rec.set('MONEY_UNIT', newValue);
					});
				break;
				case "EXCHG_RATE_O" :
					Ext.each(detailSelectedRecs, function(rec, i){
						rec.set('EXCHG_RATE_O', newValue);
					});
				break;
				case "RECEIPT_TYPE" :
					Ext.each(detailSelectedRecs, function(rec, i){
						rec.set('RECEIPT_TYPE', newValue);
					});
				break;
			}
			return rv;
		}
	});

	Unilite.createValidator('validator02', {
		store: directMasterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ORDER_UNIT_Q" :
					if(record.get('OREDER_UNIT_P') != '' ){
						record.set('ORDER_O', newValue * record.get('ORDER_UNIT_P'));
					}else if(record.get('ORDER_UNIT_P') == ''){
						record.set('ORDER_UNIT_P',record.get('ORDER_O') / newValue);
						record.set('ORDER_P',record.get('ORDER_O') / newValue / record.get('TRNS_RATE'));
					}
					record.set('ORDER_Q', newValue * record.get('TRNS_RATE'));
					break;
				case "ORDER_UNIT_P" :
					record.set('ORDER_P', newValue / record.get('TRNS_RATE'));
					record.set('ORDER_O',record.get('ORDER_Q') * newValue);
					break;
				case "ORDER_O" :
					record.set('ORDER_UNIT_P', newValue / record.get('ORDER_UNIT_Q'));
					record.set('ORDER_P', newValue / record.get('ORDER_UNIT_Q') /record.get('TRNS_RATE') );
					break;
				case "IN_DIV_CODE" :
					record.set('WH_CODE', '');
					break;
			}
			return rv;
		}
	});
};
</script>