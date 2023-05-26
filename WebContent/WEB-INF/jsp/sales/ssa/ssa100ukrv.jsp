<%--
'   프로그램명 : 매출등록 (영업)
'   작   성   자 : (주)시너지시스템즈 개발실
'   작   성   일 :
'   최종수정자 :
'   최종수정일 :
'   버         전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa100ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa100ukrv" />				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>						<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S024" />						<!-- 부가세유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S002"/>						<!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S007"/>						<!-- 출고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A"/>							<!-- 출고창고 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />						<!-- 판매단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>						<!-- 과세여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S003"/>						<!-- 단가구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B034" storeId="B034"/>		<!-- 결제조건 -->
	<t:ExtComboStore comboType="AU" comboCode="B035"/>						<!-- 수불타입 -->
	<t:ExtComboStore comboType="AU" comboCode="B030"/>						<!-- 세액포함여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S014"/>						<!-- 매출대상 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>						<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="S065"/>						<!-- 주문구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S166"/>						<!-- 보증기간 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />			<!--창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고Cell-->
	<t:ExtComboStore comboType="OU" />										<!-- 창고-->
	<t:ExtComboStore comboType="AU" comboCode="B059" />	<!-- 세구분 -->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>
<script type="text/javascript">
var SearchInfoWindow;				//SearchInfoWindow : 검색창
var referSalesOrderWindow;			//수주참조
var referIssueWindow;				//출고(미매출)/반품출고참조
var referPreviousSalesOrderWindow;	//수주참조(선매출)
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
	grsSalePrsn		: ${grsSalePrsn},
	//20191113 로그인한 유저의 영업담당 가져오는 로직 추가
	gsSalesPrsn		: Ext.isEmpty(${gsSalesPrsn}) ? '' : '${gsSalesPrsn}',
	gsCreditMsg		: '${gsCreditMsg}' // 신용여신액 초과시 메세지 설정
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

	var isAdvanUseYN = false;
	if(BsaCodeInfo.gsAdvanUseYn=='N') {	//수주참조 선매출탭 사용유무
		isAdvanUseYN = true;
	}



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ssa100ukrvService.selectDetailList',
			update	: 'ssa100ukrvService.updateDetail',
			create	: 'ssa100ukrvService.insertDetail',
			destroy	: 'ssa100ukrvService.deleteDetail',
			syncAll	: 'ssa100ukrvService.saveAll'
		}
	});

	//마스터 폼
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.sales.salesinfo" default="매출정보"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		items		: [{
			title		: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
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
						//20190731 임시 주석
//						combo.changeDivCode(combo, newValue, oldValue, eOpts);
//						var field = panelResult.getField('SALE_PRSN');
//						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						if(!Ext.isEmpty(newValue) && !Ext.isEmpty(panelSearch.getValue('SALE_DATE'))){
							UniSales.fnGetClosingInfo(
								UniAppManager.app.cbGetClosingInfo,
								newValue,
								"S",
								panelSearch.getField('SALE_DATE').getSubmitValue()
							);
						}
						if(CustomCodeInfo.gsCustCreditYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
							//여신액 구하기
							var divCode		= newValue;
							var CustomCode	= panelSearch.getValue('SALE_CUSTOM_CODE');
							var saleDate	= panelSearch.getField('SALE_DATE').getSubmitValue();
							var moneyUnit	= BsaCodeInfo.gsMoneyUnit;
							//마스터폼에 여신액 set
							UniAppManager.app.fnGetCustCredit(divCode, CustomCode, saleDate, moneyUnit);
						}
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
				valueFieldName	: 'SALE_CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				allowBlank		: false,
				validateBlank	: true,
				holdable		: 'hold',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
//							var projectPopup = panelSearch.down('#project');
//							projectPopup.setExtParam({'CUSTOM_CODE':records[0]["CUSTOM_CODE"]});
							CustomCodeInfo.gsAgentType		= records[0]["AGENT_TYPE"];   //거래처분류
							CustomCodeInfo.gsCustCreditYn	= records[0]["CREDIT_YN"];
							CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"]; //원미만계산
							CustomCodeInfo.gsTaxCalType		= records[0]["TAX_CALC_TYPE"];
							CustomCodeInfo.gsRefTaxInout	= records[0]["TAX_TYPE"];	//세액포함여부
							salesOrderSearch.setValue('CUSTOM_CODE', panelSearch.getValue('SALE_CUSTOM_CODE'));//수주참조에 SET
							salesOrderSearch.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));//수주참조에 SET

							if(!Ext.isEmpty(records[0]["MONEY_UNIT"])){
								panelSearch.setValue('MONEY_UNIT', records[0]["MONEY_UNIT"]);
								panelResult.setValue('MONEY_UNIT', records[0]["MONEY_UNIT"]);
							}
							if(!Ext.isEmpty(records[0]["BUSI_PRSN"])){ // 20210728 거래처의 주영업담당자가 있으면 영업담당 다시 세팅
								panelSearch.setValue('SALE_PRSN', records[0]["BUSI_PRSN"]);
								panelResult.setValue('SALE_PRSN', records[0]["BUSI_PRSN"]);
//								var deptCode = UniAppManager.app.fnGetDeptCode(records[0]["BUSI_PRSN"]);	//영업담당의 부서 set
//								UniAppManager.app.fnSetDeptCodeName(deptCode);
							}
							if(!Ext.isEmpty(CustomCodeInfo.gsRefTaxInout)){
								panelSearch.setValue('TAX_TYPE', CustomCodeInfo.gsRefTaxInout)
								panelResult.setValue('TAX_TYPE', CustomCodeInfo.gsRefTaxInout)
							}
							if(CustomCodeInfo.gsCustCreditYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
								//여신액 구하기
								var divCode		= UserInfo.divCode;
								var CustomCode	= panelSearch.getValue('SALE_CUSTOM_CODE');
								var saleDate	= panelSearch.getField('SALE_DATE').getSubmitValue()
								var moneyUnit	= BsaCodeInfo.gsMoneyUnit;
								//마스터폼에 여신액 set
								UniAppManager.app.fnGetCustCredit(divCode, CustomCode, saleDate, moneyUnit);
							}
							
							// 결제 조건
							if(!Ext.isEmpty(records[0]["RECEIPT_DAY"])){
								panelSearch.setValue('PAYMENT_TERM', records[0]["RECEIPT_DAY"]);
								panelResult.setValue('PAYMENT_TERM', records[0]["RECEIPT_DAY"]);
								
								// 결제 조건 값에 따른 결제 예정일 세팅
								fnControlPaymentDay(records[0]["RECEIPT_DAY"]);
							} else {
								// 결제 예정일 set
								panelSearch.setValue('PAYMENT_DAY', panelSearch.getValue('SALE_DATE'));
								panelResult.setValue('PAYMENT_DAY', panelSearch.getValue('SALE_DATE'));
							}
							
							panelResult.setValue('SALE_CUSTOM_CODE', panelSearch.getValue('SALE_CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
//							panelSearch.setValue('TEX_CAR_TYPE', records[0]["TAX_CALC_TYPE"]);
							UniAppManager.app.fnExchngRateO();
						},
						scope: this
					},
					onClear: function(type) {
						CustomCodeInfo.gsAgentType		= '';
						CustomCodeInfo.gsCustCreditYn	= '';
						CustomCodeInfo.gsUnderCalBase	= '';
						CustomCodeInfo.gsTaxCalType		= '';
						CustomCodeInfo.gsRefTaxInout	= '';
						salesOrderSearch.setValue('CUSTOM_CODE'	, '');//수주참조에 SET
						salesOrderSearch.setValue('CUSTOM_NAME'	, '');//수주참조에 SET
						panelResult.setValue('SALE_CUSTOM_CODE'	, '');
						panelResult.setValue('CUSTOM_NAME'		, '');

						panelSearch.setValue('MONEY_UNIT'		, '');
						panelResult.setValue('MONEY_UNIT'		, '');
						panelSearch.setValue('EXCHG_RATE_O'		, 0);
						panelResult.setValue('EXCHG_RATE_O'		, 0);
//						panelSearch.setValue('TEX_CAR_TYPE', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name		: 'SALE_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					} else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SALE_PRSN', newValue);
						//20191021 panel의 영업담당 변경 시, 그리드 영업담당도 변경되도록 수정
						var detailRecords = masterGrid.getStore().data.items;
						Ext.each(detailRecords, function(detailRecord, index) {
							detailRecord.set('REF_SALE_PRSN', newValue);
						});
//						var deptCode = UniAppManager.app.fnGetDeptCode(newValue);	//영업담당의 부서 set
//						UniAppManager.app.fnSetDeptCodeName(deptCode);
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
						if(!Ext.isEmpty(newValue && !Ext.isEmpty(panelSearch.getValue('DIV_CODE')))){
							UniSales.fnGetClosingInfo(
								UniAppManager.app.cbGetClosingInfo,
								panelSearch.getValue('DIV_CODE'),
								"S",
								UniDate.getDbDateStr(newValue)
							);
						}
						if(CustomCodeInfo.gsCustCreditYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
							//여신액 구하기
							var divCode		= UserInfo.divCode;;
							var CustomCode	= panelSearch.getValue('SALE_CUSTOM_CODE');
							var saleDate	= UniDate.getDbDateStr(newValue);
							var moneyUnit	= BsaCodeInfo.gsMoneyUnit;
							//마스터폼에 여신액 set
							UniAppManager.app.fnGetCustCredit(divCode, CustomCode, saleDate, moneyUnit);
						}
						
						panelResult.setValue('SALE_DATE', newValue);
						// 매출일 값에 따른 결제 예정일 세팅
						fnControlPaymentDay(panelSearch.getValue("PATMENT_TERM"));
						UniAppManager.app.fnExchngRateO();
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.vattype" default="부가세유형"/>',
				name		: 'BILL_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S024',
				value		: '10',
				allowBlank	: false,
				holdable	: '',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BILL_TYPE', newValue);

						// 20210222 : 부가세유형이 카드매출인 경우 카드사 readonly 비활성
						if('40' == newValue){
							panelSearch.getField('CARD_CUSTOM_CODE').setReadOnly(false);
							panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(false);
						} else {
							panelSearch.setValue('CARD_CUSTOM_CODE', '');
							panelSearch.getField('CARD_CUSTOM_CODE').setReadOnly(true);
							panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(true);
						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name		: 'ORDER_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S002',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
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
						panelResult.setValue('BILL_NUM', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>',
				name		: 'TAX_TYPE',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'B030',
				width		: 235,
				value		: '1',
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TAX_TYPE',newValue.TAX_TYPE);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.base.taxtype" default="세구분"/>' ,
				name		: 'TAX_TYPE2',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				holdable	: 'hold',
				comboCode	: 'B059',
				allowBlank	: true,
				fieldStyle	: 'text-align: center;',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TAX_TYPE2',newValue);
					}
				}
			},
			Unilite.popup('PROJECT',{
				fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
				validateBlank	: true,
				holdable		: 'hold',
				textFieldName	: 'PROJECT_NO',
				itemId			: 'project',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('PROJECT_NO'		, records[0]["PJT_CODE"]);
								panelResult.setValue('SALE_CUSTOM_CODE'	, records[0]["CUSTOM_CODE"]);
								panelResult.setValue('CUSTOM_NAME'		, records[0]["CUSTOM_NAME"]);
								panelSearch.setValue('PROJECT_NO'		, records[0]["PJT_CODE"]);
								panelSearch.setValue('SALE_CUSTOM_CODE'	, records[0]["CUSTOM_CODE"]);
								panelSearch.setValue('CUSTOM_NAME'		, records[0]["CUSTOM_NAME"]);
								//20200103 추가
								panelSearch.setValue('PJT_NAME'			, records[0]["PJT_NAME"]);
							},
							scope: this
						},
						onClear: function(type) {
							panelResult.setValue('PROJECT_NO'		, '');
							panelResult.setValue('SALE_CUSTOM_CODE'	, '');
							panelResult.setValue('CUSTOM_NAME'		, '');
							panelSearch.setValue('PROJECT_NO'		, '');
							panelSearch.setValue('SALE_CUSTOM_CODE'	, '');
							panelSearch.setValue('CUSTOM_NAME'		, '');
							//20200103 추가
							panelSearch.setValue('PJT_NAME'			, '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'BPARAM0'	: 3});
							popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('SALE_CUSTOM_CODE')});
						},
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('PROJECT_NO', newValue);
						}
					}
			}),{
				fieldLabel	: '<t:message code="system.label.sales.remarks" default="비고"/>',
				xtype		: 'textarea',
				name		: 'REMARK',
				height		: 50,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('REMARK', newValue);
					}
				}
			// 20210222 : 카드사(CARD_CUSTOM_CODE) 추가
			},{
				fieldLabel	: '<t:message code="system.label.sales.cardcustomnm" default="카드사"/>' ,
				name		: 'CARD_CUSTOM_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A028',
				allowBlank	: true,
				readOnly    : true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CARD_CUSTOM_CODE',newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.paycondition" default="결제조건"/>',
				name		: 'PAYMENT_TERM',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B034',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						
						// 결제조건 값에 따른 결제 예정일 세팅
						fnControlPaymentDay(newValue);
						panelResult.setValue('PAYMENT_TERM',newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.paymentday" default="결제예정일"/>',
				xtype		: 'uniDatefield',
				name		: 'PAYMENT_DAY',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PAYMENT_DAY',newValue);
					}
				}
			},{	//20200629 추가: 구매확인서 번호(SSA100T.PURCH_DOC_NO)
				xtype	: 'container' ,
				layout	: {type:'hbox'},
				width	: 300,
				items	: [{
					fieldLabel	: '<t:message code="system.label.sales.purchasedocumentno" default="구매확인서번호"/>',
					xtype		: 'uniTextfield',
					name		: 'PURCH_DOC_NO',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('PURCH_DOC_NO', newValue);
						}
					}
				}]
			},{	//20200629 추가: 발급일자(SSA100T.ISSUE_DATE)
				xtype	: 'container' ,
				layout	: {type:'hbox'},
				width	: 300,
				items	: [{
					fieldLabel	: '<t:message code="system.label.sales.issuedate2" default="발급일자"/>',
					xtype		: 'uniDatefield',
					name		: 'ISSUE_DATE',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ISSUE_DATE', newValue);
						}
					}
				}]
			}]
		},{
			title		:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id			: 'search_panel2',
			itemId		:'search_panel2',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [{
				fieldLabel	: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'OU',
				holdable	: 'hold'
			},
			Unilite.popup('ITEM2',{	//카드 팝업?
				fieldLabel		: '<t:message code="system.label.sales.cardcustnm" default="카드가맹점"/>',
				validateBlank	: false,
				valueFieldName	: 'CARD_CUST_NM',
				textFieldName	: 'CARD_NM',
				readOnly		: true,
				hidden		    : true        // 20210222 수정 : 숨김처리
			}),{
				fieldLabel	: '<t:message code="system.label.sales.taxabletotalamount" default="과세총액"/>(1)',
				name		: 'TOT_SALE_TAX_O',
				id			: 'M_TOT_SALE_TAX_O',
				xtype		: 'uniNumberfield',
				value		: 0,
				readOnly	: true
			},{
				fieldLabel	: '<t:message code="system.label.sales.taxexemptiontotalamount" default="면세총액"/>(2)',
				name		: 'TOT_SALE_EXP_O',
				id			: 'M_TOT_SALE_EXP_O',
				xtype		: 'uniNumberfield',
				value		: 0,
				readOnly	: true
			},{
				fieldLabel	: '<t:message code="system.label.sales.taxsmalltotalamount" default="영세총액"/>(3)',
				name		: 'TOT_SALE_ZERO_O',
				id			: 'M_TOT_SALE_ZERO_O',
				xtype		: 'uniNumberfield',
				value		: 0,
				readOnly	: true
			},{
				fieldLabel	: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>(4)',
				name		: 'TOT_SALE_SUPPLY_O',
				id			: 'M_TOT_SALE_SUPPLY_O',
				xtype		: 'uniNumberfield',
				value		: 0,
				readOnly	: true
			},{
				fieldLabel	: '<t:message code="system.label.sales.taxtotalamount" default="세액합계"/>(5)',
				name		: 'TOT_TAX_AMT',
				id			: 'M_TOT_TAX_AMT',
				xtype		: 'uniNumberfield',
				value		: 0,
				readOnly	: true
			},{
				fieldLabel	: '<t:message code="system.label.sales.amountofsupply" default="공급대가"/>(6)',
				name		: 'TOT_AMT',
				id			: 'M_TOT_AMT',
				xtype		: 'uniNumberfield',
				value		: 0,
				readOnly	: true
			},{
				fieldLabel	: '<t:message code="system.label.sales.exslipdate" default="결의전표일"/>',
				name		: 'EX_DATE',
				xtype		: 'uniTextfield',
				readOnly	: true
			},{
				fieldLabel	: '<t:message code="system.label.sales.exslipno" default="결의전표번호"/>',
				name		: 'EX_NUM',
				xtype		: 'uniTextfield',
				readOnly	: true
			},{
				xtype		: 'uniNumberfield',
				name		: 'EXCHG_RATE_O',		//환율,
				hidden		: true,
				type		: 'uniER',
				holdable	: 'hold',
				decimalPrecision: 4,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EXCHG_RATE_O', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.creditbalance" default="여신잔액"/>',
				xtype		: 'uniNumberfield',	//여신잔액
				name		: 'TOT_REM_CREDIT_I',
				hidden		: isCreditYn
			},{
				xtype		: 'uniTextfield',		//화폐단위
				name		: 'MONEY_UNIT',
				hidden		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('MONEY_UNIT', newValue);
						if(newValue != BsaCodeInfo.gsMoneyUnit){
//							var length = Ext.isEmpty(UniFormat.FC.split('.')[1]) ? 0 : UniFormat.FC.split('.')[1].length;
//							detailGrid.getColumn("ORDER_O").setConfig('format',UniFormat.FC);
//							detailGrid.getColumn("ORDER_O").setConfig('decimalPrecision',length);
//							detailGrid.getColumn("ORDER_O_TAX_O").setConfig('format',UniFormat.FC);
//							detailGrid.getColumn("ORDER_O_TAX_O").setConfig('decimalPrecision',length);
//							detailGrid.getView().refresh(true);
						} else {
//							var length = Ext.isEmpty(UniFormat.Price.split('.')[1]) ? 0 : UniFormat.Price.split('.')[1].length;
//							detailGrid.getColumn("ORDER_O").setConfig('format',UniFormat.Price);
//							detailGrid.getColumn("ORDER_O").setConfig('decimalPrecision',length);
//							detailGrid.getColumn("ORDER_O_TAX_O").setConfig('format',UniFormat.Price);
//							detailGrid.getColumn("ORDER_O_TAX_O").setConfig('decimalPrecision',length);
//							detailGrid.getView().refresh(true);
						}
//						if(isLoad){
//							isLoad = false;
//						} else{
//							UniAppManager.app.fnExchngRateO();
//						}
					}
				}
			},{
				xtype		: 'uniNumberfield',
				name		: 'EXCHG_AMT_I',		//환산액
				hidden		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EXCHG_AMT_I', newValue);
					}
				}
			},{
				xtype	: 'hiddenfield',
				name	: 'CARD_CUST_CD'		//카드가맹점
			},{
				xtype	: 'hiddenfield',
				name	: 'CARD_TAX_TYPE'
			},{
				xtype	: 'hiddenfield',
				name	: 'TAX_CALC_TYPE'
			},{
				fieldLabel	: 'PJT_NAME',
				xtype		: 'uniTextfield',
				name		: 'PJT_NAME',
				hidden		: true
			}]
		}],
		api: {
			load	: 'ssa100ukrvService.selectMaster',
			submit	: 'ssa100ukrvService.syncForm'
		},
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
				if(gsSaveRefFlag == "Y"
				&& (basicForm.getField('REMARK').isDirty() || basicForm.getField('PROJECT_NO').isDirty() || basicForm.getField('SALE_PRSN').isDirty() || basicForm.getField('SALE_PRSN').dirty
				      || basicForm.getField('CARD_CUSTOM_CODE').isDirty()|| basicForm.getField('PAYMENT_TERM').isDirty()|| basicForm.getField('PAYMENT_DAY').isDirty())){
					UniAppManager.setToolbarButtons('save', true);
				}
			},
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
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
	});// End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					//20190731 임시 주석
