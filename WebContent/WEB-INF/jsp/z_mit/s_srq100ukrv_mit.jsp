<%--
'	프로그램명 : 출하지시등록(MIT) (영업)
'	작   성   자 : 시너지지스템즈 개발실
'	작   성   일 : 20200227
'	최종수정자 :
'	최종수정일 : 20200227
'	버	 전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_srq100ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_srq100ukrv_mit" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />				<!--화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="B013" />				<!--판매단위-->
	<t:ExtComboStore comboType="AU" comboCode="B021" />				<!--품목상태-->
	<t:ExtComboStore comboType="AU" comboCode="B024" />				<!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5' />	<!--생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="B059" />				<!--과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="B116" />				<!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="S002" />				<!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="S003" />				<!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="S007" />				<!--출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="S010" />				<!--영업담당자-->
	<t:ExtComboStore comboType="AU" comboCode="S014" />				<!--매출대상-->
	<t:ExtComboStore comboType="AU" comboCode="S065" />				<!--주문구분-->
	<t:ExtComboStore comboType="AU" comboCode="S024" />				<!--부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="T008" />
	<t:ExtComboStore comboType="AU" comboCode="T016" />				<!--대금결제방법-->
	<t:ExtComboStore comboType="OU" />								<!--창고-->
	<t:ExtComboStore comboType="OU" storeId="ouChkCombo"/>			<!--창고-->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>

<script type="text/javascript">
var searchInfoWindow;	//searchInfoWindow : 조회창
var referWindow;		//참조내역
var referSCMWindow;

var BsaCodeInfo = {
	gsAutoType			: '${gsAutoType}',
	gsAutoType			: '${gsAutoType}',
	gsMoneyUnit			: '${gsMoneyUnit}',
	gsVatRate			: '${gsVatRate}',
	gsOutType			: '${grsOutType}',
	gsCredit			: '${gsCredit}',
	gsPrintPgID			: '${gsPrintPgID}',
	gsSrq100UkrLink		: '${gsSrq100UkrLink}',
	gsStr100UkrLink		: '${gsStr100UkrLink}',
	gsTimeYN1			: '${gsTimeYN1}',
	gsTimeYN2			: '${gsTimeYN2}',
	gsCreditYn			: '${gsCreditYn}',
	gsBoxQYn			: '${gsBoxQYn}',
	gsMiniPackQYn		: '${gsMiniPackQYn}',
	gsPointYn			: '${gsPointYn}',
	gsPriceGubun		: '${gsPriceGubun}',
	gsWeight			: '${gsWeight}',
	gsVolume			: '${gsVolume}',
	gsUnitChack			: '${gsUnitChack}',
	gsStatusM			: 'N',
	gsReportGubun		: '${gsReportGubun}',
	//20190925 LOT 관리기준 설정 추가
	gsLotNoInputMethod	: '${gsLotNoInputMethod}',
	gsLotNoEssential	: '${gsLotNoEssential}',
	gsEssItemAccount	: '${gsEssItemAccount}'
};
var gsLotNoEssential = BsaCodeInfo.gsLotNoEssential == 'Y' ? false : true;

var CustomCodeInfo = {
	gsAgentType		: '',
	gsUnderCalBase	: '',
	//20191212 추가
	gsTaxInout		: ''
};
var outDivCode = UserInfo.divCode;

