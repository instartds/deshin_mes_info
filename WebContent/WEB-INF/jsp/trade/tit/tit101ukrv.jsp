<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tit101ukrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="tit101ukrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="T029"/>			<!-- 신고자 -->
	<t:ExtComboStore comboType="AU" comboCode="T008"/>			<!-- 항구코드(선적항/도착항) -->
	<t:ExtComboStore comboType="AU" comboCode="T009"/>			<!-- 세관 -->
	<t:ExtComboStore comboType="B"  comboCode="B013"/>			<!-- 중량단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>			<!-- <t:message code="system.label.trade.packagingtype" default="포장형태"/> -->
	<t:ExtComboStore comboType="AU" comboCode="T005"/>			<!-- 가격조건 -->
	<t:ExtComboStore comboType="AU" comboCode="T016"/>			<!-- 결제방법 -->
	<t:ExtComboStore comboType="AU" comboCode="T006"/>			<!-- <t:message code="system.label.trade.paymentcondition" default="결제조건"/> -->
	<t:ExtComboStore comboType="AU" comboCode="T021"/>			<!-- 신고구분 -->
	<t:ExtComboStore comboType="AU" comboCode="T011"/>			<!-- 검사구분 -->
	<t:ExtComboStore comboType="AU" comboCode="T027"/>			<!-- <t:message code="system.label.trade.transporttype" default="운송형태"/> -->
	<t:ExtComboStore comboType="AU" comboCode="B012"/>			<!-- 선박국적 -->
	<t:ExtComboStore comboType="AU" comboCode="B001"/>			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="T109"/>			<!-- 국내외구분 -->
	<t:ExtComboStore comboType="AU" comboCode="T002"/>			<!-- 무역종류 -->
	<t:ExtComboStore comboType="AU" comboCode="T113"/>			<!-- 페이지링크 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var SearchInfoWindow		//검색 팝업
var SearchMasterReffWindow;	//master선적참조
var SearchDetailReffWindow;	//detail선적참조
var BsaCodeInfo = {
	gsOrderPrsn: '${gsOrderPrsn}'
};

