<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="s_str105ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="s_str105ukrv_mit" /> 		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" />						<!-- 수불담당 -->	
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />			<!--창고-->	
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고Cell-->
	<t:ExtComboStore comboType="AU" comboCode="S007" />						<!--출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="B021" />						<!--품목상태-->
	<t:ExtComboStore comboType="AU" comboCode="B013" />						<!--판매단위-->
	<t:ExtComboStore comboType="AU" comboCode="B059" />						<!--과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="S014" />						<!--매출대상-->
	<t:ExtComboStore comboType="AU" comboCode="S002" />						<!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="S003" />						<!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="B004" />						<!--화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="S010" />						<!--영업담당자-->
	<t:ExtComboStore comboType="AU" comboCode="T016" />						<!--대금결제방법-->
	<t:ExtComboStore comboType="AU" comboCode="B116" />						<!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="S065" />						<!--주문구분-->
	<t:ExtComboStore comboType="AU" comboCode="Z017" />						<!--바코드별 국가구분-->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5' />			<!--생성경로-->
	<t:ExtComboStore comboType="OU" />										<!-- 창고-->
</t:appConfig>
<style type="text/css">
	.search-hr {height: 1px;}
	.x-change-cell_Read {
		//background-color: #F3E2A9;
		color: #FFB000;
	}
</style>
<script type="text/javascript">

//20190820 추가: 기존 입력되어 있던 창고, 창고cell 그대로 유지 하기 위해 추가
var gsWhCode;
var gsWhCellCode;
var tempSaveWindow;			//데이터 임시저장 관련 window
var searchInfoWindow;		//searchInfoWindow : 검색창
var referRequestWindow;		//출하지시참조
var refersalesOrderWindow;	//수주(오퍼)참조
var orderNumWindow;			//20200130 추가: 수주번호 팝업
var issueReqNumWindow;		//20200401 추가: 출하지시번호 팝업
var alertWindow;			//alertWindow : 경고창
var gsText			= ''	//바코드 알람 팝업 메세지
var gsRefYn			= 'N'
var gsMonClosing	= '';	//월마감 여부
var gsDayClosing	= '';	//일마감 여부
var gsMaxInoutSeq	= 0;
var gsSaveFlag		= false;
//var gsLotNoS		= ''	//FIFO 구현을 위한 임시테이블명

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
	gsSumTypeCell		: '${gsSumTypeCell}',
	gsRefWhCode			: '${gsRefWhCode}',
	gsManageTimeYN		: '${gsManageTimeYN}',
	useLotAssignment	: '${useLotAssignment}',
	gsFifo				: '${gsFifo}',
	grsOutType			: ${grsOutType},
	gsVatRate			: ${gsVatRate},
	salePrsn			: ${salePrsn},
	inoutPrsn			: ${inoutPrsn},
	whList				: ${whList},
	gsReportGubun		: '${gsReportGubun}',	//레포트 구분
	gsDefaultType		: '${gsDefaultType}',	//레포트 타입(S148.SUB_CODE)
	gsDefaultCrf		: '${gsDefaultCrf}',	//레포트(CRF) 파일명(S148.REF_CODE2)
	gsDefaultFolder		: '${gsDefaultFolder}'	//레포트(CRF) 폴더명(S148.REF_CODE3): 사이트일 때만 입력
};

var CustomCodeInfo = {
	gsAgentType		: '',
	gsCustCreditYn	: '',
	gsUnderCalBase	: '',
	gsTaxInout		: '',
	gsbusiPrsn		: ''
};

var outDivCode = UserInfo.divCode;
	
function appMain() {
	var isAutoOrderNum = false;				//자동채번 여부
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoOrderNum = true;
	}

	var manageTimeYN = false;				//시/분/초 필드 처리여부
	if(BsaCodeInfo.gsManageTimeYN =='Y') {
		manageTimeYN = true;
	}

	var sumtypeCell = true;					//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeCell =='Y') {
		sumtypeCell = false;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_str105ukrv_mitService.selectList'/*,
			update	: 's_str105ukrv_mitService.updateDetail',
			create	: 's_str105ukrv_mitService.insertDetail',
			destroy	: 's_str105ukrv_mitService.deleteDetail',
			syncAll	: 's_str105ukrv_mitService.saveAll'*/
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_str105ukrv_mitService.selectList2',
			update	: 's_str105ukrv_mitService.updateDetail2',
			create	: 's_str105ukrv_mitService.insertDetail2',
			destroy	: 's_str105ukrv_mitService.deleteDetail2',
			syncAll	: 's_str105ukrv_mitService.saveAll2'
		}
	});

	//임시저장관련 proxy
	var tempProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_str105ukrv_mitService.tempSelectList',
			create	: 's_str105ukrv_mitService.tempInsertDetail',
			syncAll	: 's_str105ukrv_mitService.tempSaveAll'
		}
	});



	/** 수주의 마스터 정보를 가지고 있는 Form
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 6},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
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
					var field = panelResult.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
					if(!Ext.isEmpty(newValue) && !Ext.isEmpty(panelResult.getValue('INOUT_DATE'))){
						UniSales.fnGetClosingInfo(
							UniAppManager.app.cbGetClosingInfo,
							newValue,
							"I",
							panelResult.getField('INOUT_DATE').getSubmitValue()
						);
					}
					panelResult.setValue('DEPT_CODE', '');
					panelResult.setValue('DEPT_NAME', '');
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issueno" default="출고번호"/>',
			xtype		: 'uniTextfield',
			name		: 'INOUT_NUM',
			holdable	: 'hold'
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
			name		: 'INOUT_DATE',
			xtype		: 'uniDatefield',
			value		: new Date(),
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(newValue && !Ext.isEmpty(panelResult.getValue('DIV_CODE')))){
						UniSales.fnGetClosingInfo(
							UniAppManager.app.cbGetClosingInfo,
							panelResult.getValue('DIV_CODE'),
							"I",
							UniDate.getDbDateStr(newValue)
						);
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxabletotalamount" default="과세총액"/>(1)',
			name		: 'TOT_SALE_TAXI', 
			xtype		: 'uniNumberfield',
			readOnly	: true,
			value		: 0,
			holdable	: 'hold',
			colspan		: 3
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>' ,
			holdable	: 'hold',
			//20200130 필수 제거
//			allowBlank	: false,
			listeners	: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						CustomCodeInfo.gsAgentType		= records[0]["AGENT_TYPE"];
						CustomCodeInfo.gsCustCreditYn	= records[0]["CREDIT_YN"] == Ext.isEmpty(records[0]["CREDIT_YN"])? 0 : records[0]["CREDIT_YN"];
						CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"];
						CustomCodeInfo.gsTaxInout		= records[0]["TAX_TYPE"];	//세액포함여부
						CustomCodeInfo.gsbusiPrsn		= records[0]["BUSI_PRSN"];	//거래처의 주영업담당
						
						//20190812 추가
						if(!Ext.isEmpty(records[0]["NATION_CODE"])) {
							panelResult.setValue('NATION_CODE', records[0]["MONEY_UNIT"]);
						} else {
							panelResult.setValue('NATION_CODE', 'ZZ');
						}

						if(BsaCodeInfo.gsOptDivCode == "1"){	//출고사업장과 동일
							//skip
						} else {
							var saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);//거래처의 영업담당자의 사업장코드	
							if(Ext.isEmpty(saleDivCode)){		//거래처의 영업담당자가 있는지 체크
								panelResult.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
								panelResult.getField('CUSTOM_CODE').focus();
								
								CustomCodeInfo.gsAgentType		= '';
								CustomCodeInfo.gsCustCreditYn	= '';
								CustomCodeInfo.gsUnderCalBase	= '';
								CustomCodeInfo.gsTaxInout		= '';
								CustomCodeInfo.gsbusiPrsn		= '';
								Unilite.messageBox('<t:message code="system.message.sales.message065" default="영업담당자 정보가 존재하지 않습니다."/>');	//영업담당자정보가 존재하지 않습니다.
								return false;
							}
						}
						panelResult.setValue('MONEY_UNIT', records[0]["MONEY_UNIT"]);
						UniAppManager.app.fnExchngRateO();
					},
					scope: this
				},
				onClear: function(type) {
					CustomCodeInfo.gsAgentType		= '';
					CustomCodeInfo.gsCustCreditYn	= '';
					CustomCodeInfo.gsUnderCalBase	= '';
					CustomCodeInfo.gsTaxInout		= '';
					CustomCodeInfo.gsbusiPrsn		= '';
					
					panelResult.setValue('MONEY_UNIT'	, BsaCodeInfo.gsMoneyUnit);
					panelResult.setValue('EXCHG_RATE_O'	, 1);
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			child		: 'WH_CELL_CODE',
//			allowBlank	: false, 
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salesdate" default="매출일"/>'  ,
			name		: 'SALE_DATE', 
			xtype		: 'uniDatefield',
			value		: new Date(),
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxtotalamount" default="세액합계"/>(2)', 
			name		: 'TOT_TAXI',
			readOnly	: true,
			value		: 0,
			xtype		: 'uniNumberfield',
			holdable	: 'hold',
			colspan		: 2
		},{
			margin	: '0 0 0 15',
			xtype	: 'button',
			text	: '임시저장하기',
			id		: 'tempSave',
			handler	: function() {
				//20200402 추가
				barcodeStore.clearFilter();
				var tempRecords = barcodeGrid.getStore().data.items;
				if(Ext.isEmpty(tempRecords)) {
					Unilite.messageBox('<t:message code="system.message.common.savecheck2" default="저장할 데이터가 없습니다."/>');
					return false;
				}
				var inoutNum = panelResult.getValue('INOUT_NUM');
				Ext.each(tempRecords, function(tempRecord, index) {
					if(tempRecord.get('INOUT_NUM') != inoutNum) {
						tempRecord.set('INOUT_NUM', inoutNum);
					}
					tempRecord.phantom = true;
					temSaveStore.insert(index, tempRecord);

					if (tempRecords.length == index +1) {
						temSaveStore.saveStore();
					}
				});
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
			name		: 'INOUT_PRSN',	
			xtype		: 'uniCombobox',
			comboType	: 'AU', 
			comboCode	: 'B024', 
			allowBlank	: false, 
			holdable	: 'hold',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('DEPT', { 
			fieldLabel		: '<t:message code="system.label.sales.department" default="부서"/>', 
			valueFieldName	: 'DEPT_CODE',
			textFieldName	: 'DEPT_NAME',
			hidden			: true,
			holdable		: 'hold',
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
						panelResult.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
						panelResult.getField('ALL_CHANGE_WH_CODE').setValue(records[0]['WH_CODE']);
					},
					scope: this
				},
				onClear: function(type) {
					panelResult.setValue('DEPT_CODE', '');
					panelResult.setValue('DEPT_NAME', '');
				},
				applyextparam: function(popup){
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;				//부서정보
					var divCode = '';								//사업장
					
					if(authoInfo == "A"){	//자기사업장	
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						
					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>',
			name		: 'WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
//			hidden		: true,
			holdable	: 'hold',
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
			value		: BsaCodeInfo.gsMoneyUnit,
			allowBlank	: false,
			displayField: 'value',
			holdable	: 'hold',
			fieldStyle	: 'text-align: center;',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
//					UniAppManager.app.fnExchngRateO(); 
				},
				blur: function( field, The, eOpts ) {
					UniAppManager.app.fnExchngRateO();
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxexemptiontotalamount" default="면세총액"/>(3)', 
			name		: 'TOT_SALENO_TAXI',
			xtype		: 'uniNumberfield',
			readOnly	: true,
			value		: 0,
			holdable	: 'hold'
		},{
			fieldLabel	: ' ',
			name		: 'NATION_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'AU', 
			comboCode	: 'Z017',
			//20200327 수정: 중간에 수정 가능하도록 변경
//			holdable	: 'hold',
			fieldStyle	: 'text-align: center;',
			labelWidth	: 10,
			width		: 100,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			margin	: '0 0 0 15',
			xtype	: 'button',
			text	: '임시불러오기',
			id		: 'tempQuery',
			handler	: function() {
				var detailRecords	= detailGrid.getStore().data.items;
				var barcodeRecords	= barcodeGrid.getStore().data.items;
				if(detailRecords.length != 0 || barcodeRecords.length != 0) {
					Unilite.messageBox('화면을 초기화 한 후 작업을 진행하세요');
					return false;
				}
				openTempSaveWindow();
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
			name		: 'CREATE_LOC',	
			xtype		: 'uniCombobox', 
			comboType	: 'AU', 
			comboCode	: 'B031', 
			allowBlank	: false, 
			hidden		: true,
			value		: '1',
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{	//20200401 추가: 출하지시번호 필드 추가
			xtype		: 'container',
			defaultType	: 'uniTextfield',
			layout		: {type : 'hbox'},
			tdAttrs		: {width: 380},
			items		: [{	//20191219 수주번호 필드 팝업으로 변경: 기존로직 주석, 20200130 텍스트 필드로 원복
				fieldLabel	: '<t:message code="system.label.sales.sono" default="수주번호"/>', 
				name		: 'ORDER_BARCODE',
				xtype		: 'uniTextfield',
				readOnly	: false,
				fieldStyle	: 'IME-MODE: inactive',				//IE에서만 적용 됨
	//			autoCreate	: {tag: 'input', type: 'text', size: '20', style :'IME-MODE:DISABLED' ,autocomplete: 'off', maxlength: '8'},
	//			holdable	: 'hold',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					},
					specialkey:function(field, event) {
						if(event.getKey() == event.ENTER) {
							//저장버튼 활성화 확인
							if(UniAppManager.app._needSave()) {
								beep();
								gsText = '저장할 데이터가 존재 합니다.';
								openAlertWindow(gsText);
								//해당 컬럼에 포커싱 작업 추후 진행
								panelResult.setValue('ORDER_BARCODE', '');
								panelResult.getField('ORDER_BARCODE').focus();
								return false;
							}
							//main 그리드 데이터 존재여부 확인
							var masterRecords = detailStore.data.items
							if(masterRecords.length > 0) {
								beep();
								gsText = '신규 버튼을 누른 후 새 작업을 시작해 주세요.';
								openAlertWindow(gsText);
								//해당 컬럼에 포커싱 작업 추후 진행
								panelResult.setValue('ORDER_BARCODE', '');
								panelResult.getField('ORDER_BARCODE').focus();
								return false;
							}
							//WH_CODE, WH_CELL_CODE 입력여부 확인
							if(Ext.isEmpty(panelResult.getValue('WH_CODE')) || Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))) {
								beep();
								gsText = '출고창고 / 출고창고Cell은 필수 입력입니다.';
								openAlertWindow(gsText);
								//해당 컬럼에 포커싱 작업 추후 진행
								panelResult.setValue('ORDER_BARCODE', '');
								panelResult.getField('ORDER_BARCODE').focus();
								return false;
							}
							//20200130 로직 변경: 입력된 수주번호로 검색 후 데이터가 하나이면 바로 이후로직 수행 아니면 팝업 오픈
	//						var newValue = panelResult.getValue('ORDER_BARCODE');
	//						if(!Ext.isEmpty(newValue)) {
	//							detailGrid.focus();
	//							Ext.getBody().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
	//							fnEnterOrderBarcode(newValue);
	//							panelResult.setValue('ORDER_BARCODE', '');
	//						}
							var param = {
								DIV_CODE	: panelResult.getValue('DIV_CODE'),
								ORDER_NUM	: panelResult.getValue('ORDER_BARCODE')
							}
							s_str105ukrv_mitService.getOrderNum(param, function(provider, response){
								if(provider.length == 1) {
									detailGrid.focus();
									Ext.getBody().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
									fnEnterOrderBarcode(provider[0].ORDER_NUM);
									panelResult.setValue('ORDER_BARCODE', '');
								} else {
									openOrderNumPopup();
								}
							});
						}
					},
					//20200205: 더블클릭 이벤트 추가 - 수주팝업 오픈
					afterrender:function(field) {
						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				//20200205: 더블클릭 이벤트 추가 - 수주팝업 오픈
				onDblclick:function(event, elm)	{
					//저장버튼 활성화 확인
					if(UniAppManager.app._needSave()) {
						beep();
						gsText = '저장할 데이터가 존재 합니다.';
						openAlertWindow(gsText);
						//해당 컬럼에 포커싱 작업 추후 진행
						panelResult.setValue('ORDER_BARCODE', '');
						panelResult.getField('ORDER_BARCODE').focus();
						return false;
					}
					//main 그리드 데이터 존재여부 확인
					var masterRecords = detailStore.data.items
					if(masterRecords.length > 0) {
						beep();
						gsText = '신규 버튼을 누른 후 새 작업을 시작해 주세요.';
						openAlertWindow(gsText);
						//해당 컬럼에 포커싱 작업 추후 진행
						panelResult.setValue('ORDER_BARCODE', '');
						panelResult.getField('ORDER_BARCODE').focus();
						return false;
					}
					//WH_CODE, WH_CELL_CODE 입력여부 확인
					if(Ext.isEmpty(panelResult.getValue('WH_CODE')) || Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))) {
						beep();
						gsText = '출고창고 / 출고창고Cell은 필수 입력입니다.';
						openAlertWindow(gsText);
						//해당 컬럼에 포커싱 작업 추후 진행
						panelResult.setValue('ORDER_BARCODE', '');
						panelResult.getField('ORDER_BARCODE').focus();
						return false;
					}
					openOrderNumPopup();
				}
			},{	//20200401 추가: 출하지시번호 필드 추가
				fieldLabel	: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>', 
				name		: 'ISSUE_REQ_BARCODE',
				xtype		: 'uniTextfield',
				readOnly	: false,
				fieldStyle	: 'IME-MODE: inactive',				//IE에서만 적용 됨
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					},
					specialkey:function(field, event) {
						if(event.getKey() == event.ENTER) {
							//저장버튼 활성화 확인
							if(UniAppManager.app._needSave()) {
								beep();
								gsText = '저장할 데이터가 존재 합니다.';
								openAlertWindow(gsText);
								//해당 컬럼에 포커싱 작업 추후 진행
								panelResult.setValue('ISSUE_REQ_BARCODE', '');
								panelResult.getField('ISSUE_REQ_BARCODE').focus();
								return false;
							}
							//main 그리드 데이터 존재여부 확인
							var masterRecords = detailStore.data.items
							if(masterRecords.length > 0) {
								beep();
								gsText = '신규 버튼을 누른 후 새 작업을 시작해 주세요.';
								openAlertWindow(gsText);
								//해당 컬럼에 포커싱 작업 추후 진행
								panelResult.setValue('ISSUE_REQ_BARCODE', '');
								panelResult.getField('ISSUE_REQ_BARCODE').focus();
								return false;
							}
							//WH_CODE, WH_CELL_CODE 입력여부 확인
							if(Ext.isEmpty(panelResult.getValue('WH_CODE')) || Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))) {
								beep();
								gsText = '출고창고 / 출고창고Cell은 필수 입력입니다.';
								openAlertWindow(gsText);
								//해당 컬럼에 포커싱 작업 추후 진행
								panelResult.setValue('ISSUE_REQ_BARCODE', '');
								panelResult.getField('ISSUE_REQ_BARCODE').focus();
								return false;
							}
							var param = {
								DIV_CODE		: panelResult.getValue('DIV_CODE'),
								ISSUE_REQ_NUM	: panelResult.getValue('ISSUE_REQ_BARCODE')
							}
							s_str105ukrv_mitService.getIssueReqNum(param, function(provider, response){
								if(provider.length == 1) {
									detailGrid.focus();
									Ext.getBody().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
									fnEnterIssueBarcode(provider[0].ISSUE_REQ_NUM);
									panelResult.setValue('ISSUE_REQ_BARCODE', '');
								} else {
									openIssueReqNumPopup();
								}
							});
						}
					},
					//20200205: 더블클릭 이벤트 추가 - 수주팝업 오픈
					afterrender:function(field) {
						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				//20200205: 더블클릭 이벤트 추가 - 수주팝업 오픈
				onDblclick:function(event, elm)	{
					//저장버튼 활성화 확인
					if(UniAppManager.app._needSave()) {
						beep();
						gsText = '저장할 데이터가 존재 합니다.';
						openAlertWindow(gsText);
						//해당 컬럼에 포커싱 작업 추후 진행
						panelResult.setValue('ISSUE_REQ_BARCODE', '');
						panelResult.getField('ISSUE_REQ_BARCODE').focus();
						return false;
					}
					//main 그리드 데이터 존재여부 확인
					var masterRecords = detailStore.data.items
					if(masterRecords.length > 0) {
						beep();
						gsText = '신규 버튼을 누른 후 새 작업을 시작해 주세요.';
						openAlertWindow(gsText);
						//해당 컬럼에 포커싱 작업 추후 진행
						panelResult.setValue('ISSUE_REQ_BARCODE', '');
						panelResult.getField('ISSUE_REQ_BARCODE').focus();
						return false;
					}
					//WH_CODE, WH_CELL_CODE 입력여부 확인
					if(Ext.isEmpty(panelResult.getValue('WH_CODE')) || Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))) {
						beep();
						gsText = '출고창고 / 출고창고Cell은 필수 입력입니다.';
						openAlertWindow(gsText);
						//해당 컬럼에 포커싱 작업 추후 진행
						panelResult.setValue('ISSUE_REQ_BARCODE', '');
						panelResult.getField('ISSUE_REQ_BARCODE').focus();
						return false;
					}
					openIssueReqNumPopup();
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '',
				name		: 'GUBUN',
				holdable	: 'hold',
				items		: [{
					boxLabel	: '수주',
					name		: 'GUBUN',
					inputValue	: '1',
					width		: 60
				},{
					boxLabel	: '출하지시',
					name		: 'GUBUN',
					inputValue	: '2',
					width		: 70
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.GUBUN == '1') {
							panelResult.getField('ORDER_BARCODE').setHidden(false);
							panelResult.getField('ISSUE_REQ_BARCODE').setHidden(true);
						} else {
							panelResult.getField('ORDER_BARCODE').setHidden(true);
							panelResult.getField('ISSUE_REQ_BARCODE').setHidden(false);
						}
					}
				}
			}]
		},{
			xtype		: 'image',
			src			: CPATH+'/resources/css/icons/s01_query.png',
			hidden		: true,
			listeners	: {
				click : {
					element	: 'el',
					fn		: function( e, t, eOpts )	{
						//저장버튼 활성화 확인
						if(UniAppManager.app._needSave()) {
							beep();
							gsText = '저장할 데이터가 존재 합니다.';
							openAlertWindow(gsText);
							//해당 컬럼에 포커싱 작업 추후 진행
							panelResult.setValue('ORDER_BARCODE', '');
							panelResult.getField('ORDER_BARCODE').focus();
							return false;
						}
						//main 그리드 데이터 존재여부 확인
						var masterRecords = detailStore.data.items
						if(masterRecords.length > 0) {
							beep();
							gsText = '신규 버튼을 누른 후 새 작업을 시작해 주세요.';
							openAlertWindow(gsText);
							//해당 컬럼에 포커싱 작업 추후 진행
							panelResult.setValue('ORDER_BARCODE', '');
							panelResult.getField('ORDER_BARCODE').focus();
							return false;
						}
						//WH_CODE, WH_CELL_CODE 입력여부 확인
						if(Ext.isEmpty(panelResult.getValue('WH_CODE')) || Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))) {
							beep();
							gsText = '출고창고 / 출고창고Cell은 필수 입력입니다.';
							openAlertWindow(gsText);
							//해당 컬럼에 포커싱 작업 추후 진행
							panelResult.setValue('ORDER_BARCODE', '');
							panelResult.getField('ORDER_BARCODE').focus();
							return false;
						}
						openOrderNumPopup();
					}
				}
			}
		},
		//20191219 수주번호 필드 팝업으로 변경: 신규 추가된 내용, 20200130 텍스트 필드로 원복
/*		Unilite.popup('ORDER_NUM',{
			fieldLabel		: '<t:message code="system.label.sales.sono" default="수주번호"/>',
			validateBlank	: true,
			textFieldName	: 'ORDER_BARCODE',
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						//저장버튼 활성화 확인
						if(UniAppManager.app._needSave()) {
							beep();
							gsText = '저장할 데이터가 존재 합니다.';
							openAlertWindow(gsText);
							//해당 컬럼에 포커싱 작업 추후 진행
							panelResult.setValue('ORDER_BARCODE', '');
							panelResult.getField('ORDER_BARCODE').focus();
							return false;
						}
						//main 그리드 데이터 존재여부 확인
						var masterRecords = detailStore.data.items
						if(masterRecords.length > 0) {
							beep();
							gsText = '신규 버튼을 누른 후 새 작업을 시작해 주세요.';
							openAlertWindow(gsText);
							//해당 컬럼에 포커싱 작업 추후 진행
							panelResult.setValue('ORDER_BARCODE', '');
							panelResult.getField('ORDER_BARCODE').focus();
							return false;
						}
						//WH_CODE, WH_CELL_CODE 입력여부 확인
						if(Ext.isEmpty(panelResult.getValue('WH_CODE')) || Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))) {
							beep();
							gsText = '출고창고 / 출고창고Cell은 필수 입력입니다.';
							openAlertWindow(gsText);
							//해당 컬럼에 포커싱 작업 추후 진행
							panelResult.setValue('ORDER_BARCODE', '');
							panelResult.getField('ORDER_BARCODE').focus();
							return false;
						}
						var newValue = panelResult.getValue('ORDER_BARCODE');
						if(!Ext.isEmpty(newValue)) {
							detailGrid.focus();
							Ext.getBody().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
							fnEnterOrderBarcode(newValue);
							panelResult.setValue('ORDER_BARCODE', '');
						}
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),*/{
			fieldLabel	: '<t:message code="system.label.sales.barcode" default="바코드"/>', 
			name		: 'BARCODE',
			xtype		: 'uniTextfield',
			readOnly	: false,
			fieldStyle	: 'IME-MODE: inactive',				//IE에서만 적용 됨
//			autoCreate	: {tag: 'input', type: 'text', size: '20', style :'IME-MODE:DISABLED' ,autocomplete: 'off', maxlength: '8'},
//			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				specialkey:function(field, event) {
					if(event.getKey() == event.ENTER) {
						var newValue = panelResult.getValue('BARCODE');
						if(!Ext.isEmpty(newValue)) {
							detailGrid.focus();
							fnEnterBarcode(newValue);
							panelResult.setValue('BARCODE', '');
						}
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.exchangerate" default="환율"/>', 
			name		: 'EXCHG_RATE_O',
			xtype		: 'uniNumberfield', 
			holdable	: 'hold',
			decimalPrecision: 4,
			value		: 1,
			hidden		: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuetotamount" default="출고총액"/>',
			name		: 'TOTAL_AMT',
			xtype		: 'uniNumberfield',
			readOnly	: true,
			value		: 0,
			holdable	: 'hold'
		},{
			fieldLabel	: '<t:message code="system.label.sales.lotnos" default="FIFO위한 field"/>',
			name		: 'LOT_NO_S',
			xtype		: 'uniTextfield',
			colspan		: 4,
			width		: 1000,
			readOnly	: true,
			hidden		: true
		},{
			margin	: '0 0 0 15',
			xtype	: 'button',
			text	: '<t:message code="system.label.sales.specificationprint" default="거래명세서출력"/>',
			id		: 'btnPrint',
			handler	: function() {
				if(Ext.isEmpty(panelResult.getValue('INOUT_NUM'))){
					return false;
				}
				if(UniAppManager.app._needSave())   {
					Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
					return false;
				}
				//20190103 공통코드에 따라 출력 리포트 구분
				var reportGubun = BsaCodeInfo.gsReportGubun;
				if(reportGubun.toUpperCase() == 'CLIP'){
					var param = panelResult.getValues();
					var win;
					param.PGM_ID		= PGM_ID;				//프로그램ID
					param.MAIN_CODE		= 'S036'				//해당 모듈의 출력정보를 가지고 있는 공통코드
					param["COMP_NAME"]	= UserInfo.deptName;
					
					if(BsaCodeInfo.gsDefaultType == '15'){
						var win = Ext.create('widget.ClipReport', {
							url		: CPATH+'/sales/str410clskrv_5.do',
							prgID	: 'str410skrv_5',
							extParam: param
						});
						win.center();
						win.show();
					} else if(BsaCodeInfo.gsDefaultType == '20'){
						var win = Ext.create('widget.ClipReport', {
							url		: CPATH+'/sales/str410clskrv_kodi.do',
							prgID	: 'str410skrv_kodi',
							extParam: param
						});
						win.center();
						win.show();
					} else if(BsaCodeInfo.gsDefaultType == '30'){
						if(Ext.isEmpty(BsaCodeInfo.gsDefaultCrf)) {
							param.RPT_NAME = 'str105clukrv';
						} else {
							param.RPT_NAME		= BsaCodeInfo.gsDefaultCrf;
							param.FOLDER_NAME	= BsaCodeInfo.gsDefaultFolder;
						}
						var win = Ext.create('widget.ClipReport', {
							url		: CPATH+'/sales/str105clukrv.do',
							prgID	: 's_str105ukrv_mit',
							extParam: param
						});
						win.center();
						win.show();
					} else {
						var win = Ext.create('widget.ClipReport', {
							url		: CPATH+'/sales/str410clskrv.do',
							prgID	: 'str410skrv',
							extParam: param
						});
						win.center();
						win.show();
					}
					
				} else {
					var param = panelResult.getValues();
	//				param["sTxtValue2_fileTitle"]='TRANSPORT AND GOODS ISSUE DOCUMENT\n' +			레포트에 고정 시킴
	//						'QUE VO INDUSTRIAL PARK, PHUONGLIEU COMMUNE, QUE VO DISTRICT, BAC NINH PROVINCE, VIET NAM';
					param["PGM_ID"]= PGM_ID;
					param["MAIN_CODE"] = 'S036';		//영업용 공통 코드
					var win = Ext.create('widget.CrystalReport', {
						url: CPATH+'/sales/str105crkrv.do',
						prgID: 's_str105ukrv_mit',
						extParam: param
					});
					win.center();
					win.show();
				}
			}
		},{
			margin	: '0 0 0 15',
			xtype	: 'button',
			text	: '임시출고삭제',
			id		: 'tempDelete',
			handler	: function() {
				var inoutNum = panelResult.getValue('INOUT_NUM');
				//20190906 확인 메세지 추가1
				if(Ext.isEmpty(inoutNum)) {
					Unilite.messageBox('<t:message code="system.message.sales.datacheck022" default="삭제할 자료가 없습니다."/>');
					return false;
				}
				//20190906 확인 메세지 추가2
				if(confirm('<t:message code="system.message.sales.message141" default="삭제하시겠습니까?"/>')) {
					var param = {
						COMP_CODE	: UserInfo.compCode,
						DIV_CODE	: panelResult.getValue('DIV_CODE'),
						INOUT_NUM	: inoutNum
					}
					s_str105ukrv_mitService.tempDeleteDetail(param, function(provider, response){
						UniAppManager.updateStatus(Msg.sMB011);
						//20190906 임시출고삭제 후 초기화로직 추가
						UniAppManager.app.onResetButtonDown();
					});
				}
			}
		},{
			margin	: '0 0 0 15',
			xtype	: 'button',
			text	: 'beep 테스트',
			hidden	: true,
			handler	: function() {
				beep_ok();
			}
		}],
		fnCreditCheck: function() {
			if(BsaCodeInfo.gsCustCreditYn=='Y' && BsaCodeInfo.gsCreditYn=='Y') {
				if(this.getValue('TOT_ORDER_AMT') > this.getValue('REMAIN_CREDIT')) {
					Unilite.messageBox('<t:message code="system.message.sales.datacheck002" default="해당 업체에 대한 여신액이 부족합니다. 추가여신액 설정을 선행하시고 작업하시기 바랍니다."/>');
					return false;
				}
			}
			return true;
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
							var popupFC = item.up('uniPopupField');
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
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});



	/** 출고 디테일 정보를 가지고 있는 Grid
	 */
	//마스터 모델 정의
	Unilite.defineModel('s_str105ukrv_mitDetailModel', { 
		fields: [
			{name: 'INOUT_SEQ'				, text:'<t:message code="system.label.sales.seq" default="순번"/>'						, type: 'int'		, allowBlank: false},
			{name: 'CUSTOM_NAME'			, text:'<t:message code="system.label.sales.customname" default="거래처명"/>'				, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		, text:'<t:message code="system.label.sales.issuetype" default="출고유형"/>'				, type: 'string'	, comboType: 'AU', comboCode: 'S007', allowBlank: false, defaultValue: Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value')}, 
			{name: 'WH_CODE'				, text:'<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'			, type: 'string'	, comboType: 'OU', allowBlank: false/*, child: 'WH_CELL_CODE'*/},
			{name: 'WH_NAME'				, text:'<t:message code="system.label.sales.issuewarehousename" default="출고창고명"/>'		, type: 'string'},
			{name: 'WH_CELL_CODE'			, text:'<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>'	, type: 'string'	, allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList')/*, parentNames:['WH_CODE','SALE_DIV_CODE']*/},
			{name: 'WH_CELL_NAME'			, text:'<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>'	, type: 'string'},
			{name: 'SALE_DIV_CODE'			, text:'<t:message code="system.label.sales.salesdivision" default="매출사업장"/>'			, type: 'string'	, allowBlank: false, child: 'WH_CODE'},		//확인해봐야함
			{name: 'ITEM_CODE'				, text:'<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'				, text:'<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'	, allowBlank: false},
			{name: 'SPEC'					, text:'<t:message code="system.label.sales.spec" default="규격"/>'						, type: 'string'},
			{name: 'LOT_NO'					, text:'<t:message code="system.label.sales.lotno" default="LOT번호"/>'					, type: 'string'	, allowBlank: false},
			{name: 'ITEM_STATUS'			, text:'<t:message code="system.label.sales.itemstatus" default="품목상태"/>'				, type: 'string'	, comboType: 'AU', comboCode: 'B021', defaultValue: "1", allowBlank: false},
			{name: 'ORDER_UNIT'				, text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'				, type: 'string'	, allowBlank: false, comboType: 'AU', comboCode: 'B013', displayField: 'value'},
			{name: 'PRICE_TYPE'				, text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string'	, defaultValue: BsaCodeInfo.gsPriceGubun},
			{name: 'TRANS_RATE'				, text: '<t:message code="Mpo501.label.TRNS_RATE" default="입수"/>' 						, type: 'float'		, decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'ORDER_UNIT_Q'			, text:'<t:message code="system.label.sales.issueqty" default="출고량"/>'					, type: 'uniQty'	, defaultValue: 0, allowBlank: false},
			{name: 'TEMP_ORDER_UNIT_Q'		, text:'TEMP_ORDER_UNIT_Q'	, type: 'uniQty'},		//LOT팝업에서 허용된 수량만 입력하기 위해..
			{name: 'ORDER_UNIT_P'			, text:'<t:message code="system.label.sales.price" default="단가"/>'						, type: 'uniUnitPrice'	, defaultValue: 0, allowBlank: true, editable: true},
			{name: 'INOUT_WGT_Q'			, text:'<t:message code="system.label.sales.issueqty" default="출고량"/>(<t:message code="system.label.sales.weight" default="중량"/>)'			, type: 'uniQty'		, defaultValue: 0},
			{name: 'INOUT_FOR_WGT_P'		, text:'<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'			, type: 'uniUnitPrice'	, defaultValue: 0},
			{name: 'INOUT_VOL_Q'			, text:'<t:message code="system.label.sales.issueqty" default="출고량"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'			, type: 'uniQty'		, defaultValue: 0},
			{name: 'INOUT_FOR_VOL_P'		, text:'<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'			, type: 'uniUnitPrice'	, defaultValue: 0},
			{name: 'INOUT_WGT_P'			, text:'<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.weight" default="중량"/>)'			, type: 'uniUnitPrice'	, defaultValue: 0},
			{name: 'INOUT_VOL_P'			, text:'<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'			, type: 'uniUnitPrice'	, defaultValue: 0},
			{name: 'ORDER_UNIT_O'			, text:'<t:message code="system.label.sales.amount" default="금액"/>'						, type: 'uniPrice'		, defaultValue: 0, allowBlank: true},
			{name: 'ORDER_AMT_SUM'			, text:'<t:message code="system.label.sales.totalamount1" default="합계금액"/>'				, type: 'uniPrice'		, defaultValue: 0},
			{name: 'TAX_TYPE'				, text:'<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'			, type: 'string'		, comboType: 'AU', comboCode: 'B059', defaultValue: "1", allowBlank: false},
			{name: 'INOUT_TAX_AMT'			, text:'<t:message code="system.label.sales.vatamount" default="부가세액"/>'				, type: 'uniPrice'		, defaultValue: 0, allowBlank: true},
			{name: 'WGT_UNIT'				, text:'<t:message code="system.label.sales.weightunit" default="중량단위"/>'				, type: 'string'		, defaultValue: BsaCodeInfo.gsWeight},
			{name: 'UNIT_WGT'				, text:'<t:message code="system.label.sales.unitweight" default="단위중량"/>'				, type: 'int'			, defaultValue: 0},
			{name: 'VOL_UNIT'				, text:'<t:message code="system.label.sales.volumnunit" default="부피단위"/>'				, type: 'string'		, defaultValue: BsaCodeInfo.gsVolume},
			{name: 'UNIT_VOL'				, text:'<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'				, type: 'string'		, defaultValue: 0},
			{name: 'TRANS_COST'				, text:'<t:message code="system.label.sales.shippingcharge" default="운반비"/>'			, type: 'uniPrice'		, defaultValue: 0},
			{name: 'DISCOUNT_RATE'			, text:'<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'			, type: 'uniPercent'	, defaultValue: 0},
			{name: 'STOCK_Q'				, text:'<t:message code="system.label.sales.inventoryqty2" default="재고수량"/>'			, type: 'uniQty'},
			{name: 'ORDER_STOCK_Q'			, text:'<t:message code="system.label.sales.unit" default="단위"/><t:message code="system.label.sales.inventoryqty2" default="재고수량"/>'				, type: 'uniQty'},
			{name: 'PRICE_YN'				, text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string'		, comboType: 'AU', comboCode: 'S003', defaultValue: "2", allowBlank: false},
			{name: 'ACCOUNT_YNC'			, text:'<t:message code="system.label.sales.salessubject" default="매출대상"/>'				, type: 'string'		, comboType: 'AU', comboCode: 'S014', defaultValue: "Y", allowBlank: false},
			{name: 'DELIVERY_DATE'			, text:'<t:message code="system.label.sales.deliverydate2" default="납품일"/>'				, type: 'uniDate'},
			{name: 'DELIVERY_TIME'			, text:'<t:message code="system.label.sales.deliverytime2" default="납품시간"/>'			, type: 'string'},
			{name: 'RECEIVER_ID'			, text:'<t:message code="system.label.sales.receiverid" default="수신자ID"/>'				, type: 'string'},
			{name: 'RECEIVER_NAME'			, text:'<t:message code="system.label.sales.receivername" default="수신자명"/>'				, type: 'string'},
			{name: 'TELEPHONE_NUM1'			, text:'<t:message code="system.label.sales.phoneno1" default="전화번호"/>'					, type: 'string'},
			{name: 'TELEPHONE_NUM2'			, text:'<t:message code="system.label.sales.phoneno1" default="전화번호"/>'					, type: 'string'},
			{name: 'ADDRESS'				, text:'<t:message code="system.label.sales.address" default="주소"/>'					, type: 'string'},
			{name: 'SALE_CUST_CD'			, text:'<t:message code="system.label.sales.salesplace" default="매출처"/>'				, type: 'string'		, allowBlank: false},					//매출처 defaultValue 다시 분석
			{name: 'SALE_PRSN'				, text:'<t:message code="system.label.sales.salescharge" default="영업담당"/>'				, type: 'string'		, comboType: 'AU', comboCode: 'S010'},	//거래처의 주영업담당
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
//			{name: 'LOT_ASSIGNED_YN'		, text:'LOT_ASSIGNED_YN'	, type: 'string'		, defaultValue: "N"},	//lot팝업에서 선택시 Y로 set..
			{name: 'INOUT_NUM'				, text:'<t:message code="system.label.sales.tranno" default="수불번호"/>'					, type: 'string'},
			{name: 'INOUT_DATE'				, text:'<t:message code="system.label.sales.issuedate" default="출고일"/>'					, type: 'uniDate'		, allowBlank: false},
			{name: 'INOUT_METH'				, text:'INOUT_METH'			, type: 'string'		, defaultValue: "2", allowBlank: false},
			{name: 'INOUT_TYPE'				, text:'INOUT_TYPE'			, type: 'string'		, defaultValue: "2", allowBlank: false},
			{name: 'DIV_CODE'				, text:'DIV_CODE'			, type: 'string'		, allowBlank: false},
			{name: 'INOUT_CODE_TYPE'		, text:'INOUT_CODE_TYPE'	, type: 'string'		, defaultValue: "4", allowBlank: false},
			{name: 'INOUT_CODE'				, text:'<t:message code="system.label.sales.customcode" default="거래처코드"/>'				, type: 'string'		, allowBlank: false},
			{name: 'SALE_CUSTOM_CODE'		, text:'<t:message code="system.label.sales.customcode" default="거래처코드"/>'				, type: 'string'		, allowBlank: false},
			{name: 'CREATE_LOC'				, text:'CREATE_LOC'			, type: 'string'		, allowBlank: false},
			{name: 'UPDATE_DB_USER'			, text:'UPDATE_DB_USER'		, type: 'string'		, defaultValue: UserInfo.userID},
			{name: 'UPDATE_DB_TIME'			, text:'UPDATE_DB_TIME'		, type: 'string'},
			{name: 'MONEY_UNIT'				, text:'MONEY_UNIT'			, type: 'string'		, allowBlank: false},
			{name: 'EXCHG_RATE_O'			, text:'EXCHG_RATE_O'		, type: 'uniER'			, allowBlank: false, defaultValue: 1},
			{name: 'ORIGIN_Q'				, text:'ORIGIN_Q'			, type: 'uniQty'},
			{name: 'ORDER_NOT_Q'			, text:'<t:message code="system.label.sales.undeliveryqtyso" default="미납량(수주)"/>'				, type: 'uniQty'},
			{name: 'ISSUE_NOT_Q'			, text:'<t:message code="system.label.sales.undeliveryqtyshipmentorder" default="미납량(출하)"/>'	, type: 'uniQty'},
			{name: 'ORDER_SEQ'				, text:'<t:message code="system.label.sales.seq" default="순번"/>'						, type: 'int'},
			{name: 'ISSUE_REQ_SEQ'			, text:'ISSUE_REQ_SEQ'		, type: 'uniQty'},
			{name: 'BASIS_SEQ'				, text:'BASIS_SEQ'			, type: 'int'},
			{name: 'ORDER_TYPE'				, text:'ORDER_TYPE'			, type: 'string'},
			{name: 'STOCK_UNIT'				, text:'STOCK_UNIT'			, type: 'string'},
			{name: 'BILL_TYPE'				, text:'BILL_TYPE'			, type: 'string'		, defaultValue: "10", allowBlank: false},
			{name: 'SALE_TYPE'				, text:'SALE_TYPE'			, type: 'string'		, allowBlank: false},
			{name: 'CREDIT_YN'				, text:'CREDIT_YN'			, type: 'string'		, defaultValue: BsaCodeInfo.gsCustCreditYn},
			{name: 'ACCOUNT_Q'				, text:'ACCOUNT_Q'			, type: 'uniQty'		, defaultValue: 0},
			{name: 'SALE_C_YN'				, text:'SALE_C_YN'			, type: 'string'		, defaultValue: "N"},
			{name: 'INOUT_PRSN'				, text:'INOUT_PRSN'			, type: 'string'},
			{name: 'WON_CALC_BAS'			, text:'WON_CALC_BAS'		, type: 'string'		, defaultValue: BsaCodeInfo.gsUnderCalBase},
			{name: 'TAX_INOUT'				, text:'TAX_INOUT'			, type: 'string'},
			{name: 'AGENT_TYPE'				, text:'AGENT_TYPE'			, type: 'string'		, defaultValue: BsaCodeInfo.gsAgentType},
			{name: 'STOCK_CARE_YN'			, text:'STOCK_CARE_YN'		, type: 'string'},
			{name: 'RETURN_Q_YN'			, text:'RETURN_Q_YN'		, type: 'string'},
			{name: 'REF_CODE2'				, text:'REF_CODE2'			, type: 'string'},		//defaultValue: INOUT_TYPE_DETAIL(출고유형)의 SUB_CODE를들고REF_CODE2를 참조해옴
			{name: 'EXCESS_RATE'			, text:'EXCESS_RATE'		, type: 'int'},
			{name: 'SRC_ORDER_Q'			, text:'SRC_ORDER_Q'		, type: 'string'},
			{name: 'SOF110T_PRICE'			, text:'SOF110T_PRICE'		, type: 'uniPrice'},
			{name: 'SRQ100T_PRICE'			, text:'SRQ100T_PRICE'		, type: 'uniPrice'},
			{name: 'COMP_CODE'				, text:'COMP_CODE'			, type: 'string'		, defaultValue: UserInfo.compCode, allowBlank: false },
			{name: 'DEPT_CODE'				, text:'DEPT_CODE'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text:'ITEM_ACCOUNT'		, type: 'string'},
			{name: 'GUBUN'					, text:'GUBUN'				, type: 'string'},
			{name: 'SALE_BASIS_P'			, text:'<t:message code="system.label.sales.sellingprice" default="판매단가"/>'				, type: 'uniUnitPrice'	, editable: false},
//			{name: 'PURCHASE_RATE'			, text:'<t:message code="system.label.sales.purchaserate" default="매입율"/>'				, type: 'uniPercent'	, editable: false},
//			{name: 'PURCHASE_P'				, text:'<t:message code="system.label.sales.purchaseprice" default="매입가"/>'				, type: 'uniUnitPrice'	, editable: false},
//			{name: 'SALES_TYPE'				, text:'판매형태'				, type: 'string'		, comboType:'AU', comboCode:'YP09', editable: false},
//			{name: 'PURCHASE_CUSTOM_CODE'	, text:'<t:message code="system.label.sales.purchaseplace" default="매입처"/>'				, type: 'string'		, comboType:'AU', editable: false},
//			{name: 'PURCHASE_TYPE'			, text:'<t:message code="system.label.sales.purchasecondition" default="매입조건"/>'		, type: 'string'		, comboType:'AU', comboCode:'YP09', editable: false},
			{name: 'LOT_YN'					, text:'LOT_YN'				, type: 'string'},
			{name: 'NATION_INOUT'			, text:'NATION_INOUT'		, type: 'string'},
			{name: 'SALE_DATE'				, text:'SALE_DATE'			, type: 'uniDate'},
			{name: 'BARCODE_KEY'			, text:'BARCODE_KEY'		, type: 'string'},
			{name: 'myId'					, text:'myId'				, type: 'string'}
		]
	});
	//마스터 스토어 정의
	var detailStore = Unilite.createStore('s_str105ukrv_mitDetailStore', {
		model	: 's_str105ukrv_mitDetailModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			allDeletable: true,			// 전체 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)) {
					CustomCodeInfo.gsAgentType		= records[0].get("AGENT_TYPE");
					CustomCodeInfo.gsCustCreditYn	= records[0].get("CREDIT_YN") == Ext.isEmpty(records[0].get("CREDIT_YN"))? 0 : records[0].get("CREDIT_YN");
					CustomCodeInfo.gsUnderCalBase	= records[0].get("WON_CALC_BAS");
					CustomCodeInfo.gsTaxInout		= records[0].get("TAX_INOUT");	//세액포함여부
					CustomCodeInfo.gsbusiPrsn		= records[0].get("BUSI_PRSN");	//거래처의 주영업담당
				}
				this.fnOrderAmtSum();
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
		},
		loadStoreRecords: function() {
			var param = panelResult.getValues();
			
			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {
//						panelResult.setLoadRecord(records[0]);
						Ext.getCmp('btnPrint').setDisabled(false);
					}
				}
			});
		},
		fnOrderAmtSum: function() {
			if(!Ext.isEmpty(this.sumBy)) {
				var dtotQty		= 0;
				var dSaleTI		= 0;
				var dSaleNTI	= 0;
				var dTaxI		= 0;
				///* && record.get('TYPE_LEVEL') == '1'*/
				var results = this.sumBy(function(record, id){
											return record.get('TAX_TYPE') == '1';}, 
										['ORDER_UNIT_O','INOUT_TAX_AMT']);
				dSaleTI = results.ORDER_UNIT_O;
				dTaxI	= results.INOUT_TAX_AMT;
				console.log("과세 - 과세된총액:"+dSaleTI);		//과세된총액
				console.log("과세 - 부가세총액:"+dTaxI);		//부가세총액
				
				var results = this.sumBy(function(record, id){
											return record.get('TAX_TYPE') == '2';}, 
										['ORDER_UNIT_O']);
				dSaleNTI = results.ORDER_UNIT_O;
				console.log("면세 - 면세된총액:"+dSaleNTI);	//면세된총액
				
				dtotQty = Ext.isNumeric(this.sum('ORDER_UNIT_Q')) ? this.sum('ORDER_UNIT_Q'):0;	//수량총계
				panelResult.setValue('TOT_SALE_TAXI'	,dSaleTI);								//과세총액(1)
				panelResult.setValue('TOT_SALENO_TAXI'	,dSaleNTI);								//면세총액(3)
				panelResult.setValue('TOT_TAXI'			,dTaxI);								//세액합계(2)
				panelResult.setValue('TOTAL_AMT'		,dSaleTI + dSaleNTI + dTaxI);			//출고총액
//				panelResult.setValue('TOT_QTY'			,dtotQty);   							//수량총계
				
				panelResult.fnCreditCheck();
			}
		}
	});
	//마스터 그리드 정의
	var detailGrid = Unilite.createGrid('s_str105ukrv_mitGrid', {
		store	: detailStore,
		itemId	: 's_str105ukrv_mitGrid',
		selModel: 'rowmodel',
		layout	: 'fit',
		region	: 'center',
		flex	: 1,
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			onLoadSelectFirst	: false,
			copiedRow			: false
		},
		tbar: [{
			xtype	: 'splitbutton',
			itemId	: 'refTool',
			text	: '<t:message code="system.label.sales.reference" default="참조..."/>',
			iconCls	: 'icon-referance',
			menu	: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId	: 'refBtn',
					text	: '<t:message code="system.label.sales.soofferrefer" default="수주(오퍼)참조"/>',
					handler	: function() {
						if(BsaCodeInfo.useLotAssignment == "Y"){
							if(Ext.isEmpty(panelResult.getValue('WH_CODE'))){
								Unilite.messageBox('<t:message code="system.message.sales.message057" default="출고창고를 선택해 주세요."/>');
								return false;
							}else if(Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))){
								Unilite.messageBox('<t:message code="system.message.sales.message058" default="출고창고 Cell을 선택해 주세요."/>');
								return false;
							}
						}
						opensalesOrderWindow();
					}
				},{
					itemId	: 'requestBtn',
					text	: '<t:message code="system.label.sales.shipmentorderrefer" default="출하지시참조"/>',
					hidden	: true,
					handler	: function() {
						openRequestWindow();
					}
				}]
			})
		}],
		features: [ {id: 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: true },
					{id: 'masterGridTotal',		ftype: 'uniSummary',			showSummaryRow: true} ],
		columns: [
				{dataIndex: 'myId'						, width:70 ,hidden: true},
				{dataIndex: 'TYPE_LEVEL'				, width:70 ,hidden: true},
				{dataIndex: 'INOUT_SEQ'					, width:60 ,hidden: true},
				{dataIndex: 'CUSTOM_NAME'				, width:133,hidden: true},
				//20200130 추가
				{dataIndex: 'ORDER_NUM'					, width:120 },
				{dataIndex: 'ORDER_SEQ'					, width:66 , align: 'center' },
				{dataIndex: 'INOUT_TYPE_DETAIL'			, width:80},
				{dataIndex: 'WH_CODE'					, width:93},
				{dataIndex: 'WH_NAME'					, width:93 ,hidden: true},
				{dataIndex: 'WH_CELL_CODE'				, width:120,hidden: sumtypeCell, 
					renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
						combo.store.clearFilter();
						combo.store.filter('option', record.get('WH_CODE'));
					}
				},
				{dataIndex: 'WH_CELL_NAME'				, width:100,hidden: true },
				{dataIndex: 'SALE_DIV_CODE'				, width:100,hidden: true },
				{dataIndex: 'ITEM_CODE'					, width:113, 
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
													detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
												} else {
													UniAppManager.app.onNewDataButtonDown();
													detailGrid.setItemData(record,false, detailGrid.getSelectionModel().getLastSelected());
												}
											}); 
									},
									scope: this
							},
							'onClear': function(type) {
								detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
							},
							'applyextparam': function(popup){
								var divCode = panelResult.getValue('DIV_CODE');
								popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
							}
						}
					})
				},
				{dataIndex: 'ITEM_NAME'					, width:200,
					editor		: Unilite.popup('DIV_PUMOK_G', {
					autoPopup	: true,
					listeners	: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record,false, detailGrid.getSelectionModel().getLastSelected());
									}
								}); 
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode});
						}
					}
				})
				},
				{dataIndex: 'SPEC'						, width:150 },
				{dataIndex: 'LOT_NO'					, width:120,	hidden: false,
					editor: Unilite.popup('LOTNO_G', {
						textFieldName	: 'LOTNO_CODE',
						DBtextFieldName	: 'LOTNO_CODE',
						validateBlank	: false,
						autoPopup		: true,
						listeners		: {
							'onSelected': {
								fn: function(records, type) {
									var rtnRecord;
									Ext.each(records, function(record,i) {
										if(i==0){
											rtnRecord = detailGrid.uniOpt.currentRecord
										}else{
											rtnRecord = detailGrid.getSelectedRecord();
										}
										rtnRecord.set('LOT_NO'				, record['LOT_NO']);
										rtnRecord.set('TEMP_ORDER_UNIT_Q'	, record['STOCK_Q']);
	//									rtnRecord.set('ORDER_UNIT_Q', 0);
										
										rtnRecord.set('WH_CODE'			, record['WH_CODE']);
										rtnRecord.set('WH_CELL_CODE'	, record['WH_CELL_CODE']);
	//									rtnRecord.set('SALE_BASIS_P'	, record['SALE_BASIS_P']);
										rtnRecord.set('LOT_ASSIGNED_YN'	, 'Y');
	//									rtnRecord.set('PURCHASE_RATE'	, record['PURCHASE_RATE']);
	//									rtnRecord.set('PURCHASE_P'		, record['PURCHASE_P']);
	//									rtnRecord.set('SALES_TYPE'		, record['SALES_TYPE']);
	//									rtnRecord.set('PURCHASE_TYPE'	, record['PURCHASE_TYPE']);
	//									rtnRecord.set('PURCHASE_CUSTOM_CODE', record['CUSTOM_CODE']);
	//									if(i==0) {
	//										detailGrid.setLotData(record,false);
	//									}
									});
								},
							scope: this
							},
							'onClear': function(type) {
								var rtnRecord = detailGrid.uniOpt.currentRecord;
								rtnRecord.set('LOT_NO'				, '');
								rtnRecord.set('LOT_ASSIGNED_YN'		, 'N');
								rtnRecord.set('TEMP_ORDER_UNIT_Q'	, '');
							},
							'applyextparam': function(popup){
								var record		= detailGrid.getSelectedRecord();
								var divCode		= panelResult.getValue('DIV_CODE');
								var itemCode	= record.get('ITEM_CODE');
								var itemName	= record.get('ITEM_NAME');
								var whCode		= record.get('WH_CODE');
								var whCellCode	= record.get('WH_CELL_CODE');
								var stockYN		= 'Y'
								popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode, 'S_WH_CELL_CODE': whCellCode, 'STOCK_YN': stockYN});
							}
						}
					})
				},
				{dataIndex: 'ORDER_UNIT'				, width:80, align: 'center',
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
				},
				{dataIndex: 'ORDER_NOT_Q'				, width:93 },
				{dataIndex: 'ISSUE_NOT_Q'				, width:93 },
				{dataIndex: 'ORDER_UNIT_Q'				, width:93, summaryType: 'sum' },
				{dataIndex: 'TRANS_RATE'				, width:60 },
				{dataIndex: 'ORDER_UNIT_P'				, width:100, summaryType: 'sum' },
				{dataIndex: 'ORDER_UNIT_O'				, width:120, summaryType: 'sum' },
				{dataIndex: 'INOUT_TAX_AMT'				, width:120, summaryType: 'sum' },
				{dataIndex: 'ORDER_AMT_SUM'				, width:120, summaryType: 'sum' },
				{dataIndex: 'TAX_TYPE'					, width:80 , align: 'center' },
				{dataIndex: 'STOCK_Q'					, width:100, summaryType: 'sum' },
				{dataIndex: 'DISCOUNT_RATE'				, width:80 },
				{dataIndex: 'ITEM_STATUS'				, width:80, align: 'center' },
				{dataIndex: 'ORDER_STOCK_Q'				, width:100, hidden: true },
				{dataIndex: 'SALE_PRSN'					, width:80 , hidden: true },
				{dataIndex: 'PRICE_TYPE'				, width:110, hidden: true },
				{dataIndex: 'INOUT_WGT_Q'				, width:106, hidden: true },
				{dataIndex: 'INOUT_FOR_WGT_P'			, width:106, hidden: true },
				{dataIndex: 'INOUT_VOL_Q'				, width:106, hidden: true },
				{dataIndex: 'INOUT_FOR_VOL_P'			, width:106, hidden: true },
				{dataIndex: 'INOUT_WGT_P'				, width:106, hidden: true },
				{dataIndex: 'INOUT_VOL_P'				, width:106, hidden: true },
				{dataIndex: 'WGT_UNIT'					, width:66 , hidden: true },
				{dataIndex: 'UNIT_WGT'					, width:100, hidden: true },
				{dataIndex: 'VOL_UNIT'					, width:80 , hidden: true },
				{dataIndex: 'UNIT_VOL'					, width:93 , hidden: true },
				{dataIndex: 'TRANS_COST'				, width:93 , hidden: true },
				{dataIndex: 'PRICE_YN'					, width:73 , hidden: true },
				{dataIndex: 'ACCOUNT_YNC'				, width:73 , hidden: false },
				{dataIndex: 'DELIVERY_DATE'				, width:80 , hidden: true },
				{dataIndex: 'DELIVERY_TIME'				, width:66 , hidden: true },
				{dataIndex: 'RECEIVER_ID'				, width:86 , hidden: true },
				{dataIndex: 'RECEIVER_NAME'				, width:86 , hidden: true },
				{dataIndex: 'TELEPHONE_NUM1'			, width:80 , hidden: true },
				{dataIndex: 'TELEPHONE_NUM2'			, width:80 , hidden: true },
				{dataIndex: 'ADDRESS'					, width:133, hidden: true },
				{dataIndex: 'SALE_CUST_CD'				, width:110, hidden: true },
				{dataIndex: 'DVRY_CUST_CD'				, width:113, hidden: true },
				{dataIndex: 'DVRY_CUST_NAME'			, width:113, hidden: true },
				{dataIndex: 'ORDER_CUST_CD'				, width:113, hidden: true },
				{dataIndex: 'PLAN_NUM'					, width:100, hidden: true },
				{dataIndex: 'ISSUE_REQ_NUM'				, width:100, hidden: true },
				{dataIndex: 'BASIS_NUM'					, width:100, hidden: true },
				{dataIndex: 'PAY_METHODE1'				, width:200, hidden: true },
				{dataIndex: 'LC_SER_NO'					, width:100, hidden: true },
				{dataIndex: 'REMARK'					, width:100, hidden: true },
				{dataIndex: 'LOT_ASSIGNED_YN'			, width:100, hidden: true },
				{dataIndex: 'INOUT_NUM'					, width:80 , hidden: true },
				{dataIndex: 'INOUT_DATE'				, width:66 , hidden: true },
				{dataIndex: 'INOUT_METH'				, width:66 , hidden: true },
				{dataIndex: 'INOUT_TYPE'				, width:66 , hidden: true },
				{dataIndex: 'DIV_CODE'					, width:66 , hidden: true },
				{dataIndex: 'INOUT_CODE_TYPE'			, width:66 , hidden: true },
				{dataIndex: 'INOUT_CODE'				, width:66 , hidden: true },
				{dataIndex: 'SALE_CUSTOM_CODE'			, width:66 , hidden: true },
				{dataIndex: 'CREATE_LOC'				, width:66 , hidden: true },
				{dataIndex: 'UPDATE_DB_USER'			, width:66 , hidden: true },
				{dataIndex: 'UPDATE_DB_TIME'			, width:66 , hidden: true },
				{dataIndex: 'MONEY_UNIT'				, width:66 , hidden: true },
				{dataIndex: 'EXCHG_RATE_O'				, width:66 , hidden: true },
				{dataIndex: 'ORIGIN_Q'					, width:66 , hidden: true },
				{dataIndex: 'ORDER_NOT_Q'				, width:66 , hidden: true },
				{dataIndex: 'ISSUE_NOT_Q'				, width:66 , hidden: true },
				{dataIndex: 'ISSUE_REQ_SEQ'				, width:66 , hidden: true },
				{dataIndex: 'BASIS_SEQ'					, width:66 , hidden: true },
				{dataIndex: 'ORDER_TYPE'				, width:66 , hidden: true },
				{dataIndex: 'STOCK_UNIT'				, width:66 , hidden: true },
				{dataIndex: 'BILL_TYPE'					, width:66 , hidden: true },
				{dataIndex: 'SALE_TYPE'					, width:66 , hidden: true },
				{dataIndex: 'CREDIT_YN'					, width:66 , hidden: true },
				{dataIndex: 'ACCOUNT_Q'					, width:66 , hidden: true },
				{dataIndex: 'SALE_C_YN'					, width:66 , hidden: true },
				{dataIndex: 'INOUT_PRSN'				, width:66 , hidden: true },
				{dataIndex: 'WON_CALC_BAS'				, width:66 , hidden: true },
				{dataIndex: 'TAX_INOUT'					, width:66 , hidden: true },
				{dataIndex: 'AGENT_TYPE'				, width:66 , hidden: true },
				{dataIndex: 'STOCK_CARE_YN'				, width:66 , hidden: true },
				{dataIndex: 'RETURN_Q_YN'				, width:66 , hidden: true },
				{dataIndex: 'REF_CODE2'					, width:66 , hidden: true },
				{dataIndex: 'EXCESS_RATE'				, width:66 , hidden: true },
				{dataIndex: 'SRC_ORDER_Q'				, width:66 , hidden: true },
				{dataIndex: 'SOF110T_PRICE'				, width:66 , hidden: true },
				{dataIndex: 'SRQ100T_PRICE'				, width:66 , hidden: true },
				{dataIndex: 'COMP_CODE'					, width:66 , hidden: true },
				{dataIndex: 'DEPT_CODE'					, width:66 , hidden: true },
				{dataIndex: 'ITEM_ACCOUNT'				, width:66 , hidden: true },
				{dataIndex: 'GUBUN'						, width:66 , hidden: true },
				{dataIndex: 'TEMP_ORDER_UNIT_Q'			, width:66 , hidden: true },
