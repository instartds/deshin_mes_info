<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="str110ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="str110ukrv"/> 				<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>			<!-- 입고창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList"/>	<!-- 창고Cell-->
	<t:ExtComboStore comboType="AU" comboCode="A028"/>						<!-- 카드사 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>						<!-- 화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="B010"/>
	<t:ExtComboStore comboType="AU" comboCode="B013"/>						<!-- 판매단위-->
	<t:ExtComboStore comboType="AU" comboCode="B021"/>						<!-- 양불구분-->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>						<!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B030"/>						<!-- 세액포함여부-->
	<t:ExtComboStore comboType="AU" comboCode="B031"/>						<!-- 수불생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>						<!-- 과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="S002"/>						<!-- 판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="S008"/>						<!-- 반품유형-->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>						<!-- 담당(영업)-->
	<t:ExtComboStore comboType="AU" comboCode="S011"/>						<!-- 미매출마감여부-->
	<t:ExtComboStore comboType="AU" comboCode="S014"/>						<!-- 매출대상-->
	<t:ExtComboStore comboType="AU" comboCode="S024"/>						<!-- 부가세유형 -->
	<t:ExtComboStore comboType="AU" comboCode="YP09"/>						<!-- 판매형태-->
	<t:ExtComboStore comboType="OU"/>										<!-- 창고-->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>

<script type="text/javascript">
var searchInfoWindow;		//searchInfoWindow : 검색창
var referReturnWindow;		//참조내역
var salereferReturnWindow;	//참조내역(출고참조)
var alertWindow;			//alertWindow : 경고창
var isLoad = false;			//로딩 플래그 화폐단위 환율 change 로드시 계속 타므로 임시로 막음
var excelWindow;			//엑셀참조
var BsaCodeInfo = {
	gsAutoType			: '${gsAutoType}',
	gsMoneyUnit			: '${gsMoneyUnit}',
	gsVatRate			: ${gsVatRate},
	gsReturnDetailType	: '${gsReturnDetailType}',
	gsReturnAutoYN		: '${gsReturnAutoYN}',
	gsOptDivCode		: '${gsOptDivCode}',
	gsPringPgID			: '${gsPringPgID}',
	salePrsn			: ${salePrsn},
	inoutPrsn			: ${inoutPrsn},
	gsRefWhCode			: '${gsRefWhCode}',
	gsOutType			: ${gsOutType},
	gsSumTypeCell		: '${gsSumTypeCell}',
	gsRefMainWhCode		: '${gsRefMainWhCode}',
	gsBarcodeYn			: '${gsBarcodeYn}',
	gsItemStatusType	: '${gsItemStatusType}',
	gsSiteCode			: '${gsSiteCode}'		//20210331 추가
};

/*var output ='';
for(var key in BsaCodeInfo){
	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
Unilite.messageBox(output);*/
var sItemStatusType = BsaCodeInfo.gsItemStatusType;
if(Ext.isEmpty(sItemStatusType)){
	sItemStatusType = '2';
}
var CustomCodeInfo = {
	gsAgentType		: '',
	gsUnderCalBase	: '',
	gsTaxInout		: ''
};
var gsTaxInout = ''					//20210521 추가: 참조 적용 시, 각 record의 세액포함여부 이용해서 계산하기 위해 추가
var outDivCode = UserInfo.divCode;

/*var output ='';
for(var key in BsaCodeInfo){
	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
Unilite.messageBox(output);*/

function appMain() {
	/** 자동채번 여부
	 */
	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoOrderNum = true;
	}
	var sumtypeCell = true; //재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeCell =='Y') {
		sumtypeCell = false;
	}



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'str110ukrvService.selectDetailList',
			update	: 'str110ukrvService.updateDetail',
			create	: 'str110ukrvService.insertDetail',
			destroy	: 'str110ukrvService.deleteDetail',
			syncAll	: 'str110ukrvService.saveAll'
		}
	});



	/** 반품마스터 정보를 가지고 있는 Form
	 */
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
			holdable	: 'hold',
			value		: UserInfo.divCode,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelResult.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.returndate" default="반품일"/>',
			name		: 'INOUT_DATE',
			xtype		: 'uniDatefield',
			allowBlank	: false,
			value		: UniDate.get('today'),
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					//20191011 추가
					if(isLoad) {
						isLoad = false;
					} else {
						if(newValue && UniDate.getDbDateStr(newValue).length == 8 && !Ext.isEmpty(panelResult.getValue('MONEY_UNIT'))) {
							UniAppManager.app.fnExchngRateO();
						}
					}
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		:'<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			allowBlank		: false,
			validateBlank	: true,
			holdable		: 'hold',
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						CustomCodeInfo.gsAgentType		= records[0]["AGENT_TYPE"];//거래처분류
						CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"];//원미만계산
						CustomCodeInfo.gsTaxInout		= records[0]["TAX_TYPE"];	//세액포함여부
						//20191011 화폐, 환율 추가와 관련하여 로직 추가
						panelResult.setValue('MONEY_UNIT', records[0].MONEY_UNIT);
					},
					scope: this
				},
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						CustomCodeInfo.gsAgentType		= '';
						CustomCodeInfo.gsUnderCalBase	= '';
						CustomCodeInfo.gsTaxInout		= '';
						
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						CustomCodeInfo.gsAgentType		= '';
						CustomCodeInfo.gsUnderCalBase	= '';
						CustomCodeInfo.gsTaxInout		= '';
						
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),{
			//20191011 추가
			fieldLabel	: '<t:message code="system.label.sales.currency" default="화폐"/>',
			name		: 'MONEY_UNIT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B004',
			value		: UserInfo.currency,
			allowBlank	: false,
			displayField: 'value',
			holdable	: 'hold',
			fieldStyle	: 'text-align: center;',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					if(isLoad) {
                        isLoad = false;
					}else{
					   fnSetColumnFormat(newValue);
					}
				},
				blur: function( field, The, eOpts ) {
				}
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
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.returnno" default="반품번호"/>',
			name		: 'INOUT_NUM',
			xtype		: 'uniTextfield',
			readOnly	: isAutoOrderNum,
			allowBlank	: isAutoOrderNum,
//			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			//20191004 추가
			fieldLabel	: '<t:message code="system.label.sales.returnmanageno" default="반품관리번호"/>',
			name		: 'INSPEC_NUM',
			xtype		: 'uniTextfield',
