<%--
'	프로그램명 : 발주현황조회_외주통합 (구매)
'	작성자 : 시너지시스템즈 개발팀
'	작성일 :
'	최종수정자 :
'	최종수정일 :
'	버전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo131skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo131skrv" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />			<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" />			<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" />			<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="M002" />			<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" />			<!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />			<!-- 계정구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" />
	<t:ExtComboStore comboType="AU" comboCode="I008" />			<!-- 입고유무 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />			<!-- 화폐단위 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var gubunStore = Unilite.createStore('gubunComboStore', {
		fields	: ['text', 'value'],
		data	:	[
			{'text':'구매'	, 'value':'1'},
			{'text':'외주'	, 'value':'2'}
		]
	});



	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Mpo131skrvModel', {
		fields: [
			{name: 'ORDER_TYPE'		, text: '<t:message code="system.label.purchase.classfication" default="구분"/>'		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.item" default="품목"/>'				, type:'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'			, type:'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type:'string'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type:'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type:'string'},
			{name: 'PROJECT_NO'		, text: '<t:message code="system.label.sales.project" default="프로젝트"/>'				, type:'string'},
			{name: 'PJT_NAME'		, text: '<t:message code="system.label.purchase.projectname" default="프로젝트명"/>'		, type:'string'},
			{name: 'REMARK1'		, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'+'1'		, type:'string'},
			{name: 'REMARK2'		, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'+'2'		, type:'string'},
			{name: 'ORDER_DATE'		, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'			, type:'uniDate'},
			{name: 'DVRY_DATE'		, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'		, type:'uniDate'},
			{name: 'ORDER_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				, type:'uniQty'},
			{name: 'ORDER_P'		, text: '<t:message code="system.label.purchase.pounitprice" default="발주단가"/>'		, type:'uniUnitPrice'},
			{name: 'ORDER_O'		, text: '<t:message code="system.label.product.poamount" default="발주액"/>'			, type:'uniPrice'},
			{name: 'TEMP_INOUT_Q'	, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'		, type:'uniQty'},
			{name: 'TEMP_INOUT_DATE', text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'		, type:'uniDate'},
			{name: 'INSTOCK_Q'		, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'		, type:'uniQty'},
			{name: 'INSTOCK_O'		, text: '<t:message code="system.label.purchase.receiptamount" default="입고금액"/>'	, type:'uniPrice'},
			{name: 'END_ORDER_Q'	, text: '마감량'		, type:'uniQty'},
			{name: 'END_ORDER_O'	, text: '마감금액'		, type:'uniPrice'},
			{name: 'AGREE_STATUS'	, text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'		, type:'string',comboType:'AU' ,comboCode:'M007'},
			{name: 'CONTROL_STATUS'	, text: '<t:message code="system.label.purchase.status" default="상태"/>'				, type:'string',comboType:'AU' ,comboCode:'M002'},
			{name: 'ORDER_NUM'		, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type:'string'},
			{name: 'IN_DIV_CODE'	, text: '<t:message code="system.label.purchase.receiptdivision" default="입고사업장"/>'	, type: 'string', allowBlank: false , comboType: 'BOR120'},
			//20191029 추가: 수주번호, 수주처, 수주품목명
			{name: 'SO_NUM'			, text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'SO_CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.soplace" default="수주처"/>'			, type: 'string'},
			{name: 'SO_ITEM_NAME'	, text: '<t:message code="system.label.purchase.soitemname" default="수주품목명"/>'		, type: 'string'},
			//20200120 추가: IF_YN, DVRY_ESTI_DATE
			{name: 'IF_YN'	 		, text: '<t:message code="system.label.purchase.ifyn" default="접수확인"/>' 			, type: 'string'},
			{name: 'DVRY_ESTI_DATE'	, text: '<t:message code="system.label.purchase.dvryestidate" default="납품예정일"/>'	, type: 'uniDate'},
			//20200528 추가: D_DAY
			{name: 'D_DAY'			, text: 'D-Day'		, type: 'string'},
			//20200922 추가:발주형태,구매단위,화폐,자사발주단가,자사발주금액,미입고량,최종입고일
			{name: 'ORDER_TYPE'		, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		, type: 'string'},
			{name: 'MONEY_UNIT'		, text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'		, type: 'string' ,comboType:'AU' ,comboCode:'B004'},
			{name: 'ORDER_LOC_P'	, text: '<t:message code="system.label.purchase.comppounitprice" default="자사발주단가"/>'	, type: 'uniUnitPrice'},
			{name: 'ORDER_LOC_O'	, text: '<t:message code="system.label.purchase.comppoprice" default="자사발주금액"/>'		, type: 'uniPrice'},
			{name: 'UNDVRY_Q'		, text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'		, type: 'uniQty'},
			{name: 'MAX_INOUT_DATE'	, text: '<t:message code="system.label.purchase.lastreceiptdate" default="최종입고일"/>'	, type: 'uniDate'},
			{name: 'CONFM_YN'		, text: '접수확인'		, type: 'string'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mpo131skrvMasterStore1', {
		model	: 'Mpo131skrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {
				read: 'mpo131skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'ORDER_TYPE'
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items		: [{
			title	: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId	: 'search_panel1',
			layout	: {type: 'uniTable', columns: 1},
			items	: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				//multiSelect : true,
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						//var field = panelResult.getField('ORDER_PRSN');
						//field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
						//var field2 = panelResult.getField('WH_CODE');
						//field2.getStore().clearFilter(true);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE_FR',
				textFieldName	: 'CUSTOM_NAME_FR',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_CODE_FR', newValue);
								panelResult.setValue('CUSTOM_CODE_FR', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_NAME_FR', '');
									panelResult.setValue('CUSTOM_NAME_FR', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_NAME_FR', newValue);
								panelResult.setValue('CUSTOM_NAME_FR', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_CODE_FR', '');
									panelResult.setValue('CUSTOM_CODE_FR', '');
								}
							},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':	['1','2']});
						popup.setExtParam({'CUSTOM_TYPE':	['1','2']});
					}
				}
			}),
	/* 		Unilite.popup('AGENT_CUST', {
				fieldLabel: '~',
				valueFieldName: 'CUSTOM_CODE_TO',
				textFieldName: 'CUSTOM_NAME_TO',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE_TO', panelSearch.getValue('CUSTOM_CODE_TO'));
							panelResult.setValue('CUSTOM_NAME_TO', panelSearch.getValue('CUSTOM_NAME_TO'));
						},
						scope: this
					},
					onClear: function(type) {

						panelResult.setValue('CUSTOM_CODE_TO', '');
						panelResult.setValue('CUSTOM_NAME_TO', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':	['1','2']});
						popup.setExtParam({'CUSTOM_TYPE':	['1','2']});
					}
				}
			}), */
			{
				fieldLabel	: '<t:message code="system.label.purchase.classfication" default="구분"/>',
				name		: 'GUBUN',
				xtype		: 'uniCombobox',
				store		: gubunStore,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('GUBUN', newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.purchase.podate" default="발주일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'ORDER_DATE_FR',
				endFieldName	: 'ORDER_DATE_TO',
				allowBlank		: false,
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel	: '입고유무',
				name		: 'INOUT_FLAG',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'I008',
				value		: '3',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_FLAG', newValue);
					}
				}
			},
			Unilite.popup('PROJECT',{
				fieldLabel		: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				valueFieldName	:'PROJECT_NO',
				textFieldName	:  'PROJECT_NAME',
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName	: 'PJT_NAME',
				validateBlank	: false,
//				allowBlank		: false,
				textFieldOnly	: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PROJECT_NO', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('PROJECT_NAME', newValue);
					}
				}
			}),
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_CODE', newValue);
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_NAME', newValue);
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}
						},
					applyextparam: function(popup){	// 2021.08 표준화 작업
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				name		: 'ITEM_ACCOUNT',
				fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.sono" default="수주번호"/>',
				name		: 'SO_NUM',
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SO_NUM', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 5},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			//multiSelect : true,
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					//var field = panelSearch.getField('ORDER_PRSN');
					//field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
					//var field2 = panelSearch.getField('WH_CODE');
					//field2.getStore().clearFilter(true);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE_FR',
			textFieldName	: 'CUSTOM_NAME_FR',
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('CUSTOM_CODE_FR', newValue);
							panelResult.setValue('CUSTOM_CODE_FR', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME_FR', '');
								panelResult.setValue('CUSTOM_NAME_FR', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('CUSTOM_NAME_FR', newValue);
							panelResult.setValue('CUSTOM_NAME_FR', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE_FR', '');
								panelResult.setValue('CUSTOM_CODE_FR', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER':	['1','2']});
							popup.setExtParam({'CUSTOM_TYPE':	['1','2']});
				}
			}
		}) ,
/*		Unilite.popup('AGENT_CUST', {
			fieldLabel: '~',
			labelWidth: 8,
			valueFieldName: 'CUSTOM_CODE_TO',
			textFieldName: 'CUSTOM_NAME_TO',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE_TO', panelResult.getValue('CUSTOM_CODE_TO'));
						panelSearch.setValue('CUSTOM_NAME_TO', panelResult.getValue('CUSTOM_NAME_TO'));
					},
					scope: this
				},
				onClear: function(type) {

					panelSearch.setValue('CUSTOM_CODE_TO', '');
					panelSearch.setValue('CUSTOM_NAME_TO', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':	['1','2']});
					popup.setExtParam({'CUSTOM_TYPE':	['1','2']});
				}
			}
		}), */
		{
			fieldLabel		: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ORDER_DATE_FR',
			endFieldName	: 'ORDER_DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_TO',newValue);
				}
			}
		},{
			fieldLabel	: '입고유무',
			name		: 'INOUT_FLAG',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'I008',
			value		: '3',
			colspan		: 2,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('INOUT_FLAG', newValue);
				}
			}
		},
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
			valueFieldName	: 'PROJECT_NO',
			textFieldName	: 'PROJECT_NAME',
			DBvalueFieldName: 'PJT_CODE',
			DBtextFieldName	: 'PJT_NAME',
			validateBlank	: false,
//			allowBlank		: false,
			textFieldOnly	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PROJECT_NO', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('PROJECT_NAME', newValue);
				}
			}
		}),
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_CODE', newValue);
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_NAME', newValue);
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}
						},
					applyextparam: function(popup){	// 2021.08 표준화 작업
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.classfication" default="구분"/>',
			name		: 'GUBUN',
			xtype		: 'uniCombobox',
			store		: gubunStore,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('GUBUN', newValue);
				}
			}
		},{
			name		: 'ITEM_ACCOUNT',
			fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.sono" default="수주번호"/>',
			name		: 'SO_NUM',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SO_NUM', newValue);
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('mpo131skrvGrid1', {
		store		: directMasterStore1,
		layout		: 'fit',
		region		: 'center',
		excelTitle	: '<t:message code="system.label.purchase.postatusinquiry" default="발주현황조회"/>',
		uniOpt		: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: true
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: true,
			dock			: 'bottom'
		}],
		selModel: 'rowmodel',
		columns: [
			//{dataIndex:'ORDER_TYPE'			,width: 40},
			{dataIndex:'IN_DIV_CODE'		,width: 100},
			{dataIndex:'CUSTOM_CODE'		,width: 90},
			{dataIndex:'CUSTOM_NAME'		,width: 120},
			{dataIndex:'ORDER_NUM'			,width: 120},
			{dataIndex:'ORDER_DATE'         ,width: 90},
			{dataIndex:'ORDER_TYPE'			,width: 80},
			{dataIndex:'ITEM_CODE'			,width: 90,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
			}},
			{dataIndex:'ITEM_NAME'			,width: 160},
			{dataIndex:'SPEC'				,width: 110},
			{dataIndex:'ORDER_UNIT'			,width: 100},
			{dataIndex:'DVRY_DATE'			,width: 90},
			//20200528 추가: D_DAY
			{dataIndex:'D_DAY'				,width: 60 , align:'center',
				renderer:function(value, metaData, record) {
					var r = value;
					if(r == 'D-1') {
						r = '<span style="color:' + 'red' + ';">' + r +'</span>';					//빨갛게
//						r = '<span style="color:' + 'red' + ';">' + '<b>' + r + '<b>' +'</span>';	//빨갛고 진하게
					}
					return r;
				}
			},
			{dataIndex:'ORDER_Q'			,width: 90 , summaryType: 'sum'},
			{dataIndex:'MONEY_UNIT'			,width: 90},
			{dataIndex:'ORDER_P'			,width: 90},
			{dataIndex:'ORDER_O'			,width: 90 , summaryType: 'sum'},
			{dataIndex:'ORDER_LOC_P'		,width: 110},
			{dataIndex:'ORDER_LOC_O'		,width: 110 , summaryType: 'sum'},
			{dataIndex:'INSTOCK_Q'			,width: 90 , summaryType: 'sum'},
			{dataIndex:'INSTOCK_O'			,width: 90 , summaryType: 'sum'},
			{dataIndex:'MAX_INOUT_DATE'		,width: 90 },
			{dataIndex:'UNDVRY_Q'			,width: 90 , summaryType: 'sum'},
			{dataIndex:'PROJECT_NO'			,width: 90},
			{dataIndex:'PJT_NAME'			,width: 90},
			{dataIndex:'REMARK1'			,width: 170},
			{dataIndex:'REMARK2'			,width: 170},
			{dataIndex:'TEMP_INOUT_Q'		,width: 90 , summaryType: 'sum'},
			{dataIndex:'TEMP_INOUT_DATE'	,width: 90},
			{dataIndex:'END_ORDER_Q'		,width: 90 , summaryType: 'sum'},
			{dataIndex:'END_ORDER_O'		,width: 90 , summaryType: 'sum'},
			{dataIndex:'AGREE_STATUS'		,width: 90 , align:'center'},
			{dataIndex:'CONTROL_STATUS'		,width: 90 , align:'center'},
			//20191029 추가: 수주번호, 수주처, 수주품목명
			{ dataIndex:'SO_NUM'			,width:100, hidden: false},
			{ dataIndex:'SO_CUSTOM_NAME'	,width:150, hidden: false},
			{ dataIndex:'SO_ITEM_NAME'		,width:200, hidden: false},
			//20200120 추가: IF_YN, DVRY_ESTI_DATE
			{ dataIndex:'IF_YN'				,width:80 , align:'center',hidden: true},
			{ dataIndex:'DVRY_ESTI_DATE'	,width:90 , hidden: true}
		],
		listeners:{
			afterrender: function(grid) {
				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				this.contextMenu.add({
					text: '발주등록 바로가기',
					//iconCls : '',
					handler: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						var params = {
							sender: me,
							'PGM_ID'	: 'mpo131skrv',
							COMP_CODE	: UserInfo.compCode,
							DIV_CODE	: panelResult.getValue('DIV_CODE'),
							ORDER_NUM	: record.data.ORDER_NUM,
							CUSTOM_CODE	: record.data.CUSTOM_CODE,
							CUSTOM_NAME	: record.data.CUSTOM_NAME,
							ORDER_DATE	: record.data.ORDER_DATE,
							MONEY_UNIT	: record.data.MONEY_UNIT,
							PROJECT_NO	: record.data.PROJECT_NO
						};
						var rec = {data : {prgID : 'mpo502ukrv', 'text':''}};
						parent.openTab(rec, '/matrl/mpo502ukrv.do', params);
					}
				});
			}
		},
		viewConfig:{
			getRowClass : function(record,rowIndex,rowParams,store){
				var cls = '';
				if(record.get('CONTROL_STATUS')=="1"){	//발주중
					cls = 'x-change-cell_row1';
				}else if(record.get('CONTROL_STATUS')=="3"){	//계산서처리
					cls = 'x-change-cell_row2';
				}else if(record.get('CONTROL_STATUS')=="9"){	//마감
					cls = 'x-change-cell_row3';
				}
				return cls;
			}
		}
	});



	Unilite.Main({
		id			: 'mpo131skrvApp',
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
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));
			UniAppManager.setToolbarButtons('reset', true);
		},
		onQueryButtonDown: function() {
			// 20210305 : 조회전 필수값 입력 여부 체크
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			directMasterStore1.loadData({});
			this.fnInitBinding();
		}
	});
};
</script>