function appMain() {
	/** 자동채번 여부
	 */
	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoOrderNum = true;
	}

	/** 수주승인 방식
	 */
	var isDraftFlag = true;
	if(BsaCodeInfo.gsDraftFlag=='1') {
		isDraftFlag = false;
	}



	// Direct Proxy 정의
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_srq100ukrv_mitService.selectList',
			update	: 's_srq100ukrv_mitService.updateDetail',
			create	: 's_srq100ukrv_mitService.insertDetail',
			syncAll	: 's_srq100ukrv_mitService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_srq100ukrv_mitService.selectList2',
			update	: 's_srq100ukrv_mitService.updateDetail2',
			destroy	: 's_srq100ukrv_mitService.deleteDetail2',
			syncAll	: 's_srq100ukrv_mitService.saveAll2'
		}
	});


	/** 마스터 정보를 가지고 있는 Form
	 */
	var masterForm = Unilite.createSearchForm('masterForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'DVRY_DATE_FR',
			endFieldName	: 'DVRY_DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},
		Unilite.popup('ORDER_NUM',{
			fieldLabel		: '<t:message code="system.label.sales.sono" default="수주번호"/>',
			textFieldName	: 'ORDER_NUM',
			validateBlank	: false,
			colspan			: 2,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE'	: masterForm.getValue('DIV_CODE')});
					popup.setExtParam({'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
			name		: 'ORDER_TYPE',
			comboType	: 'AU',
			comboCode	: 'S002',
			xtype		: 'uniCombobox',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype		: 'container',
			layout		: { type: 'uniTable', columns: 2},
			colspan		: 2,
			items		: [
				Unilite.popup('DIV_PUMOK',{
					fieldLabel		: '<t:message code="system.label.sales.itemcode" default="품목코드"/>',
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('SPEC', records[0]["SPEC"]);
							},
							scope: this
						},
						onClear: function(type) {
							masterForm.setValue('SPEC', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						},
						onValueFieldChange: function(field, newValue){
							if(Ext.isEmpty(newValue)) {
								masterForm.setValue('ITEM_NAME'	, '');
								masterForm.setValue('SPEC'		, '');
							}
						},
						onTextFieldChange: function(field, newValue){
						}
					}
			}),{
				name	: 'SPEC',
				xtype	: 'uniTextfield'
			}]
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>' ,
			holdable		: 'hold',
			validateBlank	: false,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						CustomCodeInfo.gsAgentType		= records[0]["AGENT_TYPE"];
						CustomCodeInfo.gsCustCrYn		= records[0]["CREDIT_YN"];
						CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"];
						//20191212 추가
						CustomCodeInfo.gsTaxInout		= records[0]["TAX_TYPE"];
					},
					scope: this
				},
				onClear: function(type) {
					CustomCodeInfo.gsAgentType		= '';
					CustomCodeInfo.gsCustCrYn		= '';
					CustomCodeInfo.gsUnderCalBase	= '';
					//20191212 추가
					CustomCodeInfo.gsTaxInout		= '';
				}/*,
				onValueFieldChange: function(field, newValue){
					masterForm.setValue('CUSTOM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					masterForm.setValue('CUSTOM_NAME', newValue);
				}*/
			}
		}),{//20200302 추가: 합계수량 추가
			fieldLabel	: '합계수량',
			xtype		: 'uniNumberfield',
			name		: 'SUM_ISSUE_REQ_QTY',
			type		: 'uniQty',
			readOnly	: true
		},{	//20200302 추가: 합계금액 추가
			fieldLabel	: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>',
			xtype		: 'uniNumberfield',
			name		: 'SUM_ISSUE_REQ_AMT',
			type		: 'uniPrice',
			readOnly	: true
		}],
		listeners: {
			//20170518 - 폼변경시 저장버튼 활성화 되는 로직 없음 : 주석 처리
//			uniOnChange: function(basicForm, dirty, eOpts) {
//				UniAppManager.setToolbarButtons('save', true);
//			}
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
						if(Ext.isDefined(item.holdable)) {
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
					if(Ext.isDefined(item.holdable)) {
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
	}); //End of var masterForm = Unilite.createForm('srq101ukrvMasterForm', {



	//모델 정의
	Unilite.defineModel('s_srq100ukrv_mitDetailModel', {
		fields: [
			{name: 'DIV_CODE'			, text:'<t:message code="system.label.sales.division" default="사업장"/>'						, type: 'string', 	defaultValue: UserInfo.divCode},
			{name: 'ISSUE_REQ_METH'		, text:'<t:message code="system.label.sales.shipmentordermethod" default="출하지시방법"/>'		, type: 'string', defaultValue: '2'},
			{name: 'ISSUE_REQ_PRSN'		, text:'<t:message code="system.label.sales.shipmentordercharger" default="출하지시담당자"/>'		, type: 'string', comboType: 'AU', comboCode: 'S010'},
			{name: 'ISSUE_REQ_DATE'		, text:'<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'			, type: 'uniDate'},
			{name: 'ISSUE_REQ_NUM'		, text:'<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'			, type: 'string', editable: false},		//20200402 수정: 수정 불가
			{name: 'ISSUE_REQ_SEQ'		, text:'<t:message code="system.label.sales.seq" default="순번"/>'							, type: 'int'	, allowBlank:true , editable:false},
			{name: 'CUSTOM_CODE'		, text:'<t:message code="system.label.sales.client" default="고객"/>'							, type: 'string', allowBlank:false},
			{name: 'CUSTOM_NAME'		, text:'<t:message code="system.label.sales.client" default="고객"/>'							, type: 'string', allowBlank:false},
			{name: 'BILL_TYPE'			, text:'<t:message code="system.label.sales.vattype" default="부가세유형"/>'						, type: 'string' , comboType: 'AU', comboCode: 'S024', allowBlank:false},
			{name: 'ORDER_TYPE'			, text:'<t:message code="system.label.sales.sellingtype" default="판매유형"/>'					, type: 'string' , comboType: 'AU', comboCode: 'S002', allowBlank:false},
			{name: 'INOUT_TYPE_DETAIL'	, text:'<t:message code="system.label.sales.issuetype" default="출고유형"/>'					, type: 'string' , comboType: 'AU', comboCode: 'S007', allowBlank:false},
			{name: 'ISSUE_DIV_CODE'		, text:'<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'				, type: 'string' , comboType: 'BOR120'/*, child:'WH_CODE'*/, allowBlank:false},
			{name: 'WH_CODE'			, text:'<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'				, type: 'string' , comboType: 'OU', allowBlank:false},
			{name: 'WH_CELL_CODE'		, text:'출고창고CELL'																			, type: 'string'},
			{name: 'ITEM_CODE'			, text:'<t:message code="system.label.sales.item" default="품목"/>'							, type: 'string', allowBlank:false},
			{name: 'ITEM_NAME'			, text:'<t:message code="system.label.sales.itemname" default="품목명"/>'						, type: 'string', allowBlank:false},
			{name: 'SPEC'				, text:'<t:message code="system.label.sales.spec" default="규격"/>'							, type: 'string'},
			{name: 'ORDER_UNIT'			, text:'<t:message code="system.label.sales.unit" default="단위"/>'							, type: 'string' , comboType: 'AU', comboCode: 'B013', allowBlank:false, displayField: 'value'},
			{name: 'PRICE_TYPE'			, text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'					, type: 'string' , comboType: 'AU', comboCode: 'B116', defaultValue:BsaCodeInfo.gsPriceGubun},
			{name: 'TRANS_RATE'			, text:'<t:message code="system.label.sales.containedqty" default="입수"/>'					, type: 'uniQty', defaultValue:1, allowBlank:false},
			{name: 'STOCK_Q'			, text:'<t:message code="system.label.sales.inventoryqty" default="재고량"/>'					, type: 'uniQty'},
			{name: 'ISSUE_REQ_QTY'		, text:'<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'			, type: 'uniQty', defaultValue:0, allowBlank:false},
			{name: 'ISSUE_FOR_PRICE'	, text:'<t:message code="system.label.sales.foreigncurrencyunit" default="외화단가"/>'			, type: 'uniUnitPrice', defaultValue:0},
			{name: 'ISSUE_WGT_Q'		, text:'<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>(<t:message code="system.label.sales.weight" default="중량"/>)'	, type: 'uniQty', defaultValue:0},
			{name: 'ISSUE_FOR_WGT_P'	, text:'<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'				, type: 'uniUnitPrice', defaultValue:0},
			{name: 'ISSUE_VOL_Q'		, text:'<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'	, type: 'uniQty', defaultValue:0},
			{name: 'ISSUE_FOR_VOL_P'	, text:'<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'				, type: 'uniUnitPrice', defaultValue:0},
			{name: 'ISSUE_FOR_AMT'		, text:'<t:message code="system.label.sales.foreigncurrencyamount" default="외화금액"/>'		, type: 'uniFC', defaultValue:0},
			{name: 'ISSUE_REQ_PRICE'	, text:'<t:message code="system.label.sales.price" default="단가"/>'							, type: 'uniUnitPrice', defaultValue:0},
			{name: 'ISSUE_WGT_P'		, text:'<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'				, type: 'uniUnitPrice', defaultValue:0},
			{name: 'ISSUE_VOL_P'		, text:'<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'				, type: 'uniUnitPrice', defaultValue:0},
			{name: 'ISSUE_REQ_AMT'		, text:'<t:message code="system.label.sales.amount" default="금액"/>'							, type: 'uniPrice', defaultValue:0},
			{name: 'TAX_TYPE'			, text:'<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'				, type: 'string', comboType: 'AU', comboCode: 'B059', allowBlank:false},
			{name: 'ISSUE_REQ_TAX_AMT'	, text:'<t:message code="system.label.sales.taxamount" default="세액"/>'						, type: 'uniPrice', defaultValue:0},
			{name: 'WGT_UNIT'			, text:'<t:message code="system.label.sales.weightunit" default="중량단위"/>'					, type: 'string', comboType: 'AU', comboCode: 'B013', defaultValue:BsaCodeInfo.gsWeight, displayField: 'value'},
			{name: 'UNIT_WGT'			, text:'<t:message code="system.label.sales.unitweight" default="단위중량"/>'					, type: 'int', comboType: 'AU', comboCode: 'B013', displayField: 'value'},
			{name: 'VOL_UNIT'			, text:'<t:message code="system.label.sales.volumnunit" default="부피단위"/>'					, type: 'string', defaultValue:BsaCodeInfo.gsVolume},
			{name: 'UNIT_VOL'			, text:'<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'					, type: 'int'},
			{name: 'ISSUE_DATE'			, text:'<t:message code="system.label.sales.issuerequestdate" default="출고요청일"/>'			, type: 'uniDate', allowBlank:false},
			{name: 'DELIVERY_TIME'		, text:'<t:message code="system.label.sales.deliverytime" default="납기시간"/>'					, type: 'uniTime'},
			{name: 'DISCOUNT_RATE'		, text:'<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'				, type: 'uniER', defaultValue:0},
			{name: 'LOT_NO'				, text:'<t:message code="system.label.sales.lotno" default="LOT번호"/>'						, type: 'string', allowBlank: gsLotNoEssential},
			{name: 'PRICE_YN'			, text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'					, type: 'string', comboType: 'AU', comboCode: 'S003', defaultValue:'2', allowBlank:false},
			{name: 'SALE_CUSTOM_CODE'	, text:'<t:message code="system.label.sales.salesplace" default="매출처"/>'					, type: 'string', allowBlank:false},
			{name: 'SALE_CUSTOM_NAME'	, text:'<t:message code="system.label.sales.salesplace" default="매출처"/>'					, type: 'string', allowBlank:false},
			{name: 'ACCOUNT_YNC'		, text:'<t:message code="system.label.sales.salessubject" default="매출대상"/>'				, type: 'string', comboType: 'AU', comboCode: 'S014', allowBlank:false},
			{name: 'DVRY_CUST_CD'		, text:'<t:message code="system.label.sales.deliveryplace" default="배송처"/>'				, type: 'string'},
			{name: 'DVRY_CUST_NAME'		, text:'<t:message code="system.label.sales.deliveryplace" default="배송처"/>'				, type: 'string'},
			{name: 'PROJECT_NO'			, text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'PO_NUM'				, text:'<t:message code="system.label.sales.pono2" default="P/O 번호"/>'						, type: 'string'},
			{name: 'PO_SEQ'				, text:'<t:message code="system.label.sales.poseq2" default="P/O 순번"/>'						, type: 'int'},
			{name: 'ORDER_NUM'			, text:'<t:message code="system.label.sales.sono" default="수주번호"/>'						, type: 'string', editable: false},
			{name: 'SER_NO'				, text:'<t:message code="system.label.sales.soseq" default="수주순번"/>'						, type: 'int'},
			{name: 'DEPT_CODE'			, text:'<t:message code="system.label.sales.shipmentorderdepartment" default="출하지시부서"/>'	, type: 'string', defaltValue:'*'},
			{name: 'TREE_NAME'			, text:'<t:message code="system.label.sales.departmentname" default="부서명"/>'				, type: 'string', defaultValue:'N'},
			{name: 'MONEY_UNIT'			, text:'<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'				, type: 'string'},
			{name: 'EXCHANGE_RATE'		, text:'<t:message code="system.label.sales.exchangerate" default="환율"/>'					, type: 'uniER', defaultValue:1},
			{name: 'ISSUE_QTY'			, text:'<t:message code="system.label.sales.issueqty" default="출고량"/>'						, type: 'uniQty', defaultValue:0},
			{name: 'RETURN_Q'			, text:'<t:message code="system.label.sales.returnqty" default="반품량"/>'					, type: 'uniQty'},
			{name: 'ORDER_Q'			, text:'<t:message code="system.label.sales.soqty" default="수주량"/>'						, type: 'uniQty'},
			{name: 'ISSUE_REQ_Q'		, text:'<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'			, type: 'uniQty'},
			{name: 'DVRY_DATE'			, text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'					, type: 'uniDate'},
			{name: 'DVRY_TIME'			, text:'<t:message code="system.label.sales.deliverytime" default="납기시간"/>'				, type: 'uniTime'},
			{name: 'TAX_INOUT'			, text:'<t:message code="system.label.sales.taxtype" default="세구분"/>'						, type: 'string'},
			{name: 'STOCK_UNIT'			, text:'<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'				, type: 'string'},
			{name: 'PRE_ACCNT_YN'		, text:'<t:message code="system.label.sales.salessubject" default="매출대상"/>'				, type: 'string', defaultValue:'Y'},
			{name: 'REF_FLAG'			, text:'REF_FLAG'			, type: 'string', defaultValue:'F'},
			{name: 'SALE_P'				, text:'SALE_P'				, type: 'uniUnitPrice'},
			{name: 'AMEND_YN'			, text:'AMEND_YN'			, type: 'string', defaultValue:'N'},
			{name: 'OUTSTOCK_Q'			, text:'OUTSTOCK_Q'			, type: 'string'},
			{name: 'ORDER_CUST_NM'		, text:'ORDER_CUST_NM'		, type: 'string'},
			{name: 'STOCK_CARE_YN'		, text:'STOCK_CARE_YN'		, type: 'string'},
			{name: 'NOTOUT_Q'			, text:'NOTOUT_Q'			, type: 'string'},
			{name: 'SORT_KEY'			, text:'SORT_KEY'			, type: 'string'},
			{name: 'REF_AGENT_TYPE'		, text:'REF_AGENT_TYPE'		, type: 'string', defaultValue:CustomCodeInfo.gsAgentType},
			{name: 'REF_WON_CALC_TYPE'	, text:'REF_WON_CALC_TYPE'	, type: 'string', defaultValue:CustomCodeInfo.gsUnderCalBase},
			{name: 'REF_CODE2'			, text:'REF_CODE2'			, type: 'string'},
			{name: 'COMP_CODE'			, text:'COMP_CODE'			, type: 'string', defaultValue:UserInfo.compCode},
			{name: 'SCM_FLAG_YN'		, text:'SCM_FLAG_YN'		, type: 'string'},
			{name: 'REF_LOC'			, text:'REF_LOC'			, type: 'string', defaultValue:'1'},
			{name: 'PAY_METHODE1'		, text:'<t:message code="system.label.sales.amountpaymethod" default="대금결제방법"/>'			, type: 'string', comboType: 'AU', comboCode: 'T016'},
			{name: 'LC_SER_NO'			, text:'<t:message code="system.label.sales.lcno" default="L/C번호"/>'						, type: 'string'},
			{name: 'GUBUN'				, text:'<t:message code="system.label.sales.classfication" default="구분"/>'					, type: 'string'},
			{name: 'REMARK'				, text:'<t:message code="system.label.sales.remarks" default="비고"/>'						, type: 'string'},
			{name: 'REMARK_INTER'		, text:'<t:message code="system.label.sales.remarkinter" default="내부기록사항"/>'				, type: 'string'},
			{name: 'SELECTED_YN'		, text:'SELECTED_YN'		, type: 'string'}
		]
	});

	//스토어 정의
	var detailStore = Unilite.createStore('s_srq100ukrv_mitDetailStore', {
		model	: 's_srq100ukrv_mitDetailModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();
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
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);
			var isErr		= false;
			var count		= 0;

			//미등록 탭은 모두 신규
			Ext.each(toCreate, function(record, index) {
				if(record.get('SELECTED_YN') == 'Y') {
					count = count + 1;
					record.set('ISSUE_REQ_SEQ', index + 1);
					if(record.get('ISSUE_REQ_METH') == '1' ) {
						if( record.get('DVRY_DATE') >= record.get('ISSUE_REQ_DATE')) {
							if( record.get('DVRY_DATE') < record.get('ISSUE_DATE')) {
								if(!confirm('<t:message code="system.message.sales.message006" default="출고예정일은 납기일보다 이전이어야 합니다."/>' + '\n'
									+ '<t:message code="system.label.sales.seq" default="순번"/>'+':'+record.get('ISSUE_REQ_SEQ') + '\n'
									+ '<t:message code="system.label.sales.issueresevationdate" default="출고예정일"/>:'+record.get('ISSUE_DATE') + '\n'
									+ '<t:message code="system.label.sales.deliverydate" default="납기일"/>'+':'+record.get('DVRY_DATE') + '\n'
									+ /* Msg.sMS419  +*/ '\n'
									+ '<t:message code="system.message.sales.confirm003" default="진행하시겠습니까?"/>')
								) {
									isErr = true;
									return false;
								}
							}
						} else {
							if(!confirm('<t:message code="system.message.sales.message045" default="출하지시일은 납기일보다 이전이어야 합니다."/>' + '\n'
								+ '<t:message code="system.label.sales.seq" default="순번"/>'+':'+record.get('ISSUE_REQ_SEQ') + '\n'
								+ '<t:message code="system.label.sales.issueresevationdate" default="출고예정일"/>:' + record.get('ISSUE_REQ_DATE') + ',' + '<t:message code="system.label.sales.deliverydate" default="납기일"/>' +':' +record.get('DVRY_DATE')
								+ /* Msg.sMS419  +*/ '\n'
								+ '<t:message code="system.message.sales.confirm003" default="진행하시겠습니까?"/>')
							) {
								isErr = true;
								return false;
							}
						}
					}
				}
			})
//			if(count == 0) {
//				Unilite.messageBox('저장할 데이터를 체크박스에서 선택하신 후, 저장하시기 바랍니다.');
//				return false;
//			}
			if(isErr) return false;

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정

			//20200327 변경
			if(inValidRecs.length == 0) {
				//20200402 수정: 체크로직 위치 수정
				if(count == 0) {
					Unilite.messageBox('저장할 데이터를 체크박스에서 선택하신 후, 저장하시기 바랍니다.');
					return false;
				}

//			if(inValidRecs.filter(function(item){return item.get('SELECTED_YN') == 'Y'}).length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();

						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						if(detailStore.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						} else {
							UniAppManager.app.onQueryButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_srq100ukrv_mitGrid');
				//20200327 변경
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
//				grid.uniSelectInvalidColumnAndAlert(inValidRecs.filter(function(item){return item.get('SELECTED_YN') == 'Y'}));
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				/*//20200327 너무 오래 걸려서 주석
				if (records.length > 0){
					Ext.each(records,  function(record, index, recs){
						record.phantom = true;
						//20200325 주석: 쿼리에서 수행
//						var orderQ = record.get('ORDER_Q');
//						if(orderQ != record.get('NOTOUT_Q')) {
//							UniAppManager.app.fnOrderAmtCal(record, "Q");
//						}
						//20200316 주석
//						UniSales.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('OUT_DIV_CODE'), null, record.get('ITEM_CODE'), record.get('WH_CODE'));
					});
				}*/
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	var detailStore2 = Unilite.createStore('s_srq100ukrv_mitDetailStore2', {
		model	: 's_srq100ukrv_mitDetailModel',
		proxy	: directProxy2,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param = Ext.merge(masterForm.getValues(), tab2Form.getValues());
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
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);

			var isErr	= false;
			Ext.each(list, function(record, index) {
				if(record.get('ISSUE_REQ_METH') == '1' ) {
					if( record.get('DVRY_DATE') >= record.get('ISSUE_REQ_DATE') ) {
						if( record.get('DVRY_DATE') < record.get('ISSUE_DATE')) {
							if(!confirm('<t:message code="system.message.sales.message006" default="출고예정일은 납기일보다 이전이어야 합니다."/>' + '\n'
								+ '<t:message code="system.label.sales.seq" default="순번"/>'+':'+record.get('ISSUE_REQ_SEQ') + '\n'
								+ '<t:message code="system.label.sales.issueresevationdate" default="출고예정일"/>:'+record.get('ISSUE_DATE') + '\n'
								+ '<t:message code="system.label.sales.deliverydate" default="납기일"/>'+':'+record.get('DVRY_DATE') + '\n'
								+ /* Msg.sMS419  +*/ '\n'
								+ '<t:message code="system.message.sales.confirm003" default="진행하시겠습니까?"/>')
							) {
								isErr = true;
								return false;
							}
						}
					} else {
						if(!confirm('<t:message code="system.message.sales.message045" default="출하지시일은 납기일보다 이전이어야 합니다."/>' + '\n'
							+ '<t:message code="system.label.sales.seq" default="순번"/>'+':'+record.get('ISSUE_REQ_SEQ') + '\n'
							+ '<t:message code="system.label.sales.issueresevationdate" default="출고예정일"/>:' + record.get('ISSUE_REQ_DATE') + ',' + '<t:message code="system.label.sales.deliverydate" default="납기일"/>' +':' +record.get('DVRY_DATE')
							+ /* Msg.sMS419  +*/ '\n'
							+ '<t:message code="system.message.sales.confirm003" default="진행하시겠습니까?"/>')
						) {
							isErr = true;
							return false;
						}
					}
				}
			})
			if(isErr) return false;

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();

						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						if(detailStore2.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						} else {
							UniAppManager.app.onQueryButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_srq100ukrv_mitGrid2');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if (records.length>0){
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	//그리드 정의
	var detailGrid = Unilite.createGrid('s_srq100ukrv_mitGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
			onLoadSelectFirst	: false,
			useRowNumberer		: false
		},
		//20200327: 추가: 출고요청일 일괄변경 기능 추가
		tbar	: [{
			fieldLabel	: '<t:message code="system.label.sales.issuerequestdate" default="출고요청일"/>',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			margin		: '0 5 0 0',
			id			: 'upD',
			labelAlign	: 'right',
			allowBlank	: false
		},{
			xtype		:'button',
			margin		: '0 50 0 0',
			text		: "<div style='color: blue'>일괄변경</div>",
			handler		: function(){
				var masterGridRecord = detailGrid.getSelectedRecords();
				if(!Ext.isEmpty(masterGridRecord)){
					Ext.each(masterGridRecord, function(masterGridRecord, index) {
						 masterGridRecord.set('ISSUE_DATE', Ext.getCmp('upD').getValue());
					});
				}
			}
		}],
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		selModel	:	Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if (this.selected.getCount()) {
						//20200327 추가: 저장 속도 문제로 여기서 처리
						selectRecord.phantom = true;
						selectRecord.set('SELECTED_YN' , 'Y');
					}
					//20200302 추가: 합계로직 추가
					var results = detailGrid.getStore().sumBy(function(record, id){
						return detailGrid.getSelectionModel().isSelected(record)
					}, ['ISSUE_REQ_QTY', 'ISSUE_REQ_AMT']);
					masterForm.setValue('SUM_ISSUE_REQ_QTY', results.ISSUE_REQ_QTY);
					masterForm.setValue('SUM_ISSUE_REQ_AMT', results.ISSUE_REQ_AMT);
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					selectRecord.set('SELECTED_YN' , '');
					//20200327 추가: 저장 속도 문제로 여기서 처리
					selectRecord.phantom = false;
					//20200302 추가: 합계로직 추가
					var results = detailGrid.getStore().sumBy(function(record, id){
						return detailGrid.getSelectionModel().isSelected(record)
					}, ['ISSUE_REQ_QTY', 'ISSUE_REQ_AMT']);
					masterForm.setValue('SUM_ISSUE_REQ_QTY', results.ISSUE_REQ_QTY);
					masterForm.setValue('SUM_ISSUE_REQ_AMT', results.ISSUE_REQ_AMT);

					if (this.selected.getCount() == 0) {
						UniAppManager.setToolbarButtons('save', false);
					}
				}
			}
		}),
		columns: [
			{dataIndex: 'SELECTED_YN'					, width: 66, hidden: true },
			{dataIndex: 'DIV_CODE'						, width: 66, hidden: true },
			{dataIndex: 'ISSUE_REQ_METH'				, width: 66, hidden: true },
			{dataIndex: 'ISSUE_REQ_PRSN'				, width: 66, hidden: true },
			{dataIndex: 'ISSUE_REQ_DATE'				, width: 66, hidden: true },
			{dataIndex: 'ISSUE_REQ_NUM'					, width: 66, hidden: true },
			{dataIndex: 'ISSUE_REQ_SEQ'					, width: 40, hidden: true },
			{dataIndex: 'CUSTOM_CODE'					, width: 80, hidden: true },
			{dataIndex: 'CUSTOM_NAME'					, width: 133 ,
				editor: Unilite.popup('CUST_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = Ext.getCmp('s_srq100ukrv_mitGrid').uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('SALE_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('SALE_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								UniSales.fnGetPriceInfo2(
									grdRecord
									,UniAppManager.app.cbGetPriceInfo
									,'I'
									,UserInfo.compCode
									,records[0]['CUSTOM_CODE']
									,grdRecord.get('REF_AGENT_TYPE')
									,grdRecord.get('ITEM_CODE')
									,grdRecord.get('MONEY_UNIT')
									,grdRecord.get('ORDER_UNIT')
									,grdRecord.get('STOCK_UNIT')
									,grdRecord.get('TRANS_RATE')
									,UniDate.getDbDateStr(grdRecord.get('ISSUE_REQ_DATE'))
									,grdRecord.get('ISSUE_REQ_QTY')
									,grdRecord['WGT_UNIT']
									,grdRecord['VOL_UNIT']
								)
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = Ext.getCmp('s_srq100ukrv_mitGrid').uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							grdRecord.set('SALE_CUSTOM_CODE','');
							grdRecord.set('SALE_CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'ITEM_CODE'						, width: 120},
			{dataIndex: 'ITEM_NAME'						, width: 133},
			{dataIndex: 'SPEC'							, width: 133 },
			{dataIndex: 'ORDER_UNIT'					, width: 66, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'PRICE_TYPE'					, width: 66, hidden: true },
			{dataIndex: 'TRANS_RATE'					, width: 53 },
			{dataIndex: 'STOCK_Q'						, width: 120, summaryType: 'sum' },
			{dataIndex: 'ISSUE_REQ_QTY'					, width: 106, summaryType: 'sum' },
			{dataIndex: 'ISSUE_FOR_PRICE'				, width: 106, hidden: true },
			{dataIndex: 'ISSUE_WGT_Q'					, width: 120, hidden: true },
			{dataIndex: 'ISSUE_FOR_WGT_P'				, width: 106, hidden: true },
			{dataIndex: 'ISSUE_VOL_Q'					, width: 120, hidden: true },
			{dataIndex: 'ISSUE_FOR_VOL_P'				, width: 106, hidden: true },
			{dataIndex: 'ISSUE_FOR_AMT'					, width: 106, hidden: true },
			{dataIndex: 'ISSUE_REQ_PRICE'				, width: 106, hidden: true},
			{dataIndex: 'ISSUE_WGT_P'					, width: 106, hidden: true },
			{dataIndex: 'ISSUE_VOL_P'					, width: 106, hidden: true },
			{dataIndex: 'ISSUE_REQ_AMT'					, width: 106, hidden: true, summaryType: 'sum'	},
			{dataIndex: 'TAX_TYPE'						, width: 80, align: 'center' },
			{dataIndex: 'ISSUE_REQ_TAX_AMT'				, width: 106, hidden: true, summaryType: 'sum' },
			{dataIndex: 'WGT_UNIT'						, width: 66, hidden: true },
			{dataIndex: 'UNIT_WGT'						, width: 66, hidden: true },
			{dataIndex: 'VOL_UNIT'						, width: 66, hidden: true },
			{dataIndex: 'UNIT_VOL'						, width: 66, hidden: true },
			{dataIndex: 'ISSUE_DATE'					, width: 80 },
			{dataIndex: 'DELIVERY_TIME'					, width: 80, hidden: true },
			{dataIndex: 'BILL_TYPE'						, width: 80,align: 'center' },
			{dataIndex: 'ORDER_TYPE'					, width: 90,align: 'center' },
			{dataIndex: 'INOUT_TYPE_DETAIL'				, width: 80,align: 'center' },
			{dataIndex: 'ISSUE_DIV_CODE'				, width: 90,align: 'center' },
			{dataIndex: 'WH_CODE'						, width: 150,
				listeners:{
					render:function(elm) {
						elm.editor.on('beforequery',function(queryPlan, eOpts) {
							var store = queryPlan.combo.store;
							var record = detailGrid.uniOpt.currentRecord;
							store.clearFilter();
							store.filterBy(function(item){
								return item.get('option') == (Ext.isEmpty(record.get('ISSUE_DIV_CODE')) ? record.get('DIV_CODE') : record.get('ISSUE_DIV_CODE'));
							})
						})
					}
				}
			},
			{dataIndex: 'WH_CELL_CODE'					, width: 90, hidden:true },
			{dataIndex: 'DISCOUNT_RATE'					, width: 80 },
			{dataIndex: 'LOT_NO'						, width: 100,
				editor: Unilite.popup('LOT_MULTI_G', {
					autoPopup		: true,
					validateBlank	: false,
					textFieldName	: 'LOTNO_CODE',
					DBtextFieldName	: 'LOTNO_CODE',
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord	= detailGrid.uniOpt.currentRecord;
								var issueReqQty	= grdRecord.get('ISSUE_REQ_QTY');
								var grdIdx		= detailGrid.getStore().findBy(function(record, id) {
													if(grdRecord.id	== id) return true
												});
								var rtnRecord;
								Ext.each(records, function(record,i) {
									if(i==0){
										rtnRecord		= grdRecord;
										var lotStockQ	= record['GOOD_STOCK_Q'];
										if (lotStockQ < issueReqQty || issueReqQty == 0) {
											rtnRecord.set('ISSUE_REQ_QTY', lotStockQ);
											issueReqQty = lotStockQ - lotStockQ;
										} else {
											rtnRecord.set('ISSUE_REQ_QTY', issueReqQty);
											issueReqQty = 0;
										}
										rtnRecord.set('LOT_NO', record['LOT_NO']);
										var ouComboStore = 	Ext.data.StoreManager.lookup('ouChkCombo');	//사용중인 창고 정보 스토어
										Ext.each(ouComboStore.data.items, function(comboData, idx) {	//lotno팝업에서 선택한 창고가 사용중인 창고이면 선택한 창고로 세팅
											if(comboData.get('value') == record['WH_CODE']){
												rtnRecord.set('WH_CODE', record['WH_CODE']);
											}
										});
									} else {
										var lotStockQ	= record['GOOD_STOCK_Q'];
										var whCode		= ''
										if (lotStockQ < issueReqQty || issueReqQty == 0) {
											issueReqQty = lotStockQ - lotStockQ;
										} else {
											lotStockQ	= issueReqQty;
											issueReqQty	= 0;
										}
										var ouComboStore = 	Ext.data.StoreManager.lookup('ouChkCombo');	//사용중인 창고 정보 스토어
										Ext.each(ouComboStore.data.items, function(comboData, idx) {	//lotno팝업에서 선택한 창고가 사용중인 창고이면 선택한 창고로 세팅
											if(comboData.get('value') == record['WH_CODE']){
												whCode = record['WH_CODE'];
											}
										});
										var r = {
											'DIV_CODE'			: grdRecord.get('DIV_CODE'			),
											'ISSUE_REQ_METH'	: grdRecord.get('ISSUE_REQ_METH'	),
											'ISSUE_REQ_PRSN'	: grdRecord.get('ISSUE_REQ_PRSN'	),
											'ISSUE_REQ_DATE'	: grdRecord.get('ISSUE_REQ_DATE'	),
											'ISSUE_REQ_NUM'		: grdRecord.get('ISSUE_REQ_NUM'		),
											'ISSUE_REQ_SEQ'		: grdRecord.get('ISSUE_REQ_SEQ'		),
											'CUSTOM_CODE'		: grdRecord.get('CUSTOM_CODE'		),
											'CUSTOM_NAME'		: grdRecord.get('CUSTOM_NAME'		),
											'BILL_TYPE'			: grdRecord.get('BILL_TYPE'			),
											'ORDER_TYPE'		: grdRecord.get('ORDER_TYPE'		),
											'INOUT_TYPE_DETAIL'	: grdRecord.get('INOUT_TYPE_DETAIL'	),
											'ISSUE_DIV_CODE'	: grdRecord.get('ISSUE_DIV_CODE'	),
											'ITEM_CODE'			: grdRecord.get('ITEM_CODE'			),
											'ITEM_NAME'			: grdRecord.get('ITEM_NAME'			),
											'SPEC'				: grdRecord.get('SPEC'				),
											'ORDER_UNIT'		: grdRecord.get('ORDER_UNIT'		),
											'PRICE_TYPE'		: grdRecord.get('PRICE_TYPE'		),
											'TRANS_RATE'		: grdRecord.get('TRANS_RATE'		),
											'STOCK_Q'			: grdRecord.get('STOCK_Q'			),
											'ISSUE_FOR_PRICE'	: grdRecord.get('ISSUE_FOR_PRICE'	),
											'ISSUE_WGT_Q'		: grdRecord.get('ISSUE_WGT_Q'		),
											'ISSUE_FOR_WGT_P'	: grdRecord.get('ISSUE_FOR_WGT_P'	),
											'ISSUE_VOL_Q'		: grdRecord.get('ISSUE_VOL_Q'		),
											'ISSUE_FOR_VOL_P'	: grdRecord.get('ISSUE_FOR_VOL_P'	),
											'ISSUE_FOR_AMT'		: grdRecord.get('ISSUE_FOR_AMT'		),
											'ISSUE_REQ_PRICE'	: grdRecord.get('ISSUE_REQ_PRICE'	),
											'ISSUE_WGT_P'		: grdRecord.get('ISSUE_WGT_P'		),
											'ISSUE_VOL_P'		: grdRecord.get('ISSUE_VOL_P'		),
											'ISSUE_REQ_AMT'		: grdRecord.get('ISSUE_REQ_AMT'		),
											'TAX_TYPE'			: grdRecord.get('TAX_TYPE'			),
											'ISSUE_REQ_TAX_AMT'	: grdRecord.get('ISSUE_REQ_TAX_AMT'	),
											'WGT_UNIT'			: grdRecord.get('WGT_UNIT'			),
											'UNIT_WGT'			: grdRecord.get('UNIT_WGT'			),
											'VOL_UNIT'			: grdRecord.get('VOL_UNIT'			),
											'UNIT_VOL'			: grdRecord.get('UNIT_VOL'			),
											'ISSUE_DATE'		: grdRecord.get('ISSUE_DATE'		),
											'DELIVERY_TIME'		: grdRecord.get('DELIVERY_TIME'		),
											'DISCOUNT_RATE'		: grdRecord.get('DISCOUNT_RATE'		),
											'PRICE_YN'			: grdRecord.get('PRICE_YN'			),
											'SALE_CUSTOM_CODE'	: grdRecord.get('SALE_CUSTOM_CODE'	),
											'SALE_CUSTOM_NAME'	: grdRecord.get('SALE_CUSTOM_NAME'	),
											'ACCOUNT_YNC'		: grdRecord.get('ACCOUNT_YNC'		),
											'DVRY_CUST_CD'		: grdRecord.get('DVRY_CUST_CD'		),
											'DVRY_CUST_NAME'	: grdRecord.get('DVRY_CUST_NAME'	),
											'PROJECT_NO'		: grdRecord.get('PROJECT_NO'		),
											'PO_NUM'			: grdRecord.get('PO_NUM'			),
											'PO_SEQ'			: grdRecord.get('PO_SEQ'			),
											'ORDER_NUM'			: grdRecord.get('ORDER_NUM'			),
											'SER_NO'			: grdRecord.get('SER_NO'			),
											'DEPT_CODE'			: grdRecord.get('DEPT_CODE'			),
											'TREE_NAME'			: grdRecord.get('TREE_NAME'			),
											'MONEY_UNIT'		: grdRecord.get('MONEY_UNIT'		),
											'EXCHANGE_RATE'		: grdRecord.get('EXCHANGE_RATE'		),
											'ISSUE_QTY'			: grdRecord.get('ISSUE_QTY'			),
											'RETURN_Q'			: grdRecord.get('RETURN_Q'			),
											'ORDER_Q'			: grdRecord.get('ORDER_Q'			),
											'ISSUE_REQ_Q'		: grdRecord.get('ISSUE_REQ_Q'		),
											'DVRY_DATE'			: grdRecord.get('DVRY_DATE'			),
											'DVRY_TIME'			: grdRecord.get('DVRY_TIME'			),
											'TAX_INOUT'			: grdRecord.get('TAX_INOUT'			),
											'STOCK_UNIT'		: grdRecord.get('STOCK_UNIT'		),
											'PRE_ACCNT_YN'		: grdRecord.get('PRE_ACCNT_YN'		),
											'REF_FLAG'			: grdRecord.get('REF_FLAG'			),
											'SALE_P'			: grdRecord.get('SALE_P'			),
											'AMEND_YN'			: grdRecord.get('AMEND_YN'			),
											'OUTSTOCK_Q'		: grdRecord.get('OUTSTOCK_Q'		),
											'ORDER_CUST_NM'		: grdRecord.get('ORDER_CUST_NM'		),
											'STOCK_CARE_YN'		: grdRecord.get('STOCK_CARE_YN'		),
											'NOTOUT_Q'			: grdRecord.get('NOTOUT_Q'			),
											'SORT_KEY'			: grdRecord.get('SORT_KEY'			),
											'REF_AGENT_TYPE'	: grdRecord.get('REF_AGENT_TYPE'	),
											'REF_WON_CALC_TYPE'	: grdRecord.get('REF_WON_CALC_TYPE'	),
											'REF_CODE2'			: grdRecord.get('REF_CODE2'			),
											'COMP_CODE'			: grdRecord.get('COMP_CODE'			),
											'SCM_FLAG_YN'		: grdRecord.get('SCM_FLAG_YN'		),
											'REF_LOC'			: grdRecord.get('REF_LOC'			),
											'PAY_METHODE1'		: grdRecord.get('PAY_METHODE1'		),
											'LC_SER_NO'			: grdRecord.get('LC_SER_NO'			),
											'GUBUN'				: grdRecord.get('GUBUN'				),
											'REMARK'			: grdRecord.get('REMARK'			),
											'REMARK_INTER'		: grdRecord.get('REMARK_INTER'		),
											'ISSUE_REQ_QTY'		: lotStockQ,
											'WH_CODE'			: Ext.isEmpty(whCode) ? grdRecord.get('WH_CODE') : whCode,
											'LOT_NO'			: record['LOT_NO']
										}
										detailGrid.createRow(r, null, grdIdx + i - 1);
//										UniAppManager.app.fnOrderAmtCal(record, "Q");
									}
									if(issueReqQty == 0) {
										return false;
									}
								});
								detailGrid.getNavigationModel().setPosition(5, detailStore.getCount()-1);//lotno 컬럼이 뒤쪽에 있어 lotno입력 후 수량 입력 편하게 스크롤바 이동
							},
							scope: this
						},
						'onClear': function(type) {
							var record1 = detailGrid.getSelectedRecord();
							record1.set('LOT_NO', '');
						},
						applyextparam: function(popup){
							var record		= detailGrid.uniOpt.currentRecord;
							var divCode		= record.get('ISSUE_DIV_CODE');
							var itemCode	= record.get('ITEM_CODE');
							var itemName	= record.get('ITEM_NAME');
							var whCode		= record.get('WH_CODE');
							popup.setExtParam({SELMODEL: 'MULTI', 'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode});
						}
					}
				})
			},
			{dataIndex: 'PRICE_YN'						, width: 80,align: 'center' },
			{dataIndex: 'SALE_CUSTOM_CODE'				, width: 80, hidden: true },
			{dataIndex: 'SALE_CUSTOM_NAME'				, width: 80 ,
				editor: Unilite.popup('AGENT_CUST_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = Ext.getCmp('s_srq100ukrv_mitGrid').uniOpt.currentRecord;
								grdRecord.set('SALE_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = Ext.getCmp('s_srq100ukrv_mitGrid').uniOpt.currentRecord;
							grdRecord.set('SALE_CUSTOM_CODE', '');
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'ACCOUNT_YNC'					, width: 80,align: 'center' },
			{dataIndex: 'DVRY_CUST_CD'					, width: 80, hidden: true },
			{dataIndex: 'DVRY_CUST_NAME'				, width: 120,
				editor: Unilite.popup('DELIVERY_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
								//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('DVRY_CUST_CD'	, records[0]['DELIVERY_CODE']);
								grdRecord.set('DVRY_CUST_NAME'	, records[0]['DELIVERY_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DVRY_CUST_CD'	, '');
							grdRecord.set('DVRY_CUST_NAME'	, '');
						},
						applyextparam: function(popup){
							var grdRecord = detailGrid.uniOpt.currentRecord;
							popup.setExtParam({'CUSTOM_CODE': grdRecord.get('CUSTOM_CODE')});
						}
					}
				})
			},
			{dataIndex: 'PROJECT_NO'					, width: 93 },
			{dataIndex: 'PO_NUM'						, width: 100 },
			{dataIndex: 'PO_SEQ'						, width: 80, hidden: true },
			{dataIndex: 'ORDER_NUM'						, width: 120 },
			{dataIndex: 'SER_NO'						, width: 66,align: 'center' },
			{dataIndex: 'UPDATE_DB_USER'				, width: 66, hidden: true },
			{dataIndex: 'UPDATE_DB_TIME'				, width: 66, hidden: true },
			{dataIndex: 'DEPT_CODE'						, width: 66, hidden: true },
			{dataIndex: 'TREE_NAME'						, width: 66, hidden: true},
			{dataIndex: 'MONEY_UNIT'					, width: 66, hidden: true },
			{dataIndex: 'EXCHANGE_RATE'					, width: 66, hidden: true },
			{dataIndex: 'ORDER_Q'						, width: 66, summaryType: 'sum' },
			{dataIndex: 'ISSUE_QTY'						, width: 66, summaryType: 'sum' },
			{dataIndex: 'RETURN_Q'						, width: 66, summaryType: 'sum' },
			{dataIndex: 'ISSUE_REQ_Q'					, width: 66, hidden: true },
			{dataIndex: 'DVRY_DATE'						, width: 80 },
			{dataIndex: 'DVRY_TIME'						, width: 80 },
			{dataIndex: 'TAX_INOUT'						, width: 66, hidden: true },
			{dataIndex: 'STOCK_UNIT'					, width: 66, hidden: true },
			{dataIndex: 'PRE_ACCNT_YN'					, width: 66, hidden: true },
			{dataIndex: 'REF_FLAG'						, width: 66, hidden: true },
			{dataIndex: 'SALE_P'						, width: 66, hidden: true },
			{dataIndex: 'AMEND_YN'						, width: 66, hidden: true },
			{dataIndex: 'OUTSTOCK_Q'					, width: 66, hidden: true },
			{dataIndex: 'ORDER_CUST_NM'					, width: 66, hidden: true },
			{dataIndex: 'STOCK_CARE_YN'					, width: 66, hidden: true },
			{dataIndex: 'NOTOUT_Q'						, width: 66, hidden: true},
			{dataIndex: 'SORT_KEY'						, width: 66, hidden: true },
			{dataIndex: 'REF_AGENT_TYPE'				, width: 66, hidden: true },
			{dataIndex: 'REF_WON_CALC_TYPE'				, width: 66, hidden: true },
			{dataIndex: 'REF_CODE2'						, width: 66, hidden: true },
			{dataIndex: 'COMP_CODE'						, width: 66, hidden: true },
			{dataIndex: 'SCM_FLAG_YN'					, width: 66, hidden: true },
			{dataIndex: 'REF_LOC'						, width: 66, hidden: true },
			{dataIndex: 'PAY_METHODE1'					, width: 100 },
			{dataIndex: 'LC_SER_NO'						, width: 100 },
			{dataIndex: 'GUBUN'							, width: 100, hidden: true },
			{dataIndex: 'REMARK'						, width: 106 },
			{dataIndex: 'REMARK_INTER'					, width: 106 }
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom ) {
					if(e.field=='LOT_NO') {
						if(Ext.isEmpty(e.record.data.WH_CODE)){
							Unilite.messageBox('<t:message code="system.message.sales.message057" default="출고창고를 입력하십시오."/>');
							return false;
						}
						if(Ext.isEmpty(e.record.data.ITEM_CODE)){
							Unilite.messageBox('<t:message code="system.message.sales.message024" default="품목코드를 입력 하십시오."/>');
							return false;
						}
					}
					//20191111 수주참조된 데이터는 출고사업장 등 아래 내용 수정할 수 없도록 변경 - uniLITE 소스와 동일하게 설정: 기존 생성 시 잘못 만든 내용 수정한 것임
//					if(!Ext.isEmpty(e.record.data.ISSUE_REQ_NUM)) {
					if(!Ext.isEmpty(e.record.data.ORDER_NUM)) {
						if(e.field=='CUSTOM_CODE')		return false;
						if(e.field=='CUSTOM_NAME')		return false;
						if(e.field=='ORDER_TYPE')		return false;
						if(e.field=='ITEM_CODE')		return false;
						if(e.field=='ITEM_NAME')		return false;
						if(e.field=='SPEC')				return false;
						if(e.field=='ORDER_UNIT')		return false;
						if(e.field=='TRANS_RATE')		return false;
						if(e.field=='STOCK_Q')			return false;
						if(e.field=='SALE_CUSTOM_CODE')	return false;
						if(e.field=='SALE_CUSTOM_NAME')	return false;
						if(e.field=='PRICE_YN')			return false;
						if(e.field=='ISSUE_DIV_CODE')	return false;
						if(e.field=='PO_NUM')			return false;
						if(e.field=='PO_SEQ')			return false;
						if(e.field=='SER_NO')			return false;
						if(e.field=='DISCOUNT_RATE')	return false;
						if(e.field=='BILL_TYPE')		return false;
						if(e.field=='TAX_TYPE')			return false;
						if(e.field=='ACCOUNT_YNC')		return false;
						if(e.field=='DVRY_CUST_NAME')	return false;
						if(e.field=='DVRY_DATE')		return false;
						if(e.field=='DVRY_TIME')		return false;
						if(e.field=='ISSUE_QTY')		return false;
						if(e.field=='RETURN_Q')			return false;
						if(e.field=='ORDER_Q')			return false;
						if( e.record.data.TAX_TYPE!= '1') {
							if(e.field=='ISSUE_REQ_TAX_AMT') return false;
						}
//						if(e.field=='ISSUE_REQ_PRICE')	return false;
//						if(e.field=='ISSUE_REQ_AMT')	return false;
//						if(e.field=='UNIT_WGT')			return false;
//						if(e.field=='UNIT_VOL')			return false;
//						if(!Ext.isEmpty(e.record.data.GUBUN)) {
//							if(e.field=='PRICE_TYPE')	return false;
//							if(e.field=='WGT_UNIT')		return false;
//							if(e.field=='VOL_UNIT')		return false;
//						}
					} else {
						if( e.record.data.BILL_TYPE == '50') {
							if(e.field=='TAX_TYPE')	return false;
						}
						if(e.field=='SPEC')			return false;
						if(e.field=='STOCK_Q')		return false;
						if(e.field=='PO_NUM')		return false;
						if(e.field=='PO_SEQ')		return false;
						if(e.field=='ORDER_NUM')	return false;
						if(e.field=='SER_NO')		return false;
						if(e.field=='DVRY_DATE')	return false;
						if(e.field=='DVRY_TIME')	return false;
						if(e.field=='PRICE_YN')		return false;
						if(e.field=='ISSUE_QTY')	return false;
						if(e.field=='RETURN_Q')		return false;
						if(e.field=='ORDER_Q')		return false;
						if( e.record.data.TAX_TYPE!= '1') {
							if(e.field=='ISSUE_REQ_TAX_AMT') return false;
						}
						if(e.field=='DISCOUNT_RATE') {
							if( !(e.record.data.AMEND_YN == 'Y' || ( e.record.data.AMEND_YN == 'N' && Unilite.nvl(e.record.data.DISCOUNT_RATE,0) == 0))) {
								return false;
							}
						}
					}
				} /*else {
					//출고된 적 없음 & 출하된적 있음.
					if(Unilite.nvl(e.record.data.ISSUE_QTY,0) == 0) {
						if(e.field=='ISSUE_REQ_SEQ')		return false;
						if(e.field=='SPEC')					return false;
						if(e.field=='PO_NUM')				return false;
						if(e.field=='PO_SEQ')				return false;
						if(e.field=='ORDER_NUM')			return false;
						if(e.field=='SER_NO')				return false;
						if(e.field=='PRICE_YN')				return false;
						if(e.field=='CUSTOM_CODE')			return false;
						if(e.field=='CUSTOM_NAME')			return false;
						if(e.field=='ITEM_CODE')			return false;
						if(e.field=='ITEM_NAME')			return false;
						if(e.field=='STOCK_Q')				return false;
						if(e.field=='ISSUE_DIV_CODE')		return false;
						if(e.field=='WH_CODE')				return false;
						if(e.field=='DVRY_DATE')			return false;
						if(e.field=='DVRY_TIME')			return false;
						if(e.field=='ISSUE_QTY')			return false;
						if(e.field=='RETURN_Q')				return false;
						if(e.field=='ORDER_Q')				return false;
//						if(e.field=='ISSUE_REQ_PRICE')		return false;
//						if(e.field=='ISSUE_REQ_AMT')		return false;
//						if(e.field=='ISSUE_REQ_TAX_AMT')	return false;
//						if(e.field=='UNIT_WGT')				return false;
//						if(e.field=='UNIT_VOL')				return false;
						if(!Ext.isEmpty(e.record.data.ORDER_NUM)) {
//							if(e.field=='ORDER_TYPE')		return false;
//							if(e.field=='ORDER_UNIT')		return false;
//							if(e.field=='TRANS_RATE')		return false;
//							if(e.field=='DISCOUNT_RATE')	return false;
//							if(e.field=='BILL_TYPE')		return false;
//							if(e.field=='SALE_CUSTOM_CODE')	return false;
//							if(e.field=='SALE_CUSTOM_NAME')	return false;
							if(e.field=='DISCOUNT_RATE')	return false;
						} else {
							if(e.field=='DISCOUNT_RATE') {
								if( !(e.record.data.AMEND_YN == 'Y' || ( e.record.data.AMEND_YN == 'N' && Unilite.nvl(e.record.data.DISCOUNT_RATE,0) == 0))) {
									return false;
								}
							}
						}
					} else {
						return false;
					}
				}*/
			}
		}
	});

	var detailGrid2 = Unilite.createGrid('s_srq100ukrv_mitGrid2', {
		store	: detailStore2,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: false
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns: [
			{dataIndex: 'DIV_CODE'						, width: 66, hidden: true },
			{dataIndex: 'ISSUE_REQ_METH'				, width: 66, hidden: true },
			{dataIndex: 'ISSUE_REQ_PRSN'				, width: 66, hidden: true },
			{dataIndex: 'ISSUE_REQ_DATE'				, width: 66, hidden: true },
			{dataIndex: 'ISSUE_REQ_NUM'					, width: 110 },
			{dataIndex: 'ISSUE_REQ_SEQ'					, width: 40,align: 'center' },
			{dataIndex: 'CUSTOM_CODE'					, width: 80, hidden: true },
			{dataIndex: 'CUSTOM_NAME'					, width: 133 ,
				editor: Unilite.popup('CUST_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = Ext.getCmp('s_srq100ukrv_mitGrid2').uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('SALE_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('SALE_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								UniSales.fnGetPriceInfo2(
									grdRecord
									,UniAppManager.app.cbGetPriceInfo
									,'I'
									,UserInfo.compCode
									,records[0]['CUSTOM_CODE']
									,grdRecord.get('REF_AGENT_TYPE')
									,grdRecord.get('ITEM_CODE')
									,grdRecord.get('MONEY_UNIT')
									,grdRecord.get('ORDER_UNIT')
									,grdRecord.get('STOCK_UNIT')
									,grdRecord.get('TRANS_RATE')
									,UniDate.getDbDateStr(grdRecord.get('ISSUE_REQ_DATE'))
									,grdRecord.get('ISSUE_REQ_QTY')
									,grdRecord['WGT_UNIT']
									,grdRecord['VOL_UNIT']
								)
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = Ext.getCmp('s_srq100ukrv_mitGrid').uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE'		,'');
							grdRecord.set('CUSTOM_NAME'		,'');
							grdRecord.set('SALE_CUSTOM_CODE','');
							grdRecord.set('SALE_CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'ITEM_CODE'						, width: 120,
				 editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					extParam		: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										detailGrid2.setItemData(record,false, detailGrid2.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid2.setItemData(record,false, detailGrid2.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid2.setItemData(null,true, detailGrid2.uniOpt.currentRecord);
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'						, width: 133,
				 editor: Unilite.popup('DIV_PUMOK_G', {
					extParam	: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
					autoPopup	: true,
					listeners	: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										detailGrid2.setItemData(record,false, detailGrid2.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid2.setItemData(record,false, detailGrid2.getSelectedRecord());
									}
								});
							},
						scope: this
						},
						'onClear': function(type) {
							detailGrid2.setItemData(null,true, detailGrid2.uniOpt.currentRecord);
						}
					}
				})
			},
			{dataIndex: 'SPEC'							, width: 133 },
			{dataIndex: 'ORDER_UNIT'					, width: 66, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'PRICE_TYPE'					, width: 66, hidden: true },
			{dataIndex: 'TRANS_RATE'					, width: 53 },
			{dataIndex: 'STOCK_Q'						, width: 120, summaryType: 'sum' },
			{dataIndex: 'ISSUE_REQ_QTY'					, width: 106, summaryType: 'sum' },
			{dataIndex: 'ISSUE_FOR_PRICE'				, width: 106, hidden: true },
			{dataIndex: 'ISSUE_WGT_Q'					, width: 120, hidden: true },
			{dataIndex: 'ISSUE_FOR_WGT_P'				, width: 106, hidden: true },
			{dataIndex: 'ISSUE_VOL_Q'					, width: 120, hidden: true },
			{dataIndex: 'ISSUE_FOR_VOL_P'				, width: 106, hidden: true },
			{dataIndex: 'ISSUE_FOR_AMT'					, width: 106, hidden: true },
			{dataIndex: 'ISSUE_REQ_PRICE'				, width: 106, hidden: true},
			{dataIndex: 'ISSUE_WGT_P'					, width: 106, hidden: true },
			{dataIndex: 'ISSUE_VOL_P'					, width: 106, hidden: true },
			{dataIndex: 'ISSUE_REQ_AMT'					, width: 106, hidden: true, summaryType: 'sum'	},
			{dataIndex: 'TAX_TYPE'						, width: 80, align: 'center' },
			{dataIndex: 'ISSUE_REQ_TAX_AMT'				, width: 106, hidden: true, summaryType: 'sum' },
			{dataIndex: 'WGT_UNIT'						, width: 66, hidden: true },
			{dataIndex: 'UNIT_WGT'						, width: 66, hidden: true },
			{dataIndex: 'VOL_UNIT'						, width: 66, hidden: true },
			{dataIndex: 'UNIT_VOL'						, width: 66, hidden: true },
			{dataIndex: 'ISSUE_DATE'					, width: 80 },
			{dataIndex: 'DELIVERY_TIME'					, width: 80, hidden: true },
			{dataIndex: 'BILL_TYPE'						, width: 80,align: 'center' },
			{dataIndex: 'ORDER_TYPE'					, width: 90,align: 'center' },
			{dataIndex: 'INOUT_TYPE_DETAIL'				, width: 80,align: 'center' },
			{dataIndex: 'ISSUE_DIV_CODE'				, width: 90,align: 'center' },
			{dataIndex: 'WH_CODE'						, width: 150,
				listeners:{
					render:function(elm) {
						elm.editor.on('beforequery',function(queryPlan, eOpts) {
							var store = queryPlan.combo.store;
							var record = detailGrid2.uniOpt.currentRecord;
							store.clearFilter();
							store.filterBy(function(item){
								return item.get('option') == (Ext.isEmpty(record.get('ISSUE_DIV_CODE')) ? record.get('DIV_CODE') : record.get('ISSUE_DIV_CODE'));
							})
						})
					}
				}
			},
			{dataIndex: 'WH_CELL_CODE'				, width: 90, hidden:true },
			{dataIndex: 'DISCOUNT_RATE'					, width: 80 },
			{dataIndex: 'LOT_NO'						, width: 100,
				editor: Unilite.popup('LOT_MULTI_G', {
					autoPopup		: true,
					validateBlank	: false,
					textFieldName	: 'LOTNO_CODE',
					DBtextFieldName	: 'LOTNO_CODE',
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = detailGrid2.uniOpt.currentRecord;
								var rtnRecord;
								Ext.each(records, function(record,i) {
									if(i==0){
										rtnRecord = grdRecord;
									} else {
										UniAppManager.app.onNewDataButtonDown();
										rtnRecord		= detailGrid2.getSelectedRecord()
										var columns		= detailGrid2.getColumns();
										Ext.each(columns, function(column, index) {
											if(column.dataIndex != 'ISSUE_REQ_SEQ' && column.dataIndex != 'ISSUE_REQ_QTY' && column.dataIndex != 'ISSUE_REQ_AMT' && column.dataIndex != 'ISSUE_FOR_AMT') {
												rtnRecord.set(column.initialConfig.dataIndex, grdRecord.get(column.initialConfig.dataIndex));
											}
										});
									}
									var lotStockQ	= record['GOOD_STOCK_Q'];
									var issueReqQty	= rtnRecord.get('ISSUE_REQ_QTY');
									if (lotStockQ < issueReqQty || issueReqQty == 0) {
										issueReqQty = lotStockQ
									}
									rtnRecord.set('LOT_NO', record['LOT_NO']);
									var ouComboStore = 	Ext.data.StoreManager.lookup('ouChkCombo');//사용중인 창고 정보 스토어
									Ext.each(ouComboStore.data.items, function(comboData, idx) {//lotno팝업에서 선택한 창고가 사용중인 창고이면 선택한 창고로 세팅
										if(comboData.get('value') == record['WH_CODE']){
											rtnRecord.set('WH_CODE', record['WH_CODE']);
										}
									});
									rtnRecord.set('ISSUE_REQ_QTY', issueReqQty);
								});

								detailGrid2.getNavigationModel().setPosition(5, detailStore.getCount()-1);//lotno 컬럼이 뒤쪽에 있어 lotno입력 후 수량 입력 편하게 스크롤바 이동
							},
							scope: this
						},
						'onClear': function(type) {
							var record1 = detailGrid2.getSelectedRecord();
							record1.set('LOT_NO', '');
						},
						applyextparam: function(popup){
							var record		= detailGrid2.getSelectedRecord();
							var divCode		= record.get('ISSUE_DIV_CODE');
							var itemCode	= record.get('ITEM_CODE');
							var itemName	= record.get('ITEM_NAME');
							var whCode		= record.get('WH_CODE');
							popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode});
						}
					}
				})
			},
			{dataIndex: 'PRICE_YN'						, width: 80,align: 'center' },
			{dataIndex: 'SALE_CUSTOM_CODE'				, width: 80, hidden: true },
			{dataIndex: 'SALE_CUSTOM_NAME'				, width: 80 ,
				editor: Unilite.popup('AGENT_CUST_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = Ext.getCmp('s_srq100ukrv_mitGrid2').uniOpt.currentRecord;
								grdRecord.set('SALE_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = Ext.getCmp('s_srq100ukrv_mitGrid2').uniOpt.currentRecord;
							grdRecord.set('SALE_CUSTOM_CODE', '');
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'ACCOUNT_YNC'					, width: 80,align: 'center' },
			{dataIndex: 'DVRY_CUST_CD'					, width: 80, hidden: true },
			{dataIndex: 'DVRY_CUST_NAME'				, width: 120,
				editor: Unilite.popup('DELIVERY_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = detailGrid2.uniOpt.currentRecord;
								grdRecord.set('DVRY_CUST_CD'	, records[0]['DELIVERY_CODE']);
								grdRecord.set('DVRY_CUST_NAME'	, records[0]['DELIVERY_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = detailGrid2.uniOpt.currentRecord;
							grdRecord.set('DVRY_CUST_CD'	, '');
							grdRecord.set('DVRY_CUST_NAME'	, '');
						},
						applyextparam: function(popup){
							var grdRecord = detailGrid2.uniOpt.currentRecord;
							popup.setExtParam({'CUSTOM_CODE': grdRecord.get('CUSTOM_CODE')});
						}
					}
				})
			},
			{dataIndex: 'PROJECT_NO'					, width: 93 },
			{dataIndex: 'PO_NUM'						, width: 100 },
			{dataIndex: 'PO_SEQ'						, width: 80, hidden: true },
			{dataIndex: 'ORDER_NUM'						, width: 120 },
			{dataIndex: 'SER_NO'						, width: 66,align: 'center' },
			{dataIndex: 'UPDATE_DB_USER'				, width: 66, hidden: true },
			{dataIndex: 'UPDATE_DB_TIME'				, width: 66, hidden: true },
			{dataIndex: 'DEPT_CODE'						, width: 66, hidden: true },
			{dataIndex: 'TREE_NAME'						, width: 66, hidden: true},
			{dataIndex: 'MONEY_UNIT'					, width: 66, hidden: true },
			{dataIndex: 'EXCHANGE_RATE'					, width: 66, hidden: true },
			{dataIndex: 'ORDER_Q'						, width: 66, summaryType: 'sum' },
			{dataIndex: 'ISSUE_QTY'						, width: 66, summaryType: 'sum' },
			{dataIndex: 'RETURN_Q'						, width: 66, summaryType: 'sum' },
			{dataIndex: 'ISSUE_REQ_Q'					, width: 66, hidden: true },
			{dataIndex: 'DVRY_DATE'						, width: 80 },
			{dataIndex: 'DVRY_TIME'						, width: 80 },
			{dataIndex: 'TAX_INOUT'						, width: 66, hidden: true },
			{dataIndex: 'STOCK_UNIT'					, width: 66, hidden: true },
			{dataIndex: 'PRE_ACCNT_YN'					, width: 66, hidden: true },
			{dataIndex: 'REF_FLAG'						, width: 66, hidden: true },
			{dataIndex: 'SALE_P'						, width: 66, hidden: true },
			{dataIndex: 'AMEND_YN'						, width: 66, hidden: true },
			{dataIndex: 'OUTSTOCK_Q'					, width: 66, hidden: true },
			{dataIndex: 'ORDER_CUST_NM'					, width: 66, hidden: true },
			{dataIndex: 'STOCK_CARE_YN'					, width: 66, hidden: true },
			{dataIndex: 'NOTOUT_Q'						, width: 66, hidden: true},
			{dataIndex: 'SORT_KEY'						, width: 66, hidden: true },
			{dataIndex: 'REF_AGENT_TYPE'				, width: 66, hidden: true },
			{dataIndex: 'REF_WON_CALC_TYPE'				, width: 66, hidden: true },
			{dataIndex: 'REF_CODE2'						, width: 66, hidden: true },
			{dataIndex: 'COMP_CODE'						, width: 66, hidden: true },
			{dataIndex: 'SCM_FLAG_YN'					, width: 66, hidden: true },
			{dataIndex: 'REF_LOC'						, width: 66, hidden: true },
			{dataIndex: 'PAY_METHODE1'					, width: 100 },
			{dataIndex: 'LC_SER_NO'						, width: 100 },
			{dataIndex: 'GUBUN'							, width: 100, hidden: true },
			{dataIndex: 'REMARK'						, width: 106 },
			{dataIndex: 'REMARK_INTER'					, width: 106 }
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom ) {
					if(e.field=='LOT_NO') {
						if(Ext.isEmpty(e.record.data.WH_CODE)){
							Unilite.messageBox('<t:message code="system.message.sales.message057" default="출고창고를 입력하십시오."/>');
							return false;
						}
						if(Ext.isEmpty(e.record.data.ITEM_CODE)){
							Unilite.messageBox('<t:message code="system.message.sales.message024" default="품목코드를 입력 하십시오."/>');
							return false;
						}
					}
					//20191111 수주참조된 데이터는 출고사업장 등 아래 내용 수정할 수 없도록 변경 - uniLITE 소스와 동일하게 설정: 기존 생성 시 잘못 만든 내용 수정한 것임
//					if(!Ext.isEmpty(e.record.data.ISSUE_REQ_NUM)) {
					if(!Ext.isEmpty(e.record.data.ORDER_NUM)) {
						if(e.field=='CUSTOM_CODE')		return false;
						if(e.field=='CUSTOM_NAME')		return false;
						if(e.field=='ORDER_TYPE')		return false;
						if(e.field=='ITEM_CODE')		return false;
						if(e.field=='ITEM_NAME')		return false;
						if(e.field=='SPEC')				return false;
						if(e.field=='ORDER_UNIT')		return false;
						if(e.field=='TRANS_RATE')		return false;
						if(e.field=='STOCK_Q')			return false;
						if(e.field=='SALE_CUSTOM_CODE')	return false;
						if(e.field=='SALE_CUSTOM_NAME')	return false;
						if(e.field=='PRICE_YN')			return false;
						if(e.field=='ISSUE_DIV_CODE')	return false;
						if(e.field=='PO_NUM')			return false;
						if(e.field=='PO_SEQ')			return false;
						if(e.field=='SER_NO')			return false;
						if(e.field=='DISCOUNT_RATE')	return false;
						if(e.field=='BILL_TYPE')		return false;
						if(e.field=='TAX_TYPE')			return false;
						if(e.field=='ACCOUNT_YNC')		return false;
						if(e.field=='DVRY_CUST_NAME')	return false;
						if(e.field=='DVRY_DATE')		return false;
						if(e.field=='DVRY_TIME')		return false;
						if(e.field=='ISSUE_QTY')		return false;
						if(e.field=='RETURN_Q')			return false;
						if(e.field=='ORDER_Q')			return false;
						if( e.record.data.TAX_TYPE!= '1') {
							if(e.field=='ISSUE_REQ_TAX_AMT') return false;
						}
//						if(e.field=='ISSUE_REQ_PRICE')	return false;
//						if(e.field=='ISSUE_REQ_AMT')	return false;
//						if(e.field=='UNIT_WGT')			return false;
//						if(e.field=='UNIT_VOL')			return false;
//						if(!Ext.isEmpty(e.record.data.GUBUN)) {
//							if(e.field=='PRICE_TYPE')	return false;
//							if(e.field=='WGT_UNIT')		return false;
//							if(e.field=='VOL_UNIT')		return false;
//						}
					} else {
						if( e.record.data.BILL_TYPE == '50') {
							if(e.field=='TAX_TYPE')	return false;
						}
						if(e.field=='SPEC')			return false;
						if(e.field=='STOCK_Q')		return false;
						if(e.field=='PO_NUM')		return false;
						if(e.field=='PO_SEQ')		return false;
						if(e.field=='ORDER_NUM')	return false;
						if(e.field=='SER_NO')		return false;
						if(e.field=='DVRY_DATE')	return false;
						if(e.field=='DVRY_TIME')	return false;
						if(e.field=='PRICE_YN')		return false;
						if(e.field=='ISSUE_QTY')	return false;
						if(e.field=='RETURN_Q')		return false;
						if(e.field=='ORDER_Q')		return false;
						if( e.record.data.TAX_TYPE!= '1') {
							if(e.field=='ISSUE_REQ_TAX_AMT') return false;
						}
						if(e.field=='DISCOUNT_RATE') {
							if( !(e.record.data.AMEND_YN == 'Y' || ( e.record.data.AMEND_YN == 'N' && Unilite.nvl(e.record.data.DISCOUNT_RATE,0) == 0))) {
								return false;
							}
						}
//						if(e.field=='ISSUE_REQ_PRICE')	return false;
//						if(e.field=='ISSUE_REQ_AMT')	return false;
//						if(e.field=='UNIT_WGT')			return false;
//						if(e.field=='UNIT_VOL')			return false;
//						if(!Ext.isEmpty(e.record.data.GUBUN)) {
//							if(e.field=='PRICE_TYPE')	return false;
//							if(e.field=='WGT_UNIT')		return false;
//							if(e.field=='VOL_UNIT')		return false;
//						}
					}
				} else {
					//출고된 적 없음 & 출하된적 있음.
					if(Unilite.nvl(e.record.data.ISSUE_QTY,0) == 0) {
						if(e.field=='ISSUE_REQ_SEQ')		return false;
						if(e.field=='SPEC')					return false;
						if(e.field=='PO_NUM')				return false;
						if(e.field=='PO_SEQ')				return false;
						if(e.field=='ORDER_NUM')			return false;
						if(e.field=='SER_NO')				return false;
						if(e.field=='PRICE_YN')				return false;
						if(e.field=='CUSTOM_CODE')			return false;
						if(e.field=='CUSTOM_NAME')			return false;
						if(e.field=='ITEM_CODE')			return false;
						if(e.field=='ITEM_NAME')			return false;
						if(e.field=='STOCK_Q')				return false;
						if(e.field=='ISSUE_DIV_CODE')		return false;
						if(e.field=='WH_CODE')				return false;
						if(e.field=='DVRY_DATE')			return false;
						if(e.field=='DVRY_TIME')			return false;
						if(e.field=='ISSUE_QTY')			return false;
						if(e.field=='RETURN_Q')				return false;
						if(e.field=='ORDER_Q')				return false;
//						if(e.field=='ISSUE_REQ_PRICE')		return false;
//						if(e.field=='ISSUE_REQ_AMT')		return false;
//						if(e.field=='ISSUE_REQ_TAX_AMT')	return false;
//						if(e.field=='UNIT_WGT')				return false;
//						if(e.field=='UNIT_VOL')				return false;
						if(!Ext.isEmpty(e.record.data.ORDER_NUM)) {
//							if(e.field=='ORDER_TYPE')		return false;
//							if(e.field=='ORDER_UNIT')		return false;
//							if(e.field=='TRANS_RATE')		return false;
//							if(e.field=='DISCOUNT_RATE')	return false;
//							if(e.field=='BILL_TYPE')		return false;
//							if(e.field=='SALE_CUSTOM_CODE')	return false;
//							if(e.field=='SALE_CUSTOM_NAME')	return false;
							if(e.field=='DISCOUNT_RATE')	return false;
						} else {
							if(e.field=='DISCOUNT_RATE') {
								if( !(e.record.data.AMEND_YN == 'Y' || ( e.record.data.AMEND_YN == 'N' && Unilite.nvl(e.record.data.DISCOUNT_RATE,0) == 0))) {
									return false;
								}
							}
						}
					} else {
						return false;
					}
				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
//			var grdRecord = this.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, "");
				grdRecord.set('ITEM_NAME'		, "");
				grdRecord.set('SPEC'			, "");
				grdRecord.set('ORDER_UNIT'		, "");
				grdRecord.set('STOCK_UNIT'		, "");
				grdRecord.set('STOCK_Q'			, 0);
				grdRecord.set('WH_CODE'			, '');
				grdRecord.set('TAX_TYPE'		, '');
				grdRecord.set('ISSUE_DIV_CODE'	, '');
				grdRecord.set('WGT_UNIT'		, "");
				grdRecord.set('UNIT_WGT'		, 0);
				grdRecord.set('VOL_UNIT'		, "");
				grdRecord.set('UNIT_VOL'		, 0);
				grdRecord.set('ISSUE_REQ_PRICE'	, 0);
				grdRecord.set('ISSUE_WGT_P'		, 0);
				grdRecord.set('ISSUE_VOL_P'		, 0);
				grdRecord.set('TRANS_RATE'		, 1);
				grdRecord.set('ISSUE_FOR_PRICE'	, 0);
				grdRecord.set('ISSUE_FOR_WGT_P'	, 0);
				grdRecord.set('ISSUE_FOR_VOL_P'	, 0);
				grdRecord.set('AMEND_YN'		, 'N');
				grdRecord.set('TREE_NAME'		, 'N');
				grdRecord.set('STOCK_Q'			, 0);
				//20170518 - masterForm.getValue('EXCHAGE_RATE') 존재하지 않음
//				grdRecord.set('DISCOUNT_RATE'	, masterForm.getValue('EXCHAGE_RATE'));
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('ORDER_UNIT'		, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('WH_CODE'			, record['WH_CODE']);

				//20170518 - 추가
				grdRecord.set('ISSUE_FOR_PRICE'	, record['SALE_BASIS_P']);
//				grdRecord.set('ISSUE_REQ_AMT'	, record['ORDER_O']);

				if(grdRecord.get('BILL_TYPE') != '50') {
					grdRecord.set('TAX_TYPE'	, record['TAX_TYPE']);
				}
				grdRecord.set('ISSUE_DIV_CODE'	, record['DIV_CODE']);

				if(Ext.isEmpty(record['WGT_UNIT'])) {
					grdRecord.set('WGT_UNIT'	, '');
					grdRecord.set('UNIT_WGT'	, record['UNIT_WGT']);
				} else {
					grdRecord.set('WGT_UNIT'	, record['WGT_UNIT']);
					grdRecord.set('UNIT_WGT'	, record['UNIT_WGT']);
				}
				if(Ext.isEmpty(record['VOL_UNIT'])) {
					grdRecord.set('VOL_UNIT'	,'');
					grdRecord.set('UNIT_VOL'	, record['UNIT_VOL']);
				} else {
					grdRecord.set('VOL_UNIT'	, record['VOL_UNIT']);
					grdRecord.set('UNIT_VOL'	, record['UNIT_VOL']);
				}

				UniSales.fnGetItemInfo(
						grdRecord
						, UniAppManager.app.cbGetItemInfo
						, 'I'
						, UserInfo.compCode
						, grdRecord.get('CUSTOM_CODE')
						, grdRecord.get('REF_AGENT_TYPE')
						, record['ITEM_CODE']
						, BsaCodeInfo.gsMoneyUnit
						, record['SALE_UNIT']
						, record['STOCK_UNIT']
						, record['TRANS_RATE']
						, UniDate.getDbDateStr(record['ISSUE_REQ_DATE'])
						, grdRecord.get('ISSUE_REQ_QTY')
						, record['WGT_UNIT']
						, record['VOL_UNIT']
						, ''
						, ''
						, ''
						, UserInfo.divCode
						, null
						, record['WH_CODE']
				)
				//UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
			}
		}
	});

	var tab2Form = Unilite.createForm('tab2Form', {
		disabled	: false,
		region		: 'north',
		padding		: '1 1 1 1',
		layout		: {type: 'uniTable', columns: 5},
		items		: [
		Unilite.popup('ISSUE_REQ_NUM',{
			fieldLabel		: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>',
			textFieldName	: 'ISSUE_REQ_NUM',
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE'	: masterForm.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel		: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>',
			xtype			: 'uniDateRangefield',
			allowBlank		: false,
			startFieldName	: 'ISSUE_REQ_DATE_FR',
			endFieldName	: 'ISSUE_REQ_DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		}]
	});



	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab	: 0,
		region		: 'center',
		items		: [{
			id		: 's_srq100ukrv_mitGridTab1',
			title	: '<t:message code="system.label.sales.nonentry" default="미등록"/>',
			xtype	: 'container',
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [detailGrid]
		},{
			id		: 's_srq100ukrv_mitGridTab2',
			title	: '<t:message code="system.label.sales.entry" default="등록"/>',
			xtype	: 'container',
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [tab2Form, detailGrid2]
		}],
		listeners:  {
			tabChange:  function ( tabPanel, newCard, oldCard, eOpts ) {
				detailStore.loadData({});
				detailStore2.loadData({});
				//20200302 추가: 합계 필드 추가
				masterForm.setValue('SUM_ISSUE_REQ_QTY'	, 0);
				masterForm.setValue('SUM_ISSUE_REQ_AMT'	, 0);

				var activeTabId  = tab.getActiveTab().getId();
				if(activeTabId == 's_srq100ukrv_mitGridTab1') {
					UniAppManager.setToolbarButtons(['deleteAll'], false);
				} else {
					UniAppManager.setToolbarButtons(['deleteAll'], true);
				}
			}
		}
	});



	Unilite.Main({
		id		: 's_srq100ukrv_mitApp',
		items	: [{
			layout	: 'fit',
			flex	: 1,
			border	: false,
			items	: [{
				layout	: 'border',
				defaults: {style: {padding: '5 5 5 5'}},
				border	: false,
				items	: [
					tab,
					masterForm
				]
			}]
		}],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset'], true);
			this.setDefault();
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
		},
		onQueryButtonDown: function() {
			if(!masterForm.getInvalidMessage()) return;		//필수체크
			var activeTabId = tab.getActiveTab().getId();
			if (activeTabId == 's_srq100ukrv_mitGridTab1') {
				detailStore.loadStoreRecords();
			} else {
				if(!tab2Form.getInvalidMessage()) return;	//필수체크
				detailStore2.loadStoreRecords();
			}
		},
		//링크로 넘어오는 params 받는 부분
		processParams: function(params) {
			//this.uniOpt.appParams = params;
			if(params.PGM_ID == 'sof100ukrv') { //수주등록 에서 링크넘어올시
				//20200103 수주등록에서 링크로 넘어올 경우, 초기화 후 이후 작업 진행하도록 수정
				UniAppManager.app.onResetButtonDown();
				var formPram = params.formPram;
				masterForm.setValue('DIV_CODE'		, formPram.DIV_CODE);
				masterForm.setValue('CUSTOM_CODE'	, formPram.CUSTOM_CODE);
				masterForm.setValue('CUSTOM_NAME'	, formPram.CUSTOM_NAME);
				masterForm.setValue('SHIP_PRSN'		, formPram.ORDER_PRSN);

				if(!masterForm.setAllFieldsReadOnly(true)){
					return false;
				}
				var  taxInout = formPram.TAX_INOUT;
				 /**
				 * Detail Grid Default 값 설정
				 */
				Ext.each(params.record, function(rec,i){
					var seq = detailStore.max('ISSUE_REQ_SEQ');
					if(!seq) seq = 1;
					else  seq += 1;

					var customCode = '';
					var customName = '';
					if(Ext.isEmpty(masterForm.getValue('ISSUE_REQ_NUM'))) {
						customCode=masterForm.getValue('CUSTOM_CODE');
						customName=masterForm.getValue('CUSTOM_NAME');
					}

					// var orderType = rec.get('ORDER_TYPE');
					var billType = formPram.BILL_TYPE;
					var shipDate = UniDate.getDbDateStr(UniDate.get('today'));
					outDivCode = masterForm.getValue('DIV_CODE');
					var shipPrsn = '';
					var r = {
						ISSUE_REQ_SEQ		: seq,
						DIV_CODE			: outDivCode,
						ISSUE_REQ_METH		: '2',
						CUSTOM_CODE			: customCode,
						CUSTOM_NAME			: customName,
						ORDER_TYPE			: rec.get('REF_ORDER_TYPE'),
						BILL_TYPE			: billType,
						ITEM_CODE			: rec.get('ITEM_CODE'),
						ITEM_NAME			: rec.get('ITEM_NAME'),
						SPEC				: rec.get('SPEC'),
						ORDER_UNIT			: rec.get('ORDER_UNIT'),
						TRANS_RATE			: rec.get('TRANS_RATE'),
						WH_CODE				: Unilite.nvl(rec.get('OUT_WH_CODE'),rec.get('REF_WH_CODE')),
						ISSUE_REQ_QTY		: rec.get('ORDER_Q'),
						ISSUE_REQ_PRICE 	: UniSales.fnExchangeApply(rec.get('REF_MONEY_UNIT'), rec.get('ORDER_P') *  rec.get('REF_EXCHG_RATE_O')),							//20200611 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
						ISSUE_REQ_AMT		: UniSales.fnExchangeApply(rec.get('REF_MONEY_UNIT'), (rec.get('ORDER_P') *  rec.get('REF_EXCHG_RATE_O')) *  rec.get('ORDER_Q')),	//20200611 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
						TAX_TYPE			: rec.get('TAX_TYPE'),
						ISSUE_REQ_TAX_AMT	: UniSales.fnExchangeApply(rec.get('REF_MONEY_UNIT'), rec.get('ORDER_TAX_O') *  rec.get('REF_EXCHG_RATE_O')),						//20200611 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
						ISSUE_QTY			: 0,
						ORDER_NUM			:  rec.get('ORDER_NUM'),
						INOUT_TYPE_DETAIL	: rec.get('INOUT_TYPE_DETAIL'),
						ISSUE_DIV_CODE		: outDivCode,
						EXCHANGE_RATE		: rec.get('REF_EXCHG_RATE_O'),
						DISCOUNT_RATE		: 0,
						ISSUE_REQ_DATE		: shipDate,
						DEPT_CODE			: '*',
						ISSUE_REQ_PRSN		: shipPrsn,
						SALE_CUSTOM_CODE	: customCode,
						SALE_CUSTOM_NAME	: customName,
						REF_AGENT_TYPE		: CustomCodeInfo.gsAgentType,
						REF_WON_CALC_TYPE	: CustomCodeInfo.gsUnderCalBase,
						//20200116 수주등록에서 링크로 넘어올 때, 출고일에 납기일 들어가도록 하기위해서 set하는 로직 수정
//						ISSUE_DATE			: shipDate,
						ISSUE_DATE			: UniDate.getDateStr(rec.get('DVRY_DATE')),
						ACCOUNT_YNC			: 'Y',
						PRE_ACCNT_YN		: 'Y',
						REF_FLAG			: 'F',
						PRICE_YN			: '2',
						TREE_NAME			: 'N',
						AMEND_YN			: 'N',
						SER_NO				: rec.get('SER_NO'),
						ORDER_Q				: rec.get('ORDER_Q'),
						RETURN_Q			: rec.get('RETURN_Q'),
						DVRY_DATE			: UniDate.getDateStr(rec.get('DVRY_DATE')),
						ISSUE_FOR_PRICE		: rec.get('ORDER_P'),
						ISSUE_VOL_Q			: rec.get('ORDER_Q'),
						ISSUE_FOR_AMT		: rec.get('ORDER_O'),
						UNIT_VOL			: rec.get('UNIT_VOL'),
						TREE_NAME			: '*',
						MONEY_UNIT			: rec.get('REF_MONEY_UNIT'),
						TAX_INOUT			: taxInout,
						STOCK_UNIT			: rec.get('STOCK_UNIT'),
/*						NOTOUT_Q			: rec.get('NOTOUT_Q'),
						REF_AGENT_TYPE		: rec.get('REF_AGENT_TYPE'),
						REF_WON_CALC_TYPE	: rec.get('REF_WON_CALC_TYPE'), */
						GUBUN				: 'FEFER',
						//20200107 추가
						DVRY_CUST_CD		: rec.get('DVRY_CUST_CD'),
						DVRY_CUST_NAME		: rec.get('DVRY_CUST_NAME'),
						//20200121 추가
						REMARK				: rec.get('REMARK'),
						//20200130 추가
						STOCK_Q				: rec.get('STOCK_Q')
					}
					detailGrid.createRow(r, 'CUSTOM_CODE', seq-2);
					masterForm.setAllFieldsReadOnly(true);
					var newRecord = detailGrid.getSelectedRecord();
					newRecord.set('REF_CODE2', newRecord.get('INOUT_TYPE_DETAIL'));
//					UniAppManager.app.fnGetSubCode(newRecord, newRecord.get('INOUT_TYPE_DETAIL'));
					UniAppManager.app.fnAccountYN(newRecord, newRecord.get('INOUT_TYPE_DETAIL'));
//					UniAppManager.app.fnWhCd(newRecord,0);
				});
			}
		},
		onNewDataButtonDown: function() {},
		onResetButtonDown: function() {
			this.suspendEvents();
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			detailStore.loadData({});
			detailStore2.loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			var activeTabId = tab.getActiveTab().getId();
			if (activeTabId == 's_srq100ukrv_mitGridTab1') {
				detailStore.saveStore();
			} else {
				detailStore2.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			if (activeTabId == 's_srq100ukrv_mitGridTab1') {
				var selRow = detailGrid.getSelectedRecord();
				if(selRow.phantom === true) {
					detailGrid.deleteSelectedRow();
				} else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					detailGrid.deleteSelectedRow();
				}
			} else {
				var selRow = detailGrid2.getSelectedRecord();
				if(selRow.phantom === true) {
					detailGrid2.deleteSelectedRow();
				} else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					if(selRow.get('ISSUE_QTY') > 0) {
						Unilite.messageBox('<t:message code="system.message.sales.datacheck007" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
					} else {
						detailGrid2.deleteSelectedRow();
					}
				}
			}
		},
		onDeleteAllButtonDown: function() {
			if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
				var activeTabId = tab.getActiveTab().getId();
				if (activeTabId == 's_srq100ukrv_mitGridTab1') {
				} else {
					var records		= detailStore2.data.items;
					var isNewData	= false;
					Ext.each(records, function(record,i) {
						if(record.phantom){					// 신규 레코드일시 isNewData에 true를 반환
							isNewData = true;
						} else {							// 신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
							isNewData = false;
							if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
								var deletable = true;
								Ext.each(records, function(record,i) {
									if(record.get('ISSUE_QTY') > 0 ) {
										Unilite.messageBox('<t:message code="system.message.sales.datacheck007" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
										deletable = false;
										return false;
									}
								});
								if(deletable){
									detailGrid2.reset();
									UniAppManager.app.onSaveDataButtonDown();
								}
							}
							return false;
						}
					});
					if(isNewData){								// 신규 레코드들만 있을시 그리드 리셋
						detailGrid2.reset();
						UniAppManager.app.onResetButtonDown();	// 삭제후 RESET..
					}
				}
			}
		},
		setDefault: function() {
			masterForm.setValue('DIV_CODE'			, UserInfo.divCode);
			masterForm.setValue('DVRY_DATE_FR'		, UniDate.get('startOfMonth'));
			masterForm.setValue('DVRY_DATE_TO'		, UniDate.get('today'));
			//20200302 추가: 합계 필드 추가
			masterForm.setValue('SUM_ISSUE_REQ_QTY'	, 0);
			masterForm.setValue('SUM_ISSUE_REQ_AMT'	, 0);
		},
		checkForNewDetail:function() {
			//마스터 데이타  validation 및 readonly 설정
			return masterForm.setAllFieldsReadOnly(true);
		},
		fnOrderAmtCal: function(rtnRecord, sType, fieldName, nValue) {
			var dTransRate		= fieldName == 'TRANS_RATE'			? nValue : Unilite.nvl(rtnRecord.get('TRANS_RATE'),1);
			var dIssueReqQ		= fieldName == 'ISSUE_REQ_QTY'		? nValue : Unilite.nvl(rtnRecord.get('ISSUE_REQ_QTY'),0);
			var dIssueReqVolQ	= fieldName == 'ISSUE_VOL_Q'		? nValue : Unilite.nvl(rtnRecord.get('ISSUE_VOL_Q'),0);
			var dIssueReqWgtQ	= fieldName == 'ISSUE_WGT_Q'		? nValue : Unilite.nvl(rtnRecord.get('ISSUE_WGT_Q'),0);
			var dOrderP			= fieldName == 'ISSUE_REQ_PRICE'	? nValue : Unilite.nvl(rtnRecord.get('ISSUE_REQ_PRICE'),0);
			var dOrderWgtP		= fieldName == 'ISSUE_WGT_P'		? nValue : Unilite.nvl(rtnRecord.get('ISSUE_WGT_P'),0);
			var dOrderVolP		= fieldName == 'ISSUE_VOL_P'		? nValue : Unilite.nvl(rtnRecord.get('ISSUE_VOL_P'),0);
			var dOrderForP		= fieldName == 'ISSUE_FOR_PRICE'	? nValue : Unilite.nvl(rtnRecord.get('ISSUE_FOR_PRICE'),0);
			var dOrderWgtForP	= fieldName == 'ISSUE_FOR_WGT_P'	? nValue : Unilite.nvl(rtnRecord.get('ISSUE_FOR_WGT_P'),0);
			var dOrderVolForP	= fieldName == 'ISSUE_FOR_VOL_P'	? nValue : Unilite.nvl(rtnRecord.get('ISSUE_FOR_VOL_P'),0);
			var dExchgRate		= fieldName == 'EXCHANGE_RATE'		? nValue : Unilite.nvl(rtnRecord.get('EXCHANGE_RATE'),0);
			var dOrderO			= fieldName == 'ISSUE_REQ_AMT'		? nValue : Unilite.nvl(rtnRecord.get('ISSUE_REQ_AMT'),0);
			var dOrderForO		= fieldName == 'ISSUE_FOR_AMT'		? nValue : Unilite.nvl(rtnRecord.get('ISSUE_FOR_AMT'),0);
			var dDCRate			= fieldName == 'DISCOUNT_RATE'		? nValue : Unilite.nvl(rtnRecord.get('DISCOUNT_RATE'),0);
			var dUnitWgt		= fieldName == 'UNIT_WGT'			? nValue : Unilite.nvl(rtnRecord.get('UNIT_WGT'),0);
			var dUnitVol		= fieldName == 'UNIT_VOL'			? nValue : Unilite.nvl(rtnRecord.get('UNIT_VOL'),0);
			var dPriceType		= Unilite.nvl(rtnRecord.get('PRICE_TYPE'), 'A');
			//20200611 추가: 자사금액 계산시, 'JPY' 관련로직 추가
			var moneyUnit		= rtnRecord.get('MONEY_UNIT');

			if(sType == 'P' || sType == 'Q') {	//업종별 프로세스 적용
				//20200611 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
				dOrderP		= UniSales.fnExchangeApply(moneyUnit, dOrderForP	* dExchgRate);
				dOrderWgtP	= UniSales.fnExchangeApply(moneyUnit, dOrderWgtForP	* dExchgRate);
				dOrderVolP	= UniSales.fnExchangeApply(moneyUnit, dOrderVolForP	* dExchgRate);

				if(dPriceType == 'A') 	{
					dOrderForO	= dIssueReqQ * dOrderForP;
					dOrderO		= dIssueReqQ * dOrderP;
				} else if( dPriceType == 'B') {
					dOrderForO	= dIssueReqWgtQ * dOrderWgtForP;
					dOrderO		= dIssueReqWgtQ * dOrderWgtP;
				} else if( dPriceType == 'C') {
					dOrderForO	= dIssueReqVolQ * dOrderVolForP;
					dOrderO		= dIssueReqVolQ * dOrderVolP;
				} else {
					dOrderForO	= dIssueReqQ * dOrderForP;
					dOrderO		= dIssueReqQ * dOrderP;
				}
				rtnRecord.set('ISSUE_FOR_AMT'	, dOrderForO);
				rtnRecord.set('ISSUE_FOR_PRICE'	, dOrderForP);
				rtnRecord.set('ISSUE_FOR_WGT_P'	, dOrderWgtForP);
				rtnRecord.set('ISSUE_FOR_VOL_P'	, dOrderVolForP);
				rtnRecord.set('ISSUE_REQ_AMT'	, dOrderO);
				rtnRecord.set('ISSUE_REQ_PRICE'	, dOrderP);
				rtnRecord.set('ISSUE_WGT_P'		, dOrderWgtP);
				rtnRecord.set('ISSUE_VOL_P'		, dOrderVolP);
				UniAppManager.app.fnTaxCalculate(rtnRecord, dOrderO)
			}  else if(sType == 'O') {
				//단가/세액 재계산
				if( dIssueReqQ > 0 ) {
					//단가 재계산
					dOrderForP	= (dOrderForO / dIssueReqQ) ;
					//20200611 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
					dOrderP		= UniSales.fnExchangeApply(moneyUnit, (dOrderForO / dIssueReqQ) * dExchgRate);
					if(dIssueReqWgtQ != 0 ) {
						dOrderWgtForP	= (dOrderForO / dIssueReqWgtQ);
						//20200611 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
						dOrderWgtP		= UniSales.fnExchangeApply(moneyUnit, (dOrderForO / dIssueReqWgtQ) * dExchgRate);
					}
					if(dIssueReqVolQ != 0 ) {
						dOrderVolForP	= (dOrderForO / dIssueReqVolQ);
						//20200611 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
						dOrderVolP		= UniSales.fnExchangeApply(moneyUnit, (dOrderForO / dIssueReqVolQ) * dExchgRate);
					}
					if( dPriceType == 'A') {
						dOrderO 	= dOrderP * dIssueReqQ ;
						dOrderForO	= dOrderForP * dIssueReqQ ;
					} else if( dPriceType == 'B') {
						dOrderO		= dOrderWgtP * dIssueReqWgtQ  ;
						dOrderForO	= dOrderWgtForP * dIssueReqWgtQ;
					} else if( dPriceType == 'C') {
						dOrderO		= dOrderVolP * dIssueReqVolQ  ;
						dOrderForO	= dOrderVolForP * dIssueReqVolQ;
					} else {
						dOrderO		= dOrderP * dIssueReqQ  ;
						dOrderForO	= dOrderForP * dIssueReqQ;
					}
					rtnRecord.set('ISSUE_REQ_PRICE'	, dOrderP);
					rtnRecord.set('ISSUE_WGT_P'		, dOrderWgtP);
					rtnRecord.set('ISSUE_VOL_P'		, dOrderVolP);
					rtnRecord.set('ISSUE_REQ_AMT'	, dOrderO);
					rtnRecord.set('ISSUE_FOR_PRICE'	, dOrderForP);
					rtnRecord.set('ISSUE_FOR_WGT_P'	, dOrderWgtForP);
					rtnRecord.set('ISSUE_FOR_VOL_P'	, dOrderVolForP);
					rtnRecord.set('ISSUE_FOR_AMT'	, dOrderForO);
				}
				UniAppManager.app.fnTaxCalculate(rtnRecord, dOrderO)
			}
		},
		fnOrderAmtCalR: function(rtnRecord, nValue) {
			var dIssueReqQ 		= Unilite.nvl(rtnRecord.get('ISSUE_REQ_QTY'),0);
			var dIssueReqVolQ 	= Unilite.nvl(rtnRecord.get('ISSUE_VOL_Q'),0);
			var dIssueReqWgtQ 	= Unilite.nvl(rtnRecord.get('ISSUE_WGT_Q'),0);
			var dOrderP			= fieldName=='ISSUE_REQ_PRICE' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_REQ_PRICE'),0);
			var dOrderWgtP		= fieldName=='ISSUE_WGT_P' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_WGT_P'),0);
			var dOrderVolP		= fieldName=='ISSUE_VOL_P' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_VOL_P'),0);
			var dOrderForP		= fieldName=='ISSUE_FOR_PRICE' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_FOR_PRICE'),0);
			var dOrderWgtForP	= fieldName=='ISSUE_FOR_WGT_P' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_FOR_WGT_P'),0);
			var dOrderVolForP	= fieldName=='ISSUE_FOR_VOL_P' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_FOR_VOL_P'),0);
			var dExchgRate		= fieldName=='EXCHANGE_RATE' ? nValue : Unilite.nvl(rtnRecord.get('EXCHANGE_RATE'),0);
			var dOrderO			= fieldName=='ISSUE_REQ_AMT' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_REQ_AMT'),0);
			var dOrderForO		= fieldName=='ISSUE_FOR_AMT' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_FOR_AMT'),0);
			var dDCRate			= nValue ;
			var dPriceType		= Unilite.nvl(rtnRecord.get('UNIT_VOL'),'A');
			//20200611 추가: 자사금액 계산시, 'JPY' 관련로직 추가
			var moneyUnit		= rtnRecord.get('MONEY_UNIT');

			if ( Ext.isEmpty(rtnRecord.get("ORDER_NUM"))) {
				//할인율 변경시, 단가/금액/세액 재계산
				rtnRecord.set('AMEND_YN'	, 'Y');
				rtnRecord.set('TREE_NAME'	, 'Y');		//부서명 : 할인율 적용여부 SET(N:미수정/Y:수정)

				if( dSaleP == 0 ) {
					return;
				}

				if( dOrderP == 0 || dOrderP != dSaleP ) {
					// 단가 = 판매단가 - ( 판매단가 * 할인율 / 100 )
					dOrderP = dSaleP - ( dSaleP * ( dDCRate / 100 ));
				} else {
					// 단가 = 단가 - ( 단가 * 할인율 / 100 )
					dOrderP = dOrderP - ( dOrderP * ( dDCRate / 100 ));
				}

				if( dOrderWgtP == 0 || dOrderWgtP != dSaleP ) {
					// 단가 = 판매단가 - ( 판매단가 * 할인율 / 100 )
					dOrderWgtP = dSaleP - ( dSaleP * ( dDCRate / 100 ));
				} else {
					// 단가 = 단가 - ( 단가 * 할인율 / 100 )
					dOrderWgtP = dOrderWgtP - ( dOrderWgtP * ( dDCRate / 100 ));
				}

				if ( dOrderVolP == 0 || dOrderVolP != dSaleP ) {
					// 단가 = 판매단가 - ( 판매단가 * 할인율 / 100 )
					dOrderVolP = dSaleP - ( dSaleP * ( dDCRate / 100 ))
				} else {
					// 단가 = 단가 - ( 단가 * 할인율 / 100 )
					dOrderVolP = dOrderVolP - ( dOrderVolP * ( dDCRate / 100 ))
				}

				//20200611 수정: 자사금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply 추가)
				dOrderP		= UniSales.fnExchangeApply(moneyUnit, dOrderP		* dExchgRate);
				dOrderWgtP	= UniSales.fnExchangeApply(moneyUnit, dOrderWgtP	* dExchgRate);
				dOrderVolP	= UniSales.fnExchangeApply(moneyUnit, dOrderVolP	* dExchgRate);

				if (dPriceType == 'A') {
					dOrderO		= dIssueReqQ * dOrderP;
					dOrderForO	= dIssueReqQ * dOrderForP;
				} else  if (dPriceType == 'B') {
					dOrderO		= dIssueReqWgtQ * dOrderWgtP;
					dOrderForO	= dIssueReqWgtQ * dOrderWgtForP;
				} else  if (dPriceType == 'C') {
					dOrderO		= dIssueReqVolQ * dOrderVolP;
					dOrderForO	= dIssueReqVolQ * dOrderVolForP;
				} else	{
					dOrderO		= dIssueReqQ * dOrderP;
					dOrderForO	= dIssueReqQ * dOrderForP;
				}
				rtnRecord.set('ISSUE_FOR_PRICE'	, dOrderForP);
				rtnRecord.set('ISSUE_FOR_WGT_P'	, dOrderWgtForP);
				rtnRecord.set('ISSUE_FOR_VOL_P'	, dOrderVolForP);
				rtnRecord.set('ISSUE_FOR_AMT'	, dOrderForO);
				rtnRecord.set('ISSUE_REQ_PRICE'	, dOrderP);
				rtnRecord.set('ISSUE_WGT_P'		, dOrderWgtP);
				rtnRecord.set('ISSUE_VOL_P'		, dOrderVolP);
				rtnRecord.set('ISSUE_REQ_AMT'	, dOrderO);
				UniAppManager.app.fnTaxCalculate(rtnRecord, dOrderO)
			}
		},
		fnTaxCalculate: function(rtnRecord, dOrderO) {
			var sTaxType		= rtnRecord.get('TAX_TYPE');
			var sUnderCalcType	= rtnRecord.get('REF_WON_CALC_TYPE');
			var sTaxInoutType	= Unilite.nvl(rtnRecord.get('TAX_INOUT'), '1');
			var dVatRate		= parseInt(BsaCodeInfo.gsVatRate);
			var dAmountI		= dOrderO;
			var dIRAmtO			= 0;
			var dTaxAmtO		= 0;

			if(sTaxInoutType=="1") {
				dIRAmtO		= dOrderO;
				dTaxAmtO	= dOrderO * (dVatRate / 100)
				dIRAmtO		= UniSales.fnAmtWonCalc(dIRAmtO,sUnderCalcType);

				if(UserInfo.compCountry == 'CN') {
					//20191002 세액 구하는 함수 생성: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTaxAmtO, '3');
				} else {
					//20191002 세액 구하는 함수 생성: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTaxAmtO, sUnderCalcType);
				}
			} else if(sTaxInoutType=="2") {
				if(UserInfo.compCountry == 'CN') {
					dTemp		= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '3');
					//20191002 세액 구하는 함수 생성: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO	= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, '3');
				} else {
					dTemp		= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, sUnderCalcType);
					//20191002 세액 구하는 함수 생성: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO	= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, sUnderCalcType);
				}
				dIRAmtO = UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), sUnderCalcType) ;
			}
			if(sTaxType == "2") {
				dIRAmtO		= UniSales.fnAmtWonCalc(dOrderO, sUnderCalcType );
				dTaxAmtO	= 0;
			}
			rtnRecord.set('ISSUE_REQ_AMT'		, dIRAmtO);
			rtnRecord.set('ISSUE_REQ_TAX_AMT'	, dTaxAmtO);
		},
		fnCheckNum: function(value, record, fieldName) {
			var r = true;
			if(record.get("PRICE_YN") == "1" || record.get("ACCOUNT_YNC")=="N") {
				r = true;
			} else if(record.get("PRICE_YN") == "2" ) {
				if(value < 0) {
					Unilite.messageBox('<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>');
					r = false;
					return r;
				} else if(value == 0) {
					if(fieldName == "ISSUE_REQ_TAX_AMT") {
						if(BsaCodeInfo.gsVatRate != 0) {
							Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
							r = false;
						}
					} else if(fieldName == "ISSUE_REQ_PRICE" || fieldName == "ISSUE_REQ_AMT") {
						if( record.get("ACCOUNT_YNC")=="Y") {
							Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
							r = false;
						}
					} else {
						Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
						r = false;
					}
				}
			}
			return r;
		},
		fnGetSubCode: function(rtnRecord, subCode) {
			var fRecord = '';
			Ext.each(BsaCodeInfo.gsOutType, function(item, i) {
				if(item['codeNo'] == subCode) {
					fRecord = item['refCode2'];
				}
			})
			return fRecord;
		},
		fnAccountYN: function(rtnRecord, subCode) {
			var fRecord ='';
			Ext.each(BsaCodeInfo.gsOutType, function(item, i) {
				if(item['codeNo'] == subCode && !Ext.isEmpty(item['refCode1'])) {
					fRecord = item['refCode1'];
				}
			});
//			return fRecord;
			//20170518 - 로직이 맞지 않음 : 주석
//			rtnRecord.set('ACCOUNT_YNC',subCode);
		},
		fnWhCd: function(rtnRecord, index) {
			var fRecord ='';
			if(detailGrid.getStore().data.items.length>0){
				fRecord = detailGrid.getStore().data.items[0].WH_CODE;
			}
//			return fRecord;
			rtnRecord.set('WH_CODE', fRecord);
		},
		// UniSales.fnGetPriceInfo callback 함수
		cbGetPriceInfo: function(provider, params) {
			var dSalePrice	= Unilite.nvl(provider['SALE_PRICE'], 0);
			var dWgtPrice	= Unilite.nvl(provider['WGT_PRICE']	, 0);//판매단가(중량단위)
			var dVolPrice	= Unilite.nvl(provider['VOL_PRICE']	, 0);//판매단가(부피단위)

			if(params.sType=='I') {
				//단가구분별 판매단가 계산
				if(params.priceType == 'A') {							//단가구분(판매단위)
					dWgtPrice	= (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					dVolPrice	= (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
					params.rtnRecord.set('SALE_P', dSalePrice);
				} else if(params.priceType == 'B') {					//단가구분(중량단위)
					dSalePrice	= dWgtPrice  * params.unitWgt
					dVolPrice	= (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
					params.rtnRecord.set('SALE_P', dWgtPrice);
				} else if(params.priceType == 'C') {					//단가구분(부피단위)
					dSalePrice	= dVolPrice  * params.unitVol;
					dWgtPrice	= (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					params.rtnRecord.set('SALE_P', dVolPrice);
				} else {
					dWgtPrice	= (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					dVolPrice	= (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
					params.rtnRecord.set('SALE_P', dSalePrice);
				}

				if(params.bOpt == null || params.bOpt == "") {
					params.rtnRecord.set('ISSUE_REQ_PRICE'	, dSalePrice);
					params.rtnRecord.set('ISSUE_WGT_P'		, dWgtPrice);
					params.rtnRecord.set('ISSUE_VOL_P'		, dVolPrice);
					params.rtnRecord.set('TRANS_RATE'		, provider['SALE_TRANS_RATE']);
					params.rtnRecord.set('DISCOUNT_RATE'	, provider['DC_RATE']);
					//20170518 - masterForm.getValue('EXCHAGE_RATE') 존재하지 않음
					/*var exchangRate = masterForm.getValue('EXCHAGE_RATE');
					params.rtnRecord.set('ISSUE_FOR_PRICE', dSalePrice / exchangRate);
					params.rtnRecord.set('ISSUE_FOR_WGT_P', dWgtPrice / exchangRate);
					params.rtnRecord.set('ISSUE_FOR_VOL_P', dVolPrice / exchangRate);*/
				}
				params.rtnRecord.set('AMEND_YN'	, 'N');
				params.rtnRecord.set('TREE_NAME', 'N');
			}
			if(params.qty > 0)	UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P");
		},
		cbGetPriceInfoR: function(provider, params) {
			UniAppManager.app.cbGetPriceInfo(provider, params);
			var dOrderO = params.rtnRecord.get('ISSUE_REQ_AMT')
			UniAppManager.app.fnOrderAmtCalR(params.rtnRecord, dOrderO);
		},
		// UniSales.fnGetItemInfo callback 함수
		cbGetItemInfo: function(provider, params) {
			UniAppManager.app.cbGetPriceInfo(provider, params);
			UniAppManager.app.cbStockQ(provider, params);
		},
		// UniSales.fnStockQ callback 함수
		cbStockQ: function(provider, params) {
			var rtnRecord	= params.rtnRecord;
			var dStockQ		= Unilite.nvl(provider['STOCK_Q']		, 0);
			var dOrderQ		= Unilite.nvl(rtnRecord.get('ORDER_Q')	, 0);
			var lTrnsRate	= rtnRecord.get('TRANS_RATE');
			rtnRecord.set('STOCK_Q', dStockQ / lTrnsRate);
		}
	});



	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			switch(fieldName) {
				case "BILL_TYPE":
					if(newValue=='50') {
						record.set('TAX_TYPE','2');
						record.set('ISSUE_REQ_TAX_AMT','0');
					}
				break;

			case 'INOUT_TYPE_DETAIL' :	//출고유형
				var sInoutTypeDetail = newValue;
				var sRefCode2 = UniAppManager.app.fnGetSubCode(record, sInoutTypeDetail) ;
				var gsOldRefCode2 = record.get('REF_CODE2');
				record.set('REF_CODE2',sRefCode2);

				if(sRefCode2 > '91' || sRefCode2 == '90') {
					Unilite.messageBox('<t:message code="system.message.sales.message046" default="해당 출고유형은 선택할 수 없습니다."/>');
					record.set('INOUT_TYPE_DETAIL',oldValue);
					record.set('REF_CODE2',gsOldRefCode2);
					break;
				} else if(sRefCode2 == '91') {		//폐기
					if(!Ext.isEmpty(record.get('ORDER_NUM'))) {
						Unilite.messageBox('<t:message code="system.message.sales.message047" default="출고유형[폐기]는 예외 출고등록만 가능합니다."/>');
						record.set('INOUT_TYPE_DETAIL',oldValue);
						record.set('REF_CODE2',gsOldRefCode2);
						break;
					}
				}

				if(newValue == '') {
					record.set('ACCOUNT_YNC','N');
				} else {
					if(!Ext.isEmpty(record.get('ORDER_NUM'))) {
						UniAppManager.app.fnAccountYN(record, newValue);
					}
				}
				break;

			case 'ISSUE_DIV_CODE':
				if(newValue != oldValue) {
					record.set('WH_CODE'			, '');
					record.set('STOCK_Q'			, 0);
				}
				break;

			case 'WH_CODE':			//출고창고
				UniSales.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('ISSUE_DIV_CODE'), null, record.get('ITEM_CODE'),  newValue);
				break;

			case "ORDER_UNIT" :
				if(Ext.isEmpty(record.get('CUSTOM_NAME'))) {
					Unilite.messageBox('<t:message code="system.message.sales.message048" default="객을 먼저 선택하셔야 합니다."/>');
					break;
				}
				UniSales.fnGetPriceInfo2( record
										, UniAppManager.app.cbGetPriceInfo
										, 'I'
										, UserInfo.compCode
										, record.get('CUSTOM_CODE')
										, record.get('REF_AGENT_TYPE')
										, record.get('ITEM_CODE')
										, record.get('MONEY_UNIT')
										, record.get('ORDER_UNIT')
										, record.get('STOCK_UNIT')
										, record.get('TRANS_RATE')
										, UniDate.getDbDateStr(record.get('ISSUE_REQ_DATE'))
										, record.get('ISSUE_REQ_QTY')
										, record.get('WGT_UNIT')
										, record.get('VOL_UNIT')
				);
				break;

			case "TRANS_RATE" :
				if(newValue <= 0) {
					rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
					record.set('TRANS_RATE',oldValue);
					break
				}
				if(Ext.isEmpty(record.get('CUSTOM_NAME'))) {
					Unilite.messageBox('<t:message code="system.message.sales.message048" default="고객을 먼저 선택하셔야 합니다."/>');
					break;
				}
				UniSales.fnGetPriceInfo2( record
										, 'I'
										, UserInfo.compCode
										, masterForm.getValue('CUSTOM_CODE')
										, record.get('AGENT_TYPE')
										, record.get('ITEM_CODE')
										, record.get('MONEY_UNIT')
										, record.get('ORDER_UNIT')
										, record.get('STOCK_UNIT')
										, record.get('TRANS_RATE')
										, UniDate.getDbDateStr(record.get('ISSUE_REQ_DATE'))
										, record.get('ORDER_Q')
										, record.get('WGT_UNIT')
										, record.get('VOL_UNIT')
				)
				break;

			case 'ISSUE_REQ_QTY' : 			//출하지시량
				//출하지시량
				var dIssueReqQ = Unilite.nvl(newValue, 0);
				//출고량
				var dOutStockQ = Unilite.nvl(record.get('ISSUE_QTY'), 0);
				/*issueLinkBtn 존재하지 않음(주석) - 20170516
				if(dIssueReqQ-dOutStockQ > 0 ) {
					detailGrid.down('#issueLinkBtn').disable(false);
				} else {
					detailGrid.down('#issueLinkBtn').disable(true);
				}*/
				if(!record.phantom) {
					if(dOutStockQ > 0) {
						Unilite.messageBox('<t:message code="system.message.sales.message049" default="출고가 발생한 건은 수정/삭제할 수 없습니다."/>');
						break;
					}
				}
				//수주참조일 때,
				if(!Ext.isEmpty(record.get('ORDER_NUM'))) {
					//미납량(출하가능량)
					dCanOutQ = Unilite.nvl(record.get('NOTOUT_Q'), 0);
					if(record.phantom) {
						if(dIssueReqQ > dCanOutQ) {
							Unilite.messageBox('<t:message code="system.message.sales.message050" default="출하지시량이 출고가능수량을 초과했습니다."/>');
						break;
						}
					}
				}

				//출하지시량(중량) 재계산
				var sUnitWgt	= record.get('UNIT_WGT');
				var sOrderWgtQ = dIssueReqQ * sUnitWgt;
				record.set('ISSUE_WGT_Q', sOrderWgtQ);

				//출하지시량(부피) 재계산
				var sUnitVol	= record.get('UNIT_VOL');
				var sOrderVolQ = dIssueReqQ * sUnitVol
				record.set('ISSUE_VOL_Q', sOrderVolQ);

				UniAppManager.app.fnOrderAmtCal(record, "Q", fieldName, newValue);
				break;

			case 'ISSUE_REQ_PRICE':
				record.set('ISSUE_FOR_PRICE', UniSales.fnExchangeApply2(record.get('MONEY_UNIT'), newValue / record.get('EXCHANGE_RATE')));	//20200611 수정: 외화금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply2 추가)
				UniAppManager.app.fnOrderAmtCal(record, "P", fieldName, newValue);
				break;

			case 'ISSUE_REQ_AMT':
				UniAppManager.app.fnOrderAmtCal(record, "O", fieldName, newValue);
				break;

			case 'TAX_TYPE':	 //과세구분
				if(newValue == '2') {
					record.set('ISSUE_REQ_TAX_AMT', 0);
				}
				record.set('TAX_TYPE', newValue);
				UniAppManager.app.fnOrderAmtCal(record, 'O', fieldName, newValue);
				break;

			case 'ISSUE_REQ_TAX_AMT':	//세액
				if(! UniAppManager.app.fnCheckNum(newValue, record, fieldName)) {
					record.set('ISSUE_REQ_TAX_AMT', oldValue);
					break;
				}
				break;

			case 'ISSUE_DATE':  // 출고요청일
				if(Ext.isEmpty(newValue)) {
					record.set('ISSUE_DATE', oldValue);
					break;
				}
				var shipDate = UniDate.getDbDateStr(record.get('ISSUE_REQ_DATE'));
				if(shipDate > newValue) {
					Unilite.messageBox('<t:message code="system.message.sales.message007" default="출고예정일은 출하지시일과 같거나 이후이어야 합니다"/>');
					record.set('ISSUE_DATE', oldValue);
					break;
				}
				if(record.get('ISSUE_REQ_METH')== '1') {
					if(record.get('DVRY_DATE') >= shipDate && record.get('DVRY_DATE') < record.get('ISSUE_DATE')) {
						if(!confirm('<t:message code="system.message.sales.message006" default="출고예정일은 납기일보다 이전이어야 합니다."/>' + '\n'
							+ '<t:message code="system.label.sales.seq" default="순번"/>'+':'+record.get('ISSUE_REQ_SEQ') + '\n'
							+ '<t:message code="system.label.sales.issueresevationdate" default="출고예정일"/>:'+record.get('ISSUE_DATE') + '\n'
							+ '<t:message code="system.label.sales.deliverydate" default="납기일"/>' )
						 ) {
							record.set('ISSUE_DATE', oldValue);
							break;
						}
					}
				}
				break;

			case 'ACCOUNT_YNC':
				if(!record.phantom && !Ext.isEmpty(record.get('PRE_ACCNT_YN'))) {
					if(confirm(''+'<t:message code="system.message.sales.message042" default="수주내역의 매출대상이 변경되었습니다."/>'+ '<t:message code="system.message.sales.message051" default="참조된 수불내역에 반영하시겠습니까?"/>')) {
						record.set('REF_FLAG', newValue);
					} else {
						record.set('REF_FLAG', 'F');
					}
				}
				break;

			case 'DISCOUNT_RATE':
				if(! UniAppManager.app.fnCheckNum(newValue, record, fieldName)) {
					record.set('DISCOUNT_RATE', oldValue);
					break;
				}
				UniSales.fnGetPriceInfo2(
					record
					, UniAppManager.app.cbGetPriceInfoR
					, 'I'
					, UserInfo.compCode
					, record.get('CUSTOM_CODE')
					, record.get('REF_AGENT_TYPE')
					, record.get('ITEM_CODE')
					, record.get('MONEY_UNIT')
					, record.get('ORDER_UNIT')
					, record.get('STOCK_UNIT')
					, record.get('TRANS_RATE')
					, UniDate.getDbDateStr(record.get('ISSUE_REQ_DATE'))
					, record.get('ISSUE_REQ_QTY')
					, record['WGT_UNIT']
					, record['VOL_UNIT']
				)
				break;
			}
			return rv;
		}
	});
	Unilite.createValidator('validator02', {
		store	: detailStore2,
		grid	: detailGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			switch(fieldName) {
				case "BILL_TYPE":
					if(newValue=='50') {
						record.set('TAX_TYPE','2');
						record.set('ISSUE_REQ_TAX_AMT','0');
					}
				break;

			case 'INOUT_TYPE_DETAIL' :	//출고유형
				var sInoutTypeDetail = newValue;
				var sRefCode2 = UniAppManager.app.fnGetSubCode(record, sInoutTypeDetail) ;
				var gsOldRefCode2 = record.get('REF_CODE2');
				record.set('REF_CODE2',sRefCode2);

				if(sRefCode2 > '91' || sRefCode2 == '90') {
					Unilite.messageBox('<t:message code="system.message.sales.message046" default="해당 출고유형은 선택할 수 없습니다."/>');
					record.set('INOUT_TYPE_DETAIL',oldValue);
					record.set('REF_CODE2',gsOldRefCode2);
					break;
				} else if(sRefCode2 == '91') {		//폐기
					if(!Ext.isEmpty(record.get('ORDER_NUM'))) {
						Unilite.messageBox('<t:message code="system.message.sales.message047" default="출고유형[폐기]는 예외 출고등록만 가능합니다."/>');
						record.set('INOUT_TYPE_DETAIL',oldValue);
						record.set('REF_CODE2',gsOldRefCode2);
						break;
					}
				}

				if(newValue == '') {
					record.set('ACCOUNT_YNC','N');
				} else {
					if(!Ext.isEmpty(record.get('ORDER_NUM'))) {
						UniAppManager.app.fnAccountYN(record, newValue);
					}
				}
				break;

			case 'ISSUE_DIV_CODE':
				if(newValue != oldValue) {
					record.set('WH_CODE'			, '');
					record.set('STOCK_Q'			, 0);
				}
				break;

			case 'WH_CODE':			//출고창고
				UniSales.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('ISSUE_DIV_CODE'), null, record.get('ITEM_CODE'),  newValue);
				break;

			case "ORDER_UNIT" :
				if(Ext.isEmpty(record.get('CUSTOM_NAME'))) {
					Unilite.messageBox('<t:message code="system.message.sales.message048" default="객을 먼저 선택하셔야 합니다."/>');
					break;
				}
				UniSales.fnGetPriceInfo2( record
										, UniAppManager.app.cbGetPriceInfo
										, 'I'
										, UserInfo.compCode
										, record.get('CUSTOM_CODE')
										, record.get('REF_AGENT_TYPE')
										, record.get('ITEM_CODE')
										, record.get('MONEY_UNIT')
										, record.get('ORDER_UNIT')
										, record.get('STOCK_UNIT')
										, record.get('TRANS_RATE')
										, UniDate.getDbDateStr(record.get('ISSUE_REQ_DATE'))
										, record.get('ISSUE_REQ_QTY')
										, record.get('WGT_UNIT')
										, record.get('VOL_UNIT')
				);
				break;

			case "TRANS_RATE" :
				if(newValue <= 0) {
					rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
					record.set('TRANS_RATE',oldValue);
					break
				}
				if(Ext.isEmpty(record.get('CUSTOM_NAME'))) {
					Unilite.messageBox('<t:message code="system.message.sales.message048" default="고객을 먼저 선택하셔야 합니다."/>');
					break;
				}
				UniSales.fnGetPriceInfo2( record
										, 'I'
										, UserInfo.compCode
										, masterForm.getValue('CUSTOM_CODE')
										, record.get('AGENT_TYPE')
										, record.get('ITEM_CODE')
										, record.get('MONEY_UNIT')
										, record.get('ORDER_UNIT')
										, record.get('STOCK_UNIT')
										, record.get('TRANS_RATE')
										, UniDate.getDbDateStr(record.get('ISSUE_REQ_DATE'))
										, record.get('ORDER_Q')
										, record.get('WGT_UNIT')
										, record.get('VOL_UNIT')
				)
				break;

			case 'ISSUE_REQ_QTY' : 			//출하지시량
				//출하지시량
				var dIssueReqQ = Unilite.nvl(newValue, 0);
				//출고량
				var dOutStockQ = Unilite.nvl(record.get('ISSUE_QTY'), 0);
				/*issueLinkBtn 존재하지 않음(주석) - 20170516
				if(dIssueReqQ-dOutStockQ > 0 ) {
					detailGrid.down('#issueLinkBtn').disable(false);
				} else {
					detailGrid.down('#issueLinkBtn').disable(true);
				}*/
				if(!record.phantom) {
					if(dOutStockQ > 0) {
						Unilite.messageBox('<t:message code="system.message.sales.message049" default="출고가 발생한 건은 수정/삭제할 수 없습니다."/>');
						break;
					}
				}
				//수주참조일 때,
				if(!Ext.isEmpty(record.get('ORDER_NUM'))) {
					//미납량(출하가능량)
					dCanOutQ = Unilite.nvl(record.get('NOTOUT_Q'), 0);
					if(record.phantom) {
						if(dIssueReqQ > dCanOutQ) {
							Unilite.messageBox('<t:message code="system.message.sales.message050" default="출하지시량이 출고가능수량을 초과했습니다."/>');
						break;
						}
					}
				}

				//출하지시량(중량) 재계산
				var sUnitWgt	= record.get('UNIT_WGT');
				var sOrderWgtQ = dIssueReqQ * sUnitWgt;
				record.set('ISSUE_WGT_Q', sOrderWgtQ);

				//출하지시량(부피) 재계산
				var sUnitVol	= record.get('UNIT_VOL');
				var sOrderVolQ = dIssueReqQ * sUnitVol
				record.set('ISSUE_VOL_Q', sOrderVolQ);

				UniAppManager.app.fnOrderAmtCal(record, "Q", fieldName, newValue);
				break;

			case 'ISSUE_REQ_PRICE':
				record.set('ISSUE_FOR_PRICE', UniSales.fnExchangeApply2(record.get('MONEY_UNIT'), newValue / record.get('EXCHANGE_RATE')));	//20200611 수정: 외화금액 계산시, 'JPY' 관련로직 추가(UniSales.fnExchangeApply2 추가)
				UniAppManager.app.fnOrderAmtCal(record, "P", fieldName, newValue);
				break;

			case 'ISSUE_REQ_AMT':
				UniAppManager.app.fnOrderAmtCal(record, "O", fieldName, newValue);
				break;

			case 'TAX_TYPE':	 //과세구분
				if(newValue == '2') {
					record.set('ISSUE_REQ_TAX_AMT', 0);
				}
				record.set('TAX_TYPE', newValue);
				UniAppManager.app.fnOrderAmtCal(record, 'O', fieldName, newValue);
				break;

			case 'ISSUE_REQ_TAX_AMT':	//세액
				if(! UniAppManager.app.fnCheckNum(newValue, record, fieldName)) {
					record.set('ISSUE_REQ_TAX_AMT', oldValue);
					break;
				}
				break;

			case 'ISSUE_DATE':  // 출고요청일
				if(Ext.isEmpty(newValue)) {
					record.set('ISSUE_DATE', oldValue);
					break;
				}
				var shipDate = UniDate.getDbDateStr(record.get('ISSUE_REQ_DATE'));
				if(shipDate > newValue) {
					Unilite.messageBox('<t:message code="system.message.sales.message007" default="출고예정일은 출하지시일과 같거나 이후이어야 합니다"/>');
					record.set('ISSUE_DATE', oldValue);
					break;
				}
				if(record.get('ISSUE_REQ_METH')== '1') {
					if(record.get('DVRY_DATE') >= shipDate && record.get('DVRY_DATE') < record.get('ISSUE_DATE')) {
						if(!confirm('<t:message code="system.message.sales.message006" default="출고예정일은 납기일보다 이전이어야 합니다."/>' + '\n'
							+ '<t:message code="system.label.sales.seq" default="순번"/>'+':'+record.get('ISSUE_REQ_SEQ') + '\n'
							+ '<t:message code="system.label.sales.issueresevationdate" default="출고예정일"/>:'+record.get('ISSUE_DATE') + '\n'
							+ '<t:message code="system.label.sales.deliverydate" default="납기일"/>' )
						 ) {
							record.set('ISSUE_DATE', oldValue);
							break;
						}
					}
				}
				break;

			case 'ACCOUNT_YNC':
				if(!record.phantom && !Ext.isEmpty(record.get('PRE_ACCNT_YN'))) {
					if(confirm(''+'<t:message code="system.message.sales.message042" default="수주내역의 매출대상이 변경되었습니다."/>'+ '<t:message code="system.message.sales.message051" default="참조된 수불내역에 반영하시겠습니까?"/>')) {
						record.set('REF_FLAG', newValue);
					} else {
						record.set('REF_FLAG', 'F');
					}
				}
				break;

			case 'DISCOUNT_RATE':
				if(! UniAppManager.app.fnCheckNum(newValue, record, fieldName)) {
					record.set('DISCOUNT_RATE', oldValue);
					break;
				}
				UniSales.fnGetPriceInfo2(
					record
					, UniAppManager.app.cbGetPriceInfoR
					, 'I'
					, UserInfo.compCode
					, record.get('CUSTOM_CODE')
					, record.get('REF_AGENT_TYPE')
					, record.get('ITEM_CODE')
					, record.get('MONEY_UNIT')
					, record.get('ORDER_UNIT')
					, record.get('STOCK_UNIT')
					, record.get('TRANS_RATE')
					, UniDate.getDbDateStr(record.get('ISSUE_REQ_DATE'))
					, record.get('ISSUE_REQ_QTY')
					, record['WGT_UNIT']
					, record['VOL_UNIT']
				)
				break;
			}
			return rv;
		}
	});
}
</script>