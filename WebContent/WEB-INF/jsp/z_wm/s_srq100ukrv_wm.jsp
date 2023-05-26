<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_srq100ukrv_wm">
	<t:ExtComboStore comboType="BOR120"  pgmId="s_srq100ukrv_wm"/>			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>						<!-- 화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>						<!-- 판매단위-->
	<t:ExtComboStore comboType="AU" comboCode="B021"/>						<!-- 품목상태-->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>						<!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B030"/>						<!-- 과세포함여부-->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5' />			<!-- 생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="B055"/>						<!-- 고객분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>						<!-- 과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="B087"/>						<!-- 전송여부-->
	<t:ExtComboStore comboType="AU" comboCode="B116"/>						<!-- 단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="B131"/>						<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="S002"/>						<!-- 판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="S003"/>						<!-- 단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="S007"/>						<!-- 출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>						<!-- 영업담당자-->
	<t:ExtComboStore comboType="AU" comboCode="S014"/>						<!-- 매출대상-->
	<t:ExtComboStore comboType="AU" comboCode="S024"/>						<!-- 부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S106"/>						<!-- 라벨종류-->		<%--20200304추가 --%>
	<t:ExtComboStore comboType="AU" comboCode="S065"/>						<!-- 주문구분-->
	<t:ExtComboStore comboType="AU" comboCode="T016"/>						<!-- 대금결제방법-->
	<t:ExtComboStore comboType="AU" comboCode="ZM11"/>						<!-- 배송방법 -->
	<t:ExtComboStore comboType="OU"/>										<!-- 창고-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="s_srq100ukrv_wmLevel1Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="s_srq100ukrv_wmLevel2Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="s_srq100ukrv_wmLevel3Store"/>
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-change-cell3 {
		background-color: #CCFFFF;	<%--20210208 추가: 연한 파랑(하늘색)--%>
	}
