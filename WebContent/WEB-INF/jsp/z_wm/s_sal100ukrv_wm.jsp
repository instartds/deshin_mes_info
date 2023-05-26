<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sal100ukrv_wm">
	<t:ExtComboStore comboType="BOR120"  pgmId="str103ukrv"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A028"/>						<!-- 카드사 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>						<!-- 화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>						<!-- 판매단위-->
	<t:ExtComboStore comboType="AU" comboCode="B021"/>						<!-- 품목상태-->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>						<!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5'/>			<!-- 생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="B030"/>						<!-- 과세포함여부-->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>						<!-- 과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="B116"/>						<!-- 단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="S002"/>						<!-- 판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="S003"/>						<!-- 단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="S007"/>						<!-- 출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>						<!-- 영업담당자-->
	<t:ExtComboStore comboType="AU" comboCode="S014"/>						<!-- 매출대상-->
	<t:ExtComboStore comboType="AU" comboCode="S024"/>						<!-- 부가세유형 -->		<%--20210215 추가 --%>
	<t:ExtComboStore comboType="AU" comboCode="S106"/>						<!-- 라벨종류-->		<%--20200304 추가 --%>
	<t:ExtComboStore comboType="AU" comboCode="S065"/>						<!-- 주문구분-->
	<t:ExtComboStore comboType="AU" comboCode="T016"/>						<!-- 대금결제방법-->
	<t:ExtComboStore comboType="AU" comboCode="YP09"/>						<!-- 판매형태-->
	<t:ExtComboStore comboType="OU"/>										<!-- 창고-->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>			<!-- 창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList"/>	<!-- 창고Cell-->
</t:appConfig>
<script type="text/javascript">
	//20210201 추가: 우편번호 다음 API 연동
	var protocol = ("https:" == document.location.protocol) ? "https" : "http";
	if(protocol == "https")	{
		document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	} else {
		document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	}
</script><!-- Unilite.popup('ZIP',..) -->
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var searchInfoWindow;		//searchInfoWindow : 검색창
var gsMonClosing	= '';	//월마감 여부
var gsDayClosing	= '';	//일마감 여부
var gsOldMonClosing	= '';	//월마감 여부(기존 데이터)
var gsOldDayClosing	= '';	//일마감 여부(기존 데이터)
var gsOldInoutDate	= '';
var gsWhCode		= '';	//창고코드
var isLoad			= false;//로딩 플래그 담당, 화폐단위, 환율 change 로드시 계속 타므로 막음

var BsaCodeInfo = {
	gsAutoType			: '${gsAutoType}',
	gsMoneyUnit			: '${gsMoneyUnit}',
	gsOptDivCode		: '${gsOptDivCode}',
	gsPriceGubun		: '${gsPriceGubun}',
	gsWeight			: '${gsWeight}',
	gsVolume			: '${gsVolume}',
	gsLotNoInputMethod	: '${gsLotNoInputMethod}',
	gsLotNoEssential	: '${gsLotNoEssential}',
	gsEssItemAccount	: '${gsEssItemAccount}',
	gsLotNoInputMethod	: '${gsLotNoInputMethod}',
	gsLotNoEssential	: '${gsLotNoEssential}',
	gsEssItemAccount	: '${gsEssItemAccount}',
	gsInoutAutoYN		: '${gsInoutAutoYN}',
	gsInvstatus			: '${gsInvstatus}',
	gsPointYn			: '${gsPointYn}',
	gsUnitChack			: '${gsUnitChack}',
	gsCreditYn			: '${gsCreditYn}',
	grsOutType			: ${grsOutType},
	gsSumTypeCell		: '${gsSumTypeCell}',
	gsRefWhCode			: '${gsRefWhCode}',
	gsVatRate			: ${gsVatRate},
	gsManageTimeYN		: '${gsManageTimeYN}',
	salePrsn			: ${salePrsn},
	whList				: ${whList},
	useLotAssignment	: '${useLotAssignment}',
	gsBoxYN				: '${gsBoxYN}',
	gsDefaultType		: '${gsDefaultType}',
	gsAutoSalesYN		: '${gsAutoSalesYN}',		//공통코드(S033 - 출고등록시 자동매출생성/삭제여부) 가져오는 로직 추가: 1 자동, 2 수동(값이 없을 때는 수동)
	defaultSalePrsn		: '${defaultSalePrsn}',		//영업담당(default)
	defaultCustomCd		: '${defaultCustomCd}',		//거래처(default)
	defaultCustomNm		: '${defaultCustomNm}',		//거래처명(default)
	defaultTaxInout		: '${defaultTaxInout}',		//거래처(default)에 따른 세액포함 여부
	defaultAgentType	: '${defaultAgentType}',	//거래처(default) 분류
	defaultCreditYn		: '${defaultCreditYn}',		//거래처(default)에 따른 세액포함 여부
	defaultWonCalcBas	: '${defaultWonCalcBas}',	//거래처(default)에 따른 원미만 처리 방법
	defaultBusiPrsn		: '${defaultBusiPrsn}',		//거래처(default)에 따른 주담당자
	defaultMoneyUnit	: '${defaultMoneyUnit}',	//거래처(default)에 따른 화폐
	defaultWhCode		: '${defaultWhCode}',		//출고창고(default)
	defaultWhCellCode	: '${defaultWhCellCode}'	//출고창고CELL(default)
};
//공통코드(S033 - 출고등록시 자동매출생성/삭제여부) 가져오는 로직 추가: 1 자동, 2 수동(값이 없을 때는 수동)
if(Ext.isEmpty(BsaCodeInfo.gsAutoSalesYN)) {
	BsaCodeInfo.gsAutoSalesYN = '2';
}
//자동채번 여부
var isAutoOrderNum = false;
if(BsaCodeInfo.gsAutoType=='Y') {
	isAutoOrderNum = true;
}
//시/분/초 필드 처리여부
var manageTimeYN = false;
if(BsaCodeInfo.gsManageTimeYN =='Y') {
	manageTimeYN = true;
}
//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
var sumtypeCell = true;
if(BsaCodeInfo.gsSumTypeCell =='Y') {
	sumtypeCell = false;
}
var CustomCodeInfo = {
	gsAgentType		: BsaCodeInfo.defaultAgentType,
	gsCustCreditYn	: BsaCodeInfo.defaultCreditYn,
	gsUnderCalBase	: BsaCodeInfo.defaultWonCalcBas,
	gsTaxInout		: BsaCodeInfo.defaultTaxInout,
	gsbusiPrsn		: BsaCodeInfo.defaultBusiPrsn
};
var outDivCode	= UserInfo.divCode;
var gsQueryFlag	= false;		//20210129 추가: 창고 변경 시, default Y인 창고cell 자동적용 로직 수행여부 control하기 위해 추가
var gsSalePrsn	= "";			//20210308 추가: 공통코드 변경 후, 영업담당에 수불담당 ref_code6 값 set

