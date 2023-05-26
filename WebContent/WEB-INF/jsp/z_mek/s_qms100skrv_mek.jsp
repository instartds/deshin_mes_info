<%--
'   프로그램명 : 품질업무일보 조회
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
<t:appConfig pgmId="s_qms100skrv_mek">
	<t:ExtComboStore comboType="BOR120"/> 			<!-- 사업장 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_qms100skrv_mekService.selectList'
		}
	});
	
	/**
	 * master grid Model
	 */
	Unilite.defineModel('s_qms100skrv_mekModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'},
			{name: 'WORK_USER_ID'		, text: '<t:message code="" default="작업자"/>'										, type: 'string'},
			{name: 'WORK_USER_NAME'		, text: '<t:message code="" default="작업자"/>'										, type: 'uniDate'},
			{name: 'WORK_DATE'			, text: '<t:message code="" default="작업일"/>'										, type: 'uniDate'},
			{name: 'WORK_TIME'			, text: '<t:message code="" default="소요공수"/>'										, type: 'uniPrice'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'INSPEC_Q'			, text: '<t:message code="" default="검사수량"/>'										, type: 'uniQty'},
			{name: 'BAD_Q'				, text: '<t:message code="system.label.purchase.defectqty" default="불량수량"/>'		, type: 'uniQty'}
		]
	});
	
	/**
	 * master grid store
	 */
	var directMasterStore = Unilite.createStore('s_qms100skrv_mekMasterStore', {
		model : 's_qms100skrv_mekModel',
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
	 * searchPanel
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
				fieldLabel		: '<t:message code="" default="작업일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'WORK_DATE_FR',
				endFieldName	: 'WORK_DATE_TO',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_DATE_FR', newValue);
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_DATE_TO', newValue);
				}
			},
			Unilite.popup('USER', {
				allowBlank		: true,		// 2021.08 표준화 작업
				autoPopup		: false,	// 2021.08 표준화 작업
				validateBlank	: false,	// 2021.08 표준화 작업
				textFieldWidth :120,
				valueFieldWidth: 99,
				listeners : {
//					'onSelected': {
//						fn: function(records, type ){
//							panelResult.setValue('USER_ID'	, records[0]['USER_ID']);
//							panelResult.setValue('USER_NAME', records[0]['USER_NAME']);
//						},
//						scope: this
//					}
//					, 'onClear' : function(type)	{
//						panelResult.setValue('USER_ID'	, '');
//						panelResult.setValue('USER_NAME', '');
//					}
					onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
						panelResult.setValue('USER_ID', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('USER_NAME', '');
							panelResult.setValue('USER_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){		// 2021.08 표준화 작업
						panelResult.setValue('USER_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('USER_ID', '');
							panelResult.setValue('USER_ID', '');
						}
					}
				}
			})]
		}]
	});
	
	/**
	 * panelResult
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
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
			fieldLabel	: '<t:message code="" default="작업일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'WORK_DATE_FR',
			endFieldName	: 'WORK_DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('WORK_DATE_FR', newValue);
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('WORK_DATE_TO', newValue);
			}
		},
		Unilite.popup('USER', {
			allowBlank		: true,		// 2021.08 표준화 작업
			autoPopup		: false,	// 2021.08 표준화 작업
			validateBlank	: false,	// 2021.08 표준화 작업
			valueFieldWidth	: 100,
			listeners : {
//				'onSelected': {
//					fn: function(records, type ){
//						panelSearch.setValue('USER_ID'	, records[0]['USER_ID']);
//						panelSearch.setValue('USER_NAME', records[0]['USER_NAME']);
//					},
//					scope: this
//				}
//				, 'onClear' : function(type)	{
//					panelSearch.setValue('USER_ID'	, '');
//					panelSearch.setValue('USER_NAME', '');
//				}
				onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
					panelSearch.setValue('USER_ID', newValue);
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('USER_NAME', '');
						panelSearch.setValue('USER_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){		// 2021.08 표준화 작업
					panelSearch.setValue('USER_NAME', newValue);
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('USER_ID', '');
						panelSearch.setValue('USER_ID', '');
					}
				}
			}
		})]
	});
	
	/**
	 * masterGrid
	 */
	var masterGrid = Unilite.createGrid('s_qms100skrv_mekMasterGrid', {
		layout: 'fit',
		region: 'center',
		uniOpt: {
			useLiveSearch		: true,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false,
			onLoadSelectFirst	: true,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowContext		: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		store: directMasterStore,
		sortableColumns : false,
		columns: [
			{dataIndex: 'COMP_CODE'		, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'WORK_USER_ID'	, width: 100, hidden: true},
			{dataIndex: 'WORK_USER_ID'	, width: 100},
			{dataIndex: 'WORK_DATE'		, width: 100},
			{dataIndex: 'WORK_TIME'		, width: 100},
			{dataIndex: 'ITEM_CODE'		, width: 100},
			{dataIndex: 'ITEM_NAME'		, width: 150},
			{dataIndex: 'SPEC'			, width: 150},
			{dataIndex: 'INSPEC_Q'		, width: 150},
			{dataIndex: 'BAD_Q'			, width: 150}
		]
	});//End of var masterGrid = Unilite.createGrid('s_qms100skrv_mekMasterGrid', {

	/**
	 * Main
	 */
	Unilite.Main({
		borderItems:[{
			region : 'center',
			layout : 'border',
			border : false,
			items  : [
				masterGrid, panelResult
			]},
			panelSearch
		],
		id : 's_qms100skrv_mekApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			
			panelSearch.setValue('WORK_DATE_FR'	, UniDate.get("startOfMonth"));
			panelResult.setValue('WORK_DATE_FR'	, UniDate.get("startOfMonth"));
			panelSearch.setValue('WORK_DATE_TO'	, UniDate.get("today"));
			panelResult.setValue('WORK_DATE_TO'	, UniDate.get("today"));
			
			UniAppManager.setToolbarButtons(['detail'], false);
		},
		onQueryButtonDown: function() {
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterGrid.getStore().clearData();
			
			this.fnInitBinding();
		}
	});//End of Unilite.Main( {
}
</script>
