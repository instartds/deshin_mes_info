<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sco110ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sco110ukrv" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />			<!--영업/수금담당자-->
	<t:ExtComboStore comboType="AU" comboCode="S017" />			<!-- 수금유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B064" />			<!-- 어음유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />			<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="S114" />			<!-- 수금참조경로 -->
	<t:ExtComboStore comboType="AU" comboCode="B066" />			<!-- 계산서유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A028" />			<!-- 신용카드회사 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" />			<!-- 판매유형 -->
</t:appConfig>
<style type="text/css">
.search-hr {height: 1px;}
</style>
<script type="text/javascript">

// //통장번호, 은행, 프로젝트 팝업, 브랜치입금정보 팝업 만들기
var searchInfoWindow;		// searchInfoWindow : 검색창
var referSalesWindow;		// 매출참조
var referWindow;			// 계산서미수금참조내역
var gvRemainderAmt1 = 0;	// 미수금
var gvRemainderAmt2 = 0;	// 선수금
var orderFlag = '';			// 폼수정or검색창에서 더블클릭 set 둘다change를 타므로 플레그값으로 처리를 해줌(검색창에서 넘어올경우 미수잔액,선수금잔액 가져올 필요 없다.)
var outDivCode = UserInfo.divCode;

var BsaCodeInfo = {
	gsAutoType			: '${gsAutoType}',
	gsMoneyUnit			: '${gsMoneyUnit}',
	gsPjtCodeYN			: '${gsPjtCodeYN}',
	gsCollectCd			: '${gsCollectCd}',
	gsExchangeDiffAmt	: '${gsExchangeDiffAmt}',
	salePrsn			: ${salePrsn},
	editableYN			: ${editableYN},
	gsPLCode			: ${gsPLCode},
	grsOutType			: ${grsOutType}
};

var CustomCodeInfo = {
	gsAgentType		: '',
	gsCustCrYn		: '',
	gsUnderCalBase	: ''
};

var AutoType = false;
if(BsaCodeInfo.gsAutoType == "Y"){
	AutoType = true;
}

var pjtCodeYN = false;
if(BsaCodeInfo.gsAutoType == "N"){
	pjtCodeYN = true;
}

/* var output =''; for(var key in BsaCodeInfo){ output += key + ' : ' +
 * BsaCodeInfo[key] + '\n'; } Unilite.messageBox(output);
 */

