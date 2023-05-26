<%--
'	프로그램명 : 출하지시등록 (바코드)
'	작  성  자 : (주)포렌 개발실
'	작  성  일 :
'	최종수정자 :
'	최종수정일 :
'	버	전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_srq110ukrv_in"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_srq110ukrv_in"  />			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" />						<!-- 수불담당 -->
	<t:ExtComboStore comboType="OU" />										<!--창고-->
	<t:ExtComboStore comboType="OU" storeId="ouChkCombo"/>					<!--창고-->
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
	<t:ExtComboStore comboType="AU" comboCode="S024" />						<!--부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S002" />						<!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5' />			<!--생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="T008" />
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!-- 창고Cell-->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>

<script type="text/javascript">
var searchInfoWindow;	//searchInfoWindow : 조회창
var referWindow;	//참조내역
var referSCMWindow;
var searchGBN = '2';
var alertWindow ;
var saveChk = 'N';
var addChk ='N';

var BsaCodeInfo = {
	gsAutoType		: '${gsAutoType}',
	gsAutoType		: '${gsAutoType}',
	gsMoneyUnit		: '${gsMoneyUnit}',
	gsVatRate		: '${gsVatRate}',
	gsOutType		: '${grsOutType}',
	gsCredit		: '${gsCredit}',
	gsPrintPgID		: '${gsPrintPgID}',
	gsSrq100UkrLink	: '${gsSrq100UkrLink}',
	gsStr100UkrLink	: '${gsStr100UkrLink}',
	gsTimeYN1		: '${gsTimeYN1}',
	gsTimeYN2		: '${gsTimeYN2}',
	gsCreditYn		: '${gsCreditYn}',
	gsBoxQYn		: '${gsBoxQYn}',
	gsMiniPackQYn	: '${gsMiniPackQYn}',
	gsPointYn		: '${gsPointYn}',
	gsPriceGubun	: '${gsPriceGubun}',
	gsWeight		: '${gsWeight}',
	gsVolume		: '${gsVolume}',
	gsUnitChack		: '${gsUnitChack}',
	gsStatusM		: 'N',
	gsReportGubun	: '${gsReportGubun}'
};

var CustomCodeInfo = {
	gsAgentType		: '',
	gsUnderCalBase	: ''
};

var outDivCode = UserInfo.divCode;