//					combo.changeDivCode(combo, newValue, oldValue, eOpts);
//					var field = panelSearch.getField('SALE_PRSN');
//					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
					if(!Ext.isEmpty(newValue) && !Ext.isEmpty(panelSearch.getValue('SALE_DATE'))){
						UniSales.fnGetClosingInfo(
							UniAppManager.app.cbGetClosingInfo,
							newValue,
							"S",
							panelSearch.getField('SALE_DATE').getSubmitValue()
						);
					}
					if(CustomCodeInfo.gsCustCreditYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
						//여신액 구하기
						var divCode = newValue;
						var CustomCode = panelSearch.getValue('SALE_CUSTOM_CODE');
						var saleDate = panelSearch.getField('SALE_DATE').getSubmitValue()
						var moneyUnit = BsaCodeInfo.gsMoneyUnit;
						//마스터폼에 여신액 set
						UniAppManager.app.fnGetCustCredit(divCode, CustomCode, saleDate, moneyUnit);
					}
					panelSearch.setValue('DIV_CODE', newValue);
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
					panelSearch.setValue('BILL_NUM', newValue);
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
					if(!Ext.isEmpty(newValue && !Ext.isEmpty(panelSearch.getValue('DIV_CODE')))){
						UniSales.fnGetClosingInfo(
							UniAppManager.app.cbGetClosingInfo,
							panelSearch.getValue('DIV_CODE'),
							"S",
							UniDate.getDbDateStr(newValue
						));
					}
					if(CustomCodeInfo.gsCustCreditYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
						//여신액 구하기
						var divCode		= UserInfo.divCode;;
						var CustomCode	= panelSearch.getValue('SALE_CUSTOM_CODE');
						var saleDate	= UniDate.getDbDateStr(newValue);
						var moneyUnit	= BsaCodeInfo.gsMoneyUnit;
						//마스터폼에 여신액 set
						UniAppManager.app.fnGetCustCredit(divCode, CustomCode, saleDate, moneyUnit);
					}
					
					panelSearch.setValue('SALE_DATE', newValue);
					
					// 결제조건 값에 따른 결제 예정일 세팅
					fnControlPaymentDay(panelResult.getValue("PAYMENT_TERM"));
					UniAppManager.app.fnExchngRateO();
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxabletotalamount" default="과세총액"/>(1)',
			name		: 'TOT_SALE_TAX_O',
			id			: 'P_TOT_SALE_TAX_O',
			xtype		: 'uniNumberfield',
			value		: 0,
			readOnly	: true
		},{
			xtype	: 'container' ,
			layout	: {type:'hbox', align:'stretched'},
			width	: 200,
			style	: {'margin-left':'20px'},
			items	: [{
				xtype	: 'button',
				text	: '<t:message code="system.label.sales.salesslip" default="매출기표"/>',
				width	: 80,
				itemId	: 'btnCreate',
				hidden	: true,
				handler	: function() {
					var billNum = panelResult.getValue("BILL_NUM");
					if(billNum) {
						ssa100ukrvService.selectMaster(panelSearch.getValues(),function(responseText, response) {
							console.log("responseText : ",responseText);
							console.log("response : ",response);
							if(responseText && responseText.data) {
								var masterData = responseText.data;
								if(masterData.EX_NUM && masterData.EX_NUM != 0 ) {
									Unilite.messageBox('<t:message code="system.message.sales.datacheck010" default="이미 기표된 자료입니다."/>');
									return ;
								}
								var params = {
									'PGM_ID'		: 'ssa100ukrv',
									'sGubun'		: '30',
									'DIV_CODE'		: panelSearch.getValue("DIV_CODE"),
									'BILL_DATE'		: UniDate.getDateStr(panelSearch.getValue("SALE_DATE")),
									'CUSTOM_CODE'	: panelSearch.getValue("SALE_CUSTOM_CODE"),
									'BILL_TYPE'		: panelSearch.getValue("BILL_TYPE"),
									'BILL_PUB_NUM'	: panelSearch.getValue("BILL_NUM")
								}
								var rec = {data : {prgID : 'agj260ukr', 'text':''}};
								parent.openTab(rec, '/accnt/agj260ukr.do', params, CHOST+CPATH);
								panelResult.down("#btnCreate").hide();
								panelResult.down("#btnCancel").show();
							}
						});
					} else {
						Unilite.messageBox('<t:message code="system.message.sales.message074" default="매출번호가 없습니다. 조회 후 실행하세요."/>')
					}
				}
			},{
				xtype	: 'button',
				width	: 80,
				text	: '<t:message code="system.label.sales.slipcancel" default="기표취소"/>',
				itemId	: 'btnCancel',
				hidden	: true,
				handler	: function() {
					ssa100ukrvService.selectMaster(panelSearch.getValues(),function(responseText, response) {
						console.log("responseText : ",responseText);
						console.log("response : ",response);
						if(responseText && responseText.data) {
							var masterData = responseText.data;
							if(Ext.isEmpty(masterData.EX_NUM) || masterData.EX_NUM == 0 ) {
								Unilite.messageBox('<t:message code="system.message.sales.message076" default="먼저 자료를 조회하십시요."/>');
								return ;
							}
							var param = {
								'DIV_CODE'		: panelSearch.getValue("DIV_CODE"),
								'BILL_DATE'		: UniDate.getDateStr(panelSearch.getValue("SALE_DATE")),
								'CUSTOM_CODE'	: panelSearch.getValue("SALE_CUSTOM_CODE"),
								'BILL_TYPE'		: panelSearch.getValue("BILL_TYPE"),
								'BILL_PUB_NUM'	: panelSearch.getValue("BILL_NUM")
							}
							agj260ukrService.cancelAutoSlip30(param,function(responseText, response) {
								if(!Ext.isEmpty(responseText.ERROR_DESC) ) {
									if(responseText.EBYN_MESSAGE=="FALSE") {
										console.log(responseText.ERROR_DESC);
									}
								} else {
									Unilite.messageBox('<t:message code="system.message.sales.datacheck012" default="기표 취소되었습니다."/>');
									panelResult.down("#btnCreate").show();
									panelResult.down("#btnCancel").hide();
								}
							});
						} else {
							Unilite.messageBox('<t:message code="system.message.sales.message078" default="초기화중 오류가 발생하였습니다."/>');
						}
					});
				}
			}]
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'SALE_CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: true,
			allowBlank		: false,
			holdable		: 'hold',
			listeners		: {
				onSelected: {
					fn: function(records, type) {
//						var projectPopup = panelSearch.down('#project');
//						projectPopup.setExtParam({'CUSTOM_CODE':records[0]["CUSTOM_CODE"]});
						CustomCodeInfo.gsAgentType		= records[0]["AGENT_TYPE"];		//거래처분류
						CustomCodeInfo.gsCustCreditYn	= records[0]["CREDIT_YN"];
						CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"];	//원미만계산
						CustomCodeInfo.gsTaxCalType		= records[0]["TAX_CALC_TYPE"];
						CustomCodeInfo.gsRefTaxInout	= records[0]["TAX_TYPE"];		//세액포함여부
						salesOrderSearch.setValue('CUSTOM_CODE', panelSearch.getValue('SALE_CUSTOM_CODE'));//수주참조에 SET
						salesOrderSearch.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));//수주참조에 SET

						if(!Ext.isEmpty(records[0]["MONEY_UNIT"])){
							panelSearch.setValue('MONEY_UNIT', records[0]["MONEY_UNIT"]);
							panelResult.setValue('MONEY_UNIT', records[0]["MONEY_UNIT"]);
						}
						if(!Ext.isEmpty(records[0]["BUSI_PRSN"])){//20210728 거래처의 주영업담당자가 있으면 영업담당 다시 세팅
							panelSearch.setValue('SALE_PRSN', records[0]["BUSI_PRSN"]);
							panelResult.setValue('SALE_PRSN', records[0]["BUSI_PRSN"]);
//							var deptCode = UniAppManager.app.fnGetDeptCode(records[0]["BUSI_PRSN"]);	//영업담당의 부서 set
//							UniAppManager.app.fnSetDeptCodeName(deptCode);
						}
						if(!Ext.isEmpty(CustomCodeInfo.gsRefTaxInout)){
							panelSearch.setValue('TAX_TYPE', CustomCodeInfo.gsRefTaxInout)
							panelResult.setValue('TAX_TYPE', CustomCodeInfo.gsRefTaxInout)
						}
						if(CustomCodeInfo.gsCustCreditYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
							//여신액 구하기
							var divCode		= UserInfo.divCode;
							var CustomCode	= panelResult.getValue('SALE_CUSTOM_CODE');
							var saleDate	= panelSearch.getField('SALE_DATE').getSubmitValue()
							var moneyUnit	= BsaCodeInfo.gsMoneyUnit;
							//마스터폼에 여신액 set
							UniAppManager.app.fnGetCustCredit(divCode, CustomCode, saleDate, moneyUnit);
						}

						// 결제 조건
						if(!Ext.isEmpty(records[0]["RECEIPT_DAY"])){
							panelSearch.setValue('PAYMENT_TERM', records[0]["RECEIPT_DAY"]);
							panelResult.setValue('PAYMENT_TERM', records[0]["RECEIPT_DAY"]);
						}
						// 결제조건 값에 따른 결제 예정일 세팅
						fnControlPaymentDay(records[0]["RECEIPT_DAY"]);
						
						panelSearch.setValue('SALE_CUSTOM_CODE', panelResult.getValue('SALE_CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
//						panelSearch.setValue('TEX_CAR_TYPE', records[0]["TAX_CALC_TYPE"]);
						UniAppManager.app.fnExchngRateO();
					},
					scope: this
				},
				onClear: function(type) {
					CustomCodeInfo.gsAgentType		= '';
					CustomCodeInfo.gsCustCreditYn	= '';
					CustomCodeInfo.gsUnderCalBase	= '';
					CustomCodeInfo.gsTaxCalType		= '';
					CustomCodeInfo.gsRefTaxInout	= '';
					salesOrderSearch.setValue('CUSTOM_CODE'	, '');//수주참조에 SET
					salesOrderSearch.setValue('CUSTOM_NAME'	, '');//수주참조에 SET
					panelSearch.setValue('SALE_CUSTOM_CODE'	, '');
					panelSearch.setValue('CUSTOM_NAME'		, '');

					panelSearch.setValue('MONEY_UNIT'	, '');
					panelResult.setValue('MONEY_UNIT'	, '');
					panelSearch.setValue('EXCHG_RATE_O'	, 0);
					panelResult.setValue('EXCHG_RATE_O'	, 0);
//					panelSearch.setValue('TEX_CAR_TYPE'	, '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
			name		: 'ORDER_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S002',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_TYPE', newValue);
					//20200218 로직 추가
					var detailRecords = masterGrid.getStore().data.items;
					Ext.each(detailRecords, function(detailRecord, index) {
						detailRecord.set('REF_SALE_TYPE', newValue);
					});
					//20200629 추가: 판매유형에 따른 구매확인서번호 / 발급일자 show, hidden 설정
					fnControlPurchDocField(newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.vattype" default="부가세유형"/>',
			name		: 'BILL_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S024',
			value		: '10',
			allowBlank	: false,
			holdable	: '',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BILL_TYPE', newValue);
					//20200218 로직 추가
					if(newValue != '50'){
						var billType = '1'
					} else{
						var billType = '2'
					}
					var detailRecords = masterGrid.getStore().data.items;
					Ext.each(detailRecords, function(detailRecord, index) {
						detailRecord.set('TAX_TYPE'		, billType);
						detailRecord.set('REF_BILL_TYPE', newValue);
						detailRecord.set('SALE_AMT_O'	, detailRecord.get('SALE_Q')*detailRecord.get('SALE_P'));
						UniAppManager.app.fnOrderAmtCal(detailRecord, 'O','SALE_AMT_O', detailRecord.get('SALE_AMT_O'), billType);
						UniAppManager.app.fnCreditCheck(); //여신액 체크
					});

					// 20210222 : 카드매출인 경우 readonly 비활성
					if('40' == newValue){
						panelSearch.getField('CARD_CUSTOM_CODE').setReadOnly(false);
						panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(false);
					} else {
						panelResult.setValue('CARD_CUSTOM_CODE', '');
						panelSearch.getField('CARD_CUSTOM_CODE').setReadOnly(true);
						panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(true);
					}
				}
			}
		}, {
			fieldLabel	: '<t:message code="system.label.sales.taxexemptiontotalamount" default="면세총액"/>(2)',
			name		: 'TOT_SALE_EXP_O',
			id			: 'P_TOT_SALE_EXP_O',
			xtype		: 'uniNumberfield',
			value		: 0,
			colspan		: 1,					//20200629 수정: 구매확인서 번호 필드 추가로 colspan 변경
			readOnly	: true
		},{	//20200629 추가: 구매확인서 번호(SSA100T.PURCH_DOC_NO)
			xtype	: 'container' ,
			layout	: {type:'hbox'},
			width	: 300,
			items	: [{
				fieldLabel	: '<t:message code="system.label.sales.purchasedocumentno" default="구매확인서번호"/>',
				xtype		: 'uniTextfield',
				name		: 'PURCH_DOC_NO',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('PURCH_DOC_NO', newValue);
					}
				}
			}]
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SALE_PRSN', newValue);
//					var deptCode = UniAppManager.app.fnGetDeptCode(newValue);	//영업담당의 부서 set
//					UniAppManager.app.fnSetDeptCodeName(deptCode);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>',
			name		: 'TAX_TYPE',
			xtype		: 'uniRadiogroup',
			comboType	: 'AU',
			comboCode	: 'B030',
			width		: 235,
			value		: '1',
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TAX_TYPE',newValue.TAX_TYPE);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.base.taxtype" default="세구분"/>' ,
			name		: 'TAX_TYPE2',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B059',
			holdable	: 'hold',
			allowBlank	: true,
			fieldStyle	: 'text-align: center;',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TAX_TYPE2', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxsmalltotalamount" default="영세총액"/>(3)',
			name		: 'TOT_SALE_ZERO_O',
			id			: 'P_TOT_SALE_ZERO_O',
			xtype		: 'uniNumberfield',
			value		: 0,
			colspan		: 1,					//20200629 수정: 발급일자 필드 추가로 colspan 변경
			readOnly	: true
		},{	//20200629 추가: 발급일자(SSA100T.ISSUE_DATE)
			xtype	: 'container' ,
			layout	: {type:'hbox'},
			width	: 300,
			items	: [{
				fieldLabel	: '<t:message code="system.label.sales.issuedate2" default="발급일자"/>',
				xtype		: 'uniDatefield',
				name		: 'ISSUE_DATE',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ISSUE_DATE', newValue);
					}
				}
			}]
		},{
			fieldLabel	: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>',
			name		: 'MONEY_UNIT',
			xtype		: 'uniCombobox',		//화폐단위
			comboType	: 'AU',
			comboCode	: 'B004',
			allowBlank	: false,
			holdable	: 'hold',
			value		: BsaCodeInfo.gsMoneyUnit,
			displayField: 'value',
			fieldStyle	: 'text-align: center;',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('MONEY_UNIT', newValue);
					if(newValue != BsaCodeInfo.gsMoneyUnit){
						var length = Ext.isEmpty(UniFormat.FC.split('.')[1]) ? 0 : UniFormat.FC.split('.')[1].length;
						Ext.getCmp('P_TOT_SALE_TAX_O').setConfig('decimalPrecision',length);
						Ext.getCmp('P_TOT_SALE_TAX_O').focus();
						Ext.getCmp('P_TOT_SALE_TAX_O').blur();

						Ext.getCmp('P_TOT_TAX_AMT').setConfig('decimalPrecision',length);
						Ext.getCmp('P_TOT_TAX_AMT').focus();
						Ext.getCmp('P_TOT_TAX_AMT').blur();

						Ext.getCmp('P_TOT_SALE_EXP_O').setConfig('decimalPrecision',length);
						Ext.getCmp('P_TOT_SALE_EXP_O').focus();
						Ext.getCmp('P_TOT_SALE_EXP_O').blur();

						Ext.getCmp('P_TOT_AMT').setConfig('decimalPrecision',length);
						Ext.getCmp('P_TOT_AMT').focus();
						Ext.getCmp('P_TOT_AMT').blur();

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

						Ext.getCmp('M_TOT_SALE_ZERO_O').setConfig('decimalPrecision',length);
						Ext.getCmp('M_TOT_SALE_ZERO_O').focus();
						Ext.getCmp('M_TOT_SALE_ZERO_O').blur();

						Ext.getCmp('M_TOT_SALE_SUPPLY_O').setConfig('decimalPrecision',length);
						Ext.getCmp('M_TOT_SALE_SUPPLY_O').focus();
						Ext.getCmp('M_TOT_SALE_SUPPLY_O').blur();

						//masterGrid.getColumn("SALE_P").setConfig('format',UniFormat.FC);
						//masterGrid.getColumn("SALE_P").setConfig('decimalPrecision',length);
						masterGrid.getColumn("SALE_AMT_O").setConfig('format',UniFormat.FC);
						masterGrid.getColumn("SALE_AMT_O").setConfig('decimalPrecision',length);
						masterGrid.getColumn("TAX_AMT_O").setConfig('format',UniFormat.FC);
						masterGrid.getColumn("TAX_AMT_O").setConfig('decimalPrecision',length);
						masterGrid.getColumn("ORDER_O_TAX_O").setConfig('format',UniFormat.FC);
						masterGrid.getColumn("ORDER_O_TAX_O").setConfig('decimalPrecision',length);
						masterGrid.getColumn("SALE_LOC_AMT_I").setConfig('format',UniFormat.FC);
						masterGrid.getColumn("SALE_LOC_AMT_I").setConfig('decimalPrecision',length);

					} else{
						var length = Ext.isEmpty(UniFormat.Price.split('.')[1]) ? 0 : UniFormat.Price.split('.')[1].length;
						Ext.getCmp('P_TOT_SALE_TAX_O').setConfig('decimalPrecision',length);
						Ext.getCmp('P_TOT_SALE_TAX_O').focus();
						Ext.getCmp('P_TOT_SALE_TAX_O').blur();

						Ext.getCmp('P_TOT_TAX_AMT').setConfig('decimalPrecision',length);
						Ext.getCmp('P_TOT_TAX_AMT').focus();
						Ext.getCmp('P_TOT_TAX_AMT').blur();

						Ext.getCmp('P_TOT_SALE_EXP_O').setConfig('decimalPrecision',length);
						Ext.getCmp('P_TOT_SALE_EXP_O').focus();
						Ext.getCmp('P_TOT_SALE_EXP_O').blur();

						Ext.getCmp('P_TOT_AMT').setConfig('decimalPrecision',length);
						Ext.getCmp('P_TOT_AMT').focus();
						Ext.getCmp('P_TOT_AMT').blur();

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

						Ext.getCmp('M_TOT_SALE_ZERO_O').setConfig('decimalPrecision',length);
						Ext.getCmp('M_TOT_SALE_ZERO_O').focus();
						Ext.getCmp('M_TOT_SALE_ZERO_O').blur();

						Ext.getCmp('M_TOT_SALE_SUPPLY_O').setConfig('decimalPrecision',length);
						Ext.getCmp('M_TOT_SALE_SUPPLY_O').focus();
						Ext.getCmp('M_TOT_SALE_SUPPLY_O').blur();

						//masterGrid.getColumn("SALE_P").setConfig('format',UniFormat.Price);
						//masterGrid.getColumn("SALE_P").setConfig('decimalPrecision',length);
						masterGrid.getColumn("SALE_AMT_O").setConfig('format',UniFormat.Price);
						masterGrid.getColumn("SALE_AMT_O").setConfig('decimalPrecision',length);
						masterGrid.getColumn("TAX_AMT_O").setConfig('format',UniFormat.Price);
						masterGrid.getColumn("TAX_AMT_O").setConfig('decimalPrecision',length);
						masterGrid.getColumn("ORDER_O_TAX_O").setConfig('format',UniFormat.Price);
						masterGrid.getColumn("ORDER_O_TAX_O").setConfig('decimalPrecision',length);
						masterGrid.getColumn("SALE_LOC_AMT_I").setConfig('format',UniFormat.Price);
						masterGrid.getColumn("SALE_LOC_AMT_I").setConfig('decimalPrecision',length);
					}
					if(isLoad){
						isLoad = false;
					} else{
						UniAppManager.app.fnExchngRateO();
					}
				}
			}
		},{
			xtype		: 'uniNumberfield',
			fieldLabel	: '<t:message code="system.label.sales.exchangerate" default="환율"/>',
			name		: 'EXCHG_RATE_O',		//환율,
			type		: 'uniER',
			holdable	: 'hold',
			decimalPrecision: 4,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('EXCHG_RATE_O', newValue);
				}
			}
		},
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			textFieldWidth	: 150,
			validateBlank	: true,
			textFieldName	: 'PROJECT_NO',
			itemId			: 'project',
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('PROJECT_NO'		, records[0]["PJT_CODE"]);
						panelResult.setValue('SALE_CUSTOM_CODE'	, records[0]["CUSTOM_CODE"]);
						panelResult.setValue('CUSTOM_NAME'		, records[0]["CUSTOM_NAME"]);
						panelSearch.setValue('PROJECT_NO'		, records[0]["PJT_CODE"]);
						panelSearch.setValue('SALE_CUSTOM_CODE'	, records[0]["CUSTOM_CODE"]);
						panelSearch.setValue('CUSTOM_NAME'		, records[0]["CUSTOM_NAME"]);
						//20200103 추가
						panelSearch.setValue('PJT_NAME'			, records[0]["PJT_NAME"]);
					},
					scope: this
				},
				onClear: function(type) {
					panelResult.setValue('PROJECT_NO'		, '');
					panelResult.setValue('SALE_CUSTOM_CODE'	, '');
					panelResult.setValue('CUSTOM_NAME'		, '');
					panelSearch.setValue('PROJECT_NO'		, '');
					panelSearch.setValue('SALE_CUSTOM_CODE'	, '');
					panelSearch.setValue('CUSTOM_NAME'		, '');
					//20200103 추가
					panelSearch.setValue('PJT_NAME'			, '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'BPARAM0'	: 3});
					popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('SALE_CUSTOM_CODE')});
				},
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PROJECT_NO', newValue);
				}
			}
		}),{
			xtype		: 'uniNumberfield',
			fieldLabel	: 'EXCHG_AMT_I',
			name		: 'EXCHG_AMT_I',		//환산액
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('EXCHG_AMT_I', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>(4)',
			name		: 'TOT_SALE_SUPPLY_O',
			id			: 'P_TOT_SALE_SUPPLY_O',
			xtype		: 'uniNumberfield',
			value		: 0,
			colspan		: 1,
			readOnly	: true
		},{
			xtype:'label',
			padding:'0 0 0 10',
			hidden: false,
			text:'(1) + (2) + (3)'
		},{
			fieldLabel	: '<t:message code="system.label.sales.paycondition" default="결제조건"/>',
			name		: 'PAYMENT_TERM',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B034',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					
					// 결제조건 값에 따른 결제 예정일 세팅
					fnControlPaymentDay(newValue);
					panelSearch.setValue('PAYMENT_TERM',newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.paymentday" default="결제예정일"/>',
			xtype		: 'uniDatefield',
			name		: 'PAYMENT_DAY',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PAYMENT_DAY',newValue);
				}
			}
		},{
			// 20210222 : 카드사(CARD_CUSTOM_CODE) 추가
			fieldLabel	: '<t:message code="system.label.sales.cardcustomnm" default="카드사"/>' ,
			name		: 'CARD_CUSTOM_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A028',
			allowBlank	: true,
			readOnly    : true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CARD_CUSTOM_CODE',newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxtotalamount" default="세액합계"/>(5)',
			name		: 'TOT_TAX_AMT',
			id			: 'P_TOT_TAX_AMT',
			xtype		: 'uniNumberfield',
			value		: 0,
			colspan		: 2,
			readOnly	: true
		},{	fieldLabel	: '<t:message code="system.label.sales.remarks" default="비고"/>',
			xtype		: 'textareafield',
			name		: 'REMARK',
			width		: 820,
			grow		: true,
			height		: 50,
			colspan		: 3,
			rowspan		: 2,
			layout		: {type : 'uniTable', columns : 3},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('REMARK', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.amountofsupply" default="공급대가"/>(6)',
			name		: 'TOT_AMT',
			id			: 'P_TOT_AMT',
			xtype		: 'uniNumberfield',
			value		: 0,
			colspan		: 1,
			margin		: '-27 0 0 0',
			readOnly	: true
		},{
			xtype	: 'container' ,
			margin	: '-27 0 0 0',
			layout	: {type : 'uniTable', columns : 1},
			items	: [{
				xtype		: 'label',
				padding		: '0 0 0 10',
				hidden		: false,
				colspan		: 1,
				text		: '(4) + (5)'
			}]
		}],
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
				if(gsSaveRefFlag == "Y"
				&& (basicForm.getField('REMARK').isDirty() || basicForm.getField('PROJECT_NO').isDirty() || basicForm.getField('SALE_PRSN').isDirty()
				    || basicForm.getField('CARD_CUSTOM_CODE').isDirty()|| basicForm.getField('PAYMENT_TERM').isDirty()|| basicForm.getField('PAYMENT_DAY').isDirty())){
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
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});



	//마스터 모델
	Unilite.defineModel('Ssa101ukrvModel', {
		fields: [
			{name: 'BILL_SEQ'			, text: '<t:message code="system.label.sales.seq" default="순번"/>'						, type: 'int', allowBlank: false},
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'				, type: 'string', comboType: 'AU', comboCode: 'S007', allowBlank: false},
			{name: 'OUT_DIV_CODE'		, text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'			, type: 'string', comboType: 'BOR120', allowBlank: false, child: 'WH_CODE'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'			, type: 'string', comboType: 'OU', allowBlank: false, parentNames:['OUT_DIV_CODE']},
			{name: 'WH_CELL_CODE'		, text: '<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>'	, type: 'string', store: Ext.data.StoreManager.lookup('whCellList')},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'						, type: 'string'},
			{name: 'SALE_UNIT'			, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'				, type: 'string',comboType:'AU', comboCode: 'B013', allowBlank: false, displayField: 'value'},
			{name: 'TRANS_RATE'			, text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				, type: 'uniQty', defaultValue: '1', allowBlank: false},
			{name: 'SALE_Q'				, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'					, type: 'uniQty', defaultValue: '0'},
			{name: 'SALE_P'				, text: '<t:message code="system.label.sales.price" default="단가"/>'						, type: 'uniUnitPrice', defaultValue: '0'},
			/* 매출등록(중량, 부피포함용)
			{name: 'PRICE_TYPE'			, text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string'},
			{name: 'SALE_WGT_Q'			, text: '매출량(중량)'				, type: 'uniQty'},
			{name: 'SALE_FOR_WGT_P'		, text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'			, type: 'uniUnitPrice'},
			{name: 'SALE_VOL_Q'			, text: '매출량(부피)'				, type: 'uniQty'},
			{name: 'SALE_FOR_VOL_P'		, text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'			, type: 'uniUnitPrice'},
			{name: 'SALE_WGT_P'			, text: '<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.weight" default="중량"/>)'			, type: 'uniQty'},
			{name: 'SALE_VOL_P'			, text: '<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'			, type: 'uniUnitPrice'},
			{name: 'WGT_UNIT'			, text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'				, type: 'string'},
			{name: 'UNIT_WGT'			, text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>'				, type: 'uniQty'},
			{name: 'VOL_UNIT'			, text: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>'				, type: 'string'},
			{name: 'UNIT_VOL'			, text: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'				, type: 'string'},
			*/
			{name: 'SALE_AMT_O'			, text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'			, type: 'uniFC', defaultValue: '0'/*, allowBlank: false*//* 20200110 저장로직에서 체크하도록 변경 */},
			{name: 'TAX_TYPE'			, text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'			, type: 'string',comboType:'AU', comboCode: 'B059', allowBlank: false},
			{name: 'TAX_AMT_O'			, text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'				, type: 'uniPrice', defaultValue: '0', allowBlank: true},
			{name: 'ORDER_O_TAX_O'		, text: '<t:message code="system.label.sales.salestotal" default="매출계"/>'				, type: 'uniPrice', defaultValue: '0', editable: false},
			{name: 'DISCOUNT_RATE'		, text: '<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'			, type: 'uniPercent', defaultValue: '0'},
			{name: 'STOCK_Q'			, text: '<t:message code="system.label.sales.inventoryqty" default="재고량"/>'				, type: 'uniQty', defaultValue: '0', editable: false},
			{name: 'DVRY_CUST_CD'		, text: '<t:message code="system.label.sales.deliveryplacecode" default="배송처코드"/>'		, type: 'string'},
			{name: 'DVRY_CUST_NAME'		, text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			, type: 'string'},
			{name: 'WARR_MONTH'			, text: '<t:message code="system.label.sales.warranty" default="보증기간"/>'					, type: 'string',comboType:'AU', comboCode: 'S166' },
			{name: 'PRICE_YN'			, text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string' , defaultValue: '2',comboType:'AU', comboCode: 'S003', allowBlank: false},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.sales.lotno" default="LOT NO"/>'					, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'					, type: 'string'},
			{name: 'INOUT_SEQ'			, text: '<t:message code="system.label.sales.issueseq" default="출고순번"/>'				, type: 'int'},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'				, type: 'uniDate', allowBlank: true},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'					, type: 'string'},
			{name: 'PUB_NUM'			, text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'					, type: 'string'},

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
			{name: 'REF_SALE_PRSN'		, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'				, type: 'string',comboType:'AU', comboCode: 'S010'},
			{name: 'REF_CUSTOM_CODE'	, text: 'REF_CUSTOM_CODE'		, type: 'string'},
			{name: 'REF_SALE_DATE'		, text: 'REF_SALE_DATE'			, type: 'uniDate'},
			{name: 'REF_BILL_TYPE'		, text: 'REF_BILL_TYPE'			, type: 'string'},
			{name: 'REF_CARD_CUST_CD'	, text: 'REF_CARD_CUST_CD'		, type: 'string'},
			{name: 'REF_SALE_TYPE'		, text: 'REF_SALE_TYPE'			, type: 'string'},
			{name: 'REF_PROJECT_NO'		, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
			//20200103 프로젝트명 추가
			{name: 'PJT_NAME'			, text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>'				, type: 'string', editable: false},
			{name: 'REF_TAX_INOUT'		, text: 'REF_TAX_INOUT'			, type: 'string'},
			{name: 'REF_REMARK'			, text: '<t:message code="system.label.sales.remarks" default="비고"/>'					, type: 'string'},
			{name: 'REF_EX_NUM'			, text: 'REF_EX_NUM'			, type: 'string'},
			{name: 'REF_MONEY_UNIT'		, text: 'REF_MONEY_UNIT'		, type: 'string'},
			{name: 'REF_EXCHG_RATE_O'	, text: 'REF_EXCHG_RATE_O'		, type: 'uniER'},
			{name: 'STOCK_CARE_YN'		, text: 'STOCK_CARE_YN'			, type: 'string'},
			{name: 'UNSALE_Q'			, text: 'UNSALE_Q'				, type: 'string', defaultValue: '0'},
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'		, type: 'string', defaultValue: UserInfo.userID},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'		, type: 'string'},
			{name: 'DATA_REF_FLAG'		, text: 'DATA_REF_FLAG'			, type: 'string', defaultValue: 'F'},
			{name: 'SRC_CUSTOM_CODE'	, text: 'SRC_CUSTOM_CODE'		, type: 'string'},
			{name: 'SRC_CUSTOM_NAME'	, text: 'SRC_CUSTOM_NAME'		, type: 'string'},
			{name: 'SRC_ORDER_PRSN'		, text: 'SRC_ORDER_PRSN'		, type: 'string'},
			{name: 'REF_CODE2'			, text: 'REF_CODE2'				, type: 'string'},
			{name: 'SOF110T_ACCOUNT_YNC', text: 'SOF110T_ACCOUNT_YNC'	, type: 'string'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'				, type: 'string', allowBlank: false},
			{name: 'INOUT_CUSTOM_CODE'	, text: 'INOUT_CUSTOM_CODE'		, type: 'string'},
			{name: 'INOUT_CUSTOM_NAME'	, text: 'INOUT_CUSTOM_NAME'		, type: 'string'},
			{name: 'INOUT_AGENT_TYPE'	, text: 'INOUT_AGENT_TYPE'		, type: 'string'},
			{name: 'ADVAN_YN'			, text: 'ADVAN_YN'				, type: 'string'},
			{name: 'GUBUN'				, text: 'GUBUN'					, type: 'string'},
			// 20210222 : 카드사(CARD_CUSTOM_CODE) 추가
			{name: 'CARD_CUSTOM_CODE'	, text: '<t:message code="system.label.sales.cardcustomnm" default="카드사"/>'				, type: 'string'}
		]
	});

	//마스터 스토어 정의
	var detailStore = Unilite.createStore('ssa101ukrvDetailStore', {
		model	: 'Ssa101ukrvModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,	// 상위 버튼 연결
			editable	: true,	// 수정 모드 사용
			deletable	: true,	// 삭제 가능 여부
			allDeletable: true,	// 전체 삭제 가능 여부
			useNavi		: false	// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
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
			var billNum = panelSearch.getValue('BILL_NUM');

			Ext.each(list, function(record, index) {
				if(record.data['BILL_NUM'] != billNum) {
					record.set('BILL_NUM', billNum);
				}
				if(record.data['INOUT_TYPE_DETAIL'] != 'AU') {
					//20200120 수정: <= -> ==로 수정
					if( (!Ext.isEmpty(record.data['SALE_P']) || !Ext.isEmpty(record.data['SALE_Q'])) && record.data['SALE_P'] == 0 && record.data['SALE_Q'] == 0 ){
						Unilite.messageBox('<t:message code="system.message.sales.message075" default="매출수량, 단가 가 필수 항목입나다."/>');
						checkPass = false;
						return false;
					} else{
						checkPass = true;
					}
				}
				//20200110 로직 추가
				if(record.get('ACCOUNT_YNC') == 'Y') {
					if(record.data['INOUT_TYPE_DETAIL'] != 'AU') {
						if(Ext.isEmpty(record.get('SALE_P')) || record.get('SALE_P') == 0){
							Unilite.messageBox((index + 1) + '<t:message code="system.message.sales.message060" default="행의 입력값을 확인해 주세요."/>\n' + '<t:message code="system.message.sales.message071" default="매출대상은 단가가 필수 입력값 입니다."/>');
							checkPass = false;
							return false;
						}
					}

					if(Ext.isEmpty(record.get('SALE_AMT_O')) || record.get('SALE_AMT_O') == 0){
						Unilite.messageBox((index + 1) + '<t:message code="system.message.sales.message060" default="행의 입력값을 확인해 주세요."/>\n' + '<t:message code="system.message.sales.message072" default="매출대상은 금액이 필수 입력값 입니다."/>');
						checkPass = false;
						return false;
					}
				}
			});

			// 1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	// syncAll 수정
			paramMaster.SALE_AMT_O		= panelSearch.getValue('TOT_SALE_TAX_O') + panelSearch.getValue('TOT_SALE_EXP_O'); //과세총액+면세총액
			paramMaster.UPDATE_DB_USER	= UserInfo.userID;
			paramMaster.VAT_RATE		= parseInt(BsaCodeInfo.gsVatRate);
			paramMaster.AGENT_TYPE		= CustomCodeInfo.gsAgentType;

			if((inValidRecs.length == 0) && checkPass) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						// 2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						panelSearch.setValue("BILL_NUM", master.BILL_NUM);
						panelResult.setValue("BILL_NUM", master.BILL_NUM);

						// 3.기타 처리
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						//20200511 추가: 신규 저장 후 엑셀다운로드를 위해 조회로직 수행
						UniAppManager.app.onQueryButtonDown();
						if(detailStore.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}
						UniAppManager.app.fnExSlipBtn();
					}
				};
				this.syncAllDirect(config);
				checkPass = true;
			} else {
				var grid = Ext.getCmp('ssa100ukrvGrid');
				if(!Ext.isEmpty(inValidRecs)){
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);}
				// Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				this.fnSaleAmtSum2();
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
		fnSaleAmtSum: function(newValue) {
			var dSaleTI			= 0;
			var dSaleNTI		= 0;
			var dTaxI			= 0;
			var dTotalAmt		= 0;
			var dTaxAmtO		= 0;
			var dZeroTI			= 0;//영세금액
			/*20201023 변수 신규 추가*/
			var dSumAmountTot	= 0;
			var dSumAmountI		= 0;
			var dSaleTiTot		= 0;

			var results = this.sumBy(function(record, id){
										return record.get('TAX_TYPE') == '1';},
									['SALE_AMT_O','TAX_AMT_O']);
			dSaleTI		= results.SALE_AMT_O;
			dTaxI		= results.TAX_AMT_O;
			dSaleTiTot	= results.SALE_AMT_O //+ results.TAX_AMT_O;	//20210217 주석

			var results = this.sumBy(function(record, id){
										return record.get('TAX_TYPE') == '2';},
									['SALE_AMT_O']);
			dSaleNTI = results.SALE_AMT_O;

			/*2020.03.06 영세금액 계산***************/
			var results = this.sumBy(function(record, id){
										return record.get('TAX_TYPE') == '3';},
								['SALE_AMT_O']);
			dZeroTI = results.SALE_AMT_O;
			/**********************************/

			dTaxAmtO = dTaxI ;
			panelSearch.setValue('TOT_SALE_TAX_O', dSaleTiTot);	// 과세총액(1)
			panelSearch.setValue('TOT_SALE_EXP_O', dSaleNTI);	// 면세총액(2)
			panelResult.setValue('TOT_SALE_TAX_O', dSaleTiTot);	// 과세총액(1)
			panelResult.setValue('TOT_SALE_EXP_O', dSaleNTI);	// 면세총액(2)

			var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
			if(CustomCodeInfo.gsTaxCalType == "1"){//통합
				dTaxAmtO = 0;
				//dTaxAmtO = UniSales.fnAmtWonCalc(dSaleTI * (BsaCodeInfo.gsVatRate / 100), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice)

				if(CustomCodeInfo.gsRefTaxInout == '1'){//세액 포함 여부가 별도일 경우
					dSaleTI = Math.round(dSaleTI,0);
					dTax = dSaleTI * (BsaCodeInfo.gsVatRate / 100);
					dSumAmountI = dSaleTI;
					Math.round(dTax,0);
					//20200311 부가세 계산시에는 소수점 관련 처리는 필요하지 않음
					dTaxAmtO = fnVatCalc2(dTax, CustomCodeInfo.gsUnderCalBase, 0)
				} else {									//세액 포함 여부가  포함인 경우
					dTemp = Math.round(dSaleTI / ( BsaCodeInfo.gsVatRate + 100 ) * 100,0);
					//20190821 fnAmtWonCalc 기능은 자동 버림처리.. round로 변경.
					//dTemp = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '2');	//UniMatrl	??
					dTax  =	dSaleTI - dTemp;
					Math.round(dTax,0);
					dTemp = dSaleTI - dTax;
					Math.round(dTemp,0);
					dSaleTI = Math.round(dTemp,0);
					dSumAmountTot = dSaleTI;

					//20200311 부가세 계산시에는 소수점 관련 처리는 필요하지 않음
					dTaxAmtO = fnVatCalc2(dTax, CustomCodeInfo.gsUnderCalBase, 0)

				}
				panelSearch.setValue('TOT_TAX_AMT', dTaxAmtO); //세액합계(2)
				panelResult.setValue('TOT_TAX_AMT', dTaxAmtO); //세액합계(2)
			} else{								//개별
				panelSearch.setValue('TOT_TAX_AMT', dTaxAmtO); //세액합계(2)
				panelResult.setValue('TOT_TAX_AMT', dTaxAmtO); //세액합계(2)
			}


			/*2020.03.06 영세총액(3)**********************************************/
			panelSearch.setValue('TOT_SALE_ZERO_O', dZeroTI);
			panelResult.setValue('TOT_SALE_ZERO_O', dZeroTI);
			panelSearch.setValue('TOT_SALE_SUPPLY_O', dSaleTI + dSaleNTI + dZeroTI);//공급가액(4)
			panelResult.setValue('TOT_SALE_SUPPLY_O', dSaleTI + dSaleNTI + dZeroTI);
			/*****************************************************************/




			dTotalAmt = dSaleTI + dSaleNTI + dZeroTI + dTaxAmtO; //2020.03.06 영세금액 계산 추가
			panelSearch.setValue('TOT_AMT', dTotalAmt); //총액[(1)+(2)+(3)]
			panelSearch.setValue('EXCHG_AMT_I', dTotalAmt); //환산액
			panelResult.setValue('TOT_AMT', dTotalAmt); //총액[(1)+(2)+(3)]
			panelResult.setValue('EXCHG_AMT_I', dTotalAmt); //환산액
//			this.clearFilter();
		},
		fnSaleAmtSum2: function(newValue) {	//여신액 체크 빠진 로직
			var dSaleTI	= 0;
			var dSaleNTI	= 0;
			var dTaxI		= 0;
			var dTotalAmt	= 0;
			var dTaxAmtO	= 0;
			var dZeroTI	= 0;   //영세금액
			/*20201023 변수 신규 추가*/
			var dSumAmountTot	= 0;
			var dSumAmountI		= 0;
			var dSaleTiTot = 0;
			var results = this.sumBy(function(record, id){
										return record.get('TAX_TYPE') == '1';},
									['SALE_AMT_O','TAX_AMT_O']);
			dSaleTI = results.SALE_AMT_O;
			dTaxI	= results.TAX_AMT_O;
			dSaleTiTot = results.SALE_AMT_O + results.TAX_AMT_O;

			var results = this.sumBy(function(record, id){
										return record.get('TAX_TYPE') == '2';},
									['SALE_AMT_O']);
			dSaleNTI = results.SALE_AMT_O;

			/*2020.03.06 영세금액 계산***************/
			var results = this.sumBy(function(record, id){
										return record.get('TAX_TYPE') == '3';},
								['SALE_AMT_O']);
			dZeroTI = results.SALE_AMT_O;
			/**********************************/

			dTaxAmtO = dTaxI
			panelSearch.setValue('TOT_SALE_TAX_O', dSaleTiTot); // 과세총액(1)
			panelSearch.setValue('TOT_SALE_EXP_O', dSaleNTI); // 면세총액(3)
			panelResult.setValue('TOT_SALE_TAX_O', dSaleTiTot); // 과세총액(1)
			panelResult.setValue('TOT_SALE_EXP_O', dSaleNTI); // 면세총액(3)

			var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
			if(CustomCodeInfo.gsTaxCalType == "1"){//통합
				dTaxAmtO = 0;
				if(CustomCodeInfo.gsRefTaxInout == '1'){//세액 포함 여부가 별도일 경우
					dSaleTI = Math.round(dSaleTI,0);
					dTax = dSaleTI * (BsaCodeInfo.gsVatRate / 100);
					dTax = fnVatCalc2(dTax, CustomCodeInfo.gsUnderCalBase, 0);
					dTaxAmtO = dTax;
					dSumAmountI = dSaleTI;
					//Math.round(dTax,0);
					//20200311 부가세 계산시에는 소수점 관련 처리는 필요하지 않음

				} else {									//세액 포함 여부가  포함인 경우
					dTemp = Math.round(dSaleTI / ( BsaCodeInfo.gsVatRate + 100 ) * 100,0);
					//20190821 fnAmtWonCalc 기능은 자동 버림처리.. round로 변경.
					//dTemp = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '2');	//UniMatrl	??
					dTax  =	dSaleTI - dTemp;
					dTax  = fnVatCalc2(dTax, CustomCodeInfo.gsUnderCalBase, 0);
					dTaxAmtO = dTax;
					//Math.round(dTax,0);
					dTemp = dSaleTI - dTax;
					dSaleTI = Math.round(dTemp,0);
					dSumAmountTot = dSaleTI;
					//20200311 부가세 계산시에는 소수점 관련 처리는 필요하지 않음


				}
				//dTaxAmtO = UniSales.fnAmtWonCalc(dSaleTI * (BsaCodeInfo.gsVatRate / 100), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice)
				//20200311 부가세 계산시에는 소수점 관련 처리는 필요하지 않음
				//dTaxAmtO = fnVatCalc2(dSaleTI * (BsaCodeInfo.gsVatRate / 100), CustomCodeInfo.gsUnderCalBase, 0)
				panelSearch.setValue('TOT_TAX_AMT', dTaxAmtO); //세액합계(2)
				panelResult.setValue('TOT_TAX_AMT', dTaxAmtO); //세액합계(2)
			} else{								//개별
				panelSearch.setValue('TOT_TAX_AMT', dTaxAmtO); //세액합계(2)
				panelResult.setValue('TOT_TAX_AMT', dTaxAmtO); //세액합계(2)
			}

			/*2020.03.06 영세총액(3)**********************************************/
			panelSearch.setValue('TOT_SALE_ZERO_O', dZeroTI);
			panelResult.setValue('TOT_SALE_ZERO_O', dZeroTI);
			panelSearch.setValue('TOT_SALE_SUPPLY_O', dSaleTI + dSaleNTI + dZeroTI);//공급가액(4)
			panelResult.setValue('TOT_SALE_SUPPLY_O', dSaleTI + dSaleNTI + dZeroTI);
			/*****************************************************************/



			dTotalAmt = dSaleTI + dSaleNTI + dZeroTI +  dTaxAmtO;
			panelSearch.setValue('TOT_AMT', dTotalAmt); //총액[(1)+(2)+(3)]
			panelResult.setValue('TOT_AMT', dTotalAmt); //총액[(1)+(2)+(3)]
			panelSearch.setValue('EXCHG_AMT_I', dTotalAmt); //환산액
			panelResult.setValue('EXCHG_AMT_I', dTotalAmt); //환산액
//			UniAppManager.app.fnCreditCheck(); //여신액 체크
//			this.clearFilter();
		}
	});

	//마스터 그리드
	var masterGrid = Unilite.createGrid('ssa100ukrvGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false,
			copiedRow			: true
		},
		tbar	: [{
			itemId	: 'salesOrderBtn',
			text	: '<div style="color: blue"><t:message code="system.label.sales.sorefer" default="수주참조"/></div>',
			handler	: function() {
				openSalesOrderWindow();
			}
		},{
			itemId	: 'issueBtn',
			text	: '<div style="color: blue"><t:message code="system.label.sales.issuereturnrefer" default="출고(미매출)/반품출고참조"/></div>',
			handler	: function() {
				openIssueWindow();
			}
		},{
			itemId	: 'previousSalesOrderBtn',
			text	: '<div style="color: blue"><t:message code="system.label.sales.advancesorefer" default="수주참조(선매출)"/></div>',
			hidden	: isAdvanUseYN,
			handler	: function() {
				openPreviousSalesOrderWindow();
			}
		},{
			itemId: 'eachtaxLinkBtn',
			text: '<t:message code="system.label.sales.eachtaxstatemententry" default="개별세금계산서등록"/>',
			handler: function() {
				if(detailStore.isDirty()){
					Unilite.messageBox('<t:message code="system.message.sales.message032" default="저장작업 선행후 처리하시기 바랍니다."/>');
					return false;
				}

				if(detailStore.getCount() != 0){
					var iselTaxtype = "";
					var ipubNumcnt = 0;
					var ipriceYNcnt = 0;

					var record = detailStore.data.items;

					Ext.each(record, function(rec,i){
//						if(rec.get('PUB_NUM') == "" && rec.get('PRICE_YN') == "2" && iselTaxtype == ""){
// 2021-01-05 PM요청으로 단가여부(진단가여부)체크 조건 추석처리(에이치섧퍼)
						if(rec.get('PUB_NUM') == "" && iselTaxtype == ""){
							iselTaxtype = rec.get('TAX_TYPE');
						}else{
								if(!Ext.isEmpty(rec.get('PUB_NUM'))){
									ipubNumcnt = ipubNumcnt + 1;
								}
								if(rec.get('PRICE_YN') == "1"){
									ipriceYNcnt = ipriceYNcnt + 1;
								}

						}
					});

					var sendCnt = 0;
				    data = new Object();
				    data.records = [];
					Ext.each(record, function(rec,i){
//						if(rec.get('PUB_NUM') == "" && rec.get('PRICE_YN') == "2" && rec.get('TAX_TYPE') == iselTaxtype && rec.get('SALE_AMT_O')!= "0"){
// 2021-01-05 PM요청으로 단가여부(진단가여부)체크 조건 추석처리(에이치섧퍼)
						if(rec.get('PUB_NUM') == "" && rec.get('TAX_TYPE') == iselTaxtype && rec.get('SALE_AMT_O')!= "0"){
							sendCnt = sendCnt + 1;
							data.records.push(rec);
						}
					});
// 2020-01-05 영세매출인 경우 과세구분이 영세율이 세팅이 되도록
					if(panelSearch.getValue('BILL_TYPE') == "50"){
							iselTaxtype = "3";
						}

					if(sendCnt > 0){
						var params = {
							action		: 'select',
							'PGM_ID'	: 'ssa100ukrv',
							'record'	: data.records,
							'SELTAX_TYPE':iselTaxtype,
							'formPram'	: panelSearch.getValues()
						}
						var rec = {data : {prgID : 'ssa560ukrv', 'text':''}};
						parent.openTab(rec, '/sales/ssa560ukrv.do', params, CHOST+CPATH);

					}else{
						if(ipubNumcnt > 0 ){
								Unilite.messageBox('<t:message code="system.message.sales.message152" default="이미 해당 매출건에 대하여 세금계산서가 등록되어 있습니다."/>');
								return false;
						}else if(ipriceYNcnt > 0){
								Unilite.messageBox('<t:message code="system.message.sales.message153" default="가단가가 존재하는 경우, 세금계산서등록을 할 수 없습니다."/>');
								return false;
						}else{
								Unilite.messageBox('<t:message code="system.message.sales.message154" default="등록할 자료가 없습니다."/>');
								return false;
						}

					}
				}
			}
		}],
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns: [
			{dataIndex: 'BILL_SEQ'				, width: 60 , align:'center', locked: false	},
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width: 80 , align:'center', locked: false	},
			{dataIndex: 'OUT_DIV_CODE'			, width: 100, locked: false	},
			{dataIndex: 'WH_CODE'				, width: 100, locked: false,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filter('option', record.get('OUT_DIV_CODE'));
				}
			},
			{dataIndex: 'WH_CELL_CODE'			, width: 100,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filterBy(function(item){
						return item.get('option') == record.get('WH_CODE')
							//BSA225T의 CUSTOM_CODE가 비어 있거나 panelResult의 값과 동일한 데이터만 show
							&&(item.get('refCode10') == panelResult.getValue('SALE_CUSTOM_CODE') || item.get('refCode10') == '*')
					})
				}
			},
			{dataIndex: 'ITEM_CODE'				, width: 120, locked: false,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: {
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
							var record = masterGrid.getSelectedRecord();
							var divCode = record.get('OUT_DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'				, width: 200, locked: false,
				editor: Unilite.popup('DIV_PUMOK_G', {
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
							var record = masterGrid.getSelectedRecord();
							var divCode = record.get('OUT_DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode});
						}
					}
				})
			},
			{dataIndex: 'SPEC'					, width: 170	},
			{dataIndex: 'SALE_UNIT'				, width: 80, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
			}	},
			{dataIndex: 'TRANS_RATE'			, width: 60	},
			{dataIndex: 'SALE_Q'				, width: 80, summaryType: 'sum'	},
			{dataIndex: 'SALE_P'				, width: 120},
			/*매출등록(중량, 부피포함용)
			{dataIndex: 'PRICE_TYPE'		, width: 93	},
			{dataIndex: 'SALE_WGT_Q'		, width: 106	},
			{dataIndex: 'SALE_FOR_WGT_P'	, width: 106	},
			{dataIndex: 'SALE_VOL_Q'		, width: 106	},
			{dataIndex: 'SALE_FOR_VOL_P'	, width: 106	},
			{dataIndex: 'SALE_WGT_P'		, width: 106, hidden: true	},
			{dataIndex: 'SALE_VOL_P'		, width: 106, hidden: true	},
			{dataIndex: 'WGT_UNIT'			, width: 100	},
			{dataIndex: 'UNIT_WGT'			, width: 80	},
			{dataIndex: 'VOL_UNIT'			, width: 93	},
			{dataIndex: 'UNIT_VOL'			, width: 100	},
			*/
			{dataIndex: 'SALE_AMT_O'			, width: 120, summaryType: 'sum'	},
			{dataIndex: 'TAX_TYPE'				, width: 80, align: 'center'	},
			{dataIndex: 'TAX_AMT_O'				, width: 120, summaryType: 'sum'	},
			{dataIndex: 'ORDER_O_TAX_O'			, width: 120, summaryType: 'sum'	},
			{dataIndex: 'DISCOUNT_RATE'			, width: 80	},
			{dataIndex: 'STOCK_Q'				, width: 100, summaryType: 'sum'	},
			{dataIndex: 'DVRY_CUST_CD'			, width: 113, hidden: true	},
			{dataIndex: 'DVRY_CUST_NAME'		, width:113,
				editor: Unilite.popup('DELIVERY_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
								//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('DVRY_CUST_CD',records[0]['DELIVERY_CODE']);
								grdRecord.set('DVRY_CUST_NAME',records[0]['DELIVERY_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
								//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('DVRY_CUST_CD','');
								grdRecord.set('DVRY_CUST_NAME','');
						},
						applyextparam: function(popup){
							popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('SALE_CUSTOM_CODE')});
						}
					}
				})
			},
			{dataIndex: 'WARR_MONTH'			, width: 100	},
			{dataIndex: 'PRICE_YN'				, width: 80 , align:'center'	},
			{dataIndex: 'LOT_NO'				, width: 120	},
			{dataIndex: 'INOUT_NUM'				, width: 120	},
			{dataIndex: 'INOUT_SEQ'				, width: 80 , align:'center'	},
			{dataIndex: 'INOUT_DATE'			, width: 80	},
			{dataIndex: 'ORDER_NUM'				, width: 120	},
			{dataIndex: 'PUB_NUM'				, width: 120	},
			/*hiiden, ref 필드*/
			{dataIndex: 'DIV_CODE'				, width: 66, hidden: true},
			{dataIndex: 'BILL_NUM'				, width: 66, hidden: true	},
			{dataIndex: 'SALE_LOC_AMT_I'		, width: 66, hidden: true	},
			{dataIndex: 'INOUT_TYPE'			, width: 66, hidden: true	},
			{dataIndex: 'SER_NO'				, width: 66, hidden: true	},
			{dataIndex: 'STOCK_UNIT'			, width: 66, hidden: true	},
			{dataIndex: 'ITEM_STATUS'			, width: 66, hidden: true	},
			{dataIndex: 'ACCOUNT_YNC'			, width: 66, hidden: true	},
			{dataIndex: 'ORIGIN_Q'				, width: 66, hidden: true	},
			{dataIndex: 'REF_SALE_PRSN'			, width: 66	},
			{dataIndex: 'REF_CUSTOM_CODE'		, width: 66, hidden: true	},
			{dataIndex: 'REF_SALE_DATE'			, width: 66, hidden: true	},
			{dataIndex: 'REF_BILL_TYPE'			, width: 66, hidden: true	},
			{dataIndex: 'REF_CARD_CUST_CD'		, width: 66, hidden: true	},
			{dataIndex: 'REF_SALE_TYPE'			, width: 66, hidden: true	},
			{dataIndex: 'REF_PROJECT_NO'		, width: 120,
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
										//20200103 프로젝트명 추가
										grdRecord.set('PJT_NAME'		, record['PJT_NAME']);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('REF_PROJECT_NO'	, '');
							//20200103 프로젝트명 추가
							grdRecord.set('PJT_NAME'		, '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				})
			},
			//20200103 프로젝트명 추가
			{dataIndex: 'PJT_NAME'				, width: 120},
			{dataIndex: 'REF_TAX_INOUT'			, width: 66, hidden: true	},
			//20191210 비고컬럼 보이게 변경
			{dataIndex: 'REF_REMARK'			, width: 150, hidden: false	},
			{dataIndex: 'REF_EX_NUM'			, width: 66, hidden: true	},
			{dataIndex: 'REF_MONEY_UNIT'		, width: 66, hidden: true	},
			{dataIndex: 'REF_EXCHG_RATE_O'		, width: 66, hidden: true	},
			{dataIndex: 'STOCK_CARE_YN'			, width: 66, hidden: true	},
			{dataIndex: 'UNSALE_Q'				, width: 66, hidden: true	},
			{dataIndex: 'UPDATE_DB_USER'		, width: 66, hidden: true	},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 66, hidden: true	},
			{dataIndex: 'DATA_REF_FLAG'			, width: 66, hidden: true	},
			{dataIndex: 'SRC_CUSTOM_CODE'		, width: 86, hidden: isCustManageYN	},
			{dataIndex: 'SRC_CUSTOM_NAME'		, width: 133, hidden: isCustManageYN	},
			{dataIndex: 'SRC_ORDER_PRSN'		, width: 100, hidden: isPrsnManageYN	},
			{dataIndex: 'REF_CODE2'				, width: 66, hidden: true	},
			{dataIndex: 'SOF110T_ACCOUNT_YNC'	, width: 66, hidden: true	},
			{dataIndex: 'COMP_CODE'				, width: 66, hidden: true	},
			{dataIndex: 'INOUT_CUSTOM_CODE'		, width: 66, hidden: true	},
			{dataIndex: 'INOUT_CUSTOM_NAME'		, width: 66, hidden: true	},
			{dataIndex: 'INOUT_AGENT_TYPE'		, width: 66, hidden: true	},
			{dataIndex: 'ADVAN_YN'				, width: 66, hidden: true	},
			{dataIndex: 'GUBUN'					, width: 66, hidden: true	},
			// 20210222 : 카드사(CARD_CUSTOM_CODE) 추가
			{dataIndex: 'CARD_CUSTOM_CODE'		, width: 66, hidden: true	}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				var sExNum		= panelSearch.getValue('EX_NUM');
				var sPubNum		= e.record.data.PUB_NUM;
				var sBillType	= panelSearch.getValue('BILL_TYPE');
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
					} else{
						combo.store.clearFilter();
					}
					combo.filterByRefCode('refCode1', outDivCode);
					return true;
				}

				if(e.record.phantom){//start 신규일때
					if(sRefType == "T"){	//start 참조일때
						//20200110 주석
//						if(sAccountYNC == "N"){	//매출대상이 아닌경우 쓰기 불가
//							if (UniUtils.indexOf(e.field,
//											["SALE_P", "TAX_AMT_O", "SALE_AMT_O"]))
//								return false;
//						}

						//20191104 참조 데이터의 경우에도 단가 수정되도록 주석: 결국 다 주석;;;
//						if (UniUtils.indexOf(e.field,
//										//20190916 금액, 부가세액 수정가능하도록 변경: 'TAX_AMT_O' 주석
//										["SALE_P"/*, "TAX_AMT_O"*/]))
//							return false;

						//20190906 WH_CELL_CODE 추가, 입,출고에 관계없이 참조데이터의 경우 출고창고, 출고창고CELL 수정 안 되도록 수정
//							if(sType != "2"){
							if (UniUtils.indexOf(e.field,
											["WH_CODE", "WH_CELL_CODE"]))
								return false;
//							}

						if(gsLotNoInputMethod == "Y"){
							if (UniUtils.indexOf(e.field,
											["LOT_NO"]))
								return false;
						}

						if (UniUtils.indexOf(e.field,
										[ "OUT_DIV_CODE"
										 ,"ITEM_CODE"
										 ,"ITEM_NAME"
										 ,"SPEC"
										 ,"SALE_UNIT"
										 ,"TRANS_RATE"
										 ,"ORDER_O_TAX_O"
										 ,"DISCOUNT_RATE"
										 ,"STOCK_Q"
										 ,"DVRY_CUST_CD"
										 ,"DVRY_CUST_NAME"
										 ,"PRICE_YN"
										 ,"INOUT_NUM"
										 ,"INOUT_SEQ"
										 ,"INOUT_DATE"
										 ,"ORDER_NUM"
										 ,"PUB_NUM"
										 ,"DIV_CODE"
										 ,"BILL_NUM"
										 ,"SALE_LOC_AMT_I"
										 ,"INOUT_TYPE"
										 ,"SER_NO"
										 ,"STOCK_UNIT"
										 ,"ITEM_STATUS"
										 ,"ACCOUNT_YNC"
										 ,"ORIGIN_Q"
										 ,"REF_SALE_PRSN"
										 ,"REF_CUSTOM_CODE"
										 ,"REF_SALE_DATE"
										 ,"REF_BILL_TYPE"
										 ,"REF_CARD_CUST_CD"
										 ,"REF_SALE_TYPE"
										 //20190916 프로젝트 번호 수정 가능하도록 변경
//										 ,"REF_PROJECT_NO"
										 ,"REF_TAX_INOUT"
										 //20200219 비고 수정가능하도록 변경
//										 ,"REF_REMARK"
										 ,"REF_EX_NUM"
										 ,"REF_MONEY_UNIT"
										 ,"REF_EXCHG_RATE_O"
										 ,"STOCK_CARE_YN"
										 ,"UNSALE_Q"
										 ,"UPDATE_DB_USER"
										 ,"UPDATE_DB_TIME"
										 ,"DATA_REF_FLAG"
										 ,"SRC_CUSTOM_CODE"
										 ,"SRC_CUSTOM_NAME"
										 ,"SRC_ORDER_PRSN"
										 ,"REF_CODE2"
										 ,"SOF110T_ACCOUNT_YNC"
										 ,"COMP_CODE"
										 ,"INOUT_CUSTOM_CODE"
										 ,"INOUT_CUSTOM_NAME"
										 ,"INOUT_AGENT_TYPE"
										 ,"ADVAN_YN"
										 ,"GUBUN"
										]))
							return false;

						var param = panelSearch.getValues();
						ssa100ukrvService.getGlSubCdTotCnt(param, function(provider, response) {
							glSubCdTotCnt = provider['REF_CODE'];
							if(glSubCdTotCnt < 1){
								if (UniUtils.indexOf(e.field,
												["INOUT_TYPE_DETAIL"]))
									return false;
							}
						});
					}
						else{//start 추가버튼(미참조)
							if (UniUtils.indexOf(e.field,
											["SPEC", "INOUT_NUM", "INOUT_SEQ", "ORDER_NUM", "PUB_NUM", "ORDER_O_TAX_O"]))
								return false;

							if(sRefCode2 == "94" || sRefCode2 == "AU"){//2020.08.07  금액 보정일 경우 수정 안되도록 변경
								if (UniUtils.indexOf(e.field,
												["SALE_Q", "SALE_P", "PRICE_YN"]))
									return false;
							}

							if(sRefCode2 == "94"){
								if (UniUtils.indexOf(e.field,
												["TAX_AMT_O"]))
									return false;
							}
						}//end 추가버튼(미참조)

				}//end 신규일때
				else{//start 신규가 아닐때(변경)
					if(sBillType > "10" && sBillType < "50"){	//start sBillType > "10" && sBillType < "50"
						if(!Ext.isEmpty(sExNum)){	//start 견적번호가 있을때
							if (UniUtils.indexOf(e.field,
											[ "BILL_SEQ"
											 ,"INOUT_TYPE_DETAIL"
											 ,"OUT_DIV_CODE"
											 ,"WH_CODE"
											 ,"ITEM_CODE"
											 ,"ITEM_NAME"
											 ,"SPEC"
											 ,"SALE_UNIT"
											 ,"PRICE_TYPE"
											 ,"TRANS_RATE"
											 ,"SALE_Q"
											 ,"SALE_P"
											 ,"SALE_AMT_O"
											 ,"TAX_TYPE"
											 ,"TAX_AMT_O"
											 ,"ORDER_O_TAX_O"
											 ,"DISCOUNT_RATE"
											 ,"STOCK_Q"
											 ,"DVRY_CUST_CD"
											 ,"DVRY_CUST_NAME"
											 ,"PRICE_YN"
											 ,"LOT_NO"
											 ,"INOUT_NUM"
											 ,"INOUT_SEQ"
											 ,"INOUT_DATE"
											 ,"ORDER_NUM"
											 ,"PUB_NUM"
											 ,"DIV_CODE"
											 ,"BILL_NUM"
											 ,"SALE_LOC_AMT_I"
											 ,"INOUT_TYPE"
											 ,"SER_NO"
											 ,"STOCK_UNIT"
											 ,"ITEM_STATUS"
											 ,"ACCOUNT_YNC"
											 ,"ORIGIN_Q"
											 ,"REF_SALE_PRSN"
											 ,"REF_CUSTOM_CODE"
											 ,"REF_SALE_DATE"
											 ,"REF_BILL_TYPE"
											 ,"REF_CARD_CUST_CD"
											 ,"REF_SALE_TYPE"
											 //20190916 프로젝트 번호 수정 가능하도록 변경
//											 ,"REF_PROJECT_NO"
											 ,"REF_TAX_INOUT"
											 //20200219 비고 수정가능하도록 변경
//											 ,"REF_REMARK"
											 ,"REF_EX_NUM"
											 ,"REF_MONEY_UNIT"
											 ,"REF_EXCHG_RATE_O"
											 ,"STOCK_CARE_YN"
											 ,"UNSALE_Q"
											 ,"UPDATE_DB_USER"
											 ,"UPDATE_DB_TIME"
											 ,"DATA_REF_FLAG"
											 ,"SRC_CUSTOM_CODE"
											 ,"SRC_CUSTOM_NAME"
											 ,"SRC_ORDER_PRSN"
											 ,"REF_CODE2"
											 ,"SOF110T_ACCOUNT_YNC"
											 ,"COMP_CODE"
											 ,"INOUT_CUSTOM_CODE"
											 ,"INOUT_CUSTOM_NAME"
											 ,"INOUT_AGENT_TYPE"
											 ,"ADVAN_YN"
											 ,"GUBUN"
											]))
								return false;
						}//end 견적번호가 있을때
						else{//start 견적번호가 없을때
							if (UniUtils.indexOf(e.field, //PK키값들 editable false
											[ "BILL_SEQ", "DIV_CODE", "BILL_NUM", "COMP_CODE" ]))
								return false;

							if(gsLotNoInputMethod == "Y"){
								if (UniUtils.indexOf(e.field,
												["LOT_NO"]))
									return false;
							}

							if(sRefCode2 == "94" && sRefCode2 == "AU"){
								if (UniUtils.indexOf(e.field,
												["SALE_Q", "PRICE_YN"]))
									return false;
							}

							if(sAccountYNC == "N"){
								if (UniUtils.indexOf(e.field,
												["SALE_AMT_O", "TAX_AMT_O"]))
									return false;
							}

							if(sAccountYNC == "N"){
								if (UniUtils.indexOf(e.field,
												["SALE_P"]))
									return false;
							} else{
								if(sRefCode2 == "94" || sRefCode2 == "AU"){ //2020.08.07  금액 보정일 경우 수정 안되도록 변경
									if (UniUtils.indexOf(e.field,
													["SALE_P"]))
										return false;
								}
							}

							if(e.record.data.SALE_P != "0" && e.record.data.SALE_AMT_O != "0" ){
								if (UniUtils.indexOf(e.field,
												["DISCOUNT_RATE"]))
									return false;
							}

							if(sType != "2"){
								if(glSubCdTotCnt < 1){
									if (UniUtils.indexOf(e.field,
													["INOUT_TYPE_DETAIL"]))
										return false;
								}
							}

							if (UniUtils.indexOf(e.field,
											[ "BILL_SEQ"
											 ,"OUT_DIV_CODE"
											 ,"WH_CODE"
											 ,"ITEM_CODE"
											 ,"ITEM_NAME"
											 ,"SPEC"
											 ,"PRICE_TYPE"
											 ,"SALE_WGT_Q"
											 ,"SALE_FOR_WGT_P"
											 ,"SALE_VOL_Q"
											 ,"SALE_FOR_VOL_P"
											 ,"SALE_WGT_P"
											 ,"SALE_VOL_P"
											 ,"WGT_UNIT"
											 ,"UNIT_WGT"
											 ,"VOL_UNIT"
											 ,"UNIT_VOL"
											 ,"ORDER_O_TAX_O"
											 ,"STOCK_Q"
											 ,"DVRY_CUST_CD"
											 ,"DVRY_CUST_NAME"
											 ,"INOUT_NUM"
											 ,"INOUT_SEQ"
											 ,"INOUT_DATE"
											 ,"ORDER_NUM"
											 ,"PUB_NUM"
											 ,"DIV_CODE"
											 ,"BILL_NUM"
											 ,"SALE_LOC_AMT_I"
											 ,"INOUT_TYPE"
											 ,"SER_NO"
											 ,"STOCK_UNIT"
											 ,"ITEM_STATUS"
											 ,"ACCOUNT_YNC"
											 ,"ORIGIN_Q"
											 ,"REF_SALE_PRSN"
											 ,"REF_CUSTOM_CODE"
											 ,"REF_SALE_DATE"
											 ,"REF_BILL_TYPE"
											 ,"REF_CARD_CUST_CD"
											 ,"REF_SALE_TYPE"
											 //20190916 프로젝트 번호 수정 가능하도록 변경
//											 ,"REF_PROJECT_NO"
											 ,"REF_TAX_INOUT"
											 //20200219 비고 수정가능하도록 변경
//											 ,"REF_REMARK"
											 ,"REF_EX_NUM"
											 ,"REF_MONEY_UNIT"
											 ,"REF_EXCHG_RATE_O"
											 ,"STOCK_CARE_YN"
											 ,"UNSALE_Q"
											 ,"UPDATE_DB_USER"
											 ,"UPDATE_DB_TIME"
											 ,"DATA_REF_FLAG"
											 ,"SRC_CUSTOM_CODE"
											 ,"SRC_CUSTOM_NAME"
											 ,"SRC_ORDER_PRSN"
											 ,"REF_CODE2"
											 ,"SOF110T_ACCOUNT_YNC"
											 ,"COMP_CODE"
											 ,"INOUT_CUSTOM_CODE"
											 ,"INOUT_CUSTOM_NAME"
											 ,"INOUT_AGENT_TYPE"
											 ,"ADVAN_YN"
											 ,"GUBUN"
											]))
								return false;
						}//end 견적번호가 없을때
					}	//end sBillType > "10" && sBillType < "50"
					else{
						if(!Ext.isEmpty(sPubNum)){	//start sPubNum <> ""
							if (UniUtils.indexOf(e.field,
											[ "BILL_SEQ"
											 ,"INOUT_TYPE_DETAIL"
											 ,"OUT_DIV_CODE"
											 ,"WH_CODE"
											 ,"ITEM_CODE"
											 ,"ITEM_NAME"
											 ,"SPEC"
											 ,"SALE_UNIT"
											 ,"PRICE_TYPE"
											 ,"TRANS_RATE"
											 ,"SALE_Q"
											 ,"SALE_P"
											 ,"SALE_WGT_Q"
											 ,"SALE_FOR_WGT_P"
											 ,"SALE_VOL_Q"
											 ,"SALE_FOR_VOL_P"
											 ,"SALE_WGT_P"
											 ,"SALE_VOL_P"
											 ,"WGT_UNIT"
											 ,"UNIT_WGT"
											 ,"VOL_UNIT"
											 ,"UNIT_VOL"
											 ,"SALE_AMT_O"
											 ,"TAX_TYPE"
											 ,"TAX_AMT_O"
											 ,"ORDER_O_TAX_O"
											 ,"DISCOUNT_RATE"
											 ,"STOCK_Q"
											 ,"DVRY_CUST_CD"
											 ,"DVRY_CUST_NAME"
											 ,"PRICE_YN"
											 ,"LOT_NO"
											 ,"INOUT_NUM"
											 ,"INOUT_SEQ"
											 ,"INOUT_DATE"
											 ,"ORDER_NUM"
											 ,"PUB_NUM"
											 ,"DIV_CODE"
											 ,"BILL_NUM"
											 ,"SALE_LOC_AMT_I"
											 ,"INOUT_TYPE"
											 ,"SER_NO"
											 ,"STOCK_UNIT"
											 ,"ITEM_STATUS"
											 ,"ACCOUNT_YNC"
											 ,"ORIGIN_Q"
											 ,"REF_SALE_PRSN"
											 ,"REF_CUSTOM_CODE"
											 ,"REF_SALE_DATE"
											 ,"REF_BILL_TYPE"
											 ,"REF_CARD_CUST_CD"
											 ,"REF_SALE_TYPE"
											 //20190916 프로젝트 번호 수정 가능하도록 변경
//											 ,"REF_PROJECT_NO"
											 ,"REF_TAX_INOUT"
											 //20200219 비고 수정가능하도록 변경
//											 ,"REF_REMARK"
											 ,"REF_EX_NUM"
											 ,"REF_MONEY_UNIT"
											 ,"REF_EXCHG_RATE_O"
											 ,"STOCK_CARE_YN"
											 ,"UNSALE_Q"
											 ,"UPDATE_DB_USER"
											 ,"UPDATE_DB_TIME"
											 ,"DATA_REF_FLAG"
											 ,"SRC_CUSTOM_CODE"
											 ,"SRC_CUSTOM_NAME"
											 ,"SRC_ORDER_PRSN"
											 ,"REF_CODE2"
											 ,"SOF110T_ACCOUNT_YNC"
											 ,"COMP_CODE"
											 ,"INOUT_CUSTOM_CODE"
											 ,"INOUT_CUSTOM_NAME"
											 ,"INOUT_AGENT_TYPE"
											 ,"ADVAN_YN"
											 ,"GUBUN"
											]))
								return false;
						}//end sPubNum <> ""
						else{//start sPubNum 값이 있을때
							if (UniUtils.indexOf(e.field, //PK키값들 editable false
											[ "BILL_SEQ", "DIV_CODE", "BILL_NUM", "COMP_CODE" ]))
								return false;

							if(gsLotNoInputMethod == "Y"){
								if (UniUtils.indexOf(e.field,
												["LOT_NO"]))
									return false;
							}

							if(sRefCode2 == "94" && sRefCode2 == "AU"){
								if (UniUtils.indexOf(e.field,
												["SALE_Q", "PRICE_YN"]))
									return false;
							}

							if(sAccountYNC == "N"){
								if (UniUtils.indexOf(e.field,
												["SALE_AMT_O", "TAX_AMT_O"]))
									return false;
							}

							if(sAccountYNC == "N"){
								if (UniUtils.indexOf(e.field,
												["SALE_P"]))
									return false;
							} else{
								if(sRefCode2 == "94" && sRefCode2 == "AU"){
									if (UniUtils.indexOf(e.field,
													["SALE_P"]))
										return false;
								}
							}

							if(e.record.data.SALE_P != "0" && e.record.data.SALE_AMT_O != "0" ){
								if (UniUtils.indexOf(e.field,
												["DISCOUNT_RATE"]))
									return false;
							}

							if (UniUtils.indexOf(e.field,
											[ "BILL_SEQ"
											 ,"INOUT_TYPE_DETAIL"
											 ,"OUT_DIV_CODE"
											 ,"WH_CODE"
											 ,"ITEM_CODE"
											 ,"ITEM_NAME"
											 ,"SPEC"
											 ,"SALE_UNIT"
											 ,"PRICE_TYPE"
											 ,"TRANS_RATE"
											 ,"SALE_WGT_Q"
											 ,"SALE_FOR_WGT_P"
											 ,"SALE_VOL_Q"
											 ,"SALE_FOR_VOL_P"
											 ,"SALE_WGT_P"
											 ,"SALE_VOL_P"
											 ,"WGT_UNIT"
											 ,"UNIT_WGT"
											 ,"VOL_UNIT"
											 ,"UNIT_VOL"
											 ,"ORDER_O_TAX_O"
											 ,"STOCK_Q"
											 ,"DVRY_CUST_CD"
											 ,"DVRY_CUST_NAME"
											 ,"INOUT_NUM"
											 ,"INOUT_SEQ"
											 ,"INOUT_DATE"
											 ,"ORDER_NUM"
											 ,"PUB_NUM"
											 ,"DIV_CODE"
											 ,"BILL_NUM"
											 ,"SALE_LOC_AMT_I"
											 ,"INOUT_TYPE"
											 ,"SER_NO"
											 ,"STOCK_UNIT"
											 ,"ITEM_STATUS"
											 ,"ACCOUNT_YNC"
											 ,"ORIGIN_Q"
											 ,"REF_SALE_PRSN"
											 ,"REF_CUSTOM_CODE"
											 ,"REF_SALE_DATE"
											 ,"REF_BILL_TYPE"
											 ,"REF_CARD_CUST_CD"
											 ,"REF_SALE_TYPE"
											 //20190916 프로젝트 번호 수정 가능하도록 변경
//											 ,"REF_PROJECT_NO"
											 ,"REF_TAX_INOUT"
											 //20200219 비고 수정가능하도록 변경
//											 ,"REF_REMARK"
											 ,"REF_EX_NUM"
											 ,"REF_MONEY_UNIT"
											 ,"REF_EXCHG_RATE_O"
											 ,"STOCK_CARE_YN"
											 ,"UNSALE_Q"
											 ,"UPDATE_DB_USER"
											 ,"UPDATE_DB_TIME"
											 ,"DATA_REF_FLAG"
											 ,"SRC_CUSTOM_CODE"
											 ,"SRC_CUSTOM_NAME"
											 ,"SRC_ORDER_PRSN"
											 ,"REF_CODE2"
											 ,"SOF110T_ACCOUNT_YNC"
											 ,"COMP_CODE"
											 ,"INOUT_CUSTOM_CODE"
											 ,"INOUT_CUSTOM_NAME"
											 ,"INOUT_AGENT_TYPE"
											 ,"ADVAN_YN"
											 ,"GUBUN"
											]))
								return false;
						}//end sPubNum 값이 있을때
					}
				}// end 신규가 아닐때(변경)
			}
		},
		disabledLinkButtons: function(b) {
			this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
			this.down('#procTool').menu.down('#issueLinkBtn').setDisabled(b);
			this.down('#procTool').menu.down('#saleLinkBtn').setDisabled(b);
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

				if(panelSearch.getValue('BILL_TYPE') != "50"){
					grdRecord.set('TAX_TYPE'	, record['TAX_TYPE']);
				} else{
					grdRecord.set('TAX_TYPE'	, "2");
				}

				if(sRefCode2 != "94" && sRefCode2 != "<AU>"){
					grdRecord.set('STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
					grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
					UniSales.fnGetPriceInfo(grdRecord, UniAppManager.app.cbGetPriceInfo
												,'I'
												,UserInfo.compCode
												,panelSearch.getValue('SALE_CUSTOM_CODE')
												,BsaCodeInfo.gsAgentType
												,grdRecord.get('ITEM_CODE')
												,BsaCodeInfo.gsMoneyUnit
												,grdRecord.get('SALE_UNIT')
												,grdRecord.get('STOCK_UNIT')
												,record['TRNS_RATE']
												,UniDate.getDbDateStr(panelSearch.getValue('SALE_DATE'))
												)
					if(record['STOCK_CARE_YN'] == "Y"){
						UniSales.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), "1", grdRecord.get('ITEM_CODE'),  grdRecord.get('WH_CODE'));
					}
				} else{
					grdRecord.set('STOCK_CARE_YN'	, 'N');
					grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
				}

			}
		},
		setSalesOrderData:function(record) {
			var grdRecord = this.getSelectedRecord();
			var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
			var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2

			grdRecord.set('INOUT_TYPE_DETAIL'	, inoutTypeDetail);
			grdRecord.set('REF_CODE2'			, refCode2);
			grdRecord.set('WH_CODE'				, record['WH_CODE']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('SALE_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);
			grdRecord.set('SALE_Q'				, record['NOT_SALE_Q']);
			if(panelSearch.getValue('BILL_TYPE') != "50"){
				grdRecord.set('TAX_TYPE'		, record['TAX_TYPE']);
			} else{
				grdRecord.set('TAX_TYPE'		, '2');
			}
			grdRecord.set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
			grdRecord.set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);
			grdRecord.set('DVRY_CUST_NAME'		, record['DVRY_CUST_NAME']);
			grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('DIV_CODE'			, panelSearch.getValue('DIV_CODE'));
			grdRecord.set('BILL_NUM'			, panelSearch.getValue('BILL_NUM'));
			grdRecord.set('INOUT_TYPE'			, '2');
			grdRecord.set('SER_NO'				, record['SER_NO']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('ITEM_STATUS'			, '1');
			grdRecord.set('ACCOUNT_YNC'			, record['ACCOUNT_YNC']);
			grdRecord.set('ORIGIN_Q'			, '0');
			grdRecord.set('REF_SALE_PRSN'		, panelSearch.getValue('SALE_PRSN'));
			grdRecord.set('REF_CUSTOM_CODE'		, panelSearch.getValue('SALE_CUSTOM_CODE'));
			grdRecord.set('REF_SALE_DATE'		, panelSearch.getValue('SALE_DATE'));
			grdRecord.set('REF_BILL_TYPE'		, panelSearch.getValue('BILL_TYPE'));
			grdRecord.set('REF_CARD_CUST_CD'	, panelSearch.getValue('CARD_CUST_CD'));
			grdRecord.set('REF_SALE_TYPE'		, panelSearch.getValue('ORDER_TYPE'));
			if(Ext.isEmpty(record['PROJECT_NO'])){
				grdRecord.set('REF_PROJECT_NO'	, panelSearch.getValue('PROJECT_NO'));
				//20200103 추가
				grdRecord.set('PJT_NAME'		, panelSearch.getValue('PJT_NAME'));
			} else{
				grdRecord.set('REF_PROJECT_NO'	, record['PROJECT_NO']);
				//20200103 추가
				grdRecord.set('PJT_NAME'		, record['PJT_NAME']);
			}
			grdRecord.set('REF_TAX_INOUT'		, panelSearch.getValue('TAX_TYPE').TAX_TYPE);
			grdRecord.set('REF_REMARK'			, panelSearch.getValue('REMARK'));
			grdRecord.set('REF_EX_NUM'			, panelSearch.getValue('EX_NUM'));
			grdRecord.set('REF_MONEY_UNIT'		, record['MONEY_UNIT']);
			grdRecord.set('REF_EXCHG_RATE_O'	, panelSearch.getValue('EXCHG_RATE_O'));
			grdRecord.set('STOCK_CARE_YN'		, record['STOCK_CARE_YN']);
			grdRecord.set('UNSALE_Q'			, record['NOT_SALE_Q']);
			grdRecord.set('UPDATE_DB_USER'		, UserInfo.userID);
			grdRecord.set('DATA_REF_FLAG'		, 'T');
			grdRecord.set('SRC_CUSTOM_CODE'		, record['CUSTOM_CODE']);
			grdRecord.set('SRC_CUSTOM_NAME'		, record['CUSTOM_NAME']);
			grdRecord.set('SRC_ORDER_PRSN'		, record['ORDER_PRSN']);
			grdRecord.set('OUT_DIV_CODE'		, record['OUT_DIV_CODE']);
			if(record['ACCOUNT_YNC'] == "N"){
				grdRecord.set('SALE_P'			, 0);
				grdRecord.set('SALE_AMT_O'		, 0);
				grdRecord.set('SALE_LOC_AMT_I'	, 0);
				grdRecord.set('TAX_AMT_O'		, 0);
			} else{
				grdRecord.set('SALE_P'			, record['ORDER_P']);
				if(record['ORDER_Q'] != record['NOT_SALE_Q']){
					UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
				} else{
					grdRecord.set('SALE_AMT_O'		, record['ORDER_O']);
					grdRecord.set('SALE_LOC_AMT_I'	, record['ORDER_O']);
					grdRecord.set('TAX_AMT_O'		, record['ORDER_TAX_O']);
				}
			}
			grdRecord.set('COMP_CODE'			, UserInfo.compCode);
			UniSales.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), "1", grdRecord.get('ITEM_CODE'),  grdRecord.get('WH_CODE'));
			UniAppManager.app.fnOrderAmtCal(grdRecord, "Q");
		},
		setPreviousSalesOrderData:function(record) {
			var grdRecord		= this.getSelectedRecord();
			var inoutTypeDetail	= Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value');	//출고유형콤보value중 첫번째 value
			var refCode2		= UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;				//출고유형value의 ref2

			grdRecord.set('INOUT_TYPE_DETAIL'	, inoutTypeDetail);
			grdRecord.set('REF_CODE2'			, refCode2);
			grdRecord.set('WH_CODE'				, record['WH_CODE']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('SALE_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);
			grdRecord.set('SALE_Q'				, record['NOT_SALE_Q']);
			if(panelSearch.getValue('BILL_TYPE') != "50"){
				grdRecord.set('TAX_TYPE'		, record['TAX_TYPE']);
			} else{
				grdRecord.set('TAX_TYPE'		, '2');
			}
			grdRecord.set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
			grdRecord.set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);
			grdRecord.set('DVRY_CUST_NAME'		, record['DVRY_CUST_NAME']);
			grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('DIV_CODE'			, panelSearch.getValue('DIV_CODE'));
			grdRecord.set('BILL_NUM'			, panelSearch.getValue('BILL_NUM'));
			grdRecord.set('INOUT_TYPE'			, '2');
			grdRecord.set('SER_NO'				, record['SER_NO']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('ITEM_STATUS'			, '1');
			grdRecord.set('ACCOUNT_YNC'			, record['ACCOUNT_YNC']);
			grdRecord.set('ORIGIN_Q'			, '0');
			grdRecord.set('REF_SALE_PRSN'		, panelSearch.getValue('SALE_PRSN'));
			grdRecord.set('REF_CUSTOM_CODE'		, panelSearch.getValue('SALE_CUSTOM_CODE'));
			grdRecord.set('REF_SALE_DATE'		, panelSearch.getValue('SALE_DATE'));
			grdRecord.set('REF_BILL_TYPE'		, panelSearch.getValue('BILL_TYPE'));
			grdRecord.set('REF_CARD_CUST_CD'	, panelSearch.getValue('CARD_CUST_CD'));
			grdRecord.set('REF_SALE_TYPE'		, panelSearch.getValue('ORDER_TYPE'));
			//2020103 프로젝트 추가로직 변경
//			grdRecord.set('REF_PROJECT_NO'		, record['PROJECT_NO']);
			if(Ext.isEmpty(record['PROJECT_NO'])){
				grdRecord.set('REF_PROJECT_NO'	, panelSearch.getValue('PROJECT_NO'));
				//20200103 추가
				grdRecord.set('PJT_NAME'		, panelSearch.getValue('PJT_NAME'));
			} else{
				grdRecord.set('REF_PROJECT_NO'	, record['PROJECT_NO']);
				//20200103 추가
				grdRecord.set('PJT_NAME'		, record['PJT_NAME']);
			}
			grdRecord.set('INOUT_NUM'			, record['INOUT_NUM']);
			grdRecord.set('INOUT_SEQ'			, record['INOUT_SEQ']);
			grdRecord.set('INOUT_DATE'			, record['INOUT_DATE']);
			grdRecord.set('REF_TAX_INOUT'		, panelSearch.getValue('TAX_TYPE').TAX_TYPE);
			grdRecord.set('REF_REMARK'			, panelSearch.getValue('REMARK'));
			grdRecord.set('REF_EX_NUM'			, panelSearch.getValue('EX_NUM'));
			grdRecord.set('REF_MONEY_UNIT'		, record['MONEY_UNIT']);
			grdRecord.set('REF_EXCHG_RATE_O'	, panelSearch.getValue('EXCHG_RATE_O'));
			grdRecord.set('STOCK_CARE_YN'		, record['STOCK_CARE_YN']);
			grdRecord.set('UNSALE_Q'			, record['NOT_SALE_Q']);
			grdRecord.set('UPDATE_DB_USER'		, UserInfo.userID);
			grdRecord.set('DATA_REF_FLAG'		, 'T');
			grdRecord.set('ADVAN_YN'			, 'Y');	//수주참조(선매출) 참조탭사용 확인용
			grdRecord.set('SRC_CUSTOM_CODE'		, record['CUSTOM_CODE']);
			grdRecord.set('OUT_DIV_CODE'		, record['OUT_DIV_CODE']);
			if(record['ACCOUNT_YNC'] == "N"){
				grdRecord.set('SALE_P'			, 0);
				grdRecord.set('SALE_AMT_O'		, 0);
				grdRecord.set('SALE_LOC_AMT_I'	, 0);
				grdRecord.set('TAX_AMT_O'		, 0);
			} else{
				grdRecord.set('SALE_P'			, record['ORDER_P']);
//				if(record['ORDER_Q'] != record['NOT_SALE_Q']){
//					UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
//				} else{
				grdRecord.set('SALE_AMT_O'		, record['NOT_AMOUNT']);
				grdRecord.set('SALE_LOC_AMT_I'	, record['NOT_AMOUNT']);
				grdRecord.set('TAX_AMT_O'		, record['ORDER_TAX_O']);
//				}
			}
			grdRecord.set('COMP_CODE'			, UserInfo.compCode);
			UniSales.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), "1", grdRecord.get('ITEM_CODE'),  grdRecord.get('WH_CODE'));
		},
		setIssueData: function(record) {
			var grdRecord = this.getSelectedRecord();
			var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
			var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2
			if(record['INOUT_TYPE'] == "2"){
				grdRecord.set('INOUT_TYPE_DETAIL'	, record['INOUT_TYPE_DETAIL']);
				grdRecord.set('REF_CODE2'			, record['REF_CODE2']);
			} else{
				grdRecord.set('INOUT_TYPE_DETAIL'	, '95');
				grdRecord.set('REF_CODE2'			, refCode2);
			}
			grdRecord.set('WH_CODE'					, record['WH_CODE']);
			grdRecord.set('ITEM_CODE'				, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'				, record['ITEM_NAME']);
			grdRecord.set('SPEC'					, record['SPEC']);
			grdRecord.set('SALE_UNIT'				, record['ORDER_UNIT']);
			grdRecord.set('TRANS_RATE'				, record['TRNS_RATE']);
			grdRecord.set('SALE_Q'					, record['NOT_SALE_Q']);
			grdRecord.set('SALE_P'					, record['ORDER_UNIT_P']);
			if(panelSearch.getValue('BILL_TYPE') != "50"){
				grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);
			} else{
				grdRecord.set('TAX_TYPE'			, '2');
			}
			grdRecord.set('DISCOUNT_RATE'			, record['DISCOUNT_RATE']);
			grdRecord.set('DVRY_CUST_CD'			, record['DVRY_CUST_CD']);
			grdRecord.set('PRICE_YN'				, record['PRICE_YN']);
			grdRecord.set('LOT_NO'					, record['LOT_NO']);
			grdRecord.set('INOUT_NUM'				, record['INOUT_NUM']);
			grdRecord.set('INOUT_SEQ'				, record['INOUT_SEQ']);
			grdRecord.set('DIV_CODE'				, panelSearch.getValue('DIV_CODE'));
			grdRecord.set('BILL_NUM'				, panelSearch.getValue('BILL_NUM'));
			grdRecord.set('INOUT_TYPE'				, record['INOUT_TYPE']);
			grdRecord.set('ORDER_NUM'				, record['ORDER_NUM']);
			grdRecord.set('SER_NO'					, record['ORDER_SEQ']);
			grdRecord.set('STOCK_UNIT'				, record['STOCK_UNIT']);
			grdRecord.set('ITEM_STATUS'				, '1');
			grdRecord.set('ACCOUNT_YNC'				, 'Y');
			grdRecord.set('ORIGIN_Q'				, '0');
			if(Ext.isEmpty(panelSearch.getValue('SALE_PRSN'))){
				grdRecord.set('REF_SALE_PRSN'		, record['ORDER_PRSN']);
			} else{
				grdRecord.set('REF_SALE_PRSN'		, panelSearch.getValue('SALE_PRSN'));
			}
//			grdRecord.set('REF_SALE_PRSN'			, panelSearch.getValue('SALE_PRSN'));
			grdRecord.set('REF_CUSTOM_CODE'			, panelSearch.getValue('SALE_CUSTOM_CODE'));
			grdRecord.set('REF_SALE_DATE'			, panelSearch.getValue('SALE_DATE'));
			grdRecord.set('REF_BILL_TYPE'			, panelSearch.getValue('BILL_TYPE'));
			grdRecord.set('REF_CARD_CUST_CD'		, panelSearch.getValue('CARD_CUST_CD'));
			grdRecord.set('REF_SALE_TYPE'			, panelSearch.getValue('ORDER_TYPE'));
			if(Ext.isEmpty(record['PROJECT_NO'])){
				grdRecord.set('REF_PROJECT_NO'		, panelSearch.getValue('PROJECT_NO'));
				//20200103 추가
				grdRecord.set('PJT_NAME'			, panelSearch.getValue('PJT_NAME'));
			} else{
				grdRecord.set('REF_PROJECT_NO'		, record['PROJECT_NO']);
				//20200103 추가
				grdRecord.set('PJT_NAME'			, record['PJT_NAME']);
			}
			grdRecord.set('REF_TAX_INOUT'			, panelSearch.getValue('TAX_TYPE').TAX_TYPE);
			grdRecord.set('REF_REMARK'				, panelSearch.getValue('REMARK'));
			grdRecord.set('REF_EX_NUM'				, panelSearch.getValue('EX_NUM'));
			grdRecord.set('REF_MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('REF_EXCHG_RATE_O'		, panelSearch.getValue('EXCHG_RATE_O'));
			grdRecord.set('STOCK_CARE_YN'			, record['STOCK_CARE_YN']);
			grdRecord.set('UNSALE_Q'				, record['NOT_SALE_Q']);
			grdRecord.set('UPDATE_DB_USER'			, UserInfo.userID);
			grdRecord.set('DATA_REF_FLAG'			, 'T');
			grdRecord.set('DVRY_CUST_NAME'			, record['DVRY_CUST_NAME']);
			grdRecord.set('SRC_CUSTOM_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('SRC_CUSTOM_NAME'			, record['INOUT_NAME']);
			grdRecord.set('SRC_ORDER_PRSN'			, record['ORDER_PRSN']);
			grdRecord.set('OUT_DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('INOUT_DATE'				, record['INOUT_DATE']);
			grdRecord.set('COMP_CODE'				, UserInfo.compCode);

			UniSales.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), "1", grdRecord.get('ITEM_CODE'),  grdRecord.get('WH_CODE'));
			UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
		}
	});// End of var masterGrid = Unilite.createGrid('ssa100ukrvGrid1', {



	//검색창 폼
	var salesNoSearch = Unilite.createSearchForm('salesNoSearchForm', {
		layout	: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					//20190731 임시 주석
//					combo.changeDivCode(combo, newValue, oldValue, eOpts);
//					var field = salesNoSearch.getField('SALE_PRSN');
//					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>' ,
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
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
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			fieldLabel		: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'SALE_DATE_FR',
			endFieldName	: 'SALE_DATE_TO',
			width			: 350
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
			name		: 'ORDER_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S002'
		},{
			fieldLabel	: '<t:message code="system.label.sales.vattype" default="부가세유형"/>',
			name		: 'BILL_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S024',
			value		: '10'
		},
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			validateBlank	: true,
			textFieldName	: 'PROJECT_NO',
			itemId			: 'project',
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'BPARAM0'	: 1});
					popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('SALE_CUSTOM_CODE')});
				}
			}
		}),
		{
			fieldLabel	: '<t:message code="system.label.base.taxtype" default="세구분"/>' ,
			name		: 'TAX_TYPE2',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B059',
			allowBlank	: true,
			fieldStyle	: 'text-align: center;',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {

				}
			}
		},
		{
			fieldLabel	: '<t:message code="system.label.sales.issueno" default="출고번호"/>',
			xtype		: 'uniTextfield',
			name		: 'INOUT_NUM',
			width		: 315
		},{
			fieldLabel	: '<t:message code="system.label.sales.salesno" default="매출번호"/>',
			xtype		: 'uniTextfield',
			name		: 'BILL_NUM',
			width		: 315
		},{
			fieldLabel	: '<t:message code="system.label.sales.inquiryclass" default="조회구분"/>',
			xtype		: 'radiogroup',
			allowBlank	: false,
			width		: 235,
			name		: 'RDO_TYPE',
			items: [
				{boxLabel:'<t:message code="system.label.sales.master" default="마스터"/>', name:'RDO_TYPE', inputValue:'master', checked:true},
				{boxLabel:'<t:message code="system.label.sales.detail" default="디테일"/>', name:'RDO_TYPE', inputValue:'detail'}
			],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(newValue)) {
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
		})]
	}); // createSearchForm
	//검색창 마스터 모델
	Unilite.defineModel('salesNoMasterModel', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string', comboType: 'BOR120'},
			{name: 'SALE_CUSTOM_CODE'	, text: '<t:message code="system.label.sales.client" default="고객"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.clientname" default="고객명"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'						, type: 'string'},
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
			{name: 'PAYMENT_TERM'		, text: '<t:message code="system.label.sales.paycondition" default="결제조건"/>'			, type: 'string'},
			{name: 'PAYMENT_DAY'		, text: '<t:message code="system.label.sales.paymentday" default="결제예정일"/>'				, type: 'uniDate'},
			/*거래처 정보*/
			{name: 'AGENT_TYPE'			, text: 'AGENT_TYPE'	, type: 'string'},
			{name: 'CREDIT_YN'			, text: 'CREDIT_YN'		, type: 'string'},
			{name: 'WON_CALC_BAS'		, text: 'WON_CALC_BAS'	, type: 'string'},
			{name: 'TAX_CALC_TYPE'		, text: 'TAX_CALC_TYPE'	, type: 'string'},
			{name: 'TAX_TYPE'			, text: 'TAX_TYPE'		, type: 'string'}
		]
	});
	//검색창 디테일 모델
	Unilite.defineModel('salesNoDetailModel', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string', comboType: 'BOR120'},
			{name: 'SALE_CUSTOM_CODE'	, text: '<t:message code="system.label.sales.client" default="고객"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.clientname" default="고객명"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'				,text:'<t:message code="system.label.sales.spec" default="규격"/>'						, type: 'string'},
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
	//검색 스토어(마스터)
	var salesNoMasterStore = Unilite.createStore('salesNoMasterStore', {
		model	: 'salesNoMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'ssa100ukrvService.selectSalesNumMasterList'
			}
		},
		loadStoreRecords : function() {
			var param		= salesNoSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;	//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(salesNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색 스토어(디테일)
	var salesNoDetailStore = Unilite.createStore('salesNoDetailStore', {
		model	: 'salesNoDetailModel',
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
				read: 'ssa100ukrvService.selectSalesNumDetailList'
			}
		},
		loadStoreRecords : function() {
			var param		= salesNoSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;	//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(salesNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색창 그리드(마스터)
	var salesNoMasterGrid = Unilite.createGrid('ssa101ukrvSalesNoMasterGrid', {
		store	: salesNoMasterStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: false
		},
		columns	: [
			{ dataIndex: 'DIV_CODE'			, width: 100},
			{ dataIndex: 'SALE_CUSTOM_CODE' , width: 100,hidden:true},
			{ dataIndex: 'CUSTOM_NAME'		, width: 130},
			{ dataIndex: 'ITEM_CODE'		, width: 100,hidden:true},
			{ dataIndex: 'ITEM_NAME'		, width: 166,hidden:true},
			{ dataIndex: 'SPEC'				, width: 120,hidden:true},
			{ dataIndex: 'SALE_DATE'		, width: 100},
			{ dataIndex: 'BILL_TYPE'		, width: 73},
			{ dataIndex: 'SALE_TYPE'		, width: 100,hidden:true},
			{ dataIndex: 'SALE_TYPE_NAME'	, width: 100},
			{ dataIndex: 'SALE_Q'			, width: 86},
			{ dataIndex: 'SALE_TOT_O'		, width: 86},
			{ dataIndex: 'SALE_LOC_AMT_I'	, width: 86},
			{ dataIndex: 'SALE_LOC_EXP_I'	, width: 80},
			{ dataIndex: 'TAX_AMT_O'		, width: 80},
			{ dataIndex: 'SALE_PRSN'		, width: 100,hidden:true},
			{ dataIndex: 'SALE_PRSN_NAME'	, width: 66},
			{ dataIndex: 'BILL_NUM'			, width: 120},
			{ dataIndex: 'PROJECT_NO'		, width: 86},
			{ dataIndex: 'INOUT_NUM'		, width: 100}
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
			panelSearch.setValues({'DIV_CODE'	:record.get('DIV_CODE')		, 'BILL_NUM'	:record.get('BILL_NUM')
								, 'PAYMENT_TERM':record.get('PAYMENT_TERM')	, 'PAYMENT_DAY'	:record.get('PAYMENT_DAY')});
			
			panelSearch.setValue('TAX_TYPE2', salesNoSearch.getValue('TAX_TYPE2'));
			panelResult.setValue('TAX_TYPE2', salesNoSearch.getValue('TAX_TYPE2'));
			UniAppManager.app.fnExSlipBtn();
			CustomCodeInfo.gsAgentType		= record.get("AGENT_TYPE");		//거래처분류
			CustomCodeInfo.gsCustCreditYn	= record.get("CREDIT_YN");
			CustomCodeInfo.gsUnderCalBase	= record.get("WON_CALC_BAS");	//원미만계산
			CustomCodeInfo.gsTaxCalType		= record.get("TAX_CALC_TYPE");
			CustomCodeInfo.gsRefTaxInout	= record.get("TAX_TYPE");		//세액포함여부
		}
	});
	//검색창 그리드(디테일)
	var salesNomasterGrid = Unilite.createGrid('ssa101ukrvSalesNomasterGrid', {
		store	: salesNoDetailStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: false
		},
		hidden : true,
		columns:  [
			{ dataIndex: 'DIV_CODE'			, width: 100},
			{ dataIndex: 'SALE_CUSTOM_CODE'	, width: 100,hidden:true},
			{ dataIndex: 'CUSTOM_NAME'		, width: 130},
			{ dataIndex: 'ITEM_CODE'		, width: 120},
			{ dataIndex: 'ITEM_NAME'		, width: 166},
			{ dataIndex: 'SPEC'				, width: 100},
			{ dataIndex: 'SALE_DATE'		, width: 80},
			{ dataIndex: 'BILL_TYPE'		, width: 73},
			{ dataIndex: 'SALE_TYPE'		, width: 100,hidden:true},
			{ dataIndex: 'SALE_TYPE_NAME'	, width: 100},
			{ dataIndex: 'SALE_Q'			, width: 86},
			{ dataIndex: 'SALE_TOT_O'		, width: 86},
			{ dataIndex: 'SALE_LOC_AMT_I'	, width: 86},
			{ dataIndex: 'SALE_LOC_EXP_I'	, width: 80},
			{ dataIndex: 'TAX_AMT_O'		, width: 80},
			{ dataIndex: 'SALE_PRSN'		, width: 100,hidden:true},
			{ dataIndex: 'SALE_PRSN_NAME'	, width: 66},
			{ dataIndex: 'BILL_NUM'			, width: 120},
			{ dataIndex: 'PROJECT_NO'		, width: 86},
			{ dataIndex: 'INOUT_NUM'		, width: 100}
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
			panelSearch.uniOpt.inLoading=true;
			panelSearch.setValues({'DIV_CODE':record.get('DIV_CODE'), 'BILL_NUM':record.get('BILL_NUM')});
			panelSearch.setValue('TAX_TYPE2', salesNoSearch.getValue('TAX_TYPE2'));
			panelResult.setValue('TAX_TYPE2', salesNoSearch.getValue('TAX_TYPE2'));
			panelSearch.uniOpt.inLoading=false;
		}
	});
	//검색창 메인
	function openSearchInfoWindow() {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.salesnosearch" default="매출번호검색"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [salesNoSearch, salesNoMasterGrid, salesNomasterGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						var rdoType = salesNoSearch.getValue('RDO_TYPE');
						console.log('rdoType : ',rdoType)
						if(rdoType.RDO_TYPE=='master') {
							salesNoMasterStore.loadStoreRecords();
						} else {
							salesNoDetailStore.loadStoreRecords();
						}
					},
					disabled: false
				},{
					itemId	: 'SalesNoCloseBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
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
						field.fireEvent('changedivcode'			, field, panelSearch.getValue('DIV_CODE'), null, null, "DIV_CODE");
						salesNoSearch.setValue('DIV_CODE'		, panelSearch.getValue('DIV_CODE'));
						salesNoSearch.setValue('SALE_DATE_FR'	, UniDate.get('startOfMonth', panelSearch.getValue('SALE_DATE')));
						salesNoSearch.setValue('SALE_DATE_TO'	, panelSearch.getValue('SALE_DATE'));
						salesNoSearch.setValue('CUSTOM_CODE'	, panelSearch.getValue('SALE_CUSTOM_CODE'));
						salesNoSearch.setValue('CUSTOM_NAME'	, panelSearch.getValue('CUSTOM_NAME'));
						salesNoSearch.setValue('SALE_PRSN'		, panelSearch.getValue('SALE_PRSN'));
						salesNoSearch.setValue('BILL_TYPE'		, panelSearch.getValue('BILL_TYPE'));
						salesNoSearch.setValue('ORDER_TYPE'		, panelSearch.getValue('ORDER_TYPE'));
						salesNoSearch.setValue('DEPT_CODE'		, panelSearch.getValue('DEPT_CODE'));
						salesNoSearch.setValue('DEPT_NAME'		, panelSearch.getValue('DEPT_NAME'));
						salesNoSearch.setValue('TAX_TYPE2'		, panelSearch.getValue('TAX_TYPE2'));
						salesNoSearch.setValue('RDO_TYPE'		, 'master');
						if(salesNomasterGrid) salesNomasterGrid.hide();
						if(salesNoMasterGrid) salesNoMasterGrid.show();
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}



	//수주참조 폼
	var salesOrderSearch = Unilite.createSearchForm('salesOrderForm', {
		layout	: {type : 'uniTable', columns : 3},
		items	: [
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.sales.salesorder" default="수주"/><t:message code="system.label.sales.client" default="고객"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							salesOrderSearch.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							salesOrderSearch.setValue('CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}
		}),{
			fieldLabel		: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DVRY_DATE',
			endFieldName	: 'TO_DVRY_DATE',
			width			: 315
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>',
			name		: 'TAX_INOUT',
			xtype		: 'uniRadiogroup',
			comboType	: 'AU',
			comboCode	: 'B030',
			width		: 235,
			allowBlank	: false
		},
		Unilite.popup('ORDER_NUM',{
			fieldLabel		: '<t:message code="system.label.sales.sono" default="수주번호"/>',
			validateBlank	: true,
			textFieldName	: 'ORDER_NUM',
			itemId			: 'orderNum',
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'CUSTOM_CODE': salesOrderSearch.getValue('CUSTOM_CODE')});
					popup.setExtParam({'DIV_CODE'	: UserInfo.divCode});
				}
			}
		}),
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						salesOrderSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						salesOrderSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			validateBlank	: true,
			textFieldName	: 'PROJECT_NO',
			itemId			: 'project',
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'BPARAM0'	: 3});
					popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('SALE_CUSTOM_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},{
			xtype	: 'uniTextfield',
			name	: 'DIV_CODE',
			hidden	: true
		},{
			xtype	: 'uniTextfield',
			name	: 'MONEY_UNIT',
			hidden	: true
		}]
	});
	//수주참조 모델
	Unilite.defineModel('ssa100ukrvSalesOrderModel', {
		fields: [
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'SER_NO'				, text: '<t:message code="system.label.sales.seq" default="순번"/>'					, type: 'int'},
			{name: 'SO_KIND'			, text: '<t:message code="system.label.sales.ordertype" default="주문구분"/>'			, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'					, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'			, type: 'string', displayField: 'value'},
			{name: 'TRANS_RATE'			, text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			, type: 'uniQty'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'NOT_SALE_Q'			, text: '<t:message code="system.label.sales.undeliveryqty" default="미납량"/>'		, type: 'uniQty'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.sales.soqty" default="수주량"/>'				, type: 'uniQty'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			, type: 'string'},
			//20200103 프로젝트명 추가
			{name: 'PJT_NAME'			, text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>'			, type: 'string', editable: false},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.soplace" default="수주처"/>'				, type: 'string'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string',comboType:'AU', comboCode: 'S010'},
			{name: 'PO_NUM'				, text: '<t:message code="system.label.sales.pono" default="PO번호"/>'				, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: 'CUSTOM_CODE'	, type: 'string'},
			{name: 'OUT_DIV_CODE'		, text: 'OUT_DIV_CODE'	, type: 'string',comboType: "BOR120"},
			{name: 'ORDER_P'			, text: 'ORDER_P'		, type: 'uniUnitPrice'},
			{name: 'ORDER_O'			, text: 'ORDER_O'		, type: 'uniPrice'},
			{name: 'TAX_TYPE'			, text: 'TAX_TYPE'		, type: 'string'},
			{name: 'WH_CODE'			, text: 'WH_CODE'		, type: 'string'},
			{name: 'MONEY_UNIT'			, text: 'MONEY_UNIT'	, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: 'EXCHG_RATE_O'	, type: 'string'},
			{name: 'ACCOUNT_YNC'		, text: '<t:message code="system.label.sales.salessubjectyn" default="매출대상여부"/>'	, type: 'string',comboType:'AU', comboCode: 'S014'},
			{name: 'DISCOUNT_RATE'		, text: 'DISCOUNT_RATE'	, type: 'uniPercent'},
			{name: 'DVRY_CUST_CD'		, text: 'DVRY_CUST_CD'	, type: 'string'},
			{name: 'BILL_TYPE'			, text: 'BILL_TYPE'		, type: 'string'},
			{name: 'ORDER_TYPE'			, text: 'ORDER_TYPE'	, type: 'string'},
			{name: 'PRICE_YN'			, text: 'PRICE_YN'		, type: 'string'},
			{name: 'STOCK_CARE_YN'		, text: 'STOCK_CARE_YN'	, type: 'string'},
			{name: 'STOCK_UNIT'			, text: 'STOCK_UNIT'	, type: 'string'},
			{name: 'DVRY_CUST_NAME'		, text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'		, type: 'string'},
			{name: 'TAX_INOUT'			, text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>'	, type: 'string',comboType:'AU', comboCode: 'B030'},
			{name: 'ORDER_TAX_O'		, text: 'ORDER_TAX_O'	, type: 'string'}
		]
	});
	//수주참조 스토어
	var salesOrderStore = Unilite.createStore('ssa101ukrvSalesOrderStore', {
		model	: 'ssa100ukrvSalesOrderModel',
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
				read: 'ssa100ukrvService.selectSalesOrderList'
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
								if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM']) // record = masterRecord   item = 참조 Record
									&& (record.data['SER_NO'] == item.data['SER_NO'])
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
		loadStoreRecords : function() {
			var param = salesOrderSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//수주참조 그리드
	var salesOrderGrid = Unilite.createGrid('ssa101ukrvSalesorderGrid', {
		store	: salesOrderStore,
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst : false
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns	: [
			{ dataIndex: 'ORDER_NUM'			, width:93,locked: false},
			{ dataIndex: 'SER_NO'				, width:50, locked: false},
			{ dataIndex: 'SO_KIND'				, width:66, hidden:true, locked: false},
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width:80, hidden:true},
			{ dataIndex: 'ITEM_CODE'			, width:160, locked: false},
			{ dataIndex: 'ITEM_NAME'			, width:140},
			{ dataIndex: 'SPEC'					, width:170},
			{ dataIndex: 'ORDER_UNIT'			, width:80},
			{ dataIndex: 'TRANS_RATE'			, width:40},
			{ dataIndex: 'DVRY_DATE'			, width:73},
			{ dataIndex: 'NOT_SALE_Q'			, width:80},
			{ dataIndex: 'ORDER_Q'				, width:80},
			{ dataIndex: 'PROJECT_NO'			, width:86},
			{ dataIndex: 'CUSTOM_NAME'			, width:100},
			{ dataIndex: 'ORDER_PRSN'			, width:80},
			{ dataIndex: 'PO_NUM'				, width:86},
			{ dataIndex: 'CUSTOM_CODE'			, width:66,hidden:true},
			{ dataIndex: 'OUT_DIV_CODE'			, width:66,hidden:true},
			{ dataIndex: 'ORDER_P'				, width:66,hidden:true},
			{ dataIndex: 'ORDER_O'				, width:66,hidden:true},
			{ dataIndex: 'TAX_TYPE'				, width:66,hidden:true},
			{ dataIndex: 'WH_CODE'				, width:66,hidden:true},
			{ dataIndex: 'MONEY_UNIT'			, width:66,hidden:true},
			{ dataIndex: 'EXCHG_RATE_O'			, width:66,hidden:true},
			{ dataIndex: 'ACCOUNT_YNC'			, width:86},
			{ dataIndex: 'DISCOUNT_RATE'		, width:66,hidden:true},
			{ dataIndex: 'DVRY_CUST_CD'			, width:66,hidden:true},
			{ dataIndex: 'BILL_TYPE'			, width:66,hidden:true},
			{ dataIndex: 'ORDER_TYPE'			, width:66,hidden:true},
			{ dataIndex: 'PRICE_YN'				, width:66,hidden:true},
			{ dataIndex: 'STOCK_CARE_YN'		, width:66,hidden:true},
			{ dataIndex: 'STOCK_UNIT'			, width:66,hidden:true},
			{ dataIndex: 'DVRY_CUST_NAME'		, width:86},
			{ dataIndex: 'TAX_INOUT'			, width:66},
			{ dataIndex: 'ORDER_TAX_O'			, width:66,hidden:true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			UniAppManager.app.fnMakeSof100tDataRef(records);
//			Ext.each(records, function(record,i){
//				if(!UniAppManager.app.fnRefCreditCheck()) {
//					detailStore.removeAt(0);
//					return false;
//				}
//				UniAppManager.app.onNewRefDataButtonDown(); //알림창 없는 함수
//				masterGrid.setSalesOrderData(record.data);
//			});
			detailStore.fnSaleAmtSum();
			UniAppManager.app.fnCreditCheck(); //여신액 체크
			this.deleteSelectedRow();
		}
	});
	//수주참조 메인
	function openSalesOrderWindow() {
//		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!panelSearch.setAllFieldsReadOnly(true)){
			return false;
		}
		var field = salesOrderSearch.getField('ORDER_PRSN');
		field.fireEvent('changedivcode'			, field, panelSearch.getValue('DIV_CODE'), null, null, "DIV_CODE");
		salesOrderSearch.setValue('CUSTOM_CODE'	, panelSearch.getValue('SALE_CUSTOM_CODE'));
		salesOrderSearch.setValue('CUSTOM_NAME'	, panelSearch.getValue('CUSTOM_NAME'));
		salesOrderSearch.setValue('ORDER_PRSN'	, panelSearch.getValue('SALE_PRSN'));
		salesOrderSearch.setValue('TO_DVRY_DATE', panelSearch.getValue('SALE_DATE'));
		salesOrderSearch.setValue('FR_DVRY_DATE', UniDate.get('startOfMonth', salesOrderSearch.getValue('TO_DVRY_DATE')));
		salesOrderSearch.setValue('DIV_CODE'	, panelSearch.getValue('DIV_CODE'));
		salesOrderSearch.setValue('TAX_INOUT'	, panelSearch.getValue('TAX_TYPE').TAX_TYPE);
		salesOrderSearch.setValue('MONEY_UNIT'	, panelSearch.getValue('MONEY_UNIT'));
		salesOrderStore.loadStoreRecords();

		if(!referSalesOrderWindow) {
			referSalesOrderWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.sorefer" default="수주참조"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [salesOrderSearch, salesOrderGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						salesOrderStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.salesapply" default="매출적용"/>',
					handler	: function() {
						salesOrderGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.sales.salesapplyclose" default="매출적용후 닫기"/>',
					handler	: function() {
						salesOrderGrid.returnData();
						referSalesOrderWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						if(detailStore.getCount() == 0){
							panelSearch.setAllFieldsReadOnly(false);
							panelResult.setAllFieldsReadOnly(false);
						}
						referSalesOrderWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						salesOrderSearch.clearForm();
						salesOrderGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						salesOrderSearch.clearForm();
						salesOrderGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						if(!UniAppManager.app.fnCreditCheck()) return false;
						salesOrderStore.loadStoreRecords();
					}
				}
			})
		}
		referSalesOrderWindow.center();
		referSalesOrderWindow.show();
	}



	//수주참조(선매출) 폼
	var previousSalesOrderSearch = Unilite.createSearchForm('previousSalesOrderForm', {
		layout	: {type : 'uniTable', columns : 3},
		items	: [
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.sales.salesorder" default="수주"/><t:message code="system.label.sales.client" default="고객"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							previousSalesOrderSearch.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							previousSalesOrderSearch.setValue('CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}
		}),{
			fieldLabel		: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DVRY_DATE',
			endFieldName	: 'TO_DVRY_DATE',
			width			: 315
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>',
			name		: 'TAX_INOUT',
			xtype		: 'uniRadiogroup',
			comboType	: 'AU',
			comboCode	: 'B030',
			width		: 235,
			allowBlank	: false
		},
		Unilite.popup('ORDER_NUM',{
			fieldLabel		: '<t:message code="system.label.sales.sono" default="수주번호"/>',
			validateBlank	: true,
			textFieldName	: 'ORDER_NUM',
			itemId			: 'orderNum',
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'CUSTOM_CODE': previousSalesOrderSearch.getValue('CUSTOM_CODE')});
					popup.setExtParam({'DIV_CODE'	: UserInfo.divCode});
				}
			}
		}),
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						previousSalesOrderSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						previousSalesOrderSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			validateBlank	: true,
			textFieldName	: 'PROJECT_NO',
			itemId			: 'project',
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'BPARAM0'	: 3});
					popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('SALE_CUSTOM_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010'
		},{
			xtype	: 'uniTextfield',
			name	: 'DIV_CODE',
			hidden	: true
		},{
			xtype	: 'uniTextfield',
			name	: 'MONEY_UNIT',
			hidden	: true
		}]
	});
	//수주참조(선매출) 모델
	Unilite.defineModel('ssa100ukrvPreviousSalesOrderModel', {
		fields: [
			{name: 'ORDER_NUM'		, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'SER_NO'			, text: '<t:message code="system.label.sales.seq" default="순번"/>'					, type: 'int'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.sales.spec" default="규격"/>'					, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'			, type: 'string'},
			{name: 'TRANS_RATE'		, text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			, type: 'int'},
			{name: 'DVRY_DATE'		, text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'			, type: 'string'},
			{name: 'NOT_SALE_Q'		, text: '<t:message code="system.label.sales.undeliveryqty" default="미납량"/>'		, type: 'uniQty'},
			{name: 'ORDER_Q'		, text: '<t:message code="system.label.sales.soqty" default="수주량"/>'				, type: 'uniQty'},
			{name: 'PROJECT_NO'		, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			, type: 'string'},
			//20200103 프로젝트명 추가
			{name: 'PJT_NAME'		, text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>'			, type: 'string', editable: false},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.soplace" default="수주처"/>'				, type: 'string'},
			{name: 'ORDER_PRSN'		, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string', comboType:'AU', comboCode: 'S010'},
			{name: 'PO_NUM'			, text: '<t:message code="system.label.sales.pono" default="PO번호"/>'				, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: 'CUSTOM_CODE'			, type: 'string'},
			{name: 'OUT_DIV_CODE'	, text: 'OUT_DIV_CODE'			, type: 'string',comboType: "BOR120"},
			{name: 'ORDER_P'		, text: 'ORDER_P'				, type: 'string'},
			{name: 'ORDER_O'		, text: '<t:message code="system.label.sales.soamount" default="수주액"/>'				, type: 'uniPrice'},
			{name: 'ADVAN_AMOUNT'	, text: '<t:message code="system.label.sales.advancedaramount" default="선매출액"/>'	, type: 'uniPrice'},
			{name: 'NOT_AMOUNT'		, text: '<t:message code="system.label.sales.balanceamount" default="잔여액"/>'		, type: 'uniPrice'},
			{name: 'TAX_TYPE'		, text: 'TAX_TYPE'				, type: 'string'},
			{name: 'WH_CODE'		, text: 'WH_CODE'				, type: 'string'},
			{name: 'MONEY_UNIT'		, text: 'MONEY_UNIT'			, type: 'string'},
			{name: 'EXCHG_RATE_O'	, text: 'EXCHG_RATE_O'			, type: 'string'},
			{name: 'ACCOUNT_YNC'	, text: '<t:message code="system.label.sales.salessubjectyn" default="매출대상여부"/>'	, type: 'string', comboType:'AU', comboCode: 'S014'},
			{name: 'DISCOUNT_RATE'	, text: 'DISCOUNT_RATE'			, type: 'uniPercent'},
			{name: 'DVRY_CUST_CD'	, text: 'DVRY_CUST_CD'			, type: 'string'},
			{name: 'BILL_TYPE'		, text: 'BILL_TYPE'				, type: 'string'},
			{name: 'ORDER_TYPE'		, text: 'ORDER_TYPE'			, type: 'string'},
			{name: 'PRICE_YN'		, text: 'PRICE_YN'				, type: 'string'},
			{name: 'STOCK_CARE_YN'	, text: 'STOCK_CARE_YN'			, type: 'string'},
			{name: 'STOCK_UNIT'		, text: 'STOCK_UNIT'			, type: 'string'},
			{name: 'DVRY_CUST_NAME'	, text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'		, type: 'string'},
			{name: 'TAX_INOUT'		, text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>'	, type: 'string', comboType:'AU', comboCode: 'B030'},
			{name: 'ORDER_TAX_O'	, text: 'ORDER_TAX_O'			, type: 'string'},
			{name: 'INOUT_NUM'		, text: 'INOUT_NUM'				, type: 'string'},
			{name: 'INOUT_SEQ'		, text: 'INOUT_SEQ'				, type: 'int'},
			{name: 'INOUT_DATE'		, text: 'INOUT_DATE'			, type: 'uniDate'}
		]
	});
	//수주참조(선매출) 스토어
	var previousSalesOrderStore = Unilite.createStore('ssa101ukrvPreviousSalesOrderStore', {
		model	: 'ssa100ukrvPreviousSalesOrderModel',
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
				read: 'ssa100ukrvService.selectPreviousSalesOrderList'
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
								if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM']) // record = masterRecord   item = 참조 Record
									&& (record.data['SER_NO'] == item.data['SER_NO'])
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
		loadStoreRecords : function() {
			var param= previousSalesOrderSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//수주참조(선매출) 그리드
	var previousSalesOrderGrid = Unilite.createGrid('ssa101ukrvPreviousSalesOrderGrid', {
		store	: previousSalesOrderStore,
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst : false
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns	: [
			{ dataIndex: 'ORDER_NUM'		, width: 120, locked: false},
			{ dataIndex: 'SER_NO'			, width: 40, locked: false},
			{ dataIndex: 'ITEM_CODE'		, width: 120, locked: false},
			{ dataIndex: 'ITEM_NAME'		, width: 120},
			{ dataIndex: 'SPEC'				, width: 113},
			{ dataIndex: 'ORDER_UNIT'		, width: 66},
			{ dataIndex: 'TRANS_RATE'		, width: 40},
			{ dataIndex: 'DVRY_DATE'		, width: 73},
			{ dataIndex: 'NOT_SALE_Q'		, width: 80},
			{ dataIndex: 'ORDER_Q'			, width: 80},
			{ dataIndex: 'PROJECT_NO'		, width: 86},
			{ dataIndex: 'CUSTOM_NAME'		, width: 100},
			{ dataIndex: 'ORDER_PRSN'		, width: 80},
			{ dataIndex: 'PO_NUM'			, width: 86},
			{ dataIndex: 'CUSTOM_CODE'		, width: 66, hidden: true},
			{ dataIndex: 'OUT_DIV_CODE'		, width: 66, hidden: true},
			{ dataIndex: 'ORDER_P'			, width: 66, hidden: true},
			{ dataIndex: 'ORDER_O'			, width: 86},
			{ dataIndex: 'ADVAN_AMOUNT'		, width: 86},
			{ dataIndex: 'NOT_AMOUNT'		, width: 86},
			{ dataIndex: 'TAX_TYPE'			, width: 66, hidden: true},
			{ dataIndex: 'WH_CODE'			, width: 66, hidden: true},
			{ dataIndex: 'MONEY_UNIT'		, width: 66, hidden: true},
			{ dataIndex: 'EXCHG_RATE_O'		, width: 66, hidden: true},
			{ dataIndex: 'ACCOUNT_YNC'		, width: 86},
			{ dataIndex: 'DISCOUNT_RATE'	, width: 66, hidden: true},
			{ dataIndex: 'DVRY_CUST_CD'		, width: 66, hidden: true},
			{ dataIndex: 'BILL_TYPE'		, width: 66, hidden: true},
			{ dataIndex: 'ORDER_TYPE'		, width: 66, hidden: true},
			{ dataIndex: 'PRICE_YN'			, width: 66, hidden: true},
			{ dataIndex: 'STOCK_CARE_YN'	, width: 66, hidden: true},
			{ dataIndex: 'STOCK_UNIT'		, width: 66, hidden: true},
			{ dataIndex: 'DVRY_CUST_NAME'	, width: 86},
			{ dataIndex: 'TAX_INOUT'		, width: 66},
			{ dataIndex: 'ORDER_TAX_O'		, width: 66, hidden: true},
			{ dataIndex: 'INOUT_NUM'		, width: 66, hidden: true},
			{ dataIndex: 'INOUT_SEQ'		, width: 66, hidden: true},
			{ dataIndex: 'INOUT_DATE'		, width: 66, hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
//				if(!UniAppManager.app.fnRefCreditCheck()) {
//					detailStore.removeAt(0);
//					return false;
//				}
				UniAppManager.app.onNewRefDataButtonDown(); //알림창 없는 함수
				masterGrid.setPreviousSalesOrderData(record.data);
			});
			detailStore.fnSaleAmtSum();
			UniAppManager.app.fnCreditCheck(); //여신액 체크
			this.deleteSelectedRow();
		}
	});
	//수주참조(선매출) 메인
	function openPreviousSalesOrderWindow() {
//		if(!UniAppManager.app.checkForNewDetail()) return false;
//		previousSalesOrderSearch.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
//		previousSalesOrderSearch.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
		if(!panelSearch.setAllFieldsReadOnly(true)){
			return false;
		}
		previousSalesOrderSearch.setValue('TO_DVRY_DATE', panelSearch.getValue('SALE_DATE'));
		previousSalesOrderSearch.setValue('DIV_CODE'	, panelSearch.getValue('DIV_CODE'));
		previousSalesOrderSearch.setValue('TAX_INOUT'	, panelSearch.getValue('TAX_TYPE').TAX_TYPE);
		previousSalesOrderSearch.setValue('MONEY_UNIT'	, panelSearch.getValue('MONEY_UNIT'));
		previousSalesOrderStore.loadStoreRecords();

		if(!referPreviousSalesOrderWindow) {
			referPreviousSalesOrderWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.advancesorefer" default="수주참조(선매출)"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [previousSalesOrderSearch, previousSalesOrderGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						previousSalesOrderStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.salesapply" default="매출적용"/>',
					handler	: function() {
						previousSalesOrderGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.sales.salesapplyclose" default="매출적용후 닫기"/>',
					handler	: function() {
						previousSalesOrderGrid.returnData();
						referPreviousSalesOrderWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						if(detailStore.getCount() == 0){
							panelSearch.setAllFieldsReadOnly(false);
							panelResult.setAllFieldsReadOnly(false);
						}
						referPreviousSalesOrderWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						previousSalesOrderSearch.clearForm();
						previousSalesOrderGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						previousSalesOrderSearch.clearForm();
						previousSalesOrderGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						if(!UniAppManager.app.fnCreditCheck()) return false;
						previousSalesOrderStore.loadStoreRecords();
					}
				}
			})
		}
		referPreviousSalesOrderWindow.center();
		referPreviousSalesOrderWindow.show();
	}



	//출고(미매출)/반품출고참조 폼
	var issueSearch = Unilite.createSearchForm('issueForm', {
		layout	: {type : 'uniTable', columns : 4},
		items	: [{
			fieldLabel		: '<t:message code="system.label.sales.transdate" default="수불일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'INOUT_DATE_FR',
			endFieldName	: 'INOUT_DATE_TO',
			width			: 315
		},
		Unilite.popup('INOUT_NUM',{
			fieldLabel		: '<t:message code="system.label.sales.tranno" default="수불번호"/>',
			validateBlank	: true,
			textFieldName	: 'INOUT_NUM',
			itemId			: 'inoutNum',
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'INOUT_TYPE'	: '2'});
					popup.setExtParam({'DIV_CODE'	: UserInfo.divCode});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>',
			name		: 'TAX_INOUT',
			xtype		: 'uniRadiogroup',
			comboType	: 'AU',
			comboCode	: 'B030',
			width		: 235,
			allowBlank	: false
		},
		Unilite.popup('DELIVERY',{
			fieldLabel		: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>',
			valueFieldName	: 'DELIVERY_CODE',
			textFieldName	: 'DELIVERY_NAME',
			showValue		: false,
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('SALE_CUSTOM_CODE')});
				}
			}
		}),
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						issueSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						issueSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			validateBlank	: true,
			textFieldName	: 'PROJECT_NO',
			itemId			: 'project',
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'BPARAM0': 3});
					popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('SALE_CUSTOM_CODE')});
				}
			}
		}),{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.sales.tranyn" default="수불여부"/>',
			id			: 'INOUT_TYPE',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
				width		: 66,
				name		: 'INOUT_TYPE',
				inputValue	: ''
			},{
				boxLabel	: '<t:message code="system.label.sales.issue" default="출고"/>',
				width		: 66,
				name		: 'INOUT_TYPE',
				inputValue	: '2',
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.sales.return" default="반품"/>',
				width		: 66,
				name		: 'INOUT_TYPE',
				inputValue	: '3'
			}
		]},{
			fieldLabel	: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			child		: 'WH_CELL_CODE',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					store.filterBy(function(item){
						return item.get('option') == issueSearch.getValue('DIV_CODE')
					})
				}
			}
		},
		Unilite.popup('CUST',{
			fieldLabel		: '<t:message code="system.label.sales.issueplace" default="출고처"/>',
			valueFieldName	: 'INOUT_CODE',
			textFieldName	: 'INOUT_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						issueSearch.setValue('INOUT_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						issueSearch.setValue('INOUT_CODE', '');
					}
				}
			}
		}),{
			fieldLabel		: '<t:message code="system.label.sales.issuecharger" default="출고담당"/>',
			name			: 'INOUT_PRSN',
			xtype			: 'uniCombobox',
			comboType		: 'AU',
			comboCode		: 'S010',
			onChangeDivCode	: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.base.taxtype" default="세구분"/>' ,
			name		: 'TAX_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B059'
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>',
			name		: 'WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					store.filterBy(function(item){
						return item.get('option') == issueSearch.getValue('WH_CODE')
							//BSA225T의 CUSTOM_CODE가 비어 있거나 panelResult의 값과 동일한 데이터만 show
							&&(item.get('refCode10') == issueSearch.getValue('INOUT_CODE') || item.get('refCode10') == '*')
					})
				}
			}
		},{
			xtype	: 'uniTextfield',
			name	: 'DIV_CODE',
			hidden	: true
		},{
			xtype	: 'uniTextfield',
			name	: 'CUSTOM_CODE',
			hidden	: true
		},{
			xtype	: 'uniTextfield',
			name	: 'MONEY_UNIT',
			hidden	: true
		}]
	});
	//출고(미매출)/반품출고참조 모델
	Unilite.defineModel('ssa101ukrvISSUEModel', {
		fields: [
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'					, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'			, type: 'string', displayField: 'value'},
			{name: 'NOT_SALE_Q'			, text: '<t:message code="system.label.sales.notbillingqty" default="미매출량"/>'		, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.sales.tranqty" default="수불량"/>'				, type: 'uniQty'},
//			{name: 'INOUT_WGT_Q'		, text: '수불량(중량)'		, type: 'uniQty'},	매출등록(중량, 부피포함용)
//			{name: 'INOUT_VOL_Q'		, text: '수불량(부피)'		, type: 'uniQty'},	매출등록(중량, 부피포함용)
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.sales.price" default="단가"/>'					, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_O'		, text: '<t:message code="system.label.sales.tranamount" default="수불금액"/>'			, type: 'uniPrice'},
			{name: 'INOUT_TAX_AMT'		, text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'			, type: 'uniPrice'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			, type: 'string'},
			//20200103 프로젝트명 추가
			{name: 'PJT_NAME'			, text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>'			, type: 'string', editable: false},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.sales.tranno" default="수불번호"/>'				, type: 'string'},
			{name: 'INOUT_SEQ'			, text: '<t:message code="system.label.sales.seq" default="순번"/>'					, type: 'string'},
			{name: 'INOUT_TYPE'			, text: '<t:message code="system.label.sales.trantype1" default="수불타입"/>'			, type: 'string', comboType: 'AU', comboCode: 'S035'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'		, type: 'string',comboType: "BOR120"},
			{name: 'INOUT_TYPE_DETAIL'	, text: 'INOUT_TYPE_DETAIL' , type: 'string'},
			{name: 'WH_CODE'			, text: 'WH_CODE'			, type: 'string'},
			{name: 'WH_CELL_CODE'		, text: 'WH_CELL_CODE'		, type: 'string'},
			{name: 'TRNS_RATE'			, text: 'TRNS_RATE'			, type: 'string'},
			{name: 'MONEY_UNIT'			, text: 'MONEY_UNIT'		, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: 'EXCHG_RATE_O'		, type: 'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.sales.soseq" default="수주순번"/>'				, type: 'string'},
			{name: 'TAX_TYPE'			, text: 'TAX_TYPE'			, type: 'string'},
			{name: 'DVRY_CUST_CD'		, text: 'DVRY_CUST_CD'		, type: 'string'},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'				, type: 'string'},
			{name: 'PRICE_YN'			, text: 'PRICE_YN'			, type: 'string'},
			{name: 'DISCOUNT_RATE'		, text: 'DISCOUNT_RATE'		, type: 'string'},
			{name: 'STOCK_CARE_YN'		, text: 'STOCK_CARE_YN'		, type: 'string'},
			{name: 'STOCK_UNIT'			, text: 'STOCK_UNIT'		, type: 'string'},
			{name: 'ACCOUNT_YNC'		, text: 'ACCOUNT_YNC'		, type: 'string'},
			{name: 'DVRY_CUST_NAME'		, text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'		, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: 'CUSTOM_CODE'		, type: 'string'},
//			{name: 'CUSTOM_NAME'		, text: 'CUSTOM_NAME'		, type: 'string'}, 2개가 중복
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string', comboType: 'AU', comboCode: 'S010'},
			{name: 'SOF100_TAX_INOUT'	, text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>'	, type: 'string', comboType: 'AU', comboCode: 'B030'},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'			, type: 'uniDate'},
			{name: 'REF_CODE2'			, text: 'REF_CODE2'			, type: 'string'},
			{name: 'AGENT_TYPE'			, text: 'AGENT_TYPE'		, type: 'string'},
//			{name: 'PRICE_TYPE'			, text: 'PRICE_TYPE'		, type: 'string'}, 매출등록(중량, 부피포함용)
//			{name: 'INOUT_FOR_WGT_P'	, text: 'INOUT_FOR_WGT_P'   , type: 'string'},
//			{name: 'INOUT_FOR_VOL_P'	, text: 'INOUT_FOR_VOL_P'   , type: 'string'},
//			{name: 'INOUT_WGT_P'		, text: 'INOUT_WGT_P'		, type: 'string'},
//			{name: 'INOUT_VOL_P'		, text: 'INOUT_VOL_P'		, type: 'string'},
//			{name: 'WGT_UNIT'			, text: 'WGT_UNIT'			, type: 'string'},
//			{name: 'UNIT_WGT'			, text: 'UNIT_WGT'			, type: 'string'},
//			{name: 'VOL_UNIT'			, text: 'VOL_UNIT'			, type: 'string'},
//			{name: 'UNIT_VOL'			, text: 'UNIT_VOL'			, type: 'string'}
			{name: 'REMARK'				, text: '<t:message code="system.label.sales.remarks" default="비고"/>'		, type: 'string'}
		]
	});
	//출고(미매출)/반품출고참조 스토어
	var issueStore = Unilite.createStore('ssa101ukrvIssueStore', {
		model	: 'ssa101ukrvISSUEModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'ssa100ukrvService.selectIssueList'
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
								if( (record.data['INOUT_NUM'] == item.data['INOUT_NUM']) // record = masterRecord   item = 참조 Record
									&& (record.data['INOUT_SEQ'] == item.data['INOUT_SEQ'])
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
		loadStoreRecords : function() {
			var param= issueSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//출고(미매출)/반품출고참조 그리드
	var issueGrid = Unilite.createGrid('ssa101ukrvIssueGrid', {
		store	: issueStore,
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst : false
		},
		//20191113 합계 구하는 로직 추가
		tbar	: [{
			fieldLabel		: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>',
			xtype			: 'uniNumberfield',
			type			: 'uniPrice',
			itemId			: 'SUM_SALE_AMT_O',
			width			: 150,
			labelWidth		: 55,
			value			: 0,
			readOnly		: true
		},'->',{
			fieldLabel		: '<t:message code="system.label.sales.taxamount" default="세액"/>',
			xtype			: 'uniNumberfield',
			type			: 'uniPrice',
			itemId			: 'SUM_TAX_AMT_O',
			width			: 120,
			labelWidth		: 30,
			value			: 0,
			readOnly		: true
		},'->',{
			fieldLabel		: '<t:message code="system.label.sales.totalamount" default="합계"/>',
			xtype			: 'uniNumberfield',
			type			: 'uniPrice',
			itemId			: 'TOTAL_SUM',
			width			: 120,
			labelWidth		: 30,
			value			: 0,
			readOnly		: true
		},'->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','-'],
		selModel:  Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns	: [
			{ dataIndex: 'ITEM_CODE'			, width:120, locked: false},
			{ dataIndex: 'ITEM_NAME'			, width:200},
			{ dataIndex: 'SPEC'					, width:150},
			{ dataIndex: 'ORDER_UNIT'			, width:80 , align:'center'},
			{ dataIndex: 'INOUT_DATE'			, width:80},
			{ dataIndex: 'NOT_SALE_Q'			, width:100},
			{ dataIndex: 'ORDER_UNIT_Q'			, width:100},
//			{ dataIndex: 'INOUT_WGT_Q'			, width:80},	매출등록(중량, 부피포함용)
//			{ dataIndex: 'INOUT_VOL_Q'			, width:80},	매출등록(중량, 부피포함용)
			{ dataIndex: 'ORDER_UNIT_P'			, width:120},
			{ dataIndex: 'ORDER_UNIT_O'			, width:120},
			{ dataIndex: 'INOUT_TAX_AMT'		, width:120},
			{ dataIndex: 'ORDER_NUM'			, width:120},
			{ dataIndex: 'ORDER_SEQ'			, width:66 , align:'center'},
			{ dataIndex: 'ORDER_PRSN'			, width:86, align:'center'},
			{ dataIndex: 'PROJECT_NO'			, width:100},
			{ dataIndex: 'INOUT_NUM'			, width:120},
			{ dataIndex: 'INOUT_SEQ'			, width:50 , align:'center'},
			{ dataIndex: 'INOUT_TYPE'			, width:60 , align:'center'},
			{ dataIndex: 'CUSTOM_NAME'			, width:120},
			{ dataIndex: 'DIV_CODE'				, width:86},
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width:66,hidden:true},
			{ dataIndex: 'WH_CODE'				, width:66,hidden:true},
			{ dataIndex: 'WH_CELL_CODE'			, width:66,hidden:true},
			{ dataIndex: 'TRNS_RATE'			, width:66,hidden:true},
			{ dataIndex: 'MONEY_UNIT'			, width:66,hidden:true},
			{ dataIndex: 'EXCHG_RATE_O'			, width:66,hidden:true},
			{ dataIndex: 'TAX_TYPE'				, width:70,hidden:true},
			{ dataIndex: 'DVRY_CUST_CD'			, width:100,hidden:true},
			{ dataIndex: 'LOT_NO'				, width:66},
			{ dataIndex: 'PRICE_YN'				, width:66,hidden:true},
			{ dataIndex: 'DISCOUNT_RATE'		, width:66,hidden:true},
			{ dataIndex: 'STOCK_CARE_YN'		, width:66,hidden:true},
			{ dataIndex: 'STOCK_UNIT'			, width:66,hidden:true},
			{ dataIndex: 'ACCOUNT_YNC'			, width:66,hidden:true},
			{ dataIndex: 'DVRY_CUST_NAME'		, width:86 , align:'center'},
			{ dataIndex: 'CUSTOM_CODE'			, width:86,hidden:true},
//			{ dataIndex: 'CUSTOM_NAME'			, width:133,hidden:true}, 2개가 중복
			{ dataIndex: 'SOF100_TAX_INOUT'		, width:100},
			{ dataIndex: 'REF_CODE2'			, width:66,hidden:true},
			{ dataIndex: 'AGENT_TYPE'			, width:66,hidden:true},
//			{ dataIndex: 'PRICE_TYPE'			, width:66},  매출등록(중량, 부피포함용)
//			{ dataIndex: 'INOUT_FOR_WGT_P'		, width:66},
//			{ dataIndex: 'INOUT_FOR_VOL_P'		, width:66},
//			{ dataIndex: 'INOUT_WGT_P'			, width:66},
//			{ dataIndex: 'INOUT_VOL_P'			, width:66},
//			{ dataIndex: 'WGT_UNIT'				, width:66},
//			{ dataIndex: 'UNIT_WGT'				, width:66},
//			{ dataIndex: 'VOL_UNIT'				, width:66},
//			{ dataIndex: 'UNIT_VOL'				, width:66}
			{ dataIndex: 'REMARK'				, width:300}
		],
		listeners: {
			select: function(grid, selectRecord, index, rowIndex, eOpts ) {
				//20191113 합계 구하는 로직 추가
				fnRefGridSum();
			},
			deselect:  function(grid, selectRecord, index, eOpts ) {
				//20191113 합계 구하는 로직 추가
				fnRefGridSum();
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
//			Ext.each(records, function(record,i){
//				if(!UniAppManager.app.fnRefCreditCheck()) {
//					detailStore.removeAt(0);
//					return false;
//				}
//				UniAppManager.app.onNewRefDataButtonDown(); //알림창 없는 함수
//				masterGrid.setIssueData(record.data);
//			});
			UniAppManager.app.fnMakeIssueDataRef(records);
			detailStore.fnSaleAmtSum();
			UniAppManager.app.fnCreditCheck(); //여신액 체크
			this.deleteSelectedRow();
		}
	});
	//출고(미매출)/반품출고참조 메인
	function openIssueWindow() {
		if(!panelSearch.setAllFieldsReadOnly(true)){
			return false;
		}
		var field = issueSearch.getField('INOUT_PRSN');
		field.fireEvent('changedivcode', field, panelSearch.getValue('DIV_CODE'), null, null, "DIV_CODE");
		var field = salesOrderSearch.getField('ORDER_PRSN');
		field.fireEvent('changedivcode', field, panelSearch.getValue('DIV_CODE'), null, null, "DIV_CODE");
		//issueSearch.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
		//issueSearch.setValue('CUSTOM_CODE', panelSearch.getValue('SALE_CUSTOM_CODE'));
		//issueSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));
		//issueSearch.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth', issueSearch.getValue('INOUT_DATE_TO')));
		//issueSearch.setValue('TAX_INOUT', panelSearch.getValue('TAX_TYPE').TAX_TYPE);
		//issueSearch.setValue('INOUT_CODE', panelSearch.getValue('SALE_CUSTOM_CODE'));
		//issueSearch.setValue('INOUT_NAME', panelSearch.getValue('CUSTOM_NAME'));
		//issueSearch.setValue('MONEY_UNIT', panelSearch.getValue('MONEY_UNIT'));

		issueSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
		issueSearch.setValue('CUSTOM_CODE'	, panelResult.getValue('SALE_CUSTOM_CODE'));
		issueSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));
		issueSearch.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth', issueSearch.getValue('INOUT_DATE_TO')));
		issueSearch.setValue('TAX_INOUT'	, panelResult.getValue('TAX_TYPE').TAX_TYPE);
		issueSearch.setValue('INOUT_CODE'	, panelResult.getValue('SALE_CUSTOM_CODE'));
		issueSearch.setValue('INOUT_NAME'	, panelResult.getValue('CUSTOM_NAME'));
		issueSearch.setValue('MONEY_UNIT'	, panelResult.getValue('MONEY_UNIT'));

		issueStore.loadStoreRecords();

		if(!referIssueWindow) {
			referIssueWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.issuereturnrefer" default="출고(미매출)/반품출고참조"/>',
				width	: 1180,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [issueSearch, issueGrid],
				tbar	: ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
						handler: function() {
							issueStore.loadStoreRecords();
						},
						disabled: false
					},
					{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.sales.salesapply" default="매출적용"/>',
						handler: function() {
							issueGrid.returnData();
						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.sales.salesapplyclose" default="매출적용후 닫기"/>',
						handler: function() {
							issueGrid.returnData();
							referIssueWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.sales.close" default="닫기"/>',
						handler: function() {
							if(detailStore.getCount() == 0){
								panelSearch.setAllFieldsReadOnly(false);
								panelResult.setAllFieldsReadOnly(false);
							}
							referIssueWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						issueSearch.clearForm();
						issueGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						issueSearch.clearForm();
						issueGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						if(!UniAppManager.app.fnCreditCheck()) return false;
						//20191209 추가

						var dtValue = UniDate.getDbDateStr(panelResult.getValue('SALE_DATE'));
						var dtValue_Y = dtValue.substring(0,4);
						var dtValue_M = dtValue.substring(4,6);
						var calcDateF =  UniDate.getDbDateStr(new Date(dtValue_Y, dtValue_M-1, 1));
						var calcDateT =  UniDate.getDbDateStr(new Date(dtValue_Y, dtValue_M, 0));

						issueSearch.setValue('INOUT_DATE_FR',calcDateF);
						issueSearch.setValue('INOUT_DATE_TO',calcDateT);

						issueGrid.down('#SUM_SALE_AMT_O').setValue(0);
						issueGrid.down('#SUM_TAX_AMT_O').setValue(0);
						issueGrid.down('#TOTAL_SUM').setValue(0);

						issueStore.loadStoreRecords();
					}
				}
			})
		}
		referIssueWindow.center();
		referIssueWindow.show();
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
		},
		panelSearch
		],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			} else{
				this.setDefault();
				if(params && params.BILL_NUM){
					panelSearch.setValue('BILL_NUM', params.BILL_NUM);
					panelResult.setValue('BILL_NUM', params.BILL_NUM);
				}
			}
			//20190906 추가
			UniAppManager.app.fnExSlipBtn();
			//20200629 추가
			fnControlPurchDocField(panelResult.getValue('ORDER_TYPE'));
		},// 링크로 넘어오는 params 받는 부분
		processParams: function(params) {
			// this.uniOpt.appParams = params;
			if(params.PGM_ID == 'ssa450skrv' || params.PGM_ID == 'ssa615skrv'){	//20210331 추가: 거래처원장 조회(매출/매입) 추가
				if(!Ext.isEmpty(params.BILL_NUM)){
					panelSearch.setValue('BILL_NUM',params.BILL_NUM);
					panelResult.setValue('BILL_NUM',params.BILL_NUM);
					panelSearch.setValue('DIV_CODE',params.DIV_CODE);
					panelResult.setValue('DIV_CODE',params.DIV_CODE);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},
		onQueryButtonDown: function() {
//			panelSearch.setAllFieldsReadOnly(false);
//			panelResult.setAllFieldsReadOnly(false);
			var billNo = panelSearch.getValue('BILL_NUM');
			if(Ext.isEmpty(billNo)) {
				openSearchInfoWindow()
			} else {
				isLoad = true;
				var param= panelSearch.getValues();
				panelSearch.uniOpt.inLoading=true;
				panelSearch.getForm().load({
					params: param,
					success:function(form, action) {
						panelResult.setValue('SALE_CUSTOM_CODE'	, panelSearch.getValue('SALE_CUSTOM_CODE'));
						panelResult.setValue('CUSTOM_NAME'		, panelSearch.getValue('CUSTOM_NAME'));
						panelResult.setValue('DEPT_CODE'		, panelSearch.getValue('DEPT_CODE'));
						panelResult.setValue('DEPT_NAME'		, panelSearch.getValue('DEPT_NAME'));

						//20200218 주석
//						panelSearch.getField('BILL_TYPE').holdable	= 'hold';	//부가세유형 readOnly여부 (검색으로 올시 readonly)
//						panelResult.getField('BILL_TYPE').holdable	= 'hold';	//부가세유형 readOnly여부 (검색으로 올시 readonly)
//						panelSearch.getField('ORDER_TYPE').holdable	= 'hold';	//판매유형 readOnly여부  (검색으로 올시 readonly)

						panelSearch.setAllFieldsReadOnly(true);
						panelResult.setAllFieldsReadOnly(true);
						panelSearch.setValue('TOT_AMT', panelSearch.getValue('TOT_SALE_TAX_O') + panelSearch.getValue('TOT_TAX_AMT') + panelSearch.getValue('TOT_SALE_EXP_O')+ panelSearch.getValue('TOT_SALE_ZERO_O'));
						action.result.data.TAX_TYPE == '1' ? gsTaxInout = '1' : gsTaxInout = '2';
						gsAcDate = action.result.data.AC_DATE;
						gsSaveRefFlag = 'Y';
						if(CustomCodeInfo.gsCustCreditYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
							//여신액 구하기
							var divCode		= UserInfo.divCode;
							var CustomCode	= panelSearch.getValue('SALE_CUSTOM_CODE');
							var saleDate	= panelSearch.getField('SALE_DATE').getSubmitValue()
							var moneyUnit	= BsaCodeInfo.gsMoneyUnit;
							//마스터폼에 여신액 set
							UniAppManager.app.fnGetCustCredit(divCode, CustomCode, saleDate, moneyUnit);
						}

						// 20210222 : 부가세유형이 카드매출인 경우 카드사 readonly 비활성
						if('40' == panelSearch.getValue('BILL_TYPE')){
							panelSearch.getField('CARD_CUSTOM_CODE').setReadOnly(false);
							panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(false);
						} else {
							panelSearch.getField('CARD_CUSTOM_CODE').setReadOnly(true);
							panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(true);
						}

						UniAppManager.app.fnExSlipBtn();
						panelSearch.uniOpt.inLoading=false;
						detailStore.loadStoreRecords();
					},
					failure: function(form, action) {
						panelSearch.uniOpt.inLoading=false;
						UniAppManager.app.fnExSlipBtn();
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
			} else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(!Ext.isEmpty(panelSearch.getValue('EX_NUM')) && panelSearch.getValue('EX_NUM') != "0"){
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
			// fnOrderAmtSum 호출(grid summary 이용)
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
							Unilite.messageBox('<t:message code="system.message.sales.message054" default="마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다."/>'); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
							return false;
						}
						if(!Ext.isEmpty(panelSearch.getValue('EX_NUM')) && panelSearch.getValue('EX_NUM') != "0"){
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
							UniAppManager.app.onSaveDataButtonDown();
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
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
				Unilite.messageBox('<t:message code="system.message.sales.message054" default="마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다."/>'); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
				return false;
			}
			if(!this.fnCreditCheck()) return false; //여신액 체크
			if(!Ext.isEmpty(panelSearch.getValue('EX_NUM')) && panelSearch.getValue('EX_NUM') != '0'){
				Unilite.messageBox('<t:message code="system.message.sales.message079" default="자동기표처리된 매출정보건에 대해서는 매출내역을 추가할 수 없습니다."/>');//자동기표처리된 매출정보건에 대해서는 매출내역을 추가할 수 없습니다.
				return false
			}
			//Detail Grid Default 값 설정
			var billSeq = detailStore.max('BILL_SEQ');
			if(!billSeq) billSeq = 1;
			else  billSeq += 1;

			var billNum = '';
			if(!Ext.isEmpty(panelSearch.getValue('BILL_NUM'))) {
				billNum = panelSearch.getValue('BILL_NUM');
			}

			var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
			var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2

			var outDivCode = '';
			if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))) {
				outDivCode = panelSearch.getValue('DIV_CODE');
			}

			var billType = '';
			if(!Ext.isEmpty(panelSearch.getValue('BILL_TYPE'))) {
				if(panelSearch.getValue('BILL_TYPE') != '50'){
					billType = '1'
				} else{
					billType = '2'
				}
			}

			var divCode = '';
			if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))) {
				divCode = panelSearch.getValue('DIV_CODE');
			}

			var salePrsn = '';
			if(!Ext.isEmpty(panelSearch.getValue('SALE_PRSN'))) {
				salePrsn = panelSearch.getValue('SALE_PRSN');
			}

			var customCode = '';
			if(!Ext.isEmpty(panelSearch.getValue('SALE_CUSTOM_CODE'))) {
				customCode = panelSearch.getValue('SALE_CUSTOM_CODE');
			}

			var saleDate = '';
			if(!Ext.isEmpty(panelSearch.getValue('SALE_DATE'))) {
				saleDate = panelSearch.getValue('SALE_DATE');
			}

			var refBillType = '';
			if(!Ext.isEmpty(panelSearch.getValue('BILL_TYPE'))) {
				refBillType = panelSearch.getValue('BILL_TYPE');
			}

			var cardCustCd = '';
			if(!Ext.isEmpty(panelSearch.getValue('CARD_CUST_CD'))) {
				cardCustCd = panelSearch.getValue('CARD_CUST_CD');
			}

			var saleType = '';
			if(!Ext.isEmpty(panelSearch.getValue('ORDER_TYPE'))) {
				saleType = panelSearch.getValue('ORDER_TYPE');
			}

			var projectNo = '';
			var projectNM = '';
			if(!Ext.isEmpty(panelSearch.getValue('PROJECT_NO'))) {
				projectNo = panelSearch.getValue('PROJECT_NO');
				//20200103 추가: 프로젝트명 가져오기 위해 추가
				projectNM = panelSearch.getValue('PJT_NAME');
			}

			var texInout = '';
			if(!Ext.isEmpty(panelSearch.getValue('TAX_TYPE').TAX_TYPE)) {
				texInout = panelSearch.getValue('TAX_TYPE').TAX_TYPE;
			}

			var remark = '';
			if(!Ext.isEmpty(panelSearch.getValue('REMARK'))) {
				remark = panelSearch.getValue('REMARK');
			}

			var exNum = '';
			if(!Ext.isEmpty(panelSearch.getValue('EX_NUM'))) {
				exNum = panelSearch.getValue('EX_NUM');
			}

			var moneyUnit = '';
			if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT'))) {
				moneyUnit = panelSearch.getValue('MONEY_UNIT');
			}

			var exchgRateO = '';
			if(!Ext.isEmpty(panelSearch.getValue('EXCHG_RATE_O'))) {
				exchgRateO = panelSearch.getValue('EXCHG_RATE_O');
			}

			var srcCustomCode = '';
			if(!Ext.isEmpty(panelSearch.getValue('SALE_CUSTOM_CODE'))) {
				srcCustomCode = panelSearch.getValue('SALE_CUSTOM_CODE');
			}

			var srcCustomName = '';
			if(!Ext.isEmpty(panelSearch.getValue('CUSTOM_NAME'))) {
				srcCustomName = panelSearch.getValue('CUSTOM_NAME');
			}

			var srcOrderPrsn = '';
			if(!Ext.isEmpty(panelSearch.getValue('SALE_PRSN'))) {
				srcOrderPrsn = panelSearch.getValue('SALE_PRSN');
			}

			var deptCode = '';
			if(!Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))) {
				deptCode = panelSearch.getValue('DEPT_CODE');
			}

			var whCode = '';
			if(!Ext.isEmpty(panelSearch.getValue('WH_CODE'))) {
				whCode = panelSearch.getValue('WH_CODE');
			}

			var compCode = UserInfo.compCode;

			//20190731 누락된 데이터 추가
			var advanYn		= 'N';

			var r = {
				ADVAN_YN			: advanYn,
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
				//20200103 추가: 프로젝트명 가져오기 위해 추가
				PJT_NAME			: projectNM,
				REF_TAX_INOUT		: texInout.TAX_TYPE,
				REF_REMARK			: remark,
				REF_EX_NUM			: exNum,
				REF_MONEY_UNIT		: moneyUnit,
				REF_EXCHG_RATE_O	: exchgRateO,
				SRC_CUSTOM_CODE		: srcCustomCode,
				SRC_CUSTOM_NAME		: srcCustomName,
				SRC_ORDER_PRSN		: srcOrderPrsn,
				COMP_CODE			: compCode,
				DEPT_CODE			: deptCode,
				WH_CODE				: whCode
			};
