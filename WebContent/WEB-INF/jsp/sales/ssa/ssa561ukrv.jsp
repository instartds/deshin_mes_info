<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa561ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa561ukrv"	/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!-- 세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S003" /> <!-- 단가구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S096" /> <!-- 세금계산서구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S095" /> <!-- 국세청수정사유 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당자-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="ssa561ukrvLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="ssa561ukrvLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="ssa561ukrvLevel3Store" />
</t:appConfig>

<script type="text/javascript">

var searchInfoWindow;	//searchInfoWindow : 검색창
var referWindow;	//참조내역


var BsaCodeInfo = {
	gsAutoType		: '${gsAutoType}',
	gsMoneyUnit		: '${gsMoneyUnit}',
	gsBusiPrintPgm	: '${gsBusiPrintPgm}',
	gsAutoreg		: '${gsAutoreg}',
	gsCollectDayFlg	: '${gsCollectDayFlg}',
	gsCustomGubun	: '${gsCustomGubun}',
	gsPjtCodeYN		: '${gsPjtCodeYN}',
	gsBillPrsnEssYN	: '${gsBillPrsnEssYN}',
	salePrsn		: ${salePrsn},
	gsBillYn		: '${gsBillYn}',
	gsBillConnect	: '${gsBillConnect}',
	gsBillDbUser	: '${gsBillDbUser}'
};

var isDisable = false;
if(BsaCodeInfo.gsBillConnect == "00"){
	isDisable = true
}
var CustomCodeInfo = {
	gsTaxCalcType	: '',		//세액계산법
	gsCollectDay	: '',		//수금예정일
	gsUnderCalBase	: '',		//원미만계산
	gsCollector		: '',		//수금거래처
	gsColetCare		: '',		//미수관리법
	gsBillDivChgYN	: ''		//신고사업장 여부?
};
//var output ='';
//for(var key in BsaCodeInfo){
//	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//Unilite.messageBox(output);


var AutoType = false;
if(BsaCodeInfo.gsAutoType == "Y"){
	AutoType = true;
}

var pjtCodeYN = false;
if(BsaCodeInfo.gsAutoType == "N"){
	pjtCodeYN = true;
}

var outDivCode	= UserInfo.divCode;
var isLoad		= false; 		// 로딩 플래그 화폐단위 환율 change 로드시 계속 타므로 임시로 막음
var gsLastDate	= '';
var gsRefFlag;

