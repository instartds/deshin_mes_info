<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms220skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mms220skrv"/>	<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >



function appMain() {
	/** Model 정의
	 */
	Unilite.defineModel('mms220skrvModel', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'},
			{name: 'RECEIPT_DATE'	, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'		, type: 'uniDate'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'LOT_NO'			, text: 'LOT NO'	, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		, type: 'string'},
			{name: 'RECEIPT_Q'		, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'		, type: 'uniQty'},
			{name: 'RECEIPT_PRSN'	, text: '<t:message code="system.label.purchase.receptionist" default="접수자"/>'		, type: 'string'},
			{name: 'RECEIPT_NUM'	, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'		, type: 'string'},
			{name: 'RECEIPT_SEQ'	, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'		, type: 'int'},
			{name: 'ORDER_NUM'		, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
			{name: 'ORDER_SEQ'		, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'			, type: 'int'},
			{name: 'TRADE_FLAG_YN'	, text: '<t:message code="system.label.purchase.whethertoimport" default="수입여부"/>'	, type: 'string'},
			{name: 'BASIS_NUM'		, text: '<t:message code="system.label.purchase.customsnumber" default="통관번호"/>'	, type: 'string'},
			{name: 'BASIS_SEQ'		, text: '<t:message code="system.label.purchase.customsclearance" default="통관순번"/>'	, type: 'int'}
		]
	});

	/** Store 정의(Service 정의)
	 */
	var masterStore = Unilite.createStore('mms220skrvMasterStore1', {
		model	: 'mms220skrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'mms220skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		}
	});



	/** 검색조건 (Search Panel)
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
		items: [{
			title		: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_CODE', newValue);
								panelResult.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_NAME', '');
									panelResult.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_NAME', newValue);
								panelResult.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_CODE', '');
									panelResult.setValue('CUSTOM_CODE', '');
								}
							}
					}
			}),{
				fieldLabel		: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'RECEIPT_DATE_FR',
				endFieldName	: 'RECEIPT_DATE_TO',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('RECEIPT_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('RECEIPT_DATE_TO',newValue);
					}
				}
			}, 
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.purchase.item" default="품목"/>',
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
			})]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('CUSTOM_CODE', newValue);
							panelResult.setValue('CUSTOM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('CUSTOM_NAME', newValue);
							panelResult.setValue('CUSTOM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_CODE', '');
							}
						}
				}
		}),{
			fieldLabel		: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'RECEIPT_DATE_FR',
			endFieldName	: 'RECEIPT_DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('RECEIPT_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('RECEIPT_DATE_TO',newValue);
				}
			}
		}, 
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.purchase.item" default="품목"/>',
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
		})]
	});



	/** Master Grid 정의(Grid Panel)
	 */
	var masterGrid = Unilite.createGrid('mms220skrvGrid', {
		store	: masterStore,
		layout	:  'fit',
		region	: 'center',
		uniOpt	: {
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: false,
			dblClickToEdit		: false,
			useSqlTotal			: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: false,
			filter: {
				useFilter	: true,
				autoCreate	: true
			},
			state: {
				useState	: false,
				useStateList: false
			}
		},
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: false
		}],
		columns: [
			{dataIndex: 'COMP_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'RECEIPT_DATE'	, width: 100},
			{dataIndex: 'CUSTOM_CODE'	, width: 120},
			{dataIndex: 'CUSTOM_NAME'	, width: 200},
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 150},
			{dataIndex: 'SPEC'			, width: 200},
			{dataIndex: 'LOT_NO'		, width: 100},
			{dataIndex: 'ORDER_UNIT'	, width: 80		, align:'center'},
			{dataIndex: 'RECEIPT_Q'		, width: 100},
			{dataIndex: 'RECEIPT_PRSN'	, width: 90		, align:'center'},
			{dataIndex: 'RECEIPT_NUM'	, width: 120},
			{dataIndex: 'RECEIPT_SEQ'	, width: 66		, align:'center'},
			{dataIndex: 'ORDER_NUM'		, width: 120},
			{dataIndex: 'ORDER_SEQ'		, width: 66		, align:'center'},
			{dataIndex: 'TRADE_FLAG_YN'	, width: 66		, align:'center'},
			{dataIndex: 'BASIS_NUM'		, width: 120},
			{dataIndex: 'BASIS_SEQ'		, width: 66		, align:'center'}
		]
	});




	Unilite.Main({
		id			: 'mms220skrvApp',
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
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelSearch.setValue('RECEIPT_DATE_FR'	, UniDate.get('startOfMonth'));
			panelResult.setValue('RECEIPT_DATE_FR'	, UniDate.get('startOfMonth'));
			panelSearch.setValue('RECEIPT_DATE_TO'	, UniDate.get('today'));
			panelResult.setValue('RECEIPT_DATE_TO'	, UniDate.get('today'));

			//초기화 시 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterStore.loadStoreRecords();
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			UniAppManager.app.fnInitBinding();
		}
	});
};
</script>