//				{dataIndex: 'PURCHASE_CUSTOM_CODE'		, width:66 , hidden: true },
//				{dataIndex: 'PURCHASE_TYPE'				, width:66 , hidden: true },
				{dataIndex: 'LOT_YN'					, width:66 , hidden: true },
				{dataIndex: 'NATION_INOUT'				, width:66 , hidden: true },
				{dataIndex: 'SALE_DATE'					, width:66 , hidden: true }
		],
		//20200305: 바코드 읽은 데이터는 색깔로 표시
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){		//오류 row 빨간색 표시
				var cls = '';
				var val = record.get('myId');
				if(!Ext.isEmpty(val)) {
					cls = 'x-change-cell_Read';
				}
				return cls;
			}
		},
		listeners: {
			render: function(grid, eOpts){
				var girdNm	= grid.getItemId();
				var store	= grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
					//store.onStoreActionEnable();
					if( barcodeStore.isDirty() ) {
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
					if(grid.getStore().getCount() > 0) {
						UniAppManager.setToolbarButtons('delete', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
					
					if(gsSaveFlag) {
						UniAppManager.setToolbarButtons('save', true);
					} else {
						UniAppManager.setToolbarButtons('save', false);
					}
				});
			},
			beforeedit	: function( editor, e, eOpts ) {
//				cbStore.loadStoreRecords(e.record.get('WH_CODE'));
//				var record = detailGrid.uniOpt.currentRecord;
				//LOT_NO POPUP에서 출고창고 필수조건 아님(20171211 수정)
				if (UniUtils.indexOf(e.field, 'LOT_NO')){
//					if(Ext.isEmpty(e.record.data.WH_CODE)){
//						Unilite.messageBox('출고창고를 입력하십시오.');
//						return false;
//					}
					if(BsaCodeInfo.gsSumTypeCell == 'Y' && Ext.isEmpty(e.record.data.WH_CELL_CODE)){
						Unilite.messageBox('<t:message code="system.message.sales.message059" default="출고창고 CELL코드를 입력하십시오."/>');
						return false;
					}
					if(Ext.isEmpty(e.record.data.ITEM_CODE)){
						Unilite.messageBox('<t:message code="system.message.sales.message024" default="품목코드를 입력하십시오."/>');
						return false;
					}
				}
				if(e.record.phantom){			//신규일때
					if(e.record.data.INOUT_METH == '2' && Ext.isEmpty(e.record.data.myId)){	//예외등록(추가버튼)
						 if (UniUtils.indexOf(e.field, 
											['SPEC', 'STOCK_Q', 'ORDER_CUST_CD', 'PLAN_NUM', 'ORDER_NUM', 'ISSUE_REQ_NUM', 'BASIS_NUM',
											 /*'PRICE_YN',*/ 'TRANS_RATE', 'ORDER_NOT_Q', 'ISSUE_NOT_Q', 'ORDER_UNIT_Q', 'ORDER_UNIT_O',
											 'INOUT_TAX_AMT', 'ORDER_AMT_SUM']))
							return false; 
						
						if(e.record.data.ACCOUNT_YNC == 'N'){//매출대상이 아닌 경우, 쓰기 불가
							if (UniUtils.indexOf(e.field, 
											['ORDER_UNIT_P', 'ORDER_UNIT_O', 'INOUT_TAX_AMT']))
								return false;
						}	
						
						if(!Ext.isEmpty(e.record.data.GUBUN)){
							if (UniUtils.indexOf(e.field, 
											['PRICE_TYPE', 'WGT_UNIT', 'VOL_UNIT']))
								return false;
						}
						
					} else {	//INOUT_METH = '1'	//참조등록
						if (UniUtils.indexOf(e.field,['ACCOUNT_YNC', 'REMARK'])) {
							return true;
						}
						return false;
					} 
				}else{ //신규가 아닐때
					if (UniUtils.indexOf(e.field,['ACCOUNT_YNC'])) {
						return true;
					}
					return false;
				}
			},
//			cellclick	: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ){			//콤보값이 안나오는 현상 발생하여 아래 selectionChange로 변경
//			select: function(grid, selected, index, rowIndex, eOpts ){
			selectionChange: function( gird, selected, eOpts ) {
				barcodeStore.clearFilter();
				if(UniAppManager.app._needSave()) {
					gsSaveFlag = true;
				} else {
					gsSaveFlag = false;
				}
				//선택된 행의 저장된 데이터만 barcodeGrid에 보여주도록 filter
				if(!Ext.isEmpty(selected)) {
					barcodeStore.filterBy(function(record){
						return record.get('BARCODE_KEY') == selected[0].get('myId');
					})
				}
//				var colName = e.position.column.dataIndex;
//				if(colName == 'INOUT_NUM') {
				panelResult.getField('BARCODE').focus();
//				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
//			var grdRecord = this.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		,"");
				grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,""); 
				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('ORDER_UNIT_Q'	,"0");
				grdRecord.set('ORDER_UNIT_P'	,"0");
//				grdRecord.set('SALE_BASIS_P'	,"0");
				grdRecord.set('ORDER_UNIT_O'	,"0");
				grdRecord.set('INOUT_TAX_AMT'	,"0");
				grdRecord.set('STOCK_UNIT'		,"");
//				grdRecord.set('WH_CODE'			,"");
//				grdRecord.set('WH_CELL_CODE'	,"");
//				grdRecord.set('WH_CELL_NAME'	,"");
				grdRecord.set('TAX_TYPE'		,"1");
				grdRecord.set('TRANS_RATE'		,"1");
				grdRecord.set('STOCK_CARE_YN'	,"");
				grdRecord.set('WGT_UNIT'		,"");
				grdRecord.set('UNIT_WGT'		,0);
				grdRecord.set('VOL_UNIT'		,"");
				grdRecord.set('UNIT_VOL'		,0);
				grdRecord.set('INOUT_WGT_Q'		,0);
				grdRecord.set('INOUT_FOR_WGT_P'	,0);
				grdRecord.set('INOUT_WGT_P'		,0);
				grdRecord.set('INOUT_VOL_Q'		,0);
				grdRecord.set('INOUT_FOR_VOL_P'	,0);
				grdRecord.set('INOUT_VOL_P'		,0);	
				grdRecord.set('LOT_YN'			, '');
			} else {
				var sRefWhCode = ''
				if(BsaCodeInfo.gsRefWhCode == "2"){
					sRefWhCode = Ext.data.StoreManager.lookup('whList').getAt(0).get('value'); //창고콤보value중 첫번째 value
				}	   			
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('SPEC'				, record['SPEC']); 
				grdRecord.set('ORDER_UNIT'			, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);	
				
				if(Ext.isEmpty(grdRecord.get('WH_CODE'))){		//창고를 이미 입력했을 경우는 창고정보를 적용하지 않는다.
					if(BsaCodeInfo.gsRefWhCode == "2"){			//멀티품목팝업시 출고창고 참조방법 '2'인 경우(2=첫번째행의 출고창고)
						grdRecord.set('WH_CODE', sRefWhCode);
						grdRecord.set('WH_NAME', UniAppManager.app.fnGetWhName(record['WH_CODE']));	
//						grdRecord.set('WH_CELL_CODE', '');
//						grdRecord.set('WH_CELL_NAME', '');
						grdRecord.set('LOT_NO', '');
						grdRecord.set('CELL_STOCK_Q', '0');
					}else{										//멀티품목팝업시 출고창고 참조방법 '1'인 경우(1=품목의 주창고)						
						grdRecord.set('WH_CODE', record['WH_CODE']);
						grdRecord.set('WH_NAME', UniAppManager.app.fnGetWhName(record['WH_CODE']));	
//						grdRecord.set('WH_CELL_CODE', '');
//						grdRecord.set('WH_CELL_NAME', '');
						grdRecord.set('LOT_NO', '');
					}
				}				
				grdRecord.set('TAX_TYPE'	 , record['TAX_TYPE']);
				grdRecord.set('STOCK_CARE_YN', record['STOCK_CARE_YN']);
				grdRecord.set('DIV_CODE'	 , record['DIV_CODE']);
				grdRecord.set('ITEM_ACCOUNT' , record['ITEM_ACCOUNT']);
				if((Ext.isEmpty(record['WGT_UNIT']))){
					grdRecord.set('WGT_UNIT'	 , '');
					grdRecord.set('UNIT_WGT'	 , record['UNIT_WGT']);
				}else{
					grdRecord.set('WGT_UNIT'	 , record['WGT_UNIT']);
					grdRecord.set('UNIT_WGT'	 , record['UNIT_WGT']);
				}
				if((Ext.isEmpty(record['VOL_UNIT']))){
					grdRecord.set('VOL_UNIT'	 , '');
					grdRecord.set('UNIT_VOL'	 , record['UNIT_VOL']);
				}else{
					grdRecord.set('VOL_UNIT'	 , record['VOL_UNIT']);
					grdRecord.set('UNIT_VOL'	 , record['UNIT_VOL']);
				}
//				grdRecord.set('SALE_BASIS_P'	,record['SALE_BASIS_P']);
				if(record['STOCK_CARE_YN'] == "Y"){
					UniSales.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), grdRecord.get('ITEM_STATUS'), grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE'));
				}
				grdRecord.set('LOT_YN'	 , record['LOT_YN']);
				
				////Call fnSetLotNoEssential(lRow) 들어가야함
				UniSales.fnGetDivPriceInfo2(
					 grdRecord
				   , UniAppManager.app.cbGetPriceInfo
				   , 'I'
				   , UserInfo.compCode
				   , grdRecord.get('INOUT_CODE')
				   , grdRecord.get('AGENT_TYPE')
				   , grdRecord.get('ITEM_CODE')
				   , BsaCodeInfo.gsMoneyUnit
				   , grdRecord.get('ORDER_UNIT')
				   , grdRecord.get('STOCK_UNIT')
				   , grdRecord.get('TRANS_RATE')
				   , UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'))
				   , grdRecord.get('ORDER_UNIT_Q')
				   , grdRecord.get('WGT_UNIT')
				   , grdRecord.get('VOL_UNIT')
				   , grdRecord.get('UNIT_WGT')
				   , grdRecord.get('UNIT_VOL')
				   , grdRecord.get('PRICE_TYPE')
				   , grdRecord.get('PRICE_YN')
				)
			}
		},
		setrequestData:function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('INOUT_TYPE'			, "2");
			grdRecord.set('INOUT_METH'			, "1");
			grdRecord.set('INOUT_CODE_TYPE'		, "4");
			grdRecord.set('CREATE_LOC'			, panelResult.getValue('CREATE_LOC'));
			grdRecord.set('DIV_CODE'			, panelResult.getValue('DIV_CODE'));
			grdRecord.set('INOUT_CODE'			, panelResult.getValue('CUSTOM_CODE'));
			grdRecord.set('CUSTOM_NAME'			, panelResult.getValue('CUSTOM_NAME'));
			grdRecord.set('INOUT_DATE'			, panelResult.getValue('INOUT_DATE'));
			grdRecord.set('INOUT_NUM'			, panelResult.getValue('INOUT_NUM'));
			grdRecord.set('REF_CODE2'			, record['REF_CODE2']);
			
			if(Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
				grdRecord.set('WH_CODE', record['WH_CODE']);
				grdRecord.set('WH_NAME', record['WH_CODE']);
			} else {
				grdRecord.set('WH_CODE', panelResult.getValue('WH_CODE'));
				grdRecord.set('WH_NAME', panelResult.getValue('WH_CODE'));
			}
			
			if(BsaCodeInfo.gsSumTypeCell == "Y"){
				grdRecord.set('WH_CELL_CODE'		, record['WH_CELL_CODE']);
				grdRecord.set('WH_CELL_NAME'		, record['WH_CELL_NAME']);
			}else{
				grdRecord.set('WH_CELL_CODE'		, "");
				grdRecord.set('WH_CELL_NAME'		, "");
			} 
			
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ITEM_STATUS'			, "1");
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);
			//출하지시참조 시, 출하지시량은 0으로 SET: 바코드 스캔한 값 +하기 위해
			grdRecord.set('ORDER_UNIT_Q'		, 0);
