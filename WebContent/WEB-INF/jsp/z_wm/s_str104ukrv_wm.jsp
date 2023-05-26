<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str104ukrv_wm">
	<t:ExtComboStore comboType="BOR120"  pgmId="s_str104ukrv_wm"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A028"/>							<!-- 카드사 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>							<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B010"/>							<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>							<!-- 판매단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B021"/>							<!-- 품목상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>							<!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5'/>				<!-- 생성경로 -->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>							<!-- 과세여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B116"/>							<!-- 단가구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S002"/>							<!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S003"/>							<!-- 단가구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S007"/>							<!-- 출고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>							<!-- 영업담당자 -->
	<t:ExtComboStore comboType="AU" comboCode="S014"/>							<!-- 매출대상 -->
	<t:ExtComboStore comboType="AU" comboCode="S065"/>							<!-- 주문구분 -->
	<t:ExtComboStore comboType="AU" comboCode="T016"/>							<!-- 대금결제방법 -->
	<t:ExtComboStore comboType="AU" comboCode="YP09"/>							<!-- 판매형태 -->
	<t:ExtComboStore comboType="OU"/>											<!-- 창고 -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList"/>		<!--창고Cell-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLevel1Store"/>	<!-- 대분류 -->
</t:appConfig>
<style type="text/css">
	.search-hr {height: 1px;}
	.x-grid-cell-essential2 {background-color: #FDE3FF;}		//바탕 분홍
</style>

<script type="text/javascript">
var searchInfoWindow;		//searchInfoWindow : 검색창
var referRequestWindow;		//출하지시참조
var refersalesOrderWindow;	//수주(오퍼)참조
var gsRefYn			= 'N'
var gsMonClosing	= '';	//월마감 여부
var gsDayClosing	= '';	//일마감 여부
var gsOldMonClosing	= '';	//20200107 추가: 월마감 여부(기존 데이터)
var gsOldDayClosing	= '';	//20200107 추가: 일마감 여부(기존 데이터)
var gsOldInoutDate	= '';	//20200107 추가
var gsWhCode		= '';	//창고코드
var isLoad			= false;//20190930 로딩 플래그 화폐단위 환율 change 로드시 계속 타므로 flag처리
var gsQueryFlag		= false;//20201230 추가: 창고변경 시, 창고에 설정되어 있는 기본창고cell 가져오는 로직 추가
var alertWindow;			//20210114 추가: alertWindow : 경고창
var gsText			= ''	//20210114 추가: 바코드 알람 팝업 메세지
////2015.02.10
////마감 처리 된건 수정 불가하게 수정
////여신액 넣게 fnGetCustCredit
////저장후 수불번호 박히는지 확인

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
	inoutPrsn			: ${inoutPrsn},
	whList				: ${whList},
	useLotAssignment	: '${useLotAssignment}',
	gsBoxYN				: '${gsBoxYN}',
	gsAutoSalesYN		: '${gsAutoSalesYN}',		//20200108 공통코드(S033 - 출고등록시 자동매출생성/삭제여부) 가져오는 로직 추가: 1 자동, 2 수동(값이 없을 때는 수동)
	gsShowExistLotNo	: '${gsShowExistLotNo}',	//20200115 공통코드(S156 - LOT팝업에 Main Grid에 적용된 LOT표시 여부) 가져오는 로직 추가
	gsDefaultWhCode		: '${gsDefaultWhCode}',		//20210602 추가: 기본창고 정보
	gsDefaultWhCellCode	: '${gsDefaultWhCellCode}'	//20210602 추가: 기본창고CELL 정보
};
//20200108 공통코드(S033 - 출고등록시 자동매출생성/삭제여부) 가져오는 로직 추가: 1 자동, 2 수동(값이 없을 때는 수동)
if(Ext.isEmpty(BsaCodeInfo.gsAutoSalesYN)) {
	BsaCodeInfo.gsAutoSalesYN = '2';
}
var CustomCodeInfo = {
	gsAgentType		: '',
	gsCustCreditYn	: '',
	gsUnderCalBase	: '',
	gsTaxInout		: '',
	gsbusiPrsn		: ''
};

var outDivCode = UserInfo.divCode;

function appMain() {
	/** 자동채번 여부
	 */
	var isAutoOrderNum = false;
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
			read	: 's_str104ukrv_wmService.selectDetailList',
			update	: 's_str104ukrv_wmService.updateDetail',
			create	: 's_str104ukrv_wmService.insertDetail',
			destroy	: 's_str104ukrv_wmService.deleteDetail',
			syncAll	: 's_str104ukrv_wmService.saveAll'
		}
	});



	/** 수주의 마스터 정보를 가지고 있는 Form
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5},
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
			fieldLabel	: '<t:message code="unilite.msg.sMR047" default="출고일"/>',
			name		: 'INOUT_DATE',
			xtype		: 'uniDatefield',
			value		: new Date(),
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
		 			if(Ext.isDate(newValue)) {
						if(newValue != oldValue &&!Ext.isEmpty(newValue && !Ext.isEmpty(panelResult.getValue('DIV_CODE')))){
							UniSales.fnGetClosingInfo(
								//조회, 참조 후에도 수정가능하게 변경함으로 인해 추가로직 적용을 위한 새로운 함수 생성
								UniAppManager.app.cbGetClosingInfo2,
								panelResult.getValue('DIV_CODE'),
								"I",
								UniDate.getDbDateStr(newValue)
							);
						}
		 			}
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>' ,
			holdable		: 'hold',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER': ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE': ['1','3']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.taxabletotalamount" default="과세총액"/>(1)',
			name		: 'TOT_SALE_TAXI',
			margin		: '0 0 0 50',
			xtype		: 'uniNumberfield',
			colspan		: 2,
			readOnly	: true,
			value		: 0
		},{
			fieldLabel	: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			name		: 'SALE_DATE',
			xtype		: 'uniDatefield',
			value		: new Date(),
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					if(detailStore.data.length > 0) {
						var records = detailStore.data.items;
						Ext.each(records, function(record, index) {
							record.set('SALE_DATE', newValue);
						});
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMS836" default="수불담당"/>',
			name		: 'INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024',
			allowBlank	: false,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					//20200107 로직 추가
					if(detailStore.data.length > 0) {
						var records = detailStore.data.items;
						Ext.each(records, function(record, index) {
							record.set('INOUT_PRSN', newValue);
						});
					}
					//20210415 추가: 수불담당 변경 시, 영업담당 값 set
					var inoutPrsns = Ext.data.StoreManager.lookup('CBS_AU_B024').data.items;
					Ext.each(inoutPrsns, function(inoutPrsn, i) {
						if(inoutPrsn.get('value') == newValue) {
							panelResult.setValue('ORDER_PRSN', inoutPrsn.get('refCode6'));
						}
					})
				}
			}
		},{	//20210415 추가: fieldset으로 묶기
			title	: '바코드 스캔',
			xtype	: 'uniFieldset',
			layout	: {type: 'vbox', tableAttrs:{cellpadding: 10}, tdAttrs: {valign: 'bottom'}},
			rowspan	: 3,
			margin	: '5 0 0 55',
			padding	: '3 0 3 0',
			width	: 270,
			height	: 72,
			items	: [{
				//20210317 추가
				fieldLabel	: '대분류',
				name		: 'ITEM_LEVEL1', 
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLevel1Store'),
	//			holdable	: 'hold',
				multiSelect	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{	//20210114 추가: 출하지시번호 필드 추가 -> 바코드 스캔 시, 출하지시참조/적용 로직 타도록 로직 추가
				fieldLabel	: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>',
				name		: 'ISSUE_BARCODE',
				xtype		: 'uniTextfield',
				readOnly	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					},
					specialkey:function(field, event)	{
						if(event.getKey() == event.ENTER) {
							var newValue = panelResult.getValue('ISSUE_BARCODE');
							if(!Ext.isEmpty(newValue)) {
								Ext.getBody().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
								fnEnterIssueBarcode(newValue);
								panelResult.setValue('ISSUE_BARCODE', '');
							}
						}
					}
				}
			}
		]},{//20200108 추가
			xtype	: 'component',
			itemId	: 'component1',
			width	: 100
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxtotalamount" default="세액합계"/>(2)',
			name		: 'TOT_TAXI',
			margin		: '0 0 0 50',
			colspan		: 2,
			readOnly	: true,
			value		: 0,
			xtype		: 'uniNumberfield'
		},{
			fieldLabel	: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
			name		: 'CREATE_LOC',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B031',
			allowBlank	: false,
			value		: '1',
			holdable	: 'hold',
			colspan		: 2,
			hidden		: true,
			listeners	: {
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
//						masterForm.getField('ALL_CHANGE_WH_CODE').setValue(records[0]['WH_CODE']);
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					var authoInfo = pgmInfo.authoUser;						//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;						//부서정보
					var divCode = '';										//사업장

					if(authoInfo == "A"){									//자기사업장
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});

					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});

					}else if(authoInfo == "5"){								//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),{
			fieldLabel	: '<t:message code="unilite.msg.sMRBW144" default="출고번호"/>',
			xtype		: 'uniTextfield',
			name		: 'INOUT_NUM',
//			colspan		: 2,
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="unilite.msg.sMB184" default="화폐"/>',
			name		: 'MONEY_UNIT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B004',
			value		: UserInfo.currency,
			allowBlank	: false,
			displayField: 'value',
			holdable	: 'hold',
			fieldStyle	: 'text-align: center;',
			hidden		: true,						//20210415
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					fnSetColumnFormat();
				},
				blur: function( field, The, eOpts ) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.exchangerate" default="환율"/>',
			name		: 'EXCHG_RATE_O',
			xtype		: 'uniNumberfield',
			holdable	: 'hold',
			decimalPrecision: 4,
			value		: 1,
			hidden		: true,						//20210415
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{	//20210415 추가
			fieldLabel	: '영업담당',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
				if(eOpts) {
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxexemptiontotalamount" default="면세총액"/>(3)',
			name		: 'TOT_SALENO_TAXI',
			xtype		: 'uniNumberfield',
			readOnly	: true,
			value		: 0,
			labelWidth	: 140
		},{
			title	: '거래명세서',
			xtype	: 'uniFieldset',
			layout	: {type: 'uniTable', tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
			rowspan	: 2,
			margin	: '-10 0 0 20',
			padding	: '0 0 3 0',
//			xtype	: 'container',
//			layout	: {type: 'uniTable', align: 'center'},
			items	: [{
				margin	: '0 0 0 20',
				xtype	: 'button',
				text	: '출력',
				id		: 'btnPrint',
				width	: 80,
				handler	: function() {
					if(Ext.isEmpty(panelResult.getValue('INOUT_NUM'))){
						return false;
					}
					if(UniAppManager.app._needSave()) {
						Unilite.messageBox(Msg.fstMsgH0103);
						return false;
					}
					//20210208 수정: 거래명세서 출력 (str410skrv)의 출력양식 '20' 출력하도록 수정
					var param					= panelResult.getValues();
					param.PGM_ID				= 'str410skrv';
					param.MAIN_CODE				= 'S036';
					param["COMP_NAME"]			= UserInfo.deptName;
					param["INCLUDE_PRICE_YN"]	= panelResult.getValue('rdoIncludePriceGroup1').rdoIncludePrice;

					var win = Ext.create('widget.ClipReport', {
						url		: CPATH+'/sales/str410clskrv_cov.do',
						prgID	: 'str410skrv_kodi',
						extParam: param
					});
					win.center();
					win.show();
				}
			},{	//20210208 추가: 출력 옵션
				fieldLabel	: '단가포함여부',
				xtype		: 'radiogroup',
				id			: 'rdoIncludePriceGroup1',
				labelWidth	: 100,
				items		: [{
					boxLabel	: '포함',
					name		: 'rdoIncludePrice',
					inputValue	: 'Y',
					checked		: true,
					width		: 50
				},{
					boxLabel	: '미포함',
					name		: 'rdoIncludePrice',
					inputValue	: 'N',
					width		: 70
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('rdoIncludePrice').setValue(newValue.rdoIncludePrice);
					}
				}
			}
		]},{
			fieldLabel	: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			child		: 'WH_CELL_CODE',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					//창고변경 시, 창고에 설정되어 있는 기본창고cell 가져오는 로직 추가
					var param = {
						DIV_CODE: panelResult.getValue('DIV_CODE'),
						WH_CODE	: newValue
					}
					matrlCommonService.getWhCellCode(param, function(provider, response) {
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
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
						store.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						})
					} else {
						store.filterBy(function(record){
							return false;
						})
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>',
			name		: 'WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '출고총액[(1)+(2)+(3)]',
			xtype		: 'uniNumberfield',
			name		: 'TOTAL_AMT',
			readOnly	: true,
			value		: 0,
			labelWidth	: 140
		},{
			fieldLabel	: '수량총계',
			xtype		: 'uniNumberfield',
			type		: 'uniQty',
			name		: 'TOT_QTY',
			readOnly	: true,
			value		: 0,
			hidden		: true
		},{
			fieldLabel	: '<t:message code="system.label.sales.creditamount2" default="여신액"/>',
			name		: 'REM_CREDIT',
			xtype		: 'uniNumberfield',
			holdable	: 'hold',
			hidden		: true
		},{
			xtype	: 'uniTextfield',
			name	: 'NATION_INOUT',
			hidden	: true
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



	/** 디테일 정보를 가지고 있는 Grid
	 */
	Unilite.defineModel('s_str104ukrv_wmDetailModel', {
		fields: [
			{name: 'INOUT_CODE'				, text:'<t:message code="system.label.sales.issueplace" default="출고처"/>'				, type: 'string', allowBlank: false},
			{name: 'CUSTOM_NAME'			, text:'출고처명'				, type: 'string'},
			{name: 'INOUT_SEQ'				, text:'<t:message code="system.label.sales.seq" default="순번"/>'						, type: 'int', allowBlank: false},
			{name: 'INOUT_TYPE_DETAIL'		, text:'<t:message code="system.label.sales.issuetype" default="출고유형"/>'				, type: 'string', comboType: 'AU', comboCode: 'S007', allowBlank: false, defaultValue: Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value')},
			{name: 'WH_CODE'				, text:'<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'			, type: 'string', comboType	: 'OU', allowBlank: false/*, child: 'WH_CELL_CODE'*/},
			{name: 'WH_NAME'				, text:'<t:message code="system.label.sales.issuewarehousename" default="출고창고명"/>'		, type: 'string'},
			{name: 'WH_CELL_CODE'			, text:'<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>'	, type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList')/*, parentNames:['WH_CODE','SALE_DIV_CODE']*/},
			{name: 'WH_CELL_NAME'			, text:'<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>'	, type: 'string'},
			{name: 'SALE_DIV_CODE'			, text:'<t:message code="system.label.sales.salesdivision" default="매출사업장"/>'			, type: 'string', allowBlank: false, child: 'WH_CODE'},////확인해봐야함
			{name: 'ITEM_CODE'				, text:'<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'				, text:'<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'					, text:'<t:message code="system.label.sales.spec" default="규격"/>'						, type: 'string'},
			{name: 'LOT_NO'					, text:'<t:message code="system.label.sales.lotno" default="LOT번호"/>'					, type: 'string'},
			{name: 'ITEM_STATUS'			, text:'<t:message code="system.label.sales.itemstatus" default="품목상태"/>'				, type: 'string', comboType: 'AU', comboCode: 'B021', defaultValue: "1", allowBlank: false},
			{name: 'ORDER_UNIT'				, text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'				, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'B013', displayField: 'value'},
			{name: 'PRICE_TYPE'				, text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string', defaultValue: BsaCodeInfo.gsPriceGubun},
			{name: 'TRANS_RATE'				, text:'<t:message code="system.label.sales.containedqty" default="입수"/>'				, type: 'uniQty', defaultValue: 1, allowBlank: false},
			{name: 'PACK_UNIT_Q'			, text:'<t:message code="system.label.sales.packunitq" default="BOX입수"/>'				, type: 'uniQty'},
			{name: 'BOX_Q'					, text:'<t:message code="system.label.sales.boxq" default="BOX수"/>'						, type: 'uniQty'},
			{name: 'EACH_Q'					, text:'<t:message code="system.label.sales.eachq" default="낱개"/>'						, type: 'uniQty'},
			{name: 'LOSS_Q'					, text:'<t:message code="system.label.sales.lossq" default="LOSS여분"/>'					, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q'			, text:'<t:message code="system.label.sales.issueqty" default="출고량"/>'					, type: 'uniQty', defaultValue: 0, allowBlank: false},
			{name: 'TEMP_ORDER_UNIT_Q'		, text:'TEMP_ORDER_UNIT_Q'	, type: 'uniQty'},//LOT팝업에서 허용된 수량만 입력하기 위해..
			{name: 'ORDER_UNIT_P'			, text:'<t:message code="system.label.sales.price" default="단가"/>'						, type: 'uniUnitPrice', defaultValue: 0, allowBlank: true, editable: true},
			{name: 'INOUT_WGT_Q'			, text:'<t:message code="system.label.sales.issueqty" default="출고량"/>(<t:message code="system.label.sales.weight" default="중량"/>)'				, type: 'uniQty', defaultValue: 0},
			{name: 'INOUT_FOR_WGT_P'		, text:'<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'			, type: 'uniUnitPrice', defaultValue: 0},
			{name: 'INOUT_VOL_Q'			, text:'<t:message code="system.label.sales.issueqty" default="출고량"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'				, type: 'uniQty', defaultValue: 0},
			{name: 'INOUT_FOR_VOL_P'		, text:'<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'			, type: 'uniUnitPrice', defaultValue: 0},
			{name: 'INOUT_WGT_P'			, text:'<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.weight" default="중량"/>)'				, type: 'uniUnitPrice', defaultValue: 0},
			{name: 'INOUT_VOL_P'			, text:'<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'				, type: 'uniUnitPrice', defaultValue: 0},
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
			{name: 'ORDER_STOCK_Q'			, text:'판매단위재고수량'			, type: 'uniQty'},
			{name: 'PRICE_YN'				, text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string', comboType: 'AU', comboCode: 'S003', defaultValue: "2", allowBlank: false},
			{name: 'ACCOUNT_YNC'			, text:'<t:message code="system.label.sales.salessubject" default="매출대상"/>'				, type: 'string', comboType: 'AU', comboCode: 'S014', defaultValue: "Y", allowBlank: false},
			{name: 'DELIVERY_DATE'			, text:'<t:message code="system.label.sales.deliverydate2" default="납품일"/>'				, type: 'uniDate'},
			{name: 'DELIVERY_TIME'			, text:'<t:message code="system.label.sales.deliverytime2" default="납품시간"/>'			, type: 'string'},
			{name: 'RECEIVER_ID'			, text:'<t:message code="system.label.sales.receiverid" default="수신자ID"/>'				, type: 'string'},
			{name: 'RECEIVER_NAME'			, text:'<t:message code="system.label.sales.receivername" default="수신자명"/>'				, type: 'string'},
			{name: 'TELEPHONE_NUM1'			, text:'<t:message code="system.label.sales.phoneno1" default="전화번호"/>'					, type: 'string'},
			{name: 'TELEPHONE_NUM2'			, text:'<t:message code="system.label.sales.phoneno1" default="전화번호"/>'					, type: 'string'},
			{name: 'ADDRESS'				, text:'<t:message code="system.label.sales.address" default="주소"/>'					, type: 'string'},
			{name: 'SALE_CUSTOM_CODE'		, text:'<t:message code="system.label.sales.salesplace" default="매출처"/>'				, type: 'string', allowBlank: false},
			{name: 'SALE_CUST_CD'			, text:'<t:message code="system.label.sales.salesplacename" default="매출처명"/>'			, type: 'string', allowBlank: false},////매출처 defaultValue 다시 분석
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
			{name: 'INOUT_NUM'				, text:'INOUT_NUM'			, type: 'string'},
			{name: 'INOUT_DATE'				, text:'INOUT_DATE'			, type: 'uniDate', allowBlank: false},
			{name: 'INOUT_METH'				, text:'INOUT_METH'			, type: 'string', defaultValue: "2", allowBlank: false},
			{name: 'INOUT_TYPE'				, text:'INOUT_TYPE'			, type: 'string', defaultValue: "2", allowBlank: false},
			{name: 'DIV_CODE'				, text:'DIV_CODE'			, type: 'string', allowBlank: false},
			{name: 'INOUT_CODE_TYPE'		, text:'INOUT_CODE_TYPE'	, type: 'string', defaultValue: "4", allowBlank: false},
			{name: 'INOUT_CODE'				, text:'<t:message code="system.label.sales.issueplace" default="출고처"/>'				, type: 'string', allowBlank: false},
			{name: 'CREATE_LOC'				, text:'CREATE_LOC'			, type: 'string', allowBlank: false},
			{name: 'UPDATE_DB_USER'			, text:'UPDATE_DB_USER'		, type: 'string', defaultValue: UserInfo.userID},
			{name: 'UPDATE_DB_TIME'			, text:'UPDATE_DB_TIME'		, type: 'string'},
			{name: 'MONEY_UNIT'				, text:'MONEY_UNIT'			, type: 'string', allowBlank: false},
			//20200113 EXCHG_RATE_O type변경: 'int' -> 'uniER'
			{name: 'EXCHG_RATE_O'			, text:'EXCHG_RATE_O'		, type: 'uniER', allowBlank: false, defaultValue: 1},
			{name: 'ORIGIN_Q'				, text:'ORIGIN_Q'			, type: 'uniQty'},
			{name: 'ORDER_NOT_Q'			, text:'ORDER_NOT_Q'		, type: 'uniQty'},
			{name: 'ISSUE_NOT_Q'			, text:'ISSUE_NOT_Q'		, type: 'uniQty'},
			{name: 'ORDER_SEQ'				, text:'<t:message code="system.label.sales.soseq" default="수주순번"/>'					, type: 'int'},
			{name: 'ISSUE_REQ_SEQ'			, text:'ISSUE_REQ_SEQ'		, type: 'uniQty'},
			{name: 'BASIS_SEQ'				, text:'BASIS_SEQ'			, type: 'int'},
			{name: 'ORDER_TYPE'				, text:'ORDER_TYPE'			, type: 'string'},
			{name: 'STOCK_UNIT'				, text:'STOCK_UNIT'			, type: 'string'},
			{name: 'BILL_TYPE'				, text:'<t:message code="system.label.sales.vattype" default="부가세유형"/>'			, type: 'string', defaultValue: "10", allowBlank: false, comboType: 'AU', comboCode: 'S024'},		//20210414 수정: 콤보로 변경 / 컬럼명 설정
			{name: 'SALE_TYPE'				, text:'SALE_TYPE'			, type: 'string', allowBlank: false},
			{name: 'CREDIT_YN'				, text:'CREDIT_YN'			, type: 'string', defaultValue: BsaCodeInfo.gsCustCreditYn},
			{name: 'ACCOUNT_Q'				, text:'ACCOUNT_Q'			, type: 'uniQty', defaultValue: 0},
			{name: 'SALE_C_YN'				, text:'SALE_C_YN'			, type: 'string', defaultValue: "N"},
			{name: 'INOUT_PRSN'				, text:'INOUT_PRSN'			, type: 'string'},
			{name: 'WON_CALC_BAS'			, text:'WON_CALC_BAS'		, type: 'string', defaultValue: BsaCodeInfo.gsUnderCalBase},
			{name: 'TAX_INOUT' 				, text:'<t:message code="system.label.base.taxincludedflag" default="세액포함여부"/>' 	,type: 'string'	, comboType: 'AU',comboCode: 'B030', defaultValue: '1', allowBlank: false},
			{name: 'AGENT_TYPE'				, text:'AGENT_TYPE'			, type: 'string', defaultValue: BsaCodeInfo.gsAgentType},
			{name: 'STOCK_CARE_YN'			, text:'STOCK_CARE_YN'		, type: 'string'},
			{name: 'RETURN_Q_YN'			, text:'RETURN_Q_YN'		, type: 'string'},
			{name: 'REF_CODE2'				, text:'REF_CODE2'			, type: 'string'}, ////defaultValue: INOUT_TYPE_DETAIL(출고유형)의 SUB_CODE를들고REF_CODE2를 참조해옴
			{name: 'EXCESS_RATE'			, text:'EXCESS_RATE'		, type: 'int'},
			{name: 'SRC_ORDER_Q'			, text:'SRC_ORDER_Q'		, type: 'string'},
			{name: 'SOF110T_PRICE'			, text:'SOF110T_PRICE'		, type: 'uniPrice'},
			{name: 'SRQ100T_PRICE'			, text:'SRQ100T_PRICE'		, type: 'uniPrice'},
			{name: 'COMP_CODE'				, text:'COMP_CODE'			, type: 'string', defaultValue: UserInfo.compCode, allowBlank: false },
			{name: 'DEPT_CODE'				, text:'DEPT_CODE'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text:'ITEM_ACCOUNT'		, type: 'string'},
			{name: 'GUBUN'					, text:'GUBUN'				, type: 'string'},
			{name: 'SALE_BASIS_P'			, text:'<t:message code="system.label.sales.sellingprice" default="판매단가"/>'				, type: 'uniUnitPrice', editable: false},
			{name: 'LOT_YN'					, text:'LOT_YN'				, type: 'string'},
			{name: 'NATION_INOUT'			, text:'NATION_INOUT'		, type: 'string'},
			{name: 'SALE_DATE'				, text:'SALE_DATE'			, type: 'uniDate'},
			{name: 'REMARK_INTER'			, text:'<t:message code="system.label.sales.remarkinter" default="내부기록사항"/>'			, type: 'string'},
			//20210108 추가: API연동을 위해 추가
			{name: 'BUNDLE_NO'				, text:'BUNDLE_NO'			, type: 'string', editable: false},
			{name: 'NUMBER'					, text:'NUMBER'				, type: 'string', editable: false},
			{name: 'CARD_CUSTOM_CODE'		, text: '카드사'				, type: 'string', comboType: 'AU', comboCode: 'A028'}		//20210223 추가, 20210414 수정: 조건에 따라 수정할 수 있도록 변경
		]
	});
	//마스터 스토어 정의
	var detailStore = Unilite.createStore('s_str104ukrv_wmDetailStore', {
		model	: 's_str104ukrv_wmDetailModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param		= panelResult.getValues();
			var inoutNum	= panelResult.getValue('INOUT_NUM').split(',');
			param.INOUT_NUM	= inoutNum;
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
				if(record.data['INOUT_NUM'] != orderNum) {
					record.set('INOUT_NUM', orderNum);
				}
				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
					Unilite.messageBox((index + 1) + '행의 입력값을 확인해 주세요.\n' + 'LOT NO: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				if(record.get('ACCOUNT_YNC') == 'Y') {
					if(Ext.isEmpty(record.get('ORDER_UNIT_P')) || record.get('ORDER_UNIT_P') == 0){
						Unilite.messageBox((index + 1) + '<t:message code="system.message.sales.message060" default="행의 입력값을 확인해 주세요."/>\n' + '<t:message code="system.message.sales.message071" default="매출대상은 단가가 필수 입력값 입니다."/>');
						isErr = true;
						return false;
					}
					if(Ext.isEmpty(record.get('ORDER_UNIT_O')) || record.get('ORDER_UNIT_O') == 0){
						Unilite.messageBox((index + 1) + '<t:message code="system.message.sales.message060" default="행의 입력값을 확인해 주세요."/>\n' + '<t:message code="system.message.sales.message072" default="매출대상은 금액이 필수 입력값 입니다."/>');
						isErr = true;
						return false;
					}
				}
			});
			if(isErr) return false;
			
			//20210108 추가: 신규 등록의 경우 playauto 출고지시   API 호출을 위해 bundle_no 배열 생성
			var bundle_codes = '';
			Ext.each(toCreate, function(toCreateRecord, index) {
				if(!Ext.isEmpty(toCreateRecord.get('BUNDLE_NO'))
				&& toCreateRecord.get('NUMBER') !='9999'				//20210111 수정: 쇼핑몰 코드('9999')으로 확정되어  99999 -> 9999로 변경
				&& toCreateRecord.get('NUMBER').length <= 5) {
					if(index == 0) {
						bundle_codes = toCreateRecord.get('BUNDLE_NO');
					} else {
						bundle_codes = bundle_codes + ',' + toCreateRecord.get('BUNDLE_NO');
					}
				}
			});

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			paramMaster.bundle_codes = bundle_codes;

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//20210208 수정: 출고번호 1개 생성 시에는 저장 후, 조회할 수 있도록 변경
						var master = batch.operations[0].getResultSet();
						if(!Ext.isEmpty(master.INOUT_NUM)) {
							panelResult.setValue("INOUT_NUM", master.INOUT_NUM);
						}
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						Ext.getCmp('btnPrint').setDisabled(false);//출력버튼 활성화
						UniAppManager.setToolbarButtons('save', false);

						if(!Ext.isEmpty(master.INOUT_NUM)) {
							detailStore.loadStoreRecords();
						} else {
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				//20210208 수정: 출고번호 1개 생성 시에는 저장 후, 조회할 수 있도록 변경하면서 조회로직 수정
				if(records.length == 0) {
					UniAppManager.app.onResetButtonDown();
				} else {
					panelResult.setValue('CUSTOM_CODE', records[0].get('INOUT_CODE'));
					panelResult.setValue('CUSTOM_NAME', records[0].get('CUSTOM_NAME'));
					this.fnOrderAmtSum();
					//20200113 !isLoad 추가
					isLoad = false;
				}
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
		fnOrderAmtSum: function() {
//			Unilite.messageBox(this.countBy(function(record, id){
//										return record.get('TAX_TYPE') == '1';}));
			var dtotQty	 = 0;
			var dSaleTI 	= 0;
			var dSaleNTI 	= 0;
			var dTaxI 		= 0;

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
			panelResult.setValue('TOT_SALE_TAXI'	, dSaleTI);								//과세총액(1)
			panelResult.setValue('TOT_SALENO_TAXI'	, dSaleNTI);							//면세총액(3)
			panelResult.setValue('TOT_TAXI'			, dTaxI);								//세액합계(2)
			panelResult.setValue('TOTAL_AMT'		, dSaleTI + dSaleNTI + dTaxI);			//출고총액
			panelResult.setValue('TOT_QTY'			, dtotQty);								//수량총계
		}
	});
	//마스터 그리드 정의
	var detailGrid = Unilite.createGrid('s_str104ukrv_wmGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: false,
			copiedRow		: true
		},
		tbar: [{
			itemId	: 'refBtn',
			text	: '<div style="color: blue"><t:message code="system.label.sales.soofferrefer" default="수주(오퍼)참조"/></div>',
			handler	: function() {
				if(BsaCodeInfo.useLotAssignment == "Y"){
					if(Ext.isEmpty(panelResult.getValue('WH_CODE'))){
						Unilite.messageBox('출고창고를 선택해 주세요.');
						return false;
					}else if(Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))){
						Unilite.messageBox('출고창고 Cell을 선택해 주세요.');
						return false;
					}
				}
				opensalesOrderWindow();
				}
		},'-',{
			itemId	: 'requestBtn',
			text	: '<div style="color: blue"><t:message code="system.label.sales.shipmentorderrefer" default="출하지시참조"/></div>',
			handler	: function() {
				openRequestWindow();
			}
		}],
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns: [
			{dataIndex: 'INOUT_CODE'			, width:133, hidden: false,						//20210414 추가
				editor: Unilite.popup('AGENT_CUST_G',{
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('INOUT_CODE'		, records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME'		, records[0]['CUSTOM_NAME']);
								grdRecord.set('SALE_CUSTOM_CODE', records[0]['CUSTOM_CODE']);
								grdRecord.set('SALE_CUST_CD'	, records[0]['CUSTOM_NAME']);
								grdRecord.set('TAX_INOUT'		, records[0]['TAX_TYPE']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('INOUT_CODE'		, '');
							grdRecord.set('CUSTOM_NAME'		, '');
							grdRecord.set('SALE_CUSTOM_CODE', '');
							grdRecord.set('SALE_CUST_CD'	, '');
							grdRecord.set('TAX_INOUT'		, '1');
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
							popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
						}
					}
				})
			},
			{dataIndex: 'CUSTOM_NAME'			, width:133, hidden: false,						//20210414 추가
				editor: Unilite.popup('AGENT_CUST_G',{
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('INOUT_CODE'		, records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME'		, records[0]['CUSTOM_NAME']);
								grdRecord.set('SALE_CUSTOM_CODE', records[0]['CUSTOM_CODE']);
								grdRecord.set('SALE_CUST_CD'	, records[0]['CUSTOM_NAME']);
								grdRecord.set('TAX_INOUT'		, records[0]['TAX_TYPE']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('INOUT_CODE'		, '');
							grdRecord.set('CUSTOM_NAME'		, '');
							grdRecord.set('SALE_CUSTOM_CODE', '');
							grdRecord.set('SALE_CUST_CD'	, '');
							grdRecord.set('TAX_INOUT'		, '1');
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
							popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
						}
					}
				})
			},
			{dataIndex: 'INOUT_SEQ'				, width:60 , align: 'center'},
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width:120},
			{dataIndex: 'WH_CODE'				, width:93},
			{dataIndex: 'WH_NAME'				, width:93, hidden: true},
			{dataIndex: 'WH_CELL_CODE'			, width:120, hidden: sumtypeCell,
				//20200116 추가
				listeners:{
					render:function(elm) {
						elm.editor.on('beforequery',function(queryPlan, eOpts) {
							var store = queryPlan.combo.store;
							var record = detailGrid.uniOpt.currentRecord;
							store.clearFilter();
							store.filterBy(function(item){
								return item.get('option') == record.get('WH_CODE')
									//BSA225T의 CUSTOM_CODE가 비어 있거나 panelResult의 값과 동일한 데이터만 show
									&&(item.get('refCode10') == record.get('INOUT_CODE') || item.get('refCode10') == '*')
							})
						})
					}
				},
				//20200107 추가: 상단 PANEL에서 설정한 값 SET할 때, 변경된 WH_CODE에 맞는 WH_CELL_CODE SET하기 위해 수정
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filterBy(function(item){
						return item.get('option') == record.get('WH_CODE')
							//BSA225T의 CUSTOM_CODE가 비어 있거나 panelResult의 값과 동일한 데이터만 show
							&&(item.get('refCode10') == record.get('INOUT_CODE') || item.get('refCode10') == '*')
					})
				}
			},
			{dataIndex: 'WH_CELL_NAME'			, width:100, hidden: true },
			{dataIndex: 'SALE_DIV_CODE'			, width:100, hidden: true },
			{dataIndex: 'ITEM_CODE'				, width:113,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					useBarcodeScanner: false,
					autoPopup:true,
//					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
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
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'				, width:133,
				editor: Unilite.popup('DIV_PUMOK_G', {
//					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
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
						applyextparam: function(popup){
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode});
						}
					}
				})
			},
			{dataIndex: 'SPEC'					, width:133 },
			{dataIndex: 'BILL_TYPE'				, width:100 },
			{dataIndex: 'CARD_CUSTOM_CODE'		, width:100 },
			{dataIndex: 'LOT_NO'				, width:120, hidden: true,			//20210414 수정 - hidden: true
				editor: Unilite.popup('LOT_MULTI_G', {
					textFieldName	: 'LOTNO_CODE',
					DBtextFieldName	: 'LOTNO_CODE',
					validateBlank	: false,
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								//20200128 LOT_NO 멀티선택 시 그리드 값 set하는 로직 일괄 수정
								console.log('records : ', records);
								var grdRecord			= detailGrid.uniOpt.currentRecord;
								var newDetailRecords	= new Array();
								var rtnRecord;
								var goodStockQ	= 0;
								var badStockQ	= 0;
								var outQ		= grdRecord.get('ORDER_UNIT_Q');
								var transRate	= 1;
								Ext.each(records, function(record,i) {
									if(i==0){
										rtnRecord = grdRecord;
										transRate = rtnRecord.get('TRANS_RATE');
										if(Ext.isEmpty(transRate)){
											transRate = 1;
										}
										rtnRecord.set('LOT_NO'				, record['LOT_NO']);
										rtnRecord.set('TEMP_ORDER_UNIT_Q'	, record['STOCK_Q']);
										rtnRecord.set('STOCK_Q'				, record['STOCK_Q']);
										rtnRecord.set('ORDER_STOCK_Q'		, record['STOCK_Q'] / transRate);
										rtnRecord.set('WH_CODE'				, record['WH_CODE']);
										rtnRecord.set('WH_CELL_CODE'		, record['WH_CELL_CODE']);
		
										goodStockQ = record['GOOD_STOCK_Q'];
		
										if(goodStockQ < outQ){
											rtnRecord.set('ORDER_UNIT_Q', goodStockQ);
											outQ = outQ - goodStockQ;
										} else {
											rtnRecord.set('ORDER_UNIT_Q', outQ);
											outQ = 0;
										}
										//20200120 금액계산로직 추가
										UniAppManager.app.fnOrderAmtCal(rtnRecord, 'Q');
									} else {
//										UniAppManager.app.onNewDataButtonDown();
										rtnRecord		= detailGrid.getSelectedRecord();
										var columns		= detailGrid.getColumns();
										var inoutSeq	= 0 ;
										var sortSeq		= 0;
										inoutSeq		= detailStore.max('INOUT_SEQ');
										sortSeq			= detailStore.max('SORT_SEQ');

										if(Ext.isEmpty(inoutSeq)){
											inoutSeq = 1;
										} else{
											inoutSeq = inoutSeq + i;
										}

										if(Ext.isEmpty(sortSeq)){
											sortSeq = 1;
										} else{
											sortSeq = sortSeq + i;
										}
										goodStockQ	= record['GOOD_STOCK_Q'];
										if(goodStockQ < outQ){
											var orderUnitQ = goodStockQ;
											outQ = outQ - goodStockQ;
										} else {
											var orderUnitQ = outQ;
											outQ = 0;
										}
										var r = {
											INOUT_SEQ			: inoutSeq,
											SORT_SEQ			: sortSeq,
											LOT_NO				: record['LOT_NO'],
											TEMP_ORDER_UNIT_Q	: record['STOCK_Q'],
											STOCK_Q				: record['STOCK_Q'],
											ORDER_STOCK_Q		: record['STOCK_Q'],
											WH_CODE				: record['WH_CODE'],
											WH_CELL_CODE		: record['WH_CELL_CODE'],
											ORDER_UNIT_Q		: orderUnitQ
										}
										newDetailRecords[i-1] = detailStore.model.create( r );
										Ext.each(columns, function(column, index) {
											if(    column.dataIndex != 'INOUT_SEQ'
												&& column.dataIndex != 'SORT_SEQ'
												&& column.dataIndex != 'LOT_NO'
												&& column.dataIndex != 'TEMP_ORDER_UNIT_Q'
												&& column.dataIndex != 'ORDER_UNIT_Q'
												&& column.dataIndex != 'ACCOUNT_Q'
												&& column.dataIndex != 'STOCK_Q'
												&& column.dataIndex != 'WH_CODE'
												&& column.dataIndex != 'WH_CELL_CODE'
												&& column.dataIndex != 'ORDER_STOCK_Q') {
												newDetailRecords[i-1].set(column.initialConfig.dataIndex, grdRecord.get(column.initialConfig.dataIndex));
											}
										});

										//출고량(중량) 재계산
										var sInout_q	= newDetailRecords[i-1].get('ORDER_UNIT_Q');
										var sUnitWgt	= newDetailRecords[i-1].get('UNIT_WGT');
										var sOrderWgtQ	= sInout_q * sUnitWgt;
										newDetailRecords[i-1].set('INOUT_WGT_Q'			, sOrderWgtQ);

										//출고량(부피) 재계산
										var sUnitVol = newDetailRecords[i-1].get('UNIT_VOL');
										var sOrderVolQ = sInout_q * sUnitVol;
										newDetailRecords[i-1].set('INOUT_VOL_Q'			, sOrderVolQ);

										if(newDetailRecords[i-1].get('ACCOUNT_YNC') == "N"){
											newDetailRecords[i-1].set('ORDER_UNIT_P'	, 0);
										}

										//20171211 합계금액 표시를 위해 함수 호출
										UniAppManager.app.fnOrderAmtCal(newDetailRecords[i-1], "Q")
									}
									//20200131 추가
									if(outQ == 0) {
										return false;
									}
								});
								detailStore.loadData(newDetailRecords, true);
							},
							scope: this
						},
						'onClear': function(type) {
							var rtnRecord = detailGrid.uniOpt.currentRecord;
							rtnRecord.set('LOT_NO', '');
							rtnRecord.set('LOT_ASSIGNED_YN', 'N');
							rtnRecord.set('TEMP_ORDER_UNIT_Q', '');
						},
						applyextparam: function(popup){
							//20200115 공통코드(main Grid에 있는 LOT 표시 여부)에 따라 main Grid에 있는 LOT 정보 넘기는 로직 추가
							var lots		= '';
							var grdRecord	= detailGrid.uniOpt.currentRecord;
							if(BsaCodeInfo.gsShowExistLotNo == 'N') {	//미표시이면
								var allrecords	= detailStore.data.items;
								Ext.each(allrecords, function(items, index) {
									if(Ext.isEmpty(lots) && !Ext.isEmpty(items.get('LOT_NO'))) {
										lots = items.get('LOT_NO');
									} else if(!Ext.isEmpty(items.get('LOT_NO'))) {
										lots = lots + ',' + items.get('LOT_NO');
									}
								});
								var deletedNum0	= grdRecord.get('LOT_NO') + ',';
								var deletedNum1	= ',' + grdRecord.get('LOT_NO');
								var deletedNum2	= grdRecord.get('LOT_NO');
								
								//20200117로직 수정
								if(deletedNum0 != ',') {
									lots = lots.split(deletedNum0).join("");
								}
								if(deletedNum1 != ',') {
									lots = lots.split(deletedNum1).join("");
								}
								lots = lots.split(deletedNum2).join("");
							}
							var record		= detailGrid.getSelectedRecord();
							var divCode		= panelResult.getValue('DIV_CODE');
							var itemCode	= record.get('ITEM_CODE');
							var itemName	= record.get('ITEM_NAME');
							var whCode		= record.get('WH_CODE');
							var whCellCode	= record.get('WH_CELL_CODE');
							var stockYN		= 'Y'
							//20200115 요청수량 넘기는 로직 추가
							var reqQ		= record.get('ORDER_UNIT_Q');
							popup.setExtParam({
								SELMODEL		: 'MULTI',
								'DIV_CODE'		: divCode,
								'ITEM_CODE'		: itemCode,
								'ITEM_NAME'		: itemName,
								'S_WH_CODE'		: whCode,
								'S_WH_CELL_CODE': whCellCode,
								'STOCK_YN'		: stockYN,
								//20200115 요청수량 넘기는 로직 추가
								'REQ_Q'			: reqQ,
								//20200115 공통코드(main Grid에 있는 LOT 표시 여부)에 따라 main Grid에 있는 LOT 정보 넘기는 로직 추가
								'LOTS'			: lots
							});
						}
					}
				})
			},