function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 4},
		padding		: '1 1 1 1',
		border		: true,
		items		: [{
			fieldLabel	: '담당',
			name		: 'INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024',				//20210308 수정: S010 -> B024
			holdable	: 'hold',
			allowBlank	: false,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
				if(eOpts) {
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					if(!isLoad) {
						//20210308 추가: 공통코드 변경 후, 영업담당에 수불담당 ref_code6 값 set
						var inoutPrsns = Ext.data.StoreManager.lookup('CBS_AU_B024').data.items;
						Ext.each(inoutPrsns, function(inoutPrsn, i) {
							if(inoutPrsn.get('value') == newValue) {
								gsSalePrsn = inoutPrsn.get('refCode6');
							}
						})
						if(detailStore.data.length > 0) {
							var records = detailStore.data.items;
							Ext.each(records, function(record, index) {
								record.set('INOUT_PRSN'	, newValue);
								record.set('SALE_PRSN'	, gsSalePrsn);
							});
						}
						var param = {
							DIV_CODE	: panelResult.getValue('DIV_CODE'),
							INOUT_PRSN	: newValue
						}
						s_sal100ukrv_wmService.chgInoutPrsn(param, function(provider, response) {
							if(provider) {
								CustomCodeInfo.gsAgentType			= provider.AGENT_TYPE;
								CustomCodeInfo.gsCustCreditYn		= provider.CREDIT_YN == Ext.isEmpty(provider.CREDIT_YN)? 0 : provider.CREDIT_YN;
								CustomCodeInfo.gsUnderCalBase		= provider.WON_CALC_BAS;
								CustomCodeInfo.gsTaxInout			= provider.TAX_TYPE;		//세액포함여부
								CustomCodeInfo.gsbusiPrsn			= provider.BUSI_PRSN;		//거래처의 주영업담당
								panelResult.setValue('CUSTOM_CODE'	, provider.CUSTOM_CODE);
								panelResult.setValue('CUSTOM_NAME'	, provider.CUSTOM_NAME);
								panelResult.setValue('MONEY_UNIT'	, provider.MONEY_UNIT);
								panelResult.setValue('WH_CODE'		, provider.WH_CODE);
								panelResult.getField('WH_CODE').focus();
								panelResult.getField('WH_CODE').blur();
								panelResult.setValue('WH_CELL_CODE'	, provider.WH_CELL_CODE);
								panelResult.getField('TAX_INOUT').setValue(provider.TAX_TYPE);
								fnSetColumnFormat();
							}
						});
					}
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>' ,
			holdable	: 'hold',
			autoPopup	: true,			//20210129 추가
			listeners	: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						CustomCodeInfo.gsAgentType		= records[0]["AGENT_TYPE"];
						CustomCodeInfo.gsCustCreditYn	= records[0]["CREDIT_YN"] == Ext.isEmpty(records[0]["CREDIT_YN"])? 0 : records[0]["CREDIT_YN"];
						CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"];
						CustomCodeInfo.gsTaxInout 		= records[0]["TAX_TYPE"];	//세액포함여부
						CustomCodeInfo.gsbusiPrsn 		= records[0]["BUSI_PRSN"]; //거래처의 주영업담당

						if(BsaCodeInfo.gsOptDivCode == "1") {	//출고사업장과 동일
						} else {
							var saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);//거래처의 영업담당자의 사업장코드
							if(Ext.isEmpty(saleDivCode)) {//거래처의 영업담당자가 있는지 체크
								panelResult.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
								panelResult.getField('CUSTOM_CODE').focus();

								CustomCodeInfo.gsAgentType		= '';
								CustomCodeInfo.gsCustCreditYn	= '';
								CustomCodeInfo.gsUnderCalBase	= '';
								CustomCodeInfo.gsTaxInout 		= '';
								CustomCodeInfo.gsbusiPrsn 		= '';
								Unilite.messageBox('<t:message code="system.message.sales.message073" default="영업담당자정보가 존재하지 않습니다."/>');	//영업담당자정보가 존재하지 않습니다.
								return false;
							}
						}
						panelResult.setValue('MONEY_UNIT', records[0].MONEY_UNIT);
						panelResult.getField('TAX_INOUT').setValue(records[0].TAX_TYPE);
					},
					scope: this
				},
				onClear: function(type) {
					CustomCodeInfo.gsAgentType		= '';
					CustomCodeInfo.gsCustCreditYn	= '';
					CustomCodeInfo.gsUnderCalBase	= '';
					CustomCodeInfo.gsTaxInout		= '';
					CustomCodeInfo.gsbusiPrsn		= '';
					panelResult.setValue('CUSTOM_CODE', '');
					panelResult.setValue('CUSTOM_NAME', '');
				},
				applyextparam: function(popup) {
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
			name		: 'INOUT_DATE',
			xtype		: 'uniDatefield',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					if(Ext.isDate(newValue)) {
						if(newValue != oldValue &&!Ext.isEmpty(newValue && !Ext.isEmpty(panelResult.getValue('DIV_CODE')))) {
							UniSales.fnGetClosingInfo(
								UniAppManager.app.cbGetClosingInfo2,
								panelResult.getValue('DIV_CODE'),
								"I",
								UniDate.getDbDateStr(newValue)
							);
						}
						if(detailStore.data.length > 0) {
							var records = detailStore.data.items;
							Ext.each(records, function(record, index) {
								record.set('INOUT_DATE'	, newValue);
								record.set('SALE_DATE'	, newValue);
							});
						}
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxabletotalamount" default="과세총액"/>(1)',
			name		: 'TOT_SALE_TAXI',
			xtype		: 'uniNumberfield',
			readOnly	: true,
			value		: 0
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			child		: 'WH_CELL_CODE',
			holdable	: 'hold',
//			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					//20210129 추가: 창고변경 시, 창고에 설정되어 있는 기본창고cell 가져오는 로직 추가
					var param = {
						DIV_CODE: panelResult.getValue('DIV_CODE'),
						WH_CODE	: newValue
					}
					s_sal100ukrv_wmService.getWhCellCode(param, function(provider, response) {
						if(!Ext.isEmpty(provider) && !gsQueryFlag) {
							var whCellStore = panelResult.getField('WH_CELL_CODE').getStore();
							whCellStore.clearFilter(true);
							whCellStore.filter([{
								property: 'option',
								value	: newValue
							}]);
							panelResult.getField('WH_CELL_CODE').setValue(provider);
						}
						gsQueryFlag = false;
					})
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>',
			name		: 'WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					store.filterBy(function(item) {
						return item.get('option') == panelResult.getValue('WH_CODE')
							//BSA225T의 CUSTOM_CODE가 비어 있거나 panelResult의 값과 동일한 데이터만 show
							&&(item.get('refCode10') == panelResult.getValue('CUSTOM_CODE') || item.get('refCode10') == '*')
					})
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			xtype		: 'uniCombobox',
			name		: 'DIV_CODE',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			holdable	: 'hold',
			child		: 'WH_CODE',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelResult.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..

					if(!Ext.isEmpty(newValue) && !Ext.isEmpty(panelResult.getValue('INOUT_DATE'))) {
						UniSales.fnGetClosingInfo(
							UniAppManager.app.cbGetClosingInfo,
							newValue,
							"I",
							panelResult.getField('INOUT_DATE').getSubmitValue()
						);
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxtotalamount" default="세액합계"/>(2)',
			xtype		: 'uniNumberfield',
			name		: 'TOT_TAXI',
			readOnly	: true,
			value		: 0
		},{
			fieldLabel	: '<t:message code="system.label.sales.issueno" default="출고번호"/>',
			xtype		: 'uniTextfield',
			name		: 'INOUT_NUM',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '세액포함여부',
			xtype		: 'radiogroup',
			holdable	: 'hold',
			items		: [{
				boxLabel	: '포함',
				name		: 'TAX_INOUT',
				inputValue	: '2',
				width		: 70
			},{
				boxLabel	: '별도',
				name		: 'TAX_INOUT',
				inputValue	: '1',
				width		: 60
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
//					detailStore.loadStoreRecords(newValue.rdoSelect);
				}
			}
		},{	//20210215 추가
			fieldLabel	: '<t:message code="system.label.sales.vattype" default="부가세유형"/>',
			name		: 'BILL_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S024',
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					//20210308 추가
					if(newValue == '40') {
						panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(false);
					} else {
						panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(true);
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxexemptiontotalamount" default="면세총액"/>(3)',
			xtype		: 'uniNumberfield',
			name		: 'TOT_SALENO_TAXI',
			readOnly	: true,
			value		: 0
		},{	//20210201 추가
			fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_PRSN',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					var records = detailStore.data.items;
					Ext.each(records, function(record) {
						record.set('CUSTOM_PRSN', newValue);
					});
				}
			}
		},{	//20210201 추가
			fieldLabel	: '연락처',
			name		: 'PHONE',
			xtype		: 'uniTextfield',
//			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					var records = detailStore.data.items;
					Ext.each(records, function(record) {
						record.set('PHONE', newValue);
					});
				}
			}
		},{	//20210308 추가: 카드사
			fieldLabel	: '카드사',
			name		: 'CARD_CUSTOM_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A028',
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					if(detailStore.data.length > 0) {
						var records = detailStore.data.items;
						Ext.each(records, function(record, index) {
							record.set('CARD_CUSTOM_CODE', newValue);
						});
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuetotamount" default="출고총액"/>',
			xtype		: 'uniNumberfield',
			name		: 'TOTAL_AMT',
			readOnly	: true,
			value		: 0
		},
		//20210201 추가
		Unilite.popup('ZIP',{
			showValue		: false,
			textFieldName	: 'ZIP_CODE',
			DBtextFieldName	: 'ZIP_CODE',
			popupHeight		: 600,
			listeners		: {
				'onSelected': {
					fn: function(records, type  ){
						panelResult.setValue('ADDR1', records[0]['ZIP_NAME']);
						panelResult.setValue('ADDR2', records[0]['ADDR2']);

						var records2 = detailStore.data.items;
						Ext.each(records2, function(record) {
							record.set('ZIP_CODE'	, records[0]['ZIP_CODE']);
							record.set('ADDR1'		, records[0]['ZIP_NAME']);
							record.set('ADDR2'		, records[0]['ADDR2']);
						});
					},
					scope: this
				},
				'onClear' : function(type)	{
					panelResult.setValue('ADDR1', '');
					panelResult.setValue('ADDR2', '');

					var records2 = detailStore.data.items;
					Ext.each(records2, function(record) {
						record.set('ZIP_CODE'	, '');
						record.set('ADDR1'		, '');
						record.set('ADDR2'		, '');
					});
				},
				applyextparam: function(popup){
					var paramAddr	= panelResult.getValue('ADDR1'); //우편주소 파라미터로 넘기기
					if(Ext.isEmpty(paramAddr)){
						popup.setExtParam({'GBN': 'post'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
					} else {
						popup.setExtParam({'GBN': 'addr'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
					}
					popup.setExtParam({'ADDR': paramAddr});
				}
			}
		}),{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			colspan	: 2,
				items	: [{
				fieldLabel	: '주소',
				xtype		: 'uniTextfield',
				name		: 'ADDR1' ,
				holdable	: 'hold',
				width		: 350,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						var records = detailStore.data.items;
						Ext.each(records, function(record) {
							record.set('ADDR1', newValue);
						});
					}
				}
			},{
				fieldLabel	: '',
				xtype		: 'uniTextfield',
				name		: 'ADDR2',
				holdable	: 'hold',
				width		: 143,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						var records = detailStore.data.items;
						Ext.each(records, function(record) {
							record.set('ADDR2', newValue);
						});
					}
				}
			}]
		},{
			fieldLabel	: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			xtype		: 'uniDatefield',
			name		: 'SALE_DATE',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.currency" default="화폐"/>',
			name		: 'MONEY_UNIT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B004',
			value		: UserInfo.currency,
			allowBlank	: false,
			displayField: 'value',
			readOnly	: true,
///////////////////////////////////////숨기기(테스트용으로 보이게 설정)
			hidden		: true,
			fieldStyle	: 'text-align: center;',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					fnSetColumnFormat();
				},
				blur: function( field, The, eOpts ) {
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.exchangerate" default="환율"/>',
			xtype			: 'uniNumberfield',
			name			: 'EXCHG_RATE_O',
			decimalPrecision: 4,
			value			: 1,
			readOnly		: true,
///////////////////////////////////////숨기기(테스트용으로 보이게 설정)
			hidden			: true,
			listeners		: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'uniTextfield',
			name	: 'NATION_INOUT',
			readOnly: true,
///////////////////////////////////////숨기기(테스트용으로 보이게 설정)
			hidden	: true
		}],
		listeners: {
			uniOnChange:function( basicForm, dirty, eOpts ) {
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
		}
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_sal100ukrv_wmService.selectList',
			update	: 's_sal100ukrv_wmService.updateDetail',
			create	: 's_sal100ukrv_wmService.insertDetail',
			destroy	: 's_sal100ukrv_wmService.deleteDetail',
			syncAll	: 's_sal100ukrv_wmService.saveAll'
		}
	});

	Unilite.defineModel('s_sal100ukrv_wmModel', {
		fields: [
			{name: 'INOUT_SEQ'				, text:'<t:message code="system.label.sales.seq" default="순번"/>'						, type: 'int', allowBlank: false},
			{name: 'CUSTOM_NAME'			, text:'<t:message code="system.label.sales.customname" default="거래처명"/>'				, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		, text:'<t:message code="system.label.sales.issuetype" default="출고유형"/>'				, type: 'string', comboType: 'AU', comboCode: 'S007', allowBlank: false, defaultValue: Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value')},
			{name: 'WH_CODE'				, text:'<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'			, type: 'string', comboType   : 'OU', allowBlank: false/*, child: 'WH_CELL_CODE'*/},
			{name: 'WH_NAME'				, text:'<t:message code="system.label.sales.issuewarehousename" default="출고창고명"/>'		, type: 'string'},
			{name: 'WH_CELL_CODE'			, text:'<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>'	, type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList')/*, parentNames:['WH_CODE','SALE_DIV_CODE']*/},
			{name: 'WH_CELL_NAME'			, text:'<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>'	, type: 'string'},
			{name: 'SALE_DIV_CODE'			, text:'<t:message code="system.label.sales.salesdivision" default="매출사업장"/>'			, type: 'string', allowBlank: false,comboType:'BOR120'},
			{name: 'ITEM_CODE'				, text:'<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'				, text:'<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'					, text:'<t:message code="system.label.sales.spec" default="규격"/>'						, type: 'string'},
			{name: 'LOT_NO'					, text:'<t:message code="system.label.sales.lotno" default="LOT NO"/>'					, type: 'string'},
			{name: 'ITEM_STATUS'			, text:'<t:message code="system.label.sales.itemstatus" default="품목상태"/>'				, type: 'string', comboType: 'AU', comboCode: 'B021', defaultValue: "1", allowBlank: false},
			{name: 'ORDER_UNIT'				, text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'				, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'B013', displayField: 'value'},
			{name: 'PRICE_TYPE'				, text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string', defaultValue: BsaCodeInfo.gsPriceGubun},
			{name: 'TRANS_RATE'				, text:'<t:message code="system.label.sales.containedqty" default="입수"/>'				, type: 'uniQty', defaultValue: 1, allowBlank: false},
			{name: 'PACK_UNIT_Q'			, text:'<t:message code="system.label.sales.packunitq" default="BOX입수"/>'				, type: 'uniQty'},
			{name: 'BOX_Q'					, text:'<t:message code="system.label.sales.boxq" default="BOX수"/>'						, type: 'uniQty'},
			{name: 'EACH_Q'					, text:'<t:message code="system.label.sales.eachq" default="낱개"/>'						, type: 'uniQty'},
			{name: 'LOSS_Q'					, text:'<t:message code="system.label.sales.lossq" default="LOSS여분"/>'					, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q'			, text:'수량'						, type: 'uniQty', defaultValue: 0, allowBlank: false},
			{name: 'TEMP_ORDER_UNIT_Q'		, text:'TEMP_ORDER_UNIT_Q'		, type: 'uniQty'},//LOT팝업에서 허용된 수량만 입력하기 위해..
			{name: 'ORDER_UNIT_P'			, text:'<t:message code="system.label.sales.price" default="단가"/>'						, type: 'uniUnitPrice', defaultValue: 0, allowBlank: true, editable: true},
			{name: 'INOUT_WGT_Q'			, text:'<t:message code="system.label.sales.issueqty" default="출고량"/>(<t:message code="system.label.sales.weight" default="중량"/>)'			, type: 'uniQty', defaultValue: 0},
			{name: 'INOUT_FOR_WGT_P'		, text:'<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'			, type: 'uniUnitPrice', defaultValue: 0},
			{name: 'INOUT_VOL_Q'			, text:'<t:message code="system.label.sales.issueqty" default="출고량"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'			, type: 'uniQty', defaultValue: 0},
			{name: 'INOUT_FOR_VOL_P'		, text:'<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'			, type: 'uniUnitPrice', defaultValue: 0},
			{name: 'INOUT_WGT_P'			, text:'<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.weight" default="중량"/>)'			, type: 'uniUnitPrice', defaultValue: 0},
			{name: 'INOUT_VOL_P'			, text:'<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'			, type: 'uniUnitPrice', defaultValue: 0},
			{name: 'ORDER_UNIT_O'			, text:'<t:message code="system.label.sales.amount" default="금액"/>'						, type: 'uniPrice', defaultValue: 0, allowBlank: true},
			{name: 'ORDER_AMT_SUM'			, text:'<t:message code="system.label.sales.totalamount1" default="합계금액"/>'				, type: 'uniPrice', defaultValue: 0},
			{name: 'TAX_TYPE'				, text:'<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'			, type: 'string', comboType: 'AU', comboCode: 'B059', defaultValue: "1", allowBlank: false},
			{name: 'INOUT_TAX_AMT'			, text:'<t:message code="system.label.sales.vatamount" default="부가세액"/>'				, type: 'uniPrice', defaultValue: 0, allowBlank: true},
			{name: 'WGT_UNIT'				, text:'<t:message code="system.label.sales.weightunit" default="중량단위"/>'				, type: 'string', defaultValue: BsaCodeInfo.gsWeight},
			{name: 'UNIT_WGT'				, text:'<t:message code="system.label.sales.unitweight" default="단위중량"/>'				, type: 'int', defaultValue: 0},
			{name: 'VOL_UNIT'				, text:'<t:message code="system.label.sales.volumnunit" default="부피단위"/>'				, type: 'string', defaultValue: BsaCodeInfo.gsVolume},
			{name: 'UNIT_VOL'				, text:'<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'				, type: 'string', defaultValue: 0},
			{name: 'TRANS_COST'				, text:'<t:message code="system.label.sales.shippingcharge" default="운반비"/>'			, type: 'uniPrice', defaultValue: 0},
			{name: 'DISCOUNT_RATE'			, text:'<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'			, type: 'uniPercent', defaultValue: 0},
			{name: 'STOCK_Q'				, text:'<t:message code="system.label.sales.inventoryqty2" default="재고수량"/>'			, type: 'uniQty'},
			{name: 'ORDER_STOCK_Q'			, text:'<t:message code="system.label.sales.unit" default="단위"/><t:message code="system.label.sales.inventoryqty2" default="재고수량"/>'			, type: 'uniQty'},
			{name: 'PRICE_YN'				, text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string', comboType: 'AU', comboCode: 'S003', defaultValue: "2", allowBlank: false},
			{name: 'ACCOUNT_YNC'			, text:'<t:message code="system.label.sales.salessubject" default="매출대상"/>'				, type: 'string', comboType: 'AU', comboCode: 'S014', defaultValue: "Y", allowBlank: false},
			{name: 'DELIVERY_DATE'			, text:'<t:message code="system.label.sales.deliverydate2" default="납품일"/>'				, type: 'uniDate'},
			{name: 'DELIVERY_TIME'			, text:'<t:message code="system.label.sales.deliverytime2" default="납품시간"/>'			, type: 'string'},
			{name: 'RECEIVER_ID'			, text:'<t:message code="system.label.sales.receiverid" default="수신자ID"/>'				, type: 'string'},
			{name: 'RECEIVER_NAME'			, text:'<t:message code="system.label.sales.receivername" default="수신자명"/>'				, type: 'string'},
			{name: 'TELEPHONE_NUM1'			, text:'<t:message code="system.label.sales.phoneno1" default="전화번호"/>'					, type: 'string'},
			{name: 'TELEPHONE_NUM2'			, text:'<t:message code="system.label.sales.phoneno1" default="전화번호"/>'					, type: 'string'},
			{name: 'ADDRESS'				, text:'<t:message code="system.label.sales.address" default="주소"/>'					, type: 'string'},
			{name: 'SALE_CUST_CD'			, text:'<t:message code="system.label.sales.salesplace" default="매출처"/>'				, type: 'string', allowBlank: false},////매출처 defaultValue 다시 분석
			{name: 'SALE_PRSN'				, text:'<t:message code="system.label.sales.salescharge" default="영업담당"/>'				, type: 'string', comboType: 'AU', comboCode: 'S010'}, ////거래처의 주영업담당
			{name: 'DVRY_CUST_CD'			, text:'<t:message code="system.label.sales.deliveryplace" default="배송처"/>'				, type: 'string'},
			{name: 'DVRY_CUST_NAME'			, text:'<t:message code="system.label.sales.deliveryplace" default="배송처"/>'				, type: 'string'},
			{name: 'ORDER_CUST_CD'			, text:'<t:message code="system.label.sales.soplace" default="수주처"/>'					, type: 'string'},
			{name: 'PLAN_NUM'				, text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'ORDER_NUM'				, text:'<t:message code="system.label.sales.sono" default="수주번호"/>'						, type: 'string'},
			{name: 'ISSUE_REQ_NUM'			, text:'<t:message code="system.label.sales.shipmentno" default="출하번호"/>'				, type: 'string'},
			{name: 'BASIS_NUM'				, text:'<t:message code="system.label.sales.pono2" default="P/O 번호"/>'					, type: 'string'},
			{name: 'PAY_METHODE1'			, text:'<t:message code="system.label.sales.amountpaymethod" default="대금결제방법"/>'		, type: 'string'},
			{name: 'LC_SER_NO'				, text:'<t:message code="system.label.sales.lcno" default="L/C번호"/>'					, type: 'string'},
			{name: 'REMARK'					, text:'<t:message code="system.label.sales.remarks" default="비고"/>'					, type: 'string'},
			{name: 'INOUT_NUM'				, text:'INOUT_NUM'				, type: 'string'},
			{name: 'INOUT_DATE'				, text:'INOUT_DATE'				, type: 'uniDate', allowBlank: false},
			{name: 'INOUT_METH'				, text:'INOUT_METH'				, type: 'string', defaultValue: "2", allowBlank: false},
			{name: 'INOUT_TYPE'				, text:'INOUT_TYPE'				, type: 'string', defaultValue: "2", allowBlank: false},
			{name: 'DIV_CODE'				, text:'DIV_CODE'				, type: 'string', allowBlank: false},
			{name: 'INOUT_CODE_TYPE'		, text:'INOUT_CODE_TYPE'		, type: 'string', defaultValue: "4", allowBlank: false},
			{name: 'INOUT_CODE'				, text:'INOUT_CODE'				, type: 'string', allowBlank: false},
			{name: 'SALE_CUSTOM_CODE'		, text:'SALE_CUSTOM_CODE'		, type: 'string', allowBlank: false},
			{name: 'CREATE_LOC'				, text:'CREATE_LOC'				, type: 'string', allowBlank: false},
			{name: 'UPDATE_DB_USER'			, text:'UPDATE_DB_USER'			, type: 'string', defaultValue: UserInfo.userID},
			{name: 'UPDATE_DB_TIME'			, text:'UPDATE_DB_TIME'			, type: 'string'},
			{name: 'MONEY_UNIT'				, text:'MONEY_UNIT'				, type: 'string', allowBlank: false , comboType:'AU', comboCode:'B004'},
			{name: 'EXCHG_RATE_O'			, text:'EXCHG_RATE_O'			, type: 'uniER', allowBlank: false, defaultValue: 1},
			{name: 'ORIGIN_Q'				, text:'ORIGIN_Q'				, type: 'uniQty'},
			{name: 'ORDER_NOT_Q'			, text:'ORDER_NOT_Q'			, type: 'uniQty'},
			{name: 'ISSUE_NOT_Q'			, text:'ISSUE_NOT_Q'			, type: 'uniQty'},
			{name: 'ORDER_SEQ'				, text:'ORDER_SEQ'				, type: 'int'},
			{name: 'ISSUE_REQ_SEQ'			, text:'ISSUE_REQ_SEQ'			, type: 'uniQty'},
			{name: 'BASIS_SEQ'				, text:'BASIS_SEQ'				, type: 'int'},
			{name: 'ORDER_TYPE'				, text:'ORDER_TYPE'				, type: 'string'},
			{name: 'STOCK_UNIT'				, text:'STOCK_UNIT'				, type: 'string'},
			{name: 'BILL_TYPE'				, text:'<t:message code="system.label.sales.vattype" default="부가세유형"/>'					, type: 'string', comboType:'AU', comboCode:'S024', defaultValue: "10", allowBlank: false},	//20210216 수정: '부가세유형' 컬럼 콤보로 변경 / 수정 가능하도록 변경 (hidden: false) / 변경에 따른 금액 계산로직 추가
			{name: 'SALE_TYPE'				, text:'SALE_TYPE'				, type: 'string', allowBlank: false},
			{name: 'CREDIT_YN'				, text:'CREDIT_YN'				, type: 'string', defaultValue: BsaCodeInfo.gsCustCreditYn},
			{name: 'ACCOUNT_Q'				, text:'ACCOUNT_Q'				, type: 'uniQty', defaultValue: 0},
			{name: 'SALE_C_YN'				, text:'SALE_C_YN'				, type: 'string', defaultValue: "N"},
			{name: 'INOUT_PRSN'				, text:'INOUT_PRSN'				, type: 'string'},
			{name: 'WON_CALC_BAS'			, text:'WON_CALC_BAS'			, type: 'string', defaultValue: BsaCodeInfo.gsUnderCalBase},
			{name: 'TAX_INOUT'				, text:'<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>'		, type: 'string', comboType:'AU', comboCode:'B030'},
			{name: 'AGENT_TYPE'				, text:'AGENT_TYPE'				, type: 'string', defaultValue: BsaCodeInfo.gsAgentType},
			{name: 'STOCK_CARE_YN'			, text:'STOCK_CARE_YN'			, type: 'string'},
			{name: 'RETURN_Q_YN'			, text:'RETURN_Q_YN'			, type: 'string'},
			{name: 'REF_CODE2'				, text:'REF_CODE2'				, type: 'string'}, ////defaultValue: INOUT_TYPE_DETAIL(출고유형)의 SUB_CODE를들고REF_CODE2를 참조해옴
			{name: 'EXCESS_RATE'			, text:'EXCESS_RATE'			, type: 'int'},
			{name: 'SRC_ORDER_Q'			, text:'SRC_ORDER_Q'			, type: 'string'},
			{name: 'SOF110T_PRICE'			, text:'SOF110T_PRICE'			, type: 'uniPrice'},
			{name: 'SRQ100T_PRICE'			, text:'SRQ100T_PRICE'			, type: 'uniPrice'},
			{name: 'COMP_CODE'				, text:'COMP_CODE'				, type: 'string', defaultValue: UserInfo.compCode, allowBlank: false },
			{name: 'DEPT_CODE'				, text:'DEPT_CODE'				, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text:'ITEM_ACCOUNT'			, type: 'string'},
			{name: 'GUBUN'					, text:'GUBUN'					, type: 'string'},
			{name: 'LOT_YN'					, text:'LOT_YN'					, type: 'string'},
			{name: 'NATION_INOUT'			, text:'NATION_INOUT'			, type: 'string'},
			{name: 'SALE_DATE'				, text:'SALE_DATE'				, type: 'uniDate'},
			{name: 'REMARK_INTER'			, text:'<t:message code="system.label.sales.remarkinter" default="내부기록사항"/>'		, type: 'string'},
			{name: 'KEY_IN_ITEM_NAME'		, text:'KEY_IN_ITEM_NAME'		, type: 'string'},
			{name: 'KEY_IN_PART_ITEM_NAME'	, text:'KEY_IN_PART_ITEM_NAME'	, type: 'string'},
			//20210201 추가: CUSTOM_PRSN, PHONE, ZIP_CODE, ADDR1, ADDR2
			{name: 'CUSTOM_PRSN'			, text:'CUSTOM_PRSN'			, type: 'string'},
			{name: 'PHONE'					, text:'PHONE'					, type: 'string'},
			{name: 'ZIP_CODE'				, text:'ZIP_CODE'				, type: 'string'},
			{name: 'ADDR1'					, text:'ADDR1'					, type: 'string'},
			{name: 'ADDR2'					, text:'ADDR2'					, type: 'string'},
			{name: 'GOODS_CODE'				, text:'상품코드'					, type: 'string'},										//20210225 추가: GOODS_CODE
			{name: 'CARD_CUSTOM_CODE'		, text: '카드사'					, type: 'string', comboType: 'AU', comboCode: 'A028'}	//20210308 추가
		]
	});

	var detailStore = Unilite.createStore('s_sal100ukrv_wmDetailStore',{
		model	: 's_sal100ukrv_wmModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function(newValue) {
			var param = panelResult.getValues();
			if(newValue || newValue == '') {
				param.rdoSelect = newValue;
			}
			console.log( param );
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
						if(records) {
							panelResult.setValue('CUSTOM_PRSN'	, records[0].get('CUSTOM_PRSN'));
							panelResult.setValue('PHONE'		, records[0].get('PHONE'));
							panelResult.setValue('ZIP_CODE'		, records[0].get('ZIP_CODE'));
							panelResult.setValue('ADDR1'		, records[0].get('ADDR1'));
							panelResult.setValue('ADDR2'		, records[0].get('ADDR2'));
						}
					}
				}
			});
		},
		saveStore : function(config) {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);
			var isErr		= false;

			var orderNum = panelResult.getValue('INOUT_NUM');
			var isErr = false;
			Ext.each(list, function(record, index) {
				if(record.data['INOUT_NUM'] != orderNum) {
					record.set('INOUT_NUM', orderNum);
				}
				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))) {
					Unilite.messageBox((index + 1) + '<t:message code="system.message.sales.message060" default="행의 입력값을 확인해 주세요."/>\n' + '<t:message code="system.message.sales.message070" default="LOT NO: 필수 입력값 입니다."/>');
					isErr = true;
					return false;
				}
				//20200911 로직 추가: 출고유형이 '부품반납(재고환입)'이면 단가, 금액 0 입력 가능
				if(record.get('INOUT_TYPE_DETAIL') != '30') {
					if(record.get('ACCOUNT_YNC') == 'Y') {
						if(Ext.isEmpty(record.get('ORDER_UNIT_P')) || record.get('ORDER_UNIT_P') == 0) {
							Unilite.messageBox((index + 1) + '<t:message code="system.message.sales.message060" default="행의 입력값을 확인해 주세요."/>\n' + '<t:message code="system.message.sales.message071" default="매출대상은 단가가 필수 입력값 입니다."/>');
							isErr = true;
							return false;
						}
						if(Ext.isEmpty(record.get('ORDER_UNIT_O')) || record.get('ORDER_UNIT_O') == 0) {
							Unilite.messageBox((index + 1) + '<t:message code="system.message.sales.message060" default="행의 입력값을 확인해 주세요."/>\n' + '<t:message code="system.message.sales.message072" default="매출대상은 금액이 필수 입력값 입니다."/>');
							isErr = true;
							return false;
						}
					}
				}
			});
			if(isErr) {
				return false;
			}
			var paramMaster	= panelResult.getValues();

			if(inValidRecs.length == 0) {
				if(config == null) {
					config = {
						params	: [paramMaster],
						success	: function(batch, option) {
							var master = batch.operations[0].getResultSet();
							panelResult.setValue("INOUT_NUM", master.INOUT_NUM);

							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);
	
							if(detailStore.getCount() == 0) {
								UniAppManager.app.onResetButtonDown();
							} else {
								UniAppManager.app.onQueryButtonDown();
							}
						}
					};
				}
				this.syncAllDirect(config);
			} else {
				 detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		fnOrderAmtSum: function() {
			var dtotQty		= 0;
			var dSaleTI		= 0;
			var dSaleNTI	= 0;
			var dTaxI		= 0;

			var results = this.sumBy(function(record, id) {
										return record.get('TAX_TYPE') == '1';},
									['ORDER_UNIT_O','INOUT_TAX_AMT']);
			dSaleTI	= results.ORDER_UNIT_O;
			dTaxI	= results.INOUT_TAX_AMT;
			console.log("과세 - 과세된총액:"+dSaleTI);		//과세된총액
			console.log("과세 - 부가세총액:"+dTaxI);		//부가세총액

			var results = this.sumBy(function(record, id) {
										return record.get('TAX_TYPE') == '2';},
									['ORDER_UNIT_O']);
			dSaleNTI = results.ORDER_UNIT_O;
			console.log("면세 - 면세된총액:"+dSaleNTI);	//면세된총액

			dtotQty = Ext.isNumeric(this.sum('ORDER_UNIT_Q')) ? this.sum('ORDER_UNIT_Q'):0; //수량총계
			panelResult.setValue('TOT_SALE_TAXI'	, dSaleTI);								//과세총액(1)
			panelResult.setValue('TOT_SALENO_TAXI'	, dSaleNTI);							//면세총액(3)
			panelResult.setValue('TOT_TAXI'			, dTaxI);								//세액합계(2)
			panelResult.setValue('TOTAL_AMT'		, dSaleTI + dSaleNTI + dTaxI);			//출고총액
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				this.fnOrderAmtSum();
				isLoad = false;
			},
			add: function(store, records, index, eOpts) {
				this.fnOrderAmtSum();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				this.fnOrderAmtSum();
			},
			remove: function(store, record, index, isMove, eOpts) {
				this.fnOrderAmtSum();
			}
		}
	});

	var detailGrid = Unilite.createGrid('s_sal100ukrv_wmGrid', {
		store	: detailStore,
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: false
		},
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',showSummaryRow: true},
					{id : 'masterGridTotal',	ftype: 'uniSummary',		showSummaryRow: true}],
		columns:[
//			{dataIndex: 'CUSTOM_PRSN'			, width:100},		//20210201 확인용 컬럼
//			{dataIndex: 'PHONE'					, width:100},		//20210201 확인용 컬럼
//			{dataIndex: 'ZIP_CODE'				, width:100},		//20210201 확인용 컬럼
//			{dataIndex: 'ADDR1'					, width:100},		//20210201 확인용 컬럼
//			{dataIndex: 'ADDR2'					, width:100},		//20210201 확인용 컬럼
//			{dataIndex: 'CARD_CUSTOM_CODE'		, width:100},		//20210308 확인용 컬럼
			{dataIndex: 'INOUT_SEQ'				, width:60	, align: 'center'	, hidden: false},
			{dataIndex: 'CUSTOM_NAME'			, width:133, hidden: true},
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width:80},
			{dataIndex: 'WH_CODE'				, width:150,
				listeners:{
					render:function(elm) {
						elm.editor.on('beforequery',function(queryPlan, eOpts) {
							var store = queryPlan.combo.store;
							var record = detailGrid.uniOpt.currentRecord;
							store.clearFilter();
							store.filterBy(function(item) {
								return item.get('option') == (Ext.isEmpty(record.get('SALE_DIV_CODE')) ? panelResult.getValue('DIV_CODE') : record.get('SALE_DIV_CODE'));
							})
						})
					}
				}
			},
			{dataIndex: 'WH_NAME'				, width:93	, hidden: true},
			{dataIndex: 'WH_CELL_CODE'			, width:120	, hidden: sumtypeCell,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filterBy(function(item) {
						return item.get('option') == record	.get('WH_CODE')
							//BSA225T의 CUSTOM_CODE가 비어 있거나 	panelResult의 값과 동일한 데이터만 show
							&&(item.get('refCode10') == panelResult.getValue('CUSTOM_CODE') || item.get('refCode10') == '*')
					})
				}
			},
			{dataIndex: 'WH_CELL_NAME'			, width:100	, hidden: true},
			{dataIndex: 'SALE_DIV_CODE'			, width:100	, hidden: true},
			{dataIndex: 'ITEM_CODE'				, width:113,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					useBarcodeScanner: false,
					autoPopup:true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
								if(i==0) {
										detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup) {
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'				, width:200,
				editor: Unilite.popup('DIV_PUMOK_G', {
					autoPopup:true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup) {
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode});
						}
					}
				})
			},
			{dataIndex: 'SPEC'					, width:150},
			{dataIndex: 'LOT_NO'				, width:120	, hidden: true},
			{dataIndex: 'DISCOUNT_RATE'			, width:80	, hidden: true},
			{dataIndex: 'ORDER_UNIT'			, width:80	, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'ITEM_STATUS'			, width:80	, align: 'center', hidden: true},
			{dataIndex: 'PACK_UNIT_Q'			, width:100	, hidden: BsaCodeInfo.gsBoxYN == 'Y' ? false : true},
			{dataIndex: 'BOX_Q'					, width:100	, hidden: BsaCodeInfo.gsBoxYN == 'Y' ? false : true},
			{dataIndex: 'EACH_Q'				, width:100	, hidden: BsaCodeInfo.gsBoxYN == 'Y' ? false : true},
			{dataIndex: 'LOSS_Q'				, width:100	, hidden: BsaCodeInfo.gsBoxYN == 'Y' ? false : true},
			{dataIndex: 'ORDER_UNIT_Q'			, width:93	, summaryType: 'sum' },
			{dataIndex: 'TRANS_RATE'			, width:60	, hidden: true},
			{dataIndex: 'ORDER_UNIT_P'			, width:100	, summaryType: 'sum' },
			{dataIndex: 'ORDER_UNIT_O'			, width:120	, summaryType: 'sum' },
			{dataIndex: 'INOUT_TAX_AMT'			, width:120	, summaryType: 'sum' },
			{dataIndex: 'ORDER_AMT_SUM'			, width:120	, hidden: true, summaryType: 'sum' },
			{dataIndex: 'TAX_TYPE'				, width:80	, hidden: true, align: 'center'},
			{dataIndex: 'TAX_INOUT'				, width:88	, align: 'center'},
			{dataIndex: 'STOCK_Q'				, width:100	, hidden: true, summaryType: 'sum'},
			{dataIndex: 'ORDER_STOCK_Q'			, width:100	, hidden: true, summaryType: 'sum'},
			{dataIndex: 'SALE_PRSN'				, width:80	, hidden: true, align: 'center'},
			{dataIndex: 'PRICE_TYPE'			, width:110	, hidden: true },
			{dataIndex: 'INOUT_WGT_Q'			, width:106	, hidden: true },
			{dataIndex: 'INOUT_FOR_WGT_P'		, width:106	, hidden: true },
			{dataIndex: 'INOUT_VOL_Q'			, width:106	, hidden: true },
			{dataIndex: 'INOUT_FOR_VOL_P'		, width:106	, hidden: true },
			{dataIndex: 'INOUT_WGT_P'			, width:106	, hidden: true },
			{dataIndex: 'INOUT_VOL_P'			, width:106	, hidden: true },
			{dataIndex: 'WGT_UNIT'				, width:66	, hidden: true },
			{dataIndex: 'UNIT_WGT'				, width:100	, hidden: true },
			{dataIndex: 'VOL_UNIT'				, width:80	, hidden: true },
			{dataIndex: 'UNIT_VOL'				, width:93	, hidden: true },
			{dataIndex: 'TRANS_COST'			, width:93	, hidden: true, summaryType: 'sum' },
			{dataIndex: 'PRICE_YN'				, width:73	, hidden: true, align: 'center' },
			{dataIndex: 'ACCOUNT_YNC'			, width:73	, hidden: true, align: 'center' },
			{dataIndex: 'DELIVERY_DATE'			, width:80	, hidden: true},
			{dataIndex: 'DELIVERY_TIME'			, width:66	, hidden: true },
			{dataIndex: 'RECEIVER_ID'			, width:86	, hidden: true },
			{dataIndex: 'RECEIVER_NAME'			, width:86	, hidden: true },
			{dataIndex: 'TELEPHONE_NUM1'		, width:80	, hidden: true },
			{dataIndex: 'TELEPHONE_NUM2'		, width:80	, hidden: true },
			{dataIndex: 'ADDRESS'				, width:133	, hidden: true },
			{dataIndex: 'SALE_CUST_CD'			, width:110	, hidden: true,
				editor: Unilite.popup('AGENT_CUST_G',{
					autoPopup:true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ) {
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('SALE_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('SALE_CUST_CD',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SALE_CUSTOM_CODE','');
							grdRecord.set('SALE_CUST_CD','');
						},
						applyextparam: function(popup) {
							popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
							popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
						}
					}
				})
			},
			{dataIndex: 'DVRY_CUST_CD'			, width:113	, hidden: true },
			{dataIndex: 'DVRY_CUST_NAME'		, width:113	, hidden: true,
				editor: Unilite.popup('DELIVERY_G',{autoPopup:true,listeners:{
					'onSelected': {
						fn: function(records, type  ) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DVRY_CUST_CD',records[0]['DELIVERY_CODE']);
							grdRecord.set('DVRY_CUST_NAME',records[0]['DELIVERY_NAME']);
						},
						scope: this
					},
					'onClear' : function(type) {
						var grdRecord = detailGrid.uniOpt.currentRecord;
						grdRecord.set('DVRY_CUST_CD','');
						grdRecord.set('DVRY_CUST_NAME','');
					},
					applyextparam: function(popup) {
							popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
						}
					}
				})
			},
			{dataIndex: 'ORDER_CUST_CD'			, width:113	, hidden: true},
			{dataIndex: 'PLAN_NUM'				, width:100	, hidden: true},
			{dataIndex: 'ORDER_NUM'				, width:120	, hidden: true},
			{dataIndex: 'ISSUE_REQ_NUM'			, width:100	, hidden: true},
			{dataIndex: 'BASIS_NUM'				, width:100	, hidden: true},
			{dataIndex: 'PAY_METHODE1'			, width:200	, hidden: true},
			{dataIndex: 'LC_SER_NO'				, width:100	, hidden: true},
			{dataIndex: 'REMARK'				, width:100	, hidden: true},
			{dataIndex: 'REMARK_INTER'			, width:100	, hidden: true},
			{dataIndex: 'LOT_ASSIGNED_YN'		, width:100	, hidden: true},
			{dataIndex: 'INOUT_NUM'				, width:80	, hidden: true},
			{dataIndex: 'INOUT_DATE'			, width:66	, hidden: true},
			{dataIndex: 'INOUT_METH'			, width:66	, hidden: true},
			{dataIndex: 'INOUT_TYPE'			, width:66	, hidden: true},
			{dataIndex: 'DIV_CODE'				, width:66	, hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'		, width:66	, hidden: true},
			{dataIndex: 'INOUT_CODE'			, width:66	, hidden: true},
			{dataIndex: 'SALE_CUSTOM_CODE'		, width:66	, hidden: true},
			{dataIndex: 'CREATE_LOC'			, width:66	, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'		, width:66	, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'		, width:66	, hidden: true},
			{dataIndex: 'MONEY_UNIT'			, width:66	, hidden: true},
			{dataIndex: 'EXCHG_RATE_O'			, width:66	, hidden: true},
			{dataIndex: 'ORIGIN_Q'				, width:66	, hidden: true},
			{dataIndex: 'ORDER_NOT_Q'			, width:66	, hidden: true},
			{dataIndex: 'ISSUE_NOT_Q'			, width:66	, hidden: true},
			{dataIndex: 'ORDER_SEQ'				, width:66	, hidden: true},
			{dataIndex: 'ISSUE_REQ_SEQ'			, width:66	, hidden: true},
			{dataIndex: 'BASIS_SEQ'				, width:66	, hidden: true},
			{dataIndex: 'ORDER_TYPE'			, width:66	, hidden: true},
			{dataIndex: 'STOCK_UNIT'			, width:66	, hidden: true},
			{dataIndex: 'BILL_TYPE'				, width:100	, hidden: false},		//20210216 수정: '부가세유형' 컬럼 콤보로 변경 / 수정 가능하도록 변경 (hidden: false) / 변경에 따른 금액 계산로직 추가
			{dataIndex: 'SALE_TYPE'				, width:66	, hidden: true},
			{dataIndex: 'CREDIT_YN'				, width:66	, hidden: true},
			{dataIndex: 'ACCOUNT_Q'				, width:66	, hidden: true},
			{dataIndex: 'SALE_C_YN'				, width:66	, hidden: true},
			{dataIndex: 'INOUT_PRSN'			, width:66	, hidden: true},
			{dataIndex: 'WON_CALC_BAS'			, width:66	, hidden: true},
			{dataIndex: 'AGENT_TYPE'			, width:66	, hidden: true},
			{dataIndex: 'STOCK_CARE_YN'			, width:66	, hidden: true},
			{dataIndex: 'RETURN_Q_YN'			, width:66	, hidden: true},
			{dataIndex: 'REF_CODE2'				, width:66	, hidden: true},
			{dataIndex: 'EXCESS_RATE'			, width:66	, hidden: true},
			{dataIndex: 'SRC_ORDER_Q'			, width:66	, hidden: true},
			{dataIndex: 'SOF110T_PRICE'			, width:66	, hidden: true},
			{dataIndex: 'SRQ100T_PRICE'			, width:66	, hidden: true},
			{dataIndex: 'COMP_CODE'				, width:66	, hidden: true},
			{dataIndex: 'DEPT_CODE'				, width:66	, hidden: true},
			{dataIndex: 'ITEM_ACCOUNT'			, width:66	, hidden: true},
			{dataIndex: 'GUBUN'					, width:66	, hidden: true},
			{dataIndex: 'TEMP_ORDER_UNIT_Q'		, width:66	, hidden: true},
			{dataIndex: 'LOT_YN'				, width:66	, hidden: true},
			{dataIndex: 'NATION_INOUT'			, width:66	, hidden: true},
			{dataIndex: 'SALE_DATE'				, width:66	, hidden: true},
			{dataIndex: 'KEY_IN_ITEM_NAME'		, width:66	, hidden: true},
			{dataIndex: 'KEY_IN_PART_ITEM_NAME'	, width:66	, hidden: true},
			//20210225 추가: GOODS_CODE
			{dataIndex: 'GOODS_CODE'			, width:100	, hidden: false}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, 'GOODS_CODE')) {
					if(Ext.isEmpty(e.record.get('ITEM_CODE'))) {
						Unilite.messageBox('품목정보를 먼저 입력한 후, 상품정보를 입력하세요.');
						return false;
					}
				}

				if (UniUtils.indexOf(e.field, 'LOT_NO')) {
					if(BsaCodeInfo.gsSumTypeCell == 'Y' && Ext.isEmpty(e.record.data.WH_CELL_CODE)) {
						Unilite.messageBox('<t:message code="system.message.sales.message059" default="출고창고 CELL코드를 입력하십시오."/>');
						return false;
					}
					if(Ext.isEmpty(e.record.data.ITEM_CODE)) {
						Unilite.messageBox('<t:message code="system.message.sales.message024" default="품목코드를 입력하십시오."/>');
						return false;
					}
				}

				if(UniUtils.indexOf(e.field, ['TRANS_RATE'])) {
					if(e.record.data.ORDER_UNIT != e.record.data.STOCK_UNIT) {
						return true;
					}else{
						return false;
					}
				}

				if(e.record.phantom) {			//신규일때
					if(e.record.data.INOUT_METH == '2') {	//예외등록(추가버튼)
						if (UniUtils.indexOf(e.field, ['SPEC', 'STOCK_Q', 'ORDER_CUST_CD', 'PLAN_NUM', 'ORDER_NUM', 'ISSUE_REQ_NUM', 'BASIS_NUM'])) {
							return false;
						}
						if(!Ext.isEmpty(e.record.data.GUBUN)) {
							if (UniUtils.indexOf(e.field, ['PRICE_TYPE', 'WGT_UNIT', 'VOL_UNIT'])) {
								return false;
							}
						}
					}
				} else {						//신규가 아닐때
					if (UniUtils.indexOf(e.field,
											['INOUT_TYPE_DETAIL', 'TRANS_RATE', 'INOUT_WGT_P', 'INOUT_VOL_P', 'UNIT_WGT', 'UNIT_VOL', 'INOUT_SEQ',
											 'CUSTOM_NAME', 'WH_CODE', 'WH_NAME', 'WH_CELL_CODE', 'WH_CELL_NAME', 'SALE_DIV_CODE', 'ITEM_CODE', 'ITEM_NAME',
											 'SPEC', 'ITEM_STATUS', 'ORDER_UNIT', 'TAX_TYPE', 'INOUT_TAX_AMT', 'STOCK_Q', 'RECEIVER_ID',
											 'RECEIVER_NAME', 'TELEPHONE_NUM1', 'TELEPHONE_NUM2', 'ADDRESS',
											 'ORDER_CUST_CD', 'PLAN_NUM', 'ORDER_NUM', 'ISSUE_REQ_NUM', 'BASIS_NUM', 'PAY_METHODE1', 'LC_SER_NO', 'INOUT_NUM',
											 'INOUT_DATE', 'INOUT_METH', 'INOUT_TYPE', 'DIV_CODE', 'INOUT_CODE_TYPE', 'INOUT_CODE',
											 'CREATE_LOC', 'UPDATE_DB_USER', 'UPDATE_DB_TIME', 'MONEY_UNIT', 'EXCHG_RATE_O', 'ORIGIN_Q', 'ORDER_NOT_Q',
											 'ORDER_NOT_Q', 'ISSUE_NOT_Q', 'ORDER_SEQ', 'ISSUE_REQ_SEQ', 'BASIS_SEQ', 'ORDER_TYPE', 'STOCK_UNIT', 'BILL_TYPE',
											 'BILL_TYPE', 'SALE_TYPE', 'CREDIT_YN', 'ACCOUNT_Q', 'SALE_C_YN', 'INOUT_PRSN', 'WON_CALC_BAS', 'TAX_INOUT',
											 'AGENT_TYPE', 'STOCK_CARE_YN', 'RETURN_Q_YN', 'REF_CODE2', 'EXCESS_RATE', 'SRC_ORDER_Q', 'SOF110T_PRICE',
											 'SRQ100T_PRICE', 'COMP_CODE', 'DEPT_CODE', 'ITEM_ACCOUNT', 'GUBUN',
											 //20210225 추가
											 'GOODS_CODE']))
						return false;

					if(e.record.data.PRICE_YN == '2') {
						if (UniUtils.indexOf(e.field, ['PRICE_YN'])) {
							return false;
						}
					}
					if(!Ext.isEmpty(e.record.data.GUBUN)) {
						if (UniUtils.indexOf(e.field, ['PRICE_TYPE', 'WGT_UNIT', 'VOL_UNIT'])) {
							return false;
						}
					}
				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, '');
				grdRecord.set('ITEM_NAME'		, '');
				grdRecord.set('SPEC'			, '');
				grdRecord.set('ORDER_UNIT'		, '');
				grdRecord.set('ORDER_UNIT_Q'	, '0');
				grdRecord.set('ORDER_UNIT_P'	, '0');
				grdRecord.set('ORDER_UNIT_O'	, '0');
				grdRecord.set('INOUT_TAX_AMT'	, '0');
				grdRecord.set('STOCK_UNIT'		, '');
				grdRecord.set('TAX_TYPE'		, '1');
				grdRecord.set('TRANS_RATE'		, '1');
				grdRecord.set('STOCK_CARE_YN'	, '');
				grdRecord.set('WGT_UNIT'		, '');
				grdRecord.set('UNIT_WGT'		, 0);
				grdRecord.set('VOL_UNIT'		, '');
				grdRecord.set('UNIT_VOL'		, 0);
				grdRecord.set('INOUT_WGT_Q'		, 0);
				grdRecord.set('INOUT_FOR_WGT_P'	, 0);
				grdRecord.set('INOUT_WGT_P'		, 0);
				grdRecord.set('INOUT_VOL_Q'		, 0);
				grdRecord.set('INOUT_FOR_VOL_P'	, 0);
				grdRecord.set('INOUT_VOL_P'		, 0);
				grdRecord.set('LOT_YN'			, '');
				//20210225 추가: 부가세유형 초기화 로직 추가
				grdRecord.set('BILL_TYPE'		, panelResult.getValue('BILL_TYPE'));
			} else {
				var sRefWhCode = ''
				if(BsaCodeInfo.gsRefWhCode == "2") {
					sRefWhCode = Ext.data.StoreManager.lookup('whList').getAt(0).get('value'); //창고콤보value중 첫번째 value
				}
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('ORDER_UNIT'		, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);

				if(Ext.isEmpty(grdRecord.get('WH_CODE'))) {			//창고를 이미 입력했을 경우는 창고정보를 적용하지 않는다.
					if(BsaCodeInfo.gsRefWhCode == "2") {				//멀티품목팝업시 출고창고 참조방법 '2'인 경우(2=첫번째행의 출고창고)
						grdRecord.set('WH_CODE'		, sRefWhCode);
						grdRecord.set('WH_NAME'		, UniAppManager.app.fnGetWhName(record['WH_CODE']));
						grdRecord.set('LOT_NO'		, '');
						grdRecord.set('CELL_STOCK_Q', '0');
					} else {										//멀티품목팝업시 출고창고 참조방법 '1'인 경우(1=품목의 주창고)
						grdRecord.set('WH_CODE'	, record['WH_CODE']);
						grdRecord.set('WH_NAME'	, UniAppManager.app.fnGetWhName(record['WH_CODE']));
						grdRecord.set('LOT_NO'	, '');
					}
				}
				grdRecord.set('TAX_TYPE'	 , record['TAX_TYPE']);
				grdRecord.set('STOCK_CARE_YN', record['STOCK_CARE_YN']);
				grdRecord.set('DIV_CODE'	 , record['DIV_CODE']);
				grdRecord.set('ITEM_ACCOUNT' , record['ITEM_ACCOUNT']);
				if((Ext.isEmpty(record['WGT_UNIT']))) {
					grdRecord.set('WGT_UNIT'	, '');
					grdRecord.set('UNIT_WGT'	, record['UNIT_WGT']);
				} else {
					grdRecord.set('WGT_UNIT'	, record['WGT_UNIT']);
					grdRecord.set('UNIT_WGT'	, record['UNIT_WGT']);
				}
				if((Ext.isEmpty(record['VOL_UNIT']))) {
					grdRecord.set('VOL_UNIT'	, '');
					grdRecord.set('UNIT_VOL'	, record['UNIT_VOL']);
				} else {
					grdRecord.set('VOL_UNIT'	, record['VOL_UNIT']);
					grdRecord.set('UNIT_VOL'	, record['UNIT_VOL']);
				}
				UniSales.fnGetDivPriceInfo2(grdRecord, UniAppManager.app.cbGetPriceInfo
											,'I'
											,UserInfo.compCode
											,grdRecord.get('INOUT_CODE')
											,grdRecord.get('AGENT_TYPE')
											,grdRecord.get('ITEM_CODE')
											,BsaCodeInfo.gsMoneyUnit
											,grdRecord.get('ORDER_UNIT')
											,grdRecord.get('STOCK_UNIT')
											,grdRecord.get('TRANS_RATE')
											,UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'))
											,grdRecord.get('ORDER_UNIT_Q')
											,grdRecord.get('WGT_UNIT')
											,grdRecord.get('VOL_UNIT')
											,grdRecord.get('UNIT_WGT')
											,grdRecord.get('UNIT_VOL')
											,grdRecord.get('PRICE_TYPE')
											,grdRecord.get('PRICE_YN')
											)
				if(record['STOCK_CARE_YN'] == "Y") {
					UniSales.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), grdRecord.get('ITEM_STATUS'), grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE'));
				}
				grdRecord.set('LOT_YN'	 , record['LOT_YN']);
				//20210225 추가: 판매단가, 부가세유형 지정하는 로직 추가
				var param = {
					'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
					'CUSTOM_CODE'	: panelResult.getValue('CUSTOM_CODE'),
					'ITEM_CODE'		: record['ITEM_CODE'],
					'ORDER_UNIT'	: record['SALE_UNIT']
				}
				s_sal100ukrv_wmService.getUnitPrice(param, function(provider, response) {
					if(provider && provider.length != 0) {
						grdRecord.set('ORDER_UNIT_P', provider);
						grdRecord.set('BILL_TYPE'	, '10');		//20210319 수정: 70 -> 10
						UniAppManager.app.fnOrderAmtCal(grdRecord, 'P', 'ORDER_UNIT_P', provider);
						detailStore.fnOrderAmtSum();
					}
				});
			}
		}
	});



	//검색창 폼 정의
	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
		layout	: {type: 'uniTable', columns : 3},
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			xtype		: 'uniCombobox',
			name		: 'DIV_CODE',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = orderNoSearch.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'INOUT_DATE_FR',
			endFieldName	: 'INOUT_DATE_TO',
			startDate		: new Date(),
			endDate			: new Date()
		},{
			xtype: 'component',
			width: 100
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			validateBlank	: false
		}),
		Unilite.popup('DIV_PUMOK',{
			listeners: {
				applyextparam: function(popup) {
					popup.setExtParam({'DIV_CODE': orderNoSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			xtype: 'component',
			width: 100
		},{
			fieldLabel	: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
			name		: 'INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024',				//20210308 수정: S010 -> B024
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
				if(eOpts) {
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},{	//20210205 추가
			fieldLabel	: '고객명',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_PRSN'
		},{
			xtype: 'component',
			width: 100
		},{
			fieldLabel	: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
			name		: 'CREATE_LOC',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B031',
			allowBlank	: false,
			value		: '1'
		},{	//20210205 추가
			fieldLabel	: '연락처',
			xtype		: 'uniTextfield',
			name		: 'PHONE'
		}]
	}); // createSearchForm
	//검색창 모델 정의
	Unilite.defineModel('orderNoMasterModel', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'				, type: 'string', comboType: 'BOR120'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'					, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'			, type: 'string', comboType:'AU', comboCode:'S007'},
			{name: 'CREATE_LOC'			, text: '<t:message code="system.label.sales.creationpath" default="생성경로"/>'		, type: 'string', comboType:'AU', comboCode:'B031'},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'			, type: 'uniDate'},
			{name: 'INOUT_Q'			, text: '<t:message code="system.label.sales.qty" default="수량"/>'					, type: 'uniQty'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.sales.warehouse" default="창고"/>'				, type: 'string'},
			{name: 'WH_CELL_CODE'		, text: 'WH_CELL_CODE'	, type: 'string'},
			{name: 'WH_NAME'			, text: '<t:message code="system.label.sales.warehouse" default="창고"/>'				, type: 'string'},
			{name: 'INOUT_PRSN'			, text: '<t:message code="system.label.sales.charger" default="담당자"/>'				, type: 'string', comboType:'AU', comboCode:'B024'},
			{name: 'RECEIVER_ID'		, text: '<t:message code="system.label.sales.receiverid" default="수신자ID"/>'			, type: 'string'},
			{name: 'RECEIVER_NAME'		, text: '<t:message code="system.label.sales.receivername" default="수신자명"/>'		, type: 'string'},
			{name: 'TELEPHONE_NUM1'		, text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>'			, type: 'string'},
			{name: 'TELEPHONE_NUM2'		, text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>'			, type: 'string'},
			{name: 'ADDRESS'			, text: '<t:message code="system.label.sales.address" default="주소"/>'				, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'				, type: 'string'},
			{name: 'ISSUE_REQ_NUM'		, text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'	, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'SALE_DIV_CODE'		, text: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>'		, type: 'string'},
			{name: 'SALE_CUST_NM'		, text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			, type: 'string'},
			{name: 'INOUT_CODE'			, text: '<t:message code="system.label.sales.tranplace" default="수불처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.tranplacename" default="수불처명"/>'		, type: 'string'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.sales.currency" default="화폐"/>'				, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'			, type: 'uniER'},
			{name: 'SALE_DATE'			, text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'			, type: 'uniDate'},
			{name: 'AGENT_TYPE'			, text: 'AGENT_TYPE'	, type: 'string'},
			{name: 'CREDIT_YN'			, text: 'CREDIT_YN'		, type: 'string'},
			{name: 'WON_CALC_BAS'		, text: 'WON_CALC_BAS'	, type: 'string'},
			{name: 'TAX_TYPE'			, text: 'TAX_TYPE'		, type: 'string'},
			{name: 'BUSI_PRSN'			, text: 'BUSI_PRSN'		, type: 'string'},
			{name: 'CUSTOM_PRSN'		, text: '고객명'			, type: 'string'},	//20210205 추가
			{name: 'PHONE'				, text: '연락처'			, type: 'string'},	//20210205 추가
			{name: 'BILL_TYPE'			, text: '부가세유형'			, type: 'string'}	//20210217 추가
		]
	});
	//검색창 스토어 정의
	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {
		model	: 'orderNoMasterModel',
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
				read: 's_sal100ukrv_wmService.selectOrderNumMasterList'
			}
		},
		loadStoreRecords : function() {
			var param		= orderNoSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;			//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;			//부서코드
			if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))) {
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색창 그리드 정의
	var orderNoMasterGrid = Unilite.createGrid('str103ukrvOrderNoMasterGrid', {
		store	: orderNoMasterStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: false
		},
		columns:  [
			{ dataIndex: 'DIV_CODE'			, width: 80},
			{ dataIndex: 'INOUT_CODE'		, width: 90},
			{ dataIndex: 'CUSTOM_NAME'		, width: 120},
			{ dataIndex: 'CREATE_LOC'		, width: 66},
			{ dataIndex: 'INOUT_DATE'		, width: 80},
			{ dataIndex: 'INOUT_Q'			, width: 93},
			{ dataIndex: 'INOUT_PRSN'		, width: 80},
			{ dataIndex: 'INOUT_NUM'		, width: 120},
			{ dataIndex: 'SALE_DIV_CODE'	, width: 73	, hidden: true},
			{ dataIndex: 'MONEY_UNIT'		, width: 93},
			{ dataIndex: 'EXCHG_RATE_O'		, width: 93	, hidden: true},
			{ dataIndex: 'ISSUE_REQ_NUM'	, width: 120, hidden: true},
			{ dataIndex: 'WH_CODE'			, width: 93	, hidden: true},
			{ dataIndex: 'WH_CELL_CODE'		, width: 120, hidden: true},
			{ dataIndex: 'CUSTOM_PRSN'		, width: 120},	//20210205 추가
			{ dataIndex: 'PHONE'			, width: 120}	//20210205 추가
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoMasterGrid.returnData(record);
				searchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			isLoad = true;
			var field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, record.get('DIV_CODE'), null, null, "DIV_CODE");

			panelResult.setValue('INOUT_NUM'	, record.get('INOUT_NUM'));
			panelResult.setValue('INOUT_DATE'	, record.get('INOUT_DATE'));
			panelResult.setValue('DIV_CODE'		, record.get('DIV_CODE'));
			isLoad = true;
			panelResult.setValue('INOUT_PRSN'	, record.get('INOUT_PRSN'));
			isLoad = true;
			panelResult.setValue('MONEY_UNIT'	, record.get('MONEY_UNIT'));
			panelResult.setValue('EXCHG_RATE_O'	, record.get('EXCHG_RATE_O'));
			panelResult.setValue('CUSTOM_CODE'	, record.get('INOUT_CODE'));
			panelResult.setValue('CUSTOM_NAME'	, record.get('CUSTOM_NAME'));
			gsQueryFlag = true;		//20210129 추가
			panelResult.setValue('WH_CODE'		, record.get('WH_CODE'));
			var whCellStore = panelResult.getField('WH_CELL_CODE').getStore();
			whCellStore.clearFilter(true);
			whCellStore.filter([{
				property: 'option',
				value	: record.get('WH_CODE')
			},{
				property: 'value',
				value	: record.get('WH_CELL_CODE')
			}]);
			panelResult.getField('WH_CELL_CODE').setValue(record.get('WH_CELL_CODE'));
			panelResult.getField('TAX_INOUT').setValue(record.get('TAX_TYPE'));

			isLoad = true;
			if(Ext.isEmpty(record.get('SALE_DATE'))) {
				panelResult.setValue('SALE_DATE'	, record.get('INOUT_DATE'));
			} else {
				panelResult.setValue('SALE_DATE'	, record.get('SALE_DATE'));
			}
			//20210217 추가: 부가세유형 값 set하는 로직 추가
			panelResult.setValue('BILL_TYPE'		, record.get('BILL_TYPE'));
			//20210308 추가: 카드사정보 set하는 로직 추가
			panelResult.setValue('CARD_CUSTOM_CODE'	, record.get('CARD_CUSTOM_CODE'));

			CustomCodeInfo.gsAgentType		= record.get('AGENT_TYPE');
			CustomCodeInfo.gsCustCreditYn	= record.get('CREDIT_YN');
			CustomCodeInfo.gsUnderCalBase	= record.get('WON_CALC_BAS');
			CustomCodeInfo.gsTaxInout 		= record.get('TAX_TYPE');
			CustomCodeInfo.gsbusiPrsn 		= record.get('BUSI_PRSN');
			UniAppManager.app.onQueryButtonDown();
		}
	});
	//검색창 메인
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.issuenosearch" default="출고번호검색"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [orderNoSearch, orderNoMasterGrid],
				tbar	: [ '->',{
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						orderNoMasterStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						searchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					show: function( panel, eOpts ) {
						field = orderNoSearch.getField('INOUT_PRSN');
						field.fireEvent('changedivcode', field, panelResult.getValue('DIV_CODE'), null, null, "DIV_CODE");
						orderNoSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						orderNoSearch.setValue('INOUT_PRSN'		, panelResult.getValue('INOUT_PRSN'));
						orderNoSearch.setValue('CUSTOM_CODE'	, panelResult.getValue('CUSTOM_CODE'));
						orderNoSearch.setValue('CUSTOM_NAME'	, panelResult.getValue('CUSTOM_NAME'));
						orderNoSearch.setValue('INOUT_DATE_FR'	, panelResult.getValue('INOUT_DATE'));
						orderNoSearch.setValue('INOUT_DATE_TO'	, panelResult.getValue('INOUT_DATE'));
						orderNoSearch.setValue('CREATE_LOC'		, '1');
					}
				}
			})
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
	}




	Unilite.Main({
		id			: 's_sal100ukrv_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid
			]
		}],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'newData'], true);
			this.setDefault();
		},
		setDefault: function() {
			isLoad = false;
			/*영업담당 filter set*/
			gsMonClosing = '';	//월마감 여부
			gsDayClosing = '';	//일마감 여부
			//gsOldMonClosing, gsOldDayClosing, gsOldInoutDate
			gsOldMonClosing	= '';	//월마감 여부(기존 데이터)
			gsOldDayClosing	= '';	//일마감 여부(기존 데이터)
			gsOldInoutDate	= new Date();

			var field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			panelResult.setValue('DIV_CODE', UserInfo.divCode);
////////////////////////////////////////////////////////////////////
			//사용자 정보에 따른 S010의 값 SET
			var inoutPrsn = BsaCodeInfo.defaultSalePrsn;
			if(Ext.isEmpty(panelResult.getValue('INOUT_PRSN')) && Ext.isEmpty(inoutPrsn)) {
				inoutPrsn = UniAppManager.app.fnGetInoutPrsnDivCode(UserInfo.divCode);		//사업장의 첫번째 영업담당자 set
			}
			panelResult.setValue('INOUT_PRSN'	, inoutPrsn);
			panelResult.setValue('CUSTOM_CODE'	, BsaCodeInfo.defaultCustomCd);
			panelResult.setValue('CUSTOM_NAME'	, BsaCodeInfo.defaultCustomNm);
			panelResult.setValue('WH_CODE'		, BsaCodeInfo.defaultWhCode);
			var whCellStore = panelResult.getField('WH_CELL_CODE').getStore();
			whCellStore.clearFilter(true);
			whCellStore.filter([{
				property: 'option',
				value	: panelResult.getValue('WH_CODE')
			},{
				property: 'value',
				value	: BsaCodeInfo.defaultWhCellCode}
			]);
			panelResult.getField('WH_CELL_CODE').setValue(BsaCodeInfo.defaultWhCellCode);
			panelResult.setValue('MONEY_UNIT'	, BsaCodeInfo.defaultMoneyUnit);
			panelResult.getField('TAX_INOUT').setValue(Ext.isEmpty(BsaCodeInfo.defaultTaxInout0) ? 1:BsaCodeInfo.defaultTaxInout0);		//20210129 추가
			fnSetColumnFormat();
////////////////////////////////////////////////////////////////////
			panelResult.setValue('INOUT_DATE'	, new Date());
			panelResult.setValue('SALE_DATE'	, new Date());
			if(BsaCodeInfo.gsAutoSalesYN == '2') {
				panelResult.getField('SALE_DATE').setConfig('hidden'	, true);
				panelResult.getField('SALE_DATE').setConfig('allowBlank', true);
			} else {
				panelResult.getField('SALE_DATE').setConfig('hidden'	, false);
				panelResult.getField('SALE_DATE').setConfig('allowBlank', false);
			}
			panelResult.setValue('CREATE_LOC'		, '1');
			panelResult.setValue('TOT_SALE_TAXI'	, 0);		//과세초액
			panelResult.setValue('TOT_TAXI'			, 0);		//세액합계(2)
			panelResult.setValue('TOT_SALENO_TAXI'	, 0);		//면세총액(3)
			panelResult.setValue('TOTAL_AMT'		, 0);		//출고총액[(1)+(2)+(3)]

			if(BsaCodeInfo.gsAutoType == 'Y') {
				panelResult.getForm().findField('INOUT_NUM').setReadOnly(true);
			} else {
				panelResult.getForm().findField('INOUT_NUM').setReadOnly(false);
			}
			panelResult.getField('TOT_SALE_TAXI').setReadOnly(true);
			panelResult.getField('TOT_TAXI').setReadOnly(true);
			panelResult.getField('TOT_SALENO_TAXI').setReadOnly(true);
			panelResult.getField('TOTAL_AMT').setReadOnly(true);

			panelResult.getField('TOT_SALE_TAXI').setReadOnly(true);
			panelResult.getField('TOT_TAXI').setReadOnly(true);
			panelResult.getField('TOT_SALENO_TAXI').setReadOnly(true);
			panelResult.getField('TOTAL_AMT').setReadOnly(true);
			//20210308 추가
			panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(true);

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();

			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function () {
			var returnNo = panelResult.getValue('INOUT_NUM');
			if(Ext.isEmpty(returnNo)) {
				openSearchInfoWindow()
			} else {
				fnSetColumnFormat();

				isLoad = true;
				detailStore.loadStoreRecords();
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown : function() {
			if(Ext.isEmpty(panelResult.getValue('CUSTOM_CODE')) || Ext.isEmpty(panelResult.getValue('CUSTOM_NAME'))) {
				Unilite.messageBox('<t:message code="system.label.sales.custom" default="거래처"/>: <t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			if(!this.checkForNewDetail()) return false;

			if(!panelResult.setAllFieldsReadOnly(true)) {
				return false;
			} else {
				var inoutSeq = detailStore.max('INOUT_SEQ');
				if(!inoutSeq) inoutSeq = 1;
				else  inoutSeq += 1;

				var sortSeq = detailStore.max('SORT_SEQ');
				if(!sortSeq) sortSeq = 1;
				else sortSeq += 1;

				var inoutNum = '';
				if(!Ext.isEmpty(panelResult.getValue('INOUT_NUM'))) {
					inoutNum = panelResult.getValue('INOUT_NUM');
				}

				var inoutCode = '';
				if(!Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
					inoutCode = panelResult.getValue('CUSTOM_CODE');
				}

				var customName = '';
				if(!Ext.isEmpty(panelResult.getValue('CUSTOM_NAME'))) {
					customName = panelResult.getValue('CUSTOM_NAME');
				}

				var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value');	//출고유형콤보value중 첫번째 value
				var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail);						//출고유형value의 ref2

				var createLoc = '1';

				var moneyUnit = '';
				if(!Ext.isEmpty(panelResult.getValue('MONEY_UNIT'))) {
					moneyUnit = panelResult.getValue('MONEY_UNIT');
				}

				var exchgRateO = '';
				if(!Ext.isEmpty(panelResult.getValue('EXCHG_RATE_O'))) {
					exchgRateO = panelResult.getValue('EXCHG_RATE_O');
				}

				var inoutPrsn = '';
				if(!Ext.isEmpty(panelResult.getValue('INOUT_PRSN'))) {
					inoutPrsn = panelResult.getValue('INOUT_PRSN');
				}

				var saleCustCD = '';
				if(!Ext.isEmpty(panelResult.getValue('CUSTOM_NAME'))) {
					saleCustCD = panelResult.getValue('CUSTOM_NAME');
				}
				var saleCustomCd = '';
				if(!Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
					saleCustomCd = panelResult.getValue('CUSTOM_CODE');
				}

				var saleDivCode = '';
				if(BsaCodeInfo.gsOptDivCode == "1") {
					saleDivCode = panelResult.getValue('DIV_CODE');
				} else {
					saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
				}

				var divCode = panelResult.getValue('DIV_CODE');

				var saleType = Ext.data.StoreManager.lookup('CBS_AU_S002').getAt(0).get('value');		//판매유형콤보value중 첫번째 value
				var taxInout = CustomCodeInfo.gsTaxInout;

				var deptCode = '';
				if(!Ext.isEmpty(panelResult.getValue('DEPT_CODE'))) {
					deptCode = panelResult.getValue('DEPT_CODE');
				}

				var whCode = '';
				if(!Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
					whCode = panelResult.getValue('WH_CODE');
				}
				var whCellCode = '';
				if(!Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))) {
					whCellCode= panelResult.getValue('WH_CELL_CODE');
				}
				var salePrsn = CustomCodeInfo.gsbusiPrsn;

				var nationInout = '';
				if(!Ext.isEmpty(panelResult.getValue('NATION_INOUT'))) {
					nationInout = panelResult.getValue('NATION_INOUT');
				}

				var inoutDate= '';
				if(!Ext.isEmpty(panelResult.getValue('INOUT_DATE'))) {
					inoutDate = panelResult.getValue('INOUT_DATE');
				}

				var saleDate= '';
				if(!Ext.isEmpty(panelResult.getValue('SALE_DATE'))) {
					saleDate = panelResult.getValue('SALE_DATE');
				}

				var r = {
					INOUT_SEQ			: inoutSeq,
					SORT_SEQ			: sortSeq,
					INOUT_NUM			: inoutNum,
					INOUT_CODE			: inoutCode,
					CUSTOM_NAME			: customName,
					INOUT_TYPE_DETAIL	: inoutTypeDetail,
					REF_CODE2			: refCode2,
					CREATE_LOC			: createLoc,
					MONEY_UNIT			: moneyUnit,
					EXCHG_RATE_O		: exchgRateO,
					INOUT_PRSN			: inoutPrsn,
					SALE_CUST_CD		: saleCustCD,
					SALE_CUSTOM_CODE	: saleCustomCd,
					SALE_DIV_CODE		: saleDivCode,
					DIV_CODE			: divCode,
					SALE_TYPE			: saleType,
					TAX_INOUT			: taxInout,
					DEPT_CODE			: deptCode,
					WH_CODE				: whCode,
					WH_CELL_CODE		: whCellCode,
					SALE_PRSN			: gsSalePrsn,								//로직 변경 전까지는 sale_prsn, inout_prsn에 panelResult의 inout_prsn 입력: salePrsn, -> inout_prsn으로 수정, 20210308 수정
					NATION_INOUT		: nationInout,
					INOUT_DATE			: inoutDate,
					SALE_DATE			: saleDate,
					TAX_INOUT			: panelResult.getValues().TAX_INOUT,		//20210119추가
					CUSTOM_PRSN			: panelResult.getValue('CUSTOM_PRSN'),		//20210201 추가
					PHONE				: panelResult.getValue('PHONE'),			//20210201 추가
					ZIP_CODE			: panelResult.getValue('ZIP_CODE'),			//20210201 추가
					ADDR1				: panelResult.getValue('ADDR1'),			//20210201 추가
					ADDR2				: panelResult.getValue('ADDR2'),			//20210201 추가
					BILL_TYPE			: panelResult.getValue('BILL_TYPE'),		//20210215 추가
					CARD_CUSTOM_CODE	: panelResult.getValue('CARD_CUSTOM_CODE')	//20210308 추가
				};
				panelResult.setAllFieldsReadOnly(true);
				detailGrid.createRow(r);
			}
		},
		onDeleteDataButtonDown: function() {
			if(gsMonClosing == "Y" || gsDayClosing == "Y") {	//마감여부 check
				Unilite.messageBox('<t:message code="system.message.sales.message054" default="마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다."/>');	//마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
				return false;
			}
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			} else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(BsaCodeInfo.gsInoutAutoYN == "N" && selRow.get('ACCOUNT_Q') > 0) {												//동시매출발생이 아닌 경우,매출존재체크 제외
					Unilite.messageBox('<t:message code="system.message.sales.message055" default="매출이 진행된 건은 수정/삭제할 수 없습니다."/>');	//매출이 진행된 건은 수정/삭제할 수 없습니다.
					return false;
				}
				if(selRow.get('SALE_C_YN') == "Y") {
					Unilite.messageBox('<t:message code="system.message.sales.message056" default="계산서가 마감된 건은 수정/삭제가 불가능합니다."/>');	//계산서가 마감된 건은 수정/삭제가 불가능합니다.
					return false;
				}
				detailGrid.deleteSelectedRow();
			}
			detailStore.fnOrderAmtSum();
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom) {							//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else {									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						if(gsMonClosing == "Y" || gsDayClosing == "Y") {	//마감여부 check
							Unilite.messageBox('<t:message code="system.message.sales.message054" default="마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다."/>'); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
							return false;
						}
						Ext.each(records, function(record,i) {
							if(BsaCodeInfo.gsInoutAutoYN == "N" && record.get('ACCOUNT_Q') > 0) {//동시매출발생이 아닌 경우,매출존재체크 제외
								Unilite.messageBox('<t:message code="system.message.sales.message055" default="매출이 진행된 건은 수정/삭제할 수 없습니다."/>');	//매출이 진행된 건은 수정/삭제할 수 없습니다.
								deletable = false;
								return false;
							}
							if(record.get('SALE_C_YN') == "Y") {
								Unilite.messageBox('<t:message code="system.message.sales.message056" default="계산서가 마감된 건은 수정/삭제가 불가능합니다."/>');	//계산서가 마감된 건은 수정/삭제가 불가능합니다.
								deletable = false;
								return false;
							}
						});
						if(deletable) {
							detailGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData) {								//신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		onSaveDataButtonDown: function (config) {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			detailStore.saveStore();
		},
		onResetButtonDown: function() {
			//20210129 수정: 초기화 시, '담당, 거래처, 출고일, 출고창고, 출고창고cell, 사업장, 세액포함여부'의 데이터는 초기화하지 않고 그외 내용만 초기화
			panelResult.setValue('INOUT_NUM'		, '');
			panelResult.setValue('TOT_SALE_TAXI'	, 0);
			panelResult.setValue('TOT_TAXI'			, 0);
			panelResult.setValue('TOT_SALENO_TAXI'	, 0);
			panelResult.setValue('TOTAL_AMT'		, 0);
			//20210201 추가
			panelResult.setValue('CUSTOM_PRSN'		, '');
			panelResult.setValue('PHONE'			, '');
			panelResult.setValue('ZIP_CODE'			, '');
			panelResult.setValue('ADDR1'			, '');
			panelResult.setValue('ADDR2'			, '');

			panelResult.setAllFieldsReadOnly(false);
			detailGrid.getStore().loadData({});
			UniAppManager.setToolbarButtons(['reset', 'newData'], true);
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelResult.getValue('INOUT_NUM'))) {
				Unilite.messageBox('<t:message code="system.label.sales.issueno" default="출고번호"/>:<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			return panelResult.setAllFieldsReadOnly(true);
		},
		fnOrderAmtCal: function(rtnRecord, sType, fieldName, nValue, taxType, taxInout) {
			var dTransRate		= fieldName=='TRANS_RATE'		? nValue : Unilite.nvl(rtnRecord.get('TRANS_RATE'),1);
			var dOrderQ			= fieldName=='ORDER_UNIT_Q'		? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_Q'),0);
			var dIssueReqWgtQ	= fieldName=='INOUT_WGT_Q'		? nValue : Unilite.nvl(rtnRecord.get('INOUT_WGT_Q'),0);
			var dIssueReqVolQ	= fieldName=='INOUT_VOL_Q'		? nValue : Unilite.nvl(rtnRecord.get('INOUT_VOL_Q'),0);
			var dOrderP			= fieldName=='ORDER_UNIT_P'		? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_P'),0);
			var dOrderWgtForP	= fieldName=='INOUT_FOR_WGT_P'	? nValue : Unilite.nvl(rtnRecord.get('INOUT_FOR_WGT_P'),0);
			var dOrderVolForP	= fieldName=='INOUT_FOR_VOL_P'	? nValue : Unilite.nvl(rtnRecord.get('INOUT_FOR_VOL_P'),0);
			var dOrderO			= fieldName=='ORDER_UNIT_O'		? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_O'),0);
			var dDcRate			= fieldName=='DISCOUNT_RATE'	? nValue : Unilite.nvl((100 - rtnRecord.get('DISCOUNT_RATE')),0);
			var dExchgRate		= fieldName=='EXCHG_RATE_O'		? nValue : Unilite.nvl(rtnRecord.get('EXCHG_RATE_O'),0);
			var dPriceType		= Ext.isEmpty(rtnRecord.get('PRICE_TYPE')) ? 'A' : rtnRecord.get('PRICE_TYPE');//단가구분
			var dOrderWgtP		= 0;
			var dOrderVolP		= 0;
			var dOrderForO		= 0;
			var dOrderForP		= 0;
			var moneyUnit		= rtnRecord.get('MONEY_UNIT');

			if(sType == "P" || sType == "Q") {
				//20200611 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
				dOrderWgtP	= UniSales.fnExchangeApply(moneyUnit, dOrderWgtForP	* dExchgRate);
				dOrderVolP	= UniSales.fnExchangeApply(moneyUnit, dOrderVolForP	* dExchgRate);

				if(dPriceType == "A") {
					dOrderForO	= dOrderQ * dOrderP
					dOrderO		= dOrderQ * dOrderP
				} else if(dPriceType == "B") {
					dOrderForO	= dIssueReqWgtQ * dOrderWgtForP
					dOrderO		= dIssueReqWgtQ * dOrderWgtP
				} else if(dPriceType == "C") {
					dOrderForO	= dIssueReqVolQ * dOrderVolForP
					dOrderO		= dIssueReqVolQ * dOrderVolP
				} else {
					dOrderForO	= dOrderQ * dOrderP
					dOrderO		= dOrderQ * dOrderP
				}
				rtnRecord.set('ORDER_UNIT_O'	, dOrderForO);
				rtnRecord.set('ORDER_UNIT_P'	, dOrderP);
				rtnRecord.set('INOUT_FOR_WGT_P'	, dOrderWgtForP);
				rtnRecord.set('INOUT_FOR_VOL_P'	, dOrderVolForP);
				rtnRecord.set('INOUT_WGT_P'		, dOrderWgtP);
				rtnRecord.set('INOUT_VOL_P'		, dOrderVolP);

				this.fnTaxCalculate(rtnRecord, dOrderO, null, taxInout);
			} else if(sType == "O" && (dOrderQ > 0)) {
				dOrderForP	= dOrderO / dOrderQ;
				dOrderP		= UniSales.fnExchangeApply(moneyUnit, (dOrderO / dOrderQ) * dExchgRate);

				if(dIssueReqWgtQ != 0) {
					dOrderWgtForP	= (dOrderO / dIssueReqWgtQ);
					dOrderWgtP		= UniSales.fnExchangeApply(moneyUnit, (dOrderO / dIssueReqWgtQ) * dExchgRate);
				} else {
					dOrderWgtForP	= 0;
					dOrderWgtP		= 0;
				}

				if(dIssueReqVolQ != 0) {
					dOrderVolForP	= (dOrderO / dIssueReqVolQ)
					dOrderVolP		= UniSales.fnExchangeApply(moneyUnit, (dOrderO / dIssueReqVolQ) * dExchgRate);
				} else {
					dOrderVolForP	= 0
					dOrderVolP		= 0
				}

				if(dPriceType == "A") {
					dOrderO = dOrderForP * dOrderQ;
				} else if(dPriceType == "B") {
					dOrderO = dOrderWgtForP * dIssueReqWgtQ;
				} else if(dPriceType == "C") {
					dOrderO = dOrderVolForP * dIssueReqVolQ;
				} else {
					dOrderO = dOrderForP * dOrderQ;
				}
				rtnRecord.set('INOUT_WGT_P'		, dOrderWgtP);
				rtnRecord.set('INOUT_VOL_P'		, dOrderVolP);
				rtnRecord.set('ORDER_UNIT_P'	, dOrderForP);
				rtnRecord.set('INOUT_FOR_WGT_P'	, dOrderWgtForP);
				rtnRecord.set('INOUT_FOR_VOL_P'	, dOrderVolForP);
				rtnRecord.set('ORDER_UNIT_O'	, dOrderO);
				this.fnTaxCalculate(rtnRecord, dOrderO, taxType, taxInout);
			} else if(sType == "C") {
				dOrderP = (dOrderP - (dOrderP * (dDcRate / 100)));
				rtnRecord.set('ORDER_UNIT_P', dOrderP);
				dOrderO = dOrderQ * dOrderP;
				rtnRecord.set('ORDER_UNIT_O', dOrderO);

				dOrderWgtForP = (dOrderO / dIssueReqWgtQ);
				dOrderVolForP = (dOrderO / dIssueReqVolQ);
				//자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
				dOrderWgtP	= UniSales.fnExchangeApply(moneyUnit, (dOrderO / dIssueReqWgtQ) * dExchgRate);
				dOrderVolP	= UniSales.fnExchangeApply(moneyUnit, (dOrderO / dIssueReqVolQ) * dExchgRate);

				rtnRecord.set('INOUT_WGT_P'		, dOrderWgtP);
				rtnRecord.set('INOUT_VOL_P'		, dOrderVolP);
				rtnRecord.set('INOUT_FOR_WGT_P'	, dOrderWgtForP);
				rtnRecord.set('INOUT_FOR_VOL_P'	, dOrderVolForP);
				this.fnTaxCalculate(rtnRecord, dOrderO, null, taxInout);
			}
		},
		fnTaxCalculate: function(rtnRecord, dOrderO, taxType, taxInout) {
			var sTaxType		= Ext.isEmpty(taxType)? rtnRecord.get('TAX_TYPE') : taxType;
			var sWonCalBas		= CustomCodeInfo.gsUnderCalBase;
			var sTaxInoutType	= Ext.isEmpty(taxInout)? rtnRecord.get('TAX_INOUT') : taxInout;
			var dVatRate		= parseInt(BsaCodeInfo.gsVatRate);
			var dAmountI		= dOrderO;
			var dOrderAmtO		= 0;
			var dTaxAmtO		= 0;

			//화폐단위 관련로직 추가
			if(panelResult.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit) {
				var digit = UniFormat.FC.indexOf(".") == -1 ? UniFormat.FC.length : UniFormat.FC.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.FC.length - digit;
			} else {
				var digit = UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.Price.length - digit;
			}

			if(sTaxInoutType=="1") {	//별도
				dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderO, sWonCalBas, numDigitOfPrice);
				dTaxAmtO	= UniSales.fnAmtWonCalc(dOrderAmtO * dVatRate / 100, sWonCalBas, numDigitOfPrice);
			} else if(sTaxInoutType=="2") {	//포함
				dTemp		= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, sWonCalBas, numDigitOfPrice);
				dTaxAmtO	= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, sWonCalBas, numDigitOfPrice);
				dOrderAmtO	= UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), sWonCalBas, numDigitOfPrice);
			}
			if(sTaxType == "2") {
				dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderO, sWonCalBas, numDigitOfPrice ) ;
				dTaxAmtO	= 0;
			}
			rtnRecord.set('ORDER_UNIT_O'	, dOrderAmtO);
			rtnRecord.set('INOUT_TAX_AMT'	, dTaxAmtO);
			rtnRecord.set('ORDER_AMT_SUM'	, (dOrderAmtO + dTaxAmtO));
		},
		fnCheckNum: function(value, record, fieldName) {
			var r = true;
			if(record.get("PRICE_YN") == "1" || record.get("ACCOUNT_YNC")=="N") {
				r = true;
			} else if(record.get("PRICE_YN") == "2" ) {
				if(value < 0) {
					Unilite.messageBox('<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>');
					r=false;
					return r;
				} else if(value == 0) {
					if(fieldName == "ORDER_TAX_O") {
						if(BsaCodeInfo.gsVatRate != 0) {
							Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
							r=false;
						}
					} else {
						Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
						r=false;
					}
				}
			}
			return r;
		},
		fnGetSubCode: function(rtnRecord, subCode) {
			var fRecord = '';
			Ext.each(BsaCodeInfo.grsOutType, function(item, i) {
				if(item['codeNo'] == subCode) {
					fRecord = item['refCode2'];
					if(Ext.isEmpty(fRecord)) {
						fRecord = item['codeNo']
					}
				}
			})
			return fRecord;
		},
		fnAccountYN: function(rtnRecord, subCode) {
			var fRecord ='';
			Ext.each(BsaCodeInfo.grsOutType, function(item, i) {
				if(item['codeNo'] == subCode && !Ext.isEmpty(item['refCode1'])) {
					fRecord = item['refCode1'];
				}
			});
			if(Ext.isEmpty(fRecord)) {
				fRecord = 'N'
			}
			return fRecord;
		},
		cbStockQ: function(provider, params) {
			var rtnRecord	= params.rtnRecord;
			var dStockQ		= Unilite.nvl(provider['STOCK_Q'], 0);
			var lTrnsRate	= 0;
			if(Ext.isEmpty(rtnRecord.get('TRANS_RATE')) || rtnRecord.get('TRANS_RATE') == 0) {
				lTrnsRate = 1
			} else {
				lTrnsRate = rtnRecord.get('TRANS_RATE');
			}

			rtnRecord.set('STOCK_Q', dStockQ);
			rtnRecord.set('ORDER_STOCK_Q', dStockQ / lTrnsRate);
		},
		//UniSales.fnGetDivPriceInfo2 callback 함수
		cbGetPriceInfo: function(provider, params) {
			var dSalePrice	= Unilite.nvl(provider['SALE_PRICE'],0);//판매단가(판매단위)
			var dWgtPrice	= Unilite.nvl(provider['WGT_PRICE'],0);//판매단가(중량단위)
			var dVolPrice	= Unilite.nvl(provider['VOL_PRICE'],0);//판매단가(부피단위)

			var dUnitWgt = 0;
			var dUnitVol = 0;

			if(params.sType=='I') {
				dUnitWgt = params.unitWgt;
				dUnitVol = params.unitVol;
				if(params.priceType == 'A') {
					dWgtPrice = (dUnitWgt = 0) ?	0 : dSalePrice / dUnitWgt;
					dVolPrice = (dUnitVol = 0) ?	0 : dSalePrice / dUnitVol;
				} else if(params.priceType == 'B') {
					dSalePrice = dWgtPrice  * dUnitWgt;
					dVolPrice = (dUnitVol = 0) ? 0 : dSalePrice / dUnitVol;
				} else if(params.priceType == 'C') {
					dSalePrice = dVolPrice  * dUnitVol;
					dWgtPrice = (dUnitWgt = 0) ? 0 : dSalePrice / dUnitWgt;
				} else {
					dWgtPrice = (dUnitWgt = 0) ? 0 : dSalePrice / dUnitWgt;
					dVolPrice = (dUnitVol = 0) ? 0 : dSalePrice / dUnitVol;
				}
				if(Ext.isEmpty(provider['SALE_PRICE'])) {
					params.rtnRecord.set('ORDER_UNIT_P', 0);
				} else {
					params.rtnRecord.set('ORDER_UNIT_P', provider['SALE_PRICE']);
				}
				params.rtnRecord.set('INOUT_WGT_P', dWgtPrice );
				params.rtnRecord.set('INOUT_VOL_P', dVolPrice );

				if(Ext.isEmpty(provider['SALE_TRANS_RATE'])) {
					params.rtnRecord.set('TRANS_RATE', 1);
				} else {
					params.rtnRecord.set('TRANS_RATE', provider['SALE_TRANS_RATE']);
				}

				if(Ext.isEmpty(provider['DC_RATE'])) {
					params.rtnRecord.set('DISCOUNT_RATE', 0);
				} else {
					params.rtnRecord.set('DISCOUNT_RATE', provider['DC_RATE']);
				}
				var exchangRate = panelResult.getValue('EXCHG_RATE_O');
				params.rtnRecord.set('INOUT_FOR_WGT_P'	, UniSales.fnExchangeApply2(params.rtnRecord.get('MONEY_UNIT'), dWgtPrice / exchangRate));	//20200611 수정: 외화금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply2 추가)
				params.rtnRecord.set('INOUT_FOR_VOL_P'	, UniSales.fnExchangeApply2(params.rtnRecord.get('MONEY_UNIT'), dVolPrice / exchangRate));	//20200611 수정: 외화금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply2 추가)
				params.rtnRecord.set('PRICE_YN'			, provider['PRICE_TYPE']);
			}
			if(params.rtnRecord.get('INOUT_FOR_VOL_P') > 0) {
				UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P");
			}
		},
		fnGetSalePrsnDivCode: function(subCode) {	//거래처의 영업담당자의 사업장 가져오기
			var fRecord ='';
			Ext.each(BsaCodeInfo.salePrsn, function(item, i) {
				if(item['codeNo'] == subCode) {
					fRecord = item['refCode1'];
				}
			});
			return fRecord;
		},
		fnGetInoutPrsnDivCode: function(subCode) {	//사업장의 첫번째 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.inoutPrsn, function(item, i) {
				if(item['refCode1'] == subCode) {
					fRecord = item['codeNo'];
					return false;
				}
			});
			return fRecord;
		},
		fnGetInoutPrsnUserId: function(subCode) {	//로그인 아이디의 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.inoutPrsn, function(item, i) {
				if(item['refCode10'] == subCode) {
					fRecord = item['codeNo'];
					return false;
				}
			});
			return fRecord;
		},
		fnGetWhName: function(subCode) {			//창고코드로 네임 가져오기
			var whName ='';
			Ext.each(BsaCodeInfo.whList, function(item, i) {
				if(item['value'] == subCode) {
					whName = item['text'];
				}
			});
			return whName;
		},
		cbGetClosingInfo: function(params) {
			gsMonClosing = params.gsMonClosing
			gsDayClosing = params.gsDayClosing
		},
		cbGetClosingInfo2: function(params) {
			if(params.gsMonClosing == 'Y' || params.gsDayClosing == 'Y') {
				Unilite.messageBox('<t:message code="system.message.sales.message146" default="마감이 진행된 일자는 선택할 수 없습니다."/>')
				panelResult.setValue('INOUT_DATE', gsOldInoutDate);
				return false;
			} else {
				gsOldMonClosing	= gsMonClosing;
				gsOldDayClosing	= gsDayClosing;
				gsMonClosing	= params.gsMonClosing;
				gsDayClosing	= params.gsDayClosing;
				gsOldInoutDate	= panelResult.getValue('INOUT_DATE');
				panelResult.setValue('SALE_DATE', panelResult.getValue('INOUT_DATE'));
			}
			if(detailStore.data.length > 0) {
				var records = detailStore.data.items;
				Ext.each(records, function(record, index) {
					record.set('INOUT_DATE'	, panelResult.getValue('INOUT_DATE'));
					record.set('SALE_DATE'	, panelResult.getValue('INOUT_DATE'));
				});
			}
			//출고일 변경 시 환율 가져오는 로직 추가
			UniAppManager.app.fnExchngRateO();
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelResult.getValue('SALE_DATE')),
				"MONEY_UNIT": panelResult.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)) {
					//!isLoad 추가
					if(!isLoad && provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(panelResult.getValue('MONEY_UNIT')) && panelResult.getValue('MONEY_UNIT') != UserInfo.currency) {
						Unilite.messageBox('<t:message code="system.message.sales.datacheck008" default="환율정보가 없습니다."/>')
					}
					panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
					//일자 변경에 따른 변경된 환율 적용로직 추가
					if(detailStore.data.length > 0) {
						var detailRecords = detailStore.data.items;
						Ext.each(detailRecords, function(detailRecord, index) {
							detailRecord.set('EXCHG_RATE_O', provider.BASE_EXCHG);
						});
					}
				}
			});
		}
	});



	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue) {
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;

			if(BsaCodeInfo.gsInoutAutoYN == "N" && record.get('ACCOUNT_Q')) {
				rv = '<t:message code="system.message.sales.message055" default="매출이 진행된 건은 수정/삭제할 수 없습니다."/>';
			} else if( record.get('SALE_C_YN' == 'Y')) {
				rv = '<t:message code="system.message.sales.message056" default="계산서가 마감된 건은 수정/삭제가 불가능합니다."/>';
			} else {
				switch(fieldName) {
					//20190904: 세액포함여부 수정관련 로직 추가
					case "TAX_INOUT" :
						var sInout_q = record.get('ORDER_UNIT_Q');
						UniAppManager.app.fnOrderAmtCal(record, 'Q', 'ORDER_UNIT_Q', sInout_q, null, newValue);
						break;

					case "INOUT_SEQ" :
						if(newValue <= 0 && !Ext.isEmpty(newValue)) {
							rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							break;
						}
						break;

					case "INOUT_TYPE_DETAIL" :
						var sRefCode2 = UniAppManager.app.fnGetSubCode(null, newValue) ;	//출고유형value의 ref2
						var OldRefCode2 = record.get('REF_CODE2');
						record.set('REF_CODE2', sRefCode2);
						if((sRefCode2 > "91" && sRefCode2 < "99" ) || sRefCode2 == "C1") {
							record.set('REF_CODE2', OldRefCode2);
							rv='<t:message code="system.message.sales.message046" default="해당 출고유형은 선택할 수 없습니다."/>';
							break;
						} else if(sRefCode2 == "AU") {
							if(record.get('STOCK_CARE_YN') != "N") {
								record.set('ITEM_CODE', '');
								record.set('ITEM_NAME', '');
								record.set('SPEC', "");
								break;
							}
							record.set('ACCOUNT_YNC','Y');	//매출대상
							record.set('STOCK_CARE_YN','N');	//재고대상여부 - 아니오

						} else if(sRefCode2 == "91") {
							if(!Ext.isEmpty(record.get('STOCK_CARE_YN')) || !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) {
								record.set('REF_CODE2', OldRefCode2);
								rv='<t:message code="system.message.sales.message046" default="해당 출고유형은 선택할 수 없습니다."/>';
								break;
							}
							record.set('ACCOUNT_YNC','N');	//미매출대상
							record.set('ITEM_STATUS','1');	//불량 -> 양품으로 바꿈 20160701

						} else {
							if((!Ext.isEmpty(record.get('ORDER_NUM')) && Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) || (Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) || (!Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM')))) {
							} else {
								record.set('ACCOUNT_YNC', UniAppManager.app.fnAccountYN(null, newValue));
							}
							record.set('ACCOUNT_YNC', UniAppManager.app.fnAccountYN(null, newValue));
						}
						break;

					case "WH_CODE" :
						if(!Ext.isEmpty(newValue)) {
							record.set('WH_NAME',e.column.field.getRawValue());
							record.set('WH_CELL_CODE', "");
							record.set('WH_CELL_NAME', "");
							record.set('LOT_NO', "");
						} else {
							record.set('WH_CODE', "");
							record.set('WH_CELL_CODE', "");
							record.set('WH_CELL_NAME', "");
							record.set('LOT_NO', "");
						}
						if(!Ext.isEmpty(record.get('ITEM_CODE'))) {
							UniSales.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('DIV_CODE'), record.get('ITEM_STATUS'), record.get('ITEM_CODE'),  newValue);
						}
						break;

					case "WH_CELL_CODE" :
						record.set('WH_CELL_NAME',e.column.field.getRawValue());
						break;

					case "ITEM_STATUS" :
						if(!Ext.isEmpty(record.get('ITEM_CODE'))) {
							UniSales.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('DIV_CODE'), newValue, record.get('ITEM_CODE'), record.get('WH_CODE'));
						}
						break;

					case "ORDER_UNIT" :
						UniSales.fnGetDivPriceInfo2(record, UniAppManager.app.cbGetPriceInfo
												,'I'
												,UserInfo.compCode
												,record.get('INOUT_CODE')
												,record.get('AGENT_TYPE')
												,record.get('ITEM_CODE')
												,BsaCodeInfo.gsMoneyUnit
												,newValue
												,record.get('STOCK_UNIT')
												,record.get('TRANS_RATE')
												,UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'))
												,record.get('ORDER_UNIT_Q')
												,record.get('WGT_UNIT')
												,record.get('VOL_UNIT')
												,record.get('UNIT_WGT')
												,record.get('UNIT_VOL')
												,record.get('PRICE_TYPE')
												,record.get('PRICE_YN')
												)
						detailStore.fnOrderAmtSum();
						break;

					case "PRICE_YN" :
						break;

					case "TRANS_RATE" :
						if(newValue < 0 && !Ext.isEmpty(newValue)) {
							rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							break;
						}
						UniSales.fnGetDivPriceInfo2(record, UniAppManager.app.cbGetPriceInfo
												,'R'
												,UserInfo.compCode
												,record.get('INOUT_CODE')
												,record.get('AGENT_TYPE')
												,record.get('ITEM_CODE')
												,BsaCodeInfo.gsMoneyUnit
												,record.get('ORDER_UNIT')
												,record.get('STOCK_UNIT')
												,newValue
												,UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'))
												,record.get('ORDER_UNIT_Q')
												,record.get('WGT_UNIT')
												,record.get('VOL_UNIT')
												,record.get('UNIT_WGT')
												,record.get('UNIT_VOL')
												,record.get('PRICE_TYPE')
												,record.get('PRICE_YN')
												)
						detailStore.fnOrderAmtSum();
						break;

					case "ORDER_UNIT_Q" :
						//출고유형이 '부품반납(재고환입)'이면 수량에 -입력가능함
						if((record.get('INOUT_TYPE_DETAIL') != '30' && newValue < 0) && !Ext.isEmpty(newValue)) {
							rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							break;
						}

						var sInout_q = 0;

						if(BsaCodeInfo.gsBoxYN == 'Y') {
							if(record.obj.phantom) {
								if(!Ext.isEmpty(record.get('ORDER_NUM')) || !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) {
									if(newValue > record.get('ORIGIN_Q')) {			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q');			//출고수량 = 미납량(참조에서 가져온 미납량)
										record.set('LOSS_Q',newValue - record.get('ORIGIN_Q'));//LOSS여분 = 출고수량 - 미납량
									} else {
										sInout_q = newValue;	//출고량
										record.set('LOSS_Q',0);
									}
								} else {
									sInout_q = newValue;		//출고량
									record.set('LOSS_Q',0);
								}
							} else {
								if(!Ext.isEmpty(record.get('ORDER_NUM')) && Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) {		//수주참조
									if(newValue > record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q')) {			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q');	//출고수량 = 미납량
										record.set('LOSS_Q',newValue - (record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q')));//LOSS여분 = 출고수량 - 미납량
									} else {
										sInout_q = newValue;	//출고량
										record.set('LOSS_Q',0);
									}
								} else if(!Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) {	//출하지시참조
									if(newValue > record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q')) {			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q');	//출고수량 = 미납량
										record.set('LOSS_Q',newValue - (record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q')));//LOSS여분 = 출고수량 - 미납량
									} else {
										sInout_q = newValue;	//출고량
										record.set('LOSS_Q',0);
									}
								}
							}
						} else {
							sInout_q = newValue;
						}

						var sInv_q		= record.get('STOCK_Q');			//재고량
						var sOriginQ	= record.get('ORIGIN_Q');			//출고량
						var lot_q		= record.get('TEMP_ORDER_UNIT_Q');	//로트팝업에서 넘겨받는 수량

						if(!Ext.isEmpty(lot_q) && lot_q!= 0) {
							if(sInout_q > lot_q) {
								rv = '<t:message code="system.message.sales.message062" default="출고량은 lot재고량을 초과할 수 없습니다. 현재고: "/>' + lot_q;
								break;
							}
						}

						if(BsaCodeInfo.gsInvstatus == "+" && (record.get('STOCK_CARE_YN') == "Y")) {
							if(sInout_q > (sInv_q + sOriginQ)) {
								rv='<t:message code="system.message.sales.message067" default="출고량은 재고량을 초과할 수 없습니다."/>';	//출고량은 재고량을 초과할 수 없습니다.
								break;
							}
						}
						//출고량(중량) 재계산
						var sUnitWgt	= record.get('UNIT_WGT');
						var sOrderWgtQ	= sInout_q * sUnitWgt;
						record.set('INOUT_WGT_Q', sOrderWgtQ);

						//출고량(부피) 재계산
						var sUnitVol	= record.get('UNIT_VOL');
						var sOrderVolQ	= sInout_q * sUnitVol;
						record.set('INOUT_VOL_Q', sOrderVolQ);

						UniAppManager.app.fnOrderAmtCal(record, 'Q', fieldName, sInout_q);
						detailStore.fnOrderAmtSum();

						record.set('PACK_UNIT_Q', 0);
						record.set('BOX_Q'		, 0);
						record.set('EACH_Q'		, 0);
						setTimeout(function() {
							record.set('ORDER_UNIT_Q', sInout_q);		//출고수량
						}, 50);
						break;

					case "INOUT_WGT_Q" :	//hidden
						if(newValue < 0 && !Ext.isEmpty(newValue)) {
							rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							break;
						}
						var sOrderWgtQ = record.get('INOUT_WGT_Q');
						var sUnitWgt = record.get('UNIT_WGT');
						if(sUnitWgt == 0) {
							rv='<t:message code="system.message.sales.message063" default="단위중량이 입력되지 않아서 계산이 불가능합니다. 품목정보에서 단위중량을 확인하시기 바랍니다."/>'
							break;
						}
						var sInout_q = sUnitWgt == 0 ? 0 : sOrderWgtQ / sUnitWgt;
						if(BsaCodeInfo.gsPointYn == "N" && (record.get('ORDER_UNIT') == BsaCodeInfo.gsPointYn)) {
							if(sInout_q - (Math.floor(sInout_q)) != 0) {
								rv='<t:message code="system.message.sales.message064" default="수주량(판매단위)은 소숫점을 입력할 수 없습니다. 수주량(중량단위)을 확인하시기 바랍니다."/>'
								break;
							}
						}
						record.set('ORDER_UNIT_Q', sInout_q);
						sInout_q = record.get('ORDER_UNIT_Q');
						var sInv_q = record.get('STOCK_Q');	//재고량
						var sOriginQ = record.get('ORIGIN_Q');//출고량
						var sExcessQ = record.get('EXCESS_RATE');//초과량

						if(BsaCodeInfo.gsInvstatus == "+" && (record.get('STOCK_CARE_YN') == "Y")) {
							if(sInout_q  > sInv_q + sOriginQ) {
								rv='<t:message code="system.message.sales.message067" default="출고량은 재고량을 초과할 수 없습니다."/>';	//출고량은 재고량을 초과할 수 없습니다.
								break;
							}
						}
						//출고량(부피) 재계산
						var sUnitVol = record.get('UNIT_VOL')
						var sOrderVolQ = sInout_q * sUnitVol;
						record.set('INOUT_VOL_Q', sOrderVolQ);

						UniAppManager.app.fnOrderAmtCal(record, 'Q', fieldName, newValue);
						detailStore.fnOrderAmtSum();
						break;

					case "INOUT_VOL_Q" :	//hidden
						break;

					case "ORDER_UNIT_P" :
						if(newValue < 0 && !Ext.isEmpty(newValue)) {
							rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							break;
						}
						//수주단가(중량) 재계산
						var sUnitWgt = record.get('UNIT_WGT');
						var sInoutForP = record.get('ORDER_UNIT_P');
						var sInoutWgtForP = sUnitWgt == 0 ? 0 : sInoutForP / sUnitWgt;
						record.set('INOUT_FOR_WGT_P', sInoutWgtForP);

						//수주단가(부피) 재계산
						var sUnitVol = record.get('UNIT_VOL');
						var sInoutForP = record.get('ORDER_UNIT_P');
						var sInoutVolForP = sUnitVol == 0 ? 0 : sInoutForP / sUnitVol;
						record.set('INOUT_FOR_VOL_P', sInoutVolForP);
						console.log('sInoutWgtForP:' + sInoutWgtForP + '\n' + 'sInoutVolForP:' + sInoutVolForP );

						UniAppManager.app.fnOrderAmtCal(record, 'P', fieldName, newValue);
						detailStore.fnOrderAmtSum();
						break;

					case "INOUT_FOR_WGT_P" :	//hidden
						break;

					case "INOUT_FOR_VOL_P" :	//hidden
						break;

					case "ORDER_UNIT_O" :
						if(newValue < 0 && !Ext.isEmpty(newValue)) {
							rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							break;
						}
						var dTaxAmtO = record.get('INOUT_TAX_AMT');
						if(newValue > 0 && dTaxAmtO > newValue) {
							rv='<t:message code="system.message.sales.message040" default="매출금액은 세액보다 커야 합니다."/>';	//매출금액은 세액보다 커야 합니다.
							break;
						}

						UniAppManager.app.fnOrderAmtCal(record, 'O', fieldName, newValue);
						rv = false;
						detailStore.fnOrderAmtSum();
						break;

					case "TAX_TYPE" :
						var dOrderO=record.get('ORDER_UNIT_Q')*record.get('ORDER_UNIT_P');
						record.set('ORDER_UNIT_O', dOrderO);
						UniAppManager.app.fnOrderAmtCal(record, "O",'ORDER_UNIT_O', dOrderO, newValue);
						detailStore.fnOrderAmtSum();
						break;

					case "INOUT_TAX_AMT" :
						var dSaleAmtO = record.get('ORDER_UNIT_O');
						if(newValue > 0 && dSaleAmtO < newValue) {
							rv='<t:message code="system.message.sales.message040" default="매출금액은 세액보다 커야 합니다."/>';	//매출금액은 세액보다 커야 합니다.
							break;
						}
						var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
						if(UserInfo.compCountry == "CN") {
							record.set('INOUT_TAX_AMT', UniSales.fnAmtWonCalc(newValue, "3"), numDigitOfPrice)
						} else {
							record.set('INOUT_TAX_AMT', UniSales.fnAmtWonCalc(newValue, "2"), numDigitOfPrice)
						}
						detailStore.fnOrderAmtSum();
						break;

					case "ACCOUNT_YNC" :
						if(newValue == "N") {
							record.set('ORDER_UNIT_P', 0);
							record.set('INOUT_FOR_WGT_P', 0);
							record.set('INOUT_FOR_VOL_P', 0);
							record.set('INOUT_WGT_P', 0);
							record.set('INOUT_VOL_P', 0);
							record.set('ORDER_UNIT_O', 0);
							record.set('INOUT_TAX_AMT', 0);
						} else {
							if(record.get('SRQ100T_PRICE') != 0 && record.get('SOF110T_PRICE') != 0) {
								record.set('ORDER_UNIT_P', record.get('SRQ100T_PRICE'));
							} else if(record.get('SOF110T_PRICE') != 0) {
								record.set('ORDER_UNIT_P', record.get('SOF110T_PRICE'));
							}
						}
						//수주단가(중량) 재계산
						var sUnitWgt = record.get('UNIT_WGT');
						var sInoutForP = record.get('ORDER_UNIT_P');
						var sInoutWgtForP = sUnitWgt == 0 ? 0 : sInoutForP / sUnitWgt;
						record.set('INOUT_FOR_WGT_P', sInoutWgtForP);

						//수주단가(부피) 재계산
						var sUnitVol = record.get('UNIT_VOL');
						var sInoutForP = record.get('ORDER_UNIT_P');
						var sInoutVolForP = sUnitVol == 0 ? 0 : sInoutForP / sUnitVol;
						record.set('INOUT_FOR_VOL_P', sInoutVolForP);

						UniAppManager.app.fnOrderAmtCal(record, 'P', fieldName, newValue);
						detailStore.fnOrderAmtSum();

						break;

					case "DELIVERY_DATE" :	////날짜형식에 맞게 수정해야함 	____ . __ . __
						break;

					case "DELIVERY_TIME" :	////시간형식에 맞게 수정해야함	__ . __ . __
						break;

					case "DVRY_CUST_CD" :	//hidden
						break;

					case "DVRY_CUST_NAME" :	////배송처 팝업 만들어야함
						break;

					case "DISCOUNT_RATE" :
						if(newValue < 0 && !Ext.isEmpty(newValue)) {
							rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							break;
						}
						UniAppManager.app.fnOrderAmtCal(record, 'C', fieldName, (100 - newValue));
						detailStore.fnOrderAmtSum();
						break;

					case "LOT_NO" :		////LOT_NO팝업 만들어야함
						break;

					case "TRANS_COST" :
						break;

					case "PACK_UNIT_Q" :		//BOX 입수
						if(BsaCodeInfo.gsBoxYN == 'Y') {
							var sInout_q = 0;
							if(record.obj.phantom) {
								if(!Ext.isEmpty(record.get('ORDER_NUM')) || !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) {
									if(newValue * record.get('BOX_Q') + record.get('EACH_Q') > record.get('ORIGIN_Q')) {			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q');	//출고수량 = 미납량(참조에서 가져온 미납량)
										record.set('LOSS_Q',newValue * record.get('BOX_Q') + record.get('EACH_Q') - record.get('ORIGIN_Q'));//LOSS여분 = 출고수량 - 미납량
									} else {
										sInout_q = newValue * record.get('BOX_Q') + record.get('EACH_Q');	//출고량
										record.set('LOSS_Q',0);
									}
								} else {
									//20191030 신규 행 추가 시 박스입수, 수량, 낱개 관련 계산로직 수정
									sInout_q = newValue * record.get('BOX_Q') + record.get('EACH_Q');	//출고량
//									sInout_q = newValue;	//출고량
									record.set('LOSS_Q',0);
								}
							} else {
								if(!Ext.isEmpty(record.get('ORDER_NUM')) && Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) {		//수주참조
									if(newValue * record.get('BOX_Q') + record.get('EACH_Q') > record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q')) {			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q');	//출고수량 = 미납량
										record.set('LOSS_Q',newValue * record.get('BOX_Q') + record.get('EACH_Q') - (record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q')));//LOSS여분 = 출고수량 - 미납량

									} else {
										sInout_q = newValue * record.get('BOX_Q') + record.get('EACH_Q');	//출고량
										record.set('LOSS_Q',0);
									}
								} else if(!Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) {	//출하지시참조
									if(newValue * record.get('BOX_Q') + record.get('EACH_Q') > record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q')) {			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q');	//출고수량 = 미납량
										record.set('LOSS_Q',newValue * record.get('BOX_Q') + record.get('EACH_Q') - (record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q')));//LOSS여분 = 출고수량 - 미납량

									} else {
										sInout_q = newValue * record.get('BOX_Q') + record.get('EACH_Q');	//출고량
										record.set('LOSS_Q',0);
									}
								}
							}
							record.set('ORDER_UNIT_Q', sInout_q);   //출고량 = box입수 * box수 + 낱개

							var sInv_q = record.get('STOCK_Q');	//재고량
							var sOriginQ = record.get('ORIGIN_Q'); //출고량
							var lot_q = record.get('TEMP_ORDER_UNIT_Q');//로트팝업에서 넘겨받는 수량

							if(!Ext.isEmpty(lot_q) && lot_q!= 0) {
								if(sInout_q > lot_q) {
									rv = '<t:message code="system.message.sales.message062" default="출고량은 lot재고량을 초과할 수 없습니다. 현재고: "/>' + lot_q;
									break;
								}
							}

							if(BsaCodeInfo.gsInvstatus == "+" && (record.get('STOCK_CARE_YN') == "Y")) {
								if(sInout_q > (sInv_q + sOriginQ)) {
									rv='<t:message code="system.message.sales.message067" default="출고량은 재고량을 초과할 수 없습니다."/>';	//출고량은 재고량을 초과할 수 없습니다.
									break;
								}
							}
							//출고량(중량) 재계산
							var sUnitWgt = record.get('UNIT_WGT');
							var sOrderWgtQ = sInout_q * sUnitWgt;
							record.set('INOUT_WGT_Q', sOrderWgtQ);

							//출고량(부피) 재계산
							var sUnitVol = record.get('UNIT_VOL');
							var sOrderVolQ = sInout_q * sUnitVol;
							record.set('INOUT_VOL_Q', sOrderVolQ);

							UniAppManager.app.fnOrderAmtCal(record, 'Q', fieldName, sInout_q);
							detailStore.fnOrderAmtSum();
						}
						break;

					case "BOX_Q" :				//BOX 수
						if(BsaCodeInfo.gsBoxYN == 'Y') {
							var sInout_q = 0;
							if(record.obj.phantom) {
								if(!Ext.isEmpty(record.get('ORDER_NUM')) || !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) {
									if(record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') > record.get('ORIGIN_Q')) {			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q');	//출고수량 = 미납량(참조에서 가져온 미납량)
										record.set('LOSS_Q',record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') - record.get('ORIGIN_Q'));//LOSS여분 = 출고수량 - 미납량
									} else {
										sInout_q = record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q');	//출고량
										record.set('LOSS_Q',0);
									}
								} else {
									sInout_q = record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q');	//출고량
									record.set('LOSS_Q',0);
								}
							} else {
								if(!Ext.isEmpty(record.get('ORDER_NUM')) && Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) {		//수주참조
									if(record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') > record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q')) {			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q');	//출고수량 = 미납량
										record.set('LOSS_Q',record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') - (record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q')));//LOSS여분 = 출고수량 - 미납량

									} else {
										sInout_q = record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q');	//출고량
										record.set('LOSS_Q',0);
									}
								} else if(!Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) {	//출하지시참조
									if(record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') > record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q')) {			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q');	//출고수량 = 미납량
										record.set('LOSS_Q',record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') - (record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q')));//LOSS여분 = 출고수량 - 미납량

									} else {
										sInout_q = record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q');	//출고량
										record.set('LOSS_Q',0);
									}
								}
							}
							record.set('ORDER_UNIT_Q', sInout_q);

							var sInv_q = record.get('STOCK_Q');	//재고량
							var sOriginQ = record.get('ORIGIN_Q'); //출고량
							var lot_q = record.get('TEMP_ORDER_UNIT_Q');//로트팝업에서 넘겨받는 수량

							if(!Ext.isEmpty(lot_q) && lot_q!= 0) {
								if(sInout_q > lot_q) {
									rv = '<t:message code="system.message.sales.message062" default="출고량은 lot재고량을 초과할 수 없습니다. 현재고: "/>' + lot_q;
									break;
								}
							}

							if(BsaCodeInfo.gsInvstatus == "+" && (record.get('STOCK_CARE_YN') == "Y")) {
								if(sInout_q > (sInv_q + sOriginQ)) {
									rv='<t:message code="system.message.sales.message067" default="출고량은 재고량을 초과할 수 없습니다."/>';	//출고량은 재고량을 초과할 수 없습니다.
									break;
								}
							}
							//출고량(중량) 재계산
							var sUnitWgt = record.get('UNIT_WGT');
							var sOrderWgtQ = sInout_q * sUnitWgt;
							record.set('INOUT_WGT_Q', sOrderWgtQ);

							//출고량(부피) 재계산
							var sUnitVol = record.get('UNIT_VOL');
							var sOrderVolQ = sInout_q * sUnitVol;
							record.set('INOUT_VOL_Q', sOrderVolQ);

							UniAppManager.app.fnOrderAmtCal(record, 'Q', fieldName, sInout_q);
							detailStore.fnOrderAmtSum();
						}
						break;

					case "EACH_Q" :				//낱개
						if(BsaCodeInfo.gsBoxYN == 'Y') {
							if(record.obj.phantom) {
								if(!Ext.isEmpty(record.get('ORDER_NUM')) || !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) {
									if(record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue > record.get('ORIGIN_Q')) {			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q');	//출고수량 = 미납량(참조에서 가져온 미납량)
										record.set('LOSS_Q',record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue - record.get('ORIGIN_Q'));//LOSS여분 = 출고수량 - 미납량
									} else {
										sInout_q = record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue;	//출고량
										record.set('LOSS_Q',0);
									}
								} else {
									//20191030 신규 행 추가 시 박스입수, 수량, 낱개 관련 계산로직 수정
									sInout_q = record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue;	//출고량
									record.set('LOSS_Q',0);
								}
							} else {
								if(!Ext.isEmpty(record.get('ORDER_NUM')) && Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) {		//수주참조
									if(record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue > record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q')) {			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q');	//출고수량 = 미납량
										record.set('LOSS_Q',record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue - (record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q')));//LOSS여분 = 출고수량 - 미납량

									} else {
										sInout_q = record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue;	//출고량
										record.set('LOSS_Q',0);
									}
								} else if(!Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) {	//출하지시참조
									if(record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue > record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q')) {			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q');	//출고수량 = 미납량
										record.set('LOSS_Q',record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue - (record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q')));//LOSS여분 = 출고수량 - 미납량
									} else {
										sInout_q = record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue;	//출고량
										record.set('LOSS_Q',0);
									}
								}
							}
							record.set('ORDER_UNIT_Q', sInout_q);

							var sInv_q = record.get('STOCK_Q');	//재고량
							var sOriginQ = record.get('ORIGIN_Q'); //출고량
							var lot_q = record.get('TEMP_ORDER_UNIT_Q');//로트팝업에서 넘겨받는 수량

							if(!Ext.isEmpty(lot_q) && lot_q!= 0) {
								if(sInout_q > lot_q) {
									rv = '<t:message code="system.message.sales.message062" default="출고량은 lot재고량을 초과할 수 없습니다. 현재고: "/>' + lot_q;
									break;
								}
							}

							if(BsaCodeInfo.gsInvstatus == "+" && (record.get('STOCK_CARE_YN') == "Y")) {
								if(sInout_q > (sInv_q + sOriginQ)) {
									rv='<t:message code="system.message.sales.message067" default="출고량은 재고량을 초과할 수 없습니다."/>';	//출고량은 재고량을 초과할 수 없습니다.
									break;
								}
							}
							//출고량(중량) 재계산
							var sUnitWgt = record.get('UNIT_WGT');
							var sOrderWgtQ = sInout_q * sUnitWgt;
							record.set('INOUT_WGT_Q', sOrderWgtQ);

							//출고량(부피) 재계산
							var sUnitVol = record.get('UNIT_VOL');
							var sOrderVolQ = sInout_q * sUnitVol;
							record.set('INOUT_VOL_Q', sOrderVolQ);

							UniAppManager.app.fnOrderAmtCal(record, 'Q', fieldName, sInout_q);
							detailStore.fnOrderAmtSum();
						}
						break;

					case "LOSS_Q" :				//LOSS여분
						break;

					//20210216 추가: '부가세유형' 컬럼 콤보로 변경 / 수정 가능하도록 변경 (hidden: false) / 변경에 따른 금액 계산로직 추가
					case "BILL_TYPE" :
						if(newValue == '50') {			//'영세매출'일 때만 '면세'로 변경 후, 재계산...('영세' 아님)
							record.set('TAX_TYPE'		, '2');
							record.set('INOUT_TAX_AMT'	, '0');
						} else {
							record.set('TAX_TYPE'		, '1');
						}
						var sInout_q = record.get('ORDER_UNIT_Q');
						UniAppManager.app.fnOrderAmtCal(record, 'Q', 'ORDER_UNIT_Q', sInout_q, null, null);
						detailStore.fnOrderAmtSum();
						break;

					//20210225 추가: GOODS_CODE
					case "GOODS_CODE" :
						if(!Ext.isEmpty(newValue)) {
							var param = {
								'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
								'CUSTOM_CODE'	: panelResult.getValue('CUSTOM_CODE'),
								'GOODS_CODE'	: newValue
							}
							s_sal100ukrv_wmService.getUnitPrice(param, function(provider, response) {
								if(provider && provider.length != 0) {
									record.set('ORDER_UNIT_P'	, provider);
									record.set('BILL_TYPE'		, '10');		//20210319 수정: 70 -> 10
									UniAppManager.app.fnOrderAmtCal(record, 'P');
									detailStore.fnOrderAmtSum();
								} else {
									rv = '해당 상품코드에 대한 정보가 없습니다.';
									return false;
								}
							});
						}
					break;
				}
			}
			return rv;
		}
	});



	//화폐에 따라 컬럼 포맷설정하는 부분 함수로 뺀 후, 여러곳에서 호출하도록 수정
	function fnSetColumnFormat() {
		var length = 0
		var format = ''
		if(panelResult.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit) {
			length = Ext.isEmpty(UniFormat.FC.split('.')[1]) ? 0 : UniFormat.FC.split('.')[1].length;
			format = UniFormat.FC;
			//화폐에 따라 국내외구분 값 set
			panelResult.setValue('NATION_INOUT'	,'2');
		} else {
			length = Ext.isEmpty(UniFormat.Price.split('.')[1]) ? 0 : UniFormat.Price.split('.')[1].length;
			format = UniFormat.Price;
			//화폐에 따라 국내외구분 값 set
			panelResult.setValue('NATION_INOUT'	,'1');
		}
		panelResult.getField('TOT_SALE_TAXI').setConfig('decimalPrecision',length);
		panelResult.getField('TOT_SALE_TAXI').focus();
		panelResult.getField('TOT_SALE_TAXI').blur();
		panelResult.getField('TOT_TAXI').setConfig('decimalPrecision',length);
		panelResult.getField('TOT_TAXI').focus();
		panelResult.getField('TOT_TAXI').blur();
		panelResult.getField('TOT_SALENO_TAXI').setConfig('decimalPrecision',length);
		panelResult.getField('TOT_SALENO_TAXI').focus();
		panelResult.getField('TOT_SALENO_TAXI').blur();
		panelResult.getField('TOTAL_AMT').setConfig('decimalPrecision',length);
		panelResult.getField('TOTAL_AMT').focus();
		panelResult.getField('TOTAL_AMT').blur();

		detailGrid.getColumn("ORDER_UNIT_O").setConfig('format'	,format);
		detailGrid.getColumn("ORDER_AMT_SUM").setConfig('format',format);
		detailGrid.getColumn("INOUT_TAX_AMT").setConfig('format',format);

		detailGrid.getColumn("ORDER_UNIT_O").setConfig('decimalPrecision',length);
		detailGrid.getColumn("ORDER_AMT_SUM").setConfig('decimalPrecision',length);
		detailGrid.getColumn("INOUT_TAX_AMT").setConfig('decimalPrecision',length);
		//20190906 추가
		if(!Ext.isEmpty(detailGrid.getColumn("ORDER_UNIT_O").config.editor) && !Ext.isEmpty(detailGrid.getColumn("ORDER_UNIT_O").config.editor.decimalPrecision)) {
			detailGrid.getColumn("ORDER_UNIT_O").config.editor.decimalPrecision = length;
		}
		if(!Ext.isEmpty(detailGrid.getColumn("ORDER_UNIT_O").editor)) {
			detailGrid.getColumn("ORDER_UNIT_O").editor.decimalPrecision = length;
		}
		if(!Ext.isEmpty(detailGrid.getColumn("ORDER_AMT_SUM").config.editor) && !Ext.isEmpty(detailGrid.getColumn("ORDER_AMT_SUM").config.editor.decimalPrecision)) {
			detailGrid.getColumn("ORDER_AMT_SUM").config.editor.decimalPrecision = length;
		}
		if(!Ext.isEmpty(detailGrid.getColumn("ORDER_AMT_SUM").editor)) {
			detailGrid.getColumn("ORDER_AMT_SUM").editor.decimalPrecision = length;
		}
		if(!Ext.isEmpty(detailGrid.getColumn("INOUT_TAX_AMT").config.editor) && !Ext.isEmpty(detailGrid.getColumn("INOUT_TAX_AMT").config.editor.decimalPrecision)) {
			detailGrid.getColumn("INOUT_TAX_AMT").config.editor.decimalPrecision = length;
		}
		if(!Ext.isEmpty(detailGrid.getColumn("INOUT_TAX_AMT").editor)) {
			detailGrid.getColumn("INOUT_TAX_AMT").editor.decimalPrecision = length;
		}

		if(isLoad) {
			isLoad = false;
		} else {
			UniAppManager.app.fnExchngRateO();
		}
	}
};
</script>