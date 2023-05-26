<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hrt700skrv_in"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	var fields		= createModelField(true);
	var columns		= createGridColumn(true);
	var gsMonthInfo;

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
			title	: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId	: 'search_panel1',
			layout	: {type: 'uniTable', columns: 1},
			items	: [{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				multiSelect	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '입사월',
				xtype: 'uniMonthfield',
				name: 'JOIN_YYYYMM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('JOIN_YYYYMM', newValue);
					}
				}
			},{
				fieldLabel		: '급여월',
				xtype			: 'uniMonthRangefield',
				startFieldName	: 'PAY_YYYYMM_FR',
				endFieldName	: 'PAY_YYYYMM_TO',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PAY_YYYYMM_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PAY_YYYYMM_TO',newValue);
					}
				}
			},
			Unilite.popup('Employee',{ 
				fieldLabel		: '사원',
				valueFieldName	: 'PERSON_NUMB',
				textFieldName	: 'NAME',
				validateBlank	: false,
				listeners		: {
					onSelected: {
						scope: this
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);
					}
				}
			})]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3
		},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			multiSelect	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '급여월',
			xtype			: 'uniMonthRangefield',
			startFieldName	: 'PAY_YYYYMM_FR',
			endFieldName	: 'PAY_YYYYMM_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PAY_YYYYMM_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PAY_YYYYMM_TO',newValue);
				}
			}
		},{
			fieldLabel: '입사월',
			xtype: 'uniMonthfield',
			name: 'JOIN_YYYYMM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('JOIN_YYYYMM', newValue);
					}
				}
		},
		Unilite.popup('Employee',{ 
			fieldLabel		: '사원',
			valueFieldName	: 'PERSON_NUMB',
			textFieldName	: 'NAME',
			validateBlank	: false,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);
				}
			}
		})]
	});

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hrt700skrv_inModel1', {
		fields: fields
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('s_hrt700skrv_inMasterStore1',{
		model	: 's_hrt700skrv_inModel1',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'uniDirect',
			api: {
				read	: 's_hrt700skrv_inService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			var monthArray = gsMonthInfo.split(',');
			
			if(!Ext.isEmpty(monthArray)) {
				param.monthArray = monthArray;
			}
			
			this.load({
				params : param
			});
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_hrt700skrv_inGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	:'center',
		uniOpt	:{
			expandLastColumn	: true,
			useRowNumberer		: true,
			useMultipleSorting	: true
		},
		columns	: columns,
		features: [{
			id   : 'detailGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		listeners: {
		}
	});



	Unilite.Main({
		id			: 's_hrt700skrv_inApp',
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
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('PAY_YYYYMM_FR', UniDate.get('today'));
			panelSearch.setValue('PAY_YYYYMM_TO', UniDate.get('today'));

			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('PAY_YYYYMM_FR', UniDate.get('today'));
			panelResult.setValue('PAY_YYYYMM_TO', UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('reset', true);

		},
		onQueryButtonDown: function() {
			// 꼼보 표시된 필수사항 체크로직
			if(!this.isValidSearchForm()){
				return false;
			} else {
				// 같은 년도만 조회 가능
				var frdate = panelSearch.getValue('PAY_YYYYMM_FR').getFullYear();
				var todate = panelSearch.getValue('PAY_YYYYMM_TO').getFullYear();
				
				if(frdate != todate) {
					Unilite.messageBox('같은 년도만 조회가 가능합니다.');
					return;
				}
				
				//그리드 컬럼명 조건에 맞게 재 조회하여 입력
				fields		= createModelField();
				columns		= createGridColumn();
				
				masterGrid.reconfigure(directMasterStore1, columns); // 컬럼 재정의
				masterGrid.getStore().loadStoreRecords();
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			
			this.fnInitBinding();

			fields		= createModelField();
			columns		= createGridColumn();
			
			masterGrid.reconfigure(directMasterStore1, columns); // 컬럼 재정의
			masterGrid.getStore().loadData({});
		}
	});
	// 조회한 개월수 세팅
	function fnSetInterval() {
		var param = Ext.getCmp('searchForm').getValues();

		//개월 수 구하기
		var stdDate		= Ext.getCmp('searchForm').getValue('PAY_YYYYMM_FR'); // date 형식으로 가져옴
		var startDate	= param.PAY_YYYYMM_FR; // string 값 그대로 가져옴
		var endDate		= param.PAY_YYYYMM_TO;
		var yearDiff	= Number(endDate.substring(0, 4)) - Number(startDate.substring(0, 4));
		var monthDiff	= Number(endDate.substring(4, 6)) - Number(startDate.substring(4, 6));
		var monthArr	= new Array();

		interval		= yearDiff * 12 + monthDiff;
		
		for (var i = 0; i <= interval; i++){
			monthArr.push(UniDate.getDbDateStr(UniDate.add(stdDate, {months: i})).substring(0,6));
		}
		
		gsMonthInfo = monthArr.join(',');
	}

	function fnGetInterval(bType) {
		if(bType)
			return gsMonthInfo.split(',');
		else
			return gsMonthInfo;
	}

	// 모델 필드 생성
	function createModelField(isInit) {
		var fields = [
			{name: 'COMP_CODE'			, text: '법인코드'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '사업장코드'			, type: 'string'},
			{name: 'DIV_NAME'			, text: '사업장'			, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사번'			, type: 'string'},
			{name: 'NAME'				, text: '성명'			, type: 'string'},
			{name: 'JOIN_DATE'			, text: '입사일'			, type: 'string'},
			{name: 'DEPT_CODE'			, text: '부서코드'			, type: 'string'},
			{name: 'DEPT_NAME'			, text: '부서'			, type: 'string'},
			{name: 'PENS_CUST_CODE'		, text: '운영사코드'			, type: 'string'},
			{name: 'PENS_CUST_NAME'		, text: '운영사'			, type: 'string'},
			{name: 'MIDWAY_DAYS'		, text: '산출근무일수'		, type: 'string'},
			{name: 'MIDWAY_JOIN_AMT'	, text: '누적액'			, type: 'uniPrice'},
			{name: 'BEFORE_AMT_RPI'		, text: '전기누적연금기준금'	, type: 'uniPrice'},
			{name: 'BEFORE_AMT_T05'		, text: '전기누적연금산출액'	, type: 'uniPrice'}
		];
		// 필드 초기세팅
		if(isInit) {
			fields.push(
				{name: 'AMT_RPI'	, text: '기준금'		, type: 'uniPrice'},
				{name: 'AMT_T05'	, text: '산출액'		, type: 'uniPrice'}
			);
		} else {
			fnSetInterval(); 				 // 조회하는 급여월 차이 Set 
			interval = fnGetInterval(true);  // 조회하는 급여월 차이 Get
			
			Ext.each(interval, function(item, index){
				fields.push({name: 'AMT_RPI_' + item	,text: '퇴직연금기준금'	,type:'uniPrice' });
				fields.push({name: 'AMT_T05_' + item	,text: '퇴직연금산출액'	,type:'uniPrice' });
			});
		}
		
		fields.push(
			{name: 'SUM_AMT_RPI'	, text: '기간별연금기준금'		, type: 'uniPrice'},
			{name: 'SUM_AMT_T05'	, text: '기간별연금산출액'		, type: 'uniPrice'},
			{name: 'TOT_AMT_RPI'	, text: '퇴직연금기준금'		, type: 'uniPrice'},
			{name: 'TOT_AMT_T05'	, text: '퇴직연금산출액'		, type: 'uniPrice'}
		);

		return fields;
	}
	// 그리드 컬럼 생성
	function createGridColumn(isInit) {
		//필드 생성
		var columns = [
			
			{dataIndex: 'COMP_CODE'			, text: '법인코드'			, width:  66	, hidden: true		, style: 'text-align: center'},
			{dataIndex: 'DIV_CODE'			, text: '사업장코드'			, width: 130	, hidden: true		, style: 'text-align: center'},
			{dataIndex: 'DIV_NAME'			, text: '사업장'			, width: 130						, style: 'text-align: center',
				summaryRenderer: function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{dataIndex: 'PERSON_NUMB'		, text: '사번'			, width: 100	, align: 'center'	, style: 'text-align: center'},
			{dataIndex: 'NAME'				, text: '성명'			, width: 100						, style: 'text-align: center'},
			{dataIndex: 'JOIN_DATE'			, text: '입사일'			, width:  90	, align: 'center'	, style: 'text-align: center'},
			{dataIndex: 'DEPT_CODE'			, text: '부서코드'			, width:  90	, hidden: true		, style: 'text-align: center'},
			{dataIndex: 'DEPT_NAME'			, text: '부서'			, width: 130						, style: 'text-align: center'},
			{dataIndex: 'PENS_CUST_CODE'	, text: '운용사코드'			, width:  90	, hidden: true		, style: 'text-align: center'},
			{dataIndex: 'PENS_CUST_NAME'	, text: '운용사'			, width: 100						, style: 'text-align: center'},
			
			{text: '중도입사자', 
				columns: [
						{dataIndex: 'MIDWAY_DAYS'		, text: '산출근무일수'	, width: 100	, align: 'center'	, style: 'text-align: center'},
						{dataIndex: 'MIDWAY_JOIN_AMT'	, text: '누적액'		, width: 110	, align: 'right'	, style: 'text-align: center'	, xtype:'uniNnumberColumn'	, summaryType:'sum'},
				]
			},
			
			{dataIndex: 'BEFORE_AMT_RPI'	, text: '전기누적연금기준금'	, width: 110	, align: 'right'	, style: 'text-align: center'	, xtype:'uniNnumberColumn'	, summaryType:'sum'},
			{dataIndex: 'BEFORE_AMT_T05'	, text: '전기누적연금산출액'	, width: 110	, align: 'right'	, style: 'text-align: center'	, xtype:'uniNnumberColumn'	, summaryType:'sum'}
		];
		if(isInit) {
			columns.push(
				{text: UniDate.getDbDateStr(UniDate.get('today')).substring(0,4) + '.' + UniDate.getDbDateStr(UniDate.get('today')).substring(4,6),
					columns: [ 
						{name: 'AMT_RPI'		, text: '기준금'		, width: 110	, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price	, summaryType:'sum'},
						{name: 'AMT_T05'		, text: '산출액'		, width: 110	, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price	, summaryType:'sum'}
					]
				}
			);
		} else {
			interval = fnGetInterval(true);
			
			Ext.each(interval, function(item, index){
				columns.push({text: item.substring(0,4) + '.' + item.substring(4,6),
					columns: [
						{dataIndex: 'AMT_RPI_' + item	, text: '기준금'		, width: 110	, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price	, style: 'text-align: center'	, summaryType:'sum'},
						{dataIndex: 'AMT_T05_' + item	, text: '산출액'		, width: 110	, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price	, style: 'text-align: center'	, summaryType:'sum'}
					]
				});
			});
		}

		columns.push( 
			{dataIndex: 'SUM_AMT_RPI'	, text: '기간별연금기준금'		, width: 110	, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price	, summaryType:'sum'},
			{dataIndex: 'SUM_AMT_T05'	, text: '기간별연금산출액'		, width: 110	, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price	, summaryType:'sum'}
		);
		columns.push(
			{text: "총계",
				columns: [ 
					{dataIndex: 'TOT_AMT_RPI'	, text: '퇴직연금기준금'		, width: 110	, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price	, summaryType:'sum'},
					{dataIndex: 'TOT_AMT_T05'	, text: '퇴직연금산출액'		, width: 110	, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price	, summaryType:'sum'}
				]
			}
		);
		console.log(columns);
		return columns;
	}
};
</script>