//			masterGrid.createRow(r, null, masterGrid.getStore().getCount() - 1);
			masterGrid.createRow(r);
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
			detailStore.fnSaleAmtSum();
			UniAppManager.app.fnCreditCheck(); //여신액 체크
			isOnNew = false;
		},
		onNewRefDataButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			if(!Ext.isEmpty(panelSearch.getValue('EX_NUM')) && panelSearch.getValue('EX_NUM') != '0'){
				Unilite.messageBox('<t:message code="system.message.sales.message079" default="자동기표처리된 매출정보건에 대해서는 매출내역을 추가할 수 없습니다."/>');//자동기표처리된 매출정보건에 대해서는 매출내역을 추가할 수 없습니다.
				return false
			}
			/**
			* Detail Grid Default 값 설정
			*/
			var billSeq = detailStore.max('BILL_SEQ');
			if(!billSeq) billSeq = 1;
			else  billSeq += 1;

			var billNum = '';
			if(!Ext.isEmpty(panelSearch.getValue('BILL_NUM'))) {
				billNum = panelSearch.getValue('BILL_NUM');
			}

			var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
			var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2

			var outDivCode = '';
			if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))) {
				outDivCode = panelSearch.getValue('DIV_CODE');
			}

			var billType = '';
			if(!Ext.isEmpty(panelSearch.getValue('BILL_TYPE'))) {
				if(panelSearch.getValue('BILL_TYPE') != '50'){
					billType = '1'
				} else{
					billType = '2'
				}
			}

			var divCode = '';
			if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))) {
				divCode = panelSearch.getValue('DIV_CODE');
			}

			var salePrsn = '';
			if(!Ext.isEmpty(panelSearch.getValue('SALE_PRSN'))) {
				salePrsn = panelSearch.getValue('SALE_PRSN');
			}

			var customCode = '';
			if(!Ext.isEmpty(panelSearch.getValue('SALE_CUSTOM_CODE'))) {
				customCode = panelSearch.getValue('SALE_CUSTOM_CODE');
			}

			var saleDate = '';
			if(!Ext.isEmpty(panelSearch.getValue('SALE_DATE'))) {
				saleDate = panelSearch.getValue('SALE_DATE');
			}

			var refBillType = '';
			if(!Ext.isEmpty(panelSearch.getValue('BILL_TYPE'))) {
				refBillType = panelSearch.getValue('BILL_TYPE');
			}

			var cardCustCd = '';
			if(!Ext.isEmpty(panelSearch.getValue('CARD_CUST_CD'))) {
				cardCustCd = panelSearch.getValue('CARD_CUST_CD');
			}

			var saleType = '';
			if(!Ext.isEmpty(panelSearch.getValue('ORDER_TYPE'))) {
				saleType = panelSearch.getValue('ORDER_TYPE');
			}

			var projectNo = '';
			if(!Ext.isEmpty(panelSearch.getValue('PROJECT_NO'))) {
				projectNo = panelSearch.getValue('PROJECT_NO');
			}

			var texInout = '';
			if(!Ext.isEmpty(panelSearch.getValue('TAX_TYPE').TAX_TYPE)) {
				texInout = panelSearch.getValue('TAX_TYPE').TAX_TYPE;
			}

			var remark = '';
			if(!Ext.isEmpty(panelSearch.getValue('REMARK'))) {
				remark = panelSearch.getValue('REMARK');
			}

			var exNum = '';
			if(!Ext.isEmpty(panelSearch.getValue('EX_NUM'))) {
				exNum = panelSearch.getValue('EX_NUM');
			}

			var moneyUnit = '';
			if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT'))) {
				moneyUnit = panelSearch.getValue('MONEY_UNIT');
			}

			var exchgRateO = '';
			if(!Ext.isEmpty(panelSearch.getValue('EXCHG_RATE_O'))) {
				exchgRateO = panelSearch.getValue('EXCHG_RATE_O');
			}

			var srcCustomCode = '';
			if(!Ext.isEmpty(panelSearch.getValue('SALE_CUSTOM_CODE'))) {
				srcCustomCode = panelSearch.getValue('SALE_CUSTOM_CODE');
			}

			var srcCustomName = '';
			if(!Ext.isEmpty(panelSearch.getValue('CUSTOM_NAME'))) {
				srcCustomName = panelSearch.getValue('CUSTOM_NAME');
			}

			var srcOrderPrsn = '';
			if(!Ext.isEmpty(panelSearch.getValue('SALE_PRSN'))) {
				srcOrderPrsn = panelSearch.getValue('SALE_PRSN');
			}

			var whCode = '';
			if(!Ext.isEmpty(panelSearch.getValue('WH_CODE'))) {
				whCode = panelSearch.getValue('WH_CODE');
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
				REF_TAX_INOUT		: texInout.TAX_TYPE,
				REF_REMARK			: remark,
				REF_EX_NUM			: exNum,
				REF_MONEY_UNIT		: moneyUnit,
				REF_EXCHG_RATE_O	: exchgRateO,
				SRC_CUSTOM_CODE		: srcCustomCode,
				SRC_CUSTOM_NAME		: srcCustomName,
				SRC_ORDER_PRSN		: srcOrderPrsn,
				COMP_CODE			: compCode,
				WH_CODE				: whCode
			};
			masterGrid.createRow(r);
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
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
			if(!UniAppManager.app.fnCreditCheck('Y')) return false; //여신액 체크

			if(!detailStore.isDirty()) {
				if(panelSearch.isDirty()) {
					UniAppManager.app.fnMasterSave();
				}
			} else {
				detailStore.saveStore();
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			} else {
				as.hide()
			}
		},
		setDefault: function() {
			gsMonClosing = '';	//월마감 여부
			gsDayClosing = '';	//일마감 여부
			glSubCdTotCnt = '';
			gsOldRefCode2 = '';
			gsAcDate = '';
			//거래처 정보
			CustomCodeInfo.gsAgentType = '';
			CustomCodeInfo.gsCustCreditYn = '';
			CustomCodeInfo.gsUnderCalBase = '';
			CustomCodeInfo.gsTaxCalType = '';
			CustomCodeInfo.gsRefTaxInout = '';

			/*영업담당 filter set*/
			//20190731 임시 주석
//			var field = panelSearch.getField('SALE_PRSN');
//			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
//			field = panelResult.getField('SALE_PRSN');
//			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			var param = {
				"DIV_CODE": UserInfo.divCode,
				"DEPT_CODE": UserInfo.deptCode
			};
			ssa100ukrvService.deptWhcode(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE', provider['WH_CODE']);
				}
			});

			//20200218 주석
