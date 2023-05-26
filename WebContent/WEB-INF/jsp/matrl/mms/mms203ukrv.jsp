<%--
'   프로그램명 : 수입검사등록(무상포함)
'
'   작  성  자 : 시너지시스템즈(주)
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms203ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="Q005" /> <!-- 검사유형 -->
	<t:ExtComboStore comboType="AU" comboCode="Q022" /> <!-- 검사담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M414" /> <!-- 합격여부 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주유형 -->
	<t:ExtComboStore comboType="AU" comboCode="Q033" /> <!-- 최종판정 -->
	<t:ExtComboStore comboType="AU" comboCode="Q002" /> <!-- 최종판정 -->
	<t:ExtComboStore comboType="OU" />								<!-- 창고-->
	<t:ExtComboStore items="${COMBO_TEST_CODE}" storeId="COMBO_TEST_CODE" />	<!-- 시험항목 -->
	<t:ExtComboStore items="${COMBO_TEST_CODE}" storeId="COMBO_TEST_CODE2" />	<!-- 시험항목 -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var SearchInfoWindow;	//조회버튼 누르면 나오는 조회창
var referReceiptWindow;	//접수참조
var selectedMasterGrid = 'mms203ukrvGrid1';
var masterSelectIdx = 0;
var allowFlag = true;
var BsaCodeInfo = {
	gsAutoInputFlag   : '${gsAutoInputFlag}',
	gsLotNoInputMethod: '${gsLotNoInputMethod}',
	gsLotNoEssential  : '${gsLotNoEssential}',
	gsManageLotNoYN   : '${gsManageLotNoYN}',
	gsInspecPrsn   : '${gsInspecPrsn}'
};
if(BsaCodeInfo.gsAutoInputFlag == 'N'){
	allowFlag = true;
}else{
	allowFlag = false;
}

