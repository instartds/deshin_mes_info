<%--
'	프로그램명 : 발주현황조회 (구매)
'
'	작  성  자 : (주)포렌 개발실
'	작  성  일 :
'
'	최종수정자 :
'	최종수정일 :
'
'	버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo130skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo130skrv" /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" /> <!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 계정구분 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" /> <!-- 단가형태 -->
	<t:ExtComboStore comboType="AU" comboCode="Z010" /> <!-- 사용처 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="MPO130skrvLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="MPO130skrvLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="MPO130skrvLevel3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsOrderPrsn		: '${gsOrderPrsn}'
};
//LINK 프로그램 정보
var gslinkPgmInfo = Ext.isEmpty(${gslinkPgmInfo}) ? '' : ${gslinkPgmInfo};

function appMain() {
	/**	Model 정의
	 * @type
	 */
	Unilite.defineModel('Mpo130skrvModel', {
		fields: [
			{name: 'ITEM_LEVEL1'		, text: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>'		, type: 'string' ,store: Ext.data.StoreManager.lookup('MPO130skrvLevel1Store'), child:'ITEM_LEVEL2'},
			{name: 'ITEM_LEVEL2'		, text: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>'		, type: 'string' ,store: Ext.data.StoreManager.lookup('MPO130skrvLevel2Store')},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'			, type: 'string' ,comboType:'AU' ,comboCode:'M001'},
			{name: 'ORDER_DATE'			, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'			, type: 'uniDate'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.unit" default="단위"/>'				, type: 'string'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'		, type: 'uniDate'},
			{name: 'DVRY_TIME'			, text: '<t:message code="system.label.purchase.deliverytime" default="납기시간"/>'		, type: 'uniDate'},
			{name: 'ORDER_UNIT_Q'		, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				, type: 'uniQty'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'		, type: 'string'},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'				, type: 'uniUnitPrice'},
			{name: 'ORDER_O'			, text: '<t:message code="system.label.purchase.amount" default="금액"/>'				, type: 'uniFC'},
			{name: 'EXCHG_RATE_O'		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'		, type: 'uniER'},
			{name: 'ORDER_LOC_P'		, text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'			, type: 'uniUnitPrice'},
			{name: 'ORDER_LOC_O'		, text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'			, type: 'uniPrice'},
			{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'		, type: 'uniQty'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'		, type: 'uniQty'},
			{name: 'UN_Q'				, text: '<t:message code="system.label.purchase.undeliveryqty" default="미납량"/>'		, type: 'uniQty'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'	, type: 'string' ,comboType:'AU' ,comboCode:'M201'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'	, type: 'string' ,store: Ext.data.StoreManager.lookup('whList')},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
			{name: 'CONTROL_STATUS'		, text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'	, type: 'string' ,comboType:'AU' ,comboCode:'M002'},
			{name: 'ORDER_REQ_NUM'		, text: '<t:message code="system.label.purchase.poreserveinfo" default="발주예정정보"/>'	, type: 'string'},
			{name: 'UNIT_PRICE_TYPE'	, text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'		, type: 'string' ,comboType:'AU' ,comboCode:'M301'},
			{name: 'AGREE_STATUS'		, text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'		, type: 'string' ,comboType:'AU' ,comboCode:'M007'},
			{name: 'AGREE_DATE'			, text: '<t:message code="system.label.purchase.approvaldate" default="승인일"/>'		, type: 'uniDate'},
			{name: 'AGREE_PRSN'			, text: '<t:message code="system.label.purchase.approvaluser" default="승인자"/>'		, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: '<t:message code="system.label.purchase.inputdate" default="입력일"/>'			, type: 'uniDate'},
			{name: 'PO_REQ_NUM'			, text: '<t:message code="system.label.purchase.purchaseplanno" default="구매계획번호"/>'	, type: 'string'},
			{name: 'USAGE_PLACE'        , text: '<t:message code="system.label.purchase.usageplace" default="사용처"/>'        , type: 'string',comboType:'AU',comboCode:'Z010'}
			
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mpo130skrvMasterStore1', {
		model: 'Mpo130skrvModel',
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'mpo130skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();
			/*var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('searchForm').getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}*/
			console.log( param );
			this.load({
				params: param
			});
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
				itemId: 'search_panel1',
				layout: {type: 'uniTable', columns: 1},
				defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				child:'WH_CODE',
				allowBlank: false,
				value:UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('ORDER_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE1',
				textFieldName: 'CUSTOM_NAME1',

				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE1', panelSearch.getValue('CUSTOM_CODE1'));
							panelResult.setValue('CUSTOM_NAME1', panelSearch.getValue('CUSTOM_NAME1'));
						},
						scope: this
					},
					onClear: function(type) {

						panelResult.setValue('CUSTOM_CODE1', '');
						panelResult.setValue('CUSTOM_NAME1', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
					}
				}
			}),
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '~',
				valueFieldName: 'CUSTOM_CODE2',
				textFieldName: 'CUSTOM_NAME2',

				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE2', panelSearch.getValue('CUSTOM_CODE2'));
							panelResult.setValue('CUSTOM_NAME2', panelSearch.getValue('CUSTOM_NAME2'));
						},
						scope: this
					},
					onClear: function(type) {

						panelResult.setValue('CUSTOM_CODE2', '');
						panelResult.setValue('CUSTOM_NAME2', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
						popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
					}
				}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
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
				fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
				name: 'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M201',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode4', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode4', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				}
			},
			Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				valueFieldName:'PROJECT_NO',
				textFieldName:'PROJECT_NAME',
					DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName: 'PJT_NAME',
				validateBlank: false,
//				allowBlank:false,
				textFieldOnly: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PROJECT_NO', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('PROJECT_NAME', newValue);
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
			},{
				fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('MPO130skrvLevel1Store'),
				child: 'ITEM_LEVEL2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('MPO130skrvLevel2Store'),
				child: 'ITEM_LEVEL3'
			},{
				fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('MPO130skrvLevel3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
				levelType:'ITEM'
			}]
		},{
			title:'<t:message code="system.label.purchase.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items:[
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					valueFieldName: 'DIV_PUMOK_CODE1',
					textFieldName: 'DIV_PUMOK_NAME1',
					validateBlank: false,
					popupWidth: 710,
					listeners: {
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '~',
					valueFieldName: 'DIV_PUMOK_CODE2',
					textFieldName: 'DIV_PUMOK_NAME2',
					validateBlank: false,
					popupWidth: 710,
					listeners: {
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),
			{
				fieldLabel: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'DVRY_DATE_FR',
				endFieldName: 'DVRY_DATE_TO',
				width:315
			},/*(
				Unilite.popup('',{
					fieldLabel: '<t:message code="system.label.purchase.manageno" default="관리번호"/>',
					name:'PROJECT_NO',
					textFieldWidth: 70
				})
			),*/{
				fieldLabel: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>',
				name: 'AGREE_STATUS',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M007'
			},{
				fieldLabel: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>',
				name: 'CONTROL_STATUS',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M002'
			},{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M001'
			},{
				fieldLabel: '<t:message code="system.label.purchase.inputdate" default="입력일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INPUT_DATE_FR',
				endFieldName: 'INPUT_DATE_TO',
				width:315
			},{
				fieldLabel: '<t:message code="system.label.purchase.accountclass" default="계정구분"/>',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020'
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.purchase.closingyn" default="마감여부"/>',
				id: 'rdoSelect',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width:60,
					name: 'CLOSE_FG',
					inputValue: 'A',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.purchase.closing" default="마감"/>',
					width:60,
					name: 'CLOSE_FG',
					inputValue: 'Y'
				},{
					boxLabel: '<t:message code="system.label.purchase.noclosing" default="미마감"/>',
					width:60,
					name: 'CLOSE_FG',
					inputValue: 'N'
				}]
			},{
				fieldLabel:'<t:message code="system.label.purchase.purchaseplanno" default="구매계획번호"/>',
				name: 'PO_REQ_NUM',
				id: 'PO_REQ_NUM',
				xtype: 'uniTextfield'
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			child:'WH_CODE',
			allowBlank: false,
			value:UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelSearch.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName: 'CUSTOM_CODE1',
			textFieldName: 'CUSTOM_NAME1',

			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE1', panelResult.getValue('CUSTOM_CODE1'));
						panelSearch.setValue('CUSTOM_NAME1', panelResult.getValue('CUSTOM_NAME1'));
					},
					scope: this
				},
				onClear: function(type) {

					panelSearch.setValue('CUSTOM_CODE1', '');
					panelSearch.setValue('CUSTOM_NAME1', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				}
			}
		}),
		Unilite.popup('AGENT_CUST', {
			fieldLabel: '~',
			labelWidth: 8,
			valueFieldName: 'CUSTOM_CODE2',
			textFieldName: 'CUSTOM_NAME2',
			colspan: 2,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE2', panelResult.getValue('CUSTOM_CODE2'));
						panelSearch.setValue('CUSTOM_NAME2', panelResult.getValue('CUSTOM_NAME2'));
					},
					scope: this
				},
				onClear: function(type) {

					panelSearch.setValue('CUSTOM_CODE2', '');
					panelSearch.setValue('CUSTOM_NAME2', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank: false,
			width: 315,
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
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name: 'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M201',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode4', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode4', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_PRSN', newValue);
				}
			}
			}, Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				valueFieldName:'PROJECT_NO',
				textFieldName:'PROJECT_NAME',
					DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName: 'PJT_NAME',
				validateBlank: false,
