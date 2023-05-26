<%--
'	프로그램명 : 출하지시서 출력(영업)
'	작   성   자 : 시너지시스템즈 개발실
'	작   성   일 :
'	최종수정자 :
'	최종수정일 :
'	버         전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="srq300rkrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="srq300rkrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S148"/>			<!-- 주문구분 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333; font-weight: normal; padding: 1px 2px;}
</style>

<script type="text/javascript" >
function appMain() {
	Unilite.defineModel('Srq300rkrvModel', {
		fields: [
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type:'string'},
			{name: 'ISSUE_REQ_NUM'	, text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'	,type: 'string'},
			{name: 'SER_NO'			, text: 'SER_NO'		, type: 'string'},
			{name: 'ISSUE_REQ_DATE'	, text: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'	, type: 'uniDate'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.sales.customcode" default="거래처코드"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'				, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type:'string'},
			{name: 'WH_NAME'		, text: '<t:message code="system.label.sales.warehouse" default="창고"/>'				, type: 'string'},
			{name: 'PRINT_YN'		, text: '인쇄여부'			, type:'string'},
			{name: 'COUNT_NO'		, text: 'COUNT_NO'		, type: 'int'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('srq300rkrvMasterStore1', {
		model	: 'Srq300rkrvModel',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼,상태바 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'srq300rkrvService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param		= Ext.getCmp('searchForm').getValues();
			var authoInfo	= pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records && records.length > 0){
					UniAppManager.setToolbarButtons(['print'], true);
				} else {
					UniAppManager.setToolbarButtons(['print'], false);
				}
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			}
		}
	});



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
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>',
				xtype			: 'uniDateRangefield',
				allowBlank		: false,
				startFieldName	: 'ISSUE_REQ_DATE_FR',
				endFieldName	: 'ISSUE_REQ_DATE_TO',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ISSUE_REQ_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ISSUE_REQ_DATE_TO',newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_CODE', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_NAME', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup) {
						popup.setExtParam({'CUSTOM_TYPE':['1','3']});
					}
				}
			})]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>',
			xtype			: 'uniDateRangefield',
			allowBlank		: false,
			startFieldName	: 'ISSUE_REQ_DATE_FR',
			endFieldName	: 'ISSUE_REQ_DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ISSUE_REQ_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ISSUE_REQ_DATE_TO',newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup) {
					popup.setExtParam({'CUSTOM_TYPE':['1','3']});
				}
			}
		}),{
			fieldLabel	: 'ISSUE_NUMs',
			xtype		: 'uniTextfield',
			name		: 'ISSUE_REQ_NUM',
			hidden		: true
		},{
			fieldLabel	: 'CUSTOMs',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_CODES',
			hidden		: true
		}]
	});



	/** Master Grid1 정의(Grid Panel),
	 * @type
	 */
	var masterGrid = Unilite.createGrid('srq300rkrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
				}
			}
		}),
		uniOpt: {
			expandLastColumn	: true,
			useGroupSummary		: false,
			useLiveSearch		: false,
			useContextMenu		: false,
			useRowContext		: true,
			onLoadSelectFirst	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [
			{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'DIV_CODE'			, width: 110, hidden: true},
			{dataIndex: 'ISSUE_REQ_NUM'		, width: 110},
			{dataIndex: 'SER_NO'			, width: 110, hidden: true},
			{dataIndex: 'ISSUE_REQ_DATE'	, width: 110},
			{dataIndex: 'CUSTOM_CODE'		, width: 100},
			{dataIndex: 'CUSTOM_NAME'		, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 350},
			{dataIndex: 'WH_NAME'			, width: 180},
			{dataIndex: 'PRINT_YN'			, width: 130, hidden: true},
			{dataIndex: 'COUNT_NO'			, width: 130, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			}
		}
	});



	Unilite.Main({
		id			: 'srq300rkrvApp',
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
			panelSearch.setValue('DIV_CODE'			, UserInfo.divCode);
			panelSearch.setValue('ISSUE_REQ_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('ISSUE_REQ_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('ISSUE_REQ_DATE_TO')));
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('ISSUE_REQ_DATE_TO', UniDate.get('today'));
			panelResult.setValue('ISSUE_REQ_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('ISSUE_REQ_DATE_TO')));

			//초기화 시 사업장 필드로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		},
		onPrintButtonDown: function()  {
			var param			= panelResult.getValues();
			var selectedDetails	= masterGrid.getSelectedRecords();
			var orderNums		= '';
			var orderPrints		= '';
			Ext.each(selectedDetails, function(record, idx) {
				if(idx ==0) {
					orderNums	= record.get("ISSUE_REQ_NUM");
					orderPrints	= record.get('CUSTOM_CODE');
				}else{
					orderNums	= orderNums + ',' + record.get("ISSUE_REQ_NUM");
					orderPrints	= orderPrints + ',' + record.get('CUSTOM_CODE');
				}
			});
			panelResult.setValue('ISSUE_REQ_NUM', orderNums);
			panelResult.setValue('CUSTOM_CODES'	, orderPrints);

			param				= panelResult.getValues();
			param['PGM_ID']		= PGM_ID;
			param['MAIN_CODE']	= 'S036';//영업용 공통 코드
			var win	= Ext.create('widget.ClipReport', {
				url		: CPATH+'/sales/srq300clrkrv.do',
				prgID	: 'srq300rkrv',
				extParam: param
			});
			win.center();
			win.show();
		}
	});
};
</script>