function appMain() {

	var lotNoEssential = BsaCodeInfo.gsLotNoEssential == "Y"?true:false;
	var lotNoInputMethod = BsaCodeInfo.gsLotNoInputMethod == "Y"?true:false;

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'mms203ukrvService.selectList1',
			update	: 'mms203ukrvService.updateDetail',
			create	: 'mms203ukrvService.insertDetail',
			destroy	: 'mms203ukrvService.deleteDetail',
			syncAll	: 'mms203ukrvService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'mms203ukrvService.selectList2',
			update	: 'mms203ukrvService.updateBad',
			create	: 'mms203ukrvService.insertBad',
			destroy	: 'mms203ukrvService.deleteBad',
			syncAll	: 'mms203ukrvService.saveAllBad'
		}
	});



	/** 主页面grid1 Model
	 */
	Unilite.defineModel('Mms203ukrvModel1', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'				, type: 'string'},
			{name: 'INSPEC_NUM'			, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'				, type: 'string'},
			{name: 'INSPEC_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'int'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'INSPEC_TYPE'		, text: '<t:message code="system.label.purchase.inspectype" default="검사유형"/>'			, type: 'string',comboType: 'AU',comboCode: 'Q005', allowBlank:false},
			{name: 'GOODBAD_TYPE'		, text: '<t:message code="system.label.purchase.passyn" default="합격여부"/>'				, type: 'string',comboType: 'AU',comboCode: 'M414', allowBlank:false},
			{name: 'END_DECISION'		, text: '<t:message code="system.label.purchase.finaldecision" default="최종판정"/>'		, type: 'string',comboType: 'AU',comboCode: 'Q033', allowBlank:false},
			{name: 'RECEIPT_Q'			, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'			, type: 'uniQty'},
			{name: 'NOR_RECEIPT_Q'		, text: '정상접수량'			, type: 'uniQty'},
			{name: 'FREE_RECEIPT_Q'		, text: '무상접수량'			, type: 'uniQty'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'			, type: 'uniQty'},
			{name: 'INSPEC_Q'			, text: '<t:message code="system.label.product.inspecqty2" default="검사량(시료)"/>'			, type: 'uniQty', allowBlank:false},
			// 20210217 채취수량(COLLECT_Q) 추가
			{name: 'COLLECT_Q'			, text: '<t:message code="system.label.purchase.collectqty" default="채취수량"/>'			, type: 'uniQty'},
			{name: 'NOR_COLLECT_Q'		, text: 'NOR_COLLECT_Q'			, type: 'uniQty'},
			{name: 'FREE_COLLECT_Q'		, text: 'FREE_COLLECT_Q'		, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q'		, text: '<t:message code="system.label.purchase.defectqty2" default="불량(폐기)수량"/>'		, type: 'uniQty'},
			{name: 'NOR_BAD_INSPEC_Q'	, text: '정상불량수량'	, type: 'uniQty'},
			{name: 'FREE_BAD_INSPEC_Q'	, text: '무상불량수량'	, type: 'uniQty'},
			{name: 'BAD_INSPEC_PER'		, text: '<t:message code="system.label.product.defectratepercent" default="불량률(%)"/>'	, type: 'uniPercent'},
			{name: 'GOOD_INSPEC_Q'		, text: '<t:message code="system.label.purchase.passqty2stock" default="합격수량(재고)"/>'	, type: 'uniQty'},
			{name: 'NOR_GOOD_INSPEC_Q'	, text: '정상양품수량'	, type: 'uniQty'},
			{name: 'FREE_GOOD_INSPEC_Q'	, text: '무상양품수량'	, type: 'uniQty'},
			{name: 'STOCK_UNIT'  	    , text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string',comboType:'AU',comboCode:'B013', displayField: 'value'},
			{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>' 			, type: 'uniQty'},
			{name: 'INSPEC_PRSN'		, text: '<t:message code="system.label.purchase.inspecchargeperson" default="검사담당자"/>'	, type: 'string',comboType: 'AU',comboCode: 'Q022', allowBlank:false},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'			, type: 'string'},
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
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			, type: 'string', comboType:'AU',comboCode:'B020'},
			{name: 'ITEM_LEVEL1'		, text: 'ITEM_LEVEL1'	, type: 'string'}
		]
	});

	/** 主页面grid2 Model
	 */
	Unilite.defineModel('Mms203ukrvModel2', {
		fields: [
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'	, type: 'string'},
			{name: 'INSPEC_NUM'			,text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'	, type: 'string'},
			{name: 'INSPEC_SEQ'			,text: '<t:message code="system.label.purchase.seq" default="순번"/>'			, type: 'int'},
			{name: 'TEST_CODE'		,text: '검사항목'		,type: 'string',store: Ext.data.StoreManager.lookup('COMBO_TEST_CODE'), allowBlank: false},
			{name: 'TEST_NAME'		,text: '코드'			,type: 'string'},
			{name: 'TEST_METH'		,text: '검사방법'			,type: 'string'},
			{name: 'TEST_COND'		,text: '검사기준'		,type: 'string'},
			{name: 'VALUE_TYPE'		,text: '검사값구분'					,type: 'string', comboType:'AU', comboCode:'Q042', defaultValue:'Y'},
			{name: 'VALUE_POINT'	,text: '소수점'					,type: 'int', maxLength: 1},
			{name: 'TEST_COND_FROM'	,text: 'FROM<br/>(하한값)'			,type: 'float' , decimalPrecision: 2 , format:'0,000.00'},
			{name: 'TEST_COND_TO'	,text: 'TO<br/>(상한값)'			,type: 'float' , decimalPrecision: 2 , format:'0,000.00'},
			{name: 'MEASURED_VALUE'	,text: '측정치<br/>(기준값)'		,type: 'float' , decimalPrecision: 2 , format:'0,000.00'},
			{name: 'SPEC'			,text: '검사결과<br/>(논리표현)'			,type: 'string'},
			{name: 'TEST_UNIT'		,text: '단위'						,type: 'string', comboType:'AU', comboCode:'B013'},
			{name: 'TEST_PRSN'		,text: '시험자'					,type: 'string'},
			{name: 'REVISION_DATE'	,text: '개정일자'					,type: 'uniDate'},
			{name: 'BAD_INSPEC_Q'	,text: '<t:message code="system.label.product.defectinspecqty" default="불량검사량"/>'	,type: 'uniQty'},
			{name: 'INSPEC_REMARK'	,text: '<t:message code="system.label.product.inspeccontents" default="검사내용"/>'		,type: 'string'},
			{name: 'MANAGE_REMARK'	,text: '<t:message code="system.label.product.actioncontents" default="조치내용"/>'		,type: 'string'},
			{name: 'SAVE_FLAG'			,text: 'SAVE_FLAG'	,type: 'string'},
			{name: 'SAVE_TEMP'			,text: 'SAVE_TEMP'	,type: 'string'}
		]
	});

	/** 查询窗口model
	 */
	Unilite.defineModel('receiptNoMasterModel', {		//조회버튼 누르면 나오는 조회창
		fields: [
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'	, type: 'string'},
			{name: 'INSPEC_NUM'		, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'				, type: 'string'},
			{name: 'INSPEC_SEQ'		, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'int'},
			{name: 'INSPEC_DATE'	, text: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>'			, type: 'uniDate'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'INSPEC_Q'		, text: '<t:message code="system.label.purchase.inspecqty" default="검사량"/>'				, type: 'uniQty'},
			// 20210217 채취수량(COLLECT_Q) 추가
			{name: 'COLLECT_Q'		, text: '<t:message code="system.label.purchase.collectqty" default="채취수량"/>'			, type: 'uniQty'},
			{name: 'GOOD_INSPEC_Q'	, text: '<t:message code="system.label.purchase.passqty" default="합격수량"/>'				, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q'	, text: '<t:message code="system.label.purchase.defectqty" default="불량수량"/>'			, type: 'uniQty'},
			{name: 'INSPEC_TYPE'	, text: '<t:message code="system.label.purchase.inspec" default="검사"/>'					, type: 'string', comboType: 'AU', comboCode: 'Q005'},
			{name: 'INSPEC_PRSN'	, text: '<t:message code="system.label.purchase.inspecchargeperson" default="검사담당자"/>'	, type: 'string'},
			{name: 'RECEIPT_NUM'	, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'			, type: 'string'},
			{name: 'RECEIPT_SEQ'	, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'			, type: 'int'},
			{name: 'LOT_NO'			, text: 'LOT NO'		, type: 'string'}
		]
	});

	/** 接收参考grid model
	 */
	Unilite.defineModel('mms203ukrvRECEIPTModel', {	//접수참조
		fields: [
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'RECEIPT_DATE'		, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'		, type: 'uniDate'},
			{name: 'INSPEC_METH_MATRL'	, text: '<t:message code="system.label.purchase.inspectype" default="검사유형"/>'		, type: 'string', comboType: 'AU', comboCode: 'Q005'},
			{name: 'INSPEC_Q'			, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'		, type: 'uniQty'},
			{name: 'NOR_RECEIPT_Q'			, text: '정상접수량'		, type: 'uniQty'},
			{name: 'FREE_RECEIPT_Q'			, text: '무상접수량'		, type: 'uniQty'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'		,type: 'uniQty'},
			{name: 'NOT_INSPEC_Q'		, text: '<t:message code="system.label.purchase.noinspecqty" default="미검사량"/>'		, type: 'uniQty'},
			{name: 'NOT_INSPEC_STOCK_Q'	, text: '<t:message code="system.label.purchase.noinspecqty2" default="미검사량(재고)"/>'	, type: 'uniQty'},
			{name: 'RECEIPT_NUM'		, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'		, type: 'string'},
			{name: 'RECEIPT_SEQ'		, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'		, type: 'int'},
			{name: 'LOT_NO'				, text: 'LOT NO'		, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.poclass" default="발주유형"/>'			, type: 'string', comboType: 'AU', comboCode: 'M001'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'			, type: 'int'},
			{name: 'MAKE_LOT_NO'		, text: '<t:message code="system.label.purchase.customLOT" default="거래처LOT"/>'		, type: 'string'},
			{name: 'MAKE_DATE'			, text: '<t:message code="system.label.purchase.makedate" default="제조일자"/>'			, type: 'uniDate'},
			{name: 'MAKE_EXP_DATE'		, text: '<t:message code="system.label.purchase.expirationdate" default="유통기한"/>'	, type: 'uniDate'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'WH_CODE'			, text: 'WH_CODE'	   , type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'		, type: 'string', comboType:'AU',comboCode:'B020'},
			{name: 'ITEM_LEVEL1'		, text: 'ITEM_LEVEL1'	, type: 'string'}
		]
	});



	/** 主页面grid1 store
	 */
	var directMasterStore1 = Unilite.createStore('mms203ukrvMasterStore1', {
		model : 'Mms203ukrvModel1',
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad : false,
		proxy	: directProxy,
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();

			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			Ext.each(list, function(record, index) {
				record.set('INSPEC_DATE', UniDate.getDbDateStr(panelResult.getValue('INSPEC_DATE')));
			});


			if(inValidRecs.length == 0) {
				config = {
					params: [masterForm.getValues()],
					success: function(batch, option) {
						var result = batch.operations[0].getResultSet();
						masterForm.setValue("INSPEC_NUM", result["INSPEC_NUM"]);
						panelResult.setValue("INSPEC_NUM", result["INSPEC_NUM"]);
						Ext.getCmp('receiveBadWhCode').setValue('');
						Ext.getCmp('receiveGoodWhCode').setValue('');
						if(directMasterStore2.isDirty()){
							directMasterStore2.saveStore();
						}else{
							if(directMasterStore1.getCount() == 0){
								UniAppManager.app.onResetButtonDown();
							}else{
								UniAppManager.app.onQueryButtonDown();
							}
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				Ext.getCmp('mms203ukrvGrid1').uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records[0] != null){
					masterForm.setValue('INSPEC_NUM', records[0].get('INSPEC_NUM'));
					masterForm.setValue('ITEM_CODE'  , records[0].get('ITEM_CODE'));
					masterForm.setValue('INSPEC_SEQ', records[0].get('INSPEC_SEQ'));

				if((masterForm.getValue('INSPEC_NUM') != '') && (masterForm.getValue('ITEMCODE') != '') && (masterForm.getValue('INSPEC_SEQ') != '')){
//					directMasterStore2.loadStoreRecords(records[0]);
					masterGrid.getNavigationModel().setPosition(0, 0);
					masterGrid.getSelectionModel().select(masterSelectIdx);
				}
				}else{
					masterForm.setValue('INSPEC_NUM','');
					masterForm.setValue('ITEM_CODE','');
					masterForm.setValue('INSPEC_SEQ','');
					masterGrid2.getStore().removeAll();
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params : param
			});
		}
	});

	/** 主页面grid2 store
	 */
	var directMasterStore2 = Unilite.createStore('mms203ukrvMasterStore2', {
		model: 'Mms203ukrvModel2',
		uniOpt: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad : false,
		proxy	: directProxy2,
		loadStoreRecords: function(record){
			var param = record.data;

			var searchParam = Ext.getCmp('searchForm').getValues();
			param.REVISION_DATE = searchParam.INSPEC_DATE;

			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var param = masterForm.getValues();
			var record = masterGrid.getSelectedRecord();
			if(record){
				param["INSPEC_NUM"] = record.get("INSPEC_NUM")
				param["INSPEC_SEQ"] = record.get("INSPEC_SEQ")
			}
			if(inValidRecs.length == 0) {
				var config = {
					params: [param],
					success: function(batch, option) {
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			}else{
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {

//				if(records != null && records.length > 0 ){

	                var store = masterGrid2.getStore();
	                if(store.getCount() > 0) {
		                if(!Ext.isEmpty(records[0].get('SAVE_FLAG')) && records[0].get('SAVE_FLAG') == 'N'){
								Ext.getCmp('selectListBtn').setDisabled(false);
								Ext.getCmp('saveListBtn').setDisabled(true);

		                }else if(!Ext.isEmpty(records[0].get('SAVE_FLAG')) && records[0].get('SAVE_FLAG') == 'U'){
								Ext.getCmp('selectListBtn').setDisabled(true);
								Ext.getCmp('saveListBtn').setDisabled(false);
		                }
					 }else {
								Ext.getCmp('selectListBtn').setDisabled(false);
								Ext.getCmp('saveListBtn').setDisabled(true);

					 }
					UniAppManager.setToolbarButtons(['delete'], true);
					Ext.each(records, function(record,i) {
						if(Ext.isEmpty(record.get('SAVE_FLAG')) || record.get('SAVE_FLAG') == 'N'){
							record.set('SAVE_FLAG', 'N');
							record.set('SAVE_TEMP', 'N');
						}
					});
//				}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function(store,  eOpts) {
				if( directMasterStore1.isDirty() || store.isDirty() ) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			},
			remove : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				if(store.getCount() == 0) {
					UniAppManager.setToolbarButtons(['delete','deleteAll'], false);
				}
			}
		}
	});

	/** 查询窗口store
	 */
	var receiptNoMasterStore = Unilite.createStore('receiptNoMasterStore', {	//조회버튼 누르면 나오는 조회창
		model	: 'receiptNoMasterModel',
		autoLoad : false,
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 'mms203ukrvService.selectreceiptNumMasterList'
			}
		},
		loadStoreRecords : function() {
			var param= receiptNoSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/** 接收参考store
	 */
	var receiptStore = Unilite.createStore('mms203ukrvReceiptStore', {//접수참조
		model: 'mms203ukrvRECEIPTModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'mms203ukrvService.selectreceiptList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts){
				if(successful) {
					var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					var estiRecords = new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								if((record.data['RECEIPT_NUM'] == item.data['RECEIPT_NUM'])
								&& (record.data['RECEIPT_SEQ'] == item.data['RECEIPT_SEQ'])){
									estiRecords.push(item);
								}
							});
						});
						store.remove(estiRecords);
					}
				}
			}
		},
		loadStoreRecords : function() {
			var param= receiptSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	/** 左侧条件表单
	 */
	var masterForm = Unilite.createSearchPanel('searchForm', {
		title	   : '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType : 'uniSearchSubPanel',
		items: [{
			title  : '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
 			itemId : 'search_panel1',
			layout : {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel   : '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		 : 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				holdable: 'hold',
				allowBlank   : false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel   : '<t:message code="system.label.purchase.inspectype" default="검사유형"/>',
				name		 : 'INSPEC_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Q005',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPEC_TYPE', newValue);
					}
				}
			},{
				fieldLabel   : '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
				name		 : 'INSPEC_DATE',
				xtype		: 'uniDatefield',
				value		: UniDate.get('today'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPEC_DATE', newValue);
					}
				}
			},{
				fieldLabel   : '<t:message code="system.label.purchase.inspeccharge" default="검사담당"/>',
				name		 : 'INSPEC_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Q022',
				allowBlank   : false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPEC_PRSN', newValue);
					}
				}
			},{
				fieldLabel   : '<t:message code="system.label.purchase.inspecno" default="검사번호"/>',
				name		 : 'INSPEC_NUM',
				xtype		: 'uniTextfield',
				readOnly	 : false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPEC_NUM', newValue);
					}
				}
			},{
				fieldLabel   : '<t:message code="system.label.purchase.passyn" default="합격여부"/>',
				name		 : 'GOODBAD_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'M414',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('GOODBAD_TYPE', newValue);
					}
				}
			},{
				fieldLabel   : '<t:message code="system.label.purchase.itemcodevalue" default="아이템코드값"/>',
				name		 : 'ITEM_CODE',
				xtype		: 'uniTextfield',
				hidden	   : true
			},{
				fieldLabel   : '<t:message code="system.label.purchase.seq" default="순번"/>',
				name		 : 'INSPEC_SEQ',
				xtype		: 'uniTextfield',
				hidden	   : true
			},{
				fieldLabel   : 'ITEM_ACCOUNT',
				name		 : 'ITEM_ACCOUNT',
				hidden	   : true,
				xtype		: 'uniTextfield'
			},{
				fieldLabel   : 'ITEM_LEVEL1',
				name		 : 'ITEM_LEVEL1',
				xtype		: 'uniTextfield',
				hidden	   : true
			},{
				fieldLabel   : 'ORDER_TYPE',
				name		 : 'ORDER_TYPE',
				xtype		: 'uniTextfield',
				hidden	   : true
			},{
				fieldLabel   : 'INSPEC_NUM_TEMP',
				name		: 'INSPEC_NUM_TEMP',
				xtype	   : 'uniTextfield',
				readOnly   : false,
				hidden	   : true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel   : 'INSPEC_SEQ_TEMP',
				name		 : 'INSPEC_SEQ_TEMP',
				xtype		: 'uniTextfield',
				hidden	   : true
			},{
				fieldLabel   : 'GOOD_WH_CODE',
				name		 : 'GOOD_WH_CODE',
				xtype		: 'uniTextfield',
				readOnly	 : true,
				hidden	   : true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

					}
				}
			},{
				fieldLabel   : 'BAD_WH_CODE',
				name		 : 'BAD_WH_CODE',
				xtype		: 'uniTextfield',
				readOnly	 : true,
				hidden	   : true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

					}
				}
			}]
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
	});

	/** 北侧条件表单
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel   : '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		 : 'DIV_CODE',
			xtype		: 'uniCombobox',
			holdable :'hold',
			comboType	: 'BOR120',
			allowBlank   : false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel   : '<t:message code="system.label.purchase.inspectype" default="검사유형"/>',
			name		 : 'INSPEC_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'Q005',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('INSPEC_TYPE', newValue);
				}
			}
		},{
			fieldLabel   : '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
			name		 : 'INSPEC_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('INSPEC_DATE', newValue);
				}
			}
		},{
			fieldLabel   : '<t:message code="system.label.purchase.inspeccharge" default="검사담당"/>',
			name		 : 'INSPEC_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'Q022',
			allowBlank   : false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('INSPEC_PRSN', newValue);
				}
			}
		},{
			fieldLabel   : '<t:message code="system.label.purchase.inspecno" default="검사번호"/>',
			name		 : 'INSPEC_NUM',
			xtype		: 'uniTextfield',
			readOnly	 : true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('INSPEC_NUM', newValue);
				}
			}
		},{
			fieldLabel   : 'ITEM_CODE',
			name		 : 'ITEM_CODE',
			xtype		: 'uniTextfield',
			readOnly	 : true,
			hidden	   : true,
			listeners: {

			}
		},{
			fieldLabel   : '<t:message code="system.label.purchase.passyn" default="합격여부"/>',
			name		 : 'GOODBAD_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'M414',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('GOODBAD_TYPE', newValue);
				}
			}
		},{
			fieldLabel   : '<t:message code="system.label.purchase.itemcodevalue" default="아이템코드값"/>',
			name		 : 'ITEM_CODE',
			xtype		: 'uniTextfield',
			hidden	   : true
		},{
			fieldLabel   : '<t:message code="system.label.purchase.seq" default="순번"/>',
			name		 : 'INSPEC_SEQ',
			xtype		: 'uniTextfield',
			hidden	   : true
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
	});

	/** 查询窗口条件表单
	 */
	var receiptNoSearch = Unilite.createSearchForm('receiptNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [{
			fieldLabel : '<t:message code="system.label.purchase.division" default="사업장"/>',
			name	   : 'DIV_CODE',
			xtype	  : 'uniCombobox',
			comboType  : 'BOR120',
			allowBlank : false
		},{
			fieldLabel	 : '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
			xtype		  : 'uniDateRangefield',
			startFieldName : 'INSPEC_DATE_FR',
			endFieldName   : 'INSPEC_DATE_TO',
			startDate	  : UniDate.get('startOfMonth'),
			endDate		: UniDate.get('today'),
			width		  : 315
		},
		Unilite.popup('CUST',{
			fieldLabel	 : '<t:message code="system.label.purchase.custom" default="거래처"/>',
			textFieldWidth : 170,
			validateBlank  : false
		}),
		Unilite.popup('DIV_PUMOK',{
			fieldLabel	 : '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			textFieldWidth : 170,
			validateBlank  : false
		}),{
			fieldLabel : '<t:message code="system.label.purchase.inspectype" default="검사유형"/>',
			name	   : 'INSPEC_TYPE',
			xtype	  : 'uniCombobox',
			comboType  : 'AU',
			comboCode  : 'Q005'
		},{
			fieldLabel : '<t:message code="system.label.purchase.passyn" default="합격여부"/>',
			name	   : 'GOODBAD_TYPE',
			xtype	  : 'uniCombobox',
			comboType  : 'AU',
			comboCode  : 'M414'
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
	}); // createSearchForm

	/** 接收参考条件表单
	 */
	var receiptSearch = Unilite.createSearchForm('receiptForm', {//접수참조
		layout :  {type : 'uniTable', columns : 3},
		items :[
			Unilite.popup('CUST',{
				fieldLabel	 : '<t:message code="system.label.purchase.custom" default="거래처"/>',
				textFieldWidth : 170,
				validateBlank  : false
			}),
			Unilite.popup('DIV_PUMOK',{
				fieldLabel	 : '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				textFieldWidth : 170,
				validateBlank  : false
			}),{
				fieldLabel	 : '품목계정',
				name		   : 'ITEM_ACCOUNT',
				xtype		  : 'uniCombobox',
				comboType	  : 'AU',
				comboCode	  : 'B020'
			},{
				fieldLabel	 : '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
				xtype		  : 'uniDateRangefield',
				startFieldName : 'RECEIPT_DATE_FR',
				endFieldName   : 'RECEIPT_DATE_TO',
				startDate	  : UniDate.get('startOfMonth'),
				endDate		: UniDate.get('today'),
				width		  : 315
			},{
				fieldLabel	 : '<t:message code="system.label.purchase.poclass" default="발주유형"/>',
				name		   : 'ORDER_TYPE',
				xtype		  : 'uniCombobox',
				comboType	  : 'AU',
				comboCode	  : 'M001'
			},{
				fieldLabel	 : '<t:message code="system.label.purchase.lotno" default="LOT번호"/>',
				xtype		  : 'uniTextfield',
				name		   : 'LOT_NO'
			},{
				fieldLabel   : '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		 : 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				hidden	   : true
			}
		]
	});



	/** 主列表grid
	 */
	var masterGrid = Unilite.createGrid('mms203ukrvGrid1', {
		// for tab
		layout : 'fit',
		region : 'center',
		uniOpt: {
			useLiveSearch : true,
			expandLastColumn: false,
			useRowNumberer: false
		},
		tbar: [{
					fieldLabel: '<t:message code="system.label.product.receiptwarehouse" default="입고창고"/>',
					name:'GOOD_WH_CODE',
					labelWidth: 70,
					id: 'receiveGoodWhCode',
					xtype: 'uniCombobox',
					comboType   : 'OU',
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							masterForm.setValue('GOOD_WH_CODE',newValue);
						},
                        beforequery:function( queryPlan, eOpts )   {
                            var store = queryPlan.combo.store;
                                store.clearFilter();
                            if(!Ext.isEmpty(masterForm.getValue('DIV_CODE'))){
                                store.filterBy(function(record){
                                return record.get('option') == masterForm.getValue('DIV_CODE');
                           		 })
                            }else{
                                store.filterBy(function(record){
                                return false;
                           		 })
                            }
                        }
					}
				},{
	                xtype: 'component',
	                tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' },
	                width: 20
	            },{
					fieldLabel: '<t:message code="system.label.product.badwarehouse" default="불량창고"/>',
					name:'BAD_WH_CODE',
					id: 'receiveBadWhCode',
					xtype: 'uniCombobox',
					labelWidth: 70,
					comboType   : 'OU',
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							masterForm.setValue('BAD_WH_CODE',newValue);
						},
                        beforequery:function( queryPlan, eOpts )   {
                            var store = queryPlan.combo.store;
                                store.clearFilter();
                            if(!Ext.isEmpty(masterForm.getValue('DIV_CODE'))){
                                store.filterBy(function(record){
                                return record.get('option') == masterForm.getValue('DIV_CODE');
                            	})
                            }else{
                                store.filterBy(function(record){
                                return false;
                            	})
                        	}
                        }
					}
				},{
	                xtype: 'component',
	                tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' },
	                width: 30
	            },{
					itemId: 'receiptBtn',
					text: '<div style="color: blue"><t:message code="system.label.purchase.receiptrefer" default="접수참조"/></div>',
					handler: function() {
						if(masterForm.setAllFieldsReadOnly(true)){
							openReceiptWindow();
						}
					}
				},'-'],
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'INSPEC_NUM'		, width: 120, hidden: true},
			{dataIndex: 'INSPEC_SEQ'		, width: 60, align:"center"},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'LOT_NO'			, width: 120,
				getEditor: function(record) {
					return getLotPopupEditor(BsaCodeInfo.gsManageLotNoYN);
				}
			},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'INSPEC_TYPE'		, width: 90},
			{dataIndex: 'GOODBAD_TYPE'		, width: 90},
			{dataIndex: 'END_DECISION'		, width: 90},
			{dataIndex: 'RECEIPT_Q'			, width: 100},
			{dataIndex: 'NOR_RECEIPT_Q'		, width: 100, hidden: true},
			{dataIndex: 'FREE_RECEIPT_Q'	, width: 100, hidden: true},
			{dataIndex: 'ORDER_UNIT'		, width: 80,align:"center"},
			{dataIndex: 'TRNS_RATE'			, width: 100},
			{dataIndex: 'INSPEC_Q'			, width: 120},
			{dataIndex: 'COLLECT_Q'			, width: 120, hidden: true}, // 20210217 채취수량(COLLECT_Q) 추가, 2021.07.23 해당 채취수량에 대해 수불발생 안되고, 재고도 반영 안되고 있으므로 우선 히든 처리
			{dataIndex: 'NOR_COLLECT_Q'		, width: 120,hidden:true}, // 20210304 정상 채취수량(NOR_COLLECT_Q) 추가
			{dataIndex: 'FREE_COLLECT_Q'	, width: 120,hidden:true}, // 20210304 무상 채취수량(FREE_COLLECT_Q) 추가
			{dataIndex: 'BAD_INSPEC_Q'		, width: 120},
			{dataIndex: 'NOR_BAD_INSPEC_Q'	, width: 120,hidden:true},
			{dataIndex: 'FREE_BAD_INSPEC_Q'	, width: 120,hidden:true},
			{dataIndex: 'BAD_INSPEC_PER'	, width: 120, hidden: true},
			{dataIndex: 'GOOD_INSPEC_Q'		, width: 120},
			{dataIndex: 'NOR_GOOD_INSPEC_Q'	, width: 120,hidden:true},
			{dataIndex: 'FREE_GOOD_INSPEC_Q', width: 120,hidden:true},
			{dataIndex: 'STOCK_UNIT'		, width: 80,align:'center'},
			{dataIndex: 'INSTOCK_Q'			, width: 100},
			{dataIndex: 'INSPEC_PRSN'		, width: 100},
			{dataIndex: 'CUSTOM_CODE'		, width: 120, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 120},
			{dataIndex: 'RECEIPT_NUM'		, width: 120},
			{dataIndex: 'RECEIPT_SEQ'		, width: 80, align:"center"},
			{dataIndex: 'MAKE_LOT_NO'		, width: 100},
			{dataIndex: 'MAKE_DATE'			, width: 100},
			{dataIndex: 'MAKE_EXP_DATE'		, width: 100},
			{dataIndex: 'REMARK'			, width: 180},
			{dataIndex: 'PROJECT_NO'		, width: 120,
				getEditor : function(record){
					return getPjtNoPopupEditor();
				}
			},
			{dataIndex: 'INSPEC_DATE'		, width: 80, hidden: true},
			{dataIndex: 'ORDER_TYPE'		, width: 80, hidden: true},
			{dataIndex: 'ORDER_NUM'			, width: 80, hidden: true},
			{dataIndex: 'ORDER_SEQ'			, width: 80, hidden: true, align:"center"},
			{dataIndex: 'ITEM_ACCOUNT'		, width: 80, hidden: false, align:"center"},
			{dataIndex: 'ITEM_LEVEL1'		, width: 80, hidden: true}
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(selectedMasterGrid);
					grid.changeFocusCls(oldGrid);
					selectedMasterGrid = girdNm;
					UniAppManager.setToolbarButtons('newData', false);
				});
			},
			cellclick: function() {
				selectedMasterGrid = 'mms203ukrvGrid1';

				if( directMasterStore1.isDirty() || directMasterStore2.isDirty() ) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}

				if(directMasterStore1.getCount() > 0)  {
					UniAppManager.setToolbarButtons(['delete'], true);
				}else {
					UniAppManager.setToolbarButtons(['delete'], false);
				}

			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ){
				masterSelectIdx = index;
			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0) {
					var record = selected[0];

					var param= masterForm.getValues();
					param.ITEM_CODE = selected[0].get('ITEM_CODE');
					param.INSPEC_NUM = record.get('INSPEC_NUM');
					param.INSPEC_SEQ = selected[0].get('INSPEC_SEQ');
					param.DIV_CODE = record.get('DIV_CODE');
					directMasterStore2.loadStoreRecords(record);
				}

				var record1 = masterGrid.getSelectedRecord();
				if(selected.length > 0)	{
					var record = selected[0];
					this.returnCell(record);
					directMasterStore2.loadData({})
					directMasterStore2.loadStoreRecords(record);
				} else {

				}
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom == true){
					if (UniUtils.indexOf(e.field,['REMARK','INSPEC_Q'/*'GOOD_INSPEC_Q'*/,'INSPEC_PRSN','INSPEC_TYPE','PROJECT_NO','END_DECISION'
					                             	, 'GOODBAD_TYPE','BAD_INSPEC_Q' ])){ // 20210217 채취수량(COLLECT_Q) 추가, 2021.07.23 채취수량 수정 못하도록 변경
						return true;
					} else {
						return false;
					}
				}else{
					if (UniUtils.indexOf(e.field,['REMARK','INSPEC_PRSN','PROJECT_NO','END_DECISION', 'GOODBAD_TYPE'/*,'GOOD_INSPEC_Q','BAD_INSPEC_Q'*/
					                             	 /*, 'COLLECT_Q'*/])){ // // 20210217 채취수량(COLLECT_Q) 추가
						return true;
					} else {
						return false;
					}
				}
				if(e.field == 'INSTOCK_Q') return false;
				if(UniUtils.indexOf(e.field,['LOT_NO'])){
					if(e.record.get("ITEM_CODE") == ''){
						alert('<t:message code="system.message.purchase.message028" default="품목코드를 입력 하십시오."/>');
						return false;
					}
					return true;
				}
				if(e.record.data.INSPEC_TYPE == '01'){
					return false;
				}else{
					return true;
				}
				if(e.record.data.INSPEC_TYPE == '02'){
					if(e.field == 'GOODBAD_TYPE') return true;
				}else if(e.record.data.INSTOCK_Q == e.record.data.INSPEC_Q){
					return false;
				}else{
					return false;
				}
				return false;
			}
		},
		returnCell: function(record){
			var inspecNum	= record.get("INSPEC_NUM");
			var inspecSeq	= record.get("INSPEC_SEQ");
			var itemCode	= record.get("ITEM_CODE");
			var itemAccount	= record.get("ITEM_ACCOUNT");
			var itemLevel1	= record.get("ITEM_LEVEL1");
			var orderType	= record.get("ORDER_TYPE");
		},
		setReceiptData:function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('INSPEC_NUM'			, '');
			grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('INSPEC_TYPE'			, record['INSPEC_METH_MATRL']);
			grdRecord.set('RECEIPT_Q'			, record['NOT_INSPEC_Q']);
			grdRecord.set('NOR_RECEIPT_Q'	    , record['NOR_RECEIPT_Q']);
			grdRecord.set('FREE_RECEIPT_Q'	    , record['FREE_RECEIPT_Q']);
			grdRecord.set('INSPEC_Q'			, record['NOT_INSPEC_STOCK_Q']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('RECEIPT_NUM'			, record['RECEIPT_NUM']);
			grdRecord.set('RECEIPT_SEQ'			, record['RECEIPT_SEQ']);
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('INSPEC_PRSN'			, masterForm.getValue('INSPEC_PRSN'));
			grdRecord.set('INSPEC_DATE'			, masterForm.getValue('INSPEC_DATE'));
			if(!Ext.isEmpty(masterForm.getValue('GOODBAD_TYPE'))){
				grdRecord.set('GOODBAD_TYPE'	, masterForm.getValue('GOODBAD_TYPE'));
			}else{
				grdRecord.set('GOODBAD_TYPE'	, '01');
			}
			grdRecord.set('GOOD_INSPEC_Q'		, record[('NOT_INSPEC_STOCK_Q')]);
			grdRecord.set('NOR_GOOD_INSPEC_Q'	, record['NOR_RECEIPT_Q']);
			grdRecord.set('FREE_GOOD_INSPEC_Q'	, record['FREE_RECEIPT_Q']);
			grdRecord.set('COLLECT_Q'		    , 0);  // 20210217 채취수량(COLLECT_Q) 추가
			grdRecord.set('NOR_COLLECT_Q'		, 0);  // 20210304 정상 채취수량(NOR_COLLECT_Q) 추가
			grdRecord.set('FREE_COLLECT_Q'		, 0);  // 20210304 무상 채취수량(FREE_COLLECT_Q) 추가
			grdRecord.set('BAD_INSPEC_Q'		, 0);
			grdRecord.set('INSTOCK_Q'			, 0);
			grdRecord.set('END_DECISION'		, '01');

			grdRecord.set('MAKE_LOT_NO'			, record['MAKE_LOT_NO']);
			grdRecord.set('MAKE_DATE'			, record['MAKE_DATE']);
			grdRecord.set('MAKE_EXP_DATE'		, record['MAKE_EXP_DATE']);
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('TEST_LEVEL1'			, record['TEST_LEVEL1']);
		}
	});//End of var masterGrid = Unilite.createGrid('mms203ukrvGrid1', {

	/** 主列表grid2
	 */
	var masterGrid2 = Unilite.createGrid('mms203ukrvGrid2', {
		layout: 'fit',
		region: 'south',
		uniOpt: {
			useLiveSearch : true,
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
			showSummaryRow: false
		}],
		store: directMasterStore2,
		columns: [
			{dataIndex: 'SAVE_FLAG'			, width: 66 ,hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 80 ,hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 66 ,hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 66 ,hidden: true},
			{dataIndex: 'INSPEC_NUM'		, width: 66 ,hidden: true},
			{dataIndex: 'INSPEC_SEQ'		, width: 66 ,hidden: true},
			{dataIndex: 'TEST_CODE'			, width: 200,
				listeners:{
					render:function(elm)	{
						var tGrid = elm.getView().ownerGrid;
						elm.editor.on('beforequery',function(queryPlan, eOpts)  {
							var store = queryPlan.combo.store;
							store.clearFilter();
							store.filterBy(function(item){
								return item.get('option') == panelResult.getValue('DIV_CODE');
							});
						})
					}
				}
			},
			{dataIndex: 'TEST_NAME'			, width: 105},
			{dataIndex: 'TEST_METH'			, width: 66 ,hidden: true},
			{dataIndex: 'TEST_COND'			, width: 200},
			{dataIndex: 'VALUE_TYPE'		, width: 90},
			{dataIndex: 'VALUE_POINT'		, width: 80},
			{dataIndex: 'TEST_COND_FROM'	, width: 90,
				renderer: function(value, metaData, record) {
					var formatStyle = '0,000'
					formatStyle = UniAppManager.app.fnFormatStyle(record.get('VALUE_POINT'));
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, formatStyle) + '</div>';
                }
            },
			{dataIndex: 'TEST_COND_TO'		, width: 90,
				renderer: function(value, metaData, record) {
					var formatStyle = '0,000'
					formatStyle = UniAppManager.app.fnFormatStyle(record.get('VALUE_POINT'));
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, formatStyle) + '</div>';
                }
            },
			{dataIndex: 'MEASURED_VALUE'	, width: 166,
				renderer: function(value, metaData, record) {
					var formatStyle = '0,000'
					formatStyle = UniAppManager.app.fnFormatStyle(record.get('VALUE_POINT'));
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, formatStyle) + '</div>';
                }
			},
			{dataIndex: 'SPEC'				, width: 166},
			{dataIndex: 'TEST_UNIT'		    , width: 100 ,hidden: true},
			{dataIndex: 'TEST_PRSN'		    , width: 100},
			{dataIndex: 'REVISION_DATE'		, width: 100},
			{dataIndex: 'BAD_INSPEC_Q'		, width: 100},
			{dataIndex: 'INSPEC_REMARK'		, width: 266},
			{dataIndex: 'MANAGE_REMARK'		, width: 266}

		],
		tbar: [{
			xtype: 'splitbutton',
			id:'selectListBtn',
			text: '검사정보 가져오기',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'selectListBtn1',
					text: '최근등록된 정보',
					handler: function() {
						var value = '1';
						UniAppManager.app.fnGetTestlistNew(value);
					}
				},{
					itemId: 'selectListBtn2',
					text: '품목별검사정보',
					handler: function() {
						var value = '2';
						UniAppManager.app.fnGetTestlistNew(value);
					}
				},{
					itemId: 'selectListBtn3',
					text: '분류별검사정보',
					handler: function() {
						var value = '3';
						UniAppManager.app.fnGetTestlistNew(value);
					}
				},{
					itemId: 'selectListBtn4',
					text: '표준검사정보',
					handler: function() {
						var value = '4';
						UniAppManager.app.fnGetTestlistNew(value);
					}
				}]
			})
		},'-',{     name: 'saveList',
		            id: 'saveListBtn',
		            text: '표준검사항목 저장',
		            xtype:'button',
		            handler: function() {
							Ext.MessageBox.show({
								msg : '기존 등록된 검사항목정보를 삭제후 신규저장하시겠습니까?' ,
								icon: Ext.Msg.WARNING,
								buttons : Ext.MessageBox.OKCANCEL,
								fn : function(buttonId) {
									switch (buttonId) {
										case 'ok' :
											if(directMasterStore1.isDirty() || directMasterStore2.isDirty())  {
												Unilite.messageBox('먼저 저장하셔야 표준검사항목 저장작업을 진행이 가능합니다.');
												break;
											}
											var selRecords = directMasterStore2.data.items;
											Ext.each(selRecords, function(selRecord, index) {

												selRecord.phantom = true;
												buttonStore.insert(index, selRecord);

												if(selRecords.length == index + 1) {
													buttonStore.saveStore();
												}
											})

											break;
										case 'cancel' :
											break;
									}
								},
								scope : this
							}); // MessageBox

		                }
		        }],

		listeners: {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					if(directMasterStore1.isDirty())  {
						alert('<t:message code="system.message.inventory.message032" default="검사내역을 먼저 저장하셔야 선택이 가능합니다."/>');
						return false;
					}
					var oldGrid = Ext.getCmp(selectedMasterGrid);
					grid.changeFocusCls(oldGrid);
					selectedMasterGrid = girdNm;
					UniAppManager.setToolbarButtons('newData', true);
				});
			},
			cellclick: function() {
				selectedMasterGrid = 'mms203ukrvGrid2';

				if( directMasterStore1.isDirty() || directMasterStore2.isDirty() )	{
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
				if(directMasterStore1.getCount() > 0)  {
					UniAppManager.setToolbarButtons(['delete'], true);
				}else {
					UniAppManager.setToolbarButtons(['delete'], false);
				}
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom){
					if (UniUtils.indexOf(e.field, ['TEST_CODE', 'MEASURED_VALUE', 'BAD_INSPEC_Q', 'INSPEC_REMARK', 'MANAGE_REMARK', 'VALUE_POINT'
												 , 'TEST_COND', 'TEST_COND_FROM', 'TEST_COND_TO','SPEC','TEST_PRSN'])) {
						return true;
					} else {
						return false;
					}
				} else {
					if (UniUtils.indexOf(e.field, ['MEASURED_VALUE', 'BAD_INSPEC_Q', 'INSPEC_REMARK', 'MANAGE_REMARK', 'VALUE_POINT'
												 , 'TEST_COND', 'TEST_COND_FROM', 'TEST_COND_TO','SPEC','TEST_PRSN'])) {
						return true;
					} else {
						return false;
					}
				}
			},
		setCheckItemData: function(record) {						// 검사항목
			var grdRecord = this.getSelectedRecord();
//			var records = detailStore2.data.items;
//			if(records.BAD_INSPEC_CODE != record['SUB_CODE']) {	//////////////////////////////////////// 레코드에 있는 값이면 빼고 SET됨.
			grdRecord.set('DIV_CODE'		, masterForm.getValue('DIV_CODE'));
			grdRecord.set('INSPEC_NUM'		, masterForm.getValue('INSPEC_NUM'));
			grdRecord.set('INSPEC_SEQ'		, masterForm.getValue('INSPEC_SEQ_TEMP'));
			grdRecord.set('BAD_INSPEC_CODE'	, record['SUB_CODE']);
			grdRecord.set('BAD_INSPEC_NAME'	, record['CODE_NAME']);
			grdRecord.set('SPEC'			, '');
			grdRecord.set('MEASURED_VALUE'	, '');
			grdRecord.set('BAD_INSPEC_Q'	, '0');
			grdRecord.set('INSPEC_REMARK'	, '');
			grdRecord.set('MANAGE_REMARK'	, '');
			grdRecord.set('COMP_CODE'		, UserInfo.compCode);
			grdRecord.set('GUBUN'			, '');
			selectedMasterGrid = 'mms203ukrvGrid2';
//			}
		},
		checkDupleCode: function(record) {
			var isSuccess = true;
			var records = directMasterStore2.data.items;

			Ext.each(records, function(record2,i) {
				if(record.data['SUB_CODE'] == record2.data['BAD_INSPEC_CODE'] ) {
					isSuccess = false;
					return isSuccess;
				}
			});
			if(isSuccess){
				return true;
			}else{
				return false;
			}
		}
		}
	});

	var buttonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'mms203ukrvService.testcodeCopy',
			syncAll	: 'mms203ukrvService.copyAll'
		}
	});

	var buttonStore = Unilite.createStore('testlistButtonStore',{
		uniOpt: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy		: buttonProxy,
		saveStore	: function() {
//			var inValidRecs	= this.getInvalidRecords();
			var record = masterGrid.getSelectedRecord();
			var paramMaster = {'DIV_CODE' : record.get('DIV_CODE'),
							'ITEM_CODE'	: record.get('ITEM_CODE'),
						 	'REVISION_DATE': UniDate.getDbDateStr(record.get('INSPEC_DATE'))};

//			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success : function(batch, option) {
						Ext.getCmp('mms203ukrvApp').unmask();
						buttonStore.clearData();
					},
					failure: function(batch, option) {
						Ext.getCmp('mms203ukrvApp').unmask();
						buttonStore.clearData();
					}
				};
				this.syncAllDirect(config);
//			}
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

	/** 查询窗口grid
	 */
	var receiptNoMasterGrid = Unilite.createGrid('mms203ukrvOrderNoMasterGrid', {	//조회버튼 누르면 나오는 조회창
		layout : 'fit',
		store  : receiptNoMasterStore,
		uniOpt:{
			useLiveSearch	: true,
			useGroupSummary  : true,
			expandLastColumn : false,
			useRowNumberer   : false,
			filter: {
				useFilter  : false,
				autoCreate : false
			},
			excel: {
				useExcel	  : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData	  : false,
				summaryExport : true
			}
		},
		columns:  [
			{ dataIndex: 'INSPEC_NUM'	, width:120},
			{ dataIndex: 'INSPEC_SEQ'	, width:50, align:"center"},
			{ dataIndex: 'INSPEC_DATE'	, width:85},
			{ dataIndex: 'CUSTOM_CODE'	, width:93,hidden:true},
			{ dataIndex: 'CUSTOM_NAME'	, width:133},
			{ dataIndex: 'ITEM_CODE'	, width:120},
			{ dataIndex: 'ITEM_NAME'	, width:150},
			{ dataIndex: 'SPEC'			, width:150},
			{ dataIndex: 'INSPEC_Q'		, width:80},
			// 20210217 채취수량(COLLECT_Q) 추가
			{ dataIndex: 'COLLECT_Q'    , width:80},
			{ dataIndex: 'GOOD_INSPEC_Q', width:80},
			{ dataIndex: 'BAD_INSPEC_Q'	, width:80},
			{ dataIndex: 'INSPEC_TYPE'	, width:90},
			{ dataIndex: 'INSPEC_PRSN'	, width:66, hidden:true},
			{ dataIndex: 'RECEIPT_NUM'	, width:120},
			{ dataIndex: 'RECEIPT_SEQ'	, width:80, align:"center"},
			{ dataIndex: 'LOT_NO'		, width:80}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				receiptNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			masterForm.setValues({
				'INSPEC_DATE' : record.get('INSPEC_DATE'),
				'INSPEC_DATE' : record.get('INSPEC_DATE'),
				'INSPEC_NUM'  : record.get('INSPEC_NUM'),
				'ITEMCODE'	: record.get('ITEM_CODE'),
				'INSPEC_PRSN' : record.get('INSPEC_PRSN'),
				'DIV_CODE' : record.get('DIV_CODE')
			});
			panelResult.setValues({
				'INSPEC_DATE' : record.get('INSPEC_DATE'),
				'INSPEC_NUM'  : record.get('INSPEC_NUM'),
				'ITEMCODE'	: record.get('ITEM_CODE'),
				'INSPEC_PRSN' : record.get('INSPEC_PRSN'),
				'DIV_CODE' : record.get('DIV_CODE')
			});
		}
	});

	/** 接收参考grid
	 */
	var receiptGrid = Unilite.createGrid('mms203ukrvOtherorderGrid', {//접수참조
		layout	: 'fit',
		store	: receiptStore,
		uniOpt	: {
			useLiveSearch		: true,
			expandLastColumn	: false,
			onLoadSelectFirst	: false,
			useRowNumberer		: false
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns	: [
			{ dataIndex: 'CUSTOM_CODE'			, width:93,hidden:true},
			{ dataIndex: 'CUSTOM_NAME'			, width:93},
			{ dataIndex: 'ITEM_CODE'			, width:120},
			{ dataIndex: 'ITEM_NAME'			, width:150},
			{ dataIndex: 'SPEC'					, width:150},
			{ dataIndex: 'RECEIPT_DATE'			, width:85},
			{ dataIndex: 'INSPEC_METH_MATRL'	, width:73},
			{ dataIndex: 'INSPEC_Q'				, width:100},
			{ dataIndex: 'NOR_RECEIPT_Q'		, width:100,hidden:true},
			{ dataIndex: 'FREE_RECEIPT_Q'		, width:100,hidden:true},
			{ dataIndex: 'ORDER_UNIT'			, width:73,align:"center"},
			{ dataIndex: 'TRNS_RATE'			, width:73,align:"right"},
			{ dataIndex: 'NOT_INSPEC_Q'			, width:100},
			{ dataIndex: 'NOT_INSPEC_STOCK_Q'	, width:120},
			{ dataIndex: 'RECEIPT_NUM'			, width:120},
			{ dataIndex: 'RECEIPT_SEQ'			, width:80,align:"center"},
			{ dataIndex: 'LOT_NO'				, width:120},
			{ dataIndex: 'ORDER_TYPE'			, width:100},
			{ dataIndex: 'ORDER_NUM'			, width:120,hidden:true},
			{ dataIndex: 'ORDER_SEQ'			, width:80,hidden:true},
			{ dataIndex: 'MAKE_LOT_NO'			, width: 100},
			{ dataIndex: 'MAKE_DATE'			, width: 100},
			{ dataIndex: 'MAKE_EXP_DATE'		, width: 100},
			{ dataIndex: 'REMARK'				, width:133},
			{ dataIndex: 'PROJECT_NO'			, width:120},
			{ dataIndex: 'WH_CODE'				, width:100,hidden:true},
			{ dataIndex: 'ITEM_ACCOUNT'			, width:100,hidden:true},
			{ dataIndex: 'ITEM_LEVEL1'			, width:100,hidden:true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setReceiptData(record.data);
			});
			this.getStore().remove(records);
		}
	});



	/** 查询窗口查询
	 */
	function openSearchInfoWindow() {		//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title  : '<t:message code="system.label.purchase.inspecnoinquiry" default="검사번호검색"/>',
				width  : 1080,
				height : 580,
				layout : {type:'vbox', align:'stretch'},
				items: [receiptNoSearch, receiptNoMasterGrid], //receiptNoDetailGrid],
				tbar:  ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						if(receiptNoSearch.setAllFieldsReadOnly(true)){
							receiptNoMasterStore.loadStoreRecords();
						}
					},
					disabled: false
				}/*,{
					itemId : 'confirmBtn',
					text: '확인',
					handler: function() {
						var record = receiptNoMasterGrid.getSelectedRecord();
						if(record){
							receiptNoMasterGrid.returnData(record);
							UniAppManager.app.onQueryButtonDown();
						}
						SearchInfoWindow.hide();

					},
					disabled: false
				}*/, {
					itemId : 'OrderNoCloseBtn',
					text: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						receiptNoSearch.clearForm();
						receiptNoMasterGrid.reset();
						//receiptNoDetailGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						receiptNoSearch.clearForm();
						receiptNoMasterGrid.reset();
						//receiptNoDetailGrid.reset();
					},
					show: function( panel, eOpts ) {
						receiptNoSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
						receiptNoSearch.setValue('GOODBAD_TYPE',masterForm.getValue('GOODBAD_TYPE'));
						receiptNoSearch.setValue('INSPEC_TYPE',masterForm.getValue('INSPEC_TYPE'));
						receiptNoSearch.setValue('INSPEC_DATE_FR', UniDate.get('startOfMonth', masterForm.getValue('INSPEC_DATE')));
						receiptNoSearch.setValue('INSPEC_DATE_TO',masterForm.getValue('INSPEC_DATE'));
					 }
				}
			})
		}
		SearchInfoWindow.show();
		SearchInfoWindow.center();
	}

	/** 接收参考查询
	 */
	function openReceiptWindow() {			//접수참조
		if(!referReceiptWindow) {
			referReceiptWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.purchase.receiptrefer" default="접수참조"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [receiptSearch, receiptGrid],
				tbar	: ['->', {
					itemId : 'saveBtn',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						receiptStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmBtn',
					text: '<t:message code="system.label.purchase.inspecapply" default="검사적용"/>',
					handler: function() {
						receiptGrid.returnData();
					},
					disabled: false
				},{
					itemId : 'confirmCloseBtn',
					text: '<t:message code="system.label.purchase.inspecapplyclose" default="검사적용 후 닫기"/>',
					handler: function() {
						receiptGrid.returnData();
						referReceiptWindow.hide();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler: function() {
						referReceiptWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						//receiptSearch.clearForm();
						//receiptGrid,reset();
					},
					beforeclose: function( panel, eOpts ) {
						//receiptSearch.clearForm();
						//receiptGrid,reset();
					},
					beforeshow: function ( me, eOpts ) {
						receiptSearch.setValue("DIV_CODE", masterForm.getValue("DIV_CODE"));
						receiptStore.loadStoreRecords();
					}
				}
			})
		}
		referReceiptWindow.show();
		referReceiptWindow.center();
	}


	var linkedStore = Unilite.createStore('linkedStore', {
		model: 'mms203ukrvRECEIPTModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 'mms203ukrvService.selectreceiptList'
			}
		},
		loadStoreRecords : function(param) {
			this.load({
				params : param,
				callback: function(records, operation, success) {
					if(!Ext.isEmpty(records)) {
						masterGrid.reset();
						linkedStore.clearData();
						Ext.each(records, function(record,i){
							UniAppManager.app.onNewDataButtonDown();
							masterGrid.setReceiptData(record.data);
						});
					}
				}
			});
		}
	});


	/** 主处理
	 */
	Unilite.Main({
		id : 'mms203ukrvApp',
		borderItems:[{
			region : 'center',
			layout : 'border',
			border : false,
			items  : [
				masterGrid, masterGrid2, panelResult
			]
		},masterForm],
		fnInitBinding : function(param) {

			masterForm.setValue('INSPEC_PRSN',BsaCodeInfo.gsInspecPrsn);
			panelResult.setValue('INSPEC_PRSN',BsaCodeInfo.gsInspecPrsn);

			if(!Ext.isEmpty(param) && !Ext.isEmpty(param.RECEIPT_DATE) && !Ext.isEmpty(param.RECEIPT_NUM)){
				linkedStore.loadStoreRecords(param);
			}

			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('INSPEC_DATE',UniDate.get("today"));
			panelResult.setValue('INSPEC_DATE',UniDate.get("today"));
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['deleteAll', 'save'], false);

//			Ext.getCmp('selectListBtn').setDisabled(true);
			Ext.getCmp('saveListBtn').setDisabled(true);

		},
		onQueryButtonDown: function() {
			masterForm.setAllFieldsReadOnly(false);
			/* if(!Ext.isEmpty(panelResult.getValue('INSPEC_NUM'))){
				masterForm.setValue('INSPEC_NUM',panelResult.getValue('INSPEC_NUM'));
			} */
			var inspecNo = masterForm.getValue('INSPEC_NUM');
			if(Ext.isEmpty(inspecNo)) {
				openSearchInfoWindow()
			} else {
//				masterGrid.reset();
//				masterGrid2.reset();
				masterSelectIdx = 0;
				directMasterStore1.loadStoreRecords();
			};
		},
		onNewDataButtonDown: function() {
			if(selectedMasterGrid == 'mms203ukrvGrid1' )	{
				var inspecNum = masterForm.getValue('INSPEC_NUM');
				var seq = directMasterStore1.max('INSPEC_SEQ');
				if(!seq) seq = 1;
				else  seq += 1;
				var r = {
					INSPEC_SEQ: seq
				 };
				masterGrid.createRow(r,'ITEM_CODE',seq-2);
			} else {
				var compCode	= UserInfo.compCode;
				var divCode		= masterForm.getValue('DIV_CODE');
				var r = {
					COMP_CODE	: compCode,
					DIV_CODE	: divCode,
					SAVE_FLAG   : 'N'
				};
				masterGrid2.createRow(r);
			}
			masterForm.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterGrid2.reset();
			masterGrid.getStore().clearData();
			masterGrid2.getStore().clearData();
			Ext.getCmp('receiveBadWhCode').setValue('');
			Ext.getCmp('receiveGoodWhCode').setValue('');
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(directMasterStore1.isDirty()){
				directMasterStore1.saveStore();
			}else if(directMasterStore2.isDirty()){
				directMasterStore2.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			if(selectedMasterGrid == 'mms203ukrvGrid1' ) {
				var selRow = masterGrid.getSelectedRecord();

				if(selRow.phantom === true) {
					masterGrid.deleteSelectedRow();
					return;
				}

				Ext.Msg.confirm('<t:message code="system.label.purchase.delete" default="삭제"/>', '<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>' ,function(btn){
					if (btn == 'yes') {
						var divCode = masterForm.getValue('DIV_CODE');
						var inspecNum = selRow.get('INSPEC_NUM');
						var inspecSeq = selRow.get('INSPEC_SEQ');
						UniAppManager.app.fnInspecQtyCheck2(selRow, divCode, inspecNum, inspecSeq )

						/*  if(selRow.get('INSTOCK_Q') > 1){
							alert('입고수량: ' + selRow.get('INSTOCK_Q'));
							alert('<t:message code="system.message.purchase.message065" default="입고된 수량이 존재합니다. 삭제 할 수 없습니다."/>');
						}else{
							masterGrid.deleteSelectedRow();
						} */
					}
				})
			}else{
				var selRow = masterGrid2.getSelectedRecord();
				if(selRow) {
					if(selRow.phantom === true) {
							masterGrid2.deleteSelectedRow();
					}else {
						if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
							masterGrid2.deleteSelectedRow();
						}
					}
				}
			}

		},
		onDeleteAllButtonDown: function() {
			if(confirm('시험 결과를 전체삭제 하시겠습니까?')) {
				masterGrid.reset();
				masterGrid2.reset();
				UniAppManager.app.onSaveDataButtonDown('no');
				UniAppManager.app.onResetButtonDown();
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		fnFormatStyle:function(value) {
		    	if(value == 1){
					formatStyle = '0,000.0';
		    	}else if(value == 2){
		    		formatStyle = '0,000.00';
		    	}else if(value == 3){
		    		formatStyle = '0,000.000';
		    	}else if(value == 4){
		    		formatStyle = '0,000.0000';
		    	}else if(value == 5){
		    		formatStyle = '0,000.00000';
		    	}else if(value == 6){
		    		formatStyle = '0,000.000000';
		    	}else if(value == 7){
		    		formatStyle = '0,000.0000000';
		    	}else if(value == 8){
		    		formatStyle = '0,000.00000000';
		    	}else if(value == 9){
		    		formatStyle = '0,000.000000000';
		    	}else{
		    		formatStyle = '0,000';
		    	}
		    	return formatStyle;
		},
		fnGetTestlistNew:function(value) {
		   	var record = masterGrid.getSelectedRecord();
		   	var searchParam = Ext.getCmp('searchForm').getValues();

			var param = {	'DIV_CODE' : record.get('DIV_CODE'),
							'ITEM_CODE'	: record.get('ITEM_CODE'),
							'INSPEC_NUM'	: record.get('INSPEC_NUM'),
							'INSPEC_SEQ'	: record.get('INSPEC_SEQ'),
							'SELECT_GUBUN' :value,
							'ITEM_LEVEL1' : record.get('ITEM_LEVEL1'),
						 	'REVISION_DATE': searchParam.INSPEC_DATE};

			mms203ukrvService.selectTestListNew(param, function(provider, response) {
				var records = response.result;
				if(directMasterStore1.isDirty()){
					Unilite.messageBox('<t:message code="system.message.sales.message032" default="저장작업 선행후 처리하시기 바랍니다."/>');
					return false;
				}
				if(directMasterStore1.getCount() != 0){
						if(!Ext.isEmpty(provider)) {
						masterGrid2.reset();
						directMasterStore2.clearData();
						   Ext.each(records, function(record,i) {
	   								var r = {
										SAVE_FLAG      : record.SAVE_FLAG,
										COMP_CODE      : record.COMP_CODE,
										DIV_CODE       : record.DIV_CODE,
										INSPEC_NUM     : record.INSPEC_NUM,
										INSPEC_SEQ     : record.INSPEC_SEQ,
										TEST_CODE      : record.TEST_CODE,
										TEST_NAME      : record.TEST_NAME,
										TEST_METH      : record.TEST_METH,
										TEST_COND      : record.TEST_COND,
										VALUE_TYPE     : record.VALUE_TYPE,
										VALUE_POINT    : record.VALUE_POINT,
										TEST_COND_FROM : record.TEST_COND_FROM,
										TEST_COND_TO   : record.TEST_COND_TO,
										MEASURED_VALUE : record.MEASURED_VALUE,
										SPEC           : record.SPEC,
										TEST_UNIT      : record.TEST_UNIT,
										TEST_PRSN      : record.TEST_PRSN,
										REVISION_DATE  : record.REVISION_DATE,
										BAD_INSPEC_Q   : record.BAD_INSPEC_Q,
										INSPEC_REMARK  : record.INSPEC_REMARK,
										MANAGE_REMARK  : record.MANAGE_REMARK

									};

				            	masterGrid2.createRow(r);

						   })
						}
					}
					})
		},
		fnInspecQtyCheck: function(rtnRecord, fieldName, oldValue, divCode, inspecNum, inspecSeq, msgFlag) {
			var param = {
				'DIV_CODE'   : divCode,
				'INSPEC_NUM' : inspecNum,
				'INSPEC_SEQ' : inspecSeq
			}
			mms203ukrvService.inspecQtyCheck(param, function(provider, response){
				if(!Ext.isEmpty(provider) && provider.length > 0 ) {
					if(msgFlag == 'inspectList'){
						alert("입고된 수량이 존재합니다. 검사수량을 변경할 수 없습니다.");
						rtnRecord.set(fieldName, oldValue);
					}else{
						alert('<t:message code="system.message.purchase.message065" default="입고된 수량이 존재합니다. 삭제 할 수 없습니다."/>');
						rtnRecord.set(fieldName, oldValue);
					}

				}else{
					UniAppManager.app.fnCheckIsModify();
				}
			})
		},
		fnInspecQtyCheck2: function(rtnRecord, divCode, inspecNum, inspecSeq) {
			var isErr = true;
			var param = {
				'DIV_CODE'   : divCode,
				'INSPEC_NUM' : inspecNum,
				'INSPEC_SEQ' : inspecSeq
			}
			mms203ukrvService.inspecQtyCheck(param, function(provider, response){
				if(!Ext.isEmpty(provider) && provider.length > 0 ) {
						alert('<t:message code="system.message.purchase.message065" default="입고된 수량이 존재합니다. 삭제 할 수 없습니다."/>');
						isErr = false;
				}else{
					masterGrid.deleteSelectedRow();
				}
			})
			return isErr;
		},
		fnInspecQtyCheck3: function(rtnRecord, fieldName, oldValue, divCode, inspecNum, inspecSeq, msgFlag) {
			var param = {
					'DIV_CODE'   : divCode,
					'INSPEC_NUM' : inspecNum,
					'INSPEC_SEQ' : inspecSeq
				}
				mms203ukrvService.inspecQtyCheck(param, function(provider, response){
						UniAppManager.app.fnCheckIsModify();
				})
		},
		fnCheckIsModify:function(){
			var store1 = Ext.getCmp("mms203ukrvGrid1").getStore();
			var store2 = Ext.getCmp("mms203ukrvGrid2").getStore();
			if(store1.isDirty() || store2.isDirty()){
				UniAppManager.setToolbarButtons(['save'], true);
			}else{
				UniAppManager.setToolbarButtons(['save'], false);
			}
		}
	});//End of Unilite.Main( {



	/** 主列表1校验
	 */
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "MAKE_DATE" :
					if(!Ext.isEmpty(record.get('ITEM_CODE'))){
						if(!Ext.isEmpty(newValue)){
							var params = {
								'ITEM_CODE' : record.get('ITEM_CODE')
							};
							mms203ukrvService.selectExpirationdate(params, function(provider, response) {
								if(!Ext.isEmpty(provider) && provider.EXPIRATION_DAY != 0) {

									record.set('MAKE_EXP_DATE',UniDate.getDbDateStr(UniDate.add(newValue, {months: + provider.EXPIRATION_DAY , days:-1})));
								}else{
									//alert('유효기간을 설정하지 않은 품목입니다. 유효기간을 설정해주세요.');
									record.set('MAKE_EXP_DATE', '');
								}
							});
						}
					}else{
						rv ='작업지시를 할 품목을 입력해주세요.';
						break;
					}

				break;

				case "INSPEC_Q":
					if(newValue == '' || newValue < '1'){
						rv ='<t:message code="system.label.purchase.message064" default="접수량이 1보다 작거나 데이터가 없습니다."/>';
						break;
					}
					if(record.get('RECEIPT_Q') * record.get('TRNS_RATE') < newValue){
						rv ='<t:message code="system.message.purchase.message066" default="검사수량은 잔량보다 적어야 합니다."/>';
						break;
					}
//					if(record.get('INSPEC_Q') < getSumBadQty()){
//						rv ='<t:message code="system.message.purchase.message067" default="불량수량이 검사수량보다 많을 수 없습니다."/>';
//						record.set("INSPEC_Q", oldValue)
//						break;
//					}
					qtyUpdateByType(record)
					if(record.obj.phantom == false){
						var divCode = masterForm.getValue('DIV_CODE');
						var inspecNum = record.get('INSPEC_NUM');
						var inspecSeq = record.get('INSPEC_SEQ');
						UniAppManager.app.fnInspecQtyCheck(record, fieldName, oldValue, divCode, inspecNum, inspecSeq );
						break;
					}
					break;
				case "PROJECT_NO":
					UniAppManager.app.fnCheckIsModify();
					break;
				case "INSPEC_TYPE":
					if(record.get('INSPEC_TYPE') == '02'){
						record.set('GOODBAD_TYPE','01');
					}else{
						record.set('GOODBAD_TYPE','');
					}
					qtyUpdateByType(record)
					break;
				case "GOODBAD_TYPE":
					record.set('GOODBAD_TYPE', newValue);
					qtyUpdateByType(record)
					break;
				case "LOT_NO":
					UniAppManager.app.fnCheckIsModify();
					break;

				// 불량수량
				case "BAD_INSPEC_Q":

					// (접수량   - 채취수량) 보다 값이 큰 경우
					if(record.get('RECEIPT_Q') * record.get('TRNS_RATE') - record.get('COLLECT_Q') < newValue){
						rv ='불량수량은 잔량보다 작아야합니다.';
						break;
					}

					// 합격수량 세팅 ( 접수량  - 채취수량 - 불량수량 )
					record.set('GOOD_INSPEC_Q', record.get('RECEIPT_Q') * record.get('TRNS_RATE') - record.get('COLLECT_Q') - newValue);

					var receiptQ     = record.get('RECEIPT_Q') * record.get('TRNS_RATE');        // 전체 접수량
					var norReceiptQ  = record.get('NOR_RECEIPT_Q')  - record.get('NOR_COLLECT_Q');    // 정상 접수량
					var freeReceiptQ = record.get('FREE_RECEIPT_Q') - record.get('FREE_COLLECT_Q');;   // 무상 접수량

					if(norReceiptQ > 0 && freeReceiptQ > 0 && newValue == 0 && newValue < receiptQ){
						record.set('NOR_GOOD_INSPEC_Q', norReceiptQ);
						record.set('FREE_GOOD_INSPEC_Q', freeReceiptQ);
						record.set('NOR_BAD_INSPEC_Q', 0);
						record.set('FREE_BAD_INSPEC_Q', 0);

					}else if(norReceiptQ > 0 && freeReceiptQ == 0 && newValue > 0 && newValue < receiptQ){
						record.set('NOR_GOOD_INSPEC_Q', norReceiptQ - newValue);
						record.set('FREE_GOOD_INSPEC_Q', 0);
						record.set('NOR_BAD_INSPEC_Q', newValue);
						record.set('FREE_BAD_INSPEC_Q', 0);

					}else if(norReceiptQ == 0 && freeReceiptQ > 0 && newValue > 0 && newValue < receiptQ){
						record.set('NOR_GOOD_INSPEC_Q', 0);
						record.set('FREE_GOOD_INSPEC_Q', freeReceiptQ - newValue);
						record.set('NOR_BAD_INSPEC_Q', 0);
						record.set('FREE_BAD_INSPEC_Q', newValue);

					}else if(norReceiptQ > 0 && freeReceiptQ > 0 && newValue > 0 && newValue <= freeReceiptQ && newValue < receiptQ){
						record.set('NOR_GOOD_INSPEC_Q', norReceiptQ);
						record.set('FREE_GOOD_INSPEC_Q', freeReceiptQ - newValue);
						record.set('NOR_BAD_INSPEC_Q', 0);
						record.set('FREE_BAD_INSPEC_Q', newValue);

					}else if(norReceiptQ > 0 && freeReceiptQ > 0 && newValue > 0 && newValue > freeReceiptQ && newValue < receiptQ){
						record.set('NOR_GOOD_INSPEC_Q', norReceiptQ - newValue);
						record.set('FREE_GOOD_INSPEC_Q', freeReceiptQ);
						record.set('NOR_BAD_INSPEC_Q', newValue);
						record.set('FREE_BAD_INSPEC_Q', 0);

					}else if(norReceiptQ > 0 && freeReceiptQ > 0 && newValue == receiptQ){
						record.set('NOR_GOOD_INSPEC_Q', 0);
						record.set('FREE_GOOD_INSPEC_Q', 0);
						record.set('NOR_BAD_INSPEC_Q', norReceiptQ);
						record.set('FREE_BAD_INSPEC_Q', freeReceiptQ);

					}else{
						record.set('NOR_GOOD_INSPEC_Q', norReceiptQ);
						record.set('FREE_GOOD_INSPEC_Q', freeReceiptQ);
						record.set('NOR_BAD_INSPEC_Q', 0);
						record.set('FREE_BAD_INSPEC_Q', 0);
					}

					break;
				case "GOOD_INSPEC_Q":
					if(newValue == '' || newValue < '1'){
						rv ='합격수량이 1보다 작거나 데이터가 없습니다.';
						break;
					}
					if(record.get('RECEIPT_Q') * record.get('TRNS_RATE') < newValue){
						rv ='합격수량은 잔량보다 적어야 합니다';
						break;
					}
				break;

				// 20210218 채취수량(COLLECT_Q) 추가
				case "COLLECT_Q":

					// (접수량 - 불량수량) 보다 클 경우
					if(record.get('RECEIPT_Q') * record.get('TRNS_RATE') - record.get('BAD_INSPEC_Q') <= newValue){
						rv ='채취수량은 잔량보다 작아야합니다.';
						break;
					}

					// 합격수량 세팅 ( 접수량 - 불량수량 - 채취수량 )
					record.set('GOOD_INSPEC_Q', record.get('RECEIPT_Q') * record.get('TRNS_RATE') - record.get('BAD_INSPEC_Q') - newValue);

					var norReceiptQ   = record.get('NOR_RECEIPT_Q') - record.get('NOR_BAD_INSPEC_Q');    // 정상 접수량
					var freeReceiptQ  = record.get('FREE_RECEIPT_Q') - record.get('FREE_BAD_INSPEC_Q');   // 무상 접수량

					if(norReceiptQ > 0 && freeReceiptQ > 0){
						if(newValue <= freeReceiptQ && newValue != 0){
							record.set('NOR_GOOD_INSPEC_Q', norReceiptQ);
							record.set('FREE_GOOD_INSPEC_Q', freeReceiptQ - newValue);
							record.set('NOR_COLLECT_Q', 0);
							record.set('FREE_COLLECT_Q', newValue);
						}else if(newValue > freeReceiptQ && newValue != 0){
							record.set('NOR_GOOD_INSPEC_Q', norReceiptQ -(newValue - freeReceiptQ));
							record.set('FREE_GOOD_INSPEC_Q', 0);
							record.set('NOR_COLLECT_Q', newValue - freeReceiptQ);
							record.set('FREE_COLLECT_Q', freeReceiptQ);
						}else if(newValue == 0){
							record.set('NOR_GOOD_INSPEC_Q', norReceiptQ);
							record.set('FREE_GOOD_INSPEC_Q', freeReceiptQ);
							record.set('NOR_COLLECT_Q', 0);
							record.set('FREE_COLLECT_Q', 0);
						}

					}else if(norReceiptQ == 0 && freeReceiptQ > 0){
						record.set('NOR_GOOD_INSPEC_Q', norReceiptQ);
						record.set('FREE_GOOD_INSPEC_Q', freeReceiptQ - newValue);
						record.set('NOR_COLLECT_Q', 0);
						record.set('FREE_COLLECT_Q', newValue);

					}else if(norReceiptQ > 0 && freeReceiptQ == 0){

						record.set('NOR_GOOD_INSPEC_Q', norReceiptQ - newValue);
						record.set('FREE_GOOD_INSPEC_Q', freeReceiptQ);
						record.set('NOR_COLLECT_Q', newValue);
						record.set('FREE_COLLECT_Q', 0);
					}else{

						record.set('NOR_GOOD_INSPEC_Q', norReceiptQ);
						record.set('FREE_GOOD_INSPEC_Q', freeReceiptQ );
						record.set('NOR_COLLECT_Q', 0);
						record.set('FREE_COLLECT_Q', 0);
					}


					// 정상접수량 값이 존재할 경우
					/*if(norReceiptQ > 0){
						// 채취수량 == 0
						if(newValue == 0){
							record.set('NOR_GOOD_INSPEC_Q', norReceiptQ);

						// 정상 접수량 == 채취수량
						} else if(norReceiptQ == newValue){
							record.set('NOR_GOOD_INSPEC_Q', 0);

						// 정상 접수량 > 채취수량
						} else if(norReceiptQ > newValue){
							record.set('NOR_GOOD_INSPEC_Q', norReceiptQ - newValue);
						}
					} else {
						record.set('NOR_GOOD_INSPEC_Q', norReceiptQ);
					}*/

				break;
			}
			return rv;
		}
	});

	/** 主列表2校验
	 */
	Unilite.createValidator('validator02', {
		store: directMasterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(newValue == oldValue){
				return true;
			}
			var rv = true;
			switch(fieldName) {
				case "TEST_CODE" :
					var COMBO_TEST_CODE = Ext.data.StoreManager.lookup('COMBO_TEST_CODE2');// TEST_CODE COMBO STORID 가져오기
					Ext.each(COMBO_TEST_CODE.data.items, function(comboData, jdx) {
						if(comboData.get("value") == newValue){
							record.set('TEST_NAME'		, comboData.get('value'))
							record.set('TEST_COND'		, comboData.get('refCode1'))
							record.set('TEST_COND_FROM'	, comboData.get('refCode5'))
							record.set('TEST_COND_TO'	, comboData.get('refCode6'))
							record.set('SPEC'			, comboData.get('refCode7'))
						}
					});
				break;

				case "MEASURED_VALUE" : 											// 측정치
					var minValue = record.get('TEST_COND_FROM');
					var maxValue = record.get('TEST_COND_TO');

					if (minValue == 0 && maxValue ==0) {
						break;

					} else if ((!Ext.isEmpty(minValue) && minValue > newValue)				//시험기준 FROM 보다 측정치가 작을 경우
					 || (!Ext.isEmpty(maxValue) && maxValue < newValue)) {			//시험기준 TO 보다 측정치가 큰 경우

					 	var valueType = record.get('VALUE_TYPE');
					 	if(Ext.isEmpty(valueType) || (valueType == '1')){
					 		record.set('SPEC', '부적합');
					 	}else if(valueType == '2'){
					 		break;
					 	}else if(valueType == '3'){
					 		record.set('SPEC', newValue);
					 	}

					} else if (((!Ext.isEmpty(minValue) && !Ext.isEmpty(maxValue)) && minValue <= newValue && maxValue >= newValue)	//시험기준 FROM, TO 존재하고 입력값이 사이에 있을 때,
							 || (!Ext.isEmpty(minValue) && Ext.isEmpty(maxValue) && minValue <= newValue)							//시험기준 FROM 존재, TO 없고 입력값이 FROM 보다 클 때, - 빈 값일 경우 컬럼에 0이 들어가므로 필요없는 로직일 수도 있음;;
							 || (Ext.isEmpty(minValue) && !Ext.isEmpty(maxValue) && maxValue >= newValue)) {						//시험기준 FROM 없고, TO 존재 입력값이 TO 보다 작을 때, - 빈 값일 경우 컬럼에 0이 들어가므로 필요없는 로직일 수도 있음;;

					 	var valueType = record.get('VALUE_TYPE');
					 	if(Ext.isEmpty(valueType) || (valueType == '1')){
							var param = masterForm.getValues();
							param.TEST_CODE = record.get('TEST_CODE');
							s_pms402ukrv_kodiService.getTestResult(param, function(provider, response) {
								if(provider) {
									record.set('SPEC', provider);
								}
								console.log("response",response)
							})
					 	}else if(valueType == '2'){
					 		break;
					 	}else if(valueType == '3'){
					 		record.set('SPEC', newValue);
					 	}

					}
				break;

				case "BAD_INSPEC_Q":
					if(newValue < 0){
						rv ='<t:message code="system.message.purchase.message068" default="0보다 큰 값이 입력되어야 합니다."/>';
						record.set("BAD_INSPEC_Q", oldValue)
						break;
					}
					if(newValue == 0){
						record.set("BAD_INSPEC_Q", newValue);
					}
/*					//20190228 불량수량을 검사수량으로 대체. 상단 마스터그리드의 불량수량연계 끊기로 함.
					if(grdRecord.get('INSPEC_Q') < getSumBadQty()){
						rv ='<t:message code="system.message.purchase.message067" default="불량수량이 검사수량보다 많을 수 없습니다."/>';
						record.set("BAD_INSPEC_Q", oldValue)
						break;
					}
					//상단 그리드와 연계를 끊도록 함으로 입고량 체크 로직 주석처리
					if(record.obj.phantom == false){
						var divCode = masterForm.getValue('DIV_CODE');

						var inspecNum = grdRecord.get('INSPEC_NUM');
						var inspecSeq = grdRecord.get('INSPEC_SEQ');
						UniAppManager.app.fnInspecQtyCheck(record, fieldName, oldValue, divCode, inspecNum, inspecSeq, "inspectList");
						break;
					} */
					/*디테일 값 변경시 저장버튼 활성화를 위한 로직, 함수 실행하고 그 안에서 dirty체크 해야함 안 그러면 두번째 수정시에만 저장 버튼 활성화됨*/
					var grdRecord = Ext.getCmp("mms203ukrvGrid1").getSelectedRecord();
					var divCode = masterForm.getValue('DIV_CODE');
					var inspecNum = grdRecord.get('INSPEC_NUM');
					var inspecSeq = grdRecord.get('INSPEC_SEQ');
					UniAppManager.app.fnInspecQtyCheck3(record, fieldName, oldValue, divCode, inspecNum, inspecSeq, "inspectList");
					break;

				 case "INSPEC_REMARK":
					var store = Ext.getCmp("mms203ukrvGrid2").getStore();
					UniAppManager.app.fnCheckIsModify();
					break;
				 case "MANAGE_REMARK":
					UniAppManager.app.fnCheckIsModify();
					break;
			}
			return rv;
		}
	});



	function qtyUpdateByType(record){
		if(record.get('INSPEC_TYPE') == '01' || record.get('INSPEC_TYPE') == ''){
			record.set('GOOD_INSPEC_Q', record.get('RECEIPT_Q') * record.get('TRNS_RATE')  - record.get('BAD_INSPEC_Q'));
		}else if(record.get('INSPEC_TYPE') == '02'){
			if(record.get('GOODBAD_TYPE') == '01'){
				if(record.obj.phantom){
					record.set('GOOD_INSPEC_Q', record.get('RECEIPT_Q') * record.get('TRNS_RATE'));
					record.set('BAD_INSPEC_Q','0');
				}else{
					//record.set('GOOD_INSPEC_Q', record.get('RECEIPT_Q') * record.get('TRNS_RATE') - getSumBadQty());	//SumBadQty -> 불량수량합 구하는 함수 생성해야함
					//record.set('BAD_INSPEC_Q',getSumBadQty());
					record.set('GOOD_INSPEC_Q', record.get('RECEIPT_Q') * record.get('TRNS_RATE'));
					record.set('BAD_INSPEC_Q','0');
				}
			}else if(record.get('GOODBAD_TYPE') == '02'){
				record.set('GOOD_INSPEC_Q','0');
				record.set('BAD_INSPEC_Q',record.get('RECEIPT_Q') * record.get('TRNS_RATE') );
			}else if(record.get('GOODBAD_TYPE') == '03'){
				record.set('GOOD_INSPEC_Q','0');
				record.set('BAD_INSPEC_Q','0');
			}
		}
		UniAppManager.app.fnCheckIsModify();
	}

	/** 불량수량의 합을 구한다.
	 * 获取不良数合计
	 */
	function getSumBadQty(){
		var store = Ext.getCmp("mms203ukrvGrid2").getStore();
		var sumBadQty = 0;
		if(store){
			var items = store.data.items;
			for(i = 0; i <items.length; i++ ){
				sumBadQty += items[i].get("BAD_INSPEC_Q");
			}
		}
		return sumBadQty;
	}

	function getLotPopupEditor(gsManageLotNoYN){
		var editField;
		if(gsManageLotNoYN == "Y"){
			 editField = Unilite.popup('LOTNO_G',{
				 textFieldName: 'LOT_NO',
				 DBtextFieldName: 'LOT_NO',
				 autoPopup: true,
				 listeners: {
					'onSelected': {
						fn: function(record, type) {
							var selectRec = masterGrid.getSelectedRecord()
							if(selectRec){
								selectRec.set('LOT_NO', record[0]["LOT_NO"]);
								selectRec.set('GOOD_STOCK_Q', record[0]["GOOD_STOCK_Q"]);
								selectRec.set('BAD_STOCK_Q', record[0]["BAD_STOCK_Q"]);
							}
						},
						scope: this
					},
					'onClear': {
						fn: function(record, type) {
							var selectRec = masterGrid.getSelectedRecord()
							if(selectRec){
								selectRec.set('LOT_NO', '');
								selectRec.set('GOOD_STOCK_Q', 0);
								selectRec.set('BAD_STOCK_Q', 0);
//													UniAppManager.app.checkStockPrice(selectRec.data);
							}
						},
						scope: this
					},
					applyextparam: function(popup){
						var selectRec = masterGrid.getSelectedRecord();
						if(selectRec){
							popup.setExtParam({'DIV_CODE':  selectRec.get('DIV_CODE')});
							popup.setExtParam({'ITEM_CODE': selectRec.get('ITEM_CODE')});
							popup.setExtParam({'ITEM_NAME': selectRec.get('ITEM_NAME')});
							popup.setExtParam({'FR_INOUT_DATE': UniDate.get("startOfMonth", masterForm.getValue("INSPEC_DATE"))});
							popup.setExtParam({'FR_INOUT_DATE': masterForm.getValue("INSPEC_DATE")});
							popup.setExtParam({'stockYN': 'Y'});
						}
					}
				 }
			});
		}else if(gsManageLotNoYN == "N"){
			editField = {xtype : 'textfield', maxLength:20}
		}

		var editor = Ext.create('Ext.grid.CellEditor', {
			ptype: 'cellediting',
			clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
			autoCancel : false,
			selectOnFocus:true,
			field: editField
		});
		return editor;
	}

	function getPjtNoPopupEditor(){
		var editField = Unilite.popup('PROJECT_G',{
			DBtextFieldName: 'PROJECT_NO',
			textFieldName:'PROJECT_NO',
			autoPopup: true,
			listeners: {
				'applyextparam': function(popup){
					var masterGrid = Ext.getCmp("mms203ukrvGrid1");
					var selectRec = masterGrid.getSelectedRecord();
					if(selectRec){
						popup.setExtParam({'BPARAM0': 3});
						popup.setExtParam({'CUSTOM_CODE': selectRec.get("CUSTOM_CODE")});
						popup.setExtParam({'CUSTOM_NAME': selectRec.get("CUSTOM_NAME")});
					}
				},
				'onSelected': {
					fn: function(records, type) {
					},
					scope: this
				},
				'onClear': function(type){
					scope: this
				}
			}
		})

		var editor = Ext.create('Ext.grid.CellEditor', {
			ptype: 'cellediting',
			clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
			autoCancel : false,
			selectOnFocus:true,
			field: editField
		});
		return editor;
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
			}else{
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(true);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField')	;
						if(popupFC.holdable == 'hold') {
							popupFC.setReadOnly(true);
						}
					}
				});
			}
		} else {
			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) )	{
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
};
</script>