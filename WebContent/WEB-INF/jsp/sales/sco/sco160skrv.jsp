<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sco160skrv">
	<t:ExtComboStore comboType="BOR120"  pgmId="sco160skrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B034"/>			<!-- 결제조건 -->
	<t:ExtComboStore comboType="AU" comboCode="B038"/>			<!-- 결제방법 -->
</t:appConfig>

<script type="text/javascript" >
function appMain() {

	/**
	 * 검색조건 (Search Panel)
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
		items		: [{
			title	: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId	: 'search_panel1',
			layout	: {type: 'uniTable', columns: 1},
			items	: [{
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
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
				fieldLabel		: '<t:message code="system.label.sales.salesbasedate" default="매출기준일"/>',
				xtype			: 'uniMonthRangefield',
				startFieldName	: 'FR_SALE_YYMM',
				endFieldName	: 'TO_SALE_YYMM',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('FR_SALE_YYMM', newValue);
//						if(Ext.isDate(newValue)) {
//							panelSearch.setValue('TO_SALE_YYMM', UniDate.getDbDateStr(UniDate.add(newValue, {months:12})));
//							panelResult.setValue('TO_SALE_YYMM', UniDate.getDbDateStr(UniDate.add(newValue, {months:12})));
//						}
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('TO_SALE_YYMM', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
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
					}
				}
			})]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
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
			fieldLabel		: '<t:message code="system.label.sales.salesbasedate" default="매출기준일"/>',
			xtype			: 'uniMonthRangefield',
			startFieldName	: 'FR_SALE_YYMM',
			endFieldName	: 'TO_SALE_YYMM',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FR_SALE_YYMM', newValue);
//					if(Ext.isDate(newValue)) {
//						panelSearch.setValue('TO_SALE_YYMM', UniDate.getDbDateStr(UniDate.add(newValue, {months:12})));
//						panelResult.setValue('TO_SALE_YYMM', UniDate.getDbDateStr(UniDate.add(newValue, {months:12})));
//					}
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TO_SALE_YYMM', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
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
				}
			}
		})]	
	});



	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('sco160skrvModel1', {
		fields: [
			{name: 'BUSI_PRSN'				, text:'<t:message code="system.label.sales.charger" default="담당자"/>'								, type:'string'},
			{name: 'CUSTOM_CODE'			, text:'<t:message code="system.label.sales.salesplacecode" default="매출처코드"/>'						, type:'string'},
			{name: 'SALE_CUSTOM_NAME'		, text:'<t:message code="system.label.sales.salesplace" default="매출처"/>'							, type:'string'},
			{name: 'SET_METH'				, text:'<t:message code="system.label.sales.receiptsetmeth" default="결제방법"/>'						, type:'string'	, comboType: 'AU', comboCode:'B038'},
			{name: 'DAY'					, text:'<t:message code="system.label.sales.depositdateafterbillissuance" default="계산서 발행 후 입금일"/>'	, type:'string'},
			{name: 'RECEIPT_DAY'			, text:'<t:message code="system.label.sales.cashbilldate" default="현금, 어음결제일"/>'					, type:'string'	, comboType: 'AU', comboCode:'B034'},
			{name: 'TRANSFER_REMAIN_AMT'	, text:'<t:message code="system.label.sales.balancecarriedforward" default="전기이월잔액"/>'				, type:'uniPrice'},
			{name: 'DR_AMT_01'				, text:'DR_AMT_01'		, type:'uniPrice'	, hidden: true},
			{name: 'DR_AMT_02'				, text:'DR_AMT_02'		, type:'uniPrice'	, hidden: true},
			{name: 'DR_AMT_03'				, text:'DR_AMT_03'		, type:'uniPrice'	, hidden: true},
			{name: 'DR_AMT_04'				, text:'DR_AMT_04'		, type:'uniPrice'	, hidden: true},
			{name: 'DR_AMT_05'				, text:'DR_AMT_05'		, type:'uniPrice'	, hidden: true},
			{name: 'DR_AMT_06'				, text:'DR_AMT_06'		, type:'uniPrice'	, hidden: true},
			{name: 'DR_AMT_07'				, text:'DR_AMT_07'		, type:'uniPrice'	, hidden: true},
			{name: 'DR_AMT_08'				, text:'DR_AMT_08'		, type:'uniPrice'	, hidden: true},
			{name: 'DR_AMT_09'				, text:'DR_AMT_09'		, type:'uniPrice'	, hidden: true},
			{name: 'DR_AMT_10'				, text:'DR_AMT_10'		, type:'uniPrice'	, hidden: true},
			{name: 'DR_AMT_11'				, text:'DR_AMT_11'		, type:'uniPrice'	, hidden: true},
			{name: 'DR_AMT_12'				, text:'DR_AMT_12'		, type:'uniPrice'	, hidden: true},
			{name: 'TOTAL_BOND'				, text:'<t:message code="system.label.sales.totalbonds" default="채권총계"/>'							, type:'uniPrice'},
			{name: 'CR_AMT_01'				, text:'CR_AMT_01'		, type:'uniPrice'	, hidden: true},
			{name: 'CR_AMT_02'				, text:'CR_AMT_02'		, type:'uniPrice'	, hidden: true},
			{name: 'CR_AMT_03'				, text:'CR_AMT_03'		, type:'uniPrice'	, hidden: true},
			{name: 'CR_AMT_04'				, text:'CR_AMT_04'		, type:'uniPrice'	, hidden: true},
			{name: 'CR_AMT_05'				, text:'CR_AMT_05'		, type:'uniPrice'	, hidden: true},
			{name: 'CR_AMT_06'				, text:'CR_AMT_06'		, type:'uniPrice'	, hidden: true},
			{name: 'CR_AMT_07'				, text:'CR_AMT_07'		, type:'uniPrice'	, hidden: true},
			{name: 'CR_AMT_08'				, text:'CR_AMT_08'		, type:'uniPrice'	, hidden: true},
			{name: 'CR_AMT_09'				, text:'CR_AMT_09'		, type:'uniPrice'	, hidden: true},
			{name: 'CR_AMT_10'				, text:'CR_AMT_10'		, type:'uniPrice'	, hidden: true},
			{name: 'CR_AMT_11'				, text:'CR_AMT_11'		, type:'uniPrice'	, hidden: true},
			{name: 'CR_AMT_12'				, text:'CR_AMT_12'		, type:'uniPrice'	, hidden: true},
			{name: 'TOTAL_COLLECT'			, text:'<t:message code="system.label.sales.totalcollectionamount" default="수금총계"/>'				, type:'uniPrice'},
			{name: 'UNCOLLECT'				, text:'<t:message code="system.label.sales.receivables" default="미수금"/>'							, type:'uniPrice'},
			{name: 'COLLECT_DAY'			, text:'<t:message code="system.label.sales.collectionschdate" default="수금예정일"/>'					, type:'int'}
		]
	});	

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('sco160skrvMasterStore1',{
		model	: 'sco160skrvModel1',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sco160skrvService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
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
		},
		/* groupField: 'BUSI_PRSN' */
	});

	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('sco160skrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer	: true,
			copiedRow		: false
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [
			{dataIndex: 'BUSI_PRSN'				, width: 80,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'CUSTOM_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'SALE_CUSTOM_NAME'		, width: 150},
			{dataIndex: 'SET_METH'				, width: 80},
			{dataIndex: 'DAY'					, width: 140},
			{dataIndex: 'RECEIPT_DAY'			, width: 120},
			{dataIndex: 'TRANSFER_REMAIN_AMT'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'DR_AMT_01'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'DR_AMT_02'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'DR_AMT_03'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'DR_AMT_04'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'DR_AMT_05'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'DR_AMT_06'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'DR_AMT_07'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'DR_AMT_08'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'DR_AMT_09'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'DR_AMT_10'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'DR_AMT_11'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'DR_AMT_12'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'TOTAL_BOND'			, width: 100	, summaryType: 'sum'},
			{dataIndex: 'CR_AMT_01'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'CR_AMT_02'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'CR_AMT_03'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'CR_AMT_04'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'CR_AMT_05'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'CR_AMT_06'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'CR_AMT_07'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'CR_AMT_08'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'CR_AMT_09'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'CR_AMT_10'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'CR_AMT_11'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'CR_AMT_12'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'TOTAL_COLLECT'			, width: 100	, summaryType: 'sum'},
			{dataIndex: 'UNCOLLECT'				, width: 100	, summaryType: 'sum'},
			{dataIndex: 'COLLECT_DAY'			, width: 100}
		]
	});



	Unilite.Main({
		id			: 'sco160skrvApp',
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
		fnInitBinding : function() {
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
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('TO_SALE_YYMM', UniDate.get('today'));
			panelSearch.setValue('FR_SALE_YYMM', UniDate.get('startOfMonth', panelSearch.getValue('TO_SALE_YYMM')));

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('TO_SALE_YYMM', UniDate.get('today'));
			panelResult.setValue('FR_SALE_YYMM', UniDate.get('startOfMonth', panelSearch.getValue('TO_SALE_YYMM')));

			fnSetColumnName();
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()) {
				return false;
			}
			var param = panelSearch.getValues();
			sco160skrvService.getColumn(param, function(provider, response){
				if(!Ext.isEmpty(provider)) {
					fnSetColumnName(provider);
					masterGrid.getStore().loadStoreRecords();
				}
			});
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		}
	});



	//그리드 컬럼명 set / hidden처리
	function fnSetColumnName(provider) {
		if(Ext.isEmpty(provider)) {		//초기화
			for (var i = 1; i <= 12; i ++) {
				var colSeq		= (i < 10) ? '0'+ i : i;
				var colName1	= 'DR_AMT_' + colSeq;
				var colName2	= 'CR_AMT_' + colSeq;
				masterGrid.getColumn(colName1).setHidden(true);
				masterGrid.getColumn(colName2).setHidden(true);
			}
		} else {
			for (var i=1; i <= provider.length; i ++) {
				var colSeq		= (i < 10) ? '0'+ i : i;
				var colName1	= 'DR_AMT_' + colSeq;
				var colName2	= 'CR_AMT_' + colSeq;
				masterGrid.getColumn(colName1).setText(provider[i-1].CAL_DATE);
				masterGrid.getColumn(colName2).setText(provider[i-1].CAL_DATE);
				masterGrid.getColumn(colName1).setHidden(false);
				masterGrid.getColumn(colName2).setHidden(false);
			}
			if(provider.length < 12) {
				for (var i = provider.length + 1; i <= 12; i ++) {
					var colSeq		= (i < 10) ? '0'+ i : i;
					var colName1	= 'DR_AMT_' + colSeq;
					var colName2	= 'CR_AMT_' + colSeq;
					masterGrid.getColumn(colName1).setHidden(true);
					masterGrid.getColumn(colName2).setHidden(true);
				}
			}
		}
	}
};
</script>