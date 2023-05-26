<%--
'   프로그램명 : 보드검사현황
'
'   작  성  자 : (주)시너지시스템즈 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_mms200skrv_mek">
	<t:ExtComboStore comboType="BOR120"				/>		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="Q022"/>		<!-- 검사담당 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">
var BsaCodeInfo = {
	gsInspecPrsn		: '${gsInspecPrsn}'
};

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_mms200skrv_mekService.selectList'
		}
	});

	/**
	 * master grid1 Model
	 */
	Unilite.defineModel('s_mms200skrv_mekModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'				, type: 'string'},
			{name: 'INSPEC_NUM'			, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'				, type: 'string'},
			{name: 'INSPEC_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'					, type: 'int'},
			{name: 'INSPEC_DATE'		, text: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>'			, type: 'uniDate'},
			{name: 'IN_TYPE'			, text: '<t:message code="" default="입고형태"/>'											, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'HW'					, text: '<t:message code="" default="HW"/>'												, type: 'string'},
			{name: 'SW'					, text: '<t:message code="" default="SW"/>'												, type: 'string'},
			{name: 'LOT_NO'				, text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>'				, type: 'string'},
			{name: 'GOODBAD_TYPE'		, text: '<t:message code="system.label.purchase.passyn" default="합격여부"/>'				, type: 'string'},
			{name: 'GOODBAD_TYPE_NAME'	, text: '<t:message code="" default="진행구분"/>'											, type: 'string'},
			{name: 'RECEIPT_Q'			, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'			, type: 'uniQty'},
			{name: 'INSPEC_Q'			, text: '<t:message code="system.label.product.inspecqty2" default="검사량(시료)"/>'			, type: 'uniQty'},
			{name: 'GOOD_INSPEC_Q'		, text: '<t:message code="system.label.purchase.passqty2stock" default="합격수량(재고)"/>'	, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q'		, text: '<t:message code="system.label.purchase.defectqty2" default="불량(폐기)수량"/>'		, type: 'uniQty'},
			{name: 'BAD_INSPEC_RATE'	, text: '<t:message code="system.label.product.defectratepercent" default="불량률(%)"/>'	, type: 'uniPercent'},
			{name: 'INSPEC_PRSN'		, text: '<t:message code="system.label.purchase.inspecchargeperson" default="검사담당자"/>'	, type: 'string'},
			{name: 'INSPEC_PRSN_NAME'	, text: '<t:message code="system.label.purchase.inspecchargeperson" default="검사담당자"/>'	, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'			, type: 'string'},
			{name: 'COMPLETE_DATE'		, text: '<t:message code="" default="검사완료일"/>'											, type: 'uniDate'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'}
		]
	});

	/**
	 * master grid1 store
	 */
	var directMasterStore = Unilite.createStore('s_mms200skrv_mekMasterStore', {
		model : 's_mms200skrv_mekModel',
		uniOpt: {
			isMaster  : true,			// 상위 버튼 연결
			editable  : false,			// 수정 모드 사용
			deletable : false,			// 삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
		autoLoad : false,
		proxy	: directProxy,
		loadStoreRecords: function(){
			var param = panelSearch.getValues();
			console.log(param);
			
			this.load({
				params : param
			});
		}
	});

	/**
	 * Search Panel
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		defaultType	: 'uniSearchSubPanel',
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title  : '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId : 'search_panel1',
			layout : {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'INSPEC_DATE_FR',
				endFieldName	: 'INSPEC_DATE_TO',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('INSPEC_DATE_FR', newValue);
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('INSPEC_DATE_TO', newValue);
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.inspeccharge" default="검사담당"/>',
				name		: 'INSPEC_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Q022',
				allowBlank	: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPEC_PRSN', newValue);
					},
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						var pRStore = panelSearch.getField('INSPEC_PRSN').store;
						var divChk = false;
						Ext.each(store.data.items, function(record,i){
							if(!Ext.isEmpty(record.get('refCode1'))){
								divChk = true;
							}
						});
						store.clearFilter();
						pRStore.clearFilter();
						if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE')) && divChk == true ){
							store.filterBy(function(record){
								return record.get('refCode1') == panelSearch.getValue('DIV_CODE');
							});
							pRStore.filterBy(function(record){
								return record.get('refCode1') == panelSearch.getValue('DIV_CODE');
							});
						}else if(divChk == false){
								return true;
						}else{
							store.filterBy(function(record){
								return false;
							});
							pRStore.filterBy(function(record){
								return false;
							});
						}
					}
				}
			},
			Unilite.popup('DIV_PUMOK', {
				fieldLabel		: '<t:message code="system.label.purchase.item" default="품목"/>',
				textFieldWidth	: 170,
				allowBlank		: true,		// 2021.08 표준화 작업
				autoPopup		: false,	// 2021.08 표준화 작업
				validateBlank	: false,	// 2021.08 표준화 작업
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
						panelResult.setValue('ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){		// 2021.08 표준화 작업
						panelResult.setValue('ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){								// 2021.08 표준화 작업
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('CUST', {
				fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				textFieldWidth	: 170,
				allowBlank		: true,		// 2021.08 표준화 작업
				autoPopup		: false,	// 2021.08 표준화 작업
				validateBlank	: false,	// 2021.08 표준화 작업
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
						panelResult.setValue('CUSTOM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){		// 2021.08 표준화 작업
						panelResult.setValue('CUSTOM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup){								// 2021.08 표준화 작업
					}
				}
			})]
		}]
	});

	/**
	 * panel result
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'INSPEC_DATE_FR',
			endFieldName	: 'INSPEC_DATE_TO',
			allowBlank		: false,
			colspan			: 3,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('INSPEC_DATE_FR', newValue);
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('INSPEC_DATE_TO', newValue);
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.inspeccharge" default="검사담당"/>',
			name		: 'INSPEC_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'Q022',
			allowBlank	: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INSPEC_PRSN', newValue);
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					var pRStore = panelResult.getField('INSPEC_PRSN').store;
					var divChk = false;
					Ext.each(store.data.items, function(record,i){
						if(!Ext.isEmpty(record.get('refCode1'))){
							divChk = true;
						}
					});
					store.clearFilter();
					pRStore.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE')) && divChk == true ){
						store.filterBy(function(record){
							return record.get('refCode1') == panelResult.getValue('DIV_CODE');
						});
						pRStore.filterBy(function(record){
							return record.get('refCode1') == panelResult.getValue('DIV_CODE');
						});
					}else if(divChk == false){
							return true;
					}else{
						store.filterBy(function(record){
							return false;
						});
						pRStore.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '<t:message code="system.label.purchase.item" default="품목"/>',
			textFieldWidth	: 170,
			allowBlank		: true,		// 2021.08 표준화 작업
			autoPopup		: false,	// 2021.08 표준화 작업
			validateBlank	: false,	// 2021.08 표준화 작업
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
					panelSearch.setValue('ITEM_CODE', newValue);
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_NAME', '');
						panelSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){		// 2021.08 표준화 작업
					panelSearch.setValue('ITEM_NAME', newValue);
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){								// 2021.08 표준화 작업
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			textFieldWidth	: 170,
			allowBlank		: true,		// 2021.08 표준화 작업
			autoPopup		: false,	// 2021.08 표준화 작업
			validateBlank	: false,	// 2021.08 표준화 작업
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
					panelSearch.setValue('CUSTOM_CODE', newValue);
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_NAME', '');
						panelSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){		// 2021.08 표준화 작업
					panelSearch.setValue('CUSTOM_NAME', newValue);
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_CODE', '');
						panelSearch.setValue('CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){								// 2021.08 표준화 작업
				}
			}
		}),{
			xtype		: 'component',
			html		: '※ 입고형태 [<b>N</b>ew, Repair(<b>M</b>:MODULE, <b>R</b>:제조), <b>U</b>p Grade, <b>Q</b>R Code 교체 (A/S팀)]',
			//width		: 500
			padding		: '0 0 0 50',
			tdAttrs		: {align:'right'}
		}]
	});

	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_mms200skrv_mekGrid', {
		layout	: 'fit',
		region	:'center',
		store	: directMasterStore,
		flex	: 1,
		uniOpt: {
			expandLastColumn	: false,
			useLiveSearch		: true,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		columns: [
			{dataIndex: 'COMP_CODE'				, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'				, width: 100	, hidden: true},
			{dataIndex: 'INSPEC_NUM'			, width: 100	, hidden: true},
			{dataIndex: 'INSPEC_SEQ'			, width: 100	, hidden: true},
			{dataIndex: 'INSPEC_DATE'			, width: 100},
			{dataIndex: 'IN_TYPE'				, width: 150},
			{dataIndex: 'ITEM_CODE'				, width: 120},
			{dataIndex: 'ITEM_NAME'				, width: 150},
			{dataIndex: 'SPEC'					, width: 150},
			{dataIndex: 'HW'					, width: 150},
			{dataIndex: 'SW'					, width: 150},
			{dataIndex: 'LOT_NO'				, width: 120},
			{dataIndex: 'GOODBAD_TYPE'			, width: 100	, hidden: true},
			{dataIndex: 'GOODBAD_TYPE_NAME'		, width: 100},
			{dataIndex: 'RECEIPT_Q'				, width: 100},
			{dataIndex: 'INSPEC_Q'				, width: 100},
			{dataIndex: 'GOOD_INSPEC_Q'			, width: 100},
			{dataIndex: 'BAD_INSPEC_Q'			, width: 100},
			{dataIndex: 'BAD_INSPEC_RATE'		, width: 100},
			{dataIndex: 'INSPEC_PRSN'			, width: 100	, hidden: true},
			{dataIndex: 'INSPEC_PRSN_NAME'		, width: 100},
			{dataIndex: 'CUSTOM_CODE'			, width: 120	, hidden: true},
			{dataIndex: 'CUSTOM_NAME'			, width: 120},
			{dataIndex: 'COMPLETE_DATE'			, width: 100},
			{dataIndex: 'REMARK'				, width: 200}
		]
	});//End of var masterGrid = Unilite.createGrid('s_mms200skrv_mekGrid', {

	Unilite.Main({
		borderItems:[{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]},
			panelSearch
		],
		id: 's_mms200skrv_mekApp',
		fnInitBinding: function(){
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('INSPEC_DATE_FR', UniDate.get("startOfMonth"));
			panelResult.setValue('INSPEC_DATE_FR', UniDate.get("startOfMonth"));
			panelSearch.setValue('INSPEC_DATE_TO', UniDate.get("today"));
			panelResult.setValue('INSPEC_DATE_TO', UniDate.get("today"));
			panelSearch.setValue('INSPEC_PRSN', BsaCodeInfo.gsInspecPrsn);
			panelResult.setValue('INSPEC_PRSN', BsaCodeInfo.gsInspecPrsn);
			
			UniAppManager.setToolbarButtons(['detail'], false);
		},
		onQueryButtonDown: function(){
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterGrid.getStore().clearData();
			
			this.fnInitBinding();
		}
	});
};//End of Unilite.Main({
</script>