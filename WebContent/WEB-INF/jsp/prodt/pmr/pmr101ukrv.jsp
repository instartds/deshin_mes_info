<%--
'   프로그램명 : 생산실적POP
'   작  성  자 : (주)디에스인포텍
'   작  성  일 : 2022. 12. 22
'   최종수정자 :
'   최종수정일 :
'   버      전 : MC-LINK Plus V1.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr101ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 								<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>						<!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"/>						<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="P003"/>						<!-- 불량유형 -->
	<t:ExtComboStore comboType="AU" comboCode="P002"/>						<!-- 특기사항 분류 -->
	<t:ExtComboStore comboType="AU" comboCode="P103"/>						<!-- 요청구분 -->
	<t:ExtComboStore comboType="AU" comboCode="P507"/>						<!-- 작업조 -->
	<t:ExtComboStore comboType="OU" />										<!-- 창고-->
	<t:ExtComboStore comboType="WU" />										<!-- 작업장-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고Cell-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList2" />	<!--창고Cell-->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />			<!-- 작업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />			<!--창고-->
</t:appConfig>
<style type="text/css">
	.x-form-text-field-body-default {
	    min-width: 250px !important;
	}
	.x-change-cell {
		background-color: #FFFFC6;
	}
	.x-change-cell2 {
		background-color: #FDE3FF;
	}
	.x-tool-tool-el.x-tool-img.x-tool-expand-bottom{
		transform:scale(4,2.1)!important;
		margin-left:-30px;
	}
	.x-tool-tool-el.x-tool-img.x-tool-collapse-top{
		transform:scale(4,2.1)!important;
		margin-left:-30px;
	}

</style>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" src="<c:url value='/resources/js/jquery/jquery-1.10.2.js' />" ></script>
<script type="text/javascript" src="<c:url value='/resources/js/jquery/jquery-ui-1.10.4.custom.min.js' />"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript" src="<c:url value='/resources/js/virtualKeyboard/keyboard.js' />" ></script>
<link rel="stylesheet" type="text/css" href='<c:url value="/resources/js/virtualKeyboard/keyboard.css" />'>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsManageLotNoYN	: '${gsManageLotNoYN}',		// 작업지시와 생산실적 LOT 연계여부 설정 값
	gsChkProdtDateYN: '${gsChkProdtDateYN}',	// 착수예정일 체크여부
	glEndRate		: '${glEndRate}',
	gsSumTypeCell	: '${gsSumTypeCell}',		// 재고합산유형 : 창고 Cell 합산
	gsLunchFr		: '${gsLunchFr}',			// 점심시간시작
	gsLunchTo		: '${gsLunchTo}',			// 점심시간종료
	gsSiteCode		: '${gsSiteCode}',
	gsIfCode			: '${gsIfCode}',             //작업실적데이터 연동여부
	gsIfSiteCode		: '${gsIfSiteCode}',         //작업실적데이터 연동주소
	gsIfSiteCode1		: '${gsIfSiteCode1}',        //작업실적데이터 연동주소1
	gsIfSiteCode2		: '${gsIfSiteCode2}',        //작업실적데이터 연동주소2
	gsIfCodePlan		: '${gsIfCodePlan}',         //작업지시데이터 연동여부
	gsIfSiteCodePlan	: '${gsIfSiteCodePlan}'      //작업지시데이터 연동주소
};
/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/
var gsKioskConUrl  = '${gsKioskConUrl}';
var outDivCode 	   = UserInfo.divCode;
var checkDraftStatus = false;
var outouProdtSave; // 생산실적 자동입고
var gsProdtDate; //선택한 생산일 값
var resultsAddWindow; // 생산실적등록팝업
var resultsUpdateWindow; //생산실적수정팝업
var gsSelRecord;
var gsSelRecord2;
var refItemWindow;  //벌크품목 팝업
var calPassQMethod = 'A'
var gsProdtNum = '';
var gsProdtDate1 = '';
var gsPopupChk = 'WKORD';
var sumTypeChk = true;
var labelPrintWindow;//라벨출력
var gsScanYn = 'N';//스캔여부
var weighing = 'N';//칭량저울연결여부
if(BsaCodeInfo.gsSumTypeCell == 'Y'){
	sumTypeChk = false;
}
var labelhiddenChk = true;
if(BsaCodeInfo.gsSiteCode == 'SHIN'){
	labelhiddenChk = false;
}
var gsOldValueWorkQ ; 		//생산량  이전값
var gsOldValueSavingQ ;		//관리수량 이전값
var gsOldValueGoodWorkQ ;	//양품수량 이전값
var gsOldValueBadWorkQ ;	//불량수량 이전값
var gsOldValueLossQ ;		//로스수량 이전값
var gsOldValueEtcQ ;		//기타수량 이전값
var gsOldValueBoxQ ;		//박스수량 이전값
var gsOldValueBoxTrnsRate ; //박스입수 이전값
var gsOldValuePieceQ ; 		//낱개수량 이전값
var gsLabelChk = "";
var keyPadWindow;
var gsFocus;
var searchPop2WindowInit = '';
var searchPop2Window = '';
var scaleIframe = '';

function appMain() {
	var colData = ${colData}; //불량유형 공통코드 데이터 가져오기
	var fields	= createModelField(colData);
	var columns	= createGridColumn(colData);
	var gsBadQtyInfo;
	var labelTypeStore = Unilite.createStore('labelTypeStore', {
	    fields: ['text', 'value'],
		data :  [
					{'text':'사출'	, 'value':'1'},
					{'text':'코리아나'	, 'value':'2'},
					{'text':'코스맥스'	, 'value':'3'},
					{'text':'제품표준'	, 'value':'4'}
	    		]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 작업실적 등록
		api: {
			read: 'pmr101ukrvService.selectDetailList'/*,
			update: 'pmr101ukrvService.updateDetail',
			create: 'pmr101ukrvService.insertDetail',
			destroy: 'pmr101ukrvService.deleteDetail',
			syncAll: 'pmr101ukrvService.saveAll'*/
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 작업지시별 등록
		api: {
			read: 'pmr101ukrvService.selectDetailList2',
			update: 'pmr101ukrvService.updateDetail2',
			create: 'pmr101ukrvService.insertDetail2',
			destroy: 'pmr101ukrvService.deleteDetail2',
			syncAll: 'pmr101ukrvService.saveAll2'
		}
	});

	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 공정별 등록1
		api: {
			read: 'pmr101ukrvService.selectDetailList3',
			update: 'pmr101ukrvService.updateDetail3',
			create: 'pmr101ukrvService.insertDetail3',
			destroy: 'pmr101ukrvService.deleteDetail3',
			syncAll: 'pmr101ukrvService.saveAll3'
		}
	});

	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 공정별 등록2
		api: {
			read: 'pmr101ukrvService.selectDetailList4',
			update: 'pmr101ukrvService.updateDetail4',
			create: 'pmr101ukrvService.insertDetail4',
			destroy: 'pmr101ukrvService.deleteDetail4',
			syncAll: 'pmr101ukrvService.saveAll4'
		}
	});

	var directProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 불량내역 등록
		api: {
			read: 'pmr101ukrvService.selectDetailList5',
			update: 'pmr101ukrvService.updateDetail5',
			create: 'pmr101ukrvService.insertDetail5',
			destroy: 'pmr101ukrvService.deleteDetail5',
			syncAll: 'pmr101ukrvService.saveAll5'
		}
	});

	var directProxy6 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 특기사항 등록
		api: {
			read: 'pmr101ukrvService.selectDetailList6',
			update: 'pmr101ukrvService.updateDetail6',
			create: 'pmr101ukrvService.insertDetail6',
			destroy: 'pmr101ukrvService.deleteDetail6',
			syncAll: 'pmr101ukrvService.saveAll6'
		}
	});

	var directProxy7 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 20190508 제조이력등록 탭 추가
		api: {
			read	: 'pmr101ukrvService.selectDetailList7',
			update	: 'pmr101ukrvService.updateDetail7',
			create	: 'pmr101ukrvService.insertDetail7',
			destroy	: 'pmr101ukrvService.deleteDetail7',
			syncAll	: 'pmr101ukrvService.saveAll7'
		}
	});

	var directProxy8 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 20190508 제조이력등록 탭 추가
		api: {
			read: 'pmr101ukrvService.selectDetailList8'
		}
	});

	var directProxy10 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 자재불량내역
		api: {
			read: 'pmr101ukrvService.selectDetailList10',
			update: 'pmr101ukrvService.updateDetail10',
			create: 'pmr101ukrvService.insertDetail10',
			destroy: 'pmr101ukrvService.deleteDetail10',
			syncAll: 'pmr101ukrvService.saveAll10'
		}
	});

	var progWordComboStore = new Ext.data.Store({
		storeId: 'pmr101ukrvProgWordComboStore',
		fields	: ['value', 'text','refCode1','option'],
		//autoLoad: true,
		proxy: {
			type: 'direct',
			api: {
				 read: 'UniliteComboServiceImpl.getPmp100tProgWorkCode'
				}
			},
			listeners : {
				load : function(store, records, successful, eOpts) {
					if (successful) {
					}
				}
			},
			loadStoreRecords : function(records) {
				var param = masterForm.getValues();
				param.WKORD_NUM = records.get('WKORD_NUM');
				console.log(param);
				this.load({
					params : param
				});
			}
		});

		var progWordComboStore2 = new Ext.data.Store({
			storeId : 'pmr101ukrvProgWordComboStore2',
			fields : [ 'value', 'text', 'refCode1', 'option' ],
			//autoLoad: true,
			proxy : {
				type : 'direct',
				api : {
					read : 'UniliteComboServiceImpl.getProgWorkCode'
				}
			},
			listeners : {
				load : function(store, records, successful, eOpts) {
					if (successful) {
					}
				}
			},
			loadStoreRecords : function(records) {
				var param = masterForm.getValues();
				param.WKORD_NUM = '';
				console.log(param);
				this.load({
					params : param
				});
			}
		});

		var masterForm = Unilite.createSearchPanel(
						'pmr101ukrvMasterForm',
						{
							collapsed : UserInfo.appOption.collapseLeftSearch,
							title : '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
							defaultType : 'uniSearchSubPanel',
							collapsed : UserInfo.appOption.collapseLeftSearch,
							listeners : {
								collapse : function() {
									panelResult.show();
								},
								expand : function() {
									panelResult.hide();
								}
							},
							items : [
									{
										title : '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
										itemId : 'search_panel1',
										layout : {
											type : 'uniTable',
											columns : 1
										},
										defaultType : 'uniTextfield',
										items : [
												{
													fieldLabel : '<t:message code="system.label.product.division" default="사업장"/>',
													name : 'DIV_CODE',
													xtype : 'uniCombobox',
													comboType : 'BOR120',
													allowBlank : false,
													holdable : 'hold',
													value : UserInfo.divCode,
													listeners : {
														change : function(
																field,
																newValue,
																oldValue, eOpts) {
															panelResult
																	.setValue(
																			'DIV_CODE',
																			newValue);
															masterForm
																	.setValue(
																			'WORK_SHOP_CODE',
																			'');
														}
													}
												},
												{
													fieldLabel : '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
													xtype : 'uniDateRangefield',
													startFieldName : 'PRODT_START_DATE_TO',
													endFieldName : 'PRODT_START_DATE_FR',
													//startDate: UniDate.get('startOfMonth'),
													//endDate: UniDate.get('today'),
													holdable : 'hold',
													//width : 1020,
													textFieldWidth : 400,
													onStartDateChange : function(
															field, newValue,
															oldValue, eOpts) {
														if (panelResult) {
															//panelResult.setValue('PRODT_START_DATE_FR',newValue);
														}
													},
													onEndDateChange : function(
															field, newValue,
															oldValue, eOpts) {
														if (panelResult) {
															//panelResult.setValue('PRODT_START_DATE_TO',newValue);
														}
													}
												},
												{
													xtype : 'radiogroup',
													fieldLabel : ' ',
													id : 'rdoSelect',
													items : [
															{
																boxLabel : '<t:message code="system.label.product.whole" default="전체"/>',
																width : 60,
																name : 'CONTROL_STATUS',
																inputValue : '',
																holdable : 'hold'
															//checked: true
															},
															{
																boxLabel : '<t:message code="system.label.product.process" default="진행"/>',
																width : 60,
																name : 'CONTROL_STATUS',
																holdable : 'hold',
																inputValue : '2',
																checked : true
															},
															{
																boxLabel : '<t:message code="system.label.product.closing" default="마감"/>',
																width : 60,
																name : 'CONTROL_STATUS',
																holdable : 'hold',
																inputValue : '8'
															},
															{
																boxLabel : '<t:message code="system.label.product.completion" default="완료"/>',
																width : 60,
																name : 'CONTROL_STATUS',
																holdable : 'hold',
																inputValue : '9'
															} ],
													listeners : {
														change : function(
																field,
																newValue,
																oldValue, eOpts) {
															panelResult
																	.getField(
																			'CONTROL_STATUS')
																	.setValue(
																			newValue.CONTROL_STATUS);
														}
													}
												},
												{
													fieldLabel : '<t:message code="system.label.product.workcenter" default="작업장"/>',
													name : 'WORK_SHOP_CODE',
													xtype : 'uniCombobox',
													holdable : 'hold',
													comboType : 'WU',
													allowBlank : false,
													listeners : {
														change : function(
																field,
																newValue,
																oldValue, eOpts) {
															panelResult
																	.setValue(
																			'WORK_SHOP_CODE',
																			newValue);
														},
														beforequery : function(
																queryPlan,
																eOpts) {
															var store = queryPlan.combo.store;
															var prStore = panelResult
																	.getField('WORK_SHOP_CODE').store;
															store.clearFilter();
															prStore
																	.clearFilter();
															if (!Ext
																	.isEmpty(masterForm
																			.getValue('DIV_CODE'))) {
																store
																		.filterBy(function(
																				record) {
																			return record
																					.get('option') == masterForm
																					.getValue('DIV_CODE');
																		});
																prStore
																		.filterBy(function(
																				record) {
																			return record
																					.get('option') == masterForm
																					.getValue('DIV_CODE');
																		});
															} else {
																store
																		.filterBy(function(
																				record) {
																			return false;
																		});
																prStore
																		.filterBy(function(
																				record) {
																			return false;
																		});
															}
														}
													}
												},
												{
													fieldLabel : '공정',
													name : 'S_PROG_WORK_CODE',
													xtype : 'uniCombobox',
													store : Ext.data.StoreManager
															.lookup('pmr101ukrvProgWordComboStore'),
													allowBlank : false,
													holdable : 'hold',
													listeners : {
														change : function(
																field,
																newValue,
																oldValue, eOpts) {
															panelResult
																	.setValue(
																			'S_PROG_WORK_CODE',
																			newValue);
														}
													}
												},
												Unilite.popup(
																'DIV_PUMOK',
																{
																	fieldLabel : '<t:message code="system.label.product.item" default="품목"/>',
																	holdable : 'hold',
																	validateBlank : false,
																	textFieldName : 'ITEM_NAME',
																	valueFieldName : 'ITEM_CODE',
																	validateBlank : false,
																	autoPopup : true,
																	listeners : {
																		onValueFieldChange : function(
																				field,
																				newValue) {
																			panelResult
																					.setValue(
																							'ITEM_CODE',
																							newValue);
																		},
																		onTextFieldChange : function(
																				field,
																				newValue) {
																			panelResult
																					.setValue(
																							'ITEM_NAME',
																							newValue);
																		},
																		applyextparam : function(
																				popup) {
																			popup
																					.setExtParam({
																						'DIV_CODE' : masterForm
																								.getValue('DIV_CODE')
																					});
																		}
																	}
																}),
												{
													fieldLabel : '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
													xtype : 'uniTextfield',
													name : 'WKORD_NUM',
													holdable : 'hold',
													listeners : {
														change : function(
																field,
																newValue,
																oldValue, eOpts) {
															panelResult
																	.setValue(
																			'WKORD_NUM',
																			newValue);
														},
														specialkey : function(
																field, event) {
															if (event.getKey() == event.ENTER) {
																var newValue = panelSearch
																		.getValue('WKORD_NUM');
																if (!Ext
																		.isEmpty(newValue)) {
																	if (!panelResult
																			.getInvalidMessage())
																		return false;
																	gsProdtDate = ''; //조회시 생산일자 전역변수 초기화
																	gsScanYn = 'Y';
																	//모든 탭 초기화 후, detailGrid 조회
																	directMasterStore2
																			.loadData({})
																	directMasterStore3
																			.loadData({})
																	directMasterStore4
																			.loadData({})
																	directMasterStore5
																			.loadData({})
																	directMasterStore6
																			.loadData({})
																	directMasterStore7
																			.loadData({})
																	directMasterStore8
																			.loadData({})
																	directMasterStore9
																			.loadData({})
																	detailStore
																			.loadStoreRecords();

																	UniAppManager
																			.setToolbarButtons(
																					[ 'newData' ],
																					true);

																}
															}
														}
													}
												},
												{
													fieldLabel : '<t:message code="system.label.product.workplanno" default="작업계획번호"/>',
													xtype : 'uniTextfield',
													name : 'WK_PLAN_NUM',
													listeners : {
														change : function(
																field,
																newValue,
																oldValue, eOpts) {
															panelResult
																	.setValue(
																			'WK_PLAN_NUM',
																			newValue);
														}
													}
												},
												{ //20200311 추가
													fieldLabel : '<t:message code="system.label.product.soinfo" default="수주정보"/>',
													xtype : 'uniTextfield',
													name : 'SO_INFO',
													listeners : {
														change : function(
																field,
																newValue,
																oldValue, eOpts) {
															panelResult
																	.setValue(
																			'SO_INFO',
																			newValue);
														}
													}
												},
												{
													fieldLabel : '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
													xtype : 'uniTextfield',
													name : 'WKORD_Q',
													holdable : 'hold',
													hidden : true
												},
												{
													fieldLabel : '<t:message code="system.label.product.routingcode" default="공정코드"/>',
													xtype : 'uniTextfield',
													name : 'PROG_WORK_CODE',
													holdable : 'hold',
													hidden : true
												},
												{
													fieldLabel : '<t:message code="system.label.product.item" default="품목"/>',
													xtype : 'uniTextfield',
													name : 'ITEM_CODE1',
													holdable : 'hold',
													hidden : true
												},
												{
													fieldLabel : '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>',
													xtype : 'uniTextfield',
													name : 'PRODT_NUM',
													holdable : 'hold',
													hidden : true
												}, {
													fieldLabel : 'RESULT_TYPE',
													xtype : 'uniTextfield',
													name : 'RESULT_TYPE',
													hidden : true
												} ]
									},
									{
										title : '<t:message code="system.label.inventory.additionalinfo" default="추가정보"/>',
										defaultType : 'uniTextfield',
										items : [ {
											fieldLabel : '<t:message code="system.label.product.spec" default="규격"/>',
											xtype : 'uniTextfield',
											name : 'PROD_SPEC',
											margin : '5 0 0 0',
											width : 300,
											hidden : false
										} ]
									} ],
							/*api: {
								load: 'pmr101ukrvService.selectDetailList',
								submit: 'pmr101ukrvService.syncMaster'
							},
							listeners: {
								dirtychange: function(basicForm, dirty, eOpts) {
									console.log("onDirtyChange");
									UniAppManager.setToolbarButtons('save', true);
								}
							},*/
							setAllFieldsReadOnly : function(b) {
								var r = true
								if (b) {
									var invalid = this.getForm().getFields()
											.filterBy(function(field) {
												return !field.validate();
											});
									if (invalid.length > 0) {
										r = false;
										var labelText = ''
										if (Ext
												.isDefined(invalid.items[0]['fieldLabel'])) {
											var labelText = invalid.items[0]['fieldLabel']
													+ ' : ';
										} else if (Ext
												.isDefined(invalid.items[0].ownerCt)) {
											var labelText = invalid.items[0].ownerCt['fieldLabel']
													+ ' : ';
										}
										alert(labelText + Msg.sMB083);
										invalid.items[0].focus();
									} else {
										//this.mask();
										var fields = this.getForm().getFields();
										Ext
												.each(
														fields.items,
														function(item) {
															if (Ext
																	.isDefined(item.holdable)) {
																if (item.holdable == 'hold') {
																	item
																			.setReadOnly(true);
																}
															}
															if (item.isPopupField) {
																var popupFC = item
																		.up('uniPopupField');
																if (popupFC.holdable == 'hold') {
																	popupFC
																			.setReadOnly(true);
																}
															}
														})
									}
								} else {
									//this.unmask();
									var fields = this.getForm().getFields();
									Ext.each(fields.items, function(item) {
										if (Ext.isDefined(item.holdable)) {
											if (item.holdable == 'hold') {
												item.setReadOnly(false);
											}
										}
										if (item.isPopupField) {
											var popupFC = item
													.up('uniPopupField');
											if (popupFC.holdable == 'hold') {
												item.setReadOnly(false);
											}
										}
									})
								}
								return r;
							},
							setLoadRecord : function(record) {
								var me = this;
								me.uniOpt.inLoading = false;
								me.setAllFieldsReadOnly(true);
							}
						});

		var panelResult = Unilite
				.createSearchForm(
						'resultForm',
						{
							hidden : false,
							region : 'north',
							layout : {
								type : 'uniTable',
								columns : 3,
								tableAttrs : {
									width : '99.5%'
								}
							},
							padding : '1 1 1 1',
							border : true,
							items : [
									{
										layout : {
											type : 'uniTable',
											column : 3
										},
										xtype : 'container',
										tdAttrs : {
											align : 'left'
										},
										colspan : 3,
										defaults : {
											holdable : 'hold'
										},
										items : [
												{
													fieldLabel : '<t:message code="system.label.product.division" default="사업장"/>',
													name : 'DIV_CODE',
													xtype : 'uniCombobox',
													comboType : 'BOR120',
													allowBlank : false,
													holdable : 'hold',
													value : UserInfo.divCode,
													listeners : {
														change : function(
																field,
																newValue,
																oldValue, eOpts) {
															masterForm
																	.setValue(
																			'DIV_CODE',
																			newValue);
															panelResult
																	.setValue(
																			'WORK_SHOP_CODE',
																			'');
															progWordComboStore2
																	.loadStoreRecords();
														}
													}
												},
												{
													fieldLabel : '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
													xtype : 'uniDateRangefield',
													labelWidth : 140,
													startFieldName : 'PRODT_START_DATE_FR',
													endFieldName : 'PRODT_START_DATE_TO',
													//startDate: UniDate.get('startOfMonth'),
									                //endDate: UniDate.get('today'),
													startDateFieldWidth : 120,
													endDateFieldWidth:	120,
													pickerWidth : 420,
													pickerHeight : 280,
													width : 420,
													holdable : 'hold',
													textFieldWidth : 250,
													onStartDateChange : function(
															field, newValue,
															oldValue, eOpts) {
														if (masterForm) {
															masterForm
																	.setValue(
																			'PRODT_START_DATE_FR',
																			newValue);
														}
													},
													onEndDateChange : function(
															field, newValue,
															oldValue, eOpts) {
														if (masterForm) {
															masterForm
																	.setValue(
																			'PRODT_START_DATE_TO',
																			newValue);
														}
													},
													listeners : {
													/*	el : {
															mouseover : function(
																	e, elem,
																	eOpts) {

															},
															click : function(e,
																	elem, eOpts) {

																$(
																		'.x-btn-inner-default-toolbar-small')
																		.removeClass(
																				"x-btn-inner");
																var winIds = $('.x-toolbar,x-docked,x-toolbar-default,x-docked-top,x-toolbar-docked-top,x-toolbar-default-docked-top,x-box-layout-ct');
																var winChildNodes = winIds[1].children[1];
																var winChildNodes2 = winChildNodes.childNodes
																//alert(winChildNodes.childNodes[0].childNodes);
																for (var i = 0; i < winChildNodes.childNodes[0].childElementCount; i++) {
																	if (i == 0) {
																		$(
																				'#'
																						+ winChildNodes.childNodes[0].childNodes[i].id)
																				.css(
																						"left",
																						"0px");
																	} else if (i == 1) {
																		$(
																				'#'
																						+ winChildNodes.childNodes[0].childNodes[i].id)
																				.css(
																						"left",
																						"62px");
																	} else if (i == 2) {
																		$(
																				'#'
																						+ winChildNodes.childNodes[0].childNodes[i].id)
																				.css(
																						"left",
																						"124px");
																	} else if (i == 3) {
																		$(
																				'#'
																						+ winChildNodes.childNodes[0].childNodes[i].id)
																				.css(
																						"left",
																						"186px");
																	} else if (i == 4) {
																		$(
																				'#'
																						+ winChildNodes.childNodes[0].childNodes[i].id)
																				.css(
																						"left",
																						"224px");
																	} else if (i == 5) {
																		$(
																				'#'
																						+ winChildNodes.childNodes[0].childNodes[i].id)
																				.css(
																						"left",
																						"262px");
																	} else if (i == 6) {
																		$(
																				'#'
																						+ winChildNodes.childNodes[0].childNodes[i].id)
																				.css(
																						"left",
																						"300px");
																	} else if (i == 7) {
																		$(
																				'#'
																						+ winChildNodes.childNodes[0].childNodes[i].id)
																				.css(
																						"left",
																						"334px");
																	}

																}
																var winId3 = $(
																		'.x-window-body,x-window-body-default,x-box-layout-ct,x-window-body-default,x-resizable,x-window-body-resizable,x-window-body-default-resizable')
																		.attr(
																				'id')
																$('#' + winId3)
																		.css(
																				"top",
																				"49px");
																var winId4 = $(
																		'.x-window,x-layer,x-window-default,x-border-box,x-resizable,x-window-resizable,x-window-default-resizable,x-unselectable')
																		.attr(
																				'id')
																$('#' + winId4)
																		.css(
																				"height",
																				"300px");
																$(
																		'#'
																				+ winIds[1].children[1].id)
																		.css(
																				"height",
																				"22px");
																var winId5 = $(
																		'.x-css-shadow')
																		.attr(
																				'id')
																$('#' + winId5)
																		.css(
																				"height",
																				"296px");

															}
														}*/
													}
												},
												{
													xtype : 'radiogroup',
													fieldLabel : ' ',
													id : 'rdoSelect2',
													items : [
															{
																boxLabel : '<t:message code="system.label.product.whole" default="전체"/>',
																width : 60,
																name : 'CONTROL_STATUS',
																holdable : 'hold',
																inputValue : ''
															},
															{
																boxLabel : '<t:message code="system.label.product.process" default="진행"/>',
																width : 60,
																name : 'CONTROL_STATUS',
																holdable : 'hold',
																inputValue : '2',
																checked : true
															},
															{
																boxLabel : '<t:message code="system.label.product.closing" default="마감"/>',
																width : 60,
																name : 'CONTROL_STATUS',
																holdable : 'hold',
																inputValue : '8'
															},
															{
																boxLabel : '<t:message code="system.label.product.completion" default="완료"/>',
																width : 60,
																name : 'CONTROL_STATUS',
																holdable : 'hold',
																inputValue : '9'
															} ],
													listeners : {
														change : function(
																field,
																newValue,
																oldValue, eOpts) {
															masterForm
																	.getField(
																			'CONTROL_STATUS')
																	.setValue(
																			newValue.CONTROL_STATUS);
														}
													}
												} ]

									},
									{
										layout : {
											type : 'uniTable',
											column : 4
										},
										xtype : 'container',
										tdAttrs : {
											align : 'left'
										},
										defaults : {
											holdable : 'hold'
										},
										colspan : 3,
										items : [
												{
													fieldLabel : '<t:message code="system.label.product.workcenter" default="작업장"/>',
													name : 'WORK_SHOP_CODE',
													xtype : 'uniCombobox',
													comboType : 'WU',
													allowBlank : false,
													holdable : 'hold',
													listeners : {
														change : function(
																field,
																newValue,
																oldValue, eOpts) {
															masterForm
																	.setValue(
																			'WORK_SHOP_CODE',
																			newValue);
															if ((newValue == 'WSK10' || newValue == 'WSH10')
																	&& UserInfo.divCode == '02') {//화성이고 제조 작업장일 경우에만 분동체크 팝업 실행
																weighingChkPop();
																//Ext.getCmp('btnPrint1').setDisabled(true);
															}
														},
														beforequery : function(
																queryPlan,
																eOpts) {
															var store = queryPlan.combo.store;
															var prStore = masterForm
																	.getField('WORK_SHOP_CODE').store;
															store.clearFilter();
															prStore
																	.clearFilter();
															if (!Ext
																	.isEmpty(panelResult
																			.getValue('DIV_CODE'))) {
																store
																		.filterBy(function(
																				record) {
																			return record
																					.get('option') == panelResult
																					.getValue('DIV_CODE');
																		});
																prStore
																		.filterBy(function(
																				record) {
																			return record
																					.get('option') == panelResult
																					.getValue('DIV_CODE');
																		});
															} else {
																store
																		.filterBy(function(
																				record) {
																			return false;
																		});
																prStore
																		.filterBy(function(
																				record) {
																			return false;
																		});
															}
														}
													}
												},
												{
													fieldLabel : '공정',
													name : 'S_PROG_WORK_CODE',
													xtype : 'uniCombobox',
													store : Ext.data.StoreManager
															.lookup('pmr101ukrvProgWordComboStore2'),
													allowBlank : false,
													width : 420,
													holdable : 'hold',
													listeners : {
														change : function(
																field,
																newValue,
																oldValue, eOpts) {
															masterForm
																	.setValue(
																			'S_PROG_WORK_CODE',
																			newValue);
															Ext
																	.each(
																			masterGrid3
																					.getStore().data.items,
																			function(
																					record,
																					index) {
																				if (record
																						.get('PROG_WORK_CODE') == newValue) {
																					masterGrid3
																							.getSelectionModel()
																							.select(
																									index);
																				}
																			})

														},
														beforequery : function(
																queryPlan,
																eOpts) {
															var store = queryPlan.combo.store;
															store.clearFilter();

															if (!Ext
																	.isEmpty(panelResult
																			.getValue('WORK_SHOP_CODE'))) {
																store
																		.filterBy(function(
																				record) {
																			return record
																					.get('refCode1') == panelResult
																					.getValue('WORK_SHOP_CODE');
																		});
															} else {
																store
																		.filterBy(function(
																				record) {
																			return false;
																		});
															}
														}
													}
												},
												Unilite
														.popup(
																'DIV_PUMOK',
																{
																	fieldLabel : '<t:message code="system.label.product.item" default="품목"/>',
																	validateBlank : false,
																	textFieldName : 'ITEM_NAME',
																	valueFieldName : 'ITEM_CODE',
																	validateBlank : false,
																	autoPopup : true,
																	popupWidth: 1000,

																	holdable : 'hold',
																	listeners : {
																		onValueFieldChange : function(
																				field,
																				newValue) {
																			masterForm
																					.setValue(
																							'ITEM_CODE',
																							newValue);
																		},
																		onTextFieldChange : function(
																				field,
																				newValue) {
																			masterForm
																					.setValue(
																							'ITEM_NAME',
																							newValue);
																		},
																		applyextparam : function(
																				popup) {
																			popup
																					.setExtParam({
																						'DIV_CODE' : masterForm
																								.getValue('DIV_CODE')
																					});
																		}
																	}
																}),
												{
													fieldLabel : '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
													xtype : 'uniTextfield',
													name : 'WKORD_NUM',
													labelWidth : 120,
													holdable : 'hold',
													listeners : {
														change : function(
																field,
																newValue,
																oldValue, eOpts) {
															masterForm
																	.setValue(
																			'WKORD_NUM',
																			newValue);
														},
														specialkey : function(
																field, event) {
															if (event.getKey() == event.ENTER) {
																var newValue = panelResult
																		.getValue('WKORD_NUM');
																if (!Ext
																		.isEmpty(newValue)) {
																	if (!panelResult
																			.getInvalidMessage())
																		return false;
																	gsProdtDate = ''; //조회시 생산일자 전역변수 초기화
																	gsScanYn = 'Y';
																	//모든 탭 초기화 후, detailGrid 조회
																	directMasterStore2
																			.loadData({})
																	directMasterStore3
																			.loadData({})
																	directMasterStore4
																			.loadData({})
																	directMasterStore5
																			.loadData({})
																	directMasterStore6
																			.loadData({})
																	directMasterStore7
																			.loadData({})
																	directMasterStore8
																			.loadData({})
																	directMasterStore9
																			.loadData({})
																	detailStore
																			.loadStoreRecords('scan');
																	UniAppManager
																			.setToolbarButtons(
																					[ 'newData' ],
																					true);

																}
															}
														}
													}
												} ]
									},
									{
										layout : {
											type : 'uniTable',
											column : 2
										},
										xtype : 'container',
										tdAttrs : {
											align : 'left'
										},
										defaults : {
											holdable : 'hold'
										},
										items : [
												{
													xtype : 'button',
													text : '<div style="color: blue">생산실적등록</div>',
													width : 140,
													height : 50,
													margin : '0 0 2 30',
													itemId : 'btnPrint2',
													id : 'btnPrint2',
													tdAttrs : {
														align : 'left'
													},
													handler : function(btn) {
														var detailRecord = detailGrid
																.getSelectedRecord();
														if (!Ext
																.isEmpty(detailRecord)) {
															if (detailRecord
																	.get('CONTROL_STATUS') == '9'
																	|| detailRecord
																			.get('CONTROL_STATUS') == '8') {
																return false;
															} else {
																//if(colName =="PROG_WORK_NAME") {
																openResultsAddWindow();
																tab2
																		.down(
																				'#tab2Form')
																		.getField(
																				'WORK_Q')
																		.focus();
																if ((panelResult
																		.getValue('WORK_SHOP_CODE') == 'WSK10' || panelResult
																		.getValue('WORK_SHOP_CODE') == 'WSH10')
																		&& UserInfo.divCode == '02') {//제조 작업장일 경우 칭량버튼 활성화
																	Ext
																			.getCmp(
																					'btnWeighing')
																			.setDisabled(
																					false);
																}
																//resultsAddForm.getField('PASS_Q').setStyle('color','#FFFFA1');
																//}
															}
														}
													}
												},
												{
													xtype : 'button',
													text : '<div style="color: blue">생산실적현황</div>',
													width : 140,
													height : 50,
													margin : '0 0 2 40',
													itemId : 'btnPrint3',
													id : 'btnPrint3',
													tdAttrs : {
														align : 'left'
													},
													handler : function(btn) {
														var detailRecord = detailGrid
																.getSelectedRecord();
														if (!Ext
																.isEmpty(detailRecord)) {
															openResultsUpdateWindow();
														}
													}
												} ]
									},
									{
										layout : {
											type : 'uniTable',
											column : 1
										},
										xtype : 'container',
										tdAttrs : {
											align : 'left'
										},
										defaults : {
											holdable : 'hold'
										},
										items : [ {
											xtype : 'component',
											html : '',
											style : {
												marginTop : '3px !important',
												font : '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
											}
										} ]
									},
									{
										layout : {
											type : 'uniTable',
											column : 3
										},
										xtype : 'container',
										tdAttrs : {
											align : 'right'
										},
										defaults : {
											holdable : 'hold'
										},
										items : [
												{
													xtype : 'button',
													text : '<div style="color: blue">조회</div>',
													width : 140,
													height : 50,
													margin : '0 100 2 0',
													padding : '1 1 1 1',
													itemId : 'btnPrint1',
													id : 'btnPrint1',
													tdAttrs : {
														align : 'right'
													},
													handler : function(btn) {
														if (!panelResult
																.getInvalidMessage())
															return false;
														gsProdtDate = ''; //조회시 생산일자 전역변수 초기화

														//모든 탭 초기화 후, detailGrid 조회
														directMasterStore2
																.loadData({})
														directMasterStore3
																.loadData({})
														directMasterStore4
																.loadData({})
														directMasterStore5
																.loadData({})
														directMasterStore6
																.loadData({})
														directMasterStore7
																.loadData({})
														directMasterStore8
																.loadData({})
														directMasterStore9
																.loadData({})
														detailStore
																.loadStoreRecords();
														UniAppManager
																.setToolbarButtons(
																		[ 'newData' ],
																		true)
														if ((panelResult
																.getValue('WORK_SHOP_CODE') == 'WSK10' || panelResult
																.getValue('WORK_SHOP_CODE') == 'WSH10')
																&& UserInfo.divCode == '02') {//제조 작업장일 경우 칭량저울팝업 실행
															weighingPop();
														}
													}
												},
												{
													xtype : 'button',
													text : '<div style="color: blue">신규</div>',
													width : 140,
													height : 50,
													margin : '0 0 2 0',
													padding : '1 1 1 1',
													itemId : 'btnPrint4',
													id : 'btnPrint4',
													tdAttrs : {
														align : 'right'
													},
													handler : function(btn) {
														UniAppManager.app
																.suspendEvents();
														masterForm.clearForm();
														panelResult.clearForm();

														masterForm
																.setAllFieldsReadOnly(false);
														panelResult
																.setAllFieldsReadOnly(false);
														detailGrid.reset();
														masterGrid2.reset();
														masterGrid3.reset();
														masterGrid4.reset();
														masterGrid5.reset();
														masterGrid6.reset();
														masterGrid7.reset();
														masterGrid8.reset();
														masterGrid9.reset();
														UniAppManager.app
																.fnInitBinding();
														detailStore.clearData();
														directMasterStore2
																.clearData();
														directMasterStore3
																.clearData();
														directMasterStore4
																.clearData();
														directMasterStore5
																.clearData();
														directMasterStore6
																.clearData();
														directMasterStore7
																.clearData();
														directMasterStore8
																.clearData();
														directMasterStore9
																.clearData();
													}
												},
												{
													xtype : 'button',
													text : '<div style="color: blue">닫기</div>',
													width : 140,
													height : 50,
													margin : '0 0 2 0',
													itemId : 'btnPrint5',
													id : 'btnPrint5',
													tdAttrs : {
														align : 'right'
													},
													handler : function(btn) {
														if (weighing == 'Y') {
															scaleIframe
																	.postMessage(
																			{
																				command : "disConnectStomp"
																			},
																			'*');
														}
														self.close();
													}
												} ]
									}, {
										fieldLabel : 'GS_FR_TIME',
										name : 'GS_FR_TIME',
										xtype : 'timefield',
										format : 'H:i',
										increment : 10,
										width : 185,
										readOnly : false,
										hidden : true,
										fieldStyle : 'text-align: center;'
									}, {
										fieldLabel : 'GS_TO_TIME',
										name : 'GS_TO_TIME',
										xtype : 'timefield',
										format : 'H:i',
										increment : 10,
										width : 185,
										readOnly : false,
										hidden : true,
										fieldStyle : 'text-align: center;'
									} ],
							setAllFieldsReadOnly : function(b) {
								var r = true
								if (b) {
									var invalid = this.getForm().getFields()
											.filterBy(function(field) {
												return !field.validate();
											});
									if (invalid.length > 0) {
										r = false;
										var labelText = ''
										if (Ext
												.isDefined(invalid.items[0]['fieldLabel'])) {
											var labelText = invalid.items[0]['fieldLabel']
													+ ' : ';
										} else if (Ext
												.isDefined(invalid.items[0].ownerCt)) {
											var labelText = invalid.items[0].ownerCt['fieldLabel']
													+ ' : ';
										}
										alert(labelText + Msg.sMB083);
										invalid.items[0].focus();
									} else {
										//this.mask();
										var fields = this.getForm().getFields();
										Ext
												.each(
														fields.items,
														function(item) {
															if (Ext
																	.isDefined(item.holdable)) {
																if (item.holdable == 'hold') {
																	item
																			.setReadOnly(true);
																}
															}
															if (item.isPopupField) {
																var popupFC = item
																		.up('uniPopupField');
																if (popupFC.holdable == 'hold') {
																	popupFC
																			.setReadOnly(true);
																}
															}
														})
									}
								} else {
									//this.unmask();
									var fields = this.getForm().getFields();
									Ext.each(fields.items, function(item) {
										if (Ext.isDefined(item.holdable)) {
											if (item.holdable == 'hold') {
												item.setReadOnly(false);
											}
										}
										if (item.isPopupField) {
											var popupFC = item
													.up('uniPopupField');
											if (popupFC.holdable == 'hold') {
												item.setReadOnly(false);
											}
										}
									})
								}
								return r;
							}
						});

		Unilite
				.defineModel(
						'pmr101ukrvDetailModel',
						{
							fields : [
									{
										name : 'CONTROL_STATUS',
										text : '<t:message code="system.label.product.status" default="상태"/>',
										type : 'string',
										comboType : "AU",
										comboCode : "P001"
									},
									{
										name : 'WKORD_NUM',
										text : '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
										type : 'string'
									},
									{
										name : 'ITEM_CODE',
										text : '<t:message code="system.label.product.item" default="품목"/>',
										type : 'string'
									},
									{
										name : 'ITEM_NAME',
										text : '<t:message code="system.label.product.itemname" default="품목명"/>',
										type : 'string'
									},
									{
										name : 'SPEC',
										text : '<t:message code="system.label.product.spec" default="규격"/>',
										type : 'string'
									},
									{
										name : 'STOCK_UNIT',
										text : '<t:message code="system.label.product.unit" default="단위"/>',
										type : 'string'
									},
									{
										name : 'WKORD_Q',
										text : '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
										type : 'uniQty'
									},
									{
										name : 'PRODT_START_DATE',
										text : '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
										type : 'uniDate'
									},
									{
										name : 'PRODT_END_DATE',
										text : '<t:message code="system.label.product.workenddate" default="작업완료일"/>',
										type : 'uniDate'
									},
									{
										name : 'WK_PLAN_NUM',
										text : '<t:message code="system.label.product.workplanno" default="작업계획번호"/>',
										type : 'string'
									},
									{
										name : 'ORDER_NUM',
										text : '<t:message code="system.label.product.sono" default="수주번호"/>',
										type : 'string'
									},
									{
										name : 'PROJECT_NO',
										text : '<t:message code="system.label.product.projectno" default="프로젝트번호"/>',
										type : 'string'
									},
									{
										name : 'PJT_CODE',
										text : '<t:message code="system.label.product.projectno" default="프로젝트번호"/>',
										type : 'string'
									},
									{
										name : 'REMARK',
										text : '<t:message code="system.label.product.remarks" default="비고"/>',
										type : 'string'
									},
									//Hidden: true
									{
										name : 'PROG_WORK_CODE',
										text : '<t:message code="system.label.product.routingcode" default="공정코드"/>',
										type : 'string'
									},
									{
										name : 'WORK_SHOP_CODE',
										text : '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>',
										type : 'string',
										comboType : "WU"
									},
									{
										name : 'WORK_Q',
										text : '<t:message code="system.label.product.workqty" default="작업량"/>',
										type : 'uniQty'
									},
									{
										name : 'PRODT_Q',
										text : '<t:message code="system.label.product.productionqty" default="생산량"/>',
										type : 'uniQty'
									},
									{
										name : 'LINE_END_YN',
										text : '<t:message code="system.label.product.lastroutingexistyn" default="최종공정유무"/>',
										type : 'string'
									},
									{
										name : 'WORK_END_YN',
										text : '<t:message code="system.label.product.closingyn" default="마감여부"/>',
										type : 'string'
									},
									{
										name : 'LINE_SEQ',
										text : '<t:message code="system.label.product.routingorder" default="공정순서"/>',
										type : 'string'
									},
									{
										name : 'PROG_UNIT',
										text : '<t:message code="system.label.product.routingresultunit" default="공정실적단위"/>',
										type : 'string'
									},
									{
										name : 'PROG_UNIT_Q',
										text : '<t:message code="system.label.product.routingunitqty" default="공정원단위량"/>',
										type : 'uniQty'
									},
									{
										name : 'OUT_METH',
										text : '<t:message code="system.label.product.issuemethod" default="출고방법"/>',
										type : 'string'
									},
									{
										name : 'AB',
										text : ' ',
										type : 'string'
									},
									{
										name : 'LOT_NO',
										text : '<t:message code="system.label.product.lotno" default="LOT번호"/>',
										type : 'string'
									},
									{
										name : 'RESULT_YN',
										text : '<t:message code="system.label.product.receiptmethod" default="입고방법"/>',
										type : 'string'
									},
									{
										name : 'INSPEC_YN',
										text : '<t:message code="system.label.product.receiptmethod" default="입고방법"/>',
										type : 'string'
									},
									{
										name : 'WH_CODE',
										text : '<t:message code="system.label.product.basiswarehouse" default="기준창고"/>',
										type : 'string'
									},
									{
										name : 'BASIS_P',
										text : '<t:message code="system.label.product.inventoryamount" default="재고금액"/>',
										type : 'string'
									},
									{
										name : 'DIV_CODE',
										text : '<t:message code="system.label.product.division" default="사업장"/>',
										type : 'string'
									},
									{
										name : 'INSPEC_TYPE',
										text : 'INSPEC_TYPE',
										type : 'string'
									},
									{
										name : 'STD_ITEM_ACCOUNT',
										text : 'STD_ITEM_ACCOUNT',
										type : 'string'
									},
									{
										name : 'DVRY_DATE',
										text : '납기변경일',
										type : 'uniDate'
									},
									{
										name : 'INIT_DVRY_DATE',
										text : '납품요청일',
										type : 'uniDate'
									},
									{
										name : 'ORDER_SEQ',
										text : '순번',
										type : 'string'
									},
									{
										name : 'ITEM_LEVEL1',
										text : 'ITEM_LEVEL1',
										type : 'string'
									},
									{
										name : 'EXPIRATION_DAY',
										text : 'EXPIRATION_DAY',
										type : 'int'
									},
									{
										name : 'ITEM_ACCOUNT',
										text : 'ITEM_ACCOUNT',
										type : 'string'
									},

									{
										name : 'SOF_CUSTOM_NAME',
										text : '수주처명',
										type : 'string'
									},
									{
										name : 'SOF_ITEM_NAME',
										text : '수주제품명',
										type : 'string'
									},

									{
										name : 'EQUIP_CODE',
										text : '<t:message code="system.label.product.facilities" default="설비"/>',
										type : 'string'
									},
									{
										name : 'EQUIP_NAME',
										text : '<t:message code="system.label.product.facilitiesname" default="설비명"/>',
										type : 'string'
									} ]
						});

		var detailStore = Unilite.createStore('pmr101ukrvDetailStore',
				{
					model : 'pmr101ukrvDetailModel',
					autoLoad : false,
					uniOpt : {
						isMaster : true, // 상위 버튼 연결
						editable : true, // 수정 모드 사용
						deletable : true, // 삭제 가능 여부
						useNavi : false
					// prev | next 버튼 사용
					},
					proxy : directProxy,
					loadStoreRecords : function(scan) {
						var param = panelResult.getValues();
						var scanCode = panelResult.getValue('WKORD_NUM').split(
								"/");
						param.WKORD_NUM = scanCode[0];
						console.log(param);
						this.load({
							params : param,
							callback : function(records, options, success) {
								if (success) {

								}
							}
						});
					},
					listeners : {
						load : function(store, records, successful, eOpts) {
							if (!Ext.isEmpty(records)) {
								//masterForm.setAllFieldsReadOnly(true);
								//panelResult.setAllFieldsReadOnly(true);
								masterForm.getField('DIV_CODE').setReadOnly(
										true);
								masterForm.getField('WORK_SHOP_CODE')
										.setReadOnly(true);
								panelResult.getField('DIV_CODE').setReadOnly(
										true);
								panelResult.getField('WORK_SHOP_CODE')
										.setReadOnly(true);

								//					UniAppManager.setToolbarButtons(['newData', 'delete'], false);
							} else {
								//					UniAppManager.app.onResetButtonDown();
							}
						},
						add : function(store, records, index, eOpts) {
						},
						update : function(store, record, operation,
								modifiedFieldNames, eOpts) {
						},
						remove : function(store, record, index, isMove, eOpts) {
						}
					}
				});

		/** Master Grid1 정의(Grid Panel)
		 * @type
		 */
		var detailGrid = Unilite.createGrid('pmr101ukrvGrid', {
			store : detailStore,
			layout : 'fit',
			region : 'center',
			title : "작업지시현황",
			flex : 2,
			uniOpt : {
				expandLastColumn : false,
				onLoadSelectFirst : true,
				useRowNumberer : false,
				userToolbar : false
			},
			columns : [ {
				dataIndex : 'CONTROL_STATUS',
				width : 53,
				locked : false
			}, {
				dataIndex : 'WKORD_NUM',
				width : 150,
				locked : false
			}, {
				dataIndex : 'WORK_SHOP_CODE',
				width : 100,
				hidden : false,
				hidden : true
			}, {
				dataIndex : 'ITEM_CODE',
				width : 100,
				locked : false
			}, {
				dataIndex : 'ITEM_NAME',
				width : 170,
				locked : false
			}, {
				dataIndex : 'SPEC',
				width : 150,
				locked : false
			}, {
				dataIndex : 'STOCK_UNIT',
				width : 53,
				align : 'center',
				locked : false
			}, {
				dataIndex : 'WKORD_Q',
				width : 130,
				locked : false
			}, {
				dataIndex : 'PRODT_START_DATE',
				width : 120
			}, {
				dataIndex : 'PRODT_END_DATE',
				width : 120
			}, {
				dataIndex : 'WK_PLAN_NUM',
				width : 120,
				hidden : true
			}, {
				dataIndex : 'LOT_NO',
				width : 133,
				hidden : true
			}, {
				dataIndex : 'ORDER_NUM',
				width : 120
			}, {
				dataIndex : 'ORDER_SEQ',
				width : 70,
				align : 'center'
			}, {
				dataIndex : 'INIT_DVRY_DATE',
				width : 100,
				hidden : true
			}, {
				dataIndex : 'DVRY_DATE',
				width : 100,
				hidden : true
			}, {
				dataIndex : 'PROJECT_NO',
				width : 133,
				hidden : true
			}, {
				dataIndex : 'REMARK',
				width : 200,
				hidden : true
			},
			//			{dataIndex: 'PJT_CODE'			, width: 133},
			{
				dataIndex : 'PROG_WORK_CODE',
				width : 0,
				hidden : true
			}, {
				dataIndex : 'WORK_Q',
				width : 0,
				hidden : true
			}, {
				dataIndex : 'PRODT_Q',
				width : 0,
				hidden : true
			}, {
				dataIndex : 'LINE_END_YN',
				width : 0,
				hidden : true
			}, {
				dataIndex : 'WORK_END_YN',
				width : 0,
				hidden : true
			}, {
				dataIndex : 'LINE_SEQ',
				width : 0,
				hidden : true
			}, {
				dataIndex : 'PROG_UNIT',
				width : 0,
				hidden : true
			}, {
				dataIndex : 'PROG_UNIT_Q',
				width : 0,
				hidden : true
			}, {
				dataIndex : 'OUT_METH',
				width : 0,
				hidden : true
			}, {
				dataIndex : 'AB',
				width : 0,
				hidden : true
			},

			{
				dataIndex : 'RESULT_YN',
				width : 10,
				hidden : true
			}, {
				dataIndex : 'INSPEC_YN',
				width : 0,
				hidden : true
			}, {
				dataIndex : 'WH_CODE',
				width : 0,
				hidden : true
			}, {
				dataIndex : 'BASIS_P',
				width : 0,
				hidden : true
			}, {
				dataIndex : 'DIV_CODE',
				width : 10,
				hidden : true
			}, {
				dataIndex : 'INSPEC_TYPE',
				width : 10,
				hidden : true
			}, {
				dataIndex : 'STD_ITEM_ACCOUNT',
				width : 10,
				hidden : true
			}, {
				dataIndex : 'ITEM_LEVEL1',
				width : 10,
				hidden : true
			}, {
				dataIndex : 'ITEM_ACCOUNT',
				width : 10,
				hidden : true
			}, {
				dataIndex : 'EXPIRATION_DAY',
				width : 80,
				hidden : true
			},

			{
				dataIndex : 'SOF_CUSTOM_NAME',
				width : 150,
				hidden : true
			}, {
				dataIndex : 'SOF_ITEM_NAME',
				width : 200,
				hidden : true
			},

			{
				dataIndex : 'EQUIP_CODE',
				width : 150,
				hidden : true
			}, {
				dataIndex : 'EQUIP_NAME',
				width : 200,
				hidden : true
			}, {
				text : '라벨',
				width : 120,
				xtype : 'widgetcolumn',
				hidden : labelhiddenChk,
				widget : {
					xtype : 'button',
					text : '라벨 출력',
					disabled : labelhiddenChk,
					listeners : {
						buffer : 1,
						click : function(button, event, eOpts) {
							if (BsaCodeInfo.gsSiteCode == 'SHIN') {
								gsSelRecord2 = event.record.data;
								gsLabelChk = "PMP";
								openLabelPrintWindow();
							} else {
								var gsSelRecord = event.record.data;
								masterGrid4.printLabelBtn(gsSelRecord);
							}
						}
					}
				}
			} ],
			listeners : {
				beforeedit : function(editor, e, eOpts) {
					if (e.record.phantom == false) {
						return false;
					} else {
						return false;
					}
				},
				selectionchange : function(model1, selected, eOpts) {
					if (selected.length > 0) {
						var record = selected[0];
						var activeTabId = tab.getActiveTab().getId();
						progWordComboStore.loadStoreRecords(record);
						this.returnCell(record);
						if (activeTabId == 'pmr101ukrvGrid2') {
							directMasterStore2.loadStoreRecords();
						} else if (activeTabId == 'pmr101ukrvGrid3_1') {
							directMasterStore3.loadStoreRecords();
						} else if (activeTabId == 'pmr101ukrvGrid5') {
							directMasterStore5.loadStoreRecords();
						} else if (activeTabId == 'pmr101ukrvGrid6') {
							directMasterStore6.loadStoreRecords();
						} else {
							directMasterStore8.loadStoreRecords();
						}
					}
				},
				afterrender : function(grid) {

				}
			},
			returnCell : function(record) {
				var itemCode = record.get("ITEM_CODE");
				var prodtNum = record.get("PRODT_NUM");
				masterForm.setValues({
					'ITEM_CODE1' : itemCode
				});
				masterForm.setValues({
					'PRODT_NUM' : prodtNum
				});
			}
		});

		/** 작업지시별등록 정의
		 * @type
		 */
		Unilite
				.defineModel(
						'pmr101ukrvModel2',
						{ //Pmr100ns3v.htm
							fields : [
									{
										name : 'PRODT_DATE',
										text : '<t:message code="system.label.product.productionqty" default="생산일자"/>',
										type : 'uniDate'
									},
									{
										name : 'PRODT_Q',
										text : '<t:message code="system.label.product.productionqty" default="생산량"/>',
										type : 'uniQty',
										allowBlank : false
									},
									{
										name : 'GOOD_PRODT_Q',
										text : '<t:message code="system.label.product.gooditemqty" default="양품량"/>',
										type : 'uniQty',
										allowBlank : false
									},
									{
										name : 'BAD_PRODT_Q',
										text : '<t:message code="system.label.product.defectqty" default="불량수량"/>',
										type : 'uniQty'
									},
									{
										name : 'DAY_NIGHT',
										text : '<t:message code="system.label.product.workteam" default="작업조"/>',
										type : 'string',
										comboType : 'AU',
										comboCode : 'P507',
										defaultValue : '1'
									},
									{
										name : 'MAN_HOUR',
										text : '<t:message code="system.label.product.inputtime" default="투입공수"/>',
										type : 'float',
										decimalPrecision : 2,
										format : '0,000.00'
									},

									{
										name : 'MAN_CNT',
										text : '작업인원',
										type : 'float',
										decimalPrecision : 0,
										format : '0,0000',
										allowBlank : true
									},

									{
										name : 'FR_TIME',
										text : '<t:message code="system.label.product.workhourfrom" default="시작시간"/>',
										type : 'uniTime',
										hidden  : true,
										format : 'Hi'
									},
									{
										name : 'TO_TIME',
										text : '<t:message code="system.label.product.workhourto" default="종료시간"/>',
										type : 'uniTime',
										format : 'Hi'
									},
									{
										name : 'LUNCH_CHK',
										text : '점심시간제외',
										type : 'boolean'
									},

									{
										name : 'WKORD_Q',
										text : '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
										type : 'uniQty'
									},
									{
										name : 'PRODT_SUM',
										text : '<t:message code="system.label.product.productiontotal" default="양품누계"/>',
										type : 'uniQty'
									},
									{
										name : 'JAN_Q',
										text : '<t:message code="system.label.product.productionleftqty" default="생산잔량"/>',
										type : 'uniQty'
									},
									{
										name : 'IN_STOCK_Q',
										text : '<t:message code="system.label.product.receiptqty" default="입고량"/>',
										type : 'uniQty'
									},
									{
										name : 'LOT_NO',
										text : '<t:message code="system.label.product.lotno" default="LOT번호"/>',
										type : 'string'
									},
									{
										name : 'REMARK',
										text : '<t:message code="system.label.product.remarks" default="비고"/>',
										type : 'string'
									},
									{
										name : 'PROJECT_NO',
										text : '<t:message code="system.label.product.projectno" default="프로젝트번호"/>',
										type : 'string'
									},
									{
										name : 'PJT_CODE',
										text : '<t:message code="system.label.product.projectno" default="프로젝트번호"/>',
										type : 'string'
									},
									{
										name : 'FR_SERIAL_NO',
										text : '<t:message code="system.label.product.serialno" default="시리얼번호"/>(<t:message code="system.label.product.start" default="시작"/>)',
										type : 'string'

									},
									{
										name : 'TO_SERIAL_NO',
										text : '<t:message code="system.label.product.serialno" default="시리얼번호"/>(<t:message code="system.label.product.end" default="종료"/>)',
										type : 'string'
									},
									//Hidden:true
									{
										name : 'NEW_DATA',
										text : 'NEW_DATA',
										type : 'string'
									},
									{
										name : 'PRODT_NUM',
										text : '<t:message code="system.label.product.productionresultno" default="생산실적번호"/>',
										type : 'string'
									},
									{
										name : 'PROG_WORK_CODE',
										text : '<t:message code="system.label.product.routingcode" default="공정코드"/>',
										type : 'string'
									},
									{
										name : 'UPDATE_DB_USER',
										text : '<t:message code="system.label.product.updateuser" default="수정자"/>',
										type : 'string'
									},
									{
										name : 'UPDATE_DB_TIME',
										text : '<t:message code="system.label.product.updatedate" default="수정일"/>',
										type : 'uniDate'
									},
									{
										name : 'COMP_CODE',
										text : '<t:message code="system.label.product.companycode2" default="회사코드"/>',
										type : 'string'
									},
									{
										name : 'DIV_CODE',
										text : '<t:message code="system.label.product.division" default="사업장"/>',
										type : 'string'
									},
									{
										name : 'WORK_SHOP_CODE',
										text : '<t:message code="system.label.product.workcenter" default="작업장"/>',
										type : 'string'
									},
									{
										name : 'ITEM_CODE',
										text : '<t:message code="system.label.product.item" default="품목"/>',
										type : 'string'
									},
									{
										name : 'CONTROL_STATUS',
										text : 'CONTROL_STATUS',
										type : 'string'
									},
									{
										name : 'GOOD_WH_CODE',
										text : '<t:message code="system.label.product.goodreceiptwarehouse" default="양품입고창고"/>',
										type : 'string'
									},
									{
										name : 'GOOD_PRSN',
										text : '<t:message code="system.label.product.goodreceiptincharge" default="양품입고담당"/>',
										type : 'string'
									},
									{
										name : 'BAD_WH_CODE',
										text : '<t:message code="system.label.product.defectreceiptwarehouse" default="불량입고창고"/>',
										type : 'string'
									},
									{
										name : 'BAD_PRSN',
										text : '<t:message code="system.label.product.defectreceiptincharge" default="불량입고담당"/>',
										type : 'string'
									},
									//20180605 추가
									{
										name : 'WKORD_NUM',
										text : 'WKORD_NUM',
										type : 'string'
									},
									{
										name : 'GOOD_WH_CELL_CODE',
										text : '<t:message code="system.label.product.goodwarehousecell" default="양품창고cell"/>',
										type : 'string'
									},
									{
										name : 'BAD_WH_CELL_CODE',
										text : '<t:message code="system.label.product.badwarehousecell" default="불량창고cell"/>',
										type : 'string'
									} ]
						});

		/** 공정별등록 정의 center
		 * @type
		 */
		Unilite
				.defineModel(
						'pmr101ukrvModel3',
						{ //Pmr100ns1v.htm
							fields : [
									{
										name : 'SEQ',
										text : '<t:message code="system.label.product.seq" default="순번"/>',
										type : 'string'
									},
									{
										name : 'PROG_WORK_NAME',
										text : '<t:message code="system.label.product.routingname" default="공정명"/>',
										type : 'string'
									},
									{
										name : 'PROG_UNIT',
										text : '<t:message code="system.label.product.unit" default="단위"/>',
										type : 'string'
									},
									{
										name : 'PROG_WKORD_Q',
										text : '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
										type : 'uniQty'
									},
									{
										name : 'SUM_Q',
										text : '<t:message code="system.label.product.productiontotal2" default="생산누계"/>',
										type : 'uniQty'
									},
									{
										name : 'PRODT_DATE',
										text : '<t:message code="system.label.product.productiondate" default="생산일자"/>',
										type : 'uniDate',
										allowBlank : false
									},
									{
										name : 'WORK_Q',
										text : '<t:message code="system.label.product.productionqty" default="생산량"/>',
										type : 'uniQty',
										allowBlank : false
									},
									{
										name : 'GOOD_WORK_Q',
										text : '<t:message code="system.label.product.gooditemqty" default="양품량"/>',
										type : 'uniQty',
										allowBlank : false
									},
									{
										name : 'BAD_WORK_Q',
										text : '<t:message code="system.label.product.defectqty" default="불량수량"/>',
										type : 'uniQty'
									},
									{
										name : 'DAY_NIGHT',
										text : '<t:message code="system.label.product.workteam" default="작업조"/>',
										type : 'string',
										comboType : 'AU',
										comboCode : 'P507',
										defaultValue : '1'
									},
									{
										name : 'MAN_HOUR',
										text : '<t:message code="system.label.product.inputtime" default="투입공수"/>',
										type : 'uniQty'
									},

									{
										name : 'FR_TIME',
										text : '<t:message code="system.label.product.workhourfrom" default="시작시간"/>',
										type : 'uniTime',
										format : 'Hi'
									},
									{
										name : 'TO_TIME',
										text : '<t:message code="system.label.product.workhourto" default="종료시간"/>',
										type : 'uniTime',
										format : 'Hi'
									},

									{
										name : 'JAN_Q',
										text : '<t:message code="system.label.product.productionleftqty" default="생산잔량"/>',
										type : 'uniQty'
									},
									{
										name : 'LOT_NO',
										text : '<t:message code="system.label.product.lotno" default="LOT번호"/>',
										type : 'string'
									},
									{
										name : 'FR_SERIAL_NO',
										text : '<t:message code="system.label.product.serialno" default="시리얼번호"/>(시작)',
										type : 'string'
									},
									{
										name : 'TO_SERIAL_NO',
										text : '<t:message code="system.label.product.serialno" default="시리얼번호"/>(종료)',
										type : 'string'
									},
									{
										name : 'REMARK',
										text : '<t:message code="system.label.product.remarks" default="비고"/>',
										type : 'string'
									},
									//Hidden: true
									{
										name : 'DIV_CODE',
										text : '<t:message code="system.label.product.division" default="사업장"/>',
										type : 'string'
									},
									{
										name : 'PROG_WORK_CODE',
										text : '<t:message code="system.label.product.routingcode" default="공정코드"/>',
										type : 'string'
									},
									{
										name : 'PASS_Q',
										text : '<t:message code="system.label.product.productionqty" default="양품생산량"/>',
										type : 'uniQty'
									},
									{
										name : 'WKORD_NUM',
										text : '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
										type : 'string'
									},
									{
										name : 'LINE_END_YN',
										text : '<t:message code="system.label.product.lastyn" default="최종여부"/>',
										type : 'string'
									},
									{
										name : 'WK_PLAN_NUM',
										text : '<t:message code="system.label.product.planno" default="계획번호"/>',
										type : 'string'
									},
									{
										name : 'PRODT_NUM',
										text : '',
										type : 'string'
									},
									{
										name : 'CONTROL_STATUS',
										text : '',
										type : 'string'
									},
									{
										name : 'UPDATE_DB_USER',
										text : '<t:message code="system.label.product.updateuser" default="수정자"/>',
										type : 'string'
									},
									{
										name : 'UPDATE_DB_TIME',
										text : '<t:message code="system.label.product.updatedate" default="수정일"/>',
										type : 'uniDate'
									},
									{
										name : 'COMP_CODE',
										text : '<t:message code="system.label.product.companycode2" default="회사코드"/>',
										type : 'string'
									},
									{
										name : 'GOOD_WH_CODE',
										text : '<t:message code="system.label.product.goodreceiptwarehouse" default="양품입고창고"/>',
										type : 'string'
									},
									{
										name : 'GOOD_PRSN',
										text : '<t:message code="system.label.product.goodreceiptincharge" default="양품입고담당"/>',
										type : 'string'
									},
									{
										name : 'BAD_WH_CODE',
										text : '<t:message code="system.label.product.defectreceiptwarehouse" default="불량입고창고"/>',
										type : 'string'
									},
									{
										name : 'BAD_PRSN',
										text : '<t:message code="system.label.product.defectreceiptincharge" default="불량입고담당"/>',
										type : 'string'
									},
									{
										name : 'MOLD_CODE',
										text : '금형',
										type : 'string'
									},
									{
										name : 'MOLD_NAME',
										text : '금형명',
										type : 'string'
									},
									{
										name : 'CAVIT_BASE_Q',
										text : '캐비티',
										type : 'uniQty'
									},
									{
										name : 'EQUIP_CODE',
										text : '<t:message code="system.label.product.facilities" default="설비"/>',
										type : 'string'
									},
									{
										name : 'EQUIP_NAME',
										text : '<t:message code="system.label.product.facilitiesname" default="설비명"/>',
										type : 'string'
									},
									{
										name : 'PRODT_PRSN',
										text : '<t:message code="system.label.product.worker" default="작업자"/>',
										type : 'string',
										comboType : 'AU',
										comboCode : 'P505'
									},
									//			{name: 'EXPIRATION_DATE',text: '<t:message code="system.label.product.expirationdate" default="유통기한"/>'			,type:'uniDate'	, allowBlank:true},
									//			{name: 'BOX_TRNS_RATE'	,text: 'BOX입수'					,type:'float', decimalPrecision: 0, format:'0,0000'	, allowBlank:true},
									//			{name: 'BOX_Q'			,text: 'BOX수량'					,type:'float', decimalPrecision: 0, format:'0,0000'	, allowBlank:true},
									//			{name: 'SAVING_Q'		,text: '관리수량'					,type:'float', decimalPrecision: 0, format:'0,0000'	, allowBlank:true},
									{
										name : 'MAN_CNT',
										text : '작업인원',
										type : 'float',
										decimalPrecision : 0,
										format : '0,0000',
										allowBlank : true
									},
									//			{name: 'HAZARD_CHECK'	,text: '유해물질검사요청'		,type:'bool'	, allowBlank:true},
									//			{name: 'MICROBE_CHECK'	,text: '미생물검사요청'		,type:'bool'	, allowBlank:true},
									//			{name: 'LUNCH_CHK'          , text: '점심시간제외'       , type: 'boolean'},
									//			{name: 'PIECE'          , text: '<t:message code="system.label.product.piece" default="낱개"/>'     		,type:'float', decimalPrecision: 0, format:'0,0000'	},
									//			{name: 'LOSS_Q'          , text: 'LOSS량'      ,type:'uniQty'},
									//			{name: 'YIELD'          , text: '<t:message code="system.label.product.yield" default="수율(%)"/>'     	     ,type:'float', decimalPrecision: 2, format:'0,000.00'},
									//			{name: 'ETC_Q'          , text: '<t:message code="system.label.product.etcqty" default="기타수량"/>'      ,type:'float', decimalPrecision: 0, format:'0,0000'},
									{
										name : 'GOOD_WH_CELL_CODE',
										text : '<t:message code="system.label.product.goodwarehousecell" default="양품창고cell"/>',
										type : 'string'
									},
									{
										name : 'BAD_WH_CELL_CODE',
										text : '<t:message code="system.label.product.badwarehousecell" default="불량창고cell"/>',
										type : 'string'
									} ]
						});

		/** 공정별등록 정의 east
		 * @type
		 */
		Unilite
				.defineModel(
						'pmr101ukrvModel4',
						{ //Pmr100ns1v.htm
							fields : [
									{
										name : 'PRODT_NUM',
										text : '<t:message code="system.label.product.productionno" default="생산번호"/>',
										type : 'string'
									},
									{
										name : 'PRODT_DATE',
										text : '<t:message code="system.label.product.productiondate" default="생산일자"/>',
										type : 'uniDate'
									},
									{
										name : 'FR_TIME',
										text : '<t:message code="system.label.product.workhourfrom" default="시작"/>',
										type : 'uniTime',
										format : 'Hi'
									},
									{
										name : 'TO_TIME',
										text : '<t:message code="system.label.product.workhourto" default="종료"/>',
										type : 'uniTime',
										format : 'Hi'
									},

									{
										name : 'WORK_Q',
										text : '<t:message code="system.label.product.productionqty" default="생산량"/>',
										type : 'uniQty'
									},
									{
										name : 'GOOD_WORK_Q',
										text : '<t:message code="system.label.product.gooditemqty" default="양품수량"/>',
										type : 'uniQty'
									},
									{
										name : 'BAD_WORK_Q',
										text : '<t:message code="system.label.product.defectqty" default="불량수량"/>',
										type : 'uniQty'
									},
									{
										name : 'DAY_NIGHT',
										text : '<t:message code="system.label.product.workteam" default="작업조"/>',
										type : 'string',
										comboType : 'AU',
										comboCode : 'P507',
										defaultValue : '1'
									},
									{
										name : 'MAN_CNT',
										text : '작업인원',
										type : 'uniQty',
										allowBlank : true
									},
									{
										name : 'MAN_HOUR',
										text : '<t:message code="system.label.product.inputtime" default="투입공수"/>',
										type : 'float',
										decimalPrecision : 2,
										format : '0,000.00'
									},
									{
										name : 'PRODT_PRSN',
										text : '<t:message code="system.label.product.worker" default="작업자"/>',
										type : 'string',
										comboType : 'AU',
										comboCode : 'P505'
									},
									{
										name : 'EQUIP_CODE',
										text : '<t:message code="system.label.product.facilities" default="설비"/>',
										type : 'string'
									},
									{
										name : 'EQUIP_NAME',
										text : '<t:message code="system.label.product.facilitiesname" default="설비명"/>',
										type : 'string'
									},
									{
										name : 'IN_STOCK_Q',
										text : '<t:message code="system.label.product.receiptqty" default="입고량"/>',
										type : 'uniQty'
									},
									{
										name : 'LOT_NO',
										text : '<t:message code="system.label.product.lotno" default="LOT번호"/>',
										type : 'string'
									}

							//Hidden.2022.12.23
							//			{name: 'FR_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(시작)'			,type:'string'},
							//			{name: 'TO_SERIAL_NO'	,text: '<t:message code="system.label.product.serialno" default="시리얼번호"/>(종료)'			,type:'string'},
							//			{name: 'REMARK'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'						,type:'string'},
							//			//Hidden: true
							//			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'					,type:'string'},
							//			{name: 'PROG_WKORD_Q'	,text: ''				,type:'uniQty'},
							//			{name: 'PASS_Q'		,text: ''				,type:'uniQty'},
							//			{name: 'PROG_WORK_CODE'	,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'				,type:'string'},
							//			{name: 'WKORD_NUM'		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			,type:'string'},
							//			{name: 'WK_PLAN_NUM'	,text: '<t:message code="system.label.product.planno" default="계획번호"/>'					,type:'string'},
							//			{name: 'LINE_END_YN'	,text: '<t:message code="system.label.product.lastyn" default="최종여부"/>'					,type:'string'},
							//			{name: 'COMP_CODE'		,text: '<t:message code="system.label.product.companycode2" default="회사코드"/>'				,type:'string'},
							//			{name: 'CONTROL_STATUS'	,text: ''				,type:'string'},
							//			{name: 'GOOD_WH_CODE'	,text: '<t:message code="system.label.product.goodreceiptwarehouse" default="양품입고창고"/>'	,type:'string'},
							//			{name: 'GOOD_PRSN'		,text: '<t:message code="system.label.product.goodreceiptincharge" default="양품입고담당"/>'	,type:'string'},
							//			{name: 'BAD_WH_CODE'	,text: '<t:message code="system.label.product.defectreceiptwarehouse" default="불량입고창고"/>'	,type:'string'},
							//			{name: 'BAD_PRSN'		,text: '<t:message code="system.label.product.defectreceiptincharge" default="불량입고담당"/>'	,type:'string'},
							//			{name: 'MOLD_CODE'		,text: '금형'					,type:'string'},
							//			{name: 'MOLD_NAME'		,text: '금형명'				,type:'string'},

							//			{name: 'EXPIRATION_DATE',text: '<t:message code="system.label.product.expirationdate" default="유통기한"/>'			,type:'uniDate'	, allowBlank:true},
							//			{name: 'BOX_TRNS_RATE'	,text: 'BOX입수'		,type:'float'	 , decimalPrecision: 0, format:'0,000'	, allowBlank:true},
							//			{name: 'BOX_Q'			,text: 'BOX수량'			,type:'float', decimalPrecision: 0, format:'0,000'	, allowBlank:true},
							//			{name: 'SAVING_Q'		,text: '관리수량'			,type:'uniQty'	, allowBlank:true},

							//{name: 'HAZARD_CHECK'	,text: '유해물질검사요청'	,type:'bool'	, allowBlank:true},
							//{name: 'MICROBE_CHECK'	,text: '미생물검사요청'		,type:'bool'	, allowBlank:true},
							//			{name: 'PIECE'          , text: '<t:message code="system.label.product.piece" default="낱개"/>'     ,type:'float', decimalPrecision: 0, format:'0,000'},
							//			{name: 'LOSS_Q'         , text:  'LOSS량'      ,type:'uniQty'},
							//			{name: 'YIELD'          , text: '<t:message code="system.label.product.yield" default="수율(%)"/>'     ,type:'float', decimalPrecision: 2, format:'0,000.00'},
							//			{name: 'ETC_Q'         , text: '<t:message code="system.label.product.etcqty" default="기타수량"/>'      ,type:'float', decimalPrecision: 0, format:'0,0000'},

							]
						});

		/** 불량내역등록
		 * @type
		 */
		Unilite
				.defineModel(
						'pmr101ukrvModel5',
						{
							fields : [
									{
										name : 'WKORD_NUM',
										text : '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
										type : 'string',
										allowBlank : false
									},
									{
										name : 'PROG_WORK_CODE',
										text : '<t:message code="system.label.product.routingname" default="공정명"/>',
										type : 'string',
										store : Ext.data.StoreManager
												.lookup('pmr101ukrvProgWordComboStore'),
										allowBlank : false
									},
									{
										name : 'PRODT_DATE',
										text : '<t:message code="system.label.product.occurreddate" default="발생일"/>',
										type : 'uniDate',
										allowBlank : false
									},
									{
										name : 'BAD_CODE',
										text : '<t:message code="system.label.product.defecttype" default="불량유형"/>',
										type : 'string',
										allowBlank : false,
										comboType : 'AU',
										comboCode : 'P003'
									},
									{
										name : 'BAD_Q',
										text : '<t:message code="system.label.product.qty" default="수량"/>',
										type : 'uniQty',
										allowBlank : false
									},
									{
										name : 'REMARK',
										text : '<t:message code="system.label.product.issueandmeasures" default="문제점 및 대책"/>',
										type : 'string'
									},
									//Hidden : true
									{
										name : 'DIV_CODE',
										text : '<t:message code="system.label.product.division" default="사업장"/>',
										type : 'string'
									},
									{
										name : 'WORK_SHOP_CODE',
										text : '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>',
										type : 'string'
									},
									//{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'},
									{
										name : 'ITEM_CODE',
										text : '<t:message code="system.label.product.itemname" default="품목명"/>',
										type : 'string'
									},
									{
										name : 'UPDATE_DB_USER',
										text : '<t:message code="system.label.product.updateuser" default="수정자"/>',
										type : 'string'
									},
									{
										name : 'UPDATE_DB_TIME',
										text : '<t:message code="system.label.product.updatedate" default="수정일"/>',
										type : 'uniDate'
									},
									{
										name : 'COMP_CODE',
										text : '<t:message code="system.label.product.companycode2" default="회사코드"/>',
										type : 'string'
									} ]
						});

		/** 특기사항등록
		 * @type
		 */
		Unilite
				.defineModel(
						'pmr101ukrvModel6',
						{
							fields : [
									{
										name : 'WKORD_NUM',
										text : '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
										type : 'string'
									},
									{
										name : 'PROG_WORK_CODE',
										text : '<t:message code="system.label.product.routingname" default="공정명"/>',
										type : 'string',
										store : Ext.data.StoreManager
												.lookup('pmr101ukrvProgWordComboStore'),
										allowBlank : false
									},
									{
										name : 'PRODT_DATE',
										text : '<t:message code="system.label.product.occurreddate" default="발생일"/>',
										type : 'uniDate',
										allowBlank : false
									},
									{
										name : 'CTL_CD1',
										text : '<t:message code="system.label.product.specialremarkclass" default="특기사항 분류"/>',
										type : 'string',
										allowBlank : false,
										comboType : 'AU',
										comboCode : 'P002'
									},
									{
										name : 'TROUBLE_TIME',
										text : '<t:message code="system.label.product.occurredtime" default="발생시간"/>',
										type : 'float',
										decimalPrecision : 2,
										format : '0,000.00'
									},
									{
										name : 'TROUBLE',
										text : '<t:message code="system.label.product.summary" default="요약"/>',
										type : 'string'
									},
									{
										name : 'TROUBLE_CS',
										text : '<t:message code="system.label.product.reason" default="원인"/>',
										type : 'string'
									},
									{
										name : 'ANSWER',
										text : '<t:message code="system.label.product.action" default="조치"/>',
										type : 'string'
									},
									{
										name : 'SEQ',
										text : '',
										type : 'int'
									},
									//Hidden : true
									{
										name : 'DIV_CODE',
										text : '<t:message code="system.label.product.division" default="사업장"/>',
										type : 'string'
									},
									{
										name : 'WORK_SHOP_CODE',
										text : '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>',
										type : 'string'
									},
									//{name: 'PROG_WORK_CODE' ,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'},
									{
										name : 'UPDATE_DB_USER',
										text : '<t:message code="system.label.product.updateuser" default="수정자"/>',
										type : 'string'
									},
									{
										name : 'UPDATE_DB_TIME',
										text : '<t:message code="system.label.product.updatedate" default="수정일"/>',
										type : 'uniDate'
									},
									{
										name : 'COMP_CODE',
										text : '<t:message code="system.label.product.companycode2" default="회사코드"/>',
										type : 'string'
									},
									{
										name : 'FR_TIME',
										text : '<t:message code="system.label.product.workhourfrom" default="시작"/>',
										type : 'uniTime',
										format : 'Hi'
									},
									{
										name : 'TO_TIME',
										text : '<t:message code="system.label.product.workhourto" default="종료"/>',
										type : 'uniTime',
										format : 'Hi'
									} ]
						});

		/** 20190508 제조이력등록 탭 추가
		 * @type
		 */
		Unilite
				.defineModel(
						'pmr101ukrvModel7',
						{
							fields : [
									//공통정보
									{
										name : 'COMP_CODE',
										text : 'COMP_CODE',
										type : 'string'
									},
									{
										name : 'DIV_CODE',
										text : '<t:message code="system.label.product.division" default="사업장"/>',
										type : 'string'
									},
									{
										name : 'WORK_SHOP_CODE',
										text : '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>',
										type : 'string'
									},
									{
										name : 'WKORD_NUM',
										text : '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
										type : 'string'
									},
									{
										name : 'ITEM_CODE',
										text : '<t:message code="system.label.product.childitemcode" default="자품목"/>',
										type : 'string'
									},
									{
										name : 'ITEM_NAME',
										text : '<t:message code="system.label.product.childitemname" default="자품목명"/>',
										type : 'string'
									},
									//PMR500T 정보
									{
										name : 'SEQ',
										text : '<t:message code="system.label.product.seq" default="순번"/>',
										type : 'string'
									},
									{
										name : 'PRODT_DATE',
										text : '<t:message code="system.label.product.occurreddate" default="발생일"/>',
										type : 'uniDate'
									},
									{
										name : 'MODIFY_RATE',
										text : '증감(%)',
										type : 'string'
									},
									{
										name : 'REMARK',
										text : '<t:message code="system.label.product.remarks" default="비고"/>',
										type : 'string'
									},
									//PMP200T 데이터
									{
										name : 'REF_TYPE',
										text : '<t:message code="system.label.product.requestclassification" default="요청구분"/>',
										type : 'string',
										comboType : "AU",
										comboCode : "P103"
									},
									{
										name : 'PATH_CODE',
										text : '<t:message code="system.label.product.pathinfo" default="PATH정보"/>',
										type : 'string'
									},
									{
										name : 'UNIT_Q',
										text : '<t:message code="system.label.product.originunitqty" default="원단위량"/>',
										type : 'float',
										decimalPrecision : 6,
										format : '0,000.000000'
									},
									{
										name : 'ALLOCK_Q',
										text : '<t:message code="system.label.product.allocationqty" default="예약량"/>',
										type : 'float',
										decimalPrecision : 6,
										format : '0,000.000000'
									},
									//그외 데이터
									{
										name : 'PRODT_NUM',
										text : '<t:message code="system.label.product.productionno" default="생산번호"/>',
										type : 'string'
									},
									{
										name : 'SPEC',
										text : '<t:message code="system.label.product.spec" default="규격"/>',
										type : 'string'
									},
									{
										name : 'STOCK_UNIT',
										text : '<t:message code="system.label.product.unit" default="단위"/>',
										type : 'string'
									} ]
						});

		//자재불량내역 모델 필드 생성
		function createModelField(colData) {
			var fields = [
					{
						name : 'COMP_CODE',
						text : '<t:message code="system.label.product.compcode" default="법인코드"/>',
						type : 'string'
					},
					{
						name : 'DIV_CODE',
						text : '<t:message code="system.label.product.division" default="사업장"/>',
						type : 'string'
					},
					{
						name : 'ITEM_CODE',
						text : '<t:message code="system.label.product.item" default="품목"/>',
						type : 'string'
					},
					{
						name : 'ITEM_NAME',
						text : '<t:message code="system.label.product.itemname" default="품목명"/>',
						type : 'string'
					},
					{
						name : 'SPEC',
						text : '<t:message code="system.label.product.spec" default="규격"/>',
						type : 'string'
					},
					{
						name : 'STOCK_UNIT',
						text : '<t:message code="system.label.product.unit" default="단위"/>',
						type : 'string',
						comboType : 'AU',
						comboCode : 'B013',
						displayField : 'value'
					},
					{
						name : 'CUSTOM_CODE',
						text : '<t:message code="system.label.product.custom" default="거래처코드"/>',
						type : 'string'
					},
					{
						name : 'CUSTOM_NAME',
						text : '<t:message code="system.label.product.customname" default="거래처 명"/>',
						type : 'string'
					},
					{
						name : 'WORK_SHOP_CODE',
						text : '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>',
						type : 'string'
					},
					{
						name : 'WKORD_NUM',
						text : '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
						type : 'string'
					},
					{
						name : 'PRODT_NUM',
						text : '<t:message code="system.label.product.productionno" default="생산번호"/>',
						type : 'string'
					},
					{
						name : 'SEQ',
						text : '<t:message code="system.label.product.seq" default="순번"/>',
						type : 'string'
					}, {
						name : 'SAVE_FLAG',
						text : 'SAVE_FLAG',
						type : 'string'
					} ];
			//동적 컬럼 모델 push
			Ext.each(colData, function(item, index) {
				fields.push({
					name : 'BAD_' + item.SUB_CODE,
					type : 'uniQty'
				});
			});
			console.log(fields);
			return fields;
		}

		//자재불량내역 그리드 컬럼 생성
		function createGridColumn(colData) {
			var array1 = new Array();
			var columns = [
					{
						dataIndex : 'SAVE_FLAG',
						width : 66,
						hidden : true
					},
					{
						dataIndex : 'COMP_CODE',
						width : 66,
						hidden : true
					},
					{
						dataIndex : 'DIV_CODE',
						width : 66,
						hidden : true
					},
					{
						dataIndex : 'SEQ',
						width : 40,
						align : 'center',
						hidden : false,
						locked : true
					},
					{
						dataIndex : 'WKORD_NUM',
						width : 66,
						hidden : true
					},
					{
						dataIndex : 'WORK_SHOP_CODE',
						width : 66,
						hidden : true
					},
					{
						dataIndex : 'PRODT_NUM',
						width : 66,
						hidden : true
					},
					{
						dataIndex : 'ITEM_CODE',
						width : 90,
						locked : true
					},
					{
						dataIndex : 'ITEM_NAME',
						width : 250,
						locked : true
					},
					{
						dataIndex : 'SPEC',
						width : 70,
						locked : false,
						align : 'center'
					},
					{
						dataIndex : 'STOCK_UNIT',
						width : 50,
						align : 'center',
						locked : false
					},
					{
						dataIndex : 'CUSTOM_CODE',
						width : 70,
						locked : false,
						hidden : true,
						editor : Unilite
								.popup(
										'AGENT_CUST_G',
										{
											autoPopup : true,
											listeners : {
												'onSelected' : {
													fn : function(records, type) {
														// var grdRecord =
														// Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
														if (gsPopupChk == 'RESULT') {
															var grdRecord = masterGrid12.uniOpt.currentRecord;
														} else {
															var grdRecord = masterGrid10.uniOpt.currentRecord;
														}
														grdRecord
																.set(
																		'CUSTOM_CODE',
																		records[0]['CUSTOM_CODE']);
														grdRecord
																.set(
																		'CUSTOM_NAME',
																		records[0]['CUSTOM_NAME']);
													},
													scope : this
												},
												'onClear' : function(type) {
													// var grdRecord =
													// Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
													if (gsPopupChk == 'RESULT') {
														var grdRecord = masterGrid12.uniOpt.currentRecord;
													} else {
														var grdRecord = masterGrid10.uniOpt.currentRecord;
													}
													grdRecord.set(
															'CUSTOM_CODE', '');
													grdRecord.set(
															'CUSTOM_NAME', '');
												}
											}
										})
					},
					{
						dataIndex : 'CUSTOM_NAME',
						width : 150,
						locked : false,
						editor : Unilite
								.popup(
										'AGENT_CUST_G',
										{
											autoPopup : true,
											listeners : {
												'onSelected' : {
													fn : function(records, type) {
														// var grdRecord =
														// Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
														if (gsPopupChk == 'RESULT') {
															var grdRecord = masterGrid12.uniOpt.currentRecord;
														} else {
															var grdRecord = masterGrid10.uniOpt.currentRecord;
														}

														grdRecord
																.set(
																		'CUSTOM_CODE',
																		records[0]['CUSTOM_CODE']);
														grdRecord
																.set(
																		'CUSTOM_NAME',
																		records[0]['CUSTOM_NAME']);
													},
													scope : this
												},
												'onClear' : function(type) {
													// var grdRecord =
													// Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
													if (gsPopupChk == 'RESULT') {
														var grdRecord = masterGrid12.uniOpt.currentRecord;
													} else {
														var grdRecord = masterGrid10.uniOpt.currentRecord;
													}
													grdRecord.set(
															'CUSTOM_CODE', '');
													grdRecord.set(
															'CUSTOM_NAME', '');
												}
											}
										})
					} ];
			Ext.each(colData, function(item, index) {
				if (index == 0) {
					gsBadQtyInfo = item.SUB_CODE;
				} else {
					gsBadQtyInfo += ',' + item.SUB_CODE;
				}
				array1[index] = Ext.applyIf({
					dataIndex : 'BAD_' + item.SUB_CODE,
					text : item.CODE_NAME,
					flex : 1
				}, {
					align : 'right',
					xtype : 'uniNnumberColumn',
					format : UniFormat.Qty
				});
			});
			columns
					.push({
						text : '<t:message code="system.label.product.defectinfo" default="불량정보"/>',
						columns : array1
					});
			console.log(columns);
			return columns;
		}

		Unilite.defineModel('pmr101ukrvModel10', {
			fields : fields
		});

		var directMasterStore2 = Unilite
				.createStore(
						'pmr101ukrvMasterStore2',
						{
							model : 'pmr101ukrvModel2',
							uniOpt : {
								isMaster : true, // 상위 버튼 연결
								editable : true, // 수정 모드 사용
								deletable : true, // 삭제 가능 여부
								useNavi : false
							// prev | next 버튼 사용
							},
							autoLoad : false,
							proxy : directProxy2,
							loadStoreRecords : function() {
								var param = masterForm.getValues();
								var record = detailGrid.getSelectedRecord();
								if (!Ext.isEmpty(record)) {
									param.WKORD_NUM = record.get('WKORD_NUM');
									param.WKORD_Q = record.get('WKORD_Q');
									param.PROG_WORK_CODE = record
											.get('PROG_WORK_CODE');
								}
								console.log(param);
								this.load({
									params : param,
									callback : function(records, operation,
											success) {
										if (success) {
											directMasterStore2.commitChanges();
										}
									}
								});
							},
							saveStore : function(config) {
								var inValidRecs = this.getInvalidRecords();
								var toCreate = this.getNewRecords();
								var toUpdate = this.getUpdatedRecords();
								var toDelete = this.getRemovedRecords();
								var list = [].concat(toUpdate, toCreate,
										toDelete);
								console.log("inValidRecords : ", inValidRecs);
								console.log("list:", list);

								console
										.log(
												"this.data.filterBy(this.filterInvalidNewRecords).items : ",
												this.data
														.filterBy(this.filterInvalidNewRecords));

								//1. 마스터 정보 파라미터 구성
								var paramMaster = masterForm.getValues(); //syncAll 수정

								if (inValidRecs.length == 0) {
									var detailRecord = detailGrid
											.getSelectedRecord();
									//				var saveFlag	= true;

									var fnCal = 0;
									var prodtSum = this.sumBy(function(record,
											id) {
										return true
									}, [ 'PRODT_Q' ]);
									var A = detailRecord.get('WKORD_Q'); //작업지시량
									var D = detailRecord.get('LINE_END_YN');

									if (D == 'Y') {
										fnCal = (prodtSum.PRODT_Q / A) * 100
									} else {
										fnCal = 0;
									}
									if (fnCal > (100 * (BsaCodeInfo.glEndRate / 100))) {
										//					saveFlag	= false;
										alert('<t:message code="system.message.product.message009" default="초과 생산 실적 범위를 벗어났습니다."/>');
										return false;
									}
									//				if (saveFlag) {
									if (fnCal >= '95' /*|| ((fnCal < '95') && detailRecord.get('CONTROL_STATUS') == '9')*/) {
										if (confirm('<t:message code="system.message.product.confirm004" default="완료하시겠습니까?"/>')) {
											Ext
													.each(
															list,
															function(record2, i) {
																record2
																		.set(
																				'CONTROL_STATUS',
																				'9');
															});

										} else {
											Ext
													.each(
															list,
															function(record2, i) {
																if (detailRecord
																		.get('CONTROL_STATUS') == '9') {
																	record2
																			.set(
																					'CONTROL_STATUS',
																					'3');
																}
															});
										}
									} else {
										Ext
												.each(
														list,
														function(record2, i) {
															if (detailRecord
																	.get('CONTROL_STATUS') == '9') {
																record2
																		.set(
																				'CONTROL_STATUS',
																				'3');
															}
														});
									}
									//				}
									//				if (!saveFlag) {
									//					saveFlag = true;
									//					return false;
									//				}

									config = {
										params : [ paramMaster ],
										success : function(batch, option) {
											//2.마스터 정보(Server 측 처리 시 가공)
											var master = batch.operations[0]
													.getResultSet();
											var record = detailGrid
													.getSelectedRecord();
											if (!Ext
													.isEmpty(master.CONTROL_STATUS)) {
												record.set("CONTROL_STATUS",
														master.CONTROL_STATUS);
												detailGrid.getStore()
														.commitChanges();
											}
											//3.기타 처리
											masterForm.getForm().wasDirty = false;
											masterForm.resetDirtyStatus();
											console
													.log("set was dirty to false");
											UniAppManager.setToolbarButtons(
													'save', false);
											directMasterStore2
													.loadStoreRecords();
										}
									};
									this.syncAllDirect(config);
								} else {
									var grid = Ext.getCmp('pmr101ukrvGrid2');
									grid
											.uniSelectInvalidColumnAndAlert(inValidRecs);
								}
							},
							listeners : {
								load : function(store, records, successful,
										eOpts) {
									var wkordQ = detailGrid.getSelectedRecord()
											.get('WKORD_Q');
									if (!Ext.isEmpty(records)) {
										var prodtSum = 0;
										var janQ = wkordQ;
										Ext
												.each(
														records,
														function(record, i) {
															prodtSum = prodtSum
																	+ record
																			.get('PRODT_SUM');
															janQ = janQ
																	- record
																			.get('PRODT_Q');
															record
																	.set(
																			'PRODT_SUM',
																			prodtSum);
															record.set('JAN_Q',
																	janQ);
														});
									}
								}
							}
						});

		var directMasterStore3 = Unilite
				.createStore(
						'pmr101ukrvMasterStore3',
						{
							model : 'pmr101ukrvModel3',
							uniOpt : {
								isMaster : true, // 상위 버튼 연결
								editable : true, // 수정 모드 사용
								deletable : false, // 삭제 가능 여부
								useNavi : false
							// prev | next 버튼 사용
							},
							autoLoad : false,
							proxy : directProxy3,
							loadStoreRecords : function() {
								var param = masterForm.getValues();
								var record = detailGrid.getSelectedRecord();
								if (!Ext.isEmpty(record)) {
									param.WKORD_NUM = record.get('WKORD_NUM');
									param.WKORD_Q = record.get('WKORD_Q');
									param.PROG_WORK_CODE = record
											.get('PROG_WORK_CODE');
								}
								console.log(param);
								this.load({
									params : param
								});
							},
							saveStore : function(config) {

								//
								//			Ext.each(list, function(record,i) {
								//
								//			});
								//

								var inValidRecs = this.getInvalidRecords();
								var toCreate = this.getNewRecords();
								var toUpdate = this.getUpdatedRecords();
								var toDelete = this.getRemovedRecords();
								var list = [].concat(toUpdate, toCreate);
								console.log("inValidRecords : ", inValidRecs);
								console.log("list:", list);

								console
										.log(
												"this.data.filterBy(this.filterInvalidNewRecords).items : ",
												this.data
														.filterBy(this.filterInvalidNewRecords));

								//1. 마스터 정보 파라미터 구성
								var paramMaster = masterForm.getValues(); //syncAll 수정

								//2. 초과실적 체크로직
								if (inValidRecs.length == 0) {
									var detailRecord = detailGrid
											.getSelectedRecord();
									var saveFlag = true;
									var fnCal = 0;
									Ext
											.each(
													list,
													function(record, i) {
														var prodtSum = record
																.get('SUM_Q')
																+ record
																		.get('WORK_Q');
														var A = record
																.get('PROG_WKORD_Q'); //작업지시량
														var D = record
																.get('LINE_END_YN');

														if (D == 'Y') {
															fnCal = (prodtSum / A) * 100
														} else {
															fnCal = 0;
														}
														if (fnCal > (100 * (BsaCodeInfo.glEndRate / 100))) {
															saveFlag = false;
															alert('<t:message code="system.message.product.message009" default="초과 생산 실적 범위를 벗어났습니다."/>');
															return false;
														}
														if (D == 'Y') {
															if (fnCal >= 95/* || ((fnCal < '95') && detailRecord.get('CONTROL_STATUS') == '9')*/) {
																if (confirm('<t:message code="system.message.product.confirm004" default="완료하시겠습니까?"/>')) {
																	record
																			.set(
																					'CONTROL_STATUS',
																					'9');

																} else {
																	if (detailRecord
																			.get('CONTROL_STATUS') == '9') {
																		record
																				.set(
																						'CONTROL_STATUS',
																						'3');
																	}
																}
															} else {
																if (detailRecord
																		.get('CONTROL_STATUS') == '9') {
																	record
																			.set(
																					'CONTROL_STATUS',
																					'3');
																}
															}
														}
													});

									if (!saveFlag) {
										return false;
									}

									config = {
										params : [ paramMaster ],
										success : function(batch, option) {
											//2.마스터 정보(Server 측 처리 시 가공)
											var master = batch.operations[0]
													.getResultSet();
											var record = detailGrid
													.getSelectedRecord();
											if (!Ext.isEmpty(master.PRODT_NUM)) {
												gsProdtNum = master.PRODT_NUM;
												if (directMasterStore10
														.isDirty()) {
													directMasterStore10
															.saveStore();
												}
											}
											if (!Ext
													.isEmpty(master.CONTROL_STATUS)) {
												record.set("CONTROL_STATUS",
														master.CONTROL_STATUS);
												detailGrid.getStore()
														.commitChanges();
											}

											masterForm.getForm().wasDirty = false;
											masterForm.resetDirtyStatus();
											console
													.log("set was dirty to false");

											//작업실적데이터 MES연동사용시
											if (BsaCodeInfo.gsIfCode == 'Y') {

												var param = {
													"S_COMP_CODE" : UserInfo.compCode,
													"DIV_CODE" : panelResult
															.getValue('DIV_CODE'),
													"WKORD_NUM" : record
															.get('WKORD_NUM'),
													"GS_PRODT_NUM" : gsProdtNum
												};

												pmr100ukrvService
														.selectInterfaceInfo(
																param,
																function(
																		provider,
																		response) {
																	var records = response.result;
																	if (!Ext
																			.isEmpty(provider)) {
																		//								Ext.each(records, function(record,i) {
																		var sparamAcmslt = { //실적정보 포장인 경우만
																			if_seq : provider[0]['IF_SEQ_1'],
																			company_no : provider[0]['COMPANY_NO'],
																			prdctn_dt : provider[0]['PRDCTN_DT'],
																			prdctn_product_no : provider[0]['PRDCTN_PRODUCT_NO'],
																			prdctn_product_cd : provider[0]['PRDCTN_PRODUCT_CD'],
																			prdctn_product_nm : provider[0]['PRDCTN_PRODUCT_NM'],
																			plan_outtrn : provider[0]['PLAN_OUTTRN'],
																			acmslt_outtrn : provider[0]['ACMSLT_OUTTRN'],
																			unit_cd : provider[0]['UNIT_CD'],
																			progrs_kind_cd : provider[0]['PROGRS_KIND_CD'],
																			member_no : provider[0]['MEMBER_NO'],
																			acmslt_i_or_d : provider[0]['ACMSLT_I_OR_D'],
																			wrkshp_ty : provider[0]['WRKSHP_TY']
																		};

																		var sparamPlan = {//작업지시정보 성형,충전,포장 전부
																			if_seq : provider[0]['IF_SEQ_2'],
																			company_no : provider[0]['COMPANY_NO'],
																			prdctn_dt : provider[0]['PRDCTN_DT'],
																			prdctn_product_no : provider[0]['PRDCTN_PRODUCT_NO'],
																			prdctn_product_cd : provider[0]['PRDCTN_PRODUCT_CD'],
																			prdctn_product_nm : provider[0]['PRDCTN_PRODUCT_NM'],
																			plan_outtrn : provider[0]['PLAN_OUTTRN'],
																			acmslt_outtrn : provider[0]['ACMSLT_OUTTRN'],
																			unit_cd : provider[0]['UNIT_CD'],
																			erp_lot_no : provider[0]['ERP_LOT_NO'],
																			packng_qy : provider[0]['PACKNG_QTY'],
																			member_no : provider[0]['MEMBER_NO'],
																			ordr_i_or_d : 'I',
																			order_num : provider[0]['ORDER_NUM'],
																			wrkshp_ty : provider[0]['WRKSHP_TY']
																		};

																		//										console.log("연동1"+sparam.if_seq);
																		//										console.log("연동2"+sparam.prdctn_product_no);
																		//										console.log("연동3"+sparam.plan_outtrn);
																		//										console.log("연동4"+sparam.acmslt_i_or_d);

																		Ext.Ajax
																				.request({ //작업지시 데이터 연동(성형, 충전, 포장)
																					url : '',
																					method : 'POST',
																					params : sparamPlan,
																					cors : true,
																					useDefaultXhrHeader : false,
																					//												async	: true,
																					success : function(
																							response) {
																						if (!Ext
																								.isEmpty(response)) {
																							/*	if(provider[0]['WRKSHP_TY'] == '03'){//포장일 경우
																									Ext.Ajax.request({ //작업실적 데이터 연동
																												url	: '',
																												method:'POST',
																												params	: sparamAcmslt,
																												cors: true,
																												useDefaultXhrHeader : false,
																											//	async	: true,
																												success	: function(response){
																													if(!Ext.isEmpty(response)){
																													Unilite.messageBox('MES연동데이터  전송되었습니다.');
																													}
																												},
																												failure: function (response, options) {
																												    alert( "failed: " + response.responseText );

																												  }
																											});


																								}else{
																									Unilite.messageBox('MES연동데이터  전송되었습니다.');
																								}*/
																							Unilite
																									.messageBox('MES연동데이터  전송되었습니다.');

																						}

																					},
																					failure : function(
																							response,
																							options) {
																						alert("failed: "
																								+ response.responseText);

																					}
																				});

																		//												});

																	}
																});

											}

											UniAppManager.setToolbarButtons(
													'save', false);

											directMasterStore3
													.loadStoreRecords();
										}
									};
									this.syncAllDirect(config);
								} else {
									var grid = Ext.getCmp('pmr101ukrvGrid3');
									grid
											.uniSelectInvalidColumnAndAlert(inValidRecs);
								}
							},
							listeners : {
								update : function(store, record, operation,
										modifiedFieldNames, eOpts) {
									//				var records = masterGrid3.getStore().getData();
									//				Ext.each(records, function(record,i) {
									//					masterGrid3.setOutouProdtSave(record);

									//				});
								},
								load : function(store, records, successful,
										eOpts) {

									setTimeout(
											function() {
												if (gsScanYn == 'Y') {
													openResultsAddWindow();
													tab2.down('#tab2Form')
															.getField('WORK_Q')
															.focus();
													panelResult.setValue(
															'WKORD_NUM', '');
													if ((panelResult
															.getValue('WORK_SHOP_CODE') == 'WSK10' || panelResult
															.getValue('WORK_SHOP_CODE') == 'WSH10')
															&& UserInfo.divCode == '02') {//제조 작업장일 경우 칭량저울팝업 실행
														Ext.getCmp(
																'btnWeighing')
																.setDisabled(
																		false);
														weighingPop();
													}
													gsScanYn = 'N';
												}
												var sProgWorkCode = panelResult
														.getValue('S_PROG_WORK_CODE');
												Ext
														.each(
																store.data.items,
																function(
																		record,
																		index) {
																	if (record
																			.get('PROG_WORK_CODE') == sProgWorkCode) {
																		masterGrid3
																				.getSelectionModel()
																				.select(
																						index);
																	}
																})
											}, 100);

								}
							}
						});

		var directMasterStore4 = Unilite
				.createStore(
						'pmr101ukrvMasterStore4',
						{
							model : 'pmr101ukrvModel4',
							uniOpt : {
								isMaster : true, // 상위 버튼 연결
								editable : false, // 수정 모드 사용
								deletable : true, // 삭제 가능 여부
								useNavi : false
							// prev | next 버튼 사용
							},
							autoLoad : false,
							proxy : directProxy4,
							loadStoreRecords : function(record) {
								var param = masterForm.getValues();
								if (!Ext.isEmpty(record)) {
									param.WKORD_NUM = record.get('WKORD_NUM');
									param.WKORD_Q = record.get('WKORD_Q');
									param.PROG_WORK_CODE = record
											.get('PROG_WORK_CODE');
								}
								console.log(param);
								this.load({
									params : param
								});
							},
							saveStore : function(config) {
								var inValidRecs = this.getInvalidRecords();
								var toCreate = this.getNewRecords();
								var toUpdate = this.getUpdatedRecords();
								var toDelete = this.getRemovedRecords();
								var list = [].concat(toUpdate, toCreate,
										toDelete);
								console.log("inValidRecords : ", inValidRecs);
								console.log("list:", list);

								console
										.log(
												"this.data.filterBy(this.filterInvalidNewRecords).items : ",
												this.data
														.filterBy(this.filterInvalidNewRecords));

								//1. 마스터 정보 파라미터 구성
								var paramMaster = masterForm.getValues(); //syncAll 수정
								var masterGrid3Record = masterGrid3
										.getSelectedRecord();
								paramMaster.MOLD_CODE = masterGrid3Record
										.get('MOLD_CODE');
								paramMaster.CAVIT_BASE_Q = masterGrid3Record
										.get('CAVIT_BASE_Q');
								if (inValidRecs.length == 0) {
									var saveFlag = true;
									var fnCal = 0;
									var prodtSum = this.sumBy(function(record,
											id) {
										return true
									}, [ 'WORK_Q' ]);

									Ext
											.each(
													list,
													function(record, i) {
														var detailRecord = detailGrid
																.getSelectedRecord();
														var A = detailRecord
																.get('WKORD_Q'); //작업지시량
														var D = record
																.get('LINE_END_YN');

														if (D == 'Y') {
															fnCal = (prodtSum.WORK_Q / A) * 100
														} else {
															fnCal = 0;
														}
														if (fnCal > (100 * (BsaCodeInfo.glEndRate / 100))) {
															saveFlag = false;
															alert('<t:message code="system.message.product.message009" default="초과 생산 실적 범위를 벗어났습니다."/>');
															return false;
														}
														if (D == 'Y') {
															if (fnCal >= '95'/* || ((fnCal < '95') && detailRecord.get('CONTROL_STATUS') == '9')*/) {
																if (confirm('<t:message code="system.message.product.confirm004" default="완료하시겠습니까?"/>')) {
																	record
																			.set(
																					'CONTROL_STATUS',
																					'9');

																} else {
																	if (detailRecord
																			.get('CONTROL_STATUS') == '9') {
																		record
																				.set(
																						'CONTROL_STATUS',
																						'3');
																	}
																}
															} else {
																if (detailRecord
																		.get('CONTROL_STATUS') == '9') {
																	record
																			.set(
																					'CONTROL_STATUS',
																					'3');
																}
															}
														}
													});

									if (!saveFlag) {
										return false;
									}

									config = {
										params : [ paramMaster ],
										success : function(batch, option) {
											//2.마스터 정보(Server 측 처리 시 가공)
											var master = batch.operations[0]
													.getResultSet();
											var record = detailGrid
													.getSelectedRecord();
											if (!Ext
													.isEmpty(master.CONTROL_STATUS)) {
												record.set("CONTROL_STATUS",
														master.CONTROL_STATUS);
												detailGrid.getStore()
														.commitChanges();
											}
											//3.기타 처리
											masterForm.getForm().wasDirty = false;
											masterForm.resetDirtyStatus();
											console
													.log("set was dirty to false");

											//						작업실적데이터 MES연동사용시
											if (BsaCodeInfo.gsIfCode == 'Y') {

												var param = {
													"S_COMP_CODE" : UserInfo.compCode,
													"DIV_CODE" : panelResult
															.getValue('DIV_CODE'),
													"WKORD_NUM" : record
															.get('WKORD_NUM'),
													"GS_PRODT_NUM" : gsProdtNum
												};

												pmr100ukrvService
														.selectInterfaceInfo(
																param,
																function(
																		provider,
																		response) {
																	var records = response.result;
																	if (!Ext
																			.isEmpty(provider)) {
																		//								Ext.each(records, function(record,i) {
																		var sparamAcmslt = { //실적정보 포장인 경우만
																			if_seq : provider[0]['IF_SEQ_1'],
																			company_no : provider[0]['COMPANY_NO'],
																			prdctn_dt : provider[0]['PRDCTN_DT'],
																			prdctn_product_no : provider[0]['PRDCTN_PRODUCT_NO'],
																			prdctn_product_cd : provider[0]['PRDCTN_PRODUCT_CD'],
																			prdctn_product_nm : provider[0]['PRDCTN_PRODUCT_NM'],
																			plan_outtrn : provider[0]['PLAN_OUTTRN'],
																			acmslt_outtrn : provider[0]['ACMSLT_OUTTRN'],
																			unit_cd : provider[0]['UNIT_CD'],
																			progrs_kind_cd : provider[0]['PROGRS_KIND_CD'],
																			member_no : provider[0]['MEMBER_NO'],
																			acmslt_i_or_d : provider[0]['ACMSLT_I_OR_D']
																		};

																		//										console.log("연동1"+sparam.if_seq);
																		//										console.log("연동2"+sparam.prdctn_product_no);
																		//										console.log("연동3"+sparam.plan_outtrn);
																		//										console.log("연동4"+sparam.acmslt_i_or_d);

																		var sparamPlan = {//작업지시정보 성형,충전,포장 전부
																			if_seq : provider[0]['IF_SEQ_2'],
																			company_no : provider[0]['COMPANY_NO'],
																			prdctn_dt : provider[0]['PRDCTN_DT'],
																			prdctn_product_no : provider[0]['PRDCTN_PRODUCT_NO'],
																			prdctn_product_cd : provider[0]['PRDCTN_PRODUCT_CD'],
																			prdctn_product_nm : provider[0]['PRDCTN_PRODUCT_NM'],
																			plan_outtrn : provider[0]['PLAN_OUTTRN'],
																			acmslt_outtrn : provider[0]['ACMSLT_OUTTRN'],
																			unit_cd : provider[0]['UNIT_CD'],
																			erp_lot_no : provider[0]['ERP_LOT_NO'],
																			packng_qy : provider[0]['PACKNG_QTY'],
																			member_no : provider[0]['MEMBER_NO'],
																			ordr_i_or_d : 'I',
																			order_num : provider[0]['ORDER_NUM'],
																			wrkshp_ty : provider[0]['WRKSHP_TY']
																		};

																		Ext.Ajax
																				.request({
																					url : '',
																					method : 'POST',
																					params : sparamPlan,
																					cors : true,
																					useDefaultXhrHeader : false,
																					//												async	: true,
																					success : function(
																							response) {
																						if (!Ext
																								.isEmpty(response)) {
																							/*if(provider[0]['WRKSHP_TY'] == '03'){//포장일 경우

																									Ext.Ajax.request({ //작업실적 데이터 연동(실적은 포장일 경우만)
																											url	: '',
																											method:'POST',
																											params	: sparamAcmslt,
																											cors: true,
																											useDefaultXhrHeader : false,
																							//												async	: true,
																											success	: function(response){
																													if(!Ext.isEmpty(response)){
																														Unilite.messageBox('MES연동데이터  전송되었습니다.');
																													}
																											},
																											failure: function (response, options) {
																											    alert( "failed: " + response.responseText );

																											}
																									});

																							}else{

																								Unilite.messageBox('MES연동데이터  전송되었습니다.');

																							}*/
																							Unilite
																									.messageBox('MES연동데이터  전송되었습니다.');

																						}
																					},
																					failure : function(
																							response,
																							options) {
																						alert("failed: "
																								+ response.responseText);

																					}
																				});

																		//												});

																	}
																});

											} //작업실적데이터 MES연동 end
											UniAppManager.setToolbarButtons(
													'save', false);

											directMasterStore3
													.loadStoreRecords();
										}
									};
									this.syncAllDirect(config);
								} else {
									var grid = Ext.getCmp('pmr101ukrvGrid4');
									grid
											.uniSelectInvalidColumnAndAlert(inValidRecs);
								}
							},
							listeners : {
								update : function(store, record, operation,
										modifiedFieldNames, eOpts) {

								}
							}
						});

		var directMasterStore5 = Unilite
				.createStore(
						'pmr101ukrvMasterStore5',
						{
							model : 'pmr101ukrvModel5',
							uniOpt : {
								isMaster : true, // 상위 버튼 연결
								editable : true, // 수정 모드 사용
								deletable : true, // 삭제 가능 여부
								useNavi : false
							// prev | next 버튼 사용
							},
							autoLoad : false,
							proxy : directProxy5,
							loadStoreRecords : function() {
								var param = masterForm.getValues();
								var record = detailGrid.getSelectedRecord();
								if (!Ext.isEmpty(record)) {
									param.WKORD_NUM = record.get('WKORD_NUM');
									param.WKORD_Q = record.get('WKORD_Q');
									param.PROG_WORK_CODE = record
											.get('PROG_WORK_CODE');
								}
								console.log(param);
								this.load({
									params : param
								});
							},
							saveStore : function(config) {
								var inValidRecs = this.getInvalidRecords();
								var toCreate = this.getNewRecords();
								var toUpdate = this.getUpdatedRecords();
								var toDelete = this.getRemovedRecords();
								var list = [].concat(toUpdate, toCreate);
								console.log("inValidRecords : ", inValidRecs);
								console.log("list:", list);

								console
										.log(
												"this.data.filterBy(this.filterInvalidNewRecords).items : ",
												this.data
														.filterBy(this.filterInvalidNewRecords));

								//1. 마스터 정보 파라미터 구성
								var paramMaster = masterForm.getValues(); //syncAll 수정
								if (inValidRecs.length == 0) {
									config = {
										params : [ paramMaster ],
										success : function(batch, option) {
											//2.마스터 정보(Server 측 처리 시 가공)
											/*	var master = batch.operations[0].getResultSet();
												masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
											 */
											//3.기타 처리
											masterForm.getForm().wasDirty = false;
											masterForm.resetDirtyStatus();
											console
													.log("set was dirty to false");
											UniAppManager.setToolbarButtons(
													'save', false);
										}
									};
									this.syncAllDirect(config);
								} else {
									var grid = Ext.getCmp('pmr101ukrvGrid5');
									grid
											.uniSelectInvalidColumnAndAlert(inValidRecs);
								}
							},
							listeners : {
								update : function(store, record, operation,
										modifiedFieldNames, eOpts) {

								}
							}
						});

		var directMasterStore6 = Unilite
				.createStore(
						'pmr101ukrvMasterStore6',
						{
							model : 'pmr101ukrvModel6',
							uniOpt : {
								isMaster : true, // 상위 버튼 연결
								editable : true, // 수정 모드 사용
								deletable : true, // 삭제 가능 여부
								useNavi : false
							// prev | next 버튼 사용
							},
							autoLoad : false,
							proxy : directProxy6,
							loadStoreRecords : function() {
								var param = masterForm.getValues();
								var record = detailGrid.getSelectedRecord();
								if (!Ext.isEmpty(record)) {
									param.WKORD_NUM = record.get('WKORD_NUM');
									param.WKORD_Q = record.get('WKORD_Q');
									param.PROG_WORK_CODE = record
											.get('PROG_WORK_CODE');
								}
								console.log(param);
								this.load({
									params : param
								});
							},
							saveStore : function(config) {
								var inValidRecs = this.getInvalidRecords();
								var toCreate = this.getNewRecords();
								var toUpdate = this.getUpdatedRecords();
								var toDelete = this.getRemovedRecords();
								var list = [].concat(toUpdate, toCreate);
								console.log("inValidRecords : ", inValidRecs);
								console.log("list:", list);

								console
										.log(
												"this.data.filterBy(this.filterInvalidNewRecords).items : ",
												this.data
														.filterBy(this.filterInvalidNewRecords));

								//1. 마스터 정보 파라미터 구성
								var paramMaster = masterForm.getValues(); //syncAll 수정
								if (inValidRecs.length == 0) {
									config = {
										params : [ paramMaster ],
										success : function(batch, option) {
											//2.마스터 정보(Server 측 처리 시 가공)
											/*	var master = batch.operations[0].getResultSet();
												masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
											 */
											//3.기타 처리
											masterForm.getForm().wasDirty = false;
											masterForm.resetDirtyStatus();
											console
													.log("set was dirty to false");
											UniAppManager.setToolbarButtons(
													'save', false);
											directMasterStore6
													.loadStoreRecords();
										}
									};
									this.syncAllDirect(config);
								} else {
									var grid = Ext.getCmp('pmr101ukrvGrid6');
									grid
											.uniSelectInvalidColumnAndAlert(inValidRecs);
								}
							},
							listeners : {
								update : function(store, record, operation,
										modifiedFieldNames, eOpts) {

								}
							}
						});

		//20190508 제조이력등록 탭 추가
		var directMasterStore7 = Unilite
				.createStore(
						'pmr101ukrvMasterStore7',
						{
							model : 'pmr101ukrvModel7',
							proxy : directProxy7,
							uniOpt : {
								isMaster : true, // 상위 버튼 연결
								editable : true, // 수정 모드 사용
								deletable : true, // 삭제 가능 여부
								useNavi : false
							// prev | next 버튼 사용
							},
							autoLoad : false,
							loadStoreRecords : function() {
								var param = masterForm.getValues();
								var record = detailGrid.getSelectedRecord();
								var record2 = masterGrid8.getSelectedRecord();
								if (!Ext.isEmpty(record)) {
									param.WKORD_NUM = record.get('WKORD_NUM');
								}
								if (!Ext.isEmpty(record2)) {
									param.PRODT_NUM = record2.get('PRODT_NUM');
								}
								console.log(param);
								this.load({
									params : param
								});
							},
							saveStore : function(config) {
								var inValidRecs = this.getInvalidRecords();
								var toCreate = this.getNewRecords();
								var toUpdate = this.getUpdatedRecords();
								var toDelete = this.getRemovedRecords();
								var list = [].concat(toUpdate, toCreate);
								console.log("inValidRecords : ", inValidRecs);
								console.log("list:", list);

								console
										.log(
												"this.data.filterBy(this.filterInvalidNewRecords).items : ",
												this.data
														.filterBy(this.filterInvalidNewRecords));

								//1. 마스터 정보 파라미터 구성
								var paramMaster = masterForm.getValues(); //syncAll 수정
								if (inValidRecs.length == 0) {
									config = {
										params : [ paramMaster ],
										success : function(batch, option) {
											masterForm.getForm().wasDirty = false;
											masterForm.resetDirtyStatus();
											console
													.log("set was dirty to false");
											UniAppManager.setToolbarButtons(
													'save', false);
											directMasterStore7
													.loadStoreRecords();
										}
									};
									this.syncAllDirect(config);
								} else {
									var grid = Ext.getCmp('pmr101ukrvGrid7');
									grid
											.uniSelectInvalidColumnAndAlert(inValidRecs);
								}
							},
							listeners : {
								update : function(store, record, operation,
										modifiedFieldNames, eOpts) {
								}
							}
						});

		var directMasterStore8 = Unilite.createStore('pmr101ukrvMasterStore8',
				{
					//MODEL / PROXY는 공정별 등록의 것 그대로 사용해도 됨
					model : 'pmr101ukrvModel4',
					proxy : directProxy8,
					uniOpt : {
						isMaster : false, // 상위 버튼 연결
						editable : false, // 수정 모드 사용
						deletable : false, // 삭제 가능 여부
						useNavi : false
					// prev | next 버튼 사용
					},
					autoLoad : false,
					loadStoreRecords : function() {
						var param = masterForm.getValues();
						var record = detailGrid.getSelectedRecord();
						if (!Ext.isEmpty(record)) {
							param.WKORD_NUM = record.get('WKORD_NUM');
						}
						console.log(param);
						this.load({
							params : param
						});
					},
					listeners : {
						load : function(store, records, successful, eOpts) {
							if (records.length == 0) {
								directMasterStore7.loadData({});
							}
						},
						update : function(store, record, operation,
								modifiedFieldNames, eOpts) {
						}
					}
				});

		/***생산 실적 팝업의 특기사항 스토어, 모델과 프록시는 같음***/
		var directMasterStore9 = Unilite
				.createStore(
						'pmr101ukrvMasterStore9',
						{
							model : 'pmr101ukrvModel6',
							uniOpt : {
								isMaster : false, // 상위 버튼 연결
								editable : true, // 수정 모드 사용
								deletable : true, // 삭제 가능 여부
								useNavi : false
							// prev | next 버튼 사용
							},
							autoLoad : false,
							proxy : directProxy6,
							loadStoreRecords : function() {
								var param = masterForm.getValues();
								var record = detailGrid.getSelectedRecord();
								if (!Ext.isEmpty(record)) {
									param.WKORD_NUM = record.get('WKORD_NUM');
									param.WKORD_Q = record.get('WKORD_Q');
									param.PROG_WORK_CODE = record
											.get('PROG_WORK_CODE');
								}
								console.log(param);
								this.load({
									params : param
								});
							},
							saveStore : function(config) {
								var inValidRecs = this.getInvalidRecords();
								var toCreate = this.getNewRecords();
								var toUpdate = this.getUpdatedRecords();
								var toDelete = this.getRemovedRecords();
								var list = [].concat(toUpdate, toCreate);
								console.log("inValidRecords : ", inValidRecs);
								console.log("list:", list);

								console
										.log(
												"this.data.filterBy(this.filterInvalidNewRecords).items : ",
												this.data
														.filterBy(this.filterInvalidNewRecords));

								//1. 마스터 정보 파라미터 구성
								var paramMaster = masterForm.getValues(); //syncAll 수정
								if (inValidRecs.length == 0) {
									config = {
										params : [ paramMaster ],
										success : function(batch, option) {
											//2.마스터 정보(Server 측 처리 시 가공)
											/*	var master = batch.operations[0].getResultSet();
												masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
											 */
											//3.기타 처리
											masterForm.getForm().wasDirty = false;
											masterForm.resetDirtyStatus();
											console
													.log("set was dirty to false");
											UniAppManager.setToolbarButtons(
													'save', false);
											directMasterStore9
													.loadStoreRecords();
										}
									};
									this.syncAllDirect(config);
								} else {
									var grid = Ext.getCmp('pmr101ukrvGrid9');
									grid
											.uniSelectInvalidColumnAndAlert(inValidRecs);
								}
							},
							listeners : {
								update : function(store, record, operation,
										modifiedFieldNames, eOpts) {

								}
							},
							_onStoreUpdate : function(store, eOpt) {
								if (gsPopupChk == 'WKORD') {
									console
											.log("Store data updated save btn enabled !");
									this.setToolbarButtons('sub_save4', true);
								} else {
									console
											.log("Store data updated save btn enabled !");
									this.setToolbarButtons('sub_save4', true);
								}
							}, // onStoreUpdate

							_onStoreLoad : function(store, records, successful,
									eOpts) {
								console.log("onStoreLoad");
								if (records) {
									if (gsPopupChk == 'WKORD') {
										this.setToolbarButtons('sub_save4',
												false);
									} else {
										this.setToolbarButtons('sub_save11',
												false);
									}
								}
							},
							_onStoreDataChanged : function(store, eOpts) {
								console.log(
										"_onStoreDataChanged store.count() : ",
										store.count());
								if (store.count() == 0) {
									if (gsPopupChk == 'WKORD') {
										this.setToolbarButtons(
												[ 'sub_delete4' ], false);
										Ext.apply(this.uniOpt.state, {
											'btn' : {
												'sub_delete4' : false
											}
										});
									} else {
										this.setToolbarButtons(
												[ 'sub_delete11' ], false);
										Ext.apply(this.uniOpt.state, {
											'btn' : {
												'sub_delete11' : false
											}
										});
									}

								} else {
									if (this.uniOpt.deletable) {
										if (gsPopupChk == 'WKORD') {
											this.setToolbarButtons(
													[ 'sub_delete4' ], true);
											Ext.apply(this.uniOpt.state, {
												'btn' : {
													'sub_delete4' : true
												}
											});
										} else {
											this.setToolbarButtons(
													[ 'sub_delete11' ], true);
											Ext.apply(this.uniOpt.state, {
												'btn' : {
													'sub_delete11' : true
												}
											});
										}

									}
								}
								if (store.isDirty()) {
									if (gsPopupChk == 'WKORD') {
										this.setToolbarButtons([ 'sub_save4' ],
												true);
									} else {
										this.setToolbarButtons(
												[ 'sub_save11' ], true);
									}

								} else {
									if (gsPopupChk == 'WKORD') {
										this.setToolbarButtons([ 'sub_save4' ],
												false);
									} else {
										this.setToolbarButtons(
												[ 'sub_save11' ], false);
									}
								}
							},

							setToolbarButtons : function(btnName, state) {
								if (gsPopupChk == 'WKORD') {
									var toolbar = masterGrid9
											.getDockedItems('toolbar[dock="top"]');
								} else {
									var toolbar = masterGrid11
											.getDockedItems('toolbar[dock="top"]');
								}
								var obj = toolbar[0].getComponent(btnName);
								if (obj) {
									(state) ? obj.enable() : obj.disable();
								}
							}
						});

		/***생산 실적 팝업의 자재불량 스토어***/
		var directMasterStore10 = Unilite
				.createStore(
						'pmr101ukrvMasterStore10',
						{
							model : 'pmr101ukrvModel10',
							uniOpt : {
								isMaster : false, // 상위 버튼 연결
								editable : true, // 수정 모드 사용
								deletable : true, // 삭제 가능 여부
								useNavi : false
							// prev | next 버튼 사용
							},
							autoLoad : false,
							proxy : directProxy10,
							loadStoreRecords : function(badQtyArray) {
								var param = masterForm.getValues();
								var record = detailGrid.getSelectedRecord();
								if (!Ext.isEmpty(record)) {
									param.WKORD_NUM = record.get('WKORD_NUM');
									param.PROG_WORK_CODE = record
											.get('PROG_WORK_CODE');
								}
								if (!Ext.isEmpty(badQtyArray)) {
									param.badQtyArray = badQtyArray;
								}
								param.POPUP_CHK = gsPopupChk;
								param.PRODT_NUM = gsProdtNum;
								console.log(param);
								this.load({
									params : param
								});
							},
							saveStore : function(config) {
								var inValidRecs = this.getInvalidRecords();
								var toCreate = this.getNewRecords();
								var toUpdate = this.getUpdatedRecords();
								var toDelete = this.getRemovedRecords();
								var list = [].concat(toUpdate, toCreate);
								console.log("inValidRecords : ", inValidRecs);
								console.log("list:", list);

								console
										.log(
												"this.data.filterBy(this.filterInvalidNewRecords).items : ",
												this.data
														.filterBy(this.filterInvalidNewRecords));

								//1. 마스터 정보 파라미터 구성
								var paramMaster = masterForm.getValues(); //syncAll 수정
								var badQtyArray = new Array();
								badQtyArray = gsBadQtyInfo.split(',');
								if (!Ext.isEmpty(badQtyArray)) {
									paramMaster.badQtyArray = badQtyArray;
								}
								paramMaster.PRODT_NUM = gsProdtNum;
								paramMaster.PRODT_DATE = gsProdtDate1;
								if (inValidRecs.length == 0) {
									config = {
										params : [ paramMaster ],
										success : function(batch, option) {
											//2.마스터 정보(Server 측 처리 시 가공)
											/*	var master = batch.operations[0].getResultSet();
												masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
											 */
											//3.기타 처리
											masterForm.getForm().wasDirty = false;
											masterForm.resetDirtyStatus();
											console
													.log("set was dirty to false");
											UniAppManager.setToolbarButtons(
													'save', false);
											directMasterStore3
													.loadStoreRecords();
											directMasterStore10
													.loadStoreRecords(badQtyArray);
										},
										failure : function(batch, option) {
											directMasterStore3
													.loadStoreRecords();
											directMasterStore10
													.loadStoreRecords(badQtyArray);
										}
									};
									this.syncAllDirect(config);
								} else {
									if (gsPopupChk == 'WKORD') {
										var grid = Ext
												.getCmp('pmr101ukrvGrid10');
										grid
												.uniSelectInvalidColumnAndAlert(inValidRecs);
									} else {
										var grid = Ext
												.getCmp('pmr101ukrvGrid12');
										grid
												.uniSelectInvalidColumnAndAlert(inValidRecs);
									}
								}
							},
							listeners : {
								update : function(store, record, operation,
										modifiedFieldNames, eOpts) {

								}
							},
							_onStoreUpdate : function(store, eOpt) {
								if (gsPopupChk == 'RESULT') {
									console
											.log("Store data updated save btn enabled !");
									this.setToolbarButtons('sub_save12', true);
								}
							}, // onStoreUpdate

							_onStoreLoad : function(store, records, successful,
									eOpts) {
								if (gsPopupChk == 'RESULT') {
									console.log("onStoreLoad");
									if (records) {
										this.setToolbarButtons('sub_save12',
												false);
									}
								}
							},
							_onStoreDataChanged : function(store, eOpts) {
								if (gsPopupChk == 'RESULT') {
									console
											.log(
													"_onStoreDataChanged store.count() : ",
													store.count());
									if (store.count() == 0) {
										this.setToolbarButtons(
												[ 'sub_delete12' ], false);
										Ext.apply(this.uniOpt.state, {
											'btn' : {
												'sub_delete12' : false
											}
										});
									} else {
										if (this.uniOpt.deletable) {
											this.setToolbarButtons(
													[ 'sub_delete12' ], true);
											Ext.apply(this.uniOpt.state, {
												'btn' : {
													'sub_delete12' : true
												}
											});
										}
									}
									if (store.isDirty()) {
										this.setToolbarButtons(
												[ 'sub_save12' ], true);
									} else {
										this.setToolbarButtons(
												[ 'sub_save12' ], false);
									}
								}
							},

							setToolbarButtons : function(btnName, state) {
								var toolbar = masterGrid12
										.getDockedItems('toolbar[dock="top"]');
								var obj = toolbar[0].getComponent(btnName);
								if (obj) {
									(state) ? obj.enable() : obj.disable();
								}
							}
						});

		var masterGrid2 = Unilite
				.createGrid(
						'pmr101ukrvGrid2',
						{
							layout : 'fit',
							region : 'center',
							title : '<t:message code="system.label.product.workorderperentry" default="작업지시별등록"/>',
							store : directMasterStore2,
							uniOpt : {
								expandLastColumn : false,
								useRowNumberer : true,
								useMultipleSorting : false
							},
							sortableColumns : false,
							features : [ {
								id : 'masterGridSubTotal',
								ftype : 'uniGroupingsummary',
								showSummaryRow : false
							}, {
								id : 'masterGridTotal',
								ftype : 'uniSummary',
								showSummaryRow : false
							} ],
							columns : [
									{
										dataIndex : 'PRODT_DATE',
										width : 80
									},
									{
										dataIndex : 'FR_TIME',
										width : 93,
										align : 'center',
										editor : {
											xtype : 'timefield',
											format : 'H:i',
											//	submitFormat: 'Hi', //i tried with and without this config
											increment : 10
										}
									},
									{
										dataIndex : 'TO_TIME',
										width : 93,
										align : 'center',
										editor : {
											xtype : 'timefield',
											format : 'H:i',
											//	submitFormat: 'Hi', //i tried with and without this config
											increment : 10
										}
									},
									{
										dataIndex : 'PRODT_Q',
										width : 93
									},
									{
										dataIndex : 'GOOD_PRODT_Q',
										width : 93
									},
									{
										dataIndex : 'BAD_PRODT_Q',
										width : 93
									},
									{
										dataIndex : 'DAY_NIGHT',
										width : 93
									},

									{
										dataIndex : 'MAN_CNT',
										width : 80,
										hidden : false
									},
									{
										dataIndex : 'MAN_HOUR',
										width : 93
									},
									{
										dataIndex : 'LUNCH_CHK',
										width : 85,
										xtype : 'checkcolumn',
										listeners : {
											beforecheckchange : function(
													CheckColumn, rowIndex,
													checked, record, e, eOpts) {
												var grdRecord = directMasterStore2
														.getAt(rowIndex);
												if (grdRecord.phantom == false) {
													return false;
												}
											},
											checkchange : function(CheckColumn,
													rowIndex, checked, eOpts) {

												var grdRecord = directMasterStore2
														.getAt(rowIndex);

												if (checked == true) {
													var diffTime = (grdRecord
															.get('TO_TIME') - grdRecord
															.get('FR_TIME')) / 60000 / 60;

													if ((grdRecord
															.get('TO_TIME') >= panelResult
															.getValue('GS_TO_TIME'))
															&& (grdRecord
																	.get('FR_TIME') <= panelResult
																	.getValue('GS_FR_TIME'))) {
														diffTime = diffTime - 1;
														var manCnt = grdRecord
																.get('MAN_CNT');
														grdRecord
																.set(
																		'MAN_HOUR',
																		manCnt
																				* diffTime);
													}

												} else {
													var diffTime = (grdRecord
															.get('TO_TIME') - grdRecord
															.get('FR_TIME')) / 60000 / 60;

													var manCnt = grdRecord
															.get('MAN_CNT');
													if ((grdRecord
															.get('TO_TIME') >= panelResult
															.getValue('GS_TO_TIME'))
															&& (grdRecord
																	.get('FR_TIME') <= panelResult
																	.getValue('GS_FR_TIME'))) {
														grdRecord
																.set(
																		'MAN_HOUR',
																		manCnt
																				* diffTime);
													}

												}
											}
										}
									},

									{
										dataIndex : 'WKORD_Q',
										width : 100,
										hidden : true
									}, {
										dataIndex : 'PRODT_SUM',
										width : 93
									}, {
										dataIndex : 'JAN_Q',
										width : 93
									}, {
										dataIndex : 'IN_STOCK_Q',
										width : 93
									}, {
										dataIndex : 'LOT_NO',
										width : 93
									},

									//			{dataIndex: 'PJT_CODE'			, width: 93},
									{
										dataIndex : 'FR_SERIAL_NO',
										width : 120
									}, {
										dataIndex : 'TO_SERIAL_NO',
										width : 120
									}, {
										dataIndex : 'REMARK',
										width : 200
									}, {
										dataIndex : 'PROJECT_NO',
										width : 93
									}, {
										dataIndex : 'NEW_DATA',
										width : 90,
										hidden : true
									}, {
										dataIndex : 'PRODT_NUM',
										width : 90,
										hidden : true
									}, {
										dataIndex : 'PROG_WORK_CODE',
										width : 80,
										hidden : true
									}, {
										dataIndex : 'UPDATE_DB_USER',
										width : 80,
										hidden : true
									}, {
										dataIndex : 'UPDATE_DB_TIME',
										width : 80,
										hidden : true
									}, {
										dataIndex : 'COMP_CODE',
										width : 80,
										hidden : true
									}, {
										dataIndex : 'DIV_CODE',
										width : 80,
										hidden : true
									}, {
										dataIndex : 'WORK_SHOP_CODE',
										width : 80,
										hidden : true
									}, {
										dataIndex : 'ITEM_CODE',
										width : 80,
										hidden : true
									}, {
										dataIndex : 'CONTROL_STATUS',
										width : 80,
										hidden : true
									}, {
										dataIndex : 'GOOD_WH_CODE',
										width : 80,
										hidden : true
									}, {
										dataIndex : 'GOOD_WH_CELL_CODE',
										width : 80,
										hidden : true
									}, {
										dataIndex : 'GOOD_PRSN',
										width : 80,
										hidden : true
									}, {
										dataIndex : 'BAD_WH_CODE',
										width : 80,
										hidden : true
									}, {
										dataIndex : 'BAD_WH_CELL_CODE',
										width : 80,
										hidden : true
									}, {
										dataIndex : 'BAD_PRSN',
										width : 80,
										hidden : true
									},
									//20180605 추가
									{
										dataIndex : 'WKORD_NUM',
										width : 80,
										hidden : true
									} ],
							listeners : {
								beforeedit : function(editor, e, eOpts) {
									if (e.record.phantom == false) {
										if (UniUtils.indexOf(e.field)) {
											return false;
										} else {
											return false;
										}
									} else {
										if (UniUtils.indexOf(e.field, [
												'PRODT_DATE', 'PRODT_Q',
												'DAY_NIGHT', 'MAN_CNT',
												'FR_TIME', 'TO_TIME',
												'GOOD_PRODT_Q', 'BAD_PRODT_Q',
												'MAN_HOUR', 'LOT_NO', 'REMARK',
												'FR_SERIAL_NO', 'TO_SERIAL_NO',
												'PROJECT_NO' ])) {
											return true;
										} else {
											return false;
										}
									}
								},
								render : function(grid, eOpts) {
									grid
											.getEl()
											.on(
													'click',
													function(e, t, eOpt) {
														var detailRecord = detailGrid
																.getSelectedRecord();
														if (!Ext
																.isEmpty(detailRecord)) {
															if (detailRecord
																	.get('CONTROL_STATUS') == '9'
																	|| detailRecord
																			.get('CONTROL_STATUS') == '8') {
																UniAppManager
																		.setToolbarButtons(
																				[ 'newData' ],
																				false);
															} else {
																UniAppManager
																		.setToolbarButtons(
																				[ 'newData' ],
																				true);
															}
														}
													});
								},
								cellclick : function(grid, td, cellIndex,
										thisRecord, tr, rowIndex, e, eOpts) {
									if (grid.getStore().count() > 0) {
										UniAppManager.setToolbarButtons(
												[ 'delete' ], true);
									}

								},
								selectionchange : function(model1, selected,
										eOpts) {
									if (selected.length > 0) {
										var record = selected[0];
										gsProdtDate = record.get('PRODT_DATE');
									}
								}
							},
							setOutouProdtSave : function(grdRecord) {
								grdRecord.set('GOOD_WH_CODE',
										outouProdtSaveSearch
												.getValue('GOOD_WH_CODE'));
								grdRecord.set('GOOD_WH_CELL_CODE',
										outouProdtSaveSearch
												.getValue('GOOD_WH_CELL_CODE'));
								grdRecord.set('GOOD_PRSN', outouProdtSaveSearch
										.getValue('GOOD_PRSN'));
								grdRecord.set('BAD_WH_CODE',
										outouProdtSaveSearch
												.getValue('BAD_WH_CODE'));
								grdRecord.set('BAD_WH_CELL_CODE',
										outouProdtSaveSearch
												.getValue('BAD_WH_CELL_CODE'));
								grdRecord.set('BAD_PRSN', outouProdtSaveSearch.getValue('BAD_PRSN'));
		}
	});

	var masterGrid3 = Unilite.createGrid('pmr101ukrvGrid3', {
							//		split: true,
							layout : 'fit',
							region : 'center',
							flex : 4,
							//title	: '<t:message code="system.label.product.routingperentry" default="공정별등록"/>',
							store : directMasterStore3,
							sortableColumns : false,
							uniOpt : {
								userToolbar : true,
								expandLastColumn : false,
								useRowNumberer : true,
								useMultipleSorting : true,
								onLoadSelectFirst : true
							},
							features : [ {
								id : 'masterGridSubTotal',
								ftype : 'uniGroupingsummary',
								showSummaryRow : false
							}, {
								id : 'masterGridTotal',
								ftype : 'uniSummary',
								showSummaryRow : false
							} ],
							columns : [
									//{dataIndex: 'SEQ'				, width: 35},

									{
										dataIndex : 'PROG_WORK_NAME',
										width : 120
									},
									{
										dataIndex : 'PROG_UNIT',
										width : 50,
										align : 'center'
									},
									{
										dataIndex : 'PROG_WKORD_Q',
										width : 100
									},
									{
										dataIndex : 'SUM_Q',
										width : 88
									},
									{
										dataIndex : 'PRODT_DATE',
										width : 86,
										align : 'center'
									},
									{
										dataIndex : 'WORK_Q',
										width : 88
									},
									{
										dataIndex : 'GOOD_WORK_Q',
										width : 88
									},
									{
										dataIndex : 'BAD_WORK_Q',
										width : 88
									},
									{
										dataIndex : 'YIELD',
										width : 66,
										hidden : false
									},
									{
										dataIndex : 'SAVING_Q',
										width : 80,
										hidden : false
									},
									{
										dataIndex : 'LOSS_Q',
										width : 80,
										hidden : false
									},
									{
										dataIndex : 'ETC_Q',
										width : 80,
										hidden : false
									},
									{
										dataIndex : 'BOX_Q',
										width : 80,
										hidden : false
									},
									{
										dataIndex : 'BOX_TRNS_RATE',
										width : 80,
										hidden : false
									},
									{
										dataIndex : 'PIECE',
										width : 80,
										hidden : false
									},
									{
										dataIndex : 'JAN_Q',
										width : 100
									},
									{
										dataIndex : 'DAY_NIGHT',
										width : 66
									},
									{
										dataIndex : 'MAN_CNT',
										width : 80,
										hidden : false
									},
									{
										dataIndex : 'FR_TIME',
										width : 93,
										align : 'center',
										editor : {
											xtype : 'timefield',
											format : 'H:i',
											//	submitFormat: 'Hi', //i tried with and without this config
											increment : 10
										}
									},
									{
										dataIndex : 'TO_TIME',
										width : 93,
										align : 'center',
										editor : {
											xtype : 'timefield',
											format : 'H:i',
											//	submitFormat: 'Hi', //i tried with and without this config
											increment : 10
										}
									},
									{
										dataIndex : 'LUNCH_CHK',
										width : 85,
										xtype : 'checkcolumn',
										listeners : {
											checkchange : function(CheckColumn,
													rowIndex, checked, eOpts) {
												if (checked == true) {
													var grdRecord = directMasterStore3
															.getAt(rowIndex);
													var diffTime = (grdRecord
															.get('TO_TIME') - grdRecord
															.get('FR_TIME')) / 60000 / 60;

													if ((grdRecord
															.get('TO_TIME') >= panelResult
															.getValue('GS_TO_TIME'))
															&& (grdRecord
																	.get('FR_TIME') <= panelResult
																	.getValue('GS_FR_TIME'))) {
														diffTime = diffTime - 1;
														var manCnt = grdRecord
																.get('MAN_CNT');
														grdRecord
																.set(
																		'MAN_HOUR',
																		manCnt
																				* diffTime);
													}

												} else {
													var grdRecord = directMasterStore3
															.getAt(rowIndex);
													var diffTime = (grdRecord
															.get('TO_TIME') - grdRecord
															.get('FR_TIME')) / 60000 / 60;

													var manCnt = grdRecord
															.get('MAN_CNT');
													if ((grdRecord
															.get('TO_TIME') >= panelResult
															.getValue('GS_TO_TIME'))
															&& (grdRecord
																	.get('FR_TIME') <= panelResult
																	.getValue('GS_FR_TIME'))) {
														grdRecord
																.set(
																		'MAN_HOUR',
																		manCnt
																				* diffTime);
													}

												}
											}
										}
									},
									{
										dataIndex : 'MAN_HOUR',
										width : 90
									},
									{
										dataIndex : 'LOT_NO',
										width : 93
									},
									{
										dataIndex : 'FR_SERIAL_NO',
										width : 120
									},
									{
										dataIndex : 'TO_SERIAL_NO',
										width : 120
									},
									{
										dataIndex : 'EXPIRATION_DATE',
										width : 80,
										hidden : false
									},
									{
										dataIndex : 'MOLD_CODE',
										width : 80
									},
									{
										dataIndex : 'MOLD_NAME',
										width : 80
									},
									{
										dataIndex : 'HAZARD_CHECK',
										width : 100,
										xtype : 'checkcolumn',
										hidden : false
									},
									{
										dataIndex : 'MICROBE_CHECK',
										width : 100,
										xtype : 'checkcolumn',
										hidden : false
									},
									{
										dataIndex : 'REMARK',
										flex : 1,
										minWidth : 100
									},
									{
										dataIndex : 'DIV_CODE',
										width : 10,
										hidden : true
									},
									{
										dataIndex : 'PROG_WORK_CODE',
										width : 10,
										hidden : true
									},
									{
										dataIndex : 'PASS_Q',
										width : 10,
										hidden : true
									},
									{
										dataIndex : 'WKORD_NUM',
										width : 10,
										hidden : true
									},
									{
										dataIndex : 'LINE_END_YN',
										width : 10,
										hidden : true
									},
									{
										dataIndex : 'WK_PLAN_NUM',
										width : 10,
										hidden : true
									},
									{
										dataIndex : 'PRODT_NUM',
										width : 10,
										hidden : true
									},
									{
										dataIndex : 'CONTROL_STATUS',
										width : 10,
										hidden : true
									},
									{
										dataIndex : 'UPDATE_DB_USER',
										width : 10,
										hidden : true
									},
									{
										dataIndex : 'UPDATE_DB_TIME',
										width : 10,
										hidden : true
									},
									{
										dataIndex : 'COMP_CODE',
										width : 10,
										hidden : true
									},
									{
										dataIndex : 'GOOD_WH_CODE',
										width : 80,
										hidden : true
									},
									{
										dataIndex : 'GOOD_WH_CELL_CODE',
										width : 80,
										hidden : true
									},
									{
										dataIndex : 'GOOD_PRSN',
										width : 80,
										hidden : true
									},
									{
										dataIndex : 'BAD_WH_CODE',
										width : 80,
										hidden : true
									},
									{
										dataIndex : 'BAD_WH_CELL_CODE',
										width : 80,
										hidden : true
									},
									{
										dataIndex : 'BAD_PRSN',
										width : 80,
										hidden : true
									},
									{
										dataIndex : 'EQUIP_CODE',
										width : 80,
										hidden : true
									},
									{
										dataIndex : 'EQUIP_NAME',
										width : 80,
										hidden : true
									},
									{
										dataIndex : 'PRODT_PRSN',
										width : 80,
										hidden : true
									},
									{ //20200316 추가: 자재출고 등록(생산) (mtr200ukrv) 으로 이동: 20200317: 수정: 중간 그리드로 이동 / hidden: true
										text : '<t:message code="system.label.product.materialissue" default="자재출고"/>',
										xtype : 'widgetcolumn',
										width : 120,
										hidden : true,
										widget : {
											xtype : 'button',
											text : '<t:message code="system.label.product.materialissue" default="자재출고"/>',
											listeners : {
												buffer : 1,
												click : function(button, event,
														eOpts) {
													var record = event.record.data;
													var params = {
														'PGM_ID' : 'pmr101ukrv',
														COMP_CODE : UserInfo.compCode,
														DIV_CODE : panelResult
																.getValue('DIV_CODE'),
														WKORD_NUM : record.WKORD_NUM
													}
													var rec = {
														data : {
															prgID : 'mtr200ukrv',
															'text' : ''
														}
													};
													parent
															.openTab(
																	rec,
																	'/matrl/mtr200ukrv.do',
																	params);
												}
											}
										}
									} ],
							listeners : {
								beforeedit : function(editor, e, eOpts) {
									var detailRecord = detailGrid
											.getSelectedRecord();
									if (detailRecord.get('CONTROL_STATUS') == '9'
											|| detailRecord
													.get('CONTROL_STATUS') == '8') {
										//unilite상에서 두 컬럼이 수정이 되나 저장은 안됨 (투입공수나 생산량 둘 중에 하나는 0이 아니어야 하는데 둘다 수정 불가능) - 그냥 return false 처리
										//					if(UniUtils.indexOf(e.field, ['FR_SERIAL_NO', 'TO_SERIAL_NO'])) {
										//						return true;
										//					} else {
										return false;
										//					}

									} else {
										if (directMasterStore4.isDirty()) {
											alert('삭제된 실적현황 데이터가 있습니다.\n저장 후 다시 시도해주세요.');
											return false;
										}
										if (UniUtils.indexOf(e.field, [
												'PRODT_DATE', 'WORK_Q',
												'DAY_NIGHT', 'FR_TIME',
												'TO_TIME', 'GOOD_WORK_Q',
												'BAD_WORK_Q', 'MAN_HOUR',
												'FR_SERIAL_NO', 'TO_SERIAL_NO',
												'LOT_NO', 'BOX_TRNS_RATE',
												'BOX_Q', 'SAVING_Q', 'MAN_CNT',
												'HAZARD_CHECK',
												'MICROBE_CHECK', 'LOSS_Q',
												'PIECE', 'EXPIRATION_DATE',
												'ETC_Q', 'REMARK'
												//20200311 추가
												, 'PRODT_PRSN' ])) {
											return true;
										} else {
											return false;
										}
									}
								},
								render : function(grid, eOpts) {
									//				var girdNm = grid.getItemId();
									grid.getEl().on('click',
											function(e, t, eOpt) {
												//					activeGridId = girdNm;
												//UniAppManager.setToolbarButtons(['newData', 'delete'], false);
											});
								},
								select : function(grid, selectRecord, index,
										rowIndex, eOpts) {
								},
								selectionchange : function(model1, selected,
										eOpts) {
									if (selected.length > 0) {
										var record = selected[0];
										directMasterStore4.loadData({})
										directMasterStore4
												.loadStoreRecords(record);
									}
								},
								onGridDblClick : function(grid, record,
										cellIndex, colName) {
									var detailRecord = detailGrid
											.getSelectedRecord();
									if (detailRecord.get('CONTROL_STATUS') == '9'
											|| detailRecord
													.get('CONTROL_STATUS') == '8') {
										return false;
									} else {
										//if(colName =="PROG_WORK_NAME") {
										openResultsAddWindow();
										tab2.down('#tab2Form').getField(
												'WORK_Q').focus();
										//resultsAddForm.getField('PASS_Q').setStyle('color','#FFFFA1');
										//}
									}
								}
							},
							setOutouProdtSave : function(grdRecord) {
								grdRecord.set('GOOD_WH_CODE',
										outouProdtSaveSearch
												.getValue('GOOD_WH_CODE'));
								grdRecord.set('GOOD_WH_CELL_CODE',
										outouProdtSaveSearch
												.getValue('GOOD_WH_CELL_CODE'));
								grdRecord.set('GOOD_PRSN', outouProdtSaveSearch
										.getValue('GOOD_PRSN'));
								grdRecord.set('BAD_WH_CODE',
										outouProdtSaveSearch
												.getValue('BAD_WH_CODE'));
								grdRecord.set('BAD_WH_CELL_CODE',
										outouProdtSaveSearch
												.getValue('BAD_WH_CELL_CODE'));
								grdRecord.set('BAD_PRSN', outouProdtSaveSearch
										.getValue('BAD_PRSN'));
							}
						});

		var masterGrid4 = Unilite
				.createGrid(
						'pmr101ukrvGrid4',
						{
							split : true,
							layout : 'fit',
							selModel : 'rowmodel',
							region : 'south',
							flex : 1.5,
							title : '<t:message code="system.label.product.resultsstatus" default="실적현황"/>',
							store : directMasterStore4,
							uniOpt : {
								userToolbar : false,
								expandLastColumn : false,
								useRowNumberer : true,
								useMultipleSorting : true
							},
							sortableColumns : false,
							features : [ {
								id : 'masterGridSubTotal',
								ftype : 'uniGroupingsummary',
								showSummaryRow : false
							}, {
								id : 'masterGridTotal',
								ftype : 'uniSummary',
								showSummaryRow : true
							} ],
							columns : [
									{
										dataIndex : 'PRODT_NUM',
										width : 100,
										hidden : true
									},
									{
										dataIndex : 'PRODT_DATE',
										width : 100,
										summaryRenderer : function(value,
												summaryData, dataIndex,
												metaData) {
											return Unilite
													.renderSummaryRow(
															summaryData,
															metaData,
															'<t:message code="system.label.inventory.subtotal" default="소계"/>',
															'<t:message code="system.label.inventory.total" default="총계"/>');
										}
									},
									//20190508 위치 변경 (FR_TIME, TO_TIME)
									{
										dataIndex : 'FR_TIME',
										width : 70,
										hidden  : true ,
										align : 'center'
									},
									{
										dataIndex : 'TO_TIME',
										width : 70,
										hidden  : true ,
										align : 'center'
									},
									{
										dataIndex : 'WORK_Q',
										width : 88,
										summaryType : 'sum'
									},
									{
										dataIndex : 'GOOD_WORK_Q',
										width : 88,
										summaryType : 'sum',
										tdCls : 'x-change-cell2'
									},
									{
										dataIndex : 'BAD_WORK_Q',
										width : 110,
										summaryType : 'sum'
									},

									{
										dataIndex : 'DAY_NIGHT',
										width : 88,
										align : 'center'
									},
									{
										dataIndex : 'MAN_CNT',
										width : 120
									},
									{
										dataIndex : 'MAN_HOUR',
										width : 120,
										summaryType : 'sum'
									},
									{
										dataIndex : 'PRODT_PRSN',
										width : 120,
										align : 'center'
									},
									//20190508 위치 변경 (FR_TIME, TO_TIME)
									//			{dataIndex: 'FR_TIME'			, width: 100	, align:'center'},
									//			{dataIndex: 'TO_TIME'			, width: 100	, align:'center'},
									{
										dataIndex : 'EQUIP_CODE',
										hidden  : true ,
										width : 110
									},
									{
										dataIndex : 'EQUIP_NAME',
										hidden  : true ,
										width : 150
									},
									{
										dataIndex : 'IN_STOCK_Q',
										width : 88,
										summaryType : 'sum'
									},
									//20190508 LOT_NO 컬럼 보이도록 수정
									{
										dataIndex : 'LOT_NO',
										width : 80,
										hidden  : true
									},
									{
										text : '<t:message code="system.label.product.print" default="출력"/>',
										xtype : 'widgetcolumn',
										width : 200,
										widget : {
											xtype : 'button',
											text : '검사의뢰서 출력',
											listeners : {
												buffer : 1,
												click : function(button, event,
														eOpts) {
													var gsSelRecord = event.record.data;
													masterGrid4
															.printBtn(gsSelRecord);
												}
											}
										}
									},
									{
										text : '<t:message code="system.label.product.label" default="라벨"/>',
										xtype : 'widgetcolumn',
										width : 120,
										widget : {
											xtype : 'button',
											text : '<t:message code="system.label.product.labelprint" default="라벨출력"/>',
											listeners : {
												buffer : 1,
												click : function(button, event,
														eOpts) {
													if (BsaCodeInfo.gsSiteCode == 'SHIN') {
														gsSelRecord2 = event.record.data;
														gsLabelChk = "PMR";
														openLabelPrintWindow();
													} else {
														var gsSelRecord = event.record.data;
														masterGrid4.printLabelBtn(gsSelRecord);
													}
												}
											}
										}
									} ],
							listeners : {
								beforeedit : function(editor, e, eOpts) {
								},
								render : function(grid, eOpts) {
									//				var girdNm = grid.getItemId();
									grid
											.getEl()
											.on(
													'click',
													function(e, t, eOpt) {
														//					activeGridId = girdNm;
														UniAppManager
																.setToolbarButtons(
																		[ 'newData' ],
																		false);
														if (grid.getStore()
																.count() > 0) {
															UniAppManager
																	.setToolbarButtons(
																			[ 'delete' ],
																			true);
														}
													});
								},
								selectionchange : function(model1, selected,
										eOpts) {
									if (selected.length > 0) {
										var record = selected[0];
										gsProdtDate = record.get('PRODT_DATE');
									}
								},
								onGridDblClick : function(grid, record,
										cellIndex, colName) {
									var detailRecord = detailGrid
											.getSelectedRecord();
									openResultsUpdateWindow();
								}
							},
							setOutouProdtSave : function(grdRecord) {
								grdRecord.set('GOOD_WH_CODE',
										outouProdtSaveSearch
												.getValue('GOOD_WH_CODE'));
								grdRecord.set('GOOD_WH_CELL_CODE',
										outouProdtSaveSearch
												.getValue('GOOD_WH_CELL_CODE'));
								grdRecord.set('GOOD_PRSN', outouProdtSaveSearch
										.getValue('GOOD_PRSN'));
								grdRecord.set('BAD_WH_CODE',
										outouProdtSaveSearch
												.getValue('BAD_WH_CODE'));
								grdRecord.set('BAD_WH_CELL_CODE',
										outouProdtSaveSearch
												.getValue('BAD_WH_CELL_CODE'));
								grdRecord.set('BAD_PRSN', outouProdtSaveSearch
										.getValue('BAD_PRSN'));
							},
							printBtn : function(gsSelRecord) {

								var selectedDetailRecords = detailGrid
										.getSelectedRecords();
								/*               if(Ext.isEmpty(selectedRecords)){
								 alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
								 return;
								 } */
								//              var param = panelResult.getValues();
								var param = {};
								param["DIV_CODE"] = panelResult
										.getValue('DIV_CODE')
								param["PRODT_NUM"] = gsSelRecord.PRODT_NUM;

								Ext.each(selectedDetailRecords, function(
										record, idx) {
									param["WKORD_NUM"] = record
											.get('WKORD_NUM');
									param["STD_ITEM_ACCOUNT"] = record
											.get('STD_ITEM_ACCOUNT');
									param["ITEM_LEVEL1"] = record
											.get('ITEM_LEVEL1');
									param["ITEM_CODE"] = record
											.get('ITEM_CODE');
								});

								param["sTxtValue2_fileTitle"] = '검사성적서';
								param["RPT_ID"] = 'pmr100clrkrv';
								param["PGM_ID"] = 'pmr101ukrv';
								param["MAIN_CODE"] = 'P010';

								var win = Ext.create('widget.ClipReport', {
									url : CPATH + '/prodt/pmr100clrkrv.do',
									prgID : 'pmr101ukrv',
									extParam : param
								});
								win.center();
								win.show();
							},
							printLabelBtn : function(gsSelRecord) {

								var selectedDetailRecords = detailGrid
										.getSelectedRecords();
								/*               if(Ext.isEmpty(selectedRecords)){
								 alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
								 return;
								 } */
								//              var param = panelResult.getValues();


								var param = {};
								param["DIV_CODE"] = panelResult
										.getValue('DIV_CODE')
								param["PRODT_NUM"] = gsSelRecord.PRODT_NUM ;
								param["PRINT_CNT"] = gsSelRecord.PRINT_CNT;
								param["GUBUN"] = 'STANDARD';

								Ext.each(selectedDetailRecords, function(
										record, idx) {
									param["WKORD_NUM"] = record
											.get('WKORD_NUM');
									param["STD_ITEM_ACCOUNT"] = record
											.get('STD_ITEM_ACCOUNT');
									param["PROG_WORK_GUBUN"] = record
											.get('PROG_WORK_GUBUN');
									param["ITEM_LEVEL1"] = record
											.get('ITEM_LEVEL1');
									param["ITEM_CODE"] = record
											.get('ITEM_CODE');
								});

								param["sTxtValue2_fileTitle"] = '라벨 출력';
								param["RPT_ID"] = 'pmr100clrkrv_3';
								param["PGM_ID"] = 'pmr100ukrv';
								param["MAIN_CODE"] = 'P010';

								var win = Ext.create('widget.ClipReport', {
									url : CPATH
											+ '/prodt/pmr100clrkrv_label.do',
									prgID : 'pmr101ukrv',
									extParam : param
								});
								win.center();
								win.show();
							}
						});

		var masterGrid5 = Unilite
				.createGrid(
						'pmr101ukrvGrid5',
						{
							layout : 'fit',
							region : 'center',
							title : '<t:message code="system.label.product.defectdetailsentry" default="불량내역등록"/>',
							store : directMasterStore5,
							uniOpt : {
								expandLastColumn : false,
								useRowNumberer : true,
								useMultipleSorting : true
							},
							sortableColumns : false,
							features : [ {
								id : 'masterGridSubTotal',
								ftype : 'uniGroupingsummary',
								showSummaryRow : false
							}, {
								id : 'masterGridTotal',
								ftype : 'uniSummary',
								showSummaryRow : false
							} ],
							columns : [
									{
										dataIndex : 'WKORD_NUM',
										width : 120
									},
									{
										dataIndex : 'PROG_WORK_CODE',
										width : 166,
										listeners : {
											render : function(elm) {
												var tGrid = elm.getView().ownerGrid;
												var pmp100tComboStore;
												elm.editor
														.on(
																'beforequery',
																function(
																		queryPlan,
																		eOpts) {
																	pmp100tComboStore = queryPlan.combo.store;
																	// var grdRecord = detailGrid.uniOpt.currentRecord;
																	// progWordComboStore.loadStoreRecords(grdRecord);
																	/*   store.clearFilter();
																	  store.filterBy(function(item){
																	      return item.get('option') == panelResult.getValue('DIV_CODE') && item.get('refCode1') == grdRecord.get('WKORD_NUM');
																	  }); */
																})
											}
										}
									/* ,
													'editor': Unilite.popup('PROG_WORK_CODE_G',{
														textFieldName : 'PROG_WORK_NAME',
														DBtextFieldName : 'PROG_WORK_NAME',
														autoPopup: true,
														listeners: { 'onSelected': {
															fn: function(records, type  ){
																var grdRecord = masterGrid5.uniOpt.currentRecord;
																grdRecord.set('PROG_WORK_CODE',records[0]['PROG_WORK_CODE']);
																grdRecord.set('PROG_WORK_NAME',records[0]['PROG_WORK_NAME']);
															},
															scope: this
														  },
														  'onClear' : function(type)	{
																var grdRecord = masterGrid5.uniOpt.currentRecord;
																grdRecord.set('PROG_WORK_CODE','');
																grdRecord.set('PROG_WORK_NAME','');
														  },
														  applyextparam: function(popup){
																var param =  panelResult.getValues();
																record = detailGrid.getSelectedRecord();
																popup.setExtParam({'DIV_CODE': param.DIV_CODE});
																popup.setExtParam({'ITEM_CODE': record.get('ITEM_CODE')});
																popup.setExtParam({'WORK_SHOP_CODE': record.get('WORK_SHOP_CODE')});
														  }
														}
													}) */}, {
										dataIndex : 'PRODT_DATE',
										width : 100
									}, {
										dataIndex : 'BAD_CODE',
										width : 106
									}, {
										dataIndex : 'BAD_Q',
										width : 100
									}, {
										dataIndex : 'REMARK',
										width : 800
									},

									{
										dataIndex : 'DIV_CODE',
										width : 0,
										hidden : true
									}, {
										dataIndex : 'WORK_SHOP_CODE',
										width : 0,
										hidden : true
									},
									//{dataIndex: 'PROG_WORK_CODE' 	, width: 0 , hidden: true},
									{
										dataIndex : 'ITEM_CODE',
										width : 0,
										hidden : true
									}, {
										dataIndex : 'UPDATE_DB_USER',
										width : 0,
										hidden : true
									}, {
										dataIndex : 'UPDATE_DB_TIME',
										width : 0,
										hidden : true
									}, {
										dataIndex : 'COMP_CODE',
										width : 0,
										hidden : true
									} ],
							listeners : {
								beforeedit : function(editor, e, eOpts) {
									if (!e.record.phantom) {
										if (UniUtils.indexOf(e.field, [
												'PROG_WORK_CODE',
												'PROG_WORK_NAME', 'PRODT_DATE',
												'BAD_CODE' ]))
											return false
									}
									if (!e.record.phantom || e.record.phantom) {
										if (UniUtils.indexOf(e.field,
												[ 'WKORD_NUM' ]))
											return false
									}
								},
								render : function(grid, eOpts) {
									grid
											.getEl()
											.on(
													'click',
													function(e, t, eOpt) {
														UniAppManager
																.setToolbarButtons(
																		[ 'newData' ],
																		true);
														if (grid.getStore()
																.count() > 0) {
															UniAppManager
																	.setToolbarButtons(
																			[ 'delete' ],
																			true);
														} else {
															UniAppManager
																	.setToolbarButtons(
																			[ 'delete' ],
																			false);
														}
													});
								}
							}
						});

		var masterGrid6 = Unilite
				.createGrid(
						'pmr101ukrvGrid6',
						{
							layout : 'fit',
							region : 'center',
							title : '<t:message code="system.label.product.specialremarkentry" default="특기사항등록"/>',
							store : directMasterStore6,
							uniOpt : {
								expandLastColumn : false,
								useRowNumberer : true,
								useMultipleSorting : true
							},
							sortableColumns : false,
							features : [ {
								id : 'masterGridSubTotal',
								ftype : 'uniGroupingsummary',
								showSummaryRow : false
							}, {
								id : 'masterGridTotal',
								ftype : 'uniSummary',
								showSummaryRow : false
							} ],
							columns : [
									{
										dataIndex : 'WKORD_NUM',
										width : 120,
										hidden : true
									},
									{
										dataIndex : 'PROG_WORK_CODE',
										width : 166,
										listeners : {
											render : function(elm) {
												var tGrid = elm.getView().ownerGrid;
												elm.editor
														.on(
																'beforequery',
																function(
																		queryPlan,
																		eOpts) {
																	var store = queryPlan.combo.store;
																	// var grdRecord = detailGrid.uniOpt.currentRecord;
																	// progWordComboStore.loadStoreRecords(grdRecord);
																	/*   store.clearFilter();
																	 store.filterBy(function(item){
																		 return item.get('option') == panelResult.getValue('DIV_CODE') && item.get('refCode1') == grdRecord.get('WKORD_NUM');
																	 }); */
																});
											}
										}
									/*  ,
														'editor': Unilite.popup('PROG_WORK_CODE_G',{
														textFieldName : 'PROG_WORK_NAME',
														DBtextFieldName : 'PROG_WORK_NAME',
														autoPopup: true,
														listeners: { 'onSelected': {
															fn: function(records, type  ){
																var grdRecord = masterGrid6.uniOpt.currentRecord;
																grdRecord.set('PROG_WORK_CODE',records[0]['PROG_WORK_CODE']);
																grdRecord.set('PROG_WORK_NAME',records[0]['PROG_WORK_NAME']);
															},
															scope: this
														  },
														  'onClear' : function(type)	{
																var grdRecord = masterGrid6.uniOpt.currentRecord;
																grdRecord.set('PROG_WORK_CODE','');
																grdRecord.set('PROG_WORK_NAME','');
														  },
														  applyextparam: function(popup){
																var param =  panelResult.getValues();
																record = detailGrid.getSelectedRecord();
																popup.setExtParam({'DIV_CODE': param.DIV_CODE});
																popup.setExtParam({'ITEM_CODE': record.get('ITEM_CODE')});
																popup.setExtParam({'WORK_SHOP_CODE': record.get('WORK_SHOP_CODE')});
														  }
														}
													}) */}, {
										dataIndex : 'PRODT_DATE',
										width : 100
									}, {
										dataIndex : 'CTL_CD1',
										width : 160
									}, {
										dataIndex : 'FR_TIME',
										width : 93,
										align : 'center',
										editor : {
											xtype : 'timefield',
											format : 'H:i',
											//	submitFormat: 'Hi', //i tried with and without this config
											increment : 10
										}
									}, {
										dataIndex : 'TO_TIME',
										width : 93,
										align : 'center',
										editor : {
											xtype : 'timefield',
											format : 'H:i',
											//	submitFormat: 'Hi', //i tried with and without this config
											increment : 10
										}
									}, {
										dataIndex : 'TROUBLE_TIME',
										width : 100,
										align : 'center'
									}, {
										dataIndex : 'TROUBLE',
										width : 166
									}, {
										dataIndex : 'TROUBLE_CS',
										width : 166
									}, {
										dataIndex : 'ANSWER',
										width : 800
									}, {
										dataIndex : 'SEQ',
										width : 100,
										hidden : true
									},
									//Hidden : true
									{
										dataIndex : 'DIV_CODE',
										width : 0,
										hidden : true
									}, {
										dataIndex : 'WORK_SHOP_CODE',
										width : 0,
										hidden : true
									},
									//{dataIndex: 'PROG_WORK_CODE'		, width: 0 , hidden:true},
									{
										dataIndex : 'UPDATE_DB_USER',
										width : 0,
										hidden : true
									}, {
										dataIndex : 'UPDATE_DB_TIME',
										width : 0,
										hidden : true
									}, {
										dataIndex : 'COMP_CODE',
										width : 0,
										hidden : true
									} ],
							listeners : {
								beforeedit : function(editor, e, eOpts) {
									if (!e.record.phantom) {
										if (UniUtils.indexOf(e.field, [
												'PROG_WORK_CODE',
												'PROG_WORK_NAME', 'PRODT_DATE',
												'CTL_CD1' ]))
											return false
									}
									if (!e.record.phantom || e.record.phantom) {
										if (UniUtils.indexOf(e.field,
												[ 'WKORD_NUM' ]))
											return false
									}
								},
								render : function(grid, eOpts) {
									grid
											.getEl()
											.on(
													'click',
													function(e, t, eOpt) {
														UniAppManager
																.setToolbarButtons(
																		[ 'newData' ],
																		true);
														if (grid.getStore()
																.count() > 0) {
															UniAppManager
																	.setToolbarButtons(
																			[ 'delete' ],
																			true);
														} else {
															UniAppManager
																	.setToolbarButtons(
																			[ 'delete' ],
																			false);
														}
													});
								}
							}
						});

		var masterGrid7 = Unilite.createGrid('pmr101ukrvGrid7',
				{
					title : '제조이력등록',
					store : directMasterStore7,
					split : true,
					layout : 'fit',
					region : 'center',
					flex : 5,
					uniOpt : {
						userToolbar : false,
						expandLastColumn : true,
						useRowNumberer : true,
						useMultipleSorting : true
					},
					sortableColumns : false,
					features : [ {
						id : 'masterGridSubTotal',
						ftype : 'uniGroupingsummary',
						showSummaryRow : false
					}, {
						id : 'masterGridTotal',
						ftype : 'uniSummary',
						showSummaryRow : false
					} ],
					columns : [ {
						dataIndex : 'COMP_CODE',
						width : 10,
						hidden : true
					}, {
						dataIndex : 'DIV_CODE',
						width : 10,
						hidden : true
					}, {
						dataIndex : 'WORK_SHOP_CODE',
						width : 10,
						hidden : true
					}, {
						dataIndex : 'PRODT_NUM',
						width : 10,
						hidden : true
					}, {
						dataIndex : 'PRODT_DATE',
						width : 10,
						hidden : true
					}, {
						dataIndex : 'WKORD_NUM',
						width : 10,
						hidden : true
					}, {
						dataIndex : 'SEQ',
						width : 70,
						hidden : true
					}, {
						dataIndex : 'ITEM_CODE',
						width : 110
					}, {
						dataIndex : 'ITEM_NAME',
						width : 200
					}, {
						dataIndex : 'SPEC',
						width : 130
					}, {
						dataIndex : 'STOCK_UNIT',
						width : 60,
						align : 'center'
					}, {
						dataIndex : 'UNIT_Q',
						width : 100
					}, {
						dataIndex : 'ALLOCK_Q',
						width : 100
					}, {
						dataIndex : 'MODIFY_RATE',
						width : 100,
						align : 'center'
					}, {
						dataIndex : 'REMARK',
						width : 150
					} ],
					listeners : {
						beforeedit : function(editor, e, eOpts) {
							if (UniUtils.indexOf(e.field, [ 'MODIFY_RATE',
									'REMARK' ])) {
								return true;
							} else {
								return false;
							}
						},
						render : function(grid, eOpts) {
							grid.getEl().on(
									'click',
									function(e, t, eOpt) {
										UniAppManager.setToolbarButtons(
												[ 'newData' ], false);
										if (grid.getStore().count() > 0) {
											UniAppManager.setToolbarButtons(
													[ 'delete' ], true);
										} else {
											UniAppManager.setToolbarButtons(
													[ 'delete' ], false);
										}
									});
						}
					}
				});

		var masterGrid8 = Unilite
				.createGrid(
						'pmr101ukrvGrid8',
						{
							title : '<t:message code="system.label.product.resultsstatus" default="실적현황"/>',
							store : directMasterStore8,
							split : true,
							layout : 'fit',
							selModel : 'rowmodel',
							region : 'center',
							flex : 4,
							uniOpt : {
								userToolbar : false,
								expandLastColumn : true,
								useRowNumberer : true,
								useMultipleSorting : true
							},
							sortableColumns : false,
							features : [ {
								id : 'masterGridSubTotal',
								ftype : 'uniGroupingsummary',
								showSummaryRow : false
							}, {
								id : 'masterGridTotal',
								ftype : 'uniSummary',
								showSummaryRow : false
							} ],
							columns : [ {
								dataIndex : 'PRODT_NUM',
								width : 120,
								hidden : false
							}, {
								dataIndex : 'PRODT_DATE',
								width : 80
							}, {
								dataIndex : 'FR_TIME',
								width : 100,
								align : 'center'
							}, {
								dataIndex : 'TO_TIME',
								width : 100,
								align : 'center'
							}, {
								dataIndex : 'WORK_Q',
								width : 66,
								summaryType : 'sum'
							}, {
								dataIndex : 'GOOD_WORK_Q',
								width : 66,
								summaryType : 'sum'
							}, {
								dataIndex : 'SAVING_Q',
								width : 80,
								hidden : false
							}, {
								dataIndex : 'BAD_WORK_Q',
								width : 66,
								summaryType : 'sum'
							}, {
								dataIndex : 'DAY_NIGHT',
								width : 66
							}, {
								dataIndex : 'MAN_HOUR',
								width : 76,
								summaryType : 'sum'
							}, {
								dataIndex : 'IN_STOCK_Q',
								width : 76,
								summaryType : 'sum'
							}, {
								dataIndex : 'LOT_NO',
								width : 80,
								hidden : false
							}, {
								dataIndex : 'FR_SERIAL_NO',
								width : 120,
								hidden : true
							}, {
								dataIndex : 'TO_SERIAL_NO',
								width : 120,
								hidden : true
							}, {
								dataIndex : 'REMARK',
								width : 80,
								hidden : true
							},

							{
								dataIndex : 'DIV_CODE',
								width : 66,
								hidden : true
							}, {
								dataIndex : 'PROG_WKORD_Q',
								width : 66,
								hidden : true
							}, {
								dataIndex : 'PASS_Q',
								width : 66,
								hidden : true
							}, {
								dataIndex : 'PROG_WORK_CODE',
								width : 66,
								hidden : true
							}, {
								dataIndex : 'WKORD_NUM',
								width : 66,
								hidden : true
							}, {
								dataIndex : 'WK_PLAN_NUM',
								width : 80,
								hidden : true
							}, {
								dataIndex : 'LINE_END_YN',
								width : 106,
								hidden : true
							}, {
								dataIndex : 'COMP_CODE',
								width : 106,
								hidden : true
							}, {
								dataIndex : 'GOOD_WH_CODE',
								width : 80,
								hidden : true
							}, {
								dataIndex : 'GOOD_PRSN',
								width : 80,
								hidden : true
							}, {
								dataIndex : 'BAD_WH_CODE',
								width : 80,
								hidden : true
							}, {
								dataIndex : 'BAD_PRSN',
								width : 80,
								hidden : true
							}, {
								dataIndex : 'EXPIRATION_DATE',
								width : 80,
								hidden : false
							}, {
								dataIndex : 'BOX_TRNS_RATE',
								width : 80,
								hidden : false
							}, {
								dataIndex : 'BOX_Q',
								width : 80,
								hidden : false
							}
							//			{dataIndex: 'HAZARD_CHECK'		, width: 100	, xtype: 'checkcolumn'	, hidden: false },
							//			{dataIndex: 'MICROBE_CHECK'		, width: 100	, xtype: 'checkcolumn'	, hidden: false}
							],
							listeners : {
								beforeedit : function(editor, e, eOpts) {
								},
								render : function(grid, eOpts) {
									//				var girdNm = grid.getItemId();
									grid
											.getEl()
											.on(
													'click',
													function(e, t, eOpt) {
														//					activeGridId = girdNm;
														UniAppManager
																.setToolbarButtons(
																		[ 'newData' ],
																		false);
														if (grid.getStore()
																.count() > 0) {
															UniAppManager
																	.setToolbarButtons(
																			[ 'delete' ],
																			true);
														}
													});
								},
								selectionchange : function(model1, selected,
										eOpts) {
									if (selected.length > 0) {
										var record = selected[0];
										directMasterStore7.loadData({})
										directMasterStore7
												.loadStoreRecords(record);
									}
								}
							}
						});

		var masterGrid9 = Unilite
				.createGrid(
						'pmr101ukrvGrid9',
						{
							layout : 'fit',
							region : 'center',
							width : 960,
							border : false,
							title : '',
							store : directMasterStore9,
							uniOpt : {
								expandLastColumn : false,
								useRowNumberer : false,
								useMultipleSorting : true
							},
							sortableColumns : false,
							features : [ {
								id : 'masterGridSubTotal',
								ftype : 'uniGroupingsummary',
								showSummaryRow : false
							}, {
								id : 'masterGridTotal',
								ftype : 'uniSummary',
								showSummaryRow : false
							} ],
							dockedItems : [ {
								xtype : 'toolbar',
								dock : 'top',
								items : [
										{
											xtype : 'uniBaseButton',
											text : '<t:message code="system.label.base.inquiry" default="조회"/>',
											tooltip : '<t:message code="system.label.base.inquiry" default="조회"/>',
											iconCls : 'icon-query',
											width : 26,
											height : 26,
											itemId : 'sub_query4',
											handler : function() {
												//if( me._needSave()) {
												var toolbar = masterGrid9
														.getDockedItems('toolbar[dock="top"]');
												var needSave = !toolbar[0]
														.getComponent(
																'sub_save4')
														.isDisabled();
												var record = detailGrid
														.getSelectedRecord();
												if (needSave) {
													Ext.Msg
															.show({
																title : '<t:message code="system.label.base.confirm" default="확인"/>',
																msg : Msg.sMB017
																		+ "\n"
																		+ Msg.sMB061,
																buttons : Ext.Msg.YESNOCANCEL,
																icon : Ext.Msg.QUESTION,
																fn : function(
																		res) {
																	//console.log(res);
																	if (res === 'yes') {
																		var saveTask = Ext
																				.create(
																						'Ext.util.DelayedTask',
																						function() {
																							directMasterStore9
																									.saveStore();
																						});
																		saveTask
																				.delay(500);
																	} else if (res === 'no') {
																		directMasterStore9
																				.loadStoreRecords();
																	}
																}
															});
												} else {
													directMasterStore9
															.loadStoreRecords(record
																	.get('ITEM_CODE'));
												}
											}
										},
										{
											xtype : 'uniBaseButton',
											text : '<t:message code="system.label.base.reset" default="신규"/>',
											tooltip : '<t:message code="system.label.base.reset2" default="초기화"/>',
											iconCls : 'icon-reset',
											width : 26,
											height : 26,
											itemId : 'sub_reset4',
											handler : function() {
												var toolbar = masterGrid9
														.getDockedItems('toolbar[dock="top"]');
												var needSave = !toolbar[0]
														.getComponent(
																'sub_save4')
														.isDisabled();
												if (needSave) {
													Ext.Msg
															.show({
																title : '<t:message code="system.label.base.confirm" default="확인"/>',
																msg : Msg.sMB017
																		+ "\n"
																		+ Msg.sMB061,
																buttons : Ext.Msg.YESNOCANCEL,
																icon : Ext.Msg.QUESTION,
																fn : function(
																		res) {
																	console
																			.log(res);
																	if (res === 'yes') {
																		var saveTask = Ext
																				.create(
																						'Ext.util.DelayedTask',
																						function() {
																							directMasterStore9
																									.saveStore();
																						});
																		saveTask
																				.delay(500);
																	} else if (res === 'no') {
																		masterGrid9
																				.reset();
																		directMasterStore9
																				.clearData();
																		directMasterStore9
																				.setToolbarButtons(
																						'sub_save4',
																						false);
																		directMasterStore9
																				.setToolbarButtons(
																						'sub_delete4',
																						false);
																	}
																}
															});
												} else {
													masterGrid9.reset();
													directMasterStore9
															.clearData();
													directMasterStore9
															.setToolbarButtons(
																	'sub_save4',
																	false);
													directMasterStore9
															.setToolbarButtons(
																	'sub_delete4',
																	false);
												}
											}
										},
										{
											xtype : 'uniBaseButton',
											text : '<t:message code="system.label.base.add" default="추가"/>',
											tooltip : '<t:message code="system.label.base.add" default="추가"/>',
											iconCls : 'icon-new',
											width : 26,
											height : 26,
											itemId : 'sub_newData4',
											handler : function() {
												var record = detailGrid
														.getSelectedRecord();
												var progWorkRecord = masterGrid3
														.getSelectedRecord();
												var divCode = masterForm
														.getValue('DIV_CODE');
												var prodtDate = UniDate
														.get('today');
												var workShopcode = record
														.get('WORK_SHOP_CODE');
												var wkordNum = record
														.get('WKORD_NUM');
												var itemCode = record
														.get('ITEM_CODE');
												var ctlCd1 = '';
												var troubleTime = '';
												var trouble = '';
												var troubleCs = '';
												var answer = '';
												var seq = 0;
												seq = directMasterStore9
														.max('SEQ');

												if (Ext.isEmpty(seq)) {
													seq = 1;
												} else {
													seq = seq + 1;
												}
												var r = {
													DIV_CODE : divCode,
													PRODT_DATE : prodtDate,
													WORK_SHOP_CODE : workShopcode,
													WKORD_NUM : wkordNum,
													ITEM_CODE : itemCode,
													CTL_CD1 : ctlCd1,
													TROUBLE_TIME : troubleTime,
													TROUBLE : trouble,
													TROUBLE_CS : troubleCs,
													ANSWER : answer,
													//FR_TIME					:'2008-01-01 08:30:00',
													//TO_TIME				:'2008-01-01 17:30:00',
													PROG_WORK_CODE : progWorkRecord
															.get('PROG_WORK_CODE'),
													SEQ : seq
												//COMP_CODE				:compCode
												};
												masterGrid9.createRow(r);
											}
										},
										{
											xtype : 'uniBaseButton',
											text : '<t:message code="system.label.base.delete" default="삭제"/>',
											tooltip : '<t:message code="system.label.base.delete" default="삭제"/>',
											iconCls : 'icon-delete',
											disabled : true,
											width : 26,
											height : 26,
											itemId : 'sub_delete4',
											handler : function() {
												var selRow = masterGrid9
														.getSelectedRecord();
												if (!Ext.isEmpty(selRow)) {
													if (selRow.phantom == true) {
														masterGrid9
																.deleteSelectedRow();
													} else if (confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
														masterGrid9
																.deleteSelectedRow();
													}
												} else {
													alert(Msg.sMA0256);
													return false;
												}
											}
										},
										{
											xtype : 'uniBaseButton',
											text : '<t:message code="system.label.base.save" default="저장 "/>',
											tooltip : '<t:message code="system.label.base.save" default="저장 "/>',
											iconCls : 'icon-save',
											disabled : true,
											width : 26,
											height : 26,
											itemId : 'sub_save4',
											handler : function() {
												var selectDetailRecord = detailGrid
														.getSelectedRecord();
												var param = {
													'DIV_CODE' : selectDetailRecord
															.get('DIV_CODE'),
													'WKORD_NUM' : selectDetailRecord
															.get('WKORD_NUM'),
													'PROG_WORK_CODE' : selectDetailRecord
															.get('PROG_WORK_CODE')
												}
												pmr101ukrvService
														.checkWorkEnd(
																param,
																function(
																		provider,
																		response) {
																	if (!Ext
																			.isEmpty(provider)) {
																		if (provider.WORK_END_YN == 'Y') {
																			alert('마감된 작업지시입니다.');
																			return false;
																		} else {
																			masterForm
																					.setValue(
																							'RESULT_TYPE',
																							"4");
																			directMasterStore9
																					.saveStore();
																		}
																	}
																});
											}
										} ]
							} ],
							columns : [
									{
										dataIndex : 'WKORD_NUM',
										width : 120,
										hidden : true
									},
									{
										dataIndex : 'PROG_WORK_CODE',
										width : 100,
										listeners : {
											render : function(elm) {
												var tGrid = elm.getView().ownerGrid;
												elm.editor
														.on(
																'beforequery',
																function(
																		queryPlan,
																		eOpts) {
																	var store = queryPlan.combo.store;
																	// var grdRecord = detailGrid.uniOpt.currentRecord;
																	// progWordComboStore.loadStoreRecords(grdRecord);
																	/*   store.clearFilter();
																	 store.filterBy(function(item){
																		 return item.get('option') == panelResult.getValue('DIV_CODE') && item.get('refCode1') == grdRecord.get('WKORD_NUM');
																	 }); */
																});
											}
										}
									/*  ,
														'editor': Unilite.popup('PROG_WORK_CODE_G',{
														textFieldName : 'PROG_WORK_NAME',
														DBtextFieldName : 'PROG_WORK_NAME',
														autoPopup: true,
														listeners: { 'onSelected': {
															fn: function(records, type  ){
																var grdRecord = masterGrid6.uniOpt.currentRecord;
																grdRecord.set('PROG_WORK_CODE',records[0]['PROG_WORK_CODE']);
																grdRecord.set('PROG_WORK_NAME',records[0]['PROG_WORK_NAME']);
															},
															scope: this
														  },
														  'onClear' : function(type)	{
																var grdRecord = masterGrid6.uniOpt.currentRecord;
																grdRecord.set('PROG_WORK_CODE','');
																grdRecord.set('PROG_WORK_NAME','');
														  },
														  applyextparam: function(popup){
																var param =  panelResult.getValues();
																record = detailGrid.getSelectedRecord();
																popup.setExtParam({'DIV_CODE': param.DIV_CODE});
																popup.setExtParam({'ITEM_CODE': record.get('ITEM_CODE')});
																popup.setExtParam({'WORK_SHOP_CODE': record.get('WORK_SHOP_CODE')});
														  }
														}
													}) */}, {
										dataIndex : 'PRODT_DATE',
										width : 100
									}, {
										dataIndex : 'CTL_CD1',
										width : 145
									}, {
										dataIndex : 'FR_TIME',
										width : 70,
										align : 'center',
										editor : {
											xtype : 'timefield',
											format : 'H:i',
											//	submitFormat: 'Hi', //i tried with and without this config
											increment : 10
										}
									}, {
										dataIndex : 'TO_TIME',
										width : 70,
										align : 'center',
										editor : {
											xtype : 'timefield',
											format : 'H:i',
											//	submitFormat: 'Hi', //i tried with and without this config
											increment : 10
										}
									}, {
										dataIndex : 'TROUBLE_TIME',
										width : 70
									}, {
										dataIndex : 'TROUBLE',
										width : 120
									}, {
										dataIndex : 'TROUBLE_CS',
										width : 120
									}, {
										dataIndex : 'ANSWER',
										width : 150
									}, {
										dataIndex : 'SEQ',
										width : 100,
										hidden : true
									},
									//Hidden : true
									{
										dataIndex : 'DIV_CODE',
										width : 0,
										hidden : true
									}, {
										dataIndex : 'WORK_SHOP_CODE',
										width : 0,
										hidden : true
									},
									//{dataIndex: 'PROG_WORK_CODE'		, width: 0 , hidden:true},
									{
										dataIndex : 'UPDATE_DB_USER',
										width : 0,
										hidden : true
									}, {
										dataIndex : 'UPDATE_DB_TIME',
										width : 0,
										hidden : true
									}, {
										dataIndex : 'COMP_CODE',
										width : 0,
										hidden : true
									} ],
							listeners : {
								beforeedit : function(editor, e, eOpts) {
									if (!e.record.phantom) {
										if (UniUtils.indexOf(e.field, [
												'PROG_WORK_CODE',
												'PROG_WORK_NAME', 'PRODT_DATE',
												'CTL_CD1' ]))
											return false
									}
									if (!e.record.phantom || e.record.phantom) {
										if (UniUtils
												.indexOf(e.field, [
														'WKORD_NUM',
														'PROG_WORK_CODE' ]))
											return false
									}
								},
								render : function(grid, eOpts) {
									grid
											.getEl()
											.on(
													'click',
													function(e, t, eOpt) {
														UniAppManager
																.setToolbarButtons(
																		[ 'newData' ],
																		true);
														if (grid.getStore()
																.count() > 0) {
															UniAppManager
																	.setToolbarButtons(
																			[ 'delete' ],
																			true);
														} else {
															UniAppManager
																	.setToolbarButtons(
																			[ 'delete' ],
																			false);
														}
													});
								}
							}
						});

		/*생산실적 등록 팝업 자재불량그리드*/
		var masterGrid10 = Unilite.createGrid('pmr101ukrvGrid10', {
			store : directMasterStore10,
			layout : 'fit',
			region : 'center',
			border : false,
			uniOpt : {
				expandLastColumn : false,
				useLiveSearch : true,
				//useContextMenu		: true,
				useMultipleSorting : true,
				useGroupSummary : false,
				useRowNumberer : false,
				filter : {
					useFilter : true,
					autoCreate : true
				},
				state : {
					useState : false, //그리드 설정 버튼 사용 여부
					useStateList : false
				//그리드 설정 목록 사용 여부
				}
			},
			sortableColumns : false,
			userToolbar : false,
			columns : columns,
			listeners : {
				beforeedit : function(editor, e) {
					if (UniUtils.indexOf(e.field, [ 'COMP_CODE', 'DIV_CODE',
							'ITEM_CODE', 'ITEM_NAME', 'SPEC', 'STOCK_UNIT',
							'CUSTOM_CODE', 'CUSTOM_NAME' ])) {
						return false
					}
				}
			}

		});

		//생산실적 수정 팝업 특기사항 그리드
		var masterGrid11 = Unilite
				.createGrid(
						'pmr101ukrvGrid11',
						{
							layout : 'fit',
							region : 'center',
							width : 960,
							border : false,
							store : directMasterStore9,
							uniOpt : {
								expandLastColumn : false,
								useRowNumberer : false,
								useMultipleSorting : true
							},
							sortableColumns : false,
							features : [ {
								id : 'masterGridSubTotal',
								ftype : 'uniGroupingsummary',
								showSummaryRow : false
							}, {
								id : 'masterGridTotal',
								ftype : 'uniSummary',
								showSummaryRow : false
							} ],
							dockedItems : [ {
								xtype : 'toolbar',
								dock : 'top',
								items : [
										{
											xtype : 'uniBaseButton',
											text : '<t:message code="system.label.base.inquiry" default="조회"/>',
											tooltip : '<t:message code="system.label.base.inquiry" default="조회"/>',
											iconCls : 'icon-query',
											width : 26,
											height : 26,
											itemId : 'sub_query11',
											handler : function() {
												//if( me._needSave()) {
												var toolbar = masterGrid11
														.getDockedItems('toolbar[dock="top"]');
												var needSave = !toolbar[0]
														.getComponent(
																'sub_save11')
														.isDisabled();
												var record = detailGrid
														.getSelectedRecord();
												if (needSave) {
													Ext.Msg
															.show({
																title : '<t:message code="system.label.base.confirm" default="확인"/>',
																msg : Msg.sMB017
																		+ "\n"
																		+ Msg.sMB061,
																buttons : Ext.Msg.YESNOCANCEL,
																icon : Ext.Msg.QUESTION,
																fn : function(
																		res) {
																	//console.log(res);
																	if (res === 'yes') {
																		var saveTask = Ext
																				.create(
																						'Ext.util.DelayedTask',
																						function() {
																							directMasterStore9
																									.saveStore();
																						});
																		saveTask
																				.delay(500);
																	} else if (res === 'no') {
																		directMasterStore9
																				.loadStoreRecords();
																	}
																}
															});
												} else {
													directMasterStore9
															.loadStoreRecords(record
																	.get('ITEM_CODE'));
												}
											}
										},
										{
											xtype : 'uniBaseButton',
											text : '<t:message code="system.label.base.reset" default="신규"/>',
											tooltip : '<t:message code="system.label.base.reset2" default="초기화"/>',
											iconCls : 'icon-reset',
											width : 26,
											height : 26,
											itemId : 'sub_reset11',
											handler : function() {
												var toolbar = masterGrid11
														.getDockedItems('toolbar[dock="top"]');
												var needSave = !toolbar[0]
														.getComponent(
																'sub_save11')
														.isDisabled();
												if (needSave) {
													Ext.Msg
															.show({
																title : '<t:message code="system.label.base.confirm" default="확인"/>',
																msg : Msg.sMB017
																		+ "\n"
																		+ Msg.sMB061,
																buttons : Ext.Msg.YESNOCANCEL,
																icon : Ext.Msg.QUESTION,
																fn : function(
																		res) {
																	console
																			.log(res);
																	if (res === 'yes') {
																		var saveTask = Ext
																				.create(
																						'Ext.util.DelayedTask',
																						function() {
																							directMasterStore9
																									.saveStore();
																						});
																		saveTask
																				.delay(500);
																	} else if (res === 'no') {
																		masterGrid11
																				.reset();
																		directMasterStore9
																				.clearData();
																		directMasterStore9
																				.setToolbarButtons(
																						'sub_save11',
																						false);
																		directMasterStore9
																				.setToolbarButtons(
																						'sub_delete11',
																						false);
																	}
																}
															});
												} else {
													masterGrid11.reset();
													directMasterStore9
															.clearData();
													directMasterStore9
															.setToolbarButtons(
																	'sub_save11',
																	false);
													directMasterStore9
															.setToolbarButtons(
																	'sub_delete11',
																	false);
												}
											}
										},
										{
											xtype : 'uniBaseButton',
											text : '<t:message code="system.label.base.add" default="추가"/>',
											tooltip : '<t:message code="system.label.base.add" default="추가"/>',
											iconCls : 'icon-new',
											width : 26,
											height : 26,
											itemId : 'sub_newData11',
											handler : function() {
												var record = detailGrid
														.getSelectedRecord();
												var progWorkRecord = masterGrid3
														.getSelectedRecord();
												var divCode = masterForm
														.getValue('DIV_CODE');
												var prodtDate = UniDate
														.get('today');
												var workShopcode = record
														.get('WORK_SHOP_CODE');
												var wkordNum = record
														.get('WKORD_NUM');
												var itemCode = record
														.get('ITEM_CODE');
												var ctlCd1 = '';
												var troubleTime = '';
												var trouble = '';
												var troubleCs = '';
												var answer = '';
												var seq = 0;
												seq = directMasterStore9
														.max('SEQ');

												if (Ext.isEmpty(seq)) {
													seq = 1;
												} else {
													seq = seq + 1;
												}
												var r = {
													DIV_CODE : divCode,
													PRODT_DATE : prodtDate,
													WORK_SHOP_CODE : workShopcode,
													WKORD_NUM : wkordNum,
													ITEM_CODE : itemCode,
													CTL_CD1 : ctlCd1,
													TROUBLE_TIME : troubleTime,
													TROUBLE : trouble,
													TROUBLE_CS : troubleCs,
													ANSWER : answer,
													//FR_TIME					:'2008-01-01 08:30:00',
													//TO_TIME				:'2008-01-01 17:30:00',
													PROG_WORK_CODE : progWorkRecord
															.get('PROG_WORK_CODE'),
													SEQ : seq
												//COMP_CODE				:compCode
												};
												masterGrid11.createRow(r);
											}
										},
										{
											xtype : 'uniBaseButton',
											text : '<t:message code="system.label.base.delete" default="삭제"/>',
											tooltip : '<t:message code="system.label.base.delete" default="삭제"/>',
											iconCls : 'icon-delete',
											disabled : true,
											width : 26,
											height : 26,
											itemId : 'sub_delete11',
											handler : function() {
												var selRow = masterGrid11
														.getSelectedRecord();
												if (!Ext.isEmpty(selRow)) {
													if (selRow.phantom == true) {
														masterGrid11
																.deleteSelectedRow();
													} else if (confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
														masterGrid11
																.deleteSelectedRow();
													}
												} else {
													alert(Msg.sMA0256);
													return false;
												}
											}
										},
										{
											xtype : 'uniBaseButton',
											text : '<t:message code="system.label.base.save" default="저장 "/>',
											tooltip : '<t:message code="system.label.base.save" default="저장 "/>',
											iconCls : 'icon-save',
											disabled : true,
											width : 26,
											height : 26,
											itemId : 'sub_save11',
											handler : function() {
												var selectDetailRecord = detailGrid
														.getSelectedRecord();
												var param = {
													'DIV_CODE' : selectDetailRecord
															.get('DIV_CODE'),
													'WKORD_NUM' : selectDetailRecord
															.get('WKORD_NUM'),
													'PROG_WORK_CODE' : selectDetailRecord
															.get('PROG_WORK_CODE')
												}
												pmr101ukrvService
														.checkWorkEnd(
																param,
																function(
																		provider,
																		response) {
																	if (!Ext
																			.isEmpty(provider)) {
																		if (provider.WORK_END_YN == 'Y') {
																			alert('마감된 작업지시입니다.');
																			return false;
																		} else {
																			masterForm
																					.setValue(
																							'RESULT_TYPE',
																							"4");
																			directMasterStore9
																					.saveStore();
																		}
																	}
																});
											}
										} ]
							} ],
							columns : [
									{
										dataIndex : 'WKORD_NUM',
										width : 120,
										hidden : true
									},
									{
										dataIndex : 'PROG_WORK_CODE',
										width : 100,
										listeners : {
											render : function(elm) {
												var tGrid = elm.getView().ownerGrid;
												elm.editor
														.on(
																'beforequery',
																function(
																		queryPlan,
																		eOpts) {
																	var store = queryPlan.combo.store;
																	// var grdRecord = detailGrid.uniOpt.currentRecord;
																	// progWordComboStore.loadStoreRecords(grdRecord);
																	/*   store.clearFilter();
																	 store.filterBy(function(item){
																		 return item.get('option') == panelResult.getValue('DIV_CODE') && item.get('refCode1') == grdRecord.get('WKORD_NUM');
																	 }); */
																});
											}
										}
									/*  ,
														'editor': Unilite.popup('PROG_WORK_CODE_G',{
														textFieldName : 'PROG_WORK_NAME',
														DBtextFieldName : 'PROG_WORK_NAME',
														autoPopup: true,
														listeners: { 'onSelected': {
															fn: function(records, type  ){
																var grdRecord = masterGrid6.uniOpt.currentRecord;
																grdRecord.set('PROG_WORK_CODE',records[0]['PROG_WORK_CODE']);
																grdRecord.set('PROG_WORK_NAME',records[0]['PROG_WORK_NAME']);
															},
															scope: this
														  },
														  'onClear' : function(type)	{
																var grdRecord = masterGrid6.uniOpt.currentRecord;
																grdRecord.set('PROG_WORK_CODE','');
																grdRecord.set('PROG_WORK_NAME','');
														  },
														  applyextparam: function(popup){
																var param =  panelResult.getValues();
																record = detailGrid.getSelectedRecord();
																popup.setExtParam({'DIV_CODE': param.DIV_CODE});
																popup.setExtParam({'ITEM_CODE': record.get('ITEM_CODE')});
																popup.setExtParam({'WORK_SHOP_CODE': record.get('WORK_SHOP_CODE')});
														  }
														}
													}) */}, {
										dataIndex : 'PRODT_DATE',
										width : 100
									}, {
										dataIndex : 'CTL_CD1',
										width : 145
									}, {
										dataIndex : 'FR_TIME',
										width : 70,
										align : 'center',
										editor : {
											xtype : 'timefield',
											format : 'H:i',
											//	submitFormat: 'Hi', //i tried with and without this config
											increment : 10
										}
									}, {
										dataIndex : 'TO_TIME',
										width : 70,
										align : 'center',
										editor : {
											xtype : 'timefield',
											format : 'H:i',
											//	submitFormat: 'Hi', //i tried with and without this config
											increment : 10
										}
									}, {
										dataIndex : 'TROUBLE_TIME',
										width : 70
									}, {
										dataIndex : 'TROUBLE',
										width : 120
									}, {
										dataIndex : 'TROUBLE_CS',
										width : 120
									}, {
										dataIndex : 'ANSWER',
										width : 150
									}, {
										dataIndex : 'SEQ',
										width : 100,
										hidden : true
									},
									//Hidden : true
									{
										dataIndex : 'DIV_CODE',
										width : 0,
										hidden : true
									}, {
										dataIndex : 'WORK_SHOP_CODE',
										width : 0,
										hidden : true
									},
									//{dataIndex: 'PROG_WORK_CODE'		, width: 0 , hidden:true},
									{
										dataIndex : 'UPDATE_DB_USER',
										width : 0,
										hidden : true
									}, {
										dataIndex : 'UPDATE_DB_TIME',
										width : 0,
										hidden : true
									}, {
										dataIndex : 'COMP_CODE',
										width : 0,
										hidden : true
									} ],
							listeners : {
								beforeedit : function(editor, e, eOpts) {
									if (!e.record.phantom) {
										if (UniUtils.indexOf(e.field, [
												'PROG_WORK_CODE',
												'PROG_WORK_NAME', 'PRODT_DATE',
												'CTL_CD1' ]))
											return false
									}
									if (!e.record.phantom || e.record.phantom) {
										if (UniUtils
												.indexOf(e.field, [
														'WKORD_NUM',
														'PROG_WORK_CODE' ]))
											return false
									}
								},
								render : function(grid, eOpts) {
									grid
											.getEl()
											.on(
													'click',
													function(e, t, eOpt) {
														UniAppManager
																.setToolbarButtons(
																		[ 'newData' ],
																		true);
														if (grid.getStore()
																.count() > 0) {
															UniAppManager
																	.setToolbarButtons(
																			[ 'delete' ],
																			true);
														} else {
															UniAppManager
																	.setToolbarButtons(
																			[ 'delete' ],
																			false);
														}
													});
								}
							}
						});

		//생산실적 수정 팝업 자재불량내역 그리드
		var masterGrid12 = Unilite
				.createGrid(
						'pmr101ukrvGrid12',
						{
							store : directMasterStore10,
							layout : 'fit',
							region : 'center',
							border : false,
							uniOpt : {
								expandLastColumn : false,
								useLiveSearch : true,
								//useContextMenu		: true,
								useMultipleSorting : true,
								useGroupSummary : false,
								useRowNumberer : false,
								filter : {
									useFilter : true,
									autoCreate : true
								}
							},
							sortableColumns : false,
							dockedItems : [ {
								xtype : 'toolbar',
								dock : 'top',
								items : [
										{
											xtype : 'uniBaseButton',
											text : '<t:message code="system.label.base.inquiry" default="조회"/>',
											tooltip : '<t:message code="system.label.base.inquiry" default="조회"/>',
											iconCls : 'icon-query',
											width : 26,
											height : 26,
											itemId : 'sub_query12',
											hidden : true,
											handler : function() {
												//if( me._needSave()) {
												var toolbar = masterGrid12
														.getDockedItems('toolbar[dock="top"]');
												var needSave = !toolbar[0]
														.getComponent(
																'sub_save12')
														.isDisabled();
												var record = detailGrid
														.getSelectedRecord();
												if (needSave) {
													Ext.Msg
															.show({
																title : '<t:message code="system.label.base.confirm" default="확인"/>',
																msg : Msg.sMB017
																		+ "\n"
																		+ Msg.sMB061,
																buttons : Ext.Msg.YESNOCANCEL,
																icon : Ext.Msg.QUESTION,
																fn : function(
																		res) {
																	//console.log(res);
																	if (res === 'yes') {
																		var saveTask = Ext
																				.create(
																						'Ext.util.DelayedTask',
																						function() {
																							directMasterStore10
																									.saveStore();
																						});
																		saveTask
																				.delay(500);
																	} else if (res === 'no') {
																		var badQtyArray = new Array();
																		badQtyArray = gsBadQtyInfo
																				.split(',');
																		if (directMasterStore10
																				.getCount() == 0) {
																			directMasterStore10
																					.loadStoreRecords(badQtyArray);
																		}
																	}
																}
															});
												} else {
													var badQtyArray = new Array();
													badQtyArray = gsBadQtyInfo
															.split(',');
													directMasterStore10
															.loadStoreRecords(badQtyArray);
												}
											}
										},
										{
											xtype : 'uniBaseButton',
											text : '<t:message code="system.label.base.reset" default="신규"/>',
											tooltip : '<t:message code="system.label.base.reset2" default="초기화"/>',
											iconCls : 'icon-reset',
											width : 26,
											height : 26,
											hidden : true,
											itemId : 'sub_reset12',
											handler : function() {
												var toolbar = masterGrid12
														.getDockedItems('toolbar[dock="top"]');
												var needSave = !toolbar[0]
														.getComponent(
																'sub_save12')
														.isDisabled();
												if (needSave) {
													Ext.Msg
															.show({
																title : '<t:message code="system.label.base.confirm" default="확인"/>',
																msg : Msg.sMB017
																		+ "\n"
																		+ Msg.sMB061,
																buttons : Ext.Msg.YESNOCANCEL,
																icon : Ext.Msg.QUESTION,
																fn : function(
																		res) {
																	console
																			.log(res);
																	if (res === 'yes') {
																		var saveTask = Ext
																				.create(
																						'Ext.util.DelayedTask',
																						function() {
																							directMasterStore10
																									.saveStore();
																						});
																		saveTask
																				.delay(500);
																	} else if (res === 'no') {
																		masterGrid12
																				.reset();
																		directMasterStore10
																				.clearData();
																		directMasterStore10
																				.setToolbarButtons(
																						'sub_save12',
																						false);
																		directMasterStore10
																				.setToolbarButtons(
																						'sub_delete12',
																						false);
																	}
																}
															});
												} else {
													masterGrid12.reset();
													directMasterStore10
															.clearData();
													directMasterStore10
															.setToolbarButtons(
																	'sub_save12',
																	false);
													directMasterStore10
															.setToolbarButtons(
																	'sub_delete12',
																	false);
												}
											}
										},
										{
											xtype : 'uniBaseButton',
											text : '<t:message code="system.label.base.delete" default="삭제"/>',
											tooltip : '<t:message code="system.label.base.delete" default="삭제"/>',
											iconCls : 'icon-delete',
											disabled : true,
											hidden : true,
											width : 26,
											height : 26,
											itemId : 'sub_delete12',
											handler : function() {
												var selRow = masterGrid12
														.getSelectedRecord();
												if (!Ext.isEmpty(selRow)) {
													if (selRow.phantom == true) {
														masterGrid12
																.deleteSelectedRow();
													} else if (confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
														masterGrid12
																.deleteSelectedRow();
													}
												} else {
													alert(Msg.sMA0256);
													return false;
												}
											}
										},
										{
											xtype : 'uniBaseButton',
											text : '<t:message code="system.label.base.save" default="저장 "/>',
											tooltip : '<t:message code="system.label.base.save" default="저장 "/>',
											iconCls : 'icon-save',
											disabled : true,
											hidden : true,
											width : 26,
											height : 26,
											itemId : 'sub_save12',
											handler : function() {
												var selectDetailRecord = detailGrid
														.getSelectedRecord();
												var param = {
													'DIV_CODE' : selectDetailRecord
															.get('DIV_CODE'),
													'WKORD_NUM' : selectDetailRecord
															.get('WKORD_NUM'),
													'PROG_WORK_CODE' : selectDetailRecord
															.get('PROG_WORK_CODE')
												}
												pmr101ukrvService
														.checkWorkEnd(
																param,
																function(
																		provider,
																		response) {
																	if (!Ext
																			.isEmpty(provider)) {
																		if (provider.WORK_END_YN == 'Y') {
																			alert('마감된 작업지시입니다.');
																			return false;
																		} else {
																			//masterForm.setValue('RESULT_TYPE', "4");
																			directMasterStore10
																					.saveStore();
																		}
																	}
																});
											}
										} ]
							} ],

							columns : columns,
							listeners : {
								beforeedit : function(editor, e) {
									if (UniUtils.indexOf(e.field, [
											'COMP_CODE', 'DIV_CODE',
											'ITEM_CODE', 'ITEM_NAME', 'SPEC',
											'STOCK_UNIT', 'CUSTOM_CODE',
											'CUSTOM_NAME' ])) {
										return false
									}
								}
							}

						});

		var tab = Unilite
				.createTabPanel(
						'tabPanel',
						{
							split : true,
							hidden : true,
							border : false,
							region : 'west',
							items : [
									{
										layout : {
											type : 'vbox',
											align : 'stretch'
										},
										title : '<t:message code="system.label.product.routingperentry" default="공정별등록"/>',
										id : 'pmr101ukrvGrid3_1',
										items : [ masterGrid3
										//masterGrid4
										]
									},
									//masterGrid2,
									//masterGrid5,
									//masterGrid6,
									//20190508 제조이력등록 탭 추가
									{
										layout : {
											type : 'vbox',
											align : 'stretch'
										},
										title : '제조이력등록',
										id : 'pmr101ukrvGrid7_1',
										hidden : true,
										items : [ masterGrid8, masterGrid7 ]
									}

							],
							listeners : {
								beforetabchange : function(grouptabPanel,
										newCard, oldCard, eOpts) {
									if (!UniAppManager.app.isValidSearchForm()) {
										return false;
									}
									if (UniAppManager.app._needSave()) {
										if (confirm(Msg.sMB017 + "\n"
												+ Msg.sMB061)) {
											UniAppManager.app
													.onSaveDataButtonDown();
											return false;
										}
									}
								},
								tabChange : function(tabPanel, newCard,
										oldCard, eOpts) {
									//				UniAppManager.setToolbarButtons(['newData', 'delete'], false);
									var newTabId = newCard.getId();
									var record = detailGrid.getSelectedRecord();
									if (!Ext.isEmpty(record)) {
										if (newTabId == 'pmr101ukrvGrid2') {
											directMasterStore2
													.loadStoreRecords(record);
											UniAppManager.setToolbarButtons(
													[ 'newData' ], true);
										} else if (newTabId == 'pmr101ukrvGrid3_1') {
											directMasterStore3
													.loadStoreRecords(record);
											UniAppManager.setToolbarButtons(
													[ 'newData' ], false);
										} else if (newTabId == 'pmr101ukrvGrid5') {
											directMasterStore5
													.loadStoreRecords(record);
											UniAppManager.setToolbarButtons(
													[ 'newData' ], true);
										} else if (newTabId == 'pmr101ukrvGrid6') {
											directMasterStore6
													.loadStoreRecords(record);
											UniAppManager.setToolbarButtons(
													[ 'newData' ], true);
										} else if (newTabId == 'pmr101ukrvGrid7_1') {
											directMasterStore8
													.loadStoreRecords(record);
											UniAppManager.setToolbarButtons(
													[ 'newData' ], false);
										}
									}
								}
							}
						});

		var outouProdtSaveSearch = Unilite
				.createSearchForm(
						'outouProdtSaveForm',
						{ // 생산실적 자동입고
							layout : {
								type : 'uniTable',
								columns : 2
							},
							items : [
									{
										xtype : 'container',
										html : '※ <t:message code="system.label.product.goodreceipt" default="양품입고"/>',
										colspan : 2,
										style : {
											color : 'blue'
										}
									},
									{
										fieldLabel : '<t:message code="system.label.product.goodreceiptwarehouse" default="양품입고창고"/>',
										name : 'GOOD_WH_CODE',
										allowBlank : false,
										xtype : 'uniCombobox',
										comboType : 'OU',
										child : 'GOOD_WH_CELL_CODE',
										colspan : 1,
										listeners : {
											beforequery : function(queryPlan,
													eOpts) {
												var store = queryPlan.combo.store;
												store.clearFilter();
												if (!Ext.isEmpty(panelResult
														.getValue('DIV_CODE'))) {
													store
															.filterBy(function(
																	record) {
																return record
																		.get('option') == panelResult
																		.getValue('DIV_CODE');
															})
												} else {
													store.filterBy(function(
															record) {
														return false;
													})
												}
											},
											change : function(combo, newValue,
													oldValue, eOpts) {
												outouProdtSaveSearch
														.setValue(
																'BAD_WH_CODE',
																newValue);
											}
										}
									},
									{
										fieldLabel : '<t:message code="system.label.product.goodwarehousecell" default="양품창고cell"/>',
										name : 'GOOD_WH_CELL_CODE',
										xtype : 'uniCombobox',
										disabled : sumTypeChk,
										store : Ext.data.StoreManager
												.lookup('whCellList'),
										listeners : {
											change : function(combo, newValue,
													oldValue, eOpts) {

											}
										}
									},
									{
										fieldLabel : '<t:message code="system.label.product.receiptcharger" default="입고담당자"/>',
										name : 'GOOD_PRSN',
										allowBlank : false,
										xtype : 'uniCombobox',
										comboType : 'AU',
										comboCode : 'B024',
										listeners : {
											beforequery : function(queryPlan,
													eOpts) {
												var store = queryPlan.combo.store;
												store.clearFilter();
												if (!Ext.isEmpty(panelResult
														.getValue('DIV_CODE'))) {
													store
															.filterBy(function(
																	record) {
																return record
																		.get('refCode1') == panelResult
																		.getValue('DIV_CODE');
															})
												} else {
													store.filterBy(function(
															record) {
														return false;
													})
												}
											},
											change : function(combo, newValue,
													oldValue, eOpts) {
												outouProdtSaveSearch.setValue(
														'BAD_PRSN', newValue);
											}
										}
									},
									{
										fieldLabel : '<t:message code="system.label.product.gooditemqty" default="양품량"/>',
										name : 'GOOD_Q',
										xtype : 'uniNumberfield'
									},
									{
										xtype : 'container',
										html : '※ <t:message code="system.label.product.defectreceipt" default="불량입고"/>',
										colspan : 2,
										style : {
											color : 'blue'
										}
									},
									{
										fieldLabel : '<t:message code="system.label.product.defectreceiptwarehouse" default="불량입고창고"/>',
										name : 'BAD_WH_CODE',
										child : 'BAD_WH_CELL_CODE',
										allowBlank : true,
										xtype : 'uniCombobox',
										comboType : 'OU',
										colspan : 1
									},
									{
										fieldLabel : '<t:message code="system.label.product.badwarehousecell" default="불량창고cell"/>',
										name : 'BAD_WH_CELL_CODE',
										xtype : 'uniCombobox',
										disabled : sumTypeChk,
										store : Ext.data.StoreManager
												.lookup('whCellList2'),
										listeners : {
											render : function(combo, eOpts) {

											}
										}

									},
									{
										fieldLabel : '<t:message code="system.label.product.receiptcharger" default="입고담당자"/>',
										name : 'BAD_PRSN',
										allowBlank : true,
										xtype : 'uniCombobox',
										comboType : 'AU',
										comboCode : 'B024',
										listeners : {
											beforequery : function(queryPlan,
													eOpts) {
												var store = queryPlan.combo.store;
												store.clearFilter();
												if (!Ext.isEmpty(panelResult
														.getValue('DIV_CODE'))) {
													store
															.filterBy(function(
																	record) {
																return record
																		.get('refCode1') == panelResult
																		.getValue('DIV_CODE');
															})
												} else {
													store.filterBy(function(
															record) {
														return false;
													})
												}
											}
										}
									},
									{
										fieldLabel : '<t:message code="system.label.product.defectqty" default="불량수량"/>',
										name : 'BAD_Q',
										xtype : 'uniNumberfield'
									} ],
							setAllFieldsReadOnly : function(b) {
								var r = true
								if (b) {
									var invalid = this.getForm().getFields()
											.filterBy(function(field) {
												return !field.validate();
											});
									if (invalid.length > 0) {
										r = false;
										var labelText = ''
										if (Ext
												.isDefined(invalid.items[0]['fieldLabel'])) {
											var labelText = invalid.items[0]['fieldLabel']
													+ ' : ';
										} else if (Ext
												.isDefined(invalid.items[0].ownerCt)) {
											var labelText = invalid.items[0].ownerCt['fieldLabel']
													+ ' : ';
										}
										alert(labelText + Msg.sMB083);
										invalid.items[0].focus();
									} else {
										//this.mask();
										var fields = this.getForm().getFields();
										Ext
												.each(
														fields.items,
														function(item) {
															if (Ext
																	.isDefined(item.holdable)) {
																if (item.holdable == 'hold') {
																	item
																			.setReadOnly(true);
																}
															}
															if (item.isPopupField) {
																var popupFC = item
																		.up('uniPopupField');
																if (popupFC.holdable == 'hold') {
																	popupFC
																			.setReadOnly(true);
																}
															}
														})
									}
								} else {
									//this.unmask();
									var fields = this.getForm().getFields();
									Ext.each(fields.items, function(item) {
										if (Ext.isDefined(item.holdable)) {
											if (item.holdable == 'hold') {
												item.setReadOnly(false);
											}
										}
										if (item.isPopupField) {
											var popupFC = item
													.up('uniPopupField');
											if (popupFC.holdable == 'hold') {
												item.setReadOnly(false);
											}
										}
									})
								}
								return r;
							}
						});

		function openoutouProdtSave() { // 생산실적 자동입고
			if (!outouProdtSave) {
				outouProdtSave = Ext
						.create(
								'widget.uniDetailWindow',
								{
									title : '<t:message code="system.label.product.productionautoinput" default="생산실적 자동입고"/>',
									width : 550,
									height : 360,
									layout : {
										type : 'vbox',
										align : 'stretch'
									},
									items : [ outouProdtSaveSearch ],
									tbar : [
											'->',
											{
												itemId : 'saveBtn',
												text : '<t:message code="system.label.product.confirm" default="확인"/>',
												handler : function() {
													var activeTabId = tab
															.getActiveTab()
															.getId();
													if (activeTabId == 'pmr101ukrvGrid2') { // 작업지시별 등록
														if (outouProdtSaveSearch
																.setAllFieldsReadOnly(true) == false) {
															return false;
														} else {

															if (BsaCodeInfo.gsSumTypeCell == 'Y') {//cell을 사용하고 있을 경우
																if (Ext
																		.isEmpty(outouProdtSaveSearch
																				.getValue('GOOD_WH_CELL_CODE'))) {
																	alert('<t:message code="system.message.product.message066" default="양품 입고창고cell을 선택해 주십시오."/>');
																	return false;
																}
															}

															if (!Ext
																	.isEmpty(outouProdtSaveSearch
																			.getValue('BAD_Q'))
																	&& outouProdtSaveSearch
																			.getValue('BAD_Q') > 0) {
																if (BsaCodeInfo.gsSumTypeCell == 'Y') {//cell을 사용하고 있을 경우
																	if (Ext
																			.isEmpty(outouProdtSaveSearch
																					.getValue('BAD_WH_CODE'))) {
																		alert('<t:message code="system.message.product.message061" default="불량 입고창고를 선택해 주십시오."/>');
																		return false;
																	} else if (Ext
																			.isEmpty(outouProdtSaveSearch
																					.getValue('BAD_PRSN'))) {
																		alert('<t:message code="system.message.product.message062" default="불량 입고담당자를 선택해 주십시오."/>');
																		return false;
																	} else if (Ext
																			.isEmpty(outouProdtSaveSearch
																					.getValue('BAD_WH_CELL_CODE'))) {
																		alert('<t:message code="system.message.product.message065" default="불량 입고창고cell을 선택해 주십시오."/>');
																		return false;
																	}
																} else {
																	if (Ext
																			.isEmpty(outouProdtSaveSearch
																					.getValue('BAD_WH_CODE'))) {
																		alert('<t:message code="system.message.product.message061" default="불량 입고창고를 선택해 주십시오."/>');
																		return false;
																	} else if (Ext
																			.isEmpty(outouProdtSaveSearch
																					.getValue('BAD_PRSN'))) {
																		alert('<t:message code="system.message.product.message062" default="불량 입고담당자를 선택해 주십시오."/>');
																		return false;
																	}
																}

															}

															var records = masterGrid2
																	.getStore()
																	.getNewRecords();
															Ext
																	.each(
																			records,
																			function(
																					record,
																					i) {
																				masterGrid2
																						.setOutouProdtSave(record);
																			});
															outouProdtSave
																	.hide();
															directMasterStore2
																	.saveStore();
														}
													}
													if (activeTabId == 'pmr101ukrvGrid3_1') { // 공정별 등록
														if (outouProdtSaveSearch
																.setAllFieldsReadOnly(true) == false) {
															return false;
														} else {
															//공정별등록 그리드 관련 로직
															if (BsaCodeInfo.gsSumTypeCell == 'Y') {//cell을 사용하고 있을 경우
																if (Ext
																		.isEmpty(outouProdtSaveSearch
																				.getValue('GOOD_WH_CELL_CODE'))) {
																	alert('<t:message code="system.message.product.message066" default="양품 입고창고cell을 선택해 주십시오."/>');
																	return false;
																}
															}
															if (!Ext
																	.isEmpty(outouProdtSaveSearch
																			.getValue('BAD_Q'))
																	&& outouProdtSaveSearch
																			.getValue('BAD_Q') > 0) {
																if (BsaCodeInfo.gsSumTypeCell == 'Y') {//cell을 사용하고 있을 경우
																	if (Ext
																			.isEmpty(outouProdtSaveSearch
																					.getValue('BAD_WH_CODE'))) {
																		alert('불량 입고창고를 선택해 주십시오.');
																		return false;
																	} else if (Ext
																			.isEmpty(outouProdtSaveSearch
																					.getValue('BAD_PRSN'))) {
																		alert('불량 입고담당자를 선택해 주십시오.');
																		return false;
																	} else if (Ext
																			.isEmpty(outouProdtSaveSearch
																					.getValue('BAD_WH_CELL_CODE'))) {
																		alert('<t:message code="system.message.product.message065" default="불량 입고창고cell을 선택해 주십시오."/>');
																		return false;
																	}

																} else {
																	if (Ext
																			.isEmpty(outouProdtSaveSearch
																					.getValue('BAD_WH_CODE'))) {
																		alert('불량 입고창고를 선택해 주십시오.');
																		return false;
																	} else if (Ext
																			.isEmpty(outouProdtSaveSearch
																					.getValue('BAD_PRSN'))) {
																		alert('불량 입고담당자를 선택해 주십시오.');
																		return false;
																	}
																}

															}
															var updateData = masterGrid3
																	.getStore()
																	.getUpdatedRecords();
															if (!Ext
																	.isEmpty(updateData)) {
																Ext
																		.each(
																				updateData,
																				function(
																						updateRecord,
																						i) {
																					if (updateRecord
																							.get('LINE_END_YN') == 'Y') {
																						masterGrid3
																								.setOutouProdtSave(updateRecord);
																					}
																				});
																outouProdtSave
																		.hide();
																directMasterStore3
																		.saveStore();
															}

															//실적현황 그리드 관련 로직
															var deleteData = masterGrid4
																	.getStore()
																	.getRemovedRecords(); //실적현황 그리드의 삭제된 데이터
															if (!Ext
																	.isEmpty(deleteData)) {
																Ext
																		.each(
																				deleteData,
																				function(
																						deleteRecord,
																						i) {
																					if (deleteRecord
																							.get('LINE_END_YN') == 'Y') {
																						masterGrid4
																								.setOutouProdtSave(deleteRecord);
																					}
																				});
																outouProdtSave
																		.hide();
																directMasterStore4
																		.saveStore();
															}

														}
													}
												},
												disabled : false
											},
											{
												itemId : 'CloseBtn',
												text : '<t:message code="system.label.product.close" default="닫기"/>',
												handler : function() {
													outouProdtSave.hide();
												}
											} ],
									listeners : {
										beforehide : function(me, eOpt) {
											outouProdtSaveSearch.clearForm();
										},
										beforeshow : function(panel, eOpts) {
											var activeTabId = tab
													.getActiveTab().getId();
											var detailRecord = detailGrid
													.getSelectedRecord();
											if (activeTabId == 'pmr101ukrvGrid2') { // 작업지시별 등록
												var record = masterGrid2
														.getSelectedRecord();
												outouProdtSaveSearch
														.setValue(
																'GOOD_Q',
																record
																		.get('GOOD_PRODT_Q'));
												outouProdtSaveSearch
														.setValue(
																'BAD_Q',
																record
																		.get('BAD_PRODT_Q'));

												outouProdtSaveSearch
														.setValue(
																'GOOD_WH_CODE',
																detailRecord
																		.get('WH_CODE'));

												if (!Ext.isEmpty(record
														.get('BAD_PRODT_Q'))) {
													outouProdtSaveSearch
															.setValue(
																	'BAD_WH_CODE',
																	detailRecord
																			.get('WH_CODE'));

												}
											}
											if (activeTabId == 'pmr101ukrvGrid3_1') { // 공정 등록
												var records = directMasterStore3.data.items;

												Ext
														.each(
																records,
																function(
																		record,
																		i) {
																	if (record
																			.get('LINE_END_YN') == 'Y') {

																		outouProdtSaveSearch
																				.setValue(
																						'GOOD_Q',
																						record
																								.get('GOOD_WORK_Q'));
																		outouProdtSaveSearch
																				.setValue(
																						'BAD_Q',
																						record
																								.get('BAD_WORK_Q'));

																		outouProdtSaveSearch
																				.setValue(
																						'GOOD_WH_CODE',
																						detailRecord
																								.get('WH_CODE'));

																		if (!Ext
																				.isEmpty(record
																						.get('BAD_WORK_Q'))) {
																			outouProdtSaveSearch
																					.setValue(
																							'BAD_WH_CODE',
																							detailRecord
																									.get('WH_CODE'));

																		}
																	}
																});

											}
										}
									}
								})
			}
			outouProdtSave.center();
			outouProdtSave.show();
		}

		var tab2 = Unilite
				.createTabPanel(
						'tabPanel2',
						{
							split : false,
							border : true,
							activeTab : 0,
							margin : '-3 0 0 0',
							region : 'center',
							height : 700,
							width : 1010,
							items : [
									{
										layout : {
											type : 'vbox',
											align : 'stretch'
										},
										title : '생산실적등록',
										xtype : 'container',
										width : 1010,
										id : 'pmr101ukrvGrid9_tab1',
										items : [ {
											height : 700,
											xtype : 'uniDetailForm',
											//	 xtype:'panel',
											//	 xtype:'uniFieldset',
											disabled : false,
											layout : {
												type : 'uniTable',
												columns : 1
											},
											margin : '0 0 0 20',
											border : false,
											itemId : 'tab2Form',
											items : [
													{
														fieldLabel : '<t:message code="system.label.product.routingname" default="공정명"/>',
														name : 'PROG_WORK_NAME',
														xtype : 'uniTextfield',
														margin : '0 0 0 0',
														readOnly : true
													},
													{
														xtype : 'container',
														layout : {
															type : 'uniTable',
															columns : 3
														},
														defaults : {
															padding : '0 0 0 0'
														},
														items : [
																{
																	fieldLabel : '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
																	name : 'WKORD_Q2',
																	xtype : 'uniNumberfield',
																	type : 'uniQty',
																	readOnly : true
																},
																{
																	fieldLabel : '<t:message code="system.label.product.unit" default="단위"/>',
																	name : 'STOCK_UNIT2',
																	xtype : 'uniTextfield',
																	width : 150,
																	colspan : 2,
																	readOnly : true,
																	fieldStyle : 'text-align: center;'
																},
																{
																	padding : '3 0 0 0',
																	fieldLabel : '<t:message code="system.label.product.productionleftqty" default="생산잔량"/>',
																	name : 'JAN_Q',
																	xtype : 'uniNumberfield',
																	type : 'uniQty',
																	readOnly : true

																},
																{
																	padding : '3 0 0 0',
																	fieldLabel : '<t:message code="system.label.product.productiontotal" default="생산누계"/>',
																	name : 'SUM_Q',
																	xtype : 'uniNumberfield',
																	type : 'uniQty',
																	readOnly : true
																},
																,
																{
																	xtype : 'component',
																	//html:'<hr/>',
																	tdAttrs : {
																		align : 'center'
																	},
																	width : 670,
																	padding : '0 0 0 0',
																	colspan : 3
																},
																{
																	padding : '12 0 0 0',
																	fieldLabel : '<t:message code="system.label.product.productiondate" default="생산일자"/>',
																	xtype : 'uniDatefield',
																	name : 'PRODT_DATE',
																	value : UniDate
																			.get('today'),
																	fieldStyle : 'text-align: center;background-color: yellow; background-image: none;',
																	readOnly : false,
																	allowBlank : false
																},
																{
																	xtype : 'container',
																	layout : {
																		type : 'uniTable',
																		columns : 2
																	},
																	colspan : 2,
																	defaults : {
																		padding : '-3 0 0 0'
																	},
																	items : [
																			{
																				padding : '9 0 0 0',
																				fieldLabel : 'LOT_NO',
																				xtype : 'uniTextfield',
																				name : 'LOT_NO',
																				readOnly : false,
																				fieldStyle : 'text-align: center;'
																			},
																	/*	{
																	  	padding: '9 0 0 0',
																	  	fieldLabel: '<t:message code="system.label.product.expirationdate" default="유통기한"/>',
																			xtype: 'uniDatefield',
																			name: 'EXPIRATION_DATE',
																			value:UniDate.get('today'),
																			readOnly : false,
																			allowBlank:true
																		}*/]
																} ]
													},
													{
														xtype : 'container',
														layout : {
															type : 'uniTable',
															columns : 4
														},
														padding : '12 0 0 0',
														defaults : {
															padding : '-3 0 0 0'
														},
														items : [
																{
																	fieldLabel : '<t:message code="system.label.product.productionqty" default="생산량"/>',
																	name : 'WORK_Q',
																	xtype : 'uniNumberfield',
																	decimalPrecision : 1,
																	fieldStyle : 'background-color: yellow; background-image: none;',
																	readOnly : false,
																	allowBlank : false,
																	listeners : {
																		change : function(
																				field,
																				newValue,
																				oldValue,
																				eOpts) {
																			if (newValue < 0) {
																				alert('생산량에는 양수만 가능합니다.');
																				tab2
																						.down(
																								'#tab2Form')
																						.setValue(
																								'WORK_Q',
																								oldValue);
																				return false;
																			}
																			calPassQMethod = 'A';
																			resultFormQtyClear('WORK_Q');//생산량 입력시 전체 수량 클리어
																			fn_resultQtyCalc(
																					calPassQMethod,
																					'WORK_Q',
																					newValue);

																		},
																		afterrender : function(
																				cmp) {
																			/*cmp.inputEl.set({ //see http://jsfiddle.net/4TSDu/19/
																			    autocomplete:'on'
																			});

																			// simply attach this to the change event from dom element
																			cmp.inputEl.dom.addEventListener('change', function(){
																			    cmp.setValue(this.value);
																			});

																			//focus on field
																			cmp.inputEl.dom.focus();

																			// see http://www.greywyvern.com/code/javascript/keyboard
																			VKI_attach(cmp.inputEl.dom);*/
																		},
																		focus : function(
																				field,
																				event,
																				eOpts) {
																			//gsFocus = 	field;
																			//openKeyPadWindow();

																		}
																	}
																},

														]

													},
													{
														xtype : 'container',
														layout : {
															type : 'uniTable',
															columns : 5
														},
														defaults : {
															padding : '-3 0 0 0'
														},
														items : [
																{
																	fieldLabel : '<t:message code="system.label.product.gooditemqty" default="양품량"/>',
																	name : 'GOOD_WORK_Q',
																	id : 'goodWorkQ',
																	xtype : 'uniNumberfield',
																	decimalPrecision : 1,
																	readOnly : false,
																	//fieldStyle: 'background: yellow; background-image: none;',
																	listeners : {
																		change : function(
																				field,
																				newValue,
																				oldValue,
																				eOpts) {
																			if (newValue < 0) {
																				alert('양품량에는 양수만 가능합니다.');
																				tab2
																						.down(
																								'#tab2Form')
																						.setValue(
																								'GOOD_WORK_Q',
																								oldValue);
																				return false;
																			}
																			calPassQMethod = 'B';
																			resultFormQtyClear('GOOD_WORK_Q');//양품량 입력시 전체 수량 클리어
																			fn_resultQtyCalc(
																					calPassQMethod,
																					'GOOD_WORK_Q',
																					newValue);
																		},
																		afterrender : function(
																				cmp) {
																			/*	cmp.inputEl.set({ //see http://jsfiddle.net/4TSDu/19/
																			        autocomplete:'on'
																			    });

																			    // simply attach this to the change event from dom element
																			    cmp.inputEl.dom.addEventListener('change', function(){
																			        cmp.setValue(this.value);
																			    });

																			    //focus on field
																			    cmp.inputEl.dom.focus();

																			    // see http://www.greywyvern.com/code/javascript/keyboard
																			    VKI_attach(cmp.inputEl.dom);*/
																		}
																	}
																},
																{
																	fieldLabel : '<t:message code="system.label.product.defectqty" default="불량수량"/>',
																	name : 'BAD_WORK_Q',
																	xtype : 'uniNumberfield',
																	decimalPrecision : 1,
																	margin : '0 0 0 0',
																	readOnly : false,
																	listeners : {
																		change : function(
																				field,
																				newValue,
																				oldValue,
																				eOpts) {
																			if (newValue < 0) {
																				return false;
																			}
																			fn_resultQtyCalc(
																					calPassQMethod,
																					'BAD_WORK_Q',
																					newValue);
																		},
																		afterrender : function(
																				cmp) {
																			/*	cmp.inputEl.set({ //see http://jsfiddle.net/4TSDu/19/
																			        autocomplete:'on'
																			    });

																			    // simply attach this to the change event from dom element
																			    cmp.inputEl.dom.addEventListener('change', function(){
																			        cmp.setValue(this.value);
																			    });

																			    //focus on field
																			    cmp.inputEl.dom.focus();

																			    // see http://www.greywyvern.com/code/javascript/keyboard
																			    VKI_attach(cmp.inputEl.dom);*/
																		}
																	}
																}, ]
													},
													//	{ xtype: 'container',
													//		 layout:{type:'uniTable',columns:3},
													//		 defaults	: { padding: '-3 0 0 0'},
													//  		 items:[
													{
														xtype : 'container',
														layout : {
															type : 'uniTable',
															columns : 5
														},
														colspan : 1,
														defaults : {
															padding : '13 0 0 0'
														},
														items : [
																{
																	fieldLabel : '<t:message code="system.label.product.workhour" default="작업시간"/>',
																	name : 'FR_TIME',
																	xtype : 'timefield',
																	format : 'H:i',
																	increment : 10,
																	width : 200,
																	readOnly : false,
																	fieldStyle : 'text-align: center;',
																	listeners : {
																		change : function(
																				field,
																				newValue,
																				oldValue,
																				eOpts) {

																		},
																		blur : function(
																				field,
																				event,
																				eOpts) {
																			if (!Ext
																					.isEmpty(UniDate
																							.getHHMI(tab2
																									.down(
																											'#tab2Form')
																									.getValue(
																											'TO_TIME')))) {
																				if (UniDate
																						.getHHMI(field.lastValue) > UniDate
																						.getHHMI(tab2
																								.down(
																										'#tab2Form')
																								.getValue(
																										'TO_TIME'))) {
																					alert('작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.');
																					tab2
																							.down(
																									'#tab2Form')
																							.setValue(
																									'FR_TIME',
																									field.originalValue);
																					return false;
																				}
																				var diffTime = (tab2
																						.down(
																								'#tab2Form')
																						.getValue(
																								'TO_TIME') - field.lastValue) / 60000 / 60;
																				var manCnt = tab2
																						.down(
																								'#tab2Form')
																						.getValue(
																								'MAN_CNT');
																				if (Ext
																						.isEmpty(diffTime)
																						|| diffTime == 0) {
																					tab2
																							.down(
																									'#tab2Form')
																							.setValue(
																									'MAN_HOUR',
																									0);
																				} else {
																					if (tab2
																							.down(
																									'#tab2Form')
																							.getValue(
																									'LUNCH_CHK') == true) {
																						if ((tab2
																								.down(
																										'#tab2Form')
																								.getValue(
																										'TO_TIME') >= panelResult
																								.getValue('GS_TO_TIME'))
																								&& (field.lastValue <= panelResult
																										.getValue('GS_FR_TIME'))) {
																							diffTime = diffTime - 1
																						}
																					}
																					tab2
																							.down(
																									'#tab2Form')
																							.setValue(
																									'MAN_HOUR',
																									manCnt
																											* diffTime);
																				}
																				field.originalValue = field.lastValue;
																			}

																		}
																	}
																},
																{
																	xtype : 'component',
																	html : '~',
																	margin : '0 0 0 0',
																	style : {
																		marginTop : '3px !important',
																		font : '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
																	}
																},
																{
																	fieldLabel : '',
																	name : 'TO_TIME',
																	xtype : 'timefield',
																	format : 'H:i',
																	increment : 10,
																	width : 85,
																	readOnly : false,
																	fieldStyle : 'text-align: center;',
																	listeners : {
																		change : function(
																				field,
																				newValue,
																				oldValue,
																				eOpts) {

																		},
																		blur : function(
																				field,
																				event,
																				eOpts) {
																			if (!Ext
																					.isEmpty(UniDate
																							.getHHMI(tab2
																									.down(
																											'#tab2Form')
																									.getValue(
																											'FR_TIME')))) {
																				if (UniDate
																						.getHHMI(tab2
																								.down(
																										'#tab2Form')
																								.getValue(
																										'FR_TIME')) > UniDate
																						.getHHMI(field.lastValue)) {
																					alert('작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.');
																					tab2
																							.down(
																									'#tab2Form')
																							.setValue(
																									'TO_TIME',
																									field.originalValue);
																					return false;
																				}
																				/* 	if(Ext.isEmpty(resultsAddForm.getValue('MAN_CNT')) || resultsAddForm.getValue('MAN_CNT') == 0){
																						alert('작업인원을 입력해주세요.');
																						resultsAddForm.setValue('TO_TIME', UniDate.getHHMI(field.originalValue));
																						resultsAddForm.getField('MAN_CNT').focus();
																						return false;
																					} */
																				var diffTime = (field.lastValue - tab2
																						.down(
																								'#tab2Form')
																						.getValue(
																								'FR_TIME')) / 60000 / 60;
																				var manCnt = tab2
																						.down(
																								'#tab2Form')
																						.getValue(
																								'MAN_CNT');
																				if (Ext
																						.isEmpty(diffTime)
																						|| diffTime == 0) {
																					tab2
																							.down(
																									'#tab2Form')
																							.setValue(
																									'MAN_HOUR',
																									0);
																				} else {
																					if (tab2
																							.down(
																									'#tab2Form')
																							.getValue(
																									'LUNCH_CHK') == true) {
																						if ((field.lastValue >= panelResult
																								.getValue('GS_TO_TIME'))
																								&& (tab2
																										.down(
																												'#tab2Form')
																										.getValue(
																												'FR_TIME') <= panelResult
																										.getValue('GS_FR_TIME'))) {
																							diffTime = diffTime - 1;
																						}
																					}
																					tab2
																							.down(
																									'#tab2Form')
																							.setValue(
																									'MAN_HOUR',
																									manCnt
																											* diffTime);
																				}
																				field.originalValue = field.lastValue;
																			}

																		}
																	}
																},
																{
																	xtype : 'uniCheckboxgroup',
																	fieldLabel : '점심시간',
																	labelWidth : 100,
																	id : 'LUNCH_CHK1',
																	items : [ {
																		boxLabel : '',
																		width : 100,
																		name : 'LUNCH_CHK',
																		checked : true,
																		inputValue : 'Y'
																	} ],
																	listeners : {
																		change : function(
																				field,
																				newValue,
																				oldValue,
																				eOpts) {
																			if (newValue.LUNCH_CHK == 'Y') {
																				var diffTime = (tab2
																						.down(
																								'#tab2Form')
																						.getValue(
																								'TO_TIME') - tab2
																						.down(
																								'#tab2Form')
																						.getValue(
																								'FR_TIME')) / 60000 / 60;
																				if ((tab2
																						.down(
																								'#tab2Form')
																						.getValue(
																								'TO_TIME') >= panelResult
																						.getValue('GS_TO_TIME'))
																						&& (tab2
																								.down(
																										'#tab2Form')
																								.getValue(
																										'FR_TIME') <= panelResult
																								.getValue('GS_FR_TIME'))) {
																					diffTime = diffTime - 1;
																				}
																				var manCnt = tab2
																						.down(
																								'#tab2Form')
																						.getValue(
																								'MAN_CNT');
																				if (Ext
																						.isEmpty(diffTime)
																						|| diffTime == 0) {
																					tab2
																							.down(
																									'#tab2Form')
																							.setValue(
																									'MAN_HOUR',
																									0);
																				} else {
																					tab2
																							.down(
																									'#tab2Form')
																							.setValue(
																									'MAN_HOUR',
																									manCnt
																											* diffTime);
																				}
																			} else {
																				var diffTime = (tab2
																						.down(
																								'#tab2Form')
																						.getValue(
																								'TO_TIME') - tab2
																						.down(
																								'#tab2Form')
																						.getValue(
																								'FR_TIME')) / 60000 / 60;
																				var manCnt = tab2
																						.down(
																								'#tab2Form')
																						.getValue(
																								'MAN_CNT');
																				if (Ext
																						.isEmpty(diffTime)
																						|| diffTime == 0) {
																					tab2
																							.down(
																									'#tab2Form')
																							.setValue(
																									'MAN_HOUR',
																									0);
																				} else {
																					tab2
																							.down(
																									'#tab2Form')
																							.setValue(
																									'MAN_HOUR',
																									manCnt
																											* diffTime);
																				}
																			}
																		}
																	}
																} ]
													},
													//]},
													{
														xtype : 'container',
														layout : {
															type : 'uniTable',
															columns : 3
														},
														defaults : {
															padding : '-3 0 0 0'
														},
														items : [
																{
																	fieldLabel : '<t:message code="system.label.product.workteam" default="작업조"/>',
																	name : 'DAY_NIGHT',
																	xtype : 'uniCombobox',
																	comboType : 'AU',
																	comboCode : 'P507',
																	colspan : 2,
																	listeners : {
																		change : function(
																				field,
																				newValue,
																				oldValue,
																				eOpts) {

																		}
																	}
																},
																{
																	fieldLabel : '<t:message code="system.label.product.worker" default="작업자"/>',
																	name : 'PRODT_PRSN',
																	xtype : 'uniCombobox',
																	comboType : 'AU',
																	margin : '0 0 0 0',
																	comboCode : 'P505',
																	listeners : {
																		change : function(
																				field,
																				newValue,
																				oldValue,
																				eOpts) {

																		}
																	}
																},
																Unilite
																		.popup(
																				'EQU_MACH_CODE',
																				{
																					fieldLabel : '<t:message code="system.label.product.facilities" default="설비"/>',
																					valueFieldName : 'EQUIP_CODE',
																					textFieldName : 'EQUIP_NAME',
																					margin : '0 0 0 0',
																					valueFieldWidth : 100,
																					textFieldWidth : 170,
																					allowBlank : true,
																					listeners : {
																						onSelected : {
																							fn : function(
																									records,
																									type) {
																								tab2
																										.down(
																												'#tab2Form')
																										.setValue(
																												'EQUIP_CODE',
																												records[0]['EQU_MACH_CODE']);
																								tab2
																										.down(
																												'#tab2Form')
																										.setValue(
																												'EQUIP_NAME',
																												records[0]['EQU_MACH_NAME']);
																							},
																							scope : this
																						},
																						onClear : function(
																								type) {

																							tab2
																									.down(
																											'#tab2Form')
																									.setValue(
																											'EQUIP_CODE',
																											'');
																							tab2
																									.down(
																											'#tab2Form')
																									.setValue(
																											'EQUIP_NAME',
																											'');

																						},
																						applyextparam : function(
																								popup) {
																							popup
																									.setExtParam({
																										'DIV_CODE' : panelResult
																												.getValue('DIV_CODE')
																									});
																						}
																					}
																				}) ]
													},
													{
														fieldLabel : '<t:message code="system.label.product.remarks" default="비고"/>',
														name : 'REMARK',
														xtype : 'textareafield',
														margin : '0 0 0 0',
														width : 750,
														height : 70,
														readOnly : false
													} ]
										}

										]
									},
									{
										title : '<t:message code="system.label.product.specialremarkentry" default="특기사항등록"/>',
										xtype : 'container',
										width : 1010,
										height : 480,
										hidden : true,
										layout : {
											type : 'vbox',
											align : 'stretch'
										},
										items : [ masterGrid9 ],
										id : 'pmr101ukrvGrid9_tab2'
									}, {
										title : '자재불량내역',
										xtype : 'container',
										width : 1010,
										height : 480,
										hidden : true,
										layout : {
											type : 'vbox',
											align : 'stretch'
										},
										items : [ masterGrid10 ],
										id : 'pmr101ukrvGrid10_tab2'
									}

							],
							listeners : {
								beforetabchange : function(grouptabPanel,
										newCard, oldCard, eOpts) {
									/* if(!UniAppManager.app.isValidSearchForm()){
										return false;
									}
									if(UniAppManager.app._needSave()) {
										if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
											UniAppManager.app.onSaveDataButtonDown();
											return false;
										}
									} */
								},
								tabChange : function(tabPanel, newCard,
										oldCard, eOpts) {
									//				UniAppManager.setToolbarButtons(['newData', 'delete'], false);
									var newTabId = newCard.getId();
									var record = detailGrid.getSelectedRecord();
									if (!Ext.isEmpty(record)) {
										if (newTabId == 'pmr101ukrvGrid9_tab2') {
											directMasterStore9
													.loadStoreRecords(record);
											Ext.getCmp('resultsAddSetBtn')
													.setDisabled(true);
											//UniAppManager.setToolbarButtons(['newData'], true);
										} else if (newTabId == 'pmr101ukrvGrid10_tab2') {
											var badQtyArray = new Array();
											badQtyArray = gsBadQtyInfo
													.split(',');
											if (directMasterStore10.getCount() == 0) {
												directMasterStore10
														.loadStoreRecords(badQtyArray);
											}
											Ext.getCmp('resultsAddSetBtn')
													.setDisabled(false);
										} else {
											Ext.getCmp('resultsAddSetBtn')
													.setDisabled(false)
										}
									}
								}
							}
						});

		var resultsAddForm = Unilite
				.createSearchForm(
						'resultsAddForm',
						{ // 생산실적 팝업창
							//height:300,
							width : 1120,
							//region		: 'north',
							autoScroll : false,
							border : true,
							padding : '1 1 1 1',
							layout : {
								type : 'uniTable',
								columns : 1,
								tdAttrs : {
									valign : 'top'
								}
							},
							xtype : 'container',
							defaultType : 'container',
							items : [ {
								layout : {
									type : 'uniTable',
									columns : 1,
									tableAttrs : {
										cellpadding : 5
									},
									tdAttrs : {
										valign : 'top'
									}
								},
								defaultType : 'uniFieldset',
								defaults : {
									padding : '0 15 15 15'
								},
								items : [ {
									title : '<t:message code="system.label.product.workorderinfo" default="작업지시정보"/>',
									layout : {
										type : 'uniTable',
										columns : 1
									},
									width : 700,
									margin : '0 0 15 15',
									items : [
											{
												fieldLabel : '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
												xtype : 'uniTextfield',
												name : 'WKORD_NUM',
												holdable : 'hold',
												width : 500,
												readOnly : true,
												margin : '0 0 0 40',
												fieldStyle : 'text-align: center;',
												listeners : {
													change : function(field,
															newValue, oldValue,
															eOpts) {

													}
												}
											},
											{
												fieldLabel : '<t:message code="system.label.product.item" default="품목"/>',
												name : 'ITEM_CODE',
												xtype : 'uniTextfield',
												width : 300,
												readOnly : true,
												margin : '0 0 0 40',
												fieldStyle : 'text-align: center;'

											},
											{
												fieldLabel : '<t:message code="system.label.product.itemname2" default="품명"/>',
												name : 'ITEM_NAME',
												width : 600,
												xtype : 'uniTextfield',
												margin : '0 0 0 40',
												readOnly : true
											},
											{
												xtype : 'container',
												layout : {
													type : 'uniTable',
													columns : 2
												},
												defaults : {
													padding : '-3 0 0 0'
												},
												items : [
														{
															fieldLabel : '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
															name : 'WKORD_Q',
															xtype : 'uniNumberfield',
															margin : '0 0 0 40',
															type : 'uniQty',
															readOnly : true

														},
														{
															fieldLabel : '<t:message code="system.label.product.unit" default="단위"/>',
															name : 'STOCK_UNIT',
															xtype : 'uniTextfield',
															width : 150,
															readOnly : true,
															margin : '0 0 0 40',
															fieldStyle : 'text-align: center;'
														} ]
											} ]
								} ]
							}

							],
							setAllFieldsReadOnly : setAllFieldsReadOnly
						});

		function openResultsAddWindow() { // 생산실적등록 팝업창
			if (!resultsAddWindow) {
				resultsAddWindow = Ext
						.create(
								'widget.uniDetailWindow',
								{
									title : '<t:message code="system.label.product.productionresultentrypopup" default="생산실적"/>',
									width : 1170,
									height : 1000,
									modal : true,
									tabDirection : 'left-right',
									resizable : true,
									layout : 'border',

									items : [
											{
												layout : {
													type : 'hbox',
													align : 'stretch'
												},
												xtype : 'container',
												region : 'north',
												tdAttrs : {
													align : 'left'
												},
												defaults : {
													holdable : 'hold'
												},
												margin : '0 0 2 0',
												items : [
														resultsAddForm,
														{
															layout : {
																type : 'uniTable',
																columns : 1,
																tableAttrs : {
																	cellpadding : 5
																},
																tdAttrs : {
																	valign : 'top'
																}
															},
															xtype : 'panel',
															//margin		: '0 0 0 0',
															collapsed : true,
															collapsible : true,
															//region		: 'north',
															height : 190,
															collapseDirection : 'left',
															border : false,
															defaults : {
																padding : '7 12 12 12'
															},
															items : [ {
																xtype : 'uniFieldset',
																layout : {
																	type : 'table',
																	columns : 3,
																	tableAttrs : {
																		style : 'margin-top:0px !important'
																	}
																},
																defaults : {
																	xtype : 'button',
																	margin : '2 2 2 2 '
																},
																width : 190,
																//height: 250,
																items : [
																		{
																			text : '7',
																			width : 50,
																			margin : '0 2 2 2',
																			handler : function(
																					btn) {
																				inputFields(btn.text);
																			}
																		},
																		{
																			text : '8',
																			width : 50,
																			margin : '0 2 2 2',
																			handler : function(
																					btn) {
																				treatCalcArea(btn.text);
																			}
																		},
																		{
																			text : '9',
																			width : 50,
																			margin : '0 2 2 2',
																			handler : function(
																					btn) {
																				treatCalcArea(btn.text);
																			}
																		},
																		{
																			text : '4',
																			width : 50,
																			handler : function(
																					btn) {
																				treatCalcArea(btn.text);
																			}
																		},
																		{
																			text : '5',
																			width : 50,
																			handler : function(
																					btn) {
																				treatCalcArea(btn.text);
																			}
																		},
																		{
																			text : '6',
																			width : 50,
																			handler : function(
																					btn) {
																				treatCalcArea(btn.text);
																			}
																		},
																		{
																			text : '1',
																			width : 50,
																			handler : function(
																					btn) {
																				treatCalcArea(btn.text);
																			}
																		},
																		{
																			text : '2',
																			width : 50,
																			handler : function(
																					btn) {
																				treatCalcArea(btn.text);
																			}
																		},
																		{
																			text : '3',
																			width : 50,
																			handler : function(
																					btn) {
																				treatCalcArea(btn.text);
																			}
																		},
																		{
																			text : '←',
																			colspan : 2,
																			width : 105,
																			handler : function(
																					btn) {
																				treatCalcArea('delete');
																			}
																		},
																		{
																			text : '0',
																			width : 50,
																			handler : function(
																					btn) {
																				treatCalcArea(btn.text);
																			}
																		},
																		{
																			text : '.',
																			width : 50,
																			handler : function(
																					btn) {
																				treatCalcArea(btn.text);
																			}
																		},
																		{
																			text : 'CLEAR',
																			colspan : 2,
																			width : 108,
																			handler : function(
																					btn) {
																				treatCalcArea('delete all');
																			}
																		} ]
															} ],
															listeners : {
																collapse : function() {
																	//resultsAddForm.setWidth(1120);
																},
																expand : function() {
																	//resultsAddForm.setWidth(950);
																}
															}
														}

												]
											}

											, tab2

									],
									tbar : [
											'->',
											{
												id : 'resultsAddSetBtn',
												width : 100,
												text : '<t:message code="system.label.product.save" default="저장"/>',
												handler : function() {
													if (Ext
															.isEmpty(tab2
																	.down(
																			'#tab2Form')
																	.getValue(
																			'WORK_Q'))
															|| tab2
																	.down(
																			'#tab2Form')
																	.getValue(
																			'WORK_Q') == 0) {
														tab2
																.setActiveTab('pmr101ukrvGrid9_tab1');
													}
													if (!UniAppManager.app
															.checkForNewDetail())
														return false;
													if (Ext
															.isEmpty(tab2
																	.down(
																			'#tab2Form')
																	.getValue(
																			'WORK_Q'))
															|| tab2
																	.down(
																			'#tab2Form')
																	.getValue(
																			'WORK_Q') == 0) {
														alert('생산량은(는) '
																+ Msg.sMB083);
														tab2
																.down(
																		'#tab2Form')
																.getField(
																		'WORK_Q')
																.focus();
														tab2
																.setActiveTab('pmr101ukrvGrid9_tab1');
														return false;
													}
													if (tab2
															.down('#tab2Form')
															.getValue(
																	'GOOD_WORK_Q') < 0) {
														alert('<t:message code="system.message.product.datacheck010" default="양품량은 0보다 큰 값이 입력되어야 합니다."/>');
														tab2
																.down(
																		'#tab2Form')
																.getField(
																		'GOOD_WORK_Q')
																.focus();
														return false;
													}
													var progWorkNameRecord = masterGrid3
															.getSelectedRecord();
													progWorkNameRecord
															.set(
																	'PRODT_DATE',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'PRODT_DATE')); //생산일
													gsProdtDate1 = UniDate
															.getDbDateStr(tab2
																	.down(
																			'#tab2Form')
																	.getValue(
																			'PRODT_DATE'));
													progWorkNameRecord
															.set(
																	'WORK_Q',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'WORK_Q')); //생산량

													progWorkNameRecord
															.set(
																	'GOOD_WORK_Q',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'GOOD_WORK_Q'));//양품량
													progWorkNameRecord
															.set(
																	'PASS_Q',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'GOOD_WORK_Q'));//양품량
													progWorkNameRecord
															.set(
																	'BAD_WORK_Q',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'BAD_WORK_Q'));//불량수량

													progWorkNameRecord
															.set(
																	'LOT_NO',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'LOT_NO'));//LOT_NO
													progWorkNameRecord
															.set(
																	'FR_SERIAL_NO',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'FR_SERIAL_NO'));//시리얼번호fr
													progWorkNameRecord
															.set(
																	'TO_SERIAL_NO',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'TO_SERIAL_NO'));//시리얼번호to
													progWorkNameRecord
															.set(
																	'FR_TIME',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'FR_TIME'));//시작시간
													progWorkNameRecord
															.set(
																	'TO_TIME',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'TO_TIME'));//종료시간
													progWorkNameRecord
															.set(
																	'MAN_HOUR',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'MAN_HOUR'));//투입공수
													progWorkNameRecord
															.set(
																	'DAY_NIGHT',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'DAY_NIGHT'));//작업조
													progWorkNameRecord
															.set(
																	'REMARK',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'REMARK'));//비고
													progWorkNameRecord
															.set(
																	'PRODT_PRSN',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'PRODT_PRSN'));//작업자
													progWorkNameRecord
															.set(
																	'EQUIP_CODE',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'EQUIP_CODE'));//설비코드
													progWorkNameRecord
															.set(
																	'EQUIP_NAME',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'EQUIP_NAME'));//설비코드

													//						progWorkNameRecord.set('BOX_TRNS_RATE', tab2.down('#tab2Form').getValue('BOX_TRNS_RATE'));//BOX입수
													//						progWorkNameRecord.set('BOX_Q', tab2.down('#tab2Form').getValue('BOX_Q'));// BOX수
													//						progWorkNameRecord.set('SAVING_Q', tab2.down('#tab2Form').getValue('SAVING_Q'));//관리수량
													progWorkNameRecord
															.set(
																	'MAN_CNT',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'MAN_CNT'));//작업인원
													//progWorkNameRecord.set('HAZARD_CHECK', tab2.down('#tab2Form').getValue('HAZARD_CHECK'));//유해물질검사요청
													//progWorkNameRecord.set('MICROBE_CHECK', tab2.down('#tab2Form').getValue('MICROBE_CHECK'));//미생물검사요청
													//						progWorkNameRecord.set('PIECE', tab2.down('#tab2Form').getValue('PIECE'));//낱개
													//						progWorkNameRecord.set('EXPIRATION_DATE', tab2.down('#tab2Form').getValue('EXPIRATION_DATE'));//유효기한
													//progWorkNameRecord.set('YIELD', tab2.down('#tab2Form').getValue('YIELD'));//수율
													//						progWorkNameRecord.set('LOSS_Q', tab2.down('#tab2Form').getValue('LOSS_Q'));//로스
													//						progWorkNameRecord.set('ETC_Q', tab2.down('#tab2Form').getValue('ETC_Q'));//기타수량

													progWorkNameRecord
															.set(
																	'REMARK',
																	tab2
																			.down(
																					'#tab2Form')
																			.getValue(
																					'REMARK'));//비고

													tab2.down('#tab2Form')
															.clearForm();
													resultsAddWindow.hide();
													UniAppManager.app
															.onSaveDataButtonDown();
												},
												disabled : false
											},
											{
												id : 'resultsAddCloseBtn',
												width : 100,
												text : '<t:message code="system.label.product.cancel" default="취소"/>',
												handler : function() {
													tab2
															.down('#tab2Form')
															.getField('WORK_Q')
															.setConfig(
																	'allowBlank',
																	true);
													tab2
															.down('#tab2Form')
															.getField(
																	'GOOD_WORK_Q')
															.focus();
													tab2.down('#tab2Form')
															.getField('WORK_Q')
															.focus();
													tab2.down('#tab2Form')
															.clearForm();

													resultsAddWindow.hide();
													masterGrid10.reset();
													directMasterStore10
															.commitChanges();

												},
												disabled : false
											} ],
									listeners : {
										beforehide : function(me, eOpt) {
											panelResult.getField('WKORD_NUM')
													.focus();
										},
										beforeclose : function(panel, eOpts) {
											panelResult.getField('WKORD_NUM')
													.focus();
										},
										beforeshow : function(panel, eOpts) {
											tab2.down('#tab2Form')
													.setScrollable(false);
											var detailRecord = detailGrid
													.getSelectedRecord();
											var progWorkNameRecord = masterGrid3
													.getSelectedRecord();
											resultsAddForm.setValue(
													'WKORD_NUM', detailRecord
															.get('WKORD_NUM'));
											resultsAddForm.setValue(
													'ITEM_CODE', detailRecord
															.get('ITEM_CODE'));
											resultsAddForm.setValue(
													'ITEM_NAME', detailRecord
															.get('ITEM_NAME'));
											resultsAddForm
													.setValue(
															'WKORD_Q',
															detailRecord
																	.get('WKORD_Q'));
											resultsAddForm.setValue(
													'STOCK_UNIT', detailRecord
															.get('STOCK_UNIT'));
											tab2
													.down('#tab2Form')
													.setValue(
															'PROG_WORK_NAME',
															progWorkNameRecord
																	.get('PROG_WORK_NAME'));
											tab2
													.down('#tab2Form')
													.setValue(
															'WKORD_Q2',
															progWorkNameRecord
																	.get('PROG_WKORD_Q'));
											tab2.down('#tab2Form').setValue(
													'STOCK_UNIT2',
													progWorkNameRecord
															.get('PROG_UNIT'));
											tab2
													.down('#tab2Form')
													.setValue(
															'PASS_Q',
															progWorkNameRecord
																	.get('GOOD_WORK_Q'));
											tab2.down('#tab2Form').setValue(
													'JAN_Q',
													progWorkNameRecord
															.get('JAN_Q'));
											tab2.down('#tab2Form').setValue(
													'SUM_Q',
													progWorkNameRecord
															.get('SUM_Q'));
											tab2.down('#tab2Form').setValue(
													'LOT_NO',
													progWorkNameRecord
															.get('LOT_NO'));
											tab2.down('#tab2Form').setValue(
													'EQUIP_CODE',
													progWorkNameRecord
															.get('EQUIP_CODE'));
											tab2.down('#tab2Form').setValue(
													'EQUIP_NAME',
													progWorkNameRecord
															.get('EQUIP_NAME'));
											tab2.down('#tab2Form').setValue(
													'PRODT_DATE',
													progWorkNameRecord
															.get('PRODT_DATE'));

											if (progWorkNameRecord
													.get('WORK_Q') != 0
													&& !Ext
															.isEmpty(progWorkNameRecord
																	.get('WORK_Q'))) {

												tab2
														.down('#tab2Form')
														.setValue(
																'WORK_Q',
																progWorkNameRecord
																		.get('WORK_Q'));
												tab2
														.down('#tab2Form')
														.setValue(
																'GOOD_WORK_Q',
																progWorkNameRecord
																		.get('GOOD_WORK_Q'));
												tab2
														.down('#tab2Form')
														.setValue(
																'PASS_Q',
																progWorkNameRecord
																		.get('GOOD_WORK_Q'));
												tab2
														.down('#tab2Form')
														.setValue(
																'BAD_WORK_Q',
																progWorkNameRecord
																		.get('BAD_WORK_Q'));
											}

											tab2.down('#tab2Form').setValue(
													'DAY_NIGHT',
													progWorkNameRecord
															.get('DAY_NIGHT'));
											if (!Ext.isEmpty(progWorkNameRecord
													.get('FR_TIME'))) {
												tab2
														.down('#tab2Form')
														.setValue(
																'FR_TIME',
																progWorkNameRecord
																		.get('FR_TIME'));
											}
											if (!Ext.isEmpty(progWorkNameRecord
													.get('TO_TIME'))) {
												tab2
														.down('#tab2Form')
														.setValue(
																'TO_TIME',
																progWorkNameRecord
																		.get('TO_TIME'));
											}
											tab2
													.down('#tab2Form')
													.setValue(
															'FR_SERIAL_NO',
															progWorkNameRecord
																	.get('FR_SERIAL_NO'));
											tab2
													.down('#tab2Form')
													.setValue(
															'TO_SERIAL_NO',
															progWorkNameRecord
																	.get('TO_SERIAL_NO'));
											tab2
													.down('#tab2Form')
													.setValue(
															'EXPIRATION_DATE',
															progWorkNameRecord
																	.get('EXPIRATION_DATE'));

											if (Ext.isEmpty(progWorkNameRecord
													.get('BOX_TRNS_RATE'))
													|| progWorkNameRecord
															.get('BOX_TRNS_RATE') == 0) {
												tab2
														.down('#tab2Form')
														.setValue(
																'BOX_TRNS_RATE',
																'');
											} else {
												tab2
														.down('#tab2Form')
														.setValue(
																'BOX_TRNS_RATE',
																progWorkNameRecord
																		.get('BOX_TRNS_RATE'));
											}

											if (!Ext.isEmpty(progWorkNameRecord
													.get('BOX_Q'))
													&& progWorkNameRecord
															.get('BOX_Q') != 0) {
												tab2
														.down('#tab2Form')
														.setValue(
																'BOX_Q',
																progWorkNameRecord
																		.get('BOX_Q'));
											}

											if (!Ext.isEmpty(progWorkNameRecord
													.get('PIECE'))
													&& progWorkNameRecord
															.get('PIECE') != 0) {
												tab2
														.down('#tab2Form')
														.setValue(
																'PIECE',
																progWorkNameRecord
																		.get('PIECE'));
											}

											if (!Ext.isEmpty(progWorkNameRecord
													.get('SAVING_Q'))
													&& progWorkNameRecord
															.get('SAVING_Q') != 0) {
												tab2
														.down('#tab2Form')
														.setValue(
																'SAVING_Q',
																progWorkNameRecord
																		.get('SAVING_Q'));
											}

											if (!Ext.isEmpty(progWorkNameRecord
													.get('MAN_CNT'))
													&& progWorkNameRecord
															.get('MAN_CNT') != 0) {
												tab2
														.down('#tab2Form')
														.setValue(
																'MAN_CNT',
																progWorkNameRecord
																		.get('MAN_CNT'));
											}

											if (!Ext.isEmpty(progWorkNameRecord
													.get('MAN_HOUR'))
													&& progWorkNameRecord
															.get('MAN_HOUR') != 0) {
												tab2
														.down('#tab2Form')
														.setValue(
																'MAN_HOUR',
																progWorkNameRecord
																		.get('MAN_HOUR'));
											}
											if (Ext.isEmpty(progWorkNameRecord
													.get('YIELD'))
													|| progWorkNameRecord
															.get('YIELD') == 0) {
												tab2.down('#tab2Form')
														.setValue('YIELD', '');
											} else {
												tab2
														.down('#tab2Form')
														.setValue(
																'YIELD',
																progWorkNameRecord
																		.get('YIELD'));
											}
											if (Ext.isEmpty(progWorkNameRecord
													.get('ETC_Q'))
													|| progWorkNameRecord
															.get('ETC_Q') == 0) {
												tab2.down('#tab2Form')
														.setValue('ETC_Q', '');
											} else {
												tab2
														.down('#tab2Form')
														.setValue(
																'ETC_Q',
																progWorkNameRecord
																		.get('ETC_Q'));
											}
											tab2
													.down('#tab2Form')
													.setValue(
															'HAZARD_CHECK',
															progWorkNameRecord
																	.get('HAZARD_CHECK'));
											tab2
													.down('#tab2Form')
													.setValue(
															'MICROBE_CHECK',
															progWorkNameRecord
																	.get('MICROBE_CHECK'));
											tab2.down('#tab2Form').setValue(
													'LUNCH_CHK',
													progWorkNameRecord
															.get('LUNCH_CHK'));

											tab2.down('#tab2Form').setValue(
													'REMARK',
													progWorkNameRecord
															.get('REMARK'));

											fn_expirationDateCal();//공적인 최종 공정이고, 내용물인 경우 유효기한 자동세팅

											tab2.down('#tab2Form').getField(
													'GOOD_WORK_Q').setReadOnly(
													false);
											tab2.down('#tab2Form').getField(
													'LUNCH_CHK').focus();
											tab2.down('#tab2Form').getField(
													'WORK_Q').focus();
											masterGrid10.reset();
											directMasterStore10.commitChanges();
											tab2
													.setActiveTab('pmr101ukrvGrid9_tab1');
											gsPopupChk = 'WKORD';

										},
										show : function(panel, eOpts) {
											setTimeout(function() {
												//	resultsAddForm.getField('WORK_Q').focus();
												/*	var zIndexManager = new Ext.ZIndexManager;
													zIndexManager.register(keyPadWindow);
													zIndexManager.register(resultsAddWindow);
													zIndexManager.sendToBack(resultsAddWindow);
													zIndexManager.bringToFront(keyPadWindow);*/
											}, 50);
										}
									}
								})
			}
			resultsAddWindow.center();
			resultsAddWindow.show();
		}

		/******************************************
		 *20190709 작업실적 특기사항, 자재불량내역, 비고 수정 팝업 추가
		 ******************************************/
		var tab3 = Unilite
				.createTabPanel(
						'tabPanel3',
						{
							split : false,
							border : true,
							activeTab : 0,
							margin : '-20 0 0 0',
							region : 'center',
							items : [
									{
										layout : {
											type : 'vbox',
											align : 'stretch'
										},
										title : '<t:message code="system.label.product.productionresultentryupdate" default="생산실적수정"/>',
										xtype : 'container',
										height : 300,
										layout : {
											type : 'uniTable',
											columns : 1
										},
										id : 'pmr101ukrvResult_tab1',
										items : [
												{
													fieldLabel : '작업인원',
													name : 'MAN_CNT',
													margin : '13 0 0 0',
													xtype : 'uniNumberfield',
													suffixTpl : '&nbsp;명',
													decimalPrecision : 1,
													width : 250,
													readOnly : false,
													listeners : {
														change : function(
																field,
																newValue,
																oldValue, eOpts) {
															if (!Ext
																	.isEmpty(UniDate
																			.getHHMI(resultsUpdateForm
																					.getValue('FR_TIME')))
																	&& !Ext
																			.isEmpty(UniDate
																					.getHHMI(resultsUpdateForm
																							.getValue('TO_TIME')))) {

																var diffTime = (resultsUpdateForm
																		.getValue('TO_TIME') - resultsUpdateForm
																		.getValue('FR_TIME')) / 60000 / 60;
																var manCnt = newValue;
																if (Ext
																		.isEmpty(diffTime)
																		|| diffTime == 0) {
																	resultsUpdateForm
																			.setValue(
																					'MAN_HOUR',
																					0);
																} else {
																	if (resultsUpdateForm
																			.getValue('LUNCH_CHK') == true) {
																		if (resultsUpdateForm
																				.getValue('TO_TIME') >= panelResult
																				.getValue('GS_TO_TIME')) {
																			diffTime = diffTime - 1
																		}
																	}
																	resultsUpdateForm
																			.setValue(
																					'MAN_HOUR',
																					manCnt
																							* diffTime);
																}

															}
														}
													}
												},
												{ //yunsun
													fieldLabel : '생산일자',
													name : 'PRODT_DATE',
													margin : '13 0 0 0',
													xtype : 'uniDatefield',
													//value: UniDate.get('today'),
													decimalPrecision : 1,
													width : 250,
													readOnly : false,

													listeners: {
														change: function(field, newValue, oldValue, eOpts) {
															resultsUpdateForm.setValue('PRODT_DATE', newValue);
														}
													}

												},
												{
													fieldLabel : '생산량',
													name : 'WORK_Q',
													margin : '13 0 0 0',
													xtype : 'uniNumberfield',
													decimalPrecision : 0,
													width : 250,
													readOnly : false,
													listeners : {
														change: function(field, newValue, oldValue, eOpts) {
															resultsUpdateForm.setValue('WORK_Q', newValue);
														}
													}
												},
												{
													xtype : 'container',
													layout : {
														type : 'uniTable',
														columns : 4
													},
													defaults : {
														padding : '0 0 0 0'
													},
													items : [
															{
																fieldLabel : '<t:message code="system.label.product.workhour" default="작업시간"/>',
																name : 'FR_TIME',
																xtype : 'timefield',
																format : 'H:i',
																increment : 10,
																width : 170,
																readOnly : false,
																fieldStyle : 'text-align: center;',
																listeners : {
																	change : function(
																			field,
																			newValue,
																			oldValue,
																			eOpts) {

																	},
																	blur : function(
																			field,
																			event,
																			eOpts) {
																		if (!Ext
																				.isEmpty(UniDate
																						.getHHMI(resultsUpdateForm
																								.getValue('TO_TIME')))) {
																			if (UniDate
																					.getHHMI(field.lastValue) > UniDate
																					.getHHMI(resultsUpdateForm
																							.getValue('TO_TIME'))) {
																				alert('작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.');
																				resultsUpdateForm
																						.setValue(
																								'FR_TIME',
																								field.originalValue);
																				return false;
																			}
																			var diffTime = (resultsUpdateForm
																					.getValue('TO_TIME') - field.lastValue) / 60000 / 60;
																			var manCnt = resultsUpdateForm
																					.getValue('MAN_CNT');
																			if (Ext
																					.isEmpty(diffTime)
																					|| diffTime == 0) {
																				resultsUpdateForm
																						.setValue(
																								'MAN_HOUR',
																								0);
																			} else {
																				if (resultsUpdateForm
																						.getValue('LUNCH_CHK') == true) {
																					if ((resultsUpdateForm
																							.getValue('TO_TIME') >= panelResult
																							.getValue('GS_TO_TIME'))
																							&& (field.lastValue <= panelResult
																									.getValue('GS_FR_TIME'))) {
																						diffTime = diffTime - 1
																					}
																				}
																				resultsUpdateForm
																						.setValue(
																								'MAN_HOUR',
																								manCnt
																										* diffTime);
																			}
																			field.originalValue = field.lastValue;
																		}

																	}
																}
															},
															{
																xtype : 'component',
																html : '~',
																style : {
																	marginTop : '3px !important',
																	font : '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
																}
															},
															{
																fieldLabel : '',
																name : 'TO_TIME',
																xtype : 'timefield',
																format : 'H:i',
																increment : 10,
																width : 85,
																readOnly : false,
																fieldStyle : 'text-align: center;',
																listeners : {
																	change : function(
																			field,
																			newValue,
																			oldValue,
																			eOpts) {

																	},
																	blur : function(
																			field,
																			event,
																			eOpts) {
																		if (!Ext
																				.isEmpty(UniDate
																						.getHHMI(resultsUpdateForm
																								.getValue('FR_TIME')))) {
																			if (UniDate
																					.getHHMI(resultsUpdateForm
																							.getValue('FR_TIME')) > UniDate
																					.getHHMI(field.lastValue)) {
																				alert('작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.');
																				resultsUpdateForm
																						.setValue(
																								'TO_TIME',
																								field.originalValue);
																				return false;
																			}
																			/* 	if(Ext.isEmpty(resultsUpdateForm.getValue('MAN_CNT')) || resultsUpdateForm.getValue('MAN_CNT') == 0){
																					alert('작업인원을 입력해주세요.');
																					resultsUpdateForm.setValue('TO_TIME', UniDate.getHHMI(field.originalValue));
																					resultsUpdateForm.getField('MAN_CNT').focus();
																					return false;
																				} */
																			var diffTime = (field.lastValue - resultsUpdateForm
																					.getValue('FR_TIME')) / 60000 / 60;
																			var manCnt = resultsUpdateForm
																					.getValue('MAN_CNT');
																			if (Ext
																					.isEmpty(diffTime)
																					|| diffTime == 0) {
																				resultsUpdateForm
																						.setValue(
																								'MAN_HOUR',
																								0);
																			} else {
																				if (resultsUpdateForm
																						.getValue('LUNCH_CHK') == true) {
																					if ((field.lastValue >= panelResult
																							.getValue('GS_TO_TIME'))
																							&& (resultsUpdateForm
																									.getValue('FR_TIME') <= panelResult
																									.getValue('GS_FR_TIME'))) {
																						diffTime = diffTime - 1;
																					}
																				}
																				resultsUpdateForm
																						.setValue(
																								'MAN_HOUR',
																								manCnt
																										* diffTime);
																			}
																			field.originalValue = field.lastValue;
																		}

																	}
																}
															},
															{
																xtype : 'uniCheckboxgroup',
																fieldLabel : '점심시간 제외',
																labelWidth : 100,
																id : 'LUNCH_CHK2',
																items : [ {
																	boxLabel : '',
																	width : 100,
																	name : 'LUNCH_CHK',
																	checked : true,
																	inputValue : 'Y'
																} ],
																listeners : {
																	change : function(
																			field,
																			newValue,
																			oldValue,
																			eOpts) {
																		if (newValue.LUNCH_CHK == 'Y') {
																			var diffTime = (resultsUpdateForm
																					.getValue('TO_TIME') - resultsUpdateForm
																					.getValue('FR_TIME')) / 60000 / 60;
																			if ((resultsUpdateForm
																					.getValue('TO_TIME') >= panelResult
																					.getValue('GS_TO_TIME'))
																					&& (resultsUpdateForm
																							.getValue('FR_TIME') <= panelResult
																							.getValue('GS_FR_TIME'))) {
																				diffTime = diffTime - 1;
																			}
																			var manCnt = resultsUpdateForm
																					.getValue('MAN_CNT');
																			if (Ext
																					.isEmpty(diffTime)
																					|| diffTime == 0) {
																				resultsUpdateForm
																						.setValue(
																								'MAN_HOUR',
																								0);
																			} else {
																				resultsUpdateForm
																						.setValue(
																								'MAN_HOUR',
																								manCnt
																										* diffTime);
																			}
																		} else {
																			var diffTime = (resultsUpdateForm
																					.getValue('TO_TIME') - resultsUpdateForm
																					.getValue('FR_TIME')) / 60000 / 60;
																			var manCnt = resultsUpdateForm
																					.getValue('MAN_CNT');
																			if (Ext
																					.isEmpty(diffTime)
																					|| diffTime == 0) {
																				resultsUpdateForm
																						.setValue(
																								'MAN_HOUR',
																								0);
																			} else {
																				resultsUpdateForm
																						.setValue(
																								'MAN_HOUR',
																								manCnt
																										* diffTime);
																			}
																		}
																	}
																}
															} ]
												},
												{
													xtype : 'container',
													layout : {
														type : 'uniTable',
														columns : 3
													},
													defaults : {
														padding : '-3 0 0 0'
													},
													items : [
															{
																fieldLabel : '<t:message code="system.label.product.inputtime" default="투입공수"/>',
																name : 'MAN_HOUR',
																xtype : 'uniNumberfield',
																suffixTpl : '&nbsp;M/H',
																// type:'uniQty',
																decimalPrecision : 1,
																readOnly : false
															},
															{
																fieldLabel : '<t:message code="system.label.product.workteam" default="작업조"/>',
																name : 'DAY_NIGHT',
																xtype : 'uniCombobox',
																comboType : 'AU',
																comboCode : 'P507',
																colspan : 2,
																listeners : {
																	change : function(
																			field,
																			newValue,
																			oldValue,
																			eOpts) {

																	}
																}
															},
															{
																fieldLabel : '<t:message code="system.label.product.worker" default="작업자"/>',
																name : 'PRODT_PRSN',
																xtype : 'uniCombobox',
																comboType : 'AU',
																margin : '7 0 0 0',
																comboCode : 'P505',
																listeners : {
																	change : function(
																			field,
																			newValue,
																			oldValue,
																			eOpts) {

																	}
																}
															},
															Unilite
																	.popup(
																			'EQU_MACH_CODE',
																			{
																				fieldLabel : '<t:message code="system.label.product.facilities" default="설비"/>',
																				valueFieldName : 'EQUIP_CODE',
																				textFieldName : 'EQUIP_NAME',
																				margin : '5 0 0 0',
																				valueFieldWidth : 100,
																				textFieldWidth : 170,
																				allowBlank : true,
																				listeners : {
																					onSelected : {
																						fn : function(
																								records,
																								type) {
																							resultsUpdateForm
																									.setValue(
																											'EQUIP_CODE',
																											records[0]['EQU_MACH_CODE']);
																							resultsUpdateForm
																									.setValue(
																											'EQUIP_NAME',
																											records[0]['EQU_MACH_NAME']);
																						},
																						scope : this
																					},
																					onClear : function(
																							type) {

																						resultsUpdateForm
																								.setValue(
																										'EQUIP_CODE',
																										'');
																						resultsUpdateForm
																								.setValue(
																										'EQUIP_NAME',
																										'');

																					},
																					applyextparam : function(
																							popup) {
																						popup
																								.setExtParam({
																									'DIV_CODE' : panelResult
																											.getValue('DIV_CODE')
																								});
																					}
																				}
																			}) ]
												},

												{
													fieldLabel : '<t:message code="system.label.product.productionresult" default="생산실적"/><t:message code="system.label.product.remarks" default="비고"/> ',
													name : 'REMARK',
													xtype : 'textareafield',
													margin : '5 100 0 0',
													width : 750,
													height : 150,
													readOnly : false
												} ]
									},
									{
										title : '<t:message code="system.label.product.specialremarkentry" default="특기사항등록"/>',
										xtype : 'container',
										width : 1010,
										hidden : true,
										height : 480,
										layout : {
											type : 'vbox',
											align : 'stretch'
										},
										items : [ masterGrid11 ],
										id : 'pmr101ukrvResult_tab2'
									}, {
										title : '자재불량내역',
										xtype : 'container',
										width : 1010,
										hidden : true,
										height : 480,
										layout : {
											type : 'vbox',
											align : 'stretch'
										},
										items : [ masterGrid12 ],
										id : 'pmr101ukrvResult_tab3'
									} ],
							listeners : {
								beforetabchange : function(grouptabPanel,
										newCard, oldCard, eOpts) {
									/* if(!UniAppManager.app.isValidSearchForm()){
										return false;
									}
									if(UniAppManager.app._needSave()) {
										if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
											UniAppManager.app.onSaveDataButtonDown();
											return false;
										}
									} */
								},
								tabChange : function(tabPanel, newCard,
										oldCard, eOpts) {
									//					UniAppManager.setToolbarButtons(['newData', 'delete'], false);
									var newTabId = newCard.getId();
									var record = detailGrid.getSelectedRecord();
									if (!Ext.isEmpty(record)) {
										if (newTabId == 'pmr101ukrvResult_tab2') {
											directMasterStore9
													.loadStoreRecords(record);
											Ext.getCmp('resultsUpdateSetBtn')
													.setDisabled(true);
											//UniAppManager.setToolbarButtons(['newData'], true);
										} else if (newTabId == 'pmr101ukrvResult_tab3') {
											var badQtyArray = new Array();
											badQtyArray = gsBadQtyInfo
													.split(',');
											if (directMasterStore10.getCount() == 0) {
												directMasterStore10
														.loadStoreRecords(badQtyArray);
											}
											Ext.getCmp('resultsUpdateSetBtn')
													.setDisabled(false);
										} else {
											Ext.getCmp('resultsUpdateSetBtn')
													.setDisabled(false)
										}
									}
								}
							}
						});

		var resultsUpdateForm = Unilite
				.createSearchForm(
						'resultsUpdateForm',
						{ // 생산실적 팝업창
							layout : {
								type : 'uniTable',
								columns : 3
							},
							height : 800,
							width : 1110,
							region : 'center',
							autoScroll : false,
							border : true,
							padding : '1 1 1 1',
							layout : {
								type : 'uniTable',
								columns : 1,
								tdAttrs : {
									valign : 'top'
								}
							},
							xtype : 'container',
							defaultType : 'container',
							items : [ {
								layout : {
									type : 'uniTable',
									columns : 1,
									tableAttrs : {
										cellpadding : 5
									},
									tdAttrs : {
										valign : 'top'
									}
								},
								defaultType : 'uniFieldset',
								defaults : {
									padding : '10 15 15 15'
								},
								items : [
										{
											title : '<t:message code="system.label.product.workorderinfo" default="작업지시정보"/>',
											layout : {
												type : 'uniTable',
												columns : 1
											},
											margin : '10 0 15 15',
											width : 1010,
											items : [
													{
														fieldLabel : '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
														xtype : 'uniTextfield',
														name : 'WKORD_NUM',
														holdable : 'hold',
														width : 300,
														readOnly : true,
														margin : '0 0 0 40',
														fieldStyle : 'text-align: center;',
														listeners : {
															change : function(
																	field,
																	newValue,
																	oldValue,
																	eOpts) {

															}
														}
													},
													{
														fieldLabel : '<t:message code="system.label.product.item" default="품목"/>',
														name : 'ITEM_CODE',
														xtype : 'uniTextfield',
														width : 300,
														readOnly : true,
														margin : '0 0 0 40',
														fieldStyle : 'text-align: center;'

													},
													{
														fieldLabel : '<t:message code="system.label.product.itemname2" default="품명"/>',
														name : 'ITEM_NAME',
														width : 600,
														xtype : 'uniTextfield',
														margin : '0 0 0 40',
														readOnly : true
													},
													{
														xtype : 'container',
														layout : {
															type : 'uniTable',
															columns : 2
														},
														defaults : {
															padding : '-3 0 0 0'
														},
														items : [
																{
																	fieldLabel : '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
																	name : 'WKORD_Q',
																	xtype : 'uniNumberfield',
																	margin : '0 0 0 40',
																	type : 'uniQty',
																	readOnly : true

																},
																{
																	fieldLabel : '<t:message code="system.label.product.unit" default="단위"/>',
																	name : 'STOCK_UNIT',
																	xtype : 'uniTextfield',
																	width : 150,
																	readOnly : true,
																	margin : '0 0 0 40',
																	fieldStyle : 'text-align: center;'
																} ]
													},
													{
														fieldLabel : 'PRODT_NUM',
														name : 'PRODT_NUM',
														xtype : 'uniTextfield',
														width : 300,
														readOnly : true,
														hidden : true,
														margin : '0 0 0 40',
														fieldStyle : 'text-align: center;'

													} ]
										}, tab3 ]
							} ],
							setAllFieldsReadOnly : setAllFieldsReadOnly
						});

		function openResultsUpdateWindow() { // 생산실적수정 팝업창
			if (!resultsUpdateWindow) {
				resultsUpdateWindow = Ext
						.create(
								'widget.uniDetailWindow',
								{
									title : '<t:message code="system.label.product.productionresultentryupdatepopup" default="생산실적수정팝업"/>',
									width : 1070,
									height : 790,
									tabDirection : 'left-right',
									resizable : true,
									layout : {
										type : 'vbox',
										align : 'stretch'
									},
									items : [ resultsUpdateForm ],
									tbar : [
											'->',
											{
												id : 'resultsUpdateSetBtn',
												width : 100,
												text : '<t:message code="system.label.product.save" default="저장"/>',
												handler : function() {
													//if(!UniAppManager.app.checkForNewDetail()) return false;
													var activeTabId = tab3
															.getActiveTab()
															.getId()
													if (activeTabId == 'pmr101ukrvResult_tab1') {
														var param = {
															PRODT_NUM : resultsUpdateForm
																	.getValue('PRODT_NUM'),
															DIV_CODE : masterForm
																	.getValue('DIV_CODE'),
															REMARK : resultsUpdateForm
																	.getValue('REMARK'),
															MAN_CNT : resultsUpdateForm
																	.getValue('MAN_CNT'),
															FR_TIME : resultsUpdateForm
																	.getField(
																			'FR_TIME')
																	.getSubmitValue(),
															TO_TIME : resultsUpdateForm
																	.getField(
																			'TO_TIME')
																	.getSubmitValue(),
															MAN_HOUR : resultsUpdateForm
																	.getValue('MAN_HOUR'),
															DAY_NIGHT : resultsUpdateForm
																	.getValue('DAY_NIGHT'),
															PRODT_PRSN : resultsUpdateForm
																	.getValue('PRODT_PRSN'),
															EQUIP_CODE : resultsUpdateForm
																	.getValue('EQUIP_CODE'),
															PRODT_DATE : UniDate.getDbDateStr(resultsUpdateForm
																	.getValue('PRODT_DATE')),
															WORK_Q : resultsUpdateForm
															.getValue('WORK_Q')


														}
														pmr101ukrvService
																.updateProductionResultRemark(
																		param,
																		function(
																				provider,
																				response) {
																			if (provider) {
																				UniAppManager
																						.updateStatus('<t:message code="system.message.product.message064" default="저장되었습니다."/>');
																				var records = masterGrid3
																						.getSelectedRecord();
																				directMasterStore4
																						.loadStoreRecords(records);
																			}
																		})
														/* 									resultsUpdateForm.clearForm();
																							resultsUpdateWindow.hide();
																							masterGrid12.reset();
																							directMasterStore10.commitChanges(); */
													} else if (activeTabId == 'pmr101ukrvResult_tab3') {
														if (directMasterStore10
																.isDirty()) {
															var selectDetailRecord = detailGrid
																	.getSelectedRecord();
															var param = {
																'DIV_CODE' : selectDetailRecord
																		.get('DIV_CODE'),
																'WKORD_NUM' : selectDetailRecord
																		.get('WKORD_NUM'),
																'PROG_WORK_CODE' : selectDetailRecord
																		.get('PROG_WORK_CODE')
															}
															pmr101ukrvService
																	.checkWorkEnd(
																			param,
																			function(
																					provider,
																					response) {
																				if (!Ext
																						.isEmpty(provider)) {
																					if (provider.WORK_END_YN == 'Y') {
																						alert('마감된 작업지시입니다.');
																						return false;
																					} else {
																						//masterForm.setValue('RESULT_TYPE', "4");
																						directMasterStore10
																								.saveStore();
																					}
																				}
																			});
														}
													}

												},
												disabled : false
											},
											{
												id : 'resultsUpdateCloseBtn',
												width : 100,
												text : '<t:message code="system.label.product.close" default="닫기"/>',
												handler : function() {
													resultsUpdateForm
															.clearForm();
													resultsUpdateWindow.hide();
													masterGrid12.reset();
													directMasterStore10
															.commitChanges();
												},
												disabled : false
											} ],
									listeners : {
										beforehide : function(me, eOpt) {
										},
										beforeclose : function(panel, eOpts) {
										},
										beforeshow : function(panel, eOpts) {
											var detailRecord = detailGrid
													.getSelectedRecord();
											var progWorkNameRecord = masterGrid4
													.getSelectedRecord();
											resultsUpdateForm.setValue(
													'WKORD_NUM', detailRecord
															.get('WKORD_NUM'));
											resultsUpdateForm.setValue(
													'ITEM_CODE', detailRecord
															.get('ITEM_CODE'));
											resultsUpdateForm.setValue(
													'ITEM_NAME', detailRecord
															.get('ITEM_NAME'));
											resultsUpdateForm.setValue(
													'WKORD_Q', detailRecord
															.get('WKORD_Q'));
											resultsUpdateForm.setValue(
													'STOCK_UNIT', detailRecord
															.get('STOCK_UNIT'));
											resultsUpdateForm.setValue(
													'PRODT_NUM',
													progWorkNameRecord
															.get('PRODT_NUM'));
											resultsUpdateForm.setValue(
													'REMARK',
													progWorkNameRecord
															.get('REMARK'));
											resultsUpdateForm.setValue(
													'FR_TIME',
													progWorkNameRecord
															.get('FR_TIME'));
											resultsUpdateForm.setValue(
													'TO_TIME',
													progWorkNameRecord
															.get('TO_TIME'));
											resultsUpdateForm.setValue(
													'MAN_CNT',
													progWorkNameRecord
															.get('MAN_CNT'));
											resultsUpdateForm.setValue(
													'MAN_HOUR',
													progWorkNameRecord
															.get('MAN_HOUR'));
											resultsUpdateForm.setValue(
													'PRODT_PRSN',
													progWorkNameRecord
															.get('PRODT_PRSN'));
											resultsUpdateForm.setValue(
													'DAY_NIGHT',
													progWorkNameRecord
															.get('DAY_NIGHT'));
											resultsUpdateForm.setValue(
													'EQUIP_CODE',
													progWorkNameRecord
															.get('EQUIP_CODE'));
											resultsUpdateForm.setValue(
													'EQUIP_NAME',
													progWorkNameRecord
															.get('EQUIP_NAME'));
											resultsUpdateForm.setValue(
													'PRODT_DATE',
													progWorkNameRecord
															.get('PRODT_DATE'));
											resultsUpdateForm.setValue(
													'WORK_Q',
													progWorkNameRecord
															.get('WORK_Q'));
											resultsUpdateForm.setValue(
													'LUNCH_CHK', 'Y');
											gsPopupChk = 'RESULT';
											gsProdtNum = progWorkNameRecord
													.get('PRODT_NUM');
											gsProdtDate1 = UniDate
													.getDbDateStr(progWorkNameRecord
															.get('PRODT_DATE'));
											masterGrid12.reset();
											directMasterStore10.commitChanges();
											tab3
													.setActiveTab('pmr101ukrvResult_tab1');

										}
									}
								})
			}
			resultsUpdateWindow.center();
			resultsUpdateWindow.show();
		}

		function fn_StrToDate(str) {
			var year = str.substring(0, 4);
			var month = str.substring(5, 7);
			var day = str.substring(8, 10);
			var hour = str.substring(11, 13);
			var minute = str.substring(14, 16);
			var second = str.substring(17, 19);
			return new Date(year, month, day, hour, minute, second);
		}

		function resultFormQtyClear(fieldName) {
			var fieldArry = new Array(); //배열선언
			fieldArry[0] = 'SAVING_Q';
			fieldArry[1] = 'GOOD_WORK_Q';
			fieldArry[2] = 'BOX_TRNS_RATE';
			fieldArry[3] = 'BOX_Q';
			fieldArry[4] = 'PIECE';
			fieldArry[5] = 'BAD_WORK_Q';
			fieldArry[6] = 'YIELD';
			fieldArry[7] = 'LOSS_Q';
			fieldArry[8] = 'ETC_Q';

			for (var i = 0; i < fieldArry.length; i++) {
				if (fieldArry[i] != fieldName
						&& fieldArry[i] != 'BOX_TRNS_RATE') {
					tab2.down('#tab2Form').setValue(fieldArry[i], '');
				} else if (fieldArry[i] == 'BOX_TRNS_RATE') {
					tab2.down('#tab2Form').setValue(fieldArry[i], '');
				}
			}

		}

		function resultGridQtyClear(fieldName) {
			var records = masterGrid3.getSelectedRecord();

			var fieldArry = new Array(); //배열선언
			fieldArry[0] = 'SAVING_Q';
			fieldArry[1] = 'GOOD_WORK_Q';
			fieldArry[2] = 'BOX_TRNS_RATE';
			fieldArry[3] = 'BOX_Q';
			fieldArry[4] = 'PIECE';
			fieldArry[5] = 'BAD_WORK_Q';
			fieldArry[6] = 'YIELD';
			fieldArry[7] = 'LOSS_Q';
			fieldArry[8] = 'ETC_Q';

			for (var i = 0; i < fieldArry.length; i++) {
				if (fieldArry[i] != fieldName
						&& fieldArry[i] != 'BOX_TRNS_RATE') {
					records.set(fieldArry[i], 0);
				} else if (fieldArry[i] == 'BOX_TRNS_RATE') {
					records.set(fieldArry[i], '');
				}
			}

		}

		var refItemProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',
				{
					api : {
						read : 'pmr101ukrvService.selectRefItem'
					}
				});

		Unilite.defineModel('refItemModel', {
			fields : [ {
				name : 'ITEM_CODE',
				text : '품목',
				type : 'string'
			}, {
				name : 'ITEM_NAME',
				text : '품명',
				type : 'string'
			}, {
				name : 'SPEC',
				text : '규격',
				type : 'string'
			}, {
				name : 'STOCK_UNIT',
				text : '단위',
				type : 'string'
			}, {
				name : 'ORDER_NUM',
				text : '수주번호',
				type : 'string'
			}, {
				name : 'CUSTOM_NAME',
				text : '거래처',
				type : 'string'
			}, {
				name : 'WKORD_NUM',
				text : '작업지시번호',
				type : 'string'
			}, {
				name : 'WKORD_Q',
				text : '지시수량',
				type : 'uniQty'
			}, {
				name : 'PASS_Q',
				text : '양품량',
				type : 'uniQty'
			}, {
				name : 'PRODT_WKORD_DATE',
				text : '지시일',
				type : 'uniDate'
			}, {
				name : 'LOT_NO',
				text : 'LOT NO',
				type : 'string'
			}, {
				name : 'PRODT_DATE',
				text : '제조일자',
				type : 'uniDate'
			},
			//		{name: 'EXPIRATION_DATE'	,text: '유통기한'		,type:'uniDate'}
			]
		});

		var refItemStore = Unilite.createStore('refItemStore', {
			model : 'refItemModel',
			autoLoad : false,
			uniOpt : {
				isMaster : false, // 상위 버튼 연결
				editable : false, // 수정 모드 사용
				deletable : false, // 삭제 가능 여부
				allDeletable : false, // 전체 삭제 가능 여부
				useNavi : false
			// prev | next 버튼 사용
			},
			proxy : refItemProxy,
			loadStoreRecords : function() {
				var param = panelResult.getValues();
				records = detailGrid.getSelectedRecord();
				param.WKORD_NUM = records.get('WKORD_NUM');
				// 			param.WK_PLAN_NUM = records.get('WK_PLAN_NUM');    작업지시번호로 변경함
				this.load({
					params : param
				});
			}
		});
		var refItemGrid = Unilite.createGrid('refItemGrid', {
			store : refItemStore,
			region : 'center',
			layout : 'fit',
			uniOpt : {
				expandLastColumn : false,
				useLiveSearch : false,
				useContextMenu : false,
				useMultipleSorting : false,
				useGroupSummary : false,
				useRowNumberer : false,
				onLoadSelectFirst : false,
				filter : {
					useFilter : false,
					autoCreate : false
				},
				state : {
					useState : false,
					useStateList : false
				}
			},
			selModel : 'rowmodel',
			columns : [ {
				dataIndex : 'ITEM_CODE',
				width : 100
			}, {
				dataIndex : 'ITEM_NAME',
				width : 200
			}, {
				dataIndex : 'SPEC',
				width : 120
			}, {
				dataIndex : 'STOCK_UNIT',
				width : 66,
				align : 'center'
			}, {
				dataIndex : 'PASS_Q',
				width : 100
			}, {
				dataIndex : 'LOT_NO',
				width : 100,
				align : 'center'
			}, {
				dataIndex : 'PRODT_DATE',
				width : 100
			}, {
				dataIndex : 'EXPIRATION_DATE',
				width : 100
			}, {
				dataIndex : 'ORDER_NUM',
				width : 120
			}, {
				dataIndex : 'CUSTOM_NAME',
				width : 200
			}, {
				dataIndex : 'WKORD_NUM',
				width : 120
			}, {
				dataIndex : 'WKORD_Q',
				width : 100
			}, {
				dataIndex : 'PRODT_WKORD_DATE',
				width : 100
			}

			],
			listeners : {
				onGridDblClick : function(grid, record, cellIndex, colName) {

					tab2.down('#tab2Form').setValue('LOT_NO',
							record.get('LOT_NO'));
					tab2.down('#tab2Form').setValue('EXPIRATION_DATE',
							record.get('EXPIRATION_DATE'));
					tab2.down('#tab2Form').setValue('PRODT_DATE',
							record.get('PRODT_DATE'));
					refItemWindow.hide();

				}
			}
		});

		/**
		 * 벌크품목 팝업 윈도우
		 */
		function openRefItemWindow() {
			if (!refItemWindow) {
				refItemWindow = Ext.create('widget.uniDetailWindow', {
					title : '벌크품목 팝업',
					width : 1200,
					height : 500,
					layout : {
						type : 'vbox',
						align : 'stretch'
					},
					items : [ refItemGrid ],
					tbar : [ '->', {
						itemId : 'closeBtn',
						text : '닫기',
						handler : function() {
							refItemWindow.hide();
						},
						disabled : false
					} ],
					listeners : {
						beforehide : function(me, eOpt) {
							refItemGrid.reset();
							refItemStore.clearData();
						},
						beforeshow : function(me, eOpts) {
							refItemStore.loadStoreRecords();
						}
					}
				})
			}
			refItemWindow.center();
			refItemWindow.show();
		}
		;

		/*실적 팝업 계산 로직*/
		function fn_resultQtyCalc(calPassQMethod, fieldName, newValue) {
			var workQ = tab2.down('#tab2Form').getValue('WORK_Q');
			var badWorkQ = tab2.down('#tab2Form').getValue('BAD_WORK_Q');
			var lossQ = tab2.down('#tab2Form').getValue('LOSS_Q');
			var savingQ = tab2.down('#tab2Form').getValue('SAVING_Q');
			var goodWorkQ = tab2.down('#tab2Form').getValue('GOOD_WORK_Q');
			var boxQ = tab2.down('#tab2Form').getValue('BOX_Q');
			var boxTrnsRate = tab2.down('#tab2Form').getValue('BOX_TRNS_RATE');
			var piece = tab2.down('#tab2Form').getValue('PIECE');
			var etcQ = tab2.down('#tab2Form').getValue('ETC_Q');
			var resultBoxCase = 0.00;
			var calYield = 0.00;
			var calBoxQty = 0.00;
			//현재 수정한 필드에 따라 값 세팅
			if (fieldName == 'SAVING_Q') {
				goodWorkQ = workQ - newValue - badWorkQ - lossQ - etcQ;
				resultBoxCase = (boxQ * boxTrnsRate + piece) + newValue
						+ badWorkQ + lossQ + etcQ;
				calBoxQty = (boxQ * boxTrnsRate + piece);

			} else if (fieldName == 'WORK_Q') {
				goodWorkQ = newValue - savingQ - badWorkQ - lossQ - etcQ;
				tab2.down('#tab2Form').setValue('GOOD_WORK_Q', goodWorkQ);
				tab2.down('#tab2Form').setValue('PASS_Q', goodWorkQ);
				calYield = (goodWorkQ / newValue) * 100; // 수율 = 양품량 /생산량
				tab2.down('#tab2Form').setValue('YIELD', calYield);

			} else if (fieldName == 'GOOD_WORK_Q') {
				workQ = newValue + savingQ + badWorkQ + lossQ + etcQ;
				var calYield = (newValue / workQ) * 100; // 수율 = 양품량 /생산량
				tab2.down('#tab2Form').setValue('WORK_Q', workQ);
				tab2.down('#tab2Form').setValue('YIELD', calYield);

			} else if (fieldName == 'BAD_WORK_Q') {
				goodWorkQ = workQ - savingQ - newValue - lossQ - etcQ;
				resultBoxCase = (boxQ * boxTrnsRate + piece) + savingQ
						+ newValue + lossQ + etcQ;
				calBoxQty = (boxQ * boxTrnsRate + piece);

			} else if (fieldName == 'LOSS_Q') {
				goodWorkQ = workQ - savingQ - badWorkQ - newValue - etcQ;
				resultBoxCase = (boxQ * boxTrnsRate + piece) + savingQ
						+ badWorkQ + newValue + etcQ;
				calBoxQty = (boxQ * boxTrnsRate + piece);

			} else if (fieldName == 'ETC_Q') {
				goodWorkQ = workQ - savingQ - badWorkQ - lossQ - newValue;
				resultBoxCase = (boxQ * boxTrnsRate + piece) + savingQ
						+ badWorkQ + lossQ + newValue;
				calBoxQty = (boxQ * boxTrnsRate + piece);

			} else if (fieldName == 'BOX_Q') {
				calBoxQty = newValue * boxTrnsRate + piece;
				workQ = calBoxQty + savingQ + badWorkQ + lossQ + etcQ;
				calYield = (calBoxQty / workQ) * 100; // 수율 = 양품량 /생산량
				tab2.down('#tab2Form').setValue('YIELD', calYield);
				tab2.down('#tab2Form').setValue('GOOD_WORK_Q', calBoxQty);
				tab2.down('#tab2Form').setValue('PASS_Q', calBoxQty);
				tab2.down('#tab2Form').setValue('WORK_Q', workQ);

			} else if (fieldName == 'BOX_TRNS_RATE') {
				calBoxQty = newValue * boxQ + piece;

			} else if (fieldName == 'PIECE') {

				calBoxQty = boxTrnsRate * boxQ + newValue;
			}

			if (calPassQMethod == 'A'
					&& (fieldName != 'WORK_Q' && fieldName != 'GOOD_WORK_Q' && fieldName != 'BOX_Q')) {//직전에 생산량을 입력했을 경우

				tab2.down('#tab2Form').setValue('GOOD_WORK_Q', goodWorkQ);
				tab2.down('#tab2Form').setValue('PASS_Q', goodWorkQ);
				calYield = (goodWorkQ / workQ) * 100; // 수율 = 양품량 /생산량
				tab2.down('#tab2Form').setValue('YIELD', calYield);

			} else if (calPassQMethod == 'B'
					&& (fieldName != 'WORK_Q' && fieldName != 'GOOD_WORK_Q' && fieldName != 'BOX_Q')) {//직전에 양품량을 입력했을 경우
				goodWorkQ = tab2.down('#tab2Form').getValue('GOOD_WORK_Q');
				tab2.down('#tab2Form').setValue('WORK_Q',
						resultBoxCase + goodWorkQ);
				calYield = (goodWorkQ / (resultBoxCase + goodWorkQ)) * 100; // 수율 = 양품량 /생산량
				tab2.down('#tab2Form').setValue('YIELD', calYield);

			} else if (calPassQMethod == 'C'
					&& (fieldName != 'WORK_Q' && fieldName != 'GOOD_WORK_Q' && fieldName != 'BOX_Q')) {//직전에 박스 수량을 입력했을 경우
				tab2.down('#tab2Form').setValue('GOOD_WORK_Q', calBoxQty);
				tab2.down('#tab2Form').setValue('PASS_Q', calBoxQty);
				tab2.down('#tab2Form').setValue('WORK_Q',
						calBoxQty + badWorkQ + savingQ + lossQ + etcQ);
				calYield = (calBoxQty / (calBoxQty + badWorkQ + savingQ + lossQ + etcQ)) * 100; // 수율 = 양품량 /생산량
				tab2.down('#tab2Form').setValue('YIELD', calYield);
			}
		}

		/*공정 그리드 계산 로직*/
		function fn_resultGridQtyCalc(calPassQMethod, fieldName, newValue) {
			var records = masterGrid3.getSelectedRecord();
			var workQ = records.get('WORK_Q');
			var badWorkQ = records.get('BAD_WORK_Q');
			var lossQ = records.get('LOSS_Q');
			var savingQ = records.get('SAVING_Q');
			var goodWorkQ = records.get('GOOD_WORK_Q');
			var boxQ = records.get('BOX_Q');
			var boxTrnsRate = records.get('BOX_TRNS_RATE');
			var piece = records.get('PIECE');
			var etcQ = records.get('ETC_Q');
			var resultBoxCase = 0.00;
			var calYield = 0.00;
			var calBoxQty = 0.00;
			//현재 수정한 필드에 따라 값 세팅
			if (fieldName == 'SAVING_Q') {
				goodWorkQ = workQ - newValue - badWorkQ - lossQ - etcQ;
				resultBoxCase = (boxQ * boxTrnsRate + piece) + newValue
						+ badWorkQ + lossQ + etcQ;
				calBoxQty = (boxQ * boxTrnsRate + piece);
				savingQ = newValue;
			} else if (fieldName == 'BAD_WORK_Q') {
				goodWorkQ = workQ - savingQ - newValue - lossQ - etcQ;
				resultBoxCase = (boxQ * boxTrnsRate + piece) + savingQ
						+ newValue + lossQ + etcQ;
				calBoxQty = (boxQ * boxTrnsRate + piece);
				badWorkQ = newValue;
			} else if (fieldName == 'LOSS_Q') {
				goodWorkQ = workQ - savingQ - badWorkQ - newValue - etcQ;
				resultBoxCase = (boxQ * boxTrnsRate + piece) + savingQ
						+ badWorkQ + newValue + etcQ;
				calBoxQty = (boxQ * boxTrnsRate + piece);
				lossQ = newValue
			} else if (fieldName == 'ETC_Q') {
				goodWorkQ = workQ - savingQ - badWorkQ - lossQ - newValue;
				resultBoxCase = (boxQ * boxTrnsRate + piece) + savingQ
						+ badWorkQ + lossQ + newValue;
				calBoxQty = (boxQ * boxTrnsRate + piece);
				etcQ = newValue

			} else if (fieldName == 'BOX_TRNS_RATE') {
				calBoxQty = newValue * boxQ + piece;

			} else if (fieldName == 'PIECE') {

				calBoxQty = boxTrnsRate * boxQ + newValue;
			}

			if (calPassQMethod == 'A') {//직전에 생산량을 입력했을 경우

				records.set('GOOD_WORK_Q', goodWorkQ);
				records.set('PASS_Q', goodWorkQ);
				calYield = (goodWorkQ / workQ) * 100; // 수율 = 양품량 /생산량
				records.set('YIELD', calYield);

			} else if (calPassQMethod == 'B') {//직전에 양품량을 입력했을 경우

				goodWorkQ = records.get('GOOD_WORK_Q');
				records.set('WORK_Q', resultBoxCase + goodWorkQ);
				calYield = (goodWorkQ / (resultBoxCase + goodWorkQ)) * 100; // 수율 = 양품량 /생산량

				records.set('YIELD', calYield);

			} else if (calPassQMethod == 'C') {//직전에 박스 수량을 입력했을 경우

				records.set('GOOD_WORK_Q', calBoxQty);
				records.set('PASS_Q', calBoxQty);
				records.set('WORK_Q', calBoxQty + badWorkQ + savingQ + lossQ
						+ etcQ);
				calYield = (calBoxQty / (calBoxQty + badWorkQ + savingQ + lossQ + etcQ)) * 100; // 수율 = 양품량 /생산량
				records.set('YIELD', calYield);
			}
		}

		//유효기한이 비어있을 경우 유효기한 자동 계산
		function fn_expirationDateCal() {
			var detailRecords = detailGrid.getSelectedRecord();
			var masterGrid3Records = masterGrid3.getSelectedRecord();
			var expirationDay = detailRecords.get('EXPIRATION_DAY');
			var prdtDate = resultsAddForm.getValue('PRODT_DATE');
			var calExpirationDate;
			//내용물이고 최종공정이고 유통기간이 0이 아닐경우 유효기한 자동 계산 세팅함
			if ((!Ext.isEmpty(expirationDay) && expirationDay != 0 && !Ext
					.isEmpty(prdtDate))
					&& masterGrid3Records.get('LINE_END_YN') == 'Y'
					&& detailRecords.get('ITEM_ACCOUNT') == '30') {
				calExpirationMonthDate = UniDate.add(prdtDate, {
					months : +expirationDay
				});
				var calExpirationMonthLastDay = new Date(calExpirationMonthDate
						.getYear(), calExpirationMonthDate.getMonth() + 1, 0)
						.getDate();
				if (prdtDate.getDate() > calExpirationMonthLastDay) {
					calExpirationDate = calExpirationMonthDate;
				} else {
					calExpirationDate = UniDate.add(calExpirationMonthDate, {
						days : -1
					});
				}
				resultsAddForm.setValue('EXPIRATION_DATE', calExpirationDate);
			}
		}

		/***************************
		 *라벨 출력 코드
		 *2019-11-08
		 ***************************/
		//라벨분할출력 폼
		var labelPrintSearch = Unilite
				.createSearchForm(
						'labelPrintForm',
						{
							//layout		: {type:'vbox', align:'center', pack: 'center' },
							layout : {
								type : 'uniTable',
								columns : 3
							},
							border : true,
							items : [
									{
										fieldLabel : '<t:message code="system.label.purchase.oemitemcode" default="품번"/>',
										name : 'LABEL_ITEM_CODE',
										xtype : 'uniTextfield',
										margin : '0 0 0 0',
										hidden : false,
										readOnly : true,
										colspan : 3,
										fieldStyle : 'text-align: center;',
										listeners : {
											change : function(field, newValue,
													oldValue, eOpts) {
											}
										}
									},
									{
										fieldLabel : '<t:message code="system.label.purchase.printqty" default="출력매수"/>',
										xtype : 'uniNumberfield',
										name : 'LABEL_QTY',
										margin : '0 0 0 0',
										value : 1,
										allowBlank : false,
										width : 150,
										hidden : false,
										fieldStyle : 'text-align: center;'
									},
									{
										xtype : 'component',
										html : '~',
										style : {
											marginTop : '3px !important',
											marginLeft : '-10px !important',
											padding : '0 0 0 0 ',
											font : '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
										}
									},
									{
										xtype : 'uniNumberfield',
										name : 'LABEL_QTY2',
										margin : '0 0 0 5',
										value : 1,
										width : 50,
										allowBlank : false,
										hidden : false,
										fieldStyle : 'text-align: center;'
									},
									{
										fieldLabel : '<t:message code="system.label.product.productiondate" default="생산일"/>',
										xtype : 'uniDatefield',
										name : 'PRODT_DATE',
										value : UniDate.get('today'),
										colspan : 3,
										//			fieldStyle: 'text-align: center;background-color: yellow; background-image: none;',
										readOnly : false,
										allowBlank : true
									},
									{
										fieldLabel : '<t:message code="system.label.product.qty" default="수량"/>',
										xtype : 'uniNumberfield',
										name : 'PRODT_QTY',
										value : 1,
										colspan : 3,
										allowBlank : true,
										hidden : false,
										fieldStyle : 'text-align: center;'
									//holdable	: 'hold'
									},
									{
										fieldLabel : '제품코드',
										name : 'KEY_IN_ITEM_CODE',
										xtype : 'uniTextfield',
										margin : '0 0 0 0',
										hidden : false,
										readOnly : false,
										colspan : 3,
										fieldStyle : 'text-align: center;',
										listeners : {
											change : function(field, newValue,
													oldValue, eOpts) {
											}
										}
									},
									{
										fieldLabel : '품명',
										name : 'KEY_IN_ITEM_NAME',
										xtype : 'uniTextfield',
										margin : '0 0 0 0',
										hidden : false,
										readOnly : false,
										colspan : 3,
										fieldStyle : 'text-align: center;',
										listeners : {
											change : function(field, newValue,
													oldValue, eOpts) {
											}
										}
									},
									{
										fieldLabel : '부품명',
										name : 'KEY_IN_PART_ITEM_NAME',
										xtype : 'uniTextfield',
										margin : '0 0 0 0',
										hidden : false,
										readOnly : false,
										colspan : 3,
										fieldStyle : 'text-align: center;',
										listeners : {
											change : function(field, newValue,
													oldValue, eOpts) {
											}
										}
									},
									{
										fieldLabel : '중량',
										name : 'KEY_IN_WEIGHT',
										xtype : 'uniNumberfield',
										hidden : false,
										readOnly : false,
										colspan : 3,
										decimalPrecision : 2,
										listeners : {
											change : function(field, newValue,
													oldValue, eOpts) {
											}
										}
									},
									{
										fieldLabel : '관리번호',
										name : 'KEY_IN_MANAGE_NUM',
										xtype : 'uniTextfield',
										margin : '0 0 0 0',
										hidden : false,
										readOnly : false,
										colspan : 3,
										fieldStyle : 'text-align: center;',
										listeners : {
											change : function(field, newValue,
													oldValue, eOpts) {
											}
										}
									},
									{
										fieldLabel : '제조번호',
										name : 'KEY_IN_PRODT_NUM',
										xtype : 'uniTextfield',
										margin : '0 0 0 0',
										hidden : false,
										readOnly : false,
										colspan : 3,
										fieldStyle : 'text-align: center;',
										listeners : {
											change : function(field, newValue,
													oldValue, eOpts) {
											}
										}
									},
									{
										fieldLabel : '<t:message code="system.label.sales.labeltype" default="라벨종류"/>',
										name : 'LABEL_TYPE',
										xtype : 'uniCombobox',
										store : labelTypeStore,
										allowBlank : false,
										holdable : 'hold',
										value : '1',
										colspan : 3,
										fieldStyle : 'text-align: center;',
										listeners : {

										}
									},
									{
										xtype : 'container',
										defaultType : 'uniTextfield',
										margin : '0 0 0 60',
										layout : {
											type : 'uniTable',
											columns : 2,
											align : 'center',
											pack : 'center'
										},
										items : [
												{
													xtype : 'button',
													name : 'labelPrint',
													text : '<t:message code="system.label.product.labelprint" default="라벨출력"/>',
													width : 80,
													hidden : false,
													handler : function() {
														if (!Ext
																.isEmpty(labelPrintSearch
																		.getValue('LABEL_QTY'))
																&& !Ext
																		.isEmpty(labelPrintSearch
																				.getValue('LABEL_QTY2'))) {
															if (labelPrintSearch
																	.getValue('LABEL_QTY') > labelPrintSearch
																	.getValue('LABEL_QTY2')) {
																alert('출력 시작페이지가 마지막페이지 보다 클 수는 없습니다.');
																return false;
															}
														}

														if (Ext
																.isEmpty(labelPrintSearch
																		.getValue('LABEL_QTY'))
																|| Ext
																		.isEmpty(labelPrintSearch
																				.getValue('LABEL_QTY2'))) {
															alert('출력 매수를 입력해주세요.');
															return false;
														}
														var selectedDetailRecords = detailGrid
																.getSelectedRecords();
														/*    if(Ext.isEmpty(selectedRecords)){
														          alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
														          return;
														      } */
														//									              var param = panelResult.getValues();
														var param = {};
														param["DIV_CODE"] = panelResult
																.getValue('DIV_CODE')
														param["PRODT_NUM"] = gsSelRecord2.PRODT_NUM;
														param["PRINT_CNT"] = labelPrintSearch
																.getValue('LABEL_QTY');
														param["PRODT_QTY"] = labelPrintSearch
																.getValue('PRODT_QTY');
														param["PRODT_DATE"] = UniDate
																.getDbDateStr(labelPrintSearch
																		.getValue('PRODT_DATE'));

														param["GUBUN"] = 'SHIN';
														param["LABEL_QTY"] = labelPrintSearch
																.getValue('LABEL_QTY');
														param["LABEL_QTY2"] = labelPrintSearch
																.getValue('LABEL_QTY2');
														Ext
																.each(
																		selectedDetailRecords,
																		function(
																				record,
																				idx) {
																			param["WKORD_NUM"] = record
																					.get('WKORD_NUM');
																			param["STD_ITEM_ACCOUNT"] = record
																					.get('STD_ITEM_ACCOUNT');
																			param["ITEM_LEVEL1"] = record
																					.get('ITEM_LEVEL1');
																			param["ITEM_CODE"] = record
																					.get('ITEM_CODE');
																		});
														param["WKORD_NUM"] = gsSelRecord2.WKORD_NUM;

														param["sTxtValue2_fileTitle"] = '라벨 출력';
														param["RPT_ID"] = 'pmr100clrkrv_3';
														param["PGM_ID"] = 'pmr101ukrv';
														param["MAIN_CODE"] = 'P010';
														param["LABEL_TYPE"] = labelPrintSearch
																.getValue('LABEL_TYPE');
														param["KEY_IN_ITEM_CODE"] = labelPrintSearch
																.getValue('KEY_IN_ITEM_CODE');
														param["KEY_IN_ITEM_NAME"] = labelPrintSearch
																.getValue('KEY_IN_ITEM_NAME');
														param["KEY_IN_PART_ITEM_NAME"] = labelPrintSearch
																.getValue('KEY_IN_PART_ITEM_NAME');
														param["KEY_IN_WEIGHT"] = labelPrintSearch
																.getValue('KEY_IN_WEIGHT');
														param["KEY_IN_MANAGE_NUM"] = labelPrintSearch
																.getValue('KEY_IN_MANAGE_NUM');
														param["KEY_IN_PRODT_NUM"] = labelPrintSearch
																.getValue('KEY_IN_PRODT_NUM');
														param["LABEL_LOC"] = gsLabelChk;
														var win = Ext
																.create(
																		'widget.ClipReport',
																		{
																			url : CPATH
																					+ '/prodt/pmr100clrkrv_label.do',
																			prgID : 'pmr101ukrv',
																			extParam : param
																		});
														win.center();
														win.show();
													}
												},
												{
													xtype : 'button',
													name : 'btnCancel',
													text : '<t:message code="system.label.purchase.close" default="닫기"/>',
													width : 80,
													hidden : false,
													handler : function() {
														labelPrintSearch
																.clearForm();
														labelPrintWindow.hide();
														//labelPrintWindow = '';
													}
												} ]
									} ]
						});

		function openLabelPrintWindow() {
			//if(!UniAppManager.app.checkForNewDetail()) return false;
			if (!labelPrintWindow) {
				labelPrintWindow = Ext
						.create(
								'widget.uniDetailWindow',
								{
									title : '<t:message code="system.label.purchase.label" default="라벨"/><t:message code="system.label.purchase.print" default="출력"/>',
									width : 300,
									height : 353,
									//resizable	: false,
									layout : {
										type : 'vbox',
										align : 'stretch'
									},
									items : [ labelPrintSearch ],
									listeners : {
										beforehide : function(me, eOpt) {
											labelPrintSearch.clearForm();
										},
										beforeclose : function(panel, eOpts) {

										},
										beforeshow : function(me, eOpts) {
											var selectedDetailRecord = detailGrid
													.getSelectedRecord();
											var selectedDetailRecord2 = masterGrid4
													.getSelectedRecord();
											labelPrintSearch.setValue(
													'LABEL_QTY', 1);
											labelPrintSearch.setValue(
													'LABEL_QTY2', 1);
											labelPrintSearch.setValue(
													'PRODT_DATE', UniDate
															.get('today'));
											labelPrintSearch.setValue(
													'LABEL_TYPE', 1);
											if (gsLabelChk == "PMP") {
												labelPrintSearch.setValue(
														'PRODT_QTY',
														gsSelRecord2.WKORD_Q);
												labelPrintSearch.setValue(
														'LABEL_ITEM_CODE',
														gsSelRecord2.ITEM_CODE);
											} else {
												labelPrintSearch
														.setValue(
																'PRODT_QTY',
																gsSelRecord2.GOOD_WORK_Q);
												labelPrintSearch
														.setValue(
																'LABEL_ITEM_CODE',
																selectedDetailRecord
																		.get('ITEM_CODE'));
											}
										},
										show : function(me, eOpts) {

										}
									}
								})
			}
			labelPrintWindow.center();
			labelPrintWindow.show();
		}

		/*숫자 validation 체크*/
		function numberValid(sValue) {
			var s;
			s = sValue.replace(/^\s*|\s*$/g, '');
			if (s == '' | isNaN(s)) {
				alert("올바른 숫자를 입력하세요");
				return false;
			}
			return true;
		}

		function inputFields(btnText) {
			//alert(tab2.down('#tab2Form').getField('GOOD_WORK_Q').focus());
			//alert(tab2.down('#tab2Form').getField('WORK_Q').focus());
			//alert(Ext.util.Focusable);
			gsFocus.set(btnText);
		}

		Unilite
				.Main({
					borderItems : [ {
						region : 'center',
						layout : 'border',
						border : false,
						items : [ detailGrid, tab, panelResult, masterGrid4 ]
					} /*,
								masterForm*/
					],
					uniOpt : {
						showKeyText : false,
						showToolbar : false
					//        	forceToolbarbutton:true
					},
					id : 'pmr101ukrvApp',
					fnInitBinding : function() {
						UniAppManager.setToolbarButtons([ 'reset', 'prev',
								'next' ], true);

						this.setDefault();
					},
					onQueryButtonDown : function() {
						if (!panelResult.getInvalidMessage())
							return false;
						gsProdtDate = ''; //조회시 생산일자 전역변수 초기화
						/*	기존로직
						 if(masterForm.setAllFieldsReadOnly(true) == false){
						 return false;
						 }
						 if(panelResult.setAllFieldsReadOnly(true) == false){
						 return false;
						 }
						 var orderNo = masterForm.getValue('WKORD_NUM');
						 if(Ext.isEmpty(orderNo)) {
						 var param= masterForm.getValues();
						 detailStore.loadStoreRecords();
						 }
						 */

						//모든 탭 초기화 후, detailGrid 조회
						directMasterStore2.loadData({})
						directMasterStore3.loadData({})
						directMasterStore4.loadData({})
						directMasterStore5.loadData({})
						directMasterStore6.loadData({})
						directMasterStore7.loadData({})
						directMasterStore8.loadData({})
						directMasterStore9.loadData({})
						detailStore.loadStoreRecords();
						UniAppManager.setToolbarButtons([ 'newData' ], true);
					},
					onNewDataButtonDown : function() {
						//if(!this.checkForNewDetail()) return false;
						var selectedDetailGrid = detailGrid.getSelectedRecord();
						if (!Ext.isEmpty(selectedDetailGrid)) {
							var activeTabId = tab.getActiveTab().getId();
							if (activeTabId == 'pmr101ukrvGrid2') {
								var allRecords = directMasterStore2.data.items;
								var cnt = 0;
								Ext.each(allRecords, function(r, i) {
									if (r.phantom == true) {
										cnt = cnt + 1;
									}
								})
								if (cnt == 0) {
									var record = detailGrid.getSelectedRecord();
									var wkordNum = record.get('WKORD_NUM');
									//var prodtNum = masterForm.getValue('PRODT_NUM');
									var seq = detailStore.max('PRODT_Q');
									if (!seq)
										seq = 1;
									else
										seq += 1;
									var prodtDate = UniDate.get('today');
									var progWorkCode = record
											.get('PROG_WORK_CODE');
									var wkordQ = record.get('WKORD_Q');
									var prodtQ = 0; //생산량
									var goodProdtQ = 0; //양품량
									var badProdtQ = 0; //불량량
									var manHour = 0; //투입공수
									var lotNo = record.get('LOT_NO');
									var remark = record.get('REMARK');
									var projectNo = record.get('PROJECT_NO');
									var pjtCode = record.get('PJT_CODE');
									var divCode = masterForm
											.getValue('DIV_CODE');
									var workShopCode = masterForm
											.getValue('WORK_SHOP_CODE');
									var itemCode = masterForm
											.getValue('ITEM_CODE1');
									var controlStatus = Ext.getCmp('rdoSelect')
											.getChecked()[0].inputValue
									var newData = 'N';
									var lunchChk = '1';

									var r = {
										WKORD_NUM : wkordNum,
										//PRODT_NUM		:prodtNum,
										PRODT_Q : seq,
										PRODT_DATE : prodtDate,
										PROG_WORK_CODE : progWorkCode,
										WKORD_Q : wkordQ,
										PRODT_Q : prodtQ,
										GOOD_PRODT_Q : goodProdtQ,
										BAD_PRODT_Q : badProdtQ,
										MAN_HOUR : manHour,
										LOT_NO : lotNo,
										REMARK : remark,
										PROJECT_NO : projectNo,
										PJT_CODE : pjtCode,
										DIV_CODE : divCode,
										WORK_SHOP_CODE : workShopCode,
										ITEM_CODE : itemCode,
										CONTROL_STATUS : controlStatus,
										NEW_DATA : newData,
										LUNCH_CHK : lunchChk
									//COMP_CODE		:compCode
									};
									masterGrid2
											.createRow(r, 'PRODT_Q',
													masterGrid2.getStore()
															.getCount() - 1);
								} else {
									return false;
								}
							} else if (activeTabId == 'pmr101ukrvGrid5') {
								var record = detailGrid.getSelectedRecord();
								var divCode = masterForm.getValue('DIV_CODE');
								var prodtDate = UniDate.get('today');
								var workShopcode = record.get('WORK_SHOP_CODE');
								var wkordNum = record.get('WKORD_NUM');
								var itemCode = record.get('ITEM_CODE');
								var badCode = '';
								var badQ = 0;
								var remark = '';
								if (!Ext.isEmpty(gsProdtDate)) {
									prodtDate = gsProdtDate;
								}
								var r = {
									DIV_CODE : divCode,
									PRODT_DATE : prodtDate,
									WORK_SHOP_CODE : workShopcode,
									WKORD_NUM : wkordNum,
									ITEM_CODE : itemCode,
									BAD_CODE : badCode,
									BAD_Q : badQ,
									REMARK : remark
								//COMP_CODE			:compCode
								};
								masterGrid5.createRow(r);
							} else if (activeTabId == 'pmr101ukrvGrid6') {
								var record = detailGrid.getSelectedRecord();
								var divCode = masterForm.getValue('DIV_CODE');
								var prodtDate = UniDate.get('today');
								var workShopcode = record.get('WORK_SHOP_CODE');
								var wkordNum = record.get('WKORD_NUM');
								var itemCode = record.get('ITEM_CODE');
								var ctlCd1 = '';
								var troubleTime = '';
								var trouble = '';
								var troubleCs = '';
								var answer = '';
								var seq = 0;
								seq = directMasterStore6.max('SEQ');

								if (Ext.isEmpty(seq)) {
									seq = 1;
								} else {
									seq = seq + 1;
								}
								var r = {
									DIV_CODE : divCode,
									PRODT_DATE : prodtDate,
									WORK_SHOP_CODE : workShopcode,
									WKORD_NUM : wkordNum,
									ITEM_CODE : itemCode,
									CTL_CD1 : ctlCd1,
									TROUBLE_TIME : troubleTime,
									TROUBLE : trouble,
									TROUBLE_CS : troubleCs,
									ANSWER : answer,
									SEQ : seq
								//FR_TIME					: '2008-01-01 08:30:00',
								//TO_TIME				: '2008-01-01 15:30:00'
								//COMP_CODE				:compCode
								};
								masterGrid6.createRow(r);

								/*				//행 추가 로직은 없음
								 } else if(activeTabId == 'pmr101ukrvGrid7_1') {
								 var record			= masterGrid8.getSelectedRecord();
								 var compCode		= record.get('COMP_CODE');
								 var divCode			= record.get('DIV_CODE');
								 var prodtNum		= record.get('PRODT_NUM');
								 var prodtDate		= record.get('PRODT_DATE');
								 var workShopcode	= record.get('WORK_SHOP_CODE');
								 var wkordNum		= record.get('WKORD_NUM');
								 var itemCode		= record.get('ITEM_CODE');
								 var seq = directMasterStore7.max('SEQ');
								 if(!seq) seq = 1;
								 else  seq += 1;

								 var r = {
								 COMP_CODE		: compCode,
								 DIV_CODE		: divCode,
								 PRODT_NUM		: prodtNum,
								 PRODT_DATE		: prodtDate,
								 WORK_SHOP_CODE	: workShopcode,
								 WKORD_NUM		: wkordNum,
								 ITEM_CODE		: itemCode,
								 SEQ				: seq
								 };
								 masterGrid6.createRow(r);*/
							}
							masterForm.setAllFieldsReadOnly(false);
						} else {
							alert(Msg.sMA0256);
							return false;
						}
					},
					onResetButtonDown : function() { // 새로고침 버튼
						this.suspendEvents();
						masterForm.clearForm();
						panelResult.clearForm();

						masterForm.setAllFieldsReadOnly(false);
						panelResult.setAllFieldsReadOnly(false);
						detailGrid.reset();
						masterGrid2.reset();
						masterGrid3.reset();
						masterGrid4.reset();
						masterGrid5.reset();
						masterGrid6.reset();
						masterGrid7.reset();
						masterGrid8.reset();
						masterGrid9.reset();
						this.fnInitBinding();
						detailStore.clearData();
						directMasterStore2.clearData();
						directMasterStore3.clearData();
						directMasterStore4.clearData();
						directMasterStore5.clearData();
						directMasterStore6.clearData();
						directMasterStore7.clearData();
						directMasterStore8.clearData();
						directMasterStore9.clearData();
					},
					onDeleteDataButtonDown : function() {
						var selectedDetailGrid = detailGrid.getSelectedRecord();
						if (!Ext.isEmpty(selectedDetailGrid)) {
							var activeTabId = tab.getActiveTab().getId();
							if (activeTabId == 'pmr101ukrvGrid2') {
								var selRow = masterGrid2.getSelectedRecord();
								if (selRow.phantom === true) {
									masterGrid2.deleteSelectedRow();
								} else if (confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
									masterGrid2.deleteSelectedRow();
								}
							} else if (activeTabId == 'pmr101ukrvGrid3_1') { //masterGrid3은 삭제로직 없음, masterGrid4가 삭제
								if (directMasterStore3.isDirty()) {
									alert('공정별등록에 변경된 데이터가 있습니다.\n저장 후 다시 시도해주세요.');
									return false;
								}
								var selRow = masterGrid4.getSelectedRecord();
								if (selRow.phantom === true) {
									masterGrid4.deleteSelectedRow();
								} else if (confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
									masterGrid4.deleteSelectedRow();
								}
							} else if (activeTabId == 'pmr101ukrvGrid5') {
								var selRow = masterGrid5.getSelectedRecord();
								if (selRow.phantom === true) {
									masterGrid5.deleteSelectedRow();
								} else if (confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
									masterGrid5.deleteSelectedRow();
								}
							} else if (activeTabId == 'pmr101ukrvGrid6') {
								var selRow = masterGrid6.getSelectedRecord();
								if (selRow.phantom === true) {
									masterGrid6.deleteSelectedRow();
								} else if (confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
									masterGrid6.deleteSelectedRow();
								}
							} else if (activeTabId == 'pmr101ukrvGrid7_1') {
								var selRow = masterGrid7.getSelectedRecord();
								if (selRow.phantom === true) {
									masterGrid7.deleteSelectedRow();
								} else if (confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
									masterGrid7.deleteSelectedRow();
								}
							}
						}
					},
					onSaveDataButtonDown : function(config) {
						var activeTabId = tab.getActiveTab().getId();
						var selectDetailRecord = detailGrid.getSelectedRecord();

						var param = {
							'DIV_CODE' : selectDetailRecord.get('DIV_CODE'),
							'WKORD_NUM' : selectDetailRecord.get('WKORD_NUM'),
							'PROG_WORK_CODE' : selectDetailRecord
									.get('PROG_WORK_CODE')
						}
						pmr101ukrvService
								.checkWorkEnd(
										param,
										function(provider, response) {
											if (!Ext.isEmpty(provider)) {
												if (provider.WORK_END_YN == 'Y') {
													alert('마감된 작업지시입니다.');
													return false;
												} else {
													if (activeTabId == 'pmr101ukrvGrid2') { // 작업지시별 등록
														masterForm.setValue(
																'RESULT_TYPE',
																"1");
														var inValidRecs = masterGrid2
																.getStore()
																.getInvalidRecords();
														var newData = masterGrid2
																.getStore()
																.getNewRecords();

														if (inValidRecs.length == 0) {
															if (newData
																	&& newData.length > 0) {
																if (selectDetailRecord
																		.get('RESULT_YN') == '2') {
																	openoutouProdtSave();
																} else {
																	directMasterStore2
																			.saveStore();
																}
															} else {
																directMasterStore2
																		.saveStore();
															}
														} else {
															var grid = Ext
																	.getCmp('pmr101ukrvGrid2');
															grid
																	.uniSelectInvalidColumnAndAlert(inValidRecs);
														}

													} else if (activeTabId == 'pmr101ukrvGrid3_1') { // 공정별 등록
														masterForm.setValue(
																'RESULT_TYPE',
																"2");
														var inValidRecs1 = masterGrid3
																.getStore()
																.getInvalidRecords();
														var inValidRecs2 = masterGrid4
																.getStore()
																.getInvalidRecords();
														var updateData = masterGrid3
																.getStore()
																.getUpdatedRecords(); //공정별 등록 그리드의 수정된 데이터
														var deleteData = masterGrid4
																.getStore()
																.getRemovedRecords(); //실적현황 그리드의 삭제된 데이터

														//공정별 등록 그리드의 수정된 데이터 관련 로직
														if (inValidRecs1.length == 0) {
															if (updateData
																	&& updateData.length > 0) {
																if (selectDetailRecord
																		.get('RESULT_YN') == '2') {
																	var cnt = 0;
																	Ext
																			.each(
																					updateData,
																					function(
																							updateRecord,
																							i) {
																						if (updateRecord
																								.get('LINE_END_YN') == 'Y') {
																							cnt = cnt + 1;
																						}
																					});
																	if (cnt > 0) {
																		openoutouProdtSave();
																	} else {
																		directMasterStore3
																				.saveStore();

																	}
																} else {
																	directMasterStore3
																			.saveStore();
																}
															}
														} else {
															var grid = Ext
																	.getCmp('pmr101ukrvGrid3');
															grid
																	.uniSelectInvalidColumnAndAlert(inValidRecs1);
														}

														//실적현황 그리드의 삭제된 데이터 관련 로직
														if (inValidRecs2.length == 0) {
															if (deleteData
																	&& deleteData.length > 0) {
																/*
																 * 실적현황 삭제시 팝업이 뜨면 안되고 바로 삭제 되어야 함
																 * if(selectDetailRecord.get('RESULT_YN') == '2'){
																	var cnt = 0;
																	Ext.each(deleteData, function(deleteRecord,i) {
																		if(deleteRecord.get('LINE_END_YN') == 'Y'){
																			cnt = cnt + 1;
																		}
																	});
																	if(cnt > 0){
																		openoutouProdtSave();
																	}else{
																		directMasterStore4.saveStore();

																	}
																}else{
																	directMasterStore4.saveStore();
																}*/
																directMasterStore4
																		.saveStore();
															}
														} else {
															var grid = Ext
																	.getCmp('pmr101ukrvGrid3');
															grid
																	.uniSelectInvalidColumnAndAlert(inValidRecs2);
														}
													} else if (activeTabId == 'pmr101ukrvGrid5') { // 불량내역 등록
														masterForm.setValue(
																'RESULT_TYPE',
																"3");
														directMasterStore5
																.saveStore();
													} else if (activeTabId == 'pmr101ukrvGrid6') { // 특기사항 등록
														masterForm.setValue(
																'RESULT_TYPE',
																"4");
														directMasterStore6
																.saveStore();
													} else if (activeTabId == 'pmr101ukrvGrid7_1') { // 제조이력등록
														directMasterStore7
																.saveStore();
													}
												}
											}
										})
					},
					setDefault : function() {
						masterForm.setValue('DIV_CODE', UserInfo.divCode);
						//masterForm.setValue('PRODT_START_DATE_FR',new Date());
						//masterForm.setValue('PRODT_START_DATE_TO',new Date());
						panelResult.setValue('DIV_CODE', UserInfo.divCode);
						//panelResult.setValue('PRODT_START_DATE_FR',new Date());
						//panelResult.setValue('PRODT_START_DATE_TO',new Date());
						masterForm.setValue('PRODT_START_DATE_FR', UniDate.get('startOfMonth'));
						masterForm.setValue('PRODT_START_DATE_TO', UniDate.get('today'));
						panelResult.setValue('PRODT_START_DATE_FR', UniDate.get('startOfMonth'));
						panelResult.setValue('PRODT_START_DATE_TO', UniDate.get('today'));

						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						panelResult.setValue('GS_FR_TIME',
								BsaCodeInfo.gsLunchFr);
						panelResult.setValue('GS_TO_TIME',
								BsaCodeInfo.gsLunchTo);
						UniAppManager.setToolbarButtons('save', false);
						progWordComboStore2.loadStoreRecords();
						panelResult.getField('CONTROL_STATUS').setValue('2');
						MODIFY_AUTH = true;
						setTimeout(function() {
							panelResult.getField('WKORD_NUM').focus();
						}, 50);

					},
					checkForNewDetail : function() {
						if (resultsAddForm.setAllFieldsReadOnly(true)) {
							return true;
						}
						return false;
					}
				});

		function setAllFieldsReadOnly(b) {
			var r = true
			if (b) {
				var invalid = this.getForm().getFields().filterBy(
						function(field) {
							return !field.validate();
						});
				if (invalid.length > 0) {
					r = false;
					var labelText = ''

					if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel'] + '은(는)';
					} else if (Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']
								+ '은(는)';
					}
					alert(labelText + Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if (Ext.isDefined(item.holdable)) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if (item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if (popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if (Ext.isDefined(item.holdable)) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if (item.isPopupField) {
						var popupFC = item.up('uniPopupField');
						if (popupFC.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}

		/** Validation
		 */
		Unilite.createValidator('validator01', {
			store : detailStore,
			grid : detailGrid,
			validate : function(type, fieldName, newValue, oldValue, record,
					eopt) {
				console.log('validate >>> ', {
					'type' : type,
					'fieldName' : fieldName,
					'newValue' : newValue,
					'oldValue' : oldValue,
					'record' : record
				});
				var rv = true;
				switch (fieldName) {

				}
				return rv;
			}
		}); // validator

		Unilite
				.createValidator(
						'validator02',
						{
							store : directMasterStore2,
							grid : masterGrid2,
							validate : function(type, fieldName, newValue,
									oldValue, record, eopt) {
								console.log('validate >>> ', {
									'type' : type,
									'fieldName' : fieldName,
									'newValue' : newValue,
									'oldValue' : oldValue,
									'record' : record
								});
								var rv = true;
								switch (fieldName) {
								case "PRODT_Q": // 생산량
									if (newValue < 0) {
										rv = '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
										break;
									}
									record.set('GOOD_PRODT_Q', newValue);
									break;

								case "GOOD_PRODT_Q": // 양품량
									var record1 = masterGrid2
											.getSelectedRecord();
									if (newValue > record1.get('PRODT_Q')) {
										alert('<t:message code="system.message.product.message011" default="양품량은 생산량 보다 많을 수 없습니다."/>');
										break;
									}
									record.set('BAD_PRODT_Q', record
											.get('PRODT_Q')
											- newValue);
									break;

								case "BAD_PRODT_Q": // 불량량
									if (newValue > "PRODT_Q") {
										alert('<t:message code="system.message.product.message012" default="불량량은 생산량 보다 많을 수 없습니다."/>');
										break;
									}
									record.set('GOOD_PRODT_Q', record
											.get('PRODT_Q')
											- newValue);
									break;

								case "MAN_HOUR": // 투입공수
									if (newValue < 0) {
										rv = '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
										break;
									}
									break;

								/*		case "LOT_NO" :	// LOT_NO
											if(UniBase.fnDateCheckValidator(newValue) == false){
												rv='<t:message code="system.message.product.message037" default="유효한 날짜를 입력하여 주십시오."/>';
												break;
											}
										break;*/

								case "FR_TIME":
									if (!Ext.isEmpty(UniDate.getHHMI(record
											.get('TO_TIME')))) {
										if (newValue > record.get('TO_TIME')) {

											rv = '작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.';
											break;
										}

										/* 						if(Ext.isEmpty(record.get('MAN_CNT'))){
										 rv='작업인원을 입력해주세요.';
										 break;
										 } */
										var diffTime = (record.get('TO_TIME') - newValue) / 60000 / 60;
										if (record.get('LUNCH_CHK') == true) {
											if ((record.get('TO_TIME') >= panelResult
													.getValue('GS_TO_TIME'))
													&& (newValue <= panelResult
															.getValue('GS_FR_TIME'))) {
												diffTime = diffTime - 1;
											}

										}
										var manCnt = record.get('MAN_CNT');
										record.set('MAN_HOUR', manCnt
												* diffTime);
									}
									break;

								case "TO_TIME":

									if (!Ext.isEmpty(UniDate.getHHMI(record
											.get('FR_TIME')))) {
										if (record.get('FR_TIME') > newValue) {

											rv = '작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.';
											break;
										}
										/* 						if(Ext.isEmpty(record.get('MAN_CNT'))){
										 rv='작업인원을 입력해주세요.';
										 break;
										 } */
										var diffTime = (newValue - record
												.get('FR_TIME')) / 60000 / 60;
										if (record.get('LUNCH_CHK') == true) {
											if ((newValue >= panelResult
													.getValue('GS_TO_TIME'))
													&& (record.get('FR_TIME') <= panelResult
															.getValue('GS_FR_TIME'))) {
												diffTime = diffTime - 1;
											}
										}
										var manCnt = record.get('MAN_CNT');
										record.set('MAN_HOUR', manCnt
												* diffTime);
									}
									break;
								case "MAN_CNT":

									if (!Ext.isEmpty(UniDate.getHHMI(record
											.get('FR_TIME')))) {
										if (record.get('FR_TIME') > record
												.get('TO_TIME')) {

											rv = '작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.';
											break;
										}
										if (Ext.isEmpty(newValue)) {
											rv = '작업인원을 입력해주세요.';
											break;
										}
										var diffTime = (record.get('TO_TIME') - record
												.get('FR_TIME')) / 60000 / 60;
										if (record.get('LUNCH_CHK') == true) {
											if ((record.get('TO_TIME') >= panelResult
													.getValue('GS_TO_TIME'))
													&& (record.get('FR_TIME') <= panelResult
															.getValue('GS_FR_TIME'))) {
												diffTime = diffTime - 1;
											}
										}
										var manCnt = newValue;
										record.set('MAN_HOUR', manCnt
												* diffTime);
									}
									break;

								}
								return rv;
							}
						}); // validator

		Unilite
				.createValidator(
						'validator03',
						{
							store : directMasterStore3,
							grid : masterGrid3,
							validate : function(type, fieldName, newValue,
									oldValue, record, eopt) {
								console.log('validate >>> ', {
									'type' : type,
									'fieldName' : fieldName,
									'newValue' : newValue,
									'oldValue' : oldValue,
									'record' : record
								});
								var rv = true;
								switch (fieldName) {
								case "WORK_Q": // 생산량
									if (newValue < 0) {
										rv = '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
										break;
									}
									calPassQMethod = 'A';
									resultGridQtyClear('WORK_Q')//생산량 입력시 기존 수량 초기화
									record.set('GOOD_WORK_Q', newValue
											- record.get('SAVING_Q')
											- record.get('BAD_WORK_Q')
											- record.get('LOSS_Q'));
									record.set('WORK_Q', newValue);
									var calYield = 0;
									calYield = (record.get('GOOD_WORK_Q') / newValue) * 100;
									record.set('YIELD', calYield);
									break;
								case "SAVING_Q": // 관리수량
									if (newValue < 0) {
										rv = '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
										break;
									}
									if (newValue > record.get('WORK_Q')) {
										rv = '관리수량은 생산량보다 많을 수 없습니다.';
										break;
									}
									fn_resultGridQtyCalc(calPassQMethod,
											'SAVING_Q', newValue);

									break;

								case "GOOD_WORK_Q": // 양품량
									if (newValue < 0) {
										rv = '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
										break;
									}
									calPassQMethod = 'B';
									resultGridQtyClear('GOOD_WORK_Q');//양품량 입력시 전체 수량 클리어
									var lossQ = record.get('LOSS_Q');
									var savingQ = record.get('SAVING_Q');
									var badWorkQ = record.get('BAD_WORK_Q');
									var calYield = (newValue / (newValue
											+ savingQ + badWorkQ + lossQ)) * 100; // 수율 = 양품량 /생산량
									record.set('WORK_Q', newValue + savingQ
											+ badWorkQ + lossQ);
									record.set('YIELD', calYield);
									break;

								case "BAD_WORK_Q": // 불량량
									if (newValue < 0) {
										rv = '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
										break;
									}
									fn_resultGridQtyCalc(calPassQMethod,
											'BAD_WORK_Q', newValue);

									break;

								case "LOSS_Q":

									if (newValue > record.get('WORK_Q')) {
										rv = "LOSS수량은 생산량 보다 많을 수 없습니다.";
										break;
									}
									fn_resultGridQtyCalc(calPassQMethod,
											'LOSS_Q', newValue);

									break;

								case "ETC_Q":

									if (newValue > record.get('WORK_Q')) {
										rv = "기타수량은 생산량 보다 많을 수 없습니다.";
										break;
									}
									fn_resultGridQtyCalc(calPassQMethod,
											'ETC_Q', newValue);

									break;

								case "BOX_Q": // 박스수량

									if (newValue < 0) {
										rv = '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
										break;
									}
									calPassQMethod = 'C';
									resultGridQtyClear('BOX_Q');//박스수량 입력시 전체 수량 클리어
									var savingQ = record.get('SAVING_Q');
									var lossQ = record.get('LOSS_Q');
									var badWorkQ = record.get('BAD_WORK_Q');
									var calBoxQty = newValue
											* record.get('BOX_TRNS_RATE')
											+ record.get('PIECE');
									var calYield = (calBoxQty / (calBoxQty
											+ savingQ + badWorkQ + lossQ)) * 100; // 수율 = 양품량 /생산량
									record.set('YIELD', calYield);

									record.set('GOOD_WORK_Q', calBoxQty);
									record.set('WORK_Q', calBoxQty + badWorkQ
											+ savingQ + lossQ);

									break;

								case "BOX_TRNS_RATE": // 박스 입수
									if (newValue < 0) {
										rv = '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
										break;
									}
									calPassQMethod = 'C';
									fn_resultGridQtyCalc(calPassQMethod,
											'BOX_TRNS_RATE', newValue)
									break;

								case "PIECE": // 낱개
									if (newValue < 0) {
										rv = '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
										break;
									}
									calPassQMethod = 'C';
									fn_resultGridQtyCalc(calPassQMethod,
											'PIECE', newValue)
									break;

								case "MAN_HOUR": // 투입공수
									if (newValue < 0) {
										rv = '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
										break;
									}
									break;

								/*			case "LOT_NO" :	// LOT_NO
												if(UniBase.fnDateCheckValidator(newValue) == false){
													rv='<t:message code="system.message.product.message037" default="유효한 날짜를 입력하여 주십시오."/>';
													break;
												}
											break;
								 */
								case "FR_TIME":
									if (!Ext.isEmpty(UniDate.getHHMI(record
											.get('TO_TIME')))) {
										if (newValue > record.get('TO_TIME')) {

											rv = '작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.';
											break;
										}

										/* 						if(Ext.isEmpty(record.get('MAN_CNT'))){
										 rv='작업인원을 입력해주세요.';
										 break;
										 } */
										var diffTime = (record.get('TO_TIME') - newValue) / 60000 / 60;
										if (record.get('LUNCH_CHK') == true) {
											if ((record.get('TO_TIME') >= panelResult
													.getValue('GS_TO_TIME'))
													&& (newValue <= panelResult
															.getValue('GS_FR_TIME'))) {
												diffTime = diffTime - 1;
											}

										}
										var manCnt = record.get('MAN_CNT');
										record.set('MAN_HOUR', manCnt
												* diffTime);
									}
									break;

								case "TO_TIME":

									if (!Ext.isEmpty(UniDate.getHHMI(record
											.get('FR_TIME')))) {
										if (record.get('FR_TIME') > newValue) {

											rv = '작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.';
											break;
										}
										/* 						if(Ext.isEmpty(record.get('MAN_CNT'))){
										 rv='작업인원을 입력해주세요.';
										 break;
										 } */
										var diffTime = (newValue - record
												.get('FR_TIME')) / 60000 / 60;
										if (record.get('LUNCH_CHK') == true) {
											if ((newValue >= panelResult
													.getValue('GS_TO_TIME'))
													&& (record.get('FR_TIME') <= panelResult
															.getValue('GS_FR_TIME'))) {
												diffTime = diffTime - 1;
											}
										}
										var manCnt = record.get('MAN_CNT');
										record.set('MAN_HOUR', manCnt
												* diffTime);
									}
									break;
								case "MAN_CNT":

									if (!Ext.isEmpty(UniDate.getHHMI(record
											.get('FR_TIME')))) {
										if (record.get('FR_TIME') > record
												.get('TO_TIME')) {

											rv = '작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.';
											break;
										}
										if (Ext.isEmpty(newValue)) {
											rv = '작업인원을 입력해주세요.';
											break;
										}
										var diffTime = (record.get('TO_TIME') - record
												.get('FR_TIME')) / 60000 / 60;
										if (record.get('LUNCH_CHK') == true) {
											if ((record.get('TO_TIME') >= panelResult
													.getValue('GS_TO_TIME'))
													&& (record.get('FR_TIME') <= panelResult
															.getValue('GS_FR_TIME'))) {
												diffTime = diffTime - 1;
											}
										}
										var manCnt = newValue;
										record.set('MAN_HOUR', manCnt
												* diffTime);
									}
									break;

								}
								return rv;
							}
						});

		Unilite
				.createValidator(
						'validator05',
						{
							store : directMasterStore5,
							grid : masterGrid5,
							validate : function(type, fieldName, newValue,
									oldValue, record, eopt) {
								console.log('validate >>> ', {
									'type' : type,
									'fieldName' : fieldName,
									'newValue' : newValue,
									'oldValue' : oldValue,
									'record' : record
								});
								var rv = true;
								switch (fieldName) {
								case "BAD_Q": // 수량
									if (newValue < 0) {
										rv = '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
										break;
									}

								}
								return rv;
							}
						});

		Unilite
				.createValidator(
						'validator06',
						{
							store : directMasterStore6,
							grid : masterGrid6,
							validate : function(type, fieldName, newValue,
									oldValue, record, eopt) {
								console.log('validate >>> ', {
									'type' : type,
									'fieldName' : fieldName,
									'newValue' : newValue,
									'oldValue' : oldValue,
									'record' : record
								});
								var rv = true;
								switch (fieldName) {
								case "TROUBLE_TIME": // 발생시간
									if (newValue < 0) {
										rv = '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
										break;
									}
									break;
								case "FR_TIME":
									if (!Ext.isEmpty(UniDate.getHHMI(record
											.get('TO_TIME')))) {
										if (UniDate.getHHMI(newValue) > UniDate
												.getHHMI(record.get('TO_TIME'))) {

											rv = '작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.';
											break;
										}

										var diffTime = (record.get('TO_TIME') - newValue) / 60000 / 60;
										record.set('TROUBLE_TIME', diffTime);
									}
									break;

								case "TO_TIME":

									if (!Ext.isEmpty(UniDate.getHHMI(record
											.get('FR_TIME')))) {
										if (UniDate.getHHMI(record
												.get('FR_TIME')) > UniDate
												.getHHMI(newValue)) {

											rv = '작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.';
											break;
										}

										var diffTime = (newValue - record
												.get('FR_TIME')) / 60000 / 60;

										record.set('TROUBLE_TIME', diffTime);
									}
									break;
								}
								return rv;
							}
						});

		/*   Unilite.createValidator('validator07', {
			forms: {'formA:':resultsAddForm},
			validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
				console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
				var rv = true;
				switch(fieldName) {
				case "PASS_Q" :	// 생산량
					if(newValue < 0) {
						rv= '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
						break;
					}

				break;

				case "GOOD_WORK_Q" :	// 양품량
					if(newValue > record.get('PASS_Q')) {
						alert('<t:message code="system.message.product.message011" default="양품량은 생산량 보다 많을 수 없습니다."/>');
						break;
					}
				    alert("GOOD_WORK_Q");
					record.set('BAD_WORK_Q', record.get('PASS_Q') - newValue);
				break;

				case "BAD_WORK_Q" :	// 불량량
					if(newValue > record.get('PASS_Q')) {
						alert('<t:message code="system.message.product.message012" default="불량량은 생산량 보다 많을 수 없습니다."/>');
						break;
					}

					record.set('GOOD_WORK_Q', record.get('PASS_Q') - record.get('SAVING_Q') - newValue);
				break;

				case "MAN_HOUR" :	// 투입공수
					if(newValue < 0) {
						rv= '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
						break;
					}
				break;

				case "SAVING_Q" :	// 관리수량
					if(newValue > record.get('PASS_Q')) {
						alert('관리수량은 생산량보다 많을 수 없습니다.');
						break;
					}
					alert("SAVING_Q");
					record.set('GOOD_WORK_Q', record.get('PASS_Q') - newValue - record.get('BAD_WORK_Q'));
				break;
			}
				return rv;
			}
		}); */

		Unilite
				.createValidator(
						'validator09',
						{
							store : directMasterStore9,
							grid : masterGrid9,
							validate : function(type, fieldName, newValue,
									oldValue, record, eopt) {
								console.log('validate >>> ', {
									'type' : type,
									'fieldName' : fieldName,
									'newValue' : newValue,
									'oldValue' : oldValue,
									'record' : record
								});
								var rv = true;
								switch (fieldName) {
								case "TROUBLE_TIME": // 발생시간
									if (newValue < 0) {
										//rv= '<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>';
										alert('<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>');
										rv = false;
										break;
									}
									break;
								case "FR_TIME":
									if (!Ext.isEmpty(UniDate.getHHMI(record
											.get('TO_TIME')))) {
										if (UniDate.getHHMI(newValue) > UniDate
												.getHHMI(record.get('TO_TIME'))) {

											//rv='작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.';
											alert('작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.');
											rv = false;

											break;
										}

										var diffTime = (record.get('TO_TIME') - newValue) / 60000 / 60;
										record.set('TROUBLE_TIME', diffTime);
									}
									break;

								case "TO_TIME":

									if (!Ext.isEmpty(UniDate.getHHMI(record
											.get('FR_TIME')))) {
										if (UniDate.getHHMI(record
												.get('FR_TIME')) > UniDate
												.getHHMI(newValue)) {

											//rv='작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.';
											alert('작업시간(FROM)이 작업시간(TO)보다 클 수 없습니다.');
											rv = false;
											break;
										}

										var diffTime = (newValue - record
												.get('FR_TIME')) / 60000 / 60;

										record.set('TROUBLE_TIME', diffTime);
									}
									break;
								}
								return rv;
							}
						});

		Unilite.createValidator('validator10', {
			store : directMasterStore3,
			grid : masterGrid3,
			forms : {
				'formA:' : resultsAddForm
			},
			validate : function(type, fieldName, newValue, oldValue, record,
					eopt) {
				console.log('validate >>> ', {
					'type' : type,
					'fieldName' : fieldName,
					'newValue' : newValue,
					'oldValue' : oldValue,
					'record' : record
				});
				var rv = true;

				if (fieldName == "WORK_Q") {
					//alert(newValue);
				}
				return rv;
			}
		}); // validator

		function beep() {
			audioCtx = new (window.AudioContext || window.webkitAudioContext)();

			var oscillator = audioCtx.createOscillator();
			var gainNode = audioCtx.createGain();

			oscillator.connect(gainNode);
			gainNode.connect(audioCtx.destination);

			gainNode.gain.value = 0.1; //VOLUME 크기
			oscillator.frequency.value = 4100;
			oscillator.type = 'sine'; //sine, square, sawtooth, triangle

			oscillator.start();

			setTimeout(function() {
				oscillator.stop();
			}, 1000 //길이
			);
		}
		;

		var weighingBalance = Unilite.createSearchForm(
				'weighingBalanceSearchForm', {
					defaults : {
						readOnly : true
					},
					padding : '1 1 1 1',
					border : true,
					split : true,
					//region:'east',
					//width:600,
					height : 400,
					items : [ {
						xtype : 'uxiframe',
						id : 'iFrameBalance2',
						//src	: "http://211.115.212.39:9999/mes/weighing/weighing.do",
						src : gsKioskConUrl,
						layout : 'fit',
						padding : '10 1 1 1',
						width : '100%'/*,
													height  : '600'*/
					}

					]
				});
		var weighingSearch = Unilite
				.createSearchForm(
						'weighingSearchForm',
						{

							layout : {
								type : 'uniTable',
								columns : 1,
								tableAttrs : {
									width : '99.5%'
								}
							},
							region : 'north',
							height : 50,
							defaults : {
								readOnly : true
							},
							padding : '1 1 1 1',
							border : true,
							items : [ {
								xtype : 'container',
								layout : {
									type : 'uniTable',
									columns : 1
								},
								defaultType : 'uniTextfield',
								defaults : {
									readOnly : true
								},
								items : [ {
									xtype : 'component',
									id : 'labelChkMessage',
									html : '* 현재 분동체크 중입니다...',
									tdAttrs : {
										style : 'border : 0px solid #ced9e7;font-weight: bold; font: normal 18px "굴림",Gulim,tahoma, arial, verdana, sans-serif; color:red;',
										align : 'left'
									}
								} ]
							} ]
						});

		var pop2SearchBalance = Unilite.createSearchForm(
				'pop2BalanceSearchForm', {
					defaults : {
						readOnly : true
					},
					padding : '1 1 1 1',
					border : true,
					split : true,
					region : 'center',
					flex : 1.5,
					height : 500,
					//		trackResetOnLoad: true,
					items : [ {
						xtype : 'uxiframe',
						id : 'iFrameBalance',
						//src	: "http://211.115.212.39:9999/mes/weighing/weighing.do",
						src : gsKioskConUrl,
						layout : 'fit',
						padding : '10 1 1 1',
						width : '100%'/*,
													height  : '600'*/
					}

					]
				});

		var panelSearch2 = Unilite.createSearchForm('panelSearch2', {
			region : 'south',
			layout : {
				type : 'uniTable',
				columns : 3,
				tableAttrs : {
					width : '99.5%'
				}
			},
			padding : '1 1 1 1',
			margin : '-3 0 0 0',
			border : true,
			tdAttrs : {
				align : 'right'
			},
			//		defaults:{
			//			labelWidth:140,
			//			width:375
			//		},
			items : [
					{
						xtype : 'component',
						html : '',
						width : 320,
						style : {

						}
					},
					{
						xtype : 'button',
						text : '<div style="color: blue">0점조정</div>',
						width : 140,
						height : 50,
						// margin      : '0 0 2 140',
						itemId : 'btnZeroChk',
						tdAttrs : {
							align : 'right'
						},
						handler : function(btn) {
							setTimeout(function() {
								if (confirm("0점 조정을 진행하시겠습니까?")) {
									setTimeout(function() {
										scaleIframe = $(
												"#iFrameBalance-iframeEl").get(
												0).contentWindow;
										scaleIframe.postMessage({
											command : "requestZero"
										}, '*');

									}, 100)
								} else {
									return false;
								}
							}, 100)
						}
					}, ]
		});
		//칭량팝업함수(분동용)
		function weighingChkPop() {
			if (!searchPop2WindowInit) {
				searchPop2WindowInit = Ext
						.create(
								'Ext.window.Window',
								{
									id : 'pop2Page2',
									title : '분동체크 팝업',
									width : 700,
									height : 541,
									modal : true,
									layout : 'border',
									hidden : false,
									items : [ {
										layout : {
											type : 'vbox',
											align : 'stretch'
										},
										xtype : 'panel',
										region : 'center',
										id : 'balancePanel2',
										height : 400,
										tdAttrs : {
											align : 'left'
										},
										flex : 1,
										defaults : {
											holdable : 'hold'
										},
										margin : '0 0 2 0',
										items : [ weighingSearch,
												weighingBalance ]
									} ],
									tbar : [
											'->',
											{
												itemId : 'closeBtn',
												text : '<t:message code="system.label.product.close" default="닫기"/>',
												minWidth : 100,
												hidden : false,
												handler : function() {
													Ext
															.getCmp(
																	'labelChkMessage')
															.setHtml(
																	'* 현재 분동체크 중입니다...');
													searchPop2WindowInit.hide();
													//Ext.getCmp('btnPrint1').setDisabled(false);
												},
												disabled : false
											} ],
									listeners : {
										beforehide : function(me, eOpt) {
											scaleIframe = $(
													"#iFrameBalance2-iframeEl")
													.get(0).contentWindow;
											scaleIframe.postMessage({
												command : "disConnectStomp"
											}, '*');

										},
										beforeclose : function(panel, eOpts) {

										},
										beforeshow : function(panel, eOpts) {
										},
										show : function(panel, eOpts) {
											$(
													".x-btn-inner.x-btn-inner-default-toolbar-small")
													.css("font-size", "1.5em");
											$(
													".x-btn-inner.x-btn-inner-default-toolbar-small")
													.css('font-weight', 'bold');
											$(
													".x-btn.x-unselectable.x-box-item.x-toolbar-item.x-btn-default-toolbar-small")
													.css('left', '564');
											$(
													".x-btn.x-unselectable.x-box-item.x-toolbar-item.x-btn-default-toolbar-small")
													.css('height', '22');
										}
									}
								})

			}
			searchPop2WindowInit.center();
			searchPop2WindowInit.show();

			scaleIframe = $("#iFrameBalance2-iframeEl").get(0).contentWindow;
			scaleIframe.postMessage({
				command : "disConnectStomp"
			}, '*');

			setTimeout(function() {
				//팝업을 초기화 시킵니다.
				scaleIframe.postMessage({
					command : "pageInit"
				}, '*');
				//팝업으로 데이터를 셋팅합니다.
				scaleIframe.postMessage({
					command : 'setValue', //명령어
					weightCheckPage : true, //분동체크 페이지 사용여부
					erpLoginID : UserInfo.userID
				//erp 로그인 아이디
				}, '*');
				//전자저울과 연결합니다
				scaleIframe.postMessage({
					command : "connectStomp"
				}, '*');
			}, 1000)
		}

		//칭량팝업함수(칭량용)
		function weighingPop() {
			if (!searchPop2Window) {
				searchPop2Window = Ext
						.create(
								'widget.uniDetailWindow',
								{
									id : 'pop2Page',
									title : '팝업',
									width : 700,
									height : 760,
									modal : true,
									layout : 'border',
									hidden : false,
									items : [ {
										layout : {
											type : 'hbox',
											align : 'stretch'
										},
										xtype : 'container',
										region : 'center',
										tdAttrs : {
											align : 'right'
										},
										defaults : {
											holdable : 'hold'
										},
										margin : '0 0 2 0',
										items : [ {
											layout : {
												type : 'vbox',
												align : 'stretch'
											},
											xtype : 'panel',
											region : 'east',
											id : 'balancePanel1',
											//collapsible: true,
											height : 500,
											collapseDirection : 'left',
											tdAttrs : {
												align : 'right'
											},
											flex : 1,
											defaults : {
												holdable : 'hold'
											},
											margin : '0 0 2 0',
											items : [ pop2SearchBalance,
													panelSearch2 ],
											listeners : {
												collapse : function() {
													$(
															".x-tool-tool-el.x-tool-img.x-tool-expand-right")
															.hide();
													pop2Grid.down(
															'#collapsedBtn')
															.setHidden(false);
													pop2Grid.down('#expandBtn')
															.setHidden(true);
												},
												expand : function() {
													$(
															".x-tool-tool-el.x-tool-img.x-tool-expand-right")
															.hide();
													pop2Grid.down(
															'#collapsedBtn')
															.setHidden(true);
													pop2Grid.down('#expandBtn')
															.setHidden(false);
												}
											}
										} ]
									}

									],
									tbar : [
											'->',
											{
												itemId : 'searchBtn',
												text : '<t:message code="system.label.product.inquiry" default="조회"/>',
												minWidth : 100,
												hidden : true,
												handler : function() {

												},
												disabled : false
											},
											{
												itemId : 'confirmBtn',
												text : '저장',
												hidden : true,
												minWidth : 100,
												handler : function() {

												},
												disabled : false
											},
											{
												itemId : 'closeBtn',
												text : '<t:message code="system.label.product.close" default="닫기"/>',
												minWidth : 100,
												hidden : false,
												handler : function() {
													searchPop2Window.hide();
													//팝업닫을 때 기존 저울 연결을 끊습니다.
													//scaleIframe = $("#iFrameBalance-iframeEl").get(0).contentWindow;
													//scaleIframe.postMessage({ command: "disConnectStomp" }, '*');

												},
												disabled : false
											} ],
									listeners : {
										beforehide : function(me, eOpt) {

										},
										beforeclose : function(panel, eOpts) {
										},
										beforeshow : function(panel, eOpts) {

										},
										show : function(panel, eOpts) {

										}
									}
								})

			}
			searchPop2Window.center();
			searchPop2Window.show();
			searchPop2Window.hide();

			scaleIframe = $("#iFrameBalance-iframeEl").get(0).contentWindow;
			if (weighing == 'N') {
				setTimeout(function() {
					scaleIframe.postMessage({
						command : 'setValue', //명령어
						id : '키오스크0', //연계아이디
						lotNo : "", //로트번호
						item : "", //출고품목
						outStock : {
							qty : 1,
							unit : 'G'
						}, //출고단위
						errorRange : 1, //오차
						erpLoginID : UserInfo.userID
					//erp 로그인 아이디
					}, '*');
					setTimeout(function() {
						scaleIframe.postMessage({
							command : "connectStomp"
						}, '*')
						weighing = 'Y';
					}, 2000);
				}, 1000);
			}
		}
		//분동체크  팝업에서 메세지 받았을 때 처리
		window.addEventListener("message", function(e) {
			var msg = e.data;

			switch (msg.command) {
			case 'scaleValue': //저울의 무게데이터 요청시의 응답입니다
				setTimeout(function() {
					if (!Ext.isEmpty(msg.value)) {
						var scaleValue = msg.value;
						scaleValue = String(scaleValue);
						scaleValue = scaleValue.match(/(\d*\.?\d+)/g);
						tab2.down('#tab2Form').setValue('GOOD_WORK_Q',
								scaleValue, false);
					}
				}, 1000)

				// document.querySelector('#scaleData').value = msg.value;

				break;
			case 'frameHeight': //저울과 연결 하였을 때 iframe의 높이를 반환합니다
				//document.querySelector('#scale-frame').style.height = msg.height + 'px';
				searchPop2WindowInit.setHeight(msg.height + 200);
				weighingBalance.setHeight(msg.height + 200);
				break;
			case 'weightCheck': //모든 분동체크가 확인 됬을 시
				console.log(msg.status);
				//모든 분동체크가 완료됬을 시
				if (msg.status.complete) {
					//분동체크하는 팝업을 닫습니다
					//$('#popScale002').modal('hide');
					//원래의 팝업을 오픈합니다
					//originModalOpen();
					searchPop2WindowInit.hide();
					weighingBalance.setHtml("* 분동체크가 완료되었습니다...");
					//Ext.getCmp('btnPrint1').setDisabled(false);
					if (!searchPop2Window) {
						scaleIframe.postMessage({
							command : "disConnectStomp"
						}, '*');
					}
				}
				//모든 분동체크가 완료되지 않았을 시
				else {
					//적당한 로직을 넣어주세요
					alert(msg.status.total + '개의 저울 중' + msg.status.checked
							+ '개의 저울을 분동체크 하였습니다');
					//weighingSearch.getField('chkMessage').html= '* 기준추를 활용하여 분동체크를 실행하세요..';
					Ext.getCmp('labelChkMessage').setHtml(
							'* 기준추를 활용하여 분동체크를 실행하세요..');
					// Ext.getCmp('btnPrint1').setDisabled(true);
				}
				break;
			default:
				console.log(msg);
				break;
			}
		});
	}
</script>