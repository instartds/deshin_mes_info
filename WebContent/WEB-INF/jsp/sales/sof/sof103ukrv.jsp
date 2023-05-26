<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof103ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="OU" />					<!-- 창고-->
	<t:ExtComboStore comboType="WU" />					<!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B030"/>	<!-- 세액포함여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>	<!-- 세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S002"/>	<!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S003"/>	<!-- 단가구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>	<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S024"/>	<!-- 부가세유형 -->
	<t:ExtComboStore comboType="AU" comboCode="T109"/>	<!-- 국내외 -->
</t:appConfig>
<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
</style>
<script type="text/javascript" >


function appMain() {
	var excelWindow;	// 엑셀참조
	var BsaCodeInfo = {
		gsMoneyUnit	: '${gsMoneyUnit}',
		gsVatRate	: ${gsVatRate}
	};

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
//			read	: 'sof103ukrvService.selectList',
			create	: 'sof103ukrvService.insertDetail',
			syncAll	: 'sof103ukrvService.saveAll'
		}
	});

	Unilite.defineModel('sof103ukrvModel', {
		fields: [
			{name: 'CUST_NO'			, text: '거래처groupby1'	, type: 'int'},
			{name: 'CUST_SEQ'			, text: '거래처groupby2'	, type: 'int'},
			//엑셀 데이터
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string'	, comboType: 'BOR120'},
			{name: 'OUT_DIV_CODE'		, text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'			, type: 'string'	, comboType: 'BOR120'},
			{name: 'ORDER_DATE'			, text: '<t:message code="system.label.sales.sodate" default="수주일"/>'					, type: 'uniDate'},
			//20191223 추가: 그룹순번(GROUP_SEQ)
			{name: 'GROUP_SEQ'			, text: '<t:message code="system.label.sales.groupseq" default="그룹순번"/>'				, type: 'int'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				, type: 'string'},
			{name: 'PAY_TERMS'			, text: '<t:message code="system.label.sales.paycondition" default="결제조건"/>'			, type: 'string'	, comboType: 'AU', comboCode: 'T006'},
			{name: 'PAY_METHODE1'		, text: '<t:message code="system.label.sales.amountpaymethod" default="대금결제방법"/>'		, type: 'string'},
			{name: 'TERMS_PRICE'		, text: '<t:message code="system.label.sales.pricecondition" default="가격조건"/>'			, type: 'string'	, comboType: 'AU', comboCode: 'T005'},
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.sales.salestype" default="매출유형"/>'				, type: 'string'	, comboType: 'AU', comboCode: 'S007', allowBlank:false},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname2" default="품명"/>'					, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'				, type: 'string'	, comboType: 'AU', comboCode: 'B013'},
			{name: 'TRANS_RATE'			, text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				, type: 'float'		, decimalPrecision: 6 , format: '0,000.000000'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.sales.soqty" default="수주량"/>'					, type: 'uniQty'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.sales.currency" default="화폐"/>'					, type: 'string'},
			{name: 'ORDER_P'			, text: '<t:message code="system.label.sales.price" default="단가"/>'						, type: 'uniUnitPrice'},
			{name: 'ORDER_O'			, text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'			, type: 'uniUnitPrice'},
			{name: 'ORDER_TAX_O'		, text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'				, type: 'uniPrice'	, defaultValue: 0},
			{name: 'ORDER_TOT_O'		, text: '<t:message code="system.label.sales.totalamount2" default="총액"/>'				, type: 'uniUnitPrice'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'				, type: 'uniDate'},
			{name: 'PO_NUM'				, text: '<t:message code="system.label.sales.pono2" default="PO 번호"/>'					, type: 'string'},
			{name: 'PO_SEQ'				, text: '<t:message code="system.label.sales.poseq2" default="PO 순번"/>'					, type: 'int'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.sales.remarks" default="비고"/>'					, type: 'string'},
			{name: 'REMARK_INTER'		, text: '<t:message code="system.label.sales.innerremarks" default="내부비고"/>'			, type: 'string'},
			//엑셀 데이터 외 저장 시 필요한 추가 데이터
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'				, type: 'string'	, comboType: 'AU', comboCode: 'S010'},
			{name: 'NATION_INOUT'		, text: '<t:message code="system.label.sales.domesticoverseasclass" default="국내외구분"/>'	, type: 'string'	, comboType: 'AU', comboCode: 'T109'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'				, type: 'string'	, comboType: 'AU', comboCode: 'S002'},
			{name: 'BILL_TYPE'			, text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'				, type: 'string'	, comboType: 'AU', comboCode: 'S024'}, 
			{name: 'EXCHANGE_RATE'		, text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'				, type: 'uniER'},
			{name: 'TAX_INOUT'			, text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>'		, type: 'string'	, comboType: 'AU', comboCode: 'B030'},
			{name: 'WON_CALC_BAS'		, text: 'WON_CALC_BAS'	, type: 'string'}
		]
	});	

	var detailStore = Unilite.createStore('detailStore',{
		model	: 'sof103ukrvModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
//						var master = batch.operations[0].getResultSet();
//						panelSearch.setValue("ORDER_NUM", master.orderNums);
//						detailStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);

			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});

	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode
		},{
			fieldLabel	: '수주번호',
			xtype		: 'uniTextfield',
			name		: 'ORDER_NUM',
			hidden		: true
		},{
			xtype	: 'button',
			text	: '<t:message code="system.label.commonJS.excel.title" default="엑셀 업로드"/>',
			handler	: function(){
				if(!panelSearch.getInvalidMessage()) return;	//필수체크
				openExcelWindow();
			}
		}]
	});

	var detailGrid = Unilite.createGrid('detailGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useLiveSearch		: false,
			useContextMenu		: false,
			useMultipleSorting	: false,
			useGroupSummary		: false,
			useRowNumberer		: false,
			onLoadSelectFirst	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			},
			state				: {
				useState	: false,
				useStateList: false
			}
		},
		selModel: 'rowmodel',
		columns	: [
			{dataIndex: 'DIV_CODE'			, width: 120},
			{dataIndex: 'OUT_DIV_CODE'		, width: 120},
			{dataIndex: 'CUSTOM_CODE'		, width: 100},
			{dataIndex: 'CUSTOM_NAME'		, width: 150},
			{dataIndex: 'PAY_TERMS'			, width: 120},
			{dataIndex: 'PAY_METHODE1'		, width: 100},
			{dataIndex: 'TERMS_PRICE'		, width: 100},
			{dataIndex: 'INOUT_TYPE_DETAIL'	, width: 80},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'ORDER_UNIT'		, width: 66, align: 'center'},
			{dataIndex: 'TRANS_RATE'		, width: 66},
			{dataIndex: 'ORDER_Q'			, width: 100},
			{dataIndex: 'MONEY_UNIT'		, width: 66, align: 'center'},
			{dataIndex: 'ORDER_P'			, width: 100},
			{dataIndex: 'ORDER_O'			, width: 100},
			{dataIndex: 'ORDER_TAX_O'		, width: 100},
			{dataIndex: 'ORDER_TOT_O'		, width: 100},
			{dataIndex: 'DVRY_DATE'			, width: 80},
			{dataIndex: 'PO_NUM'			, width: 110},
			{dataIndex: 'PO_SEQ'			, width: 69},
			{dataIndex: 'PROJECT_NO'		, width: 100},
			{dataIndex: 'REMARK'			, width: 200},
			{dataIndex: 'REMARK_INTER'		, width: 200},
			{dataIndex: 'WON_CALC_BAS'		, width: 200, hidden: true},
			{dataIndex: 'CUST_NO'			, width: 200, hidden: true},
			{dataIndex: 'ORDER_PRSN'		, width: 200, hidden: true},
			{dataIndex: 'NATION_INOUT'		, width: 200, hidden: true},
			{dataIndex: 'ORDER_TYPE'		, width: 200, hidden: true},
			{dataIndex: 'BILL_TYPE'			, width: 200, hidden: true},
			{dataIndex: 'EXCHANGE_RATE'		, width: 200, hidden: true},
			{dataIndex: 'TAX_INOUT'			, width: 200, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				return false;
			}
		},
		setExcelData: function(record) {	//엑셀 업로드 참조
			var grdRecord = this.getSelectedRecord();
			
			grdRecord.set('DIV_CODE'			, panelSearch.getValue('DIV_CODE'));
			grdRecord.set('OUT_DIV_CODE'		, record['OUT_DIV_CODE']);
			grdRecord.set('ORDER_DATE'			, record['ORDER_DATE']);
			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
			grdRecord.set('PAY_TERMS'			, record['PAY_TERMS']);
			grdRecord.set('PAY_METHODE1'		, record['PAY_METHODE1']);
			grdRecord.set('TERMS_PRICE'			, record['TERMS_PRICE']);
			grdRecord.set('INOUT_TYPE_DETAIL'	, record['INOUT_TYPE_DETAIL']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('ORDER_P'				, record['ORDER_P']);
			grdRecord.set('ORDER_O'				, record['ORDER_O']);
			grdRecord.set('ORDER_TAX_O'			, record['ORDER_TAX_O']);
			grdRecord.set('ORDER_TOT_O'			, record['ORDER_TOT_O']);
			grdRecord.set('DVRY_DATE'			, record['DVRY_DATE']);
			grdRecord.set('PO_NUM'				, record['PO_NUM']);
			grdRecord.set('PO_SEQ'				, record['PO_SEQ']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('REMARK_INTER'		, record['REMARK_INTER']);
			grdRecord.set('ORDER_PRSN'			, record['ORDER_PRSN']);
			grdRecord.set('NATION_INOUT'		, record['NATION_INOUT']);
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('BILL_TYPE'			, record['BILL_TYPE']);
			grdRecord.set('EXCHANGE_RATE'		, record['EXCHANGE_RATE']);
			grdRecord.set('TAX_INOUT'			, record['TAX_INOUT']);

			grdRecord.set('WON_CALC_BAS'		, record['WON_CALC_BAS']);
			grdRecord.set('CUST_NO'				, record['CUST_NO']);
			grdRecord.set('CUST_SEQ'			, record['CUST_SEQ']);

			UniAppManager.app.fnOrderAmtCal(grdRecord)
		}
	});



	function openExcelWindow() {
		var me		= this;
		var vParam	= {};
		var appName	= 'Unilite.com.excel.ExcelUpload';
		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.DIV_CODE = panelSearch.getValue('DIV_CODE');
		}
		if(!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				modal			: false,
				excelConfigName	: 'sof103ukrv',
				extParam		: {
					'PGM_ID'	: 'sof103ukrv',
					'DIV_CODE'	: panelSearch.getValue('DIV_CODE')
				},
				grids			: [{
					itemId		: 'grid01',
					title		: '<t:message code="system.label.sales.excelrefer" default="엑셀참조"/>',
					useCheckbox	: true,
					model		: 'sof103ukrvModel',
					readApi		: 'sof103ukrvService.selectExcelUploadSheet',
					columns		: [
						{dataIndex: 'DIV_CODE'			, width: 120},
						{dataIndex: 'OUT_DIV_CODE'		, width: 120},
						{dataIndex: 'CUSTOM_CODE'		, width: 100},
						{dataIndex: 'CUSTOM_NAME'		, width: 150},
						{dataIndex: 'PAY_TERMS'			, width: 120},
						{dataIndex: 'PAY_METHODE1'		, width: 100},
						{dataIndex: 'TERMS_PRICE'		, width: 100},
						{dataIndex: 'INOUT_TYPE_DETAIL'	, width: 80},
						{dataIndex: 'ITEM_CODE'			, width: 100},
						{dataIndex: 'ITEM_NAME'			, width: 200},
						{dataIndex: 'ORDER_UNIT'		, width: 66, align: 'center'},
						{dataIndex: 'TRANS_RATE'		, width: 66},
						{dataIndex: 'ORDER_Q'			, width: 100},
						{dataIndex: 'MONEY_UNIT'		, width: 66, align: 'center'},
						{dataIndex: 'ORDER_P'			, width: 100},
						{dataIndex: 'ORDER_O'			, width: 100},
						{dataIndex: 'ORDER_TAX_O'		, width: 100},
						{dataIndex: 'ORDER_TOT_O'		, width: 100},
						{dataIndex: 'DVRY_DATE'			, width: 80},
						{dataIndex: 'PO_NUM'			, width: 110},
						{dataIndex: 'PO_SEQ'			, width: 66, align: 'center'},
						{dataIndex: 'PROJECT_NO'		, width: 100},
						{dataIndex: 'REMARK'			, width: 200},
						{dataIndex: 'REMARK_INTER'		, width: 200},
						{dataIndex: 'WON_CALC_BAS'		, width: 200, hidden: true},
						{dataIndex: 'CUST_NO'			, width: 200, hidden: true},
						{dataIndex: 'CUST_SEQ'			, width: 200, hidden: true}
					]
				}],
				listeners: {
					close: function() {
						this.hide();
					}
				},
				onApply:function() {
					detailGrid.reset();
					detailStore.clearData();
					var grid	= this.down('#grid01');
					var records	= grid.getSelectionModel().getSelection();
					Ext.each(records, function(record,i){
						UniAppManager.app.onNewDataButtonDown();
						detailGrid.setExcelData(record.data);
					});
					grid.getStore().removeAll();
					this.hide();
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	}



	Unilite.Main({
		id			: 'sof103ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelSearch, detailGrid
			]
		}],
		fnInitBinding: function() {
			this.fnInitInputFields();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			
			this.fnInitBinding();
		},
		onNewDataButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
			var r = {
				DIV_CODE		: panelSearch.getValue('DIV_CODE')/*,
				ORDER_PRSN		: 'S010 로그인사용자의 SUB_CODE',
				NATION_INOUT	: 'BCM100T.NATION_CODE에 따라 설정',
				ORDER_TYPE		: '국내일 경우: 10, 국외일 경우: 40',
				BILL_TYPE		: '국내일 경우: 10, 국외일 경우: 60(직수출)',
				EXCHANGE_RATE	: '',					//BCM510T.EXCHG_DIVI = '2' AND 화폐, 수주일자의 환율
				TAX_INOUT		: ''					//BCM100T.TAX_TYPE
*/			};
			detailGrid.createRow(r);
		},
		onSaveDataButtonDown: function(config) {
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
			detailStore.saveStore();
		},
		fnInitInputFields: function(){
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','delete','save','query'], false);
		},
		fnOrderAmtCal: function(rtnRecord) {
			var dTransRate	= Unilite.nvl(rtnRecord.get('TRANS_RATE')	, 1);
			var dOrderQ		= Unilite.nvl(rtnRecord.get('ORDER_Q')		, 0);
			var dOrderP		= Unilite.nvl(rtnRecord.get('ORDER_P')		, 0); // 단가
			var dOrderPCal	= Unilite.nvl(rtnRecord.get('ORDER_P_CAL')	, 0); // 단가(할인율 계산용)
			var dOrderO		= Unilite.nvl(rtnRecord.get('ORDER_O')		, 0); // 금액
			var dOrderUnitQ	= 0;

			if(BsaCodeInfo.gsProcessFlag == 'PG') {
				dOrderO = dOrderQ * dOrderP * dTransRate;
			} else {
				dOrderO = Unilite.multiply(dOrderQ , dOrderP);
			}
			dOrderUnitQ = dOrderQ * dTransRate;
			rtnRecord.set('ORDER_O'		, dOrderO);
			rtnRecord.set('ORDER_UNIT_Q', dOrderUnitQ);
			this.fnTaxCalculate(rtnRecord, dOrderO)
		},
		fnTaxCalculate: function(rtnRecord, dOrderO, taxType) {
			var sTaxInoutType	= rtnRecord.get('TAX_INOUT');
			var dVatRate		= parseInt(BsaCodeInfo.gsVatRate);
			var dOrderAmtO		= 0;
			var dTaxAmtO		= 0;
			var dAmountI		= 0;
			//20191212 금액계산로직 변경으로 추가
			var sWonCalBas		= rtnRecord.get('WON_CALC_BAS');

			if(rtnRecord.get('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){ 
				var digit = UniFormat.FC.indexOf(".") == -1 ? UniFormat.FC.length : UniFormat.FC.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.FC.length - digit;
			} else {
				var digit = UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.Price.length - digit;
			}

			if(sTaxInoutType=='1') {
				dOrderAmtO	= dOrderO;
				dTaxAmtO	= dOrderO * dVatRate / 100
				dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderAmtO, sWonCalBas, numDigitOfPrice);
				if(UserInfo.compCountry == 'CN') {
					dTaxAmtO = UniSales.fnAmtWonCalc(dTaxAmtO, '3', numDigitOfPrice);
				} else {
					dTaxAmtO = UniSales.fnAmtWonCalc(dTaxAmtO, sWonCalBas, numDigitOfPrice);
				}
			} else if(sTaxInoutType=='2') {
				dAmountI = dOrderO;
				if(UserInfo.compCountry == 'CN') {
					dTemp	= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '3', numDigitOfPrice);
					dTaxAmtO= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, '3', numDigitOfPrice);
				} else {
					dTemp	= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, sWonCalBas, numDigitOfPrice);
					dTaxAmtO= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, sWonCalBas, numDigitOfPrice);
				}
				dOrderAmtO = UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), sWonCalBas, numDigitOfPrice);
			}
			//해외거래처이고 외화이면 부가세 0으로 계산되도록 로직 추가
			if(rtnRecord.get('NATION_INOUT') == '2' && rtnRecord.get('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit) {
				if(sTaxInoutType=='1') {
					rtnRecord.set('ORDER_O'		, dOrderAmtO);
				} else {
					rtnRecord.set('ORDER_O'		, dOrderAmtO+dTaxAmtO);
				}
				rtnRecord.set('ORDER_TAX_O'	, 0);
			} else {
				rtnRecord.set('ORDER_O'		, dOrderAmtO);
				rtnRecord.set('ORDER_TAX_O'	, dTaxAmtO);
			}
			rtnRecord.set('ORDER_TOT_O'	, dOrderAmtO+dTaxAmtO);
		}
	});
};
</script>