//			panelSearch.getField('BILL_TYPE').holdable = '';	//부가세유형 readOnly여부 (검색으로 올시 readonly)
//			panelSearch.getField('ORDER_TYPE').holdable = '';	//판매유형 readOnly여부  (검색으로 올시 readonly)
//			panelResult.getField('BILL_TYPE').holdable = '';	//부가세유형 readOnly여부 (검색으로 올시 readonly)

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('SALE_DATE', UniDate.get('today'));
			panelSearch.setValue('BILL_TYPE', '10');
			panelSearch.setValue('ORDER_TYPE', '20');
			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);

			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('SALE_DATE', UniDate.get('today'));
			panelResult.setValue('BILL_TYPE', '10');
			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME', UserInfo.deptName);

			panelSearch.setValue('TOT_SALE_TAX_O', 0);	//과세총액(1)
			panelSearch.setValue('TOT_TAX_AMT', 0);		//세액 합계(2)
			panelSearch.setValue('TOT_SALE_EXP_O', 0);	//면세 총액(3)
			panelSearch.setValue('TOT_AMT', 0);//총액[(1)+(2)+(3)
			panelSearch.setValue('TOT_REM_CREDIT_I', 0); //여신잔액
			panelSearch.setValue('EXCHG_RATE_O', 1);		//환율

			panelResult.setValue('EXCHG_RATE_O', 1);		//환율

			//20191113 로그인한 유저의 영업담당 가져오는 로직 추가
			panelSearch.setValue('SALE_PRSN', BsaCodeInfo.gsSalesPrsn);		//영업담당
			panelResult.setValue('SALE_PRSN', BsaCodeInfo.gsSalesPrsn);		//영업담당

			gsTaxInout = '1';
			gsSaveRefFlag = 'N';//

			panelResult.setValue('TOT_SALE_TAX_O', 0);	//과세총액(1)
			panelResult.setValue('TOT_TAX_AMT', 0);	 //세액 합계(2)
			panelResult.setValue('TOT_SALE_EXP_O', 0);   //면세 총액(3)
			panelResult.setValue('TOT_AMT', 0);		 //총액[(1)+(2)+(3)

			panelSearch.getField('TOT_SALE_TAX_O').setReadOnly(true);
			panelSearch.getField('TOT_TAX_AMT').setReadOnly(true);
			panelSearch.getField('TOT_SALE_EXP_O').setReadOnly(true);
			panelSearch.getField('TOT_AMT').setReadOnly(true);
			panelSearch.getField('EX_DATE').setReadOnly(true);
			panelSearch.getField('EX_NUM').setReadOnly(true);

			panelResult.getField('TOT_SALE_TAX_O').setReadOnly(true);
			panelResult.getField('TOT_TAX_AMT').setReadOnly(true);
			panelResult.getField('TOT_SALE_EXP_O').setReadOnly(true);
			panelResult.getField('TOT_AMT').setReadOnly(true);

			var orderType = panelSearch.getField('ORDER_TYPE');
			orderType.select(orderType.getStore().getAt(0));
			orderType = panelResult.getField('ORDER_TYPE');
			orderType.select(orderType.getStore().getAt(0));

			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();

			if(BsaCodeInfo.gsSaleAutoYN == "Y"){ //수주참조창 hide 여부
				masterGrid.down().down('#salesOrderBtn').show();
			} else {
				masterGrid.down().down('#salesOrderBtn').hide();
			}
			UniAppManager.setToolbarButtons('save', false);

			//숫자포맷 공통코드에 맞게 변경 (20180912)
			var length = Ext.isEmpty(UniFormat.Price.split('.')[1]) ? 0 : UniFormat.Price.split('.')[1].length;
			Ext.getCmp('P_TOT_SALE_TAX_O').setConfig('decimalPrecision',length);
			Ext.getCmp('P_TOT_SALE_TAX_O').focus();
			Ext.getCmp('P_TOT_SALE_TAX_O').blur();

			Ext.getCmp('P_TOT_TAX_AMT').setConfig('decimalPrecision',length);
			Ext.getCmp('P_TOT_TAX_AMT').focus();
			Ext.getCmp('P_TOT_TAX_AMT').blur();

			Ext.getCmp('P_TOT_SALE_EXP_O').setConfig('decimalPrecision',length);
			Ext.getCmp('P_TOT_SALE_EXP_O').focus();
			Ext.getCmp('P_TOT_SALE_EXP_O').blur();

			Ext.getCmp('P_TOT_AMT').setConfig('decimalPrecision',length);
			Ext.getCmp('P_TOT_AMT').focus();
			Ext.getCmp('P_TOT_AMT').blur();

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

			Ext.getCmp('M_TOT_SALE_ZERO_O').setConfig('decimalPrecision',length);
			Ext.getCmp('M_TOT_SALE_ZERO_O').focus();
			Ext.getCmp('M_TOT_SALE_ZERO_O').blur();

			Ext.getCmp('P_TOT_SALE_ZERO_O').setConfig('decimalPrecision',length);
			Ext.getCmp('P_TOT_SALE_ZERO_O').focus();
			Ext.getCmp('P_TOT_SALE_ZERO_O').blur();

			Ext.getCmp('M_TOT_SALE_SUPPLY_O').setConfig('decimalPrecision',length);
			Ext.getCmp('M_TOT_SALE_SUPPLY_O').focus();
			Ext.getCmp('M_TOT_SALE_SUPPLY_O').blur();

			Ext.getCmp('P_TOT_SALE_SUPPLY_O').setConfig('decimalPrecision',length);
			Ext.getCmp('P_TOT_SALE_SUPPLY_O').focus();
			Ext.getCmp('P_TOT_SALE_SUPPLY_O').blur();

			//masterGrid.getColumn("SALE_P").setConfig('format',UniFormat.Price);
			//masterGrid.getColumn("SALE_P").setConfig('decimalPrecision',6);
			masterGrid.getColumn("SALE_AMT_O").setConfig('format',UniFormat.Price);
			masterGrid.getColumn("SALE_AMT_O").setConfig('decimalPrecision',length);
			masterGrid.getColumn("TAX_AMT_O").setConfig('format',UniFormat.Price);
			masterGrid.getColumn("TAX_AMT_O").setConfig('decimalPrecision',length);
			masterGrid.getColumn("ORDER_O_TAX_O").setConfig('format',UniFormat.Price);
			masterGrid.getColumn("ORDER_O_TAX_O").setConfig('decimalPrecision',length);
			masterGrid.getColumn("SALE_LOC_AMT_I").setConfig('format',UniFormat.Price);
			masterGrid.getColumn("SALE_LOC_AMT_I").setConfig('decimalPrecision',length);
		},
		fnGetCustCredit: function(divCode, customCode, sDate, moneyUnit){
			var param = {"DIV_CODE": divCode, "CUSTOM_CODE": customCode, "SALE_DATE": sDate, "MONEY_UNIT": moneyUnit}
			ssa100ukrvService.getCustCredit(param, function(provider, response) {
				var credit = Ext.isEmpty(provider[0]['CREDIT'])? 0 : provider[0]['CREDIT'];
				panelSearch.setValue('TOT_REM_CREDIT_I', credit);
			});
		},
		fnCreditCheck: function(saveFlag){	//여신액이 작을시 오류
			if(CustomCodeInfo.gsCustCreditYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
				var dTotOrderO = panelSearch.getValue('TOT_SALE_TAX_O') + panelSearch.getValue('TOT_SALE_EXP_O') + panelSearch.getValue('TOT_TAX_AMT');
				var dCreditO = panelSearch.getValue('TOT_REM_CREDIT_I');//여신잔액
				
				if(dCreditO < dTotOrderO){
					if(BsaCodeInfo.gsCreditMsg == "E"){
						Unilite.messageBox('<t:message code="system.message.sales.datacheck002" default="해당 업체에 대한 여신액이 부족합니다. 추가여신액 설정을 선행하시고 작업하시기 바랍니다."/>');	//해당 업체에 대한 여신액이 부족합니다. 추가여신액 설정을 선행하시고 작업하시기 바랍니다.
						return false;
					} else if(!Ext.isEmpty(saveFlag)){
						if(!confirm('해당 업체에 대한 여신액이 부족합니다. \n그대로 진행 하시겠습니까?')){
							return false;
						}
					}
				}
			}
			return true;
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelSearch.getValue('SALE_DATE')),
				"MONEY_UNIT" : panelSearch.getValue('MONEY_UNIT')
			};
			if(panelSearch.uniOpt.inLoading)
				return;
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni && !Ext.isEmpty(panelSearch.getValue('MONEY_UNIT')) && panelSearch.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
						Unilite.messageBox('<t:message code="system.message.sales.datacheck008" default="환율정보가 없습니다."/>');
					}
					panelSearch.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
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
		//20200110 로직 추가
		fnAccountYN: function(rtnRecord, subCode) {
			var fRecord ='';
			Ext.each(BsaCodeInfo.grsOutType, function(item, i) {
				if(item['codeNo'] == subCode && !Ext.isEmpty(item['refCode1'])) {
					fRecord = item['refCode1'];
				}
			});
			if(Ext.isEmpty(fRecord)){
				fRecord = 'N'
			}
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
			} else{
				lTrnsRate = rtnRecord.get('TRANS_RATE');
			}
			rtnRecord.set('STOCK_Q', dStockQ / lTrnsRate);
		},
		fnOrderAmtCal: function(rtnRecord, sType, fieldName, nValue, taxType) {
			var dOrderQ =	fieldName=='SALE_Q'		? nValue : Unilite.nvl(rtnRecord.get('SALE_Q'),0);
			var dOrderP =	fieldName=='SALE_P'		? nValue : Unilite.nvl(rtnRecord.get('SALE_P'),0);
			var dOrderO =	fieldName=='SALE_AMT_O'	? nValue : Unilite.nvl(rtnRecord.get('SALE_AMT_O'),0);
			var dTransRate = fieldName=='TRANS_RATE'	? nValue : Unilite.nvl(rtnRecord.get('TRANS_RATE'),1);
			var dDcRate =	fieldName=='DISCOUNT_RATE' ? nValue : Unilite.nvl((100 - rtnRecord.get('DISCOUNT_RATE')),0);
			//20200612 추가: 자사금액 계산시, 'JPY' 관련로직 추가
			var moneyUnit		= rtnRecord.get('REF_MONEY_UNIT');

			if(sType == "P" || sType == "Q"){	//단가 수량 변경시
				dOrderO = dOrderQ * dOrderP
				rtnRecord.set('SALE_AMT_O', dOrderO);
				//20200612 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
				rtnRecord.set('SALE_LOC_AMT_I', UniSales.fnExchangeApply(moneyUnit, dOrderO * panelSearch.getValue('EXCHG_RATE_O')));
				this.fnTaxCalculate(rtnRecord, dOrderO);
			} else if(sType == "O"){ //금액 변경시
				if(dOrderQ > 0){
					if(rtnRecord.get('ADVAN_YN') != "Y"){
						dOrderP = dOrderO / dOrderQ;
					}
					rtnRecord.set('SALE_P', dOrderP);
					if(rtnRecord.get('ADVAN_YN') == "Y"){	//수주참조(선매출)탭에서 참조해온 데이터만 금액변경시 매출량 변경토록
						dOrderQ = (rtnRecord.get('SALE_AMT_O') / rtnRecord.get('SALE_P')) * dOrderQ;
					}
				}
				this.fnTaxCalculate(rtnRecord, dOrderO, taxType);
			} else if(sType == "C"){ //할인율 변경시
				dOrderP = (dOrderP - (dOrderP * (dDcRate / 100)));
				dOrderO = dOrderQ * dOrderP;
				rtnRecord.set('SALE_P', dOrderP);
				rtnRecord.set('SALE_AMT_O', dOrderO);
				//20200612 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
				rtnRecord.set('SALE_LOC_AMT_I', UniSales.fnExchangeApply(moneyUnit, dOrderO * panelSearch.getValue('EXCHG_RATE_O')));
				this.fnTaxCalculate(rtnRecord, dOrderO);
			}
		},
		fnTaxCalculate: function(rtnRecord, dOrderO, taxType) {
			var sTaxType		= Ext.isEmpty(taxType)? rtnRecord.get('TAX_TYPE') : taxType;
			var sWonCalBas		= CustomCodeInfo.gsUnderCalBase;
			var sTaxInoutType	= panelSearch.getValue('TAX_TYPE').TAX_TYPE;
			var dVatRate		= parseInt(BsaCodeInfo.gsVatRate);
			var dAmountI		= dOrderO;
			var dOrderAmtO		= 0;
			var dTaxAmtO		= 0;
			var dTemp			= 0;
			//20200612 추가: 자사금액 계산시, 'JPY' 관련로직 추가
			var moneyUnit		= rtnRecord.get('REF_MONEY_UNIT');
			//20190624 화폐단위 관련로직 추가
			if(panelSearch.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
				var digit = UniFormat.FC.indexOf(".") == -1 ? UniFormat.FC.length : UniFormat.FC.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.FC.length - digit;
			} else {
				var digit = UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.Price.length - digit;
			}

			if(sTaxInoutType=="1") {	//별도
				dOrderAmtO	= dOrderO;
				dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderAmtO, sWonCalBas, numDigitOfPrice);
				dTaxAmtO	= dOrderAmtO * dVatRate / 100

				if(UserInfo.currency == "CN"){
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTaxAmtO, '3', numDigitOfPrice);
				} else{
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					//20200311 부가세의 경우 소수점관련 계산이 들어가면 안돼 따로 적용
					//dTaxAmtO = UniSales.fnAmtWonCalc(dTaxAmtO, sWonCalBas, numDigitOfPrice);
					 dTaxAmtO = fnVatCalc2(dTaxAmtO, sWonCalBas, 0);
				}
			} else if(sTaxInoutType=="2") {	//포함
				if(UserInfo.currency == "CN"){
					dOrderAmtO	= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, "3", numDigitOfPrice);
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO	= UniSales.fnAmtWonCalc(dAmountI - dOrderAmtO, '3', numDigitOfPrice);
				} else{
					dOrderAmtO	= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, sWonCalBas, numDigitOfPrice);
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					//20200311 부가세의 경우 소수점관련 계산이 들어가면 안돼 따로 적용
					//dTaxAmtO	= UniSales.fnAmtWonCalc(dAmountI - dOrderAmtO, sWonCalBas, numDigitOfPrice);
					//20200513 수정: 계산기준을 부가세액으로 통일
