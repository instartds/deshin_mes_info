<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str140skrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_str140skrv_mit"/>	<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />	<!-- 창고Cell-->
</t:appConfig>
<style type="text/css">
	.x-change-cell {
		background-color: #FFFFC6;
	}
	.x-change-cell_Red {
		background-color: #FF0000;
	}
	.x-change-cell_Green {
		background-color: #1DDB16;
	}
</style>
<script type="text/javascript" >

function appMain() {
	/** 검색조건
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
			},{
				fieldLabel		: '완료예정일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'PRODT_END_DATE_FR',
				endFieldName	: 'PRODT_END_DATE_TO',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_END_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_END_DATE_TO',newValue);
					}
				}
			},
			Unilite.popup('ORDER_NUM',{
				fieldLabel		: '수주번호',
				validateBlank	: false,
				listeners		: {
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ORDER_NUM', newValue);
					},
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ORDER_NUM', panelSearch.getValue('ORDER_NUM'));
						},
						scope: this
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{//20200410 수정: 위치 수정
				fieldLabel	: '진행상태',
				xtype		: 'radiogroup',
				items		: [{
					boxLabel	: '<t:message code="system.label.product.whole" default="전체"/>',
					name		: 'WKORD_STATUS',
					inputValue	: '',
					width		: 60
				},{
					boxLabel	: '<t:message code="system.label.product.process" default="진행"/>',
					name		: 'WKORD_STATUS',
					inputValue	: 'N',
					width		: 60
				},{
					boxLabel	: '<t:message code="system.label.product.completion" default="완료"/>',
					name		: 'WKORD_STATUS',
					inputValue	: 'Y',
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('WKORD_STATUS').setValue(newValue.WKORD_STATUS);
					}
				}
			},{
				xtype		: 'container',
				layout		: { type: 'uniTable', columns: 2},
				defaultType	: 'uniTextfield',
				items		: [
					Unilite.popup('DIV_PUMOK',{
						fieldLabel		: '품목코드',
						valueFieldName	: 'ITEM_CODE',
						textFieldName	: 'ITEM_NAME',
						validateBlank	: false,
						valueFieldWidth	: 80,
						textFieldWidth	: 100,
						listeners		: {
							onValueFieldChange: function(field, newValue){
								panelResult.setValue('ITEM_CODE', newValue);
								if(Ext.isEmpty(newValue)) {
									panelSearch.setValue('ITEM_NAME', newValue);
									panelSearch.setValue('SPEC'		, newValue);
									panelResult.setValue('ITEM_NAME', newValue);
									panelResult.setValue('SPEC'		, newValue);
								}
							},
							onTextFieldChange: function(field, newValue){
								panelResult.setValue('ITEM_NAME', newValue);
							},
							onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('ITEM_CODE',records[0]["ITEM_CODE"]);
									panelSearch.setValue('ITEM_NAME',records[0]["ITEM_NAME"]);
									panelSearch.setValue('SPEC'		,records[0]["SPEC"]);
									panelResult.setValue('ITEM_CODE',records[0]["ITEM_CODE"]);
									panelResult.setValue('ITEM_NAME',records[0]["ITEM_NAME"]);
									panelResult.setValue('SPEC'		,records[0]["SPEC"]);
								},
								scope: this
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
				}),{
					name		: 'SPEC',
					xtype		: 'uniTextfield',
					width		: 50,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('SPEC', newValue);
						}
					}
				}]
			},
			Unilite.popup('LOT_NO',{
				fieldLabel		: 'LOT NO',
				validateBlank	: false,
				listeners		: {
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('LOT_NO', newValue);
					},
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('LOT_NO', panelSearch.getValue('LOT_NO'));
						},
						scope: this
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			//20200410 추가: 조회조건 "거래처" 추가
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE',
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
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER': ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE': ['1','3']});
					}
				}
			})]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 4},
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
		},{
			fieldLabel		: '완료예정일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'PRODT_END_DATE_FR',
			endFieldName	: 'PRODT_END_DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_END_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_END_DATE_TO',newValue);
				}
			}
		},
		Unilite.popup('ORDER_NUM',{
			fieldLabel		: '수주번호',
			validateBlank	: false,
			listeners		: {
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ORDER_NUM', newValue);
				},
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ORDER_NUM', panelResult.getValue('ORDER_NUM'));
					},
					scope: this
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{//20200410 수정: 위치 수정
			fieldLabel	: '진행상태',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '<t:message code="system.label.product.whole" default="전체"/>',
				name		: 'WKORD_STATUS',
				inputValue	: '',
				width		: 60
			},{
				boxLabel	: '<t:message code="system.label.product.process" default="진행"/>',
				name		: 'WKORD_STATUS',
				inputValue	: 'N',
				width		: 60
			},{
				boxLabel	: '<t:message code="system.label.product.completion" default="완료"/>',
				name		: 'WKORD_STATUS',
				inputValue	: 'Y',
				width		: 60
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('WKORD_STATUS').setValue(newValue.WKORD_STATUS);
				}
			}
		},{
			xtype		: 'container',
			layout		: { type: 'uniTable', columns: 2},
			defaultType	: 'uniTextfield',
			items		: [
				Unilite.popup('DIV_PUMOK',{
					fieldLabel		: '품목코드',
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					validateBlank	: false,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('ITEM_CODE', newValue);
							if(Ext.isEmpty(newValue)) {
								panelSearch.setValue('ITEM_NAME', newValue);
								panelSearch.setValue('SPEC'		, newValue);
								panelResult.setValue('ITEM_NAME', newValue);
								panelResult.setValue('SPEC'		, newValue);
							}
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('ITEM_NAME', newValue);
						},
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ITEM_CODE',records[0]["ITEM_CODE"]);
								panelSearch.setValue('ITEM_NAME',records[0]["ITEM_NAME"]);
								panelSearch.setValue('SPEC'		,records[0]["SPEC"]);

								panelResult.setValue('ITEM_CODE',records[0]["ITEM_CODE"]);
								panelResult.setValue('ITEM_NAME',records[0]["ITEM_NAME"]);
								panelResult.setValue('SPEC'		,records[0]["SPEC"]);
							},
							scope: this
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
				name		: 'SPEC',
				xtype		: 'uniTextfield',
				width		: 100,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('SPEC', newValue);
					}
				}
			}]
		},
		Unilite.popup('LOT_NO',{
			fieldLabel		: 'LOT NO',
			validateBlank	: false,
			listeners		: {
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('LOT_NO', newValue);
				},
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('LOT_NO', panelResult.getValue('LOT_NO'));
					},
					scope: this
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		//20200410 추가: 조회조건 "거래처" 추가
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
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
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER': ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE': ['1','3']});
				}
			}
		})]
	});



	Unilite.defineModel('s_str140skrv_mitModel', {
		fields: [
			{name: 'ORDER_NUM'		, text: '오더번호'		, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '거래처코드'		, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '거래처명'		, type: 'string'},
			{name: 'ITEM_CODE'		, text: '품목코드'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '품명'		, type: 'string'},
			{name: 'SPEC'			, text: '규격'		, type: 'string'},
			{name: 'WKORD_Q'		, text: '작지수량'		, type: 'uniQty'},
			{name: 'WKORD_NUM'		, text: '작지번호'		, type: 'string'},
			{name: 'LOT_NO'			, text: 'LOT NO'	, type: 'string'},
			{name: 'COAT_WKORD_NUM'	, text: '코팅작지번호'	, type: 'string'},
			{name: 'COAT_ITEM_CODE'	, text: '코팅품목'		, type: 'string'},
			{name: 'COAT_DATE'		, text: '코팅일'		, type: 'uniDate'},
			{name: 'INS_WKORD_NUM'	, text: '삽입기구작지번호'	, type: 'string'},
			{name: 'INS_ITEM_CODE'	, text: '삽입기구품목'	, type: 'string'},
			{name: 'INS_DATE'		, text: '생산일'		, type: 'uniDate'},
			{name: 'PACK_DATE'		, text: '조립포장일'		, type: 'uniDate'},
			{name: 'IN_DATE'		, text: '멸균입고일'		, type: 'uniDate'},
			{name: 'WH_CODE'		, text: '입고창고'		, type: 'string',  store: Ext.data.StoreManager.lookup('whList')},
			{name: 'MOVE_DATE'		, text: '제품창고이동일', type: 'uniDate'},
			{name: 'IN_WH_NAME'		, text: '제품창고'		, type: 'string'}
		]
	});

	var directMasterStore = Unilite.createStore('s_str140skrv_mitMasterStore',{
		model	: 's_str140skrv_mitModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_str140skrv_mitService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param = panelSearch.getValues();
			console.log( param );
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
			}
		},
		groupField: 'ORDER_NUM'
	});

	var masterGrid = Unilite.createGrid('s_str140skrv_mitGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: true,
			onLoadSelectFirst	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ 
			{id: 'masterGridSubTotal1'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'masterGridTotal1'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		selModel: 'rowmodel',
		columns	: [
			{ text: '영업 PART',
				columns: [
					{dataIndex: 'ORDER_NUM'		, width: 110,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
						}					
					},
					{dataIndex: 'CUSTOM_CODE'	, width: 100},
					{dataIndex: 'CUSTOM_NAME'	, width: 250},
					{dataIndex: 'ITEM_CODE'		, width: 100},
					{dataIndex: 'ITEM_NAME'		, width: 250	, hidden: true},
					{dataIndex: 'SPEC'			, width: 150},
					{dataIndex: 'WKORD_Q'		, width: 100, summaryType: 'sum'}
				]
			},
			{ text: '생산 PART',
				columns: [
					{dataIndex: 'WKORD_NUM'		, width: 110},
					{dataIndex: 'LOT_NO'		, width: 100},
					{dataIndex: 'COAT_WKORD_NUM', width: 110	, hidden: true},
					{dataIndex: 'COAT_ITEM_CODE', width: 100},
					{dataIndex: 'COAT_DATE'		, width: 100},
					{dataIndex: 'INS_WKORD_NUM'	, width: 110	, hidden: true},
					{dataIndex: 'INS_ITEM_CODE'	, width: 100},
					{dataIndex: 'INS_DATE'		, width: 100},
					{dataIndex: 'PACK_DATE'		, width: 100}
				]
			},
			{ text: '창고 PART',
				columns: [
					{dataIndex: 'IN_DATE'		, width: 100},
					{dataIndex: 'WH_CODE'		, width: 110, hidden: true},
					{dataIndex: 'MOVE_DATE'		, width: 110},
					{dataIndex: 'IN_WH_NAME'	, width: 110}
				]
			}
		]
	});



	Unilite.Main({
		id			: 's_str140skrv_mitApp',
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
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('PRODT_END_DATE_FR',UniDate.get('today'));
			panelSearch.setValue('PRODT_END_DATE_TO',UniDate.get('endOfTwoNextMonth'));
			panelResult.getField('WKORD_STATUS').setValue('');
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('PRODT_END_DATE_FR',UniDate.get('today'));
			panelResult.setValue('PRODT_END_DATE_TO',UniDate.get('endOfTwoNextMonth'));
			panelResult.getField('WKORD_STATUS').setValue('');

			//초기화 시 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');

			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','save'], false);
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()) return false;
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});
};
</script>