function appMain() {
	/** 자동채번 여부
	 */
	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoOrderNum = true;
	}

	/** 수주의 마스터 정보를 가지고 있는 Form
	 */
	var masterForm = Unilite.createSearchForm('masterForm',{
//		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items :[{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype:'uniCombobox',
				comboType:'BOR120',
				value:UserInfo.divCode,
				allowBlank:false,
				holdable: 'hold',
				listeners	: {
					 change: function(combo, newValue, oldValue, eOpts) {
						masterForm.setValue('WH_CODE', '');
					 }
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>',
				name: 'SHIP_DATE',
				xtype:'uniDatefield',
				value: UniDate.get('today'),
				allowBlank:false,
				holdable: 'hold'
			}, {
				fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
				startFieldName: 'DELIVERY_DATE_FR',
				endFieldName: 'DELIVERY_DATE_TO',
				xtype: 'uniDateRangefield',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {

				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {

				}
			},/* {
				margin: '0 0 0 0',
				xtype: 'button',
				text: '출고등록',
				itemId:'btnIssueLink',
				width:120,
				tdAttrs:{'align':'right', width:'25%'},
				handler: function() {
					var params = {
						'ISSUE_REQ_NUM'	: masterForm.getValue('ISSUE_REQ_NUM')
					}
					//전송
					var rec1 = {data : {prgID : 'str100Ukr', 'text':''}};				//BsaCodeInfo.gsStr100UkrLink
					parent.openTab(rec1, '/sales/str100ukrv.do', params);
				}
			},*/{
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name: 'SHIP_PRSN',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'S010',
				hidden: true,
				//allowBlank:false,
				holdable: 'hold'
			}, {
				fieldLabel: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'	,
				name: 'ISSUE_REQ_NUM',
				readOnly:isAutoOrderNum,
				allowBlank:isAutoOrderNum,
				holdable: (isAutoOrderNum === true ? 'readOnly':'hold')
			},{
				xtype: 'container',
				layout: { type: 'uniTable', columns: 2},
				defaultType: 'uniTextfield',
				defaults : {enforceMaxLength: true},
				colspan:2,
				items:[{
							fieldLabel	: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
							name		: 'WH_CODE',
							xtype		: 'uniCombobox',
							comboType	: 'OU',
							allowBlank:false,
							listeners	: {
								change: function(combo, newValue, oldValue, eOpts) {
								},
								beforequery:function( queryPlan, eOpts )	{
										var store = queryPlan.combo.store;
										store.clearFilter();
										if(!Ext.isEmpty(masterForm.getValue('DIV_CODE'))){
										 store.filterBy(function(record){
											 return record.get('option') == masterForm.getValue('DIV_CODE');
										})
									}else{
										store.filterBy(function(record){
											return false;
									})
									}
								}
							}
						},
						Unilite.popup('AGENT_CUST',{
							fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
							holdable: 'hold',
							validateBlank: false,
							listeners: {
								onSelected: {
									fn: function(records, type) {
										console.log('records : ', records);
										CustomCodeInfo.gsAgentType	= records[0]["AGENT_TYPE"];
										CustomCodeInfo.gsCustCrYn	 = records[0]["CREDIT_YN"];
										CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
									},
									scope: this
								},
								onClear: function(type) {
									CustomCodeInfo.gsAgentType	= '';
									CustomCodeInfo.gsCustCrYn	 = '';
									CustomCodeInfo.gsUnderCalBase = '';
								}/*,
								onValueFieldChange: function(field, newValue){
									masterForm.setValue('CUSTOM_CODE', newValue);
								},
								onTextFieldChange: function(field, newValue){
									masterForm.setValue('CUSTOM_NAME', newValue);
								}*/
							}
						})
					]
			},{
				fieldLabel  : '<t:message code="system.label.sales.barcode" default="바코드"/>',
				name		: 'BARCODE',
				xtype		: 'uniTextfield',
				readOnly	: false,
				fieldStyle  : 'IME-MODE: inactive',			 //IE에서만 적용 됨
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {

					},
					specialkey:function(field, event)	{
						if(event.getKey() == event.ENTER) {
							if(!masterForm.getInvalidMessage()) return;	//필수체크

							var newValue = masterForm.getValue('BARCODE');
							if(!Ext.isEmpty(newValue)) {
								// masterGrid.focus();
								fnEnterBarcode(newValue);
							//  masterForm.setValue('BARCODE', '');
								masterForm.getField('ITEM_BARCODE').focus();
							}
						}
					},afterrender: function(field) {
						field.focus(true);
					}
				}
			},{
				fieldLabel  : '<t:message code="system.label.sales.itembarcode" default="품목바코드"/>',
				name		: 'ITEM_BARCODE',
				xtype		: 'uniTextfield',
				readOnly	: false,
				fieldStyle  : 'IME-MODE: inactive',			 //IE에서만 적용 됨
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					},
					specialkey:function(field, event)	{
						if(event.getKey() == event.ENTER) {
							if(!masterForm.getInvalidMessage()) return;	//필수체크

							var newValue = masterForm.getValue('ITEM_BARCODE');
							if(!Ext.isEmpty(newValue)) {
								fnEnterItemBarcode(newValue);
								masterForm.setValue('ITEM_BARCODE', '');
								masterForm.getField('ITEM_BARCODE').focus();
							}
						}
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name: 'ORDER_TYPE',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'S002',
				value: '10'
			}],
		listeners: {
			//20170518 - 폼변경시 저장버튼 활성화 되는 로직 없음 : 주석 처리
//			uniOnChange: function(basicForm, dirty, eOpts) {
//				UniAppManager.setToolbarButtons('save', true);
//			}
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=true;
			me.setValue('DIV_CODE', 		Unilite.nvl(record.get('DIV_CODE'), UserInfo.divCode			) );
			me.setValue('SHIP_DATE',		record.get('ISSUE_REQ_DATE'));
//			me.setValue('EXPEC_SHIP_DATE',	record.get('ISSUE_DATE'));
			me.setValue('SHIP_PRSN',		record.get('ISSUE_REQ_PRSN'));
			me.setValue('ISSUE_REQ_NUM',			record.get('ISSUE_REQ_NUM'));
//			me.setValue('ORDER_TYPE',		record.get('ORDER_TYPE'));
//			me.setValue('EXCHAGE_RATE',		record.get('EXCHANGE_RATE'));
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
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

						alert(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
	}); //End of var masterForm = Unilite.createForm('srq101ukrvMasterForm', {

	/**
	 * 수주의 디테일 정보를 가지고 있는 Grid
	 */
	//마스터 모델 정의
	Unilite.defineModel('s_srq110ukrv_inDetailModel', {
		fields: [
			{name: 'DIV_CODE'			, text:'<t:message code="system.label.sales.division" default="사업장"/>'						, type: 'string', 	defaultValue: UserInfo.divCode},
			{name: 'ISSUE_REQ_METH'		, text:'<t:message code="system.label.sales.shipmentordermethod" default="출하지시방법"/>'		, type: 'string', defaultValue: '2'},
			{name: 'ISSUE_REQ_PRSN'		, text:'<t:message code="system.label.sales.shipmentordercharger" default="출하지시담당자"/>'		, type: 'string', comboType: 'AU', comboCode: 'S010'},
			{name: 'ISSUE_REQ_DATE'		, text:'<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'			, type: 'uniDate'},
			{name: 'ISSUE_REQ_NUM'		, text:'<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'			, type: 'string'},
			{name: 'ISSUE_REQ_SEQ'		, text:'<t:message code="system.label.sales.seq" default="순번"/>'							, type: 'int', allowBlank: false , editable:false},
			{name: 'CUSTOM_CODE'		, text:'<t:message code="system.label.sales.client" default="고객"/>'							, type: 'string', allowBlank:true},
			{name: 'CUSTOM_NAME'		, text:'<t:message code="system.label.sales.client" default="고객"/>'							, type: 'string', allowBlank:true},
			{name: 'BILL_TYPE'			, text:'<t:message code="system.label.sales.vattype" default="부가세유형"/>'						, type: 'string' , comboType: 'AU', comboCode: 'S024', allowBlank:true},
			{name: 'ORDER_TYPE'			, text:'<t:message code="system.label.sales.sellingtype" default="판매유형"/>'					, type: 'string' , comboType: 'AU', comboCode: 'S002', allowBlank:true},
			{name: 'INOUT_TYPE_DETAIL'	, text:'<t:message code="system.label.sales.issuetype" default="출고유형"/>'					, type: 'string' , comboType: 'AU', comboCode: 'S007', allowBlank:true},
			{name: 'ISSUE_DIV_CODE'		, text:'<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'				, type: 'string' , comboType: 'BOR120', child:'WH_CODE', allowBlank:true},
			{name: 'WH_CODE'			, text:'<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'				, type: 'string' , comboType: 'OU', allowBlank:true},
			{name: 'ITEM_CODE'			, text:'<t:message code="system.label.sales.item" default="품목"/>'							, type: 'string', allowBlank:true},
			{name: 'ITEM_NAME'			, text:'<t:message code="system.label.sales.itemname" default="품목명"/>'						, type: 'string', allowBlank:true},
			{name: 'SPEC'				, text:'<t:message code="system.label.sales.spec" default="규격"/>'							, type: 'string'},
			{name: 'ORDER_UNIT'			, text:'<t:message code="system.label.sales.unit" default="단위"/>'							, type: 'string' , comboType: 'AU', comboCode: 'B013', allowBlank:true, displayField: 'value'},
			{name: 'PRICE_TYPE'			, text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'					, type: 'string' , comboType: 'AU', comboCode: 'B116', defaultValue:BsaCodeInfo.gsPriceGubun},
			{name: 'TRANS_RATE'			, text:'<t:message code="system.label.sales.containedqty" default="입수"/>'					, type: 'uniQty', defaultValue:1, allowBlank:true},
			{name: 'STOCK_Q'			, text:'<t:message code="system.label.sales.inventoryqty" default="재고량"/>'					, type: 'uniQty'},
			{name: 'ISSUE_REQ_QTY'		, text:'<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'			, type: 'uniQty', defaultValue:0, allowBlank:true},
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
			{name: 'TAX_TYPE'			, text:'<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'				, type: 'string', comboType: 'AU', comboCode: 'B059', allowBlank:true},
			{name: 'ISSUE_REQ_TAX_AMT'	, text:'<t:message code="system.label.sales.taxamount" default="세액"/>'						, type: 'uniPrice', defaultValue:0},
			{name: 'WGT_UNIT'			, text:'<t:message code="system.label.sales.weightunit" default="중량단위"/>'					, type: 'string', comboType: 'AU', comboCode: 'B013', defaultValue:BsaCodeInfo.gsWeight, displayField: 'value'},
			{name: 'UNIT_WGT'			, text:'<t:message code="system.label.sales.unitweight" default="단위중량"/>'					, type: 'int', comboType: 'AU', comboCode: 'B013', displayField: 'value'},
			{name: 'VOL_UNIT'			, text:'<t:message code="system.label.sales.volumnunit" default="부피단위"/>'					, type: 'string', defaultValue:BsaCodeInfo.gsVolume},
			{name: 'UNIT_VOL'			, text:'<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'					, type: 'int'},
			{name: 'ISSUE_DATE'			, text:'<t:message code="system.label.sales.issuedate" default="출고일"/>'						, type: 'uniDate', allowBlank:true},
			{name: 'DELIVERY_TIME'		, text:'<t:message code="system.label.sales.deliverytime" default="납기시간"/>'					, type: 'uniTime'},
			{name: 'DISCOUNT_RATE'		, text:'<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'				, type: 'uniER', defaultValue:0},
			{name: 'LOT_NO'				, text:'<t:message code="system.label.sales.lotno" default="LOT번호"/>'						, type: 'string'},
			{name: 'PRICE_YN'			, text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'					, type: 'string', comboType: 'AU', comboCode: 'S003', defaultValue:'2', allowBlank:true},
			{name: 'SALE_CUSTOM_CODE'	, text:'<t:message code="system.label.sales.salesplace" default="매출처"/>'					, type: 'string', allowBlank:true},
			{name: 'SALE_CUSTOM_NAME'	, text:'<t:message code="system.label.sales.salesplace" default="매출처"/>'					, type: 'string', allowBlank:true},
			{name: 'ACCOUNT_YNC'		, text:'<t:message code="system.label.sales.salessubject" default="매출대상"/>'					, type: 'string', comboType: 'AU', comboCode: 'S014', allowBlank:true},
			{name: 'DVRY_CUST_CD'		, text:'<t:message code="system.label.sales.deliveryplace" default="배송처"/>'					, type: 'string'},
			{name: 'DVRY_CUST_NAME'		, text:'<t:message code="system.label.sales.deliveryplace" default="배송처"/>'					, type: 'string'},
			{name: 'PROJECT_NO'			, text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'					, type: 'string'},
			{name: 'PO_NUM'				, text:'<t:message code="system.label.sales.pono2" default="P/O 번호"/>'						, type: 'string'},
			{name: 'PO_SEQ'				, text:'<t:message code="system.label.sales.poseq2" default="P/O 순번"/>'						, type: 'int'},
			{name: 'ORDER_NUM'			, text:'<t:message code="system.label.sales.sono" default="수주번호"/>'							, type: 'string'},
			{name: 'SER_NO'				, text:'<t:message code="system.label.sales.soseq" default="수주순번"/>'						, type: 'int'},
			{name: 'DEPT_CODE'			, text:'<t:message code="system.label.sales.shipmentorderdepartment" default="출하지시부서"/>'	, type: 'string', defaltValue:'*'},
			{name: 'TREE_NAME'			, text:'<t:message code="system.label.sales.departmentname" default="부서명"/>'				, type: 'string', defaultValue:'N'},
			{name: 'MONEY_UNIT'			, text:'<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'					, type: 'string', defaultValue:BsaCodeInfo.gsMoneyUnit,displayField: 'value'},
			{name: 'EXCHANGE_RATE'		, text:'<t:message code="system.label.sales.exchangerate" default="환율"/>'					, type: 'uniER', defaultValue:1},
			{name: 'ISSUE_QTY'			, text:'<t:message code="system.label.sales.issueqty" default="출고량"/>'						, type: 'uniQty', defaultValue:0},
			{name: 'RETURN_Q'			, text:'<t:message code="system.label.sales.returnqty" default="반품량"/>'						, type: 'uniQty'},
			{name: 'ORDER_Q'			, text:'<t:message code="system.label.sales.soqty" default="수주량"/>'							, type: 'uniQty'},
			{name: 'ISSUE_REQ_Q'		, text:'<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'			, type: 'uniQty'},
			{name: 'DVRY_DATE'			, text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'					, type: 'uniDate'},
			{name: 'DVRY_TIME'			, text:'<t:message code="system.label.sales.deliverytime" default="납기시간"/>'					, type: 'uniTime'},
			{name: 'TAX_INOUT'			, text:'<t:message code="system.label.sales.taxtype" default="세구분"/>'						, type: 'string'},
			{name: 'STOCK_UNIT'			, text:'<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'				, type: 'string'},
			{name: 'PRE_ACCNT_YN'		, text:'<t:message code="system.label.sales.salessubject" default="매출대상"/>'					, type: 'string', defaultValue:'Y'},
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
			{name: 'ROW_CHECK'			, text:'ROW_CHECK'			, type: 'string'},
			//20200519 추가: 비고(출하, OUT_REMARK),WH_CELL_CODE
			{name: 'OUT_REMARK'			, text: '비고(출하)'			,type: 'string'},
			{name: 'WH_CELL_CODE'		, text: '출고창고CELL'			,type: 'string'	, editable: false, store: Ext.data.StoreManager.lookup('whCellList')}
		]
	});

	// Direct Proxy 정의
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_srq110ukrv_inService.selectList',
			update	: 's_srq110ukrv_inService.updateDetail',
			create	: 's_srq110ukrv_inService.insertDetail',
			destroy	: 's_srq110ukrv_inService.deleteDetail',
			syncAll	: 's_srq110ukrv_inService.saveAll'
		}
	});

	//마스터 스토어 정의
	var detailStore = Unilite.createStore('s_srq110ukrv_inDetailStore', {
		model: 's_srq110ukrv_inDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= masterForm.getValues();
			param.GBN = searchGBN;
			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
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
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var isErr = false;
			var shipNum = masterForm.getValue('ISSUE_REQ_NUM');
			var shipDate = UniDate.getDbDateStr(masterForm.getValue('SHIP_DATE'));
			var shipPrsn = masterForm.getValue('SHIP_PRSN');

			Ext.each(list, function(record, index) {
				record.set('ISSUE_REQ_NUM', shipNum);
				record.set('ISSUE_REQ_DATE', shipDate);
				record.set('ISSUE_REQ_PRSN', shipPrsn);
				record.set('AMEND_YN', 'N');
				record.set('REF_FLAG', 'F');
				if(Ext.isEmpty(record.get('CUSTOM_CODE')) || Ext.isEmpty(record.get('CUSTOM_NAME'))){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '고객: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				if(Ext.isEmpty(record.get('ITEM_CODE')) || Ext.isEmpty(record.get('ITEM_NAME'))){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '품목: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				if(Ext.isEmpty(record.get('ORDER_UNIT'))){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '단위: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				if(record.get('TRANS_RATE') == 0){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '입수: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				if(record.get('ISSUE_REQ_QTY') == 0){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '출하지시량: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				if(Ext.isEmpty(record.get('WH_CODE'))){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '출고창고: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				if(Ext.isEmpty(record.get('TAX_TYPE'))){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '과세구분: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				if(Ext.isEmpty(record.get('ISSUE_DATE'))){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '출고일: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				if(Ext.isEmpty(record.get('BILL_TYPE'))){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '부가세유형: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				if(Ext.isEmpty(record.get('ORDER_TYPE'))){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '판매유형: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				if(Ext.isEmpty(record.get('INOUT_TYPE_DETAIL'))){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '출고유형: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				if(Ext.isEmpty(record.get('ISSUE_DIV_CODE'))){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '출고사업장: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				if(Ext.isEmpty(record.get('PRICE_YN'))){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '단가구분: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				if(Ext.isEmpty(record.get('SALE_CUSTOM_CODE')) || Ext.isEmpty(record.get('SALE_CUSTOM_NAME'))){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '매출처: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				if(Ext.isEmpty(record.get('ACCOUNT_YNC'))){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '매출대상: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
				if(record.get('ISSUE_REQ_METH') == '1' ) {
					if( record.get('DVRY_DATE') >= shipDate ) {
						if( record.get('DVRY_DATE') < record.get('ISSUE_DATE')) {
							if(!confirm('<t:message code="system.message.sales.message006" default="출고예정일은 납기일보다 이전이어야 합니다."/>' + '\n'
								+ '<t:message code="system.label.sales.seq" default="순번"/>'+':'+record.get('ISSUE_REQ_SEQ') + '\n'
								+ '<t:message code="system.label.sales.issueresevationdate" default="출고예정일"/>:'+record.get('ISSUE_DATE') + '\n'
								+ '<t:message code="system.label.sales.deliverydate" default="납기일"/>'+':'+record.get('DVRY_DATE') + '\n'
								+ /* Msg.sMS419  +*/ '\n'
								+ '<t:message code="system.message.sales.confirm003" default="진행하시겠습니까?"/>')
							) {
//								inValidRecs = [].concat(inValidRecs, [record])
								isErr = true;
								return false;
							}
						}
					}else {
						if(!confirm('<t:message code="system.message.sales.message045" default="출하지시일은 납기일보다 이전이어야 합니다."/>' + '\n'
							+ '<t:message code="system.label.sales.seq" default="순번"/>'+':'+record.get('ISSUE_REQ_SEQ') + '\n'
							+ '<t:message code="system.label.sales.issueresevationdate" default="출고예정일"/>:' + shipDate + ',' + '<t:message code="system.label.sales.deliverydate" default="납기일"/>' +':' +record.get('DVRY_DATE')
							+ /* Msg.sMS419  +*/ '\n'
							+ '<t:message code="system.message.sales.confirm003" default="진행하시겠습니까?"/>')
						) {
//							inValidRecs = [].concat(inValidRecs, [record])
							isErr = true;
							return false;
						}
					}
				}
			})

			if(isErr){
				return false;
			}
			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
					config = {
						params: [paramMaster],
						success: function(batch, option) {
							//2.마스터 정보(Server 측 처리 시 가공)
							var master = batch.operations[0].getResultSet();
							//masterForm.setValue("ISSUE_REQ_NUM", master.ISSUE_REQ_NUM);

							//3.기타 처리
							masterForm.getForm().wasDirty = false;
							masterForm.resetDirtyStatus();
							console.log("set was dirty to false");
							detailGrid.deleteSelectedRow();
							//UniAppManager.app.onResetButtonDown();
							var  detailStoreRecords =  detailStore.data.items;
							Ext.each(detailStoreRecords, function(record,i) {
								if(detailGrid.getSelectionModel().isSelected(record) == true){
									record.set('ROW_CHECK','N');
									detailGrid.getSelectionModel().deselect(i);
								}
							})

							masterForm.setValue('CUSTOM_CODE', '');
							masterForm.setValue('CUSTOM_NAME', '');
							masterForm.setValue('BARCODE', '');
							masterForm.setValue('ITEM_BARCODE', '');
							detailStore.commitChanges();
						}
					};
				this.syncAllDirect(config);
			} else {
				/* var grid = Ext.getCmp('s_srq110ukrv_inGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs); */
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if (searchGBN =='1' && records.length>0){
					masterForm.setLoadRecord(records[0]);
				}
				searchGBN = '2';
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {

			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	//마스터 그리드 정의
	var detailGrid = Unilite.createGrid('s_srq110ukrv_inGrid', {
		layout: 'fit',
		region:'center',
		selModel:	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ) {
					selectRecord.set('ROW_CHECK', 'Y');
				},
				deselect:  function(grid, selectRecord, index, rowIndex, eOpts ) {
					selectRecord.set('ROW_CHECK', 'N');
				}
			}
		}),
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
			onLoadSelectFirst: false
		},
		store: detailStore,
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',	showSummaryRow: true} ],
		columns: [
			{dataIndex: 'DIV_CODE'			, width: 66, hidden: true },
			{dataIndex: 'ISSUE_REQ_METH'	, width: 66, hidden: true },
			{dataIndex: 'ISSUE_REQ_PRSN'	, width: 66, hidden: true },
			{dataIndex: 'ISSUE_REQ_DATE'	, width: 66, hidden: true },
			{dataIndex: 'ISSUE_REQ_NUM'		, width: 66, hidden: true },
			{dataIndex: 'ISSUE_REQ_SEQ'		, width: 40,align: 'center' },
			{dataIndex: 'CUSTOM_CODE'		, width: 80, hidden: true },
			{dataIndex: 'CUSTOM_NAME'		, width: 133 ,
				editor: Unilite.popup('CUST_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = Ext.getCmp('s_srq110ukrv_inGrid').uniOpt.currentRecord;
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
									,UniDate.getDbDateStr(masterForm.getValue('SHIP_DATE'))
									,grdRecord.get('ISSUE_REQ_QTY')
									,grdRecord['WGT_UNIT']
									,grdRecord['VOL_UNIT']
								)
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = Ext.getCmp('s_srq110ukrv_inGrid').uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							grdRecord.set('SALE_CUSTOM_CODE','');
							grdRecord.set('SALE_CUSTOM_NAME','');
						}
					}
				})
			},
//				{dataIndex: 'BILL_TYPE'			, width: 80,align: 'center' },
//				{dataIndex: 'ORDER_TYPE'		, width: 90,align: 'center' },
//				{dataIndex: 'INOUT_TYPE_DETAIL'	, width: 80,align: 'center' },
//				{dataIndex: 'ISSUE_DIV_CODE'	, width: 90,align: 'center' },
//				{dataIndex: 'WH_CODE'			, width: 100 },
			{dataIndex: 'ITEM_CODE'			, width: 120,
				 editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
									console.log('records : ', records);
									Ext.each(records, function(record,i) {
														console.log('record',record);
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
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 133,
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
						}
					}
				})
			},
			{dataIndex: 'SPEC'				, width: 133 },
			{dataIndex: 'LOT_NO'			, width: 100,
				editor: Unilite.popup('LOT_MULTI_IN_G', {
					autoPopup: true,
					validateBlank:false,
					textFieldName: 'LOTNO_CODE',
					DBtextFieldName: 'LOTNO_CODE',
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = detailGrid.uniOpt.currentRecord;
								var currentRowIndex = detailGrid.getStore().indexOf(grdRecord);
								var currentRowIndexOri = detailGrid.getStore().indexOf(grdRecord);
								var rowIdxArray = [];
								rowIdxArray.push(currentRowIndexOri);
								var rtnRecord;
								data = new Object();
								data.records = [];
								var records2 = detailStore.data.items;
								 Ext.each(records2, function(record, i){
									 if( detailGrid.getSelectionModel().isSelected(record) == true){
											data.records.push(record);
									}
								 });
								Ext.each(records, function(record,i) {
									if(i==0){
										rtnRecord = grdRecord;
									}else{
										if(i==1){
											UniAppManager.app.onNewDataButtonDown(currentRowIndex);
											currentRowIndex = currentRowIndex + 1
											rowIdxArray.push(currentRowIndex);

										}else{
											UniAppManager.app.onNewDataButtonDown(currentRowIndex);
											currentRowIndex = currentRowIndex + 1
											rowIdxArray.push(currentRowIndex);
										}
										rtnRecord		= detailGrid.getSelectedRecord()
										var columns		= detailGrid.getColumns();
										Ext.each(columns, function(column, index) {
											if(column.dataIndex != 'ISSUE_REQ_SEQ' && column.dataIndex != 'ISSUE_REQ_QTY' && column.dataIndex != 'ISSUE_REQ_AMT' && column.dataIndex != 'ISSUE_FOR_AMT') {
												rtnRecord.set(column.initialConfig.dataIndex, grdRecord.get(column.initialConfig.dataIndex));
												rtnRecord.set('ROW_CHECK', 'Y');
											}
										});
									}

									var lotStockQ	= record['GOOD_STOCK_Q'];
									var issueReqQty		= rtnRecord.get('ISSUE_REQ_QTY');
									if (lotStockQ < issueReqQty || issueReqQty == 0) {
										issueReqQty = lotStockQ
									}

									rtnRecord.set('LOT_NO'			, record['LOT_NO']);

									var ouComboStore = 	Ext.data.StoreManager.lookup('ouChkCombo');//사용중인 창고 정보 스토어
									Ext.each(ouComboStore.data.items, function(comboData, idx) {//lotno팝업에서 선택한 창고가 사용중인 창고이면 선택한 창고로 세팅
										if(comboData.get('value') == record['WH_CODE']){
											rtnRecord.set('WH_CODE'		, record['WH_CODE']);
											//20200519 추가: WH_CELL_CODE
											rtnRecord.set('WH_CELL_CODE', record['WH_CELL_CODE']);
										}
									});
									rtnRecord.set('INOUT_Q'			, issueReqQty);
								});

								Ext.each(records2, function(record, i){
									for(var j=0; j < rowIdxArray.length; j++){
										if(i == rowIdxArray[j]){
											data.records.push(record);
										}
									}
								 });
								 detailGrid.getSelectionModel().select(data.records);
								//detailGrid.getNavigationModel().setPosition(5, detailStore.getCount()-1);//lotno 컬럼이 뒤쪽에 있어 lotno입력 후 수량 입력 편하게 스크롤바 이동
							},
							scope: this
						},
						'onClear': function(type) {
							var record1 = detailGrid.getSelectedRecord();
							//record1.set('LOT_NO'		, '');
							//20200519 추가: 초기화 로직 추가
							record1.set('WH_CODE'		, '');
							record1.set('WH_CELL_CODE'	, '');
						},
						applyextparam: function(popup){
							var record		= detailGrid.uniOpt.currentRecord;
							var divCode		= masterForm.getValue('DIV_CODE');
							var itemCode	= record.get('ITEM_CODE');
							var itemName	= record.get('ITEM_NAME');
							var whCode		= record.get('WH_CODE');
							popup.setExtParam({SELMODEL: 'MULTI', 'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode});
						}
					}
				})
			},
			{dataIndex: 'ORDER_UNIT'		, width: 66, align: 'center',
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'PRICE_TYPE'		, width: 66, hidden: true },
			{dataIndex: 'TRANS_RATE'		, width: 53 },
			{dataIndex: 'ISSUE_REQ_QTY'		, width: 106, summaryType: 'sum' },
			//20200519 추가: 비고(출하), 
			{dataIndex: 'OUT_REMARK'		, width: 110 },
			{dataIndex: 'STOCK_Q'			, width: 120, summaryType: 'sum' },
			{dataIndex: 'WH_CODE'			, width: 150 },
			//20200519 추가: WH_CELL_CODE
			{dataIndex: 'WH_CELL_CODE'		, width: 130 , hidden: false,
//				listeners:{
//					render:function(elm) {
//						elm.editor.on('beforequery',function(queryPlan, eOpts) {
//							var store = queryPlan.combo.store;
//							var record = detailGrid.uniOpt.currentRecord;
//							store.clearFilter();
//							store.filterBy(function(item){
//								return item.get('option') == record.get('WH_CODE')
//							})
//						})
//					}
//				},
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filterBy(function(item){
						return item.get('option') == record.get('WH_CODE')
					})
				}
			},
			{dataIndex: 'ISSUE_FOR_PRICE'	, width: 106, hidden: true },
			{dataIndex: 'ISSUE_WGT_Q'		, width: 120, hidden: true },
			{dataIndex: 'ISSUE_FOR_WGT_P'	, width: 106, hidden: true },
			{dataIndex: 'ISSUE_VOL_Q'		, width: 120, hidden: true },
			{dataIndex: 'ISSUE_FOR_VOL_P'	, width: 106, hidden: true },
			{dataIndex: 'ISSUE_FOR_AMT'		, width: 106, hidden: true },
			{dataIndex: 'ISSUE_REQ_PRICE'	, width: 106, hidden: true  },
			{dataIndex: 'ISSUE_WGT_P'		, width: 106, hidden: true },
			{dataIndex: 'ISSUE_VOL_P'		, width: 106, hidden: true },
			{dataIndex: 'ISSUE_REQ_AMT'		, width: 106, hidden: true, summaryType: 'sum'	},
			{dataIndex: 'TAX_TYPE'			, width: 80, align: 'center' },
			{dataIndex: 'ISSUE_REQ_TAX_AMT'	, width: 106, hidden: true, summaryType: 'sum' },
			{dataIndex: 'WGT_UNIT'			, width: 66, hidden: true },
			{dataIndex: 'UNIT_WGT'			, width: 66, hidden: true },
			{dataIndex: 'VOL_UNIT'			, width: 66, hidden: true },
			{dataIndex: 'UNIT_VOL'			, width: 66, hidden: true },
			{dataIndex: 'ISSUE_DATE'		, width: 80 },
			{dataIndex: 'DELIVERY_TIME'		, width: 80, hidden: true },
			{dataIndex: 'BILL_TYPE'			, width: 80,align: 'center' },
			{dataIndex: 'ORDER_TYPE'		, width: 90,align: 'center' },
			{dataIndex: 'INOUT_TYPE_DETAIL'	, width: 80,align: 'center' },
			{dataIndex: 'ISSUE_DIV_CODE'	, width: 90,align: 'center' },
			{dataIndex: 'DISCOUNT_RATE'		, width: 80 },
			{dataIndex: 'PRICE_YN'			, width: 80,align: 'center' },
			{dataIndex: 'SALE_CUSTOM_CODE'	, width: 80, hidden: true },
			{dataIndex: 'SALE_CUSTOM_NAME'	, width: 80 ,
				editor: Unilite.popup('AGENT_CUST_G',
						{autoPopup: true,
						listeners:{
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = Ext.getCmp('s_srq110ukrv_inGrid').uniOpt.currentRecord;
								grdRecord.set('SALE_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
								var grdRecord = Ext.getCmp('s_srq110ukrv_inGrid').uniOpt.currentRecord;
								grdRecord.set('SALE_CUSTOM_CODE', '');
								grdRecord.set('CUSTOM_CODE','');
								grdRecord.set('CUSTOM_NAME','');
						}
					}
				})
			},
			{dataIndex: 'ACCOUNT_YNC'		, width: 80,align: 'center' },
			{dataIndex: 'DVRY_CUST_CD'		, width: 80, hidden: true },
			{dataIndex: 'DVRY_CUST_NAME'	, width: 120,
				editor: Unilite.popup('DELIVERY_G',{
						autoPopup: true,
						listeners:{ 'onSelected': {
							fn: function(records, type  ){
								//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('DVRY_CUST_CD',records[0]['DELIVERY_CODE']);
								grdRecord.set('DVRY_CUST_NAME',records[0]['DELIVERY_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
								//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('DVRY_CUST_CD','');
								grdRecord.set('DVRY_CUST_NAME','');
						},
							applyextparam: function(popup){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								popup.setExtParam({'CUSTOM_CODE': grdRecord.get('CUSTOM_CODE')});
							}
						}
				})
			},
			{dataIndex: 'PROJECT_NO'		, width: 93 },
			{dataIndex: 'PO_NUM'			, width: 100 },
			{dataIndex: 'PO_SEQ'			, width: 80, hidden: true },
			{dataIndex: 'ORDER_NUM'			, width: 120 },
			{dataIndex: 'SER_NO'			, width: 66,align: 'center' },
			{dataIndex: 'UPDATE_DB_USER'	, width: 66, hidden: true },
			{dataIndex: 'UPDATE_DB_TIME'	, width: 66, hidden: true },
			{dataIndex: 'DEPT_CODE'			, width: 66, hidden: true },
			{dataIndex: 'TREE_NAME'			, width: 66, hidden: true},
			{dataIndex: 'MONEY_UNIT'		, width: 66, hidden: true },
			{dataIndex: 'EXCHANGE_RATE'		, width: 66, hidden: true },
			{dataIndex: 'ORDER_Q'			, width: 66, summaryType: 'sum' },
			{dataIndex: 'ISSUE_QTY'			, width: 66, summaryType: 'sum' },
			{dataIndex: 'RETURN_Q'			, width: 66, summaryType: 'sum' },
			{dataIndex: 'ISSUE_REQ_Q'		, width: 66, hidden: true },
			{dataIndex: 'DVRY_DATE'			, width: 80 },
			{dataIndex: 'DVRY_TIME'			, width: 80 },
			{dataIndex: 'TAX_INOUT'			, width: 66, hidden: true },
			{dataIndex: 'STOCK_UNIT'		, width: 66, hidden: true },
			{dataIndex: 'PRE_ACCNT_YN'		, width: 66, hidden: true },
			{dataIndex: 'REF_FLAG'			, width: 66, hidden: true },
			{dataIndex: 'SALE_P'			, width: 66, hidden: true },
			{dataIndex: 'AMEND_YN'			, width: 66, hidden: true },
			{dataIndex: 'OUTSTOCK_Q'		, width: 66, hidden: true },
			{dataIndex: 'ORDER_CUST_NM'		, width: 66, hidden: true },
			{dataIndex: 'STOCK_CARE_YN'		, width: 66, hidden: true },
			{dataIndex: 'NOTOUT_Q'			, width: 66, hidden: true},
			{dataIndex: 'SORT_KEY'			, width: 66, hidden: true },
			{dataIndex: 'REF_AGENT_TYPE'	, width: 66, hidden: true },
			{dataIndex: 'REF_WON_CALC_TYPE'	, width: 66, hidden: true },
			{dataIndex: 'REF_CODE2'			, width: 66, hidden: true },
			{dataIndex: 'COMP_CODE'			, width: 66, hidden: true },
			{dataIndex: 'SCM_FLAG_YN'		, width: 66, hidden: true },
			{dataIndex: 'REF_LOC'			, width: 66, hidden: true },
			{dataIndex: 'PAY_METHODE1'		, width: 100 },
			{dataIndex: 'LC_SER_NO'			, width: 100 },
			{dataIndex: 'GUBUN'				, width: 100, hidden: true },
			{dataIndex: 'REMARK'			, width: 106 },
			{dataIndex: 'REMARK_INTER'		, width: 106 },
			{dataIndex: 'ROW_CHECK'			, width: 50, hidden: true }
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom ) {
					if(e.field=='LOT_NO') {
						if(Ext.isEmpty(e.record.data.WH_CODE)){
							alert('<t:message code="system.message.sales.message057" default="출고창고를 입력하십시오."/>');
							return false;
						}
						if(Ext.isEmpty(e.record.data.ITEM_CODE)){
							alert('<t:message code="system.message.sales.message024" default="품목코드를 입력 하십시오."/>');
							return false;
						}
					}
					if(!Ext.isEmpty(e.record.data.ISSUE_REQ_NUM)) {
						if(e.field=='CUSTOM_CODE') return false;
						if(e.field=='CUSTOM_NAME') return false;
						if(e.field=='ORDER_TYPE') return false;
						if(e.field=='ITEM_CODE') return false;
						if(e.field=='ITEM_NAME') return false;
						if(e.field=='SPEC') return false;
						if(e.field=='ORDER_UNIT') return false;
						if(e.field=='TRANS_RATE') return false;
						if(e.field=='STOCK_Q') return false;

						if(e.field=='SALE_CUSTOM_CODE') return false;
						if(e.field=='SALE_CUSTOM_NAME') return false;
						if(e.field=='PRICE_YN') return false;
						if(e.field=='ISSUE_DIV_CODE') return false;
						if(e.field=='PO_NUM') return false;
						if(e.field=='PO_SEQ') return false;
						if(e.field=='SER_NO') return false;
						if(e.field=='DISCOUNT_RATE') return false;
						if(e.field=='BILL_TYPE') return false;
						if(e.field=='TAX_TYPE') return false;
						if(e.field=='ACCOUNT_YNC') return false;
						if(e.field=='DVRY_CUST_NAME') return false;
						if(e.field=='DVRY_DATE') return false;
						if(e.field=='DVRY_TIME') return false;
//						if(e.field=='ISSUE_REQ_PRICE') return false;
//						if(e.field=='ISSUE_REQ_AMT') return false;
//						if(e.field=='UNIT_WGT') return false;
//						if(e.field=='UNIT_VOL') return false;
//						if(!Ext.isEmpty(e.record.data.GUBUN)) {
//							if(e.field=='PRICE_TYPE') return false;
//							if(e.field=='WGT_UNIT') return false;
//							if(e.field=='VOL_UNIT') return false;
//						}
						if(e.field=='ISSUE_QTY') return false;
						if(e.field=='RETURN_Q') return false;
						if(e.field=='ORDER_Q') return false;

						if( e.record.data.TAX_TYPE!= '1') {
							if(e.field=='ISSUE_REQ_TAX_AMT') return false;
						}
					}else {
						if( e.record.data.BILL_TYPE == '50') {
							if(e.field=='TAX_TYPE') return false;
						}
						if(e.field=='SPEC') return false;
						if(e.field=='STOCK_Q') return false;
						if(e.field=='PO_NUM') return false;
						if(e.field=='PO_SEQ') return false;
						if(e.field=='ORDER_NUM') return false;
						if(e.field=='SER_NO') return false;
						if(e.field=='DVRY_DATE') return false;
						if(e.field=='DVRY_TIME') return false;
						if(e.field=='PRICE_YN') return false;
						if(e.field=='ISSUE_QTY') return false;
						if(e.field=='RETURN_Q') return false;
						if(e.field=='ORDER_Q') return false;
//						if(e.field=='ISSUE_REQ_PRICE') return false;
//						if(e.field=='ISSUE_REQ_AMT') return false;
//						if(e.field=='UNIT_WGT') return false;
//						if(e.field=='UNIT_VOL') return false;
//						if(!Ext.isEmpty(e.record.data.GUBUN)) {
//							if(e.field=='PRICE_TYPE') return false;
//							if(e.field=='WGT_UNIT') return false;
//							if(e.field=='VOL_UNIT') return false;
//						}
						if( e.record.data.TAX_TYPE!= '1') {
							if(e.field=='ISSUE_REQ_TAX_AMT') return false;
						}
						if(e.field=='DISCOUNT_RATE') {
							if( !(e.record.data.AMEND_YN == 'Y' || ( e.record.data.AMEND_YN == 'N' && Unilite.nvl(e.record.data.DISCOUNT_RATE,0) == 0))) {
								return false;
							}
						}
					}
				}else {
					//출고된 적 없음 & 출하된적 있음.
					if(Unilite.nvl(e.record.data.ISSUE_QTY,0) == 0) {
						if(e.field=='ISSUE_REQ_SEQ') return false;
						if(e.field=='SPEC') return false;
						if(e.field=='PO_NUM') return false;
						if(e.field=='PO_SEQ') return false;
						if(e.field=='ORDER_NUM') return false;
						if(e.field=='SER_NO') return false;
						if(e.field=='PRICE_YN') return false;
						if(e.field=='CUSTOM_CODE') return false;
						if(e.field=='CUSTOM_NAME') return false;
						if(e.field=='ITEM_CODE') return false;
						if(e.field=='ITEM_NAME') return false;
						if(e.field=='STOCK_Q') return false;
						if(e.field=='ISSUE_DIV_CODE') return false;
						if(e.field=='WH_CODE') return false;
						if(e.field=='DVRY_DATE') return false;
						if(e.field=='DVRY_TIME') return false;
						if(e.field=='ISSUE_QTY') return false;
						if(e.field=='RETURN_Q') return false;
						if(e.field=='ORDER_Q') return false;
//						if(e.field=='ISSUE_REQ_PRICE') return false;
//						if(e.field=='ISSUE_REQ_AMT') return false;
//						if(e.field=='ISSUE_REQ_TAX_AMT') return false;
//						if(e.field=='UNIT_WGT') return false;
//						if(e.field=='UNIT_VOL') return false;
						if(!Ext.isEmpty(e.record.data.ORDER_NUM)) {
//							if(e.field=='ORDER_TYPE') return false;
//							if(e.field=='ORDER_UNIT') return false;
//							if(e.field=='TRANS_RATE') return false;
//							if(e.field=='DISCOUNT_RATE') return false;
//							if(e.field=='BILL_TYPE') return false;
//							if(e.field=='SALE_CUSTOM_CODE') return false;
//							if(e.field=='SALE_CUSTOM_NAME') return false;
							if(e.field=='DISCOUNT_RATE') return false;
						} else {
							if(e.field=='DISCOUNT_RATE') {
								if( !(e.record.data.AMEND_YN == 'Y' || ( e.record.data.AMEND_YN == 'N' && Unilite.nvl(e.record.data.DISCOUNT_RATE,0) == 0))) {
									return false;
								}
							}
						}
					}else {
						return false;
					}
				}
			},
			edit: function(editor, e) {
			}
		},
		disabledLinkButtons: function(b) {
//			this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
//			this.down('#procTool').menu.down('#issueLinkBtn').setDisabled(b);
//			this.down('#procTool').menu.down('#saleLinkBtn').setDisabled(b);
		},
		setItemData: function(record, dataClear, grdRecord) {
//			var grdRecord = this.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		,"");
				grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('STOCK_UNIT'		,"");
				grdRecord.set('STOCK_Q'			,0);
				grdRecord.set('WH_CODE'			,'');
				grdRecord.set('TAX_TYPE'		,'');
				grdRecord.set('ISSUE_DIV_CODE'	,'');
				grdRecord.set('WGT_UNIT'		,"");
				grdRecord.set('UNIT_WGT'		,0);
				grdRecord.set('VOL_UNIT'		,"");
				grdRecord.set('UNIT_VOL'		,0);
				grdRecord.set('ISSUE_REQ_PRICE'	, 0);
				grdRecord.set('ISSUE_WGT_P'		, 0);
				grdRecord.set('ISSUE_VOL_P'		, 0);
				grdRecord.set('TRANS_RATE'		,1);
				//20170518 - masterForm.getValue('EXCHAGE_RATE') 존재하지 않음
//				grdRecord.set('DISCOUNT_RATE',masterForm.getValue('EXCHAGE_RATE'));
				grdRecord.set('ISSUE_FOR_PRICE'	, 0);
				grdRecord.set('ISSUE_FOR_WGT_P'	, 0);
				grdRecord.set('ISSUE_FOR_VOL_P'	, 0);
				grdRecord.set('AMEND_YN'		, 'N');
				grdRecord.set('TREE_NAME'		, 'N');
				grdRecord.set('STOCK_Q'			, 0);
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
				}else {
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
						,'I'
						,UserInfo.compCode
						,grdRecord.get('CUSTOM_CODE')
						,grdRecord.get('REF_AGENT_TYPE')
						,record['ITEM_CODE']
						,BsaCodeInfo.gsMoneyUnit
						,record['SALE_UNIT']
						,record['STOCK_UNIT']
						,record['TRANS_RATE']
						,UniDate.getDbDateStr(masterForm.getValue('SHIP_DATE'))
						,grdRecord.get('ISSUE_REQ_QTY')
						,record['WGT_UNIT']
						,record['VOL_UNIT']
						,''
						,''
						,''
						, UserInfo.divCode
						, null
						,  record['WH_CODE']
				)
				//UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
			}
		},
		setRefData: function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('ISSUE_REQ_DATE'		, UniDate.getDbDateStr(masterForm.getValue('SHIP_DATE')));
			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);

