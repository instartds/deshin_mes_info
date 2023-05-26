<%--
'   프로그램명 : 매출등록 (영업)
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'   최종수정자 :
'   최종수정일 :
'   버	 전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa390ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa390ukrv" />				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>						<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S024" />						<!-- 부가세유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S002"/>						<!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S007"/>						<!-- 출고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A"/>							<!-- 출고창고 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />						<!-- 판매단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>						<!-- 과세여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S003"/>						<!-- 단가구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B035"/>						<!-- 수불타입 -->
	<t:ExtComboStore comboType="AU" comboCode="B030"/>						<!-- 세액포함여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S014"/>						<!-- 매출대상 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>						<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="S065"/>						<!-- 주문구분 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />			<!--창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고Cell-->
	<t:ExtComboStore comboType="OU" />										<!-- 창고-->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>
<script type="text/javascript">
var SearchInfoWindow;				//SearchInfoWindow : 검색창
var referContractOrderWindow;		//계약참조
var checkPass	= true;
var isLoad		= false;			//로딩 플래그 화폐단위 환율 change 로드시 계속 타므로 임시로 막음
var isOnNew		= false;			//행 추가 시, filter하지 않기 위한 로직
////그리드에 사업장의 창고 뿌려주기
////저장전 재고량 체크


var BsaCodeInfo = {
	gsCreditYn		: '${gsCreditYn}',
	gsAutoType		: '${gsAutoType}',
	gsMoneyUnit		: '${gsMoneyUnit}',
	gsVatRate		: ${gsVatRate},
	gsInvStatus		: '${gsInvStatus}',
	gsOptDivCode	: '${gsOptDivCode}',
	gsProcessFlag	: '${gsProcessFlag}',
	gsBusiPrintYN	: '${gsBusiPrintYN}',
	gsBusiPrintPgm	: '${gsBusiPrintPgm}',
	gsMoneyExYn		: '${gsMoneyExYn}',
	gsAdvanUseYn	: '${gsAdvanUseYn}',
	gsPointYn		: '${gsPointYn}',
	gsUnitChack		: '${gsUnitChack}',
	gsPriceGubun	: '${gsPriceGubun}',
	gsWeight		: '${gsWeight}',
	gsVolume		: '${gsVolume}',
	gsCustManageYN	: '${gsCustManageYN}',
	gsPrsnManageYN	: '${gsPrsnManageYN}',
	grsOutType		: ${grsOutType},
	gsManageLotNoYN	: ${gsManageLotNoYN},
	gsSaleAutoYN	: '${gsSaleAutoYN}',
	grsSalePrsn		: ${grsSalePrsn}
};

var CustomCodeInfo = {
	gsAgentType		: '',
	gsCustCreditYn	: '',
	gsUnderCalBase	: '',
	gsTaxCalType	: '',
	gsRefTaxInout	: ''
};

var gsLotNoInputMethod	= BsaCodeInfo.gsManageLotNoYN[0].MNG_LOT;
var gsLotNoEssential	= BsaCodeInfo.gsManageLotNoYN[0].ESS_YN;
var gsEssItemAccount	= BsaCodeInfo.gsManageLotNoYN[0].ESS_ACCOUNT;
var glSubCdTotCnt		= '';

var gsOldRefCode2	= '';
var gsTaxInout		= '';
var gsAcDate		= '';

var gsMonClosing	= '';	//월마감 여부
var gsDayClosing	= '';	//일마감 여부