//			{dataIndex: 'SALE_BASIS_P'			, width:90 },
			{dataIndex: 'DISCOUNT_RATE'			, width:93, hidden: true},			//20210414 수정 - hidden: true
			{dataIndex: 'ORDER_UNIT'			, width:80, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'ITEM_STATUS'			, width:80 },
			{dataIndex: 'PACK_UNIT_Q'			, width:100, hidden: BsaCodeInfo.gsBoxYN == 'Y' ? false : true},
			{dataIndex: 'BOX_Q'					, width:100, hidden: BsaCodeInfo.gsBoxYN == 'Y' ? false : true},
			{dataIndex: 'EACH_Q'				, width:100, hidden: BsaCodeInfo.gsBoxYN == 'Y' ? false : true},
			{dataIndex: 'LOSS_Q'				, width:100, hidden: BsaCodeInfo.gsBoxYN == 'Y' ? false : true},
			{dataIndex: 'ORDER_UNIT_Q'			, width:93, summaryType: 'sum' },
			{dataIndex: 'TRANS_RATE'			, width:73, hidden: true},						//20210414 수정 - hidden: true
			{dataIndex: 'ORDER_UNIT_P'			, width:86, summaryType: 'sum' },
			{dataIndex: 'ORDER_UNIT_O'			, width:100, summaryType: 'sum' },
			{dataIndex: 'INOUT_TAX_AMT'			, width:80, summaryType: 'sum' },
			{dataIndex: 'ORDER_AMT_SUM'			, width:80, summaryType: 'sum' },
			{dataIndex: 'TAX_TYPE'				, width:80, align: 'center' },
			{dataIndex: 'TAX_INOUT'				, width:100, align: 'center' },					//20210414 수정 - hidden: false, 콤보로 변경
			{dataIndex: 'STOCK_Q'				, width:120, summaryType: 'sum' },
			{dataIndex: 'ORDER_STOCK_Q'			, width:120, summaryType: 'sum', hidden: true},	//20210414 수정 - hidden: true
//			{dataIndex: 'PURCHASE_RATE'			, width:90 },
//			{dataIndex: 'PURCHASE_P'			, width:90 },
			{dataIndex: 'SALE_PRSN'				, width:100 },
//			{dataIndex: 'SALES_TYPE'			, width:70 },
			{dataIndex: 'PRICE_TYPE'			, width:110, hidden: true },
			{dataIndex: 'INOUT_WGT_Q'			, width:106, hidden: true },
			{dataIndex: 'INOUT_FOR_WGT_P'		, width:106, hidden: true },
			{dataIndex: 'INOUT_VOL_Q'			, width:106, hidden: true },
			{dataIndex: 'INOUT_FOR_VOL_P'		, width:106, hidden: true },
			{dataIndex: 'INOUT_WGT_P'			, width:106, hidden: true },
			{dataIndex: 'INOUT_VOL_P'			, width:106, hidden: true },
			{dataIndex: 'WGT_UNIT'				, width:66, hidden: true },
			{dataIndex: 'UNIT_WGT'				, width:100, hidden: true },
			{dataIndex: 'VOL_UNIT'				, width:80, hidden: true },
			{dataIndex: 'UNIT_VOL'				, width:93, hidden: true },
			{dataIndex: 'TRANS_COST'			, width:93, summaryType: 'sum', hidden: true},	//20210414 수정 - hidden: true
			{dataIndex: 'PRICE_YN'				, width:80 },
			{dataIndex: 'ACCOUNT_YNC'			, width:73 },
			{dataIndex: 'DELIVERY_DATE'			, width:80, hidden: true},						//20210414 수정 - hidden: true
			{dataIndex: 'DELIVERY_TIME'			, width:66, hidden: manageTimeYN, hidden: true},//20210414 수정 - hidden: true
			{dataIndex: 'RECEIVER_ID'			, width:86, hidden: true },
			{dataIndex: 'RECEIVER_NAME'			, width:86, hidden: true },
			{dataIndex: 'TELEPHONE_NUM1'		, width:80, hidden: true },
			{dataIndex: 'TELEPHONE_NUM2'		, width:80, hidden: true },
			{dataIndex: 'ADDRESS'				, width:133, hidden: true },
			{dataIndex: 'SALE_CUSTOM_CODE'		, width:66, hidden: true },						//20210414 수정 - hidden: true
			{dataIndex: 'SALE_CUST_CD'			, width: 110, hidden: true,						//20210414 수정 - hidden: true
				editor: Unilite.popup('AGENT_CUST_G',{
					autoPopup:true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
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
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
							popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
						}
					}
				})
			},
			{dataIndex: 'DVRY_CUST_CD'			, width:113, hidden: true },
			{dataIndex: 'DVRY_CUST_NAME'		, width:113, hidden: true,						//20210414 수정 - hidden: true
				editor: Unilite.popup('DELIVERY_G',{
					autoPopup:true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
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
						applyextparam: function(popup){
							popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
						}
					}
				})
			},
			{dataIndex: 'ORDER_CUST_CD'			, width:113 },
			{dataIndex: 'PLAN_NUM'				, width:115, hidden: true},						//20210414 수정 - hidden: true
			{dataIndex: 'ORDER_NUM'				, width:115 },
			//20200218 수주순번 추가
			{dataIndex: 'ORDER_SEQ'				, width:80 , align: 'center'},
			{dataIndex: 'ISSUE_REQ_NUM'			, width:115 },
			{dataIndex: 'BASIS_NUM'				, width:115, hidden: true},						//20210414 수정 - hidden: true
			{dataIndex: 'PAY_METHODE1'			, width:115, hidden: true},						//20210414 수정 - hidden: true
			{dataIndex: 'LC_SER_NO'				, width:100, hidden: true},						//20210414 수정 - hidden: true
			{dataIndex: 'REMARK'				, width:100 },
			{dataIndex: 'LOT_ASSIGNED_YN'		, width:100,hidden: true },
			{dataIndex: 'INOUT_NUM'				, width:80, hidden: true },
			{dataIndex: 'INOUT_DATE'			, width:66, hidden: true },
			{dataIndex: 'INOUT_METH'			, width:66, hidden: true },
			{dataIndex: 'INOUT_TYPE'			, width:66, hidden: true },
			{dataIndex: 'DIV_CODE'				, width:66, hidden: true },
			{dataIndex: 'INOUT_CODE_TYPE'		, width:66, hidden: true },
			{dataIndex: 'INOUT_CODE'			, width:66, hidden: true },
			{dataIndex: 'CREATE_LOC'			, width:66, hidden: true },
			{dataIndex: 'UPDATE_DB_USER'		, width:66, hidden: true },
			{dataIndex: 'UPDATE_DB_TIME'		, width:66, hidden: true },
			{dataIndex: 'MONEY_UNIT'			, width:66, hidden: true },
			{dataIndex: 'EXCHG_RATE_O'			, width:66, hidden: true },
			{dataIndex: 'ORIGIN_Q'				, width:66, hidden: true },
			{dataIndex: 'ORDER_NOT_Q'			, width:66, hidden: true },
			{dataIndex: 'ISSUE_NOT_Q'			, width:66, hidden: true },
			{dataIndex: 'ISSUE_REQ_SEQ'			, width:66, hidden: true },
			{dataIndex: 'BASIS_SEQ'				, width:66, hidden: true },
			{dataIndex: 'ORDER_TYPE'			, width:66, hidden: true },
			{dataIndex: 'STOCK_UNIT'			, width:66, hidden: true },	//20210223 추가
			{dataIndex: 'SALE_TYPE'				, width:66, hidden: true },
			{dataIndex: 'CREDIT_YN'				, width:66, hidden: true },
			{dataIndex: 'ACCOUNT_Q'				, width:66, hidden: true },
			{dataIndex: 'SALE_C_YN'				, width:66, hidden: true },
			{dataIndex: 'INOUT_PRSN'			, width:66, hidden: true },
			{dataIndex: 'WON_CALC_BAS'			, width:66, hidden: true },
			{dataIndex: 'AGENT_TYPE'			, width:66, hidden: true },
			{dataIndex: 'STOCK_CARE_YN'			, width:66, hidden: true },
			{dataIndex: 'RETURN_Q_YN'			, width:66, hidden: true },
			{dataIndex: 'REF_CODE2'				, width:66, hidden: true },
			{dataIndex: 'EXCESS_RATE'			, width:66, hidden: true },
			{dataIndex: 'SRC_ORDER_Q'			, width:66, hidden: true },
			{dataIndex: 'SOF110T_PRICE'			, width:66, hidden: true },
			{dataIndex: 'SRQ100T_PRICE'			, width:66, hidden: true },
			{dataIndex: 'COMP_CODE'				, width:66, hidden: true },
			{dataIndex: 'DEPT_CODE'				, width:66, hidden: true },
			{dataIndex: 'ITEM_ACCOUNT'			, width:66, hidden: true },
			{dataIndex: 'GUBUN'					, width:66, hidden: true },
			{dataIndex: 'TEMP_ORDER_UNIT_Q'		, width:66, hidden: true },
//			{dataIndex: 'PURCHASE_CUSTOM_CODE'	, width:66, hidden: true },
//			{dataIndex: 'PURCHASE_TYPE'			, width:66, hidden: true },
			{dataIndex: 'LOT_YN'				, width:66, hidden: true},
			{dataIndex: 'NATION_INOUT'			, width:66, hidden: true},
			{dataIndex: 'SALE_DATE'				, width:66, hidden: true},
			{dataIndex: 'REMARK_INTER'			, width:100, hidden: true},						//20210414 수정 - hidden: true
			//20210108 추가: API연동을 위해 추가
			{dataIndex: 'BUNDLE_NO'				, width:100, hidden: false},
			{dataIndex: 'NUMBER'				, width:100, hidden: false}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