function appMain() {
	//자동채번 여부
	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoOrderNum = true;
	}

	var gsColetAmt		= 0;
	var gsAcDate		= '';
	var gsPjtCode		= '';
	var gsDivCode		= '';
	var gsStatusM		= '';
	var sSaleAmt		= 0;
	var sTaxAmt			= 0;
	var gsBeforePubNum	= '';		//계산서발행번호
	var gsSaveRefFlag	= 'N';		//검색후에만 수정 가능하게 조회버튼 활성화..
	var gsOriginalPubNum= '';		//원본계산서발행번호



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ssa561ukrvService.selectDetailList',
			update	: 'ssa561ukrvService.updateDetail',
			create	: 'ssa561ukrvService.insertDetail',
			destroy	: 'ssa561ukrvService.deleteDetail',
			syncAll	: 'ssa561ukrvService.saveAll'
		}
	});



	var panelSearch = Unilite.createSearchForm('ssa561ukrvPanelSearch',{
		region		: 'north',
		autoScroll	: true,
		border		: true,
		padding		: '1 1 1 1',
		layout		: {type : 'uniTable', columns : 2
//			,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//				tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		api			: {
			submit: 'ssa561ukrvService.syncForm'
		},
		items		: [{
			layout	: {type : 'uniTable', columns : 4
//				,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//					tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
			},
			padding	: '1 1 1 1',
			xtype	: 'container',
			defaults: {margin: '5 0 5 0'},
			items	: [{
				fieldLabel	: '<t:message code="system.label.sales.serialno" default="일련번호"/>',
				name		: 'PUB_NUM',
				xtype		: 'uniTextfield',
				labelWidth	: 110,
				readOnly	: AutoType,
				tdAttrs		: {style: 'border-bottom: 1px solid #cccccc; padding-top: 0px; padding-bottom: 4px'  }

			},{
				fieldLabel	: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>',
				name		: 'SALE_DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						referSearch.setValue('SALE_DIV_CODE', newValue);
					}
				},
				tdAttrs		: {style: 'border-bottom: 1px solid #cccccc; padding-top: 0px; padding-bottom: 4px'  }
			},{
				fieldLabel		: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_SALE_DATE',
				endFieldName	: 'TO_SALE_DATE',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				holdable		: 'hold',
				allowBlank		: false,
				width			: 370,
				tdAttrs			: {style: 'border-bottom: 1px solid #cccccc; padding-top: 0px; padding-bottom: 4px'  }
			},{
				xtype	: 'container' ,
				layout	: {type: 'uniTable'/*, align:'stretched'*/},
				tdAttrs	: {align: 'right'},
				width	: 160,
				items	: [{
					xtype	: 'button',
					text	: '<t:message code="system.label.sales.salesslip" default="매출기표"/>',
					id		: 'btnAccnt',
					itemId	: 'btnAccnt',
					width	: 80,
//					style	: {'margin-left':'50px'},
					handler	: function() {
						var billNum = panelSearch.getValue("PUB_NUM");
						if (billNum) {
							var param = {
								BILL_DIV_CODE	: panelSearch.getValue('BILL_DIV_CODE'),
								PUB_NUM			: panelSearch.getValue('PUB_NUM')
							}
							ssa561ukrvService.selectMasterList(param, function(provider, response) {
								var exDate = UniDate.getDbDateStr(provider.EX_DATE);
								if(exDate == null || exDate =='') {
									var params = {
										'PGM_ID'		: 'ssa560ukrv',
										'sGubun'		: '30',
										'DIV_CODE'		: panelSearch.getValue("SALE_DIV_CODE"),
										'BILL_DATE'		: UniDate.getDateStr(panelSearch.getValue("WRITE_DATE")),
										'CUSTOM_CODE'	: panelSearch.getValue("CUSTOM_CODE"),
										'BILL_TYPE'		: '10',
										'BILL_PUB_NUM'	: panelSearch.getValue("PUB_NUM")
									}

									var rec = {data : {prgID : 'agj260ukr', 'text':''}};
									parent.openTab(rec, '/accnt/agj260ukr.do', params, CHOST+CPATH);
									
								} else {
									Unilite.messageBox('<t:message code="system.message.sales.message009" default="이미 전표가 등록되었습니다."/>');
								}
							});

						} else {
							Unilite.messageBox('<t:message code="system.message.sales.message010" default="일련번호가 없습니다. 조회 후 실행하세요."/>')
						}
					}
				},{
					xtype	: 'button',
					text	: '<t:message code="system.label.sales.slipcancel" default="기표취소"/>',
					itemId	: 'btnCancel',
					width	: 80,
//					style	: {'margin-left':'10px'},
					handler	: function() {
						var param = {
							BILL_DIV_CODE	: panelSearch.getValue('BILL_DIV_CODE'),
							PUB_NUM			: panelSearch.getValue('PUB_NUM')
						}
						ssa561ukrvService.selectMasterList(param, function(provider, response) {
							var exDate = UniDate.getDbDateStr(provider.EX_DATE);
							if(exDate != null && exDate !='') {
								var param = {
									'DIV_CODE'		: panelSearch.getValue("SALE_DIV_CODE"),
									'BILL_DATE'		: UniDate.getDateStr(panelSearch.getValue("WRITE_DATE")),
									'CUSTOM_CODE'	: panelSearch.getValue("CUSTOM_CODE"),
									'BILL_TYPE'		: '10',
									'BILL_PUB_NUM'	: panelSearch.getValue("PUB_NUM")
								}
								agj260ukrService.cancelAutoSlip30(param,function(responseText, response) {
									if(!Ext.isEmpty(responseText.ERROR_DESC)) {
										if(responseText.EBYN_MESSAGE=="FALSE") {
											console.log(responseText.ERROR_DESC);
										}
										
									} else {
										Unilite.messageBox('<t:message code="system.message.sales.datacheck012" default="기표 취소되었습니다."/>');
										UniAppManager.app.onQueryButtonDown()
//										panelSearch.down("#btnAccnt").setDisabled(false);
//										panelSearch.down("#btnCancel").setDisabled(true);
									}
								});
								
							} else {
								Unilite.messageBox('<t:message code="system.message.sales.message011" default="기표된 전표가 없습니다."/>');
							}
						});
					}
				}
			],
			tdAttrs	: {style: 'border-bottom: 1px solid #cccccc; padding-top: 0px; padding-bottom: 4px'  }
			}]
		},{
			xtype: 'component'
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 1},
			border	: true,
			padding	: '1 1 1 1',
			colspan	: 2,
			items	: [{
				xtype	: 'container',
				margin	: '0 0 0 0',
				layout	: {type : 'uniTable', columns : 4},
				items	: [{
					xtype: 'component',
					width: 10
				},{
					title	: '<t:message code="system.label.sales.supplyperson" default="공급자"/>',
					xtype	: 'fieldset',
					padding	: '0 10 10 10',
					margin	: '0 0 0 0',
					defaults: {readOnly: true, xtype: 'uniTextfield'},
					layout	: {type: 'uniTable' , columns: 2},
					items	: [{
						fieldLabel	: '<t:message code="system.label.sales.owncompnum" default="등록번호"/>',
						name		: 'OWN_COM_NUM',
						colspan		: 2
					},{
						xtype		: 'uniCombobox',
						fieldLabel	: '<t:message code="system.label.sales.compkorname" default="상호(법인명)"/>',
						name		: 'BILL_DIV_CODE',
						comboType	: 'BOR120'
					},{
						fieldLabel	: '<t:message code="system.label.sales.name2" default="성명"/>(<t:message code="system.label.sales.representativename" default="대표자명"/>)',
						name		: 'OWN_TOP_NAME'
					},{
						fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/><t:message code="system.label.sales.address" default="주소"/>',
						name		: 'OWN_ADDRESS',
						width		: 490,
						colspan		: 2
					},{
						fieldLabel	: '<t:message code="system.label.sales.businessconditions" default="업태"/>',
						name		: 'OWN_COMP_TYPE'
					},{
						fieldLabel	: '<t:message code="system.label.sales.compclass" default="종목"/>',
						name		: 'OWN_COMP_CLASS'
					},{
						fieldLabel	: '<t:message code="system.label.sales.servantbusinessnum" default="종사업자번호"/>',
						name		: 'OWN_SERVANT_NUM'
					}]
				},{
					xtype: 'component',
					width: 10
				},{
					title	:'<t:message code="system.label.sales.receiver2" default="공급받는자"/>',
					padding	: '0 10 10 10',
					margin	: '0 0 0 0',
					xtype	: 'fieldset',
					defaults: {readOnly: true, xtype: 'uniTextfield'},
					layout	: {type: 'uniTable' , columns: 2},
					items	: [{
						fieldLabel	: '<t:message code="system.label.sales.owncompnum" default="등록번호"/>',
						name		: 'CUST_COM_NUM'
					},
					Unilite.popup('AGENT_CUST_SINGLE',{
						fieldLabel		: '<t:message code="system.label.sales.client" default="고객"/>',
						textFieldName	: 'CUSTOM_CODE',
						DBtextFieldName	: 'CUSTOM_CODE',
						readOnly		: false,
						holdable		: 'hold',
						allowBlank		: false,
						listeners		: {
							applyextparam: function(popup){
								popup.setExtParam({'SINGLE_CODE': true});
							},
							onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('CUSTOM_NAME', records[0]["CUSTOM_NAME"]);
									if(Ext.isEmpty(records[0]["TAX_CALC_TYPE"]) ||  records[0]["TAX_CALC_TYPE"] == "2"){
										CustomCodeInfo.gsTaxCalcType = "2";
									}else{
										CustomCodeInfo.gsTaxCalcType = "1";
									}
									CustomCodeInfo.gsCollectDay = records[0]["COLLECT_DAY"];									//수금예정일
									UniAppManager.app.fnRcptDateCal(CustomCodeInfo.gsCollectDay);

									if(!Ext.isEmpty(records[0]["COMPANY_NUM"]) && records[0]["COMPANY_NUM"].length == 10){		//사업자번호
										rsComNum =  records[0]["COMPANY_NUM"];
										comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
										panelSearch.setValue('CUST_COM_NUM', comNum);
									}else{
										comNum = records[0]["COMPANY_NUM"];
										panelSearch.setValue('CUST_COM_NUM', comNum);
									}

									panelSearch.setValue('CUST_TOP_NAME'	, records[0]["TOP_NAME"]);							//대표자
									panelSearch.setValue('CUST_ADDRESS'		, records[0]["ADDR1"] + ' ' + records[0]["ADDR2"]);	//주소
									panelSearch.setValue('CUST_COMP_TYPE'	, records[0]["COMP_TYPE"]);							//업태
									panelSearch.setValue('CUST_COMP_CLASS'	, records[0]["COMP_CLASS"]);						//업종
									panelSearch.setValue('CUST_SERVANT_NUM'	, records[0]["SERVANT_COMPANY_NUM"]);				//종사업장번호

									CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"]									//원미계산
									if(Ext.isEmpty(records[0]["COLLECTOR_CP"])){												//수금거래처
										CustomCodeInfo.gsCollector = records[0]["CUSTOM_CODE"];
									}else{
										CustomCodeInfo.gsCollector = records[0]["COLLECTOR_CP"];
									}
									CustomCodeInfo.gsColetCare = records[0]["COLLECT_CARE"];									//미수관리방법
									if(Ext.isEmpty(records[0]["BILL_DIV_CODE"])){
										CustomCodeInfo.gsBillDivChgYN = 'N'
										UniAppManager.app.fnRecordComBo();														//신고사업장 가져오기
									}else{
										CustomCodeInfo.gsBillDivChgYN = 'Y'
										panelSearch.setValue('BILL_DIV_CODE', records[0]["BILL_DIV_CODE"]);
										UniAppManager.app.billDivCode_onChange();
									}
									
									panelSearch.setValue('MONEY_UNIT', records[0].MONEY_UNIT);
									UniAppManager.app.fnExchngRateO();
								 },
							scope: this
							},
							onClear: function(type) {																			//onClear가 먹지 않음
								panelSearch.setValue('CUSTOM_CODE'		, '');
								panelSearch.setValue('MONEY_UNIT'		, BsaCodeInfo.gsMoneyUnit);
								panelSearch.setValue('EXCHG_RATE_O'	, 1);
							}
						}
					}),
					Unilite.popup('AGENT_CUST_SINGLE',{
						fieldLabel		: '<t:message code="system.label.sales.compkorname" default="상호(법인명)"/>',
						textFieldName	: 'CUSTOM_NAME',
						DBtextFieldName	: 'CUSTOM_NAME',
						readOnly		: false,
						holdable		: 'hold',
						allowBlank		: false,
						listeners		: {
							applyextparam: function(popup){
								popup.setExtParam({'SINGLE_CODE': false});
							},
							onSelected: {
								fn: function(records, type) {
									 panelSearch.setValue('CUSTOM_CODE', records[0]["CUSTOM_CODE"]);
									 if(Ext.isEmpty(records[0]["TAX_CALC_TYPE"]) ||  records[0]["TAX_CALC_TYPE"] == "2"){
										CustomCodeInfo.gsTaxCalcType = "2";
									 }else{
										CustomCodeInfo.gsTaxCalcType = "1";
									 }
									 CustomCodeInfo.gsCollectDay = records[0]["COLLECT_DAY"];									//수금예정일
									 UniAppManager.app.fnRcptDateCal(CustomCodeInfo.gsCollectDay);

									if(!Ext.isEmpty(records[0]["COMPANY_NUM"]) && records[0]["COMPANY_NUM"].length == 10){		//사업자번호
										rsComNum =  records[0]["COMPANY_NUM"];
										comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
										panelSearch.setValue('CUST_COM_NUM', comNum);
									}else{
										comNum = records[0]["COMPANY_NUM"];
										panelSearch.setValue('CUST_COM_NUM', comNum);
									}

									panelSearch.setValue('CUST_TOP_NAME'	, records[0]["TOP_NAME"]);							//대표자
									panelSearch.setValue('CUST_ADDRESS'		, records[0]["ADDR1"] + ' ' + records[0]["ADDR2"]);	//주소
									panelSearch.setValue('CUST_COMP_TYPE'	, records[0]["COMP_TYPE"]);							//업태
									panelSearch.setValue('CUST_COMP_CLASS'	, records[0]["COMP_CLASS"]);						//업종
									panelSearch.setValue('CUST_SERVANT_NUM'	, records[0]["SERVANT_COMPANY_NUM"]);				//종사업장번호

									CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"]									//원미계산
									if(Ext.isEmpty(records[0]["COLLECTOR_CP"])){												//수금거래처
										CustomCodeInfo.gsCollector = records[0]["CUSTOM_CODE"];
									}else{
										CustomCodeInfo.gsCollector = records[0]["COLLECTOR_CP"];
									}
									CustomCodeInfo.gsColetCare = records[0]["COLLECT_CARE"];									//미수관리방법
									if(Ext.isEmpty(records[0]["BILL_DIV_CODE"])){
										CustomCodeInfo.gsBillDivChgYN = 'N'
										UniAppManager.app.fnRecordComBo();														//신고사업장 가져오기
									}else{
										CustomCodeInfo.gsBillDivChgYN = 'Y'
										panelSearch.setValue('BILL_DIV_CODE', records[0]["BILL_DIV_CODE"]);
										UniAppManager.app.billDivCode_onChange();
									}
									
									panelSearch.setValue('MONEY_UNIT', records[0].MONEY_UNIT);
									UniAppManager.app.fnExchngRateO();
								},
							scope: this
							},
							onClear: function(type) {																			//onClear가 먹지 않음
								panelSearch.setValue('CUSTOM_CODE'		, '');
								panelSearch.setValue('MONEY_UNIT'		, BsaCodeInfo.gsMoneyUnit);
								panelSearch.setValue('EXCHG_RATE_O'	, 1);
							}
						}
					}),{
						fieldLabel	: '<t:message code="system.label.sales.name2" default="성명"/>(<t:message code="system.label.sales.representativename" default="대표자명"/>)',
						name		: 'CUST_TOP_NAME'
					},{
						fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/><t:message code="system.label.sales.address" default="주소"/>',
						name		: 'CUST_ADDRESS',
						width		: 490,
						colspan		: 2
					},{
						fieldLabel	: '<t:message code="system.label.sales.businessconditions" default="업태"/>',
						name		: 'CUST_COMP_TYPE'
					},{
						fieldLabel	: '<t:message code="system.label.sales.compclass" default="종목"/>',
						name		: 'CUST_COMP_CLASS'
					},{
						fieldLabel	: '<t:message code="system.label.sales.servantbusinessnum" default="종사업자번호"/>',
						name		: 'CUST_SERVANT_NUM'
					},{
						xtype: 'container',
						items: [{
							fieldLabel	: '<t:message code="system.label.sales.bfissue" default="당초승인번호"/>',
							xtype		: 'uniTextfield',
							name		: 'BF_ISSUE',
							id			: 'bfIssue',
							readOnly	: true
						}]
					}]
				}]
			},{
				xtype	: 'container',
				margin	: '0 0 0 0',
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 2},
				border	: true,
				items	: [{
					margin	: '0 0 0 0',
					xtype	: 'container',
					layout	: {type : 'uniTable', columns : 2},
					items	: [{
						fieldLabel	: '<t:message code="system.label.sales.publishdate" default="발행일"/>',
						xtype		: 'uniDatefield',
						name		: 'WRITE_DATE',
						colspan		: 2,
						labelWidth	: 110,
						holdable	: 'hold',
						allowBlank	: false,
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
								var newValue1 = String(UniDate.getDbDateStr(newValue));
								newValue1 = newValue1.replace(".", "").replace(".", "");
								if(String(newValue1).length == 8){
									UniAppManager.app.fnRcptDateCal(CustomCodeInfo.gsCollectDay);
								}
							},
							blur : function (e, event, eOpts) {
								if(UniDate.getDbDateStr(gsLastDate) != UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE'))) {
									UniAppManager.app.fnExchngRateO();
								}
								gsLastDate = panelSearch.getValue('WRITE_DATE');
							}
						}
					},{
						fieldLabel	: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>',
						xtype		: 'uniNumberfield',
						type		: 'uniPrice',
						name		: 'SALE_AMT',
						labelWidth	: 110,
						readOnly	: true
					},{
						fieldLabel	: '<t:message code="system.label.sales.taxamount" default="세액"/>',
						xtype		: 'uniNumberfield',
						type		: 'uniPrice',
						name		: 'SALE_TAX',
						readOnly	: true
					}]
				},{
					margin	: '0 0 0 0',
					xtype	: 'container',
					layout	: {type : 'uniTable', columns : 2},
					items	: [{
						fieldLabel	: '<t:message code="system.label.sales.remarks" default="비고"/>',
						xtype		: 'uniTextfield',
						name		: 'REMARK',
						labelWidth	: 123,
						width		: 524,
						colspan		: 2
					},{
						fieldLabel	: '<t:message code="system.label.purchase.currency" default="화폐"/>',
						name		: 'MONEY_UNIT',
						xtype		: 'uniCombobox',
						comboType	: 'AU',
						comboCode	: 'B004',
						labelWidth	: 123,
						allowBlank	: false,
						displayField: 'value',
						holdable	: 'hold',
						fieldStyle	: 'text-align: center;',
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
//								if(newValue != BsaCodeInfo.gsMoneyUnit){
//									var length = Ext.isEmpty(UniFormat.FC.split('.')[1]) ? 0 : UniFormat.FC.split('.')[1].length;
//									detailGrid.getColumn("ORDER_O").setConfig('format',UniFormat.FC);
//									detailGrid.getColumn("ORDER_O").setConfig('decimalPrecision',length);
//									detailGrid.getColumn("ORDER_O_TAX_O").setConfig('format',UniFormat.FC);
//									detailGrid.getColumn("ORDER_O_TAX_O").setConfig('decimalPrecision',length);
//									detailGrid.getView().refresh(true);
//									
//								} else {
//									var length = Ext.isEmpty(UniFormat.Price.split('.')[1]) ? 0 : UniFormat.Price.split('.')[1].length;
//									detailGrid.getColumn("ORDER_O").setConfig('format',UniFormat.Price);
//									detailGrid.getColumn("ORDER_O").setConfig('decimalPrecision',length);
//									detailGrid.getColumn("ORDER_O_TAX_O").setConfig('format',UniFormat.Price);
//									detailGrid.getColumn("ORDER_O_TAX_O").setConfig('decimalPrecision',length);
//									detailGrid.getView().refresh(true);
//								}
								if(isLoad){
									isLoad = false;
								} else {
									UniAppManager.app.fnExchngRateO();
								}
		
							}
						}
					},{
						fieldLabel	: '<t:message code="system.label.sales.exchangerate" default="환율"/>',
						xtype		: 'uniNumberfield',
						name		: 'EXCHG_RATE_O',
						type		: 'uniER',
						readOnly	: true/*,
						holdable	: 'hold'*/
					},{
	//					fieldLabel	: '<t:message code="system.label.sales.remarks" default="비고"/>',
	//					xtype		: 'uniTextfield',
	//					name		: 'REMARK',
	//					labelWidth	: 123,
	//					width		: 524,
	//					grow		: true,
	//					height		: 47
	//				},{
						fieldLabel	: '거래처수금예정일(temp)',
						xtype		: 'uniDatefield',
						name		: 'TEMP_COL_DATE',
						hidden		: true
					}]
				}]
			}]
		},{
			padding	: '1 1 1 1',
			layout	: {type : 'uniTable', columns : 1},
			colspqn	: 2,
			border	: true,
			xtype	: 'container',
			items	: [{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 6},
				items	: [
					Unilite.popup('PROJECT',{
					fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
					validateBlank	: false,
					textFieldName	: 'PROJECT_NO',
					itemId			: 'project',
					labelWidth		: 110,
//					holdable		: 'hold',
					listeners		: {
						applyextparam: function(popup){
							popup.setExtParam({'BPARAM0': 3});
							popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')});
						}
					},
					tdAttrs: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  }
				}),{
					fieldLabel	: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>',
					xtype		: 'radiogroup',
					holdable	: 'hold',
					items		: [{
						boxLabel	: '<t:message code="system.label.sales.taxation" default="과세"/>',
						name		: 'TAX_BILL' ,
						id			: 'rdoTaxType1',
						inputValue	: '1',
						width		: 45
					},{
						boxLabel	: '<t:message code="system.label.sales.taxexemption" default="면세"/>',
						name		: 'TAX_BILL',
						id			: 'rdoTaxType2',
						inputValue	: '2',
						width		: 45
					},{
						boxLabel	: '<t:message code="system.label.sales.zerotaxrate" default="영세율"/>',
						name		: 'TAX_BILL',
						id			: 'rdoTaxType3',
						inputValue	: '3',
						width		: 65
					}],
					tdAttrs: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  }
				},{
					fieldLabel	: '<t:message code="system.label.sales.exslipdate" default="결의전표일"/>/<t:message code="system.label.sales.number" default="번호"/>',
					xtype		: 'uniDatefield',
					name		: 'EX_DATE',
					maxLength	: 10,
					labelWidth	: 123,
					width		: 215,
					readOnly	: true,
					tdAttrs: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  }
				},{
					xtype		: 'uniTextfield',
					name		: 'EX_NUM',
					width		: 60,
					hideLabel	: true,
					readOnly	: true,
					tdAttrs: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  }
				 },{
					fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
					xtype		: 'uniCombobox',
					name		: 'SALE_PRSN',
					comboType	: 'AU',
					comboCode	: 'S010',
					colspan		: 2,
					tdAttrs: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  }
				}]
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 5},
				items	: [{
					fieldLabel	: '<t:message code="system.label.sales.collectionschdate" default="수금예정일"/>',
					xtype		: 'uniDatefield',
					name		: 'RECEIPT_PLAN_DATE',
					labelWidth	: 110
//					holdable	: 'hold'
				},{
					fieldLabel	: '<t:message code="system.label.sales.taxinvoiceclass" default="세금계산서구분"/>',
					xtype		: 'uniCombobox',
					name		: 'BILL_TYPE',
					id			: 'billType',
					comboType	: 'AU',
					comboCode	: 'S096',
					allowBlank	: false,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts){
							if(newValue == '1'){	//정상발행
								Ext.getCmp('bfIssue').hide();
								panelSearch.getField('REMARK').allowBlank = true;	//// 폼의 allowBlank통제 하려면?
								//수정사유  readOnly, allowBlank 세팅
								panelSearch.setValue('UPDATE_REASON', '');
								panelSearch.getField('UPDATE_REASON').setReadOnly(true);
								panelSearch.getField('UPDATE_REASON').allowBlank = true;
								
							} else if(newValue == '2'){	//수정발행 '2'
								Ext.getCmp('bfIssue').show();
								panelSearch.getField('REMARK').allowBlank = false;
								//수정사유  readOnly, allowBlank 세팅
								panelSearch.getField('UPDATE_REASON').setReadOnly(false);
								panelSearch.getField('UPDATE_REASON').allowBlank = false;
							}
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.updatereason" default="수정사유"/>',
					xtype		: 'uniCombobox',
					name		: 'UPDATE_REASON',
					comboType	: 'AU',
					comboCode	: 'S095',
					labelWidth	: 123,
					listeners	: {
						change:function(field, eOpts) {
							if(Ext.isEmpty(field.getValue())){
								field.fireEvent('onClear');
							}else {
								field.openPopup();
							}
						},
						onSelected:function(record, type) {
							detailGrid.reset();
							detailStore.clearData();
							record = record[0];
							panelSearch.down('#btnAccnt').setDisabled(true);
							panelSearch.down('#btnCancel').setDisabled(false);
							panelSearch.setValue('SALE_AMT', 0);	//금액
							panelSearch.setValue('SALE_TAX', 0);	//세액
							panelSearch.setAllFieldsReadOnly(false);
							panelSearch.setValue('CUSTOM_CODE', record.CUSTOM_CODE);	//거래처
							panelSearch.setValue('CUSTOM_NAME', record.CUSTOM_NAME);	//거래처명
							if(Ext.isEmpty(record.TAX_CALC_TYPE) || record.TAX_CALC_TYPE == "2"){
								CustomCodeInfo.gsTaxCalcType = '2';
							} else{
								CustomCodeInfo.gsTaxCalcType = '1';
							}
							CustomCodeInfo.gsCollectDay = record.COLLECT_DAY;
							UniAppManager.app.fnRcptDateCal(CustomCodeInfo.gsCollectDay);

							if(!Ext.isEmpty(record.COMPANY_NUM) && record.COMPANY_NUM.length == 10){		//사업자번호set
								rsComNum =  record.COMPANY_NUM;
								comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
								panelSearch.setValue('CUST_COM_NUM', comNum);
							} else {
								comNum = record.COMPANY_NUM;
								panelSearch.setValue('CUST_COM_NUM', comNum);
							}
							panelSearch.setValue('CUST_TOP_NAME', record.TOP_NAME);	//대표자
							panelSearch.setValue('CUST_ADDRESS', record.ADDR1 + record.ADDR2 );	//주소
							panelSearch.setValue('CUST_COMP_TYPE', record.COMP_TYPE);	//업태
							panelSearch.setValue('CUST_COMP_CLASS', record.COMP_CLASS);	//업종
							CustomCodeInfo.gsUnderCalBase = record.WON_CALC_BAS;	//원미만계산
							if(Ext.isEmpty(record.COLLECTOR_CP)){		//수금거래처
								CustomCodeInfo.gsCollector = record.CUSTOM_CODE;
							} else {
								CustomCodeInfo.gsCollector = record.COLLECTOR_CP;
							}
							CustomCodeInfo.gsColetCare = record.COLLECT_CARE;	//미수관리방법
							panelSearch.setValue('WRITE_DATE', record.REG_DATE);	//작성일
							panelSearch.setValue('REMARK', record.REG_REMARK);	//비고
							if(record.BILL_TYPE == "11"){	//계산서유형
								panelSearch.getField('TAX_BILL').setValue('1');
							} else if(record.BILL_TYPE == "20"){
								panelSearch.getField('TAX_BILL').setValue('2');
							} else if(record.BILL_TYPE == "12"){
								panelSearch.getField('TAX_BILL').setValue('3');
							}
							panelSearch.setValue('SALE_DIV_CODE', record.SALE_DIV_CODE);
							gsDivCode = record.SALE_DIV_CODE;
							UniAppManager.app.fnRecordComBo();
							panelSearch.setValue('BILL_DIV_CODE', record.DIV_CODE);
							panelSearch.setValue('SALE_PRSN', record.SALE_PRSN); //영업담당
							panelSearch.setValue('BF_ISSUE', record.ISSU_ID);	//당초승인번호

							var updateReason = panelSearch.getValue('UPDATE_REASON');
							switch(updateReason) {
								case "01" :
									panelSearch.getField('WRITE_DATE').setReadOnly(true);
									panelSearch.setValue('FR_SALE_DATE', record.PUB_FR_DATE);
									panelSearch.setValue('TO_SALE_DATE', record.PUB_TO_DATE);
									panelSearch.setValue('SALE_AMT', record.SALE_AMT_O);//금액
									panelSearch.setValue('SALE_TAX', record.TAX_AMT_O);	//세액
									sSaleAmt = record.SALE_AMT_O;
									sTaxAmt = record.TAX_AMT_O;
									amtForm.setValue('SALE_LOC_TOT_DIS', record.SALE_TOT_AMT);
									panelSearch.setAllFieldsReadOnly(true);
									panelSearch.setValue('RECEIPT_PLAN_DATE', record.RECEIPT_PLAN_DATE);
									panelSearch.getField('RECEIPT_PLAN_DATE').setReadOnly(true);
									panelSearch.getField('PROJECT_NO').setReadOnly(true);
									panelSearch.getField('SALE_PRSN').setReadOnly(true);
									gsStatusM = "N"
									Ext.getCmp('labelText').setText('<t:message code="system.message.sales.message012" default="※ 매출내역 변동이 없으므로 내역없이 수정발행 저장시 자동으로 2부 발행"/>');
									break;

								case "02" :
									panelSearch.getField('WRITE_DATE').setReadOnly(false);
									Ext.getCmp('labelText').setText('<t:message code="system.message.sales.message013" default="※ 증감분에 대하여 수불 또는 매출부터 추가 등록 후 1부만 발행"/>');
									break;

								case "03" :
									panelSearch.getField('WRITE_DATE').setReadOnly(false);
									Ext.getCmp('labelText').setText('<t:message code="system.message.sales.message014" default="※ 환입된 금액분에 대하여 수불 또는 매출부터 추가 등록 후 1부만 발행"/>');
									break;

								case "04" :
									panelSearch.getField('WRITE_DATE').setReadOnly(false);
									panelSearch.setValue('FR_SALE_DATE', record.PUB_FR_DATE);
									panelSearch.setValue('TO_SALE_DATE', record.PUB_TO_DATE);
									panelSearch.setValue('SALE_AMT', record.SALE_AMT_O);//금액
									panelSearch.setValue('SALE_TAX', record.TAX_AMT_O);	//세액
									sSaleAmt = record.SALE_AMT_O;
									sTaxAmt = record.TAX_AMT_O;
									amtForm.setValue('SALE_LOC_TOT_DIS', record.SALE_TOT_AMT);
									panelSearch.setAllFieldsReadOnly(true);
									panelSearch.getField('RECEIPT_PLAN_DATE').setReadOnly(true);
									panelSearch.getField('PROJECT_NO').setReadOnly(true);
									panelSearch.getField('SALE_PRSN').setReadOnly(true);
									gsStatusM = "N"
									Ext.getCmp('labelText').setText('<t:message code="system.message.sales.message015" default="※ 부(-)의 세금계산서 1부만 발행"/>');
									panelSearch.getField('WRITE_DATE').setReadOnly(false);
									break;

								case "05" :
									panelSearch.getField('WRITE_DATE').setReadOnly(true);
									panelSearch.setValue('FR_SALE_DATE', record.PUB_FR_DATE);
									panelSearch.setValue('TO_SALE_DATE', record.PUB_TO_DATE);
									Ext.getCmp('labelText').setText('<t:message code="system.message.sales.message016" default="※ 부(-)의 세금계산서 1부, 영세율 세금계산서 1부씩 발행"/>');
									break;

								case "06" :
									panelSearch.getField('WRITE_DATE').setReadOnly(false);
									panelSearch.setValue('FR_SALE_DATE', record.PUB_FR_DATE);
									panelSearch.setValue('TO_SALE_DATE', record.PUB_TO_DATE);
									panelSearch.setValue('SALE_AMT', record.SALE_AMT_O);//금액
									panelSearch.setValue('SALE_TAX', record.TAX_AMT_O);	//세액
									sSaleAmt = record.SALE_AMT_O;
									sTaxAmt = record.TAX_AMT_O;
									amtForm.setValue('SALE_LOC_TOT_DIS', record.SALE_TOT_AMT);
									panelSearch.setAllFieldsReadOnly(false);
									panelSearch.getField('RECEIPT_PLAN_DATE').setReadOnly(true);
									panelSearch.getField('PROJECT_NO').setReadOnly(true);
									panelSearch.getField('SALE_PRSN').setReadOnly(true);
									gsStatusM = "N"
									Ext.getCmp('labelText').setText('<t:message code="system.message.sales.message017" default="※ 원 세금계산서의 반대 세금계산서 1부만 발행"/>');
									break;
							}
							gsBeforePubNum = record.PUB_NUM;
							gsOriginalPubNum = record.ORIGINAL_PUB_NUM;
							UniAppManager.setToolbarButtons('save', true);
						},
						onclear:function(record, type) {
						}
					},
					app: 'Unilite.app.popup.TaxBillSearchPopup',
					api: 'popupService.TaxBillSearchPopup',
					openPopup: function() {
						var me = this;
						var param = {};
						param['TYPE'] = 'TEXT';
						param['pageTitle'] = me.pageTitle;
						param['CUSTOM_CODE'] = panelSearch.getValue('CUSTOM_CODE');
						param['CUSTOM_NAME'] = panelSearch.getValue('CUSTOM_NAME');
						param['WRITE_DATE'] = panelSearch.getValue('WRITE_DATE');
						param['SALE_DIV_CODE'] = panelSearch.getValue('SALE_DIV_CODE');
						param['UPDATE_REASON'] = panelSearch.getValue('UPDATE_REASON');
						param['BILL_CONNECT'] = BsaCodeInfo.gsBillConnect;
						param['BILL_DB_USER'] = BsaCodeInfo.gsBillDbUser;
						if(me.app) {
							var fn = function() {
								var oWin =  Ext.WindowMgr.get(me.app);
								if(!oWin) {
									oWin = Ext.create( me.app, {
											id: me.app,
											callBackFn: me.processResult,
											callBackScope: me,
											popupType: 'TEXT',
											width: 750,
											height:450,
											title: '<t:message code="system.label.sales.origintaxsearch" default="원본세금계산서검색"/>',
											param: param
									 });
								}
								oWin.fnInitBinding(param);
								oWin.center();
								oWin.show();
							}
						 }
						 Unilite.require(me.app, fn, this, true);
					},
					processResult: function(result, type) {
						var me = this, rv;
						console.log("Result: ", result);
						if(result){
							if(Ext.isDefined(result) && result.status == 'OK') {
							me.fireEvent('onSelected', result.data);
							}
						}
					}
				}/*,
					Unilite.popup('TAXBILL_SEARCH',{
					fieldLabel: '수정사유',
					textFieldWidth: 170,
					validateBlank: false,
					valueFieldName:'UPDATE_REASON_CODE',
					textFieldName:'UPDATE_REASON_NAME',
					holdable: 'hold',
					readOnly: false,
					listeners: {
						applyextparam: function(popup){
							popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')});
							popup.setExtParam({'CUSTOM_NAME': panelSearch.getValue('CUSTOM_NAME')});
							popup.setExtParam({'WRITE_DATE': panelSearch.getValue('WRITE_DATE')});
							popup.setExtParam({'SALE_DIV_CODE': panelSearch.getValue('SALE_DIV_CODE')});
							popup.setExtParam({'UPDATE_REASON': ''});
							popup.setExtParam({'BILL_CONNECT': BsaCodeInfo.gsBillConnect});		//웹캐쉬인지 센드빌인지
							popup.setExtParam({'BILL_DB_USER': BsaCodeInfo.gsBillDbUser});		//웹캐쉬인지 센드빌인지

						}
					}
				})*/,{
					fieldLabel	: '<t:message code="system.label.sales.electronicdocumentnum" default="전자문서번호"/>',
					xtype		: 'uniTextfield',
					name		: 'EB_NUM',
					readOnly	: true
				},{
					xtype: 'container',
					items: [{
						xtype	: 'label',
						id		: 'labelText',
						border	: false,
						margin	: '0 0 0 10',
						text	: '',
						width	: 550
					}]
				}]
			}]
		}],
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
				if(gsSaveRefFlag == "Y"){
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
					r = false;
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
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function() {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});

	var amtForm = Unilite.createSearchForm('ssa561ukrvAmtForm',{		//합계폼
		region	: 'south',
		layout	: {type : 'uniTable'},
		padding	: '1 1 1 1',
		border	: true,
		defaults:{xtype: 'uniNumberfield', width: 120, labelAlign: 'top', readOnly: true, margin: '0 10 0 50'/*, labelStyle: 'text-align: center;'*/},
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>',
			name		: 'SALE_LOC_TOT_DIS',
			type		: 'uniPrice'
		},{
			xtype: 'component',
			width: 35
		},{
			fieldLabel	: '<t:message code="system.label.sales.cash" default="현금"/>',
			name		: '',
			type		: 'uniPrice'
		},{
			xtype: 'component',
			width: 35
		},{
			fieldLabel	: '<t:message code="system.label.sales.check" default="수표"/>',
			name		: '',
			type		: 'uniPrice'
		},{
			xtype: 'component',
			width: 35
		},{
			fieldLabel	: '<t:message code="system.label.sales.note" default="어음"/>',
			name		: '',
			type		: 'uniPrice'
		},{
			xtype: 'component',
			width: 35
		},{
			fieldLabel	: '<t:message code="system.label.sales.creditar" default="외상미수금"/>',
			name		: '',
			type		: 'uniPrice'
		},{
			xtype: 'component',
			width: 35
		},{
			xtype	: 'component',
			html	: '<t:message code="system.label.sales.thisamount" default="이 금액을"/>',
			width	: 90
		},{
			xtype	: 'container',
			name	: 'RDO_CLAIM_YN',
			layout	: {type: 'uniTable', columns: 1},
			items	: [{
				xtype		: 'radiofield',
				boxLabel	: '<t:message code="system.label.sales.received" default="영수 함"/>',
				name		: 'CLAIM_YN',
				id			: 'rdoIn',
				inputValue	: '1'
			},{
				xtype		: 'radiofield',
				boxLabel	: '<t:message code="system.label.sales.claimed" default="청구 함"/>',
				name		: 'CLAIM_YN',
				inputValue	: '2'
			}]
		}],
  		setLoadRecord: function() {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});



	//마스터 모델 정의
	Unilite.defineModel('ssa561ukrvDetailModel', {
		fields: [{name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>'			, type: 'string', comboType: 'BOR120'},
				 {name: 'BILL_NUM'			,text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'					, type: 'string'},
				 {name: 'BILL_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'						, type: 'int', defaultValue: '9999'},
				 {name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string'},
				 {name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
				 {name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'						, type: 'string'},
				 {name: 'SALE_Q'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'						, type: 'uniQty', defaultValue: 0},

				 //20181029 추가
				 {name: 'MONEY_UNIT'		,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'				, type: 'string'/*, comboType: 'AU', comboCode: 'B004'*/},
				 {name: 'SALE_AMT_O'		,text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'				, type: 'uniPrice'},
				 {name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'				, type: 'uniER'},
				 
				 {name: 'SALE_P'			,text: '<t:message code="system.label.sales.price" default="단가"/>'						, type: 'uniUnitPrice', defaultValue: 0},
				 {name: 'SALE_LOC_AMT_I'	,text: '<t:message code="system.label.sales.exchangeamount" default="환산액"/>'			, type: 'uniPrice', defaultValue: 0},
				 {name: 'TAX_TYPE'			,text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'			, type: 'string', comboType: 'AU', comboCode: 'B059', defaultValue:"1"},
				 {name: 'TAX_AMT_O'			,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'					, type: 'uniPrice', defaultValue: 0},
				 {name: 'PUB_NUM'			,text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'					, type: 'string'},
				 {name: 'REMARK'			,text: '<t:message code="system.label.sales.remarks" default="비고"/>'					, type: 'string'},
				 {name: 'RECEIPT_PLAN_DATE'	,text: 'RECEIPT_PLAN_DATE'			, type: 'string'},
				 {name: 'PROJECT_NO'		,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
				 {name: 'PROJECT_NAME'		,text: '<t:message code="system.label.sales.projectname" default="프로젝트명"/>'				, type: 'string'},
				 {name: 'BILL_DIV_CODE'		,text: '<t:message code="system.label.sales.declaredivisioncode" default="신고사업장"/>'		, type: 'string'},
				 {name: 'COMP_CODE'			,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'					, type: 'string'},
				 {name: 'INOUT_NUM'			,text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'					, type: 'string'},
				 {name: 'INOUT_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'						, type: 'int'},
				 {name: 'INOUT_TYPE'		,text: '<t:message code="system.label.sales.trantype" default="수불유형"/>'					, type: 'string', defaultValue: '2'},
				 {name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'				, type: 'string', defaultValue: 'AU'},
				 {name: 'SALE_UNIT'			,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'				, type: 'string'},
				 {name: 'TRANS_RATE'		,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				, type: 'uniQty', defaultValue: '1'},
				 {name: 'WH_CODE'			,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'					, type: 'string'},
				 {name: 'PRICE_YN'			,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string', defaultValue: '2'},
				 {name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.client" default="고객"/>'						, type: 'string'},
				 {name: 'ORDER_PRSN'		,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'				, type: 'string'},
				 {name: 'OUT_DIV_CODE'		,text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'			, type: 'string'},
				 {name: 'PRICE_TYPE'		,text: '<t:message code="system.label.sales.pricecalculationtype" default="단가계산구분"/>'	, type: 'string', defaultValue: 'A'},
				 {name: 'UNIT_WGT'			,text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>'				, type: 'int', defaultValue: '1'},
				 {name: 'WGT_UNIT'			,text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'				, type: 'string'},
				 {name: 'UNIT_VOL'			,text: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'				, type: 'int', defaultValue: '1'},
				 {name: 'VOL_UNIT'			,text: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>'				, type: 'string'},
				 {name: 'SALE_WGT_Q'		,text: '<t:message code="system.label.sales.qty" default="수량"/>(<t:message code="system.label.sales.weight" default="중량"/>)'		, type: 'uniQty', defaultValue: 0},
				 {name: 'SALE_FOR_WGT_P'	,text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'			, type: 'uniUnitPrice', defaultValue: 0},
				 {name: 'SALE_WGT_P'		,text: '<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.weight" default="중량"/>)'	, type: 'uniUnitPrice', defaultValue: 0},
				 {name: 'SALE_VOL_Q'		,text: '<t:message code="system.label.sales.qty" default="수량"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'		, type: 'uniQty', defaultValue: 0},
				 {name: 'SALE_FOR_VOL_P'	,text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'			, type: 'uniUnitPrice', defaultValue: 0},
				 {name: 'SALE_VOL_P'		,text: '<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'	, type: 'uniUnitPrice', defaultValue: 0},
				 {name: 'INSERT_DB_USER'	,text: 'INSERT_DB_USER'				, type: 'string', defaultValue: UserInfo.userID},
				 {name: 'UPDATE_DB_USER'	,text: 'UPDATE_DB_USER'				, type: 'string', defaultValue: UserInfo.userID}
		]
	});

	//마스터 스토어 정의
	var detailStore = Unilite.createStore('ssa561ukrvDetailStore', {
		model	: 'ssa561ukrvDetailModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: directProxy,
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)) {
					if(gsRefFlag == 'Y') {
						Ext.each(records,  function(record, index, recs){
							record.phantom = true;
						});
						panelSearch.setAllFieldsReadOnly(true);
					}
					this.fnOrderAmtSum();
				}
			},
			add: function(store, records, index, eOpts) {
				this.fnOrderAmtSum();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				if(detailStore.getCount() != 0){
					var pubNum = detailStore.data.items[0].get('PUB_NUM');
					panelSearch.setValue("PUB_NUM", pubNum);
				}
				this.fnOrderAmtSum();
			},
			remove: function(store, record, index, isMove, eOpts) {
			this.fnOrderAmtSum();
			}
		},
		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				console.log("onStoreLoad");
				if(records) {
					if(records.length > 0) {
						if(gsRefFlag == 'Y'){
							UniAppManager.setToolbarButtons('save', true);
							gsRefFlag = 'N';
						} else {
							UniAppManager.setToolbarButtons('save', false);
						}
						var msg = records.length + Msg.sMB001; 				//'건이 조회되었습니다.';
						UniAppManager.updateStatus(msg, true);
					}
				}
			}
		},
		loadStoreRecords: function(param) {
			if(Ext.isEmpty(param)) {
				var param = {
					BILL_DIV_CODE	: panelSearch.getValue('BILL_DIV_CODE'),
					PUB_NUM			: panelSearch.getValue('PUB_NUM')
				}
			}
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {
						panelSearch.setLoadRecord();
					}
				}
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var paramMaster = {};
			if(!detailStore.isDirty()) {
				if(panelSearch.getValue('BILL_TYPE') == "2" && panelSearch.getValue('UPDATE_REASON') == "01"){	//수정발행, 기제사항착오
					UniAppManager.app.fnModifyUpdatechange();
					return false;
					
				} else if(panelSearch.getValue('BILL_TYPE') == "2" && (panelSearch.getValue('UPDATE_REASON') == "04" || panelSearch.getValue('UPDATE_REASON') == "06")){//수정발행 계약의 해제, 착오예의한 이중발행
					UniAppManager.app.fnContractCancel();
					return false;
					
				} else {	//수정,정상발행 마스터만 저장할시..
					if(!UniAppManager.app.fnGetBillSendUseYNChk()){
						if(UniAppManager.app.fnGetBillSendCloseChk()){
							Ext.Msg.show({
								title:'<t:message code="system.label.sales.confirm" default="확인"/>',
								msg: '<t:message code="system.message.sales.message099" default="국세청전송 완료건 입니다."/>' + '\n' 
								+ '<t:message code="system.message.sales.message100" default="정말로 삭제하시겠습니까?"/>' + '\n' 
								+ '<t:message code="system.message.sales.message101" default="삭제후 재발행시 [수정세금계산서]로 발행을 하여야 합니다."/>',
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									console.log(res);
									if (res === 'yes' ) {
//										me.onSaveAndResetButtonDown();
									} else if(res === 'no') {
										UniAppManager.app.onQueryButtonDown();
									}
								}
							});
						}
					}
					var dtotTaxI = Ext.isNumeric(detailStore.sum('TAX_AMT_O')) ? detailStore.sum('TAX_AMT_O'):0;
					if(dtotTaxI != sTaxAmt){
						Unilite.messageBox('<t:message code="system.message.sales.message102" default="통합계산세액과 개별세금계산서의 세액합계액이 일치하지 않습니다."/>' + '\n' 
								+ '<t:message code="system.label.sales.unitytaxamount" default="통합계산세액"/>' + ': ' 
								+ sTaxAmt + '\n' + '<t:message code="system.label.sales.eachtotaltaxamount" default="개별합계세액"/>' + ': ' + dtotTaxI);
						return false;
					}
//					paramMaster = UniAppManager.app.fnGetParamMaster();
					UniAppManager.app.fnMasterSave();
				}

			} else {			//정상발행 마스터 디테일 모두 저장시..
				if(!UniAppManager.app.fnGetBillSendUseYNChk()){
					if(UniAppManager.app.fnGetBillSendCloseChk()){
						Ext.Msg.show({
							title:'<t:message code="system.label.sales.confirm" default="확인"/>',
							msg: '<t:message code="system.message.sales.message099" default="국세청전송 완료건 입니다."/>' + '\n' 
							+ '<t:message code="system.message.sales.message100" default="정말로 삭제하시겠습니까?"/>' + '\n' 
							+ '<t:message code="system.message.sales.message101" default="삭제후 재발행시 [수정세금계산서]로 발행을 하여야 합니다."/>',
							buttons: Ext.Msg.YESNOCANCEL,
							icon: Ext.Msg.QUESTION,
							fn: function(res) {
								console.log(res);
								if (res === 'yes' ) {
	//								me.onSaveAndResetButtonDown();
								} else if(res === 'no') {
									UniAppManager.app.onQueryButtonDown();
								}
							}
						});
					}
				}
				var dtotTaxI = Ext.isNumeric(detailStore.sum('TAX_AMT_O')) ? detailStore.sum('TAX_AMT_O'):0;
				if(dtotTaxI != sTaxAmt){
					Unilite.messageBox('<t:message code="system.message.sales.message102" default="통합계산세액과 개별세금계산서의 세액합계액이 일치하지 않습니다."/>' + '\n' 
							+  '<t:message code="system.label.sales.unitytaxamount" default="통합계산세액"/>' + ': ' 
							+ sTaxAmt + '\n' + '<t:message code="system.label.sales.eachtotaltaxamount" default="개별합계세액"/>' + ': ' + dtotTaxI);
					return false;
				}
				paramMaster = UniAppManager.app.fnGetParamMaster();
				paramMaster.MODE = 'update'

				if(inValidRecs.length == 0) {
						config = {
							params: [paramMaster],
							success: function(batch, option) {
								//2.마스터 정보(Server 측 처리 시 가공)
//									var master = batch.operations[0].getResultSet();
//									panelSearch.setValue("PUB_NUM", master.PUB_NUM);

//									if(detailStore.getCount() != 0){
//										var pubNum = detailStore.data.items[0].get('PUB_NUM');
//										panelSearch.setValue("PUB_NUM", pubNum);
//									}

								//3.기타 처리
								panelSearch.getForm().wasDirty = false;
								panelSearch.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);

								if(detailStore.getCount() == 0){
									UniAppManager.app.onResetButtonDown();
								}
							}
						};
					this.syncAllDirect(config);
					
				} else {
					detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		},
		fnMasterSet: function(provider) {
			panelSearch.setValue('PUB_NUM', provider.PUB_NUM);
			panelSearch.setValue('SALE_DIV_CODE', provider.SALE_DIV_CODE);
			UniAppManager.app.fnSaleDivCode_onChange();
			panelSearch.setValue('FR_SALE_DATE', provider.PUB_FR_DATE);
			panelSearch.setValue('TO_SALE_DATE', provider.PUB_TO_DATE);

			if(!Ext.isEmpty(provider.OWN_COMNUM) && provider.OWN_COMNUM.length == 10){		//좌측 등록번호 set
				rsComNum =  provider.OWN_COMNUM;
				comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
				panelSearch.setValue('OWN_COM_NUM', comNum);
			} else {
				comNum = provider.OWN_COMNUM;
				panelSearch.setValue('OWN_COM_NUM', comNum);
			}
			panelSearch.setValue('OWN_TOP_NAME', provider.OWN_TOPNAME );
			panelSearch.setValue('OWN_ADDRESS', provider.OWN_ADDR);
			panelSearch.setValue('OWN_COMP_CLASS', provider.OWN_COMCLASS);
			panelSearch.setValue('OWN_COMP_TYPE', provider.OWN_COMTYPE);
			panelSearch.setValue('OWN_SERVANT_NUM', provider.OWN_SERVANTNUM);
			panelSearch.setValue('CUSTOM_CODE', provider.CUSTOM_CODE);
			panelSearch.setValue('CUSTOM_NAME', provider.CUSTOM_NAME);

			if(!Ext.isEmpty(provider.CUST_COMNUM) && provider.CUST_COMNUM.length == 10){		//우측 등록번호 set
				rsComNum =  provider.CUST_COMNUM;
				comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
				panelSearch.setValue('CUST_COM_NUM', comNum);
			} else {
				comNum = provider.CUST_COMNUM;
				panelSearch.setValue('CUST_COM_NUM', comNum);
			}
			panelSearch.setValue('CUST_TOP_NAME', provider.CUST_TOPNAME);
			panelSearch.setValue('CUST_ADDRESS', provider.CUST_ADDR);
			panelSearch.setValue('CUST_COMP_CLASS', provider.CUST_COMCLASS);
			panelSearch.setValue('CUST_COMP_TYPE', provider.CUST_COMTYPE);
			panelSearch.setValue('CUST_SERVANT_NUM', provider.CUST_SERVANTNUM);
			panelSearch.setValue('BF_ISSUE', provider.BFO_ISSU_ID);

			//Call fnCustomChange(txtCustomCode.value, "", "3") 저장시는 필요 없음
			UniAppManager.app.fnRecordComBo();
			panelSearch.setValue('BILL_DIV_CODE', provider.DIV_CODE);
			panelSearch.setValue('BILL_TYPE', provider.BILL_FLAG);
			panelSearch.setValue('ORG_BILL_TYPE', provider.BILL_TYPE);
			Ext.getCmp('billType').setReadOnly(true);
			panelSearch.setValue('SALE_PRSN', provider.SALE_PRSN);

			if(panelSearch.getValue('BILL_TYPE') != '1'){
				panelSearch.setValue('UPDATE_REASON', provider.MODI_REASON);
				Ext.getCmp('bfIssue').show();
				panelSearch.getField('REMARK').allowBlank = false;
				panelSearch.getField('UPDATE_REASON').allowBlank = false;
				//수정사유  readOnly, allowBlank 세팅
				panelSearch.getField('UPDATE_REASON').setReadOnly(true);
			} else {
				Ext.getCmp('bfIssue').hide();
				panelSearch.getField('REMARK').allowBlank = true;
				panelSearch.getField('UPDATE_REASON').allowBlank = true;
				//수정사유  readOnly, allowBlank 세팅
				panelSearch.setValue('UPDATE_REASON', '');
				panelSearch.getField('UPDATE_REASON').setReadOnly(true);
			}
			panelSearch.setValue('EB_NUM', provider.EB_NUM);
			panelSearch.setValue('WRITE_DATE',provider.BILL_DATE);
			panelSearch.setValue('REMARK',provider.REMARK);
			panelSearch.setValue('PROJECT_NO', provider.PROJECT_NO);
			gsColetAmt = provider.COLET_AMT;
			CustomCodeInfo.gsColetCare = provider.COLLECT_CARE;
			panelSearch.setValue('EX_NUM', provider.EX_NUM)
			gsAcDate = provider.AC_DATE;
			var exDate = UniDate.getDbDateStr(provider.EX_DATE);
			if(exDate == null || exDate == ''){
				panelSearch.setValue('EX_DATE', '');
				panelSearch.down('#btnAccnt').setDisabled(false);
				panelSearch.down('#btnCancel').setDisabled(true);
			} else {
				panelSearch.setValue('EX_DATE',exDate);
				if(gsAcDate ==null && gsAcDate == ''){
					panelSearch.down('#btnAccnt').setDisabled(false);
					panelSearch.down('#btnCancel').setDisabled(true);
				} else {
					panelSearch.down('#btnAccnt').setDisabled(true);
					panelSearch.down('#btnCancel').setDisabled(false);
				}
			}

			panelSearch.setValue('RECEIPT_PLAN_DATE', provider.RECEIPT_PLAN_DATE);
			if(provider.BILL_TYPE == "11"){
				panelSearch.getField('TAX_BILL').setValue('1');
				Ext.getCmp('rdoTaxType2').setReadOnly(true);
				Ext.getCmp('rdoTaxType3').setReadOnly(true);
			} else if(provider.BILL_TYPE == "20"){
				panelSearch.getField('TAX_BILL').setValue('2');
				Ext.getCmp('rdoTaxType1').setReadOnly(true);
				Ext.getCmp('rdoTaxType3').setReadOnly(true);
			} else if(provider.BILL_TYPE == "12"){
				Ext.getCmp('rdoTaxType1').setReadOnly(true);
				Ext.getCmp('rdoTaxType2').setReadOnly(true);
				panelSearch.getField('TAX_BILL').setValue('3');
			}

			CustomCodeInfo.gsTaxCalcType = provider.TAX_CALC_TYPE;
			gsPjtCode = provider.PROJECT_NO;
			amtForm.setValue('SALE_LOC_TOT_DIS', provider.SALE_TOT_AMT)

			panelSearch.setValue('SALE_AMT', provider.SALE_AMT_O);
			panelSearch.setValue('SALE_TAX', provider.TAX_AMT_O);

			panelSearch.setValue('MONEY_UNIT'	, provider.MONEY_UNIT);
			panelSearch.setValue('EXCHG_RATE_O'	, provider.EXCHG_RATE_O);

			gsSaveRefFlag = 'Y';
			panelSearch.setAllFieldsReadOnly(true);
		},
		fnOrderAmtSum: function() {
			var dtotSaleTI = 0;
			var dtotTaxI = 0;

			dtotSaleTI	= Ext.isNumeric(this.sum('SALE_AMT_O'))		? this.sum('SALE_AMT_O'): 0;
			dtotTaxI	= Ext.isNumeric(this.sum('TAX_AMT_O'))		? this.sum('TAX_AMT_O')	: 0;
			sSaleAmt	= dtotSaleTI;
			sTaxAmt		= dtotTaxI;
			amtForm.setValue('SALE_LOC_TOT_DIS', dtotSaleTI + dtotTaxI);
			panelSearch.setValue('SALE_AMT', dtotSaleTI);
			panelSearch.setValue('SALE_TAX', dtotTaxI);

			var records = detailStore.data.items;
			var lAuTypeCnt = 0;
			Ext.each(records, function(record,i){
				if(record.get('INOUT_TYPE_DETAIL') == "AU"){
					lAuTypeCnt = lAuTypeCnt + 1;
				}
			});
			UniAppManager.app.fnSetEnableNewBtn("Y", lAuTypeCnt, records);
		}
	});

	//마스터 그리드 정의
	var detailGrid = Unilite.createGrid('ssa561ukrvGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false
		},
		tbar	: [ {
			itemId	: 'estimateBtn', iconCls : 'icon-referance'	,
			text	: '<t:message code="system.label.sales.salesreference" default="매출참조"/>',
			handler	: function() {
				if(panelSearch.getValue('BILL_TYPE') == '2' && panelSearch.getValue('UPDATE_REASON') == '01') {	// 수정발행 - 기재사항 착오  일경우 매출참조 못한다.
					Unilite.messageBox('<t:message code="system.message.sales.message103" default="추가참조하실 수 없습니다."/>');
				} else if(panelSearch.getValue('BILL_TYPE') == '2' && panelSearch.getValue('UPDATE_REASON') == '04') {	// 수정발행 - 계약의 해제 일경우 매출참조 못한다.
					Unilite.messageBox('<t:message code="system.message.sales.message103" default="추가참조하실 수 없습니다."/>' );
				} else if(!Ext.isEmpty(panelSearch.getValue('EB_NUM'))) {
					Unilite.messageBox('<t:message code="system.message.sales.message104" default="이미 전자세금계산서가 발행된 자료입니다."/>');
				} else if(!Ext.isEmpty(panelSearch.getValue('EX_DATE'))) {
					Unilite.messageBox('<t:message code="system.message.sales.message105" default="회계전표가 생성된 계산서발행자료는 수정/삭제할 수 없습니다."/>');
				} else {
					openReferWindow();
				}
			}
		}],
		columns: [{ dataIndex: 'DIV_CODE'	, width: 80 },
				  { dataIndex: 'BILL_NUM'	, width: 100},
				  { dataIndex: 'BILL_SEQ'	, width: 50 },
				  { dataIndex: 'ITEM_CODE'	, width: 105,
					editor: Unilite.popup('DIV_PUMOK_G', {
		 				textFieldName	: 'ITEM_CODE',
		 				DBtextFieldName	: 'ITEM_CODE',
//						extParam		: {SELMODEL: 'MULTI', DIV_CODE: UserInfo.divCode, POPUP_TYPE: 'GRID_CODE'},
						autoPopup		: true,
						listeners		: {
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
							applyextparam: function(popup){
								var record = detailGrid.getSelectedRecord();
								popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': record.get('DIV_CODE'), 'POPUP_TYPE': 'GRID_CODE'});
							}
						}
					})
				  },
				  {dataIndex: 'ITEM_NAME'	, width: 200,
					editor: Unilite.popup('DIV_PUMOK_G', {
						autoPopup: true,
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
							applyextparam: function(popup){
								var record = detailGrid.getSelectedRecord();
								popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': record.get('DIV_CODE'), 'POPUP_TYPE': 'GRID_CODE'});
							}
						}
					})
				  },
				  { dataIndex: 'SPEC'				, width: 150},
				  { dataIndex: 'SALE_Q'				, width: 106},
				  
				  //20181029 추가 (MONEY_UNIT)
				  { dataIndex: 'MONEY_UNIT'			, width: 80, align: 'center'},

				  { dataIndex: 'SALE_P'				, width: 106},
				  
				  //20181029 추가 (SALE_AMT_O, EXCHG_RATE_O)
				  { dataIndex: 'SALE_AMT_O'			, width: 106},
				  { dataIndex: 'EXCHG_RATE_O'		, width: 106},
				  
				  { dataIndex: 'SALE_LOC_AMT_I'		, width: 106},
				  { dataIndex: 'TAX_TYPE'			, width: 80, align: 'center'},
				  { dataIndex: 'TAX_AMT_O'			, width: 80 },
				  { dataIndex: 'PUB_NUM'			, width: 100, hidden: true},
				  { dataIndex: 'REMARK'				, width: 100, hidden: true},
				  { dataIndex: 'RECEIPT_PLAN_DATE'	, width: 100, hidden: true},
				  { dataIndex: 'PROJECT_NO'			, width: 100 },
				  { dataIndex: 'PROJECT_NAME'		, width: 166, hidden: true},
				  { dataIndex: 'BILL_DIV_CODE'		, width: 100, hidden: true},
				  { dataIndex: 'COMP_CODE'			, width: 66,  hidden: true },
				  { dataIndex: 'INOUT_NUM'			, width: 66,  hidden: true },
				  { dataIndex: 'INOUT_SEQ'			, width: 66,  hidden: true },
				  { dataIndex: 'INOUT_TYPE'			, width: 66,  hidden: true },
				  { dataIndex: 'INOUT_TYPE_DETAIL'	, width: 66,  hidden: true },
				  { dataIndex: 'SALE_UNIT'			, width: 66,  hidden: true },
				  { dataIndex: 'TRANS_RATE'			, width: 66,  hidden: true },
				  { dataIndex: 'WH_CODE'			, width: 66,  hidden: true },
				  { dataIndex: 'PRICE_YN'			, width: 66,  hidden: true },
				  { dataIndex: 'CUSTOM_CODE'		, width: 66,  hidden: true },
				  { dataIndex: 'ORDER_PRSN'			, width: 66,  hidden: true },
				  { dataIndex: 'OUT_DIV_CODE'		, width: 66,  hidden: true },
				  { dataIndex: 'PRICE_TYPE'			, width: 66,  hidden: true },
				  { dataIndex: 'UNIT_WGT'			, width: 66,  hidden: true },
				  { dataIndex: 'WGT_UNIT'			, width: 66,  hidden: true },
				  { dataIndex: 'UNIT_VOL'			, width: 66,  hidden: true },
				  { dataIndex: 'VOL_UNIT'			, width: 66,  hidden: true },
				  { dataIndex: 'SALE_WGT_Q'			, width: 66,  hidden: true },
				  { dataIndex: 'SALE_FOR_WGT_P'		, width: 66,  hidden: true },
				  { dataIndex: 'SALE_WGT_P'			, width: 66,  hidden: true },
				  { dataIndex: 'SALE_VOL_Q'			, width: 66,  hidden: true },
				  { dataIndex: 'SALE_FOR_VOL_P'		, width: 66,  hidden: true },
				  { dataIndex: 'SALE_VOL_P'			, width: 66,  hidden: true }
		],
		setItemData: function(record, dataClear, grdRecord) {
//			var grdRecord = this.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, "");
				grdRecord.set('ITEM_NAME'		, "");
				grdRecord.set('SPEC'			, "");
				grdRecord.set('SALE_UNIT'		, "");
				grdRecord.set('TRANS_RATE'		, "1");
				grdRecord.set('WH_CODE'			, "");
				grdRecord.set('UNIT_WGT'		, 0);
				grdRecord.set('WGT_UNIT'		, "");
				grdRecord.set('UNIT_VOL'		, 0);
				grdRecord.set('VOL_UNIT'		, "");
				grdRecord.set('SALE_Q'			, 0);
				grdRecord.set('MONEY_UNIT'		, '');
				grdRecord.set('SALE_P'			, 0);
				grdRecord.set('SALE_AMT_O'		, 0);
				grdRecord.set('EXCHG_RATE_O'	, 0);
				grdRecord.set('SALE_LOC_AMT_I'	, 0);
				grdRecord.set('TAX_AMT_O'		, 0);
				grdRecord.set('SALE_WGT_Q'		, 0);
				grdRecord.set('SALE_FOR_WGT_P'	, 0);
				grdRecord.set('SALE_WGT_P'		, 0);
				grdRecord.set('SALE_VOL_Q'		, 0);
				grdRecord.set('SALE_FOR_VOL_P'	, 0);
				grdRecord.set('SALE_VOL_P'		, 0);
				
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('SALE_UNIT'		, record['SALE_UNIT']);
				grdRecord.set('TRANS_RATE'		, record['TRNS_RATE']);
				grdRecord.set('WH_CODE'			, record['WH_CODE']);
				grdRecord.set('UNIT_WGT'		, record['UNIT_WGT']);
				grdRecord.set('WGT_UNIT'		, record['WGT_UNIT']);
				grdRecord.set('UNIT_VOL'		, record['UNIT_VOL']);
				grdRecord.set('VOL_UNIT'		, record['VOL_UNIT']);
				grdRecord.set('TAX_TYPE'		, record['TAX_TYPE']);
				grdRecord.set('SALE_Q'			, 0);
				grdRecord.set('MONEY_UNIT'		, panelSearch.getValue('MONEY_UNIT'));
				grdRecord.set('SALE_P'			, 0);
				grdRecord.set('SALE_AMT_O'		, 0);
				grdRecord.set('EXCHG_RATE_O'	, panelSearch.getValue('EXCHG_RATE_O'));
				grdRecord.set('SALE_LOC_AMT_I'	, 0);
				grdRecord.set('TAX_AMT_O'		, 0);
				grdRecord.set('SALE_WGT_Q'		, 0);
				grdRecord.set('SALE_FOR_WGT_P'	, 0);
				grdRecord.set('SALE_WGT_P'		, 0);
				grdRecord.set('SALE_VOL_Q'		, 0);
				grdRecord.set('SALE_FOR_VOL_P'	, 0);
				grdRecord.set('SALE_VOL_P'		, 0);
			}
		},
		setReferData:function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('PUB_NUM'				, panelSearch.getValue('PUB_NUM'));
			grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('BILL_NUM'			, record['BILL_NUM']);
			grdRecord.set('BILL_SEQ'			, record['BILL_SEQ']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('SALE_Q'				, record['SALE_Q']);
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('SALE_P'				, record['SALE_P']);
			grdRecord.set('SALE_AMT_O'			, record['SALE_AMT_O']);
//			grdRecord.set('EXCHG_RATE_O'		, panelSearch.getValue('EXCHG_RATE_O'));
//			grdRecord.set('SALE_LOC_AMT_I'		, Unilite.multiply(record['SALE_AMT_O'], panelSearch.getValue('EXCHG_RATE_O')));
			grdRecord.set('EXCHG_RATE_O'		, record['EXCHG_RATE_O']);
			grdRecord.set('SALE_LOC_AMT_I'		, record['SALE_LOC_AMT_I']);
			grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);
			grdRecord.set('TAX_AMT_O'			, record['TAX_AMT_O']);
			grdRecord.set('REMARK'				, panelSearch.getValue('REMARK'));
			grdRecord.set('RECEIPT_PLAN_DATE'	, panelSearch.getValue('RECEIPT_PLAN_DATE'));
//			grdRecord.set('PROJECT_NO'			, panelSearch.getValue('PROJECT_NO'));
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('PROJECT_NAME'		, record['PROJECT_NAME']);
			grdRecord.set('BILL_DIV_CODE'		, panelSearch.getValue('BILL_DIV_CODE'));
			grdRecord.set('COMP_CODE'			, UserInfo.compCode);
			grdRecord.set('INOUT_NUM'			, record['INOUT_NUM']);
			grdRecord.set('INOUT_SEQ'			, record['INOUT_SEQ']);
			grdRecord.set('INOUT_TYPE'			, record['INOUT_TYPE']);
			grdRecord.set('INOUT_TYPE_DETAIL'	, record['INOUT_TYPE_DETAIL']);
			grdRecord.set('SALE_UNIT'			, record['SALE_UNIT']);
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);
			grdRecord.set('WH_CODE'				, record['WH_CODE']);
			grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('ORDER_PRSN'			, record['ORDER_PRSN']);
			grdRecord.set('OUT_DIV_CODE'		, record['OUT_DIV_CODE']);
			grdRecord.set('PRICE_TYPE'			, record['PRICE_TYPE']);
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
			grdRecord.set('SALE_WGT_Q'			, record['SALE_WGT_Q']);
			grdRecord.set('SALE_FOR_WGT_P'		, record['SALE_FOR_WGT_P']);
			grdRecord.set('SALE_WGT_P'			, record['SALE_WGT_P']);
			grdRecord.set('SALE_VOL_Q'			, record['SALE_VOL_Q']);
			grdRecord.set('SALE_FOR_VOL_P'		, record['SALE_FOR_VOL_P']);
			grdRecord.set('SALE_VOL_P'			, record['SALE_VOL_P']);
			gsPjtCode = record['PROJECT_NO']
		},
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.get('INOUT_TYPE_DETAIL') == "AU"){
					if(e.record.phantom){			//신규일때
						if (UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'SALE_AMT_O', 'TAX_AMT_O', 'TAX_TYPE'])){
							return true;
						}else{
							return false;
						}
					}
				}else{ //신규가 아닐때
					return false;
				}
			}
		}
	});



	//검색창 폼 정의
	var billNosearch = Unilite.createSearchForm('ssa561ukrvBillNosearchForm', {
		layout			: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items			: [{
			fieldLabel	: '<t:message code="system.label.sales.declaredivisioncode" default="신고사업장"/>',
			xtype		: 'uniCombobox',
			name		: 'BILL_DIV_CODE',
			comboType	: 'BOR120',
			allowBlank	: false
		},{
			fieldLabel	: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>',
			xtype		: 'uniCombobox',
			name		: 'SALE_DIV_CODE',
			comboType	: 'BOR120'
		},{
			fieldLabel		: '<t:message code="system.label.sales.billdate" default="계산서일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_SALE_DATE',
			endFieldName	: 'TO_SALE_DATE',
			width			: 350
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>'
		}),
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			itemId			: 'project',
			textFieldName	:'PROJECT_NO',
			validateBlank	: true,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'BPARAM0': 3});
					popup.setExtParam({'CUSTOM_CODE': panelSearch.getValue('SALE_CUSTOM_CODE')});
				}
			}
		})]
	});

	//검색창 모델 정의
	Unilite.defineModel('billNoMasterModel', {
		fields: [{name: 'DIV_NAME'		,text: '<t:message code="system.label.sales.declaredivisioncode" default="신고사업장"/>'	, type: 'string'},
				 {name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			, type: 'string'},
				 {name: 'PUB_NUM'		,text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'				, type: 'string'},
				 {name: 'BILL_FLAG'		,text: '<t:message code="system.label.sales.invoiceclass" default="계산서구분"/>'		, type: 'string', comboType: 'AU', comboCode: 'S096'},
				 {name: 'BILL_TYPE'		,text: '<t:message code="system.label.sales.billtype" default="계산서종류"/>'			, type: 'string'},
				 {name: 'BILL_DATE'		,text: '<t:message code="system.label.sales.billdate" default="계산서일"/>'				, type: 'uniDate'},
				 {name: 'PUB_DATE'		,text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'				, type: 'string'},
				 {name: 'SALE_DIV_CODE'	,text: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>'		, type: 'string', comboType: 'BOR120'},
				 {name: 'PROJECT_NO'	,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			, type: 'string'},
				 {name: 'EX_YN'			,text: '<t:message code="system.label.sales.slipyn" default="기표여부"/>'				, type: 'string'},
				 {name: 'COLET_CUST_CD'	,text: '<t:message code="system.label.sales.collectionplace" default="수금처"/>'		, type: 'string'},
				 {name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.declaredivisioncode" default="신고사업장"/>'	, type: 'string', comboType: 'BOR120'},
				 {name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			, type: 'string'},
				 {name: 'SALE_PRSN'		,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string'},
				 {name: 'MODI_REASON'	,text: '<t:message code="system.label.sales.updatereason" default="수정사유"/>'			, type: 'string'}
		]
	});

	//검색창 스토어 정의
	var billNoMasterStore = Unilite.createStore('ssa561ukrvBillNoMasterStore', {
		model	: 'billNoMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api: {
				read : 'ssa561ukrvService.selectBillNoMasterList'
			}
		},
		loadStoreRecords : function() {
			var param= billNosearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	//검색창 그리드 정의
	var billNoMasterGrid = Unilite.createGrid('ssa561ukrvBillNoMasterGrid', {
		store	: billNoMasterStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: false
		},
		columns	: [
			{ dataIndex: 'DIV_NAME'		, width: 100 },
			{ dataIndex: 'CUSTOM_NAME'	, width: 106 },
			{ dataIndex: 'PUB_NUM'		, width: 100 },
			{ dataIndex: 'BILL_FLAG'	, width: 73 },
			{ dataIndex: 'BILL_TYPE'	, width: 100 },
			{ dataIndex: 'BILL_DATE'	, width: 73 },
			{ dataIndex: 'PUB_DATE'		, width: 146 },
			{ dataIndex: 'SALE_DIV_CODE', width: 80 },
			{ dataIndex: 'PROJECT_NO'	, width: 100 },
			{ dataIndex: 'EX_YN'		, width: 66 },
			{ dataIndex: 'COLET_CUST_CD', width: 110 },
			{ dataIndex: 'DIV_CODE'		, width: 73, hidden:true },
			{ dataIndex: 'CUSTOM_CODE'  , width: 73, hidden:true },
			{ dataIndex: 'SALE_PRSN'	, width: 73, hidden:true },
			{ dataIndex: 'MODI_REASON'  , width:100 }
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				billNoMasterGrid.returnData(record);
				var param = {
					BILL_DIV_CODE : panelSearch.getValue('BILL_DIV_CODE'),
					PUB_NUM : 		panelSearch.getValue('PUB_NUM')
				}
				ssa561ukrvService.selectMasterList(param, function(provider, response) {
					detailStore.fnMasterSet(provider);
				});
				UniAppManager.app.onQueryButtonDown();
				searchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			panelSearch.setValue('SALE_DIV_CODE', record.get('SALE_DIV_CODE'));
			UniAppManager.app.fnSaleDivCode_onChange();
			UniAppManager.app.fnRecordComBo();
			panelSearch.setValue('BILL_DIV_CODE', record.get('DIV_CODE'));
			panelSearch.setValue('PUB_NUM', record.get('PUB_NUM'));
			panelSearch.setValue('SALE_PRSN', record.get('SALE_PRSN'));

			gsOriginalPubNum = record.get('ORIGINAL_PUB_NUM');
		}
	});

	//검색창 메인
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.billnosearch" default="계산서번호검색"/>',
				width	: 930,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [billNosearch, billNoMasterGrid],
				tbar	: ['->',{
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						billNoMasterStore.loadStoreRecords();
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
						billNosearch.clearForm();
						billNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						billNosearch.clearForm();
						billNoMasterGrid.reset();
					},
					show: function( panel, eOpts ) {
						billNosearch.setValue('CUSTOM_CODE'		, panelSearch.getValue('CUSTOM_CODE'));
						billNosearch.setValue('CUSTOM_NAME'		, panelSearch.getValue('CUSTOM_NAME'));
						billNosearch.setValue('FR_SALE_DATE'	, UniDate.get('startOfMonth', panelSearch.getValue('WRITE_DATE')));
						billNosearch.setValue('TO_SALE_DATE'	, panelSearch.getValue('WRITE_DATE'));
						billNosearch.setValue('SALE_DIV_CODE'	, panelSearch.getValue('SALE_DIV_CODE'));
						billNosearch.setValue('BILL_DIV_CODE'	, panelSearch.getValue('BILL_DIV_CODE'));
					}
				}
			});
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
	}



	//참조내역 폼 정의
	var referSearch = Unilite.createSearchForm('referForm', {
		layout	:  {type : 'uniTable', columns : 3},
		items	:[{
			fieldLabel	: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>',
			xtype		: 'uniCombobox',
			name		: 'SALE_DIV_CODE',
			comboType	: 'BOR120'
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel	: '<t:message code="system.label.sales.item" default="품목"/>',
			colspan		: 2,
			validateBlank: false
		}),{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			xtype		: 'uniCombobox',
			name		: 'SALE_PRSN',
			comboType	: 'AU',
			comboCode	: 'S010'
		}, 
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			valueFieldName	: 'PROJECT_NO',
			textFieldName	: 'PROJECT_NAME',
			DBvalueFieldName: 'PJT_CODE',
			DBtextFieldName	: 'PJT_NAME',
			colspan			: 2,
			validateBlank	: false,
			textFieldOnly	: false,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup) {
				},
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
			xtype		: 'uniCombobox',
			name		: 'ITEM_LEVEL1',
			store		: Ext.data.StoreManager.lookup('ssa561ukrvLevel1Store'),
			child		: 'ITEM_LEVEL2'
		},{
			fieldLabel	: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
			xtype		: 'uniCombobox',
			name		: 'ITEM_LEVEL2',
			store		: Ext.data.StoreManager.lookup('ssa561ukrvLevel2Store'),
			child		: 'ITEM_LEVEL3'
		},{
			fieldLabel	: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
			xtype		: 'uniCombobox',
			name		: 'ITEM_LEVEL3',
			store		: Ext.data.StoreManager.lookup('ssa561ukrvLevel3Store')
		},{
			fieldLabel	: '<t:message code="system.label.purchase.currency" default="화폐"/>',
			name		: 'MONEY_UNIT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B004',
			hidden		: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.exchangerate" default="환율"/>',
			xtype		: 'uniNumberfield',
			name		: 'EXCHG_RATE_O',
			type		: 'uniER',
			hidden		: true
		}]
	});

	//참조내역 모델 정의
	Unilite.defineModel('ssa561ukrvReferModel', {
		fields: [
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>'			, type: 'string', comboType: 'BOR120' },
			{name: 'BILL_NUM'			,text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'					, type: 'string'},
			{name: 'BILL_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'						, type: 'string'},
			{name: 'SALE_DATE'			,text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'					, type: 'uniDate'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'						, type: 'string'},
			{name: 'SALE_Q'				,text: '<t:message code="system.label.sales.qty" default="수량"/>'						, type: 'uniQty'},

			//20181029 추가
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'				, type: 'string'/*, comboType: 'AU', comboCode: 'B004'*/},
			{name: 'SALE_AMT_O'			,text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'				, type: 'uniPrice'},
			{name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'				, type: 'uniER'},
			 
			{name: 'PRICE_YN'			,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string', comboType: 'AU', comboCode: 'S003'},
			{name: 'SALE_P'				,text: '<t:message code="system.label.sales.price" default="단가"/>'						, type: 'uniUnitPrice'},
			{name: 'SALE_LOC_AMT_I'		,text: '<t:message code="system.label.sales.exchangeamount" default="환산액"/>'			, type: 'uniPrice'},
			{name: 'TAX_TYPE'			,text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'			, type: 'string', comboType: 'AU', comboCode: 'B059'},
			{name: 'TAX_AMT_O'			,text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'				, type: 'uniPrice'},
			{name: 'INOUT_NUM'			,text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'					, type: 'string'},
			{name: 'INOUT_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'						, type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'						, type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'PROJECT_NAME'		,text: '<t:message code="system.label.sales.projectname" default="프로젝트명"/>'				, type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.sales.remarks" default="비고"/>'					, type: 'string'},
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'					, type: 'string'},
			{name: 'INOUT_TYPE'			,text: '<t:message code="system.label.sales.trantype" default="수불유형"/>'					, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'				, type: 'string'},
			{name: 'SALE_UNIT'			,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'				, type: 'string'},
			{name: 'TRANS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				, type: 'uniQty'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'					, type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.client" default="고객"/>'						, type: 'string'},
			{name: 'ORDER_PRSN'			,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'				, type: 'string'},
			{name: 'OUT_DIV_CODE'		,text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'			, type: 'string'},
			{name: 'PRICE_TYPE'			,text: '<t:message code="system.label.sales.pricecalculationtype" default="단가계산구분"/>'	, type: 'string'},
			{name: 'UNIT_WGT'			,text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>'				, type: 'string'},
			{name: 'WGT_UNIT'			,text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'				, type: 'string'},
			{name: 'UNIT_VOL'			,text: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'				, type: 'string'},
			{name: 'VOL_UNIT'			,text: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>'				, type: 'string'},
			{name: 'SALE_WGT_Q'			,text: '<t:message code="system.label.sales.qty" default="수량"/>(<t:message code="system.label.sales.weight" default="중량"/>)'		, type: 'uniQty'},
			{name: 'SALE_FOR_WGT_P'		,text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'			, type: 'uniUnitPrice'},
			{name: 'SALE_WGT_P'			,text: '<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.weight" default="중량"/>)'	, type: 'uniPrice'},
			{name: 'SALE_VOL_Q'			,text: '<t:message code="system.label.sales.qty" default="수량"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'		, type: 'uniQty'},
			{name: 'SALE_FOR_VOL_P'		,text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'			, type: 'uniUnitPrice'},
			{name: 'SALE_VOL_P'			,text: '<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'	, type: 'uniUnitPrice'}
		]
	});

	//참조내역 스토어 정의
	var referStore = Unilite.createStore('ssa561ukrvReferStore', {
		model	: 'ssa561ukrvReferModel',
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
				read	: 'ssa561ukrvService.selectReferList'
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
								if( (record.data['BILL_NUM'] == item.data['BILL_NUM'])) {		// record = masterRecord	item = 참조 Record
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
			var taxInPutFormParams = panelSearch.getValues();	//param.TAX_BILL 가져오려고..getvalue로 못가져옴..
			var param = {
				SALE_FR_DATE	: UniDate.getDbDateStr(panelSearch.getValue('FR_SALE_DATE')),
				SALE_TO_DATE	: UniDate.getDbDateStr(panelSearch.getValue('TO_SALE_DATE')),
				BILL_DIV_CODE	: panelSearch.getValue('BILL_DIV_CODE'),
				SALE_DIV_CODE	: referSearch.getValue('SALE_DIV_CODE'),
				CUSTOM_CODE		: panelSearch.getValue('CUSTOM_CODE'),
				TAX_BILL		: taxInPutFormParams.TAX_BILL,
				PLAN_NUM		: panelSearch.getValue('PROJECT_NO'),
				ITEM_CODE		: referSearch.getValue('ITEM_CODE'),
				ITEM_NAME		: referSearch.getValue('ITEM_NAME'),
				ITEM_LEVEL1		: referSearch.getValue('ITEM_LEVEL1'),
				ITEM_LEVEL2		: referSearch.getValue('ITEM_LEVEL2'),
				ITEM_LEVEL3		: referSearch.getValue('ITEM_LEVEL3'),
				SALE_PRSN		: referSearch.getValue('SALE_PRSN'),
				PROJECT_NO		: referSearch.getValue('PROJECT_NO'),
				PROJECT_NAME	: referSearch.getValue('PROJECT_NAME'),
				MONEY_UNIT		: referSearch.getValue('MONEY_UNIT'),
				EXCHG_RATE_O	: referSearch.getValue('EXCHG_RATE_O')
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	//참조내역 그리드 정의
	var referGrid = Unilite.createGrid('ssa561ukrvReferGrid', {
		store	: referStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly		: false,
			toggleOnClick	: false,
			mode			: 'SIMPLE',
			listeners		: {
				beforeselect : function( me, record, index, eOpts ){	//선택된 합계금액 set
				},
				beforedeselect : function( me, record, index, eOpts ){
				}
			}
		}),
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns: [
			{ dataIndex: 'DIV_CODE'			, width: 90 },
			{ dataIndex: 'BILL_NUM'			, width: 120 },
			{ dataIndex: 'BILL_SEQ'			, width: 50, align: 'center' },
			{ dataIndex: 'SALE_DATE'		, width: 80 },
			{ dataIndex: 'ITEM_CODE'		, width: 110 },
			{ dataIndex: 'ITEM_NAME'		, width: 150 },
			{ dataIndex: 'SPEC'				, width: 120 },
			{ dataIndex: 'PRICE_YN'			, width: 73 },
			{ dataIndex: 'SALE_Q'			, width: 60 },
				  
			//20181029 추가 (MONEY_UNIT)
			{ dataIndex: 'MONEY_UNIT'		, width: 80, align: 'center'},

			{ dataIndex: 'SALE_P'			, width: 106},
			
			//20181029 추가 (SALE_AMT_O, EXCHG_RATE_O)
			{ dataIndex: 'SALE_AMT_O'		, width: 106},
			{ dataIndex: 'EXCHG_RATE_O'		, width: 106},
			  
			{ dataIndex: 'SALE_LOC_AMT_I'	, width: 120 },
			{ dataIndex: 'TAX_TYPE'			, width: 66, align: 'center' },
			{ dataIndex: 'TAX_AMT_O'		, width: 120 },
			{ dataIndex: 'INOUT_NUM'		, width: 120 },
			{ dataIndex: 'INOUT_SEQ'		, width: 60 },
			{ dataIndex: 'ORDER_NUM'		, width: 120 },
			{ dataIndex: 'PROJECT_NO'		, width: 100},
			{ dataIndex: 'PROJECT_NAME'		, width: 166, hidden: true  },
			{ dataIndex: 'REMARK'			, width: 66, hidden: true },
			{ dataIndex: 'COMP_CODE'		, width: 66, hidden: true },
			{ dataIndex: 'INOUT_TYPE'		, width: 66, hidden: true },
			{ dataIndex: 'INOUT_TYPE_DETAIL', width: 66, hidden: true },
			{ dataIndex: 'SALE_UNIT'		, width: 66, hidden: true },
			{ dataIndex: 'TRANS_RATE'		, width: 66, hidden: true },
			{ dataIndex: 'WH_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'CUSTOM_CODE'		, width: 66, hidden: true },
			{ dataIndex: 'ORDER_PRSN'		, width: 66, hidden: true },
			{ dataIndex: 'OUT_DIV_CODE'		, width: 66, hidden: true },
			{ dataIndex: 'PRICE_TYPE'		, width: 66, hidden: true },
			{ dataIndex: 'UNIT_WGT'			, width: 66, hidden: true },
			{ dataIndex: 'WGT_UNIT'			, width: 66, hidden: true },
			{ dataIndex: 'UNIT_VOL'			, width: 66, hidden: true },
			{ dataIndex: 'VOL_UNIT'			, width: 66, hidden: true },
			{ dataIndex: 'SALE_WGT_Q'		, width: 66, hidden: true },
			{ dataIndex: 'SALE_FOR_WGT_P'	, width: 66, hidden: true },
			{ dataIndex: 'SALE_WGT_P'		, width: 66, hidden: true },
			{ dataIndex: 'SALE_VOL_Q'		, width: 66, hidden: true },
			{ dataIndex: 'SALE_FOR_VOL_P'	, width: 66, hidden: true },
			{ dataIndex: 'SALE_VOL_P'		, width: 66, hidden: true }
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
			detailStore.fnOrderAmtSum();
			UniAppManager.app.fnSetEnableNewBtn("N", 0, records);
			this.deleteSelectedRow();
		}
	});

	//참조내역 메인
	function openReferWindow() {
		if(!panelSearch.setAllFieldsReadOnly(true)) return false;
		if(!referWindow) {
			referWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.salesreference" default="매출참조"/>',
				width	: 930,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [referSearch, referGrid],
				tbar	: [{
						xtype	: 'button',
						text	: '<t:message code="system.label.sales.allapply1" default="일괄적용"/>',
						id		: 'directQuery',
						itemId	: 'directQuery',
//						width	: 80,
						handler	: function() {
							var taxInPutFormParams = panelSearch.getValues();	//param.TAX_BILL 가져오려고..getvalue로 못가져옴..
							var param = {
								SALE_FR_DATE	: UniDate.getDbDateStr(panelSearch.getValue('FR_SALE_DATE')),
								SALE_TO_DATE	: UniDate.getDbDateStr(panelSearch.getValue('TO_SALE_DATE')),
								BILL_DIV_CODE	: panelSearch.getValue('BILL_DIV_CODE'),
								SALE_DIV_CODE	: referSearch.getValue('SALE_DIV_CODE'),
								CUSTOM_CODE		: panelSearch.getValue('CUSTOM_CODE'),
								TAX_BILL		: taxInPutFormParams.TAX_BILL,
								PLAN_NUM		: panelSearch.getValue('PROJECT_NO'),
								ITEM_CODE		: referSearch.getValue('ITEM_CODE'),
								ITEM_NAME		: referSearch.getValue('ITEM_NAME'),
								ITEM_LEVEL1		: referSearch.getValue('ITEM_LEVEL1'),
								ITEM_LEVEL2		: referSearch.getValue('ITEM_LEVEL2'),
								ITEM_LEVEL3		: referSearch.getValue('ITEM_LEVEL3'),
								SALE_PRSN		: referSearch.getValue('SALE_PRSN'),
								PROJECT_NO		: referSearch.getValue('PROJECT_NO'),
								PROJECT_NAME	: referSearch.getValue('PROJECT_NAME'),
								MONEY_UNIT		: referSearch.getValue('MONEY_UNIT'),
								EXCHG_RATE_O	: referSearch.getValue('EXCHG_RATE_O')
							}

							referGrid.reset();
							referSearch.clearForm();
							referWindow.hide();
							
							//main에서 직접 조회로직 추가
							fnGetRefDirect(param);
						}
				},'->',{
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						referStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.detailsapply" default="내역적용"/>',
					handler	: function() {
						referGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.sales.afterapplyclose" default="적용 후 닫기"/>',
					handler	: function() {
						referGrid.returnData();
						referWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						if(detailStore.getCount() == 0){
							panelSearch.setAllFieldsReadOnly(false);
						}
						referWindow.hide();
					},
					disabled: false
				}],
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
						var mRecords = detailStore.data.items;
						if(mRecords.length != 0) {
							Ext.getCmp('directQuery').disable();
						} else {
							Ext.getCmp('directQuery').enable();
						}
						referSearch.setValue('SALE_DIV_CODE', panelSearch.getValue('SALE_DIV_CODE'));
						referSearch.setValue('MONEY_UNIT'	, panelSearch.getValue('MONEY_UNIT'));
						referSearch.setValue('EXCHG_RATE_O'	, panelSearch.getValue('EXCHG_RATE_O'));
					}
				}
			})
		}
		referWindow.center();
		referWindow.show();
	}



	/** main app
	 */
	Unilite.Main({
		id			: 'ssa561ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelSearch, amtForm, detailGrid
			]
		}],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('newData', false);
//			detailGrid.disabledLinkButtons(false);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			var pubNum = panelSearch.getValue('PUB_NUM');
			
			if(Ext.isEmpty(pubNum)) {
				openSearchInfoWindow()
				
			} else {
				isLoad = true;
				var param = {
					BILL_DIV_CODE : panelSearch.getValue('BILL_DIV_CODE'),
					PUB_NUM : 		pubNum
				}
				ssa561ukrvService.selectMasterList(param, function(provider, response) {
					detailStore.fnMasterSet(provider);
				});
				detailStore.loadStoreRecords();
			}
		},
		onNewDataButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)) return false;
			if(!Ext.isEmpty(panelSearch.getValue('EX_DATE'))) {
				Unilite.messageBox('<t:message code="system.message.sales.message105" default="회계전표가 생성된 계산서발행자료는 수정/삭제할 수 없습니다."/>');
			} else if(gsColetAmt > 0) {
				Unilite.messageBox('<t:message code="system.message.sales.message106" default="수금이 진행된 계산서발행자료는 삭제할 수 없습니다."/>');
			} else {
				var r = {};
				var record = detailStore.data.items[0];
				if(record){
					r = {
						DIV_CODE			: record.get('DIV_CODE'),
						BILL_NUM			: record.get('BILL_NUM'),
						PUB_NUM				: record.get('PUB_NUM'),
						REMARK				: record.get('REMARK'),
						RECEIPT_PLAN_DATE	: record.get('RECEIPT_PLAN_DATE'),
						PROJECT_NO			: record.get('PROJECT_NO'),
						PROJECT_NAME		: record.get('PROJECT_NAME'),
						BILL_DIV_CODE		: record.get('BILL_DIV_CODE'),
						COMP_CODE			: record.get('COMP_CODE'),
						CUSTOM_CODE			: record.get('CUSTOM_CODE'),
						ORDER_PRSN			: record.get('ORDER_PRSN'),
						OUT_DIV_CODE		: record.get('OUT_DIV_CODE')
					 };
				 }
				detailGrid.createRow(r);
				if(!UniAppManager.app.getTopToolbar().getComponent('newData').isDisabled( )){
					UniAppManager.setToolbarButtons('newData', false);
				}
				panelSearch.setAllFieldsReadOnly(true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.clearForm();
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitBinding();
//			panelSearch.getField('CUSTOM_CODE').focus();
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			if(!Ext.isEmpty(panelSearch.getValue('EX_DATE'))) {
				Unilite.messageBox('<t:message code="system.message.sales.message105" default="회계전표가 생성된 계산서발행자료는 수정/삭제할 수 없습니다."/>');
			
			} else if(gsColetAmt > 0) {
				Unilite.messageBox('<t:message code="system.message.sales.message106" default="수금이 진행된 계산서발행자료는 삭제할 수 없습니다."/>');
			
			} else {
				var selRow = detailGrid.getSelectedRecord();
				if(selRow.phantom === true) {
					detailGrid.deleteSelectedRow();
			
				} else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					detailGrid.deleteSelectedRow();
				}
				detailStore.fnOrderAmtSum();
			}
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{								//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						if(!Ext.isEmpty(panelSearch.getValue('EX_DATE'))) {
							Unilite.messageBox('<t:message code="system.message.sales.message105" default="회계전표가 생성된 계산서발행자료는 수정/삭제할 수 없습니다."/>');
						} else if(gsColetAmt > 0) {
							Unilite.messageBox('<t:message code="system.message.sales.message106" default="수금이 진행된 계산서발행자료는 삭제할 수 없습니다."/>');
						/*---------삭제전 로직 구현 끝----------*/
						}else{
							if(deletable){
								detailGrid.reset();
								detailStore.fnOrderAmtSum();
								UniAppManager.app.onSaveDataButtonDown();
							}
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('ssa561ukrvAdvanceSerch');
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
  				bdc100ukrvService.getFileList({DOC_NO : selected_doc_no},function(provider, response) {
				});
			}
			detailStore.onStoreActionEnable();
		},
		confirmSaveData: function(config) {
			var fp = Ext.getCmp('ssa561ukrvFileUploadPanel');
			if(detailStore.isDirty() || fp.isDirty()) {
				if(confirm(2)) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
			panelSearch.setValue('SALE_DIV_CODE'	, UserInfo.divCode);
			UniAppManager.app.fnSaleDivCode_onChange();
			panelSearch.setValue('TO_SALE_DATE'		, new Date());
			panelSearch.setValue('FR_SALE_DATE'		, UniDate.get('startOfMonth', panelSearch.getValue('TO_SALE_DATE')));
			panelSearch.setValue('SALE_AMT'			, 0);
			panelSearch.setValue('SALE_TAX'			, 0);
			panelSearch.setValue('BILL_TYPE'		, '1');				//세금계산서구분
			gsBillDivChgYN = 'N'										//신고사업장 변경여부
			panelSearch.setValue('WRITE_DATE'		, new Date());		//작성일
			gsLastDate = panelSearch.getValue('WRITE_DATE');
			panelSearch.setValue('MONEY_UNIT'		, BsaCodeInfo.gsMoneyUnit);
			panelSearch.setValue('EXCHG_RATE_O'		, '1');

			if(BsaCodeInfo.gsBillYn == 'Y'){
				Ext.getCmp('billType').setReadOnly(false);
			} else {
				Ext.getCmp('billType').setReadOnly(false);
			}
			Ext.getCmp('bfIssue').hide();								//당초승인번호
			panelSearch.getField('UPDATE_REASON').setReadOnly(true);	//수정사유
			amtForm.setValue('SALE_LOC_TOT_DIS'		, 0);
			panelSearch.getField('TAX_BILL').setValue('1');				//과세구분
			amtForm.getField('CLAIM_YN').setValue('2');					// 영수,청구 선택
//			panelSearch.getField("RDO_CLAIM_YN").setReadOnly(true);  영수,청구 READONLY	////테스트후 풀것

			gsColetAmt = 0;
			panelSearch.down('#btnAccnt').setDisabled(true);
			panelSearch.down('#btnCancel').setDisabled(true);


			UniAppManager.app.fnRecordComBo();							//신고사업장 가져오기
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();

			Ext.getCmp('rdoTaxType1').setReadOnly(false);
			Ext.getCmp('rdoTaxType2').setReadOnly(false);
			Ext.getCmp('rdoTaxType3').setReadOnly(false);

			panelSearch.setAllFieldsReadOnly(false);

			Ext.getCmp('rdoIn').setReadOnly(true);
			UniAppManager.setToolbarButtons('save', false);
			Ext.getCmp('labelText').setText('');
			gsStatusM = "N"
			gsSaveRefFlag = 'N';
			panelSearch.getField('REMARK').allowBlank = true;			// 폼의 allowBlank통제 하려면?
			//수정사유  readOnly, allowBlank 세팅
			panelSearch.setValue('UPDATE_REASON', '');
			panelSearch.getField('UPDATE_REASON').setReadOnly(true);
			panelSearch.getField('UPDATE_REASON').allowBlank = true;

			panelSearch.getField('BILL_TYPE').setReadOnly(isDisable);
		},
		fnSaleDivCode_onChange: function(){								//참조탭 매출사업장 설정
			referSearch.setValue('SALE_DIV_CODE', panelSearch.getValue('SALE_DIV_CODE'));
		},
		fnRecordComBo: function(){										//신고사업장 가져오기
			if(BsaCodeInfo.gsBillDivChgYN == "Y") return false;			//신고사업장 변경여부가 '아니오'일 경우만 자동으로 변경함
			var param = panelSearch.getValues();
			ssa561ukrvService.selectBillDivList(param, function(provider, response) {
				if(Ext.isEmpty(provider)) return false;
				panelSearch.setValue('BILL_DIV_CODE', provider.data.BILL_DIV_CODE);
				UniAppManager.app.billDivCode_onChange();				//사업장정보 쿼리 조회후 set
			});
		},
		billDivCode_onChange: function(){								//신고사업장 정보 가져오기
			if(Ext.isEmpty(panelSearch.getValue('BILL_DIV_CODE'))){
				panelSearch.setValue('OWN_COM_NUM'		, '');
				panelSearch.setValue('OWN_TOP_NAME'		, '');
				panelSearch.setValue('OWN_ADDRESS'		, '');
				panelSearch.setValue('OWN_COMP_TYPE'	, '');
				panelSearch.setValue('OWN_COMP_CLASS'	, '');
				panelSearch.setValue('OWN_SERVANT_NUM'	, '');
				return false;
			}

			var param = panelSearch.getValues();
			ssa561ukrvService.selectBillDivInfo(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					var comNum = '';
					if(Ext.isEmpty(provider.data.COMPANY_NUM)){
						panelSearch.setValue('OWN_COM_NUM', '');
						
					} else {
						if(!Ext.isEmpty(provider.data.COMPANY_NUM) && provider.data.COMPANY_NUM.length == 10){
							rsComNum =  provider.data.COMPANY_NUM;
							comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
							panelSearch.setValue('OWN_COM_NUM', comNum);
							
						} else {
							comNum = provider.data.COMPANY_NUM;
							panelSearch.setValue('OWN_COM_NUM', comNum);
						}
					}
					panelSearch.setValue('OWN_TOP_NAME'		, provider.data.REPRE_NAME);
					panelSearch.setValue('OWN_ADDRESS'		, provider.data.ADDR);
					panelSearch.setValue('OWN_COMP_TYPE'	, provider.data.COMP_TYPE);
					panelSearch.setValue('OWN_COMP_CLASS'	, provider.data.COMP_CLASS);
					panelSearch.setValue('OWN_SERVANT_NUM'	, provider.data.SUB_DIV_NUM);
				}
			});
		},
		fnGetBillSendUseYNChk: function(){								//국세청전송완료체크 전 사용유무파악
			if(BsaCodeInfo.gsBillYn == "Y"){
				return true;
			} else {
				return false;
			}
		},
		fnGetBillSendCloseChk: function(){								//국세청전송완료건 체크
			var param = {BILL_SEQ : panelSearch.getValue("EB_NUM")};
			ssa561ukrvService.getBillSendCloseChk(param, function(provider, response) {
				if(Ext.isEmpty(provider)){
					return false;
					
				} else {
					var gsBillChk	= provider['REPORT_STAT'];
					var sBillGubun	= provider['BILL_GUBUN'];

					if(sBillGubun == "01"){
						if(!Ext.isEmpty(gsBillChk) && gsBillChk != "N"){
							return true;
						} else {
							return false;
						}
						
					} else if(sBillGubun == "02"){
						if(!Ext.isEmpty(gsBillChk)){
							return true;
						} else {
							return false;
						}
						
					} else {
						return false;
					}
				}
			});
		},
		fnSetEnableNewBtn: function(sAuTypeCheck, lAuTypeCnt, records){	//금액보정(AU) 유무 체크하여 [추가]버튼 활성화 처리
			if(!Ext.isEmpty(panelSearch.getValue('EX_DATE'))) return false;
			if(gsColetAmt > 0) return false;
			//this.getTopToolbar().getComponent('save').isDisabled( )
			if(sAuTypeCheck == "N"){
				lAuTypeCnt = 0;
				Ext.each(records, function(record,i){
					if(record.get('INOUT_TYPE_DETAIL') == "AU"){
						lAuTypeCnt = lAuTypeCnt + 1;
					}
				});
			}
			if(lAuTypeCnt == 0){
				if(UniAppManager.app.getTopToolbar().getComponent('newData').isDisabled()){
					UniAppManager.setToolbarButtons('newData', true);
				}
			} else {
				if(!UniAppManager.app.getTopToolbar().getComponent('newData').isDisabled()){
					UniAppManager.setToolbarButtons('newData', false);
				}
			}
		},
		fnRcptDateCal: function(gsCollectDay){
			if(gsCollectDay.length == 1){
				gsCollectDay = "0" + gsCollectDay;
			}

			if(!Ext.isEmpty(gsCollectDay)){
				if(!Ext.isEmpty(panelSearch.getValue('WRITE_DATE'))){
					var sYearMonth = UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE')).substring(0, 6);
					var sDay = UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE')).substring(6, 8);
					if(BsaCodeInfo.gsCollectDayFlg == "1"){
						if(sDay >= gsCollectDay){
							panelSearch.setValue('TEMP_COL_DATE'	, sYearMonth + gsCollectDay);												//text를 날짜형식으로 set해주기 위해
							panelSearch.setValue('RECEIPT_PLAN_DATE', UniDate.add(panelSearch.getValue('TEMP_COL_DATE'), {months:+1}));
						} else {
							panelSearch.setValue('TEMP_COL_DATE'	, sYearMonth + gsCollectDay);												//text를 날짜형식으로 set해주기 위해
							panelSearch.setValue('RECEIPT_PLAN_DATE', panelSearch.getValue('TEMP_COL_DATE'));
						}
						
					} else if(BsaCodeInfo.gsCollectDayFlg == "2"){
							panelSearch.setValue('TEMP_COL_DATE'	, panelSearch.getValue('WRITE_DATE'));										//text를 날짜형식으로 set해주기 위해
							panelSearch.setValue('RECEIPT_PLAN_DATE', UniDate.add(panelSearch.getValue('TEMP_COL_DATE'), {days:+parseInt(gsCollectDay)}));
					}
				}
			}
		},
		fnGetParamMaster: function(){
			var taxInPutFormParams = panelSearch.getValues();	//param.TAX_BILL 가져오려고..getvalue로 못가져옴..
			var taxBill = '';
			if(taxInPutFormParams.TAX_BILL == "1"){
				taxBill	= '11';
			} else if(taxInPutFormParams.TAX_BILL == "2"){
				taxBill	= '20';
			} else if(taxInPutFormParams.TAX_BILL == "3"){
				taxBill	= '12';
			}
			var beforePubNum = panelSearch.getValue('BILL_TYPE') == "1" ? "" : gsBeforePubNum;
			var originPubNum = panelSearch.getValue('BILL_TYPE') == "1" ? "" : gsOriginalPubNum ;
			var paramMaster = {
				  FLAG					: gsStatusM
				, DIV_CODE				: panelSearch.getValue('BILL_DIV_CODE')
				, PUB_NUM				: panelSearch.getValue('PUB_NUM')
				, BILL_TYPE				: taxBill
				, BILL_DATE				: UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE'))
				, PUB_FR_DATE			: UniDate.getDbDateStr(panelSearch.getValue('FR_SALE_DATE'))
				, PUB_TO_DATE			: UniDate.getDbDateStr(panelSearch.getValue('TO_SALE_DATE'))
				, CUSTOM_CODE			: panelSearch.getValue('CUSTOM_CODE')
				, SALE_AMT_O			: sSaleAmt
				, SALE_LOC_AMT_I		: Unilite.multiply(sSaleAmt, panelSearch.getValue('EXCHG_RATE_O'))
				, TAX_AMT_O				: sTaxAmt
				, COLET_CUST_CD			: CustomCodeInfo.gsCollector
				, REMARK				: panelSearch.getValue('REMARK')
				, PROJECT_NO			: panelSearch.getValue('PROJECT')
				, UPDATE_DB_USER		: UserInfo.userID
				, SALE_DIV_CODE			: panelSearch.getValue('SALE_DIV_CODE')
				, COLLECT_CARE			: CustomCodeInfo.gsColetCare
				, RECEIPT_PLAN_DATE		: UniDate.getDbDateStr(panelSearch.getValue('RECEIPT_PLAN_DATE'))
				, TAX_CALC_TYPE			: CustomCodeInfo.gsTaxCalcType
				, SALE_PROFIT			: '*'
				, COMP_CODE				: UserInfo.compCode
				, BILL_FLAG				: panelSearch.getValue('BILL_TYPE')
				, MODI_REASON			: panelSearch.getValue('UPDATE_REASON')
				, SALE_PRSN				: panelSearch.getValue('SALE_PRSN')
				, PROJECT_NO			: gsPjtCode
				, SERVANT_COMPANY_NUM	: panelSearch.getValue('OWN_SERVANT_NUM')
				, BFO_ISSU_ID			: panelSearch.getValue('BF_ISSUE')
				, BEFORE_PUB_NUM		: beforePubNum
				, ORIGIN_PUB_NUM		: originPubNum
				//20181029 추가
				, MONEY_UNIT			: panelSearch.getValue('MONEY_UNIT')
				, EXCHG_RATE_O			: panelSearch.getValue('EXCHG_RATE_O')
			}
			return paramMaster;
		},
		fnModifyUpdatechange: function(){
			var pubNum = '';
			if(gsStatusM == "D"){
				pubNum = panelSearch.getValue('PUB_NUM');
			} else {
				pubNum = gsBeforePubNum;
			}
			var param = {
				  M_FLAG			: gsStatusM
				, M_COMP_CODE		: UserInfo.compCode
				, M_DIV_CODE		: panelSearch.getValue('SALE_DIV_CODE')
				, M_PUB_NUM			: pubNum
				, M_ORIGIN_PUB_NUM	: gsOriginalPubNum
				, M_SALE_PRSN		: panelSearch.getValue('SALE_PRSN')
				, M_REMARK			: panelSearch.getValue('REMARK')
				, M_USER_ID			: UserInfo.userID
				, M_BFO_ISSU_ID		: panelSearch.getValue('BF_ISSUE')
				, M_MODE			: 'modifyUpdate'
			}
			panelSearch.submit({
				params	: param,
				success	: function(comp, action) {
					panelSearch.setValue('PUB_NUM', action.result.PUB_NUM);
					UniAppManager.setToolbarButtons('save', false);
				},
				failure: function(form, action){
				}
			});
		},
		fnContractCancel: function(){		//수정발행
			var pubNum = '';
			if(gsStatusM == "D"){
				pubNum = panelSearch.getValue('PUB_NUM');
			} else {
				pubNum = gsBeforePubNum;
			}
//			panelSearch.setValue('PUB_NUM', pubNum);
			var param = {
				  M_FLAG			: gsStatusM
				, M_COMP_CODE		: UserInfo.compCode
				, M_DIV_CODE		: panelSearch.getValue('SALE_DIV_CODE')
				, M_PUB_NUM			: pubNum
				, M_ORIGIN_PUB_NUM	: gsOriginalPubNum
				, M_SALE_PRSN		: panelSearch.getValue('SALE_PRSN')
				, M_REMARK			: panelSearch.getValue('REMARK')
				, M_USER_ID			: UserInfo.userID
				, M_MAKE_DATE		: UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE'))
				, M_BFO_ISSU_ID		: panelSearch.getValue('BF_ISSUE')
				, M_MODI_REASON		: panelSearch.getValue('UPDATE_REASON')
				, M_MODE			: 'contractCancel'
			}
			panelSearch.submit({
				params	: param,
				success	: function(comp, action) {
					panelSearch.setValue('PUB_NUM', action.result.PUB_NUM);
					UniAppManager.setToolbarButtons('save', false);
				},
				failure: function(form, action){
				}
			});
		},
		fnMasterSave: function(paramMaster){
			var taxInPutFormParams = panelSearch.getValues();	//param.TAX_BILL 가져오려고..getvalue로 못가져옴..
			var taxBill = '';
			if(taxInPutFormParams.TAX_BILL == "1"){
				taxBill	= '11';
			}else if(taxInPutFormParams.TAX_BILL == "2"){
				taxBill	= '20';
			}else if(taxInPutFormParams.TAX_BILL == "3"){
				taxBill	= '12';
			}
			var beforePubNum = panelSearch.getValue('BILL_TYPE') == "1" ? "" : gsBeforePubNum;
			var originPubNum = panelSearch.getValue('BILL_TYPE') == "1" ? "" : gsOriginalPubNum ;
			var param = {
				  M_FLAG				: gsStatusM
				, M_DIV_CODE			: panelSearch.getValue('BILL_DIV_CODE')
				, M_PUB_NUM				: panelSearch.getValue('PUB_NUM')
				, M_BILL_TYPE			: taxBill
				, M_BILL_DATE			: UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE'))
				, M_PUB_FR_DATE			: UniDate.getDbDateStr(panelSearch.getValue('FR_SALE_DATE'))
				, M_PUB_TO_DATE			: UniDate.getDbDateStr(panelSearch.getValue('TO_SALE_DATE'))
				, M_CUSTOM_CODE			: panelSearch.getValue('CUSTOM_CODE')
				, M_SALE_AMT_O			: sSaleAmt
				, M_SALE_LOC_AMT_I		: Unilite.multiply(sSaleAmt, panelSearch.getValue('EXCHG_RATE_O'))
				, M_TAX_AMT_O			: sTaxAmt
				, M_COLET_CUST_CD		: CustomCodeInfo.gsCollector
				, M_REMARK				: panelSearch.getValue('REMARK')
				, M_PROJECT_NO			: panelSearch.getValue('PROJECT')
				, M_UPDATE_DB_USER		: UserInfo.userID
				, M_SALE_DIV_CODE		: panelSearch.getValue('SALE_DIV_CODE')
				, M_COLLECT_CARE		: CustomCodeInfo.gsColetCare
				, M_RECEIPT_PLAN_DATE	: UniDate.getDbDateStr(panelSearch.getValue('RECEIPT_PLAN_DATE'))
				, M_TAX_CALC_TYPE		: CustomCodeInfo.gsTaxCalcType
				, M_SALE_PROFIT			: '*'
				, M_COMP_CODE			: UserInfo.compCode
				, M_BILL_FLAG			: panelSearch.getValue('BILL_TYPE')
				, M_MODI_REASON			: panelSearch.getValue('UPDATE_REASON')
				, M_SALE_PRSN			: panelSearch.getValue('SALE_PRSN')
				, M_PROJECT_NO			: gsPjtCode
				, M_SERVANT_COMPANY_NUM	: panelSearch.getValue('OWN_SERVANT_NUM')
				, M_BFO_ISSU_ID			: panelSearch.getValue('BF_ISSUE')
				, M_BEFORE_PUB_NUM		: beforePubNum
				, M_ORIGIN_PUB_NUM		: originPubNum
				, M_MODE : ''
				//20181029 추가
				, M_MONEY_UNIT			: panelSearch.getValue('MONEY_UNIT')
				, M_EXCHG_RATE_O		: panelSearch.getValue('EXCHG_RATE_O')
			}
			panelSearch.submit({
				params: param,
				success:function(comp, action) {
//					panelSearch.setValue('PUB_NUM', action.result.PUB_NUM);
					UniAppManager.setToolbarButtons('save', false);
					UniAppManager.updateStatus('<t:message code="system.message.sales.message033" default="저장되었습니다."/>');
				},
				failure: function(form, action){
				}
			});
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelSearch.getValue('WRITE_DATE')),
				"MONEY_UNIT": panelSearch.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni && !Ext.isEmpty(panelSearch.getValue('MONEY_UNIT')) && panelSearch.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
						Unilite.messageBox('<t:message code="system.message.sales.datacheck008" default="환율정보가 없습니다."/>');
					}
					panelSearch.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
				}
			});
		}
	});



	function fnGetRefDirect(param) {
		gsRefFlag		= 'Y';
		param.gsRefFlag	= gsRefFlag;
		
		detailStore.loadStoreRecords(param);
	}



	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "SALE_LOC_AMT_I" :
//					if(newValue <= 0 && !Ext.isEmpty(newValue)) {
//						rv=Msg.sMB076;
//						break;
//					}
					break;

				case "TAX_AMT_O" :
//					if(newValue <= 0 && !Ext.isEmpty(newValue)) {
//						rv=Msg.sMB076;
//						break;
//					}
					break;
			}
			return rv;
		}
	}); // validator
}
</script>