//			grdRecord.set('ORDER_UNIT_Q'		, record['NOT_REQ_Q']);
			grdRecord.set('ORIGIN_Q'			, record['NOT_REQ_Q']);
			grdRecord.set('ORDER_NOT_Q'			, "0");
			grdRecord.set('ISSUE_NOT_Q'			, record['NOT_REQ_Q']);
			grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);
			grdRecord.set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
			grdRecord.set('ACCOUNT_YNC'			, record['ACCOUNT_YNC']);
			grdRecord.set('DELIVERY_DATE'		, record['ISSUE_DATE']);
			grdRecord.set('SALE_CUSTOM_CODE'	, record['SALE_CUSTOM_CODE']);
			grdRecord.set('SALE_CUST_CD'		, record['SALE_CUST_CD']);
			grdRecord.set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);
			grdRecord.set('DVRY_CUST_NAME'		, record['DVRY_CUST_NAME']);
			grdRecord.set('ORDER_CUST_CD'		, record['ORDER_CUST_CD']);
			grdRecord.set('PLAN_NUM'			, record['PROJECT_NO']);
			grdRecord.set('ISSUE_REQ_NUM'		, record['ISSUE_REQ_NUM']);
			grdRecord.set('BASIS_NUM'			, record['PO_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['PO_SEQ']);
			
			if(BsaCodeInfo.gsOptDivCode == "1"){
				grdRecord.set('SALE_DIV_CODE'		, record['ISSUE_DIV_CODE']);
			}else{
				grdRecord.set('SALE_DIV_CODE'		, record['DIV_CODE']);
			}
			
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('EXCHG_RATE_O'		, panelResult.getValue('EXCHG_RATE_O'));
			grdRecord.set('ISSUE_REQ_SEQ'		, record['ISSUE_REQ_SEQ']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['SER_NO']);
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('BILL_TYPE'			, record['BILL_TYPE']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
			grdRecord.set('SALE_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('SALE_PRSN'			, record['ISSUE_REQ_PRSN']);
			grdRecord.set('INOUT_PRSN'			, panelResult.getValue('INOUT_PRSN'));
			grdRecord.set('ACCOUNT_Q'			, "0");
			grdRecord.set('SALE_C_YN'			, "N");
			grdRecord.set('CREDIT_YN'			, CustomCodeInfo.gsCustCreditYn);
			grdRecord.set('WON_CALC_BAS'		, CustomCodeInfo.gsUnderCalBase);
			grdRecord.set('PAY_METHODE1'		, record['PAY_METHODE1']);
			grdRecord.set('LC_SER_NO'			, record['LC_SER_NO']);

			if(record['SOF100_TAX_INOUT'] == ""){
				if(record['TAX_INOUT'] == "") {
					grdRecord.set('TAX_INOUT'		, CustomCodeInfo.gsTaxInout);
				} else {
					grdRecord.set('TAX_INOUT'		, record['TAX_INOUT']);
				}
			} else {
				grdRecord.set('TAX_INOUT'		, record['SOF100_TAX_INOUT']);
			}
			
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('AGENT_TYPE'			, record['AGENT_TYPE']);
			grdRecord.set('DEPT_CODE'			, record['DEPT_CODE']);
			grdRecord.set('STOCK_CARE_YN'		, record['STOCK_CARE_YN']);
			grdRecord.set('UPDATE_DB_USER'		, UserInfo.userID);
			grdRecord.set('RETURN_Q_YN'			, record['RETURN_Q_YN']);
			grdRecord.set('SRC_ORDER_Q'			, record['ORDER_Q']);
			grdRecord.set('EXCESS_RATE'			, record['EXCESS_RATE']);
			grdRecord.set('PRICE_TYPE'			, record['PRICE_TYPE']);
			grdRecord.set('INOUT_FOR_WGT_P'		, record['ISSUE_FOR_WGT_P']);
			grdRecord.set('INOUT_FOR_VOL_P'		, record['ISSUE_FOR_VOL_P']);
			grdRecord.set('INOUT_WGT_P'			, record['ISSUE_WGT_P']);
			grdRecord.set('INOUT_VOL_P'			, record['ISSUE_VOL_P']);
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
			
			//출고량(중량) 재계산
			var sInout_q = grdRecord.get('ORDER_UNIT_Q');
			var sUnitWgt = grdRecord.get('UNIT_WGT');
			var sOrderWgtQ = sInout_q * sUnitWgt;
			grdRecord.set('INOUT_WGT_Q'			, sOrderWgtQ);
			
			//출고량(부피) 재계산
			var sUnitVol = grdRecord.get('UNIT_VOL');
			var sOrderVolQ = sInout_q * sUnitVol;
			grdRecord.set('INOUT_VOL_Q'			, sOrderVolQ);
			
			if(grdRecord.get('ACCOUNT_YNC') == "N"){
				grdRecord.set('ORDER_UNIT_P'	, 0);
			}else{
				grdRecord.set('ORDER_UNIT_P'	, record['ISSUE_FOR_PRICE']);
//				grdRecord.set('ORDER_UNIT_P'	, record['ISSUE_REQ_PRICE']);
			}
			
			if(record['ORDER_Q'] != record['NOT_REQ_Q']){
				UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
			}else{
				if(record['ACCOUNT_YNC'] == "N"){
					grdRecord.set('ORDER_UNIT_O'	, 0);
					grdRecord.set('INOUT_TAX_AMT'	, 0);
				}else{
					grdRecord.set('ORDER_UNIT_O'	, record['ISSUE_FOR_AMT']);
//					grdRecord.set('ORDER_UNIT_O'	, record['ISSUE_REQ_AMT']);
//					grdRecord.set('INOUT_TAX_AMT'	, record['ISSUE_REQ_TAX_AMT']);
				}
				//20171211 합계금액 표시를 위해 함수 호출
				UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
			}
			grdRecord.set('COMP_CODE'		, UserInfo.compCode);
			grdRecord.set('REMARK'			, record['REMARK']);
			grdRecord.set('TRANS_COST'		, "0");	
			grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
			grdRecord.set('GUBUN'			, "FEFER");
			grdRecord.set('INOUT_TYPE_DETAIL'	, record['INOUT_TYPE_DETAIL']);
			
			var lRate = record['TRANS_RATE'];
			if(lRate == 0){
				lRate = 1;
			}
			grdRecord.set('STOCK_Q'	, record['STOCK_Q'] / lRate);
		},
		setSalesOrderData: function(record) { 
			var grdRecord = this.getSelectedRecord();
			
			panelResult.setValue('NATION_INOUT'	, record['NATION_INOUT']);
			panelResult.setValue('EXCHG_RATE_O'	, record['EXCHG_RATE_O']);
//			panelResult.setValue('WH_CODE'		, record['WH_CODE']);
//			panelResult.setValue('WH_CELL_CODE'	, record['WH_CELL_CODE']);
			panelResult.setValue('NATION_CODE'	, record['NATION_CODE']);

			grdRecord.set('INOUT_TYPE'			, "2");
			grdRecord.set('INOUT_METH'			, "1");
			grdRecord.set('INOUT_CODE_TYPE'		, "4");
			grdRecord.set('CREATE_LOC'			, panelResult.getValue('CREATE_LOC'));
			grdRecord.set('DIV_CODE'			, panelResult.getValue('DIV_CODE'));
			grdRecord.set('INOUT_CODE'			, panelResult.getValue('CUSTOM_CODE'));
			grdRecord.set('CUSTOM_NAME'			, panelResult.getValue('CUSTOM_NAME'));
			grdRecord.set('INOUT_DATE'			, panelResult.getValue('INOUT_DATE'));
			grdRecord.set('INOUT_NUM'			, panelResult.getValue('INOUT_NUM'));
			grdRecord.set('NATION_INOUT'		, panelResult.getValue('NATION_INOUT'));
			grdRecord.set('EXCHG_RATE_O'		, record['EXCHG_RATE_O']);
			var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
			var sRefCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2
			
			if(record['INOUT_TYPE_DETAIL'] > ""){
				grdRecord.set('INOUT_TYPE_DETAIL'	, record['INOUT_TYPE_DETAIL']);
			}else{
				grdRecord.set('INOUT_TYPE_DETAIL'	, inoutTypeDetail);
			}			
			
			grdRecord.set('REF_CODE2'			, sRefCode2);
			
			if(Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
				grdRecord.set('WH_CODE', record['WH_CODE']);
				grdRecord.set('WH_NAME', record['WH_CODE']);
			} else {
				grdRecord.set('WH_CODE', panelResult.getValue('WH_CODE'));
				grdRecord.set('WH_NAME', panelResult.getValue('WH_CODE'));
			}

			grdRecord.set('WH_CELL_CODE'		, panelResult.getValue('WH_CELL_CODE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ITEM_STATUS'			, "1");
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);
			//수주참조 시, 출고량은 0으로 SET: 바코드 스캔한 값 +하기 위해
			grdRecord.set('ORDER_UNIT_Q'		, 0);
//			grdRecord.set('ORDER_UNIT_Q'		, record['R_ALLOC_Q']);
			grdRecord.set('ORIGIN_Q'			, record['R_ALLOC_Q']);
			grdRecord.set('ORDER_NOT_Q'			, record['R_ALLOC_Q']);
			grdRecord.set('ISSUE_NOT_Q'			, "0");
			grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);
			grdRecord.set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
			grdRecord.set('ACCOUNT_YNC'			, record['ACCOUNT_YNC']);
			grdRecord.set('SALE_CUSTOM_CODE'	, record['SALE_CUST_CD']);
			grdRecord.set('SALE_CUST_CD'		, record['SALE_CUST_NM']);
			grdRecord.set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);
			grdRecord.set('DVRY_CUST_NAME'		, record['DVRY_CUST_NAME']);
			grdRecord.set('ORDER_CUST_CD'		, record['CUSTOM_NAME']);
			grdRecord.set('PLAN_NUM'			, record['PROJECT_NO']);
			grdRecord.set('BASIS_NUM'			, record['PO_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['PO_SEQ']);
			
			if(BsaCodeInfo.gsOptDivCode == "1"){
				grdRecord.set('SALE_DIV_CODE'		, record['OUT_DIV_CODE']);
			}else{
				grdRecord.set('SALE_DIV_CODE'		, record['DIV_CODE']);
			}
			
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('EXCHG_RATE_O'		, panelResult.getValue('EXCHG_RATE_O'));
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['SER_NO']);
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('BILL_TYPE'			, record['BILL_TYPE']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
			if(panelResult.getValue('CREATE_LOC') == "5"){
			   grdRecord.set('SALE_TYPE'		, '60');
			}else{
			   grdRecord.set('SALE_TYPE'		, record['ORDER_TYPE']);
			}			
			grdRecord.set('SALE_PRSN'			, record['ORDER_PRSN']);
			grdRecord.set('INOUT_PRSN'			, panelResult.getValue('INOUT_PRSN'));
			grdRecord.set('ACCOUNT_Q'			, "0");
			grdRecord.set('SALE_C_YN'			, "N");
			grdRecord.set('CREDIT_YN'			, CustomCodeInfo.gsCustCreditYn);
			grdRecord.set('WON_CALC_BAS'		, CustomCodeInfo.gsUnderCalBase);
			grdRecord.set('TAX_INOUT'			, record['TAX_INOUT']);
			grdRecord.set('AGENT_TYPE'			, record['AGENT_TYPE']);
			grdRecord.set('DEPT_CODE'			, record['DEPT_CODE']);
			grdRecord.set('STOCK_CARE_YN'		, record['STOCK_CARE_YN']);
			grdRecord.set('UPDATE_DB_USER'		, record['USER_ID']);
			grdRecord.set('RETURN_Q_YN'			, record['RETURN_Q_YN']);
			grdRecord.set('SRC_ORDER_Q'			, record['ORDER_Q']);
			grdRecord.set('EXCESS_RATE'			, record['EXCESS_RATE']);
			
			if(grdRecord.get('ACCOUNT_YNC') == "N"){
				grdRecord.set('ORDER_UNIT_P'	, 0);
			}else{
				grdRecord.set('ORDER_UNIT_P'	, record['R_ORDER_P']);
			}			
			
			if(record['ORDER_Q'] != record['R_ALLOC_Q']){  
				UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
			}
			
			if(record['ACCOUNT_YNC'] == "N"){
				grdRecord.set('ORDER_UNIT_O'	, 0);
				grdRecord.set('INOUT_TAX_AMT'	, 0);
			}else{
				grdRecord.set('ORDER_UNIT_O'	, record['R_ORDER_O']);
				grdRecord.set('INOUT_TAX_AMT'	, record['R_ORDER_TAX_O']);
			}
			
			
			grdRecord.set('PRICE_TYPE'			, record['PRICE_TYPE']);
			grdRecord.set('INOUT_FOR_WGT_P'		, record['ORDER_FOR_WGT_P']);
			grdRecord.set('INOUT_FOR_VOL_P'		, record['ORDER_FOR_VOL_P']);
			grdRecord.set('INOUT_WGT_P'			, record['ORDER_WGT_P']);
			grdRecord.set('INOUT_VOL_P'			, record['ORDER_VOL_P']);
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
			
			var sInout_q = grdRecord.get('ORDER_UNIT_Q');
			//출고량(중량) 재계산
			var sUnitWgt = grdRecord.get('UNIT_WGT');
			var sOrderWgtQ = sInout_q * sUnitWgt;
			grdRecord.set('INOUT_WGT_Q'			, sOrderWgtQ);
			
			//출고량(부피) 재계산
			var sUnitVol = grdRecord.get('UNIT_VOL');
			var sOrderVolQ = sInout_q * sUnitVol
			grdRecord.set('INOUT_VOL_Q'			, sOrderVolQ);
			
			grdRecord.set('COMP_CODE'			, UserInfo.compCode);
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PAY_METHODE1'		, record['PAY_METHODE1']);
			grdRecord.set('LC_SER_NO'			, record['LC_SER_NO']);
			grdRecord.set('TRANS_COST'			, "0");
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			grdRecord.set('GUBUN'				, "FEFER");
			
			var lRate = record['TRANS_RATE'];
			if(lRate == 0){
				lRate = 1;
			}
			grdRecord.set('STOCK_Q'			, record['STOCK_Q']); 
			grdRecord.set('ORDER_STOCK_Q'	, record['STOCK_Q'] / lRate);
			grdRecord.set('LOT_YN'			, record['LOT_YN']);
			grdRecord.set('LOT_NO'			, record['R_LOT_NO']);

			grdRecord.set('myId'			, record['myId']);

			UniAppManager.app.fnOrderAmtCal(grdRecord, "P")
		}
	});




	var barcodeStore = Unilite.createStore('s_str105ukrv_mitBarcodeStore', {
		model	: 's_str105ukrv_mitDetailModel',
		proxy	: directProxy2,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			allDeletable: true,			// 전체 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				detailStore.fnOrderAmtSum();
				if(!Ext.isEmpty(records)) {
					gsMaxInoutSeq = records[0].get('MAX_INOUT_SEQ');
				}
				panelResult.getField('BARCODE').focus();
			},
			add: function(store, records, index, eOpts) {
				detailStore.fnOrderAmtSum();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				detailStore.fnOrderAmtSum();
			},
			remove: function(store, record, index, isMove, eOpts) {
				detailStore.fnOrderAmtSum();
			}
		},
		loadStoreRecords: function() {
			var param = panelResult.getValues();
			
			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {
						//FIFO 위한 데이터 생성 (초기화)
//						gsLotNoS = ''
						panelResult.setValue('LOT_NO_S', '');
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
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var orderNum = panelResult.getValue('INOUT_NUM');
			var isErr = false;
			Ext.each(list, function(record, index) {
				if(record.get('ACCOUNT_YNC') == 'Y') {
					if(record.get('ORDER_UNIT_P') == 0) {
						Unilite.messageBox((index + 1) + '<t:message code="system.message.sales.message060" default="행의 입력값을 확인해 주세요."/>\n' + '<t:message code="system.label.sales.price" default="단가"/>: <t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
						isErr = true;
					}
					if(record.get('ORDER_UNIT_O') == 0) {
						Unilite.messageBox((index + 1) + '<t:message code="system.message.sales.message060" default="행의 입력값을 확인해 주세요."/>\n' + '<t:message code="system.label.sales.amount" default="금액"/>: <t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
						isErr = true;
					}
				}
				if(record.data['INOUT_NUM'] != orderNum) {
					record.set('INOUT_NUM', orderNum);
				}
				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
					Unilite.messageBox((index + 1) + '<t:message code="system.message.sales.message060" default="행의 입력값을 확인해 주세요."/>', 'LOT NO:' + '<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					isErr = true;
					return false;
				}
			});
			if(isErr) return false;
			
//			var totRecords = detailStore.data.items;
//			Ext.each(totRecords, function(record, index) {
//				record.set('SORT_SEQ', index+1);
//			});
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("INOUT_NUM", master.INOUT_NUM);
						
//						var inoutNum = panelResult.getValue('INOUT_NUM');
//						Ext.each(list, function(record, index) {
//							if(record.data['INOUT_NUM'] != inoutNum) {
//								record.set('INOUT_NUM', inoutNum);
//							}
//						})
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						Ext.getCmp('btnPrint').setDisabled(false);//출력버튼 활성화
						UniAppManager.setToolbarButtons('save', false);	
						detailStore.loadStoreRecords();
						barcodeStore.loadStoreRecords();
						if(detailStore.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}
					} 
				};
				this.syncAllDirect(config);
			} else {
				barcodeGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var barcodeGrid = Unilite.createGrid('s_str105ukrv_mitBarcodeGrid', {
		store	: barcodeStore,
		itemId	: 's_str105ukrv_mitBarcodeGrid',
		layout	: 'fit',
		region	: 'south',
		split	: true,
		flex	: 0.5,
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: true,
			onLoadSelectFirst	: false,
			userToolbar			: false,
			copiedRow			: true
		},
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false},
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: false} ],
		columns: [
			{dataIndex: 'INOUT_SEQ'				,width:60	,align: 'center'},
			{dataIndex: 'CUSTOM_NAME'			,width:133	,hidden: true},
			{dataIndex: 'INOUT_TYPE_DETAIL'		,width:80	,hidden: true},
			{dataIndex: 'WH_CODE'				,width:93	,hidden: true},
			{dataIndex: 'WH_NAME'				,width:93 	,hidden: true},
			{dataIndex: 'WH_CELL_CODE'			,width:120	,hidden: true},
			{dataIndex: 'WH_CELL_NAME'			,width:100	,hidden: true},
			{dataIndex: 'SALE_DIV_CODE'			,width:100	,hidden: true},
			{dataIndex: 'ITEM_CODE'				,width:113 },
			{dataIndex: 'ITEM_NAME'				,width:200 },
			{dataIndex: 'SPEC'					,width:150 },
			{dataIndex: 'LOT_NO'				,width:120 },
			{dataIndex: 'DISCOUNT_RATE'			,width:80	,hidden: true},
			{dataIndex: 'ORDER_UNIT'			,width:80	,align: 'center'},
			{dataIndex: 'ORDER_UNIT_Q'			,width:93},
			//저장 시, 필요한 컬럼 (HIDDEN)
			{dataIndex: 'ITEM_STATUS'			,width:66	,hidden: true},
			{dataIndex: 'ORDER_NOT_Q'			,width:66	,hidden: true},
			{dataIndex: 'ISSUE_NOT_Q'			,width:66	,hidden: true},
			{dataIndex: 'TRANS_RATE'			,width:66	,hidden: true},
			{dataIndex: 'ORDER_UNIT_P'			,width:66	,hidden: true},
			{dataIndex: 'ORDER_UNIT_O'			,width:66	,hidden: true},
			{dataIndex: 'INOUT_TAX_AMT'			,width:66	,hidden: true},
			{dataIndex: 'ORDER_AMT_SUM'			,width:66	,hidden: true},
			{dataIndex: 'TAX_TYPE'				,width:66	,hidden: true},
			{dataIndex: 'STOCK_Q'				,width:66	,hidden: true},
			{dataIndex: 'ORDER_STOCK_Q'			,width:66	,hidden: true},
			{dataIndex: 'SALE_PRSN'				,width:66	,hidden: true},
			{dataIndex: 'PRICE_TYPE'			,width:66	,hidden: true},
			{dataIndex: 'INOUT_WGT_Q'			,width:66	,hidden: true},
			{dataIndex: 'INOUT_FOR_WGT_P'		,width:66	,hidden: true},
			{dataIndex: 'INOUT_VOL_Q'			,width:66	,hidden: true},
			{dataIndex: 'INOUT_FOR_VOL_P'		,width:66	,hidden: true},
			{dataIndex: 'INOUT_WGT_P'			,width:66	,hidden: true},
			{dataIndex: 'INOUT_VOL_P'			,width:66	,hidden: true},
			{dataIndex: 'WGT_UNIT'				,width:66	,hidden: true},
			{dataIndex: 'UNIT_WGT'				,width:66	,hidden: true},
			{dataIndex: 'VOL_UNIT'				,width:66	,hidden: true},
			{dataIndex: 'UNIT_VOL'				,width:66	,hidden: true},
			{dataIndex: 'TRANS_COST'			,width:66	,hidden: true},
			{dataIndex: 'PRICE_YN'				,width:66	,hidden: true},
			{dataIndex: 'ACCOUNT_YNC'			,width:66	,hidden: true},
			{dataIndex: 'DELIVERY_DATE'			,width:66	,hidden: true},
			{dataIndex: 'DELIVERY_TIME'			,width:66	,hidden: true},
			{dataIndex: 'RECEIVER_ID'			,width:66	,hidden: true},
			{dataIndex: 'RECEIVER_NAME'			,width:66	,hidden: true},
			{dataIndex: 'TELEPHONE_NUM1'		,width:66	,hidden: true},
			{dataIndex: 'TELEPHONE_NUM2'		,width:66	,hidden: true},
			{dataIndex: 'ADDRESS'				,width:66	,hidden: true},
			{dataIndex: 'SALE_CUST_CD'			,width:66	,hidden: true},
			{dataIndex: 'DVRY_CUST_CD'			,width:66	,hidden: true},
			{dataIndex: 'DVRY_CUST_NAME'		,width:66	,hidden: true},
			{dataIndex: 'ORDER_CUST_CD'			,width:66	,hidden: true},
			{dataIndex: 'PLAN_NUM'				,width:66	,hidden: true},
			{dataIndex: 'ORDER_NUM'				,width:66	,hidden: true},
			{dataIndex: 'ISSUE_REQ_NUM'			,width:66	,hidden: true},
			{dataIndex: 'BASIS_NUM'				,width:66	,hidden: true},
			{dataIndex: 'PAY_METHODE1'			,width:66	,hidden: true},
			{dataIndex: 'LC_SER_NO'				,width:66	,hidden: true},
			{dataIndex: 'REMARK'				,width:66	,hidden: true},
			{dataIndex: 'LOT_ASSIGNED_YN'		,width:66	,hidden: true},
			{dataIndex: 'INOUT_NUM'				,width:66	,hidden: true},
			{dataIndex: 'INOUT_DATE'			,width:66	,hidden: true},
			{dataIndex: 'INOUT_METH'			,width:66	,hidden: true},
			{dataIndex: 'INOUT_TYPE'			,width:66	,hidden: true},
			{dataIndex: 'DIV_CODE'				,width:66	,hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'		,width:66	,hidden: true},
			{dataIndex: 'INOUT_CODE'			,width:66	,hidden: true},
			{dataIndex: 'SALE_CUSTOM_CODE'		,width:66	,hidden: true},
			{dataIndex: 'CREATE_LOC'			,width:66	,hidden: true},
			{dataIndex: 'UPDATE_DB_USER'		,width:66	,hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'		,width:66	,hidden: true},
			{dataIndex: 'MONEY_UNIT'			,width:66	,hidden: true},
			{dataIndex: 'EXCHG_RATE_O'			,width:66	,hidden: true},
			{dataIndex: 'ORIGIN_Q'				,width:66	,hidden: true},
			{dataIndex: 'ORDER_NOT_Q'			,width:66	,hidden: true},
			{dataIndex: 'ISSUE_NOT_Q'			,width:66	,hidden: true},
			{dataIndex: 'ORDER_SEQ'				,width:66	,hidden: true},
			{dataIndex: 'ISSUE_REQ_SEQ'			,width:66	,hidden: true},
			{dataIndex: 'BASIS_SEQ'				,width:66	,hidden: true},
			{dataIndex: 'ORDER_TYPE'			,width:66	,hidden: true},
			{dataIndex: 'STOCK_UNIT'			,width:66	,hidden: true},
			{dataIndex: 'BILL_TYPE'				,width:66	,hidden: true},
			{dataIndex: 'SALE_TYPE'				,width:66	,hidden: true},
			{dataIndex: 'CREDIT_YN'				,width:66	,hidden: true},
			{dataIndex: 'ACCOUNT_Q'				,width:66	,hidden: true},
			{dataIndex: 'SALE_C_YN'				,width:66	,hidden: true},
			{dataIndex: 'INOUT_PRSN'			,width:66	,hidden: true},
			{dataIndex: 'WON_CALC_BAS'			,width:66	,hidden: true},
			{dataIndex: 'TAX_INOUT'				,width:66	,hidden: true},
			{dataIndex: 'AGENT_TYPE'			,width:66	,hidden: true},
			{dataIndex: 'STOCK_CARE_YN'			,width:66	,hidden: true},
			{dataIndex: 'RETURN_Q_YN'			,width:66	,hidden: true},
			{dataIndex: 'REF_CODE2'				,width:66	,hidden: true},
			{dataIndex: 'EXCESS_RATE'			,width:66	,hidden: true},
			{dataIndex: 'SRC_ORDER_Q'			,width:66	,hidden: true},
			{dataIndex: 'SOF110T_PRICE'			,width:66	,hidden: true},
			{dataIndex: 'SRQ100T_PRICE'			,width:66	,hidden: true},
			{dataIndex: 'COMP_CODE'				,width:66	,hidden: true},
			{dataIndex: 'DEPT_CODE'				,width:66	,hidden: true},
			{dataIndex: 'ITEM_ACCOUNT'			,width:66	,hidden: true},
			{dataIndex: 'GUBUN'					,width:66	,hidden: true},
			{dataIndex: 'TEMP_ORDER_UNIT_Q'		,width:66	,hidden: true},
//			{dataIndex: 'PURCHASE_CUSTOM_CODE'	,width:66	,hidden: true },
//			{dataIndex: 'PURCHASE_TYPE'			,width:66	,hidden: true },
			{dataIndex: 'LOT_YN'				,width:66	,hidden: true},
			{dataIndex: 'NATION_INOUT'			,width:66	,hidden: true},
			{dataIndex: 'SALE_DATE'				,width:66	,hidden: true},
			{dataIndex: 'BARCODE_KEY'			,width:66	,hidden: true}
		], 
		listeners: {
			render: function(grid, eOpts){
				var girdNm	= grid.getItemId();
				var store	= grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
					//store.onStoreActionEnable();
					if( barcodeStore.isDirty() ) {
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
					if(grid.getStore().getCount() > 0) {
						UniAppManager.setToolbarButtons('delete', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
				});
			},
			beforeedit	: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, 'ORDER_UNIT_Q')){
					return true;
				} else {
					return false;
				}
			}
		}
	});




	/** 수불정보를 검색하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//검색창 폼 정의
	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
			name: 'DIV_CODE',
			xtype:'uniCombobox',
			comboType:'BOR120',
			value:UserInfo.divCode,
			allowBlank:false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = orderNoSearch.getField('INOUT_PRSN');	
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..					
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'INOUT_DATE_FR',
			endFieldName: 'INOUT_DATE_TO',
			width: 350,
			startDate: new Date() ,
			endDate: new Date()
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
			validateBlank: false
		}),
			Unilite.popup('DIV_PUMOK',{
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': orderNoSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.sales.trancharge" default="수불담당"/>'		,
			name: 'INOUT_PRSN',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B024',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
				
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			xtype: 'uniTextfield',
			name:'PROJECT_NO',
			width:315
		}, {
			fieldLabel: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>',
			xtype: 'uniTextfield',
			name:'ISSUE_REQ_NUM',
			width:315
		}, {
			fieldLabel: '<t:message code="system.label.sales.receivername" default="수신자명"/>',
			xtype: 'uniTextfield',
			name:'RECEIVER_NAME'
		}, {
			fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
			name: 'CREATE_LOC',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B031',
			allowBlank:false,
			value:'1'
		},
		Unilite.popup('DEPT', { 
			fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
			valueFieldName: 'DEPT_CODE',
	   		textFieldName: 'DEPT_NAME',
			hidden: true,
			allowBlank: false,
			holdable: 'hold',
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
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.inquiryclass" default="조회구분"/>',
			xtype		: 'uniRadiogroup',
			name		: 'RDO_TYPE',
			allowBlank	: false,
			width		: 235,
			items		: [
				{boxLabel:'<t:message code="system.label.sales.master" default="마스터"/>', name:'RDO_TYPE', inputValue:'master', checked:true},
				{boxLabel:'<t:message code="system.label.sales.detail" default="디테일"/>', name:'RDO_TYPE', inputValue:'detail'}
			],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					orderNoMasterGrid.reset();
					orderNoDetailGrid.reset();
					if(newValue.RDO_TYPE=='detail') {
						if(orderNoMasterGrid) orderNoMasterGrid.hide();
						if(orderNoDetailGrid) orderNoDetailGrid.show();
					} else {
						if(orderNoDetailGrid) orderNoDetailGrid.hide();
						if(orderNoMasterGrid) orderNoMasterGrid.show();
					}
				}
			}
		}]
	}); // createSearchForm
	//검색창 모델 정의
	Unilite.defineModel('orderNoMasterModel', {
		fields: [{name: 'DIV_CODE'				, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string', comboType: 'BOR120'},		 
				 {name: 'ITEM_CODE'				, text: '<t:message code="system.label.sales.item" default="품목"/>'			, type: 'string'},
				 {name: 'ITEM_NAME'				, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},
				 {name: 'SPEC'					, text: '<t:message code="system.label.sales.spec" default="규격"/>'			, type: 'string'},
				 {name: 'INOUT_TYPE_DETAIL'		, text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'			, type: 'string', comboType:'AU', comboCode:'S007'},		 
				 {name: 'CREATE_LOC'			, text: '<t:message code="system.label.sales.creationpath" default="생성경로"/>'			, type: 'string', comboType:'AU', comboCode:'B031'},		 
				 {name: 'INOUT_DATE'			, text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'			, type: 'uniDate'},
				 {name: 'INOUT_Q'				, text: '<t:message code="system.label.sales.qty" default="수량"/>'			, type: 'uniQty'},
				 {name: 'WH_CODE'				, text: '<t:message code="system.label.sales.warehouse" default="창고"/>'			, type: 'string'},
				 {name: 'WH_NAME'				, text: '<t:message code="system.label.sales.warehouse" default="창고"/>'			, type: 'string'},
				 {name: 'INOUT_PRSN'			, text: '<t:message code="system.label.sales.charger" default="담당자"/>'			, type: 'string', comboType:'AU', comboCode:'B024'},		 
				 {name: 'RECEIVER_ID'			, text: '<t:message code="system.label.sales.receiverid" default="수신자ID"/>'			, type: 'string'},
				 {name: 'RECEIVER_NAME'			, text: '<t:message code="system.label.sales.receivername" default="수신자명"/>'			, type: 'string'},
				 {name: 'TELEPHONE_NUM1'		, text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>'			, type: 'string'},
				 {name: 'TELEPHONE_NUM2'		, text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>'			, type: 'string'},
				 {name: 'ADDRESS'				, text: '<t:message code="system.label.sales.address" default="주소"/>'			, type: 'string'},
				 {name: 'INOUT_NUM'				, text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'			, type: 'string'},
				 {name: 'ISSUE_REQ_NUM'			, text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'		, type: 'string'},
				 {name: 'PROJECT_NO'			, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'		, type: 'string'},
				 {name: 'SALE_DIV_CODE'			, text: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>'			, type: 'string'},
				 {name: 'SALE_CUST_NM'			, text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			, type: 'string'},
				 {name: 'INOUT_CODE'			, text: '<t:message code="system.label.sales.tranplace" default="수불처"/>'			, type: 'string'},
				 {name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.sales.tranplacename" default="수불처명"/>'			, type: 'string'},
				 {name: 'MONEY_UNIT'			, text: '<t:message code="system.label.sales.currency" default="화폐"/>'			, type: 'string'},
				 {name: 'EXCHG_RATE_O'			, text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'			, type: 'uniER'},
				 {name: 'SALE_DATE'				, text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'			, type: 'uniDate'},
				 
				 /*CustomCodeInfo set위해*/
				 {name: 'AGENT_TYPE'			, text: 'AGENT_TYPE'	, type: 'string'},
				 {name: 'CREDIT_YN'				, text: 'CREDIT_YN'		, type: 'string'},
				 {name: 'WON_CALC_BAS'			, text: 'WON_CALC_BAS'	, type: 'string'},
				 {name: 'TAX_TYPE'				, text: 'TAX_TYPE'		, type: 'string'},
				 {name: 'BUSI_PRSN'				, text: 'BUSI_PRSN'		, type: 'string'}
		]
	});
	//검색창 스토어 정의
	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {
		model: 'orderNoMasterModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 's_str105ukrv_mitService.selectOrderNumMasterList'
			}
		},
		loadStoreRecords : function() {
			var param		= orderNoSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;				//부서코드
			if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색창 그리드 정의
	var orderNoMasterGrid = Unilite.createGrid('s_str105ukrv_mitOrderNoMasterGrid', {
		// title: '기본',
		layout	: 'fit',	   
		store	: orderNoMasterStore,
		uniOpt	: {
			useRowNumberer: false
		},
		columns:  [{ dataIndex: 'DIV_CODE'				, width: 80 },
				   { dataIndex: 'INOUT_CODE'			, width: 90 },
				   { dataIndex: 'CUSTOM_NAME'			, width: 120},
				   { dataIndex: 'CREATE_LOC'			, width: 66 },
				   { dataIndex: 'INOUT_DATE'			, width: 80 },
				   { dataIndex: 'INOUT_Q'				, width: 93 },
				   { dataIndex: 'INOUT_PRSN'			, width: 80 },
				   { dataIndex: 'INOUT_NUM'				, width: 120 },
				   { dataIndex: 'SALE_DIV_CODE'			, width: 73, hidden: true },
				   { dataIndex: 'MONEY_UNIT'			, width: 93 },
				   { dataIndex: 'EXCHG_RATE_O'			, width: 93, hidden: true },
				   { dataIndex: 'ISSUE_REQ_NUM'			, width: 120 }
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoMasterGrid.returnData(record);
				searchInfoWindow.hide();
			}
		}, // listeners
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			var field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, record.get('DIV_CODE'), null, null, "DIV_CODE");
			field = panelResult.getField('INOUT_PRSN');			
			field.fireEvent('changedivcode', field, record.get('DIV_CODE'), null, null, "DIV_CODE");

			panelResult.setValue('INOUT_NUM'	, record.get('INOUT_NUM'));
			panelResult.setValue('INOUT_DATE'	, record.get('INOUT_DATE'));
			panelResult.setValue('DIV_CODE'		, record.get('DIV_CODE'));
			panelResult.setValue('INOUT_PRSN'	, record.get('INOUT_PRSN'));
			panelResult.setValue('MONEY_UNIT'	, record.get('MONEY_UNIT'));
			panelResult.setValue('EXCHG_RATE_O'	, record.get('EXCHG_RATE_O'));
			panelResult.setValue('CUSTOM_CODE'	, record.get('INOUT_CODE'));
			panelResult.setValue('CUSTOM_NAME'	, record.get('CUSTOM_NAME'));
			panelResult.setValue('INOUT_DATE'	, record.get('INOUT_DATE'));
			panelResult.setValue('WH_CODE'		, record.get('WH_CODE'));
			panelResult.setValue('WH_CELL_CODE'	, record.get('WH_CELL_CODE'));
			panelResult.setValue('NATION_CODE'	, record.get('NATION_CODE'));
//			panelResult.setValue('CREATE_LOC'	, record.get('CREATE_LOC'));
			if(Ext.isEmpty(record.get('SALE_DATE'))){
				panelResult.setValue('SALE_DATE', record.get('INOUT_DATE'));
			}else{
				panelResult.setValue('SALE_DATE', record.get('SALE_DATE'));
			}
			
			CustomCodeInfo.gsAgentType		= record.get('AGENT_TYPE');
			CustomCodeInfo.gsCustCreditYn	= record.get('CREDIT_YN');
			CustomCodeInfo.gsUnderCalBase	= record.get('WON_CALC_BAS');
			CustomCodeInfo.gsTaxInout		= record.get('TAX_TYPE');
			CustomCodeInfo.gsbusiPrsn		= record.get('BUSI_PRSN');
			UniAppManager.app.onQueryButtonDown();
		}
	});
	//검색창 detail그리드 정의
	var orderNoDetailGrid = Unilite.createGrid('s_str105ukrv_mitorderNoDetailGrid', {
		layout : 'fit',
		store: orderNoMasterStore,
		uniOpt:{
			useRowNumberer: false
		},
		hidden : true,
		columns:  [
			{ dataIndex: 'DIV_CODE'				, width: 80 },
			{ dataIndex: 'ITEM_CODE'			, width: 150 },
			{ dataIndex: 'ITEM_NAME'			, width: 150 },
			{ dataIndex: 'SPEC'					, width: 133 },
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 80 },
			{ dataIndex: 'CREATE_LOC'			, width: 66 },
			{ dataIndex: 'INOUT_DATE'			, width: 80 },
			{ dataIndex: 'INOUT_Q'				, width: 93 },
			{ dataIndex: 'WH_CODE'				, width: 66, hidden: true },
			{ dataIndex: 'WH_NAME'				, width: 80 },
			{ dataIndex: 'INOUT_PRSN'			, width: 80 },
			{ dataIndex: 'RECEIVER_ID'			, width: 86, hidden: true },
			{ dataIndex: 'RECEIVER_NAME'		, width: 86, hidden: true },
			{ dataIndex: 'TELEPHONE_NUM1'		, width: 80, hidden: true },
			{ dataIndex: 'TELEPHONE_NUM2'		, width: 80, hidden: true },
			{ dataIndex: 'ADDRESS'				, width: 133, hidden: true },
			{ dataIndex: 'INOUT_NUM'			, width: 120 },
			{ dataIndex: 'ISSUE_REQ_NUM'		, width: 100 },
			{ dataIndex: 'PROJECT_NO'			, width: 86 },
			{ dataIndex: 'SALE_DIV_CODE'		, width: 73, hidden: true },
			{ dataIndex: 'SALE_CUST_NM'			, width: 93 },
			{ dataIndex: 'INOUT_CODE'			, width: 93, hidden: true },
			{ dataIndex: 'MONEY_UNIT'			, width: 93 },
			{ dataIndex: 'EXCHG_RATE_O'			, width: 93, hidden: true },
			{ dataIndex: 'SALE_DATE'			, width: 93, hidden: true }
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoDetailGrid.returnData(record);
				searchInfoWindow.hide();
			}
		}, // listeners
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			var field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, record.get('DIV_CODE'), null, null, "DIV_CODE");
			field = panelResult.getField('INOUT_PRSN');			
			field.fireEvent('changedivcode', field, record.get('DIV_CODE'), null, null, "DIV_CODE");
			
			panelResult.setValue('INOUT_NUM'	, record.get('INOUT_NUM'));
			panelResult.setValue('INOUT_DATE'	, record.get('INOUT_DATE'));
			panelResult.setValue('DIV_CODE'		, record.get('DIV_CODE'));
			panelResult.setValue('INOUT_PRSN'	, record.get('INOUT_PRSN'));
			panelResult.setValue('MONEY_UNIT'	, record.get('MONEY_UNIT'));
			panelResult.setValue('EXCHG_RATE_O'	, record.get('EXCHG_RATE_O'));
			panelResult.setValue('CUSTOM_CODE'	, record.get('INOUT_CODE'));
			panelResult.setValue('CUSTOM_NAME'	, record.get('SALE_CUST_NM'));
			panelResult.setValue('INOUT_DATE'	, record.get('INOUT_DATE'));
			panelResult.setValue('WH_CODE'		, record.get('WH_CODE'));
			panelResult.setValue('WH_CELL_CODE'	, record.get('WH_CELL_CODE'));
			panelResult.setValue('NATION_CODE'	, record.get('NATION_CODE'));