function appMain() {
	/** 자동채번 여부
	*/
	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoOrderNum = true;
	}



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sco110ukrvService.selectDetailList',
			update	: 'sco110ukrvService.updateDetail',
			create	: 'sco110ukrvService.insertDetail',
			destroy	: 'sco110ukrvService.deleteDetail',
			syncAll	: 'sco110ukrvService.saveAll'
		}
	});

	/** 수주의 마스터 정보를 가지고 있는 Form
	*/
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.sales.collectinfo" default="수금정보"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
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
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts){
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('COLL_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);// panelResult의 필터링 처리 위해..

						panelResult.setValue('DIV_CODE', newValue);
						if(orderFlag != "1"){	//폼수정or검색창에서 더블클릭 set 둘다change를 타므로 플레그값으로 처리를 해줌(검색창에서 넘어올경우 미수잔액,선수금잔액 가져올 필요 없다.)
							UniAppManager.app.fnCallGetRemainder('DIV_CODE', newValue)	// 미수잔액, 선수금잔액 구하기
						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.collectiondate" default="수금일"/>',
				xtype		: 'uniDatefield',
				allowBlank	: false,
				name		: 'COLL_DATE',
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts){
						panelResult.setValue('COLL_DATE', newValue);
						if(orderFlag != "1"){	// 폼수정or검색창에서 더블클릭 set 둘다change를 타므로 플레그값으로 처리를 해줌(검색창에서 넘어올경우 미수잔액,선수금잔액 가져올 필요 없다.)
							UniAppManager.app.fnCallGetRemainder('COLL_DATE', newValue)	// 미수잔액, 선수금잔액 구하기
						}
					},
					blur : function () {
						UniAppManager.app.fnExchngRateO();
					}
				}
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
				allowBlank		: false,
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				holdable		: 'hold',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							var cstomCd = panelSearch.getValue('CUSTOM_CODE');
							var cstomNm = panelSearch.getValue('CUSTOM_NAME');
							panelSearch.setValue('COLL_CUSTOM_CODE'	, records[0]["COLLECTOR_CP"]);
							panelSearch.setValue('COLL_CUSTOM_NAME'	, records[0]["COLLECTOR_NM"]);
							panelResult.setValue('CUSTOM_CODE'		, cstomCd);
							panelResult.setValue('CUSTOM_NAME'		, cstomNm);
							panelResult.setValue('COLL_CUSTOM_CODE'	, records[0]["COLLECTOR_CP"]);
							panelResult.setValue('COLL_CUSTOM_NAME'	, records[0]["COLLECTOR_NM"]);

							if(Ext.isEmpty(panelSearch.getValue('COLL_CUSTOM_CODE'))){
								panelSearch.setValue('COLL_CUSTOM_CODE', cstomCd);
								panelSearch.setValue('COLL_CUSTOM_NAME', cstomNm);
								panelResult.setValue('COLL_CUSTOM_CODE', cstomCd);
								panelResult.setValue('COLL_CUSTOM_NAME', cstomNm)
							}
							CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];

							if(Ext.isEmpty(panelSearch.getValue('COLL_PRSN'))){
								var busiPrsn = records[0]["BUSI_PRSN"]
								var sDivCode = UniAppManager.app.fnGetSalePrsnDivCode(busiPrsn);
								if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE')) && sDivCode == panelSearch.getValue('DIV_CODE')){
									panelSearch.setValue('COLL_PRSN', busiPrsn)
									panelResult.setValue('COLL_PRSN', busiPrsn)
								}
							}
							if(orderFlag != "1"){	// 폼수정or검색창에서 더블클릭 set 둘다change를 타므로 플레그값으로 처리를 해줌(검색창에서 넘어올경우 미수잔액,선수금잔액 가져올 필요 없다.)
								UniAppManager.app.fnCallGetRemainder('CUSTOM_CODE', cstomCd)	// 미수잔액, 선수금잔액 구하기
							}
							var saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(panelSearch.getValue('COLL_PRSN'));// 영업담당의 사업장코드 가져오기
							panelResult.setValue('COLL_DIV_CODE', saleDivCode);
							panelSearch.setValue('COLL_DIV_CODE', saleDivCode);
						},
						scope: this
					},
					onClear: function(type) {
						CustomCodeInfo.gsUnderCalBase = '';
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.sales.referencepath" default="참조경로"/>',
				name		: 'REF_LOC',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S114',
				value		: '1',
				allowBlank	: false,
				holdable	: 'hold',
				hidden		: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts){
						panelResult.setValue('REF_LOC', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.sales.collectionplace" default="수금처"/>',
				valueFieldName	: 'COLL_CUSTOM_CODE',
				textFieldName	: 'COLL_CUSTOM_NAME',
				validateBlank	: false,
				holdable		: 'hold',
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('COLL_CUSTOM_CODE', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('COLL_CUSTOM_NAME', '');
							panelResult.setValue('COLL_CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('COLL_CUSTOM_NAME', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('COLL_CUSTOM_CODE', '');
							panelResult.setValue('COLL_CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.sales.collectioncharge" default="수금담당"/>',
				name		: 'COLL_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010',
				holdable	: 'hold',
				allowBlank	: false,
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					} else {
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners:{
					change: function(combo, newValue, oldValue, eOpts) {
						var saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(newValue);	// 영업담당의 사업장코드 가져오기
						panelResult.setValue('COLL_DIV_CODE', saleDivCode);
						panelSearch.setValue('COLL_DIV_CODE', saleDivCode);
						panelResult.setValue('COLL_PRSN'	, panelSearch.getValue('COLL_PRSN'));
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.currency" default="화폐"/>',
				name		: 'MONEY_UNIT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B004',
				allowBlank	: false,
				holdable	: 'hold',
				displayField: 'value',
				fieldStyle	: 'text-align: center;',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts){
						panelResult.setValue('MONEY_UNIT', newValue);
						if(orderFlag != "1"){	// 폼수정or검색창에서 더블클릭 set 둘다change를 타므로 플레그값으로 처리를 해줌(검색창에서 넘어올경우 미수잔액,선수금잔액 가져올 필요 없다.)
							UniAppManager.app.fnCallGetRemainder('MONEY_UNIT', newValue)	// 미수잔액, 선수금잔액 구하기
						}
						console.log(UniFormat.FC);
						console.log(UniFormat.FC);
						if(newValue != BsaCodeInfo.gsMoneyUnit){
							var length = Ext.isEmpty(UniFormat.FC.split('.')[1]) ? 0 : UniFormat.FC.split('.')[1].length;
							detailGrid.getColumn("COLLECT_FOR_AMT").setConfig('format',UniFormat.FC);
							detailGrid.getColumn("COLLECT_FOR_AMT").setConfig('decimalPrecision',length);
							detailGrid.getView().refresh(true);
						} else {
							var length = Ext.isEmpty(UniFormat.Price.split('.')[1]) ? 0 : UniFormat.Price.split('.')[1].length;
							detailGrid.getColumn("COLLECT_FOR_AMT").setConfig('format',UniFormat.Price);
							detailGrid.getColumn("COLLECT_FOR_AMT").setConfig('decimalPrecision',length);
							detailGrid.getView().refresh(true);
						}
					},
					blur: function( field, The, eOpts ) {
						UniAppManager.app.fnExchngRateO();
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.exchangerate" default="환율"/>',
				name		: 'EXCHG_RATE',
				xtype		: 'uniNumberfield',
				allowBlank	: false,
				holdable	: 'hold',
				decimalPrecision: 4,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts){
						panelResult.setValue('EXCHG_RATE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.collectionno" default="수금번호"/>',
				name		: 'COLL_NUM',
				xtype		: 'uniTextfield',
				allowBlank	: AutoType,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts){
						panelResult.setValue('COLL_NUM', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.collectiondivision" default="수금사업장"/>',
				name		: 'COLL_DIV_CODE',
				comboType	: 'BOR120',
				xtype		: 'uniCombobox',
				readOnly	: true,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts){
						panelResult.setValue('COLL_DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.slipdate" default="전표일"/>',
				xtype		: 'uniDatefield',
				name		: 'EX_DATE',
				holdable	: 'hold',
				readOnly	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts){
						panelResult.setValue('EX_DATE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.slipno" default="전표번호"/>',
				name		: 'EX_NUM',
				xtype		: 'uniTextfield',
				readOnly	: true,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts){
						panelResult.setValue('EX_NUM', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.arbalance" default="미수잔액"/>',
				name		: 'REMAIN_UNCOLL',
				xtype		: 'uniNumberfield',
				holdable	: 'hold'
			},{
				fieldLabel	: '<t:message code="system.label.sales.advancebalance" default="선수금잔액"/>',
				name		: 'REMAIN_ADV',
				xtype		: 'uniNumberfield',
				holdable	: 'hold'
			},{
				fieldLabel	: '<t:message code="system.label.sales.collectiontotalamount" default="수금총액"/>',
				name		: 'TOTAL_FOR_AMT',
				xtype		: 'uniNumberfield',
				holdable	: 'hold'
			},{
				fieldLabel	: '<t:message code="system.label.sales.exchangecollectiontotamt" default="환산수금총액"/>',
				name		: 'TOTAL_AMT',
				xtype		: 'uniNumberfield',
				holdable	: 'hold',
				hidden		: true
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					// this.mask();
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
				// this.unmask();
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

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
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
				change: function(combo, newValue, oldValue, eOpts){
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelSearch.getField('COLL_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);// panelResult의 필터링처리 위해..
					panelSearch.setValue('DIV_CODE', newValue);
					if(orderFlag != "1"){// 폼수정or검색창에서 더블클릭 set 둘다change를 타므로 플레그값으로 처리를 해줌(검색창에서 넘어올경우 미수잔액,선수금잔액 가져올 필요 없다.)
						UniAppManager.app.fnCallGetRemainder('DIV_CODE', newValue)	// 미수잔액, 선수금잔액 구하기
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.collectiondate" default="수금일"/>',
			xtype		: 'uniDatefield',
			name		: 'COLL_DATE',
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts){
					panelSearch.setValue('COLL_DATE', newValue);
					if(orderFlag != "1"){	// 폼수정or검색창에서 더블클릭 set 둘다change를 타므로 플레그값으로 처리를 해줌(검색창에서 넘어올경우 미수잔액,선수금잔액 가져올 필요 없다.)
						UniAppManager.app.fnCallGetRemainder('COLL_DATE', newValue)	// 미수잔액, 선수금잔액 구하기
					}
				},
				blur: function( field, The, eOpts ) {
					UniAppManager.app.fnExchngRateO();
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			allowBlank		: false,
			holdable		: 'hold',
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('MONEY_UNIT',records[0].MONEY_UNIT);
						panelSearch.setValue('MONEY_UNIT',records[0].MONEY_UNIT);
						UniAppManager.app.fnExchngRateO();
						var cstomNm = panelResult.getValue('CUSTOM_NAME');
						var cstomCd = panelResult.getValue('CUSTOM_CODE');
						panelResult.setValue('COLL_CUSTOM_CODE'	, records[0]["COLLECTOR_CP"]);
						panelResult.setValue('COLL_CUSTOM_NAME'	, records[0]["COLLECTOR_NM"]);
						panelSearch.setValue('CUSTOM_CODE'		, cstomCd);
						panelSearch.setValue('CUSTOM_NAME'		, cstomNm);
						panelSearch.setValue('COLL_CUSTOM_CODE'	, records[0]["COLLECTOR_CP"]);
						panelSearch.setValue('COLL_CUSTOM_NAME'	, records[0]["COLLECTOR_NM"]);

						if(Ext.isEmpty(panelResult.getValue('COLL_CUSTOM_CODE'))){
							panelResult.setValue('COLL_CUSTOM_CODE', cstomCd);
							panelResult.setValue('COLL_CUSTOM_NAME', cstomNm);
							panelSearch.setValue('COLL_CUSTOM_CODE', cstomCd);
							panelSearch.setValue('COLL_CUSTOM_NAME', cstomNm)
						}
						CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];

						if(Ext.isEmpty(panelResult.getValue('COLL_PRSN'))){
							var busiPrsn = records[0]["BUSI_PRSN"]
							var sDivCode = UniAppManager.app.fnGetSalePrsnDivCode(busiPrsn);
							if(!Ext.isEmpty(panelResult.getValue('DIV_CODE')) && sDivCode == panelResult.getValue('DIV_CODE')){
								panelResult.setValue('COLL_PRSN', busiPrsn)
								panelSearch.setValue('COLL_PRSN', busiPrsn)
							}
						}
						if(orderFlag != "1"){	// 폼수정or검색창에서 더블클릭 set 둘다change를 타므로 플레그값으로 처리를 해줌(검색창에서 넘어올경우 미수잔액,선수금잔액 가져올 필요 없다.)
							UniAppManager.app.fnCallGetRemainder('CUSTOM_CODE', cstomCd)	// 미수잔액, 선수금잔액 구하기
						}
						var saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(panelSearch.getValue('COLL_PRSN'));// 영업담당의 사업장코드 가져오기
						panelResult.setValue('COLL_DIV_CODE', saleDivCode);
						panelSearch.setValue('COLL_DIV_CODE', saleDivCode);
					},
					scope: this
				},
				onClear: function(type) {
					CustomCodeInfo.gsUnderCalBase = '';
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			xtype	: 'container' ,
			layout	: {type:'hbox', align:'stretched'},
			width	: 200,
			style	: {'margin-left':'20px'},
			items	: [{
				xtype	: 'button',
				text	: '<t:message code="system.label.sales.collectionslip" default="수금기표"/>',
				itemId	: 'btnCreate',
				width	: 80,
				handler	: function() {
					var collNum = panelResult.getValue("COLL_NUM");
					if(collNum) {
						var paramCheck = panelResult.getValues();
						paramCheck.BASIS_NUM = collNum;
						
						sco110ukrvService.selectCollectNumMasterList(paramCheck,function(responseText, response) {
							console.log("responseText : ",responseText);
							console.log("response : ",response);
// if(responseText && responseText.data) {
							var masterData = responseText[0];
							if(masterData != null && masterData.EX_DATE && masterData.EX_DATE != '' ) {
								Unilite.messageBox('<t:message code="system.message.sales.datacheck010" default="이미 기표된 자료입니다."/>');
								UniAppManager.app.onQueryButtonDown();
								return ;
							}
							var params = {
								'PGM_ID'		: 'sco110ukrv',
								'sGubun'		: '31',
								'DIV_CODE'		: panelResult.getValue("DIV_CODE"),
								'COLL_DATE'		: UniDate.getDateStr(panelResult.getValue("COLL_DATE")),
								'CUSTOM_CODE'	: panelResult.getValue("COLL_CUSTOM_CODE"),	//20210420 수정: CUSTOM_CODE -> COLL_CUSTOM_CODE
								'COLLECT_NUM'	: panelResult.getValue("COLL_NUM")
							}
							var rec = {data : {prgID : 'agj260ukr', 'text':''}};
							parent.openTab(rec, '/accnt/agj260ukr.do', params, CHOST+CPATH);
// }
						});
					} else {
						Unilite.messageBox('<t:message code="system.message.sales.datacheck011" default="수금번호가 없습니다. 조회 후 실행하세요."/>')
					}
				}
			},{
				xtype	: 'button',
				text	: '<t:message code="system.label.sales.slipcancel" default="기표취소"/>',
				itemId	: 'btnCancel',
				width	: 80,
				handler	 :function() {
					var param = panelResult.getValues();
					param.BASIS_NUM = param.COLL_NUM;
					
					sco110ukrvService.selectCollectNumMasterList(param,function(responseText, response) {
						console.log("responseText : ",responseText);
						console.log("response : ",response);
						if(responseText ) {
							var masterData = responseText[0];
							if(masterData != null && (Ext.isEmpty(masterData.EX_DATE) || masterData.EX_DATE == 0 ) ) {
								Unilite.messageBox('<t:message code="system.message.sales.message076" default="먼저 자료를 조회하십시요."/>');
								return ;
							}
							
							var param = {
								'DIV_CODE'		: panelResult.getValue("DIV_CODE"),
								'COLL_DATE'		: UniDate.getDateStr(panelResult.getValue("COLL_DATE")),
								'CUSTOM_CODE'	: panelResult.getValue("CUSTOM_CODE"),
								'COLLECT_NUM'	: panelResult.getValue("COLL_NUM")
							}
							agj260ukrService.cancelAutoSlip31(param,function(responseText, response) {
								if(!Ext.isEmpty(responseText.ERROR_DESC) ) {
									if(responseText.EBYN_MESSAGE=="FALSE") {
										console.log(responseText.ERROR_DESC);
									}
								}else {
									Unilite.messageBox('<t:message code="system.message.sales.datacheck012" default="기표 취소되었습니다."/>');
									UniAppManager.app.onQueryButtonDown();
								}
							});
						} else {
							Unilite.messageBox('<t:message code="system.message.sales.datacheck013" default="등록된 전표가 없습니다."/>');
						}
					});
				}
			}]
		},{
			fieldLabel	: '<t:message code="system.label.sales.referencepath" default="참조경로"/>',
			name		: 'REF_LOC',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S114',
			value		: '1',
			allowBlank	: false,
			holdable	: 'hold',
			hidden		: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts){
					panelSearch.setValue('REF_LOC', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.collectionplace" default="수금처"/>',
			valueFieldName	: 'COLL_CUSTOM_CODE',
			textFieldName	: 'COLL_CUSTOM_NAME',
			holdable		: 'hold',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('COLL_CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('COLL_CUSTOM_NAME', '');
						panelResult.setValue('COLL_CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('COLL_CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('COLL_CUSTOM_CODE', '');
						panelResult.setValue('COLL_CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.collectioncharge" default="수금담당"/>',
			name		: 'COLL_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			allowBlank	: false,
			holdable	: 'hold',
			colspan		: 2,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners:{
				change: function(combo, newValue, oldValue, eOpts) {
					var saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(newValue);	// 영업담당의 사업장코드 가져오기
					panelSearch.setValue('COLL_DIV_CODE', saleDivCode);
					panelResult.setValue('COLL_DIV_CODE', saleDivCode);
					panelSearch.setValue('COLL_PRSN', panelResult.getValue('COLL_PRSN'));
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.currency" default="화폐"/>',
			name		: 'MONEY_UNIT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B004',
			allowBlank	: false,
			holdable	: 'hold',
			displayField: 'value',
			fieldStyle	: 'text-align: center;',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts){
					panelSearch.setValue('MONEY_UNIT', newValue);
					//UniAppManager.app.fnExchngRateO();
					if(orderFlag != "1"){	// 폼수정or검색창에서 더블클릭 set 둘다change를 타므로 플레그값으로 처리를 해줌(검색창에서 넘어올경우 미수잔액,선수금잔액 가져올 필요 없다.)
						UniAppManager.app.fnCallGetRemainder('MONEY_UNIT', newValue)	// 미수잔액, 선수금잔액 구하기
					};
					if(newValue != BsaCodeInfo.gsMoneyUnit){
						var length = Ext.isEmpty(UniFormat.FC.split('.')[1]) ? 0 : UniFormat.FC.split('.')[1].length;
//						panelResult.setValue('NATION_INOUT','2');
						Ext.getCmp('REMAIN_UNCOLL').setConfig('decimalPrecision',length);
						Ext.getCmp('REMAIN_UNCOLL').focus();
						Ext.getCmp('REMAIN_UNCOLL').blur();
						Ext.getCmp('REMAIN_ADV').setConfig('decimalPrecision',length);
						Ext.getCmp('REMAIN_ADV').focus();
						Ext.getCmp('REMAIN_ADV').blur();
						Ext.getCmp('TOTAL_FOR_AMT').setConfig('decimalPrecision',length);
						Ext.getCmp('TOTAL_FOR_AMT').focus();
						Ext.getCmp('TOTAL_FOR_AMT').blur();
						detailGrid.getColumn("COLLECT_FOR_AMT").setConfig('format',UniFormat.FC);
						detailGrid.getColumn("COLLECT_FOR_AMT").setConfig('decimalPrecision',length);
					} else {
						var length = Ext.isEmpty(UniFormat.Price.split('.')[1]) ? 0 : UniFormat.Price.split('.')[1].length;
//						panelResult.setValue('NATION_INOUT','1');
						Ext.getCmp('REMAIN_UNCOLL').setConfig('decimalPrecision',length);
						Ext.getCmp('REMAIN_UNCOLL').focus();
						Ext.getCmp('REMAIN_UNCOLL').blur();
						Ext.getCmp('REMAIN_ADV').setConfig('decimalPrecision',length);
						Ext.getCmp('REMAIN_ADV').focus();
						Ext.getCmp('REMAIN_ADV').blur();
						Ext.getCmp('TOTAL_FOR_AMT').setConfig('decimalPrecision',length);
						Ext.getCmp('TOTAL_FOR_AMT').focus();
						Ext.getCmp('TOTAL_FOR_AMT').blur();
						detailGrid.getColumn("COLLECT_FOR_AMT").setConfig('format',UniFormat.Price);
						detailGrid.getColumn("COLLECT_FOR_AMT").setConfig('decimalPrecision',length);
					}
				},
				blur: function( field, The, eOpts ) {
					UniAppManager.app.fnExchngRateO();
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.exchangerate" default="환율"/>',
			name		: 'EXCHG_RATE',
			xtype		: 'uniNumberfield',
			allowBlank	: false,
			holdable	: 'hold',
			decimalPrecision: 4,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts){
					panelSearch.setValue('EXCHG_RATE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.collectionno" default="수금번호"/>',
			name		: 'COLL_NUM',
			xtype		: 'uniTextfield',
			allowBlank	: AutoType,
			holdable	: 'hold',
			colspan		: 2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts){
					panelSearch.setValue('COLL_NUM', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.collectiondivision" default="수금사업장"/>',
			name		: 'COLL_DIV_CODE',
			comboType	: 'BOR120',
			xtype		: 'uniCombobox',
			readOnly	: true,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts){
					panelSearch.setValue('COLL_DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.slipdate" default="전표일"/>',
			xtype		: 'uniDatefield',
			name		: 'EX_DATE',
			holdable	: 'hold',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts){
					panelSearch.setValue('EX_DATE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.slipno" default="전표번호"/>',
			name		: 'EX_NUM',
			xtype		: 'uniTextfield',
			readOnly	: true,
			holdable	: 'hold',
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts){
					panelSearch.setValue('EX_NUM', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.arbalance" default="미수잔액"/>',
			name		: 'REMAIN_UNCOLL',
			id			: 'REMAIN_UNCOLL',
			xtype		: 'uniNumberfield',
			holdable	: 'hold'
		},{
			fieldLabel	: '<t:message code="system.label.sales.advancebalance" default="선수금잔액"/>',
			name		: 'REMAIN_ADV',
			id			: 'REMAIN_ADV',
			xtype		: 'uniNumberfield',
			holdable	: 'hold'
		},{
			fieldLabel	: '<t:message code="system.label.sales.collectiontotalamount" default="수금총액"/>',
			name		: 'TOTAL_FOR_AMT',
			id			: 'TOTAL_FOR_AMT',
			xtype		: 'uniNumberfield',
			holdable	: 'hold',
			colspan		: 2
		},{
			fieldLabel	: '<t:message code="system.label.sales.exchangecollectiontotamt" default="환산수금총액"/>',
			name		: 'TOTAL_AMT',
			xtype		: 'uniNumberfield',
			holdable	: 'hold',
			hidden		: true
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					// this.mask();
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
				// this.unmask();
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



	/** 수주의 디테일 정보를 가지고 있는 Grid
	*/
	Unilite.defineModel('sco110ukrvDetailModel', {
		fields: [
			{name: 'COLLECT_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'							, type: 'int', allowBlank: false},
			// 20210319 카드사 추가
			{name: 'COLLECT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.cardcustomnme" default="카드사"/>'					, type: 'string', comboType: 'AU', comboCode: 'A028'},
			{name: 'CARD_CUSTOM_CODE'		,text: '<t:message code="system.label.sales.cardpurchase" default="카드매입사"/>'				, type: 'string', comboType: 'AU', comboCode: 'A028', editable: false},
			{name: 'PUB_NUM'				,text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'						, type: 'string'},
			{name: 'SALE_LOC_AMT_I'			,text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'					, type: 'uniFC', defaultValue: 0},
			{name: 'TAX_AMT_O'				,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'						, type: 'uniPrice', defaultValue: 0},
			{name: 'TOT_SALE_AMT'			,text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'					, type: 'uniFC', defaultValue: 0},
			{name: 'UN_COLL_AMT'			,text: '<t:message code="system.label.sales.arbalance" default="미수잔액"/>'					, type: 'uniFC', defaultValue: 0},
			{name: 'COLLECT_TYPE'			,text: '<t:message code="system.label.sales.collectiontype" default="수금유형"/>'				, type: 'string', comboType: 'AU', comboCode: 'S017', allowBlank: false},
			//20190722 수금액, 환산액 필수 제외 후, 수금유형이 "선수금 - 반제"가 아닐 경우 수동으로 체크하도록 변경
			{name: 'COLLECT_FOR_AMT'		,text: '<t:message code="system.label.sales.collectionamount" default="수금액"/>'				, type: 'uniFC', defaultValue: 0/*, allowBlank: false*/},
			{name: 'COLLECT_AMT'			,text: '<t:message code="system.label.sales.exchangeamount" default="환산액"/>'				, type: 'uniPrice', defaultValue: 0/*, allowBlank: false*/},
			{name: 'REPAY_AMT'				,text: '<t:message code="system.label.sales.advancedrefundamountfor" default="선수반제액(외화)"/>'	, type: 'uniFC', defaultValue: 0},
			{name: 'REPAY_AMT_WON'			,text: '<t:message code="system.label.sales.advancedrefundamountkor" default="선수반제액(원화)"/>'	, type: 'uniPrice', defaultValue: 0},
			{name: 'MONEY_UNIT'				,text: '<t:message code="system.label.sales.currency" default="화폐"/>'						, type: 'string', defaultValue: BsaCodeInfo.gsMoneyUnit, allowBlank: false, displayField: 'value'},
			{name: 'EXCHANGE_RATE'			,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'					, type: 'uniER', allowBlank: false, defaultValue: 1},
			{name: 'NOTE_NUM'				,text: '<t:message code="system.label.sales.noteno" default="어음번호"/>'						, type: 'string'},
			{name: 'NOTE_CREDIT_RATE'		,text: '<t:message code="system.label.sales.authorizedrate" default="인정율(%)"/>'				, type: 'uniPercent', defaultValue: 0},
			{name: 'NOTE_TYPE'				,text: '<t:message code="system.label.sales.noteclass" default="어음구분"/>'					, type: 'string', comboType: 'AU', comboCode: 'B064'},
			{name: 'PUB_CUST_CD'			,text: '<t:message code="system.label.sales.publishofficecode" default="발행기관CD"/>'			, type: 'string'},
			{name: 'PUB_CUST_NM'			,text: '<t:message code="system.label.sales.publishoffice" default="발행기관"/>'				, type: 'string'},
			{name: 'NOTE_PUB_DATE'			,text: '<t:message code="system.label.sales.publishdate" default="발행일"/>'					, type: 'uniDate'},
			{name: 'PUB_PRSN'				,text: '<t:message code="system.label.sales.publisher" default="발행인"/>'						, type: 'string'},
			{name: 'NOTE_DUE_DATE'			,text: '<t:message code="system.label.sales.duedate" default="만기일"/>'						, type: 'uniDate'},
			{name: 'PUB_ENDOSER'			,text: '<t:message code="system.label.sales.endorser" default="배서인"/>'						, type: 'string'},
			{name: 'DISHONOR_DATE'			,text: '<t:message code="system.label.sales.dishonoreddate" default="부도일"/>'				, type: 'uniDate'},
			{name: 'PROJECT_NO'				,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'					, type: 'string'},
			{name: 'PJT_CODE'				,text: '<t:message code="system.label.sales.project" default="프로젝트"/>'						, type: 'string'},
			{name: 'PJT_NAME'				,text: '<t:message code="system.label.sales.projectname" default="프로젝트명"/>'					, type: 'string'},
			{name: 'SAVE_CODE'				,text: '<t:message code="system.label.sales.bankaccountno" default="통장번호"/>'				, type: 'string'},
			{name: 'SAVE_NAME'				,text: '<t:message code="system.label.sales.bankaccountname" default="통장명"/>'				, type: 'string'},
			{name: 'REF_MONEY_UNIT'			,text: '<t:message code="system.label.sales.referencecurrency" default="참조화폐"/>'			, type: 'string'},
			{name: 'REF_EXCHANGE_RATE'		,text: '<t:message code="system.label.sales.referenceexchange" default="참조환율"/>'			, type: 'uniER', defaultValue: 1},
			{name: 'REMARK'					,text: '<t:message code="system.label.sales.remarks" default="비고"/>'						, type: 'string'},
			{name: 'BILL_DIV_CODE'			,text: 'BILL_DIV_CODE'		, type: 'string',comboType: 'BOR120' },
			{name: 'DIV_CODE'				,text: 'DIV_CODE'			, type: 'string', allowBlank: false},
			{name: 'CUSTOM_CODE'			,text: 'CUSTOM_CODE'		, type: 'string', allowBlank: false},
			{name: 'COLLECT_DATE'			,text: 'COLLECT_DATE'		, type: 'uniDate', allowBlank: false},
			{name: 'COLET_CUST_CD'			,text: 'COLET_CUST_CD'		, type: 'string'},
			{name: 'COLLECT_PRSN'			,text: 'COLLECT_PRSN'		, type: 'string'},
			{name: 'COLLECT_DIV'			,text: 'COLLECT_DIV'		, type: 'string', allowBlank: false},
			{name: 'COLLECT_NUM'			,text: 'COLLECT_NUM'		, type: 'string', allowBlank: AutoType},
			{name: 'UPDATE_DB_USER'			,text: 'UPDATE_DB_USER'		, type: 'string', defaultValue: UserInfo.userID},
			{name: 'UPDATE_DB_TIME'			,text: 'UPDATE_DB_TIME'		, type: 'string'},
			{name: 'DEPT_CODE'				,text: 'DEPT_CODE'			, type: 'string'},
			{name: 'TREE_NAME'				,text: 'TREE_NAME'			, type: 'string', defaultValue: '*'},
			{name: 'SALE_PROFIT'			,text: 'SALE_PROFIT'		, type: 'string', defaultValue: '*', allowBlank: false},
			{name: 'EX_DATE'				,text: 'EX_DATE'			, type: 'uniDate'},
			{name: 'EX_NUM'					,text: 'EX_NUM'				, type: 'int'},
			{name: 'EX_SEQ'					,text: 'EX_SEQ'				, type: 'int'},
			{name: 'AGREE_YN'				,text: 'AGREE_YN'			, type: 'string'},
			{name: 'AC_DATE'				,text: 'AC_DATE'			, type: 'uniDate'},
			{name: 'AC_NUM'					,text: 'AC_NUM'				, type: 'int'},
			{name: 'UN_PRE_COLL_AMT'		,text: 'UN_PRE_COLL_AMT'	, type: 'uniPrice'},
			{name: 'TOTAL_AMT'				,text: 'TOTAL_AMT'			, type: 'uniPrice'},
			{name: 'TOTAL_FOR_AMT'			,text: 'TOTAL_FOR_AMT'		, type: 'uniPrice'},
			{name: 'CUSTOM_NAME'			,text: 'CUSTOM_NAME'		, type: 'string'},
			{name: 'COLET_CUST_NM'			,text: 'COLET_CUST_NM'		, type: 'string'},
			{name: 'REFER_COLLECT_AMT'		,text: 'REFER_COLLECT_AMT'	, type: 'uniPrice'},
			{name: 'REFER_REPAY_AMT'		,text: 'REFER_REPAY_AMT'	, type: 'uniPrice'},
			{name: 'REFER_REPAY_AMT_WON'	,text: 'REFER_REPAY_AMT_WON', type: 'uniPrice'},
			{name: 'REFER_UN_COLL_AMT'		,text: 'REFER_UN_COLL_AMT'	, type: 'uniPrice'},
			{name: 'REF_UN_COLL_AMT'		,text: 'REF_UN_COLL_AMT'	, type: 'uniPrice'},
			{name: 'REF_CODE1'				,text: '<t:message code="system.label.sales.maincollectiontype" default="주수금유형"/>'		, type: 'string'},
			{name: 'BILL_DATE'				,text: '<t:message code="system.label.sales.billissuedate" default="계산서발행일"/>'			, type: 'uniDate'},
			{name: 'COMP_CODE'				,text: 'COMP_CODE'			, type: 'string', defaultValue: UserInfo.compCode, allowBlank: false},
			{name: 'CARD_ACC_NUM'			,text: '<t:message code="system.label.sales.cardapproveno" default="카드승인번호"/>'			, type: 'string'},
			{name: 'RECEIPT_NAME'			,text: '<t:message code="system.label.sales.depositperson" default="입금자"/>'				, type: 'string'},
			{name: 'BR_IN_NUM'				,text: 'BR_IN_NUM'			, type: 'string'},
			{name: 'ACCT_NO'				,text: 'ACCT_NO'			, type: 'string'},
			{name: 'CURR_UNIT'				,text: 'CURR_UNIT'			, type: 'string'},
			{name: 'ACCT_TXDAY'				,text: 'ACCT_TXDAY'			, type: 'uniDate'},
			{name: 'ACCT_TXDAY_SEQ'			,text: 'ACCT_TXDAY_SEQ'		, type: 'int'},
			{name: 'BANK_CD'				,text: 'BANK_CD'			, type: 'string'},
			{name: 'REF_AMT_LOC'			,text: '<t:message code="system.label.sales.referencechangeamount" default="참조환산금액"/>'	, type: 'uniPrice', defaultValue: 0},
			{name: 'RECEIPT_PLAN_DATE'		,text: '<t:message code="system.label.sales.collectionschdate" default="수금예정일"/>'		, type: 'uniDate'},
			{name: 'REF_LOC'				,text: '<t:message code="system.label.sales.referencepath" default="참조경로"/>'			, type: 'string', comboType: 'AU', comboCode: 'S114'},
			{name: 'BILL_NUM'				,text: 'BILL_NUM'			, type: 'string'}
		]
	});
	// 마스터 스토어 정의
	var detailStore = Unilite.createStore('sco110ukrvDetailStore', {
		model	: 'sco110ukrvDetailModel',
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
				this.fnMasterSet();
				setTimeout(UniAppManager.app.fnExSlipBtn(), 10);
// this.fnOrderAmtSum();
			},
			add: function(store, records, index, eOpts) {
				sCollType = UniAppManager.app.fnGetSubCode(records[0].get('COLLECT_TYPE'));
				this.fnOrderAmtSum(sCollType);
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				sCollType = UniAppManager.app.fnGetSubCode(record.get('COLLECT_TYPE'));
				this.fnOrderAmtSum(sCollType);
			},
			remove: function(store, record, index, isMove, eOpts) {
// sCollType = UniAppManager.app.fnGetSubCode(record.get('COLLECT_TYPE'));
				this.fnOrderAmtSum();
			}
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
//			var list = [].concat(toUpdate, toCreate);
			var list = this.data.items;
			console.log("list:", list);
			var isErr = false;
			Ext.each(list, function(record, index) {
				if(!UniAppManager.app.fnIsOccupied(record, index + 1)){
					isErr = true;
					return false;
				}
			})
			if(isErr) return false;
// console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ",
// this.data.filterBy(this.filterInvalidNewRecords));

			// 1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	// syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						// 2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						panelSearch.setValue("COLL_NUM", master.COLL_NUM);
						panelResult.setValue("COLL_NUM", master.COLL_NUM);

						// 3.기타 처리
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.app.fnExSlipBtn();
						if(detailStore.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		fnMasterSet: function() {
			if(this.getCount() < 1) return false;
			panelSearch.setValues({
				'EX_DATE'		:this.getAt(0).get('EX_DATE'),	// 전표일
				'EX_NUM'		:this.getAt(0).get('EX_NUM'),		// 전표번호
				'REMAIN_UNCOLL'	:Ext.isNumeric(this.getAt(0).get('REF_UN_COLL_AMT')) ? this.getAt(0).get('REF_UN_COLL_AMT'):0,// 미수잔액
				'REMAIN_ADV'	:Ext.isNumeric(this.getAt(0).get('UN_PRE_COLL_AMT')) ? this.getAt(0).get('UN_PRE_COLL_AMT'):0,// 선수금잔액
				'TOTAL_FOR_AMT'	:Ext.isNumeric(this.getAt(0).get('TOTAL_FOR_AMT'))   ? this.getAt(0).get('TOTAL_FOR_AMT'):0,// 수금총액
				'TOTAL_AMT'		:Ext.isNumeric(this.getAt(0).get('TOTAL_AMT'))   ? this.getAt(0).get('TOTAL_AMT'):0,// 환산수금총액
				'EXCHG_RATE'	:Ext.isNumeric(this.getAt(0).get('EXCHANGE_RATE'))   ? this.getAt(0).get('EXCHANGE_RATE'):0// 환율
			});
			panelResult.setValues({
				'EX_DATE'		:this.getAt(0).get('EX_DATE'),   // 전표일
				'EX_NUM'		:this.getAt(0).get('EX_NUM'),	// 전표번호
				'REMAIN_UNCOLL'	:Ext.isNumeric(this.getAt(0).get('REF_UN_COLL_AMT')) ? this.getAt(0).get('REF_UN_COLL_AMT'):0,// 미수잔액
				'REMAIN_ADV'	:Ext.isNumeric(this.getAt(0).get('UN_PRE_COLL_AMT')) ? this.getAt(0).get('UN_PRE_COLL_AMT'):0,// 선수금잔액
				'TOTAL_FOR_AMT'	:Ext.isNumeric(this.getAt(0).get('TOTAL_FOR_AMT'))   ? this.getAt(0).get('TOTAL_FOR_AMT'):0,// 수금총액
				'TOTAL_AMT'		:Ext.isNumeric(this.getAt(0).get('TOTAL_AMT'))   ? this.getAt(0).get('TOTAL_AMT'):0,// 환산수금총액
				'EXCHG_RATE'	:Ext.isNumeric(this.getAt(0).get('EXCHANGE_RATE'))   ? this.getAt(0).get('EXCHANGE_RATE'):0// 환율
			});
			gvRemainderAmt1 = this.getAt(0).get('REF_UN_COLL_AMT')// 미수금
			gvRemainderAmt2  = this.getAt(0).get('UN_PRE_COLL_AMT')// 선수금
		},
		fnOrderAmtSum: function(sCollType) {
			var dCollAmt = 0;
			var dRepayAmt = 0;
			var dTotCollAmt = 0;
			var dTotRepayAmt = 0;
			var dOldTotCollAmt = 0;
			var dOldTotRepayAmt = 0;
			var dRemainderRepayAmt = 0;

			dTotCollAmt = Ext.isNumeric(this.sum('COLLECT_FOR_AMT')) 	? this.sum('COLLECT_FOR_AMT'):0;	// 수금총액(외화) 합계
			dOldTotCollAmt = Ext.isNumeric(this.sum('REFER_COLLECT_AMT')) ? this.sum('REFER_COLLECT_AMT'):0;

			if(sCollType == "80"){
				dTotRepayAmt = 	Ext.isNumeric(this.sum('REPAY_AMT')) ? this.sum('REPAY_AMT'):0;
				dOldTotRepayAmt = Ext.isNumeric(this.sum('REFER_REPAY_AMT')) ? this.sum('REFER_REPAY_AMT'):0;
			}
			panelSearch.setValue('TOTAL_FOR_AMT', dTotCollAmt);	// 수금총액
			panelResult.setValue('TOTAL_FOR_AMT', dTotCollAmt);	// 수금총액

// dRemainderCollAmt = detailStore.getCount() > 0 ?
// detailStore.getAt(0).get('REF_UN_COLL_AMT') : 0;
			dRemainderCollAmt = gvRemainderAmt1			// 미수잔액
			panelSearch.setValue('REMAIN_UNCOLL', dRemainderCollAmt + dOldTotCollAmt - dTotCollAmt);
			panelResult.setValue('REMAIN_UNCOLL', dRemainderCollAmt + dOldTotCollAmt - dTotCollAmt);

// dRemainderRepayAmt = detailStore.getCount() > 0
// ?detailStore.getAt(0).get('UN_PRE_COLL_AMT') : 0;
			dRemainderRepayAmt = gvRemainderAmt2 		// 선수금잔액
			panelSearch.setValue('REMAIN_ADV', dRemainderRepayAmt + dOldTotRepayAmt - dTotRepayAmt);
			panelResult.setValue('REMAIN_ADV', dRemainderRepayAmt + dOldTotRepayAmt - dTotRepayAmt);
/* 확장용 */
// var dCollAmt = 0;
// var dRepayAmt = 0;
// var dCollForAmt = 0;
// var dTotCollAmt = 0;
// var dTotRepayAmt = 0;
// var dTotCollForAmt = 0;
// var dOldTotCollAmt = 0;
// var dOldTotRepayAmt = 0;
// var dOldTotCollForAmt = 0;
// var dRemainderCollAmt = 0;
// var dRemainderRepayAmt = 0;
//
// dTotCollForAmt = Ext.isNumeric(this.sum('COLLECT_AMT')) ?
// this.sum('COLLECT_AMT'):0;
// dOldTotCollForAmt = Ext.isNumeric(this.sum('REFER_COLLECT_AMT')) ?
// this.sum('REFER_COLLECT_AMT'):0;
// // dTotCollAmt = Ext.isNumeric(this.sum('COLLECT_AMT')) ?
// this.sum('COLLECT_AMT'):0;
// dOldTotCollAmt = Ext.isNumeric(this.sum('REFER_COLLECT_AMT')) ?
// this.sum('REFER_COLLECT_AMT'):0;
//
// if(sCollType == "80"){
// dTotRepayAmt = Ext.isNumeric(this.sum('REPAY_AMT')) ?
// this.sum('REPAY_AMT'):0;
// dOldTotRepayAmt = Ext.isNumeric(this.sum('REFER_REPAY_AMT')) ?
// this.sum('REFER_REPAY_AMT'):0;
// }
//
// // if(panelSearch.getValue('MONEY_UNIT') == "KRW"){
// panelSearch.setValue('TOTAL_FOR_AMT', dTotCollForAmt); //수금총액
// // }
// panelSearch.setValue('TOTAL_AMT', dTotCollAmt); //환산수금 총액
//
// dRemainderCollAmt = panelSearch.getValue('REMAIN_UNCOLL');
// panelSearch.setValue('REMAIN_UNCOLL', dRemainderCollAmt + dOldTotCollForAmt -
// dTotCollForAmt); //미수잔액 set
//
// dRemainderRepayAmt = panelSearch.getValue('REMAIN_ADV');
// panelSearch.setValue('REMAIN_ADV', dRemainderRepayAmt + dOldTotRepayAmt -
// dTotRepayAmt); //미수잔액 set
		}
	});
	// 마스터 그리드 정의
	var detailGrid = Unilite.createGrid('sco110ukrvGrid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
			copiedRow: true
		},
		tbar: [/*
				* { itemId : '',iconCls : 'icon-referance' ,
				* text:'<t:message code="system.label.sales.salesreference" default="매출참조"/>', handler: function() {
				* openReferSalesWindow(); } },
				*/ {
		/* itemId : '', */
			text:'<div style="color: blue"><t:message code="system.label.sales.arreference" default="미수금참조"/></div>',
			handler: function() {
				openReferWindow();
			}
		}],
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal',	ftype: 'uniSummary',	showSummaryRow: true} ],
		store: detailStore,
		columns: [
			{ dataIndex: 'COLLECT_SEQ'				, width: 70,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex: 'CARD_CUSTOM_CODE'			, width: 100, hidden: true},
			{ dataIndex: 'PUB_NUM'					, width: 100},
			{ dataIndex: 'SALE_LOC_AMT_I'			, width: 103, summaryType: 'sum'},
			{ dataIndex: 'TAX_AMT_O'				, width: 80, summaryType: 'sum'},
			{ dataIndex: 'TOT_SALE_AMT'				, width: 106, summaryType: 'sum'},
			{ dataIndex: 'UN_COLL_AMT'				, width: 106, summaryType: 'sum'},
			{ dataIndex: 'COLLECT_TYPE'				, width: 150},
			{ dataIndex: 'COLLECT_FOR_AMT'			, width: 100, summaryType: 'sum'/* ,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(panelSearch.getValue('MONEY_UNIT') != 'KRW') {
						return Ext.util.Format.number(val,'0,000,000.0000');
					}
				}   */
			},	// 확장용
			{ dataIndex: 'COLLECT_AMT'				, width: 106, summaryType: 'sum'},
			{ dataIndex: 'REPAY_AMT'				, width: 120, summaryType: 'sum'},	// 확장용
			{ dataIndex: 'REPAY_AMT_WON'			, width: 120 , summaryType: 'sum'},
			// 20210319 카드사 추가
			{ dataIndex: 'COLLECT_TYPE_DETAIL'		, width: 100},
			{ dataIndex: 'MONEY_UNIT'				, width: 66 , hidden: true, align: 'center'},	// 확장용
			{ dataIndex: 'EXCHANGE_RATE'			, width: 100, hidden: true},	// 확장용
			{ dataIndex: 'NOTE_NUM'					, width: 66 },
			{ dataIndex: 'NOTE_CREDIT_RATE'			, width: 106},
			{ dataIndex: 'NOTE_TYPE'				, width: 106},
			{ dataIndex: 'PUB_CUST_CD'				, width: 73, hidden: true },
			//{ dataIndex: 'PUB_CUST_NM' , width: 66 },
			{ dataIndex:'PUB_CUST_NM',  width: 100	,
				'editor' :Unilite.popup('BANK_G',	{
					autoPopup: true,
					listeners: {
						'onSelected': function(records, type  ){
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('PUB_CUST_CD',records[0]['BANK_CODE']);
							grdRecord.set('PUB_CUST_NM',records[0]['BANK_NAME']);
						},
						'onClear':  function( type  ){
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('PUB_CUST_CD','');
							grdRecord.set('PUB_CUST_NM','');
						}
					} // listeners
				})
			},
			{ dataIndex: 'NOTE_PUB_DATE'			, width: 106},
			{ dataIndex: 'PUB_PRSN'					, width: 73 },
			{ dataIndex: 'NOTE_DUE_DATE'			, width: 106},
			{ dataIndex: 'PUB_ENDOSER'				, width: 73 },
			{ dataIndex: 'DISHONOR_DATE'			, width: 106, hidden: true},
			{ dataIndex: 'PROJECT_NO'				, width: 100},
			{ dataIndex: 'PJT_CODE'					, width: 100, hidden: true},
			{ dataIndex: 'PJT_NAME'					, width: 106, hidden: true},
			{ dataIndex: 'SAVE_CODE'				, width: 106,
				editor: Unilite.popup('BANK_BOOK_G', {
					textFieldName: 'BANK_BOOK_CODE',
					DBtextFieldName: 'BANK_BOOK_CODE',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								Ext.each(records, function(record,i) {
									if(i==0) {
										var grdRecord = detailGrid.getSelectedRecord();
										grdRecord.set('SAVE_CODE', record['BANK_BOOK_CODE']);
										grdRecord.set('SAVE_NAME', record['BANK_BOOK_NAME']);
										grdRecord.set('PUB_CUST_CD', record['BANK_CD']);
										grdRecord.set('PUB_CUST_NM', record['BANK_NM']);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = detailGrid.getSelectedRecord();
							grdRecord.set('SAVE_CODE', '');
							grdRecord.set('SAVE_NAME', '');
						},
						applyextparam: function(popup){
						}
					}
				})
			},
			{ dataIndex: 'SAVE_NAME'			, width: 106, hidden: false,
				editor: Unilite.popup('BANK_BOOK_G', {
					textFieldName: 'BANK_BOOK_NAME',
					DBtextFieldName: 'BANK_BOOK_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								Ext.each(records, function(record,i) {
								if(i==0) {
									var grdRecord = detailGrid.getSelectedRecord();
									grdRecord.set('SAVE_CODE', record['BANK_BOOK_CODE']);
									grdRecord.set('SAVE_NAME', record['BANK_BOOK_NAME']);
									grdRecord.set('PUB_CUST_CD', record['BANK_CD']);
									grdRecord.set('PUB_CUST_NM', record['BANK_NM']);
								}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = detailGrid.getSelectedRecord();
							grdRecord.set('SAVE_CODE', '');
							grdRecord.set('SAVE_NAME', '');
						},
						applyextparam: function(popup){
						}
					}
				})
			},
			{ dataIndex: 'REF_MONEY_UNIT'		, width: 66, hidden: true },
			{ dataIndex: 'REF_EXCHANGE_RATE'	, width: 166, hidden: true},
			{ dataIndex: 'REMARK'				, width: 100 },
			{ dataIndex: 'BILL_DIV_CODE'		, width: 66, hidden: true },
			{ dataIndex: 'DIV_CODE'				, width: 66, hidden: true },
			{ dataIndex: 'CUSTOM_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'COLLECT_DATE'			, width: 66, hidden: true },
			{ dataIndex: 'COLET_CUST_CD'		, width: 66, hidden: true },
			{ dataIndex: 'COLLECT_PRSN'			, width: 66, hidden: true },
			{ dataIndex: 'COLLECT_DIV'			, width: 66, hidden: true },
			{ dataIndex: 'COLLECT_NUM'			, width: 66, hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'		, width: 66, hidden: true },
			{ dataIndex: 'UPDATE_DB_TIME'		, width: 66, hidden: true },
			{ dataIndex: 'DEPT_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'TREE_NAME'			, width: 66, hidden: true },
			{ dataIndex: 'SALE_PROFIT'			, width: 66, hidden: true },
			{ dataIndex: 'EX_DATE'				, width: 66, hidden: true },
			{ dataIndex: 'EX_NUM'				, width: 66, hidden: true },
			{ dataIndex: 'EX_SEQ'				, width: 66, hidden: true },
			{ dataIndex: 'AGREE_YN'				, width: 66, hidden: true },
			{ dataIndex: 'AC_DATE'				, width: 66, hidden: true },
			{ dataIndex: 'AC_NUM'				, width: 66, hidden: true },
			{ dataIndex: 'UN_PRE_COLL_AMT'		, width: 66, hidden: true},
			{ dataIndex: 'TOTAL_AMT'			, width: 66, hidden: true},
			{ dataIndex: 'TOTAL_FOR_AMT'		, width: 66, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'			, width: 66, hidden: true },
			{ dataIndex: 'COLET_CUST_NM'		, width: 66, hidden: true },
			{ dataIndex: 'REFER_COLLECT_AMT'	, width: 66, hidden: true },
			{ dataIndex: 'REFER_REPAY_AMT'		, width: 66, hidden: true},
			{ dataIndex: 'REFER_REPAY_AMT_WON'	, width: 66, hidden: true },
			{ dataIndex: 'REFER_UN_COLL_AMT'	, width: 66, hidden: true },
			{ dataIndex: 'REF_UN_COLL_AMT'		, width: 66, hidden: true},
			{ dataIndex: 'REF_CODE1'			, width: 66, hidden: true },
			{ dataIndex: 'BILL_DATE'			, width: 66, hidden: true },
			{ dataIndex: 'COMP_CODE'			, width: 120, hidden: true},
			{ dataIndex: 'CARD_ACC_NUM'			, width: 100},
			{ dataIndex: 'RECEIPT_NAME'			, width: 133},
			{ dataIndex: 'BR_IN_NUM'			, width: 100, hidden: true},
			{ dataIndex: 'ACCT_NO'				, width: 86, hidden: true },
			{ dataIndex: 'CURR_UNIT'			, width: 100, hidden: true},
			{ dataIndex: 'ACCT_TXDAY'			, width: 100, hidden: true},
			{ dataIndex: 'ACCT_TXDAY_SEQ'		, width: 100, hidden: true},
			{ dataIndex: 'BANK_CD'				, width: 100, hidden: true},
			{ dataIndex: 'REF_AMT_LOC'			, width: 100, hidden: true},
			{ dataIndex: 'RECEIPT_PLAN_DATE'	, width: 100, hidden: true},
			{ dataIndex: 'REF_LOC'				, width: 66, hidden: true},
			{ dataIndex: 'BILL_NUM'				, width: 250, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				var gsRegistYN = BsaCodeInfo.editableYN[0].REGIST_YN;	// 권한등록 여부
				var gsModifyYN = BsaCodeInfo.editableYN[0].MODIFY_YN;	// 수정/삭제 여부
				var gsPCode = BsaCodeInfo.gsPLCode[0].P_CODE;			// 환차익
				var gsLCode = BsaCodeInfo.gsPLCode[0].L_CODE;			// 환차손
				var sCollType = e.record.data.REF_CODE1;
				if(gsRegistYN == "Y" && gsModifyYN == "N"){
					if (UniUtils.indexOf(e.field, ['COLLECT_SEQ', 'PUB_NUM', 'SALE_LOC_AMT_I', 'TAX_AMT_O', 'TOT_SALE_AMT', 'UN_COLL_AMT', 'COLLECT_TYPE'
												, 'COLLECT_FOR_AMT', 'COLLECT_AMT', 'REPAY_AMT', 'REPAY_AMT_WON', 'MONEY_UNIT', 'EXCHANGE_RATE', 'NOTE_NUM'
												, 'NOTE_CREDIT_RATE', 'NOTE_TYPE', 'PUB_CUST_CD', 'PUB_CUST_NM', 'NOTE_PUB_DATE', 'PUB_PRSN', 'NOTE_DUE_DATE'
												, 'PUB_ENDOSER', 'DISHONOR_DATE', 'PROJECT_NO', 'PJT_CODE', 'PJT_NAME', 'SAVE_CODE', 'SAVE_NAME', 'REF_MONEY_UNIT'
												, 'REF_EXCHANGE_RATE', 'REMARK', 'BILL_DIV_CODE', 'DIV_CODE', 'CUSTOM_CODE', 'COLLECT_DATE', 'COLET_CUST_CD'
												, 'COLLECT_PRSN', 'COLLECT_DIV', 'COLLECT_NUM', 'UPDATE_DB_USER', 'UPDATE_DB_TIME','DEPT_CODE', 'TREE_NAME', 'SALE_PROFIT'
												, 'EX_DATE', 'EX_NUM', 'EX_SEQ', 'AGREE_YN', 'AC_DATE', 'AC_NUM', 'UN_PRE_COLL_AMT', 'TOTAL_AMT', 'TOTAL_FOR_AMT'
												, 'CUSTOM_NAME', 'COLET_CUST_NM', 'REFER_COLLECT_AMT', 'REFER_REPAY_AMT', 'REFER_REPAY_AMT_WON', 'REFER_UN_COLL_AMT'
												, 'REF_UN_COLL_AMT', 'REF_CODE1', 'BILL_DATE', 'COMP_CODE', 'CARD_ACC_NUM', 'RECEIPT_NAME', 'BR_IN_NUM', 'ACCT_NO'
												, 'CURR_UNIT', 'ACCT_TXDAY', 'ACCT_TXDAY_SEQ', 'BANK_CD', 'REF_AMT_LOC', 'RECEIPT_PLAN_DATE', 'REF_LOC'
					]))
					return false;
				}

				if(e.record.phantom){			// 신규일때
					if(sCollType == "80"){
						if (UniUtils.indexOf(e.field,
											['COLLECT_SEQ', 'COLLECT_TYPE']))
							return false;
					}
				} else {							// 신규가 아닐때
					if (UniUtils.indexOf(e.field,
											['COLLECT_SEQ', 'COLLECT_TYPE']))
							return false;
				}

				if(sCollType == "80"){				// 선수금 - 반제인경우
					if (UniUtils.indexOf(e.field,
										['COLLECT_AMT', 'COLLECT_FOR_AMT', 'SAVE_CODE', 'SAVE_NAME']))
						return false;
				} else {
					if (UniUtils.indexOf(e.field,
											['REPAY_AMT', 'REPAY_AMT_WON']))
							return false;

					if(BsaCodeInfo.gsExchangeDiffAmt == "Y"){	// 환차손익 자동설정
						if(sCollType == gsPCode || sCollType == gsLCode ){
							if (UniUtils.indexOf(e.field,
											['COLLECT_AMT', 'COLLECT_FOR_AMT']))
							return false;
						}
					}
				}
				// 72.선수금 - 보통예금, 73.선수금 - 당좌예금, 21.당좌예금 - 입금, 22.신용카드 - 입금
				if(sCollType != "20" && sCollType != "30" && sCollType != "71" && sCollType != "21" && sCollType != "72" && sCollType != "73" && sCollType != "22"){
					if (UniUtils.indexOf(e.field,
									['PUB_CUST_CD', 'PUB_CUST_NM']))	// 어음/보통예금
																		// 이외인
																		// 경우
					return false;
				}

				if(sCollType != "30" && sCollType != "71" ){
					if (UniUtils.indexOf(e.field,
									['NOTE_NUM', 'NOTE_TYPE', 'NOTE_PUB_DATE', 'PUB_PRSN', 'NOTE_DUE_DATE', 'PUB_ENDOSER', 'NOTE_CREDIT_RATE']))	// 어음
																																					// 이외인
																																					// 경우
					return false;
				}
				// 20210319 수금유형이 신용카드-입금일 경우에만 edit 가능
				if (e.field == 'COLLECT_TYPE_DETAIL' && e.record.get('COLLECT_TYPE')!= "22"){
					return false;
				}

				if (UniUtils.indexOf(e.field,
									[ 'PUB_NUM'
									,'SALE_LOC_AMT_I'
									,'TAX_AMT_O'
									,'TOT_SALE_AMT'
									,'UN_COLL_AMT'
									,'MONEY_UNIT'
									,'EXCHANGE_RATE'
									,'DISHONOR_DATE'
									,'PROJECT_NO'
									,'PJT_CODE'
									,'PJT_NAME'
									,'REF_MONEY_UNIT'
									,'BILL_DIV_CODE'
									,'DIV_CODE'
									,'CUSTOM_CODE'
									,'COLLECT_DATE'
									,'COLET_CUST_CD'
									,'COLLECT_PRSN'
									,'COLLECT_DIV'
									,'COLLECT_NUM'
									,'UPDATE_DB_USER'
									,'UPDATE_DB_TIME'
									,'DEPT_CODE'
									,'TREE_NAME'
									,'SALE_PROFIT'
									,'EX_DATE'
									,'EX_NUM'
									,'EX_SEQ'
									,'AGREE_YN'
									,'AC_DATE'
									,'AC_NUM'
									,'UN_PRE_COLL_AMT'
									,'TOTAL_AMT'
									,'TOTAL_FOR_AMT'
									,'CUSTOM_NAME'
									,'COLET_CUST_NM'
									,'REFER_COLLECT_AMT'
									,'REFER_REPAY_AMT'
									,'REFER_REPAY_AMT_WON'
									,'REFER_UN_COLL_AMT'
									,'REF_UN_COLL_AMT'
									,'REF_CODE1'
									,'BILL_DATE'
									,'COMP_CODE'
									,'BR_IN_NUM'
									,'ACCT_NO'
									,'CURR_UNIT'
									,'ACCT_TXDAY'
									,'ACCT_TXDAY_SEQ'
									,'BANK_CD'
									,'RECEIPT_PLAN_DATE'
									,'REF_LOC'
									]))
					return false;
			}
		},
		setReferData:function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('DIV_CODE'			, panelSearch.getValue('DIV_CODE'));
			grdRecord.set('COLLECT_NUM'			, panelSearch.getValue('COLL_NUM'));
			grdRecord.set('BILL_DIV_CODE'		, panelSearch.getValue('DIV_CODE'));
			grdRecord.set('PUB_NUM'				, record['PUB_NUM']);

			grdRecord.set('BILL_DATE'			, record['BILL_DATE']);
			grdRecord.set('TAX_AMT_O'			, record['TAX_AMT_O']);
			grdRecord.set('TOT_SALE_AMT'		, record['TOT_SALE_AMT']);
			grdRecord.set('UN_COLL_AMT'			, record['UN_COLL_AMT']);
			grdRecord.set('COLLECT_TYPE'		, '');
			grdRecord.set('REF_CODE1'			, '');
			grdRecord.set('COLLECT_FOR_AMT'		, record['UN_COLL_AMT']);
			grdRecord.set('COLLECT_AMT'			, record['UN_COLL_AMT']);
			grdRecord.set('REPAY_AMT'			, '');
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('PJT_CODE'			, record['PJT_CODE']);
			grdRecord.set('PJT_NAME'			, record['PJT_NAME']);
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('SALE_LOC_AMT_I'		, record['SALE_LOC_AMT_I']);

			if(Ext.isEmpty(panelSearch.getValue('COLL_NUM'))){
				grdRecord.set('CUSTOM_CODE'		, panelSearch.getValue('CUSTOM_CODE'));
				grdRecord.set('CUSTOM_NAME'		, panelSearch.getValue('CUSTOM_NAME'));
			}

			grdRecord.set('COLLECT_DATE'		, panelSearch.getValue('COLL_DATE'));
			grdRecord.set('COLLECT_DIV'			, panelSearch.getValue('COLL_DIV_CODE'));
			grdRecord.set('COLET_CUST_CD'		, panelSearch.getValue('COLL_CUSTOM_CODE'));
			grdRecord.set('COLLECT_PRSN'		, panelSearch.getValue('COLL_PRSN'));
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('EXCHANGE_RATE'		, panelSearch.getValue('EXCHG_RATE'));
			grdRecord.set('SALE_PROFIT'			, '*');
			grdRecord.set('UPDATE_DB_USER'		, UserInfo.userID);
			grdRecord.set('DEPT_CODE'			, '*');
			grdRecord.set('TREE_NAME'			, '*');
			grdRecord.set('COMP_CODE'			, UserInfo.compCode);
			grdRecord.set('REF_MONEY_UNIT'		, record['MONEY_UNIT']);
			grdRecord.set('REF_EXCHANGE_RATE'	, record['EXCHAGNE_RATE']);
			grdRecord.set('REF_LOC'				, record['REF_LOC']);
			grdRecord.set('REF_AMT_LOC'			, record['REF_AMT_LOC']);
			grdRecord.set('RECEIPT_PLAN_DATE'	, record['RECEIPT_PLAN_DATE']);
			grdRecord.set('NOTE_CREDIT_RATE'	, 0 );
			grdRecord.set('COLLECT_AMT'			, (record['UN_COLL_AMT'] * panelSearch.getValue('EXCHG_RATE')));
		},
		setSalesNoReferData:function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('COLLECT_AMT'	, record['SALE_TOT_O']);
			grdRecord.set('BILL_NUM'	, record['BILL_NUM']);
		}
	});

	/**
	* 수주정보를 검색하기 위한 Search Form, Grid, Inner Window 정의
	*/
  	// 검색창 폼 정의
  	var collectNosearch = Unilite.createSearchForm('collectNosearchForm', {
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype:'uniCombobox',
				comboType:'BOR120',
				value:UserInfo.divCode,
				labelWidth: 120,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = collectNosearch.getField('COLLECT_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);// panelResult의
																							// 필터링
																							// 처리
																							// 위해..
					}
				}
		},{
			fieldLabel: '<t:message code="system.label.sales.collectiondate" default="수금일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'COLLECT_DATE_FR',
			endFieldName: 'COLLECT_DATE_TO',
			width: 350
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			labelWidth: 120,
			listeners:{
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						collectNosearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						collectNosearch.setValue('CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
				}
			}
		}),
			Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.collectionplace" default="수금처"/>' ,
			valueFieldName	: 'COLET_CUST_CODE',
			textFieldName	: 'COLET_CUST_NAME',
			validateBlank	: false,
			listeners:{
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						collectNosearch.setValue('COLET_CUST_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						collectNosearch.setValue('COLET_CUST_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
				}
			}
		}),{
			xtype: 'container',
			layout: {type: 'hbox', align: 'stretch'},
			margin: '0 0 2 0',
			items: [{
				fieldLabel: '<t:message code="system.label.sales.collectioncharge" default="수금담당"/>/<t:message code="system.label.sales.collectiondivision" default="수금사업장"/>',
				name: 'COLLECT_PRSN',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'S010',
				width: 250,
				labelWidth: 120,
				listeners:{
					change: function(combo, newValue, oldValue, eOpts) {
						var saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(newValue);// 영업담당의
																							// 사업장코드
																							// 가져오기
						collectNosearch.setValue('COLL_DIV_CODE', saleDivCode);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					} else {
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},{
				hideLabel: true,
				width: 105,
				name: 'COLL_DIV_CODE',
				comboType: 'BOR120',
				xtype:'uniCombobox',
				readOnly: true
			}]
		},{
			fieldLabel: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'  ,
			name: 'MONEY_UNIT',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B004',
			value: 'KRW',
			displayField: 'value',
			fieldStyle: 'text-align: center;'
		},{
			fieldLabel: '<t:message code="system.label.sales.referencepath" default="참조경로"/>',
			name:'REF_LOC',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'S114',
			labelWidth: 120
		},{
			fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			name: 'PROJECT_NO',
			xtype:'uniTextfield'
			//labelWidth:100
		}/*
			* , Unilite.popup('DEPT', { fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', valueFieldName:
			* 'DEPT_CODE', textFieldName: 'DEPT_NAME', labelWidth: 120,
			* allowBlank: false, holdable: 'hold', listeners: { applyextparam:
			* function(popup){ var authoInfo = pgmInfo.authoUser;
			* //권한정보(N-전체,A-자기사업장>5-자기부서) var deptCode = UserInfo.deptCode;
			* //부서정보 var divCode = ''; //사업장
			*
			* if(authoInfo == "A"){ //자기사업장 popup.setExtParam({'DEPT_CODE':
			* ""}); popup.setExtParam({'DIV_CODE': UserInfo.divCode});
			*
			* }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){ //전체권한
			* popup.setExtParam({'DEPT_CODE': ""});
			* popup.setExtParam({'DIV_CODE':
			* panelSearch.getValue('DIV_CODE')});
			*
			* }else if(authoInfo == "5"){ //부서권한
			* popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
			* popup.setExtParam({'DIV_CODE': UserInfo.divCode}); } } } })
			*/]
	});

	// createSearchForm
	// 검색창 모델 정의
	Unilite.defineModel('collectNoMasterModel', {
		fields: [
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string', comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'},
			{name: 'COLLECT_DATE'	, text: '<t:message code="system.label.sales.collectiondate" default="수금일"/>'			, type: 'uniDate'},
			{name: 'COLLECT_NUM'	, text: '<t:message code="system.label.sales.collectionno" default="수금번호"/>'			, type: 'string'},
			{name: 'MONEY_UNIT'		, text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'			, type: 'string', displayField: 'value'},
			//{name: 'COLLECT_FOR_AMT' , text: '환산수금액' , type: 'uniPrice'},
			{name: 'COLLECT_AMT'	, text: '<t:message code="system.label.sales.collectionamount" default="수금액"/>'			, type: 'uniPrice'},
			{name: 'REPAY_AMT'		, text: '<t:message code="system.label.sales.paybackamount" default=" 반제액"/>'			, type: 'uniPrice'},
			{name: 'COLET_CUST_CD'	, text: '<t:message code="system.label.sales.collectionplacecode" default="수금처코드"/>'	, type: 'string'},
			{name: 'COLET_CUST_NM'	, text: '<t:message code="system.label.sales.collectionplace" default="수금처"/>'			, type: 'string'},
			{name: 'COLLECT_PRSN'	, text: '<t:message code="system.label.sales.collectioncharge" default="수금담당"/>'		, type: 'string',comboType: 'AU', comboCode:'S010'},
			{name: 'REF_LOC'		, text: '<t:message code="system.label.sales.referencepath" default="참조경로"/>'			, type: 'string', comboType: 'AU', comboCode: 'S114'},
			{name: 'EX_DATE'		, text: '<t:message code="system.label.sales.slipdate" default="전표일"/>'					, type: 'uniDate'},
			{name: 'EX_NUM'			, text: '<t:message code="system.label.sales.slipno" default="전표번호"/>'					, type: 'string'},
			{name: 'EX_SEQ'			, text: '<t:message code="system.label.sales.exslipseq" default="결의순번"/>'				, type: 'string'},
			{name: 'AGREE_YN'		, text: '<t:message code="system.label.sales.confirmedpending" default="확정여부"/>'		, type: 'string'},
			{name: 'AC_DATE'		, text: '<t:message code="system.label.sales.slipdate" default="전표일"/>'					, type: 'uniDate'},
			{name: 'AC_NUM'			, text: '<t:message code="system.label.sales.slipno" default="전표번호"/>'					, type: 'string'}
		]
	});
	// 검색창 스토어 정의
	var collectNoMasterStore = Unilite.createStore('collectNoMasterStore', {
		model: 'collectNoMasterModel',
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
				read	: 'sco110ukrvService.selectCollectNumMasterList'
			}
		},
		loadStoreRecords : function() {
				var param= collectNosearch.getValues();
				var authoInfo = pgmInfo.authoUser;				// 권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	// 부서코드
				if(authoInfo == "5" && Ext.isEmpty(collectNosearch.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	// 검색창 그리드 정의
	var collectNoMasterGrid = Unilite.createGrid('sco110ukrvCollectNoMasterGrid', {
		// title: '기본',
		layout : 'fit',
		store: collectNoMasterStore,
		uniOpt:{
					useRowNumberer: true
		},
		columns:  [
			{ dataIndex: 'DIV_CODE'			, width: 100 },
			{ dataIndex: 'CUSTOM_CODE'		, width: 66, hidden: true  },
			{ dataIndex: 'CUSTOM_NAME'		, width: 120 },
			{ dataIndex: 'COLLECT_DATE'		, width: 80  },
			{ dataIndex: 'COLLECT_NUM'		, width: 120 },
			{ dataIndex: 'MONEY_UNIT'		, width: 93, align: 'center'  },
// { dataIndex: 'COLLECT_FOR_AMT' , width: 100 },
			{ dataIndex: 'COLLECT_AMT'		, width: 100 },
			//20190722 반제액 컬럼 표시
			{ dataIndex: 'REPAY_AMT'		, width: 113, hidden: false },
			{ dataIndex: 'COLET_CUST_CD'	, width: 93, hidden: true  },
			{ dataIndex: 'COLET_CUST_NM'	, width: 120 },
			{ dataIndex: 'COLLECT_PRSN'		, width: 86  },
			{ dataIndex: 'REF_LOC'			, width: 110  },
			{ dataIndex: 'EX_DATE'			, width: 120  },
			{ dataIndex: 'EX_NUM'			, width: 66  },
			{ dataIndex: 'EX_SEQ'			, width: 53, hidden: true  },
			{ dataIndex: 'AGREE_YN'			, width: 53, hidden: true  },
			{ dataIndex: 'AC_DATE'			, width: 66, hidden: true  },
			{ dataIndex: 'AC_NUM'			, width: 66, hidden: true  }
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
					collectNoMasterGrid.returnData(record);
					UniAppManager.app.onQueryButtonDown();
					searchInfoWindow.hide();
					orderFlag = '';
			}
		}, // listeners
		returnData: function(record) {
			orderFlag = '1';	// change에 중복오류때문에 사용
			var saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(record.get('COLLECT_PRSN'));// 수불담당자의
																									// 사업장
																									// 가져오기
// panelSearch.setValues({'DIV_CODE':record.get('DIV_CODE'),
// 'COLL_NUM':record.get('COLLECT_NUM'),
// 'COLL_DATE':record.get('COLLECT_DATE'),
// 'CUSTOM_CODE':record.get('CUSTOM_CODE'),
// 'CUSTOM_NAME':record.get('CUSTOM_NAME'),
// 'COLL_CUSTOM_CODE':record.get('COLET_CUST_CD'),
// 'COLL_CUSTOM_NAME':record.get('COLET_CUST_NM'),
// 'COLL_PRSN':record.get('COLLECT_PRSN'),
// 'COLL_DIV_CODE':saleDivCode,
// 'MONEY_UNIT':record.get('MONEY_UNIT')
// });
			panelSearch.setValue('DIV_CODE', record.get('DIV_CODE'));
			panelSearch.setValue('COLL_NUM', record.get('COLLECT_NUM'));
			panelSearch.setValue('COLL_DATE', record.get('COLLECT_DATE'));
			panelSearch.setValue('CUSTOM_CODE', record.get('CUSTOM_CODE'));
			panelSearch.setValue('CUSTOM_NAME', record.get('CUSTOM_NAME'));
			panelSearch.setValue('COLL_CUSTOM_CODE', record.get('COLET_CUST_CD'));
			panelSearch.setValue('COLL_CUSTOM_NAME', record.get('COLET_CUST_NM'));
			panelSearch.setValue('COLL_PRSN', record.get('COLLECT_PRSN'));
			panelSearch.setValue('COLL_DIV_CODE', saleDivCode);
			panelSearch.setValue('MONEY_UNIT', record.get('MONEY_UNIT'));
			panelSearch.setValue('REF_LOC', record.get('REF_LOC'));


			panelResult.setValue('DIV_CODE', record.get('DIV_CODE'));
			panelResult.setValue('COLL_NUM', record.get('COLLECT_NUM'));
			panelResult.setValue('COLL_DATE', record.get('COLLECT_DATE'));
			panelResult.setValue('CUSTOM_CODE', record.get('CUSTOM_CODE'));
			panelResult.setValue('CUSTOM_NAME', record.get('CUSTOM_NAME'));
			panelResult.setValue('COLL_CUSTOM_CODE', record.get('COLET_CUST_CD'));
			panelResult.setValue('COLL_CUSTOM_NAME', record.get('COLET_CUST_NM'));
			panelResult.setValue('COLL_PRSN', record.get('COLLECT_PRSN'));
			panelResult.setValue('COLL_DIV_CODE', saleDivCode);
			panelResult.setValue('MONEY_UNIT', record.get('MONEY_UNIT'));
			panelResult.setValue('REF_LOC', record.get('REF_LOC'));

			UniAppManager.app.fnExSlipBtn();
			/*
			* panelSearch.setValue('DIV_CODE', record.get('DIV_CODE'));
			* panelSearch.setValue('COLL_NUM', record.get('COLLECT_NUM'));
			* panelSearch.setValue('COLL_DATE', record.get('COLLECT_DATE'));
			* panelSearch.setValue('CUSTOM_CODE', record.get('CUSTOM_CODE'));
			* panelSearch.setValue('CUSTOM_NAME', record.get('CUSTOM_NAME'));
			* panelSearch.setValue('COLL_CUSTOM_CODE',
			* record.get('COLET_CUST_CD'));
			* panelSearch.setValue('COLL_CUSTOM_NAME',
			* record.get('COLET_CUST_NM')); panelSearch.setValue('COLL_PRSN',
			* record.get('COLLECT_PRSN'));
			* panelSearch.setValue('COLL_DIV_CODE', saleDivCode);
			* panelSearch.setValue('MONEY_UNIT', record.get('MONEY_UNIT'));
			* panelSearch.setValue('EXCHG_RATE', '1');
			* panelSearch.setValue('EX_NUM', record.get('EX_NUM'));
			* panelSearch.setValue('EX_DATE', record.get('AC_DATE'));
			* panelSearch.setValue('REMAIN_ADV',
			* record.get('UN_PRE_COLL_AMT'));
			* panelSearch.setValue('REMAIN_UNCOLL',
			* record.get('REF_UN_COLL_AMT'));
			* panelSearch.setValue('TOTAL_FOR_AMT',
			* record.get('TOTAL_FOR_AMT')); panelSearch.setValue('TOTAL_AMT',
			* record.get('TOTAL_AMT') );
			*/
// panelResult.setValues({
// 'CUSTOM_CODE':record.get('CUSTOM_CODE'),
// 'CUSTOM_NAME':record.get('CUSTOM_NAME'),
// 'COLL_CUSTOM_CODE':record.get('COLET_CUST_CD'),
// 'COLL_CUSTOM_NAME':record.get('COLET_CUST_NM')
// })
			/*
			* panelResult.setValue('COLL_PRSN', record.get('COLLECT_PRSN'));
			* panelResult.setValue('CUSTOM_CODE', record.get('CUSTOM_CODE'));
			* panelResult.setValue('CUSTOM_NAME', record.get('CUSTOM_NAME'));
			* panelResult.setValue('COLL_CUSTOM_CODE',
			* record.get('COLET_CUST_CD'));
			* panelResult.setValue('COLL_CUSTOM_NAME',
			* record.get('COLET_CUST_NM'));
			*/
		}
	});

	// 검색창 메인
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.sales.collectionnosearch" default="수금번호검색"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [collectNosearch, collectNoMasterGrid],
				tbar:  ['->',
					{	itemId : 'searchBtn',
						text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
						handler: function() {
							collectNoMasterStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.sales.close" default="닫기"/>',
						handler: function() {
							searchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
							collectNosearch.clearForm();
							collectNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
							collectNosearch.clearForm();
							collectNoMasterGrid.reset();
					},
					show: function( panel, eOpts ) {
						var field = collectNosearch.getField('COLLECT_PRSN');
						field.fireEvent('changedivcode', field, panelSearch.getValue('DIV_CODE'), null, null, "DIV_CODE");
						collectNosearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
						collectNosearch.setValue('CUSTOM_CODE',panelSearch.getValue('CUSTOM_CODE'));
						collectNosearch.setValue('CUSTOM_NAME',panelSearch.getValue('CUSTOM_NAME'));
						collectNosearch.setValue('MONEY_UNIT',panelSearch.getValue('MONEY_UNIT'));
	// collectNosearch.setValue('COLL_PRSN',panelSearch.getValue('COLL_PRSN'));
	// collectNosearch.setValue('COLET_CUST_CD',panelSearch.getValue('COLL_CUSTOM_CODE'));
	// collectNosearch.setValue('COLET_CUST_NM',panelSearch.getValue('COLL_CUSTOM_NAME'));
						collectNosearch.setValue('COLLECT_DATE_FR', panelSearch.getValue('COLL_DATE'));
						collectNosearch.setValue('COLLECT_DATE_TO', panelSearch.getValue('COLL_DATE'));
						collectNosearch.setValue('COLL_DIV_CODE', panelSearch.getValue('COLL_DIV_CODE'));
						collectNosearch.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
						collectNosearch.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
						collectNosearch.setValue('REF_LOC', panelSearch.getValue('REF_LOC'));
					}
				}
			})
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
	}

	/**
	* 출하지시내역을 참조하기 위한 Search Form, Grid, Inner Window 정의
	*/
	// 계산서미수금참조내역 폼 정의
	var referSearch = Unilite.createSearchForm('referForm', {
		layout :  {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			xtype:'uniCombobox',
			comboType:'BOR120',
				name:'DIV_CODE',
				readOnly: true
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
			validateBlank: false,
			readOnly: true
		}), {
			fieldLabel: '<t:message code="system.label.sales.referencepath" default="참조경로"/>',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'S114',
				name:'REF_LOC',
				readOnly: true
		},{
			fieldLabel: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>',
			name:'MONEY_UNIT',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B004',
			displayField: 'value',
			readOnly: true,
				fieldStyle: 'text-align: center;'
		},{
			xtype: 'uniNumberfield',
			fieldLabel: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>',
			name: 'TOT_AMT',
			value: '0',
			readOnly: true,
			fieldStyle: 'font-weight:bolder;'
		}]
	});
	// 계산서미수금참조내역 모델 정의
	Unilite.defineModel('sco110ukrvReferModel', {
		fields: [
			{name: 'SALE_DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string', comboType: 'BOR120'},
			{name: 'PUB_NUM'			,text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'					, type: 'string'},
			{name: 'BILL_DATE'			,text: '<t:message code="system.label.sales.publishdate" default="발행일"/>'				, type: 'uniDate'},
			{name: 'BILL_TYPE'			,text: '<t:message code="system.label.sales.billclass" default="계산서유형"/>'				, type: 'string',comboType: 'AU', comboCode:'B066'},
			{name: 'SALE_LOC_AMT_I'		,text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'				, type: 'uniFC'},
			{name: 'TAX_AMT_O'			,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'					, type: 'uniPrice'},
			{name: 'TOT_SALE_AMT'		,text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'				, type: 'uniFC'},
			{name: 'UN_COLL_AMT'		,text: '<t:message code="system.label.sales.arbalance" default="미수잔액"/>'				, type: 'uniFC'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'PJT_CODE'			,text: '<t:message code="system.label.sales.projectcode" default="프로젝트코드"/>'			, type: 'string'},
			{name: 'PJT_NAME'			,text: '<t:message code="system.label.sales.project" default="프로젝트"/>'					, type: 'string'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.sales.currency" default="화폐"/>'					, type: 'string', displayField: 'value'},
			{name: 'EXCHAGNE_RATE'		,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'				, type: 'uniER'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.declaredivisioncode" default="신고사업장"/>'		, type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'},
			{name: 'COLET_CUST_CD'		,text: '<t:message code="system.label.sales.collectioncustomer" default="수금거래처"/>'		, type: 'string'},
			{name: 'COLET_AMT'			,text: '<t:message code="system.label.sales.collectionamount" default="수금액"/>'			, type: 'uniPrice'},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.sales.updateuser" default="수정자"/>'				, type: 'string'},
			{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.sales.updatedate" default="수정일"/>'				, type: 'uniDate'},
			{name: 'SALE_PROFIT'		,text: '<t:message code="system.label.sales.businessdivision" default="사업부"/>'			, type: 'string'},
			{name: 'COLLECT_CARE'		,text: '<t:message code="system.label.sales.armanagemethod" default="미수관리방법"/>'			, type: 'string'},
			{name: 'EX_NUM'				,text: '<t:message code="system.label.sales.exslipno" default="결의전표번호"/>'				, type: 'string'},
			{name: 'PUB_FR_DATE'		,text: '<t:message code="system.label.sales.salesdatefrom" default="매출일(FROM)"/>'		, type: 'uniDate'},
			{name: 'PUB_TO_DATE'		,text: '<t:message code="system.label.sales.salesdateto" default="매출일(TO)"/>'			, type: 'uniDate'},
			{name: 'SALE_AMT_O'			,text: '<t:message code="system.label.sales.salesamountforeign" default="매출액(외화)"/>'	, type: 'string'},
			{name: 'REF_AMT_LOC'		,text: '<t:message code="system.label.sales.referencechangeamount" default="참조환산금액"/>'	, type: 'uniPrice'},
			{name: 'RECEIPT_PLAN_DATE'	,text: '<t:message code="system.label.sales.collectionschdate" default="수금예정일"/>'		, type: 'uniDate'},
			{name: 'REF_LOC'			,text: 'REF_LOC'	, type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.sales.remarks" default="비고"/>'					, type: 'string'}
		]
	});

	// 계산서미수금참조내역 스토어 정의
	var referStore = Unilite.createStore('sco110ukrvReferStore', {
		model: 'sco110ukrvReferModel',
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
				read	: 'sco110ukrvService.selectReferList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful) {
					referSearch.setValue('TOT_AMT', 0);
					var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
					var deleteRecords = new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
	
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
									console.log("record :", record);
								if( (record.data['PUB_NUM'] == item.data['PUB_NUM'])) // record
																						// =
																						// masterRecord
																						// item
																						// = 참조
																						// Record
								{
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
			var param= referSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	// 계산서미수금참조내역 그리드 정의
	var referGrid = Unilite.createGrid('sco110ukrvReferGrid', {
		store	: referStore,
		layout	: 'fit',
		uniOpt	:{				//20210326 수정: 위치 수정
			onLoadSelectFirst: false
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly		: false,
			toggleOnClick	: false,
			mode			: 'SIMPLE',
			listeners		: {
				beforeselect : function( me, record, index, eOpts ){	// 선택된 합계금액 set
					var totalAmt = referSearch.getValue('TOT_AMT') + record.get('TOT_SALE_AMT');
					referSearch.setValue('TOT_AMT', totalAmt);
				},
				beforedeselect : function( me, record, index, eOpts ){
					var totalAmt = referSearch.getValue('TOT_AMT') - record.get('TOT_SALE_AMT');
					referSearch.setValue('TOT_AMT', totalAmt);
				}
			}
		}),
		columns	: [
			{ dataIndex: 'SALE_DIV_CODE'		, width: 93  },
			{ dataIndex: 'PUB_NUM'				, width: 106 },
			{ dataIndex: 'BILL_DATE'			, width: 73  },
			{ dataIndex: 'BILL_TYPE'			, width: 80  },
			{ dataIndex: 'SALE_LOC_AMT_I'		, width: 93  },
			{ dataIndex: 'TAX_AMT_O'			, width: 86  },
			{ dataIndex: 'TOT_SALE_AMT'			, width: 93  },
			{ dataIndex: 'UN_COLL_AMT'			, width: 93  },
			{ dataIndex: 'PROJECT_NO'			, width: 93, hidden: true  },
			{ dataIndex: 'PJT_CODE'				, width: 93, hidden: true  },
			{ dataIndex: 'PJT_NAME'				, width: 166 },
			{ dataIndex: 'MONEY_UNIT'			, width: 66, align: 'center'},
			{ dataIndex: 'EXCHAGNE_RATE'		, width: 86  },
			{ dataIndex: 'DIV_CODE'				, width: 66, hidden: true  },
			{ dataIndex: 'CUSTOM_CODE'			, width: 66, hidden: true  },
			{ dataIndex: 'COLET_CUST_CD'		, width: 66, hidden: true  },
			{ dataIndex: 'COLET_AMT'			, width: 66, hidden: true  },
			{ dataIndex: 'UPDATE_DB_USER'		, width: 66, hidden: true  },
			{ dataIndex: 'UPDATE_DB_TIME'		, width: 66, hidden: true  },
			{ dataIndex: 'SALE_PROFIT'			, width: 66, hidden: true  },
			{ dataIndex: 'COLLECT_CARE'			, width: 66, hidden: true  },
			{ dataIndex: 'EX_NUM'				, width: 66, hidden: true  },
			{ dataIndex: 'PUB_FR_DATE'			, width: 66, hidden: true  },
			{ dataIndex: 'PUB_TO_DATE'			, width: 66, hidden: true  },
			{ dataIndex: 'SALE_AMT_O'			, width: 66, hidden: true  },
			{ dataIndex: 'REF_AMT_LOC'			, width: 100 },
			{ dataIndex: 'RECEIPT_PLAN_DATE'	, width: 80  },
			{ dataIndex: 'REF_LOC'				, width: 66, hidden: true  },
			{ dataIndex: 'REMARK'				, width: 133 }
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				detailGrid.setReferData(record.data);
			});
			this.deleteSelectedRow();
		}
	});
	// 계산서미수금참조내역 메인
	function openReferWindow() {
		if(!panelSearch.setAllFieldsReadOnly(true)) return false;
		if(!referWindow) {
			referWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.sales.arreference" default="미수금참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [referSearch, referGrid],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
						handler: function() {
							referStore.loadStoreRecords();
						},
						disabled: false
					},
					{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.sales.arapply" default="미수금적용"/>',
						handler: function() {
							referGrid.returnData();
						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.sales.arapplyclose" default="미수금적용후 닫기"/>',
						handler: function() {
							referGrid.returnData();
							referWindow.hide();
							referSearch.setValue('TOT_AMT', 0);
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.sales.close" default="닫기"/>',
						handler: function() {
							referWindow.hide();
							referSearch.setValue('TOT_AMT', 0);
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						referSearch.clearForm();
						referGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						referSearch.clearForm();
						referGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						referSearch.setValue('DIV_CODE'		, panelSearch.getValue('DIV_CODE'));
						referSearch.setValue('MONEY_UNIT'	, panelSearch.getValue('MONEY_UNIT'));
						//20210420 수정
//						referSearch.setValue('CUSTOM_CODE'	, panelSearch.getValue('CUSTOM_CODE'));
//						referSearch.setValue('CUSTOM_NAME'	, panelSearch.getValue('CUSTOM_NAME'));
						referSearch.setValue('CUSTOM_CODE'	, panelSearch.getValue('COLL_CUSTOM_CODE'));
						referSearch.setValue('CUSTOM_NAME'	, panelSearch.getValue('COLL_CUSTOM_NAME'));
						referSearch.setValue('REF_LOC'		, panelSearch.getValue('REF_LOC'));
						referStore.loadStoreRecords();
					}
				}
			})
		}
		referWindow.center();
		referWindow.show();
	}

	// 매출참조 폼(주석)
	var salesNoSearch = Unilite.createSearchForm('salesNoSearchForm', {
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
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);// panelResult의
																							// 필터링
																							// 처리
																							// 위해..
					}
				}
			},
			Unilite.popup('DEPT', {
				fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>',
				valueFieldName: 'DEPT_CODE',
				textFieldName: 'DEPT_NAME',

				holdable: 'hold',
				allowBlank: false,
				listeners: {
					applyextparam: function(popup){
						var authoInfo = pgmInfo.authoUser;				// 권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	// 부서정보
						var divCode = '';					// 사업장

						if(authoInfo == "A"){	// 자기사업장
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});

						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	// 전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});

						}else if(authoInfo == "5"){		// 부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),
				Unilite.popup('AGENT_CUST',{
				fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
				validateBlank: false,
				readOnly: true
			}),{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				width: 350
			},{
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name: 'SALE_PRSN',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'S010',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					} else {
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name: 'ORDER_TYPE',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'S002',
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.sales.vattype" default="부가세유형"/>',
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
						popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('SALE_CUSTOM_CODE')});
					}
				}

			}), {
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
			listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': salesNoSearch.getValue('DIV_CODE')});
					}
				}
			})/*
				* ,{ fieldLabel: '<t:message code="system.label.sales.inquiryclass" default="조회구분"/>' , xtype: 'uniRadiogroup', allowBlank:
				* false, width: 235, name:'RDO_TYPE', items: [ {boxLabel:'<t:message code="system.label.sales.master" default="마스터"/>',
				* name:'RDO_TYPE', inputValue:'master', checked:true},
				* {boxLabel:'<t:message code="system.label.sales.detail" default="디테일"/>', name:'RDO_TYPE', inputValue:'detail'} ],
				* listeners: { change: function(field, newValue, oldValue,
				* eOpts) { if(newValue.RDO_TYPE=='detail') {
				* if(salesNoMasterGrid) salesNoMasterGrid.hide();
				* if(salesNoDetailGrid) salesNoDetailGrid.show(); } else {
				* if(salesNoDetailGrid) salesNoDetailGrid.hide();
				* if(salesNoMasterGrid) salesNoMasterGrid.show(); } } } }
				*/]
	}); // createSearchForm

	// 매출참조 모델
	Unilite.defineModel('salesNoMasterModel', {
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
			/* 거래처 정보 */
			{name: 'AGENT_TYPE'			, text: 'AGENT_TYPE'	, type: 'string'},
			{name: 'CREDIT_YN' 			, text: 'CREDIT_YN'		, type: 'string'},
			{name: 'WON_CALC_BAS'		, text: 'WON_CALC_BAS'  , type: 'string'},
			{name: 'TAX_CALC_TYPE'		, text: 'TAX_CALC_TYPE' , type: 'string'},
			{name: 'TAX_TYPE'			, text: 'TAX_TYPE'		, type: 'string'}
		]
	});

	// 매출참조 스토어
	var salesNoMasterStore = Unilite.createStore('salesNoMasterStore', {
		model: 'salesNoMasterModel',
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
				read	: 'sco110ukrvService.selectSalesNumMasterList'
			}
		},
		loadStoreRecords : function() {
			var param= salesNoSearch.getValues();
			var authoInfo = pgmInfo.authoUser;				// 권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	// 부서코드
			if(authoInfo == "5" && Ext.isEmpty(salesNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	// 매출참조 그리드
	var salesNoMasterGrid = Unilite.createGrid('ssa101ukrvSalesNoMasterGrid', {
		// title: '기본',
		layout : 'fit',
		store: salesNoMasterStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', {
			checkOnly : false,
			toggleOnClick:false,
		uniOpt:{
			onLoadSelectFirst : false
		},
			mode: 'SIMPLE'
		}),
		uniOpt:{
					useRowNumberer: false
		},
		columns:  [
			{ dataIndex: 'DIV_CODE'			,  width: 100},
			{ dataIndex: 'SALE_CUSTOM_CODE'	,  width: 100,hidden:true},
			{ dataIndex: 'CUSTOM_NAME'		,  width: 130},
			{ dataIndex: 'ITEM_CODE'		,  width: 100,hidden:true},
			{ dataIndex: 'ITEM_NAME'		,  width: 166,hidden:true},
			{ dataIndex: 'SALE_DATE'		,  width: 100},
			{ dataIndex: 'BILL_TYPE'		,  width: 73},
			{ dataIndex: 'SALE_TYPE'		,  width: 100,hidden:true},
			{ dataIndex: 'SALE_TYPE_NAME'	,  width: 100},
			{ dataIndex: 'SALE_Q'			,  width: 86},
			{ dataIndex: 'SALE_TOT_O'		,  width: 86},
// { dataIndex: 'SALE_LOC_AMT_I' , width: 86},
// { dataIndex: 'SALE_LOC_EXP_I' , width: 80},
// { dataIndex: 'TAX_AMT_O' , width: 80},
			{ dataIndex: 'SALE_PRSN'		,  width: 100,hidden:true},
			{ dataIndex: 'SALE_PRSN_NAME'	,  width: 66},
			{ dataIndex: 'BILL_NUM'			,  width: 120},
			{ dataIndex: 'PROJECT_NO'		,  width: 86},
			{ dataIndex: 'INOUT_NUM'		,  width: 100}
		] ,
		listeners: {
// onGridDblClick: function(grid, record, cellIndex, colName) {
// salesNoMasterGrid.returnData(record);
// UniAppManager.app.onQueryButtonDown();
// searchInfoWindow.hide();
// }
		}, // listeners
		returnData: function(record) {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
			UniAppManager.app.onNewDataButtonDown();
			detailGrid.setSalesNoReferData(record.data);
			});
			this.deleteSelectedRow();
		}
	});

	// 매출참조 메인
	function openReferSalesWindow() {
		if(!panelSearch.setAllFieldsReadOnly(true)) return false;
		if(!referSalesWindow) {
			referSalesWindow = Ext.create('widget.uniDetailWindow', {
			title: '<t:message code="system.label.sales.salesreference" default="매출참조"/>',
			width: 1080,
			height: 580,
			layout: {type:'vbox', align:'stretch'},
			items: [salesNoSearch, salesNoMasterGrid/* , salesNoDetailGrid */],
			tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
						handler: function() {
							salesNoMasterStore.loadStoreRecords();
// var rdoType = salesNoSearch.getValue('RDO_TYPE');
// console.log('rdoType : ',rdoType)
// if(rdoType.RDO_TYPE=='master') {
// salesNoMasterStore. ();
// }else {
// salesNoDetailStore.loadStoreRecords();
// }
						},
						disabled: false
					},
					{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.sales.salesreferenceapply" default="매출참조적용"/>',
						handler: function() {
							salesNoMasterGrid.returnData();
						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.sales.salesreferenceapplyclose" default="매출참조적용후 닫기"/>',
						handler: function() {
							salesNoMasterGrid.returnData();
							referSalesWindow.hide();
						},
						disabled: false
					},{
						itemId : 'SalesNoCloseBtn',
						text: '<t:message code="system.label.sales.close" default="닫기"/>',
						handler: function() {
							referSalesWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						salesNoSearch.clearForm();
						salesNoMasterGrid.reset();
// salesNoDetailGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						salesNoSearch.clearForm();
						salesNoMasterGrid.reset();
// salesNoDetailGrid.reset();
					},
					show: function( panel, eOpts ) {
						var field = salesNoSearch.getField('SALE_PRSN');
						field.fireEvent('changedivcode', field, panelSearch.getValue('DIV_CODE'), null, null, "DIV_CODE");
						salesNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
						salesNoSearch.setValue('SALE_DATE_TO',UniDate.get('today'));
						salesNoSearch.setValue('SALE_DATE_FR',UniDate.get('startOfMonth', salesNoSearch.getValue('SALE_DATE_TO')));
						salesNoSearch.setValue('CUSTOM_CODE',panelSearch.getValue('CUSTOM_CODE'));
						salesNoSearch.setValue('CUSTOM_NAME',panelSearch.getValue('CUSTOM_NAME'));
						salesNoSearch.setValue('SALE_PRSN',panelSearch.getValue('COLL_PRSN'));
						salesNoSearch.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
						salesNoSearch.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
						salesNoSearch.setValue('ORDER_TYPE','20');
					}
				}
			})
		}
		referSalesWindow.center();
		referSalesWindow.show();
	}

	/**
	* 사업장별 영업담당 정보
	*/
// var divPrsnStore = Unilite.createStore('STR103UKRV_DIV_PRSN', {
// fields: ["value","text","option"],
// autoLoad: false,
// uniOpt: {
// isMaster: false, // 상위 버튼 연결
// editable: false, // 수정 모드 사용
// deletable:false, // 삭제 가능 여부
// useNavi : false // prev | next 버튼 사용
// },
// proxy: {
// type: 'direct',
// api: {
// read: 'salesCommonService.fnRecordCombo'
// }
// },
// listeners: {
// load: function( store, records, successful, eOpts ) {
// console.log("영업담당 store",this);
//
// if(successful) {
// referSearch.setValue('ESTI_PRSN', panelSearch.getValue('ORDER_PRSN'));
// }
// }
// },
// loadStoreRecords: function() {
// var param= {
// 'COMP_CODE' : UserInfo.compCode,
// 'MAIN_CODE' : 'S010',
// 'DIV_CODE' : panelSearch.getValue('DIV_CODE'),
// 'TYPE' :'DIV_PRSN'
// }
// console.log( param );
// this.load({
// params : param
// });
// }
// });

	/**
	* main app
	*/
	Unilite.Main({
		id: 'sco110ukrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, detailGrid
			]
		},
		panelSearch
		],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
// detailGrid.disabledLinkButtons(false);
			this.setDefault();
			//20190905 수금현황 조회에서 넘어오는 부분 추가
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
		},
		//20190905 수금현황 조회에서 넘어오는 부분 추가
		processParams: function(params) {
			if(params.PGM_ID == 'sco301skrv') {
				orderFlag = '1';
				var saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(params.record.get('COLLECT_PRSN'));
				panelSearch.setValue('DIV_CODE'			, params.record.get('DIV_CODE'));
				panelSearch.setValue('COLL_NUM'			, params.record.get('COLLECT_NUM'));
				panelSearch.setValue('COLL_DATE'		, params.record.get('COLLECT_DATE'));
				panelSearch.setValue('CUSTOM_CODE'		, params.record.get('CUSTOM_CODE'));
				panelSearch.setValue('CUSTOM_NAME'		, params.record.get('CUSTOM_NAME'));
				panelSearch.setValue('COLL_CUSTOM_CODE'	, params.record.get('COLET_CUST_CD'));
				panelSearch.setValue('COLL_CUSTOM_NAME'	, params.record.get('COLET_CUST_NM'));
				panelSearch.setValue('COLL_PRSN'		, params.record.get('COLLECT_PRSN'));
				panelSearch.setValue('COLL_DIV_CODE'	, saleDivCode);
				panelSearch.setValue('MONEY_UNIT'		, params.record.get('MONEY_UNIT'));
				panelSearch.setValue('REF_LOC'			, params.record.get('REF_LOC'));
	
				panelResult.setValue('DIV_CODE'			, params.record.get('DIV_CODE'));
				panelResult.setValue('COLL_NUM'			, params.record.get('COLLECT_NUM'));
				panelResult.setValue('COLL_DATE'		, params.record.get('COLLECT_DATE'));
				panelResult.setValue('CUSTOM_CODE'		, params.record.get('CUSTOM_CODE'));
				panelResult.setValue('CUSTOM_NAME'		, params.record.get('CUSTOM_NAME'));
				panelResult.setValue('COLL_CUSTOM_CODE'	, params.record.get('COLET_CUST_CD'));
				panelResult.setValue('COLL_CUSTOM_NAME'	, params.record.get('COLET_CUST_NM'));
				panelResult.setValue('COLL_PRSN'		, params.record.get('COLLECT_PRSN'));
				panelResult.setValue('COLL_DIV_CODE'	, saleDivCode);
				panelResult.setValue('MONEY_UNIT'		, params.record.get('MONEY_UNIT'));
				panelResult.setValue('REF_LOC'			, params.record.get('REF_LOC'));
	
				setTimeout(function(){UniAppManager.app.onQueryButtonDown()}, 500);
				orderFlag = '';
			} else if(params.PGM_ID == 'ssa615skrv') {
				sco110ukrvService.selectCollectNumMasterList(params, function(provider, response) {
					var record		= provider[0];
					orderFlag		= '1';															// change에 중복오류때문에 사용
					var saleDivCode	= UniAppManager.app.fnGetSalePrsnDivCode(record.COLLECT_PRSN);	//수불담당자의 사업장 가져오기
					panelSearch.setValue('DIV_CODE'			, record.DIV_CODE);
					panelSearch.setValue('COLL_NUM'			, record.COLLECT_NUM);
					panelSearch.setValue('COLL_DATE'		, record.COLLECT_DATE);
					panelSearch.setValue('CUSTOM_CODE'		, record.CUSTOM_CODE);
					panelSearch.setValue('CUSTOM_NAME'		, record.CUSTOM_NAME);
					panelSearch.setValue('COLL_CUSTOM_CODE'	, record.COLET_CUST_CD);
					panelSearch.setValue('COLL_CUSTOM_NAME'	, record.COLET_CUST_NM);
					panelSearch.setValue('COLL_PRSN'		, record.COLLECT_PRSN);
					panelSearch.setValue('COLL_DIV_CODE'	, saleDivCode);
					panelSearch.setValue('MONEY_UNIT'		, record.MONEY_UNIT);
					panelSearch.setValue('REF_LOC'			, record.REF_LOC);

					panelResult.setValue('DIV_CODE'			, record.DIV_CODE);
					panelResult.setValue('COLL_NUM'			, record.COLLECT_NUM);
					panelResult.setValue('COLL_DATE'		, record.COLLECT_DATE);
					panelResult.setValue('CUSTOM_CODE'		, record.CUSTOM_CODE);
					panelResult.setValue('CUSTOM_NAME'		, record.CUSTOM_NAME);
					panelResult.setValue('COLL_CUSTOM_CODE'	, record.COLET_CUST_CD);
					panelResult.setValue('COLL_CUSTOM_NAME'	, record.COLET_CUST_NM);
					panelResult.setValue('COLL_PRSN'		, record.COLLECT_PRSN);
					panelResult.setValue('COLL_DIV_CODE'	, saleDivCode);
					panelResult.setValue('MONEY_UNIT'		, record.MONEY_UNIT);
					panelResult.setValue('REF_LOC'			, record.REF_LOC);

					UniAppManager.app.fnExSlipBtn();
					UniAppManager.app.onQueryButtonDown();
					orderFlag = '';
				});
			}
		},
		onQueryButtonDown: function() {
// panelSearch.setAllFieldsReadOnly(false);
// panelResult.setAllFieldsReadOnly(false);
			var collNum = panelSearch.getValue('COLL_NUM');
			if(Ext.isEmpty(collNum)) {
				openSearchInfoWindow()
			} else {
				detailStore.loadStoreRecords();
				panelSearch.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)) return false;
				/**
				* Detail Grid Default 값 설정
				*/
			var collectSeq = detailStore.max('COLLECT_SEQ');
			if(!collectSeq) collectSeq = 1;
			else  collectSeq += 1;


			var exchangeRate = '';
			if(!Ext.isEmpty(panelSearch.getValue('EXCHG_RATE'))) {
				exchangeRate = panelSearch.getValue('EXCHG_RATE');
			}

			var billDivCode = '';
			if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))) {
				billDivCode = panelSearch.getValue('DIV_CODE');
			}

			var refLoc = '';
			if(!Ext.isEmpty(panelSearch.getValue('REF_LOC'))) {
				refLoc = panelSearch.getValue('REF_LOC');
			}

			var divCode = '';
			if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))) {
				divCode = panelSearch.getValue('DIV_CODE');
			}

			var collectNum = '';
			if(!Ext.isEmpty(panelSearch.getValue('COLL_NUM'))) {
				collectNum = panelSearch.getValue('COLL_NUM');
			}

			var collectDate = '';
			if(!Ext.isEmpty(panelSearch.getValue('COLL_DATE'))) {
				collectDate = panelSearch.getValue('COLL_DATE');
			}

			var customCode = '';
			if(!Ext.isEmpty(panelSearch.getValue('CUSTOM_CODE'))) {
				customCode = panelSearch.getValue('CUSTOM_CODE');
			}

			var coletCustCd = '';
			if(!Ext.isEmpty(panelSearch.getValue('COLL_CUSTOM_CODE'))) {
				coletCustCd = panelSearch.getValue('COLL_CUSTOM_CODE');
			}

			var collPrsn = '';
			if(!Ext.isEmpty(panelSearch.getValue('COLL_PRSN'))) {
				collPrsn = panelSearch.getValue('COLL_PRSN');
			}

			var collDivCode = '';
			if(!Ext.isEmpty(panelSearch.getValue('COLL_DIV_CODE'))) {
				collDivCode = panelSearch.getValue('COLL_DIV_CODE');
			}

			var unPreCollAmt = '';
			if(!Ext.isEmpty(panelSearch.getValue('REMAIN_ADV'))) {
				unPreCollAmt = panelSearch.getValue('REMAIN_ADV');
			}

			var exDate = '';
			if(!Ext.isEmpty(panelSearch.getValue('EX_DATE'))) {
				exDate = panelSearch.getValue('EX_DATE');
			}

			var exNum = '';
			if(!Ext.isEmpty(panelSearch.getValue('EX_NUM'))) {
				exNum = panelSearch.getValue('EX_NUM');
			}

			var deptCode = '';
			if(!Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))) {
				deptCode = panelSearch.getValue('DEPT_CODE');
			}

			var moneyUnit = '';
			if(!Ext.isEmpty(panelSearch.getValue('MONEY_UNIT'))) {
				moneyUnit = panelSearch.getValue('MONEY_UNIT');
			}

			var r = {
				COLLECT_SEQ: collectSeq,
				EXCHANGE_RATE: exchangeRate,
				BILL_DIV_CODE: billDivCode,
				REF_LOC: refLoc,
				DIV_CODE: divCode,
				COLLECT_NUM: collectNum ,
				COLLECT_DATE: collectDate,
				CUSTOM_CODE: customCode,
				COLET_CUST_CD: coletCustCd,
				COLLECT_PRSN: collPrsn,
				COLLECT_DIV: collDivCode,
				UN_PRE_COLL_AMT: unPreCollAmt,
				EX_DATE: exDate,
				EX_NUM: exNum,
				DEPT_CODE: deptCode,
				MONEY_UNIT: moneyUnit
			};

// detailGrid.createRow(r, 'ITEM_CODE', detailGrid.getStore().getCount() - 1);
			detailGrid.createRow(r);
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitBinding();
// panelSearch.getField('CUSTOM_CODE').focus();
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				var fnPostingCheckResult = UniAppManager.app.fnPostingCheck(selRow.get('REF_CODE1'), "D");
				if(fnPostingCheckResult == "E"){
					Unilite.messageBox('<t:message code="system.message.sales.datacheck014" default="기표 처리된 건에 대해서 수정/삭제할 수 없습니다."/>');
					return false;
				}else {
					detailGrid.deleteSelectedRow();
				}
			}
			// fnOrderAmtSum 호출(grid summary 이용)
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						// 신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else {									// 신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						Ext.each(records, function(record,i) {
							var fnPostingCheckResult = UniAppManager.app.fnPostingCheck(record.get('REF_CODE1'), "D");
							if(fnPostingCheckResult == "E"){
								Unilite.messageBox('<t:message code="system.message.sales.datacheck014" default="기표 처리된 건에 대해서 수정/삭제할 수 없습니다."/>');
								deletable = false;
								return false;
							}
						});
						/*---------삭제전 로직 구현 끝----------*/

						if(deletable){
							detailGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){								// 신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	// 삭제후 RESET..
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('sco110ukrvAdvanceSerch');
			if(as.isHidden()) {
				as.show();
			} else {
				as.hide()
			}
		},
		rejectSave: function() {
			var rowIndex = detailGrid.getSelectedRowIndex();
			detailGrid.select(rowIndex);
			detailStore.rejectChanges();

			if(rowIndex >= 0){
				detailGrid.getSelectionModel().select(rowIndex);
				var selected = detailGrid.getSelectedRecord();

				var selected_doc_no = selected.data['DOC_NO'];
  				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {
					}
				);
			}
			detailStore.onStoreActionEnable();
		},
		confirmSaveData: function(config) {
			var fp = Ext.getCmp('sco110ukrvFileUploadPanel');
			if(detailStore.isDirty() || fp.isDirty()) {
				if(confirm('<t:message code="system.message.sales.message021" default="변경된 내용을 저장하시겠습니까?"/>')) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		fnIsOccupied: function(record, idx){
			var sCollType = record.get('REF_CODE1'); // 주수금유형
			if(sCollType == "80"){// 선수금반제
				//20190722 수정
				if(Ext.isEmpty(record.get('REPAY_AMT'))){		// 선수반제액(외화)
					Unilite.messageBox(idx +'<t:message code="system.label.sales.line" default="행"/>' + '<t:message code="system.message.sales.message107" default="반제액은 필수 입니다."/>');
					return false;
				}
				//20190722 추가
				if(Ext.isEmpty(record.get('REPAY_AMT_WON'))){		// 선수반제액(원화)
					Unilite.messageBox(idx +'<t:message code="system.label.sales.line" default="행"/> ' + '<t:message code="system.message.sales.message107" default="반제액은 필수 입니다."/>');
					return false;
				}
			} else {
				//20190722 수정
				if(Ext.isEmpty(record.get('COLLECT_FOR_AMT')) || record.get('COLLECT_FOR_AMT') == 0){	// 수금액 필수처리
					Unilite.messageBox(idx +'<t:message code="system.label.sales.line" default="행"/> ' + '<t:message code="system.message.sales.message108" default="수금액은 필수 입니다."/>');
					return false;
				}
				//20190722 추가
				if(Ext.isEmpty(record.get('COLLECT_AMT')) || record.get('COLLECT_AMT') == 0){			// 환산액 필수처리
					Unilite.messageBox(idx +'<t:message code="system.label.sales.line" default="행"/> ' + '<t:message code="system.message.sales.message108" default="수금액은 필수 입니다."/>');
					return false;
				}
			}
			
			if(sCollType == "30" || sCollType == "71"){ // 어음
				if(Ext.isEmpty(record.get('NOTE_NUM'))){// 어음번호 필수처리
				Unilite.messageBox(idx +'<t:message code="system.label.sales.line" default="행"/> ' + '<t:message code="system.message.sales.message109" default="어음번호는 필수 입니다."/>');
				return false;
				}
				if(Ext.isEmpty(record.get('NOTE_CREDIT_RATE'))){// 인정율(%) 필수처리
				Unilite.messageBox(idx +'<t:message code="system.label.sales.line" default="행"/> ' + '<t:message code="system.message.sales.message110" default="인정율(%)은 필수 입니다."/>');
				return false;
				}
				if(Ext.isEmpty(record.get('NOTE_TYPE'))){// 어음구분 필수처리
				Unilite.messageBox(idx +'<t:message code="system.label.sales.line" default="행"/> ' + '<t:message code="system.message.sales.message111" default="어음구분은 필수 입니다."/>');
				return false;
				}
				if(Ext.isEmpty(record.get('PUB_CUST_CD'))){// 발<t:message code="system.label.sales.line" default="행"/>기관 필수처리
				Unilite.messageBox(idx +'<t:message code="system.label.sales.line" default="행"/> ' + '<t:message code="system.message.sales.message112" default="발행기관은 필수 입니다."/>');
				return false;
				}
				if(Ext.isEmpty(record.get('NOTE_DUE_DATE'))){// 어음만기일 필수처리
				Unilite.messageBox(idx +'<t:message code="system.label.sales.line" default="행"/> ' + '<t:message code="system.message.sales.message113" default="어음만기일은 필수 입니다."/>');
				return false;
				}
			}
	
			if(sCollType == "20"){ // 보통예금
				if(Ext.isEmpty(record.get('PUB_CUST_CD'))){// 발행기관 필수처리
				Unilite.messageBox(idx +'<t:message code="system.label.sales.line" default="행"/> ' + '<t:message code="system.message.sales.message112" default="발행기관은 필수 입니다."/>');
				return false;
				}
	
				if(Ext.isEmpty(record.get('SAVE_CODE'))){// 통장번호 필수처리
				Unilite.messageBox(idx +'<t:message code="system.label.sales.line" default="행"/> ' + '<t:message code="system.message.sales.message114" default="통장번호 필수 입니다."/>');
				return false;
				}
			}
	
			if(sCollType == "21" || sCollType == "72" || sCollType == "73"){
				if(Ext.isEmpty(record.get('PUB_CUST_CD'))){// 발행기관 필수처리
				Unilite.messageBox(idx +'<t:message code="system.label.sales.line" default="행"/> ' + '<t:message code="system.message.sales.message112" default="발행기관은 필수 입니다."/>');
				return false;
				}
	
				if(Ext.isEmpty(record.get('SAVE_CODE'))){// 통장번호 필수처리
				Unilite.messageBox(idx +'<t:message code="system.label.sales.line" default="행"/> ' + '<t:message code="system.message.sales.message114" default="통장번호 필수 입니다."/>');
				return false;
				}
			}
			return true;
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelResult.getValue('COLL_DATE')),
				"MONEY_UNIT" : panelResult.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(panelSearch.getValue('MONEY_UNIT')) && panelSearch.getValue('MONEY_UNIT') != "KRW"){
						Unilite.messageBox('<t:message code="system.message.sales.datacheck008" default="환율정보가 없습니다."/>')
					}
					panelSearch.setValue('EXCHG_RATE', provider.BASE_EXCHG);
					panelResult.setValue('EXCHG_RATE', provider.BASE_EXCHG);
				}
			});
		},
		setDefault: function() {
			/* 수금담당 filter set */
			var field = panelSearch.getField('COLL_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('COLL_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('MONEY_UNIT','KRW');
			panelSearch.setValue('EXCHG_RATE', '1');
			panelSearch.getForm().findField('COLL_NUM').setReadOnly(AutoType);
			panelSearch.setValue('COLL_DATE',new Date());
			panelSearch.getForm().findField('COLL_DIV_CODE').setReadOnly(true);
			panelSearch.getForm().findField('EX_NUM').setReadOnly(true);
			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('MONEY_UNIT','KRW');
			panelResult.setValue('EXCHG_RATE', '1');
			panelResult.getForm().findField('COLL_NUM').setReadOnly(AutoType);
			panelResult.setValue('COLL_DATE',new Date());
			panelResult.getForm().findField('COLL_DIV_CODE').setReadOnly(true);
			panelResult.getForm().findField('EX_NUM').setReadOnly(true);
			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME', UserInfo.deptName);

			panelSearch.setValue('REMAIN_UNCOLL', '0');
			panelSearch.setValue('REMAIN_ADV', '0');
			panelSearch.setValue('TOTAL_FOR_AMT', '0');
			panelSearch.setValue('TOTAL_AMT', '0');
			panelSearch.setValue('REF_LOC','1');
			panelResult.setValue('REF_LOC','1');
			panelSearch.getForm().findField('EX_DATE').setReadOnly(true);
			panelResult.getForm().findField('EX_DATE').setReadOnly(true);
			panelSearch.getForm().findField('REMAIN_UNCOLL').setReadOnly(true);
			panelSearch.getForm().findField('REMAIN_ADV').setReadOnly(true);
			panelSearch.getForm().findField('TOTAL_FOR_AMT').setReadOnly(true);
			panelSearch.getForm().findField('TOTAL_AMT').setReadOnly(true);

			panelResult.setValue('REMAIN_UNCOLL', '0');
			panelResult.setValue('REMAIN_ADV', '0');
			panelResult.setValue('TOTAL_FOR_AMT', '0');
			panelResult.getForm().findField('REMAIN_UNCOLL').setReadOnly(true);
			panelResult.getForm().findField('REMAIN_ADV').setReadOnly(true);
			panelResult.getForm().findField('TOTAL_FOR_AMT').setReadOnly(true);

			orderFlag = ''
 			panelResult.down("#btnCreate").setDisabled(true);
 			panelResult.down("#btnCancel").setDisabled(true);
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		},
		fnGetSalePrsnDivCode: function(subCode){	// 거래처의 영업담당자의 사업장 가져오기
			var saleDivCode ='';
			Ext.each(BsaCodeInfo.salePrsn, function(item, i) {
				if(item['codeNo'] == subCode) {
					saleDivCode = item['refCode1'];
				}
			});
			return saleDivCode;
		},
		fnPostingCheck: function(sCollType,opt){
			var optN = 'N';
			var optE = 'E';
			if(sCollType == "80" || Ext.isEmpty(sCollType)){	// 선수금-반제인 경우
				return false;
			}
			// 전표여부 체크
			if(!Ext.isEmpty(panelSearch.getValue('EX_DATE')) || !Ext.isEmpty(panelSearch.getValue('EX_NUM')) && panelSearch.getValue('EX_NUM') != "0"){
				if(opt == "N"){
					return optN;
				} else {
					return optE;
				}
			}
		},
		fnGetSubCode: function(subCode) {
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
		fnAmtCheck: function(e, newValue, fieldName){
			var sCollType		= e.record.get('REF_CODE1');
			var dTotRemainUnColl= 0;
			var dRemainUnColl	= 0;
			var dOldCollAmt		= 0;
			var dOldRemainAdv	= 0;
			if(e.record.phantom){
				if(!Ext.isEmpty(e.record.get('UN_COLL_AMT'))){	// 미수잔액 REFER_UN_COLL_AMT
					if(fieldName == 'REPAY_AMT'){
						dTotRemainUnColl = e.record.get('UN_COLL_AMT');
					} else {
						dTotRemainUnColl = e.record.get('UN_COLL_AMT') * e.record.get('EXCHANGE_RATE');
					}
				}
			} else {
				// 이전 db의 수금액
				if(!Ext.isEmpty(e.record.get('REFER_COLLECT_AMT'))){
					dOldCollAmt = e.record.get('REFER_COLLECT_AMT');
				}
				// 이전 db의 반제액
				if(!Ext.isEmpty(e.record.get('REPAY_AMT'))){
					dOldRemainAdv = e.record.get('REPAY_AMT');
				}
				// 조회된 미수잔액(기존에 등록했던 수금액,반제액이 반영된 후의 미수잔액)
				if(!Ext.isEmpty(e.record.get('UN_COLL_AMT'))){
					dRemainUnColl = e.record.get('UN_COLL_AMT');
				}
	
				dTotRemainUnColl = dTotRemainUnColl + dRemainUnColl + dOldCollAmt + dOldRemainAdv;
			}
			if(!Ext.isEmpty(e.record.get('PUB_NUM'))){
				if(newValue > dTotRemainUnColl){
					return false;	// Y 일때 수금액은 미수잔액보다 클 수 없습니다.
				}
			}
			return true;
		},
		fnRepayCal: function(e, fieldName, newValue){
			//20190719 선수반제액(외화), 선수반제액(원화) 입력 시 계산로직 수정
			if(fieldName == "REPAY_AMT_WON"){
				// 선수반제액(외화)
				e.record.set('REPAY_AMT', newValue / e.record.get('EXCHANGE_RATE'))
//				e.record.set('REPAY_AMT', e.record.get('REPAY_AMT_WON') / e.record.get('EXCHANGE_RATE'))
			} else {
				// 선수반제액(원화)
				e.record.set('REPAY_AMT_WON', newValue / e.record.get('EXCHANGE_RATE'))
//				e.record.set('REPAY_AMT_WON', e.record.get('REPAY_AMT') / e.record.get('EXCHANGE_RATE'))
			}
		},
		fnCallGetRemainder: function(fieldName, newValue){	// sales 공통 함수 호출
			var divCode = fieldName =='DIV_CODE' 		? newValue : panelSearch.getValue('DIV_CODE');
				var customCode = fieldName =='CUSTOM_CODE' 	? newValue : panelSearch.getValue('CUSTOM_CODE');
				var collDate = fieldName =='COLL_DATE' 		? UniDate.getDbDateStr(newValue) : UniDate.getDbDateStr(panelSearch.getValue('COLL_DATE'));
				var moneyUnit = panelSearch.getValue('MONEY_UNIT');
				UniSales.fnGetRemainder(UniAppManager.app.cbFnGetRemainder, '3', divCode, customCode, moneyUnit, collDate);
		},
		cbFnGetRemainder: function(result1, result2){	// 미수잔액, 선수금잔액 set
			panelSearch.setValue('REMAIN_UNCOLL', result1);
			panelSearch.setValue('REMAIN_ADV', result2);
			gvRemainderAmt1 = result1;
			gvRemainderAmt2 = result2;
			detailStore.fnOrderAmtSum();
		},
		// 매출기표 / 기표취소 버튼 show/hide
		fnExSlipBtn:function() {
			var cancelBtn = panelResult.down("#btnCancel");
			var createBtn = panelResult.down("#btnCreate");
			if(!Ext.isEmpty(panelResult.getValue('EX_NUM')) && panelResult.getValue('EX_NUM') != 0) {
				cancelBtn.setDisabled(false);
				createBtn.setDisabled(true);
			} else {
				cancelBtn.setDisabled(true);
				createBtn.setDisabled(false);
			}
		}
	});

/*
 * Unilite.createValidator('formValidator', { forms: {'formA:':panelSearch},
 * validate: function( type, fieldName, newValue, oldValue) { if(newValue ==
 * oldValue){ return false; } var divCode = fieldName =='DIV_CODE' ? newValue :
 * panelSearch.getValue('DIV_CODE'); var customCode = fieldName =='CUSTOM_CODE' ?
 * newValue : panelSearch.getValue('CUSTOM_CODE'); var collDate = fieldName
 * =='COLL_DATE' ? UniDate.getDbDateStr(newValue) :
 * UniDate.getDbDateStr(panelSearch.getValue('COLL_DATE')); var moneyUnit =
 * panelSearch.getValue('MONEY_UNIT');
 *
 * var rv = true;
 *
 * switch(fieldName) { case "DIV_CODE" : if(Ext.isEmpty(divCode) ||
 * Ext.isEmpty(customCode) || Ext.isEmpty(collDate)){
 * panelSearch.setValue('REMAIN_UNCOLL', '0');
 * panelSearch.setValue('REMAIN_ADV', '0'); break; }
 * UniSales.fnGetRemainder(UniAppManager.app.cbFnGetRemainder, '3', divCode,
 * customCode, moneyUnit, collDate); break;
 *
 * case "COLL_DATE" : if(Ext.isEmpty(divCode) || Ext.isEmpty(customCode) ||
 * Ext.isEmpty(collDate)){ panelSearch.setValue('REMAIN_UNCOLL', '0');
 * panelSearch.setValue('REMAIN_ADV', '0'); break; }
 * UniSales.fnGetRemainder(UniAppManager.app.cbFnGetRemainder,'3', divCode,
 * customCode, moneyUnit, collDate); break;
 *
 * case "CUSTOM_CODE" : if(Ext.isEmpty(divCode) || Ext.isEmpty(customCode) ||
 * Ext.isEmpty(collDate)){ panelSearch.setValue('REMAIN_UNCOLL', '0');
 * panelSearch.setValue('REMAIN_ADV', '0'); break; } //
 * UniSales.fnGetRemainder(UniAppManager.app.cbFnGetRemainder,'3', divCode,
 * customCode, moneyUnit, collDate); break;
 *
 * case "MONEY_UNIT" : if(Ext.isEmpty(divCode) || Ext.isEmpty(customCode) ||
 * Ext.isEmpty(collDate)){ panelSearch.setValue('REMAIN_UNCOLL', '0');
 * panelSearch.setValue('REMAIN_ADV', '0'); break; }
 * UniSales.fnGetRemainder(UniAppManager.app.cbFnGetRemainder,'3', divCode,
 * customCode, moneyUnit, collDate); break; } return rv; } });
 */

/*
 * Unilite.createValidator('formValidator', { forms: {'formA:':panelResult},
 * validate: function( type, fieldName, newValue, oldValue) { if(newValue ==
 * oldValue){ return false; } var divCode = fieldName =='DIV_CODE' ? newValue :
 * panelSearch.getValue('DIV_CODE'); var customCode = fieldName =='CUSTOM_CODE' ?
 * newValue : panelSearch.getValue('CUSTOM_CODE'); var collDate = fieldName
 * =='COLL_DATE' ? UniDate.getDbDateStr(newValue) :
 * UniDate.getDbDateStr(panelSearch.getValue('COLL_DATE')); var moneyUnit =
 * panelSearch.getValue('MONEY_UNIT');
 *
 * var rv = true;
 *
 * switch(fieldName) { case "DIV_CODE" : if(Ext.isEmpty(divCode) ||
 * Ext.isEmpty(customCode) || Ext.isEmpty(collDate)){
 * panelSearch.setValue('REMAIN_UNCOLL', '0');
 * panelSearch.setValue('REMAIN_ADV', '0'); break; }
 * UniSales.fnGetRemainder(UniAppManager.app.cbFnGetRemainder, '3', divCode,
 * customCode, moneyUnit, collDate); break;
 *
 * case "COLL_DATE" : if(Ext.isEmpty(divCode) || Ext.isEmpty(customCode) ||
 * Ext.isEmpty(collDate)){ panelSearch.setValue('REMAIN_UNCOLL', '0');
 * panelSearch.setValue('REMAIN_ADV', '0'); break; }
 * UniSales.fnGetRemainder(UniAppManager.app.cbFnGetRemainder,'3', divCode,
 * customCode, moneyUnit, collDate); break;
 *
 * case "CUSTOM_CODE" : if(Ext.isEmpty(divCode) || Ext.isEmpty(customCode) ||
 * Ext.isEmpty(collDate)){ panelSearch.setValue('REMAIN_UNCOLL', '0');
 * panelSearch.setValue('REMAIN_ADV', '0'); break; }
 * UniSales.fnGetRemainder(UniAppManager.app.cbFnGetRemainder,'3', divCode,
 * customCode, moneyUnit, collDate); break;
 *
 * case "MONEY_UNIT" : if(Ext.isEmpty(divCode) || Ext.isEmpty(customCode) ||
 * Ext.isEmpty(collDate)){ panelSearch.setValue('REMAIN_UNCOLL', '0');
 * panelSearch.setValue('REMAIN_ADV', '0'); break; }
 * UniSales.fnGetRemainder(UniAppManager.app.cbFnGetRemainder,'3', divCode,
 * customCode, moneyUnit, collDate); break; } return rv; } });
 */

	/** Validation
	*/
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv				= true;
			var sCollType		= record.get('REF_CODE1');
			var gsPCode			= BsaCodeInfo.gsPLCode[0].P_CODE;		// 환차익
			var gsLCode			= BsaCodeInfo.gsPLCode[0].L_CODE;		// 환차손
			var sRefCode2		= '';
			var dRemainUnColl	= 0;
			var dOldCollAmt		= 0;
			var dRemainAdv		= 0;
			var dRemainAdvWon	= 0;
			var dOldRemainAdv	= 0;
			var dAdv			= 0;
			var dRepayAmt		= 0;
			var dRepayAmtWon	= 0;
			var fnPostingCheckResult = UniAppManager.app.fnPostingCheck(sCollType, "U");
			if( fnPostingCheckResult == "N"){	// 기표여부 체크
				Unilite.messageBox('<t:message code="system.message.sales.message116" default="기표처리된 수금정보건에 대해서는 수금내역을 추가할 수 없습니다."/>');
				return false;
			}else if(fnPostingCheckResult == "E"){
				Unilite.messageBox('<t:message code="system.message.sales.datacheck014" default="기표 처리된 건에 대해서 수정/삭제할 수 없습니다."/>');
				return false;
			}
			switch(fieldName) {
				case "COLLECT_SEQ" :	// 수금순번
					if(newValue <= 0 && !Ext.isEmpty(newValue)) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						break;
					}
					break;

				case "COLLECT_TYPE" :	// 수금유형(수금유형에서선수금관리)
					sRefCode2 = UniAppManager.app.fnGetSubCode(newValue);

					record.set('REF_CODE1', sRefCode2);
					sCollType = sRefCode2;
					if(BsaCodeInfo.gsExchangeDiffAmt == "Y"){
						if(sCollType == gsPCode || sCollType == gsLCode ){
							rv='<t:message code="system.message.sales.message115" default="환차손익 자동생성(S115)이면 환차손익은 자동으로 만들어 집니다."/>';// fSbMsgS0230
						}
					}

					if(sCollType == "80"){	// 선수금-반제
						if(!Ext.isEmpty(panelSearch.getValue('REMAIN_ADV'))){
							dRemainAdv = panelSearch.getValue('REMAIN_ADV');
							dRemainAdvWon = dRemainAdv * record.get('EXCHANGE_RATE');
						}
						if(!Ext.isEmpty(record.get('REPAY_AMT'))){
							dRepayAmt = record.get('REPAY_AMT');
							dRepayAmtWon = record.get('REPAY_AMT_WON');
						}

						if(dRemainAdv <= 0){
							rv= '<t:message code="system.message.sales.message117" default="선수금잔액이 0(zero)이하일 때 선수금반제내역을 등록할 수 없습니다."/>';
							record.set('COLLECT_AMT'	, 'REPAY_AMT_WON');
							record.set('COLLECT_FOR_AMT', 'REPAY_AMT');
							record.set('REPAY_AMT_WON'	, 0);
							record.set('REPAY_AMT'		, 0);
						}else if(dRemainAdv <= dRepayAmt || dRemainAdv > dRepayAmt){
							record.set('COLLECT_AMT'	, 0);
							record.set('COLLECT_FOR_AMT', 0);
							record.set('REPAY_AMT'		, dRemainAdv);
							record.set('REPAY_AMT_WON'	, dRemainAdvWon);
						}

					} else {
//						if(!Ext.isEmpty(BsaCodeInfo.gsCollectCd )){
//							record.set('EXCHANGE_RATE', 1);
//							record.set('COLLECT_AMT', 0);
//							record.set('COLLECT_FOR_AMT', 0);
//						} else {
//							record.set('EXCHANGE_RATE', panelSearch.getValue('EXCHG_RATE'));
//						}
					}
					// 20210319 수금유형이 신용카드-입금 일경우에만 카드사 추가, 변경 가능
					if(sCollType != "22"){
						record.set('COLLECT_TYPE_DETAIL', null);
					}
					if(newValue != oldValue){
						detailStore.fnOrderAmtSum(sCollType)
					}
// UniAppManager.app.fnBranchInAmt_GetPop()
					record.set('REF_AMT_LOC', record.get('COLLECT_FOR_AMT') * record.get('REF_EXCHANGE_RATE'));
					break;

				case "COLLECT_AMT" :	// 수금액(원화)
					// 미수잔액 >= 수금액
					if(!UniAppManager.app.fnAmtCheck(e, newValue, fieldName)){
						rv='<t:message code="system.message.sales.message118" default="수금유형이 [할인]unilite.msg.[장려금]unilite.msg.[선수금-현금]unilite.msg.[선수금-어음]이외인 경우unilite.msg.수금액은 미수잔액보다 클 수 없습니다."/>';
					}
// if(!Ext.isEmpty(BsaCodeInfo.gsCollectCd )){
// record.set('EXCHANGE_RATE', 1);
// record.set('COLLECT_FOR_AMT', Math.floor(newValue *
// record.get('EXCHANGE_RATE')));
// }
// record.set('REF_AMT_LOC', Math.floor(record.get('COLLECT_FOR_AMT') *
// record.get('REF_EXCHANGE_RATE')));

					if(newValue != oldValue){
// detailStore.fnOrderAmtSum(sCollType)
					}
					break;

				case "COLLECT_FOR_AMT" :
					if(!UniAppManager.app.fnAmtCheck(e, newValue, fieldName)){
						record.set('COLLECT_AMT', Math.floor( newValue * record.get('EXCHANGE_RATE')));
						rv='<t:message code="system.message.sales.message118" default="수금유형이 [할인]unilite.msg.[장려금]unilite.msg.[선수금-현금]unilite.msg.[선수금-어음]이외인 경우unilite.msg.수금액은 미수잔액보다 클 수 없습니다."/>';
					}
//					if(!Ext.isEmpty(BsaCodeInfo.gsCollectCd )){
//						record.set('EXCHANGE_RATE', 1);
//						record.set('REF_AMT_LOC', 0);
//					} else {
//						record.set('EXCHANGE_RATE', panelSearch.getValue('EXCHG_RATE'));
						record.set('REF_AMT_LOC', Math.floor( newValue * record.get('REF_EXCHANGE_RATE')));
//					}
					record.set('COLLECT_AMT', Math.floor( newValue * record.get('EXCHANGE_RATE')));
// detailStore.fnOrderAmtSum(sCollType)
					break;

				case "REPAY_AMT" :
					if(sCollType != "80"){
						break;
					}
					if(!UniAppManager.app.fnAmtCheck(e, newValue, fieldName)){
						rv='<t:message code="system.message.sales.message118" default="수금유형이 [할인],[장려금],[선수금-현금],[선수금-어음]이외인 경우 수금액은 미수잔액보다 클 수 없습니다."/>';
					}
					dRemainAdv = 0;
					if(!Ext.isEmpty(panelSearch.getValue('REMAIN_ADV'))){
						dRemainAdv = panelSearch.getValue('REMAIN_ADV');
					}
					dAdv = newValue;
					//20190722 체크로직 수정
					if(dAdv > dRemainAdv + oldValue){
						rv='<t:message code="system.message.sales.message119" default="선수금반제액은 선수금잔액보다 클 수 없습니다."/>';	// 선수금반제액은 선수금잔액보다 클 수 없습니다.
					}
					if(newValue != oldValue){
						UniAppManager.app.fnRepayCal(e, fieldName, newValue);	// 선수반제액(원화)수정시
																	// 아래함수
																	// 태우고난후 변경된
																	// 선수반제액(외화)금액에의한
																	// 마스터
																	// 재계산되도록
// detailStore.fnOrderAmtSum(sCollType)
					}
					break;

				case "REPAY_AMT_WON" :
					if(sCollType != "80"){
						break;
					}
					if(!UniAppManager.app.fnAmtCheck(e, newValue, fieldName)){
						rv='<t:message code="system.message.sales.message118" default="수금유형이 [할인]unilite.msg.[장려금]unilite.msg.[선수금-현금]unilite.msg.[선수금-어음]이외인 경우unilite.msg.수금액은 미수잔액보다 클 수 없습니다."/>';
					}
					dRemainAdv = 0;
					if(!Ext.isEmpty(panelSearch.getValue('REMAIN_ADV'))){
						dRemainAdv = panelSearch.getValue('REMAIN_ADV') * record.get('EXCHANGE_RATE');
					}
					dAdv = newValue;
					//20190722 체크로직 수정
					if(dAdv > dRemainAdv + oldValue){
						rv='<t:message code="system.message.sales.message119" default="선수금반제액은 선수금잔액보다 클 수 없습니다."/>';	// 선수금반제액은 선수금잔액보다 클 수 없습니다.
					}
					if(newValue != oldValue){
						UniAppManager.app.fnRepayCal(e, fieldName, newValue);	// 선수반제액(원화)수정시
																	// 아래함수
																	// 태우고난후 변경된
																	// 선수반제액(외화)금액에의한
																	// 마스터
																	// 재계산되도록
// detailStore.fnOrderAmtSum(sCollType)
					}
					break;

				case "NOTE_TYPE" :	// 어음구분(1:자수2:타수)

					break;

				case "PUB_CUST_NM" :	// 어음발행처(은행)////은행팝업 생성후

					break;

				case "NOTE_PUB_DATE" :	// 어음발행일
					if(newValue > panelSearch.getValue('COLL_DATE') && !Ext.isEmpty(newValue)){
						rv='<t:message code="system.message.sales.message120" default="어음발행일이 수금일보다 이후입니다. 어음발행일을 확인하십시오."/>'; // 어음발행일이 수금일보다 이후입니다. 어음발행일을 확인하십시오.
						record.set('NOTE_PUB_DATE', panelSearch.getValue('COLL_DATE'));
					}
					break;

				case "NOTE_DUE_DATE" :	// 어음만기일
					if(newValue < panelSearch.getValue('COLL_DATE') && !Ext.isEmpty(newValue)){
						rv='<t:message code="system.message.sales.message121" default="어음만기일이 수금일보다 이전입니다. 어음만기일을 확인하십시오."/>'; // 어음만기일이 수금일보다 이전입니다. 어음만기일을 확인하십시오.
						record.set('NOTE_DUE_DATE', panelSearch.getValue('COLL_DATE'));
					}
					if(newValue < record.get('NOTE_PUB_DATE') && !Ext.isEmpty(newValue)){
						rv='<t:message code="system.message.sales.message122" default="어음만기일이 어음발행일보다 이전입니다. 일자를 확인하십시오."/>'; // 어음만기일이 어음발행일보다 이전입니다. 일자를 확인하십시오.
						record.set('NOTE_DUE_DATE', panelSearch.getValue('COLL_DATE'));
					}
					break;

				case "PROJECT_NO" :	// //관리번호 팝업

					break;

				case "SAVE_CODE" :	// //통장번호 팝업

					break;

				case "REF_EXCHANGE_RATE" :
					record.set('REF_AMT_LOC', record.get('COLLECT_FOR_AMT') * newValue)
					break;

				case "NOTE_CREDIT_RATE" :	// //인정율 처리?

					break;
			}
			return rv;
		}
	}); // validator
}
</script>