//					dTaxAmtO = fnVatCalc2(dAmountI - dOrderAmtO, sWonCalBas, numDigitOfPrice);
					dTaxAmtO	= fnVatCalc2(dOrderAmtO * dVatRate / 100, sWonCalBas, numDigitOfPrice);
				}
				//20191002 세액 구하는 로직 추가
				dOrderAmtO	= UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), sWonCalBas, 0);
			}
			if(sTaxType == "2" || sTaxType == "3") {	//면세 또는 영세
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderO, sWonCalBas, numDigitOfPrice ) ;
				dTaxAmtO = 0;
			}
			rtnRecord.set('SALE_AMT_O'		, dOrderAmtO);	//금액
			//20200612 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
			rtnRecord.set('SALE_LOC_AMT_I'	, UniSales.fnExchangeApply(moneyUnit, dOrderAmtO * panelSearch.getValue('EXCHG_RATE_O')));
			rtnRecord.set('TAX_AMT_O'		, dTaxAmtO);	//부가세액
			rtnRecord.set('ORDER_O_TAX_O'	, dOrderAmtO + dTaxAmtO);	//매출계
		},
		cbGetClosingInfo: function(params){
			gsMonClosing = params.gsMonClosing
			gsDayClosing = params.gsDayClosing
		},
		fnMasterSave: function(){
			var param = panelSearch.getValues();
			panelSearch.submit({
				params: param,
				success:function(comp, action) {
					UniAppManager.setToolbarButtons('save', false);
					UniAppManager.updateStatus('<t:message code="system.message.sales.message033" default="저장되었습니다."/>');
				},
				failure: function(form, action){
				}
			});
		},
		//매출기표 / 기표취소 버튼 show/hide
		fnExSlipBtn:function() {
			var cancelBtn = panelResult.down("#btnCancel");
			var createBtn = panelResult.down("#btnCreate");
			if(panelSearch.getValue("BILL_TYPE") == "10" || panelSearch.getValue("BILL_TYPE") == "50" ) {
				cancelBtn.hide();
				createBtn.hide();
			} else if(!Ext.isEmpty(panelSearch.getValue('EX_NUM')) && panelSearch.getValue('EX_NUM') != 0) {
				cancelBtn.show();
				createBtn.hide();
			} else {
				cancelBtn.hide();
				createBtn.show();
			}
		},
		//수주 데이터 참조시
		fnMakeSof100tDataRef: function(records) {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
				Unilite.messageBox('<t:message code="system.message.sales.message054" default="마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다."/>'); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
				return false;
			}
			if(!this.fnCreditCheck()) return false; //여신액 체크
			if(!Ext.isEmpty(panelSearch.getValue('EX_NUM')) && panelSearch.getValue('EX_NUM') != '0'){
				Unilite.messageBox('<t:message code="system.message.sales.message079" default="자동기표처리된 매출정보건에 대해서는 매출내역을 추가할 수 없습니다."/>');//자동기표처리된 매출정보건에 대해서는 매출내역을 추가할 수 없습니다.
				return false
			}
			var newDetailRecords = new Array();
			var billSeq = 0;
			billSeq = detailStore.max('ISSUE_REQ_SEQ');

			if(Ext.isEmpty(billSeq)){
				billSeq = 1;
			} else{
				billSeq = billSeq + 1;
			}

			Ext.each(records, function(record,i){
				if(i == 0){
					billSeq = billSeq;
				} else{
					billSeq += 1;
				}
				var billNum = '';
				if(!Ext.isEmpty(panelSearch.getValue('BILL_NUM'))) {
					billNum = panelSearch.getValue('BILL_NUM');
				}

				var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
				var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2

				var outDivCode = '';
				if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))) {
					outDivCode = panelSearch.getValue('DIV_CODE');
				}

				var billType = '';
				if(!Ext.isEmpty(panelSearch.getValue('BILL_TYPE'))) {
					if(panelSearch.getValue('BILL_TYPE') != '50'){
						billType = '1'
					} else{
						billType = '2'
					}
				}

				var divCode = '';
				if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))) {
					divCode = panelSearch.getValue('DIV_CODE');
				}

				var salePrsn = '';
				if(!Ext.isEmpty(panelSearch.getValue('SALE_PRSN'))) {
					salePrsn = panelSearch.getValue('SALE_PRSN');
				}

				var customCode = '';
				if(!Ext.isEmpty(panelSearch.getValue('SALE_CUSTOM_CODE'))) {
					customCode = panelSearch.getValue('SALE_CUSTOM_CODE');
				}

				var saleDate = '';
				if(!Ext.isEmpty(panelSearch.getValue('SALE_DATE'))) {
					saleDate = panelSearch.getValue('SALE_DATE');
				}

				var refBillType = '';
				if(!Ext.isEmpty(panelSearch.getValue('BILL_TYPE'))) {
					refBillType = panelSearch.getValue('BILL_TYPE');
				}

				var cardCustCd = '';
				if(!Ext.isEmpty(panelSearch.getValue('CARD_CUST_CD'))) {
					cardCustCd = panelSearch.getValue('CARD_CUST_CD');
				}

				var saleType = '';
				if(!Ext.isEmpty(panelSearch.getValue('ORDER_TYPE'))) {
					saleType = panelSearch.getValue('ORDER_TYPE');
				}

				var projectNo = '';
				if(!Ext.isEmpty(panelSearch.getValue('PROJECT_NO'))) {
					projectNo = panelSearch.getValue('PROJECT_NO');
				}

				var texInout = '';
				if(!Ext.isEmpty(panelSearch.getValue('TAX_TYPE').TAX_TYPE)) {
					texInout = panelSearch.getValue('TAX_TYPE').TAX_TYPE;
				}

				var remark = '';
				if(!Ext.isEmpty(panelSearch.getValue('REMARK'))) {
					remark = panelSearch.getValue('REMARK');
				}

				var exNum = '';
				if(!Ext.isEmpty(panelSearch.getValue('EX_NUM'))) {
					exNum = panelSearch.getValue('EX_NUM');
				}

				var moneyUnit = '';
				if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT'))) {
					moneyUnit = panelSearch.getValue('MONEY_UNIT');
				}

				var exchgRateO = '';
				if(!Ext.isEmpty(panelSearch.getValue('EXCHG_RATE_O'))) {
					exchgRateO = panelSearch.getValue('EXCHG_RATE_O');
				}

				var srcCustomCode = '';
				if(!Ext.isEmpty(panelSearch.getValue('SALE_CUSTOM_CODE'))) {
					srcCustomCode = panelSearch.getValue('SALE_CUSTOM_CODE');
				}

				var srcCustomName = '';
				if(!Ext.isEmpty(panelSearch.getValue('CUSTOM_NAME'))) {
					srcCustomName = panelSearch.getValue('CUSTOM_NAME');
				}

				var srcOrderPrsn = '';
				if(!Ext.isEmpty(panelSearch.getValue('SALE_PRSN'))) {
					srcOrderPrsn = panelSearch.getValue('SALE_PRSN');
				}

				var deptCode = '';
				if(!Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))) {
					deptCode = panelSearch.getValue('DEPT_CODE');
				}

				var whCode = '';
				if(!Ext.isEmpty(panelSearch.getValue('WH_CODE'))) {
					whCode = panelSearch.getValue('WH_CODE');
				}

				var compCode = UserInfo.compCode;

				var r = {
					'BILL_SEQ': billSeq,
					'BILL_NUM': billNum,
					'INOUT_TYPE_DETAIL': inoutTypeDetail,
					'REF_CODE2': refCode2,
					'OUT_DIV_CODE': outDivCode,
					'TAX_TYPE': billType,
					'DIV_CODE': divCode,
					'REF_SALE_PRSN': salePrsn,
					'REF_CUSTOM_CODE': customCode,
					'REF_SALE_DATE': saleDate,
					'REF_BILL_TYPE': refBillType,
					'REF_CARD_CUST_CD': cardCustCd,
					'REF_SALE_TYPE': saleType,
					'REF_PROJECT_NO': projectNo,
					'REF_TAX_INOUT': texInout.TAX_TYPE,
					'REF_REMARK': remark,
					'REF_EX_NUM': exNum,
					'REF_MONEY_UNIT': moneyUnit,
					'REF_EXCHG_RATE_O': exchgRateO,
					'SRC_CUSTOM_CODE': srcCustomCode,
					'SRC_CUSTOM_NAME': srcCustomName,
					'SRC_ORDER_PRSN': srcOrderPrsn,
					'COMP_CODE': compCode,
					'DEPT_CODE': deptCode,
					'WH_CODE': whCode
				};
