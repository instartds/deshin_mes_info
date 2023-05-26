<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ssa700skrv_wm">
	<t:ExtComboStore comboType="BOR120" pgmId="s_ssa700skrv_wm"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055"/>				<!--고객분류-->
</t:appConfig>
<script type="text/javascript" >


function appMain() {
	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
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
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '기준일',
				name		: 'BASIS_DATE',
				xtype		: 'uniDatefield',
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('BASIS_DATE', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 3
					//20210521 추가
					, tableAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width: '100%'}
					, tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ align : 'right'}
		},
		padding		: '1 1 1 1',
		border		: true,
		items		: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			tdAttrs		: {width: 250},
			allowBlank	: false,
			value		: UserInfo.divCode,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '기준일',
			name		: 'BASIS_DATE',
			xtype		: 'uniDatefield',
			tdAttrs		: {width: 250},
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('BASIS_DATE', newValue);
				}
			}
		},{	//20210521 추가
			xtype		: 'container',
			layout		: {type: 'uniTable', columns: 2},
			padding		: '0 20 4 0',
			items		: [{
				text	: '재무제표',
				xtype	: 'button',
				tdAttrs	: {align : 'right'},
				width	: 100,
				handler	: function() {
					if(!panelResult.getInvalidMessage()) return;
					var params = {
						'PGM_ID'	: PGM_ID
					}
					var rec1 = {data : {prgID : 'agc130skr', 'text':''}};
					parent.openTab(rec1, '/accnt/agc130skr.do', params);
				}
			},{
				text	: '일계표',
				xtype	: 'button',
				tdAttrs	: {align : 'right'},
				width	: 100,
				handler	: function() {
					if(!panelResult.getInvalidMessage()) return;
					var params = {
						'PGM_ID'	: PGM_ID,
						'DIV_CODE'	: panelSearch.getValue('DIV_CODE'),
						'BASIS_DATE': panelSearch.getValue('BASIS_DATE')
					}
					var rec1 = {data : {prgID : 'agb120skr', 'text':''}};
					parent.openTab(rec1, '/accnt/agb120skr.do', params);
				}
			}]
		}],
		listeners: {
			uniOnChange:function( basicForm, dirty, eOpts ) {
			}
		}
	});

	var stockPanel = Unilite.createForm('stockForm',{
		region		: 'south',
		layout		: {type : 'uniTable', columns : 3},
		padding		: '1 1 1 1',
		border		: true,
		disabled	: false,
		items		: [{
			fieldLabel	: '재고자산',
			name		: 'STOCK_AMT',
			xtype		: 'uniNumberfield',
			type		: 'uniFC',
			readOnly	: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		}],
		listeners: {
			uniOnChange:function( basicForm, dirty, eOpts ) {
			}
		}
	});


	Unilite.defineModel('s_ssa700skrv_wmModel', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'		, text: 'DIV_CODE'		, type: 'string'},
			{name: 'AGENT_TYPE'		, text: '<t:message code="system.label.base.classfication" default="구분"/>'		, type: 'string', comboType:'AU', comboCode: 'B055'},
			{name: 'SALE_AMT'		, text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'	, type: 'uniFC'},
			{name: 'AMT_ECEPT_FEE'	, text: '금액(수수료제외)'																, type: 'uniFC'},		//20210520 추가
			{name: 'SALE_COST'		, text: '<t:message code="system.label.sales.salescostII" default="매출원가"/>'		, type: 'uniFC'},
			{name: 'SALE_PROFIT'	, text: '<t:message code="system.label.sales.salesprofit" default="매출이익"/>'		, type: 'uniFC'},
			{name: 'PROFIT_RATE'	, text: '<t:message code="system.label.sales.profitrate" default="이익율"/>(%)'	, type: 'uniPercent'},
			{name: 'COLLECT_FOR_AMT', text: '<t:message code="system.label.sales.collectionamount" default="수금액"/>'	, type: 'uniFC'}
		]
	});

	var detailStore = Unilite.createStore('s_ssa700skrv_wmDetailStore',{
		model	: 's_ssa700skrv_wmModel',
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_ssa700skrv_wmService.selectList'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부
			allDeletable: false,	// 전체 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param = panelResult.getValues();
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
		}
	});

	var detailGrid = Unilite.createGrid('s_ssa700skrv_wmGrid', {
		title	: '[매 출]',
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		flex	: 6,
		split	: true,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true
		},
		//20210521 추가
		tbar: [{
			text	: '일일업무',
			width	: 100,
			handler	: function() {
				if(!panelResult.getInvalidMessage()) return;
				var params = {
					'PGM_ID'	: PGM_ID,
					'DIV_CODE'	: panelSearch.getValue('DIV_CODE'),
					'BASIS_DATE': panelSearch.getValue('BASIS_DATE')
				}
				var rec1 = {data : {prgID : 'ssa625skrv', 'text':''}};
				parent.openTab(rec1, '/sales/ssa625skrv.do', params);
			}
		}],
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',showSummaryRow: false},
					{id : 'masterGridTotal',	ftype: 'uniSummary',		showSummaryRow: true}],
		columns	: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'AGENT_TYPE'		, width: 180, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.totalamount" default="합계"/>');
			}},
			{dataIndex: 'SALE_AMT'			, flex: 100, summaryType: 'sum'},
			{dataIndex: 'AMT_ECEPT_FEE'		, flex: 100, summaryType: 'sum'},		//20210520 추가
			{dataIndex: 'SALE_COST'			, flex: 100, summaryType: 'sum'},
			{dataIndex: 'SALE_PROFIT'		, flex: 100, summaryType: 'sum'},
			{dataIndex: 'PROFIT_RATE'		, flex: 100},
			{dataIndex: 'COLLECT_FOR_AMT'	, flex: 100, summaryType: 'sum'}
		],
		listeners: {
		}
	});



	Unilite.defineModel('s_ssa700skrv_wmModel2', {
		fields: [
			{name: 'COMP_CODE'	, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'	, text: 'DIV_CODE'		, type: 'string'},
			{name: 'AGENT_TYPE'	, text: '<t:message code="system.label.base.classfication" default="구분"/>', type: 'string', comboType:'AU', comboCode:'B055'},
			{name: 'AMT_I'		, text: '매입금액'	, type: 'uniFC'},
			{name: 'PAY_AMT'	, text: '결제금액'	, type: 'uniFC'}
		]
	});

	var detailStore2 = Unilite.createStore('s_ssa700skrv_wmDetailStore2',{
		model	: 's_ssa700skrv_wmModel2',
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_ssa700skrv_wmService.selectList2'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param = panelResult.getValues();
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
		}
	});

	var detailGrid2 = Unilite.createGrid('s_ssa700skrv_wmGrid2', {
		title	: '[매 입]',
		store	: detailStore2,
		layout	: 'fit',
		region	: 'east',
		flex	: 4,
		split	: true,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true
		},
		//20210521 추가
		tbar: [{
			text	: '외상매입현황',
			width	: 100,
			handler	: function() {
				if(!panelResult.getInvalidMessage()) return;
				var params = {
					'PGM_ID'	: PGM_ID,
					'DIV_CODE'	: panelSearch.getValue('DIV_CODE'),
					'BASIS_DATE': panelSearch.getValue('BASIS_DATE')
				}
				var rec1 = {data : {prgID : 's_map110skrv_wm', 'text':''}};
				parent.openTab(rec1, '/z_wm/s_map110skrv_wm.do', params);
			}
		}],
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',showSummaryRow: false},
					{id : 'masterGridTotal',	ftype: 'uniSummary',		showSummaryRow: true}],
		columns	: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'AGENT_TYPE'		, width: 180, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.totalamount" default="합계"/>');
			}},
			{dataIndex: 'AMT_I'				, flex: 100, summaryType: 'sum'},
			{dataIndex: 'PAY_AMT'			, flex: 100, summaryType: 'sum'}
		],
		listeners: {
		}
	});



	Unilite.defineModel('s_ssa700skrv_wmModel3', {
		fields: [
			{name: 'COMP_CODE'	, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'	, text: 'DIV_CODE'		, type: 'string'},
			{name: 'BAL_TYPE'	, text: '<t:message code="system.label.base.classfication" default="구분"/>'	, type: 'string'},
			{name: 'CARRY_AMT'	, text:'<t:message code="" default="이월금액"/>'	, type: 'uniFC'},
			{name: 'OUT_AMT'	, text:'<t:message code="system.label.sales.depositamount" default="입금액"/>'	, type: 'uniFC'},
			{name: 'IN_AMT'		, text:'<t:message code="system.label.sales.payamount" default="출금액"/>'		, type: 'uniFC'},
			{name: 'IN_JAN_AMT'	, text:'<t:message code="system.label.sales.balanceamount2" default="잔액"/>'	, type: 'uniFC'}
		]
	});

	var detailStore3 = Unilite.createStore('s_ssa700skrv_wmDetailStore3',{
		model	: 's_ssa700skrv_wmModel3',
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_ssa700skrv_wmService.selectList3'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param = panelResult.getValues();
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
		}
	});

	var detailGrid3 = Unilite.createGrid('s_ssa700skrv_wmGrid3', {
		title	: '[현 금]',
		store	: detailStore3,
		layout	: 'fit',
		region	: 'center',
		flex	: 6,
		split	: true,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true
		},
		//20210521 추가
		tbar: [{
			text	: '현금출납장',
			width	: 100,
			handler	: function() {
				if(!panelResult.getInvalidMessage()) return;
				var params = {
					'PGM_ID'	: PGM_ID,
					'DIV_CODE'	: panelSearch.getValue('DIV_CODE'),
					'BASIS_DATE': panelSearch.getValue('BASIS_DATE')
				}
				var rec1 = {data : {prgID : 'agb130skr', 'text':''}};
				parent.openTab(rec1, '/accnt/agb130skr.do', params);
			}
		},{
			text	: '계좌잔액조회',
			width	: 100,
			handler	: function() {
				if(!panelResult.getInvalidMessage()) return;
				var params = {
					'PGM_ID'	: PGM_ID,
					'DIV_CODE'	: panelSearch.getValue('DIV_CODE'),
					'BASIS_DATE': panelSearch.getValue('BASIS_DATE')
				}
				var rec1 = {data : {prgID : 'afs520skr', 'text':''}};
				parent.openTab(rec1, '/accnt/afs520skr.do', params);
			}
		}],
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',showSummaryRow: false},
					{id : 'masterGridTotal',	ftype: 'uniSummary',		showSummaryRow: false}],
		columns	: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'BAL_TYPE'			, width: 180,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.totalamount" default="합계"/>');
			}},
			{dataIndex: 'CARRY_AMT'			, flex: 100, summaryType: 'sum'},
			{dataIndex: 'OUT_AMT'			, flex: 100, summaryType: 'sum'},
			{dataIndex: 'IN_AMT'			, flex: 100, summaryType: 'sum'},
			{dataIndex: 'IN_JAN_AMT'		, flex: 100, summaryType: 'sum'}
		],
		listeners: {
		}
	});



	Unilite.defineModel('s_ssa700skrv_wmModel4', {
		fields: [
			{name: 'COMP_CODE'	, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'	, text: 'DIV_CODE'		, type: 'string'},
			{name: 'BAL_TYPE'	, text: '<t:message code="system.label.base.classfication" default="구분"/>'	, type: 'string'},
			{name: 'OUT_AMT'	, text:'<t:message code="" default="금액"/>'	, type: 'uniFC'}
		]
	});

	var detailStore4 = Unilite.createStore('s_ssa700skrv_wmDetailStore4',{
		model	: 's_ssa700skrv_wmModel4',
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_ssa700skrv_wmService.selectList4'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param = panelResult.getValues();
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
		}
	});

	var detailGrid4 = Unilite.createGrid('s_ssa700skrv_wmGrid4', {
		title	: '[채권/채무]',
		store	: detailStore4,
		layout	: 'fit',
		region	: 'east',
		flex	: 4,
		split	: true,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true
		},
		//20210521 추가
		tbar: [{
			text	: '채권채무현황',
			width	: 100,
			handler	: function() {
				if(!panelResult.getInvalidMessage()) return;
				var params = {
					'PGM_ID'	: PGM_ID,
					'DIV_CODE'	: panelSearch.getValue('DIV_CODE'),
					'BASIS_DATE': panelSearch.getValue('BASIS_DATE')
				}
				var rec1 = {data : {prgID : 'ssa630skrv', 'text':''}};
				parent.openTab(rec1, '/sales/ssa630skrv.do', params);
			}
		}],
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',showSummaryRow: false},
					{id : 'masterGridTotal',	ftype: 'uniSummary',		showSummaryRow: false}],
		columns	: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'BAL_TYPE'			, width: 180,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.totalamount" default="합계"/>');
			}},
			{dataIndex: 'OUT_AMT'			, flex: 100, summaryType: 'sum'}
		],
		listeners: {
		}
	});



	Unilite.defineModel('s_ssa700skrv_wmModel5', {
		fields: [
			{name: 'COMP_CODE'	, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'	, text: 'DIV_CODE'		, type: 'string'},
			{name: 'STOCK_AMT'	, text: '현재고금액'			, type: 'uniFC'}
		]
	});

	var detailStore5 = Unilite.createStore('s_ssa700skrv_wmDetailStore5',{
		model	: 's_ssa700skrv_wmModel5',
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_ssa700skrv_wmService.selectList5'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param = panelResult.getValues();
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
				if(records.length == 1) {
					stockPanel.setValue('STOCK_AMT', records[0].get('STOCK_AMT'));
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



	var gridPanel1 = Ext.create('Ext.panel.Panel', {
		region	: 'center',
		layout	: {
			type	: 'hbox',
			layout	: 'border',
			align	: 'stretch'
		},
		flex	: 1,
		items	: [
			detailGrid, detailGrid2
		]
	});

	var gridPanel2 = Ext.create('Ext.panel.Panel', {
		region	: 'south',
		layout	: {
			type	: 'hbox',
			layout	: 'border',
			align	: 'stretch'
		},
		flex	: 1,
		items	: [
			detailGrid3, detailGrid4
		]
	});



	Unilite.Main({
		id			: 's_ssa700skrv_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, gridPanel1, gridPanel2, stockPanel
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
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('BASIS_DATE'	, new Date());

			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('BASIS_DATE'	, new Date());

			//초기화 시 사업장으로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function () {
			if(!panelResult.getInvalidMessage()) return;
			detailStore.loadStoreRecords();
			detailStore2.loadStoreRecords();
			detailStore3.loadStoreRecords();
			detailStore4.loadStoreRecords();
			detailStore5.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			detailGrid.getStore().loadData({});
			detailGrid2.getStore().loadData({});
			detailGrid3.getStore().loadData({});
			detailGrid4.getStore().loadData({});
			this.fnInitBinding();
		}
	});
};
</script>