//			var orderType = masterForm.getValue('ORDER_TYPE');
//			if(orderType == '80') {
//				grdRecord.set('BILL_TYPE'		, '60');
//			}else if(orderType == '81') {
//				grdRecord.set('BILL_TYPE'		, '50');
//			}else {
//				grdRecord.set('BILL_TYPE'		, record['BILL_TYPE']);
//			}
			grdRecord.set('BILL_TYPE'			, record['BILL_TYPE']);
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('SALE_CUSTOM_CODE'	, record['SALE_CUST_CD']);
			grdRecord.set('SALE_CUSTOM_NAME'	, record['SALE_CUST_NAME']);
			grdRecord.set('ISSUE_DIV_CODE'		, record['OUT_DIV_CODE']);
			grdRecord.set('WH_CODE'				, Unilite.nvl(record['WH_CODE'],record['REF_WH_CODE']));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);
			grdRecord.set('STOCK_Q'				, record['STOCK_Q']);
			grdRecord.set('NOTOUT_Q'			, record['NOTOUT_Q']);
			grdRecord.set('ISSUE_REQ_QTY'		, record['NOTOUT_Q']);
			grdRecord.set('ISSUE_REQ_PRICE'		, record['ORDER_P']);
			grdRecord.set('ISSUE_REQ_AMT'		, record['ORDER_O']);
			grdRecord.set('EXCHANGE_RATE'		, record['REF_EXCHG_RATE_O']);
			grdRecord.set('ISSUE_FOR_PRICE'		, record['ORDER_FOR_P']);
			grdRecord.set('ISSUE_FOR_AMT'		, record['ORDER_FOR_O']);
			grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);
			grdRecord.set('ISSUE_REQ_TAX_AMT'	, record['ORDER_TAX_O']);
			grdRecord.set('ISSUE_DATE'			, record['DVRY_DATE']);
			grdRecord.set('ISSUE_FOR_AMT'		, record['ORDER_FOR_O']);
			grdRecord.set('DELIVERY_TIME'		, record['DVRY_TIME']);
			grdRecord.set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
			grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
			grdRecord.set('ACCOUNT_YNC'			, record['ACCOUNT_YNC']);
			grdRecord.set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);
			grdRecord.set('DVRY_CUST_NAME'		, record['DVRY_CUST_NAME']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('PO_NUM'				, record['PO_NUM']);
			grdRecord.set('PO_SEQ'				, record['PO_SEQ']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('SER_NO'				, record['SER_NO']);
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('TREE_NAME'			, '*');
			grdRecord.set('MONEY_UNIT'			, record['REF_MONEY_UNIT']);
//			grdRecord.set('ISSUE_QTY'			, record['OUTSTOCK_Q']);
//			grdRecord.set('RETURN_Q'			, record['RETURN_Q']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('ISSUE_REQ_Q'			, record['ISSUE_REQ_Q']);
			grdRecord.set('DVRY_DATE'			, record['DVRY_DATE']);
			grdRecord.set('DVRY_TIME'			, record['DVRY_TIME']);
			grdRecord.set('TAX_INOUT'			, record['TAX_INOUT']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('PRE_ACCNT_YN'		, record['ACCOUNT_YNC']);
			grdRecord.set('REF_AGENT_TYPE'		, record['REF_AGENT_TYPE']);
			grdRecord.set('REF_WON_CALC_TYPE'	, record['REF_WON_CALC_TYPE']);
			grdRecord.set('REF_LOC'				, record['REF_LOC']);
			grdRecord.set('PAY_METHODE1'		, record['PAY_METHODE1']);
			grdRecord.set('LC_SER_NO'			, record['LC_SER_NO']);
			grdRecord.set('ISSUE_WGT_Q'			, record['ORDER_WGT_Q']);
			grdRecord.set('ISSUE_VOL_Q'			, record['ORDER_VOL_Q']);
			grdRecord.set('PRICE_TYPE'			, record['PRICE_TYPE']);
			grdRecord.set('ISSUE_FOR_WGT_P'		, record['ORDER_FOR_WGT_P']);
			grdRecord.set('ISSUE_FOR_VOL_P'		, record['ORDER_FOR_VOL_P']);
			grdRecord.set('ISSUE_WGT_P'			, record['ORDER_WGT_P']);
			grdRecord.set('ISSUE_VOL_P'			, record['ORDER_VOL_P']);
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
			grdRecord.set('GUBUN'				, 'FEFER');
			grdRecord.set('INOUT_TYPE_DETAIL'	, record['INOUT_TYPE_DETAIL']);
			grdRecord.set('LOT_NO'				, record['LOT_NO']);

			CustomCodeInfo.gsAgentType = record['REF_AGENT_TYPE'];
			CustomCodeInfo.gsUnderCalBase = record['REF_WON_CALC_TYPE'];

			var orderQ = record['ORDER_Q'];
			if(orderQ != record['NOTOUT_Q']) {
				UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
			}
			UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
			UniSales.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, record['OUT_DIV_CODE'], null,record['ITEM_CODE'],record['WH_CODE'])	;
		}
	});

	/**
	 * 수주정보를 검색하기 위한 Search Form, Grid, Inner Window 정의
	 */
	 //조회창 폼 정의
	var requestNoSearch = Unilite.createSearchForm('requestNoSearchForm', {
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [
			Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
			validateBlank: false
		}),{
			fieldLabel: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ISSUE_REQ_DATE_FR',
			endFieldName: 'ISSUE_REQ_DATE_TO',
			width: 350,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			labelWidth: 100
		}, {
			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'		,
			name: 'ISSUE_REQ_PRSN',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'S010'
		}, {
			xtype: 'container',
			layout: {type: 'uniTable', columns: 2},
			items: [{
				fieldLabel: '<t:message code="system.label.sales.issuedivisionwh" default="출고사업장/창고"/>',
				name: 'ISSUE_DIV_CODE',
				xtype:'uniCombobox',
				comboType:'BOR120',
				value:UserInfo.divCode,
				allowBlank:false,
				labelWidth: 100
			}, {
				margin:  '0 0 0 10',
				hideLabel: true,
				name: 'WH_CODE',
				xtype:'uniCombobox',
				comboType:'OU',
				listeners: {
					beforequery:function( queryPlan, eOpts )	{
						var store = queryPlan.combo.store;
									store.clearFilter();
									if(!Ext.isEmpty(requestNoSearch.getValue('ISSUE_DIV_CODE'))){
										store.filterBy(function(record){
										return record.get('option') == requestNoSearch.getValue('ISSUE_DIV_CODE');
									})
									}else{
											store.filterBy(function(record){
											return false;
									 })
								}
							}
				}
			}]
		}, {
			fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
			name: 'ORDER_TYPE',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'S002'
			//value: '10'
		},
			Unilite.popup('DIV_PUMOK',{
			labelWidth: 100
		}),{
			fieldLabel: '<t:message code="system.label.sales.issuetype" default="출고유형"/>',
			name: 'INOUT_TYPE_DETAIL',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'S007'
		}, Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
				valueFieldName:'PJT_CODE',
				textFieldName:'PJT_NAME',
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName: 'PJT_NAME',
				validateBlank: false,
//				allowBlank:false,
				textFieldOnly: false,
				labelWidth: 100,
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
				}), {
					fieldLabel: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'	,
					name: 'ISSUE_REQ_NUM',
					xtype: 'uniTextfield'
				}
