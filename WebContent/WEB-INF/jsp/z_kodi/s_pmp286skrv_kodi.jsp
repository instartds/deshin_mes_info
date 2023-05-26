<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp286skrv_kodi" >
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmp286skrv_kodi"/>			<!-- 사업장 -->

</t:appConfig>

<script type="text/javascript" >

function appMain() {
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title		: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
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
			title		: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel		: '조회일자',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'PRODT_DATE_FR',
				endFieldName	: 'PRODT_DATE_TO',
				startDate: UniDate.get('startOfLastMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_DATE_TO',newValue);
					}
				}
			}]
		}]
	});


	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border:true,
		items	: [{
			fieldLabel		: '조회일자',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'PRODT_DATE_FR',
			endFieldName	: 'PRODT_DATE_TO',
			startDate: UniDate.get('startOfLastMonth'),
			endDate: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_DATE_TO',newValue);
				}
			}
		}]
	});


	/** Model1 정의 
	 * @type
	 */
	Unilite.defineModel('s_pmp286skrv_kodiModel1', {					//믹싱-제조이력
		fields: [
			{name: 'MONTH'				,text: '년월'				, type: 'string'},
			{name: 'PRODT_DT'			,text: '생산일자'			, type: 'uniDate'},
			{name: 'PRODT_CNT_ERP'		,text: 'ERP'			, type: 'uniQty'},
			{name: 'PRODT_CNT_MES'		,text: '제조이력'			, type: 'uniQty'},
			{name: 'PRODT_CNT_RATE'		,text: '입력률(%)'			, type: 'uniPercent'},
			{name: 'WORK_CNT_ERP'		,text: 'ERP'			, type: 'uniQty'},
			{name: 'WORK_CNT_MES'		,text: '제조이력'			, type: 'uniQty'},
			{name: 'WORK_CNT_RATE'		,text: '입력률(%)'			, type: 'uniPercent'},
			{name: 'WORK_Q_ERP'			,text: 'ERP'			, type: 'uniQty'},
			{name: 'WORK_Q_MES'			,text: '제조이력'			, type: 'uniQty'},
			{name: 'WORK_Q_RATE'		,text: '입력률(%)'			, type: 'uniPercent'}
		]
	});


	/** Model2 정의 
	 * @type
	 */
	Unilite.defineModel('s_pmp286skrv_kodiModel2', {					//타정-성형이력
		fields: [
			{name: 'MONTH'				,text: '년월'				, type: 'string'},
			{name: 'PRODT_DT'			,text: '생산일자'			, type: 'uniDate'},
			{name: 'PRODT_CNT_ERP'		,text: 'ERP'			, type: 'uniQty'},
			{name: 'PRODT_CNT_MES'		,text: '성형이력'			, type: 'uniQty'},
			{name: 'PRODT_CNT_RATE'		,text: '입력률(%)'			, type: 'uniPercent'},
			{name: 'WORK_CNT_ERP'		,text: 'ERP'			, type: 'uniQty'},
			{name: 'WORK_CNT_MES'		,text: '성형이력'			, type: 'uniQty'},
			{name: 'WORK_CNT_RATE'		,text: '입력률(%)'			, type: 'uniPercent'},
			{name: 'WORK_Q_ERP'			,text: 'ERP'			, type: 'uniQty'},
			{name: 'WORK_Q_MES'			,text: '성형이력'			, type: 'uniQty'},
			{name: 'WORK_Q_RATE'		,text: '입력률(%)'			, type: 'uniPercent'}
		]
	});


	/** Store1 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_pmp286skrv_kodiMasterStore1', {
		model	: 's_pmp286skrv_kodiModel1',
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
				read: 's_pmp286skrv_kodiService.selectList1'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		},
		groupField: 'MONTH'
	});


	/** Store2 정의(Service 정의)
	 * @type
	 */
	var directMasterStore2 = Unilite.createStore('s_pmp286skrv_kodiMasterStore2', {
		model	: 's_pmp286skrv_kodiModel2',
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
				read: 's_pmp286skrv_kodiService.selectList2'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		},
		groupField: 'MONTH'
	});


	/** Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('s_pmp286skrv_kodiGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		uniOpt	: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: false,
			filter				: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		
		selModel:'rowmodel',
		
		features: [
			{id: 'masterGridSubTotal1'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},			//소계 기능
			{id: 'masterGridTotal1'		, ftype: 'uniSummary'			, showSummaryRow: true}				//총계 기능
		],
		columns	: [
			{dataIndex: 'MONTH' 							, width:100, align:'center', locked: true,		//생산년월
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
				}
			},
			{dataIndex: 'PRODT_DT' 							, width:100, locked: true},						//생산일자
			{text: '생산품목수',
				columns:[
					{dataIndex: 'PRODT_CNT_ERP'				, width:90 , summaryType: 'sum'},				//생산품목수_ERP
					{dataIndex: 'PRODT_CNT_MES'				, width:90 , summaryType: 'sum'}				//생산품목수_제조이력
				]
			},
			{dataIndex: 'PRODT_CNT_RATE'					, width:100, 									//입력률
				summaryType:function(values) {
					var prodtCntErpSum =0;
					var prodtCntMesSum=0;
					
					Ext.each(values, function(value, index) {
						prodtCntErpSum = prodtCntErpSum + value.get('PRODT_CNT_ERP');
						prodtCntMesSum = prodtCntMesSum + value.get('PRODT_CNT_MES');
					});
					avgData = prodtCntMesSum / prodtCntErpSum * 100;
					return avgData;
				}
			},	
			{text: '실적등록건수',
				columns:[
					{dataIndex: 'WORK_CNT_ERP'				, width:90 , summaryType: 'sum'},				//실족등록건수_ERP
					{dataIndex: 'WORK_CNT_MES'				, width:90 , summaryType: 'sum'}				//실족등록건수_제조이력
				]
			},
			{dataIndex: 'WORK_CNT_RATE'						, width:100,									//입력률
				summaryType:function(values) {
					var workCntErpSum =0;
					var workCntMesSum=0;
					
					Ext.each(values, function(value, index) {
						workCntErpSum = workCntErpSum + value.get('WORK_CNT_ERP');
						workCntMesSum = workCntMesSum + value.get('WORK_CNT_MES');
					});
					avgData = workCntMesSum / workCntErpSum * 100;
					return avgData;
				}
			},
			{text: '생산량',
				columns:[
					{dataIndex: 'WORK_Q_ERP'				, width:100 , summaryType: 'sum'},				//생산량_ERP
					{dataIndex: 'WORK_Q_MES'				, width:100 , summaryType: 'sum'}				//생산량_제조이력
				]
			},
			{dataIndex: 'WORK_Q_RATE'						, width:100,									//입력률
				summaryType:function(values) {
					var workQErpSum =0;
					var workQMesSum=0;
					
					Ext.each(values, function(value, index) {
						workQErpSum = workQErpSum + value.get('WORK_Q_ERP');
						workQMesSum = workQMesSum + value.get('WORK_Q_MES');
					});
					avgData = workQMesSum / workQErpSum * 100;
					return avgData;
				}
			}
		]
	});


	/** Grid2 정의(Grid Panel)
	 * @type
	 */
	var masterGrid2 = Unilite.createGrid('s_pmp286skrv_kodiGrid2', {
		store	: directMasterStore2,
		layout	: 'fit',
		uniOpt	: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: true,
			expandLastColumn	: false,
			filter				: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		
		selModel:'rowmodel',
		
		features: [
			{id: 'masterGridSubTotal1'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},			//소계 기능
			{id: 'masterGridTotal1'		, ftype: 'uniSummary'			, showSummaryRow: true}				//총계 기능
		],
		columns	: [
			{dataIndex: 'MONTH' 							, width:100, align:'center', locked: true,		//생산년월
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
				}
			},
			{dataIndex: 'PRODT_DT' 							, width:100, locked: true},						//생산일자
			{text: '생산품목수',
				columns:[
					{dataIndex: 'PRODT_CNT_ERP'				, width:90 , summaryType: 'sum'},				//생산품목수_ERP
					{dataIndex: 'PRODT_CNT_MES'				, width:90 , summaryType: 'sum'}				//생산품목수_성형이력
				]
			},
			{dataIndex: 'PRODT_CNT_RATE'					, width:100,									//입력률
				summaryType:function(values) {
					var prodtCntErpSum =0;
					var prodtCntMesSum=0;
					
					Ext.each(values, function(value, index) {
						prodtCntErpSum = prodtCntErpSum + value.get('PRODT_CNT_ERP');
						prodtCntMesSum = prodtCntMesSum + value.get('PRODT_CNT_MES');
					});
					avgData = prodtCntMesSum / prodtCntErpSum * 100;
					return avgData;
				}
			
			},
			{text: '실적등록건수',
				columns:[
					{dataIndex: 'WORK_CNT_ERP'				, width:90 , summaryType: 'sum'},				//실족등록건수_ERP
					{dataIndex: 'WORK_CNT_MES'				, width:90 , summaryType: 'sum'}				//실족등록건수_성형이력
				]
			},
			{dataIndex: 'WORK_CNT_RATE'						, width:100,									//입력률
				summaryType:function(values) {
					var workCntErpSum =0;
					var workCntMesSum=0;
					
					Ext.each(values, function(value, index) {
						workCntErpSum = workCntErpSum + value.get('WORK_CNT_ERP');
						workCntMesSum = workCntMesSum + value.get('WORK_CNT_MES');
					});
					avgData = workCntMesSum / workCntErpSum * 100;
					return avgData;
				}
			},
			{text: '생산량',
				columns:[
					{dataIndex: 'WORK_Q_ERP'				, width:100 , summaryType: 'sum'},				//생산량_ERP
					{dataIndex: 'WORK_Q_MES'				, width:100 , summaryType: 'sum'}				//생산량_성형이력
				]
			},
			{dataIndex: 'WORK_Q_RATE'						, width:100,									//입력률
				summaryType:function(values) {
					var workQErpSum =0;
					var workQMesSum=0;
					
					Ext.each(values, function(value, index) {
						workQErpSum = workQErpSum + value.get('WORK_Q_ERP');
						workQMesSum = workQMesSum + value.get('WORK_Q_MES');
					});
					avgData = workQMesSum / workQErpSum * 100;
					return avgData;
				}
			}
		]
	});



	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab: 0,
		region: 'center',
		items: [{
			title: '믹싱',
			xtype:'container',
			layout:{type:'vbox', align:'stretch'},
			items:[masterGrid1],
			id: 'tab1'
		},{
			title: '타정',
			xtype:'container',
			layout:{type:'vbox', align:'stretch'},
			items:[masterGrid2],
			id: 'tab2' 
		}],
		listeners : {
			beforetabchange : function ( tabPanel, newCard, oldCard, eOpts )  {
			},
			tabChange : function ( tabPanel, newCard, oldCard, eOpts )  {
				var newTabId = newCard.getId();
				if(newTabId == 'tab1'){
					directMasterStore1.loadStoreRecords();
				}else if(newTabId == 'tab2'){
					directMasterStore2.loadStoreRecords();
				}
			}
		}
	});



	Unilite.Main({
		id			: 's_pmp286skrv_kodiApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, tab
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('PRODT_DATE_FR'	, UniDate.get('startOfLastMonth'));
			panelSearch.setValue('PRODT_DATE_TO'	, UniDate.get('today'));
			panelResult.setValue('PRODT_DATE_FR'	, UniDate.get('startOfLastMonth'));
			panelResult.setValue('PRODT_DATE_TO'	, UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function() {							//조회버튼
			if(!panelSearch.getInvalidMessage()) return;		//필수체크
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'tab1') {
				directMasterStore1.loadStoreRecords();
			}else if(activeTabId == 'tab2') {
				directMasterStore2.loadStoreRecords();
			}
			
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {							//신규버튼
			panelResult.clearForm();
			masterGrid1.getStore().loadData({})
			panelSearch.clearForm();
			masterGrid2.getStore().loadData({});
			this.fnInitBinding();
		}
	});
};
</script>