//				masterGrid.createRow(r, null, masterGrid.getStore().getCount() - 1);
//				masterGrid.createRow(r);
				newDetailRecords[i] = detailStore.model.create( r );
				panelSearch.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
				detailStore.fnSaleAmtSum();
				UniAppManager.app.fnCreditCheck(); //여신액 체크

				var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
				var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2

				newDetailRecords[i].set('INOUT_TYPE_DETAIL'			, inoutTypeDetail);

				newDetailRecords[i].set('REF_CODE2'			, refCode2);
				newDetailRecords[i].set('WH_CODE'			, record.get('WH_CODE'));
				newDetailRecords[i].set('ITEM_CODE'			, record.get('ITEM_CODE'));
				newDetailRecords[i].set('ITEM_NAME'			, record.get('ITEM_NAME'));
				newDetailRecords[i].set('SPEC'				, record.get('SPEC'));
				newDetailRecords[i].set('SALE_UNIT'			, record.get('ORDER_UNIT'));
				newDetailRecords[i].set('TRANS_RATE'		, record.get('TRANS_RATE'));
				newDetailRecords[i].set('SALE_Q'			, record.get('NOT_SALE_Q'));

				if(panelSearch.getValue('BILL_TYPE') != "50"){
					newDetailRecords[i].set('TAX_TYPE'		, record.get('TAX_TYPE'));
				} else{
					newDetailRecords[i].set('TAX_TYPE'		, '2');
				}

				newDetailRecords[i].set('DISCOUNT_RATE'		, record.get('DISCOUNT_RATE'));
				newDetailRecords[i].set('DVRY_CUST_CD'		, record.get('DVRY_CUST_CD'));
				newDetailRecords[i].set('DVRY_CUST_NAME'	, record.get('DVRY_CUST_NAME'));
				newDetailRecords[i].set('PRICE_YN'			, record.get('PRICE_YN'));
				newDetailRecords[i].set('ORDER_NUM'			, record.get('ORDER_NUM'));
				newDetailRecords[i].set('DIV_CODE'			, panelSearch.getValue('DIV_CODE'));
				newDetailRecords[i].set('BILL_NUM'			, panelSearch.getValue('BILL_NUM'));
				newDetailRecords[i].set('INOUT_TYPE'		, '2');
				newDetailRecords[i].set('SER_NO'			, record.get('SER_NO'));
				newDetailRecords[i].set('STOCK_UNIT'		, record.get('STOCK_UNIT'));
				newDetailRecords[i].set('ITEM_STATUS'		, '1');
				newDetailRecords[i].set('ACCOUNT_YNC'		, record.get('ACCOUNT_YNC'));
				newDetailRecords[i].set('ORIGIN_Q'			, '0');
				newDetailRecords[i].set('REF_SALE_PRSN'		, panelSearch.getValue('SALE_PRSN'));
				newDetailRecords[i].set('REF_CUSTOM_CODE'	, panelSearch.getValue('SALE_CUSTOM_CODE'));
				newDetailRecords[i].set('REF_SALE_DATE'		, panelSearch.getValue('SALE_DATE'));
				newDetailRecords[i].set('REF_BILL_TYPE'		, panelSearch.getValue('BILL_TYPE'));
				newDetailRecords[i].set('REF_CARD_CUST_CD'	, panelSearch.getValue('CARD_CUST_CD'));
				newDetailRecords[i].set('REF_SALE_TYPE'		, panelSearch.getValue('ORDER_TYPE'));

				if(Ext.isEmpty(record.get('PROJECT_NO'))){
					newDetailRecords[i].set('REF_PROJECT_NO'	, panelSearch.getValue('PROJECT_NO'));
					//20200103 추가: 프로젝트명 가져오기 위해 추가
					newDetailRecords[i].set('PJT_NAME'			, panelSearch.getValue('PJT_NAME'));
				} else{
					newDetailRecords[i].set('REF_PROJECT_NO'	, record.get('PROJECT_NO'));
					//20200103 추가: 프로젝트명 가져오기 위해 추가
					newDetailRecords[i].set('PJT_NAME'			, record.get('PJT_NAME'));
				}

				newDetailRecords[i].set('REF_TAX_INOUT'		, panelSearch.getValue('TAX_TYPE').TAX_TYPE);
				//20191210 참조의 비고값 넣도록 수정
				newDetailRecords[i].set('REF_REMARK'		, record.get('REMARK') + (Ext.isEmpty(panelSearch.getValue('REMARK')) ? '' : '  '+ panelSearch.getValue('REMARK')));
				newDetailRecords[i].set('REF_EX_NUM'		, panelSearch.getValue('EX_NUM'));
				newDetailRecords[i].set('REF_MONEY_UNIT'	, record.get('MONEY_UNIT'));
				newDetailRecords[i].set('REF_EXCHG_RATE_O'	, panelSearch.getValue('EXCHG_RATE_O'));
				newDetailRecords[i].set('STOCK_CARE_YN'		, record.get('STOCK_CARE_YN'));
				newDetailRecords[i].set('UNSALE_Q'			, record.get('NOT_SALE_Q'));
				newDetailRecords[i].set('UPDATE_DB_USER'	, UserInfo.userID);
				newDetailRecords[i].set('DATA_REF_FLAG'		, 'T');
				newDetailRecords[i].set('SRC_CUSTOM_CODE'	, record.get('CUSTOM_CODE'));
				newDetailRecords[i].set('SRC_CUSTOM_NAME'	, record.get('CUSTOM_NAME'));
				newDetailRecords[i].set('SRC_ORDER_PRSN'	, record.get('ORDER_PRSN'));
				newDetailRecords[i].set('OUT_DIV_CODE'		, record.get('OUT_DIV_CODE'));

				if(record.get('ACCOUNT_YNC') == "N"){
					newDetailRecords[i].set('SALE_P'		, 0);
					newDetailRecords[i].set('SALE_AMT_O'	, 0);
					newDetailRecords[i].set('SALE_LOC_AMT_I', 0);
					newDetailRecords[i].set('TAX_AMT_O'		, 0);
				} else{
					newDetailRecords[i].set('SALE_P'		, record.get('ORDER_P'));
					if(record.get('ORDER_Q') != record.get('NOT_SALE_Q')){
						UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "Q")
					} else{
						newDetailRecords[i].set('SALE_AMT_O'		, record.get('ORDER_O'));
						newDetailRecords[i].set('SALE_LOC_AMT_I'	, record.get('ORDER_O'));
						newDetailRecords[i].set('TAX_AMT_O'			, record.get('ORDER_TAX_O'));
					}
				}

				newDetailRecords[i].set('COMP_CODE'			, UserInfo.compCode);
				UniSales.fnStockQ(newDetailRecords[i], UniAppManager.app.cbStockQ, UserInfo.compCode, newDetailRecords[i].get('DIV_CODE'), "1", newDetailRecords[i].get('ITEM_CODE'),  newDetailRecords[i].get('WH_CODE'));
				UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "Q");
			});
			detailStore.loadData(newDetailRecords, true);
		},
		//출고(미매출)/반품출고 데이터 참조시
		fnMakeIssueDataRef: function(records) {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
				Unilite.messageBox('<t:message code="system.message.sales.message054" default="마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다."/>'); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
				return false;
			}
			if(!this.fnCreditCheck()) return false; //여신액 체크
			if(!Ext.isEmpty(panelSearch.getValue('EX_NUM')) && panelSearch.getValue('EX_NUM') != '0'){
				Unilite.messageBox('<t:message code="system.message.sales.message079" default="자동기표처리된 매출정보건에 대해서는 매출내역을 추가할 수 없습니다."/>');//자동기표처리된 매출정보건에 대해서는 매출내역을 추가할 수 없습니다.
				return false
			}
			var newDetailRecords = new Array();
			var billSeq = 0;
			billSeq = detailStore.max('BILL_SEQ');
			if(Ext.isEmpty(billSeq)){
				billSeq = 1;
			} else{
				billSeq = billSeq + 1;
			}

			Ext.each(records, function(record,i){
				if(i == 0){
					billSeq = billSeq;
				} else{
					billSeq += 1;
				}
				var billNum = '';
				if(!Ext.isEmpty(panelSearch.getValue('BILL_NUM'))) {
					billNum = panelSearch.getValue('BILL_NUM');
				}

				var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
				var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2

				var outDivCode = '';
				if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))) {
					outDivCode = panelSearch.getValue('DIV_CODE');
				}

				var billType = '';
				if(!Ext.isEmpty(panelSearch.getValue('BILL_TYPE'))) {
					if(panelSearch.getValue('BILL_TYPE') == '50' || panelSearch.getValue('BILL_TYPE') == '60' || panelSearch.getValue('BILL_TYPE') == '90'){
						billType = '3'
					}else if(panelSearch.getValue('BILL_TYPE') == '10'){
						billType = '1'
					}else{
						billType = '1'
					}
				}

				var divCode = '';
				if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))) {
					divCode = panelSearch.getValue('DIV_CODE');
				}

				var salePrsn = '';
				if(!Ext.isEmpty(panelSearch.getValue('SALE_PRSN'))) {
					salePrsn = panelSearch.getValue('SALE_PRSN');
				}

				var customCode = '';
				if(!Ext.isEmpty(panelSearch.getValue('SALE_CUSTOM_CODE'))) {
					customCode = panelSearch.getValue('SALE_CUSTOM_CODE');
				}

				var saleDate = '';
				if(!Ext.isEmpty(panelSearch.getValue('SALE_DATE'))) {
					saleDate = panelSearch.getValue('SALE_DATE');
				}

				var refBillType = '';
				if(!Ext.isEmpty(panelSearch.getValue('BILL_TYPE'))) {
					refBillType = panelSearch.getValue('BILL_TYPE');
				}

				var cardCustCd = '';
				if(!Ext.isEmpty(panelSearch.getValue('CARD_CUST_CD'))) {
					cardCustCd = panelSearch.getValue('CARD_CUST_CD');
				}

				var saleType = '';
				if(!Ext.isEmpty(panelSearch.getValue('ORDER_TYPE'))) {
					saleType = panelSearch.getValue('ORDER_TYPE');
				}

				var projectNo = '';
				if(!Ext.isEmpty(panelSearch.getValue('PROJECT_NO'))) {
					projectNo = panelSearch.getValue('PROJECT_NO');
				}

				var texInout = '';
				if(!Ext.isEmpty(panelSearch.getValue('TAX_TYPE').TAX_TYPE)) {
					texInout = panelSearch.getValue('TAX_TYPE').TAX_TYPE;
				}

				var remark = '';
				if(!Ext.isEmpty(panelSearch.getValue('REMARK'))) {
					remark = panelSearch.getValue('REMARK');
				}

				var exNum = '';
				if(!Ext.isEmpty(panelSearch.getValue('EX_NUM'))) {
					exNum = panelSearch.getValue('EX_NUM');
				}

				var moneyUnit = '';
				if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT'))) {
					moneyUnit = panelSearch.getValue('MONEY_UNIT');
				}

				var exchgRateO = '';
				if(!Ext.isEmpty(panelSearch.getValue('EXCHG_RATE_O'))) {
					exchgRateO = panelSearch.getValue('EXCHG_RATE_O');
				}

				var srcCustomCode = '';
				if(!Ext.isEmpty(panelSearch.getValue('SALE_CUSTOM_CODE'))) {
					srcCustomCode = panelSearch.getValue('SALE_CUSTOM_CODE');
				}

				var srcCustomName = '';
				if(!Ext.isEmpty(panelSearch.getValue('CUSTOM_NAME'))) {
					srcCustomName = panelSearch.getValue('CUSTOM_NAME');
				}

				var srcOrderPrsn = '';
				if(!Ext.isEmpty(panelSearch.getValue('SALE_PRSN'))) {
					srcOrderPrsn = panelSearch.getValue('SALE_PRSN');
				}

				var deptCode = '';
				if(!Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))) {
					deptCode = panelSearch.getValue('DEPT_CODE');
				}

				var whCode = '';
				if(!Ext.isEmpty(panelSearch.getValue('WH_CODE'))) {
					whCode = panelSearch.getValue('WH_CODE');
				}


				var compCode = UserInfo.compCode;

				var r = {
					'ADVAN_YN'			: 'N',
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
//				masterGrid.createRow(r, null, masterGrid.getStore().getCount() - 1);
//				masterGrid.createRow(r);
				newDetailRecords[i] = detailStore.model.create( r );
				panelSearch.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
				detailStore.fnSaleAmtSum();
				UniAppManager.app.fnCreditCheck(); //여신액 체크

				var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
				var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2

				if(record.get('INOUT_TYPE') == "2"){
					newDetailRecords[i].set('INOUT_TYPE_DETAIL'	, record.get('INOUT_TYPE_DETAIL'));
					newDetailRecords[i].set('REF_CODE2'			, record.get('REF_CODE2'));
				} else{
					newDetailRecords[i].set('INOUT_TYPE_DETAIL'	, '95');
					newDetailRecords[i].set('REF_CODE2'			, refCode2);
				}

				newDetailRecords[i].set('WH_CODE'				, record.get('WH_CODE'));
				newDetailRecords[i].set('WH_CELL_CODE'			, record.get('WH_CELL_CODE'));
				newDetailRecords[i].set('ITEM_CODE'				, record.get('ITEM_CODE'));
				newDetailRecords[i].set('ITEM_NAME'				, record.get('ITEM_NAME'));
				newDetailRecords[i].set('SPEC'					, record.get('SPEC'));
				newDetailRecords[i].set('SALE_UNIT'				, record.get('ORDER_UNIT'));
				newDetailRecords[i].set('TRANS_RATE'			, record.get('TRNS_RATE'));
				newDetailRecords[i].set('SALE_Q'				, record.get('NOT_SALE_Q'));
				newDetailRecords[i].set('SALE_P'				, record.get('ORDER_UNIT_P'));

				if(panelSearch.getValue('BILL_TYPE') != "50"){
					newDetailRecords[i].set('TAX_TYPE'			, record.get('TAX_TYPE'));
				} else{
					newDetailRecords[i].set('TAX_TYPE'			, '2');
				}

				newDetailRecords[i].set('DISCOUNT_RATE'			, record.get('DISCOUNT_RATE'));
				newDetailRecords[i].set('DVRY_CUST_CD'			, record.get('DVRY_CUST_CD'));
				newDetailRecords[i].set('TAX_TYPE'				, billType);
				newDetailRecords[i].set('PRICE_YN'				, record.get('PRICE_YN'));
				newDetailRecords[i].set('LOT_NO'				, record.get('LOT_NO'));
				newDetailRecords[i].set('INOUT_NUM'				, record.get('INOUT_NUM'));
				newDetailRecords[i].set('INOUT_SEQ'				, record.get('INOUT_SEQ'));
				newDetailRecords[i].set('DIV_CODE'				, panelSearch.getValue('DIV_CODE'));
				newDetailRecords[i].set('BILL_NUM'				, panelSearch.getValue('BILL_NUM'));
				newDetailRecords[i].set('INOUT_TYPE'			, record.get('INOUT_TYPE'));
				newDetailRecords[i].set('ORDER_NUM'				, record.get('ORDER_NUM'));
				newDetailRecords[i].set('SER_NO'				, record.get('ORDER_SEQ'));
				newDetailRecords[i].set('STOCK_UNIT'			, record.get('STOCK_UNIT'));
				newDetailRecords[i].set('ITEM_STATUS'			, '1');
				newDetailRecords[i].set('ACCOUNT_YNC'			, record.get('ACCOUNT_YNC'));
				newDetailRecords[i].set('ORIGIN_Q'				, '0');

				if(Ext.isEmpty(panelSearch.getValue('SALE_PRSN'))){
					newDetailRecords[i].set('REF_SALE_PRSN'		, record.get('ORDER_PRSN'));
				} else{
					newDetailRecords[i].set('REF_SALE_PRSN'		, panelSearch.getValue('SALE_PRSN'));
				}

//				newDetailRecords[i].set('REF_SALE_PRSN'			, panelSearch.getValue('SALE_PRSN'));

				newDetailRecords[i].set('REF_CUSTOM_CODE'		, panelSearch.getValue('SALE_CUSTOM_CODE'));
				newDetailRecords[i].set('REF_SALE_DATE'			, panelSearch.getValue('SALE_DATE'));
				newDetailRecords[i].set('REF_BILL_TYPE'			, panelSearch.getValue('BILL_TYPE'));
				newDetailRecords[i].set('REF_CARD_CUST_CD'		, panelSearch.getValue('CARD_CUST_CD'));
				newDetailRecords[i].set('REF_SALE_TYPE'			, panelSearch.getValue('ORDER_TYPE'));

				if(Ext.isEmpty(record.get('PROJECT_NO'))){
					newDetailRecords[i].set('REF_PROJECT_NO'	, panelSearch.getValue('PROJECT_NO'));
					//20200103 추가: 프로젝트명 가져오기 위해 추가
					newDetailRecords[i].set('PJT_NAME'			, panelSearch.getValue('PJT_NAME'));
				} else{
					newDetailRecords[i].set('REF_PROJECT_NO'	, record.get('PROJECT_NO'));
					//20200103 추가: 프로젝트명 가져오기 위해 추가
					newDetailRecords[i].set('PJT_NAME'			, record.get('PJT_NAME'));
				}

				newDetailRecords[i].set('REF_TAX_INOUT'			, panelSearch.getValue('TAX_TYPE').TAX_TYPE);
				//20191210 참조의 비고값 넣도록 수정
				newDetailRecords[i].set('REF_REMARK'			, record.get('REMARK') + (Ext.isEmpty(panelSearch.getValue('REMARK')) ? '' : '  '+ panelSearch.getValue('REMARK')));
				newDetailRecords[i].set('REF_EX_NUM'			, panelSearch.getValue('EX_NUM'));
				newDetailRecords[i].set('REF_MONEY_UNIT'		, record.get('MONEY_UNIT'));
				newDetailRecords[i].set('REF_EXCHG_RATE_O'		, panelSearch.getValue('EXCHG_RATE_O'));
				newDetailRecords[i].set('STOCK_CARE_YN'			, record.get('STOCK_CARE_YN'));
				newDetailRecords[i].set('UNSALE_Q'				, record.get('NOT_SALE_Q'));
				newDetailRecords[i].set('UPDATE_DB_USER'		, UserInfo.userID);
				newDetailRecords[i].set('DATA_REF_FLAG'			, 'T');
				newDetailRecords[i].set('DVRY_CUST_NAME'		, record.get('DVRY_CUST_NAME'));
				newDetailRecords[i].set('SRC_CUSTOM_CODE'		, record.get('CUSTOM_CODE'));
				newDetailRecords[i].set('SRC_CUSTOM_NAME'		, record.get('INOUT_NAME'));
				newDetailRecords[i].set('SRC_ORDER_PRSN'		, record.get('ORDER_PRSN'));
				newDetailRecords[i].set('OUT_DIV_CODE'			, record.get('DIV_CODE'));
				newDetailRecords[i].set('INOUT_DATE'			, record.get('INOUT_DATE'));
				newDetailRecords[i].set('COMP_CODE'				, UserInfo.compCode);

				//20191209 참조 시, 참조된 금액 재계산 없이 그대로 set되도록 수정: 참조창의 값 set
				newDetailRecords[i].set('SALE_AMT_O'			, record.get('ORDER_UNIT_O'));
				//20200612 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
				newDetailRecords[i].set('SALE_LOC_AMT_I'		, UniSales.fnExchangeApply(record.get('MONEY_UNIT'), Unilite.multiply(record.get('ORDER_UNIT_O'), panelSearch.getValue('EXCHG_RATE_O'))));
				//20201130 매출유형이 영세매출이면 부가세 0으로 적용
				var inoutTaxAmt = record.get('INOUT_TAX_AMT');
				if(panelSearch.getValue('BILL_TYPE') == '50'|| panelSearch.getValue('BILL_TYPE') == '60' || panelSearch.getValue('BILL_TYPE') == '90'){
					inoutTaxAmt= 0;
				}
				newDetailRecords[i].set('TAX_AMT_O'				, inoutTaxAmt);
				newDetailRecords[i].set('ORDER_O_TAX_O'			, record.get('ORDER_UNIT_O') + inoutTaxAmt);

				UniSales.fnStockQ(newDetailRecords[i], UniAppManager.app.cbStockQ, UserInfo.compCode, newDetailRecords[i].get('DIV_CODE'), "1", newDetailRecords[i].get('ITEM_CODE'),  newDetailRecords[i].get('WH_CODE'));
				//20191209 참조 시, 참조된 금액 재계산 없이 그대로 set되도록 수정: 주석
				//20200206 수정: 미매출량 = 수불량 - 매출금액 = 수불금액, 미매출량 <> 수불량  매출금액 = 미매출량 * 단가
				if(Math.abs(record.get('NOT_SALE_Q')) != Math.abs(record.get('ORDER_UNIT_Q'))) {
					UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "Q")
				}
			});
			detailStore.loadData(newDetailRecords, true);
		}
	});// End of Unilite.Main( {

	// 결제 조건에 따른 결제 예정일 세팅
	function fnControlPaymentDay(newValue){
		// 매출일
		var saleDate = panelSearch.getValue('SALE_DATE');
		if(Ext.isEmpty(saleDate)|| !Ext.isDate(saleDate)) return;
		
		// 결제 조건 값이 없을 경우
		if (Ext.isEmpty(newValue)){
			panelSearch.setValue('PAYMENT_DAY', saleDate);
			panelResult.setValue('PAYMENT_DAY', saleDate);
		} else {
			var commonCodes = Ext.data.StoreManager.lookup('B034').data.items;
			
			Ext.each(commonCodes,function(commonCode, i) {
				// 결제 조건의 값이 같은경우
				if(commonCode.get('value') == newValue) {
					var strDate = '';
					var paymentDay = '';
					var ref1= commonCode.get('refCode1');		// 결제 조건 - 조건
					var mon	= Ext.isEmpty(commonCode.get('refCode2')) ? '0' : commonCode.get('refCode2');	// ref2 데이터 (월), 20210820 추가
					var date= Ext.isEmpty(commonCode.get('refCode3')) ? '0' : commonCode.get('refCode3');	// ref3 데이터

					switch(ref1) {
					// 세금계산서 발행 (결제예정일 없음)
					case "1" :
						paymentDay = '';
						break;

					// 월 마감 후(매출일의 말일 날짜 기준)
					case "2" :
						strDate		= UniDate.get('endOfMonth', saleDate);
						strDate		= new Date(strDate.substring(0,4)+ '-' + strDate.substring(4,6)+ '-' + strDate.substring(6,8))
						strDate		= UniDate.add(strDate, {months	: mon});
						paymentDay	= UniDate.add(strDate, {days	: date});
						break;

					// 입고 후(출고참조의 출고일자 MAX 기준)
					case "3" :
						strDate		= Ext.isEmpty(detailStore.max('INOUT_DATE')) ? new Date() : detailStore.max('INOUT_DATE');
						strDate		= UniDate.add(strDate, {months	: mon});
						paymentDay	= UniDate.add(strDate, {days: date});
						break;

					default:
						saleDate	= UniDate.add(saleDate, {months	: mon});
						paymentDay	= UniDate.add(saleDate, {days: date});
					}
					// 결제 예정일 set
					panelSearch.setValue('PAYMENT_DAY', paymentDay);
					panelResult.setValue('PAYMENT_DAY', paymentDay);
				}
			})
		}
	}

	//20200629 추가: 판매유형의 공통코드에 따라 구매확인서 필드 control
	function fnControlPurchDocField(newValue) {
		var commonCodes	= Ext.data.StoreManager.lookup('CBS_AU_S002').data.items;
		Ext.each(commonCodes,function(commonCode, i) {
			if(commonCode.get('value') == newValue) {
				if(commonCode.get('refCode11') == 'Y') {
					panelSearch.getField('PURCH_DOC_NO').setHidden(false);
					panelSearch.getField('ISSUE_DATE').setHidden(false);
					panelResult.getField('PURCH_DOC_NO').setHidden(false);
					panelResult.getField('ISSUE_DATE').setHidden(false);
				} else {
					panelSearch.setValue('PURCH_DOC_NO'	, '');
					panelSearch.setValue('ISSUE_DATE'	, '');
					panelResult.setValue('PURCH_DOC_NO'	, '');
					panelResult.setValue('ISSUE_DATE'	, '');

					panelSearch.getField('PURCH_DOC_NO').setHidden(true);
					panelSearch.getField('ISSUE_DATE').setHidden(true);
					panelResult.getField('PURCH_DOC_NO').setHidden(true);
					panelResult.getField('ISSUE_DATE').setHidden(true);
				}
			}
		})
	}

	//20191113 합계 구하는 로직 추가
	function fnRefGridSum() {
		var results = issueGrid.getStore().sumBy(function(record, id) {
			if(issueGrid.getSelectionModel().isSelected(record)) return true;
		},
		['ORDER_UNIT_O', 'INOUT_TAX_AMT']);
		issueGrid.down('#SUM_SALE_AMT_O').setValue(results.ORDER_UNIT_O);
		issueGrid.down('#SUM_TAX_AMT_O').setValue(results.INOUT_TAX_AMT);
		issueGrid.down('#TOTAL_SUM').setValue(results.ORDER_UNIT_O + results.INOUT_TAX_AMT);
	}

	function fnVatCalc2(dAmount, sUnderCalBase, numDigit) {
		var absAmt = 0, wasMinus = false;
		var numDigit = (numDigit == undefined) ? 0 : numDigit ;

		//한국의 경우 소숫점 버림
		if(UserInfo.currency == 'KRW') {
			//sUnderCalBase = '2';
			numDigit = 0;
		}

		if( dAmount >= 0 ) {
			absAmt = dAmount;
		} else {
			absAmt = Math.abs(dAmount);
			wasMinus = true;
		}

		var mn = Math.pow(10, numDigit);
		switch (sUnderCalBase) {
			case  "1" :	//up : 0에서 멀어짐.
				absAmt = Math.ceil(absAmt * mn) / mn;
				break;
			case  "2" :	//cut : 0에서 가까와짐, 아래 자리수 버림.
				absAmt = Math.floor(absAmt * mn) / mn;
				break;
			default:						//round
				absAmt = Math.round(absAmt * mn) / mn;
		}
		// 음수 였다면 -1을 곱하여 복원.
		return (wasMinus) ? absAmt * (-1) : absAmt;
	}

	//Validation
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			if(record.phantom && Ext.isEmpty(record.get('REF_EX_NUM')) && record.get('REF_EX_NUM' != "0")){//신규일때
				rv = '<t:message code="system.message.sales.message077" default="회계전표가 생성된 매출자료는 수정/삭제할 수 없습니다."/>';	//회계전표가 생성된 매출자료는 수정/삭제할 수 없습니다.
			} else if(record.phantom && Ext.isEmpty(record.get('PUB_NUM'))){
				rv = '<t:message code="system.message.sales.message068" default="계산서가 발행된 건은 삭제할 수 없습니다."/>';	//계산서가 발행된 건은 삭제할 수 없습니다.
			} else{
				switch(fieldName) {
					case "BILL_SEQ" :
						if(newValue <= 0 && !Ext.isEmpty(newValue)) {
							rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							break;
						}
						break;

					case "INOUT_TYPE_DETAIL" :
						//20200413 수정: record.get('INOUT_TYPE_DETAIL') -> newValue
						var sInoutTypeDetail = newValue;
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
						} else{
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
							if(panelSearch.getValue('BILL_TYPE') != "50"){
								record.set('TAX_TYPE', "1");
							} else{
								record.set('TAX_TYPE', "2");
							}

							record.set('ACCOUNT_YNC', "Y");
							record.set('PRICE_YN', "2");
							record.set('UPDATE_DB_USER', UserInfo.userID);
							record.set('INOUT_TYPE', "2");
							record.set('DIV_CODE', panelSearch.getValue('DIV_CODE'));
							record.set('ITEM_STATUS', "1");
							record.set('ORIGIN_Q', "0");
							record.set('STOCK_Q', "0");
							record.set('REF_SALE_PRSN', panelSearch.getValue('SALE_PRSN'));
							record.set('REF_CUSTOM_CODE', panelSearch.getValue('SALE_CUSTOM_CODE'));
							record.set('REF_SALE_DATE', panelSearch.getValue('SALE_DATE'));
							record.set('REF_BILL_TYPE', panelSearch.getValue('BILL_TYPE'));
							record.set('REF_CARD_CUST_CD', panelSearch.getValue('CARD_CUST_CD'));
							record.set('REF_SALE_TYPE', panelSearch.getValue('ORDER_TYPE'));
							record.set('REF_PROJECT_NO', panelSearch.getValue('PROJECT_NO'));
							if(panelSearch.getValue('TAX_TYPE').TAX_TYPE == "1"){
								record.set('REF_TAX_INOUT', "1");
							} else{
								record.set('REF_TAX_INOUT', "2");
							}

							record.set('REF_REMARK', panelSearch.getValue('REMARK'));
							record.set('REF_EX_NUM', panelSearch.getValue('EX_NUM'));
							record.set('REF_MONEY_UNIT', panelSearch.getValue('MONEY_UNIT'));
							record.set('REF_EXCHG_RATE_O', panelSearch.getValue('EXCHG_RATE_O'));
							record.set('UNSALE_Q', "0");
							record.set('DATA_REF_FLAG', "F");
							record.set('SRC_CUSTOM_CODE', panelSearch.getValue('SALE_CUSTOM_CODE'));
							record.set('SRC_CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
							//20191021 주석
//							record.set('SRC_ORDER_PRSN', panelSearch.getValue('SALE_PRSN'));
						}

						//20200110로직 추가
						record.set('ACCOUNT_YNC', UniAppManager.app.fnAccountYN(null, newValue));
						break;

					case "OUT_DIV_CODE" :	////구현해야함
//						record.set('WH_CODE', Ext.data.StoreManager.lookup('whList').getAt(0).get('value')); ////창고콤보value중 첫번째 value 사업장별 창고로 수정요망

						break;

					case "WH_CODE" :
						//20210324 추가: 창고 선택 시, 창고 cell 자동 선택되도록 로직 추가
						var param = {
							DIV_CODE: panelResult.getValue('DIV_CODE'),
							WH_CODE	: newValue
						}
						matrlCommonService.getWhCellCode(param, function(provider, response) {
							if(!Ext.isEmpty(provider)) {
								record.set('WH_CELL_CODE', provider);
							}
						})
						break;

					case "SALE_UNIT" :
						UniSales.fnGetPriceInfo(record, UniAppManager.app.cbGetPriceInfo
												,'I'
												,UserInfo.compCode
												,panelSearch.getValue('SALE_CUSTOM_CODE')
												,BsaCodeInfo.gsAgentType
												,record.get('ITEM_CODE')
												,BsaCodeInfo.gsMoneyUnit
												,record.get('SALE_UNIT')
												,record.get('STOCK_UNIT')
												,record.get('TRANS_RATE')
												,UniDate.getDbDateStr(panelSearch.getValue('SALE_DATE'))
												);
//						detailStore.fnSaleAmtSum();
						UniAppManager.app.fnCreditCheck(); //여신액 체크
						break;

					case "TRANS_RATE" :
						UniSales.fnGetPriceInfo(record, UniAppManager.app.cbGetPriceInfo
												,'R'
												,UserInfo.compCode
												,panelSearch.getValue('SALE_CUSTOM_CODE')
												,BsaCodeInfo.gsAgentType
												,record.get('ITEM_CODE')
												,BsaCodeInfo.gsMoneyUnit
												,record.get('SALE_UNIT')
												,record.get('STOCK_UNIT')
												,record.get('TRANS_RATE')
												,UniDate.getDbDateStr(panelSearch.getValue('SALE_DATE'))
												);
//						detailStore.fnSaleAmtSum();
						UniAppManager.app.fnCreditCheck(); //여신액 체크
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
						} else{
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
								} else{
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
						UniAppManager.app.fnCreditCheck(); //여신액 체크
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
						UniAppManager.app.fnCreditCheck(); //여신액 체크

						break;

					case "SALE_AMT_O" :
						//20200413 수정: newValue -> Unilite.multiply(newValue * panelSearch.getValue('EXCHG_RATE_O'))
						//20200612 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
						record.set('SALE_LOC_AMT_I', UniSales.fnExchangeApply(record.get('REF_MONEY_UNIT'), Unilite.multiply(newValue , panelSearch.getValue('EXCHG_RATE_O'))));

						var sRefCode2 = record.get('REF_CODE2');
						var sInoutTypeDetail = record.get('INOUT_TYPE_DETAIL');
						var dTaxAmtO = 0;

						if(sRefCode2 == "94" || sRefCode2 == "95"){ //'에누리/반품환입
							if(newValue > 0 && !Ext.isEmpty(newValue)) {
								rv =  '<t:message code="system.message.sales.message080" default="음수만 입력가능합니다."/>';	//음수만 입력 가능합니다.
								break;
							}
						} else if(sRefCode2 == "AU"){ //금액보정
							/*if(newValue < 0 && !Ext.isEmpty(newValue)) {
								rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';	//양수만 입력 가능합니다.
								break;
							}*/
						} else{
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
						} else{
							if(dTaxAmtO < newValue){
								rv = '<t:message code="system.message.sales.message083" default="매출금액은 세액보다 작아야 합니다."/>' //매출금액은 세액보다 작아야 합니다.
								break;
							}
						}

						//20190916 금액, 부가세액 수정가능하도록 변경: 단가 재계산로직 생략
//						UniAppManager.app.fnOrderAmtCal(record, 'O', fieldName, newValue);

						 if(sRefCode2 == "AU"){ //2020.08.07 금액보정이면 수량, 단가는 수정 안되고 금액은 양수 음수 모두 입력 가능하도록 수정
							UniAppManager.app.fnOrderAmtCal(record, 'O', fieldName, newValue);
							detailStore.fnSaleAmtSum();
						 }else{
							record.set('ORDER_O_TAX_O'	, newValue + record.get('TAX_AMT_O'));
						 }


//						detailStore.fnSaleAmtSum();
						UniAppManager.app.fnCreditCheck(); //여신액 체크
//						rv = false;
						break;

					case "TAX_TYPE" :		  //과세구분
//						if(!Ext.isEmpty(newValue) && newValue == "1"){
//							var inoutTax = record.get('SALE_AMT_O') / 10
//							record.set('TAX_AMT_O', inoutTax);
//							record.set('TAX_TYPE', newValue)
//							detailStore.fnSaleAmtSum(newValue);
//						} else if(!Ext.isEmpty(newValue) && newValue == "2"){
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
						UniAppManager.app.fnCreditCheck(); //여신액 체크
						break;

					case "TAX_AMT_O" :			//부가세액
						var dSaleAmtO = 0;
						var sRefCode2 = record.get('REF_CODE2');
						if(sRefCode2 == "94" || sRefCode2 == "95"){ //'에누리/반품환입
							if(newValue > 0 && !Ext.isEmpty(newValue)) {
								rv =  '<t:message code="system.message.sales.message080" default="음수만 입력가능합니다."/>';	//음수만 입력 가능합니다.
								break;
							}
						} /* else if(sRefCode2 == "AU"){ //금액보정
							if(newValue < 0 && !Ext.isEmpty(newValue)) {
								rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';	//양수만 입력 가능합니다.
								break;
							}
						} else{
							if(newValue < 0 && !Ext.isEmpty(newValue)) {
								rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';	//양수만 입력 가능합니다.
								break;
							}
						} */

						if(record.get('ACCOUNT_YNC') == "N"){	//미매출대상인 경우
							if(newValue != 1){
								rv = '<t:message code="system.message.sales.message081" default="매출대상이 NO 인 경우, 숫자 0만 입력가능합니다."/>'; //매출대상이 'NO'인 경우, 숫자 0만 입력가능합니다.
								break;
							}
							record.set('SALE_AMT_O', 0);
							record.set('SALE_LOC_AMT_I', 0);
							record.set('SALE_P', 0);
						} else{
							dSaleAmtO = record.get('SALE_AMT_O');
							if(record.get('TAX_TYPE')  == "2"){
								if(newValue != 0){
									rv = '<t:message code="system.message.sales.message084" default="과세구분이 면세인 경우, 부가세액은 0입니다."/>'; //과세구분이 면세인 경우, 부가세액은 0입니다.
									break;
								}
							} else{
								if(dSaleAmtO > 0){
									if(dSaleAmtO < newValue){
										rv = '<t:message code="system.message.sales.message085" default="세액은 매출액보다 작아야 합니다."/>'; //세액은 매출액보다 작아야 합니다.
										break;
									}
								} else{
									if(dSaleAmtO > newValue){
										rv = '<t:message code="system.message.sales.message086" default="세액은 매출액보다 커야 합니다."/>'; //세액은 매출액보다 커야 합니다.
										break;
									}
								}
							}
							var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
							if(UserInfo.currency == "CN"){
								record.set('TAX_AMT_O', UniSales.fnAmtWonCalc(dTaxAmtO, "3", numDigitOfPrice));
							} else{
								record.set('TAX_AMT_O',UniSales.fnAmtWonCalc(dTaxAmtO, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice));
							}
						}
//						detailStore.fnSaleAmtSum();
						UniAppManager.app.fnCreditCheck(); //여신액 체크
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
						UniAppManager.app.fnOrderAmtCal(record, 'C', fieldName, newValue);
//						detailStore.fnSaleAmtSum();
						UniAppManager.app.fnCreditCheck(); //여신액 체크
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