//			panelResult.setValue('CREATE_LOC'	, record.get('CREATE_LOC'));
			if(Ext.isEmpty(record.get('SALE_DATE'))){
				panelResult.setValue('SALE_DATE', record.get('INOUT_DATE'));
			}else{
				panelResult.setValue('SALE_DATE', record.get('SALE_DATE'));
			}

			CustomCodeInfo.gsAgentType		= record.get('AGENT_TYPE');
			CustomCodeInfo.gsCustCreditYn	= record.get('CREDIT_YN');
			CustomCodeInfo.gsUnderCalBase	= record.get('WON_CALC_BAS');
			CustomCodeInfo.gsTaxInout		= record.get('TAX_TYPE');
			CustomCodeInfo.gsbusiPrsn		= record.get('BUSI_PRSN');	
			UniAppManager.app.onQueryButtonDown();
		}
	});
	//openSearchInfoWindow (검색창 메인)
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.sales.issuenosearch" default="출고번호검색"/>',
				width: 830,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [orderNoSearch, orderNoMasterGrid, orderNoDetailGrid],
				tbar:  [ '->',
					{	itemId : 'searchBtn',
						text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
						handler: function() {
							orderNoMasterStore.loadStoreRecords();
						},
						disabled: false
					}, {
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
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
						orderNoDetailGrid.reset();
						barcodeStore.loadData({});
					},
					beforeclose: function( panel, eOpts ) {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
						orderNoDetailGrid.reset();
					},
					beforeshow: function( panel, eOpts ) {
						field = orderNoSearch.getField('INOUT_PRSN');
						field.fireEvent('changedivcode', field	, panelResult.getValue('DIV_CODE'), null, null, "DIV_CODE");
						orderNoSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						orderNoSearch.setValue('INOUT_PRSN'		, panelResult.getValue('INOUT_PRSN'));
						orderNoSearch.setValue('CUSTOM_CODE'	, panelResult.getValue('CUSTOM_CODE'));
						orderNoSearch.setValue('CUSTOM_NAME'	, panelResult.getValue('CUSTOM_NAME'));
						orderNoSearch.setValue('INOUT_DATE_FR'	, new Date());
						orderNoSearch.setValue('INOUT_DATE_TO'	,new Date());
						orderNoSearch.setValue('CREATE_LOC'		, '1');	
						orderNoSearch.setValue('DEPT_CODE'		, panelResult.getValue('DEPT_CODE'));
						orderNoSearch.setValue('DEPT_NAME'		, panelResult.getValue('DEPT_NAME'));
						orderNoSearch.setValue('RDO_TYPE'		,'master');
//						orderNoSearch.setValue('ORDER_TYPE',panelResult.getValue('ORDER_TYPE'));

						orderNoDetailGrid.hide();
						orderNoMasterGrid.show();
					}
				}		
			})
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
	}



	/** 출하지시내역을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//출하지시 참조 폼 정의
	var requestSearch = Unilite.createSearchForm('requestForm', {
		layout :  {type : 'uniTable', columns : 3},
		items :[{
			xtype: 'uniCombobox',
			name:'DIV_CODE',
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			child: 'WH_CODE',
			comboType:'BOR120',
			allowBlank: false,
			readOnly: true
		},
			Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>' , 
			validateBlank: false,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': requestSearch.getValue('DIV_CODE')});
				}
			}
		}), {
			fieldLabel: '출하지시예정일',
			xtype: 'uniDateRangefield',
			startFieldName: 'ISSUE_DATE_FR',
			endFieldName: 'ISSUE_DATE_TO',	
			width: 350,
			endDate: UniDate.get('tomorrow')
		}, {
			fieldLabel: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>',
			xtype: 'uniTextfield',
			name:'ISSUE_REQ_NUM'
		}, {
			fieldLabel: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			xtype: 'uniTextfield',
			name:'PROJECT_NO'
		}, {
			fieldLabel: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
			name: 'WH_CODE',
			xtype:'uniCombobox',
			comboType   : 'OU',
			comboCode:''
			//store: Ext.data.StoreManager.lookup('whList')
		}, {
			xtype: 'hiddenfield',
			name:'MONEY_UNIT'
		}, {
			xtype: 'hiddenfield',
			name:'CUSTOM_CODE'
		}, {
			xtype: 'hiddenfield',
			name:'CUSTOM_NAME'
		}, {
			xtype: 'hiddenfield',
			name:'CREATE_LOC'
		}]
	});
	//출하지시 참조 모델 정의
	Unilite.defineModel('s_str105ukrv_mitRequestModel', {
		fields: [
			{name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.sales.custom" default="거래처"/>'				, type: 'string'},
			{name: 'ITEM_CODE'				,text: '<t:message code="system.label.sales.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'					,text: '<t:message code="system.label.sales.spec" default="규격"/>'					, type: 'string'},
			{name: 'ORDER_UNIT'				,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'				, type: 'string', displayField: 'value'},
			{name: 'TRANS_RATE'				,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'					, type: 'string'},
			{name: 'ISSUE_REQ_DATE'			,text: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'				, type: 'uniDate'},
			{name: 'ISSUE_DATE'				,text: '출하지시예정일'			, type: 'uniDate'},
			{name: 'NOT_REQ_Q'				,text: '<t:message code="system.label.sales.unissuedqty" default="미출고량"/>'				, type: 'uniQty'},
			{name: 'ISSUE_REQ_QTY'			,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'				, type: 'uniQty'},
			{name: 'ISSUE_WGT_Q'			,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>(<t:message code="system.label.sales.weight" default="중량"/>)'			, type: 'string'},
			{name: 'ISSUE_VOL_Q'			,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'			, type: 'string'},
			{name: 'STOCK_Q'				,text: '<t:message code="system.label.sales.inventoryqty2" default="재고수량"/>'				, type: 'uniQty'},
			{name: 'WH_CODE'				,text: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'				, type: 'string'      , comboType   : 'OU'},
			{name: 'ORDER_NUM'				,text: '<t:message code="system.label.sales.soofferno" default="수주(오퍼)번호"/>'		, type: 'string'},
			{name: 'ISSUE_REQ_NUM'			,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'				, type: 'string'},
			{name: 'ISSUE_REQ_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'					, type: 'string'},
			{name: 'PROJECT_NO'				,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'PAY_METHODE1'			,text: '<t:message code="system.label.sales.amountpaymethod" default="대금결제방법"/>'				, type: 'string'},
			{name: 'LC_SER_NO'				,text: '<t:message code="system.label.sales.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'LOT_NO'					,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'				, type: 'string'},
			{name: 'RECEIVER_ID'			,text: '<t:message code="system.label.sales.receiverid" default="수신자ID"/>'				, type: 'string'},
			{name: 'RECEIVER_NAME'			,text: '<t:message code="system.label.sales.receivername" default="수신자명"/>'				, type: 'string'},
			{name: 'TELEPHONE_NUM1'			,text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>'				, type: 'string'},
			{name: 'TELEPHONE_NUM2'			,text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>'				, type: 'string'},
			{name: 'ADDRESS'				,text: '<t:message code="system.label.sales.address" default="주소"/>'					, type: 'string'},
			{name: 'ORDER_CUST_CD'			,text: '<t:message code="system.label.sales.soplace" default="수주처"/>'				, type: 'string'},
			{name: 'DIV_CODE'				,text: 'DIV_CODE'			, type: 'string'},
			{name: 'CUSTOM_CODE'			,text: 'CUSTOM_CODE'		, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'		,text: 'INOUT_TYPE_DETAIL'	, type: 'string'},
			{name: 'WH_CELL_CODE'			,text: 'WH_CELL_CODE'		, type: 'string'},
			{name: 'WH_CELL_NAME'			,text: 'WH_CELL_NAME'		, type: 'string'},
			{name: 'ISSUE_REQ_PRICE'		,text: 'ISSUE_REQ_PRICE'	, type: 'string'},
			{name: 'ISSUE_REQ_AMT'			,text: 'ISSUE_REQ_AMT'		, type: 'string'},
			{name: 'ISSUE_REQ_TAX_AMT'		,text: 'ISSUE_REQ_TAX_AMT'	, type: 'string'},
			{name: 'TAX_TYPE'				,text: 'TAX_TYPE'			, type: 'string'},
			{name: 'MONEY_UNIT'				,text: 'MONEY_UNIT'			, type: 'string'},
			{name: 'EXCHANGE_RATE'			,text: 'EXCHANGE_RATE'		, type: 'string'},
			{name: 'ACCOUNT_YNC'			,text: '<t:message code="system.label.sales.salessubject" default="매출대상"/>'				, type: 'string'},
			{name: 'DISCOUNT_RATE'			,text: 'DISCOUNT_RATE'		, type: 'string'},
			{name: 'ISSUE_REQ_PRSN'			,text: 'ISSUE_REQ_PRSN'		, type: 'string'},
			{name: 'DVRY_CUST_CD'			,text: 'DVRY_CUST_CD'		, type: 'string'},
			{name: 'REMARK'					,text: 'REMARK'				, type: 'string'},
			{name: 'SER_NO'					,text: 'SER_NO'				, type: 'string'},
			{name: 'SALE_CUSTOM_CODE'		,text: 'SALE_CUSTOM_CODE'	, type: 'string'},
			{name: 'SALE_CUST_CD'			,text: 'SALE_CUST_CD'		, type: 'string'},
			{name: 'ISSUE_DIV_CODE'			,text: 'ISSUE_DIV_CODE'		, type: 'string'},
			{name: 'BILL_TYPE'				,text: 'BILL_TYPE'			, type: 'string'},
			{name: 'ORDER_TYPE'				,text: 'ORDER_TYPE'			, type: 'string'},
			{name: 'PRICE_YN'				,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string', comboType: 'AU', comboCode: 'S003'},
			{name: 'PO_NUM'					,text: 'PO_NUM'				, type: 'string'},
			{name: 'PO_SEQ'					,text: 'PO_SEQ'				, type: 'string'},
			{name: 'CREDIT_YN'				,text: 'CREDIT_YN'			, type: 'string'},
			{name: 'WON_CALC_BAS'			,text: 'WON_CALC_BAS' 		, type: 'string'},
			{name: 'TAX_INOUT'				,text: 'TAX_INOUT'			, type: 'string'},
			{name: 'AGENT_TYPE'				,text: 'AGENT_TYPE'			, type: 'string'},
			{name: 'STOCK_CARE_YN'			,text: 'STOCK_CARE_YN'		, type: 'string'},
			{name: 'STOCK_UNIT'				,text: 'STOCK_UNIT'			, type: 'string'},
			{name: 'DVRY_CUST_NAME'			,text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'				, type: 'string'},
			{name: 'SOF100_TAX_INOUT'		,text: 'SOF100_TAX_INOUT'	, type: 'string'},
			{name: 'RETURN_Q_YN'			,text: 'RETURN_Q_YN'		, type: 'string'},
			{name: 'ORDER_Q'				,text: 'ORDER_Q'			, type: 'string'},
			{name: 'REF_CODE2'				,text: 'REF_CODE2'			, type: 'string'},
			{name: 'EXCESS_RATE'			,text: 'EXCESS_RATE'		, type: 'string'},
			{name: 'DEPT_CODE'				,text: 'DEPT_CODE'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'			,text: 'ITEM_ACCOUNT'		, type: 'string'},
			{name: 'PRICE_TYPE'				,text: 'PRICE_TYPE'			, type: 'string'},
			{name: 'ISSUE_FOR_WGT_P'		,text: 'ISSUE_FOR_WGT_P' 	, type: 'string'},
			{name: 'ISSUE_WGT_P'			,text: 'ISSUE_WGT_P'		, type: 'string'},
			{name: 'ISSUE_FOR_VOL_P'		,text: 'ISSUE_FOR_VOL_P' 	, type: 'string'},
			{name: 'ISSUE_VOL_P'			,text: 'ISSUE_VOL_P'		, type: 'string'},
			{name: 'WGT_UNIT'				,text: 'WGT_UNIT'			, type: 'string'},
			{name: 'UNIT_WGT'				,text: 'UNIT_WGT'			, type: 'string'},
			{name: 'VOL_UNIT'				,text: 'VOL_UNIT'			, type: 'string'},
			{name: 'UNIT_VOL'				,text: 'UNIT_VOL'			, type: 'string'},
			//20180810 추가
			{name: 'ISSUE_FOR_PRICE'		,text: 'ISSUE_REQ_PRICE'	, type: 'string'},
			{name: 'ISSUE_FOR_AMT'			,text: 'ISSUE_REQ_AMT'		, type: 'string'}
			
		]
	});
	//출하지시 참조 스토어 정의
	var requestStore = Unilite.createStore('s_str105ukrv_mitRequestStore', {
		model: 's_str105ukrv_mitRequestModel',
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
				read : 's_str105ukrv_mitService.selectRequestiList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful) {/*
					var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);  
					var deleteRecords = new Array();

					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
					
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								
								if((record.data['ISSUE_REQ_NUM'] == item.data['ISSUE_REQ_NUM']) 
								&& (record.data['ISSUE_REQ_SEQ'] == item.data['ISSUE_REQ_SEQ'])) {
									deleteRecords.push(item);
								}
							});
						});
						store.remove(deleteRecords);
					}
				*/}
			}
		},
		loadStoreRecords : function() {
			var param= requestSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//출하지시 참조 그리드 정의
	var requestGrid = Unilite.createGrid('s_str105ukrv_mitRequestGrid', {
		// title: '기본',
		layout	: 'fit',
		store	: requestStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false, mode: 'SIMPLE'}),
		uniOpt	:{
			onLoadSelectFirst	: false,
			useRowNumberer		: false
		},
		columns:  [
			{ dataIndex: 'CUSTOM_NAME'			,  width: 120 },
			{ dataIndex: 'ITEM_CODE'			,  width: 120 },
			{ dataIndex: 'ITEM_NAME'			,  width: 113 },
			{ dataIndex: 'SPEC'					,  width: 113 },
			{ dataIndex: 'ORDER_UNIT'			,  width: 80, align: 'center' },
			{ dataIndex: 'TRANS_RATE'			,  width: 40 },
			{ dataIndex: 'ISSUE_REQ_DATE'		,  width: 80 },
			{ dataIndex: 'ISSUE_DATE'			,  width: 80 },
			{ dataIndex: 'NOT_REQ_Q'			,  width: 80 },
			{ dataIndex: 'ISSUE_REQ_QTY'		,  width: 80 },
			{ dataIndex: 'ISSUE_WGT_Q'			,  width: 80, hidden: true },
			{ dataIndex: 'ISSUE_VOL_Q'			,  width: 80, hidden: true },
			{ dataIndex: 'STOCK_Q'				,  width: 80 },
			{ dataIndex: 'WH_CODE'				,  width: 93},
			{ dataIndex: 'ORDER_NUM'			,  width: 120 },
			{ dataIndex: 'ISSUE_REQ_NUM'		,  width: 100 },
			{ dataIndex: 'ISSUE_REQ_SEQ'		,  width: 40 },
			{ dataIndex: 'PROJECT_NO'			,  width: 86 },
			{ dataIndex: 'PAY_METHODE1'			,  width: 100 },
			{ dataIndex: 'LC_SER_NO'			,  width: 100 },
			{ dataIndex: 'LOT_NO'				,  width: 66 },
			{ dataIndex: 'RECEIVER_ID'			,  width: 86, hidden: true },
			{ dataIndex: 'RECEIVER_NAME'		,  width: 86 , hidden: true},
			{ dataIndex: 'TELEPHONE_NUM1'		,  width: 80, hidden: true },
			{ dataIndex: 'TELEPHONE_NUM2'		,  width: 80, hidden: true },
			{ dataIndex: 'ADDRESS'				,  width: 133, hidden: true },
			{ dataIndex: 'ORDER_CUST_CD'		,  width: 86 },
			{ dataIndex: 'DIV_CODE'				,  width: 66, hidden: true },
			{ dataIndex: 'CUSTOM_CODE'			,  width: 66, hidden: true },
			{ dataIndex: 'INOUT_TYPE_DETAIL'	,  width: 66, hidden: true },
			{ dataIndex: 'WH_CELL_CODE'			,  width: 66, hidden: true },
			{ dataIndex: 'WH_CELL_NAME'			,  width: 66, hidden: true },
			{ dataIndex: 'ISSUE_REQ_PRICE'		,  width: 66, hidden: true },
			{ dataIndex: 'ISSUE_REQ_AMT'		,  width: 66, hidden: true },
			{ dataIndex: 'ISSUE_REQ_TAX_AMT'	,  width: 66, hidden: true },
			{ dataIndex: 'TAX_TYPE'				,  width: 66, hidden: true },
			{ dataIndex: 'MONEY_UNIT'			,  width: 66, hidden: true },
			{ dataIndex: 'EXCHANGE_RATE'		,  width: 66, hidden: true },
			{ dataIndex: 'ACCOUNT_YNC'			,  width: 66 },
			{ dataIndex: 'DISCOUNT_RATE'		,  width: 66, hidden: true },
			{ dataIndex: 'ISSUE_REQ_PRSN'		,  width: 66, hidden: true },
			{ dataIndex: 'DVRY_CUST_CD'			,  width: 66, hidden: true },
			{ dataIndex: 'REMARK'				,  width: 66, hidden: true },
			{ dataIndex: 'SER_NO'				,  width: 66, hidden: true },
			{ dataIndex: 'SALE_CUSTOM_CODE'		,  width: 66, hidden: true },
			{ dataIndex: 'SALE_CUST_CD'			,  width: 66, hidden: true },
			{ dataIndex: 'ISSUE_DIV_CODE'		,  width: 66, hidden: true },
			{ dataIndex: 'BILL_TYPE'			,  width: 66, hidden: true },
			{ dataIndex: 'ORDER_TYPE'			,  width: 66, hidden: true },
			{ dataIndex: 'PRICE_YN'				,  width: 80 },
			{ dataIndex: 'PO_NUM'				,  width: 66, hidden: true },
			{ dataIndex: 'PO_SEQ'				,  width: 66, hidden: true },
			{ dataIndex: 'CREDIT_YN'			,  width: 66, hidden: true },
			{ dataIndex: 'WON_CALC_BAS'			,  width: 66, hidden: true },
			{ dataIndex: 'TAX_INOUT'			,  width: 66, hidden: true },
			{ dataIndex: 'AGENT_TYPE'			,  width: 66, hidden: true },
			{ dataIndex: 'STOCK_CARE_YN'		,  width: 66, hidden: true },
			{ dataIndex: 'STOCK_UNIT'			,  width: 66, hidden: true },
			{ dataIndex: 'DVRY_CUST_NAME'		,  width: 113 },
			{ dataIndex: 'SOF100_TAX_INOUT'		,  width: 66, hidden: true },
			{ dataIndex: 'RETURN_Q_YN'			,  width: 66, hidden: true },
			{ dataIndex: 'ORDER_Q'				,  width: 66, hidden: true },
			{ dataIndex: 'REF_CODE2'			,  width: 66, hidden: true },
			{ dataIndex: 'EXCESS_RATE'			,  width: 66, hidden: true },
			{ dataIndex: 'DEPT_CODE'			,  width: 66, hidden: true },
			{ dataIndex: 'ITEM_ACCOUNT'			,  width: 66, hidden: true },
			{ dataIndex: 'PRICE_TYPE'			,  width: 66, hidden: true },
			{ dataIndex: 'ISSUE_FOR_WGT_P'		,  width: 66, hidden: true },
			{ dataIndex: 'ISSUE_WGT_P'			,  width: 66, hidden: true },
			{ dataIndex: 'ISSUE_FOR_VOL_P'		,  width: 66, hidden: true },
			{ dataIndex: 'ISSUE_VOL_P'			,  width: 66, hidden: true },
			{ dataIndex: 'WGT_UNIT'				,  width: 66, hidden: true },
			{ dataIndex: 'UNIT_WGT'				,  width: 66, hidden: true },
			{ dataIndex: 'VOL_UNIT'				,  width: 66, hidden: true },
			{ dataIndex: 'UNIT_VOL'				,  width: 66, hidden: true },
			//20180810 추가
			{ dataIndex: 'ISSUE_FOR_PRICE'		,  width: 66, hidden: true },
			{ dataIndex: 'ISSUE_FOR_AMT'		,  width: 66, hidden: true }
		],
		listeners: {	
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function(issueReqBarcode) {
			var records = this.getSelectedRecords();
			if(!Ext.isEmpty(issueReqBarcode)) {
				records = issueReqBarcode;
			}
			//20200401 수정: 참조적용 로직 변경
//			Ext.each(records, function(record,i){	
//				UniAppManager.app.onNewDataButtonDown();
//				detailGrid.setrequestData(record.data);
//			});
			//20200401 수정: 참조적용 로직 변경
			UniAppManager.app.fnMakeSrf100tDataRef(records, issueReqBarcode);

			this.deleteSelectedRow();
			detailStore.fnOrderAmtSum();
			detailStore.sort([{property: 'ISSUE_REQ_NUM'	, direction: 'ASC'	, mode: 'multi'}
							, {property: 'ISSUE_REQ_SEQ'	, direction: 'ASC'	, mode: 'multi'}
							, {property: 'CUSTOM_NAME'		, direction: 'ASC'	, mode: 'multi'}
							, {property: 'ISSUE_REQ_PRSN'	, direction: 'DESC'	, mode: 'multi'}
							, {property: 'ITEM_CODE'		, direction: 'ASC'	, mode: 'multi'}
							, {property: 'DELIVERY_DATE'	, direction: 'ASC'	, mode: 'multi'}
			]);
			CustomCodeInfo.gsAgentType		= records[0].AGENT_TYPE;
			CustomCodeInfo.gsCustCreditYn	= records[0].CREDIT_YN;
			CustomCodeInfo.gsUnderCalBase	= records[0].WON_CALC_BAS;
			CustomCodeInfo.gsTaxInout		= records[0].TAX_TYPE;
			CustomCodeInfo.gsbusiPrsn		= records[0].ISSUE_REQ_PRSN;
		}
	});
	//출하지시 참조 메인
	function openRequestWindow() {
		if(!panelResult.getInvalidMessage()) return false;
		
		if(!referRequestWindow) {
			referRequestWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.sales.shipmentorderrefer" default="출하지시참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				
				items: [requestSearch, requestGrid],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
						handler: function() {
							requestStore.loadStoreRecords();
						},
						disabled: false
					}, 
					{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.sales.issueapply" default="출고적용"/>',
						handler: function() {
							requestGrid.returnData();
						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.sales.issueapplyclose" default="출고적용후 닫기"/>',
						handler: function() {
							requestGrid.returnData();
							referRequestWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.sales.close" default="닫기"/>',
						handler: function() {
							if(detailStore.getCount() == 0){
								panelResult.setAllFieldsReadOnly(false);
							}
							referRequestWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						requestSearch.clearForm();
						requestGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						requestSearch.clearForm();
						requestGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						requestSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						requestSearch.setValue('MONEY_UNIT'		, panelResult.getValue('MONEY_UNIT'));
						requestSearch.setValue('CUSTOM_CODE'	, panelResult.getValue('CUSTOM_CODE'));
						requestSearch.setValue('CUSTOM_NAME'	, panelResult.getValue('CUSTOM_NAME'));
						requestSearch.setValue('CREATE_LOC'		, panelResult.getValue('CREATE_LOC'));	
						requestSearch.setValue('ISSUE_DATE_TO'	, panelResult.getValue('INOUT_DATE'));
						requestSearch.setValue('ISSUE_DATE_FR'	, UniDate.get('startOfMonth', panelResult.getValue('INOUT_DATE')));
//						requestSearch.setValue('ISSUE_DATE_FR'	, UniDate.get('startOfMonth', salesOrderSearch.getValue('ISSUE_DATE_TO')));
						requestStore.loadStoreRecords();
					}
				}
			})
		}
		referRequestWindow.center();
		referRequestWindow.show();
	}



	/** 수주(오퍼)를 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//수주(오퍼) 참조 폼 정의
	var salesOrderSearch = Unilite.createSearchForm('s_str105ukrv_mitsalesOrderForm', {
		layout :  {type : 'uniTable', columns : 2},
		items :[
			Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>' , 
			validateBlank: false,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}), {
			fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'DVRY_DATE_FR',
			endFieldName: 'DVRY_DATE_TO',	
			width: 350,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		}, {
			fieldLabel: '<t:message code="system.label.sales.sono" default="수주번호"/>',
			xtype: 'uniTextfield',
			name:'ORDER_NUM'
		}, {
			fieldLabel: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			xtype: 'uniTextfield',
			name:'PROJECT_NO'
		},{
			fieldLabel: '<t:message code="system.label.sales.domesticoverseasclass" default="국내외구분"/>',
			name: 'NATION_INOUT',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'T109',
			value: '1',
			holdable: 'hold'
		}, {
			xtype: 'hiddenfield',
			name:'CUSTOM_CODE'
		}, {
			xtype: 'hiddenfield',
			name:'CUSTOM_NAME'
		}, {
			xtype: 'hiddenfield',
			name: 'DIV_CODE'
		}, {
			xtype: 'hiddenfield',
			name: 'MONEY_UNIT'
		}, {
			xtype: 'hiddenfield',
			name: 'CREATE_LOC'
		}]
	}); 
	//수주(오퍼) 참조 모델 정의
	Unilite.defineModel('s_str105ukrv_mitsalesOrderModel', {
		fields: [
			{ name: 'ORDER_NUM'				, text:'<t:message code="system.label.sales.sono" default="수주번호"/>'			,type : 'string' },
			{ name: 'SER_NO'				, text:'<t:message code="system.label.sales.seq" default="순번"/>'				,type : 'string' },
			{ name: 'SO_KIND'				, text:'<t:message code="system.label.sales.ordertype" default="주문구분"/>'			,type : 'string', comboType: 'AU', comboCode: 'S065' },
			{ name: 'INOUT_TYPE_DETAIL'		, text:'<t:message code="system.label.sales.issuetype" default="출고유형"/>'			,type : 'string' },
			{ name: 'ITEM_CODE'				, text:'<t:message code="system.label.sales.item" default="품목"/>'			,type : 'string' },
			{ name: 'ITEM_NAME'				, text:'<t:message code="system.label.sales.itemname" default="품목명"/>'				,type : 'string' },
			{ name: 'SPEC'					, text:'<t:message code="system.label.sales.spec" default="규격"/>'				,type : 'string' },
			{ name: 'ORDER_UNIT'			, text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'			,type : 'string', displayField: 'value' },
			{ name: 'TRANS_RATE'			, text:'<t:message code="system.label.sales.containedqty" default="입수"/>'				,type : 'string' },
			{ name: 'DVRY_DATE'				, text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'			,type : 'uniDate' },
			{ name: 'NOT_INOUT_Q'			, text:'<t:message code="system.label.sales.undeliveryqty" default="미납량"/>'			,type : 'uniQty' },
			{ name: 'ORDER_Q'				, text:'<t:message code="system.label.sales.soqty" default="수주량"/>'			,type : 'uniQty' },
			{ name: 'ISSUE_REQ_Q'			, text:'<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'			,type : 'uniQty' },
			{ name: 'R_LOT_NO'				, text:'<t:message code="system.label.sales.lotno" default="LOT번호"/>'			,type : 'string' },
			{ name: 'ORDER_WGT_Q'			, text:'<t:message code="system.label.sales.soqty" default="수주량"/>(<t:message code="system.label.sales.weight" default="중량"/>)'		,type : 'string' },
			{ name: 'ORDER_VOL_Q'			, text:'<t:message code="system.label.sales.soqty" default="수주량"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'		,type : 'string' },
			{ name: 'PROJECT_NO'			, text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			,type : 'string' },
			{ name: 'CUSTOM_NAME'			, text:'<t:message code="system.label.sales.soplace" default="수주처"/>'			,type : 'string' },
			{ name: 'PO_NUM'				, text:'PO NO'			,type : 'string' },
			{ name: 'PAY_METHODE1'			, text:'<t:message code="system.label.sales.amountpaymethod" default="대금결제방법"/>'			,type : 'string' },
			{ name: 'LC_SER_NO'				, text:'<t:message code="system.label.sales.lcno" default="L/C번호"/>'			,type : 'string' },
			{ name: 'CUSTOM_CODE'			, text:'CUSTOM_CODE'	,type : 'string' },
			{ name: 'OUT_DIV_CODE'			, text:'OUT_DIV_CODE'	,type : 'string' },
			{ name: 'ORDER_P'				, text:'ORDER_P'		,type : 'string' },
			{ name: 'ORDER_O'				, text:'ORDER_O'		,type : 'string' },
			{ name: 'TAX_TYPE'				, text:'TAX_TYPE'		,type : 'string' },
			{ name: 'WH_CODE'				, text:'WH_CODE'		,type : 'string' },
			{ name: 'MONEY_UNIT'			, text:'MONEY_UNIT'		,type : 'string' },
			{ name: 'EXCHG_RATE_O'			, text:'EXCHG_RATE_O'	,type : 'uniER' },
			{ name: 'ACCOUNT_YNC'			, text:'<t:message code="system.label.sales.salessubject" default="매출대상"/>'			,type : 'string', comboType: 'AU', comboCode: 'S014' },
			{ name: 'DISCOUNT_RATE'			, text:'DISCOUNT_RATE'	,type : 'string' },
			{ name: 'ORDER_PRSN'			, text:'ORDER_PRSN'		,type : 'string' },
			{ name: 'DVRY_CUST_CD'			, text:'DVRY_CUST_CD'	,type : 'string' },
			{ name: 'SALE_CUST_CD'			, text:'SALE_CUST_CD'	,type : 'string' },
			{ name: 'SALE_CUST_NM'			, text:'<t:message code="system.label.sales.salesplace" default="매출처"/>'			,type : 'string' },
			{ name: 'BILL_TYPE'				, text:'BILL_TYPE'		,type : 'string' },
			{ name: 'ORDER_TYPE'			, text:'ORDER_TYPE'		,type : 'string' },
			{ name: 'PRICE_YN'				, text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'			,type : 'string', comboType: 'AU', comboCode: 'S003' },
			{ name: 'PO_SEQ'				, text:'PO_SEQ'			,type : 'string' },
			{ name: 'CREDIT_YN'				, text:'CREDIT_YN'		,type : 'string' },
			{ name: 'WON_CALC_BAS'			, text:'WON_CALC_BAS'	,type : 'string' },
			{ name: 'TAX_INOUT'				, text:'TAX_INOUT'		,type : 'string' },
			{ name: 'AGENT_TYPE'			, text:'AGENT_TYPE'		,type : 'string' },
			{ name: 'STOCK_CARE_YN'			, text:'STOCK_CARE_YN'	,type : 'string' },
			{ name: 'STOCK_UNIT'			, text:'STOCK_UNIT'		,type : 'string' },
			{ name: 'DVRY_CUST_NAME' 		, text:'<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			,type : 'string' },
			{ name: 'RETURN_Q_YN'			, text:'RETURN_Q_YN'	,type : 'string' },
			{ name: 'DIV_CODE'				, text:'DIV_CODE'		,type : 'string' },
			{ name: 'ORDER_TAX_O'			, text:'ORDER_TAX_O'	,type : 'string' },
			{ name: 'EXCESS_RATE'			, text:'EXCESS_RATE'	,type : 'string' },
			{ name: 'DEPT_CODE'				, text:'DEPT_CODE'		,type : 'string' },
			{ name: 'ITEM_ACCOUNT'			, text:'ITEM_ACCOUNT'	,type : 'string' },
			{ name: 'STOCK_Q'				, text:'STOCK_Q'		,type : 'string' },
			{ name: 'REMARK'				, text:'REMARK'			,type : 'string' },
			{ name: 'PRICE_TYPE'			, text:'PRICE_TYPE'		,type : 'string' },
			{ name: 'ORDER_FOR_WGT_P'		, text:'ORDER_FOR_WGT_P',type : 'string' },
			{ name: 'ORDER_FOR_VOL_P'		, text:'ORDER_FOR_VOL_P',type : 'string' },
			{ name: 'ORDER_WGT_P'			, text:'ORDER_WGT_P'	,type : 'string' },
			{ name: 'ORDER_VOL_P'			, text:'ORDER_VOL_P'	,type : 'string' },
			{ name: 'WGT_UNIT'				, text:'WGT_UNIT'		,type : 'string' },
			{ name: 'UNIT_WGT'				, text:'UNIT_WGT'		,type : 'string' },
			{ name: 'VOL_UNIT'				, text:'VOL_UNIT'		,type : 'string' },
			{ name: 'UNIT_VOL'				, text:'UNIT_VOL'		,type : 'string' },
			{ name: 'LOT_YN'				, text:'LOT_YN'			,type : 'string' },
			{ name: 'NATION_INOUT'			, text:'NATION_INOUT'	,type : 'string' }
		] 
	});
	//수주(오퍼) 참조 스토어 정의
	var salesOrderStore = Unilite.createStore('s_str105ukrv_mitsalesOrderStore', {
		model	: 's_str105ukrv_mitsalesOrderModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api: {
				read	: 's_str105ukrv_mitService.selectSalesOrderList'
			}
		},
		loadStoreRecords : function() {
			var param= salesOrderSearch.getValues();
			console.log( param );
			param.WH_CODE		= panelResult.getValue('WH_CODE');
			param.WH_CELL_CODE	= panelResult.getValue('WH_CELL_CODE'); 
			this.load({
				params : param
			});
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
									&& (record.data['ORDER_SEQ'] == item.data['SER_NO'])
									)	
								{
									deleteRecords.push(item);
								}
							});
						});
						store.remove(deleteRecords);
					}
				}
			}
		}
	});
	//수주(오퍼) 참조 그리드 정의
	var salesOrderGrid = Unilite.createGrid('s_str105ukrv_mitsalesOrderGrid', {
		// title: '기본',
		layout : 'fit',
		store: salesOrderStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false, mode: 'SIMPLE' }), 
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns:  [
			{ dataIndex: 'ORDER_NUM'				,  width: 100 }, 
			{ dataIndex: 'SER_NO'					,  width: 66 },
			{ dataIndex: 'SO_KIND'					,  width: 66 },
			{ dataIndex: 'INOUT_TYPE_DETAIL'		,  width: 80, hidden: true },
			{ dataIndex: 'ITEM_CODE'				,  width: 120 },
			{ dataIndex: 'ITEM_NAME'				,  width: 113 },
			{ dataIndex: 'SPEC'						,  width: 113 },
			{ dataIndex: 'ORDER_UNIT'				,  width: 66, align: 'center' },
			{ dataIndex: 'TRANS_RATE'				,  width: 40 },
			{ dataIndex: 'DVRY_DATE'				,  width: 80 },
			{ dataIndex: 'NOT_INOUT_Q'				,  width: 80 },
			{ dataIndex: 'ORDER_Q'					,  width: 80 },
			{ dataIndex: 'ISSUE_REQ_Q'				,  width: 100 },
			{ dataIndex: 'R_LOT_NO'					,  width: 120 },
			{ dataIndex: 'ORDER_WGT_Q'				,  width: 100, hidden: true },
			{ dataIndex: 'ORDER_VOL_Q'				,  width: 100, hidden: true },
			{ dataIndex: 'PROJECT_NO'				,  width: 86 },
			{ dataIndex: 'CUSTOM_NAME'				,  width: 120 },
			{ dataIndex: 'PO_NUM'					,  width: 86 },
			{ dataIndex: 'PAY_METHODE1'				,  width: 100 },
			{ dataIndex: 'LC_SER_NO'				,  width: 100 },
			{ dataIndex: 'CUSTOM_CODE'				,  width: 66, hidden: true },
			{ dataIndex: 'OUT_DIV_CODE'				,  width: 66, hidden: true },
			{ dataIndex: 'ORDER_P'					,  width: 66, hidden: true },
			{ dataIndex: 'ORDER_O'					,  width: 66, hidden: true },
			{ dataIndex: 'TAX_TYPE'					,  width: 66, hidden: true },
			{ dataIndex: 'WH_CODE'					,  width: 66, hidden: true },
			{ dataIndex: 'MONEY_UNIT'				,  width: 66, hidden: true },
			{ dataIndex: 'EXCHG_RATE_O'				,  width: 66, hidden: true },
			{ dataIndex: 'ACCOUNT_YNC'				,  width: 66 },
			{ dataIndex: 'DISCOUNT_RATE'			,  width: 66, hidden: true },
			{ dataIndex: 'ORDER_PRSN'				,  width: 86, hidden: true },
			{ dataIndex: 'DVRY_CUST_CD'				,  width: 66, hidden: true },
			{ dataIndex: 'SALE_CUST_CD'				,  width: 86, hidden: true },
			{ dataIndex: 'SALE_CUST_NM'				,  width: 130},
			{ dataIndex: 'BILL_TYPE'				,  width: 66, hidden: true },
			{ dataIndex: 'ORDER_TYPE'				,  width: 66, hidden: true },
			{ dataIndex: 'PRICE_YN'					,  width: 66 },
			{ dataIndex: 'PO_SEQ'					,  width: 86, hidden: true },
			{ dataIndex: 'CREDIT_YN'				,  width: 86, hidden: true },
			{ dataIndex: 'WON_CALC_BAS'				,  width: 86, hidden: true },
			{ dataIndex: 'TAX_INOUT'				,  width: 66, hidden: true },
			{ dataIndex: 'AGENT_TYPE'				,  width: 86, hidden: true },
			{ dataIndex: 'STOCK_CARE_YN'			,  width: 66, hidden: true },
			{ dataIndex: 'STOCK_UNIT'				,  width: 66, hidden: true },
			{ dataIndex: 'DVRY_CUST_NAME' 			,  width: 113 },
			{ dataIndex: 'RETURN_Q_YN'				,  width: 66, hidden: true },
			{ dataIndex: 'DIV_CODE'					,  width: 66, hidden: true },
			{ dataIndex: 'ORDER_TAX_O'				,  width: 66, hidden: true },
			{ dataIndex: 'EXCESS_RATE'				,  width: 66, hidden: true },
			{ dataIndex: 'DEPT_CODE'				,  width: 66, hidden: true },
			{ dataIndex: 'ITEM_ACCOUNT'				,  width: 66, hidden: true },
			{ dataIndex: 'STOCK_Q'					,  width: 66, hidden: true },
			{ dataIndex: 'REMARK'					,  width: 86, hidden: true },
			{ dataIndex: 'PRICE_TYPE'				,  width: 66, hidden: true },
			{ dataIndex: 'ORDER_FOR_WGT_P'			,  width: 66, hidden: true },
			{ dataIndex: 'ORDER_FOR_VOL_P'			,  width: 66, hidden: true },
			{ dataIndex: 'ORDER_WGT_P'				,  width: 66, hidden: true },
			{ dataIndex: 'ORDER_VOL_P'				,  width: 66, hidden: true },
			{ dataIndex: 'WGT_UNIT'					,  width: 66, hidden: true },
			{ dataIndex: 'UNIT_WGT'					,  width: 66, hidden: true },
			{ dataIndex: 'VOL_UNIT'					,  width: 66, hidden: true },
			{ dataIndex: 'UNIT_VOL'					,  width: 66, hidden: true },
			{ dataIndex: 'LOT_YN'					,  width: 66, hidden: true },
			{ dataIndex: 'NATION_INOUT'				,  width: 66, hidden: true }
		],
		listeners: {	
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function(orderBarcode) {
			var records = this.getSelectedRecords();
			if(!Ext.isEmpty(orderBarcode)) {				//수주번호 입력 시,
				records = orderBarcode;
			}
			//20191118 참조적용 로직 변경 :  기존로직 주석
//			Ext.each(records, function(record,i){	
//				UniAppManager.app.onNewDataButtonDown();
//				if(!Ext.isEmpty(orderBarcode)) {			//수주번호 입력 시,
//					detailGrid.setSalesOrderData(record);
//					
//				} else {
//					detailGrid.setSalesOrderData(record.data);
//				}
//			});
			//20191118 참조적용 로직 변경
			UniAppManager.app.fnMakeSof100tDataRef(records, orderBarcode);

			this.deleteSelectedRow();
			detailStore.fnOrderAmtSum();
			detailStore.sort([{property: 'ORDER_NUM'	, direction: 'ASC'	, mode: 'multi'}
							, {property: 'ORDER_SEQ'	, direction: 'ASC'	, mode: 'multi'}
							, {property: 'CUSTOM_NAME'	, direction: 'ASC'	, mode: 'multi'}
							, {property: 'SALE_PRSN'	, direction: 'ASC'	, mode: 'multi'}
							, {property: 'ITEM_CODE'	, direction: 'ASC'	, mode: 'multi'}
			]);
			CustomCodeInfo.gsAgentType		= records[0].AGENT_TYPE;
			CustomCodeInfo.gsCustCreditYn	= records[0].CREDIT_YN;
			CustomCodeInfo.gsUnderCalBase	= records[0].WON_CALC_BAS;
			CustomCodeInfo.gsTaxInout		= records[0].TAX_TYPE;
			CustomCodeInfo.gsbusiPrsn		= records[0].ORDER_PRSN;
		}
	});
	//수주(오퍼) 참조 메인
	function opensalesOrderWindow() {
		if(!panelResult.getInvalidMessage()) return false;
		if(Ext.isEmpty(panelResult.getValue('WH_CODE')) || Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))) {
			Unilite.messageBox('출고창고 / 출고창고Cell은 필수 입력입니다.');
			return false;
		}
		if(!refersalesOrderWindow) {
			refersalesOrderWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.sales.soofferrefer" default="수주(오퍼)참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				
				items: [salesOrderSearch, salesOrderGrid],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
						handler: function() {
							salesOrderStore.loadStoreRecords();
						},
						disabled: false
					}, 
					{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.sales.issueapply" default="출고적용"/>',
						handler: function() {
							salesOrderGrid.returnData();
						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.sales.issueapplyclose" default="출고적용후 닫기"/>',
						handler: function() {
							salesOrderGrid.returnData();
							refersalesOrderWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.sales.close" default="닫기"/>',
						handler: function() {
							if(detailStore.getCount() == 0){
								panelResult.setAllFieldsReadOnly(false);
							}
							refersalesOrderWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						panelResult.getField('BARCODE').focus();
						//salesOrderSearch.clearForm();
						//salesOrderGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						//salesOrderSearch.clearForm();
						//salesOrderGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						salesOrderSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
						salesOrderSearch.setValue('MONEY_UNIT',panelResult.getValue('MONEY_UNIT'));
						salesOrderSearch.setValue('CUSTOM_CODE',panelResult.getValue('CUSTOM_CODE'));
						salesOrderSearch.setValue('CUSTOM_NAME',panelResult.getValue('CUSTOM_NAME'));
						salesOrderSearch.setValue('CREATE_LOC',panelResult.getValue('CREATE_LOC'));
						salesOrderSearch.setValue('DVRY_DATE_TO', panelResult.getValue('INOUT_DATE'));
						salesOrderSearch.setValue('DVRY_DATE_FR', UniDate.get('startOfMonth', panelResult.getValue('INOUT_DATE')));
//  					salesOrderSearch.setValue('DVRY_DATE_FR', UniDate.get('startOfMonth', salesOrderSearch.getValue('DVRY_DATE_TO')));
						if(panelResult.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
							salesOrderSearch.setValue('NATION_INOUT', '2');
						}else{
							salesOrderSearch.setValue('NATION_INOUT', '1');
						}
						salesOrderStore.loadStoreRecords();
					}
				}
			})
		}
		refersalesOrderWindow.center();
		refersalesOrderWindow.show();
	}


	/** 20200130 수주번호 팝업 추가
	 */
	var orderNumSearch = Unilite.createSearchForm('OrderNumForm', {
		layout	: {type : 'uniTable', columns : 3},
		items	:[{
			fieldLabel		: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'DVRY_DATE_FR',
			endFieldName	: 'DVRY_DATE_TO',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.soplace" default="수주처"/>',
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			xtype	: 'hiddenfield',
			name	: 'DIV_CODE'
		}]
	});
	//수주번호 팝업 모델
	Unilite.defineModel('orderNumModel', {
		fields: [
			{name: 'ORDER_NUM'		,text: '<t:message code="system.label.common.sono" default="수주번호"/>'			,type: 'string'},
			{name: 'ORDER_DATE'		,text: '<t:message code="system.label.common.sodate" default="수주일"/>'			,type: 'uniDate'},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.common.soplace" default="수주처"/>'			,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.common.soplace" default="수주처"/>'			,type: 'string'},
			{name: 'MONEY_UNIT'		,text:  '<t:message code="system.label.sales.currency" default="화폐"/>'			,type: 'string'},
			{name: 'ORDER_Q'		,text: '<t:message code="system.label.sales.soqty" default="수주량"/>'				,type: 'uniQty'},
			{name: 'ORDER_O'		,text: '<t:message code="system.label.sales.soamount" default="수주액"/>'			,type: 'uniFC'}
		]
	});
	//수주번호 팝업 스토어
	var orderNumStore = Unilite.createStore('orderNumStore', {
		model	: 'orderNumModel',
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
				read: 's_str105ukrv_mitService.getOrderNum'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords	= detailStore.data.filterBy(detailStore.filterNewOnly);
					var delRecords		= new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								if((record.data['ORDER_NUM'] == item.data['ORDER_NUM'])
								) {
									delRecords.push(item);
								}
							});
						});
						store.remove(delRecords);
					}
				}
			}
		},
		loadStoreRecords : function() {
			var param = orderNumSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//수주번호 팝업 그리드
	var orderNumGrid = Unilite.createGrid('orderNumGrid', {
		store	: orderNumStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false }),
		uniOpt	: {
			expandLastColumn	: true,
			onLoadSelectFirst	: false
		},
		columns:  [
			{dataIndex: 'ORDER_NUM'			, width: 110},
			{dataIndex: 'ORDER_DATE'		, width: 80},
			{dataIndex: 'CUSTOM_CODE'		, width: 110	, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 130},
			{dataIndex: 'MONEY_UNIT'		, width: 80		, align: 'center'},
			{dataIndex: 'ORDER_Q'			, width: 100},
			{dataIndex: 'ORDER_O'			, width: 100}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record, i){
				detailGrid.focus();
				Ext.getBody().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
				fnEnterOrderBarcode(record.get('ORDER_NUM'));
				panelResult.setValue('ORDER_BARCODE', '');
			});
			this.getStore().remove(records);
		}
	});
	//수주번호 팝업  메인
	function openOrderNumPopup() {
		orderNumSearch.setValue('CUSTOM_CODE'	, panelResult.getValue('CUSTOM_CODE'));
		orderNumSearch.setValue('CUSTOM_NAME'	, panelResult.getValue('CUSTOM_NAME'));
		orderNumSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));

		if(!orderNumWindow) {
			orderNumWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.sono" default="수주번호"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [orderNumSearch, orderNumGrid],
				tbar	: ['->',{
					itemId	: 'queryBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						orderNumStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.issueapply" default="출고적용"/>',
					handler	: function() {
						orderNumGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.sales.issueapplyclose" default="출고적용후 닫기"/>',
					handler	: function() {
						orderNumGrid.returnData();
						orderNumWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						if(detailStore.getCount() == 0){
							panelResult.setAllFieldsReadOnly(false);
						}
						orderNumWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						orderNumSearch.clearForm();
						panelResult.setValue('ORDER_BARCODE', '');
						// orderNumGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						orderNumSearch.clearForm();
						panelResult.setValue('ORDER_BARCODE', '');
						// orderNumGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						orderNumStore.loadStoreRecords();
					}
				}
			})
		}
		orderNumWindow.center();
		orderNumWindow.show();
	}



	/** 20200401 추가: 출하지시번호 팝업
	 */
	var issueReqNumSearch = Unilite.createSearchForm('issueReqNumForm', {
		layout	: {type : 'uniTable', columns : 3},
		items	:[{
			fieldLabel		: '출고예정일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ISSUE_DATE_FR',
			endFieldName	: 'ISSUE_DATE_TO',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '거래처',
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),
		Unilite.popup('ORDER_NUM',{
			fieldLabel		: '<t:message code="system.label.sales.sono" default="수주번호"/>',
			textFieldName	: 'ORDER_NUM',
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
					popup.setExtParam({'DIV_CODE'	: panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			xtype	: 'hiddenfield',
			name	: 'DIV_CODE'
		}]
	});
	//출하지시번호 팝업 모델
	Unilite.defineModel('issueReqNumModel', {
		fields: [
			{name: 'ISSUE_REQ_NUM'	,text: '출하지시번호'			,type: 'string'},
//			{name: 'ISSUE_REQ_SEQ'	,text: '순번'				,type: 'int'},
			{name: 'ISSUE_DATE'		,text: '출하지시예정일'		,type: 'uniDate'},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.common.soplace" default="수주처"/>'			,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.common.soplace" default="수주처"/>'			,type: 'string'},
			{name: 'MONEY_UNIT'		,text: '<t:message code="system.label.sales.currency" default="화폐"/>'			,type: 'string'},
			{name: 'ISSUE_REQ_QTY'	,text: '출하지시량'			,type: 'uniQty'},
			{name: 'ISSUE_REQ_AMT'	,text: '출하지시금액'			,type: 'uniFC'}
		]
	});
	//출하지시번호 팝업 스토어
	var issueReqNumStore = Unilite.createStore('issueReqNumStore', {
		model	: 'issueReqNumModel',
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
				read: 's_str105ukrv_mitService.getIssueReqNum'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords	= detailStore.data.filterBy(detailStore.filterNewOnly);
					var delRecords		= new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								if((record.data['ISSUE_REQ_NUM'] == item.data['ISSUE_REQ_NUM'] && record.data['ISSUE_REQ_SEQ'] == item.data['ISSUE_REQ_SEQ'])
								) {
									delRecords.push(item);
								}
							});
						});
						store.remove(delRecords);
					}
				}
			}
		},
		loadStoreRecords : function() {
			var param = issueReqNumSearch.getValues();
			param.WH_CODE = panelResult.getValue('WH_CODE');
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//출하지시번호 팝업 그리드
	var issueReqNumGrid = Unilite.createGrid('issueReqNumGrid', {
		store	: issueReqNumStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			//20200403 추가: 거래처 같은 것만 선택되도록 수정
			listeners: {
				beforeselect : function( me, record, index, eOpts ){
					var selectedCustom = me.selected.items[0];
					if(Ext.isEmpty(selectedCustom) || selectedCustom.get('CUSTOM_CODE') == record.get('CUSTOM_CODE')) {
						return true;
					} else {
//						Unilite.messageBox('<t:message code="system.message.sales.message148" default="동일한 거래처만 선택 가능합니다."/>');
						return false;
					}
				},
				beforedeselect : function( me, record, index, eOpts ){
				}
			}
		}),
		uniOpt	: {
			expandLastColumn	: true,
			onLoadSelectFirst	: false
		},
		columns:  [
			{dataIndex: 'ISSUE_REQ_NUM'	, width: 110},
//			{dataIndex: 'ISSUE_REQ_SEQ'	, width: 80		, align: 'center'},
			{dataIndex: 'ISSUE_DATE'	, width: 100},
			{dataIndex: 'CUSTOM_CODE'	, width: 110	, hidden: true},
			{dataIndex: 'CUSTOM_NAME'	, width: 130},
			{dataIndex: 'MONEY_UNIT'	, width: 80		, align: 'center'},
			{dataIndex: 'ISSUE_REQ_QTY'	, width: 100},
			{dataIndex: 'ISSUE_REQ_AMT'	, width: 100}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record, i){
				detailGrid.focus();
				Ext.getBody().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
				fnEnterIssueBarcode(record.get('ISSUE_REQ_NUM'));
				panelResult.setValue('ISSUE_REQ_BARCODE', '');
			});
			this.getStore().remove(records);
		}
	});
	//출하지시번호 팝업  메인
	function openIssueReqNumPopup() {
		issueReqNumSearch.setValue('CUSTOM_CODE'	, panelResult.getValue('CUSTOM_CODE'));
		issueReqNumSearch.setValue('CUSTOM_NAME'	, panelResult.getValue('CUSTOM_NAME'));
		issueReqNumSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));

		if(!issueReqNumWindow) {
			issueReqNumWindow = Ext.create('widget.uniDetailWindow', {
				title	: '출하지시번호',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [issueReqNumSearch, issueReqNumGrid],
				tbar	: ['->',{
					itemId	: 'queryBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						issueReqNumStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.issueapply" default="출고적용"/>',
					handler	: function() {
						issueReqNumGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.sales.issueapplyclose" default="출고적용후 닫기"/>',
					handler	: function() {
						issueReqNumGrid.returnData();
						issueReqNumWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						if(detailStore.getCount() == 0){
							panelResult.setAllFieldsReadOnly(false);
						}
						issueReqNumWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						issueReqNumSearch.clearForm();
						panelResult.setValue('ISSUE_REQ_BARCODE', '');
						// issueReqNumGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						issueReqNumSearch.clearForm();
						panelResult.setValue('ISSUE_REQ_BARCODE', '');
						// issueReqNumGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						issueReqNumStore.loadStoreRecords();
					}
				}
			})
		}
		issueReqNumWindow.center();
		issueReqNumWindow.show();
	}



	var temSaveStore = Unilite.createStore('s_str105ukrv_mitTemSaveStore', {
		model	: 's_str105ukrv_mitDetailModel',
		proxy	: tempProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			allDeletable: false,			// 전체 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				panelResult.getField('BARCODE').focus();
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		loadStoreRecords: function() {
			var param = panelResult.getValues();

			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
				}
			});
		},
		saveStore: function(saveFlag) {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var orderNum = panelResult.getValue('INOUT_NUM');
			var isErr = false;
			Ext.each(list, function(record, index) {
				if(record.get('ACCOUNT_YNC') == 'Y') {
					if(record.get('ORDER_UNIT_P') == 0) {
						Unilite.messageBox((index + 1) + '<t:message code="system.message.sales.message060" default="행의 입력값을 확인해 주세요."/>\n' + '<t:message code="system.label.sales.price" default="단가"/>: <t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
						isErr = true;
					}
					if(record.get('ORDER_UNIT_O') == 0) {
						Unilite.messageBox((index + 1) + '<t:message code="system.message.sales.message060" default="행의 입력값을 확인해 주세요."/>\n' + '<t:message code="system.label.sales.amount" default="금액"/>: <t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
						isErr = true;
					}
				}
				if(record.data['INOUT_NUM'] != orderNum) {
					record.set('INOUT_NUM', orderNum);
				}
				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
					Unilite.messageBox((index + 1) + '<t:message code="system.message.sales.message060" default="행의 입력값을 확인해 주세요."/>', 'LOT NO:' + '<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					isErr = true;
					return false;
				}
			});
			if(isErr) return false;
			
//			var totRecords = detailStore.data.items;
//			Ext.each(totRecords, function(record, index) {
//				record.set('SORT_SEQ', index+1);
//			});
			//1. 마스터 정보 파라미터 구성
			var paramMaster			= panelResult.getValues();	//syncAll 수정
			paramMaster.SAVE_FLAG	= saveFlag;

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("INOUT_NUM", master.INOUT_NUM);
					} 
				};
				this.syncAllDirect(config);
			} else {
				tempGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	var tempGrid = Unilite.createGrid('s_str105ukrv_mitTempGrid', {
		store	: temSaveStore,
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst : false
		},
		columns:  [
			{dataIndex: 'INOUT_SEQ'				, width:60	,hidden: true},
//			{dataIndex: 'INOUT_CODE'			, width:100 },
			{dataIndex: 'SALE_CUSTOM_CODE'		, width:100 },
			{dataIndex: 'CUSTOM_NAME'			, width:150 },
			{dataIndex: 'ORDER_NUM'				, width:120 },
			{dataIndex: 'ISSUE_REQ_NUM'			, width:120},
			{dataIndex: 'INOUT_NUM'				, width:120 },
			{dataIndex: 'INOUT_DATE'			, width:100 },
			//저장 시, 필요한 컬럼 (HIDDEN)
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width:80	,hidden: true},
			{dataIndex: 'WH_CODE'				, width:93	,hidden: true},
			{dataIndex: 'WH_NAME'				, width:93 	,hidden: true},
			{dataIndex: 'WH_CELL_CODE'			, width:120	,hidden: true},
			{dataIndex: 'WH_CELL_NAME'			, width:100	,hidden: true},
			{dataIndex: 'SALE_DIV_CODE'			, width:100	,hidden: true},
			{dataIndex: 'ITEM_CODE'				, width:113	,hidden: true},
			{dataIndex: 'ITEM_NAME'				, width:200	,hidden: true},
			{dataIndex: 'SPEC'					, width:150	,hidden: true},
			{dataIndex: 'LOT_NO'				, width:120	,hidden: true},
			{dataIndex: 'DISCOUNT_RATE'			, width:80	,hidden: true},
			{dataIndex: 'ORDER_UNIT'			, width:80	,hidden: true},
			{dataIndex: 'ORDER_UNIT_Q'			, width:93	,hidden: true},
			{dataIndex: 'ITEM_STATUS'			, width:66	,hidden: true},
			{dataIndex: 'ORDER_NOT_Q'			, width:66	,hidden: true},
			{dataIndex: 'ISSUE_NOT_Q'			, width:66	,hidden: true},
			{dataIndex: 'TRANS_RATE'			, width:66	,hidden: true},
			{dataIndex: 'ORDER_UNIT_P'			, width:66	,hidden: true},
			{dataIndex: 'ORDER_UNIT_O'			, width:66	,hidden: true},
			{dataIndex: 'INOUT_TAX_AMT'			, width:66	,hidden: true},
			{dataIndex: 'ORDER_AMT_SUM'			, width:66	,hidden: true},
			{dataIndex: 'TAX_TYPE'				, width:66	,hidden: true},
			{dataIndex: 'STOCK_Q'				, width:66	,hidden: true},
			{dataIndex: 'ORDER_STOCK_Q'			, width:66	,hidden: true},
			{dataIndex: 'SALE_PRSN'				, width:66	,hidden: true},
			{dataIndex: 'PRICE_TYPE'			, width:66	,hidden: true},
			{dataIndex: 'INOUT_WGT_Q'			, width:66	,hidden: true},
			{dataIndex: 'INOUT_FOR_WGT_P'		, width:66	,hidden: true},
			{dataIndex: 'INOUT_VOL_Q'			, width:66	,hidden: true},
			{dataIndex: 'INOUT_FOR_VOL_P'		, width:66	,hidden: true},
			{dataIndex: 'INOUT_WGT_P'			, width:66	,hidden: true},
			{dataIndex: 'INOUT_VOL_P'			, width:66	,hidden: true},
			{dataIndex: 'WGT_UNIT'				, width:66	,hidden: true},
			{dataIndex: 'UNIT_WGT'				, width:66	,hidden: true},
			{dataIndex: 'VOL_UNIT'				, width:66	,hidden: true},
			{dataIndex: 'UNIT_VOL'				, width:66	,hidden: true},
			{dataIndex: 'TRANS_COST'			, width:66	,hidden: true},
			{dataIndex: 'PRICE_YN'				, width:66	,hidden: true},
			{dataIndex: 'ACCOUNT_YNC'			, width:66	,hidden: true},
			{dataIndex: 'DELIVERY_DATE'			, width:66	,hidden: true},
			{dataIndex: 'DELIVERY_TIME'			, width:66	,hidden: true},
			{dataIndex: 'RECEIVER_ID'			, width:66	,hidden: true},
			{dataIndex: 'RECEIVER_NAME'			, width:66	,hidden: true},
			{dataIndex: 'TELEPHONE_NUM1'		, width:66	,hidden: true},
			{dataIndex: 'TELEPHONE_NUM2'		, width:66	,hidden: true},
			{dataIndex: 'ADDRESS'				, width:66	,hidden: true},
			{dataIndex: 'SALE_CUST_CD'			, width:66	,hidden: true},
			{dataIndex: 'DVRY_CUST_CD'			, width:66	,hidden: true},
			{dataIndex: 'DVRY_CUST_NAME'		, width:66	,hidden: true},
			{dataIndex: 'ORDER_CUST_CD'			, width:66	,hidden: true},
			{dataIndex: 'PLAN_NUM'				, width:66	,hidden: true},
			{dataIndex: 'BASIS_NUM'				, width:66	,hidden: true},
			{dataIndex: 'PAY_METHODE1'			, width:66	,hidden: true},
			{dataIndex: 'LC_SER_NO'				, width:66	,hidden: true},
			{dataIndex: 'REMARK'				, width:66	,hidden: true},
			{dataIndex: 'LOT_ASSIGNED_YN'		, width:66	,hidden: true},
			{dataIndex: 'INOUT_METH'			, width:66	,hidden: true},
			{dataIndex: 'INOUT_TYPE'			, width:66	,hidden: true},
			{dataIndex: 'DIV_CODE'				, width:66	,hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'		, width:66	,hidden: true},
			{dataIndex: 'SALE_CUSTOM_CODE'		, width:66	,hidden: true},
			{dataIndex: 'CREATE_LOC'			, width:66	,hidden: true},
			{dataIndex: 'UPDATE_DB_USER'		, width:66	,hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'		, width:66	,hidden: true},
			{dataIndex: 'MONEY_UNIT'			, width:66	,hidden: true},
			{dataIndex: 'EXCHG_RATE_O'			, width:66	,hidden: true},
			{dataIndex: 'ORIGIN_Q'				, width:66	,hidden: true},
			{dataIndex: 'ORDER_NOT_Q'			, width:66	,hidden: true},
			{dataIndex: 'ISSUE_NOT_Q'			, width:66	,hidden: true},
			{dataIndex: 'ORDER_SEQ'				, width:66	,hidden: true},
			{dataIndex: 'ISSUE_REQ_SEQ'			, width:66	,hidden: true},
			{dataIndex: 'BASIS_SEQ'				, width:66	,hidden: true},
			{dataIndex: 'ORDER_TYPE'			, width:66	,hidden: true},
			{dataIndex: 'STOCK_UNIT'			, width:66	,hidden: true},
			{dataIndex: 'BILL_TYPE'				, width:66	,hidden: true},
			{dataIndex: 'SALE_TYPE'				, width:66	,hidden: true},
			{dataIndex: 'CREDIT_YN'				, width:66	,hidden: true},
			{dataIndex: 'ACCOUNT_Q'				, width:66	,hidden: true},
			{dataIndex: 'SALE_C_YN'				, width:66	,hidden: true},
			{dataIndex: 'INOUT_PRSN'			, width:66	,hidden: true},
			{dataIndex: 'WON_CALC_BAS'			, width:66	,hidden: true},
			{dataIndex: 'TAX_INOUT'				, width:66	,hidden: true},
			{dataIndex: 'AGENT_TYPE'			, width:66	,hidden: true},
			{dataIndex: 'STOCK_CARE_YN'			, width:66	,hidden: true},
			{dataIndex: 'RETURN_Q_YN'			, width:66	,hidden: true},
			{dataIndex: 'REF_CODE2'				, width:66	,hidden: true},
			{dataIndex: 'EXCESS_RATE'			, width:66	,hidden: true},
			{dataIndex: 'SRC_ORDER_Q'			, width:66	,hidden: true},
			{dataIndex: 'SOF110T_PRICE'			, width:66	,hidden: true},
			{dataIndex: 'SRQ100T_PRICE'			, width:66	,hidden: true},
			{dataIndex: 'COMP_CODE'				, width:66	,hidden: true},
			{dataIndex: 'DEPT_CODE'				, width:66	,hidden: true},
			{dataIndex: 'ITEM_ACCOUNT'			, width:66	,hidden: true},
			{dataIndex: 'GUBUN'					, width:66	,hidden: true},
			{dataIndex: 'TEMP_ORDER_UNIT_Q'		, width:66	,hidden: true},
//			{dataIndex: 'PURCHASE_CUSTOM_CODE'	, width:66	,hidden: true},
//			{dataIndex: 'PURCHASE_TYPE'			, width:66	,hidden: true},
			{dataIndex: 'LOT_YN'				, width:66	,hidden: true},
			{dataIndex: 'NATION_INOUT'			, width:66	,hidden: true},
			{dataIndex: 'SALE_DATE'				, width:66	,hidden: true},
			{dataIndex: 'BARCODE_KEY'			, width:66	,hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				var orderNum	= record.get('ORDER_NUM');
				//20200401 추가
				var issueReqNum	= record.get('ISSUE_REQ_NUM');
				var customCode	= record.get('SALE_CUSTOM_CODE');
				//barcodeGrid 데이터 생성 - 임시출고번호로 재조회 한 후 set
				var newDetailRecords = new Array();
				var param = {
					COMP_CODE		: record.get('COMP_CODE'),
					DIV_CODE		: record.get('DIV_CODE'),
					INOUT_NUM		: record.get('INOUT_NUM'),
					ORDER_NUM		: orderNum,
					//20200402 추가
					ISSUE_REQ_NUM	: issueReqNum
				}
				s_str105ukrv_mitService.getTempBarcodeData(param, function(provider, response){
					if(!Ext.isEmpty(provider)) {
						Ext.each(provider, function(providerRecord,i){
							newDetailRecords[i] = providerRecord;
							if(i == 0) {
								panelResult.setValue('WH_CODE'		, providerRecord.WH_CODE);
								//20190827 필터초기화 및 재설정
								panelResult.getField('WH_CELL_CODE').getStore().getFilters().removeAll();
								panelResult.getField('WH_CELL_CODE').getStore().filter('option', providerRecord.WH_CODE);
								panelResult.setValue('WH_CELL_CODE'	, providerRecord.WH_CELL_CODE);
								panelResult.setValue('EXCHG_RATE_O'	, providerRecord.EXCHG_RATE_O);
								panelResult.setValue('INOUT_NUM'	, providerRecord.INOUT_NUM);
								panelResult.setValue('INOUT_DATE'	, providerRecord.INOUT_DATE);
								panelResult.setValue('SALE_DATE'	, Ext.isEmpty(providerRecord.SALE_DATE) ? providerRecord.INOUT_DATE : providerRecord.SALE_DATE);
							}
						});
						barcodeStore.loadData(newDetailRecords, true);
						tempSaveWindow.hide();
						//20200401 추가: 조건에 따른 분개로직 추가
						if(Ext.isEmpty(issueReqNum)) {
							//detailGrid 데이터 생성: 수주번호 입력 시 로직 그대로 수행
							fnEnterOrderBarcode(orderNum, customCode);//20200401 추가
							panelResult.getField('GUBUN').setValue('1');
						} else {
							fnEnterIssueBarcode(issueReqNum, customCode);//20200401 추가
							panelResult.getField('GUBUN').setValue('2');
						}
					}
				});
			}
		}
	});
	//임시데이터 조회 window
	function openTempSaveWindow() {
		if(!tempSaveWindow) {
			tempSaveWindow = Ext.create('widget.uniDetailWindow', {
				title	: '임시저장 데이터',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [tempGrid],
				tbar	: ['->', {
					itemId : 'saveBtn',
					text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler: function() {
						tempGrid.getStore().loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler: function() {
						if(detailStore.getCount() == 0){
							panelResult.setAllFieldsReadOnly(false);
						}
						tempSaveWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						panelResult.getField('BARCODE').focus();
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function ( me, eOpts ) {
						tempGrid.getStore().loadStoreRecords();
					}
				}
			})
		}
		tempSaveWindow.center();
		tempSaveWindow.show();
	}




	//경고창
	var alertSearch = Unilite.createSearchForm('alertSearch', {
		layout	: {type : 'uniTable', columns : 1
		, tdAttrs: {width: '100%', align : 'center', style: 'background-color: #dfe8f6;'}		//cfd9e7
		},
		items	:[{
			xtype	: 'component',
			itemId	: 'TEXT_TEST',
			width	: 330,
			height	: 50,
			html	: '',
			style	: {
				marginTop	: '3px !important',
				font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
            }
		},{
			xtype	: 'container',
			padding	: '0 0 0 0',
			align	: 'center',
			items	: [{
				xtype	: 'button',
				text	: '<t:message code="system.label.sales.confirm" default="확인"/>',
				width	: 80,
				handler	: function() {
					alertWindow.hide();
				},
				disabled: false
			}]
		}]
	}); 
	function openAlertWindow() {
		if(!alertWindow) {
			alertWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.warntitle" default="경고"/>',
				width	: 350,
				height	: 120,
				layout	: {type:'vbox', align:'stretch'},
				items	: [alertSearch],
				listeners : {
					beforehide: function(me, eOpt) {
						alertSearch.clearForm();
					},
					beforeclose: function( panel, eOpts ) {
						alertSearch.clearForm();
					},
					beforeshow: function( panel, eOpts ) {
						alertSearch.down('#TEXT_TEST').setHtml(gsText);
					}/*,
					specialkey:function(field, event) {
						if(event.getKey() == event.ENTER) {
							beep();
						}
					}*/
				}		
			})
		}
		alertWindow.center();
		alertWindow.show();
	}




	/** main app
	 */
	Unilite.Main({
		id			: 's_str105ukrv_mitApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			autoScroll: true,
			items	: [
				panelResult, detailGrid, barcodeGrid
			]	
		}],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset', 'newData'], true);
			this.setDefault();
			UniAppManager.app.fnExchngRateO(true);
			Ext.getCmp('btnPrint').setDisabled(true);
			
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params); 
			}
			panelResult.getField('ORDER_BARCODE').focus();		//Reset 버튼 클릭 시, 수주번호에 포커스 강제 지정
			panelResult.onLoadSelectText('ORDER_BARCODE');
		},
		onQueryButtonDown: function() {
//			if(!panelResult.getInvalidMessage()) return;	//필수체크
			var returnNo = panelResult.getValue('INOUT_NUM');
			if(Ext.isEmpty(returnNo)) {
				openSearchInfoWindow()
			} else {
//				if(!panelResult.getInvalidMessage()) return false;
				barcodeStore.clearFilter();
				detailStore.loadStoreRecords();
				barcodeStore.loadStoreRecords();
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function() {
			if(!panelResult.setAllFieldsReadOnly(true)){
				return false;

			} else {
				var sortSeq = detailStore.max('SORT_SEQ');
				if(!sortSeq) sortSeq = 1;
				else  sortSeq += 1;
				
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
				
				var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
				var refCode1 = UniAppManager.app.fnGetSubCode1(null, inoutTypeDetail) ;	//출고유형value의 ref1
				var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2
				
				var createLoc = '';
				if(!Ext.isEmpty(panelResult.getValue('CREATE_LOC'))) {
					createLoc = panelResult.getValue('CREATE_LOC');
				}
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
				if(BsaCodeInfo.gsOptDivCode == "1"){
					saleDivCode = panelResult.getValue('DIV_CODE');
				}else{
					saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
				}
				
				var divCode = '';
				if(BsaCodeInfo.gsOptDivCode == "1"){
					saleDivCode = panelResult.getValue('DIV_CODE');
				}else{
					saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
				}
				
				var saleType = Ext.data.StoreManager.lookup('CBS_AU_S002').getAt(0).get('value'); //판매유형콤보value중 첫번째 value
				var taxInout = CustomCodeInfo.gsTaxInout;
				
				var deptCode = '';
				if(!Ext.isEmpty(panelResult.getValue('DEPT_CODE'))) {
					deptCode = panelResult.getValue('DEPT_CODE');
				}				
				
				var whCode = '';
				if(!Ext.isEmpty(panelResult.getValue('WH_CODE'))){
					whCode = panelResult.getValue('WH_CODE');
				}
				var whCellCode = '';
				if(!Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))){
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
					BARCODE_KEY			: '',
					TYPE_LEVEL			: '1',
					INOUT_SEQ			: 0,
					SORT_SEQ			: sortSeq, 
					INOUT_NUM			: inoutNum,
					INOUT_CODE			: inoutCode,
					CUSTOM_NAME			: customName,
					INOUT_TYPE_DETAIL	: inoutTypeDetail,
					REF_CODE2			: refCode2,
					ACCOUNT_YNC			: refCode1,
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
					SALE_PRSN			: salePrsn,
					NATION_INOUT		: nationInout,
					INOUT_DATE			: inoutDate,
					SALE_DATE			: saleDate
				};				
//				panelResult.setAllFieldsReadOnly(true);
				detailGrid.createRow(r);
			}
		},
		onNewDataButtonDown2: function(newValue, masterRecord) {
			var selectedRecord		= masterRecord;
			var barcodeLotNo		= newValue.split('|')[1];
			var barcodeOrderUnitQ	= newValue.split('|')[2];
			
			if(!Ext.isEmpty(barcodeLotNo)) {
				barcodeLotNo = barcodeLotNo.toUpperCase();
			}
			
			if (Ext.isEmpty(selectedRecord)) {
				Unilite.messageBox('<t:message code="system.message.sales.datacheck016" default="선택된 자료가 없습니다."/>');
				return false;
				
			} else {
				var sofInfo		= selectedRecord.get('ORDER_NUM') + selectedRecord.get('ORDER_SEQ');
				var srqInfo		= selectedRecord.get('ISSUE_REQ_NUM') + selectedRecord.get('ISSUE_REQ_SEQ');
				var BARCODE_KEY	= selectedRecord.get('myId')
				
				if(Ext.isEmpty(BARCODE_KEY)) {
					if(!Ext.isEmpty(srqInfo) && srqInfo != 0) {				//출하지시 참조일 경우,
						BARCODE_KEY = srqInfo;
						
					} else if(!Ext.isEmpty(sofInfo) && sofInfo != 0) {		//수주 참조일 경우,
						BARCODE_KEY = sofInfo;
						
					} else {
						BARCODE_KEY = fnMakeRandomKey();
					}
					selectedRecord.set('myId', BARCODE_KEY);
				}
				
				gsMaxInoutSeq = gsMaxInoutSeq;
				if(!gsMaxInoutSeq) gsMaxInoutSeq = 1;
				else  gsMaxInoutSeq += 1;
				
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
				
				var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
				var refCode1 = UniAppManager.app.fnGetSubCode1(null, inoutTypeDetail) ;	//출고유형value의 ref1
				var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2
				
				var createLoc = '';
				if(!Ext.isEmpty(panelResult.getValue('CREATE_LOC'))) {
					createLoc = panelResult.getValue('CREATE_LOC');
				}
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
				if(BsaCodeInfo.gsOptDivCode == "1"){
					saleDivCode = panelResult.getValue('DIV_CODE');
				}else{
					saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
				}
				
				var divCode = '';
				if(BsaCodeInfo.gsOptDivCode == "1"){
					saleDivCode = panelResult.getValue('DIV_CODE');
				}else{
					saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
				}
				
				var saleType = Ext.data.StoreManager.lookup('CBS_AU_S002').getAt(0).get('value'); //판매유형콤보value중 첫번째 value
				var taxInout = CustomCodeInfo.gsTaxInout;
				
				var deptCode = '';
				if(!Ext.isEmpty(panelResult.getValue('DEPT_CODE'))) {
					deptCode = panelResult.getValue('DEPT_CODE');
				}				
				
				var whCode = '';
				if(!Ext.isEmpty(panelResult.getValue('WH_CODE'))){
					whCode = panelResult.getValue('WH_CODE');
				}
				var whCellCode = '';
				if(!Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))){
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
					ITEM_CODE			: selectedRecord.get('ITEM_CODE'),
					ITEM_NAME			: selectedRecord.get('ITEM_NAME'),
					SPEC				: selectedRecord.get('SPEC'),
					ORDER_UNIT			: selectedRecord.get('ORDER_UNIT'),
					INOUT_SEQ			: gsMaxInoutSeq,
					INOUT_NUM			: inoutNum,
					INOUT_CODE			: inoutCode,
					CUSTOM_NAME			: customName,
					INOUT_TYPE_DETAIL	: inoutTypeDetail,
					REF_CODE2			: refCode2,
					ACCOUNT_YNC			: refCode1,
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
					SALE_PRSN			: salePrsn,
					NATION_INOUT		: nationInout,
					INOUT_DATE			: inoutDate,
					SALE_DATE			: saleDate,
					BARCODE_KEY			: BARCODE_KEY
				};				
				panelResult.setAllFieldsReadOnly(true);
				barcodeGrid.createRow(r);
				
				var newRecord	= barcodeGrid.getSelectedRecord();
				var columns		= detailGrid.getColumns();
				Ext.each(columns, function(column, index) {
					newRecord.set(column.initialConfig.dataIndex, selectedRecord.get(column.initialConfig.dataIndex));
				});
				
				//20181205 - 수주/출하지시 등록에서 판매단위와 재고단위가 다를 때 로직 추가
				if(selectedRecord.get('ORDER_UNIT') != selectedRecord.get('STOCK_UNIT')) {
					var barcodeTrnsRate	= barcodeOrderUnitQ
					barcodeOrderUnitQ	= 1;
					newRecord.set('TRANS_RATE'	, barcodeTrnsRate);
				}
				//20181205 - 여기까지
				
				newRecord.set('INOUT_SEQ'	, gsMaxInoutSeq);
				newRecord.set('LOT_NO'		, barcodeLotNo);
				newRecord.set('ORDER_UNIT_Q', barcodeOrderUnitQ);
				UniAppManager.app.fnOrderAmtCal(newRecord, 'Q', 'ORDER_UNIT_Q', barcodeOrderUnitQ);
				
				//바코드 인식 한 값 detailGrid에 set
				var newDetailOderUnitQ = selectedRecord.get('ORDER_UNIT_Q') + parseInt(barcodeOrderUnitQ);
				selectedRecord.set('ORDER_UNIT_Q', newDetailOderUnitQ);
				UniAppManager.app.fnOrderAmtCal(selectedRecord, 'Q', 'ORDER_UNIT_Q', newDetailOderUnitQ);
				
				//FIFO 위한 데이터 생성
				lotNoS = panelResult.getValue('LOT_NO_S');
				if(Ext.isEmpty(lotNoS)) {
					panelResult.setValue('LOT_NO_S', barcodeLotNo);
				} else {
					panelResult.setValue('LOT_NO_S', lotNoS + ',' + barcodeLotNo);
				}
				selectedRecord.set('ORDER_NOT_Q', selectedRecord.get('ORDER_NOT_Q') - barcodeOrderUnitQ);
				panelResult.getField('BARCODE').focus();