var gsSaveRefFlag	= 'N';	//검색후에만 수정 가능하게 조회버튼 활성화..
//var output ='';
//	for(var key in BsaCodeInfo){
//		output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//	}
//Unilite.messageBox(output);
function appMain() {
	var isCreditYn = false;
	if(BsaCodeInfo.gsCreditYn != 'Y'){
		isCreditYn = true;
	}

	//자동채번 여부
	var isAutoBillNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoBillNum = true;
	}

	var isCustManageYN = false;
	if(BsaCodeInfo.gsCustManageYN=='N') {
		isCustManageYN = true;
	}

	var isPrsnManageYN = false;
	if(BsaCodeInfo.gsPrsnManageYN=='N') {
		isPrsnManageYN = true;
	}


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ssa390ukrvService.selectDetailList',
			update	: 'ssa390ukrvService.updateDetail',
			create	: 'ssa390ukrvService.insertDetail',
			destroy	: 'ssa390ukrvService.deleteDetail',
			syncAll	: 'ssa390ukrvService.saveAll'
		}
	});

	//마스터 폼
	var panelResult = Unilite.createSearchForm('resultForm',{
//		title: '<t:message code="system.label.sales.salesinfo" default="매출정보"/>',
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			holdable	: 'hold',
			child		: 'WH_CODE',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelResult.getField('SALE_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..

					if(!Ext.isEmpty(newValue) && !Ext.isEmpty(panelResult.getValue('SALE_DATE'))){
						UniSales.fnGetClosingInfo(
							UniAppManager.app.cbGetClosingInfo,
							newValue,
							"S",
							panelResult.getField('SALE_DATE').getSubmitValue()
						);
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salesno" default="매출번호"/>',
			name		: 'BILL_NUM',
			xtype		: 'uniTextfield',
			readOnly	: isAutoBillNum,
			allowBlank	: isAutoBillNum,
			holdable	: isAutoBillNum ? 'readOnly':'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			name		: 'SALE_DATE',
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(newValue && !Ext.isEmpty(panelResult.getValue('DIV_CODE')))){
						UniSales.fnGetClosingInfo(
							UniAppManager.app.cbGetClosingInfo,
							panelResult.getValue('DIV_CODE'),
							"S",
							UniDate.getDbDateStr(newValue)
						);
					}
					UniAppManager.app.fnExchngRateO();
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'SALE_CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			holdable		: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {

						CustomCodeInfo.gsAgentType		= records[0]["AGENT_TYPE"];   //거래처분류
						CustomCodeInfo.gsCustCreditYn	= records[0]["CREDIT_YN"];
						CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"]; //원미만계산
						CustomCodeInfo.gsTaxCalType		= records[0]["TAX_CALC_TYPE"];
						CustomCodeInfo.gsRefTaxInout	= records[0]["TAX_TYPE"]; 	//세액포함여부

						if(!Ext.isEmpty(records[0]["MONEY_UNIT"])){
							panelResult.setValue('MONEY_UNIT', records[0]["MONEY_UNIT"]);
						}
						if(Ext.isEmpty(panelResult.getValue('SALE_PRSN')) && !Ext.isEmpty(records[0]["BUSI_PRSN"])){
							panelResult.setValue('SALE_PRSN', records[0]["BUSI_PRSN"]);
						}
						if(!Ext.isEmpty(CustomCodeInfo.gsRefTaxInout)){
							panelResult.setValue('TAX_TYPE', CustomCodeInfo.gsRefTaxInout)
						}
						UniAppManager.app.fnExchngRateO();
					},
					scope: this
				},
				onValueFieldChange: function(field, newValue, oldValue){
					contractOrderSearch.setValue('CUSTOM_CODE', newValue);//계약참조에 SET

					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_NAME', '');
						
						CustomCodeInfo.gsAgentType		= '';
						CustomCodeInfo.gsCustCreditYn	= '';
						CustomCodeInfo.gsUnderCalBase	= '';
						CustomCodeInfo.gsTaxCalType		= '';
						CustomCodeInfo.gsRefTaxInout	= '';
						contractOrderSearch.setValue('CUSTOM_CODE', '');//계약참조에 SET
						contractOrderSearch.setValue('CUSTOM_NAME', '');//계약참조에 SET

						panelResult.setValue('MONEY_UNIT'	, '');
						panelResult.setValue('EXCHG_RATE_O'	, 0);
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					contractOrderSearch.setValue('CUSTOM_NAME', newValue);//계약참조에 SET

					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('SALE_CUSTOM_CODE', '');
						
						CustomCodeInfo.gsAgentType		= '';
						CustomCodeInfo.gsCustCreditYn	= '';
						CustomCodeInfo.gsUnderCalBase	= '';
						CustomCodeInfo.gsTaxCalType		= '';
						CustomCodeInfo.gsRefTaxInout	= '';
						contractOrderSearch.setValue('CUSTOM_CODE', '');//계약참조에 SET
						contractOrderSearch.setValue('CUSTOM_NAME', '');//계약참조에 SET

						panelResult.setValue('MONEY_UNIT'	, '');
						panelResult.setValue('EXCHG_RATE_O'	, 0);
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.contractnumber" default="계약번호"/>',
			name		: 'CONT_NUM',
			xtype		: 'uniTextfield',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			width	: 300,
			items	: [{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.contractendyn" default="계약종료여부"/>',
				name		: 'CONT_STATE',
				id			: 'statusFlag',
				holdable	: 'hold',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.end" default="종료"/>',
					name		: 'CONT_STATE',
					inputValue	: '9', 
					width		: 80
				},{
					boxLabel	: '<t:message code="system.label.sales.contract" default="계약"/>',
					name		: 'CONT_STATE',
					inputValue	: '1', 
					width		: 80
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
//						if(newValue.CONT_STATE == '2') {
//							//주문확정 데이터는 삭제, 수정 가능: 선택하여 수주확정도 가능
//							directMasterStore1.uniOpt.editable	= true;
//							directMasterStore1.uniOpt.deletable	= true;
//							directMasterStore2.uniOpt.editable	= true;
//							directMasterStore2.uniOpt.deletable	= true;
//							panelResult.down('#btnConfirm').setText('<t:message code="system.label.sales.orderconfirmation" default="수주확정"/>');
//							masterGrid1.getColumn('ORDER_NUM').setHidden(true);
//							
//						} else {
//							//수주확정 데이터는 삭제, 수정 불가능: 선택하여 취소만 가능
//							directMasterStore1.uniOpt.editable	= false;
//							directMasterStore1.uniOpt.deletable	= false;
//							directMasterStore2.uniOpt.editable	= false;
//							directMasterStore2.uniOpt.deletable	= false;
//							panelResult.down('#btnConfirm').setText('<t:message code="system.label.sales.cancel" default="취소"/>');
//							masterGrid1.getColumn('ORDER_NUM').setHidden(false);
//						}
//						UniAppManager.app.onQueryButtonDown(newValue.CONT_STATE);
					}
				}
			}]
		},{
			fieldLabel	: '<t:message code="system.label.sales.contractamount" default="계약금액"/>(A)',
			name		: 'CONT_AMT',
			itemId		: 'CONT_AMT',
			xtype		: 'uniNumberfield',
			value		: 0,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.salestotalamt" default="매출누적액"/>(B)',
			name		: 'TOT_SALES_AMT',
			itemId		: 'TOT_SALES_AMT',
			xtype		: 'uniNumberfield',
			value		: 0,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.monthsalesamt" default="금월매출액"/>(C)',
			name		: 'MONTH_SALES_AMT',
			itemId		: 'MONTH_SALES_AMT',
			xtype		: 'uniNumberfield',
			value		: 0,
			readOnly	: true
		},{
			xtype: 'component',
			width: 30
		},{
			xtype: 'component',
			width: 30
		},{
			fieldLabel	: '<t:message code="system.label.sales.balanceamount2" default="잔액"/>',
			name		: 'REMAIN_AMT',
			itemId		: 'REMAIN_AMT',
			xtype		: 'uniNumberfield',
			value		: 0,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			readOnly	: true,
			hidden		: true,
//			allowBlank	: false,
//			holdable	: 'hold',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
//					var deptCode = UniAppManager.app.fnGetDeptCode(newValue);	//영업담당의 부서 set
//					UniAppManager.app.fnSetDeptCodeName(deptCode);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
			name		: 'ORDER_TYPE',
			xtype		: 'uniTextfield',
			value		: '20',
			allowBlank	: false,
			readOnly	: true,
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.vattype" default="부가세유형"/>',
			name		: 'BILL_TYPE',
			xtype		: 'uniTextfield',
			value		: '10',
			allowBlank	: false,
			readOnly	: true,
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>',
			name		: 'TAX_TYPE',
			xtype		: 'uniTextfield',
			value		: '1',
			allowBlank	: false,
			readOnly	: true,
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			itemId			: 'project',
			textFieldName	: 'PROJECT_NO',
			validateBlank	: true,
			holdable		: 'hold',
			hidden			: true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('PROJECT_NO'		, records[0]["PJT_CODE"]);
						panelResult.setValue('SALE_CUSTOM_CODE'	, records[0]["CUSTOM_CODE"]);
						panelResult.setValue('CUSTOM_NAME'		, records[0]["CUSTOM_NAME"]);
					},
					scope: this
				},
				onClear: function(type) {
					panelResult.setValue('PROJECT_NO'		, '');
					panelResult.setValue('SALE_CUSTOM_CODE'	, '');
					panelResult.setValue('CUSTOM_NAME'		, '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'BPARAM0': 3});
					popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('SALE_CUSTOM_CODE')});
				},
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.remarks" default="비고"/>',
			xtype		: 'uniTextfield',
			name		: 'REMARK',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxabletotalamount" default="과세총액"/>(1)',
			name		: 'TOT_SALE_TAX_O',
			id			: 'M_TOT_SALE_TAX_O',
			xtype		: 'uniNumberfield',
			value		: 0,
			hidden		: true,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxtotalamount" default="세액합계"/>(2)',
			name		: 'TOT_TAX_AMT',
			id			: 'M_TOT_TAX_AMT',
			xtype		: 'uniNumberfield',
			value		: 0,
			hidden		: true,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxexemptiontotalamount" default="면세총액"/>(3)',
			name		: 'TOT_SALE_EXP_O',
			id			: 'M_TOT_SALE_EXP_O',
			xtype		: 'uniNumberfield',
			value		: 0,
			hidden		: true,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.salestotalamount2" default="매출총액"/>',
			name		: 'TOT_AMT',
			id			: 'M_TOT_AMT',
			xtype		: 'uniNumberfield',
			value		: 0,
			hidden		: true,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.exslipdate" default="결의전표일"/>',
			name		: 'EX_DATE',
			xtype		: 'uniTextfield',
			hidden		: true,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.exslipno" default="결의전표번호"/>',
			name		: 'EX_NUM',
			xtype		: 'uniTextfield',
			hidden		: true,
			readOnly	: true
		},{
			xtype		: 'uniNumberfield',
			name		: 'EXCHG_RATE_O',		//환율,
			value		: 1,
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.creditbalance" default="여신잔액"/>',
			xtype		: 'uniNumberfield',	//여신잔액
			name		: 'TOT_REM_CREDIT_I',
			hidden		: isCreditYn
		},{
			fieldLabel	: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>',
			xtype		: 'uniTextfield',		//화폐단위
			name		: 'MONEY_UNIT',
			value		: 'KRW',
			hidden		: true,
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue != BsaCodeInfo.gsMoneyUnit){
						var length = Ext.isEmpty(UniFormat.FC.split('.')[1]) ? 0 : UniFormat.FC.split('.')[1].length;
						Ext.getCmp('M_TOT_SALE_TAX_O').setConfig('decimalPrecision',length);
						Ext.getCmp('M_TOT_SALE_TAX_O').focus();
						Ext.getCmp('M_TOT_SALE_TAX_O').blur();

						Ext.getCmp('M_TOT_TAX_AMT').setConfig('decimalPrecision',length);
						Ext.getCmp('M_TOT_TAX_AMT').focus();
						Ext.getCmp('M_TOT_TAX_AMT').blur();

						Ext.getCmp('M_TOT_SALE_EXP_O').setConfig('decimalPrecision',length);
						Ext.getCmp('M_TOT_SALE_EXP_O').focus();
						Ext.getCmp('M_TOT_SALE_EXP_O').blur();

						Ext.getCmp('M_TOT_AMT').setConfig('decimalPrecision',length);
						Ext.getCmp('M_TOT_AMT').focus();
						Ext.getCmp('M_TOT_AMT').blur();

						//masterGrid.getColumn("SALE_P").setConfig('format',UniFormat.FC);
						//masterGrid.getColumn("SALE_P").setConfig('decimalPrecision',length);
						masterGrid.getColumn("SALE_AMT_O").setConfig('format',UniFormat.FC);
						masterGrid.getColumn("SALE_AMT_O").setConfig('decimalPrecision',length);
						masterGrid.getColumn("TAX_AMT_O").setConfig('format',UniFormat.FC);
						masterGrid.getColumn("TAX_AMT_O").setConfig('decimalPrecision',length);
						masterGrid.getColumn("ORDER_O_TAX_O").setConfig('format',UniFormat.FC);
						masterGrid.getColumn("ORDER_O_TAX_O").setConfig('decimalPrecision',length);
//						masterGrid.getColumn("SALE_LOC_AMT_I").setConfig('format',UniFormat.FC);
//						masterGrid.getColumn("SALE_LOC_AMT_I").setConfig('decimalPrecision',length);

					}else{
						var length = Ext.isEmpty(UniFormat.Price.split('.')[1]) ? 0 : UniFormat.Price.split('.')[1].length;
						Ext.getCmp('M_TOT_SALE_TAX_O').setConfig('decimalPrecision',length);
						Ext.getCmp('M_TOT_SALE_TAX_O').focus();
						Ext.getCmp('M_TOT_SALE_TAX_O').blur();

						Ext.getCmp('M_TOT_TAX_AMT').setConfig('decimalPrecision',length);
						Ext.getCmp('M_TOT_TAX_AMT').focus();
						Ext.getCmp('M_TOT_TAX_AMT').blur();

						Ext.getCmp('M_TOT_SALE_EXP_O').setConfig('decimalPrecision',length);
						Ext.getCmp('M_TOT_SALE_EXP_O').focus();
						Ext.getCmp('M_TOT_SALE_EXP_O').blur();

						Ext.getCmp('M_TOT_AMT').setConfig('decimalPrecision',length);
						Ext.getCmp('M_TOT_AMT').focus();
						Ext.getCmp('M_TOT_AMT').blur();

						//masterGrid.getColumn("SALE_P").setConfig('format',UniFormat.Price);
						//masterGrid.getColumn("SALE_P").setConfig('decimalPrecision',length);
						masterGrid.getColumn("SALE_AMT_O").setConfig('format',UniFormat.Price);
						masterGrid.getColumn("SALE_AMT_O").setConfig('decimalPrecision',length);
						masterGrid.getColumn("TAX_AMT_O").setConfig('format',UniFormat.Price);
						masterGrid.getColumn("TAX_AMT_O").setConfig('decimalPrecision',length);
						masterGrid.getColumn("ORDER_O_TAX_O").setConfig('format',UniFormat.Price);
						masterGrid.getColumn("ORDER_O_TAX_O").setConfig('decimalPrecision',length);
//						masterGrid.getColumn("SALE_LOC_AMT_I").setConfig('format',UniFormat.Price);
//						masterGrid.getColumn("SALE_LOC_AMT_I").setConfig('decimalPrecision',length);
					}
					if(isLoad){
						isLoad = false;
					}else{
						UniAppManager.app.fnExchngRateO();
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			holdable	: 'hold',
			hidden		: true
		},
			Unilite.popup('ITEM2',{	//카드 팝업?
			fieldLabel		: '<t:message code="system.label.sales.cardcustnm" default="카드가맹점"/>',
			validateBlank	: false,
			valueFieldName	: 'CARD_CUST_NM',
			textFieldName	: 'CARD_NM',
			readOnly		: true,
			hidden			: true
		}),{
			xtype		: 'uniNumberfield',
			name		: 'EXCHG_AMT_I',		//환산액
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'hiddenfield',
			name	: 'CARD_CUST_CD'			//카드가맹점
		},{
			xtype	: 'hiddenfield',
			name	: 'CARD_TAX_TYPE'
		},{
			xtype	: 'hiddenfield',
			name	: 'TAX_CALC_TYPE'
		}],
		api: {
			load	: 'ssa390ukrvService.selectMaster',
			submit	: 'ssa390ukrvService.syncForm'
		},
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
				if(gsSaveRefFlag == "Y" 
				&& (basicForm.getField('REMARK').isDirty() || basicForm.getField('PROJECT_NO').isDirty() || basicForm.getField('SALE_PRSN').isDirty() || basicForm.getField('SALE_PRSN').dirty)){
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
						if(Ext.isDefined(item.holdable) ){
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
				//this.unmask();
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
	});// End of var panelResult = Unilite.createSearchForm('searchForm',{

	//마스터 모델
	Unilite.defineModel('Ssa101ukrvModel',{
		fields: [
			{name: 'BILL_SEQ'			, text: '<t:message code="system.label.sales.seq" default="순번"/>'					, type: 'int', allowBlank: false},
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'			, type: 'string', comboType: 'AU', comboCode: 'S007', allowBlank: false},
			{name: 'OUT_DIV_CODE'		, text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'		, type: 'string', comboType: 'BOR120', allowBlank: false, child: 'WH_CODE'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'		, type: 'string', comboType: 'OU', allowBlank: false, parentNames:['OUT_DIV_CODE']},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>' 					, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'					, type: 'string'},
			{name: 'SALE_UNIT'			, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'			, type: 'string',comboType:'AU', comboCode: 'B013', allowBlank: false, displayField: 'value'},
			{name: 'TRANS_RATE'			, text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			, type: 'uniQty', defaultValue: '1', allowBlank: false},
			{name: 'SALE_Q'				, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'				, type: 'uniQty', allowBlank: false, defaultValue: '0'},
			{name: 'SALE_P'				, text: '<t:message code="system.label.sales.price" default="단가"/>'					, type: 'uniUnitPrice', allowBlank: false, defaultValue: '0'},
			{name: 'SALE_AMT_O'			, text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'		, type: 'uniFC', defaultValue: '0', allowBlank: false},
			{name: 'TAX_TYPE'			, text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'		, type: 'string',comboType:'AU', comboCode: 'B059', allowBlank: false},
			{name: 'TAX_AMT_O'			, text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'			, type: 'uniPrice', defaultValue: '0', allowBlank: true},
			{name: 'ORDER_O_TAX_O'		, text: '<t:message code="system.label.sales.totalamount2" default="총액"/>'			, type: 'uniPrice', defaultValue: '0', editable: false},
			{name: 'DISCOUNT_RATE'		, text: '<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'		, type: 'uniPercent', defaultValue: '0'},
			{name: 'STOCK_Q'			, text: '<t:message code="system.label.sales.inventoryqty" default="재고량"/>'			, type: 'uniQty', defaultValue: '0', editable: false},
			{name: 'DVRY_CUST_CD'		, text: '<t:message code="system.label.sales.deliveryplacecode" default="배송처코드"/>'	, type: 'string'},
			{name: 'DVRY_CUST_NAME'		, text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'		, type: 'string'},
			{name: 'PRICE_YN'			, text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'			, type: 'string' , defaultValue: '2',comboType:'AU', comboCode: 'S003', allowBlank: false},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'				, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'				, type: 'string'},
			{name: 'INOUT_SEQ'			, text: '<t:message code="system.label.sales.issueseq" default="출고순번"/>'			, type: 'int'},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'			, type: 'uniDate', allowBlank: true},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'PUB_NUM'			, text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'				, type: 'string'},
			/*hiiden, ref 필드*/
			{name: 'DIV_CODE'			, text: 'DIV_CODE'				, type: 'string',comboType: "BOR120", allowBlank: false},
			{name: 'BILL_NUM'			, text: 'BILL_NUM'				, type: 'string', allowBlank: isAutoBillNum},
			{name: 'SALE_LOC_AMT_I'		, text: 'SALE_LOC_AMT_I'		, type: 'uniPrice', defaultValue: '0'},
			{name: 'INOUT_TYPE'			, text: 'INOUT_TYPE'			, type: 'string', defaultValue: '2'},
			{name: 'SER_NO'				, text: 'SER_NO'				, type: 'int'},
			{name: 'STOCK_UNIT'			, text: 'STOCK_UNIT'			, type: 'string'},
			{name: 'ITEM_STATUS'		, text: 'ITEM_STATUS'			, type: 'string', defaultValue: '1'},
			{name: 'ACCOUNT_YNC'		, text: 'ACCOUNT_YNC'			, type: 'string', defaultValue: 'Y'},
			{name: 'ORIGIN_Q'			, text: 'ORIGIN_Q'				, type: 'uniQty', defaultValue: '0'},
			{name: 'REF_SALE_PRSN'		, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string',comboType:'AU', comboCode: 'S010'},
			{name: 'REF_CUSTOM_CODE'	, text: 'REF_CUSTOM_CODE'		, type: 'string'},
			{name: 'REF_SALE_DATE'		, text: 'REF_SALE_DATE'			, type: 'uniDate'},
			{name: 'REF_BILL_TYPE'		, text: 'REF_BILL_TYPE'			, type: 'string'},
			{name: 'REF_CARD_CUST_CD'	, text: 'REF_CARD_CUST_CD'		, type: 'string'},
			{name: 'REF_SALE_TYPE'		, text: 'REF_SALE_TYPE'			, type: 'string'},
			{name: 'REF_PROJECT_NO'		, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'REF_TAX_INOUT'		, text: 'REF_TAX_INOUT'			, type: 'string'},
			{name: 'REF_REMARK'			, text: 'REF_REMARK'			, type: 'string'},
			{name: 'REF_EX_NUM'			, text: 'REF_EX_NUM'			, type: 'string'},
			{name: 'REF_MONEY_UNIT'		, text: 'REF_MONEY_UNIT'		, type: 'string'},
			{name: 'REF_EXCHG_RATE_O'	, text: 'REF_EXCHG_RATE_O'		, type: 'string'},
			{name: 'STOCK_CARE_YN'		, text: 'STOCK_CARE_YN'			, type: 'string'},
			{name: 'UNSALE_Q'			, text: 'UNSALE_Q'				, type: 'string', defaultValue: '0'},
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'		, type: 'string', defaultValue: UserInfo.userID},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'		, type: 'string'},
			{name: 'DATA_REF_FLAG'		, text: 'DATA_REF_FLAG'			, type: 'string', defaultValue: 'F'},
			{name: 'SRC_CUSTOM_CODE'	, text: 'SRC_CUSTOM_CODE'		, type: 'string'},
			{name: 'SRC_CUSTOM_NAME'	, text: 'SRC_CUSTOM_NAME'		, type: 'string'},
			{name: 'SRC_ORDER_PRSN'		, text: 'SRC_ORDER_PRSN'		, type: 'string'},
			{name: 'REF_CODE2'			, text: 'REF_CODE2'				, type: 'string'},
			{name: 'SOF110T_ACCOUNT_YNC', text: 'SOF110T_ACCOUNT_YNC'   , type: 'string'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'				, type: 'string', allowBlank: false},
			{name: 'INOUT_CUSTOM_CODE'	, text: 'INOUT_CUSTOM_CODE'		, type: 'string'},
			{name: 'INOUT_CUSTOM_NAME'	, text: 'INOUT_CUSTOM_NAME'		, type: 'string'},
			{name: 'INOUT_AGENT_TYPE'	, text: 'INOUT_AGENT_TYPE'		, type: 'string'},
			{name: 'ADVAN_YN'			, text: 'ADVAN_YN'				, type: 'string'},
			{name: 'GUBUN'				, text: 'GUBUN'					, type: 'string'},
			//20200131 프로젝트명 추가
			{name: 'PJT_NAME'			, text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>'			, type: 'string', editable: false}

		]
	});// End of Unilite.defineModel('Ssa101ukrvModel',{

	// 마스터 스토어 정의
	var detailStore = Unilite.createStore('ssa101ukrvDetailStore',{
		model	: 'Ssa101ukrvModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				this.fnSaleAmtSum();
//				var viewNormal = masterGrid.getView();
//				viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			},
			add: function(store, records, index, eOpts) {
				this.fnSaleAmtSum();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				this.fnSaleAmtSum();
			},
			remove: function(store, record, index, isMove, eOpts) {
				this.fnSaleAmtSum();
			}
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
			var billNum = panelResult.getValue('BILL_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['BILL_NUM'] != billNum) {
					record.set('BILL_NUM', billNum);
				}
				if(record.data['INOUT_TYPE_DETAIL'] != 'AU') {
					if( (!Ext.isEmpty(record.data['SALE_P']) || !Ext.isEmpty(record.data['SALE_Q'])) && record.data['SALE_P'] <= 0 && record.data['SALE_Q'] <= 0 ){
						Unilite.messageBox('<t:message code="system.message.sales.message075" default="매출수량, 단가 가 필수 항목입나다."/>');
						checkPass = false;
					}else{
						checkPass = true;
					}
				}
			});

			// 1. 마스터 정보 파라미터 구성
			var paramMaster				= panelResult.getValues();	// syncAll 수정
			paramMaster.SALE_AMT_O		= panelResult.getValue('TOT_SALE_TAX_O') + panelResult.getValue('TOT_SALE_EXP_O'); //과세총액+면세총액
			paramMaster.UPDATE_DB_USER	= UserInfo.userID;
			paramMaster.VAT_RATE		= parseInt(BsaCodeInfo.gsVatRate);
			paramMaster.AGENT_TYPE		= CustomCodeInfo.gsAgentType;

			if((inValidRecs.length == 0) && checkPass) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						// 2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("BILL_NUM", master.BILL_NUM);

						// 3.기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						if(detailStore.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
				checkPass = true;
			} else {
				var grid = Ext.getCmp('ssa390ukrvGrid');
				if(!Ext.isEmpty(inValidRecs)){
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);}
				// Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
			}
		},
		fnSaleAmtSum: function(newValue) {
			var dSaleTI		= 0;
			var dSaleNTI	= 0;
			var dTaxI		= 0;
			var dTotalAmt	= 0;
			var dTaxAmtO	= 0;
			var results = this.sumBy(function(record, id){
										return record.get('TAX_TYPE') == '1';},
									['SALE_AMT_O','TAX_AMT_O']);
			dSaleTI = results.SALE_AMT_O;
			dTaxI	= results.TAX_AMT_O;

			var results = this.sumBy(function(record, id){
										return record.get('TAX_TYPE') == '2';},
									['SALE_AMT_O']);
			dSaleNTI = results.SALE_AMT_O;

			dTaxAmtO = dTaxI
			panelResult.setValue('TOT_SALE_TAX_O', dSaleTI); // 과세총액(1)
			panelResult.setValue('TOT_SALE_EXP_O', dSaleNTI); // 면세총액(3)

			var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
			if(CustomCodeInfo.gsTaxCalType == "1"){//통합
				dTaxAmtO = 0;
				dTaxAmtO = UniSales.fnAmtWonCalc(dSaleTI * (BsaCodeInfo.gsVatRate / 100), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice)
				panelResult.setValue('TOT_TAX_AMT', dTaxAmtO); //세액합계(2)
			}else{								//개별
				panelResult.setValue('TOT_TAX_AMT', dTaxAmtO); //세액합계(2)
			}

			dTotalAmt = dSaleTI + dSaleNTI + dTaxAmtO;
			panelResult.setValue('TOT_AMT', dTotalAmt); //총액[(1)+(2)+(3)]
			panelResult.setValue('EXCHG_AMT_I', dTotalAmt); //환산액
			
			//20190729 추가
			var contAmt		= panelResult.getValue('CONT_AMT');								//계약금액
			var totSalesAmt	= panelResult.getValue('TOT_SALES_AMT');						//매출누적액
			panelResult.setValue('MONTH_SALES_AMT'	, dTotalAmt);							//금월매출액
			panelResult.setValue('REMAIN_AMT'		, contAmt - (totSalesAmt + dTotalAmt));	//잔액

			if(panelResult.getValue('REMAIN_AMT') <= 0) {
				panelResult.setValue('REMAIN_AMT', 0);
				//20190801 저장시 변경해서 저장하도록 수정
//				Ext.getCmp('statusFlag').setValue('9');
			} else {
				//20190801 저장시 변경해서 저장하도록 수정
//				Ext.getCmp('statusFlag').setValue('1');
			}
		}
	});

	// 마스터 그리드
	var masterGrid = Unilite.createGrid('ssa390ukrvGrid',{
		// for tab
		layout: 'fit',
		region:'center',
		uniOpt: {
			expandLastColumn: true,
			useRowNumberer	: false,
			copiedRow		: false
		},
		tbar: [{
			itemId: 'contractOrderBtn',
			text: '<t:message code="system.label.sales.contractreference" default="계약참조"/>',
			handler: function() {
				openContractOrderWindow();
			}
		}],
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal',	ftype: 'uniSummary',	 showSummaryRow: true} ],
		store: detailStore,
		columns: [
			{dataIndex: 'BILL_SEQ'			, width: 60 , align:'center', locked: false	},
			{dataIndex: 'INOUT_TYPE_DETAIL'	, width: 80 , align:'center', locked: false	},
			{dataIndex: 'OUT_DIV_CODE'		, width: 100, locked: false	, hidden: true},
			{dataIndex: 'WH_CODE'			, width: 100, locked: false	, hidden: true,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filter('option', record.get('OUT_DIV_CODE'));
				}
			},
			{dataIndex: 'ITEM_CODE'			,		width: 120, locked: false,
				editor: Unilite.popup('DIV_PUMOK_G',{
								textFieldName: 'ITEM_CODE',
								DBtextFieldName: 'ITEM_CODE',
								useBarcodeScanner: false,
//								extParam: {SELMODEL: 'MULTI', DIV_CODE: UserInfo.divCode, POPUP_TYPE: 'GRID_CODE'},
								autoPopup: true,
								listeners: {'onSelected': {
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
												var record = masterGrid.getSelectedRecord();
												var divCode = record.get('OUT_DIV_CODE');
												popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
											}
								}
					})
			},
			{dataIndex: 'ITEM_NAME'			, width: 200, locked: false,
				editor: Unilite.popup('DIV_PUMOK_G',{
//									extParam: {SELMODEL: 'MULTI', DIV_CODE: UserInfo.divCode},
									autoPopup: true,
									listeners: {'onSelected': {
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
												var record = masterGrid.getSelectedRecord();
												var divCode = record.get('OUT_DIV_CODE');
												popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode});
											}
									}
					})
			},
			{dataIndex: 'SPEC'				, width: 170	},
//			{dataIndex: 'SALE_UNIT'			, width: 80, align: 'center',
//				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
//				}
//			},
//			{dataIndex: 'TRANS_RATE'		, width: 60	},
			{dataIndex: 'SALE_Q'			, width: 80, summaryType: 'sum'	},
			{dataIndex: 'SALE_P'			, width: 120, summaryType: 'sum'	},
			{dataIndex: 'SALE_AMT_O'		, width: 120, summaryType: 'sum'	},
//			{dataIndex: 'TAX_TYPE'			, width: 80, align: 'center'	},
			{dataIndex: 'TAX_AMT_O'			, width: 120, summaryType: 'sum'	},
			{dataIndex: 'ORDER_O_TAX_O'		, width: 120, summaryType: 'sum'	},
			//20200131 프로젝트코드 / 명 추가,
			{dataIndex: 'REF_PROJECT_NO'	, width: 100,
				editor: Unilite.popup('PROJECT_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = masterGrid.uniOpt.currentRecord;
								Ext.each(records, function(record,i) {
									if(i==0) {
										grdRecord.set('REF_PROJECT_NO'	, record['PJT_CODE']);
										grdRecord.set('PJT_NAME'		, record['PJT_NAME']);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('REF_PROJECT_NO'	, '');
							grdRecord.set('PJT_NAME'		, '');
						},
						applyextparam: function(popup){
						}
					}
				})
			},
			{dataIndex: 'PJT_NAME'				, width: 100}
//,
//			{dataIndex: 'DISCOUNT_RATE'		, width: 80	},
//			{dataIndex: 'STOCK_Q'			, width: 100, summaryType: 'sum'	},
//			{dataIndex: 'DVRY_CUST_CD'		, width: 113, hidden: true	},
//			{dataIndex: 'DVRY_CUST_NAME'	, width:113,
//					editor: Unilite.popup('DELIVERY_G',{
//							autoPopup: true,
//							listeners:{ 'onSelected': {
//							fn: function(records, type  ){
//								//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
//								var grdRecord = masterGrid.uniOpt.currentRecord;
//								grdRecord.set('DVRY_CUST_CD',records[0]['DELIVERY_CODE']);
//								grdRecord.set('DVRY_CUST_NAME',records[0]['DELIVERY_NAME']);
//							},
//							scope: this
//						 },
//						 'onClear' : function(type) {
//								//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
//								var grdRecord = masterGrid.uniOpt.currentRecord;
//								grdRecord.set('DVRY_CUST_CD','');
//								grdRecord.set('DVRY_CUST_NAME','');
//						 },
//							applyextparam: function(popup){
//								popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('SALE_CUSTOM_CODE')});
//							}
//						}
//				})
//			},
//			{dataIndex: 'PRICE_YN'			, width: 80 , align:'center'	},
//			{dataIndex: 'LOT_NO'			, width: 100	},
//			{dataIndex: 'INOUT_NUM'			, width: 120	},
//			{dataIndex: 'INOUT_SEQ'			, width: 80 , align:'center'	},
//			{dataIndex: 'INOUT_DATE'		, width: 80	},
//			{dataIndex: 'ORDER_NUM'			, width: 120	},
//			{dataIndex: 'PUB_NUM'			, width: 120	},
//
//			/*hiiden, ref 필드*/
//			{dataIndex: 'DIV_CODE'			, width: 66, hidden: true},
//			{dataIndex: 'BILL_NUM'			, width: 66, hidden: true	},
//			{dataIndex: 'SALE_LOC_AMT_I'	, width: 66, hidden: true	},
//			{dataIndex: 'INOUT_TYPE'		, width: 66, hidden: true	},
//			{dataIndex: 'SER_NO'			, width: 66, hidden: true	},
//			{dataIndex: 'STOCK_UNIT'		, width: 66, hidden: true	},
//			{dataIndex: 'ITEM_STATUS'		, width: 66, hidden: true	},
//			{dataIndex: 'ACCOUNT_YNC'		, width: 66, hidden: true	},
//			{dataIndex: 'ORIGIN_Q'			, width: 66, hidden: true	},
//			{dataIndex: 'REF_SALE_PRSN'		, width: 66	},
//			{dataIndex: 'REF_CUSTOM_CODE'	, width: 66, hidden: true	},
//			{dataIndex: 'REF_SALE_DATE'		, width: 66, hidden: true	},
//			{dataIndex: 'REF_BILL_TYPE'		, width: 66, hidden: true	},
//			{dataIndex: 'REF_CARD_CUST_CD'	, width: 66, hidden: true	},
//			{dataIndex: 'REF_SALE_TYPE'		, width: 66, hidden: true	},
//			{dataIndex: 'REF_PROJECT_NO'	, width: 120,
//				editor: Unilite.popup('PROJECT_G',{
//					extParam: {DIV_CODE: UserInfo.divCode},
//					autoPopup: true,
//					listeners: {
//						'onSelected': {
//							fn: function(records, type) {
//								console.log('records : ', records);
//								var grdRecord = masterGrid.uniOpt.currentRecord;
//								Ext.each(records, function(record,i) {
//									if(i==0) {
//										grdRecord.set('REF_PROJECT_NO', record['PJT_CODE']);
//									}
//								});
//							},
//							scope: this
//						},
//						'onClear': function(type) {
//							var grdRecord = masterGrid.uniOpt.currentRecord;
//							grdRecord.set('REF_PROJECT_NO', '');
//						}
//					}
//				})
//			},
//			{dataIndex: 'REF_TAX_INOUT'			, width: 66, hidden: true	},
//			{dataIndex: 'REF_REMARK'			, width: 66, hidden: true	},
//			{dataIndex: 'REF_EX_NUM'			, width: 66, hidden: true	},
//			{dataIndex: 'REF_MONEY_UNIT'		, width: 66, hidden: true	},
//			{dataIndex: 'REF_EXCHG_RATE_O'		, width: 66, hidden: true	},
//			{dataIndex: 'STOCK_CARE_YN'			, width: 66, hidden: true	},
//			{dataIndex: 'UNSALE_Q'				, width: 66, hidden: true	},
//			{dataIndex: 'UPDATE_DB_USER'		, width: 66, hidden: true	},
//			{dataIndex: 'UPDATE_DB_TIME'		, width: 66, hidden: true	},
//			{dataIndex: 'DATA_REF_FLAG'			, width: 66, hidden: true	},
//			{dataIndex: 'SRC_CUSTOM_CODE'		, width: 86, hidden: isCustManageYN	},
//			{dataIndex: 'SRC_CUSTOM_NAME'		, width: 133, hidden: isCustManageYN	},
//			{dataIndex: 'SRC_ORDER_PRSN'		, width: 100, hidden: isPrsnManageYN	},
//			{dataIndex: 'REF_CODE2'				, width: 66, hidden: true	},
//			{dataIndex: 'SOF110T_ACCOUNT_YNC'	, width: 66, hidden: true	},
//			{dataIndex: 'COMP_CODE'				, width: 66, hidden: true	},
//			{dataIndex: 'INOUT_CUSTOM_CODE'		, width: 66, hidden: true	},
//			{dataIndex: 'INOUT_CUSTOM_NAME'		, width: 66, hidden: true	},
//			{dataIndex: 'INOUT_AGENT_TYPE'		, width: 66, hidden: true	},
//			{dataIndex: 'ADVAN_YN'				, width: 66, hidden: true	},
//			{dataIndex: 'GUBUN'					, width: 66, hidden: true	}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				var sExNum		= panelResult.getValue('EX_NUM');
				var sPubNum		= e.record.data.PUB_NUM;
				var sBillType	= panelResult.getValue('BILL_TYPE');
				var sRefType	= e.record.data.DATA_REF_FLAG;
				var sInoutType	= e.record.data.INOUT_TYPE_DETAIL;
				var sType		= e.record.data.INOUT_TYPE;
				var sInoutNum	= e.record.data.INOUT_NUM;
				var sRefCode2	= e.record.data.REF_CODE2;
				var sAccountYNC	= e.record.data.ACCOUNT_YNC;
				gsOldRefCode2	= e.record.data.REF_CODE2;

				//사업장의 창고 가져오기
				if(e.field=='ORDER_UNIT') {
					var outDivCode = masterGrid.getSelectedRecord().get('OUT_DIV_CODE');
					var combo = e.column.field;
					if(e.rowIdx == 5) {
						combo.store.clearFilter();
						combo.store.filter('refCode1', outDivCode);
					}else{
						combo.store.clearFilter();
					}
					combo.filterByRefCode('refCode1', outDivCode);
					return true;
				}

				if(sRefType == 'T') {		//계약참조 또는 신규 추가된 데이터
					if (UniUtils.indexOf(e.field, ["INOUT_TYPE_DETAIL", "OUT_DIV_CODE", "WH_CODE", "SPEC"])) {
						return false;
					}
				} else if(sRefType == '') {	//조회된 데이터
					if (UniUtils.indexOf(e.field, ["INOUT_TYPE_DETAIL", "OUT_DIV_CODE", "WH_CODE", "ITEM_CODE", "ITEM_NAME", "SPEC"])) {
						return false;
					}
				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
//			var grdRecord = this.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		,"");
				grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('SALE_UNIT'		,"");
				grdRecord.set('SALE_Q'			,0);
				grdRecord.set('SALE_P'			,0);
				grdRecord.set('SALE_AMT_O'		,0);
				grdRecord.set('TAX_AMT_O'		,0);
				grdRecord.set('STOCK_UNIT'		,"");
//				grdRecord.set('WH_CODE'			,"");
				grdRecord.set('TAX_TYPE'		,"1");
				grdRecord.set('TRANS_RATE'		,1);
				grdRecord.set('DISCOUNT_RATE'	,0);
				grdRecord.set('STOCK_CARE_YN'	,"");
			} else {
				var sRefCode2 = grdRecord.get('REF_CODE2');
				var sTrRate = record['TRNS_RATE'];

				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('SALE_UNIT'		, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);

				if(Ext.isEmpty(grdRecord.get('WH_CODE'))){
					grdRecord.set('WH_CODE'		, record['WH_CODE']);
				}

				if(panelResult.getValue('BILL_TYPE') != "50"){
					grdRecord.set('TAX_TYPE'	, record['TAX_TYPE']);
				}else{
					grdRecord.set('TAX_TYPE'	, "2");
				}

				if(sRefCode2 != "94" && sRefCode2 != "<AU>"){
					grdRecord.set('STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
					grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
					UniSales.fnGetPriceInfo(grdRecord, UniAppManager.app.cbGetPriceInfo
												,'I'
												,UserInfo.compCode
												,panelResult.getValue('SALE_CUSTOM_CODE')
												,BsaCodeInfo.gsAgentType
												,grdRecord.get('ITEM_CODE')
												,BsaCodeInfo.gsMoneyUnit
												,grdRecord.get('SALE_UNIT')
												,grdRecord.get('STOCK_UNIT')
												,record['TRNS_RATE']
												,UniDate.getDbDateStr(panelResult.getValue('SALE_DATE'))
					)
					if(record['STOCK_CARE_YN'] == "Y"){
						UniSales.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), "1", grdRecord.get('ITEM_CODE'),  grdRecord.get('WH_CODE'));
					}
				} else {
					grdRecord.set('STOCK_CARE_YN'	, 'N');
					grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
				}
			}
		}
	});// End of var masterGrid = Unilite.createGrid('ssa390ukrvGrid1',{





	//검색창 폼
	var salesNoSearch = Unilite.createSearchForm('salesNoSearchForm',{
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [
			{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
				name: 'DIV_CODE',
				xtype:'uniCombobox',
				comboType:'BOR120',
				value:UserInfo.divCode,
				allowBlank:false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = salesNoSearch.getField('SALE_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					}
				}
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners:{
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							salesNoSearch.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							salesNoSearch.setValue('CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				width: 350
			},{
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'		,
				name: 'SALE_PRSN',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'S010',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'		,
				name: 'ORDER_TYPE',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'S002'
			},{
				fieldLabel: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'		,
				name: 'BILL_TYPE',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'S024',
				value: '10'
			},
				Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.sales.manageno" default="관리번호"/>',

				validateBlank: true,
				textFieldName:'PROJECT_NO',
				itemId:'project',
				listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'BPARAM0': 1});
						popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('SALE_CUSTOM_CODE')});
					}
				}

			}),{
				fieldLabel: '<t:message code="system.label.sales.issueno" default="출고번호"/>',
				xtype: 'uniTextfield',
				name:'INOUT_NUM',
				width:315
			},{
				fieldLabel: '<t:message code="system.label.sales.salesno" default="매출번호"/>',
				xtype: 'uniTextfield',
				name:'BILL_NUM',
				width:315
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							salesNoSearch.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							salesNoSearch.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': salesNoSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.sales.inquiryclass" default="조회구분"/>'	,
				xtype: 'radiogroup',
				allowBlank: false,
				width: 235,
				name:'RDO_TYPE',
				items: [
					{boxLabel:'<t:message code="system.label.sales.master" default="마스터"/>', name:'RDO_TYPE', inputValue:'master', checked:true},
					{boxLabel:'<t:message code="system.label.sales.detail" default="디테일"/>', name:'RDO_TYPE', inputValue:'detail'}
				],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue) {
							if(newValue.RDO_TYPE=='detail') {
								if(salesNoMasterGrid) salesNoMasterGrid.hide();
								if(salesNomasterGrid) salesNomasterGrid.show();
							} else {
								if(salesNomasterGrid) salesNomasterGrid.hide();
								if(salesNoMasterGrid) salesNoMasterGrid.show();
							}
						}
					}
				}
			}]
	}); // createSearchForm

	//검색창 마스터 모델
	Unilite.defineModel('salesNoMasterModel',{
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string', comboType: 'BOR120'},
			{name: 'SALE_CUSTOM_CODE'	, text: '<t:message code="system.label.sales.client" default="고객"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.clientname" default="고객명"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SALE_DATE'			, text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'				, type: 'uniDate'},
			{name: 'BILL_TYPE'			, text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'				, type: 'string', comboType: 'AU', comboCode: 'S024' },
			{name: 'SALE_TYPE'			, text: '<t:message code="system.label.sales.salesclass" default="매출구분"/>'				, type: 'string'},
			{name: 'SALE_TYPE_NAME'		, text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'				, type: 'string'},
			{name: 'SALE_Q'				, text: '<t:message code="system.label.sales.qty" default="수량"/>'						, type: 'uniQty'},
			{name: 'SALE_TOT_O'			, text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'			, type: 'uniPrice'},
			{name: 'SALE_LOC_AMT_I'		, text: '<t:message code="system.label.sales.taxabletotalamount" default="과세총액"/>'		, type: 'uniPrice'},
			{name: 'SALE_LOC_EXP_I'		, text: '<t:message code="system.label.sales.taxexemptiontotalamount" default="면세총액"/>'	, type: 'uniPrice'},
			{name: 'TAX_AMT_O'			, text: '<t:message code="system.label.sales.taxtotalamount" default="세액합계"/>'			, type: 'uniPrice'},
			{name: 'SALE_PRSN'			, text: '<t:message code="system.label.sales.charger" default="담당자"/>'					, type: 'string'},
			{name: 'SALE_PRSN_NAME'		, text: '<t:message code="system.label.sales.charger" default="담당자"/>'					, type: 'string'},
			{name: 'BILL_NUM'			, text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'					, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'					, type: 'string'},
			/*거래처 정보*/
			{name: 'AGENT_TYPE'			, text: 'AGENT_TYPE'	, type: 'string'},
			{name: 'CREDIT_YN'			, text: 'CREDIT_YN'		, type: 'string'},
			{name: 'WON_CALC_BAS'		, text: 'WON_CALC_BAS'	, type: 'string'},
			{name: 'TAX_CALC_TYPE'		, text: 'TAX_CALC_TYPE'	, type: 'string'},
			{name: 'TAX_TYPE'			, text: 'TAX_TYPE'		, type: 'string'}
		]
	});

	//검색창 디테일 모델
	Unilite.defineModel('salesNoDetailModel',{
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string', comboType: 'BOR120'},
			{name: 'SALE_CUSTOM_CODE' 	, text: '<t:message code="system.label.sales.client" default="고객"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.clientname" default="고객명"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SALE_DATE'			, text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'				, type: 'uniDate'},
			{name: 'BILL_TYPE'			, text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'				, type: 'string', comboType: 'AU', comboCode: 'S024'},
			{name: 'SALE_TYPE'			, text: '<t:message code="system.label.sales.salesclass" default="매출구분"/>'				, type: 'string'},
			{name: 'SALE_TYPE_NAME'		, text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'				, type: 'string'},
			{name: 'SALE_Q'				, text: '<t:message code="system.label.sales.qty" default="수량"/>'						, type: 'uniQty'},
			{name: 'SALE_TOT_O'			, text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'			, type: 'uniPrice'},
			{name: 'SALE_LOC_AMT_I'		, text: '<t:message code="system.label.sales.taxabletotalamount" default="과세총액"/>'		, type: 'uniPrice'},
			{name: 'SALE_LOC_EXP_I'		, text: '<t:message code="system.label.sales.taxexemptiontotalamount" default="면세총액"/>'	, type: 'uniPrice'},
			{name: 'TAX_AMT_O'			, text: '<t:message code="system.label.sales.taxtotalamount" default="세액합계"/>'			, type: 'uniPrice'},
			{name: 'SALE_PRSN'			, text: '<t:message code="system.label.sales.charger" default="담당자"/>'					, type: 'string'},
			{name: 'SALE_PRSN_NAME'		, text: '<t:message code="system.label.sales.charger" default="담당자"/>'					, type: 'string'},
			{name: 'BILL_NUM'			, text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'					, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'					, type: 'string'}
		]
	});

	// 검색 스토어(마스터)
	var salesNoMasterStore = Unilite.createStore('salesNoMasterStore',{
		model: 'salesNoMasterModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'ssa390ukrvService.selectSalesNumMasterList'
			}
		},
		loadStoreRecords : function() {
			var param= salesNoSearch.getValues();
			var authoInfo = pgmInfo.authoUser;	//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(salesNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	// 검색 스토어(디테일)
	var salesNoDetailStore = Unilite.createStore('salesNoDetailStore',{
		model: 'salesNoDetailModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'ssa390ukrvService.selectSalesNumDetailList'
			}
		},
		loadStoreRecords : function() {
			var param= salesNoSearch.getValues();
			var authoInfo = pgmInfo.authoUser;	//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(salesNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	// 검색창 그리드(마스터)
	var salesNoMasterGrid = Unilite.createGrid('ssa101ukrvSalesNoMasterGrid',{
		// title: '기본',
		layout : 'fit',
		store: salesNoMasterStore,
		uniOpt:{
					useRowNumberer: false
		},
		columns:  [
			{ dataIndex: 'DIV_CODE'			,  width: 100},
			{ dataIndex: 'SALE_CUSTOM_CODE' ,  width: 100,hidden:true},
			{ dataIndex: 'CUSTOM_NAME'		,  width: 130},
			{ dataIndex: 'ITEM_CODE'		,  width: 100,hidden:true},
			{ dataIndex: 'ITEM_NAME'		,  width: 166,hidden:true},
			{ dataIndex: 'SALE_DATE'		,  width: 100},
			{ dataIndex: 'BILL_TYPE'		,  width: 73},
			{ dataIndex: 'SALE_TYPE'		,  width: 100,hidden:true},
			{ dataIndex: 'SALE_TYPE_NAME'	,  width: 100},
			{ dataIndex: 'SALE_Q'			,  width: 86},
			{ dataIndex: 'SALE_TOT_O'		,  width: 86},
			{ dataIndex: 'SALE_LOC_AMT_I'	,  width: 86},
			{ dataIndex: 'SALE_LOC_EXP_I'	,  width: 80},
			{ dataIndex: 'TAX_AMT_O'		,  width: 80},
			{ dataIndex: 'SALE_PRSN'		,  width: 100,hidden:true},
			{ dataIndex: 'SALE_PRSN_NAME'	,  width: 66},
			{ dataIndex: 'BILL_NUM'			,  width: 120},
			{ dataIndex: 'PROJECT_NO'		,  width: 86},
			{ dataIndex: 'INOUT_NUM'		,  width: 100}
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
					salesNoMasterGrid.returnData(record);
					UniAppManager.app.onQueryButtonDown();
					SearchInfoWindow.hide();
			}
		}, // listeners
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelResult.setValues({'DIV_CODE':record.get('DIV_CODE'), 'BILL_NUM':record.get('BILL_NUM')});
			CustomCodeInfo.gsAgentType	= record.get("AGENT_TYPE");   //거래처분류
			CustomCodeInfo.gsCustCreditYn = record.get("CREDIT_YN");
			CustomCodeInfo.gsUnderCalBase = record.get("WON_CALC_BAS"); //원미만계산
			CustomCodeInfo.gsTaxCalType   = record.get("TAX_CALC_TYPE");
			CustomCodeInfo.gsRefTaxInout  = record.get("TAX_TYPE"); 	//세액포함여부
		}
	});

	// 검색창 그리드(디테일)
	var salesNomasterGrid = Unilite.createGrid('ssa101ukrvSalesNomasterGrid',{
		layout : 'fit',
		store: salesNoDetailStore,
		uniOpt:{
			useRowNumberer: false
		},
		hidden : true,
		columns:  [
			{ dataIndex: 'DIV_CODE'			,  width: 100},
			{ dataIndex: 'SALE_CUSTOM_CODE'	,  width: 100,hidden:true},
			{ dataIndex: 'CUSTOM_NAME'		,  width: 130},
			{ dataIndex: 'ITEM_CODE'		,  width: 120},
			{ dataIndex: 'ITEM_NAME'		,  width: 166},
			{ dataIndex: 'SALE_DATE'		,  width: 80},
			{ dataIndex: 'BILL_TYPE'		,  width: 73},
			{ dataIndex: 'SALE_TYPE'		,  width: 100,hidden:true},
			{ dataIndex: 'SALE_TYPE_NAME'	,  width: 100},
			{ dataIndex: 'SALE_Q'			,  width: 86},
			{ dataIndex: 'SALE_TOT_O'		,  width: 86},
			{ dataIndex: 'SALE_LOC_AMT_I'	,  width: 86},
			{ dataIndex: 'SALE_LOC_EXP_I'	,  width: 80},
			{ dataIndex: 'TAX_AMT_O'		,  width: 80},
			{ dataIndex: 'SALE_PRSN'		,  width: 100,hidden:true},
			{ dataIndex: 'SALE_PRSN_NAME'	,  width: 66},
			{ dataIndex: 'BILL_NUM'			,  width: 120},
			{ dataIndex: 'PROJECT_NO'		,  width: 86},
			{ dataIndex: 'INOUT_NUM'		,  width: 100}
		] ,
		listeners: {
			 onGridDblClick:function(grid, record, cellIndex, colName) {
					salesNomasterGrid.returnData(record)
					UniAppManager.app.onQueryButtonDown();
					SearchInfoWindow.hide();
			 }
		}, // listeners
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelResult.uniOpt.inLoading=true;
			panelResult.setValues({'DIV_CODE':record.get('DIV_CODE'), 'BILL_NUM':record.get('BILL_NUM')});
			panelResult.uniOpt.inLoading=false;
		}
	});

	//검색창 메인
	function openSearchInfoWindow() {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow',{
				title: '<t:message code="system.label.sales.salesnosearch" default="매출번호검색"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [salesNoSearch, salesNoMasterGrid, salesNomasterGrid],
				tbar:  ['->',
										{	itemId : 'saveBtn',
											text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
											handler: function() {
												var rdoType = salesNoSearch.getValue('RDO_TYPE');
												console.log('rdoType : ',rdoType)
												if(rdoType.RDO_TYPE == 'master') {
													salesNoMasterStore.loadStoreRecords();
												}else {
													salesNoDetailStore.loadStoreRecords();
												}
											},
											disabled: false
										},{
											itemId : 'SalesNoCloseBtn',
											text: '<t:message code="system.label.sales.close" default="닫기"/>',
											handler: function() {
												SearchInfoWindow.hide();
											},
											disabled: false
										}
								],
				listeners : {
					beforehide: function(me, eOpt) {
						salesNoSearch.clearForm();
						salesNoMasterGrid.reset();
						salesNomasterGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						salesNoSearch.clearForm();
						salesNoMasterGrid.reset();
						salesNomasterGrid.reset();
					},
					show: function( panel, eOpts ) {
						var field = salesNoSearch.getField('SALE_PRSN');
						field.fireEvent('changedivcode', field, panelResult.getValue('DIV_CODE'), null, null, "DIV_CODE");
						salesNoSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
						salesNoSearch.setValue('SALE_DATE_FR',UniDate.get('startOfMonth', panelResult.getValue('SALE_DATE')));
						salesNoSearch.setValue('SALE_DATE_TO',panelResult.getValue('SALE_DATE'));
						salesNoSearch.setValue('CUSTOM_CODE',panelResult.getValue('SALE_CUSTOM_CODE'));
						salesNoSearch.setValue('CUSTOM_NAME',panelResult.getValue('CUSTOM_NAME'));
						salesNoSearch.setValue('SALE_PRSN',panelResult.getValue('SALE_PRSN'));
						salesNoSearch.setValue('BILL_TYPE',panelResult.getValue('BILL_TYPE'));
						salesNoSearch.setValue('ORDER_TYPE',panelResult.getValue('ORDER_TYPE'));
						salesNoSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
						salesNoSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
						salesNoSearch.setValue('RDO_TYPE', 'master');
						if(salesNomasterGrid) salesNomasterGrid.hide();
						if(salesNoMasterGrid) salesNoMasterGrid.show();
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}



	//계약참조 폼
	var contractOrderSearch = Unilite.createSearchForm('contractOrderForm',{
		layout :  {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		:'<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						contractOrderSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						contractOrderSearch.setValue('CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.contractnumber" default="계약번호"/>',
			name		: 'CONT_NUM',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype: 'component',
			width: 30
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			items	: [{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.contractclassification" default="계약구분"/>',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.lease" default="임대"/>',
					width		: 80,
					name		: 'CONT_GUBUN',
				readOnly	: true,
					inputValue	: '1',
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.sales.maintenance" default="유지보수"/>',
					width		: 80,
					name		: 'CONT_GUBUN',
				readOnly	: true,
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			width	: 300,
			items	: [{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.contractendyn" default="계약종료여부"/>',
				name		: 'CONT_STATE',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
					name		: 'CONT_STATE',
					inputValue	: '', 
					width		: 60
				},{
					boxLabel	: '<t:message code="system.label.sales.end" default="종료"/>',
					name		: 'CONT_STATE',
					inputValue	: '9', 
					width		: 60
				},{
					boxLabel	: '<t:message code="system.label.sales.contract" default="계약"/>',
					name		: 'CONT_STATE',
					inputValue	: '1', 
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		},{
			fieldLabel	: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			xtype		: 'uniDatefield',
			name		: 'SALE_DATE',
			hidden		: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		}]
	});

	//계약참조 모델
	Unilite.defineModel('ssa390ukrvSalesOrderModel',{
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'		, type: 'string'},
			{name: 'CONT_NUM'			, text: '<t:message code="system.label.sales.contractnumber" default="계약번호"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				, type: 'string'},
			{name: 'CONT_GUBUN'			, text: '<t:message code="system.label.sales.contractclassification" default="계약구분"/>'	, type: 'string'},
			{name: 'CONT_DATE'			, text: '<t:message code="system.label.sales.contractdate" default="계약일"/>'				, type: 'uniDate'},
			{name: 'CONT_AMT'			, text: '<t:message code="system.label.sales.contractamount" default="계약금액"/>'			, type: 'uniPrice'},
			{name: 'REMAIN_AMT'			, text:	'<t:message code="system.label.sales.balanceamount2" default="잔액"/>'			, type: 'uniPrice'},
			{name: 'SALE_PRSN'			, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'				, type: 'string'},
			{name: 'CONT_STATE'			, text: '<t:message code="system.label.sales.contractstatus" default="계약상태"/>'			, type: 'string'},
			{name: 'CONT_FR_DATE'		, text: '<t:message code="system.label.sales.contractedperiod" default="계약기간"/>FR'		, type: 'uniDate'},
			{name: 'CONT_TO_DATE'		, text: '<t:message code="system.label.sales.contractedperiod" default="계약기간"/>TO'		, type: 'uniDate'},
			{name: 'CONT_MONTH'			, text: '<t:message code="system.label.sales.monthsofcontract" default="계약월수"/>'		, type: 'int'},
			{name: 'MONTH_MAINT_AMT'	, text: '<t:message code="system.label.sales.monthmaintenancecost" default="월유지보수비"/>'	, type: 'uniPrice'},
			{name: 'CHAGE_DAY'			, text: '<t:message code="system.label.sales.billingdate" default="청구일"/>'				, type: 'int'},
			{name: 'TAX_IN_OUT'			, text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>'		, type: 'string'	, comboType:'AU'	, comboCode: 'B030'},
			{name: 'REMARK'				, text: '<t:message code="system.label.sales.remarks" default="비고"/>'					, type: 'string'}
		]
	});

	//계약참조 스토어
	var contractOrderStore = Unilite.createStore('ssa101ukrvSalesOrderStore',{
		model	: 'ssa390ukrvSalesOrderModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'ssa390ukrvService.selectSalesOrderList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
					var deleteRecords = new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								if((record.data['ORDER_NUM'] == item.data['ORDER_NUM']) // record = masterRecord   item = 참조 Record
								&& (record.data['SER_NO'] == item.data['SER_NO'])) {
									deleteRecords.push(item);
								}
							});
						});
						store.remove(deleteRecords);
					}
				}
			}
		},
		loadStoreRecords : function() {
			var param= contractOrderSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	//계약참조 그리드
	var contractOrderGrid = Unilite.createGrid('ssa101ukrvSalesorderGrid',{
		store	: contractOrderStore,
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst : false
		},
		selModel: 'rowmodel',
		columns	: [
			{ dataIndex: 'COMP_CODE'		, width: 100	, hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{ dataIndex: 'CONT_NUM'			, width: 120},
			{ dataIndex: 'CUSTOM_CODE'		, width: 100	, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'		, width: 150},
			{ dataIndex: 'CONT_GUBUN'		, width: 100	, hidden: true},
			{ dataIndex: 'CONT_DATE'		, width: 80},
			{ dataIndex: 'CONT_AMT'			, width: 100},
			{ dataIndex: 'REMAIN_AMT'		, width: 100},
			{ dataIndex: 'SALE_PRSN'		, width: 100	, hidden: true},
			{ dataIndex: 'CONT_STATE'		, width: 100	, hidden: true},
			{ dataIndex: 'CONT_FR_DATE'		, width: 100	, hidden: true},
			{ dataIndex: 'CONT_TO_DATE'		, width: 100	, hidden: true},
			{ dataIndex: 'CONT_MONTH'		, width: 100	, hidden: true},
			{ dataIndex: 'MONTH_MAINT_AMT'	, width: 100	, hidden: true},
			{ dataIndex: 'CHAGE_DAY'		, width: 100	, hidden: true},
			{ dataIndex: 'TAX_IN_OUT'		, width: 100	, hidden: true},
			{ dataIndex: 'REMARK'			, width: 100	, hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				var record = this.getSelectedRecord();
				panelResult.setValue('SALE_CUSTOM_CODE'	, record.get('CUSTOM_CODE'));
				panelResult.setValue('CUSTOM_NAME'		, record.get('CUSTOM_NAME'));
				panelResult.setValue('CONT_NUM'			, record.get('CONT_NUM'));
				panelResult.setValue('CONT_AMT'			, record.get('CONT_AMT'));
				panelResult.setValue('TOT_SALES_AMT'	, record.get('TOT_SALES_AMT'));
				panelResult.setValue('REMAIN_AMT'		, record.get('REMAIN_AMT'));
				panelResult.setValue('CONT_STATE'		, record.get('CONT_STATE'));
				panelResult.setValue('TAX_TYPE'			, record.get('TAX_IN_OUT'));
				panelResult.setValue('MONEY_UNIT'		, record.get('MONEY_UNIT'));
				UniAppManager.app.fnMakeScn100tDataRef(record);
				detailStore.fnSaleAmtSum();
				this.deleteSelectedRow();

				referContractOrderWindow.hide();
			}
		},
		returnData: function() {
		}
	});

	//계약참조 메인
	function openContractOrderWindow() {
		if(!panelResult.setAllFieldsReadOnly(true)){
			return false;
		}
		contractOrderSearch.setValue('CUSTOM_CODE'	, panelResult.getValue('SALE_CUSTOM_CODE'));
		contractOrderSearch.setValue('CUSTOM_NAME'	, panelResult.getValue('CUSTOM_NAME'));
		contractOrderSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
		contractOrderSearch.setValue('SALE_DATE'	, panelResult.getValue('SALE_DATE'));
		contractOrderSearch.setValue('CONT_STATE'	, panelResult.getValue('CONT_STATE'));
		contractOrderStore.loadStoreRecords();

		if(!referContractOrderWindow) {
			referContractOrderWindow = Ext.create('widget.uniDetailWindow',{
				title	: '<t:message code="system.label.sales.contractreference" default="계약참조"/>',
				layout	: {type:'vbox', align:'stretch'},
				items	: [contractOrderSearch, contractOrderGrid],
				width	: 1080,
				height	: 580,
				tbar	: ['->', {
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						contractOrderStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.salesapply" default="매출적용"/>',
					handler	: function() {
						contractOrderGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.sales.salesapplyclose" default="매출적용후 닫기"/>',
					handler	: function() {
						contractOrderGrid.returnData();
						referContractOrderWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						if(detailStore.getCount() == 0){
							panelResult.setAllFieldsReadOnly(false);
						}
						referContractOrderWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						contractOrderSearch.clearForm();
						contractOrderGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						contractOrderSearch.clearForm();
						contractOrderGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						contractOrderStore.loadStoreRecords();
					}
				}
			})
		}
		referContractOrderWindow.center();
		referContractOrderWindow.show();
	}





	Unilite.Main( {
		id			: 'ssa101ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		}],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}else{
				this.setDefault();
				if(params && params.BILL_NUM){
					panelResult.setValue('BILL_NUM', params.BILL_NUM);
				}
			}
		},// 링크로 넘어오는 params 받는 부분
		processParams: function(params) {
			// this.uniOpt.appParams = params;
			if(params.PGM_ID == 'ssa450skrv'){
				if(!Ext.isEmpty(params.BILL_NUM)){
					panelResult.setValue('BILL_NUM',params.BILL_NUM);
					panelResult.setValue('DIV_CODE',params.DIV_CODE);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},
		onQueryButtonDown: function() {
//			panelResult.setAllFieldsReadOnly(false);
			var billNo = panelResult.getValue('BILL_NUM');
			if(Ext.isEmpty(billNo)) {
				openSearchInfoWindow()
			} else {
				isLoad = true;
				var param= panelResult.getValues();
				panelResult.uniOpt.inLoading=true;
				panelResult.getForm().load({
					params: param,
					success:function(form, action) {
						panelResult.getField('BILL_TYPE').holdable = 'hold'; 	//부가세유형 readOnly여부 (검색으로 올시 readonly)
						panelResult.getField('ORDER_TYPE').holdable = 'hold'; 	//판매유형 readOnly여부  (검색으로 올시 readonly)
						panelResult.setAllFieldsReadOnly(true);
						panelResult.setValue('TOT_AMT', panelResult.getValue('TOT_SALE_TAX_O') + panelResult.getValue('TOT_TAX_AMT') + panelResult.getValue('TOT_SALE_EXP_O'));
						action.result.data.TAX_TYPE == '1' ? gsTaxInout = '1' : gsTaxInout = '2';
						gsAcDate = action.result.data.AC_DATE;
						gsSaveRefFlag = 'Y';
						panelResult.uniOpt.inLoading=false;
						detailStore.loadStoreRecords();
					},
					failure: function(form, action) {
						panelResult.uniOpt.inLoading=false;
					}
				})
			}
		},
		onDeleteDataButtonDown: function() {
			if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
				Unilite.messageBox('<t:message code="system.message.sales.message054" default="마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다."/>'); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
				return false;
			}
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(!Ext.isEmpty(panelResult.getValue('EX_NUM')) && panelResult.getValue('EX_NUM') != "0"){
					Unilite.messageBox('<t:message code="system.message.sales.message077" default="회계전표가 생성된 매출자료는 수정/삭제할 수 없습니다."/>');	//회계전표가 생성된 매출자료는 수정/삭제할 수 없습니다..
					return false;
				}
				if(!Ext.isEmpty(selRow.get('REF_EX_NUM')) && selRow.get('REF_EX_NUM') != "0"){
					Unilite.messageBox('<t:message code="system.message.sales.message077" default="회계전표가 생성된 매출자료는 수정/삭제할 수 없습니다."/>');	//회계전표가 생성된 매출자료는 수정/삭제할 수 없습니다..
					return false;
				}
				if(!Ext.isEmpty(selRow.get('PUB_NUM'))){
					Unilite.messageBox('<t:message code="system.message.sales.message068" default="계산서가 발행된 건은 삭제할 수 없습니다."/>');	//계산서가 발행된 건은 삭제할 수 없습니다.
					return false;
				}
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
							Unilite.messageBox('<t:message code="system.message.sales.message054" default="마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다."/>'); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
							return false;
						}
						if(!Ext.isEmpty(panelResult.getValue('EX_NUM')) && panelResult.getValue('EX_NUM') != "0"){
							Unilite.messageBox('<t:message code="system.message.sales.message077" default="회계전표가 생성된 매출자료는 수정/삭제할 수 없습니다."/>');	//회계전표가 생성된 매출자료는 수정/삭제할 수 없습니다..
							return false;
						}
						Ext.each(records, function(record,i) {
							if(!Ext.isEmpty(record.get('REF_EX_NUM')) && record.get('REF_EX_NUM') != "0"){
								Unilite.messageBox('<t:message code="system.message.sales.message077" default="회계전표가 생성된 매출자료는 수정/삭제할 수 없습니다."/>');	//회계전표가 생성된 매출자료는 수정/삭제할 수 없습니다..
								deletable = false;
								return false;
							}
							if(!Ext.isEmpty(record.get('PUB_NUM'))){
								Unilite.messageBox('<t:message code="system.message.sales.message068" default="계산서가 발행된 건은 삭제할 수 없습니다."/>');	//계산서가 발행된 건은 삭제할 수 없습니다.
								deletable = false;
								return false;
							}
						});
						/*---------삭제전 로직 구현 끝----------*/

						if(deletable){
							masterGrid.reset();
							if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
								Unilite.messageBox('<t:message code="system.message.sales.message054" default="마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다."/>'); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
								return false;
							}
							detailStore.saveStore();
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
		onNewDataButtonDown: function() {
			isOnNew = true;
			if(!panelResult.setAllFieldsReadOnly(true)){
				return false;
			}
			if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
				Unilite.messageBox('<t:message code="system.message.sales.message054" default="마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다."/>'); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
				return false;
			}
			if(!Ext.isEmpty(panelResult.getValue('EX_NUM')) && panelResult.getValue('EX_NUM') != '0'){
				Unilite.messageBox('<t:message code="system.message.sales.message079" default="자동기표처리된 매출정보건에 대해서는 매출내역을 추가할 수 없습니다."/>');//자동기표처리된 매출정보건에 대해서는 매출내역을 추가할 수 없습니다.
				return false
			}

			//Detail Grid Default 값 설정
			var billSeq = detailStore.max('BILL_SEQ');
			if(!billSeq) billSeq = 1;
			else  billSeq += 1;


			var billNum = '';
			if(!Ext.isEmpty(panelResult.getValue('BILL_NUM'))) {
				billNum = panelResult.getValue('BILL_NUM');
			}

			var inoutTypeDetail = '11';												//임대매출
			var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2

			var outDivCode = '';
			if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))) {
				outDivCode = panelResult.getValue('DIV_CODE');
			}

			var billType = '';
			if(!Ext.isEmpty(panelResult.getValue('BILL_TYPE'))) {
				if(panelResult.getValue('BILL_TYPE') != '50'){
					billType = '1'
				}else{
					billType = '2'
				}
			}

			var divCode = '';
			if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))) {
				divCode = panelResult.getValue('DIV_CODE');
			}

			var salePrsn = '';
			if(!Ext.isEmpty(panelResult.getValue('SALE_PRSN'))) {
				salePrsn = panelResult.getValue('SALE_PRSN');
			}

			var customCode = '';
			if(!Ext.isEmpty(panelResult.getValue('SALE_CUSTOM_CODE'))) {
				customCode = panelResult.getValue('SALE_CUSTOM_CODE');
			}

			var saleDate = '';
			if(!Ext.isEmpty(panelResult.getValue('SALE_DATE'))) {
				saleDate = panelResult.getValue('SALE_DATE');
			}

			var refBillType = '';
			if(!Ext.isEmpty(panelResult.getValue('BILL_TYPE'))) {
				refBillType = panelResult.getValue('BILL_TYPE');
			}

			var cardCustCd = '';
			if(!Ext.isEmpty(panelResult.getValue('CARD_CUST_CD'))) {
				cardCustCd = panelResult.getValue('CARD_CUST_CD');
			}

			var saleType = '';
			if(!Ext.isEmpty(panelResult.getValue('ORDER_TYPE'))) {
				saleType = panelResult.getValue('ORDER_TYPE');
			}

			var projectNo = '';
			if(!Ext.isEmpty(panelResult.getValue('PROJECT_NO'))) {
				projectNo = panelResult.getValue('PROJECT_NO');
			}

			var texInout = '';
			if(!Ext.isEmpty(panelResult.getValue('TAX_TYPE'))) {
				texInout = panelResult.getValue('TAX_TYPE');
			}

			var remark = '';
			if(!Ext.isEmpty(panelResult.getValue('REMARK'))) {
				remark = panelResult.getValue('REMARK');
			}

			var exNum = '';
			if(!Ext.isEmpty(panelResult.getValue('EX_NUM'))) {
				exNum = panelResult.getValue('EX_NUM');
			}

			var moneyUnit = '';
			if(!Ext.isEmpty(panelResult.getValue('MONEY_UNIT'))) {
				moneyUnit = panelResult.getValue('MONEY_UNIT');
			}

			var exchgRateO = '';
			if(!Ext.isEmpty(panelResult.getValue('EXCHG_RATE_O'))) {
				exchgRateO = panelResult.getValue('EXCHG_RATE_O');
			}

			var srcCustomCode = '';
			if(!Ext.isEmpty(panelResult.getValue('SALE_CUSTOM_CODE'))) {
				srcCustomCode = panelResult.getValue('SALE_CUSTOM_CODE');
			}

			var srcCustomName = '';
			if(!Ext.isEmpty(panelResult.getValue('CUSTOM_NAME'))) {
				srcCustomName = panelResult.getValue('CUSTOM_NAME');
			}

			var srcOrderPrsn = '';
			if(!Ext.isEmpty(panelResult.getValue('SALE_PRSN'))) {
				srcOrderPrsn = panelResult.getValue('SALE_PRSN');
			}

			var deptCode = '';
			if(!Ext.isEmpty(panelResult.getValue('DEPT_CODE'))) {
				deptCode = panelResult.getValue('DEPT_CODE');
			}

			var whCode = '';
			if(!Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
				whCode = panelResult.getValue('WH_CODE');
			}

			var compCode = UserInfo.compCode;

			var r = {
				BILL_SEQ			: billSeq,
				BILL_NUM			: billNum,
				INOUT_TYPE_DETAIL	: inoutTypeDetail,
				REF_CODE2			: refCode2,
				OUT_DIV_CODE		: outDivCode,
				TAX_TYPE			: billType,
				DIV_CODE			: divCode,
				REF_SALE_PRSN		: salePrsn,
				REF_CUSTOM_CODE		: customCode,
				REF_SALE_DATE		: saleDate,
				REF_BILL_TYPE		: refBillType,
				REF_CARD_CUST_CD	: cardCustCd,
				REF_SALE_TYPE		: saleType,
				REF_PROJECT_NO		: projectNo,
				REF_TAX_INOUT		: texInout,
				REF_REMARK			: remark,
				REF_EX_NUM			: exNum,
				REF_MONEY_UNIT		: moneyUnit,
				REF_EXCHG_RATE_O	: exchgRateO,
				SRC_CUSTOM_CODE		: srcCustomCode,
				SRC_CUSTOM_NAME		: srcCustomName,
				SRC_ORDER_PRSN		: srcOrderPrsn,
				COMP_CODE			: compCode,
				DEPT_CODE			: deptCode,
				WH_CODE				: whCode,
				//20190801 추가
				DATA_REF_FLAG		: 'T',
				ORDER_NUM			: panelResult.getValue('CONT_NUM'),
				SER_NO				: 1
			};
//			masterGrid.createRow(r, null, masterGrid.getStore().getCount() - 1);
			masterGrid.createRow(r);
			panelResult.setAllFieldsReadOnly(true);
			detailStore.fnSaleAmtSum();
			isOnNew = false;
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			detailStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
				Unilite.messageBox('<t:message code="system.message.sales.message054" default="마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다."/>'); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
				return false;
			}
			
			if(panelResult.getValue('REMAIN_AMT') == 0) {
				if(!confirm('<t:message code="system.message.product.confirm004" default="종료하시겠습니까?"/>')) {
					return false;
				} else {
					//20190801 잔액이 0이고 완료할 경우, 계약종료여부 종료로 변경 후 저장
					Ext.getCmp('statusFlag').setValue('9');
				}
			}
			if(!detailStore.isDirty()) {
				if(panelResult.isDirty()) {
					UniAppManager.app.fnMasterSave();
				}
			}else {
				detailStore.saveStore();
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
		setDefault: function() {
			gsMonClosing	= '';	//월마감 여부
			gsDayClosing	= '';	//일마감 여부
			glSubCdTotCnt	= '';
			gsOldRefCode2	= '';
			gsAcDate		= '';
			//거래처 정보
			CustomCodeInfo.gsAgentType		= '';
			CustomCodeInfo.gsCustCreditYn	= '';
			CustomCodeInfo.gsUnderCalBase	= '';
			CustomCodeInfo.gsTaxCalType		= '';
			CustomCodeInfo.gsRefTaxInout	= '';

			/*영업담당 filter set*/
			var field = panelResult.getField('SALE_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			var param = {
				"DIV_CODE": UserInfo.divCode,
				"DEPT_CODE": UserInfo.deptCode
			};
			ssa390ukrvService.deptWhcode(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					panelResult.setValue('WH_CODE', provider['WH_CODE']);
				}
			});

			panelResult.getField('BILL_TYPE').holdable = ''; 	//부가세유형 readOnly여부 (검색으로 올시 readonly)
			panelResult.getField('ORDER_TYPE').holdable = ''; 	//판매유형 readOnly여부  (검색으로 올시 readonly)

			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('SALE_DATE'	, UniDate.get('today'));
			panelResult.setValue('BILL_TYPE'	, '10');
			panelResult.setValue('ORDER_TYPE'	, '20');
			panelResult.setValue('TAX_TYPE'		, 1);
			panelResult.setValue('DEPT_CODE'	, UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME'	, UserInfo.deptName);

			panelResult.setValue('CONT_AMT'			, 0);
			panelResult.setValue('MONTH_SALES_AMT'	, 0);
			panelResult.setValue('TOT_SALES_AMT'	, 0);
			panelResult.setValue('REMAIN_AMT'		, 0);
			
			panelResult.setValue('TOT_SALE_TAX_O'	, 0);	//과세총액(1)
			panelResult.setValue('TOT_TAX_AMT'		, 0);	//세액 합계(2)
			panelResult.setValue('TOT_SALE_EXP_O'	, 0);	//면세 총액(3)
			panelResult.setValue('TOT_AMT'			, 0);	//총액[(1)+(2)+(3)
			panelResult.setValue('TOT_REM_CREDIT_I'	, 0);	//여신잔액
			panelResult.setValue('EXCHG_RATE_O'		, 1);	//환율

			gsTaxInout = '1';
			gsSaveRefFlag = 'N';

			panelResult.getField('TOT_SALE_TAX_O').setReadOnly(true);
			panelResult.getField('TOT_TAX_AMT').setReadOnly(true);
			panelResult.getField('TOT_SALE_EXP_O').setReadOnly(true);
			panelResult.getField('TOT_AMT').setReadOnly(true);
			panelResult.getField('EX_DATE').setReadOnly(true);
			panelResult.getField('EX_NUM').setReadOnly(true);

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();

			if(BsaCodeInfo.gsSaleAutoYN == "Y"){
			} else {
			}
			UniAppManager.setToolbarButtons('save', false);

			//숫자포맷 공통코드에 맞게 변경 (20180912)
			var length = Ext.isEmpty(UniFormat.Price.split('.')[1]) ? 0 : UniFormat.Price.split('.')[1].length;
			Ext.getCmp('M_TOT_SALE_TAX_O').setConfig('decimalPrecision',length);
			Ext.getCmp('M_TOT_SALE_TAX_O').focus();
			Ext.getCmp('M_TOT_SALE_TAX_O').blur();

			Ext.getCmp('M_TOT_TAX_AMT').setConfig('decimalPrecision',length);
			Ext.getCmp('M_TOT_TAX_AMT').focus();
			Ext.getCmp('M_TOT_TAX_AMT').blur();

			Ext.getCmp('M_TOT_SALE_EXP_O').setConfig('decimalPrecision',length);
			Ext.getCmp('M_TOT_SALE_EXP_O').focus();
			Ext.getCmp('M_TOT_SALE_EXP_O').blur();

			Ext.getCmp('M_TOT_AMT').setConfig('decimalPrecision',length);
			Ext.getCmp('M_TOT_AMT').focus();
			Ext.getCmp('M_TOT_AMT').blur();

			//masterGrid.getColumn("SALE_P").setConfig('format',UniFormat.Price);
			//masterGrid.getColumn("SALE_P").setConfig('decimalPrecision',6);
			masterGrid.getColumn("SALE_AMT_O").setConfig('format',UniFormat.Price);
			masterGrid.getColumn("SALE_AMT_O").setConfig('decimalPrecision',length);
			masterGrid.getColumn("TAX_AMT_O").setConfig('format',UniFormat.Price);
			masterGrid.getColumn("TAX_AMT_O").setConfig('decimalPrecision',length);
			masterGrid.getColumn("ORDER_O_TAX_O").setConfig('format',UniFormat.Price);
			masterGrid.getColumn("ORDER_O_TAX_O").setConfig('decimalPrecision',length);
//			masterGrid.getColumn("SALE_LOC_AMT_I").setConfig('format',UniFormat.Price);
//			masterGrid.getColumn("SALE_LOC_AMT_I").setConfig('decimalPrecision',length);
			
			Ext.getCmp('statusFlag').setValue('1');
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelResult.getValue('SALE_DATE')),
				"MONEY_UNIT" : panelResult.getValue('MONEY_UNIT')
			};
			if(panelResult.uniOpt.inLoading)
				return;
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni && !Ext.isEmpty(panelResult.getValue('MONEY_UNIT')) && panelResult.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
						Unilite.messageBox('<t:message code="system.message.sales.datacheck008" default="환율정보가 없습니다."/>');
					}
					panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
				}
			});
		},
		fnGetSubCode: function(rtnRecord, subCode) {
			var fRecord = '';
			Ext.each(BsaCodeInfo.grsOutType, function(item, i) {
				if(item['codeNo'] == subCode) {
					fRecord = item['refCode2'];
					if(Ext.isEmpty(fRecord)){
						fRecord = item['codeNo']
					}
				}
			})
			return fRecord;
		},
		// UniSales.fnGetPriceInfo2 callback 함수
		cbGetPriceInfo: function(provider, params) {
			var dSalePrice=Unilite.nvl(provider['SALE_PRICE'],0);//판매단가(판매단위)
			if(params.sType=='I') {
				params.rtnRecord.set('SALE_P', dSalePrice);
				params.rtnRecord.set('TRANS_RATE', provider['SALE_TRANS_RATE']);
				params.rtnRecord.set('DISCOUNT_RATE', provider['DC_RATE']);
			}

			if(params.rtnRecord.get('SALE_Q') > 0){
				UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P");
			}
		},
		cbStockQ: function(provider, params) {
			var rtnRecord = params.rtnRecord;

			var dStockQ = Unilite.nvl(provider['STOCK_Q'], 0);
//			var dOrderQ = Unilite.nvl(rtnRecord.get('ORDER_Q'), 0);
			var lTrnsRate = 0;
			if(Ext.isEmpty(rtnRecord.get('TRANS_RATE')) || rtnRecord.get('TRANS_RATE') == 0){
				lTrnsRate = 1
			}else{
				lTrnsRate = rtnRecord.get('TRANS_RATE');
			}
			rtnRecord.set('STOCK_Q', dStockQ / lTrnsRate);
		},
		fnOrderAmtCal: function(rtnRecord, sType, fieldName, nValue, taxType) {
			var dOrderQ		= fieldName=='SALE_Q'			? nValue : Unilite.nvl(rtnRecord.get('SALE_Q'),0);
			var dOrderP		= fieldName=='SALE_P'			? nValue : Unilite.nvl(rtnRecord.get('SALE_P'),0);
			var dOrderO		= fieldName=='SALE_AMT_O'		? nValue : Unilite.nvl(rtnRecord.get('SALE_AMT_O'),0);
			var dTransRate	= fieldName=='TRANS_RATE'		? nValue : Unilite.nvl(rtnRecord.get('TRANS_RATE'),1);
			var dDcRate		= fieldName=='DISCOUNT_RATE'	? nValue : Unilite.nvl((100 - rtnRecord.get('DISCOUNT_RATE')),0);
			//20200612 추가: 자사금액 계산시, 'JPY' 관련로직 추가
			var moneyUnit		= rtnRecord.get('REF_MONEY_UNIT');

			if(sType == "P" || sType == "Q"){	//단가 수량 변경시
				dOrderO = dOrderQ * dOrderP
				rtnRecord.set('SALE_AMT_O', dOrderO);
				//20200612 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
				rtnRecord.set('SALE_LOC_AMT_I', UniSales.fnExchangeApply(moneyUnit, dOrderO * panelResult.getValue('EXCHG_RATE_O')));
				this.fnTaxCalculate(rtnRecord, dOrderO);
			}else if(sType == "O"){ //금액 변경시
				if(dOrderQ > 0){
					//20190801 주석: 매출금액 변경 시, 단가 재계산 발생하지 않음
//					if(rtnRecord.get('ADVAN_YN') != "Y"){
//						dOrderP = dOrderO / dOrderQ;
//					}
//					rtnRecord.set('SALE_P', dOrderP);
//					if(rtnRecord.get('ADVAN_YN') == "Y"){	//수주참조(선매출)탭에서 참조해온 데이터만 금액변경시 매출량 변경토록
//						dOrderQ = (rtnRecord.get('SALE_AMT_O') / rtnRecord.get('SALE_P')) * dOrderQ;
//					}
				}
				this.fnTaxCalculate(rtnRecord, dOrderO, taxType);
			}else if(sType == "C"){ //할인율 변경시
				dOrderP = (dOrderP - (dOrderP * (dDcRate / 100)));
				dOrderO = dOrderQ * dOrderP;
				rtnRecord.set('SALE_P', dOrderP);
				rtnRecord.set('SALE_AMT_O', dOrderO);
				//20200612 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
				rtnRecord.set('SALE_LOC_AMT_I', UniSales.fnExchangeApply(moneyUnit, dOrderO * panelResult.getValue('EXCHG_RATE_O')));
				this.fnTaxCalculate(rtnRecord, dOrderO);
			}
		},
		fnTaxCalculate: function(rtnRecord, dOrderO, taxType) {
			var sTaxType		= Ext.isEmpty(taxType)? rtnRecord.get('TAX_TYPE') : taxType;
			var sTaxInoutType	= rtnRecord.get('REF_TAX_INOUT');
			var dVatRate		= parseInt(BsaCodeInfo.gsVatRate);
			var dOrderAmtO		= 0;
			var dTaxAmtO		= 0;
			var dAmountI		= dOrderO;
			var dTemp			= 0;
			var sWonCalBas		= CustomCodeInfo.gsUnderCalBase;
			//20200612 추가: 자사금액 계산시, 'JPY' 관련로직 추가
			var moneyUnit		= rtnRecord.get('REF_MONEY_UNIT');

			//20190624 화폐단위 관련로직 추가
			if(panelResult.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
				var digit = UniFormat.FC.indexOf(".") == -1 ? UniFormat.FC.length : UniFormat.FC.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.FC.length - digit;
			} else {
				var digit = UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.Price.length - digit;
			}
//			var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");

			if(sTaxInoutType=="1") {	//별도
				dOrderAmtO = dOrderO;
				dTaxAmtO = dOrderO * dVatRate / 100
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderAmtO, sWonCalBas, numDigitOfPrice);

				if(UserInfo.currency == "CN"){
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTaxAmtO, '3', numDigitOfPrice);
				}else{
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTaxAmtO, sWonCalBas, numDigitOfPrice);
				}
			}else if(sTaxInoutType=="2") {	//포함
				dAmountI = dOrderO;
				if(UserInfo.currency == "CN"){
					dTemp = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '3', numDigitOfPrice);
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, '3', numDigitOfPrice)
				}else{
					dTemp = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, sWonCalBas, numDigitOfPrice);
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, sWonCalBas, numDigitOfPrice);
				}
				dOrderAmtO = UniSales.fnAmtWonCalc(dAmountI - dTaxAmtO, sWonCalBas, numDigitOfPrice);
			}
			if(sTaxType == "2") {	//면세
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderO, sWonCalBas, numDigitOfPrice ) ;
				dTaxAmtO = 0;
			}
			rtnRecord.set('SALE_AMT_O', dOrderAmtO);	//금액
			//20200612 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
			rtnRecord.set('SALE_LOC_AMT_I'	, UniSales.fnExchangeApply(moneyUnit, dOrderAmtO * panelResult.getValue('EXCHG_RATE_O')));
			rtnRecord.set('TAX_AMT_O', dTaxAmtO);	//부가세액
			rtnRecord.set('ORDER_O_TAX_O', dOrderAmtO + dTaxAmtO);	//매출계
		},
		cbGetClosingInfo: function(params){
			gsMonClosing = params.gsMonClosing
			gsDayClosing = params.gsDayClosing
		},
		fnMasterSave: function(){
			var param = panelResult.getValues();
			panelResult.submit({
				params: param,
				success:function(comp, action) {
					UniAppManager.setToolbarButtons('save', false);
					UniAppManager.updateStatus('<t:message code="system.message.sales.message033" default="저장되었습니다."/>');
				},
				failure: function(form, action){
				}
			});
		},
		//계약 데이터 참조시
		fnMakeScn100tDataRef: function(records) {
			if(!panelResult.setAllFieldsReadOnly(true)){
				return false;
			}
			if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
				Unilite.messageBox('<t:message code="system.message.sales.message054" default="마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다."/>'); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
				return false;
			}
			if(!Ext.isEmpty(panelResult.getValue('EX_NUM')) && panelResult.getValue('EX_NUM') != '0'){
				Unilite.messageBox('<t:message code="system.message.sales.message079" default="자동기표처리된 매출정보건에 대해서는 매출내역을 추가할 수 없습니다."/>');//자동기표처리된 매출정보건에 대해서는 매출내역을 추가할 수 없습니다.
				return false
			}
			var newDetailRecords = new Array();
			var count = 0;

			Ext.each(records, function(refRecord, i){
				var param = {
					COMP_CODE	: refRecord.get('COMP_CODE'),
					DIV_CODE	: refRecord.get('DIV_CODE'),
					CONT_NUM	: refRecord.get('CONT_NUM')
				}
				ssa390ukrvService.setSalesOrderList(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						Ext.each(provider, function(record, j){
							panelResult.setValue('SALE_PRSN', record.SALE_PRSN);

							var billNum = '';
							if(!Ext.isEmpty(panelResult.getValue('BILL_NUM'))) {
								billNum = panelResult.getValue('BILL_NUM');
							}
			
							var billSeq = 0;
							billSeq = detailStore.max('BILL_SEQ');
				
							if(Ext.isEmpty(billSeq)){
								billSeq = 1;
							}else{
								billSeq = billSeq + 1;
							}
							
							var inoutTypeDetail = '11'; //출고유형콤보value중 첫번째 value
							var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2
			
							var outDivCode = '';
							if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))) {
								outDivCode = panelResult.getValue('DIV_CODE');
							}
			
							var billType = '';
							if(!Ext.isEmpty(panelResult.getValue('BILL_TYPE'))) {
								if(panelResult.getValue('BILL_TYPE') != '50'){
									billType = '1'
								}else{
									billType = '2'
								}
							}
			
							var divCode = '';
							if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))) {
								divCode = panelResult.getValue('DIV_CODE');
							}
			
							var salePrsn = '';
							if(!Ext.isEmpty(panelResult.getValue('SALE_PRSN'))) {
								salePrsn = panelResult.getValue('SALE_PRSN');
							}
			
							var customCode = '';
							if(!Ext.isEmpty(panelResult.getValue('SALE_CUSTOM_CODE'))) {
								customCode = panelResult.getValue('SALE_CUSTOM_CODE');
							}
			
							var saleDate = '';
							if(!Ext.isEmpty(panelResult.getValue('SALE_DATE'))) {
								saleDate = panelResult.getValue('SALE_DATE');
							}
			
							var refBillType = '';
							if(!Ext.isEmpty(panelResult.getValue('BILL_TYPE'))) {
								refBillType = panelResult.getValue('BILL_TYPE');
							}
			
							var cardCustCd = '';
							if(!Ext.isEmpty(panelResult.getValue('CARD_CUST_CD'))) {
								cardCustCd = panelResult.getValue('CARD_CUST_CD');
							}
			
							var saleType = '';
							if(!Ext.isEmpty(panelResult.getValue('ORDER_TYPE'))) {
								saleType = panelResult.getValue('ORDER_TYPE');
							}
			
							var projectNo = '';
							if(!Ext.isEmpty(panelResult.getValue('PROJECT_NO'))) {
								projectNo = panelResult.getValue('PROJECT_NO');
							}
			
							var texInout = '';
							if(!Ext.isEmpty(panelResult.getValue('TAX_TYPE').TAX_TYPE)) {
								texInout = panelResult.getValue('TAX_TYPE').TAX_TYPE;
							}
			
							var remark = '';
							if(!Ext.isEmpty(panelResult.getValue('REMARK'))) {
								remark = panelResult.getValue('REMARK');
							}
			
							var exNum = '';
							if(!Ext.isEmpty(panelResult.getValue('EX_NUM'))) {
								exNum = panelResult.getValue('EX_NUM');
							}
			
							var moneyUnit = '';
							if(!Ext.isEmpty(panelResult.getValue('MONEY_UNIT'))) {
								moneyUnit = panelResult.getValue('MONEY_UNIT');
							}
			
							var exchgRateO = '';
							if(!Ext.isEmpty(panelResult.getValue('EXCHG_RATE_O'))) {
								exchgRateO = panelResult.getValue('EXCHG_RATE_O');
							}
			
							var srcCustomCode = '';
							if(!Ext.isEmpty(panelResult.getValue('SALE_CUSTOM_CODE'))) {
								srcCustomCode = panelResult.getValue('SALE_CUSTOM_CODE');
							}
			
							var srcCustomName = '';
							if(!Ext.isEmpty(panelResult.getValue('CUSTOM_NAME'))) {
								srcCustomName = panelResult.getValue('CUSTOM_NAME');
							}
			
							var srcOrderPrsn = '';
							if(!Ext.isEmpty(panelResult.getValue('SALE_PRSN'))) {
								srcOrderPrsn = panelResult.getValue('SALE_PRSN');
							}
			
							var deptCode = '';
							if(!Ext.isEmpty(panelResult.getValue('DEPT_CODE'))) {
								deptCode = panelResult.getValue('DEPT_CODE');
							}
			
							var whCode = '';
							if(!Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
								whCode = panelResult.getValue('WH_CODE');
							}
			
							var compCode = UserInfo.compCode;
			
							var r = {
								'BILL_SEQ'			: billSeq,
								'BILL_NUM'			: billNum,
								'INOUT_TYPE_DETAIL'	: inoutTypeDetail,
								'REF_CODE2'			: refCode2,
								'OUT_DIV_CODE'		: outDivCode,
								'TAX_TYPE'			: billType,
								'DIV_CODE'			: divCode,
								'REF_SALE_PRSN'		: salePrsn,
								'REF_CUSTOM_CODE'	: customCode,
								'REF_SALE_DATE'		: saleDate,
								'REF_BILL_TYPE'		: refBillType,
								'REF_CARD_CUST_CD'	: cardCustCd,
								'REF_SALE_TYPE'		: saleType,
								'REF_PROJECT_NO'	: projectNo,
								'REF_TAX_INOUT'		: texInout.TAX_TYPE,
								'REF_REMARK'		: remark,
								'REF_EX_NUM'		: exNum,
								'REF_MONEY_UNIT'	: moneyUnit,
								'REF_EXCHG_RATE_O'	: exchgRateO,
								'SRC_CUSTOM_CODE'	: srcCustomCode,
								'SRC_CUSTOM_NAME'	: srcCustomName,
								'SRC_ORDER_PRSN'	: srcOrderPrsn,
								'COMP_CODE'			: compCode,
								'DEPT_CODE'			: deptCode,
								'WH_CODE'			: whCode
							};
							newDetailRecords[count] = detailStore.model.create( r );
							panelResult.setAllFieldsReadOnly(true);
							detailStore.fnSaleAmtSum();
			
							newDetailRecords[count].set('OUT_DIV_CODE'		, record['DIV_CODE']);
							newDetailRecords[count].set('INOUT_TYPE_DETAIL'	, record['INOUT_TYPE_DETAIL']);
							newDetailRecords[count].set('REF_CODE2'			, refCode2);
							newDetailRecords[count].set('WH_CODE'			, record['WH_CODE']);
							newDetailRecords[count].set('ITEM_CODE'			, record['ITEM_CODE']);
							newDetailRecords[count].set('ITEM_NAME'			, record['ITEM_NAME']);
							newDetailRecords[count].set('SPEC'				, record['SPEC']);
							newDetailRecords[count].set('SALE_UNIT'			, record['SALE_UNIT']);
							newDetailRecords[count].set('TRANS_RATE'		, record['TRANS_RATE']);
							newDetailRecords[count].set('SALE_Q'			, record['SALE_Q']);
			
							if(panelResult.getValue('BILL_TYPE') != "50"){
								newDetailRecords[count].set('TAX_TYPE'		, record['TAX_TYPE']);
							}else{
								newDetailRecords[count].set('TAX_TYPE'		, '2');
							}
							newDetailRecords[count].set('ORDER_NUM'			, record['ORDER_NUM']);
							newDetailRecords[count].set('SER_NO'			, record['SER_NO']);
			
							newDetailRecords[count].set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
							newDetailRecords[count].set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);
							newDetailRecords[count].set('DVRY_CUST_NAME'	, record['DVRY_CUST_NAME']);
							newDetailRecords[count].set('PRICE_YN'			, record['PRICE_YN']);
							newDetailRecords[count].set('DIV_CODE'			, panelResult.getValue('DIV_CODE'));
							newDetailRecords[count].set('BILL_NUM'			, panelResult.getValue('BILL_NUM'));
							newDetailRecords[count].set('INOUT_TYPE'		, '2');
							newDetailRecords[count].set('STOCK_UNIT'		, record['STOCK_UNIT']);
							newDetailRecords[count].set('ITEM_STATUS'		, '1');
							newDetailRecords[count].set('ACCOUNT_YNC'		, record['ACCOUNT_YNC']);
							newDetailRecords[count].set('ORIGIN_Q'			, '0');


							newDetailRecords[count].set('REF_SALE_PRSN'		, panelResult.getValue('SALE_PRSN'));
							newDetailRecords[count].set('REF_CUSTOM_CODE'	, panelResult.getValue('SALE_CUSTOM_CODE'));
							newDetailRecords[count].set('REF_SALE_DATE'		, panelResult.getValue('SALE_DATE'));
							newDetailRecords[count].set('REF_BILL_TYPE'		, panelResult.getValue('BILL_TYPE'));
							newDetailRecords[count].set('REF_CARD_CUST_CD'	, panelResult.getValue('CARD_CUST_CD'));
							newDetailRecords[count].set('REF_SALE_TYPE'		, panelResult.getValue('ORDER_TYPE'));
			
							if(!Ext.isEmpty(panelResult.getValue('PROJECT_NO'))){
								newDetailRecords[count].set('REF_PROJECT_NO', panelResult.getValue('PROJECT_NO'));
							}else{
								newDetailRecords[count].set('REF_PROJECT_NO', record['PROJECT_NO']);
							}