//				cbStore.loadStoreRecords(e.record.get('WH_CODE'));
//				var record = detailGrid.uniOpt.currentRecord;
				if (UniUtils.indexOf(e.field, 'LOT_NO')){
						//LOT_NO POPUP에서 출고창고 필수조건 아님(20171211 수정)
//					if(Ext.isEmpty(e.record.data.WH_CODE)){
//						Unilite.messageBox('출고창고를 입력하십시오.');
//						return false;
//					}
					if(BsaCodeInfo.gsSumTypeCell == 'Y' && Ext.isEmpty(e.record.data.WH_CELL_CODE)){
						Unilite.messageBox('출고창고 CELL코드를 입력하십시오.');
						return false;
					}
					if(Ext.isEmpty(e.record.data.ITEM_CODE)){
						Unilite.messageBox(Msg.sMS003);
						return false;
					}
				}
				//20210414 추가: 부가세유형에 따라 카드사 컬럼 수정가능여부 결정하도록 로직 추가
				if (UniUtils.indexOf(e.field, ['CARD_CUSTOM_CODE'])) {
					if(e.record.get('BILL_TYPE') == '40') {
						return true;
					} else {
						return false;
					}
				}
				if(e.record.phantom){			//신규일때
					if(e.record.data.INOUT_METH == '2'){	//예외등록(추가버튼)
						if (UniUtils.indexOf(e.field,
											['INOUT_SEQ', 'SPEC', 'STOCK_Q', 'ORDER_CUST_CD', 'PLAN_NUM', 'ORDER_NUM', 'ORDER_SEQ', 'ISSUE_REQ_NUM', 'BASIS_NUM',		//20210414 수정: INOUT_SEQ, ORDER_SEQ 추가
											 /*'PRICE_YN',*/ 'TRANS_RATE']))
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
						if (UniUtils.indexOf(e.field,
											['INOUT_WGT_P', 'INOUT_VOL_P', 'UNIT_WGT', 'UNIT_VOL', 'INOUT_WGT_P', 'INOUT_VOL_P', 'UNIT_WGT', 'UNIT_VOL',
											 'CUSTOM_NAME', 'CUSTOM_NAME', 'ITEM_CODE',
											 'ITEM_NAME', 'SPEC', 'ORDER_UNIT', 'TRANS_RATE', 'TAX_TYPE', 'DISCOUNT_RATE', 'STOCK_Q',
											 'DELIVERY_DATE', 'DELIVERY_TIME', 'RECEIVER_ID', 'RECEIVER_NAME', 'TELEPHONE_NUM1', 'TELEPHONE_NUM2',
											 'ADDRESS', 'SALE_CUST_CD', 'DVRY_CUST_CD', 'DVRY_CUST_NAME', 'ORDER_CUST_CD', 'PLAN_NUM', 'ORDER_NUM',
											 'ORDER_NUM', 'ISSUE_REQ_NUM', 'BASIS_NUM', 'PAY_METHODE1'	, 'LC_SER_NO', 'INOUT_NUM', 'INOUT_DATE', 'INOUT_METH',
											 'INOUT_TYPE', 'DIV_CODE', 'INOUT_CODE_TYPE', 'INOUT_CODE', 'SALE_CUSTOM_CODE', 'CREATE_LOC', 'UPDATE_DB_USER',
											 'UPDATE_DB_TIME', 'MONEY_UNIT', 'EXCHG_RATE_O', 'ORIGIN_Q', 'ORDER_NOT_Q', 'ISSUE_NOT_Q', 'ORDER_SEQ', 'ISSUE_REQ_SEQ',
											 'BASIS_SEQ', 'ORDER_TYPE', 'STOCK_UNIT', 'BILL_TYPE', 'SALE_TYPE', 'CREDIT_YN', 'ACCOUNT_Q', 'SALE_C_YN', 'INOUT_PRSN',
											 'WON_CALC_BAS', 'TAX_INOUT', 'AGENT_TYPE', 'STOCK_CARE_YN', 'RETURN_Q_YN', 'REF_CODE2', 'EXCESS_RATE', 'SRC_ORDER_Q',
											 'SOF110T_PRICE', 'SRQ100T_PRICE', 'COMP_CODE', 'DEPT_CODE', 'ITEM_ACCOUNT', 'GUBUN' ]))
							return false;

						if(e.record.data.ACCOUNT_YNC == 'N'){
							if (UniUtils.indexOf(e.field,
											['ORDER_UNIT_P', 'ORDER_UNIT_O']))
								return false;
						}

						if(e.record.data.PRICE_YN == '2'){
							if (UniUtils.indexOf(e.field,
											['PRICE_YN']))
								return false;
						}

//						if(BsaCodeInfo.gsLotNoInputMethod == "Y"){
//							if (UniUtils.indexOf(e.field,
//											['LOT_NO']))
//								return false;
//						}

						if(!Ext.isEmpty(e.record.data.GUBUN)){
							if (UniUtils.indexOf(e.field,
											['PRICE_TYPE', 'WGT_UNIT', 'VOL_UNIT']))
								return false;
						}
					}
				} else { //신규가 아닐때
					if (UniUtils.indexOf(e.field,
											['INOUT_TYPE_DETAIL', 'TRANS_RATE', 'INOUT_WGT_P', 'INOUT_VOL_P', 'UNIT_WGT', 'UNIT_VOL', 'INOUT_SEQ',
											 'CUSTOM_NAME', 'WH_CODE', 'WH_NAME', 'WH_CELL_CODE', 'WH_CELL_NAME', 'SALE_DIV_CODE', 'ITEM_CODE', 'ITEM_NAME',
											 'SPEC', 'ITEM_STATUS', 'ORDER_UNIT', 'TAX_TYPE', 'INOUT_TAX_AMT', 'STOCK_Q', 'ACCOUNT_YNC', 'RECEIVER_ID',
											 'RECEIVER_NAME', 'TELEPHONE_NUM1', 'TELEPHONE_NUM2', 'ADDRESS', 'SALE_CUST_CD', 'DVRY_CUST_CD', 'DVRY_CUST_NAME',
												 'ORDER_CUST_CD', 'PLAN_NUM', 'ORDER_NUM', 'ISSUE_REQ_NUM', 'BASIS_NUM', 'PAY_METHODE1', 'LC_SER_NO', 'INOUT_NUM',
												 'INOUT_DATE', 'INOUT_METH', 'INOUT_TYPE', 'DIV_CODE', 'INOUT_CODE_TYPE', 'INOUT_CODE', 'SALE_CUSTOM_CODE',
											 'CREATE_LOC', 'UPDATE_DB_USER', 'UPDATE_DB_TIME', 'MONEY_UNIT', 'EXCHG_RATE_O', 'ORIGIN_Q', 'ORDER_NOT_Q',
											 'ORDER_NOT_Q', 'ISSUE_NOT_Q', 'ORDER_SEQ', 'ISSUE_REQ_SEQ', 'BASIS_SEQ', 'ORDER_TYPE', 'STOCK_UNIT', 'BILL_TYPE',
											 'BILL_TYPE', 'SALE_TYPE', 'CREDIT_YN', 'ACCOUNT_Q', 'SALE_C_YN', 'INOUT_PRSN', 'WON_CALC_BAS', 'TAX_INOUT',
											 'AGENT_TYPE', 'STOCK_CARE_YN', 'RETURN_Q_YN', 'REF_CODE2', 'EXCESS_RATE', 'SRC_ORDER_Q', 'SOF110T_PRICE',
											 'SRQ100T_PRICE', 'COMP_CODE', 'DEPT_CODE', 'ITEM_ACCOUNT', 'GUBUN']))
						return false;

					if(e.record.data.ACCOUNT_YNC == 'N'){	//매출대상이 아닌 경우, 쓰기 불가
							if (UniUtils.indexOf(e.field,
											['ORDER_UNIT_P', 'ORDER_UNIT_O']))
								return false;
						}

					if(e.record.data.PRICE_YN == '2'){
							if (UniUtils.indexOf(e.field,
											['PRICE_YN']))
								return false;
						}

//					if(BsaCodeInfo.gsLotNoInputMethod == "Y"){
//							if (UniUtils.indexOf(e.field,
//											['LOT_NO']))
//								return false;
//						}
					if(!Ext.isEmpty(e.record.data.GUBUN)){
							if (UniUtils.indexOf(e.field,
											['PRICE_TYPE', 'WGT_UNIT', 'VOL_UNIT']))
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
				grdRecord.set('LOT_YN'	 , '');
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
					} else {										//멀티품목팝업시 출고창고 참조방법 '1'인 경우(1=품목의 주창고)
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
				} else {
					grdRecord.set('WGT_UNIT'	 , record['WGT_UNIT']);
					grdRecord.set('UNIT_WGT'	 , record['UNIT_WGT']);
				}
				if((Ext.isEmpty(record['VOL_UNIT']))){
					grdRecord.set('VOL_UNIT'	 , '');
					grdRecord.set('UNIT_VOL'	 , record['UNIT_VOL']);
				} else {
					grdRecord.set('VOL_UNIT'	 , record['VOL_UNIT']);
					grdRecord.set('UNIT_VOL'	 , record['UNIT_VOL']);
				}
//				grdRecord.set('SALE_BASIS_P'	,record['SALE_BASIS_P']);
				////Call fnSetLotNoEssential(lRow) 들어가야함
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
				if(record['STOCK_CARE_YN'] == "Y"){
					UniSales.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), grdRecord.get('ITEM_STATUS'), grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE'));
				}
				grdRecord.set('LOT_YN'	 , record['LOT_YN']);
			}
		}
	});


	/** 검색하기 위한 Search Form, Grid, Inner Window 정의
	 */
	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
		layout			: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items			: [{
			fieldLabel	: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
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
			width			: 350,
			startDate		: new Date() ,
			endDate			: new Date()
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			validateBlank	: false
		}),
		Unilite.popup('DIV_PUMOK',{
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': orderNoSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
			name		: 'INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			xtype		: 'uniTextfield',
			name		: 'PROJECT_NO',
			width		: 315
		},{
			fieldLabel	: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>',
			xtype		: 'uniTextfield',
			name		: 'ISSUE_REQ_NUM',
			width		: 315
		},{
			fieldLabel	: '<t:message code="system.label.sales.receivername" default="수신자명"/>',
			xtype		: 'uniTextfield',
			name		: 'RECEIVER_NAME'
		},{
			fieldLabel	: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
			name		: 'CREATE_LOC',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B031',
			allowBlank	: false,
			value		: '1'
		},
		Unilite.popup('DEPT', {
			fieldLabel		: '<t:message code="system.label.sales.department" default="부서"/>',
			valueFieldName	: 'DEPT_CODE',
			textFieldName	: 'DEPT_NAME',
			hidden			: true,
			allowBlank		: false,
			holdable		: 'hold',
			listeners		: {
				applyextparam: function(popup){
					var authoInfo	= pgmInfo.authoUser;	//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode	= UserInfo.deptCode;	//부서정보
					var divCode		= '';					//사업장

					if(authoInfo == "A"){	//자기사업장
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					} else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					} else if(authoInfo == "5"){		//부서권한
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
			{name: 'WH_NAME'			, text: '<t:message code="system.label.sales.warehouse" default="창고"/>'				, type: 'string'},
			{name: 'INOUT_PRSN'			, text: '<t:message code="system.label.sales.charger" default="담당자"/>'				, type: 'string', comboType:'AU', comboCode:'B024'},
			{name: 'RECEIVER_ID'		, text: '<t:message code="system.label.sales.receiverid" default="수신자ID"/>'			, type: 'string'},
			{name: 'RECEIVER_NAME'		, text: '<t:message code="system.label.sales.receivername" default="수신자명"/>'		, type: 'string'},
			{name: 'TELEPHONE_NUM1'		, text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>'			, type: 'string'},
			{name: 'TELEPHONE_NUM2'		, text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>'			, type: 'string'},
			{name: 'ADDRESS'			, text: '<t:message code="system.label.sales.address" default="주소"/>'				, type: 'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.tranplacename" default="수불처명"/>'		, type: 'string'},
			{name: 'ISSUE_REQ_NUM'		, text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'	, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'SALE_DIV_CODE'		, text: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>'		, type: 'string'},
			{name: 'SALE_CUST_NM'		, text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			, type: 'string'},
			{name: 'INOUT_CODE'			, text: '<t:message code="system.label.sales.tranplace" default="수불처"/>'			, type: 'string'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.sales.currency" default="화폐"/>'				, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'			, type: 'uniER'},
			{name: 'SALE_DATE'			, text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'			, type: 'uniDate'},
			{name: 'SALE_PRSN'			, text: 'SALE_PRSN'		, type: 'string'},
			/*CustomCodeInfo set위해*/
			{name: 'AGENT_TYPE'			, text: 'AGENT_TYPE'	, type: 'string'},
			{name: 'CREDIT_YN'			, text: 'CREDIT_YN'		, type: 'string'},
			{name: 'WON_CALC_BAS'		, text: 'WON_CALC_BAS'	, type: 'string'},
			{name: 'TAX_TYPE'			, text: 'TAX_TYPE'		, type: 'string'},
			{name: 'BUSI_PRSN'			, text: 'BUSI_PRSN'		, type: 'string'}
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
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_str104ukrv_wmService.selectOrderNumMasterList'
			}
		},
		loadStoreRecords : function() {
			var param		= orderNoSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;	//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;	//부서코드
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
	var orderNoMasterGrid = Unilite.createGrid('str103ukrvOrderNoMasterGrid', {
		store	: orderNoMasterStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: false
		},
		columns:  [
			{ dataIndex: 'DIV_CODE'			, width: 80 },
			{ dataIndex: 'INOUT_CODE'		, width: 90 },
			{ dataIndex: 'CUSTOM_NAME'		, width: 120},
			{ dataIndex: 'CREATE_LOC'		, width: 66 },
			{ dataIndex: 'INOUT_DATE'		, width: 80 },
			{ dataIndex: 'INOUT_Q'			, width: 93 },
			{ dataIndex: 'INOUT_PRSN'		, width: 80 },
			{ dataIndex: 'INOUT_NUM'		, width: 120 },
			{ dataIndex: 'SALE_DIV_CODE'	, width: 73, hidden: true },
			{ dataIndex: 'MONEY_UNIT'		, width: 93 },
			{ dataIndex: 'EXCHG_RATE_O'		, width: 93, hidden: true },
			{ dataIndex: 'ISSUE_REQ_NUM'	, width: 120 }
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoMasterGrid.returnData(record);
				searchInfoWindow.hide();
			}
		},// listeners
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			var field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, record.get('DIV_CODE'), null, null, "DIV_CODE");
			field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, record.get('DIV_CODE'), null, null, "DIV_CODE");

			//20200113 추가
			isLoad = true;
			panelResult.setValue('INOUT_NUM'	, record.get('INOUT_NUM'));
			panelResult.setValue('INOUT_DATE'	, record.get('INOUT_DATE'));
			panelResult.setValue('DIV_CODE'		, record.get('DIV_CODE'));
			panelResult.setValue('INOUT_PRSN'	, record.get('INOUT_PRSN'));
			//20200113 추가
			isLoad = true;
			panelResult.setValue('MONEY_UNIT'	, record.get('MONEY_UNIT'));
			panelResult.setValue('EXCHG_RATE_O'	, record.get('EXCHG_RATE_O'));
			panelResult.setValue('CUSTOM_CODE'	, record.get('INOUT_CODE'));
			panelResult.setValue('CUSTOM_NAME'	, record.get('CUSTOM_NAME'));
			panelResult.setValue('INOUT_DATE'	, record.get('INOUT_DATE'));
			//20200113 추가
			isLoad = true;
			if(Ext.isEmpty(record.get('SALE_DATE'))){
				panelResult.setValue('SALE_DATE', record.get('INOUT_DATE'));
			} else {
				panelResult.setValue('SALE_DATE', record.get('SALE_DATE'));
			}
			//20210415 추가
			isLoad = true;
			panelResult.setValue('ORDER_PRSN'	, record.get('SALE_PRSN'));
			CustomCodeInfo.gsAgentType		= record.get('AGENT_TYPE');
			CustomCodeInfo.gsCustCreditYn	= record.get('CREDIT_YN');
			CustomCodeInfo.gsUnderCalBase	= record.get('WON_CALC_BAS');
			CustomCodeInfo.gsTaxInout 		= record.get('TAX_TYPE');
			CustomCodeInfo.gsbusiPrsn 		= record.get('BUSI_PRSN');
			UniAppManager.app.onQueryButtonDown();
		}
	});
	//검색창 그리드 정의
	var orderNoDetailGrid = Unilite.createGrid('s_str104ukrv_wmorderNoDetailGrid', {
		store	: orderNoMasterStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: false
		},
		hidden	: true,
		columns	: [
			{ dataIndex: 'DIV_CODE'			, width: 80 },
			{ dataIndex: 'ITEM_CODE'		, width: 150 },
			{ dataIndex: 'ITEM_NAME'		, width: 150 },
			{ dataIndex: 'SPEC'				, width: 133 },
			{ dataIndex: 'INOUT_TYPE_DETAIL', width: 80 },
			{ dataIndex: 'CREATE_LOC'		, width: 66 },
			{ dataIndex: 'INOUT_DATE'		, width: 80 },
			{ dataIndex: 'INOUT_Q'			, width: 93 },
			{ dataIndex: 'WH_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'WH_NAME'			, width: 80 },
			{ dataIndex: 'INOUT_PRSN'		, width: 80 },
			{ dataIndex: 'RECEIVER_ID'		, width: 86, hidden: true },
			{ dataIndex: 'RECEIVER_NAME'	, width: 86, hidden: true },
			{ dataIndex: 'TELEPHONE_NUM1'	, width: 80, hidden: true },
			{ dataIndex: 'TELEPHONE_NUM2'	, width: 80, hidden: true },
			{ dataIndex: 'ADDRESS'			, width: 133, hidden: true },
			{ dataIndex: 'INOUT_NUM'		, width: 120 },
			{ dataIndex: 'ISSUE_REQ_NUM'	, width: 100 },
			{ dataIndex: 'PROJECT_NO'		, width: 86 },
			{ dataIndex: 'SALE_DIV_CODE'	, width: 73, hidden: true },
			{ dataIndex: 'SALE_CUST_NM'		, width: 93 },
			{ dataIndex: 'INOUT_CODE'		, width: 93, hidden: true },
			{ dataIndex: 'MONEY_UNIT'		, width: 93 },
			{ dataIndex: 'EXCHG_RATE_O'		, width: 93, hidden: true },
			{ dataIndex: 'SALE_DATE'		, width: 93, hidden: true }
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoDetailGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				searchInfoWindow.hide();
			}
		},// listeners
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			var field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, record.get('DIV_CODE'), null, null, "DIV_CODE");

			panelResult.setValue('INOUT_NUM'	, record.get('INOUT_NUM'));
			//20200113 추가
			isLoad = true;
			panelResult.setValue('INOUT_DATE'	, record.get('INOUT_DATE'));
			panelResult.setValue('DIV_CODE'		, record.get('DIV_CODE'));
			panelResult.setValue('INOUT_PRSN'	, record.get('INOUT_PRSN'));
			//20200113 추가
			isLoad = true;
			panelResult.setValue('MONEY_UNIT'	, record.get('MONEY_UNIT'));
			panelResult.setValue('EXCHG_RATE_O'	, record.get('EXCHG_RATE_O'));
//			panelResult.setValue('CUSTOM_CODE'	, record.get('INOUT_CODE'));
//			panelResult.setValue('CUSTOM_NAME'	, record.get('SALE_CUST_NM'));
			panelResult.setValue('INOUT_DATE'	, record.get('INOUT_DATE'));
			//20200113 추가
			isLoad = true;
			if(Ext.isEmpty(record.get('SALE_DATE'))){
				panelResult.setValue('SALE_DATE', record.get('INOUT_DATE'));
			} else {
				panelResult.setValue('SALE_DATE', record.get('SALE_DATE'));
			}
			//20210415 추가
			isLoad = true;
			panelResult.setValue('ORDER_PRSN'	, record.get('SALE_PRSN'));
			CustomCodeInfo.gsAgentType		= record.get('AGENT_TYPE');
			CustomCodeInfo.gsCustCreditYn	= record.get('CREDIT_YN');
			CustomCodeInfo.gsUnderCalBase	= record.get('WON_CALC_BAS');
			CustomCodeInfo.gsTaxInout 		= record.get('TAX_TYPE');
			CustomCodeInfo.gsbusiPrsn 		= record.get('BUSI_PRSN');
		}
	});
	//검색창 메인
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.issuenosearch" default="출고번호검색"/>',
				width	: 830,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [orderNoSearch, orderNoMasterGrid, orderNoDetailGrid],
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
						orderNoDetailGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
						orderNoDetailGrid.reset();
					},
					beforeshow: function( panel, eOpts ) {
						field = orderNoSearch.getField('INOUT_PRSN');
						field.fireEvent('changedivcode'			, field, panelResult.getValue('DIV_CODE'), null, null, "DIV_CODE");
						orderNoSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						orderNoSearch.setValue('INOUT_PRSN'		, panelResult.getValue('INOUT_PRSN'));
						orderNoSearch.setValue('CUSTOM_CODE'	, panelResult.getValue('CUSTOM_CODE'));
						orderNoSearch.setValue('CUSTOM_NAME'	, panelResult.getValue('CUSTOM_NAME'));
//						orderNoSearch.setValue('ORDER_TYPE'		, panelResult.getValue('ORDER_TYPE'));
						orderNoSearch.setValue('INOUT_DATE_FR'	, new Date());
						orderNoSearch.setValue('INOUT_DATE_TO'	, new Date());
						orderNoSearch.setValue('CREATE_LOC'		, '1');
						orderNoSearch.setValue('DEPT_CODE'		, panelResult.getValue('DEPT_CODE'));
						orderNoSearch.setValue('DEPT_NAME'		, panelResult.getValue('DEPT_NAME'));

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
		layout	:  {type : 'uniTable', columns : 4},
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			xtype		: 'uniCombobox',
			name		: 'DIV_CODE',
			child		: 'WH_CODE',
			comboType	: 'BOR120',
			allowBlank	: false,
			readOnly	: true
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>' ,
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': requestSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel		: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ISSUE_DATE_FR',
			endFieldName	: 'ISSUE_DATE_TO',
			width			: 350,
			colspan			: 2,
			endDate			: UniDate.get('tomorrow')
		},{
			fieldLabel	: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>',
			xtype		: 'uniTextfield',
			name		: 'ISSUE_REQ_NUM'
		},{	//20210302 수정: 관리번호 대신 주문/수신자 조회조건 추가
			fieldLabel	: '주문/수신자',
			xtype		: 'uniTextfield',
			name		: 'RECEIVER_NAME'
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			comboCode	: ''
			//store		: Ext.data.StoreManager.lookup('whList')
		},{	//20210302 수정: 내부기록사항 대신 '생산완료, 취소포함여부' 추가
			xtype	: 'container',
			padding	: '0 0 0 0',
			layout	: {type : 'uniTable', columns : 1},
			rowspan	: 2,
			items	: [{
				fieldLabel	: ' ',
				boxLabel	: '생산 완료',
				name		: 'CLOSE_YN',
				xtype		: 'checkboxfield',
				labelWidth	: 60
			},{
				fieldLabel	: ' ',
				boxLabel	: '취소 포함',
				name		: 'CANCEL_YN',
				xtype		: 'checkboxfield',
				labelWidth	: 60
			}]
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false
		}),{
			fieldLabel	: '<t:message code="system.label.sales.remarks" default="비고"/>',
			xtype		: 'uniTextfield',
			name		: 'REMARK'
		},{	//20210317 추가
			fieldLabel	: '대분류',
			name		: 'ITEM_LEVEL1', 
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('itemLevel1Store'),
//			holdable	: 'hold',
			multiSelect	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'hiddenfield',
			name	: 'MONEY_UNIT'
		},/* {
			xtype: 'hiddenfield',
				name:'CUSTOM_CODE'
		},{
			xtype: 'hiddenfield',
				name:'CUSTOM_NAME'
		}, */{
			xtype	: 'hiddenfield',
			name	: 'CREATE_LOC'
		}]
	});
	//출하지시 참조 모델 정의
	Unilite.defineModel('s_str104ukrv_wmRequestModel', {
		fields: [
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.custom" default="거래처"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'					, type: 'string'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'			, type: 'string', displayField: 'value'},
			{name: 'TRANS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			, type: 'string'},
			{name: 'ISSUE_REQ_DATE'		,text: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'	, type: 'uniDate'},
			{name: 'ISSUE_DATE'			,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'			, type: 'uniDate'},
			{name: 'NOT_REQ_Q'			,text: '<t:message code="system.label.sales.unissuedqty" default="미출고량"/>'			, type: 'uniQty'},
			{name: 'ISSUE_REQ_QTY'		,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'	, type: 'uniQty'},
			{name: 'ISSUE_WGT_Q'		,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>(<t:message code="system.label.sales.weight" default="중량"/>)'		, type: 'string'},
			{name: 'ISSUE_VOL_Q'		,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'		, type: 'string'},
			{name: 'STOCK_Q'			,text: '<t:message code="system.label.sales.inventoryqty2" default="재고수량"/>'		, type: 'uniQty'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'		, type: 'string', comboType	: 'OU'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.sales.soofferno" default="수주(오퍼)번호"/>'		, type: 'string'},
			{name: 'ISSUE_REQ_NUM'		,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'	, type: 'string'},
			{name: 'ISSUE_REQ_SEQ'		,text: '<t:message code="system.label.sales.seq" default="순번"/>'					, type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			, type: 'string'},
			{name: 'PAY_METHODE1'		,text: '<t:message code="system.label.sales.amountpaymethod" default="대금결제방법"/>'	, type: 'string'},
			{name: 'LC_SER_NO'			,text: '<t:message code="system.label.sales.lcno" default="L/C번호"/>'				, type: 'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'				, type: 'string'},
			{name: 'RECEIVER_ID'		,text: '<t:message code="system.label.sales.receiverid" default="수신자ID"/>'			, type: 'string'},
			{name: 'RECEIVER_NAME'		,text: '<t:message code="system.label.sales.receivername" default="수신자명"/>'			, type: 'string'},
			{name: 'TELEPHONE_NUM1'		,text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>'				, type: 'string'},
			{name: 'TELEPHONE_NUM2'		,text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>'				, type: 'string'},
			{name: 'ADDRESS'			,text: '<t:message code="system.label.sales.address" default="주소"/>'				, type: 'string'},
			{name: 'ORDER_CUST_CD'		,text: '<t:message code="system.label.sales.soplace" default="수주처"/>'				, type: 'string'},
			{name: 'DIV_CODE'			,text: 'DIV_CODE'			, type: 'string'},
			{name: 'CUSTOM_CODE'		,text: 'CUSTOM_CODE'		, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	,text: 'INOUT_TYPE_DETAIL'	, type: 'string'},
			{name: 'WH_CELL_CODE'		,text: 'WH_CELL_CODE'		, type: 'string'},
			{name: 'WH_CELL_NAME'		,text: '출고창고CELL'			, type: 'string'},
			{name: 'ISSUE_REQ_PRICE'	,text: '단가'	                , type: 'uniUnitPrice'},
			{name: 'ISSUE_REQ_AMT'		,text: '금액'		            , type: 'uniUnitPrice'},
			{name: 'ISSUE_REQ_TAX_AMT'	,text: '부가세액'	            , type: 'uniUnitPrice'},
			{name: 'TAX_TYPE'			,text: 'TAX_TYPE'			, type: 'string'},
			{name: 'MONEY_UNIT'			,text: 'MONEY_UNIT'			, type: 'string'},
			{name: 'EXCHANGE_RATE'		,text: 'EXCHANGE_RATE'		, type: 'string'},
			{name: 'ACCOUNT_YNC'		,text: '<t:message code="system.label.sales.salessubject" default="매출대상"/>'			, type: 'string'},
			{name: 'DISCOUNT_RATE'		,text: 'DISCOUNT_RATE'		, type: 'string'},
			{name: 'ISSUE_REQ_PRSN'		,text: 'ISSUE_REQ_PRSN'		, type: 'string'},
			{name: 'DVRY_CUST_CD'		,text: 'DVRY_CUST_CD'		, type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.sales.remarks" default="비고"/>'				, type: 'string'},
			{name: 'SER_NO'				,text: 'SER_NO'				, type: 'string'},
			{name: 'SALE_CUSTOM_CODE'	,text: 'SALE_CUSTOM_CODE'	, type: 'string'},
			{name: 'SALE_CUST_CD'		,text: 'SALE_CUST_CD'		, type: 'string'},
			{name: 'ISSUE_DIV_CODE'		,text: 'ISSUE_DIV_CODE'		, type: 'string'},
			{name: 'BILL_TYPE'			,text: 'BILL_TYPE'			, type: 'string'},
			{name: 'ORDER_TYPE'			,text: 'ORDER_TYPE'			, type: 'string'},
			{name: 'PRICE_YN'			,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'			, type: 'string', comboType: 'AU', comboCode: 'S003'},
			{name: 'PO_NUM'				,text: 'PO_NUM'				, type: 'string'},
			{name: 'PO_SEQ'				,text: 'PO_SEQ'				, type: 'string'},
			{name: 'CREDIT_YN'			,text: 'CREDIT_YN'			, type: 'string'},
			{name: 'WON_CALC_BAS'		,text: 'WON_CALC_BAS'		, type: 'string'},
			{name: 'TAX_INOUT'			,text: 'TAX_INOUT'			, type: 'string'},
			{name: 'AGENT_TYPE'			,text: 'AGENT_TYPE'			, type: 'string'},
			{name: 'STOCK_CARE_YN'		,text: 'STOCK_CARE_YN'		, type: 'string'},
			{name: 'STOCK_UNIT'			,text: 'STOCK_UNIT'			, type: 'string'},
			{name: 'DVRY_CUST_NAME'		,text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			, type: 'string'},
			{name: 'SOF100_TAX_INOUT'	,text: 'SOF100_TAX_INOUT'	, type: 'string'},
			{name: 'RETURN_Q_YN'		,text: 'RETURN_Q_YN'		, type: 'string'},
			{name: 'ORDER_Q'			,text: 'ORDER_Q'			, type: 'string'},
			{name: 'REF_CODE2'			,text: 'REF_CODE2'			, type: 'string'},
			{name: 'EXCESS_RATE'		,text: 'EXCESS_RATE'		, type: 'string'},
			{name: 'DEPT_CODE'			,text: 'DEPT_CODE'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'		,text: 'ITEM_ACCOUNT'		, type: 'string'},
			{name: 'PRICE_TYPE'			,text: 'PRICE_TYPE'			, type: 'string'},
			{name: 'ISSUE_FOR_WGT_P'	,text: 'ISSUE_FOR_WGT_P'	, type: 'string'},
			{name: 'ISSUE_WGT_P'		,text: 'ISSUE_WGT_P'		, type: 'string'},
			{name: 'ISSUE_FOR_VOL_P'	,text: 'ISSUE_FOR_VOL_P'	, type: 'string'},
			{name: 'ISSUE_VOL_P'		,text: 'ISSUE_VOL_P'		, type: 'string'},
			{name: 'WGT_UNIT'			,text: 'WGT_UNIT'			, type: 'string'},
			{name: 'UNIT_WGT'			,text: 'UNIT_WGT'			, type: 'string'},
			{name: 'VOL_UNIT'			,text: 'VOL_UNIT'			, type: 'string'},
			{name: 'UNIT_VOL'			,text: 'UNIT_VOL'			, type: 'string'},
			{name: 'LOT_YN'				,text: 'LOT_YN'				, type: 'string'},
			{name: 'REMARK_INTER'		,text: '<t:message code="system.label.sales.remarkinter" default="내부기록사항"/>'		, type: 'string'},
			//20210108 추가: API연동을 위해 추가
			{name: 'BUNDLE_NO'			,text:'BUNDLE_NO'			, type: 'string'},
			{name: 'NUMBER'				,text:'NUMBER'				, type: 'string'},
			{name: 'CARD_CUSTOM_CODE'	,text: '카드사'				, type: 'string', comboType: 'AU', comboCode: 'A028'},	//20210223 추가
			{name: 'RECEIVER_NAME'		,text:'고객'					, type: 'string'},										//20210302 추가
			{name: 'ORDER_STATUS'		,text:'취소/마감여부'				, type: 'string', comboType: 'AU', comboCode: 'B010'}	//20210302 추가
		]
	});
	//출하지시 참조 스토어 정의
	var requestStore = Unilite.createStore('s_str104ukrv_wmRequestStore', {
		model	: 's_str104ukrv_wmRequestModel',
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
				read: 's_str104ukrv_wmService.selectRequestiList'
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
								if((record.data['ISSUE_REQ_NUM'] == item.data['ISSUE_REQ_NUM'])
									&& (record.data['ISSUE_REQ_SEQ'] == item.data['ISSUE_REQ_SEQ'])) {
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
			var param= requestSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//출하지시 참조 그리드 정의
	var requestGrid = Unilite.createGrid('s_str104ukrv_wmRequestGrid', {
		store	: requestStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false, mode: 'MULTI',
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
					if(record.get('ORDER_STATUS') == 'Y') {
						return false;
					}
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ) {
				},
				deselect:  function(grid, selectRecord, index, eOpts ) {
				}
			}
		}),	//20200417: SIMPLE -> MULTI로 수정, 20210302 추가: 취소/마감인 데이터는 선택되지 않도록 하기 위해 추가
		uniOpt	: {
			onLoadSelectFirst	: false,
			useRowNumberer		: false,
			expandLastColumn	: false
		},
		columns	: [
			{ dataIndex: 'CUSTOM_NAME'			, width: 120 },
			{ dataIndex: 'RECEIVER_NAME'		, width: 100 },
			{ dataIndex: 'ITEM_CODE'			, width: 120 },
			{ dataIndex: 'ITEM_NAME'			, width: 113 },
			{ dataIndex: 'SPEC'					, width: 113 },
			{ dataIndex: 'ORDER_UNIT'			, width: 80, align: 'center' },
			{ dataIndex: 'TRANS_RATE'			, width: 40 },
			{ dataIndex: 'ISSUE_REQ_DATE'		, width: 80 },
			{ dataIndex: 'ISSUE_DATE'			, width: 80 },
			{ dataIndex: 'NOT_REQ_Q'			, width: 80 },
			{ dataIndex: 'ISSUE_REQ_QTY'		, width: 80 },
			{ dataIndex: 'ISSUE_WGT_Q'			, width: 80, hidden: true },
			{ dataIndex: 'ISSUE_VOL_Q'			, width: 80, hidden: true },
			{ dataIndex: 'STOCK_Q'				, width: 80 },
			{ dataIndex: 'WH_CODE'				, width: 93},
			{ dataIndex: 'WH_CELL_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'WH_CELL_NAME'			, width: 66, hidden: false },
			{ dataIndex: 'ORDER_NUM'			, width: 120 },
			{ dataIndex: 'ISSUE_REQ_NUM'		, width: 100 },
			{ dataIndex: 'ISSUE_REQ_SEQ'		, width: 40 },
			{ dataIndex: 'PROJECT_NO'			, width: 86 },
			{ dataIndex: 'PAY_METHODE1'			, width: 100 },
			{ dataIndex: 'LC_SER_NO'			, width: 100 },
			{ dataIndex: 'LOT_NO'				, width: 66 },
			{ dataIndex: 'RECEIVER_ID'			, width: 86, hidden: true },
			{ dataIndex: 'RECEIVER_NAME'		, width: 86 , hidden: true},
			{ dataIndex: 'TELEPHONE_NUM1'		, width: 80, hidden: true },
			{ dataIndex: 'TELEPHONE_NUM2'		, width: 80, hidden: true },
			{ dataIndex: 'ADDRESS'				, width: 133, hidden: true },
			{ dataIndex: 'ORDER_CUST_CD'		, width: 86 },
			{ dataIndex: 'DIV_CODE'				, width: 66, hidden: true },
			{ dataIndex: 'CUSTOM_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 66, hidden: true },
			{ dataIndex: 'ISSUE_REQ_PRICE'		, width: 66, hidden: true },
			{ dataIndex: 'ISSUE_REQ_AMT'		, width: 66, hidden: true },
			{ dataIndex: 'ISSUE_REQ_TAX_AMT'	, width: 66, hidden: true },
			{ dataIndex: 'TAX_TYPE'				, width: 66, hidden: true },
			{ dataIndex: 'MONEY_UNIT'			, width: 66, hidden: true },
			{ dataIndex: 'EXCHANGE_RATE'		, width: 66, hidden: true },
			{ dataIndex: 'ACCOUNT_YNC'			, width: 66 },
			{ dataIndex: 'DISCOUNT_RATE'		, width: 66, hidden: true },
			{ dataIndex: 'ISSUE_REQ_PRSN'		, width: 66, hidden: true },
			{ dataIndex: 'DVRY_CUST_CD'			, width: 66, hidden: true },
			{ dataIndex: 'SER_NO'				, width: 66, hidden: true },
			{ dataIndex: 'SALE_CUSTOM_CODE'		, width: 66, hidden: true },
			{ dataIndex: 'SALE_CUST_CD'			, width: 66, hidden: true },
			{ dataIndex: 'ISSUE_DIV_CODE'		, width: 66, hidden: true },
			{ dataIndex: 'BILL_TYPE'			, width: 66, hidden: true },
			{ dataIndex: 'ORDER_TYPE'			, width: 66, hidden: true },
			{ dataIndex: 'PRICE_YN'				, width: 80 },
			{ dataIndex: 'PO_NUM'				, width: 66, hidden: true },
			{ dataIndex: 'PO_SEQ'				, width: 66, hidden: true },
			{ dataIndex: 'CREDIT_YN'			, width: 66, hidden: true },
			{ dataIndex: 'WON_CALC_BAS'			, width: 66, hidden: true },
			{ dataIndex: 'TAX_INOUT'			, width: 66, hidden: true },
			{ dataIndex: 'AGENT_TYPE'			, width: 66, hidden: true },
			{ dataIndex: 'STOCK_CARE_YN'		, width: 66, hidden: true },
			{ dataIndex: 'STOCK_UNIT'			, width: 66, hidden: true },
			{ dataIndex: 'DVRY_CUST_NAME'		, width: 113 },
			{ dataIndex: 'SOF100_TAX_INOUT'		, width: 66, hidden: true },
			{ dataIndex: 'RETURN_Q_YN'			, width: 66, hidden: true },
			{ dataIndex: 'ORDER_Q'				, width: 66, hidden: true },
			{ dataIndex: 'REF_CODE2'			, width: 66, hidden: true },
			{ dataIndex: 'EXCESS_RATE'			, width: 66, hidden: true },
			{ dataIndex: 'DEPT_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'ITEM_ACCOUNT'			, width: 66, hidden: true },
			{ dataIndex: 'PRICE_TYPE'			, width: 66, hidden: true },
			{ dataIndex: 'ISSUE_FOR_WGT_P'		, width: 66, hidden: true },
			{ dataIndex: 'ISSUE_WGT_P'			, width: 66, hidden: true },
			{ dataIndex: 'ISSUE_FOR_VOL_P'		, width: 66, hidden: true },
			{ dataIndex: 'ISSUE_VOL_P'			, width: 66, hidden: true },
			{ dataIndex: 'WGT_UNIT'				, width: 66, hidden: true },
			{ dataIndex: 'UNIT_WGT'				, width: 66, hidden: true },
			{ dataIndex: 'VOL_UNIT'				, width: 66, hidden: true },
			{ dataIndex: 'UNIT_VOL'				, width: 66, hidden: true },
			{ dataIndex: 'REMARK'				, width: 120},
			{ dataIndex: 'REMARK_INTER'			, width: 120},
			{ dataIndex: 'LOT_YN'				, width: 66	, hidden: true },
			{ dataIndex: 'CARD_CUSTOM_CODE'		, width: 110, hidden: true },	//20210223 추가
			{ dataIndex: 'ORDER_STATUS'			, width: 110, align: 'center' }	//20210223 추가
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			UniAppManager.app.fnMakeSrq100tDataRef(records);
			this.deleteSelectedRow();
			detailStore.fnOrderAmtSum();
		},
		viewConfig: {
			//20210302 추가: 취소/마감된 데이터 배경색으로 구분
			getRowClass: function(record, rowIndex, rowParams, store) {
				var cls = '';
				if(record.get('ORDER_STATUS') == 'Y') {
					cls = 'x-grid-cell-essential2';
				}
				return cls;
			}
		}
	});
	//출하지시 참조 메인
	function openRequestWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;

		if(!referRequestWindow) {
			referRequestWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.shipmentorderrefer" default="출하지시참조"/>',
				width	: 1100,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [requestSearch, requestGrid],
				tbar	: ['->', {
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						requestStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.issueapply" default="출고적용"/>',
					handler	: function() {
						requestGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.sales.issueapplyclose" default="출고적용후 닫기"/>',
					handler	: function() {
						requestGrid.returnData();
						referRequestWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						if(detailStore.getCount() == 0){
							panelResult.setAllFieldsReadOnly(false);
						}
						referRequestWindow.hide();
					},
					disabled: false
				}],
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
	var salesOrderSearch = Unilite.createSearchForm('s_str104ukrv_wmsalesOrderForm', {
		layout	: {type : 'uniTable', columns : 3},
		items	: [
			Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>' ,
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel		: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'DVRY_DATE_FR',
			endFieldName	: 'DVRY_DATE_TO',
			width			: 350,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today')
		},{
			xtype: 'component',
			width: 30
		},{
			fieldLabel	: '<t:message code="system.label.sales.sono" default="수주번호"/>',
			xtype		: 'uniTextfield',
			name		:'ORDER_NUM'
		},{
			fieldLabel	: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			xtype		: 'uniTextfield',
			name		:'PROJECT_NO'
		},{
			xtype: 'component',
			width: 30
		},{
			fieldLabel	: '<t:message code="system.label.sales.domesticoverseasclass" default="국내외구분"/>',
			name		: 'NATION_INOUT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T109',
			value		: '1',
			holdable	: 'hold'
		},{
			fieldLabel	: '<t:message code="system.label.sales.remarkinter" default="내부기록사항"/>',
			xtype		: 'uniTextfield',
			name		:'REMARK_INTER'
		},
		Unilite.popup('DELIVERY',{
			fieldLabel		: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>',
			valueFieldName	: 'DELIVERY_CODE',
			textFieldName	: 'DELIVERY_NAME',
			showValue		: false,
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
				}
			}
		}),{
			xtype: 'hiddenfield',
			name:'CUSTOM_CODE'
		},{
			xtype: 'hiddenfield',
			name:'CUSTOM_NAME'
		},{
			xtype: 'hiddenfield',
			name: 'DIV_CODE'
		},{
			xtype: 'hiddenfield',
			name: 'MONEY_UNIT'
		},{
			xtype: 'hiddenfield',
			name: 'CREATE_LOC'
		}]
	});
	//수주(오퍼) 참조 모델 정의
	Unilite.defineModel('s_str104ukrv_wmsalesOrderModel', {
		fields: [
			{ name: 'ORDER_NUM'			, text:'<t:message code="system.label.sales.sono" default="수주번호"/>'					,type : 'string' },
			{ name: 'SER_NO'			, text:'<t:message code="system.label.sales.seq" default="순번"/>'					,type : 'string' },
			{ name: 'SO_KIND'			, text:'<t:message code="system.label.sales.ordertype" default="주문구분"/>'			,type : 'string', comboType: 'AU', comboCode: 'S065' },
			{ name: 'INOUT_TYPE_DETAIL'	, text:'<t:message code="system.label.sales.issuetype" default="출고유형"/>'			,type : 'string' },
			{ name: 'ITEM_CODE'			, text:'<t:message code="system.label.sales.item" default="품목"/>'					,type : 'string' },
			{ name: 'ITEM_NAME'			, text:'<t:message code="system.label.sales.itemname" default="품목명"/>'				,type : 'string' },
			{ name: 'SPEC'				, text:'<t:message code="system.label.sales.spec" default="규격"/>'					,type : 'string' },
			{ name: 'ORDER_UNIT'		, text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'			,type : 'string', displayField: 'value' },
			{ name: 'TRANS_RATE'		, text:'<t:message code="system.label.sales.containedqty" default="입수"/>'			,type : 'string' },
			{ name: 'DVRY_DATE'			, text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'			,type : 'uniDate' },
			{ name: 'NOT_INOUT_Q'		, text:'<t:message code="system.label.sales.undeliveryqty" default="미납량"/>'			,type : 'uniQty' },
			{ name: 'ORDER_Q'			, text:'<t:message code="system.label.sales.soqty" default="수주량"/>'					,type : 'uniQty' },
			{ name: 'ISSUE_REQ_Q'		, text:'<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'	,type : 'uniQty' },
			{ name: 'R_LOT_NO'			, text:'<t:message code="system.label.sales.lotno" default="LOT번호"/>'				,type : 'string' },
			{ name: 'ORDER_WGT_Q'		, text:'수주량(주량)'		,type : 'string' },
			{ name: 'ORDER_VOL_Q'		, text:'수주량(부피)'		,type : 'string' },
			{ name: 'PROJECT_NO'		, text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			,type : 'string' },
			{ name: 'CUSTOM_NAME'		, text:'<t:message code="system.label.sales.soplace" default="수주처"/>'				,type : 'string' },
			{ name: 'PO_NUM'			, text:'PO NO'			,type : 'string' },
			{ name: 'PAY_METHODE1'		, text:'<t:message code="system.label.sales.amountpaymethod" default="대금결제방법"/>'	,type : 'string' },
			{ name: 'LC_SER_NO'			, text:'<t:message code="system.label.sales.lcno" default="L/C번호"/>'				,type : 'string' },
			{ name: 'CUSTOM_CODE'		, text:'CUSTOM_CODE'	,type : 'string' },
			{ name: 'OUT_DIV_CODE'		, text:'OUT_DIV_CODE'	,type : 'string' },
			{ name: 'ORDER_P'			, text:'ORDER_P'		,type : 'string' },
			{ name: 'ORDER_O'			, text:'ORDER_O'		,type : 'string' },
			{ name: 'TAX_TYPE'			, text:'TAX_TYPE'		,type : 'string' },
			{ name: 'WH_CODE'			, text:'WH_CODE'		,type : 'string' },
			{ name: 'MONEY_UNIT'		, text:'MONEY_UNIT'		,type : 'string' },
			{ name: 'EXCHG_RATE_O'		, text:'EXCHG_RATE_O'	,type : 'string' },
			{ name: 'ACCOUNT_YNC'		, text:'<t:message code="system.label.sales.salessubject" default="매출대상"/>'			,type : 'string', comboType: 'AU', comboCode: 'S014' },
			{ name: 'DISCOUNT_RATE'		, text:'DISCOUNT_RATE'	,type : 'string' },
			{ name: 'ORDER_PRSN'		, text:'ORDER_PRSN'		,type : 'string' },
			{ name: 'DVRY_CUST_CD'		, text:'DVRY_CUST_CD'	,type : 'string' },
			{ name: 'SALE_CUST_CD'		, text:'SALE_CUST_CD'	,type : 'string' },
			{ name: 'SALE_CUST_NM'		, text:'<t:message code="system.label.sales.salesplace" default="매출처"/>'			,type : 'string' },
			{ name: 'BILL_TYPE'			, text:'BILL_TYPE'		,type : 'string' },
			{ name: 'ORDER_TYPE'		, text:'ORDER_TYPE'		,type : 'string' },
			{ name: 'PRICE_YN'			, text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'			,type : 'string', comboType: 'AU', comboCode: 'S003' },
			{ name: 'PO_SEQ'			, text:'PO_SEQ'			,type : 'string' },
			{ name: 'CREDIT_YN'			, text:'CREDIT_YN'		,type : 'string' },
			{ name: 'WON_CALC_BAS'		, text:'WON_CALC_BAS'	,type : 'string' },
			{ name: 'TAX_INOUT'			, text:'TAX_INOUT'		,type : 'string' },
			{ name: 'AGENT_TYPE'		, text:'AGENT_TYPE'		,type : 'string' },
			{ name: 'STOCK_CARE_YN'		, text:'STOCK_CARE_YN'	,type : 'string' },
			{ name: 'STOCK_UNIT'		, text:'STOCK_UNIT'		,type : 'string' },
			{ name: 'DVRY_CUST_NAME'	, text:'<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			,type : 'string' },
			{ name: 'RETURN_Q_YN'		, text:'RETURN_Q_YN'	,type : 'string' },
			{ name: 'DIV_CODE'			, text:'DIV_CODE'		,type : 'string' },
			{ name: 'ORDER_TAX_O'		, text:'ORDER_TAX_O'	,type : 'string' },
			{ name: 'EXCESS_RATE'		, text:'EXCESS_RATE'	,type : 'string' },
			{ name: 'DEPT_CODE'			, text:'DEPT_CODE'		,type : 'string' },
			{ name: 'ITEM_ACCOUNT'		, text:'ITEM_ACCOUNT'	,type : 'string' },
			{ name: 'STOCK_Q'			, text:'STOCK_Q'		,type : 'string' },
			{ name: 'REMARK'			, text:'REMARK'			,type : 'string' },
			{ name: 'PRICE_TYPE'		, text:'PRICE_TYPE'		,type : 'string' },
			{ name: 'ORDER_FOR_WGT_P'	, text:'ORDER_FOR_WGT_P',type : 'string' },
			{ name: 'ORDER_FOR_VOL_P'	, text:'ORDER_FOR_VOL_P',type : 'string' },
			{ name: 'ORDER_WGT_P'		, text:'ORDER_WGT_P'	,type : 'string' },
			{ name: 'ORDER_VOL_P'		, text:'ORDER_VOL_P'	,type : 'string' },
			{ name: 'WGT_UNIT'			, text:'WGT_UNIT'		,type : 'string' },
			{ name: 'UNIT_WGT'			, text:'UNIT_WGT'		,type : 'string' },
			{ name: 'VOL_UNIT'			, text:'VOL_UNIT'		,type : 'string' },
			{ name: 'UNIT_VOL'			, text:'UNIT_VOL'		,type : 'string' },
			{ name: 'LOT_YN'			, text:'LOT_YN'			,type : 'string' },
			{ name: 'NATION_INOUT'		, text:'NATION_INOUT'	,type : 'string' },
			{ name: 'REMARK_INTER'		, text:'<t:message code="system.label.sales.remarkinter" default="내부기록사항"/>'	,type : 'string' },
			//20210108 추가: API연동을 위해 추가
			{ name: 'BUNDLE_NO'			, text:'BUNDLE_NO'		, type: 'string'},
			{ name: 'NUMBER'			, text:'NUMBER'			, type: 'string'},
			{ name: 'CARD_CUSTOM_CODE'	, text: '카드사'			, type: 'string', comboType: 'AU', comboCode: 'A028'}	//20210223 추가
		]
	});
	//수주(오퍼) 참조 스토어 정의
	var salesOrderStore = Unilite.createStore('s_str104ukrv_wmsalesOrderStore', {
		model	: 's_str104ukrv_wmsalesOrderModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_str104ukrv_wmService.selectSalesOrderList'
			}
		},
		loadStoreRecords : function() {
			var param= salesOrderSearch.getValues();
			console.log( param );
			param.WH_CODE = panelResult.getValue('WH_CODE');
			param.WH_CELL_CODE = panelResult.getValue('WH_CELL_CODE');
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
								if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM']) // record = masterRecord	item = 참조 Record
									&& (record.data['ORDER_SEQ'] == item.data['SER_NO'])) {
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
	var salesOrderGrid = Unilite.createGrid('s_str104ukrv_wmsalesOrderGrid', {
		store	: salesOrderStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false, mode: 'MULTI' }),	//20200417: SIMPLE -> MULTI로 수정
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false
		},
		columns	: [
			{ dataIndex: 'CUSTOM_NAME'			, width: 120 },
			{ dataIndex: 'ORDER_NUM'			, width: 100 },
			{ dataIndex: 'SER_NO'				, width: 66 },
			{ dataIndex: 'SO_KIND'				, width: 66 },
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 80, hidden: true },
			{ dataIndex: 'ITEM_CODE'			, width: 120 },
			{ dataIndex: 'ITEM_NAME'			, width: 113 },
			{ dataIndex: 'SPEC'					, width: 113 },
			{ dataIndex: 'ORDER_UNIT'			, width: 66, align: 'center' },
			{ dataIndex: 'TRANS_RATE'			, width: 40 },
			{ dataIndex: 'DVRY_DATE'			, width: 80 },
			{ dataIndex: 'NOT_INOUT_Q'			, width: 80 },
			{ dataIndex: 'ORDER_Q'				, width: 80 },
			{ dataIndex: 'ISSUE_REQ_Q'			, width: 100 },
			{ dataIndex: 'R_LOT_NO'				, width: 120 },
			{ dataIndex: 'ORDER_WGT_Q'			, width: 100, hidden: true },
			{ dataIndex: 'ORDER_VOL_Q'			, width: 100, hidden: true },
			{ dataIndex: 'PROJECT_NO'			, width: 86 },
			{ dataIndex: 'PO_NUM'				, width: 86 },
			{ dataIndex: 'PAY_METHODE1'			, width: 100 },
			{ dataIndex: 'LC_SER_NO'			, width: 100 },
			{ dataIndex: 'CUSTOM_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'OUT_DIV_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'ORDER_P'				, width: 66, hidden: true },
			{ dataIndex: 'ORDER_O'				, width: 66, hidden: true },
			{ dataIndex: 'TAX_TYPE'				, width: 66, hidden: true },
			{ dataIndex: 'WH_CODE'				, width: 66, hidden: true },
			{ dataIndex: 'MONEY_UNIT'			, width: 66, hidden: true },
			{ dataIndex: 'EXCHG_RATE_O'			, width: 66, hidden: true },
			{ dataIndex: 'ACCOUNT_YNC'			, width: 66 },
			{ dataIndex: 'DISCOUNT_RATE'		, width: 66, hidden: true },
			{ dataIndex: 'ORDER_PRSN'			, width: 86, hidden: true },
			{ dataIndex: 'DVRY_CUST_CD'			, width: 66, hidden: true },
			{ dataIndex: 'SALE_CUST_CD'			, width: 86, hidden: true },
			{ dataIndex: 'SALE_CUST_NM'			, width: 130},
			{ dataIndex: 'BILL_TYPE'			, width: 66, hidden: true },
			{ dataIndex: 'ORDER_TYPE'			, width: 66, hidden: true },
			{ dataIndex: 'PRICE_YN'				, width: 66 },
			{ dataIndex: 'PO_SEQ'				, width: 86, hidden: true },
			{ dataIndex: 'CREDIT_YN'			, width: 86, hidden: true },
			{ dataIndex: 'WON_CALC_BAS'			, width: 86, hidden: true },
			{ dataIndex: 'TAX_INOUT'			, width: 66, hidden: true },
			{ dataIndex: 'AGENT_TYPE'			, width: 86, hidden: true },
			{ dataIndex: 'STOCK_CARE_YN'		, width: 66, hidden: true },
			{ dataIndex: 'STOCK_UNIT'			, width: 66, hidden: true },
			{ dataIndex: 'DVRY_CUST_NAME'		, width: 113 },
			{ dataIndex: 'RETURN_Q_YN'			, width: 66, hidden: true },
			{ dataIndex: 'DIV_CODE'				, width: 66, hidden: true },
			{ dataIndex: 'ORDER_TAX_O'			, width: 66, hidden: true },
			{ dataIndex: 'EXCESS_RATE'			, width: 66, hidden: true },
			{ dataIndex: 'DEPT_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'ITEM_ACCOUNT'			, width: 66, hidden: true },
			{ dataIndex: 'STOCK_Q'				, width: 66, hidden: true },
			{ dataIndex: 'REMARK'				, width: 86, hidden: true },
			{ dataIndex: 'PRICE_TYPE'			, width: 66, hidden: true },
			{ dataIndex: 'ORDER_FOR_WGT_P'		, width: 66, hidden: true },
			{ dataIndex: 'ORDER_FOR_VOL_P'		, width: 66, hidden: true },
			{ dataIndex: 'ORDER_WGT_P'			, width: 66, hidden: true },
			{ dataIndex: 'ORDER_VOL_P'			, width: 66, hidden: true },
			{ dataIndex: 'WGT_UNIT'				, width: 66, hidden: true },
			{ dataIndex: 'UNIT_WGT'				, width: 66, hidden: true },
			{ dataIndex: 'VOL_UNIT'				, width: 66, hidden: true },
			{ dataIndex: 'UNIT_VOL'				, width: 66, hidden: true },
			{ dataIndex: 'LOT_YN'				, width: 66, hidden: true },
			{ dataIndex: 'NATION_INOUT'			, width: 66, hidden: true },
			{ dataIndex: 'REMARK_INTER'			, width: 110},
			{ dataIndex: 'CARD_CUSTOM_CODE'		, width: 110, hidden: true }	//20210223 추가
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			UniAppManager.app.fnMakeSof100tDataRef(records);
			this.deleteSelectedRow();
			detailStore.fnOrderAmtSum();
		}
	});
	//수주(오퍼) 참조 메인
	function opensalesOrderWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!refersalesOrderWindow) {
			refersalesOrderWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.soofferrefer" default="수주(오퍼)참조"/>',
				width	: 1000,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [salesOrderSearch, salesOrderGrid],
				tbar	: ['->', {
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						salesOrderStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '<t:message code="system.label.sales.issueapply" default="출고적용"/>',
					handler	: function() {
						salesOrderGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '<t:message code="system.label.sales.issueapplyclose" default="출고적용후 닫기"/>',
					handler	: function() {
						salesOrderGrid.returnData();
						refersalesOrderWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						if(detailStore.getCount() == 0){
							panelResult.setAllFieldsReadOnly(false);
						}
						refersalesOrderWindow.hide();
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
						salesOrderSearch.setValue('DIV_CODE'	,panelResult.getValue('DIV_CODE'));
						salesOrderSearch.setValue('MONEY_UNIT'	,panelResult.getValue('MONEY_UNIT'));
						salesOrderSearch.setValue('CUSTOM_CODE'	,panelResult.getValue('CUSTOM_CODE'));
						salesOrderSearch.setValue('CUSTOM_NAME'	,panelResult.getValue('CUSTOM_NAME'));
						salesOrderSearch.setValue('CREATE_LOC'	,panelResult.getValue('CREATE_LOC'));
						salesOrderSearch.setValue('DVRY_DATE_TO', panelResult.getValue('INOUT_DATE'));
						salesOrderSearch.setValue('DVRY_DATE_FR', UniDate.get('startOfMonth', panelResult.getValue('INOUT_DATE')));
//						salesOrderSearch.setValue('DVRY_DATE_FR', UniDate.get('startOfMonth', salesOrderSearch.getValue('DVRY_DATE_TO')));
						if(panelResult.getValue('MONEY_UNIT') != UserInfo.currency){
							salesOrderSearch.setValue('NATION_INOUT', '2');
						} else {
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



	/** main app
	 */
	Unilite.Main({
		id			: 's_str104ukrv_wmApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid
			]
		}],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset', 'newData'], true);
			panelResult.getField('INOUT_PRSN').focus();
			this.setDefault();
			UniAppManager.app.fnExchngRateO(true);
			Ext.getCmp('btnPrint').setDisabled(true);
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
			//20210114 추가
			panelResult.getField('ISSUE_BARCODE').focus();
			panelResult.onLoadSelectText('ISSUE_BARCODE');
		},
		onQueryButtonDown: function() {
			var returnNo = panelResult.getValue('INOUT_NUM');
			if(Ext.isEmpty(returnNo)) {
				openSearchInfoWindow()
			} else {
				//20190930 추가
				fnSetColumnFormat();
				isLoad = true;

				detailStore.loadStoreRecords();
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		//링크로 넘어오는 params 받는 부분
		processParams: function(params) {
			//this.uniOpt.appParams = params;
			if(params.PGM_ID == 's_srq100ukrv_yp' || params.PGM_ID == 'srq100ukrv') { //출하지시등록에서 링크 넘어올시
				var formPram = params.formPram;
				if(!panelResult.setAllFieldsReadOnly(true)){
					return false;
				}
				Ext.each(params.record, function(rec,i){
					if(i == 0){
						panelResult.setValue('CUSTOM_CODE'	, rec.get('CUSTOM_CODE'));
						panelResult.setValue('CUSTOM_NAME'	, rec.get('CUSTOM_NAME'));
						panelResult.setValue('DIV_CODE'		, formPram.DIV_CODE);
						panelResult.setValue('MONEY_UNIT'	, rec.get('MONEY_UNIT'));
						panelResult.setValue('CREATE_LOC'	, rec.get('REF_LOC'));
					}
					//출하지시등록에서 넘어오면 출고일, 수불담당자 수정가능하도록 변경
					panelResult.getField('INOUT_DATE').setReadOnly(false);
					panelResult.getField('INOUT_PRSN').setReadOnly(false);

					var dOutQ		= 0; var dIReqQ = 0; var dDoOutQ = 0; var dOrdQ = 0;
					dIReqQ			= rec.get('ISSUE_REQ_QTY');
					dOutQ			= rec.get('ISSUE_QTY');
					dOrdQ			= rec.get('ORDER_Q');
					dDoOutQ			= dIReqQ - dOutQ;
					var sUnitWgt	= 0; sOrderWgtQ = 0; sUnitVol = 0; sOrderVolQ = 0;
					sUnitWgt		= rec.get('UNIT_WGT');
					sOrderWgtQ		= dDoOutQ * sUnitWgt
					sUnitVol		= rec.get('UNIT_VOL')
					sOrderVolQ		= dDoOutQ * sUnitVol
					var orderUnitP	= 0;
					var orderUnitO	= 0;
					var inoutTaxAmt	= 0;
					if(rec.get('ACCOUNT_YNC') == "N"){  //미매출 대상인경우
						orderUnitP	= 0;
						orderUnitO	= 0;
						inoutTaxAmt	= 0;
					} else {
						orderUnitP	= rec.get('ISSUE_REQ_PRICE');
						orderUnitO	= rec.get('ISSUE_REQ_AMT');
						inoutTaxAmt	= rec.get('ISSUE_REQ_TAX_AMT');
					}
					var saleDivCode	= '';
					if(BsaCodeInfo.gsOptDivCode == "1"){
						saleDivCode	= rec.get('ISSUE_DIV_CODE');
					} else {
						saleDivCode	= rec.get('DIV_CODE');
					}
					var dvryDate	= rec.get('DVRY_DATE');
					var gubun		= 'FEFER';
					var nationInout	= '1';
					var sale_date	= panelResult.getValue('SALE_DATE');
					if(dDoOutQ > 0){		//미출고량이 있을시만 row 생성..
						var r = {
							INOUT_SEQ			: rec.get('ISSUE_REQ_SEQ'),
							INOUT_TYPE			: "2",
							INOUT_METH			: "1",
							INOUT_CODE_TYPE		: "4",
							CREATE_LOC			: rec.get('REF_LOC'),
							DIV_CODE			: UserInfo.divCode,
							INOUT_CODE			: rec.get('CUSTOM_CODE'),
							CUSTOM_NAME			: rec.get('CUSTOM_NAME'),
							INOUT_DATE			: UniDate.getDbDateStr(rec.get('ISSUE_REQ_DATE')),
							INOUT_TYPE_DETAIL	: rec.get('INOUT_TYPE_DETAIL'),
							REF_CODE2			: rec.get('REF_CODE2'),
							WH_CODE				: rec.get('WH_CODE'),
							WH_NAME				: rec.get('WH_CODE'),
							ITEM_CODE			: rec.get('ITEM_CODE'),
							ITEM_NAME			: rec.get('ITEM_NAME'),
							SPEC				: rec.get('SPEC'),
							ITEM_STATUS			: '1',
							ORDER_UNIT			: rec.get('ORDER_UNIT'),
							TRANS_RATE			: rec.get('TRANS_RATE'),
							ORDER_UNIT_Q		: dDoOutQ,
							ORIGIN_Q			: dDoOutQ,
							ORDER_NOT_Q			: dDoOutQ,
							ISSUE_NOT_Q			: '0',
							PRICE_TYPE			: rec.get('PRICE_TYPE'),
							WGT_UNIT			: rec.get('WGT_UNIT'),
							UNIT_WGT			: rec.get('UNIT_WGT'),
							VOL_UNIT			: rec.get('VOL_UNIT'),
							UNIT_VOL			: rec.get('UNIT_VOL'),
							INOUT_FOR_WGT_P		: rec.get('ISSUE_FOR_WGT_P'),
							INOUT_FOR_VOL_P		: rec.get('ISSUE_FOR_VOL_P'),
							INOUT_WGT_P			: rec.get('ISSUE_WGT_P'),
							INOUT_VOL_P			: rec.get('ISSUE_VOL_P'),
							INOUT_WGT_Q			: sOrderWgtQ,
							INOUT_VOL_Q			: sOrderVolQ,
							ORDER_UNIT_P		: orderUnitP,
							TAX_TYPE			: rec.get('TAX_TYPE'),
							DISCOUNT_RATE		: rec.get('DISCOUNT_RATE'),
							ACCOUNT_YNC			: rec.get('ACCOUNT_YNC'),
							SALE_CUSTOM_CODE	: rec.get('SALE_CUSTOM_CODE'),
							SALE_CUST_CD		: rec.get('SALE_CUSTOM_NAME'),
							DVRY_CUST_CD		: rec.get('DVRY_CUST_CD'),
							DVRY_CUST_NAME		: rec.get('DVRY_CUST_NAME'),
							ORDER_CUST_CD		: rec.get('ORDER_CUST_NM'),
							PLAN_NUM			: rec.get('PROJECT_NO'),
							ISSUE_REQ_NUM		: rec.get('ISSUE_REQ_NUM'),
							BASIS_NUM			: rec.get('PO_NUM'),
							BASIS_SEQ			: rec.get('PO_SEQ'),
							SALE_DIV_CODE		: saleDivCode,
							MONEY_UNIT			: rec.get('MONEY_UNIT'),
							EXCHG_RATE_O		: rec.get('EXCHANGE_RATE'),
							ISSUE_REQ_SEQ		: rec.get('ISSUE_REQ_SEQ'),
							ORDER_NUM			: rec.get('ORDER_NUM'),
							ORDER_SEQ			: rec.get('SER_NO'),
							ORDER_TYPE			: rec.get('ORDER_TYPE'),
							BILL_TYPE			: rec.get('BILL_TYPE'),
							STOCK_UNIT			: rec.get('STOCK_UNIT'),
							PRICE_YN			: rec.get('PRICE_YN'),
							SALE_TYPE			: rec.get('ORDER_TYPE'),
							SALE_PRSN			: rec.get('ISSUE_REQ_PRSN'),
							INOUT_PRSN			: panelResult.getValue('INOUT_PRSN'),
							ACCOUNT_Q			: '0',
							SALE_C_YN			: 'N',
							CREDIT_YN			: CustomCodeInfo.gsCustCreditYn,
							WON_CALC_BAS		: CustomCodeInfo.gsUnderCalBase,
							TAX_INOUT			: rec.get('TAX_INOUT'),
							AGENT_TYPE			: CustomCodeInfo.gsAgentType,
							STOCK_CARE_YN		: rec.get('STOCK_CARE_YN'),
							LOT_NO				: rec.get('LOT_NO'),
							REMARK				: rec.get('REMARK'),
							SRC_ORDER_Q			: rec.get('ORDER_Q'),
							COMP_CODE			: UserInfo.compCode,
							TRANS_COST			: 0,
							ORDER_UNIT_O		: orderUnitO,
							INOUT_TAX_AMT		: inoutTaxAmt,
							ITEM_ACCOUNT		: rec.get('ITEM_ACCOUNT'),
							DELIVERY_DATE		: dvryDate,
							GUBUN				: gubun,
							NATION_INOUT		: nationInout,
							SALE_DATE			: sale_date
						}
						detailGrid.createRow(r, 'INOUT_SEQ');
						var record = detailGrid.getSelectedRecord();
						UniSales.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('DIV_CODE'), record.get('ITEM_STATUS'), record.get('ITEM_CODE'), record.get('WH_CODE'));
					}
				});
			//20210309 추가: 수주등록에서 넘어오는 로직 추가
			} else if(params.PGM_ID == 'sof100ukrv') {
				var formPram = params.formPram;
				panelResult.setValue('DIV_CODE'		, formPram.DIV_CODE);
				panelResult.setValue('CUSTOM_CODE'	, formPram.CUSTOM_CODE);
				panelResult.setValue('CUSTOM_NAME'	, formPram.CUSTOM_NAME);
				panelResult.setValue('MONEY_UNIT'	, formPram.MONEY_UNIT);
				fnSetColumnFormat();

				var param = {
					DIV_CODE	: formPram.DIV_CODE,
					MONEY_UNIT	: formPram.MONEY_UNIT,
					CUSTOM_CODE	: formPram.CUSTOM_CODE,
					CUSTOM_NAME	: formPram.CUSTOM_NAME,
					ORDER_NUM	: formPram.ORDER_NUM,
					USER_ID		: UserInfo.divCode
				}
				s_str104ukrv_wmService.selectSalesOrderList(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						if(!panelResult.setAllFieldsReadOnly(true)){
							return false;
						} else {
							var newDetailRecords = new Array();
							var whCellCode = '';
							var whCellName = '';
							var saleDivCode = '';
							var taxInout = '';
							var inoutSeq = 0;
							var sortSeq = 0;
							inoutSeq = detailStore.max('INOUT_SEQ');
							sortSeq = detailStore.max('SORT_SEQ');
							if(Ext.isEmpty(inoutSeq)){
								inoutSeq = 1;
							} else {
								inoutSeq = inoutSeq + 1;
							}
							if(Ext.isEmpty(sortSeq)){
								sortSeq = 1;
							} else {
								sortSeq = sortSeq + 1;
							}

							Ext.each(provider, function(record, i){
								if(i == 0){
									inoutSeq = inoutSeq;
									sortSeq = sortSeq;
								} else {
									inoutSeq += 1;
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
								var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value');	//출고유형콤보value중 첫번째 value
								var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail);						//출고유형value의 ref2
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
								} else {
									saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
								}
								var divCode = '';
								if(BsaCodeInfo.gsOptDivCode == "1"){
									saleDivCode = panelResult.getValue('DIV_CODE');
								} else {
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
									'INOUT_SEQ'			: inoutSeq,
									'SORT_SEQ'			: sortSeq,
									'INOUT_NUM'			: inoutNum,
									'INOUT_CODE'		: inoutCode,
									'CUSTOM_NAME'		: customName,
									'INOUT_TYPE_DETAIL'	: inoutTypeDetail,
									'REF_CODE2'			: refCode2,
									'CREATE_LOC'		: createLoc,
									'MONEY_UNIT'		: moneyUnit,
									'EXCHG_RATE_O'		: exchgRateO,
									'INOUT_PRSN'		: inoutPrsn,
									'SALE_CUST_CD'		: saleCustCD,
									'SALE_CUSTOM_CODE'	: saleCustomCd,
									'SALE_DIV_CODE'		: saleDivCode,
									'DIV_CODE'			: divCode,
									'SALE_TYPE'			: saleType,
									'TAX_INOUT'			: taxInout,
									'DEPT_CODE'			: deptCode,
									'WH_CODE'			: whCode,
									'WH_CELL_CODE'		: whCellCode,
									'SALE_PRSN'			: salePrsn,
									'NATION_INOUT'		: nationInout,
									'INOUT_DATE'		: inoutDate,
									'SALE_DATE'			: saleDate
								};
								newDetailRecords[i] = detailStore.model.create( r );
								newDetailRecords[i].set('INOUT_TYPE'		, "2");
								newDetailRecords[i].set('INOUT_METH'		, "1");
								newDetailRecords[i].set('INOUT_CODE_TYPE'	, "4");
								newDetailRecords[i].set('CREATE_LOC'		, panelResult.getValue('CREATE_LOC'));
								newDetailRecords[i].set('DIV_CODE'			, panelResult.getValue('DIV_CODE'));
								newDetailRecords[i].set('INOUT_CODE'		, record.CUSTOM_CODE);
								newDetailRecords[i].set('CUSTOM_NAME'		, record.CUSTOM_NAME);
								newDetailRecords[i].set('INOUT_DATE'		, panelResult.getValue('INOUT_DATE'));
								newDetailRecords[i].set('INOUT_NUM'			, panelResult.getValue('INOUT_NUM'));

								panelResult.setValue('NATION_INOUT', record.NATION_INOUT);
								newDetailRecords[i].set('NATION_INOUT'		, panelResult.getValue('NATION_INOUT'));
								newDetailRecords[i].set('EXCHG_RATE_O'		, record.EXCHG_RATE_O);

								var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
								var sRefCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2

								if(record.INOUT_TYPE_DETAIL > ""){
									newDetailRecords[i].set('INOUT_TYPE_DETAIL'	, record.INOUT_TYPE_DETAIL);
								} else {
									newDetailRecords[i].set('INOUT_TYPE_DETAIL'	, inoutTypeDetail);
								}

								newDetailRecords[i].set('REF_CODE2'			, sRefCode2);
								if(!Ext.isEmpty(panelResult.getValue('WH_CODE'))){
									newDetailRecords[i].set('WH_CODE'		, panelResult.getValue('WH_CODE'));
								} else {
									newDetailRecords[i].set('WH_CODE'		, record.WH_CODE);
								}
								if(!Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))){
									newDetailRecords[i].set('WH_CELL_CODE'	, panelResult.getValue('WH_CELL_CODE'));
								} else {
									var param = {
										DIV_CODE: panelResult.getValue('DIV_CODE'),
										WH_CODE	: newDetailRecords[i].get('WH_CODE')
									}
									matrlCommonService.getWhCellCode(param, function(provider, response) {
										if(!Ext.isEmpty(provider)) {
											newDetailRecords[i].set('WH_CELL_CODE', provider);
										}
									})
								}
								newDetailRecords[i].set('ITEM_CODE'			, record.ITEM_CODE);
								newDetailRecords[i].set('ITEM_NAME'			, record.ITEM_NAME);
								newDetailRecords[i].set('SPEC'				, record.SPEC);
								newDetailRecords[i].set('ITEM_STATUS'		, "1");
								newDetailRecords[i].set('ORDER_UNIT'		, record.ORDER_UNIT);
								newDetailRecords[i].set('TRANS_RATE'		, record.TRANS_RATE);
								newDetailRecords[i].set('ORDER_UNIT_Q'		, record.R_ALLOC_Q);
								newDetailRecords[i].set('ORIGIN_Q'			, record.R_ALLOC_Q);
								newDetailRecords[i].set('ORDER_NOT_Q'		, record.R_ALLOC_Q);
								newDetailRecords[i].set('ISSUE_NOT_Q'		, "0");
								newDetailRecords[i].set('TAX_TYPE'			, record.TAX_TYPE);
								newDetailRecords[i].set('DISCOUNT_RATE'		, record.DISCOUNT_RATE);
								newDetailRecords[i].set('ACCOUNT_YNC'		, record.ACCOUNT_YNC);
								newDetailRecords[i].set('SALE_CUSTOM_CODE'	, record.SALE_CUST_CD);
								newDetailRecords[i].set('SALE_CUST_CD'		, record.SALE_CUST_NM);
								newDetailRecords[i].set('DVRY_CUST_CD'		, record.DVRY_CUST_CD);
								newDetailRecords[i].set('DVRY_CUST_NAME'	, record.DVRY_CUST_NAME);
								newDetailRecords[i].set('ORDER_CUST_CD'		, record.CUSTOM_NAME);
								newDetailRecords[i].set('PLAN_NUM'			, record.PROJECT_NO);
								newDetailRecords[i].set('BASIS_NUM'			, record.PO_NUM);
								newDetailRecords[i].set('BASIS_SEQ'			, record.PO_SEQ);
				
								if(BsaCodeInfo.gsOptDivCode == "1"){
									newDetailRecords[i].set('SALE_DIV_CODE'	, record.OUT_DIV_CODE);
								} else {
									newDetailRecords[i].set('SALE_DIV_CODE'	, record.DIV_CODE);
								}
				
								newDetailRecords[i].set('MONEY_UNIT'		, record.MONEY_UNIT);
								newDetailRecords[i].set('EXCHG_RATE_O'		, panelResult.getValue('EXCHG_RATE_O'));
								newDetailRecords[i].set('ORDER_NUM'			, record.ORDER_NUM);
								newDetailRecords[i].set('ORDER_SEQ'			, record.SER_NO);
								newDetailRecords[i].set('ORDER_TYPE'		, record.ORDER_TYPE);
								newDetailRecords[i].set('BILL_TYPE'			, record.BILL_TYPE);
								newDetailRecords[i].set('CARD_CUSTOM_CODE'	, record.CARD_CUSTOM_CODE);
								newDetailRecords[i].set('STOCK_UNIT'		, record.STOCK_UNIT);
								newDetailRecords[i].set('PRICE_YN'			, record.PRICE_YN);
								if(panelResult.getValue('CREATE_LOC') == "5"){
									newDetailRecords[i].set('SALE_TYPE'		, '60');
								} else {
									newDetailRecords[i].set('SALE_TYPE'		, record.ORDER_TYPE);
								}
								newDetailRecords[i].set('SALE_PRSN'			, record.ORDER_PRSN);
								newDetailRecords[i].set('INOUT_PRSN'		, panelResult.getValue('INOUT_PRSN'));
								newDetailRecords[i].set('ACCOUNT_Q'			, "0");
								newDetailRecords[i].set('SALE_C_YN'			, "N");
								newDetailRecords[i].set('CREDIT_YN'			, CustomCodeInfo.gsCustCreditYn);
								newDetailRecords[i].set('WON_CALC_BAS'		, CustomCodeInfo.gsUnderCalBase);
								newDetailRecords[i].set('TAX_INOUT'			, record.TAX_INOUT);
								newDetailRecords[i].set('AGENT_TYPE'		, record.ITEM_CODE);
								newDetailRecords[i].set('AGENT_TYPE'		, record.AGENT_TYPE);
								newDetailRecords[i].set('DEPT_CODE'			, record.DEPT_CODE);
								newDetailRecords[i].set('STOCK_CARE_YN'		, record.STOCK_CARE_YN);
								newDetailRecords[i].set('UPDATE_DB_USER'	, record.USER_ID);
								newDetailRecords[i].set('RETURN_Q_YN'		, record.RETURN_Q_YN);
								newDetailRecords[i].set('SRC_ORDER_Q'		, record.ORDER_Q);
								newDetailRecords[i].set('EXCESS_RATE'		, record.EXCESS_RATE);
				
								if(newDetailRecords[i].get('ACCOUNT_YNC') == "N"){
									newDetailRecords[i].set('ORDER_UNIT_P'	, 0);
								} else {
									newDetailRecords[i].set('ORDER_UNIT_P'	, record.R_ORDER_P);
								}
				
								if(record.ORDER_Q != record.R_ALLOC_Q){
									UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "Q")
								}
				
								if(record.ACCOUNT_YNC == "N"){
									newDetailRecords[i].set('ORDER_UNIT_O'	, 0);
									newDetailRecords[i].set('INOUT_TAX_AMT'	, 0);
								} else {
									newDetailRecords[i].set('ORDER_UNIT_O'	, record.R_ORDER_O);
									newDetailRecords[i].set('INOUT_TAX_AMT'	, record.R_ORDER_TAX_O);
								}
				
								newDetailRecords[i].set('PRICE_TYPE'		, record.PRICE_TYPE);
								newDetailRecords[i].set('INOUT_FOR_WGT_P'	, record.ORDER_FOR_WGT_P);
								newDetailRecords[i].set('INOUT_FOR_VOL_P'	, record.ORDER_FOR_VOL_P);
								newDetailRecords[i].set('INOUT_WGT_P'		, record.ORDER_WGT_P);
								newDetailRecords[i].set('INOUT_VOL_P'		, record.ORDER_VOL_P);
								newDetailRecords[i].set('WGT_UNIT'			, record.WGT_UNIT);
								newDetailRecords[i].set('UNIT_WGT'			, record.UNIT_WGT);
								newDetailRecords[i].set('VOL_UNIT'			, record.VOL_UNIT);
								newDetailRecords[i].set('UNIT_VOL'			, record.UNIT_VOL);
				
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
								newDetailRecords[i].set('REMARK'			, record.REMARK);
								newDetailRecords[i].set('PAY_METHODE1'		, record.PAY_METHODE1);
								newDetailRecords[i].set('LC_SER_NO'			, record.LC_SER_NO);
								newDetailRecords[i].set('TRANS_COST'		, "0");
								newDetailRecords[i].set('ITEM_ACCOUNT'		, record.ITEM_ACCOUNT);
								newDetailRecords[i].set('GUBUN'				, "FEFER");
				
								var lRate = newDetailRecords[i].get('TRANS_RATE');
								if(lRate == 0){
									lRate = 1;
								}
								newDetailRecords[i].set('STOCK_Q'		, record.STOCK_Q);
								newDetailRecords[i].set('ORDER_STOCK_Q'	, record.STOCK_Q / lRate);
								newDetailRecords[i].set('LOT_YN'		, record.LOT_YN);
								newDetailRecords[i].set('REMARK_INTER'	, record.REMARK_INTER);
								newDetailRecords[i].set('LOT_NO'		, record.R_LOT_NO);
								UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "P");
								//20210108 추가: API연동을 위해 추가
								newDetailRecords[i].set('BUNDLE_NO'		, record.BUNDLE_NO);
								newDetailRecords[i].set('NUMBER'		, record.NUMBER);
								if(!Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))){
									newDetailRecords[i].set('WH_CELL_CODE'	, panelResult.getValue('WH_CELL_CODE'));
								} else {
									var param = {
										DIV_CODE: panelResult.getValue('DIV_CODE'),
										WH_CODE	: newDetailRecords[i].get('WH_CODE')
									}
									matrlCommonService.getWhCellCode(param, function(provider, response) {
										if(!Ext.isEmpty(provider)) {
											newDetailRecords[i].set('WH_CELL_CODE', provider);
										}
									})
								}
								UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "P");
								UniSales.fnStockQ(newDetailRecords[i], UniAppManager.app.cbStockQ, UserInfo.compCode, newDetailRecords[i].get('DIV_CODE'), newDetailRecords[i].get('ITEM_STATUS'), newDetailRecords[i].get('ITEM_CODE'), newDetailRecords[i].get('WH_CODE'));
							});
							detailStore.loadData(newDetailRecords, true);
							panelResult.setAllFieldsReadOnly(true);
						}
					}
				})
			};
			panelResult.getField('INOUT_DATE').setReadOnly(false);
			panelResult.getField('SALE_DATE').setReadOnly(false);
			panelResult.getField('INOUT_PRSN').setReadOnly(false);
		},
		onNewDataButtonDown: function() {
//			if(!this.checkForNewDetail()) return false;
			//20210415 추가: 행 추가 시에는 영업담당 정보 필수로 체크
			if(Ext.isEmpty(panelResult.getValue('ORDER_PRSN'))) {
				Unilite.messageBox('영업담당(은)는 필수입력 입니다.');
				return false;
			} else if(!panelResult.setAllFieldsReadOnly(true)){
				return false;
			} else {
				var inoutSeq = detailStore.max('INOUT_SEQ');
				if(!inoutSeq) inoutSeq = 1;
				 else  inoutSeq += 1;

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
				} else {
					saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
				}

				var divCode = '';
				if(BsaCodeInfo.gsOptDivCode == "1"){
					saleDivCode = panelResult.getValue('DIV_CODE');
				} else {
					saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
				}

				var saleType = Ext.data.StoreManager.lookup('CBS_AU_S002').getAt(0).get('value');		//판매유형콤보value중 첫번째 value
				var taxInout = Ext.isEmpty(CustomCodeInfo.gsTaxInout) ? '1':CustomCodeInfo.gsTaxInout;	//20210414 수정: panel에 거래처 set되지 않았을 때는 기본값 '1'로 설정

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
				var salePrsn = Ext.isEmpty(CustomCodeInfo.gsbusiPrsn) ? panelResult.getValue('ORDER_PRSN'): CustomCodeInfo.gsbusiPrsn;

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
						SALE_PRSN			: salePrsn,
						NATION_INOUT		: nationInout,
						INOUT_DATE			: inoutDate,
						SALE_DATE			: saleDate
				};
				panelResult.setAllFieldsReadOnly(true);
//				var createRow = detailGrid.createRow(r, null, detailGrid.getStore().getCount() - 1);
//				var createRow = detailGrid.createRow(r);
//				cbStore.loadStoreRecords(whCode);
				detailGrid.createRow(r);

//				var param = {
//					"DIV_CODE"	: panelResult.getValue('DIV_CODE'),
//					"DEPT_CODE"	: panelResult.getValue('DEPT_CODE')
//				};
//				s_str104ukrv_wmService.deptWhcode(param, function(provider, response){
//					if(!Ext.isEmpty(provider)){
//						var whCode = provider['WH_CODE'];
//						 createRow.set('WH_CODE', whCode);
//					} else {
//						var whCode = '';
//					}
//				});
			}
		},
		onResetButtonDown: function() {
			//20201230 추가: 창고변경 시, 창고에 설정되어 있는 기본창고cell 가져오는 로직 추가
			gsQueryFlag = false;
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(Ext.isEmpty(CustomCodeInfo.gsbusiPrsn) && BsaCodeInfo.gsInoutAutoYN == 'Y' && gsRefYn == 'N'){
//				if(confirm(Msg.sMS507 + '(' + panelResult.getValue('CUSTOM_NAME') + ')' + Msg.sMS377 + '\n' + Msg.sMS357)){
					detailStore.saveStore();
//				} else {
//					return false;
//				}
			} else {
				detailStore.saveStore();
			}

		},
		onDeleteDataButtonDown: function() {
			if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
				Unilite.messageBox(Msg.sMS042); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
				return false;
			}
			var selRow = detailGrid.getSelectedRecord();
			if(selRow) {
				if(selRow.phantom === true) {
					detailGrid.deleteSelectedRow();
				}else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					if(BsaCodeInfo.gsInoutAutoYN == "N" && selRow.get('ACCOUNT_Q') > 0) {//동시매출발생이 아닌 경우,매출존재체크 제외
						Unilite.messageBox(Msg.sMS335);	//매출이 진행된 건은 수정/삭제할 수 없습니다.
						return false;
					}
					if(selRow.get('SALE_C_YN') == "Y"){
						Unilite.messageBox(Msg.sMS214);	//계산서가 마감된 건은 수정/삭제가 불가능합니다.
						return false;
					}
					detailGrid.deleteSelectedRow();
				}
				detailStore.fnOrderAmtSum();
			}
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else {									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
							Unilite.messageBox(Msg.sMS042); //마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
							return false;
						}
						Ext.each(records, function(record,i) {
							if(BsaCodeInfo.gsInoutAutoYN == "N" && record.get('ACCOUNT_Q') > 0) {//동시매출발생이 아닌 경우,매출존재체크 제외
								Unilite.messageBox(Msg.sMS335);	//매출이 진행된 건은 수정/삭제할 수 없습니다.
								deletable = false;
								return false;
							}
							if(record.get('SALE_C_YN') == "Y"){
								Unilite.messageBox(Msg.sMS214);	//계산서가 마감된 건은 수정/삭제가 불가능합니다.
								deletable = false;
								return false;
							}
						});
						/*---------삭제전 로직 구현 끝-----------*/

						if(deletable){
							detailGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
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
			var as = Ext.getCmp('s_str104ukrv_wmAdvanceSerch');
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
			var fp = Ext.getCmp('s_str104ukrv_wmFileUploadPanel');
			if(detailStore.isDirty() || fp.isDirty()) {
				if(confirm(Msg.sMB061)) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
			//20200113 추가
			isLoad = false;
			/*영업담당 filter set*/
			gsMonClosing	= '';	//월마감 여부
			gsDayClosing	= '';	//일마감 여부
			//20200107 추가:gsOldMonClosing, gsOldDayClosing, gsOldInoutDate
			gsOldMonClosing	= '';	//월마감 여부(기존 데이터)
			gsOldDayClosing	= '';	//일마감 여부(기존 데이터)
			gsOldInoutDate	= new Date();

			var field		= panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			var inoutPrsn;
			//20191104 - 주석
//			if(!Ext.isEmpty(BsaCodeInfo.inoutPrsn[0].refCode10)){
//			if(!Ext.isEmpty(BsaCodeInfo.inoutPrsn[0].refCode10)){
			inoutPrsn = UniAppManager.app.fnGetInoutPrsnUserId(UserInfo.userID);		//로그인 아이디에 따른 영업담당자 set
//			}
			if(Ext.isEmpty(panelResult.getValue('INOUT_PRSN')) && Ext.isEmpty(inoutPrsn)){
				inoutPrsn = UniAppManager.app.fnGetInoutPrsnDivCode(UserInfo.divCode);		//사업장의 첫번째 영업담당자 set
			}
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('INOUT_PRSN'	, inoutPrsn); ////사업장에 따른 수불담당자 불러와야함
			//20210415 추가: 초기화 시, 영업담당자 set
			var inoutPrsns = Ext.data.StoreManager.lookup('CBS_AU_B024').data.items;
			Ext.each(inoutPrsns, function(inoutPrsn, i) {
				if(inoutPrsn.get('value') == inoutPrsn) {
					panelResult.setValue('ORDER_PRSN', inoutPrsn.get('refCode6'));
				}
			})

			panelResult.setValue('INOUT_DATE'	, new Date());
			//20200108 공통코드(S033 - 출고등록시 자동매출생성/삭제여부)에 따라 매출일 필드 control
			panelResult.setValue('SALE_DATE', new Date());
			if(BsaCodeInfo.gsAutoSalesYN == '2') {
				panelResult.getField('SALE_DATE').setConfig('hidden'	, true);
				panelResult.getField('SALE_DATE').setConfig('allowBlank', true);
			} else {
				panelResult.getField('SALE_DATE').setConfig('hidden'	, false);
				panelResult.getField('SALE_DATE').setConfig('allowBlank', false);
				panelResult.down('#component1').setConfig('hidden'		, true);
			}
			panelResult.setValue('CREATE_LOC'	, '1');
//			panelResult.setValue('MONEY_UNIT'	, BsaCodeInfo.gsMoneyUnit);
			panelResult.setValue('DEPT_CODE'	, UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME'	, UserInfo.deptName);
			panelResult.setValue('EXCHG_RATE_O'	, '1');
			panelResult.setValue('MONEY_UNIT'	, UserInfo.currency);
			panelResult.setValue('NATION_INOUT'	, '1');
//			panelResult.setValue('REMAIN_CREDIT', UniSales.fnGetCustCredit(UserInfo.compCode, detailForm.getValue('DIV_CODE'), detailForm.getValue("CUSTOM_CODE"), detailForm.getValue('ORDER_DATE'), UserInfo.currency));

			panelResult.setValue('TOT_SALE_TAXI'	, 0);	//과세초액
			panelResult.setValue('TOT_TAXI'			, 0);	//세액합계(2)
			panelResult.setValue('TOT_QTY'			, 0);	//수량총계
			panelResult.setValue('TOT_SALENO_TAXI'	, 0);	//면세총액(3)
			panelResult.setValue('TOTAL_AMT'		, 0);	//출고총액[(1)+(2)+(3)]
			panelResult.setValue('REM_CREDIT'		, 0);	//여신액

			if(BsaCodeInfo.gsAutoType == "Y"){
				panelResult.getForm().findField('INOUT_NUM').setReadOnly(true);
			} else {
				panelResult.getForm().findField('INOUT_NUM').setReadOnly(false);
			}
			/*	'사업장 권한 설정	////
				If gsAuParam(0) <> "N" Then
					txtDivCode.disabled = True
					btnDivCode.disabled = True
				End If
			 */
			panelResult.getField('TOT_SALE_TAXI').setReadOnly(true);
			panelResult.getField('TOT_TAXI').setReadOnly(true);
			panelResult.getField('TOT_QTY').setReadOnly(true);
			panelResult.getField('TOT_SALENO_TAXI').setReadOnly(true);
			panelResult.getField('TOTAL_AMT').setReadOnly(true);

			//20210602 추가
			panelResult.setValue('WH_CODE'		, BsaCodeInfo.gsDefaultWhCode);
			panelResult.setValue('WH_CELL_CODE'	, BsaCodeInfo.gsDefaultWhCellCode);

			gsRefYn = 'N'

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();

			UniAppManager.setToolbarButtons('save', false);
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
				Unilite.messageBox('<t:message code="unilite.msg.sMSR213" default="거래처"/>:<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			//마스터 데이타 수정 못 하도록 설정
			return panelResult.setAllFieldsReadOnly(true);
		},
		fnOrderAmtCal: function(rtnRecord, sType, fieldName, nValue, taxType, taxInout) {		//20210414 수정: 과세포함여부 변경에 따른 계산로직 추가
			var dTransRate		= fieldName=='TRANS_RATE'	? nValue : Unilite.nvl(rtnRecord.get('TRANS_RATE'),1);
			var dOrderQ			= fieldName=='ORDER_UNIT_Q'	? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_Q'),0);
			var dIssueReqWgtQ	= fieldName=='INOUT_WGT_Q'	? nValue : Unilite.nvl(rtnRecord.get('INOUT_WGT_Q'),0);
			var dIssueReqVolQ	= fieldName=='INOUT_VOL_Q'	? nValue : Unilite.nvl(rtnRecord.get('INOUT_VOL_Q'),0);
			var dOrderP			= fieldName=='ORDER_UNIT_P'	? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_P'),0);
			var saleBasisP		= fieldName=='SALE_BASIS_P'	? nValue : Unilite.nvl(rtnRecord.get('SALE_BASIS_P'),0);
			var dOrderWgtForP	= fieldName=='INOUT_FOR_WGT_P'? nValue : Unilite.nvl(rtnRecord.get('INOUT_FOR_WGT_P'),0);
			var dOrderVolForP	= fieldName=='INOUT_FOR_VOL_P'? nValue : Unilite.nvl(rtnRecord.get('INOUT_FOR_VOL_P'),0);
			var dOrderO			= fieldName=='ORDER_UNIT_O'	? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_O'),0);
			var dDcRate			= fieldName=='DISCOUNT_RATE'	? nValue : Unilite.nvl((100 - rtnRecord.get('DISCOUNT_RATE')),0);
			var dExchgRate		= fieldName=='EXCHG_RATE_O'	? nValue : Unilite.nvl(rtnRecord.get('EXCHG_RATE_O'),0);
			var dPriceType		= Ext.isEmpty(rtnRecord.get('PRICE_TYPE')) ? 'A' : rtnRecord.get('PRICE_TYPE');//단가구분
			var dOrderWgtP		= 0;
			var dOrderVolP		= 0;
			var dOrderForO		= 0;
			var dOrderForP		= 0;
			//20200611 추가: 자사금액 계산시, 'JPY' 관련로직 추가
			var moneyUnit		= rtnRecord.get('MONEY_UNIT');

			if(sType == "P" || sType == "Q"){
				//20200611 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
				dOrderWgtP	= UniSales.fnExchangeApply(moneyUnit, dOrderWgtForP	* dExchgRate);
				dOrderVolP	= UniSales.fnExchangeApply(moneyUnit, dOrderVolForP	* dExchgRate);

				if(dPriceType == "A"){
					dOrderForO = dOrderQ * dOrderP
					dOrderO	= dOrderQ * dOrderP
				}else if(dPriceType == "B"){
					dOrderForO = dIssueReqWgtQ * dOrderWgtForP
					dOrderO	= dIssueReqWgtQ * dOrderWgtP
				}else if(dPriceType == "C"){
					dOrderForO = dIssueReqVolQ * dOrderVolForP
						dOrderO	= dIssueReqVolQ * dOrderVolP
				} else {
					dOrderForO = dOrderQ * dOrderP
					dOrderO	= dOrderQ * dOrderP
				}
				rtnRecord.set('ORDER_UNIT_O'	, dOrderForO);
				rtnRecord.set('ORDER_UNIT_P'	, dOrderP);
				rtnRecord.set('INOUT_FOR_WGT_P'	, dOrderWgtForP);
				rtnRecord.set('INOUT_FOR_VOL_P'	, dOrderVolForP);
				rtnRecord.set('INOUT_WGT_P'		, dOrderWgtP);
				rtnRecord.set('INOUT_VOL_P'		, dOrderVolP);
				this.fnTaxCalculate(rtnRecord, dOrderO, null, taxInout);		//20210414 수정: 과세포함여부 변경에 따른 계산로직 추가
			}else if(sType == "O" && (dOrderQ > 0)){
				dOrderForP	= dOrderO / dOrderQ;
				//20200611 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
				dOrderP		= UniSales.fnExchangeApply(moneyUnit, (dOrderO / dOrderQ) * dExchgRate);

				if(dIssueReqWgtQ != 0){
					dOrderWgtForP	= (dOrderO / dIssueReqWgtQ);
					//20200611 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
					dOrderWgtP		= UniSales.fnExchangeApply(moneyUnit, (dOrderO / dIssueReqWgtQ) * dExchgRate);
				} else {
					dOrderWgtForP	= 0;
					dOrderWgtP		= 0;
				}

				if(dIssueReqVolQ != 0){
					dOrderVolForP	= (dOrderO / dIssueReqVolQ)
					//20200611 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
					dOrderVolP		= UniSales.fnExchangeApply(moneyUnit, (dOrderO / dIssueReqVolQ) * dExchgRate);
				} else {
					dOrderVolForP	= 0
					dOrderVolP		= 0
				}

				if(dPriceType == "A"){
					dOrderO = dOrderForP * dOrderQ;
				}else if(dPriceType == "B"){
					dOrderO = dOrderWgtForP * dIssueReqWgtQ;
				}else if(dPriceType == "C"){
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
				this.fnTaxCalculate(rtnRecord, dOrderO, taxType, taxInout);		//20210414 수정: 과세포함여부 변경에 따른 계산로직 추가
			}else if(sType == "C"){
				dOrderP = (dOrderP - (dOrderP * (dDcRate / 100)));
				rtnRecord.set('ORDER_UNIT_P', dOrderP);
				dOrderO = dOrderQ * dOrderP;
				rtnRecord.set('ORDER_UNIT_O', dOrderO);

				dOrderWgtForP = (dOrderO / dIssueReqWgtQ);
				dOrderVolForP = (dOrderO / dIssueReqVolQ);
				//20200611 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
				dOrderWgtP	= UniSales.fnExchangeApply(moneyUnit, (dOrderO / dIssueReqWgtQ) * dExchgRate);
				dOrderVolP	= UniSales.fnExchangeApply(moneyUnit, (dOrderO / dIssueReqVolQ) * dExchgRate);

				rtnRecord.set('INOUT_WGT_P', dOrderWgtP);
				rtnRecord.set('INOUT_VOL_P', dOrderVolP);
				rtnRecord.set('INOUT_FOR_WGT_P', dOrderWgtForP);
				rtnRecord.set('INOUT_FOR_VOL_P', dOrderVolForP);
				this.fnTaxCalculate(rtnRecord, dOrderO, null, taxInout);		//20210414 수정: 과세포함여부 변경에 따른 계산로직 추가
			}
		},
		fnTaxCalculate: function(rtnRecord, dOrderO, taxType, taxInout) {		//20210414 수정: 과세포함여부 변경에 따른 계산로직 추가
			var sTaxType		= Ext.isEmpty(taxType)? rtnRecord.get('TAX_TYPE') : taxType;
			var sWonCalBas		= CustomCodeInfo.gsUnderCalBase;
			var sTaxInoutType	= Ext.isEmpty(taxInout)? rtnRecord.get('TAX_INOUT') : taxInout;		//20210414 수정: 과세포함여부 변경에 따른 계산로직 추가
			var dVatRate		= parseInt(BsaCodeInfo.gsVatRate);
			var dAmountI		= dOrderO;
			var dOrderAmtO		= 0;
			var dTaxAmtO		= 0;

			//20190624 화폐단위 관련로직 추가
//			var numDigitOfPrice	= UniFormat.Price.length - UniFormat.Price.indexOf(".");	//기존로직
			if(panelResult.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
				var digit = UniFormat.FC.indexOf(".") == -1 ? UniFormat.FC.length : UniFormat.FC.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.FC.length - digit;
			} else {
				var digit = UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.Price.length - digit;
			}

			if(sTaxInoutType=="1") {	//별도
				dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderO, sWonCalBas, numDigitOfPrice);
				//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
				dTaxAmtO	= UniSales.fnAmtWonCalc(dOrderAmtO * dVatRate / 100, sWonCalBas, numDigitOfPrice);
			}else if(sTaxInoutType=="2") {	//포함
//				dAmountI	= UniSales.fnAmtWonCalc(dAmountI, sWonCalBas, numDigitOfPrice);
//				dOrderAmtO	= UniSales.fnAmtWonCalc(dAmountI / ( dVatRate + 100 ) * 100, sWonCalBas, numDigitOfPrice);
				//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
//				dTaxAmtO	= UniSales.fnAmtWonCalc(dAmountI - dOrderAmtO, sWonCalBas, numDigitOfPrice);
				//20191212 세액 구하는 로직 변경: 통일
				dTemp		= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, sWonCalBas, numDigitOfPrice);
				dTaxAmtO	= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, sWonCalBas, numDigitOfPrice);
				//20191002 세액 구하는 로직 추가
				dOrderAmtO	= UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), sWonCalBas, numDigitOfPrice);
			}
			if(sTaxType == "2" || sTaxType == "3") {		//20210303 수정: 영세일 때도 세액 0으로 계산하도록 수정 -  || sTaxType == "3" 추가
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderO, sWonCalBas, numDigitOfPrice ) ;
				dTaxAmtO = 0;
			}
			//20191212 강제로 소숫점 삭제(반올림)하는 부분 주석
			rtnRecord.set('ORDER_UNIT_O'	, dOrderAmtO/*.toFixed(0)*/);
			rtnRecord.set('INOUT_TAX_AMT'	, dTaxAmtO/*.toFixed(0)*/);
			rtnRecord.set('ORDER_AMT_SUM'	, (dOrderAmtO + dTaxAmtO)/*.toFixed(0)*/);
		},
		fnCheckNum: function(value, record, fieldName) {
			var r = true;
			if(record.get("PRICE_YN") == "1" || record.get("ACCOUNT_YNC")=="N") {
				r = true;
			} else if(record.get("PRICE_YN") == "2" ) {
				if(value < 0) {
					Unilite.messageBox(Msg.sMB076);
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
			var rtnRecord	= params.rtnRecord;
			var dStockQ		= Unilite.nvl(provider['STOCK_Q'], 0);
//			var dOrderQ		= Unilite.nvl(rtnRecord.get('ORDER_Q'), 0);
			var lTrnsRate	= 0;
			if(Ext.isEmpty(rtnRecord.get('TRANS_RATE')) || rtnRecord.get('TRANS_RATE') == 0){
				lTrnsRate = 1
			} else {
				lTrnsRate = rtnRecord.get('TRANS_RATE');
			}

			rtnRecord.set('STOCK_Q'			, dStockQ);
			rtnRecord.set('ORDER_STOCK_Q'	, dStockQ / lTrnsRate);
		},
		// UniSales.fnGetDivPriceInfo2 callback 함수
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
				}else if(params.priceType == 'B'){
					dSalePrice = dWgtPrice  * dUnitWgt;
					dVolPrice = (dUnitVol = 0) ? 0 : dSalePrice / dUnitVol;
				}else if(params.priceType == 'C'){
					dSalePrice = dVolPrice  * dUnitVol;
					dWgtPrice = (dUnitWgt = 0) ? 0 : dSalePrice / dUnitWgt;
				} else {
					dWgtPrice = (dUnitWgt = 0) ? 0 : dSalePrice / dUnitWgt;
					dVolPrice = (dUnitVol = 0) ? 0 : dSalePrice / dUnitVol;
				}
				if(Ext.isEmpty(provider['SALE_PRICE'])){
					params.rtnRecord.set('ORDER_UNIT_P', 0);
					params.rtnRecord.set('SALE_BASIS_P', 0);
				} else {
					params.rtnRecord.set('ORDER_UNIT_P', provider['SALE_PRICE']);
					params.rtnRecord.set('SALE_BASIS_P', provider['SALE_PRICE']);
				}
				params.rtnRecord.set('INOUT_WGT_P', dWgtPrice );
				params.rtnRecord.set('INOUT_VOL_P', dVolPrice );

				if(Ext.isEmpty(provider['SALE_TRANS_RATE'])){
					params.rtnRecord.set('TRANS_RATE', 1);
				} else {
					params.rtnRecord.set('TRANS_RATE', provider['SALE_TRANS_RATE']);
				}

				if(Ext.isEmpty(provider['DC_RATE'])){
					params.rtnRecord.set('DISCOUNT_RATE', 0);
				} else {
					params.rtnRecord.set('DISCOUNT_RATE', provider['DC_RATE']);
				}
				var exchangRate = panelResult.getValue('EXCHG_RATE_O');
				params.rtnRecord.set('INOUT_FOR_WGT_P'	, UniSales.fnExchangeApply2(params.rtnRecord.get('MONEY_UNIT'), dWgtPrice / exchangRate));	//20200611 수정: 외화금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply2 추가)
				params.rtnRecord.set('INOUT_FOR_VOL_P'	, UniSales.fnExchangeApply2(params.rtnRecord.get('MONEY_UNIT'), dVolPrice / exchangRate));	//20200611 수정: 외화금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply2 추가)
				params.rtnRecord.set('PRICE_YN'			, provider['PRICE_TYPE']);
			}
			if(params.rtnRecord.get('INOUT_FOR_VOL_P') > 0){
				UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P");
			}
		},
		fnGetSalePrsnDivCode: function(subCode){	//거래처의 영업담당자의 사업장 가져오기
			var fRecord ='';
			Ext.each(BsaCodeInfo.salePrsn, function(item, i) {
				if(item['codeNo'].toUpperCase() == subCode.toUpperCase()) {
					fRecord = item['refCode1'];
				}
			});
			return fRecord;
		},
		fnGetInoutPrsnUserId: function(subCode){ //로그인 아이디의 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.inoutPrsn, function(item, i) {
				if(item['refCode10'] == subCode) {
					fRecord = item['codeNo'];
//					return false;
				}
			});
			return fRecord;
		},
		fnGetInoutPrsnDivCode: function(subCode){	//사업장의 첫번째 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.inoutPrsn, function(item, i) {
				if(item['refCode1'].toUpperCase() == subCode.toUpperCase()) {
					fRecord = item['codeNo'];
//					return false;
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
		//20200107 신규 생성
		cbGetClosingInfo2: function(params){
//			if(gsOldMonClosing == '' && gsOldDayClosing == '' && gsMonClosing == '' &&gsDayClosing == '') {
//				gsMonClosing	= params.gsMonClosing
//				gsDayClosing	= params.gsDayClosing
//				gsOldInoutDate	= panelResult.getValue('INOUT_DATE');
//			} else {
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
//			}
			if(detailStore.data.length > 0) {
				var records = detailStore.data.items;
				Ext.each(records, function(record, index) {
					record.set('INOUT_DATE'	, panelResult.getValue('INOUT_DATE'));
					record.set('SALE_DATE'	, panelResult.getValue('INOUT_DATE'));
				});
			}
			//20200113 - 출고일 변경 시 환율 가져오는 로직 추가
			UniAppManager.app.fnExchngRateO();
		},
		fnExchngRateO:function(isIni, refProvider) {	//20210114 수정: refProvider 추가
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE')),
				"MONEY_UNIT": panelResult.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(!isLoad && provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(panelResult.getValue('MONEY_UNIT')) && panelResult.getValue('MONEY_UNIT') != UserInfo.currency){
						Unilite.messageBox('<t:message code="system.message.sales.datacheck008" default="환율정보가 없습니다."/>')
					}
					panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
					if(detailStore.data.length > 0) {
						var detailRecords = detailStore.data.items;
						Ext.each(detailRecords, function(detailRecord, index) {
							detailRecord.set('EXCHG_RATE_O', provider.BASE_EXCHG);
						});
					}
					//20210114 추가: refProvider 관련로직 추가
					if(!Ext.isEmpty(refProvider)) {
						fnMakeSrq100tDataRef_ByBarcode(refProvider);
						Ext.getBody().unmask();
						//첫번째 행 포커스
						detailGrid.getSelectionModel().select(0);
						panelResult.getField('ISSUE_BARCODE').focus();
					}
				}
			});
		},
		//출하지시 데이터 참조시
		fnMakeSrq100tDataRef: function(records) {
			//			if(!this.checkForNewDetail()) return false;
			/**
			 * Detail Grid Default 값 설정
			 */
				if(!panelResult.setAllFieldsReadOnly(true)){
						return false;
				} else {
					var newDetailRecords = new Array();
					var whCellCode = '';
					var whCellName = '';
					var saleDivCode = '';
					var taxInout = '';
					var inoutSeq = 0;
					var sortSeq = 0;
						  inoutSeq = detailStore.max('INOUT_SEQ');
						  sortSeq = detailStore.max('SORT_SEQ');
					if(Ext.isEmpty(inoutSeq)){
						inoutSeq = 1;
					} else {
						inoutSeq = inoutSeq + 1;
					}

					if(Ext.isEmpty(sortSeq)){
						sortSeq = 1;
					} else {
						sortSeq = sortSeq + 1;
					}

					Ext.each(records, function(record,i){
						if(i == 0){
							 inoutSeq = inoutSeq;
							 sortSeq = sortSeq;
						} else {
							 inoutSeq += 1;
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
						} else {
							saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
						}

						var divCode = '';
						if(BsaCodeInfo.gsOptDivCode == "1"){
							saleDivCode = panelResult.getValue('DIV_CODE');
						} else {
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
								'INOUT_SEQ': inoutSeq,
								'SORT_SEQ': sortSeq,
								'INOUT_NUM': inoutNum,
								'INOUT_CODE': inoutCode,
								'CUSTOM_NAME': customName,
								'INOUT_TYPE_DETAIL': inoutTypeDetail,
								'REF_CODE2': refCode2,
								'CREATE_LOC': createLoc,
								'MONEY_UNIT': moneyUnit,
								'EXCHG_RATE_O': exchgRateO,
								'INOUT_PRSN': inoutPrsn,
								'SALE_CUST_CD': saleCustCD,
								'SALE_CUSTOM_CODE': saleCustomCd,
								'SALE_DIV_CODE': saleDivCode,
								'DIV_CODE': divCode,
								'SALE_TYPE': saleType,
								'TAX_INOUT': taxInout,
								'DEPT_CODE': deptCode,
								'WH_CODE': whCode,
								'WH_CELL_CODE': whCellCode,
								'SALE_PRSN': salePrsn,
								'NATION_INOUT': nationInout,
								'INOUT_DATE': inoutDate,
								'SALE_DATE': saleDate
							};

						newDetailRecords[i] = detailStore.model.create( r );
						newDetailRecords[i].set('INOUT_TYPE'			, "2");
						newDetailRecords[i].set('INOUT_METH'		, "1");
						newDetailRecords[i].set('INOUT_CODE_TYPE'	, "4");
						newDetailRecords[i].set('CREATE_LOC'		, panelResult.getValue('CREATE_LOC'));
						newDetailRecords[i].set('DIV_CODE'			, panelResult.getValue('DIV_CODE'));
						newDetailRecords[i].set('INOUT_CODE'		, record.get('CUSTOM_CODE'));
						newDetailRecords[i].set('CUSTOM_NAME'		, record.get('CUSTOM_NAME'));
						newDetailRecords[i].set('INOUT_DATE'		, panelResult.getValue('INOUT_DATE'));
						newDetailRecords[i].set('INOUT_NUM'			, panelResult.getValue('INOUT_NUM'));
						newDetailRecords[i].set('REF_CODE2'			, record.get('REF_CODE2'));
						//20200327로직 변경
//						newDetailRecords[i].set('WH_CODE'			, record.get('WH_CODE'));
//						newDetailRecords[i].set('WH_NAME'			, record.get('WH_CODE'));
						if(!Ext.isEmpty(panelResult.getValue('WH_CODE'))){
							newDetailRecords[i].set('WH_CODE'		, panelResult.getValue('WH_CODE'));
							newDetailRecords[i].set('WH_NAME'		, panelResult.getValue('WH_NAME'));
						} else {
							newDetailRecords[i].set('WH_CODE'		, record.get('WH_CODE'));
							newDetailRecords[i].set('WH_NAME'		, record.get('WH_CODE'));
						}

						//20200327로직 변경
//						if(BsaCodeInfo.gsSumTypeCell == "Y"){
//							newDetailRecords[i].set('WH_CELL_CODE'	, record.get('WH_CELL_CODE'));
//							newDetailRecords[i].set('WH_CELL_NAME'	, record.get('WH_CELL_NAME'));
//						} else {
//							newDetailRecords[i].set('WH_CELL_CODE'	, "");
//							newDetailRecords[i].set('WH_CELL_NAME'	, "");
//						}
						if(BsaCodeInfo.gsSumTypeCell == "Y"){
							if(!Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))){
								newDetailRecords[i].set('WH_CELL_CODE'	, panelResult.getValue('WH_CELL_CODE'));
								newDetailRecords[i].set('WH_CELL_NAME'	, panelResult.getValue('WH_CELL_NAME'));
							} else {
								newDetailRecords[i].set('WH_CELL_CODE'	, record.get('WH_CELL_CODE'));
								newDetailRecords[i].set('WH_CELL_NAME'	, record.get('WH_CELL_NAME'));
							}
						} else {
							newDetailRecords[i].set('WH_CELL_CODE'	, '');
							newDetailRecords[i].set('WH_CELL_NAME'	, '');
						}

						newDetailRecords[i].set('ITEM_CODE'			, record.get('ITEM_CODE'));
						newDetailRecords[i].set('ITEM_NAME'			, record.get('ITEM_NAME'));
						newDetailRecords[i].set('SPEC'				, record.get('SPEC'));
						newDetailRecords[i].set('ITEM_STATUS'		, "1");
						newDetailRecords[i].set('ORDER_UNIT'		, record.get('ORDER_UNIT'));
						newDetailRecords[i].set('TRANS_RATE'		, record.get('TRANS_RATE'));
						newDetailRecords[i].set('ORDER_UNIT_Q'		, record.get('NOT_REQ_Q'));
						newDetailRecords[i].set('ORIGIN_Q'			, record.get('NOT_REQ_Q'));
						newDetailRecords[i].set('ORDER_NOT_Q'		, "0");
						newDetailRecords[i].set('ISSUE_NOT_Q'		, record.get('NOT_REQ_Q'));
						newDetailRecords[i].set('TAX_TYPE'			, record.get('TAX_TYPE'));
						newDetailRecords[i].set('DISCOUNT_RATE'		, record.get('DISCOUNT_RATE'));
						newDetailRecords[i].set('ACCOUNT_YNC'		, record.get('ACCOUNT_YNC'));
						newDetailRecords[i].set('DELIVERY_DATE'		, record.get('ISSUE_DATE'));
						newDetailRecords[i].set('SALE_CUSTOM_CODE'	, record.get('SALE_CUSTOM_CODE'));
						newDetailRecords[i].set('SALE_CUST_CD'		, record.get('SALE_CUST_CD'));
						newDetailRecords[i].set('DVRY_CUST_CD'		, record.get('DVRY_CUST_CD'));
						newDetailRecords[i].set('DVRY_CUST_NAME'	, record.get('DVRY_CUST_NAME'));
						newDetailRecords[i].set('ORDER_CUST_CD'		, record.get('ORDER_CUST_CD'));
						newDetailRecords[i].set('PLAN_NUM'			, record.get('PROJECT_NO'));
						newDetailRecords[i].set('ISSUE_REQ_NUM'		, record.get('ISSUE_REQ_NUM'));
						newDetailRecords[i].set('BASIS_NUM'			, record.get('PO_NUM'));
						newDetailRecords[i].set('BASIS_SEQ'			, record.get('PO_SEQ'));

						if(BsaCodeInfo.gsOptDivCode == "1"){
							newDetailRecords[i].set('SALE_DIV_CODE'	, record.get('ISSUE_DIV_CODE'));
						} else {
							newDetailRecords[i].set('SALE_DIV_CODE'	, record.get('DIV_CODE'));
						}

						newDetailRecords[i].set('MONEY_UNIT'		, record.get('MONEY_UNIT'));
						newDetailRecords[i].set('EXCHG_RATE_O'		, panelResult.getValue('EXCHG_RATE_O'));
						newDetailRecords[i].set('ISSUE_REQ_SEQ'		, record.get('ISSUE_REQ_SEQ'));
						newDetailRecords[i].set('ORDER_NUM'			, record.get('ORDER_NUM'));
						newDetailRecords[i].set('ORDER_SEQ'			, record.get('SER_NO'));
						newDetailRecords[i].set('ORDER_TYPE'		, record.get('ORDER_TYPE'));
						newDetailRecords[i].set('BILL_TYPE'			, record.get('BILL_TYPE'));
						newDetailRecords[i].set('CARD_CUSTOM_CODE'	, record.get('CARD_CUSTOM_CODE'));	//20210223 추가
						newDetailRecords[i].set('STOCK_UNIT'		, record.get('STOCK_UNIT'));
						newDetailRecords[i].set('PRICE_YN'			, record.get('PRICE_YN'));
						newDetailRecords[i].set('SALE_TYPE'			, record.get('ORDER_TYPE'));
						newDetailRecords[i].set('SALE_PRSN'			, record.get('ISSUE_REQ_PRSN'));
						newDetailRecords[i].set('INOUT_PRSN'		, panelResult.getValue('INOUT_PRSN'));
						newDetailRecords[i].set('ACCOUNT_Q'			, "0");
						newDetailRecords[i].set('SALE_C_YN'			, "N");
						newDetailRecords[i].set('CREDIT_YN'			, CustomCodeInfo.gsCustCreditYn);
						newDetailRecords[i].set('WON_CALC_BAS'		, CustomCodeInfo.gsUnderCalBase);
						newDetailRecords[i].set('PAY_METHODE1'		, record.get('PAY_METHODE1'));
						newDetailRecords[i].set('LC_SER_NO'			, record.get('LC_SER_NO'));

						if(Ext.isEmpty(record.get('SOF100_TAX_INOUT'))){
							newDetailRecords[i].set('TAX_INOUT'		, record.get('TAX_INOUT')); //출하지시 참조시 수주의 세액 포함 여부가 null이면 거래처의 세액포함 여부로 세팅
						} else {
							newDetailRecords[i].set('TAX_INOUT'		, record.get('SOF100_TAX_INOUT'));
						}

						newDetailRecords[i].set('LOT_NO'			, record.get('LOT_NO'));
						newDetailRecords[i].set('AGENT_TYPE'		, record.get('AGENT_TYPE'));
						newDetailRecords[i].set('DEPT_CODE'			, record.get('DEPT_CODE'));
						newDetailRecords[i].set('STOCK_CARE_YN'		, record.get('STOCK_CARE_YN'));
						newDetailRecords[i].set('UPDATE_DB_USER'	, UserInfo.userID);
						newDetailRecords[i].set('RETURN_Q_YN'		, record.get('RETURN_Q_YN'));
						newDetailRecords[i].set('SRC_ORDER_Q'		, record.get('ORDER_Q'));
						newDetailRecords[i].set('EXCESS_RATE'		, record.get('EXCESS_RATE'));
						newDetailRecords[i].set('PRICE_TYPE'		, record.get('PRICE_TYPE'));
						newDetailRecords[i].set('INOUT_FOR_WGT_P'	, record.get('ISSUE_FOR_WGT_P'));
						newDetailRecords[i].set('INOUT_FOR_VOL_P'	, record.get('ISSUE_FOR_VOL_P'));
						newDetailRecords[i].set('INOUT_WGT_P'		, record.get('ISSUE_WGT_P'));
						newDetailRecords[i].set('INOUT_VOL_P'		, record.get('ISSUE_VOL_P'));
						newDetailRecords[i].set('WGT_UNIT'			, record.get('WGT_UNIT'));
						newDetailRecords[i].set('UNIT_WGT'			, record.get('UNIT_WGT'));
						newDetailRecords[i].set('VOL_UNIT'			, record.get('VOL_UNIT'));
						newDetailRecords[i].set('UNIT_VOL'			, record.get('UNIT_VOL'));

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
						} else {
							newDetailRecords[i].set('ORDER_UNIT_P'	, record.get('ISSUE_REQ_PRICE'));
						}

						if(record.get('ORDER_Q') != record.get('NOT_REQ_Q')){
								UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "Q")
						} else {
							if(record.get('ACCOUNT_YNC') == "N"){
								newDetailRecords[i].set('ORDER_UNIT_O'	, 0);
								newDetailRecords[i].set('INOUT_TAX_AMT'	, 0);
							} else {
								newDetailRecords[i].set('ORDER_UNIT_O'	, record.get('ISSUE_REQ_AMT'));
								newDetailRecords[i].set('INOUT_TAX_AMT'	, record.get('ISSUE_REQ_TAX_AMT'));
							}
							//20171211 합계금액 표시를 위해 함수 호출
							UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "Q");
						}

						newDetailRecords[i].set('COMP_CODE'			, UserInfo.compCode);
						newDetailRecords[i].set('REMARK'			, record.get('REMARK'));
						newDetailRecords[i].set('TRANS_COST'		, "0");
						newDetailRecords[i].set('ITEM_ACCOUNT'		, record.get('ITEM_ACCOUNT'));
						newDetailRecords[i].set('GUBUN'				, "FEFER");
						newDetailRecords[i].set('INOUT_TYPE_DETAIL'	, record.get('INOUT_TYPE_DETAIL'));

						var lRate = record.get('TRANS_RATE');
						if(lRate == 0){
							lRate = 1;
						}
						newDetailRecords[i].set('STOCK_Q'		, record.get('STOCK_Q'));
						newDetailRecords[i].set('ORDER_STOCK_Q'	, record.get('STOCK_Q') / lRate);
						newDetailRecords[i].set('LOT_YN'		, record.get('LOT_YN'));
						newDetailRecords[i].set('REMARK_INTER'	, record.get('REMARK_INTER'));
						//20210108 추가: API연동을 위해 추가
						newDetailRecords[i].set('BUNDLE_NO'		, record.get('BUNDLE_NO'));
						newDetailRecords[i].set('NUMBER'		, record.get('NUMBER'));
					});
					detailStore.loadData(newDetailRecords, true);
					panelResult.setAllFieldsReadOnly(true);
				}
		},
		//수주 데이터 참조시
		fnMakeSof100tDataRef: function(records) {
			if(!panelResult.setAllFieldsReadOnly(true)){
				return false;
			} else {
				var newDetailRecords = new Array();
				var whCellCode = '';
				var whCellName = '';
				var saleDivCode = '';
				var taxInout = '';
				var inoutSeq = 0;
				var sortSeq = 0;
					  inoutSeq = detailStore.max('INOUT_SEQ');
					  sortSeq = detailStore.max('SORT_SEQ');
				if(Ext.isEmpty(inoutSeq)){
					inoutSeq = 1;
				} else {
					inoutSeq = inoutSeq + 1;
				}
	
				if(Ext.isEmpty(sortSeq)){
					sortSeq = 1;
				} else {
					sortSeq = sortSeq + 1;
				}
	
				Ext.each(records, function(record, i){
					if(i == 0){
						 inoutSeq = inoutSeq;
						 sortSeq = sortSeq;
					} else {
						 inoutSeq += 1;
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
					} else {
						saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
					}
	
					var divCode = '';
					if(BsaCodeInfo.gsOptDivCode == "1"){
						saleDivCode = panelResult.getValue('DIV_CODE');
					} else {
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
						'INOUT_SEQ'			: inoutSeq,
						'SORT_SEQ'			: sortSeq,
						'INOUT_NUM'			: inoutNum,
						'INOUT_CODE'		: inoutCode,
						'CUSTOM_NAME'		: customName,
						'INOUT_TYPE_DETAIL'	: inoutTypeDetail,
						'REF_CODE2'			: refCode2,
						'CREATE_LOC'		: createLoc,
						'MONEY_UNIT'		: moneyUnit,
						'EXCHG_RATE_O'		: exchgRateO,
						'INOUT_PRSN'		: inoutPrsn,
						'SALE_CUST_CD'		: saleCustCD,
						'SALE_CUSTOM_CODE'	: saleCustomCd,
						'SALE_DIV_CODE'		: saleDivCode,
						'DIV_CODE'			: divCode,
						'SALE_TYPE'			: saleType,
						'TAX_INOUT'			: taxInout,
						'DEPT_CODE'			: deptCode,
						'WH_CODE'			: whCode,
						'WH_CELL_CODE'		: whCellCode,
						'SALE_PRSN'			: salePrsn,
						'NATION_INOUT'		: nationInout,
						'INOUT_DATE'		: inoutDate,
						'SALE_DATE'			: saleDate
					};
					newDetailRecords[i] = detailStore.model.create( r );
					newDetailRecords[i].set('INOUT_TYPE'		, "2");
					newDetailRecords[i].set('INOUT_METH'		, "1");
					newDetailRecords[i].set('INOUT_CODE_TYPE'	, "4");
					newDetailRecords[i].set('CREATE_LOC'		, panelResult.getValue('CREATE_LOC'));
					newDetailRecords[i].set('DIV_CODE'			, panelResult.getValue('DIV_CODE'));
					newDetailRecords[i].set('INOUT_CODE'		, record.get('CUSTOM_CODE'));
					newDetailRecords[i].set('CUSTOM_NAME'		, record.get('CUSTOM_NAME'));
					newDetailRecords[i].set('INOUT_DATE'		, panelResult.getValue('INOUT_DATE'));
					newDetailRecords[i].set('INOUT_NUM'			, panelResult.getValue('INOUT_NUM'));
	
					panelResult.setValue('NATION_INOUT', record.get('NATION_INOUT'));
					newDetailRecords[i].set('NATION_INOUT'		, panelResult.getValue('NATION_INOUT'));
	
					newDetailRecords[i].set('EXCHG_RATE_O'		, record.get('EXCHG_RATE_O'));
					
					var inoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_S007').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
					var sRefCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail) ;	//출고유형value의 ref2
	
					if(record.get('INOUT_TYPE_DETAIL') > ""){
						newDetailRecords[i].set('INOUT_TYPE_DETAIL'	, record.get('INOUT_TYPE_DETAIL'));
					} else {
						newDetailRecords[i].set('INOUT_TYPE_DETAIL'	, inoutTypeDetail);
					}
	
					newDetailRecords[i].set('REF_CODE2'			, sRefCode2);
					//20201230 수정: panel값 없으면 참조데이터의 데이터 적용 후 해당 창고정보에 맞는 wh_cell_code 확인하여 set
//					newDetailRecords[i].set('WH_CODE'			, panelResult.getValue('WH_CODE'));
					if(!Ext.isEmpty(panelResult.getValue('WH_CODE'))){
						newDetailRecords[i].set('WH_CODE'		, panelResult.getValue('WH_CODE'));
					} else {
						newDetailRecords[i].set('WH_CODE'		, record.get('WH_CODE'));
					}
					if(!Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))){
						newDetailRecords[i].set('WH_CELL_CODE'	, panelResult.getValue('WH_CELL_CODE'));
					} else {
						var param = {
							DIV_CODE: panelResult.getValue('DIV_CODE'),
							WH_CODE	: newDetailRecords[i].get('WH_CODE')
						}
						matrlCommonService.getWhCellCode(param, function(provider, response) {
							if(!Ext.isEmpty(provider)) {
								newDetailRecords[i].set('WH_CELL_CODE', provider);
							}
						})
					}
					newDetailRecords[i].set('ITEM_CODE'			, record.get('ITEM_CODE'));
					newDetailRecords[i].set('ITEM_NAME'			, record.get('ITEM_NAME'));
					newDetailRecords[i].set('SPEC'				, record.get('SPEC'));
					newDetailRecords[i].set('ITEM_STATUS'		, "1");
					newDetailRecords[i].set('ORDER_UNIT'		, record.get('ORDER_UNIT'));
					newDetailRecords[i].set('TRANS_RATE'		, record.get('TRANS_RATE'));
					newDetailRecords[i].set('ORDER_UNIT_Q'		, record.get('R_ALLOC_Q'));
					newDetailRecords[i].set('ORIGIN_Q'			, record.get('R_ALLOC_Q'));
					newDetailRecords[i].set('ORDER_NOT_Q'		, record.get('R_ALLOC_Q'));
					newDetailRecords[i].set('ISSUE_NOT_Q'		, "0");
					newDetailRecords[i].set('TAX_TYPE'			, record.get('TAX_TYPE'));
					newDetailRecords[i].set('DISCOUNT_RATE'		, record.get('DISCOUNT_RATE'));
					newDetailRecords[i].set('ACCOUNT_YNC'		, record.get('ACCOUNT_YNC'));
					newDetailRecords[i].set('SALE_CUSTOM_CODE'	, record.get('SALE_CUST_CD'));
					newDetailRecords[i].set('SALE_CUST_CD'		, record.get('SALE_CUST_NM'));
					newDetailRecords[i].set('DVRY_CUST_CD'		, record.get('DVRY_CUST_CD'));
					newDetailRecords[i].set('DVRY_CUST_NAME'	, record.get('DVRY_CUST_NAME'));
					newDetailRecords[i].set('ORDER_CUST_CD'		, record.get('CUSTOM_NAME'));
					newDetailRecords[i].set('PLAN_NUM'			, record.get('PROJECT_NO'));
					newDetailRecords[i].set('BASIS_NUM'			, record.get('PO_NUM'));
					newDetailRecords[i].set('BASIS_SEQ'			, record.get('PO_SEQ'));
	
					if(BsaCodeInfo.gsOptDivCode == "1"){
						newDetailRecords[i].set('SALE_DIV_CODE'	, record.get('OUT_DIV_CODE'));
					} else {
						newDetailRecords[i].set('SALE_DIV_CODE'	, record.get('DIV_CODE'));
					}
	
					newDetailRecords[i].set('MONEY_UNIT'		, record.get('MONEY_UNIT'));
					newDetailRecords[i].set('EXCHG_RATE_O'		, panelResult.getValue('EXCHG_RATE_O'));
					newDetailRecords[i].set('ORDER_NUM'			, record.get('ORDER_NUM'));
					newDetailRecords[i].set('ORDER_SEQ'			, record.get('SER_NO'));
					newDetailRecords[i].set('ORDER_TYPE'		, record.get('ORDER_TYPE'));
					newDetailRecords[i].set('BILL_TYPE'			, record.get('BILL_TYPE'));
					newDetailRecords[i].set('CARD_CUSTOM_CODE'	, record.get('CARD_CUSTOM_CODE'));	//20210223 추가
					newDetailRecords[i].set('STOCK_UNIT'		, record.get('STOCK_UNIT'));
					newDetailRecords[i].set('PRICE_YN'			, record.get('PRICE_YN'));
					if(panelResult.getValue('CREATE_LOC') == "5"){
						newDetailRecords[i].set('SALE_TYPE'		, '60');
					} else {
						newDetailRecords[i].set('SALE_TYPE'		, record.get('ORDER_TYPE'));
					}
					newDetailRecords[i].set('SALE_PRSN'			, record.get('ORDER_PRSN'));
					newDetailRecords[i].set('INOUT_PRSN'		, panelResult.getValue('INOUT_PRSN'));
					newDetailRecords[i].set('ACCOUNT_Q'			, "0");
					newDetailRecords[i].set('SALE_C_YN'			, "N");
					newDetailRecords[i].set('CREDIT_YN'			, CustomCodeInfo.gsCustCreditYn);
					newDetailRecords[i].set('WON_CALC_BAS'		, CustomCodeInfo.gsUnderCalBase);
					newDetailRecords[i].set('TAX_INOUT'			, record.get('TAX_INOUT'));
					newDetailRecords[i].set('AGENT_TYPE'		, record.get('ITEM_CODE'));
					newDetailRecords[i].set('AGENT_TYPE'		, record.get('AGENT_TYPE'));
					newDetailRecords[i].set('DEPT_CODE'			, record.get('DEPT_CODE'));
					newDetailRecords[i].set('STOCK_CARE_YN'		, record.get('STOCK_CARE_YN'));
					newDetailRecords[i].set('UPDATE_DB_USER'	, record.get('USER_ID'));
					newDetailRecords[i].set('RETURN_Q_YN'		, record.get('RETURN_Q_YN'));
					newDetailRecords[i].set('SRC_ORDER_Q'		, record.get('ORDER_Q'));
					newDetailRecords[i].set('EXCESS_RATE'		, record.get('EXCESS_RATE'));
	
					if(newDetailRecords[i].get('ACCOUNT_YNC') == "N"){
						newDetailRecords[i].set('ORDER_UNIT_P'	, 0);
					} else {
						newDetailRecords[i].set('ORDER_UNIT_P'	, record.get('R_ORDER_P'));
					}
	
					if(record.get('ORDER_Q') != record.get('R_ALLOC_Q')){
						UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "Q")
					}
	
					if(record.get('ACCOUNT_YNC') == "N"){
						newDetailRecords[i].set('ORDER_UNIT_O'	, 0);
						newDetailRecords[i].set('INOUT_TAX_AMT'	, 0);
					} else {
						newDetailRecords[i].set('ORDER_UNIT_O'	, record.get('R_ORDER_O'));
						newDetailRecords[i].set('INOUT_TAX_AMT'	, record.get('R_ORDER_TAX_O'));
					}
	
					newDetailRecords[i].set('PRICE_TYPE'		, record.get('PRICE_TYPE'));
					newDetailRecords[i].set('INOUT_FOR_WGT_P'	, record.get('ORDER_FOR_WGT_P'));
					newDetailRecords[i].set('INOUT_FOR_VOL_P'	, record.get('ORDER_FOR_VOL_P'));
					newDetailRecords[i].set('INOUT_WGT_P'		, record.get('ORDER_WGT_P'));
					newDetailRecords[i].set('INOUT_VOL_P'		, record.get('ORDER_VOL_P'));
					newDetailRecords[i].set('WGT_UNIT'			, record.get('WGT_UNIT'));
					newDetailRecords[i].set('UNIT_WGT'			, record.get('UNIT_WGT'));
					newDetailRecords[i].set('VOL_UNIT'			, record.get('VOL_UNIT'));
					newDetailRecords[i].set('UNIT_VOL'			, record.get('UNIT_VOL'));
	
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
					newDetailRecords[i].set('REMARK'			, record.get('REMARK'));
					newDetailRecords[i].set('PAY_METHODE1'		, record.get('PAY_METHODE1'));
					newDetailRecords[i].set('LC_SER_NO'			, record.get('LC_SER_NO'));
					newDetailRecords[i].set('TRANS_COST'		, "0");
					newDetailRecords[i].set('ITEM_ACCOUNT'		, record.get('ITEM_ACCOUNT'));
					newDetailRecords[i].set('GUBUN'				, "FEFER");
	
					var lRate = record.get('TRANS_RATE');
					if(lRate == 0){
						lRate = 1;
					}
					newDetailRecords[i].set('STOCK_Q'		, record.get('STOCK_Q'));
					newDetailRecords[i].set('ORDER_STOCK_Q'	, record.get('STOCK_Q') / lRate);
					newDetailRecords[i].set('LOT_YN'		, record.get('LOT_YN'));
					newDetailRecords[i].set('REMARK_INTER'	, record.get('REMARK_INTER'));
					newDetailRecords[i].set('LOT_NO'		, record.get('R_LOT_NO'));			//20200227 수정: 20181217 주석했던 부분 주석해제
					UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "P");
					//20210108 추가: API연동을 위해 추가
					newDetailRecords[i].set('BUNDLE_NO'		, record.get('BUNDLE_NO'));
					newDetailRecords[i].set('NUMBER'		, record.get('NUMBER'));
				});
				detailStore.loadData(newDetailRecords, true);
				panelResult.setAllFieldsReadOnly(true);
			}
		}
	});



	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			if(BsaCodeInfo.gsInoutAutoYN == "N" && record.get('ACCOUNT_Q')){
				rv = Msg.sMS335;
			}else if( record.get('SALE_C_YN' == 'Y')){
				rv = Msg.sMS214;
			} else {
				switch(fieldName) {
					case "INOUT_SEQ" :
						if(newValue <= 0 && !Ext.isEmpty(newValue)) {
							rv=Msg.sMB076;
							break;
						}
						break;

					case "INOUT_TYPE_DETAIL" :
						var sRefCode2 = UniAppManager.app.fnGetSubCode(null, newValue) ;	//출고유형value의 ref2
						var OldRefCode2 = record.get('REF_CODE2');
						record.set('REF_CODE2', sRefCode2);
						if((sRefCode2 > "91" && sRefCode2 < "99" ) || sRefCode2 == "C1"){
							record.set('REF_CODE2', OldRefCode2);
							rv=Msg.sMS255;
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
								rv=Msg.sMS255;
								break;
							}
							record.set('ACCOUNT_YNC','N');	//미매출대상
							record.set('ITEM_STATUS','1');	//불량 -> 양품으로 바꿈 20160701

						} else {
							if((!Ext.isEmpty(record.get('ORDER_NUM')) && Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) || (Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))) || (!Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM')))){
								//skip
							} else {
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
						} else {
							record.set('WH_CODE', "");
							record.set('WH_CELL_CODE', "");
							record.set('WH_CELL_NAME', "");
							record.set('LOT_NO', "");
						}
						if(!Ext.isEmpty(record.get('ITEM_CODE'))){
							UniSales.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('DIV_CODE'), record.get('ITEM_STATUS'), record.get('ITEM_CODE'),  newValue);

						}
						//20201230 추가: 창고변경 시, 창고에 설정되어 있는 기본창고cell 가져오는 로직 추가
						var param = {
							DIV_CODE: panelResult.getValue('DIV_CODE'),
							WH_CODE	: newValue
						}
						matrlCommonService.getWhCellCode(param, function(provider, response) {
							if(!Ext.isEmpty(provider)) {
								record.set('WH_CELL_CODE', provider);
							}
						})
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
							rv=Msg.sMB076;
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
						//20210415 주석: -수량 입력 가능하도록 변경(반품기능 이 프로그램에서 사용)