//				beep_ok();
			}
		},
		onResetButtonDown: function() {
			gsMaxInoutSeq = 0;
			//20190820 추가: 기존 입력되어 있던 창고, 창고cell 그대로 유지 하기 위해 추가
			gsWhCode	= panelResult.getValue('WH_CODE');
			gsWhCellCode= panelResult.getValue('WH_CELL_CODE');
			panelResult.clearForm();

			panelResult.setAllFieldsReadOnly(false);
			detailStore.loadData({});
			barcodeStore.loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			barcodeStore.clearFilter();
			if(barcodeStore.isDirty()) {
				barcodeStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
				Unilite.messageBox('<t:message code="system.message.sales.message054" default="마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다."/>'); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
				return false;
			}

			var selRows	= detailGrid.getStore().data.items;
			var selRow1 = detailGrid.getSelectedRecord();;
			var selRow2	= barcodeGrid.getSelectedRecord();
			
			if(Ext.isEmpty(selRow1) && Ext.isEmpty(selRow2)) {
				Unilite.messageBox('<t:message code="system.message.sales.datacheck016" default="선택된 자료가 없습니다."/>');						//선택된 자료가 없습니다.
				return false;
			}
			if(activeGridId == 's_str105ukrv_mitGrid' && !Ext.isEmpty(selRow1) && selRow1.phantom === true) {				//detailGrid 삭제 함수 호출
				fnDeleteDetail(selRow1);
				
			} else if(activeGridId != 's_str105ukrv_mitGrid' && !Ext.isEmpty(selRow2) && selRow2.phantom === true) {		//barcodeGrid 삭제 함수 호출
				Ext.each(selRows, function(selRow,i) {
					if(selRow.get('ITEM_CODE') == selRow2.get('ITEM_CODE') /*&& selRow.get('LOT_NO') == selRow2.get('LOT_NO').split('-')[0]*/) {
						selRow1 = selRow;
					}
				});
				fnBarcodeGrid(selRow1, selRow2)
					
			} else if ('현재행을 삭제 합니다. 삭제 하시겠습니까?') {
				if( activeGridId == 's_str105ukrv_mitGrid' && !Ext.isEmpty(selRow1)) {										//detailGrid 삭제 함수 호출
					if(BsaCodeInfo.gsInoutAutoYN == "N" && selRow1.get('ACCOUNT_Q') > 0) {									//동시매출발생이 아닌 경우,매출존재체크 제외
						Unilite.messageBox('<t:message code="system.message.sales.message055" default="매출이 진행된 건은 수정/삭제할 수 없습니다."/>');	//매출이 진행된 건은 수정/삭제할 수 없습니다.
						return false;
					}
					if(selRow1.get('SALE_C_YN') == "Y"){
						Unilite.messageBox('<t:message code="system.message.sales.message056" default="계산서가 마감된 건은 수정/삭제가 불가능합니다."/>');	//계산서가 마감된 건은 수정/삭제가 불가능합니다.
						return false;
					}
					fnDeleteDetail(selRow1);
					
				} else if(activeGridId != 's_str105ukrv_mitGrid' && !Ext.isEmpty(selRow2)) {		//barcodeGrid 삭제 함수 호출
					if(BsaCodeInfo.gsInoutAutoYN == "N" && selRow2.get('ACCOUNT_Q') > 0) {	//동시매출발생이 아닌 경우,매출존재체크 제외
						Unilite.messageBox('<t:message code="system.message.sales.message055" default="매출이 진행된 건은 수정/삭제할 수 없습니다."/>');													//매출이 진행된 건은 수정/삭제할 수 없습니다.
						return false;
					}
					if(selRow2.get('SALE_C_YN') == "Y"){
						Unilite.messageBox('<t:message code="system.message.sales.message056" default="계산서가 마감된 건은 수정/삭제가 불가능합니다."/>');													//계산서가 마감된 건은 수정/삭제가 불가능합니다.
						return false;
					}
					Ext.each(selRows, function(selRow,i) {
						if(selRow.get('ITEM_CODE') == selRow2.get('ITEM_CODE') /*&& selRow.get('LOT_NO') == selRow2.get('LOT_NO').split('-')[0]*/) {
							selRow1 = selRow;
						}
					});
					fnBarcodeGrid(selRow1, selRow2)
				}
			}
			detailStore.fnOrderAmtSum();
		},
		onDeleteAllButtonDown: function() {
			var records1	= detailStore.data.items;
			var records2	= barcodeStore.data.items;
			var records		= [].concat(records1, records2);
			var isNewData	= false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
							Unilite.messageBox('<t:message code="system.message.sales.message054" default="마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다."/>');			//마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
							return false;
						}
						Ext.each(records, function(record,i) {
							if(BsaCodeInfo.gsInoutAutoYN == "N" && record.get('ACCOUNT_Q') > 0) {//동시매출발생이 아닌 경우,매출존재체크 제외
								Unilite.messageBox('<t:message code="system.message.sales.message055" default="매출이 진행된 건은 수정/삭제할 수 없습니다."/>');		//매출이 진행된 건은 수정/삭제할 수 없습니다.
								deletable = false;
								return false;
							}
							if(record.get('SALE_C_YN') == "Y"){
								Unilite.messageBox('<t:message code="system.message.sales.message056" default="계산서가 마감된 건은 수정/삭제가 불가능합니다."/>');		//계산서가 마감된 건은 수정/삭제가 불가능합니다.
								deletable = false;
								return false;
							}
						});
						/*---------삭제전 로직 구현 끝-----------*/
						
						if(deletable){
							detailGrid.reset();
							barcodeGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				barcodeGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
				//FIFO 위한 데이터 생성 (초기화)
//				gsLotNoS = ''
				panelResult.setValue('LOT_NO_S', '');
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('s_str105ukrv_mitAdvanceSerch');	
			if(as.isHidden()) {
				as.show();
			} else {
				as.hide()
			}
		},
		setDefault: function() {
			/*영업담당 filter set*/
			gsMonClosing = '';	//월마감 여부
			gsDayClosing = '';	//일마감 여부	
			var field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var param = {
				"DIV_CODE": UserInfo.divCode,
				"DEPT_CODE": UserInfo.deptCode
			};
			s_str105ukrv_mitService.deptWhcode(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					 panelResult.setValue('ALL_CHANGE_WH_CODE', provider['WH_CODE']);
				}
			});
			var inoutPrsn = UniAppManager.app.fnGetInoutPrsnDivCode(UserInfo.divCode);		//사업장의 첫번째 영업담당자 set 
			
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('INOUT_PRSN'	, inoutPrsn);								//사업장에 따른 수불담당자 불러와야함
			panelResult.setValue('INOUT_DATE'	, new Date());
			panelResult.setValue('SALE_DATE'	, new Date());
			panelResult.setValue('CREATE_LOC'	, '1');
