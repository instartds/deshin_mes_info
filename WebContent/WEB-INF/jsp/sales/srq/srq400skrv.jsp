<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="srq400skrv">
	<t:ExtComboStore comboType="BOR120" pgmId="srq400skrv" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A035" /> 		<!-- 완료여부-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/** Model 정의 
	 * @type 
	 */	
	Unilite.defineModel('srq400skrvModel1', {
		fields: [
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.sales.client" default="고객"/>'					,type: 'string', maxLength: 8},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.sales.clientname" default="고객명"/>'			,type: 'string', maxLength: 20},
			{name: 'ORDER_NUM'		,text: '<t:message code="system.label.sales.sono" default="수주번호"/>' 				,type: 'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'ORDER_Q'		,text: '<t:message code="system.label.sales.issueresevationqty" default="출고예정량"/>'	,type: 'uniQty'},
			{name: 'ISSUE_QTY'		,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>'				,type: 'uniQty'},
			{name: 'COMPLETE_YN'	,text: '<t:message code="system.label.sales.complateyn" default="완료여부"/>'			,type: 'string', comboType: 'AU', comboCode: 'A035'},
			{name: 'QUERY_TIME'		,text: 'QUERY_TIME'	,type: 'string'}
		]
	});

	Unilite.defineModel('srq400skrvModel2', {
		fields: [
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.sales.client" default="고객"/>'					,type: 'string', maxLength: 8},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.sales.clientname" default="고객명"/>'			,type: 'string', maxLength: 20},
			{name: 'ORDER_NUM'		,text: '<t:message code="system.label.sales.pono" default="발주번호"/>' 				,type: 'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'ALLOC_Q'		,text: '<t:message code="system.label.sales.issueresevationqty" default="출고예정량"/>'	,type: 'uniQty'},
			{name: 'OUTSTOCK_Q'		,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>'				,type: 'uniQty'},
			{name: 'COMPLETE_YN'	,text: '<t:message code="system.label.sales.complateyn" default="완료여부"/>'			,type: 'string', comboType: 'AU', comboCode: 'A035'},
			{name: 'QUERY_TIME'		,text: 'QUERY_TIME'	,type: 'string'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('srq400skrvMasterStore1',{
		model	: 'srq400skrvModel1',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'srq400skrvService.selectList1'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
						setTimeout(function(){
							//20190918 2개 그리드에서 탭으로 변경되면서 시간에 따라 보여주는 탭 변경하는 것으로 변경
//							UniAppManager.app.onQueryButtonDown();
							var activeTabId = tab.getActiveTab().getId();
							if (activeTabId == 'srq400skrvGridTab') {
								tab.setActiveTab(1);
							} else {
								tab.setActiveTab(0);
							}
						}, 60000);
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
		}
	});

	var directMasterStore2 = Unilite.createStore('srq400skrvMasterStore2',{
		model	: 'srq400skrvModel2',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'srq400skrvService.selectList2'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
						setTimeout(function(){
							//20190918 2개 그리드에서 탭으로 변경되면서 시간에 따라 보여주는 탭 변경하는 것으로 변경
//							UniAppManager.app.onQueryButtonDown();
							var activeTabId = tab.getActiveTab().getId();
							if (activeTabId == 'srq400skrvGridTab') {
								tab.setActiveTab(1);
							} else {
								tab.setActiveTab(0);
							}
						}, 60000);
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
		}
	});



	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
			title		: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
				name		: 'OUT_DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('OUT_DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel		: '<t:message code="system.label.sales.date" default="일자"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_DATE',
				endFieldName	: 'TO_DATE',
				startDate		: UniDate.get('today'),
				endDate			: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('FR_DATE', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('TO_DATE', newValue);
					}
				}
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				}
			}
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
			name		: 'OUT_DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('OUT_DIV_CODE', newValue);
				}
			}
		}, {
			fieldLabel		: '<t:message code="system.label.sales.date" default="일자"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			startDate		: UniDate.get('today'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FR_DATE', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TO_DATE', newValue);
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('srq400skrvGrid1', {
//		title	: '완제품 납품',
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: true,
			useMultipleSorting	: true
		},
		features: [ 
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
			{ dataIndex: 'CUSTOM_CODE'	,width:120	, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'	,width:250},
			{ dataIndex: 'ORDER_NUM'	,width:150},
			{ dataIndex: 'ITEM_CODE'	,width:100	, hidden: true},
			{ dataIndex: 'ITEM_NAME'	,width:350},
			{ dataIndex: 'ORDER_Q'		,width:150},
			{ dataIndex: 'ISSUE_QTY'	,width:150},
			{ dataIndex: 'COMPLETE_YN'	,width:120	, align: 'center'},
			{ dataIndex: 'QUERY_TIME'	,width:100	, hidden: true}
		] 
	});

	var masterGrid2 = Unilite.createGrid('srq400skrvGrid2', {
//		title	: '임가공 자재 출고',
		store	: directMasterStore2, 
		layout	: 'fit',
		region	: 'east',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: true,
			useMultipleSorting	: true
		},
		features: [ 
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
			{ dataIndex: 'CUSTOM_CODE'	,width:120	, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'	,width:250},
			{ dataIndex: 'ORDER_NUM'	,width:150},
			{ dataIndex: 'ITEM_CODE'	,width:100	, hidden: true},
			{ dataIndex: 'ITEM_NAME'	,width:350},
			{ dataIndex: 'ALLOC_Q'		,width:150},
			{ dataIndex: 'OUTSTOCK_Q'	,width:150},
			{ dataIndex: 'COMPLETE_YN'	,width:120	, align: 'center'},
			{ dataIndex: 'QUERY_TIME'	,width:100	, hidden: true}
		] 
	});



	//20190918 한 화면에 2개 그리드 보이던 것을 탭으로 변경
	var tab = Unilite.createTabPanel('tabPanel', {
		activeTab	: 0,
		region		: 'center',
		items		: [{
			title	: '<t:message code="system.label.sales.finishedproductdelivery" default="완제품 납품"/>',
			xtype	: 'container',
			id		: 'srq400skrvGridTab',
			layout	: {
				type	: 'vbox',
				align	: 'stretch'
			},
			items	: [ masterGrid1 ]
		}, {
			title	: '<t:message code="system.label.sales.leavingprocessingmaterial" default="임가공 자재 출고"/>',
			xtype	: 'container',
			id		: 'srq400skrvGridTab2',
			layout	: {
				type	: 'vbox',
				align	: 'stretch'
			},
			items	: [ masterGrid2 ]
		} ],
		listeners : {
			tabChange : function(tabPanel, newCard, oldCard, eOpts) {
				var activeTabId = tabPanel.getActiveTab().getId();
				if (activeTabId == 'srq400skrvGridTab') {
					directMasterStore1.loadStoreRecords();
				} else {
					directMasterStore2.loadStoreRecords();
				}
			}
		}
	});



	Unilite.Main({
		id			: 'srq400skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				tab, panelResult
			]
		},
			panelSearch	
		],
		fnInitBinding : function() {
			panelSearch.setValue('OUT_DIV_CODE'	, UserInfo.divCode);
			panelSearch.setValue('FR_DATE'		, UniDate.get('today'));
			panelSearch.setValue('TO_DATE'		, UniDate.get('today'));

			panelResult.setValue('OUT_DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('FR_DATE'		, UniDate.get('today'));
			panelResult.setValue('TO_DATE'		, UniDate.get('today'));

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('OUT_DIV_CODE');
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()) {
				return false;
			}
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'srq400skrvGridTab'){
				directMasterStore1.loadStoreRecords();
			}else{
				directMasterStore2.loadStoreRecords();
			}
		},
		onResetButtonDown:function(){
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid1.getStore().loadData({});
			masterGrid2.getStore().loadData({});
			this.fnInitBinding();
		}
	});
};
</script>