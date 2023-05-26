<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sco150skrv">
	<t:ExtComboStore comboType="BOR120"  pgmId="sco150skrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B015"/>			<!-- 구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />			<!-- 수금담당 -->
</t:appConfig>

<script type="text/javascript" >
function appMain() {
	var isLoad = false;

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
				fieldLabel		: '<t:message code="system.label.sales.slipdate" default="전표일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_DATE',
				endFieldName	: 'TO_DATE',
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
			}),{
				fieldLabel	: '<t:message code="system.label.sales.classfication" default="구분"/>',
				name		: 'GUBUN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B015',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('GUBUN', newValue);
					}
				}
			}]
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
			fieldLabel		: '<t:message code="system.label.sales.slipdate" default="전표일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
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
		}),{
			fieldLabel	: '<t:message code="system.label.sales.classfication" default="구분"/>',
			name		: 'GUBUN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B015',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('GUBUN', newValue);
				}
			}
		}]	
	});



	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('sco150skrvModel1', {
		fields: [
			{name: 'BUSI_PRSN'			, text:'<t:message code="system.label.sales.charger" default="담당자"/>'			, type:'string'},
			{name: 'CUSTOM_CODE'		, text:'<t:message code="system.label.sales.salesplacecode" default="매출처코드"/>'	, type:'string'},
			{name: 'CUSTOM_NAME'		, text:'<t:message code="system.label.sales.salesplace" default="매출처"/>'		, type:'string'},
			{name: 'IWAL_OUT_AMT_I'		, text:'<t:message code="system.label.sales.carryoveramount" default="이월금액"/>'	, type:'uniPrice'},
			{name: 'OUT_DR_AMT_I'		, text:'<t:message code="system.label.sales.salesamount" default="매출액"/>'		, type:'uniPrice'},
			{name: 'OUT_CR_AMT_I'		, text:'<t:message code="system.label.sales.depositamount" default="입금액"/>'		, type:'uniPrice'},
			{name: 'OUT_JAN_AMT_I'		, text:'<t:message code="system.label.sales.balanceamount2" default="잔액"/>'		, type:'uniPrice'},
			{name: 'IWAL_IN_AMT_I'		, text:'<t:message code="system.label.sales.carryoveramount" default="이월금액"/>'	, type:'uniPrice'},
			{name: 'IN_CR_AMT_I'		, text:'<t:message code="system.label.sales.pruchaseamount" default="매입액"/>'	, type:'uniPrice'},
			{name: 'IN_DR_AMT_I'		, text:'<t:message code="system.label.sales.payamount" default="출금액"/>'			, type:'uniPrice'},
			{name: 'IN_JAN_AMT_I'		, text:'<t:message code="system.label.sales.balanceamount2" default="잔액"/>'		, type:'uniPrice'}
		]
	});	

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('sco150skrvMasterStore1',{
		model	: 'sco150skrvModel1',
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
				read: 'sco150skrvService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		/* groupField: 'BUSI_PRSN' */
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('sco150skrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer	: true,
			copiedRow		: false
		},
		selModel: 'rowmodel',
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns	: [
			{dataIndex: 'BUSI_PRSN'			, width: 80	, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'CUSTOM_NAME'		, width: 150},
			{dataIndex: 'IWAL_OUT_AMT_I'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'OUT_DR_AMT_I'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'OUT_CR_AMT_I'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'OUT_JAN_AMT_I'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'IWAL_IN_AMT_I'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'IN_CR_AMT_I'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'IN_DR_AMT_I'		, width: 100	, summaryType: 'sum'},
			{dataIndex: 'IN_JAN_AMT_I'		, width: 100	, summaryType: 'sum'}
		],
		listeners: {
			select: function(grid, selected, index, rowIndex, eOpts ){
				if(!Ext.isEmpty(selected)) {
					masterGrid2.getStore().loadStoreRecords();
				} else {
					masterGrid2.getStore().loadData({});
				}
			}
		}
	});



	/** Model2 정의 
	 * @type 
	 */
	Unilite.defineModel('sco150skrvModel12', {
		fields: [
			{name: 'GUBUN'		, text:'<t:message code="system.label.sales.classfication" default="구분"/>'		, type:'string'},
			{name: 'GUBUN1'		, text:'<t:message code="system.label.sales.classfication" default="구분"/>1'		, type:'string'},
			{name: 'AC_DATE'	, text:'<t:message code="system.label.sales.slipdate" default="전표일"/>'			, type:'uniDate'},
			{name: 'SLIP_NUM'	, text:'<t:message code="system.label.sales.number" default="번호"/>'				, type:'string'},
			{name: 'SLIP_SEQ'	, text:'<t:message code="system.label.sales.seq" default="순번"/>'				, type:'string'},
			{name: 'REMARK'		, text:'<t:message code="system.label.sales.remark" default="적요"/>'				, type:'string'},
			{name: 'DR_AMT_I'	, text:'<t:message code="system.label.sales.debitamount" default="차변금액"/>'		, type:'uniPrice'},
			{name: 'CR_AMT_I'	, text:'<t:message code="system.label.sales.creditamount3" default="대변금액"/>'	, type:'uniPrice'},
			{name: 'JAN_AMT_I'	, text:'<t:message code="system.label.sales.balanceamount2" default="잔액"/>'		, type:'uniPrice'},
			{name: 'EX_NUM'		, text:'EX_NUM'		, type:'string'},
			{name: 'JAN_DIVI'	, text:'JAN_DIVI'	, type:'string'}
		]
	});	

	/** Store2 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore2 = Unilite.createStore('sco150skrvMasterStore2',{
		model	: 'sco150skrvModel12',
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
				read: 'sco150skrvService.selectList2'
			}
		},
		loadStoreRecords : function() {
			var selectedMaster	= masterGrid.getSelectedRecord();
			if(Ext.isEmpty(selectedMaster)) {
				Unilite.messageBox('<t:message code="system.message.sales.message061" default="선택된 데이터가 없습니다."/>');
				return false;
			} else {
				var param			= Ext.getCmp('searchForm').getValues();
				param.ACCNT_CODE	= masterGrid2.down('#ACCNT_CODE').getValue();
				param.CUSTOM_CODE	= selectedMaster.get('CUSTOM_CODE');
				param.CUSTOM_NAME	= selectedMaster.get('CUSTOM_NAME');
				isLoad = true;
			}
			this.load({
				params: param
			});
		}/*,
		groupField: 'AC_DATE'*/
	});

	/** Master Grid2 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid2 = Unilite.createGrid('sco150skrvGrid2', {
		store	: directMasterStore2,
		layout	: 'fit',
		region	: 'south',
		flex	: 0.6,
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer	: true,
			copiedRow		: false
		},
		tbar:[{
			fieldLabel	: '<t:message code="system.label.sales.classfication" default="구분"/>',
			name		: 'ACCNT_CODE',
			itemId		: 'ACCNT_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.create('Ext.data.Store', {
								id		: 'comboStore',
								fields	: ['name', 'value'],
								data	: [
									{name : '외상매출금'	, value: '11301'},
									{name : '선수금'	, value: '21310'}
								]
						  }),
			queryMode	: 'local',
			displayField: 'name',
			valueField	: 'value',
			allowBlank	: false,
			labelWidth	: 30,
			width		: 150,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					if(isLoad) {
						masterGrid2.getStore().loadStoreRecords();
					}
				}
			}
		}, '->', '->', '->', '->', '->', '->', '->', '->', '->', '->', '->', '->', '->', '->', '->', '->', '->', '->', '->', '->'],
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [
			{dataIndex: 'GUBUN'		, width: 100	, hidden: true},
			{dataIndex: 'GUBUN1'	, width: 100	, hidden: true},
			{dataIndex: 'AC_DATE'	, width: 100},
			{dataIndex: 'SLIP_NUM'	, width: 100},
			{dataIndex: 'SLIP_SEQ'	, width: 100},
			{dataIndex: 'REMARK'	, width: 200,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'DR_AMT_I'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'CR_AMT_I'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'JAN_AMT_I'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'EX_NUM'	, width: 100	, hidden: true},
			{dataIndex: 'JAN_DIVI'	, width: 100	, hidden: true}
		],
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(record.get('GUBUN') == '3') {
					cls = 'x-change-cell_dark';
				} else if(record.get('GUBUN') == '2'){
					cls = 'x-change-cell_normal';
				}
				return cls;
			}
		}
	});



	Unilite.Main({
		id			: 'sco150skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, masterGrid2, panelResult
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
			isLoad = false;

			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE', UniDate.get('today'));

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE', UniDate.get('today'));

			masterGrid2.down('#ACCNT_CODE').setValue('11300');
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()) {
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			masterGrid2.getStore().loadData({})
			this.fnInitBinding();
		}
	});
};
</script>