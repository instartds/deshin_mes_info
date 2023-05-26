<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="opo100ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="opo100ukrv"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" /> <!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B038" /> <!-- 결제조건 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" /> <!-- 단가형태 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="Q002" /> <!-- 품질대상여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 단위 -->
</t:appConfig>
<script type="text/javascript" >

var SearchInfoWindow;	//조회버튼 누르면 나오는 조회창
var excelWindow;	// 엑셀참조
var MRE100TWindow;	// 구매요청등록 참조

var BsaCodeInfo = {
	gsAutoType: '${gsAutoType}',
	gsOrderPrsn: '${gsOrderPrsn}',
	gsOrderPrsnYN: '${gsOrderPrsnYN}',
	gsDefaultMoney: '${gsDefaultMoney}',
	gsApproveYN: '${gsApproveYN}',
	gsScChildStockPopYN: '${gsScChildStockPopYN}'
};

var CustomCodeInfo = {
	gsUnderCalBase: ''
};


/*
var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);
*/

var outDivCode = UserInfo.divCode;
var aa = 0;
function appMain() {
	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y')	{
		isAutoOrderNum = true;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'opo100ukrvService.selectList',
			update: 'opo100ukrvService.updateDetail',
			create: 'opo100ukrvService.insertDetail',
			destroy: 'opo100ukrvService.deleteDetail',
			syncAll: 'opo100ukrvService.saveAll'
		}
	});
	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('Opo100ukrvModel', {
		fields: [
			{name: 'COMP_CODE'	 		,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'				,type: 'string',child:'WH_CODE'},
			{name: 'CUSTOM_CODE'	 	,text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'				,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				,type: 'string',allowBlank: isAutoOrderNum},
			{name: 'ORDER_SEQ'			,text: '<t:message code="system.label.purchase.seq" default="순번"/>'					,type: 'int'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'					,type: 'string'},
			{name: 'STOCK_UNIT'	 		,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'				,type: 'string', displayField: 'value'},
			{name: 'ORDER_UNIT_Q'		,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				,type: 'uniQty'},
			{name: 'ORDER_UNIT'	 		,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				,type: 'string', allowBlank: false,comboType:'AU',comboCode:'B013',displayField: 'value'},
			{name: 'UNIT_PRICE_TYPE'	,text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'				,type: 'string',comboType:'AU',comboCode:'M301', allowBlank: false},
			{name: 'ORDER_UNIT_P'		,text: '<t:message code="system.label.purchase.price" default="단가"/>'					,type: 'uniUnitPrice', allowBlank: false},
			{name: 'ORDER_O'		 	,text: '<t:message code="system.label.purchase.amount" default="금액"/>'					,type: 'uniPrice'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				,type: 'uniDate', allowBlank: false},
			{name: 'WH_CODE'		 	,text: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>'				,type: 'string',store: Ext.data.StoreManager.lookup('whList'), allowBlank: false},
			{name: 'TRNS_RATE'		   ,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'			   ,type: 'float', decimalPrecision: 4, format:'0,000.0000'},
			{name: 'ORDER_Q'		 	,text: '<t:message code="system.label.purchase.inventoryunitqty" default="재고단위량"/>'				,type: 'uniQty'},
			{name: 'PO_REQ_NUM'		 ,text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'		   ,type: 'string'},
			{name: 'PO_SER_NO'		  ,text: '<t:message code="system.label.purchase.purchaserequestseq" default="구매요청순번"/>'		   ,type: 'int'},
			{name: 'ORDER_P'		 	,text: '<t:message code="system.label.purchase.pounitpricestock" default="발주단가(재고)"/>'			,type: 'uniUnitPrice'},
			{name: 'CONTROL_STATUS'		,text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'				,type: 'string',comboType:'AU',comboCode:'M002'},
			{name: 'ORDER_REQ_NUM'		,text: '<t:message code="system.label.purchase.poreserveno" default="발주예정번호"/>'			,type: 'string'},
			{name: 'INSTOCK_Q'			,text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				,type: 'uniQty'},
			{name: 'PRE_CONTROL_STATUS' ,text: '<t:message code="system.label.purchase.oldprocessstatus" default="old진행상태"/>' 			,type: 'string'},
			{name: 'CONTROL_STATUS_V'	,text: '<t:message code="system.label.purchase.processstatusappliedvalue" default="진행상태반영값"/>' 			,type: 'string'},
			{name: 'INSPEC_FLAG'	 	,text: '<t:message code="system.label.purchase.qualityyn" default="품질대상여부"/>'			,type: 'string',comboType:'AU',comboCode:'Q002', defaultValue: 'Y', allowBlank: false},
			{name: 'REMARK'		 		,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					,type: 'string'},
			{name: 'LOT_NO'			   	,text: 'LOT NO' 				,type: 'string'},
			{name: 'MONEY_UNIT'		   	,text: '<t:message code="system.label.purchase.currency" default="화폐"/>' 				,type: 'string'},
			{name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>' 				,type: 'uniQty'},
			{name: 'ORDER_LOC_P'		,text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>' 				,type: 'uniQty'},
			{name: 'ORDER_LOC_O'		,text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>' 				,type: 'uniQty'},
			{name: 'LOT_NO'			   	,text: 'LOT NO' 				,type: 'string'},
			{name: 'PROJECT_NO'		   	,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>' 				,type: 'string'},
			{name: 'SUPPLY_TYPE'	   	,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>' 				,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER'		,type: 'string'},
			{name: 'UPDATE_DB_TIME'	 	,text: 'UPDATE_DB_TIME'		,type: 'string'}
		]
	});

	Unilite.defineModel('orderNoMasterModel', {		//조회버튼 누르면 나오는 조회창
		fields: [
			{name: 'CUSTOM_NAME'				, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'		, type: 'string'},
			{name: 'ORDER_DATE'					, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'		, type: 'uniDate'},
			{name: 'ORDER_TYPE'					, text: '<t:message code="system.label.purchase.poclass" default="발주유형"/>'		, type: 'string',comboType:'AU',comboCode:'M001'},
			{name: 'ORDER_NUM'					, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'		, type: 'string'},
			{name: 'CUSTOM_CODE'				, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'   , type: 'string'},
			{name: 'DEPT_CODE'					, text: '<t:message code="system.label.purchase.departmencode" default="부서코드"/>'   	, type: 'string'},
			{name: 'DEPT_NAME'					, text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'   	, type: 'string'},
			{name: 'ORDER_PRSN'					, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'		, type: 'string',comboType:'AU',comboCode:'M201'},
			{name: 'AGREE_STATUS'				, text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'		, type: 'string',comboType:'AU',comboCode:'M007'},
			{name: 'AGREE_PRSN'					, text: '<t:message code="system.label.purchase.approvaluser" default="승인자"/>'		, type: 'string'},
			{name: 'AGREE_PRSN_NAME'			, text: '<t:message code="system.label.purchase.approvalusername" default="승인자명"/>'		, type: 'string'},
			{name: 'AGREE_DATE'					, text: '<t:message code="system.label.purchase.approvaldate" default="승인일"/>'		, type: 'uniDate'},
			{name: 'MONEY_UNIT'					, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'		, type: 'string'},
			{name: 'RECEIPT_TYPE'				, text: '<t:message code="system.label.purchase.paymentcondition" default="결제조건"/>'		, type: 'string'},
			{name: 'REMARK'						, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'		, type: 'string'},
			{name: 'EXCHG_RATE_O'				, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'		, type: 'string'},
			{name: 'DRAFT_YN'					, text: '<t:message code="system.label.purchase.drafting" default="기안여부"/>'		, type: 'string'},
			{name: 'DIV_CODE'					, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string',comboType:'BOR120'},
			{name: 'PROJECT_NO'					, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'COMP_NAME'	 				, text: '<t:message code="system.label.purchase.companyname" default="회사명"/>'		, type: 'string'}
		]
	});


	Unilite.Excel.defineModel('excel.mpo501.sheet01', {
		fields: [
			{name: 'ITEM_CODE',  	text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>', 		type: 'string'},
			{name: 'QTY',  			text:'<t:message code="system.label.purchase.purchase2qty" default="구매수량"/>', 		type: 'uniQty'},
			{name: 'ITEM_NAME',  	text:'<t:message code="system.label.purchase.itemname" default="품목명"/>', 		type: 'string'},
			{name: 'SPEC',  		text:'<t:message code="system.label.purchase.spec" default="규격"/>', 			type: 'string'},
			{name: 'MONEY_UNIT',  	text:'<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>', 		type: 'string', displayField: 'value'},
			{name: 'EXCHG_RATE_O',  text:'<t:message code="system.label.purchase.exchangerate" default="환율"/>', 			type: 'uniER'},
			{name: 'PRICE',  		text:'<t:message code="system.label.purchase.purchaseprice" default="구매단가"/>', 		type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT',  	text:'<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>', 		type: 'string', displayField: 'value'},
			{name: 'TRNS_RATE',  	text:'<t:message code="system.label.purchase.containedqty" default="입수"/>', 			type: 'uniER'},
			{name: 'STOCK_UNIT',  	text:'<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>', 		type: 'string', displayField: 'value'},
			{name: 'WH_CODE',  		text:'<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>', 		type: 'string'},
			{name: 'INSPEC_YN',  	text:'<t:message code="system.label.purchase.qualityinspectyn" default="품질검사여부"/>', 	type: 'string'},
			{name: 'DVRY_DATE',  	text:'<t:message code="system.label.purchase.deliverydate" default="납기일"/>', 		type: 'uniDate'},
			{name: 'DVRY_TIME',  	text:'<t:message code="system.label.purchase.deliverytime" default="납기시간"/>', 		type: 'string'},
			{name: 'DATA_CHECK',  	text:'<t:message code="system.label.purchase.verificationin" default="검증"/>', 			type: 'string'}
		]
	});

	Unilite.defineModel('Mre100ukrvModel', {	   // 구매요청등록 참조
		fields: [
			{name: 'DIV_CODE'		   ,text: '<t:message code="system.label.purchase.division" default="사업장"/>'				,type: 'string'},
			{name: 'PO_REQ_NUM'		 ,text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'		 ,type: 'string',allowBlank: isAutoOrderNum},
			{name: 'PO_SER_NO'		  ,text: '<t:message code="system.label.purchase.seq" default="순번"/>'				 ,type: 'int', allowBlank: false},
			{name: 'ITEM_CODE'		  ,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			   ,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'		  ,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'SPEC'			   ,text: '<t:message code="system.label.purchase.spec" default="규격"/>'				 ,type: 'string'},
			{name: 'STOCK_UNIT'		 ,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			   ,type: 'string', displayField: 'value'},
			{name: 'R_ORDER_Q'		  ,text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'			   ,type: 'uniQty'},
			{name: 'PAB_STOCK_Q'		,text: '<t:message code="system.label.purchase.onhandqty" default="현재고량"/>'			   ,type: 'uniQty'},
			{name: 'ORDER_UNIT_Q'	   ,text: '<t:message code="system.label.purchase.porequestqty" default="발주요청량"/>(<t:message code="system.label.purchase.stock" default="재고"/>)'	  ,type: 'uniQty', allowBlank: false},
			{name: 'ORDER_UNIT'		 ,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			   ,type: 'string', allowBlank: false,comboType:'AU',comboCode:'B013',displayField: 'value'},
			{name: 'TRNS_RATE'		  ,text: '<t:message code="system.label.purchase.purchasereceiptcount" default="구매입수"/>'			   ,type: 'uniQty'},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.purchase.porequestqty" default="발주요청량"/>'			  ,type: 'uniQty', allowBlank: false},
			{name: 'MONEY_UNIT'		 ,text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'			   ,type: 'string',comboType:'AU',comboCode:'B004', displayField: 'value'},
			{name: 'EXCHG_RATE_O'	   ,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				 ,type: 'uniER'},

			{name: 'UNIT_PRICE_TYPE'	,text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'			   ,type: 'string',comboType:'AU',comboCode:'M301', allowBlank: false},
			{name: 'ORDER_P'			,text: '<t:message code="system.label.purchase.price" default="단가"/>'				 ,type: 'uniUnitPrice', allowBlank: false},
			{name: 'ORDER_O'			,text: '<t:message code="system.label.purchase.amount" default="금액"/>'				 ,type: 'uniPrice'},
			{name: 'ORDER_LOC_P'		,text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'			   ,type: 'uniUnitPrice'},
			{name: 'ORDER_LOC_O'		,text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'			   ,type: 'uniPrice'},

			{name: 'DVRY_DATE'		  ,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				,type: 'uniDate', allowBlank: false},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>'			   ,type: 'string',store: Ext.data.StoreManager.lookup('whList'), allowBlank: false},
			{name: 'SUPPLY_TYPE'		,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'			   ,type: 'string',comboType:'AU',comboCode:'B014'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'			   ,type: 'string'},

			{name: 'PO_REQ_DATE'		,text: '<t:message code="system.label.purchase.poreservedate" default="발주예정일"/>'			  ,type: 'uniDate'},
			{name: 'INSPEC_FLAG'		,text: '<t:message code="system.label.purchase.qualityyn" default="품질대상여부"/>'		 ,type: 'string',comboType:'AU',comboCode:'Q002', allowBlank: false},
			{name: 'REMARK'			 ,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				 ,type: 'string'},

			{name: 'ORDER_REQ_NUM'	  ,text: '<t:message code="system.label.purchase.poreserveno" default="발주예정번호"/>'		 ,type: 'string'},
			{name: 'MRP_CONTROL_NUM'	,text: 'MRP<t:message code="system.label.purchase.number" default="번호"/>'			  ,type: 'string'},
			{name: 'ORDER_YN'		   ,text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'			   ,type: 'string'},

			{name: 'PURCH_LDTIME'	   , text: '<t:message code="system.label.purchase.purchase2" default="구매"/>LT'			  ,type: 'uniQty'},
			{name: 'COMP_CODE'		  ,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			   ,type: 'string'},
			{name: 'UPDATE_DB_USER'	 ,text: 'UPDATE_DB_USER'	 ,type: 'string'},
			{name: 'UPDATE_DB_TIME'	 ,text: 'UPDATE_DB_TIME'	 ,type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('opo100ukrvMasterStore1',{
		model: 'Opo100ukrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
		   	editable: true,			// 수정 모드 사용
		   	deletable: true,			// 삭제 가능 여부
		   	allDeletable: true,
			useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
		proxy: directProxy,
		listeners: {
		   	load: function(store, records, successful, eOpts) {
		   		this.fnSumOrderO();
		   	},
		   	add: function(store, records, index, eOpts) {
		   		this.fnSumOrderO();
		   	},
		   	update: function(store, record, operation, modifiedFieldNames, eOpts) {
		   		this.fnSumOrderO();
		   	},
		   	remove: function(store, record, index, isMove, eOpts) {
		   		this.fnSumOrderO();
		   	}
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();
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
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("ORDER_NUM", master.ORDER_NUM);
						panelResult.setValue("ORDER_NUM", master.ORDER_NUM);
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						if(directMasterStore1.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('opo100ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		fnSumOrderO: function() {
			console.log("=============Exec fnOrderAmtSum()");
			var sSumOrderO = Ext.isNumeric(this.sum('ORDER_O')) ? this.sum('ORDER_O'):0;
			var sSumOrderLocO = Ext.isNumeric(this.sum('ORDER_LOC_O')) ? this.sum('ORDER_LOC_O'):0;
			masterForm.setValue('SumOrderO',sSumOrderO);
			masterForm.setValue('SumOrderLocO',sSumOrderLocO);
		}
	});

	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	//조회버튼 누르면 나오는 조회창
		model: 'orderNoMasterModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'opo100ukrvService.selectOrderNumList'
			}
		},
		loadStoreRecords : function()	{
			var param= orderNoSearch.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var otherOrderStore2 = Unilite.createStore('mpo501ukrvOtherOrderStore2', {	 // 구매요청등록참조
		model: 'Mre100ukrvModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false		 // prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'opo100ukrvService.selectMre100tList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful)  {
				   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
				   var orderRecords = new Array();
				   if(masterRecords.items.length > 0)   {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records,
							function(item, i)   {
								Ext.each(masterRecords.items, function(record, i)   {
									console.log("record :", record);
										if( (record.data['PO_REQ_NUM'] == item.data['PO_REQ_NUM']) && (record.data['PO_SER_NO'] == item.data['PO_SER_NO'])){
											orderRecords.push(item);
										}
								});
							});
					   store.remove(orderRecords);
				   }
				}
			}
		},
		loadStoreRecords : function()   {
			var param= otherorderSearch2.getValues();
			var authoInfo = pgmInfo.authoUser;			  //권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;   //부서코드
			if(authoInfo == "5" && Ext.isEmpty(otherorderSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});


	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var masterForm = Unilite.createSearchPanel('searchForm', {
		title: '발주조건',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
		   	layout: {type: 'uniTable', columns: 1},
		   	defaultType: 'uniTextfield',
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				holdable: 'hold',
				value: UserInfo.divCode,
				child:'WH_CODE',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('ORDER_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
						var field2 = panelResult.getField('WH_CODE');
						field2.getStore().clearFilter(true);
					}
				}
			},
			Unilite.popup('DEPT', {
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
//				allowBlank: false,
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							masterForm.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						if(authoInfo == "A"){	//자기사업장
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				allowBlank: false,
				holdable: 'hold',
				extParam: {'CUSTOM_TYPE': ['1','2']},
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
							masterForm.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
							panelResult.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
							UniAppManager.app.fnExchngRateO();
						},
						scope: this
					},
					onClear: function(type)	{
						CustomCodeInfo.gsUnderCalBase = '';
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'CUSTOM_TYPE':  ['1', '2']});
//						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
					}
				}
			}),
			{
		 		fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
		 		xtype: 'uniDatefield',
		 		name: 'ORDER_DATE',
		 		value: UniDate.get('today'),
		 		allowBlank:false,
		 		holdable: 'hold',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name:'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M001',
				allowBlank:false,
				value: '4',
				readOnly:true
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M201',
				allowBlank:false,
				holdable: 'hold',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					/*
					if(eOpts){
						combo.filterByRefCode('refCode4', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode4', newValue, divCode);
					}
					*/
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_PRSN', newValue);
						var param = {"SUB_CODE": newValue};
						mpo501ukrvService.userName(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								masterForm.setValue('AGREE_PRSN', provider['USER_ID']);
								masterForm.setValue('USER_NAME', provider['USER_NAME']);
								panelResult.setValue('AGREE_PRSN', provider['USER_ID']);
								panelResult.setValue('USER_NAME', provider['USER_NAME']);
							}else{
								masterForm.setValue('USER_NAME', '');
								masterForm.setValue('AGREE_PRSN', '');
								panelResult.setValue('AGREE_PRSN', '');
								panelResult.setValue('USER_NAME', '');
							}
						});
					}
				}
			},{
				fieldLabel:'<t:message code="system.label.purchase.pono" default="발주번호"/>',
				name: 'ORDER_NUM',
				xtype: 'uniTextfield',
				readOnly: isAutoOrderNum,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_NUM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>',
				id:'AGREE_STATUS',
				name:'AGREE_STATUS',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M007',
				readOnly: true,
				holdable: 'hold'
			},{
				xtype: 'container',
				padding: '10 0 0 0',
				layout: {
					type: 'hbox',
					align: 'center',
					pack:'center'
				}
			},{
				fieldLabel:'<t:message code="system.label.purchase.approvaldate" default="승인일"/>',
				id:'AGREE_DATE',
				name: 'AGREE_DATE',
				xtype: 'uniDatefield',
		 		value: UniDate.get('today'),
				readOnly:true
			},{
				fieldLabel:'<t:message code="system.label.purchase.approvaluser" default="승인자"/>ID',
				name: 'AGREE_PRSN',
				xtype: 'uniTextfield'
//				hidden: true
			},
			Unilite.popup('USER_SINGLE', {
				fieldLabel: '<t:message code="system.label.purchase.approvaluser" default="승인자"/>',
				textFieldWidth: 150,
				id: 'AGREE_PRSN_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							masterForm.setValue('AGREE_PRSN', records[0]["USER_ID"]);
							panelResult.setValue('AGREE_PRSN', records[0]["USER_ID"]);
							panelResult.setValue('USER_NAME', masterForm.getValue('USER_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						masterForm.setValue('AGREE_PRSN', '');
						panelResult.setValue('AGREE_PRSN', '');
						panelResult.setValue('USER_NAME', '');
					}
				}

			}),
			Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				textFieldWidth: 150,
				validateBlank: true,
				textFieldName:'PROJECT_NO',
				itemId:'project',
				listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE')});
					}
				}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
				name:'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B004',
				displayField: 'value',
				allowBlank:false,
				fieldStyle: 'text-align: center;',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('MONEY_UNIT', newValue);
					},
					blur: function( field, The, eOpts )	{
						UniAppManager.app.fnExchngRateO();
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.payingmethod" default="결제방법"/>',
				name:'RECEIPT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B038'
			},{
				fieldLabel:'<t:message code="system.label.purchase.exchangerate" default="환율"/>',
				name: 'EXCHG_RATE_O',
				xtype: 'uniTextfield',
				allowBlank:false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EXCHG_RATE_O', newValue);
					}
				}
			},{
				fieldLabel:'<t:message code="system.label.purchase.potatal" default="발주총액"/>',
				name: 'SumOrderO',
				xtype: 'uniNumberfield',
				readOnly: true
			},{
				fieldLabel:'<t:message code="system.label.purchase.cototal" default="자사총액"/>',
				name: 'SumOrderLocO',
				xtype: 'uniNumberfield',
				readOnly: true,
				hidden:true
			},{
				fieldLabel:'<t:message code="system.label.purchase.remarks" default="비고"/>',
				name: 'REMARK',
				xtype: 'uniTextfield'
			},{
				fieldLabel: '<t:message code="system.label.purchase.companyname" default="회사명"/>',
				name:'COMP_NAME',
				xtype: 'uniTextfield',
				hidden: true
			},{
				fieldLabel:'<t:message code="system.label.purchase.drafting" default="기안여부"/>',
				name: 'DRAFT_YN',
				xtype: 'uniTextfield',
				hidden:true
			}]
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
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)	{
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
	});


	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			holdable: 'hold',
			value: UserInfo.divCode,
			child:'WH_CODE',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = masterForm.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					masterForm.setValue('DIV_CODE', newValue);
					var field2 = masterForm.getField('WH_CODE');
					field2.getStore().clearFilter(true);
				}
			}
		},
		Unilite.popup('DEPT', {
			fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
			valueFieldName: 'DEPT_CODE',
	   	 	textFieldName: 'DEPT_NAME',
			holdable: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						masterForm.setValue('WH_CODE',records[0]["WH_CODE"]);
						panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
						masterForm.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
						masterForm.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
					},
					scope: this
				},
				onClear: function(type)	{
					masterForm.setValue('DEPT_CODE', '');
					masterForm.setValue('DEPT_NAME', '');
				},
				applyextparam: function(popup){
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장
					if(authoInfo == "A"){	//자기사업장
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),
		{
			fieldLabel: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			holdable: 'hold',
			store: Ext.data.StoreManager.lookup('whList'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('WH_CODE', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			allowBlank: false,
			holdable: 'hold',
			extParam: {'CUSTOM_TYPE': ['1','2']},
			listeners: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
						masterForm.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
						masterForm.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						masterForm.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
						UniAppManager.app.fnExchngRateO();
					},
					scope: this
				},
				onClear: function(type)	{
					CustomCodeInfo.gsUnderCalBase = '';
					masterForm.setValue('CUSTOM_CODE', '');
					masterForm.setValue('CUSTOM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'CUSTOM_TYPE':  ['1', '2']});
//					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
				}
			}
		}),
		{
	 		fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
	 		xtype: 'uniDatefield',
	 		name: 'ORDER_DATE',
	 		value: UniDate.get('today'),
	 		allowBlank:false,
	 		holdable: 'hold',
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('ORDER_DATE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name:'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M201',
			allowBlank:false,
			holdable: 'hold',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				/*
				if(eOpts){
					combo.filterByRefCode('refCode4', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode4', newValue, divCode);
				}
				*/
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('ORDER_PRSN', newValue);
					var param = {"SUB_CODE": newValue};
					mpo501ukrvService.userName(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
							masterForm.setValue('AGREE_PRSN', provider['USER_ID']);
							masterForm.setValue('USER_NAME', provider['USER_NAME']);
							panelResult.setValue('AGREE_PRSN', provider['USER_ID']);
							panelResult.setValue('USER_NAME', provider['USER_NAME']);
						}else{
							masterForm.setValue('USER_NAME', '');
							masterForm.setValue('AGREE_PRSN', '');
							panelResult.setValue('AGREE_PRSN', '');
							panelResult.setValue('USER_NAME', '');
						}
					});
				}
			}
		},{
			fieldLabel:'<t:message code="system.label.purchase.pono" default="발주번호"/>',
			name: 'ORDER_NUM',
			xtype: 'uniTextfield',
			readOnly: isAutoOrderNum,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('ORDER_NUM', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
			name:'MONEY_UNIT',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B004',
			displayField: 'value',
			allowBlank:false,
			fieldStyle: 'text-align: center;',
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('MONEY_UNIT', newValue);
				},
				blur: function( field, The, eOpts )	{
					UniAppManager.app.fnExchngRateO();
				}
			}
		},{
			fieldLabel:'<t:message code="system.label.purchase.exchangerate" default="환율"/>',
			name: 'EXCHG_RATE_O',
			xtype: 'uniTextfield',
			allowBlank:false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('EXCHG_RATE_O', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>',
			id:'AGREE_STATUSr',
			name:'AGREE_STATUS',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M007',
			readOnly: true,
			holdable: 'hold'
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
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)	{
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
	});

	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			value: UserInfo.divCode,
			child:'WH_CODE',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = orderNoSearch.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					var field2 = orderNoSearch.getField('WH_CODE');
					field2.getStore().clearFilter(true);
				}
			}
		},
		Unilite.popup('DEPT', {
			fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
			valueFieldName: 'DEPT_CODE',
	   	 	textFieldName: 'DEPT_NAME',
			listeners: {
				applyextparam: function(popup){
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장
					if(authoInfo == "A"){	//자기사업장
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),
		{
			fieldLabel: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('whList')
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
//				extParam: {'CUSTOM_TYPE': ['1','2']}
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'CUSTOM_TYPE':  ['1', '2']});
//					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
				}
			}
		}),
		{
			fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315
		},{
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name:'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M201',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				/*
				if(eOpts){
					combo.filterByRefCode('refCode4', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode4', newValue, divCode);
				}
				*/
			}
		},{
			fieldLabel:'<t:message code="system.label.purchase.pono" default="발주번호"/>',
			name: 'ORDER_NUM',
			xtype: 'uniTextfield'
		},{
			fieldLabel: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>',
			id:'AGREE_STATUSp',
			name:'AGREE_STATUS',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M007'
		}]
	});

	var otherorderSearch2 = Unilite.createSearchForm('otherorderForm2', {	 // 구매요청등록 참조
		layout: {type : 'uniTable', columns : 3},
		items :[{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value: UserInfo.divCode
			},
			{
				fieldLabel:'<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>',
				name: 'PO_REQ_NUM',
				xtype: 'uniTextfield',
				readOnly: isAutoOrderNum
			},
			{
				fieldLabel: '<t:message code="system.label.purchase.requestdate" default="요청일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PO_REQ_DATE_FR',
				endFieldName: 'PO_REQ_DATE_TO',
				allowBlank: false,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},
			Unilite.popup('DEPT', {
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
				valueFieldName: 'DEPT_CODE',
				textFieldName: 'DEPT_NAME',
				listeners: {
					applyextparam: function(popup){
						var authoInfo = pgmInfo.authoUser;			  //권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;   //부서정보
						var divCode = '';				   //사업장
						if(authoInfo == "A"){   //자기사업장
							popup.setExtParam({'TREE_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
							popup.setExtParam({'TREE_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}else if(authoInfo == "5"){	 //부서권한
							popup.setExtParam({'TREE_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),
			Unilite.popup('Employee',{
				fieldLabel: '<t:message code="system.label.purchase.employee" default="사원"/>',
				valueFieldName:'PERSON_NUMB',
				textFieldName:'PERSON_NAME',
				autoPopup:true
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
				name:'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B004',
				displayField: 'value',
				fieldStyle: 'text-align: center;',
				value: BsaCodeInfo.gsDefaultMoney
			},
			{
				fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>',
				name: 'SUPPLY_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B014',
				allowBlank:false,
				value: '3',
				readOnly: true
			},
			{
				fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020'
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
//				extParam: {'CUSTOM_TYPE': ['1','2']}
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'CUSTOM_TYPE':  ['1', '2']});
//						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
					}
				}
			})
		]
	});



	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid= Unilite.createGrid('opo100ukrvGrid', {
		region: 'center' ,
		layout: 'fit',
		excelTitle: '<t:message code="system.label.purchase.poentry" default="발주등록"/>',
		uniOpt: {
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		tbar: [{
			xtype: 'splitbutton',
			itemId:'orderTool',
			text: '<t:message code="system.label.purchase.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
						itemId: 'otherorderBtn2',
						text: '<t:message code="system.label.purchase.purchaserequestinputrefer" default="구매요청등록참조"/>',
						handler: function() {
							openMRE100TWindow();
						}
					}/*, {
						itemId: 'excelBtn',
						text: '엑셀참조',
						handler: function() {
								openExcelWindow();
						}
				}*/]
			})
		}],
		store: directMasterStore1,
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		columns: [
			{dataIndex:'DIV_CODE'					, width: 93 ,hidden: true},
			{dataIndex:'CUSTOM_CODE'				, width: 93 ,hidden: true},
			{dataIndex:'ORDER_NUM'					, width: 110 ,hidden: true},
			{dataIndex:'ORDER_SEQ'					, width: 40 ,locked: false, align: 'center'},
			{dataIndex:'ITEM_CODE'					, width: 120 ,locked: false,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					useBarcodeScanner: false,
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var a = masterGrid.uniOpt.currentRecord.get('ITEM_CODE');
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
							masterGrid.uniOpt.currentRecord.set('ITEM_CODE',a);
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
				})
			},
			{dataIndex:'ITEM_NAME'					, width: 250 ,locked: false,
				editor: Unilite.popup('DIV_PUMOK_G', {
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
				})
			},
			{dataIndex:'SPEC'					, width: 138 },
			{dataIndex:'STOCK_UNIT'	 			, width: 88 , align: 'center'},
			{dataIndex:'ORDER_UNIT_Q'			, width: 93 },
			{dataIndex:'ORDER_UNIT'	 			, width: 88 , align: 'center'},
			{dataIndex:'UNIT_PRICE_TYPE'		, width: 88 , align: 'center'},
			{dataIndex:'ORDER_UNIT_P'			, width: 93 },
			{dataIndex:'ORDER_O'				, width: 106 },
			{dataIndex:'DVRY_DATE'				, width: 80 },
			{dataIndex:'WH_CODE'				, width: 120 },
			{dataIndex:'TRNS_RATE'				, width: 93, xtype: 'uniNnumberColumn'},
			{dataIndex:'ORDER_Q'				, width: 93 },
			{dataIndex:'PO_REQ_NUM'			 , width: 93 ,hidden : true},
			{dataIndex:'PO_SER_NO'			  , width: 93 ,hidden : true},
			{dataIndex:'ORDER_P'				, width: 93 ,hidden : true},
			{dataIndex:'CONTROL_STATUS'			, width: 100 , align: 'center'},
			{dataIndex:'PRE_CONTROL_STATUS'	 	, width: 66, hidden: true},
			{dataIndex:'CONTROL_STATUS_V' 		, width: 66, hidden: true},
			{dataIndex:'ORDER_REQ_NUM'			, width: 100 },
			{dataIndex:'INSTOCK_Q'				, width: 100 ,hidden : true},
			{dataIndex:'INSPEC_FLAG'			, width: 100 , align: 'center'},
			{dataIndex:'REMARK'			   	 	, width: 200},
			{dataIndex:'MONEY_UNIT'	   	 		, width: 80, hidden:true},
			{dataIndex:'EXCHG_RATE_O'	 		, width: 80, hidden : true},
			{dataIndex:'ORDER_LOC_P'			, width: 100 ,hidden : true},
			{dataIndex:'ORDER_LOC_O'			, width: 100 ,hidden : true},
			{dataIndex:'LOT_NO'			   		, width: 100},
			{dataIndex:'PROJECT_NO'		   	 	, width: 200},
			{dataIndex:'SUPPLY_TYPE'	   	 	, width: 133 ,hidden:true},
			{dataIndex:'COMP_CODE'	 			, width: 10 ,hidden : true},
			{dataIndex:'UPDATE_DB_USER'			, width: 10 ,hidden : true},
			{dataIndex:'UPDATE_DB_TIME'			, width: 10 ,hidden : true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if((e.record.data.CONTROL_STATUS > '1' && e.record.data.CONTROL_STATUS != '9') || /*top.gsAutoOrder <> "Y" &&*/ masterForm.getValue('ORDER_YN') > '1'){
					if(e.field=='CONTROL_STATUS') return false;
				}
				if(e.record.phantom){
					if(e.record.data.ORDER_REQ_NUM != ''){
						if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','ORDER_SEQ','ORDER_O'])) return false;
					}else{
					if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','ORDER_SEQ'])) return true;
					}
				}
				if(UniUtils.indexOf(e.field, [
					'ORDER_UNIT','DVRY_DATE','DVRY_TIME','ORDER_UNIT_P','MONEY_UNIT','EXCHG_RATE_O',
					'ORDER_LOC_P','ORDER_LOC_O','WH_CODE','UNIT_PRICE_TYPE','ORDER_UNIT_Q',/*'ORDER_O',*/
					'REMARK','PROJECT_NO','CONTROL_STATUS','INSPEC_FLAG'
				]))	return true;
				if(e.record.data.ORDER_UNIT != e.record.data.STOCK_UNIT){
					if(e.field=='TRNS_RATE') return true;
				}else{
					if(e.field=='TRNS_RATE') return false;
				}
				return false;
			}
		},
		disabledLinkButtons: function(b) {
	   		this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
	   		this.down('#procTool').menu.down('#issueLinkBtn').setDisabled(b);
	   		this.down('#procTool').menu.down('#saleLinkBtn').setDisabled(b);
		},
		setItemData: function(record, dataClear, grdRecord) {
	   		if(dataClear) {
	   			grdRecord.set('ITEM_CODE'			,"");
	   			grdRecord.set('ITEM_NAME'			,"");
				grdRecord.set('ITEM_ACCOUNT'		,"");
				grdRecord.set('SPEC'				,"");
				grdRecord.set('ORDER_UNIT'			,"");
				grdRecord.set('STOCK_UNIT'			,"");
				grdRecord.set('TRNS_RATE'			,'1');
				grdRecord.set('ORDER_P'				,0);
				grdRecord.set('DVRY_DATE'			,UniDate.get('today'));
				grdRecord.set('ORDER_UNIT_P'		,0);
				grdRecord.set('WH_CODE'			  , '');
	   		} else {
	   			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
	   			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
	   			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
				grdRecord.set('ORDER_P'				, record['BASIS_P']);
				grdRecord.set('DVRY_DATE'			, moment().add('day',record['PURCH_LDTIME']).format('YYYYMMDD'));
				grdRecord.set('WH_CODE'			 , record['WH_CODE']);
				var param = {"DIV_CODE": record['DIV_CODE'],
							 "DEPT_CODE": masterForm.getValue('DEPT_CODE')};
				mpo501ukrvService.callDeptInspecFlag(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						grdRecord.set('INSPEC_FLAG', provider['INSPEC_FLAG']);
					}
				});
				var param = {"ITEM_CODE": record['ITEM_CODE'],
							"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE'),
							"DIV_CODE": masterForm.getValue('DIV_CODE'),
							"MONEY_UNIT": masterForm.getValue('MONEY_UNIT'),
							"ORDER_UNIT": record['ORDER_UNIT'],
							"ORDER_DATE": masterForm.getValue('ORDER_DATE')
							};
				mpo501ukrvService.fnOrderPrice(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						grdRecord.set('ORDER_UNIT_P', provider['ORDER_P']);
					}
				});
				UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
	   		}
		},
		setOrderData:function(record) {
	   		var grdRecord = this.getSelectedRecord();
	   		grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));
	   		grdRecord.set('CUSTOM_CODE'			, masterForm.getValue('CUSTOM_CODE'));
			grdRecord.set('ORDER_NUM'			, '');
			grdRecord.set('CONTROL_STATUS'		, '1');
			grdRecord.set('ORDER_Q'				, '0');
			grdRecord.set('ORDER_P'				, '0');
			grdRecord.set('ORDER_UNIT_Q'		, '0');
			grdRecord.set('UNIT_PRICE_TYPE'		, 'Y');
			grdRecord.set('ORDER_UNIT_P'		, '0');
			grdRecord.set('ORDER_O'				, '0');
			grdRecord.set('TRNS_RATE'			, '1');
			grdRecord.set('INSTOCK_Q'			, '0');
			grdRecord.set('DVRY_DATE'			, UniDate.get('today'));
			grdRecord.set('COMP_CODE'			, record['COMP_CODE']);
			//grdRecord.set('MONEY_UNIT'			, masterForm.getValue('MONEY_UNIT'));
			//grdRecord.set('EXCHG_RATE_O'		, masterForm.getValue('EXCHG_RATE_O'));
			//grdRecord.set('ORDER_LOC_P'			, '0');
			//grdRecord.set('ORDER_LOC_O'			, '0');
			if(Ext.isEmpty(masterForm.getValue('PROJECT_NO'))){
				grdRecord.set('PROJECT_NO'		,masterForm.getValue('PROJECT_NO'));
			}
			if(Ext.isEmpty(masterForm.getValue('REMARK'))){
				grdRecord.set('REMARK'		,masterForm.getValue('REMARK'));
			}
			var param = {"DIV_CODE": record['DIV_CODE'],
				"DEPT_CODE": masterForm.getValue('DEPT_CODE')};
			opo100ukrvService.callDeptInspecFlag(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					grdRecord.set('INSPEC_FLAG', provider['INSPEC_FLAG']);
				}
			});
		},
		setEstiData: function(record) {					 // 구매요청등록참조 셋팅
			var grdRecord = this.getSelectedRecord();
//			grdRecord.set('ORDER_NUM'		  , record['']);
//			grdRecord.set('ORDER_SEQ'		  , record['']);
			grdRecord.set('DIV_CODE'		   , record['DIV_CODE']);
			grdRecord.set('ITEM_CODE'		  , record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		  , record['ITEM_NAME']);
//			grdRecord.set('CUSTOM_CODE'		, masterForm.setValue('CUSTOM_CODE'));
//			grdRecord.set('CONTROL_STATUS'	 , 'Y');
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('PO_REQ_NUM'		 , record['PO_REQ_NUM']);
			grdRecord.set('PO_SER_NO'		 , record['PO_SER_NO']);
			grdRecord.set('ORDER_P'			, record['ORDER_P']);
			grdRecord.set('ORDER_UNIT_Q'	   , record['ORDER_UNIT_Q']);
			grdRecord.set('ORDER_Q'			, grdRecord.get('ORDER_UNIT_Q') * grdRecord.get('TRNS_RATE'));
			grdRecord.set('ORDER_UNIT'	   , record['ORDER_UNIT']);
			grdRecord.set('UNIT_PRICE_TYPE'	, record['UNIT_PRICE_TYPE']);
			grdRecord.set('ORDER_UNIT_P'	   , record['ORDER_P']);
			grdRecord.set('ORDER_O'			, record['ORDER_O']);
			grdRecord.set('TRNS_RATE'		  , '1');
//			grdRecord.set('INSTOCK_Q'		  , record['']);
			grdRecord.set('DVRY_DATE'		  , record['DVRY_DATE']);
			grdRecord.set('COMP_CODE'		  , UserInfo.compCode);
			grdRecord.set('MONEY_UNIT'		 , record['MONEY_UNIT']);
			grdRecord.set('EXCHG_RATE_O'	   , record['EXCHG_RATE_O']);
			grdRecord.set('ORDER_LOC_P'		, record['ORDER_LOC_P']);
			grdRecord.set('ORDER_LOC_O'		, record['ORDER_LOC_O']);
			grdRecord.set('WH_CODE'			, record['WH_CODE']);
			grdRecord.set('SPEC'			, record['SPEC']);
//			grdRecord.set('WH_CODE'			, record['']);
			grdRecord.set('INSPEC_FLAG'			, record['INSPEC_FLAG']);


		}
	});

	var orderNoMasterGrid = Unilite.createGrid('opo100ukrvOrderNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
		layout : 'fit',
		title: '<t:message code="system.label.purchase.ponosearch2" default="발주번호검색"/>',
		store: orderNoMasterStore,
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false
		},
		columns: [
			{ dataIndex: 'CUSTOM_NAME'			,  width: 180},
			{ dataIndex: 'ORDER_DATE'			,  width: 110},
			{ dataIndex: 'ORDER_TYPE'			,  width: 93,align:'center'},
			{ dataIndex: 'ORDER_NUM'			,  width: 133,align:'center'},
			{ dataIndex: 'CUSTOM_CODE'	   		,  width: 80,hidden:true},
			{ dataIndex: 'DEPT_CODE'	   		,  width: 80,hidden:true},
			{ dataIndex: 'DEPT_NAME'	   		,  width: 80,hidden:true},
			{ dataIndex: 'ORDER_PRSN'			,  width: 93,align:'center'},
			{ dataIndex: 'AGREE_STATUS'			,  width: 66,align:'center'},
			{ dataIndex: 'AGREE_PRSN'			,  width: 100,hidden:true},
			{ dataIndex: 'AGREE_PRSN_NAME'	  ,  width: 100,hidden:true},
			{ dataIndex: 'AGREE_DATE'			,  width: 66,hidden:true},
			{ dataIndex: 'MONEY_UNIT'			,  width: 66,hidden:true},
			{ dataIndex: 'RECEIPT_TYPE'			,  width: 66,hidden:true},
			{ dataIndex: 'REMARK'				,  width: 66,hidden:true},
			{ dataIndex: 'EXCHG_RATE_O'		,  width: 66,hidden:true},
			{ dataIndex: 'DRAFT_YN'			,  width: 66,hidden:true},
			{ dataIndex: 'DIV_CODE'			,  width: 66,hidden:true},
			{ dataIndex: 'PROJECT_NO'		,  width: 150},
			{ dataIndex: 'COMP_NAME'		,  width: 200,hidden:true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record)	{
			if(Ext.isEmpty(record))	{
				record = this.getSelectedRecord();
			}
			masterForm.setValues({
				'DIV_CODE':record.get('DIV_CODE'),
				'CUSTOM_CODE':record.get('CUSTOM_CODE'),
				'CUSTOM_NAME':record.get('CUSTOM_NAME'),
				'ORDER_DATE':record.get('ORDER_DATE'),
				'ORDER_TYPE':record.get('ORDER_TYPE'),
				'ORDER_PRSN':record.get('ORDER_PRSN'),
				'ORDER_NUM':record.get('ORDER_NUM'),
				'MONEY_UNIT':record.get('MONEY_UNIT'),
				'EXCHG_RATE_O':record.get('EXCHG_RATE_O'),
				'COMP_NAME':record.get('COMP_NAME'),
				'AGREE_STATUS':record.get('AGREE_STATUS'),
				'AGREE_PRSN_NAME':record.get('AGREE_PRSN_NAME'),
				'AGREE_PRSN':record.get('AGREE_PRSN'),
				'DRAFT_YN':record.get('DRAFT_YN'),
				'DEPT_CODE':record.get('DEPT_CODE'),
				'DEPT_NAME':record.get('DEPT_NAME')
		  	});
		  	panelResult.setValues({
		  		'DIV_CODE':record.get('DIV_CODE'),
		  		'DEPT_CODE':record.get('DEPT_CODE'),
		  		'DEPT_NAME':record.get('DEPT_NAME'),
		  		'ORDER_NUM':record.get('ORDER_NUM'),
		  		'CUSTOM_CODE':record.get('CUSTOM_CODE'),
		  		'CUSTOM_NAME':record.get('CUSTOM_NAME'),
		  		'ORDER_DATE':record.get('ORDER_DATE'),
		  		'ORDER_PRSN':record.get('ORDER_PRSN'),
				'AGREE_STATUS':record.get('AGREE_STATUS'),
		  		'AGREE_PRSN_NAME':record.get('AGREE_PRSN_NAME')
		  	});
		}
	});


	function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.ponosearch2" default="발주번호검색"/>',
				width: 960,
				height: 380,
				layout: {type:'vbox', align:'stretch'},
				items: [orderNoSearch, orderNoMasterGrid], //orderNoDetailGrid],
				tbar:  ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						orderNoMasterStore.loadStoreRecords();
					},
					disabled: false
				}, {
					itemId : 'OrderNoCloseBtn',
					text: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler: function() {
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
					 	orderNoSearch.setValue('DIV_CODE',		masterForm.getValue('DIV_CODE'));
					 	orderNoSearch.setValue('DEPT_CODE',		masterForm.getValue('DEPT_CODE'));
					 	orderNoSearch.setValue('DEPT_NAME',		masterForm.getValue('DEPT_NAME'));
					 	orderNoSearch.setValue('WH_CODE',		masterForm.getValue('WH_CODE'));
					 	orderNoSearch.setValue('CUSTOM_CODE',	masterForm.getValue('CUSTOM_CODE'));
					 	orderNoSearch.setValue('CUSTOM_NAME',	masterForm.getValue('CUSTOM_NAME'));
					 	orderNoSearch.setValue('ORDER_DATE_FR',	UniDate.get('startOfMonth'));
						orderNoSearch.setValue('ORDER_DATE_TO',	masterForm.getValue('ORDER_DATE'));
					 	orderNoSearch.setValue('ORDER_PRSN',	masterForm.getValue('ORDER_PRSN'));
					 	orderNoSearch.setValue('ORDER_TYPE',	masterForm.getValue('ORDER_TYPE'));
					 	if(BsaCodeInfo.gsApproveYN == '2'){
					 		orderNoSearch.setValue('AGREE_STATUS','2');
					 	}else if(BsaCodeInfo.gsApproveYN == '1'){
					 		orderNoSearch.setValue('AGREE_STATUS',masterForm.getValue('AGREE_STATUS'));
					 	}
					 }
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}


	function openExcelWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUploadWin';
		if(!excelWindow) {
			excelWindow =  Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				width: 830,
				height: 580,
				modal: false,
				excelConfigName: 'mpo501',
				extParam: {
					'DIV_CODE': masterForm.getValue('DIV_CODE'),
					'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE'),
					'MONEY_UNIT': masterForm.getValue('MONEY_UNIT'),
					'ORDER_DATE': UniDate.getDateStr( masterForm.getValue('ORDER_DATE'))
				},
				grids: [{
					itemId: 'grid01',
					title: '<t:message code="system.label.purchase.ponoinfo" default="발주정보"/>',
					useCheckbox: true,
					model : 'excel.mpo501.sheet01',
					readApi: 'opo100ukrvService.selectExcelUploadSheet1',
					columns: [
		 			 	{ dataIndex: 'ITEM_CODE',  	  	width: 120},
		 			 	{ dataIndex: 'QTY',  		  		width: 100},
		 			 	{ dataIndex: 'ITEM_NAME',  	  	width: 250},
		 			 	{ dataIndex: 'SPEC',  		  		width: 88},
		 			 	{ dataIndex: 'MONEY_UNIT',			width: 88, align: 'center'},
		 			 	{ dataIndex: 'EXCHG_RATE_O',  		width: 88},
		 			 	{ dataIndex: 'PRICE',  		  	width: 88},
		 			 	{ dataIndex: 'ORDER_UNIT',			width: 88, align: 'center'},
		 			 	{ dataIndex: 'TRNS_RATE',  	  	width: 88},
		 			 	{ dataIndex: 'STOCK_UNIT',			width: 88},
		 			 	{ dataIndex: 'WH_CODE',  	  		width: 120},
		 			 	{ dataIndex: 'INSPEC_YN',  	  	width: 120},
		 			 	{ dataIndex: 'DVRY_DATE',  	  	width: 120},
		 			 	{ dataIndex: 'DVRY_TIME',  	  	width: 120},
		 			 	{ dataIndex: 'DATA_CHECK',			width: 120}
					],
					listeners: {
						afterrender: function(grid) {
							var me = this;
							this.contextMenu = Ext.create('Ext.menu.Menu', {});
							this.contextMenu.add({
								text: '<t:message code="system.label.purchase.goodsinfoentry" default="상품정보등록"/>',   iconCls : '',
								handler: function(menuItem, event) {
									var records = grid.getSelectionModel().getSelection();
									var record = records[0];
									var params = {
										appId: UniAppManager.getApp().id,
										sender: me,
										action: 'excelNew',
										_EXCEL_JOBID: excelWindow.jobID,
										_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'),
										ITEM_CODE: record.get('ITEM_CODE'),
										DIV_CODE: masterForm.getValue('DIV_CODE')
									}
										var rec = {data : {prgID : 'bpr101ukrv', 'text':''}};
										parent.openTab(rec, '/base/bpr101ukrv.do', params);
									}
							});
							this.contextMenu.add({
								text: '<t:message code="system.label.purchase.bookinfoentry" default="도서정보등록"/>',   iconCls : '',
								handler: function(menuItem, event) {
									var records = grid.getSelectionModel().getSelection();
									var record = records[0];
									var params = {
										appId: UniAppManager.getApp().id,
										sender: me,
										action: 'excelNew',
										_EXCEL_JOBID: excelWindow.jobID,
										_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'),
										ITEM_CODE: record.get('ITEM_CODE'),
										DIV_CODE: masterForm.getValue('DIV_CODE')
									}
									var rec = {data : {prgID : 'bpr102ukrv', 'text':''}};
									parent.openTab(rec, '/base/bpr102ukrv.do', params);
								}
							});
				   			me.on('cellcontextmenu', function( view, cell, cellIndex, record, row, rowIndex, event ) {
								event.stopEvent();
								if(record.get('_EXCEL_HAS_ERROR') == 'Y')
									me.contextMenu.showAt(event.getXY());
							});
						}
					}
				}],
				listeners: {
					close: function() {
						this.hide();
					}
				},
				onApply:function()	{
					var grid = this.down('#grid01');
					var records = grid.getSelectionModel().getSelection();
					Ext.each(records, function(record,i){
						UniAppManager.app.onNewDataButtonDown();
						detailGrid.setExcelData(record.data);
					});
					grid.getStore().remove(records);
				}
			 });
		}
		excelWindow.center();
		excelWindow.show();
	};

	var otherorderGrid2 = Unilite.createGrid('mpo501ukrvOtherorderGrid2', {	//구매요청등록참조
		layout: 'fit',
		store: otherOrderStore2,
		uniOpt: {
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns: [
			{dataIndex:'DIV_CODE'			   , width: 93 ,hidden: true},
			{dataIndex:'CUSTOM_CODE'			, width: 93 ,hidden: true},
			{dataIndex:'PO_REQ_NUM'			 , width: 110 ,hidden: true},
			{dataIndex:'PO_SER_NO'			  , width: 55, align: 'center' },
			{dataIndex:'ITEM_CODE'			  , width: 120 },
			{dataIndex:'ITEM_NAME'			  , width: 250 },
			{dataIndex:'SPEC'				   , width: 138 },
			{dataIndex:'STOCK_UNIT'			 , width: 88 , align: 'center'},
			{dataIndex:'R_ORDER_Q'			  , width: 90 },
			{dataIndex:'PAB_STOCK_Q'			, width: 90 },
			{dataIndex:'ORDER_UNIT_Q'		   , width: 125 },
			{dataIndex:'ORDER_UNIT'			 , width: 88 , align: 'center'},
			{dataIndex:'TRNS_RATE'			  , width: 93 },
			{dataIndex:'ORDER_Q'				, width: 93 },
			{dataIndex:'MONEY_UNIT'			 , width: 73 ,hidden : true},
			{dataIndex:'EXCHG_RATE_O'		   , width: 80 ,hidden : true},

			{dataIndex:'UNIT_PRICE_TYPE'		, width: 88 , align: 'center'},
			{dataIndex:'ORDER_P'				, width: 93 },
			{dataIndex:'ORDER_O'				, width: 106 },
			{dataIndex:'ORDER_LOC_P'			, width: 93 },
			{dataIndex:'ORDER_LOC_O'			, width: 106 },

			{dataIndex:'SUPPLY_TYPE'			, width: 80 ,hidden : true},
			{dataIndex: 'CUSTOM_CODE'		   ,width: 90},
			{dataIndex: 'CUSTOM_NAME'		   ,width: 106 },
			{dataIndex:'DVRY_DATE'			  , width: 80 },

			{dataIndex:'PO_REQ_DATE'			, width: 80 },
			{dataIndex:'WH_CODE'				, width: 120 , align: 'center'},
			{dataIndex:'INSPEC_FLAG'			, width: 100 , align: 'center'},
			{dataIndex:'REMARK'				 , width: 200 },

			{dataIndex:'ORDER_REQ_NUM'		  , width: 100 },
			{dataIndex:'MRP_CONTROL_NUM'		, width: 100 },
			{dataIndex:'ORDER_YN'			   , width: 80 ,hidden : true},
			{dataIndex:'PURCH_LDTIME'		   , width: 80 ,hidden : true},
			{dataIndex:'COMP_CODE'			  , width: 10 ,hidden : true},
			{dataIndex:'UPDATE_DB_USER'		 , width: 10 ,hidden : true},
			{dataIndex:'UPDATE_DB_TIME'		 , width: 10 ,hidden : true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function()  {
			var records = this.getSelectedRecords();

			Ext.each(records, function(record,i) {
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setEstiData(record.data);
			});
			this.getStore().remove(records);
		}
	});

	function openMRE100TWindow() {		  //구매요청등록참조
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!MRE100TWindow) {
			MRE100TWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.purchaserequestinputrefer" default="구매요청등록참조"/>',
				width: 1200,
				height: 350,
				layout: {type:'vbox', align:'stretch'},
				items: [otherorderSearch2, otherorderGrid2],
				tbar: ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						otherOrderStore2.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmCloseBtn',
					text: '<t:message code="system.label.purchase.afterapplyclose" default="적용 후 닫기"/>',
					handler: function() {
						otherorderGrid2.returnData();
						MRE100TWindow.hide();
//						directMasterStore1.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler: function() {
						MRE100TWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					 beforeshow: function ( me, eOpts ) {
					 	otherorderSearch2.setValue('DIV_CODE', masterForm.getValue('DIV_CODE'));
						otherorderSearch2.setValue('PO_REQ_DATE_TO', UniDate.get('today'));
						otherorderSearch2.setValue('PO_REQ_DATE_FR', UniDate.get('startOfMonth', otherorderSearch2.getValue('PO_REQ_DATE_TO')));
						otherorderSearch2.setValue('SUPPLY_TYPE', '3');
						otherorderSearch2.setValue('MONEY_UNIT', BsaCodeInfo.gsDefaultMoney);
						otherOrderStore2.loadStoreRecords();
					 }
		}
			})
		}
		MRE100TWindow.center();
		MRE100TWindow.show();
	};

	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			masterForm
		],
		id: 'opo100ukrvApp',
		fnInitBinding: function() {
//			masterForm.setValue('DEPT_CODE',UserInfo.deptCode);
//			masterForm.setValue('DEPT_NAME',UserInfo.deptName);
//			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			UniAppManager.setToolbarButtons(['reset','newData','print', 'prev', 'next'], true);
			this.setDefault();
			masterForm.setValue('ORDER_PRSN',BsaCodeInfo.gsOrderPrsn);
			panelResult.setValue('ORDER_PRSN',BsaCodeInfo.gsOrderPrsn);
			if(BsaCodeInfo.gsApproveYN == '1'){
				Ext.getCmp('AGREE_DATE').setHidden(false);
				Ext.getCmp('AGREE_STATUS').setHidden(false);
				Ext.getCmp('AGREE_PRSN_NAME').setHidden(false);
				Ext.getCmp('AGREE_STATUSr').setHidden(false);
				Ext.getCmp('AGREE_STATUSp').setHidden(false);
			}else if(BsaCodeInfo.gsApproveYN == '2'){
				Ext.getCmp('AGREE_DATE').setHidden(true);
				Ext.getCmp('AGREE_STATUS').setHidden(true);
				Ext.getCmp('AGREE_PRSN_NAME').setHidden(true);
				Ext.getCmp('AGREE_STATUSr').setHidden(true);
				Ext.getCmp('AGREE_STATUSp').setHidden(true);
				masterForm.setValue('AGREE_STATUS','2');
				panelResult.setValue('AGREE_STATUS','2');
			}
			mpo501ukrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			});
			var param = {"SUB_CODE": BsaCodeInfo.gsOrderPrsn};
			mpo501ukrvService.userName(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('AGREE_PRSN',provider['USER_ID']);
					panelResult.setValue('AGREE_PRSN',provider['USER_ID']);
					masterForm.setValue('USER_NAME',provider['USER_NAME']);
					panelResult.setValue('USER_NAME',provider['USER_NAME']);

				}
			});
		},
		onQueryButtonDown: function()	{
			masterForm.setAllFieldsReadOnly(false);
			var orderNo = masterForm.getValue('ORDER_NUM');
			if(Ext.isEmpty(orderNo)) {
				openSearchInfoWindow()
			} else {
				directMasterStore1.loadStoreRecords();
				masterForm.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
			 var orderNum = masterForm.getValue('ORDER_NUM');
			 var seq = directMasterStore1.max('ORDER_SEQ');
			 if(!seq) seq = 1;
			 else  seq += 1;
			 var divCode = masterForm.getValue('DIV_CODE');
			 var cutomCode = masterForm.getValue('CUSTOM_CODE');
			 var controlStatus = '1';
			 var orderQ = '0';
			 var orderP = '0';
			 var orderUnitQ = '0';
			 var unitPriceType = 'Y';
			 var orderUnitP = '0';
			 var orderO = '0';
			 var trnsRate = '1';
			 var instockQ = '0';
			 var dvryDate = UniDate.get('today');
			 var compCode = masterForm.getValue('COMP_CODE');
			 var moneyUnit = masterForm.getValue('MONEY_UNIT'); // MoneyUnit
			 var exchgRateO = masterForm.getValue('EXCHG_RATE_O');
			 var orderLocP = '0';
			 var orderLocO = '0';
			 var whCode = masterForm.getValue('WH_CODE');
			 var r = {
				ORDER_NUM: orderNum,
				ORDER_SEQ: seq,
				DIV_CODE: divCode,
				CUSTOM_CODE: cutomCode,
				CONTROL_STATUS: controlStatus,
				ORDER_Q: orderQ,
				ORDER_P: orderP,
				ORDER_UNIT_Q: orderUnitQ,
				UNIT_PRICE_TYPE: unitPriceType,
				ORDER_UNIT_P: orderUnitP,
				ORDER_O: orderO,
				TRNS_RATE: trnsRate,
				INSTOCK_Q: instockQ,
				DVRY_DATE: dvryDate,
				COMP_CODE: compCode,
				MONEY_UNIT: moneyUnit,
				EXCHG_RATE_O: exchgRateO,
				ORDER_LOC_P: orderLocP,
				ORDER_LOC_O: orderLocO,
				WH_CODE: whCode
			};
			masterGrid.createRow(r);
			masterForm.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(!directMasterStore1.isDirty())	{
				if(masterForm.isDirty())	{
					masterForm.saveForm();
				}
			}else {
				directMasterStore1.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('INSPEC_Q') > 1)
				{
					alert('<t:message code="system.message.purchase.message049" default="검사된 수량이 존재합니다. 데이터를 삭제할 수 없습니다."/>');
				}else{
					masterGrid.deleteSelectedRow();
				}
			}
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore1.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('<t:message code="system.message.purchase.message008" default="전체삭제 하시겠습니까?"/>')) {
						if(record.get('INSPEC_Q') > 1){
								alert('<t:message code="system.message.purchase.message049" default="검사된 수량이 존재합니다. 데이터를 삭제할 수 없습니다."/>');
						}else{
							var deletable = true;
							if(deletable){
								masterGrid.reset();
								UniAppManager.app.onSaveDataButtonDown();
							}
							isNewData = false;
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		onPrintButtonDown: function() {
			if(masterForm.getValue('AGREE_STATUS') != '2'){
				alert('<t:message code="system.message.purchase.message009" default="미승인건은 인쇄할 수 없습니다."/>');
				return false;
			}
			var param= Ext.getCmp('searchForm').getValues();
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/mpo/mpo502rkrPrint.do',
				prgID: 'mpo502rkr',
					extParam: {
						ORDER_NUM : param.ORDER_NUM,
						DIV_CODE : masterForm.getValue('DIV_CODE')
					}
				});
			win.center();
			win.show();
		},
		setDefault: function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('ORDER_DATE',new Date());
			masterForm.setValue('ORDER_TYPE','4');
			orderNoSearch.setValue('ORDER_TYPE','4');
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ORDER_DATE',new Date());
			masterForm.setValue('AGREE_STATUS','1');
			panelResult.setValue('AGREE_STATUS','1');
			masterForm.setValue('AGREE_DATE',UniDate.get('today'));
			panelResult.setValue('AGREE_DATE',UniDate.get('today'));
			masterForm.setValue('DRAFT_YN','N');
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
			var field = masterForm.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = orderNoSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
		},
		checkForNewDetail:function() {
			return masterForm.setAllFieldsReadOnly(true);
			return panelResult.setAllFieldsReadOnly(true);
		},
		fnCalOrderAmt: function(rtnRecord, sType, nValue) {
			var dOrderUnitQ= sType =='Q' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_Q'),0);
			var dOrderUnitP= sType =='P' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_P'),0);
			var dOrderO= sType =='O' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_O'),0);
			var dTransRate= sType =='R' ? nValue : Unilite.nvl(rtnRecord.get('TRNS_RATE'),1);
			var dOrderQ;
			var dOrderP;
			var dExchgRateO= sType =='X' ? nValue : Unilite.nvl(rtnRecord.get('EXCHG_RATE_O'),1);
			var dOrderLocP= sType =='L' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_LOC_P'),0);
			var dOrderLocO= sType =='I' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_LOC_O'),0);

			if(sType == 'P' || sType == 'Q'){
				dOrderO = dOrderUnitQ * dOrderUnitP; //금액 = 발주량 * 단가
				rtnRecord.set('ORDER_O', dOrderO);

				dOrderQ = dOrderUnitQ * dTransRate;
				rtnRecord.set('ORDER_Q', dOrderQ);

				dOrderP = dOrderUnitP / dTransRate;
				rtnRecord.set('ORDER_P', dOrderP);

				dOrderLocP = dOrderUnitP * dExchgRateO;
				rtnRecord.set('ORDER_LOC_P', dOrderLocP);

				dOrderLocO = dOrderUnitQ * dOrderLocP;
				rtnRecord.set('ORDER_LOC_O', dOrderLocO);
			}else if(sType == 'R'){
				dOrderQ = dOrderUnitQ * dTransRate;
				rtnRecord.set('ORDER_Q', dOrderQ);

				dOrderP = dOrderUnitP / dTransRate;
				rtnRecord.set('ORDER_P', dOrderP);
			}else if(sType == 'O'){
				if(Math.abs(dOrderUnitQ) > '0'){
					dOrderUnitP = Math.abs(dOrderO) / Math.abs(dOrderUnitQ);
					rtnRecord.set('ORDER_UNIT_P', dOrderUnitP);

					dOrderP = dOrderUnitP / dTransRate;
					rtnRecord.set('ORDER_P', dOrderP);

					dOrderLocP = dOrderUnitP * dExchgRateO;
					rtnRecord.set('ORDER_LOC_P', dOrderLocP);

					dOrderLocO = dOrderUnitQ * dOrderLocP;
					rtnRecord.set('ORDER_LOC_O', dOrderLocO);
				}else{
					rtnRecord.set('ORDER_UNIT_P', '0');
					rtnRecord.set('ORDER_P', '0');
					rtnRecord.set('ORDER_LOC_P', '0');

					dOrderLocO = dOrderO * dExchgRateO;
					rtnRecord.set('ORDER_LOC_O', dOrderLocO);
				}
			}else if(sType == 'X'){
				dOrderLocP = dOrderUnitP * dExchgRateO;
				rtnRecord.set('ORDER_LOC_P', dOrderLocP);

				dOrderLocO = dOrderUnitQ * dOrderLocP;
				rtnRecord.set('ORDER_LOC_O', dOrderLocO);
			}else if(sType == 'L'){
				dOrderLocO = dOrderLocP * dOrderUnitQ;
				rtnRecord.set('ORDER_LOC_O', dOrderLocO);

				dOrderUnitP = dOrderLocP / dExchgRateO;
				rtnRecord.set('ORDER_UNIT_P', dOrderUnitP);

				dOrderO = dOrderUnitQ * dOrderUnitP;
				rtnRecord.set('ORDER_O', dOrderO);

				dOrderQ = dOrderUnitQ * dTransRate;
				rtnRecord.set('ORDER_Q', dOrderQ);

				dOrderP = dOrderUnitP / dTransRate;
				rtnRecord.set('ORDER_P', dOrderP);
			}else if(sType == 'I'){
				dOrderLocP = dOrderLocO / dOrderUnitQ;
				rtnRecord.set('ORDER_LOC_P', dOrderLocP);

				dOrderUnitP = dOrderLocP / dExchgRateO;
				rtnRecord.set('ORDER_UNIT_P', dOrderUnitP);

				dOrderO = dOrderUnitQ * dOrderUnitP;
				rtnRecord.set('ORDER_O', dOrderO);

				dOrderQ = dOrderUnitQ * dTransRate;
				rtnRecord.set('ORDER_Q', dOrderQ);

				dOrderP = dOrderUnitP / dTransRate;
				rtnRecord.set('ORDER_P', dOrderP);
			}
		},
		requestApprove: function(){	 //결재 요청
			var gsWin = window.open('about:blank','payviewer','width=500,height=500');
			var frm		 = document.f1;
			var compCode	= UserInfo.compCode;
			var divCode	 = panelResult.getValue('DIV_CODE');
			var outStocNum  = panelResult.getValue('OUTSTOCK_NUM');
			var spText	  = 'EXEC omegaplus_kdg.unilite.USP_GW_BCO100T01 ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + outStocNum + "'";
			var spCall	  = encodeURIComponent(spText);

//			frm.action = '/payment/payreq.php';
			frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=opo100ukrv&draft_no=" + 0 + "&sp=" + spCall;
			frm.target   = "payviewer";
			frm.method   = "post";
			frm.submit();
		},
		fnExchngRateO: function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE')),
				"MONEY_UNIT": masterForm.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {   
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(masterForm.getValue('MONEY_UNIT')) && masterForm.getValue('MONEY_UNIT') != "KRW"){
						alert('<t:message code="system.message.sales.datacheck008" default="환율정보가 없습니다."/>')
					}
					masterForm.setValue('EXCHG_RATE_O'	, provider.BASE_EXCHG);
					panelResult.setValue('EXCHG_RATE_O'	, provider.BASE_EXCHG);
				}
				
			});
		}
	});


	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ORDER_SEQ" : //발주순번
					if(newValue <= 0){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}

				case "ORDER_UNIT" :
					directMasterStore1.fnSumOrderO();
				break;

				case "ORDER_UNIT_Q" :
					if(newValue <= 0){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "Q", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_UNIT_P":
					if(record.get('UNIT_PRICE_TYPE') == 'Y'){
						if(newValue <= 0){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
						}
					}
					UniAppManager.app.fnCalOrderAmt(record, "P", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_O" :
					if(newValue <= 0){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "O", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "MONEY_UNIT" :
					if(newValue == BsaCodeInfo.gsDefaultMoney){
						record.set('EXCHG_RATE_O', '1');
					}
					UniAppManager.app.fnCalOrderAmt(record, "X");
					directMasterStore1.fnSumOrderO();
					break;

				case "EXCHG_RATE_O":
					if(newValue <= 0){
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "X", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_LOC_P":
					if(record.get('UNIT_PRICE_TYPE') == 'Y'){
						if(newValue <= 0){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
						}
					}
					UniAppManager.app.fnCalOrderAmt(record, "L", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_LOC_O":
					if(newValue <= 0){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "I", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "DVRY_DATE":
					if(newValue < masterForm.getValue('ORDER_DATE')){
						rv='<t:message code="system.message.purchase.message050" default="납기일은 발주일 보다 크거나 같아야 합니다."/>';
								break;
					}
					break;

				case "CONTROL_STATUS":
					if(oldValue != '8'){
						if (!(newValue < '2' || newValue =='9')){
							rv='<t:message code="system.message.purchase.message035" default="선택할 수 없는 코드입니다."/>';
								break;
						}
					}else{
						rv='<t:message code="system.message.purchase.message035" default="선택할 수 없는 코드입니다."/>';
								break;
					}
					if((masterForm.getValue('ORDER_YN')== '1') && newValue == '9'){
						rv='<t:message code="system.message.purchase.message051" default="승인되지 않은 자료는 강제마감시킬 수 없습니다."/>';
								break;
					}
					break;

				case "TRNS_RATE":
					if(newValue <= 0){
							rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
							break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "R", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "PROJECT_NO":

			}
			return rv;
		}
	});
};
</script>