</style>
<script type="text/javascript" >
	//20201216추가: 우편번호 다음 API 연동
	var protocol = ("https:" == document.location.protocol) ? "https" : "http";
	if(protocol == "https") {
		document.write(unescape("%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	} else {
		document.write(unescape("%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	}
</script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >
var searchInfoWindow;		//searchInfoWindow : 검색창
var isLoad = false;			//로딩 플래그 담당, 화폐단위, 환율 change 로드시 계속 타므로 막음

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
	gsLotNoInputMethod	: '${gsLotNoInputMethod}',
	gsLotNoEssential	: '${gsLotNoEssential}',
	gsEssItemAccount	: '${gsEssItemAccount}',
	defaultSalePrsn		: '${defaultSalePrsn}',		//영업담당(default)
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
var CustomCodeInfo = {
	gsAgentType		: '',
	gsCustCrYn		: '',
	gsUnderCalBase	: '',
	gsRefTaxInout	: '',
	gsbusiPrsn		: ''
};


function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 3},
		padding		: '1 1 1 1',
		border		: true,
		items		: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			xtype		: 'uniCombobox',
			name		: 'DIV_CODE',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelResult.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
				}
			}
		},{
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
			fieldLabel		: '주문일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ORDER_DATE_FR',
			endFieldName	: 'ORDER_DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>',
			name		: 'ISSUE_REQ_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			allowBlank	: false,
			holdable	: 'hold'
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 3 0',
//			colspan	: 2,
			items	: [{
				fieldLabel	: '품목분류',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_srq100ukrv_wmLevel1Store'),
				child		: 'ITEM_LEVEL2',
				width		: 200
			},{
				fieldLabel	: '',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_srq100ukrv_wmLevel2Store'),
				child		: 'ITEM_LEVEL3',
				width		: 100

			},{
				fieldLabel	: '',
				name		: 'ITEM_LEVEL3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_srq100ukrv_wmLevel3Store'),
				width		: 100
			}]
		},{	//20210203 추가: 조회조건 '조달구분' 추가
			fieldLabel	: '조달구분',
			name		: 'SUPPLY_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B014'
		},{	//20210201 추가: 조회조건 '주문/수령자' 추가
			fieldLabel	: '주문/수령자',
			name		: 'RECEIVER_NAME',
			xtype		: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{	//20210201 추가: 조회조건 '고객분류' 추가
			fieldLabel	: '고객분류',
			name		: 'AGENT_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B055'
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '등록여부',
			items		: [{
				boxLabel	: '미등록',
				width		: 80,
				name		: 'REGI_YN',
				inputValue	: 'N',
				checked		: true
			},{
				boxLabel	: '등록',
				width		: 80,
				name		: 'REGI_YN',
				inputValue	: 'Y'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					UniAppManager.app.onQueryButtonDown(newValue.REGI_YN);
				}
			}
		},{	//20201026 추가: 저장 시 필요
			fieldLabel	: 'KEY_VALUE',
			name		: 'KEY_VALUE',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{	//20210203 추가: 링크 받는 로직을 위해 필요
			fieldLabel	: 'ORDER_NUM',
			name		: 'ORDER_NUM',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
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



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_srq100ukrv_wmService.selectList',
			update	: 's_srq100ukrv_wmService.updateDetail',
			create	: 's_srq100ukrv_wmService.insertDetail',
			destroy	: 's_srq100ukrv_wmService.deleteDetail',
			syncAll	: 's_srq100ukrv_wmService.saveAll'
		}
	});

	Unilite.defineModel('s_srq100ukrv_wmModel', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string', allowBlank: false},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'		, type: 'string', allowBlank: false},
			{name: 'OPR_FLAG'			, text: 'OPR_FLAG'		, type: 'string', allowBlank: false},
			{name: 'ORDER_NUM'			, text: '수주번호'			, type: 'string'},
			{name: 'SER_NO'				, text: '수주순번'			, type: 'int'	, allowBlank: false},
			{name: 'UNIQUEID'			, text: 'UNIQUEID'		, type: 'string'},							//UNIQUEID
			{name: 'NUMBER'				, text: 'NUMBER'		, type: 'string'},							//NUMBER
			{name: 'SITE_CODE'			, text: '판매사이트코드'		, type: 'string', allowBlank: false},		//SITECODE
			{name: 'SITE_NAME'			, text: '판매사이트'			, type: 'string', allowBlank: false},		//SITENAME
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'				, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname2" default="품명"/>'					, type: 'string', allowBlank: false},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'						, type: 'string', editable: false},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.sales.unit" default="단위"/>'						, type: 'string', comboType: 'AU', comboCode: 'B013', allowBlank:false, displayField: 'value'},
			{name: 'SHOP_SALE_NAME'		, text: '상품명'			, type: 'string'},							//SHOP_SALE_NAME
			{name: 'SHOP_OPT_NAME'		, text: '옵션명'			, type: 'string'},							//SHOP_SALE_NAME
			{name: 'ORDER_Q'			, text: '수량'			, type: 'uniQty', allowBlank: false},		//COUNT
			{name: 'ORDER_PRICE'		, text: '판매가'			, type: 'uniUnitPrice'},					//PRICE
			{name: 'SHOP_ORD_NO'		, text: '주문번호'			, type: 'string'},							//SHOP_ORD_NO
			{name: 'RECEIVER_NAME'		, text: '수령자명'			, type: 'string'},							//RECIPIENTNAME
			{name: 'TELEPHONE_NUM1'		, text: '수령자전화번호'		, type: 'string'},							//RECIPIENTTEL
			{name: 'TELEPHONE_NUM2'		, text: '수령자핸드폰'		, type: 'string'},							//RECIPIENTHTEL
			{name: 'ZIP_NUM'			, text: '우편번호'			, type: 'string'},							//RECIPIENTZIP
			{name: 'ADDRESS1'			, text: '주소'			, type: 'string'},							//RECIPIENTADDRESS
			{name: 'DELIV_METHOD'		, text: '배송방법'			, type: 'string', comboType: 'AU', comboCode: 'ZM11'},	//DELIVMETHOD()
			{name: 'ISSUING_NUMBER'		, text: '운송장발행수'		, type: 'int'},
			{name: 'INVOICE_NUM'		, text: '운송장번호1'		, type: 'string'},
			{name: 'INVOICE_NUM2'		, text: '운송장번호2'		, type: 'string'},
			{name: 'TRNS_YN'			, text: '택배전송여부'		, type: 'string', comboType: 'AU', comboCode: 'B087'},
			{name: 'TRNS_ERROR'			, text: '오류'			, type: 'string'},
			//화면에서는 HIDDEN
			{name: 'ORD_STATUS'			, text: 'ORD_STATUS'	, type: 'string'},							//ORD_STATUS
			{name: 'SENDER_CODE'		, text: '택배사코드'			, type: 'int'},								//SENDER_CODE
			{name: 'SENDER'				, text: '택배사'			, type: 'string'},							//SENDER
			{name: 'DELIV_PRICE'		, text: '배송비'			, type: 'uniPrice'},						//DELIVPRICE
			{name: 'DVRY_DATE'			, text: '배송예정일'			, type: 'uniPrice'},						//DELIVDATE
			{name: 'CUSTOMER_ID2'		, text: '주문자ID'			, type: 'string'},							//ORDERID
			{name: 'ORDER_NAME'			, text: '주문자명'			, type: 'string'},							//ORDERNAME
			{name: 'ORDER_TEL1'			, text: '주문자전화번호'		, type: 'string'},							//ORDERTEL
			{name: 'ORDER_TEL2'			, text: '주문자핸드폰'		, type: 'string'},							//ORDERHTEL
			{name: 'ORDER_MAIL'			, text: '주문자email'		, type: 'string'},							//ORDEREMAIL
			{name: 'MSG'				, text: '배송메세지'			, type: 'string'},							//MSG
			{name: 'INVOICE_NUM'		, text: '송장번호'			, type: 'string'},							//INVOICE_NUM
			{name: 'SHOP_SALE_NO'		, text: '쇼핑몰 판매번호'		, type: 'string'},							//SHOP_SALE_NO
			{name: 'ISSUE_REQ_Q'		, text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'		, type: 'uniQty' , defaultValue: 0},
			{name: 'OUTSTOCK_Q'			, text: 'OUTSTOCK_Q'	, type: 'int', defaultValue: 0},
			//출하지시 등록 저장을 위한 컬럼
			{name: 'ISSUE_REQ_NUM'		, text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'		, type: 'string'},
			{name: 'ISSUE_REQ_SEQ'		, text: '<t:message code="system.label.sales.seq" default="순번"/>'						, type: 'int', allowBlank: false , editable:false},
			{name: 'ISSUE_REQ_DATE'		, text: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'		, type: 'uniDate'},
			{name: 'AGENT_TYPE'			, text: 'AGENT_TYPE'	, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	, text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'				, type: 'string' , comboType: 'AU', comboCode: 'S007', allowBlank:false},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'			, type: 'string' , comboType: 'OU', allowBlank:false},
			{name: 'ORDER_P'			, text: 'ORDER_P'		, type: 'uniUnitPrice', defaultValue:0},
			{name: 'ORDER_TAX_O'		, text: 'ORDER_TAX_O'	, type: 'uniPrice', defaultValue:0},
			{name: 'TRANS_RATE'			, text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				, type: 'uniQty', defaultValue:1, allowBlank:false},
			{name: 'PRICE_YN'			, text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string', comboType: 'AU', comboCode: 'S003', defaultValue:'2', allowBlank:false},
			{name: 'TAX_TYPE'			, text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'			, type: 'string', comboType: 'AU', comboCode: 'B059', allowBlank:false},
			{name: 'DISCOUNT_RATE'		, text: '<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'			, type: 'uniPercent', defaultValue:0},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'			, type: 'string', defaultValue:BsaCodeInfo.gsMoneyUnit,displayField: 'value'},
			{name: 'EXCHANGE_RATE'		, text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'				, type: 'uniER', defaultValue:1},
			{name: 'ORDER_FOR_P'		, text: '외화단가'			, type: 'uniFC'},
			{name: 'ORDER_FOR_O'		, text: '외화금액'			, type: 'uniFC'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.sales.shipmentordercharger" default="출하지시담당자"/>'	, type: 'string', comboType: 'AU', comboCode: 'S010'},
			{name: 'OUT_DIV_CODE'		, text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'			, type: 'string', comboType: 'BOR120'/*, child:'WH_CODE'*/, allowBlank:false},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.sales.issuerequestdate" default="출고요청일"/>'		, type: 'uniDate', allowBlank:false},
			{name: 'SALE_CUST_CD'		, text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'				, type: 'string', allowBlank:false},
			{name: 'DVRY_CUST_CD'		, text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'			, type: 'string'},
			{name: 'BILL_TYPE'			, text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'				, type: 'string', comboType: 'AU', comboCode: 'S024', allowBlank:false},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'				, type: 'string', comboType: 'AU', comboCode: 'S002', allowBlank:false},
			{name: 'ACCOUNT_YNC'		, text: '<t:message code="system.label.sales.salessubject" default="매출대상"/>'			, type: 'string', comboType: 'AU', comboCode: 'S014', allowBlank:false},
			{name: 'PO_NUM'				, text: '<t:message code="system.label.sales.pono2" default="P/O 번호"/>'					, type: 'string'},
			{name: 'PO_SEQ'				, text: '<t:message code="system.label.sales.poseq2" default="P/O 순번"/>'				, type: 'int'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'PRICE_TYPE'			, text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string', comboType: 'AU', comboCode: 'B116', defaultValue:BsaCodeInfo.gsPriceGubun},
			{name: 'ORDER_DATE'			, text: '<t:message code="unilite.msg.sMS122" default="수주일"/>'							, type: 'uniDate'},
			{name: 'REMARK_INTER'		, text: '<t:message code="system.label.sales.remarkinter" default="내부기록사항"/>'			, type: 'string'},
			{name: 'BUNDLE_NO'			, text: 'BUNDLE_NO'		, type: 'string'},			//20201216 추가
			{name: 'PAY_TIME'			, text: '결제완료시간'		, type: 'string'},			//20201229 추가
			{name: 'PRINT_YN'			, text: '<t:message code="system.label.purchase.printyn" default="출력여부"/>'				, type: 'string', comboType: 'AU', comboCode: 'B131'},			//20210208 추가
			{name: 'WKORD_YN'			, text: '작업지시 여부'		, type: 'string', comboType: 'AU', comboCode: 'B131', editable: false},	//20210407 추가
			{name: 'WKORD_NUM'			, text: '작업지시번호'		, type: 'string'}			//20210407 추가
		]
	});

	var detailStore = Unilite.createStore('s_srq100ukrv_wmDetailStore',{
		model	: 's_srq100ukrv_wmModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부
			allDeletable: false,	// 전체 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function(newValue) {
			var param = panelResult.getValues();
			if(newValue || newValue == '') {
				param.REGI_YN = newValue;
			}
			console.log( param );
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});
		},
		saveStore : function(config) {
			var inValidRecs		= this.getInvalidRecords();
			var toCreate		= this.getNewRecords();
			var toUpdate		= this.getUpdatedRecords();
			var toDelete		= this.getRemovedRecords();
			var paramMaster		= panelResult.getValues();
			paramMaster.CPATH	= CPATH;				//20210302 추가: TEST에서는 아래로직 수행하지 않도록 로직 추가
/////////(참고) 운송장번호 중복으로 작업 시에 PLAY AUTO와 interface 생략하려면 여기 주석 "해제"하고 진행해야함
//			paramMaster.CPATH	= '/wm';				//20210302 추가: TEST에서는 아래로직 수행하지 않도록 로직 추가

			if(inValidRecs.length == 0) {
				if(config == null) {
					config = {
						params	: [paramMaster],
						success	: function(batch, option) {
							var master = batch.operations[0].getResultSet();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);

//							if(detailStore.getCount() == 0) {
//								UniAppManager.app.onResetButtonDown();
//							} else {
								UniAppManager.app.onQueryButtonDown();
//							}
						}
					};
				}
				this.syncAllDirect(config);
			} else {
				 detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				isLoad = false;
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				//20210208 추가: 전화번호 입력 시, 자동으로 '-' 추가하도록 로직 추가, 20210218 수정: 안심번호 관련로직 추가
				if(!Ext.isEmpty(record.get('TELEPHONE_NUM1') && modifiedFieldNames == 'TELEPHONE_NUM1')) {
					record.set('TELEPHONE_NUM1', record.get('TELEPHONE_NUM1').replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3"));
				}
				if(!Ext.isEmpty(record.get('TELEPHONE_NUM2') && modifiedFieldNames == 'TELEPHONE_NUM2')) {
					record.set('TELEPHONE_NUM2', record.get('TELEPHONE_NUM2').replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3"));
				}
				//20210503 추가: ORDER_TEL1, ORDER_TEL2
				if(!Ext.isEmpty(record.get('ORDER_TEL1') && modifiedFieldNames == 'ORDER_TEL1')) {
					record.set('ORDER_TEL1', record.get('ORDER_TEL1').replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3"));
				}
				if(!Ext.isEmpty(record.get('ORDER_TEL2') && modifiedFieldNames == 'ORDER_TEL2')) {
					record.set('ORDER_TEL2', record.get('ORDER_TEL2').replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3"));
				}
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				console.log("onStoreLoad");
				if(records) {
					if(records.length > 0) {
						var msg = records.length + Msg.sMB001; 				//'건이 조회되었습니다.';
						UniAppManager.updateStatus(msg, true);
					}
				}
			}
		}
	});

	var detailGrid = Unilite.createGrid('s_srq100ukrv_wmGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useLiveSearch		: true,		//20210311 추가
			onLoadSelectFirst	: false,
			expandLastColumn	: false,	//20210618 수정: 엑셀다운로드 시, 컬럼으로 인식해서 false로 변경
			useRowNumberer		: false
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
					//20201230 - 기등록 된 데이터, 체크 전에 수정된 데이터 존재여부 체크
					var checkFlag = false;
					var queryFlag = panelResult.getValues().REGI_YN;
					if(queryFlag == 'Y') {
						var records = detailGrid.getStore().data.items;
						Ext.each(records, function(record, idx) {
							if(record.get('OPR_FLAG') == 'U') {
								checkFlag = true;
								return false;
							}
						});
						if(checkFlag) {
							Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
							return false;
						}
					}
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var saveFlag = panelResult.getValues().REGI_YN;
					if(saveFlag == 'N') {
						var seq = detailStore.max('ISSUE_REQ_SEQ');
						if(!seq) seq = 1;
						else seq += 1;
						selectRecord.set('ISSUE_REQ_SEQ', seq);
						selectRecord.set('OPR_FLAG'		, 'N');
					} else {
						selectRecord.set('OPR_FLAG', 'D');
					}
					//20201223 추가: 출하지시서, 운송장 출력기능 추가 - 등록된 데이터만 출력버튼 활성화
					if(panelResult.getValues().REGI_YN == 'Y') {
						detailGrid.down('#orderReqPrintBtn').enable();
						detailGrid.down('#carriageBillprintBtn').enable();
					}
					//20210618 추가: 엑셀다운로드 기능 추가(선택된 파일만 다운로드 하도록 기능 추가)
					detailGrid.down('#excelDownload').enable();
				},
				deselect: function(grid, selectRecord, index, eOpts ){
					selectRecord.set('OPR_FLAG', '');
					var saveFlag = panelResult.getValues().REGI_YN;
					if(saveFlag == 'N') {
						selectRecord.set('ISSUE_REQ_SEQ', 0);
					}
					//20201223 추가: 출하지시서, 운송장 출력기능 추가
					if (this.selected.getCount() == 0) {
						detailGrid.down('#orderReqPrintBtn').disable();
						detailGrid.down('#carriageBillprintBtn').disable();
						//20210618 추가: 엑셀다운로드 기능 추가(선택된 파일만 다운로드 하도록 기능 추가)
						detailGrid.down('#excelDownload').disable();
					}
				}
			}
		}),
		tbar	: [{
			//20201216 추가: 테스트
			text	: '송장번호 update test',
			width	: 100,
			hidden	: true,
			handler	: function() {
				var record	= detailGrid.getSelectedRecord();
				var param	= {
					'BUNDLE_NO'		: record.get('BUNDLE_NO'),
					'SENDER_CODE'	: record.get('SENDER_CODE'),
					'INVOICE_NUM'	: record.get('INVOICE_NUM')
				}
				s_api_wmService.updateAPITrsIvoiceNum(param, function(provider, response){
				});
			}
		},{
			text	: 'test',
			itemId	: 'trnOrderInfo',
			width	: 100,
			hidden	: true,
			handler	: function() {
				s_srq100ukrv_wmService.addressSplit2('충남 공주시 월송동 43-14', function(provider, response){
					Unilite.messageBox(provider);
				});
			}
		},{	//20210310 추가: 수동 cj interface
			text	: 'CJ_interface',
			itemId	: 'trnOrderInfo',
			width	: 100,
			hidden	: true,
			handler	: function() {
				var param = {
					REG_DATE : '20210310',
					KEY_VALUE: '20210310183221203072'
				}
				s_srq100ukrv_wmService.CJ_interface(param, function(provider, response){
//					Unilite.messageBox(provider);
				});
			}
		},{	//20201223 추가: 출하지시서, 운송장 출력기능 추가
			text	: '출하지시서',
			xtype	: 'button',
			itemId	: 'orderReqPrintBtn',
			width	: 100,
			handler	: function() {
				var selectedRecords = detailGrid.getSelectedRecords();
				var orderReqInfo;
				Ext.each(selectedRecords, function(record, idx) {
					if(idx ==0) {
						orderReqInfo = record.get('ISSUE_REQ_NUM') + '/' + record.get('ISSUE_REQ_SEQ');
					} else {
						orderReqInfo = orderReqInfo + ',' + record.get('ISSUE_REQ_NUM') + '/' + record.get('ISSUE_REQ_SEQ');
					}
				});
				var param			= panelResult.getValues();
				param.PGM_ID		= 's_srq100ukrv_wm';
				param.MAIN_CODE		= 'Z012';
				param.dataCount		= selectedRecords.length;
				param.orderReqInfo	= orderReqInfo;

				var win = Ext.create('widget.ClipReport', {
					url			: CPATH + '/z_wm/s_srq100clukrv_wm.do',
					prgID		: 's_srq100ukrv_wm',
					extParam	: param,
					submitType	: 'POST'
				});
				win.center();
				win.show();
				//20210208 추가: 출력한 데이터 상태값 변경
				s_srq100ukrv_wmService.updatePrintStatus(param, function(provider2, response){
				});
			}
		},{	//20201223 추가: 출하지시서, 운송장 출력기능 추가
			text	: '운송장',
			itemId	: 'carriageBillprintBtn',
			width	: 100,
			handler	: function() {
				var selectedRecords	= detailGrid.getSelectedRecords();
				var orderReqInfo;
				var errFlag			= false;	//택배배송 여부 확인 flag
				var i = 0;
				Ext.each(selectedRecords, function(record, idx) {
					if(record.get('DELIV_METHOD') == '01' || record.get('DELIV_METHOD') == '02' || record.get('DELIV_METHOD') == '03') {
						if(i == 0) {
							orderReqInfo = record.get('ISSUE_REQ_NUM') + '/' + record.get('ISSUE_REQ_SEQ');
						} else {
							orderReqInfo = orderReqInfo + ',' + record.get('ISSUE_REQ_NUM') + '/' + record.get('ISSUE_REQ_SEQ');
						}
						i++;
						//택배배송 여부 확인: 01 택배배송, 02 무료배송, 03 선결제, 20210209 수정: 주석, 일단 다출력
	//					if(record.get('DELIV_METHOD') != '01' && record.get('DELIV_METHOD') != '02' && record.get('DELIV_METHOD') != '03') {
	//						Unilite.messageBox('배송방법이 택배배송/선결제/무료배송인 경우만 운송장 출력이 가능합니다.');
	//						errFlag = true;
	//						return false;
	//					}
					}
				});
				if(errFlag) return false;

				var param			= panelResult.getValues();
				param.PGM_ID		= 's_srq100ukrv_wm(C)';
				param.MAIN_CODE		= 'Z012';
				param.dataCount		= i;
				param.orderReqInfo	= orderReqInfo;

				var win = Ext.create('widget.ClipReport', {
					url			: CPATH + '/z_wm/s_srq100clukrv_wm(C).do',
					prgID		: 's_srq100ukrv_wm',
					extParam	: param,
					submitType	: 'POST'
				});
				win.center();
				win.show();
			}
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbseparator'
		},{
			xtype: 'tbspacer'
/*		},{	//2020617 추가: 선택된 데이터만 엑셀 다운로드 하는 기능을 구현하기 위해 추가(사용 안 함 - 공통 프로세스로직 사용하도록 변경)
			text	: '<font color="blue">다운로드</font>',
			itemId	: 'excelDownload_notUse',
			width	: 80,
			hidden	: true,
			handler	: function() {
				//넘길 변수 선언
				var orderInfo
				var columnCode, columnName, columnSize, columnSort, columnFomt;
				var param		= panelResult.getValues();
				var seq			= 1;
				var selecteds	= detailGrid.getSelectedRecords();
				var columns		= detailGrid.getColumns();


				//컴럼 정보 변수 생성하여 넘길 변수에 추가
				Ext.each(columns, function(column, index) {
					if(!column.hidden && index != 0) {		//hidden필드 && 체크박스 제외
						if(seq == 1) {
							columnCode = column.initialConfig.dataIndex;
							columnName = column.initialConfig.text.replace("<span style='color:#f00 !important;font-weight:bold'>*</span>", "");		//필수표시 제거
							columnSize = column.initialConfig.width;
							columnSort = column.initialConfig.align;
							columnFomt = column.initialConfig.format;
						} else {
							columnCode = columnCode + ',' + column.initialConfig.dataIndex;
							columnName = columnName + ',' + column.initialConfig.text.replace("<span style='color:#f00 !important;font-weight:bold'>*</span>", "");		//필수표시 제거;
							columnSize = columnSize + ',' + column.initialConfig.width;
							columnSort = columnSort + ',' + column.initialConfig.align;
							columnFomt = columnFomt + '/' + column.initialConfig.format;
						}
						seq++;
					}
				});
				param.columnCount	= seq - 1;
				param.columnCode	= columnCode;
				param.columnName	= columnName;
				param.columnSize	= columnSize;
				param.columnSort	= columnSort;
				param.columnFomt	= columnFomt;

				//선택된 데이터 정보 변수에 추가
				Ext.each(selecteds, function(record, idx) {
					if(idx ==0) {
						orderInfo = record.get('ORDER_NUM') + '/' + record.get('SER_NO');
					} else {
						orderInfo = orderInfo + ',' + record.get('ORDER_NUM') + '/' + record.get('SER_NO');
					}
				});
				param.dataCount		= selecteds.length;
				param.orderInfo		= orderInfo;

				var form = panelFileDown;
				form.submit({
					params: param,
					success:function(form, action)  {
					},
					failure: function(form, action){
					}
				});
			}*/
		},{	//20210621 추가: 선택된 데이터만 엑셀 다운로드 하는 기능을 구현하기 위해 추가
			text	: '<font color="blue">다운로드</font>',
			itemId	: 'excelDownload',
			width	: 80,
			handler	: function() {
				//넘길 변수 선언
				var title		= '출하지시등록(WM)';
				var orderInfo;
				var param		= panelResult.getValues();
				var selecteds	= detailGrid.getSelectedRecords();

				//선택된 데이터 정보 변수에 추가
				Ext.each(selecteds, function(record, idx) {
					if(idx ==0) {
						orderInfo = record.get('ORDER_NUM') + '/' + record.get('SER_NO');
					} else {
						orderInfo = orderInfo + ',' + record.get('ORDER_NUM') + '/' + record.get('SER_NO');
					}
				});
				detailGrid.getStore().readParams.orderInfo = orderInfo;
				detailGrid.getStore().readParams.dataCount = selecteds.length;
				detailGrid.downloadExcelXml(null, title);
				//호출 후 초기화: 전체 엑셀다운로드 시 해당 데이터 정상적으로 다운로드 하기 위해 필요
				detailGrid.getStore().readParams.orderInfo = '';
				detailGrid.getStore().readParams.dataCount = 0;
			}
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbseparator'
		},{
			xtype: 'tbspacer'
		}],
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',showSummaryRow: false},
					{id : 'masterGridTotal',	ftype: 'uniSummary',		showSummaryRow: false}],
		columns	: [
			{dataIndex: 'BUNDLE_NO'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
//			{dataIndex: 'OPR_FLAG'			, width: 100, hidden: true},			//20210223 주석
			{dataIndex: 'ISSUE_REQ_NUM'		, width: 100, hidden: true},
			{dataIndex: 'ISSUE_REQ_SEQ'		, width: 100, hidden: true},
			{dataIndex: 'ISSUE_REQ_DATE'	, width: 100, hidden: true},
			{dataIndex: 'UNIQUEID'			, width: 100, hidden: true},
			{dataIndex: 'NUMBER'			, width: 100, hidden: true},
			{dataIndex: 'ORDER_NUM'			, width: 100, hidden: true},
			{dataIndex: 'SER_NO'			, width: 100, hidden: true},
			{dataIndex: 'SITE_CODE'			, width: 100, hidden: true},
			{dataIndex: 'SITE_NAME'			, width: 100,
				editor: Unilite.popup('AGENT_CUST_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('SITE_CODE', records[0]['CUSTOM_CODE']);
								grdRecord.set('SITE_NAME', records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SITE_CODE','');
							grdRecord.set('SITE_NAME','');
						}
					}
				})
			},
			{dataIndex: 'ITEM_CODE'			, width: 120,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								detailGrid.setItemData(records, false, detailGrid.uniOpt.currentRecord);
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null, true, detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'POPUP_TYPE'	: 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE'	: divCode});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 150,
				editor: Unilite.popup('DIV_PUMOK_G', {
					autoPopup	: true,
					listeners	: {
						'onSelected': {
							fn: function(records, type) {
								detailGrid.setItemData(records, false, detailGrid.uniOpt.currentRecord);
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null, true, detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'POPUP_TYPE'	: 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE'	: divCode});
						}
					}
				})
			},
			{dataIndex: 'SPEC'				, width: 130},
			{dataIndex: 'SHOP_SALE_NAME'	, width: 120},
			{dataIndex: 'SHOP_OPT_NAME'		, width: 120, hidden: true},
			{dataIndex: 'ORDER_Q'			, width: 80	, align: 'center'},
			{dataIndex: 'ORDER_PRICE'		, width: 100, hidden: true},
			{dataIndex: 'SHOP_ORD_NO'		, width: 100},
			{dataIndex: 'RECEIVER_NAME'		, width: 100},
			{dataIndex: 'TELEPHONE_NUM1'	, width: 120},
			{dataIndex: 'TELEPHONE_NUM2'	, width: 120},
			{dataIndex: 'ZIP_NUM'			, width: 100	,
				//20210208 추가: 팝업으로 변경
				editor: Unilite.popup('ZIP_G',{
					textFieldName	: 'ZIP_NUM',
					DBtextFieldName	: 'ZIP_NUM',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('ADDRESS1', records[0]['ZIP_NAME'] + ' ' + records[0]['ADDR2']);
								grdRecord.set('ZIP_NUM'	, records[0]['ZIP_CODE']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ADDRESS1', '');
							grdRecord.set('ZIP_NUM'	, '');
						},
						applyextparam: function(popup){
							var grdRecord	= detailGrid.uniOpt.currentRecord;
							var paramAddr	= grdRecord.get('ADDRESS1'); //우편주소 파라미터로 넘기기
							if(Ext.isEmpty(paramAddr)){
								popup.setExtParam({'GBN': 'post'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
							} else {
								popup.setExtParam({'GBN': 'addr'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
							}
							popup.setExtParam({'ADDR': paramAddr});
						}
					}
				})
			},
			{dataIndex: 'ADDRESS1'			, width: 200},
			{dataIndex: 'DELIV_METHOD'		, width: 100, align: 'center'},
			{dataIndex: 'ORD_STATUS'		, width: 100, hidden: true},
			{dataIndex: 'DELIV_PRICE'		, width: 100, hidden: true},
			{dataIndex: 'DVRY_DATE'			, width: 100, hidden: true},
			{dataIndex: 'CUSTOMER_ID2'		, width: 100, hidden: true},
			{dataIndex: 'ORDER_NAME'		, width: 100, hidden: false},	//20210503 수정 - hidden: false
			{dataIndex: 'ORDER_TEL1'		, width: 100, hidden: false},	//20210503 수정 - hidden: false
			{dataIndex: 'ORDER_TEL2'		, width: 100, hidden: false},	//20210503 수정 - hidden: false
			{dataIndex: 'ORDER_MAIL'		, width: 100, hidden: true},
			{dataIndex: 'MSG'				, width: 100, hidden: true},
			{dataIndex: 'SENDER_CODE'		, width: 100, hidden: true},
			{dataIndex: 'SENDER'			, width: 100, hidden: true},
			{dataIndex: 'ISSUING_NUMBER'	, width: 100, hidden: false},
			{dataIndex: 'INVOICE_NUM'		, width: 100, hidden: false},
			{dataIndex: 'INVOICE_NUM2'		, width: 100, hidden: false},
			{dataIndex: 'TRNS_YN'			, width: 100, hidden: false, align: 'center'},
			{dataIndex: 'TRNS_ERROR'		, width: 100, hidden: false},
			{dataIndex: 'PAY_TIME'			, width: 130, align: 'center'},	//20201229 추가
			{dataIndex: 'PRINT_YN'			, width: 80	, align: 'center'},	//20210208 추가
			{dataIndex: 'WKORD_YN'			, width: 100, align: 'center'},	//20210407 추가
			{dataIndex: 'WKORD_NUM'			, width: 100}					//20210407 추가
		],
		listeners: {
			selectionchange: function( grid, selected, eOpts ){
			},
			cellclick: function( view, td, cellIndex, selRecord, tr, rowIndex, e, eOpts ) {
				//20210203 추가: 그리드 클릭 시, 동일한 송장번호 전체 선택/해제, 체크박스는 개별로 동작하도록 구성, 20210208 수정: 미등록 데이터는 아래로직 수행하지 않음
				var saveFlag = panelResult.getValues().REGI_YN;
				if(saveFlag == 'Y') {
					if (cellIndex != 0
					&& cellIndex != detailGrid.getColumnIndex('DELIV_METHOD')
					//20210208 추가: 수령자명, 전화번호, 핸드폰, 우편번호, 주소 수정 가능하도록 수정
					&& cellIndex != detailGrid.getColumnIndex('RECEIVER_NAME') && cellIndex != detailGrid.getColumnIndex('TELEPHONE_NUM1') && cellIndex != detailGrid.getColumnIndex('TELEPHONE_NUM2')
					&& cellIndex != detailGrid.getColumnIndex('ZIP_NUM') && cellIndex != detailGrid.getColumnIndex('ADDRESS1')
					&& !(saveFlag == 'Y' && cellIndex == detailGrid.getColumnIndex('INVOICE_NUM')
					&& cellIndex != detailGrid.getColumnIndex('ORDER_TEL1') && cellIndex != detailGrid.getColumnIndex('ORDER_TEL2')			//20210503 추가
					//20210209 주석
//					&& (e.record.get('DELIV_METHOD') == '01' || e.record.get('DELIV_METHOD') == '02' || e.record.get('DELIV_METHOD') == '03')
					)
//					&& !(saveFlag == 'N' && cellIndex == detailGrid.getColumnIndex('ISSUING_NUMBER'))
					) {
						var sm		= detailGrid.getSelectionModel();
						var records	= detailStore.data.items;
						var data	= detailGrid.getSelectionModel().getSelection();
						var data2	= new Array;
						Ext.each(records, function(record, idx) {
							if(!Ext.isEmpty(selRecord.get('INVOICE_NUM')) && selRecord.get('INVOICE_NUM') == record.get('INVOICE_NUM')
							 && selRecord.get('RECEIVER_NAME') == record.get('RECEIVER_NAME')){		//2210223 수정: !Ext.isEmpty(selRecord.get('INVOICE_NUM')) && 추가, 20210527 수정: 수령자명 추가
								data.push(record);
								data2.push(record);
							}
						});
						if(detailGrid.getSelectionModel().isSelected(selRecord)) {
							sm.deselect(data2);
						} else {
							sm.select(data);
						}
					}
				}
			},
			beforeedit: function( editor, e, eOpts ) {
				//20210222 추가 - 체크된 데이터가 있을 경우에는 초기화 후 수정하도록 처리
				var checkFlag = false;
				var saveFlag = panelResult.getValues().REGI_YN;
				if(saveFlag == 'Y') {
					var records = detailGrid.getStore().data.items;
					Ext.each(records, function(record, idx) {
						if(record.get('OPR_FLAG') == 'D') {
							checkFlag = true;
							return false;
						}
					});
					if(checkFlag && UniUtils.indexOf(e.field, ['DELIV_METHOD', 'RECEIVER_NAME', 'TELEPHONE_NUM1', 'TELEPHONE_NUM2', 'ZIP_NUM', 'ADDRESS1', 'INVOICE_NUM'])) {
						Unilite.messageBox('조회버튼을 눌려 초기화 하신 후, 수정작업을 진행하세요.');
						return false;
					}
				}
				//20210201 추가: 배송방법은 무조건 수정 가능
				if (UniUtils.indexOf(e.field, ['DELIV_METHOD'])) {
					return true;
				}
				//20210208 추가: 택배배송일 때는 수령자명, 전화번호, 핸드폰, 우편번호, 주소 수정 가능하도록 수정 - 무조건 수정할 수 있도록 변경
				if(UniUtils.indexOf(e.field, ['RECEIVER_NAME', 'TELEPHONE_NUM1', 'TELEPHONE_NUM2', 'ZIP_NUM', 'ADDRESS1', 'ORDER_TEL1', 'ORDER_TEL2'])) {		//20210503 추가: , 'ORDER_TEL1', 'ORDER_TEL2'
//					if (e.record.get('DELIV_METHOD') == '01' || e.record.get('DELIV_METHOD') == '02' || e.record.get('DELIV_METHOD') == '03') {
						return true;
//					} else {
//						Unilite.messageBox('수령자 관련 정보는 배송방법이 택배배송일 때만 수정할 수 있습니다.');
//						return false;
//					}
				}
				//20201230 추가: 등록된 데이터중 택배배송의 경우 송장번호 변경 가능
				if(saveFlag == 'Y') {								//등록된 데이터
					if (UniUtils.indexOf(e.field, ['INVOICE_NUM'])
					/*&& (e.record.get('DELIV_METHOD') == '01' || e.record.get('DELIV_METHOD') == '02' || e.record.get('DELIV_METHOD') == '03')*/) {	//20210209 수정: 송장번호는 무조건 수정할 수 있게 변경
						return true;
					} else {
						return false;
					}
				} else {											//미등록된 데이터
					if (UniUtils.indexOf(e.field, ['ISSUING_NUMBER'/*, 'DELIV_METHOD', 'INVOICE_NUM'*/])) {		//20201223 수정: DELIV_METHOD, INVOICE_NUM
						return true;
					} else {
						return false;
					}
				}
			}
		},
		//20210208 추가: 출력여부가 Y이면 표시
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store) {
				var cls = '';
				if(record.get('PRINT_YN') == 'Y') {
					cls = 'x-change-cell3';
				}
				return cls;
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'	, '');
				grdRecord.set('ITEM_NAME'	, '');
				grdRecord.set('SPEC'		, '');
			} else {
				grdRecord.set('ITEM_CODE'	, record[0].ITEM_CODE);
				grdRecord.set('ITEM_NAME'	, record[0].ITEM_NAME);
				grdRecord.set('SPEC'		, record[0].SPEC);
			}
		}
	});



	Unilite.Main({
		id			: 's_srq100ukrv_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid
			]
		}],
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['reset'], true);
			this.setDefault();

			//20210203 수정: 링크 받는로직 추가
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
				UniAppManager.setToolbarButtons(['deleteAll'], true);
			}
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('ORDER_PRSN'		, BsaCodeInfo.defaultSalePrsn);
			panelResult.setValue('ORDER_DATE_FR'	, UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO'	, UniDate.get('today'));
			panelResult.setValue('ISSUE_REQ_DATE'	, UniDate.get('today'));
			panelResult.getField('REGI_YN').setValue('N');
			//20201223 추가: 출하지시서, 운송장 출력기능 추가
			detailGrid.down('#orderReqPrintBtn').disable();
			detailGrid.down('#carriageBillprintBtn').disable();
			//20210618 추가: 엑셀다운로드 기능 추가(선택된 파일만 다운로드 하도록 기능 추가)
			detailGrid.down('#excelDownload').disable();
		},
		//202210203 추가: 링크로 넘어오는 params 받는 부분
		processParams: function(params) {
			if(params.PGM_ID == 'sof100ukrv') {
				var formPram = params.formPram;
				panelResult.setValue('DIV_CODE'			, formPram.DIV_CODE);
				panelResult.setValue('ORDER_PRSN'		, formPram.ORDER_PRSN);
				panelResult.setValue('ORDER_NUM'		, formPram.ORDER_NUM);
				panelResult.setValue('ISSUE_REQ_DATE'	, UniDate.get('today'));
				panelResult.getField('REGI_YN').setValue('N');
				detailGrid.down('#orderReqPrintBtn').disable();
				detailGrid.down('#carriageBillprintBtn').disable();
				//20210618 추가: 엑셀다운로드 기능 추가(선택된 파일만 다운로드 하도록 기능 추가)
				detailGrid.down('#excelDownload').disable();

				UniAppManager.app.onQueryButtonDown();
				panelResult.setValue('ORDER_NUM'	, '');
			}
		},
		onQueryButtonDown: function (newValue) {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			panelResult.setAllFieldsReadOnly(true);
			//20201223 추가: 출하지시서, 운송장 출력기능 추가
			detailGrid.down('#orderReqPrintBtn').disable();
			detailGrid.down('#carriageBillprintBtn').disable();
			//20210618 추가: 엑셀다운로드 기능 추가(선택된 파일만 다운로드 하도록 기능 추가)
			detailGrid.down('#excelDownload').disable();

			if(Ext.isEmpty(newValue)) {
				detailStore.loadStoreRecords();
			} else {
				detailStore.loadStoreRecords(newValue);
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			} else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('ISSUE_REQ_Q') > 0 || selRow.get('OUTSTOCK_Q') > 0 ) {												//동시매출발생이 아닌 경우,매출존재체크 제외
					Unilite.messageBox('<t:message code="system.message.sales.datacheck007" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
					return false;
				}
				detailGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom) {							//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else {										//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
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
			var saveFlag = panelResult.getValues().REGI_YN;
			if(saveFlag == 'N') {
				var record = detailGrid.getSelectedRecord();
				if(Ext.isEmpty(record)) {
					Unilite.messageBox('저장할 데이터를 선택하시오.');
					return false;
				}
			} else {
				//20210208 추가: 삭제(출하지시 데이터 삭제) 저장시 확인 메세지 추가
				var records = detailGrid.getSelectedRecords();
				var delFlag = false;
				if(!Ext.isEmpty(records)) {
					if(!confirm('선택된 출하지시 데이터를 취소하시겠습니까?')) {
						return false;
					} else {
						//20210407 추가: 작업지시 데이터 존재여부 확인하여 있을 경우, 팝업 한 번 더 띄우도록 수정
						var wkordMsg	= '';
						var wkordSeq	= 0;
						Ext.each(records, function(record, i) {
							if(!Ext.isEmpty(record.get('WKORD_NUM'))) {
								if(wkordSeq == 0) {
									wkordMsg = record.get('WKORD_NUM');
								} else {
									wkordMsg = wkordMsg + ', ' + record.get('WKORD_NUM');
								}
								wkordSeq++;
							}
						});
						if(wkordSeq != 0) {
							if(!confirm('작업지시 데이터가 존재하는 출하지시 데이터가 있습니다.\n계속 진행하시겠습니까? \n작업지시번호: ' + wkordMsg)) {
								return false;
							}
						}
					}
				}
			}
			detailStore.saveStore();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.getStore().loadData({});
			this.fnInitBinding();
		},
		fnAccountYN: function(rtnRecord, subCode) {
			var fRecord ='';
			Ext.each(BsaCodeInfo.gsOutType, function(item, i) {
				if(item['codeNo'] == subCode && !Ext.isEmpty(item['refCode1'])) {
					fRecord = item['refCode1'];
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
			switch(fieldName) {
				//20201230 추가
				case 'INVOICE_NUM':
					record.set('INVOICE_NUM2'	, newValue);
					record.set('OPR_FLAG'		, 'U');
				break;

				//20210201 추가
				case 'DELIV_METHOD':
				//20210208 추가: 수령자명, 전화번호, 핸드폰, 우편번호, 주소 수정 가능하도록 수정
				case 'RECEIVER_NAME':
				case 'ZIP_NUM':
				case 'ADDRESS1':
					var saveFlag = panelResult.getValues().REGI_YN;
					if(saveFlag == 'Y') {
						record.set('OPR_FLAG', 'U');
					}
				break;

				//20210208 추가: 전화번호 입력 시, 전화번호 유효성 체크로직 추가
				case "TELEPHONE_NUM1" :
					if(!Ext.isEmpty(newValue)) {
						if(!tel_check(newValue)) {
							rv = '올바른 전화번호를 입력하세요.'
							record.set('TELEPHONE_NUM1', oldValue);
							break;
						}
					}
					var saveFlag = panelResult.getValues().REGI_YN;
					if(saveFlag == 'Y') {
						record.set('OPR_FLAG', 'U');
					}
					break;

				//20210208 추가: 전화번호 입력 시, 전화번호 유효성 체크로직 추가
				case "TELEPHONE_NUM2" :
					if(!Ext.isEmpty(newValue)) {
						if(!tel_check(newValue)) {
							rv = '올바른 전화번호를 입력하세요.'
							record.set('TELEPHONE_NUM2', oldValue);
							break;
						}
					}
					var saveFlag = panelResult.getValues().REGI_YN;
					if(saveFlag == 'Y') {
						record.set('OPR_FLAG', 'U');
					}
					break;

				//20210503 추가: 주문자 전화번호 입력 시, 전화번호 유효성 체크로직 추가
				case "ORDER_TEL1" :
					if(!Ext.isEmpty(newValue)) {
						if(!tel_check(newValue)) {
							rv = '올바른 전화번호를 입력하세요.'
							record.set('ORDER_TEL1', oldValue);
							break;
						}
					}
					var saveFlag = panelResult.getValues().REGI_YN;
					if(saveFlag == 'Y') {
						record.set('OPR_FLAG', 'U');
					}
					break;

				//20210503 추가: 주문자 전화번호 입력 시, 전화번호 유효성 체크로직 추가
				case "ORDER_TEL2" :
					if(!Ext.isEmpty(newValue)) {
						if(!tel_check(newValue)) {
							rv = '올바른 전화번호를 입력하세요.'
							record.set('ORDER_TEL2', oldValue);
							break;
						}
					}
					var saveFlag = panelResult.getValues().REGI_YN;
					if(saveFlag == 'Y') {
						record.set('OPR_FLAG', 'U');
					}
					break;
			}
			return rv;
		}
	});

	//20210208 추가: 전화번호 체크로직 추가, 20210218 수정: 안심번호 체크로직 추가
	function tel_check(str) {
//		str = str.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
//		var regTel = /^(01[016789]{1}|070|02|0[3-9]{1}[0-9]{1})-[0-9]{3,4}-[0-9]{4}$/;
		str = str.replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
		var regTel = /^(050[2-8]{1}|01[016789]{1}|070|02|0[3-9]{1}[0-9]{1})-[0-9]{3,4}-[0-9]{4}$/;
		if(!regTel.test(str)) {
			return false;
		}
		return true;
	}

	//2020617 추가: 선택된 데이터만 엑셀 다운로드 하는 기능을 구현하기 위해 추가
	var panelFileDown = Unilite.createForm('FileDownForm', {
		url				: CPATH+'/z_wm/s_srq100ukrvExcelDown.do',
		layout			: {type: 'uniTable', columns: 1},
		disabled		: false,
		autoScroll		: false,
		standardSubmit	: true
	});
};
</script>