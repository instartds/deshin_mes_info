<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sgp200ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sgp200ukrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" />					<!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />					<!-- 화폐유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B018" />					<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />					<!-- 계정구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" />					<!-- 계획금액단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B074" />					<!-- 양산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H001" />					<!-- 기준요일 -->
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	var planYear	= ${planYear};
	var baseDate	= ${baseDate};
	var selectWeek	= ${selectWeek};
	var refConfig	= ${refConfig};			//기준요일 확인 (공통코드 B604의 SUB_CODE)
	var refConfig2	= ${refConfig2};		//고객관리여부 확인 (공통코드 S060의 REF_CODE1)

	var excelWindow; 						//견적정보 업로드 윈도우 생성 
	var srmWindow; 							//SRM 윈도우 
	//var columns	= createGridColumn(selectWeek);
var BsaCodeInfo = {
	gsMoneyUnit			: '${gsMoneyUnit}',
	gsUseReceiveSrmYN	: '${gsUseReceiveSrmYN}'	//SRM 데이터수신 사용여부 확인 (공통코드 S146의 SUB_CODE = '1'의 REF_CODE1)
}
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sgp200ukrvService.selectList1',
			update	: 'sgp200ukrvService.updateDetail',
			create	: 'sgp200ukrvService.insertDetail',
			destroy	: 'sgp200ukrvService.deleteDetail',
			syncAll	: 'sgp200ukrvService.saveAll'
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sgp200ukrvService.selectList2'//,
//			update	: 'sgp200ukrvService.updateDetail2',
//			create	: 'sgp200ukrvService.insertDetail2',
//			destroy	: 'sgp200ukrvService.deleteDetail2',
//			syncAll	: 'sgp200ukrvService.saveAll2'
		}
	});
	
	
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Sgp200ukrvModel1', {
		fields: [
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.custom" default="거래처"/>'			,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'				,type: 'string'		, allowBlank: false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'		, allowBlank: false},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'				,type: 'string'},
			//20181120 추가 (ITEM_TYPE:양산구분(B074), REG_YN(BOM등록여부(BPR500T 저장 여부)))
			{name: 'ITEM_TYPE'			,text: '<t:message code="system.label.product.productiontype" default="양산구분"/>'	,type: 'string'		, comboType: "AU"	, comboCode: "B074"},
			{name: 'REG_YN'				,text: '<t:message code="system.label.product.entryyn1" default="등록여부(BOM)"/>'	,type: 'string'		, comboType: "AU"	, comboCode: "B018"},
			
			{name: 'PLAN_TYPE1'			,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'		,type: 'string'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.sales.currency" default="화폐"/>'			,type: 'string'},
			{name: 'ENT_MONEY_UNIT'		,text: '<t:message code="system.label.sales.planamountunit" default="계획금액단위"/>'	,type: 'string'},
			{name: 'MONEYUNIT_FACTOR'	,text: '<t:message code="system.label.sales.amountformat" default="금액형식"/>'		,type: 'string'},
			{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.sales.accountclass" default="계정구분"/>'		,type: 'string'},
			
			{name: 'SUM_PLANQTY'		,text: '<t:message code="system.label.sales.qtytotal" default="수량합계"/>'			,type: 'uniQty'},
			{name: 'SUM_PLANAMT'		,text: '<t:message code="system.label.sales.amounttotal" default="금액합계"/>'		,type: 'uniPrice'},
			
			{name: 'APPL_DATE0'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
			{name: 'WK_PLAN_QTY0'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY0'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT0'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE0'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

			{name: 'APPL_DATE1'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
			{name: 'WK_PLAN_QTY1'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY1'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT1'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE1'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

			{name: 'APPL_DATE2'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
			{name: 'WK_PLAN_QTY2'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY2'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT2'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE2'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

			{name: 'APPL_DATE3'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
			{name: 'WK_PLAN_QTY3'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY3'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT3'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE3'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

			{name: 'APPL_DATE4'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
			{name: 'WK_PLAN_QTY4'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY4'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT4'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE4'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

			{name: 'APPL_DATE5'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
			{name: 'WK_PLAN_QTY5'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY5'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT5'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE5'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

			{name: 'APPL_DATE6'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
			{name: 'WK_PLAN_QTY6'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY6'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT6'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE6'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

			{name: 'APPL_DATE7'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
			{name: 'WK_PLAN_QTY7'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY7'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT7'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE7'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

			{name: 'APPL_DATE8'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
			{name: 'WK_PLAN_QTY8'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY8'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT8'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE8'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

			{name: 'APPL_DATE9'			,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
			{name: 'WK_PLAN_QTY9'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY9'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT9'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE9'			,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

			{name: 'APPL_DATE10'		,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
			{name: 'WK_PLAN_QTY10'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY10'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT10'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE10'		,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},

			{name: 'APPL_DATE11'		,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
			{name: 'WK_PLAN_QTY11'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY11'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT11'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE11'		,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},
			
			{name: 'APPL_DATE12'		,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
			{name: 'WK_PLAN_QTY12'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'PLAN_QTY12'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT12'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE12'		,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'},
			
			{name: 'APPL_DATE13'		,text: '<t:message code="system.label.sales.applydate" default="적용일"/>13'		,type: 'uniDate'},
			{name: 'WK_PLAN_QTY13'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>13'	,type: 'uniQty'},
			{name: 'PLAN_QTY13'			,text: '<t:message code="system.label.sales.qty" default="수량"/>13'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT13'			,text: '<t:message code="system.label.sales.amount" default="금액"/>13'			,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE13'		,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>13'		,type: 'uniDate'},
			
			{name: 'APPL_DATE14'		,text: '<t:message code="system.label.sales.applydate" default="적용일"/>14'		,type: 'uniDate'},
			{name: 'WK_PLAN_QTY14'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>14'	,type: 'uniQty'},
			{name: 'PLAN_QTY14'			,text: '<t:message code="system.label.sales.qty" default="수량"/>14'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT14'			,text: '<t:message code="system.label.sales.amount" default="금액"/>14'			,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE14'		,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>14'		,type: 'uniDate'},
			
			{name: 'APPL_DATE15'		,text: '<t:message code="system.label.sales.applydate" default="적용일"/>15'		,type: 'uniDate'},
			{name: 'WK_PLAN_QTY15'		,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>15'	,type: 'uniQty'},
			{name: 'PLAN_QTY15'			,text: '<t:message code="system.label.sales.qty" default="수량"/>15'				,type: 'uniQty'		, allowBlank: true},
			{name: 'PLAN_AMT15'			,text: '<t:message code="system.label.sales.amount" default="금액"/>15'			,type: 'uniPrice'	, allowBlank: true},
			{name: 'BASE_DATE15'		,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>15'		,type: 'uniDate'},
			{name: 'EXCEL_YN'			,text: 'EXCEL_YN'																,type: 'string'}
		]
	});
	
	Unilite.defineModel('Sgp200ukrvModel2', {
		fields: [
			{name: 'PLAN_TYPE1'		,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'		,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'			,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		,type: 'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'				,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.sales.spec" default="규격"/>'				,type: 'string'},
			//20181120 추가 (ITEM_TYPE:양산구분(B074), REG_YN(BOM등록여부(BPR500T 저장 여부)))
			{name: 'ITEM_TYPE'		,text: '<t:message code="system.label.product.productiontype" default="양산구분"/>'	,type: 'string'		, comboType: "AU"	, comboCode: "B074"},
			{name: 'REG_YN'			,text: '<t:message code="system.label.product.entryyn1" default="등록여부(BOM)"/>'	,type: 'string'		, comboType: "AU"	, comboCode: "B018"},
			{name: 'PLAN_WEEK'		,text: '<t:message code="system.label.sales.planweekly" default="계획주간"/>'		,type: 'string'},
			{name: 'APPL_DATE'		,text: '<t:message code="system.label.sales.applydate" default="적용일"/>'			,type: 'uniDate'},
			{name: 'PLAN_QTY'		,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'},
			{name: 'PLAN_AMT'		,text: '<t:message code="system.label.sales.amount" default="금액"/>'				,type: 'uniPrice'},
			{name: 'BASE_DATE'		,text: '<t:message code="system.label.sales.basisdate" default="기준일"/>'			,type: 'uniDate'}
		]
	});

	//미등록된 SRM 데이터 
	Unilite.Excel.defineModel('Sgp200ukrvModel_notRegisteredSRM', {
		fields: [
			{name: 'SRM_ITEM_CODE'	, text: '<t:message code="ssystem.label.sales.item" default="품목"/>'		, type: 'string'},
			{name: 'SPECIFICATION'	, text: '<t:message code="system.label.sales.spec" default="규격"/>'		, type: 'string'},
			{name: 'DESCRIPTION'	, text: '<t:message code="system.label.sales.remarks" default="비고"/>'	, type: 'string'}
		]
	});

	// 엑셀업로드 window의 Grid Model
	Unilite.Excel.defineModel('excel.sgp200ukrv.sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'		, text: 'EXCEL_JOBID'	, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="ssystem.label.sales.item" default="품목"/>'					, type: 'string'},
			{name: 'W1'					, text: 'W1'			, type: 'uniQty'},
			{name: 'W2'					, text: 'W2'			, type: 'uniQty'},
			{name: 'W3'					, text: 'W3'			, type: 'uniQty'},
			{name: 'W4'					, text: 'W4'			, type: 'uniQty'},
			{name: 'W5'					, text: 'W5'			, type: 'uniQty'},
			{name: 'W6'					, text: 'W6'			, type: 'uniQty'},
			{name: 'W7'					, text: 'W7'			, type: 'uniQty'},
			{name: 'W8'					, text: 'W8'			, type: 'uniQty'},
			{name: 'W9'					, text: 'W9'			, type: 'uniQty'},
			{name: 'W10'				, text: 'W10'			, type: 'uniQty'},
			{name: 'W11'				, text: 'W11'			, type: 'uniQty'},
			{name: 'W12'				, text: 'W12'			, type: 'uniQty'}
		]
	});
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('sgp200ukrvMasterStore1',{
		model: 'Sgp200ukrvModel1',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function()	{	
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore: function() {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);

			//1.필수입력항목 체크
			if(!Ext.isEmpty(list)) {
				if(!fnEssenInput(list)) {
					return false;
				}
			}
			
			//2.마스터 정보 파라미터 구성
			var paramMaster	= panelResult.getValues();

			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						//1.마스터 정보(Server 측 처리 시 가공)
//						var master = batch.operations[0].getResultSet();
//						panelResult.setValue("ORDER_NUM", master.ORDER_NUM);
						
						//2.기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);	 
						
						if(directMasterStore1.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}else{
							UniAppManager.app.onQueryButtonDown();
						}
					 } 
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_sof101ukrv_ypGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
//		groupField: '',
		listeners: {
//			load: function(store, records, successful, eOpts) {
//				var param= Ext.getCmp('resultForm').getValues(); 
//				sgp200ukrvService.selectWeek(param, 
//					function(provider, response) {
//						
//					}
//				)
//			}
		}
	});
	
	var directMasterStore2 = Unilite.createStore('sgp200ukrvMasterStore2',{
		model: 'Sgp200ukrvModel2',
		uniOpt: {
			isMaster	: true,				// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 
			deletable	: false,			// 삭제 가능 여부 
			useNavi		: false				// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy2,
		loadStoreRecords: function()	{  
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}//,
//		groupField: ''	
	});
	
	var notRegisteredSRMStore = Unilite.createStore('sgp200ukrvNotRegisteredSRMStore',{
		model: 'Sgp200ukrvModel_notRegisteredSRM',
		uniOpt: {
			isMaster	: false,			// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 
			deletable	: false,			// 삭제 가능 여부 
			useNavi		: false				// prev | next 버튼 사용
		},
		autoLoad: false
//		groupField: ''	
	});



	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				holdable	: 'hold',
				tdAttrs		: {width: 380},
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}, {
				fieldLabel	: '<t:message code="system.label.sales.planyear" default="계획년도"/>',
				name		: 'PLAN_YEAR',
				xtype		: 'uniYearField',
				value		: new Date().getFullYear(),
				allowBlank	: false,
				holdable	: 'hold',
				readOnly	: true,
				tdAttrs		: {width: 380},
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.plandate" default="계획일"/>',
				name		: 'PLAN_DATE',
				xtype		: 'uniDatefield',
//				allowBlank	: false,
				holdable	: 'hold',
				hidden		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						if(UniDate.getDbDateStr(newValue).length == 8) {
							var param= Ext.getCmp('resultForm').getValues(); 
							sgp200ukrvService.planDateFrSet(param, function(provider, response) {
									panelResult.setValue('PLAN_DATE_FR', provider[0].WEEKFR);
									panelResult.setValue('PLAN_DATE_TO', provider[0].WEEKTO);
								}
							)
						}
					}
				}
			},{
				xtype		: 'container',
				layout		: {type : 'uniTable'},
				colspan		: 2,
//				labelWidth	: 18,
				items		: [{ 
					fieldLabel	: '<t:message code="system.label.sales.planperiod" default="계획기간"/>',
					name		: 'PLAN_DATE_FR',
					xtype		: 'uniTextfield',
					holdable	: 'hold',
					fieldStyle	: 'text-align: center;',
					allowBlank	: false,
					width		: 196,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if(isNaN(newValue)){
								Unilite.messageBox('<t:message code="system.message.sales.message019" default="자만 입력가능합니다."/>');
								panelResult.setValue('PLAN_DATE_FR', '');
								return false;
							}
							if(newValue.length == 7) {
								var frDate		= parseInt(newValue);
								var toDate		= parseInt('15');
								var planYear	= newValue.substring(0, 4);
								panelResult.setValue('PLAN_DATE_TO'	, frDate+toDate);
								panelResult.setValue('PLAN_YEAR'	, planYear);
								//컬럼명 set
								fnSetColumnName(newValue);
							}
						}
					}
				},{ 
					fieldLabel	: '~',
					name		: 'PLAN_DATE_TO',
					xtype		: 'uniTextfield',
					fieldStyle	: 'text-align: center;',
					holdable	: 'hold',
					readOnly	: true,
					width		: 127,
					labelWidth	: 18,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				}]
			}, {
				fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'  ,
				name		: 'ORDER_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S002',
				holdable	: 'hold',
				allowBlank	: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}, {
				fieldLabel	: '<t:message code="system.label.sales.currency" default="화폐"/>',
				name		: 'MONEY_UNIT',  
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'B004',
				displayField: 'value',
				allowBlank	: false,
				holdable	: 'hold',
				fieldStyle	: 'text-align: center;',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}, {
				fieldLabel	: '<t:message code="system.label.sales.planamountunit" default="계획금액단위"/>',
				name		: 'ENT_MONEY_UNIT',  
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'B042',
				holdable	: 'hold',
				allowBlank	: false,
				colspan		: 2,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}, {
				fieldLabel	: '<t:message code="system.label.sales.basisdate2" default="기준요일"/>'  ,
				name		: 'BASE_WEEK',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H001',
				holdable	: 'hold',
				allowBlank	: false,
				readOnly	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}, {
				fieldLabel	: '<t:message code="system.label.sales.accountclass" default="계정구분"/>',
				name		: 'ITEM_ACCOUNT',	
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},
			Unilite.popup('DIV_PUMOK', {
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE_FR', 
				textFieldName	: 'ITEM_NAME_FR',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_NAME_FR', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_CODE_FR', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('DIV_PUMOK', {
				valueFieldName	: 'ITEM_CODE_TO', 
				textFieldName	: 'ITEM_NAME_TO',
				validateBlank	: false,
				fieldLabel		: '~',
				labelWidth		: 18,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_NAME_TO', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_CODE_TO', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			})
			
		],
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
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
							var popupFC = item.up('uniPopupField') ;
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
	
	
	
	/**Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('sgp200ukrvGrid1', {
		// for tab
		title	: '<t:message code="system.label.sales.planentry" default="계획등록"/>',
		layout	: 'fit',	 
		store	: directMasterStore1,
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: true
		},
//		features: [ {id: 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
//				   	{id: 'masterGridTotal',		ftype: 'uniSummary',			showSummaryRow: false} ],
		tbar: [{
			xtype	: 'button',
			text	: '<t:message code="system.label.sales.Receivesrm" default="SRM 수신"/>',
			id		: 'recieveSRM',
			width	: 100,
			handler	: function() {
//				Unilite.messageBox('srm수신작업');
				Ext.getCmp('mainItem').getEl().mask('Loading....');
				var param = panelResult.getValues();
				
				sgp200ukrvService.receiveSRM(param, function(provider, response){
					if(!Ext.isEmpty(provider)) {
						masterGrid1.getStore().loadData({});
						var store	= masterGrid1.getStore();
						var records	= response.result;
						var newWeek	= provider[0].START_WEEK;
						var frDate	= parseInt(newWeek);
						var toDate	= parseInt('15');
						var planYear= newWeek.substring(0, 4);
						panelResult.setValue('PLAN_DATE_FR'	, newWeek);
						panelResult.setValue('PLAN_DATE_TO'	, frDate+toDate);
						panelResult.setValue('PLAN_YEAR'	, planYear);
						//컬럼명 set
						fnSetColumnName(newWeek);
	
						if(!Ext.isEmpty(provider)){
							Ext.each(provider, function(srmData, i) {
								if(srmData.SRM_FLAG == 'Registered') {			//'Registered' or 'Not Registered'
									srmData.phantom = true;
									store.insert(i, srmData);
								} else {
									notRegisteredSRMStore.insert(i, srmData);
								}
							});
						}
						Ext.getCmp('mainItem').unmask();
						if(notRegisteredSRMStore.count() > 0) {
							openSrmWindow();
						}
						
					} else {
						Unilite.messageBox('<t:message code="system.message.sales.message008" default="수신된 데이터가 없습니다."/>');
						Ext.getCmp('mainItem').unmask();
						return false;
					}
				});
			}
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.commonJS.excel.title" default="엑셀 업로드"/>',
			id		: 'excelUploadButton',
			width	: 100,
			handler	: function() {
				openExcelWindow();
			}
		}],
		columns: [		
			{ dataIndex: 'CUSTOM_CODE'			, width: 100	,
				'editor': Unilite.popup('AGENT_CUST_G',{
					textFieldName	: 'CUSTOM_CODE',
					DBtextFieldName	: 'CUSTOM_CODE',
					autoPopup		: true,
					listeners		: { 
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid1.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = masterGrid1.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
					}
				}),
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}
			},
			{ dataIndex: 'CUSTOM_NAME'			, width: 160	,
				'editor': Unilite.popup('AGENT_CUST_G',{
					autoPopup		: true,
					listeners		: { 
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid1.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = masterGrid1.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
					}
				}),
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}
			},
			{ dataIndex: 'ITEM_CODE'			, width: 86,
				'editor' : Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = masterGrid1.uniOpt.currentRecord;
								Ext.each(records, function(record,i) {
									if(i==0) {
										masterGrid1.setItemCodeData(record,false, grdRecord);
									} else {
										masterGrid1.createRow(null, null, directMasterStore1.getCount()-1);
										var newRecord	= masterGrid1.getSelectedRecord();
										var columns		= masterGrid1.getColumns();
										Ext.each(columns, function(column, index)	{
											newRecord.set(column.initialConfig.dataIndex, grdRecord.get(column.initialConfig.dataIndex));
										});
										newRecord.set('ITEM_CODE'	, record['ITEM_CODE']);
										newRecord.set('ITEM_NAME'	, record['ITEM_NAME']);
										newRecord.set('SPEC'		, record['SPEC']);
//										UniAppManager.app.onNewDataButtonDown(record);
//										masterGrid1.setItemCodeData(record,false, masterGrid1.getSelectedRecord());
									}
								}); 
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid1.setItemCodeData(null,true, masterGrid1.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': panelResult.getValue('DIV_CODE'), 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{ dataIndex: 'ITEM_NAME'			, width: 160	,
				'editor' : Unilite.popup('DIV_PUMOK_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										masterGrid1.setItemCodeData(record,false, masterGrid1.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown(record);
//										masterGrid1.setItemCodeData(record,false, masterGrid1.getSelectedRecord());
									}
								}); 
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid1.setItemCodeData(null,true, masterGrid1.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': panelResult.getValue('DIV_CODE'), 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{ dataIndex: 'SPEC'					, width: 100 },
			//20181120 추가 (ITEM_TYPE:양산구분(B074), REG_YN(BOM등록여부(BPR500T 저장 여부)))
			{ dataIndex: 'ITEM_TYPE'			, width: 80 },
			{ dataIndex: 'REG_YN'				, width: 100 },

			{ dataIndex: 'PLAN_TYPE1'			, width: 100		, hidden: true },
			{ dataIndex: 'MONEY_UNIT'			, width: 100		, hidden: true },
			{ dataIndex: 'ENT_MONEY_UNIT'		, width: 80			, hidden: true },
			{ dataIndex: 'MONEYUNIT_FACTOR'		, width: 133		, hidden: true },
			{ dataIndex: 'ITEM_ACCOUNT'			, width: 100		, hidden: true },
			{
				text: '<t:message code="system.label.sales.totalamount" default="합계"/>',
				columns:[
					{ dataIndex: 'SUM_PLANQTY'		, width: 100 },
					{ dataIndex: 'SUM_PLANAMT'		, width: 100 }
				]
			},   
			{
				id		: 'comlumnName0',
				columns	:[
					{ dataIndex: 'APPL_DATE0'		, width: 100		, hidden: true },
					{ dataIndex: 'WK_PLAN_QTY0'		, width: 100		, hidden: true },
					{ dataIndex: 'PLAN_QTY0'		, width: 100 },
					{ dataIndex: 'PLAN_AMT0'		, width: 100 },
					{ dataIndex: 'BASE_DATE0'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName1',
				columns	:[
					{ dataIndex: 'APPL_DATE1'		, width: 100		, hidden: true },
					{ dataIndex: 'WK_PLAN_QTY1'		, width: 100		, hidden: true },
					{ dataIndex: 'PLAN_QTY1'		, width: 100 },
					{ dataIndex: 'PLAN_AMT1'		, width: 100 },
					{ dataIndex: 'BASE_DATE1'		, width: 100 }
				]
			},
			{
				id		: 'comlumnName2',
				columns	:[
					{ dataIndex: 'APPL_DATE2'		, width: 100		, hidden: true },
					{ dataIndex: 'WK_PLAN_QTY2'		, width: 100		, hidden: true },
					{ dataIndex: 'PLAN_QTY2'		, width: 100 },
					{ dataIndex: 'PLAN_AMT2'		, width: 100 },
					{ dataIndex: 'BASE_DATE2'		, width: 100 }
				]
			},
			{
				id		: 'comlumnName3',
				columns	:[
					{ dataIndex: 'APPL_DATE3'		, width: 100		, hidden: true },
					{ dataIndex: 'WK_PLAN_QTY3'		, width: 100		, hidden: true },
					{ dataIndex: 'PLAN_QTY3'		, width: 100 },
					{ dataIndex: 'PLAN_AMT3'		, width: 100 },
					{ dataIndex: 'BASE_DATE3'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName4',
				columns	:[
					{ dataIndex: 'APPL_DATE4'		, width: 100		, hidden: true },
					{ dataIndex: 'WK_PLAN_QTY4'		, width: 100		, hidden: true },
					{ dataIndex: 'PLAN_QTY4'		, width: 100 },
					{ dataIndex: 'PLAN_AMT4'		, width: 100 },
					{ dataIndex: 'BASE_DATE4'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName5',
				columns	:[
					{ dataIndex: 'APPL_DATE5'		, width: 100		, hidden: true },
					{ dataIndex: 'WK_PLAN_QTY5'		, width: 100		, hidden: true },
					{ dataIndex: 'PLAN_QTY5'		, width: 100 },
					{ dataIndex: 'PLAN_AMT5'		, width: 100 },
					{ dataIndex: 'BASE_DATE5'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName6',
				columns	:[
					{ dataIndex: 'APPL_DATE6'		, width: 100		, hidden: true },
					{ dataIndex: 'WK_PLAN_QTY6'		, width: 100		, hidden: true },
					{ dataIndex: 'PLAN_QTY6'		, width: 100 },
					{ dataIndex: 'PLAN_AMT6'		, width: 100 },
					{ dataIndex: 'BASE_DATE6'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName7',
				columns	:[
					{ dataIndex: 'APPL_DATE7'		, width: 100		, hidden: true },
					{ dataIndex: 'WK_PLAN_QTY7'		, width: 100		, hidden: true },
					{ dataIndex: 'PLAN_QTY7'		, width: 100 },
					{ dataIndex: 'PLAN_AMT7'		, width: 100 },
					{ dataIndex: 'BASE_DATE7'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName8',
				columns	:[
					{ dataIndex: 'APPL_DATE8'		, width: 100		, hidden: true },
					{ dataIndex: 'WK_PLAN_QTY8'		, width: 100		, hidden: true },
					{ dataIndex: 'PLAN_QTY8'		, width: 100 },
					{ dataIndex: 'PLAN_AMT8'		, width: 100 },
					{ dataIndex: 'BASE_DATE8'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName9',
				columns	:[
					{ dataIndex: 'APPL_DATE9'		, width: 100		, hidden: true },
					{ dataIndex: 'WK_PLAN_QTY9'		, width: 100		, hidden: true },
					{ dataIndex: 'PLAN_QTY9'		, width: 100 },
					{ dataIndex: 'PLAN_AMT9'		, width: 100 },
					{ dataIndex: 'BASE_DATE9'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName10',
				columns	:[
					{ dataIndex: 'APPL_DATE10'		, width: 100		, hidden: true },
					{ dataIndex: 'WK_PLAN_QTY10'	, width: 100		, hidden: true },
					{ dataIndex: 'PLAN_QTY10'		, width: 100 },
					{ dataIndex: 'PLAN_AMT10'		, width: 100 },
					{ dataIndex: 'BASE_DATE10'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName11',
				columns	:[
					{ dataIndex: 'APPL_DATE11'		, width: 100		, hidden: true },
					{ dataIndex: 'WK_PLAN_QTY11'	, width: 100		, hidden: true },
					{ dataIndex: 'PLAN_QTY11'		, width: 100 },
					{ dataIndex: 'PLAN_AMT11'		, width: 100 },
					{ dataIndex: 'BASE_DATE11'		, width: 100 }
				]
			}, 
			{
				id		: 'comlumnName12',
				columns	:[
					{ dataIndex: 'APPL_DATE12'		, width: 100		, hidden: true },
					{ dataIndex: 'WK_PLAN_QTY12'	, width: 100		, hidden: true },
					{ dataIndex: 'PLAN_QTY12'		, width: 100 },
					{ dataIndex: 'PLAN_AMT12'		, width: 100 },
					{ dataIndex: 'BASE_DATE12'		, width: 100 }
				]
			},		   
			{
				id		: 'comlumnName13',
				columns	:[
					{ dataIndex: 'APPL_DATE13'		, width: 100		, hidden: true },
					{ dataIndex: 'WK_PLAN_QTY13'	, width: 100		, hidden: true },
					{ dataIndex: 'PLAN_QTY13'		, width: 100 },
					{ dataIndex: 'PLAN_AMT13'		, width: 100 },
					{ dataIndex: 'BASE_DATE13'		, width: 100 }
				]
			},		   
			{
				id		: 'comlumnName14',
				columns	:[
					{ dataIndex: 'APPL_DATE14'		, width: 100		, hidden: true },
					{ dataIndex: 'WK_PLAN_QTY14'	, width: 100		, hidden: true },
					{ dataIndex: 'PLAN_QTY14'		, width: 100 },
					{ dataIndex: 'PLAN_AMT14'		, width: 100 },
					{ dataIndex: 'BASE_DATE14'		, width: 100 }
				]
			},		  
			{
				id		: 'comlumnName15',
				columns	:[
					{ dataIndex: 'APPL_DATE15'		, width: 100		, hidden: true },
					{ dataIndex: 'WK_PLAN_QTY15'	, width: 100		, hidden: true },
					{ dataIndex: 'PLAN_QTY15'		, width: 100 },
					{ dataIndex: 'PLAN_AMT15'		, width: 100 },
					{ dataIndex: 'BASE_DATE15'		, width: 100 }
				]
			}],
			listeners: { 
				beforeedit  : function( editor, e, eOpts ) {
					//20181120 추가: 양산구분, BOM등록여부는 입력사항이 아님
					if(UniUtils.indexOf(e.field, ['ITEM_TYPE', 'REG_YN'])) {
						return false;
					}
					if(e.record.phantom == false) {
						if(UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_NAME', 'ITEM_CODE', 'ITEM_NAME', 'PLAN_QTY0', 'PLAN_AMT0', 'PLAN_QTY1', 'PLAN_AMT1', 'PLAN_QTY2', 'PLAN_AMT2', 'PLAN_QTY3', 'PLAN_AMT3', 'PLAN_QTY4', 'PLAN_AMT4' 
													, 'PLAN_QTY5', 'PLAN_AMT5', 'PLAN_QTY6', 'PLAN_AMT6', 'PLAN_QTY7', 'PLAN_AMT7', 'PLAN_QTY8', 'PLAN_AMT8', 'PLAN_QTY9', 'PLAN_AMT9'
													, 'PLAN_QTY10', 'PLAN_AMT10', 'PLAN_QTY11', 'PLAN_AMT11', 'PLAN_QTY12', 'PLAN_AMT12', 'PLAN_QTY13', 'PLAN_AMT13', 'PLAN_QTY14', 'PLAN_AMT14', 'PLAN_QTY15', 'PLAN_AMT15'])) {
							return true;
						} else {
							return false;
						}
					} else {
						if(UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_NAME', 'ITEM_CODE', 'ITEM_NAME', 'PLAN_QTY0', 'PLAN_AMT0', 'PLAN_QTY1', 'PLAN_AMT1', 'PLAN_QTY2', 'PLAN_AMT2', 'PLAN_QTY3', 'PLAN_AMT3', 'PLAN_QTY4', 'PLAN_AMT4'
													, 'PLAN_QTY5', 'PLAN_AMT5', 'PLAN_QTY6', 'PLAN_AMT6', 'PLAN_QTY7', 'PLAN_AMT7', 'PLAN_QTY8', 'PLAN_AMT8', 'PLAN_QTY9', 'PLAN_AMT9', 'PLAN_QTY10', 'PLAN_AMT10'
													, 'PLAN_QTY11', 'PLAN_AMT11', 'PLAN_QTY12', 'PLAN_AMT12', 'PLAN_QTY13', 'PLAN_AMT13', 'PLAN_QTY14', 'PLAN_AMT14', 'PLAN_QTY15', 'PLAN_AMT15'])) {
							return true;
						} else {
							return false;
						}
					}
				}
			},
			setItemCodeData: function(record, dataClear, grdRecord) {   
				if(dataClear) {
					grdRecord.set('ITEM_CODE'	, '');
					grdRecord.set('ITEM_NAME'	, '');
					grdRecord.set('SPEC'		, '');
					
				} else {
					grdRecord.set('ITEM_CODE'	, record['ITEM_CODE']);
					grdRecord.set('ITEM_NAME'	, record['ITEM_NAME']);
					grdRecord.set('SPEC'		, record['SPEC']);
				}
			}
	});
	
	/** Master Grid2 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid2 = Unilite.createGrid('sgp200ukrvGrid2', {
		// for tab
		title	: '<t:message code="system.label.sales.changehistory" default="변경이력"/>',
		layout	: 'fit',	   
		store	: directMasterStore2,
		uniOpt: {
			expandLastColumn: true,
			useRowNumberer: true
		},
//		features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
//					{id: 'masterGridTotal', 	ftype: 'uniSummary',  showSummaryRow: false} ],
		columns:  [		
			{ dataIndex: 'PLAN_TYPE1' 		, width: 100 },
			{ dataIndex: 'CUSTOM_CODE'		, width: 100 },
			{ dataIndex: 'CUSTOM_NAME'		, width: 160 },
			{ dataIndex: 'ITEM_CODE'		, width: 100 },
			{ dataIndex: 'ITEM_NAME'		, width: 160 },
			{ dataIndex: 'SPEC'				, width: 100 },
			//20181120 추가 (ITEM_TYPE:양산구분(B074), REG_YN(BOM등록여부(BPR500T 저장 여부)))
			{ dataIndex: 'ITEM_TYPE'		, width: 80 },
			{ dataIndex: 'REG_YN'			, width: 100 },

			{ dataIndex: 'PLAN_WEEK'		, width: 100 },
			{ dataIndex: 'APPL_DATE'		, width: 100 },
			{ dataIndex: 'PLAN_QTY'			, width: 100 },
			{ dataIndex: 'PLAN_AMT'			, width: 100 },
			{ dataIndex: 'BASE_DATE'		, width: 100 }
		] ,
		listeners: { 
			beforeedit  : function( editor, e, eOpts ) {
				return false;
			}
		}
	});  
	
	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab: 0,
		region: 'center',
		items: [
			masterGrid1,
			masterGrid2
		],
		listeners: {
			beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{
				if(Ext.isObject(oldCard))	{
					if(UniAppManager.app._needSave())	{
						if(confirm('<t:message code="system.message.sales.message020" default="내용이 변경되었습니다."/>" + "\n" + "<t:message code="system.message.sales.message021" default="변경된 내용을 저장하시겠습니까?"/>'))	{
							UniAppManager.app.onSaveDataButtonDown();
							this.setActiveTab(oldCard);
						}else {
							UniAppManager.setToolbarButtons('save', false);
						}
					}
				}
			},
			tabChange: function( tabPanel, newCard, oldCard, eOpts ) {
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 'sgp200ukrvGrid2') { 
					directMasterStore2.loadStoreRecords();
					panelResult.setAllFieldsReadOnly(false)
					UniAppManager.setToolbarButtons(['save', 'newData', 'delete' ], false);
				} else {
					directMasterStore1.loadStoreRecords();
					panelResult.setAllFieldsReadOnly(true)
					var count = masterGrid1.getStore().getCount();
					if(count <= 0) {
						UniAppManager.setToolbarButtons(['save', 'newData', 'delete' ], false);
					} else {
						UniAppManager.setToolbarButtons(['newData', 'delete' ], true);
					}
				}
			}
		}
	});
	
	
	
	//견적정보 엑셀업로드 윈도우 생성 함수
	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';
		//필수 입력정보 체크
		if (!panelResult.getInvalidMessage()) {
			return false;
		} 
		if(directMasterStore1.isDirty())	{									//화면에 저장할 내용이 있을 경우 저장여부 확인
			if(confirm('<t:message code="system.message.commonJS.baseApp.confirmSave" default="변경된 내용을 저장하시겠습니까?"/>')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
				masterGrid1.reset();
				directMasterStore1.clearData();
			}
		}
		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.COMP_CODE		= UserInfo.compCode;
			excelWindow.extParam.DIV_CODE		= panelResult.getValue('DIV_CODE');
			excelWindow.extParam.WW_DD_TYPE		= 10;
			excelWindow.extParam.PLAN_TYPE1		= panelResult.getValue('ORDER_TYPE');
//			excelWindow.extParam.CUSTOM_CODE	= 엑셀의 CUSTOM_CODE;
//			excelWindow.extParam.PLAN_TYPE2_CODE= 엑셀의 ITEM_CODE;
//			excelWindow.extParam.PLAN_WEEK		= 엑셀의 W11~W22;
			excelWindow.extParam.APPL_DATE		= UniDate.getDbDateStr(new Date());
//			excelWindow.extParam.BASE_DATE		= 엑셀의 W11~W22에서 계산한 기준일자;
		}
		if(!excelWindow) { 
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: 'sgp200ukrv',
				width	: 600,
				height	: 400,
				modal	: false,
				extParam: {
				//COMP_CODE, DIV_CODE, WW_DD_TYPE, PLAN_TYPE1, CUSTOM_CODE, ITEM_CODE, PLAN_WEEK, APPL_DATE, BASE_DATE
					'PGM_ID'			: 'sgp200ukrv',
					'COMP_CODE'			: UserInfo.compCode,
					'DIV_CODE'			: panelResult.getValue('DIV_CODE'),
					'WW_DD_TYPE'		: '10',
					'PLAN_TYPE1'		: panelResult.getValue('ORDER_TYPE'),
//					'CUSTOM_CODE'		: 엑셀의 CUSTOM_CODE,
//					'PLAN_TYPE2_CODE'	: 엑셀의 ITEM_CODE,
//					'PLAN_WEEK'			: 엑셀의 W11~W22,
					'APPL_DATE'			: UniDate.getDbDateStr(new Date())
//					'BASE_DATE'			: 엑셀의 W11~W22에서 계산한 기준일자,
					
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid01',
						title		: '<t:message code="system.label.sales.weeklysalesplanexcelupload" default="주간판매계획 엑셀업로드"/>',
						useCheckbox	: false,
						model		: 'excel.sgp200ukrv.sheet01',
						readApi		: 'sgp200ukrvService.selectExcelUploadSheet1',
						columns		: [	
							{dataIndex: '_EXCEL_JOBID'		, width: 100	, hidden: true},
							{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
							{dataIndex: 'CUSTOM_CODE'		, width: 100},
							{dataIndex: 'CUSTOM_NAME'		, width: 120},
							{dataIndex: 'ITEM_CODE'			, width: 100},
							{dataIndex: 'W1'				, width: 80},
							{dataIndex: 'W2'				, width: 80},
							{dataIndex: 'W3'				, width: 80},
							{dataIndex: 'W4'				, width: 80},
							{dataIndex: 'W5'				, width: 80},
							{dataIndex: 'W6'				, width: 80},
							{dataIndex: 'W7'				, width: 80},
							{dataIndex: 'W8'				, width: 80},
							{dataIndex: 'W9'				, width: 80},
							{dataIndex: 'W10'				, width: 80},
							{dataIndex: 'W11'				, width: 80},
							{dataIndex: 'W12'				, width: 80}
						]
					}
				],
				listeners: {
					beforeshow: function( panel, eOpts )	{
						//행추가 후에는 master 입력값 변경 불가
						panelResult.setAllFieldsReadOnly(true);
					},
					close: function() {
						this.hide();
					}
				},

				onApply: function() {
					excelWindow.getEl().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
					var me		= this;
					var grid	= this.down('#grid01');
					var records	= grid.getStore().getAt(0);	
					if (!Ext.isEmpty(records)) {
						var param			= panelResult.getValues();
						param._EXCEL_JOBID	= records.get('_EXCEL_JOBID');
						param.WW_DD_TYPE	= '10'
						param.APPL_DATE		= UniDate.getDbDateStr(new Date());
						
						sgp200ukrvService.selectUploadData(param, function(provider, response){
							var store	= masterGrid1.getStore();
							var records	= response.result;
							
							//panelResult 및 그리드 set
							var newWeek		= provider[0].START_WEEK;
							var frDate		= parseInt(newWeek);
							var toDate		= parseInt('15');
							var planYear	= newWeek.substring(0, 4);
							panelResult.setValue('PLAN_DATE_FR'	, newWeek);
							panelResult.setValue('PLAN_DATE_TO'	, frDate+toDate);
							panelResult.setValue('PLAN_YEAR'	, planYear);
							//컬럼명 set
							fnSetColumnName(newWeek);

							if(!Ext.isEmpty(provider)){
								Ext.each(provider, function(excelData, i) {
									excelData.phantom = true;
									store.insert(i, excelData);
								});
							}
							excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();
						});
					} else {
						alert ('<t:message code="system.message.sales.message022" default="업로드할 파일을 선택하십시오."/>');
						this.unmask();  
					}

					//버튼세팅
					UniAppManager.setToolbarButtons('newData'	, true);
					UniAppManager.setToolbarButtons('delete'	, false);
				},
				
				//툴바 세팅
				_setToolBar: function() {
					var me = this;
					me.tbar = [
					'->',
					{
						xtype	: 'button',
						text	: '<t:message code="system.label.commonJS.excel.btnUpload" default="업로드"/>',
						tooltip	: '<t:message code="system.label.commonJS.excel.btnUpload" default="업로드"/>', 
						width	: 60,
						handler: function() {
							me.jobID = null;
							me.uploadFile();
						}
					},{
						xtype	: 'button',
						text	: '<t:message code="system.label.commonJS.excel.btnApply" default="적용"/>',
						tooltip	: '<t:message code="system.label.commonJS.excel.btnApply" default="적용"/>',  
						width	: 60,
						handler	: function() { 
							var grids	= me.down('grid');
							var isError	= false;
							if(Ext.isDefined(grids.getEl()))	{
								grids.getEl().mask();
							}
							Ext.each(grids, function(grid, i){   
								var records = grid.getStore().data.items;
								return Ext.each(records, function(record, i){	
									if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
										console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
										isError = true;	 
										return false;
									}
								});
							}); 
							if(Ext.isDefined(grids.getEl())) {
								grids.getEl().unmask();
							}
							if(!isError) {
								me.onApply();
								
							}else {
								Unilite.messageBox('<t:message code="system.message.commonJS.excel.rowErrorText" default="에러가 있는 행은 적용이 불가능합니다."/>');
							}
						}
					},{
							xtype: 'tbspacer'	
					},{
							xtype: 'tbseparator'	
					},{
							xtype: 'tbspacer'	
					},{
						xtype: 'button',
						text : '<t:message code="system.label.commonJS.excel.btnClose" default="닫기"/>',
						tooltip : '<t:message code="system.label.commonJS.excel.btnClose" default="닫기"/>', 
						handler: function() { 
							var grid = me.down('#grid01');
							grid.getStore().removeAll();
							me.hide();
						}
					}
				]}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};

	
	


	//검색창 그리드 정의
	var unregisteredSrmGrid = Unilite.createGrid('str120ukrvInNoMasterGrid', {
		// title: '기본',
		layout	: 'fit',
		store	: notRegisteredSRMStore,
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true
		},
		columns	: [
			{ dataIndex: 'SRM_ITEM_CODE'	, width: 120 },
			{ dataIndex: 'SPECIFICATION'	, width: 133 },
			{ dataIndex: 'DESCRIPTION'		, flex: 1 }
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function(record) {
		}
	});
	
	//SRM 데이터 중 ERP에 품목정보 등록하지 않은 데이터 보여주기 위한 window
	function openSrmWindow() {
		if(!srmWindow) {
			srmWindow = Ext.create('widget.uniDetailWindow', {
				title	: 'Unregistered SRM Data',
				width	: 550,
				height	: 300,
				layout	: {type:'vbox', align:'stretch'},
				items	: [unregisteredSrmGrid],
				tbar	:['->',{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.confirm" default="확인"/>',
					handler	: function() {
						srmWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt)	{
						unregisteredSrmGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						unregisteredSrmGrid.reset();
					},
					show: function( panel, eOpts )	{
					}
				}
			})
		}
		srmWindow.center();
		srmWindow.show();
	};

	
	
	
	
	Unilite.Main( {
		id			: 'sgp200ukrvApp',
		borderItems	:[{
			id		: 'mainItem',
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				tab, panelResult
			]
		}],
		fnInitBinding: function() {
			//SRM 데이터 수신 버튼 사용여부 체크하여 숨기여부 결정
			if(Ext.isEmpty(BsaCodeInfo.gsUseReceiveSrmYN) || BsaCodeInfo.gsUseReceiveSrmYN != 'Y') {
				Ext.getCmp('recieveSRM').setHidden(true);
			}
			//컬럼명 set
			if(Ext.isEmpty(baseDate)) {
				Unilite.messageBox('<t:message code="system.message.sales.datacheck018" default="달력정보가 존재하지 않습니다. 달력을 먼저 생성하세요."/>');
				Ext.getCmp('mainItem').setDisabled(true);
				return false;
			}
			fnSetColumnName(baseDate[0].WEEKFR);
			//기준요일 set
			if(Ext.isEmpty(refConfig)) {
				panelResult.setValue('BASE_WEEK'	, '1');
			} else {
				panelResult.setValue('BASE_WEEK'	, refConfig[0].SUB_CODE);
			}
			//고객관리여부에 따른 컬럼 숨김 처리
			if(Ext.isEmpty(refConfig2) || refConfig2[0].REF_CODE1 == 'N') {
				masterGrid1.getColumn('CUSTOM_CODE').setHidden(true);
				masterGrid1.getColumn('CUSTOM_NAME').setHidden(true);
				masterGrid2.getColumn('CUSTOM_CODE').setHidden(true);
				masterGrid2.getColumn('CUSTOM_NAME').setHidden(true);
			} else {
				masterGrid1.getColumn('CUSTOM_CODE').setHidden(false);
				masterGrid1.getColumn('CUSTOM_NAME').setHidden(false);
				masterGrid2.getColumn('CUSTOM_CODE').setHidden(false);
				masterGrid2.getColumn('CUSTOM_NAME').setHidden(false);
			}
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('PLAN_YEAR'	, new Date().getFullYear());
			panelResult.setValue('PLAN_DATE_FR'	, baseDate[0].WEEKFR);
			panelResult.setValue('PLAN_DATE_TO'	, baseDate[0].WEEKTO);
			panelResult.setValue('MONEY_UNIT'	, BsaCodeInfo.gsMoneyUnit);
			panelResult.getField('BASE_WEEK').setReadOnly(true);
			panelResult.getField('PLAN_YEAR').setReadOnly(true);
			panelResult.getField('PLAN_DATE_TO').setReadOnly(true);
					
			var param= Ext.getCmp('resultForm').getValues(); 
			sgp200ukrvService.defaultSet(param, function(provider, response) {
				if (!Ext.isEmpty(provider)) {
					panelResult.setValue('ORDER_TYPE'		, provider[0].PLAN_TYPE1);
					panelResult.setValue('ENT_MONEY_UNIT'	, provider[0].ENT_MONEY_UNIT);
				} else {
					panelResult.setValue('ORDER_TYPE'		, '10');
					panelResult.setValue('ENT_MONEY_UNIT'	, '1');
				}
			})
			UniAppManager.setToolbarButtons('reset',true);
			
			//화면 초기화 시 포커스 / readOnly set, 20200701 주석: 사업장 권한 관련로직 공통에서 처리하므로 주석 처리
//			if (pgmInfo.authoUser != 'N') {
//				panelResult.getField('DIV_CODE').setReadOnly(true);
//				panelResult.onLoadSelectText('PLAN_DATE_FR');
//			} else {
				panelResult.onLoadSelectText('DIV_CODE');
//			}
		},
		onQueryButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return false;
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'sgp200ukrvGrid1'){
				directMasterStore1.loadStoreRecords();
				UniAppManager.setToolbarButtons('newData', true);
			}
			else if(activeTabId == 'sgp200ukrvGrid2'){
				directMasterStore2.loadStoreRecords();
			}		
			UniAppManager.setToolbarButtons('reset',true);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid1.getStore().loadData({});
			masterGrid2.getStore().loadData({});
			this.fnInitBinding();
		},
		onNewDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'sgp200ukrvGrid1') { 
				var record= masterGrid1.getSelectedRecord();
			
				var planType1	= panelResult.getValue('ORDER_TYPE');
				var moneyUnit	= panelResult.getValue('MONEY_UNIT');
				var entMoneyUnit= panelResult.getValue('ENT_MONEY_UNIT');
				var wkPlanQty0	= 0;
				var wkPlanQty1	= 0;
				var wkPlanQty2	= 0;
				var wkPlanQty3	= 0;
				var wkPlanQty4	= 0;
				var wkPlanQty5	= 0;
				var wkPlanQty6	= 0;
				var wkPlanQty7	= 0;
				var wkPlanQty8	= 0;
				var wkPlanQty9	= 0;
				var wkPlanQty10	= 0;
				var wkPlanQty11	= 0;
				var wkPlanQty12	= 0;
				var wkPlanQty13	= 0;
				var wkPlanQty14	= 0;
				var wkPlanQty15	= 0;
				
				//행추가시 각 주차의 기준일자 가져오는 로직 추가
				var param = {
					S_COMP_CODDE	: UserInfo.compCode,
					PLAN_YEAR		: panelResult.getValue('PLAN_YEAR'),
					PLAN_DATE_FR	: panelResult.getValue('PLAN_DATE_FR'),
					PLAN_DATE_TO	: panelResult.getValue('PLAN_DATE_TO'),
					// BASE_WEEK		: parseInt(panelResult.getValue('BASE_WEEK')) + 1
					BASE_WEEK		: parseInt(panelResult.getValue('BASE_WEEK'))
				};
				sgp200ukrvService.fnGetDate(param, function(provider, response) {
					if(Ext.isEmpty(provider)) {
						Unilite.messageBox('<t:message code="system.message.sales.message023" default="기준일 설정중 오류"/>');			//"기준일 설정중 오류"
						return false;
						
					} else {
						var baseDate0	=provider[0].BASIC_DATE;
						var baseDate1	=provider[1].BASIC_DATE;
						var baseDate2	=provider[2].BASIC_DATE;
						var baseDate3	=provider[3].BASIC_DATE;
						var baseDate4	=provider[4].BASIC_DATE;
						var baseDate5	=provider[5].BASIC_DATE;
						var baseDate6	=provider[6].BASIC_DATE;
						var baseDate7	=provider[7].BASIC_DATE;
						var baseDate8	=provider[8].BASIC_DATE;
						var baseDate9	=provider[9].BASIC_DATE;
						var baseDate10	=provider[10].BASIC_DATE;
						var baseDate11	=provider[11].BASIC_DATE;
						var baseDate12	=provider[12].BASIC_DATE;
						var baseDate13	=provider[13].BASIC_DATE;
						var baseDate14	=provider[14].BASIC_DATE;
						var baseDate15	=provider[15].BASIC_DATE;
						
						var r = {
							PLAN_TYPE1		: planType1,
							MONEY_UNIT		: moneyUnit,
							ENT_MONEY_UNIT	: entMoneyUnit,
							WK_PLAN_QTY0	: wkPlanQty0,
							WK_PLAN_QTY1	: wkPlanQty1,
							WK_PLAN_QTY2	: wkPlanQty2,
							WK_PLAN_QTY3	: wkPlanQty3,
							WK_PLAN_QTY4	: wkPlanQty4,
							WK_PLAN_QTY5	: wkPlanQty5,
							WK_PLAN_QTY6	: wkPlanQty6,
							WK_PLAN_QTY7	: wkPlanQty7,
							WK_PLAN_QTY8	: wkPlanQty8,
							WK_PLAN_QTY9	: wkPlanQty9,
							WK_PLAN_QTY10	: wkPlanQty10,
							WK_PLAN_QTY11	: wkPlanQty11,
							WK_PLAN_QTY12	: wkPlanQty12,
							WK_PLAN_QTY13	: wkPlanQty13,
							WK_PLAN_QTY14	: wkPlanQty14,
							WK_PLAN_QTY15	: wkPlanQty15,
							BASE_DATE0		: baseDate0,
							BASE_DATE1		: baseDate1,
							BASE_DATE2		: baseDate2,
							BASE_DATE3		: baseDate3,
							BASE_DATE4		: baseDate4,
							BASE_DATE5		: baseDate5,
							BASE_DATE6		: baseDate6,
							BASE_DATE7		: baseDate7,
							BASE_DATE8		: baseDate8,
							BASE_DATE9		: baseDate9,
							BASE_DATE10		: baseDate10,
							BASE_DATE11		: baseDate11,
							BASE_DATE12		: baseDate12,
							BASE_DATE13		: baseDate13,
							BASE_DATE14		: baseDate14,
							BASE_DATE15		: baseDate15
						};		
						masterGrid1.createRow(r, null, directMasterStore1.getCount()-1);
					}
				});
			}
			panelResult.setAllFieldsReadOnly(true);
		},
		onSaveDataButtonDown: function () {
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'sgp200ukrvGrid1') {
				directMasterStore1.saveStore();
//			} else if(activeTabId == 'sgp200ukrvGrid2') {
//				directMasterStore2.saveStore();
			}		 
		},
		onDeleteDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'sgp200ukrvGrid1') {
				var selRow = masterGrid1.getSelectedRecord();
				if(selRow.phantom === true)	{
					masterGrid1.deleteSelectedRow();
				} else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid1.deleteSelectedRow();
				}
			}
		}
	});
	
	
	
	
	
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PLAN_QTY0":
				case "PLAN_QTY1":
				case "PLAN_QTY2":
				case "PLAN_QTY3":
				case "PLAN_QTY4":
				case "PLAN_QTY5":
				case "PLAN_QTY6":
				case "PLAN_QTY7":
				case "PLAN_QTY8":
				case "PLAN_QTY9":
				case "PLAN_QTY10":
				case "PLAN_QTY11":
				case "PLAN_QTY12":
				case "PLAN_QTY13":
				case "PLAN_QTY14":
				case "PLAN_QTY15":
					var itemCode = record.get('ITEM_CODE');
					if (Ext.isEmpty(itemCode)) {							//품목이 존재해야 한다.
						rv = '<t:message code="system.message.sales.message024" default="품목코드를 입력하십시오."/>';									//품목코드를 입력하십시오.
						break;
					}
					if(newValue != 0) {
						if(isNaN(newValue)){
							rv = '<t:message code="system.message.sales.message027" default="숫자만 입력 하세요."/>';								//숫자만 입력 하세요.
							break;
						}
						if(newValue <= 0 ){
							rv = '<t:message code="system.message.sales.message025" default="0보다 큰수만 입력가능합니다."/>';	//0보다 큰수만 입력가능합니다.
							break;
						}
						//입력 필드의 적용일 컬럼을 오늘 날짜로 set
						var seq = fieldName.substring(8,10);
						record.set('APPL_DATE' + seq, UniDate.get('today'));
						
						//입력 필드의 단가 * 수량 값을 금액 컬럼에 set
						var cost = fnSaleCost(itemCode, record, newValue, seq);
						if(cost == false) {
							rv = '<t:message code="system.message.sales.message026" default="판매단가 조회 중 오류"/>';								//판매단가 조회 중 오류
						}
					}
				break;


				case "PLAN_AMT0":
				case "PLAN_AMT1":
				case "PLAN_AMT2":
				case "PLAN_AMT3":
				case "PLAN_AMT4":
				case "PLAN_AMT5":
				case "PLAN_AMT6":
				case "PLAN_AMT7":
				case "PLAN_AMT8":
				case "PLAN_AMT9":
				case "PLAN_AMT10":
				case "PLAN_AMT11":
				case "PLAN_AMT12":
				case "PLAN_AMT13":
				case "PLAN_AMT14":
				case "PLAN_AMT15":
					var itemCode = record.get('ITEM_CODE');
					if (Ext.isEmpty(itemCode)) {							//품목이 존재해야 한다.
						rv = '<t:message code="system.message.sales.message024" default="품목코드를 입력하십시오."/>';									//품목코드를 입력하십시오.
						break;
					}
					if(newValue != 0) {
						if(isNaN(newValue)){
							rv = '<t:message code="system.message.sales.message027" default="숫자만 입력 하세요."/>';								//숫자만 입력 하세요.
							break;
						}
						if(newValue <= 0 ){
							rv = '<t:message code="system.message.sales.message025" default="0보다 큰수만 입력가능합니다."/>';//0보다 큰수만 입력가능합니다.
							break;
						}
						//입력 필드의 적용일 컬럼을 오늘 날짜로 set
						var seq = fieldName.substring(8,10);
						record.set('APPL_DATE' + seq, UniDate.get('today'));
					}
				break;
			}
			return rv;
		}
	}); // validator
	
	
	
	//저장 전 필수입력항목 체크
	function fnEssenInput(list) {
		var flagEssenInput	= true;
		var chkCount		= 0;
		Ext.each(list, function(record,i) {
			for (var i=0;  i <= 15; i ++) {
				if(Ext.isEmpty(record.get('PLAN_QTY' + i)) && Ext.isEmpty(record.get('PLAN_AMT' + i))){
					chkCount = chkCount + 1;
				}
			}
			if (chkCount == 16) {
				Unilite.messageBox(Msg.sMM014);
				flagEssenInput = false;
				return false;
			}
		});
		Ext.each(list, function(record,i) {
			for (var i=0;  i <= 15; i ++) {
				if(Ext.isEmpty(record.get('PLAN_QTY' + i)) && !Ext.isEmpty(record.get('PLAN_AMT' + i))){
					Unilite.messageBox(Msg.sMS441);
					flagEssenInput = false;
					return false;
				}
			}
		});
		return flagEssenInput;
	}
	
	
	
	//그리드 컬럼명 set
	function fnSetColumnName(provider) {
		if(Ext.isEmpty(provider)) {
			return false;
		}
//		var columnName0 = provider.substring(0, 4) + '-' + provider.substring(4, 7);
		for (var i=0;  i <= 15; i ++) {
			var varProvider = (parseInt(provider) + i).toString();
			eval("columnName"+i+"= varProvider.substring(0, 4) + '-' + varProvider.substring(4, 7)");
		}
		
		Ext.getCmp('comlumnName0').setText(columnName0);
		Ext.getCmp('comlumnName1').setText(columnName1);
		Ext.getCmp('comlumnName2').setText(columnName2);
		Ext.getCmp('comlumnName3').setText(columnName3);
		Ext.getCmp('comlumnName4').setText(columnName4);
		Ext.getCmp('comlumnName5').setText(columnName5);
		Ext.getCmp('comlumnName6').setText(columnName6);
		Ext.getCmp('comlumnName7').setText(columnName7);
		Ext.getCmp('comlumnName8').setText(columnName8);
		Ext.getCmp('comlumnName9').setText(columnName9);
		Ext.getCmp('comlumnName10').setText(columnName10);
		Ext.getCmp('comlumnName11').setText(columnName11);
		Ext.getCmp('comlumnName12').setText(columnName12);
		Ext.getCmp('comlumnName13').setText(columnName13);
		Ext.getCmp('comlumnName14').setText(columnName14);
		Ext.getCmp('comlumnName15').setText(columnName15);
	}
	
	
	
	//판매단가 가져와서 금액 계산하는 함수
	function fnSaleCost(itemCode, record, newValue, seq){
		var param = {
			S_COMP_CODE : UserInfo.compCode,
			ITEM_CODE	: itemCode
		}
		sgp200ukrvService.getSaleCost(param, function(provider, response){
			if(Ext.isEmpty(provider)){									//데이터가 없을 때는 validator에서 메세지 처리
				return false;
			} else {
				record.set('PLAN_AMT' + seq, newValue * provider[0].SALE_BASIS_P);
			}
		});
	}
};
</script>