//						if(newValue < 0 && !Ext.isEmpty(newValue)) {
//							rv=Msg.sMB076;
//							break;
//						}

						var sInout_q = 0;

						if(BsaCodeInfo.gsBoxYN == 'Y'){
							if(record.obj.phantom){
								if(newValue > record.get('ORIGIN_Q')){			//출고수량 > 미납량
									sInout_q = record.get('ORIGIN_Q');			//출고수량 = 미납량(참조에서 가져온 미납량)
									record.set('LOSS_Q',newValue - record.get('ORIGIN_Q'));//LOSS여분 = 출고수량 - 미납량
								} else {
									sInout_q = newValue;	//출고량
									record.set('LOSS_Q',0);
								}
							} else {
								if(!Ext.isEmpty(record.get('ORDER_NUM')) && Ext.isEmpty(record.get('ISSUE_REQ_NUM'))){		//수주참조
									if(newValue > record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q')){			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q');			//출고수량 = 미납량
										record.set('LOSS_Q',newValue - (record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q')));//LOSS여분 = 출고수량 - 미납량
									} else {
										sInout_q = newValue;	//출고량
										record.set('LOSS_Q',0);
									}
								}else if(!Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))){	//출하지시참조
									if(newValue > record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q')){			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q');			//출고수량 = 미납량
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

						var sInv_q = record.get('STOCK_Q');				//재고량
						var sOriginQ = record.get('ORIGIN_Q');			//출고량
						var lot_q = record.get('TEMP_ORDER_UNIT_Q');	//로트팝업에서 넘겨받는 수량

						if(!Ext.isEmpty(lot_q) && lot_q!= 0){
							if(sInout_q > lot_q){
								rv = "출고량은 lot재고량을 초과할 수 없습니다. 현재고: " + lot_q;
								break;
							}
						}

						if(BsaCodeInfo.gsInvstatus == "+" && (record.get('STOCK_CARE_YN') == "Y")){
							if(sInout_q > (sInv_q + sOriginQ)){
								rv=Msg.sMS210;	//출고량은 재고량을 초과할 수 없습니다.
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

						record.set('PACK_UNIT_Q',0);
						record.set('BOX_Q',0);
						record.set('EACH_Q',0);

						setTimeout(function(){
							record.set('ORDER_UNIT_Q',sInout_q);		//출고수량
						}, 50);
						break;

					case "INOUT_WGT_Q" :	//hidden
						if(newValue < 0 && !Ext.isEmpty(newValue)) {
							rv=Msg.sMB076;
							break;
						}
						var sOrderWgtQ = record.get('INOUT_WGT_Q');
						var sUnitWgt = record.get('UNIT_WGT');
						if(sUnitWgt == 0){
							rv='단위중량이 입력되지 않아서 계산이 불가능합니다. 품목정보에서 단위중량을 확인하시기 바랍니다.'
							break;
						}
						var sInout_q = sUnitWgt == 0 ? 0 : sOrderWgtQ / sUnitWgt;
						if(BsaCodeInfo.gsPointYn == "N" && (record.get('ORDER_UNIT') == BsaCodeInfo.gsPointYn)){
							if(sInout_q - (Math.floor(sInout_q)) != 0){
								rv='수주량(판매단위)은 소숫점을 입력할 수 없습니다. 수주량(중량단위)을 확인하시기 바랍니다.'
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
								rv=Msg.sMS210;	//출고량은 재고량을 초과할 수 없습니다.
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
							rv=Msg.sMB076;
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
							rv=Msg.sMB076;
							break;
						}
						var dTaxAmtO = record.get('INOUT_TAX_AMT');
						if(newValue > 0 && dTaxAmtO > newValue){
							rv=Msg.sMS224;	//매출금액은 세액보다 커야 합니다.
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
						var dOrderO = record.get('ORDER_UNIT_Q')*record.get('ORDER_UNIT_P');
						record.set('ORDER_UNIT_O', dOrderO);
						UniAppManager.app.fnOrderAmtCal(record, "O",'ORDER_UNIT_O', dOrderO, newValue);
						detailStore.fnOrderAmtSum();
						break;

					case "INOUT_TAX_AMT" :
						var dSaleAmtO = record.get('ORDER_UNIT_O');
						if(newValue > 0 && dSaleAmtO < newValue){
							rv = Msg.sMS224;	//매출금액은 세액보다 커야 합니다.
							break;
						}
						var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
						if(UserInfo.compCountry == "CN"){
							record.set('INOUT_TAX_AMT', UniSales.fnAmtWonCalc(newValue, "3"), numDigitOfPrice)
						} else {
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
						} else {
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
							rv=Msg.sMB076;
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
						if(BsaCodeInfo.gsBoxYN == 'Y'){
							var sInout_q = 0;
							if(record.obj.phantom){
								if(newValue * record.get('BOX_Q') + record.get('EACH_Q') > record.get('ORIGIN_Q')){			//출고수량 > 미납량
									sInout_q = record.get('ORIGIN_Q');	//출고수량 = 미납량(참조에서 가져온 미납량)
									record.set('LOSS_Q',newValue * record.get('BOX_Q') + record.get('EACH_Q') - record.get('ORIGIN_Q'));//LOSS여분 = 출고수량 - 미납량

								} else {

									sInout_q = newValue * record.get('BOX_Q') + record.get('EACH_Q');	//출고량
									record.set('LOSS_Q',0);
								}
							} else {
								if(!Ext.isEmpty(record.get('ORDER_NUM')) && Ext.isEmpty(record.get('ISSUE_REQ_NUM'))){		//수주참조
									if(newValue * record.get('BOX_Q') + record.get('EACH_Q') > record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q')){			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q');	//출고수량 = 미납량
										record.set('LOSS_Q',newValue * record.get('BOX_Q') + record.get('EACH_Q') - (record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q')));//LOSS여분 = 출고수량 - 미납량
									} else {
										sInout_q = newValue * record.get('BOX_Q') + record.get('EACH_Q');	//출고량
										record.set('LOSS_Q',0);
									}
								}else if(!Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))){	//출하지시참조
									if(newValue * record.get('BOX_Q') + record.get('EACH_Q') > record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q')){			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q');	//출고수량 = 미납량
										record.set('LOSS_Q',newValue * record.get('BOX_Q') + record.get('EACH_Q') - (record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q')));//LOSS여분 = 출고수량 - 미납량
									} else {
										sInout_q = newValue * record.get('BOX_Q') + record.get('EACH_Q');	//출고량
										record.set('LOSS_Q',0);
									}
								}
							}
							record.set('ORDER_UNIT_Q', sInout_q);	//출고량 = box입수 * box수 + 낱개

							var sInv_q = record.get('STOCK_Q');	//재고량
							var sOriginQ = record.get('ORIGIN_Q'); //출고량
							var lot_q = record.get('TEMP_ORDER_UNIT_Q');//로트팝업에서 넘겨받는 수량

							if(!Ext.isEmpty(lot_q) && lot_q!= 0){
								if(sInout_q > lot_q){
									rv = "출고량은 lot재고량을 초과할 수 없습니다. 현재고: " + lot_q;
									break;
								}
							}

							if(BsaCodeInfo.gsInvstatus == "+" && (record.get('STOCK_CARE_YN') == "Y")){
								if(sInout_q > (sInv_q + sOriginQ)){
									rv=Msg.sMS210;	//출고량은 재고량을 초과할 수 없습니다.
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
						if(BsaCodeInfo.gsBoxYN == 'Y'){
							var sInout_q = 0;

							if(record.obj.phantom){
								if(record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') > record.get('ORIGIN_Q')){			//출고수량 > 미납량
									sInout_q = record.get('ORIGIN_Q');	//출고수량 = 미납량(참조에서 가져온 미납량)
									record.set('LOSS_Q',record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') - record.get('ORIGIN_Q'));//LOSS여분 = 출고수량 - 미납량
								} else {
									sInout_q = record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q');	//출고량
									record.set('LOSS_Q',0);
								}
							} else {
								if(!Ext.isEmpty(record.get('ORDER_NUM')) && Ext.isEmpty(record.get('ISSUE_REQ_NUM'))){		//수주참조
									if(record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') > record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q')){			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q');	//출고수량 = 미납량
										record.set('LOSS_Q',record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') - (record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q')));//LOSS여분 = 출고수량 - 미납량

									} else {
										sInout_q = record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q');	//출고량
										record.set('LOSS_Q',0);
									}
								}else if(!Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))){	//출하지시참조
									if(record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') > record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q')){			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q');	//출고수량 = 미납량
										record.set('LOSS_Q',record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q') - (record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q')));//LOSS여분 = 출고수량 - 미납량

									} else {
										sInout_q = record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q');	//출고량
										record.set('LOSS_Q',0);
									}
								}
							}
							record.set('ORDER_UNIT_Q', sInout_q);

//							var sInout_q = record.get('PACK_UNIT_Q') * newValue + record.get('EACH_Q');	//출고량
							var sInv_q = record.get('STOCK_Q');	//재고량
							var sOriginQ = record.get('ORIGIN_Q'); //출고량
							var lot_q = record.get('TEMP_ORDER_UNIT_Q');//로트팝업에서 넘겨받는 수량

							if(!Ext.isEmpty(lot_q) && lot_q!= 0){
								if(sInout_q > lot_q){
									rv = "출고량은 lot재고량을 초과할 수 없습니다. 현재고: " + lot_q;
									break;
								}
							}

							if(BsaCodeInfo.gsInvstatus == "+" && (record.get('STOCK_CARE_YN') == "Y")){
								if(sInout_q > (sInv_q + sOriginQ)){
									rv=Msg.sMS210;	//출고량은 재고량을 초과할 수 없습니다.
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
						if(BsaCodeInfo.gsBoxYN == 'Y'){
							if(record.obj.phantom){
								if(record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue > record.get('ORIGIN_Q')){			//출고수량 > 미납량
									sInout_q = record.get('ORIGIN_Q');	//출고수량 = 미납량(참조에서 가져온 미납량)
									record.set('LOSS_Q',record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue - record.get('ORIGIN_Q'));//LOSS여분 = 출고수량 - 미납량

								} else {

									sInout_q = record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue;	//출고량
									record.set('LOSS_Q',0);
								}
							} else {
								if(!Ext.isEmpty(record.get('ORDER_NUM')) && Ext.isEmpty(record.get('ISSUE_REQ_NUM'))){		//수주참조
									if(record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue > record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q')){			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q');	//출고수량 = 미납량
										record.set('LOSS_Q',record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue - (record.get('ORIGIN_Q') + record.get('ORDER_NOT_Q')));//LOSS여분 = 출고수량 - 미납량

									} else {
										sInout_q = record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue;	//출고량
										record.set('LOSS_Q',0);
									}
								}else if(!Ext.isEmpty(record.get('ORDER_NUM')) && !Ext.isEmpty(record.get('ISSUE_REQ_NUM'))){	//출하지시참조
									if(record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue > record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q')){			//출고수량 > 미납량
										sInout_q = record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q');	//출고수량 = 미납량
										record.set('LOSS_Q',record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue - (record.get('ORIGIN_Q') + record.get('ISSUE_NOT_Q')));//LOSS여분 = 출고수량 - 미납량

									} else {
										sInout_q = record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue;	//출고량
										record.set('LOSS_Q',0);
									}
								}
							}
							record.set('ORDER_UNIT_Q', sInout_q);
//							record.set('ORDER_UNIT_Q', record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue);

//							var sInout_q = record.get('PACK_UNIT_Q') * record.get('BOX_Q') + newValue;	//출고량
							var sInv_q = record.get('STOCK_Q');	//재고량
							var sOriginQ = record.get('ORIGIN_Q'); //출고량
							var lot_q = record.get('TEMP_ORDER_UNIT_Q');//로트팝업에서 넘겨받는 수량

							if(!Ext.isEmpty(lot_q) && lot_q!= 0){
								if(sInout_q > lot_q){
									rv = "출고량은 lot재고량을 초과할 수 없습니다. 현재고: " + lot_q;
									break;
								}
							}

							if(BsaCodeInfo.gsInvstatus == "+" && (record.get('STOCK_CARE_YN') == "Y")){
								if(sInout_q > (sInv_q + sOriginQ)){
									rv=Msg.sMS210;	//출고량은 재고량을 초과할 수 없습니다.
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

					//20210414 추가: '부가세유형' 컬럼 콤보로 변경 / 수정 가능하도록 변경 (hidden: false) / 변경에 따른 금액 계산로직 추가
					case "BILL_TYPE" :
						if(newValue == '50') {			//'영세매출'일 때만 '면세'로 변경 후, 재계산...('영세' 아님)
							record.set('TAX_TYPE'		, '2');
							record.set('INOUT_TAX_AMT'	, '0');
						} else {
							record.set('TAX_TYPE'		, '1');
						}
						//카드매출이 아니면 카드사 컬럼 초기화
						if(newValue != '40') {
							record.set('CARD_CUSTOM_CODE', '');
						}
						var sInout_q = record.get('ORDER_UNIT_Q');
						UniAppManager.app.fnOrderAmtCal(record, 'Q', 'ORDER_UNIT_Q', sInout_q, null, null);
						detailStore.fnOrderAmtSum();
						break;

					//20210414: 세액포함여부 수정관련 로직 추가
					case "TAX_INOUT" :
						var sInout_q = record.get('ORDER_UNIT_Q');
						UniAppManager.app.fnOrderAmtCal(record, 'Q', 'ORDER_UNIT_Q', sInout_q, null, newValue);
						detailStore.fnOrderAmtSum();
						break;
				}
			}
			return rv;
		}
	}); // validator



	//20190930 화폐에 따라 컬럼 포맷설정하는 부분 함수로 뺀 후, 여러곳에서 호출하도록 수정
	function fnSetColumnFormat(provider) {
		var length = 0
		var format = ''
		if(panelResult.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
			length = Ext.isEmpty(UniFormat.FC.split('.')[1]) ? 0 : UniFormat.FC.split('.')[1].length;
			format = UniFormat.FC;
			panelResult.setValue('NATION_INOUT', '2');
			
		} else {
			length = Ext.isEmpty(UniFormat.Price.split('.')[1]) ? 0 : UniFormat.Price.split('.')[1].length;
			format = UniFormat.Price;
			panelResult.setValue('NATION_INOUT', '1');
		}
		panelResult.getField('TOT_SALE_TAXI').setConfig('decimalPrecision', length);
		panelResult.getField('TOT_SALE_TAXI').focus();
		panelResult.getField('TOT_SALE_TAXI').blur();
		panelResult.getField('TOT_TAXI').setConfig('decimalPrecision', length);
		panelResult.getField('TOT_TAXI').focus();
		panelResult.getField('TOT_TAXI').blur();
		panelResult.getField('TOT_SALENO_TAXI').setConfig('decimalPrecision', length);
		panelResult.getField('TOT_SALENO_TAXI').focus();
		panelResult.getField('TOT_SALENO_TAXI').blur();
		panelResult.getField('TOTAL_AMT').setConfig('decimalPrecision', length);
		panelResult.getField('TOTAL_AMT').focus();
		panelResult.getField('TOTAL_AMT').blur();

		detailGrid.getColumn("ORDER_UNIT_O").setConfig('format'	, format);
		detailGrid.getColumn("ORDER_AMT_SUM").setConfig('format', format);
		detailGrid.getColumn("INOUT_TAX_AMT").setConfig('format', format);

		detailGrid.getColumn("ORDER_UNIT_O").setConfig('decimalPrecision'	, length);
		detailGrid.getColumn("ORDER_AMT_SUM").setConfig('decimalPrecision'	, length);
		detailGrid.getColumn("INOUT_TAX_AMT").setConfig('decimalPrecision'	, length);

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

		//20190930 운반비 추가
		detailGrid.getColumn("TRANS_COST").setConfig('format',format);
		detailGrid.getColumn("TRANS_COST").setConfig('decimalPrecision', length);
		if(!Ext.isEmpty(detailGrid.getColumn("TRANS_COST").config.editor) && !Ext.isEmpty(detailGrid.getColumn("TRANS_COST").config.editor.decimalPrecision)) {
			detailGrid.getColumn("TRANS_COST").config.editor.decimalPrecision = length;
		}
		if(!Ext.isEmpty(detailGrid.getColumn("TRANS_COST").editor)) {
			detailGrid.getColumn("TRANS_COST").editor.decimalPrecision = length;
		}

		if(isLoad){
			isLoad = false;
		} else {
			UniAppManager.app.fnExchngRateO(null, provider);	//20210114 추가: refProvider 관련로직 추가
		}
	}



	//20210114 추가: 바코드 입력 로직 (출하지시번호)
	function fnEnterIssueBarcode(newValue) {
		var detailRecords	= detailStore.data.items;
		var IssueReqBarcode	= newValue
		var flag			= true;

		//동일한 출하지시번호 입력되었을 경우 처리
		Ext.each(detailRecords, function(detailRecord,i) {
			if(detailRecord.get('ISSUE_REQ_NUM').toUpperCase() == IssueReqBarcode.toUpperCase()) {
				beep();
				gsText	= '<t:message code="system.label.sales.message001" default="동일한  출하지시번호가 이미 등록 되었습니다."/>';
				flag	= false;
				openAlertWindow(gsText);
				Ext.getBody().unmask();
				panelResult.getField('ISSUE_BARCODE').focus();
				return false;
			}
		});

		if(flag) {
			var param = {
				CUSTOM_CODE		: panelResult.getValue('CUSTOM_CODE'),
				ISSUE_REQ_NUM	: IssueReqBarcode,
				ITEM_LEVEL1		: panelResult.getValue('ITEM_LEVEL1')		//20210317 추가
			}
			//출하지시참조 조회쿼리 호출
			s_str104ukrv_wmService.selectRequestiList(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					panelResult.setValue('MONEY_UNIT', provider[0].MONEY_UNIT);
					fnSetColumnFormat(provider)
				} else {
					Unilite.messageBox('입력하신 출하지시번호 오류 또는 이미 출고된 데이터 입니다.' + '<p>' + '담당자에게 문의하세요.');		//20210308 수정: 메세지 수정
					Ext.getBody().unmask();
					panelResult.setValue('ISSUE_BARCODE', '');
					panelResult.getField('ISSUE_BARCODE').focus();
					return false;
				}
			});
		}
	}

	//20210114 추가: 바코드 입력 로직 (출하지시번호)
	function fnMakeSrq100tDataRef_ByBarcode(records) {
		if(!panelResult.setAllFieldsReadOnly(true)){
			return false;
		} else {
			var newDetailRecords = new Array();
			var whCellCode			= '';
			var whCellName			= '';
			var saleDivCode			= '';
			var taxInout			= '';
			var inoutSeq			= 0;
			var sortSeq				= 0;
			inoutSeq				= detailStore.max('INOUT_SEQ');
			sortSeq					= detailStore.max('SORT_SEQ');

			if(Ext.isEmpty(inoutSeq)){
				inoutSeq = 1;
			} else {
				inoutSeq = inoutSeq + 1;
			}
			if(Ext.isEmpty(sortSeq)){
				sortSeq = 1;
			} else {
				sortSeq = sortSeq + 1;
			}

			Ext.each(records, function(record,i){
				if(i == 0){
					inoutSeq= inoutSeq;
					sortSeq	= sortSeq;
				} else {
					inoutSeq+= 1;
					sortSeq	+= 1;
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
				var refCode2 = UniAppManager.app.fnGetSubCode(null, inoutTypeDetail);					//출고유형value의 ref2

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
				if(BsaCodeInfo.gsOptDivCode == '1'){
					saleDivCode = panelResult.getValue('DIV_CODE');
				} else {
					saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
				}
				var divCode = '';
				if(BsaCodeInfo.gsOptDivCode == '1'){
					saleDivCode = panelResult.getValue('DIV_CODE');
				} else {
					saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(CustomCodeInfo.gsbusiPrsn);	//거래처의 영업담당의 사업장가져오기
				}

				var saleType = Ext.data.StoreManager.lookup('CBS_AU_S002').getAt(0).get('value');		//판매유형콤보value중 첫번째 value
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
					'INOUT_SEQ'			: inoutSeq,
					'SORT_SEQ'			: sortSeq,
					'INOUT_NUM'			: inoutNum,
					'INOUT_CODE'		: inoutCode,
					'CUSTOM_NAME'		: customName,
					'INOUT_TYPE_DETAIL'	: inoutTypeDetail,
					'REF_CODE2'			: refCode2,
					'CREATE_LOC'		: createLoc,
					'MONEY_UNIT'		: moneyUnit,
					'EXCHG_RATE_O'		: exchgRateO,
					'INOUT_PRSN'		: inoutPrsn,
					'SALE_CUST_CD'		: saleCustCD,
					'SALE_CUSTOM_CODE'	: saleCustomCd,
					'SALE_DIV_CODE'		: saleDivCode,
					'DIV_CODE'			: divCode,
					'SALE_TYPE'			: saleType,
					'TAX_INOUT'			: taxInout,
					'DEPT_CODE'			: deptCode,
					'WH_CODE'			: whCode,
					'WH_CELL_CODE'		: whCellCode,
					'SALE_PRSN'			: salePrsn,
					'NATION_INOUT'		: nationInout,
					'INOUT_DATE'		: inoutDate,
					'SALE_DATE'			: saleDate
				};
				newDetailRecords[i] = detailStore.model.create( r );
				newDetailRecords[i].set('INOUT_TYPE'		, '2');
				newDetailRecords[i].set('INOUT_METH'		, '1');
				newDetailRecords[i].set('INOUT_CODE_TYPE'	, '4');
				newDetailRecords[i].set('CREATE_LOC'		, panelResult.getValue('CREATE_LOC'));
				newDetailRecords[i].set('DIV_CODE'			, panelResult.getValue('DIV_CODE'));
				newDetailRecords[i].set('INOUT_CODE'		, record.CUSTOM_CODE);
				newDetailRecords[i].set('CUSTOM_NAME'		, record.CUSTOM_NAME);
				newDetailRecords[i].set('INOUT_DATE'		, panelResult.getValue('INOUT_DATE'));
				newDetailRecords[i].set('INOUT_NUM'			, panelResult.getValue('INOUT_NUM'));
				newDetailRecords[i].set('REF_CODE2'			, record.REF_CODE2);
				if(!Ext.isEmpty(panelResult.getValue('WH_CODE'))){
					newDetailRecords[i].set('WH_CODE'		, panelResult.getValue('WH_CODE'));
					newDetailRecords[i].set('WH_NAME'		, panelResult.getValue('WH_NAME'));
				} else {
					newDetailRecords[i].set('WH_CODE'		, record.WH_CODE);
					newDetailRecords[i].set('WH_NAME'		, record.WH_CODE);
				}
				if(BsaCodeInfo.gsSumTypeCell == "Y"){
					if(!Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))){
						newDetailRecords[i].set('WH_CELL_CODE'	, panelResult.getValue('WH_CELL_CODE'));
						newDetailRecords[i].set('WH_CELL_NAME'	, panelResult.getValue('WH_CELL_NAME'));
					} else {
						newDetailRecords[i].set('WH_CELL_CODE'	, record.WH_CELL_CODE);
						newDetailRecords[i].set('WH_CELL_NAME'	, record.WH_CELL_NAME);
					}
				} else {
					newDetailRecords[i].set('WH_CELL_CODE'	, '');
					newDetailRecords[i].set('WH_CELL_NAME'	, '');
				}
				newDetailRecords[i].set('ITEM_CODE'			, record.ITEM_CODE);
				newDetailRecords[i].set('ITEM_NAME'			, record.ITEM_NAME);
				newDetailRecords[i].set('SPEC'				, record.SPEC);
				newDetailRecords[i].set('ITEM_STATUS'		, '1');
				newDetailRecords[i].set('ORDER_UNIT'		, record.ORDER_UNIT);
				newDetailRecords[i].set('TRANS_RATE'		, record.TRANS_RATE);
				newDetailRecords[i].set('ORDER_UNIT_Q'		, record.NOT_REQ_Q);
				newDetailRecords[i].set('ORIGIN_Q'			, record.NOT_REQ_Q);
				newDetailRecords[i].set('ORDER_NOT_Q'		, '0');
				newDetailRecords[i].set('ISSUE_NOT_Q'		, record.NOT_REQ_Q);
				newDetailRecords[i].set('TAX_TYPE'			, record.TAX_TYPE);
				newDetailRecords[i].set('DISCOUNT_RATE'		, record.DISCOUNT_RATE);
				newDetailRecords[i].set('ACCOUNT_YNC'		, record.ACCOUNT_YNC);
				newDetailRecords[i].set('DELIVERY_DATE'		, record.ISSUE_DATE);
				newDetailRecords[i].set('SALE_CUSTOM_CODE'	, record.SALE_CUSTOM_CODE);
				newDetailRecords[i].set('SALE_CUST_CD'		, record.SALE_CUST_CD);
				newDetailRecords[i].set('DVRY_CUST_CD'		, record.DVRY_CUST_CD);
				newDetailRecords[i].set('DVRY_CUST_NAME'	, record.DVRY_CUST_NAME);
				newDetailRecords[i].set('ORDER_CUST_CD'		, record.ORDER_CUST_CD);
				newDetailRecords[i].set('PLAN_NUM'			, record.PROJECT_NO);
				newDetailRecords[i].set('ISSUE_REQ_NUM'		, record.ISSUE_REQ_NUM);
				newDetailRecords[i].set('BASIS_NUM'			, record.PO_NUM);
				newDetailRecords[i].set('BASIS_SEQ'			, record.PO_SEQ);

				if(BsaCodeInfo.gsOptDivCode == "1"){
					newDetailRecords[i].set('SALE_DIV_CODE'	, record.ISSUE_DIV_CODE);
				} else {
					newDetailRecords[i].set('SALE_DIV_CODE'	, record.DIV_CODE);
				}

				newDetailRecords[i].set('MONEY_UNIT'		, record.MONEY_UNIT);
				newDetailRecords[i].set('EXCHG_RATE_O'		, panelResult.getValue('EXCHG_RATE_O'));
				newDetailRecords[i].set('ISSUE_REQ_SEQ'		, record.ISSUE_REQ_SEQ);
				newDetailRecords[i].set('ORDER_NUM'			, record.ORDER_NUM);
				newDetailRecords[i].set('ORDER_SEQ'			, record.SER_NO);
				newDetailRecords[i].set('ORDER_TYPE'		, record.ORDER_TYPE);
				newDetailRecords[i].set('BILL_TYPE'			, record.BILL_TYPE);
				newDetailRecords[i].set('CARD_CUSTOM_CODE'	, record.CARD_CUSTOM_CODE);	//20210223 추가, 20210226 수정
				newDetailRecords[i].set('STOCK_UNIT'		, record.STOCK_UNIT);
				newDetailRecords[i].set('PRICE_YN'			, record.PRICE_YN);
				newDetailRecords[i].set('SALE_TYPE'			, record.ORDER_TYPE);
				newDetailRecords[i].set('SALE_PRSN'			, record.ISSUE_REQ_PRSN);
				newDetailRecords[i].set('INOUT_PRSN'		, panelResult.getValue('INOUT_PRSN'));
				newDetailRecords[i].set('ACCOUNT_Q'			, '0');
				newDetailRecords[i].set('SALE_C_YN'			, 'N');
				newDetailRecords[i].set('CREDIT_YN'			, CustomCodeInfo.gsCustCreditYn);
				newDetailRecords[i].set('WON_CALC_BAS'		, CustomCodeInfo.gsUnderCalBase);
				newDetailRecords[i].set('PAY_METHODE1'		, record.PAY_METHODE1);
				newDetailRecords[i].set('LC_SER_NO'			, record.LC_SER_NO);

				if(Ext.isEmpty(record.SOF100_TAX_INOUT)){
					newDetailRecords[i].set('TAX_INOUT'		, record.TAX_INOUT);		//출하지시 참조시 수주의 세액 포함 여부가 null이면 거래처의 세액포함 여부로 세팅
				} else {
					newDetailRecords[i].set('TAX_INOUT'		, record.SOF100_TAX_INOUT);
				}

				newDetailRecords[i].set('LOT_NO'			, record.LOT_NO);
				newDetailRecords[i].set('AGENT_TYPE'		, record.AGENT_TYPE);
				newDetailRecords[i].set('DEPT_CODE'			, record.DEPT_CODE);
				newDetailRecords[i].set('STOCK_CARE_YN'		, record.STOCK_CARE_YN);
				newDetailRecords[i].set('UPDATE_DB_USER'	, UserInfo.userID);
				newDetailRecords[i].set('RETURN_Q_YN'		, record.RETURN_Q_YN);
				newDetailRecords[i].set('SRC_ORDER_Q'		, record.ORDER_Q);
				newDetailRecords[i].set('EXCESS_RATE'		, record.EXCESS_RATE);
				newDetailRecords[i].set('PRICE_TYPE'		, record.PRICE_TYPE);
				newDetailRecords[i].set('INOUT_FOR_WGT_P'	, record.ISSUE_FOR_WGT_P);
				newDetailRecords[i].set('INOUT_FOR_VOL_P'	, record.ISSUE_FOR_VOL_P);
				newDetailRecords[i].set('INOUT_WGT_P'		, record.ISSUE_WGT_P);
				newDetailRecords[i].set('INOUT_VOL_P'		, record.ISSUE_VOL_P);
				newDetailRecords[i].set('WGT_UNIT'			, record.WGT_UNIT);
				newDetailRecords[i].set('UNIT_WGT'			, record.UNIT_WGT);
				newDetailRecords[i].set('VOL_UNIT'			, record.VOL_UNIT);
				newDetailRecords[i].set('UNIT_VOL'			, record.UNIT_VOL);

				//출고량(중량) 재계산
				var sInout_q	= newDetailRecords[i].get('ORDER_UNIT_Q');
				var sUnitWgt	= newDetailRecords[i].get('UNIT_WGT');
				var sOrderWgtQ	= sInout_q * sUnitWgt;
				newDetailRecords[i].set('INOUT_WGT_Q', sOrderWgtQ);

				//출고량(부피) 재계산
				var sUnitVol	= newDetailRecords[i].get('UNIT_VOL');
				var sOrderVolQ	= sInout_q * sUnitVol;
				newDetailRecords[i].set('INOUT_VOL_Q', sOrderVolQ);

				if(newDetailRecords[i].get('ACCOUNT_YNC') == 'N'){
					newDetailRecords[i].set('ORDER_UNIT_P', 0);
				} else {
					newDetailRecords[i].set('ORDER_UNIT_P', record.ISSUE_REQ_PRICE);
				}

				if(record.ORDER_Q != record.NOT_REQ_Q){
						UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], 'Q')
				} else {
					if(record.ACCOUNT_YNC == 'N'){
						newDetailRecords[i].set('ORDER_UNIT_O'	, 0);
						newDetailRecords[i].set('INOUT_TAX_AMT'	, 0);
					} else {
						newDetailRecords[i].set('ORDER_UNIT_O'	, record.ISSUE_REQ_AMT);
						newDetailRecords[i].set('INOUT_TAX_AMT'	, record.ISSUE_REQ_TAX_AMT);
					}
					//20171211 합계금액 표시를 위해 함수 호출
					UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], 'Q');
				}

				newDetailRecords[i].set('COMP_CODE'			, UserInfo.compCode);
				newDetailRecords[i].set('REMARK'			, record.REMARK);
				newDetailRecords[i].set('TRANS_COST'		, '0');
				newDetailRecords[i].set('ITEM_ACCOUNT'		, record.ITEM_ACCOUNT);
				newDetailRecords[i].set('GUBUN'				, 'FEFER');
				newDetailRecords[i].set('INOUT_TYPE_DETAIL'	, record.INOUT_TYPE_DETAIL);

				var lRate = record.TRANS_RATE;
				if(lRate == 0){
					lRate = 1;
				}
				newDetailRecords[i].set('STOCK_Q'		, record.STOCK_Q);
				newDetailRecords[i].set('ORDER_STOCK_Q'	, record.STOCK_Q / lRate);
				newDetailRecords[i].set('LOT_YN'		, record.LOT_YN);
				newDetailRecords[i].set('REMARK_INTER'	, record.REMARK_INTER);
				newDetailRecords[i].set('BUNDLE_NO'		, record.BUNDLE_NO);
				newDetailRecords[i].set('NUMBER'		, record.NUMBER);
			});
			detailStore.loadData(newDetailRecords, true);
			panelResult.setAllFieldsReadOnly(true);
			detailStore.fnOrderAmtSum();
		}
	}

	function beep() {
		audioCtx					= new(window.AudioContext || window.webkitAudioContext)();
		var oscillator				= audioCtx.createOscillator();
		var gainNode				= audioCtx.createGain();
		oscillator.connect(gainNode);
		gainNode.connect(audioCtx.destination);
		gainNode.gain.value			= 0.1;			//VOLUME 크기
		oscillator.frequency.value	= 4100;
		oscillator.type				= 'sine';		//sine, square, sawtooth, triangle
		oscillator.start();

		setTimeout(
			function() {
				oscillator.stop();
			},
			1000									//길이
		);
	};

	//메세지 창
	var alertSearch = Unilite.createSearchForm('alertSearch', {
		layout	: {
			type	: 'uniTable',
			columns	: 1,
			tdAttrs	: {width: '100%', align : 'center', style: 'background-color: #dfe8f6;'}	//cfd9e7
		},
		items	:[{
			xtype	: 'component',
			itemId	: 'TEXT_TEST',
			html	: '',
			width	: 330,
			height	: 50,
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
				layout	: {type: 'vbox', align: 'stretch'},
				items	: [alertSearch],
				width	: 350,
				height	: 120,
				listeners: {
					beforehide: function(me, eOpt) {
						alertSearch.clearForm();
					},
					beforeclose: function( panel, eOpts ) {
						alertSearch.clearForm();
					},
					beforeshow: function( panel, eOpts ) {
						alertSearch.down('#TEXT_TEST').setHtml(gsText);
					}
				}
			})
		}
		alertWindow.center();
		alertWindow.show();
	}
}
</script>