/*							{
			fieldLabel: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
			xtype: 'uniTextfield',
			name:'PROJECT_NO',
			width:315,
			labelWidth: 100
		}*/
		]
	}); // createSearchForm
	//조회창 모델 정의
	Unilite.defineModel('requestNoMasterModel', {
		fields: [
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.client" default="고객"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.client" default="고객"/>'					, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'						, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'						, type: 'string'},
			{name: 'ISSUE_REQ_QTY'		, text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'		, type: 'uniQty'},
			{name: 'ISSUE_REQ_DATE'		, text: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'		, type: 'uniDate'},
			{name: 'ISSUE_DATE'			, text: '<t:message code="system.label.sales.issueresevationdate" default="출고예정일"/>'	, type: 'uniDate'},
			{name: 'ISSUE_DIV_CODE'		, text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'			, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'			, type: 'string', comboType:'OU'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'				, type: 'string', comboType:'AU', comboCode:'S002'},
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'				, type: 'string', comboType:'AU', comboCode:'S007'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'ISSUE_REQ_NUM'		, text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'					, type: 'string'},
			{name: 'SORT_KEY'			, text: 'SORT_KEY'			, type: 'string'}
		]
	});

	//조회창 스토어 정의
	var requestNoMasterStore = Unilite.createStore('requestNoMasterStore', {
		model: 'requestNoMasterModel',
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
				read	: 's_srq110ukrv_inService.selectOrderNumMasterList'
			}
		}
		,loadStoreRecords : function() {
			var param= requestNoSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//조회창 그리드 정의
	var requestNoMasterGrid = Unilite.createGrid('s_srq110ukrv_inOrderNoMasterGrid', {
		// title: '기본',
		layout : 'fit',
		store: requestNoMasterStore,
		uniOpt:{
					useRowNumberer: false
		},
		columns:  [
			{ dataIndex: 'CUSTOM_CODE'			, width: 66, hidden: true  },
			{ dataIndex: 'CUSTOM_NAME'			, width: 100 },
			{ dataIndex: 'ITEM_CODE'			, width: 80  },
			{ dataIndex: 'ITEM_NAME'			, width: 166 },
			{ dataIndex: 'SPEC'					, width: 120 },
			{ dataIndex: 'ISSUE_REQ_QTY'		, width: 100  },
			{ dataIndex: 'ISSUE_REQ_DATE'		, width: 80  },
			{ dataIndex: 'ISSUE_DATE'			, width: 80  },
			{ dataIndex: 'ISSUE_REQ_NUM'		, width: 100  },
			{ dataIndex: 'ISSUE_DIV_CODE'		, width: 80, hidden: true  },
			{ dataIndex: 'WH_CODE'				, width: 80  },
			{ dataIndex: 'ORDER_TYPE'			, width: 86  },
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 66  },
			{ dataIndex: 'PROJECT_NO'			, width: 100  },
			{ dataIndex: 'DIV_CODE'				, width: 73, hidden: true  },
			{ dataIndex: 'SORT_KEY'				, width: 73, hidden: true  }
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
					requestNoMasterGrid.returnData(record);
					UniAppManager.app.onQueryButtonDown();
					searchInfoWindow.hide();
					UniAppManager.setToolbarButtons(['deleteAll'], true);
			}
		}, // listeners
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			masterForm.uniOpt.inLoading=true;
			masterForm.setValues({'DIV_CODE':record.get('DIV_CODE'), 'ISSUE_REQ_NUM':record.get('ISSUE_REQ_NUM')});
			masterForm.setValues('CUSTOM_CODE',record.get('CUSTOM_CODE'));
			masterForm.setValues('CUSTOM_NAME',record.get('CUSTOM_NAME'));
			masterForm.uniOpt.inLoading=false;
		}
	});

	//조회창 메인
	function openSearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.sales.shipmentordernosearch" default="출하지시번호검색"/>',
				width: 830,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [requestNoSearch, requestNoMasterGrid],
				tbar:  ['->',
						{	itemId : 'searchBtn',
							text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
							handler: function() {
								requestNoMasterStore.loadStoreRecords();
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
						requestNoSearch.clearForm();
						requestNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						requestNoSearch.clearForm();
						requestNoMasterGrid.reset();
					},
					beforeshow: function( panel, eOpts ) {
						requestNoSearch.setValue('ISSUE_DIV_CODE',masterForm.getValue('DIV_CODE'));
						requestNoSearch.setValue('ISSUE_REQ_DATE_FR',UniDate.get('startOfMonth'));
						requestNoSearch.setValue('ISSUE_REQ_DATE_TO',UniDate.get('today'));
						requestNoSearch.setValue('ISSUE_REQ_PRSN',masterForm.getValue('SHIP_PRSN'));
						requestNoSearch.setValue('WH_CODE',masterForm.getValue('WH_CODE'));
						//requestNoSearch.setValue('ORDER_TYPE','10');
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
	//참조내역 폼 정의 (수주참조)
	 var referSearch = Unilite.createSearchForm('referForm', {
		layout :  {type : 'uniTable', columns : 3},
		items :[
		Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>',
			validateBlank: false
		}),{
			fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
			name: 'ORDER_TYPE',
			comboType:'AU',
			comboCode:'S002',
			xtype:'uniCombobox'
		},{
			fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'DELIVERY_DATE_FR',
			endFieldName: 'DELIVERY_DATE_TO',
			width: 350,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>'
		}),{
			fieldLabel: '<t:message code="system.label.sales.offernosalesorder" default="수주/Offer번"/>',
			xtype: 'uniTextfield',
			name:'SO_SER_NO'
		},{
			fieldLabel: '<t:message code="system.label.sales.remarks" default="비고"/>',
			xtype: 'uniTextfield',
			name:'REMARK'
		},{
			fieldLabel: '<t:message code="system.label.sales.remarkinter" default="내부기록사항"/>',
			xtype: 'uniTextfield',
			name:'REMARK_INTER'
		}]
	});
	//참조내역 모델 정의
	Unilite.defineModel('s_srq110ukrv_inReferModel', {
		fields: [
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.client" default="고객"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.client" default="고객"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'		, type: 'string', displayField: 'value'},
			{name: 'TRANS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'		, type: 'uniQty'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'		, type: 'uniDate'},
			{name: 'DVRY_TIME'			,text: '<t:message code="system.label.sales.deliverytime" default="납기시간"/>'		, type: 'uniDate'},
			{name: 'NOTOUT_Q'			,text: '<t:message code="system.label.sales.undeliveryqty" default="미납량"/>'		, type: 'uniQty'},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.sales.soqty" default="수주량"/>'				, type: 'uniQty'},
			{name: 'ORDER_WGT_Q'		,text: '<t:message code="system.label.sales.soqtyweight" default="수주량(중량)"/>'	, type: 'uniQty'},
			{name: 'ORDER_VOL_Q'		,text: '<t:message code="system.label.sales.soqtyvolumn" default="수주량(부피)"/>'	, type: 'uniQty'},
			{name: 'ORDER_TYPE'			,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'		, type: 'string'},
			{name: 'ORDER_TYPE_NAME'	,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'		, type: 'string'},
			{name: 'ORDER_PRSN'			,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'		, type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'SER_NO'				,text: '<t:message code="system.label.sales.seq" default="순번"/>'				, type: 'int'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'SALE_CUST_CD'		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'		, type: 'string'},
			{name: 'SALE_CUST_NAME'		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'		, type: 'string'},
			{name: 'OUT_DIV_CODE'		,text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'	, type: 'string', comboType: 'BOR120'},
			{name: 'PAY_METHODE1'		,text: '<t:message code="system.label.sales.amountpaymethod" default="대금결제방법"/>', type: 'string'},
			{name: 'LC_SER_NO'			,text: '<t:message code="system.label.sales.lcno" default="L/C번호"/>'			, type: 'string'},
			{name: 'PO_NUM'				,text: '<t:message code="system.label.sales.pono2" default="P/O 번호"/>'			, type: 'string'},
			{name: 'PO_SEQ'				,text: '<t:message code="system.label.sales.poseq2" default="P/O 순번"/>'			, type: 'int'},
			{name: 'DIV_CODE'			,text: 'DIV_CODE'			, type: 'string'},
			{name: 'DISCOUNT_RATE'		,text: 'DISCOUNT_RATE'		, type: 'uniER'},
			{name: 'ACCOUNT_YNC'		,text: 'ACCOUNT_YNC'		, type: 'string', comboType: 'AU', comboCode: 'S014'},
			{name: 'DVRY_CUST_CD'		,text: '<t:message code="system.label.sales.deliveryplacecode" default="배송처코드"/>', type: 'string'},
			{name: 'DVRY_CUST_NAME'		,text: '<t:message code="system.label.sales.deliveryplacename" default="배송처명"/>', type: 'string'},
			{name: 'PRICE_YN'			,text: 'PRICE_YN'			, type: 'string'},
			{name: 'ORDER_FOR_P'		,text: 'ORDER_FOR_P'		, type: 'string'},
			{name: 'ORDER_FOR_O'		,text: 'ORDER_FOR_O'		, type: 'string'},
			{name: 'ORDER_P'			,text: 'ORDER_P'			, type: 'string'},
			{name: 'ORDER_O'			,text: 'ORDER_O'			, type: 'string'},
			{name: 'TAX_TYPE'			,text: 'TAX_TYPE'			, type: 'string'},
			{name: 'ORDER_TAX_O'		,text: 'ORDER_TAX_O'		, type: 'string'},
			{name: 'STOCK_Q'			,text: 'STOCK_Q'			, type: 'string'},
			{name: 'ISSUE_REQ_Q'		,text: 'ISSUE_REQ_Q'		, type: 'string'},
			{name: 'OUTSTOCK_Q'			,text: 'OUTSTOCK_Q'			, type: 'string'},
			{name: 'RETURN_Q'			,text: 'RETURN_Q'			, type: 'string'},
			{name: 'SALE_Q'				,text: 'SALE_Q'				, type: 'string'},
			{name: 'STOCK_UNIT'			,text: 'STOCK_UNIT'			, type: 'string'},
			{name: 'REF_ORDER_DATE'		,text: 'REF_ORDER_DATE'		, type: 'string'},
			{name: 'REF_MONEY_UNIT'		,text: 'REF_MONEY_UNIT'		, type: 'string'},
			{name: 'REF_EXCHG_RATE_O'	,text: 'REF_EXCHG_RATE_O'	, type: 'string'},
			{name: 'REF_WH_CODE'		,text: 'REF_WH_CODE'		, type: 'string'},
			{name: 'BILL_TYPE'			,text: 'BILL_TYPE'			, type: 'string'},
			{name: 'TAX_INOUT'			,text: 'TAX_INOUT'			, type: 'string'},
			{name: 'SORT_KEY'			,text: 'SORT_KEY'			, type: 'string'},
			{name: 'REF_AGENT_TYPE'		,text: 'REF_AGENT_TYPE'		, type: 'string'},
			{name: 'REF_WON_CALC_TYPE'	,text: 'REF_WON_CALC_TYPE'	, type: 'string'},
			{name: 'REF_LOC'			,text: 'REF_LOC'			, type: 'string'},
			{name: 'REMARK'				,text: 'REMARK'				, type: 'string'},
			{name: 'PRICE_TYPE'			,text: 'PRICE_TYPE'			, type: 'string'},
			{name: 'ORDER_FOR_WGT_P'	,text: 'ORDER_FOR_WGT_P'	, type: 'string'},
			{name: 'ORDER_FOR_VOL_P'	,text: 'ORDER_FOR_VOL_P'	, type: 'string'},
			{name: 'ORDER_WGT_P'		,text: 'ORDER_WGT_P'		, type: 'string'},
			{name: 'ORDER_VOL_P'		,text: 'ORDER_VOL_P'		, type: 'string'},
			{name: 'WGT_UNIT'			,text: 'WGT_UNIT'			, type: 'string'},
			{name: 'UNIT_WGT'			,text: 'UNIT_WGT'			, type: 'string'},
			{name: 'VOL_UNIT'			,text: 'VOL_UNIT'			, type: 'string'},
			{name: 'UNIT_VOL'			,text: 'UNIT_VOL'			, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'		, type: 'string', comboType: 'AU', comboCode: 'S007'},
			{name: 'LOT_NO'				,text: 'LOT NO'				, type: 'string'},
			{name: 'REMARK_INTER'		,text: '<t:message code="system.label.sales.remarkinter" default="내부기록사항"/>'	, type: 'string'}
		]
	});

	//참조내역 스토어 정의 (수주참조)
	var referStore = Unilite.createStore('s_srq110ukrv_inReferStore', {
			model: 's_srq110ukrv_inReferModel',
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
					read	: 's_srq110ukrv_inService.selectReferList'
				}
			}
			,loadStoreRecords : function() {
				var param= referSearch.getValues();
				param["ORDER_PRSN"] = masterForm.getValue('SHIP_PRSN');
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	//참조내역 그리드 정의
	var referGrid = Unilite.createGrid('s_srq110ukrv_inReferGrid', {
		// title: '기본',
		layout : 'fit',
		store: referStore,
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false, mode: 'SIMPLE' }),
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns:  [
			{ dataIndex: 'CUSTOM_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'CUSTOM_NAME'			, width: 106 },
			{ dataIndex: 'ITEM_CODE'			, width: 100 },
			{ dataIndex: 'ITEM_NAME'			, width: 150 },
			{ dataIndex: 'SPEC'					, width: 120 },
			{ dataIndex: 'ORDER_UNIT'			, width: 70, align: 'center' },
			{ dataIndex: 'TRANS_RATE'			, width: 40, align: 'center' },
			{ dataIndex: 'DVRY_DATE'			, width: 80 },
			{ dataIndex: 'DVRY_TIME'			, width: 66, hidden: true },
			{ dataIndex: 'NOTOUT_Q'				, width: 100 },
			{ dataIndex: 'ORDER_Q'				, width: 100 },
			{ dataIndex: 'ORDER_WGT_Q'			, width: 100, hidden: true },
			{ dataIndex: 'ORDER_VOL_Q'			, width: 100, hidden: true },
			{ dataIndex: 'ORDER_TYPE'			, width: 66, hidden: true },
			{ dataIndex: 'ORDER_TYPE_NAME'		, width: 80 },
			{ dataIndex: 'ORDER_PRSN'			, width: 93, hidden: true },
			{ dataIndex: 'ORDER_NUM'			, width: 100 },
			{ dataIndex: 'SER_NO'				, width: 60 },
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 100 },
			{ dataIndex: 'PROJECT_NO'			, width: 100 },
			{ dataIndex: 'SALE_CUST_CD'			, width: 66, hidden: true },
			{ dataIndex: 'SALE_CUST_NAME'		, width: 106 },
			{ dataIndex: 'OUT_DIV_CODE'			, width: 120 },
			{ dataIndex: 'PAY_METHODE1'			, width: 100 },
			{ dataIndex: 'LC_SER_NO'			, width: 100 },
			{ dataIndex: 'PO_NUM'				, width: 100 },
			{ dataIndex: 'PO_SEQ'				, width: 53, hidden: true },
			{ dataIndex: 'DIV_CODE'				, width: 66, hidden: true },
			{ dataIndex: 'DISCOUNT_RATE'		, width: 66, hidden: true },
			{ dataIndex: 'ACCOUNT_YNC'			, width: 66, hidden: true },
			{ dataIndex: 'DVRY_CUST_CD'			, width: 66, hidden: true },
			{ dataIndex: 'DVRY_CUST_NAME'		, width: 66 },
			{ dataIndex: 'PRICE_YN'				, width: 66, hidden: true },
			{ dataIndex: 'ORDER_FOR_P'			, width: 66, hidden: true },
			{ dataIndex: 'ORDER_FOR_O'			, width: 86, hidden: true },
			{ dataIndex: 'ORDER_P'				, width: 66, hidden: true },
			{ dataIndex: 'ORDER_O'				, width: 86, hidden: true },
			{ dataIndex: 'TAX_TYPE'				, width: 66, hidden: true },
			{ dataIndex: 'ORDER_TAX_O'			, width: 66, hidden: true },
			{ dataIndex: 'STOCK_Q'				, width: 66, hidden: true },
			{ dataIndex: 'ISSUE_REQ_Q'			, width: 66, hidden: true },
			{ dataIndex: 'OUTSTOCK_Q'			, width: 66, hidden: true },
			{ dataIndex: 'RETURN_Q'				, width: 66, hidden: true },
			{ dataIndex: 'SALE_Q'				, width: 66, hidden: true },
			{ dataIndex: 'STOCK_UNIT'			, width: 66, hidden: true },
			{ dataIndex: 'REF_ORDER_DATE'		, width: 66, hidden: true },
			{ dataIndex: 'REF_MONEY_UNIT'		, width: 66, hidden: true },
			{ dataIndex: 'REF_EXCHG_RATE_O'		, width: 66, hidden: true },
			{ dataIndex: 'REF_WH_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'BILL_TYPE'			, width: 66, hidden: true },
			{ dataIndex: 'TAX_INOUT'			, width: 66, hidden: true },
			{ dataIndex: 'SORT_KEY'				, width: 66, hidden: true },
			{ dataIndex: 'REF_AGENT_TYPE'		, width: 66, hidden: true },
			{ dataIndex: 'REF_WON_CALC_TYPE'	, width: 66, hidden: true },
			{ dataIndex: 'REF_LOC'				, width: 66, hidden: true },
			{ dataIndex: 'REMARK'				, width: 66, hidden: true },
			{ dataIndex: 'PRICE_TYPE'			, width: 66, hidden: true },
			{ dataIndex: 'ORDER_FOR_WGT_P'		, width: 66, hidden: true },
			{ dataIndex: 'ORDER_FOR_VOL_P'		, width: 66, hidden: true },
			{ dataIndex: 'ORDER_WGT_P'			, width: 66, hidden: true },
			{ dataIndex: 'ORDER_VOL_P'			, width: 66, hidden: true },
			{ dataIndex: 'WGT_UNIT'				, width: 66, hidden: true },
			{ dataIndex: 'UNIT_WGT'				, width: 66, hidden: true },
			{ dataIndex: 'VOL_UNIT'				, width: 66, hidden: true },
			{ dataIndex: 'UNIT_VOL'				, width: 66, hidden: true },
			{ dataIndex: 'LOT_NO'				, width: 66 },
			{ dataIndex: 'REMARK_INTER'			, width: 100}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			UniAppManager.app.fnMakeSof100tDataRef(records);
		/* 	Ext.each(records, function(record,i){
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setRefData(record.data);
									}); */
			this.deleteSelectedRow();
		}
	});
	//참조내역 메인
	function openReferWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!referWindow) {
			referWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.sales.reference" default="참조..."/>',
				width: 1100,
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
				},{	itemId : 'confirmBtn',
					text: '<t:message code="system.label.sales.referenceapply" default="참조적용"/>',
					handler: function() {
						referGrid.returnData();
					},
					disabled: false
				},{	itemId : 'confirmCloseBtn',
					text: '<t:message code="system.label.sales.referenceapplyclose" default="참조적용 후 닫기"/>',
					handler: function() {
						referGrid.returnData();
						referWindow.hide();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler: function() {
						referWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
//						referSearch.clearForm();
						referGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
//						referSearch.clearForm();
						referGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						referSearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
						referSearch.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
						referStore.loadStoreRecords();
					}
				}
			})
		}
		referWindow.center();
		referWindow.show();
	}






	/**
	 * 사업장별 영업담당 정보
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
						referSearch.setValue('ESTI_PRSN', masterForm.getValue('ORDER_PRSN'));
					}
			}
		},
		loadStoreRecords: function() {
			var param= {
						'COMP_CODE' : UserInfo.compCode,
						'MAIN_CODE' : 'S010',
						'DIV_CODE'  : masterForm.getValue('DIV_CODE'),
						'TYPE'		:'DIV_PRSN'
				}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/**
	 * main app
	 */
	Unilite.Main({
		id: 's_srq110ukrv_inApp',
		items: [{
			layout: 'fit',
			flex: 1,
			border: false,
			items: [{
				layout: 'border',
				defaults: {style: {padding: '5 5 5 5'}},
				border: false,
				items: [
					detailGrid,
					masterForm
				]
			}]
		}],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset'/*, 'newData'*/, 'prev', 'next'], true);		//20200519 수정: 추가버튼 false
			detailGrid.disabledLinkButtons(false);
			this.setDefault();
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}

//			if(params.ORDER_NUM ) {
//				Ext.getBody().mask();
//				var param = {'SO_SER_NO': params.ORDER_NUM};
//					s_srq110ukrv_inService.selectReferList(param, function(provider, response){
//					Ext.each(provider, function(data,i){
//						if(i==0) {
//							masterForm.setValue('SHIP_PRSN', provider[0]['ORDER_PRSN'])
//							masterForm.setValue('ORDER_TYPE', provider[0]['ORDER_TYPE'])
//							masterForm.setValue('MONEY_UNIT', provider[0]['REF_MONEY_UNIT'])
//							masterForm.setValue('EXCHAGE_RATE', provider[0]['REF_EXCHG_RATE_O'])
//						}
//						UniAppManager.app.onNewDataButtonDown();
//						detailGrid.setRefData(data);
//					});
//					Ext.getBody().unmask();
//				})
//			}
		},
		onQueryButtonDown: function() {
			if(!masterForm.setAllFieldsReadOnly(true)){
				return false;
			}
			searchGBN = '2';
			var shipNum = masterForm.getValue('ISSUE_REQ_NUM');
			if(searchGBN == '1' && Ext.isEmpty(shipNum)) {
				openSearchInfoWindow()
			} else {
				detailStore.loadStoreRecords();
			}
		},
		//링크로 넘어오는 params 받는 부분
		processParams: function(params) {
			//this.uniOpt.appParams = params;
			if(params.PGM_ID == 'sof100ukrv') { //수주등록 에서 링크넘어올시
				var formPram = params.formPram;

				masterForm.setValue('DIV_CODE'		,formPram.DIV_CODE);
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

					 var customCode='';
					 var customName='';
					 if(Ext.isEmpty(masterForm.getValue('ISSUE_REQ_NUM'))) {
						customCode=masterForm.getValue('CUSTOM_CODE');
						customName=masterForm.getValue('CUSTOM_NAME');
					 }

					// var orderType = rec.get('ORDER_TYPE');

					 var billType = formPram.BILL_TYPE;

				 var shipDate = UniDate.getDbDateStr(masterForm.getValue('SHIP_DATE'));
					 outDivCode = masterForm.getValue('DIV_CODE');
				 var shipPrsn = masterForm.getValue('SHIP_PRSN');
				 var r = {
					ISSUE_REQ_SEQ	: seq,
					DIV_CODE		: outDivCode,
					ISSUE_REQ_METH  :'2',
					CUSTOM_CODE		: customCode,
					CUSTOM_NAME		: customName,
					ORDER_TYPE		: rec.get('REF_ORDER_TYPE'),
					BILL_TYPE		: billType,
					ITEM_CODE		: rec.get('ITEM_CODE'),
					ITEM_NAME		: rec.get('ITEM_NAME'),
					SPEC			: rec.get('SPEC'),
					ORDER_UNIT		: rec.get('ORDER_UNIT'),
					TRANS_RATE		: rec.get('TRANS_RATE'),
					WH_CODE			:  Unilite.nvl(rec.get('OUT_WH_CODE'),rec.get('REF_WH_CODE')),
					ISSUE_REQ_QTY	: rec.get('ORDER_Q'),
					ISSUE_REQ_PRICE : rec.get('ORDER_P') *  rec.get('REF_EXCHG_RATE_O'),
					ISSUE_REQ_AMT	: (rec.get('ORDER_P') *  rec.get('REF_EXCHG_RATE_O')) *  rec.get('ORDER_Q') ,
					TAX_TYPE		: rec.get('TAX_TYPE'),
					ISSUE_REQ_TAX_AMT : rec.get('ORDER_TAX_O') *  rec.get('REF_EXCHG_RATE_O'),
					ISSUE_QTY		: 0,
					ORDER_NUM		:  rec.get('ORDER_NUM'),
					INOUT_TYPE_DETAIL: rec.get('INOUT_TYPE_DETAIL'),
					ISSUE_DIV_CODE	: outDivCode,
					EXCHANGE_RATE	: rec.get('REF_EXCHG_RATE_O'),
					DISCOUNT_RATE	: 0,
					ISSUE_REQ_DATE	: shipDate,
					DEPT_CODE		: '*',
					ISSUE_REQ_PRSN  : shipPrsn,
					SALE_CUSTOM_CODE: customCode,
					SALE_CUSTOM_NAME: customName,
					REF_AGENT_TYPE	: CustomCodeInfo.gsAgentType,
					REF_WON_CALC_TYPE: CustomCodeInfo.gsUnderCalBase,
					ISSUE_DATE		: shipDate,
					ACCOUNT_YNC	 : 'Y',
					PRE_ACCNT_YN	: 'Y',
					REF_FLAG			: 'F',
					PRICE_YN			: '2',
					TREE_NAME		: 'N',
					AMEND_YN		: 'N',

					SER_NO	:	rec.get('SER_NO'),
					ORDER_Q	:	rec.get('ORDER_Q'),
					RETURN_Q	:	rec.get('RETURN_Q'),
					DVRY_DATE	:	UniDate.getDateStr(rec.get('DVRY_DATE')),

					ISSUE_FOR_PRICE	:	rec.get('ORDER_P'),
					ISSUE_VOL_Q	:	rec.get('ORDER_Q'),
					ISSUE_FOR_AMT	:	rec.get('ORDER_O'),
					UNIT_VOL	:	rec.get('UNIT_VOL'),
					TREE_NAME	:	'*',
					MONEY_UNIT	:	rec.get('REF_MONEY_UNIT'),
					TAX_INOUT	:	taxInout,
					STOCK_UNIT	:	rec.get('STOCK_UNIT'),
/* 					NOTOUT_Q	:	rec.get('NOTOUT_Q'),
					REF_AGENT_TYPE	:	rec.get('REF_AGENT_TYPE'),
					REF_WON_CALC_TYPE	:	rec.get('REF_WON_CALC_TYPE'), */
					GUBUN	:	'FEFER'
				}

				detailGrid.createRow(r, 'CUSTOM_CODE', seq-2);
				masterForm.setAllFieldsReadOnly(true);
				var newRecord = detailGrid.getSelectedRecord();
				newRecord.set('REF_CODE2',newRecord.get('INOUT_TYPE_DETAIL'));
//				UniAppManager.app.fnGetSubCode(newRecord, newRecord.get('INOUT_TYPE_DETAIL'));
				UniAppManager.app.fnAccountYN(newRecord, newRecord.get('INOUT_TYPE_DETAIL'));
//				UniAppManager.app.fnWhCd(newRecord,0);
				});
			}
		},
		onNewDataButtonDown: function(rowIndex) {
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				 addChk = 'Y';
				 var shipNum = masterForm.getValue('ISSUE_REQ_NUM')

				 var seq = detailStore.max('ISSUE_REQ_SEQ');
				 var addIndex = 0;
					if(!seq) seq = 1;
					 else  seq += 1;
				if(Ext.isEmpty(rowIndex)){
					addIndex =  seq-2
				}else{
					addIndex = rowIndex
				}

				 var customCode='';
				 var customName='';
				 if(Ext.isEmpty(masterForm.getValue('ISSUE_REQ_NUM'))) {
					customCode=masterForm.getValue('CUSTOM_CODE');
					customName=masterForm.getValue('CUSTOM_NAME');
				 }

				 var orderType = masterForm.getValue('ORDER_TYPE');

				 var billType='10';
//				 if(orderType == '60') {
//					billType='50';
//				 }else if(orderType == '80') {
//					billType='60';
//				 }else if(orderType == '81') {
//					billType='50';
//				 }
				 var shipDate = UniDate.getDbDateStr(masterForm.getValue('SHIP_DATE'));
				 outDivCode = masterForm.getValue('DIV_CODE');
				 var shipPrsn = masterForm.getValue('SHIP_PRSN');
				 var whCode = masterForm.getValue('WH_CODE');
				 var r = {
					DIV_CODE		: outDivCode,
					ISSUE_REQ_METH  :'2',
					ISSUE_REQ_NUM	: shipNum,
					ISSUE_REQ_SEQ	: seq,
					CUSTOM_CODE		: customCode,
					CUSTOM_NAME		: customName,
					ORDER_TYPE		: orderType,
					BILL_TYPE		: billType,
					INOUT_TYPE_DETAIL: '10',
//					REF_CODE2		: r.INOUT_TYPE_DETAIL,
					ISSUE_DIV_CODE	: outDivCode,
//					WH_CODE		 : fnWhCd(0),
					TRANS_RATE	: 1,
					ISSUE_REQ_QTY	: 0,
					ISSUE_REQ_PRICE : 0,
					ISSUE_REQ_AMT	: 0,
					ISSUE_REQ_TAX_AMT : 0,
					ISSUE_QTY		: 0,
					MONEY_UNIT 		: BsaCodeInfo.gsMoneyUnit,
					EXCHANGE_RATE	: 1,
					DISCOUNT_RATE	: 0,
					ISSUE_REQ_DATE	: shipDate,
					DEPT_CODE		: '*',
					ISSUE_REQ_PRSN  : shipPrsn,
					SALE_CUSTOM_CODE: customCode,
					SALE_CUSTOM_NAME: customName,
					REF_AGENT_TYPE	: CustomCodeInfo.gsAgentType,
					REF_WON_CALC_TYPE: CustomCodeInfo.gsUnderCalBase,
					ISSUE_DATE		: shipDate,
					ACCOUNT_YNC	 : 'Y',
					PRE_ACCNT_YN	: 'Y',
					REF_FLAG			: 'F',
					PRICE_YN			: '2',
					ISSUE_QTY		: 0,
					TREE_NAME		: 'N',
					AMEND_YN		: 'N',
					WH_CODE		: whCode
				};
				detailGrid.createRow(r, 'CUSTOM_CODE', addIndex);
				masterForm.setAllFieldsReadOnly(true);
				var newRecord = detailGrid.getSelectedRecord();
				newRecord.set('REF_CODE2',newRecord.get('INOUT_TYPE_DETAIL'));
//				UniAppManager.app.fnGetSubCode(newRecord, newRecord.get('INOUT_TYPE_DETAIL'));
				UniAppManager.app.fnAccountYN(newRecord, newRecord.get('INOUT_TYPE_DETAIL'));
//				UniAppManager.app.fnWhCd(newRecord,0);
				UniAppManager.setToolbarButtons(['deleteAll'], true);
			},
		onResetButtonDown: function() {
			this.suspendEvents();
			//masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
//			if(detailStore.data.length == 0) {
//				alert('출하지시 목록을 입력하세요.');
//				return;
//			}
			detailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('ISSUE_QTY') > 0  ) {
					alert('<t:message code="system.message.sales.datacheck007" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
				}else {
					detailGrid.deleteSelectedRow();
				}
			}
		},
		onDeleteAllButtonDown: function() {
			if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
				detailGrid.reset();
				UniAppManager.app.onSaveDataButtonDown('no');
				UniAppManager.app.onResetButtonDown();
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('s_srq110ukrv_inAdvanceSerch');
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

			detailStore.onStoreActionEnable();

		},
		confirmSaveData: function(config) {
			if(detailStore.isDirty() ) {
				if(confirm('<t:message code="system.message.sales.message021" default="변경된 내용을 저장하시겠습니까?"/>')) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
			//masterForm.setValue('DIV_CODE',UserInfo.divCode);
			//masterForm.setValue('SHIP_DATE',new Date());
			masterForm.setValue('ISSUE_REQ_NUM','');
			masterForm.setValue('CUSTOM_CODE','');
			masterForm.setValue('CUSTOM_NAME','');
			masterForm.setValue('BARCODE','');
			masterForm.setValue('ITEM_BARCODE','');
			masterForm.setValue('WH_CODE','30000');
			//FIX ME
			/*	'사업장 권한 설정
				If gsAuParam(0) <> "N" Then
					txtDivCode.disabled = True
					btnDivCode.disabled = True
				End If
			 */
			if(BsaCodeInfo.gsAutoType=='Y') {
				masterForm.getField('ISSUE_REQ_NUM').setReadOnly(true);
			} else {
				masterForm.getField('ISSUE_REQ_NUM').setReadOnly(false);
			}

			detailGrid.disabledLinkButtons(true);

			masterForm.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);
			//20170518 - masterForm.getValue('EXCHAGE_RATE') 존재하지 않음
//			masterForm.setValue('EXCHAGE_RATE', 1);

			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons(['save','deleteAll'], false);
			masterForm.getField('BARCODE').focus();

		},
		checkForNewDetail:function() {
			/**
			 * 마스터 데이타  validation 및 readonly 설정
			 */
			return masterForm.setAllFieldsReadOnly(true);
		},
		fnOrderAmtCal: function(rtnRecord, sType, fieldName, nValue) {
			var dTransRate= fieldName=='TRANS_RATE' ? nValue : Unilite.nvl(rtnRecord.get('TRANS_RATE'),1);

			var dIssueReqQ= fieldName=='ISSUE_REQ_QTY' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_REQ_QTY'),0);
			var dIssueReqVolQ = fieldName=='ISSUE_VOL_Q' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_VOL_Q'),0);
			var dIssueReqWgtQ = fieldName=='ISSUE_WGT_Q' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_WGT_Q'),0);

			var dOrderP= fieldName=='ISSUE_REQ_PRICE' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_REQ_PRICE'),0);
			var dOrderWgtP= fieldName=='ISSUE_WGT_P' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_WGT_P'),0);
			var dOrderVolP= fieldName=='ISSUE_VOL_P' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_VOL_P'),0);
			var dOrderForP= fieldName=='ISSUE_FOR_PRICE' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_FOR_PRICE'),0);
			var dOrderWgtForP= fieldName=='ISSUE_FOR_WGT_P' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_FOR_WGT_P'),0);
			var dOrderVolForP= fieldName=='ISSUE_FOR_VOL_P' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_FOR_VOL_P'),0);

			var dExchgRate= fieldName=='EXCHANGE_RATE' ? nValue : Unilite.nvl(rtnRecord.get('EXCHANGE_RATE'),0);
			var dOrderO= fieldName=='ISSUE_REQ_AMT' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_REQ_AMT'),0);
			var dOrderForO= fieldName=='ISSUE_FOR_AMT' ? nValue : Unilite.nvl(rtnRecord.get('ISSUE_FOR_AMT'),0);
			var dDCRate= fieldName=='DISCOUNT_RATE' ? nValue : Unilite.nvl(rtnRecord.get('DISCOUNT_RATE'),0);
			var dUnitWgt= fieldName=='UNIT_WGT' ? nValue : Unilite.nvl(rtnRecord.get('UNIT_WGT'),0);
			var dUnitVol= fieldName=='UNIT_VOL' ? nValue : Unilite.nvl(rtnRecord.get('UNIT_VOL'),0);

			var dPriceType= Unilite.nvl(rtnRecord.get('UNIT_VOL'),'A');

			if(sType == 'P' || sType == 'Q') {	//업종별 프로세스 적용
				dOrderP	= dOrderForP	* dExchgRate;
				dOrderWgtP = dOrderWgtForP * dExchgRate;
				dOrderVolP = dOrderVolForP * dExchgRate;

				if(dPriceType == 'A') 	{
					dOrderForO = dIssueReqQ * dOrderForP;
					dOrderO	= dIssueReqQ * dOrderP;
				}else if( dPriceType == 'B') {
					dOrderForO = dIssueReqWgtQ * dOrderWgtForP;
					dOrderO	= dIssueReqWgtQ * dOrderWgtP;
				}else if( dPriceType == 'C') {
					dOrderForO = dIssueReqVolQ * dOrderVolForP;
					dOrderO	= dIssueReqVolQ * dOrderVolP;
				}else {
					dOrderForO = dIssueReqQ * dOrderForP;
					dOrderO	= dIssueReqQ * dOrderP;
				}
				rtnRecord.set('ISSUE_FOR_AMT', dOrderForO);
				rtnRecord.set('ISSUE_FOR_PRICE', dOrderForP);
				rtnRecord.set('ISSUE_FOR_WGT_P', dOrderWgtForP);
				rtnRecord.set('ISSUE_FOR_VOL_P', dOrderVolForP);

				rtnRecord.set('ISSUE_REQ_AMT', dOrderO);
				rtnRecord.set('ISSUE_REQ_PRICE', dOrderP);
				rtnRecord.set('ISSUE_WGT_P', dOrderWgtP);
				rtnRecord.set('ISSUE_VOL_P', dOrderVolP);
				UniAppManager.app.fnTaxCalculate(rtnRecord, dOrderO)
			}  else if(sType == 'O') {
				//단가/세액 재계산
				if( dIssueReqQ > 0 ) {
					//단가 재계산
					dOrderForP	= (dOrderForO / dIssueReqQ) ;
					dOrderP	= (dOrderForO / dIssueReqQ) * dExchgRate;
					if(dIssueReqWgtQ != 0 ) {
						dOrderWgtForP = (dOrderForO / dIssueReqWgtQ);
						dOrderWgtP= (dOrderForO / dIssueReqWgtQ) * dExchgRate;
					}
					if(dIssueReqVolQ != 0 ) {
						dOrderVolForP = (dOrderForO / dIssueReqVolQ);
						 dOrderVolP = (dOrderForO / dIssueReqVolQ) * dExchgRate;
					}

					if( dPriceType == 'A') {
						dOrderO = dOrderP * dIssueReqQ ;
						dOrderForO = dOrderForP * dIssueReqQ ;
					} else if( dPriceType == 'B') {

						dOrderO = dOrderWgtP * dIssueReqWgtQ  ;
						dOrderForO = dOrderWgtForP * dIssueReqWgtQ;
					} else if( dPriceType == 'C') {
						dOrderO = dOrderVolP * dIssueReqVolQ  ;
						dOrderForO = dOrderVolForP * dIssueReqVolQ;
					} else {
						dOrderO = dOrderP * dIssueReqQ  ;
						dOrderForO = dOrderForP * dIssueReqQ;
					}

					rtnRecord.set('ISSUE_REQ_PRICE', dOrderP);
					rtnRecord.set('ISSUE_WGT_P', dOrderWgtP);
					rtnRecord.set('ISSUE_VOL_P', dOrderVolP);
					rtnRecord.set('ISSUE_REQ_AMT', dOrderO);

					rtnRecord.set('ISSUE_FOR_PRICE', dOrderForP);
					rtnRecord.set('ISSUE_FOR_WGT_P', dOrderWgtForP);
					rtnRecord.set('ISSUE_FOR_VOL_P', dOrderVolForP);
					rtnRecord.set('ISSUE_FOR_AMT', dOrderForO);

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

			if ( Ext.isEmpty(rtnRecord.get("ORDER_NUM")) ) {
				//할인율 변경시, 단가/금액/세액 재계산
				rtnRecord.set('AMEND_YN', 'Y');
				rtnRecord.set('TREE_NAME', 'Y');		//부서명 : 할인율 적용여부 SET(N:미수정/Y:수정)

				if( dSaleP == 0 ) {
					return;
				}

				if( dOrderP == 0 || dOrderP != dSaleP ) {
					// 단가 = 판매단가 - ( 판매단가 * 할인율 / 100 )
					dOrderP = dSaleP - ( dSaleP * ( dDCRate / 100 ) );
				} else {
					// 단가 = 단가 - ( 단가 * 할인율 / 100 )
					dOrderP = dOrderP - ( dOrderP * ( dDCRate / 100 ) );
				}

				if( dOrderWgtP == 0 || dOrderWgtP != dSaleP ) {
					// 단가 = 판매단가 - ( 판매단가 * 할인율 / 100 )
					dOrderWgtP = dSaleP - ( dSaleP * ( dDCRate / 100 ) );
				} else {
					// 단가 = 단가 - ( 단가 * 할인율 / 100 )
					dOrderWgtP = dOrderWgtP - ( dOrderWgtP * ( dDCRate / 100 ) );
				}

				if ( dOrderVolP == 0 || dOrderVolP != dSaleP ) {
					// 단가 = 판매단가 - ( 판매단가 * 할인율 / 100 )
					dOrderVolP = dSaleP - ( dSaleP * ( dDCRate / 100 ) )
				} else {
					// 단가 = 단가 - ( 단가 * 할인율 / 100 )
					dOrderVolP = dOrderVolP - ( dOrderVolP * ( dDCRate / 100 ) )
				}

				dOrderP		= dOrderP	* dExchgRate;
				dOrderWgtP	= dOrderWgtP * dExchgRate;
				dOrderVolP	= dOrderVolP * dExchgRate	;

				if (dPriceType == 'A') {
					dOrderO	= dIssueReqQ * dOrderP;
					dOrderForO = dIssueReqQ * dOrderForP;
				} else  if (dPriceType == 'B') {
					dOrderO	= dIssueReqWgtQ * dOrderWgtP;
					dOrderForO = dIssueReqWgtQ * dOrderWgtForP;
				} else  if (dPriceType == 'C') {
					dOrderO	= dIssueReqVolQ * dOrderVolP;
					dOrderForO = dIssueReqVolQ * dOrderVolForP;
				} else	{
					dOrderO	= dIssueReqQ * dOrderP;
					dOrderForO = dIssueReqQ * dOrderForP;
				}


				rtnRecord.set('ISSUE_FOR_PRICE', dOrderForP);
				rtnRecord.set('ISSUE_FOR_WGT_P', dOrderWgtForP);
				rtnRecord.set('ISSUE_FOR_VOL_P', dOrderVolForP);
				rtnRecord.set('ISSUE_FOR_AMT', dOrderForO);

				rtnRecord.set('ISSUE_REQ_PRICE', dOrderP);
				rtnRecord.set('ISSUE_WGT_P', dOrderWgtP);
				rtnRecord.set('ISSUE_VOL_P', dOrderVolP);
				rtnRecord.set('ISSUE_REQ_AMT', dOrderO);
				UniAppManager.app.fnTaxCalculate(rtnRecord, dOrderO)
			}
		},
		fnTaxCalculate: function(rtnRecord, dOrderO) {
			var sTaxType = rtnRecord.get('TAX_TYPE');
			var sUnderCalcType = rtnRecord.get('REF_WON_CALC_TYPE');

			var sTaxInoutType = Unilite.nvl(rtnRecord.get('TAX_INOUT'), '1');

			var dVatRate = parseInt(BsaCodeInfo.gsVatRate);
			var dAmountI = dOrderO;

			var dIRAmtO = 0;
			var dTaxAmtO = 0;

			if(sTaxInoutType=="1") {
				dIRAmtO = dOrderO;
				dTaxAmtO	= dOrderO * (dVatRate / 100)
				dIRAmtO = UniSales.fnAmtWonCalc(dIRAmtO,sUnderCalcType);

				if(UserInfo.compCountry == 'CN') {
					dTaxAmtO	= UniSales.fnAmtWonCalc(dTaxAmtO, sUnderCalcType);								//세액은 절사처리함.
				} else {
					dTaxAmtO	= UniSales.fnAmtWonCalc(dTaxAmtO, sUnderCalcType);								//세액은 절사처리함.
				}
			} else if(sTaxInoutType=="2") {
				if(UserInfo.compCountry == 'CN') {
					dTemp	= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, "3");		//세액은 절사처리함.
					dTaxAmtO	= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, "3");						//세액은 절사처리함.
				} else {
					//20191212 수정: '2' -> sUnderCalcType
					dTemp	= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, sUnderCalcType);
					dTaxAmtO	= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, sUnderCalcType);
				}
				dIRAmtO = UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), sUnderCalcType) ;
			}
			if(sTaxType == "2") {
				dIRAmtO = UniSales.fnAmtWonCalc(dOrderO, sUnderCalcType ) ;
				dTaxAmtO = 0;
			}
			rtnRecord.set('ISSUE_REQ_AMT',dIRAmtO);
			rtnRecord.set('ISSUE_REQ_TAX_AMT',dTaxAmtO);
		},

		fnCheckNum: function(value, record, fieldName) {
			var r = true;
			if(record.get("PRICE_YN") == "1" || record.get("ACCOUNT_YNC")=="N") {
				r = true;
			} else if(record.get("PRICE_YN") == "2" ) {
				if(value < 0) {
					alert('<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>');
					r=false;
					return r;
				}else if(value == 0) {
					if(fieldName == "ISSUE_REQ_TAX_AMT") {
						if(BsaCodeInfo.gsVatRate != 0) {
							alert('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
							r=false;
						}
					}else if(fieldName == "ISSUE_REQ_PRICE" || fieldName == "ISSUE_REQ_AMT") {
						if( record.get("ACCOUNT_YNC")=="Y") {
							alert('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
							r=false;
						}
					}else {
						alert('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
						r=false;
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
			rtnRecord.set('WH_CODE',fRecord);
		},
		// UniSales.fnGetPriceInfo callback 함수
		cbGetPriceInfo: function(provider, params) {
			var dSalePrice=Unilite.nvl(provider['SALE_PRICE'],0);

			var dWgtPrice = Unilite.nvl(provider['WGT_PRICE'],0);//판매단가(중량단위)
			var dVolPrice = Unilite.nvl(provider['VOL_PRICE'],0);//판매단가(부피단위)

			if(params.sType=='I') {

				//단가구분별 판매단가 계산
				if(params.priceType == 'A') {							//단가구분(판매단위)
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					dVolPrice  = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
					params.rtnRecord.set('SALE_P', dSalePrice);
				}else if(params.priceType == 'B') {						//단가구분(중량단위)
					dSalePrice = dWgtPrice  * params.unitWgt
					dVolPrice  = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
					params.rtnRecord.set('SALE_P', dWgtPrice);
				}else if(params.priceType == 'C') {						//단가구분(부피단위)
					dSalePrice = dVolPrice  * params.unitVol;
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					params.rtnRecord.set('SALE_P', dVolPrice);
				}else {
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					dVolPrice = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
					params.rtnRecord.set('SALE_P', dSalePrice);
				}

				if(params.bOpt == null || params.bOpt == "") {

					params.rtnRecord.set('ISSUE_REQ_PRICE', dSalePrice);
					params.rtnRecord.set('ISSUE_WGT_P', dWgtPrice);
					params.rtnRecord.set('ISSUE_VOL_P', dVolPrice);
					params.rtnRecord.set('TRANS_RATE',provider['SALE_TRANS_RATE']);
					params.rtnRecord.set('DISCOUNT_RATE',provider['DC_RATE']);

					//20170518 - masterForm.getValue('EXCHAGE_RATE') 존재하지 않음
					/*var exchangRate = masterForm.getValue('EXCHAGE_RATE');
					params.rtnRecord.set('ISSUE_FOR_PRICE', dSalePrice / exchangRate);
					params.rtnRecord.set('ISSUE_FOR_WGT_P', dWgtPrice / exchangRate);
					params.rtnRecord.set('ISSUE_FOR_VOL_P', dVolPrice / exchangRate);*/

				}
				params.rtnRecord.set('AMEND_YN', 'N');
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
			var rtnRecord = params.rtnRecord;

			var dStockQ = Unilite.nvl(provider['STOCK_Q'], 0);
			var dOrderQ = Unilite.nvl(rtnRecord.get('ORDER_Q'), 0);
			var lTrnsRate = rtnRecord.get('TRANS_RATE');

			rtnRecord.set('STOCK_Q', dStockQ / lTrnsRate);
			rtnRecord.commit();
		},
		//수주 데이터 참조시
		fnMakeSof100tDataRef: function(records) {
			if(!this.checkForNewDetail()) return false;
			/**
			 * Detail Grid Default 값 설정
			 */
			 var newDetailRecords = new Array();
			 var seq = 0;
			 seq = detailStore.max('ISSUE_REQ_SEQ');

			 if(Ext.isEmpty(seq)){
					seq = 1;
			 }else{
					seq = seq + 1;
			 }

			 Ext.each(records, function(record,i){
				 var shipNum = masterForm.getValue('ISSUE_REQ_NUM')
				 var customCode='';
				 var customName='';
				 if(i == 0){
					 seq = seq;
				 }else{
					 seq += 1;
				 }

				 if(Ext.isEmpty(masterForm.getValue('ISSUE_REQ_NUM'))) {
					customCode=masterForm.getValue('CUSTOM_CODE');
					customName=masterForm.getValue('CUSTOM_NAME');
				 }
				 var orderType = masterForm.getValue('ORDER_TYPE');

				 var billType='10';
//				 if(orderType == '60') {
//					billType='50';
//				 }else if(orderType == '80') {
//					billType='60';
//				 }else if(orderType == '81') {
//					billType='50';
//				 }
				 var shipDate = UniDate.getDbDateStr(masterForm.getValue('SHIP_DATE'));
				 outDivCode = masterForm.getValue('DIV_CODE');
				 var shipPrsn = masterForm.getValue('SHIP_PRSN');
				 var whCode = masterForm.getValue('WH_CODE');
				 var r = {
							'DIV_CODE'		: outDivCode,
							'ISSUE_REQ_METH'  :'2',
							'ISSUE_REQ_NUM'	: shipNum,
							'ISSUE_REQ_SEQ'	: seq,
							'CUSTOM_CODE'		: customCode,
							'CUSTOM_NAME'		: customName,
							'ORDER_TYPE'		: orderType,
							'BILL_TYPE'		: billType,
							'INOUT_TYPE_DETAIL': '10',
//							'REF_CODE2		: r.INOUT_TYPE_DETAIL,
							'ISSUE_DIV_CODE	': outDivCode,
//							'WH_CODE		 : fnWhCd(0),
							'TRANS_RATE'	: 1,
							'ISSUE_REQ_QTY'	: 0,
							'ISSUE_REQ_PRICE' : 0,
							'ISSUE_REQ_AMT'	: 0,
							'ISSUE_REQ_TAX_AMT' : 0,
							'ISSUE_QTY'		: 0,
							'MONEY_UNIT' 		: BsaCodeInfo.gsMoneyUnit,
							'EXCHANGE_RATE'	: 1,
							'DISCOUNT_RATE'	: 0,
							'ISSUE_REQ_DATE'	: shipDate,
							'DEPT_CODE'		: '*',
							'ISSUE_REQ_PRSN'  : shipPrsn,
							'SALE_CUSTOM_CODE': customCode,
							'SALE_CUSTOM_NAME': customName,
							'REF_AGENT_TYPE'	: CustomCodeInfo.gsAgentType,
							'REF_WON_CALC_TYPE': CustomCodeInfo.gsUnderCalBase,
							'ISSUE_DATE'		: shipDate,
							'ACCOUNT_YNC'	 : 'Y',
							'PRE_ACCNT_YN'	: 'Y',
							'REF_FLAG'		: 'F',
							'PRICE_YN'			: '2',
							'ISSUE_QTY'		: 0,
							'TREE_NAME'		: 'N',
							'AMEND_YN'		: 'N'
						};

					///	detailGrid.createRow(r, 'CUSTOM_CODE', seq-2);
						newDetailRecords[i] = detailStore.model.create( r );

						masterForm.setAllFieldsReadOnly(true);
					//	var newRecord = detailGrid.getSelectedRecord();
						newDetailRecords[i].set('REF_CODE2',newDetailRecords[i].get('INOUT_TYPE_DETAIL'));
//						UniAppManager.app.fnGetSubCode(newRecord, newRecord.get('INOUT_TYPE_DETAIL'));
						UniAppManager.app.fnAccountYN(newDetailRecords[i], newDetailRecords[i].get('INOUT_TYPE_DETAIL'));
//						UniAppManager.app.fnWhCd(newRecord,0);
						UniAppManager.setToolbarButtons(['deleteAll'], true);

						newDetailRecords[i].set('ISSUE_REQ_DATE'		, UniDate.getDbDateStr(masterForm.getValue('SHIP_DATE')));

						newDetailRecords[i].set('CUSTOM_CODE'			, record.get('CUSTOM_CODE'));
						newDetailRecords[i].set('CUSTOM_NAME'			, record.get('CUSTOM_NAME'));

//						var orderType = masterForm.getValue('ORDER_TYPE');
//						if(orderType == '80') {
//							newDetailRecords[i].set('BILL_TYPE'		, '60');
//						}else if(orderType == '81') {
//							newDetailRecords[i].set('BILL_TYPE'		, '50');
//						}else {
//							newDetailRecords[i].set('BILL_TYPE'		, record.get('BILL_TYPE']);
//						}
						newDetailRecords[i].set('BILL_TYPE'		, record.get('BILL_TYPE'));
						newDetailRecords[i].set('ORDER_TYPE'			, record.get('ORDER_TYPE'));
						newDetailRecords[i].set('SALE_CUSTOM_CODE'			, record.get('SALE_CUST_CD'));
						newDetailRecords[i].set('SALE_CUSTOM_NAME'			, record.get('SALE_CUST_NAME'));

						newDetailRecords[i].set('ISSUE_DIV_CODE'		, record.get('OUT_DIV_CODE'));
						if(Ext.isEmpty(whCode)){
							newDetailRecords[i].set('WH_CODE'				, Unilite.nvl(record.get('WH_CODE'),record.get('REF_WH_CODE')));
						}else{
							newDetailRecords[i].set('WH_CODE'				, whCode);
						}

						newDetailRecords[i].set('ITEM_CODE'			, record.get('ITEM_CODE'));
						newDetailRecords[i].set('ITEM_NAME'			, record.get('ITEM_NAME'));
						newDetailRecords[i].set('SPEC'				, record.get('SPEC'));
						newDetailRecords[i].set('ORDER_UNIT'			, record.get('ORDER_UNIT'));
						newDetailRecords[i].set('TRANS_RATE'			, record.get('TRANS_RATE'));
						newDetailRecords[i].set('STOCK_Q'				, record.get('STOCK_Q'));
						newDetailRecords[i].set('NOTOUT_Q'				, record.get('NOTOUT_Q'));
						newDetailRecords[i].set('ISSUE_REQ_QTY'			, record.get('NOTOUT_Q'));

						newDetailRecords[i].set('ISSUE_REQ_PRICE'			, record.get('ORDER_P'));
						newDetailRecords[i].set('ISSUE_REQ_AMT'			, record.get('ORDER_O'));

						newDetailRecords[i].set('EXCHANGE_RATE'			, record.get('REF_EXCHG_RATE_O'));
						newDetailRecords[i].set('ISSUE_FOR_PRICE'			, record.get('ORDER_FOR_P'));
						newDetailRecords[i].set('ISSUE_FOR_AMT'			, record.get('ORDER_FOR_O'));
						newDetailRecords[i].set('TAX_TYPE'			, record.get('TAX_TYPE'));

						newDetailRecords[i].set('ISSUE_REQ_TAX_AMT'			, record.get('ORDER_TAX_O'));
						newDetailRecords[i].set('ISSUE_DATE'			, record.get('DVRY_DATE'));
						newDetailRecords[i].set('ISSUE_FOR_AMT'			, record.get('ORDER_FOR_O'));
						newDetailRecords[i].set('DELIVERY_TIME'			, record.get('DVRY_TIME'));


						newDetailRecords[i].set('DISCOUNT_RATE'			, record.get('DISCOUNT_RATE'));
						newDetailRecords[i].set('PRICE_YN'			, record.get('PRICE_YN'));
						newDetailRecords[i].set('ACCOUNT_YNC'			, record.get('ACCOUNT_YNC'));
						newDetailRecords[i].set('DVRY_CUST_CD'			, record.get('DVRY_CUST_CD'));

						newDetailRecords[i].set('DVRY_CUST_NAME'			, record.get('DVRY_CUST_NAME'));
						newDetailRecords[i].set('PROJECT_NO'			, record.get('PROJECT_NO'));
						newDetailRecords[i].set('PO_NUM'			, record.get('PO_NUM'));
						newDetailRecords[i].set('PO_SEQ'			, record.get('PO_SEQ'));

						newDetailRecords[i].set('ORDER_NUM'			, record.get('ORDER_NUM'));
						newDetailRecords[i].set('SER_NO'			, record.get('SER_NO'));
						newDetailRecords[i].set('REMARK'			, record.get('REMARK'));
						newDetailRecords[i].set('TREE_NAME'			, '*');

						newDetailRecords[i].set('MONEY_UNIT'			, record.get('REF_MONEY_UNIT'));
//						newDetailRecords[i].set('ISSUE_QTY'			, record.get('OUTSTOCK_Q']);
//						newDetailRecords[i].set('RETURN_Q'			, record.get('RETURN_Q']);
						newDetailRecords[i].set('ORDER_Q'			, record.get('ORDER_Q'));

						newDetailRecords[i].set('ISSUE_REQ_Q'			, record.get('ISSUE_REQ_Q'));
						newDetailRecords[i].set('DVRY_DATE'			, record.get('DVRY_DATE'));
						newDetailRecords[i].set('DVRY_TIME'			, record.get('DVRY_TIME'));
						newDetailRecords[i].set('TAX_INOUT'			, record.get('TAX_INOUT'));

						newDetailRecords[i].set('STOCK_UNIT'			, record.get('STOCK_UNIT'));
						newDetailRecords[i].set('PRE_ACCNT_YN'			, record.get('ACCOUNT_YNC'));
						newDetailRecords[i].set('REF_AGENT_TYPE'			, record.get('REF_AGENT_TYPE'));
						newDetailRecords[i].set('REF_WON_CALC_TYPE'			, record.get('REF_WON_CALC_TYPE'));
						newDetailRecords[i].set('REF_LOC'			, record.get('REF_LOC'));
						newDetailRecords[i].set('PAY_METHODE1'			, record.get('PAY_METHODE1'));
						newDetailRecords[i].set('LC_SER_NO'			, record.get('LC_SER_NO'));
						newDetailRecords[i].set('ISSUE_WGT_Q'			, record.get('ORDER_WGT_Q'));
						newDetailRecords[i].set('ISSUE_VOL_Q'			, record.get('ORDER_VOL_Q'));
						newDetailRecords[i].set('PRICE_TYPE'			, record.get('PRICE_TYPE'));
						newDetailRecords[i].set('ISSUE_FOR_WGT_P'			, record.get('ORDER_FOR_WGT_P'));
						newDetailRecords[i].set('ISSUE_FOR_VOL_P'			, record.get('ORDER_FOR_VOL_P'));
						newDetailRecords[i].set('ISSUE_WGT_P'			, record.get('ORDER_WGT_P'));
						newDetailRecords[i].set('ISSUE_VOL_P'			, record.get('ORDER_VOL_P'));
						newDetailRecords[i].set('WGT_UNIT'			, record.get('WGT_UNIT'));
						newDetailRecords[i].set('UNIT_WGT'			, record.get('UNIT_WGT'));
						newDetailRecords[i].set('VOL_UNIT'			, record.get('VOL_UNIT'));
						newDetailRecords[i].set('UNIT_VOL'			, record.get('UNIT_VOL'));
						newDetailRecords[i].set('GUBUN'				, 'FEFER');
						newDetailRecords[i].set('INOUT_TYPE_DETAIL'	, record.get('INOUT_TYPE_DETAIL'));
						newDetailRecords[i].set('LOT_NO'	, record.get('LOT_NO'));
						newDetailRecords[i].set('REMARK_INTER'			, record.get('REMARK_INTER'));
						//newDetailRecords[i].set('WH_CODE'	, whCode);
						CustomCodeInfo.gsAgentType = record.get('REF_AGENT_TYPE');
						CustomCodeInfo.gsUnderCalBase = record.get('REF_WON_CALC_TYPE');

						var orderQ = record.get('ORDER_Q');
						if(orderQ != record.get('NOTOUT_Q')) {
							UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "Q")
						}
						UniAppManager.app.fnOrderAmtCal(newDetailRecords[i], "Q")
						UniSales.fnStockQ(newDetailRecords[i], UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('OUT_DIV_CODE'), null,record.get('ITEM_CODE'),record.get('WH_CODE'))	;


			 });
				detailStore.loadData(newDetailRecords, true);

		}
	});

	//바코드 입력 로직 (거래처코드 수주기반 데이터 조회)
	function fnEnterBarcode(newValue) {
		searchGBN = '2';
		detailStore.loadStoreRecords();
	}

  //품목바코드 입력 로직
	function fnEnterItemBarcode(newValue) {
		 var barcodeItemCode = newValue.split('|')[0].toUpperCase();
		 var barcodeLotNo	= newValue.split('|')[1];
		 var barcodeInoutQ	= newValue.split('|')[2];
		 var flag = true;

		 if(!Ext.isEmpty(barcodeLotNo)) {
			 barcodeLotNo = barcodeLotNo.toUpperCase();
		 } else {
			 barcodeItemCode = '';
			 barcodeLotNo	= newValue.split('|')[0].toUpperCase();
			 barcodeInoutQ	= 0;
		 }

		 //동일한 LOT_NO 입력되었을 경우 처리
		 var records  = detailStore.data.items;		//비교할 records 구성
		 Ext.each(records, function(record, i) {
			 if(record.get('LOT_NO').toUpperCase() == barcodeLotNo && record.get('ITEM_CODE') == barcodeItemCode) {
				 beep();
				 gsText = '<t:message code="system.label.sales.message005" default="동일한  Lot No.(이)가 이미 등록되었습니다."/>';
				 openAlertWindow(gsText);
				 masterForm.setValue('ITEM_BARCODE', '');
				 flag = false;
				 return false;
			 }
		 });
		 if(flag) {
			 var chk = true ;
			 var dIssueReqQ = 0 ;
			 var dOutStockQ = 0;
			 var dCanOutQ = 0;
			 var sUnitWgt = 0;
			 var sOrderWgtQ = 0;
			 var sUnitVol = 0;
			 var sOrderVolQ = 0;
			 Ext.each(records, function(record, i) {
				 if(record.get('ITEM_CODE') == barcodeItemCode && Ext.isEmpty(record.get('LOT_NO'))&& chk == true) {
						 record.set('LOT_NO', barcodeLotNo);
						 record.set('ISSUE_REQ_QTY', barcodeInoutQ);
						//출하지시량
						 dIssueReqQ = Unilite.nvl(barcodeInoutQ, 0);
						//출고량
						 dOutStockQ = Unilite.nvl(record.get('ISSUE_QTY'), 0);
						if(Number(dOutStockQ) > 0) {
							gsText ='<t:message code="system.message.sales.message049" default="출고가 발생한 건은 수정/삭제할 수 없습니다."/>';
							openAlertWindow(gsText);
							return false;
						}
						//수주참조일 때,
						if(!Ext.isEmpty(record.get('ORDER_NUM'))) {
							//미납량(출하가능량)
							dCanOutQ = Unilite.nvl(record.get('NOTOUT_Q'), 0);
								if(Number(dIssueReqQ) > Number(dCanOutQ)) {
									gsText = '<t:message code="system.message.sales.message050" default="출하지시량이 출고가능수량을 초과했습니다."/>';
									openAlertWindow(gsText);
									return false;
								}
						}
						//출하지시량(중량) 재계산
						 sUnitWgt	= record.get('UNIT_WGT');
						 sOrderWgtQ = dIssueReqQ * sUnitWgt;
						record.set('ISSUE_WGT_Q', sOrderWgtQ);


						//출하지시량(부피) 재계산
						 sUnitVol	= record.get('UNIT_VOL');
						 sOrderVolQ = dIssueReqQ * sUnitVol
						record.set('ISSUE_VOL_Q', sOrderVolQ);

						 UniAppManager.app.fnOrderAmtCal(record, "Q", "ISSUE_REQ_QTY", barcodeInoutQ);
						 detailGrid.getSelectionModel().select(i)
						 chk = false;
				 }else{
					return true;
				 }
			 });
			 return;
		 }
	}

	//경고창
	var alertSearch = Unilite.createSearchForm('alertSearch', {
		layout  : {type : 'uniTable', columns : 1
		, tdAttrs: {width: '100%', align : 'center', style: 'background-color: #dfe8f6;'}		//cfd9e7
		},
		items	:[{
			xtype	: 'component',
			itemId  : 'TEXT_TEST',
			width	: 330,
			height  : 50,
			html	: '',
			style	: {
				marginTop	: '3px !important',
				font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
			}
		},{
			xtype	: 'container',
			padding : '0 0 0 0',
			align	: 'center',
			items	: [{
				xtype	: 'button',
				text	: '<t:message code="system.label.sales.confirm" default="확인"/>',
				width	: 80,
				handler : function() {
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
				height  : 120,
				layout  : {type:'vbox', align:'stretch'},
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
					specialkey:function(field, event)	{
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

		gainNode.gain.value = 0.1;			//VOLUME 크기
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
	/**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var records = detailStore.data.items;
			var grdRecord = detailGrid.uniOpt.currentRecord;
			var rowIndex = detailGrid.getStore().indexOf(grdRecord);
			data = new Object();
			data.records = [];
			 Ext.each(records, function(record, i){
				if((detailGrid.getSelectionModel().isSelected(record) == true || i == rowIndex)) {
					data.records.push(record);
				}
			});
			detailGrid.getSelectionModel().select(data.records);

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
					alert('<t:message code="system.message.sales.message046" default="해당 출고유형은 선택할 수 없습니다."/>');
					record.set('INOUT_TYPE_DETAIL',oldValue);
					record.set('REF_CODE2',gsOldRefCode2);
					break;
				} else if(sRefCode2 == '91') {		//폐기
					if(!Ext.isEmpty(record.get('ORDER_NUM'))) {
						alert('<t:message code="system.message.sales.message047" default="출고유형[폐기]는 예외 출고등록만 가능합니다."/>');
						record.set('INOUT_TYPE_DETAIL',oldValue);
						record.set('REF_CODE2',gsOldRefCode2);
						break;
					}
				}

				if(newValue == '') {
					record.set('ACCOUNT_YNC','N');
				}else {
					if(!Ext.isEmpty(record.get('ORDER_NUM'))) {
						UniAppManager.app.fnAccountYN(record, newValue);
					}
				}
				break;
			case 'ISSUE_DIV_CODE':

				if(newValue != oldValue) {
					record.set('ITEM_CODE',	'');
					record.set('SPEC',	'');
					record.set('ORDER_UNIT',	'');
					record.set('STOCK_UNIT',	'');
					record.set('WH_CODE',	'');
					record.set('TAX_TYPE',	'');
					record.set('STOCK_Q',	0);
					record.set('ISSUE_REQ_PRICE',	0);
					record.set('TRANS_RATE',	1);
					record.set('DISCOUNT_RATE',	0);
					record.set('AMEND_YN',	'N');
					record.set('TREE_NAME',	'N');
					record.set('ISSUE_REQ_PRICE',	0);
					record.set('ISSUE_REQ_AMT',	0);
					record.set('ISSUE_REQ_TAX_AMT',	0);
					UniAppManager.app.fnWhCd(newRecord,0);
					outDivCode = newValue;
				}
				break;
		case 'WH_CODE':			//출고창고
			UniSales.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('ISSUE_DIV_CODE'), null, record.get('ITEM_CODE'),  newValue);
			break;
		case "ORDER_UNIT" :
				if(Ext.isEmpty(record.get('CUSTOM_NAME'))) {
					alert('<t:message code="system.message.sales.message048" default="객을 먼저 선택하셔야 합니다."/>');
					break;
				}
				UniSales.fnGetPriceInfo2(record
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
												, UniDate.getDbDateStr(masterForm.getValue('SHIP_DATE'))
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
					alert('<t:message code="system.message.sales.message048" default="고객을 먼저 선택하셔야 합니다."/>');
					break;
				}
				UniSales.fnGetPriceInfo2(record
										,'I'
										,UserInfo.compCode
										,masterForm.getValue('CUSTOM_CODE')
										,CustomCodeInfo.gsAgentType
										,record.get('ITEM_CODE')
										,BsaCodeInfo.gsMoneyUnit
										,record.get('ORDER_UNIT')
										,record.get('STOCK_UNIT')
										,record.get('TRANS_RATE')
										,UniDate.getDbDateStr(masterForm.getValue('SHIP_DATE'))
										,record.get('ORDER_Q')
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
						alert('<t:message code="system.message.sales.message049" default="출고가 발생한 건은 수정/삭제할 수 없습니다."/>');
						break;
					}
				}

				//수주참조일 때,
				if(!Ext.isEmpty(record.get('ORDER_NUM'))) {
					//미납량(출하가능량)
					dCanOutQ = Unilite.nvl(record.get('NOTOUT_Q'), 0);
					if(record.phantom) {
						if(dIssueReqQ > dCanOutQ) {
							alert('<t:message code="system.message.sales.message050" default="출하지시량이 출고가능수량을 초과했습니다."/>');
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
				var records = detailStore.data.items;
				var grdRecord = detailGrid.uniOpt.currentRecord;
				var rowIndex = detailGrid.getStore().indexOf(grdRecord);
				data = new Object();
				data.records = [];
				 Ext.each(records, function(record, i){
					if((detailGrid.getSelectionModel().isSelected(record) == true || i == rowIndex)) {
						data.records.push(record);
					}
				});
				detailGrid.getSelectionModel().select(data.records);

		break;

		case 'ISSUE_REQ_PRICE':
			record.set('ISSUE_FOR_PRICE', newValue / record.get('EXCHANGE_RATE'));
			UniAppManager.app.fnOrderAmtCal(record, "P", fieldName, newValue);
		break;
		case 'ISSUE_REQ_AMT':
			UniAppManager.app.fnOrderAmtCal(record, "O", fieldName, newValue);
		break;

		case 'TAX_TYPE':	//과세구분
			if(newValue == '2') {
				record.set('ISSUE_REQ_TAX_AMT', 0);
			}
			record.set('TAX_TYPE', newValue);
			UniAppManager.app.fnOrderAmtCal(record, 'O', fieldName, newValue);
			break;
	case 'ISSUE_REQ_TAX_AMT':	//세액
			if(! UniAppManager.app.fnCheckNum(newValue, record, fieldName) ) {
				record.set('ISSUE_REQ_TAX_AMT', oldValue);
				break;
			}
		break;
	case 'ISSUE_DATE':  // 출고요청일
			if(Ext.isEmpty(newValue)) {
				record.set('ISSUE_DATE', oldValue);
				break;
			}
			var shipDate = UniDate.getDbDateStr(masterForm.getValue('SHIP_DATE'));
			if(shipDate > newValue) {
				alert('<t:message code="system.message.sales.message007" default="출고예정일은 출하지시일과 같거나 이후이어야 합니다"/>');
				record.set('ISSUE_DATE', oldValue);
				break;
			}
			if(record.get('ISSUE_REQ_METH')== '1') {
				if(record.get('DVRY_DATE') >= shipDate && record.get('DVRY_DATE') < record.get('ISSUE_DATE') ) {
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
				}else {
					record.set('REF_FLAG', 'F');
				}
			}
			break;
		case 'DISCOUNT_RATE':
			if(! UniAppManager.app.fnCheckNum(newValue, record, fieldName) ) {
				record.set('DISCOUNT_RATE', oldValue);
				break;
			}
			UniSales.fnGetPriceInfo2(
				record
				,UniAppManager.app.cbGetPriceInfoR
				,'I'
				,UserInfo.compCode
				,record.get('CUSTOM_CODE')
				,record.get('REF_AGENT_TYPE')
				,record.get('ITEM_CODE')
				,record.get('MONEY_UNIT')
				,record.get('ORDER_UNIT')
				,record.get('STOCK_UNIT')
				,record.get('TRANS_RATE')
				,UniDate.getDbDateStr(masterForm.getValue('SHIP_DATE'))
				,record.get('ISSUE_REQ_QTY')
				,record['WGT_UNIT']
				,record['VOL_UNIT']
			)
			break;
//		case 'ISSUE_QTY':
//				//출하지시량
//				var dIssueReqQ = Unilite.nvl(record.get('ISSUE_REQ_QTY'), 0);
//
//				//출고량
//				var dOutStockQ = Unilite.nvl(newValue, 0);
//				if(dIssueReqQ-dOutStockQ > 0 ) {
//					detailGrid.down('#issueLinkBtn').disable(false);
//				} else {
//					detailGrid.down('#issueLinkBtn').disable(true);
//				}
//
//		break;
//		case 'PRICE_TYPE': 	//단가구분
//		var customCode = record.get('CUSTOM_NAME');
//		if(Ext.isEmpty(customCode))		{
//			alert(Msg.sMS299);
//			record.set('PRICE_TYPE', oldValue);
//				break;
//			}
//
//			UniSales.fnGetPriceInfo2(record,
//					cbGetPriceInfo,
//					'I',
//				UserInfo.compCode,
//				customCode,
//				record.get('REF_AGENT_TYPE'),
//				record.get('ITEM_CODE'),
//				record.get('MONEY_UNIT'),
//				record.get('ORDER_UNIT'),
//				record.get('STOCK_UNIT'),
//				record.get('TRANS_RATE'),
//				UniDate.getDbDateStr(masterForm.getValue('SHIP_DATE')),
//				record.get('ISSUT_REQ_QTY'),
//				record.get('WGT_UNIT'),
//				record.get('VOL_UNIT')
//		);
//		break;
//			case 'ISSUE_WGT_Q': //출하지시량
//			//수주량 재계산
//			var sOrderWgtQ = record.get('ISSUE_WGT_Q')
//			var sUnitWgt	= record.get('UNIT_WGT')
//
//			if( sUnitWgt == 0) {
//				//단위중량이 입력되지 않아서 계산이 불가능합니다. 품목정보에서 단위중량을 확인하시기 바랍니다.
//				alert(Msg.fStMsgS0102 + '\n'+ Msg.fStMsgS0103);
//				record.set('ISSUE_WGT_Q', oldValue);
//				break;
//			}
//			var dIssueReqQ = (sUnitWgt == 0) ? 0 : sOrderWgtQ / sUnitWgt
//
//			if(BsaCodeInfo.gsPointYn == 'N' && record.get('ORDER_UNIT') == BsaCodeInfo.gsUnitChack) {
//				if( (dIssueReqQ - parseInt(dIssueReqQ)) !=  0) {
//					//수주량(판매단위)은 소숫점을 입력할 수 없습니다. 수주량(중량단위)을 확인하시기 바랍니다.
//					alert(Msg.fStMsgS0104 + '\n'+ Msg.fStMsgS0105);
//					record.set('ISSUE_WGT_Q', oldValue);
//					break;
//				}
//			}
//
//			record.set('ISSUE_REQ_QTY', Unilite.nvl(dIssueReqQ,0));
//
//			var dOutStockQ = Unilite.nvl(record.get('ISSUE_QTY'), 0 );
//
//			if(!record.phantom) {
//				if(dOutStockQ > 0) {
//					alert(Msg.sMS293); //출고가 발생한 건은 수정/삭제할 수 없습니다.
//					record.set('ISSUE_WGT_Q', oldValue);
//					break;
//				}
//			}
//
//			if(!Ext.isEmpty(record.get('ORDER_NUM'))) {
//				var dCanOutQ = Unilite.nvl(record.get('NOTOUT_Q'), 0);
//				 if(!record.phantom) {
//					if(dIssueReqQ > dCanOutQ) {
//						alert(Msg.sMS292); //출하지시량이 출고가능수량을 초과했습니다.
//						record.set('ISSUE_WGT_Q', oldValue);
//						break;
//					}
//				 }
//			}
//
//			//수주량(부피) 재계산
//			var sUnitVol = record.get('UNIT_VOL');
//			var sOrderVolQ = dIssueReqQ * sUnitVol;
//
//			record.set('ISSUE_VOL_Q', sOrderVolQ);
//			UniAppManager.app.fnOrderAmtCal(record, 'Q', fieldName, newValue);
//			break;
//		case 'ISSUE_VOL_Q': 	//출하지시량
//			var sOrderVolQ = record.get('ISSUE_VOL_Q');
//			var sUnitVol	= record.get('UNIT_VOL');
//
//			if( sUnitVol == 0) {
//				//단위중량이 입력되지 않아서 계산이 불가능합니다. 품목정보에서 단위중량을 확인하시기 바랍니다.
//				alert(Msg.fStMsgS0102 + '\n'+ Msg.fStMsgS0103);
//				record.set('ISSUE_VOL_Q', oldValue);
//				break;
//			}
//			var dIssueReqQ = (sUnitVol == 0) ? 0 : sOrderVolQ / sUnitVol;
//
//			if(BsaCodeInfo.gsPointYn == 'N' && record.get('ORDER_UNIT') == BsaCodeInfo.gsUnitChack) {
//				if( (dIssueReqQ - parseInt(dIssueReqQ)) !=  0) {
//					//수주량(판매단위)은 소숫점을 입력할 수 없습니다. 수주량(중량단위)을 확인하시기 바랍니다.
//					alert(Msg.fStMsgS0104 + '\n'+ Msg.fStMsgS0105);
//					record.set('ISSUE_VOL_Q', oldValue);
//					break;
//				}
//			}
//
//			record.set('ISSUE_REQ_QTY', Unilite.nvl(dIssueReqQ,0));	//출하지시량
//
//			var dOutStockQ = Unilite.nvl(record.get('ISSUE_QTY'), 0 );	//출고량
//
//			if(!record.phantom) {
//				if(dOutStockQ > 0) {
//					alert(Msg.sMS293); //출고가 발생한 건은 수정/삭제할 수 없습니다.
//					record.set('ISSUE_VOL_Q', oldValue);
//					break;
//				}
//			}
//
//			if(!Ext.isEmpty(record.get('ORDER_NUM'))) {
//				var dCanOutQ = Unilite.nvl(record.get('NOTOUT_Q'), 0);
//				 if(!record.phantom) {
//					if(dIssueReqQ > dCanOutQ) {
//						alert(Msg.sMS292); //출하지시량이 출고가능수량을 초과했습니다.
//						record.set('ISSUE_VOL_Q', oldValue);
//						break;
//					}
//				 }
//			}
//
//			//수주량(부피) 재계산
//			var sUnitWgt = record.get('UNIT_WGT');
//			var sOrderWgtQ = dIssueReqQ * sUnitWgt;
//
//			record.set('ISSUE_WGT_Q', sOrderWgtQ);
//			UniAppManager.app.fnOrderAmtCal(record, 'Q', fieldName, newValue);
//			break;
//		case 'ISSUE_FOR_PRICE':		//출하단가
//			if(! UniAppManager.app.fnCheckNum(newValue, record, fieldName) ) {
//				record.set('ISSUE_FOR_PRICE', oldValue);
//				break;
//			}
//
//			var sUnitWgt	= record.get('UNIT_WGT');
//			var sIssueForP = record.get('ISSUE_FOR_PRICE');
//
//			var sIssueWgtForP = (sUnitWgt == 0) ?  0 : sIssueForP/sUnitWgt;
//
//			record.set("ISSUE_FOR_WGT_P", sIssueWgtForP);
//
//			//수주단가(부피) 재계산
//			var sUnitVol	= record.get('UNIT_VOL');
//			var sIssueForP = record.get('ISSUE_FOR_PRICE');
//
//			var sIssueVolForP =  (sUnitVol == 0) ? 0 : (sIssueForP / sUnitVol);
//			record.set('ISSUE_FOR_VOL_P', sIssueVolForP);
//
//			UniAppManager.app.fnOrderAmtCal(record, 'P', fieldName, newValue);
//			break;
//		case 'ISSUE_FOR_WGT_P'://출하단가
//		 if(! UniAppManager.app.fnCheckNum(newValue, record, fieldName) ) {
//				record.set('ISSUE_FOR_WGT_P', oldValue);
//				break;
//			}
//
//			//수주단가 재계산
//			var sIssueWgtForP	= record.get('ISSUE_FOR_WGT_P');
//			var sUnitWgt = record.get('UNIT_WGT');
//
//			if(sUnitWgt == 0) {
//				//단위중량이 입력되지 않아서 계산이 불가능합니다. 품목정보에서 단위중량을 확인하시기 바랍니다.
//				alert(fStMsgS0102 + '\n' + fStMsgS0103);
//				record.set('ISSUE_FOR_WGT_P', oldValue);
//				break;
//			}
//			var sIssueForP =  sIssueWgtForP * sUnitWgt;
//
//			record.set("ISSUE_FOR_PRICE", sIssueForP);
//
//			//수주단가(부피) 재계산
//			var sUnitVol	= record.get('UNIT_VOL');
//			var sIssueForP = record.get('ISSUE_FOR_PRICE');
//
//			var sIssueVolForP =  (sUnitVol == 0) ? 0 : (sIssueForP / sUnitVol);
//			record.set('ISSUE_FOR_VOL_P', sIssueVolForP);
//
//			UniAppManager.app.fnOrderAmtCal(record, 'P', fieldName, newValue);
//			break;
//
//		case 'ISSUE_FOR_VOL_P'://출하단가
//			if(! UniAppManager.app.fnCheckNum(newValue, record, fieldName) ) {
//				record.set('ISSUE_FOR_WGT_P', oldValue);
//				break;
//			}
//
//			//수주단가 재계산
//			var sIssueVolForP	= record.get('ISSUE_FOR_VOL_P');
//			var sUnitVol = record.get('UNIT_VOL');
//
//			if(sUnitVol == 0) {
//				//단위중량이 입력되지 않아서 계산이 불가능합니다. 품목정보에서 단위부피을 확인하시기 바랍니다.
//				alert(Msg.fStMsgS0102 + '\n' + Msg.fStMsgS0103);
//				record.set('ISSUE_FOR_VOL_P', oldValue);
//				break;
//			}
//			var sIssueForP =  sIssueWgtForP * sUnitVol;
//
//			record.set("ISSUE_FOR_PRICE", sIssueForP);
//
//			//수주단가(부피) 재계산
//			var sUnitWgt	= record.get('UNIT_WGT');
//			var sIssueForP = record.get('ISSUE_FOR_PRICE');
//
//			var sIssueWgtForP =  (sUnitWgt == 0) ? 0 : (sIssueForP / sUnitWgt);
//			record.set('ISSUE_FOR_WGT_P', sIssueWgtForP);
//
//			UniAppManager.app.fnOrderAmtCal(record, 'P', fieldName, newValue);
//			break;
//		case 'ISSUE_FOR_AMT': //출하금액
//			if(! UniAppManager.app.fnCheckNum(newValue, record, fieldName) ) {
//				record.set('ISSUE_FOR_AMT', oldValue);
//				break;
//			}
//			 UniAppManager.app.fnOrderAmtCal(record, 'O', fieldName, newValue);
//			 break;
//
//
//
//		case 'INSPEC_Q'://출고량(영업실)
//			if(UniAppMananer.app.fnCheckNum(newValue, record, fieldName)) {
//				record.set('INSPEC_Q', oldValue);
//				break;
//			}
//			break;
			}
			return rv;
		}
	}); // validator
}
</script>
