<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sof103skrv_wm">
	<t:ExtComboStore comboType="BOR120"  pgmId="s_sof103skrv_wm" />			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B030"/>						<!-- 과세포함여부-->
	<t:ExtComboStore comboType="AU" comboCode="P001" opts= '2;3;5;7;8;9'/>	<!-- 진행상태(작지상태) -->
	<t:ExtComboStore comboType="AU" comboCode="S002"/>						<!-- 판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>						<!-- 영업담당자-->
	<t:ExtComboStore comboType="AU" comboCode="S011"/>						<!-- 수주상태-->
	<t:ExtComboStore comboType="AU" comboCode="ZM11"/>						<!-- 배송방법-->		<%--20201217추가 --%>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="s_sof103skrv_wmLevel1Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="s_sof103skrv_wmLevel2Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="s_sof103skrv_wmLevel3Store"/>
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-change-cell1 {color: red;}
	.x-change-cell2 {color: #ffa500;}
	.x-change-cell3 {color: #228b22;}
	.x-grid-cell-essential1 {background-color: #FFFFC6;}		//바탕 연한 노랑
	.x-grid-cell-essential2 {background-color: #FDE3FF;}		//바탕 분홍
	.x-change-cell_row1 {background-color: #f7f6eb;}			//바탕 진한 노랑
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsBalanceOut		: '${gsBalanceOut}',
	defaultSalePrsn		: '${defaultSalePrsn}'		//영업담당(default)
};
var activeGridId	= 's_sof103skrv_wmGrid';
//20210126 추가: 주문묶음번호에 따라 그리드 색 변경하기 위해서 추가
var gsBundleNo;
var gsBundleNoColor;

function appMain() {
	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,//true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
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
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('ORDER_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '주문일',
				startFieldName	: 'ORDER_DATE_FR',
				endFieldName	: 'ORDER_DATE_TO',
				xtype			: 'uniDateRangefield',
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_TO', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
				xtype		: 'uniTextfield',
				name		: 'RECEIVER_NAME',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('RECEIVER_NAME', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name		: 'ORDER_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE', newValue);
						if(Ext.isEmpty(newValue)) {
							panelSearch.setValue('CUSTOM_NAME', newValue);
							panelResult.setValue('CUSTOM_NAME', newValue);
						}
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);
					},
				applyextparam: function(popup) {
					popup.setExtParam({'CUSTOM_TYPE':['1','3']});
				}
			}
		}),{
				fieldLabel	: '연락처',
				xtype		: 'uniTextfield',
				name		: 'PHONE_NUM',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PHONE_NUM', newValue);
					}
				}
			},{	//20201224 추가
			xtype		: 'radiogroup',
			fieldLabel	: '수주상태',
			items		: [{
				boxLabel	: '전체',
				name		: 'ORDER_STATUS',
				inputValue	: '', 
				width		: 60,
				checked		: true
			},{
				boxLabel	: '정상/미마감',
				name		: 'ORDER_STATUS',
				inputValue	: 'N', 
				width		: 100
			},{
				boxLabel	: '취소/마감',
				width		: 80,
				name		: 'ORDER_STATUS',
				inputValue	: 'Y'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('ORDER_STATUS').setValue(newValue.ORDER_STATUS);
					//20201228 추가
					detailStore.loadStoreRecords(newValue.ORDER_STATUS);
					detailStore2.loadStoreRecords(newValue.ORDER_STATUS);
				}
			}
		},{
				fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name		: 'ORDER_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S002',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},Unilite.popup('DIV_PUMOK',{
				fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('ITEM_NAME', newValue);
						panelResult.setValue('ITEM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				},
				applyextparam: function(popup) {
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
				fieldLabel	: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_sof103skrv_wmLevel1Store'),
				child		: 'ITEM_LEVEL2',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{
				fieldLabel	: '중분류',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_sof103skrv_wmLevel2Store'),
				child		: 'ITEM_LEVEL3',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{
				fieldLabel	: '소분류',
				name		: 'ITEM_LEVEL3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_sof103skrv_wmLevel3Store'),
//				parentNames	: ['ITEM_LEVEL1','ITEM_LEVEL2'],
//				levelType	: 'ITEM',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL3', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 4
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding		: '1 1 1 1',
		border		: true,
		items		: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelSearch.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '주문일',
			startFieldName	: 'ORDER_DATE_FR',
			endFieldName	: 'ORDER_DATE_TO',
			xtype			: 'uniDateRangefield',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_FR', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_TO', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
			xtype		: 'uniTextfield',
			name		: 'RECEIVER_NAME',
//			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('RECEIVER_NAME', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
			name		: 'ITEM_LEVEL1',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('s_sof103skrv_wmLevel1Store'),
			child		: 'ITEM_LEVEL2',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_LEVEL1', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_PRSN', newValue);
				}
			},
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('CUSTOM_NAME', newValue);
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);
				},
				applyextparam: function(popup) {
					popup.setExtParam({'CUSTOM_TYPE':['1','3']});
				}
			}
		}),{
			fieldLabel	: '연락처',
			xtype		: 'uniTextfield',
			name		: 'PHONE_NUM',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PHONE_NUM', newValue);
				}
			}
		},{
			fieldLabel	: '중분류',
			name		: 'ITEM_LEVEL2',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('s_sof103skrv_wmLevel2Store'),
			child		: 'ITEM_LEVEL3',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_LEVEL2', newValue);
				}
			}
		},{	//20201224 추가
			xtype		: 'radiogroup',
			fieldLabel	: '수주상태',
			hidden		: true,
			items		: [{
				boxLabel	: '전체',
				name		: 'ORDER_STATUS',
				inputValue	: '', 
				width		: 60,
				checked		: true
			},{
				boxLabel	: '정상/미마감',
				name		: 'ORDER_STATUS',
				inputValue	: 'N', 
				width		: 100
			},{
				boxLabel	: '취소/마감',
				width		: 80,
				name		: 'ORDER_STATUS',
				inputValue	: 'Y'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('ORDER_STATUS').setValue(newValue.ORDER_STATUS);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
			name		: 'ORDER_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S002',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_TYPE', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('ITEM_NAME', newValue);
						panelResult.setValue('ITEM_NAME', newValue);
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				},
				applyextparam: function(popup) {
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{//20201224 추가
			xtype		: 'radiogroup',
			fieldLabel	: '수주상태',
			items		: [{
				boxLabel	: '전체',
				name		: 'ORDER_STATUS',
				inputValue	: '', 
				width		: 60,
				checked		: true
			},{
				boxLabel	: '정상/미마감',
				name		: 'ORDER_STATUS',
				inputValue	: 'N', 
				width		: 100
			},{
				boxLabel	: '취소/마감',
				width		: 80,
				name		: 'ORDER_STATUS',
				inputValue	: 'Y'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('ORDER_STATUS').setValue(newValue.ORDER_STATUS);
				}
			}
		},{
			fieldLabel	: '소분류',
			name		: 'ITEM_LEVEL3',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('s_sof103skrv_wmLevel3Store'),
//			parentNames	: ['ITEM_LEVEL1','ITEM_LEVEL2'],
//			levelType	: 'ITEM',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_LEVEL3', newValue);
				}
			}
		}],
		listeners: {
			uniOnChange:function( basicForm, dirty, eOpts ) {
			}
		}
	});



	Unilite.defineModel('s_sof103skrv_wmModel', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'		, type: 'string', allowBlank: false},
			{name: 'DIV_CODE'		, text: 'DIV_CODE'		, type: 'string', allowBlank: false},
			{name: 'ORDER_NUM'		, text: '수주번호'			, type: 'string'},
			{name: 'SER_NO'			, text: '수주순번'			, type: 'int'	, allowBlank: false},
			{name: 'UNIQUEID'		, text: 'UNIQUEID'		, type: 'string'},									//UNIQUEID
			{name: 'NUMBER'			, text: 'NUMBER'		, type: 'string', allowBlank: false},				//NUMBER
			{name: 'SITE_CODE'		, text: '판매사이트코드'		, type: 'string', allowBlank: false},				//SITECODE
			{name: 'SITE_NAME'		, text: '판매사이트'			, type: 'string', allowBlank: false},				//SITENAME
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'	, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname2" default="품명"/>'		, type: 'string', allowBlank: false},
			{name: 'SPEC'			, text: '<t:message code="system.label.sales.spec" default="규격"/>'			, type: 'string', editable: false},
			{name: 'SHOP_SALE_NAME'	, text: '상품명'			, type: 'string'},									//SHOP_SALE_NAME
			{name: 'SHOP_OPT_NAME'	, text: '옵션명'			, type: 'string'},									//SHOP_SALE_NAME
			{name: 'ORDER_Q'		, text: '수량'			, type: 'uniQty'		, allowBlank: false},		//COUNT
			{name: 'ORDER_P'		, text: '단가'			, type: 'uniUnitPrice'},		//20201208 추가
			{name: 'ORDER_PRICE'	, text: '판매가'			, type: 'uniPrice'		, allowBlank: false},		//PRICE
			{name: 'ORDER_TAX_O'	, text: '부가세'			, type: 'uniPrice'},								//20201208 추가
			{name: 'SUM_PRICE'		, text: '합계금액'			, type: 'uniPrice'},								//20201208 추가
			{name: 'SHOP_ORD_NO'	, text: '주문번호'			, type: 'string'},									//SHOP_ORD_NO
			{name: 'RECEIVER_NAME'	, text: '수령자명'			, type: 'string'},									//RECIPIENTNAME
			{name: 'TELEPHONE_NUM1'	, text: '수령자전화번호'		, type: 'string'},									//RECIPIENTTEL
			{name: 'TELEPHONE_NUM2'	, text: '수령자핸드폰'		, type: 'string'},									//RECIPIENTHTEL
			{name: 'ZIP_NUM'		, text: '우편번호'			, type: 'string'},									//RECIPIENTZIP
			{name: 'ADDRESS1'		, text: '주소1'			, type: 'string'},									//RECIPIENTADDRESS
			{name: 'ADDRESS2'		, text: '주소2'			, type: 'string'},									//RECIPIENTADDRESS
			{name: 'DELIV_METHOD'	, text: '배송방법'			, type: 'string', comboType: 'AU', comboCode: 'ZM11'},	//DELIVMETHOD, 20201223 공통코드로 변경
			{name: 'ORD_STATUS'		, text: '주문상태'			, type: 'string'},									//ORD_STATUS
			{name: 'SENDER_CODE'	, text: '택배사코드'			, type: 'int'},										//SENDER_CODE
			{name: 'SENDER'			, text: '택배사'			, type: 'string'},									//SENDER
			{name: 'DELIV_PRICE'	, text: '배송비'			, type: 'uniPrice'},								//DELIVPRICE
			{name: 'DVRY_DATE'		, text: '배송예정일'			, type: 'uniDate'},									//DELIVDATE
			{name: 'CUSTOMER_ID'	, text: '주문자ID'			, type: 'string'},									//ORDERID
			{name: 'ORDER_NAME'		, text: '주문자명'			, type: 'string'},									//ORDERNAME
			{name: 'ORDER_TEL1'		, text: '주문자전화번호'		, type: 'string'},									//ORDERTEL
			{name: 'ORDER_TEL2'		, text: '주문자핸드폰'		, type: 'string'},									//ORDERHTEL
			{name: 'ORDER_MAIL'		, text: '주문자email'		, type: 'string'},									//ORDEREMAIL
			{name: 'MSG'			, text: '배송메세지'			, type: 'string'},									//MSG
			{name: 'INVOICE_NUM'	, text: '송장번호'			, type: 'string'},									//INVOICE_NUM
			{name: 'SHOP_ORD_NO'	, text: '쇼핑몰 주문번호'		, type: 'string'},									//SHOP_ORD_NO
			{name: 'SHOP_SALE_NO'	, text: '쇼핑몰 판매번호'		, type: 'string'},									//SHOP_SALE_NO
			{name: 'BUNDLE_NO'		, text: '주문묶음번호'		, type: 'string'},									//BUNDLE_NO
			{name: 'ISSUE_REQ_Q'	, text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'	, type: 'uniQty', defaultValue: 0},
			{name: 'OUTSTOCK_Q'		, text: 'OUTSTOCK_Q'	, type: 'int', defaultValue: 0},
			{name: 'TAX_INOUT'		, text: '세액포함 여부'		, type: 'string', comboType: 'AU', comboCode: 'B030'},
			{name: 'ORDER_PRSN'		, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string', comboType: 'AU', comboCode: 'S010'},
			{name: 'ORDER_DATE'		, text: '주문일자'			, type:'uniDate'},
			{name: 'INVOICE_NUM'	, text: '운송장번호1'		, type: 'string'},
			{name: 'INVOICE_NUM2'	, text: '운송장번호2'		, type: 'string'},
			{name: 'ORDER_STATUS'	, text: '수주상태'			, type: 'string', comboType: 'AU', comboCode: 'S011'},
			{name: 'OUTSTOCK_Q'		, text: '출고수량'			, type: 'uniQty'},
			//20210215 추가: 작지상태, 작업지시량, 실적수량, 검사수량
			{name: 'CONTROL_STATUS'	, text: '작지상태'			, type: 'string', comboType: 'AU', comboCode:"P001"},
			{name: 'WKORD_Q'		, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		, type: 'uniQty'},
			{name: 'PRODT_Q'		, text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'		, type: 'uniQty'},
			{name: 'INSPEC_Q'		, text: '<t:message code="system.label.purchase.inspectqty" default="검사수량"/>'		, type: 'uniQty'}
		]
	});

	var detailStore = Unilite.createStore('s_sof103skrv_wmDetailStore',{
		model	: 's_sof103skrv_wmModel',
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_sof103skrv_wmService.selectList'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부
			allDeletable: false,	// 전체 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function(newValue) {
			var param = panelResult.getValues();
			if(newValue || newValue == '') {
				param.ORDER_STATUS = newValue;
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
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
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

	var detailGrid = Unilite.createGrid('s_sof103skrv_wmGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',showSummaryRow: false},
					{id : 'masterGridTotal',	ftype: 'uniSummary',		showSummaryRow: false}],
		columns	: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'UNIQUEID'			, width: 100, hidden: true},
			{dataIndex: 'NUMBER'			, width: 100, hidden: true},
			{dataIndex: 'ORDER_NUM'			, width: 100, hidden: true},
			{dataIndex: 'SER_NO'			, width: 100, hidden: true},
			{dataIndex: 'SITE_CODE'			, width: 100, hidden: true},
			{dataIndex: 'ORD_STATUS'		, width: 90	, hidden: false, align: 'center'},
			{dataIndex: 'BUNDLE_NO'			, width: 120, hidden: false},		//20210126 위치 이동 / 보이게
			{dataIndex: 'SITE_NAME'			, width: 110},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 150},		//20201224 추가
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'SHOP_SALE_NAME'	, width: 120},
			{dataIndex: 'SHOP_OPT_NAME'		, width: 120, hidden: true},
			{dataIndex: 'ORDER_Q'			, width: 80	, align: 'center'},
			{dataIndex: 'ORDER_P'			, width: 100},
			{dataIndex: 'ORDER_PRICE'		, width: 100},
			{dataIndex: 'ORDER_TAX_O'		, width: 100},
			{dataIndex: 'SUM_PRICE'			, width: 100},
			{dataIndex: 'TAX_INOUT'			, width: 100, align: 'center'},
			{dataIndex: 'ORDER_PRSN'		, width: 100},
			{dataIndex: 'ORDER_DATE'		, width: 100},
			{dataIndex: 'SHOP_ORD_NO'		, width: 110},
			{dataIndex: 'RECEIVER_NAME'		, width: 100},
			{dataIndex: 'TELEPHONE_NUM1'	, width: 120},
			{dataIndex: 'TELEPHONE_NUM2'	, width: 120},
			{dataIndex: 'ZIP_NUM'			, width: 100},
			{dataIndex: 'ADDRESS1'			, width: 200},
			{dataIndex: 'ADDRESS2'			, width: 200},
			{dataIndex: 'DELIV_METHOD'		, width: 100, align: 'center'},	//20201223 수정: 정렬 변경
			{dataIndex: 'DELIV_PRICE'		, width: 100, hidden: true},
			{dataIndex: 'DVRY_DATE'			, width: 100, hidden: true},
			{dataIndex: 'CUSTOMER_ID'		, width: 100, hidden: true},
			{dataIndex: 'ORDER_NAME'		, width: 100, hidden: true},
			{dataIndex: 'ORDER_TEL1'		, width: 100, hidden: true},
			{dataIndex: 'ORDER_TEL2'		, width: 100, hidden: true},
			{dataIndex: 'ORDER_MAIL'		, width: 100, hidden: true},
			{dataIndex: 'MSG'				, width: 100, hidden: true},
			{dataIndex: 'SENDER_CODE'		, width: 100, hidden: true},
			{dataIndex: 'SENDER'			, width: 100, hidden: true},
			{dataIndex: 'SHOP_ORD_NO'		, width: 100, hidden: true},
			{dataIndex: 'SHOP_SALE_NO'		, width: 100, hidden: true},
			{dataIndex: 'INVOICE_NUM'		, width: 100,
				renderer: function (val, meta, record) {
					if (!Ext.isEmpty(val)) {
//						return '<a href="http://nplus.doortodoor.co.kr/web/detail.jsp?slipno=' + val + '" target="_blank">' + val + '</a>';
						return '<div style="color: blue">' + val + '</div>';
					} else {
						return '';
					}
				}
			},
			{dataIndex: 'INVOICE_NUM2'		, width: 100},
			{dataIndex: 'ORDER_STATUS'		, width: 100, align: 'center'},
			//20210215 추가: 작지상태, 작업지시량, 실적수량, 검사수량
			{dataIndex: 'CONTROL_STATUS'	, width: 80		, align: 'center'},
			{dataIndex: 'WKORD_Q'			, width: 100},
			{dataIndex: 'PRODT_Q'			, width: 100},
			{dataIndex: 'INSPEC_Q'			, width: 100},
			{dataIndex: 'OUTSTOCK_Q'		, width: 100}
		],
		listeners: {
			//20210316 추가: 마우스 오른 쪽 클릭 - 주문등록(일괄) (WM) (s_sof103ukrv_wm)으로 이동하는 링크 추가
			itemmouseenter:function(view, record, item, index, e, eOpts) {
				view.ownerGrid.setCellPointer(view, item);
			},
			selectionchange: function( grid, selected, eOpts ){
				detailStore2.clearFilter();
				//선택된 행의 저장된 데이터만 detailGrid에 보여주도록 filter
				if(selected && selected[0]) {
					detailStore2.filterBy(function(record){
						return record.get('BUNDLE_NO') == selected[0].get('BUNDLE_NO')
							&& record.get('ORDER_NUM') == selected[0].get('ORDER_NUM')
							&& record.get('SER_NO') == selected[0].get('SER_NO');
					})
				} else {
					detailStore2.filterBy(function(record){
						return record.get('BUNDLE_NO') == 'ZZZZZ';
					})
				}
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ){
				detailStore2.clearFilter();
				//선택된 행의 저장된 데이터만 detailGrid에 보여주도록 filter
				if(thisRecord) {
					detailStore2.filterBy(function(record){
						return record.get('BUNDLE_NO') == thisRecord.get('BUNDLE_NO')
							&& record.get('ORDER_NUM') == thisRecord.get('ORDER_NUM')
							&& record.get('SER_NO') == thisRecord.get('SER_NO');
					})
				}
				//클릭 시, 송장 조회화면 팝업 open
				if(grid.panel.headerCt.getHeaderAtIndex(cellIndex).dataIndex == 'INVOICE_NUM' && !Ext.isEmpty(thisRecord.get('INVOICE_NUM'))) {		//20201224 추가: grid.panel.headerCt.getHeaderAtIndex(cellIndex).dataIndex == 'INVOICE_NUM' &&
					openSearchPopup(thisRecord.get('INVOICE_NUM'))
				}
			},
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
				});
			}
		},
		//20210316 추가: 마우스 오른 쪽 클릭 - 주문등록(일괄) (WM) (s_sof103ukrv_wm)으로 이동하는 링크 추가
		onItemcontextmenu:function(menu, grid, record, item, index, event) {
			menu.down('#link_S_Sof103ukrv').show();
		},
		uniRowContextMenu:{
			items: [{
				text	: '주문등록(일괄) (WM)으로 이동',
				itemId	: 'link_S_Sof103ukrv',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					detailGrid.goto_S_Sof103ukrv(param.record);
				}
			}]
		},
		goto_S_Sof103ukrv:function(record) {
			if(record) {
				var params = {
					action			: 'select',
					'PGM_ID'		: PGM_ID,
					'DIV_CODE'		: record.data['DIV_CODE'],
					'ORDER_DATE'	: UniDate.getDbDateStr(record.data['ORDER_DATE']),
					'ORDER_PRSN'	: record.data['ORDER_PRSN'],
					'ORDER_NAME'	: record.data['ORDER_NAME']
				}
				var rec = {data : {prgID : 's_sof103ukrv_wm', 'text':''}};
				parent.openTab(rec, '/z_wm/s_sof103ukrv_wm.do', params);
			}
		},
		viewConfig: {
			//20210126 추가: 주문묶음번호에 따라 그리드 색 변경하기 위해서 추가
			renderRow: function (record, rowIdx, out) {
				var me					= this,
				isMetadataRecord		= rowIdx === -1,
				selModel				= me.selectionModel,
				rowValues				= me.rowValues,
				itemClasses				= rowValues.itemClasses,
				rowClasses				= rowValues.rowClasses,
				itemCls					= me.itemCls,
				cls,
				rowTpl					= me.rowTpl;
				rowValues.rowAttr		= {};
				// Set up mandatory properties on rowValues
				rowValues.record		= record;
				rowValues.recordId		= record.internalId;
				// recordIndex is index in true store (NOT the data source - possibly a GroupStore)
				rowValues.recordIndex	= me.store.indexOf(record);
				// rowIndex is the row number in the view.
				rowValues.rowIndex		= rowIdx;
				rowValues.rowId			= me.getRowId(record);
				rowValues.itemCls		= rowValues.rowCls = '';
				if (!rowValues.columns) {
					rowValues.columns = me.ownerCt.getVisibleColumnManager().getColumns();
				}
				itemClasses.length = rowClasses.length = 0;
				if (!isMetadataRecord) {
					itemClasses[0] = itemCls;
					if (!me.ownerCt.disableSelection && selModel.isRowSelected) {
						// Selection class goes on the outermost row, so it goes into itemClasses
						if (selModel.isRowSelected(record)) {
							itemClasses.push(me.selectedItemCls);
						}
					}
					if(rowIdx == 0) {
						gsBundleNoColor	= '';
						gsBundleNo		= record.get('BUNDLE_NO');
					} else {
						if(gsBundleNo != record.get('BUNDLE_NO')) {
							if(gsBundleNoColor != 'x-change-cell_row1') {
								itemClasses.push('x-change-cell_row1');
								gsBundleNoColor	= 'x-change-cell_row1';
								gsBundleNo		= record.get('BUNDLE_NO');
							} else {
								itemClasses.push('');
								gsBundleNoColor	= '';
								gsBundleNo		= record.get('BUNDLE_NO');
							}
						} else {
							itemClasses.push(gsBundleNoColor);
						}
					}
					if(me.getRowClass) {
						cls = me.getRowClass(record, rowIdx, null, me.dataSource);
						if (cls) {
							rowClasses.push(cls);
						}
					}
				}
				if (out) {
					rowTpl.applyOut(rowValues, out, me.tableValues);
				} else {
					return rowTpl.apply(rowValues, me.tableValues);
				}
				if(me.ownerGrid.uniOpt && me.ownerGrid.uniOpt.useLiveSearch && me.ownerGrid.searchRegExp)	{
					setTimeout(function(){
						try{
							if(me.ownerGrid.uniOpt && me.ownerGrid.uniOpt.useLiveSearch && me.ownerGrid.searchRegExp)	{
								me.ownerGrid._setHighlite(me, rowIdx);
							}
						}catch(e){
							console.log(e)
						}
					}, 1000);
				}
			},
			getRowClass: function(record, rowIndex, rowParams, store) {
				var cls = '';
				if(record.get('ORDER_STATUS') == 'Y') {
					cls = 'x-change-cell1';
				} else if(record.get('ORD_STATUS').substring(0, 2) == '취소') {
					cls = 'x-change-cell2';
				}
				return cls;
			}
		}
	});


	Unilite.defineModel('s_sof103skrv_wmModel2', {	//S_SOF115T_WM에 저장
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'		, type: 'string'	, allowBlank: false},
			{name: 'DIV_CODE'		, text: 'DIV_CODE'		, type: 'string'	, allowBlank: false},
			{name: 'UNIQUEID'		, text: 'UNIQUEID'		, type: 'string'},		//UNIQUEID
			{name: 'NUMBER'			, text: 'NUMBER'		, type: 'string'},		//NUMBER
			{name: 'ORDER_NUM'		, text: '수주번호'			, type: 'string'},
			{name: 'SER_NO'			, text: '수주순번'			, type: 'int'		, allowBlank: false},
			{name: 'SUB_SEQ'		, text: '구분'			, type: 'int'		, allowBlank: false},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'	, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname2" default="품명"/>'		, type: 'string', allowBlank: false},
			{name: 'SPEC'			, text: '<t:message code="system.label.sales.spec" default="규격"/>'			, type: 'string', editable:false},
			{name: 'UNIT_Q'			, text: '수량'			, type: 'int'		, allowBlank: false},
			{name: 'UNIT_O'			, text: '금액'			, type: 'uniPrice'},						//20201208 추가:금액 필드 추가, 20201211 수정: 필수 제외
			{name: 'OLD_ITEM_CODE'	, text: '이전 품목'			, type: 'string'},
			{name: 'OLD_ITEM_NAME'	, text: '이전 품목명'		, type: 'string'},
			{name: 'OLD_ITEM_SPEC'	, text: '<t:message code="system.label.sales.spec" default="규격"/>'			, type: 'string', editable:false},
			{name: 'OLD_UNIT_Q'		, text: '이전 수량'			, type: 'int'},
			{name: 'PROD_ITEM_CODE'	, text: '모품목코드'			, type: 'string'},
			{name: 'BUNDLE_NO'		, text: '주문묶음번호'		, type: 'string'},							//BUNDLE_NO
			{name: 'REMARK'			, text: '비고'			, type: 'string'}							//20210316 추가
		]
	});

	var detailStore2 = Unilite.createStore('s_sof103skrv_wmDetailStore2',{
		model	: 's_sof103skrv_wmModel2',
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_sof103skrv_wmService.selectList2'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function(newValue) {
			var param = panelResult.getValues();
			if(newValue || newValue == '') {
				param.ORDER_STATUS = newValue;
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
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(detailGrid.getStore().data.items.length > 1) {
					detailStore2.filterBy(function(record){
						return record.get('BUNDLE_NO') == 'ZZZZZ';
					})
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

	var detailGrid2 = Unilite.createGrid('s_sof103skrv_wmGrid2', {
		store	: detailStore2,
		layout	: 'fit',
		region	: 'south',
		split	: true,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',showSummaryRow: false},
					{id : 'masterGridTotal',	ftype: 'uniSummary',		showSummaryRow: false}],
		columns	: [
			{dataIndex: 'UNIQUEID'		, width: 100, hidden: true},
			{dataIndex: 'NUMBER'		, width: 100, hidden: true},
			{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'ORDER_NUM'		, width: 100, hidden: true},
			{dataIndex: 'SER_NO'		, width: 100, hidden: true},
			{dataIndex: 'SUB_SEQ'		, width: 80	, align: 'center'},
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 150},
			{dataIndex: 'SPEC'			, width: 130},
			{dataIndex: 'UNIT_Q'		, width: 100, align: 'center'},
			{dataIndex: 'UNIT_O'		, width: 100},
			{dataIndex: 'OLD_ITEM_CODE'	, width: 120},
			{dataIndex: 'OLD_ITEM_NAME'	, width: 150},
			{dataIndex: 'OLD_ITEM_SPEC'	, width: 130},
			{dataIndex: 'OLD_UNIT_Q'	, width: 100, align: 'center'},
			{dataIndex: 'REMARK'		, width: 200}				//20210316 추가
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
				});
			}
		}
	});



	Unilite.Main({
		id			: 's_sof103skrv_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid, detailGrid2
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset'], true);
			this.setDefault();

			//초기화 시 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		setDefault: function() {
			panelSearch.setValue('DIV_CODE'			, UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE_FR'	, UniDate.add(new Date(),{ days: -7 }));
			panelSearch.setValue('ORDER_DATE_TO'	, new Date());
			panelSearch.setValue('ORDER_PRSN'		, BsaCodeInfo.defaultSalePrsn);
			panelSearch.getField('ORDER_STATUS').setValue('');		//20201224 추가

			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_FR'	, UniDate.add(new Date(),{ days: -7 }));
			panelResult.setValue('ORDER_DATE_TO'	, new Date());
			panelResult.setValue('ORDER_PRSN'		, BsaCodeInfo.defaultSalePrsn);
			panelResult.getField('ORDER_STATUS').setValue('');		//20201224 추가
		},
		onQueryButtonDown: function () {
			if(!panelResult.getInvalidMessage()) return;
			detailStore.loadStoreRecords();
			detailStore2.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			detailGrid.getStore().loadData({});
			detailGrid2.getStore().loadData({});
			this.fnInitBinding();
		}
	});


	function openSearchPopup(invoiceNum) {
		var url		= 'http://nplus.doortodoor.co.kr/web/detail.jsp?slipno=' + invoiceNum;
		var option	= 'scrollbars=no, left=100, top=100, width=700, height=700';
		window.open(url, null, option);
	}
};
</script>