//							newDetailRecords[count].set('REF_TAX_INOUT'		, panelResult.getValue('TAX_TYPE').TAX_TYPE);
							newDetailRecords[count].set('REF_REMARK'		, panelResult.getValue('REMARK'));
							newDetailRecords[count].set('REF_EX_NUM'		, panelResult.getValue('EX_NUM'));
							newDetailRecords[count].set('REF_MONEY_UNIT'	, record['MONEY_UNIT']);
							newDetailRecords[count].set('REF_EXCHG_RATE_O'	, panelResult.getValue('EXCHG_RATE_O'));
							newDetailRecords[count].set('STOCK_CARE_YN'		, record['STOCK_CARE_YN']);
							newDetailRecords[count].set('UNSALE_Q'			, record['NOT_SALE_Q']);
							newDetailRecords[count].set('UPDATE_DB_USER'	, UserInfo.userID);
							newDetailRecords[count].set('DATA_REF_FLAG'		, 'T');
							newDetailRecords[count].set('SRC_CUSTOM_CODE'	, record['SRC_CUSTOM_CODE']);
							newDetailRecords[count].set('SRC_CUSTOM_NAME'	, record['SRC_CUSTOM_NAME']);
							newDetailRecords[count].set('SRC_ORDER_PRSN'	, record['SRC_ORDER_PRSN']);
							newDetailRecords[count].set('OUT_DIV_CODE'		, record['OUT_DIV_CODE']);
			
							newDetailRecords[count].set('REF_TAX_INOUT'		, record['TAX_CALC_TYPE']);

							newDetailRecords[count].set('SALE_P'			, record['SALE_P']);
							newDetailRecords[count].set('SALE_AMT_O'		, record['SALE_AMT_O']);
							//20200612 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
							newDetailRecords[count].set('SALE_LOC_AMT_I'	, UniSales.fnExchangeApply(record['MONEY_UNIT'], Unilite.multiply(record['SALE_AMT_O'], panelResult.getValue('EXCHG_RATE_O'))));
							newDetailRecords[count].set('TAX_AMT_O'			, record['TAX_AMT_O']);
							newDetailRecords[count].set('ORDER_O_TAX_O'		, record['ORDER_O_TAX_O']);
			
							newDetailRecords[count].set('COMP_CODE'			, UserInfo.compCode);
							UniSales.fnStockQ(newDetailRecords[count]		, UniAppManager.app.cbStockQ, UserInfo.compCode, newDetailRecords[count].get('DIV_CODE'), "1", newDetailRecords[count].get('ITEM_CODE'),  newDetailRecords[count].get('WH_CODE'));