//			panelResult.setValue('MONEY_UNIT'	, BsaCodeInfo.gsMoneyUnit);
			panelResult.setValue('DEPT_CODE'	, UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME'	, UserInfo.deptName);
			panelResult.setValue('EXCHG_RATE_O'	, '1');
			panelResult.setValue('MONEY_UNIT'	, BsaCodeInfo.gsMoneyUnit);
			panelResult.setValue('NATION_INOUT'	, '1');
//			panelResult.setValue('REMAIN_CREDIT', UniSales.fnGetCustCredit(UserInfo.compCode, detailForm.getValue('DIV_CODE'), detailForm.getValue("CUSTOM_CODE"), detailForm.getValue('ORDER_DATE'), UserInfo.currency));
			
			panelResult.setValue('EXCHG_RATE_O'	, 1);										//환율
			panelResult.setValue('TOT_SALE_TAXI', 0);										//과세초액
			panelResult.setValue('TOT_TAXI'		, 0);										//세액합계(2)
//			panelResult.setValue('TOT_QTY'		, 0);										//수량총계
			panelResult.setValue('TOT_SALENO_TAXI', 0);										//면세총액(3)
			panelResult.setValue('TOTAL_AMT'	, 0);										//출고총액[(1)+(2)+(3)]
			panelResult.setValue('REM_CREDIT'	, 0);										//여신액
			
			if(BsaCodeInfo.gsAutoType == "Y"){
				panelResult.getForm().findField('INOUT_NUM').setReadOnly(true);
			}else{
				panelResult.getForm().findField('INOUT_NUM').setReadOnly(false);
			}
			panelResult.getField('TOT_SALE_TAXI').setReadOnly(true);
			panelResult.getField('TOT_TAXI').setReadOnly(true);
//			panelResult.getField('TOT_QTY').setReadOnly(true);
			panelResult.getField('TOT_SALENO_TAXI').setReadOnly(true);
			panelResult.getField('TOTAL_AMT').setReadOnly(true);

			//20190820 추가: 기존 입력되어 있던 창고, 창고cell 그대로 유지 하기 위해 추가
			panelResult.setValue('WH_CODE'		, gsWhCode);
			panelResult.setValue('WH_CELL_CODE'	, gsWhCellCode);

			//20200401 추가
			panelResult.getField('GUBUN').setValue('2');

			gsRefYn = 'N'
			
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			
			UniAppManager.setToolbarButtons('save', false);
		},
		checkForNewDetail:function() { 
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
				Unilite.messageBox('<t:message code="system.label.sales.custom" default="거래처"/>:<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
	
			/** 마스터 데이타 수정 못 하도록 설정
			 */
			panelResult.setAllFieldsReadOnly(true);
			return panelResult.setAllFieldsReadOnly(true);
		},
		fnOrderAmtCal: function(rtnRecord, sType, fieldName, nValue, taxType) {
			var dTransRate		= fieldName=='TRANS_RATE'		? nValue : Unilite.nvl(rtnRecord.get('TRANS_RATE'),1);
			var dOrderQ			= fieldName=='ORDER_UNIT_Q'		? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_Q'),0);
			var dIssueReqWgtQ	= fieldName=='INOUT_WGT_Q'		? nValue : Unilite.nvl(rtnRecord.get('INOUT_WGT_Q'),0);
			var dIssueReqVolQ	= fieldName=='INOUT_VOL_Q'		? nValue : Unilite.nvl(rtnRecord.get('INOUT_VOL_Q'),0);
			var dOrderP			= fieldName=='ORDER_UNIT_P'		? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_P'),0); 
			var saleBasisP		= fieldName=='SALE_BASIS_P'		? nValue : Unilite.nvl(rtnRecord.get('SALE_BASIS_P'),0);
			var dOrderWgtForP	= fieldName=='INOUT_FOR_WGT_P'	? nValue : Unilite.nvl(rtnRecord.get('INOUT_FOR_WGT_P'),0);
			var dOrderVolForP	= fieldName=='INOUT_FOR_VOL_P'	? nValue : Unilite.nvl(rtnRecord.get('INOUT_FOR_VOL_P'),0);
			var dOrderO			= fieldName=='ORDER_UNIT_O'		? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_O'),0);
			var dDcRate			= fieldName=='DISCOUNT_RATE'	? nValue : Unilite.nvl((100 - rtnRecord.get('DISCOUNT_RATE')),0);
			var dExchgRate		= fieldName=='EXCHG_RATE_O'		? nValue : Unilite.nvl(rtnRecord.get('EXCHG_RATE_O'),0);
			var dPriceType		= Ext.isEmpty(rtnRecord.get('PRICE_TYPE')) ? 'A' : rtnRecord.get('PRICE_TYPE');					//단가구분
			var dOrderWgtP		= 0;
			var dOrderVolP		= 0;
			var dOrderForO		= 0;
			var dOrderForP		= 0;
			//20200612 추가: 자사금액 계산시, 'JPY' 관련로직 추가
			var moneyUnit		= rtnRecord.get('MONEY_UNIT');

			if(sType == "P" || sType == "Q"){
				//20200612 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
				dOrderWgtP	= UniSales.fnExchangeApply(moneyUnit, dOrderWgtForP * dExchgRate);
				dOrderVolP	= UniSales.fnExchangeApply(moneyUnit, dOrderVolForP * dExchgRate);
				
				if(dPriceType == "A"){
					dOrderForO = dOrderQ * dOrderP 
					dOrderO	= dOrderQ * dOrderP
				}else if(dPriceType == "B"){
					dOrderForO = dIssueReqWgtQ * dOrderWgtForP
					dOrderO	= dIssueReqWgtQ * dOrderWgtP
				}else if(dPriceType == "C"){
					dOrderForO = dIssueReqVolQ * dOrderVolForP
					dOrderO	= dIssueReqVolQ * dOrderVolP
				}else{
					dOrderForO = dOrderQ * dOrderP
					dOrderO	= dOrderQ * dOrderP
				}
				
				rtnRecord.set('ORDER_UNIT_O'	, dOrderForO);
				rtnRecord.set('ORDER_UNIT_P'	, dOrderP);
				rtnRecord.set('INOUT_FOR_WGT_P'	, dOrderWgtForP);
				rtnRecord.set('INOUT_FOR_VOL_P'	, dOrderVolForP);
				
				rtnRecord.set('INOUT_WGT_P', dOrderWgtP);
				rtnRecord.set('INOUT_VOL_P', dOrderVolP);
				
				this.fnTaxCalculate(rtnRecord, dOrderO);
				
			} else if(sType == "O" && (dOrderQ > 0)){
				dOrderForP	= dOrderO / dOrderQ; 
				//20200612 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
				dOrderP		= UniSales.fnExchangeApply(moneyUnit, (dOrderO / dOrderQ) * dExchgRate);
				
				if(dIssueReqWgtQ != 0){
					dOrderWgtForP	= (dOrderO / dIssueReqWgtQ); 
					//20200612 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
					dOrderWgtP		= UniSales.fnExchangeApply(moneyUnit, (dOrderO / dIssueReqWgtQ) * dExchgRate);
				}else{
					dOrderWgtForP	= 0;
					dOrderWgtP	   = 0;
				}
				
				if(dIssueReqVolQ != 0){
					dOrderVolForP	= (dOrderO / dIssueReqVolQ) 
					//20200612 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
					dOrderVolP		= UniSales.fnExchangeApply(moneyUnit, (dOrderO / dIssueReqVolQ) * dExchgRate);
				}else{
					dOrderVolForP	= 0
					dOrderVolP	   = 0
				}
				
				if(dPriceType == "A"){
					dOrderO = dOrderForP * dOrderQ;
				}else if(dPriceType == "B"){
					dOrderO = dOrderWgtForP * dIssueReqWgtQ;
				}else if(dPriceType == "C"){
					dOrderO = dOrderVolForP * dIssueReqVolQ;
				}else{
					dOrderO = dOrderForP * dOrderQ;
				}
				
				rtnRecord.set('INOUT_WGT_P', dOrderWgtP);
				rtnRecord.set('INOUT_VOL_P', dOrderVolP);
				
				rtnRecord.set('ORDER_UNIT_P', dOrderForP);
				rtnRecord.set('INOUT_FOR_WGT_P', dOrderWgtForP);
				rtnRecord.set('INOUT_FOR_VOL_P', dOrderVolForP);
				rtnRecord.set('ORDER_UNIT_O', dOrderO);
				this.fnTaxCalculate(rtnRecord, dOrderO, taxType);
				
			} else if(sType == "C"){
				dOrderP = (dOrderP - (dOrderP * (dDcRate / 100)));
				rtnRecord.set('ORDER_UNIT_P', dOrderP);
				dOrderO = dOrderQ * dOrderP;
				rtnRecord.set('ORDER_UNIT_O', dOrderO);
				
				dOrderWgtForP = (dOrderO / dIssueReqWgtQ);
				dOrderVolForP = (dOrderO / dIssueReqVolQ);
				//20200612 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
				dOrderWgtP	= UniSales.fnExchangeApply(moneyUnit, (dOrderO / dIssueReqWgtQ) * dExchgRate);
				dOrderVolP	= UniSales.fnExchangeApply(moneyUnit, (dOrderO / dIssueReqVolQ) * dExchgRate);
				
				rtnRecord.set('INOUT_WGT_P', dOrderWgtP);
				rtnRecord.set('INOUT_VOL_P', dOrderVolP);
				rtnRecord.set('INOUT_FOR_WGT_P', dOrderWgtForP);
				rtnRecord.set('INOUT_FOR_VOL_P', dOrderVolForP);
				this.fnTaxCalculate(rtnRecord, dOrderO);
			}
		},
		fnTaxCalculate: function(rtnRecord, dOrderO, taxType) {
			var sTaxType 	  = Ext.isEmpty(taxType)? rtnRecord.get('TAX_TYPE') : taxType;
			var sWonCalBas 	  = CustomCodeInfo.gsUnderCalBase;
			var sTaxInoutType = rtnRecord.get('TAX_INOUT');
			var dVatRate = parseInt(BsaCodeInfo.gsVatRate);
			var dAmountI = dOrderO;
			var dOrderAmtO = 0;
			var dTaxAmtO = 0;
//			var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
			var numDigitOfPrice = UniFormat.Price.length - (UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length: UniFormat.Price.indexOf("."));
			if(sTaxInoutType=="1" || Ext.isEmpty(sTaxInoutType)) {	//별도
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderO, sWonCalBas, numDigitOfPrice);
				dTaxAmtO   = UniSales.fnAmtWonCalc(dOrderAmtO * dVatRate / 100, sWonCalBas, numDigitOfPrice);
			}else if(sTaxInoutType=="2") {	//포함
				dAmountI =   UniSales.fnAmtWonCalc(dAmountI, sWonCalBas, numDigitOfPrice);
				//20191212 세액계산로직 수정(통일)
//				dOrderAmtO = UniSales.fnAmtWonCalc(dAmountI / ( dVatRate + 100 ) * 100, sWonCalBas, numDigitOfPrice);
//				dTaxAmtO = 	 UniSales.fnAmtWonCalc(dAmountI - dOrderAmtO, sWonCalBas, numDigitOfPrice);
				//20200513 수정: 계산기준을 부가세액으로 통일
//				dTaxAmtO   = UniSales.fnAmtWonCalc(dAmountI * dVatRate / 100, sWonCalBas, numDigitOfPrice);
				dOrderAmtO = UniSales.fnAmtWonCalc(dAmountI / ( dVatRate + 100 ) * 100, sWonCalBas, numDigitOfPrice);
				dTaxAmtO = 	 UniSales.fnAmtWonCalc(dOrderAmtO * dVatRate / 100 , sWonCalBas, numDigitOfPrice);
				dOrderAmtO = UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), sWonCalBas, numDigitOfPrice) ;
			}
			if(sTaxType == "2") {
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderO, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice ) ; 
				dTaxAmtO = 0;
			}
			
			//자사화폐가 "KRW"일 때, 금액 소숫점 첫째자리에서 반올림
			if(BsaCodeInfo.gsMoneyUnit == 'KRW') {
				rtnRecord.set('ORDER_UNIT_O'	, dOrderAmtO.toFixed(0));
				rtnRecord.set('INOUT_TAX_AMT'	, dTaxAmtO.toFixed(0));
				rtnRecord.set('ORDER_AMT_SUM'	, (dOrderAmtO + dTaxAmtO).toFixed(0));
			
			} else {
				rtnRecord.set('ORDER_UNIT_O'	, dOrderAmtO);
				rtnRecord.set('INOUT_TAX_AMT'	, dTaxAmtO);
				rtnRecord.set('ORDER_AMT_SUM'	, (dOrderAmtO + dTaxAmtO));
			}
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
				}else if(value == 0) {
					if(fieldName == "ORDER_TAX_O") {
						if(BsaCodeInfo.gsVatRate != 0) {
							Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
							r=false;
						}
					}else {
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
					if(Ext.isEmpty(fRecord)){
						fRecord = item['codeNo']
					}
				}
			})
			return fRecord;
		},
		fnGetSubCode1: function(rtnRecord, subCode) {
			var fRecord = '';
			Ext.each(BsaCodeInfo.grsOutType, function(item, i) {
				
				if(item['codeNo'] == subCode) {
					fRecord = item['refCode1'];
					if(Ext.isEmpty(fRecord)){
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
			if(Ext.isEmpty(fRecord)){
				fRecord = 'N'
			}
			return fRecord;
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
					
			rtnRecord.set('STOCK_Q', dStockQ);
			rtnRecord.set('ORDER_STOCK_Q', dStockQ / lTrnsRate);
		},
		// UniSales.fnGetDivPriceInfo2 callback 함수
		cbGetPriceInfo: function(provider, params) {
			var dSalePrice=Unilite.nvl(provider['SALE_PRICE'],0);//판매단가(판매단위)
			var dWgtPrice = Unilite.nvl(provider['WGT_PRICE'],0);//판매단가(중량단위)
			var dVolPrice = Unilite.nvl(provider['VOL_PRICE'],0);//판매단가(부피단위)
			
			var dUnitWgt = 0;
			var dUnitVol = 0;
			if(params.sType=='I') {
				dUnitWgt = params.unitWgt;
				dUnitVol = params.unitVol;
				if(params.priceType == 'A') {
					dWgtPrice = (dUnitWgt = 0) ?	0 : dSalePrice / dUnitWgt;
					dVolPrice = (dUnitVol = 0) ?	0 : dSalePrice / dUnitVol;
				}else if(params.priceType == 'B'){
					dSalePrice = dWgtPrice  * dUnitWgt;
					dVolPrice = (dUnitVol = 0) ? 0 : dSalePrice / dUnitVol;
				}else if(params.priceType == 'C'){
					dSalePrice = dVolPrice  * dUnitVol;
					dWgtPrice = (dUnitWgt = 0) ? 0 : dSalePrice / dUnitWgt;
				}else{
					dWgtPrice = (dUnitWgt = 0) ? 0 : dSalePrice / dUnitWgt;
					dVolPrice = (dUnitVol = 0) ? 0 : dSalePrice / dUnitVol;
				}
				if(Ext.isEmpty(provider['SALE_PRICE'])){
					params.rtnRecord.set('ORDER_UNIT_P'	, 0);
					params.rtnRecord.set('SALE_BASIS_P'	, 0);
				}else{
					params.rtnRecord.set('ORDER_UNIT_P'	, provider['SALE_PRICE']);
					params.rtnRecord.set('SALE_BASIS_P'	, provider['SALE_PRICE']);
					panelResult.getField('BARCODE').focus();
				}
				params.rtnRecord.set('INOUT_WGT_P', dWgtPrice );
				params.rtnRecord.set('INOUT_VOL_P', dVolPrice );
				
				if(Ext.isEmpty(provider['SALE_TRANS_RATE'])){
					params.rtnRecord.set('TRANS_RATE', 1);
				}else{
					params.rtnRecord.set('TRANS_RATE', provider['SALE_TRANS_RATE']);
				}
				
				if(Ext.isEmpty(provider['DC_RATE'])){
					params.rtnRecord.set('DISCOUNT_RATE', 0);
				}else{
					params.rtnRecord.set('DISCOUNT_RATE', provider['DC_RATE']);
				}
				var exchangRate = panelResult.getValue('EXCHG_RATE_O');
				params.rtnRecord.set('INOUT_FOR_WGT_P'	, UniSales.fnExchangeApply2(params.rtnRecord.get('MONEY_UNIT'), dWgtPrice / exchangRate));	//20200611 수정: 외화금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply2 추가)
				params.rtnRecord.set('INOUT_FOR_VOL_P'	, UniSales.fnExchangeApply2(params.rtnRecord.get('MONEY_UNIT'), dVolPrice / exchangRate));	//20200611 수정: 외화금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply2 추가)
				
				params.rtnRecord.set('PRICE_YN',provider['PRICE_TYPE']);
				
			}
			if(params.rtnRecord.get('INOUT_FOR_VOL_P') > 0){
				UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P");
			}
		},
		fnGetSalePrsnDivCode: function(subCode){	//거래처의 영업담당자의 사업장 가져오기
			var fRecord ='';
			Ext.each(BsaCodeInfo.salePrsn, function(item, i) {
				if(item['codeNo'] == subCode) {
					fRecord = item['refCode1'];
				}
			});
			return fRecord;
		},
		fnGetInoutPrsnDivCode: function(subCode){	//사업장의 첫번째 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.inoutPrsn, function(item, i) {
				if(item['refCode1'] == subCode) {
					fRecord = item['codeNo'];
					return false;
				}
			});
			return fRecord;
		},
		fnGetWhName: function(subCode){	//창고코드로 네임 가져오기
			var whName ='';
			Ext.each(BsaCodeInfo.whList, function(item, i) {
				if(item['value'] == subCode) {
					whName = item['text'];
				}
			});
			return whName;
		},
		cbGetClosingInfo: function(params){
			gsMonClosing = params.gsMonClosing	
			gsDayClosing = params.gsDayClosing
		},
		fnExchngRateO:function(isIni, refProvider) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE')),
				"MONEY_UNIT" : panelResult.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(panelResult.getValue('MONEY_UNIT')) && panelResult.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit
					//20200402 추가: 참조적용 시 메세지 띄우지 않기 위해서
					&& Ext.isEmpty(refProvider)){
						Unilite.messageBox('<t:message code="system.message.sales.datacheck008" default="환율정보가 없습니다."/>')
//						panelResult.setValue('MONEY_UNIT', '');
//						panelResult.getField('MONEY_UNIT').focus();
						panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
						Ext.getBody().unmask();
//						return false;	//20200402 수정: 환율 정보가 없어도 조회된 데이터는 set하기 위해 주석
					}
					panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
					
					if(!Ext.isEmpty(refProvider)) {
						if(panelResult.getValue('GUBUN').GUBUN == '1') {
							salesOrderGrid.returnData(refProvider);
						} else {
							requestGrid.returnData(refProvider);
						}
						Ext.getBody().unmask();
						//첫번째 행 포커스
						detailGrid.getSelectionModel().select(0);

						// -----------------------------------------------------
						barcodeStore.clearFilter();						//filter clear 후
						var records = barcodeStore.data.items;			//비교할 records 구성
						barcodeStore.filterBy(function(record){			//다시 필터 set
							return record.get('BARCODE_KEY') == detailGrid.getSelectionModel().selected.items[0].get('myId');
						})
						var barcodeRecords = barcodeStore.data.items;
						var barcodeOrderUnitQ = 0
						Ext.each(barcodeRecords, function(barcodeRecord, i) {
							barcodeOrderUnitQ = barcodeOrderUnitQ + barcodeRecord.get('ORDER_UNIT_Q');
						});
						//detailGrid의 출고량, 미납량 수정
						detailGrid.getSelectionModel().selected.items[0].set('ORDER_UNIT_Q'	, barcodeOrderUnitQ);
						detailGrid.getSelectionModel().selected.items[0].set('ORDER_NOT_Q'	, detailGrid.getSelectionModel().selected.items[0].get('ORDER_NOT_Q') - barcodeOrderUnitQ);
						UniAppManager.app.fnOrderAmtCal(detailGrid.getSelectionModel().selected.items[0], "P")
						// -----------------------------------------------------
						panelResult.getField('BARCODE').focus();
					}
				}
			});
		},
		//20191118 참조적용 로직 변경
		fnMakeSof100tDataRef: function(records, orderBarcode) {
			if(!panelResult.setAllFieldsReadOnly(true)){
				return false;
			} else {
				var newDetailRecords = new Array();
				var sortSeq = detailStore.max('SORT_SEQ');
				if(!sortSeq) sortSeq = 1;
				else  sortSeq += 1;
				
				Ext.each(records, function(record,i){
					if(i == 0){
						sortSeq = sortSeq;
					} else {
						sortSeq += 1;
					}
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
					
					var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
					var refCode1 = UniAppManager.app.fnGetSubCode1(null, inoutTypeDetail) ;	//출고유형value의 ref1
					var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2
					
					var createLoc = '';
					if(!Ext.isEmpty(panelResult.getValue('CREATE_LOC'))) {
						createLoc = panelResult.getValue('CREATE_LOC');
					}
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
					if(BsaCodeInfo.gsOptDivCode == "1"){
						saleDivCode = panelResult.getValue('DIV_CODE');
					}else{
						saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
					}
					
					var divCode = '';
					if(BsaCodeInfo.gsOptDivCode == "1"){
						saleDivCode = panelResult.getValue('DIV_CODE');
					}else{
						saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
					}
					
					var saleType = Ext.data.StoreManager.lookup('CBS_AU_S002').getAt(0).get('value'); //판매유형콤보value중 첫번째 value
					var taxInout = CustomCodeInfo.gsTaxInout;
					
					var deptCode = '';
					if(!Ext.isEmpty(panelResult.getValue('DEPT_CODE'))) {
						deptCode = panelResult.getValue('DEPT_CODE');
					}				
					
					var whCode = '';
					if(!Ext.isEmpty(panelResult.getValue('WH_CODE'))){
						whCode = panelResult.getValue('WH_CODE');
					}
					var whCellCode = '';
					if(!Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))){
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
						BARCODE_KEY			: '',
						TYPE_LEVEL			: '1',
						INOUT_SEQ			: 0,
						SORT_SEQ			: sortSeq, 
						INOUT_NUM			: inoutNum,
						INOUT_CODE			: inoutCode,
						CUSTOM_NAME			: customName,
						INOUT_TYPE_DETAIL	: inoutTypeDetail,
						REF_CODE2			: refCode2,
						ACCOUNT_YNC			: refCode1,
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
						SALE_PRSN			: salePrsn,
						NATION_INOUT		: nationInout,
						INOUT_DATE			: inoutDate,
						SALE_DATE			: saleDate
					};
					newDetailRecords[i] = detailStore.model.create( r );

					var grdRecord = detailGrid.getSelectedRecord();
					if(!Ext.isEmpty(orderBarcode)) {			//수주번호 입력 시,
						record = record;
					} else {
						record = record.data;
					}
					
					panelResult.setValue('NATION_INOUT'			, record['NATION_INOUT']);
					panelResult.setValue('EXCHG_RATE_O'			, record['EXCHG_RATE_O']);
					panelResult.setValue('NATION_CODE'			, record['NATION_CODE']);
					newDetailRecords[i].set('INOUT_TYPE'		, "2");
					newDetailRecords[i].set('INOUT_METH'		, "1");
					newDetailRecords[i].set('INOUT_CODE_TYPE'	, "4");
					newDetailRecords[i].set('CREATE_LOC'		, panelResult.getValue('CREATE_LOC'));
					newDetailRecords[i].set('DIV_CODE'			, panelResult.getValue('DIV_CODE'));
					newDetailRecords[i].set('INOUT_CODE'		, panelResult.getValue('CUSTOM_CODE'));
					newDetailRecords[i].set('CUSTOM_NAME'		, panelResult.getValue('CUSTOM_NAME'));
					newDetailRecords[i].set('INOUT_DATE'		, panelResult.getValue('INOUT_DATE'));
					newDetailRecords[i].set('INOUT_NUM'			, panelResult.getValue('INOUT_NUM'));
					newDetailRecords[i].set('NATION_INOUT'		, panelResult.getValue('NATION_INOUT'));
					newDetailRecords[i].set('EXCHG_RATE_O'		, record['EXCHG_RATE_O']);
					var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
					var sRefCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2
					
					if(record['INOUT_TYPE_DETAIL'] > ""){
						newDetailRecords[i].set('INOUT_TYPE_DETAIL'	, record['INOUT_TYPE_DETAIL']);
					}else{
						newDetailRecords[i].set('INOUT_TYPE_DETAIL'	, inoutTypeDetail);
					}			
					
					newDetailRecords[i].set('REF_CODE2'			, sRefCode2);
					
					if(Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
						newDetailRecords[i].set('WH_CODE', record['WH_CODE']);
						newDetailRecords[i].set('WH_NAME', record['WH_CODE']);
					} else {
						newDetailRecords[i].set('WH_CODE', panelResult.getValue('WH_CODE'));
						newDetailRecords[i].set('WH_NAME', panelResult.getValue('WH_CODE'));
					}
		
					newDetailRecords[i].set('WH_CELL_CODE'		, panelResult.getValue('WH_CELL_CODE'));
					newDetailRecords[i].set('ITEM_CODE'			, record['ITEM_CODE']);
					newDetailRecords[i].set('ITEM_NAME'			, record['ITEM_NAME']);
					newDetailRecords[i].set('SPEC'				, record['SPEC']);
					newDetailRecords[i].set('ITEM_STATUS'		, "1");
					newDetailRecords[i].set('ORDER_UNIT'		, record['ORDER_UNIT']);
					newDetailRecords[i].set('TRANS_RATE'		, record['TRANS_RATE']);
					//수주참조 시, 출고량은 0으로 SET: 바코드 스캔한 값 +하기 위해
					newDetailRecords[i].set('ORDER_UNIT_Q'		, 0);
					newDetailRecords[i].set('ORIGIN_Q'			, record['R_ALLOC_Q']);
					newDetailRecords[i].set('ORDER_NOT_Q'		, record['R_ALLOC_Q']);
					newDetailRecords[i].set('ISSUE_NOT_Q'		, "0");
					newDetailRecords[i].set('TAX_TYPE'			, record['TAX_TYPE']);
					newDetailRecords[i].set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
					newDetailRecords[i].set('ACCOUNT_YNC'		, record['ACCOUNT_YNC']);
					newDetailRecords[i].set('SALE_CUSTOM_CODE'	, record['SALE_CUST_CD']);
					newDetailRecords[i].set('SALE_CUST_CD'		, record['SALE_CUST_NM']);
					newDetailRecords[i].set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);
					newDetailRecords[i].set('DVRY_CUST_NAME'	, record['DVRY_CUST_NAME']);
					newDetailRecords[i].set('ORDER_CUST_CD'		, record['CUSTOM_NAME']);
					newDetailRecords[i].set('PLAN_NUM'			, record['PROJECT_NO']);
					newDetailRecords[i].set('BASIS_NUM'			, record['PO_NUM']);
					newDetailRecords[i].set('BASIS_SEQ'			, record['PO_SEQ']);

					if(BsaCodeInfo.gsOptDivCode == "1"){
						newDetailRecords[i].set('SALE_DIV_CODE'	, record['OUT_DIV_CODE']);
					}else{
						newDetailRecords[i].set('SALE_DIV_CODE'	, record['DIV_CODE']);
					}

					newDetailRecords[i].set('MONEY_UNIT'		, record['MONEY_UNIT']);
					newDetailRecords[i].set('EXCHG_RATE_O'		, panelResult.getValue('EXCHG_RATE_O'));
					newDetailRecords[i].set('ORDER_NUM'			, record['ORDER_NUM']);
					newDetailRecords[i].set('ORDER_SEQ'			, record['SER_NO']);
					newDetailRecords[i].set('ORDER_TYPE'		, record['ORDER_TYPE']);
					newDetailRecords[i].set('BILL_TYPE'			, record['BILL_TYPE']);
					newDetailRecords[i].set('STOCK_UNIT'		, record['STOCK_UNIT']);
					newDetailRecords[i].set('PRICE_YN'			, record['PRICE_YN']);
					if(panelResult.getValue('CREATE_LOC') == "5"){
						newDetailRecords[i].set('SALE_TYPE'		, '60');
					}else{
						newDetailRecords[i].set('SALE_TYPE'		, record['ORDER_TYPE']);
					}
					newDetailRecords[i].set('SALE_PRSN'			, record['ORDER_PRSN']);
					newDetailRecords[i].set('INOUT_PRSN'		, panelResult.getValue('INOUT_PRSN'));
					newDetailRecords[i].set('ACCOUNT_Q'			, "0");
					newDetailRecords[i].set('SALE_C_YN'			, "N");
					newDetailRecords[i].set('CREDIT_YN'			, CustomCodeInfo.gsCustCreditYn);
					newDetailRecords[i].set('WON_CALC_BAS'		, CustomCodeInfo.gsUnderCalBase);
					newDetailRecords[i].set('TAX_INOUT'			, record['TAX_INOUT']);
					newDetailRecords[i].set('AGENT_TYPE'		, record['AGENT_TYPE']);
					newDetailRecords[i].set('DEPT_CODE'			, record['DEPT_CODE']);
					newDetailRecords[i].set('STOCK_CARE_YN'		, record['STOCK_CARE_YN']);
					newDetailRecords[i].set('UPDATE_DB_USER'	, record['USER_ID']);
					newDetailRecords[i].set('RETURN_Q_YN'		, record['RETURN_Q_YN']);
					newDetailRecords[i].set('SRC_ORDER_Q'		, record['ORDER_Q']);
					newDetailRecords[i].set('EXCESS_RATE'		, record['EXCESS_RATE']);

					if(newDetailRecords[i].get('ACCOUNT_YNC') == "N"){
						newDetailRecords[i].set('ORDER_UNIT_P'	, 0);
					}else{
						newDetailRecords[i].set('ORDER_UNIT_P'	, record['R_ORDER_P']);
					}

					if(record['ORDER_Q'] != record['R_ALLOC_Q']){
						UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "Q")
					}

					if(record['ACCOUNT_YNC'] == "N"){
						newDetailRecords[i].set('ORDER_UNIT_O'	, 0);
						newDetailRecords[i].set('INOUT_TAX_AMT'	, 0);
					}else{
						newDetailRecords[i].set('ORDER_UNIT_O'	, record['R_ORDER_O']);
						newDetailRecords[i].set('INOUT_TAX_AMT'	, record['R_ORDER_TAX_O']);
					}

					newDetailRecords[i].set('PRICE_TYPE'		, record['PRICE_TYPE']);
					newDetailRecords[i].set('INOUT_FOR_WGT_P'	, record['ORDER_FOR_WGT_P']);
					newDetailRecords[i].set('INOUT_FOR_VOL_P'	, record['ORDER_FOR_VOL_P']);
					newDetailRecords[i].set('INOUT_WGT_P'		, record['ORDER_WGT_P']);
					newDetailRecords[i].set('INOUT_VOL_P'		, record['ORDER_VOL_P']);
					newDetailRecords[i].set('WGT_UNIT'			, record['WGT_UNIT']);
					newDetailRecords[i].set('UNIT_WGT'			, record['UNIT_WGT']);
					newDetailRecords[i].set('VOL_UNIT'			, record['VOL_UNIT']);
					newDetailRecords[i].set('UNIT_VOL'			, record['UNIT_VOL']);

					var sInout_q = newDetailRecords[i].get('ORDER_UNIT_Q');
					//출고량(중량) 재계산
					var sUnitWgt = newDetailRecords[i].get('UNIT_WGT');
					var sOrderWgtQ = sInout_q * sUnitWgt;
					newDetailRecords[i].set('INOUT_WGT_Q'		, sOrderWgtQ);

					//출고량(부피) 재계산
					var sUnitVol = newDetailRecords[i].get('UNIT_VOL');
					var sOrderVolQ = sInout_q * sUnitVol

					newDetailRecords[i].set('INOUT_VOL_Q'		, sOrderVolQ);
					newDetailRecords[i].set('COMP_CODE'			, UserInfo.compCode);
					newDetailRecords[i].set('REMARK'			, record['REMARK']);
					newDetailRecords[i].set('PAY_METHODE1'		, record['PAY_METHODE1']);
					newDetailRecords[i].set('LC_SER_NO'			, record['LC_SER_NO']);
					newDetailRecords[i].set('TRANS_COST'		, "0");
					newDetailRecords[i].set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
					newDetailRecords[i].set('GUBUN'				, "FEFER");

					var lRate = record['TRANS_RATE'];
					if(lRate == 0){
						lRate = 1;
					}
					newDetailRecords[i].set('STOCK_Q'			, record['STOCK_Q']); 
					newDetailRecords[i].set('ORDER_STOCK_Q'		, record['STOCK_Q'] / lRate);
					newDetailRecords[i].set('LOT_YN'			, record['LOT_YN']);
					newDetailRecords[i].set('LOT_NO'			, record['R_LOT_NO']);
					newDetailRecords[i].set('myId'				, record['myId']);

					UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "P")
				});
				detailStore.loadData(newDetailRecords, true);
			}
		},
		fnMakeSrf100tDataRef: function(records, issueReqBarcode) {
			if(!panelResult.setAllFieldsReadOnly(true)){
				return false;
			} else {
				var newDetailRecords = new Array();
				var sortSeq = detailStore.max('SORT_SEQ');
				if(!sortSeq) sortSeq = 1;
				else  sortSeq += 1;

				Ext.each(records, function(record,i){
					if(i == 0){
						sortSeq = sortSeq;
					} else {
						sortSeq += 1;
					}

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

					var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
					var refCode1 = UniAppManager.app.fnGetSubCode1(null, inoutTypeDetail) ;	//출고유형value의 ref1
					var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2

					var createLoc = '';
					if(!Ext.isEmpty(panelResult.getValue('CREATE_LOC'))) {
						createLoc = panelResult.getValue('CREATE_LOC');
					}

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
					if(BsaCodeInfo.gsOptDivCode == "1"){
						saleDivCode = panelResult.getValue('DIV_CODE');
					}else{
						saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
					}

					var divCode = '';
					if(BsaCodeInfo.gsOptDivCode == "1"){
						saleDivCode = panelResult.getValue('DIV_CODE');
					}else{
						saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
					}

					var saleType = Ext.data.StoreManager.lookup('CBS_AU_S002').getAt(0).get('value'); //판매유형콤보value중 첫번째 value
					var taxInout = CustomCodeInfo.gsTaxInout;

					var deptCode = '';
					if(!Ext.isEmpty(panelResult.getValue('DEPT_CODE'))) {
						deptCode = panelResult.getValue('DEPT_CODE');
					}

					var whCode = '';
					if(!Ext.isEmpty(panelResult.getValue('WH_CODE'))){
						whCode = panelResult.getValue('WH_CODE');
					}

					var whCellCode = '';
					if(!Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))){
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
						BARCODE_KEY			: '',
						TYPE_LEVEL			: '1',
						INOUT_SEQ			: 0,
						SORT_SEQ			: sortSeq, 
						INOUT_NUM			: inoutNum,
						INOUT_CODE			: inoutCode,
						CUSTOM_NAME			: customName,
						INOUT_TYPE_DETAIL	: inoutTypeDetail,
						REF_CODE2			: refCode2,
						ACCOUNT_YNC			: refCode1,
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
						SALE_PRSN			: salePrsn,
						NATION_INOUT		: nationInout,
						INOUT_DATE			: inoutDate,
						SALE_DATE			: saleDate
					};
					newDetailRecords[i] = detailStore.model.create( r );

					if(!Ext.isEmpty(issueReqBarcode)) {
						record = record;
					} else {
						record = record.data;
					}
					panelResult.setValue('NATION_INOUT'			, record['NATION_INOUT']);
					panelResult.setValue('EXCHG_RATE_O'			, record['EXCHANGE_RATE']);
					panelResult.setValue('NATION_CODE'			, record['NATION_CODE']);

					newDetailRecords[i].set('INOUT_TYPE'		, "2");
					newDetailRecords[i].set('INOUT_METH'		, "1");
					newDetailRecords[i].set('INOUT_CODE_TYPE'	, "4");
					newDetailRecords[i].set('CREATE_LOC'		, panelResult.getValue('CREATE_LOC'));
					newDetailRecords[i].set('DIV_CODE'			, panelResult.getValue('DIV_CODE'));
					newDetailRecords[i].set('INOUT_CODE'		, panelResult.getValue('CUSTOM_CODE'));
					newDetailRecords[i].set('CUSTOM_NAME'		, panelResult.getValue('CUSTOM_NAME'));
					newDetailRecords[i].set('INOUT_DATE'		, panelResult.getValue('INOUT_DATE'));
					newDetailRecords[i].set('INOUT_NUM'			, panelResult.getValue('INOUT_NUM'));
					newDetailRecords[i].set('REF_CODE2'			, record['REF_CODE2']);

					if(Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
						newDetailRecords[i].set('WH_CODE', record['WH_CODE']);
						newDetailRecords[i].set('WH_NAME', record['WH_CODE']);
					} else {
						newDetailRecords[i].set('WH_CODE', panelResult.getValue('WH_CODE'));
						newDetailRecords[i].set('WH_NAME', panelResult.getValue('WH_CODE'));
					}
					
					if(BsaCodeInfo.gsSumTypeCell == "Y"){
						if(!Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))) {
							newDetailRecords[i].set('WH_CELL_CODE'	, panelResult.getValue('WH_CELL_CODE'));
						} else {
							newDetailRecords[i].set('WH_CELL_CODE'	, record['WH_CELL_CODE']);
							newDetailRecords[i].set('WH_CELL_NAME'	, record['WH_CELL_NAME']);
						}
					}else{
						newDetailRecords[i].set('WH_CELL_CODE'	, "");
						newDetailRecords[i].set('WH_CELL_NAME'	, "");
					} 

					newDetailRecords[i].set('ITEM_CODE'			, record['ITEM_CODE']);
					newDetailRecords[i].set('ITEM_NAME'			, record['ITEM_NAME']);
					newDetailRecords[i].set('SPEC'				, record['SPEC']);
					newDetailRecords[i].set('ITEM_STATUS'		, "1");
					newDetailRecords[i].set('ORDER_UNIT'		, record['ORDER_UNIT']);
					newDetailRecords[i].set('TRANS_RATE'		, record['TRANS_RATE']);
					//출하지시참조 시, 출하지시량은 0으로 SET: 바코드 스캔한 값 +하기 위해
					newDetailRecords[i].set('ORDER_UNIT_Q'		, 0);
		//			newDetailRecords[i].set('ORDER_UNIT_Q'		, record['NOT_REQ_Q']);
					newDetailRecords[i].set('ORIGIN_Q'			, record['NOT_REQ_Q']);
					newDetailRecords[i].set('ORDER_NOT_Q'		, "0");
					newDetailRecords[i].set('ISSUE_NOT_Q'		, record['NOT_REQ_Q']);
					newDetailRecords[i].set('TAX_TYPE'			, record['TAX_TYPE']);
					newDetailRecords[i].set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
					newDetailRecords[i].set('ACCOUNT_YNC'		, record['ACCOUNT_YNC']);
					newDetailRecords[i].set('DELIVERY_DATE'		, record['ISSUE_DATE']);
					newDetailRecords[i].set('SALE_CUSTOM_CODE'	, record['SALE_CUSTOM_CODE']);
					newDetailRecords[i].set('SALE_CUST_CD'		, record['SALE_CUST_CD']);
					newDetailRecords[i].set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);
					newDetailRecords[i].set('DVRY_CUST_NAME'	, record['DVRY_CUST_NAME']);
					newDetailRecords[i].set('ORDER_CUST_CD'		, record['ORDER_CUST_CD']);
					newDetailRecords[i].set('PLAN_NUM'			, record['PROJECT_NO']);
					newDetailRecords[i].set('ISSUE_REQ_NUM'		, record['ISSUE_REQ_NUM']);
					newDetailRecords[i].set('BASIS_NUM'			, record['PO_NUM']);
					newDetailRecords[i].set('BASIS_SEQ'			, record['PO_SEQ']);

					if(BsaCodeInfo.gsOptDivCode == "1"){
						newDetailRecords[i].set('SALE_DIV_CODE'	, record['ISSUE_DIV_CODE']);
					}else{
						newDetailRecords[i].set('SALE_DIV_CODE'	, record['DIV_CODE']);
					}

					newDetailRecords[i].set('MONEY_UNIT'		, record['MONEY_UNIT']);
					newDetailRecords[i].set('EXCHG_RATE_O'		, panelResult.getValue('EXCHG_RATE_O'));
					newDetailRecords[i].set('ISSUE_REQ_SEQ'		, record['ISSUE_REQ_SEQ']);
					newDetailRecords[i].set('ORDER_NUM'			, record['ORDER_NUM']);
					newDetailRecords[i].set('ORDER_SEQ'			, record['SER_NO']);
					newDetailRecords[i].set('ORDER_TYPE'		, record['ORDER_TYPE']);
					newDetailRecords[i].set('BILL_TYPE'			, record['BILL_TYPE']);
					newDetailRecords[i].set('STOCK_UNIT'		, record['STOCK_UNIT']);
					newDetailRecords[i].set('PRICE_YN'			, record['PRICE_YN']);
					newDetailRecords[i].set('SALE_TYPE'			, record['ORDER_TYPE']);
					newDetailRecords[i].set('SALE_PRSN'			, record['ISSUE_REQ_PRSN']);
					newDetailRecords[i].set('INOUT_PRSN'		, panelResult.getValue('INOUT_PRSN'));
					newDetailRecords[i].set('ACCOUNT_Q'			, "0");
					newDetailRecords[i].set('SALE_C_YN'			, "N");
					newDetailRecords[i].set('CREDIT_YN'			, record['CREDIT_YN']);
					newDetailRecords[i].set('WON_CALC_BAS'		, record['WON_CALC_BAS']);
					newDetailRecords[i].set('PAY_METHODE1'		, record['PAY_METHODE1']);
					newDetailRecords[i].set('LC_SER_NO'			, record['LC_SER_NO']);

					if(record['SOF100_TAX_INOUT'] == ""){
						if(record['TAX_INOUT'] == "") {
							newDetailRecords[i].set('TAX_INOUT'	, CustomCodeInfo.gsTaxInout);
						} else {
							newDetailRecords[i].set('TAX_INOUT'	, record['TAX_INOUT']);
						}
					} else {
						newDetailRecords[i].set('TAX_INOUT'		, record['SOF100_TAX_INOUT']);
					}

					newDetailRecords[i].set('LOT_NO'			, record['LOT_NO']);
					newDetailRecords[i].set('AGENT_TYPE'		, record['AGENT_TYPE']);
					newDetailRecords[i].set('DEPT_CODE'			, record['DEPT_CODE']);
					newDetailRecords[i].set('STOCK_CARE_YN'		, record['STOCK_CARE_YN']);
					newDetailRecords[i].set('UPDATE_DB_USER'	, UserInfo.userID);
					newDetailRecords[i].set('RETURN_Q_YN'		, record['RETURN_Q_YN']);
					newDetailRecords[i].set('SRC_ORDER_Q'		, record['ORDER_Q']);
					newDetailRecords[i].set('EXCESS_RATE'		, record['EXCESS_RATE']);
					newDetailRecords[i].set('PRICE_TYPE'		, record['PRICE_TYPE']);
					newDetailRecords[i].set('INOUT_FOR_WGT_P'	, record['ISSUE_FOR_WGT_P']);
					newDetailRecords[i].set('INOUT_FOR_VOL_P'	, record['ISSUE_FOR_VOL_P']);
					newDetailRecords[i].set('INOUT_WGT_P'		, record['ISSUE_WGT_P']);
					newDetailRecords[i].set('INOUT_VOL_P'		, record['ISSUE_VOL_P']);
					newDetailRecords[i].set('WGT_UNIT'			, record['WGT_UNIT']);
					newDetailRecords[i].set('UNIT_WGT'			, record['UNIT_WGT']);
					newDetailRecords[i].set('VOL_UNIT'			, record['VOL_UNIT']);
					newDetailRecords[i].set('UNIT_VOL'			, record['UNIT_VOL']);
					//20200402 추가
					newDetailRecords[i].set('LOT_YN'			, record['LOT_YN']);
					newDetailRecords[i].set('myId'				, record['myId']);

					//출고량(중량) 재계산
					var sInout_q = newDetailRecords[i].get('ORDER_UNIT_Q');
					var sUnitWgt = newDetailRecords[i].get('UNIT_WGT');
					var sOrderWgtQ = sInout_q * sUnitWgt;
					newDetailRecords[i].set('INOUT_WGT_Q'		, sOrderWgtQ);

					//출고량(부피) 재계산
					var sUnitVol = newDetailRecords[i].get('UNIT_VOL');
					var sOrderVolQ = sInout_q * sUnitVol;
					newDetailRecords[i].set('INOUT_VOL_Q'		, sOrderVolQ);

					if(newDetailRecords[i].get('ACCOUNT_YNC') == "N"){
						newDetailRecords[i].set('ORDER_UNIT_P'	, 0);
					}else{
						newDetailRecords[i].set('ORDER_UNIT_P'	, record['ISSUE_FOR_PRICE']);
		//				newDetailRecords[i].set('ORDER_UNIT_P'	, record['ISSUE_REQ_PRICE']);
					}

					if(record['ORDER_Q'] != record['NOT_REQ_Q']){
						UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "Q")
					}else{
						if(record['ACCOUNT_YNC'] == "N"){
							newDetailRecords[i].set('ORDER_UNIT_O'	, 0);
							newDetailRecords[i].set('INOUT_TAX_AMT'	, 0);
						}else{
							newDetailRecords[i].set('ORDER_UNIT_O'	, record['ISSUE_FOR_AMT']);
						}
						//20171211 합계금액 표시를 위해 함수 호출
						UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "Q")
					}
					newDetailRecords[i].set('COMP_CODE'		, UserInfo.compCode);
					newDetailRecords[i].set('REMARK'		, record['REMARK']);
					newDetailRecords[i].set('TRANS_COST'	, "0");	
					newDetailRecords[i].set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
					newDetailRecords[i].set('GUBUN'			, "FEFER");
					newDetailRecords[i].set('INOUT_TYPE_DETAIL'	, record['INOUT_TYPE_DETAIL']);

					var lRate = record['TRANS_RATE'];
					if(lRate == 0){
						lRate = 1;
					}
					newDetailRecords[i].set('STOCK_Q'	, record['STOCK_Q'] / lRate);
				});
				detailStore.loadData(newDetailRecords, true);
			}
		}
	});



	//detailGrid 삭제
	function fnDeleteDetail(selRow) {
		var deleteRecords	= new Array();
		
		detailGrid.deleteSelectedRow();
		//barcode그리드의 관련 내용 삭제
		barcodeStore.clearFilter();
		var barcodeRecords = barcodeStore.data.items;
		Ext.each(barcodeRecords, function(barcodeRecord,i) {
			if(barcodeRecord.get('BARCODE_KEY') == selRow.get('myId')) {
				deleteRecords.push(barcodeRecord);
				fnDeleteLotNo(barcodeRecord);		//LOT_NO_S 삭제 함수 호출
			}
		});
		barcodeStore.remove(deleteRecords);
		gsMaxInoutSeq = Unilite.nvl(barcodeStore.max('INOUT_SEQ'), 0);
	}

	//barcodeGrid 삭제
	function fnBarcodeGrid(selRow, selRow2) {
		var deleteRecords	= new Array();
		fnDeleteLotNo(selRow2);						//LOT_NO_S 삭제 함수 호출
		if(Ext.isEmpty(selRow)) {
			var selRows = detailStore.data.items;
			Ext.each(selRows, function(selRow,i) {
				if(selRow2.get('BARCODE_KEY') == selRow.get('myId')) {
					selRow.set('ORDER_UNIT_Q'	, selRow.get('ORDER_UNIT_Q') - selRow2.get('ORDER_UNIT_Q'));
					selRow.set('ORDER_NOT_Q'	, selRow.get('ORDER_NOT_Q') + selRow2.get('ORDER_UNIT_Q'));
					if(selRow.get('ORDER_UNIT_Q') == 0) {
						deleteRecords.push(selRow);
					}
				}
			});
		} else {
			selRow.set('ORDER_UNIT_Q'	, selRow.get('ORDER_UNIT_Q') - selRow2.get('ORDER_UNIT_Q'));
			selRow.set('ORDER_NOT_Q'	, selRow.get('ORDER_NOT_Q') + selRow2.get('ORDER_UNIT_Q'));
		}
		detailStore.remove(deleteRecords);
		barcodeGrid.deleteSelectedRow();
		gsMaxInoutSeq = Unilite.nvl(barcodeStore.max('INOUT_SEQ'), 0);
		UniAppManager.app.fnOrderAmtCal(selRow, "P");
	}

	//FIFO 위한 데이터 생성 - 삭제
	function fnDeleteLotNo(selRow2) {
		var lotNoS		= panelResult.getValue('LOT_NO_S');
		var deletedNum0	= selRow2.get('LOT_NO') + ','; 
		var deletedNum1	= ',' + selRow2.get('LOT_NO'); 
		var deletedNum2	= selRow2.get('LOT_NO'); 
		lotNoS = lotNoS.split(deletedNum0).join("");
		lotNoS = lotNoS.split(deletedNum1).join("");
		lotNoS = lotNoS.split(deletedNum2).join("");
		panelResult.setValue('LOT_NO_S', lotNoS);
	}



	//바코드 입력 로직 (수주번호)
	function fnEnterOrderBarcode(newValue, customCode) {
		var OrderBarcode	= newValue;
		
		var param = {
			DIV_CODE	: panelResult.getValue('DIV_CODE'),
			CUSTOM_CODE	: panelResult.getValue('CUSTOM_CODE'),
			MONEY_UNIT	: panelResult.getValue('MONEY_UNIT'),
			WH_CODE		: panelResult.getValue('WH_CODE'),
			WH_CELL_CODE: panelResult.getValue('WH_CELL_CODE'), 
			ORDER_NUM	: OrderBarcode
		}
		//20190822 - 임시불러오기 버튼 후, 더블클릭 관련로직
		if(!Ext.isEmpty(customCode)) {
			param.CUSTOM_CODE = customCode;
			param.INOUT_NUM   = panelResult.getValue('INOUT_NUM');
		}
		//수주참조 조회쿼리 호출
		s_str105ukrv_mitService.selectSalesOrderList(param, function(provider, response){
			if(!Ext.isEmpty(provider)){
				panelResult.setValue('CUSTOM_CODE'	, provider[0].CUSTOM_CODE);
				panelResult.setValue('CUSTOM_NAME'	, provider[0].CUSTOM_NAME);
				panelResult.setValue('MONEY_UNIT'	, provider[0].MONEY_UNIT);
				
				UniAppManager.app.fnExchngRateO(null, provider);
				
				//환율가져오기 전에 set하는 로직 진행이 되어서 어쩔 수 없이 환율 가져오는 함수 안에서 처리 (아래 5개행)
//					requestGrid.returnData(provider);
//					Ext.getBody().unmask();
//					//첫번째 행 포커스
//					detailGrid.getSelectionModel().select(0);
//					panelResult.getField('BARCODE')focus();
				
			} else {
				Unilite.messageBox('입력하신 수주번호의 데이터가 존재하지 않습니다.');
				Ext.getBody().unmask();
				panelResult.setValue('ORDER_BARCODE', '');
				panelResult.getField('ORDER_BARCODE').focus();
				return false;
			}
		});
	}

	//20200401 추가: 바코드 입력 로직 (출하지시번호)
	function fnEnterIssueBarcode(newValue, customCode) {
		var IssueReqBarcode	= newValue;
		
		var param = {
			DIV_CODE		: panelResult.getValue('DIV_CODE'),
			CUSTOM_CODE		: panelResult.getValue('CUSTOM_CODE'),
			WH_CODE			: panelResult.getValue('WH_CODE'),
			WH_CELL_CODE	: panelResult.getValue('WH_CELL_CODE'), 
			ISSUE_REQ_NUM	: IssueReqBarcode
		}
		//20190822 - 임시불러오기 버튼 후, 더블클릭 관련로직
		if(!Ext.isEmpty(customCode)) {
			param.CUSTOM_CODE = customCode;
			param.INOUT_NUM   = panelResult.getValue('INOUT_NUM');
		}
		//출하지시참조 조회쿼리 호출
		s_str105ukrv_mitService.selectRequestiList(param, function(provider, response){
			if(!Ext.isEmpty(provider)){
				panelResult.setValue('CUSTOM_CODE'	, provider[0].CUSTOM_CODE);
				panelResult.setValue('CUSTOM_NAME'	, provider[0].CUSTOM_NAME);
				panelResult.setValue('MONEY_UNIT'	, provider[0].MONEY_UNIT);
				
				UniAppManager.app.fnExchngRateO(null, provider);
			} else {
				Unilite.messageBox('입력하신 출하지시번호의 데이터가 존재하지 않습니다.');
				Ext.getBody().unmask();
				panelResult.setValue('ISSUE_REQ_BARCODE', '');
				panelResult.getField('ISSUE_REQ_BARCODE').focus();
				return false;
			}
		});
	}

	//바코드 입력 로직 (lot_no)
	function fnEnterBarcode(newValue) {
		var records = detailGrid.getStore().data.items;
		var masterRecord;
		var flag = true;

		//공통코드에서 자릿수 가져와서 바코드 데이터 읽기
		var param = {
			NATION_CODE	: panelResult.getValue('NATION_CODE'),
			BARCODE		: newValue
		}
		s_str105ukrv_mitService.getBarcodeInfo(param, function(provider, response){
			if(Ext.isEmpty(provider) || Ext.isEmpty(provider[0].ITEM_CODE)) {
				Unilite.messageBox('입력된 바코드 정보가 잘못되었습니다.');
				return false;
			}
			//동일한 LOT_NO 입력되었을 경우 처리
			var itemCode	= provider[0].ITEM_CODE;
			var barcodeLotNo= provider[0].LOT_NO;
			var barLotNoCom = '';					//20200305 LOT_NO 비교로직 수정
			var serialNo	= provider[0].SN;
	
			if(!Ext.isEmpty(barcodeLotNo)) {
				barcodeLotNo = barcodeLotNo.toUpperCase();
				barLotNoCom = barcodeLotNo + '-' + serialNo;
			} else {
				itemCode	= '';
				barcodeLotNo= newValue.toUpperCase();
				serialNo	= 0;
				barLotNoCom = barcodeLotNo;
			}
			//master data 찾는 로직
			Ext.each(records, function(record, i) {
				//20200130 LOT_NO도 비교하도록 주석 해제
				if(record.get('ITEM_CODE').toUpperCase() == itemCode.toUpperCase() && record.get('LOT_NO').toUpperCase() == barLotNoCom) {
					masterRecord = record;
				}
			});

			//품목정보 체크
			if(Ext.isEmpty(masterRecord)) {
				beep();
				gsText = '<t:message code="system.label.sales.message003" default="입력하신 품목 정보가 없습니다."/>';
				openAlertWindow(gsText);
				//해당 컬럼에 포커싱 작업 추후 진행
				panelResult.setValue('BARCODE', '');
				panelResult.getField('BARCODE').focus();
				return false;
			}
			//미납량 체크
			//20200402 수정: 플래그에 따라 체크로직 분개하는 로직 추가(ORDER_NOT_Q, ISSUE_NOT_Q)
			if((masterRecord.get('ORDER_NOT_Q') == 0 && panelResult.getValue('GUBUN').GUBUN == '1') || (masterRecord.get('ISSUE_NOT_Q') == 0 && panelResult.getValue('GUBUN').GUBUN == '2')) {
				beep();
				gsText = '미납된 수주량이 없습니다.';
				openAlertWindow(gsText);
				//해당 컬럼에 포커싱 작업 추후 진행
				panelResult.setValue('BARCODE', '');
				panelResult.getField('BARCODE').focus();
				return false;
			}

			//참조적용이 아닐 경우, 품목정보, 출고량, 단가 체크
			if(masterRecord.get('INOUT_METH') == '2') {
				//단가정보 체크
				if(masterRecord.get('ACCOUNT_YNC') == 'Y' &&(Ext.isEmpty(masterRecord.get('ORDER_UNIT_P')) || masterRecord.get('ORDER_UNIT_P') == 0)) {
					beep();
					gsText = '<t:message code="system.label.sales.message004" default="단가 정보가 없습니다."/>';
					openAlertWindow(gsText);
					//해당 컬럼에 포커싱 작업 추후 진행
					panelResult.setValue('BARCODE', '');
					panelResult.getField('BARCODE').focus();
					return false;
				}
			}

			//BIV150T (COMP_CODE, ITEM_CODE, WH_CODE, DIV_CODE)
			if(flag) {
				//20200402 수정: 플래그에 따라 체크로직 분개하는 로직 추가(ORDER_NOT_Q, ISSUE_NOT_Q)
				var orderUnitQ = panelResult.getValue('GUBUN').GUBUN == '1' ? masterRecord.get('ORDER_NOT_Q') : masterRecord.get('ISSUE_NOT_Q')
				var param = {
					ITEM_CODE		: itemCode,
					LOT_NO			: barcodeLotNo + '-' + serialNo,
					ORDER_UNIT_Q	: orderUnitQ,
					WH_CODE			: masterRecord.get('WH_CODE'),
					DIV_CODE		: panelResult.getValue('DIV_CODE'),
					LOT_NO_S		: panelResult.getValue('LOT_NO_S'),
					GSFIFO			: BsaCodeInfo.gsFifo
				}
				s_str105ukrv_mitService.getFifo(param, function(provider, response){
					if(!Ext.isEmpty(provider)){
						var flag = true;
						Ext.each(provider, function(record, i) {
							if(!Ext.isEmpty(provider[i].ERR_MSG)) {
								beep();
								gsText = provider[i].ERR_MSG;
								openAlertWindow(gsText);
								panelResult.setValue('BARCODE', '');
								panelResult.getField('BARCODE').focus();
								return false;
							};
							if(masterRecord.get('ITEM_CODE').toUpperCase() == provider[i].NEWVALUE.split('|')[0]) {
								barcodeStore.clearFilter();						//filter clear 후
								var records = barcodeStore.data.items;			//비교할 records 구성
								barcodeStore.filterBy(function(record){			//다시 필터 set
									return record.get('BARCODE_KEY') == masterRecord.get('myId');
								})
								
								Ext.each(records, function(record,j) {
									if(record.get('LOT_NO').toUpperCase() == provider[i].NEWVALUE.split('|')[1]) {
										beep();
										gsText = '<t:message code="system.label.sales.message005" default="동일한  Lot No.(이)가 이미 등록되었습니다."/>'
										openAlertWindow(gsText);
										flag = false;
										panelResult.setValue('BARCODE', '');
										panelResult.getField('BARCODE').focus();
										flag = false;
										return false;
									}
								});
								if(flag) {
									UniAppManager.app.onNewDataButtonDown2(provider[i].NEWVALUE, masterRecord);
									return;
								}
								
							} else {
								beep();
								gsText = '<t:message code="system.message.sales.datacheck020" default="선택된 품목과 바코드의 품목이 일치하지 않습니다."/>'
								openAlertWindow(gsText);
								panelResult.setValue('BARCODE', '');
								panelResult.getField('BARCODE').focus();
							}
						});
					}
				});
			}
		});
	}



	//랜덤 키 생성 (날짜(8자리) + 5자리 랜덤 숫자)
	function fnMakeRandomKey() {
		var date = UniDate.getDbDateStr(UniDate.get('today'));
		var rand = Math.floor(Math.pow(10, 4) + Math.random() * (Math.pow(10, 5) - Math.pow(10, 4) - 1)); 
		return date + rand;
	}



	function beep_ok() {
		audioCtx = new(window.AudioContext || window.webkitAudioContext)();
	
		var oscillator = audioCtx.createOscillator();
		var gainNode = audioCtx.createGain();
	
		oscillator.connect(gainNode);
		gainNode.connect(audioCtx.destination);
	
		gainNode.gain.value = 0.1;				//VOLUME 크기
		oscillator.frequency.value = 1000;
		oscillator.type = 'sine';				//sine, square, sawtooth, triangle
	
		oscillator.start();
	
		setTimeout(
			function() {
			  oscillator.stop();
			},
			1000									//길이
		);
	};

	function beep() {
		audioCtx = new(window.AudioContext || window.webkitAudioContext)();
	
		var oscillator = audioCtx.createOscillator();
		var gainNode = audioCtx.createGain();
	
		oscillator.connect(gainNode);
		gainNode.connect(audioCtx.destination);
	
		gainNode.gain.value = 0.1;				//VOLUME 크기
		oscillator.frequency.value = 4100;
		oscillator.type = 'sine';				//sine, square, sawtooth, triangle
	
		oscillator.start();
	
		setTimeout(
			function() {
			  oscillator.stop();
			},
			1000									//길이
		);
	};



	/** Validation
	 */
	Unilite.createValidator('validator00', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			if(BsaCodeInfo.gsInoutAutoYN == "N" && record.get('ACCOUNT_Q')){
				rv = '<t:message code="system.message.sales.message055" default="매출이 진행된 건은 수정/삭제할 수 없습니다."/>';				
			}else if( record.get('SALE_C_YN' == 'Y')){
				rv = '<t:message code="system.message.sales.message056" default="계산서가 마감된 건은 수정/삭제가 불가능합니다."/>';
			}else{
				switch(fieldName) {
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
						record.set('ACCOUNT_YNC', UniAppManager.app.fnGetSubCode1(null, newValue));
						if((sRefCode2 > "91" && sRefCode2 < "99" ) || sRefCode2 == "C1"){
							record.set('REF_CODE2', OldRefCode2);
							rv='<t:message code="system.message.sales.message046" default="해당 출고유형은 선택할 수 없습니다."/>';
							break;
						}else if(sRefCode2 == "AU"){
							if(record.get('STOCK_CARE_YN') != "N"){
								record.set('ITEM_CODE', '');
								record.set('ITEM_NAME', '');
								record.set('SPEC', "");
								break;
							}
							record.set('ACCOUNT_YNC','Y');	//매출대상
							record.set('STOCK_CARE_YN','N');	//재고대상여부 - 아니오
							
						}else if(sRefCode2 == "91"){
							if(!Ext.isEmpty(record.get('STOCK_CARE_YN')) || !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))){
								record.set('REF_CODE2', OldRefCode2);
								rv='<t:message code="system.message.sales.message046" default="해당 출고유형은 선택할 수 없습니다."/>';
								break;
							}
							record.set('ACCOUNT_YNC','N');	//미매출대상
							record.set('ITEM_STATUS','1');	//불량 -> 양품으로 바꿈 20160701
							
						}else{
							if((!Ext.isEmpty(record.get('ORDER_NUM')) && Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) || (Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) || (!Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM')))){
								//skip						
							}else{
								record.set('ACCOUNT_YNC', UniAppManager.app.fnAccountYN(null, newValue));
							}	
							record.set('ACCOUNT_YNC', UniAppManager.app.fnAccountYN(null, newValue));
						}
						break;
						
					case "WH_CODE" :
						if(!Ext.isEmpty(newValue)){
							record.set('WH_NAME',e.column.field.getRawValue());
							record.set('WH_CELL_CODE', "");
							record.set('WH_CELL_NAME', "");
							record.set('LOT_NO', "");
						}else{
							record.set('WH_CODE', "");
							record.set('WH_CELL_CODE', "");
							record.set('WH_CELL_NAME', "");
							record.set('LOT_NO', "");
						}
						if(!Ext.isEmpty(record.get('ITEM_CODE'))){
							UniSales.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('DIV_CODE'), record.get('ITEM_STATUS'), record.get('ITEM_CODE'),  newValue);					
							
						}
						//그리드 창고cell콤보 reLoad.. 
//						cbStore.loadStoreRecords(newValue);
						break;
					
					case "WH_CELL_CODE" :
						record.set('WH_CELL_NAME',e.column.field.getRawValue());
						break;			
					
					case "ITEM_STATUS" :
						if(!Ext.isEmpty(record.get('ITEM_CODE'))){
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
//						UniSales.fnGetDivPriceInfo2(record, UniAppManager.app.cbGetPriceInfo
//												,'I'
//												,UserInfo.compCode
//												,record.get('INOUT_CODE')
//												,record.get('AGENT_TYPE')
//												,record.get('ITEM_CODE')
//												,BsaCodeInfo.gsMoneyUnit
//												,record.get('ORDER_UNIT')
//												,record.get('STOCK_UNIT')
//												,record.get('TRANS_RATE')
//												,UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'))
//												,record.get('ORDER_UNIT_Q')
//												,record.get('WGT_UNIT')
//												,record.get('VOL_UNIT')
//												,record.get('UNIT_WGT')
//												,record.get('UNIT_VOL')
//												,record.get('PRICE_TYPE')
//												,newValue
//												)
//						detailStore.fnOrderAmtSum();
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
						if(newValue <= 0 || Ext.isEmpty(newValue)) {
							rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							break;
						}
						var selectedRecord = detailGrid.getSelectedRecord();
						if(Ext.isEmpty(selectedRecord)) {
							rv='<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>';
							break;
						}
						var sInout_q	= newValue;	//출고량
						var sInv_q		= record.get('STOCK_Q');	//재고량
						var sOriginQ	= record.get('ORIGIN_Q'); //출고량
						var lot_q		= record.get('TEMP_ORDER_UNIT_Q');//로트팝업에서 넘겨받는 수량
						
						if(!Ext.isEmpty(lot_q) && lot_q!= 0){
							if(sInout_q > lot_q){
								rv = '<t:message code="system.message.sales.message062" default="출고량은 lot재고량을 초과할 수 없습니다. 현재고: "/>' + lot_q;
								break;
							}
						}
						
						
						if(BsaCodeInfo.gsInvstatus == "+" && (record.get('STOCK_CARE_YN') == "Y")){
							if(sInout_q > (sInv_q + sOriginQ)){
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
						
						UniAppManager.app.fnOrderAmtCal(record, 'Q', fieldName, newValue);
						
						//바코드 인식 한 값 detailGrid에 set
						var newDetailOderUnitQ	= selectedRecord.get('ORDER_UNIT_Q') + newValue - oldValue;
						selectedRecord.set('ORDER_UNIT_Q', newDetailOderUnitQ);
						UniAppManager.app.fnOrderAmtCal(selectedRecord, 'Q', 'ORDER_UNIT_Q', newDetailOderUnitQ);

						detailStore.fnOrderAmtSum();
						break;
					
					case "INOUT_WGT_Q" :	//hidden
						if(newValue < 0 && !Ext.isEmpty(newValue)) {
							rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							break;
						}
						var sOrderWgtQ = record.get('INOUT_WGT_Q');
						var sUnitWgt = record.get('UNIT_WGT');
						if(sUnitWgt == 0){
							rv='<t:message code="system.message.sales.message063" default="단위중량이 입력되지 않아서 계산이 불가능합니다. 품목정보에서 단위중량을 확인하시기 바랍니다."/>'
							break;
						}
						var sInout_q = sUnitWgt == 0 ? 0 : sOrderWgtQ / sUnitWgt;
						if(BsaCodeInfo.gsPointYn == "N" && (record.get('ORDER_UNIT') == BsaCodeInfo.gsPointYn)){
							if(sInout_q - (Math.floor(sInout_q)) != 0){
								rv='<t:message code="system.message.sales.message064" default="수주량(판매단위)은 소숫점을 입력할 수 없습니다. 수주량(중량단위)을 확인하시기 바랍니다."/>'
								break;
							}
						}
						record.set('ORDER_UNIT_Q', sInout_q);
						sInout_q = record.get('ORDER_UNIT_Q');
						var sInv_q = record.get('STOCK_Q');	//재고량
						var sOriginQ = record.get('ORIGIN_Q');//출고량
						var sExcessQ = record.get('EXCESS_RATE');//초과량
						
						if(BsaCodeInfo.gsInvstatus == "+" && (record.get('STOCK_CARE_YN') == "Y")){
							if(sInout_q  > sInv_q + sOriginQ){
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
						if(newValue > 0 && dTaxAmtO > newValue){
							rv='<t:message code="system.message.sales.message040" default="매출금액은 세액보다 커야 합니다."/>';	//매출금액은 세액보다 커야 합니다.
							break;
						}
						
						UniAppManager.app.fnOrderAmtCal(record, 'O', fieldName, newValue);
						rv = false;
						detailStore.fnOrderAmtSum();
						break;
					
					case "TAX_TYPE" :		
//						if(!Ext.isEmpty(newValue) && newValue == "1"){
//							var inoutTax = record.get('ORDER_UNIT_O') / 10
//							record.set('INOUT_TAX_AMT', inoutTax);
//							detailStore.fnOrderAmtSum(newValue);
//						}else if(!Ext.isEmpty(newValue) && newValue == "2"){
//							record.set('INOUT_TAX_AMT', 0);
//							detailStore.fnOrderAmtSum(newValue);
//						}
						//여기 테스트 요망
//						UniAppManager.app.fnOrderAmtCal(record, 'O', fieldName, newValue);
//						detailStore.fnOrderAmtSum();
//						break;
						var dOrderO=record.get('ORDER_UNIT_Q')*record.get('ORDER_UNIT_P');
						record.set('ORDER_UNIT_O', dOrderO);					
						UniAppManager.app.fnOrderAmtCal(record, "O",'ORDER_UNIT_O', dOrderO, newValue);
						detailStore.fnOrderAmtSum();
						break;
					
					case "INOUT_TAX_AMT" :		
						var dSaleAmtO = record.get('ORDER_UNIT_O');
						if(newValue > 0 && dSaleAmtO < newValue){
							rv='<t:message code="system.message.sales.message040" default="매출금액은 세액보다 커야 합니다."/>';	//매출금액은 세액보다 커야 합니다.
							break;
						}
//						var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
						var numDigitOfPrice = UniFormat.Price.length - (UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length: UniFormat.Price.indexOf("."));
						if(UserInfo.compCountry == "CN"){
							record.set('INOUT_TAX_AMT', UniSales.fnAmtWonCalc(newValue, "3"), numDigitOfPrice)
						}else{
							record.set('INOUT_TAX_AMT', UniSales.fnAmtWonCalc(newValue, "2"), numDigitOfPrice)
						}
						detailStore.fnOrderAmtSum();
						break;
					
					case "ACCOUNT_YNC" :		
						if(newValue == "N"){
							record.set('ORDER_UNIT_P', 0);
							record.set('INOUT_FOR_WGT_P', 0);
							record.set('INOUT_FOR_VOL_P', 0);
							record.set('INOUT_WGT_P', 0);
							record.set('INOUT_VOL_P', 0);
							record.set('ORDER_UNIT_O', 0);
							record.set('INOUT_TAX_AMT', 0);
						}else{
							if(record.get('SRQ100T_PRICE') != 0 && record.get('SOF110T_PRICE') != 0){
								record.set('ORDER_UNIT_P', record.get('SRQ100T_PRICE'));
							}else if(record.get('SOF110T_PRICE') != 0){
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
				}
			}
			return rv;
		}
	});
	Unilite.createValidator('validator01', {
		store: barcodeStore,
		grid: barcodeGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			if(BsaCodeInfo.gsInoutAutoYN == "N" && record.get('ACCOUNT_Q')){
				rv = '<t:message code="system.message.sales.message055" default="매출이 진행된 건은 수정/삭제할 수 없습니다."/>';				
			}else if( record.get('SALE_C_YN' == 'Y')){
				rv = '<t:message code="system.message.sales.message056" default="계산서가 마감된 건은 수정/삭제가 불가능합니다."/>';
			}else{
				switch(fieldName) {
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
						record.set('ACCOUNT_YNC', UniAppManager.app.fnGetSubCode1(null, newValue));
						if((sRefCode2 > "91" && sRefCode2 < "99" ) || sRefCode2 == "C1"){
							record.set('REF_CODE2', OldRefCode2);
							rv='<t:message code="system.message.sales.message046" default="해당 출고유형은 선택할 수 없습니다."/>';
							break;
						}else if(sRefCode2 == "AU"){
							if(record.get('STOCK_CARE_YN') != "N"){
								record.set('ITEM_CODE', '');
								record.set('ITEM_NAME', '');
								record.set('SPEC', "");
								break;
							}
							record.set('ACCOUNT_YNC','Y');	//매출대상
							record.set('STOCK_CARE_YN','N');	//재고대상여부 - 아니오
							
						}else if(sRefCode2 == "91"){
							if(!Ext.isEmpty(record.get('STOCK_CARE_YN')) || !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))){
								record.set('REF_CODE2', OldRefCode2);
								rv='<t:message code="system.message.sales.message046" default="해당 출고유형은 선택할 수 없습니다."/>';
								break;
							}
							record.set('ACCOUNT_YNC','N');	//미매출대상
							record.set('ITEM_STATUS','1');	//불량 -> 양품으로 바꿈 20160701
							
						}else{
							if((!Ext.isEmpty(record.get('ORDER_NUM')) && Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) || (Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) || (!Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM')))){
								//skip						
							}else{
								record.set('ACCOUNT_YNC', UniAppManager.app.fnAccountYN(null, newValue));
							}	
							record.set('ACCOUNT_YNC', UniAppManager.app.fnAccountYN(null, newValue));
						}
						break;
						
					case "WH_CODE" :
						if(!Ext.isEmpty(newValue)){
							record.set('WH_NAME',e.column.field.getRawValue());
							record.set('WH_CELL_CODE', "");
							record.set('WH_CELL_NAME', "");
							record.set('LOT_NO', "");
						}else{
							record.set('WH_CODE', "");
							record.set('WH_CELL_CODE', "");
							record.set('WH_CELL_NAME', "");
							record.set('LOT_NO', "");
						}
						if(!Ext.isEmpty(record.get('ITEM_CODE'))){
							UniSales.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('DIV_CODE'), record.get('ITEM_STATUS'), record.get('ITEM_CODE'),  newValue);					
							
						}
						//그리드 창고cell콤보 reLoad.. 
//						cbStore.loadStoreRecords(newValue);
						break;
					
					case "WH_CELL_CODE" :
						record.set('WH_CELL_NAME',e.column.field.getRawValue());
						break;			
					
					case "ITEM_STATUS" :
						if(!Ext.isEmpty(record.get('ITEM_CODE'))){
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
//						UniSales.fnGetDivPriceInfo2(record, UniAppManager.app.cbGetPriceInfo
//												,'I'
//												,UserInfo.compCode
//												,record.get('INOUT_CODE')
//												,record.get('AGENT_TYPE')
//												,record.get('ITEM_CODE')
//												,BsaCodeInfo.gsMoneyUnit
//												,record.get('ORDER_UNIT')
//												,record.get('STOCK_UNIT')
//												,record.get('TRANS_RATE')
//												,UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'))
//												,record.get('ORDER_UNIT_Q')
//												,record.get('WGT_UNIT')
//												,record.get('VOL_UNIT')
//												,record.get('UNIT_WGT')
//												,record.get('UNIT_VOL')
//												,record.get('PRICE_TYPE')
//												,newValue
//												)
//						detailStore.fnOrderAmtSum();
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
						if(newValue <= 0 || Ext.isEmpty(newValue)) {
							rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							break;
						}
						var selectedRecord = detailGrid.getSelectedRecord();
						if(Ext.isEmpty(selectedRecord)) {
							rv='<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>';
							break;
						}
						var sInout_q	= newValue;	//출고량
						var sInv_q		= record.get('STOCK_Q');	//재고량
						var sOriginQ	= record.get('ORIGIN_Q'); //출고량
						var lot_q		= record.get('TEMP_ORDER_UNIT_Q');//로트팝업에서 넘겨받는 수량
						
						if(!Ext.isEmpty(lot_q) && lot_q!= 0){
							if(sInout_q > lot_q){
								rv = '<t:message code="system.message.sales.message062" default="출고량은 lot재고량을 초과할 수 없습니다. 현재고: "/>' + lot_q;
								break;
							}
						}
						
						
						if(BsaCodeInfo.gsInvstatus == "+" && (record.get('STOCK_CARE_YN') == "Y")){
							if(sInout_q > (sInv_q + sOriginQ)){
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
						
						UniAppManager.app.fnOrderAmtCal(record, 'Q', fieldName, newValue);
						
						//바코드 인식 한 값 detailGrid에 set
						var newDetailOderUnitQ	= selectedRecord.get('ORDER_UNIT_Q') + newValue - oldValue;
						selectedRecord.set('ORDER_UNIT_Q', newDetailOderUnitQ);
						UniAppManager.app.fnOrderAmtCal(selectedRecord, 'Q', 'ORDER_UNIT_Q', newDetailOderUnitQ);

						detailStore.fnOrderAmtSum();
						break;
					
					case "INOUT_WGT_Q" :	//hidden
						if(newValue < 0 && !Ext.isEmpty(newValue)) {
							rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							break;
						}
						var sOrderWgtQ = record.get('INOUT_WGT_Q');
						var sUnitWgt = record.get('UNIT_WGT');
						if(sUnitWgt == 0){
							rv='<t:message code="system.message.sales.message063" default="단위중량이 입력되지 않아서 계산이 불가능합니다. 품목정보에서 단위중량을 확인하시기 바랍니다."/>'
							break;
						}
						var sInout_q = sUnitWgt == 0 ? 0 : sOrderWgtQ / sUnitWgt;
						if(BsaCodeInfo.gsPointYn == "N" && (record.get('ORDER_UNIT') == BsaCodeInfo.gsPointYn)){
							if(sInout_q - (Math.floor(sInout_q)) != 0){
								rv='<t:message code="system.message.sales.message064" default="수주량(판매단위)은 소숫점을 입력할 수 없습니다. 수주량(중량단위)을 확인하시기 바랍니다."/>'
								break;
							}
						}
						record.set('ORDER_UNIT_Q', sInout_q);
						sInout_q = record.get('ORDER_UNIT_Q');
						var sInv_q = record.get('STOCK_Q');	//재고량
						var sOriginQ = record.get('ORIGIN_Q');//출고량
						var sExcessQ = record.get('EXCESS_RATE');//초과량
						
						if(BsaCodeInfo.gsInvstatus == "+" && (record.get('STOCK_CARE_YN') == "Y")){
							if(sInout_q  > sInv_q + sOriginQ){
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
						if(newValue > 0 && dTaxAmtO > newValue){
							rv='<t:message code="system.message.sales.message040" default="매출금액은 세액보다 커야 합니다."/>';	//매출금액은 세액보다 커야 합니다.
							break;
						}
						
						UniAppManager.app.fnOrderAmtCal(record, 'O', fieldName, newValue);
						rv = false;
						detailStore.fnOrderAmtSum();
						break;
					
					case "TAX_TYPE" :		
//						if(!Ext.isEmpty(newValue) && newValue == "1"){
//							var inoutTax = record.get('ORDER_UNIT_O') / 10
//							record.set('INOUT_TAX_AMT', inoutTax);
//							detailStore.fnOrderAmtSum(newValue);
//						}else if(!Ext.isEmpty(newValue) && newValue == "2"){
//							record.set('INOUT_TAX_AMT', 0);
//							detailStore.fnOrderAmtSum(newValue);
//						}
						//여기 테스트 요망
//						UniAppManager.app.fnOrderAmtCal(record, 'O', fieldName, newValue);
//						detailStore.fnOrderAmtSum();
//						break;
						var dOrderO=record.get('ORDER_UNIT_Q')*record.get('ORDER_UNIT_P');
						record.set('ORDER_UNIT_O', dOrderO);					
						UniAppManager.app.fnOrderAmtCal(record, "O",'ORDER_UNIT_O', dOrderO, newValue);
						detailStore.fnOrderAmtSum();
						break;
					
					case "INOUT_TAX_AMT" :		
						var dSaleAmtO = record.get('ORDER_UNIT_O');
						if(newValue > 0 && dSaleAmtO < newValue){
							rv='<t:message code="system.message.sales.message040" default="매출금액은 세액보다 커야 합니다."/>';	//매출금액은 세액보다 커야 합니다.
							break;
						}
//						var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
						var numDigitOfPrice = UniFormat.Price.length - (UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length: UniFormat.Price.indexOf("."));
						if(UserInfo.compCountry == "CN"){
							record.set('INOUT_TAX_AMT', UniSales.fnAmtWonCalc(newValue, "3"), numDigitOfPrice)
						}else{
							record.set('INOUT_TAX_AMT', UniSales.fnAmtWonCalc(newValue, "2"), numDigitOfPrice)
						}
						detailStore.fnOrderAmtSum();
						break;
					
					case "ACCOUNT_YNC" :		
						if(newValue == "N"){
							record.set('ORDER_UNIT_P', 0);
							record.set('INOUT_FOR_WGT_P', 0);
							record.set('INOUT_FOR_VOL_P', 0);
							record.set('INOUT_WGT_P', 0);
							record.set('INOUT_VOL_P', 0);
							record.set('ORDER_UNIT_O', 0);
							record.set('INOUT_TAX_AMT', 0);
						}else{
							if(record.get('SRQ100T_PRICE') != 0 && record.get('SOF110T_PRICE') != 0){
								record.set('ORDER_UNIT_P', record.get('SRQ100T_PRICE'));
							}else if(record.get('SOF110T_PRICE') != 0){
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
				}
			}
			return rv;
		}
	}); // validator

	var activeGridId = 's_str105ukrv_mitGrid';
}
</script>