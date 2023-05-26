<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_map110skrv_wm">
	<t:ExtComboStore comboType="BOR120" pgmId="s_map110skrv_wm"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055"/>				<!-- 고객분류 -->
	<t:ExtComboStore comboType="AU" comboCode="M001"/>				<!-- 발주형태 -->
	<t:ExtComboStore comboType="O"/>								<!-- 창고 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var AccTransWindow;				//계좌이체리스트 조회 팝업 - 20210304 추가

function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_map110skrv_wmModel', {
		fields: [
			{name: 'INOUT_CODE'			, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'					, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'					, type: 'string',comboType:'AU',comboCode:'M001'},
			{name: 'COMPANY_NUM'		, text: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>'			, type: 'string'},
			{name: 'BILL_NUM'			, text: '<t:message code="system.label.purchase.billno" default="계산서번호"/>'					, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.receiptdivision" default="입고사업장"/>'			, type: 'string',comboType:'BOR120'},
			{name: 'BILL_DATE'			, text: '<t:message code="system.label.purchase.billdate" default="계산서일"/>'					, type: 'uniDate'},
			{name: 'CHANGE_BASIS_DATE'	, text: '<t:message code="system.label.purchase.exdate" default="결의일"/>'					, type: 'uniDate'},
			{name: 'ISSUE_EXPECTED_DATE', text: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>'			, type: 'uniDate'},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'						, type: 'string'},
			{name: 'INOUT_Q'			, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				, type: 'uniQty'},
			{name: 'BUY_Q'				, text: '<t:message code="system.label.purchase.purchaseqty" default="매입량"/>'				, type: 'uniQty'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			, type: 'string'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'				, type: 'string'},
			{name: 'AMOUNT_P'			, text: '<t:message code="system.label.purchase.localprice" default="원화단가"/>'				, type: 'uniUnitPrice'},
			{name: 'AMOUNT_I'			, text: '<t:message code="system.label.purchase.localamount" default="원화금액"/>'				, type: 'uniPrice'},
			{name: 'TAX_I'				, text: 'VAT'				, type: 'uniPrice'},
			{name: 'TOTAL_I'			, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'				, type: 'uniPrice'},
			{name: 'FOR_AMOUNT_O'		, text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>'	, type: 'uniFC'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'				, type: 'uniER'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string'},
			{name: 'INOUT_METH'			, text: '<t:message code="system.label.purchase.tranmethod" default="수불방법"/>'				, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'					, type: 'string'},
			{name: 'EX_DATE'			, text: '<t:message code="system.label.purchase.exslipdate" default="결의전표일"/>'				, type: 'uniDate'},
			{name: 'EX_NUM'				, text: '<t:message code="system.label.purchase.exslipno" default="결의전표번호"/>'				, type: 'string'},
			{name: 'AC_DATE'			, text: '<t:message code="system.label.human.acdate" default="회계전표일"/>'						, type: 'uniDate'},
			{name: 'AC_NUM'				, text: '<t:message code="system.label.purchase.acslipno" default="회계전표번호"/>'				, type: 'string'},
			{name: 'AGREE_YN'			, text: '<t:message code="system.label.purchase.exslipapproveyn" default="결의전표승인여부"/>'		, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'				, type: 'string'},
			{name: 'CUSTOM_PRSN'		, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'				, type: 'string'},
			{name: 'PHONE'				, text: '연락처'				, type: 'string'},
			{name: 'BANK_NAME'			, text: '은행명'				, type: 'string'},
			{name: 'BANK_ACCOUNT'		, text: '계좌번호'				, type: 'string'},
			{name: 'BIRTHDAY'			, text: '생년월일'				, type: 'string'},		//20210312 수정: uniDate -> string
			{name: 'ZIP_CODE'			, text: '우편번호'				, type: 'string'},
			{name: 'ADDR1'				, text: '주소'				, type: 'string'},
			{name: 'ORG_AMT_I'			, text: '<t:message code="system.label.common.occuramount" default="발생금액"/>'		, type:'uniPrice'},		//20210524 추가
			{name: 'J_AMT_I'			, text: '반제금액'		, type:'uniPrice'},																		//20210524 추가
			{name: 'BLN_I'				, text: '잔액'		, type:'uniPrice'}																		//20210524 추가
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_map110skrv_wmMasterStore1',{
		model	: 's_map110skrv_wmModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_map110skrv_wmService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params:param,
				callback : function(records,options,success) {
					if(success) {
						if(Ext.isEmpty(records)){
							UniAppManager.setToolbarButtons(['print'], false);
						 }else{
							UniAppManager.setToolbarButtons(['print'], true);
						 }
					}
				}
			});
		},
		groupField: 'CUSTOM_NAME'
	});

	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title		: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel: '<t:message code="system.label.purchase.purchasedivision" default="매입사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				child:'IN_WH_CODE',
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
						var field2 = panelResult.getField('IN_WH_CODE');
						field2.getStore().clearFilter(true);
						panelSearch.setValue('IN_WH_CODE', '');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'BILL_DATE_FR',
				endFieldName: 'BILL_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('BILL_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('BILL_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
				name: 'IN_WH_CODE',
				comboType  : 'O',
				xtype: 'uniCombobox',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('IN_WH_CODE', newValue);
					},
						beforequery:function( queryPlan, eOpts ) {
							var store = queryPlan.combo.store;
								store.clearFilter();
							if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
								store.filterBy(function(record){
								return record.get('option') == panelSearch.getValue('DIV_CODE');
							})
							}else{
								store.filterBy(function(record){
								return false;
							})
						}
					}
				}
			},{	//20210304 추가: 조회조건 "전표승인여부" 추가
				fieldLabel	: '전표승인여부',
				xtype		: 'radiogroup',
				itemId		: 'rdo2',
				items		: [{
					boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
					name		: 'rdoSelect2',
					inputValue	: 'A',
					width		: 60,
					checked		: true
				},{
					boxLabel	: '승인',
					name		: 'rdoSelect2',
					inputValue	: 'Y',
					width		: 60
				},{
					boxLabel	: '미승인',
					name		: 'rdoSelect2',
					inputValue	: 'N',
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('rdoSelect2').setValue(newValue.rdoSelect2);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M001',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUST_CODE',
				textFieldName: 'CUST_NAME',
				popupWidth: 710,
				extParam: {'CUSTOM_TYPE': ['1','2']},
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUST_CODE', panelSearch.getValue('CUST_CODE'));
							panelResult.setValue('CUST_NAME', panelSearch.getValue('CUST_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUST_CODE', '');
						panelResult.setValue('CUST_NAME', '');
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.clienttype" default="고객분류"/>',
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AGENT_TYPE', newValue);
					}
				}
			},{	//20200218 추가: 조회조건 "기표여부" 추가
				fieldLabel	: '<t:message code="system.label.sales.slipyn" default="기표여부"/>',
				xtype		: 'radiogroup',
				itemId		: 'rdo',
				items		: [{
					boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
					name		: 'rdoSelect',
					inputValue	: 'A',
					width		: 60,
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.purchase.slipposting" default="기표"/>',
					name		: 'rdoSelect',
					inputValue	: 'Y',
					width		: 60
				},{
					boxLabel	: '<t:message code="system.label.purchase.notslipposting" default="미기표"/>',
					name		: 'rdoSelect',
					inputValue	: 'N',
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
					}
				}
			},{	//20210524 추가
				fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
				xtype		: 'uniTextfield',
				name		: 'CUSTOM_PRSN',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CUSTOM_PRSN', newValue);
					}
				}
			},{	//20210524 추가
				fieldLabel	: '지급여부',
				xtype		: 'radiogroup',
				itemId		: 'PROV_YN',
				items		: [{
					boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
					name		: 'PROV_YN',
					inputValue	: 'A',
					width		: 60
				},{
					boxLabel	: '지급', 
					name		: 'PROV_YN',
					inputValue	: 'Y',
					width		: 60
				},{
					boxLabel	: '미지급',
					name		: 'PROV_YN',
					inputValue	: 'N',
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('PROV_YN').setValue(newValue.PROV_YN);
					}
				}
			}
		]},{
			title:'<t:message code="system.label.purchase.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.electronicbillnum" default="전자세금계산서번호"/>',
				name: 'BILL_NUM',
				xtype: 'uniTextfield'
			},{
				fieldLabel: '<t:message code="system.label.purchase.paymentplandate" default="지급예정일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ISSUE_EXPDT_FR',
				endFieldName: 'ISSUE_EXPDT_TO',
				width: 315
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'IN_FR_DATE',
				endFieldName: 'IN_TO_DATE',
				width: 315
			},{
				fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'ITEM_LEVEL2'
			},{
				fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'ITEM_LEVEL3'
			},{
				fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
				levelType:'ITEM'
			}]
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
						var labelText = invalid.items[0]['fieldLabel']+':';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
					}

					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
				//	this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.purchasedivision" default="매입사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			child:'IN_WH_CODE',
			value: UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
					var field2 = panelSearch.getField('IN_WH_CODE');
					field2.getStore().clearFilter(true);
					panelResult.setValue('IN_WH_CODE', '');
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.billdate" default="계산서일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'BILL_DATE_FR',
			endFieldName: 'BILL_DATE_TO',
			startDate: UniDate.get('today'),
			endDate: UniDate.get('today'),
			allowBlank: false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('BILL_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('BILL_DATE_TO',newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
			name: 'IN_WH_CODE',
			xtype: 'uniCombobox',
			comboType  : 'O',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('IN_WH_CODE', newValue);
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
		},{	//20210304 추가: 조회조건 "전표승인여부" 추가
			fieldLabel	: '전표승인여부',
			xtype		: 'radiogroup',
			itemId		: 'rdo2',
			colspan		: 2,
			items		: [{
				boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
				name		: 'rdoSelect2',
				inputValue	: 'A',
				width		: 60,
				checked		: true
			},{
				boxLabel	: '승인',
				name		: 'rdoSelect2',
				inputValue	: 'Y',
				width		: 60
			},{
				boxLabel	: '미승인',
				name		: 'rdoSelect2',
				inputValue	: 'N',
				width		: 60
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('rdoSelect2').setValue(newValue.rdoSelect2);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name: 'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M001',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_TYPE', newValue);
				}
			}
		},
		Unilite.popup('CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName: 'CUST_CODE',
			textFieldName: 'CUST_NAME',
			popupWidth: 710,
			extParam: {'CUSTOM_TYPE': ['1','2']},
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUST_CODE', panelResult.getValue('CUST_CODE'));
						panelSearch.setValue('CUST_NAME', panelResult.getValue('CUST_NAME'));
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CUST_CODE', '');
					panelSearch.setValue('CUST_NAME', '');
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.purchase.clienttype" default="고객분류"/>',
			name: 'AGENT_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B055',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AGENT_TYPE', newValue);
				}
			}
		},{	//20200218 추가: 조회조건 "기표여부" 추가
			fieldLabel	: '<t:message code="system.label.sales.slipyn" default="기표여부"/>',
			xtype		: 'radiogroup',
			itemId		: 'rdo',
			colspan		: 2,
			items		: [{
				boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
				name		: 'rdoSelect',
				inputValue	: 'A',
				width		: 60,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.purchase.slipposting" default="기표"/>',
				name		: 'rdoSelect',
				inputValue	: 'Y',
				width		: 60
			},{
				boxLabel	: '<t:message code="system.label.purchase.notslipposting" default="미기표"/>',
				name		: 'rdoSelect',
				inputValue	: 'N',
				width		: 60
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
				}
			}
		},{	//20210524 추가
			fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_PRSN',
			colspan		: 3,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CUSTOM_PRSN', newValue);
				}
			}
		},{	//20210524 추가
			fieldLabel	: '지급여부',
			xtype		: 'radiogroup',
			itemId		: 'PROV_YN',
			items		: [{
				boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
				name		: 'PROV_YN',
				inputValue	: 'A',
				width		: 60
			},{
				boxLabel	: '지급', 
				name		: 'PROV_YN',
				inputValue	: 'Y',
				width		: 60
			},{
				boxLabel	: '미지급',
				name		: 'PROV_YN',
				inputValue	: 'N',
				width		: 60
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('PROV_YN').setValue(newValue.PROV_YN);
				}
			}
		},{	//20210524 수정: container 추가
			xtype		: 'container',
			layout		: {type: 'uniTable', columns: 1},
			padding		: '0 0 6 20',
			items		: [{
				xtype	: 'button',
				text	: '계좌이체리스트',
				itemId	: 'btnList',
				width	: 100,
				handler	: function() {
					openAccTransWindow();
				}
			}]
		}]
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_map110skrv_wmGrid1', {
		store		: directMasterStore1,
		layout		: 'fit',
		region		: 'center',
		excelTitle	: '<t:message code="system.label.purchase.creditpurchasestatusinquiry" default="외상매입현황 조회"/>',
		uniOpt		: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: true
		}],
		columns: [
			{dataIndex: 'INOUT_CODE'			, width: 53	, hidden: true},
			{dataIndex: 'CUSTOM_NAME'			, width: 126,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.customtotal" default="거래처계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
				}
			},
			{dataIndex: 'ORDER_TYPE'			, width: 100, align: 'center'},
			{dataIndex: 'COMPANY_NUM'			, width: 120, align: 'center'},
			{dataIndex: 'BILL_NUM'				, width: 120},
			{dataIndex: 'DIV_CODE'				, width: 100},
			{dataIndex: 'BILL_DATE'				, width: 86},
			{dataIndex: 'CHANGE_BASIS_DATE'		, width: 86	, hidden: true},
			{dataIndex: 'ISSUE_EXPECTED_DATE'	, width: 86},
			{dataIndex: 'INOUT_DATE'			, width: 86},
			{dataIndex: 'ITEM_CODE'				, width: 120},
			{dataIndex: 'ITEM_NAME'				, width: 130},
			{dataIndex: 'SPEC'					, width: 133},
			{dataIndex: 'INOUT_Q'				, width: 66},
			{dataIndex: 'BUY_Q'					, width: 66	, summaryType: 'sum'},
			{dataIndex: 'STOCK_UNIT'			, width: 66	, align: 'center'},
			{dataIndex: 'MONEY_UNIT'			, width: 66	, align: 'center'},
			{dataIndex: 'AMOUNT_P'				, width: 100},
			{dataIndex: 'AMOUNT_I'				, width: 100, summaryType: 'sum'},
			{dataIndex: 'TAX_I'					, width: 80	, summaryType: 'sum'},
			{dataIndex: 'TOTAL_I'				, width: 120, summaryType: 'sum'},
			{dataIndex: 'CUSTOM_PRSN'			, width: 100},
			{dataIndex: 'PHONE'					, width: 110},
			{dataIndex: 'BANK_NAME'				, width: 100},
			{dataIndex: 'BANK_ACCOUNT'			, width: 120},
			{dataIndex: 'BIRTHDAY'				, width: 100},
			{dataIndex: 'ZIP_CODE'				, width: 100, align: 'center'},
			{dataIndex: 'ADDR1'					, width: 250},
			{dataIndex: 'FOR_AMOUNT_O'			, width: 120},
			{dataIndex: 'EXCHG_RATE_O'			, width: 66},
			{dataIndex: 'INOUT_NUM'				, width: 120},
			{dataIndex: 'INOUT_METH'			, width: 66	, align: 'center'},
			{dataIndex: 'WH_CODE'				, width: 100, align: 'center'},
			{dataIndex: 'EX_DATE'				, width: 86},
			{dataIndex: 'EX_NUM'				, width: 86},
			{dataIndex: 'AC_DATE'				, width: 86},
			{dataIndex: 'AC_NUM'				, width: 86},
			{dataIndex: 'AGREE_YN'				, width: 113},
			{dataIndex: 'ORG_AMT_I'				, width: 120},	//20210524 추가
			{dataIndex: 'J_AMT_I'				, width: 120},	//20210524 추가
			{dataIndex: 'BLN_I'					, width: 120},	//20210524 추가
			{dataIndex: 'REMARK'				, width: 133},
			{dataIndex: 'PROJECT_NO'			, width: 133}
		]
	});



	/** 계좌이체리스트 팝업 - 20210304 추가
	 * 
	 */
	Unilite.defineModel('AccTransModel', {
		fields: [
			{name: 'INOUT_CODE'		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'	, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'		, type: 'string'},
			{name: 'CUSTOM_PRSN'	, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'	, type: 'string'},
			{name: 'PHONE'			, text: '연락처'		, type: 'string'},
			{name: 'BANK_NAME'		, text: '은행명'		, type: 'string'},
			{name: 'BANK_ACCOUNT'	, text: '계좌번호'		, type: 'string'},
			{name: 'BIRTHDAY'		, text: '생년월일'		, type: 'string'},		//20210430 수정: uniDate -> string
			{name: 'ZIP_CODE'		, text: '우편번호'		, type: 'string'},
			{name: 'ADDR1'			, text: '주소'		, type: 'string'},
			{name: 'TOTAL_I'		, text: '<t:message code="system.label.purchase.totalamount" default="합계"/>'	, type: 'uniPrice'}
		]
	});

	var AccTransStore = Unilite.createStore('AccTransStore', {
		model	: 'AccTransModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_map110skrv_wmService.selectList2'
			}
		},
		loadStoreRecords : function() {
			var param = panelSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var AccTransGrid = Unilite.createGrid('s_map100ukrv_wmAccTransGrid', {	//조회버튼 누르면 나오는 조회창
		layout		: 'fit',
		excelTitle	: '계좌이체리스트',
		store		: AccTransStore,
		uniOpt		: {
			expandLastColumn: false,
			useRowNumberer	: true
		},
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: true
		}],
		columns:  [
			{dataIndex: 'INOUT_CODE'			, width: 53	, hidden: true},
			{dataIndex: 'CUSTOM_NAME'			, width: 126,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'CUSTOM_PRSN'			, width: 100},
			{dataIndex: 'PHONE'					, width: 110},
			{dataIndex: 'BANK_NAME'				, width: 100},
			{dataIndex: 'BANK_ACCOUNT'			, width: 120},
			{dataIndex: 'BIRTHDAY'				, width: 100, align: 'center'},
			{dataIndex: 'ZIP_CODE'				, width: 100, align: 'center'},
			{dataIndex: 'ADDR1'					, width: 250},
			{dataIndex: 'TOTAL_I'				, width: 120, summaryType: 'sum'}
		]
	});

	function openAccTransWindow() {
		if(!AccTransWindow) {
			AccTransWindow = Ext.create('widget.uniDetailWindow', {
				title	: '게좌이체리스트',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [AccTransGrid],
				tbar	: ['->', {
					itemId	: 'saveBtn',
					text	: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler	: function() {
						AccTransStore.loadStoreRecords();
					},
					disabled: false
				}, {
					itemId	: 'OrderNoCloseBtn',
					text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler	: function() {
						AccTransWindow.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						AccTransGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						AccTransGrid.reset();
					},
					show: function( panel, eOpts ) {
						AccTransStore.loadStoreRecords();
					}
				}
			})
		}
		AccTransWindow.center();
		AccTransWindow.show();
	}




	Unilite.Main({
		id			: 's_map110skrv_wmApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function(params) {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('BILL_DATE_FR'	, UniDate.get('today'));
			panelSearch.setValue('BILL_DATE_TO'	, UniDate.get('today'));
			panelResult.setValue('BILL_DATE_FR'	, UniDate.get('today'));
			panelResult.setValue('BILL_DATE_TO'	, UniDate.get('today'));
			//20200218 추가: 조회조건 "기표여부" 추가
			panelSearch.setValue('rdoSelect'	, 'A');
			panelResult.setValue('rdoSelect'	, 'A');
			//20210304 추가: 조회조건 "전표승인여부" 추가
			panelSearch.setValue('rdoSelect2'	, 'A');
			panelResult.setValue('rdoSelect2'	, 'A');
			panelSearch.getField('PROV_YN').setValue('A');	//20210524 추가
			panelResult.getField('PROV_YN').setValue('A');	//20210524 추가

			UniAppManager.setToolbarButtons('save'	, false);
			UniAppManager.setToolbarButtons('reset'	, true);

			//20210521 추가: 링크 받는 로직 추가
			if(!Ext.isEmpty(params && params.PGM_ID)){
				if(params.PGM_ID == 's_ssa700skrv_wm') {
					panelSearch.setValue('DIV_CODE'		, params.DIV_CODE);
					panelResult.setValue('DIV_CODE'		, params.DIV_CODE);
					panelSearch.setValue('BILL_DATE_FR'	, params.BASIS_DATE);
					panelSearch.setValue('BILL_DATE_TO'	, params.BASIS_DATE);
					panelResult.setValue('BILL_DATE_FR'	, params.BASIS_DATE);
					panelResult.setValue('BILL_DATE_TO'	, params.BASIS_DATE);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},
		onQueryButtonDown: function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
				var viewNormal = masterGrid.getView();
				console.log("viewNormal: ",viewNormal);
				viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				UniAppManager.setToolbarButtons('excel', true);
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		},
		onPrintButtonDown: function(){
			var selectedDetails = masterGrid.getSelectedRecords();
			if(Ext.isEmpty(selectedDetails)){
				Unilite.messageBox('출력할 데이터를 선택하여 주십시오.');
				return;
			}
			var param		= panelResult.getValues();
			param.PGM_ID	= PGM_ID;
			param.MAIN_CODE	= 'Z012';

			var win = Ext.create('widget.ClipReport', {
				url			: CPATH+'/z_wm/s_map110clskrv_wm.do',
				prgID		: PGM_ID,
				extParam	: param,
				submitType	: 'POST'
			});
			win.center();
			win.show();
		}
	});
};
</script>