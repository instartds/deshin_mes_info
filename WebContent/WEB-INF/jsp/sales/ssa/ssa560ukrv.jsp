<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa560ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa560ukrv"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" />						<!-- 세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S003" />						<!-- 단가구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S096" />						<!-- 세금계산서구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S095" />						<!-- 국세청수정사유 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />						<!--영업담당자-->
	<t:ExtComboStore comboType="AU" comboCode="B034" storeId="B034"/>		<!-- 결제조건 -->
	<t:ExtComboStore comboType="OU" />										<!-- 창고-->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />			<!-- 창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList"/>	<!-- 창고Cell-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="ssa560ukrvLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="ssa560ukrvLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="ssa560ukrvLevel3Store" />
</t:appConfig>

<script type="text/javascript">

var searchInfoWindow;	//searchInfoWindow : 검색창
var referWindow;		//참조내역


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

var outDivCode = UserInfo.divCode;
var gsSaleAmt = 0 ;
var gsSaveChk = true;
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
	var sSaleAmt		= 0;
	var sTaxAmt			= 0;
	var gsBeforePubNum	= '';			//계산서발행번호
	var gsOriginalPubNum=  '';			//원본계산서발행번호
	var gsSaveRefFlag	= 'N';			//검색후에만 수정 가능하게 조회버튼 활성화..
	var gsStatusM		= '';
	var delfag			= '';
	var linkFlag		= false;

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ssa560ukrvService.selectDetailList',
			update	: 'ssa560ukrvService.updateDetail',
			create	: 'ssa560ukrvService.insertDetail',
			destroy	: 'ssa560ukrvService.deleteDetail',
			syncAll	: 'ssa560ukrvService.saveAll'
		}
	});



	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		autoScroll	: true,
		border		: true,
		padding		: '1 1 1 1',
		layout		: {type : 'uniTable', columns : 2
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		items		: [{
			layout	: {type : 'uniTable', columns : 5},
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
				tdAttrs: {style: 'border-bottom: 1px solid #cccccc; padding-top: 0px; padding-bottom: 4px'  }
			},{
				fieldLabel		: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_SALE_DATE',
				endFieldName	: 'TO_SALE_DATE',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				allowBlank		: false,
				holdable		: 'hold',
				labelWidth		: 123,
				width			: 350,
				tdAttrs			: {style: 'border-bottom: 1px solid #cccccc; padding-top: 0px; padding-bottom: 4px'  }
			},{
				xtype	: 'component',
				width	: 182,
				tdAttrs	: {style: 'border-bottom: 1px solid #cccccc; padding-top: 0px; padding-bottom: 4px'  }
			}]
		},{
			xtype	: 'container' ,
			layout	: {type:'hbox', align:'stretched'},
			width	: 550,					//20200702 수정: 250 -> 550
			tdAttrs	: { },
			items	: [{
				xtype	: 'button',
				text	: '<t:message code="system.label.sales.salesslip" default="매출기표"/>',
				id		: 'btnAccnt',
				itemId	: 'btnAccnt',
				style	: {'margin-left':'50px'},
//				hidden	: true,
				width	: 80,
				handler	:function() {
					var billNum = panelResult.getValue("PUB_NUM");
					if(billNum) {
						var param = {
							BILL_DIV_CODE	: panelResult.getValue('BILL_DIV_CODE'),
							PUB_NUM			: panelResult.getValue('PUB_NUM')
						}
						ssa560ukrvService.selectMasterList(param, function(provider, response) {
							var exDate = UniDate.getDbDateStr(provider.EX_DATE);
							if(exDate == null || exDate =='') {
								var params = {
									'PGM_ID'		: 'ssa560ukrv',
									'sGubun'		: '30',
									'DIV_CODE'		: panelResult.getValue("SALE_DIV_CODE"),
									'BILL_DATE'		: UniDate.getDateStr(panelResult.getValue("WRITE_DATE")),
									'CUSTOM_CODE'	: panelResult.getValue("CUSTOM_CODE"),
									'BILL_TYPE'		: '10',
									'BILL_PUB_NUM'	: panelResult.getValue("PUB_NUM")
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
				style	: {'margin-left':'10px'},
//				hidden	: true,
				width	: 80,
				handler	:function() {
					var param = {
						BILL_DIV_CODE	: panelResult.getValue('BILL_DIV_CODE'),
						PUB_NUM			: panelResult.getValue('PUB_NUM')
					}
					ssa560ukrvService.selectMasterList(param, function(provider, response) {
						var exDate = UniDate.getDbDateStr(provider.EX_DATE);
						if(exDate != null && exDate !='') {
							var param = {
								'DIV_CODE'		: panelResult.getValue("SALE_DIV_CODE"),
								'BILL_DATE'		: UniDate.getDateStr(panelResult.getValue("WRITE_DATE")),
								'CUSTOM_CODE'	: panelResult.getValue("CUSTOM_CODE"),
								'BILL_TYPE'		: '10',
								'BILL_PUB_NUM'	: panelResult.getValue("PUB_NUM"),
								//20200302 추가: 에러메세지 표시
								'EBYN_MESSAGE'	: 'TRUE'
							}
							agj260ukrService.cancelAutoSlip30(param,function(responseText, response) {
								if(response.type == 'exception') {
									return false;
								} else {
									if(!Ext.isEmpty(responseText.ERROR_DESC) ) {
										if(responseText.EBYN_MESSAGE=="FALSE") {
											console.log(responseText.ERROR_DESC);
										}
									}else {
										Unilite.messageBox('<t:message code="system.message.sales.datacheck012" default="기표 취소되었습니다."/>');
										UniAppManager.app.onQueryButtonDown()
										//panelResult.down("#btnAccnt").setDisabled(false);
										//panelResult.down("#btnCancel").setDisabled(true);
									}
								}
							});
						} else {
							Unilite.messageBox('<t:message code="system.message.sales.message011" default="기표된 전표가 없습니다."/>');
						}
					});
				}
			}]
		},{
			xtype	: 'container',
			colspan	: 2,
			layout	: {type : 'uniTable', columns : 1},
			border	: true,
			padding	: '1 1 1 1',
			items	: [{
				xtype	: 'container',
				margin	: '0 0 0 0',
				layout	: {type : 'uniTable', columns : 4},
				items	: [{
					xtype: 'component',
					width: 10
				},{
					title	:'<t:message code="system.label.sales.supplyperson" default="공급자"/>',
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
						fieldLabel	: '<t:message code="system.label.sales.compkorname" default="상호(법인명)"/>',
						xtype		: 'uniCombobox',
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
					title	: '<t:message code="system.label.sales.receiver2" default="공급받는자"/>',
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
						allowBlank		: false,
						validateBlank	: false,
						readOnly		: false,
						//holdable		: 'hold',
						listeners		: {
							applyextparam: function(popup){
								popup.setExtParam({'SINGLE_CODE': true});
							},
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('CUSTOM_NAME', records[0]["CUSTOM_NAME"]);
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
										panelResult.setValue('CUST_COM_NUM', comNum);
									}else{
										comNum = records[0]["COMPANY_NUM"];
										panelResult.setValue('CUST_COM_NUM', comNum);
									}

									panelResult.setValue('CUST_TOP_NAME'	, records[0]["TOP_NAME"]);							//대표자
									panelResult.setValue('CUST_ADDRESS'		, records[0]["ADDR1"] + ' ' + records[0]["ADDR2"]);	//주소
									panelResult.setValue('CUST_COMP_TYPE'	, records[0]["COMP_TYPE"]);							//업태
									panelResult.setValue('CUST_COMP_CLASS'	, records[0]["COMP_CLASS"]);						//업종
									panelResult.setValue('CUST_SERVANT_NUM'	, records[0]["SERVANT_COMPANY_NUM"]);				//종사업장번호

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
										panelResult.setValue('BILL_DIV_CODE', records[0]["BILL_DIV_CODE"]);
										UniAppManager.app.billDivCode_onChange();
									}
									
									// 결제 조건
									if(!Ext.isEmpty(records[0]["RECEIPT_DAY"])){
										panelResult.setValue('PAY_TERMS', records[0]["RECEIPT_DAY"]);
									}
									// 결제 조건 값에 따른 결제 예정일 세팅
									fnControlPaymentDay(records[0]["RECEIPT_DAY"]);
								},
							scope: this
							},
							onClear: function(type) {		////onClear가 먹지 않음
								panelResult.setValue('CUSTOM_CODE', '');
							}
						}
					}),
					Unilite.popup('AGENT_CUST_SINGLE',{
						fieldLabel		: '<t:message code="system.label.sales.compkorname" default="상호(법인명)"/>',
						textFieldName	: 'CUSTOM_NAME',
						DBtextFieldName	: 'CUSTOM_NAME',
						allowBlank		: false,
						validateBlank	: false,
						readOnly		: false,
						holdable		: 'hold',
						listeners		: {
							applyextparam: function(popup){
								popup.setExtParam({'SINGLE_CODE': false});
							},
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('CUSTOM_CODE', records[0]["CUSTOM_CODE"]);
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
										panelResult.setValue('CUST_COM_NUM', comNum);
									}else{
										comNum = records[0]["COMPANY_NUM"];
										panelResult.setValue('CUST_COM_NUM', comNum);
									}

									panelResult.setValue('CUST_TOP_NAME'	, records[0]["TOP_NAME"]);							//대표자
									panelResult.setValue('CUST_ADDRESS'		, records[0]["ADDR1"] + ' ' + records[0]["ADDR2"]);	//주소
									panelResult.setValue('CUST_COMP_TYPE'	, records[0]["COMP_TYPE"]);							//업태
									panelResult.setValue('CUST_COMP_CLASS'	, records[0]["COMP_CLASS"]);						//업종
									panelResult.setValue('CUST_SERVANT_NUM'	, records[0]["SERVANT_COMPANY_NUM"]);				//종사업장번호

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
										panelResult.setValue('BILL_DIV_CODE', records[0]["BILL_DIV_CODE"]);
										UniAppManager.app.billDivCode_onChange();
									}
									
									// 결제 조건
									if(!Ext.isEmpty(records[0]["RECEIPT_DAY"])){
										panelResult.setValue('PAY_TERMS', records[0]["RECEIPT_DAY"]);
									}
									// 결제 조건 값에 따른 결제 예정일 세팅
									fnControlPaymentDay(records[0]["RECEIPT_DAY"]);
								},
								scope: this
							},
							onClear: function(type) {		////onClear가 먹지 않음
								panelResult.setValue('CUSTOM_CODE', '');
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
						fieldLabel	: '<t:message code="system.label.sales.paycondition" default="결제조건"/>',
						name		: 'PAY_TERMS',
						xtype		: 'uniCombobox',
						comboType	: 'AU',
						comboCode	: 'B034'
					},{
						xtype: 'container',
						items: [{
							fieldLabel	: '<t:message code="system.label.sales.bfissue" default="당초승인번호"/>',
							xtype		: 'uniTextfield',
							name		: 'BF_ISSUE',
							readOnly	: true,
							id			: 'bfIssue'
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
						xtype		: 'uniDatefield',
						name		: 'WRITE_DATE',
						fieldLabel	: '<t:message code="system.label.sales.publishdate" default="발행일"/>',
						allowBlank	: false,
						labelWidth	: 110,
//						holdable	: 'hold',
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
								var newValue1 = String(UniDate.getDbDateStr(newValue));
								newValue1 = newValue1.replace(".", "").replace(".", "");
								if(String(newValue1).length == 8){
									UniAppManager.app.fnRcptDateCal(CustomCodeInfo.gsCollectDay);
								}
								// 수금예정일 set
								fnControlPaymentDay(panelResult.getValue('PAY_TERMS'));
							}
						}
					},{	//20210527 추가
						xtype		: 'radiogroup',
//						holdable	: 'hold',
						itemId		: 'PRE_SEND_YN',
						fieldLabel	: '선발행 여부',
						items		: [{
							boxLabel	: '<t:message code="system.label.sales.yes" default="예"/>',
							name		: 'PRE_SEND_YN' ,
							inputValue	: 'Y',
							width		: 55
						},{
							boxLabel	: '<t:message code="system.label.sales.no" default="아니오"/>',
							name		: 'PRE_SEND_YN',
							inputValue	: 'N',
							width		: 60
						}]
					},{
						xtype		: 'uniNumberfield',
						name		: 'SALE_AMT',
						fieldLabel	: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>',
						labelWidth	: 110,
						readOnly	: true
					},{
						xtype		: 'uniNumberfield',
						name		: 'SALE_TAX',
						fieldLabel	: '<t:message code="system.label.sales.taxamount" default="세액"/>',
						readOnly	: true
					}]
				},{
					margin		: '0 0 0 0',
					xtype		: 'textareafield',
					name		: 'REMARK',
					fieldLabel	: '<t:message code="system.label.sales.remarks" default="비고"/>',
					labelWidth	: 123,
					width		: 524,
					grow		: true,
					height		: 47,
					listeners:{
						change:function(field, newValue, oldValue)	{
							UniAppManager.setToolbarButtons('save', true);
				 		}
				 	}					
				},{
					xtype		: 'uniDatefield',
					name		: 'TEMP_COL_DATE',
					fieldLabel	: '거래처수금예정일(temp)',
					hidden		: true
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
						change:function(field, newValue, oldValue)	{
							UniAppManager.setToolbarButtons('save', true);
				 		},						
						applyextparam: function(popup){
							popup.setExtParam({'BPARAM0': 3});
							popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
						}
					},
					tdAttrs: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  }
				}),{
					xtype		: 'radiogroup',
					holdable	: 'hold',
					fieldLabel	: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>',
					items		: [{
						boxLabel	: '<t:message code="system.label.sales.taxation" default="과세"/>',
						name		: 'TAX_BILL' ,
						inputValue	: '1',
						id			: 'rdoTaxType1',
						width		: 45
					},{
						boxLabel	: '<t:message code="system.label.sales.taxexemption" default="면세"/>',
						name		: 'TAX_BILL',
						inputValue	: '2',
						id			: 'rdoTaxType2',
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
					xtype		: 'uniDatefield',
					fieldLabel	: '<t:message code="system.label.sales.exslipdate" default="결의전표일"/>/<t:message code="system.label.sales.number" default="번호"/>',
					name		: 'EX_DATE',
					width		: 215,
					maxLength	: 10,
					labelWidth	: 110,
					readOnly	: true,
					tdAttrs		: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  }
				},{
					xtype		: 'uniTextfield',
					hideLabel	: true,
					name		: 'EX_NUM',
					width		: 50,
					readOnly	: true,
					tdAttrs		: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  }
				 },{
					fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
					name		: 'SALE_PRSN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'S010',
					listeners:{
						change:function(field, newValue, oldValue)	{
							UniAppManager.setToolbarButtons('save', true);
				 		}
				 	},					
					tdAttrs		: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  }
				},{
					xtype	: 'component',
					width	: 10,
					tdAttrs	: {style: 'border-top: 1px solid #cccccc; padding-top: 4px; padding-bottom: 0px'  }
				}]
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 5},
				items	: [{
					xtype		: 'uniDatefield',
					name		: 'RECEIPT_PLAN_DATE',
					fieldLabel	: '<t:message code="system.label.sales.collectionschdate" default="수금예정일"/>',
					labelWidth	: 110,
					listeners:{
						change:function(field, newValue, oldValue)	{
							UniAppManager.setToolbarButtons('save', true);
				 		}
				 	}					
//					holdable	: 'hold'
				},{
					fieldLabel	: '<t:message code="system.label.sales.taxinvoiceclass" default="세금계산서구분"/>',
					name		: 'BILL_TYPE',
					id			: 'billType',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'S096',
					allowBlank	: false,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts){
							if(newValue == '1'){	//정상발행
								Ext.getCmp('bfIssue').hide();
								panelResult.getField('REMARK').allowBlank = true;	//// 폼의 allowBlank통제 하려면?
								//수정사유  readOnly, allowBlank 세팅
								panelResult.setValue('UPDATE_REASON', '');
								panelResult.getField('UPDATE_REASON').setReadOnly(true);
								panelResult.getField('UPDATE_REASON').allowBlank = true;
							}else if(newValue == '2'){	//수정발행 '2'
								Ext.getCmp('bfIssue').show();
								panelResult.getField('REMARK').allowBlank = false;
								//수정사유  readOnly, allowBlank 세팅
								panelResult.getField('UPDATE_REASON').setReadOnly(false);
								panelResult.getField('UPDATE_REASON').allowBlank = false;
							}
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.updatereason" default="수정사유"/>',
					name		: 'UPDATE_REASON',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'S095',
					labelWidth	: 113,							//20200702 수정: 110 -> 113
					listeners	: {
						change:function(field, eOpts) {
							if (!Ext.isEmpty(panelResult.getValue('PUB_NUM'))){
								gsSaveRefFlag = "Y";
							}
							if(linkFlag) {
								linkFlag = false;
								return false;
							} else {
								if(Ext.isEmpty(field.getValue())){
									field.fireEvent('onClear');
								} else {
									field.openPopup();
								}
							}
						},
						onSelected:function(record, type) {
							detailGrid.reset();
							detailStore.clearData();
							record = record[0];
							panelResult.down('#btnAccnt').setDisabled(true);
							panelResult.down('#btnCancel').setDisabled(false);
							panelResult.setValue('SALE_AMT', 0);										//금액
							panelResult.setValue('SALE_TAX', 0);										//세액
							panelResult.setAllFieldsReadOnly(false);
							panelResult.setValue('CUSTOM_CODE', record.CUSTOM_CODE);					//거래처
							panelResult.setValue('CUSTOM_NAME', record.CUSTOM_NAME);					//거래처명
							if(Ext.isEmpty(record.TAX_CALC_TYPE) || record.TAX_CALC_TYPE == "2"){
								CustomCodeInfo.gsTaxCalcType = '2';
							}else{
								CustomCodeInfo.gsTaxCalcType = '1';
							}
							CustomCodeInfo.gsCollectDay = record.COLLECT_DAY;
							UniAppManager.app.fnRcptDateCal(CustomCodeInfo.gsCollectDay);

							if(!Ext.isEmpty(record.COMPANY_NUM) && record.COMPANY_NUM.length == 10){	//사업자번호set
								rsComNum =  record.COMPANY_NUM;
								comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
								panelResult.setValue('CUST_COM_NUM', comNum);
							}else{
								comNum = record.COMPANY_NUM;
								panelResult.setValue('CUST_COM_NUM', comNum);
							}
							panelResult.setValue('CUST_TOP_NAME'	, record.TOP_NAME);					//대표자
							panelResult.setValue('CUST_ADDRESS'		, record.ADDR1 + record.ADDR2 );	//주소
							panelResult.setValue('CUST_COMP_TYPE'	, record.COMP_TYPE);				//업태
							panelResult.setValue('CUST_COMP_CLASS'	, record.COMP_CLASS);				//업종
							CustomCodeInfo.gsUnderCalBase = record.WON_CALC_BAS;						//원미만계산
							if(Ext.isEmpty(record.COLLECTOR_CP)){										//수금거래처
								CustomCodeInfo.gsCollector = record.CUSTOM_CODE;
							}else{
								CustomCodeInfo.gsCollector = record.COLLECTOR_CP;
							}
							CustomCodeInfo.gsColetCare = record.COLLECT_CARE;							//미수관리방법
							panelResult.setValue('WRITE_DATE'	, record.REG_DATE);						//작성일
							panelResult.setValue('REMARK'		, record.REG_REMARK);					//비고
							if(record.BILL_TYPE == "11"){												//계산서유형
								panelResult.getField('TAX_BILL').setValue('1');
							}else if(record.BILL_TYPE == "20"){
								panelResult.getField('TAX_BILL').setValue('2');
							}else if(record.BILL_TYPE == "12"){
								panelResult.getField('TAX_BILL').setValue('3');
							}
							panelResult.setValue('SALE_DIV_CODE', record.SALE_DIV_CODE);
							gsDivCode = record.SALE_DIV_CODE;
							UniAppManager.app.fnRecordComBo();
							panelResult.setValue('BILL_DIV_CODE', record.DIV_CODE);
							panelResult.setValue('SALE_PRSN'	, record.SALE_PRSN);					//영업담당
							panelResult.setValue('BF_ISSUE'		, record.ISSU_ID);						//당초승인번호

							var updateReason = panelResult.getValue('UPDATE_REASON');
							switch(updateReason) {
								case "01" :
									panelResult.getField('WRITE_DATE').setReadOnly(true);
									panelResult.setValue('FR_SALE_DATE'	, record.PUB_FR_DATE);
									panelResult.setValue('TO_SALE_DATE'	, record.PUB_TO_DATE);
									panelResult.setValue('SALE_AMT'		, record.SALE_AMT_O);	//금액
									panelResult.setValue('SALE_TAX'		, record.TAX_AMT_O);	//세액

									sSaleAmt = record.SALE_AMT_O;
									sTaxAmt = record.TAX_AMT_O;
									amtForm.setValue('SALE_LOC_TOT_DIS', record.SALE_TOT_AMT);
									panelResult.setAllFieldsReadOnly(true);
									panelResult.setValue('RECEIPT_PLAN_DATE', record.RECEIPT_PLAN_DATE);
									panelResult.getField('RECEIPT_PLAN_DATE').setReadOnly(true);
									panelResult.getField('PROJECT_NO').setReadOnly(true);
									panelResult.getField('SALE_PRSN').setReadOnly(true);
									gsStatusM = "N"
									Ext.getCmp('labelText').setHtml("<font color = 'red'><t:message code='system.message.sales.message012' default='※ 매출내역 변동이 없으므로 내역없이 수정발행 저장시 자동으로 2부 발행'/>");	//20200702 수정: setText -> setHtml
									//20200702 추가: 각 수정사유별로 처리
									UniAppManager.setToolbarButtons('save', true);
									break;

								case "02" :
									panelResult.getField('WRITE_DATE').setReadOnly(false);
									Ext.getCmp('labelText').setHtml("<font color = 'red'><t:message code='system.message.sales.message013' default='※ 증감분에 대하여 수불 또는 매출부터 추가 등록 후 1부만 발행'/>");			//20200702 수정: setText -> setHtml
									//20200702 추가: 각 수정사유별로 처리
									UniAppManager.setToolbarButtons('save', false);
									break;

								case "03" :
									panelResult.getField('WRITE_DATE').setReadOnly(false);
									Ext.getCmp('labelText').setHtml("<font color = 'red'><t:message code='system.message.sales.message014' default='※ 환입된 금액분에 대하여 수불 또는 매출부터 추가 등록 후 1부만 발행'/>");		//20200702 수정: setText -> setHtml
									//20200702 추가: 각 수정사유별로 처리
									UniAppManager.setToolbarButtons('save', false);
									break;

								case "04" :
									panelResult.getField('WRITE_DATE').setReadOnly(false);
									panelResult.setValue('FR_SALE_DATE', record.PUB_FR_DATE);
									panelResult.setValue('TO_SALE_DATE', record.PUB_TO_DATE);
									panelResult.setValue('SALE_AMT', record.SALE_AMT_O);		//금액
									panelResult.setValue('SALE_TAX', record.TAX_AMT_O);			//세액

									sSaleAmt = record.SALE_AMT_O;
									sTaxAmt = record.TAX_AMT_O;
									amtForm.setValue('SALE_LOC_TOT_DIS', record.SALE_TOT_AMT);
									panelResult.setAllFieldsReadOnly(true);
									panelResult.getField('RECEIPT_PLAN_DATE').setReadOnly(true);
									panelResult.getField('PROJECT_NO').setReadOnly(true);
									panelResult.getField('SALE_PRSN').setReadOnly(true);
									gsStatusM = "N"
									Ext.getCmp('labelText').setHtml("<font color = 'red'><t:message code='system.message.sales.message015' default='※ 부(-)의 세금계산서 1부만 발행'/>");						//20200702 수정: setText -> setHtml
									panelResult.getField('WRITE_DATE').setReadOnly(false);
									//20200702 추가: 각 수정사유별로 처리
									UniAppManager.setToolbarButtons('save', true);
									break;

								case "05" :
									panelResult.getField('WRITE_DATE').setReadOnly(true);
									panelResult.setValue('FR_SALE_DATE', record.PUB_FR_DATE);
									panelResult.setValue('TO_SALE_DATE', record.PUB_TO_DATE);
									Ext.getCmp('labelText').setHtml("<font color = 'red'><t:message code='system.message.sales.message016' default='※ 부(-)의 세금계산서 1부, 영세율 세금계산서 1부씩 발행'/>");			//20200702 수정: setText -> setHtml
									//20200702 추가: 각 수정사유별로 처리
									UniAppManager.setToolbarButtons('save', false);
									break;

								case "06" :
									panelResult.getField('WRITE_DATE').setReadOnly(false);
									panelResult.setValue('FR_SALE_DATE', record.PUB_FR_DATE);
									panelResult.setValue('TO_SALE_DATE', record.PUB_TO_DATE);
									panelResult.setValue('SALE_AMT', record.SALE_AMT_O);		//금액
									panelResult.setValue('SALE_TAX', record.TAX_AMT_O);			//세액

									sSaleAmt = record.SALE_AMT_O;
									sTaxAmt = record.TAX_AMT_O;
									amtForm.setValue('SALE_LOC_TOT_DIS', record.SALE_TOT_AMT);
									panelResult.setAllFieldsReadOnly(false);
									panelResult.getField('RECEIPT_PLAN_DATE').setReadOnly(true);
									panelResult.getField('PROJECT_NO').setReadOnly(true);
									panelResult.getField('SALE_PRSN').setReadOnly(true);
									gsStatusM = "N"
									Ext.getCmp('labelText').setHtml("<font color = 'red'><t:message code='system.message.sales.message017' default='※ 원 세금계산서의 반대 세금계산서 1부만 발행'/>");					//20200702 수정: setText -> setHtml
									//20200702 추가: 각 수정사유별로 처리
									UniAppManager.setToolbarButtons('save', true);
									break;
							}
							gsBeforePubNum = record.PUB_NUM;
							gsOriginalPubNum = record.ORIGINAL_PUB_NUM;
							//20200702 주석: 각 수정사유별로 처리
//							UniAppManager.setToolbarButtons('save', true);
						},
						onclear:function(record, type) {
						}
					},
					app: 'Unilite.app.popup.TaxBillSearchPopup',
					api: 'popupService.TaxBillSearchPopup',
					openPopup: function() {
						var me		= this;
						var param	= {};
						param['TYPE']			= 'TEXT';
						param['TABLE_NAME']		= 'STB100T';
						param['pageTitle']		= me.pageTitle;
						param['CUSTOM_CODE']	= panelResult.getValue('CUSTOM_CODE');
						param['CUSTOM_NAME']	= panelResult.getValue('CUSTOM_NAME');
						param['WRITE_DATE']		= panelResult.getValue('WRITE_DATE');
						param['SALE_DIV_CODE']	= panelResult.getValue('SALE_DIV_CODE');
						param['UPDATE_REASON']	= panelResult.getValue('UPDATE_REASON');
						param['BILL_CONNECT']	= BsaCodeInfo.gsBillConnect;
						param['BILL_DB_USER']	= BsaCodeInfo.gsBillDbUser;
						if(me.app) {
							var fn = function() {
								var oWin =  Ext.WindowMgr.get(me.app);
								if(!oWin) {
									oWin = Ext.create( me.app, {
										title			: '<t:message code="system.label.sales.origintaxsearch" default="원본세금계산서검색"/>',
										id				: me.app,
										callBackFn		: me.processResult,
										callBackScope	: me,
										popupType		: 'TEXT',
										width			: 750,
										height			: 450,
										param			: param
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
//								UniAppManager.setToolbarButtons('deleteAll', true);
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
							popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
							popup.setExtParam({'CUSTOM_NAME': panelResult.getValue('CUSTOM_NAME')});
							popup.setExtParam({'WRITE_DATE': panelResult.getValue('WRITE_DATE')});
							popup.setExtParam({'SALE_DIV_CODE': panelResult.getValue('SALE_DIV_CODE')});
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
				}]
			}]
		},{	//202000702 수정: 위치 변경 / 레이아웃 재설정
			xtype: 'container',
			items:[{
				xtype	: 'component',
				width	: 10,
				height	: 40
			},{
				xtype	: 'label',
				border	: false,
				margin	: '0 0 0 10',
				text	: '',
				width	: 550,
				id		: 'labelText'
			}]
		}],
		api: {
			submit: 'ssa560ukrvService.syncForm'
		},
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
  		setLoadRecord: function() {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});

	var amtForm = Unilite.createSearchForm('ssa560ukrvAmtForm',{		//합계폼
		region	: 'south',
		layout	: {type : 'uniTable'},
		padding	: '1 1 1 1',
		border	: true,
		defaults: {xtype: 'uniNumberfield', width: 120, labelAlign: 'top', readOnly: true, margin: '0 10 0 50'/*, labelStyle: 'text-align: center;'*/},
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>',
			name		: 'SALE_LOC_TOT_DIS'
		},{
			xtype: 'component',
			width: 35
		},{
			fieldLabel	: '<t:message code="system.label.sales.cash" default="현금"/>',
			name		: ''
		},{
			xtype: 'component',
			width: 35
		},{
			fieldLabel	: '<t:message code="system.label.sales.check" default="수표"/>',
			name		: ''
		},{
			xtype: 'component',
			width: 35
		},{
			fieldLabel	: '<t:message code="system.label.sales.note" default="어음"/>',
			name		: ''
		},{
			xtype: 'component',
			width: 35
		},{
			fieldLabel	: '<t:message code="system.label.sales.creditar" default="외상미수금"/>',
			name		: ''
		},{
			xtype: 'component',
			width: 35
		},{
			xtype	: 'component',
			html	: '<t:message code="system.label.sales.thisamount" default="이 금액을"/>',
			width	: 90
		},{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 1},
			name	: 'RDO_CLAIM_YN',
			items	: [{
				xtype		: 'radiofield',
				boxLabel	: '<t:message code="system.label.sales.received" default="영수 함"/>',
				name		: 'CLAIM_YN',
				inputValue	: '1',
				id			: 'rdoIn',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						if(gsStatusM != 'N') {							//확인해야하는 부분
							gsStatusM = 'U';
						}
						UniAppManager.setToolbarButtons('save', true);
//						Unilite.messageBox('dddd');
					}
				}
			},{
				xtype		: 'radiofield',
				boxLabel	: '<t:message code="system.label.sales.claimed" default="청구 함"/>',
				name		: 'CLAIM_YN',
				inputValue	: '2',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						if(gsStatusM != 'N') {							//확인해야하는 부분
							gsStatusM = 'U';
						}
						UniAppManager.setToolbarButtons('save', true);
//						Unilite.messageBox('dddd');
					}
				}
			}]
		},{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 1},
			items	: [{
				xtype		: 'uniNumberfield',
				name		: 'TAX_DIFF_AMT',
				fieldLabel	: '부가세액 차이',
				readOnly	: true
			}]
		}],
  		setLoadRecord: function() {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});

	/**
	 * 수주의 디테일 정보를 가지고 있는 Grid
	 */
	//마스터 모델 정의
	Unilite.defineModel('ssa560ukrvDetailModel', {
		fields: [
			{name: 'DIV_CODE'			,text	: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>'			, type: 'string', comboType: 'BOR120'},
			{name: 'BILL_NUM'			,text	: '<t:message code="system.label.sales.salesno" default="매출번호"/>'					, type: 'string'},
			{name: 'BILL_SEQ'			,text	: '<t:message code="system.label.sales.seq" default="순번"/>'							, type: 'int', defaultValue: '9999'},
			{name: 'ITEM_CODE'			,text	: '<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string'},
			{name: 'ITEM_NAME'			,text	: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'				,text	: '<t:message code="system.label.sales.spec" default="규격"/>'						, type: 'string'},
			{name: 'SALE_Q'				,text	: '<t:message code="system.label.sales.qty" default="수량"/>'							, type: 'uniQty', defaultValue: 0},
			{name: 'SALE_P'				,text	: '<t:message code="system.label.sales.price" default="단가"/>'						, type: 'uniUnitPrice', defaultValue: 0},
			{name: 'SALE_AMT_O'			,text	: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'				, type: 'uniPrice', defaultValue: 0},
			{name: 'TAX_TYPE'			,text	: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'			, type: 'string', comboType: 'AU', comboCode: 'B059', defaultValue:"1"},
			{name: 'TAX_AMT_O'			,text	: '<t:message code="system.label.sales.taxamount" default="세액"/>'					, type: 'uniPrice', defaultValue: 0},
			{name: 'PUB_NUM'			,text	: '<t:message code="system.label.sales.billno" default="계산서번호"/>'					, type: 'string'},
			{name: 'REMARK'				,text	: '<t:message code="system.label.sales.remarks" default="비고"/>'						, type: 'string'},
			{name: 'RECEIPT_PLAN_DATE'	,text	: 'RECEIPT_PLAN_DATE'	, type: 'string'},
			{name: 'PROJECT_NO'			,text	: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'PROJECT_NAME'		,text	: '<t:message code="system.label.sales.projectname" default="프로젝트명"/>'				, type: 'string'},
			{name: 'BILL_DIV_CODE'		,text	: '<t:message code="system.label.sales.declaredivisioncode" default="신고사업장"/>'		, type: 'string'},
			{name: 'COMP_CODE'			,text	: '<t:message code="system.label.sales.compcode" default="법인코드"/>'					, type: 'string'},
			{name: 'INOUT_NUM'			,text	: '<t:message code="system.label.sales.issueno" default="출고번호"/>'					, type: 'string'},
			{name: 'INOUT_SEQ'			,text	: '<t:message code="system.label.sales.seq" default="순번"/>'							, type: 'int'},
			{name: 'INOUT_TYPE'			,text	: '<t:message code="system.label.sales.trantype" default="수불유형"/>'					, type: 'string', defaultValue: '2'},
			{name: 'INOUT_TYPE_DETAIL'	,text	: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'					, type: 'string', defaultValue: 'AU'},
			{name: 'SALE_UNIT'			,text	: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'					, type: 'string'},
			{name: 'TRANS_RATE'			,text	: '<t:message code="system.label.sales.containedqty" default="입수"/>'				, type: 'uniQty', defaultValue: '1'},
			{name: 'WH_CODE'			,text	: '<t:message code="system.label.sales.warehouse" default="창고"/>'					, type: 'string'},
			{name: 'PRICE_YN'			,text	: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string', defaultValue: '2'},
			{name: 'CUSTOM_CODE'		,text	: '<t:message code="system.label.sales.client" default="고객"/>'						, type: 'string'},
			{name: 'ORDER_PRSN'			,text	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'				, type: 'string'},
			{name: 'OUT_DIV_CODE'		,text	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'			, type: 'string'},
			{name: 'PRICE_TYPE'			,text	: '<t:message code="system.label.sales.pricecalculationtype" default="단가계산구분"/>'	, type: 'string', defaultValue: 'A'},
			{name: 'UNIT_WGT'			,text	: '<t:message code="system.label.sales.unitweight" default="단위중량"/>'				, type: 'int', defaultValue: '1'},
			{name: 'WGT_UNIT'			,text	: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'				, type: 'string'},
			{name: 'UNIT_VOL'			,text	: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'				, type: 'int', defaultValue: '1'},
			{name: 'VOL_UNIT'			,text	: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>'				, type: 'string'},
			{name: 'SALE_WGT_Q'			,text	: '<t:message code="system.label.sales.qty" default="수량"/>(<t:message code="system.label.sales.weight" default="중량"/>)'			, type: 'uniQty', defaultValue: 0},
			{name: 'SALE_FOR_WGT_P'		,text	: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'				, type: 'uniUnitPrice', defaultValue: 0},
			{name: 'SALE_WGT_P'			,text	: '<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.weight" default="중량"/>)'	, type: 'uniUnitPrice', defaultValue: 0},
			{name: 'SALE_VOL_Q'			,text	: '<t:message code="system.label.sales.qty" default="수량"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'			, type: 'uniQty', defaultValue: 0},
			{name: 'SALE_FOR_VOL_P'		,text	: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'				, type: 'uniUnitPrice', defaultValue: 0},
			{name: 'SALE_VOL_P'			,text	: '<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'	, type: 'uniUnitPrice', defaultValue: 0},
			{name: 'INSERT_DB_USER'		,text	: 'INSERT_DB_USER'		, type: 'string', defaultValue: UserInfo.userID},
			{name: 'UPDATE_DB_USER'		,text	: 'UPDATE_DB_USER'		, type: 'string', defaultValue: UserInfo.userID}
		]
	});
	//마스터 스토어 정의
	var detailStore = Unilite.createStore('ssa560ukrvDetailStore', {
		model	: 'ssa560ukrvDetailModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param = {
				BILL_DIV_CODE	: panelResult.getValue('BILL_DIV_CODE'),
				PUB_NUM			: panelResult.getValue('PUB_NUM')
			}
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {
						panelResult.setLoadRecord();
						gsSaveChk = true;
						UniAppManager.setToolbarButtons(['delete','newData'], false);
						/*
						 *그리드 세액 데이터 수정시 그리드 세액 합계 폼의 세액에 세팅하고 폼의 공급가액의 10%부가세와 비교하여 차이액 세팅
						 */
						var taxAmtO		= detailStore.sum('TAX_AMT_O');
						var baseTaxAmt	= Unilite.multiply(gsSaleAmt, 0.1);
						baseTaxAmt		= UniSales.fnAmtWonCalc(baseTaxAmt, CustomCodeInfo.gsUnderCalBase, 0);
						//panelResult.setValue("SALE_TAX", taxAmtO);
						amtForm.setValue("TAX_DIFF_AMT",taxAmtO - baseTaxAmt );
						panelResult.getField('CUSTOM_CODE').setReadOnly(true);
						panelResult.getField('CUSTOM_NAME').setReadOnly(true);
						panelResult.down('#PRE_SEND_YN').setReadOnly(true);	//20210527 추가
						if(taxAmtO - baseTaxAmt != 0){
							//Unilite.messageBox('공급가액에 대한 부가세(10%)와 디테일 내역의 부가세의 합이 차이가 납니다.\n부가세 차이액을 확인해주세요.');
							gsSaveChk = false;
						}
					}
				}
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var paramMaster = {};

			if(panelResult.getValue('BILL_TYPE') == "2" && panelResult.getValue('UPDATE_REASON') == "01"){	//수정발행, 기제사항착오
				UniAppManager.app.fnModifyUpdatechange();
				return false;
			} else if(panelResult.getValue('BILL_TYPE') == "2" && (panelResult.getValue('UPDATE_REASON') == "04" || panelResult.getValue('UPDATE_REASON') == "06")){//수정발행 계약의 해제, 착오예의한 이중발행
				UniAppManager.app.fnContractCancel();
				return false;
			}

			if(!detailStore.isDirty()) {
				//수정,정상발행 마스터만 저장할시..
				if(!UniAppManager.app.fnGetBillSendUseYNChk()){
					if(UniAppManager.app.fnGetBillSendCloseChk()){
						Ext.Msg.show({
							title	: '<t:message code="system.label.sales.confirm" default="확인"/>',
							msg		: '<t:message code="system.message.sales.message099" default="국세청전송 완료건 입니다."/>' + "\n"
									+ '<t:message code="system.message.sales.message100" default="정말로 삭제하시겠습니까?"/>' + "\n"
									+ '<t:message code="system.message.sales.message101" default="삭제후 재발행시 [수정세금계산서]로 발행을 하여야 합니다."/>',
							buttons	: Ext.Msg.YESNOCANCEL,
							icon	: Ext.Msg.QUESTION,
							fn		: function(res) {
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
					if(CustomCodeInfo.gsTaxCalcType == '1'){//2020.02.10 세액계산법이 통합인 경우
						if(!confirm('<t:message code="system.message.sales.message102" default="통합계산세액과 개별세금계산서의 세액합계액이 일치하지 않습니다."/>'+ '\n'
								+'<t:message code="system.label.sales.unitytaxamount" default="통합계산세액"/>' + ": "
								+ sTaxAmt + "\n" + '<t:message code="system.label.sales.eachtotaltaxamount" default="개별합계세액"/>' + ": " + dtotTaxI
								+'\n그래도 진행하시겠습니까?')) {
							return false;
						}
					}
				}

/* 				if(gsSaveChk == false){
				} */
//				paramMaster = UniAppManager.app.fnGetParamMaster();
				UniAppManager.app.fnMasterSave();

			} else {			//정상발행 마스터 디테일 모두 저장시..
				if(!UniAppManager.app.fnGetBillSendUseYNChk()){
					if(UniAppManager.app.fnGetBillSendCloseChk()){
						Ext.Msg.show({
							title:'<t:message code="system.label.sales.confirm" default="확인"/>',
							msg: '<t:message code="system.message.sales.message099" default="국세청전송 완료건 입니다."/>' + "\n"
							+ '<t:message code="system.message.sales.message100" default="정말로 삭제하시겠습니까?"/>' + "\n"
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
					if(CustomCodeInfo.gsTaxCalcType == '1'){//2020.02.10 세액계산법이 통합인 경우
						if(!confirm('<t:message code="system.message.sales.message102" default="통합계산세액과 개별세금계산서의 세액합계액이 일치하지 않습니다."/>'+ '\n'
								+'<t:message code="system.label.sales.unitytaxamount" default="통합계산세액"/>' + ": "
								+ sTaxAmt + "\n" + '<t:message code="system.label.sales.eachtotaltaxamount" default="개별합계세액"/>' + ": " + dtotTaxI
								+'\n그래도 진행하시겠습니까?')) {
							return false;
						}
					}
				}

/* 				if(gsSaveChk == false){
					if(!confirm('공급가액에 대한 부가세(10%)와 \n그리드 디테일 내역의 부가세의 합이 차이가 납니다.\n그래도 진행하시겠습니까?')) {
						return false;
					}
				} */

				paramMaster = UniAppManager.app.fnGetParamMaster();
				paramMaster.MODE = 'update'

				if(inValidRecs.length == 0) {
					config = {
							params: [paramMaster],
							success: function(batch, option) {
								//2.마스터 정보(Server 측 처리 시 가공)
								//20200511 주석 해제: 신규 저장 후 엑셀다운로드를 위해 조회로직 수행
								var master = batch.operations[0].getResultSet();
								panelResult.setValue("PUB_NUM", master.PUB_NUM);
//								if(detailStore.getCount() != 0){
//								var pubNum = detailStore.data.items[0].get('PUB_NUM');
//									panelResult.setValue("PUB_NUM", pubNum);
//								}

								//3.기타 처리
								panelResult.getForm().wasDirty = false;
								panelResult.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);

								panelResult.down('#btnAccnt').setDisabled(false);
								panelResult.down('#btnCancel').setDisabled(true);
								//전체삭제할 경우 폼 리셋
								if (gsStatusM == 'D') {
									UniAppManager.app.onResetButtonDown();
								}
								//20200511 추가: 신규 저장 후 엑셀다운로드를 위해 조회로직 수행
								else {
									setTimeout(function() {						//20210527 추가: 저장 후, 너무 빨리 조회해서 조회팝업창 뜨는 현상 발생
										UniAppManager.app.onQueryButtonDown();
										panelResult.getField('CUSTOM_CODE').setReadOnly(true);
										panelResult.getField('CUSTOM_NAME').setReadOnly(true);
										panelResult.down('#PRE_SEND_YN').setReadOnly(true);	//20210527 추가
										if(detailStore.getCount() == 0){
											UniAppManager.app.onResetButtonDown();
										}
									}, 50);
								}
							 }
						};
					this.syncAllDirect(config);
				} else {
					detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
			gsSaveRefFlag = 'N';
		},
		fnMasterSet: function(provider) {
			panelResult.setValue('PUB_NUM', provider.PUB_NUM);
			panelResult.setValue('SALE_DIV_CODE', provider.SALE_DIV_CODE);
			UniAppManager.app.fnSaleDivCode_onChange();
			panelResult.setValue('FR_SALE_DATE', provider.PUB_FR_DATE);
			panelResult.setValue('TO_SALE_DATE', provider.PUB_TO_DATE);

			if(!Ext.isEmpty(provider.OWN_COMNUM) && provider.OWN_COMNUM.length == 10){		//좌측 등록번호 set
				rsComNum =  provider.OWN_COMNUM;
				comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
				panelResult.setValue('OWN_COM_NUM', comNum);
			}else{
				comNum = provider.OWN_COMNUM;
				panelResult.setValue('OWN_COM_NUM', comNum);
			}
			panelResult.setValue('OWN_TOP_NAME', provider.OWN_TOPNAME );
			panelResult.setValue('OWN_ADDRESS', provider.OWN_ADDR);
			panelResult.setValue('OWN_COMP_CLASS', provider.OWN_COMCLASS);
			panelResult.setValue('OWN_COMP_TYPE', provider.OWN_COMTYPE);
			panelResult.setValue('OWN_SERVANT_NUM', provider.OWN_SERVANTNUM);
			panelResult.setValue('CUSTOM_CODE', provider.CUSTOM_CODE);
			panelResult.setValue('CUSTOM_NAME', provider.CUSTOM_NAME);

			if(!Ext.isEmpty(provider.CUST_COMNUM) && provider.CUST_COMNUM.length == 10){		//우측 등록번호 set
				rsComNum =  provider.CUST_COMNUM;
				comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
				panelResult.setValue('CUST_COM_NUM', comNum);
			}else{
				comNum = provider.CUST_COMNUM;
				panelResult.setValue('CUST_COM_NUM', comNum);
			}
			panelResult.setValue('CUST_TOP_NAME', provider.CUST_TOPNAME);
			panelResult.setValue('CUST_ADDRESS', provider.CUST_ADDR);
			panelResult.setValue('CUST_COMP_CLASS', provider.CUST_COMCLASS);
			panelResult.setValue('CUST_COMP_TYPE', provider.CUST_COMTYPE);
			panelResult.setValue('CUST_SERVANT_NUM', provider.CUST_SERVANTNUM);
			panelResult.setValue('BF_ISSUE', provider.BFO_ISSU_ID);

			//Call fnCustomChange(txtCustomCode.value, "", "3") 저장시는 필요 없음
			UniAppManager.app.fnRecordComBo();
			panelResult.setValue('BILL_DIV_CODE', provider.DIV_CODE);
			panelResult.setValue('BILL_TYPE', provider.BILL_FLAG);
			panelResult.setValue('ORG_BILL_TYPE', provider.BILL_TYPE);
			Ext.getCmp('billType').setReadOnly(true);
			panelResult.setValue('SALE_PRSN', provider.SALE_PRSN);

			if(panelResult.getValue('BILL_TYPE') != '1'){
				panelResult.setValue('UPDATE_REASON', provider.MODI_REASON);
				Ext.getCmp('bfIssue').show();
				panelResult.getField('REMARK').allowBlank = false;
				panelResult.getField('UPDATE_REASON').allowBlank = false;
				//수정사유  readOnly, allowBlank 세팅
				panelResult.getField('UPDATE_REASON').setReadOnly(true);
			}else{
				Ext.getCmp('bfIssue').hide();
				panelResult.getField('REMARK').allowBlank = true;
				panelResult.getField('UPDATE_REASON').allowBlank = true;
				//수정사유  readOnly, allowBlank 세팅
				panelResult.setValue('UPDATE_REASON', '');
				panelResult.getField('UPDATE_REASON').setReadOnly(true);
			}
			panelResult.setValue('EB_NUM', provider.EB_NUM);
			panelResult.setValue('WRITE_DATE',provider.BILL_DATE);
			panelResult.setValue('REMARK',provider.REMARK);
			panelResult.setValue('PROJECT_NO', provider.PROJECT_NO);
			gsColetAmt = provider.COLET_AMT;
			CustomCodeInfo.gsColetCare = provider.COLLECT_CARE;
			panelResult.setValue('EX_NUM', provider.EX_NUM)
			gsAcDate = provider.AC_DATE;
			var exDate = UniDate.getDbDateStr(provider.EX_DATE);
			if(exDate == null || exDate == ''){
				panelResult.setValue('EX_DATE', '');
				panelResult.down('#btnAccnt').setDisabled(false);
				panelResult.down('#btnCancel').setDisabled(true);
			}else{
				panelResult.setValue('EX_DATE',exDate);
				if(gsAcDate ==null && gsAcDate == ''){
					panelResult.down('#btnAccnt').setDisabled(false);
					panelResult.down('#btnCancel').setDisabled(true);
				}else{
					panelResult.down('#btnAccnt').setDisabled(true);
					panelResult.down('#btnCancel').setDisabled(false);
				}
			}

			panelResult.setValue('RECEIPT_PLAN_DATE', provider.RECEIPT_PLAN_DATE);
			if(provider.BILL_TYPE == "11"){
				panelResult.getField('TAX_BILL').setValue('1');
				Ext.getCmp('rdoTaxType2').setReadOnly(true);
				Ext.getCmp('rdoTaxType3').setReadOnly(true);
			}else if(provider.BILL_TYPE == "20"){
				panelResult.getField('TAX_BILL').setValue('2');
				Ext.getCmp('rdoTaxType1').setReadOnly(true);
				Ext.getCmp('rdoTaxType3').setReadOnly(true);
			}else if(provider.BILL_TYPE == "12"){
				Ext.getCmp('rdoTaxType1').setReadOnly(true);
				Ext.getCmp('rdoTaxType2').setReadOnly(true);
				panelResult.getField('TAX_BILL').setValue('3');
			}

			CustomCodeInfo.gsTaxCalcType = provider.TAX_CALC_TYPE;
			gsPjtCode = provider.PROJECT_NO;
			amtForm.setValue('SALE_LOC_TOT_DIS'	, provider.SALE_TOT_AMT)

			panelResult.setValue('SALE_AMT'		, provider.SALE_AMT_O);
			panelResult.setValue('SALE_TAX'		, provider.TAX_AMT_O);
			panelResult.setValue('PRE_SEND_YN'	, provider.PRE_SEND_YN);		//20210527 추가
			panelResult.setValue('PAY_TERMS'	, provider.PAY_TERMS);

			gsSaveRefFlag = 'Y';
			panelResult.setAllFieldsReadOnly(true);
			//20200207 마스터에 저장된 값을 전역변수에 세팅
			gsSaleAmt = panelResult.getValue('SALE_AMT');

		},
		fnOrderAmtSum: function() {
			var dtotSaleTI = 0;
			var dtotTaxI = 0;

			dtotSaleTI = Ext.isNumeric(this.sum('SALE_AMT_O')) 	 ? this.sum('SALE_AMT_O'):0;
			dtotTaxI = Ext.isNumeric(this.sum('TAX_AMT_O')) ? this.sum('TAX_AMT_O'):0;
			sSaleAmt = dtotSaleTI;
			sTaxAmt = dtotTaxI;
			panelResult.setValue('SALE_AMT', dtotSaleTI);

			//20191211 세액계산 수정: 거래처 정보등록의 통합/개별여부에 따라 통합일 경우에는 합계금액의 10% 계산해서 set
			if(CustomCodeInfo.gsTaxCalcType == '1' && panelResult.getValues().TAX_BILL == '1') {
				var sCalTaxAmt = Unilite.multiply(dtotSaleTI, 0.1);
				sCalTaxAmt = UniSales.fnAmtWonCalc(sCalTaxAmt, CustomCodeInfo.gsUnderCalBase, 0);
				panelResult.setValue('SALE_TAX', sCalTaxAmt);
				amtForm.setValue('SALE_LOC_TOT_DIS', dtotSaleTI + sCalTaxAmt);
			} else {
				panelResult.setValue('SALE_TAX', dtotTaxI);

				amtForm.setValue('SALE_LOC_TOT_DIS', dtotSaleTI + dtotTaxI);
			}
			sTaxAmt = panelResult.getValue('SALE_TAX');

			var records = detailStore.data.items;
			var lAuTypeCnt = 0;
			Ext.each(records, function(record,i){
				if(record.get('INOUT_TYPE_DETAIL') == "AU"){
					lAuTypeCnt = lAuTypeCnt + 1;
				}
			});
			UniAppManager.app.fnSetEnableNewBtn("Y", lAuTypeCnt, records);
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records.length == 0) {
					//수정세금계산서 기재사항 착오/수정의 경우, 전체삭제 버튼 활성화
					if (panelResult.getValue('BILL_TYPE') == '2' && panelResult.getValue('UPDATE_REASON') == '01'){
						UniAppManager.setToolbarButtons('deleteAll', true);
						gsStatusM = 'Q';

					} else if(panelResult.getValue('BILL_TYPE') == '2' && panelResult.getValue('UPDATE_REASON') == '04') {
						UniAppManager.setToolbarButtons(['delete','newData'], false);

					} else {
						this.fnOrderAmtSum();
						UniAppManager.setToolbarButtons('deleteAll', false);
					}

				//조회된 데이터가 있을 경우, 전체삭제 버튼 활성화
				} else if(records.length > 0) {
					//this.fnOrderAmtSum();
					gsStatusM = 'Q';
					UniAppManager.setToolbarButtons('deleteAll', true);
					panelResult.getField('PUB_NUM').setReadOnly(true);

				}
				gsSaveRefFlag = 'N';
			},
			add: function(store, records, index, eOpts) {
				/*
				 *그리드 매출 참조 추가시 그리드 세액 합계 폼의 세액에 세팅하고 폼의 공급가액의 10%부가세와 비교하여 차이액 세팅
				 */
				var taxAmtO = detailStore.sum('TAX_AMT_O');
				var saleAmtO = detailStore.sum('SALE_AMT_O')
				if(panelResult.getValues().TAX_BILL == '1'){
				    var baseTaxAmt = Unilite.multiply(saleAmtO, 0.1);
				}else{
					var baseTaxAmt = 0;
				}
				baseTaxAmt = UniSales.fnAmtWonCalc(baseTaxAmt, CustomCodeInfo.gsUnderCalBase, 0);
				panelResult.setValue("SALE_TAX", taxAmtO);
				amtForm.setValue("TAX_DIFF_AMT", taxAmtO - baseTaxAmt);
				gsSaveChk = true;
				if(taxAmtO - baseTaxAmt != 0){
					//Unilite.messageBox('공급가액에 대한 부가세(10%)와 디테일 내역의 부가세의 합이 차이가 납니다.\n부가세 차이액을 확인해주세요.');
					gsSaveChk = false;
				}
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				if(detailStore.getCount() != 0){
					var pubNum = detailStore.data.items[0].get('PUB_NUM');
					panelResult.setValue("PUB_NUM", pubNum);
					/*
					 *그리드 세액 데이터 수정시 그리드 세액 합계 폼의 세액에 세팅하고 폼의 공급가액의 10%부가세와 비교하여 차이액 세팅
					 */
					if(modifiedFieldNames == 'TAX_AMT_O'){
						var taxAmtO = detailStore.sum('TAX_AMT_O');
						var saleAmtO = detailStore.sum('SALE_AMT_O')
						var baseTaxAmt = Unilite.multiply(saleAmtO, 0.1);
						baseTaxAmt = UniSales.fnAmtWonCalc(baseTaxAmt, CustomCodeInfo.gsUnderCalBase, 0);
						panelResult.setValue("SALE_TAX", taxAmtO);
						amtForm.setValue("TAX_DIFF_AMT", taxAmtO - baseTaxAmt);
						gsSaveChk = true;
						if(taxAmtO - baseTaxAmt != 0){
							//Unilite.messageBox('공급가액에 대한 부가세(10%)와 디테일 내역의 부가세의 합이 차이가 납니다.\n부가세 차이액을 확인해주세요.');
							gsSaveChk = false;
						}
					}
				}
			}
		}
	});
	//마스터 그리드 정의
	var detailGrid = Unilite.createGrid('ssa560ukrvGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: false
		},
		tbar	: [{
			itemId	: 'estimateBtn',
			text	: '<div style="color: blue"><t:message code="system.label.sales.salesreference" default="매출참조"/></div>',
			handler	: function() {
				if(panelResult.getValue('BILL_TYPE') == '2' && panelResult.getValue('UPDATE_REASON') == '01') {				// 수정발행 - 기재사항 착오  일경우 매출참조 못한다.
					Unilite.messageBox('<t:message code="system.message.sales.message103" default="추가참조하실 수 없습니다."/>');
				} else if(panelResult.getValue('BILL_TYPE') == '2' && panelResult.getValue('UPDATE_REASON') == '04') {		// 수정발행 - 계약의 해제 일경우 매출참조 못한다.
					Unilite.messageBox('<t:message code="system.message.sales.message103" default="추가참조하실 수 없습니다."/>' );
				} else if(!Ext.isEmpty(panelResult.getValue('EB_NUM'))) {
					Unilite.messageBox('<t:message code="system.message.sales.message104" default="이미 전자세금계산서가 발행된 자료입니다."/>');
				} else if(!Ext.isEmpty(panelResult.getValue('EX_DATE'))) {
					Unilite.messageBox('<t:message code="system.message.sales.message105" default="회계전표가 생성된 계산서발행자료는 수정/삭제할 수 없습니다."/>');
				} else {
					openReferWindow();
				}
			}
		}],
		columns: [
			{ dataIndex: 'DIV_CODE'				, width: 80 },
			{ dataIndex: 'BILL_NUM'				, width: 100},
			{ dataIndex: 'BILL_SEQ'				, width: 50 },
			{ dataIndex: 'ITEM_CODE'			, width: 105,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
//					extParam		: {SELMODEL: 'MULTI', DIV_CODE: UserInfo.divCode, POPUP_TYPE: 'GRID_CODE'},
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
			{ dataIndex: 'ITEM_NAME'			, width: 200,
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
			{ dataIndex: 'SPEC'					, width: 150},
			{ dataIndex: 'SALE_Q'				, width: 106},
			{ dataIndex: 'SALE_P'				, width: 106},
			{ dataIndex: 'SALE_AMT_O'			, width: 106},
			{ dataIndex: 'TAX_TYPE'				, width: 80, align: 'center'},
			{ dataIndex: 'TAX_AMT_O'			, width: 80 },
			{ dataIndex: 'PUB_NUM'				, width: 100, hidden: true},
			{ dataIndex: 'REMARK'				, width: 100, hidden: true},
			{ dataIndex: 'RECEIPT_PLAN_DATE'	, width: 100, hidden: true},
			{ dataIndex: 'PROJECT_NO'			, width: 100 },
			{ dataIndex: 'PROJECT_NAME'			, width: 120, hidden: false},
			{ dataIndex: 'BILL_DIV_CODE'		, width: 100, hidden: true},
			{ dataIndex: 'COMP_CODE'			, width: 66,  hidden: true },
			{ dataIndex: 'INOUT_NUM'			, width: 66,  hidden: true },
			{ dataIndex: 'INOUT_SEQ'			, width: 66,  hidden: true },
			{ dataIndex: 'INOUT_TYPE'			, width: 66,  hidden: true },
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 66,  hidden: true },
			{ dataIndex: 'SALE_UNIT'			, width: 66,  hidden: true },
			{ dataIndex: 'TRANS_RATE'			, width: 66,  hidden: true },
			{ dataIndex: 'WH_CODE'				, width: 66,  hidden: true },
			{ dataIndex: 'PRICE_YN'				, width: 66,  hidden: true },
			{ dataIndex: 'CUSTOM_CODE'			, width: 66,  hidden: true },
			{ dataIndex: 'ORDER_PRSN'			, width: 66,  hidden: true },
			{ dataIndex: 'OUT_DIV_CODE'			, width: 66,  hidden: true },
			{ dataIndex: 'PRICE_TYPE'			, width: 66,  hidden: true },
			{ dataIndex: 'UNIT_WGT'				, width: 66,  hidden: true },
			{ dataIndex: 'WGT_UNIT'				, width: 66,  hidden: true },
			{ dataIndex: 'UNIT_VOL'				, width: 66,  hidden: true },
			{ dataIndex: 'VOL_UNIT'				, width: 66,  hidden: true },
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
				grdRecord.set('SALE_P'			, 0);
				grdRecord.set('SALE_AMT_O'		, 0);
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
				grdRecord.set('SALE_P'			, 0);
				grdRecord.set('SALE_AMT_O'		, 0);
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
			grdRecord.set('PUB_NUM'				, panelResult.getValue('PUB_NUM'));
			grdRecord.set('DIV_CODE'  			, record['DIV_CODE']);
			grdRecord.set('BILL_NUM'  			, record['BILL_NUM']);
			grdRecord.set('BILL_SEQ'  			, record['BILL_SEQ']);
			grdRecord.set('ITEM_CODE' 			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME' 			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('SALE_Q'				, record['SALE_Q']);
			grdRecord.set('SALE_P'				, record['SALE_P']);
			grdRecord.set('SALE_AMT_O'			, record['SALE_AMT_O']);
			grdRecord.set('TAX_TYPE'  			, record['TAX_TYPE']);
			grdRecord.set('TAX_AMT_O' 			, record['TAX_AMT_O']);
			grdRecord.set('REMARK'				, panelResult.getValue('REMARK'));
			grdRecord.set('RECEIPT_PLAN_DATE'	, panelResult.getValue('RECEIPT_PLAN_DATE'));
//			grdRecord.set('PROJECT_NO'			, panelResult.getValue('PROJECT_NO'));
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('PROJECT_NAME'		, record['PROJECT_NAME']);
			grdRecord.set('BILL_DIV_CODE'		, panelResult.getValue('BILL_DIV_CODE'));
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
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.get('INOUT_TYPE_DETAIL') == "AU"){
					if(e.record.phantom){			//신규일때
						if (UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'SALE_AMT_O', 'TAX_AMT_O', 'TAX_TYPE'])){
							return true;
						}else{
							return false;
						}
					}else{
						if (UniUtils.indexOf(e.field, ['TAX_AMT_O'])){//2020.02.07 부가세수정 가능하도록 수정
							return true;
						}
					}
				}else{ //신규가 아닐때
					var billNum = panelResult.getValue("PUB_NUM");
					var exDate  = panelResult.getValue("EX_DATE");
					var ebNum   = panelResult.getValue("EB_NUM");
					if( Ext.isEmpty(exDate) && Ext.isEmpty(ebNum)){
						if (UniUtils.indexOf(e.field, ['TAX_AMT_O'])){
							return true;
						}else{
							return false;
						}
					}else{
						return false;
					}
				}
			}
		}
	});



	/**
	 * 수주정보를 검색하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//검색창 폼 정의
	var billNosearch = Unilite.createSearchForm('ssa560ukrvBillNosearchForm', {
		layout			: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items			: [{
			fieldLabel	: '<t:message code="system.label.sales.declaredivisioncode" default="신고사업장"/>',
			name		: 'BILL_DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false
		},{
			fieldLabel	: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>',
			name		: 'SALE_DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120'
		},{
			fieldLabel		: '<t:message code="system.label.sales.billdate" default="계산서일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_SALE_DATE',
			endFieldName	: 'TO_SALE_DATE',
			width			: 350
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						billNosearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						billNosearch.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			validateBlank	: true,
			textFieldName	: 'PROJECT_NO',
			itemId			: 'project',
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'BPARAM0': 3});
					popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('SALE_CUSTOM_CODE')});
				}
			}
		})]
	});
	// createSearchForm
	//검색창 모델 정의
	Unilite.defineModel('billNoMasterModel', {
		fields: [
			{name: 'DIV_NAME'		,text	: '<t:message code="system.label.sales.declaredivisioncode" default="신고사업장"/>'	, type: 'string'},
			{name: 'CUSTOM_NAME'	,text	: '<t:message code="system.label.sales.salesplace" default="매출처"/>'				, type: 'string'},
			{name: 'PUB_NUM'		,text	: '<t:message code="system.label.sales.billno" default="계산서번호"/>'				, type: 'string'},
			{name: 'BILL_FLAG'		,text	: '<t:message code="system.label.sales.invoiceclass" default="계산서구분"/>'			, type: 'string', comboType: 'AU', comboCode: 'S096'},
			{name: 'BILL_TYPE'		,text	: '<t:message code="system.label.sales.billtype" default="계산서종류"/>'				, type: 'string'},
			{name: 'BILL_DATE'		,text	: '<t:message code="system.label.sales.billdate" default="계산서일"/>'				, type: 'uniDate'},
			{name: 'PUB_DATE'		,text	: '<t:message code="system.label.sales.salesdate" default="매출일"/>'				, type: 'string'},
			{name: 'SALE_DIV_CODE'	,text	: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>'		, type: 'string', comboType: 'BOR120'},
			{name: 'PROJECT_NO'		,text	: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'EX_YN'			,text	: '<t:message code="system.label.sales.slipyn" default="기표여부"/>'				, type: 'string'},
			{name: 'COLET_CUST_CD'	,text	: '<t:message code="system.label.sales.collectionplace" default="수금처"/>'		, type: 'string'},
			{name: 'DIV_CODE'		,text	: '<t:message code="system.label.sales.declaredivisioncode" default="신고사업장"/>'	, type: 'string', comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'	,text	: '<t:message code="system.label.sales.salesplace" default="매출처"/>'				, type: 'string'},
			{name: 'SALE_PRSN'		,text	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string'},
			{name: 'MODI_REASON'	,text	: '<t:message code="system.label.sales.updatereason" default="수정사유"/>'			, type: 'string'},
			{name: 'TAX_CALC_TYPE'	,text	: 'TAX_CALC_TYPE'																, type: 'string'},
			//20200413 추가: 공급가액(환산액), 부가세, 합계금액
			{name: 'SALE_AMT_O'		,text	: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'			, type: 'uniPrice'},
			{name: 'TAX_AMT_O'		,text	: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'				, type: 'uniPrice'},
			{name: 'SUM_AMT_O'		,text	: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'			, type: 'uniPrice'}
		]
	});
	//검색창 스토어 정의
	var billNoMasterStore = Unilite.createStore('ssa560ukrvBillNoMasterStore', {
		model	: 'billNoMasterModel',
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
				read : 'ssa560ukrvService.selectBillNoMasterList'
			}
		},
		loadStoreRecords : function() {
			var param= billNosearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records.length == 0) {
					if(panelResult.getValue('BILL_TYPE') == '2' && panelResult.getValue('UPDATE_REASON') == '01'){
						UniAppManager.setToolbarButtons('deleteAll', true);
						UniAppManager.setToolbarButtons('save', false);
					}
				}
				gsStatusM = 'Q';
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});
	//검색창 그리드 정의
	var billNoMasterGrid = Unilite.createGrid('ssa560ukrvBillNoMasterGrid', {
		store	: billNoMasterStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: true
		},
		columns	: [
			{ dataIndex: 'DIV_NAME'			, width: 100},
			{ dataIndex: 'CUSTOM_NAME'		, width: 106},
			{ dataIndex: 'PUB_NUM'			, width: 100},
			{ dataIndex: 'BILL_FLAG'		, width: 73 },
			{ dataIndex: 'BILL_TYPE'		, width: 100},
			{ dataIndex: 'BILL_DATE'		, width: 73 },
			//20200413 추가: 공급가액(환산액), 부가세, 합계금액
			{ dataIndex: 'SALE_AMT_O'		, width: 100},
			{ dataIndex: 'TAX_AMT_O'		, width: 100},
			{ dataIndex: 'SUM_AMT_O'		, width: 100},
			{ dataIndex: 'PUB_DATE'			, width: 146},
			{ dataIndex: 'SALE_DIV_CODE'	, width: 80 },
			{ dataIndex: 'PROJECT_NO'		, width: 100},
			{ dataIndex: 'EX_YN'			, width: 66 },
			{ dataIndex: 'COLET_CUST_CD'	, width: 110},
			{ dataIndex: 'DIV_CODE'			, width: 73 , hidden:true },
			{ dataIndex: 'CUSTOM_CODE'		, width: 73 , hidden:true },
			{ dataIndex: 'SALE_PRSN'		, width: 73 , hidden:true },
			{ dataIndex: 'MODI_REASON'		, width: 100},
			{ dataIndex: 'WON_CALC_BAS'		, width: 100, hidden:true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				billNoMasterGrid.returnData(record);
				var param = {
					BILL_DIV_CODE	: panelResult.getValue('BILL_DIV_CODE'),
					PUB_NUM			: panelResult.getValue('PUB_NUM')
				}
				CustomCodeInfo.gsUnderCalBase = record.get('WON_CALC_BAS');
//				ssa560ukrvService.selectMasterList(param, function(provider, response) {
//					detailStore.fnMasterSet(provider);
//				});
				UniAppManager.app.onQueryButtonDown();
				searchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			panelResult.setValue('SALE_DIV_CODE', record.get('SALE_DIV_CODE'));
			UniAppManager.app.fnSaleDivCode_onChange();
			UniAppManager.app.fnRecordComBo();
			panelResult.setValue('BILL_DIV_CODE', record.get('DIV_CODE'));
			panelResult.setValue('PUB_NUM'		, record.get('PUB_NUM'));
			panelResult.setValue('SALE_PRSN'	, record.get('SALE_PRSN'));
			gsOriginalPubNum = record.get('ORIGINAL_PUB_NUM');
		}
	});
	//검색창 메인
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.sales.billnosearch" default="계산서번호검색"/>',
				width: 930,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [billNosearch, billNoMasterGrid],
				tbar:  ['->',{
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
						billNosearch.setValue('CUSTOM_CODE',panelResult.getValue('CUSTOM_CODE'));
						billNosearch.setValue('CUSTOM_NAME',panelResult.getValue('CUSTOM_NAME'));
						billNosearch.setValue('FR_SALE_DATE',UniDate.get('startOfMonth', panelResult.getValue('WRITE_DATE')));
						billNosearch.setValue('TO_SALE_DATE',panelResult.getValue('WRITE_DATE'));
						billNosearch.setValue('SALE_DIV_CODE',panelResult.getValue('SALE_DIV_CODE'));
						billNosearch.setValue('BILL_DIV_CODE',panelResult.getValue('BILL_DIV_CODE'));
					}
				}
			});
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
	}



	//참조내역 폼 정의
	var referSearch = Unilite.createSearchForm('referForm', {
		layout	: {type : 'uniTable', columns : 3},
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>',
			name		: 'SALE_DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			readOnly	: true
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						referSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						referSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': referSearch.getValue('SALE_DIV_CODE')});
				}
			}
		}),{
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
						return item.get('option') == referSearch.getValue('SALE_DIV_CODE')
					})
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010'
		},
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			valueFieldName	: 'PROJECT_NO',
			textFieldName	: 'PROJECT_NAME',
			DBvalueFieldName: 'PJT_CODE',
			DBtextFieldName	: 'PJT_NAME',
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
						return item.get('option') == referSearch.getValue('WH_CODE')
							//BSA225T의 CUSTOM_CODE가 비어 있거나 panelResult의 값과 동일한 데이터만 show
							&&(item.get('refCode10') == panelResult.getValue('CUSTOM_CODE') || item.get('refCode10') == '*')
					})
				}
			}
		},{
			name		: 'ITEM_LEVEL1',
			fieldLabel	: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
			xtype		:'uniCombobox',
			store		: Ext.data.StoreManager.lookup('ssa560ukrvLevel1Store'),
			child		: 'ITEM_LEVEL2'
		},{
			name		: 'ITEM_LEVEL2',
			fieldLabel	: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('ssa560ukrvLevel2Store'),
			child		: 'ITEM_LEVEL3'
		},{
			name		: 'ITEM_LEVEL3',
			fieldLabel	: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('ssa560ukrvLevel3Store')
		}]
	});
	//참조내역 모델 정의
	Unilite.defineModel('ssa560ukrvReferModel', {
		fields: [
			{name: 'DIV_CODE'			,text	: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>'			, type: 'string', comboType: 'BOR120' },
			{name: 'BILL_NUM'			,text	: '<t:message code="system.label.sales.salesno" default="매출번호"/>'					, type: 'string'},
			{name: 'BILL_SEQ'			,text	: '<t:message code="system.label.sales.seq" default="순번"/>'							, type: 'string'},
			{name: 'SALE_DATE'			,text	: '<t:message code="system.label.sales.salesdate" default="매출일"/>'					, type: 'uniDate'},
			{name: 'CUSTOM_CODE'		,text	: '<t:message code="system.label.sales.custom" default="거래처"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'		,text	: '<t:message code="system.label.sales.customname" default="거래처명"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			,text	: '<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string'},
			{name: 'ITEM_NAME'			,text	: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'				,text	: '<t:message code="system.label.sales.spec" default="규격"/>'						, type: 'string'},
			{name: 'SALE_Q'				,text	: '<t:message code="system.label.sales.qty" default="수량"/>'							, type: 'uniQty'},
			{name: 'PRICE_YN'			,text	: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string', comboType: 'AU', comboCode: 'S003'},
			{name: 'SALE_P'				,text	: '<t:message code="system.label.sales.price" default="단가"/>'						, type: 'uniUnitPrice'},
			{name: 'SALE_AMT_O'			,text	: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'				, type: 'uniPrice'},
			{name: 'TAX_TYPE'			,text	: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'			, type: 'string', comboType: 'AU', comboCode: 'B059'},
			{name: 'TAX_AMT_O'			,text	: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'					, type: 'uniPrice'},
			{name: 'INOUT_NUM'			,text	: '<t:message code="system.label.sales.issueno" default="출고번호"/>'					, type: 'string'},
			{name: 'INOUT_SEQ'			,text	: '<t:message code="system.label.sales.seq" default="순번"/>'							, type: 'string'},
			{name: 'ORDER_NUM'			,text	: '<t:message code="system.label.sales.sono" default="수주번호"/>'						, type: 'string'},
			{name: 'PROJECT_NO'			,text	: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'PROJECT_NAME'		,text	: '<t:message code="system.label.sales.projectname" default="프로젝트명"/>'				, type: 'string'},
			{name: 'REMARK'				,text	: '<t:message code="system.label.sales.remarks" default="비고"/>'						, type: 'string'},
			{name: 'COMP_CODE'			,text	: '<t:message code="system.label.sales.compcode" default="법인코드"/>'					, type: 'string'},
			{name: 'INOUT_TYPE'			,text	: '<t:message code="system.label.sales.trantype" default="수불유형"/>'					, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	,text	: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'					, type: 'string'},
			{name: 'SALE_UNIT'			,text	: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'					, type: 'string'},
			{name: 'TRANS_RATE'			,text	: '<t:message code="system.label.sales.containedqty" default="입수"/>'				, type: 'uniQty'},
			{name: 'WH_CODE'			,text	: '<t:message code="system.label.sales.warehouse" default="창고"/>'					, type: 'string'},
//			{name: 'CUSTOM_CODE'		,text	: '<t:message code="system.label.sales.client" default="고객"/>'						, type: 'string'},
			{name: 'ORDER_PRSN'			,text	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'				, type: 'string'},
			{name: 'OUT_DIV_CODE'		,text	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'			, type: 'string'},
			{name: 'PRICE_TYPE'			,text	: '<t:message code="system.label.sales.pricecalculationtype" default="단가계산구분"/>'	, type: 'string'},
			{name: 'UNIT_WGT'			,text	: '<t:message code="system.label.sales.unitweight" default="단위중량"/>'				, type: 'string'},
			{name: 'WGT_UNIT'			,text	: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'				, type: 'string'},
			{name: 'UNIT_VOL'			,text	: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'				, type: 'string'},
			{name: 'VOL_UNIT'			,text	: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>'				, type: 'string'},
			{name: 'SALE_WGT_Q'			,text	: '<t:message code="system.label.sales.qty" default="수량"/>(<t:message code="system.label.sales.weight" default="중량"/>)'			, type: 'uniQty'},
			{name: 'SALE_FOR_WGT_P'		,text	: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'				, type: 'uniUnitPrice'},
			{name: 'SALE_WGT_P'			,text	: '<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.weight" default="중량"/>)'	, type: 'uniPrice'},
			{name: 'SALE_VOL_Q'			,text	: '<t:message code="system.label.sales.qty" default="수량"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'			, type: 'uniQty'},
			{name: 'SALE_FOR_VOL_P'		,text	: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'				, type: 'uniUnitPrice'},
			{name: 'SALE_VOL_P'			,text	: '<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'	, type: 'uniUnitPrice'}
		]
	});
	//참조내역 스토어 정의
	var referStore = Unilite.createStore('ssa560ukrvReferStore', {
		model	: 'ssa560ukrvReferModel',
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
				read: 'ssa560ukrvService.selectReferList'
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
								if( (record.data['BILL_NUM'] == item.data['BILL_NUM'])) { // record = masterRecord   item = 참조 Record
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
			var taxInPutFormParams = panelResult.getValues();	//param.TAX_BILL 가져오려고..getvalue로 못가져옴..
			var param= {
				SALE_FR_DATE	: UniDate.getDbDateStr(panelResult.getValue('FR_SALE_DATE')),
				SALE_TO_DATE	: UniDate.getDbDateStr(panelResult.getValue('TO_SALE_DATE')),
				BILL_DIV_CODE	: panelResult.getValue('BILL_DIV_CODE'),
				SALE_DIV_CODE	: referSearch.getValue('SALE_DIV_CODE'),
				CUSTOM_CODE		: panelResult.getValue('CUSTOM_CODE'),
				TAX_BILL		: taxInPutFormParams.TAX_BILL,
				PLAN_NUM		: panelResult.getValue('PROJECT_NO'),
				ITEM_CODE		: referSearch.getValue('ITEM_CODE'),
				ITEM_NAME		: referSearch.getValue('ITEM_NAME'),
				ITEM_LEVEL1		: referSearch.getValue('ITEM_LEVEL1'),
				ITEM_LEVEL2		: referSearch.getValue('ITEM_LEVEL2'),
				ITEM_LEVEL3		: referSearch.getValue('ITEM_LEVEL3'),
				SALE_PRSN		: referSearch.getValue('SALE_PRSN'),
				PROJECT_NO		: referSearch.getValue('PROJECT_NO'),
				PROJECT_NAME	: referSearch.getValue('PROJECT_NAME'),
				WH_CODE			: referSearch.getValue('WH_CODE'),
				WH_CELL_CODE	: referSearch.getValue('WH_CELL_CODE')
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//참조내역 그리드 정의
	var referGrid = Unilite.createGrid('ssa560ukrvReferGrid', {
		store	: referStore,
		layout	: 'fit',
		//20191025 추가
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
		},'->','-'],
		selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly		: false,
			toggleOnClick	: false,
			mode			: 'SIMPLE'
		}),
		uniOpt:{
			onLoadSelectFirst: false
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns:  [
			{ dataIndex: 'DIV_CODE'				, width: 90 },
			{ dataIndex: 'BILL_NUM'				, width: 120,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
				}
			},
			{ dataIndex: 'BILL_SEQ'				, width: 50, align: 'center' },
			{ dataIndex: 'SALE_DATE'			, width: 80 },
			{ dataIndex: 'CUSTOM_CODE'			, width: 100 },
			{ dataIndex: 'CUSTOM_NAME'			, width: 150 },
			{ dataIndex: 'ITEM_CODE'			, width: 110 },
			{ dataIndex: 'ITEM_NAME'			, width: 150 },
			{ dataIndex: 'SPEC'					, width: 120 },
			{ dataIndex: 'SALE_Q'				, width: 120 ,summaryType:'sum'},
			{ dataIndex: 'PRICE_YN'				, width: 73 },
			{ dataIndex: 'SALE_P'				, width: 100 },
			{ dataIndex: 'SALE_AMT_O'			, width: 120 ,summaryType:'sum' },
			{ dataIndex: 'TAX_TYPE'				, width: 66, align: 'center' },
			{ dataIndex: 'TAX_AMT_O'			, width: 120 ,summaryType:'sum' },
			{ dataIndex: 'INOUT_NUM'			, width: 120 },
			{ dataIndex: 'INOUT_SEQ'			, width: 60 },
			{ dataIndex: 'ORDER_NUM'			, width: 120 },
			{ dataIndex: 'PROJECT_NO'			, width: 100},
			{ dataIndex: 'PROJECT_NAME'			, width: 166, hidden: true  },
			{ dataIndex: 'REMARK'				, width: 66, hidden: true },
			{ dataIndex: 'COMP_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'INOUT_TYPE'			, width: 66, hidden: true },
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 66, hidden: true },
			{ dataIndex: 'SALE_UNIT'			, width: 66, hidden: true },
			{ dataIndex: 'TRANS_RATE'			, width: 66, hidden: true },
			{ dataIndex: 'WH_CODE'				, width: 66, hidden: true },
			{ dataIndex: 'CUSTOM_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'ORDER_PRSN'			, width: 66, hidden: true },
			{ dataIndex: 'OUT_DIV_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'PRICE_TYPE'			, width: 66, hidden: true },
			{ dataIndex: 'UNIT_WGT'				, width: 66, hidden: true },
			{ dataIndex: 'WGT_UNIT'				, width: 66, hidden: true },
			{ dataIndex: 'UNIT_VOL'				, width: 66, hidden: true },
			{ dataIndex: 'VOL_UNIT'				, width: 66, hidden: true },
			{ dataIndex: 'SALE_WGT_Q'			, width: 66, hidden: true },
			{ dataIndex: 'SALE_FOR_WGT_P'		, width: 66, hidden: true },
			{ dataIndex: 'SALE_WGT_P'			, width: 66, hidden: true },
			{ dataIndex: 'SALE_VOL_Q'			, width: 66, hidden: true },
			{ dataIndex: 'SALE_FOR_VOL_P'		, width: 66, hidden: true },
			{ dataIndex: 'SALE_VOL_P'			, width: 66, hidden: true }
		],
		listeners		: {
			select: function(grid, selectRecord, index, rowIndex, eOpts ) {//선택된 합계금액 set
				var records	= referStore.data.items;
				data		= new Object();
				data.records= [];
				Ext.each(records, function(record, i){
					//20191025 수정: 체크박스 클릭의 경우에는 해당 행만 선택되도록 수정
					if(selectRecord.get('BILL_NUM') + selectRecord.get('BILL_SEQ') == record.get('BILL_NUM') +  record.get('BILL_SEQ') || referGrid.getSelectionModel().isSelected(record) == true) {
						data.records.push(record);
					}
				});
				referGrid.getSelectionModel().select(data.records);
				//20191025 매출참조 그리드 합계 구하는 함수 생성, 호출하는 로직 추가
				fnRefGridSum();
			},
			deselect:  function(grid, selectRecord, index, eOpts ) {
				var records	= referStore.data.items;
				data		= new Object();
				data.records= [];
				Ext.each(records, function(record, i){
					if(selectRecord.get('BILL_NUM') + selectRecord.get('BILL_SEQ') == record.get('BILL_NUM') +  record.get('BILL_SEQ')) {
						data.records.push(record);
					}
				});
				referGrid.getSelectionModel().deselect(data.records);
				//20191025 매출참조 그리드 합계 구하는 함수 생성, 호출하는 로직 추가
				fnRefGridSum();
			},
			//20191025 수정: 애출번호 클릭 시, 동일매출번호 같이 선택되도록 수정
			cellclick: function( view, td, cellIndex, selectRecord, tr, rowIndex, e, eOpts ) {
				if(cellIndex == 2 && referGrid.getSelectionModel().isSelected(selectRecord) == true) {
					var records	= referStore.data.items;
					data		= new Object();
					data.records= [];
					Ext.each(records, function(record, i){
						if(selectRecord.get('BILL_NUM') == record.get('BILL_NUM') || referGrid.getSelectionModel().isSelected(record) == true) {
							data.records.push(record);
						}
					});
					referGrid.getSelectionModel().select(data.records);
					//20191025 매출참조 그리드 합계 구하는 함수 생성, 호출하는 로직 추가
					fnRefGridSum();
				}
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
		if(!panelResult.setAllFieldsReadOnly(true)) return false;
		if(!referWindow) {
			referWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.salesreference" default="매출참조"/>',
				width	: 930,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [referSearch, referGrid],
				tbar	: ['->',{
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
							panelResult.setAllFieldsReadOnly(false);
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
						referSearch.setValue('SALE_DIV_CODE', panelResult.getValue('SALE_DIV_CODE'));
					}
				}
			})
		}
		referWindow.center();
		referWindow.show();
	}



	Unilite.Main({
		id			: 'ssa560ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				 panelResult, amtForm, detailGrid
			]
		}],
		fnInitBinding: function(params) {
			linkFlag = false;
			UniAppManager.setToolbarButtons('reset'		, true);
			UniAppManager.setToolbarButtons('newData'	, false);
//			detailGrid.disabledLinkButtons(false);

			this.setDefault(params);
		},
		//20200221 세금계산서 발행현황에 링크 기능 추가로 인해 받는 로직 추가
		processParams: function(params) {
			if(params.PGM_ID == 'ssa100ukrv') { //매출등록에서 링크넘어올시
				var formPram = params.formPram;
				panelResult.setValue('SALE_DIV_CODE'	, formPram.DIV_CODE);
				panelResult.setValue('FR_SALE_DATE'		, formPram.SALE_DATE);
				panelResult.setValue('TO_SALE_DATE'		, formPram.SALE_DATE);
				panelResult.setValue('CUSTOM_CODE'		, formPram.SALE_CUSTOM_CODE);

				var param = {CUSTOM_NAME : formPram.SALE_CUSTOM_CODE};
				popupService.agentCustPopup(param, function(provider, response)	{
					panelResult.setValue('CUSTOM_NAME', provider[0]["CUSTOM_NAME"]);
					if(Ext.isEmpty(provider[0]["TAX_CALC_TYPE"]) ||  provider[0]["TAX_CALC_TYPE"] == "2"){
						CustomCodeInfo.gsTaxCalcType = "2";
					}else{
						CustomCodeInfo.gsTaxCalcType = "1";
					}
					CustomCodeInfo.gsCollectDay = provider[0]["COLLECT_DAY"];									//수금예정일
//					UniAppManager.app.fnRcptDateCal(CustomCodeInfo.gsCollectDay);	//20210820 수정: 아래에서 넘어온 데이터 그대로 SET

					if(!Ext.isEmpty(provider[0]["COMPANY_NUM"]) && provider[0]["COMPANY_NUM"].length == 10){		//사업자번호
						rsComNum =  provider[0]["COMPANY_NUM"];
						comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
						panelResult.setValue('CUST_COM_NUM', comNum);
					}else{
						comNum = provider[0]["COMPANY_NUM"];
						panelResult.setValue('CUST_COM_NUM', comNum);
					}

					panelResult.setValue('CUST_TOP_NAME'	, provider[0]["TOP_NAME"]);							//대표자
					panelResult.setValue('CUST_ADDRESS'		, provider[0]["ADDR1"] + ' ' + provider[0]["ADDR2"]);	//주소
					panelResult.setValue('CUST_COMP_TYPE'	, provider[0]["COMP_TYPE"]);							//업태
					panelResult.setValue('CUST_COMP_CLASS'	, provider[0]["COMP_CLASS"]);						//업종
					panelResult.setValue('CUST_SERVANT_NUM'	, provider[0]["SERVANT_COMPANY_NUM"]);				//종사업장번호

					CustomCodeInfo.gsUnderCalBase = provider[0]["WON_CALC_BAS"]									//원미계산
					if(Ext.isEmpty(provider[0]["COLLECTOR_CP"])){												//수금거래처
						CustomCodeInfo.gsCollector = provider[0]["CUSTOM_CODE"];
					}else{
						CustomCodeInfo.gsCollector = provider[0]["COLLECTOR_CP"];
					}
					CustomCodeInfo.gsColetCare = provider[0]["COLLECT_CARE"];									//미수관리방법
					if(Ext.isEmpty(provider[0]["BILL_DIV_CODE"])){
						CustomCodeInfo.gsBillDivChgYN = 'N'
						UniAppManager.app.fnRecordComBo();														//신고사업장 가져오기
					}else{
						CustomCodeInfo.gsBillDivChgYN = 'Y'
						panelResult.setValue('BILL_DIV_CODE', provider[0]["BILL_DIV_CODE"]);
						UniAppManager.app.billDivCode_onChange();
					}
				});
				panelResult.setValue('PAY_TERMS', formPram.PAYMENT_TERM);
				// 결제 조건 값에 따른 결제 예정일 세팅
				if(Ext.isEmpty(formPram.PAYMENT_DAY)) {
					fnControlPaymentDay(formPram.PAYMENT_TERM);		//20210820 수정: 매출등록에 값이 없을 때만 재계산 아니면 아래에서 넘어온 데이터 그대로 SET
				} else {
					panelResult.setValue('RECEIPT_PLAN_DATE', formPram.PAYMENT_DAY);
				}
				panelResult.setValue('SALE_PRSN'		, formPram.SALE_PRSN);
				panelResult.setValue('PROJECT_NO'		, formPram.PROJECT_NO);

				var spubNum			= panelResult.getValue('PUB_NUM');
				var sreceiptDate	= panelResult.getValue('RECEIPT_PLAN_DATE');
				var sbillDivcode	= panelResult.getValue('BILL_DIV_CODE');

				if(params.SELTAX_TYPE == "1"){
					panelResult.getField('TAX_BILL').setValue('1');
				}else if(params.SELTAX_TYPE == "2"){
					panelResult.getField('TAX_BILL').setValue('2');
				}else if(params.SELTAX_TYPE == "3"){
					panelResult.getField('TAX_BILL').setValue('3');
				}

				Ext.each(params.record, function(rec,i){
					var r = {
						DIV_CODE			: rec.get('DIV_CODE'),
						BILL_NUM			: rec.get('BILL_NUM'),
						BILL_SEQ			: rec.get('BILL_SEQ'),
						ITEM_CODE			: rec.get('ITEM_CODE'),
						ITEM_NAME			: rec.get('ITEM_NAME'),
						SPEC				: rec.get('SPEC'),
						SALE_Q				: rec.get('SALE_Q'),
						SALE_P				: rec.get('SALE_P'),
						SALE_AMT_O			: rec.get('SALE_AMT_O'),
						TAX_TYPE			: rec.get('TAX_TYPE'),
						TAX_AMT_O			: rec.get('TAX_AMT_O'),
						REMARK				: rec.get('REF_REMARK'),
						PUB_NUM				: spubNum,
						RECEIPT_PLAN_DATE	: sreceiptDate,
						PROJECT_NO			: rec.get('PROJECT_NO'),
						BILL_DIV_CODE		: sbillDivcode,
						COMP_CODE			: rec.get('COMP_CODE')
					}
					detailGrid.createRow(r);
				});
				detailStore.fnOrderAmtSum();

			} else if(params.PGM_ID == 'ssa580skrv') {
				panelResult.setValue('SALE_DIV_CODE', params.DIV_CODE);
				panelResult.setValue('PUB_NUM'		, params.PUB_NUM);
				UniAppManager.app.onQueryButtonDown();
			}
		},
		onQueryButtonDown: function() {
			delfag = '';
//			panelResult.setAllFieldsReadOnly(false);
			var pubNum = panelResult.getValue('PUB_NUM');
			if(Ext.isEmpty(pubNum)) {
				openSearchInfoWindow()
			} else {
				var param = {
					BILL_DIV_CODE	: panelResult.getValue('BILL_DIV_CODE'),
					PUB_NUM			: pubNum
				}
				ssa560ukrvService.selectMasterList(param, function(provider, response) {
					detailStore.fnMasterSet(provider);
				});
				detailStore.loadStoreRecords();
			}
		},
		onNewDataButtonDown: function() {
			delfag = '';
			if(!panelResult.setAllFieldsReadOnly(true)) return false;

			if(!Ext.isEmpty(panelResult.getValue('EX_DATE'))) {
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
				if(gsStatusM != 'N') {
					gsStatusM = 'U';
				}
				if(!UniAppManager.app.getTopToolbar().getComponent('newData').isDisabled( )){
					UniAppManager.setToolbarButtons('newData', false);
				}
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onResetButtonDown: function() {
			//panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailStore.clearData();
			//this.fnInitBinding();
			/***** 2020.05.13 초기화 버튼 클릭시 일부만 클리어되도록 수정*/
			linkFlag = false;
			UniAppManager.setToolbarButtons('reset'		, true);
			UniAppManager.setToolbarButtons('newData'	, false);

			panelResult.setValue('CUST_COM_NUM'		, '');
			panelResult.setValue('CUSTOM_CODE'		, '');
			panelResult.setValue('CUSTOM_NAME'		, '');
			panelResult.setValue('CUST_TOP_NAME'	, '');
			panelResult.setValue('CUST_ADDRESS'		, '');
			panelResult.setValue('CUST_COMP_TYPE'	, '');
			panelResult.setValue('CUST_COMP_CLASS'	, '');
			panelResult.setValue('CUST_SERVANT_NUM'	, '');
			panelResult.setValue('SALE_AMT'			, 0);
			panelResult.setValue('SALE_TAX'			, 0);
			panelResult.setValue('REMARK'			, '');
			panelResult.setValue('PROJECT_NO'		, '');
			panelResult.setValue('EX_DATE'			, '');
			panelResult.setValue('EX_NUM'			, '');
			panelResult.setValue('PUB_NUM'			, '');
			panelResult.setValue('BILL_TYPE'		, '1');	//세금계산서구분

			if(panelResult.getValue('BILL_TYPE') == '1' ){
				panelResult.setValue('BF_ISSUE' , '');
			}

			amtForm.setValue('TAX_DIFF_AMT'			, 0);
			gsBillDivChgYN = 'N'	//신고사업장 변경여부
			if(BsaCodeInfo.gsBillYn == 'Y'){
				Ext.getCmp('billType').setReadOnly(false);
			}else{
				Ext.getCmp('billType').setReadOnly(false);
			}
			Ext.getCmp('bfIssue').hide();								//당초승인번호
			panelResult.getField('UPDATE_REASON').setReadOnly(true);	//수정사유
			amtForm.setValue('SALE_LOC_TOT_DIS', 0);
			amtForm.getField('CLAIM_YN').setValue('2');					// 영수,청구 선택
//			panelResult.getField("RDO_CLAIM_YN").setReadOnly(true);		//영수,청구 READONLY	////테스트후 풀것
			gsColetAmt = 0;
			panelResult.down('#btnAccnt').setDisabled(true);
			panelResult.down('#btnCancel').setDisabled(true);
			Ext.getCmp('rdoIn').setReadOnly(true);
			UniAppManager.setToolbarButtons('save', false);
			Ext.getCmp('labelText').setHtml('');						//20200702 수정: setText -> setHtml
			gsStatusM = "N"
			gsSaveRefFlag = 'N';
			panelResult.getField('REMARK').allowBlank = true;			// 폼의 allowBlank통제 하려면?
			//수정사유  readOnly, allowBlank 세팅
			panelResult.setValue('UPDATE_REASON', '');
			panelResult.getField('UPDATE_REASON').setReadOnly(true);
			panelResult.getField('UPDATE_REASON').allowBlank = true;
			panelResult.getField('BILL_TYPE').setReadOnly(isDisable);
			panelResult.getField('CUSTOM_CODE').setReadOnly(false);
			panelResult.getField('CUSTOM_NAME').setReadOnly(false);
			panelResult.getField('WRITE_DATE').setReadOnly(false); //20210728 수정세금계산서 발행 후 신규버튼 눌렀을 시 발행일 활성화 되도록 수정.
			panelResult.getField('PRE_SEND_YN').setValue('N');																	//20210527 추가
			panelResult.down('#PRE_SEND_YN').setReadOnly(false);																//20210527 추가
			panelResult.setValue('TO_SALE_DATE'			, new Date());															//20210527 추가
			panelResult.setValue('FR_SALE_DATE'			, UniDate.get('startOfMonth', panelResult.getValue('TO_SALE_DATE')));	//20210527 추가
			panelResult.setValue('WRITE_DATE'			, new Date());															//20210527 추가
			panelResult.setValue('RECEIPT_PLAN_DATE'	, '');																	//20210527 추가
			panelResult.setValue('EB_NUM'				, '');																	//20210527 추가
		},
		onSaveDataButtonDown: function(config) {
			if (delfag == 'del') {
				//저장 시... 수정세금계산서(기재사항 착오/수정)가 아니고 detail data가 모두 삭제(스토어 카운트가 0)되면... 전체삭제 로직 수행
				if (!(panelResult.getValue('BILL_TYPE') == '2' && panelResult.getValue('UPDATE_REASON') == '01')) {
					if (detailStore.getCount() == 0) {
						if (confirm ("세금계산서를 완전히 삭제하시겠습니까?")) {
							gsStatusM = 'D';
						} else {
							UniAppManager.app.onQueryButtonDown();
							return false;
						}
					}
				}
			}
			detailStore.saveStore();
			delfag = '';
		},
		onDeleteDataButtonDown: function() {
			if(!Ext.isEmpty(panelResult.getValue('EX_DATE'))) {
				Unilite.messageBox('<t:message code="system.message.sales.message105" default="회계전표가 생성된 계산서발행자료는 수정/삭제할 수 없습니다."/>');
			} else if(gsColetAmt > 0) {
				Unilite.messageBox('<t:message code="system.message.sales.message106" default="수금이 진행된 계산서발행자료는 삭제할 수 없습니다."/>');
			} else {
				var selRow = detailGrid.getSelectedRecord();
				if(selRow.phantom === true) {
					detailGrid.deleteSelectedRow();
				}else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					detailGrid.deleteSelectedRow();
				}
				detailStore.fnOrderAmtSum();
			}
		},
		onDeleteAllButtonDown: function() {
			delfag = 'del';
			var records = detailStore.data.items;
			var isNewData = false;
			//20190219 추가
			//수정세금계산서 기재사항 착오/수정일 경우
			if(panelResult.getValue('BILL_TYPE') == '2' && panelResult.getValue('UPDATE_REASON') == '01'){
				if(gsStatusM == 'N') {
					UniAppManager.setToolbarButtons('save', false);
					UniAppManager.app.onResetButtonDown();
					return false;
				} else {
					gsStatusM = 'D';
					if(confirm(Msg.sMB064)) {										//전체삭제 하시겠습니까?
						UniAppManager.app.fnModifyUpdatechange();
						return false;
					}
				}
			}
			//수정세금계산서 기재사항 착오/수정 외의 경우
			//회계전표가 생성된 계산서발행자료는 수정/삭제할 수 없습니다.
			if (!Ext.isEmpty(panelResult.getValue('EX_DATE'))){
				Unilite.messageBox(Msg.sMS322);										//"회계전표가 생성된 계산서발행자료는 수정/삭제할 수 없습니다."
				return false;
			}

			if(gsStatusM =='N') {
				UniAppManager.setToolbarButtons('save', false);
				UniAppManager.app.onResetButtonDown();
				return false;

			} else if(records.length > 0) {
				Ext.each(records, function(record,i) {
					if(record.phantom){					//신규 레코드일시 isNewData에 true를 반환
						isNewData = true;
					}else{								//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
						isNewData = false;
						if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
							var deletable = true;
							/*---------삭제전 로직 구현 시작----------*/
							if(!Ext.isEmpty(panelResult.getValue('EX_DATE'))) {
								Unilite.messageBox('<t:message code="system.message.sales.message105" default="회계전표가 생성된 계산서발행자료는 수정/삭제할 수 없습니다."/>');
							} else if(gsColetAmt > 0) {
								Unilite.messageBox('<t:message code="system.message.sales.message106" default="수금이 진행된 계산서발행자료는 삭제할 수 없습니다."/>');
							/*---------삭제전 로직 구현 끝----------*/
							}else{
								if(deletable){
									gsStatusM = 'D';
									detailGrid.reset();
									detailStore.fnOrderAmtSum();
									UniAppManager.app.onSaveDataButtonDown();
								}
							}
						}
						return false;
					}
				});
				if(isNewData){									//신규 레코드들만 있을시 그리드 리셋
					detailGrid.reset();
					UniAppManager.app.onResetButtonDown();		//삭제후 RESET..
				}
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('ssa560ukrvAdvanceSerch');
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
			var fp = Ext.getCmp('ssa560ukrvFileUploadPanel');
			if(detailStore.isDirty() || fp.isDirty()) {
				if(confirm(2)) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function(params) {
			delfag = '';
			panelResult.setValue('SALE_DIV_CODE', UserInfo.divCode);
			UniAppManager.app.fnSaleDivCode_onChange();
			panelResult.setValue('TO_SALE_DATE'	, new Date());
			panelResult.setValue('FR_SALE_DATE'	, UniDate.get('startOfMonth', panelResult.getValue('TO_SALE_DATE')));
			panelResult.setValue('SALE_AMT'		, 0);
			panelResult.setValue('SALE_TAX'		, 0);
			panelResult.setValue('BILL_TYPE'	, '1');					//세금계산서구분
			gsBillDivChgYN = 'N'										//신고사업장 변경여부
			panelResult.setValue('WRITE_DATE'	, new Date());			//작성일
			if(BsaCodeInfo.gsBillYn == 'Y'){
				Ext.getCmp('billType').setReadOnly(false);
			}else{
				Ext.getCmp('billType').setReadOnly(false);
			}
			Ext.getCmp('bfIssue').hide();								//당초승인번호
			panelResult.getField('UPDATE_REASON').setReadOnly(true);	//수정사유
			amtForm.setValue('SALE_LOC_TOT_DIS', 0);
			panelResult.getField('TAX_BILL').setValue('1');				//과세구분
			amtForm.getField('CLAIM_YN').setValue('2');					// 영수,청구 선택
//			panelResult.getField("RDO_CLAIM_YN").setReadOnly(true);		//영수,청구 READONLY	////테스트후 풀것

			gsColetAmt = 0;
			panelResult.down('#btnAccnt').setDisabled(true);
			panelResult.down('#btnCancel').setDisabled(true);

			//20200221 세금계산서 발행현황에 링크 기능 추가로 인해 받는 로직관련하여 수정
			UniAppManager.app.fnRecordComBo(params);	//신고사업장 가져오기
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();

			Ext.getCmp('rdoTaxType1').setReadOnly(false);
			Ext.getCmp('rdoTaxType2').setReadOnly(false);
			Ext.getCmp('rdoTaxType3').setReadOnly(false);

			panelResult.setAllFieldsReadOnly(false);

			Ext.getCmp('rdoIn').setReadOnly(true);
			UniAppManager.setToolbarButtons('save', false);
			Ext.getCmp('labelText').setHtml('');					//20200702 수정: setText -> setHtml
			gsStatusM = "N"
			gsSaveRefFlag = 'N';
			panelResult.getField('REMARK').allowBlank = true;	//// 폼의 allowBlank통제 하려면?
			//수정사유  readOnly, allowBlank 세팅
			panelResult.setValue('UPDATE_REASON', '');
			panelResult.getField('UPDATE_REASON').setReadOnly(true);
			panelResult.getField('UPDATE_REASON').allowBlank = true;

			panelResult.getField('BILL_TYPE').setReadOnly(isDisable);
			panelResult.getField('PRE_SEND_YN').setValue('N');		//20210527 추가: 선발행여부 기본값 설정
		},
		fnSaleDivCode_onChange: function(){		//참조탭 매출사업장 설정
			referSearch.setValue('SALE_DIV_CODE', panelResult.getValue('SALE_DIV_CODE'));
		},
		//20200221 세금계산서 발행현황에 링크 기능 추가로 인해 받는 로직관련하여 수정
		fnRecordComBo: function(params){		//신고사업장 가져오기
			if(BsaCodeInfo.gsBillDivChgYN == "Y") return false;	//신고사업장 변경여부가 '아니오'일 경우만 자동으로 변경함
			var param = panelResult.getValues();
			ssa560ukrvService.selectBillDivList(param, function(provider, response) {
				if(Ext.isEmpty(provider)) return false;
				panelResult.setValue('BILL_DIV_CODE', provider.data.BILL_DIV_CODE);
				UniAppManager.app.billDivCode_onChange(params);	//사업장정보 쿼리 조회후 set
			});
		},
		billDivCode_onChange: function(params){		//신고사업장 정보 가져오기
			if(Ext.isEmpty(panelResult.getValue('BILL_DIV_CODE'))){
				panelResult.setValue('OWN_COM_NUM'		, '');
				panelResult.setValue('OWN_TOP_NAME'		, '');
				panelResult.setValue('OWN_ADDRESS'		, '');
				panelResult.setValue('OWN_COMP_TYPE'	, '');
				panelResult.setValue('OWN_COMP_CLASS'	, '');
				panelResult.setValue('OWN_SERVANT_NUM'	, '');

				//20200221 세금계산서 발행현황에 링크 기능 추가로 인해 받는 로직 추가
				if(!Ext.isEmpty(params && params.PGM_ID)){
					UniAppManager.app.processParams(params);
				}
				return false;
			}
			var param = panelResult.getValues();
			ssa560ukrvService.selectBillDivInfo(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					var comNum = '';
					if(Ext.isEmpty(provider.data.COMPANY_NUM)){
						panelResult.setValue('OWN_COM_NUM', '');
					}else{
						if(!Ext.isEmpty(provider.data.COMPANY_NUM) && provider.data.COMPANY_NUM.length == 10){
							rsComNum =  provider.data.COMPANY_NUM;
							comNum = rsComNum.substring(0, 3) + '-' + rsComNum.substring(3, 5) + '-' + rsComNum.substring(5);
							panelResult.setValue('OWN_COM_NUM', comNum);
						}else{
							comNum = provider.data.COMPANY_NUM;
							panelResult.setValue('OWN_COM_NUM', comNum);
						}
					}
					panelResult.setValue('OWN_TOP_NAME'		, provider.data.REPRE_NAME);
					panelResult.setValue('OWN_ADDRESS'		, provider.data.ADDR);
					panelResult.setValue('OWN_COMP_TYPE'	, provider.data.COMP_TYPE);
					panelResult.setValue('OWN_COMP_CLASS'	, provider.data.COMP_CLASS);
					panelResult.setValue('OWN_SERVANT_NUM'	, provider.data.SUB_DIV_NUM);

					//20200221 세금계산서 발행현황에 링크 기능 추가로 인해 받는 로직 추가
					if(!Ext.isEmpty(params && params.PGM_ID)){
						UniAppManager.app.processParams(params);
					}
				}
			});
		},
		fnGetBillSendUseYNChk: function(){		//국세청전송완료체크 전 사용유무파악
			if(BsaCodeInfo.gsBillYn == "Y"){
				return true;
			}else{
				return false;
			}
		},
		fnGetBillSendCloseChk: function(){		//국세청전송완료건 체크
			var param = {BILL_SEQ : panelResult.getValue("EB_NUM")};
			ssa560ukrvService.getBillSendCloseChk(param, function(provider, response) {
				if(Ext.isEmpty(provider)){
					return false;
				}else{
					var gsBillChk	= provider['REPORT_STAT'];
					var sBillGubun	= provider['BILL_GUBUN'];

					if(sBillGubun == "01"){
						if(!Ext.isEmpty(gsBillChk) && gsBillChk != "N"){
							return true;
						}else{
							return false;
						}
					}else if(sBillGubun == "02"){
						if(!Ext.isEmpty(gsBillChk)){
							return true;
						}else{
							return false;
						}
					}else{
						return false;
					}
				}
			});
		},
		fnSetEnableNewBtn: function(sAuTypeCheck, lAuTypeCnt, records){	//금액보정(AU) 유무 체크하여 [추가]버튼 활성화 처리
			if(!Ext.isEmpty(panelResult.getValue('EX_DATE'))) return false;
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
				if(UniAppManager.app.getTopToolbar().getComponent('newData').isDisabled( )){
					UniAppManager.setToolbarButtons('newData', true);
				}
			}else{
				if(!UniAppManager.app.getTopToolbar().getComponent('newData').isDisabled( )){
					UniAppManager.setToolbarButtons('newData', false);
				}
			}
		},
		fnRcptDateCal: function(gsCollectDay){
			if(gsCollectDay.length == 1){
				gsCollectDay = "0" + gsCollectDay;
			}
			if(!Ext.isEmpty(gsCollectDay)){
				if(!Ext.isEmpty(panelResult.getValue('WRITE_DATE'))){
					var sYearMonth = UniDate.getDbDateStr(panelResult.getValue('WRITE_DATE')).substring(0, 6);
					var sDay = UniDate.getDbDateStr(panelResult.getValue('WRITE_DATE')).substring(6, 8);
					if(BsaCodeInfo.gsCollectDayFlg == "1"){
						if(sDay >= gsCollectDay){
							panelResult.setValue('TEMP_COL_DATE', sYearMonth + gsCollectDay);//text를 날짜형식으로 set해주기 위해
							panelResult.setValue('RECEIPT_PLAN_DATE', UniDate.add(panelResult.getValue('TEMP_COL_DATE'), {months:+1}));
						}else{
							panelResult.setValue('TEMP_COL_DATE', sYearMonth + gsCollectDay);//text를 날짜형식으로 set해주기 위해
							panelResult.setValue('RECEIPT_PLAN_DATE', panelResult.getValue('TEMP_COL_DATE'));
						}
					}else if(BsaCodeInfo.gsCollectDayFlg == "2"){
						panelResult.setValue('TEMP_COL_DATE', panelResult.getValue('WRITE_DATE'));//text를 날짜형식으로 set해주기 위해
						panelResult.setValue('RECEIPT_PLAN_DATE', UniDate.add(panelResult.getValue('TEMP_COL_DATE'), {days:+parseInt(gsCollectDay)}));
					}
				}
			}
		},
		fnGetParamMaster: function(){
			var taxInPutFormParams = panelResult.getValues();	//param.TAX_BILL 가져오려고..getvalue로 못가져옴..
			var taxBill = '';
			if(taxInPutFormParams.TAX_BILL == "1"){
				taxBill = '11';
			}else if(taxInPutFormParams.TAX_BILL == "2"){
				taxBill = '20';
			}else if(taxInPutFormParams.TAX_BILL == "3"){
				taxBill = '12';
			}
			var beforePubNum= panelResult.getValue('BILL_TYPE') == "1" ? "" : gsBeforePubNum;
			var originPubNum= panelResult.getValue('BILL_TYPE') == "1" ? "" : gsOriginalPubNum ;
			var paramMaster	= {
				  FLAG					: gsStatusM
				, DIV_CODE				: panelResult.getValue('BILL_DIV_CODE')
				, PUB_NUM				: panelResult.getValue('PUB_NUM')
				, BILL_TYPE				: taxBill
				, BILL_DATE				: UniDate.getDbDateStr(panelResult.getValue('WRITE_DATE'))
				, PUB_FR_DATE			: UniDate.getDbDateStr(panelResult.getValue('FR_SALE_DATE'))
				, PUB_TO_DATE			: UniDate.getDbDateStr(panelResult.getValue('TO_SALE_DATE'))
				, CUSTOM_CODE			: panelResult.getValue('CUSTOM_CODE')
				, SALE_AMT_O			: sSaleAmt
				, SALE_LOC_AMT_I		: sSaleAmt
				, TAX_AMT_O				: sTaxAmt
				, COLET_CUST_CD			: CustomCodeInfo.gsCollector
				, REMARK				: panelResult.getValue('REMARK')
				, PROJECT_NO			: panelResult.getValue('PROJECT')
				, UPDATE_DB_USER		: UserInfo.userID
				, SALE_DIV_CODE			: panelResult.getValue('SALE_DIV_CODE')
				, COLLECT_CARE			: CustomCodeInfo.gsColetCare
				, RECEIPT_PLAN_DATE		: UniDate.getDbDateStr(panelResult.getValue('RECEIPT_PLAN_DATE'))
				, TAX_CALC_TYPE			: CustomCodeInfo.gsTaxCalcType
				, SALE_PROFIT			: '*'
				, COMP_CODE				: UserInfo.compCode
				, BILL_FLAG				: panelResult.getValue('BILL_TYPE')
				, MODI_REASON			: panelResult.getValue('UPDATE_REASON')
				, SALE_PRSN				: panelResult.getValue('SALE_PRSN')
				, PROJECT_NO			: gsPjtCode
				, SERVANT_COMPANY_NUM	: panelResult.getValue('CUST_SERVANT_NUM')
				, BFO_ISSU_ID			: panelResult.getValue('BF_ISSUE')
				, BEFORE_PUB_NUM		: beforePubNum
				, ORIGIN_PUB_NUM		: originPubNum
				, PRE_SEND_YN			: panelResult.getValues().PRE_SEND_YN		//20210527 추가
				, PAY_TERMS				: panelResult.getValue('PAY_TERMS')
				
			}
			return paramMaster;
		},
		fnModifyUpdatechange: function(){ //수정발행
			var pubNum = '';
			if(gsStatusM =="D"){
				pubNum = panelResult.getValue('PUB_NUM');
			}else{
				pubNum = gsBeforePubNum;
			}
			var param = {
				  M_FLAG			: gsStatusM
				, M_COMP_CODE		: UserInfo.compCode
				, M_DIV_CODE		: panelResult.getValue('SALE_DIV_CODE')
				, M_PUB_NUM			: pubNum
				, M_ORIGIN_PUB_NUM	: gsOriginalPubNum
				, M_SALE_PRSN		: panelResult.getValue('SALE_PRSN')
				, M_REMARK			: panelResult.getValue('REMARK')
				, M_USER_ID			: UserInfo.userID
				, M_BFO_ISSU_ID		: panelResult.getValue('BF_ISSUE')
				, M_MODE			: 'modifyUpdate'
			}
			panelResult.submit({
				params: param,
				success:function(comp, action) {
					UniAppManager.updateStatus('<t:message code="system.message.sales.message033" default="저장되었습니다."/>');
					panelResult.setValue('PUB_NUM', action.result.PUB_NUM);
					UniAppManager.setToolbarButtons('save', false);
					//20190219 삭제 시, 화면 초기화
					if(gsStatusM =="D"){
						UniAppManager.app.onResetButtonDown();
						UniAppManager.setToolbarButtons('deleteAll', false);
					} else {
						UniAppManager.app.onQueryButtonDown();
						UniAppManager.setToolbarButtons('deleteAll', true);
					}
				},
				failure: function(form, action){
				}
			});
		},
		fnContractCancel: function(){	//수정발행
			var pubNum = '';
			if(gsStatusM =="D"){
				pubNum = panelResult.getValue('PUB_NUM');
			}else{
				pubNum = gsBeforePubNum;
			}
//			panelResult.setValue('PUB_NUM', pubNum);
			var param = {
				  M_FLAG			: gsStatusM
				, M_COMP_CODE		: UserInfo.compCode
				, M_DIV_CODE		: panelResult.getValue('SALE_DIV_CODE')
				, M_PUB_NUM			: pubNum
				, M_ORIGIN_PUB_NUM	: gsOriginalPubNum
				, M_SALE_PRSN		: panelResult.getValue('SALE_PRSN')
				, M_REMARK			: panelResult.getValue('REMARK')
				, M_USER_ID			: UserInfo.userID
				, M_MAKE_DATE		: UniDate.getDbDateStr(panelResult.getValue('WRITE_DATE'))
				, M_BFO_ISSU_ID		: panelResult.getValue('BF_ISSUE')
				, M_MODI_REASON		: panelResult.getValue('UPDATE_REASON')
				, M_MODE			: 'contractCancel'
			}
			panelResult.submit({
				params: param,
				success:function(comp, action) {
					UniAppManager.updateStatus('<t:message code="system.message.sales.message033" default="저장되었습니다."/>');
					panelResult.setValue('PUB_NUM', action.result.PUB_NUM);
					UniAppManager.setToolbarButtons('save', false);
					//20190219 삭제 시, 화면 초기화
					if(gsStatusM =="D"){
						UniAppManager.app.onResetButtonDown();
						UniAppManager.setToolbarButtons('deleteAll', false);
					} else {
						UniAppManager.app.onQueryButtonDown();
						UniAppManager.setToolbarButtons('deleteAll', true);
					}
				},
				failure: function(form, action){
				}
			});
		},
		fnMasterSave: function(paramMaster){	//수정발행
			var taxInPutFormParams = panelResult.getValues();	//param.TAX_BILL 가져오려고..getvalue로 못가져옴..
			var taxBill = '';
			if(taxInPutFormParams.TAX_BILL == "1"){
				taxBill = '11';
			}else if(taxInPutFormParams.TAX_BILL == "2"){
				taxBill = '20';
			}else if(taxInPutFormParams.TAX_BILL == "3"){
				taxBill = '12';
			}
			var beforePubNum = panelResult.getValue('BILL_TYPE') == "1" ? "" : gsBeforePubNum;
			var originPubNum = panelResult.getValue('BILL_TYPE') == "1" ? "" : gsOriginalPubNum ;
			var param = {
				  M_FLAG				: gsStatusM
				, M_DIV_CODE			: panelResult.getValue('BILL_DIV_CODE')
				, M_PUB_NUM				: panelResult.getValue('PUB_NUM')
				, M_BILL_TYPE			: taxBill
				, M_BILL_DATE			: UniDate.getDbDateStr(panelResult.getValue('WRITE_DATE'))
				, M_PUB_FR_DATE			: UniDate.getDbDateStr(panelResult.getValue('FR_SALE_DATE'))
				, M_PUB_TO_DATE			: UniDate.getDbDateStr(panelResult.getValue('TO_SALE_DATE'))
				, M_CUSTOM_CODE			: panelResult.getValue('CUSTOM_CODE')
				, M_SALE_AMT_O			: sSaleAmt
				, M_SALE_LOC_AMT_I		: sSaleAmt
				, M_TAX_AMT_O			: sTaxAmt
				, M_COLET_CUST_CD		: CustomCodeInfo.gsCollector
				, M_REMARK				: panelResult.getValue('REMARK')
				, M_PROJECT_NO			: panelResult.getValue('PROJECT')
				, M_UPDATE_DB_USER		: UserInfo.userID
				, M_SALE_DIV_CODE		: panelResult.getValue('SALE_DIV_CODE')
				, M_COLLECT_CARE		: CustomCodeInfo.gsColetCare
				, M_RECEIPT_PLAN_DATE	: UniDate.getDbDateStr(panelResult.getValue('RECEIPT_PLAN_DATE'))
				, M_TAX_CALC_TYPE		: CustomCodeInfo.gsTaxCalcType
				, M_SALE_PROFIT			: '*'
				, M_COMP_CODE			: UserInfo.compCode
				, M_BILL_FLAG			: panelResult.getValue('BILL_TYPE')
				, M_MODI_REASON			: panelResult.getValue('UPDATE_REASON')
				, M_SALE_PRSN			: panelResult.getValue('SALE_PRSN')
				, M_PROJECT_NO			: gsPjtCode
				, M_SERVANT_COMPANY_NUM	: panelResult.getValue('OWN_SERVANT_NUM')
				, M_BFO_ISSU_ID			: panelResult.getValue('BF_ISSUE')
				, M_BEFORE_PUB_NUM		: beforePubNum
				, M_ORIGIN_PUB_NUM		: originPubNum
				, PAY_TERMS				: panelResult.getValue('PAY_TERMS')
				, M_MODE				: ''
			}
			panelResult.submit({
				params: param,
				success:function(comp, action) {
//					panelResult.setValue('PUB_NUM', action.result.PUB_NUM);
					UniAppManager.setToolbarButtons('save', false);
					UniAppManager.updateStatus('<t:message code="system.message.sales.message033" default="저장되었습니다."/>');
				},
				failure: function(form, action){
				}
			});
		}
	});



	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "SALE_AMT_O" :
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


	//20191025 매출참조 그리드 합계 구하는 함수 생성
	function fnRefGridSum() {
		var results = referGrid.getStore().sumBy(function(record, id) {
			if(referGrid.getSelectionModel().isSelected(record)) return true;
		},
		['SALE_AMT_O', 'TAX_AMT_O']);
		referGrid.down('#SUM_SALE_AMT_O').setValue(results.SALE_AMT_O);
		referGrid.down('#SUM_TAX_AMT_O').setValue(results.TAX_AMT_O);
		referGrid.down('#TOTAL_SUM').setValue(results.SALE_AMT_O + results.TAX_AMT_O);
	}
	
	
	// 20210705 : 수금 예정일 control
	function fnControlPaymentDay(newValue){
		// 발행일
		var writeDate = panelResult.getValue('WRITE_DATE');
		if(Ext.isEmpty(writeDate)|| !Ext.isDate(writeDate)) return;

		// 결제 조건 값이 없을 경우
		if (Ext.isEmpty(newValue)){
			panelResult.setValue('RECEIPT_PLAN_DATE', writeDate);
		} else {
			var commonCodes = Ext.data.StoreManager.lookup('B034').data.items;
			Ext.each(commonCodes,function(commonCode, i) {
				// 결제 조건의 값이 같은경우
				if(commonCode.get('value') == newValue) {
					var ref1	= commonCode.get('refCode1');
					var mon		= Ext.isEmpty(commonCode.get('refCode2')) ? '0' : commonCode.get('refCode2');			// ref2 데이터 (월), 20210820 추가
					var date	= Ext.isEmpty(commonCode.get('refCode3')) ? '0' : commonCode.get('refCode3');			// ref3 데이터 (일)
					var paymentDay = '';
					
					// 결제조건이 세금계산서 발행 후일 경우
					if(ref1 == '1') {
						paymentDay = UniDate.add(writeDate	, {months	: mon});			// ref2 데이터 (월), 20210820 추가
						paymentDay = UniDate.add(paymentDay	, {days		: date});
					// 결제조건이 월마감 후일 경우: 월 말일부터 계산, 20210820 추가
					} else if(ref1 == '2') {
						paymentDay = UniDate.get('endOfMonth', writeDate);
						paymentDay = new Date(paymentDay.substring(0,4)+ '-' + paymentDay.substring(4,6)+ '-' + paymentDay.substring(6,8))
						paymentDay = UniDate.add(paymentDay, {months	: mon});
						paymentDay = UniDate.add(paymentDay, {days		: date});
					}

					// 수금 예정일 set
					panelResult.setValue('RECEIPT_PLAN_DATE', paymentDay);
				}
			})
		}
	}
}
</script>