//				allowBlank:false,
				textFieldOnly: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('PROJECT_NO', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('PROJECT_NAME', newValue);
					}
				}
			})
			]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('mpo130skrvGrid1', {
		layout: 'fit',
		region: 'center',
		excelTitle: '<t:message code="system.label.purchase.postatusinquiry" default="발주현황조회"/>',
		tbar:[{xtype:'uniNumberfield',
				labelWidth: 110,
				fieldLabel:'<t:message code="system.label.purchase.selectionsummary" default="선택된 데이터 합계"/>',
				itemId:'selectionSummary',
				readOnly: true,
				value:0,
				decimalPrecision:4,
				format:'0,000.0000'}],
		uniOpt: {
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false,
			dock: 'bottom'
		}],
		store: directMasterStore1,
		viewConfig:{
			getRowClass : function(record,rowIndex,rowParams,store){
				var cls = '';
				if(record.get('CONTROL_STATUS')=="1"){			//발주중
					cls = 'x-change-cell_row1';
				}else if(record.get('CONTROL_STATUS')=="3"){	//계산서처리
					cls = 'x-change-cell_row2';
				}else if(record.get('CONTROL_STATUS')=="9"){	//마감
					cls = 'x-change-cell_row3';
				}
				return cls;
			}
		},
		columns: [
			{dataIndex: 'CUSTOM_CODE'		, width: 80 ,hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 120},
			{dataIndex: 'ITEM_CODE'			, width: 120 ,locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.subtotal" default="소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
				}
			},

			{dataIndex: 'ORDER_DATE'		, width: 80},
			{dataIndex: 'ITEM_NAME'			, width: 150 ,locked: false},
			{dataIndex: 'SPEC'				, width: 120},

			{dataIndex: 'ORDER_TYPE'		, width: 80 ,align: 'center'},

			{dataIndex: 'STOCK_UNIT'		, width: 53 ,align: 'center'},

			{dataIndex: 'ORDER_UNIT_Q'		, width: 80 ,summaryType: 'sum'},
			{dataIndex: 'MONEY_UNIT'		, width: 73 ,align: 'center'},
			{dataIndex: 'ORDER_UNIT_P'		, width: 93},
			{dataIndex: 'ORDER_O'			, width: 106 ,summaryType: 'sum'},
			{dataIndex: 'DVRY_DATE'			, width: 80},
			{dataIndex: 'DVRY_TIME'			, width: 80, hidden: true },
			{dataIndex: 'EXCHG_RATE_O'		, width: 80 },
			{dataIndex: 'ORDER_LOC_P'		, width: 93 },
			{dataIndex: 'ORDER_LOC_O'		, width: 106 ,summaryType: 'sum'},
			{dataIndex: 'INSTOCK_Q'			, width: 93 ,summaryType: 'sum'},
			{dataIndex: 'TRNS_RATE'			, width: 93 },
			{dataIndex: 'UN_Q'				, width: 93 ,summaryType: 'sum'},
			{dataIndex: 'ORDER_PRSN'		, width: 93 ,align: 'center'},
			{dataIndex: 'WH_CODE'			, width: 100 ,align: 'center'},
			{dataIndex: 'ORDER_NUM'			, width: 106},
			{dataIndex: 'PO_REQ_NUM'		, width: 106},
			{dataIndex: 'PROJECT_NO'		, width: 133},
			{dataIndex: 'CONTROL_STATUS'	, width: 88 ,align: 'center'},
			{dataIndex: 'ORDER_REQ_NUM'		, width: 100, hidden: true },
			{dataIndex: 'UNIT_PRICE_TYPE'	, width: 66 ,align: 'center', hidden: true },
			{dataIndex: 'AGREE_STATUS'		, width: 66 ,align: 'center'},
			{dataIndex: 'AGREE_DATE'		, width: 80, hidden: true },
			{dataIndex: 'AGREE_PRSN'		, width: 66, hidden: true },
			{dataIndex: 'ITEM_LEVEL1'		, width: 120 ,locked: false, hidden: true },
			{dataIndex: 'ITEM_LEVEL2'		, width: 120 ,locked: false, hidden: true },
			{dataIndex: 'REMARK'			, width: 133},
			{dataIndex: 'USAGE_PLACE'       , width: 93},
			{dataIndex: 'INSERT_DB_TIME'	, width: 80, hidden: true }
		],
		listeners: {
			selectionchange:function( grid, selection, eOpts )	{
				if(selection && selection.startCell)	{
					var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary");
					if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex)	{

					var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
					var store = grid.store;
					var sum = 0;

					for(var i=startIdx; i <= endIdx; i++){
						var record = store.getAt(i);
						sum += record.get(columnName);
					}
						this.down('#selectionSummary').setValue(sum);
					} else {
						this.down('#selectionSummary').setValue(0);
					}
				}
			},
			afterrender: function(grid) {
				var me = this;
				me.contextMenu = Ext.create('Ext.menu.Menu', {});
				if(!Ext.isEmpty(gslinkPgmInfo)) {
					Ext.each(gslinkPgmInfo, function(linkRecord,i) {
						var pgm_id	= linkRecord.refCode2
						var url		= '/' + linkRecord.refCode3 + '/' + pgm_id + '.do';
						me.contextMenu.add({
							text	: linkRecord.refCode1,
							iconCls	: '',
							handler	: function(menuItem, event) {
								var record = grid.getSelectedRecord();
								var params = {
									sender			: me,
									'PGM_ID'		: 'mpo130skrv',
									'ORDER_NUM'		: record.data['ORDER_NUM'],
									'ORDER_TYPE'	: record.data['ORDER_TYPE'],
									'CUSTOM_CODE'	: record.data['CUSTOM_CODE'],
									'CUSTOM_NAME'	: record.data['CUSTOM_NAME'],
									'MONEY_UNIT'	: record.data['MONEY_UNIT'],
									'EXCHG_RATE_O'	: record.data['EXCHG_RATE_O'],
									'ORDER_DATE'	: record.data['ORDER_DATE']
								}
								var rec = {data : {prgID : pgm_id, 'text':''}};
								parent.openTab(rec, url, params);
							}
						})
					});
				} else {
					me.contextMenu.add({
						text	: '<t:message code="system.label.purchase.poentry" default="발주등록"/>',
						iconCls	: '',
						handler	: function(menuItem, event) {
							var record = grid.getSelectedRecord();
							var params = {
								sender			: me,
								'PGM_ID'		: 'mpo130skrv',
								'ORDER_NUM'		: record.data['ORDER_NUM'],
								'ORDER_TYPE'	: record.data['ORDER_TYPE'],
								'CUSTOM_CODE'	: record.data['CUSTOM_CODE'],
								'CUSTOM_NAME'	: record.data['CUSTOM_NAME'],
								'MONEY_UNIT'	: record.data['MONEY_UNIT'],
								'EXCHG_RATE_O'	: record.data['EXCHG_RATE_O'],
								'ORDER_DATE'	: record.data['ORDER_DATE']
							}
							var rec = {data : {prgID : 'mpo501ukrv', 'text':''}};
							parent.openTab(rec, '/matrl/mpo501ukrv.do', params);
						}
					})
				}
			},
			onGridDblClick :function( grid, record, cellIndex, colName ) {
				//공통코드에 LINK PG에 대한 정보가 있을 경우, 같이 넘긴다.
				if(!Ext.isEmpty(gslinkPgmInfo) && !Ext.isEmpty(gslinkPgmInfo[0].refCode2)) {
					var pgm_id = gslinkPgmInfo[0].refCode2;
				}
				masterGrid.gotoSmpo501ukrv(record, pgm_id);
			}
		},
		gotoSmpo501ukrv:function(record, pgm_id) {
			if(record)	{
				var params = {
					action			: 'select',
					'PGM_ID'		: 'mpo130skrv',
					'ORDER_NUM'		: record.data['ORDER_NUM'],
					'ORDER_TYPE'	: record.data['ORDER_TYPE'],
					'CUSTOM_CODE'	: record.data['CUSTOM_CODE'],
					'CUSTOM_NAME'	: record.data['CUSTOM_NAME'],
					'MONEY_UNIT'	: record.data['MONEY_UNIT'],
					'EXCHG_RATE_O'	: record.data['EXCHG_RATE_O'],
					'ORDER_DATE'	: record.data['ORDER_DATE']
				}
				
				//공통코드에 LINK PG에 대한 정보가  등록되어 있지 않으면 기본(발주등록)으로 링크
				if(Ext.isEmpty(pgm_id)) {
					pgm_id	= 'mpo501ukrv';
					var url	= '/matrl/mpo501ukrv.do';

				//공통코드에 LINK PG에 대한 정보가  등록되어 있을 경우, 더블클릭 시 첫번 째 저장 값으로 이동 
				} else {
					var url	= '/' + gslinkPgmInfo[0].refCode3 + '/' + pgm_id + '.do';
				}
				var rec1= {data : {prgID : pgm_id, 'text':''}};
				parent.openTab(rec1, url, params);
			}
		}
	});



	Unilite.Main({
		id: 'mpo130skrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('ORDER_DATE_TO',UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO',UniDate.get('today'));
			panelSearch.setValue('ORDER_PRSN',BsaCodeInfo.gsOrderPrsn);
			panelResult.setValue('ORDER_PRSN',BsaCodeInfo.gsOrderPrsn);
			var field = panelSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('CLOSE_FG','A');
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown: function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords();
			//var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.getView();
			//console.log("viewLocked: ", viewLocked);
			console.log("viewNormal: ", viewNormal);
			//viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			//viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			UniAppManager.setToolbarButtons('excel',true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		}
	});
};
</script>