//							UniAppManager.app.fnOrderAmtCal(newDetailRecords[count], "Q");
							if(count + 1 == newDetailRecords.length) {
								detailStore.loadData(newDetailRecords, true);
							}
							count = count + 1;
						});
					}
				});
			});
		}
	});// End of Unilite.Main( {



	/**
	* Validation
	*/
	Unilite.createValidator('validator01',{
		store: detailStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ',{'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			if(record.phantom && Ext.isEmpty(record.get('REF_EX_NUM')) && record.get('REF_EX_NUM' != "0")){//신규일때
				rv = '<t:message code="system.message.sales.message077" default="회계전표가 생성된 매출자료는 수정/삭제할 수 없습니다."/>';	//회계전표가 생성된 매출자료는 수정/삭제할 수 없습니다.
			}else if(record.phantom && Ext.isEmpty(record.get('PUB_NUM'))){
				rv = '<t:message code="system.message.sales.message068" default="계산서가 발행된 건은 삭제할 수 없습니다."/>';	//계산서가 발행된 건은 삭제할 수 없습니다.
			}else{
				switch(fieldName) {
					case "BILL_SEQ" :
						if(newValue <= 0 && !Ext.isEmpty(newValue)) {
							rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							break;
						}
						break;

					case "INOUT_TYPE_DETAIL" :
						var sInoutTypeDetail = record.get('INOUT_TYPE_DETAIL');
						var sRefCode2 = UniAppManager.app.fnGetSubCode(null, sInoutTypeDetail) ;	//출고유형value의 ref2
						record.set('REF_CODE2', sRefCode2);

						if(sRefCode2 >= "90" && sRefCode2 != "94" && sRefCode2 != "95" && sRefCode2 != "AU"){
							rv = '<t:message code="system.message.sales.message046" default="해당 출고유형은 선택할 수 없습니다."/>';	//해당 출고유형은 선택할 수 없습니다.
							break;
						}

						if(sRefCode2 == "94" || sRefCode2 == "95" || sRefCode2 == "AU"){	//'미매출대상인 경우
							if(record.get('ACCOUNT_YNC') == "N"){
								rv = '<t:message code="system.message.sales.message082" default="매출대상이 NO 인 경우,해당 출고유형은 선택할 수 없습니다."/>';	//매출대상이 'NO'인 경우,해당 출고유형은 선택할 수 없습니다.
								break;
							}
						}

						if(record.get('INOUT_TYPE') != "3"){	//반품이외
							if(sRefCode2 == "95"){
								rv = '<t:message code="system.message.sales.message046" default="해당 출고유형은 선택할 수 없습니다."/>'; //해당 출고유형은 선택할 수 없습니다.
								break;
							}
						}else{
							if(gsOldRefCode2 == "95" && sRefCode2 != "95"){
								rv = '<t:message code="system.message.sales.message087" default="반품관련 출고유형을 선택해 주십시오."/>';	//반품관련 출고유형을 선택해 주십시오.
								break;
							}
						}

						if(sRefCode2 == "94" || sRefCode2 == "AU"){	//'에누리 , 금액보정용
							record.set('SALE_Q', "0");
							record.set('SALE_P', "0");
							record.set('SALE_AMT_O', "0");
							record.set('TAX_AMT_O', "0");
							record.set('STOCK_UNIT', "");
							record.set('TRANS_RATE', "1");
							record.set('DISCOUNT_RATE', "0");
							record.set('STOCK_CARE_YN', "N");
							record.set('SALE_LOC_AMT_I', "0");
							if(panelResult.getValue('BILL_TYPE') != "50"){
								record.set('TAX_TYPE', "1");
							}else{
								record.set('TAX_TYPE', "2");
							}

							record.set('ACCOUNT_YNC', "Y");
							record.set('PRICE_YN', "2");
							record.set('UPDATE_DB_USER', UserInfo.userID);
							record.set('INOUT_TYPE', "2");
							record.set('DIV_CODE', panelResult.getValue('DIV_CODE'));
							record.set('ITEM_STATUS', "1");
							record.set('ORIGIN_Q', "0");
							record.set('STOCK_Q', "0");
							record.set('REF_SALE_PRSN', panelResult.getValue('SALE_PRSN'));
							record.set('REF_CUSTOM_CODE', panelResult.getValue('SALE_CUSTOM_CODE'));
							record.set('REF_SALE_DATE', panelResult.getValue('SALE_DATE'));
							record.set('REF_BILL_TYPE', panelResult.getValue('BILL_TYPE'));
							record.set('REF_CARD_CUST_CD', panelResult.getValue('CARD_CUST_CD'));
							record.set('REF_SALE_TYPE', panelResult.getValue('ORDER_TYPE'));
							record.set('REF_PROJECT_NO', panelResult.getValue('PROJECT_NO'));
							if(panelResult.getValue('TAX_TYPE').TAX_TYPE == "1"){
								record.set('REF_TAX_INOUT', "1");
							}else{
								record.set('REF_TAX_INOUT', "2");
							}

							record.set('REF_REMARK', panelResult.getValue('REMARK'));
							record.set('REF_EX_NUM', panelResult.getValue('EX_NUM'));
							record.set('REF_MONEY_UNIT', panelResult.getValue('MONEY_UNIT'));
							record.set('REF_EXCHG_RATE_O', panelResult.getValue('EXCHG_RATE_O'));
							record.set('UNSALE_Q', "0");
							record.set('DATA_REF_FLAG', "F");
							record.set('SRC_CUSTOM_CODE', panelResult.getValue('SALE_CUSTOM_CODE'));
							record.set('SRC_CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
							record.set('SRC_ORDER_PRSN', panelResult.getValue('SALE_PRSN'));
						}
						break;

					case "OUT_DIV_CODE" :	////구현해야함
//						record.set('WH_CODE', Ext.data.StoreManager.lookup('whList').getAt(0).get('value')); ////창고콤보value중 첫번째 value 사업장별 창고로 수정요망

						break;

					case "WH_CODE" :		////구현해야함

						break;

					case "SALE_UNIT" :
						UniSales.fnGetPriceInfo(record, UniAppManager.app.cbGetPriceInfo
												,'I'
												,UserInfo.compCode
												,panelResult.getValue('SALE_CUSTOM_CODE')
												,BsaCodeInfo.gsAgentType
												,record.get('ITEM_CODE')
												,BsaCodeInfo.gsMoneyUnit
												,record.get('SALE_UNIT')
												,record.get('STOCK_UNIT')
												,record.get('TRANS_RATE')
												,UniDate.getDbDateStr(panelResult.getValue('SALE_DATE'))
												);
//						detailStore.fnSaleAmtSum();
						break;

					case "TRANS_RATE" :
						UniSales.fnGetPriceInfo(record, UniAppManager.app.cbGetPriceInfo
												,'R'
												,UserInfo.compCode
												,panelResult.getValue('SALE_CUSTOM_CODE')
												,BsaCodeInfo.gsAgentType
												,record.get('ITEM_CODE')
												,BsaCodeInfo.gsMoneyUnit
												,record.get('SALE_UNIT')
												,record.get('STOCK_UNIT')
												,record.get('TRANS_RATE')
												,UniDate.getDbDateStr(panelResult.getValue('SALE_DATE'))
												);
//						detailStore.fnSaleAmtSum();
						break;

					case "SALE_Q" :
						var sInout_q = 0;
						var sInv_q = 0;
						var sOriginQ = 0;
						var sRefCode2 = record.get('REF_CODE2');
						if(sRefCode2 != "94" && sRefCode2 != "95" ){
							if(newValue < 0 && !Ext.isEmpty(newValue)) {
								rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
								break;
							}
						}

						if(record.get('INOUT_TYPE') == "3"){ //반품
							if(newValue > 0 && !Ext.isEmpty(newValue)) {
								rv = '<t:message code="system.message.sales.message080" default="음수만 입력가능합니다."/>';
								break;
							}
						}else{
							if(newValue < 0 && !Ext.isEmpty(newValue)) {
								rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
								break;
							}
						}
						if(record.get('INOUT_TYPE') == "2"){
							sInout_q = newValue;
							if(!Ext.isEmpty(record.get('STOCK_Q'))){
								sInv_q = record.get('STOCK_Q');
							}
							if(!Ext.isEmpty(record.get('ORIGIN_Q'))){
								sOriginQ = record.get('ORIGIN_Q');
							}

							if(BsaCodeInfo.gsInvStatus == "+" && record.get('STOCK_CARE_YN') == "Y" && BsaCodeInfo.gsSaleAutoYN == "Y"){
								if(sInout_q > sInv_q + sOriginQ){
									rv = '<t:message code="system.label.sales.warehousecode" default="창고코드"/>:' + record.get('WH_CODE') + '<br>' +	//창고코드 :
										'<t:message code="system.label.sales.issueqty" default="출고량"/>:' + sInout_q + '<br>' +'<t:message code="system.label.sales.inventoryqty" default="재고량"/>:' + sInv_q +'<br>' +  //출고량:   재고량:
										'<t:message code="system.message.sales.message067" default="출고량은 재고량을 초과할 수 없습니다."/>'	//출고량은 재고량을 초과할 수 없습니다.
									break;
								}
							}
						}

						if(record.phantom){
							if(Ext.isEmpty(record.get('INOUT_NUM'))){
								if(record.get('UNSALE_Q') > 0){
									if(record.get('UNSALE_Q') < newValue){
										rv = '<t:message code="system.message.sales.message088" default="미매출량을 초과하였습니다."/>';
										break;
									}
								}else{
									if(record.get('UNSALE_Q') > newValue){
										rv = '<t:message code="system.message.sales.message088" default="미매출량을 초과하였습니다."/>';
										break;
									}
									if(newValue > 0){
										rv = '<t:message code="system.message.sales.message088" default="미매출량을 초과하였습니다."/>';
										break;
									}
								}
							}
						}
						UniAppManager.app.fnOrderAmtCal(record, 'Q', fieldName, newValue);
//						detailStore.fnSaleAmtSum();
						break;

					case "SALE_P" :
						if(record.get('ACCOUNT_YNC') == "N"){	//미매출대상인 경우
							if(newValue < 0 && !Ext.isEmpty(newValue)) {
								rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';	//매출대상이 'NO'인 경우, 숫자 0만 입력가능합니다.
								break;
							}
							record.set('SALE_AMT_O', 0);
							record.set('SALE_LOC_AMT_I', 0);
							record.set('TAX_AMT_O', 0);
						}
						UniAppManager.app.fnOrderAmtCal(record, 'P', fieldName, newValue);
//						detailStore.fnSaleAmtSum();

						break;

					case "SALE_AMT_O" :
						var sRefCode2 = record.get('REF_CODE2');
						var sInoutTypeDetail = record.get('INOUT_TYPE_DETAIL');
						var dTaxAmtO = 0;

						if(sRefCode2 == "94" || sRefCode2 == "95"){ //'에누리/반품환입
							if(newValue > 0 && !Ext.isEmpty(newValue)) {
								rv =  '<t:message code="system.message.sales.message080" default="음수만 입력가능합니다."/>';	//음수만 입력 가능합니다.
								break;
							}
						}else if(sRefCode2 == "AU"){ //금액보정
							if(newValue < 0 && !Ext.isEmpty(newValue)) {
								rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';	//양수만 입력 가능합니다.
								break;
							}
						}else{
							if(newValue < 0 && !Ext.isEmpty(newValue)) {
								rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';	//양수만 입력 가능합니다.
								break;
							}

							if(record.get('ACCOUNT_YNC') == "N"){	//미매출대상인 경우
								if(newValue != 1){
									rv = '<t:message code="system.message.sales.message081" default="매출대상이 NO 인 경우, 숫자 0만 입력가능합니다."/>'; //매출대상이 'NO'인 경우, 숫자 0만 입력가능합니다.
									break;
								}
								record.set('SALE_P', 0);
								record.set('SALE_LOC_AMT_I', 0);
								record.set('TAX_AMT_O', 0);
							}
						}

						dTaxAmtO = record.get('TAX_AMT_O');
						if(newValue > 0){
							if(record.get('ADVAN_YN') != "Y"){
								if(dTaxAmtO > newValue){
									rv = '<t:message code="system.message.sales.message040" default="매출금액은 세액보다 커야 합니다."/>'; //매출금액은 세액보다 커야 합니다.
									break;
								}
							}
						}else{
							if(dTaxAmtO < newValue){
								rv = '<t:message code="system.message.sales.message083" default="매출금액은 세액보다 작아야 합니다."/>' //매출금액은 세액보다 작아야 합니다.
								break;
							}
						}

						UniAppManager.app.fnOrderAmtCal(record, 'O', fieldName, newValue);
//						detailStore.fnSaleAmtSum();
						rv = false;
						break;

					case "TAX_TYPE" :		  //과세구분
//						if(!Ext.isEmpty(newValue) && newValue == "1"){
//							var inoutTax = record.get('SALE_AMT_O') / 10
//							record.set('TAX_AMT_O', inoutTax);
//							record.set('TAX_TYPE', newValue)
//							detailStore.fnSaleAmtSum(newValue);
//						}else if(!Ext.isEmpty(newValue) && newValue == "2"){
//							record.set('TAX_AMT_O', 0);
//							record.set('TAX_TYPE', newValue)
//							detailStore.fnSaleAmtSum(newValue);
//						}
//						UniAppManager.app.fnOrderAmtCal(record, 'O', fieldName, null, newValue);
//
						var dOrderO=record.get('SALE_Q')*record.get('SALE_P');
						record.set('SALE_AMT_O', dOrderO);
						UniAppManager.app.fnOrderAmtCal(record, "O",'SALE_AMT_O', dOrderO, newValue);
//						detailStore.fnSaleAmtSum();
						break;

					case "TAX_AMT_O" :			//부가세액
						var dSaleAmtO = 0;
						var sRefCode2 = record.get('REF_CODE2');
						if(sRefCode2 == "94" || sRefCode2 == "95"){ //'에누리/반품환입
							if(newValue > 0 && !Ext.isEmpty(newValue)) {
								rv =  '<t:message code="system.message.sales.message080" default="음수만 입력가능합니다."/>';	//음수만 입력 가능합니다.
								break;
							}
						}else if(sRefCode2 == "AU"){ //금액보정
							if(newValue < 0 && !Ext.isEmpty(newValue)) {
								rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';	//양수만 입력 가능합니다.
								break;
							}
						}else{
							if(newValue < 0 && !Ext.isEmpty(newValue)) {
								rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';	//양수만 입력 가능합니다.
								break;
							}
						}

						if(record.get('ACCOUNT_YNC') == "N"){	//미매출대상인 경우
							if(newValue != 1){
								rv = '<t:message code="system.message.sales.message081" default="매출대상이 NO 인 경우, 숫자 0만 입력가능합니다."/>'; //매출대상이 'NO'인 경우, 숫자 0만 입력가능합니다.
								break;
							}
							record.set('SALE_AMT_O', 0);
							record.set('SALE_LOC_AMT_I', 0);
							record.set('SALE_P', 0);
						}else{
							dSaleAmtO = record.get('SALE_AMT_O');
							if(record.get('TAX_TYPE')  == "2"){
								if(newValue != 0){
									rv = '<t:message code="system.message.sales.message084" default="과세구분이 면세인 경우, 부가세액은 0입니다."/>'; //과세구분이 면세인 경우, 부가세액은 0입니다.
									break;
								}
							}else{
								if(dSaleAmtO > 0){
									if(dSaleAmtO < newValue){
										rv = '<t:message code="system.message.sales.message085" default="세액은 매출액보다 작아야 합니다."/>'; //세액은 매출액보다 작아야 합니다.
										break;
									}
								}else{
									if(dSaleAmtO > newValue){
										rv = '<t:message code="system.message.sales.message086" default="세액은 매출액보다 커야 합니다."/>'; //세액은 매출액보다 커야 합니다.
										break;
									}
								}
							}
							var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
							if(UserInfo.currency == "CN"){
								record.set('TAX_AMT_O', UniSales.fnAmtWonCalc(dTaxAmtO, "3", numDigitOfPrice));
							}else{
								record.set('TAX_AMT_O',UniSales.fnAmtWonCalc(dTaxAmtO, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice));
							}
						}
//						detailStore.fnSaleAmtSum();
						record.set('ORDER_O_TAX_O', record.get('SALE_AMT_O') + newValue);
						break;

					case "PRICE_YN" :	//구현내용 없음

						break;

					case "DVRY_CUST_NAME" :	//배송처 팝업 필요

						break;

					case "DISCOUNT_RATE" :
						if(newValue < 0 && !Ext.isEmpty(newValue)) {
							rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';	//양수만 입력 가능합니다.
							break;
						}
						UniAppManager.app.fnOrderAmtCal(record, 'C', fieldName, (100 - newValue));
//						detailStore.fnSaleAmtSum();
						break;

					case "ORDER_PRSN" :	//구현내용 없음

						break;

					case "LOT_NO" :

						break;
				}
			}
			return rv;
		}
	}); // validator
};


</script>