//			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					//20200106 추가
					if(detailStore.data.length > 0) {
						var records = detailStore.data.items;
						Ext.each(records, function(record, index) {
							record.set('INSPEC_NUM', newValue);
						});
					}
				}
			}
		},{
			//20191011 추가
			fieldLabel	: '<t:message code="system.label.sales.exchangerate" default="환율"/>',
			name		: 'EXCHG_RATE_O',
			xtype		: 'uniNumberfield',
			type		: 'uniER',
			holdable	: 'hold',
			value		: 1,
			hidden		: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.returnwarehouse" default="반품창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			child		: 'WH_CELL_CODE',
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						})
					}else{
						store.filterBy(function(record){
							return false;
						})
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.returnwarehousecell" default="반품창고Cell"/>',
			name		: 'WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
//			colspan		: 2,
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{	//20210312 추가
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
					panelResult.setValue('CARD_CUSTOM_CODE', '');
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>',
			xtype		: 'uniRadiogroup',
			name		: 'ITEM_STATUS',
			holdable	: 'hold',
//			colspan		: 2,
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.defect" default="불량"/>',
				name		: 'ITEM_STATUS',
				inputValue	: '2',
				width		: 70/* ,
				checked		: true */
			},{
				boxLabel	: '<t:message code="system.label.sales.good" default="양품"/>',
				name		: 'ITEM_STATUS',
				inputValue	: '1',
				width		: 70
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.returntotalamount" default="반품총액"/>',
			name		: 'RETURN_AMT',
			xtype		: 'uniNumberfield',
			value		: '0',
			readOnly	: true,
			holdable	: 'hold'
		},{
			fieldLabel	: '<t:message code="system.label.sales.taxtotalamount" default="세액합계"/>',
			name		: 'VAT_AMT',
			xtype		: 'uniNumberfield',
			value		: '0',
			readOnly	: true,
			holdable	: 'hold'
		},{	//20210312 추가: 카드사
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
			fieldLabel	: '<t:message code="system.label.sales.barcode" default="바코드"/>',
			name		: 'BARCODE',
			xtype		: 'uniTextfield',
			fieldStyle	: 'IME-MODE: inactive',				//IE에서만 적용 됨
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				specialkey:function(field, event) {
					if(panelResult.setAllFieldsReadOnly(true) == false){
						return false;
					}
					if(event.getKey() == event.ENTER) {
						var newValue = panelResult.getValue('BARCODE');
						if(!Ext.isEmpty(newValue)) {
							Ext.getCmp('str110ukrvApp').mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
							detailGrid.focus();
							fnEnterBarcode(newValue);
							panelResult.setValue('BARCODE', '');
						}
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.sorefersetuse" default="수주참조 날짜set용"/>',
			name		: 'SET_ORDER_DATE',
			xtype		: 'uniDatefield',
			hidden		: true,
			value		: UniDate.get('today')
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
								//20191008 반품관리번호는 반품번호가 있을 때만 readOnly(true)
								if(item.name == 'INSPEC_NUM' && Ext.isEmpty(panelResult.getValue('INOUT_NUM'))) {
									item.setReadOnly(false);
								} else {
									item.setReadOnly(true);
								}
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
				//20191011 panelResult에 화폐, 환율 추가로 인해.. 행추가후에 참조 불가능 하도록 변경
				detailGrid.down('#excelBtn').disable();
				detailGrid.down('#saleReferBtn').disable();
				detailGrid.down('#estimateBtn').disable();

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
				//20191011 panelResult에 화폐, 환율 추가로 인해.. 행추가후에 참조 불가능 하도록 변경
				detailGrid.down('#excelBtn').enable();
				detailGrid.down('#saleReferBtn').enable();
				detailGrid.down('#estimateBtn').enable();
			}
			return r;
		}/*,
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}*/
	});



	/** 수주의 디테일 정보를 가지고 있는 Grid
	 */
	//마스터 모델 정의
	Unilite.defineModel('str110ukrvDetailModel', {
		fields: [
			{name: 'INOUT_SEQ'					,text: '<t:message code="system.label.sales.seq" default="순번"/>'						,type: 'int', allowBlank: false},
			{name: 'INOUT_TYPE_DETAIL'			,text: '<t:message code="system.label.sales.returntype" default="반품유형"/>'				,type: 'string', comboType: 'AU', comboCode: 'S008', defaultValue: Ext.data.StoreManager.lookup('CBS_AU_S008').getAt(0).get('value'), allowBlank: false},
			{name: 'WH_CODE'					,text: '<t:message code="system.label.sales.returnwarehouse" default="반품창고"/>'			,type: 'string', comboType   : 'OU', allowBlank: false, child: 'WH_CELL_CODE'},
			{name: 'WH_CELL_CODE'				,text: '<t:message code="system.label.sales.returnwarehousecell" default="반품창고Cell"/>'	,type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','SALE_DIV_CODE']},
			{name: 'ITEM_CODE'					,text: '<t:message code="system.label.sales.item" default="품목"/>'						,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'					,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'SPEC'						,text: '<t:message code="system.label.sales.spec" default="규격"/>'						,type: 'string'},
			{name: 'ORDER_UNIT'					,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'				,type: 'string', comboType: 'AU', comboCode: 'B013', allowBlank: false, displayField: 'value'},
			{name: 'TRNS_RATE'					,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				,type: 'uniQty', defaultValue: 1, allowBlank: false},
			{name: 'ORDER_UNIT_Q'				,text: '<t:message code="system.label.sales.returnqty" default="반품량"/>'					,type: 'uniQty', defaultValue: 0, allowBlank: false},
			{name: 'ORDER_UNIT_P'				,text: '<t:message code="system.label.sales.price" default="단가"/>'						,type: 'uniUnitPrice', defaultValue: 0},
			{name: 'ORDER_UNIT_O'				,text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'				,type: 'uniPrice', defaultValue: 0},
			{name: 'ORDER_AMT_SUM'				,text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'				,type: 'uniPrice', defaultValue: 0},
			//20191011 추가: EXCHANGE_AMOUNT - ˂t:message code="system.label.sales.exchangeamount" default="환산액"/˃
			{name: 'EXCHANGE_AMOUNT'			,text: '<t:message code="system.label.sales.exchangeamount" default="환산액"/>'			,type: 'uniPrice', defaultValue: 0},
			{name: 'TAX_TYPE'					,text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'			,type: 'string', comboType: 'AU', comboCode: 'B059', defaultValue: '1', allowBlank: false},
			{name: 'INOUT_TAX_AMT'				,text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'				,type: 'uniPrice', defaultValue: 0},
			{name: 'ORDER_O_TAX_O'				,text: '<t:message code="system.label.sales.returntotal" default="반품계"/>'				,type: 'uniPrice', defaultValue: 0},
			{name: 'DISCOUNT_RATE'				,text: '<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'			,type: 'uniPercent', defaultValue: 0},
			{name: 'ITEM_STATUS'				,text: '<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>'			,type: 'string', comboType: 'AU', comboCode: 'B021', defaultValue: '2', allowBlank: false},
			{name: 'ACCOUNT_YNC'				,text: '<t:message code="system.label.sales.salessubject" default="매출대상"/>'				,type: 'string', comboType: 'AU', comboCode: 'S014', allowBlank: false},
			{name: 'ORDER_NUM'					,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'						,type: 'string'},
			{name: 'ORDER_SEQ'					,text: '<t:message code="system.label.sales.seq" default="순번"/>'						,type: 'int'},
			{name: 'SALE_DIV_CODE'				,text: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>'			,type: 'string', allowBlank: false, child: 'WH_CODE'},
			{name: 'SALE_CUSTOM_CODE'			,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'				,type: 'string', allowBlank: false},
			{name: 'SALE_CUSTOM_NAME'			,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'				,type: 'string'},
			{name: 'DVRY_CUST_CD'				,text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'				,type: 'string'},
			{name: 'DVRY_CUST_NM'				,text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'				,type: 'string'},
			{name: 'PROJECT_NO'					,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				,type: 'string'},
			//20200106 프로젝트명 추가
			{name: 'PJT_NAME'					,text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>'				,type: 'string', editable: false},
			{name: 'LOT_NO'						,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'					,type: 'string'},
			{name: 'REMARK'						,text: '<t:message code="system.label.sales.remarks" default="비고"/>'					,type: 'string'},
			{name: 'STOCK_UNIT'					,text: 'STOCK_UNIT'					,type: 'string'},
			{name: 'DIV_CODE'					,text: 'DIV_CODE'					,type: 'string', allowBlank: false, defaultValue: UserInfo.divCode},
			{name: 'INOUT_NUM'					,text: 'INOUT_NUM'					,type: 'string', allowBlank: isAutoOrderNum},
			{name: 'INOUT_TYPE'					,text: 'INOUT_TYPE'					,type: 'string', defaultValue: '3', allowBlank: false},
			{name: 'INOUT_METH'					,text: 'INOUT_METH'					,type: 'string', defaultValue: '2', allowBlank: false},
			{name: 'INOUT_CODE_TYPE'			,text: 'INOUT_CODE_TYPE'			,type: 'string', defaultValue: '4', allowBlank: false},
			{name: 'INOUT_CODE'					,text: 'INOUT_CODE'					,type: 'string', allowBlank: false},
			{name: 'INOUT_DATE'					,text: 'INOUT_DATE'					,type: 'uniDate', allowBlank: false},
			{name: 'INOUT_Q'					,text: 'INOUT_Q'					,type: 'uniQty'},
			{name: 'INOUT_P'					,text: 'INOUT_P'					,type: 'uniUnitPrice'},
			{name: 'INOUT_I'					,text: 'INOUT_I'					,type: 'uniPrice'},
			{name: 'MONEY_UNIT'					,text: 'MONEY_UNIT'					,type: 'string', defaultValue: BsaCodeInfo.gsMoneyUnit, allowBlank: false},
			{name: 'INOUT_FOR_P'				,text: 'INOUT_FOR_P'				,type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O'				,text: 'INOUT_FOR_O'				,type: 'uniPrice'},
			//20190618 환율 type 변경
//			{name: 'EXCHG_RATE_O'				,text: 'EXCHG_RATE_O'				,type: 'int', defaultValue: 1, allowBlank: false},
			{name: 'EXCHG_RATE_O'				,text: 'EXCHG_RATE_O'				,type: 'uniER', allowBlank: false},
			{name: 'INOUT_PRSN'					,text: 'INOUT_PRSN'					,type: 'string', allowBlank: false},
			{name: 'ACCOUNT_Q'					,text: 'ACCOUNT_Q'					,type: 'uniQty', defaultValue: 0},
			{name: 'BILL_TYPE'					,text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'					, type: 'string', comboType: 'AU', comboCode: 'S024', allowBlank: false},
			{name: 'SALE_TYPE'					,text: 'SALE_TYPE'					,type: 'string', allowBlank: false, defaultValue: Ext.data.StoreManager.lookup('CBS_AU_S002').getAt(0).get('value')},
			{name: 'PRICE_YN'					,text: 'PRICE_YN'					,type: 'string', defaultValue: '2', allowBlank: false},
			{name: 'UPDATE_DB_USER'				,text: 'UPDATE_DB_USER'				,type: 'string', defaultValue: UserInfo.userID, allowBlank: false},
			{name: 'UPDATE_DB_TIME'				,text: 'UPDATE_DB_TIME'				,type: 'string'},
			{name: 'STOCK_CARE_YN'				,text: 'STOCK_CARE_YN'				,type: 'string'},
			{name: 'SOF100_TAX_INOUT'			,text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>'		,type: 'string', comboType: 'AU', comboCode: 'B030', defaultValue: CustomCodeInfo.gsTaxInout},
			{name: 'BILL_NUM'					,text: 'BILL_NUM'					,type: 'string'},
			{name: 'SSA110T_INOUT_TYPE_DETAIL'	,text: 'SSA110T_INOUT_TYPE_DETAIL'	,type: 'string'},
			{name: 'SALE_PRSN'					,text: 'SALE_PRSN'					,type: 'string'},
			{name: 'REF_BILL_TYPE'				,text: 'REF_BILL_TYPE'				,type: 'string', defaultValue: '10'},
			{name: 'REF_SALE_TYPE'				,text: 'REF_SALE_TYPE'				,type: 'string', defaultValue: Ext.data.StoreManager.lookup('CBS_AU_S002').getAt(0).get('value')},
			{name: 'AGENT_TYPE'					,text: 'AGENT_TYPE'					,type: 'string'},
			{name: 'DEPT_CODE'					,text: 'DEPT_CODE'					,type: 'string'},
			{name: 'ITEM_ACCOUNT'				,text: 'ITEM_ACCOUNT'				,type: 'string'},
			{name: 'COMP_CODE'					,text: 'COMP_CODE'					,type: 'string', defaultValue: UserInfo.compCode, allowBlank: false},
//			{name: 'TEMP_ORDER_UNIT_Q'			,text: 'TEMP_ORDER_UNIT_Q'			,type: 'uniQty'},//LOT팝업에서 허용된 수량만 입력하기 위해..
			{name: 'LOT_ASSIGNED_YN'			,text: 'LOT_ASSIGNED_YN'			,type: 'string'},	//lot팝업에서 선택시 N로 set..
			{name: 'SALE_BASIS_P'				,text: '<t:message code="system.label.sales.sellingprice" default="판매단가"/>'				,type: 'uniUnitPrice', editable: false},
//			{name: 'PURCHASE_RATE'				,text: '<t:message code="system.label.sales.purchaserate" default="매입율"/>'				,type: 'uniPercent', editable: false},
//			{name: 'PURCHASE_P'					,text: '<t:message code="system.label.sales.purchaseprice" default="매입가"/>'				,type: 'uniUnitPrice', editable: false},
//			{name: 'SALES_TYPE'					,text: '판매형태'						,type: 'string', comboType:'AU', comboCode:'YP09', editable: false},
//			{name: 'PURCHASE_CUSTOM_CODE'		,text:'<t:message code="system.label.sales.purchaseplace" default="매입처"/>'				,type: 'string', comboType:'AU', editable: false},
//			{name: 'PURCHASE_TYPE'				,text:'<t:message code="system.label.sales.purchasecondition" default="매입조건"/>'			,type: 'string', comboType:'AU', comboCode:'YP09', editable: false}
			{name: 'LOT_YN'						, text:'LOT_YN'						,type: 'string'},
			{name: 'BASIS_NUM'					, text:'BASIS_NUM'					,type: 'string'},
			{name: 'BASIS_SEQ'					, text:'BASIS_SEQ'					,type: 'int'},
			//20191004 추가(반품관리번호 저장용 컬럼 선언)
			{name: 'INSPEC_NUM'					, text:'INSPEC_NUM'					,type: 'string'},
			{name: 'CARD_CUSTOM_CODE'			, text:'카드사'						,type: 'string', comboType: 'AU', comboCode: 'A028'}	//20210312 추가
		]
	});
	//마스터 스토어 정의
	var detailStore = Unilite.createStore('str110ukrvDetailStore', {
		model: 'str110ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {
						//20200115 양불구분 값 set하는 로직 추가
						panelResult.setValue('ITEM_STATUS', records[0].get('ITEM_STATUS'));
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

			var isErr = false;
			Ext.each(list, function(record, index) {
				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
					Unilite.messageBox((index + 1) + '<t:message code="system.message.commonJS.grid.invalidColumn" default="행의 입력값을 확인해 주세요."/>' + '\n' + 'LOT NO: ' + '<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					isErr = true;
					return false;
				}
				if(!Ext.isEmpty(panelResult.getValue('INSPEC_NUM'))) {
					record.set('INSPEC_NUM', panelResult.getValue('INSPEC_NUM'));
				}
				//20210318 추가: 매출대상 여부가 'Y'이면 단가 필수 체크로직 추가
				if(record.get('ACCOUNT_YNC') == 'Y' && (Ext.isEmpty(record.get('ORDER_UNIT_P')) || record.get('ORDER_UNIT_P') == 0)){
					Unilite.messageBox((index + 1) + '<t:message code="system.message.commonJS.grid.invalidColumn" default="행의 입력값을 확인해 주세요."/>' + '\n' + '단가: ' + '<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					isErr = true;
					return false;
				}
			});
			if(isErr) return false;

//			var orderNum = panelResult.getValue('ORDER_NUM');
//			Ext.each(list, function(record, index) {
//				if(record.data['ORDER_NUM'] != orderNum) {
//					record.set('ORDER_NUM', orderNum);
//				}
//			})
//			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("INOUT_NUM", master.INOUT_NUM);

						//3.기타 처리
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
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				this.fnOrderAmtSum();
//				var viewNormal = detailGrid.getView();
//				viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
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
			console.log("=============Exec fnOrderAmtSum()");
			var sumOrder = Ext.isNumeric(this.sum('ORDER_UNIT_O')) ? this.sum('ORDER_UNIT_O'):0;
			var sumTax = Ext.isNumeric(this.sum('INOUT_TAX_AMT')) ? this.sum('INOUT_TAX_AMT'):0;
			panelResult.setValue('RETURN_AMT',sumOrder);
			panelResult.setValue('VAT_AMT',sumTax);
		}
	});
	//마스터 그리드 정의
	var detailGrid = Unilite.createGrid('str110ukrvGrid', {
		layout: 'fit',
		region: 'center',
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
			copiedRow: true
		},
		tbar: [{
			itemId: 'excelBtn',
			text: '<div style="color: blue"><t:message code="system.label.sales.excelrefer" default="엑셀참조"/></div>',
			handler: function() {
					openExcelWindow();
			}
		},{
			itemId : 'saleReferBtn',
			text:'<div style="color: blue"><t:message code="system.label.sales.issuerefer" default="출고참조"/></div>',
			handler: function() {
				openSaleReferWindow();
				}
		},'-',{
			itemId : 'estimateBtn',
			text:'<div style="color: blue"><t:message code="system.label.sales.sorefer" default="수주참조"/></div>',
			handler: function() {
				openOrderReferWindow();
			}
		}],
		store: detailStore,	//ORDER_UNIT_P	TRNS_RATE	DISCOUNT_RATE
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal',	ftype: 'uniSummary',	  showSummaryRow: true} ],
		columns: [
			{ dataIndex: 'INOUT_SEQ'				,width: 60, align: 'center'},
				{ dataIndex: 'INOUT_TYPE_DETAIL'	,width: 80, align: 'center'},
				{ dataIndex: 'WH_CODE'				,width: 100,
					listeners:{
						render:function(elm) {
							elm.editor.on(
								'beforequery',function(queryPlan, eOpts) {
									var store = queryPlan.combo.store;
									store.clearFilter();
									store.filterBy(function(item){
										return item.get('option') == panelResult.getValue('DIV_CODE');
									})
								}
							)
						}
					}
				},
				{ dataIndex: 'WH_CELL_CODE'			,width: 100, hidden: sumtypeCell,
					//20200115 추가: 조회 할 때, 변경된 WH_CODE에 맞는 WH_CELL_CODE SET하기 위해 수정
					renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
						combo.store.clearFilter();
						combo.store.filterBy(function(item){
							return item.get('option') == record.get('WH_CODE')
								//BSA225T의 CUSTOM_CODE가 비어 있거나 panelResult의 값과 동일한 데이터만 show
								&&(item.get('refCode10') == Ext.isEmpty(record.get('INOUT_CODE')) ? panelResult.getValue('CUSTOM_CODE') : record.get('INOUT_CODE') || item.get('refCode10') == '*')
						})
					}
				},
				{ dataIndex: 'ITEM_CODE'			,width: 100,
					editor: Unilite.popup('DIV_PUMOK_G', {
						textFieldName: 'ITEM_CODE',
						DBtextFieldName: 'ITEM_CODE',
						useBarcodeScanner: false,
	//					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
						autoPopup: true,
						listeners: {
							'onSelected': {
								fn: function(records, type) {
									console.log('records : ', records);
									Ext.each(records, function(record,i) {
										console.log('record',record);
										if(i==0) {
											detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
											var grdRecord = detailGrid.uniOpt.currentRecord;
											UniSales.fnGetPriceInfo2( grdRecord
																	, UniAppManager.app.cbGetPriceInfo
																	,'I'
																	,UserInfo.compCode
																	,grdRecord.get('INOUT_CODE')
																	,CustomCodeInfo.gsAgentType
																	,record['ITEM_CODE']
																	,BsaCodeInfo.gsMoneyUnit
																	,record['ORDER_UNIT']
																	,record['STOCK_UNIT']
																	,record['TRANS_RATE']
																	,UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'))
																	)
										} else {
											UniAppManager.app.onNewDataButtonDown();
											detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
											var grdRecord = detailGrid.getSelectedRecord();
											UniSales.fnGetPriceInfo2( grdRecord
																	, UniAppManager.app.cbGetPriceInfo
																	,'I'
																	,UserInfo.compCode
																	,grdRecord.get('INOUT_CODE')
																	,CustomCodeInfo.gsAgentType
																	,record['ITEM_CODE']
																	,BsaCodeInfo.gsMoneyUnit
																	,record['ORDER_UNIT']
																	,record['STOCK_UNIT']
																	,record['TRANS_RATE']
																	,UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'))
																	)
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
				{ dataIndex: 'ITEM_NAME'			,width: 200,
					editor: Unilite.popup('DIV_PUMOK_G', {
						extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
						autoPopup: true,
						listeners: {
							'onSelected': {
								fn: function(records, type) {
									console.log('records : ', records);
									Ext.each(records, function(record,i) {
										console.log('record',record);
										if(i==0) {
											detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
											var grdRecord = detailGrid.uniOpt.currentRecord;
											UniSales.fnGetPriceInfo2( grdRecord
																	, UniAppManager.app.cbGetPriceInfo
																	,'I'
																	,UserInfo.compCode
																	,grdRecord.get('INOUT_CODE')
																	,CustomCodeInfo.gsAgentType
																	,record['ITEM_CODE']
																	,BsaCodeInfo.gsMoneyUnit
																	,record['ORDER_UNIT']
																	,record['STOCK_UNIT']
																	,record['TRANS_RATE']
																	,UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'))
																	)
										} else {
											UniAppManager.app.onNewDataButtonDown();
											detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
											var grdRecord = detailGrid.getSelectedRecord();
											UniSales.fnGetPriceInfo2( grdRecord
																	, UniAppManager.app.cbGetPriceInfo
																	,'I'
																	,UserInfo.compCode
																	,grdRecord.get('INOUT_CODE')
																	,CustomCodeInfo.gsAgentType
																	,record['ITEM_CODE']
																	,BsaCodeInfo.gsMoneyUnit
																	,record['ORDER_UNIT']
																	,record['STOCK_UNIT']
																	,record['TRANS_RATE']
																	,UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'))
																	)
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
				{ dataIndex: 'SPEC'					,width: 150,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
					}
				},
				{ dataIndex: 'LOT_NO'				,width:120 },
//				{ dataIndex: 'SALE_BASIS_P'			,width:90 },
//				{ dataIndex: 'DISCOUNT_RATE'		,width: 66},
				{ dataIndex: 'ORDER_UNIT_P'			,width: 93	, summaryType: 'sum'},
				{ dataIndex: 'ORDER_UNIT_Q'			,width: 93	, summaryType: 'sum'},
				{ dataIndex: 'ORDER_UNIT_O'			,width: 100	, summaryType: 'sum'},
				{ dataIndex: 'INOUT_TAX_AMT'		,width: 100	, summaryType: 'sum'},
				{ dataIndex: 'ORDER_AMT_SUM'		,width: 100	, summaryType: 'sum'},
				{ dataIndex: 'BILL_TYPE'			,width: 100	, align: 'center'},
				{ dataIndex: 'CARD_CUSTOM_CODE'		,width: 100	, align: 'center'},	//20210223 추가
				//20191011 추가: EXCHANGE_AMOUNT - ˂t:message code="system.label.sales.exchangeamount" default="환산액"/˃
				{ dataIndex: 'EXCHANGE_AMOUNT'		,width: 100	, summaryType: 'sum'},
				{ dataIndex: 'TAX_TYPE'				,width: 73	, align: 'center' },
//				{ dataIndex: 'PURCHASE_RATE'		,width:90 },
//				{ dataIndex: 'PURCHASE_P'			,width:90 },
//				{ dataIndex: 'SALES_TYPE'			,width:70 },
				{ dataIndex: 'ORDER_UNIT'			,width: 80	, align: 'center'},
				{ dataIndex: 'TRNS_RATE'			,width: 73	, summaryType: 'sum'},
				{ dataIndex: 'ORDER_O_TAX_O'		,width: 100	, summaryType: 'sum', hidden: true},
				{ dataIndex: 'ITEM_STATUS'			,width: 80	, align: 'center'},
				{ dataIndex: 'ACCOUNT_YNC'			,width: 80	, align: 'center'},
				{ dataIndex: 'SOF100_TAX_INOUT'		,width: 100, align: 'center'},
				{ dataIndex: 'ORDER_NUM'			,width: 120},
				{ dataIndex: 'ORDER_SEQ'			,width: 66	, align: 'center'},
				{ dataIndex: 'SALE_DIV_CODE'		,width: 66	, hidden: true},
				{ dataIndex: 'SALE_CUSTOM_CODE'		,width: 66	, hidden: true},
				{ dataIndex: 'SALE_CUSTOM_NAME'		,width: 100},
				{ dataIndex: 'DVRY_CUST_CD'			,width: 66	, hidden: true},
				{ dataIndex: 'DVRY_CUST_NM'			,width: 100},
				{ dataIndex: 'PROJECT_NO'			,width: 100,
					editor: Unilite.popup('PROJECT_G', {
//						extParam		: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
						autoPopup		: true,
						listeners		: {
							'onSelected': {
								fn: function(records, type) {
									console.log('records : ', records);
									Ext.each(records, function(record,i) {
										console.log('record',record);
										if(i==0) {
											detailGrid.setProjectData(record,false);
										} else {
											UniAppManager.app.onNewDataButtonDown();
											detailGrid.setProjectData(record,false);
										}
									});
								},
								scope: this
								},
							'onClear': function(type) {
								detailGrid.setProjectData(null,true);
							},
							applyextparam: function(popup){
								popup.setExtParam({SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'});
							}
						}
					})
				},
				//20200106 프로젝트명 추가
				{ dataIndex: 'PJT_NAME'				,width: 120},
				{ dataIndex: 'REMARK'				,width: 200},
				{ dataIndex: 'STOCK_UNIT'			,width: 60	, hidden: true},
				{ dataIndex: 'DIV_CODE'				,width: 60	, hidden: true},
				{ dataIndex: 'INOUT_NUM'			,width: 60	, hidden: true},
				{ dataIndex: 'INOUT_TYPE'			,width: 60	, hidden: true},
				{ dataIndex: 'INOUT_METH'			,width: 60	, hidden: true},
				{ dataIndex: 'INOUT_CODE_TYPE'		,width: 60	, hidden: true},
				{ dataIndex: 'INOUT_CODE'			,width: 60	, hidden: true},
				{ dataIndex: 'INOUT_DATE'			,width: 60	, hidden: true},
				{ dataIndex: 'INOUT_Q'				,width: 60	, hidden: true},
				{ dataIndex: 'INOUT_P'				,width: 60	, hidden: true},
				{ dataIndex: 'INOUT_I'				,width: 60	, hidden: true},
				{ dataIndex: 'MONEY_UNIT'			,width: 60	, hidden: true},
				{ dataIndex: 'INOUT_FOR_P'			,width: 60	, hidden: true},
				{ dataIndex: 'INOUT_FOR_O'			,width: 60	, hidden: true},
				{ dataIndex: 'EXCHG_RATE_O'			,width: 60	, hidden: true},
				{ dataIndex: 'INOUT_PRSN'			,width: 60	, hidden: true},
				{ dataIndex: 'ACCOUNT_Q'			,width: 60	, hidden: true},
				{ dataIndex: 'SALE_TYPE'			,width: 60	, hidden: true},
				{ dataIndex: 'PRICE_YN'				,width: 60	, hidden: true},
				{ dataIndex: 'UPDATE_DB_USER'		,width: 60	, hidden: true},
				{ dataIndex: 'UPDATE_DB_TIME'		,width: 60	, hidden: true},
				{ dataIndex: 'STOCK_CARE_YN'		,width: 60	, hidden: true},
				{ dataIndex: 'BILL_NUM'				,width: 80	, hidden: true},
				{ dataIndex: 'SSA110T_INOUT_TYPE_DETAIL'	,width: 80, hidden: true},
				{ dataIndex: 'SALE_PRSN'			,width: 80	, hidden: true},
				{ dataIndex: 'REF_BILL_TYPE'		,width: 6	, hidden: true},
				{ dataIndex: 'REF_SALE_TYPE'		,width: 6	, hidden: true},
				{ dataIndex: 'AGENT_TYPE'			,width: 80	, hidden: true},
				{ dataIndex: 'DEPT_CODE'			,width: 80	, hidden: true},
				{ dataIndex: 'ITEM_ACCOUNT'			,width: 80	, hidden: true},
				{ dataIndex: 'COMP_CODE'			,width: 80	, hidden: true},
//				{ dataIndex: 'TEMP_ORDER_UNIT_Q'	,width: 90	,hidden: true  },
				{ dataIndex: 'LOT_ASSIGNED_YN'		,width: 100	,hidden: true },
				{ dataIndex: 'LOT_YN'				,width: 100	,hidden: true },
				{ dataIndex: 'BASIS_NUM'			,width: 100	,hidden: true},
				{ dataIndex: 'BASIS_SEQ'			,width: 100	,hidden: true}
//				{dataIndex: 'PURCHASE_CUSTOM_CODE'	,width: 66	, hidden: true },
//				{dataIndex: 'PURCHASE_TYPE'			,width: 66	, hidden: true }
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field,['BILL_TYPE','CARD_CUSTOM_CODE'])) {	//20210223 추가
					return true;
				}
				if (UniUtils.indexOf(e.field,['EXCHANGE_AMOUNT','ORDER_AMT_SUM'])) {
					return false;
				}
				if(e.record.phantom){			//신규일때
					if (UniUtils.indexOf(e.field,
											['SPEC','SOF100_TAX_INOUT','ORDER_NUM','ORDER_SEQ','ORDER_O_TAX_O','SALE_DIV_CODE',
											 'SALE_CUSTOM_CODE','SALE_CUSTOM_NAME','DVRY_CUST_CD','DVRY_CUST_NM']) )
							return false;
					if(!Ext.isEmpty(e.record.data.ORDER_NUM)){
						if (UniUtils.indexOf(e.field,
											['ORDER_UNIT','TRNS_RATE']) )
							return false;
					}
				}else{
					if (e.field == 'LOT_NO'){
						return false;
					}
					if(e.record.data.ACCOUNT_Q > 0 && BsaCodeInfo.gsReturnAutoYN == "N"){
						if (UniUtils.indexOf(e.field,
											['INOUT_SEQ','WH_CODE','ITEM_CODE','ITEM_NAME','SPEC',
											 'ORDER_UNIT','TRNS_RATE','ORDER_UNIT_Q','ORDER_UNIT_P','ORDER_UNIT_O','TAX_TYPE',
											 'INOUT_TAX_AMT','ORDER_O_TAX_O','DISCOUNT_RATE','ITEM_STATUS','ORDER_NUM',
											 'ORDER_SEQ','SALE_DIV_CODE','SALE_CUSTOM_CODE','SALE_CUSTOM_NAME','DVRY_CUST_CD','DVRY_CUST_NM',
											 'PROJECT_NO','LOT_NO','REMARK','STOCK_UNIT','DIV_CODE','INOUT_NUM','INOUT_TYPE','INOUT_METH',
											 'INOUT_CODE_TYPE','INOUT_CODE','INOUT_DATE','INOUT_Q','INOUT_P','INOUT_I','MONEY_UNIT',
											 'INOUT_FOR_P','INOUT_FOR_O','EXCHG_RATE_O','INOUT_PRSN','ACCOUNT_Q','BILL_TYPE','SALE_TYPE','PRICE_YN',
											 'UPDATE_DB_USER','UPDATE_DB_TIME','STOCK_CARE_YN','SOF100_TAX_INOUT','BILL_NUM','SSA110T_INOUT_TYPE_DETAIL',
											 'SALE_PRSN','REF_BILL_TYPE','REF_SALE_TYPE','AGENT_TYPE','DEPT_CODE','ITEM_ACCOUNT','COMP_CODE']) )
							return false;
					}else{
						if (UniUtils.indexOf(e.field,
											['SPEC','WH_CODE','INOUT_SEQ','ORDER_NUM','ORDER_SEQ','ITEM_CODE',
											 'ITEM_NAME','ITEM_STATUS','SOF100_TAX_INOUT','ORDER_O_TAX_O','SALE_DIV_CODE',
											 'SALE_CUSTOM_CODE','SALE_CUSTOM_NAME','DVRY_CUST_CD','DVRY_CUST_NM']) )
							return false;
					}
					if(!Ext.isEmpty(e.record.data.ORDER_NUM)) {
						if (UniUtils.indexOf(e.field,
											['ORDER_UNIT','TRNS_RATE','PROJECT_NO']) )
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
				grdRecord.set('ORDER_UNIT_Q'	,0);
				grdRecord.set('ORDER_UNIT_p'	,0);
				grdRecord.set('ORDER_UNIT_O'	,0);
				grdRecord.set('INOUT_TAX_AMT'	,0);
				grdRecord.set('STOCK_UNIT'		,"");
//				grdRecord.set('WH_CODE'			,"");
				//20200204 수정
//				grdRecord.set('TAX_TYPE'		,1);
				grdRecord.set('TAX_TYPE'		,'');
				grdRecord.set('TRNS_RATE'		,1);
				grdRecord.set('STOCK_CARE_YN'	,"");
				grdRecord.set('SALE_BASIS_P'	,0);
				grdRecord.set('LOT_YN'	 , '');
			} else {
//				var sRefWhCode = ''
//				if(BsaCodeInfo.gsRefWhCode == "2"){
//					sRefWhCode = Ext.data.StoreManager.lookup('whList').getAt(0).get('value'); //창고콤보value중 첫번째 value
//				}
//				if(Ext.isEmpty(grdRecord.get('WH_CODE'))){		//창고를 이미 입력했을 경우는 창고정보를 적용하지 않는다.
//					if(BsaCodeInfo.gsRefWhCode == "2"){
//						grdRecord.set('WH_CODE'			, sRefWhCode);	//창고의 첫번째value
//					}else{
//						grdRecord.set('WH_CODE', record['WH_CODE']);	//품목의 주창고
//					 }
//				}
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('ORDER_UNIT'			, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				//20200204 수정: 과세구분이 비어있을 때만 과세구분값 set
				if(Ext.isEmpty(record['TAX_TYPE'])) {
					grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);
				}
				grdRecord.set('STOCK_CARE_YN'		, record['STOCK_CARE_YN']);
				grdRecord.set('DIV_CODE'			, record['DIV_CODE']);

				if(Ext.isEmpty(record['WGT_UNIT'])){
					grdRecord.set('WGT_UNIT'			, '');
					grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
				}else{
					grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
					grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
				}

				if(Ext.isEmpty(record['VOL_UNIT'])){
					grdRecord.set('VOL_UNIT'			, '');
					grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
				}else{
					grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
					grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
				}
				grdRecord.set('LOT_YN'	 , record['LOT_YN']);
				UniSales.fnGetDivPriceInfo2(grdRecord, UniAppManager.app.cbGetPriceInfo
											,'I'
											,UserInfo.compCode
											,grdRecord.get('INOUT_CODE')
											,CustomCodeInfo.gsAgentType
											,grdRecord.get('ITEM_CODE')
											,BsaCodeInfo.gsMoneyUnit
											,grdRecord.get('ORDER_UNIT')
											,grdRecord.get('STOCK_UNIT')
											,record['TRANS_RATE']
											,UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'))
											,grdRecord.get('WGT_UNIT')
											,grdRecord.get('VOL_UNIT')
											)

			}
		},
		//수주참조
		setOrderRefer:function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('INOUT_NUM'			, panelResult.getValue('INOUT_NUM'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);
			grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);
			grdRecord.set('ORDER_UNIT_Q'		, record['ENRETURN_Q']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_P']);
			grdRecord.set('WH_CODE'				, panelResult.getValue('WH_CODE'));
			grdRecord.set('INOUT_TYPE_DETAIL'	, Ext.data.StoreManager.lookup('CBS_AU_S008').getAt(0).get('value'));
			grdRecord.set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
			grdRecord.set('INOUT_METH'			, '1');
			if(BsaCodeInfo.gsOptDivCode == "1"){
				grdRecord.set('SALE_DIV_CODE'	, record['OUT_DIV_CODE']);
			}else{
				grdRecord.set('SALE_DIV_CODE'	, record['DIV_CODE']);
			}
			grdRecord.set('SALE_CUSTOM_CODE'	, record['SALE_CUST_CD']);
			grdRecord.set('SALE_CUSTOM_NAME'	, record['SALE_CUST_NM']);
			grdRecord.set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);
			grdRecord.set('DVRY_CUST_NM'		, record['DVRY_CUST_NM']);
			grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
			grdRecord.set('SOF100_TAX_INOUT'	, record['TAX_INOUT']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['SER_NO']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			//20200106 추가
			grdRecord.set('PJT_NAME'			, record['PJT_NAME']);
			grdRecord.set('STOCK_CARE_YN'		, record['STOCK_CARE_YN']);
			grdRecord.set('SALE_PRSN'			, record['ORDER_PRSN_CD']);
			grdRecord.set('REF_BILL_TYPE'		, record['BILL_TYPE']);
			grdRecord.set('REF_SALE_TYPE'		, record['ORDER_TYPE_CD']);
			grdRecord.set('BILL_TYPE'			, '10');
			//20200417 수정: 통화가 같으면 첫번째 값 아니면 40(직수출)
			grdRecord.set('SALE_TYPE'			, panelResult.getValue('MONEY_UNIT') == BsaCodeInfo.gsMoneyUnit ? Ext.data.StoreManager.lookup('CBS_AU_S002').getAt(0).get('value') : '40');
			grdRecord.set('AGENT_TYPE'			, record['AGENT_TYPE']);
			grdRecord.set('DEPT_CODE'			, record['DEPT_CODE']);
			//20191014 수정
			grdRecord.set('MONEY_UNIT'			, panelResult.getValue('MONEY_UNIT'));	//record['MONEY_UNIT']);;
			//20191014 수정
			if(!Ext.isEmpty(panelResult.getValue('EXCHG_RATE_O'))) {
				grdRecord.set('EXCHG_RATE_O'	, panelResult.getValue('EXCHG_RATE_O'));	//record['EXCHG_RATE_O']);
			} else {
				grdRecord.set('EXCHG_RATE_O'	, record['EXCHG_RATE_O']);
			}
			//20210521 추가: 세액포함여부 계산하기 위해서 추가
			gsTaxInout = Ext.isEmpty(record['TAX_INOUT']) ? '' : record['TAX_INOUT'];
//			//20190618 추가: MONEY_UNIT, EXCHG_RATE_O
//			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);;
//			grdRecord.set('EXCHG_RATE_O'		, record['EXCHG_RATE_O']);

			UniAppManager.app.fnOrderAmtCal(grdRecord, "P");
		},
		//출고참조
		setSaleRefer:function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('INOUT_NUM'			, panelResult.getValue('INOUT_NUM'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);
			grdRecord.set('ORDER_UNIT_Q'		, record['ENRETURN_Q']);
			grdRecord.set('ORDER_UNIT_P'		, record['INOUT_P']);
			if(BsaCodeInfo.gsRefMainWhCode.toUpperCase() == 'Y'){
				grdRecord.set('WH_CODE'			, record['MAIN_WH_CODE']);
			}else{
				grdRecord.set('WH_CODE'			, panelResult.getValue('WH_CODE'));
			}
			grdRecord.set('INOUT_TYPE_DETAIL'	, Ext.data.StoreManager.lookup('CBS_AU_S008').getAt(0).get('value'));
			grdRecord.set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
			grdRecord.set('INOUT_METH'			, '1');
			grdRecord.set('SALE_DIV_CODE'		, record['DIV_CODE']);
			if(BsaCodeInfo.gsOptDivCode == "1"){
				grdRecord.set('SALE_DIV_CODE'	, record['SALE_DIV_CODE']);
			}else{
				grdRecord.set('SALE_DIV_CODE'	, record['DIV_CODE']);
			}
			grdRecord.set('SALE_CUSTOM_CODE'	, record['SALE_CUSTOM_CODE']);
			grdRecord.set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);
			grdRecord.set('DVRY_CUST_NM'		, record['DVRY_CUST_NM']);
			grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
			grdRecord.set('SOF100_TAX_INOUT'	, Ext.isEmpty(record['TAX_INOUT']) ? CustomCodeInfo.gsTaxInout: record['TAX_INOUT']);		//20210521 수정: CustomCodeInfo.gsTaxInout -> 현재 로직
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			//20200106 추가
			grdRecord.set('PJT_NAME'			, record['PJT_NAME']);
			grdRecord.set('STOCK_CARE_YN'		, record['STOCK_CARE_YN']);
			grdRecord.set('SALE_PRSN'			, record['SALE_PRSN']);
			grdRecord.set('REF_BILL_TYPE'		, record['BILL_TYPE']);
			grdRecord.set('REF_SALE_TYPE'		, record['ORDER_TYPE']);
			grdRecord.set('BILL_TYPE'			, '10');
			//20200417 수정: 통화가 같으면 첫번째 값 아니면 40(직수출)
			grdRecord.set('SALE_TYPE'			, panelResult.getValue('MONEY_UNIT') == BsaCodeInfo.gsMoneyUnit ? Ext.data.StoreManager.lookup('CBS_AU_S002').getAt(0).get('value') : '40');
			grdRecord.set('AGENT_TYPE'			, record['AGENT_TYPE']);
			grdRecord.set('DEPT_CODE'			, record['DEPT_CODE']);
			grdRecord.set('BASIS_NUM'			, record['INOUT_NUM']);
			grdRecord.set('BASIS_SEQ'			, record['INOUT_SEQ']);
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			//20190527 수정: 20191014 수정
			grdRecord.set('MONEY_UNIT'			, panelResult.getValue('MONEY_UNIT'));	//record['MONEY_UNIT']);;
			//20190618 추가: 20191014 수정
			if(!Ext.isEmpty(panelResult.getValue('EXCHG_RATE_O'))) {
				grdRecord.set('EXCHG_RATE_O'	, panelResult.getValue('EXCHG_RATE_O'));	//record['EXCHG_RATE_O']);
			} else {
				grdRecord.set('EXCHG_RATE_O'	, record['EXCHG_RATE_O']);
			}
			//20210312 추가
			grdRecord.set('BILL_TYPE'			, record['BILL_TYPE']);
			grdRecord.set('CARD_CUSTOM_CODE'	, record['CARD_CUSTOM_CODE']);
			//20210521 추가: 세액포함여부 계산하기 위해서 추가
			gsTaxInout = Ext.isEmpty(record['TAX_INOUT']) ? '' : record['TAX_INOUT'];
			UniAppManager.app.fnOrderAmtCal(grdRecord, "P");
		},
		setProjectData: function(record, dataClear) {		 /* 관리번호 Grid Popup */
			var grdRecord = detailGrid.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('PROJECT_NO'	, '');
				//20200106 프로젝트명 추가
				grdRecord.set('PJT_NAME'	, '');
			} else {
				grdRecord.set('PROJECT_NO'	, record['PJT_CODE']);
				//20200106 프로젝트명 추가
				grdRecord.set('PJT_NAME'	, record['PJT_NAME']);
			}
		},
		setExcelRefer:function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('SALE_DIV_CODE'		, panelResult.getValue('DIV_CODE'));
			grdRecord.set('INOUT_TYPE_DETAIL'	, record['INOUT_TYPE_DETAIL']);
			grdRecord.set('INOUT_NUM'			, panelResult.getValue('INOUT_NUM'));
			grdRecord.set('WH_CODE'				, record['WH_CODE']);

			grdRecord.set('WH_CELL_CODE'		, record['WH_CELL_CODE']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);
			grdRecord.set('ORDER_UNIT_Q'		, record['ORDER_UNIT_Q']);
			grdRecord.set('ORDER_UNIT_P'		, record['ORDER_UNIT_P']);
			grdRecord.set('ORDER_UNIT_O'		, record['ORDER_UNIT_O']);
			grdRecord.set('INOUT_TAX_AMT'		, record['INOUT_TAX_AMT']);
			if(record['ORDER_AMT_SUM'] > 0 )	{
				grdRecord.set('ORDER_AMT_SUM'		, record['ORDER_AMT_SUM']);
			} else {
				grdRecord.set('ORDER_AMT_SUM'       , parseFloat(record['ORDER_UNIT_O']) + parseFloat(record['INOUT_TAX_AMT']))
			}
			grdRecord.set('TAX_TYPE'		, record['TAX_TYPE']);
			grdRecord.set('ITEM_STATUS'		, record['ITEM_STATUS']);
			grdRecord.set('ACCOUNT_YNC'		, record['ACCOUNT_YNC']);
			grdRecord.set('REMARK'			, record['REMARK']);

			grdRecord.set('INOUT_METH'			, '1');

			grdRecord.set('SOF100_TAX_INOUT'	, Unilite.nvl(record['SOF100_TAX_INOUT'], CustomCodeInfo.gsTaxInout));
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('BILL_TYPE'			, '10');
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			//20190527 수정: 20191014 수정
			grdRecord.set('MONEY_UNIT'			, panelResult.getValue('MONEY_UNIT'));	//record['MONEY_UNIT']);;
			grdRecord.set('EXCHG_RATE_O'	, panelResult.getValue('EXCHG_RATE_O'));	//record['EXCHG_RATE_O']);
			UniAppManager.app.fnOrderAmtCal(grdRecord, "P");
		}
	});



	/** 수주정보를 검색하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//검색창 폼 정의
	var returnNoSearch = Unilite.createSearchForm('returnNoSearchForm', {
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype:'uniCombobox',
			comboType:'BOR120',
			value:UserInfo.divCode,
			allowBlank:false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = returnNoSearch.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.returndate" default="반품일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'INOUT_DATE_FR',
			endFieldName: 'INOUT_DATE_TO',
			width: 350
//			startDate: UniDate.get('startOfMonth'),
//			endDate: UniDate.get('today')
		},{
			fieldLabel: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
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
		},
			Unilite.popup('DIV_PUMOK', {
			fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						returnNoSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						returnNoSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': returnNoSearch.getValue('DIV_CODE')});
				}
			}
		}),
			Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						returnNoSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						returnNoSearch.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.sales.warehouse" default="창고"/>',
			name: 'WH_CODE',
			xtype:'uniCombobox',
			comboType   : 'OU',
			listeners: {
				beforequery:function( queryPlan, eOpts) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(!Ext.isEmpty(returnNoSearch.getValue('DIV_CODE'))){
							store.filterBy(function(record){
							return record.get('option') == returnNoSearch.getValue('DIV_CODE');
						})
					} else {
						store.filterBy(function(record){
							return false;
						})
					}
				}
			}
		},
		Unilite.popup('PROJECT',{
			fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			valueFieldName:'PJT_CODE',
			textFieldName:'PJT_NAME',
			DBvalueFieldName: 'PJT_CODE',
			DBtextFieldName: 'PJT_NAME',
			validateBlank: false,
			textFieldOnly: false,
			listeners: {
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
			//20191209 추가
			fieldLabel	: '<t:message code="system.label.sales.returnmanageno" default="반품관리번호"/>',
			name		: 'INSPEC_NUM',
			xtype		: 'uniTextfield',
//			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]
	});
	// createSearchForm
	//검색창 모델 정의
	Unilite.defineModel('returnNoMasterModel', {
		fields: [
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.client" default="고객"/>'		, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.sales.returntype" default="반품유형"/>'	, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'			, type: 'string'},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.sales.returndate" default="반품일"/>'	, type: 'uniDate'},
			{name: 'INOUT_Q'			, text: '<t:message code="system.label.sales.returnqty" default="반품량"/>'	, type: 'uniQty'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.sales.warehouse" default="창고"/>'		, type: 'string', comboType: 'OU' },
			{name: 'INOUT_PRSN'			, text: '<t:message code="system.label.sales.charger" default="담당자"/>'		, type: 'string', comboType: 'AU', comboCode: 'B024'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.sales.returnno" default="반품번호"/>'	, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'	, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'		, type: 'string'},
			{name: 'INOUT_CODE'			, text: '<t:message code="system.label.sales.tranplace" default="수불처"/>'	, type: 'string'},
			{name: 'TAX_TYPE'			, text: '<t:message code="system.label.sales.tranplace" default="수불처"/>'	, type: 'string'},
			{name: 'AGENT_TYPE'			, text: '<t:message code="system.label.sales.tranplace" default="수불처"/>'	, type: 'string'},
			{name: 'WON_CALC_BAS'		, text: '<t:message code="system.label.sales.tranplace" default="수불처"/>'	, type: 'string'},
			{name: 'INSPEC_NUM'			, text:'INSPEC_NUM'		,type: 'string'},	//20191004 추가(반품관리번호 저장용 컬럼 선언)
			{name: 'MONEY_UNIT'			, text:'MONEY_UNIT'		,type: 'string'},	//20191008 화폐의 따라 포맷 적용하기 위해 조회 추가
			//20200115 LOT_NO 추가
			{name: 'LOT_NO'				, text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'		, type: 'string'},
			//20210312 추가: BILL_TYPE, CARD_CUSTOM_CODE
			{name: 'BILL_TYPE'			, text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'	, type: 'string', comboType: 'AU', comboCode: 'S024' },
			{name: 'CARD_CUSTOM_CODE'	, text:'카드사'			, type: 'string', comboType: 'AU', comboCode: 'A028'}
		]
	});
	//검색창 스토어 정의
	var returnNoMasterStore = Unilite.createStore('returnNoMasterStore', {
		model: 'returnNoMasterModel',
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
				read	: 'str110ukrvService.selectReturnNumMasterList'
			}
		},
		loadStoreRecords : function() {
			var param= returnNoSearch.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(returnNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색창 그리드 정의
	var returnNoMasterGrid = Unilite.createGrid('str110ukrvReturnNoMasterGrid', {
		// title: '기본',
		layout : 'fit',
		store: returnNoMasterStore,
		uniOpt:{
			useRowNumberer: false
		},
		columns:  [
			{ dataIndex: 'CUSTOM_NAME'			, width: 120},
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 66, hidden: true },
			{ dataIndex: 'ITEM_CODE'			, width: 120 },
			{ dataIndex: 'ITEM_NAME'			, width: 186 },
			{ dataIndex: 'SPEC'					, width: 150 },
			{ dataIndex: 'LOT_NO'				, width: 120 },
			{ dataIndex: 'INOUT_DATE'			, width: 93 },
			{ dataIndex: 'INOUT_Q'				, width: 80 },
			{ dataIndex: 'WH_CODE'				, width: 86 },
			{ dataIndex: 'INOUT_PRSN'			, width: 86 , align:'center' },
			{ dataIndex: 'INOUT_NUM'			, width: 120 },
			{ dataIndex: 'PROJECT_NO'			, width: 120 },
			{ dataIndex: 'DIV_CODE'				, width: 80, hidden: true },
			{ dataIndex: 'INOUT_CODE'			, width: 80, hidden: true },
			//20191008 화폐에 따라 포맷 적용하기 위해 조회 추가
			{ dataIndex: 'MONEY_UNIT'			, width: 80, hidden: true }
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				returnNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				searchInfoWindow.hide();
			}
		}, // listeners
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			//20191008 포맷 적용하는 로직 우선 수행: 20191011 isLoad = true; 추가
			isLoad = true;
			//fnSetColumnFormat(record.get('MONEY_UNIT')); //--> 20200701 조회데이터 적용시 사용자가 입력한 환율 적용하도록 하기 위해 주석.

			var field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, record.get('DIV_CODE'), null, null, "DIV_CODE");
			field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, record.get('DIV_CODE'), null, null, "DIV_CODE");
			panelResult.uniOpt.inLoading=true;
			panelResult.uniOpt.inLoading=true;
			isLoad = true;
			panelResult.setValues({
				'DIV_CODE'			: record.get('DIV_CODE'),
				'INOUT_NUM'			: record.get('INOUT_NUM'),
				'INOUT_DATE'		: record.get('INOUT_DATE'),
				'INOUT_PRSN'		: record.get('INOUT_PRSN'),
				'CUSTOM_CODE'		: record.get('INOUT_CODE'),
				'CUSTOM_NAME'		: record.get('CUSTOM_NAME'),
				'INSPEC_NUM'		: record.get('INSPEC_NUM'),			//20191004 추가
				'EXCHG_RATE_O'		: record.get('EXCHG_RATE_O'),		//20191011 추가
				'BILL_TYPE'			: record.get('BILL_TYPE'),			//20210312 추가
				'CARD_CUSTOM_CODE'	: record.get('CARD_CUSTOM_CODE')	//20210312 추가
			});
			isLoad = true;
			panelResult.setValue('MONEY_UNIT',record.get('MONEY_UNIT'));
			CustomCodeInfo.gsTaxInout = record.get('TAX_TYPE');
			CustomCodeInfo.gsAgentType = record.get('AGENT_TYPE');
			CustomCodeInfo.gsUnderCalBase = record.get('WON_CALC_BAS');
			panelResult.uniOpt.inLoading=false;
			panelResult.uniOpt.inLoading=false;
		}
	});
	//검색창 메인
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.sales.returnnosearch" default="반품번호검색"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [returnNoSearch, returnNoMasterGrid],
				tbar:  ['->',{
					itemId : 'searchBtn',
					text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler: function() {
						returnNoMasterStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler: function() {
						searchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						returnNoSearch.clearForm();
						returnNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						returnNoSearch.clearForm();
						returnNoMasterGrid.reset();
					},
					show: function( panel, eOpts ) {
						var field = returnNoSearch.getField('INOUT_PRSN');
						field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
						returnNoSearch.setValue('CUSTOM_CODE',panelResult.getValue('CUSTOM_CODE'));
						returnNoSearch.setValue('CUSTOM_NAME',panelResult.getValue('CUSTOM_NAME'));
						returnNoSearch.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth', panelResult.getValue('INOUT_DATE')));
						returnNoSearch.setValue('INOUT_DATE_TO',panelResult.getValue('INOUT_DATE'));
						returnNoSearch.setValue('INOUT_PRSN',panelResult.getValue('INOUT_PRSN'));
						returnNoSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
						returnNoSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
						returnNoSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
					}
				}
			})
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
	}



	/** 출하지시내역을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//수주참조 폼 정의
	var orderReferSearch = Unilite.createSearchForm('orderReferForm', {
		layout :  {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			width: 350,
//				startDate: UniDate.add(UniDate.getDateStr(UniDate.get('today')), {months:-1}),
//				startDate: UniDate.add(panelResult.getValue('SET_ORDER_DATE'), {months:-1}),
			endDate: UniDate.get('today')
		},
			Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>' ,
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			colspan: 2,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						orderReferSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						orderReferSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}), {
			fieldLabel: '<t:message code="system.label.sales.sono" default="수주번호"/>',
			xtype: 'uniTextfield',
			name:'ORDER_NUM'
		},{
			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name: 'ORDER_PRSN',
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
		},
			Unilite.popup('PROJECT',{
			fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			valueFieldName:'PJT_CODE',
			textFieldName:'PJT_NAME',
			DBvalueFieldName: 'PJT_CODE',
			DBtextFieldName: 'PJT_NAME',
			validateBlank: false,
//				allowBlank:false,
			textFieldOnly: false,
//				labelWidth: 140,
			listeners: {
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
		})]
	});
	//수주참조 모델 정의
	Unilite.defineModel('str110ukrvorderReferModel', {
		fields: [
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'					, type: 'string'},
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.sales.sodate" default="수주일"/>'				, type: 'uniDate'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'			, type: 'string' , displayField: 'value'},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.sales.soqty" default="수주량"/>'					, type: 'uniQty'},
			{name: 'ENRETURN_Q'			,text: '<t:message code="system.label.sales.returnavaiableqty" default="반품가능량"/>'	, type: 'uniQty'},
			{name: 'ORDER_P'			,text: '<t:message code="system.label.sales.soprice" default="수주단가"/>'				, type: 'uniUnitPrice'},
			{name: 'ORDER_PRSN'			,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string'},
			{name: 'ORDER_TYPE'			,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'			, type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'					, type: 'string'},
			{name: 'SER_NO'				,text: '<t:message code="system.label.sales.seq" default="순번"/>'					, type: 'string'},
			{name: 'SALE_CUST_CD'		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			, type: 'string'},
			{name: 'SALE_CUST_NM'		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			, type: 'string'},
			{name: 'DVRY_CUST_CD'		,text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			, type: 'string'},
			{name: 'DVRY_CUST_NM'		,text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			, type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			, type: 'string'},
			//20200106 프로젝트명 추가
			{name: 'PJT_NAME'			,text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>'			, type: 'string', editable: false},
			{name: 'TAX_INOUT'			,text: '<t:message code="system.label.sales.taxincludedflagcode" default="세포함여부"/>'	, type: 'string'},
			{name: 'SOF100_TAX_INOUT'	,text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>'	, type: 'string' , comboType:'AU', comboCode:'B030'},
			{name: 'TRANS_RATE'			,text: 'TRANS_RATE'		, type: 'string'},
			{name: 'TAX_TYPE'			,text: 'TAX_TYPE'		, type: 'string'},
			{name: 'PRICE_YN'			,text: 'PRICE_YN'		, type: 'string'},
			{name: 'STOCK_CARE_YN'		,text: 'STOCK_CARE_YN'	, type: 'string'},
			{name: 'DISCOUNT_RATE'		,text: 'DISCOUNT_RATE'	, type: 'string'},
			{name: 'ORDER_PRSN_CD'		,text: 'ORDER_PRSN_CD'	, type: 'string'},
			{name: 'DIV_CODE'			,text: 'DIV_CODE'		, type: 'string'},
			{name: 'OUT_DIV_CODE'		,text: 'OUT_DIV_CODE'	, type: 'string'},
			{name: 'BILL_TYPE'			,text: 'BILL_TYPE'		, type: 'string'},
			{name: 'ORDER_TYPE_CD'		,text: 'ORDER_TYPE_CD'	, type: 'string'},
			{name: 'AGENT_TYPE'			,text: 'AGENT_TYPE'		, type: 'string'},
			{name: 'DEPT_CODE'			,text: 'DEPT_CODE'		, type: 'string'},
			//20190618 추가
			{name: 'MONEY_UNIT'			,text: 'MONEY_UNIT'		, type: 'string'},
			{name: 'EXCHG_RATE_O'		,text: 'EXCHG_RATE_O'	, type: 'uniER'}
		]
	});
	//수주참조 스토어 정의
	var orderReferStore = Unilite.createStore('str110ukrvReferStore', {
		model: 'str110ukrvorderReferModel',
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
				read	: 'str110ukrvService.selectOrderReferList'
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

						Ext.each(records,function(item, i) {
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
		},
		loadStoreRecords : function() {
			var param= orderReferSearch.getValues();
			param.DIV_CODE = panelResult.getValue('DIV_CODE');
			param.CUSTOM_CODE = panelResult.getValue('CUSTOM_CODE');
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//수주참조 그리드 정의
	var orderReferGrid = Unilite.createGrid('str110ukrvorderReferGrid', {
		// title: '기본',
		layout : 'fit',
		store: orderReferStore,
		uniOpt:{
			onLoadSelectFirst : false
		},
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false, mode: 'SIMPLE' }),
		columns:  [
			{ dataIndex: 'ITEM_CODE'		, width: 120 },
			{ dataIndex: 'ITEM_NAME'		, width: 200 },
			{ dataIndex: 'SPEC'				, width: 150 },
			{ dataIndex: 'ORDER_DATE'		, width: 80 },
			{ dataIndex: 'ORDER_UNIT'		, width: 66, align:'center'  },
			{ dataIndex: 'ORDER_Q'			, width: 86 },
			{ dataIndex: 'ENRETURN_Q'		, width: 86 },
			{ dataIndex: 'ORDER_P'			, width: 100 },
			{ dataIndex: 'ORDER_PRSN'		, width: 86, align:'center'  },
			{ dataIndex: 'ORDER_TYPE'		, width: 100 },
			{ dataIndex: 'ORDER_NUM'		, width: 100 },
			{ dataIndex: 'SER_NO'			, width: 40, hidden: true },
			{ dataIndex: 'SALE_CUST_CD'		, width: 66, hidden: true },
			{ dataIndex: 'SALE_CUST_NM'		, width: 100 },
			{ dataIndex: 'DVRY_CUST_CD'		, width: 66, hidden: true },
			{ dataIndex: 'DVRY_CUST_NM'		, width: 100 },
			{ dataIndex: 'PROJECT_NO'		, width: 100 },
			{ dataIndex: 'TAX_INOUT'		, width: 66, hidden: true },
			{ dataIndex: 'SOF100_TAX_INOUT'	, width: 100, align:'center'  },
			{ dataIndex: 'TRANS_RATE'		, width: 66, hidden: true },
			{ dataIndex: 'TAX_TYPE'			, width: 66, hidden: true },
			{ dataIndex: 'PRICE_YN'			, width: 66, hidden: true },
			{ dataIndex: 'STOCK_CARE_YN'	, width: 66, hidden: true },
			{ dataIndex: 'DISCOUNT_RATE'	, width: 66, hidden: true },
			{ dataIndex: 'ORDER_PRSN_CD'	, width: 66, hidden: true },
			{ dataIndex: 'DIV_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'OUT_DIV_CODE'		, width: 66, hidden: true },
			{ dataIndex: 'BILL_TYPE'		, width: 66, hidden: true },
			{ dataIndex: 'ORDER_TYPE_CD'	, width: 66, hidden: true },
			{ dataIndex: 'AGENT_TYPE'		, width: 66, hidden: true },
			{ dataIndex: 'DEPT_CODE'		, width: 66, hidden: true },
			//20190618 추가
			{ dataIndex: 'MONEY_UNIT'		, width: 66, hidden: true },
			{ dataIndex: 'EXCHG_RATE_O'		, width: 66, hidden: true }
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			//20191008 포맷 적용하는 로직 우선 수행
			fnSetColumnFormat(records[0].get('MONEY_UNIT'));
			//20191014 주석//20191011 추가
			isLoad = true;
//			panelResult.setValue('MONEY_UNIT'	, records[0].get('MONEY_UNIT'));
//			panelResult.setValue('EXCHG_RATE_O'	, records[0].get('EXCHG_RATE_O'));

			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				detailGrid.setOrderRefer(record.data);
			});
			this.deleteSelectedRow();
		}
	});
	//수주참조 메인
	function openOrderReferWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!referReturnWindow) {
			referReturnWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.sales.sorefer" default="수주참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [orderReferSearch, orderReferGrid],
				tbar:  ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler: function() {
						orderReferStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmBtn',
					text: '<t:message code="system.label.sales.returnapply" default="반품적용"/>',
					handler: function() {
						orderReferGrid.returnData();
					},
					disabled: false
				},{
					itemId : 'confirmCloseBtn',
					text: '<t:message code="system.label.sales.returnapplyclose" default="반품적용후 닫기"/>',
					handler: function() {
						orderReferGrid.returnData();
						referReturnWindow.hide();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler: function() {
						if(detailStore.getCount() == 0){
							panelResult.setAllFieldsReadOnly(false);
						}
						referReturnWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						orderReferSearch.clearForm();
						orderReferGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						orderReferSearch.clearForm();
						orderReferGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						var field = orderReferSearch.getField('ORDER_PRSN');
						field.fireEvent('changedivcode', field, panelResult.getValue('DIV_CODE'), null, null, "DIV_CODE");
						orderReferSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
						orderReferSearch.setValue('ORDER_DATE_FR', UniDate.add(orderReferSearch.getValue('ORDER_DATE_TO'), {months: -3}));
						orderReferStore.loadStoreRecords();
					}
				}
			})
		}
		referReturnWindow.center();
		referReturnWindow.show();
	}



	//출고참조 폼 정의
	var saleReferSearch = Unilite.createSearchForm('saleReferForm', {
		layout :  {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value:UserInfo.divCode
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>',
			allowBlank		: false,
			readOnly		: true,
			validateBlank	: true,
			valueFieldName	:'CUSTOM_CODE',
			textFieldName	:'CUSTOM_NAME'
		}),{
			//참조 팝업에 검색조건 LOT_NO 추가
			fieldLabel	: '<t:message code="system.label.sales.lotno" default="LOT번호"/>',
			name		: 'LOT_NO',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.transdate" default="수불일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_INOUT_DATE',
			endFieldName: 'TO_INOUT_DATE',
			endDate: UniDate.get('today')
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>' ,
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						saleReferSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						saleReferSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': saleReferSearch.getValue('DIV_CODE')});
				}
			}
		}),{//20191129 출고참조 팝업 검색조건(출고창고, 출고창고CELL) 추가
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			items	: [{
				fieldLabel	: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'OU',
				child		: 'WH_CELL_CODE',
				holdable	: 'hold',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					},
					beforequery:function( queryPlan, eOpts) {
						var store = queryPlan.combo.store;
						store.clearFilter();
						if(!Ext.isEmpty(saleReferSearch.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == saleReferSearch.getValue('DIV_CODE');
							})
						}else{
							store.filterBy(function(record){
								return false;
							})
						}
					}
				}
			},{
				fieldLabel	: '',
				name		: 'WH_CELL_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whCellList'),
	//			colspan		: 2,
				holdable	: 'hold',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			}]
		},{
			fieldLabel	: '고객명',
			name		: 'CUSTOM_PRSN',
			xtype		: 'uniTextfield',
			hidden		: BsaCodeInfo.gsSiteCode == 'WM' ? false: true,	//20210331 추가
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		}]
	});
	//출고참조 모델 정의
	Unilite.defineModel('str110ukrvsaleReferModel', {
		fields: [
			{name: 'CUSTOM_CODE',		text: '<t:message code="system.label.sales.custom" default="거래처"/>',				type: 'string'},
			{name: 'CUSTOM_NAME',		text: '<t:message code="system.label.sales.customname" default="거래처명"/>',			type: 'string'},
			{name: 'INOUT_DATE',		text: '<t:message code="system.label.sales.transdate" default="수불일"/>',				type: 'uniDate'},
			{name: 'ITEM_CODE',			text: '<t:message code="system.label.sales.item" default="품목"/>',					type: 'string'},
			{name: 'ITEM_NAME',			text: '<t:message code="system.label.sales.itemname" default="품목명"/>',				type: 'string'},
			{name: 'SPEC',				text: '<t:message code="system.label.sales.spec" default="규격"/>',					type: 'string'},
			{name: 'INOUT_Q',			text: '<t:message code="system.label.sales.issueqty" default="출고량"/>',				type: 'uniQty'},
			{name: 'ENRETURN_Q',		text: '<t:message code="system.label.sales.returnavaiableqty" default="반품가능량"/>',	type: 'uniQty'},
			{name: 'ORDER_UNIT',		text: '<t:message code="system.label.sales.unit" default="단위"/>',					type: 'string', displayField: 'value'},
			{name: 'LOT_NO',			text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>',				type: 'string'},
			{name: 'ORDER_TYPE',		text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',			type: 'string',comboType:"AU", comboCode:"S002"},
			{name: 'TRNS_RATE',			text: '<t:message code="system.label.sales.containedqty" default="입수"/>',			type: 'string'},
			{name: 'ORDER_UNIT_Q',		text: '<t:message code="system.label.sales.issueqty" default="출고량"/>(<t:message code="system.label.sales.inventory" default="재고"/>)',   type: 'uniQty'},
			{name: 'MONEY_UNIT',		text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>',			type: 'string'},
			{name: 'INOUT_P',			text: '<t:message code="system.label.sales.issueprice" default="출고단가"/>',			type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O',		text: '<t:message code="system.label.sales.amount" default="금액"/>',					type: 'uniPrice'},
			{name: 'INOUT_I',			text: '<t:message code="system.label.sales.coamount" default="자사금액"/>',				type: 'uniPrice'},
			{name: 'INOUT_TYPE_DETAIL',	text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>',			type: 'string' ,comboType:"AU", comboCode:"S007"},
			{name: 'WH_CODE',			text: '<t:message code="system.label.sales.warehouse" default="창고"/>',				type: 'string' ,comboType   : 'OU'},
			{name: 'ACCOUNT_YNC',		text: '<t:message code="system.label.sales.salessubject" default="매출대상"/>',			type: 'string' ,comboType:'AU', comboCode:'B010' },
			{name: 'INOUT_NUM',			text: '<t:message code="system.label.sales.tranno" default="수불번호"/>',				type: 'string'},
			{name: 'INOUT_SEQ',			text: '<t:message code="system.label.sales.transeq" default="수불순번"/>',				type: 'string'},
			{name: 'PRICE_YN',			text: 'PRICE_YN',		type: 'string'},
			{name: 'SALE_DIV_CODE',		text: '<t:message code="system.label.sales.salesdivision" default="매출사업장"/>',		type: 'string'},
			{name: 'SALE_CUSTOM_CODE',	text: '<t:message code="system.label.sales.salesplace" default="매출처"/>',			type: 'string'},
			{name: 'TAX_TYPE',			text: 'TAX_TYPE',		type: 'string'},
			{name: 'DISCOUNT_RATE',		text: 'DISCOUNT_RATE',	type: 'string'},
			{name: 'DVRY_CUST_CD',		text: 'DVRY_CUST_CD',	type: 'string'},
			{name: 'DVRY_CUST_NM',		text: 'DVRY_CUST_NM',	type: 'string'},
			{name: 'ORDER_NUM',			text: 'ORDER_NUM',		type: 'string'},
			{name: 'ORDER_SEQ',			text: 'ORDER_SEQ',		type: 'string'},
			{name: 'PROJECT_NO',		text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',			type: 'string'},
			{name: 'PJT_NAME',			text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>',			type: 'string', editable: false},					//20200106 프로젝트명 추가
			{name: 'STOCK_CARE_YN',		text: 'STOCK_CARE_YN',	type: 'string'},
			{name: 'SALE_PRSN',			text: 'SALE_PRSN',		type: 'string'},
			{name: 'BILL_TYPE',			text: 'BILL_TYPE',		type: 'string'},
			{name: 'AGENT_TYPE',		text: 'AGENT_TYPE',		type: 'string'},
			{name: 'DEPT_CODE',			text: 'DEPT_CODE',		type: 'string'},
			{name: 'DIV_CODE',			text: 'DIV_CODE',		type: 'string'},
			{name: 'MAIN_WH_CODE',		text: '<t:message code="system.label.sales.mainwarehouse" default="주창고"/>',			type: 'string', comboType   : 'OU'},
			{name: 'MAIN_WH_CODE_YN',	text: '<t:message code="system.label.sales.itemmainwarehouseuseyn" default="품목주창고 사용여부"/>',	type: 'string'},
			{name: 'EXCHG_RATE_O',		text: 'EXCHG_RATE_O',	type: 'uniER'},																									//20190618 추가
			{name: 'TAX_INOUT',			text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>',	type: 'string', comboType: 'AU', comboCode: 'B030'}	//20215021 추가
		]
	});
	//출고참조 스토어 정의
	var saleReferStore = Unilite.createStore('str110ukrvsaleReferStore', {
		model: 'str110ukrvsaleReferModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,	// 상위 버튼 연결
			editable: false,	// 수정 모드 사용
			deletable:false,	// 삭제 가능 여부
			useNavi : false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'str110ukrvService.selectSaleReferList'
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
						Ext.each(records,function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM']) // record = masterRecord   item = 참조 Record
									&& (record.data['ORDER_SEQ'] == item.data['ORDER_SEQ'])
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
		},
		loadStoreRecords : function()  {
			var param= saleReferSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//출고참조 그리드 정의
	var saleReferGrid = Unilite.createGrid('str110ukrvsaleReferGrid', {
		// title: '기본',
		layout : 'fit',
		store: saleReferStore,
		uniOpt:{
			onLoadSelectFirst : false
		},
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false, mode: 'SIMPLE' }),
		columns:  [
			{ dataIndex: 'CUSTOM_CODE',			width: 80},
			{ dataIndex: 'CUSTOM_NAME',			width: 120},
			{ dataIndex: 'INOUT_DATE',			width: 80},
			{ dataIndex: 'ITEM_CODE',			width: 120},
			{ dataIndex: 'ITEM_NAME',			width: 200},
			{ dataIndex: 'MAIN_WH_CODE',		width: 120, hidden:true},
			{ dataIndex: 'SPEC',				width: 150},
			{ dataIndex: 'INOUT_Q',				width: 120},
			{ dataIndex: 'ENRETURN_Q',			width: 120},
			{ dataIndex: 'ORDER_UNIT',			width: 60 , align:'center'},
			{ dataIndex: 'LOT_NO',				width: 120},
			{ dataIndex: 'ORDER_TYPE',			width: 120},
			{ dataIndex: 'TRNS_RATE',			width: 120, hidden : true},
			{ dataIndex: 'ORDER_UNIT_Q',		width: 120, hidden : true},
			{ dataIndex: 'MONEY_UNIT',			width: 80 , align:'center'},
			{ dataIndex: 'INOUT_P',				width: 120},
			{ dataIndex: 'INOUT_FOR_O',			width: 120},
			{ dataIndex: 'INOUT_I',				width: 120, hidden : true},
			//자사금액?
			{ dataIndex: 'INOUT_TYPE_DETAIL',	width: 120, align:'center'},
			{ dataIndex: 'WH_CODE',				width: 120},
			{ dataIndex: 'ACCOUNT_YNC',			width: 80 , align:'center'},
			{ dataIndex: 'INOUT_NUM',			width: 120},
			{ dataIndex: 'INOUT_SEQ',			width: 80, align:'center'},
			{ dataIndex: 'PRICE_YN',			width: 120, hidden : true},
			{ dataIndex: 'SALE_DIV_CODE',		width: 120, hidden : true},
			{ dataIndex: 'SALE_CUSTOM_CODE',	width: 120, hidden : true},
			{ dataIndex: 'TAX_TYPE',			width: 120, hidden : true},
			{ dataIndex: 'DISCOUNT_RATE',		width: 120, hidden : true},
			{ dataIndex: 'DVRY_CUST_CD',		width: 120, hidden : true},
			{ dataIndex: 'DVRY_CUST_NM',		width: 120, hidden : true},
			{ dataIndex: 'ORDER_NUM',			width: 120, hidden : true},
			{ dataIndex: 'ORDER_SEQ',			width: 120, hidden : true},
			{ dataIndex: 'PROJECT_NO',			width: 120},
			{ dataIndex: 'STOCK_CARE_YN',		width: 120, hidden : true},
			{ dataIndex: 'SALE_PRSN',			width: 120, hidden : true},
			{ dataIndex: 'BILL_TYPE',			width: 120, hidden : true},
			{ dataIndex: 'ORDER_TYPE',			width: 120, hidden : true},
			{ dataIndex: 'AGENT_TYPE',			width: 120, hidden : true},
			{ dataIndex: 'DEPT_CODE',			width: 120, hidden : true},
			{ dataIndex: 'DIV_CODE',			width: 120, hidden : true},
			{ dataIndex: 'EXCHG_RATE_O',		width: 66 , hidden : true },	//20190618 추가
			{ dataIndex: 'TAX_INOUT',			width: 66 , hidden : false }
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			//20191008 포맷 적용하는 로직 우선 수행
			fnSetColumnFormat(records[0].get('MONEY_UNIT'));
			//20191014 주석//20191011 추가
			isLoad = true;
//			panelResult.setValue('MONEY_UNIT'	, records[0].get('MONEY_UNIT'));
//			panelResult.setValue('EXCHG_RATE_O'	, records[0].get('EXCHG_RATE_O'));

			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				detailGrid.setSaleRefer(record.data);
			});
			this.deleteSelectedRow();
		}
	});
	//출고참조 메인
	function openSaleReferWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!salereferReturnWindow) {
			salereferReturnWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.sales.issuerefer" default="출고참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [saleReferSearch, saleReferGrid],
				tbar:  ['->',
					{   itemId : 'saveBtn',
						text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
						handler: function() {
							saleReferStore.loadStoreRecords();
						},
						disabled: false
					},
					{   itemId : 'confirmBtn',
						text: '<t:message code="system.label.sales.returnapply" default="반품적용"/>',
						handler: function() {
							saleReferGrid.returnData();
						},
						disabled: false
					},
					{   itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.sales.returnapplyclose" default="반품적용후 닫기"/>',
						handler: function() {
							saleReferGrid.returnData();
							salereferReturnWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.sales.close" default="닫기"/>',
						handler: function() {
							if(detailStore.getCount() == 0){
								panelResult.setAllFieldsReadOnly(false);
							}
							salereferReturnWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						saleReferSearch.clearForm();
						saleReferGrid.reset();
					},
					beforeclose: function( panel, eOpts )  {
						saleReferSearch.clearForm();
						saleReferGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						saleReferSearch.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						saleReferSearch.setValue('TO_INOUT_DATE', UniDate.get('today'));
						saleReferSearch.setValue('FR_INOUT_DATE', UniDate.add(saleReferSearch.getValue('TO_INOUT_DATE'), {months: -1}));
						saleReferSearch.setValue('CUSTOM_CODE'	, panelResult.getValue('CUSTOM_CODE'));
						saleReferSearch.setValue('CUSTOM_NAME'	, panelResult.getValue('CUSTOM_NAME'));
						saleReferStore.loadStoreRecords();
					}
				}
			})
		}
		salereferReturnWindow.center();
		salereferReturnWindow.show();
	}



	/** 사업장별 영업담당 정보
	 */
	var divPrsnStore = Unilite.createStore('STR103UKRV_DIV_PRSN', {
		fields: ["value","text","option"],
		autoLoad: false,
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false				// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'salesCommonService.fnRecordCombo'
			}
		},
		listeners: {
			load: function( store, records, successful, eOpts ) {
				console.log("영업담당 store",this);
				if(successful) {
					orderReferSearch.setValue('ESTI_PRSN', panelResult.getValue('ORDER_PRSN'));
				}
			}
		},
		loadStoreRecords: function() {
			var param= {
						'COMP_CODE' : UserInfo.compCode,
						'MAIN_CODE' : 'S010',
						'DIV_CODE'  : panelResult.getValue('DIV_CODE'),
						'TYPE'		:'DIV_PRSN'
				}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	//엑셀참조 모델
	Unilite.Excel.defineModel('excel.str110.sheet01', {
		fields: [
			{name: 'INOUT_TYPE_DETAIL'			,text: '<t:message code="system.label.sales.returntype" default="반품유형"/>'				,type: 'string', comboType: 'AU', comboCode: 'S008', defaultValue: Ext.data.StoreManager.lookup('CBS_AU_S008').getAt(0).get('value'), allowBlank: false},
			{name: 'WH_CODE'					,text: '<t:message code="system.label.sales.returnwarehouse" default="반품창고"/>'			,type: 'string', comboType   : 'OU', allowBlank: false, child: 'WH_CELL_CODE'},
			{name: 'WH_CELL_CODE'				,text: '<t:message code="system.label.sales.returnwarehousecell" default="반품창고Cell"/>'	,type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','SALE_DIV_CODE']},
			{name: 'ITEM_CODE'					,text: '<t:message code="system.label.sales.item" default="품목"/>'						,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'					,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'SPEC'						,text: '<t:message code="system.label.sales.spec" default="규격"/>'						,type: 'string'},
			{name: 'LOT_NO'						,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'					,type: 'string'},
			{name: 'ORDER_UNIT_P'				,text: '<t:message code="system.label.sales.price" default="단가"/>'						,type: 'uniUnitPrice', defaultValue: 0},
			{name: 'ORDER_UNIT_Q'				,text: '<t:message code="system.label.sales.returnqty" default="반품량"/>'					,type: 'uniQty', defaultValue: 0, allowBlank: false},
			{name: 'ORDER_UNIT_O'				,text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'				,type: 'uniPrice', defaultValue: 0},
			{name: 'INOUT_TAX_AMT'				,text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'				,type: 'uniPrice', defaultValue: 0},
			{name: 'ORDER_AMT_SUM'				,text: '<t:message code="system.label.sales.returntotal" default="반품계(합계)"/>'				,type: 'uniPrice', defaultValue: 0},
			{name: 'TAX_TYPE'					,text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'			,type: 'string', comboType: 'AU', comboCode: 'B059', defaultValue: '1', allowBlank: false},
			{name: 'ORDER_UNIT'					,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'				,type: 'string', comboType: 'AU', comboCode: 'B013', allowBlank: false, displayField: 'value'},
			{name: 'TRNS_RATE'					,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				,type: 'uniQty', defaultValue: 1, allowBlank: false},
			{name: 'ITEM_STATUS'				,text: '<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>'			,type: 'string', comboType: 'AU', comboCode: 'B021', defaultValue: '2', allowBlank: false},
			{name: 'ACCOUNT_YNC'				,text: '<t:message code="system.label.sales.salessubject" default="매출대상"/>'				,type: 'string', comboType: 'AU', comboCode: 'S014', allowBlank: false},
			{name: 'SOF100_TAX_INOUT'			,text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>'		,type: 'string', comboType: 'AU', comboCode: 'B030', defaultValue: CustomCodeInfo.gsTaxInout},
			{name: 'PROJECT_NO'					,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				,type: 'string'},
			{name: 'REMARK'						,text: '<t:message code="system.label.sales.remarks" default="비고"/>'					,type: 'string'}
		]
	});
	//엑셀참조 팝업
	function openExcelWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUploadWin';
		if(!excelWindow) {
			excelWindow =  Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				modal: false,
				excelConfigName: 'str110', //2020.03.13 극동 엑셀업로드를 위한 변수처리
				grids: [{
					xtype       : 'uniGridPanel',
					itemId		: 'grid01',
					title		: '<t:message code="system.label.sales.returninfo" default="반품정보"/>',
					useCheckbox	: true,
					model		: 'excel.str110.sheet01',
					readApi		: 'str110ukrvService.selectExcelist',
					columns		: [
						{ dataIndex: 'INOUT_TYPE_DETAIL'	,width: 80, align: 'center'},
						{ dataIndex: 'WH_CODE'				,width: 100},
						{ dataIndex: 'WH_CELL_CODE'			,width: 100},
						{ dataIndex: 'ITEM_CODE'			,width: 100},
						{ dataIndex: 'ITEM_NAME'			,width: 200},
						{ dataIndex: 'SPEC'					,width: 150},
						{ dataIndex: 'LOT_NO'				,width:120 },
						{ dataIndex: 'ORDER_UNIT_P'			,width: 93	},
						{ dataIndex: 'ORDER_UNIT_Q'			,width: 93	},
						{ dataIndex: 'ORDER_UNIT_O'			,width: 100	},
						{ dataIndex: 'INOUT_TAX_AMT'		,width: 100	},
						{ dataIndex: 'ORDER_AMT_SUM'		,width: 100	},
						{ dataIndex: 'TAX_TYPE'				,width: 73	, align: 'center' },
						{ dataIndex: 'ORDER_UNIT'			,width: 80	, align: 'center'},
						{ dataIndex: 'TRNS_RATE'			,width: 73	},
						{ dataIndex: 'ITEM_STATUS'			,width: 80	, align: 'center'},
						{ dataIndex: 'ACCOUNT_YNC'			,width: 80	, align: 'center'},
						{ dataIndex: 'SOF100_TAX_INOUT'		,width: 100, align: 'center'},
						{ dataIndex: 'PROJECT_NO'			,width: 100},
						{ dataIndex: 'REMARK'				,width: 200}
					]
				}],
				listeners: {
					close: function() {
						this.hide();
					},
					hide: function() {
						excelWindow.down('#grid01').getStore().loadData({});
						this.hide();
					}
				},
				onApply:function() {
					var flag = true
					var grid = this.down('#grid01');
					var records = grid.getSelectionModel().getSelection();
					if(records && records.length > 0)	{

						isLoad = true;

						/*Ext.each(records, function(record,i){
							UniAppManager.app.onNewDataButtonDown();
							detailGrid.setExcelRefer(record.data);
						});*/

						flag =  UniAppManager.app.fnMakeExcelRef(records);
						if(flag) {
								grid.getStore().remove(records);
 								grid.getView().refresh();
						}

					}

				}
			});
		}
		excelWindow.center();
		excelWindow.show();
		isLoad = true;
	};



	/** main app
	 */
	Unilite.Main({
		id			: 'str110ukrvApp',
		borderItems	: [{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				detailGrid, panelResult
			]
		}],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
			//20191011 추가
			UniAppManager.app.fnExchngRateO(true);

			//20200115 반품현황 조회에서 넘어오는 링크 받는 로직 추가
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			} else {
				this.setDefault();
				panelResult.getField('INOUT_PRSN').focus();
			}
		},
		onQueryButtonDown: function() {
			panelResult.getField('CUSTOM_CODE').focus();
			panelResult.setAllFieldsReadOnly(false);

			var returnNo = panelResult.getValue('INOUT_NUM');
			if(Ext.isEmpty(returnNo)) {
				openSearchInfoWindow()
			} else {
				isLoad = true;
				gsTaxInout = ''
				detailStore.loadStoreRecords();
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function() {
			if(!this.checkForNewDetail()) return false;
			var orderNum = panelResult.getValue('ORDER_NUM')

			var inoutSeq = detailStore.max('INOUT_SEQ');
			if(!inoutSeq) inoutSeq = 1;
			else  inoutSeq += 1;

			var inoutNum = '';
			if(!Ext.isEmpty(panelResult.getValue('INOUT_NUM'))) {
				inoutNum = panelResult.getValue('INOUT_NUM');
			}

			var inoutCode = '';
			if(!Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
				inoutCode = panelResult.getValue('CUSTOM_CODE');
			}

			var inoutDate = '';
			if(!Ext.isEmpty(panelResult.getValue('INOUT_DATE'))) {
				inoutDate = panelResult.getValue('INOUT_DATE');
			}

			var inoutPrsn = '';
			if(!Ext.isEmpty(panelResult.getValue('INOUT_PRSN'))) {
				inoutPrsn = panelResult.getValue('INOUT_PRSN');
			}

			var saleCustomCode = '';
			if(!Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
				saleCustomCode = panelResult.getValue('CUSTOM_CODE');
			}

			var salePrsn = UniAppManager.app.fnSalePrsn(null, panelResult.getValue('DIV_CODE'));	//사업장의 영업담당 가져오기

			var deptCode = '';
			if(!Ext.isEmpty(panelResult.getValue('DEPT_CODE'))) {
				deptCode = panelResult.getValue('DEPT_CODE');
			}

			var whCode = '';
			if(!Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
				whCode = panelResult.getValue('WH_CODE');
			}

			var whCellCode = '';
			if(!Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))){
				whCellCode= panelResult.getValue('WH_CELL_CODE');
			}

			var saleDivCode = '';
			if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))) {
				saleDivCode = panelResult.getValue('DIV_CODE');
			}

			var whCode = '';
			if(!Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
				whCode = panelResult.getValue('WH_CODE');
			}
			var taxInout = CustomCodeInfo.gsTaxInout;
			var inoutSubCode = Ext.data.StoreManager.lookup('CBS_AU_S008').getAt(0).get('value');
			var accountYNC = UniAppManager.app.fnAccountYN(inoutSubCode);
			//20191008 행추가 시, 공통코드(S008)의 ref_code4가 있으면 해당 값을 ITEM_STATUS 값에 SET.. 없으면 PANEL의 값 SET하도록 수정
			var itemStatus = Ext.isEmpty(UniAppManager.app.fnGetItemStatus(inoutSubCode)) ? panelResult.getValue('ITEM_STATUS').ITEM_STATUS : UniAppManager.app.fnGetItemStatus(inoutSubCode);
			//20210521 수정: 전역변수 값 초기화
			gsTaxInout = CustomCodeInfo.gsTaxInout;

			var r = {
				INOUT_SEQ			: inoutSeq,
				INOUT_NUM			: inoutNum,
				SALE_DIV_CODE		: saleDivCode,
				DIV_CODE			: saleDivCode,
				INOUT_CODE			: inoutCode,
				INOUT_DATE			: inoutDate,
				INOUT_PRSN			: inoutPrsn,
				SALE_CUSTOM_CODE	: saleCustomCode,
				SALE_PRSN			: salePrsn,
				ACCOUNT_YNC			: accountYNC,
				DEPT_CODE			: deptCode,
				WH_CODE				: whCode,
				WH_CELL_CODE		: whCellCode,
				ITEM_STATUS			: itemStatus,
				SOF100_TAX_INOUT	: CustomCodeInfo.gsTaxInout,
				//20190626 추가: 20191011 수정
				EXCHG_RATE_O		: panelResult.getValue('EXCHG_RATE_O'),
				//20191011 추가
				MONEY_UNIT			: panelResult.getValue('MONEY_UNIT'),
				//20200121 추가: panel의 화폐단위와 BsaCodeInfo.gsMoneyUnit가 같으면 과세, 아니면 면세
				TAX_TYPE			: panelResult.getValue('MONEY_UNIT') == BsaCodeInfo.gsMoneyUnit ? 1 : 2,
				//20200417 추가: 통화가 같으면 첫번째 값 아니면 40(직수출)
				SALE_TYPE			: panelResult.getValue('MONEY_UNIT') == BsaCodeInfo.gsMoneyUnit ? Ext.data.StoreManager.lookup('CBS_AU_S002').getAt(0).get('value') : '40',
				BILL_TYPE			: panelResult.getValue('BILL_TYPE'),		//20210312 추가
				CARD_CUSTOM_CODE	: panelResult.getValue('CARD_CUSTOM_CODE')	//20210312 추가
			};
			detailGrid.createRow(r);

			//20200123 상위행의 매출유형, 매출대상여부 적용하는 로직 추가
			var records			= detailGrid.getStore().data.items;
			var selectedRecord	= detailGrid.getSelectedRecord();
			var selectedIndex	= 0
			Ext.each(records, function(record, i){
				if(record.get('INOUT_SEQ') == selectedRecord.get('INOUT_SEQ')) {
					selectedIndex = i;
				}
			});
			if(selectedIndex > 0) {detailGrid.getSelectedRecord().getPrevious
				selectedRecord.set('INOUT_TYPE_DETAIL'	, detailGrid.getStore().getAt(selectedIndex - 1).get('INOUT_TYPE_DETAIL'));
				selectedRecord.set('ACCOUNT_YNC'		, detailGrid.getStore().getAt(selectedIndex - 1).get('ACCOUNT_YNC'));
				selectedRecord.set('WH_CODE'			, detailGrid.getStore().getAt(selectedIndex - 1).get('WH_CODE'));
				selectedRecord.set('WH_CELL_CODE'		, detailGrid.getStore().getAt(selectedIndex - 1).get('WH_CELL_CODE'));
			}

			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			gsTaxInout = ''
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('ACCOUNT_Q') > 0 && BsaCodeInfo.gsReturnAutoYN == "N"){
					Unilite.messageBox('<t:message code="system.message.sales.message068" default="계산서가 발행된 건은 삭제할 수 없습니다."/>');	//계산서가 발행된 건은 삭제할 수 없습니다.
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
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						Ext.each(records, function(record,i) {
							if(record.get('ACCOUNT_Q') > 0 && BsaCodeInfo.gsReturnAutoYN == "N"){
								Unilite.messageBox('<t:message code="system.message.sales.message068" default="계산서가 발행된 건은 삭제할 수 없습니다."/>');	//계산서가 발행된 건은 삭제할 수 없습니다.
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
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('str110ukrvAdvanceSerch');
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
			var fp = Ext.getCmp('str110ukrvFileUploadPanel');
			if(detailStore.isDirty() || fp.isDirty()) {
				if(confirm('<t:message code="system.message.sales.message021" default="변경된 내용을 저장하시겠습니까?"/>')) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		fnGetInoutPrsnDivCode: function(subCode){ //사업장의 첫번째 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.inoutPrsn, function(item, i) {
				if(item['refCode1'] == subCode) {
					fRecord = item['codeNo'];
					return false;
				}
			});
			return fRecord;
		},
		fnGetInoutPrsnUserId: function(subCode){ //로그인 아이디의 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.inoutPrsn, function(item, i) {
				if(item['refCode10'] == subCode) {
					fRecord = item['codeNo'];
					return false;
				}
			});
			return fRecord;
		},
		setDefault: function() {
			//20191008 포맷 적용하는 로직 우선 수행
			fnSetColumnFormat(BsaCodeInfo.gsMoneyUnit);

			/*수불담당 filter set*/
			var field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			if(BsaCodeInfo.gsBarcodeYn == 'Y') {
				panelResult.getField('BARCODE').setHidden(false);

			} else {
				panelResult.getField('BARCODE').setHidden(true);
			}

			var param = {
				"DIV_CODE": UserInfo.divCode,
				"DEPT_CODE": UserInfo.deptCode
			};

			var inoutPrsn;
			//20191104 - 주석
//			if(!Ext.isEmpty(BsaCodeInfo.inoutPrsn[0].refCode10)){
				inoutPrsn = UniAppManager.app.fnGetInoutPrsnUserId(UserInfo.userID);		//로그인 아이디에 따른 영업담당자 set
//			}
			if(Ext.isEmpty(panelResult.getValue('INOUT_PRSN')) && Ext.isEmpty(inoutPrsn)){
				inoutPrsn = UniAppManager.app.fnGetInoutPrsnDivCode(UserInfo.divCode);		//사업장의 첫번째 영업담당자 set
			}

			str110ukrvService.deptWhcode(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					 panelResult.setValue('WH_CODE', provider['WH_CODE']);
				}
			});

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('INOUT_PRSN',inoutPrsn);
			panelResult.setValue('CUSTOM_CODE','');
			panelResult.setValue('CUSTOM_NAME','');
			panelResult.setValue('INOUT_NUM','');
			panelResult.setValue('RETURN_AMT','0');
			panelResult.setValue('VAT_AMT','0');
			panelResult.setValue('INOUT_DATE',new Date());
			//panelResult.setValue('ITEM_STATUS', '2');
			//20200417 S160 공통코드 값으로 기본값 대체
			panelResult.setValue('ITEM_STATUS'	, sItemStatusType);
			//20191011 추가
			panelResult.setValue('EXCHG_RATE_O'	, '1');
			panelResult.setValue('MONEY_UNIT'	, UserInfo.currency);

			panelResult.getForm().findField('RETURN_AMT').setReadOnly(true);
			panelResult.getForm().findField('VAT_AMT').setReadOnly(true);
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
			if(BsaCodeInfo.gsAutoType == "Y"){
				panelResult.getForm().findField('INOUT_NUM').setReadOnly(true);
			}else{
				panelResult.getForm().findField('INOUT_NUM').setReadOnly(false);
			}
			//20191011 panelResult에 화폐, 환율 추가로 인해.. 행추가후에 참조 불가능 하도록 변경에 따른 추가 로직
			detailGrid.down('#excelBtn').enable();
			detailGrid.down('#saleReferBtn').enable();
			detailGrid.down('#estimateBtn').enable();
			//20210312 추가
			panelResult.setValue('BILL_TYPE', 10);
			panelResult.getField('CARD_CUSTOM_CODE').setReadOnly(true);
		},
		//20200115 반품현황 조회에서 넘어오는 링크 받는 로직 추가
		processParams: function(params) {
			if(params.PGM_ID == 'str320skrv') {
				if(!Ext.isEmpty(params.INOUT_NUM)){
					isLoad = true;
					fnSetColumnFormat(params.MONEY_UNIT);
					isLoad = true;
					panelResult.setValue('DIV_CODE'		, params.DIV_CODE);
					panelResult.setValue('INOUT_NUM'	, params.INOUT_NUM);
					panelResult.setValue('INOUT_DATE'	, params.INOUT_DATE);
					panelResult.setValue('INOUT_PRSN'	, params.INOUT_PRSN);
					panelResult.setValue('CUSTOM_CODE'	, params.CUSTOM_CODE);
					panelResult.setValue('CUSTOM_NAME'	, params.CUSTOM_NAME);
					panelResult.setValue('INSPEC_NUM'	, params.INSPEC_NUM);
					panelResult.setValue('MONEY_UNIT'	, params.MONEY_UNIT);
					panelResult.setValue('EXCHG_RATE_O'	, params.EXCHG_RATE_O);
					CustomCodeInfo.gsTaxInout		= params.TAX_TYPE;
					CustomCodeInfo.gsAgentType		= params.AGENT_TYPE;
					CustomCodeInfo.gsUnderCalBase	= params.WON_CALC_BAS;
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
				Unilite.messageBox('<t:message code="system.label.sales.custom" default="거래처"/>:<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			//마스터 데이타 수정 못 하도록 설정
			return panelResult.setAllFieldsReadOnly(true);
		},
		fnOrderAmtCal: function(rtnRecord, sType, nValue, taxType) {
			var dTransRate= sType=='R' ? nValue : Unilite.nvl(rtnRecord.get('TRANS_RATE'),1);
			var dOrderQ= sType=='Q' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_Q'),0);
			var dOrderP= sType=='P' ? (nValue != null ? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_P'),0))  : Unilite.nvl(rtnRecord.get('ORDER_UNIT_P'),0); //단가
			var dOrderO= sType=='O' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_O'),0); //금액
			var dDcRate= sType=='C' ? nValue : Unilite.nvl(100 - rtnRecord.get('DISCOUNT_RATE'),0);
			var saleBasisP = Unilite.nvl(rtnRecord.get('SALE_BASIS_P'),0);
			if(sType == "P" || sType == "Q"){
				dOrderO = dOrderQ * dOrderP;
				rtnRecord.set('ORDER_UNIT_O', dOrderO);
				//Unilite.messageBox('1586 dOrderO : ' + dOrderO);
				this.fnTaxCalculate(rtnRecord, dOrderO, taxType);
			}else if(sType == "O"){
				if(dOrderQ > 0){
					dOrderP = dOrderO / (dOrderQ * dTransRate);
					rtnRecord.set('ORDER_UNIT_P', dOrderP);
				}
				this.fnTaxCalculate(rtnRecord, dOrderO, taxType);
			}else if(sType == "C"){
//				dOrderP = (dOrderP - (dOrderP * (dDcRate / 100)));
				dOrderP = (saleBasisP - (saleBasisP * (dDcRate / 100)));
				rtnRecord.set('ORDER_UNIT_P', dOrderP);
				dOrderO = dOrderQ * dOrderP;
				rtnRecord.set('ORDER_UNIT_O', dOrderO);
				this.fnTaxCalculate(rtnRecord, dOrderO, taxType);
			}
		},
		fnTaxCalculate: function(rtnRecord, dOrderO, taxType) {
//			var sTaxType = rtnRecord.get('TAX_TYPE');
			var sTaxType = Ext.isEmpty(taxType)? rtnRecord.get('TAX_TYPE') : taxType;//과세여부 : 1
			var sWonCalBas = CustomCodeInfo.gsUnderCalBase;	//round 여부 : 3
			var sTaxInoutType = Ext.isEmpty(gsTaxInout) ? CustomCodeInfo.gsTaxInout: gsTaxInout;  //세액 포함여부 : 1, 20210521 수정: gsTaxInout에 값이 없을 때, 기존로직 수행
			var dVatRate = parseInt(BsaCodeInfo.gsVatRate);			//10
			var dOrderAmtO = 0;
			var dTaxAmtO = 0;
			var dAmountI = 0;
			var dTemp = 0;
			//20191212 수정
//			var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
			//20200121 화폐단위 관련로직 수정
//			var digit = UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
//			var numDigitOfPrice	= UniFormat.Price.length - digit;
			if(panelResult.getValue('MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
				var digit = UniFormat.FC.indexOf(".") == -1 ? UniFormat.FC.length : UniFormat.FC.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.FC.length - digit;
			} else {
				var digit = UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
				var numDigitOfPrice	= UniFormat.Price.length - digit;
			}
			if(!Ext.isEmpty(rtnRecord.get('ORDER_NUM'))){
				sTaxInoutType = rtnRecord.get('SOF100_TAX_INOUT');
			}

			if(sTaxInoutType == "1"){//별도
				dOrderAmtO = dOrderO;
				//Unilite.messageBox('1619 dOrderAmtO : ' + dOrderAmtO);
				dTaxAmtO   = dOrderO * dVatRate / 100;
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderAmtO, sWonCalBas, numDigitOfPrice);
				//Unilite.messageBox('1621 dOrderAmtO : ' + dOrderAmtO);
				//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림
				dTaxAmtO   = UniSales.fnAmtWonCalc(dTaxAmtO, sWonCalBas, numDigitOfPrice);
			}else if(sTaxInoutType == "2"){//포함
				dAmountI = dOrderO
				if(UserInfo.compCountry == "CN"){
					dTemp = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '3', numDigitOfPrice);
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc((dTemp * dVatRate / 100, '3', numDigitOfPrice));
				}else{
					dTemp = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, sWonCalBas, numDigitOfPrice);
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, sWonCalBas, numDigitOfPrice);
				}
				dOrderAmtO = UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), sWonCalBas, numDigitOfPrice);
			}

			if(sTaxType == "2"){
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderO, sWonCalBas, numDigitOfPrice);
				dTaxAmtO = 0;
			}
			rtnRecord.set('ORDER_UNIT_O'	, dOrderAmtO);
			rtnRecord.set('INOUT_TAX_AMT'	, dTaxAmtO);
			rtnRecord.set('ORDER_O_TAX_O'	, (dOrderAmtO + dTaxAmtO));
			rtnRecord.set('ORDER_AMT_SUM'	, dOrderAmtO + dTaxAmtO);
			//20191011 추가: EXCHANGE_AMOUNT - ˂t:message code="system.label.sales.exchangeamount" default="환산액"/˃
			//20200121 수정
//			rtnRecord.set('EXCHANGE_AMOUNT'	, Unilite.multiply((dOrderAmtO + dTaxAmtO), rtnRecord.get('EXCHG_RATE_O')));
			var digit = UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
			var numDigitOfPrice	= UniFormat.Price.length - digit;
			//20200611 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
			rtnRecord.set('EXCHANGE_AMOUNT'	, UniSales.fnAmtWonCalc(UniSales.fnExchangeApply(rtnRecord.get('MONEY_UNIT'), Unilite.multiply((dOrderAmtO + dTaxAmtO), rtnRecord.get('EXCHG_RATE_O'))), sWonCalBas, numDigitOfPrice));
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
		fnSalePrsn: function(rtnRecord, divCode) {	//사업장별 영업담당 가져오기
			Ext.each(BsaCodeInfo.salePrsn, function(item, i) {
				if(item['refCode1'] == divCode && !Ext.isEmpty(item['refCode1'])) {
					salePrsn = item['codeNo'];
					return false;
				}
			});
			if(Ext.isEmpty(salePrsn)){
				salePrsn = '01'
			}
			return salePrsn;
		},
		// UniSales.fnGetPriceInfo callback 함수
		cbGetPriceInfo: function(provider, params) {
			if(params.sType=='I') {
				var orderUnitP = 0;
				if(Ext.isEmpty(provider['SALE_PRICE'])){
					params.rtnRecord.set('ORDER_UNIT_P', 0 );
					params.rtnRecord.set('SALE_BASIS_P'	, 0);
					orderUnitP = 0;
				}else{
					params.rtnRecord.set('ORDER_UNIT_P', provider['SALE_PRICE'] );
					params.rtnRecord.set('SALE_BASIS_P'	, provider['SALE_PRICE']);
					orderUnitP = provider['SALE_PRICE'];
				}

				if(Ext.isEmpty(provider['TRNS_RATE'])){
					params.rtnRecord.set('TRNS_RATE', 1 );
				}else{
					params.rtnRecord.set('TRNS_RATE', provider['TRNS_RATE'] );
				}

				if(Ext.isEmpty(provider['DC_RATE'])){
					params.rtnRecord.set('DISCOUNT_RATE', 0 );
				}else{
					params.rtnRecord.set('DISCOUNT_RATE', provider['DC_RATE'] );
				}
			}
			if(params.rtnRecord.get('ORDER_UNIT_Q') > 0){
				UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P", orderUnitP);
			}
		},
		fnAccountYN: function(subCode) {
			var fRecord ='';
			Ext.each(BsaCodeInfo.gsOutType, function(item, i) {
				if(item['codeNo'] == subCode && !Ext.isEmpty(item['refCode1'])) {
					fRecord = item['refCode1'];
				}
			});
			if(Ext.isEmpty(fRecord)){
				fRecord = 'N'
			}
			return fRecord;
		},
		//20191008 그리드 반품유형에 따라 양불구분 값 SET하는 함수 생성
		fnGetItemStatus: function(subCode) {
			var fRecord ='';
			Ext.each(BsaCodeInfo.gsOutType, function(item, i) {
				if(item['codeNo'] == subCode && !Ext.isEmpty(item['refCode4'])) {
					fRecord = item['refCode4'];
				}
			});
			if(Ext.isEmpty(fRecord)){
				fRecord = panelResult.getValue('ITEM_STATUS').ITEM_STATUS;
			}
			return fRecord;
		},
		//20191011 추가
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE')),
				"MONEY_UNIT": panelResult.getValue('MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(panelResult.getValue('MONEY_UNIT')) && panelResult.getValue('MONEY_UNIT') != UserInfo.currency){
						Unilite.messageBox('<t:message code="system.message.sales.datacheck008" default="환율정보가 없습니다."/>')
					}
					panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
				}
			});
		},fnMakeExcelRef: function(records){
			var flag = true;
			if(!this.checkForNewDetail()){
				 flag = false;
				 return false;
			}
			//Detail Grid Default 값 설정
			var orderNum = panelResult.getValue('ORDER_NUM')
			var newDetailRecords = new Array();
			var inoutSeq = 0;
				inoutSeq = detailStore.max('INOUT_SEQ');
			if(!inoutSeq) inoutSeq = 1;
			else  inoutSeq += 1;

			var inoutNum = '';
			if(!Ext.isEmpty(panelResult.getValue('INOUT_NUM'))) {
				inoutNum = panelResult.getValue('INOUT_NUM');
			}

			var inoutCode = '';
			if(!Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
				inoutCode = panelResult.getValue('CUSTOM_CODE');
			}

			var inoutDate = '';
			if(!Ext.isEmpty(panelResult.getValue('INOUT_DATE'))) {
				inoutDate = panelResult.getValue('INOUT_DATE');
			}

			var inoutPrsn = '';
			if(!Ext.isEmpty(panelResult.getValue('INOUT_PRSN'))) {
				inoutPrsn = panelResult.getValue('INOUT_PRSN');
			}

			var saleCustomCode = '';
			if(!Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
				saleCustomCode = panelResult.getValue('CUSTOM_CODE');
			}

			var salePrsn = UniAppManager.app.fnSalePrsn(null, panelResult.getValue('DIV_CODE'));	//사업장의 영업담당 가져오기

			var deptCode = '';
			if(!Ext.isEmpty(panelResult.getValue('DEPT_CODE'))) {
				deptCode = panelResult.getValue('DEPT_CODE');
			}

			var whCode = '';
			if(!Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
				whCode = panelResult.getValue('WH_CODE');
			}

			var whCellCode = '';
			if(!Ext.isEmpty(panelResult.getValue('WH_CELL_CODE'))){
				whCellCode= panelResult.getValue('WH_CELL_CODE');
			}

			var saleDivCode = '';
			if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))) {
				saleDivCode = panelResult.getValue('DIV_CODE');
			}

			var whCode = '';
			if(!Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
				whCode = panelResult.getValue('WH_CODE');
			}
			var taxInout = CustomCodeInfo.gsTaxInout;
			var inoutSubCode = Ext.data.StoreManager.lookup('CBS_AU_S008').getAt(0).get('value');
			var accountYNC = UniAppManager.app.fnAccountYN(inoutSubCode);
			//20191008 행추가 시, 공통코드(S008)의 ref_code4가 있으면 해당 값을 ITEM_STATUS 값에 SET.. 없으면 PANEL의 값 SET하도록 수정
			var itemStatus = Ext.isEmpty(UniAppManager.app.fnGetItemStatus(inoutSubCode)) ? panelResult.getValue('ITEM_STATUS').ITEM_STATUS : UniAppManager.app.fnGetItemStatus(inoutSubCode);



			Ext.each(records, function(record,i){
				if(i == 0){
					inoutSeq = inoutSeq;
				} else {
					inoutSeq += 1;
				}

				var r = {
				INOUT_SEQ		: inoutSeq,
				INOUT_NUM		: inoutNum,
				SALE_DIV_CODE	: saleDivCode,
				DIV_CODE		: saleDivCode,
				INOUT_CODE		: inoutCode,
				INOUT_DATE		: inoutDate,
				INOUT_PRSN		: inoutPrsn,
				SALE_CUSTOM_CODE: saleCustomCode,
				SALE_PRSN		: salePrsn,
				ACCOUNT_YNC		: accountYNC,
				DEPT_CODE		: deptCode,
				WH_CODE			: whCode,
				WH_CELL_CODE	: whCellCode,
				ITEM_STATUS		: itemStatus,
				SOF100_TAX_INOUT: CustomCodeInfo.gsTaxInout,
				//20190626 추가: 20191011 수정
				EXCHG_RATE_O	: panelResult.getValue('EXCHG_RATE_O'),
				//20191011 추가
				MONEY_UNIT		: panelResult.getValue('MONEY_UNIT'),
				//20200121 추가: panel의 화폐단위와 BsaCodeInfo.gsMoneyUnit가 같으면 과세, 아니면 면세
				TAX_TYPE		: panelResult.getValue('MONEY_UNIT') == BsaCodeInfo.gsMoneyUnit ? 1 : 2,
				//20200417 추가: 통화가 같으면 첫번째 값 아니면 40(직수출)
				SALE_TYPE		: panelResult.getValue('MONEY_UNIT') == BsaCodeInfo.gsMoneyUnit ? Ext.data.StoreManager.lookup('CBS_AU_S002').getAt(0).get('value') : '40'
				};
				newDetailRecords[i] = detailStore.model.create( r );
				newDetailRecords[i].set('SALE_DIV_CODE'		, panelResult.getValue('DIV_CODE'));
				newDetailRecords[i].set('INOUT_TYPE_DETAIL'	, record.get('INOUT_TYPE_DETAIL'));
				newDetailRecords[i].set('INOUT_NUM'			, panelResult.getValue('INOUT_NUM'));
				newDetailRecords[i].set('WH_CODE'				, record.get('WH_CODE'));

				newDetailRecords[i].set('WH_CELL_CODE'		, record.get('WH_CELL_CODE'));
				newDetailRecords[i].set('ITEM_CODE'			, record.get('ITEM_CODE'));
				newDetailRecords[i].set('ITEM_NAME'			, record.get('ITEM_NAME'));
				newDetailRecords[i].set('SPEC'				, record.get('SPEC'));
				newDetailRecords[i].set('ORDER_UNIT'			, record.get('ORDER_UNIT'));
				newDetailRecords[i].set('TRNS_RATE'			, record.get('TRNS_RATE'));
				newDetailRecords[i].set('TAX_TYPE'			, record.get('TAX_TYPE'));
				newDetailRecords[i].set('ORDER_UNIT_Q'		, record.get('ORDER_UNIT_Q'));
				newDetailRecords[i].set('ORDER_UNIT_P'		, record.get('ORDER_UNIT_P'));
				newDetailRecords[i].set('ORDER_UNIT_O'		, record.get('ORDER_UNIT_O'));
				newDetailRecords[i].set('INOUT_TAX_AMT'		, record.get('INOUT_TAX_AMT'));
				if(record['ORDER_AMT_SUM'] > 0 )	{
					newDetailRecords[i].set('ORDER_AMT_SUM'		, record.get('ORDER_AMT_SUM'));
				} else {
					newDetailRecords[i].set('ORDER_AMT_SUM'       , parseFloat(record.get('ORDER_UNIT_O')) + parseFloat(record.get('INOUT_TAX_AMT')))
				}
				newDetailRecords[i].set('TAX_TYPE'		, record.get('TAX_TYPE'));
				newDetailRecords[i].set('ITEM_STATUS'		, record.get('ITEM_STATUS'));
				newDetailRecords[i].set('ACCOUNT_YNC'		, record.get('ACCOUNT_YNC'));
				newDetailRecords[i].set('REMARK'			, record.get('REMARK'));

				newDetailRecords[i].set('INOUT_METH'			, '1');

				newDetailRecords[i].set('SOF100_TAX_INOUT'	, Unilite.nvl(record.get('SOF100_TAX_INOUT'), CustomCodeInfo.gsTaxInout));
				newDetailRecords[i].set('PROJECT_NO'			, record.get('PROJECT_NO'));
				newDetailRecords[i].set('BILL_TYPE'			, '10');
				newDetailRecords[i].set('LOT_NO'				, record.get('LOT_NO'));
				//20190527 수정: 20191014 수정
				newDetailRecords[i].set('MONEY_UNIT'			, panelResult.getValue('MONEY_UNIT'));	//record['MONEY_UNIT']);;
				newDetailRecords[i].set('EXCHG_RATE_O'	, panelResult.getValue('EXCHG_RATE_O'));	//record['EXCHG_RATE_O']);
				UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "P");
			})

			detailStore.loadData(newDetailRecords, true);
			/*//20200123 상위행의 매출유형, 매출대상여부 적용하는 로직 추가
			var records			= detailGrid.getStore().data.items;
			var selectedRecord	= detailGrid.getSelectedRecord();
			var selectedIndex	= 0
			Ext.each(records, function(record, i){
				if(record.get('INOUT_SEQ') == selectedRecord.get('INOUT_SEQ')) {
					selectedIndex = i;
				}
			});
			if(selectedIndex > 0) {detailGrid.getSelectedRecord().getPrevious
				selectedRecord.set('INOUT_TYPE_DETAIL'	, detailGrid.getStore().getAt(selectedIndex - 1).get('INOUT_TYPE_DETAIL'));
				selectedRecord.set('ACCOUNT_YNC'		, detailGrid.getStore().getAt(selectedIndex - 1).get('ACCOUNT_YNC'));
				selectedRecord.set('WH_CODE'			, detailGrid.getStore().getAt(selectedIndex - 1).get('WH_CODE'));
				selectedRecord.set('WH_CELL_CODE'		, detailGrid.getStore().getAt(selectedIndex - 1).get('WH_CELL_CODE'));
			}*/

			return flag;
		}
	});



	//바코드 입력 로직 (lot_no)
	function fnEnterBarcode(newValue) {
		//동일한 LOT_NO 입력되었을 경우 처리
		var masterRecords		= detailStore.data.items;
		var itemCode			= newValue.split('|')[0].toUpperCase();
		var barcodeLotNo		= newValue.split('|')[1];
		var goodStockBarcodeQ	= Ext.isEmpty(newValue.split('|')[2]) ? 0 : newValue.split('|')[2];
		var flag = true;

		if(!Ext.isEmpty(barcodeLotNo)) {
			barcodeLotNo = barcodeLotNo.toUpperCase();

		} else {
			itemCode			= ''
			barcodeLotNo		= newValue.split('|')[0].toUpperCase();
			goodStockBarcodeQ	= 0;
		}

		var param = panelResult.getValues();
		param.ITEM_CODE		= itemCode;
		param.LOT_NO		= barcodeLotNo;
		param.WH_CODE		= '';										//기출고창고

		if (barcodeLotNo.substring(0, 1) == 'X') {
//			COMP_CODE, DIV_CODE, BOX_BARCODE, LOT_NO -- str800t에서 lot_no 가져와서 이후 로직 수행
			str110ukrvService.getLotNo(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					Ext.each(provider, function(record, i) {
						itemCode			= provider[i].ITEM_CODE;
						barcodeLotNo		= provider[i].LOT_NO;

						Ext.each(masterRecords, function(masterRecord,i) {
							if(masterRecord.get('LOT_NO').toUpperCase() == barcodeLotNo) {
								beep();
								gsText = '<t:message code="system.message.inventory.message004" default="이미 등록한 품목 입니다."/>' + '\n' + 'Lot no. : ' + barcodeLotNo;
								openAlertWindow(gsText);
								panelResult.setValue('BARCODE', '');
								panelResult.getField('BARCODE').focus();
								flag = false;
								return false;
							}
						});

						if(!flag) {
							Ext.getCmp('str110ukrvApp').unmask();
							return false;
						}
					});

					if(flag) {
						Ext.each(provider, function(record, i) {
							itemCode			= provider[i].ITEM_CODE;
							barcodeLotNo		= provider[i].LOT_NO;

							var param = {
								DIV_CODE	: panelResult.getValue('DIV_CODE'),
								ITEM_CODE	: itemCode,
								ITEM_NAME	: '',
								CUSTOM_CODE	: panelResult.getValue('CUSTOM_CODE'),
								CUSTOM_NAME	: panelResult.getValue('CUSTOM_NAME'),
								LOT_NO		: barcodeLotNo
							}
							//출고참조 로직 수행
							str110ukrvService.selectSaleReferList(param, function(provider, response){
								if(!Ext.isEmpty(provider)) {
									UniAppManager.app.onNewDataButtonDown();
									detailGrid.setSaleRefer(provider[0]);
									panelResult.getField('BARCODE').focus();
									Ext.getCmp('str110ukrvApp').unmask();
								}
							});
						});

					} else {
						Ext.getCmp('str110ukrvApp').unmask();
					}
				}
			});

		} else {
			Ext.each(masterRecords, function(masterRecord,i) {
				if(masterRecord.get('LOT_NO').toUpperCase() == barcodeLotNo) {
					beep();
					gsText = '<t:message code="system.message.inventory.message004" default="이미 등록한 품목 입니다."/>' + '\n' + 'Lot no. : ' + barcodeLotNo;
					openAlertWindow(gsText);
					panelResult.setValue('BARCODE', '');
					panelResult.getField('BARCODE').focus();
					flag = false;
					return false;
				}
			});

			if(!flag) {
				Ext.getCmp('str110ukrvApp').unmask();
				return false;
			}

			var param = {
				DIV_CODE	: panelResult.getValue('DIV_CODE'),
				ITEM_CODE	: itemCode,
				ITEM_NAME	: '',
				CUSTOM_CODE	: panelResult.getValue('CUSTOM_CODE'),
				CUSTOM_NAME	: panelResult.getValue('CUSTOM_NAME'),
				LOT_NO		: barcodeLotNo
			}
			//출고참조 로직 수행
			str110ukrvService.selectSaleReferList(param, function(provider, response){
				if(!Ext.isEmpty(provider)) {
					UniAppManager.app.onNewDataButtonDown();
					detailGrid.setSaleRefer(provider[0]);
				}
				panelResult.getField('BARCODE').focus();
				Ext.getCmp('str110ukrvApp').unmask();
			});
		}
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
				text	: '<t:message code="system.label.inventory.confirm" default="확인"/>',
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
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, detailGrid) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if(record.phantom){
				if(record.get('ACCOUNT_Q ') > 0 && BsaCodeInfo.gsReturnAutoYN == "N"){
					rv = '<t:message code="system.message.sales.message069" default="계산서가 발행된 건은 수정할 수 없습니다."/>';
				}
			}

			switch(fieldName) {
				case "INOUT_SEQ" :
					if(newValue <= 0 && !Ext.isEmpty(newValue)) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						break;
					}
					break;
				case "INOUT_TYPE_DETAIL" :
					record.set("ACCOUNT_YNC", UniAppManager.app.fnAccountYN(newValue));
					//20191008 그리드 반품유형 변경 시, 공통코드(S008)의 REF_CODE4 값이 있으면 해당 값 없으면 PANEL값으로 ITEM_STATUS SET하도록 변경
					record.set("ITEM_STATUS", UniAppManager.app.fnGetItemStatus(newValue));
					break;
				case "WH_CODE" :
						if(!Ext.isEmpty(newValue)){
							record.set('WH_CELL_CODE', "");
						}else{
							record.set('WH_CELL_CODE', "");
						}
						//그리드 창고cell콤보 reLoad..
//						cbStore.loadStoreRecords(newValue);
						break;
				case "ORDER_UNIT" :
					UniSales.fnGetPriceInfo2( record
											, UniAppManager.app.cbGetPriceInfo
											,'I'
											,UserInfo.compCode
											,panelResult.getValue('CUSTOM_CODE')
											,CustomCodeInfo.gsAgentType
											,record.get('ITEM_CODE')
											,BsaCodeInfo.gsMoneyUnit
											,newValue
											,record.get('STOCK_UNIT')
											,record.get('TRANS_RATE')
											,UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'))
											,record.get('WGT_UNIT')
											,record.get('VOL_UNIT')
											)
					detailStore.fnOrderAmtSum();
					break;
				case "TRNS_RATE" :
					if(newValue < 0 && !Ext.isEmpty(newValue)) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						break;
					}
					detailStore.fnOrderAmtSum();
//					UniAppManager.app.fnOrderAmtCal(record, "Q", newValue);
					break;
				case "ORDER_UNIT_Q" :
					if(newValue < 0 && !Ext.isEmpty(newValue)) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						break;
					}
//					var sInout_q = newValue;	//반품량
//					var lot_q = record.get('TEMP_ORDER_UNIT_Q');//로트팝업에서 넘겨받는 수량
//					if(!Ext.isEmpty(lot_q) && lot_q!= 0){
//						if(sInout_q > lot_q){
//							rv = "출고량은 lot재고량을 초과할 수 없습니다. 현재고: " + lot_q;
//							break;
//						}
//					}
					detailStore.fnOrderAmtSum();
					UniAppManager.app.fnOrderAmtCal(record, "Q", newValue, record.get('TAX_TYPE'));
					break;

				case "ORDER_UNIT_P" :
					if(newValue < 0 && !Ext.isEmpty(newValue)) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						break;
					}
					detailStore.fnOrderAmtSum();
					UniAppManager.app.fnOrderAmtCal(record, "P", newValue, record.get('TAX_TYPE'));
					break;

				case "ORDER_UNIT_O" :
					var dTaxAmtO = 0;
					if(newValue < 0 && !Ext.isEmpty(newValue)) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						break;
					}
					if(Ext.isEmpty('INOUT_TAX_AMT')){
						dTaxAmtO = 0;
					}else{
						dTaxAmtO = record.get('INOUT_TAX_AMT');
					}

					if(newValue > 0 && dTaxAmtO > newValue){
						rv='<t:message code="system.message.sales.message040" default="매출금액은 세액보다 커야 합니다."/>';
						break;
					}
					detailStore.fnOrderAmtSum();
					UniAppManager.app.fnOrderAmtCal(record, "O", newValue, record.get('TAX_TYPE'));
					rv = false;
					break;

				case "TAX_TYPE" :
//					if(newValue == "1"){
//						var inoutTax = record.get('ORDER_UNIT_O') / 10
//						record.set('INOUT_TAX_AMT', inoutTax);
//					}else if(newValue == "2"){
//						record.set('INOUT_TAX_AMT', 0);
//					}

//					if(!Ext.isEmpty(newValue) && newValue == "1"){
//						var inoutTax = record.get('ORDER_UNIT_O') / 10
//						record.set('INOUT_TAX_AMT', inoutTax);
//						record.set('TAX_TYPE', newValue)
//					}else if(!Ext.isEmpty(newValue) && newValue == "2"){
//						record.set('INOUT_TAX_AMT', 0);
//						record.set('TAX_TYPE', newValue)
//					}

					var dOrderO=record.get('ORDER_UNIT_Q')*record.get('ORDER_UNIT_P');
					record.set('ORDER_UNIT_O', dOrderO);
					UniAppManager.app.fnOrderAmtCal(record, "O", dOrderO, newValue);
					detailStore.fnOrderAmtSum();
					break;

				case "INOUT_TAX_AMT" :
					var dSaleAmtO = 0;
					if(Ext.isEmpty('ORDER_UNIT_O')){
						dSaleAmtO = 0;
					}else{
						dSaleAmtO = record.get('ORDER_UNIT_O');
					}
					if(newValue < 0 && !Ext.isEmpty(newValue)) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						break;
					}
					//20191011 사용 안하는 로직 주석
//					if(Ext.isEmpty('ORDER_UNIT_O')){
//						dTaxAmtO = 0;
//					}else{
//						dTaxAmtO = record.get('ORDER_UNIT_O');
//					}
					if(dSaleAmtO > 0 && dSaleAmtO < newValue){
						rv='<t:message code="system.message.sales.message036" default="세액은 매출액보다 작아야 합니다."/>';
						break;
					}
					if(UserInfo.compCountry == "CN"){	//// str110ukrs1.htm 1077줄보고 참조
						break;
					}

					var orderO = record.get('ORDER_UNIT_O')
					var inoutTaxAmt = newValue;
					record.set('ORDER_O_TAX_O'	,(orderO + inoutTaxAmt));
					//20191011 누락된 로직 추가
					record.set('ORDER_AMT_SUM'	,(orderO + inoutTaxAmt));
					//20200611 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
					record.set('EXCHANGE_AMOUNT', UniSales.fnExchangeApply(record.get('MONEY_UNIT'), Unilite.multiply((orderO + inoutTaxAmt), record.get('EXCHG_RATE_O'))));
					detailStore.fnOrderAmtSum();
					break;

				case "DISCOUNT_RATE" :
					if(newValue < 0 && !Ext.isEmpty(newValue)) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						break;
					}
					detailStore.fnOrderAmtSum();
					UniAppManager.app.fnOrderAmtCal(record, "C", (100 - newValue), record.get('TAX_TYPE'));
					break;
				case "ORDER_NUM" : //editable에서 이미 전부false이므로 구현 않함.
					break;
				case "PROJECT_NO" :////관리번호 팝업 만들어야함.
					break;
			}
			return rv;
		}
	}); // validator



	//20191008 화폐에 따라 컬럼 포맷설정하는 부분 함수로 뺀 후, 여러곳에서 호출하도록 수정
	function fnSetColumnFormat(moneyUnit) {
		var length = 0
		var format = ''
		if(moneyUnit != BsaCodeInfo.gsMoneyUnit){
			length = Ext.isEmpty(UniFormat.FC.split('.')[1]) ? 0 : UniFormat.FC.split('.')[1].length;
			format = UniFormat.FC;
		} else {
			length = Ext.isEmpty(UniFormat.Price.split('.')[1]) ? 0 : UniFormat.Price.split('.')[1].length;
			format = UniFormat.Price;
		}
		panelResult.getField('RETURN_AMT').setConfig('decimalPrecision',length);
		panelResult.getField('RETURN_AMT').focus();
		panelResult.getField('RETURN_AMT').blur();
		panelResult.getField('VAT_AMT').setConfig('decimalPrecision',length);
		panelResult.getField('VAT_AMT').focus();
		panelResult.getField('VAT_AMT').blur();

		detailGrid.getColumn("ORDER_UNIT_O").setConfig('format'	,format);
		detailGrid.getColumn("ORDER_AMT_SUM").setConfig('format',format);
		//20191011 추가: EXCHANGE_AMOUNT - ˂t:message code="system.label.sales.exchangeamount" default="환산액"/˃
		detailGrid.getColumn("EXCHANGE_AMOUNT").setConfig('format',format);
		detailGrid.getColumn("INOUT_TAX_AMT").setConfig('format',format);
		detailGrid.getColumn("ORDER_O_TAX_O").setConfig('format',format);

		detailGrid.getColumn("ORDER_UNIT_O").setConfig('decimalPrecision',length);
		detailGrid.getColumn("ORDER_AMT_SUM").setConfig('decimalPrecision',length);
		//20191011 추가: EXCHANGE_AMOUNT - ˂t:message code="system.label.sales.exchangeamount" default="환산액"/˃
		detailGrid.getColumn("EXCHANGE_AMOUNT").setConfig('decimalPrecision',length);
		detailGrid.getColumn("INOUT_TAX_AMT").setConfig('decimalPrecision',length);
		detailGrid.getColumn("ORDER_O_TAX_O").setConfig('decimalPrecision',length);

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
		//20191011 추가: EXCHANGE_AMOUNT - ˂t:message code="system.label.sales.exchangeamount" default="환산액"/˃
		if(!Ext.isEmpty(detailGrid.getColumn("EXCHANGE_AMOUNT").config.editor) && !Ext.isEmpty(detailGrid.getColumn("EXCHANGE_AMOUNT").config.editor.decimalPrecision)) {
			detailGrid.getColumn("EXCHANGE_AMOUNT").config.editor.decimalPrecision = length;
		}
		if(!Ext.isEmpty(detailGrid.getColumn("EXCHANGE_AMOUNT").editor)) {
			detailGrid.getColumn("EXCHANGE_AMOUNT").editor.decimalPrecision = length;
		}
		if(!Ext.isEmpty(detailGrid.getColumn("INOUT_TAX_AMT").config.editor) && !Ext.isEmpty(detailGrid.getColumn("INOUT_TAX_AMT").config.editor.decimalPrecision)) {
			detailGrid.getColumn("INOUT_TAX_AMT").config.editor.decimalPrecision = length;
		}
		if(!Ext.isEmpty(detailGrid.getColumn("INOUT_TAX_AMT").editor)) {
			detailGrid.getColumn("INOUT_TAX_AMT").editor.decimalPrecision = length;
		}
		if(!Ext.isEmpty(detailGrid.getColumn("ORDER_O_TAX_O").config.editor) && !Ext.isEmpty(detailGrid.getColumn("ORDER_O_TAX_O").config.editor.decimalPrecision)) {
			detailGrid.getColumn("ORDER_O_TAX_O").config.editor.decimalPrecision = length;
		}
		if(!Ext.isEmpty(detailGrid.getColumn("ORDER_O_TAX_O").editor)) {
			detailGrid.getColumn("ORDER_O_TAX_O").editor.decimalPrecision = length;
		}

		if(isLoad){
			isLoad = false;
		} else {
			UniAppManager.app.fnExchngRateO();
		}
	}
}
</script>