function appMain() {

	var masterModel =Unilite.defineModel('masterModel', {		//masterForm과 그리드 연동시켜 놓은 모델
		fields: [
			{name: 'PASS_SER_NO'		, text: '<t:message code="system.label.trade.customsmanagementno" default="통관관리번호"/>'	, type: 'string'},
			{name: 'INVOICE_DATE'		, text: '<t:message code="system.label.trade.customdate" default="통관일"/>'				, type: 'uniDate', allowBlank: false, defaultValue: UniDate.get('today')},
			{name: 'INVOICE_NO'			, text: '<t:message code="system.label.trade.invoice2" default="INVOICE 번호"/>'			, type: 'string', allowBlank: false},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.trade.division" default="사업장"/>'					, type: 'string'},
			{name: 'EP_NO'				, text: '<t:message code="system.label.trade.epno" default="면허번호"/>'					, type: 'string'},
			{name: 'TRADE_TYPE'			, text: '<t:message code="system.label.trade.tradetype" default="무역종류"/>'				, type: 'string'},
			{name: 'PjctCD'				, text: '<t:message code="system.label.trade.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'EP_DATE'			, text: '<t:message code="system.label.trade.epdate" default="면허일"/>'					, type: 'uniDate'},
			{name: 'ED_DATE'			, text: '<t:message code="system.label.trade.reportdate" default="신고일"/>'				, type: 'uniDate'},
			{name: 'ED_NO'				, text: '<t:message code="system.label.trade.reportno" default="신고번호"/>'				, type: 'string'},
			//20191127 요청일, 도착일 필수 제외
			{name: 'APP_DATE'			, text: '<t:message code="system.label.trade.requestdate" default="요청일"/>'				, type: 'uniDate'/*, allowBlank: false*/, defaultValue: UniDate.get('today')},
			{name: 'DISCHGE_DATE'		, text: '<t:message code="system.label.trade.arrivaldate" default="도착일"/>'				, type: 'uniDate'/*, allowBlank: false*/},
			{name: 'SHIP_FIN_DATE'		, text: '<t:message code="system.label.trade.shipmentdate" default="선적일"/>'				, type: 'uniDate'},
			{name: 'REPORTOR'			, text: '<t:message code="system.label.trade.reporter" default="신고인(관세사)"/>'			, type: 'string'},
			{name: 'BL_SER_NO'			, text: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>'			, type: 'string'},
			{name: 'DEST_PORT'			, text: '<t:message code="system.label.trade.arrivalport" default="도착항"/>'				, type: 'string', allowBlank: false},
			{name: 'DEST_PORT_NM'		, text: '<t:message code="system.label.trade.arrivalport" default="도착항"/>'				, type: 'string', allowBlank: false},
			{name: 'SHIP_PORT'			, text: '<t:message code="system.label.trade.shipmentport" default="선적항"/>'				, type: 'string', allowBlank: false},
			{name: 'SHIP_PORT_NM'		, text: '<t:message code="system.label.trade.shipmentport" default="선적항"/>'				, type: 'string', allowBlank: false},
			{name: 'VESSEL_NATION_CODE'	, text: '<t:message code="system.label.trade.vesselnation" default="선박국적"/>'			, type: 'string'},
			{name: 'VESSEL_NM'			, text: '<t:message code="system.label.trade.vesselname" default="VESSEL명"/>'			, type: 'string'},
			{name: 'DEVICE_NO'			, text: '<t:message code="system.label.trade.deviceconfirmno" default="장치확인번호"/>'		, type: 'string'},
			{name: 'DEVICE_PLACE'		, text: '<t:message code="system.label.trade.deviceplace" default="장치장소"/>'				, type: 'string'},
			{name: 'CUSTOMS'			, text: '<t:message code="system.label.trade.customoffice" default="세관"/>'				, type: 'string'},
			{name: 'EXAM_TXT'			, text: '<t:message code="system.label.trade.investigation" default="조사란"/>'			, type: 'string'},
			{name: 'IMPORTER'			, text: '<t:message code="system.label.trade.importer" default="수입자"/>'					, type: 'string'},
			{name: 'IMPORTER_NM'		, text: '<t:message code="system.label.trade.importer" default="수입자"/>'					, type: 'string'},
			{name: 'EXPORTER'			, text: '<t:message code="system.label.trade.exporter" default="수출자"/>'					, type: 'string'},
			{name: 'EXPORTER_NM'		, text: '<t:message code="system.label.trade.exporter" default="수출자"/>'					, type: 'string'},
			{name: 'GROSS_WEIGHT'		, text: '<t:message code="system.label.trade.grossweight" default="총중량"/>'				, type: 'uniQty', defaultValue: 0},
			{name: 'WEIGHT_UNIT'		, text: '<t:message code="system.label.trade.weightunit" default="중량단위"/>'				, type: 'string'},
			{name: 'PACKING_TYPE'		, text: '<t:message code="system.label.trade.packagingtype" default="포장형태"/>'			, type: 'string'},
			{name: 'TOT_PACKING_COUNT'	, text: '<t:message code="system.label.trade.totalpackingcount" default="총포장갯수"/>'		, type: 'uniQty', defaultValue: 0},
			{name: 'PASS_AMT'			, text: '<t:message code="system.label.trade.customamount" default="통관금액"/>'			, type: 'uniFC'},
			{name: 'PASS_AMT_UNIT'		, text: '<t:message code="system.label.trade.currencyunit" default="화폐단위"/>'			, type: 'string', allowBlank: false, displayField: 'value'},
			{name: 'PASS_EXCHANGE_RATE'	, text: '<t:message code="system.label.trade.customexchangerate" default="통관환율"/>'		, type: 'string', allowBlank: false},
			{name: 'PASS_AMT_WON'		, text: '<t:message code="system.label.trade.exchangeamount" default="환산액 "/>'			, type: 'uniPrice', defaultValue: 0},
			{name: 'CIF_AMT'			, text: 'CIf <t:message code="system.label.trade.amount" default="금액"/>(USD)'			, type: 'uniFC', defaultValue: 0},
			{name: 'CIF_AMT_UNIT'		, text: 'Cif<t:message code="system.label.trade.currencyunit" default="화폐단위"/>'			, type: 'string'},
			{name: 'CIF_EXCHANGE_RATE'	, text: 'USD<t:message code="system.label.trade.exchangerate" default="환율"/>'			, type: 'string', defaultValue: '0'},
			{name: 'CIF_AMT_WON'		, text: 'CIf <t:message code="system.label.trade.localamount" default="원화금액"/>'			, type: 'uniPrice', defaultValue: 0},
			{name: 'PAY_METHODE'		, text: '<t:message code="system.label.trade.payingterm" default="결제방법"/>'				, type: 'string'},
			{name: 'TERMS_PRICE'		, text: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'			, type: 'string'},
			{name: 'PAY_TERMS'			, text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'		, type: 'string'},
			{name: 'PAY_DURING'			, text: '<t:message code="system.label.trade.period" default="기간"/>'					, type: 'string'},
			{name: 'EP_TYPE'			, text: '<t:message code="system.label.trade.statetype" default="신고구분"/>'				, type: 'string', allowBlank: false},
			{name: 'INSPECT_TYPE'		, text: '<t:message code="system.label.trade.inspecttype" default="검사구분"/>'				, type: 'string'},
			{name: 'FORM_TRANS'			, text: '<t:message code="system.label.trade.transporttype" default="운송형태"/>'			, type: 'string'},
			{name: 'TARIFF_TAX'			, text: '<t:message code="system.label.trade.customs" default="관세"/>'					, type: 'uniPrice'},
			{name: 'VALUE_TAX'			, text: '<t:message code="system.label.trade.vat" default="부가세"/>'						, type: 'uniPrice', defaultValue: 0},
			{name: 'INCOME_TAX'			, text: '<t:message code="system.label.trade.intaxi" default="소득세"/>'					, type: 'uniPrice', defaultValue: 0},
			{name: 'INHA_TAX'			, text: '<t:message code="system.label.trade.loctaxi" default="주민세"/>'					, type: 'uniPrice', defaultValue: 0},
			{name: 'EDUC_TAX'			, text: '<t:message code="system.label.trade.educationtax" default="교육세"/>'				, type: 'uniPrice', defaultValue: 0},
			{name: 'TRAF_TAX'			, text: '<t:message code="system.label.trade.traftax" default="교통세"/>'					, type: 'uniPrice', defaultValue: 0},
			{name: 'ARGRI_TAX'			, text: '<t:message code="system.label.trade.sptaxi" default="농특세"/>'					, type: 'uniPrice', defaultValue: 0},
			{name: 'INPUT_NO'			, text: '<t:message code="system.label.trade.inputno" default="반입번호"/>'					, type: 'string'},
			{name: 'INPUT_DATE'			, text: '<t:message code="system.label.trade.inputdate" default="반입일"/>'				, type: 'uniDate'},
			{name: 'OUTPUT_DATE'		, text: '<t:message code="system.label.trade.outputdate" default="반출일"/>'				, type: 'uniDate'},
			{name: 'PAYMENT_DATE'		, text: '<t:message code="system.label.trade.paymentdate" default="납부일"/>'				, type: 'uniDate'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.trade.deliverydate" default="납기일"/>'				, type: 'uniDate'},
			{name: 'TAXBILL_DATE'		, text: '<t:message code="system.label.trade.billissuedate" default="계산서발행일"/>'			, type: 'uniDate'},
			{name: 'TAXBILL_NO'			, text: '<t:message code="system.label.trade.billno" default="계산서번호"/>'					, type: 'string'},
			{name: 'REMARKS1'			, text: '<t:message code="system.label.trade.remarks" default="비고"/>1'					, type: 'string'},
			{name: 'REMARKS2'			, text: '<t:message code="system.label.trade.remarks" default="비고"/>2'					, type: 'string'},
			{name: 'REMARKS3'			, text: '<t:message code="system.label.trade.remarks" default="비고"/>3'					, type: 'string'},
			{name: 'OPR_FLAG'			, text: 'OPR_FLAG'		, type: 'string'},
			{name: 'PROJECT_NO'			, text: 'PROJECT_NO'	, type: 'string'},
			{name: 'SO_SER_NO'			, text: 'SO_SER_NO'		, type: 'string'},
			{name: 'LC_SER_NO'			, text: 'LC_SER_NO'		, type: 'string'},
			//20191125 추가
			{name: 'BL_NO'				, text: '<t:message code="system.label.trade.blno" default="B/L번호"/>'					, type: 'string'}
		]
	});

	var detailModel =Unilite.defineModel('detailModel', {		//mainGrid
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.trade.division" default="사업장"/>'					, type: 'string', comboType: "BOR120"},
			{name: 'PASS_SER_NO'		, text: '<t:message code="system.label.trade.customsmanagementno" default="통관관리번호"/>'	, type: 'string'},
			{name: 'PASS_SER'			, text: '<t:message code="system.label.trade.seq" default="순번"/>'						, type: 'int'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.trade.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.trade.itemname2" default="품명 "/>'					, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.trade.spec" default="규격"/>'						, type: 'string'},
			{name: 'UNIT'				, text: '<t:message code="system.label.trade.purchaseunit" default="구매단위"/>'			, type: 'string', comboType: "AU", comboCode: "B013", displayField: 'value'},
			{name: 'QTY'				, text: '<t:message code="system.label.trade.qty" default="수량"/>'						, type: 'uniQty'},
			{name: 'PRICE'				, text: '<t:message code="system.label.trade.price" default="단가 "/>'						, type: 'uniUnitPrice'},
			{name: 'PASS_AMT'			, text: '<t:message code="system.label.trade.amount" default="금액"/>'					, type: 'uniFC'},
			{name: 'PASS_EXCHANGE_RATE'	, text: '<t:message code="system.label.trade.exchangerate" default="환율"/>'				, type: 'uniER'},
			{name: 'PASS_AMT_WON'		, text: '<t:message code="system.label.trade.exchangeamount" default="환산액 "/>'			, type: 'uniPrice'},
			{name: 'HS_NO'				, text: '<t:message code="system.label.trade.hsno" default="HS번호"/>'					, type: 'string'},
			{name: 'HS_NAME'			, text: '<t:message code="system.label.trade.hsname" default="HS명"/>'					, type: 'string'},
			{name: 'BL_SER_NO'			, text: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>'			, type: 'string'},
			{name: 'BL_SER'				, text: '<t:message code="system.label.trade.blno2" default="B/L순번"/>'					, type: 'int'},
			{name: 'SO_SER_NO'			, text: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>'		, type: 'string'},
			{name: 'SO_SER'				, text: '<t:message code="system.label.trade.offerno2" default="OFFER행번"/>'				, type: 'int'},
			{name: 'USE_QTY'			, text: '<t:message code="system.label.trade.useqty" default="진행수량"/>'					, type: 'uniQty'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.trade.bondedwarehouse" default="보세창고"/>'			, type: 'string'},
			{name: 'TEMP_FLAG'			, text: 'TEMP_FLAG'		, type: 'string'}
		]
	});

	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'tit101ukrvService.selectMasterList',
			update	: 'tit101ukrvService.updateMaster',
			create	: 'tit101ukrvService.insertMaster',
			destroy	: 'tit101ukrvService.deleteMaster',
			syncAll	: 'tit101ukrvService.saveAll'
		}
	});

	var directMasterStore = Unilite.createStore('directMasterStore', {
		model	: 'masterModel',
		proxy	: directMasterProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param= panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
			update:function( store, record, operation, modifiedFieldNames, eOpts )  {
				if(directDetailStore.getCount() != 0 && !directDetailStore.isDirty()){
					directDetailStore.data.items[0].set('TEMP_FLAG', 'Y'); //마스터 저장만 발생할시 저장setvice로직 태우기 위해..
				}
				//20191203 날짜필드 수정 안되어 주석처리
//				masterForm.setActiveRecord(record);
			},
			load: function(store, records, successful, eOpts) {
				masterForm.setActiveRecord(records[0]);
				directDetailStore.loadStoreRecords();
				if(store.count() > 0){
					Ext.getCmp('linkBtn').setDisabled(false);
				}
				masterForm.setAllFieldsReadOnly(true);
			}
		}
	});

	var directDetailProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'tit101ukrvService.selectDetailList',
			update	: 'tit101ukrvService.updateDetail',
			create	: 'tit101ukrvService.insertDetail',
			destroy	: 'tit101ukrvService.deleteDetail',
			syncAll	: 'tit101ukrvService.saveAll'
		}
	});

	var directDetailStore = Unilite.createStore('directDetailStore', {
		model	: 'detailModel',
		proxy	: directDetailProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,	 	// 전체 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param= panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var passSerNo = masterForm.getValue('PASS_SER_NO');
			Ext.each(list, function(record, index) {
				if(record.data['PASS_SER_NO'] != passSerNo) {
					record.set('PASS_SER_NO', passSerNo);
				}
			})

			//1. 마스터 정보 파라미터 구성
			var paramMaster				= masterGrid.getStore().data.items[0].data;	//syncAll 수정
			paramMaster.INVOICE_DATE	= UniDate.getDbDateStr(paramMaster.INVOICE_DATE);
			paramMaster.SHIP_FIN_DATE	= UniDate.getDbDateStr(paramMaster.SHIP_FIN_DATE);
			paramMaster.DISCHGE_DATE	= UniDate.getDbDateStr(paramMaster.DISCHGE_DATE);
			paramMaster.INPUT_DATE		= UniDate.getDbDateStr(paramMaster.INPUT_DATE);
			paramMaster.OUTPUT_DATE		= UniDate.getDbDateStr(paramMaster.OUTPUT_DATE);
			paramMaster.PAYMENT_DATE	= UniDate.getDbDateStr(paramMaster.PAYMENT_DATE);
			paramMaster.TAXBILL_DATE	= UniDate.getDbDateStr(paramMaster.TAXBILL_DATE);
			paramMaster.DVRY_DATE		= UniDate.getDbDateStr(paramMaster.DVRY_DATE);
			paramMaster.APP_DATE		= UniDate.getDbDateStr(paramMaster.APP_DATE);
			paramMaster.EP_DATE			= UniDate.getDbDateStr(paramMaster.EP_DATE);
			paramMaster.ED_DATE			= UniDate.getDbDateStr(paramMaster.ED_DATE);
			//20191125 INVOICE_NO, DISCHGE_DATE 추가
			if(Ext.isEmpty(paramMaster.INVOICE_NO)) {
				paramMaster.INVOICE_NO	= masterForm.getValue('INVOICE_NO');
			}
			if(Ext.isEmpty(paramMaster.DISCHGE_DATE)) {
				paramMaster.DISCHGE_DATE= UniDate.getDbDateStr(masterForm.getValue('DISCHGE_DATE'));
			}

			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
//						masterForm.setValue("PASS_SER_NO", master.PASS_SER_NO);
						panelResult.setValue("PASS_INCOM_NO", master.PASS_SER_NO);

						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						if(directDetailStore.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						} else {
							UniAppManager.app.onQueryButtonDown();
						}
					 }
				};
				this.syncAllDirect(config);
			} else {
//				var grid = Ext.getCmp('tes100ukrvGrid');
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			update:function( store, record, operation, modifiedFieldNames, eOpts )  {
				this.fnOrderAmtSum();
			},
			load: function(store, records, successful, eOpts) {
				this.fnOrderAmtSum();
			},
			remove: function(store, record, index, isMove, eOpts) {
				this.fnOrderAmtSum();
			},
			add: function(store, records, index, eOpts) {
				this.fnOrderAmtSum();
			}
		},
		fnOrderAmtSum: function() {
			var passAmt		= 0;//금액
			var passAmtWon	= 0;//환산액
			var results		= this.sumBy(function(record, id){
										return true;
							}, ['PASS_AMT','PASS_AMT_WON']);

			passAmt			= results.PASS_AMT;		 //금액
			passAmtWon		= results.PASS_AMT_WON;	 //환산액

			masterForm.setValue('PASS_AMT'		, passAmt);
			masterForm.setValue('PASS_AMT_WON'	, passAmtWon);
		}
	});



	var masterGrid = Unilite.createGrid('tit101ukrvMasterGrid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'south',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: false
		},
		columns: [
			{ dataIndex: 'PASS_SER_NO'			, width: 100},
			{ dataIndex: 'INVOICE_DATE'			, width: 100},
			{ dataIndex: 'INVOICE_NO'			, width: 100},
			{ dataIndex: 'DIV_CODE'				, width: 100},
			{ dataIndex: 'EP_NO'				, width: 100},
			{ dataIndex: 'TRADE_TYPE'			, width: 100},
			{ dataIndex: 'PjctCD'				, width: 100},
			{ dataIndex: 'EP_DATE'				, width: 100},
			{ dataIndex: 'ED_DATE'				, width: 100},
			{ dataIndex: 'ED_NO'				, width: 100},
			{ dataIndex: 'APP_DATE'				, width: 100},
			{ dataIndex: 'DISCHGE_DATE'			, width: 100},
			{ dataIndex: 'SHIP_FIN_DATE'		, width: 100},
			{ dataIndex: 'REPORTOR'				, width: 100},
			{ dataIndex: 'BL_SER_NO'			, width: 100},
			{ dataIndex: 'DEST_PORT'			, width: 100},
			{ dataIndex: 'DEST_PORT_NM'			, width: 100},
			{ dataIndex: 'SHIP_PORT'			, width: 100},
			{ dataIndex: 'SHIP_PORT_NM'			, width: 100},
			{ dataIndex: 'VESSEL_NATION_CODE'	, width: 100},
			{ dataIndex: 'VESSEL_NM'			, width: 100},
			{ dataIndex: 'DEVICE_NO'			, width: 100},
			{ dataIndex: 'DEVICE_PLACE'			, width: 100},
			{ dataIndex: 'CUSTOMS'				, width: 100},
			{ dataIndex: 'EXAM_TXT'				, width: 100},
			{ dataIndex: 'IMPORTER'				, width: 100},
			{ dataIndex: 'IMPORTER_NM'			, width: 100},
			{ dataIndex: 'EXPORTER'				, width: 100},
			{ dataIndex: 'EXPORTER_NM'			, width: 100},
			{ dataIndex: 'GROSS_WEIGHT'			, width: 100},
			{ dataIndex: 'WEIGHT_UNIT'			, width: 100},
			{ dataIndex: 'PACKING_TYPE'			, width: 100},
			{ dataIndex: 'TOT_PACKING_COUNT'	, width: 100},
			{ dataIndex: 'PASS_AMT'				, width: 100},
			{ dataIndex: 'PASS_AMT_UNIT'		, width: 100, align: 'center'},
			{ dataIndex: 'PASS_EXCHANGE_RATE'	, width: 100},
			{ dataIndex: 'PASS_AMT_WON'			, width: 100},
			{ dataIndex: 'CIF_AMT'				, width: 100},
			{ dataIndex: 'CIF_AMT_UNIT'			, width: 100, align: 'center'},
			{ dataIndex: 'CIF_EXCHANGE_RATE'	, width: 100},
			{ dataIndex: 'CIF_AMT_WON'			, width: 100},
			{ dataIndex: 'PAY_METHODE'			, width: 100},
			{ dataIndex: 'TERMS_PRICE'			, width: 100},
			{ dataIndex: 'PAY_TERMS'			, width: 100},
			{ dataIndex: 'PAY_DURING'			, width: 100},
			{ dataIndex: 'EP_TYPE'				, width: 100},
			{ dataIndex: 'INSPECT_TYPE'			, width: 100},
			{ dataIndex: 'FORM_TRANS'			, width: 100},
			{ dataIndex: 'TARIFF_TAX'			, width: 100},
			{ dataIndex: 'VALUE_TAX'			, width: 100},
			{ dataIndex: 'INCOME_TAX'			, width: 100},
			{ dataIndex: 'INHA_TAX'				, width: 100},
			{ dataIndex: 'EDUC_TAX'				, width: 100},
			{ dataIndex: 'TRAF_TAX'				, width: 100},
			{ dataIndex: 'ARGRI_TAX'			, width: 100},
			{ dataIndex: 'INPUT_NO'				, width: 100},
			{ dataIndex: 'INPUT_DATE'			, width: 100},
			{ dataIndex: 'OUTPUT_DATE'			, width: 100},
			{ dataIndex: 'PAYMENT_DATE'			, width: 100},
			{ dataIndex: 'DVRY_DATE'			, width: 100},
			{ dataIndex: 'TAXBILL_DATE'			, width: 100},
			{ dataIndex: 'TAXBILL_NO'			, width: 100},
			{ dataIndex: 'REMARKS1'				, width: 100},
			{ dataIndex: 'REMARKS2'				, width: 100},
			{ dataIndex: 'REMARKS3'				, width: 100},
			{ dataIndex: 'OPR_FLAG'				, width: 100},
			{ dataIndex: 'PROJECT_NO'			, width: 100},
			{ dataIndex: 'SO_SER_NO'			, width: 100},
			{ dataIndex: 'LC_SER_NO'			, width: 100},
			//20191125 추가
			{ dataIndex: 'BL_NO'				, width: 100}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				this.returnData();
				SearchMasterReffWindow.hide();
			},
			selectionchangerecord:function(selected) {
				masterForm.loadForm(selected);
			}
		}
	});

	var detailGrid = Unilite.createGrid('tit101ukrvDetailGrid', { //main gird
		store	: directDetailStore,
		layout	: 'fit',
		region	: 'south',
		flex	: 1.5,
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: false
		},
		tbar	: [{
			itemId	: 'openShippingRef',
			text	: '<div style="color: blue"><t:message code="system.label.trade.shipmentrefer" default="선적참조"/></div>',
			handler	: function() {
				openSearchDetailReffWindow();
			}
		}],
		//20191202 수량, 금액, 환산액 합계 사용
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns: [
			{ dataIndex: 'DIV_CODE'				, width: 120, hidden: true},
			{ dataIndex: 'PASS_SER_NO'			, width: 100, hidden: true},
			{ dataIndex: 'PASS_SER'				, width: 66},
			{ dataIndex: 'ITEM_CODE'			, width: 100},
			{ dataIndex: 'ITEM_NAME'			, width: 150},
			{ dataIndex: 'SPEC'					, width: 100},
			{ dataIndex: 'UNIT'					, width: 80, align: 'center'},
			{ dataIndex: 'QTY'					, width: 100, summaryType: 'sum'},
			{ dataIndex: 'PRICE'				, width: 100},
			{ dataIndex: 'PASS_AMT'				, width: 100, summaryType: 'sum'},
			{ dataIndex: 'PASS_EXCHANGE_RATE'	, width: 100, hidden: true},
			{ dataIndex: 'PASS_AMT_WON'			, width: 100, summaryType: 'sum'},
			{ dataIndex: 'HS_NO'				, width: 100},
			{ dataIndex: 'HS_NAME'				, width: 150},
			{ dataIndex: 'BL_SER_NO'			, width: 100},
			{ dataIndex: 'BL_SER'				, width: 90},
			{ dataIndex: 'SO_SER_NO'			, width: 100},
			{ dataIndex: 'SO_SER'				, width: 90},
			{ dataIndex: 'USE_QTY'				, width: 100},
			{ dataIndex: 'WH_CODE'				, flex: 1, minWidth: 100}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				var record = e.record;
				if(!e.record.phantom){ //진행<t:message code="system.label.trade.qty" default="수량"/>이 있는 데이터는 수정불가.
					if(record.get('USE_QTY') > 0){
						return false;
					}
				}
				if (UniUtils.indexOf(e.field, ['QTY', 'PRICE', 'WH_CODE', 'PASS_AMT'])){
					return true;
				} else {
					return false;
				}
			},
			//20191128 validator로직 여기에서 구현
			edit : function( editor, context, eOpts ) {
				if(context.originalValue != context.value) {
					switch(context.field) {
						case "QTY" :
							if(context.value <= 0 && !Ext.isEmpty(context.value)) {
								rv=Msg.sMB076;
								break;
							}
							var dQty	= context.value;
							var dPrice	= context.record.get('PRICE');
							context.record.set('PASS_AMT'	, dQty * dPrice);
							var dAmt	= context.record.get('PASS_AMT');
							var dExchR	= context.record.get('PASS_EXCHANGE_RATE');
							//20191202 환산액은 무조건 반올림 처리
//							context.record.set('PASS_AMT_WON', dAmt * dExchR);
							context.record.set('PASS_AMT_WON', UniMatrl.fnAmtWonCalc(dAmt * dExchR, '3', 0));
						break;
	
						case "PRICE" :
							if(context.value <= 0 && !Ext.isEmpty(context.value)) {
								rv=Msg.sMB076;
								break;
							}
							var dQty	= context.record.get('QTY');
							var dPrice	= context.value;
							context.record.set('PASS_AMT'	, dQty * dPrice);
							var dAmt	= context.record.get('PASS_AMT');
							var dExchR	= context.record.get('PASS_EXCHANGE_RATE');
							//20191202 환산액은 무조건 반올림 처리
//							context.record.set('PASS_AMT_WON', dAmt * dExchR);
							context.record.set('PASS_AMT_WON', UniMatrl.fnAmtWonCalc(dAmt * dExchR, '3', 0));
						break;
	
						case "PASS_AMT" :
							if(context.value <= 0 && !Ext.isEmpty(context.value)) {
								rv=Msg.sMB076;
								break;
							}
							var dAmt	= context.value;
							var dExchR	= context.record.get('PASS_EXCHANGE_RATE');
							var dQty	= context.record.get('QTY');
							//20191202 UnitPrice 포맷 적용해서 단가 계산하도록 수정
//							context.record.set('PRICE'		, dAmt/dQty);
							var numDigitOfPrice	= UniFormat.UnitPrice.length - (UniFormat.UnitPrice.indexOf(".") == -1 ? UniFormat.UnitPrice.length : UniFormat.UnitPrice.indexOf(".") + 1);
							context.record.set('PRICE', UniMatrl.fnAmtWonCalc(dAmt / dQty, 3, numDigitOfPrice));
							
							//20191202 환산액은 무조건 반올림 처리
//							context.record.set('PASS_AMT_WON', dAmt * dExchR);
							context.record.set('PASS_AMT_WON', UniMatrl.fnAmtWonCalc(dAmt * dExchR, '3', 0));
						break;
					}
				}
			}
		},
		setShippingGridData: function(record) {
			var grdRecord	= this.getSelectedRecord();
			var passSeq		= directDetailStore.max('PASS_SER');
			if(!passSeq){
				passSeq = 1;
			} else {
				passSeq += 1;
			}
			var r = {
				 PASS_SER			: passSeq
				,DIV_CODE			: record.DIV_CODE
				,ITEM_CODE			: record.ITEM_CODE
				,ITEM_NAME			: record.ITEM_NAME
				,SPEC				: record.SPEC
				,UNIT				: record.UNIT
				,QTY				: record.QTY - record.USE_QTY
				,PRICE				: record.PRICE
				,PASS_AMT			: record.BL_AMT
				//20191128 수정
//				,PASS_AMT_WON		: record.BL_AMT * masterForm.getValue('PASS_EXCHANGE_RATE')
				,PASS_AMT_WON		: record.BL_AMT_WON
				,PASS_EXCHANGE_RATE	: masterForm.getValue('PASS_EXCHANGE_RATE')
				,HS_NO				: record.HS_NO
				,HS_NAME			: record.HS_NAME
				,BL_SER_NO			: record.BL_SER_NO
				,BL_SER				: record.BL_SER
				,SO_SER_NO			: record.SO_SER_NO
				,SO_SER				: record.SO_SER
				,USE_QTY			: record.USE_QTY
			}
			detailGrid.createRow(r);
			masterForm.setAllFieldsReadOnly(true);
			Ext.getCmp('applyBtn').setDisabled(true);
			Ext.getCmp('linkBtn').setDisabled(true);
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.trade.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.trade.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [
				{
				fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				colspan:2,
				comboType: 'BOR120',
				allowBlank: false,
				value:UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//20191202로직 추가
						if(UniAppManager.app._needSave()) {
							var saveFlag = true;
						} else {
							var saveFlag = false;
						}
						masterForm.setValue('DIV_CODE', newValue);
						panelResult.setValue('DIV_CODE', newValue);
						//20191202로직 추가
						UniAppManager.setToolbarButtons('save', saveFlag);
					}
				}
			},
				Unilite.popup('PASS_INCOM_NO',{
				fieldLabel: '<t:message code="system.label.trade.customsmanagementno" default="통관관리번호"/>',
				validateBlank: false,
				allowBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PASS_INCOM_NO', panelResult.getValue('PASS_INCOM_NO'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('PASS_INCOM_NO', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),
				{
				name: 'page',
				hidden:true,
				xtype: 'uniTextfield',
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue("page",newValue);
						}
					}
				}
			]
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
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
				//  this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('tit101ukrvresultForm',{
		title	: '<t:message code="system.label.trade.searchconditon" default="검색조건"/>',
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4, tableAttrs: {width: '99%'}},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			holdable: 'hold',
			value:UserInfo.divCode,
			tdAttrs: {width: 245},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//20191202로직 추가
					if(UniAppManager.app._needSave()) {
						var saveFlag = true;
					} else {
						var saveFlag = false;
					}
					masterForm.setValue('DIV_CODE', newValue);
					panelSearch.setValue('DIV_CODE', newValue);
					//20191202로직 추가
					UniAppManager.setToolbarButtons('save', saveFlag);
				}
			}
		},
		Unilite.popup('PASS_INCOM_NO',{
			fieldLabel: '<t:message code="system.label.trade.customsmanagementno" default="통관관리번호"/>',
			validateBlank: false,
			allowBlank: false,
			holdable: 'hold',
			tdAttrs: {width: 300},
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PASS_INCOM_NO', panelResult.getValue('PASS_INCOM_NO'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('PASS_INCOM_NO', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			text: '<t:message code="system.label.trade.shipmentapply" default="선적적용"/>',
			width: 100,
			id: 'applyBtn',
			xtype:'button',
			tdAttrs: {align: 'right'},
			handler	: function() {
				panelReff.setValue("DIV_CODE",panelResult.getValue("DIV_CODE"));
				openSearchMasterReffWindow();
			}
		},{
			text: '<t:message code="system.label.trade.expenseentry" default="경비등록"/>',
			xtype:'button',
			id:'linkBtn',
			width: 100,
			tdAttrs: {align: 'left', width: 120},
			margin:'0 0 0 5',
			handler	: function() {
				var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
				if(needSave ){
					alert(Msg.sMB154); //먼저 저장하십시오.
					return false;
				}
				var param = new Array();
				param[0] = "P";	//진행구분
				param[1] = masterForm.getValue('PASS_SER_NO'); //근거번호
				param[2] = ""  //수출자
				param[3] = ""
				param[4] = ""
				param[5] = panelResult.getValue('DIV_CODE');
				param[6] = masterForm.getValue('PASS_AMT_UNIT');  //화폐단위
				param[7] = masterForm.getValue('PASS_EXCHANGE_RATE'); //<t:message code="system.label.trade.exchangerate" default="환율"/>
				var params = {
					appId: UniAppManager.getApp().id,
					arrayParam: param
				}
				var rec = {data : {prgID : 'tix100ukrv', 'text':''}};
				parent.openTab(rec, '/trade/tix100ukrv.do', params, CHOST+CPATH);
			}
		},{
			name: 'page',
			hidden:true,
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue("page",newValue);
				}
			}
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					if(field.name == 'SO_AMT' && field.getValue() == 0){
						return false;
					}
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
							var popupFC = item.up('uniPopupField')	;
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

	var masterForm = Unilite.createSearchForm('masterForm',{
		region: 'center',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		autoScroll: true,
		items: [{
			xtype: 'container',
			colspan: 3,
			layout: {type: 'uniTable', columns: 4},
			items:[{
				fieldLabel: '<t:message code="system.label.trade.customsmanagementno" default="통관관리번호"/>',
				name: 'PASS_SER_NO',
				xtype: 'uniTextfield',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.tradetype" default="무역종류"/>',
				name: 'TRADE_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'T002',
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},
			Unilite.popup('PROJECT', {
				fieldLabel: '<t:message code="system.label.trade.project" default="프로젝트"/>',
				readOnly:true,
				colspan:3,
				valueFieldName: 'PjctCD',
				textFieldName: 'PjctNM'
			}),{
				fieldLabel: '<t:message code="system.label.trade.customdate" default="통관일"/>',
				name: 'INVOICE_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				//20191203 수정하능하도록 변경
//				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.invoice2" default="INVOICE 번호"/>',
				name: 'INVOICE_NO',
				xtype: 'uniTextfield',
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.blno" default="B/L번호"/>',
				name: 'BL_NO',
				xtype: 'uniTextfield',
				readOnly: true,
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.epdate" default="면허일"/>',
				name: 'EP_DATE',
				xtype: 'uniDatefield',
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
			},{
				fieldLabel: '<t:message code="system.label.trade.epno" default="면허번호"/>',
				name: 'EP_NO',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.reportdate" default="신고일"/>',
				name: 'ED_DATE',
				xtype: 'uniDatefield',
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
			},{
				fieldLabel: '<t:message code="system.label.trade.reportno" default="신고번호"/>',
				name: 'ED_NO',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.requestdate" default="요청일"/>',
				name: 'APP_DATE',
				xtype: 'uniDatefield',
				value:UniDate.get('today'),
				//20191203 수정하능하도록 변경
//				holdable: 'hold',
				//20191127 요청일, 도착일 필수 제외
//				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.arrivaldate" default="도착일"/>',
				name: 'DISCHGE_DATE',
				xtype: 'uniDatefield',
				//20191203 수정하능하도록 변경
//				holdable: 'hold',
				//20191127 요청일, 도착일 필수 제외
//				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.shipmentdate" default="선적일"/>',
				name: 'SHIP_FIN_DATE',
				xtype: 'uniDatefield',
				colspan:2,
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.reporter" default="신고인(관세사)"/>',
				name: 'REPORTOR',
				xtype: 'uniCombobox',
				comboType: '0',
				comboCode: 'T029',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.vesselnation" default="선박국적"/>',
				name: 'VESSEL_NATION_CODE',
				xtype: 'uniCombobox',
				comboType: '0',
				comboCode: 'B012',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.vesselname" default="VESSEL명"/>',
				name: 'VESSEL_NM',
				xtype: 'uniTextfield',
				width:495,
				colspan:2,
				comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.arrivalport" default="도착항"/>',
				name: 'DEST_PORT',
				xtype: 'uniCombobox',
				comboType: '0',
				comboCode: 'T008',
				//20191203 수정하능하도록 변경
//				holdable: 'hold',
				listeners: {
					render:function(elm){
						elm.on('select',function(queryPlan,eOpts)  {
							var selectdata=eOpts.data;
							console.log("selectdata:",selectdata);
							masterForm.setValue("DEST_PORT",selectdata.value);
							masterForm.setValue("DEST_PORT_NM",selectdata.text);
						});
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.shipmentport" default="선적항"/>',
				name: 'SHIP_PORT',
				xtype: 'uniCombobox',
				comboType: '0',
				comboCode: 'T008',
				//20191203 수정하능하도록 변경
//				holdable: 'hold',
				colspan: 3,
				listeners: {
					render:function(elm){
						elm.on('select',function(queryPlan,eOpts)  {
							var selectdata=eOpts.data;
							console.log("selectdata:",selectdata);
							masterForm.setValue("SHIP_PORT",selectdata.value);
							masterForm.setValue("SHIP_PORT_NM",selectdata.text);
						});
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.statetype" default="신고구분"/>',
				name: 'EP_TYPE',
				xtype: 'uniCombobox',
				comboType: '0',
				comboCode: 'T021',
				//20191203 수정하능하도록 변경
//				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.deviceconfirmno" default="장치확인번호"/>',
				name: 'DEVICE_NO',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.deviceplace" default="장치장소"/>',
				name: 'DEVICE_PLACE',
				xtype: 'uniTextfield',
				width:495,
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.inspecttype" default="검사구분"/>',
				name: 'INSPECT_TYPE',
				xtype: 'uniCombobox',
				comboType: '0',
				comboCode: 'T011',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.customoffice" default="세관"/>',
				name: 'CUSTOMS',
				xtype: 'uniCombobox',
				comboType: '0',
				comboCode: 'T009',
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.investigation" default="조사란"/>',
				name: 'EXAM_TXT',
				width:400,
				xtype: 'uniTextfield',
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.packagingtype" default="포장형태"/>',
				name: 'PACKING_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'T026',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.totalpackingcount" default="총포장갯수"/>',
				name: 'TOT_PACKING_COUNT',
				xtype: 'uniNumberfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 2},
				colspan: 2,
				items:[{
					fieldLabel: '<t:message code="system.label.trade.grossweight" default="총중량"/>',
					name: 'GROSS_WEIGHT',
					xtype:'uniNumberfield',
					width:175
				},{
					name: 'WEIGHT_UNIT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B013',
					displayField: 'value'
				}]
			},{
				fieldLabel: '<t:message code="system.label.trade.customexchangerate" default="통관환율"/>',
				name: 'PASS_EXCHANGE_RATE',
				xtype:'uniNumberfield',
				decimalPrecision:UniFormat.ER.indexOf('.') > -1 ? UniFormat.ER.length-1 - UniFormat.ER.indexOf('.') : 0,
				allowBlank: false,
				holdable: 'hold',
				decimalPrecision: 4,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue("PASS_AMT_WON",masterForm.getValue("PASS_AMT")*newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.trade.exchangeamount" default="환산액 "/>',
				name: 'PASS_AMT_WON',
				xtype:'uniNumberfield',
				//20191128 수정
				type:'uniPrice',
//				value:0.0,
//				decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 3},
				colspan: 2,
				items:[{
					fieldLabel: '<t:message code="system.label.trade.customamount" default="통관금액"/>',
					name: 'PASS_AMT',
					xtype:'uniNumberfield',
					type:'uniFC',
					decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
					readOnly:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							masterForm.setValue("PASS_AMT_WON",masterForm.getValue("PASS_EXCHANGE_RATE")*newValue);
						}
					},
					width:175
				},{
					name: 'PASS_AMT_UNIT',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B004',
					displayField: 'value',
					allowBlank: false,
					value:UserInfo.divCode,
					holdable: 'hold',
					fieldStyle: 'text-align: center;',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					margin: '0 0 0 6',
					xtype: 'button',
					id: 'startButton',
					text: '<t:message code="system.label.trade.additionalinput" default="추가입력"/>',
					handler : function() {
						if(Ext.getCmp('hiddenArea').isHidden()){
							Ext.getCmp('hiddenArea').show();
						} else {
							Ext.getCmp('hiddenArea').hide();
						}
					}
				}]
			}]
		},
			{
			xtype: 'container',
			colspan: 3,
			layout: {type: 'vbox', align: 'stretch'},
			items:[{
				xtype: 'container',
				id: 'hiddenArea',
				layout: {type: 'uniTable', columns: 3},
				items:[{
					fieldLabel: 'USD <t:message code="system.label.trade.exchangerate" default="환율"/>',
					name: 'CIF_EXCHANGE_RATE',
					xtype:'uniNumberfield',
					decimalPrecision:UniFormat.ER.indexOf('.') > -1 ? UniFormat.ER.length-1 - UniFormat.ER.indexOf('.') : 0,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: 'CIf <t:message code="system.label.trade.localamount" default="원화금액"/>',
					name: 'CIF_AMT_WON',
					xtype:'uniNumberfield',
					value:0.0,
					decimalPrecision:UniFormat.ER.indexOf('.') > -1 ? UniFormat.ER.length-1 - UniFormat.ER.indexOf('.') : 0,
					readOnly:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					xtype: 'container',
					layout: {type: 'uniTable', columns: 2},
					colspan: 2,
					items:[{
						fieldLabel: 'CIf <t:message code="system.label.trade.amount" default="금액"/>(USD)',
						name: 'CIF_AMT',
						xtype:'uniNumberfield',
						decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
						listeners:{
							change: function(field, newValue, oldValue, eOpts) {
								masterForm.setValue("CIF_AMT_WON",newValue*masterForm.getValue("CIF_EXCHANGE_RATE"));
							}
						},
						width:175
					},{
						name: 'CIF_AMT_UNIT',
						xtype: 'uniCombobox',
						displayField: 'value',
						comboType: 'AU',
						comboCode: 'B004',
						fieldStyle: 'text-align: center;',
						listeners:{
							render:function(elm) {
								elm.on('beforequery',function(queryPlan, eOpts)  {
									var store = queryPlan.combo.store;
									// store.clearFilter();
									store.filterBy(function(item){
										return item.get('refCode3') == 1;
									})
								});
								elm.on('select',function(queryPlan,eOpts)  {
									var selectdata=eOpts.data;
									 console.log("eOpts : ",eOpts.data);
									masterForm.setValue("CIF_EXCHANGE_RATE",1.0);
								});
							}
						}
					}]
				},
				Unilite.popup('CUST',{
					fieldLabel: '<t:message code="system.label.trade.importer" default="수입자"/>',
					valueFieldName: 'IMPORTER',
					textFieldName: 'IMPORTER_NM',
					readOnly:true,
					colspan: 2
				}),
				Unilite.popup('CUST',{
					fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
					valueFieldName: 'EXPORTER',
					colspan:4,
					textFieldName: 'EXPORTER_NM',
					readOnly:true
				}),{
					fieldLabel: '<t:message code="system.label.trade.payingterm" default="결제방법"/>',
					name: 'PAY_METHODE',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'T016',
					readOnly:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>',
					name: 'TERMS_PRICE',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'T005',
					readOnly:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					xtype: 'container',
					layout: {type: 'uniTable', columns: 2},
					colspan: 2,
					items:[{
						fieldLabel: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>',
						name: 'PAY_TERMS',
						xtype: 'uniCombobox',
						comboType:'AU',
						comboCode:'T006',
						readOnly: true,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
							}
						}
					},{
						name: 'PAY_DURING',
						xtype: 'uniTextfield',
						width:80,
						readOnly:true,
						suffixTpl: 'Day',
						listeners: {
//							render: function(obj) {
//								 var font=document.createElement("font");
//								 font.setAttribute("vertical-align","middle");
//								 var tips=document.createTextNode('Day');
//								 font.appendChild(tips);
//								obj.el.dom.parentNode.appendChild(font);
//							 }
						}
					}]
				},{
					fieldLabel: '<t:message code="system.label.trade.customs" default="관세"/>',
					name: 'TARIFF_TAX',
					xtype:'uniNumberfield',
					decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.trade.vat" default="부가세"/>',
					name: 'VALUE_TAX',
					xtype:'uniNumberfield',
					decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.trade.intaxi" default="소득세"/>',
					name: 'INCOME_TAX',
					xtype:'uniNumberfield',
					decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.trade.loctaxi" default="주민세"/>',
					name: 'INHA_TAX',
					xtype:'uniNumberfield',
					decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.trade.educationtax" default="교육세"/>',
					name: 'EDUC_TAX',
					xtype:'uniNumberfield',
					decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.trade.traftax" default="교통세"/>',
					name: 'TRAF_TAX',
					xtype:'uniNumberfield',
					decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.trade.sptaxi" default="농특세"/>',
					name: 'ARGRI_TAX',
					xtype:'uniNumberfield',
					decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.trade.billissuedate" default="계산서발행일"/>',
					name: 'TAXBILL_DATE',
					xtype: 'uniDatefield',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.trade.billno" default="계산서번호"/>',
					name: 'TAXBILL_NO',
					xtype: 'uniTextfield',
					colspan:3,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.trade.inputno" default="반입번호"/>',
					name: 'INPUT_NO',
					xtype: 'uniTextfield',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.trade.inputdate" default="반입일"/>',
					name: 'INPUT_DATE',
					xtype: 'uniDatefield',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.trade.outputdate" default="반출일"/>',
					name: 'OUTPUT_DATE',
					xtype: 'uniDatefield',
					colspan:2,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.trade.transporttype" default="운송형태"/>',
					name: 'FORM_TRANS',
					xtype: 'uniCombobox',
					comboType: '0',
					comboCode: 'T027',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.trade.paymentdate" default="납부일"/>',
					name: 'PAYMENT_DATE',
					xtype: 'uniDatefield',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.trade.deliverydate" default="납기일"/>',
					name: 'DVRY_DATE',
					colspan:3,
					xtype: 'uniDatefield',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.trade.remarks" default="비고"/>',
					name: 'REMARKS1',
					xtype: 'uniTextfield',
					colspan:4,
					width:735,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					name: 'REMARKS2',
					xtype: 'uniTextfield',
					colspan:4,
					margin:'0 0 0 95',
					width:640,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					name: 'REMARKS3',
					xtype: 'uniTextfield',
					colspan:4,
					margin:'0 0 0 95',
					width:640,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				}]
			},{
				fieldLabel: 'DIV_CODE',
				name: 'DIV_CODE',
				xtype: 'uniTextfield',
				hidden:true,
				allowBlank: false,
				value:UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				hidden:true,
				fieldLabel: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>',
				name: 'BL_SER_NO',
				xtype: 'uniTextfield',
				allowBlank: false,
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				name: 'OPR_FLAG',
				xtype: 'uniTextfield',
				hidden:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				name: 'PROJECT_NO',
				xtype: 'uniTextfield',
				hidden:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				name: 'SO_SER_NO',
				hidden:true,
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				name: 'LC_SER_NO',
				hidden:true,
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		}],
		api: {
			load: 'tit101ukrvService.selectMaster',
			submit: 'tit101ukrvService.syncForm'
		},
		listeners: {
			uniOnChange:function( form, dirty, eOpts ) {
				if(dirty){
					console.log("onDirtyChange");
					UniAppManager.setToolbarButtons('save', true);
				}
			}
		},
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
							var popupFC = item.up('uniPopupField')  ;
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
						var popupFC = item.up('uniPopupField')  ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
		},
		loadForm: function(record)  {
			this.setActiveRecord(record || null);
			this.resetDirtyStatus();
		}
	});



	//master선적참조 폼
	var panelReff = Unilite.createSearchForm('searchForm2', {
		layout :  {type : 'uniTable', columns : 2},
		items: [{
			fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
			name:'DIV_CODE',
			colspan:2,
			xtype: 'uniCombobox',
			comboType:'BOR120',
			value:UserInfo.divCode,
			readOnly:true
		},{
			fieldLabel: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>',
			name: 'BL_SER_NO',
			xtype: 'uniTextfield'
		},{
			fieldLabel: '<t:message code="system.label.trade.blno" default="B/L번호"/>',
			name: 'BL_NO',
			xtype: 'uniTextfield'
		},{
			fieldLabel: '<t:message code="system.label.trade.bldate" default="B/L일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'BL_DATE_FR',
			endFieldName: 'BL_DATE_TO',
			allowBlank: false,
			width: 315
		},
		Unilite.popup('CUST',{
			fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
			valueFieldName: 'EXPORTER',
			colspan:2,
			textFieldName: 'EXPORTER_NM'
		})]
	});

	//master 선적참조 모델
	var reffModel = Unilite.defineModel('reffModel', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.trade.division" default="사업장"/>'					, type: 'string',comboType:'BOR120'},
			{name: 'BL_SER_NO'			, text: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>'			, type: 'string'},
			{name: 'BL_NO'				, text: '<t:message code="system.label.trade.blno" default="B/L번호"/>'					, type: 'string'},
			{name: 'BL_DATE'			, text: '<t:message code="system.label.trade.bldate" default="B/L일"/>'					, type: 'uniDate'},
			{name: 'IMPORTER'			, text: '<t:message code="system.label.trade.importer" default="수입자"/>'					, type: 'string'},
			{name: 'IMPORTER_NM'		, text: '<t:message code="system.label.trade.importer" default="수입자"/>'					, type: 'string'},
			{name: 'EXPORTER'			, text: '<t:message code="system.label.trade.exporter" default="수출자"/>'					, type: 'string'},
			{name: 'EXPORTER_NM'		, text: '<t:message code="system.label.trade.exporter" default="수출자"/>'					, type: 'string'},
			{name: 'EXCHANGE_RATE'		, text: '<t:message code="system.label.trade.exchangerate" default="환율"/>'				, type: 'string'},
			{name: 'AMT_UNIT'			, text: '<t:message code="system.label.trade.currencyunit" default="화폐단위"/>'			, type: 'string', displayField: 'value'},
			{name: 'PAY_TERMS'			, text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'		, type: 'string', comboType: "AU", comboCode: "T006"},
			{name: 'PAY_METHODE'		, text: '<t:message code="system.label.trade.payingterm" default="결제방법"/>'				, type: 'string'},
			{name: 'TERMS_PRICE'		, text: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'			, type: 'string', comboType: "AU", comboCode: "T005"},
			{name: 'PAY_DURING'			, text: '<t:message code="system.label.base.payperiod" default="결제기간"/>'				, type: 'string'},
			{name: 'SO_SER_NO'			, text: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>'		, type: 'string'},
			{name: 'LC_SER_NO'			, text: '<t:message code="system.label.trade.lcmanageno" default="L/C관리번호"/>'			, type: 'string'},
			{name: 'VESSEL_NAME'		, text: '<t:message code="system.label.trade.vesselname2" default="운송수단"/>'				, type: 'string'},
			{name: 'VESSEL_NATION_CODE'	, text: '<t:message code="system.label.trade.vesselnation" default="선박국적"/>'			, type: 'string'},
			{name: 'DEST_PORT'			, text: '<t:message code="system.label.trade.arrivalport" default="도착항"/>'				, type: 'string'},
			{name: 'DEST_PORT_NM'		, text: '<t:message code="system.label.trade.arrivalportname" default="도착항명"/>'			, type: 'string'},
			{name: 'SHIP_PORT'			, text: '<t:message code="system.label.trade.shipmentport" default="선적항"/>'				, type: 'string'},
			{name: 'SHIP_PORT_NM'		, text: '<t:message code="system.label.trade.shipmentportname" default="선적항명"/>'		, type: 'string'},
			{name: 'PACKING_TYPE'		, text: '<t:message code="system.label.trade.packagingtype" default="포장형태"/>'			, type: 'string'},
			{name: 'GROSS_WEIGHT'		, text: '<t:message code="system.label.trade.grossweight" default="총중량"/>'				, type: 'string'},
			{name: 'WEIGHT_UNIT'		, text: '<t:message code="system.label.trade.weightunit" default="중량단위"/>'				, type: 'string'},
			{name: 'DATE_SHIPPING'		, text: '<t:message code="system.label.trade.shipmentdate" default="선적일"/>'				, type: 'uniDate'},
			{name: 'BL_AMT'				, text: '<t:message code="system.label.trade.blamount" default="B/L금액"/>'				, type: 'string'},
			{name: 'BL_AMT_WON'			, text: '<t:message code="system.label.trade.blamountwon" default="B/L환산액"/>'			, type: 'string'},
			{name: 'TRADE_TYPE'			, text: '<t:message code="system.label.trade.tradetype" default="무역종류"/>'				, type: 'string'},
			{name: 'NATION_INOUT'		, text: '<t:message code="system.label.trade.domesticoverseasclass" default="국내외구분"/>'	, type: 'string'},
			{name: 'PROJECT_NO'			, text: 'PROJECT_NO'		, type: 'string'},
			{name: 'PROJECT_NAME'		, text: '<t:message code="system.label.trade.project" default="프로젝트"/>'					, type: 'string'},
			{name: 'RECEIVE_AMT'		, text: '<t:message code="system.label.trade.supptotali" default="지급액"/>'				, type: 'string'},
			{name: 'EXPENSE_FLAG'		, text: 'EXPENSE_FLAG'		, type: 'string'},
			{name: 'INVOICE_NO'			, text: 'INVOICE_NO'		, type: 'string'},
			{name: 'CUSTOMS'			, text: 'CUSTOMS'			, type: 'string'},
			{name: 'EP_TYPE'			, text: 'EP_TYPE'			, type: 'string'},
			{name: 'LC_NO'				, text: 'LC_NO'				, type: 'string'}
		]
	});

	//선적 master참조 스토어
	var directReffStore = Unilite.createStore('directMasterStore', {
		model: 'reffModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false		 // prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'tit101ukrvService.selectReffMaster'
			}
		},
		loadStoreRecords : function() {
			var param= panelReff.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	//master선적참조  그리드
	var reffGrid=Unilite.createGrid('tit101ukrvGrid', {
		store	: directReffStore,
		layout	: 'fit',
		selModel: {
			selType	: 'rowmodel',
			mode	: 'SINGLE'
		},
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer	: false
		},
		columns: [
			{dataIndex: 'DIV_CODE'				, width: 100},
			{dataIndex: 'BL_SER_NO'				, width: 100},
			{dataIndex: 'BL_NO'					, width: 100},
			{dataIndex: 'BL_DATE'				, width: 100},
			{dataIndex: 'IMPORTER'				, width: 100, hidden:true},
			{dataIndex: 'IMPORTER_NM'			, width: 100, hidden:true},
			{dataIndex: 'EXPORTER'				, width: 100, hidden:true},
			{dataIndex: 'EXPORTER_NM'			, width: 100},
			{dataIndex: 'EXCHANGE_RATE'			, width: 100, hidden:true},
			{dataIndex: 'AMT_UNIT'				, width: 100, hidden:true},
			{dataIndex: 'PAY_TERMS'				, width: 100},
			{dataIndex: 'PAY_METHODE'			, width: 100, hidden:true},
			{dataIndex: 'TERMS_PRICE'			, minWidth: 100, flex: 1},
			{dataIndex: 'PAY_DURING'			, width: 100, hidden:true},
			{dataIndex: 'SO_SER_NO'				, width: 100, hidden:true},
			{dataIndex: 'LC_SER_NO'				, width: 100, hidden:true},
			{dataIndex: 'VESSEL_NAME'			, width: 100, hidden:true},
			{dataIndex: 'VESSEL_NATION_CODE'	, width: 100, hidden:true},
			{dataIndex: 'DEST_PORT'				, width: 100, hidden:true},
			{dataIndex: 'DEST_PORT_NM'			, width: 100, hidden:true},
			{dataIndex: 'SHIP_PORT'				, width: 100, hidden:true},
			{dataIndex: 'SHIP_PORT_NM'			, width: 100, hidden:true},
			{dataIndex: 'PACKING_TYPE'			, width: 100, hidden:true},
			{dataIndex: 'GROSS_WEIGHT'			, width: 100, hidden:true},
			{dataIndex: 'WEIGHT_UNIT'			, width: 100, hidden:true},
			{dataIndex: 'DATE_SHIPPING'			, width: 100, hidden:true},
			{dataIndex: 'BL_AMT'				, width: 100, hidden:true},
			{dataIndex: 'BL_AMT_WON'			, width: 100, hidden:true},
			{dataIndex: 'TRADE_TYPE'			, width: 100, hidden:true},
			{dataIndex: 'NATION_INOUT'			, width: 100, hidden:true},
			{dataIndex: 'PROJECT_NO'			, width: 100, hidden:true},
			{dataIndex: 'PROJECT_NAME'			, width: 100, hidden:true},
			{dataIndex: 'RECEIVE_AMT'			, width: 100, hidden:true},
			{dataIndex: 'EXPENSE_FLAG'			, width: 100, hidden:true},
			{dataIndex: 'INVOICE_NO'			, width: 100, hidden:true},
			{dataIndex: 'CUSTOMS'				, width: 100, hidden:true},
			{dataIndex: 'EP_TYPE'				, width: 100, hidden:true},
			{dataIndex: 'LC_NO'					, width: 100, hidden:true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				this.returnData();
				SearchMasterReffWindow.hide();
			}
		},
		returnData:function() {
			var record = this.getSelectedRecord();
			if(Ext.isEmpty(record)){
				return false;
			}
			panelSearch.setValue("PASS_SER_NO",'');
			panelResult.setValue("PASS_SER_NO",'');
			var r = {
				 BL_SER_NO			: record.data.BL_SER_NO
				,BL_DATE			: record.data.BL_DATE
				,IMPORTER			: record.data.IMPORTER
				,IMPORTER_NM		: record.data.IMPORTER_NM
				,EXPORTER			: record.data.EXPORTER
				,EXPORTER_NM		: record.data.EXPORTER_NM
				,EXCHANGE_RATE		: record.data.EXCHANGE_RATE
				,PASS_AMT_UNIT		: record.data.AMT_UNIT
				,PAY_TERMS			: record.data.PAY_TEMRS
				,PAY_METHODE		: record.data.PAY_METHODE
				,TERMS_PRICE		: record.data.TERMS_PRICE
				,PAY_DURING			: record.data.PAY_DURING
				,SO_SER_NO			: record.data.SO_SER_NO
				,LC_SER_NO			: record.data.LC_SER_NO
				,VESSEL_NAME		: record.data.VESSEL_NAME
				,VESSEL_NATION_CODE	: record.data.VESSEL_NATION_CODE
				,DEST_PORT			: record.data.DEST_PORT
				,DEST_PORT_NM		: record.data.DEST_PORT_NM
				,SHIP_PORT			: record.data.SHIP_PORT
				,SHIP_PORT_NM		: record.data.SHIP_PORT_NM
				,PACKING_TYPE		: record.data.PACKING_TYPE
				,GROSS_WEIGHT		: record.data.GROSS_WEIGHT
				,WEIGHT_UNIT		: record.data.WEIGHT_UNIT
				,DATE_SHIPPING		: record.data.DATE_SHIPPING
				,EXCHANGE_RATE		: record.data.EXCHANGE_RATE
				,RECEIVE_AMT		: record.data.RECEIVE_AMT
				,BL_AMT_WON			: record.data.BL_AMT_WON
				,DIV_CODE			: record.data.DIV_CODE
				,TRADE_TYPE			: record.data.TRADE_TYPE
				,NATION_INOUT		: record.data.NATION_INOUT
				,PROJECT_NO			: record.data.PROJECT_NO
				,PROJECT_NAME		: record.data.PROJECT_NAME
				,EXPENSE_FLAG		: record.data.EXPENSE_FLAG
				//20191125 수정: 기존 BL_NO 관련로직 없음, INVOICE_NO컬럼에 참조된 BL_NO 들어가게 되어 있음
				,BL_NO				: record.data.BL_NO
				,INVOICE_NO			: record.data.INVOICE_NO
				,CUSTOMS			: record.data.CUSTOMS
				,EP_TYPE			: record.data.EP_TYPE
				,LC_NO				: record.data.LC_NO
				,PASS_EXCHANGE_RATE	: record.data.EXCHANGE_RATE
				,DISCHGE_DATE		: UniDate.get('today')
				,PASS_AMT			: record.data.BL_AMT
				,PASS_AMT_WON		: record.data.BL_AMT_WON
//				PASS_SER_NO:'',
//				PASS_AMT:record.data.PASS_AMT,
//				PASS_AMT_UNIT:record.data.AMT_UNIT,
//				SHIP_FIN_DATE:record.data.BL_DATE,
//				BL_SER_NO:record.data.BL_SER_NO,
//				DIV_CODE: record.data.DIV_CODE,
//				CUSTOMS:record.data.CUSTOMS,
//				DEST_PORT:record.data.DEST_PORT,
//				DEST_PORT_NM:record.data.DEST_PORT_NM,
//				EP_TYPE:record.data.EP_TYPE,
//				PASS_EXCHANGE_RATE:record.data.EXCHANGE_RATE,
//				EXPORTER:record.data.EXPORTER,
//				EXPORTER_NM:record.data.EXPORTER_NM,
//				GROSS_WEIGHT:record.data.GROSS_WEIGHT,
//				IMPORTER:record.data.IMPORTER,
//				IMPORTER_NM:record.data.IMPORTER_NM,
//				INVOICE_NO:record.data.,
//				LC_SER_NO:record.data.LC_SER_NO,
//				PACKING_TYPE:record.data.PACKING_TYPE,
//				PAY_DURING:record.data.PAY_DURING,
//				PAY_METHODE:record.data.PAY_METHODE,
//				PAY_TERMS:record.data.PAY_TERMS,
//				PROJECT_NO:record.data.PROJECT_NO,
//				SHIP_PORT:record.data.SHIP_PORT,
//				SHIP_PORT_NM:record.data.SHIP_PORT_NM,
//				SO_SER_NO:record.data.SO_SER_NO,
//				TERMS_PRICE:record.data.TERMS_PRICE,
//				TRADE_TYPE:record.data.TRADE_TYPE,
//				VESSEL_NATION_CODE:record.data.VESSEL_NATION_CODE,
//				WEIGHT_UNIT:record.data.WEIGHT_UNIT,
//				APP_DATE:UniDate.get('today'),
//				INVOICE_DATE:UniDate.get('today')
			}
			masterGrid.createRow(r);
		}
	});

	//master 선적참조 메인
	function openSearchMasterReffWindow() {
		if(!SearchMasterReffWindow) {
			SearchMasterReffWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.trade.shipmentapply" default="선적적용"/>',
				width	: 1080,
				height	: 500,
				layout	: {type:'vbox', align:'stretch'},
				items	: [panelReff, reffGrid],
				tbar	: ['->', {
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.trade.inquiry" default="조회"/>',
					handler	: function() {
						directReffStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.trade.shipmentapply" default="선적적용"/>',
					handler	: function() {
						reffGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.trade.afterapplyclose" default="선적적용 후 닫기"/>',
					handler	: function() {
						reffGrid.returnData();
						SearchMasterReffWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.trade.close" default="닫기"/>',
					handler	: function() {
						SearchMasterReffWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt)  {
						panelReff.clearForm();
						reffGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						panelReff.clearForm();
						reffGrid.reset();
					},
					show: function( panel, eOpts )  {
						panelReff.setValue('BL_DATE_TO', UniDate.get('today'));
						panelReff.setValue('BL_DATE_FR', UniDate.get('startOfMonth', shippingSearch.getValue('BL_DATE_TO')));
					}
				}
			})
		}
		SearchMasterReffWindow.center();
		SearchMasterReffWindow.show();
	}



	//선적detail참조 폼
	var shippingSearch = Unilite.createSearchForm('shippingSearchForm', {
		layout	: {type : 'uniTable', columns : 2},
		items	: [{
			fieldLabel: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>',
			xtype: 'uniTextfield',
			name: 'BL_SER_NO',
			colspan: 2
		},{
			fieldLabel: '<t:message code="system.label.trade.bldate" default="B/L일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'BL_DATE_FR',
			endFieldName: 'BL_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
			valueFieldName:'EXPORTER',
			textFieldName:'EXPORTER_NM',
			readOnly: true,
			listeners: {
				applyextparam: function(popup) {
//					popup.setExtParam({'CUSTOM_TYPE':'1,2,3'});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>',
			name: 'PAY_TERMS',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'T006'
		},{
			fieldLabel: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>',
			name: 'TERMS_PRICE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'T005'
		}]
	});

	// 선적detail참조 모델
	Unilite.defineModel('tit101ukrvShippingModel', {
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.trade.division" default="사업장"/>'				, type: 'string'},
			{name: 'BL_SER_NO'		,text: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>'		, type: 'string'},
			{name: 'BL_SER'			,text: '<t:message code="system.label.trade.seq" default="순번"/>'					, type: 'int'},
			{name: 'EXPORTER_NM'	,text: '<t:message code="system.label.trade.exporter" default="수출자"/>'				, type: 'string'},
			{name: 'TERMS_PRICE'	,text: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'		, type: 'string', comboType:"AU", comboCode:"T005"},
			{name: 'PAY_TERMS'		,text: '<t:message code="system.label.trade.approvalcondition" default="결재조건"/>'	, type: 'string', comboType:"AU", comboCode:"T006"},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.trade.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.trade.itemname2" default="품명 "/>'				, type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.trade.spec" default="규격"/>'					, type: 'string'},
			{name: 'UNIT'			,text: '<t:message code="system.label.trade.purchaseunit" default="구매단위"/>'			, type: 'string', comboType:"AU", comboCode:"B013", displayField: 'value'},
			{name: 'QTY'			,text: '<t:message code="system.label.trade.shipmentqty" default="선적수량"/>'			, type: 'uniQty'},
			{name: 'PRICE'			,text: '<t:message code="system.label.trade.price" default="단가 "/>'					, type: 'uniUnitPrice'},
			{name: 'BL_AMT'			,text: '<t:message code="system.label.trade.amount" default="금액"/>'					, type: 'uniFC'},
			{name: 'BL_AMT_WON'		,text: '<t:message code="system.label.trade.exchangeamount" default="환산액 "/>'		, type: 'uniFC'},
			{name: 'HS_NO'			,text: '<t:message code="system.label.trade.hsno" default="HS번호"/>'					, type: 'string'},
			{name: 'HS_NAME'		,text: '<t:message code="system.label.trade.hsname" default="HS명"/>'				, type: 'string'},
			{name: 'SO_SER_NO'		,text: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>'	, type: 'string'},
			{name: 'SO_SER'			,text: '<t:message code="system.label.trade.offerno2" default="OFFER행번"/>'			, type: 'int'},
			{name: 'USE_QTY'		,text: '<t:message code="system.label.trade.useqty" default="진행수량"/>'				, type: 'uniQty'},
			{name: 'REMAIN_QTY'		,text: '<t:message code="system.label.trade.remainqty" default="선적수량"/>'			, type: 'uniQty'}
		]
	});

	// 선적detail참조 스토어
	var shippingStore = Unilite.createStore('tis100ukrvshippingStore', {
		model: 'tit101ukrvShippingModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			 // prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'tit101ukrvService.selectShippingList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful)  {
					var masterRecords = directDetailStore.data.filterBy(directDetailStore.filterNewOnly);
					var deleteRecords = new Array();

					if(masterRecords.items.length > 0) {
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
									console.log("record :", record);
								if( (record.data['BL_SER_NO'] == item.data['BL_SER_NO']) // record = masterRecord	item = 참조 Record
									&& (record.data['BL_SER'] == item.data['BL_SER'])
									) {
									deleteRecords.push(item);
								}
							});
						});
						store.remove(deleteRecords);
					}
				}
			}
		},
		loadStoreRecords : function()  {
			var param			= shippingSearch.getValues();
			param.DIV_CODE		= masterForm.getValue('DIV_CODE');
			param.TRADE_TYPE	= masterForm.getValue('TRADE_TYPE');
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'SO_SER_NO'
	});

	// 선적detail참조 그리드
	var shippingRefGrid = Unilite.createGrid('tis100ukrvshippingRefGrid', {
		store	: shippingStore,
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst: false
		},
		selModel:	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns	: [
			{ dataIndex: 'DIV_CODE'		, width:100, hidden: true},
			{ dataIndex: 'BL_SER_NO'	, width:100},
			{ dataIndex: 'BL_SER'		, width:66},
			{ dataIndex: 'EXPORTER_NM'	, width:100},
			{ dataIndex: 'TERMS_PRICE'	, width:120},
			{ dataIndex: 'PAY_TERMS'	, width:100},
			{ dataIndex: 'ITEM_CODE'	, width:100},
			{ dataIndex: 'ITEM_NAME'	, width:150},
			{ dataIndex: 'SPEC'			, width:120},
			{ dataIndex: 'UNIT'			, width:100, align: 'center'},
			{ dataIndex: 'QTY'			, width:100},
			{ dataIndex: 'USE_QTY'		, width:100, hidden: true},
			{ dataIndex: 'REMAIN_QTY'	, width:100},
			{ dataIndex: 'PRICE'		, width:100},
			{ dataIndex: 'BL_AMT'		, width:100},
			{ dataIndex: 'BL_AMT_WON'	, width:100, hidden: true},
			{ dataIndex: 'HS_NO'		, width:100, hidden: true},
			{ dataIndex: 'HS_NAME'		, width:100, hidden: true},
			{ dataIndex: 'SO_SER_NO'	, width:100, hidden: true},
			{ dataIndex: 'SO_SER'		, width:100, hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
//			detailGrid.setOfferMasterData(record.data);
			Ext.each(records, function(record,i) {
				detailGrid.setShippingGridData(record.data);
			});
			this.getStore().remove(records);
		}
	});

	// 선적detail참조 메인
	function openSearchDetailReffWindow() {
		if(!masterForm.setAllFieldsReadOnly(true)){
			return false;
		}
		if(!SearchDetailReffWindow) {
			SearchDetailReffWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.trade.offerrefer" default="OFFER참조"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [shippingSearch, shippingRefGrid],
				tbar	: ['->', {
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.trade.inquiry" default="조회"/>',
					handler	: function() {
						shippingStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.trade.afterapplyclose2" default="적용 후 닫기"/>',
					handler	: function() {
						shippingRefGrid.returnData();
						SearchDetailReffWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.trade.close" default="닫기"/>',
					handler	: function() {
						SearchDetailReffWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						 shippingSearch.clearForm();
						 shippingRefGrid.reset();
					},
					 beforeclose: function( panel, eOpts )  {
						 shippingSearch.clearForm();
						 shippingRefGrid.reset();
					},
					 beforeshow: function ( me, eOpts ) {
					 	shippingSearch.setValue('EXPORTER', masterForm.getValue('EXPORTER'));
						shippingSearch.setValue('EXPORTER_NM', masterForm.getValue('EXPORTER_NM'));
						shippingSearch.setValue('BL_DATE_TO', UniDate.get('today'));
						shippingSearch.setValue('BL_DATE_FR', UniDate.get('startOfMonth', shippingSearch.getValue('BL_DATE_TO')));
						shippingSearch.setValue('BL_SER_NO', masterForm.getValue('BL_SER_NO'));
						shippingStore.loadStoreRecords();
					 }
				}
			})
		}
		SearchDetailReffWindow.center();
		SearchDetailReffWindow.show();
	}



	Unilite.defineModel('orderNoMasterModel', {
		fields: [
			{name: 'DIV_CODE'			,text:'<t:message code="system.label.common.division" default="사업장"/>'					,type:'string', comboType: "BOR120" },
			{name: 'TRADE_TYPE'			,text:'<t:message code="system.label.common.tradetype" default="무역종류"/>'				,type:'string'},
			{name: 'PASS_INCOM_NO'		,text:'<t:message code="system.label.common.customsmanagementno" default="통관관리번호"/>'	,type:'string'},
			{name: 'INVOICE_DATE'		,text:'<t:message code="system.label.common.customdate" default="통관일"/>'				,type:'uniDate'},
			{name: 'IMPORTER'			,text:'<t:message code="system.label.common.importer" default="수입자"/>'					,type:'string'},
			{name: 'IMPORTER_NM'		,text:'<t:message code="system.label.common.importer" default="수입자"/>'					,type:'string'},
			{name: 'EXPORTER'			,text:'<t:message code="system.label.common.exporter" default="수출자"/>'					,type:'string'},
			{name: 'EXPORTER_NM'		,text:'<t:message code="system.label.common.exporter" default="수출자"/>'					,type:'string'},
			{name: 'PAY_TERMS'			,text:'<t:message code="system.label.common.paycondition" default="결제조건"/>'				,type:'string'},
			{name: 'TERMS_PRICE'		,text:'<t:message code="system.label.common.pricecondition" default="가격조건"/>'			,type:'string'},
			{name: 'PASS_EXCHANGE_RATE'	,text:'<t:message code="system.label.common.exchangerate" default="환율"/>'				,type:'string'},
			{name: 'PASS_AMT_UNIT'		,text:'<t:message code="system.label.common.currencyunit" default="화폐단위"/>'				,type:'string'},
			{name: 'PROJECT_NO'			,text:'<t:message code="system.label.common.projectno" default="프로젝트번호"/>'				,type:'string'},
			{name: 'PROJECT_NAME'		,text:'<t:message code="system.label.common.projectname" default="프로젝트명"/>'				,type:'string'},
			{name: 'SO_SER_NO'			,text:'<t:message code="system.label.common.offerno" default="OFFER번호"/>'				,type:'string'},
			{name: 'LC_SER_NO'			,text:'<t:message code="system.label.common.lcmanageno" default="L/C관리번호"/>'			,type:'string'},
			{name: 'LC_NO'				,text:'<t:message code="system.label.common.lcno" default="L/C번호"/>'					,type:'string'},
			{name: 'BL_SER_NO'			,text:'<t:message code="system.label.common.blmanageno" default="B/L관리번호"/>'			,type:'string'},
			{name: 'BL_NO'				,text:'<t:message code="system.label.common.blno" default="B/L번호"/>'					,type:'string'},
			{name: 'REMARKS1'			,text:'<t:message code="system.label.common.remarks" default="비고"/>1'					,type:'string'},
			{name: 'REMARKS2'			,text:'<t:message code="system.label.common.remarks" default="비고"/>2'					,type:'string'},
			{name: 'REMARKS3'			,text:'<t:message code="system.label.common.remarks" default="비고"/>2'					,type:'string'},
			//20191202 추가
			{name: 'PASS_AMT'			, text: '<t:message code="system.label.trade.customamount" default="통관금액"/>'			,type: 'uniFC'}
		]
	});

	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	//조회버튼 누르면 나오는 조회창
		model	: 'orderNoMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 'popupService.passIncomNoPopup'
			}
		},
		loadStoreRecords : function()	{
			if(orderNoSearch.validateForm()){
				var param= orderNoSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts){
				if(Ext.isEmpty(this.data.items)){
					Ext.Msg.alert('<t:message code="unilite.msg.sMB099" />','<t:message code="unilite.msg.sMB015" />');
				}
			}
		}
	});

	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
		layout: {type: 'uniTable', columns : 2},
		items: [{
			fieldLabel: '<t:message code="system.label.common.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype:'uniCombobox',
			comboType:'BOR120',
			readOnly: true
		},{
			fieldLabel: '<t:message code="system.label.common.customsmanagementno" default="통관관리번호"/>',
			xtype: 'uniTextfield',
			name: 'PASS_SER_NO'
		},{
			fieldLabel: '<t:message code="system.label.common.blno" default="B/L번호"/>',
			xtype: 'uniTextfield',
			name: 'BL_NO'
		}, {
			fieldLabel: '<t:message code="system.label.common.customdate" default="통관일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'INVOICE_DATE_FR',
			endFieldName: 'INVOICE_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank:false
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.common.exporter" default="수출자"/>',
			validateBlank: false, 
			valueFieldName:'EXPORTER',
			textFieldName:'EXPORTER_NM',
//			extParam: {'AGENT_CUST_FILTER':'1,2'},
			listeners: {
				applyextparam: function(popup) {
					popup.setExtParam({'AGENT_CUST_FILTER':'1,2'});
					popup.setExtParam({'CUSTOM_TYPE':'1,2'});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.common.paycondition" default="결제조건"/>',
			name: 'PAY_TERMS',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'T006'
		},{
			fieldLabel: '<t:message code="system.label.common.pricecondition" default="가격조건"/>',
			name: 'TERMS_PRICE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'T005'
		}],
		validateForm: function(){
			var r= true
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
				alert(labelText+Msg.sMB083);
				invalid.items[0].focus();
			}
			return r;
		}
	});

	var orderNoMasterGrid = Unilite.createGrid('ipo100ma1OrderNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
		store	: orderNoMasterStore,
		layout	: 'fit',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		selModel: 'rowmodel',
		columns	: [
			{ dataIndex: 'DIV_CODE'				, width: 100 },
			{ dataIndex: 'TRADE_TYPE'			, width: 100, hidden: true },
			{ dataIndex: 'PASS_INCOM_NO'		, width: 100 },
			{ dataIndex: 'INVOICE_DATE'			, width: 100 },
			{ dataIndex: 'IMPORTER'				, width: 100, hidden: true },
			{ dataIndex: 'IMPORTER_NM'			, width: 100, hidden: true },
			{ dataIndex: 'EXPORTER'				, width: 100, hidden: true },
			{ dataIndex: 'EXPORTER_NM'			, width: 100 },
			{ dataIndex: 'PAY_TERMS'			, width: 100 },
			{ dataIndex: 'TERMS_PRICE'			, width: 100 },
			{ dataIndex: 'PASS_EXCHANGE_RATE'	, width: 100, hidden: true },
			{ dataIndex: 'PASS_AMT_UNIT'		, width: 100, hidden: true },
			{ dataIndex: 'PROJECT_NO'			, width: 100, hidden: true },
			{ dataIndex: 'PROJECT_NAME'			, width: 100, hidden: true },
			{ dataIndex: 'SO_SER_NO'			, width: 100 },
			{ dataIndex: 'LC_SER_NO'			, width: 100 },
			{ dataIndex: 'LC_NO'				, width: 100 },
			{ dataIndex: 'BL_SER_NO'			, width: 100, hidden: true },
			{ dataIndex: 'BL_NO'				, width: 100 },
			{ dataIndex: 'REMARKS1'				, width: 100, hidden: true },
			{ dataIndex: 'REMARKS2'				, width: 100, hidden: true },
			{ dataIndex: 'REMARKS3'				, width: 100, hidden: true },
			//20191202 추가
			{ dataIndex: 'PASS_AMT'				, width: 100 }
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoMasterGrid.returnData(record);
			}
		},
		returnData: function(record) {
			panelSearch.setValue('DIV_CODE'			, record.get('DIV_CODE'));
			panelResult.setValue('DIV_CODE'			, record.get('DIV_CODE'));
			masterForm.setValue('DIV_CODE'			, record.get('DIV_CODE'));
			panelSearch.setValue('PASS_INCOM_NO'	, record.get('PASS_INCOM_NO'));
			panelResult.setValue('PASS_INCOM_NO'	, record.get('PASS_INCOM_NO'));
			UniAppManager.app.onQueryButtonDown();
			SearchInfoWindow.hide();
		}
	});

	function openSearchInfoWindow(param) {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '통관관리번호',
				width	: 1080,
				height	: 650,
				layout	: {type:'vbox', align:'stretch'},
				items	: [orderNoSearch, orderNoMasterGrid], //orderNoDetailGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.trade.inquiry" default="조회"/>',
					handler	: function() {
						orderNoMasterStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'OrderOkBtn',
					text	: '적용',
					handler	: function() {
						if(!Ext.isEmpty(orderNoMasterGrid.getSelectedRecord())){
							orderNoMasterGrid.returnData(orderNoMasterGrid.getSelectedRecord());
						}
					},
					disabled: false
				}, {
					itemId	: 'OrderNoCloseBtn',
					text	: '<t:message code="system.label.trade.close" default="닫기"/>',
					handler	: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt)	{
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					show: function( panel, eOpts )	{
						orderNoSearch.setValues({
							'DIV_CODE'			: panelSearch.getValue('DIV_CODE'),
							'INVOICE_DATE_FR'	: UniDate.get('startOfMonth'),
							'INVOICE_DATE_TO'	: UniDate.get('today')
						});
						orderNoMasterStore.loadStoreRecords();
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}



	Unilite.Main({
		id: 'tit101ukrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult,masterForm/*, masterGrid*/,detailGrid
			]
		}
		/*panelSearch */],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);

			masterForm.setValue('APP_DATE'			, UniDate.get('today'));
			masterForm.setValue('INVOICE_DATE'		, UniDate.get('today'));
			//20191125 도착일, 신고구분, 통관환율 기본값 추가
			masterForm.setValue('DISCHGE_DATE'		, UniDate.get('today'));
			masterForm.setValue('EP_TYPE'			, '1');
			masterForm.setValue('PASS_EXCHANGE_RATE', 1);
			
			masterForm.setValue('GROSS_WEIGHT'		, 0.0);
			masterForm.setValue('PASS_AMT_UNIT'		, 0.0);
			masterForm.setValue('TOT_PACKING_COUNT'	, 0.0);
			masterForm.setValue('PASS_AMT_WON'		, 0.0);
			masterForm.setValue('CIF_AMT'			, 0.0);
			masterForm.setValue('CIF_EXCHANGE_RATE'	, 0.0);
			masterForm.setValue('CIF_AMT_WON'		, 0.0);
			masterForm.setValue('TARIFF_TAX'		, 0.0);
			masterForm.setValue('VALUE_TAX'			, 0.0);
			masterForm.setValue('INCOME_TAX'		, 0.0);
			masterForm.setValue('INHA_TAX'			, 0.0);
			masterForm.setValue('EDUC_TAX'			, 0.0);
			masterForm.setValue('TRAF_TAX'			, 0.0);
			masterForm.setValue('ARGRI_TAX'			, 0.0);
			masterForm.setValue('PASS_AMT'			, 0.0);
			Ext.getCmp('applyBtn').setDisabled(false);
			Ext.getCmp('linkBtn').setDisabled(true);
			Ext.getCmp('hiddenArea').hide();
			UniAppManager.setToolbarButtons('reset'		, true);
			UniAppManager.setToolbarButtons('prev'		, true);
			UniAppManager.setToolbarButtons('next'		, true);
			UniAppManager.setToolbarButtons('newData'	, false);
			UniAppManager.setToolbarButtons('save'		, false);

			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
		},
		onQueryButtonDown: function() {
			//20191202 전체수정
			if(Ext.isEmpty(panelResult.getValue('PASS_INCOM_NO')) ){
				openSearchInfoWindow();
			} else {
				masterForm.clearForm();
				masterForm.resetDirtyStatus();
				directMasterStore.loadStoreRecords();
				panelResult.setAllFieldsReadOnly(true);
				masterForm.getField('PASS_AMT_UNIT').setReadOnly(true);
				masterForm.getField('PASS_EXCHANGE_RATE').setReadOnly(true);
			}
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterForm.clearForm();
			//20191129 수정
//			masterGrid.reset();
//			detailGrid.reset();
			masterGrid.getStore().loadData({});
			detailGrid.getStore().loadData({});
			UniAppManager.setToolbarButtons('save', false);
			UniAppManager.setToolbarButtons('deleteAll', false);
			this.fnInitBinding();
			panelResult.setAllFieldsReadOnly(false);
			masterForm.setAllFieldsReadOnly(false);
		},
		onPrevDataButtonDown:  function() {
			panelSearch.setValue("page","prev");
			var param= panelResult.getValues();
			masterForm.uniOpt.inLoading=true;
			Ext.getBody().mask('로딩중...','loading-indicator');
			masterForm.getForm().load({
				params: param,
				success:function(actionform, action) {
					panelSearch.setValue("PASS_SER_NO",action.result.data.PASS_SER_NO);
					panelResult.setValue("PASS_SER_NO",action.result.data.PASS_SER_NO);
					masterForm.uniOpt.inLoading=false;
					UniAppManager.setToolbarButtons('deleteAll',true);
					Ext.getBody().unmask();
				},
				 failure: function(batch, option) {
					console.log("option:",option);
					Ext.Msg.alert("확인",'<t:message code="unilite.msg.sMS035"  default="자료의 처음입니다" />');
					//UniAppManager.app.onResetButtonDown();
					masterForm.uniOpt.inLoading=false;
					Ext.getBody().unmask();
				 }
			});
			console.log("param:",param);
			UniAppManager.setToolbarButtons('excel',true);
		},
		onNextDataButtonDown:  function() {
			panelSearch.setValue("page","next");
			var param= panelResult.getValues();
			masterForm.uniOpt.inLoading=true;
			Ext.getBody().mask('로딩중...','loading-indicator');
			masterForm.getForm().load({
				params: param,
				success:function(actionform, action) {
					panelSearch.setValue("PASS_SER_NO",action.result.data.PASS_SER_NO);
					panelResult.setValue("PASS_SER_NO",action.result.data.PASS_SER_NO);
					masterForm.uniOpt.inLoading=false;
					UniAppManager.setToolbarButtons('deleteAll',true);
					Ext.getBody().unmask();
				},
				failure: function(batch, option) {
					console.log("option:",option);
					Ext.Msg.alert("확인",'<t:message code="unilite.msg.sMS036"  default="자료의 마지막입니다" />');
					masterForm.uniOpt.inLoading=false;
					Ext.getBody().unmask();
				}
			});
			console.log("param:",param);
			UniAppManager.setToolbarButtons('excel',true);
		},
		onDeleteDataButtonDown:function(){
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			} else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				detailGrid.deleteSelectedRow();
			}
			directDetailStore.fnOrderAmtSum();
		},
		onDeleteAllButtonDown:function(){
			var records = directDetailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					 //신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else {								  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						/*---------삭제전 로직 구현 끝----------*/
						if(deletable){
							detailGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){							  //신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
			}
		},
		onSaveDataButtonDown: function(config) {
			if(!masterForm.getInvalidMessage()) return;
			directDetailStore.saveStore();
		},
		checkForNewDetail:function() {
			return panelResult.setAllFieldsReadOnly(true);
		}
	});



	//Validation
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			if(BsaCodeInfo.gsInoutAutoYN == "N" && record.get('ACCOUNT_Q')){
				rv = Msg.sMS335;
			} else if( record.get('SALE_C_YN' == 'Y')){
				rv = Msg.sMS214;
			} else {
				//20191128 주석 - grid editor에서 처리
//				switch(fieldName) {
//					case "QTY" :
//						if(newValue <= 0 && !Ext.isEmpty(newValue)) {
//							rv=Msg.sMB076;
//							break;
//						}
//						var dQty = newValue;
//						var dPrice = record.get('PRICE');
//						record.set('PASS_AMT', dQty * dPrice);
//						var dAmt = record.get('PASS_AMT');
//						var dExchR = record.get('PASS_EXCHANGE_RATE');
//						record.set('PASS_AMT_WON', dAmt * dExchR);
//						break;
//
//					case "PRICE" :
//						if(newValue <= 0 && !Ext.isEmpty(newValue)) {
//							rv=Msg.sMB076;
//							break;
//						}
//						var dQty = record.get('QTY');
//						var dPrice = newValue;
//						 record.set('PASS_AMT', dQty * dPrice);
//						var dAmt = record.get('PASS_AMT');
//						var dExchR = record.get('PASS_EXCHANGE_RATE');
//						record.set('PASS_AMT_WON', dAmt * dExchR);
//						break;
//
//					case "PASS_AMT" :
//						if(newValue <= 0 && !Ext.isEmpty(newValue)) {
//							rv=Msg.sMB076;
//							break;
//						}
//						var dAmt = newValue;
//						var dExchR = record.get('PASS_EXCHANGE_RATE');
//						record.set('PASS_AMT_WON', dAmt * dExchR);
//						var dQty = record.get('QTY');
//						record.set('PRICE', dAmt/dQty);
//						break;
//				}
			}
			return rv;
		}
	}); // validator
};
</script>