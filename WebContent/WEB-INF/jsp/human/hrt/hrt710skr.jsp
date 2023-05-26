<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hrt710skr"  >
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
			Unilite.popup('DEPT',{
				fieldLabel		: '부서',
				valueFieldName	: 'DEPT_CODE_FR',
				textFieldName	: 'DEPT_NAME_FR',
				validateBlank	: false,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
					},
					'onValueFieldChange': function(field, newValue, oldValue  ){
						panelResult.setValue('DEPT_CODE_FR', newValue);
					},
					'onTextFieldChange':  function( field, newValue, oldValue  ){
						panelResult.setValue('DEPT_NAME_FR', newValue);
					}
				}
			}),
			Unilite.popup('DEPT', {
				fieldLabel		: '~',
				valueFieldName	: 'DEPT_CODE_TO',
				textFieldName	: 'DEPT_NAME_TO',
				validateBlank	: false,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
//						panelResult.setValue('DEPT_CODE2', '');
//						panelResult.setValue('DEPT_NAME2', '');
					},
					'onValueFieldChange': function(field, newValue, oldValue  ){
						panelResult.setValue('DEPT_CODE_TO', newValue);
					},
					'onTextFieldChange':  function( field, newValue, oldValue  ){
						panelResult.setValue('DEPT_NAME_TO', newValue);
					}
				}  
			}),
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
//						panelResult.setValue('PERSON_NUMB', '');
//						panelResult.setValue('NAME', '');
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
		layout	: {type : 'uniTable', columns : 4
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
		},
		Unilite.popup('DEPT',{
			fieldLabel		: '부서',
			valueFieldName	: 'DEPT_CODE_FR',
			textFieldName	: 'DEPT_NAME_FR',
			validateBlank	: false,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
//					panelResult.setValue('DEPT_CODE1', '');
//					panelResult.setValue('DEPT_NAME1', '');
				},
				'onValueFieldChange': function(field, newValue, oldValue  ){
					panelSearch.setValue('DEPT_CODE_FR', newValue);
				},
				'onTextFieldChange':  function( field, newValue, oldValue  ){
					panelSearch.setValue('DEPT_NAME_FR', newValue);
				}
			}
		}),
		Unilite.popup('DEPT', {
			fieldLabel		: '~',
			labelWidth		: 15,
			valueFieldName	: 'DEPT_CODE_TO',
			textFieldName	: 'DEPT_NAME_TO',
			validateBlank	: false,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
//					panelResult.setValue('DEPT_CODE2', '');
//					panelResult.setValue('DEPT_NAME2', '');
				},
				'onValueFieldChange': function(field, newValue, oldValue  ){
					panelSearch.setValue('DEPT_CODE_TO', newValue);
				},
				'onTextFieldChange':  function( field, newValue, oldValue  ){
					panelSearch.setValue('DEPT_NAME_TO', newValue);
				}
			}  
		}),
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
//					panelResult.setValue('PERSON_NUMB', '');
//					panelResult.setValue('NAME', '');
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



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hrt710skrService.selectList'
		}
	}); 

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hrt710skrModel1', {
		fields: fields
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('hrt710skrMasterStore1',{
		model	: 'hrt710skrModel1',
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
				read	: 'hrt710skrService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			var monthArray = gsMonthInfo.split(',');
			
			if(!Ext.isEmpty(monthArray)) {
				param.monthArray = monthArray;
			}
			
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('hrt710skrGrid1', {
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
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id   : 'detailGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		listeners: {
			selectionchange: function(grid, selNodes ){
			}
		}
	});



	Unilite.Main({
		id			: 'hrt710skrApp',
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
			} else {
				//그리드 컬럼명 조건에 맞게 재 조회하여 입력
				fields		= createModelField();
				columns		= createGridColumn();
			
				//var newColumns = createGridColumn();
				//masterGrid.setConfig('columns',newColumns);
				masterGrid.reconfigure(directMasterStore1, columns);
				masterGrid.getStore().loadStoreRecords();
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			
			masterGrid.getStore().loadData({});
			
			fields		= createModelField();
			columns		= createGridColumn();
			
			masterGrid.reconfigure(directMasterStore1, columns);
			
			this.fnInitBinding();
		}
	});
	
	function fnSetInterval() {
		var param = Ext.getCmp('searchForm').getValues();
		
		//개월 수 구하기
		var stdDate		= Ext.getCmp('searchForm').getValue('PAY_YYYYMM_FR');
		var startDate	= param.PAY_YYYYMM_FR;
		var endDate		= param.PAY_YYYYMM_TO;
		var startYear	= parseInt(UniDate.getDbDateStr(param.PAY_YYYYMM_FR).substring(0, 4));
		var startMonth	= parseInt(UniDate.getDbDateStr(param.PAY_YYYYMM_TO).substring(4, 6));
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
			{name: 'COMP_CODE'		, text: '법인코드'			, type: 'string'},
			{name: 'DIV_CODE'		, text: '사업장코드'			, type: 'string'},
			{name: 'DIV_NAME'		, text: '사업장'			, type: 'string'},
			{name: 'PERSON_NUMB'	, text: '사번'			, type: 'string'},
			{name: 'NAME'			, text: '성명'			, type: 'string'},
			{name: 'JOIN_DATE'		, text: '입사일'			, type: 'string'},
			{name: 'DEPT_CODE'		, text: '부서코드'			, type: 'string'},
			{name: 'DEPT_NAME'		, text: '부서'			, type: 'string'},
			{name: 'PENS_CUST_CODE'	, text: '운영사코드'			, type: 'string'},
			{name: 'PENS_CUST_NAME'	, text: '운영사'			, type: 'string'},
			{name: 'TOT_AMT_T05'	, text: '누적퇴직연금납입액'	, type: 'uniPrice'},
			{name: 'SUM_AMT_RPI'	, text: '기간별연금기준금'		, type: 'uniPrice'},
			{name: 'SUM_AMT_T05'	, text: '기간별연금납입액'		, type: 'uniPrice'}
		];
		if(isInit) {
			fields.push(
				{name: 'AMT_RPI'	, text: '기준금'		, type: 'uniPrice'},
				{name: 'AMT_T05'	, text: '납입액'		, type: 'uniPrice'}
			);
		} else {
			fnSetInterval();
			
			interval = fnGetInterval(true);
			
			Ext.each(interval, function(item, index){
				fields.push({name: 'AMT_RPI_' + item	,text: '기준금'	,type:'uniPrice' });
				fields.push({name: 'AMT_T05_' + item	,text: '납입액'	,type:'uniPrice' });
			});
//			for (var i = 0; i <= interval; i++){
//				fields.push(
//					{name: 'NAME_B' + i		, text: '퇴직기준금'		, type: 'uniPrice'},
//					{name: 'NAME_N' + i		, text: '퇴직연금 납입액'	, type: 'uniPrice'}
//				);
//			}
		}
		console.log(fields);
		return fields;
	}
	// 그리드 컬럼 생성
	function createGridColumn(isInit) {
		//필드 생성
		var columns = [
//			{xtype: 'rownumberer',	sortable:false,	width: 35,	align:'center  !important',	resizable: true},
			
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
			{dataIndex: 'TOT_AMT_T05'		, text: '누적퇴직연금납입액'	, width: 110	, align: 'right'	, style: 'text-align: center'	, xtype:'uniNnumberColumn'	, summaryType:'sum'},
			{dataIndex: 'SUM_AMT_RPI'		, text: '기간별연금기준금'		, width: 110	, align: 'right'	, style: 'text-align: center'	, xtype:'uniNnumberColumn'	, summaryType:'sum'},
			{dataIndex: 'SUM_AMT_T05'		, text: '기간별연금납입액'		, width: 110	, align: 'right'	, style: 'text-align: center'	, xtype:'uniNnumberColumn'	, summaryType:'sum'}
		];
		if(isInit) {
			columns.push(
				{text: UniDate.getDbDateStr(UniDate.get('today')).substring(0,4) + '.' + UniDate.getDbDateStr(UniDate.get('today')).substring(4,6),
					columns: [ 
						{name: 'AMT_RPI'		, text: '기준금'		, width: 110	, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price	, summaryType:'sum'},
						{name: 'AMT_T05'		, text: '납입액'		, width: 110	, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price	, summaryType:'sum'}
					]
				}
			);
		} else {
			interval = fnGetInterval(true);
			
			Ext.each(interval, function(item, index){
				columns.push({text: item.substring(0,4) + '.' + item.substring(4,6),
					columns: [
						{dataIndex: 'AMT_RPI_' + item	, text: '기준금'		, width: 110	, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price	, style: 'text-align: center'	, summaryType:'sum'},
						{dataIndex: 'AMT_T05_' + item	, text: '납입액'		, width: 110	, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price	, style: 'text-align: center'	, summaryType:'sum'}
					]
				});
			});
//			for (var i = 0; i <= interval; i++){
//				columns.push(
//					{text: UniDate.getDbDateStr(UniDate.add(startDate, {months: i})).substring(0,4) + '.' + UniDate.getDbDateStr(UniDate.add(startDate, {months: i})).substring(4,6),
//						columns: [ 
//							{dataIndex: 'NAME_B' + i	, text: '퇴직기준금',	  width: 120  , style: 'text-align: center'   , align: 'right'	, xtype:'uniNnumberColumn'  , format: UniFormat.Price},
//							{dataIndex: 'NAME_N' + i	, text: '퇴직연금 납입액',	  width: 120  , style: 'text-align: center'   , align: 'right'	, xtype:'uniNnumberColumn'  , format: UniFormat.Price}
//						]
//					}
//				);
//			}
		}
		console.log(columns);
		return columns;
	}
};
</script>